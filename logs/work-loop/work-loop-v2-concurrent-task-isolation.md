---
task: work-loop-v2-concurrent-task-isolation
status: closed
turn: operator
---

## Outcome

**Retired by the operator on 2026-08-15 to permit the Work Loop v2 durable-state migration.** The
implementation is complete and landed; the task's own operational-validation condition was never
satisfied, and this record does not claim it was.

The objective was to make two concurrent Work Loop v2 tasks safe in one repository: separate writable
checkouts, one visible task owner per checkout, no duplicate logical-task ownership, and reuse of the
bound checkout on later handoffs. The mechanism was built, independently verified, and landed on
canonical `main`. What remained was representative ordinary use by a genuine concurrent pair, which
the record's own standard required before the case could be called Resolved. That use never happened
under this task, so it is retired as **Integrated, awaiting operational validation** rather than
resolved.

## Decisions that matter

**Accepted work, assessed and preserved.** Unit 10 was accepted. The concurrency mechanism is live on
canonical `main` at `0d9e335`. The landing contains exactly the nine authorised implementation paths,
is byte-identical to the independently verified task branch, and imported neither branch history nor
this task's state file. Unrelated uncommitted work in the checkout remained intact, and nothing was
pushed. No further Claude unit was open at retirement.

**The operator declined a synthetic trial.** Rather than manufacture a fan-out, the operator chose
immediate controlled landing and designated ordinary concurrent use as the source of the remaining
operational evidence. That is why the mechanism landed with its validation condition still open — a
deliberate decision, not an oversight.

**Two undeclared state files were correctly left alone.** The `axcion-harness-v0-2-*-monday-prep`
pair is another task's ambiguous state, not a defect in this landing; the new mechanism refuses to
guess which copy is authoritative, which is the intended behaviour. They remain untouched for that
task's owner to reconcile.

**Superseded by this retirement:** the record's open `Next action` asked the operator to use the
mechanism on the next genuine pair of concurrent Work Loop tasks and to return here once at least one
task had completed a later Claude/Codex handoff in its originally bound checkout without mixed edits
or state. That return never occurred under this task. The operator's 2026-08-15 decision supersedes
the disposition, not the standard — the case is retired unvalidated, not validated.

## Evidence

Durable evidence already present in this record, carried forward unchanged:

- Landing commit `0d9e335` on canonical `main` in `ai-resources`.
- From canonical `main`: the owner suite passed **92/0** and the dispatcher suite passed **389/0**.
- Rollback remains available as a normal inverse commit:

  ```
  git -C "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources" revert --no-edit 0d9e335
  ```

## Accepted limitations

1. **Representative ordinary use never happened.** The repository-problem-resolution SOP therefore
   does not permit this case to be called **Resolved**, and it is not. This unresolved completion
   condition stands unchanged at retirement.
2. **No genuine concurrent pair was observed end to end** — no pair has been seen receiving separate
   writable checkouts with correct visible owners and then completing a later handoff in its
   originally bound checkout. The automated suites cover the refusal paths; they do not cover this.
3. **Rollback stays relevant.** Any unexpected refusal, wrong checkout, duplicated task or mixed
   state reopens the causal model and makes the preserved revert of `0d9e335` applicable.
4. **The two undeclared `axcion-harness-v0-2-*-monday-prep` state files remain unreconciled**, owned
   by another task and deliberately untouched here.
