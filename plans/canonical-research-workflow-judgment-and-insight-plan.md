# Canonical Research Workflow — Judgment, Insight, Depth, and Parallel Research Plan

**Date:** 2026-08-17  
**Status:** Proposed  
**Primary owner:** `ai-resources` canonical research workflow  
**First consumers:** Axcíon Sector Intelligence and Axcíon Content Programme

## Operating outcome

The canonical research workflow should support this sequence:

```text
research → interpretation → Axcíon judgment → approved House View → publishing
```

For serious content-supporting research, article development must not begin until the founder has approved, changed, or rejected the proposed House View.

The workflow should also:

- extract externally useful insights rather than return only information;
- distinguish assignment-level Light, Standard, and Deep research modes;
- preserve evidence, provenance, and visible uncertainty proportionately in every mode; and
- test bounded parallel research before adopting multi-agent execution as a normal technique.

## What exists today

Sector Intelligence already contains a local judgment-layer implementation at the Stage 3→4 boundary.

Its flow is:

```text
evidence sufficiency
→ proposed Unit Judgment Brief
→ explicit operator approval
→ approved Unit Judgment Brief
→ section directives
→ cluster synthesis
→ report architecture and prose
```

The implementation includes:

- proposed and approved forms of a Unit Judgment Brief;
- an unconditional human approval halt with no inferred or automatic approval;
- mechanical promotion so the approved analytical content is identical to the proposal the operator reviewed;
- fail-closed checks in `/run-analysis`, `/run-synthesis`, and `/run-report`;
- propagation of the approved brief and judgment standard into section directives, cluster synthesis, report architecture, and report prose; and
- separate regression checks for artifact validity, authority gating, proposal production and approval, and downstream propagation.

The four regression suites were rerun during this investigation. Result: **82 passed, 0 failed**.

The local implementation is documented in:

- `projects/axcion-sector-intelligence/reports/analyst-judgment-layer-implementation-research-v1.md`
- `projects/axcion-sector-intelligence/logs/work-loop/analyst-judgment-layer-local-pilot.md`
- `projects/axcion-sector-intelligence/logs/work-loop/judgment-layer-workflow-integration.md`

## Material limitations of the local pilot

The existing pilot is the correct substrate, but it should not be copied verbatim.

1. **It is local, not canonical.** The pilot explicitly deferred adoption in `ai-resources`.
2. **It has not completed a representative end-to-end operating trial.** The tests prove the wiring and failure behavior, not the quality and usability of a real production run.
3. **Editorial/compliance QC is unwired.** Four authoring consumers receive the approved judgment; the independent QC consumer does not.
4. **It contains Sector Intelligence assumptions.** These include M&A-specific language, `Core / Adjacent / Selective / Avoid` verdicts, buyer-fit framing, and a literal Chapter 7 consolidation rule.
5. **It uses an inline producer rather than the recommended canonical producer skill.** Canonical adoption should establish a reusable producer contract.
6. **The brief predates the fuller House View and external-insight requirements.** Its current shape is narrower than the proposal in this plan.

## Core design decision

Retain the existing artifact concept and name: **Unit Judgment Brief**.

Expand it so that it becomes the vehicle for:

- external insight extraction;
- competing interpretations;
- the proposed Axcíon House View;
- confidence and invalidation conditions; and
- the founder's approval decision.

Do not create a separate insight report, House View report, new top-level command, sixth workflow stage, or semantic hook. One approved cross-unit artifact should remain the single analytical authority downstream.

## Canonical sequence

The existing Stage 3→4 boundary should become:

```text
gap resolution complete
→ produce proposed Unit Judgment Brief
→ independent judgment QC
→ founder review
→ approve, revise, or reject
→ mechanically promote approved brief
→ section directives
→ cluster synthesis
→ report or content architecture
→ prose
```

Every report-bound re-entry point must validate the approved brief independently. A session starting at `/run-synthesis` or `/run-report` cannot assume another session passed the approval gate.

## Expanded Unit Judgment Brief contract

### Evidence and interpretation

