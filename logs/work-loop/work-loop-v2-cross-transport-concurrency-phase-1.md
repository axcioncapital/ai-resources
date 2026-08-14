---
task: work-loop-v2-cross-transport-concurrency-phase-1
turn: codex
---

## Objective and scope

Implement and validate Phase 1 of the accepted Work Loop v2 cross-transport concurrency proposal: one shared repository-rooted live-lease contract used by the attended carrier and unattended dispatcher, plus fail-closed repository-depth ownership admission before the carrier launches an actor. Complete the controller-level acceptance coverage, preserve both transports' intentional boundaries and existing behavior, make only the necessary Work Loop instruction updates, and run the two explicitly authorized live validations after the implementation has passed independent assessment.

Task exit condition: the Phase 1 implementation and required instruction changes are committed in this worktree, the relevant controller suites and failure paths pass, one genuine cross-transport contention proof and one genuine fan-out-two Work Loop pair produce the accepted evidence, and the final limitations and rollback path are recorded for an operator integration decision.

Scope: the Phase 1 files and test surfaces named in `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-and-task-aware-worktrees-implementation-proposal-2026-08-13.md`, plus this state file. Temporary linked worktrees may be created only when the approved live validations require them; implementation remains bound to this checkout.

Excluded: Phase 2 task-aware automatic worktrees; changing or replacing D4; changes to the executable core; automatic merge, landing, push, branch deletion, worktree cleanup or other destructive cleanup; a scheduler, registry, service or lease database; and concurrency outside Work Loop v2. No work is performed in the main checkout.

## Lane and unit

Standard. Implementation mode. Unit 3a2a — correct the stale carrier-lease oracle in the dispatcher test and close only the existing 12e cross-transport controller slice.

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

Unit 3a1 recovery is accepted. Commit `2bef1acf` (state pointer `eac0f563`) makes unproven carrier shutdown pin both owned leases, preserves release on proven shutdown, and refuses a second carrier with exit `17`. Its isolated slice passed 18/0 and its pin-call mutant failed 10 assertions; syntax passed. Codex accepts the single inspection-only unknown-reason branch because it is conservative, adds no admission path, and the tested visible-survivor and unavailable-census branches cover the safety invariant.

This unit fixes one stale test oracle before any broad verification. `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` still defines `carrier_lock_for` as the removed `${TMPDIR}` legacy lock even though both transports now use the accepted shared repository-rooted lease helper. Cases 12e-1 and 12e-3 therefore inspect a directory the carrier no longer creates. The cross-transport behaviors themselves are already encoded in 12e-1 through 12e-4; do not redesign or expand that matrix.

Governing authority: the approved proposal §§ 4.1–4.5, acceptance cases 3, 4, 7, 8 and 11 in §§ 5.1–5.3, and rollout § 7 step 3. The accepted helper contract and both production transports are fixed inputs for this unit.

Required outcome: replace only the stale test-side carrier lease-path derivation with an independent oracle for the carrier's current shared task and checkout lease locations, and update only comments or setup assertions made false by that migration. The four existing 12e cases must prove both acquisition directions across checkout and task resources, exit `17`, no second actor launch, and no commit by the refused run.

Check before editing:

1. Confirm from the current helper and carrier which shared directory 12e-1 must observe for a carrier-held checkout lease and which directory 12e-3 must observe for a carrier-held task lease.
2. Confirm the test oracle remains independent: it may mirror the accepted derivation but must not source or call the production helper to assert that helper's own output.
3. Confirm whether any 12e setup comment still describes the removed temporary-directory behavior. Change only comments/setup assertions necessary to make the test truthful now; do not alter expected refusal behavior to obtain green.

Evidence:

- The durable failing baseline is already recorded: the complete dispatcher run at `5255628a` had 11 failures, all in 12e, and Unit 3a1 recorded that `carrier_lock_for` still pointed at the removed legacy path. Do not reconstruct a historical red run.
- Run `bash -n` on the changed test file.
- Run only the smallest isolated slice containing existing cases 12e-1 through 12e-4, with their required fixture preamble. Report exact pass/fail totals and the assertions each case covers.
- Show the fixture can distinguish task from checkout lease paths and that the two setup assertions now observe the live carrier-held shared lease before the opposing transport starts.
- Commit only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` and this state file by explicit pathspec. Report committed paths and the commit hash, then hand back at `turn: codex`.

Codex framing boundaries: no production code, helper changes, carrier test changes, broad dispatcher or carrier suite, ownership admission, ownership-compatible redesign of future fixtures, M6, instruction edits, controller-wide acceptance or live validation. These are held back so this unit has one fixture correction and one proportionate evidence slice.

Recorded deferrals, not part of this unit:

- The accepted helper sets its process-local pinned flag before writing `survivors`, but the write/copy are error-suppressed and the function returns success. If durable pin-file creation failed, ordinary cleanup would skip release in the current process, yet a later process might see a dead holder without durable pin evidence and clear it. This was not introduced by Unit 3a1; assess it in a separate bounded helper-hardening unit before live validation or record it explicitly as an accepted limitation.
- Unit 3a1 noted that `terminate_actor_group "$pid"` relies on the actor being launched into a same-valued process group. Hold the naming/readability improvement back unless later evidence shows a functional defect.

Stop and hand back if closing 12e requires production changes, ownership work, a new fixture architecture, or rewriting expected outcomes. Challenge a false premise rather than broadening.

Completion condition: the stale carrier lock oracle is corrected without coupling the test to production helper execution; syntax passes; the isolated existing 12e-1 through 12e-4 controller slice passes and proves live shared-lease contention in both directions without second launches or commits; only the dispatcher test and state file are committed; and the state hands back at `turn: codex`.

## Latest result

Inspected (2026-08-14):

- Brief premise, stale oracle: HOLDS — read `dispatch.test.sh` 167-171; `carrier_lock_for` printed `${TMPDIR:-/tmp}/axcion-harness-v0.2.<sha16 canonical checkout>.lock`, the removed legacy path. Its only callers were the 12e-1 and 12e-3 setup assertions (565, 642).
- Claim (1), which directories 12e-1 and 12e-3 must observe: HOLDS — read `carry-turn.sh` 408 (canonicalizes `CHECKOUT`) and 696 (`wl_lease_init "$CHECKOUT" "$TASK"`), then `logs/scripts/work-loop-lease.sh` 119-130. The carrier's leases are `<git-common-dir>/work-loop-dispatch-locks/checkout-<sha16 canonical checkout>.lock` and `.../task-<sha16 task>.lock`. `dispatch.sh` 503 and 685 pass through the identical derivation, so 12e-1 must observe the CHECKOUT lease (the dispatcher runs a different task in the same tree) and 12e-3 the TASK lease (the dispatcher runs in a different checkout).
- Claim (2), oracle independence: HOLDS — searched `dispatch.test.sh` for `work-loop-lease.sh` and `wl_lease_`; the four matches are fixture copy-in (33, 92) and case 12f's deliberate removal (732-733). No oracle sources or calls the library; `lock_root_for`/`task_lock_for`/`checkout_lock_for` mirror the derivation with `git rev-parse --git-common-dir` and `shasum` only.
- Claim (3), stale comments: FOUND TWO — the `carrier_lock_for` header (162-166) described the `${TMPDIR}` key as current, and the case 12e header (532-543) asserted "all four must FAIL against the code as it stands" and cited the two-blind-transports state as present tense. Both are now false. Verified the underlying facts before rewriting: `carry-turn.sh` has 0 occurrences of `work-loop-dispatch-locks` (it reaches the root through the library) and 1 of `axcion-harness-v0.2.` (line 727, the refusal-only `legacy_lock_check`); `dispatch.sh` has 0 of `axcion-harness-v0.2.`.

Result: the stale carrier oracle is deleted rather than re-pointed. Both transports now resolve leases through one shared derivation, so the existing `checkout_lock_for` and `task_lock_for` answer for both — 12e-1 observes `checkout_lock_for "$d"`, 12e-3 observes `task_lock_for "$WT" xt-shared`. Comments at the mirror block, the removed-oracle site and the 12e header were corrected to describe the post-change state. No production file, no expected exit code, no launch count and no HEAD assertion was touched.

Evidence:

- `bash -n plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` — clean. `grep -c carrier_lock_for` — 0.
- Isolated slice: preamble (lines 1-252) + the 12e block (537-731) + a pass/fail footer, run with the fixture preamble `REPO_ROOT`/`DISPATCH_BIN`/`OWNER_BIN`/`LEASE_BIN`/`CARRY_BIN` exported. **pass=21 fail=0, exit 0.** Coverage: 12e-1 checkout-lease setup, dispatcher exit 17, no actor, no commit, plus the control that the holding carrier did launch (5); 12e-2 dispatcher-checkout setup, carrier exit 17, no actor, no commit (4); 12e-3 ownership claim, worktree replication, task-lease setup, dispatcher exit 17, no actor, no commit, holding-carrier control (7); 12e-4 ownership claim, dispatcher task-lease setup, carrier exit 17, no actor, no commit in the worktree (5).
- The fixture distinguishes the two resources: for this checkout the oracles return `.../task-a962de0d108a7487.lock` and `.../checkout-0d1f538516e4119f.lock` — different names under one root, and that root resolves to the MAIN checkout's `.git`, which is the property that lets a lease taken in a linked worktree be seen from another.
- Falsifiable, and shown failing: a mutant that reinstates the `${TMPDIR}` oracle and points only the two corrected setup assertions back at it scores **pass=19 fail=2**, failing exactly the 12e-1 checkout-lease and 12e-3 task-lease setup assertions and nothing else. That is the direct proof the assertions observe a lease the carrier really takes, that the old path is one nothing writes, and that the edit changed the oracle without disturbing the behaviour matrix.
- Earlier accepted limitation from Unit 3a1 stands unchanged: the census-names-nobody-but-group-answers branch is inspection-only, fail-closed, and does not block progression.

Deferrals noticed in this unit, not implemented:

- The slice is assembled by line-range extraction and needs five environment variables supplied by hand, because the suite has no case filter. A first run without them silently retargeted `REPO_ROOT` to `/` and reported 12 failures that had nothing to do with the code. A `--only <case>` filter would remove a real repeat hazard for every future slice; held back as out of this unit's fixture-correction scope.
- Both deferrals carried in the brief (the error-suppressed pin-file write, and `terminate_actor_group` naming) are untouched and still open.

## Blocker

None.

## Next action

Codex: assess Unit 3a2a. The stale carrier oracle is removed rather than re-pointed, on the finding that one shared derivation now serves both transports; judge whether deleting the carrier-specific helper is the right shape or whether a named carrier oracle should survive for readability. Confirm the 12e-1 checkout-lease and 12e-3 task-lease choices match the resource each case actually contends on, and that the 21/0 slice plus the 19/2 targeted mutant is sufficient evidence at this consequence. Then decide whether to close this unit and open the next Phase 1 unit — the recorded candidates are the helper-hardening assessment of the error-suppressed pin write, and the broader controller verification the brief held back.
