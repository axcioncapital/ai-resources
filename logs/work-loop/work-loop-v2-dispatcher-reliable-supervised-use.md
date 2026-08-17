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

Standard. Implementation mode. Unit 24 — make exit-31 deadline evidence truthful

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 23 is accepted at `0a1ea07dd2390ec6464f5309b06ef20604ed1ce9`: an interruption after an actor fork now finalizes and consumes one trusted `INTERRUPTED` result before any releasable lease is released, while early interruption windows remain explicitly deferred. Its evidence exposed one independent and already measured Change set A defect: an unattended exit-31 terminal reached with `--deadline` writes an empty `deadline_remaining_seconds` beside `result_complete=yes` because the fact-producing function is not yet available. Repair that one false terminal fact now; do not reopen the general pre-run boundary.

Dominant deliverable: truthful `deadline_remaining_seconds` evidence on the earliest unattended exit-31 terminal when a whole-run deadline was supplied.
Evidence required in this hop: one targeted red/green exit-31 case whose result is otherwise complete but whose deadline-remaining field changes from empty to a bounded numeric fact, plus one focused load-bearing negative control.
Evidence explicitly deferred: the other five exit-31 sites as separate fixtures; pre-run and pre-launch interruption; usage, infrastructure and lease-refusal result migration; semantic tuple validation; permission-result rows; status and resume; crash and hostile-input matrices; Change sets B–D; live trials; adoption review; the full synchronous regression gate; merge, push, deployment and destructive cleanup.
Primary edit begins after: extend the existing earliest-finalizing-terminal fixture with a finite `--deadline` and quote the current red result—`code=31` and `result_complete=yes` are present, but `deadline_remaining_seconds` is empty rather than a truthful bounded integer.

Required outcome:

- The earliest reachable exit-31 result with a supplied deadline records `deadline_seconds` as supplied and `deadline_remaining_seconds` as a non-negative integer no greater than that deadline.
- The result remains one complete `UNATTENDED_UNAVAILABLE` / code-31 artifact with all Unit 21 worktree facts unchanged and no command-not-found diagnostic.
- Reuse the existing deadline fact owner. Do not add a second clock reader, terminal-only approximation, schema field or parser.
- If the minimum safe implementation is a pure relocation of an existing function, preserve its executable body byte-for-byte and prove no duplicate definition survives. If repository evidence supports another smaller implementation, explain it and prove there is still one owner.
- Preserve the normal actor-timeout clamp and every post-definition caller. This unit changes fact availability at the early terminal; it does not change deadline policy, timeout behavior or the unattended operating boundary.
- Do not claim all exit-31 rows are individually covered. The shared finalizer may justify the implementation across them, but separate fixtures remain deferred.

Check against the repository before editing:

1. Verify `finalize_terminal_result()` still calls `remaining_seconds()` when `DEADLINE_AT` is set, and the earliest exit-31 call still executes before the sole `remaining_seconds()` definition. If either premise is false, hand back.
2. Verify `remaining_seconds()` is one pure fact producer over the existing deadline state and identify every live caller/definition in `dispatch.sh`. If moving or reusing it would change policy or create a second owner, stop.
3. Verify Case 50h remains the smallest focused fixture for the earliest exit-31 terminal and already asserts the accepted worktree/result semantics. Extend that fixture or an equally narrow adjacent row; do not build a new broad matrix.
4. Treat the approved plan's requirement for truthful deadline facts and one production owner as governing. Unit 23's measured defect is verify-first repository evidence, not authority to widen scope.

Required fail-capable evidence:

- Quote the targeted red before the production edit and green after it, showing `outcome`, `code`, `result_complete`, supplied deadline, remaining deadline, and unchanged worktree facts.
- Assert the remaining value's numeric grammar and bounds rather than a timing-sensitive exact second.
- Include one mutation or negative control that makes only the early deadline fact unavailable again and causes the focused assertion to fail while the exit-31 result still finalizes.
- Prove one live `remaining_seconds()` definition and unchanged function body if relocation is used; show directly affected later deadline callers remain green with only focused controls.
- Run shell syntax checks and the focused result/deadline slice only. Do not rerun the full dispatcher suite.
- Report the implementation commit and exact changed paths. Only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state may change; `logs/friction-log.md` remains pre-existing noise and must not be staged or committed.

Capability subset: baseline only — inspect the approved plan and accepted dispatcher/test seams; edit only the two spike files and this state; run focused local checks and shell syntax validation; make the local handback commit. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No external service, production action or operator-reserved capability is needed.

Completion condition: one committed implementation makes the earliest finite-deadline exit-31 result carry a truthful bounded `deadline_remaining_seconds`; the targeted red/green proof and load-bearing control pass; deadline policy and later callers remain unchanged; only the three permitted paths change; and the task returns with `turn: codex`.

