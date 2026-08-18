---
task: work-loop-v2-post-compaction-recovery-repair
status: active
turn: codex
---

## Objective and scope

Implement the post-compaction recovery repair plan, including operator-approved Amendment 1: preserve the Work Loop contract while preventing unnecessary immediate context refill after compaction, restore the `$realign` / `$reorient` boundary, make active-state result rollover reliable, and prove the repaired behavior.

Scope is Units 0–4 and the completion condition in `plans/work-loop-v2-v0.2/work-loop-v2-post-compaction-recovery-repair-implementation-plan-v0.1.md`. Preserve its exclusions: do not split the executable core; add no model default, hook, parser, state field, registry, cache, summary file, recovery daemon, universal state-size gate, provisional 12/16 KB launch policy, or unrelated optimization; do not change Work Loop roles, lifecycle, admission, courier permissions, or dispatcher exit codes.

## Lane and unit

Standard. Unit 4 — representative proof and independent review — is blocked on recovery from an
unsafe fast-forward of the disposable case branch into canonical `main` before the required review
gate completed.

Named reason for the loop: the repair spans multiple bounded implementation and proof units, must survive hand-offs, and requires assessment independent of the implementer before it counts as complete.

## Latest result

The disposable case reached closed commit `4510cb0a`, but it did not remain a representative proof.
After its required rollover hand-back, later turns treated fixture plan
`plans/work-loop-v2-v0.2/u4-live-case-governing-plan.md` as genuine authority even though its claimed
approval commit `aa11bb22` does not exist. That produced additional implementation at `a0f4f6ec`:
`$reorient` now conditionally omits the complete Work Loop skill and executable core and the case uses
a 5,541-byte pass ceiling. Both reverse the operator-approved main plan, which requires those two full
reads and makes byte volume diagnostic rather than correctness.

The plan-required independent review therefore failed both axes. Spec: four material blockers — the
semantic reversal, invalid fixture authority, hard byte ceiling, and absence of a conforming
post-change live proof; Tracer 7's phrase checks do not protect the mandatory-read semantics.
Standards: the capability checker still reports READY with `core-resolution.md` removed, and
`routing-and-admission.md` creates a prohibited sibling-reference chain that its Markdown-link guard
does not detect. Cleanup also remains incomplete: fixture plan, decoy state, audit and operator prompt
landed in canonical paths.

Before this assessment completed, canonical checkout `/Users/patrik.lindeberg/Claude Code/Axcion AI
Repo/ai-resources` was fast-forwarded from `0d5641b8` to `4510cb0a`.

**The operator chose option A on 2026-08-18, and the restore is complete and verified.** Canonical
`main` is back at its exact pre-merge pointer `0d5641b8`, the working tree is clean, and the
fast-forward never left this machine — `origin/main` remained `3e7789cd` throughout, and `main` is
now 25 commits ahead of it rather than 45. No commit was lost: `4510cb0a` is still reachable on
`disposable/wl2-unit4-case-2026-08-17`. Confirmed absent from canonical `main`:
`unit4-operator-prompt.md`, the four new `.agents/skills/work-loop-v2/references/` files, and the
fixture governing plan. This checkout remains the bound implementation checkout for corrected Unit 4.

Two of the review's load-bearing findings were independently confirmed against the repository rather
than taken on report. `git cat-file -t aa11bb22` returns `Not a valid object name`, so the fixture
plan's claimed content-bound approval anchors to a commit that does not exist. And
`work-loop-capability.sh` enumerates exactly five components — state-validator, owner-helper,
reorient-skill, compact-recovery-hook, owner-ignore-rule — none of which is
`.agents/skills/work-loop-v2/references/core-resolution.md`, so the gate can report `READY` with a
file the resolver depends on removed.

## Blocker

None. The operator's decision resolved it.

## Next action

Codex: frame corrected Unit 4 against the operator-approved main plan, not the fixture plan. The
restore is done, so the unit starts from `0d5641b8` plus this checkout's uncommitted work. The four
Spec blockers and two Standards findings in `audits/working/u4-case-spec-review.md` and
`audits/working/u4-case-standards-review.md` are the scope to reframe against — in particular
restoring the mandatory full reads of the Work Loop skill and executable core, returning byte volume
to a diagnostic rather than a pass ceiling, and closing the capability-check gap on
`core-resolution.md`. Size the unit and set `turn: claude`.
