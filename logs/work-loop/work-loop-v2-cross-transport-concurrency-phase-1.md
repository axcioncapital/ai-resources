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

Standard. Implementation mode. Unit 3b2r — implement carrier ownership admission with ownership-valid ordinary fixtures.

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

Unit 3b1 is accepted failing-first evidence at 333/17 over 350 assertions. The first 3b2 brief correctly stopped on a false premise before implementation: globally packaging the owner helper makes old section 12b controls encounter a replicated-state AMBIGUOUS condition they were written before ownership admission to model. The approved proposal already settles that condition as a refusal. This corrected brief preserves section 12b's distinct over-refusal controls by establishing valid ownership when admission is intended and restoring a unique state location before the final main-checkout control.

Required production outcome: make `scripts/axcion-harness-v0.2/carry-turn.sh` run the checkout's `logs/scripts/work-loop-owner.sh check --depth repo --checkout <checkout> --task <task>` after both live leases are acquired and before any actor launch. Map PROCEED/0 to continue, REFUSE/3 to carrier exit 33, AMBIGUOUS/4 to exit 34, and missing/unreadable/failed/unrecognized helper results to exit 35. Preserve the helper's reason on 33/34, fail closed on 35, launch no actor on any ownership stop, write no declaration, and release both leases through existing cleanup.

Required fixture reconciliation in `scripts/axcion-harness-v0.2/carry-turn.test.sh`:

- Ordinary `mkfix` repositories package and track the real owner helper.
- Section 12e's missing-helper case removes the tracked helper from both the fixture index and disk before launch, so it reaches ownership exit 35 without creating an out-of-allowlist deletion.
- In section 12b, after the task lease is removed and before the linked-worktree admission control, use the real owner helper's local claim operation to declare task `task-bb` in that linked worktree. The control may then prove: task lease free + ownership settled in this checkout → admitted. Update only the assertion wording/comments needed to state that prerequisite; do not change its expected exit 0 or launch count.
- Preserve the section 12b check that checkout X's still-live legacy lock refuses at exit 17; lease admission remains first, so that refusal precedes ownership.
- Remove the linked worktree after that live-lock refusal and before the final main-checkout no-holder control. With the linked copy gone, the main checkout again has the unique state file, so repo-depth ownership PROCEED and the existing exit-0 control is legitimate.
- Preserve the 350-assertion total. Do not delete or skip the section 12b controls or weaken section 12e's replicated-state AMBIGUOUS case.

Evidence required:

- Preserve the Unit 3b1 raw red evidence: `logs/harness-runs/carrier-owner-admission-red-unit-3b1-20260814.out`, 333/17, exit 1.
- Show production placement, the 0/3/4/catch-all mapping, and cleanup path.
- Show ordinary helper packaging, the genuine missing-helper removal, the local ownership declaration used by section 12b, and linked-worktree removal ordering.
- Run the complete ordinary carrier suite exactly once after implementation, synchronously in the foreground. Capture complete stdout/stderr plus `SUITE_EXIT=<code>` in `logs/harness-runs/carrier-owner-admission-green-unit-3b2r-20260814.out`.
- Record exact totals and failures. Acceptance target is the unchanged 350/0; report actual behavior and stop without diagnosis if red.
- Confirm no assertion was deleted, skipped or weakened and no production surface outside the carrier changed.
- Commit the two bounded code/test files and this state file; hand back at `turn: codex` with the implementation commit hash. A pointer commit may follow.

Constraints: only `scripts/axcion-harness-v0.2/carry-turn.sh` and `scripts/axcion-harness-v0.2/carry-turn.test.sh` may change beyond state. Do not change helpers, dispatcher, instructions, executable core, carrier boundaries, test selector behavior or raw evidence. Run the suite once, foreground only; no rerun or detached execution.

Open deferrals carried without action: helper pin-file write/copy durability, carrier process-group parameter naming, dispatcher case selection, duplicated fixture-packaging knowledge, and explicit broken-owner-helper coverage.

Stop if the corrected ownership-valid fixtures still conflict with a frozen assertion, if cleanup cannot release both leases, if any broader production change is required, or if the full suite remains red.

Completion condition: carrier ownership admission with 33/34/35 is implemented before actor launch; section 12b and 12e fixtures express valid and invalid ownership conditions without contradictory expectations; the unchanged 350-assertion suite has run once with durable evidence; bounded files/state are committed; and the task hands back at `turn: codex`.

## Latest result

Inspected (2026-08-14):

- Claim (1): HOLDS — read `scripts/axcion-harness-v0.2/carry-turn.sh`; `acquire_lock` (legacy lock, then `wl_lease_acquire carry`) runs at line 1400 and `launch_actor` at line 1495 in the pre-change file, so a placement after `validate_state` is after both live leases and before any actor launch.
- Claim (2): HOLDS — searched the same file for its exit taxonomy (`die N` / `exit N` / `result_line`); the used set is 0 10 11 12 13 14 15 16 17 18 19 20 24 25 26 28 30 and 37, so 33, 34 and 35 are free.
- Claim (3): HOLDS — read `logs/scripts/work-loop-owner.sh`; `check|claim|clear`, `--checkout/--task/--depth local|repo`, and `verdict()` maps PROCEED→0, REFUSE→3, AMBIGUOUS→4; usage/argument failures use 10/11/12.
- Claim (4): HOLDS — read `die()` at carry-turn.sh line 296; it calls `release_lock` → `wl_lease_release` before exiting, so 33/34/35 release both leases through the existing cleanup with no new path.
- Claim (5): HOLDS — read `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` lines 2335–2370; the carrier's messages are that block's own wording ("ownership refused for task", "ownership is AMBIGUOUS for task", "the ownership check is unavailable").
- Claim (6): HOLDS — read `carry-turn.test.sh`; `mkfix` packaged only `work-loop-lease.sh`, `add_owner_helper` existed separately, and section 12e case 19 asserted the helper's absence rather than removing it.
- Claim (7): HOLDS — read section 12b lines 934–956; the over-refusal control ran against a linked worktree holding a replicated `task-bb.md` with no declaration, which repo-depth ownership settles as AMBIGUOUS, and the final main-checkout control ran while that worktree still existed.
- Claim (8): HOLDS — `logs/harness-runs/carrier-owner-admission-red-unit-3b1-20260814.out` is present and unmodified; line 430 reads `passed: 333   failed: 17` and line 449 `SUITE_EXIT=1`, i.e. 350 assertions.
- Claim (9): HOLDS — searched `carry-turn.sh` for `ALLOW_PATHS=(`; the default set is `^logs/work-loop/ ^logs/harness-runs/`, so an untracked `logs/work-loop/.owner` written by a fixture claim is inside the allowlist and cannot cause a spurious exit 18.

