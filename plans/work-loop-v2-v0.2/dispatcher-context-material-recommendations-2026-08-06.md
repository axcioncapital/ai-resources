# Work Loop v2 dispatcher — what to add from the Supervisor context

**Date:** 2026-08-06  
**Status:** Recommendation only. This document does not authorize implementation or production use.

## Decision

The target experience is:

> The operator describes the task in Codex, invokes one command, leaves the computer for roughly
> 40 minutes, and returns to either completed work or one clearly explained decision that requires
> operator judgment.

The current dispatcher is a strong transport core, but this experience requires a bounded
supervisory layer around it. The plan should include:

1. **One-command intake and launch from Codex.**
2. **Automatic routine Claude ↔ Codex cycling.**
3. **A total unattended-run time, hop, and cost budget.**
4. **Clean checkpoints before deadlines and between actors.**
5. **Fresh-session and context-window continuity through the state file and Git.**
6. **Mechanical preparation of an isolated worktree after the task boundary is approved.**
7. **A small derived operational state model for monitoring.**
8. **Safe operator interruption and recovery.**
9. **Machine-readable outcomes and operator notifications.**
10. **A final return report.**

This is a bounded unattended Work Loop Supervisor, not unrestricted autonomy. It may carry routine
turns and manage processes inside a task the operator approved. It must still stop for scope,
architecture, risk, permissions, destructive recovery, external effects, merge conflicts, or any
other decision owned by the operator.

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

The Supervisor proposal should extend this core rather than rebuild those capabilities under new
names.

## Intended unattended run

The normal path should be:

1. The operator writes the objective in Codex.
2. The operator invokes one command, including an unattended time budget.
3. Codex prepares the bounded brief, exact task id, allowed paths, completion conditions, and stop
   conditions.
4. The launcher performs preflight checks and prepares an isolated worktree.
5. The supervisor launches Claude in that worktree.
6. Claude verifies, works, tests, records evidence, commits, and hands back.
7. The supervisor launches Codex to assess the result.
8. Codex closes, continues with the next bounded unit, corrects once, or sets `turn: operator`.
9. Routine Claude ↔ Codex turns continue while the approved task and run budgets permit.
10. The supervisor stops at completion, a deadline checkpoint, a technical failure, or an
    operator-owned decision and sends a notification.

The operator may observe the run, but the run must not depend on the operator watching or moving
prompts between products.

## Addition 1 — one-command intake and launch

### Required behavior

Codex should expose one operator-facing command whose meaning is approximately:

> Prepare this request as one bounded Work Loop task and run it unattended for up to the supplied
> duration within the approved safety policy.

The command should:

- turn the current operator request into the canonical Work Loop brief;
- create or identify the exact task-state file;
- derive an exact task id;
- record the approved objective, boundaries, required evidence, stop conditions, and allowed paths;
- accept a total run duration and optional cost or turn ceiling;
- run preflight checks;
- prepare the isolated execution location;
- start the supervisor with the exact task and checkout;
- return the run id and where progress can be observed.

Invoking the command is approval to carry routine turns only within those written limits. It is not
approval for merging, deployment, destructive recovery, external communication, new credentials,
new infrastructure, or a material scope change.

### Acceptance evidence

- One command starts a fixture task without manual prompt copying.
- The launched task id and checkout exactly match the prepared brief.
- A malformed, ambiguous, consequential, or unbounded request does not start a run.
- Starting fails safely if the repository or worktree preflight fails.
- No second task-state or handoff system is created.

## Addition 2 — unattended Claude ↔ Codex cycling

The supervisor should support a deliberately approved full-loop mode, not only one-hop courier
mode.

After each actor exits, it should re-read the state file and repository and:

- launch Claude only when the file says `turn: claude`;
- launch Codex only when the file says `turn: codex`;
- stop without another launch when the file says `turn: operator`;
- stop on a malformed file, illegal transition, unexpected effect, or uncommitted handback;
- continue only while the task and global run budgets permit.

The supervisor does not decide whether the next turn exists. Each actor writes that decision into
the existing state file. The supervisor only carries it.

### Acceptance evidence

- A live or appropriately isolated proof completes Claude → Codex → Claude → Codex without operator
  transport.
