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

Standard. Discovery mode. Unit 2b2a — run and classify the dispatcher regression suite after shared-helper wiring.

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

Unit 2b1 is accepted at commit `1f0938a7bc0e680583e7abe1ecc933ebe5b5b902`: the dispatcher consumes the accepted helper, duplicate inline leasing is removed, targeted case 12f went red then green, syntax passed and focused case 12 passed 7/0. This verification unit now answers one named question only: did that wiring preserve the dispatcher regression surface outside the intentionally carrier-dependent 12e failures?

Governing sources and authority:

- Current operator decision: Phase 1 and its two bounded live validations are approved; D4 is retained; Phase 2 is deferred.
- Approved implementation basis: `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-and-task-aware-worktrees-implementation-proposal-2026-08-13.md`, especially § 5 and § 7 steps 2–4.
- Accepted failing-first boundary: Unit 1 cases 12e-1 through 12e-4 at commits `54d9db9c` and `b67f88d9` remain intentionally red until carrier integration. Their last accepted isolated signature was `pass=25 fail=11`; surrounding cases 12 and 12d were 15/15 green.
- Accepted dispatcher wiring: Unit 2b1 at `1f0938a7bc0e680583e7abe1ecc933ebe5b5b902`.

Required outcome: execute the existing dispatcher regression surface once and classify every failure. Establish whether all failures are confined to the already accepted 12e cross-transport cases and whether all other dispatcher cases, including new case 12f, pass through the shared helper.

Execution and evidence:

- Inspect only enough of `dispatch.test.sh` to identify its supported whole-suite or case-selection command. Do not edit production or test files.
- Run the dispatcher suite once. If the harness supports excluding 12e, run the complete non-12e surface and separately use the accepted 12e result already recorded; if it does not, run the whole suite and classify its output by case.
- Remain active until the foreground test command completes or the courier stops. Do not end the turn with a progress-only message such as “waiting for the run.”
- Report the exact command, exit code, pass/fail counts, elapsed time if available, and every failing case identifier.
- Confirm whether case 12f is green and whether any failure exists outside 12e.
- Compare the observed 12e failure signature with the accepted `pass=25 fail=11` signature if 12e ran. Do not rewrite or weaken 12e.
- Record final `git status --short --untracked-files=all`. Preserve ambient `logs/friction-log.md` and harness captures.
- Change only this state file, set `turn: codex`, and commit it by explicit pathspec. Report the commit hash.

Explicitly deferred: the helper's own full suite and focused helper matrix; carrier integration; carrier verification; instruction changes; controller acceptance across both transports; and both live validations. This unit is evidence-only and must not fix a failure it discovers.

Stop and hand back with the evidence if any non-12e failure appears, the suite cannot be run within the safety boundary, or the expected 12e signature changes. Do not edit implementation or tests in this unit.

Completion condition: one completed dispatcher regression run is classified; case 12f is accounted for; every failure is identified as either an unchanged intentional 12e failure or an unexpected regression; no production/test file changed; and the committed state hands back at `turn: codex`.

## Latest result

Inspected (2026-08-14):

- Claim (1) — Unit 2b1 is at commit `1f0938a7bc0e680583e7abe1ecc933ebe5b5b902` and wired the dispatcher to the shared helper: HOLDS. `git log -1` resolves that full hash to `batch: … unit 2b1, dispatcher wired to the shared live lease`; `git show --stat` on it lists exactly three files — this state file, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` (+188/−…) and `dispatch.test.sh` (+68).
- Claim (2) — case 12f exists in the dispatcher suite: HOLDS. Searched `dispatch.test.sh` for `^echo "Case 12`; found `Case 12f — an ABSENT lease library refuses before launch and takes no lease` at line 728.
- Claim (3) — cases 12e-1 through 12e-4 exist and are still the cross-transport cases: HOLDS. Same search found them at lines 551, 588, 617 and 664, under their Unit 1 titles, unedited by this unit.
- Claim (4) — `dispatch.test.sh` supports a whole-suite or case-selection command: HOLDS, and it is whole-suite only. Read the harness header (lines 1–40) and searched the whole file for `CASE_FILTER|_ONLY|--case|getopts|"$@"` at top level; the documented usage block (lines 20–21) offers `bash dispatch.test.sh` and the `DISPATCH_BIN` override and nothing else, and no top-level argument parsing exists. There is no 12e exclusion switch. The brief's fallback therefore applies: run the whole suite and classify by case.
- Claim (5) — the accepted 12e signature is `pass=25 fail=11`, with surrounding cases 12 and 12d 15/15 green: HOLDS, with one qualification the comparison depends on. Read the Unit 1 record at `git show b67f88d9:logs/work-loop/…phase-1.md` lines 106–117: that figure is labelled there as `SLICE pass=25 fail=11`, taken from a temporary assembled slice of the suite preamble plus cases 12, 12d and 12e — not from a whole-suite run. So the `fail=11` half is directly comparable to today's whole-suite run and the `pass=25` half is not; the comparison below is made on the failure set, not on the pass total.

