---
task: cross-transport-concurrency-correction
turn: codex
---

## Objective and scope

Correct the seven reviewed Phase 1 concurrency findings, complete the required controller and live evidence, and leave this branch ready for the final independent review and merge decision described in `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-correction-plan-2026-08-14.md`.

Scope is exactly that correction plan as committed at `f2b19b5d80a061111c39cc7444f90f6374f19d38`. Excluded: Phase 2, automatic worktree creation, a scheduler, registry, service, new state store, new command surface, unrelated `LOCK_KEY` work, unrelated cleanup, merge, and push.

## Lane and unit

Standard. Implementation mode. Unit 1 — make the shared lease distinguish live, absent, and unknown holders and reclaim only positively absent unpinned leases without permitting two winners.

Named reason for the loop: the correction spans several independently assessable units and must survive session boundaries; the result also needs assessment by someone other than its implementer before it can progress. The operator explicitly chose Work Loop v2 for this task on 2026-08-15, overriding the normal specialist route to Matt `implement`.

## Brief

This unit closes the shared safety gap first because every later carrier and dispatcher correction depends on the lease helper's liveness verdict. It implements only correction-plan step 1; the other six findings remain outside this unit so the evidence stays attributable and the correction remains reviewable.

Required outcome: add failing-first behavioral coverage and the smallest helper change that establishes `LIVE`, `ABSENT`, and `UNKNOWN`; refuses and preserves `LIVE` and `UNKNOWN`; reclaims only `ABSENT`; never auto-reclaims a pinned lease; and allows exactly one winner when contenders race to reclaim the same stale lease.

Governing sources:

- Current operator direction on 2026-08-15 governs the choice to use Work Loop v2.
- `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-correction-plan-2026-08-14.md` at `f2b19b5d80a061111c39cc7444f90f6374f19d38` governs the correction scope and acceptance conditions.
- Its named governing proposal, `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-and-task-aware-worktrees-implementation-proposal-2026-08-13.md`, governs Phase 1's two-resource lease contract and the rule that a lease not shown free is held.
- `.agents/skills/work-loop-v2/references/repository-problem-resolution-sop.md` was routing context only. It is not approved implementation authority and adds no artifacts or gates to this unit.

Check these claims against the live repository before changing anything:

1. In `logs/scripts/work-loop-lease.sh`, inspect `wl_lease_acquire` and establish whether every existing unpinned lease is currently refused without a three-state PID probe, including positively absent holders.
2. In `logs/scripts/work-loop-lease.test.sh`, search the executed cases for explicit behavioral coverage of a live holder, an uninspectable holder, missing/empty/malformed/zero/zero-prefixed PIDs, positively absent recovery, two stale-recovery contenders, and pinned non-recovery. State exactly which are absent or only indirectly covered.
3. In `logs/scripts/work-loop-lease.sh`, confirm how `survivors` is recognized and preserve the invariant that pin evidence is checked before PID liveness.
4. Inspect the `wl_lease_acquire` call sites in `scripts/axcion-harness-v0.2/carry-turn.sh` and `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`. Preserve their public return-code and metadata contract; neither caller may reimplement PID classification in this unit.
5. Report the current branch, checkout, Git status, and unrelated existing changes before editing. Treat all pre-existing modifications and untracked evidence as operator-owned; do not stage or commit them.

Authorized changes for this unit:

- `logs/scripts/work-loop-lease.sh`
- `logs/scripts/work-loop-lease.test.sh`
- this state file
- `logs/friction-log.md` only if an existing hook updates it; do not stage or commit that unrelated hook output

Codex framing decision: carrier legacy-lock handling, carrier process-group shutdown, dispatcher refusal logging, dispatcher status wording, the full controller matrix, live cases 23/24, and the closing record are held for later units because each has a separate dominant behavior and evidence set.

Required evidence:

- Add the exact cases listed in correction-plan step 1, with positive controls that distinguish safe admission from blanket refusal.
- Before the production fix, run the new targeted cases against the pre-fix helper and record output proving they fail for the intended reason. Do not manufacture red evidence after implementation.
- After the fix, run `bash -n logs/scripts/work-loop-lease.sh logs/scripts/work-loop-lease.test.sh` and `bash logs/scripts/work-loop-lease.test.sh`; report commands, exit codes, pass/fail totals, and the relevant output.
- Demonstrate from the race case that exactly one contender acquires after stale recovery and from filesystem assertions that live, unknown, malformed, and pinned lease directories survive.
- Report changed files, the implementation commit, any deviations, remaining limitations, and rollback instructions.

Completion condition: the shared helper and its suite satisfy correction-plan step 1, the authorized tests pass, no caller duplicates PID classification, only authorized files are committed, and Claude updates this state file with the result and evidence, sets `turn: codex`, commits, and stops for assessment.

Stop and hand back without improvising if a premise is false, the supported host cannot distinguish positive absence from unknown, safe stale recovery would require deleting the active lease path directly, the public helper contract must materially change, or the work needs files outside the authorized boundary. Challenge stale instructions or a false premise explicitly rather than building around them.

## Latest result

The one permitted final tightly-bounded fix, confined to correction-closure finding 1. Finding 2 was not reopened, the witness-set design is unchanged, the lease was not redesigned, and neither recorded deferral was addressed.