- A Codex close verdict reaches Claude and finishes at `turn: operator`.
- A Codex continuation opens the next bounded unit and returns to Claude.
- A correction remains frozen to its named findings.
- Every operator stop produces zero subsequent actor launches.

## Addition 3 — total unattended-run budgets

The current per-actor timeout and hop limit should be supplemented by a total run envelope.

At launch, the supervisor should receive:

- an absolute run deadline or total duration;
- a maximum number of actor hops;
- a maximum number of correction or continuation transitions already permitted by the Work Loop;
- an optional model-cost or turn ceiling where reliable telemetry exists;
- a reserved checkpoint margin before the hard deadline.

For a 40-minute run, an example policy would be:

- no new substantial unit begins once only the checkpoint margin remains;
- the current actor is told the absolute deadline and expected handback margin;
- the supervisor stops at the next valid checkpoint;
- a hard deadline still terminates safely if cooperative handback fails.

Budget exhaustion is not task completion. It means the work stops in a resumable state and reports
what remains.

### Acceptance evidence

- The supervisor never starts a new actor after the global deadline.
- Per-actor timeouts cannot make the total run silently exceed its hard bound.
- The checkpoint margin is observable in the actor's assignment.
- Reaching a hop, time, or cost ceiling reports `budget_exhausted`, not `completed`.
- Repository and state-file truth are preserved for a later resume.

## Addition 4 — automatic checkpoints

Every actor handback should be treated as a durable checkpoint. Before yielding, the actor should
leave:

- the latest material result in the canonical state file;
- the exact next actor or operator turn;
- evidence and limitations needed by the next actor;
- a commit where the Work Loop contract requires Claude to commit;
- no unstated dependency on the previous conversation.

When the global deadline approaches, the current actor should prefer handing back the smallest
coherent result rather than starting another substantial step.

The supervisor validates the checkpoint structurally. Claude and Codex remain responsible for the
meaning and adequacy of the evidence.

### Acceptance evidence

- A fresh actor can continue from the state file and Git without the previous transcript.
- A deadline checkpoint does not claim unfinished work is complete.
- An incomplete or uncommitted handback stops for inspection rather than being retried.
- No separate wrap document is created.

## Addition 5 — fresh-session and context-window continuity

The system should obtain continuity primarily by starting fresh actors from repository truth, not by
preserving one ever-growing chat.

At every routine handoff:

- the state file carries the current task truth;
- Git carries repository history and the committed implementation;
- the next actor receives the immediate brief, exact task id, governing sources, and remaining run
  budget;
- old transcripts are diagnostic evidence, not required working memory.

This design resets most context pressure naturally because Claude and Codex can start fresh on their
respective turns.

### Context-aware rollover inside one actor

One long Claude unit may still approach its own context limit. The supervisor should preserve an
extension point for cooperative rollover, but it should not guess from an arbitrary 75–80% token
threshold.

Rollover becomes justified when either:

- reliable live product telemetry identifies real remaining context;
- the actor reports that compaction or context pressure threatens the handback;
- repeated run evidence shows context-related timeout, no-transition, or incomplete-handback
  failures.

When triggered, rollover should ask the actor to reach a safe repository checkpoint, update the
existing state file, and end. A fresh actor then continues from that checkpoint. If the current
process interface cannot accept a cooperative checkpoint request, use bounded units and deadlines
until an SDK or app-server control surface is justified; do not simulate continuity by copying a
full transcript.

### Acceptance evidence

- Several actor sessions can continue the same task from the canonical state and Git.
- Completed work is not repeated after a fresh-session transition.
- A rollover leaves no second handoff artifact.
- Context percentage alone never causes an unsafe mid-edit termination.
- Hidden conversation resume is optional, never the sole recovery mechanism.

## Addition 6 — isolated worktree preparation

Unattended implementation should normally run in a dedicated worktree rather than directly in the
main checkout.

The launcher may mechanically:

- confirm that the task and allowed-path boundary are explicit;
- confirm that the integration target is safe;
- create a named branch and linked worktree;
- launch both Claude and Codex in that exact worktree;
- register the task, worktree, branch, and run id in operational evidence;
- prevent another supervisor from using the same task/worktree pair.

