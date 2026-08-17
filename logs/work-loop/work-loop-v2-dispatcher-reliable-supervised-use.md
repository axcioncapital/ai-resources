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

Standard. Implementation mode. Unit 17 — restore the dead M1 mutation control

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 16 is accepted at correction commit `3602132ea3b0c81ec999ac0e35d3810b89a3dfb9`: every validated carry-one success now publishes and consumes a truthful result before release, and its M27 control proves all four post-hop vocabulary rows fail-capable. That handback also established that case 50c's M1 selector no longer matches the Unit 11 die-funnel finalization line, leaving case 50a's terminal-finalization assertion without a working negative control; this unit restores only that proof so the plan's Change set A and final regression evidence can become trustworthy again.

Dominant deliverable: case 50c's M1 mutant again disables the current die-funnel terminal-finalization transfer and proves case 50a's finalization assertion fail-capable.
Evidence required in this hop: the already-established targeted red and live-line mismatch; one focused case-50 green result in which M1 is applied and exposes the expected missing-result behavior while M2/M3 remain green; a production-unchanged check; and shell syntax evidence.
Evidence explicitly deferred: the post-hop `actor` / `permission_mode_requested` semantic question; validator-side outcome-token or semantic-tuple whitelisting; terminal families A–C and M; status and resume; crash and hostile-input matrices; Change sets B–D; live trials; adoption review; merge, push, deployment, and destructive cleanup.
Primary edit begins after: cite Unit 16's accepted failing case — case 50c reports `the sed matched nothing — the control cannot run` because its selector still expects bare `finalize_terminal_result "$code"` while the live dispatcher carries the Unit 11 failure-transfer suffix — and verify that mismatch by inspecting the current production line and M1 selector. Do not rerun a broad baseline before editing.

Required outcome:

- Change only case 50c's M1 mutation control so it targets the current, single die-funnel finalization-transfer call that case 50a depends on. Preserve the production dispatcher and the accepted M2/M3 controls byte-for-byte.
- The M1 mutant must differ from the real dispatcher, remain syntactically valid, and actually skip the whole finalization/failure-transfer action rather than accidentally retaining a fallback that can still publish a result.
- Under the M1 mutant, the focused fixture must expose the accepted negative signature: dispatcher exit `22` and zero terminal-result artifacts. Against the real dispatcher, case 50a's terminal result remains present and valid.
- Keep the mutation narrow and fail closed: if the intended call is absent or cannot be uniquely and safely mutated, the control must report failure rather than silently testing an unchanged or ambiguously modified script.
- Do not change production code, result vocabulary, schema, parser, lifecycle semantics, case 60, or either recorded deferral.

Check against the repository before editing:

1. In `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, verify the current die-funnel terminal seam still contains the Unit 11 transfer shape `finalize_terminal_result "$code" || die_funnel_unprovable "$code"` and identify whether exactly one production call owns the case-50a path. Hand back if the premise is false or the target is ambiguous.
2. In `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, verify case 50c's M1 selector still expects the obsolete bare call, while M2 and M3 remain independently addressed and green according to the existing fixture. Do not broaden the mutation across unrelated finalization calls.
3. Verify the accepted Unit 16 correction and production dispatcher remain untouched by this unit. The separate post-hop `actor` / `permission_mode_requested` question is background only and must not govern or expand this edit.

Required fail-capable evidence:

- Quote the accepted pre-edit failure and the inspected old-selector/current-line mismatch. This is settled Unit 16 evidence; do not rerun the broad suite merely to recreate it.
- Run the smallest focused case-50 slice that exercises 50a–50c and report exact pass/fail counts. Show M1 differs, parses, produces exit `22` with zero results, and makes the relevant finalization assertion fail-capable; show M2 and M3 still pass unchanged.
- Prove `dispatch.sh` is unchanged from Unit 16 and run `bash -n` on the changed test file.
- Report the correction commit and prove it changes only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` and this task state file. `logs/friction-log.md` remains pre-existing session noise and must not be staged or committed.

Capability subset: baseline only — read the approved plan and accepted Unit 16 evidence; inspect `dispatch.sh`; edit and locally test only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`; update and locally commit that test plus this state file. The baseline deny set is required in full. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed.

Completion condition: the current M1 control safely mutates exactly the intended die-funnel finalization transfer, its focused fixture proves exit `22` with no terminal result while the real dispatcher and M2/M3 controls remain green, production and deferred semantics are untouched, syntax passes, only permitted paths are committed, and the task returns with `turn: codex`.

Stop and hand back if the live finalization owner differs from the accepted Unit 11 seam, the target cannot be mutated uniquely without broadening across other terminals, the expected M1 negative signature is no longer valid, the repair would require production changes or fixture redesign beyond case 50c, or the required evidence cannot be made fail-capable. Challenge a false premise rather than widening the unit.

## Latest result

Inspected (2026-08-17):

