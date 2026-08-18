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

Standard. Discovery mode. Unit 5 — re-verify the remaining terminal-result proof gaps

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 4 is accepted at `b8bfd30a5425e9ef96d9f43a5924ce191895f6e6`: missing-runtime behavior and committed proof already existed, while authentication readiness has no current route and belongs to Change set B. The discovery also falsified Unit 35's search method: it searched one assertion form and missed the `for pair in "code:N"` form already used by cases 50d, 50h and 50i. The only remaining Unit 35 `GAP (proof)` rows — invalid state/ownership, permission denial and budget exhaustion — were produced by that same incomplete search, so implementing from them before one bounded correction would be waste.

Dominant deliverable: replace Unit 35's unreliable proof-gap findings for invalid state/ownership, permission denial and budget exhaustion with one current, assertion-form-complete adjudication.
Evidence required in this hop: a compact route-and-proof mapping for only those three grouped classes, searching every committed result-assertion form currently used and identifying the earliest genuine remaining gap.
Evidence explicitly deferred: implementation or new permanent tests for any confirmed gap; terminal classes Unit 4 or Unit 35 already established as covered; Change set A clauses beyond terminal-result coverage; complete runtime/authentication preflight from Change set B; the dead `RUN_ID` discriminator; Unit 1's fixture limitation; the focused-case selector; Change sets B–D; live trials; final regression; adoption review; merge, push, deployment and destructive cleanup.

Required outcome:

- Re-adjudicate only these Unit 35 rows against the current dispatcher and committed tests: invalid state/ownership (`13`, `14`, `15`, `26`, `33`, `34`, `35`); permission denial (`37`); and budget exhaustion (`29`). Do not rebuild the full terminal-class matrix.
- For every currently reachable code in those rows, cite the production route into terminal finalization and the exact committed assertion or mutation control that can fail if the route stops producing exactly one valid run-bound result.
- Search all assertion shapes actually present in `dispatch.test.sh`, including direct `res_field` comparisons and loop/table forms such as `"code:N"`; do not infer absence from one grep shape.
- Classify each reachable code as `COVERED`, `BEHAVIOR GAP`, `PROOF GAP`, or `UNKNOWN`. A shared `die()` funnel, exit-code assertion, aggregate pass count or prose comment alone is not result proof.
- Identify the earliest genuine non-covered code in approved-plan order as the next bounded implementation target, or state that these three rows are covered. Do not design or implement a repair.
- Change no production, test or documentation file and run no broad suite. Existing committed fail-capable proof is preferred; if a bounded route cannot be adjudicated from it, return `UNKNOWN` rather than constructing a new fixture.

Check against the repository:

1. Verify Unit 4 commit `b8bfd30a…` proved Unit 35's row-2 search missed existing `code:20` / `code:31` loop assertions and that no source or test changed in Unit 4. If that premise differs, hand back.
2. Verify Unit 35 commit `f8efcd70…` names only rows 3, 5 and 9 as the remaining `GAP (proof)` rows after the now-corrected row 2, and record its exact production-code set rather than relying on this brief's copy.
3. Inspect the current `dispatch.sh` and `dispatch.test.sh` at the Unit 4 baseline plus only the accepted history needed to understand an existing assertion or mutation. Bound searches to codes `13|14|15|26|33|34|35|37|29`, their outcome symbols and the terminal-result helper/assertion forms.
4. Apply the approved plan's actual bar: every admitted terminal path must produce one durable atomic result. Pre-admission routes are outside this result contract and must be identified rather than counted as gaps.

Required fail-capable evidence:

- Return one compact table with one row per reachable code: production symbol/site, admission status, result producer/consumer path, actor-start fact, lease disposition, exact committed test/assertion or mutation, and verdict.
- For every `COVERED` verdict, explain in one line how its cited evidence would read differently if the result were missing, duplicated, malformed, unbound or semantically wrong. If it proves only some of those properties, say exactly which and do not overclaim.
- For every non-covered verdict, quote the precise missing route or assertion and state the complete searched surfaces and patterns. Identify the earliest one without proposing a repair.
- Confirm no production, test or documentation file changed; only this state file may be committed. Leave pre-existing `logs/friction-log.md` noise unstaged.

Capability subset: baseline only — read the approved plan, accepted Unit 35 and Unit 4 evidence, current dispatcher, focused tests and necessary accepted history; update and commit only this task state. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No test execution, source mutation, model launch, authentication attempt, network, external service or operator-reserved capability is permitted.

Completion condition: one committed discovery handback supplies a trustworthy current adjudication for the three remaining Unit 35 proof-gap rows, identifies the earliest genuine next target or establishes coverage, changes only this state file, and returns with `turn: codex`.

Stop and hand back if the three rows cannot be bounded without rebuilding the whole matrix; if current behavior differs materially from the approved plan; if existing evidence cannot distinguish a required property; or if resolving an `UNKNOWN` would require constructing a fixture. Challenge the brief rather than widening it.

