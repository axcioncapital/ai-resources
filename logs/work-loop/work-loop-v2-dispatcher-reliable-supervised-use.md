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

Standard. Implementation mode. Unit 12 — finalize dry-run before lease release

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 11 is accepted at `e52337a39a16bd442d6c3ca9499ad099bc479b2b`: the shared `die()` funnel now treats failed terminal publication as terminal-unprovable at exit 38 even when a stronger teardown cause already pinned the leases, while preserving that earlier cause, avoiding re-pin or second publication, and leaving successful finalization and existing pin retention green. Change set A remains active. The next smallest uncovered terminal site is the admitted `--dry-run` success path: accepted discovery shows it owns both leases and initialized run evidence, but it still releases and exits 0 without producing or consuming the run-bound terminal result promised by the plan.

Dominant deliverable: one trusted `--dry-run` terminal-success path that finalizes and validates its exact run-bound result before either owned lease is released.
Evidence required in this hop: one targeted red/green dry-run case proves the current successful path exits 0 and releases without a valid promised result, then proves it writes exactly one valid no-model terminal result, consumes that exact expected-identity artifact before release, retains the existing dry-run report, and admits the next dispatcher; one induced finalization or consumption failure proves exit 38, no success claim, both leases pinned, and the next dispatcher refused at 17.
Evidence explicitly deferred: `--carry-one`; terminal families A–C and M; `--help` and strictly read-only `--status`; other zero-exit sites already covered by the accepted operator-terminal seam; moving run identity earlier; schema expansion or semantic tuple validation; status rendering; resume; crash-boundary recovery beyond this seam; broad terminal-family, hostile-input, lease, carrier, and dispatcher matrices; Change sets B–D; live trials; adoption review; merge, push, deployment, and destructive cleanup.
Primary edit begins after: add and run one focused fixture against a valid admitted `--dry-run` that proves it currently exits 0, launches no actor, releases both leases, leaves no valid promised run-bound terminal result, and allows a subsequent dispatcher to acquire.

Required outcome: make valid `--dry-run` completion obey Change set A's accepted producer/consumer and durable release boundary. After its existing preflight and hazard reporting, it must atomically finalize exactly one truthful code-0 terminal result for the dispatcher-owned run, validate and consume the exact promised path through the accepted structural and expected-identity boundaries, and only then release both leases and exit 0. The result must truthfully show that no model request or actor launch started and must preserve the current operator-visible dry-run report.

If publication or validation of that promised result fails, the path must not claim dry-run success or release through its normal branch or EXIT trap: use the accepted terminal-unprovability route, exit 38, keep both leases pinned with truthful cause, and make a subsequent dispatcher refuse at 17. Reuse the single accepted producer, consumer, path/identity validators, and lease-pin owner. Do not add another result store, parser, lifecycle reader, lease writer, retry, poller, wrapper, reason taxonomy, or recovery state.

Governing authority and settled evidence:

- The content-bound-approved plan governs Change set A required behavior items 2–8, durable order items 5–6, missing-evidence blocking, and § 8's one-production-owner rule. Its strictly read-only `--status` contract remains untouched.
- Units 5–11 are accepted. Reuse their atomic producer, structural and expected-identity validators, same-process consumer, truthful exit-38 pin route, and successful/failing finalization behavior; do not redesign or broadly re-prove them.
- Unit 4's accepted terminal map establishes that `--dry-run` is an admitted N-family run after run evidence initialization, while current source places a direct `release_lock; exit 0` at that terminal. Unit 11's accepted deferral confirms dry-run still releases without a terminal result.
- This unit promotes only `--dry-run`. `--carry-one` is a separate post-hop terminal site with different observables and remains deferred.

Check against the repository before editing:

1. Verify valid `--dry-run` still runs after both leases and run evidence exist, launches no actor, and directly releases then exits 0 without finalization or consumption.
2. Verify the accepted finalizer can truthfully represent this no-model success from dispatcher-owned facts and the accepted consumer can validate its exact task, checkout, run, and path in the same process before release.
3. Verify one focused existing dry-run fixture can distinguish this mode from `--status` and `--carry-one`, preserve its current report, and observe subsequent lease acquisition. If any premise is false, hand back the exact narrow conflict rather than widening the unit.

Required fail-capable evidence:

- quote the targeted pre-edit red: valid dry-run exits 0, launches no actor, releases both leases, writes no valid promised result, and permits the next acquire;
- show the post-edit success writes and consumes exactly one structurally valid expected-identity result with code 0 and truthful no-model/no-actor facts before release, preserves the existing dry-run report, exits 0, and permits the next acquire;
- induce one publication or consumption failure and show exit 38, no dry-run success or valid-result claim, truthful retention of both leases across the EXIT trap, and next-dispatcher refusal at 17;
- include one narrow mutation control that removes or bypasses only the new dry-run finalization/consumption boundary and restores the unsafe result-less release;
- show structurally that `--dry-run` reuses the accepted single producer, consumer, validators, and lease writer and does not change the strictly read-only `--status` branch;
- re-run only the focused dry-run cases and directly affected accepted terminal-result/consumer/pin cases; do not run full dispatcher, terminal-family, validator, lease, carrier, or mutation matrices;
- report pre-unit and handback commits and exact committed paths; and
- prove only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state changed. `logs/friction-log.md` remains outside the unit and must stay untouched and uncommitted.

