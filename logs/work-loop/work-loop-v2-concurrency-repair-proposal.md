---
task: work-loop-v2-concurrency-repair-proposal
status: closed
turn: operator
---

## Outcome

The implementation proposal is accepted as the reliable basis for the next implementation task. It covers all ten required sections, traces current-behavior claims to checked repository evidence, distinguishes repository fact from recommendation, preserves D4 as settled policy unless the operator later approves Phase 2, and keeps implementation and other excluded work outside this unit.

Recommended architecture: one shared live-lease contract used by both transport programs, plus fail-closed repo-depth ownership admission in the attended carrier, as Phase 1. Task-aware automatic worktrees are presented as a conditional Phase 2.

## Decisions that matter

- Phase 1 is recommended but not authorized by this proposal task.
- Phase 2 remains a proposed replacement for D4 and requires an explicit operator decision after Phase 1 validation.
- Live actor runs likewise require explicit authorization in the implementation task.
- Deferral: `scripts/axcion-harness-v0.2/carry-turn.test.sh` § 12b (line 811) asserts the exact behaviour Phase 1 would remove. Not changed here — the brief excludes changing tests; the inversion is recorded inside the proposal.
- Deferral: `plans/axcion-harness-v0.2/task-scoped-concurrency-investigation-2026-08-08.md` is superseded on two points (its line 37 composite `CHECKOUT|TASK` lock key, and its Step 2 recommendation to keep locks under the temporary directory). Not corrected in that document — the brief excludes changing anything beyond the proposal and this state file; the correction is recorded in the proposal § 2.7.

## Evidence

Commit `10d2eeb6f8868b2f073e11150dc1a50a95ea760a`, containing exactly this state file and `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-and-task-aware-worktrees-implementation-proposal-2026-08-13.md`.

## Accepted limitations

The proposal intentionally leaves the same-task interactive-session limitation open, and does not implement any recommendation.
