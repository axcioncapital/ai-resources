---
task: work-loop-v2-dispatcher-supervised-semi-agentic-use
status: active
turn: codex
---

## Objective and scope

Implement the approved revised plan at `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` through its complete revised Gate SA acceptance contract and independent adoption review, so the dispatcher may truthfully carry the label **Ready for supervised semi-agentic use — durable terminal results are guaranteed after run admission.**

Scope: the existing Work Loop v2 supervised dispatcher, its accepted helpers and runtime surfaces, focused proof, the required live trials, and the synchronous regression gate named by the plan. Excluded throughout: durable results for invalid pre-admission invocations; the unqualified **Reliable supervised semi-autonomous dispatcher** label; Gate ST; Gate U; unattended or walk-away release claims; a dispatcher rewrite or language migration; merge, push, deployment, destructive cleanup; and every other exclusion in plan §§ 4 and 7.

Task exit condition: one integrated candidate has passed the revised Gate SA and the independent review has returned `ADOPT`, or Patrik has explicitly chosen `SHRINK` or `STOP`.

## Lane and unit

Standard. Implementation mode. Unit 6 — prove the ownership-ambiguity terminal result

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 5 is accepted at `61ee46a6a63ba186e24dbc1d079fabda01679f9d`. It established that code 34 `OWNERSHIP_AMBIGUOUS` is a reachable post-admission route required by Change set A and is the only route in the bounded set with no committed test of any kind. This unit closes only that real proof gap; it does not create a general matrix, helper, selector or proof framework.

Dominant deliverable: add one permanent fail-capable regression proving that an admitted ownership-ambiguity refusal produces exactly one complete, run-bound and semantically correct terminal result.
Evidence required in this hop: the focused code-34 case green on the real dispatcher, plus a bounded negative control showing that the case fails when its terminal result is absent or invalid; the narrowest existing dispatcher regression that can safely include the new case.
Evidence explicitly deferred: result proof for codes `13`, `14`, `15`, `26`, `35`, `37` and `29`; strengthening case 50e/code 33 for uniqueness and `result_complete=yes`; re-adjudicating the nine sibling codes in Unit 5's note; every Change set A clause beyond this one route; the focused-case selector; Change sets B–D; live trials; final regression; adoption review; merge, push, deployment and destructive cleanup.
Primary edit begins after: a focused ownership-ambiguity case is made red by the narrowest temporary mutation or existing prove-failure mechanism that suppresses or invalidates its terminal result. The temporary mutation must not survive the unit; do not add a mutation framework.

Required outcome:

