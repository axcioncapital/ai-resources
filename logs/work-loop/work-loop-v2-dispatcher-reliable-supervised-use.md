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

Standard. Implementation mode. Unit 32 — make the shared nonzero funnel consume its result

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 31 is accepted at `729f727e149bd0cbbbec3ed3baab5369e3d10c3c`: the one shared `die_terminal_untrusted()` sentence now refuses an artifact as the run's reported ending without assuming exit 0 or treating the failed gate as provenance. Its code-0/code-28 red and green are wording-specific, M38 restores only the former clause while behavioral refusal stays intact, and the implementation changes only the approved production sentence and focused tests. The shared nonzero `die()` funnel still finalizes and advertises a result, then releases both leases without consuming that promised artifact; make that funnel the fifth trusted consumer now.

Current position: the approved plan is content-bound at `e9a6fd8bc51992a1ce8f6e09dcf95b273dd07240` (plan blob `43c44e01703c8622482d93d80407ddc1c83e038a`) against baseline `2451e3df5b8616e035a39a679799738a975b642e`; Change set A remains in progress after 31 accepted units. This unit directly advances plan § 5 requirements 3, 5 and 6 and the durable ordering rule that release follows trusted terminal evidence. The missing first-class focused-case selector noticed in Unit 31 remains a deferred harness-contract improvement: focused evidence can run through a temporary outside-repository slicer, and Gate SA does not require a selector.

Dominant deliverable: every ordinary run-bound nonzero terminal that exits through the shared `die()` funnel consumes the exact artifact it just finalized, against the outcome and code independently owned by that funnel, before the artifact is advertised or either lease can release.
Evidence required in this hop: targeted red/green proof at one post-hop terminal (22) and one pre-hop terminal (18), plus one mutation control that removes only the new funnel consumption while preserving finalization and the rest of the funnel.
Evidence explicitly deferred: the full dispatcher regression suite; proving every individual nonzero call site separately; any focused-case selector; remaining Change set A; Change sets B–D; live trials; adoption review; the full synchronous regression gate; merge, push, deployment and destructive cleanup.
Primary edit begins after: add a focused post-finalization alteration at the case-50 funnel seam for outcome on code 22 and code on code 18, and quote the pre-edit red: the altered promised artifact is advertised, the original 22/18 is returned and both leases release because the funnel performs no consumer check.

Required outcome:

- After successful finalization and before result advertisement or release, the shared covered funnel must apply the accepted path, structure, identity and semantic consumer to its promised run-bound result. The semantic expectation must come from the funnel's dispatcher-owned terminal code and the existing sole `result_outcome()` mapping, not from the artifact, state, log or message.
- Give the consumer one truthful terminal-neutral label for the shared nonzero ending it is checking. Do not duplicate the parser, validators, refusal owner, result mapping or per-code call sites.
- A clean code-22 post-hop terminal and clean code-18 pre-hop terminal must keep their accepted exit, one complete advertised result and safe lease release.
- An outcome-only or code-only alteration after finalization must instead exit 38 through the accepted terminal-neutral refusal, name the correct shared nonzero terminal, carry the distinct bounded mismatch token, not advertise the refused artifact, retain both leases, refuse the next dispatcher with 17, and terminate once without recursion.
- Preserve the accepted finalization-failure transfer. Its direct `die_funnel_unprovable()` path, and terminals outside the run-evidence coverage guard, are not new consumers in this unit.
- Preserve the four accepted operator, dry-run, carry-one and interruption consumers and their independently supplied expected pairs. Update the focused composition assertion so it truthfully names the new fifth call site and still exposes any consumer call lacking a pair; make no claim about direct pre-run exits or the finalization-failure transfer.

Check against the repository before editing:

1. Verify `die()` still calls `finalize_terminal_result "$code" || die_funnel_unprovable "$code"`, then may advertise `RESULT_FILE`, then releases, with no consumer between those operations. Verify case 50 owns representative post-hop 22 and pre-hop 18 funnel results, and case 62c enumerates exactly the four existing marked consumers while explicitly excluding this funnel.
2. Verify `result_outcome()` maps 22 to `NO_TRANSITION` and 18 to `FOREIGN_UNSTAGED`, and `consume_terminal_result()` can receive an independently supplied outcome/code pair without reading expectations from the artifact.
3. Verify the accepted refusal re-entry clears `RESULT_FILE` before calling `die 38` while the first result is already finalized. The new integration must not re-consume the refused artifact recursively; prove the actual bounded path rather than assuming the existing finalization guard is sufficient.
4. Add the two alteration fixtures first and reproduce the targeted red before changing production. If a representative code-22 or code-18 terminal bypasses the shared funnel, or if truthful bounded refusal requires changing the schema/parser/refusal owner, hand back.

