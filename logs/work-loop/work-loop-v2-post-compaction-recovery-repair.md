---
task: work-loop-v2-post-compaction-recovery-repair
status: active
turn: codex
---

## Objective and scope

Implement the post-compaction recovery repair plan, including operator-approved Amendment 1: preserve the Work Loop contract while preventing unnecessary immediate context refill after compaction, restore the `$realign` / `$reorient` boundary, make active-state result rollover reliable, and prove the repaired behavior.

Scope is Units 0–4 and the completion condition in `plans/work-loop-v2-v0.2/work-loop-v2-post-compaction-recovery-repair-implementation-plan-v0.1.md`. Preserve its exclusions: do not split the executable core; add no model default, hook, parser, state field, registry, cache, summary file, recovery daemon, universal state-size gate, provisional 12/16 KB launch policy, or unrelated optimization; do not change Work Loop roles, lifecycle, admission, courier permissions, or dispatcher exit codes.

## Lane and unit

Standard. Implementation mode. Unit 4c — resolve the frozen independent-review findings once.

The unsafe fast-forward is reversed and the operator chose to continue from this bound implementation
checkout. The correction round is frozen to the material findings already recorded; it is not a new
general review or a reopening of Units 0–3.

Named reason for the loop: the repair spans multiple bounded implementation and proof units, must survive hand-offs, and requires assessment independent of the implementer before it counts as complete.

## Latest result

Inspected (2026-08-18):

- Claim (1): HOLDS — read `.agents/skills/reorient/SKILL.md` Step 3 in full. Items 1 and 2 of the
  ordered read list are "Read the complete `work-loop-v2` skill available in the current scope" and
  "Read `references/core-resolution.md`, run the resolver it carries, and read the complete core file
  that resolver prints", both unconditional. Searched the Step 3 span from its heading to the skill
  read for `mandatory set|conditional|only when|read anything below`: no match. `.agents/skills/
  work-loop-v2/SKILL.md` line 38 names the core-resolution read condition as "when the Work Loop owns
  the move … and during `$reorient` recovery". No `a0f4f6ec` conditional semantics are present here.
- Claim (2): HOLDS — `logs/scripts/work-loop-capability.sh` enumerated exactly five components and
  no `.agents/skills/work-loop-v2/references/` path; `work-loop-capability.test.sh` line 319 listed
  the same five. Reproduced live: with `core-resolution.md` moved aside the checker printed
  `verdict: READY … all five Work Loop v2 components are present` at exit 0. `SKILL.md` links five
  direct references, each with a read condition an admitted move can meet, so the smallest complete
  component is the body plus the set it links — derived, not listed.
- Claim (3): HOLDS — searched `routing-and-admission.md` for `` `references/…` ``: three hits, at the
  routing-index read (step 2), the core-resolver run (step 3) and § The routing index. Searched it
  for the old `chain_hits` pattern `\(references/…\)`: no match, so the guard was green on all three.
- Claim (4): HOLDS — ran the seven present S8 order and clause predicates against
  `git show a0f4f6ec:.agents/skills/reorient/SKILL.md`: all seven returned green, including the
  order check and the `references/core-resolution.md` clause.
- Claim (5): HOLDS — `git ls-files` matches no `u4-live-case`, `u4-live-case-governing-plan` or
  `unit4-operator-prompt` path. `git grep` for `a0f4f6ec`'s two distinctive strings returns nothing.
  Searched `.agents`, `logs/scripts`, `.claude`, `.codex` and `plans` for `5,?541`: one hit, plan
  § 8 review prose naming the rejected number, which the brief permits as evidence and not a gate.
- Claim (6): HOLDS — `092a1715` exists; at that revision `logs/work-loop/u4-live-case.md` contains
  `U4-OLD-RESULT` 0 times, carries one `## Latest result`, is `status: active` / `turn: codex`, and
  the validator prints `ACTIVE_CODEX` at exit 0 against that revision in a scratch checkout.

Result: the six frozen findings are resolved on this feature branch, with approved recovery semantics
and the diagnostic-only byte treatment untouched. `$reorient`, `$realign`, the Work Loop main skill,
the executable core and the resolver were not edited. Findings 1–3 were repaired in
`work-loop-capability.sh` + its test, `routing-and-admission.md` + the Slice 1 chain guard, and the
Tracer 7 S8 controls. Findings 4–6 are dispositions supported by repository evidence, not edits.
Nothing was merged, cherry-picked or copied from the disposable branch, and the disposable
worktree and branch are untouched.

