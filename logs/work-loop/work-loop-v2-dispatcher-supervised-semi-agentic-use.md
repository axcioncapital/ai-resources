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

Standard. Implementation mode. Unit 13 — close remaining terminal-result proof gaps

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 12 is accepted at `0d89c12a76aceca5d513133755c2b2449b36f60e`: initial state-validation codes `13`, `14` and `15` now have permanent exactly-one-complete-result proof. The local `assert_state_terminal` helper stays because it removes fifteen genuinely repeated assertions across three fixtures without creating a production contract. No new permanent mutant is needed: M1 and M41 already cut the exact shared funnel, while Unit 12 supplied the required scratch red. The `state_sha256_before=unavailable` assertion is accepted as today's truthful observation, with the explicit instruction to update rather than reverse any future improvement that moves hashing earlier.

The remaining known terminal-result gaps are code `26`, a post-hop code-`15` shape, permission code `37`, and budget code `29` in its before-launch and after-launch shapes. This unit closes those known gaps together so the task does not turn into one ceremony-heavy unit per exit code. The plan expressly requires every admitted terminal class, which is the stated consequence that justifies this bounded exhaustive bundle; all target fixtures already exist and no new scenario must be invented.

Dominant deliverable: complete permanent representative result proof for every remaining known admitted terminal-result class and lifecycle shape: malformed terminal `26`, post-hop malformed state `15`, permission denial `37`, and budget exhaustion `29` before and after actor launch.
Evidence required in this hop: one shared-funnel scratch mutation red; focused result assertions on one structurally representative existing fixture for each class/shape; structural evidence showing the sibling fixtures converge on the same terminal producer; syntax and only the affected focused cases.
Evidence explicitly deferred: the three uncovered evidence-location refusal branches; other identifier/token bounds; Change set A work not directly about the remaining known result-proof gaps; the full dispatcher suite; Change sets B–D; live trials; final regression; adoption review; historical-probe cleanup; merge, push, deployment and destructive cleanup.
Primary edit begins after: in scratch, express the intended assertions against one representative remaining fixture and show they fail against a narrowly mutated dispatcher copy that preserves the expected exit but suppresses or corrupts the terminal result. Reuse the accepted funnel-cut technique; commit no additional copy of that mutation.

Required outcome:

- In case 22, add full result proof to one representative malformed-terminal fixture: exactly one finalized record, no partial beside it, completion sentinel, `outcome=MALFORMED_TERMINAL`, `code=26`, truthful pre-hop/no-model/state/ownership facts, the state-repair next action, both leases held at finalization and released afterwards, and the exact state-file path. Preserve the other three existing code-26 variants as structural sibling controls; do not duplicate the same result block four times when all four validator failures converge on the same dispatcher `die 26` branch.
- In one of cases 48/49, prove the post-hop code-`15` terminal with its truthful actor-start, state before/after, working-tree/changed-path and lease facts. Choose the fixture that exposes the stronger distinct lifecycle shape; preserve the sibling's existing exit/effect coverage and cite the common post-hop validation branch instead of duplicating the full block.
- In case 43, choose one representative permission-denial fixture and prove one complete `PERMISSION_DENIED/37` result, the capability-decision next action, the truthful actor/model/capture and permission facts available in that fixture, and lease ordering. Keep its parser/fallback siblings as existing controls rather than copying the result block into each.
- For budget code `29`, prove both materially different lifecycle shapes already present: one after an actor has started and one where the expired run refuses the next launch. Each must record its own truthful stage, actor/model, deadline/budget, partial-effect and lease facts plus `BUDGET_EXHAUSTED/29` and the bounded rerun action. Do not treat one shape as proof of the other.
- Treat additional code-`13` validator-missing/unreadable branches as covered by Unit 12's permanent code-13 result proof plus their structural convergence on the same `die 13` producer. Add no duplicate result blocks unless inspection finds branch-specific trusted fields that genuinely differ.
- Reuse the existing result helpers and the Unit 12 helper only where its exact pre-hop-state contract fits. A narrow test-local helper may remove repeated mechanics, but add no generalized exit-code matrix, second schema checker, production helper, or new test framework.
- If any representative exposes wrong production behavior or a supposedly convergent sibling carries materially different trusted facts, hand back that exact finding. Do not combine production repair with this proof unit.

Check against the repository:

1. Verify Unit 12 commit `0d89c12a…` changes only this state file and `dispatch.test.sh`, reports cases 2/4 `67/0`, scratch mutant `1/15` versus real `16/0`, and leaves only `logs/friction-log.md` unstaged. Treat the accepted helper and mutation evidence as settled and do not rerun them.
2. Verify the approved revised plan's Change set A and Gate SA require every admitted terminal class to produce one durable atomic truthful result; this explicit exhaustive consequence is the reason these remaining classes are bundled rather than deferred or split into one-code units.
3. On the complete current test surface, verify that permanent result proof is still absent for `MALFORMED_TERMINAL/26`, post-hop `BAD_TURN/15`, `PERMISSION_DENIED/37`, and both lifecycle shapes of `BUDGET_EXHAUSTED/29`. If any is already proved equivalently, omit it and hand back the narrower result rather than duplicate it.
4. Trace each selected fixture and its siblings to the exact production terminal branch. Verify which siblings are genuinely structurally identical and which carry distinct trusted facts; representative proof is permitted only for the former.
5. Derive every expected field from the live producer path and fixture observation. Do not copy Unit 12's pre-hop values onto a post-hop, permission, or budget terminal where they are not truthful.

