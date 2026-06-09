# Quality Control Standards — {{PROJECT_TITLE}}

> **Chassis status.** Source-pipeline chassis landed FX-B4 (2026-05-27). Deferred items pending: S-08, S-09, S-14, S-15, S-17, S-18 — see project's v6 Post-R2 Review Trigger for the activation timing of these items.
>
> **Tunable-vs-immutable boundary.** This chassis distinguishes project-tunable fields from canonical-immutable rule structure:
> - **Project-tunable** (declared via `{{...}}` placeholders): per-claim-type evidence thresholds (see `reference/claim-permission.md` — project-fillable, derived from `claim-permission.template.md`); blocking-gate thresholds `{{CLUSTER_BLOCK_THRESHOLD}}` and `{{SECTION_BLOCK_THRESHOLD}}`; freshness-period date ranges; `{{PROJECT_TITLE}}`.
> - **Canonical-immutable** (must not be rephrased or reordered without `/risk-check` re-fire): the four permission-class names, the permitted-prose-verb lists, the six structural section headings (§ Claim-Permission Classes, § Source-Diversity Matrix, § No-Source-Substitution Rule, § Country Coverage Table, § Research Stop Conditions, § Source-Conflict Resolution Procedure), the gate-clearance artifact schema.
>
> **When to read this file.** When running QC checks, applying fixes to prose, or handling evidence gaps. Not needed for every turn.

## Evidence-First Principle (Project Operating Rule)

Do not optimize for answering the research question. Optimize for finding the strongest available evidence class. If only weak or proxy evidence is available, preserve the weakness in the output. Do not compensate for weak evidence with stronger prose.

This principle takes precedence over all other Stage 2 and Stage 3 behavior rules. When in conflict with any other rule, this principle wins.

## Core QC Principles

- QC checks are deterministic and binary (PASS/FAIL).
- QC is separated from remediation — identify problems in one step, fix in a separate step.
- Every finding carries severity classification (BLOCKING / NON-BLOCKING) and a proposed fix.
- Cross-model verification: no model reviews its own output.

## Evidence Calibration

Project's epistemic-label framework. Project may extend or recalibrate; the four-tier shape is canonical.

- **Tier 1 (Fact):** named transaction, event, or directly-attested datum.
- **Tier 2 (Reported):** advisory-report aggregate, trade-body statistic, regulator publication.
- **Tier 3 (Interpretive):** sponsor or commentator opinion, analyst framing.
- **Tier 4 (Inferred):** executing AI inference — always flagged.

## Uncertainty Disclosure and Caveat Routing

Every analytical output states evidence limitations explicitly. Caveat routing:

- **Load-bearing caveats** (inline, at point of claim): the caveat changes how the immediate claim should be read or applied; the reader cannot interpret the claim correctly without seeing the caveat at the point of reading.
- **Non-load-bearing caveats** (route to back-matter "Evidence Limitations & Open Questions" section): per-paragraph evidence-quality hedges that explain methodology, source reliability, or evidence completeness without changing the immediate claim's meaning.

**Test:** If removing the caveat changes how the reader should act on the immediate claim, it is load-bearing — keep inline. If removing it loses no actionable information at the point of reading, route to back-matter.

## Bright-Line Rule

Defined in the main CLAUDE.md. Applies at: Step 4.2, Step 5.2, Step 5.7, and `/verify-chapter`. Before ANY fix to report prose, check:

1. Multi-paragraph scope? → PAUSE
2. Analytical claim alteration? → PAUSE
3. Sourced statement modification? → PAUSE

If ANY true → do not apply without operator approval. Log to `/logs/decisions.md`.

## Claim ID Invariant

Every discrete factual assertion that can appear in report prose MUST have a Claim ID before it enters any downstream artifact. The pipeline has one primary ID assignment point (Step 2.3) plus two supplementary entries: Step 2.S4 (`supplementary-evidence-merger` assigns `Q[n]-C[##]` continuing the extract sequence; block-level findings decomposed first), and Step 3.S3 (gap-fill evidence written to a lightweight extract file with `GF[cluster]-C[##]` IDs before merging into memos).

**Test:** If a claim can be cited independently in report prose, it needs an ID. No `[CITATION NEEDED]` tags should reach Stage 4 prose except for genuine analytical inferences synthesizing across multiple claims without a single supporting source.

**QC check:** Step 3.7 (synthesis) flags any finding without a traceable Claim ID. Step 4.2 (report writing) blocks if the source is known but the ID is missing — assigned upstream first.

