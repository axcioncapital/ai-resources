# Work Loop v2 dispatcher — what to add from the Supervisor context

**Date:** 2026-08-06  
**Status:** Recommendation only. This document does not authorize implementation or production use.

## Decision

The context material contains two ideas that would materially improve the current dispatcher:

1. **Safe operator interruption and recovery.**
2. **A small machine-readable outcome and notification boundary.**

A third idea—**context-aware session rollover**—is worth preserving as a later option, but there is
not enough evidence to implement it now.

The rest of the proposed Supervisor should not be added to the dispatcher. In particular, the
dispatcher should not acquire a second project-state system, decide whether tests or review findings
are valid, decide that work is complete, create worktrees autonomously, or become a Visual Studio
Code application. Those duties either already exist elsewhere or would turn a transport mechanism
into a fourth decision-maker.

## Why the boundary matters

Work Loop v2 has three decision-making actors:

- **Codex** frames the next unit and assesses returned evidence.
- **Claude** verifies repository reality, implements, tests, records evidence, and commits.
- **The operator** owns priorities, scope, risk, and hard-to-reverse decisions.

The dispatcher is a **courier** between them. It may carry a turn already written in
`logs/work-loop/{task-id}.md`, validate that the transport completed safely, and stop visibly. It
must not decide which work should happen, whether evidence is persuasive, whether a review finding
is supported, or whether a task should close.

A useful test is:

> If removing the dispatcher would change a decision, the dispatcher was doing more than transport.

This boundary comes from
`plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`, especially the courier clause in
§ 4. The state file and repository remain authoritative; terminal text, notifications, dashboards,
and dispatcher exit codes are operational aids only.

## What the current dispatcher already does

The existing spike at `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` already provides
most of the safe transport capability proposed in the context material:

- receives an exact checkout path and task id;
- validates task identity and `turn:`;
- launches one actor at a time;
- routes routine Codex ↔ Claude turns;
- stops at `turn: operator`;
- enforces a per-actor timeout and absolute hop limit;
- retries one pre-edit failure only when repository state is provably unchanged;
- refuses staged foreign work, out-of-scope working-tree changes, Git locks, and in-progress Git
  operations;
- detects missing transitions, unexpected changes, and uncommitted Claude handbacks;
- validates the two terminal state-file shapes;
- writes a run log and one raw actor-output capture per hop;
- re-derives truth from the state file and Git after every actor exit.

The dispatcher has therefore already implemented the useful core of:

- process launch;
- exact-task routing;
- bounded retries and timeouts;
- structural handoff validation;
- fresh-session continuation;
- execution logging;
- Codex review routing;
- operator escalation through `turn: operator`.

The Supervisor proposal should not cause those capabilities to be rebuilt under new names.

## Addition 1 — safe operator interruption and recovery

### The problem

The context material requires a visible operator stop control and safe recovery from interrupted
sessions. The current dispatcher has timeout-driven termination, but its manual signal handling is
not complete.

Its signal trap is currently:

```bash
trap 'release_lock' EXIT INT TERM
```

This releases the dispatcher lock, but it does not explicitly:

- terminate the active actor;
- wait for the actor and its descendants to exit;
- stop the dispatcher from continuing;
- prevent a subsequent actor launch;
- classify the run as interrupted;
- record the recovery state.

A simulated long-running hop was started and the dispatcher process was sent `SIGTERM`. Two seconds
later the dispatcher was still alive. This proves a real controller gap; it is not merely a
hypothetical feature request. The probe did not establish whether every descendant process would
remain alive, so the implementation must test that separately rather than assume either outcome.

### Required behavior

On `SIGINT` or `SIGTERM`, the dispatcher should:

1. Mark shutdown as requested so the loop cannot launch another actor.
2. Terminate the active actor process group or otherwise cover the actor and all descendants.
3. Allow a short grace period, then force termination if anything remains.
4. Wait for the process tree to be reaped.
5. Re-read the state file and repository without modifying them.
6. Record that the run was interrupted, including the task, actor, hop, state-file path, final
   `turn:`, and run-log path.
