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

Standard. Implementation mode. Unit 3a2f — restore the owner suite's dispatcher fixtures by packaging the required shared lease helper.

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

Unit 3a2e established that all six owner-suite failures share one deterministic test-fixture packaging omission: `new_repo()` in `logs/scripts/work-loop-owner.test.sh` copies the owner helper but not the newly mandatory `work-loop-lease.sh`, so every dispatcher-backed case fail-closes at exit 11 before reaching its intended assertion. Production behavior is correct and the assertions remain semantically correct. This unit applies only the smallest correction needed to make those fixtures representative and restore the approved rollout step 4 gate.

Required outcome: update `logs/scripts/work-loop-owner.test.sh` so each `new_repo()` fixture packages the repository's shared lease helper alongside the existing owner helper before `logs/scripts` is staged and committed. Preserve all current expectations, assertion counts, fail-closed production behavior and test intent. Then run the complete ordinary owner-helper suite exactly once and record its exact result.

Prepared implementation boundary from the accepted diagnosis: resolve the lease helper beside the existing owner/dispatcher paths, and copy it into each fixture repository's `logs/scripts/work-loop-lease.sh` inside `new_repo()` before the existing whole-directory `git add`. Claude owns the exact code, but the correction must remain within this one test file.

Evidence required:

- Failing-first evidence is the preserved Unit 3a2d run: exit 1, 86 passed, 6 failed, with all six identical missing-lease exit-11 paths in `logs/harness-runs/owner-suite-unit-3a2d-foreground-20260814.out`.
- Show the exact fixture-packaging diff and why T4 linked worktrees inherit the helper through the fixture base commit.
- Run `logs/scripts/work-loop-owner.test.sh` exactly once after the edit, synchronously in the foreground. Capture complete stdout/stderr and append exactly `SUITE_EXIT=<code>` after termination in `logs/harness-runs/owner-suite-unit-3a2f-postfix-20260814.out`.
- Record exact passed/failed totals and any failing names. The expected gate is the proposal's recorded 92/0 baseline, but report what actually occurs rather than changing assertions to obtain it.
- Confirm the assertion total is unchanged and no assertion or expected exit code was weakened, removed, skipped or rewritten.
- Commit the test correction and this state file. Hand back at `turn: codex` with the implementation commit hash and evidence. A state-only pointer commit may follow if needed to record the hash.

Constraints:

- Allowed implementation surface: `logs/scripts/work-loop-owner.test.sh` only.
- Do not change `dispatch.sh`, `work-loop-owner.sh`, `work-loop-lease.sh`, any production exit code, any assertion expectation, or any Work Loop instruction.
- Do not add a new absent-lease assertion in this unit. The accepted dispatcher suite already covers deliberate exit 11 for an absent lease library; adding adjacent coverage is not required to restore the owner gate.
- Foreground execution is mandatory. Do not use `&`, `nohup`, `disown`, detachment or asynchronous execution, and do not rerun the suite.
- Do not stage or commit the raw harness output.

Open deferrals carried without action: helper pin-file write/copy durability, carrier process-group parameter naming, and the dispatcher suite's lack of a case selector.

Stop and hand back without broadening if the one-file fixture correction cannot restore the intended paths, if any production change appears necessary, or if the post-fix suite remains red. Do not diagnose a new red result inside this unit.

Completion condition: the one test fixture packages the required shared lease helper without weakening assertions; the full owner-helper suite has run once after the edit with durable output and exact totals; the correction and state are committed; no other implementation surface changed; and the task hands back at `turn: codex`.

## Latest result

Inspected (2026-08-14):

- Claim (1) `new_repo()` copies the owner helper but not `work-loop-lease.sh`: HOLDS — read `logs/scripts/work-loop-owner.test.sh` lines 60–81; the only helper copy was `cp "$OWNER_BIN" "$d/logs/scripts/work-loop-owner.sh"`, and `grep -n 'cp "' logs/scripts/work-loop-owner.test.sh` returned no lease copy.
- Claim (2) the shared lease helper exists beside the owner helper: HOLDS — `ls -la logs/scripts/` shows `work-loop-lease.sh` (12250 bytes) alongside `work-loop-owner.sh`.
- Claim (3) `new_repo()` already stages the whole `logs/scripts` directory before committing: HOLDS — line 75 was `git -C "$d" add .gitignore README.md logs/scripts`, so a file copied before it is tracked without a staging change.
- Claim (4) all six Unit 3a2d failures are the same missing-lease exit-11 path: HOLDS — `grep -n FAIL logs/harness-runs/owner-suite-unit-3a2d-foreground-20260814.out` returns exactly six lines (11, 16, 31, 38, 43, 119), and each detail line reads `STOP [11] the shared lease library is missing or unreadable: .../logs/scripts/work-loop-lease.sh`; the file ends `86 passed, 6 failed` / `SUITE_EXIT=1`.
- Claim (5) the fail-closed lease check is production behavior in the dispatcher, not a test artifact: HOLDS — `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` lines 671–682 resolve `$CHECKOUT/logs/scripts/work-loop-lease.sh` and `exit 11` when it is missing or unsourceable.
- Claim (6) the F1 case's expected exit 35 is reachable once the lease is packaged: HOLDS — lines 534–542 remove only `work-loop-owner.sh` from the fixture, so the lease check passes and the missing-owner-helper check is the one that fires.
- Claim (7) `logs/scripts` is not gitignored, so the copied helper is really tracked: HOLDS — searched `.gitignore` for `logs/scripts` and `lease`; the only matches are prose comments at lines 45, 48 and 52, no ignore rule.