Result: the dispatcher regression suite was run once, complete, after the Unit 2b1 shared-helper wiring. It ends `pass=471 fail=11`, exit 1. Every one of the 11 failures falls inside cases 12e-1 through 12e-4 — the Unit 1 cross-transport cases that are intentionally red until carrier integration. No failure exists anywhere else in the 98-case surface, and case 12f is green. Nothing was fixed, edited or re-run; this unit is evidence only.

Evidence:

- Command, run from `plans/work-loop-v2-v0.2/handoff-automation-spike/`: `bash dispatch.test.sh`. Exit code `1`. Elapsed 380 s. Final line: `pass=471 fail=11  (all cases SIMULATED — no live product transport)`. Exit 1 is the harness's own `[ "$FAIL" -eq 0 ] || exit 1`, so it reports the 12e failures and not a harness fault.
- Failure classification — all 11 `FAIL` lines, attributed to the case header each sits under:
  - 12e-1 (2 failures): `a dispatcher is refused while a CARRIER holds the checkout` — `expected exit 17, got 0`; `and the dispatcher launched no actor` — `actors ran: xt-dispatched`.
  - 12e-2 (3): `a carrier is refused while a DISPATCHER holds the checkout` — `expected exit 17, got 0`; `and the carrier launched no actor` — `launches: 1`; `and committed nothing` — `HEAD moved`.
  - 12e-3 (3): `a dispatcher is refused while a CARRIER holds the same task elsewhere` — `expected exit 17, got 0`; `and the dispatcher launched no actor` — `actors ran: xt-shared`; `and committed nothing` — `HEAD moved`.
  - 12e-4 (3): `a carrier is refused while a DISPATCHER holds the same task elsewhere (lease refusal precedes ownership admission)` — `expected exit 17, got 0`; `and the carrier launched no actor` — `launches: 1`; `and committed nothing in the worktree` — `HEAD moved`.
  - 2 + 3 + 3 + 3 = 11. `grep -c '^  FAIL '` over the captured run returns 11, so the attribution is exhaustive and nothing was missed outside the four case blocks.
- 12e signature unchanged. The failure set matches the Unit 1 record case for case: the same four cases, the same primary assertion `expected exit 17, got 0` in each, and the same asymmetry — 12e-1's third assertion `and committed nothing` PASSES today, exactly as the Unit 1 record noted at its line 150, while the equivalent assertion fails in 12e-2, 12e-3 and 12e-4. No 12e case moved in either direction, and nothing in 12e was rewritten or weakened.
- Case 12f green: `pass=7 fail=0` within the case — the exit-11 refusal, the message naming the missing lease library, no actor launched, no commit made, no lease directory left behind, plus both controls (with the library present the same run proceeds, and the actor does run). The controls passing is what stops 12f being satisfied by a dispatcher that refuses everything.
- Cases 12 and 12d: 15 PASS, 0 FAIL across the two — the same `15/15 green` the Unit 1 record accepted. The shared helper did not disturb the ordinary same-transport refusal surface.
- The evidence can fail. This run had 11 red assertions and exit 1, so the harness was demonstrably capable of reporting failure on this invocation; the claim being made is about *where* the failures are, and a regression outside 12e would have appeared in the same `FAIL` grep that produced the list above. Case 0 is the harness's own falsifiability proof — it points the suite at an absent dispatcher and asserts the suite fails — and it passed in this run.
- No production or test file changed. Final `git status --short --untracked-files=all`: ` M logs/friction-log.md`, ` M logs/work-loop/work-loop-v2-cross-transport-concurrency-phase-1.md`, and 22 untracked `logs/harness-runs/` captures. The friction log and the harness captures are the pre-existing ambient state and were left alone; the suite output was captured outside the repository, under `$TMPDIR`, so it added nothing to the working tree.

Prior accepted units, unchanged: Unit 1 at `54d9db9c` and `b67f88d9`; Unit 2a at `c409c12a` and pointer correction `1b736816`; Unit 2b1 at `1f0938a7`.

Deferral noticed during this unit, recorded and not done: the suite has no case-selection switch, so any future unit that needs a subset pays the full 380 s or hand-assembles a slice as Unit 1 did. Adding a filter would touch the test harness, which this evidence-only unit must not do. Worth deciding deliberately if verification units recur.

## Blocker

None.

## Next action

Codex: assess Unit 2b2a against its completion condition — one complete dispatcher regression run classified, case 12f accounted for, every failure identified as either an unchanged intentional 12e failure or an unexpected regression, and no production or test file changed.

Two things this unit deliberately left to you rather than settling on its own:

1. The accepted `pass=25 fail=11` figure is recorded in the Unit 1 record as a `SLICE` result from a hand-assembled subset, not a whole-suite total. The comparison above is therefore made on the failure set — same four cases, same assertions, same 12e-1 asymmetry — and not on the pass count. Confirm that is the intended reading of "unchanged 12e signature".
2. Whether the deferral above (the suite has no case-selection switch) belongs to a later unit or is dropped.

Then decide what follows: the deferred helper suite and focused helper matrix, or carrier integration.