- In `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, add the smallest permanent case that reaches the dispatcher's current post-admission `OWNERSHIP_AMBIGUOUS` route through the real ownership helper. Do not simulate success by calling the finalizer directly.
- Prove exit `34`, no actor launch, and exactly one result at the path bound to the dispatcher-advertised run id.
- Prove the result is complete and semantically correct for this route, including at minimum protocol/version completeness, `outcome:OWNERSHIP_AMBIGUOUS`, `code:34`, the ownership ambiguity fact, truthful actor/stage facts, and the applicable lease state before and after finalization. Follow the existing result assertion vocabulary rather than introducing an abstraction for one case.
- Keep production code unchanged if the current route satisfies the contract. If the case exposes a behavior defect, stop and hand back the failing evidence; do not turn this proof unit into a combined test-and-production repair.
- Do not touch case 50e/code 33 or add coverage for another code. Do not implement a focused-case selector, general table-driven matrix, new helper, schema change or documentation expansion.

Check against the repository:

1. Verify Unit 5 commit `61ee46a6…` changed only this state file and established that code 34 is post-admission, reachable from the owner helper's `AMBIGUOUS` result, and has no exit-code or result assertion in the committed dispatcher tests. If any premise is false, hand back before editing.
2. Verify the approved plan at blob `c7857d5fb7956533c1047a8f449ba09f43186f9e` requires every admitted invalid-state-or-ownership terminal path to produce exactly one valid durable result. This is why the test is release proof rather than optional polish.
3. Inspect the current ownership and result-test fixtures before constructing anything. Reuse their established linked-worktree/owner setup and result readers where sufficient; do not create a second fixture system.
4. Verify that the negative control actually makes the new result assertion fail, then restore the real dispatcher before the green run and before commit.

Required fail-capable evidence:

- Quote the red negative-control command or bounded procedure and the failing assertion/output. State exactly what was temporarily changed and prove it was restored.
- Quote the green focused-case result, including the asserted result count and the fields that establish completeness, binding and semantics.
- Run the narrowest existing regression surface that safely exercises the committed case. If no focused execution route exists, run the existing dispatcher suite; do not build a selector in this unit. Report exact pass/fail counts.
- Confirm the final diff contains only this state file and the focused dispatcher test change, with no surviving production mutation and the pre-existing `logs/friction-log.md` noise unstaged.

Capability subset: baseline only — read the approved plan, Unit 5 handback, dispatcher, ownership helper and existing dispatcher fixtures; temporarily mutate only the dispatcher surface needed for the negative control, restore it, edit the focused dispatcher test, run local tests, and commit the test plus this task state. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No model launch, authentication attempt, network, external service or operator-reserved capability is permitted.

Completion condition: one committed implementation handback adds permanent fail-capable code-34 terminal-result proof, leaves production behavior unchanged unless it stops on a discovered defect, reports red and green evidence plus the narrow regression result, and returns with `turn: codex`.

Stop and hand back if code 34 is pre-admission or unreachable; if reaching it requires changing production behavior; if no bounded negative control can show the new assertion can fail; if the fixture requires a new general framework; or if the current route fails the terminal-result contract. Challenge the brief rather than widening it.

## Latest result

Inspected (2026-08-18):

- Claim (1): HOLDS — `git show --stat 61ee46a6` changes exactly one file, this state file. Its three established facts re-verified independently rather than read back from the handback: code 34 is post-admission (`die 34` at `dispatch.sh:4056`, below `RUN_ID` 3172 and `acquire_lock` 3263); it is reachable through the real helper (`logs/scripts/work-loop-owner.sh:89` maps verdict `AMBIGUOUS` to exit 4, and `marker_holder` at 592-607 returns `?` for a declaration holding more than one non-empty line); and it had no assertion of any kind — searched all of `dispatch.test.sh` for `expect_rc 34`, `"code:34"`, `res_field … code)" = 34` and `OWNERSHIP_AMBIGUOUS`, all four returning nothing.
- Claim (2): HOLDS, and the blob pin is exact rather than stale — I checked, because HEAD's blob for the plan is `af0f1efd…`, not the pinned `c7857d5f…`. `c7857d5f` is the blob at commit `849d0800`, and the plan's own approval record binds Patrik's 2026-08-18 approval to precisely that commit and blob. The later commit `b6a20ed0` only records that approval and states it "changes no objective, boundary, exclusion, sequence, acceptance condition or authority relationship". Verified by diff: `### Change set A` is **byte-identical** between the two blobs. In the approved blob, item 3 requires "Atomically finalize exactly one terminal result for … invalid state or ownership", which is code 34's class. The brief's pin is right and my first reading of it was wrong.
- Claim (3): HOLDS — inspected the existing fixtures before building anything. The new case reuses `new_sandbox`, `state_file`, `run_dispatch`, `$NOOP`, `calls`, `run_id_of`, `res_count`, `part_count`, `res_field`, `out_has` and `expect_rc`, and follows case 50a's assertion vocabulary and case 50e's ownership setup. No second fixture system, no helper, no selector, no schema change.
- Claim (4): HOLDS — the negative control did make the new assertions fail, and nothing needed restoring because nothing tracked was mutated. Evidence below.

Result: **case 67a added to `dispatch.test.sh`, 28/28 green, production code unchanged.** The route already satisfied the contract, so no production edit was made or needed. One pre-existing suite failure unrelated to this unit was surfaced by the required full regression and is reported below rather than fixed.

What the case does. `Case 67a — an admitted OWNERSHIP_AMBIGUOUS refusal finalizes exactly one complete run-bound result`, appended at `dispatch.test.sh:10470-10587`. It writes two task ids into one `logs/work-loop/.owner`, which is the helper's own documented "holds more than one task id" row, so the `AMBIGUOUS` verdict is produced by the shipped helper's logic — nothing stubs the helper, plants a verdict or calls `finalize_terminal_result` directly. The case first asserts the real helper returns exit 4 for that declaration, so a fixture that stopped reaching the ambiguity route would fail loudly instead of quietly asserting against some other terminal.

Green — the full existing dispatcher suite, `bash dispatch.test.sh`: **`pass=1319 fail=3`**. All 28 of case 67a's assertions pass:

- exit `34`; `calls=0`; the stop text names the helper's own ambiguity verdict.
- exactly one finalized result, counted three ways — one `.result` file, zero `.result.partial`, and exactly one `terminal_result_version=` line inside it (an appending producer would carry two).
- protocol completeness — first line `terminal_result_version=1`, last line `result_complete=yes`, every line matching the bounded `key=value` grammar.
- semantics — `outcome=OWNERSHIP_AMBIGUOUS`, `code=34`, `task=owner-ambiguous-task`, `owner_check=ambiguous`, `stage=pre-hop`, `actor=none`, `actor_launched=no`, `model_request_started=no`, `hop=0`, `next_action=operator-resolve-ownership`.
- binding, from inside the artifact as well as from its name — `run` equals the announced run id, `checkout` equals the canonical checkout.
- lease order — both leases recorded `held-by-this-run` at finalization and both directories gone afterwards, so release happened after a valid result existed.