Result: Unit 3a2f corrected the owner suite's fixture packaging in `logs/scripts/work-loop-owner.test.sh` only. Two hunks: a `LEASE_BIN="${LEASE_BIN:-$HERE/work-loop-lease.sh}"` resolution beside the existing `OWNER_BIN`/`DISPATCH_BIN` lines, and one `cp "$LEASE_BIN" "$d/logs/scripts/work-loop-lease.sh" 2>/dev/null || true` inside `new_repo()`, placed after the owner-helper copy and before the existing `git add ... logs/scripts`. T4's linked worktrees inherit the helper without their own copy because `add_worktree()` runs `git worktree add -q "$p" -b "$name" main`, and `main` is the fixture base commit that now tracks `logs/scripts/work-loop-lease.sh`. No production file, exit code, assertion, expectation or Work Loop instruction was touched; no assertion was skipped, weakened or added.

Evidence: the full owner-helper suite ran exactly once after the edit, synchronously in the foreground — `bash logs/scripts/work-loop-owner.test.sh` — with complete stdout/stderr and a trailing `SUITE_EXIT=0` in `logs/harness-runs/owner-suite-unit-3a2f-postfix-20260814.out` (untracked, not staged). Result **92 passed, 0 failed**, exit 0, matching the proposal's recorded baseline; `grep -c '  FAIL'` on that output returns 0. Before: the preserved Unit 3a2d run in `logs/harness-runs/owner-suite-unit-3a2d-foreground-20260814.out` was 86 passed / 6 failed, exit 1. The assertion total is unchanged at 92 (86 + 6 = 92 before, 92 + 0 = 92 after) — the six previously failing named cases pass rather than having disappeared. The suite remains able to fail: its own Case 0 points the run at an absent helper and asserts the suite fails, and it passed in this run.

Accepted Unit 3a2e diagnosis: all six Unit 3a2d failures are caused by `new_repo()` omitting `work-loop-lease.sh`; production is not implicated. Every affected dispatcher fixture exits 11 before lock or ownership behavior. Smallest justified correction is one test file: resolve the lease helper and copy it into `new_repo()` before the existing fixture commit. State commit `4085ab54`, pointer `b9144b30`.

Unit 3a2d failing-first evidence: complete owner suite **86/6**, exit 1, against baseline 92/0; raw output `logs/harness-runs/owner-suite-unit-3a2d-foreground-20260814.out`; state `58e1ed25`, pointer `72f240a0`.

Accepted regression evidence: dispatcher **482/0**, exit 0 (`59d095a8` / `e2a39065`); carrier **316/0**, exit 0 (`8be728e9` / `f9125746`); shared lease helper suite **50/0** from its implementation unit.

Accepted implementation through Unit 3a2a remains: shared helper and dispatcher through `5255628a`; carrier shared lease at `04de80a7`; carrier pin correction at `2bef1acf`; cross-transport fixture correction at `33d90df9` with pointer `50874ea2`, targeted 21/0 and stale-oracle mutant 19/2.

## Blocker

None.

## Next action

Codex: assess Unit 3a2f. The rollout step 4 owner gate is restored at 92/0, exit 0, with the correction confined to `logs/scripts/work-loop-owner.test.sh` and no assertion changed. Decide close, continue to the next Phase 1 unit, or correct once. Deferrals carried without action are unchanged: helper pin-file write/copy durability, carrier process-group parameter naming, and the dispatcher suite's lack of a case selector. One deferral is added by this unit: the owner suite's `new_repo()` now duplicates the dispatcher's own helper-packaging knowledge in a second place, so a future third shared helper would silently reproduce this same failure — not done now because a shared fixture-packaging routine is outside this unit's one-file boundary.
