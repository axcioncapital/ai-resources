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

Both frozen findings reproduced by inspection before anything was changed, then corrected. Nothing newly noticed was implemented.

**Finding 1 — reproduced.** Confirmed by running the new case 19 against the pre-correction helper (`git show fee4fe49:logs/scripts/work-loop-lease.sh`, via `WL_LEASE_LIB`). A stale lease plus a `<lease>.reclaiming` marker owned by a positively absent pid produced `rc=17 ... REFUSED-STATE state=CONTENDED reason=... the lease could not be reclaimed in 25 rounds ... was left behind by a run that died mid-reclaim and has to be removed by hand`. The dead holder no longer stranded the task; the dead reclaimer did, which is the same permanent refusal one level up.

**Finding 1 — corrected.** The exclusive marker is gone. Reclaimers now exclude each other through a **set** rather than a lock: each creates a witness directory `wl-reclaim-<pid>-<round>` inside the lease it means to reclaim, then reads the set back. A witness whose owner is positively absent is **ignored and never removed** — ignoring is a read-only decision, so it needs no arbitration of its own, which is what stops the recursion that made the marker unrecoverable. A witness whose owner is uninspectable stands the reader down, so `UNKNOWN is held` is unweakened. Between two live reclaimers the lower pid proceeds, which is what stops both standing down and neither making progress. The witness sits inside the lease, so the winner's rename carries every witness away with the stale directory — there is nothing left to clean up and nothing for the operator to delete by hand. The re-validation inside the critical section is unchanged and still load-bearing: a witness placed in a lease that has since become live would otherwise license renaming a live holder's lease away.

**Finding 2 — reproduced.** Case 16's residue assertion read `-name '*.reclaim'` while the implementation created `*.reclaiming`, so it could not have detected the artifact whose cleanup it claimed to prove. The two `-maxdepth` terms around `-o` were also ungrouped.

**Finding 2 — corrected.** The name now matches, the terms are grouped, and two assertions were added that do not depend on knowing the artifact's name: the lease root must hold nothing but `*.lock` directories, and no `wl-reclaim-*` witness may survive inside an acquired lease. A name-matched assertion can only catch residue whose name it was told; the residue that matters is the kind nobody predicted.

Result: findings 1 and 2 are resolved. A reclaimer that dies mid-reclaim now costs the next run one extra probe instead of a stranded lease. Correction-plan step 1's acceptance condition that a dead unpinned holder does not strand the task permanently now holds for the reclaimer as well as the holder. The correction stayed inside Unit 1's three authorized files; the public helper contract, the return codes and every caller are unchanged.

Evidence:

- **Both findings failing first, against the pre-correction helper** (`WL_LEASE_LIB=/tmp/wl2-prefix-lease.sh bash logs/scripts/work-loop-lease.test.sh`, exit 1): `pass=102 fail=11`. Case 19 failed with the `CONTENDED` stranding reason quoted above and left the dead reclaimer's witness behind. Case 20 failed in the opposite direction and is the reason the fix could not be "delete whatever is in the way": with a live reclaimer's witness present the pre-correction helper returned `rc=0 ACQUIRED task_owned=1 checkout_owned=1`, removed the witness and renamed the lease away underneath it.
- **After the correction:** `bash -n logs/scripts/work-loop-lease.sh logs/scripts/work-loop-lease.test.sh` → exit 0. `bash logs/scripts/work-loop-lease.test.sh` → `pass=113 fail=0`, exit 0, reproduced on five consecutive runs, so the race and back-off paths are not passing by timing.
- **Case 19 (recovery):** fabricates a stale lease, a `<lease>.reclaiming` marker owned by a dead pid, and a `wl-reclaim-<deadpid>-1` witness — both representations of the interrupted state, so the case tests the mechanism before and after the correction rather than describing one of them. Asserts the next run acquires both leases, releases both on exit, and leaves no witness and no tombstone.
- **Case 20 (preservation):** (a) an uninspectable reclaimer (pid 1, deterministic — lower than any contender and answering `kill -0` with a refusal rather than absence) refuses the next run with `state=CONTENDED`, its witness preserved and the lease untouched; (b) a live reclaimer started before the contender refuses it too, its witness preserved and its lease not renamed away underneath it.
- **The existing cases are unchanged and still green**, including case 17's exactly-one-winner race (`acquired=1 refused=5 other=0`), the rollback, partial-pin, durable-pin and read-only-status cases.
- **Neither caller regressed.** `bash scripts/axcion-harness-v0.2/carry-turn.test.sh` → `passed: 371 failed: 0`, exit 0. `bash plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` → `pass=537 fail=0`, exit 0. Both run unmodified.
- **Changed:** `logs/scripts/work-loop-lease.sh`, `logs/scripts/work-loop-lease.test.sh`, and this state file — Unit 1's three authorized files, nothing else. `logs/friction-log.md` and `logs/harness-runs/` remain pre-existing operator-owned and unstaged.
- **Rollback:** `git revert` the correction commit returns the exclusive-marker implementation; `git checkout c6f758fe -- logs/scripts/work-loop-lease.sh logs/scripts/work-loop-lease.test.sh` returns the state before Unit 1.

Candidate deferrals, recorded and not implemented — newly noticed during this correction, so not part of the frozen scope:

1. Two live reclaimers that are mutually uninspectable both stand down and both refuse. That is fail-closed and correct under `UNKNOWN is held`, but it is a refusal neither can resolve. It cannot arise between two runs in one repository that can inspect each other.
2. `wl_lease_status` still reports `HELD` for a lease whose recorded holder is provably dead, so status and acquisition describe the same lease differently. Carried forward unchanged from Unit 1's hand-back.

## Blocker

None.

## Next action

Codex: run the closure check on the frozen findings only — are findings 1 and 2 resolved, and did the correction break the shared lease or either caller? Then close, or use the menu in core § 3.
