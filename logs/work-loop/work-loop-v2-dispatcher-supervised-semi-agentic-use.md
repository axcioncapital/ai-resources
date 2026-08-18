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

Standard. Implementation mode. Unit 11 — complete ownership-stop result proof

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 10 is accepted at `2b720f29b8760bd59880c0216e9fb264fc7d69f3`: the reserved run-ID discriminator is populated again, stable for a canonical checkout/task pair, different across checkouts, and preserves the accepted filename and status contracts. The clearer `RUN_DISCRIMINATOR` name is accepted because it prevents the identity value from again being mistaken for obsolete lease state; controller proof is sufficient for this unit, while the plan's genuine parallel live trial remains explicitly deferred. The next smallest necessary gap is durable terminal-result proof for the ownership stops: code 34 is already accepted, code 33 is only partly proved, and code 35 has exit/no-launch coverage but no result coverage.

Dominant deliverable: complete permanent exactly-one-result proof for the admitted ownership stops `33` and `35`, closing the ownership-stop proof family with the already accepted code `34` evidence.
Evidence required in this hop: focused assertions on the existing code-33 and code-35 fixtures showing one complete result, truthful ownership/outcome fields, no model start, leases held at finalization and released afterwards; one bounded mutation showing those assertions fail when ownership-stop finalization is absent or wrong; syntax plus only the affected focused cases.
Evidence explicitly deferred: result proof for codes `13`, `14`, `15`, `26`, `37` and `29`; the three uncovered evidence-location refusal branches; other identifier/token bounds; every other Change set A clause; production changes unless the proof exposes a real defect; the full dispatcher suite; Change sets B–D; live trials; final regression; adoption review; historical-probe cleanup; merge, push, deployment and destructive cleanup.
Primary edit begins after: in scratch, express the intended ownership-result assertions against the existing fixtures and demonstrate that they fail against one narrowly mutated dispatcher copy where ownership stops cannot publish the expected terminal result. Do not edit production to manufacture the red.

Required outcome:

- Strengthen existing case 50e/code 33 only where its proof is incomplete: exactly one finalized result, no partial result, completion marker present, `model_request_started=no`, the bounded ownership next action, and released leases after the record truthfully says they were held at finalization. Preserve its existing observed owner-declaration assertions; do not reopen the separate `owner_declared` display-policy question.
- Extend the existing case 12d/code 35 absent-helper and broken-helper branches so each proves exactly one complete terminal result with `outcome=OWNERSHIP_UNAVAILABLE`, `code=35`, `stage=pre-hop`, no actor/model start, the truthful distinct owner-check status for that branch, both leases held at finalization, and both released after finalization.
- Reuse the existing result helpers and fixtures. Add no second schema checker, generalized exit-code matrix, new production helper or new test framework.
- Treat code 34's accepted Unit 6 evidence as settled; do not rerun or duplicate it. If the new assertions reveal wrong current production behavior, hand back the exact defect rather than combining a production repair with this proof unit.
- Keep the unit at the ownership boundary. Do not add state, permission, budget or evidence-location result cases merely because they are nearby.

Check against the repository:

1. Verify Unit 10 commit `2b720f29…` changes only this state file, the existing run-ID block and case 12i; reports case 12i `11/0`, its 12-family neighbors `33/0`, cases 1–4 `22/0`, and leaves only `logs/friction-log.md` unstaged. Treat that evidence as accepted and do not rerun it before editing.
2. Verify the approved plan requires exactly one valid terminal result for invalid ownership after admission, and the current dispatcher maps codes `33`, `34`, `35` to distinct bounded outcomes and the common ownership next action.
3. Verify on the complete existing test surface that case 50e proves some code-33 fields but not uniqueness/completeness, while both case-12d code-35 branches prove refusal/no-launch but no terminal-result facts. If permanent proof already exists elsewhere, hand back rather than duplicate it.
4. Verify both code-35 branches occur after run identity/evidence and both leases exist, and identify their truthful distinct `owner_check` values from the production path. If either is actually pre-admission, stop because the brief's premise is false.

