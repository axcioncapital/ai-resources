---
task: cross-transport-concurrency-correction
turn: codex
---

## Objective and scope

Correct the reviewed Phase 1 concurrency findings, maintain an accurate closing record, obtain an independent merge recommendation, and reach an honest merge decision under `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-correction-plan-2026-08-14.md` as bound at `f2b19b5d80a061111c39cc7444f90f6374f19d38`.

The operator's 2026-08-15 decision to skip live case 24 remains binding and recorded as an accepted limitation. Excluded: Phase 2, case-24 reconstruction, product worktree automation, scheduler, registry, service, new state store or command surface, unrelated `LOCK_KEY` work, unrelated cleanup, history rewriting, merge, and push.

The operator further directed on 2026-08-15 that Unit 11 fix only what is truly needed and avoid excess gates or governance. For this internal helper correction, that means deterministic red/green proof, the helper's full suite, and narrow transport integration checks; it expressly does not mean rerunning every broad suite or rewriting the closing record before independent confirmation.

## Lane and unit

Standard. Implementation mode. Unit 11 — close the final Spec review's reproduced double-winner stale-reclaim race.

Named reason for the loop: the independent reviewer reproduced a high-severity violation of correction finding 5, so merge is unsafe until someone other than that reviewer implements and proves the narrow correction.

## Brief

The final independent review did not recommend merge because current stale-lease arbitration can return success to two reclaimers. This unit fixes only that safety defect. Do not add case 24, refactor ownership admission, rename `r17`, rewrite commit history, update the closing record prematurely, or perform unrelated cleanup; the separate Standards findings remain outside this unit.

Governing sources:

- Correction plan finding 5 and its acceptance at `f2b19b5d80a061111c39cc7444f90f6374f19d38`: a positively dead unpinned lease is recoverable, stale recovery permits exactly one winner, and no active lease path is deleted after a stale decision.
- Proposal case 13 in `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-and-task-aware-worktrees-implementation-proposal-2026-08-13.md`: exactly one simultaneous stale reclaimer proceeds.
- Independent finding `audits/working/2026-08-15-final-concurrency-spec-review.md`, especially the late-arriving lower-PID interleaving. Treat the audit as verified review evidence, not governing design authority.

Verify these claims first against current HEAD:

1. `logs/scripts/work-loop-lease.sh` scans a witness set before the rename, and a lower-PID witness arriving after a higher-PID scan can authorize both contenders.
2. Both contenders can recheck the same stale holder before either rename, after which the loser can rename the winner's newly-created live lease and still return success.
3. The existing race test in `logs/scripts/work-loop-lease.test.sh` does not deterministically force that late-lower-PID schedule.

If any claim is false or the review reproduction depends on behavior the real helper cannot exhibit, record the exact contrary evidence and hand back without implementation.

Required outcome:

- Add one deterministic failing regression that forces the valid late-arriving lower-PID schedule described by the review. At current pre-fix code it must demonstrate two successful reclaimers or the equivalent duplicate-ownership failure; do not accept a probabilistic loop as the only evidence.
- Make the smallest safe arbitration correction so a stale decision cannot later rename or replace a different generation's live lease. The implementation mechanism is Claude's technical decision, but its winner claim must remain valid through rename/recreate and must preserve the plan's fail-closed behavior for `UNKNOWN` and pinned holders.
- Show the forced interleaving now yields exactly one successful owner, the loser receives a non-success/held result, and the winner's live lease survives with correct metadata.
- Keep the helper's ordinary simultaneous race, live/unknown/pinned, rollback, and partial-pin behavior green. Run only the smallest existing carrier and dispatcher test slices that exercise stale recovery or the shared lease acquisition contract; do not run their full suites unless the helper's public behavior or packaging changes beyond this defect.

Authorized tracked changes: `logs/scripts/work-loop-lease.sh`, `logs/scripts/work-loop-lease.test.sh`, and this state file. Leave the closing record, `logs/friction-log.md`, `logs/harness-runs/`, and both review notes under `audits/working/` unstaged and uncommitted. Do not change transport scripts unless the helper's public contract genuinely cannot close the race; if that occurs, stop and hand back before widening scope.

