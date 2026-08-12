# Writing Studio Claude Skill Specification

**Version:** v0.2  
**Status:** Draft for incremental refinement  
**Target:** User-scoped Claude skill  
**Proposed skill name:** `writing-studio`

> **Specification, not build authority.** This document defines the first candidate
> contract for the Writing Studio skill. It does not authorise creating, installing,
> deploying, or testing the skill, and it does not retire or amend the existing
> Writing Studio case architecture.

> **One evolving specification.** Improve this file in place. Increment the version
> when a change materially alters scope, authority, invocation, lifecycle, outputs,
> or acceptance conditions. Do not create parallel specifications for the same skill.

## 1. Objective

Create one reusable Claude skill that develops or materially improves substantive
external writing inside the repository that owns the finished asset.

The skill carries the reusable production method. The active destination repository
carries the assignment record, sources, drafts, review outcomes, approvals, and final
asset. An ordinary assignment must not require the operator to switch repositories.

The skill replaces the need for a separate `axcion-writing-studio` repository. It does
not replace destination-specific research, editorial policy, review, acceptance, or
publication systems.

### Method lineage

The production method adapts ideas from Matt Pocock's experimental
[`writing-fragments`](https://github.com/mattpocock/skills/blob/main/skills/in-progress/writing-fragments/SKILL.md),
[`writing-shape`](https://github.com/mattpocock/skills/blob/main/skills/in-progress/writing-shape/SKILL.md),
and [`writing-beats`](https://github.com/mattpocock/skills/blob/main/skills/in-progress/writing-beats/SKILL.md)
skills.

Their current topology is **Explore, then Shape or Beats**. Shape and Beats are
alternative composition methods that consume a fixed raw-material pile; they are not
sequential stages. Writing Studio preserves that separation while adding the authority,
provenance, versioning, QA, review, and acceptance controls required for institutional
writing. The implementation must record the upstream commit reviewed and retain the
applicable MIT attribution so later upstream changes do not silently alter this method or
erase its provenance.

## 2. Design principles

These principles govern every later implementation decision, in priority order:

1. **Authority before prose.** Better writing must never conceal a missing job,
   unresolved authority, unsupported claim, or absent contribution.
2. **Explore before exploit.** Widen and sharpen the authorised material before
   committing to an article path. Once composition begins, treat that material as a
   fixed input unless the assignment explicitly returns to exploration.
3. **Argument before prose.** Settle the asset's argument contract and the current
   block's job before wording it. A complete paragraph-level outline is optional when
   interactive shaping will determine the stronger sequence.
4. **Ground the reader.** A block may rely only on concepts the reader is expected to
   bring or that an earlier block has introduced.
5. **Destination owns state.** Durable assignment evidence belongs beside the asset
   it governs.
6. **Preserve human authorship.** Offer real choices at load-bearing moments, write in
   agreed units, and treat intervening operator edits as authoritative production input.
7. **Production and review stay independent.** The producing context may proofread its
   own work but may not issue the independent verdict.
8. **Preserve meaning.** Understanding a source does not grant permission to
   strengthen, broaden, or simplify its claims beyond its authority.
9. **Prefer the smallest sufficient mechanism.** The MVP is one skill plus necessary
   references, not an operational system around a skill.

When principles conflict, the earlier principle wins.

## 3. Capability boundary

### 3.1 The skill owns

- validating an already-authorised writing assignment;
- resolving the writing job before prose begins;
- confirming that source roles and claim permissions are explicit;
- identifying the asset or section's distinct contribution;
- eliciting and preserving authorised fragments, examples, observations, and language;
- separating material exploration from structural commitment;
- developing reader prerequisites, claim progression, argument, structure, and evidence
  placement;
- presenting bounded alternatives at load-bearing editorial choices;
- composing one agreed block, section, or beat at a time while preserving operator edits;
- drafting or revising within the approved boundaries;
- running production QA against the exact candidate produced;
- recording an explicit stop when source or decision authority is missing;
- preparing a bounded handoff for independent review and destination acceptance.

### 3.2 The skill does not own

- deciding business, research, or communication authority;
- discovering or classifying internal knowledge on the destination's behalf;
- selecting or conducting the underlying research route;
- granting permission to use, strengthen, or publish a claim;
- maintaining canonical message meaning or destination editorial policy;
- conducting its own independent review;
- granting destination acceptance or founder approval;
- publishing, scheduling, distributing, or repurposing the asset;
- maintaining cross-destination operational memory;
- writing outside the active destination's authorised working paths.

If fulfilling the writing request would require one of these actions, return control to
the authority that owns it. Do not absorb the action into Writing Studio for convenience.

## 4. Runtime and placement

### 4.1 Skill type

Writing Studio is a **Claude skill**, not a Codex skill, command, agent, workflow, or
repository.

### 4.2 Canonical and installed locations

- Canonical source: `ai-resources/skills/writing-studio/`
- User-scoped Claude installation target: `~/.claude/skills/writing-studio/`

The canonical source is the versioned authority. The installed copy or symlink is a
deployment surface, not a second editable source. The implementation phase must use the
repository's established resource-distribution mechanism rather than invent a new one.

### 4.3 Invocation for v0.2

Make v0.2 user-invoked:

```yaml
disable-model-invocation: true
```

The operator invokes `writing-studio` deliberately and names `Develop` or `Improve`.
This avoids an implicit-trigger collision while `article-production` still claims parts
of drafting and `article-review-gate` owns cold review.

Reconsider model invocation only after the first two real assignments demonstrate an
unambiguous destination-to-Studio handoff. Until then, no other skill may rely on
Writing Studio activating automatically.

### 4.4 Runtime tier

The work is judgment-heavy. The planned Claude frontmatter is:

```yaml
model: opus
effort: high
```

Do not declare a repository or workspace default model. These fields apply only when
this skill is invoked.

## 5. Trigger boundary

Use Writing Studio when the operator explicitly invokes it to develop or materially
improve substantive external writing of at least one meaningful section.

Representative requests:

- "Use Writing Studio Develop on this approved article package."
- "Use Writing Studio Improve on this pitch section; the argument is approved but
  the structure is not working."
- "Run the Writing Studio process on this authorised draft."

A **meaningful section** is a unit whose structure, argument, evidence treatment, or
claim wording affects what the reader understands or believes. A short passage may
qualify when it contains a consequential claim or canonical message.

Route elsewhere when the request is primarily:

- research collection or synthesis before writing readiness;
- source-authority classification;
- a short line edit that does not affect consequential meaning;
- cold review, approval, publication, or distribution;
- generic internal notes;
- writing without an authoritative owner for its claims.

## 6. Modes

### 6.1 Develop

Use Develop for a new substantive asset or section produced from an approved inbound
package.

The package must identify:

1. the asset specification;
2. the final permitted claim-and-evidence set;
3. the research or decision synthesis;
4. the source manifest and source roles;
5. limitations and unresolved questions;
6. destination communication and editorial authorities;
7. authorised working paths and acceptance owner.

Develop turns this package into an argument, structure, and candidate draft. It does
not repair an incomplete package by launching research or silently making decisions.

Develop contains two phases:

1. **Explore material.** Mine the authorised package and operator contributions for
   fragments without imposing article order. A fragment may be a claim, example,
   vignette, sharp sentence, analogy, tension, question, or candidate leading phrase.
   Preserve its source role and claim permission. A newly surfaced factual proposition
   remains an unresolved input until the destination authority permits it.
2. **Exploit material.** Freeze an identifiable material pile and select one composition
   branch:
   - **Shape** is the default for institutional, analytical, explanatory, and
     argument-led assets. Grow the reader journey block by block.
   - **Beats** is available for narrative, experiential, chronological, or
     journey-led assets. Grow the piece one narrative move at a time.

Shape and Beats are alternatives. Do not run Beats as an outline that Shape then expands.
If the composition method changes, start a new candidate path from the same material-pile
version or explicitly return to exploration.

### 6.2 Improve

Use Improve when an existing substantive asset or section has an authorised problem
to solve.

The input must identify:

1. the exact candidate being revised;
2. the stated problem or authorised review findings;
3. what must remain unchanged;
4. what may change;
5. what the revision must accomplish;
6. the governing evidence, policy, and write boundary.

Diagnose the causes of the stated problem before rewriting. This is production
diagnosis: it may determine why the specified section is not working, but it may not
expand into an independent cold review, reopen the thesis, or issue an approval verdict.

Improve normally uses the Shape discipline on the bounded revision area: identify the
reader's current grounding, define the block's job, and revise in agreed units. Use Beats
only when the authorised problem is the order or movement of a narrative passage. Improve
may derive a working material pile from the candidate and authorised findings, but it may
not use fragment exploration to reopen settled claims.

## 7. Universal pre-drafting gate

Drafting may begin only when all four elements are settled in writing:

1. **Settled job** — what asset or section is being produced, for whom, and what it
   must accomplish.
2. **Resolved source authority** — which repositories or documents govern each kind
   of claim and expression.
3. **Permitted claims** — what may be asserted, qualified, treated as hypothesis, or
   not used.
4. **Distinct contribution** — what this asset adds that the destination's existing
   assets do not already say.

For Improve, distinct contribution means the revised section's intended job within the
larger asset. The revision does not need to invent a new thesis.

The gate controls reader-facing candidate prose, not pre-drafting material exploration.
Before the gate passes, the skill may capture clearly labelled working fragments inside
the authorised topic and write boundary. Those fragments carry no permission into the
candidate: unsupported or undecided material must remain visibly unresolved and outside
the permitted material pile.

If any element is unresolved, stop with the exact marker:

`SOURCE_OR_DECISION_REQUIRED`

Record:

- what is unresolved;
- why it blocks drafting;
- the source or decision required;
- who owns it;
- what work may safely continue;
- what condition resumes the assignment.

Founder input may settle a founder-owned decision. It cannot turn missing evidence into
support or override another source's authority.

The pre-drafting gate is the skill's output gate. Do not add a second generic phrase such
as `RELEASE ARTIFACT`; obey an additional outline-approval gate only when the destination
requires one.

## 8. Source roles

Every material input must have one of four roles:

### Authority

May ground claims only within its declared domain:

- **Business authority** governs Axcíon's position, capability, and business decisions.
- **Research authority** governs empirical or analytical support and its limitations.
- **Communication authority** governs approved meaning, terminology, voice, and
  expression. It does not establish the underlying business or research truth.

### Approved communication

Shows what Axcíon has already said publicly or approved for communication. It may guide
consistency and reveal existing messages, but it does not automatically evidence the
truth of the underlying claim.

### Reference-only

May guide tone, structure, examples, comparison, or context. It may not support a claim.

### Excluded

Must not influence the candidate. Record why it is excluded when the reason is not
obvious from destination policy.

When two authoritative sources conflict within the same domain, stop and name the
conflict. Do not choose a winner from convenience, recency, or writing quality unless
the destination has already defined that precedence.

## 9. Assignment tiers

Tiering changes minimum interaction cadence and review requirements, not the authority,
grounding, or provenance method.

### Routine

Use for approved substance with bounded change, no new or sensitive claim, and no
canonical-message consequence.

Independent review is optional only when destination policy permits it and production
work reveals no uncertainty that warrants escalation.

### Consequential

Use for a new argument, thought leadership, core website or pitch copy, sensitive claim,
capability wording, canonical-message implication, or another destination-defined high-
stakes condition.

Independent review is mandatory.

Any escalation trigger wins. Ambiguity is Consequential. Destination policy may impose
stricter review but may not weaken this minimum.

## 10. Production lifecycle

Both modes follow one universal lifecycle. Mode references supply the branch-specific
method.

### Step 1 — Open the assignment

Identify the destination, asset, audience, mode, tier, owners, constraints, inbound
package, current candidate when applicable, and authorised write paths.

**Complete when:** every required input is located or the missing input is named in a
stop record.

### Step 2 — Read the governing context

Read the full authorised package, relevant communication canon, related assets, and
destination requirements. Follow citations only where required to resolve a load-bearing
claim, source role, contradiction, or limitation.

Answer:

1. What governs this job?
2. What has already been said?
3. What is missing or conflicting?
4. What must this asset contribute?

**Complete when:** all four answers cite their governing inputs and every material source
has a role.

### Step 3 — Test readiness

Apply the four-part pre-drafting gate.

**Complete when:** all four elements are settled in writing or the assignment has stopped
with `SOURCE_OR_DECISION_REQUIRED`.

### Step 4 — Define the production contract

Record:

- intended reader belief;
- practical implication;
- required constraints;
- what the asset must not become;
- acceptance owner and done condition.

**Complete when:** the contract can distinguish a successful candidate from an articulate
but wrong one.

### Step 5 — Explore the material

For Develop, mine the authorised package and operator contributions into one logical
material pile. Capture useful fragments without arranging them into article order. Preserve
the provenance and permission of every factual or canonical fragment; label unresolved
material so it cannot drift into candidate prose. Look for a leading phrase only when it
names an already-authorised idea more precisely rather than inventing a stronger claim.

For Improve, derive only the bounded material needed from the current candidate,
authorised findings, and preserved constraints. Skip open exploration when the material is
already sufficient.

**Complete when:** an identifiable material-pile version contains enough permitted material
to fulfil the production contract, or the missing material has produced a durable stop.

### Step 6 — Choose the reader journey

Select Shape or Beats and establish the reader's conceptual starting point:

- **prerequisites** — concepts the intended reader is expected to bring;
- **introduced concepts** — concepts the asset must ground before later blocks rely on
  them.

Maintain a compact grounding ledger for material concepts, not every familiar word. A
candidate unit is reachable only when all concepts it requires are already grounded.

**Complete when:** the composition branch is justified, the audience prerequisites are
explicit, and at least one authorised opening can be reached from them.

### Step 7 — Agree the entry path

For Consequential Develop work, present two or three genuinely different openings or entry
paths. They may vary the reader's entry point, emphasis, or form, but they must preserve the
same authorised thesis and claim permissions. Explain what each opening promises and what
later moves it enables. The operator chooses one or composes an authorised hybrid.

For Routine work with a locked route, present one proposed opening and invite correction;
generate alternatives only when a material editorial choice remains. Improve may retain the
existing opening when it is outside the authorised revision boundary.

**Complete when:** one opening is selected, its promise fits the production contract, and
the next move it requires is known.

### Step 8 — Compose in agreed units

Keep reader-facing copy separate from production notes. Before every write, re-read the
current candidate from disk and preserve operator edits. Then compose only the next agreed
unit:

- **Shape:** ask what the reader needs next, define what the block contributes that the
  previous block did not, and choose a defensible form such as prose, list, table, callout,
  quotation, or example. Offer alternatives at genuine structural pivots.
- **Beats:** offer two or three reachable next moves, state what each move grounds or
  unlocks, let the operator choose, and write that beat only.

Every unit must have one primary job, rely only on grounded concepts, introduce any new
concept before it is used, and trace every material claim to permitted support. Preserve
all evidence limits, qualifications, terminology conditions, and publication conditions.

For Consequential work, write one block or beat at a time. For Routine work, the operator
may approve section-sized batches after the entry path is settled. Never batch the whole
asset before its route is agreed.

Treat the material pile as a quarry, not a script: split, combine, paraphrase, or omit
fragments as the reader journey requires. If the journey needs material the pile lacks,
request an authorised contribution, cut the move, or explicitly return to exploration.
Returning to exploration creates a new material-pile version before composition resumes.

The asset ends when the reader journey fulfils the production contract, not when the pile
is empty. Unused fragments remain unused; they do not create an obligation to include them.

**Complete when:** one identifiable candidate exists in the authorised destination path,
the reader journey is complete, every material block earns its place, and no production
note appears in reader-facing copy.

### Step 9 — Run production QA

Bind QA to the exact candidate. Check authority, evidence and claim strength, argument,
distinct contribution, reader grounding, block function, opening promise, journey
completion, institutional register, repetition, contradiction, prohibited terminology,
and destination constraints.

Production QA is authoring hygiene, not independent review. Label it `independent: false`.

**Complete when:** every QA dimension has a recorded result and every material defect is
fixed or returned to its owner.

### Step 10 — Prepare the handoff

Return either:

- `READY_FOR_REVIEW` with the exact candidate identity and bounded reviewer packet; or
- `SOURCE_OR_DECISION_REQUIRED` with the durable stop record.

Writing Studio prepares the packet in v0.2. The destination workflow or operator invokes
the separate reviewer.

**Complete when:** the next authority can act without reconstructing the production
context and receives no material that would contaminate an independent cold read.

## 11. Durable assignment record

The skill defines required information, not a universal file schema. Map the following
fields into the destination's existing artifacts:

- assignment identity, mode, tier, and current outcome;
- destination owner, acceptance owner, and founder approver when applicable;
- authority references with identifiable versions;
- source roles and claim permissions;
- the four pre-drafting gate answers;
- production contract;
- input manifest and authorised write paths;
- material-pile identity, version, provenance, unresolved material, and unused fragments;
- selected composition branch and its rationale;
- audience prerequisites and material concept-grounding decisions;
- opening alternatives considered and the selected entry path when applicable;
- argument, block-function, form, and structure decisions;
- candidate identity and candidate lineage;
- production-QA result bound to that candidate;
- stop reason, owner, and resume condition when blocked;
- review, acceptance, and approval references when those events occur.

Use the destination's existing version identifier when it binds later decisions to exact
wording. Otherwise record a minimal candidate label plus a content hash. A material change
creates a new candidate identity and repeats production QA plus every affected downstream
gate.

Do not create a generic Studio assignment file when the destination already has safe homes
for this information.

## 12. Content Programme destination contract

For `axcion-content-programme`, use the existing article family:

- `articles/drafts/<slug>.md` — clean candidate article only;
- `articles/drafts/<slug>.notes.md` — assignment and production record;
- `articles/drafts/<slug>.research-brief.md` — destination-authorised research scope;
- `articles/drafts/<slug>.review.md` — reviewer-owned findings and gate result;
- `articles/published/<slug>.md` — accepted source after the required approvals.

Writing Studio may write only the authorised draft and notes paths. It may read an
authorised research brief or review findings. It does not write the review verdict, alter
project canon or policy, change research permission, move an article to `published/`, or
touch LinkedIn OS or another destination.

For the pilot, the material pile, pile version, grounding ledger, branch decision, and
opening choices live in `<slug>.notes.md`; `<slug>.md` remains clean reader-facing copy.
Create a separate material file only when Content Programme explicitly authorises that
destination-native path after the notes file proves insufficient.

The Content Programme handoff into Writing Studio is sufficient when its records state in
writing that the article or section is ready for production and identify the approved
package. v0.2 does not require a new universal readiness field.

`article-production` remains responsible for selection, research sizing and routing,
evidence readiness, and the permitted claim chain. `article-review-gate` remains responsible
for independent cold review and the publication-gate record. This specification does not
authorise modifying either skill before the Writing Studio pilot supplies evidence for the
exact boundary change.

## 13. Independent review handoff

The review packet contains only what the reviewer needs to judge the exact candidate:

- candidate wording and identity;
- authority and evidence mapped to material claims;
- intended audience and claimed reader prerequisites;
- distinct contribution;
- material limitations;
- production contract;
- destination constraints.

Exclude discarded openings, the internal grounding ledger, drafting rationale, production
self-assessment, earlier reviewer conclusions, and other material that would anchor a cold
reviewer unless the destination's review method explicitly requires it.

The reviewer returns findings against the exact candidate. Writing Studio may apply
authorised findings in Improve mode and return a new candidate for re-gating. It may not
issue or revise the independent verdict.

Destination acceptance and founder approval remain separate authority events. Founder
approval binds to exact final wording. A material later change repeats every affected gate.

## 14. Skill package specified for v0.2

```text
writing-studio/
├── SKILL.md
└── references/
    ├── develop.md
    ├── improve.md
    ├── production-qa.md
    └── review-handoff.md
```

### `SKILL.md`

Carry what every invocation needs:

- Claude frontmatter and manual-invocation choice;
- mode selection;
- capability and authority boundaries;
- pre-drafting gate;
- source roles;
- tier selection;
- universal lifecycle;
- destination-policy precedence;
- durable-record and write boundaries;
- failure outcomes;
- conditional pointers to the four references.

### `references/develop.md`

Read only in Develop mode. Specify inbound-package validation, governed fragment
exploration, material-pile versioning, Shape-or-Beats selection, reader grounding, opening
alternatives, interaction cadence, quarry treatment, clean candidate production, and
Develop-specific failure cases.

### `references/improve.md`

Read only in Improve mode. Specify production diagnosis, preserve/change/accomplish mapping,
bounded material extraction, reader grounding, Shape or Beats use, finding disposition,
candidate lineage, and escalation when the requested fix would alter authority or evidence.

### `references/production-qa.md`

Read after a candidate exists. Define the semantic QA dimensions, candidate binding, defect
disposition, and the boundary between self-check and independent review.

### `references/review-handoff.md`

Read only when the candidate is ready for separate review. Define packet contents,
contamination exclusions, version binding, and downstream authority events.

### Deliberately absent in v0.2

- No scripts: the difficult work is judgment, not deterministic transformation.
- No assets or assignment template: repeated use has not shown that destination-native
  records are insufficient.
- No README, implementation guide, changelog, command, agent, hook, checker, router,
  dashboard, or central index.
- No separate public `writing-fragments`, `writing-shape`, or `writing-beats` skills. Their
  useful mechanics are internal phases and branches of one governed Writing Studio entry
  point.
- No separate reference files for gates, source roles, or tiers: every mode needs them, so
  hiding them behind pointers would weaken the core path.
- No separate Shape and Beats reference files until forward tests show that keeping both
  branches in `develop.md` causes a real loading or attention failure.

## 15. Planned frontmatter contract

The implementation should begin from this shape, with the final description checked against
the completed body:

```yaml
---
name: writing-studio
description: Interactively develop or materially improve substantive external writing from an approved source and claim package inside the destination repository.
model: opus
effort: high
disable-model-invocation: true
---
```

Because v0.2 is user-invoked, the description is a human-facing one-line summary rather than
an always-loaded trigger catalogue.

## 16. Failure behaviour

- **Missing or conflicting authority:** write `SOURCE_OR_DECISION_REQUIRED`; name the
  conflict, owner, safe work, and resume condition.
- **Insufficient evidence:** preserve the gap; return it to the research or claim-permission
  owner. Do not browse around the authorised route.
- **Unsupported fragment:** keep it visibly outside the permitted material pile until its
  owner and permission are resolved.
- **Material gap during composition:** request an authorised contribution, cut the move, or
  return explicitly to exploration and create a new material-pile version. Do not invent a
  bridge merely because the reader journey needs one.
- **Composition branch no longer fits:** start a new candidate path from the same pile or
  return to exploration. Do not silently turn Beats into an outline for Shape.
- **Operator edit changes a material claim or opening promise:** preserve the edit, pause the
  next write, and repeat every affected authority, grounding, and candidate-lineage check.
- **Write boundary absent or unsafe:** make no destination edit; request an authorised path.
- **Candidate identity absent:** create or request a minimal version binding before QA or
  review handoff.
- **Requested improvement changes the thesis or claim permission:** return for authority
  rather than treating it as prose work.
- **Destination policy contradicts the universal method:** follow the stricter authority or
  safety rule; surface the conflict when precedence is not explicit.
- **Review requested in the producing context:** prepare the packet and route to a separate
  fresh context.
- **Information remains uncertain:** leave the gap visible. Prefer an incomplete but honest
  candidate or explicit stop over plausible invention.

## 17. Validation plan

Validation belongs to the later build phase. v0.2 specifies these required cases.

### 17.1 Structural validation

- Run the repository's skill validator.
- Confirm name, description, `model`, `effort`, and invocation fields follow current Claude
  conventions.
- Confirm every referenced file exists and is linked directly from `SKILL.md`.
- Confirm `SKILL.md` remains under the repository's 500-line budget.

### 17.2 Behavioural evaluation

Evaluate the completed candidate against the eight-layer AI-resource framework: purpose,
context boundary, interpretation, reasoning constraints, decisions, constraints, failure
behaviour, and output contract.

Run a fresh-context misinterpretation check against at least these readings:

1. "Develop may launch research when the package looks weak."
2. "Improve may independently review or approve the draft."
3. "Destination-local state means Writing Studio may invent a new destination schema."
4. "A fragment spoken by the operator is automatically authorised candidate material."
5. "Every Develop run must execute Beats and then Shape."
6. "Once the pile is fixed, the skill may draft the whole asset before the operator sees it."

The skill fails if a fresh executor can reasonably take any of those actions.

### 17.3 Forward test — Develop stop

Use Content Programme article two while its authorised evidence packet is incomplete.

Pass conditions:

- the four gate elements are tested before prose;
- the run stops durably with `SOURCE_OR_DECISION_REQUIRED`;
- no research is launched and no article prose is invented;
- no review, publication, or cross-repository write occurs.

### 17.4 Forward test — Develop success

Continue the same assignment after the authorised evidence package exists.

Pass conditions:

- an identifiable, provenance-bound material pile is fixed before composition;
- Shape is selected and justified for the argument-led fixture;
- reader prerequisites and material concept dependencies are explicit;
- two or three authorised entry paths are offered and the operator chooses one;
- composition proceeds in agreed blocks and re-reads intervening operator edits;
- claim limits survive into argument and prose;
- the journey completes without forcing unused fragments into the article;
- clean copy remains separate from production notes;
- the candidate and production QA are version-bound;
- the result is `READY_FOR_REVIEW`, never approved or published;
- the reviewer packet is bounded and uncontaminated.

### 17.5 Forward test — Beats branch

Use an isolated, authorised narrative fixture whose value depends on scene, sequence, or
experiential movement rather than a primarily institutional argument.

Pass conditions:

- Beats is selected for an explicit narrative reason, not by default;
- every proposed beat is reachable from the current grounded concepts;
- the operator sees two or three genuine next moves and only the chosen beat is written;
- an intervening operator edit changes what is offered next;
- the journey ends when its promise is fulfilled, even though material remains unused;
- the run does not expand the beats through a subsequent Shape pass.

### 17.6 Forward test — Improve

Use an isolated `test_only` copy of an existing section plus bounded, authorised findings.
Do not touch the live frozen article-one files.

Pass conditions:

- the causes of the stated problem are diagnosed before rewriting;
- sound material and locked meaning are preserved;
- each authorised finding receives a disposition;
- evidence-dependent or thesis-changing requests return for authority;
- the revision preserves operator edits and repairs only the authorised reader journey;
- a new candidate identity is produced;
- independent review remains separate.

### 17.7 Non-interference test

Across all tests, verify that the skill writes no run state into its own folder, creates no
global index, modifies no destination policy, and touches only explicitly authorised paths.

## 18. Adoption and retirement boundary

The skill is not adopted merely because its files validate. Adoption requires:

1. Develop stop behaviour observed;
2. Shape-based Develop success behaviour observed;
3. Beats behaviour observed on a genuinely narrative fixture;
4. Improve behaviour observed separately;
5. operator-edit preservation observed during incremental composition;
6. review independence and write boundaries verified;
7. operator acceptance of the demonstrated candidate.

Only after adoption may the new architecture be routed back into the existing Writing Studio
case. That later change must explicitly amend the V3 solution and implementation brief and
disposition the old repository plan. Do not rewrite that history from this specification.

## 19. Provisional choices to revisit after evidence

These are v0.2 defaults, not permanent architecture:

1. **Invocation:** remain user-invoked unless real handoffs show automatic invocation is both
   useful and unambiguous.
2. **Routine review:** keep independent review optional where destination policy permits; tighten
   if Routine assignments reveal semantic risk.
3. **Review dispatch:** prepare only; consider dispatching a fresh reviewer only if repeated runs
   create operator transport work.
4. **Assignment template:** add one only if two real destinations cannot map required information
   safely into existing artifacts.
5. **Content Programme integration:** narrow `article-production` only after a forward test shows
   the exact handoff that should replace its current drafting responsibility.
6. **Reference split:** add or merge references based on observed loading failures, not anticipated
   completeness.
7. **Interaction cadence:** keep Consequential work block-by-block; allow section-sized Routine
   batches only when pilots show no loss of authorship or semantic control.
8. **Material storage:** keep the pilot pile in destination notes; add a separate destination-native
   file only after observed size or editing friction.
9. **Branch exposure:** keep Shape and Beats internal; expose them as named operator choices only if
   users repeatedly need direct control over branch selection.

## 20. v0.2 completion condition

This specification is ready for its first refinement round when the operator can answer these
questions from the document without additional explanation:

1. What does Writing Studio own?
2. What must be settled before it writes prose?
3. Where does assignment state live?
4. How do Develop and Improve differ?
5. How do Explore, Shape, and Beats relate?
6. How does the method keep the reader conceptually grounded?
7. Where does the operator make load-bearing editorial choices?
8. What remains independent of the producing context?
9. What evidence is required before the skill can be adopted?

Unresolved wording, overbuilt structure, or a boundary the operator cannot explain back is a
v0.2 defect to revise here before implementation.