7. Release the lock exactly once.
8. Exit non-zero with an unambiguous interrupted outcome.

An interrupted actor must **not** be retried automatically. Interruption may have occurred after an
unobserved partial effect, so the safe next step is inspection.

### Acceptance evidence

Tests should demonstrate all of the following:

- `SIGINT` during a long simulated actor terminates the dispatcher within a bounded time.
- `SIGTERM` does the same.
- The actor and its descendants are no longer running.
- No next actor is launched.
- The lock is released.
- The state file is not silently edited or reverted.
- A partial repository effect is preserved for inspection, not retried.
- The terminal record identifies the task and recoverable next action.
- Sending a signal when no actor is active also exits cleanly.

This is the highest-value addition because it closes a measured safety defect without changing the
Work Loop's semantics.

## Addition 2 — structured terminal outcome and notification boundary

### The problem

The dispatcher already writes detailed logs and prints useful stop messages. However, an operator
running several loops still has to watch terminals or manually inspect them to learn that:

- a task closed;
- an operator decision is waiting;
- a permission or handback problem stopped a run;
- a timeout or interruption occurred.

That remaining observation burden is directly related to the original “babysitting” problem.

The answer is not a dashboard, daemon, or new workflow state machine. The smallest useful addition
is one machine-readable terminal event that an optional observer can turn into a desktop or Codex
notification.

### Required behavior

When a dispatcher invocation ends, it should emit exactly one structured outcome containing:

- run id;
- task id;
- checkout;
- state-file path;
- final known `turn:`;
- actor and hop, when applicable;
- dispatcher exit code and named reason;
- outcome kind: `closed`, `operator_question`, `failed`, `timed_out`, or `interrupted`;
- run-log and actor-output paths;
- timestamp.

The exact encoding may be JSON or JSON Lines. It should be written to standard output and/or the
existing run evidence—not to a second semantic state file.

An optional observer may translate that event into a desktop notification. The observer must not:

- choose the next actor;
- answer an operator question;
- approve a permission;
- edit the task-state file;
- retry a failed or interrupted actor;
- treat its own notification as evidence.

### Acceptance evidence

Tests should demonstrate that:

- every terminal path emits exactly one event;
- a closed task and an operator question are distinguishable;
- every non-zero dispatcher exit has a structured outcome;
- the event agrees with a fresh read of the state file;
- duplicate invocation of an already-terminal task launches no actor;
- event or notification failure cannot change the repository or continue the loop;
- existing human-readable output remains usable.

This addition materially reduces watching while preserving the dispatcher as transport only.

## Preserve for later — context-aware session rollover

The context material proposes monitoring context usage, waiting for a safe checkpoint, asking the
actor to wrap, and starting a fresh session before reliability deteriorates.

The problem is plausible, but it has not been observed in the dispatcher evidence:

- dispatcher actors are already launched as fresh one-shot sessions;
- the state file and Git already support fresh-session continuation;
- a recent Claude dispatcher run completed 26 turns successfully and reported its context window in
  the final structured output;
- current captures expose useful token or context information mainly at completion, not as a proven
  reliable live control signal;
- no recorded dispatcher stop has been attributed to context exhaustion.

The proposed 75–80% threshold is therefore not justified. Adding rollover now would introduce
session intervention, checkpoint selection, partial-effect handling, and new failure modes without
an observed failure to solve.

### Trigger for reconsideration

Reopen this idea only when run evidence shows one of the following:

- an actor fails or times out because its context is exhausted;
- compaction repeatedly causes an inaccurate or incomplete handback;
- long units repeatedly need manual session replacement;
- both products expose reliable live context telemetry that can be consumed without guessing.

If triggered, the rollover design must still:

- hand back through the existing Work Loop state file;
- use a safe repository checkpoint, not token percentage alone;
- start from repository truth rather than hidden transcript memory;
- never create a second handoff document;
- never let the dispatcher invent a new turn or completion decision.

