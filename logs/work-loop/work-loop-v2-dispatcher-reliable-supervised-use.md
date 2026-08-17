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

Standard. Implementation mode. Unit 29 — enforce expected meaning at the carry-one terminal

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 28 is accepted at `bf1ef244cbc24157e8551b9489abce70e1a357ac`: the admitted dry-run terminal now supplies its independently expected outcome/code before release, and its correction makes every refusal at that seam name the preflight terminal actually reached. The focused semantic and wording controls are fail-capable, the correction's classifier regression was repaired inside the frozen round, and the operator terminal remains integrated. Change set A still requires every releasing terminal consumer to trust the promised result's meaning, so migrate exactly one next consumer: the post-hop carry-one terminal.

Current position: the approved plan is content-bound at `e9a6fd8bc51992a1ce8f6e09dcf95b273dd07240` (plan blob `43c44e01703c8622482d93d80407ddc1c83e038a`) against baseline `2451e3df5b8616e035a39a679799738a975b642e`; Change set A remains in progress after 28 accepted units. This unit is justified by the plan's exact run-bound producer/consumer and release-order requirements. The plan and canonical Work Loop govern; current dispatcher comments and tests are verify-first repository evidence.

Dominant deliverable: the post-hop carry-one terminal releases its leases only after its promised result agrees with the outcome and code that this caller independently expected.
Evidence required in this hop: one targeted red/green carry-one semantic-consumer case covering the two one-field mismatches, plus one focused load-bearing control that removes only this caller's expected pair.
Evidence explicitly deferred: semantic integration at interruption, the shared nonzero `die()` funnel, or any other terminal seam; validation of fields beyond outcome/code; broad all-terminal guards; remaining Change set A terminal-family migration; Change sets B–D; live trials; adoption review; the full synchronous regression gate; merge, push, deployment and destructive cleanup.
Primary edit begins after: quote a focused pre-edit real carried hop in which a result altered after successful finalization only in `outcome` or only in `code` still passes the current carry-one consumer, exits 0 and releases both leases.

Required outcome:

- The existing post-hop carry-one release seam establishes expected outcome/code from dispatcher-owned facts independently of the artifact, and requires the accepted semantic boundary after path, structure and identity but before release.
- A genuine carried hop still exits 0, records `CARRY_ONE_COMPLETE` with code 0, preserves its accepted next-action split and post-hop facts, and releases both leases. An outcome-only mismatch is refused with `outcome-mismatch`; a code-only mismatch is refused with `code-mismatch`. Each uses the existing untrusted-result path: exit 38, no false result advertisement, both leases retained with the truthful token, and the next dispatcher refused.
- `result_outcome()` remains the sole code-to-outcome owner. The carry-one caller must derive its expected symbol through that owner and its dispatcher-owned `CARRY_ONE`/`ACTOR_PROCESS_STARTED` facts; it must not hard-code a second mapping, read an expectation from the result, compare the artifact with itself, reparse it, or add another semantic reader.
- Preserve the accepted order and snapshot: promised-path gate → one structural parse → expected identity → expected outcome/code → release. Preserve the truthful existing label `the carry-one terminal after one carried hop` and do not change shared refusal wording.
- Only the carry-one consumer becomes newly subject to semantic agreement in this unit. The accepted operator and dry-run integrations stay intact; interruption and the nonzero funnel remain behaviorally unchanged and explicitly deferred.
- Update only the focused caller-count/composition assertions directly affected by a third migrated caller. They must name operator, dry-run and carry-one as migrated, and interruption as deferred; do not imply that the nonzero funnel is consumed or generalize the claim to every terminal.

Check against the repository before editing:

1. Verify Units 27–28's operator and dry-run integrations remain present and that the carry-one call site still supplies no expected pair. If carry-one is already semantically integrated, hand back.
2. Verify the carry-one terminal finalizes code 0, consumes the exact promised result and releases at one existing post-hop seam; verify `result_outcome 0` resolves `CARRY_ONE_COMPLETE` from dispatcher-owned `CARRY_ONE=1` and `ACTOR_PROCESS_STARTED=1`, after the dry-run branch and without artifact input.
3. Reproduce the named red by forcing a real carry-one artifact, after successful finalization and before consumption, to retain valid path/structure/identity while changing only outcome or only code. If the current consumer already refuses both for the intended semantic reason, hand back.
4. Verify case 60 owns carry-one publication, its four lifecycle transitions, accepted next-action meanings, truthful post-hop facts, release, finalization failure and sole-owner assertions; extend that focused owner rather than creating a parallel broad matrix.
5. Verify case 62c currently names operator and dry-run as supplying expectations while carry-one and interruption supply none, and keeps a real deferred carry-one run green. Update that composition only for this migration. If interruption or another terminal must change, hand back rather than widening.

