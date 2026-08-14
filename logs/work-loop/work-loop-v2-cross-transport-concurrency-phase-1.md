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

Standard. Implementation mode. Unit 3b1 — freeze the carrier's repository-depth ownership admission as failing controller tests.

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

Controller rollout step 4 is restored and accepted: carrier 316/0, dispatcher 482/0, owner helper 92/0, and shared lease helper 50/0. A direct bounded source search now confirms the next approved implementation gap: `scripts/axcion-harness-v0.2/carry-turn.sh` has no invocation of `work-loop-owner.sh check --depth repo` and no ownership exits 33/34/35. The proposal requires that admission before any carrier actor launch. This first test-first unit freezes the three required failure paths without changing production code.

Required outcome: add focused controller cases to `scripts/axcion-harness-v0.2/carry-turn.test.sh` that prove the current carrier lacks all three required repository-depth ownership stops:

1. Ownership helper missing or unreadable: carrier must exit 35 and launch no actor.
2. Repository-depth ownership verdict REFUSE: carrier must exit 33 and launch no actor.
3. Repository-depth ownership verdict AMBIGUOUS: carrier must exit 34 and launch no actor.

Each case must use isolated fixtures and the harness's sanctioned stub-binary route, assert the exact exit code, assert zero actor launches, and retain enough output evidence to distinguish the ownership stop from lease refusal or ordinary actor failure. The expectations come directly from approved proposal §4.4 and §5.5 cases 19–20; do not redesign them.

Evidence required:

- Verify first that the bounded carrier source has no repository-depth ownership invocation or 33/34/35 mapping. If that premise is false, stop and hand back without adding tests.
- Show the exact new test cases and why each fixture reaches its intended ownership condition while the shared lease helper remains present and usable.
- Run the complete ordinary carrier suite exactly once after adding the tests, synchronously in the foreground, capturing complete stdout/stderr and appending `SUITE_EXIT=<code>` to `logs/harness-runs/carrier-owner-admission-red-unit-3b1-20260814.out`.
- The new cases must fail against current production for their intended missing-admission reason. Record the exact total and the new failing assertions. Existing pre-Unit-3b1 assertions must remain green; if unrelated failures occur, stop and report them without diagnosis.
- Commit only the new tests and this state file. Hand back at `turn: codex` with the test commit hash and evidence; a state-only pointer commit may follow.

Constraints:

- Allowed implementation surface: `scripts/axcion-harness-v0.2/carry-turn.test.sh` only.
- Do not edit `carry-turn.sh`, any helper, dispatcher, instruction, expected production behavior, or existing assertion.
- Do not add a general case selector or restructure the harness. The dispatcher selector deferral does not enter this unit.
- Run the complete suite once only. Foreground execution is mandatory; no `&`, `nohup`, detachment, asynchronous tool call or rerun.
- Do not stage or commit the raw harness output.

Open deferrals carried without action: helper pin-file write/copy durability, carrier process-group parameter naming, dispatcher case selection, and duplicated helper-packaging knowledge in test fixtures.

Stop if a correct test cannot isolate ownership admission from the live-lease gate without modifying production, or if the current carrier already implements the required behavior.

Completion condition: three falsifiable ownership-admission controller cases exist in the one allowed test file; they run red against current production for the intended missing-admission reason while all existing assertions remain green; the tests and state are committed; and the task hands back at `turn: codex` without production changes.

## Latest result

Inspected (2026-08-14):

