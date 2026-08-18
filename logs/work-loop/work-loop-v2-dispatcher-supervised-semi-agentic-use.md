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

Standard. Discovery mode. Unit 16 — map remaining token-boundary gaps

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 15 is accepted at `944184aad91a070469048ae36e6d9bc34900a079` with its correction at `ae9dd70c00d98203e4aee3f87e5898fd9d490443`. The three remaining evidence-location branches now have permanent `37/0` pre-admission proof through one narrow helper, no production change, and no repeated live-holder scenario. The correction removed 40 lines of duplicated narrative while a code-only before/after diff remained empty at 121 executable lines; syntax and the same focused slice stayed green. The two-point precondition is accepted as the real current boundary shape, not new machinery to consolidate.

The nearest unresolved Change set A question is the rest of the approved hostile-token requirement. Unit 9 already bounded task IDs at 128 and recorded that run IDs, outcomes, reason codes, protocol versions and control tokens remained deferred. Some may already be closed enumerations or bounded at their consumer; others may be externally supplied and genuinely unbounded. One compact discovery is necessary before implementation so the task does not add meaningless checks to internally fixed literals or miss an actual trust boundary.

Dominant deliverable: a current, producer-to-consumer adjudication of the five remaining token classes named by Change set A.
Evidence required in this hop: one compact map of each class's producer, trust boundary, current character and length control, mechanically consumed tests, and exact verdict; then one earliest genuine next target.
Evidence explicitly deferred: any production or test change; evidence-location work already accepted; path and handback hostile-input families outside these five token classes; Change set B execution budgets including `--max-hops`; the full dispatcher suite; Change sets B–D; live trials; final regression; adoption review; historical cleanup; merge, push, deployment and destructive cleanup.

Required outcome:

- Adjudicate only the plan's five still-unsettled classes: run IDs, terminal outcomes, reason codes, protocol versions, and control tokens. Do not rebuild a complete hostile-input matrix.
- For each class, enumerate every production source that can reach a trusted control or terminal-result field, distinguish external/actor input from dispatcher-generated literals, and trace the consuming validation or closed enumeration. A generated fixed literal is not unbounded merely because no runtime length check wraps it.
- Treat `control tokens` as values that can alter dispatcher routing, authority or continuation. Enumerate that surface from current parsing and transition logic, then separate tokens already constrained by a closed `case`/grammar from values with only a type check or no upper bound. Record `--max-hops` as Change set B evidence rather than silently importing its implementation into this Change set A unit.
- Classify each row `COVERED`, `BEHAVIOR GAP`, `PROOF GAP`, `NOT APPLICABLE`, or `UNKNOWN`. Name the exact missing control or proof for every non-covered verdict.
- Identify one earliest, smallest implementation target in approved-plan order. If all five classes are already structurally bounded, say so and identify the next unmet Change set A clause instead.

Check against the repository:

1. Verify Unit 15 and correction commits are test/state-only, preserve production, and report the accepted `37/0` plus empty code-only correction diff. Do not rerun them.
2. Verify the approved plan blob still names strict length and character grammars for exactly these token classes alongside task IDs, and distinguish that Change set A requirement from Change set B's separate hop/deadline/usage ceilings.
3. Inspect the complete current producer/consumer surfaces in `dispatch.sh`, its terminal-result validator/reader, and the focused committed tests. Search every assignment and accepted input route for each class; do not infer coverage from one grep form.
4. Use accepted history only where needed to understand a current contract, especially Unit 9's task-ID decision and Unit 10's run-ID discriminator repair. Current code and tests decide present behavior.

Required fail-capable evidence:

- Return one compact table: token class/value, source and trust level, current grammar/maximum or closed set, consumer, exact permanent proof, and verdict.
- For every `COVERED`, state how the cited mechanism or test would read differently if an out-of-grammar or over-bound value reached trusted routing/result framing. Do not call prose or an aggregate pass count proof.
- For every gap, name the complete searched surfaces/patterns and the smallest hostile example that would distinguish current behavior from the approved requirement; do not execute or implement it.
- Confirm no production, test or documentation file changed and no test suite ran; only this state file may be committed. Leave `logs/friction-log.md` unstaged.

Capability subset: baseline only — read the approved plan, accepted Units 9, 10 and 15 evidence, current dispatcher, terminal-result validator/reader and focused tests; inspect necessary accepted history; and commit only this task state. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No test execution, source mutation, model launch, authentication attempt, network, external service or operator-reserved capability is permitted.

Completion condition: one committed discovery handback establishes the exact remaining behavior/proof gaps for the five token classes, identifies one justified next target without implementing it, changes only this state file, and returns with `turn: codex`.

Stop and hand back if `control tokens` cannot be bounded from the current dispatcher surface without inventing a new policy category, if the five classes require a full hostile-input audit to adjudicate, or if current behavior materially conflicts with the approved plan beyond one bounded next target.

## Latest result

Inspected (2026-08-18):

