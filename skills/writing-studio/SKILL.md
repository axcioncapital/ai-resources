---
name: writing-studio
description: Interactively develops or materially improves substantive external writing from an approved source-and-claim package. Use when the operator invokes Writing Studio Develop or Improve. Do NOT use for research, cold review, approval, or publication.
model: opus
effort: high
disable-model-invocation: true
---

# Writing Studio

Develop or materially improve substantive external writing inside the repository that owns the finished asset. Carry the reusable production method; keep assignment records, sources, candidates, review outcomes, approvals, and final assets in the active destination.

Writing Studio is a subordinate production method. It does not replace destination research, editorial policy, independent review, acceptance, or publication systems.

## Start here

The operator must invoke this skill deliberately and name a mode:

- **Develop** — create a new substantive asset or meaningful section from an approved package. Read [references/develop.md](references/develop.md) completely before acting.
- **Improve** — repair an authorised problem in an existing substantive candidate. Read [references/improve.md](references/improve.md) completely before acting.

A meaningful section is a unit whose argument, structure, evidence treatment, or claim wording affects what the reader understands or believes. Route a short, non-consequential line edit elsewhere.

If the mode is missing, ask whether the operator wants Develop or Improve. Do not infer a mode when the difference would change the authority or input contract.

## Capability boundary

Own:

- validating an already-authorised writing assignment;
- resolving the writing job, source roles, claim permissions, and distinct contribution;
- exploring authorised material without prematurely imposing article order;
- building the reader journey, argument, structure, evidence placement, and candidate prose;
- offering bounded choices at load-bearing editorial moments;
- preserving operator edits while composing in agreed units;
- running non-independent production QA on the exact candidate; and
- preparing a bounded handoff for independent review.

Do not own:

- business, research, claim, or publication authority;
- source discovery or classification on the destination's behalf;
- research routing or execution;
- destination canon or editorial policy;
- cold review, approval, acceptance, publication, distribution, or repurposing;
- cross-destination operational memory; or
- writes outside authorised destination paths.

Return any needed action outside this boundary to its named owner. Do not absorb it for convenience.

## Authority and source roles

Apply this priority when sources conflict: destination authority and explicit operator decisions within their owned domain take precedence over writing preference. If precedence between two same-domain authorities is not already defined, stop rather than choosing by recency, fluency, or convenience.

Assign every material input one role:

- **Authority** may ground claims only within its declared domain:
  - business authority governs Axcíon's position, capability, and business decisions;
  - research authority governs empirical or analytical support and its limitations;
  - communication authority governs approved meaning, terminology, voice, and expression, but not underlying truth.
- **Approved communication** shows what Axcíon has already said or approved for communication. It does not automatically evidence the underlying claim.
- **Reference-only** may guide tone, structure, comparison, or context. It may not support a claim.
- **Excluded** must not influence the candidate. Record a non-obvious exclusion reason in the destination record.

Treat operator speech and edits as authoritative production input, not automatic business or research evidence. Founder input may settle a founder-owned decision; it cannot turn missing evidence into support.

## Select the tier

- **Routine:** approved substance, bounded change, no sensitive or new claim, and no canonical-message consequence. Independent review is optional only when destination policy permits it and production work reveals no semantic uncertainty.
- **Consequential:** new argument, thought leadership, core website or pitch copy, sensitive or capability claim, canonical-message implication, or another destination-defined high-stakes condition. Independent review is mandatory.

Any escalation trigger wins. Treat ambiguity as Consequential. Destination policy may require stricter review but may not weaken this minimum.

## Universal workflow

Maintain this compact checklist in the destination's existing production record; do not create a second tracker:

- [ ] Open the assignment
- [ ] Read governing context
- [ ] Apply the pre-drafting gate
- [ ] Define the production contract
- [ ] Develop or improve the candidate
- [ ] Run production QA
- [ ] Prepare independent review

Mark completed stages `[x]`, identify the current stage as `active`, and leave later stages unchecked. If blocked, label the current stage `blocked` and link it to the existing `SOURCE_OR_DECISION_REQUIRED` record.

### 1. Open the assignment

Identify the destination, asset, audience, mode, tier, owners, constraints, inbound package, current candidate when applicable, and authorised read and write paths.

### 2. Read governing context

Read the complete authorised package, relevant communication canon, related assets, and destination requirements. Follow citations only to resolve a load-bearing claim, source role, contradiction, or limitation.

Establish in writing:

1. what governs the job;
2. what has already been said;
3. what is missing or conflicting; and
4. what this asset or revision must contribute.

### 3. Apply the pre-drafting gate

Reader-facing candidate prose may begin only when all four elements are settled in writing:

1. **Settled job** — the asset or section, audience, and required outcome.
2. **Resolved source authority** — which sources govern each kind of claim and expression.
3. **Permitted claims** — what may be asserted, qualified, treated as hypothesis, or not used.
4. **Distinct contribution** — what the asset adds beyond existing destination assets. For Improve, this is the revised section's intended job within the larger asset.

Before the gate passes, Develop may capture clearly labelled working fragments inside the authorised topic and write boundary. Those fragments carry no permission into the candidate. Improve may diagnose the authorised problem but may not rewrite candidate prose.

If any element is unresolved, stop with the exact marker:

```text
SOURCE_OR_DECISION_REQUIRED
unresolved: <specific gap or conflict>
why_it_blocks: <effect on candidate prose>
required_source_or_decision: <what would resolve it>
owner: <named authority>
safe_work: <what may continue, or none>
resume_when: <observable condition>
```

This gate replaces a generic output-release phrase. Do not add a second `RELEASE ARTIFACT` gate unless the destination already requires a separate outline approval.

### 4. Define the production contract

Record the intended reader belief, practical implication, required constraints, what the asset must not become, the acceptance owner, and the done condition. Make the contract strong enough to reject articulate prose that serves the wrong job.

### 5. Develop or improve the candidate

Follow the selected mode reference. Preserve the explore/exploit seam: in Develop, fix an identifiable authorised material pile before composition; in Improve, derive only the bounded material needed for the authorised revision.

For Develop, choose **Shape or Beats**, never both in sequence:

- Shape is the default for institutional, analytical, explanatory, or argument-led work.
- Beats is for narrative, experiential, chronological, or journey-led work.

Before every destination write, re-read the current candidate from disk and preserve intervening operator edits. Treat the material pile as a quarry rather than a script, and finish when the reader journey fulfils the production contract rather than when all material is used.

### 6. Run production QA

Once an exact candidate exists, read [references/production-qa.md](references/production-qa.md) completely and run it against that candidate. Record `independent: false`. Fix material defects inside existing authority; return defects needing new authority or evidence to their owner.

### 7. Prepare independent review

When production QA passes, read [references/review-handoff.md](references/review-handoff.md) completely. Prepare a bounded, version-bound packet and return `READY_FOR_REVIEW`. Writing Studio does not invoke or impersonate the reviewer; hand control back to the destination workflow or operator for a fresh-context review.

## Destination-owned records

Use the destination's existing artifacts. Map, rather than duplicate:

- assignment identity, mode, tier, owners, and current outcome;
- authority references with identifiable versions, source roles, and claim permissions;
- the four gate answers and production contract;
- authorised input manifest and write paths;
- material-pile version and provenance for Develop;
- branch, grounding, opening, argument, block-function, and structure decisions;
- candidate identity and lineage;
- candidate-bound production QA;
- stop reason, owner, safe work, and resume condition; and
- review, acceptance, and approval references when those events occur.

Use a destination version identifier that binds later decisions to exact wording. If none exists, record a minimal candidate label plus a content hash. A material change creates a new candidate identity and repeats production QA and every affected downstream gate.

Do not create a generic Writing Studio assignment file when the destination already has safe homes for this state. Keep reader-facing prose clean; production notes belong in the destination's production record.

### Content Programme pilot

For `axcion-content-programme`, use the existing article family:

- `articles/drafts/<slug>.md` — candidate article only;
- `articles/drafts/<slug>.notes.md` — assignment and production record;
- `articles/drafts/<slug>.research-brief.md` — destination-authorised research scope;
- `articles/drafts/<slug>.review.md` — reviewer-owned findings and gate result; and
- `articles/published/<slug>.md` — accepted source after required approvals.

Write only the authorised draft and notes paths. Read an authorised research brief or review findings when the assignment permits it. Do not write the review verdict, alter project canon or policy, change research permission, move an article to `published/`, or touch another destination.

Keep the pilot material pile, grounding decisions, branch decision, and opening choices in `<slug>.notes.md`. Create no separate material file unless Content Programme explicitly authorises a destination-native path after real use shows the notes file is insufficient.

## Output contract

Return one of two outcomes:

### Ready

```text
READY_FOR_REVIEW
candidate: <exact identity and path>
production_qa: <bound PASS record>
review_packet: <manifest or authorised paths>
review_owner: <destination workflow or named owner>
```

This means produced and self-checked, never approved, accepted, publishable, or published.

### Blocked

Return the `SOURCE_OR_DECISION_REQUIRED` record from the pre-drafting gate. Write it durably in the destination's existing production record when an authorised record path exists; otherwise make no destination edit and ask for one.

## Failure behavior

