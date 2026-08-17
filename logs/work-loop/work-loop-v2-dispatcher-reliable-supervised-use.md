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

Standard. Discovery mode. Unit 18 — settle post-hop actor and permission semantics

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 17 is accepted at `e85e76d17a012b0d5b2e57b4ee151ddb6b5dbee0`: case 50c's M1 control again disables the one live die-funnel finalization transfer, fails closed when that target is not unique and valid, and proves the case-50a terminal contract fail-capable without changing production. Change set A still requires truthful terminal fields under the approved plan, and Unit 16 left one semantic uncertainty: after a real carried hop, the result reports `actor=none` and `permission_mode_requested=none` even though `actor_launched=yes`; this discovery settles whether that is the correct contract or a bounded repair is needed, without implementing either answer.

Plan justification: the approved plan's Change set A requires every result to truthfully record actor and permission mode and gives the dispatcher exclusive ownership of those runtime facts. Resolving the meaning of the already-shipped post-hop values is therefore the smallest justified next move before more terminal families are built.

Dominant deliverable: one evidence-backed semantic decision for `actor` and `permission_mode_requested` in successful post-hop carry-one terminal results.
Evidence required in this hop: the accepted Unit 16 four-transition results; the live producer lifecycle for actor and permission-mode variables; every mechanically consuming schema, validator, renderer or test that assigns meaning to those fields; and a concrete verdict that either accepts the current values or specifies the smallest later correction and its fail-capable proof.
Evidence explicitly deferred: implementation of any recommended correction; validator-side outcome-token or semantic-tuple whitelisting; a separate control for case 50a's four planted-lookalike existence/shape assertions; terminal families A–C and M; status and resume; crash and hostile-input matrices; Change sets B–D; live trials; adoption review; merge, push, deployment, and destructive cleanup.

Required outcome:

- Establish from the current producer, consumer and accepted plan what `actor` is intended to mean: the actor currently in flight, the actor that ran, or another bounded concept. Separately establish what `permission_mode_requested` is intended to mean before, during and after a hop.
- Trace where each value is set, cleared, finalized, parsed, validated, rendered and asserted. Distinguish a truthful explicit `none` from lost runtime evidence; do not infer meaning from the field name alone.
- Evaluate all four accepted Unit 16 post-hop transitions — active Claude, active Codex, closed operator and blocked operator — plus the pre-hop operator and dry-run controls. Reuse the accepted Unit 16 results rather than rerunning its broad slice unless repository inspection shows that evidence cannot answer the question.
- Return exactly one technical disposition: **ACCEPT CURRENT CONTRACT** with the supporting semantics and why it satisfies Gate SA, or **CORRECTION REQUIRED** with the exact semantic mismatch, the smallest affected production/test boundary and evidence that a later implementation unit must prove. Do not implement the disposition in this discovery unit.
- Preserve the accepted signal/teardown truth: do not recommend retaining an in-flight actor value after the process is no longer terminable merely to make the terminal result read more naturally. If durable historical actor or requested permission must survive, identify the smallest single-owner fact already available or the precise missing fact without designing a second state store.

Check against the repository:

1. Verify Unit 16's reported premise in `dispatch.sh`: the hop-over path clears the in-flight actor before carry-one finalization, and identify exactly why the same path yields `permission_mode_requested=none`. Record the searched functions and assignments.
2. Inspect `finalize_terminal_result`, `result_actor`, `result_permission_mode_requested`, `consume_terminal_result`, structural/identity validation, status or handoff rendering, and all tests that read either field. State which surfaces merely preserve tokens and which enforce semantics.
3. Compare those findings with the approved plan's Change set A result-field and trusted-field-ownership requirements and with the Work Loop's role meanings. Treat the plan as governing; Unit 16's explanation is accepted evidence but not authority over an unresolved semantic contract.
4. Verify whether any accepted terminal already represents “an actor ran but none is now in flight,” and whether its result uses a separate durable historical fact. Do not widen into a general schema redesign or validator vocabulary work.

Required fail-capable evidence:

- A compact field-lifecycle table covering pre-launch, in-flight, post-hop-before-finalization and terminal result for both fields, with exact producer locations.
- A bounded consumer inventory showing whether changing either value would alter validation, routing, status, recovery or only reporting.
- The accepted four post-hop rows and two over-fire controls mapped to the proposed semantic decision; if current evidence cannot distinguish the alternatives, name the one smallest experiment that would, run only that experiment, and report its observable contrary outcome.
- A plan-conformance argument that could reject the current implementation: name the exact Gate SA requirement that would fail under the losing interpretation.
- Report the discovery commit, changing only this task state file. No production or test file may change; `logs/friction-log.md` remains pre-existing session noise and must not be staged or committed.

Capability subset: baseline only — read/search the approved plan, accepted Unit 16 evidence, dispatcher, focused tests and repository history; run only a bounded local inspection or experiment if the accepted evidence is insufficient; update and locally commit this state file. The baseline deny set is required in full. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed.

Completion condition: the two post-hop fields have one evidence-backed semantic disposition against the approved Gate SA contract, every producer and mechanical consumer that bears on the decision is accounted for, any required correction is bounded but not implemented, no production or test file changed, and the task returns with `turn: codex`.

Stop and hand back if the governing plan and accepted runtime contract materially conflict, the intended meaning requires an operator-owned product or authority decision, the evidence cannot distinguish current truth from lost control evidence without implementation, or the question cannot be resolved without broadening into schema redesign. Challenge a false premise rather than choosing a convenient interpretation.

## Latest result

Inspected (2026-08-17):

- Claim (1): HOLDS — read `dispatch.sh` lines 3740–3967. `CUR_ACTOR` is assigned `before_turn` at line 3764 when the hop opens, and cleared to `""` at line 3933 immediately after the transition table, which is 13 lines above the `--carry-one` block at 3946 and 28 above `finalize_terminal_result 0` at 3961. `actor` is written at line 789 as `tr_kv_or actor "${CUR_ACTOR:-}" none`, so the cleared variable prints the fallback token. The same clear yields `permission_mode_requested=none` through a second, separate route: `result_permission_mode_requested()` (lines 638–645) tests `[ "${CUR_ACTOR:-}" = "claude" ]` at line 641 as its proxy for "the launched actor was Claude", and that test fails once the variable is cleared. Searched `CUR_ACTOR` across the whole file: exactly six occurrences (390 init, 641 guard, 789 producer, 2354 signal handler, 3764 set, 3933 clear) — no other writer.
- Claim (2): HOLDS, with one named surface absent — searched `dispatch.sh` and `dispatch.test.sh` for `result_actor`: **no match in either file.** There is no `result_actor()` function; `actor` is produced inline at line 789 and that inline line is the surface the claim intends. All other named surfaces exist and were read: `finalize_terminal_result` (714–835), `result_permission_mode_requested` (638–645), `validate_terminal_result` (1016–1138), `validate_terminal_result_identity` (1170–1218), `consume_terminal_result` (1930–1940), the read-only `--status` branch (2554–2560).
- Claim (3): HOLDS — read plan §§ *Change set A → Required behavior* 3–4 and *Trusted field ownership* (lines 139–180) and *Gate SA* / success criteria (lines 212–218, 401–404). The plan requires the result to truthfully record `actor` and, "when available", permission mode, and gives the dispatcher exclusive ownership of runtime facts. It is governing; Unit 16's explanation is evidence only.
- Claim (4): HOLDS — searched the record's 41 fields for anything representing "an actor ran but none is now in flight". Three dispatcher-owned facts already do so and survive the clear: `stage=post-hop` and `actor_launched=yes` (both from monotonic `ACTOR_PROCESS_STARTED`, raised once at the sole fork point, line 3307), `hop=1`, and `capture` — `LAST_CAPTURE`, assigned once at `launch_actor` line 3401 as `$LOG_DIR/$RUN_ID.hop$hop.$actor.out` and never cleared (searched `LAST_CAPTURE=`: exactly two writes, 392 init and 3401). The actor that ran is therefore recoverable from the capture path's own basename. Searched the globals block (386–424) for a launched-actor name: none exists; `ACTOR_PROCESS_STARTED` is boolean.

Result: **CORRECTION REQUIRED**, bounded to `permission_mode_requested` only. `actor=none` is accepted as truthful under its own settled meaning; `permission_mode_requested=none` on a live attended Claude carry-one terminal is a false statement about a dispatcher-owned trusted field, and it is false on exactly the one terminal a courier exists to produce.

