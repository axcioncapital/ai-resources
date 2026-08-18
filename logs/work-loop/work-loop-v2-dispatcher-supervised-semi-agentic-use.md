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

Standard. Implementation mode. Unit 14 — make failed revalidation facts truthful

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 13 is accepted at `e21d2e1cbd51663459f9915bded20982a4f78c6f` for the proof it completed: representative permanent result coverage now exists for malformed terminal `26`, permission denial `37`, both materially distinct budget-`29` lifecycle shapes, and every post-hop code-`15` field except the two it correctly refused to pin. Its focused evidence was `143/0`; the shared-funnel scratch cut failed every intended result assertion while preserving all expected exits; no permanent mutant or production change was added. The representative treatment is accepted because Claude traced the sibling fixtures to their shared producers and retained structural controls instead of duplicating full blocks.

The handback also established a production defect: when a post-hop `validate_state` call fails before returning a new classification, `turn_at_terminal` and `state_class` retain the successful pre-hop reading. In case 49 that makes a `BAD_TURN/15` result say `claude` and `ACTIVE_CLAUDE`, even though the post-hop validator produced no legal classification. This is not optional polish: approved Change set A item 4 and Gate SA require truthful terminal before/after facts. The smallest repair is to prevent any failed revalidation from reporting a prior validation's values, then pin the truthful unavailable values in the already-existing representative case.

Dominant deliverable: make failed state revalidation unable to publish stale `turn_at_terminal` or `state_class` facts.
Evidence required in this hop: the two missing case-49 assertions fail against current production and pass after the narrow repair; the existing focused case 49 remains green; syntax checks for the changed shell files; and a diff confined to the dispatcher, the focused case-49 assertions/comments, and this state file.
Evidence explicitly deferred: the unreachable-or-defensive `launch_actor` code-15 site unless inspection disproves that characterization; the three uncovered evidence-location refusal branches; other identifier/token bounds; all other Change set A work; the full dispatcher suite; Change sets B–D; live trials; final regression; adoption review; historical-probe cleanup; merge, push, deployment and destructive cleanup.
Primary edit begins after: add the two case-49 assertions for `turn_at_terminal=unavailable` and `state_class=unavailable`, and quote their focused failure against the current committed dispatcher while the existing code-15 exit and other assertions still pass.

Required outcome:

- A failed `validate_state` observation must not leave a previous successful observation available to the terminal-result producer. Preserve the canonical validator as the only lifecycle authority; add no parser, lifecycle state, recovery state, or generalized helper.
- Keep successful validation behavior unchanged. Initial validation failures must remain truthful, and post-hop case 49 must finalize exactly one `BAD_TURN/15` result with `turn_at_terminal=unavailable` and `state_class=unavailable` while preserving its already-accepted actor, hash, effect, ownership and lease facts.
- Make the minimum production edit that establishes that invariant. Clearing stale observation variables at the correct validation boundary is the current technical hypothesis, not a mandated mechanism; verify it against the live control flow before editing.
- Replace case 49's deliberate non-assertion comment with the two permanent assertions and only the explanation still useful after the repair. Do not broaden this into proof for another exit site or class.

Check against the repository:

1. Verify Unit 13 commit `e21d2e1c…` changes only this state file and `dispatch.test.sh`, carries the reported focused proof, and leaves production unchanged. Treat its accepted result assertions and structural controls as settled; do not rerun the other Unit 13 cases.
2. Verify `validate_state` assigns `ST_CLASS`/`ST_TURN` only after a successful validator return, that the loop invokes it once before launch and again after actor exit, and that a failing later call can currently expose the earlier values to terminal finalization. If any part is false, hand back the narrower finding rather than editing.
3. Verify the proposed unavailable values are truthful for every failure point affected by the chosen repair and do not erase a fresh failed observation that the result contract should retain.
4. Verify the `launch_actor` default code-15 site is unreachable from validated `ST_TURN` values or hand back that distinction; do not add unrelated proof or production behavior for it in this unit.

Required fail-capable evidence:

- Quote the before-edit focused case-49 total showing exactly the two new truthfulness assertions red while its existing terminal proof and exit remain green.
- Quote the after-edit focused case-49 total with both new assertions and all existing case-49 assertions green.
- Run `bash -n` on `dispatch.sh` and `dispatch.test.sh`. Do not run the full suite or another Unit 13 fixture.
- Confirm the committed diff contains only `dispatch.sh`, the focused case-49 test/comment change, and this state file; leave `logs/friction-log.md` unstaged.

Capability subset: baseline only — inspect the approved plan, accepted Unit 13 result, dispatcher validation/result control flow and case 49; edit the dispatcher and focused test; run local syntax and the one focused case; and commit the implementation, test and task state. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No model launch, authentication attempt, network, external service or operator-reserved capability is permitted.

Completion condition: one committed narrow repair makes failed revalidation facts truthful, case 49 permanently proves both unavailable fields without losing its accepted terminal proof, no unrelated behavior or machinery is added, and the state returns with `turn: codex`.

Stop and hand back if the stale values are intentional under a governing contract, the repair would erase a distinct truthful observation, the affected surface is broader than this invariant, or the change requires another lifecycle reader, recovery state or generalized framework.

## Latest result

Inspected (2026-08-18):