Required fail-capable evidence:

- Quote red and green for the post-hop outcome mismatch and pre-hop code mismatch. Red must show the current unsafe original exit/advertisement/release; green must show exit 38, the correct `outcome-mismatch` or `code-mismatch` token, no refused-result advertisement, both leases retained and next exit 17.
- Show clean controls for the same code-22 and code-18 paths remain at their original exit, produce exactly one complete result with the correct outcome/code, advertise it and release safely.
- Prove the refusal terminates once rather than recursively re-entering the new consumer. State exactly how the accepted refusal re-entry is bounded and show no repeated refusal or secondary terminal-result claim.
- Add one fail-closed mutation control that removes only the new shared-funnel consumer call while leaving finalization, its failure transfer, advertisement and release intact. The mutant must differ and parse, and the same post-finalization alterations must restore the unsafe original 22/18 exits, advertisement and lease release.
- Update case 62c's marked-call-site composition evidence from four to five supplying consumers, naming the shared nonzero funnel and leaving the no-missing-pair side asserted. Do not weaken the four existing names or convert the assertion to a loose count.
- Run only the directly affected case 50 and case 62 regions through a faithful temporary slicer outside the repository, plus `bash -n` on both shell files. Report the focused baseline/red/green counts and slicer-fidelity check; do not add a selector or run the full dispatcher suite in this hop.
- Report the implementation commit and exact changed paths. Only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state may change; `logs/friction-log.md` remains pre-existing noise and must not be staged or committed.

Capability subset: baseline only — inspect the approved plan and accepted funnel/consumer seams; edit only the dispatcher integration, its focused cases/composition assertion and this state; run the named focused local checks and shell syntax validation; make the local handback commit. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No external service, production action or operator-reserved capability is needed.

Completion condition: one committed integration makes the shared run-bound nonzero funnel consume its finalized result before advertisement and release; clean code-22 and code-18 endings remain unchanged, outcome/code alterations fail closed once at 38 with retained leases and no false result advertisement, the consumer-removal mutant restores the unsafe behavior, all five marked consumers supply independent expectations, only the three permitted paths change, and the state returns with `turn: codex`.

Stop and hand back if the funnel cannot consume without recursive refusal, if the expected outcome/code would have to come from the artifact or a second mapping, if another parser/refusal owner or per-code integration is needed, if the finalization-failure transfer would be weakened, or if focused proof cannot distinguish consumer trust from mere finalization. Challenge a false premise rather than widening.

## Latest result

Inspected (2026-08-18):

- Claim (1): HOLDS — `dispatch.sh:1379` was `finalize_terminal_result "$code" || die_funnel_unprovable "$code" # die funnel failure transfer`, followed immediately by the `RESULT_FILE` advertisement (1380-1383), `release_lock` (1384) and `exit "$code"` (1385), with nothing between. Case 50a owns the post-hop 22 (`NO_TRANSITION`, launched actor) and case 50b the pre-hop 18 (`FOREIGN_UNSTAGED`, no launch). Case 62c enumerated exactly `carry-one;dry-run;interruption;operator;` and stated in its own comment that it made no claim about this funnel.
- Claim (2): HOLDS — `result_outcome()` maps `22) NO_TRANSITION` and `18) FOREIGN_UNSTAGED`. `consume_terminal_result()` takes `[terminal-label] [expected-outcome] [expected-code]`, derives `promised="$LOG_DIR_ABS/$RUN_ID.result"` itself, and reads no expectation from the artifact; its semantic boundary fires when either half of the pair is stated.
- Claim (3): HOLDS, and the hazard is real rather than theoretical. `die_terminal_untrusted()` clears `RESULT_FILE` (`dispatch.sh:2003`) and then calls `die 38`, which re-enters the funnel. `finalize_terminal_result` returns early at `RESULT_FINALIZED -eq 1` *before* it would re-set `RESULT_FILE`, so the on-disk record still carries the original code — an unguarded funnel consumer would compare it against `TERMINAL_UNPROVABLE`/38, refuse again, and never terminate. The existing finalization guard is therefore not sufficient on its own, exactly as the brief anticipated. The bound implemented is a dedicated one-shot `RESULT_CONSUMED` flag set *before* the call (the call does not return on a refusal), with `[ -n "$RESULT_FILE" ]` as the coverage condition; case 50k counts `STOP [38]` lines to prove it rather than assuming it.
- Claim (4): HOLDS — fixtures and assertions were added first and the red reproduced before production changed (below). No representative 22 or 18 bypasses the funnel, and no schema, parser or refusal owner had to change.
- Packaging lines: HOLDS — all four present for Implementation mode; `Dominant deliverable:` names one deliverable.