**Field lifecycle, with exact producer locations.**

| Point in the run | `CUR_ACTOR` | `actor` (789) | `permission_mode_requested` (638–645) |
|---|---|---|---|
| pre-launch, before any hop | `""` (390) | `none` | `none` — guard 639, `ACTOR_PROCESS_STARTED=0` |
| hop opened, pre-fork (3764 → 3781) | `claude`/`codex` | `claude`/`codex` | `none` — guard 639 still 0 (asserted, case 50d) |
| in flight, after the fork (3307) | `claude`/`codex` | `claude`/`codex` | live+claude+attended → `default` (644); simulated → `none` (640); `--unattended` → `none` (643) |
| post-hop, after the clear (3933) → carry-one finalization (3961) | `""` | `none` | `none` — guard 641 alone |

The last row is the whole finding. `actor` reaches `none` through the field's own fallback; `permission_mode_requested` reaches it through a guard that was using `CUR_ACTOR` as a stand-in for a fact `CUR_ACTOR` stops carrying at 3933.

**Consumer inventory — what would change if either value changed.**

- `validate_terminal_result` (1016–1138): enforces key-set membership against `TERMINAL_RESULT_REQUIRED`, presence, no duplicates, ≤512-byte values, no tab/CR, `terminal_result_version=1`, the exact `schema`, and the `result_complete=yes` sentinel. It applies **no value grammar to either field**. Token-preserving only.
- `validate_terminal_result_identity` (1170–1218): compares `task`, `checkout`, `run` only. Neither field participates.
- `consume_terminal_result` (1930–1940): calls the two above; refuses via `die_terminal_unprovable`. Inherits their indifference to both values.
- `--status` (2554–2560): reads the **run log**, not the result — `grep -E '^hop=[0-9]+ actor='`, whose line is written at 3766 from `before_turn` and truthfully names the actor that ran. Unaffected.
- Tests: `dispatch.test.sh` asserts `permission_mode_requested` at lines 5025 and 5041 only — both are case 50d **pre-fork** rows. Case 60a (line ~7116) asserts `actor=none` post-hop. Searched the file for any post-hop assertion on `permission_mode_requested`: **none exists**, which is why this survived Unit 16.
- Repository-wide: searched every `*.sh` and `*.md` outside the spike for `permission_mode_requested` and for any terminal-result reader — the only hits are this state file's own prose. No helper, validator, courier, hook or command reads either field.

**Verdict: changing either value alters reporting only.** No validation, routing, status, recovery or lease behaviour depends on either, so the correction below is contained to the producer and its proof.

**The four accepted rows and the two over-fire controls, mapped.**

| Accepted row | `actor` | `permission_mode_requested` as shipped | Under the correction |
|---|---|---|---|
| 60b1 claude→codex (`CARRY_ONE_COMPLETE operator-carry-turn-to-codex`) | `none` — accepted | `none`; **false in live mode** | `default` |
| 60b2 codex→claude (`…operator-carry-turn-to-claude`) | `none` — accepted | `none` — truthful (Codex requests no mode) | unchanged |
| 60b3 claude→operator/CLOSED (`…none-task-closed`) | `none` — accepted | `none`; **false in live mode** | `default` |
| 60b4 codex→operator/BLOCKED (`…operator-answer-the-blocking-question`) | `none` — accepted | `none` — truthful | unchanged |
| 60c control — pre-hop operator terminal | `none`, `stage=pre-hop`, `actor_launched=no` | `none` — truthful | unchanged |
| 60c control — `--carry-one --dry-run` | `none`, nothing launched | `none` — truthful | unchanged |

The Unit 16 slice was **not** rerun, and repository inspection is why: every 60-series row runs under `--actor-cmd`, so `MODE=simulated` and guard 640 returns `none` before guard 641 is ever consulted. Rerunning that slice cannot distinguish the two candidate meanings — it would reconfirm a `none` produced for an unrelated and truthful reason.

