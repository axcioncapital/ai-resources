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

Standard. Implementation mode. Unit 15 — prove remaining evidence-location refusals

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 14 is accepted at `9707b2546e74ee50b4117dbffb1d6bd090aa8d8d`. `validate_state` now clears its two observation variables before a new observation, so a failed later validation cannot publish the previous valid turn/classification. Case 49 proved the defect at `26/2` before the repair and the completed result at `28/0` after it; the related initial-validation fixtures remained `80/0`; both shell files parsed; and no parser, lifecycle state, recovery state or helper was added. The 27-line production comment is more verbose than ideal, but it explains a subtle truthfulness invariant and trimming it alone would be a perfection pass, so it is accepted rather than turned into ceremony.

The next unmet Change set A boundary is already known and tightly bounded. `check_evidence_location()` has five refusal branches. Existing cases 58b and 63a prove an existing unwritable directory and a missing location beneath a non-directory ancestor; the remaining three branches are a dangling/non-directory symlink, an existing path that is not a directory, and a missing location whose nearest existing ancestor is not writable. Gate SA explicitly requires every invalid pre-admission invocation to fail clearly without actor launch, owner/lease acquisition, mutation or evidence, so these three belong in one representative family unit rather than three separate units.

Dominant deliverable: permanent pre-admission proof for the three remaining `check_evidence_location()` refusal branches.
Evidence required in this hop: one shared-boundary scratch mutation that makes the intended new checks fail; focused green proof for the three branches; syntax for the test file; structural evidence that all three refuse before the same admission point; and a test-only committed diff.
Evidence explicitly deferred: other identifier and token bounds, broader hostile-input coverage, all other Change set A work, the full dispatcher suite, Change sets B–D, live trials, final regression, adoption review, historical-probe cleanup, merge, push, deployment and destructive cleanup.
Primary edit begins after: express the intended assertions in scratch and show that bypassing or weakening the shared evidence-location admission check makes each new branch fail at least one load-bearing pre-admission invariant. Commit no mutant.

Required outcome:

- Add one focused fixture for each remaining branch: (1) a symlink evidence location that does not resolve to a directory, (2) an exact existing non-directory evidence path, and (3) a missing evidence path beneath a nearest existing ancestor that is not writable.
- Each fixture must prove clear stderr with the branch-specific reason and refused path, nonzero/usage exit, no actor call, no owner or lease acquisition, no checkout or Git mutation, and no run or refusal evidence. It must also prove the hostile filesystem object or ancestor is unchanged.
- Reuse the established pre-admission observations from cases 58b/63a. A narrow test-local helper is permitted only if it removes the same repeated invariant assertions across all three new fixtures; add no generalized admission matrix, production helper, schema checker or test framework.
- Keep `dispatch.sh` byte-identical. If any branch currently violates the approved pre-admission contract, stop and hand back the exact production defect instead of repairing it in this proof unit.

Check against the repository:

1. Verify Unit 14 commit `9707b254…` is confined to `dispatch.sh`, case 49 in `dispatch.test.sh`, and this state file; treat its reported focused evidence as settled and do not rerun it.
2. Verify the complete `check_evidence_location()` branch set and current permanent tests establish exactly the two covered and three uncovered refusal shapes named above. Search the complete dispatcher test surface, not only cases 58b/63a. If the count or coverage differs, hand back the narrower mapping before editing.
3. Verify all three target calls occur before run admission, run identity/evidence initialization, owner/lease acquisition and actor launch. If one is not pre-admission, stop rather than applying the wrong invariant.
4. Derive each branch-specific stderr expectation from the live producer. Do not make three fixtures pass on only a generic `STOP [10]` string.

Required fail-capable evidence:

- Quote one uncommitted shared-boundary mutant or equivalent scratch control, prove it differs and parses, and show each target fixture goes red on at least one no-actor/no-lease/no-mutation/no-evidence assertion while its hostile input remains present. The real dispatcher must then make all three green. Add no permanent mutant.
- Quote focused green totals for only the three new fixtures and enumerate which exact refusal branch each reaches.
- Run `bash -n` on `dispatch.test.sh`. Do not rerun cases 58b/63a, Unit 14, or the full suite.
- Confirm the committed diff contains only the new focused test/helper additions and this state file; `dispatch.sh`, the state validator and both lease/owner helpers must remain byte-identical. Leave `logs/friction-log.md` unstaged.

Capability subset: baseline only — inspect the approved admission contract, accepted Unit 14 evidence, `check_evidence_location()` and the complete existing dispatcher test surface; create scratch filesystem fixtures and one uncommitted mutant; edit focused test coverage; run local syntax and focused cases; and commit the test and task state. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No model launch, authentication attempt, network, external service or operator-reserved capability is permitted.

Completion condition: one committed test-only handback proves all three remaining evidence-location refusals satisfy the complete pre-admission invariant, adds no generalized machinery or production change, and returns with `turn: codex`.

Stop and hand back if an allegedly uncovered branch already has equivalent proof, a target is not pre-admission, a branch violates the contract, or meaningful proof requires production change or generalized machinery.

## Latest result

Reproduced (2026-08-18): finding 1 holds by inspection. The cases 63c–63e block measured 194 lines for 37 assertions — 68 comment, 5 blank, 121 code.

Result: the frozen finding is corrected. Six comment sites were rewritten or removed and no executable line was touched. The family banner lost the plan restatement, the pre-admission-contract recital, the call-site line-number list and the why-not-three-units argument; the helper preamble lost the "generalizes nothing" defence; the no-evidence comment was removed outright; each per-case banner was cut to the one thing it must carry, the distinction from an already-covered branch. Retained exactly as the finding names: one concise family boundary note, the lease-root detector rationale, the three per-fixture distinctions, and the unwritable-ancestor environment caveat. The block is now 154 lines — 28 comment, 5 blank, 121 code — a 40-line comment reduction, and no cleanup was applied outside 63c–63e.

Evidence: a code-only before/after view of the block (comments and blank lines stripped) diffs empty at 121 lines both sides, so every fixture, helper contract, assertion and behaviour is byte-identical. `bash -n dispatch.test.sh` is clean. The existing focused slice, rebuilt from the corrected file, returns `pass=37 fail=0`. `dispatch.sh`, `work-loop-state.sh`, `work-loop-lease.sh` and `work-loop-owner.sh` remain byte-identical to HEAD. Nothing else was rerun.

Nothing newly noticed during the correction. The two-point-precondition observation from Unit 15 stands as recorded and was not acted on here.

## Blocker

None.

## Next action

Codex: closure check on frozen finding 1 only — is the excessive narrative resolved, and did the trim break anything? The second question is answered by the empty code-only diff plus the 37/0 slice.