## Latest result

Inspected (2026-08-18):

- Claim (1): HOLDS — `git show --stat b8bfd30a` changes exactly one file, this state file (58 insertions, 45 deletions); no production, test or documentation file is in the commit. Its committed record does establish the row-2 miss, and I re-confirmed the underlying fact independently: `git show f8efcd70:…/dispatch.test.sh` carries `"code:20"` at 5692 and `"code:31"` at 5961 and 6058.
- Claim (2): HOLDS — read Unit 35's table at `f8efcd70`. Exactly four rows carry **GAP (proof)**: rows 2, 3, 5 and 9. With row 2 corrected by Unit 4, rows 3, 5 and 9 remain, and no other row carries that verdict. Its production code set, recorded from the table rather than from this brief's copy: row 3 `die 13/14/15/26` at `3407-3433` and `die 33/34/35` at `4004-4010`; row 5 `die_hop 37` at `4345`; row 9 `die_hop 29` at `4219,4251,4272,4282`. Two matters this brief's copy does not carry, recorded because they bound the verdicts below: rows 6, 7 and 8 are **partially** covered ("COVERED by 28 / 22 / 18; the rest unproven"), so nine further codes sit outside this unit's scope and outside any covered claim; and code **26 appears in row 3 and again in row 7**, unproven in both, so adjudicating it here does not double-count it.
- Claim (3): HOLDS — inspected the current `dispatch.sh` (4507 lines) and `dispatch.test.sh` (10474 lines) at the Unit 4 baseline. Searched `dispatch.sh` for `die N`/`die_hop N` for each of `13|14|15|26|33|34|35|37|29`, and read `result_outcome()` for each code's outcome symbol rather than assuming one. Searched `dispatch.test.sh` in **every assertion form present in it**, established by enumerating the forms rather than assuming them: the loop form `"code:N"` (8 sites total, all listed below), direct comparison `res_field … code)" = N`, the `case "$(res_field … outcome):$(res_field … code)" in` form at 5564, the variable-parametrised form `= "$WANT50"` at 6282, plus each code's outcome symbol as a bare string and `expect_rc N`. The complete set of codes carrying a committed **result** assertion in any form is `0, 18, 20, 22, 28, 31, 33, 38`.
- Claim (4): HOLDS — plan lines 145-160. The admission-boundary paragraph puts pre-admission refusals outside the result contract; item 3 lists "invalid state or ownership", "permission denial" and "budget exhaustion" among the classes owing exactly one atomically finalized result. Every one of the nine codes below is post-admission, so none is excused by that paragraph and all nine are inside the contract.

Result: **the three rows are `1 COVERED, 8 PROOF GAP, 0 BEHAVIOR GAP, 0 UNKNOWN`.** No behavior defect was found. Unit 35's three surviving rows were directionally right — proof really is missing for eight of the nine codes — but wrong in detail on code 33, which case 50e already covers.

Shared facts, true of all nine and so not repeated per row: every site is post-admission (`LOG_DIR` 3143, `RUN_ID` 3172, `acquire_lock` 3263 all precede the earliest site at 3458), so `finalize_terminal_result()`'s own guard at 769 is satisfied at each; every one reaches `die()` at 1365, which finalizes, consumes through the four validators, advertises the path, then `release_lock` at 1424 and exits — so the lease is released only after a valid result, and `die_hop` (3074) is a one-line alias for `die`, adding no separate path.

| Code / symbol | Production site(s) | Actor started | Committed result assertion | Verdict |
|---|---|---|---|---|
| 13 `STATE_MISSING` | `3458, 3459, 3463, 3474` (`validate_state`, called 4021/4143/4349) | no | none — only `expect_rc 13` at test `424` | **PROOF GAP** |
| 14 `IDENTITY_MISMATCH` | `3469` | no | none — only `expect_rc 14` at test `404, 1882` | **PROOF GAP** |
| 15 `BAD_TURN` | `3475, 3484` (validator), `3985` (unknown actor name, in `launch_actor`) | no fork | none — only `expect_rc 15` at test `427, 5349, 5428` | **PROOF GAP** |
| 26 `MALFORMED_TERMINAL` | `3473` | no | none — only `expect_rc 26` at test `1751, 1788, 1816, 1848` | **PROOF GAP** |
| 33 `OWNERSHIP_REFUSED` | `4055` | no | **case 50e**, test `5764-5790` | **COVERED** (limits below) |
| 34 `OWNERSHIP_AMBIGUOUS` | `4056` | no | **none of any kind — not even an exit-code assertion** | **PROOF GAP** (worst of the eight) |
| 35 `OWNERSHIP_UNAVAILABLE` | `4057` (helper failed), `4061` (helper absent/unreadable) | no | none — only `expect_rc 35` at test `619, 655` | **PROOF GAP** |
| 37 `PERMISSION_DENIED` | `4396` via `die_hop` | yes — hop ran, denials in capture | none — only `expect_rc 37` at test `5192, 5228, 5258` | **PROOF GAP** |
| 29 `BUDGET_EXHAUSTED` | `4270, 4302, 4323, 4333` via `die_hop` | 4270 no; 4302/4333 yes (actor terminated); 4323 no | none — only `expect_rc 29` at test `2222, 3606, 3650` | **PROOF GAP** |