## Evidence Scarcity Handling

When supplementary research exhausts maximum passes (2 per question in Stage 2, 2 per question in Stage 3) without resolving a gap, the item is classified as **confirmed evidence scarcity** and added to `/execution/scarcity-register/{section}/{section}-scarcity-register.md` (Stage 2) or updated in place (Stage 3).

**Entry format:** Question ID, missing component, research attempted, editorial instruction (one of: HEDGE — qualify claims; SCOPE CAVEAT — note the limitation; PROXY FRAMING — use adjacent evidence with transparent proxy disclosure), downstream routing (which cluster memo + section directive incorporates the instruction).

**Downstream rules:** Stage 3 section directives MUST reference scarcity entries for their cluster. Stage 4 report prose MUST implement the editorial instruction specified. The scarcity register is a required input for `section-directive-drafter` and `evidence-to-report-writer`.

## Late-Stage Data Correction Propagation

When a supplementary pass closes a gap or corrects a data point already referenced in a downstream artifact, the correction must propagate through all dependent artifacts before the workflow advances. Propagation chain: Research Extract → Cluster Memo → Section Directive → Chapter Draft → Report Prose. After any merge (Step 2.S4 or Step 3.S3), check whether any downstream artifact already references the affected component; if so, update cluster memos / revise section directives / flag chapter passages under the bright-line rule before modifying.

## No-Source-Substitution Rule

The workflow may not silently substitute proxy evidence for the requested in-scope evidence. Return one of three outcomes per claim:

- (a) **direct evidence found** — claim tagged `IN-LENS`
- (b) **proxy evidence found, clearly downgraded** — claim tagged `PROXY-DOWNGRADE`
- (c) **no evidence found** — claim tagged `NO-EVIDENCE`

**Operating rule.** If no in-scope evidence is found, do not broaden the claim. Broaden the **source** only, and downgrade the conclusion. The claim's scope stays inside the original question's scope; the conclusion's strength drops to match the available evidence class.

**Tag vocabulary (canonical — exact-string match required by downstream consumers):**

