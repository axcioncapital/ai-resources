# /reconcile Genericness Heuristics

> **When to read this file:** Loaded by `reconcile-reviewer` when scoring the "Originality / non-generic value" dimension of a reconciliation. Not needed for every turn.

Polished prose can still be a defect. An output that reads well but could have been written for almost any comparable business is a failure of the workflow, not a stylistic quirk — it means the project's specific context never actually shaped the output. Score this dimension by testing for *substitutability*, not by taste.

## The substitution test

For each major claim or recommendation in the output, ask: **if you deleted every project-specific noun (company name, market, stage) and handed this to a different, comparable company, would it still read as correct advice?**

- **Yes, unchanged** → generic. The specific context did no work.
- **No — it would misfire or need rewriting** → grounded. The context was load-bearing.

Run this on the 3–5 highest-weight claims, not the whole document — genericness concentrates in the recommendations and framing, not in factual scaffolding.

## Positive signals (fire the flag)

- **Best-practice language substituting for a decision.** "Companies should focus on building trust with stakeholders" — true of everything, decides nothing.
- **Lists of options with no ranking.** Presenting three paths without saying which one and why is not judgment; it's a menu.
- **Abstract-noun stacking without a referent.** "Alignment," "leverage," "ecosystem," "positioning," "synergy," "intelligence" used without a concrete, checkable meaning attached in the same sentence.
- **Framework applied without a verdict.** Naming a model (e.g., a value-chain framework, a maturity curve) and walking through its steps without using it to conclude something specific.
- **Category mismatch with the project's actual shape.** Advice calibrated for a different company stage, funding model, or market structure than the one the mandate rubric describes (see `mandate-rubric.md` for this project's actual stage/constraints).
- **"Best practice" cited instead of a project-specific trade-off.** Naming what other companies do, without stating why it does or doesn't apply here.

## Negative signals (do not flag)

- Standard terminology used correctly and then immediately made concrete (a framework named, then applied to a specific number, constraint, or decision).
- A recommendation that would visibly break if applied to a different company at a different stage — that's the substitution test passing, not a defect.
- Confident, plain statements of fact that happen to also be true elsewhere — genericness is about substitutable *judgment*, not about claims being universally true.

## Scoring

- **Weak** — most high-weight claims pass the substitution test as "unchanged"; the output could be relabeled for another company with minimal edits.
- **Moderate** — a mix; some claims are load-bearing on project context, others are swappable filler.
- **Strong / not generic** — the high-weight claims fail the substitution test; removing project specifics would visibly break the recommendation.

Cite the specific sentence or claim that triggered the flag when reporting a Weak or Moderate score — "the advice feels generic" is itself a generic finding. Name what a project-specific version would have said instead, using `mandate-rubric.md`'s stated context.
