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

Standard. Implementation mode. Unit 31 — make untrusted-result refusals terminal-neutral

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 30 is accepted at `3803f0cf4f46615f413ef22e5481a7a3ec3fac5b`: the interruption terminal now supplies independently expected `INTERRUPTED`/28 before release in both eligible signal windows. The targeted launched-actor red/green and M37 control are fail-capable, both genuine pre- and post-launch paths remain truthful, M29 and M31 stay green, and case 62c now proves all four existing consumers supply expectations without claiming the nonzero funnel is covered. Before that funnel can become a truthful fifth consumer, its shared refusal sentence must stop saying `refusing to exit 0` and stop describing the consumer gate as this run's provenance; make only that terminal-neutral wording correction now.

Current position: the approved plan is content-bound at `e9a6fd8bc51992a1ce8f6e09dcf95b273dd07240` (plan blob `43c44e01703c8622482d93d80407ddc1c83e038a`) against baseline `2451e3df5b8616e035a39a679799738a975b642e`; Change set A remains in progress after 30 accepted units. This prerequisite is justified by Gate SA's requirement that terminal evidence and operator reporting be truthful, and by the next funnel consumer's nonzero terminal class. The plan and canonical Work Loop govern; the current message and focused tests are verify-first repository evidence.

Dominant deliverable: every `die_terminal_untrusted()` refusal describes rejection of an untrusted artifact truthfully without assuming the run intended to exit 0 or claiming the consumer gate proves provenance.
Evidence required in this hop: one targeted red/green wording proof across an existing code-zero semantic refusal and the accepted code-28 interruption semantic refusal, plus one focused wording-only mutation control.
Evidence explicitly deferred: adding the consumer to the shared nonzero `die()` funnel; changing `die_terminal_unprovable()` or any other message; changing refusal tokens, exit codes, result production, parsing, identity/semantic checks, pin/release behavior or recovery instructions; remaining Change set A; Change sets B–D; live trials; adoption review; the full synchronous regression gate; merge, push, deployment and destructive cleanup.
Primary edit begins after: add focused assertions to the existing dry-run and launched-actor interruption mismatch fixtures and quote their pre-edit failure: both correctly exit 38 and retain leases, but both print `failed this run's own consumer gate` and `refusing to exit 0`; the second statement is false for the interruption that was ending with code 28, and neither phrase is needed to describe artifact rejection.

Required outcome:

- Replace only the shared `die_terminal_untrusted()` refusal clause with terminal-neutral wording that says the promised artifact failed the consumer gate and is therefore refused as this run's reported ending. It must not say or imply that the original terminal was exit 0, and must not describe the gate itself as evidence of the artifact's provenance.
- Preserve each caller-owned terminal label, the bounded refusal token, the promised result path, the state classification, the reason the artifact is untrusted, both-lease retention, exit 38, the exact recovery action, and the rule that the refused artifact is not advertised.
- The same sentence must remain truthful for both code-zero consumers and nonzero consumers. Do not add code-specific branches, a new message owner, an expected-code parameter, or any funnel integration in this unit.
- Resolve the recorded shared-wording deferral with this change. Do not alter `die_terminal_unprovable()`; its separate wording and finalization-failure path remain outside this unit.

Check against the repository before editing:

1. Verify the exact `die_terminal_untrusted()` sentence still contains both `failed this run's own consumer gate` and `refusing to exit 0`, and that no focused test currently asserts terminal-neutral wording. If it is already equivalently neutral, hand back.
2. Verify the accepted dry-run mismatch fixture in case 58e and launched-actor interruption mismatch fixture in case 27w both reach `die_terminal_untrusted()`, retain leases and carry truthful distinct terminal labels, while differing in their intended terminal code (0 versus 28).
3. Add the wording assertions first and reproduce the red against both existing fixtures before changing production. The red must fail on the old phrases, not on exit, retention, label, token or fixture setup.
4. Search `dispatch.sh` and `dispatch.test.sh` for the two old phrases and bound the change to the one production sentence plus the focused assertions/control that own it. If another production message must change, hand back rather than widening.

Required fail-capable evidence:

- Quote the red and green for both existing semantic-refusal contexts. Green must show the dry-run refusal still names the admitted preflight terminal and the interruption refusal still names the launched-actor interruption terminal; both say the artifact failed the consumer gate and is refused as the run's reported ending; neither contains `failed this run's own consumer gate` or `refusing to exit 0`.
- Show all accepted behavior is unchanged in both fixtures: exit 38, distinct mismatch token, no refused-result advertisement, both leases retained, and next dispatcher exit 17.
- Add one wording-only mutation/control that restores exactly the former shared clause while leaving the consumer, terminal labels, expected pairs, tokens, exit/pin logic and recovery text intact. It must match exactly once, differ, parse, keep the behavioral refusal green, and make the new wording assertion fail; fail closed if it cannot run.
- Run only the directly affected cases 27 and 58 plus `bash -n` on both shell files. Do not run case 62 or the full dispatcher suite, because no consumer composition or boundary changed.
- Report the implementation commit and exact changed paths. Only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state may change; `logs/friction-log.md` remains pre-existing noise and must not be staged or committed.

Capability subset: baseline only — inspect the approved plan and accepted wording/test seams; edit only the shared refusal sentence, its focused assertions/control and this state; run the named focused local checks and shell syntax validation; make the local handback commit. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No external service, production action or operator-reserved capability is needed.

Completion condition: one committed wording change makes `die_terminal_untrusted()` truthful for both code-zero and nonzero semantic refusals without changing any refusal behavior or integrating the nonzero funnel; the two existing contexts prove the new sentence and reject the old phrases, the wording-only control restores the former false sentence while behavior still refuses, only the three permitted paths change, the recorded shared-wording deferral is resolved, and the state returns with `turn: codex`.

Stop and hand back if terminal-neutral wording requires changing another message, function signature, refusal token, recovery action, pin/release logic, schema, parser or consumer integration; if the existing fixtures do not isolate the sentence from behavior; or if the wording-only control cannot restore exactly the old clause. Challenge a false premise rather than widening.

## Latest result

Inspected (2026-08-18):

- Claim (1): HOLDS — read `dispatch.sh:1991` (`die_terminal_untrusted()`); the single sentence carried both `failed this run's own consumer gate` and `refusing to exit 0`. Searched `dispatch.test.sh` for both phrases and for `did not pass the consumer gate` / `reported ending`: no match, so no focused test asserted either the old or a neutral wording. Not already neutral.
- Claim (2): HOLDS — `expect_dry_refusal58` (case 58e) and `expect_int_refusal27` (case 27w) both assert exit 38, both leases retained with the bounded token, no result advertisement and next dispatcher 17, and each asserts its own distinct truthful label (`the admitted dry-run preflight terminal` vs `reached the interruption terminal after a launched actor`). Their consumer call sites differ in intended code exactly as claimed: `dispatch.sh:4009` passes `"$(result_outcome 0)" 0`, `dispatch.sh:2644` passes `"$(result_outcome 28)" 28`.
- Claim (3): HOLDS — assertions added first; the red reproduced on wording alone (below).
- Claim (4): HOLDS — searched both shell files for the two old phrases. `failed this run's own consumer gate` occurred once, in `die_terminal_untrusted()` only. `refusing to exit 0` occurred twice: `die_terminal_untrusted()` and `die_terminal_unprovable()` (`dispatch.sh:1972`). Only the first was changed; the unprovable sentence is untouched and the change stayed inside the one production sentence plus its focused assertions and control.
- Packaging lines: HOLDS — all four present for Implementation mode, `Dominant deliverable:` names one deliverable.

Result: `die_terminal_untrusted()`'s shared clause is now terminal-neutral. It reads `... did not pass the consumer gate (<token>) — so it is refused as this run's reported ending, because a result this run cannot prove is its own must not be reported as how it ended.` It no longer names an exit-0 ending and no longer calls the gate this run's own, so one sentence is true for the three code-0 consumers and for the code-28 interruption alike. No refusal behavior, token, exit code, label, pin/release logic, signature or recovery text changed, and no funnel integration was added.

Evidence: a marker-driven slice of cases 27 and 58 was run three times against the same dispatcher.

- Baseline (pre-edit `dispatch.test.sh`, from `HEAD`): `pass=240 fail=0`.
- Red (assertions added, production unchanged): `pass=240 fail=16` — the 240 accepted assertions were untouched and exactly the 16 new wording assertions failed, on wording only. Both fixtures still reported `refused with exit 38, never 28` / `never 0`, the truthful distinct labels, the bounded cause on both leases, and next dispatcher 17; the failures read `expected to contain: did not pass the consumer gate`, `expected to contain: refused as this run's reported ending`, `expected NOT to contain: failed this run's own consumer gate`, `expected NOT to contain: refusing to exit 0`.
- Green (production changed): `pass=258 fail=0` = 240 + 16 wording + 2 M38. Both semantic-refusal contexts pass all four new assertions while keeping exit 38, no advertisement, their own terminal label, no operator-terminal claim, both leases retained with the bounded `outcome-mismatch` / `code-mismatch` cause, and next dispatcher 17.

M38 is the wording-only control, added to case 58f beside M35. It restores exactly the two former clauses and nothing else, and fails closed: it requires each neutral phrase to have matched exactly once and to be gone from the mutant, the former phrase to be present exactly once, `refusing to exit 0` to stand at 2 (proving `die_terminal_unprovable()`'s own sentence was left alone), all four consumption markers, the dry-run label and the recovery text intact, and the mutant to differ and parse. Under it the run still refuses with exit 38 and both leases held while the shared sentence claims provenance and an exit-0 ending again — so the new assertions in both 58e and 27w are fail-capable off one control, because there is one production clause.

`bash -n` passed on both shell files. The recorded shared-wording deferral is resolved. Changed paths: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this state file. `logs/friction-log.md` was left unstaged.

Deferral noticed in this unit, not implemented: `dispatch.test.sh` has no case-selection mechanism — a bare invocation runs the whole suite, and an early attempt to pass `--cases 27,58` was silently ignored and started a full-suite run, which was terminated. Running only the named cases therefore required building a marker-driven slicer outside the repository (preamble + the result/validator/identity helpers the two regions borrow from later sections + the two case regions), proven faithful by the `pass=240 fail=0` baseline. A first-class focused-case selector in the harness would remove that step, but it changes the harness's own contract and is outside this unit's wording scope.

## Blocker

None.

## Next action

Codex: assess Unit 31. The shared `die_terminal_untrusted()` sentence is terminal-neutral and proven over one code-0 and one code-28 consumer, with a fail-capable wording-only control; the nonzero `die()` funnel remains unintegrated and is the next candidate consumer. Also dispose of the recorded deferral on the harness missing focused-case selector.
