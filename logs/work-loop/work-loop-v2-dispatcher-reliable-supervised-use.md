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

Correction round on the one frozen finding (Unit 28's dry-run seam).

Reproduced first, by inspection: the shipped call site was `consume_terminal_result "" "$(result_outcome 0)" 0 # dry-run terminal consumption`, and `die_terminal_untrusted()` renders its second argument as `${2:-a real operator terminal}`. A forced dry-run semantic refusal printed `STOP [38] the run reached a real operator terminal (state_class=ACTIVE_CODEX) ...` over a preflight that launched nothing. The finding reproduced exactly as frozen.

Finding (1): RESOLVED — the dry-run call site now passes `"the admitted dry-run preflight terminal"` as its label. That is the argument the shared exit always accepted and this seam never supplied; `die_terminal_untrusted()`'s wording, its default, and the operator terminal's own sentence are untouched, and no other call site changed. The same refusal now prints `the run reached the admitted dry-run preflight terminal (state_class=ACTIVE_CODEX) ...`. Because the label is passed at the call site rather than at the refusal, this also corrects the path, structure and identity refusals at this seam, which inherited the same false sentence.

Evidence: `58e`'s refusal contract gains two assertions per forced mismatch — the output names the preflight terminal it actually reached, and contains no operator-terminal claim — and both hold for the outcome-only and code-only cases. Fail-capability is a new control, `M35`, kept separate from `M34` on purpose: `M34` proves the semantic *refusal* is real, `M35` proves its *wording* is. `M35` restores exactly the empty label, leaves the expected pair and every boundary in place, differs and parses; the run still refuses with the same token and retention, and the sentence goes back to claiming a real operator terminal — so 58e's two wording assertions are capable of failing. Everything Unit 28 established stays green: both mismatches still exit 38 with their own bounded token, advertise nothing, retain both leases and refuse the next dispatcher; real dry-runs over active, closed and blocked tasks still accept `DRY_RUN_COMPLETE`/`0` and release.

Did the correction break something: yes, and it was repaired inside this round. The label change added a comment at the seam that cites `consume_terminal_result` by name, and `62c`'s call-site classifier enumerated it as a fifth call site supplying no pair, so `62c` failed with `not-supplying='CARRIED,;interruption;carry-one;'`. The classifier now selects call sites only — dropping comment lines and requiring the `# <seam> terminal consumption` end-of-line marker that every production call site and every mutation control already addresses them by. `62c` passes again on its exact names: `operator;dry-run;` supply a pair, `interruption;carry-one;` do not. That repair is collateral to the frozen fix, not a second correction.

`M34`'s selector was updated in the same edit, since the line it addresses no longer contains the empty label; it still removes exactly the expected pair, keeps the consumer call and leaves the operator terminal's pair intact.

Focused run over cases 51a/56/58/61/62: `pass=110 fail=0` (that slice was `pass=104 fail=0` at Unit 28's handback). Both shell files pass `bash -n`. Changed paths: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this state file; `logs/friction-log.md` was left unstaged.

Nothing newly noticed in this round is carried as a candidate deferral. The Unit 27 deferral — that the shared untrusted-result sentence describes the cause in provenance terms ("failed this run's own consumer gate") even when the refusal is semantic — still stands unresolved and was not touched here; it is about the shared exit's wording, which this finding explicitly excluded.

## Blocker

None.

## Next action

Codex: the closure check on the frozen findings only. Finding (1) is resolved — the dry-run seam names its own terminal and M35 makes that wording fail-capable — and the one thing the correction broke (62c's call-site classifier) was repaired in the same round. Are the frozen findings resolved, and did the correction break anything else? Then close, or use the menu.