Required fail-capable evidence:

- Quote the focused red and green. Red: both one-field alterations exit 0, advertise the altered result and release. Green: each exits 38 with its distinct semantic token, advertises no refused result, retains both leases with that cause, and makes the next dispatcher refuse.
- Show the expected pair is established independently of the artifact through the sole mapping owner, and that real carried hops across the accepted lifecycle rows still record `CARRY_ONE_COMPLETE`/0 with their existing next-action meanings and post-hop facts.
- Add one focused mutation/control that removes only the carry-one call site's expected-pair arguments while preserving its truthful label, consumer call and path, structure and identity boundaries. It must match exactly once, differ, parse, leave the operator and dry-run pairs intact, and restore exit 0 plus release for both mismatches; fail closed if it cannot run.
- Prove exactly three production consumers now supply expectations — operator, dry-run and carry-one — while interruption supplies none and remains behaviorally green. Make no claim that the shared nonzero funnel consumes a result.
- Keep the standalone semantic-validator case, accepted operator and dry-run integration cases, and directly affected carry-one cases green. Run only the focused cases 51a, 56, 58, 60, 61 and 62 plus `bash -n` on both shell files; do not run the full dispatcher suite.
- Report the implementation commit and exact changed paths. Only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state may change; `logs/friction-log.md` remains pre-existing noise and must not be staged or committed.

Capability subset: baseline only — inspect the approved plan and accepted dispatcher/test seams; edit only the two spike files and this state; run focused local checks and shell syntax validation; make the local handback commit. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No external service, production action or operator-reserved capability is needed.

Completion condition: one committed integration makes the post-hop carry-one terminal's lease release depend on independently expected outcome/code as well as the three accepted trust boundaries; genuine carried hops remain truthful and release, both one-field mismatches fail closed through the existing retained-lease route, the focused removal control restores the unsafe accepts, exactly three named production consumer call sites now supply expectations, interruption remains deferred and unchanged, only the three permitted paths change, and the state returns with `turn: codex`.

Stop and hand back if carry-one is already equivalently integrated; if its expected pair cannot be established independently through the accepted owner; if the work requires reparsing, a second mapping, schema/vocabulary change or another pin/exit owner; if interruption or the nonzero funnel must change; or if the focused proof cannot isolate semantic refusal from the earlier trust boundaries. Challenge a false premise rather than widening.

## Latest result

Inspected (2026-08-17):

- Claim (1): HOLDS — read `dispatch.sh` and searched it for `consume_terminal_result`; the four production call sites are interruption (2616, label only), dry-run (3981, `"the admitted dry-run preflight terminal" "$(result_outcome 0)" 0`), operator (4067, `"" "$(result_outcome 0)" 0`) and carry-one (4319, label only). Units 27–28 are present; carry-one supplied no expected pair, so it was not yet semantically integrated.
- Claim (2): HOLDS — read `dispatch.sh` 4303–4323: inside the `CARRY_ONE -eq 1` block the seam runs `finalize_terminal_result 0` (4318), `consume_terminal_result` on the promised artifact (4319), then `release_lock`/`exit 0` (4321–4322) — one post-hop seam. Read `result_outcome()` 534–600: the code-0 branch takes `dry-run` first (575–577), then `[ CARRY_ONE -eq 1 ] && [ ACTOR_PROCESS_STARTED -eq 1 ] && printf CARRY_ONE_COMPLETE` (578), before any `ST_CLASS` reading; searched the function for any artifact or record input — no match. `ACTOR_PROCESS_STARTED=1` is set at launch (3599), so both facts are true at line 4319.
- Claim (3): HOLDS — reproduced. Injected one altering `sed` line after the `# carry-one terminal finalization` marker (between publication and consumption) on a real `--carry-one` run with a codex actor. `outcome`-only altered to `COMPLETED`: `rc=0`, record read back `outcome=COMPLETED code=0`, `terminal result:` advertised, both leases released. `code`-only altered to `22`: `rc=0`, `outcome=CARRY_ONE_COMPLETE code=22`, advertised, both leases released. The current consumer refused neither.
- Claim (4): HOLDS — read `dispatch.test.sh` case 60 (7943–8529 pre-edit): 60a owns publication, post-hop facts, release and the next admitted dispatcher; 60b owns the four lifecycle transitions and their next-action meanings; 60c the non-over-fire controls; 60e finalization failure; 60g the sole-owner marker counts. The new work extends this owner (60j, 60k) rather than adding a matrix.
- Claim (5): HOLDS — read case 62c (8939–9005 pre-edit): `SUPPLY62` was asserted as `operator;dry-run;` in either order and `NOSUPPLY62` as `interruption;carry-one;`, and a real deferred `--carry-one` run was asserted green at exit 0.
- Packaging lines: HOLD — `Dominant deliverable:`, `Evidence required in this hop:`, `Evidence explicitly deferred:` and (Implementation mode) `Primary edit begins after:` are all present and non-empty, and the dominant deliverable names exactly one thing.

