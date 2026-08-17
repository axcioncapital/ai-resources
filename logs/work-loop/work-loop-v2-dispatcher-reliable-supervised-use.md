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

Standard. Implementation mode. Unit 27 — enforce expected meaning at the operator terminal

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 26 is accepted at `84b76ee548c761d496e6fbfaffbe7d67043aa5eb`: one standalone, read-only, snapshot-bound semantic boundary now compares the once-parsed result's `outcome` and `code` with independent caller expectations. Its focused proof showed that both one-field mismatches passed the pre-existing path, structure and identity gates, while the new boundary rejects them distinctly; M32 removed exactly the two comparisons and restored both false accepts. The approved plan's Change set A still requires trusted terminal evidence to control advancement and release, so this unit integrates only the first production consumer: the loop-mode operator terminal.

Current position: the approved plan is content-bound at `e9a6fd8bc51992a1ce8f6e09dcf95b273dd07240` (plan blob `43c44e01703c8622482d93d80407ddc1c83e038a`) against baseline `2451e3df5b8616e035a39a679799738a975b642e`; Change set A is still in progress after 26 accepted units. This unit is justified by Change set A's exact run-bound producer/consumer path, trusted-field ownership, and release-only-after-terminal-result requirements. The plan and canonical Work Loop are governing; the current production comments and tests are verify-first repository evidence.

Dominant deliverable: the loop-mode operator terminal releases its leases only after its promised terminal result agrees with the outcome and code that this caller independently expected.
Evidence required in this hop: one targeted red/green operator-terminal case covering the two one-field semantic mismatches, plus one focused load-bearing control that removes only this integration.
Evidence explicitly deferred: semantic integration at dry-run, carry-one, interruption, the shared nonzero `die()` funnel, or any other terminal seam; validation of any semantic field beyond outcome/code; broad all-terminal ordering guards; remaining Change set A terminal-family migration; Change sets B–D; live trials; adoption review; the full synchronous regression gate; merge, push, deployment and destructive cleanup.
Primary edit begins after: quote a focused pre-edit operator-terminal run in which a result altered after finalization only in `outcome` or only in `code` still passes the current production consumer, exits 0 and releases its leases.

Required outcome:

- At the existing loop-mode `turn: operator` release seam, both `CLOSED` completion and `BLOCKED_OPERATOR` takeover establish their expected outcome/code from dispatcher-owned facts independently of the result artifact, then require the accepted semantic boundary in addition to the existing path, structure and identity boundaries before release.
- A valid real producer result for each of those two operator-terminal classes still exits 0 and releases normally. An outcome-only mismatch is refused with `outcome-mismatch`; a code-only mismatch is refused with `code-mismatch`. Each refusal follows the already accepted untrusted-result path: exit 38, no false terminal-result advertisement, both leases retained with the truthful bounded cause, and the next dispatcher refused.
- `result_outcome()` remains the sole production code-to-outcome owner. Do not hard-code a second operator-terminal mapping, derive an expectation from the artifact, compare the artifact with itself, reparse it, or add a second semantic reader.
- Preserve the accepted order: promised-path gate → one structural parse → expected identity → expected outcome/code → release. The semantic decision stays pinned to the same artifact snapshot captured by the structural pass.
- At the end of this unit, only the loop-mode operator terminal's release decision depends on the new semantic agreement. Do not change the release behavior of dry-run, carry-one, interruption, the nonzero funnel, or any other caller. Do not add a new library, CLI, schema version, parser, state field, evidence path, wait, scan, retry or terminal vocabulary.
- Update the focused production-composition assertion so it proves the four accepted boundaries occur once and in order for this seam, without claiming that the deferred terminal seams are already migrated.

Check against the repository before editing:

1. Verify the accepted Unit 26 boundary and its captured `TR_OUTCOME`/`TR_CODE` remain present, read-only, snapshot-bound, and not yet called by a production consumer. If an equivalent production integration already exists, hand back.
2. Verify the loop-mode operator terminal is one release seam shared by both canonical `CLOSED` and `BLOCKED_OPERATOR` code-zero endings, and that its current production consumer composes only path, structure and identity before release. Identify the exact caller-owned facts that independently determine each expected pair without reading the artifact.
3. Reproduce the named red by forcing a real operator-terminal artifact, after successful finalization and before consumption, to retain correct task/checkout/run and structure while changing only outcome or only code. If the current unmodified consumer already refuses each for the semantic reason, hand back.
4. Verify the existing case 56 forcing-fixture pattern exercises production text at this exact seam and already proves exit-38 retention, no trusted-result advertisement, and refusal of the next dispatcher. Extend that focused owner rather than creating a parallel harness or broad new matrix.
5. Verify `result_outcome()` remains the only production code-to-symbol map and that no deferred consumer's observable behavior must change to integrate this one seam. If the integration cannot stay confined to the operator terminal, hand back rather than widening.

Required fail-capable evidence:

- Quote the focused red before the production edit and green after it. The red must show the current production operator-terminal path accepting and releasing for the outcome-only and code-only altered records; the green must show the same path refusing each with its distinct bounded token while unchanged real `CLOSED` and `BLOCKED_OPERATOR` records still exit 0 and release.
- Show the expected pair is established independently of the artifact under test and through the existing sole mapping owner. Evidence that reads outcome/code from the result and compares them back is invalid.
- Prove each semantic refusal exits 38, advertises no refused artifact as trusted, retains both leases with the correct bounded cause, and makes the next dispatcher refuse. Reuse the existing accepted untrusted-result route; do not add another pin or exit owner.
- Add one focused mutation/control that removes only the operator-terminal semantic integration while preserving path, structure and identity. It must match exactly, differ, parse, and restore exit 0 plus lease release for both one-field mismatches; fail closed if it cannot run.
- Keep the standalone Unit 26 semantic-validator case and the directly affected operator-terminal consumer slice green. Run only those focused controls plus `bash -n` on both shell files; do not run the full dispatcher suite.
- Report the implementation commit and exact changed paths. Only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state may change; `logs/friction-log.md` remains pre-existing noise and must not be staged or committed.

Capability subset: baseline only — inspect the approved plan and accepted dispatcher/test seams; edit only the two spike files and this state; run focused local checks and shell syntax validation; make the local handback commit. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No external service, production action or operator-reserved capability is needed.

Completion condition: one committed integration makes the loop-mode operator terminal's lease release depend on independently expected outcome/code as well as the three accepted trust boundaries; valid `CLOSED` and `BLOCKED_OPERATOR` records still release, both one-field mismatches fail closed through the existing retained-lease route, the focused removal control restores the unsafe accept, no other terminal seam changes behavior, only the three permitted paths change, and the state returns with `turn: codex`.

Stop and hand back if an equivalent integration already exists; if either expectation cannot be established independently through the accepted owner; if the work requires reparsing, a second mapping, a second pin/exit owner, schema or vocabulary change; if another terminal seam's behavior must change; or if the focused proof cannot distinguish semantic refusal from path, structure or identity refusal. Challenge a false premise rather than widening.

## Latest result

