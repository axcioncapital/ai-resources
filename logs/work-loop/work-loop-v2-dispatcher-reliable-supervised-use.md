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

Standard. Implementation mode. Unit 30 — enforce expected meaning at the interruption terminal

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 29 is accepted at `8487c813656ebd33d7cb16f0c085cebec1cf2740`: the post-hop carry-one terminal now supplies independently expected `CARRY_ONE_COMPLETE`/0 before release. The targeted red showed both one-field alterations exiting 0 and releasing; the green routes each through the distinct exit-38 retained-lease cause; M36 removes only the carry-one pair and restores both unsafe accepts; and case 62c names operator, dry-run and carry-one as the three migrated consumers. Change set A still has one existing releasing consumer without semantic agreement, so migrate exactly the interruption terminal; the shared nonzero `die()` funnel finalizes without consuming and remains a separate deliverable.

Current position: the approved plan is content-bound at `e9a6fd8bc51992a1ce8f6e09dcf95b273dd07240` (plan blob `43c44e01703c8622482d93d80407ddc1c83e038a`) against baseline `2451e3df5b8616e035a39a679799738a975b642e`; Change set A remains in progress after 29 accepted units. This unit is justified by the plan's exact run-bound producer/consumer and release-order requirements. The plan and canonical Work Loop govern; current dispatcher comments and tests are verify-first repository evidence.

Dominant deliverable: every interruption terminal that has run evidence releases its leases only after its promised result agrees with the outcome and code that this caller independently expected.
Evidence required in this hop: one targeted red/green interruption semantic-consumer case covering the two one-field mismatches, plus one focused load-bearing control that removes only this caller's expected pair.
Evidence explicitly deferred: adding a consumer to the shared nonzero `die()` funnel or changing any other terminal seam; validation of fields beyond outcome/code; broad all-terminal guards; remaining Change set A terminal-family migration; Change sets B–D; live trials; adoption review; the full synchronous regression gate; merge, push, deployment and destructive cleanup.
Primary edit begins after: quote a focused pre-edit real interruption after a launched actor in which a result altered after successful finalization only in `outcome` or only in `code` still passes the current interruption consumer, exits 28 and releases both leases after clean teardown.

Required outcome:

- The existing interruption release seam establishes expected outcome/code from dispatcher-owned facts independently of the artifact, and requires the accepted semantic boundary after path, structure and identity but before release.
- Genuine post-launch and eligible pre-launch interruptions still exit 28, record `INTERRUPTED` with code 28, preserve their accepted stage/actor/model facts and truthful dynamic terminal labels, and release only after clean teardown and successful consumption. An outcome-only mismatch is refused with `outcome-mismatch`; a code-only mismatch is refused with `code-mismatch`. Each uses the existing untrusted-result path: exit 38, no false result advertisement, both leases retained with the truthful token, and the next dispatcher refused.
- `result_outcome()` remains the sole code-to-outcome owner. The interruption caller must derive its expected symbol through `result_outcome 28` and use literal code 28 independently of the artifact; it must not hard-code a second mapping, read an expectation from the result, compare the artifact with itself, reparse it, or add another semantic reader.
- Preserve the accepted order and snapshot: promised-path gate → one structural parse → expected identity → expected outcome/code → release. Preserve the existing launched-actor/pre-launch `term_label` split and shared refusal wording.
- Only the interruption consumer becomes newly subject to semantic agreement in this unit. The accepted operator, dry-run and carry-one integrations stay intact; the nonzero `die()` funnel remains behaviorally unchanged and explicitly deferred.
- Update only the focused caller-composition assertion directly affected by the fourth migrated caller. It must name all four production consumers as supplying expectations and none as deferred, while explicitly saying that this does not claim the nonzero funnel consumes a result.

Check against the repository before editing:

1. Verify Units 27–29's operator, dry-run and carry-one integrations remain present and that the interruption call site still supplies only its dynamic label. If interruption is already semantically integrated, hand back.
2. Verify `on_signal()` finalizes code 28 and consumes the exact promised result under the same `RUN_ID`/`LOG_DIR` eligibility guard before advertising, releasing and exiting 28; verify `result_outcome 28` resolves `INTERRUPTED` without artifact input.
3. Reproduce the named red by forcing a real launched-actor interruption artifact, after successful finalization and before consumption, to retain valid path/structure/identity while changing only outcome or only code. If the current consumer already refuses both for the intended semantic reason, hand back.
4. Verify case 27 owns post-launch and eligible pre-launch interruption publication/consumption, truthful facts and labels, clean release, finalization failure, and its existing integration controls. Extend that focused owner rather than creating a parallel broad matrix.
5. Verify case 62c currently names operator, dry-run and carry-one as supplying expectations and interruption alone as deferred. Update only that composition and its immediately false wording. If the nonzero funnel or another terminal must change, hand back rather than widening.

