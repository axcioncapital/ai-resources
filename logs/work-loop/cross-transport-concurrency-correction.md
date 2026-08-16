---
task: cross-transport-concurrency-correction
status: closed
turn: operator
---

## Outcome

The seven Phase 1 safety corrections and the required controller coverage are complete, live case 23 passed end-to-end in one continuous post-fix observation, and the final independent Spec review's reproduced stale-reclaim blocker was fixed and independently confirmed. **Merge is recommended**, with live case 24 and the documented non-blocking findings accepted rather than closed.

The durable Phase 1 record — outcome, decisions, evidence and the full limitation list — is `logs/work-loop/work-loop-v2-cross-transport-concurrency-phase-1.md`.

## Decisions that matter

**The final Spec review blocked merge on a real high-severity defect, and Unit 11 repaired it.** Stale-lease arbitration could return success to two reclaimers: the witness set is read by scanning it, and a scan cannot see a witness published after it runs, so a lower-PID reclaimer arriving after a higher-PID scan was authorised too — and the second one renamed the first one's freshly created live lease away. The repair does not add more re-checking, because no check-then-act sequence can close that window. The rename, recreate and holder write now run while the reclaimer holds an **exclusive claim** on that lease, taken with the same atomic `mkdir` the lease itself uses, with all three pre-rename re-checks moved inside it. The claim reuses the existing `<lease>.reclaiming` directory, so the dead-owner recovery already in the acquisition loop covers it and an exclusive claim cannot strand the lease one level up. Fail-closed behaviour for `LIVE`, `UNKNOWN`, corrupt pids and pinned leases is unchanged; no public function, return code or `WL_LEASE_*` variable changed, so neither transport was touched.

**The repair is protected by a deterministic regression, not a probabilistic one.** New case 22 forces the exact interleaving instead of racing and counting. The pre-existing barrier race (case 17) stays and stays green, but is no longer treated as proof of this schedule.

**The narrow independent re-review of Unit 11 passed and recommends merge.**

**The operator decided on 2026-08-15 to skip live case 24 rather than orchestrate it**, and to fix only what is truly needed in Unit 11. A supported, contract-compliant route for case 24 was worked out and is recorded in the Phase 1 record; nothing was reconstructed, simulated or approximated in its place.

**The Standards axis did not pass cleanly, and its three findings were recorded rather than implemented.** Rewriting 21 historical commit subjects conflicts with this task's explicit no-history-rewrite boundary and was judged disproportionate; the duplicated ownership-admission glue is a judgement-call smell with correct, covered behaviour and is a separate refactor; `r17`'s naming is low-severity cleanup. **Deferred and not done:** all three, plus a stale comment on case 19 of the shared-lease harness, whose assertions are correct but whose wording Unit 11 made half true — left rather than widening a safety commit.

**Evidence bound, deviated from and stated:** the Unit 11 brief asked for narrow carrier and dispatcher test *slices*. Neither suite supports selecting cases, so no such slice exists; the two existing suites were run unchanged instead of authoring a bespoke extract. More evidence than asked for, and no repository change.

## Evidence

**Final implementation commit:** `f3b4e1b1` (Unit 11 — exclusive reclaim claim, case 22, and the Unit 11 handback), plus this closing commit carrying the Phase 1 record update and this reduced file.

**The falsifying pair, both measured on 2026-08-15:** the shared-lease suite returns `132 / 4` against the pre-Unit-11 helper, with all four failures in case 22 and every other case passing, and `136 / 0` against the repaired helper over four consecutive runs. On the forced schedule the loser returns 2 / `CONTENDED`, the winner's lease survives with complete holder metadata, and no tombstone, claim or witness residue is left.

**Transports, re-run at `f3b4e1b1`:** `carry-turn.test.sh` 423 / 0, `dispatch.test.sh` 632 / 0, both exit 0. `bash -n` clean over the helper and both transports. `git diff --check` clean in the working tree.

**Durable Phase 1 record:** `logs/work-loop/work-loop-v2-cross-transport-concurrency-phase-1.md`, updated in this closing commit with the Unit 11 repair, the re-measured span (15 files, 6562 insertions, 259 deletions at `f3b4e1b1`), the refreshed gate table, and the review outcome on both axes. The durable live case-23 refusal record is quoted in full there rather than cited by path.

## Accepted limitations

1. **Live case 24 was not executed, so the correction plan's Done definition is not fully met.** Controller case 12 covers two different tasks in two linked worktrees and passes, but there is no post-fix live proof of two real concurrent Work Loop tasks each completing a later handoff in its own linked worktree. Accepted by the operator on 2026-08-15 on time grounds, with the route recorded.
2. **The Standards axis did not pass cleanly.** Its three findings — historical commit-subject prefixes, duplicated ownership-admission glue, and the `r17` naming — are recorded and open, not fixed.
3. **The interactive same-task limitation stays open by design.** Nothing prevents two interactive sessions on one checkout for the same task, or an operator proceeding past a refusal.
4. **The full technical limitation list is the Phase 1 record's**, which carries all nineteen, including the ones Unit 11 changed or added. This file does not restate them.
5. **Nothing has been merged or pushed.** Rollback is to decline the merge and discard the branch.