Result: the post-hop carry-one terminal is the third migrated consumer. `dispatch.sh` 4319 now reads `consume_terminal_result "the carry-one terminal after one carried hop" "$(result_outcome 0)" 0`, so release depends on independently expected outcome and code as well as path, structure and identity. No second mapping, no reparse, no new reader: the symbol comes from `result_outcome()` and the code is the literal 0 the finalization above published under. The accepted order, the snapshot binding, the truthful label and the shared refusal wording are unchanged, and interruption plus the nonzero `die()` funnel are untouched.

Evidence: the red above is the failing case; the green is the same two fixtures against the edited dispatcher. Each now exits 38, advertises no terminal result, prints `reached the carry-one terminal after one carried hop` and never `reached a real operator terminal`, retains both leases with the bounded cause (`outcome-mismatch` and `code-mismatch` respectively, and not `could not finalize`), and makes the next dispatcher exit 17 — case 60j. Case 60k adds M36, which strips only this call site's two expectation arguments while asserting its labelled consumer call, the operator pair and the dry-run pair all survive, differs, parses, and restores exit 0 plus release for both mismatches; it fails closed if the selector does not match exactly once. 60j also asserts structurally that this call site derives its pair through `result_outcome` and reads nothing from the artifact. Accepted behaviour is re-proved by 60a and 60b running against the integrated dispatcher: a genuine carried hop still exits 0, records `CARRY_ONE_COMPLETE`/0 with post-hop stage, `actor_launched=yes`, hop 1 and the validated post-hop turn, releases both leases, and all four lifecycle rows keep their existing next-action meanings. Case 62c now proves exactly three production call sites supply a pair — operator, dry-run and carry-one, compared as a sorted set — with interruption alone deferred, and makes no claim about the nonzero funnel; its behavioural run is kept and re-read as the migrated seam's green.

Focused cases 51a, 56, 58, 60, 61 and 62 reported `pass=188 fail=0` (110 before this unit). `bash -n` passed on both shell files. Changed paths: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` and this state file. `logs/friction-log.md` was left unstaged.

Two wording lines in case 62 were corrected in the same edit because this migration made them false: its section echo said "exactly two seams supply one", and its header comment named carry-one as still deferred.

The earlier recorded deferral remains outside this unit: the shared untrusted-result sentence describes semantic refusal in provenance terms (`failed this run's own consumer gate`). One new deferral is recorded: `Evidence explicitly deferred:` was satisfied as written, and the interruption consumer and the shared nonzero `die()` funnel remain the only unmigrated terminal seams — neither was touched and neither is claimed.

## Blocker

None.

## Next action

Codex: assess Unit 29 — whether the post-hop carry-one terminal's release now depends on independently expected outcome and code, whether the red/green and M36 control are fail-capable and correctly scoped to this one consumer, whether the 62c composition change is the narrowest one this migration required, and whether interruption and the nonzero funnel are genuinely unchanged. Then close, continue, correct once, or stop.