- **Missing or conflicting authority:** stop and name the conflict, owner, safe work, and resume condition.
- **Insufficient evidence:** preserve the gap and return it to the research or claim-permission owner. Do not browse around the authorised route.
- **Unsupported fragment:** keep it outside the permitted pile until its owner and permission are resolved.
- **Material gap during composition:** request an authorised contribution, cut the move, or return explicitly to exploration and create a new pile version. Do not invent a bridge.
- **Composition branch no longer fits:** start a new candidate path from the same pile or return to exploration. Do not silently turn Beats into an outline for Shape.
- **Operator edit changes meaning:** preserve the edit, pause, and repeat affected authority, grounding, lineage, and QA checks.
- **Unsafe or missing write boundary:** make no destination edit; request an authorised path.
- **Missing candidate identity:** create or request a minimal version binding before QA or review handoff.
- **Improve would alter thesis or claim permission:** return for authority rather than treating it as prose work.
- **Review requested in the producing context:** prepare the packet and route it to a fresh reviewer.
- **Uncertainty remains:** leave the gap visible. Prefer an explicit stop or incomplete but honest candidate over plausible invention.

## Bias countering

Do not reward fluency at the expense of authority, evidence, or analytical value. Push back constructively on an unsupported premise, even when it came from the operator. Leave gaps rather than inventing facts, transitions, or implications. Prefer accuracy and calibrated judgment over comprehensive-looking prose.

Offer real alternatives only at material choices. Do not create options as ceremony, and do not collapse a genuine operator choice into the first plausible draft. Preserve human edits without assuming those edits can override source authority.

## Known pitfalls

- Treating the three borrowed methods as Fragments → Beats → Shape; Shape and Beats are alternatives.
- Launching research when Develop's inbound package is weak.
- Letting Improve become an independent cold review or thesis rewrite.
- Treating operator speech as automatic authority for a factual claim.
- Drafting the whole asset before the entry path and reader journey are agreed.
- Asking for paragraph-by-paragraph approval during ordinary Shape work.
- Forcing unused fragments into the conclusion.
- Inventing a destination schema or writing state into the skill folder.
- Calling production QA independent review or treating `READY_FOR_REVIEW` as approval.

## Examples

**Develop stop:** "Use Writing Studio Develop on article two." The approved research brief is present but the evidence packet is incomplete. Record `SOURCE_OR_DECISION_REQUIRED`; do not research or draft the article.

**Develop success:** "Use Writing Studio Develop on this approved article package." Validate the package, fix a provenance-bound pile, choose Shape for the argument-led asset, offer authorised entry paths, compose in agreed sections, run production QA, and return `READY_FOR_REVIEW`.

**Improve:** "Use Writing Studio Improve on this pitch section using these authorised findings." Diagnose the bounded problem, preserve locked meaning, revise only the authorised area, create a new candidate identity, and return it for re-review.

## Validation loop

For a candidate skill release:

1. validate frontmatter, direct reference links, and the 500-line `SKILL.md` budget;
2. evaluate purpose, context boundary, interpretation, reasoning constraints, decisions, constraints, failure behavior, and output contract;
3. check that a fresh executor cannot reasonably launch research, self-review or approve, invent a destination schema, authorise operator fragments automatically, run Beats then Shape, or batch the full asset prematurely;
4. forward-test Develop stop, Shape Develop success, Beats, Improve, operator-edit preservation, review independence, and write non-interference on authorised fixtures; and
5. adopt only after the operator accepts the demonstrated behaviour.

Structural validity is not adoption. Do not retire the historical Writing Studio repository plan until the destination pilot has met these behavioral conditions and the operator explicitly approves retirement.

## Runtime recommendations

- **Model:** Opus, because the hard part is editorial and semantic judgment under authority constraints.
- **Effort:** high.
- **Invocation:** user-only while `article-production` and `article-review-gate` have adjacent responsibilities.
- **Paths:** no frontmatter restriction. This user-invoked skill must work across destination repositories; validate authorised read and write paths per assignment.
- **Context:** remain in the active destination conversation so operator choices and edits are visible; use a fresh context only for independent review.
- **Tools:** use the destination's normal read and edit tools within authorised paths. Do not restrict tools globally because destination implementations differ.

## Method lineage

The interactive writing engine adapts ideas from Matt Pocock's MIT-licensed experimental `writing-fragments`, `writing-shape`, and `writing-beats` skills, pinned for review at commit [`84fdeffd12f2ee307994d1eb6feb48173b6e0502`](https://github.com/mattpocock/skills/tree/84fdeffd12f2ee307994d1eb6feb48173b6e0502). Their Explore → Shape or Beats topology is preserved; Axcíon's authority, provenance, versioning, QA, review, and destination-state controls are original additions. Upstream changes do not alter this pinned method automatically.