The brief must include:

1. **Evidence** — what is known, tied to existing claim IDs.
2. **Conventional interpretation** — the obvious or mainstream explanation.
3. **Candidate Axcíon interpretations** — three to five plausible readings of the evidence.
4. **Countercase** — why each material interpretation could be wrong, or the strongest limiting alternative.
5. **Company-level implications** — which kinds of businesses are affected and how.
6. **Buyer/investor implications** — why an acquirer or investor could care.
7. **Proposed House View** — what Axcíon currently believes.
8. **Confidence** — High / Medium / Low, with a reason.
9. **What would change the view** — observable evidence, events, or diligence findings that would invalidate or materially alter the view.

### External insight extraction

Every content-supporting brief must return:

- most important finding;
- most surprising finding;
- strongest statistic;
- most interesting comparison;
- strongest contradiction with conventional wisdom;
- second-order implication;
- company-level implication;
- investor implication; and
- potential article thesis.

Each item must retain its evidence basis and must not be promoted above the permission class of its load-bearing claims.

### Insight ladder

The brief must state how far its strongest publishable insight reaches:

```text
Level 1 — Fact
Level 2 — Observation
Level 3 — Interpretation
Level 4 — Company implication
Level 5 — Strategic implication
```

A major article should normally reach Level 4 or Level 5. This is a semantic publication-readiness judgment, not a mechanical label check. A reviewer must judge whether the reasoning actually reaches the claimed level. A founder may approve a lower-level piece only with an explicit reason, such as a deliberately descriptive research note whose evidence is itself the contribution.

## Evidence and context boundary

The producer receives two visibly separate input bundles.

### Evidence bundle

Determines what may be concluded about the subject:

- refined cluster memos;
- claim-permission tables and gate-clearance caveats;
- resolved gap assessment;
- scarcity register;
- country-parity and source-conflict outputs where applicable; and
- existing claim IDs for every load-bearing factual premise.

### Axcíon context bundle

Determines why a conclusion matters and how it may be framed:

- a project-owned Axcíon Judgment Context Card;
- approved Task Plan and Research Plan;
- relevant positioning and audience constraints; and
- dated operator decisions made after those plans.

The governing rule is:

> Context affects relevance and framing, never evidence grade.

Context may not strengthen an evidence grade, close a gap, turn a hypothesis into a market fact, or convert a failed search into proof of absence.

## Founder approval contract

The proposed brief is not authority.

The founder may:

- **approve** it;
- provide revision directions, after which the proposal is revised and presented again; or
- **reject** it, which stops report/content development or returns the work to research and reframing.

Approval must be explicit. Silence, a timeout, an ambiguous response, or approval of an adjacent artifact cannot approve the brief.

After approval, the proposal must be mechanically promoted. The analytical content the founder reviewed must be carried into the approved artifact byte-for-byte; only approval metadata and the status/banner may change.

## Downstream behavior

### Section directives

Every directive identifies which approved thesis it supports, qualifies, or challenges. It carries the thesis, relevant claim IDs, commercial significance, competing signal, limiting caveat, and narrative payoff.

### Cluster synthesis and report prose

Writers express and connect approved analysis in evidence-led prose. They may not:

- invent a new implication;
- silently settle an unresolved tension;
- exceed a claim's permission class;
- drop a material caveat; or
- treat Axcíon context as external evidence.

### Architecture

The architecture maps each approved thesis across the narrative: introduced, developed, qualified, and consolidated. Project-specific conclusion rules belong in the project context or document architecture, not in the canonical standard.

### Independent QC

Architecture, chapter, and compliance QC must test:

- every material judgment maps to the approved House View;
- factual premises retain appropriate citations;
- no new thesis or implication is invented downstream;
- counterevidence and limiting caveats survive;
- Axcíon context is not used as proof of an external fact;
- material charts and tables are interpreted rather than merely displayed;
- the reader can identify the point, commercial significance, and confidence without doing the analytical work; and
- the conclusion consolidates rather than originates material judgments.

## Light, Standard, and Deep research modes

