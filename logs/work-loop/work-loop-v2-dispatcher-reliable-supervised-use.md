---
task: work-loop-v2-dispatcher-reliable-supervised-use
status: active
turn: codex
---

## Objective and scope

Implement `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` through its complete Gate SA acceptance contract and independent adoption review, while preserving the plan's fixed supervised-use boundary.

Scope: the existing Work Loop v2 supervised dispatcher, its accepted helpers and runtime surfaces, focused proof, live trials, and the synchronous regression gate named by the plan. Excluded throughout: Gate ST, Gate U, unattended or walk-away release claims, dispatcher rewrite or language migration, merge, push, deployment, destructive cleanup, and every other exclusion in plan §§ 4 and 7.

Task exit condition: one integrated candidate has passed Gate SA and the independent review has returned `ADOPT`, or Patrik has explicitly chosen `SHRINK` or `STOP`.

## Lane and unit

Standard. Implementation mode. Unit 10 — consume the operator-terminal result before release

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Change set A remains active. Unit 9 is accepted at `4eb88c92dae48ca90d92abedae77979386806e98`: the first legitimate consumer is the same-process operator-terminal release seam, where lease release is the real advance decision and the dispatcher independently owns the promised path plus expected task, checkout, run, and evidence root. This unit makes that one vertical path trustworthy by composing the accepted validators before release; it does not build another reader or broaden terminal coverage.

Dominant deliverable: one production consumer gate at the real operator-terminal seam that permits lease release only after the promised run-bound result passes the accepted path, structural, and expected-identity boundaries.
Evidence required in this hop: one focused red/green operator-terminal case proves that a missing or wrong-identity promised result currently exits 0 and releases, then proves valid expected evidence releases normally while each refusal exits 38, truthfully pins both leases, and prevents the next dispatcher from acquiring.
Evidence explicitly deferred: semantic tuple validation beyond the identity required by this consumer; the `die()` funnel's ignored finalizer return; terminal families A–C, M, and the remaining N sites; status rendering; resume; moving run identity earlier; crash-boundary recovery beyond this seam; broad hostile-input matrices; Change sets B–D; broad regressions; live trials; adoption review; merge, push, deployment, and destructive cleanup.
Primary edit begins after: add and run one focused operator-terminal fixture that replaces the promised result after successful finalization but before `release_lock` with a structurally valid result carrying another run identity, and observe the current path exit 0, release both leases, and admit the next dispatcher.

Required outcome: after the operator-terminal seam successfully finalizes `$LOG_DIR/$RUN_ID.result`, consume that exact promised artifact synchronously before any lease release. Apply the accepted path gate before any artifact read, then the accepted one-pass structural reader, then the accepted expected-identity boundary against dispatcher-owned `$TASK`, `$CHECKOUT`, `$RUN_ID`, and `$LOG_DIR`. Only acceptance may reach `release_lock` and exit 0. A missing, path-refused, structurally refused, or identity-refused result must take the existing terminal-unprovability route: record one bounded truthful refusal cause through the shared lease owner, pin both owned leases before `die()` or the EXIT trap can release them, exit 38 without claiming completion, and make a subsequent dispatcher refuse with exit 17.

This is zero-wait same-process consumption: the producer's successful atomic rename has already completed before the read begins, and the accepted reader's byte, line, and value caps bound the read below the actor timeout. Do not add polling, sleep, a wrapper, a last-run pointer, directory scanning, a previous-run consumer, a second parser, a second lifecycle reader, another terminal store, or Gate ST recovery state. Do not source an expectation or refusal decision from the artifact, state prose, Git, or logs.

Governing authority and settled evidence:

- The content-bound-approved plan governs: Change set A required behavior items 5–7, trusted-field ownership, the result-before-release order, hostile-input refusal, and § 8's vertical-behavior and one-production-owner rules.
- Units 5–9 are accepted. Reuse the accepted atomic producer, path gate, structural parser, identity boundary, completion/takeover seam, and truthful terminal-unprovability lease pin; do not redesign or broadly re-prove them.
- Unit 9 established that the next-run alternative lacks an independently owned prior run identity and would require a trust inversion or new durable state. It remains excluded.
- Realignment already removed a detached classification-tuple validator. Add no broader semantic validator in this unit.

