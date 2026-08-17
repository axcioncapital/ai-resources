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

Standard. Implementation mode. Unit 8 — terminalize closed and blocked operator exits.

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Change set A remains active. Units 5–7 established an atomic v1 producer for the D–L `die()` funnel plus exact structural and expected-identity validation, but successful completion and operator takeover still exit the real loop with code 0 and no terminal result. This unit returns to the approved operating outcome: one real loop-mode terminal seam must durably distinguish completion from takeover before the dispatcher reports success or releases its lease.

Dominant deliverable: one atomic terminalization seam for the real loop-mode `turn: operator` exit, producing truthful distinct results for canonical `CLOSED` completion and `BLOCKED_OPERATOR` takeover.
Evidence required in this hop: a focused red/green controller case proves the current closed path exits 0 without a result, then proves both canonical operator classifications finalize exactly one valid run-bound result before release; a focused control proves completion and takeover cannot collapse to one outcome.
Evidence explicitly deferred: dry-run and `--carry-one` zero exits; other uncovered terminal families A–C, M, and N; a general semantic validator; first result consumer and finite waiting; missing-result canonical-state conversion beyond fail-closed terminalization; wider cross-field semantics; moving run identity earlier; full durable crash-boundary injection and recovery; Change sets B–D; broad regression matrices; live trials; adoption review; merge, push, deployment, and destructive cleanup.
Primary edit begins after: add and run one focused loop-mode fixture that reaches a valid `CLOSED` record at `turn: operator`, observes exit 0, and proves the promised `$LOG_DIR/$RUN_ID.result` is absent.

Required outcome: when loop mode reaches `turn: operator`, use the canonical validator classification already established by `validate_state()` to finalize exactly one atomic v1 terminal result before lease release and exit. `CLOSED` must record a bounded completion outcome and next action; `BLOCKED_OPERATOR` must record a distinct bounded operator-takeover outcome and next action. Both must truthfully carry code 0, run identity, actor/hop facts, canonical state classification, before/after evidence already available, owner/lease observations, and `result_complete=yes` through the accepted producer.

The path may exit 0 only when the promised complete result exists. If finalization cannot be proven, fail closed without clearing the applicable lease or claiming completion; do not reconstruct evidence from state prose, Git, or logs. Preserve the accepted ordering that the result exists before release. Reuse the existing producer and mappings rather than introducing a second producer, parser, lifecycle reader, terminal store, or general semantic-validator layer.

This is one real terminal seam, not all remaining exits. Do not absorb dry-run, `--carry-one`, argument/runtime/lease/signal families, a consumer, waiting, transition redesign, status rendering, resume, or Change set B work.

Governing authority and settled evidence:

- The content-bound-approved plan governs: § 1's two trustworthy run outcomes; Change set A required behavior items 2–7; the durable order requiring terminal result before lease release; canonical lifecycle classification; and § 8's vertical-behavior and one-production-owner rules.
- Unit 7 is accepted at `0681544f9e87f703fb5a53a58a24e1205774607d`. Do not redesign or re-prove its parser/identity boundary before the primary edit; use it only to validate this unit's produced result.
- Realignment removed the proposed detached classification-tuple validator. Codex's framing decision: semantic classification is implemented only as needed by this real completion/takeover seam; a general tuple validator remains deferred until a consumer demonstrates the need.

Check against the repository before editing:

1. Verify the loop's `turn: operator` block still receives canonical `CLOSED` versus `BLOCKED_OPERATOR` through `validate_state()`, then calls `release_lock` and `exit 0` without `finalize_terminal_result()`.
2. Verify this one block covers both an initially terminal loop-mode invocation and a loop that reaches operator after a valid hop, while dry-run and `--carry-one` exit through separate sites.
3. Verify the accepted producer can express truthful distinct code-0 completion/takeover outcomes without a second terminal writer or lifecycle parser. If not, hand back the exact narrow-helper or premise conflict rather than widening.

Required fail-capable evidence:

- quote the targeted closed-path red showing exit 0 with no promised terminal result, then the focused green;
- show a valid `CLOSED` loop-mode terminal produces exactly one structurally valid, identity-valid result with completion outcome and no further actor action;
- show a valid `BLOCKED_OPERATOR` loop-mode terminal produces exactly one structurally valid, identity-valid result with a distinct takeover outcome and operator action;
- prove result finalization occurs before lease release, and a forced finalization failure cannot exit 0, claim completion, or silently clear the lease;
- include one mutation or negative control that removes/bypasses terminalization and exposes the missing result, plus one control that collapses the two classifications and makes the distinction check fail;
- show no actor launches after either terminal classification and no second producer/parser/lifecycle reader was added;
- run only the focused operator-terminal cases and the accepted validator cases directly affected; do not run the full dispatcher suite or reconstruct prior mutation matrices;
- report pre-unit and handback commits and exact committed paths; and
- prove only `dispatch.sh`, `dispatch.test.sh`, and this task state changed. `logs/friction-log.md` remains outside the unit and must stay untouched and uncommitted.

Capability subset: baseline only — read/search the approved plan and accepted Units 5–7, edit only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state, run focused local checks, and make the local handback commit. The baseline deny set is required in full. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed.

Completion condition: one local commit makes the real loop-mode operator terminal produce truthful distinct completion/takeover results before release, focused fail-capable proof is green, finalization failure cannot become exit-0 success, the accepted producer/parser/identity boundaries remain intact, no deferred exit family or consumer is integrated, only the three permitted paths change, and the task hands back with `turn: codex`.

Stop and hand back without widening if the operator block does not own both canonical classifications, truthful terminalization requires a second producer or lifecycle parser, or failure-safe ordering cannot be isolated from broader crash recovery. Challenge a false premise rather than building around it.

## Latest result