These should be treated as an assignment-level workflow-effort axis. They must not be collapsed into either existing axis:

| Axis | Question answered |
|---|---|
| L1–L3 knowledge depth | How deeply must this question be understood? |
| Tier A–D control effort | How much evidence-control effort does this question deserve? |
| Light / Standard / Deep research mode | How much workflow machinery does this assignment need? |

The three axes coexist. A Light assignment may still contain one load-bearing Tier A question. A Deep assignment may contain L1 contextual questions.

### Light

Suitable for:

- quick meeting preparation;
- simple company questions;
- article orientation; and
- small internal checks.

Expected behavior:

- sourced and provenance-visible;
- narrow question set and bounded search;
- compact evidence and uncertainty record;
- no major publishable market-pattern claim without escalation; and
- no automatic exemption from full controls for a load-bearing question.

### Standard

Suitable for:

- company research;
- buyer research;
- normal sector work; and
- commercial briefs.

Expected behavior:

- default assignment mode;
- formal research plan and evidence extraction;
- permission and sufficiency controls;
- House View when the output supports content, advice, or a recommendation; and
- proportionate independent challenge and QC.

### Deep

Suitable for:

- market studies;
- major strategic decisions;
- M&A investigations;
- Evidence Packs; and
- consequential claims requiring detailed challenge.

Expected behavior:

- full source ladder;
- systematic counter-search;
- comprehensive permission and sufficiency adjudication;
- independent judgment challenge;
- complete evidence and provenance chain; and
- the full House View and publishing handoff where content is in scope.

The current canonical workflow is sufficiently heavy that its actual mapping to Standard or Deep must be measured rather than assumed.

## Bounded multi-agent research experiment

Do not build a general agent swarm. Test one optional execution pattern through the existing execution manifest.

### Experimental design

Select one genuine Sector Intelligence or buyer-research assignment and run it twice:

1. **Baseline:** the normal research path.
2. **Bounded parallel variant:**
   - agent 1 — market structure and dynamics;
   - agent 2 — companies, competitors, and transactions;
   - agent 3 — risks, disconfirming evidence, and challenge;
   - lead agent — synthesis into the same canonical evidence and judgment artifacts.

Hold constant:

- approved scope and research questions;
- source policy;
- time or effort budget;
- output schemas; and
- acceptance standards.

Compare:

- evidence coverage;
- unique useful primary sources;
- contradictions and counterevidence found;
- duplicate work;
- wall-clock time;
- operator intervention;
- synthesis burden;
- quality of the final House View; and
- total review burden.

If bounded parallel research clearly improves the result, add it as an optional `bounded-parallel` execution pattern in the existing manifest. Do not make it the default and do not create autonomous coordination or shared-memory machinery.

## Implementation sequence

### Unit 1 — Representative local operating trial

Run one genuine Sector Intelligence unit through the existing local judgment implementation.

Prove:

- a real proposal can be produced from live evidence;
- founder revisions and approval work as intended;
- approved judgment materially shapes directives and prose;
- no downstream component invents an unapproved thesis; and
- review and token burden are acceptable.

This satisfies the pilot's explicit prerequisite before canonical rollout.

### Unit 2 — Canonical artifact foundation

Add the generalized canonical standard, Context Card template, Unit Judgment Brief template, file conventions, required-reference documentation, promotion helper, validators, and falsifiable regression fixtures.

Do not alter orchestration in this unit. The dominant deliverable is the portable, machine-checkable artifact contract.

### Unit 3 — Producer, QC, and founder approval path

Create the reusable Unit Judgment Brief producer. Add the independent judgment QC step and the explicit founder approval/revision/rejection flow. Verify re-entry across absent, proposed, rejected, malformed, and approved states.

### Unit 4 — Canonical Stage 3 orchestration

Change `/run-analysis` so the approved brief is required before section directives. Add the canonical fail-closed preflight and its command-path tests.

### Unit 5 — Downstream propagation and QC

