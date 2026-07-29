UNIT: 2026-07-29-review-layer-consolidation-prove
STREAM: 2026-07-29-review-layer-consolidation
PHASE: prove
REPO: ai-resources
BASE: 2cb245e (as recorded in this unit's evidence)   HEAD-AT-START: 8840672
NEXT: Codex Prove review → G2

> **RETROSPECTIVE RECOVERY BRIEF — brief-first ordering was NOT satisfied for this unit.**
>
> `docs/work-loop.md` § Artifacts requires the brief to precede every other artifact of its unit, and
> the § Ordering rule requires it to be written before the unit's first commit. **Neither happened
> here.** The Prove unit was run and its evidence committed at `8c24043` with no brief in the working
> tree and none in git history — the same orphan-artifact violation that `85a4bcc` repaired for
> Build-3 and Build-4, repeated one unit later by the unit that was meant to be checking the stream.
>
> This file was written **after** the work, on operator authorization, and is a **reachability
> repair only**. It restores what § Resume order and § Reconciliation index on. It does **not**
> restore the property the ordering rule exists to give — that the work was bounded by a brief agreed
> before it started. Nothing here may be read as evidence that this unit was scoped in advance.
>
> **Provenance of the scope below:** transcribed from § 1 of this unit's own evidence
> (`…-prove.evidence.md:26-35`), which records the four checks the operator specified at the opening
> of the Prove phase. That evidence file is the only surviving record of the instruction. No scope,
> premise or falsifier below is inferred from the unit's *results*; results are deliberately excluded
> so this brief cannot be mistaken for one written with the answers in hand.
>
> Authorized by the operator, 2026-07-29. Historical evidence was not rewritten and this unit is
> **not** marked complete.

BRIEF
Need: the four Build slices S1–S4 of the review-layer consolidation are committed, but no unit has
judged the result as a whole. Prove exists to test what was built against what Shape said would
falsify it, before G2 decides whether it is fit to stand.

Scope: verification only. Prove reads the stream's Shape plan and review from disk and judges the
landed change against them. No policy doc, command, hook or settings file is edited to *extend* the
change; only defects the verification itself surfaces may be repaired, and every repair is reported.

Premises to verify — the four checks specified by the operator at the opening of this phase:
- P1 — the six repaired references resolve: every target anchor exists and every citing site points
  at a real heading.
- P2 — no live reference to a deleted policy section survives across `docs/`, `skills/` and
  `.claude/`.
- P3 — the `improve-skill` automatic-QC removal is the intended shape: the automatic independent
  post-edit pass and its loop-back are gone, and the pipeline's own evaluation engine is intact.
- P4 — every protected safeguard named in the G1-approved package is unchanged, verified per path
  rather than by search.

Falsified if any of P1–P4 fails; or if a protected safeguard differs from its pre-stream state; or
if a live reference to removed machinery survives in a file this stream may edit; or if the evidence
claims an end state the repository does not hold.

LIMITATION carried into the review: this brief is retrospective (see notice above), so it cannot
constrain what the unit did — it can only state what the unit was told to check. The reviewer should
treat the evidence, not this file, as the authority on what was actually done.
