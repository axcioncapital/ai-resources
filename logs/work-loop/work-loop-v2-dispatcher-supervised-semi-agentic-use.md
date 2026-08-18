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

Inspected (2026-08-18):

- Packaging lines: HOLD — `## Brief` carries all four lines Implementation mode requires; `Dominant deliverable:` names exactly one deliverable.
- Claim (1): HOLDS — `git show --stat --format="" 9707b254` lists exactly three paths: this state file, `dispatch.sh`, `dispatch.test.sh`; the test diff is confined to case 49. Its focused evidence was treated as settled and not rerun.
- Claim (2): HOLDS — `check_evidence_location()` (`dispatch.sh` 1598-1628) has exactly five refusal branches: dangling/non-directory symlink (1604), exists-and-not-a-directory (1609), existing-directory-not-writable (1611), ancestor-not-a-directory (1621), ancestor-not-writable (1624). Searched the complete test surface for coverage — `grep -n "STOP \[10\]" dispatch.test.sh` returns two hits (8989, 10869) and `grep -n "expect_rc 10"` returns seven, of which only 8988, 10868 and 10939 concern the evidence location; the other four are `--deadline`, `--status --dry-run` and `--unattended` usage errors. `grep -n "ln -s" dispatch.test.sh` returns three hits, all in case 52b's terminal-result identity fixtures, none an evidence location. So exactly two branches were covered (58b → 1611; 63a and 63a(2) → 1621) and exactly three were not. The mapping is as the brief states.
- Claim (3): HOLDS — one call site, `dispatch.sh` 1635, so all five branches share it. It precedes evidence-directory creation (3174), canonicalization (3179), `RUN_ID` (3221), `acquire_lock` (3312), the ownership helper (4125) and `launch_actor` (4370).
- Claim (4): HOLDS — scratch probe against the live dispatcher returned three distinct messages: `is a symlink that does not resolve to a directory`, `exists and is not a directory`, and `cannot be created — <ancestor> is not writable`. Each fixture asserts its own clause, not a shared `STOP [10]`.

Result: cases 63c, 63d and 63e were added to `dispatch.test.sh` immediately after 63b, together with one narrow test-local helper, `evidence_refusal_invariants()`, holding the six absences all three share. `dispatch.sh` and the three helpers are byte-identical to HEAD.

Evidence: the shared boundary was bypassed in an uncommitted scratch copy and each fixture went red on the no-lease assertion — the required no-actor/no-lease/no-mutation/no-evidence class — while its hostile input stayed present and its setup and unchanged-object assertions stayed green (24/13). The real dispatcher then returned 37/0 for the same three cases, rebuilt from the committed test file rather than from the scratch text. `bash -n dispatch.test.sh` is clean. Cases 58b, 63a, 49 and the full suite were not rerun.

One thing the red run established that the brief did not anticipate, and it is a finding rather than a detour: **bypassing `check_evidence_location()` alone is not enough to make the four absences observable.** The `mkdir`/canonicalize guards at 3174/3179 are a deliberate second statement of the same precondition ("a check that cannot fail is not a check", 3166-3172), and they sit *above* `acquire_lock` today, so a single-point bypass still stops the run before any lease. The first mutant proved only the branch wording (32/5). The control was therefore made the honest one — the precondition removed at both places the code states it — and only then did the lease assertion move. The same is now true of case 63a's own historic red, which a single-point bypass would no longer reproduce.

## Blocker

None.

## Next action

Codex: assess Unit 15 against its completion condition — three remaining `check_evidence_location()` refusal branches given permanent pre-admission proof, no generalized machinery, no production change. Two things are recorded for the assessment rather than acted on. First, a deferral: the lease-held half of this boundary is proved once, by 63a(2), as an ordering fact about the single call site, and was not re-run per branch — three live holder dispatchers for one ordering would be ceremony. Second, the two-point-precondition finding under `## Latest result`, which is about the shape of any future control at this boundary, not about this unit's result.