Required evidence: exact pre-fix red output from the deterministic schedule; exact post-fix green output; helper syntax check; the full shared-lease suite; the narrow existing carrier and dispatcher slices that exercise the shared lease contract; `git diff --check`; changed-path proof; and the commit containing implementation, tests, and this handback. Skip the owner suite and broad carrier/dispatcher suites unless the implementation changes their contract or fixture packaging. Process-control checks must run on a host where their inspection commands work.

Completion condition: the reproduced high-severity race is deterministically protected, the minimum evidence above passes, and Claude sets `turn: codex`, commits only authorized tracked files, and stops for a narrow independent re-review. Stop rather than weaken stale recovery, pin every dead lease, rely on timing luck, delete a possibly live generation, or expand into Standards cleanup.

## Latest result

Inspected (2026-08-15), against `ecf8aa0e1a562ad7798192361c1ff8d54c18a9ad`:

- Claim (1): HOLDS — read `logs/scripts/work-loop-lease.sh` lines 292–309 (`wl_lease__witness_clear`) and 401–409. The witness set is read by one `for` glob over `"$wl_d/wl-reclaim-"*`, and a reclaimer stands down only for a witness that is present at that scan. A lower-PID witness created after a higher-PID scan is invisible to it, and the lower-PID run does not stand down for the higher PID either, because line 306 stands down only when `$wl_other -lt $wl_pid`. Both are authorized.
- Claim (2): HOLDS — read lines 415–435. The re-verification (`-d "$wl_d"`, no `survivors`, holder still ABSENT) and the `mv "$wl_d" "$wl_tomb"` are separate steps with nothing holding the lease between them, and each contender's tombstone name is unique (`$wl_d.stale.$wl_pid.$wl_round`), so the second `mv` renames whatever now sits at `$wl_d` — including a live lease the first contender created at line 432 — then `mkdir`s and writes its own holder and returns 0.
- Claim (3): HOLDS — read `logs/scripts/work-loop-lease.test.sh` case 17 (lines 767–808). It starts `N` contenders behind a barrier file and counts the outcomes; searched the whole file for any mechanism that orders witness publication against another contender's scan (`grep -n 'wl-reclaim\|mkdir()\|mv()\|command mkdir'`) — no match outside fabricated fixtures in cases 19–21. Nothing forces the late-lower-PID schedule.

Result: the reproduced double-winner stale-reclaim race is closed, and the closure is protected by a deterministic regression.

- `logs/scripts/work-loop-lease.sh` — the rename, the recreate and the holder write now happen while the run holds an **exclusive reclaim claim** on the lease, taken with `mkdir "$wl_d.reclaiming"`, which exactly one of two simultaneous reclaimers creates. All three pre-rename re-checks moved inside the claim, so the winner's verdict cannot be invalidated between the last check and the `mv`: no other reclaimer can rename or recreate that lease while the claim is held. The claim is dropped on every path — refused re-check, failed rename, and success (after the fresh lease carries this run's pid). Fail-closed behaviour is unchanged: `LIVE`, `UNKNOWN`, corrupt pids and `survivors` still refuse before any reclaim, and a claim whose pid is unwritten reads as `UNKNOWN` and is held.
- The claim reuses the existing `<lease>.reclaiming` directory rather than adding a second marker, so the dead-owner recovery already in the loop's first block — probe the claim's pid, clear only on positive absence, clearing grants nothing because the following `mkdir` still picks the winner — now covers a claimant of this build as well as one from the earlier build. That is what stops the claim stranding the lease one level up.
- `logs/scripts/work-loop-lease.test.sh` — new **case 22** forces the exact schedule. Two processes source the shipped library unmodified and shadow `mkdir` and `mv` with shell functions (bash resolves a function before a PATH lookup), rendezvous through files, and take their L/H roles from their two real pids: H publishes its witness and scans alone, only then does L publish and scan, both re-read the same stale holder, and only then is either rename allowed to run. Both waits are bounded, so no interleaving can hang the harness.

Evidence:

- **Red, deterministic, pre-fix.** Ran the suite against the unmodified `HEAD` helper (`git show HEAD:logs/scripts/work-loop-lease.sh`, sha256 `36f0afb6213b03e8c031218a349e79102f0b819250b6db72939b7e0c116a01ff`) via `WL_LEASE_LIB=`. Case 22 failed on both runs with **two winners**: `rc A=0 B=0 | ROLE=L pid=65731 rc=0 holder=65731 state=ABSENT | ROLE=H pid=65732 rc=0 holder=65732 state=ABSENT` (second run: pids 83364/83365, same shape). Suite total `pass=132 fail=4`, exit 1 — the four failures are all case 22, so every other case passes against the pre-fix helper and case 22 is the only discriminator.
- **Green, post-fix.** `bash logs/scripts/work-loop-lease.test.sh` → `pass=136 fail=0`, exit 0, four consecutive runs. Case 22: `exactly one reclaimer succeeded on the forced late-witness schedule (rc A=2 B=0)`; the loser is `REFUSED (rc=2)` with `state=CONTENDED`; the surviving lease records the winner's pid; its `task`/`checkout`/`program` metadata is complete; no tombstone, claim, or witness residue.
- **Ordinary behaviour still green in the same runs**: case 2 (simultaneous race), 13/14/15 (live, uninspectable, corrupt pids), 16 (stale recovery, no residue), 17 (multi-contender stale race, exactly one winner), 18 (pinned dead holder never reclaimed), 19 (dead reclaimer does not strand), 20a/20b (live and uninspectable reclaimers preserved), 21a–d (reclaim claim fails closed across all three owner states), 3/4/5 (two-resource rollback), 11 (pin evidence, both halves).
- **Syntax:** `bash -n logs/scripts/work-loop-lease.sh` and `bash -n logs/scripts/work-loop-lease.test.sh` both clean.
- **Transports:** `bash scripts/axcion-harness-v0.2/carry-turn.test.sh` → `passed: 423  failed: 0`, exit 0 (2m57s). `bash plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` → `pass=632 fail=0`, exit 0 (8m31s).
- **Public contract untouched:** searched both transports for any use of reclaim internals — `grep -rn --include='*.sh' -e 'reclaiming' -e 'wl-reclaim' -e 'WL_LEASE_WITNESS' -e 'acquire_one'` — no match in `carry-turn.sh` or `dispatch.sh`. They use `wl_lease_init/_acquire/_pin/_release/_status`, plus `wl_lease__read_holder` and `wl_lease__pid_state`; none of those changed, and no return code or `WL_LEASE_*` variable changed.
- `git diff --check` → clean, exit 0. Changed tracked paths in this commit: `logs/scripts/work-loop-lease.sh`, `logs/scripts/work-loop-lease.test.sh`, and this state file. `logs/friction-log.md`, `logs/harness-runs/` and both `audits/working/` review notes were left unstaged and uncommitted.

Deviation from the brief's evidence bound, stated plainly: the brief asked for "the smallest existing carrier and dispatcher test slices" rather than their full suites. Neither suite supports selecting cases — searched both for a filter (`grep -n 'ONLY\|CASE_FILTER\|--only\|SELECT'`), and each runs top to bottom — so no such slice exists to run. Rather than author a bespoke extract, which would be new untested harness code standing in for evidence, I ran the two existing suites unchanged. That is more evidence than the brief required, not less, and it changed nothing in the repository.

Deferrals, recorded and not done: the three Standards findings from the final review (commit-prefix violations needing history rewriting, the duplication smell in transport ownership-admission glue, the `r17` naming) stay outside this unit, exactly as the brief bounds it. Noticed while working and also not done: `case 19`'s comment still describes the `<lease>.reclaiming` marker as a shape "the correction changed", which is now only half true — the marker is written again by the current build. Its assertions are correct and unaffected; the wording is cosmetic and would widen this commit past the defect.

## Blocker

None. The reproduced double-winner race is closed and deterministically protected. Merge remains gated on the narrow independent re-review of this correction, which is Codex's next move.

## Next action

Codex: run the narrow independent re-review of Unit 11 against commit `HEAD`, on the frozen question only — is the reproduced late-lower-PID double-winner race actually closed by the exclusive reclaim claim, does case 22 fail against the pre-fix helper and pass against this one, and did the correction break anything in the shared-lease, carrier or dispatcher suites? Then decide merge.
