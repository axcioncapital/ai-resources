---
task: work-loop-v2-concurrent-task-isolation
turn: operator
---

## Objective and scope

Make two concurrent Work Loop v2 tasks safe in one repository: separate writable checkouts, one visible task owner per checkout, no duplicate logical-task ownership, and reuse of the bound checkout on later handoffs.

Human-controlled: final landing and cleanup. Excluded: push, automatic deletion, a scheduler, persistent registry, and a second state system. The operator declined a synthetic fan-out trial and chose immediate controlled landing; ordinary concurrent use supplies the remaining operational evidence.

## Lane and unit

Standard. Unit 10 accepted. The case is **Integrated, awaiting operational validation**; no further Claude unit is open.

Named reason for the loop: this cross-cutting concurrency fix needed bounded implementation and independent assessment across sessions.

## Latest result

Accepted: the concurrency mechanism is live on canonical `main` at `0d9e335`. The landing contains exactly the nine authorised implementation paths, is byte-identical to the independently verified task branch, and did not import branch history or this task's state file. From canonical main, the owner suite passed 92/0 and the dispatcher suite passed 389/0; unrelated uncommitted work remained intact. Nothing was pushed.

Rollback remains available as a normal inverse commit:

```
git -C "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources" revert --no-edit 0d9e335
```

The two undeclared `axcion-harness-v0-2-*-monday-prep` state files are a separate task's ambiguous state, not a defect in this landing; the new mechanism correctly refuses to guess. They remain untouched for that task's owner to reconcile.

## Blocker

Representative ordinary use has not happened yet, so the repository-problem-resolution SOP does not permit the case to be called **Resolved**.

## Next action

Operator: use the mechanism on the next genuine pair of concurrent Work Loop tasks in this repository. Return here after the pair has received separate writable checkouts with the correct visible owners and at least one task has completed a later Claude/Codex handoff in its originally bound checkout without mixed edits or state. Do not manufacture a duplicate or ownership conflict; the automated suites already cover those refusals. Report any unexpected refusal, wrong checkout, duplicated task, or mixed state immediately; that reopens the causal model and makes the preserved revert relevant.
