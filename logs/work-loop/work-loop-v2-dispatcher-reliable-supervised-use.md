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

Standard. Discovery mode. Unit 15 — resolve successful carry-one terminal semantics

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 14 is accepted at `420a83f2ca8ef53432a21d90edffe88fada2fa2d`: every admitted dry-run now reports one truthful dry-run-specific outcome and next action across lifecycle states, while real completion and operator-takeover meanings remain unchanged. The next admitted code-zero boundary is `--carry-one`, whose accepted post-hop checks currently end with `release_lock; exit 0` and no terminal result; before integrating that seam, resolve what one truthful result must say across every reachable validated post-hop transition and how the existing single vocabulary owner can express it without a second lifecycle reader.

Dominant deliverable: one evidence-backed decision on the truthful successful carry-one terminal-result contract and the smallest next implementation boundary.
Evidence required in this hop: a compact map of every reachable validated carry-one post-hop transition and the trusted facts available at its terminal seam; a plan-grounded outcome/next-action decision; the exact durable finalization/consumption/release order required there; and exactly one fail-capable next Implementation-mode unit.
Evidence explicitly deferred: every dispatcher and test edit; carry-one terminal-result integration itself; validator-side outcome-token or semantic-tuple whitelisting; terminal families A–C and M; status rendering; resume; crash-boundary recovery beyond the carry-one seam; hostile-input and full regression matrices; Change sets B–D; live trials; adoption review; merge, push, deployment, and destructive cleanup.

Named unknown: after one actor hop passes all accepted post-hop state, Git, proof, path, ownership, and transition checks, what single code-zero `outcome` and bounded `next_action` truthfully describe the carry-one run for each reachable `before_turn -> after_turn` / lifecycle combination, and can that contract be produced and consumed before release through the accepted terminal-result seam without duplicating lifecycle or transition semantics?

Governing authority and settled evidence:

- The content-bound-approved plan governs Change set A items 2–8: one versioned schema, exactly one truthful result per admitted terminal class, one exact producer/consumer path, expected evidence plus a role-owned transition, finalization before safe release, and one production owner under § 8.
- Units 5–14 are accepted. Their producer, validators, consumer, identity binding, operator-terminal finalization, dry-run finalization, exit-38 pin behavior, and code-zero mode-first vocabulary are settled and must not be redesigned or broadly re-proved.
- Unit 14's `102/0`, syntax checks, and M26 control are accepted and must not be rerun. Its carry-one observation remains verify-first repository reality: after accepted post-hop validation, the branch reports the turn movement, releases the lock, and exits zero without finalization or consumption.
- Codex's framing decision: this is Discovery because carry-one's truthful semantic tuple is not yet settled. Choosing a token or production input by intuition would either recreate `UNCLASSIFIED` or make implementation and semantic discovery one oversized unit.

Check against the repository:

1. In `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, inspect only the carry-one argument/setup path, the accepted post-hop validation and transition region, the current carry-one terminal branch, `result_outcome()`, `result_next_action()`, the terminal-result producer/consumer, and expected-identity validation. Establish which dispatcher-owned variables are authoritative and still in scope at the carry-one terminal seam; do not infer a fresh lifecycle state from the task body.
2. Map each actually reachable validated carry-one transition from the accepted transition table: `codex -> claude`, `claude -> codex`, `codex -> operator`, and `claude -> operator`. For each, establish the validator classification available after the hop, actor/model-start facts, stage, mode/carry-one signal, outcome and next action today, whether a result is produced and consumed, and whether release occurs before evidence exists. Mark any listed transition unreachable with the exact guard that proves it; do not manufacture fixtures for impossible states.
3. Distinguish the run's outcome from the task's lifecycle. Decide whether one carry-one-specific outcome applies to all successful validated hops, whether an operator-terminal hop must retain `COMPLETED` / `OPERATOR_TAKEOVER`, or whether another bounded distinction is required by the plan. Likewise decide whether `next_action` must name the validated next actor/operator condition or can truthfully use one carry-one completion token. Explain which trusted post-hop fact owns each distinction.
4. Establish the smallest safe ordering at the current seam: expected identity, finalization, exact-result consumption, teardown proof, release or truthful exit-38 pin. State whether the accepted finalizer/consumer can be reused directly and whether the existing vocabulary functions need one new input or branch. Do not design crash recovery beyond what this seam requires.
5. Inspect only the focused carry-one, operator-terminal, dry-run, result-validator, and exit-38 tests needed to package the next unit. Determine the one targeted failing case and the minimum regression/mutation evidence; do not run the accepted suites in this discovery unit.

Required fail-capable evidence:

- cite exact bounded source regions for carry-one setup, post-hop validation/transition, terminal exit, vocabulary ownership, producer, consumer, identity validator, and release/pin behavior;
- provide one compact transition table whose entries would differ if lifecycle class, next actor, stage, outcome, next action, model-start facts, or release ordering were read differently than reported;
- quote the exact approved-plan clauses that settle semantic truth and durable ordering, then give one explicit conclusion rather than a menu of equally preferred designs;
- state whether the single-owner and narrow-helper conditions in plan § 8 are satisfied by the proposed boundary, and why;
- recommend exactly one next Implementation-mode unit with one dominant deliverable, one targeted failing case, exact permitted source/test paths, proportional regression and mutation evidence, and explicit deferred work; and
- report the discovery commit and prove it changes only this task state file. `dispatch.sh`, `dispatch.test.sh`, and `logs/friction-log.md` must remain untouched and uncommitted.

Capability subset: baseline only — read/search the approved plan, accepted Unit 14 state/history, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, and its focused test file; update and locally commit only this task state file. The baseline deny set is required in full. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed.

Completion condition: the named carry-one semantic unknown is resolved from live repository and approved-plan evidence; the handback maps every reachable validated post-hop class, fixes one truthful outcome/next-action contract and durable ordering, recommends exactly one properly packaged implementation unit, changes no dispatcher or test code, and returns with `turn: codex`.

Stop and hand back if the approved plan cannot determine the semantic bar, trusted post-hop identity or lifecycle facts are unavailable at the seam, the result would require a second lifecycle/transition parser or material architecture change, the next action requires an operator-owned product or risk choice, or any source edit appears necessary to answer the question. Challenge the framing rather than guessing or implementing through uncertainty.

## Latest result

Inspected (2026-08-17):

- Claim (1): HOLDS — read `dispatch.sh` carry-one setup (`311` `CARRY_ONE=0`, `1248` flag parse, `1275` `MAX_HOPS=1`), the accepted post-hop validation/transition region (`3794`–`3886`), the carry-one terminal branch (`3903`–`3912`), the code-zero vocabulary owner (`502`–`593`), the producer (`686`–`807`), the consumer (`1887`–`1899`), the identity validator (`1142`), and the release/pin owners (`1800`–`1861`, `1904`). Dispatcher-owned facts still live and in scope at the seam: `CARRY_ONE`, `MODE` (assigned once at `1294`–`1297`), `ACTOR_PROCESS_STARTED` (set only at the single fork, `3264`), `CUR_HOP`/`CUR_ACTOR` (`3721`, cleared `3890`), and `ST_TURN`/`ST_CLASS` re-established by the post-hop `validate_state` at `3795` from the canonical validator (`2836`–`2865`). No lifecycle fact is inferred from the task body.
- Claim (2): HOLDS — all four listed transitions are reachable and none is guarded out. Verified by live probe over the real dispatcher (four sandboxes, `--carry-one` plus `--actor-cmd`), transcript below.
- Claim (3): HOLDS — the run's outcome and the task's lifecycle are separable at the seam: `state_class` and `turn_at_terminal` are already required schema fields (`853`), so naming the run in `outcome` loses no lifecycle fact.
- Claim (4): HOLDS — the accepted finalizer and consumer are reusable at this seam unchanged; the two fail-closed exits are not (see Finding F1). `report_teardown` is called only from the signal handler (`2323`) and the timeout kill path (`3278`), so a normally-exited actor needs no teardown proof here — the same position the accepted operator terminal occupies.
- Claim (5): HOLDS — searched `dispatch.test.sh` for `carry.one\|carry_one\|CARRY_ONE`; carry-one is exercised at cases 23–26 (`1806`–`1900`) and used as a one-hop bound by ~40 later cases. No case asserts a terminal result at the carry-one exit, and no case asserts its absence. The accepted suites were not run.

Result: the named unknown is resolved. **One truthful outcome, `CARRY_ONE_COMPLETE`, covers every reachable validated carry-one post-hop transition; `next_action` stays keyed on the canonical post-hop `ST_CLASS`.** The seam today is the dispatcher's only post-hop terminal that produces no durable evidence at all.

**Transition map (live probe, 2026-08-17).** Each row would read differently if lifecycle class, next actor, stage, launch facts, or release ordering were other than reported.

| # | Transition | Post-hop `ST_CLASS` | Stage / launch facts | Outcome today | `next_action` today | Result artifact | Release before evidence |
|---|---|---|---|---|---|---|---|
| 1 | `claude -> codex` | `ACTIVE_CODEX` | post-hop, actor=claude, launched=yes, hop=1 | *(vocabulary never called; would fall to `UNCLASSIFIED`, `533`)* | *(would be `operator-read-run-log`, `574`)* | **ABSENT** | **yes** |
| 2 | `codex -> claude` | `ACTIVE_CLAUDE` | post-hop, actor=codex, launched=yes, hop=1 | *(as above — `UNCLASSIFIED`)* | *(as above)* | **ABSENT** | **yes** |
| 3 | `claude -> operator` | `CLOSED` | post-hop, actor=claude, launched=yes, hop=1 | *(would borrow `COMPLETED`, `531`)* | *(would borrow `none-task-closed`)* | **ABSENT** | **yes** |
| 4 | `codex -> operator` | `BLOCKED_OPERATOR` | post-hop, actor=codex, launched=yes, hop=1 | *(would borrow `OPERATOR_TAKEOVER`, `532`)* | *(would borrow `operator-answer-the-blocking-question`)* | **ABSENT** | **yes** |
| C | control: turn already `operator`, no hop | `CLOSED` | **pre-hop, actor=none, launched=no, hop=0** | `COMPLETED` | `none-task-closed` | **PRESENT** | no — finalized and consumed first |

Rows 1–4 all exited `0` with `runs/` holding only the hop capture, the process-tree marker and the run log. Row C is not a carry-one terminal at all: `--carry-one` over an already-`operator` turn reaches the accepted operator terminal at `3661`–`3670` before any hop, and that is what makes `CARRY_ONE=1` alone an unsafe branch condition.

**Evidence: what the probe returns now, and what it would have returned otherwise.**

```
T1 claude -> codex   exit=0  RESULT ARTIFACT: ABSENT   runs/: *.hop1.claude.out *.hop1.claude.tree *.log
T2 codex -> claude   exit=0  RESULT ARTIFACT: ABSENT   runs/: *.hop1.codex.out  *.hop1.codex.tree  *.log
T3 claude -> operator exit=0 RESULT ARTIFACT: ABSENT   runs/: *.hop1.claude.out *.hop1.claude.tree *.log
T4 codex -> operator  exit=0 RESULT ARTIFACT: ABSENT   runs/: *.hop1.codex.out  *.hop1.codex.tree  *.log
C  already operator   exit=0 RESULT ARTIFACT: PRESENT
     outcome=COMPLETED  code=0  mode=simulated  stage=pre-hop  actor=none
     actor_launched=no  hop=0  turn_at_terminal=operator  state_class=CLOSED
     next_action=none-task-closed  result_complete=yes
