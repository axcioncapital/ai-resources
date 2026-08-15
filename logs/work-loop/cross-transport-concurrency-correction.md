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

Inspected (2026-08-15):

- Claim (1): HOLDS — read `wl_lease_acquire` in `logs/scripts/work-loop-lease.sh`. It ran no PID probe of any kind. Both branches were `mkdir <lease-dir>` and, on failure, `wl_lease__read_holder` then `return 2` with `WL_LEASE_REFUSAL` set to `pinned` or `held`. Every existing unpinned lease was refused, including one whose recorded holder was positively absent.
- Claim (2): HOLDS — read all executed cases in `logs/scripts/work-loop-lease.test.sh` (cases 0, 0b, 1–12). Absent entirely: positively-absent recovery, two stale-recovery contenders, and any explicit assertion of a liveness verdict. Only indirectly covered: a live holder (cases 1, 3, 5, 9 hold a live lease but assert only that refusal happens, never why); an uninspectable holder and a missing/unreadable pid (case 8 asserts refusal and non-deletion, but with no verdict to assert against); pinned non-recovery (cases 7, 11, 12 pin from a still-running process, so no case combined a pin with a dead holder). No case used an empty, malformed, zero or zero-prefixed pid at all.
- Claim (3): HOLDS — `survivors` was recognised by `[ -f "$1/survivors" ]` in three places: `wl_lease_acquire` (twice), `wl_lease_status`, and `wl_lease__pin_evidence_ok`, which also requires a `^PINNED by pid ` marker line. Pin evidence is now checked before PID liveness on both the outer and the re-validated inner path, and that ordering is asserted by new case 18.
- Claim (4): HOLDS — `wl_lease_acquire` is called at `scripts/axcion-harness-v0.2/carry-turn.sh:771` and `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh:792`. Both consume the return code plus `WL_LEASE_RESOURCE`, `WL_LEASE_REFUSAL`, `WL_LEASE_SURVIVORS` and the `WL_LEASE_HOLDER_*` fields; neither classifies a pid around that call. Both are unchanged by this unit, and the return-code and metadata contract is unchanged — the two new variables are additive.
- Claim (5): HOLDS — branch `session/2026-08-14-concurrency-fix-2`, checkout `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-concurrency-fix-2`. Pre-existing and operator-owned before any edit: ` M logs/friction-log.md` and `?? logs/harness-runs/`. Neither was staged or committed. The correction plan exists at `f2b19b5d80a061111c39cc7444f90f6374f19d38`.

Result: correction-plan step 1 is implemented. `logs/scripts/work-loop-lease.sh` gained `wl_lease__pid_state`, reproducing the dispatcher's three-state probe (`LIVE` / `ABSENT` / `UNKNOWN`, each with a reason), and `wl_lease__acquire_one`, which both leases now go through. It checks pin evidence first, refuses `LIVE` and `UNKNOWN`, reclaims only `ABSENT`, and reclaims by renaming the stale directory to a unique sibling tombstone and deleting the tombstone — `rm -rf` is never aimed at the live lease path. Two new caller-readable variables, `WL_LEASE_HOLDER_STATE` and `WL_LEASE_HOLDER_REASON`, expose the verdict; return codes and every pre-existing variable are unchanged, and neither caller was touched.

A bare rename is not sufficient arbitration and the harness proved it: one reclaimer can rename the stale lease away, recreate it and write its own pid while a second reclaimer is still acting on an `ABSENT` verdict about a directory that no longer exists — the second then renames away the first's *live* lease and both win. So the rename, the recreate and the holder write happen inside a `<lease>.reclaiming` marker directory that only one reclaimer holds at a time. Ordinary contenders never touch it; their `mkdir` already fails against the fresh lease.

Two deviations from a literal reading of the plan's step-1 bullets, both inside the authorized files and both needed for the completion condition:

1. **A `survivors` entry that is not a readable pin record blocks reclaim.** Adding liveness reclaim broke cases 11 and 12, which pin with the evidence write deliberately blocked by a directory standing where the file belongs. `[ -f survivors ]` is false there, the pinning process has exited, so the lease read as unpinned-with-a-dead-holder and was reclaimed — deleting the one directory still refusing the next run. `-f` still decides the refusal wording and still matches `wl_lease_status`; a wider `-e` test now decides whether reclaim may run at all. Cases 11 and 12 are the regression protection for this.
2. **A bounded reclaim round count (25) with a `CONTENDED` refusal.** Exhaustion refuses; it never admits.

Deferrals, recorded and not done: `wl_lease_status` still reports `HELD` for a lease whose recorded holder is provably dead, so status and acquisition now describe the same lease differently — correcting that is a wording change outside step 1's stated surface. And `dispatch.sh` still carries its own `pid_state` for the paths that do not go through a lease; step 2 is where the carrier is pointed at the shared probe.

Evidence:

- **Failing first, before the helper changed.** `bash logs/scripts/work-loop-lease.test.sh` against the pre-fix helper: `pass=83 fail=14`. Cases 13/14/15 failed on `REFUSED-STATE state=<unset> reason=<unset>` — there was no verdict to read. Case 16 failed with `rc=17 REFUSED ... refusal=held holder_pid=12660` against a pid the harness had just confirmed absent by `kill -0` wording. Case 17 failed `acquired=0 refused=6`: nobody could ever take the stale lease, which is the permanent-strand defect. Case 18 failed on the absent `state=PINNED` verdict. The red run also caught a harness fault of my own first — `kill -0 $p 2>&1 | grep -q` reports the *kill's* failure under `pipefail`, so absence could not be established; fixed by capturing the message and matching it, and the same trap is now avoided inside the library.
- **After the fix.** `bash -n logs/scripts/work-loop-lease.sh logs/scripts/work-loop-lease.test.sh` → exit 0. `bash logs/scripts/work-loop-lease.test.sh` → `pass=97 fail=0`, exit 0, reproduced on four consecutive runs so the race cases are not passing by timing.
- **Exactly one winner after stale recovery.** Case 17 fabricates one stale lease, releases 6 contenders on a barrier, and asserts `acquired=1`, `refused=5`, `other=0`. It fails against the pre-fix helper (`acquired=0`) and would fail against a bare-rename reclaim (`acquired=2`).
- **Survival assertions on the filesystem, not on wording.** Case 13 (`LIVE`) and case 14 (`UNKNOWN`, pid 1 refused by EPERM) assert the directory exists and its `pid` file is byte-identical afterwards. Case 15 does the same for missing, empty, non-numeric, `0` and `007` pids — all `UNKNOWN`, all refused, all surviving. Case 18 fabricates a pin over a provably dead pid and asserts the lease and its `survivors` file both survive and that the verdict is `PINNED`, proving pin evidence outranks liveness rather than following it.
- **No residue.** Case 16 asserts reclaim leaves no `*.stale.*` and no `*.reclaiming` behind, and the repository's own lease root is empty after every run.
- **Neither caller regressed.** `bash scripts/axcion-harness-v0.2/carry-turn.test.sh` → `passed: 371 failed: 0`, exit 0. `bash plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` → `pass=537 fail=0`, exit 0. Both suites were run unmodified.
- **Changed and committed:** `logs/scripts/work-loop-lease.sh`, `logs/scripts/work-loop-lease.test.sh`, and this state file. `logs/friction-log.md` and `logs/harness-runs/` were pre-existing operator-owned changes and were left unstaged.
- **Rollback:** `git revert` the implementation commit, or `git checkout c6f758fe -- logs/scripts/work-loop-lease.sh logs/scripts/work-loop-lease.test.sh`.

## Blocker

None.

## Next action

Codex: assess Unit 1 against correction-plan step 1 — in particular whether the two deviations above are accepted as part of this unit or handed back, and whether the reclaim marker's stranding window is an acceptable limitation to carry. Then close, continue to the next correction step, or correct once.
