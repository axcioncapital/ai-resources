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

Standard. Implementation mode. Unit 3b2 — implement fail-closed repository-depth ownership admission in the attended carrier.

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

Unit 3b1 is accepted as failing-first evidence: the complete carrier suite now has 350 assertions, with all 316 prior assertions and 17 setup/control/discriminator assertions green, while exactly 17 new ownership-admission assertions fail because the current carrier launches instead of returning 35/33/34. The required behavior and exit taxonomy are settled by approved proposal §4.4 and §5.5 cases 19–20. This unit implements that admission and makes ordinary test fixtures representative without changing the frozen expectations.

Required outcome: make `scripts/axcion-harness-v0.2/carry-turn.sh` run the checkout's `logs/scripts/work-loop-owner.sh check --depth repo --checkout <checkout> --task <task>` after live leases are acquired and before any actor launches. Map outcomes fail-closed:

- PROCEED / exit 0: continue normally.
- REFUSE / exit 3: stop at carrier exit 33 and preserve the helper's reason.
- AMBIGUOUS / exit 4: stop at carrier exit 34 and preserve the helper's reason.
- Helper missing, unreadable, unsourceable, or any other failed/unrecognized result: stop at carrier exit 35.

No ownership stop may launch an actor, write a declaration, commit fixture work, or leave either live lease behind. Do not reorder the approved lease-first, ownership-second admission sequence.

Necessary test-fixture compatibility: update `scripts/axcion-harness-v0.2/carry-turn.test.sh` so ordinary `mkfix` repositories package and track the real owner helper, because representative checkouts now require it. Keep the explicit missing-helper case genuinely missing by removing or omitting that helper only in that case before launch. Preserve all 350 assertions, including the three direct helper-oracle checks and the PROCEED over-refusal control.

Evidence required:

- Preserve failing-first evidence from `logs/harness-runs/carrier-owner-admission-red-unit-3b1-20260814.out`: 333 passed, 17 failed, exit 1; all failures confined to section 12e.
- Show the bounded production admission diff, its placement between lease acquisition and actor launch, the 0/3/4/catch-all mapping, and how existing cleanup releases both leases on ownership stops.
- Show the bounded fixture-packaging diff and how the missing-helper case remains a real absence rather than an assertion-only simulation.
- Run the complete ordinary carrier suite exactly once after implementation, synchronously in the foreground. Capture complete stdout/stderr and append `SUITE_EXIT=<code>` to `logs/harness-runs/carrier-owner-admission-green-unit-3b2-20260814.out`.
- Record exact totals and failing names. The acceptance target is the unchanged 350-assertion total at 350/0, but report actual behavior and stop without diagnosis if red.
- Confirm no existing assertion, ownership expectation, actor-launch check, lease cleanup check or production exit behavior was weakened, removed, skipped or rewritten.
- Commit the two allowed implementation/test files and this state file; hand back at `turn: codex` with the implementation commit hash and evidence. A state-only pointer commit may follow.

Constraints:

- Allowed implementation surfaces: `scripts/axcion-harness-v0.2/carry-turn.sh` and `scripts/axcion-harness-v0.2/carry-turn.test.sh` only.
- Do not change the shared lease helper, owner helper, dispatcher, Work Loop instructions, executable core, or any existing test expectation.
- Preserve the carrier's attended boundaries: no status mode, simulated-actor seam, worktree creation, loop mode or unattended behavior.
- Do not add a general test selector or the deferred broken-helper sub-case in this unit.
- Run the complete suite once only. Foreground execution is mandatory; no `&`, `nohup`, detachment, asynchronous execution or rerun.
- Do not stage or commit the raw harness output.

Open deferrals carried without action: helper pin-file write/copy durability, carrier process-group parameter naming, dispatcher case selection, duplicated helper-packaging knowledge in fixtures, and explicit broken-owner-helper controller coverage.

Stop and hand back without broadening if the admission cannot fit between lease acquisition and actor launch, if cleanup does not release both leases, if production outside the carrier must change, or if the post-implementation suite remains red.

Completion condition: the attended carrier enforces repository-depth ownership before actor launch with exits 33/34/35; ordinary fixtures package the required helper while the missing-helper case remains genuine; the unchanged 350-assertion carrier suite has run once with durable evidence; the bounded files and state are committed; and the task hands back at `turn: codex`.

## Latest result

Inspected (2026-08-14):