Evidence: each repaired control accepts its wrong fixture before and rejects it after.
(1) Capability — before: `core-resolution.md` removed gave `READY` / exit 0; after: `missing:
work-loop-references — … core-resolution.md is absent or unreadable` / exit 3, while the untouched
checkout is `READY` on all six against canonical `ai-resources`. `work-loop-capability.test.sh`
exits 0, 94 passed / 0 failed, with new cases for a removed reference, a removed body, a body linking
nothing, per-reference attribution and reference drift.
(2) Chain guard — before: the old pattern returned no hits on the pre-edit
`routing-and-admission.md`; after: the new pattern returns its three backticked sibling paths on that
same pre-edit file and none on any of the five live references. `work-loop-v2-slice-1.test.sh`
exits 0, 407 passed / 0 failed, including a backticked negative fixture and a CONTROL asserting a
bare ownership citation is not flagged.
(3) Recovery contract — before: all seven present S8 predicates were green against `a0f4f6ec`; after,
against that same content, the gate check returns `mandatory set / conditional / Read anything below
only when` and the complete-core check returns absent, while the live file returns no gate words and
carries the read. Both wrong fixtures are built from the live file, so the controls survive the
disposable branch's scheduled removal. `work-loop-v2-tracer-7.test.sh` exits 0, 167 passed /
0 failed, all nine scenarios PASS.
Full correction record, including findings 4–6 and the deferrals, is in plan § 8
"Correction round — the six frozen findings".

Deferred, recorded and not done (core § 3): `.claude/commands/work-loop-v2.md` Step 0 prose still
says "five separate things", and `/sync-workflow`'s remediation still enumerates the five original
component names — both count-only staleness in files outside this correction's implementation
boundary, neither changing behaviour. Separately, `courier-operation.md` names a sibling path as an
ownership citation; the guard's CONTROL fixes that as permitted, and whether references should cite
siblings by path at all is a contract question rather than this correction's.

Standing conditions this correction ran under, unchanged by it: canonical `main` remains at its
pre-merge pointer `0d5641b8` after the operator's option-A restore; `4510cb0a` and `a0f4f6ec` stay
reachable only on `disposable/wl2-unit4-case-2026-08-17`; and this remains the bound implementation
checkout for corrected Unit 4. The failed review itself is recorded in plan § 8 and is not erased.

## Blocker

None. The operator's decision resolved it.

## Next action

Codex: run the correction closure check on the six frozen findings only — are findings 1–6 resolved,
and did the correction break anything? Nothing else re-opens this unit.

What the closure check has to work with:

1. Capability presence now covers the direct references. Red/green above; `work-loop-capability.sh`
   reports six components and derives the reference set from the skill's own links.
2. The three backticked sibling loading instructions are gone from `routing-and-admission.md`, and
   the Slice 1 chain guard now catches that shape while a CONTROL keeps a bare ownership citation
   green.
3. Tracer 7 S8 gains two predicates that reject the `a0f4f6ec` conditional shape, each paired with a
   wrong fixture built from the live file rather than from the disposable branch.
4–6. Dispositions, not edits: fixture authority and the byte ceiling are confirmed absent from the
   tracked tree, the accepted semantic trace stays the pre-reversal one, and `092a1715` is accepted
   for its rollover behaviour alone.

Did the correction break anything: `work-loop-capability.test.sh` 94/0 exit 0,
`work-loop-v2-slice-1.test.sh` 407/0 exit 0, `work-loop-v2-tracer-7.test.sh` 167/0 exit 0 with all
nine scenarios PASS. `$reorient`, `$realign`, the Work Loop main skill, the executable core and the
resolver are unedited; the diagnostic-only byte treatment is unchanged; nothing entered this branch
from the disposable one, whose worktree and branch are untouched.

Two deferrals are recorded above and in plan § 8 and are for the closure check to accept or route,
not to implement here: the "five separate things" count prose in `.claude/commands/work-loop-v2.md`
Step 0 and `/sync-workflow`'s five-name remediation list, both outside this correction's
implementation boundary; and whether a reference may cite a sibling's path at all, which is a
contract question raised by `courier-operation.md`.

Still deferred by the brief: the final complete Work Loop regression matrix, the task-close verdict,
and destructive removal of the disposable worktree and branch.
