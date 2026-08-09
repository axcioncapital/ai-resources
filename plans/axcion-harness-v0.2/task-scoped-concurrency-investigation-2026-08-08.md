# Task-scoped concurrency for Work Loop v2 — MVP investigation

**Date:** 2026-08-08  
**Status:** Focused research recommendation; non-governing until adopted by the operator  
**Scope:** The attached task-scoped isolation / single-writer proposal, current Work Loop v2 and dispatcher evidence, and the repository's wider concurrent-session machinery  
**Governing context:** Read this as a focused addendum to [`mvp-plan.md`](mvp-plan.md), not as a second Harness v0.2 plan.

## Decision in one line

Adopt **task identity as the ownership boundary** and add **two small dispatcher leases when concurrent dispatched tasks enter scope**—one lease for `repository + task`, one for the physical checkout—but do not add a state-writer service, automatic worktree manager, structural-file lock system, registry, or broad log migration to the attended MVP.

The proposal has a real use case. Its most valuable contribution is not a new concurrency platform. It exposes one precise gap in the current spike: the existing lock is keyed by `checkout + task`, so it blocks only an identical pair. It does not block the same task in two worktrees, and it does not block two tasks in one checkout. Two leases close those two holes with a small change to an already-proven mechanism.

Everything else should follow evidence. Work Loop v2 already has persistent task identity, one state file, explicit turns, task-to-checkout binding, state hashing, transition validation, Git checks, worktree policy, and a dispatcher that launches one actor at a time. Building parallel state-writing and worktree-management systems now would replace or duplicate those contracts before the attended Harness v0.2 vertical slice is adopted.

## What problem is real

There are three different concurrency problems. They should not be solved as one system.

| Problem | Current evidence | MVP response |
|---|---|---|
| Two actor runs mutate one Work Loop task | The dispatcher serializes one exact `checkout + task`, but the same task can still be launched in another linked worktree. | Add a short-lived `repository + task` lease around an active dispatch run. |
| Two tasks mutate one physical checkout | The dispatcher lock includes the task ID, so two different tasks can both acquire different locks for the same checkout. Dirty-tree checks reduce the window but do not prevent a clean-start race. | Add a short-lived checkout-writer lease independent of task ID. |
| Independent tasks edit shared repository files or ambient hooks write to every branch | The two-worktree proof isolated working trees but explicitly left `logs/friction-log.md`, file ownership, landing and session identity unresolved. | Keep worktrees conditional; use existing per-task allowlists and the existing serial landing policy. Quarantine only the proven ambient writer for dispatched runs. Do not build a global manager. |

The repository has already experienced the underlying class. The 2026-06-05 diagnostics records about five collisions in eleven days and distinguishes same-checkout lost updates from shared bookkeeping conflicts across worktrees ([collision report](../../audits/2026-06-05-concurrent-session-collision-diagnostics-fix.md), lines 14–18 and 59–67). Worktrees are therefore justified for real parallel writing. That history does not justify every mechanism in the attached proposal.

## Current-state evidence