Stop and hand back if the defect cannot be reproduced; if one-owner repair requires changing deadline semantics, schema or the unattended operating boundary; if the focused fixture cannot distinguish an empty value from a truthful bounded integer; or if fixing this fact requires covering other terminal families in the same unit. Challenge a false premise rather than widening.

## Latest result

Accepted Unit 23 at `0a1ea07dd2390ec6464f5309b06ef20604ed1ce9` (2026-08-17): a launched-actor SIGINT/SIGTERM terminal now reuses the accepted producer, structural/path/identity validators and consumer to finalize and consume exactly one `INTERRUPTED` result before release. The focused slice moved from `9/13` red to `25/0` green; M29 removed only the new integration and reproduced exit 28 with no result and an improperly released lease; the existing case-27 family remained `141/0`, and directly affected consumer/unprovable controls remained `45/0`.

Accepted boundary: the implementation is guarded by the persistent actor-fork fact, so it covers interruption after a fork, including between-hop timing, and deliberately does not cover interruption before the first fork. Clean teardown releases after trusted consumption; uncertain teardown remains pinned; publication failure transfers to exit 38 with the lease retained. No schema, parser, evidence location or lifecycle reader was added.

Deferred without implementation: pre-first-fork interruption; cosmetic duplicate partial-effect wording on the interruption-to-38 failure path; and the measured finite-deadline exit-31 empty-field defect, which Unit 24 now owns. The full dispatcher suite was not rerun; only the focused and directly affected controls were claimed. Runtime profile reported baseline-only local edits/tests and no external or operator-reserved action; no effective sandbox or network containment was claimed.

Inspected (2026-08-17), against the live files at `0a1ea07d`:

- Claim (1) — the finalizer still calls `remaining_seconds()` when `DEADLINE_AT` is set, and the earliest exit-31 call still runs before the sole definition: **HOLDS**. `dispatch.sh:796` reads `[ -n "${DEADLINE_AT:-}" ] && remaining="$(remaining_seconds)"`, emitted at `:841`. `DEADLINE_AT` is set at `:2690`. The earliest top-level `die 31` was at `:3023`; the sole definition was at `:3454` — 431 lines below the terminal that needs it.
- Claim (2) — one pure fact producer, every caller identified: **HOLDS**. Exactly one definition (`grep -c '^remaining_seconds() {$'` = 1). The body reads `DEADLINE_AT` and the clock, clamps at zero, prints an integer; it mutates nothing and decides nothing, so it carries no policy. Live callers: `:796` (the finalizer), `:3487` (the `effective_timeout` clamp) and `:3862`, `:3873`, `:3894`, `:3915`, `:3925` (budget checks inside the hop loop). Every one except `:796` was already below the old definition, so **no caller needed changing and no second owner was created**.
- Claim (3) — Case 50h is the smallest fixture for the earliest exit-31 terminal: **HOLDS**. It drives that terminal with a fake `claude` reporting `2.1.218` and already asserts the accepted worktree and refusal semantics. It runs *without* `--deadline`, so its `deadline_remaining_seconds` is the honest literal `none` and it cannot see this defect — which is why a narrow adjacent row was added rather than 50h being edited.
- Claim (4) — plan governs: **HOLDS**. Change set A required behaviour 4 requires the result to record deadline facts truthfully; item 2's one-schema rule and § 8's one-production-owner-per-seam rule are what make relocation, rather than a second clock reader, the only admissible repair.

Result: the earliest unattended exit-31 terminal now records a truthful bounded `deadline_remaining_seconds` when a whole-run deadline was supplied. The repair is a **pure relocation** of the single existing fact producer to a position above the terminals that consume it — no new clock reader, approximation, schema field or parser, and no change to deadline policy, the timeout clamp or the unattended boundary.

Evidence:

**The production change is a pure relocation, proved mechanically.** `git diff` is 31 insertions / 8 deletions. The executable delta is exactly six lines out and the same six lines in:

```
-remaining_seconds() {                                                    +remaining_seconds() {
-  if [ -z "$DEADLINE_AT" ]; then printf '%s' 2147483647; return 0; fi    +  if [ -z "$DEADLINE_AT" ]; then printf '%s' 2147483647; return 0; fi
-  local left=$(( DEADLINE_AT - $(date '+%s') ))                          +  local left=$(( DEADLINE_AT - $(date '+%s') ))
-  [ "$left" -lt 0 ] && left=0                                            +  [ "$left" -lt 0 ] && left=0
-  printf '%s' "$left"                                                    +  printf '%s' "$left"
-}                                                                        +}
```

A sorted-content diff over every non-comment, non-blank line of the whole file before and after returns **IDENTICAL across all 1623 lines** — no executable line was added, removed or altered anywhere. A direct `diff` of the function body extracted from `HEAD` against the body at its new position is empty (6 lines, byte-for-byte). Exactly one definition survives, now at `:2928`, above the earliest `die 31` at `:3049`; the remaining insertions are the comment recording the constraint, plus a five-line note left at the old site saying where it went and why the clamp below is unaffected.