- Claim (1): HOLDS — searched `scripts/axcion-harness-v0.2/carry-turn.sh` for `work-loop-owner`, `--depth` and `depth repo`; the only match is a prose comment at line 664 that names the durable declaration to contrast it with the lease. No invocation exists.
- Claim (2): HOLDS — searched the same file with `grep -nE '\b(33|34|35)\b'`; no match, so none of the three ownership exits is implemented or even mentioned.
- Claim (3): HOLDS — the one allowed implementation surface `scripts/axcion-harness-v0.2/carry-turn.test.sh` exists and parses (`bash -n`, exit 0).
- Claim (4): HOLDS — read proposal §4.4 (lines 291–299: carrier ownership stops take 33/34/35, free in the carrier's documented taxonomy) and §5.5 cases 19–20 (lines 385–386: absent helper → 35; REFUSE/AMBIGUOUS → 33/34; both controller, both failing-first). The expectations were taken from there unchanged.
- Claim (5): HOLDS — read `plans/.../dispatch.sh` lines 2336–2367, the admission the proposal says to mirror, and used its wording for the asserted messages rather than inventing carrier-local text.

Result: Unit 3b1 complete. `carry-turn.test.sh` gained section **12e — Repository-depth ownership admission before actor launch**, carrying the three required stops plus one over-refusal control. Production was not touched: the only changed file is the allowed test file. Complete ordinary carrier suite, run once in the foreground: **333 passed / 17 failed, SUITE_EXIT=1** against a 350-assertion total — 34 new assertions, of which 17 are the intended red and 17 (fixture setup, control, discriminators) are green. All **316** pre-Unit-3b1 assertions remain green; the failing list contains nothing outside section 12e.

Evidence: each case proves its own fixture reaches the intended verdict by running the helper directly, then asserts the carrier acts on it — so a red assertion cannot be blamed on a fixture that never produced the condition. The three fixture oracles all passed: `REFUSE (3) from the worktree` ok, `AMBIGUOUS (4)` ok, control `PROCEED (0)` ok. The carrier ignored all three: expected `35`/`33`/`34`, got `0` in each; `launched nothing` expected `0`, got `1`; `committed nothing` shows HEAD moving (e.g. `601fd438… → 6080b8ee…`); and the forbidden-string check found `outcome=CARRIED`. That is the missing-admission reason and no other. The evidence can fail in both directions: the control run (helper present, ownership PROCEED) carries with exit 0 and one launch, so a launcher that refused everything would fail it, and the `code=17` discriminator passes now and separates an ownership stop from a lease refusal once production lands. Raw output: `logs/harness-runs/carrier-owner-admission-red-unit-3b1-20260814.out` (untracked by instruction).

Fixture note for the implementing unit: the three ownership fixtures package `work-loop-owner.sh` locally via a new `add_owner_helper` fixture function, tracked and committed because `logs/scripts/` sits outside the carrier's default allow-path set. `mkfix` was deliberately left unchanged, so no existing fixture moved.

Deferrals noticed during this unit, recorded and not done:

1. **`mkfix` does not package the ownership helper.** Once the admission is implemented, every existing carrier fixture would fail closed at exit 35, because none of them carries `logs/scripts/work-loop-owner.sh`. This is fixture packaging that belongs with the implementing unit — the same shape as the 3a2f lease-helper packaging — and doing it now would touch every existing case's fixture for no present benefit.
2. **The "present but broken helper" sub-case is not covered.** The dispatcher proves it (`dispatch.test.sh` case 12d, a helper that exits 99 → 35 via the catch-all arm). It is a fourth expectation and the brief froze three, so it was not added.

Accepted controller regression evidence carried forward: dispatcher **482/0**, owner helper **92/0**, shared lease helper **50/0**. Carrier is now **333/17 by design** until the implementing unit lands.

Accepted implementation through Unit 3a2f: shared helper and dispatcher through `5255628a`; carrier shared lease at `04de80a7`; carrier pin correction at `2bef1acf`; cross-transport fixture correction at `33d90df9`; owner-suite fixture packaging at `e859d377`.

## Blocker

None.

## Next action

Codex: assess Unit 3b1. The three frozen ownership-admission cases exist in the one allowed test file, run red against current production for the missing-admission reason only, and all 316 pre-existing assertions stay green with no production change. Decide whether to accept and open the implementing unit (3b2) that adds the repository-depth admission to `carry-turn.sh`, and whether deferral 1 — packaging the ownership helper in `mkfix` — enters that unit or stays held.