| Current fact | Repository evidence | Consequence |
|---|---|---|
| A task, not a session, already persists across Work Loop units. | The executable core defines one task as several units and keeps accepted work in the same task on Continue ([executable core](../work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md), lines 62–65 and 167–176). | No new session registry or session-scoped worktree model is needed. |
| One task has one authoritative state file. | The core states “One task, one file” and fixes `logs/work-loop/{task-id}.md` as the interface ([executable core](../work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md), lines 249–253 and 287–305). | Preserve the state file. Do not add contract, handoff, decision or lease state as competing task truth. |
| The checkout that contains the task file is already the task binding. | The deployed Codex skill says the file location is the binding, both actors verify it, and a mismatch stops rather than copying the state file ([Codex skill](../../.agents/skills/work-loop-v2/SKILL.md), lines 45–72). | A task worktree should survive handoffs. A handoff must not create a new worktree. |
| Worktrees are already conditional. | The deployed skill uses the local checkout for one writer and deliberate isolation for concurrent, unattended or large work, and explicitly says not to build another decision procedure ([Codex skill](../../.agents/skills/work-loop-v2/SKILL.md), lines 53–63). The Harness v0.2 plan puts contained unattended concurrency and conditional worktrees after the attended MVP cut line ([MVP plan](mvp-plan.md), lines 441–470). | Automatic worktree creation is not an attended-MVP requirement. |
| The dispatcher already has one active actor, state hashes and strict post-hop validation. | It hashes the state before a hop, re-reads it from disk, rejects byte-identical or unchanged-turn handbacks, checks the allowed transition, and validates Git and allowed paths ([dispatcher](../work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh), lines 1751–1777 and 1833–1883). | Do not add a separate state-writer service until a failure survives these controls. |
| The current lease has the wrong scope for multi-task use. | `LOCK_KEY` is SHA-256 of `CHECKOUT|TASK`, acquired with atomic directory creation ([dispatcher](../work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh), lines 450–467). | The exact pair is serialized, but the two cross-pair races remain open. |
| The dispatcher lock does not stop a person from editing the state file. | The deployed skill states this directly and requires `--status` before hand-editing during a run ([Codex skill](../../.agents/skills/work-loop-v2/SKILL.md), lines 132–140). | The MVP lease protects dispatcher launches, not every possible editor. Do not claim universal locking. |
| Two separate task worktrees have been demonstrated once. | The closed proof records two dispatcher instances, two linked worktrees and 182 seconds of actor overlap, while declining to authorize same-checkout concurrency or production installation ([parallel proof](../../logs/work-loop/work-loop-v2-parallel-worktree-proof.md), lines 6–22). | The next claim may be “fan-out 2 under declared policy,” not general parallel orchestration. |
| Production policy remains unresolved. | `work-loop-v2-production-readiness-policy.md` is still at `turn: codex`; its recommendation keeps worktree creation operator-gated because the file-ownership decision is judgment, not transport ([production-readiness discovery](../../logs/work-loop/work-loop-v2-production-readiness-policy.md), lines 290–341). | Assess and disposition that task before building a competing automatic-worktree path. |
| The ambient writer is proven, narrow and expensive to migrate broadly. | The production-readiness discovery shows `logs/friction-log.md` is written by a hook and read by 20+ commands; it recommends suppressing that one breadcrumb for dispatched actors rather than renaming the log estate ([production-readiness discovery](../../logs/work-loop/work-loop-v2-production-readiness-policy.md), lines 231–236 and 264–275). | Fix the proven dispatched-run writer only. Do not “kill global mutable files” repo-wide in this MVP. |

## The smallest viable architecture

The attended Harness v0.2 remains a one-task vertical slice. The concurrency addition is a narrow transport hardening used only when a second dispatched task is actually admitted.

```text
operator or existing worktree helper
        |
        | supplies exact task + exact checkout
        v
dispatcher
  1. acquire repository+task lease
  2. acquire physical-checkout lease
  3. validate state / Git / allowlist
  4. launch exactly one actor
  5. validate hash / turn / Git handback
  6. release both leases
        |
        v
same task can resume later in the same worktree
different task can run concurrently only in another worktree
```

### Lease 1 — task lease