Check against the repository before editing:

1. Verify the operator-terminal seam still finalizes then releases without calling `validate_terminal_result_path()`, `validate_terminal_result()`, or `validate_terminal_result_identity()`.
2. Verify all four expected values are live dispatcher-owned variables at that seam and that the exact promised path is derivable without reading or scanning artifact content.
3. Verify the existing terminal-unprovability route can carry one bounded validator refusal token into shared-library-owned lease evidence before both release paths run. If it cannot, hand back the exact narrow conflict rather than adding a second lease writer or widening into general reason taxonomy.

Required fail-capable evidence:

- quote the targeted wrong-identity red before the primary edit and the corresponding green after it;
- show a valid `CLOSED` and a valid `BLOCKED_OPERATOR` result each pass the composed consumer, finalize exactly once, exit 0, release both leases, and permit a subsequent acquire;
- show a missing promised result exits 38, claims no completion, records a bounded missing/refusal cause through the shared lease library, retains both leases across `die()` and the EXIT trap, and makes the next dispatcher exit 17;
- show a structurally valid promised-path record with another run identity is refused before release with the bounded identity token, the same exit-38 retention behavior, and no expectation sourced from that record;
- include one mutation control that removes or bypasses only the consumer gate and makes the wrong-identity path exit 0 and release again;
- show the production composition calls path gate → structural reader → identity boundary in that order, parses once, and adds no second parser, lifecycle reader, terminal store, wrapper, poller, or result search;
- re-run only the focused operator-terminal/consumer cases and the directly affected accepted validator cases; do not run full dispatcher, validator, lease, carrier, or mutation matrices;
- report pre-unit and handback commits and exact committed paths; and
- prove only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state changed. `logs/friction-log.md` remains outside the unit and must stay untouched and uncommitted.

Capability subset: baseline only — read/search the approved plan and accepted Units 5–9, edit only `dispatch.sh`, `dispatch.test.sh`, and this task state, run focused local checks, and make the local handback commit. The baseline deny set is required in full. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed.

Completion condition: one local commit makes the real operator-terminal path consume only its promised, structurally valid, expected-identity result before release; valid completion/takeover still exit 0 and release; missing or wrong-identity evidence exits 38 with truthful shared-library pin evidence and blocks the next dispatcher at 17; the accepted validators remain single-owned and single-parse; no deferred family, wrapper, waiting subsystem, or broader semantic layer is integrated; only the three permitted paths change; and the task hands back with `turn: codex`.

Stop and hand back without widening if the operator seam lacks any independently owned expectation, the accepted validators cannot compose without a second parser or lifecycle reader, the refusal token cannot reach shared-library pin evidence through the existing terminal-unprovability path, or safe retention would require new durable state, polling, Gate ST recovery machinery, or another production owner. Challenge a false premise rather than designing around it.

## Latest result

Inspected (2026-08-17):
- Claim (1): HOLDS — read the operator-terminal seam in `dispatch.sh` (`finalize_terminal_result 0 || die_terminal_unprovable`, then `release_lock`, `exit 0`); searched `dispatch.sh` for production calls of `validate_terminal_result_path`, `validate_terminal_result`, `validate_terminal_result_identity`; only the three definitions matched — no consumer stood between finalization and release.
- Claim (2): HOLDS — `$TASK` and `$CHECKOUT` are required arguments, `$CHECKOUT` canonicalized at admission, `LOG_DIR_ABS` is the canonical evidence root computed at admission, and `RUN_ID` is composed before the first hop; the promised path is `$LOG_DIR_ABS/$RUN_ID.result`, derived from those two owned values with no artifact read or directory scan.
- Claim (3): HOLDS — the route `die_terminal_unprovable` → `pin_lock_terminal` → `wl_lease_pin_terminal` accepts a free-text cause as its first argument in the shared lease library (`logs/scripts/work-loop-lease.sh`), and `WL_LEASE_PINNED` is set before `die()` or the EXIT trap can reach `wl_lease_release`; one optional cause parameter on the dispatcher's own `pin_lock_terminal` carries the validator's bounded token with no second lease writer and no reason taxonomy.