- Claim (1): HOLDS — `git show --stat` on `944184aa` and `ae9dd70c` lists only `logs/work-loop/…-use.md` and `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`; `git diff 944184aa^ HEAD -- …/dispatch.sh` is empty, and `git diff --name-only 944184aa^ HEAD` returns exactly those two paths. The accepted `37/0` is at line 71 of the `944184aa` state blob. A code-only view of both `dispatch.test.sh` blobs (comments and blank lines stripped) diffs empty at 7698 lines each — the whole file, a superset of the block-level 121-line claim. Neither commit was rerun.
- Claim (2): HOLDS — plan blob `af0f1efd`, line 209: "Apply strict length and character grammars to task IDs, run IDs, outcomes, reason codes, protocol versions, and control tokens." Exactly the five classes plus task IDs, under `#### Hostile-input boundary` in Change set A. Change set B's `#### Retry and execution budgets` (lines 236–246) separately owns the three-hop ceiling, whole-run deadline and usage/state-size budgets; `--max-hops` is recorded here as Change set B evidence and was not imported.
- Claim (3): HOLDS — searched `dispatch.sh` (4585 lines) for every assignment and input route of each class: `run_id=|RUN_ID=|--run-id|WL_RUN_ID`, all `RUN_ID`/`RUN_DISCRIMINATOR` references, `result_outcome`/`result_next_action`, `tr_val`/`tr_kv`/`tr_kv_or`, the four `TERMINAL_RESULT_*` constants, `validate_terminal_result{,_identity,_semantics}`, `consume_terminal_result` call sites, the argument `case`, `ST_CLASS`/`ST_TURN`, `OWNER_STATUS`, `WL_LEASE_HOLDER_*`, `permission_denials_in`, and every `[Vv]ersion` occurrence. Test surface searched by reason token (`run-mismatch`, `unknown-version`, `bad-version-line`, `unknown-schema`, `value-too-long`, `too-large`, `too-many-lines`) and by `expect_rc 10`/`expect_rc 12`.
- Claim (4): HOLDS — Unit 9's decision is stated in production at `dispatch.sh:1518-1536`, including its own record that bounds for these five classes "are not in place yet"; Unit 10's discriminator is at `dispatch.sh:3215`. Both were read to understand the current contract; every verdict below is taken from current code and current committed tests.

Result: all five classes are already structurally bounded, and not by the grammars the plan names. Four of the five are protected by something strictly stronger — equality against a dispatcher-owned value, or a closed `case` whose default refuses — so adding a length/character grammar to them would be ceremony. The adjudication did surface one genuine, reachable defect in the control-token surface, and it is the earliest next target.

| Class | Producer / trust | Current control | Consumer | Permanent proof | Verdict |
|---|---|---|---|---|---|
| Run IDs | `dispatch.sh:3221`, dispatcher-generated. No `--run-id` option, no env route (searched both) | timestamp 15 fixed + `shasum\|cut -c1-8` 8 fixed + `$$` + `$TASK` (already `^[A-Za-z0-9][A-Za-z0-9._-]*$`, ≤128) | `validate_terminal_result_identity:1284` — `TR_RUN` = `$RUN_ID` by equality | case 12i; case 52 `run-mismatch` + mutation control m11 deleting that refusal | COVERED |
| Terminal outcomes | `result_outcome()` — closed `case` over the exit code, ~30 fixed literals, `*) UNCLASSIFIED` | `tr_val` truncates to 512 and strips `\n\r\t` on write | `validate_terminal_result_semantics:1357` — `TR_OUTCOME` = caller's `result_outcome "$code"` | case 62b (3 outcome-mismatch fixtures); 27w/50k/58e/60j; 62c proves all four seams supply an expectation | COVERED |
| Reason codes | `$code` — the dispatcher's own exit code, passed to `die`/`finalize_terminal_result` | same `tr_val` bound | same boundary:1358 — `TR_CODE` = caller's `$code` | case 62b code-mismatch fixture | COVERED |
| Protocol versions (record) | `terminal_result_version`, `schema` — dispatcher constants | must be key #1 and exactly `1` (`:1155-1157`); `schema` exact-match | `validate_terminal_result` refuses `unknown-version` / `bad-version-line` / `unknown-schema` | case 51b — all three tokens asserted | COVERED |
| Protocol versions (binary) | `claude --version` (`:3439`) — external subprocess, gates `--unattended` | `version_number` extracts only `[0-9]+\.[0-9]+\.[0-9]+`; `version_at_least` re-validates `''\|*[!0-9.]*` and per-component digits; empty or unusable → `die 31` | the `--unattended` authority gate | cases 32f, 32h | NOT APPLICABLE as a trust boundary — the producer is the same binary about to be trusted with the entire hop, so a grammar here constrains nothing an adversary does not already own. Fails closed regardless |
| Control tokens — option **names** | operator argv | closed `case` `:1436-1455`, `*) STOP [10] unknown argument` | argument parser | none — searched `unknown argument`, `--bogus\|--unknown\|--nosuch`, all 10 `expect_rc 10` sites (every one asserts a *value* or a mode *combination*, never the name grammar) | PROOF GAP |
| Control tokens — option **arity** | operator argv | none | argument parser | none | **BEHAVIOR GAP** — see below |
| Control tokens — `MODE`, flags | dispatcher literals `:3572-3575` | set to fixed literals from `{live, simulated, dry-run, status}`; flags set to `1`, never to an argv value | routing | 32f/5426, 4361 (mode-combination refusals) | COVERED |
| Control tokens — state class | `work-loop-state.sh` | exit code consumed first (`:3545-3554`); then `ST_CLASS` closed `case` with `*) die 15` | `validate_state` | 51b-adjacent; the `*)` refusal is production-visible | COVERED |
| Control tokens — ownership verdict | `work-loop-owner.sh` | consumed as an **exit code** (`:4132-4135`), never as text | admission | existing ownership cases | COVERED |
| Control tokens — lease holder | another process's lease dir | routing uses exact equality (`= dispatch` `:2857`, `= $$` `:757`); raw value reaches prose only | `result_lease_status`, refusal wording | plant_lease cases | COVERED |
| Control tokens — actor capture | the actor (the only actor-controlled input) | parsed as JSON by jq or python3, never `eval`/`source`; fails safe to "no denials"; presence → `die_hop 37` | `permission_denials_in:3666` | O3 denial cases | COVERED — targets are unbounded but reach only stderr and the run log; `TERMINAL_RESULT_REQUIRED` has no denials field, so no actor byte enters result framing |