The launcher must not independently decide file ownership or resolve overlap with another active
task. Those are admission decisions. It also must not automatically merge, delete the branch, or
remove the worktree when the unattended run ends.

### Acceptance evidence

- Both actors' kernel working directories are the intended worktree.
- The main checkout remains unchanged by the run.
- A second supervisor cannot claim the same task/worktree.
- A file-ownership conflict prevents launch.
- Completion leaves the branch and worktree available for operator inspection.
- Landing and teardown remain separate, operator-gated actions.

## Addition 7 — derived operational state

The supervisor needs a small process-lifecycle model so the operator and notification layer can
understand what it is doing. Suggested derived states are:

- `preparing`;
- `running_claude`;
- `running_codex`;
- `checkpointing`;
- `waiting_for_operator`;
- `completed`;
- `failed`;
- `timed_out`;
- `budget_exhausted`;
- `interrupted`.

These labels describe the supervisor, not the task's meaning. They should be derived from live
process state, the latest state-file read, and the terminal outcome. They must not replace `turn:` or
become a second semantic workflow.

### Acceptance evidence

- Every displayed state can be re-derived from process and repository facts.
- Removing the operational-state display changes no Work Loop decision.
- `completed`, `waiting_for_operator`, and `failed` cannot be confused.
- Restart does not trust a stale operational label over the state file and Git.

## Addition 8 — safe operator interruption and recovery

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

## Addition 9 — structured terminal outcome and notification boundary

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

## Addition 10 — final return report

When the run ends, Codex should present a concise report in the operator's original Codex task. It
should say:

- whether the task completed, stopped at a checkpoint, failed, timed out, was interrupted, or needs
  an operator decision;
- what outcome was achieved;
- which worktree, branch, commits, and material paths contain the work;
- what Claude reports it tested and what Codex assessed;
- what remains incomplete or limited;
- why the supervisor stopped;
- the exact next action for the operator;
- where the canonical state file and operational logs live.

The report must distinguish repository facts from model claims. “Claude reports these tests passed”
is different from “the supervisor observed a zero exit code,” and neither automatically means Codex
accepted the evidence.

If the operator was away when the run ended, the same report should remain available when they
return. A notification may link to it, but notification delivery is not part of task correctness.

### Acceptance evidence

- Every terminal outcome produces one operator-facing report.
- The report distinguishes completed, operator decision, technical failure, budget exhaustion, and
  interruption.
- Commit and path claims agree with Git and the final state file.
- The report never claims a merge, deployment, or adoption that did not occur.
- The exact next action is present even when the task did not complete.

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

### Autonomous worktree decisions, landing, and teardown

The one-command launcher may mechanically create a worktree as described in Addition 6, but only
after Codex has prepared an explicit task and path boundary under an approved operating policy.

It must not independently choose overlapping file ownership, resolve a content conflict, merge the
result, delete a live worktree, or remove a branch. Those actions are governed by
`docs/parallel-sessions-playbook.md` and include operator gates.

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
2. Harden the dispatcher with safe interruption, a total run budget, and structured terminal
   outcomes.
3. Add the one-command Codex intake and launch path.
4. Add mechanical isolated-worktree preparation behind the existing admission and file-ownership
   gates.
5. Prove full unattended Claude ↔ Codex cycling with checkpoints and fresh-session continuation.
6. Add the derived operational state, notification observer, and final return report.
7. Run several real 40-minute tasks and record completion, interruption, escalation, context, cost,
   and operator-attention evidence.
8. Add cooperative context rollover only if live telemetry or observed failures justify it.
9. Reconsider a Visual Studio Code UI or persistent service only if the CLI, Codex task, and
   notifications prove insufficient.

## Bottom line

The plan should build a bounded unattended supervisor around the proven dispatcher:

> One Codex command prepares the task, starts isolated execution, carries routine Claude ↔ Codex
> turns for the approved time, checkpoints safely, and returns either completed work or one clear
> operator decision.

The supervisor should manage sessions, budgets, worktree mechanics, observation, notifications, and
safe recovery. It should not manage strategy, evidence judgment, risk acceptance, merging,
deployment, or any other operator-owned decision.
