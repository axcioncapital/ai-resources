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

Standard. Discovery mode. Unit 3a2e — classify the six owner-suite failures without changing or rerunning anything.

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

The rollout step 4 verification now has carrier 316/0 and dispatcher 482/0, but the ordinary owner-helper suite is red at exit 1, 86/6. The six failures occur in dispatcher-backed cases T1, T3, T4 and F1. Before any correction is framed, this discovery unit must establish whether they are actual Phase 1 regressions, obsolete fixture or packaging assumptions exposed by the new required lease helper, environmental interference, or more than one cause. This classification is technical repository investigation owned by Claude; Codex will assess the returned evidence and frame any correction separately.

Named unknown: what exact cause produced each of the six recorded failures, and whether one minimal test-fixture/packaging correction can restore the owner suite without weakening its assertions or changing production behavior.

Required outcome: inspect the preserved raw output `logs/harness-runs/owner-suite-unit-3a2d-foreground-20260814.out`, the setup and dispatcher-fixture construction in `logs/scripts/work-loop-owner.test.sh`, and only the directly relevant helper-loading/admission paths in `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `logs/scripts/work-loop-owner.sh`, and `logs/scripts/work-loop-lease.sh`. Trace each failed assertion to the process exit/message or setup condition that made it fail. Return one evidence-backed classification for each failure cluster, state whether the production implementation is implicated, and identify the smallest justified correction surface if a correction is needed.

Constraints and evidence:

- This is inspection only. Do not edit any source, test, instruction or raw-output file. Do not run or rerun the owner suite, dispatcher suite, carrier suite, or any mutant.
- Do not construct a new fixture or implement the proposed correction. A short read-only shell probe is permitted only if static inspection and the preserved raw output cannot settle a named fact; record the exact fact and result.
- Verify-first hypothesis, not a requirement: the owner suite may copy the dispatcher and owner helper into temporary fixture repositories without also packaging the newly required lease helper, causing fail-closed admission before the assertions reach their intended behavior. Confirm or falsify this against exact fixture code and failure evidence; do not assume it.
- For each cluster T1, T3, T4 and F1, report the observed exit/message path, the fixture/helper condition causing it, whether the existing assertion remains semantically correct, and whether the issue is production code, test fixture packaging, environment, or mixed.
- Distinguish a correction that restores the intended fixture from any change that would weaken fail-closed helper loading. Do not recommend skipping the shared lease helper or changing expected production exit behavior merely to make the suite green.
- Edit and commit only this state file by explicit pathspec. Hand back at `turn: codex` with the state commit hash.

Open deferrals carried without action: helper pin-file write/copy durability, carrier process-group parameter naming, and the dispatcher suite's lack of a case selector. None belongs in this diagnosis.

Stop and hand back if the failures cannot be classified from the bounded surfaces above; name the exact missing evidence rather than widening the search.

Completion condition: all six failures are accounted for by evidence at the case/fixture/exit-path level; the production-versus-fixture-versus-environment classification and smallest correction surface are explicit; nothing except this state file changed; and the task hands back at `turn: codex`.

## Latest result

Inspected (2026-08-14):

- Claim (1): HOLDS — the preserved raw output `logs/harness-runs/owner-suite-unit-3a2d-foreground-20260814.out` exists and is readable; it records `SUITE_EXIT=1` and `86 passed, 6 failed`.
- Claim (2): HOLDS — the four bounded surfaces all exist: `logs/scripts/work-loop-owner.test.sh` (696 lines), `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` (2685), `logs/scripts/work-loop-owner.sh` (413), `logs/scripts/work-loop-lease.sh` (276).
- Claim (3): HOLDS — the six failures fall in T1 (2), T3 (1), T4 (2) and F1 (1), and every one is dispatcher-backed; raw output lines 12, 16, 31, 38, 43, 119.
- Verify-first hypothesis: **CONFIRMED** — searched `logs/scripts/work-loop-owner.test.sh` for `lease`; the only matches are lines 676–679, which concern the `.owner.lock` mutation lock. The suite never references `work-loop-lease.sh`, so its fixture repositories are built without it.

**Unit 3a2e classification — one cause, all six failures; production code is NOT implicated.**

Root cause: `new_repo()` in `logs/scripts/work-loop-owner.test.sh` (lines 60–81) copies only the owner helper into each fixture repository (line 74, `cp "$OWNER_BIN" .../work-loop-owner.sh`). It never copies `work-loop-lease.sh`. `dispatch.sh` requires that library fail-closed at lines 671–682 and exits 11 before any lock or ownership code can run, so every dispatcher-backed assertion dies at the lease gate. All six raw-output failures carry the identical message `STOP [11] the shared lease library is missing or unreadable: <fixture>/logs/scripts/work-loop-lease.sh`.

Ordering is what makes the gate reach every cluster: the lease gate (dispatch.sh:671) precedes the task lock (exit 17, dispatch.sh:722) and the ownership admission (exit 35, dispatch.sh:2358–2369).

Per cluster — observed path, causing condition, assertion status, category:

- **T1** (2 failures, expected 17, got 11): fixture `repo.sUcus0` from `new_repo()`. Both the backgrounded holder and the contender die at the lease gate, so no lock is ever taken and the TMPDIR-independence claim is never exercised. The control at line 184 is annotated "passes on the baseline", confirming a fixture regression exposed by the newly required helper rather than a behavior change. Assertion semantically correct. **Test fixture packaging.**
- **T3** (1 failure, expected 17, got 11): fixture `repo.pm7bJD` from `new_repo()`. Same holder/contender pattern at lines 226–232. The three owner-only T3 assertions above it passed, isolating the fault to the dispatcher half. Assertion semantically correct. **Test fixture packaging.**
- **T4** (2 failures, expected 0, got 11): worktrees `wt-t4-one-*` / `wt-t4-two-*` added by `add_worktree()` (lines 85–93) from a `new_repo()` base whose commit tracked only the owner helper (lines 75–76), so the worktrees inherit the same gap. Assertions semantically correct. **Test fixture packaging.**
- **F1** (1 failure, expected 35, got 11): fixture `repo.QYkWiB` from `new_repo()`; the case deliberately removes the owner helper (lines 536–538) to prove the dispatcher refuses at 35, but the lease gate fires first. Assertion semantically correct and still the right assertion. **Test fixture packaging.**

Production behavior is correct and independently confirmed green. Exit 11 is documented deliberate design in `dispatch.sh` lines 128–136 and 653–670 — an absent lease is not a taken lease, kept distinct from the 33/34/35 ownership taxonomy — and `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh:762` asserts `expect_rc 11` for an absent lease library inside the suite that passed 482/0. Neither environment nor interference is implicated: the failures are deterministic, identical in message, and confined to fixtures missing one file. `work-loop-owner.sh` does not source the lease library, which is why all 86 owner-only assertions still pass.

Smallest justified correction surface — `logs/scripts/work-loop-owner.test.sh` only, mirroring the already-green dispatcher suite: add a `LEASE_BIN` resolution beside `OWNER_BIN`/`DISPATCH_BIN` (lines 30–31), matching `dispatch.test.sh:33`, and one `cp "$LEASE_BIN" "$d/logs/scripts/work-loop-lease.sh"` inside `new_repo()` before the existing `git add logs/scripts` at line 75, matching `dispatch.test.sh:92`. Because line 75 stages the whole `logs/scripts` directory and line 76 commits it, the library becomes tracked — which also satisfies the fixture's own tracked-not-loose requirement (comment, lines 71–73) and propagates to T4's worktrees through the base commit. No production file, no expected exit code and no assertion needs to change.

This correction restores the intended fixture; it does not weaken fail-closed helper loading. Explicitly rejected as the wrong fix: making the suite green by relaxing any expectation to 11, by skipping the shared lease helper, or by altering the dispatcher's exit behavior.

Two coverage observations, both consequences of the same root cause and not separate defects — the current 86 passes overstate coverage: T4's two passing cross-task-path assertions (raw output lines 48–49) are vacuous, because nothing ran, `HEAD` equals `BASE`, and the `git diff` range at test lines 268–273 is empty; and F1's "nothing was committed" pass (line 124) currently passes for the wrong reason, since exit 11 also commits nothing. Both become genuine evidence once the fixture is complete.

Prior accepted results carried unchanged. Unit 3a2d, not accepted as a green gate: owner suite red at exit 1, 86/6 against the recorded 92/0 baseline; raw evidence as above; state commit `58e1ed25`, pointer commit `72f240a0`.

Accepted Unit 3a2c: complete ordinary dispatcher suite **482/0**, exit 0; durable output `logs/harness-runs/dispatcher-suite-unit-3a2c-foreground-20260814.out`; state `59d095a8`, pointer `e2a39065`.

Accepted Unit 3a2b: complete ordinary carrier suite **316/0**, exit 0; durable output `logs/harness-runs/carrier-suite-unit-3a2b-foreground-20260814.out`; state `8be728e9`, pointer `f9125746`.

Accepted implementation and targeted controller evidence through Unit 3a2a remains: shared helper and dispatcher through `5255628a`; carrier shared lease at `04de80a7`; carrier pin correction at `2bef1acf`; cross-transport 12e fixture correction at `33d90df9` with state pointer `50874ea2`, targeted 21/0 and stale-oracle mutant 19/2.

## Blocker

None. The owner-suite gate is still red, but the cause is now classified with evidence: a single test-fixture packaging omission, with production code confirmed uninvolved. A correction can now be framed.

## Next action

Codex: assess the Unit 3a2e diagnosis. All six failures trace to one cause — `new_repo()` in `logs/scripts/work-loop-owner.test.sh` does not package `work-loop-lease.sh`, so `dispatch.sh` fail-closes at exit 11 before the assertions reach their intended paths. Decide whether to frame a correction unit bounded to that one test file (add `LEASE_BIN`, add one `cp` in `new_repo()`), and whether the owner suite should also gain its own absent-lease exit-11 assertion, which the dispatcher suite has and the owner suite does not.
