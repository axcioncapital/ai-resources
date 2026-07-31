UNIT: 2026-07-31-g1-reviewed-plan-invariant-build-1   STREAM: 2026-07-31-g1-reviewed-plan-invariant   PHASE: build
REPO: ai-resources                                    BASE: 6050a5b83f976583154f79ecfd5335691ba3d156    NEXT: Claude writer

BRIEF

**Authored by Claude, not by Codex — and that is the correct provenance here.** A Build unit
implements an already-independently-reviewed and G1-approved plan; it does not receive new framing.
The framing was done in Frame and Shape, reviewed twice by fresh Codex tasks, and approved by the
operator at G1. This brief therefore transcribes the approved scope rather than proposing any.

Need: implement the exact G1-approved package — plan-v4 §7's single atomic slice S1, four files,
ordered steps 1–4 — so that the Slice 1 invariant exists in the repository's authorities:

> G1 cannot open unless the plan it presents is byte-identical to the plan a valid independent review
> inspected — proven by matching path, containing commit and blob SHA — and the correction loop
> terminates: one initial review, at most one material correction, at most one closure `review-2`,
> never a third, with an unresolved material `review-2` closing the stream `hold-reframe`.

Authority for this unit, in order (`docs/work-loop-repair-workflow.md` §1):

1. the operator's G1 approval, bound to plan-v4 at commit `df45a2b1a42a2140c85a56e71c395407dc9eb903`,
   blob `9ae4839afc8ccb23c4bd50a2644f32213273ed90`;
2. `docs/work-loop-repair-workflow.md` § Stage 7;
3. plan-v4 §7 (ordered steps), §4 (scope), §5 (exclusions), §6 (design);
4. the implementation handoff `…-shape.handoff-2.md`.

Premises to verify — all re-derived against Git in this worktree before any object edit:

- plan-v4 still resolves to blob `9ae4839a…` at commit `df45a2b1…` and at HEAD; any mutation voids G1.
  [check: `git rev-parse` both]
- review-2 still resolves to blob `848ee9f9…` at commit `12b22dd9…`; its binding relation holds.
  [check: `git rev-parse`]
- the four objects under repair are byte-identical to the approved base, so plan-v4 §13.8's line
  numbers still resolve. [check: `git diff --stat 6050a5b HEAD -- <four paths>` → empty; blob compare]
- the worktree is clean and `6050a5b` is an ancestor of HEAD. [check: `git status --porcelain`,
  `git merge-base --is-ancestor`]
- the previous writer released ownership and this session has explicitly acquired it (§7).

Scope: exactly the four files in plan-v4 §4 —

| Path | Change |
|---|---|
| `docs/work-loop.md` | plan identity · review identity · review-header requirement · G1 precondition · materiality · lifecycle · `hold-reframe` and its capability transition · `review-{n}` path |
| `.agents/skills/work-loop/SKILL.md` | the three-line plan-identity carrier on Shape review headers; correct `:42` |
| `.claude/commands/work-loop.md` | header validation · `HEADER-REPAIR` receipt · the comparison · G1 package in identities · blocker stop · lifecycle mechanics · capability `hold-reframe` transition |
| `templates/capability-record.md` | **line 98 only** — add `hold-reframe` to the `## Units` outcome enumeration |

Step 4 runs last, so the template is made consistent with a contract that already defines the outcome.

Exclusions (plan-v4 §5): routing · G2 candidate identity and Prove-side non-convergence · post-G1
package freeze and OF-1 · state, ownership and writer leases · general phase/transition enforcement,
validators and scripts · review-method expansion and OF-3 · legacy consolidation · historical
rewriting. No new state, validator, script, outcome beyond `hold-reframe`, review machinery, gate or
later-slice design is introduced.

Falsified if: any file outside the four in-scope paths plus this stream's `logs/loop/` artifacts is
modified (F12) · a fourth gate appears or `hold-reframe` behaves as a gate (F11) · "at most one review
round" survives in the contract or `SKILL.md` (A18) · the template's line-7 status axis changes (A17) ·
any acceptance criterion A1–A20 is unmet · plan-v4 is mutated to fit the implementation.

Budget: Build carries **no review and no gate** (`.claude/commands/work-loop.md:136-138`,
`…repair-workflow.md` § Stage 7). The next independent review is Prove's, before G2. A discovery that
materially invalidates plan-v4 is a **stop and report**, never a quiet expansion.

LIMITATIONS: This brief opens an implementation unit and authorizes no scope beyond the G1-approved
package. It makes no behavioural claim — these are documentation and instruction changes, and whether a
future session obeys them is behavioural evidence unobtainable before the slice exists (plan-v4 §11.6);
M8, M9 and M10 belong to Stage 9 (Use).