Evidence: one bounded experiment, the smallest that separates the alternatives. `result_permission_mode_requested` was extracted verbatim from `dispatch.sh` into a scratch harness (production and tests untouched) and evaluated with every input held constant at the live attended Claude values — `ACTOR_PROCESS_STARTED=1`, `MODE=live`, `UNATTENDED=0` — varying only `CUR_ACTOR`:

```
live in-flight (CUR_ACTOR=claude) -> default
live post-hop  (CUR_ACTOR="")     -> none
RESULT: the clear alone flips default -> none
simulated in-flight               -> none
```

It could have failed and did not: had both live rows printed the same token, the cause would have lain elsewhere and the disposition would have been ACCEPT. The contrary outcome it rules out is exactly that. The corroborating asymmetry needs no run at all and is stronger still: `die_hop` at 3885, 3907, 3914, 3917 and 3921 all sit **above** the clear at 3933, so the identical live Claude launch reports `permission_mode_requested=default` when the hop fails and `none` when it succeeds. A field whose value tracks whether the run succeeded is not recording what was requested.

**Plan-conformance argument, stated so it could reject the current implementation.** Change set A required behavior 4 obliges the result to truthfully record "permission mode … when available", and *Trusted field ownership* makes permission approval a dispatcher-exclusive runtime fact. The schema keeps `none` and `unavailable` as distinct answers on purpose — `permission_mode_effective` is written `unavailable` at line 806, and `owner_declaration` (656–659) states the three-answer distinction explicitly — so `none` asserts *established and absent*, not *unobtainable*. On a live attended Claude hop the mode is available and was requested: `--permission-mode default` is in the argv handed to the child, added under P0-F precisely because the child would otherwise inherit `bypassPermissions`. Under the losing interpretation — accept the current values — the courier's only success artifact denies the supervision that the supervised-use claim rests on, and Change set A.4 fails for the `CARRY_ONE_COMPLETE` terminal class while Gate SA's "every terminal class produces exactly one valid result" still passes structurally. That is the exact gap this discovery closes.

**Smallest affected production/test boundary for the later implementation unit.** One fact is missing and no store is needed for it: which actor the observed fork was for. Record it in one monotonic global set beside `LAST_CAPTURE` at `launch_actor` line 3401 — the single entry every launch path funnels through — and have guard 641 read that instead of `CUR_ACTOR`. Nothing else moves: no schema change, no new result field, no second parser, and **the clear at 3933 stays byte-identical**, so the signal handler keeps its true reading of what is terminable. Line 3401 runs before the fork, so the existing first guard at 639 must stay first and unchanged; it is what keeps the four pre-fork die paths reporting `none`.

Evidence a later implementation unit must prove, all fail-capable:

1. A live-mode post-hop carry-one Claude row reports `permission_mode_requested=default`, and the Codex row still reports `none`.
2. Case 50d's two pre-fork rows stay `none` — the false-launch regression control.
3. `--unattended` Claude carry-one stays `none` — the contained profile carries no mode of its own.
4. A mutation control neutralising the new global's single assignment drives the live post-hop Claude row back to `none`, red→green, proving the fix is load-bearing rather than incidentally satisfied.
5. Case 60a's `actor=none` is unchanged and `dispatch.sh` line 3933 is byte-identical, proving the repair did not buy its reading by weakening the accepted teardown invariant.

Nothing was implemented. `git diff` over `dispatch.sh` and `dispatch.test.sh` is empty; only this state file changed.

Candidate deferrals noticed and not implemented: (a) `actor` remains the only required field whose value depends on how the run ended rather than on what happened — giving "the actor that ran" its own field would be a schema change and is out of scope here and unnecessary, since `stage`, `actor_launched`, `hop` and `capture` already carry the fact; (b) no test asserts `permission_mode_requested` at any post-hop terminal, which is the coverage gap that let this reach Unit 18 — item 1 above closes it; (c) the brief names a `result_actor` surface that does not exist, so a later brief citing it should name line 789 instead.

## Blocker

None.

## Next action

Codex: assess the Unit 18 discovery. The disposition returned is `CORRECTION REQUIRED`, bounded to `permission_mode_requested` on live attended Claude post-hop terminals, with `actor=none` accepted as truthful under its settled in-flight meaning. Decide whether to open the bounded implementation unit on the single-global repair at `launch_actor` line 3401 plus guard 641, carrying the five proof obligations above, or to reframe.