Required fail-capable evidence:

- Quote the focused red and green. Red: both one-field alterations exit 28, advertise the altered result and release after clean teardown. Green: each exits 38 with its distinct semantic token, advertises no refused result, retains both leases with that cause, names the launched-actor interruption terminal rather than a real operator terminal, and makes the next dispatcher refuse.
- Show the expected pair is established independently of the artifact through the sole mapping owner. Keep both accepted genuine windows green: post-launch remains `INTERRUPTED`/28 with its post-hop facts, and eligible pre-launch remains `INTERRUPTED`/28 with its pre-hop/no-actor facts and truthful label.
- Add one focused mutation/control that removes only the interruption call site's expected-pair arguments while preserving its dynamic label, eligibility guard, consumer call and path, structure and identity boundaries. It must match exactly once, differ, parse, leave the operator, dry-run and carry-one pairs intact, and restore exit 28 plus release for both mismatches; fail closed if it cannot run.
- Prove all four production consumer call sites now supply expectations and none remains deferred. State explicitly that the shared nonzero `die()` funnel still consumes nothing and is not covered by that assertion; keep one representative previously migrated consumer behavior green.
- Run only the interruption-owned case 27 and focused composition/integration case 62, plus `bash -n` on both shell files. Do not rerun the full dispatcher suite or rebuild accepted shared-validator evidence.
- Report the implementation commit and exact changed paths. Only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state may change; `logs/friction-log.md` remains pre-existing noise and must not be staged or committed.

Capability subset: baseline only — inspect the approved plan and accepted dispatcher/test seams; edit only the two spike files and this state; run focused local checks and shell syntax validation; make the local handback commit. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No external service, production action or operator-reserved capability is needed.

Completion condition: one committed integration makes every eligible interruption terminal's lease release depend on independently expected `INTERRUPTED`/28 as well as the three accepted trust boundaries; genuine pre- and post-launch interruptions remain truthful and release after clean teardown, both launched-actor one-field mismatches fail closed through the existing retained-lease route, the focused removal control restores the unsafe exit-28 releases, all four named production consumers now supply expectations without claiming the nonzero funnel does, only the three permitted paths change, and the state returns with `turn: codex`.

Stop and hand back if interruption is already equivalently integrated; if its expected pair cannot be established independently through the accepted owner; if the work requires reparsing, a second mapping, schema/vocabulary change or another pin/exit owner; if the nonzero funnel or another terminal must change; or if the focused proof cannot isolate semantic refusal from the earlier trust boundaries. Challenge a false premise rather than widening.

## Latest result

Inspected (2026-08-17):

- Claim (1): HOLDS — searched `dispatch.sh` for `consume_terminal_result` at non-comment lines; four production call sites, of which dry-run (3981), operator (4067) and carry-one (4348) each carry `"$(result_outcome 0)" 0`, and interruption (2616) carried `"$term_label"` alone. Units 27–29 intact; interruption was not yet semantically integrated.
- Claim (2): HOLDS — read `on_signal()` 2613–2623: `term_label` splits on `ACTOR_PROCESS_STARTED` (2613–2614), then `[ -n "${RUN_ID:-}" ] && [ -n "${LOG_DIR:-}" ] && { finalize_terminal_result 28 || die_terminal_unprovable "$term_label"; }` (2615) and the same guard before `consume_terminal_result` (2616) — one eligibility condition, identical on both lines — then the `terminal result:` advertisement (2617–2620), `release_lock` and `exit 28`. Searched `result_outcome()` for a code-28 branch: line 593 is a constant-table entry `28) printf 'INTERRUPTED'`, with no artifact, mode, lifecycle or fork input.
- Claim (3): HOLDS — reproduced. On a real launched-actor interruption (hung simulated actor, SIGTERM to the backgrounded dispatcher), with one guarded altering `sed` injected after the `# interruption terminal finalization` marker: `outcome` altered to `COMPLETED` gave `rc=28`, record `outcome=COMPLETED code=28 stage=post-hop actor_launched=yes`, `terminal result:` advertised, both leases released; `code` altered to `22` gave `rc=28`, `outcome=INTERRUPTED code=22`, advertised, both leases released. The current consumer refused neither.
- Claim (4): HOLDS — read case 27: 27r owns post-launch publication, consumption, truthful facts, the evidence pointer and clean release; 27u owns the eligible pre-launch window with its pre-hop/no-actor facts and truthful label; 27s owns publication failure; 27t (M29) and 27v (M31) are the existing integration and widening controls. The new work extends this owner (27w, 27x) rather than adding a matrix.
- Claim (5): HOLDS — read case 62c: `SUPPLY62` was asserted as the sorted set `carry-one;dry-run;operator;` and `NOSUPPLY62` as `interruption;`.
- Packaging lines: HOLD — all four present and non-empty for Implementation mode, with a single dominant deliverable.
- Also verified before editing, because the edit sits on the line they select: M29 (case 27t) matches the marker `# interruption terminal consumption`, and M31 (case 27v) matches the guard prefix `[ -n "${RUN_ID:-}" ] && [ -n "${LOG_DIR:-}" ] &&` exactly twice. Appending the pair before the trailing marker leaves both selectors matching as before, and both controls stayed green.