Red — the negative control. **Nothing in the tracked tree was mutated**, so "restored" is trivially satisfied and verifiable: the mutant is a scratchpad copy of `dispatch.sh` carrying one added line, `[ "$code" = 34 ] && return 1`, injected after `local code="$1"` in `finalize_terminal_result()`, and the suite was pointed at it through the harness's own existing `DISPATCH_BIN=` mechanism. Command: `DISPATCH_BIN=<scratch>/mutant-no34.sh REPO_ROOT=<checkout> bash <scratch>/frozen.test.sh`. That mutation suppresses the result for code 34 and nothing else, so the red run stays legible. Result: **`pass=1296 fail=26`**, and **22 of the 26 failures are case 67a's**, including:

```
FAIL  67a — exits 34 when ownership is ambiguous
      expected exit 34, got 38
FAIL  67a — a terminal result exists at the run-bound path
      missing …/20260818T190406--42276-owner-ambiguous-task.result
FAIL  67a — exactly one finalized result
      found 0
FAIL  67a — the last line is the completeness sentinel
FAIL  67a — outcome=OWNERSHIP_AMBIGUOUS
FAIL  67a — both leases it reported holding were released on the way out
```

Three of 67a's assertions correctly stayed green under the mutant — nothing was launched, no partial artifact survived, and the stop still named the ambiguity — which is right: the mutation removes the result, not the refusal. `git diff --quiet dispatch.sh` confirms the production file is byte-identical to HEAD, and the whole test diff is a single insertion hunk, `@@ -10469,0 +10470,118 @@`, with zero deleted or modified lines, so no pre-existing case was touched.

**Pre-existing failure found by the required regression, not caused by this unit — reported, not fixed.** The 3 green failures are all **case 58b** ("a dry-run whose publication FAILS pins both leases and exits 38"), and they appear identically in the red run, so they are independent of the mutant too:

```
FAIL  58b — the unprovable dry-run exits 38, never 0
      expected exit 38, got 10 — STOP [10] run evidence directory is not writable
FAIL  58b — both leases retained across the EXIT trap with the truthful finalization-failure cause
FAIL  58b — the next dispatcher is refused by the retained lease
```

58b forces a publication failure by making the run-evidence directory unwritable. That is now refused earlier, at exit 10, by `check_evidence_location()` — which **Unit 1 added** (`git log -S"check_evidence_location"` → `48d0459d`). Units 1, 2 and 3 each reported only focused slices (`52/0`, `208/0`, `233/0`) and no full-suite run, so this has been red for three accepted units without being seen. It admits two readings and I am deliberately not choosing between them: either 58b's forcing technique is simply obsolete and the case needs a different way to reach the publication-failure path, or Unit 1's pre-admission check has made that post-admission failure mode unreachable by this route, which would be a Change set A question rather than a test question. Fixing either is outside this unit's dominant deliverable and outside the brief's scope.

Deferral recorded, not implemented (core § 5): `owner_declared` reports the **first** non-empty line of the declaration, so this terminal records `owner_declared=owner-ambiguous-task` beside `owner_check=ambiguous` — one of the two ids that made it ambiguous. It is defensible, because the field's stated contract is "a declaration that exists" and the stop message carries the helper's full reason, but arguably it should read `unavailable` when the declaration cannot be resolved to one owner. Case 67a therefore asserts `owner_declared` is **non-empty and does not pin its value**, with the reason written at the assertion, so a future decision either way does not have to fight a regression this unit froze.

One process note. The first baseline run was started before the test edit and was still executing when the edit landed; bash reads a script lazily, so that run would have picked up the new case mid-flight. I terminated it (exit 144) and discarded its partial output rather than report a baseline it could not honestly carry. The red and green runs above were both started after the edit was complete, and the red run used a frozen copy of the test file so that no later edit could affect it. Also disclosed: red and green were run in parallel, and under that contention case 28's timing assertion failed in the red run ("took 728s, bound is 14s"); it passes in the green run, which is why green is the reported regression result.

Final scope: `git status --porcelain` shows the test file, this state file, and the pre-existing unstaged `logs/friction-log.md`. Only the test file and this state file are staged; `dispatch.sh` is identical to HEAD.

## Blocker

None.

## Next action

Codex: assess Unit 6 — code 34 now has permanent fail-capable terminal-result proof and the production route was found already correct. Then decide three things. (a) **Case 58b is red and has been for three accepted units.** Decide whether it is a test-fixture obsolescence or a Change set A finding about Unit 1's pre-admission check closing a post-admission failure path, and whether it becomes the next unit — it is a regression in the accepted baseline, so it likely outranks the remaining proof gaps. (b) Whether a full-suite run becomes required evidence at the end of each unit rather than a focused slice, since three units in a row missed this. (c) Whether the `owner_declared` deferral above is scoped into the eventual ownership work or accepted as written. The remaining terminal-result proof gaps (`13, 14, 15, 26, 35, 37, 29`) and the case 50e strengthening stay deferred exactly as this brief left them.
