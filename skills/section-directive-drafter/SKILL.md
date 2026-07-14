---
name: section-directive-drafter
description: >
  Transforms refined cluster analytical memos into structured section directives
  for report prose synthesis. Use when all cluster memos are reviewed and approved
  and the user needs directives specifying what each report section should accomplish,
  its target length, narrative positioning, emphasis guidance, hedging requirements,
  and known gaps. Triggers on requests like "draft section directives," "create
  directives from memos," "what should each section do," or when analytical memos
  are provided with expectation of synthesis preparation. Takes cluster analytical
  memos (from cluster-analysis-pass, refined) as input. Do NOT use before cluster
  memos are refined and approved, for writing actual report prose (that's
  evidence-to-report-writer), for designing document architecture from scratch
  without a pre-existing section list (that's research-structure-creator or manual
  architecture work), for style/voice decisions (that's specifying-output-style),
  or when memos have not been through editorial review.
model: opus
effort: high
---

# Section Directive Drafter

Produce structured editorial directives — one per report section — from refined cluster analytical memos. Directives tell `evidence-to-report-writer` what each section must accomplish, which evidence to use, how to weight it, and what to hedge. This skill produces editorial instructions, not prose.

## Pipeline Position

```
cluster-analysis-pass → gap-assessment-gate → [this skill] → evidence-to-report-writer
```

The output serves as Inputs 2 (Document Architecture) and 3 (Editorial Annotations) for `evidence-to-report-writer`.

## Input Requirements

Three inputs, two required:

1. **Refined cluster analytical memos** (required) — post-editorial-review, from `cluster-analysis-pass`. Each must contain: Key Findings (with `[SOURCE-GROUNDED]`/`[ANALYTICAL]` tags), Evidence Strength Map, Cross-Question Tensions, Gaps That Matter, and So What sections.

2. **Report section list** (required) — at minimum: section titles in sequence. May include brief scope descriptions. Can come from a document architecture draft, a table of contents sketch, or user-provided outline.

3. **Gap Assessment Report** (optional, recommended) — from `gap-assessment-gate`. Used to identify Accepted Gaps each section must acknowledge and residual Weakening gaps requiring hedging.

4. **Per-cluster permission tables (S-06)** (recommended when produced) — from `cluster-memo-refiner` Check 9 or `claim-permission-gate` (both write this path; the gate's table supersedes at Pass 3), located at `analysis/claim-permission/{section}/{section}-cluster-NN-permission-table.md` (one per cluster). Used to enforce the NOT-SUPPORTED refusal rule (see Procedure Step 3) and to set per-class prose constraints (see Directive Components → Permission-Class Constraints). **Each table MUST carry `chassis_version:` in its frontmatter, and this skill hard-exits on a missing or pre-`2026-07-14` value — see the chassis-provenance gate under Hard stop conditions.** If the project's memos pre-date Bundle 2b (no permission tables produced *at all*), the skill operates in a degraded mode — operator judgment fills the permission-class assignment, and the directive flags the absence so downstream `evidence-to-report-writer` knows to apply conservative defaults. **The degraded mode is for an ABSENT table, never for a STALE one:** an absent table flags every finding for review; a stale table yields confident wrong constraints that nothing flags. Never route a stale table into degraded mode.

### Validation

Before proceeding, verify:

- At least 2 cluster memos provided
- Memos contain identifiable findings with evidence strength indicators
- A section list with at least 2 sections exists
- If the section list exceeds 10 sections, flag that directive granularity may need to be reduced. Offer the user a choice: full directives for all sections (token-heavy), or full directives for priority sections + condensed directives for supporting sections.
- No unresolved **Blocking** gaps remain (check Gap Assessment Report if provided; if not provided, scan memo Gaps That Matter sections for anything that reads as Blocking-severity)

**Hard stop conditions:**
- Unresolved Blocking gap detected → Refuse. Direct user to `gap-assessment-gate`.
- No section list provided → Refuse. Request section list. Do not improvise a section structure.
- Memos appear unrefined (no editorial tags, raw cluster-analysis-pass output with unresolved tensions flagged for review) → Flag concern, ask user to confirm memos are final.
- **CLUSTER-INSUFFICIENT cluster present in permission tables (S-06 blocking-gate)** → If any per-cluster permission table flags `CLUSTER-INSUFFICIENT` (>30% NOT-SUPPORTED claims) and the operator has not invoked `OPERATOR-OVERRIDE`, refuse. Direct the operator to either supplement evidence for the blocked cluster via gap-filling research OR accept scope reduction (remove the affected cluster from the synthesis mandate, with its claims noted as gaps in the evidence-limitations back-matter).
- **⚠ STALE PERMISSION TABLE (chassis-provenance gate — check this FIRST, before drafting a single constraint, and HARD-EXIT on failure).** For **every** permission table supplied as Input 4, read its frontmatter `chassis_version:` field. **This skill requires `chassis_version: 2026-07-14` or later.** If the field is **absent**, or its date is **earlier than `2026-07-14`**, **REFUSE — do not draft a single Permission-Class Constraint from that table.** Emit: *"Permission table `{path}` was produced by chassis version `{version or 'unversioned (pre-2026-07-14)'}`. Its class verdicts were graded by a rule set with a known gap and an overlap and cannot be converted into prose constraints. Re-adjudication is required.*

  *__Do these in order — step 2 is NOT reversible by `git revert`:__ (1) **back-port** `§ Claim-Permission Classes` from the canonical `reference/quality-standards.md` into this project's own copy; (2) delete `analysis/{section}/.claim-permission-gate.done`; (3) re-run `/run-sufficiency {section}`; (4) re-invoke this skill."*

  **The ordering is load-bearing.** `claim-permission-gate` carries its own chassis-version hard exit, so deleting the sentinel *before* the back-port lands the operator in a **second** hard exit with the sentinel already gone and nothing to restore it. **Never print "delete the sentinel and re-run" without the back-port step first** — the first draft of this gate did exactly that and created a dead end (found by `/risk-check`, 2026-07-14).

  **The stamp must be EARNED, not merely PRESENT — check the re-stamp invariant too.** `chassis_version` is a self-asserted frontmatter field. A version check alone tests whether the file *claims* freshness, not whether its verdicts *are* fresh — and a hand-pasted line defeats it in one edit. So apply this invariant as part of the same gate:

  > **`generated_at` MUST be greater than or equal to `chassis_version`.** A table cannot have been produced *before* the rules that produced it existed.

  If `generated_at` precedes `chassis_version`, the table was **re-stamped, not re-adjudicated** — the body still carries verdicts graded under the old rules. **REFUSE**, and say so explicitly: *"Permission table `{path}` declares `chassis_version: {v}` but was generated `{generated_at}`, before that chassis existed. The stamp was added without re-adjudicating the claims. Delete `analysis/{section}/.claim-permission-gate.done` and re-run `claim-permission-gate` — do not hand-edit the version field."*

  **This is not a theoretical attack; it is the likely operator error.** `/run-sufficiency` explicitly documents a path where the operator edits a permission table by hand (§ *"a `claim-permission-gate` verdict the operator disputes → operator edits the affected table directly"*), and the refusal message above *names the field and the value it wants* — pasting one line is the path of least resistance out of a hard exit. The invariant costs nothing (both fields already exist) and it is what makes the stamp mean something. **Found 2026-07-14 by an adversarial run of this very gate: the first draft passed a table forged exactly this way.**

  **If the operator genuinely means to proceed on a stale table, route them to the override — do not let them invent a bypass.** Both fields are self-asserted, so two hand-edits will always pass this gate; that is an *override*, and this workflow has a real one. Say so in the refusal: *"To proceed deliberately on a table you know to be stale, use the documented `OPERATOR-OVERRIDE` path (signed `override_rationale:`, auto-logged to `/logs/decisions.md`) — do not edit the version fields. A silent frontmatter edit is an unlogged override, and nothing downstream can distinguish it from a real re-run."* **The gate stops neglect and carelessness. It does not stop intent, and it must not pretend to** — see `reference/quality-standards.md § Provenance is stamped on outputs` for the stated limit.

  **Why this is a hard exit and not a warning, and why the degraded mode below does NOT cover it.** This skill turns permission classes into the prose constraints that license what synthesis may assert — it is the last stage at which an over-claim can still be stopped. A **stale** table is strictly more dangerous than an **absent** one: absence routes to the degraded mode below, which flags every finding for operator review; staleness routes to confident, wrong constraints that nothing flags. **This is demonstrated, not hypothetical** (2026-07-14, by execution): re-adjudicating a real pre-2026-07-14 table under the current chassis moved **2 of 6 claims** from `PROXY-SUPPORTED` to `ILLUSTRATIVE-ONLY`, and a blind run of *this skill* against the stale table confirmed it would emit *"hedged framing required"* for both — **permitting two market-pattern generalizations the current rules forbid outright**, because `PROXY-SUPPORTED` carries no generalization prohibition and only `ILLUSTRATIVE-ONLY` does. The stale table also carried **zero** `[GENERALIZATION-CAPPED]` markers, so the disposition rule below never fired. Nothing in the pipeline surfaced any of it. **A silently laundered over-claim is the worst failure this skill can have; a hard exit is the correct trade.**

If findings across memos use inconsistent labeling (some use claim IDs, some use prose-only descriptions), flag the inconsistency and request standardization before proceeding.

## Procedure

### Step 1 — Build Claim Inventory

Extract every finding from all cluster memos into a flat inventory:

Per finding, capture:
- **Finding label** — short identifier (claim ID if available, or a generated tag like `C1-F3` = Cluster 1, Finding 3)
- **Content** — the finding statement
- **Tag** — `[SOURCE-GROUNDED]` or `[ANALYTICAL]`
- **Evidence strength** — Establishes / Suggests / Preliminary signal (from Evidence Strength Map)
- **Source cluster** — which cluster memo it comes from
- **Contributing questions** — which research questions feed this finding

**Field-exposure boundary (#15 two-field rule).** The Claim Inventory captures *contributing questions* for allocation and for the downstream cluster-memo / sufficiency-stage risk-tier lookup — but those are working inputs, not directive output. Do NOT surface the upstream **risk-tier** (Tier A–D) or **evidentiary-lens / independence-basis** axes in directive output: the directive's per-finding grading is the **claim-permission class** alone (the four-class S-06 label, applied in Permission-Class Constraints). The risk-tier and lens axes have done their control work by Stage 3 and live only in Stage-2 extracts and Stage-3 sufficiency tables (per `reference/quality-standards.md § Risk-Tier Model`). Tier/lens are control *inputs*, not editorial fields; carrying them into a directive would re-introduce a competing taxonomy the permission class already subsumes.

Also extract from each memo:
- Cross-Question Tensions (for tension-aware allocation)
- Gaps That Matter (for gap acknowledgment mapping)
- So What recommendations (for emphasis guidance)

### Step 2 — Map Claims to Sections

Allocate each finding to exactly one **primary section** where it receives full or summary treatment. A finding may have **secondary mentions** in other sections (brief reference, not re-development).

Allocation principles:
- Match finding content to section scope based on section titles and descriptions
- Findings that address a section's core question → primary allocation to that section
- Findings that provide context for another section's argument → secondary mention
- Cross-Question Tensions → allocate to the section where the tension is most consequential
- So What recommendations → use as tiebreaker when a finding could serve multiple sections

**During allocation:** If a finding with Establishes or Suggests strength cannot be mapped to any section based on scope, flag it immediately as an allocation failure. Present the finding and ask the user whether to expand an existing section's scope or add a new section. Do not proceed to Step 3 until all Establishes/Suggests findings are allocated. Preliminary signal findings that don't fit may be deferred to the orphan check.

**Orphan check (post-allocation):** Verify every finding with Establishes or Suggests strength lands in at least one section. Preliminary signal findings may be deliberately excluded if peripheral — list these as intentional exclusions with rationale.

**Duplication check:** No finding should receive full development treatment in more than one section. If the same finding is essential to two sections, designate one as primary (full development) and the other as secondary (brief reference with forward/backward pointer).

### Step 3 — Assign Emphasis

For each section's allocated findings, classify treatment level:

| Evidence Strength | Cross-Question Support | Treatment |
|---|---|---|
| Establishes + convergent (multiple questions) | High | **Full development** (80-120 words in final prose) |
| Establishes, single question | Medium-High | **Full development** |
| Suggests + convergent | Medium | **Standard treatment** (40-80 words) |
| Suggests, single question | Medium-Low | **Summary treatment** (20-40 words) |
| Preliminary signal | Low | **Brief mention or footnote** (≤20 words) |
| Analytical (model-identified pattern) | Varies | **Supporting role only** — never the lead claim in a paragraph |

Override with So What recommendations from cluster memos: if a memo recommends foregrounding a Suggests-level finding, elevate to Standard or Full development and note the override.

**Override precedence:** So What overrides apply only to a finding's primary section allocation. If a So What recommendation points to a finding allocated as secondary in a given section, first consider whether primary allocation should shift to that section. If reallocation isn't appropriate, the So What override does not apply to the secondary mention — note the tension in the directive.

### Step 4 — Calculate Length Targets

Estimate per section using evidence density:

```
Target = Σ (allocated findings × treatment word estimate) + framing overhead (50-80 words per section)
```

Round to nearest 50. Present as a range (e.g., 350-450 words) rather than a false-precision number.

If total across all sections exceeds a reasonable report length (flag if >5000 words for a typical knowledge base entry, >10000 for a full report), note the total and ask user whether to compress globally or split sections.

User can override any length target.

**Balance check:** If the longest section's target length exceeds the shortest by more than 3x, flag the imbalance before proceeding. Present the specific sections and their targets. Recommend whether to compress the heavy section, split it, or supplement the thin section with additional evidence. Do not proceed to Step 5 until the user acknowledges the imbalance or overrides.

### Step 5 — Draft Directives

Produce one directive block per section with all components (see Directive Components below).

### Step 6 — Cross-Section Coherence Check

Verify:
- **Dependency logic** — if Section 3 assumes the reader knows something from Section 2, the dependency is noted in both directives
- **No circular dependencies** — Section A cannot depend on Section B while B depends on A
- **Emphasis consistency** — the same finding isn't marked "foreground" in one section and "compress first" in another
- **Tension handling** — cross-question tensions are allocated to a single section for resolution, not split across sections
- **Narrative arc** — sections in sequence tell a coherent story (problem → mechanism → evidence → implication, or similar)

## Directive Components

Each section directive contains the following components. **Iteration note:** If this section exceeds ~15 components in future versions, extract the detailed definitions into a bundled reference file under this skill's `references/` directory and keep only the component list with one-line descriptions here.

### Section Objective
1-2 sentences: what this section must accomplish for the reader. Written as a reader-outcome statement: "After reading this section, the reader understands X and can Y."

### Reader Question
The single question this section answers (e.g., "Why does fund structure matter for investment strategy?"). Gives `evidence-to-report-writer` a framing anchor for the narrative opening.

### Claim Allocation
Compact list of finding labels allocated to this section with treatment level (e.g., `C1-F3 [Full], C2-F1 [Summary], C1-F7 [Brief]`). Full details (strength, tag, source cluster) live in the master Claim Allocation Summary — do not duplicate here.

### Target Length
Word count range. State the basis (evidence density calculation or user override). **Advisory when a report architecture exists:** this estimate is superseded by the depth allocation in the report architecture (`research-structure-creator` component 3), which is the authoritative band. Writers follow the architecture band; no per-chapter Override entry is needed when the two disagree.

### Narrative Positioning
Where in the report this section sits. Specify:
- What the reader already knows (from prior sections)
- What this section sets up for later sections
- Dependencies on other sections (explicit forward/backward references)

### Emphasis Guidance
- **Foreground** — findings to develop fully, with reasoning
- **Supporting** — findings for standard treatment
- **Compress first** — findings to sacrifice first if section runs long (pre-approved compression priorities for `evidence-to-report-writer`)

### Hedging Requirements
Findings requiring hedging language, mapped mechanically from Evidence Strength Map:

| Strength Label | Required Hedging |
|---|---|
| Establishes | None — state as firm ground |
| Suggests | Moderate hedging ("evidence suggests," "indicators point to") |
| Preliminary signal | Strong hedging ("early signals indicate," "tentative evidence") |
| Analytical (model pattern) | Frame as observation, not finding ("a pattern emerges across," "taken together, the evidence points toward") |

List each finding requiring hedging with its required level.

### Known Gaps
Gaps this section must acknowledge, pulled from cluster memo Gaps That Matter and/or Gap Assessment Report Accepted Gaps. For each:
- What is missing
- Recommended acknowledgment approach (brief caveat, explicit limitation statement, or scope boundary note)

### Cross-Section Dependencies
Explicit setup/payoff relationships:
- "Sets up [Section X] by establishing [concept]"
- "Assumes reader has encountered [concept] from [Section Y]"
- "Resolves tension introduced in [Section Z]"

### Permission-Class Constraints (S-06)

Per-section enforcement of `reference/quality-standards.md § Claim-Permission Classes`. The directive references the per-cluster permission tables (where available) and translates them into per-finding prose constraints. Each finding allocated to the section carries one of four permission classes from its source cluster's permission table:

| Permission class | Prose constraint |
|---|---|
| `SUPPORTED` | Plain assertion permitted. Use verbs from the permitted list: shows / confirms / establishes / demonstrates / records. No hedging required. |
| `PROXY-SUPPORTED` | Hedged framing required. Use verbs: suggests / is consistent with / points to / indicates. Must include proxy nature inline (e.g., "evidence above the project's deal-size lens suggests…") or in a load-bearing caveat. |
| `ILLUSTRATIVE-ONLY` | Illustrative framing required. Use verbs: illustrates / shows in one named case / appears in / reports (single-sourced). MUST NOT support a market-pattern claim — the directive explicitly prohibits writing the finding as if it generalized. **A single-sourced datum that is not a named case** (e.g. one regulator statistic) also lands in this class: it may be stated, **attributed to its source**, as the single attested figure — it simply cannot ground a generalization. |
| `NOT-SUPPORTED` | **Directive MUST NOT instruct synthesis to make this claim.** If the finding is thematically required by the section's narrative, the directive instructs `evidence-to-report-writer` to frame it as a "monitoring hypothesis" (S-15 routing deferred to post-R2 review per v6; until S-15 lands, operator judgment fills the framing). **`NOT-SUPPORTED` means *unsupported*, never *false*** — the directive may not instruct synthesis to assert the claim's **negation** either. Both are unstateable. See chassis § Evidenced Negatives vs Absence of Evidence. |

**⚠ `[GENERALIZATION-CAPPED]` rows require a disposition — do not pass them through (2026-07-14).** A permission table row may carry `ILLUSTRATIVE-ONLY [GENERALIZATION-CAPPED]`. That row is **self-contradictory on its face**: the claim *text* is a generalization, but its class forbids stating one. This is not an error — `claim-permission-gate` carries claim text verbatim and cannot rewrite it, so the capped row is how it hands the problem forward. **The directive must resolve it**, one of two ways:

- **Narrow (preferred).** Instruct synthesis to state only what the instances actually attest — the specific cases, not the pattern. This preserves the finding at the scope its evidence supports.
- **Omit.** If it cannot be narrowed, drop it from the section's synthesis mandate and note it in the evidence-limitations back-matter.

**Never instruct synthesis to restate the generalization under a hedge.** `ILLUSTRATIVE-ONLY`'s verb list does not license it, and hedging a generalization the evidence cannot carry is precisely the laundering the permission gate exists to prevent. A `[GENERALIZATION-CAPPED]` row also signals that `cluster-memo-refiner` Check 9 failed to narrow the finding upstream — worth flagging to the operator.

**A `[POPULATION-LEVEL-UNVERIFIED — operator review]` flag is a memo defect, not an evidence verdict.** The finding may be well-evidenced; its memo simply failed to record *why* it may generalize. Do not treat it as weak evidence. Surface it for operator review and, where possible, route it back for memo completion rather than degrading the finding.

**Verb-list enforcement (handed off to `chapter-prose-reviewer` Stage 4.3):** the directive flags any allocated finding whose intended verb pairing would violate the permission class — e.g., `establishes` paired with a PROXY-SUPPORTED finding. The flag is informational at directive time; the enforcement gate is at Stage 4.3.

> **⚠ The Stage-4.3 gate this hands off to does not exist as described (verified 2026-07-14).** `chapter-prose-reviewer` contains **zero permission-class vocabulary** — the same is true of `evidence-to-report-writer`, `citation-converter`, and `cluster-synthesis-drafter`. **This skill's per-class prose constraints above are, as of this date, the *only* place the permission classes actually shape prose.** The "informational at directive time; enforced at 4.3" split is therefore false in the second half: nothing enforces at 4.3. Treat the constraints above as the **real** control, not a preliminary flag, and write them into the directive with that weight. Routed as an open finding on mission `research-workflow-deploy-fitness`.

**Degraded mode (no permission tables available):** if Input 4 was not provided (memos pre-date Bundle 2b), the directive falls back to Hedging Requirements (existing component) and flags every finding lacking a permission class for operator review before synthesis. The directive's Permission-Class Constraints section is populated with "[NO PERMISSION TABLE — operator review required]" placeholders.

## Output Structure

```markdown
# Section Directives: [Report Title]

## Narrative Arc
[3-5 sentences: how the sections connect as a whole argument]

## Claim Allocation Summary
[Master table: all findings, their primary section, treatment level — one glance view]

## Section Directives

### Section 1: [Title]
[All directive components]

### Section 2: [Title]
[All directive components]

[...repeat for each section]

## Orphan Check
[Findings not allocated to any section, with rationale for each exclusion]

## Dependency Map
[Which sections reference/set up which others — as a simple list or matrix]
```

## Completion Checklist

Before presenting directives (even in refinement mode), verify all of the following. Any failure is a hard stop requiring resolution before proceeding.

1. **Full allocation** — Every finding with Establishes or Suggests strength is allocated to exactly one primary section. Preliminary signal exclusions are listed with rationale in Orphan Check.
2. **No duplication** — No finding receives full development treatment in more than one section. Secondary mentions are brief references only.
3. **Complete directives** — Every section has all directive components populated (Section Objective, Reader Question, Claim Allocation, Target Length, Narrative Positioning, Emphasis Guidance, Hedging Requirements, Known Gaps, Cross-Section Dependencies). Components may state "None applicable" but cannot be omitted.
4. **No circular dependencies** — The Dependency Map contains no cycles (Section A → B → A).
5. **Balance acknowledged** — If the longest section exceeds the shortest by >3x, the imbalance is flagged and user has acknowledged or overridden.
6. **Hedging mapped** — Every Suggests, Preliminary signal, and Analytical finding has an explicit hedging requirement in its section directive matching the Hedging Requirements table.
7. **Permission classes enforced (S-06)** — When permission tables are provided (Input 4), every allocated finding in every section has a Permission-Class Constraints entry matching its class from the source cluster's permission table. No NOT-SUPPORTED finding is allocated for synthesis development; any thematically-required NOT-SUPPORTED claim is flagged for monitoring-hypothesis framing. If permission tables are absent, every finding carries a "[NO PERMISSION TABLE — operator review required]" placeholder in the section's Permission-Class Constraints.

## Evidence Integrity Rules

- Operate only from provided memos. Do not supplement with external knowledge about what the report "should" cover.
- Preserve evidence strength labels exactly as they appear in cluster memos. Do not upgrade or downgrade.
- If a memo's So What recommendation conflicts with evidence strength (e.g., recommends foregrounding a Preliminary signal finding), follow the recommendation but flag the override explicitly in the directive.
- Claim allocation must be traceable — every finding in the directive output must map to a specific finding in a specific cluster memo.
- Gaps in directives are acceptable. If a section's scope cannot be fully specified from available memos, say so. Do not invent editorial direction to fill the gap.

## Output Protocol

**Default mode: Refinement**

Present the Claim Allocation Summary table and Narrative Arc first. This lets the user redirect emphasis, adjust section scope, or override allocations before the full directive set is generated.

**Do not produce the full directive set until user says `RELEASE ARTIFACT`.**

When user says `RELEASE ARTIFACT`:
- Write the complete directive set to a file (e.g., `section-directives.md` in the active workflow directory)
- Provide a brief summary of what was created

## Edge Cases

**More sections than clusters:** Some sections may draw from a single cluster or a subset. This is normal — directives still specify all components.

**More clusters than sections:** Multiple clusters feed one section. The directive must be explicit about which cluster's findings take priority when emphasis conflicts arise.

**Section with no strong evidence:** If all allocated findings are Suggests or Preliminary signal, the directive should recommend a short section length, heavy hedging, and flag whether the section should be retained or merged into an adjacent section. Present as a recommendation, not an automatic decision.

**Findings that don't fit any section:** List in Orphan Check. Recommend either adding a section, expanding an existing section's scope, or explicitly excluding with rationale.

**User provides section list mid-conversation:** Accept and proceed. Do not require a separate invocation.