Update `/run-synthesis`, `/run-report`, authoring skills, architecture QC, chapter review, and compliance QC. Prove both existence enforcement and actual content propagation.

### Unit 6 — Deployment and synchronization

Update:

- `workflows/research-workflow/SETUP.md`;
- `docs/required-reference-files.md`;
- `reference/file-conventions.md`;
- deployment placeholder/reference contracts where needed;
- `/deploy-workflow`; and
- `/sync-workflow` coverage for the new scripts and reference files.

Canonical and deployed project copies must be assessed separately. A canonical change does not automatically update every project-owned command or reference file.

### Unit 7 — Content Programme integration

The Content Programme's full-research path currently moves from synthesis to article hypotheses and drafting. Insert the approved-House-View handoff before article development.

Its partial research-workflow deployment is customized:

- research artifacts live under `research/` rather than at project root;
- the unit is an article rather than a multi-chapter report; and
- its local commands and references contain project-specific path and voice adaptations.

Therefore propagation must be an explicit project adaptation with path tests, not a blind canonical copy.

If Editorial V1 is still live, update its full-research handoff. If Editorial V2 has been activated by then, place the same gate between its research stage and final argument-map stage. Do not update a superseded workflow as though it were live.

### Unit 8 — Research-mode experiment

Run representative Light, Standard, and Deep assignments through one shared phase model. Measure quality, time, artifact count, operator intervention, and whether controls were proportionate. Use the evidence to settle the exact mode matrix and default.

### Unit 9 — Multi-agent comparison

Run the bounded baseline-versus-parallel experiment described above. Adopt an optional parallel pattern only if it clearly improves quality or speed without imposing disproportionate synthesis and review costs.

## Verification strategy

### Structural contract tests

Reject:

- absent brief;
- proposed brief presented as authority;
- rejected brief;
- approved brief with no approver;
- approved brief with no claim IDs;
- missing required House View sections;
- missing confidence or invalidation condition;
- malformed insight ladder; and
- approved content that differs analytically from the reviewed proposal.

Accept one minimal valid approved brief.

### Command-path tests

Prove that real command paths:

- produce the proposal before expecting the approved artifact;
- halt for explicit founder approval;
- resume safely without overwriting a proposal under review;
- fail closed before every report/content-authoring dispatch; and
- pass the approved brief and judgment standard as operative inputs rather than unused paths or attachments.

### Semantic evaluation

Independent reviewers assess representative pre/post outputs. Acceptance requires:

- every material judgment maps to permitted evidence and the approved brief;
- the conventional interpretation and strongest countercase are treated fairly;
- the selected House View explains why it outweighs alternatives;
- confidence matches the evidence;
- invalidation conditions are observable;
- the insight ladder level is earned rather than asserted;
- company and investor implications are specific and bounded; and
- downstream prose is more decision-useful without becoming inflated, repetitive, or formulaic.

### Operating proof

Run one real Sector Intelligence case and one real Content Programme case. The canonical capability is not ready for broad adoption until both the research workflow and its first publishing consumer operate successfully through the new handoff.

## Explicit non-goals

- No sixth research stage.
- No separate House View report alongside the Unit Judgment Brief.
- No semantic enforcement hook.
- No new identifier system for judgment or context.
- No automatic founder approval.
- No hard-coded M&A verdict vocabulary in canonical files.
- No hard-coded Chapter 7 rule in the canonical standard.
- No three unrelated research workflows.
- No general agent swarm, shared autonomous memory, or agent organization simulation.
- No canonical rollout before the representative local operating trial.

## Completion condition

The work is complete when:

1. the canonical workflow produces one evidence-grounded, independently reviewed, founder-approved House View before report or serious content development;
2. external insight extraction and the insight ladder are explicit and traceable;
3. all report-bound re-entry paths fail closed without valid authority;
4. authoring and QC consumers receive and enforce the approved judgment;
5. Sector Intelligence and Content Programme both pass representative operating trials;
6. Light, Standard, and Deep have been empirically calibrated rather than merely named; and
7. bounded parallel research has been adopted or rejected on measured evidence.