Required fail-capable evidence:

- Quote the focused mutation red, naming which new result assertion fails and why. One narrow mutation is enough if it falsifies the shared ownership-result guarantee; do not build an ownership mutation matrix.
- Quote green focused results for code 33 and both code-35 branches, including one-result/no-partial/completion, outcome/code, no model start, truthful owner status, held-at-finalization and released-afterward facts.
- Run `bash -n` on the edited test script and execute only case 50e, case 12d and the minimum harness support needed for them. Do not rerun Unit 10 or the full suite.
- Confirm the final committed diff contains only this state file and focused additions inside the existing ownership test cases. `dispatch.sh` and the lease/owner helpers must remain byte-identical; leave `logs/friction-log.md` unstaged.

Capability subset: baseline only — read the approved plan, Unit 10 evidence, ownership result producer and existing cases 12d/50e; edit the focused test assertions; create and execute a scratch mutant; run local syntax and focused tests; and commit the test and this task state. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No model launch, authentication attempt, network, external service or operator-reserved capability is permitted.

Completion condition: one committed test-only handback permanently proves exactly one truthful complete result for ownership stops 33 and 35, preserves the accepted code-34 evidence without duplication, changes no production file, and returns with `turn: codex`.

Stop and hand back if either stop is pre-admission, equivalent permanent proof already exists, the assertions expose a production defect, or meaningful proof requires a generalized matrix, new helper contract or production change. Challenge the brief rather than widening it.

## Latest result

Inspected (2026-08-18):

- Claim (1): HOLDS — `git show 2b720f29 --name-only` lists exactly three files (this state file, `dispatch.sh`, `dispatch.test.sh`), one hunk each: `@@ -3191,15 +3191,34 @@` in the run-id block and `@@ -1596,6 +1596,97 @@` for case 12i. The `11/0`, `33/0` and `22/0` figures are read from the accepted record and were not rerun before editing. Unstaged at unit start: only `logs/friction-log.md` and this state file carrying Codex's brief.
- Claim (2): HOLDS on both halves. Plan, approved blob `c7857d5f` item 3: "Atomically finalize **exactly one** terminal result for: … invalid state or **ownership**". Dispatcher: `result_outcome()` maps the three codes to three **distinct** tokens — `33 → OWNERSHIP_REFUSED`, `34 → OWNERSHIP_AMBIGUOUS`, `35 → OWNERSHIP_UNAVAILABLE` — while `result_next_action()` maps `33|34|35` to one shared instruction, `operator-resolve-ownership`. Read from the two case statements, not inferred.
- Claim (3): HOLDS, and no equivalent proof exists elsewhere — searched the whole test surface for `OWNERSHIP_(REFUSED|AMBIGUOUS|UNAVAILABLE)` and `operator-resolve-ownership`, which returns exactly two sites: case 50e (code 33) and case 67a (code 34, the accepted Unit 6 evidence). **Nothing anywhere asserted a code-35 result.** Case 50e proved 11 things — exit, no launch, a result exists, six fields including `owner_declared=decoy-alpha`, both `lease_*_at_finalization`, and the **task** lease released — but not uniqueness, not completeness, not `model_request_started`, not `next_action`, and not the **checkout** lease's release. Case 12d proved exit 35, the refusal wording, no actor and no commit for the absent helper, and exit 35 plus no actor for the broken one — and **no terminal-result fact at all** for either.
- Claim (4): HOLDS. Both code-35 sites (`die 35` in the ownership block) sit below run identity, the evidence location and both lease acquisitions, so both are admitted-run terminals rather than pre-admission refusals — and `die()` funnels through `finalize_terminal_result "$code"` **before** `release_lock`, which is what makes "held at finalization, released afterwards" the expected shape. The two truthful distinct `owner_check` values, read from the production path and then confirmed by probe: absent helper → `unavailable`; helper ran and returned an unrecognised exit → `check-failed`.

