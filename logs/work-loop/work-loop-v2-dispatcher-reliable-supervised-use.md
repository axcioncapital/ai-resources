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

Standard. Implementation mode. Unit 28 — enforce expected meaning at the dry-run terminal

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 27 is accepted at `bc8709e8823eb524bff1f2a538933fbab44aadcc`: the loop-mode operator terminal now supplies its independently expected outcome/code to the accepted semantic boundary before release. Valid `CLOSED` and `BLOCKED_OPERATOR` endings still release, both one-field semantic mismatches take the existing exit-38 retained-lease route, M33 removes only the expected pair and restores both unsafe releases, and the focused proof distinguishes the one migrated caller from three deferred consumers. Change set A still requires every terminal result that can advance or release to be trusted, so migrate exactly one next consumer: the admitted dry-run terminal.

Current position: the approved plan is content-bound at `e9a6fd8bc51992a1ce8f6e09dcf95b273dd07240` (plan blob `43c44e01703c8622482d93d80407ddc1c83e038a`) against baseline `2451e3df5b8616e035a39a679799738a975b642e`; Change set A remains in progress after 27 accepted units. This unit is justified by its exact run-bound producer/consumer and release-order requirements. The plan and canonical Work Loop govern; current dispatcher comments and tests are verify-first repository evidence.

Dominant deliverable: the admitted dry-run terminal releases its leases only after its promised result agrees with the outcome and code that this caller independently expected.
Evidence required in this hop: one targeted red/green dry-run semantic-consumer case covering the two one-field mismatches, plus one focused load-bearing control that removes only this caller's expected pair.
Evidence explicitly deferred: semantic integration at carry-one, interruption, the shared nonzero `die()` funnel, or any other terminal seam; validation of fields beyond outcome/code; broad all-terminal guards; remaining Change set A terminal-family migration; Change sets B–D; live trials; adoption review; the full synchronous regression gate; merge, push, deployment and destructive cleanup.
Primary edit begins after: quote a focused pre-edit admitted `--dry-run` in which a result altered after finalization only in `outcome` or only in `code` still passes its current production consumer, exits 0 and releases both leases.

Required outcome:

- The existing admitted `--dry-run` release seam establishes its expected outcome/code from dispatcher-owned facts independently of the artifact, and requires the accepted semantic boundary after path, structure and identity but before release.
- A genuine dry-run result still exits 0, records its accepted dry-run-specific outcome with code 0, launches no actor or model request, and releases both leases. An outcome-only mismatch is refused with `outcome-mismatch`; a code-only mismatch is refused with `code-mismatch`. Each uses the existing untrusted-result path: exit 38, no false result advertisement, both leases retained with the truthful token, and the next dispatcher refused.
- `result_outcome()` remains the sole code-to-outcome owner. The dry-run caller must not hard-code a second outcome mapping, read an expectation from the result, compare the artifact with itself, reparse it, or add another semantic reader.
- Preserve the accepted order and snapshot: promised-path gate → one structural parse → expected identity → expected outcome/code → release.
- Only the dry-run consumer becomes newly subject to semantic agreement in this unit. The accepted operator-terminal integration stays intact; carry-one, interruption and the nonzero funnel remain behaviorally unchanged and explicitly deferred.
- Update only the focused caller-count/composition assertions directly affected by a second migrated caller. They must report two migrated callers and the remaining deferred consumers honestly; do not generalize the claim to every terminal.

Check against the repository before editing:

1. Verify Unit 27's operator-terminal integration remains present and that the admitted dry-run call site still supplies no expected pair. If dry-run is already semantically integrated, hand back.
2. Verify the dry-run terminal finalizes code 0, consumes the exact promised result and releases at one existing seam; verify `result_outcome 0` resolves the dry-run-specific outcome from dispatcher-owned `MODE` before lifecycle state and without artifact input.
3. Reproduce the named red by forcing a real dry-run artifact, after successful finalization and before consumption, to retain valid path/structure/identity while changing only outcome or only code. If the current consumer already refuses both for the intended semantic reason, hand back.
4. Verify existing dry-run cases 58–59 own its publication, consumption, no-model facts, lifecycle-independent outcome, failure retention and read-only-status regressions. Extend that focused owner or one adjacent case rather than creating a parallel broad matrix.
5. Verify the shared consumer's optional-pair behavior permits this second caller without changing the two still-deferred consumer call sites. If another terminal's behavior must change, hand back rather than widening.

Required fail-capable evidence:

- Quote the focused red and green. Red: both one-field alterations exit 0, advertise the altered result and release. Green: each exits 38 with its distinct semantic token, advertises no refused result, retains both leases with that cause, and makes the next dispatcher refuse.
- Show the expected pair is established independently of the artifact through the sole mapping owner, and that a real dry-run still records the accepted dry-run outcome/code and no-actor/no-model facts.
- Add one focused mutation/control that removes only the dry-run call site's expected-pair arguments while preserving its consumer call and the path, structure and identity boundaries. It must match exactly once, differ, parse, and restore exit 0 plus release for both mismatches; fail closed if it cannot run.
- Prove the accepted operator-terminal caller still supplies expectations, exactly two production consumers now supply a pair, and the interruption and carry-one consumers do not. Keep one representative deferred terminal behavior green without implying the nonzero funnel is consumed.
- Keep the standalone semantic-validator case, the accepted operator-terminal integration case, and the directly affected dry-run cases green. Run only that focused slice plus `bash -n` on both shell files; do not run the full dispatcher suite.
- Report the implementation commit and exact changed paths. Only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state may change; `logs/friction-log.md` remains pre-existing noise and must not be staged or committed.

Capability subset: baseline only — inspect the approved plan and accepted dispatcher/test seams; edit only the two spike files and this state; run focused local checks and shell syntax validation; make the local handback commit. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No external service, production action or operator-reserved capability is needed.