**The gap, reproduced by inspection.** Codex was right on both halves. The witness-set implementation constructed no `.reclaiming` path at all — `grep -n reclaiming logs/scripts/work-loop-lease.sh` at `ca35371c` returned only prose comments and the `WL_LEASE_RECLAIM_ROUNDS` text, no code — so an old-format marker was walked straight past. Case 19 fabricated a dead marker but asserted nothing about it, and case 20 asserted only the in-lease witness. Confirmed behaviourally against `ca35371c`'s helper: with a live marker owner and a free lease, a contender returned `rc=0 ACQUIRED task_owned=1 checkout_owned=1`.

**The fix.** One additive block at the top of `wl_lease__acquire_one`, before the `mkdir`. If `<lease>.reclaiming` exists, its recorded pid goes through the same three-state probe used everywhere else:

- **LIVE or UNINSPECTABLE** — the marker is preserved untouched and admission is refused with `CONTENDED`.
- **ABSENT** — the marker is cleared by rename-to-tombstone then delete, the same discipline the stale lease gets, so `rm -rf` is never aimed at a path another run might recreate. Recovery then proceeds normally.
- **Absent but unclearable** — refused, preserved. Failing closed rather than spinning against something this run cannot remove, which also bounds the loop.

It is read *before* the `mkdir` deliberately. The window the old mechanism left open is exactly the one where the reclaimer has renamed the lease away and not yet recreated it, so the lease path is free; a run that went straight to `mkdir` there would take a lease a live reclaimer is still working on. That is why sub-cases (a) and (b) below fabricate a **free** lease — it is the placement, not just the check, that is under test.

Clearing a dead marker cannot produce two winners because clearing grants nothing: both runs then go through the unchanged witness set, which decides the single winner. Sub-case (d) exercises that directly.

Result: finding 1 is resolved for both representations. A live or uninspectable reclaimer — old-format marker or new-format witness — is preserved and refuses admission; a positively absent one permits recovery and is cleaned up, with exactly one winner.

Evidence:

- **Failing first, against the pre-fix helper** (`git show ca35371c:logs/scripts/work-loop-lease.sh` via `WL_LEASE_LIB`): `bash logs/scripts/work-loop-lease.test.sh` → `pass=122 fail=5`, exit 1. Case 21(a) and 21(b) both returned `rc=0 ACQUIRED task_owned=1 checkout_owned=1` over a live and an uninspectable marker owner. Case 21(c) recovered but left `...task-9dcf021a45ce8584.lock.reclaiming survives` as residue. Case 19's new assertion failed the same way. Sub-case (d) already passed at `acquired=1`, which is the point of including it: it is the regression guard on the witness race, not a new claim.
- **After the fix:** `bash -n logs/scripts/work-loop-lease.sh logs/scripts/work-loop-lease.test.sh` → exit 0. `bash logs/scripts/work-loop-lease.test.sh` → `pass=127 fail=0`, exit 0, reproduced on four consecutive runs.
- **All three marker-owner states, asserted directly** — each on both admission and the filesystem. (a) LIVE: `rc=17`, `state=CONTENDED`, marker byte-identical afterwards, and no lease created behind the reclaimer's back. (b) UNINSPECTABLE (pid 1): `rc=17`, marker preserved, no lease created. (c) ABSENT: `rc=0`, both resources owned, marker gone, no tombstone left.
- **No two winners with a dead marker in the way** — sub-case (d) fabricates a stale lease *and* a dead old-format marker, releases 6 barrier-synchronised contenders, and asserts `acquired=1`, `other=0`.
- **Existing protection retained.** Case 17's witness race still reports `acquired=1 refused=5 other=0`; cases 19 and 20 still pass, including the newly added assertion that the dead old-format marker is cleaned up; the rollback, partial-pin, durable-pin and read-only-status cases are untouched and green.
- **Neither caller regressed.** `bash scripts/axcion-harness-v0.2/carry-turn.test.sh` → `passed: 371 failed: 0`, exit 0. `bash plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` → `pass=537 fail=0`, exit 0. Both unmodified.
- **Changed:** `logs/scripts/work-loop-lease.sh` (+36 lines, one self-contained block; no existing logic altered), `logs/scripts/work-loop-lease.test.sh` (+121 lines), and this state file. `logs/friction-log.md` and `logs/harness-runs/` remain pre-existing operator-owned and unstaged.
- **Rollback:** `git revert` the final-fix commit restores `ca35371c`'s behaviour; `git checkout c6f758fe -- logs/scripts/work-loop-lease.sh logs/scripts/work-loop-lease.test.sh` returns the state before Unit 1.

Deferral, recorded and not done: the transition block is dead weight once no checkout can still hold an old-format marker. The comment says so in place and names the condition for removing it. Removing it now would defeat the fix.

The two deferrals recorded at the correction round stand unchanged and were not addressed here: mutually uninspectable live reclaimers both stand down, and `wl_lease_status` still reports `HELD` for a provably dead holder.

## Blocker

None.

## Next action

Codex: the final closure check — does the transition fix resolve correction-closure finding 1, and did it break the shared lease or either caller? This fix and regressions only; anything else is a deferral.