How the COVERED rows would read differently: each is an equality or a closed set, so an out-of-grammar value cannot be *accepted* — it can only *mismatch*. Plant `outcome=OPERATOR_TAKEOVER` in a CLOSED run's record and `validate_terminal_result_semantics` returns `outcome-mismatch` and the funnel refuses release (case 62b, already red-proven); plant any `run=` value other than this run's and identity returns `run-mismatch` (case 52, whose mutation control m11 deletes exactly that line and makes the case go red); set `terminal_result_version=2` and the parser returns `unknown-version` at line 1 (51b). A 512-character or 5-megabyte value fails at `value-too-long` or `too-large` before any comparison. `recorded_usage` and `actor_session_id` are written as the literal `unavailable` (`:857-862`), so today no actor-supplied value reaches the record at all.

Evidence: **one reachable behavior gap — the argument parser hangs instead of refusing.** Every value-taking option is `--opt) VAR="${2:-}"; shift 2 ;;` — 11 such branches at `dispatch.sh:1436-1446` — inside `while [ $# -gt 0 ]`, under `set -uo pipefail` with no `-e` (`:287`). When such an option is the final argument, `${2:-}` yields empty, `shift 2` fails without shifting, `$#` stays 1, and the loop repeats forever. Smallest hostile example, **not executed against the dispatcher**: `bash dispatch.sh --checkout "$PWD" --task`. The bash semantic it depends on was verified by inspection in an isolated scratch script outside the repository (bash 3.2.57, arm64-darwin): a `--task`-only argv pinned `$#` at 1 across 5 iterations and never terminated. This violates the plan's own Change-set acceptance clause — "Every invalid pre-admission invocation produces clear stderr and a nonzero exit" — in the two respects it can fail without mutating anything: there is no stderr and no exit. The no-actor/no-lease/no-mutation/no-evidence half is satisfied, because the hang precedes all of them.

Earliest, smallest next target in approved-plan order: **an argv arity guard in the parser, with permanent proof for both the arity and the option-name grammar.** One guard covers all 11 branches, it sits at the same pre-admission point cases 58b/63a/63c–63e already assert against, and it closes the one Change set A control-token row that is a real behavior gap plus the one that is only a proof gap. Not implemented here.

Two smaller observations, recorded and not acted on: `too-many-lines` has no committed assertion, but it is unreachable through the current grammar — only 44 keys are defined and every extra line is refused earlier as `duplicate-field`, `unknown-field` or `malformed-line`, so it is defence in depth rather than a gap. And `consume_terminal_result:2187` guards the semantic boundary with "either expectation was stated" rather than "both", which is deliberate (`:2173-2176`) and is already pinned by case 62c.

## Blocker

None.

## Next action

Codex: assess Unit 16's discovery. Three questions. (1) Is the adjudication accepted — that run IDs, outcomes, reason codes and both protocol-version surfaces are already bounded by equality or closed enumeration, so the plan's "strict length and character grammars" clause is satisfied for them by a stronger mechanism and needs no new check? (2) Is the argv arity hang accepted as a real Change set A control-token defect against the "clear stderr and a nonzero exit" acceptance clause, given it was established by inspection and an out-of-repo scratch check rather than by running the dispatcher? (3) Is the proposed next unit — one arity guard plus permanent proof for both arity and the option-name grammar — the right next target, or should the option-name proof gap be split out? Nothing was implemented; only this state file changed.