Required fail-capable evidence:

- Quote one narrow scratch mutation red and the matching real-dispatcher green before the test edit. The expected exit must remain unchanged while the result assertions fail. Do not commit another permanent funnel mutant; M1 and M41 remain the standing controls.
- Quote focused green totals for the selected code-26, post-hop-code-15, code-37, and both code-29 shapes. Enumerate the materially distinguishing stage/actor/model/state/deadline/permission/effect facts rather than printing every shared field again.
- Quote the structural convergence evidence that justifies not duplicating assertions across sibling fixtures. If that evidence fails, stop and return the exact branch distinction instead of silently widening.
- Run `bash -n` on `dispatch.test.sh` and only the affected focused cases with the minimum harness prologue. Do not rerun Units 10–12 or the full suite.
- Confirm the committed diff contains only this state file and focused additions inside the existing affected cases. `dispatch.sh`, the state validator and both lease/owner helpers must remain byte-identical; leave `logs/friction-log.md` unstaged.

Capability subset: baseline only — read the approved plan, accepted Unit 12 evidence, the terminal producer and existing affected fixtures; edit focused test assertions; create and execute one scratch mutant; run local syntax and focused tests; and commit the test and this task state. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No model launch, authentication attempt, network, external service or operator-reserved capability is permitted.

Completion condition: one committed test-only handback closes every remaining known result-proof gap with representative proof scaled to real lifecycle differences, duplicates no structurally identical sibling, changes no production file, and returns with `turn: codex`.

Stop and hand back if equivalent proof already exists, a selected path is pre-admission, structural convergence is false, production behavior is wrong, or meaningful proof requires a generalized matrix, new production contract or production change. Challenge the brief rather than widening it.

## Latest result

Inspected (2026-08-18):