- Claim (1): HOLDS — `git show --stat e21d2e1c…` lists exactly this state file and `dispatch.test.sh`; `git diff HEAD~1 HEAD -- dispatch.sh logs/scripts/` is empty, so production was untouched. Unit 13's other cases were not rerun.
- Claim (2): HOLDS in all three parts. `validate_state` (dispatch.sh 3506) reaches `ST_CLASS="$out"` only on validator rc `0`; `ST_TURN` is set only inside the classification `case` below it; every earlier exit is a `die`. The function is called at three sites — once before the loop (4070), once at the top of every iteration (4192), and once after each actor exits (4398) — so a later call has an earlier successful reading behind it. That the earlier reading reaches finalization was not inferred: Unit 13 observed it in case 49's record as `turn_at_terminal=claude` / `state_class=ACTIVE_CLAUDE`, and this unit reproduced it as a focused red before editing.
- Claim (3): HOLDS — `unavailable` is truthful at every failure point the clear affects (missing file, unreadable file, absent validator, identity mismatch, BAD_BODY, and a nonzero validator return), because none of them yields a classification. The one observation that must survive does: the unrecognised-classification `die 15` fires *after* `ST_CLASS="$out"`, so it still reports what this call's own validator printed. That is a fresh failed observation, not a stale one, and the repair deliberately leaves it standing.
- Claim (4): HOLDS — the `launch_actor` default `die 15` is unreachable from validated values. Both call sites (4341, 4377) pass `$before_turn`, which is `ST_TURN` after the `operator` branch at 4194 has already stopped the run, so only `claude` and `codex` reach the `case`, and both have arms. It is defensive. No proof or behaviour was added for it, as the brief defers.

Packaging lines: all four present for an Implementation-mode unit; `Dominant deliverable:` names one deliverable; `Evidence explicitly deferred:` is populated.

Result: a failed state validation can no longer publish a previous validation's reading. `validate_state` clears `ST_TURN` and `ST_CLASS` on entry — two assignments and their explanation, and nothing else in production changed. Case 49 now permanently proves both fields as `unavailable` alongside the terminal facts it already carried.

- **The repair is the move `launch_actor` already makes one function over.** It clears `LAUNCHED_ACTOR` on entry so a stop in its four pre-fork `die()` paths cannot answer with the previous hop's fork; `validate_state` now clears its two observation variables for exactly the same reason. No parser, no lifecycle state, no recovery state, no helper — the canonical validator remains the only lifecycle authority.
- **Successful validation is unchanged**, since both variables are reassigned before the function returns. `--status` is unaffected: it reads frontmatter through `fm_value` and never calls `validate_state`.
- **Case 49's non-assertion comment is replaced** by the two assertions in the record's own field list, plus the explanation that still earns its place — why this case and no other in the suite can catch the defect. Case 4's pre-hop code 15 asserts the same two values and passes either way, because nothing has run there to leave a reading behind; only a terminal reached *after* a successful validation distinguishes a cleared variable from an uncleared one.

Evidence:

- **Before the repair, on the committed dispatcher: `pass=26 fail=2`.** The two failures are exactly the new assertions — `turn_at_terminal=unavailable` got `claude`, `state_class=unavailable` got `ACTIVE_CLAUDE` — while the exit-15 assertion and every existing case-49 fact stayed green.
- **After the repair: `pass=28 fail=0`,** same focused case, same runner.
- **One check beyond the brief, and why.** Cases 2–4 were also run: `pass=80 fail=0`. They are the *other* terminals produced by the function this unit edited, they are Unit 12 fixtures rather than Unit 13 ones, and they cost seconds. A production change to a shared function whose only proof is the one terminal it was aimed at leaves its siblings unevidenced. The full suite was not run.
- `bash -n` clean on both `dispatch.sh` and `dispatch.test.sh`.
- Committed diff: `dispatch.sh` (+29, all inside `validate_state`), `dispatch.test.sh` (case 49 only), and this state file. `work-loop-state.sh`, `work-loop-lease.sh` and `work-loop-owner.sh` byte-identical to HEAD. `logs/friction-log.md` left unstaged.

## Blocker

None.

## Next action

Codex: assess Unit 14 — the stale-observation invariant, the two case-49 assertions, and the before/after focused counts.

Two things worth your verdict rather than my assumption:

1. **The clear covers every `validate_state` failure, not only the post-hop one case 49 exercises.** The initial call's terminals — codes 13, 14, 26 and the pre-hop 15 — already recorded `unavailable` and are unaffected in value; cases 2–4 confirm that at 80/0. But a *later*-iteration failure at the loop-top call (4192) is now also covered, and that shape has no fixture. It is the same invariant and the same two lines, so I did not add one.
2. **The unrecognised-classification `die 15` still publishes `state_class=<the token the validator printed>`.** That is deliberate under premise 3 — a fresh failed observation the record should keep — and it is unproved: no fixture makes the validator return an unrecognised classification. Flagged rather than built, since a fixture for it needs a stub validator and that is a scenario, not an assertion.

**Deferrals noticed and not done:** the `launch_actor` default code-15 site, confirmed defensive and left alone; a fixture for a later-iteration loop-top validation failure; a fixture for the unrecognised-classification branch; and everything the brief already lists under evidence explicitly deferred.