Result: the shared nonzero `die()` funnel is now the fifth trusted consumer. After successful finalization and before advertisement or release it applies the accepted path, structure, identity and semantic boundary to its own promised run-bound artifact, with the expected pair taken from the funnel's own `$code` parameter and the sole `result_outcome()` mapping — one call site, no per-code branch, no second parser, mapping or refusal owner. `die_funnel_unprovable()`'s finalization-failure transfer, the four accepted consumers and their independently supplied pairs are unchanged; `dispatch.sh` gained 40 lines and removed none.

Evidence: a marker-driven slice of cases 50 and 62 was run three times against the same dispatcher.

- Baseline (pre-edit `dispatch.test.sh` from `HEAD`, unchanged dispatcher): `pass=158 fail=0`, no missing helper or unbound variable.
- Red (fixtures and assertions added, production unchanged): `pass=163 fail=15`. The failures quote the measured unsafe behaviour: the post-hop mismatch `expected exit 38, got 22`, the pre-hop mismatch `expected exit 38, got 18`, both advertised their altered artifact, both released (`task=absent checkout=absent`), the next dispatcher exited 0 instead of 17, `STOP [38] lines: 0`, and 62c reported `supplying='interruption;dry-run;operator;carry-one;'`.
- Green (production changed): `pass=180 fail=0` = 158 + 22 new.

Green shows, for both halves: exit 38 and never the original code, the distinct `outcome-mismatch` / `code-mismatch` token pinned on both leases, no refused-result advertisement, both leases retained, next dispatcher 17, the refusal naming `the shared nonzero terminal for code 22` / `for code 18` and claiming no operator terminal, and exactly one `STOP [38]` line — the termination proof. The clean controls on the same two paths still exit 22 and 18, advertise one complete `NO_TRANSITION` / `FOREIGN_UNSTAGED` result and release both leases. 62c now reports all five call sites supplying a pair, with the no-missing-pair side still asserted.

M39 is the fail-closed mutation control: it deletes only the funnel consumer line, requiring that selector to have matched exactly once, the finalization transfer marker to survive, all four other consumption markers to survive, and the mutant to differ and parse. Under it both alterations return to the unsafe original endings — `exits 22, advertises the altered artifact and releases` and the same at 18 — so case 50k is fail-capable.

Additional untouched regression check, run because the brief requires the finalization-failure transfer preserved: case 57 (the funnel's own failure transfer, including 57b/57c/57d/57e) is byte-identical between the pre- and post-edit test files and reports `pass=23 fail=0` against the changed dispatcher.

Slicer fidelity: the baseline slice passed 158/158 with no missing helpers, and every changed hunk in `dispatch.test.sh` (`+6125,186` and the 62c hunks at `+9557..9611`) falls inside the sliced case-50 region (5385-6310) and case-62 region (9399-EOF), so the focused run covers the whole change. `bash -n` passed on both shell files.

Changed paths: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this state file. `logs/friction-log.md` was left unstaged.

Not covered by this hop's run, and stated rather than claimed: `die_terminal_unprovable()` also re-enters the funnel with `die 38`, and on that path `finalize_terminal_result` retries. Where the retry succeeds the new consumer now checks a record that says `TERMINAL_UNPROVABLE`/38 against that same expected pair and accepts it; where it fails, `die_funnel_unprovable()` exits before the consumer is reached. Cases 55e, 57e, 58b and 60e force the failure by making the log directory unwritable, so the retry fails too and they take the second path unchanged — but they were outside the run this brief authorized, so this is reasoning plus case 57's green, not measurement of those four.

## Blocker

None.

## Next action

Codex: assess Unit 32. All five marked consumers now supply independent expectations and no terminal seam finalizes without consuming; the funnel's one-shot bound is proven by counted refusals rather than argument. Decide whether the unmeasured `die_terminal_unprovable()` re-entry path noted above needs its own unit or is covered, and dispose of the still-open deferral on the harness's missing focused-case selector.
