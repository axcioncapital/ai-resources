---
task: cross-transport-concurrency-correction
turn: codex
---

## Objective and scope

Correct the seven reviewed Phase 1 concurrency findings, complete the required controller and live evidence, and leave this branch ready for the final independent review and merge decision described in `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-correction-plan-2026-08-14.md`.

Scope is exactly that correction plan as committed at `f2b19b5d80a061111c39cc7444f90f6374f19d38`. Excluded: Phase 2, automatic worktree creation, a scheduler, registry, service, new state store, new command surface, unrelated `LOCK_KEY` work, unrelated cleanup, merge, and push.

## Lane and unit

Standard. Implementation mode. Unit 6 — complete the proposal's exact controller acceptance matrix for cases 3, 4, 12, 16, and 22. Delivered; awaiting assessment.

Named reason for the loop: the correction spans several independently assessable units and must survive session boundaries; the result also needs assessment by someone other than its implementer before it can progress. The operator explicitly chose Work Loop v2 for this task on 2026-08-15.

## Brief

Units 1–5 are accepted. This unit closes correction-plan step 6: proposal cases 3, 4, 12, 16, and 22 must each have their own named, falsifiable controller assertions and positive controls rather than relying on indirect broad-suite coverage.

Required outcome: complete exact controller evidence for the five proposal cases without changing production behavior unless a new exact case exposes a real defect and Codex explicitly reframes it. Case 22 is already implemented as dispatcher case `30g`; confirm it rather than duplicating it.

Governing sources:

- The operator-approved correction plan at `f2b19b5d80a061111c39cc7444f90f6374f19d38`, especially implementation sequence step 6 and the verification distinction between controller and live evidence, governs this unit.
- The governing Phase 1 proposal named by that plan governs the exact meaning of cases 3, 4, 12, 16, and 22.
- Accepted Units 1–5 govern current production behavior; this unit should add exact evidence, not reopen their implementations without a demonstrated product failure.

Check these claims against the live repository before changing anything:

1. Read the proposal's exact definitions of cases 3, 4, 12, 16, and 22, then map each one to executed assertions in `carry-turn.test.sh` and `dispatch.test.sh`. Distinguish exact named coverage from indirect or partial coverage.
2. Verify whether case 3 currently uses a real carrier holding both leases while a dispatcher in the same checkout is refused with 17 and names the carrier, with a control proving the carrier actor actually launched.
3. Verify whether case 4 currently uses a real dispatcher holding both leases while a carrier in the same checkout is refused with 17 and names the dispatcher, with a control proving the dispatcher actor actually launched.
4. Verify exact current coverage and positive controls for case 12 (two different tasks in two linked worktrees admitted concurrently with isolated paths), case 16 (partial acquisition pins only the lease acquired and status reports exactly that state), and case 22 (accepted Unit 5 case `30g`).
5. Report branch, checkout, Git status, and pre-existing operator-owned changes before editing. Do not stage or commit `logs/friction-log.md` or `logs/harness-runs/`.

Authorized changes:

- `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`
- `scripts/axcion-harness-v0.2/carry-turn.test.sh`
- this state file
- `logs/friction-log.md` only if an existing hook updates it; never stage or commit it

Codex framing decision: no production file is authorized. If an exact case reveals a product defect, hand back its failing evidence for reframing rather than repairing it inside this coverage unit. Verification gates, live cases 23/24, and the closing record remain outside this unit.

Required evidence:

- Give cases 3, 4, 12, and 16 their own proposal-numbered assertions, adding or sharpening only what the mapping proves missing. Preserve accepted case 22 as dispatcher case `30g` rather than duplicating it.
- For case 3: real carrier holds; dispatcher in the same checkout exits 17 before actor launch and names the carrier. For case 4: real dispatcher holds; carrier in the same checkout exits 17 before actor launch and names the dispatcher.
- For case 12: different tasks in different linked worktrees are both admitted concurrently and neither sees the other's paths. For case 16: partial acquisition pins only the lease actually acquired, and dispatcher `--status` reports exactly that partial state.
- Each case needs a positive control that would fail if the implementation merely refused everything or never launched the holder. Evidence must distinguish the required behavior from wrong-holder, mixed-path, or over-pinning behavior.
- Because the defect is missing exact coverage, do not manufacture a production failure merely to obtain red output. Report which exact assertions were absent before the edit, and use an existing mutation/prove-failure facility only where it directly demonstrates that the new case detects the relevant wrong behavior without adding a new fixture system.
- Run `bash -n` on every changed shell test, the full carrier suite, and the full dispatcher suite; report commands, exit codes, and current totals. If the shared lease suite is exercised by a changed case, run it too.
- Report changed files, implementation commit, deviations, remaining limitations, and rollback instructions.

Completion condition: correction-plan step 6 is satisfied; all five proposal cases have exact named, falsifiable controller evidence and positive controls; relevant full suites pass; production behavior is unchanged unless a real defect was handed back and reframed; only authorized files are committed; and Claude updates this file, sets `turn: codex`, commits, and stops.

Stop and hand back without improvising if any exact case exposes a production defect, genuine linked-worktree isolation cannot be exercised by the controller suites, the proof needs files outside the authorized boundary, or a premise is false.

## Latest result

Inspected (2026-08-15):

- Claim (1): HOLDS — mapped the proposal's cases 3, 4, 12, 16 and 22 (`work-loop-v2-cross-transport-concurrency-and-task-aware-worktrees-implementation-proposal-2026-08-13.md` §§ 5.1–5.5) onto executed assertions by reading `dispatch.test.sh` and `carry-turn.test.sh` end to end. The existing cross-transport family is four different proposal rows, not these: `12e-1`/`12e-2` are proposal case 11 (one checkout, different tasks — fixture tasks `xt-carried`/`xt-dispatched`), `12e-3`/`12e-4` are proposal cases 7/8 (one task, different checkouts). Exact named coverage existed only for case 22.
- Claim (2): HOLDS — this claim asks for a verification, not an assertion, so no premise could fail here; the verification ran and its answer is **no**. Searched `dispatch.test.sh` and `carry-turn.test.sh` for any acquisition case pairing a live carrier and a starting dispatcher on the SAME task in the SAME checkout; no match. `12e-1` is the nearest and runs a different task; `30g` is same-task/same-checkout but is `--status`, which takes no lease.
- Claim (3): HOLDS — same shape, same answer for case 4. Searched `carry-turn.test.sh` for a dispatcher-recorded lease refusing a carrier: `plant_lease` is called once in that file (line 1090) and plants `carry`, never `dispatch`. `12e-2` runs a different task; `12e-4` runs a different checkout.
- Claim (4): HOLDS, in three parts. Case 12 — searched both suites for two runs admitted concurrently on different tasks in different worktrees; no match. `carry-turn.test.sh` 1099–1121 is the nearest and is sequential, carrier-only, and contends against a planted lock, so it cannot show two live programs holding leases at one moment. Case 16 — the pin guard is proven at library level (`work-loop-lease.test.sh` case 6, line 450), but searched `dispatch.test.sh` for `--status` over a half-pinned repository; no match, so the surface an operator actually reads was unproven. Case 22 — present and exact as dispatcher case `30g` (`dispatch.test.sh` 2928), confirmed and not duplicated.
- Claim (5): HOLDS — branch `session/2026-08-14-concurrency-fix-2`, checkout `ai-resources-concurrency-fix-2`, HEAD `d22978ad` at unit start. Pre-existing operator-owned changes: `logs/friction-log.md` modified and `logs/harness-runs/` untracked. Neither was staged or committed.