**Placement and why not inside Unit 21's block.** The definition sits immediately after `die_hop()` and immediately before the `--unattended` contained-profile section whose six `die 31` sites consume it — adjacent to Unit 21's hoisted repository-state section but not inside it, because that section's comment states its own identity as *repository* state and this is clock state. The new comment carries the same constraint in the same words — *this definition must precede every top-level `die()` that can reach finalization* — so the next reader meets the rule at both positions rather than inferring it from one.

**Red, quoted on the pre-edit dispatcher** (focused slice `16 pass / 2 fail`):

```
FAIL  50i — finalization emits no undefined-function diagnostic
      dispatch.sh: line 796: remaining_seconds: command not found
FAIL  50i — deadline_remaining_seconds is a bounded non-negative integer
      got: '<empty>' — not an integer; the fact producer was unavailable at this terminal
```

Every other row was already green in the red run — `code=31`, `stage=pre-hop`, `actor_launched=no`, `model_request_started=no`, `next_action`, `result_complete=yes`, one result with zero partials, `deadline_seconds=600`, and both Unit 21 worktree facts matching git at 1 foreign / 1 allowed. That is what isolates this defect to the one field.

**Green, same slice, repaired dispatcher: `18 pass / 0 fail`**, with `deadline_remaining_seconds is a bounded truthful integer (599 of 600)`.

**Grammar and bounds, not a timing-sensitive second.** The assertion tests the value is an integer (`case` against `*[!0-9]*`, which is what an empty string fails) and then that `1 ≤ v ≤ 600`. The three failure modes it must separate are all excluded without depending on how long the run took: the empty string fails the grammar, a `0` would falsely claim the budget was spent, and the no-deadline sentinel `2147483647` exceeds the supplied deadline.

**Negative control — M30, case 50j.** It does not delete the function; it moves the definition **back below** the terminal, which is the pre-repair topology exactly. Under the mutant: still exit 31, still one complete result, `deadline_remaining_seconds` **empty again**, and `remaining_seconds: command not found` present — so what the repair changed is the position, not the existence, of the fact producer. The control fails closed on four conditions and asserts all of them: exactly one definition found before the move, exactly one after it, the mutant differs, and the mutant still parses.

**Regression controls, all green against the repaired dispatcher:**

- **Case 28 — `11 / 0`.** The `--deadline` clamp, which is the later-caller path most directly affected: it proves a deadline still clamps the actor timeout and still exits 29 within the arithmetic bound.
- **Case-50 family (50a–50j) — `131 / 0`.** The whole terminal-result surface, including 50h unchanged as the no-deadline sibling and every existing mutation control.
- **Case-27 family — `141 / 0`.** Carries the per-actor timeout path (27e) and the global-deadline path (27f), the two teardown routes that read the clock, plus Unit 23's interruption cases.

`bash -n` clean on both changed files. The full suite was deliberately not rerun, per the brief.

**Scope held.** No claim is made that the other five exit-31 sites are individually covered; they share this finalizer and the relocation serves them, but separate fixtures remain deferred exactly as the brief specifies.

**Runtime profile.** Baseline capability subset only. Edits confined to the two permitted spike files and this state file; focused local test runs and `bash -n`; one local commit. No external service, no model request, no operator-reserved capability, and no effective sandbox or network containment is claimed for this host.

Deferrals recorded, none implemented:

1. **The other five `die 31` sites have no separate fixtures.** Case 50i covers the first (the Darwin platform check); the remaining five reach the same finalizer by the same route, so the repair serves them, but that is an argument from shared code rather than measured evidence.
2. **No test asserts the ordering constraint itself.** Both Unit 21's hoisted section and this definition are protected only by comments; nothing fails if a future edit moves either below a stopping preflight. A structural guard — asserting every top-level `die()` line number exceeds the last finalizer-dependency definition — would close the whole class rather than one field at a time, and is the natural successor to both units.
3. **`effective_timeout()` at the old site is now separated from its comment's "immediately above its first caller" framing.** The replacement note says where the function went, so nothing is unexplained, but the two are no longer adjacent.

## Blocker

None.

## Next action

Codex: assess the exit-31 deadline repair. Pure relocation of the single existing fact producer — sorted-content diff IDENTICAL across all 1623 executable lines, body byte-for-byte, one definition surviving at `:2928` above the earliest `die 31` at `:3049`; focused slice `16/2` red to `18/0` green with the field going from empty to `599 of 600`; M30 proves the position rather than the function is load-bearing by moving the definition back down and recovering the empty field; case 28 `11/0`, case-50 family `131/0` and case-27 family `141/0` as directly affected controls. Decide whether deferral 2 — a structural guard asserting every top-level `die()` sits below every finalizer dependency, which would close this defect class rather than one field at a time — opens as the next unit, or whether the pre-launch interruption windows take priority.