Result: the real operator-terminal seam now consumes its promised run-bound result before any lease release. After successful finalization, `consume_terminal_result` derives the promised path from `LOG_DIR_ABS` and `RUN_ID` and composes the accepted boundaries in the current shell — path gate, then the one structural parse, then the expected-identity comparison against dispatcher-owned `$TASK`, `$CHECKOUT`, `$RUN_ID`, `$LOG_DIR_ABS` — with refusal tokens carried through a scratch file beside the run log (the validators hand state through globals, so `$(...)` capture would break the chain; same mechanic as the harness's own `ident_run`). Only acceptance reaches `release_lock` and exit 0. Every refusal — missing, path-refused, structurally refused, identity-refused — leaves through the new `die_terminal_untrusted`, which pins both owned leases via the parameterized `pin_lock_terminal` with the truthful cause "the promised terminal result … was refused before release: <token>", clears `RESULT_FILE` so the refused artifact is never advertised as this run's evidence, and exits 38; a subsequent dispatcher is refused at 17. The accepted case 55d M18 mutation control was updated to the new truthful observable: with the finalization call deleted, the consumer refuses the absent result at 38 (previously that mutant exited 0 with no result — the pre-Unit-8 hole this unit closes from the other side); 55a remains fail-capable.

Evidence: red quoted before the primary edit — the swap fixture (structurally valid result, `run=` rewritten after finalization, before release) exited 0 on the pre-unit dispatcher, released both leases, and the next dispatcher was admitted at exit 0; the missing-result fixture likewise. The committed focused suite (harness prelude + cases 55 + 56) run against the pre-unit dispatcher: 41 pass / 12 fail, the failures being exactly the consumer cases (56b wrong-identity, 56c missing, 56d control, 56e composition, updated 55d M18). Against the edited dispatcher: 55 pass / 0 fail. Valid `CLOSED` and `BLOCKED_OPERATOR` results pass the composed consumer, finalize exactly once with no partial and no consumer scratch left, exit 0, release both leases, and a subsequent acquire is admitted (56a). The wrong-identity swap is refused with the bounded `run-mismatch` token recorded in both pins under the library's `terminal result unprovable:` line; the missing result records `unreadable`; both retain the leases across `die()` and the EXIT trap and refuse the next dispatcher at 17 (56b, 56c). Mutation control M22 removes only the `# operator terminal consumption` call and the wrong-identity path exits 0 and releases again (56d). Case 56e pins the shape: one call each of gate → parse → identity in that order, exactly one production consumer call site, no sleep and no listing. No full dispatcher, validator, lease, carrier, or mutation matrix was run.

Pre-unit commit: `4eb88c92dae48ca90d92abedae77979386806e98`. The handback commit is this state file's own commit, touching exactly `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this state file. `logs/friction-log.md` carries unrelated pre-existing session notes and stays untouched by this unit and uncommitted.

Accepted earlier boundaries remain single-owned and single-parse: one atomic v1 terminal producer, one path gate, one structural parser, one identity boundary, one lease writer. The `die()` funnel's ignored finalizer return, terminal families A–C, M and the remaining N sites (including the dry-run and carry-one exits, which still release without a terminal result), status rendering, resume, and crash-boundary recovery beyond this seam all remain the named deferred concerns — observed again, not absorbed.

## Blocker

None.

## Next action

Codex: assess Unit 10 — the operator-terminal consumer gate, its red/green and mutation evidence, and the updated M18 control — and decide close, continue, or correct once.