Completion condition: one committed integration makes the admitted dry-run terminal's lease release depend on independently expected outcome/code as well as the three accepted trust boundaries; a genuine dry-run remains truthful and releases, both one-field mismatches fail closed through the existing retained-lease route, the focused removal control restores the unsafe accepts, only two production consumer call sites now supply expectations, no deferred terminal changes behavior, only the three permitted paths change, and the state returns with `turn: codex`.

Stop and hand back if dry-run is already equivalently integrated; if its expected pair cannot be established independently through the accepted owner; if the work requires reparsing, a second mapping, schema/vocabulary change or another pin/exit owner; if carry-one, interruption or the nonzero funnel must change; or if the focused proof cannot isolate semantic refusal from the earlier trust boundaries. Challenge a false premise rather than widening.

## Latest result

Inspected (2026-08-17):
- Claim (1): HOLDS — searched `dispatch.sh` for `consume_terminal_result`; four call sites. Line 4036 still carries Unit 27's `"" "$(result_outcome 0)" 0 # operator terminal consumption`; line 3950 was the bare `consume_terminal_result # dry-run terminal consumption`, supplying no expected pair. Dry-run was not integrated.
- Claim (2): HOLDS — the dry-run seam is one block: `finalize_terminal_result 0 || die_terminal_unprovable`, then the consume call, then `[ -n "$RESULT_FILE" ] && say`, `release_lock`, `exit 0`. Searched `dispatch.sh` for `MODE=`; it is set at argument parse (lines 1456–1459) from `DRY_RUN`, never from a state file or artifact, and `result_outcome`'s `0)` branch reads `case "${MODE:-}" in dry-run)` and returns before `CARRY_ONE` and before `ST_CLASS`.
- Claim (3): HOLDS — reproduced by injecting a one-field alteration after the `# dry-run terminal finalization` marker on an unmodified dispatcher. `outcome`→`COMPLETED` gave `rc=0`, both leases released, artifact advertised, over a run that launched nothing; `code`→`22` gave the same. Neither was refused.
- Claim (4): HOLDS — searched `dispatch.test.sh` cases 58–59 (lines 7538–7794 before this edit). 58a owns publication, consumption and the truthful `code=0`/`mode=dry-run`/`actor_launched=no`/`model_request_started=no`/`stage=pre-hop` facts; 58b owns exit-38 retention; 58c owns M25; 58d owns the one-call-site markers and `--status` read-only; 59 owns the lifecycle-independent outcome. Extended 58 with 58e/58f rather than opening a parallel matrix.
- Claim (5): HOLDS — the shared consumer's guard is `[ -n "$x_outcome" ] || [ -n "$x_code" ]`, so a second supplying caller is invisible to the interruption (line 2616) and carry-one (line 4288) call sites, which still pass label-only arguments.

Result: the admitted `--dry-run` terminal now releases only after the promised record's `outcome` and `code` agree with what this caller independently expected. It supplies `"$(result_outcome 0)"` and the literal `0` to the already-shared consumer; no new argument, boundary, mapping or vocabulary was added, and the two still-deferred consumers are untouched.

Evidence: focused red before the edit — `outcome`→`COMPLETED` and `code`→`22` each gave `rc=0`, `task-lease=released`, `checkout-lease=released`, with the altered artifact advertised as the run's terminal result. Green after — each gives `rc=38`, both leases held, with the STOP line naming `(outcome-mismatch)` and `(code-mismatch)` distinctly. Permanent case 58e asserts it: both forced mismatches exit 38, advertise nothing, pin both leases with their own bounded token (and not a finalization cause), and make the next dispatcher exit 17; and a real dry-run over an active, a closed and a blocked task each expects and accepts `DRY_RUN_COMPLETE`/`0` and releases — which is the assertion that the expectation tracks `MODE` rather than lifecycle. 58f's M34 removes only the dry-run pair, keeps its consumer call and leaves the operator terminal's pair in place, differs and parses; both mismatches then exit 0 and release, so 58e is fail-capable and the two migrated seams are separately fail-capable. 62c now names the migrated seams instead of counting them: `operator;dry-run;` supply a pair, `interruption;carry-one;` do not, and a real carried `--carry-one` hop still exits 0 and releases. Case 62's stale prose and heading, which said only one seam supplied a pair, were corrected in the same edit. Focused run over cases 51a/56/58/61/62: `pass=104 fail=0` (that slice was `pass=70 fail=0` before this unit, with 58 and its 34 assertions newly included). Both shell files pass `bash -n`. Changed paths: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this state file; `logs/friction-log.md` was left unstaged.

Deferred, noticed during this unit and not done: the dry-run call site passes an empty terminal label, so a semantic refusal there prints `die_terminal_untrusted`'s default sentence — "the run reached a real operator terminal" — over a preflight. That wording is pre-existing (the bare call already routed through the same default for a path, structure or identity refusal) and this unit makes it reachable on a new and more ordinary path, but supplying a truthful label is not required by the completion condition, so it stays a deferral rather than becoming unasked work. The Unit 27 deferral about the same message's provenance-oriented wording still stands.

## Blocker

None.

## Next action

Codex: assess Unit 28. The five claims held, the dry-run red reproduced pre-edit and is closed post-edit, and the integration is confined to that one call site. Judge whether 58e's three-lifecycle run genuinely proves the expectation tracks `MODE` rather than `ST_CLASS`, whether M34 is the narrowest removal and leaves the operator seam provably intact, and whether 62c's named-seam assertion now states the deferral honestly. Decide too whether the empty dry-run terminal label recorded above should be frozen as a finding or left deferred. Then close, continue, correct once, or stop.