Result: correction-plan step 6 is satisfied, with no production change. `dispatch.test.sh` gains five proposal-numbered cases — `12e-5` (proposal case 3), `12e-6` (proposal case 4), `12e-7` (proposal case 12), and `30i` with its control `30i-b` (proposal case 16). Local numbering with the proposal number in the header follows `30g`'s reason: "case 3", "case 4", "case 12" and "case 16" are all already taken in that file by unrelated local cases. Case 22 is preserved as `30g`, unmodified. `carry-turn.test.sh` was authorized but needed no change: the mapping placed every gap on the dispatcher side, because in cases 3 and 12 the dispatcher is the program under observation, and in case 4 the carrier is already driven from the dispatcher suite alongside `12e-2`/`12e-4`.

Evidence:

- Absent before the edit, and named: no assertion anywhere paired a live carrier with a starting dispatcher on one task in one checkout (case 3); none planted or launched a dispatcher-held lease against a starting carrier in one checkout (case 4); none held two leases at the same moment across two worktrees (case 12); none ran `--status` over a partially pinned repository (case 16). The pre-edit dispatcher baseline was `pass=578 fail=0` — 578 assertions, none of them these.
- Case 3 (`12e-5`): a real carrier holds both leases (setup asserts both directories and `program=carry`); the dispatcher exits 17, its refusal contains `an attended carry holds task xt-same` and does not contain `a dispatcher`; it launched no actor and moved no HEAD. Control: the carrier launched exactly one actor, so the refusal is not vacuous.
- Case 4 (`12e-6`): a real dispatcher holds both leases (setup asserts `program=dispatch`); the carrier exits 17 with `an unattended dispatched run already holds the TASK lease for 'xt-same2'` and without `an attended carry`; zero carrier launches, HEAD unmoved. Control: the dispatcher's actor recorded exactly one launch — `12e-2` used a bare `sleep`, which could not answer that.
- Case 12 (`12e-7`): a carrier on `iso-here` in the main checkout and a dispatcher on `iso-there` in a linked worktree; both hold both of their leases **at the same moment**, read while both are still running. Both checkouts resolve the same lease root, so each could see the other and both were admitted anyway. Neither exited 17; both actors launched. Isolation: the carrier's hop is in its own checkout's state file and the worktree's replica of that file is untouched; the dispatcher's run log exists only in the worktree it ran in; all four leases were released at the end.
- Case 16 (`30i` + `30i-b`): the shared library is driven into partial acquisition by a separate process, because `wl_lease_acquire` rolls the task lease back when the checkout lease is refused, making the state unreachable through acquire alone. The owned task lease carries the pin; the unowned checkout lease does not. `--status` exits 0, reports the task lease `PINNED`, reads back `descendants still running: 4242`, and describes the checkout lease as `HELD by a dispatcher running task pin-partial` — not as a second pin. Behavioural half: an unrelated task in that checkout is still admitted and launches, so the pin did not silently take the whole checkout. `30i-b` is the control that makes all of it non-vacuous: a run that genuinely owned both leases pins both, and the same unrelated task is then refused with 17 naming `its checkout lock is PINNED` and launches nothing. Neither half means anything alone — `30i` passes against a pin that never writes the checkout lease, `30i-b` against one that writes it unconditionally.
- The assertions can fail, shown rather than argued. The first post-edit run was `pass=626 fail=5`, with all five failures in `30i`/`30i-b`: the driver handed `wl_lease_init` the raw sandbox path where every real caller hands it a resolved one (`work-loop-lease.sh` 167 hashes the string it is given), so it took its checkout lease under a second key. No production behaviour was involved and none was changed; the driver now canonicalizes as `dispatch.sh` and `carry-turn.sh` do, and a setup assertion was added requiring both leases to be where the suite derives them, so that class of mistake fails loudly instead of passing for the wrong reason.
- Commands and exit codes, run from this checkout: `bash -n plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` rc 0; `bash -n scripts/axcion-harness-v0.2/carry-turn.test.sh` rc 0; `bash plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` rc 0, **`pass=632 fail=0`** (pre-edit `578/0`); `bash scripts/axcion-harness-v0.2/carry-turn.test.sh` rc 0, **`passed: 423 failed: 0`**; `bash logs/scripts/work-loop-lease.test.sh` rc 0, **`pass=127 fail=0`**, run because `30i` sources the shared library. `git diff --check` rc 0. No production file differs from `d22978ad`: `git diff --name-only` over `dispatch.sh`, `carry-turn.sh`, `work-loop-lease.sh` and `work-loop-owner.sh` returns nothing.
- Changed files and implementation commit: `a3096a21`, carrying exactly `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` and this state file. `logs/friction-log.md` and `logs/harness-runs/` were left uncommitted, as the brief requires.
- Rollback: `git revert a3096a21`, or `git checkout d22978ad -- plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`. Nothing outside that one file changed, so no production behaviour can be affected either way.