Result: **the ownership-stop result family is closed. Case 50e now proves code 33's record is unique and complete, case 12d proves a complete result for each code-35 branch with its own truthful `owner_check`, and one reused mutation shows all of it fails when the shared funnel cannot publish. `dispatch.sh` and every helper are byte-identical to HEAD.**

**What changed, and only this.** `dispatch.test.sh` +166/-0, three hunks, all inside the two existing ownership cases: `@@ -722` (12d absent-helper), `@@ -751` (12d broken-helper plus the M41 control), `@@ -5973` (50e). `git diff --stat` on `dispatch.sh` and on all three `logs/scripts/` helpers is empty. No second schema checker, no exit-code matrix, no new production helper, no new test framework — the assertions reuse `res_field`, `res_count`, `part_count`, `run_id_of`, the existing `for pair in` idiom, and the existing 12d/50e fixtures unchanged.

**Code 34 was not touched or rerun.** Case 67a's accepted evidence stands as-is; it was read only as the shape to match, so the two ownership siblings now prove the same things about their own terminals.

Evidence:

- **The scratch red, before any test edit, exactly as the brief directs.** A probe expressed the intended code-35 assertions against the existing 12d fixture and ran them twice: against a mutated dispatcher copy, **`pass=2 fail=11`**; against the real dispatcher, **`pass=13 fail=0`**. Production was not edited to manufacture it — the mutant is a separate copy under the harness's own `$SANDBOX_ROOT`. The eleven that failed name the reason: `exactly one finalized result / found 0`, `completeness sentinel is last / got:` (empty), and nine `got: <absent>` field reads.
- **The committed mutation control, M41, and why it is one and not a matrix.** All three ownership codes publish through the same die funnel, so removing that single action falsifies the guarantee for all of them at once — which is what the brief asked for instead of an ownership mutation matrix. Green: `PASS M41 mutant differs from the dispatcher and still parses (the one funnel call site was found)`; `PASS M41: the ownership stop still exits 35 but publishes NO result (the assertions above are fail-capable)`; `PASS M41: and model_request_started reads as absent, not as 'no'`.
- **M41 is M1's construction reused verbatim, not a new technique.** Same marker line, `grep -Fxc` hit count required to be exactly 1, mutant required to differ and to parse. M1 already cuts this seam for case 50c, so inventing a second way to cut it would only create a way for two controls to disagree about the same line.
- **The control's value is that the exit code does not move.** Under M41 the run still exits 35. A case asserting only the code — which is what case 12d was — passes against that mutant and proves nothing about the record. What disappears is the record.
- **One added assertion is *not* falsified by M41, and saying so is the point.** `no unfinalized temporary artifact was left behind` passed under the mutant too, because a funnel that publishes nothing leaves no temporary either: `partials=0` both ways. It is fail-capable against a different failure — a non-atomic publish that leaves the `.partial` behind — which the suite already covers with M2. Reporting it as falsified by M41 would be the ceremony core § 6 rule 5 forbids.
- **Case 12d, green: `pass=42 fail=0`.** Absent-helper branch: one finalized result with no temporary beside it, complete to `result_complete=yes`, and eleven fields — `outcome=OWNERSHIP_UNAVAILABLE`, `code=35`, `stage=pre-hop`, `owner_check=unavailable`, `actor=none`, `actor_launched=no`, `model_request_started=no`, `hop=0`, `next_action=operator-resolve-ownership`, both `lease_*_at_finalization=held-by-this-run` — then both leases read as gone from the filesystem afterwards. Broken-helper branch: the same eleven with `owner_check=check-failed`, same uniqueness, completeness and release facts. The existing control (helper present → exit 0, actor runs) is untouched and still green.
- **The two branches are asserted against each other, not only against their own literals.** `PASS and the two branches recorded DIFFERENT owner_check verdicts` compares the two records directly — the check a shared constant of the right shape would pass while both literal assertions still succeeded.
- **Case 50e, green: `pass=19 fail=0`**, up from 12 assertions. Added: exactly one finalized result; no unfinalized temporary; exactly one `terminal_result_version=` line (an appending producer would carry two); `result_complete=yes` as the last line; `model_request_started=no`; `next_action=operator-resolve-ownership`; and the **checkout** lease's release. Its existing observed owner-declaration assertions are preserved verbatim, and the `owner_declared` display-policy question is untouched — nothing was pinned that would freeze one side of it.
- **Route and syntax.** `bash -n` clean on `dispatch.test.sh`. Only cases 50e and 12d were executed, each extracted by line range over the harness's own prologue with `DISPATCH_BIN`/`REPO_ROOT` pinned — Unit 10 was not rerun and neither was the full suite, as the brief requires. All probes and mutants live outside the tracked tree.
- **Final scope, by inspection.** `git status --porcelain` shows this state file, `dispatch.test.sh`, and the pre-existing unstaged `logs/friction-log.md`, left untouched and unstaged. `git diff --quiet` passes on `dispatch.sh`, `work-loop-owner.sh`, `work-loop-lease.sh` and `work-loop-state.sh`.