Inspected (2026-08-17):
- Claim (1): HOLDS — searched `dispatch.sh` for `validate_terminal_result_semantics`; exactly one hit, the definition at line 1313. It re-establishes `TR_PARSE_GATED`, `TR_SOURCE`, symlink, `TR_FID` and `TR_SHA` against the parse's snapshot before comparing, and no production call site existed: the only `consume_terminal_result` composition (lines 2064–2076) called path, structure and identity and nothing else.
- Claim (2): HOLDS — searched `dispatch.sh` for the loop-mode operator branch; `if [ "$ST_TURN" = "operator" ]` (line 3936) is one branch serving both endings, choosing its wording by `closing_record_ok` and finalizing/consuming/releasing once at lines 3983–3992. The caller-owned facts are the literal `0` that the finalization and the exit already share, and `result_outcome 0`, which reads `MODE`, `CARRY_ONE`, `ACTOR_PROCESS_STARTED` and `ST_CLASS` — dispatcher-owned variables, no artifact read. `ST_CLASS=CLOSED` yields `COMPLETED` and `BLOCKED_OPERATOR` yields `OPERATOR_TAKEOVER`, so one call covers both.
- Claim (3): HOLDS — reproduced by injecting a one-field alteration after the `# operator terminal finalization` marker on an unmodified dispatcher. `outcome`-only (`COMPLETED`→`OPERATOR_TAKEOVER`) gave `rc=0`, both leases released, artifact advertised; `code`-only (`0`→`22`) gave the same. The pre-edit consumer refused neither.
- Claim (4): HOLDS — searched `dispatch.test.sh` case 56 (lines 7133–7319); 56b forces via `awk` at that exact marker and asserts exit 38, `out_lacks "  terminal result:"`, both lock dirs present with the bounded token in both `survivors` files, and exit 17 for the next dispatcher. Extended rather than duplicated.
- Claim (5): HOLDS — searched `dispatch.sh` for `result_outcome`; one definition (line 534), one production call (line 825, the producer). No deferred consumer had to change: the three other call sites supply no expectation and take the unchanged three-boundary path.

Result: the loop-mode operator terminal now releases only after the promised record's `outcome` and `code` agree with what this caller independently expected. `consume_terminal_result()` takes an optional expected pair as arguments 2 and 3 and composes `validate_terminal_result_semantics` as a fourth boundary only when one is supplied; the operator seam supplies `"$(result_outcome 0)"` and the literal `0`. The three deferred seams pass nothing and are byte-for-byte unchanged in behaviour.

Evidence: focused red before the edit — the outcome-only and code-only altered records both gave `rc=0`, `task-lease=released`, `checkout-lease=released` and `terminal result:` advertised. Green after — both give `rc=38`, `task-lease=held`, `checkout-lease=held`, with the STOP line naming `(outcome-mismatch)` and `(code-mismatch)` distinctly. Permanent case 62 asserts all of it: real `CLOSED` (`COMPLETED`/`0`) and real `BLOCKED_OPERATOR` (`OPERATOR_TAKEOVER`/`0`) still exit 0, release both leases and admit the next dispatcher; three forced mismatches (CLOSED-claims-takeover, CLOSED-claims-22, BLOCKED-claims-COMPLETED) each exit 38, advertise nothing, pin both leases with their own bounded token and make the next dispatcher exit 17. 62c proves the call site derives its pair through `result_outcome` and reads nothing from the artifact, and that exactly one of the four call sites supplies a pair while three do not; the dry-run terminal still exits 0 live. 62d's M33 removes only the two expectation arguments, keeps the consumer call, differs and parses — and both mismatches exit 0 and release again, so 62b is fail-capable. 56e now pins four boundaries once and in order and asserts the consumer holds no second mapping. Focused run over cases 51a/56/61/62: `pass=70 fail=0` (the same slice pre-edit was `pass=43 fail=0`). Both shell files pass `bash -n`. Changed paths: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this state file; `logs/friction-log.md` was left unstaged.

Deferred, noticed during this unit and not done: `die_terminal_untrusted`'s message still says the artifact "failed this run's own consumer gate", which reads as a provenance failure even when the refusal is semantic. It is truthful and bounded, so it is not a defect this unit had to fix, and rewording a shared terminal message is outside `## Objective and scope` for a unit that agreed to change one seam.

## Blocker

None.

## Next action

Codex: assess Unit 27. The five claims held, the red reproduced pre-edit and is closed post-edit, and the integration is confined to the loop-mode operator terminal. Judge whether the expected pair is genuinely caller-established (62c), whether M33 is the narrowest removal of this integration (62d), and whether 56e's four-boundary assertion overclaims about the three deferred seams. Then close, continue, correct once, or stop.