Result: the interruption terminal is the fourth and last production consumer to be migrated. `dispatch.sh` 2616 now reads `consume_terminal_result "$term_label" "$(result_outcome 28)" 28`, so every eligible interruption releases its leases only after the promised record's outcome and code agree with the ending this caller independently expected, on top of path, structure and identity. The pair is not split by window and the label still is: code 28 has no branch inside `result_outcome()`, so both windows expect the same ending, while the record's own `stage`, `actor_launched` and `model_request_started` continue to tell them apart. The run-evidence eligibility guard, the dynamic `term_label` and the shared refusal wording are unchanged; the nonzero `die()` funnel was not touched.

Evidence: the red above is the failing case; the green is the same two fixtures against the edited dispatcher. Each now exits 38 rather than 28, advertises no terminal result, prints `reached the interruption terminal after a launched actor` and never `reached a real operator terminal`, retains both leases with the bounded cause (`outcome-mismatch` and `code-mismatch`, and not `could not finalize`), and makes the next dispatcher exit 17 — case 27w. Case 27x adds M37, which strips only this call site's two expectation arguments while asserting that its dynamic label, its guarded consumer call, both eligibility guards and the operator, dry-run and carry-one pairs all survive; it differs, parses, and restores exit 28 plus release for both mismatches, and fails closed if the selector does not match exactly once. 27w also asserts structurally that this call site derives its pair through `result_outcome 28` and reads nothing from the artifact. Both genuine windows stayed green against the integrated dispatcher: 27r keeps `INTERRUPTED`/28 with post-hop facts, the evidence pointer and release after clean teardown, and 27u keeps `INTERRUPTED`/28 with pre-hop/no-actor facts, its counted (not fabricated) foreign-path total, its bounded tokens and its truthful pre-launch label. Case 62c now proves all four consumer call sites supply expectations and that none is left deferred, and it says in the assertion text itself that this makes no claim about the shared nonzero `die()` funnel, which consumes nothing; its carry-one behavioural run is the representative previously-migrated consumer kept green.

Focused cases 27 and 62 reported `pass=228 fail=0`. `bash -n` passed on both shell files. The full dispatcher suite was not rerun and accepted shared-validator evidence was not rebuilt, as the brief required. Changed paths: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` and this state file. `logs/friction-log.md` was left unstaged.

Two wording lines in case 62 were corrected in the same edit because this migration made them false: its section echo said "exactly three seams supply one", and its header comment named interruption as still deferred.

The earlier wording deferral remains outside this unit: the shared untrusted-result sentence describes semantic refusal in provenance terms (`failed this run's own consumer gate`). One new deferral is recorded: with all four consumers migrated, the shared nonzero `die()` funnel is the only remaining terminal seam that finalizes without consuming a result — it was explicitly deferred by this brief, is not covered by 62c's empty deferred list, and stays a distinct deliverable.

## Blocker

None.

## Next action

Codex: assess Unit 30 — whether every eligible interruption terminal's release now depends on independently expected `INTERRUPTED`/28, whether the red/green and M37 control are fail-capable and scoped to this one consumer, whether both accepted interruption windows and the two existing controls (M29, M31) are genuinely unchanged, and whether 62c's empty deferred list is stated without implying the nonzero funnel is covered. Then close, continue, correct once, or stop.