- Claim (1): HOLDS — `git show --stat 0d89c12a…` lists exactly `logs/work-loop/work-loop-v2-dispatcher-supervised-semi-agentic-use.md` and `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`; HEAD is that commit. Unit 12's accepted counts and mutation evidence were not rerun, as instructed. The worktree carried `logs/friction-log.md` plus this state file (Codex's uncommitted Unit 13 brief) and nothing else.
- Claim (2): HOLDS — read `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` § Change set A, required behaviour item 3: it enumerates the terminal classes that must each "atomically finalize exactly one terminal result", naming "invalid state or ownership", "permission denial" and "budget exhaustion" explicitly, and item 4 requires the record to be truthful field by field.
- Claim (3): HOLDS — searched the whole of `dispatch.test.sh` for `MALFORMED_TERMINAL`, `PERMISSION_DENIED`, `BUDGET_EXHAUSTED`, `operator-decide-capability-grant`, `operator-rerun-with-larger-budget`, `code:26`, `code:37` and `code:29`; the only matches were two `expect_rc 29` labels containing the words "BUDGET_EXHAUSTED" as prose. No result-record assertion existed for any of the four classes. The post-hop `BAD_TURN` was likewise unproved: the file's single `BAD_TURN` occurrence is Unit 12's pre-hop call at case 4.
- Claim (4): HOLDS, with one correction to the brief's fixture numbering — searched `dispatch.sh` for terminal producers: `die 26` is one site (inside `validate_state`, on the validator's BAD_BODY exit 16), `die_hop 37` is one site, `die_hop 29` is four, `die 15` is three. Ran all four case-22 fixtures against the live dispatcher: each returns validator rc `16` and dispatcher rc `26` with an identical record shape, so representative proof is permitted. The brief names "one of cases 48/49" for the post-hop `15`; **case 48 exits 0**, so case 49 is the only candidate, and it is also the stronger shape (two allowlisted dirty paths against case 47's one).
- Claim (5): HOLDS — every expected value was read off a live run of each fixture in scratch before any assertion was written, not carried over from Unit 12. The post-hop terminals differ from Unit 12's pre-hop values in exactly the way that matters: real `state_sha256_before`/`head_before`, `stage=post-hop`, `actor_launched=yes`, and after-facts `unavailable` only where the run died above the line that takes them.

Packaging lines: all four present for an Implementation-mode unit; `Dominant deliverable:` names one deliverable enumerated over its classes; `Evidence explicitly deferred:` is populated.

Result: every remaining known terminal-result gap now has permanent proof except two fields of the post-hop `BAD_TURN` record, which are handed back below as a production finding rather than pinned. Test-only. `dispatch.sh`, `work-loop-state.sh`, `work-loop-lease.sh` and `work-loop-owner.sh` are each byte-identical to HEAD.

- **Code 26 (case 22)** — the representative (`partial-task`) gets the full record through Unit 12's `assert_state_terminal`, whose pre-hop contract fits it unchanged: `die 26` is raised inside `validate_state`, the same funnel as 13/14/15, so `stage=pre-hop`, `actor=none`, `hop=0`, `turn_at_terminal`/`state_class`/both hashes `unavailable`, `owner_check=unchecked`, both leases held at finalization and gone afterwards, plus the state-repair next action and the file path. The three siblings get two assertions each — one finalized result, and the same `MALFORMED_TERMINAL/26` pair — over a counted single-producer control, instead of the same eighteen assertions four times.
- **Post-hop code 15 (case 49)** — proved as its own lifecycle: real `state_sha256_before` and `head_before`, `state_sha256_after`/`head_after` `unavailable`, `stage=post-hop`, `actor=claude`, `actor_launched=yes`, `hop=1`, `worktree_allowlisted_dirty_paths=2`, `changed_paths_since_launch=2`, `owner_check=proceed`, the repair action, the state-file path, and lease held-then-released. Case 47's fixture reaches the same branch with one dirty path; case 49 was chosen because a count of two cannot be a constant.
- **Code 37 (case 43)** — full post-hop record, including the two facts that make this terminal what it is: `next_action=operator-decide-capability-grant`, the only capability-decision action in the dispatcher, and a `capture` path asserted to exist on disk and to contain the denials the stop printed. Also proved that the state hash moved across the hop while `head_before` and `head_after` stood still — the "edited, could not commit" shape. 43c and 43d are covered by a counted single-producer control.
- **Code 29, both shapes** — the after-launch kill (case 28) records `actor=claude`, `hop=1`, `deadline_seconds=3`, `deadline_remaining_seconds=0`, after-facts `unavailable` because it dies on the 124 branch, and real before-facts. The refused-launch shape (case 28b) records `actor=none` — stable whether or not a hop had completed, because the hop-over line clears `CUR_ACTOR` — plus `deadline_seconds=1`. The two are then compared against each other on `actor`, so neither stands as proof of the other. Case 28b's timing-dependent facts are deliberately unpinned; instead its two admissible shapes are named in one `case`, so a record matching neither fails. A counted control records that the other two `die_hop 29` sites are retry variants of the after-launch shape.

Evidence:

- **Scratch red, before the test edit.** The M1 funnel line (`finalize_terminal_result "$code" || die_funnel_unprovable "$code"`, one hit, mutant differs and parses) was cut from a scratch copy. Against that mutant the intended assertions ran **pass=9 fail=104** — the 9 passes are the eight `expect_rc` assertions plus one, so **every expected exit is unchanged and every result assertion is red**. Against the real dispatcher the same file ran **pass=113 fail=0**. No permanent mutant was committed; M1 and M41 remain the standing controls.
- **Focused green.** The affected cases (22, 28, 28b, 43, 49) with the minimum harness prologue: **pass=143 fail=0**. The same slice taken from HEAD's `dispatch.test.sh` runs **pass=23 fail=0**, so the unit adds 120 assertions, all green. Units 10–12 and the full suite were not rerun.
- **One assertion was wrong and was fixed by the run, not by review.** The single-producer control first used `^[[:space:]]*(die|die_hop) 26 `; the code-26 site sits in a `case` arm (`16) die 26 …`), so it counted zero and reported a moved branch that had not moved. All three counts now use `(^|[^[:alnum:]_])die(_hop)? N `, verified to return 1, 1 and 4.
- `bash -n plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` clean.
- Committed diff: this state file and `dispatch.test.sh` only. `logs/friction-log.md` left unstaged.

## Blocker

None.

## Next action

Codex: assess Unit 13, and decide the one finding it hands back.

**The finding.** At the post-hop `BAD_TURN` terminal, the record reports `turn_at_terminal=claude` and `state_class=ACTIVE_CLAUDE`. Those are the values the **pre-hop** `validate_state` returned; the post-hop call refused to return a classification, which is the entire reason the run exits 15, and nothing clears the two variables in between. The same terminal reached before a hop — Unit 12's case 4 — records both as `unavailable`. So one producer gives two opposite answers to "what did you observe", and the stale one asserts a legal turn at a terminal whose whole meaning is that the turn was not legal. It is the same defect class the dispatcher's own `LAUNCHED_ACTOR` note names one field over: the previous hop's reading answering for a reading that never happened. It is reachable at every post-hop `validate_state` failure, not only this one.

Those two fields are therefore left **unasserted** in case 49, with the reasoning written at the call site. Asserting today's values would make a record that contradicts its own exit code into a guarded contract; asserting `unavailable` would be making the production change this unit is barred from combining with proof work. Everything else about that terminal is proved. Codex decides: open a production unit to clear `ST_TURN`/`ST_CLASS` before each `validate_state` call and then pin `unavailable`, or accept the carry-over as intended and pin today's values — either way the assertion is added with the decision, and the post-hop code-15 class is complete only then.

**Deferrals noticed and not done:** the three uncovered evidence-location refusal branches; the `die 15` site at `launch_actor` ("cannot launch actor"), which is a third code-15 shape neither Unit 12 nor this unit proves; the two retry-variant `die_hop 29` sites, counted but not individually proved; and everything the brief already lists under evidence explicitly deferred.
