---
task: work-loop-v2-cross-transport-concurrency-phase-1
turn: operator
---

## Outcome

Phase 1 of the accepted Work Loop v2 cross-transport concurrency proposal is implemented in this worktree (`session/2026-08-14-concurrency-fix-2`), at pilot quality, and is ready for an operator integration decision.

What is in place:

- **One shared repository-rooted live-lease contract**, in the new `logs/scripts/work-loop-lease.sh`, used by both transports. The attended carrier (`scripts/axcion-harness-v0.2/carry-turn.sh`) and the unattended dispatcher (`plans/work-loop-v2-mvp/handoff-automation-spike/dispatch.sh`) acquire and release the same task-and-checkout lease, so a run of either program is visible to the other.
- **Fail-closed repository-depth ownership admission in the attended carrier, before it launches an actor.** A carrier hop that cannot establish ownership refuses rather than proceeding.
- **A durable record on early refusal.** A pre-actor exit-17 lease refusal now writes both a human-readable refusal naming the attended holder and a machine-readable terminal record carrying `actor_launched=no`. Before the fix, that refusal happened earlier than the dispatcher's log destination existed and left no artifact.
- **Every pin result reported as itself** by both carrier and dispatcher, and a pin in the shared helper that is durable-or-explicit rather than silently best-effort.
- **The required Work Loop instruction updates only** — `.agents/skills/work-loop-v2/SKILL.md` (6 lines changed). No change to the executable core.

Both transports' intentional boundaries are preserved: the dispatcher was never used as the Work Loop courier during this task, and no work was performed in the main checkout.

## Decisions that matter

**Case 23 (genuine cross-transport contention) is accepted on composite evidence, not on a single end-to-end post-fix run.** The genuine pre-fix live run did produce the required behaviour: a real attended carrier hop held the shared lease, a real unattended dispatcher attempt for the same task and repository lost with exit 17, the refusal named the attended carrier as holder, and no second actor was launched. Its only missing artifact was the requested early-refusal log. Unit 9r2 then fixed that exact logging-order defect and proved the durable record directly; Unit 9r3 carried that case inside the full green dispatcher regression suite. Repeating the live model launch would have added orchestration cost without testing an unproven behaviour.

**The operator decided on 2026-08-14 to close at pilot quality rather than manufacture case 24.** Case 24 (a genuine fan-out-two Work Loop pair) needs two top-level Work Loop tasks in two worktrees. A single interactive Claude session cannot safely create two top-level actors, and the alternatives — operator-coordinated dual sessions, or re-enabling automated transport — both cost more than the remaining uncertainty is worth at this stage. Unit 10 stopped on exactly this and launched no transport.

**Deferrals carried out of this closure, each with why it stays outside Phase 1:**

- **`LOCK_KEY` is unassigned in `dispatch.sh`.** Pre-existing, not introduced by this repair, and not on the Phase 1 surface. Fixing it would be an unrelated edit inside a task whose scope excluded repairs.
- **Phase 2 task-aware automatic worktrees, and any change to D4.** Explicitly excluded by the task's own scope. Phase 2 is the next proposal stage and depends on an operator integration decision on Phase 1 first.
- **The retained interactive same-task limitation.** Deliberately kept, not overlooked: the attended path still refuses a second same-task actor rather than coordinating one, and relaxing that would reopen the very over-refusal control that Unit 3b2 identified as load-bearing.

**A false premise was handed back once and honoured.** Unit 3b2 found that ordinary `mkfix` helper packaging could not preserve the over-refusal control in the carrier's section 12b, and handed back rather than building around it. Unit 3b2r then implemented the admission properly.

## Evidence

**Branch:** `session/2026-08-14-concurrency-fix-2`. **Merge-base with `main`:** `212fa918`. **Head at closure:** `1ea47608`, plus this closing commit.

**Implementation span:** `54d9db9c` (unit 1, four cross-transport contention cases as a red slice) through `5bd3226b` (unit 9r3). Twelve files changed against `main`: +4044 / −278 lines.

**Controller gates, each red-before-green where a fix was involved:**

| Suite | Result |
|---|---|
| Shared lease helper (`work-loop-lease.test.sh`) | 67 / 0 |
| Owner suite | 92 / 0 (was 86/6 on a fixture-packaging omission) |
| Carrier suite (`carry-turn.test.sh`) | 350 / 0 |
| Dispatcher suite (`dispatch.test.sh`) | 537 / 0, exit 0 — the final full regression gate |

Intermediate red-to-green transitions on the dispatcher suite: 498/5 → 503/0 (unit 7), 510/7 → 517/0 (unit 8r2), then 537/0 at unit 9r3.

**Live evidence:** the genuine case-23 carrier-versus-dispatcher observation — dispatcher exit 17, carrier exit 22, holder label correct — is recorded in `plans/work-loop-v2-v0.2/dispatcher-work-loop-harness-autonomy-improvement-report-2026-08-14.md` (§1.1, §2.7, and Evidence consulted), committed at `5d38c76f`.

**Run artifacts:** `logs/harness-runs/` in this worktree, including `20260814-unit9r3-dispatcher-suite-full.out` (the 537/0 gate), `20260814-unit8-holder-label-green.out`, `20260814-unit8-dispatcher-red.out` and the unit-6 gate outputs. This directory is **untracked** — it is local working evidence, not committed history.

**Rollback path:** nothing from this task has been merged to `main` or pushed. Rollback is to decline the merge and discard the branch; the repository returns to `212fa918` with no revert needed. If a partial rollback is ever wanted after a merge, the implementation is separable at file level — `logs/scripts/work-loop-lease.sh` and its test are new files, and the carrier and dispatcher changes are confined to `carry-turn.sh` and `dispatch.sh`.

## Accepted limitations

1. **The genuine fan-out-two pair (case 24) is unrun.** Broader operational confidence should not be claimed until the next real pair of concurrent Work Loop tasks supplies it. That pair is the intended natural producer of this evidence — it does not need to be manufactured.
2. **Case 23 was not repeated end-to-end after the logging fix.** Its acceptance is composite: a genuine pre-fix live contention observation plus a post-fix durable-logging proof plus the full 537/0 regression gate. Each half is real; the single unbroken post-fix run is what is missing.
3. **The interactive same-task limitation is retained by design**, not resolved.
4. **Live evidence in `logs/harness-runs/` is untracked** and will not survive a clean checkout.