Capability subset: baseline only — read/search the approved plan and accepted Units 4–11, edit only `dispatch.sh`, `dispatch.test.sh`, and this task state, run focused local checks, and make the local handback commit. The baseline deny set is required in full. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed.

Completion condition: one local commit makes valid admitted `--dry-run` finalize and consume exactly one truthful run-bound terminal result before release; success preserves its no-actor report, exits 0, releases both leases, and admits the next dispatcher; unprovable publication or consumption exits 38 without a success claim, retains both leases truthfully, and blocks the next dispatcher at 17; `--status`, `--carry-one`, every other terminal site, and all deferred subsystems remain outside the change; only the three permitted paths change; and the task hands back with `turn: codex`.

Stop and hand back without widening if dry-run is not an admitted run with both leases and run evidence, the accepted producer/consumer cannot express and validate its no-model success without schema redesign, safe failure cannot reuse the accepted exit-38 pin route, or the focused edit would need to absorb `--status`, `--carry-one`, another terminal family, another parser, or another lease owner. Challenge a false premise rather than designing around it.

## Latest result

Inspected (2026-08-17):
- Claim (1): HOLDS — read the `--dry-run` block in `dispatch.sh`: it runs after both leases are acquired and run evidence exists (`RUN_ID`/`LOG_DIR_ABS` set, `validate_state` already run), launches nothing, and ended in a direct `release_lock; exit 0` with no finalization or consumption call between the report and the release.
- Claim (2): HOLDS — the accepted finalizer derives `mode=dry-run` (set at argument parse), `stage=pre-hop`, `actor_launched=no` and `model_request_started=no` from dispatcher-owned state, so the no-model success is truthfully expressible without schema change; the accepted consumer needs only `$TASK`, `$CHECKOUT`, `$RUN_ID`, `$LOG_DIR_ABS`, all live at that point in the same process.
- Claim (3): HOLDS — plain `--dry-run` fixtures exist in the harness (cases 26, 30c, 32l), `--status --dry-run` together is refused at exit 10 so the modes cannot blur, the stable report observable is the `dry-run: would launch actor …` line, and lease state is observable via the mirrored lock-path helpers plus a second run.

Result: valid admitted `--dry-run` now obeys the accepted producer/consumer boundary before release. After its existing preflight report — preserved verbatim — the seam finalizes exactly one truthful code-0 record and consumes it through the accepted composition (path gate → one structural parse → expected identity) with the same two markers pattern as the operator terminal (`# dry-run terminal finalization`, `# dry-run terminal consumption`). Only acceptance reaches `release_lock; exit 0`. Failed publication routes through the accepted `die_terminal_unprovable`; an untrusted promised artifact routes through the consumer's own `die_terminal_untrusted`; both pin and exit 38. No new producer, consumer, parser, lease writer, store, retry, or poller; `--status` and `--carry-one` are untouched.

Evidence: red quoted before the primary edit — a valid admitted dry-run exited 0, launched no actor, released both leases, left no promised result, and admitted the next dispatcher. The committed focused suite (harness prelude + cases 55–58) against the pre-unit dispatcher: 85 pass / 9 fail, the failures being exactly the new dry-run cases (58a result/validity/truthful-fields, 58b unprovable path, 58c control, 58d shape). Against the edited dispatcher: 95 pass / 0 fail. Success (58a): exit 0, report preserved, no actor, exactly one structurally valid expected-identity result carrying `code=0 mode=dry-run actor_launched=no model_request_started=no stage=pre-hop`, no partial, no consumer scratch, both leases released, next dispatcher admitted. Induced publication failure (58b, evidence directory refusing new entries before the run): exit 38, no result advertised, both leases retained across the EXIT trap with the truthful `could not finalize` cause via the shared lease library, next dispatcher refused at 17. Mutation control M25 (58c) deletes only the two dry-run marker lines, leaves the operator-terminal seam intact, and the result-less exit-0 release returns. 58d pins one call site per marker and behaviorally re-proves `--status` exits 0 with no terminal result and no lease held. Accepted cases 55, 56, 57 pass unchanged in both runs. No full matrices were run.

Pre-unit commit: `e52337a39a16bd442d6c3ca9499ad099bc479b2b`. The handback commit is this state file's own commit, touching exactly `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state. `logs/friction-log.md` remains untouched and uncommitted.

Observation recorded, not acted on: `result_outcome(0)` maps only `CLOSED` and `BLOCKED_OPERATOR`, so a dry-run record carries `outcome=UNCLASSIFIED` — the mapping's deliberate no-guessing fallback; the `mode=dry-run` field carries the distinction. Naming a dry-run outcome symbol would touch the accepted outcome vocabulary and is left as a candidate deferral. Standing deferrals otherwise unchanged: `--carry-one` still releases without a terminal result, terminal families A–C and M, status rendering, resume, crash-boundary recovery beyond this seam.

## Blocker

None.

## Next action

Codex: assess Unit 12 — the dry-run finalize-and-consume boundary, its red/green and M25 control, the preserved report and read-only `--status` proof, and the recorded `outcome=UNCLASSIFIED` observation — and decide close, continue, or correct once.
