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

Standard. Discovery mode. Unit 35 — adjudicate terminal-class result coverage

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 34 is accepted at `bad745e4293650c176ee28a55da1139801468e45` with disposition `SAFE AS IMPLEMENTED`: a later consumer refusal now preserves an already-pinned initiating cause, continues to expose its own bounded mismatch in stderr and the run log, and uses truthful lease wording. The focused green was 166/0, the ordinary unpinned control still records its own cause, and M40 restores the overwrite and false wording without changing the retained-lease exit path. With that terminal-boundary defect closed, the next justified question is whether the plan's enumerated terminal classes already have accepted proof of exactly one valid result, or which class is the next actual gap.

Current position: the approved plan is content-bound at `e9a6fd8bc51992a1ce8f6e09dcf95b273dd07240` (plan blob `43c44e01703c8622482d93d80407ddc1c83e038a`) against baseline `2451e3df5b8616e035a39a679799738a975b642e`; Change set A remains in progress after 34 accepted units. This unit advances plan § 5 Change set A, Required behavior item 3 and Change-set acceptance item 1. It is discovery-only because the unknown is proof coverage, not an authorized implementation change.

Dominant deliverable: adjudicate the existing proof coverage for every terminal class enumerated in Change set A Required behavior item 3, ending with either the first concrete uncovered class in plan order or a supported finding that this terminal-class slice is ready for Change set A acceptance.
Evidence required in this hop: a compact plan-to-repository mapping that classifies each enumerated terminal class as `COVERED`, `GAP`, or `UNKNOWN`, cites its production terminal owner and existing fail-capable proof, and identifies the earliest non-covered class without running or changing the dispatcher.
Evidence explicitly deferred: implementation of any discovered gap; the other Change set A required-behavior, field-ownership, durable-ordering, hostile-input and acceptance clauses; the focused-case selector improvement; Change sets B–D; live trials; final regression; adoption review; merge, push, deployment and destructive cleanup.

Required outcome:

- Read the terminal classes exactly from the approved plan: usage/argument refusal; missing runtime/authentication; invalid state/ownership; lease refusal; permission denial; actor timeout/interruption/failure; missing handback/no valid transition; partial/unexpected effects; budget exhaustion; operator takeover; and successful completion.
- For each class, identify the one production terminal-result path currently responsible for it and the existing committed evidence that can fail if that class stops producing exactly one structurally valid, run-bound result. Reuse accepted evidence; do not rerun suites or recreate prior probes.
- Classify a class `COVERED` only when both production routing and fail-capable proof are identifiable. Classify it `GAP` when a route or proof is demonstrably absent or contradicts the plan, and `UNKNOWN` when the bounded inspection cannot establish either. Do not treat a shared funnel, zero exit, prose assertion, or file appearance alone as proof.
- Stop at evidence and hand back. If a gap exists, name the earliest one in plan order as the candidate for the next bounded implementation unit, without designing or implementing its repair. If none exists, state only that this terminal-class slice is ready; do not infer that all of Change set A is accepted.

Check against the repository:

1. Verify the approved plan still contains the eleven grouped terminal classes above and the acceptance statement that every terminal class produces exactly one valid result. If the approved content differs, hand back the discrepancy.
2. Inspect the current dispatcher and its committed focused tests at `bad745e4…`, plus only the accepted implementation commits or task handbacks needed to establish a class's proof. Do not widen into Change sets B–D or unrelated dispatcher behavior.
3. Distinguish one shared finalization funnel from class-specific reachability. A class is not covered merely because it eventually calls `die`; cite the route into the funnel and the assertion or mutation that would fail if that route stopped finalizing exactly once.
4. Treat the missing focused-case selector as deferred operating friction, not a Gate SA requirement and not a reason to implement in this unit.

Required fail-capable evidence:

- Return the compact eleven-row classification with exact production symbols/locations and exact committed test cases or mutation controls. A row without both is not `COVERED`.
- For the earliest `GAP` or `UNKNOWN`, quote the precise missing or contradictory evidence and bound the searched surface. If all rows are `COVERED`, cite the controls that distinguish duplicate, missing, malformed, or unbound results rather than relying on aggregate pass counts.
- Report the inspected commits and paths and confirm no production or test file changed. The only permitted changed path is this task state file; `logs/friction-log.md` remains pre-existing noise and must not be staged or committed.

Capability subset: baseline only — read the approved plan, dispatcher, focused tests and necessary accepted Git history; update and commit only this task state with the discovery handback. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No test execution, external service, production action or operator-reserved capability is needed.

Completion condition: one committed discovery handback classifies all eleven plan-enumerated terminal classes from existing repository evidence, identifies the earliest non-covered class or supports readiness of this terminal-class slice, changes no production or test file, and returns the state with `turn: codex`.

Stop and hand back if the mapping requires rerunning tests, reconstructing missing historical evidence as though it had passed, treating aggregate suite success as class-specific proof, or widening into another Change set A clause. Challenge a false premise rather than filling the gap by inference.

## Latest result

Unit 35 is a Discovery unit. No production or test file changed and no suite was run; the only changed path is this state file. Inspected at `bad745e4293650c176ee28a55da1139801468e45`: the approved plan, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` and `.../dispatch.test.sh`.

Inspected (2026-08-18):

- Premise (1): HOLDS. The approved plan still carries the eleven grouped terminal classes verbatim at lines 146-156 under Change set A Required behavior item 3, and the acceptance statement `Every terminal class produces exactly one valid result.` at line 214. No discrepancy to hand back.
- Premise (3): the shared funnel was deliberately not accepted as class proof. Every row below cites the specific `die`/`die_hop`/direct-exit line that is the class's route, separately from the assertion that would fail if a result stopped being finalized.

Classification rule applied, stated so the rows can be checked: **`COVERED`** = the route into the funnel is citable *and* a committed assertion exists that reads a finalized run-bound result carrying that class's own code or outcome, so it would fail if that route stopped finalizing exactly one. **`GAP`** = the route provably bypasses result finalization, or no such assertion exists. Exit-code assertions alone were not counted — `expect_rc` sites exist for all twenty-six codes and prove the exit, not the result.

| # | Plan class | Production route | Result proof | Verdict |
|---|---|---|---|---|
| 1 | usage or argument refusal | `dispatch.sh:1455,1459-1466,1483,1493,1505-1514,1540,1682-1698,3113-3118` — direct `printf 'STOP [10\|11\|12]…'; exit`, all before `RUN_ID` is created at `3141` | none; no result is produced at all | **GAP** (route) |
| 2 | missing runtime or authentication | `die 31` at `3328,3335,3342,3347-3348,3355`; `die 20` at `3819,3830` | no committed assertion reads a result for 31 or 20 | **GAP** (proof) |
| 3 | invalid state or ownership | `die 13/14/15/26` at `3407-3433`; `die 33/34/35` at `4004-4010` | none for any of those codes | **GAP** (proof) |
| 4 | lease refusal | `r17()` at `1827-1831`, reached at `1880-1896` — writes a `.refusal` file via `open_refusal_record` (`1802`), before `RUN_ID` at `3141` | none; the `.refusal` artifact is not the versioned terminal-result schema and is not written by `finalize_terminal_result` | **GAP** (route) |
| 5 | permission denial | `die_hop 37` at `4345` → `die_hop` (`3067`) → `die` | none for 37 | **GAP** (proof) |
| 6 | actor timeout, interruption, or failure | `die_hop 21` at `4253,4284`; `die 20` at `3819,3830`; interruption via `on_signal` at `2668` | 28 only: case 27r `res_count=1` plus per-field record assertions incl. `code=28`, 27u, 27w, controls M29/M31/M37 | **COVERED** by 28; 21 and 20 unproven |
| 7 | missing handback or no valid transition | `die_hop 22`; `die 25` at `4020`; `die 26` at `3422`; `die_hop 36` at `4367` | 22 only: case 50a (`outcome=NO_TRANSITION`, `code=22`, one version line, sentinel), case 57a (`res_count=1`, `code=22`), control M39 | **COVERED** by 22; 25, 26, 36 unproven |
| 8 | partial or unexpected effects | `die 16` at `4197`; `die 18` at `4207`; `die 19` at `4191`; `die_hop 24` at `4308,4312`; `die_hop 30` at `4323` | 18 only: case 50b (`outcome=FOREIGN_UNSTAGED`, `code=18`, unavailable fields explicit, foreign path counted), case 50k clean control | **COVERED** by 18; 16, 19, 24, 30 unproven |
| 9 | budget exhaustion | `die_hop 29` at `4219,4251,4272,4282` | none for 29 | **GAP** (proof) |
| 10 | operator takeover | operator terminal at `4119` finalizing code 0 with `ST_CLASS=BLOCKED_OPERATOR` | case 55b (`code=0`, `state_class=BLOCKED_OPERATOR`, structurally valid, identity-valid), 55c (cannot collapse with completion), 56a, control M21 | **COVERED** |
| 11 | successful completion | same terminal at `4119` with `ST_CLASS=CLOSED` | case 55a (`code=0`, `state_class=CLOSED`, `result_complete=yes`, structurally and identity valid), 56a, 62a, controls M21/M33 | **COVERED** |

Earliest non-covered class in plan order: **class 1, usage or argument refusal.** It is the stronger kind of gap — not merely unproven but structurally unreachable. The quoted contradiction: the plan requires (line 145-146) that the dispatcher "Atomically finalize exactly one terminal result for: usage or argument refusal", while `finalize_terminal_result` refuses by its own coverage guard, `[ -n "${RUN_ID:-}" ] && [ -n "${LOG_DIR:-}" ] || return 1` (`dispatch.sh:769`), whose comment states the position outright: "No run identity means this terminal is outside the covered funnel — an argument refusal or a lease-infrastructure failure. Those exit directly and never reach here." Every argument-refusal exit sits above `RUN_ID="$(date …)"` at `3141`, so no result exists to finalize. The searched surface was the whole of `dispatch.sh` for `printf 'STOP [` direct exits and for every `die`/`die_hop` call site, and the whole of `dispatch.test.sh` for `res_field … code)" = N` result assertions; the latter exist only for codes 0, 18, 22, 28 and 38.