```

The control row is what makes rows 1–4 fail-capable: the same dispatcher, the same flag, the same evidence root and the same exit code do produce a complete record when the terminal is the accepted one, so `ABSENT` above is this seam's behaviour and not a broken sandbox.

**Decision, and the trusted fact that owns each distinction.**

1. **`outcome` names the run, not the task: one value, `CARRY_ONE_COMPLETE`, on all four rows.** The owning fact is `CARRY_ONE` plus `ACTOR_PROCESS_STARTED` — both dispatcher-owned, both settled before the seam. This is Unit 14's accepted precedent applied one branch over: a dry-run over a closed task is `DRY_RUN_COMPLETE`, not `COMPLETED`, because what the run did precedes what the task is. Rows 3 and 4 must not keep `COMPLETED` / `OPERATOR_TAKEOVER`: those are the full-loop terminals' symbols, and a courier reading them cannot tell a run that carried one hop by design from a run that drove the task to its end. Nothing is lost — `state_class` and `turn_at_terminal` are required fields and carry `CLOSED` / `BLOCKED_OPERATOR` exactly.
2. **`next_action` keeps the lifecycle split, because the required action genuinely differs.** The owning fact is the canonical post-hop `ST_CLASS`. Rows 1–2 need a carry-specific token naming the actor that owns the next move (`carry-one-hop-carried-next-turn-claude` / `-codex`); rows 3–4 keep the two accepted operator tokens unchanged, because "the task is closed" and "a person must answer this" are the same instructions a full loop would give and are the distinction code `0` was split to protect. Collapsing all four to one completion token would re-hide the unanswered question.
3. **The branch condition is `CARRY_ONE=1` *and* `ACTOR_PROCESS_STARTED=1`, inside `0)` and after the existing dry-run branch.** Row C is the reason both halves are load-bearing: `CARRY_ONE` alone would relabel a genuine pre-hop operator terminal as a carried hop. Order matters — `dry-run` must still win, so `--carry-one --dry-run` (case 26) stays `DRY_RUN_COMPLETE`. `MODE` at this seam is `live` or `simulated` only: `dry-run` exits at `3607` before the loop and `status` at `2524`.
4. **Durable ordering at the seam, in this exact order:** say the carry lines (unchanged) → `finalize_terminal_result 0` or fail closed → `consume_terminal_result` → say the result path → `release_lock` → `exit 0`. That is byte-for-byte the accepted operator seam's order at `3661`–`3670`. Expected identity needs nothing new: `consume_terminal_result` already derives the promised path from `LOG_DIR_ABS` and `RUN_ID` and composes the three accepted validators against live dispatcher variables. Teardown proof adds nothing here — the actor exited on its own, which is why `report_teardown` is not on this path or on the accepted operator path.

**Finding F1 — the two fail-closed exits cannot be reused verbatim.** `die_terminal_unprovable` (`1802`) and `die_terminal_untrusted` (`1818`) both open "the run reached a real operator terminal", which is false at the carry-one seam. Calling them there would make the exit-38 message lie about which terminal was reached. The fix inside single ownership is one optional label parameter on each, defaulting to the current wording so the operator seam's message is unchanged — not a second pair of carry-one twins, which would duplicate the pin-and-exit logic and create a second owner.

**Plan clauses that settle this.** § 5 Change set A item 3 requires exactly one atomically finalized terminal result for every listed class including "operator takeover" and "successful completion"; item 5 requires "one exact run-bound producer/consumer evidence path"; item 6 states "A zero actor exit, commit, artifact, prose claim, or file appearance cannot independently advance the Work Loop. Progress requires the expected terminal evidence plus a valid role-owned state transition"; item 7 makes missing terminal evidence "an operator blocker … never reconstructed from a commit, report, event, or narrative"; Change-set acceptance requires "Every terminal class produces exactly one valid result." Durable ordering item 6 requires "release a lease only after the terminal result exists and teardown is proven safe." Rows 1–4 violate all of these today: the run releases its lease and exits `0` on a hop whose only evidence is prose in a log.

**Plan § 8 conditions.** Single production owner: preserved — `result_outcome()` / `result_next_action()` remain the only code-zero vocabulary, gaining one branch each ahead of the existing lifecycle case, and `finalize_terminal_result` / `consume_terminal_result` remain the only producer and consumer. No second lifecycle reader: the branch reads `ST_CLASS` as set by the canonical validator and two dispatcher-owned flags; it parses nothing. No validator change is required — inspected `validate_terminal_result` (`988`–`1140`): values are constrained by key membership (`1074`), duplicate detection, charset and length only; `outcome` and `next_action` have no value whitelist, so a new token is accepted as written. The narrow-helper clause is not triggered: nothing here is a pure transition that cannot be tested through the dispatcher.

**Recommended next unit — Unit 16, Implementation mode.**

- Dominant deliverable: the carry-one terminal seam finalizes and consumes exactly one truthful `CARRY_ONE_COMPLETE` result before either lease is released.
- Primary edit begins after: a targeted failing case in which a carry-one `claude -> codex` run exits `0` and no `*.result` exists under its evidence root — red today on the artifact's absence, as row 1 above shows.
- Evidence required in this hop: the four transition rows each produce one valid record with `outcome=CARRY_ONE_COMPLETE`, `stage=post-hop`, `result_complete=yes` and the four decided `next_action` values; row C still reports `COMPLETED` / `none-task-closed` at `stage=pre-hop` (over-fire control); `--carry-one --dry-run` still reports `DRY_RUN_COMPLETE` (Unit 14 control); an unwritable evidence root at the carry-one seam exits `38` with both leases pinned, the next dispatcher refused `17`, and the message naming the carry-one terminal rather than an operator one; one mutation control (M27) deleting only the two new vocabulary branches restores `UNCLASSIFIED` on rows 1–2 and the borrowed symbols on rows 3–4; pre-edit and post-edit counts on the focused slice; clean shell syntax.
- Evidence explicitly deferred: validator-side outcome-token or semantic-tuple whitelisting; terminal families A–C and M; status rendering; resume; crash-boundary recovery beyond this seam; hostile-input and full regression matrices; Change sets B–D; live trials; adoption review; merge, push, deployment, destructive cleanup.
- Permitted paths: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, its focused test file, and this state file. Nothing else.

Candidate deferral noticed and not implemented: no focused case currently asserts that `--carry-one` over an already-`operator` turn takes the pre-hop operator terminal rather than the carry-one branch. Unit 16 adds it as an over-fire control, so it is folded in rather than carried separately.

Evidence pointer: this handback commit, which changes only this state file.

## Blocker

None.

## Next action

Codex: assess the resolved carry-one semantic contract — one `CARRY_ONE_COMPLETE` outcome across all four reachable transitions with `next_action` keyed on the canonical post-hop `ST_CLASS`, the `CARRY_ONE` + `ACTOR_PROCESS_STARTED` branch condition proved necessary by the pre-hop control row, the finalize/consume/release ordering copied from the accepted operator seam, and Finding F1's label parameter on the two fail-closed exits. Then either frame Unit 16 as recommended above or reframe the boundary.