**Identity:** hash of the canonical Git common directory plus task ID. Resolve the common directory with `git rev-parse --git-common-dir`, canonicalize it, and never assume `.git` is a directory. Linked worktrees share a common repository directory, so the key remains stable across them. Git documents `--git-common-dir` as the path holding data shared by worktrees ([git-rev-parse](https://git-scm.com/docs/git-rev-parse)).

**Guarantee:** only one dispatched run may mutate one logical Work Loop task at a time, even if the task file has accidentally appeared in two worktrees.

**Lifetime:** one dispatcher run, not the whole multi-day task. Holding it for the task lifetime would block legitimate later handoffs and create stale-lock administration.

### Lease 2 — checkout-writer lease

**Identity:** hash of the canonical physical checkout path, independent of task ID.

**Guarantee:** only one dispatched writer may use a physical checkout at a time. A second task must use another worktree or stop.

### Reuse the existing lock mechanism

Keep the current temporary-directory lock, PID status, three-way liveness verdict and pinned-lock behavior. Do not create `.git/axcion/`, a database or a tracked registry. Acquire the two leases in a fixed order—task, then checkout—and release the task lease if checkout acquisition fails. Pin both leases when a surviving actor cannot be ruled out, because that actor may still mutate both the task and its checkout.

The state file remains the sole semantic interface. Lease files contain only operational ownership facts such as PID and pinned-survivor evidence. They never contain objective, turn, result, decision or next action.

## Concrete use cases

### Use case 1 — two independent Work Loop tasks in `ai-resources`

Task A owns a new report. Task B owns a separate script. Their allowed paths do not overlap and each is large enough to justify a separate run.

- Operator or the existing helper prepares one worktree per task.
- Each task retains its own state file, branch and worktree through every Claude/Codex handoff.
- The task leases differ and the checkout leases differ, so both runs can proceed.
- Landing remains serial under the existing playbook.

This is the only parallel shape already supported by live proof, at fan-out 2.

### Use case 2 — accidental duplicate launch of one task

The same task ID is started from the main checkout and a linked worktree. The current combined lock permits both because the checkout paths differ. The repository+task lease rejects the second launch before an actor starts.

### Use case 3 — two tasks pointed at the main checkout

Two task IDs start while the checkout is clean. The current combined locks differ, so both can pass lock acquisition before either creates visible dirty state. The checkout lease rejects the second deterministically.

### Use case 4 — normal multi-session handoff

Claude exits, the dispatcher validates the handback and releases both leases. A later Codex or Claude session resumes the same task in the same checkout. It reacquires the leases. No new worktree, branch, task file or session registry is created.

### Use case 5 — wider repository work outside Work Loop

Interactive Claude sessions and Codex-managed worktrees already have separate concurrency mechanisms. The SessionStart detector is advisory, `/concurrent-session-check` predicts file overlap, `/new-worktree-session` creates isolation, and the staging guard protects some commit paths. Do not make Work Loop leases a repo-wide session manager in the MVP. Reuse the existing worktree discipline and keep the lease claim narrow: it serializes dispatcher-owned actor runs only.

## Adopt now, defer, reject

### Adopt now as policy, with code only when concurrent dispatch is promoted

1. **Task is the continuity boundary.** A task keeps one ID, one state file, one branch and one checkout/worktree across handoffs.
2. **One active actor per task.** Enforce with the repository+task lease for dispatcher runs.
3. **One dispatched writer per checkout.** Enforce with the checkout lease.
4. **Different tasks run concurrently only in different worktrees.** Cap the supported claim at two until more is demonstrated.
5. **Quarantine the proven ambient writer for dispatched actors.** Prefer the active production-readiness recommendation: suppress the `friction-log.md` breadcrumb under an explicit dispatcher environment marker while leaving interactive telemetry unchanged.
6. **Safe stop on ambiguity.** Keep dirty-tree, Git-hazard, invalid-state, timeout, permission and pinned-descendant stops.

### Defer until an observed trigger

| Capability | Why it is deferred | Trigger to reconsider |
|---|---|---|
| Mechanical serialized state writer | It would change the core's current ownership: Codex and Claude write the file, while the courier may not change semantic content. It also needs a structured patch/transition protocol and another failure surface. | One reproduced lost update or stale overwrite despite both leases, or repeated partial-write incidents that current malformed-state/dirty-state stops cannot recover safely. |
| Compare-and-swap state API | The dispatcher already records the pre-hop hash, allows one actor, re-reads from disk and checks the transition. | Evidence that a writer outside the dispatcher routinely edits during a hop and cannot be excluded operationally. |
| Automatic task worktree creation/reuse | Choosing whether tasks overlap, what base is authoritative and whether parallelism pays is still judgment. The current active discovery recommends operator-created worktrees. | Three to five attended trials show that manual worktree setup is the material remaining operator burden, and the ownership decision can be represented by existing task scopes without a new artifact. |
| Automatic worktree cleanup or landing | Merge conflicts, live sessions and branch integration are destructive or semantic decisions. | A separately approved, proven landing policy with liveness and dirty-state tests. |
| Structural-file lease | Worktrees plus disjoint allowed paths and serial landing already surface conflicts. A structural lease needs a shared path classifier and another global ownership system. | Repeated same-path conflicts after the two-lease model and per-task path scopes are in real use. |
| Repo-wide log namespacing or global-file removal | `friction-log.md` alone has 20+ consumers. A broad migration adds more lifecycle and reconciliation cost than the dispatched MVP needs. | A measured landing-conflict pattern across more than the one proven ambient writer. |

### Reject for this MVP

- one worktree per session;
- one global repository lock;
- a persistent lock database or task registry;
- four-file task directories or semantic shadow state;
- universal automatic worktree creation;
- automatic push, merge, branch deletion or worktree deletion;
- a general concurrency scheduler or “manager platform”;
- a broad rewrite of interactive session markers, logs and guards as part of Work Loop v2.

## Migration and validation steps

### Step 0 — reconcile the existing decision path

Assess and close or reframe `work-loop-v2-production-readiness-policy.md`. Record whether its operator-created worktree recommendation remains governing. Do not open a second concurrency implementation stream while that task is at `turn: codex`.

Keep the attended Harness v0.2 slice as the release cut line. The two-lease work is required only before a production claim of concurrent dispatched tasks, not before the first attended single-task tracer.

### Step 1 — freeze the two missing cases as failing tests

Add focused dispatcher fixtures that fail against the current composite lock:

1. same repository + same task + different worktrees → second run refused;
2. same physical checkout + different tasks → second run refused;
3. same repository + different tasks + different worktrees → both runs admitted;
4. same task after the first run releases its lease → later handoff admitted;
5. pinned task lease or pinned checkout lease → second run refused with a safe status message;
6. failure to acquire lease 2 releases lease 1;
7. status reports task and checkout ownership separately without writing state.

### Step 2 — split the existing lock, do not add a subsystem

Refactor only the current lock section and its status/tests. Reuse its `mkdir`, PID, `UNKNOWN`, stale and pinned-survivor behavior. Keep locks under the runtime temp directory and derive stable identifiers from canonical paths.

### Step 3 — re-run the current safety suite and a two-worktree proof

Demonstrate the three combinations above in a throwaway clone or fixture. Verify that the dispatcher still:

- launches one actor at a time;
- observes a changed state hash and allowed turn transition;
- refuses out-of-allowlist work and Git hazards;
- releases both leases on every ordinary exit;
- pins the necessary lease if actor survival cannot be disproved;
- starts nothing after `turn: operator`.

### Step 4 — one attended real-repository trial

Run two independent, additive-heavy tasks in separate worktrees, maximum fan-out 2. Use the task briefs' existing scope and the dispatchers' `--allow-path` inputs as the ownership evidence; do not create a new ownership registry. Keep landing serial and operator-controlled.

### Step 5 — decide by evidence

After the Harness v0.2 real-task set, choose one:

- **Adopt:** no cross-write, no duplicate task run, lower operator transport, and landing remains understandable.
- **Revise:** the leases work but worktree setup or ambient writers dominate the burden; address only the measured owner.
- **Stop/shrink:** parallelism adds more setup, merge or supervision cost than it saves. Keep the single-task dispatcher.

## Risks and mitigations

| Risk | MVP mitigation |
|---|---|
| Stale or pinned locks block legitimate recovery. | Keep the current three-state liveness check and manual, evidence-based clearing. Never infer “stale” from a permission-denied process probe. |
| Launchers resolve different temporary lock roots. | Resolve and report one stable per-user lock root before acquisition; prove two independent launch paths calculate the same path. |
| Two-lock acquisition deadlocks or leaks one lock. | Acquire in fixed order; if the second fails, release the first; cover every exit and signal path with tests. |
| A manual editor ignores the lease. | State the boundary honestly. `--status` remains required before hand-editing a dispatched task; a repo-wide editor lock is out of scope. |
| The task ID is duplicated in another repository. | Include canonical Git common-directory identity in the task-lease key. |
| Two worktrees edit the same canonical file. | Treat overlap as a no-go at admission or an operator merge conflict later. Leases isolate actors; they do not make co-editing safe. |
| Worktree automation chooses the wrong base or strands dirty work. | Keep worktree creation operator-gated for MVP and use the existing helper. |
| The lease becomes semantic state. | Store only operational PID/pinning facts. The task state remains in `logs/work-loop/{task-id}.md`. |
| A state writer grows into a workflow engine. | Do not build it without a reproduced failure that the two leases and existing validation cannot stop. |

## Decision criteria

The two leases are justified when all are true:

- concurrent dispatched tasks are being promoted beyond a fixture;
- at least two tasks may target one repository;
- each task has an exact state file and checkout;
- the tasks use different worktrees and non-overlapping allowed paths;
- the change stays inside the existing dispatcher lock/status/test surface.

Automatic worktrees are justified only when real attended trials show that setup, rather than task judgment or landing, is the repeated bottleneck. A serialized state writer is justified only when a state corruption escapes one-actor leasing plus the current hash/turn/Git validation. Repo-wide shared-state redesign is justified only when multiple named shared writers remain after `friction-log.md` is quarantined for dispatched actors.

## Final recommendation

Use the proposal as a **two-lease correction to the existing dispatcher**, not as a new Harness v0.2 architecture.

For the attended MVP, change nothing yet: complete one single-task vertical slice and disposition the active production-readiness discovery. Before enabling two concurrent dispatched tasks, split the current `checkout + task` lock into a repository+task lease and a checkout-writer lease, prove the two missing race cases, and run one fan-out-2 attended trial. Keep state writing, worktree creation, landing and broader repository coordination in their current owners until measured failures justify moving them.

That is the smallest change that directly closes a real gap while preserving Work Loop v2's central strength: one task, one state file, bounded actors, and no second semantic system.
