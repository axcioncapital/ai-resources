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

Standard. Discovery mode. Unit 6 — broad Phase 1 controller regression gate across the shared lease helper, owner helper, attended carrier, and unattended dispatcher.

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

Unit 5 and its frozen correction are accepted: the proposal's two instruction changes landed at `9226c7c4`, and correction `61f7d08d` added the attended carrier to the repository-depth assignment without breaking either accepted edit. Phase 1 implementation and instruction work are therefore complete enough to enter proposal §7 step 4. This unit answers one question only: do all four relevant controller suites pass together on the current implementation before either live validation begins?

Governing authority: the operator-approved Phase 1 proposal bound at `10d2eeb6f8868b2f073e11150dc1a50a95ea760a`, especially §7 step 4 and the adopt/revise/stop gate. Accepted implementation evidence: shared helper `f4396a7c`; dispatcher integration `1f0938a7`; carrier integration `04de80a7`; carrier ownership admission `52ecf472`; carrier pin-result handling `1da14105`; dispatcher pin-result handling `294feb28`; instruction commits `9226c7c4` and `61f7d08d`. Phase 2, D4, the executable core, live cases 23/24, integration, cleanup, push, and main checkout remain outside this unit.

Required outcome: from this bound worktree, run the complete current suites for (1) `logs/scripts/work-loop-lease.test.sh`, (2) `logs/scripts/work-loop-owner.test.sh`, (3) `scripts/axcion-harness-v0.2/carry-turn.test.sh`, and (4) `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`. Capture each suite's command, exit code, pass/fail count, and raw output path under `logs/harness-runs/`. Establish the current counts rather than forcing historical counts: the relevant recorded baselines are helper 67/0, owner 92/0, carrier 350/0, and dispatcher 482/0, but focused assertions added later may legitimately increase a suite count.

Claims to verify before running:

1. Confirm all four suite files exist and identify their complete-suite invocation from their own executable/header behavior or accepted repository convention.
2. Confirm the implementation source and test files named above have no uncommitted changes before the gate. The already-known ambient `logs/friction-log.md` modification and untracked harness outputs are not implementation dirt; report any other relevant dirt and stop rather than hiding it.
3. Confirm no dispatcher run is in flight and no shared task or checkout lease is held for this task before starting. This is a verification claim, not permission to clear a lease.

Evidence required: four raw output files, four observed exit codes, four explicit pass/fail summaries, and a compact comparison with the recorded baselines. The evidence must show the actual failing assertion and stop if any suite is nonzero; do not fix a failure in this unit. After the runs, report whether any source or test file changed. Commit only this state file with explicit pathspec; raw harness outputs may remain uncommitted as evidence.

Codex framing decision: the four suites are one regression-gate deliverable, not four implementation units, because this unit changes no product code and constructs no fixtures. Run them sequentially and stop on the first nonzero result so a real regression is not buried and the bounded clock is respected. Do not re-run a completed green suite.

Stop if a suite is missing or cannot be invoked, relevant implementation/test dirt exists, a live lease or run blocks safe execution, any suite exits nonzero, the tests would require main checkout, or the unit would need to change anything except the state file and raw evidence logs. Challenge a false premise and hand back; do not improvise around it.

Completion condition: all four complete suites have run once against the current Phase 1 worktree, each exits 0 with explicit counts and durable raw output, no relevant source/test file changed, the evidence comparison is recorded, and the task hands back at `turn: codex`.

## Latest result

Inspected (2026-08-14):

- Claim (1): HOLDS — searched the four named paths; all four exist. `logs/scripts/work-loop-lease.test.sh`, `scripts/axcion-harness-v0.2/carry-turn.test.sh` and `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` are mode-executable; `logs/scripts/work-loop-owner.test.sh` is not (mode 644). Each file's own `Usage:` header names `bash <file>` as the complete-suite invocation, so `bash <file>` is the uniform route and the missing execute bit changes nothing. `carry-turn.test.sh`'s header distinguishes the bare invocation (the green suite) from `--prove-failure` (the separate mutant proof); the bare form was used.
- Claim (2): HOLDS — ran `git status --porcelain` limited to the eight implementation and test paths (`work-loop-lease.sh`, `work-loop-lease.test.sh`, `work-loop-owner.sh`, `work-loop-owner.test.sh`, `carry-turn.sh`, `carry-turn.test.sh`, `dispatch.sh`, `dispatch.test.sh`); output was empty. Whole-tree status showed only the known ambient `logs/friction-log.md`, this state file carrying Codex's brief, and untracked `logs/harness-runs/` — none of which is implementation dirt.
- Claim (3): **FALSE AS WRITTEN** — searched the live lease root by sourcing the helper and calling the read-only `wl_lease_status` for this checkout and task. Both leases are HELD: `task-f026eaec09add182.lock` and `checkout-0d1f538516e4119f.lock` under `ai-resources/.git/work-loop-dispatch-locks`, both recording `pid=96236 program=carry` for this exact task and this exact checkout. No dispatcher run is in flight (`ps -ax` matched no `dispatch.sh`; the only match is that carrier process). The holder is the attended carrier that launched this very Claude invocation, which is the behavior Unit 5's accepted correction `61f7d08d` introduced — so the claim as worded can never hold for any attended unit of this task, not merely this one. No lease was cleared.