Class 4 (lease refusal) is the same shape and is named second, because it shares the cause — both terminals are reached before run identity exists — and any repair of class 1 will meet the same question. That is an observation about ordering, not a design.

Not established, and deliberately not inferred: whether a result is *feasible* for those two classes, since `--log-dir` and `--checkout` may themselves be the rejected argument. That is the implementing unit's question, and this unit does not answer or pre-empt it.

Residual limitation, stated rather than buried: rows 6, 7 and 8 are `COVERED` on one member each. Their unproven siblings — 20, 21, 25, 26, 36, 16, 19, 24, 30 — reach the funnel through the same inspected `die`/`die_hop` calls cited above, but no committed assertion would fail if one of those specific routes stopped finalizing. Per the brief's own bar the shared funnel was not counted as their proof, so they are recorded here as inspected-not-proven rather than folded into the verdict.

This adjudication covers Change set A Required behavior item 3 and the first Change-set acceptance bullet only. It says nothing about the other required-behavior items, trusted field ownership, durable ordering, the hostile-input boundary, or the remaining acceptance bullets.

## Blocker

None.

## Next action

Codex: assess Unit 35 and frame the next unit. Five of eleven terminal classes are `COVERED` (six, seven, eight by one member each; ten and eleven fully), six are `GAP` — two because the route bypasses result finalization entirely and four because no result assertion exists. The earliest is class 1, usage or argument refusal, whose terminals exit above `RUN_ID` and so cannot reach `finalize_terminal_result` at all; class 4 shares that cause. Decide whether the next unit repairs class 1, and whether the nine inspected-not-proven sibling codes in rows 6-8 warrant their own proof unit. The harness's missing focused-case selector remains deferred.