**No production defect was exposed.** Every field the new assertions read already carried the truthful value the plan asks for, on both code-35 branches and on code 33 — so this unit stayed test-only and nothing was handed back as a repair.

Deferrals recorded, not implemented (core § 5):

- **(a) `owner_declared` on the absent-helper branch reads `none`, and that is left unpinned.** With no `.owner` file the field is genuinely `none`, but that is the same token a checkout with no declaration produces when the check *did* run — so the field alone cannot distinguish "nothing declared" from "could not look". It is the same display-policy question case 67a already records as open for the ambiguous branch, so this unit asserts around it rather than freezing one answer. Codex may want it folded into that existing deferral rather than tracked twice.
- **(b) Result proof still missing for codes `13`, `14`, `15`, `26`, `37` and `29`**, exactly as the brief defers. Note the family boundary now: `33`, `34` and `35` are complete, so the ownership row is closed and the remaining gaps are state, permission and budget.
- **(c) Unchanged and still deferred:** the three uncovered `check_evidence_location()` refusal branches; other identifier and token bounds (`--max-hops` included); every other Change set A clause; Change sets B–D; live trials including trial 8; the final synchronous regression; adoption review; the two stale historical probe scripts; and merge, push, deployment and destructive cleanup.

## Blocker

None.

## Next action

Codex: assess Unit 11. The ownership-stop result family is closed: case 50e proves code 33's record unique and complete (`19/0`, up from 12 assertions), case 12d proves a complete result for each code-35 branch with its own truthful `owner_check` — `unavailable` and `check-failed`, asserted against each other (`42/0`) — and M41 shows the whole set collapses when the shared die funnel cannot publish (scratch red `2/11`, real `13/0`). Code 34's Unit 6 evidence was neither rerun nor duplicated. `dispatch.sh` and all three helpers are byte-identical to HEAD, and no production defect was exposed. Then decide three things. (a) Whether **one mutation is accepted as sufficient** for the whole ownership family — my argument is that all three codes publish through the same funnel, so cutting it once falsifies all of them, and a per-branch matrix is the ceremony the brief forbade. (b) Whether the honest gap I recorded matters: `no unfinalized temporary` is **not** falsified by M41 (a funnel that publishes nothing leaves no temporary either), so its fail-capability rests on the existing M2; accept that, or ask for it to lean on M2 explicitly. (c) Whether the `owner_declared=none` ambiguity on the absent-helper branch should fold into case 67a's existing open deferral rather than be tracked twice — and whether the remaining result-proof gaps (`13`, `14`, `15`, `26`, `37`, `29`) are the right next unit now that the ownership row is complete.