Result: Unit 3b2r is implemented and the complete ordinary carrier suite is green at the unchanged 350 assertions, 0 failures, exit 0. Carrier ownership admission now runs after both live leases and before any actor launch; the section 12b and 12e fixtures express valid and invalid ownership conditions without contradictory expectations.

Evidence:

- Production placement — `scripts/axcion-harness-v0.2/carry-turn.sh` lines 1429–1466, immediately after `validate_state`/`R_BEFORE` and before the restart-safety block, therefore after `acquire_lock` (line 1400) and before `launch_actor`. Mapping: `0` → `say "ownership: PROCEED — …"`; `3` → `die 33` "ownership refused for task"; `4` → `die 34` "ownership is AMBIGUOUS for task"; catch-all `*` → `die 35` "the ownership check ran and failed (exit N)"; missing or unreadable helper → `die 35` "the ownership check is unavailable". Cleanup path: every stop is `die`, which calls `release_lock` → `wl_lease_release`, so both leases are released and no actor is launched and no declaration written. Exit codes 33/34/35 are documented in the header taxonomy and named as shared with the dispatcher.
- Fixture reconciliation — `mkfix` now copies and tracks `$OWNER_BIN` beside the lease library. Section 12e case 19 removes the tracked helper genuinely (`git rm --cached` + `rm -f` + commit, mirroring 12c's lease-library removal), so the working tree stays clean and the run reaches ownership rather than exit 18. Section 12b declares `task-bb` in the linked worktree with the helper's own `claim --depth local` before the over-refusal control — local, because at repo depth `claim` reads the same replicated state as AMBIGUOUS and writes nothing. The linked worktree is removed immediately after the still-live legacy-lock refusal and before the final main-checkout control, which restores the unique-state-file condition that ownership admits.
- Suite run — one foreground run after implementation: `logs/harness-runs/carrier-owner-admission-green-unit-3b2r-20260814.out`, `passed: 350   failed: 0`, `SUITE_EXIT=0`. Section 12b shows "with the task lease free and ownership settled the worktree IS admitted" and "with no live holder the second task carries normally"; section 12e shows 35 for the absent helper, 33 for REFUSE, 34 for AMBIGUOUS, each with zero launches and no commit, plus the present-helper control carrying at 0.
- Fail capability — the red evidence from Unit 3b1 is the same suite at 333/17, exit 1, against the same 350 assertions with no production change. The only difference between the two runs is this unit's production block and the fixture reconciliation, so the green run could have read differently and did.
- No assertion deleted, skipped or weakened — `assert_eq` 155, `assert_contains` 176, `assert_absent` 32, inline `ok` 4, inline `bad` 14, identical at `HEAD` and in the working tree; the totals still sum to 350.
- Implementation commit — `52ecf472`, carrying `carry-turn.sh`, `carry-turn.test.sh` and this state file and nothing else.
- No production surface outside the carrier changed — `git status --porcelain` shows only `scripts/axcion-harness-v0.2/carry-turn.sh`, `scripts/axcion-harness-v0.2/carry-turn.test.sh` and this state file as this unit's work. `logs/friction-log.md` was already modified before this unit began and was not touched or staged; `logs/harness-runs/` remains untracked, as it was for the Unit 3b1 red evidence.

Prior accepted evidence, unchanged: Unit 3b1 red at 333/17 (test commit `b883c3f6`, pointer `2a8aba9b`); first Unit 3b2 false-premise handback (state commit `eb17cb49`); dispatcher 482/0, carrier 316/0, owner helper 92/0, shared lease helper 50/0; implementation commits `e859d377`, `5255628a`, `04de80a7`, `2bef1acf`, `33d90df9`.

Deferrals carried without action, plus one noticed in this unit: helper pin-file write/copy durability; carrier process-group parameter naming; dispatcher case selection; duplicated fixture-packaging knowledge — now more visible, because `add_owner_helper` is redundant with `mkfix` for the three 12e fixtures that still call it, and the two places that know how to package a helper could be one; explicit broken-owner-helper coverage — the `*` catch-all arm (exit 35, "ran and failed") has production code but no case in the ordinary suite, since only the missing-helper arm is exercised.

## Blocker

None.

## Next action

Codex: assess Unit 3b2r against its completion condition — carrier ownership admission implemented before actor launch with the 0/3/4/catch-all mapping and fail-closed 35; section 12b and 12e fixtures ownership-valid without contradictory expectations; the unchanged 350-assertion suite green at 350/0, exit 0, from one foreground run; bounded files and state committed. Then decide close, continue, correct once, or stop, and say whether the two authorized live validations open next.