Claim (3) did not block execution, and this was established by inspection rather than assumed: all four suites build throwaway checkouts under `$TMPDIR` (`SANDBOX_ROOT` / `TMPROOT` via `mktemp -d`) and resolve their lease roots from those sandbox repositories' own Git common directories, so the real repository's held leases never participate. The gate ran, changed no file outside this state file and the untracked evidence logs, and the brief's operative stop condition — "a live lease or run blocks safe execution" — did not fire. Codex owns whether the premise needs rewording, and it matters beyond wording for live cases 23 and 24, where an attended carrier holding both leases is a real condition rather than an artifact.

Result: **the regression gate is RED and was stopped at the fourth suite, so proposal §7 step 4 is not satisfied and neither live validation may begin.** Three suites pass; the dispatcher suite exits 1 with 5 failures. No failure was fixed and no source or test file changed — post-run `git status --porcelain` over `logs/scripts/`, `scripts/axcion-harness-v0.2/` and `plans/work-loop-v2-v0.2/handoff-automation-spike/` was empty, identical to the pre-run check.

Evidence — four suites, run sequentially from this bound worktree, raw output durable under `logs/harness-runs/`:

| # | Command | Exit | Counts | Baseline | Raw output |
|---|---|---|---|---|---|
| 1 | `bash logs/scripts/work-loop-lease.test.sh` | 0 | pass=67 fail=0 | 67/0 — matches | `logs/harness-runs/20260814-unit6-gate-1-lease.out` |
| 2 | `bash logs/scripts/work-loop-owner.test.sh` | 0 | 92 passed, 0 failed | 92/0 — matches | `logs/harness-runs/20260814-unit6-gate-2-owner.out` |
| 3 | `bash scripts/axcion-harness-v0.2/carry-turn.test.sh` | 0 | passed=371 failed=0 | 350/0 — +21 assertions, fail still 0 | `logs/harness-runs/20260814-unit6-gate-3-carrier.out` |
| 4 | `bash plans/.../handoff-automation-spike/dispatch.test.sh` | **1** | pass=498 **fail=5** | 482/0 — **contradicted** | `logs/harness-runs/20260814-unit6-gate-4-dispatcher.out` |

The five failures are one root plus four cascades, all inside Case 12e-3 ("a live CARRIER holds the TASK in a linked worktree; a DISPATCHER starts on it here"). The root is the case's own setup:

```
FAIL  12e-3 setup — the carrier's TASK lease is live before the dispatcher starts
      no lease at .../co.kldl1p/.git/work-loop-dispatch-locks/task-a962de0d108a7487.lock
FAIL  a dispatcher is refused while a CARRIER holds the same task elsewhere
      expected exit 17, got 0
FAIL    and the dispatcher launched no actor        actors ran: xt-shared;
FAIL    and committed nothing                       HEAD moved from d9a9684e
FAIL    control — the carrier that HELD the task did launch its own actor   launches: 0
```

The carrier in the linked worktree took no task lease and launched nothing (`launches: 0`), so no lease existed for the dispatcher to be refused by; the dispatcher then correctly proceeded, and the remaining three assertions fell out of that. The sibling cross-transport cases 12e-1, 12e-2 and 12e-4 all pass, including 12e-1's control proving a carrier does launch in this harness when it is not in a linked worktree. Read-only history: `git log -S'12e-3'` places the case's introduction at `54d9db9c`, the Unit 1 **red** slice, which Unit 2b1 `1f0938a7` was to turn green. Whether this is a case that was never fully turned green, or a regression from the later carrier ownership-admission work at `52ecf472`, is a framing call and is left to Codex — this unit diagnosed no further and fixed nothing.

The evidence can fail and did: suite 4 returned a nonzero exit and named the failing assertions, and each suite's own Case 0 is a falsifiability proof that goes red when the artifact under test is removed.

Two records that need reconciling, both Codex's to judge: the recorded dispatcher baseline of 482/0 is contradicted by the current complete run at 503 assertions with 5 red, so either that baseline came from a focused slice rather than the complete suite or something regressed after it was taken; and the carrier suite is now 371 rather than the recorded 350, with fail still 0, consistent with the brief's allowance for later-added focused assertions.

Prior accepted implementation is unchanged: shared helper and durable pin contract; dispatcher and carrier shared-lease integration; carrier repository-depth ownership admission; both transports' explicit pin-result handling; instruction commits `9226c7c4` and `61f7d08d`. Open: this red gate, authorized live cases 23 and 24, and the final limitations/rollback record.

## Blocker

The Phase 1 regression gate does not pass. `dispatch.test.sh` exits 1 with 5 failures rooted in Case 12e-3's setup — the carrier in a linked worktree takes no task lease and launches no actor. Proposal §7 step 4 requires the gate before either authorized live validation, so live cases 23 and 24 stay closed until Codex frames the repair.

## Next action

Codex: assess the red gate. Decide whether Case 12e-3 is an unclosed Unit 1 red case or a regression from the carrier ownership-admission work at `52ecf472`, and frame the repair unit accordingly. Also decide whether claim (3) needs rewording, given that the attended carrier now holds both leases for the whole of every attended Claude unit — which bears on live cases 23 and 24, not only on brief wording.