- Claim (1): HOLDS — searched `dispatch.sh` for `finalize_terminal_result` and `die_funnel_unprovable`. The die-funnel seam is `dispatch.sh:1245`, still exactly the Unit 11 shape `  finalize_terminal_result "$code" || die_funnel_unprovable "$code" # die funnel failure transfer`, and it is the only `die_funnel_unprovable` call site in the file. `grep -Fxc` on that whole line returns `1`, so the target is unique and unambiguous. The other three `finalize_terminal_result` calls are the dry-run (`3646`), operator (`3704`) and carry-one (`3961`) terminals, none of which owns the case-50a path — case 50a exits `22` through `die_hop 22` (`3918`) into `die()`.
- Claim (2): HOLDS — searched `dispatch.test.sh` case 50c. M1's selector was `sed 's|^  finalize_terminal_result "\$code"$|  :|'`, still expecting the obsolete bare call, so `cmp` found the "mutant" identical and the control reported `the sed matched nothing — the control cannot run`. M2 (`^  mv -f "$tmp" "$final" .*$`) and M3 (`^  local final="$LOG_DIR/$RUN_ID.result"$`) address different lines and were green.
- Claim (3): HOLDS — `git diff --stat 3602132e -- .../dispatch.sh` is empty, so the accepted Unit 16 production dispatcher is untouched by this unit. The post-hop `actor` / `permission_mode_requested` question was read as background only and governed nothing here.

Result: **Unit 17 is implemented.** Case 50c's M1 control again mutates the live die-funnel finalization transfer, so case 50a's terminal-finalization contract has a working negative control for the first time since Unit 11.

One test-side edit, in case 50c's M1 block only. The whole action is replaced with `  :` — the publish *and* the unprovability exit it transfers to — because cutting only the call would leave `|| die_funnel_unprovable "$code"` dangling and change the syntax rather than the behaviour. The selector is now the exact production line matched whole (`grep -Fxc` + `awk '$0 == want'`) instead of a `sed` regex, which is what makes it fail closed: the control requires exactly one occurrence, a mutant that differs, and a mutant that parses, and reports failure naming which of the three failed rather than testing an unchanged or ambiguously modified script. M2 and M3 are byte-for-byte untouched.

Evidence:

- **Targeted red, pre-edit, on the focused case-50 slice (50a–50c): 56 pass / 1 fail.** The single failure is the dead control: `FAIL 50c — M1 mutant differs from the dispatcher (the call site was found) / the sed matched nothing — the control cannot run`. This reproduces the accepted Unit 16 deferral by inspection; the broad suite was not rerun to recreate it.
- **Green after the edit: 58 pass / 0 fail** on the same slice. Two assertions more than red because the working M1 control now reaches its second assertion, which the dead one never did.
- **The mutation is narrow and valid.** `diff dispatch.sh m1.sh` is exactly one line — `1245c1245`, the seam replaced by `  :` — and `bash -n` on the mutant is clean.
- **The negative signature is real.** Under M1 with a non-planting actor: `rc=22` and `res_count=0`. Against the real dispatcher the same fixture finalizes its result, which cases 50a and 50c's own controls assert.
- **Case 50a is fail-capable under M1, shown directly.** Running case 50a's assertion block against the M1 mutant takes it from **32 pass / 0 fail** to **9 pass / 23 fail**, including `the result names its own run id`, `state hashes are recorded and equal`, `head_before is the real commit`, and `the actor's planted SUCCESS result did not become the trusted result`. So the finalization contract this control exists to protect does go red when the producer is broken.
- **Production unchanged.** `git diff --stat 3602132e -- .../dispatch.sh` is empty. `bash -n dispatch.test.sh` is clean.
- Commit: this handback, changing exactly `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` and this state file. `logs/friction-log.md` is pre-existing session noise and was neither staged nor committed.

Deferrals recorded, not implemented:

- **New, noticed while proving fail-capability.** Four of case 50a's assertions survive the M1 mutant — `a terminal result exists at the run-bound path`, `exactly one version line`, `the last line is the completeness sentinel`, and `the run announced a run id`. They survive because case 50a's actor deliberately *plants* a lookalike result at the run-bound path, so a file exists there whether the dispatcher finalized or not. That is by design for the trusted-framing assertion (which does go red), but it means 50a's bare existence and shape checks are not proven by M1 alone. Whether that needs its own control — a no-plant variant, or a field-identity check ahead of the shape checks — is Codex's to size; it is outside this unit's frozen scope.
- **Standing.** The post-hop `actor=none` / `permission_mode_requested=none` semantics remain deferred for a later bounded discovery unit, unchanged and undecided.

## Blocker

None.

## Next action

Codex: assess Unit 17. The M1 control now targets the single live die-funnel finalization transfer, fails closed on absence, duplication, non-difference or a non-parsing mutant, and takes the focused case-50 slice from `56/1` to `58/0`; case 50a goes `32/0` to `9/23` under the mutant, so its finalization contract is proven fail-capable. `dispatch.sh` is byte-for-byte unchanged from Unit 16. Decide close, continue or correct, and size the new case-50a lookalike-survival deferral plus the standing post-hop `actor` / `permission_mode_requested` question.