| Tag | Meaning |
|---|---|
| `IN-LENS` | Claim supported by direct in-scope evidence (matches project's geography / size band / scope criteria as applicable). |
| `PROXY-DOWNGRADE` | Claim supported only by proxy evidence (out-of-scope deal, region-aggregate-for-country-specific, adjacent-country example). Claim must declare proxy nature inline or in load-bearing caveat per § Uncertainty Disclosure. |
| `NO-EVIDENCE` | No direct or proxy evidence found at any source class. Claim must NOT appear in prose without explicit "no evidence found" framing. |

## Country Coverage Table

For projects with a multi-country scope, every cluster memo includes a Country Coverage Table for each country-relevant claim. The table format:

| Claim | {{Country_1}} status | {{Country_2}} status | {{Country_N}} status | Permitted conclusion strength |
|---|---|---|---|---|
| (claim text) | `observed` / `proxied` / `not evidenced` | same | same | (per § Claim-Permission Classes) |

**Country-confidence label vocabulary (canonical — exact-string match required):**

- `observed` — direct evidence available for this country.
- `proxied` — only pan-region or adjacent-country proxy available.
- `not evidenced` — no evidence at any source class.

**Gate rule.** A claim's permitted scope is bounded by its weakest-country status:

- All countries at `observed` or `proxied` → may be stated as multi-country (with proxy caveat where applicable).
- One country at `not evidenced` → must reframe as fewer-country or country-specific (with caveat for the missing country), OR downgrade per § Claim-Permission Classes.
- Two or more countries at `not evidenced` → ILLUSTRATIVE-ONLY at best per § Claim-Permission Classes.

**Stage 2 ordering rule.** Per-country research sessions for a country-relevant question run per-country **first**; pan-region synthesis runs **last** (not first). Pan-region-first ordering biases the claim toward multi-country framing before per-country evidence is known.

**Single-country projects.** Omit this section entirely; the gate rules are inapplicable.

## Risk-Tier Model

> **Adjacency rule.** This section defines the control-effort axis (Tier A–D) and the single point at which tier touches the permission machinery (the permission ceiling, a cap). It is **adjacent to, and never merged with**, § Claim-Permission Classes. The four permission-class names, their verb lists, and gate semantics belong to that section and are unchanged here; this section does not restate or override them. Edits that would alter the permission-class set require `/risk-check` re-fire against that section, not this one.

The workflow applies control depth per question by **risk tier**, set at plan time before evidence is gathered. Tiering keeps heavy controls where the thesis verdict rests and runs light where a question is illustrative. Tier is an **input that sets control depth**; the permission class (§ Claim-Permission Classes) is an **output that grades the result**. They are never substituted for each other.

### Three orthogonal axes (do not collapse)

| Axis | Question it answers | Assigned when | Assigned by | Lives where |
|---|---|---|---|---|
| **Risk tier** (control effort) | How much control effort does this question deserve? | Plan time (before evidence) | `research-plan-creator` (`risk-tier:` field) | research plan; carried on the question |
| **Evidentiary lens / role** | What evidentiary role does this source play? | Extract time | `research-extract-creator` (`independence basis` field) | Stage-2 extracts |
| **Permission class** | Given the evidence found, how strongly may the claim be stated? | Post-evidence (Pass 3) | `claim-permission-gate` / `cluster-memo-refiner` Check 9 | § Claim-Permission Classes |

**Orthogonality to the Depth Calibration Framework (L1–L3).** `research-plan-creator` also carries an L1–L3 knowledge-depth scale (its Depth Calibration Framework). That scale answers *how deeply must we understand this topic?* — a **knowledge-depth** axis. Risk tier answers *how much control effort does the answer deserve?* — a **control-effort** axis. They are orthogonal and **coexist**: a question may be L1 (conversational depth) yet Tier A (load-bearing, full controls), or L3 (execution competency) yet Tier C. Tier A–D does **not** replace, alias, or map onto L1–L3; both fields are assigned independently at plan time.

### Tier assignment (deterministic, at plan time)

- **Tier A** — the answer carries the thesis verdict, OR a quantitative SUPPORTED assertion the positioning recommendation rests on.
- **Tier B** — materially supports a Tier-A claim but is not itself load-bearing. **(Default — see below.)**
- **Tier C** — provides context/framing that shapes interpretation but supports no standalone market-pattern claim.
- **Tier D** — illustrative only (a named case, no pattern claim).

Tier is assigned by `research-plan-creator`, one per research question, recorded as a `risk-tier:` field on the question. The plan-time assignment is surfaced at the existing research-plan approval gate; the operator may re-tier any question. No new gate is introduced — tier rides the gate that already exists.

**Backward-compatible default (presence-gated).** A question with no `risk-tier:` field defaults to **Tier B** — normal, uniform control depth, identical to pre-tiering behaviour. Tiering is opt-in enrichment, not a breaking change: an un-tiered plan runs exactly as before. Consumers MUST presence-gate the tier read — **absent `risk-tier:` field, OR a project chassis with no § Risk-Tier Model section, → Tier B** — so a project that has not adopted this model drives every question to Tier B and runs unchanged.

### Control matrix per tier

| Control | Tier A | Tier B | Tier C | Tier D |
|---|---|---|---|---|
| Full source ladder (all source classes attempted) | required | required | lightweight (primary + one corroborant) | named source only |
| Counter-search (disconfirming, #4) | mandatory | — | — | — |
| Stage-2 extract verification | yes | yes | citation-check only | — |
| Pass-3 permission gate | yes | yes | yes | auto-ILLUSTRATIVE-ONLY ceiling |
| Sufficiency gate (blocking ratios) | yes | yes | counts toward section ratio | excluded from ratio |
| Citation entailment (#7) | sentence-level | claim-level | claim-level | — |
| Paywall fast-lane (#5) | full deep session if gated | fast-lane | fast-lane | not pursued if gated |

The controls are the existing workflow stages; tier routes them — it does not invent new ones.

### Permission ceiling (the one point of contact with § Claim-Permission Classes)

Tier caps the **highest** permission class a question may reach. It never re-grades: a Tier-A question can still end NOT-SUPPORTED if the evidence is absent.

| Tier | Permission ceiling | Enforcement |
|---|---|---|
| A | up to SUPPORTED | — |
| B | up to SUPPORTED | — |
| C | up to PROXY-SUPPORTED | **advisory** — `claim-permission-gate` flags a C-tier claim graded above the ceiling; the operator may override |
| D | ILLUSTRATIVE-ONLY max | **hard cap** — a D-tier question is auto-ceilinged to ILLUSTRATIVE-ONLY by construction |

The ceiling is a **cap, not a re-grade**: under the ceiling, the permission gate decides where the claim actually lands per § Claim-Permission Classes. The four permission-class names, verb lists, and gate semantics in that section are unchanged by this model. (Ceiling enforcement split — hard cap for D, advisory for C — is a project-recordable decision; record it in the adopting project's `logs/decisions.md`.)

## Claim-Permission Classes

> **Canonical-ordering rule.** This chassis is the source of truth for permission-class names, the permitted-prose-verb lists, and gate semantics. Per-claim-type evidence thresholds (the project-fillable table) live in `reference/claim-permission.md` (derived from `claim-permission.template.md`). Future edits that cross this boundary in either direction require `/risk-check` re-fire.

Every cluster claim that reaches synthesis carries a permission class. The class determines what prose verbs may be used, what framing is required, and whether the claim may appear at all.

### Four Permission Classes

| Class | Conditions | Permitted prose verbs | Permitted prose framing |
|---|---|---|---|
| `SUPPORTED` | Direct evidence, ≥2 source channels, in-scope (per § No-Source-Substitution Rule) or directly-applicable proxy with no downgrade | shows / confirms / establishes / demonstrates / records | Plain assertion. No hedging required. |
| `PROXY-SUPPORTED` | Proxy evidence with downgrade (out-of-scope, pan-region for country-specific claim, or `PROXY-DOWNGRADE`-tagged extracts) | suggests / is consistent with / points to / indicates | Must include proxy nature inline or in load-bearing caveat per § Uncertainty Disclosure. |
| `ILLUSTRATIVE-ONLY` | <3 same-pattern instances, OR single-source named-example, OR two-or-more-countries `not evidenced` from § Country Coverage Table | illustrates / shows in one named case / appears in | Must NOT support a market-pattern claim. Named cases used as illustration only. |
| `NOT-SUPPORTED` | No direct or proxy evidence at any source class (`NO-EVIDENCE` tag in extracts, OR all-source-classes-exhausted per § Research Stop Conditions Cond. 3 or 4) | (may not state) | Claim must NOT appear in prose. If thematically required, framed as a "monitoring hypothesis" (project routes per its own deferral protocol). |

**Verb-list enforcement.** The verb-list above is normative. `evidence-to-report-writer` may NOT pair `establishes` / `confirms` / `shows` with a `PROXY-SUPPORTED` or `ILLUSTRATIVE-ONLY` claim. Cross-checked at Stage 4.3 (`chapter-prose-reviewer`).

### Minimum Evidence Thresholds

Project-fillable. The chassis declares the rule shape; the per-claim-type table lives in `reference/claim-permission.md` (template at `reference/claim-permission.template.md`, FX-B5). Claims that meet the threshold reach SUPPORTED; below threshold, claims downgrade to PROXY-SUPPORTED at best; without proxy evidence, ILLUSTRATIVE-ONLY or NOT-SUPPORTED.

### Source-Diversity Matrix

Project-fillable. The chassis declares the rule shape; the per-claim-type table lives in `reference/claim-permission.md`. **Triangulation-packets rule.** The matrix is not "find N sources" — it is "find N source-types playing different evidentiary roles." Three independent reports from the same source class count as ONE evidentiary role, not three. **The same collapse applies across source classes that share one underlying origin:** if two or more channels trace to the same underlying source, dataset, or primary release — e.g., a trade-body summary and a specialist-press article both restating the same underlying benchmark figure — they count as ONE evidentiary role even though their source *classes* differ. Genuine independence requires a distinct underlying observation, not merely a distinct publication venue. Operationalised per claim by the `independence basis` field in `research-extract-creator` (`independently-observed` = distinct role; `same-underlying-dataset` / `same-press-release` = collapse to one role; `unclear` = treat as one role pending resolution). A claim resting on ≥2 channels that collapse to one role does not meet the ≥2-channel SUPPORTED bar and downgrades to PROXY-SUPPORTED. **Deployment-time obligation:** this cross-class collapse *tightens* the SUPPORTED bar relative to the same-class-only formulation. Any project deployed from this template inherits it; any project that records `independence basis` tags before this clause is active in its own chassis must back-validate those already-tagged extracts (re-check them before the rule bites), since tags recorded under the looser rule are unvalidated against the collapse.

### R1-Defect Fold-Ins

Project-fillable. The chassis declares the rule shape; the per-defect rows live in `reference/claim-permission.md`. Defects surfaced by first-pass critique become normative permission sub-rules — when a defect pattern is detected, the affected claim auto-downgrades or auto-NOT-SUPPORTED per the project's fold-in row.

### No-Orphan-Citation Enforcement

Each citation must answer "What exact sentence does this source support?" If the answer is vague or the source supports only a general topical area, remove the citation OR downgrade the dependent claim by one permission class. Implemented at `cluster-memo-refiner` Check 9 sub-check 2 + `citation-converter` validation.

### Blocking-Gate Semantics

The permission gate is **blocking**, not advisory. Synthesis (Pass 4) cannot proceed for a cluster or section that fails the following ratio tests:

- **Cluster-level block (`CLUSTER-INSUFFICIENT`):** if more than `{{CLUSTER_BLOCK_THRESHOLD}}` (project-tunable; default 30%) of a cluster's claims are NOT-SUPPORTED at gate time, the cluster is flagged. Pass 4 synthesis is blocked for that cluster. Unblocking: (a) additional evidence found via gap-filling research, OR (b) operator explicitly overrides and accepts scope reduction. Flagged by `cluster-memo-refiner` Check 9.
- **Section-level block (`SECTION-INSUFFICIENT`):** if more than `{{SECTION_BLOCK_THRESHOLD}}` (project-tunable; default 40%) of all claims across a section are NOT-SUPPORTED, the section is flagged. Pass 4 synthesis is blocked at section level. Unblocking requires operator decision. Flagged by the Pass 3 gate-clearance emitter.

**Threshold calibration.** The default values are locked starting values. Calibration after the first production run is permitted. Any adjustment must be logged to `logs/decisions.md` with a brief rationale (sample size, false-block rate observed, etc.).

### Gate-Clearance Artifact

Pass 3 emits `analysis/gate-clearance/{section}/{section}-gate-clearance.md` with this structure:

- Per-cluster verdict: `CLEARED` / `BLOCKED` (CLUSTER-INSUFFICIENT) / `CLEARED-WITH-CAVEATS`
- Per-cluster NOT-SUPPORTED count and ratio
- Section-level verdict: `CLEARED` / `BLOCKED` (SECTION-INSUFFICIENT) / `CLEARED-WITH-CAVEATS`
- If `BLOCKED`: a remediation prompt listing which clusters need more evidence or scope reduction before synthesis can proceed.

`/run-analysis` and `/run-synthesis` Step 0 fail-safe: refuse-to-run when this file is absent or when its top-level verdict is `BLOCKED`. Per-section override via `OPERATOR-OVERRIDE` only.

## Research Stop Conditions

A research subtask may stop when ANY of the following is true:

1. Two high-quality direct sources answer the question.
2. One high-quality direct source plus three named examples support the pattern.
3. Three source classes (per `reference/source-class-hierarchy.md`) have been checked and no direct evidence exists.
4. Local-language, primary-source, and advisory-source searches all fail.

**Reciprocal rule** (a subtask may NOT stop until at least one condition is true): Subtasks that exit before any condition is met are flagged as "incomplete research" and the affected claims are downgraded to NOT-SUPPORTED by default per § Claim-Permission Classes.

**Evidence-ceiling marking.** Extracts that closed via condition 3 or 4 are marked `EVIDENCE-CEILING-REACHED` by `research-extract-verifier`; affected claims are pre-classified PROXY-SUPPORTED or NOT-SUPPORTED before reaching the `cluster-memo-refiner` Check 9 gate.

## Source-Conflict Resolution Procedure

When two reputable sources disagree on the same fact, apply this 3-step procedure. Do not silently pick one, average, or omit.

**Step 1 — Flag the conflict.** Record both sources in `analysis/source-conflicts/{section}/{section}-source-conflict-log.md` with table columns: Conflict ID, Claim, Source A, Source A value, Source B, Source B value, Conflict type (numeric / categorical / interpretive).

**Step 2 — Triangulate.** Check whether a third independent source resolves the conflict. Use `reference/source-class-hierarchy.md` to select the triangulation source (prefer higher source class). If resolved: record `status: RESOLVED-TRIANGULATION` and proceed with the resolved value. Else proceed to Step 3.

**Step 3 — Adjudicate or downgrade.** Apply the first applicable adjudication rule:

| Rule | Condition | Action | Conflict-log status |
|---|---|---|---|
| **Methodology preference** | Conflict between source classes | Prefer the higher source class per `reference/source-class-hierarchy.md`. Record rationale. | `RESOLVED-METHODOLOGY` |
| **Granularity preference** | One source at finer granularity for the specific claim | Prefer the finer source for the claim it directly supports. Record rationale. | `RESOLVED-GRANULARITY` |
| **No adjudication possible** | Neither rule cleanly applies | Downgrade the affected claim one permission class per § Claim-Permission Classes. Prose explicitly notes the conflict. | `UNRESOLVED` |