Unit 6 observations, none acted on:

- The carrier suite's first run of this unit reported `passed: 418 failed: 5`, all five in section 16 with exit 21 (actor timeout), while other work ran concurrently on this machine. A clean rerun returned `423/0` over the same 423 assertions. Recorded as a load-sensitive timing flake in that section, not a product failure and not a fix attempted here.
- Deferral, noticed mid-unit and deliberately not implemented: `wl_lease_init` hashes the checkout string it is handed rather than a resolved path, so correctness depends on every caller canonicalizing first. `dispatch.sh` and `carry-turn.sh` both do, so no shipped behaviour is wrong — but a future caller that does not would take a second, invisible checkout lease and contend with nobody. Not done now because it is a production change in the shared library and this unit authorizes no production file.
- Two orphaned temp sandboxes under `${TMPDIR}/wl2-dispatch-test.*` remain from a test run I stopped mid-flight; their removal was denied by permission prompt. They are outside every checkout, hold no lease this repository resolves, and affect no result above.

Units 1–5 accepted: Unit 1 (`fee4fe49`, `ca35371c`, `57f3b25b`), Unit 2 (`2d58991d`, record update `bc979e8d`), Unit 3 (`cda44c50`), Unit 4 (`8e4261f0`), Unit 5 (`81644987`, correction `d22978ad`).

Unit 5 deferrals held for task closure: the carrier's fallback labels retain contextual `another` wording while both recognized holder classes agree; the dispatcher `STALE LOCK` sentence still says a dispatcher died, outside step 5's explicit `LIVE`/`UNKNOWN` scope.

Units 1–5 accepted: Unit 1 (`fee4fe49`, `ca35371c`, `57f3b25b`), Unit 2 (`2d58991d`, record update `bc979e8d`), Unit 3 (`cda44c50`), Unit 4 (`8e4261f0`), Unit 5 (`81644987`, correction `d22978ad`).

Accepted limitations held for closure. From Unit 1: mutually uninspectable live reclaimers both fail closed; `wl_lease_status` describes a provably dead holder as `HELD`; the old-marker transition block can be removed only after no checkout can carry that format. From Unit 3: a host unable to execute `ps -g` pins interrupted or timed-out runs rather than releasing leases, because shutdown cannot be proved. From Unit 4: an unwritable shared lease root leaves the refusal terminal-only with an explicit warning, and refusal records have no pruning policy because the plan authorizes no cleanup service or machinery; the unassigned `LOCK_KEY` remains excluded unrelated work.

## Blocker

None.

## Next action

Codex: assess Unit 6 against correction-plan step 6 — whether the five proposal cases now have exact named, falsifiable controller assertions with positive controls; whether `12e-7`'s concurrency reading and `30i`/`30i-b`'s pairing are sound evidence rather than restatements of neighbouring cases; whether leaving `carry-turn.test.sh` unchanged is the right placement call; and whether the recorded `wl_lease_init` canonicalization deferral belongs at task closure or in a reframed unit. Then close, continue to step 7 (verification gates, live cases 23/24, closing record), or correct once.