This capability would probably belong in an actor adapter or a thin supervisor above the courier,
not in the dispatcher's semantic core.

## Ideas that should not be added

### A second `.project-state/` directory

Reject the proposed `current-task.md`, `workflow-state.json`, `handoffs/`, `reviews/`, and
`escalation-log.md` structure.

The Work Loop state file already carries the task's current truth; Git carries repository history;
dispatcher run logs carry operational evidence. A second directory would create competing answers
to “what is current?” and reproduce the stale-handoff problem the Work Loop was designed to avoid.

### A second execution ledger

Do not introduce SQLite or another durable ledger for the current dispatcher. Existing run logs
already contain the operational information required to reconstruct a run. Improve their terminal
event format if machine consumption is needed.

A database becomes worth considering only if a future multi-process service needs querying,
retention, or crash-safe queue semantics that files demonstrably cannot provide.

### Automatic test and handoff truth decisions

The dispatcher may verify structural facts:

- which paths changed;
- whether Git moved;
- whether a commit exists;
- whether a command exited;
- whether the state file changed shape.

It must not decide:

- whether the right tests were selected;
- whether test evidence proves correctness;
- whether a Codex finding is valid;
- whether Claude's correction is good enough;
- whether the task is complete.

Those are repository and progression judgments owned by Claude and Codex.

### Automatic worktree selection, creation, landing, and teardown

The dispatcher should continue to receive an exact checkout and task. Worktree creation is preceded
by a file-ownership decision; landing may expose content conflicts; destructive cleanup requires
liveness checks. These are governed by `docs/parallel-sessions-playbook.md` and include operator
gates.

A separate operator-invoked launcher may automate mechanical steps after the operator supplies the
approved task, branch, worktree, and file boundary. The dispatcher itself should not choose them.

### A Visual Studio Code extension

Do not build an extension yet. Direct CLI process control is already working, testable, and more
auditable. The structured terminal event recommended above creates a clean integration seam if a UI
is justified later.

Build a UI only after repeated real use shows that terminal invocation and notifications are
insufficient.

### A full workflow state machine

States such as `PREPARING_WORKSPACE`, `PRIMING`, `WORKING`, `REVIEWING`, and `VERIFYING` may be useful
display labels, but they must not become a second authoritative workflow.

The authoritative semantic state remains `turn:` plus the task-state file content. The dispatcher
already has operational exit codes for failures. A UI may derive a temporary display label from
current process and repository facts, but removing that UI must not change any decision.

### Hidden session resume as the default

Do not make product conversation IDs the continuity mechanism. They are useful diagnostic metadata,
but the Work Loop deliberately proves that a fresh session can continue from the state file and Git.
Resuming hidden conversational state would make recovery harder to inspect and reproduce.

## Existing prerequisites that remain higher priority

The current production-readiness discovery has identified two separate issues that must be settled
before unattended parallel use:

1. Headless Claude sessions need correct session identity and file-scope initialization.
2. The tracked `logs/friction-log.md` writer creates an ambient co-edit in parallel worktrees.

Those findings are currently recorded in
`logs/work-loop/work-loop-v2-production-readiness-policy.md`, which is still at `turn: codex`.
Its recommendations are therefore evidence awaiting assessment, not approved policy.

The Supervisor context does not replace those prerequisites.

## Recommended order

1. Assess and settle the existing production-readiness policy.
2. Add safe signal-driven interruption and recovery.
3. Add the structured terminal outcome.
4. Connect an optional notification-only observer.
5. Run several real tasks and record failure and operator-attention evidence.
6. Reconsider context-aware rollover only if those runs produce its trigger.
7. Reconsider a UI or persistent service only if the minimal CLI shape proves insufficient.

## Bottom line

The valuable lesson from the Supervisor context is not “build a supervisor.” It is:

> Make the existing courier safer to stop and easier to observe.

That closes a measured safety gap and reduces the remaining need to watch terminals. The broader
proposal would add duplicate state, premature infrastructure, and semantic decisions that do not
belong in the dispatcher.
