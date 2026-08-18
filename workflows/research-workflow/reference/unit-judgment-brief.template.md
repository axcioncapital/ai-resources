# Unit Judgment Brief — template

> **When to read this file:** when producing a Unit Judgment Brief, or when reviewing one against its
> contract. The authority rules — lifecycle, challenge, promotion, consumption — are in
> `docs/judgment-authority-contract.md`. This file carries the shape and how to write it well.

**Where the brief sits.** After gap resolution, before downstream writing. It is the first artifact
authorised to turn combined research into a current Axcíon-level view, and it is the single
analytical authority downstream. It is an **internal planning artifact**: it is not copied into a
report as a section, and its headings must not become report headings.

**The proposed form is not authority.** Only `{base}-approved.md`, produced mechanically by
`logs/scripts/promote-judgment-brief.sh` after explicit approval, is. See the contract § 5.

**Length is a target, not a gate.** 500–800 words. The validator reports a brief outside the band and
accepts it. Do not treat the warning as a failure, and do not pad or cut to hit the number.

**No new identifier scheme.** Existing research claim IDs (`[Q1-C05]`, `[GF3-C02]`) are the mandatory
evidence basis. Context is referenced in prose under a `Context:` lead-in, never given an ID of its
own.

---

## Template — copy from here down

```markdown
---
unit: {unit}
artifact: unit-judgment-brief
status: proposed
as_of: YYYY-MM-DD
---

# Unit Judgment Brief — {unit}

**PROPOSED — FOR INDEPENDENT CHALLENGE AND OPERATOR DECISION.** The producer works to a
junior-to-mid-level analyst standard: it connects evidence and proposes commercially relevant
implications. The operator retains authority over Axcíon strategy and over the final verdict.

## Theses

### Thesis 1 — {the view in one line, not a topic label}

{One compact analytical paragraph. It combines, in whatever order reads best:
 - the current view or pattern;
 - the two to four decisive findings, cited by existing claim ID and used strictly within their
   permission limits [Q1-C05] [Q2-C07];
 - what those findings mean commercially — market attractiveness, buyer behaviour, transaction
   logic, target quality, timing, risk or access.

 Do not write this as facts-then-implications. The unit of thought is one evidence-backed thesis.
 Every thesis cites at least one claim ID; an interpretation with no evidence basis is refused.}

Context: {why this matters to Axcíon now, or how it should be framed given current priorities.
Optional. It may shape relevance and framing only — it may never raise confidence, close a gap,
turn a hypothesis into a market fact, or convert a failed search into proof of absence. Do not cite
a claim ID on this line: evidence belongs in the thesis, not in the context statement.}

Countercase: {the strongest counterevidence, scope limitation or alternative reading — include it
where it changes how the thesis should be understood, and omit it where it does not. Weak
objections do not earn a line merely by existing.}

### Thesis 2 — {…}

{…}

### Thesis 3 — {…}

{…}

## Provisional verdict

{A short unit verdict, or `unresolved` where the evidence genuinely cannot distinguish between
competing readings. `unresolved` is a valid analytical conclusion; where it is used, say what
decision the uncertainty prevents or qualifies.

Cite the claim IDs the verdict rests on [Q1-C05]. A verdict supported only by context is context
deciding the outcome, and it is refused.

Use the strongest conclusion the evidence permits. Neither avoid judgment nor manufacture
certainty.}

## What would change the view

{The observable evidence, event or diligence result that would materially move the verdict. Write
what would be seen, not "more research" — a change condition that cannot be observed is not one.}
```

---

## Producer inputs

Two bundles, kept explicitly separate. They have different epistemic roles, and the separation is
what the challenge checks.

**Evidence bundle** — determines what can be concluded:

- refined cluster memos
- per-cluster claim-permission tables
- gate-clearance verdict and caveats
- gap assessment and scarcity register
- existing claim IDs for every load-bearing factual premise

The producer does not re-read all raw research by default. It may inspect an extract where a memo
conclusion needs traceability checking; it does not duplicate the analysis stage.

**Axcíon context bundle** — determines why a conclusion matters and how it is framed:

- the project's judgment context card, where the project keeps one
- the approved unit task plan and research plan
- unit-specific operator decisions made after those plans were written
- any current priority or operating change not yet recorded, supplied as a dated operator note

**Context may never** strengthen an evidence grade, close a gap, turn a hypothesis into a market
fact, or convert a failed search into proof of absence.

## What the challenge asks

The independent reviewer did not write the brief. The minimum questions:

1. Are the decisive conclusions traceable to permitted evidence?
2. Does any interpretation exceed what its load-bearing claims permit?
3. Is Axcíon context influencing relevance rather than evidence confidence?
4. Is the strongest contrary case represented fairly?
5. Are proposed implications commercially useful, bounded, and consistent with current priorities?

A finding that requires change is tagged. Two tags carry mechanical force:
`permission-breach` (an evidence-permission overreach — it can never be disposed of by approval) and
`decision-conflict: {id}` (a conflict with an operator decision — its disposition must name the
decision that settles it, and that may not be the decision it conflicts with).

## Approval

Approval is the operator's own act, and it runs through the existing operator decision point — there
is no separate approval workflow and no new stage. On approval, **do not write the approved file by
hand.** Run `logs/scripts/promote-judgment-brief.sh` against the reviewed proposal. It carries
everything from `## Theses` down byte for byte and refuses to write if it cannot. Authoring the
approved file by hand is how theses drift between what the operator read and what governs the work,
and nothing afterwards can detect that.

On rejection, set `status: rejected` and `rejected_by:` on the proposal. No approved file is created,
and nothing downstream may proceed on it.