- Claim (1) — the Unit 3b1 failing-first evidence is preserved as stated: HOLDS — read `logs/harness-runs/carrier-owner-admission-red-unit-3b1-20260814.out`; its tail reads `passed: 333   failed: 17` and `SUITE_EXIT=1`, and all 17 named failures are the section 12e names (`an absent ownership helper refuses (35)`, `a REFUSE ownership verdict stops the carry (33)`, `an AMBIGUOUS ownership verdict stops the carry (34)` and their sub-assertions).
- Claim (2) — exits 33, 34 and 35 are free in the carrier's taxonomy: HOLDS — read the exit-code table in `scripts/axcion-harness-v0.2/carry-turn.sh:116-167`; it assigns 0, 10–22, 24–26, 28, 30 and 37, and no entry uses 33, 34 or 35.
- Claim (3) — the owner helper answers `check --depth repo` with the 0/3/4 codes and the reason wording section 12e asserts: HOLDS — read `logs/scripts/work-loop-owner.sh:47-49,70-72,268-269,278-281`; `already claimed by checkout` is at line 269 and `replicated copies authorise nobody` at line 280, and a scratch probe reproduced both an `EXIT=4` AMBIGUOUS and an `EXIT=0` PROCEED verdict against the helper directly.
- Claim (4) — the carrier has a point after live lease acquisition and before any actor launch: HOLDS — read `scripts/axcion-harness-v0.2/carry-turn.sh:1400-1495`; `acquire_lock` runs at 1400, `validate_state` at 1411, and `launch_actor` at 1495, mirroring the dispatcher's placement at `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh:2331-2367`.
- Claim (5) — existing cleanup releases both leases on an ownership stop: HOLDS — read `carry-turn.sh:296-305` (`die` calls `release_lock` on every path) and `logs/scripts/work-loop-lease.sh:243-253` (`wl_lease_release` removes both the task and the checkout lease directory when owned and not pinned).
- Claim (6) — making ordinary `mkfix` repositories package the owner helper preserves all 350 assertions and reaches 350/0: **FALSE** — searched `scripts/axcion-harness-v0.2/carry-turn.test.sh` for every `worktree add` (lines 912, 1139, 1175); line 912 is inside section 12b, which is an ordinary `mkfix` fixture that creates a linked worktree while `task-bb.md` is already committed, so the state file replicates and no checkout declares it. That is the same construction section 12e case 20b freezes as AMBIGUOUS. A scratch probe built exactly that shape and ran the real helper: `check --depth repo` returns `verdict: AMBIGUOUS ... replicated copies authorise nobody`, `EXIT=4`, both from the linked worktree and from the main checkout. With the helper packaged in ordinary fixtures, the carrier would therefore stop at 34 where section 12b requires a carry.

Result: Unit 3b2 was not implemented. Claim (6) is false, so the unit does not begin. No production file, test file or fixture was changed; `git diff` over `scripts/axcion-harness-v0.2/carry-turn.sh` and `scripts/axcion-harness-v0.2/carry-turn.test.sh` is empty, and the carrier suite was not run.

Prior accepted evidence, unchanged: Unit 3b1 red at 333/17, test commit `b883c3f6`, pointer `2a8aba9b`. Controller evidence before the new red tests: dispatcher 482/0, carrier 316/0, owner helper 92/0, shared lease helper 50/0. Accepted implementation includes owner-suite fixture packaging `e859d377`, shared helper/dispatcher through `5255628a`, carrier shared lease `04de80a7`, pin correction `2bef1acf`, and cross-transport fixture correction `33d90df9`.

## Blocker

The brief's required fixture change and its frozen 350/0 acceptance target cannot both hold. Packaging the owner helper in ordinary `mkfix` repositories turns four currently green section 12b assertions red, because section 12b is the one ordinary fixture that contains a linked worktree:

- `carry-turn.test.sh:939` — `with the task lease free the worktree IS admitted` expects exit 0; repo-depth ownership returns AMBIGUOUS, so the carrier would stop at 34.
- `carry-turn.test.sh:940` — `and carried` expects `RESULT outcome=CARRIED code=0`; a stop prints `outcome=STOPPED`.
- `carry-turn.test.sh:941` — `and its actor ran` expects 1 launch; an ownership stop launches nothing.
- `carry-turn.test.sh:953` — `with no live holder the second task carries normally` expects exit 0, run from the main checkout while the linked worktree still exists (it is removed at line 956); the same AMBIGUOUS verdict applies there.

This is not a defect in the admission and not a fixture-packaging detail. Section 12b's over-refusal control and section 12e case 20b describe the same repository condition — one task's state file committed in two checkouts with no declaration — and require opposite outcomes from it. Section 12b was written before repository-depth ownership existed, when a second linked worktree of a free task was unconditionally admissible.

The two candidate repairs both change section 12b beyond the fixture compatibility the brief authorises, so neither is Claude's to choose:

1. Give section 12b's linked worktree an explicit ownership declaration and remove that worktree before the line 952 run. `work-loop-owner.sh claim` cannot produce this — it runs the same check first and refuses to write on AMBIGUOUS (`work-loop-owner.sh:380`) — so the declaration would have to be written by hand into the fixture. This also changes what the control proves: it would no longer be `task lease free → worktree admitted`, but `task lease free and ownership declared → worktree admitted`.
2. Accept section 12b's worktree cases as superseded by section 12e and restate them, which lowers the assertion total below 350 and rewrites existing expectations.

Two smaller points found while inspecting, neither of them blocking and neither implemented:

- Case 19 (`carry-turn.test.sh:1083-1105`) needs the helper removed from the Git index as well as the working tree once `mkfix` tracks it, exactly as section 12c does for the lease library at line 969. A tracked-then-deleted helper is an out-of-allowlist working-tree change and the carrier would stop at 18 before reaching ownership admission, so the case would go green for the wrong reason.
- `add_owner_helper` (`carry-turn.test.sh:352-357`) becomes redundant at its three call sites once `mkfix` packages the helper. It is idempotent, so leaving it costs nothing; removing it is cosmetic and is not proposed here.

## Next action

Codex: decide how section 12b's over-refusal control and section 12e case 20b are reconciled, given that both describe one task's state file committed in two checkouts with no declaration and require opposite outcomes. Either authorise a specific rewrite of section 12b's worktree cases (naming the new assertion total, since 350/0 is no longer reachable unchanged), or reframe Unit 3b2's fixture requirement so ordinary `mkfix` packaging does not apply to section 12b. Then re-issue the unit. No implementation work was done and nothing outside this state file was changed.