The single `COVERED` verdict, with exactly what its evidence does and does not prove — stated per the brief rather than claimed whole. Case 50e seeds `logs/work-loop/.owner` with a different task, runs to exit 33, then reads `R50E="$d/runs/$(run_id_of "$OUT").result"`.

- **Missing** — proven. `[ -f "$R50E" ]` is asserted directly.
- **Unbound** — proven. The path is derived from the run id the dispatcher printed, not composed by the harness, so a result written anywhere else fails the `-f` test.
- **Semantically wrong** — proven. `outcome:OWNERSHIP_REFUSED`, `code:33`, `owner_check:refused`, `owner_declared:decoy-alpha`, `actor_launched:no`, `stage:pre-hop`, and the two lease fields at `held-by-this-run`, plus the released lease directory afterwards.
- **Duplicated** — **NOT proven.** Case 50e makes no `res_count` assertion, so a second result finalized into the same directory would not be detected.
- **Malformed** — **partially proven only.** It asserts individual fields but never `result_complete=yes`, so a record truncated after the fields it happens to read would still pass.

Those two omissions are real and are named here rather than smoothed into the verdict; 33 is covered against the failures the case can see, not against all five.

For the eight `PROOF GAP` verdicts, the precise missing thing and the searched surface: **no assertion anywhere in `dispatch.test.sh` reads a `.result` file for any of codes 13, 14, 15, 26, 34, 35, 37, 29.** Searched surfaces and patterns, complete: all 10474 lines of `dispatch.test.sh` for `"code:N"` (found only 28, 28, 22, 18, 20, 33, 31, 31 — at 2984, 3125, 5516, 5598, 5729, 5770, 5998, 6095), for every `res_field … code` comparison line (found only 0, 22, 38), for each of the nine outcome symbols as a bare string (`STATE_MISSING`, `IDENTITY_MISMATCH`, `BAD_TURN`, `MALFORMED_TERMINAL`, `OWNERSHIP_AMBIGUOUS`, `OWNERSHIP_UNAVAILABLE`, `PERMISSION_DENIED`, `BUDGET_EXHAUSTED` — no hits; `OWNERSHIP_REFUSED` hits only 50e), and the ±14-line neighbourhood of all 18 `expect_rc` sites for those codes for any `.result`, `res_count` or `res_field` use — none present.

**What the verdict does and does not assert.** `PROOF GAP` here says the route is citable and the proof is absent. It does **not** assert the behavior is correct: no code below was executed, because this unit's capability subset forbids test execution and fixture construction. The behavior expectation rests on inspection — call order placing every site inside the finalizer's guard, plus case 50k's structural independence assertion that the funnel is one generic call site deriving its expected symbol through `result_outcome "$code"` with no per-code branch, plus Unit 4's empirical confirmation of that same funnel at codes 31 and 20. That is why none is `BEHAVIOR GAP` and none is `UNKNOWN`: both halves — route and proof-absence — were established, and only execution is missing.

Earliest genuine non-covered target, in approved-plan order: **plan class 3, invalid state or ownership** (row 3 precedes rows 5 and 9). Its lowest-numbered uncovered code is **13 `STATE_MISSING`**. One item deserves separating from plan order, though: **code 34 `OWNERSHIP_AMBIGUOUS` is the only one of the nine with no test of any kind** — the other seven at least pin their exit code. It is reachable (`work-loop-owner.sh:89` exits 4 on `AMBIGUOUS`, and the dispatcher branches on that at 4056), and it is the route that fires when one task is replicated across checkouts with none declaring it — the case core § 7 reserves to the operator. Nothing currently proves the dispatcher stops there at all.

No production, test or documentation file changed and no suite was run: `git status --porcelain` shows only this state file and the pre-existing unstaged `logs/friction-log.md`. Only this state file is staged.

## Blocker

None.

## Next action

Codex: scope the next unit against a corrected picture — proof is genuinely missing for eight codes, but the gap is narrower than Unit 35 recorded (33 is covered) and wider in one place than plan order suggests (34 has no test at all). Decide (a) whether one implementation unit adds result assertions across the eight, or whether it is bounded to plan class 3 first, starting at code 13; (b) whether code 34 is pulled forward out of plan order on the ground that it is wholly unexercised and its class is operator-reserved; and (c) whether case 50e's two named omissions — no `res_count` uniqueness check, no `result_complete=yes` completeness check — are folded into that unit or recorded as a deferral. Note for sizing, not for action now: rows 6, 7 and 8 carry nine further unproven codes (`16, 19, 21, 24, 25, 26, 30, 36`, and `20` at `die_hop`) that no unit has yet re-adjudicated in every assertion form.