Unit 8 final fix (the correction menu's one final tightly-bounded fix) — **implemented and green**.

Inspected for the final fix (2026-08-17), both frozen gaps reproduced red before the primary edit:

- Lease gap: a driver-mode call to `wl_lease_pin_terminal` returned 127 (helper absent), `wl_lease_release` then removed both leases and the next contender was admitted — focused lease block red `4/5`.
- Dispatcher gap: forcing finalization failure at the real pre-fix operator seam (sed the seam's `finalize_terminal_result 0 ||` to an absent finalizer) exited 38 with **both owned lease directories released** and a second dispatcher admitted with exit 0 — focused dispatch block red `27/5`.

Result: exit 38 at the real operator terminal now fails closed holding its leases. The library gained one backward-compatible entry point, `wl_lease_pin_terminal <unprovable-reason> [task-label]` — same three outcomes, same both-leases rule and partial-acquisition guards as `wl_lease_pin`, sharing one factored write-and-verify core (`wl_lease__pin_owned`) so the two causes cannot drift — writing its own truthful record: the `PINNED by pid` marker every reader already keys on, a `terminal result unprovable: <reason>` cause line, and clear-guidance that names no pids because none are implicated. The dispatcher consumes it through `pin_lock_terminal()` (dispatcher wording and exit-17 messaging beside `pin_lock()`, evidence written only by the library) inside `die_terminal_unprovable()`: pin first, then `die 38`, so the pin already stands before `die()`'s `release_lock` and the EXIT trap run. The seam is unchanged in shape — `finalize_terminal_result 0 || die_terminal_unprovable` at `dispatch.sh:3516`, still one line under the existing M18 marker — and the retention call carries its own marker comment so M21 can delete exactly it.

Evidence: focused red lease `4/5` and dispatch `27/5`; green lease `9/0` (new Case 23) and dispatch `33/0` (cases 55a–55f). Pre-unit commit for this fix `3e60b01b`.

- New helper case (lease Case 23): the terminal pin reports `rc=0 pinned=1`, release leaves BOTH leases, every owned lease carries the marker and the `terminal result unprovable:` line with no `descendants still running:`, no `sweep incomplete:` and no descendant prose; the next run is refused 17 with `refusal=pinned`. A same-case control proves the ordinary teardown pin still writes `descendants still running: 4242` and its unchanged guidance prose — the existing cause and its format are untouched.
- Forced failure at the real seam (dispatch 55e): exit 38, no completion claim, both lease dirs survive `die()` and the EXIT trap, both carry the truthful cause, and a second real dispatcher on the same sandbox is refused with exit 17.
- Mutation control M21 removes only the retention call by its marker: forced failure then exits 38 with both leases released by the EXIT path — the retention call is what does the work, and the new case is fail-capable. The forcing mutant itself is the second control (pre-fix behaviour exactly).
- Ordinary paths intact (55f, plus 55a/55b re-run green): `CLOSED` and `BLOCKED_OPERATOR` still finalize exactly one result each and release both leases normally afterwards.
- Single owner intact: `finalize_terminal_result` has exactly two call sites (`die()` at `dispatch.sh:1187`, the seam at `dispatch.sh:3516`); no `survivors` write exists in `dispatch.sh`; no second producer, parser or lifecycle reader was added.
- `wl_lease_pin`'s signature, return codes and text are unchanged, so no carrier contract changed — inspection confirmed `carry-turn.sh` consumes `wl_lease_pin` only, and `carry-turn.test.sh` was therefore not touched, per the correction boundary.
- Only `dispatch.sh`, `dispatch.test.sh`, `logs/scripts/work-loop-lease.sh`, `logs/scripts/work-loop-lease.test.sh` and this state file changed. `logs/friction-log.md` was already dirty beforehand, was not touched, and is not committed.

Candidate deferral, noticed and not done: `--status`'s PINNED branch still opens with the teardown-flavored header "the previous run could not confirm it stopped everything it started" before printing the pin record verbatim; the verbatim record carries the truthful cause, so the header is cosmetic-misleading only, and rewording it was outside the frozen finding.

---

Unit 8's hand-back evidence follows, unchanged.

Inspected (2026-08-17):

- Claim (1): HOLDS — read the loop's operator block at `dispatch.sh:3390-3416` (pre-unit `0681544f`). It sits at the top of `while :; do validate_state; ...`, branches on `closing_record_ok()`, which is `[ "${ST_CLASS:-}" = CLOSED ]` at `dispatch.sh:3000-3002`, and then runs `release_lock` and `exit 0`. Searched the block for `finalize_terminal_result` — no match; the only call was `die()`'s at `dispatch.sh:1146`.
- Claim (2): HOLDS — the block's position at the top of the loop covers both an initially terminal invocation (hop 0) and a loop reaching operator after a hop. Dry-run exits separately at `dispatch.sh:3365-3383` under `[ "$DRY_RUN" -eq 1 ]`, status mode at `dispatch.sh:2314`, and `--carry-one` at `dispatch.sh:3648-3658` at the *end* of the loop body. Four distinct sites; this unit touched only the operator one.
- Claim (3): HOLDS — `result_outcome()` and `result_next_action()` key on the exit code alone, and code 0 was unmapped in both (falling to `UNCLASSIFIED` / `operator-read-run-log`). Both could express the distinction by consulting `ST_CLASS`, which `validate_state()` already set from the canonical validator, so no second producer, parser or lifecycle reader was needed.

Result: the real loop-mode `turn: operator` seam now finalizes exactly one atomic v1 result before releasing its lease. `CLOSED` records `COMPLETED` / `none-task-closed`; `BLOCKED_OPERATOR` records `OPERATOR_TAKEOVER` / `operator-answer-the-blocking-question`. Both carry code 0 truthfully — neither is a failure — with the distinction living in the record rather than the exit code, keyed on `ST_CLASS` and never re-derived. The seam is one line (`dispatch.sh:3470`) so a mutation control can remove it whole, and it fails closed: a terminal whose result cannot be written exits 38 instead of 0.

**One judgment call, disclosed for Codex.** The fail-closed branch needed an exit code. Code 26 (`MALFORMED_TERMINAL`) is documented at `dispatch.sh:160-161` as *the state file is neither a § 7 question nor a § 4 closing record*, and its next action sends the operator to repair that file — which would be a false instrument here, since the state file is fine and the write is what failed. Codes 27 and 32 are marked at `dispatch.sh:186-190` as gaps with "Do not reuse either number." So I added **38 `TERMINAL_UNPROVABLE`** to the existing table and both existing mappings. That is a new exit code, not a new producer or layer, and I judged a truthful code inside the accepted producer better than a misleading reuse. If Codex disagrees, the alternative is reusing 26 and accepting a wrong next action.

Evidence: focused red `76/15`, green `95/0`. Per case: 51 `27/0`, 52 `22/0`, 53 `14/0`, 54 `10/0`, 55 `22/0`. Pre-unit commit `0681544f9e87f703fb5a53a58a24e1205774607d`.

- The targeted red the brief asked for, quoted together so the pair is the point: `PASS 55a — a CLOSED record is not a failure and still exits 0` beside `FAIL 55a — the CLOSED terminal left the promised run-bound result / missing …/20260817T114602--87447-closed-task.result; runs/ holds: …log`. Exit 0, run log present, promised result absent.
- `CLOSED` now produces exactly one finalized result and no leftover `.partial`, judged by the accepted boundary rather than by harness `sed`: structurally valid v1 *and* identity-valid for its own task, checkout, run and promised path. It carries `code=0`, `state_class=CLOSED`, `result_complete=yes`, and `actor_launched=no` with zero recorded actor invocations.
- `BLOCKED_OPERATOR` produces its own structurally and identity-valid result carrying `code=0` and `state_class=BLOCKED_OPERATOR`.
- The distinction is asserted as a *difference* between the two records, not against hard-coded words — a test pinning exact strings would stay green through a rename that made both identical. A third assertion proves neither fell through to the `UNCLASSIFIED` fallback, which separates "mapped" from "merely non-empty".
- Three mutation controls, each verified to be valid bash before being trusted: M18 deletes the seam by its marker comment (deleting by function name would also remove `die()`'s call and prove something else) → the CLOSED path exits 0 with no result, the pre-unit behaviour exactly. M19 collapses the two classifications → both terminals report `COMPLETED` and 55c fails. M20 points the seam at a finalizer that does not exist → exit 38 and `TERMINAL_UNPROVABLE`, never completion.
- Ordering and fail-closed: finalization precedes `release_lock` in source order at the seam, matching `die()`'s accepted ordering. M20 proves a run that cannot prove its terminal exits 38, reports `TERMINAL_UNPROVABLE`, and claims no completion.
- Single owner intact: `finalize_terminal_result` has exactly two call sites — `die()` at `dispatch.sh:1184` and this seam at `dispatch.sh:3470`. No second producer, parser, lifecycle reader or terminal store was added; the classification is read from `ST_CLASS`, never reconstructed from state prose, Git or logs.
- Only `dispatch.sh`, `dispatch.test.sh` and this state file changed. `logs/friction-log.md` was already dirty beforehand, was not touched, and is not committed.

**Partly resolved, stated rather than stretched — the "without clearing the applicable lease" clause.** The fail-closed path does not exit 0 and claims no completion, both proven. It does still release the *run lease*: `die()` calls `release_lock`, and `trap 'release_lock' EXIT` at `dispatch.sh:2137` fires on every exit path regardless. Suppressing that for this one branch means changing global teardown, which is outside this unit and would risk leaking leases on paths this unit does not own. What is fully satisfied is the ownership *declaration*: the dispatcher never clears it on any path — verified by search, and asserted in 55d, so a failed terminal cannot quietly hand the checkout on. Codex should decide whether the run-lease half needs its own unit.

Deferrals unchanged. Nothing new was noticed that needs recording.

---

Unit 7's acceptance record follows, unchanged.

Unit 7 accepted at `0681544f9e87f703fb5a53a58a24e1205774607d`. The result boundary now provides one atomic v1 producer for the D–L `die()` funnel, one exact structural parser, and one expected-identity boundary with pre-read symlink refusal and content/file snapshot binding. Claude reports focused cases 51–54 green at `73/0`; Codex did not duplicate them.

Realignment on 2026-08-17 removed the proposed standalone `code`/`outcome`/`next_action` validator before execution. Material reason: it would add another detached trust layer while the real completion/takeover path still emitted no terminal result and no production route consumed any validator, contrary to the plan's vertical-behavior rule. Accepted Units 5–7 and every fixed scope boundary remain intact.

Accepted deferrals remain: requested permission mode reconstruction until Change set B; loose `changed_paths_since_launch` naming at `stage=launch`; the composed first-consumer wrapper; uncovered terminal families; finite waiting/missing-result handling; wider semantic validation; durable crash recovery; Change sets B–D; regressions, live trials, and adoption review. The cosmetic double dash in sandbox run ids remains deferred.

## Blocker

None.

## Next action

Codex: final closure check on the frozen finding only, two questions:

1. Is the original lease-retention finding fully resolved — forced finalization failure at the real operator seam exits 38, retains both owned leases across `die()` and the EXIT trap with the truthful terminal-result-unprovable cause recorded through the shared lease library, and refuses a second dispatcher with exit 17?
2. Did this final fix break the existing teardown-pin behavior or the ordinary successful `CLOSED` / `BLOCKED_OPERATOR` terminal paths?

Anything else newly noticed is a deferral, not a further correction round. The `--status` PINNED-header wording noted under `## Latest result` is one such candidate.
