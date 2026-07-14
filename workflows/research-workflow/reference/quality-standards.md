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

## Critical Finding Classification

Governs REVISE-finding criticality only (e.g., `run-execution.md` Step 2.1b). It does NOT apply to QC-gate FAIL rules ("PAUSE on FAIL with critical findings" in `run-report.md` / `produce-architecture.md`) — those are a different rule class and always pause.

A Critical finding in a REVISE verdict is classified before acting:

- **Mechanical Critical** — exactly one correct fix, no editorial or scope judgment required (e.g., a forbidden-terminology strip, a missing literal scope line whose content is already known from the inputs). All-mechanical Criticals: auto-apply fixes and re-run QC, one iteration only. Still FLAG after the re-run → pause (no fresh iteration budget).
- **Judgment Critical** — requires an editorial, scope, or content decision. Pause for operator review.
- **Conservative default:** ambiguous classification → judgment → pause. Any mechanical/judgment mix → pause.

The executing source of this rule is the canonical `research-prompt-qc` skill (§ Autonomy Rules) — the qc-gate subagent reads the skill, not this file. This section is the operator-facing mirror; if the two ever diverge, the skill governs and the divergence is a defect to log.

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

**Confirmed evidence scarcity is a statement about the search, not about the world.** It records that the pipeline looked and did not find — nothing more. It does **not** establish that the thing sought is absent, and prose may not convert a scarcity entry into a negative finding ("no such deals occurred", "the practice is absent"). The three permitted editorial instructions (HEDGE / SCOPE CAVEAT / PROXY FRAMING) are all forms of *saying less*; none of them licenses asserting the negative. Where the pipeline has instead found positive evidence that something does **not** occur, that is an **evidenced negative** — it is a finding, it grades on the ordinary ladder, and it does not belong in this register. See § Claim-Permission Classes → Evidenced Negatives vs Absence of Evidence.

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
| `NO-EVIDENCE` | No direct or proxy evidence found at any source class. Claim must NOT appear in prose without explicit "no evidence found" framing. **The tag records a failed search, not an established absence** — it licenses neither the claim nor its negation. A positively-evidenced absence is `IN-LENS` (evidence of a negative), not `NO-EVIDENCE`; see § Claim-Permission Classes → Evidenced Negatives vs Absence of Evidence. |

## Country Coverage Table

For projects with a multi-country scope, every cluster memo includes a Country Coverage Table for each country-relevant claim. The table format:

| Claim | {{Country_1}} status | {{Country_2}} status | {{Country_N}} status | Permitted conclusion strength |
|---|---|---|---|---|
| (claim text) | `observed` / `proxied` / `not evidenced` | same | same | (per § Claim-Permission Classes) |

**Country-confidence label vocabulary (canonical — exact-string match required):**

- `observed` — direct evidence available for this country.
- `proxied` — only pan-region or adjacent-country proxy available.
- `not evidenced` — no evidence at any source class.

**Gate rule.** A claim's permitted scope is bounded by its weakest-country status. This is the **country-coverage ceiling** (§ Claim-Permission Classes → Permission ceilings): it caps a class that was already assigned on evidence, and never re-grades the evidence itself.

- All countries at `observed` or `proxied` → may be stated as multi-country (with proxy caveat where applicable). No cap.
- One country at `not evidenced` → **narrow the claim** to the evidenced countries (with a caveat naming the missing one). Narrowing is the first remedy: it preserves the finding at the scope its evidence supports. Only if the claim cannot be narrowed — it is inherently multi-country — does the ceiling cap it per § Claim-Permission Classes.
- Two or more countries at `not evidenced` → **cap at `ILLUSTRATIVE-ONLY`** (a ceiling, not a re-grade — record the cap in the Rationale).

> **Who may narrow.** The "narrow the claim" remedy above is addressed to **`cluster-memo-refiner` Check 9**, which owns the finding text. **`claim-permission-gate` cannot narrow** — it carries claim text verbatim and may not write prose — so at the Pass-3 gate the same trigger **caps** and records the cap instead. See § Claim-Permission Classes → Permission ceilings, "Narrow-vs-cap is decided by the consumer." A narrow instruction reaching the gate means Check 9 did not act on it upstream.

**Note — `not evidenced` is an absence of evidence, not an evidenced negative.** A country marked `not evidenced` means the search found nothing there; it does **not** license a claim that the phenomenon is absent in that country. If evidence positively establishes absence in a country, that is `observed` (of a negative), not `not evidenced` — and it grades on the ordinary ladder. See § Claim-Permission Classes → Evidenced Negatives vs Absence of Evidence.

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

<!-- chassis-version: 2026-07-14 -->

> **Chassis version: `2026-07-14`. This marker is load-bearing — do not delete it, and bump it on any change to the class conditions, adjudication order, or ceilings.**
>
> `claim-permission-gate` and `cluster-memo-refiner` **verify this marker at pre-flight and HARD-EXIT if it is absent or older than the version they require.** The reason is a real hazard, not a hypothetical: the canonical **skills** are symlinked into consuming projects, but each project holds its **own real copy of this chassis**. A canonical skill edit therefore reaches every project *instantly on merge*, while the chassis it depends on does **not**. Without this marker the new skill would run against an old chassis and **silently misadjudicate** — the pre-flight's heading-presence checks all pass, because the old chassis has the same headings. A loud exit is the only safe failure here.
>
> **If a skill halts on this check:** your project's `reference/quality-standards.md` predates the 2026-07-14 re-cut. Back-port § Claim-Permission Classes (and its subsections), § Country Coverage Table's gate rule, and § Research Stop Conditions from the canonical template, then re-run. Claims already adjudicated under the old chassis were graded by a rule set with a known gap and overlap — see the version history below — and should be re-checked, not assumed correct.

> **Canonical-ordering rule.** This chassis is the source of truth for permission-class **names**, the permitted-prose-**verb lists**, the **class conditions** (the Conditions column below — the generic evidence bar), the **ceiling** semantics, and the **gate** semantics. Per-claim-type evidence thresholds — the project-fillable calibration *on top of* the generic bar — live in `reference/claim-permission.md` (derived from `claim-permission.template.md`). Future edits that cross this boundary in either direction require `/risk-check` re-fire.
>
> **The Conditions column is chassis-owned, not project-fillable** (stated explicitly 2026-07-14 — it was previously undefined, and its status was the load-bearing ambiguity behind the defects this section now fixes). A project may *tighten* the bar per claim type in its `claim-permission.md`; it may not redefine what a class **means**. The four class names are therefore fixed for every project deployed from this template, and a consuming skill may rely on them as literals.

Every cluster claim that reaches synthesis carries a permission class. The class determines what prose verbs may be used, what framing is required, and whether the claim may appear at all.

### The two controls — do not conflate them

A claim is governed by **two independent controls**, applied in order. Collapsing them into one column is what produced the gap and the overlap this section repaired on 2026-07-14 (see § Adjudication order below).

1. **The permission class** grades the **evidence** — how much of it, how independent, how well it fits the claim as scoped. Graded on ONE ordered axis. Nothing about the *claim's* rhetorical ambition enters here.
2. **The ceilings** then **cap** the class — they never raise it. A ceiling reflects a property of the **claim** (how broadly it generalizes, how many countries it spans, what risk tier it is load-bearing on), not of the evidence.

**Assign the class on evidence first. Then apply the ceilings.** Never let a ceiling condition re-enter the class conditions — that is precisely the mixed-axis error corrected here.

### Four Permission Classes

Graded on a single ordered axis: the count of **independent evidentiary roles** (per § Source-Diversity Matrix — same-origin channels collapse to ONE role; this is a count of roles, not of documents), then evidence **fit** (direct/in-scope vs proxy-requiring-downgrade, per § No-Source-Substitution Rule).

| Class | Conditions (evidence only) | Permitted prose verbs | Permitted prose framing |
|---|---|---|---|
| `SUPPORTED` | **≥2** independent evidentiary roles, evidence **direct and in-scope** (per § No-Source-Substitution Rule) — or a directly-applicable proxy requiring no downgrade | shows / confirms / establishes / demonstrates / records | Plain assertion. No hedging required. |
| `PROXY-SUPPORTED` | **≥2** independent evidentiary roles, but the evidence is **proxy and requires downgrade** (out-of-scope, pan-region for a country-specific claim, or `PROXY-DOWNGRADE`-tagged extracts) | suggests / is consistent with / points to / indicates | Must include proxy nature inline or in load-bearing caveat per § Uncertainty Disclosure. |
| `ILLUSTRATIVE-ONLY` | **Exactly 1** independent evidentiary role (direct or proxy). One role can attest what it observed; it cannot be triangulated, so it cannot carry a generalization. | illustrates / shows in one named case / appears in / reports (single-sourced) | May be stated as the single attested case or datum, **attributed to its source**. Must NOT be *stated as* a generalization or market-pattern claim — see the disposition rule below for a claim that arrives here via the generalization ceiling. |
| `NOT-SUPPORTED` | **Zero** evidentiary roles — no direct and no proxy evidence at any source class. | (may not state) | Claim must NOT appear in prose. If thematically required, framed as a "monitoring hypothesis" (project routes per its own deferral protocol). |

> **`NOT-SUPPORTED` is defined by the role count and by NOTHING else** (tightened 2026-07-14). It previously read *"…zero roles (`NO-EVIDENCE` tag, **OR** all-source-classes-exhausted per § Research Stop Conditions Cond. 3 or 4)"*. That `OR` was **not role-gated**, and it broke the partition: a claim resting on **≥2 proxy roles** whose subtask *also* exhausted its source classes matched `PROXY-SUPPORTED` **and** `NOT-SUPPORTED` at once, with no tie-break. A `NO-EVIDENCE` tag and a Cond. 3 / Cond. 4 closure are **routes to zero roles, not independent triggers** — they are evidence *provenance*, and provenance never selects a class. Count the roles; if the count is not zero, the claim is not `NOT-SUPPORTED`, however its subtask closed.

**Disposition rule — a claim capped at `ILLUSTRATIVE-ONLY` by the generalization ceiling** (added 2026-07-14; without it the capped row is self-contradictory). Such a claim's **text is still a generalization** — the Pass-3 gate carries claim text verbatim and cannot rewrite it — while the class it now sits in forbids stating a generalization. That is not a contradiction to be resolved by the gate; it is an instruction to **Pass 4**:

- The gate records `GENERALIZATION-CAPPED` in the Rationale alongside the evidence-graded class it would otherwise have earned (e.g. `evidence: SUPPORTED (2 roles); generalization ceiling → capped ILLUSTRATIVE-ONLY`).
- **Pass 4 may NOT state the claim as written.** It must either (a) **narrow** it in prose to what the instances actually attest — the preferred route, and the one that preserves the finding — or (b) omit it. It may not restate the generalization under a hedge; `ILLUSTRATIVE-ONLY`'s verb list does not license it.
- Upstream, `cluster-memo-refiner` Check 9 should have narrowed the finding *before* it reached the gate — narrowing at Pass 3 is impossible by construction. A `GENERALIZATION-CAPPED` row reaching Pass 4 therefore also signals that Check 9 did not do its job, and is worth surfacing to the operator.

### Adjudication order (the partition guarantee)

**Count the independent evidentiary roles first, then apply the fit test.** The four conditions are mutually exclusive and jointly exhaustive by construction — every evidence shape lands in exactly **one** class, so no precedence rule is needed and none may be invented.

Worked cases (these are the four that the pre-2026-07-14 table adjudicated wrongly; they are the acceptance test for any future edit to this table):

| Evidence shape | Class | Note |
|---|---|---|
| One direct, in-scope source that is **not** a named example (e.g. a single regulator statistic) | `ILLUSTRATIVE-ONLY` | **Previously fell through all four classes** — it failed `SUPPORTED` (<2 roles), was not proxy, was not a named example, and was not zero-evidence. It is stateable, attributed, as a single-sourced datum; it cannot ground a generalization. |
| A pattern claim resting on 2 direct, independent source roles | `SUPPORTED`, then the **generalization ceiling** applies | **Previously matched `SUPPORTED` AND `ILLUSTRATIVE-ONLY` at once.** The evidence earns `SUPPORTED`; the claim's ambition is then bounded by the ceiling below — not by re-grading the evidence. |
| One direct source, a named example | `ILLUSTRATIVE-ONLY` | Unchanged behaviour. |
| An exhaustive search that **found** a well-evidenced negative (≥2 roles recording a true zero) | `SUPPORTED` | See § Evidenced Negatives vs Absence of Evidence. `NOT-SUPPORTED` is **not** the home for a negative that the evidence actually supports. |

### Permission ceilings (caps, never raises)

Applied **after** the class is assigned on evidence. A ceiling can only lower a class, never lift it — a thin-evidence claim on a high-priority question still lands where its evidence puts it. **Four ceilings exist** (three live, one declared-but-unimplementable — see the table); they compose, and the most restrictive binds.

**Narrow-vs-cap is decided by the consumer, not by the ceiling.** Every ceiling below offers, in principle, two remedies: **narrow** the claim to what the evidence actually supports, or **cap** its class. Which one a consumer may use is fixed by what that consumer is allowed to write:

- **`cluster-memo-refiner` Check 9 may NARROW** — it owns the finding text and may rewrite its scope. Narrowing is always the preferred remedy: it preserves the finding at the scope its evidence supports, rather than demoting it.
- **`claim-permission-gate` may ONLY CAP** — its Output schema requires claim text **verbatim** and it is forbidden from writing prose, so it has no mechanism to narrow. Any instruction below to "narrow" is addressed to Check 9, upstream; at the Pass-3 gate the same trigger caps and records.

A "narrow" instruction reaching the gate is therefore not a contradiction — it is an instruction that has arrived one stage too late, and the gate's caps-with-a-marker are what make that visible.

**Presence-gating — and the one distinction that makes it coherent.** Two kinds of missing input exist, and they are **not** treated alike. Conflating them produced a self-contradiction in the first draft of this section (2026-07-14), so the distinction is stated as a rule:

- **Legitimately absent → the ceiling is INAPPLICABLE and does NOT fire.** The input is one a correct project may simply not have: no Country Coverage Table in a single-country project; no research plan in an un-tiered project; no instance count on a claim that **does not generalize**. Absence here carries no information about the claim, so firing would be a penalty on a technicality. Disclose which ceilings were inactive.
- **Required but missing → the input is MALFORMED, and the ceiling FIRES with a flag.** The input is one the claim's own shape *demands*: a claim that **does** generalize, carrying neither ≥3 same-pattern instances **nor** a population-level source. Such a claim has recorded **no warrant to generalize at all** — and a generalization with no recorded warrant must not pass as `SUPPORTED`. Cap it, flag it for operator review, and do not silently choose either way.

**"Absent input → never fire" applies ONLY to the first case.** It is not a general licence to skip a ceiling whenever the memo is thin.

| Ceiling | Trigger | Cap |
|---|---|---|
| **Generalization ceiling** | **Fires when the claim generalizes and its warrant to generalize is insufficient.** Two tests, both required:<br>**(1) Does the claim generalize?** — read from the **claim text**: does it extrapolate a pattern across a class of actors, deals, or periods ("sponsors systematically…", "the market has shifted to…", "no sponsor did X")? If **no** (a single attested datum, a named case), the ceiling is **inapplicable** — record `instances: n/a` and move on.<br>**(2) If it generalizes, is there a warrant?** — a generalization is warranted by **exactly one of two things**: **≥3 same-pattern instances** (sample-based), **OR ≥1 population-level evidentiary role** (coverage-based — see exemption below). If **either** is present, the ceiling does **not** fire. If **neither** is recorded, the ceiling **FIRES** and the row is flagged — see the malformed-input rule above. | **The branch depends on the consumer — it is not a free choice.** `cluster-memo-refiner` Check 9 owns **narrow-or-escalate** (it may rewrite a finding's scope; its 3-tier ladder — `<3` illustrative / `3–5` directional-with-caveat / `5+` across ≥2 countries pattern-permitted — arbitrates). `claim-permission-gate` **can only cap**: its Output schema requires claim text **verbatim** and it is forbidden from writing prose, so it has no mechanism to narrow. At the Pass-3 gate a fired ceiling therefore **caps at `ILLUSTRATIVE-ONLY`** and records the cap. Narrowing, if any, happens upstream at Check 9. |
| **Country-coverage ceiling** | Two or more countries at `not evidenced` in the claim's Country Coverage Table. **Does not fire** when the project is single-country (§ Country Coverage Table is omitted by design), the claim is not country-relevant, or no Country Coverage Table is present. A missing table is **inapplicable**, never "two or more countries not evidenced." | Cap at `ILLUSTRATIVE-ONLY`. |
| **Risk-tier ceiling** | The claim is load-bearing on a risk-tiered question; the binding tier is the **most restrictive** among its contributing questions. **Does not fire** absent a research plan or a `§ Risk-Tier Model` section — every claim then binds at Tier B (no constraint). | **Owned by § Risk-Tier Model → Permission ceiling — see that table; do not restate it here.** |
| **Process ceiling** ⚠ **declared, NOT implementable — do not rely on it** | The claim's subtask met **no** stop condition — it was *abandoned*, not merely thin-yielding (§ Research Stop Conditions, reciprocal rule). **A diligent subtask that worked the ladder and found little closes legitimately under Cond. 5 and is NOT caught by this.** | Cap at `NOT-SUPPORTED`, recorded as `process ceiling: incomplete research, no stop condition met` — never as a bare evidence verdict. **Status: no consumer implements this.** The refined cluster memo carries **no stop-condition or subtask-completeness field**, so `claim-permission-gate` cannot evaluate the trigger at all. Wiring it requires a memo-schema change upstream. Treat as stated intent, not a live control. |

**Record every applied ceiling in the claim's Rationale**, naming the ceiling and the cap. A cap that is not recorded is indistinguishable from an evidence verdict, which destroys the reader's ability to audit the gate.

> **Never infer the process ceiling from thin evidence.** A one-role claim is `ILLUSTRATIVE-ONLY` — an *evidence* outcome. It is not a signal that the researcher gave up. Inferring abandonment from a thin evidence base would re-conflate the process and evidence axes that this section exists to separate, and would make `ILLUSTRATIVE-ONLY` unreachable all over again.

> **Definition — "same-pattern instance" (load-bearing; previously undefined).** An instance is **one observed occurrence of the pattern the claim asserts** — one deal, one actor, one event exhibiting the behaviour being generalized. It is **not** a source, a document, or an evidentiary role: three reports describing the *same* transaction are ONE instance; one report describing three transactions is THREE instances. **Instances and evidentiary roles are different axes and must never be compared or substituted** — roles set the *class* (how well-evidenced the claim is), instances set the *ceiling* (how broadly it may generalize). Conflating the two is the exact defect this section was rewritten to remove on 2026-07-14: the pre-rewrite table tested `<3 same-pattern instances` as a *class condition*, which collided with `SUPPORTED`'s ≥2-role bar and made a well-corroborated 2-role claim match two classes at once.
>
> **`n/a` is valid ONLY for a non-generalizing claim.** A claim that asserts no pattern has no instance count: record `n/a`, and the ceiling is inapplicable. **Never read `n/a` as `0`** — that would fire the ceiling on every non-generalizing claim in the memo.
>
> **But `n/a` on a claim that DOES generalize is a memo defect, not an exemption.** A generalizing claim must record its warrant — an instance count, or a named population-level source. If it records neither, the memo has failed to state why the claim may generalize, and the gate must not read that silence as permission. This is the **required-but-missing** case above: cap and flag. **A memo cannot exempt a generalizing claim by writing `n/a`.**
>
> **Upstream obligation (new — this rule creates it).** `cluster-memo-refiner` Check 9 must record, for every finding whose claim text generalizes, **either** `instances: {count}` **or** `instances: n/a (population-level — {named source})`. A bare `n/a` on a generalizing finding is now a defect that the Pass-3 gate will flag back. Memos written before 2026-07-14 do not carry this field reliably — expect flags on first re-run against an existing project, and treat them as memo-completion work, not as evidence failures.

> **Population-level exemption (load-bearing — this is how an evidenced negative survives the ceiling).** The generalization ceiling exists to stop a claim **extrapolating** from too few observed cases. It must NOT fire on a claim whose evidence covers the **whole population** rather than a sample of it — a complete regulatory register, a full-population survey, an exhaustive transaction database. Such a claim does not extrapolate; it **reports coverage**, and its warrant comes from the completeness of the source, not from an instance count.
>
> This is decisive for **evidenced negatives**, which have **zero positive instances by construction**: a claim like *"no continuation vehicles were used in this segment in 2025"*, established by a complete statutory register recording a true zero, would otherwise be read as `0 < 3` and capped to `ILLUSTRATIVE-ONLY` — destroying a well-evidenced finding and re-importing, through the ceiling layer, the very penalty-on-negatives that § Evidenced Negatives vs Absence of Evidence forbids on the class layer.
>
> **The exemption fires on the RECORD, not on the reader's inference — and this distinction is the whole point.** It applies when, and only when, the memo **records** the population-level basis: `instances: n/a (population-level — National Register of Collective Investment Vehicles)`. Given that line, the ceiling does not fire and the claim keeps its evidence-graded class.
>
> **The same claim with a bare `instances: n/a` is capped and flagged, and that is correct, not a contradiction.** The Pass-3 gate is forbidden to adjudicate population-level status — it *reads* the field, it does not infer it from a source list — because a gate that infers "that looks like a register to me" is a gate that can be talked into treating a large sample as a population. So the two cases are genuinely different **memos**, not two readings of one rule: a well-formed memo names the register and the finding survives; a memo that names nothing has stated no warrant, and the gate caps it with `[POPULATION-LEVEL-UNVERIFIED — operator review]` rather than guessing. **The finding is not lost — it is held, visibly, until the memo says why it may generalize.** The remedy is to complete the memo upstream and re-run, not to relax the gate.
>
> The exemption is about **source coverage, not claim polarity** — it applies equally to a positive population-level claim ("the register records 412 registrations") and does **not** rescue a negative that rests on a *sample* ("we looked at 4 sponsors and none used CVs" — that is a sample, it generalizes, and the ceiling fires).
>
> **Who determines population-level coverage, and how it is recorded.** The exemption fires only when **at least one** of the claim's evidentiary roles is genuinely population-level — a source whose *stated scope is the whole population the claim quantifies over*: a complete statutory register, a mandatory-filing database, an exhaustive transaction record. **A large sample is not a population.** A 140-respondent survey, however well-constructed, is a sample and does not by itself carry the exemption — it may sit *alongside* a population-level source as corroboration, but it cannot supply the exemption on its own.
>
> The determination is made **upstream, where the source is characterised** — `research-extract-creator` records the source's scope, and `cluster-memo-refiner` carries it into the memo as `instances: n/a (population-level — {named source})`. The Pass-3 gate **reads** this; it does not adjudicate it. **If population-level status is not determinable from the memo, the gate does NOT silently choose.** It applies the ceiling *and* flags the row `[POPULATION-LEVEL-UNVERIFIED — operator review]`, exactly as the Tier-C ceiling flags rather than silently downgrading. A silent choice in either direction is the failure mode: firing the ceiling destroys a well-evidenced negative; not firing it launders a sample into a population claim.

### Evidenced Negatives vs Absence of Evidence

These are two different things and the pre-2026-07-14 rules conflated them. `NOT-SUPPORTED` was carrying three unrelated meanings at once: *we found nothing*, *the negative is true*, and *the researcher did not finish looking*. Separated:

- **An evidenced negative is a first-class finding, graded on the ordinary ladder.** A claim whose *content* is negative ("no continuation vehicles were used in this segment", "the practice does not occur in this market") is graded exactly like any positive claim. Sources that looked and recorded nothing, a regulator confirming zero registrations, a dataset carrying a true zero — these are **evidence**, and they count as evidentiary roles. Such a claim **can reach `SUPPORTED`**. Never downgrade a conclusion merely for being negative; an evidenced negative is a result, not a shortfall.
- **Absence of evidence is not evidence of absence.** Failing to *find* evidence establishes nothing about the world. It bounds only what may be **stated**. A claim that failed to find support is `NOT-SUPPORTED` — a statement about the **evidence available for the claim**, never a finding that the claim is false.
- **`NOT-SUPPORTED` never means "false."** It means "unsupported." A `NOT-SUPPORTED` claim **and its negation are both unstateable.** Never invert a `NOT-SUPPORTED` claim into a positive assertion of the opposite — that manufactures an evidenced negative out of an empty search.
- **The test, applied per claim.** Ask: did we find evidence *that X does not happen* (→ grade on the ladder; may reach `SUPPORTED`), or did we merely *fail to find evidence that X happens* (→ state nothing, in either direction)? The § Research Stop Conditions Cond. 3 and Cond. 4 exits are **always the second case** — they record a search that ran out of sources, not a negative that was established. **But note the scope of that statement:** it says a Cond. 3/4 closure never *establishes a negative*. It does **not** assign a class — the class still comes from the role count (a Cond. 3 closure can still carry ≥2 proxy roles → `PROXY-SUPPORTED`). Provenance constrains what the claim *means*, never which class it *lands in*.
- **Process incompleteness is not an evidence verdict.** § Research Stop Conditions' reciprocal rule downgrades claims from incomplete subtasks to `NOT-SUPPORTED`. That is a **process penalty**, not an evidentiary finding. It must be recorded in the Rationale as such — e.g. `NOT-SUPPORTED — incomplete research, no stop condition met` — so no reader can mistake it for a searched-and-found-nothing verdict, and no downstream step can read it as an established negative.

**Verb-list enforcement.** The verb-list above is normative. `evidence-to-report-writer` may NOT pair `establishes` / `confirms` / `shows` with a `PROXY-SUPPORTED` or `ILLUSTRATIVE-ONLY` claim. Cross-checked at Stage 4.3 (`chapter-prose-reviewer`).

> **⚠ Enforcement-gap disclosure (2026-07-14).** The verb-list enforcement asserted immediately above, and the § No-Orphan-Citation Enforcement below, both name consuming skills that **contain no permission-class vocabulary at all** — `evidence-to-report-writer`, `chapter-prose-reviewer`, `citation-converter`, `cluster-synthesis-drafter`. As of this date the enforcement these clauses claim is, on the evidence of the files, **enforced nowhere**. The clauses are retained (they state the intended contract) but must not be relied on as a live control. Routed as an open finding on mission `research-workflow-deploy-fitness`; it is not fixed here. Do not read "Cross-checked at Stage 4.3" as a guarantee that a check runs.

### Lockstep contract (load-bearing)

This section is the **authority**. Four other files carry copies or literals of what it defines, and they were enumerated by grep, not by assumption (a `/risk-check` consumer inventory, 2026-07-14, found one this contract's first draft had missed):

| File | What it carries | Must change when… |
|---|---|---|
| `cluster-memo-refiner` § Check 9 | **Restates all four class conditions** + applies the ceilings at first pass | conditions, names, adjudication order, or ceilings change |
| `claim-permission-gate` | **Relies on the class names as literals**; implements the adjudication order and the ceilings authoritatively at Pass 3 (supersedes Check 9's table at the shared path) | conditions, names, adjudication order, or ceilings change |
| `section-directive-drafter` | **Restates the verb lists and prose framing** per class (not the conditions); converts classes into per-finding prose constraints | **verb lists or prose framing** change — *not* triggered by a conditions-only edit |
| **Each consuming project's own `reference/quality-standards.md`** | A **real local copy of this entire chassis** — *not* a symlink | **always.** See the version-marker hazard below. |

**The project-copy row is the dangerous one.** The skills travel by **symlink** and land in every project the instant a canonical edit merges; this chassis does **not** — each project owns a copy. A canonical change therefore updates the *consumers* and leaves the *rules they consume* stale, silently. That is why the chassis-version marker at the top of this section exists and why both skills hard-exit on it. **Any edit here that bumps the version marker creates a back-port obligation for every deployed project.** Enumerate them before merging.

An edit to the Conditions column, the class names, the adjudication order, or the ceilings requires the paired edits above **and** a `/risk-check` re-fire, per the Canonical-ordering rule. Acceptance test for any such edit: the worked-cases table in § Adjudication order — run every case through the changed rules and show each lands in exactly one class.

This contract exists because the copies **did** silently diverge: before 2026-07-14 the chassis and Check 9 both carried a mixed-axis class table with a gap and an overlap, and nothing bound them. (Same failure class as the Stage-3 input-path contract fixed in thread 1.)

### Version history

| Version | Change | Migration obligation |
|---|---|---|
| `2026-07-14` | **Class conditions re-cut onto a single ordered axis** (independent evidentiary roles → fit). Closed a **gap** (a single direct in-scope source that is not a named example matched *no* class) and an **overlap** (a 2-role pattern claim matched `SUPPORTED` and `ILLUSTRATIVE-ONLY` at once), both demonstrated by execution. The `<3 same-pattern instances` and country-coverage conditions moved **out of the class conditions** and became **ceilings**. `NOT-SUPPORTED` tightened to *zero roles only* (removing a non-role-gated `OR` that created a second overlap). Added § Evidenced Negatives vs Absence of Evidence, § Adjudication order, § Permission ceilings, Stop Condition 5, and the chassis-version marker. **No class was renamed and none was added.** | **Back-port required** for any project on an earlier chassis — the skills will hard-exit until you do. Re-run the gate on already-adjudicated sections: their verdicts were produced by a rule set with a known gap and overlap, so they are neither automatically wrong nor automatically right. |
| *(pre-`2026-07-14`)* | Unversioned. Class conditions cut on mixed axes (quantity / evidence-type / rhetorical-role). | — |

### Minimum Evidence Thresholds

Project-fillable **calibration on top of the generic bar** — never a redefinition of it. The chassis owns the class conditions (above); the per-claim-type table lives in `reference/claim-permission.md` (template at `reference/claim-permission.template.md`, FX-B5).

A project row may **raise** the number of independent evidentiary roles a given claim type needs before it reaches `SUPPORTED` (e.g. "market-sizing claims require 3 roles, not 2"). A project row may **not** lower the generic bar, redefine a class, or introduce a class name. When no `claim-permission.md` row applies — or the file is absent or unfilled — the generic bar in the Conditions column governs, and the run must disclose the **GENERIC-BAR regime** (see `claim-permission-gate` pre-flight).

A claim that fails a raised per-claim-type threshold is graded by the ordinary axis on the roles it *does* have — it does not "fall through." The class ladder above is total; the project table only moves where `SUPPORTED` begins.

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
5. **The question's maximum supplementary passes are exhausted** (per § Evidence Scarcity Handling — 2 per question in Stage 2, 2 in Stage 3) **and the source ladder has been worked to its end**, whatever was or was not found. The subtask closes as **confirmed evidence scarcity**; the claim is then graded on the evidence it actually has, per § Claim-Permission Classes.

> **Condition 5 was added 2026-07-14 to close a structural trap, and it is load-bearing.** Conditions 1–4 alone are **not exhaustive**: a subtask that found *exactly one* direct source can satisfy none of them — Cond. 1 needs two sources; Cond. 2 needs one source **plus three named examples**; Cond. 3 and Cond. 4 both require that *no* evidence was found. Such a subtask could therefore never legally stop, so the reciprocal rule below flagged it "incomplete research" and downgraded its claim to `NOT-SUPPORTED` — which made **`ILLUSTRATIVE-ONLY` (exactly 1 evidentiary role) structurally unreachable**, since every claim that would land there arrives via a subtask that met no stop condition. The class survived in practice only because no skill ever implemented the reciprocal rule. That is not a safeguard; it is an unenforced rule masking a contradiction. Cond. 5 gives the one-source subtask a legitimate exit and restores `ILLUSTRATIVE-ONLY` to reachability.

**Reciprocal rule** (a subtask may NOT stop until at least one condition is true): Subtasks that exit before any condition is met are flagged as "incomplete research" and the affected claims are downgraded to NOT-SUPPORTED by default per § Claim-Permission Classes.

> **Scope of the reciprocal rule — narrow, and narrower than it reads.** It penalises **abandonment**: a subtask that stopped *early*, with passes still available and the source ladder unworked. It does **not** fire on a subtask that worked the ladder to its end and found little — that subtask closes legitimately under Cond. 5. "We looked properly and found one source" is an evidence outcome (`ILLUSTRATIVE-ONLY`), **not** a process failure (`NOT-SUPPORTED`). Applying this rule to a diligent, thin-yield subtask is the error Cond. 5 exists to prevent.
>
> **It is a CEILING, not a class condition** (settled 2026-07-14). The reciprocal rule is a verdict about the **process**, not about the evidence — so it cannot live on the class axis, which § Claim-Permission Classes grades on evidence alone. Left un-placed, it was a *third* axis colliding with the other two: a 1-role claim from an abandoned subtask matched `ILLUSTRATIVE-ONLY` (on evidence) and `NOT-SUPPORTED` (on process) with nothing to arbitrate. It is therefore a **process ceiling** — the fourth ceiling — capping the claim at `NOT-SUPPORTED`. Being a cap, it composes monotonically downward with the other three (most-restrictive binds), and the class partition stays total. Record it in the Rationale as `NOT-SUPPORTED — process ceiling: incomplete research, no stop condition met`, never as a bare evidence verdict.
>
> **Enforcement status (disclosed, NOT fixed — do not rely on this rule).** As of 2026-07-14 **no skill implements it.** `claim-permission-gate` runs roles → fit → ceilings and has no step for it; and the refined cluster memo — the gate's only input — **carries no stop-condition or subtask-completeness field at all**, so a gate could not evaluate the rule even if a step existed. Wiring it requires a memo-schema change upstream, which is out of scope here. Treat this as **stated intent, not a live control.** Routed as an open finding on mission `research-workflow-deploy-fitness`.

> **This downgrade is a process penalty, not an evidence verdict.** It must be recorded in the claim's Rationale as `NOT-SUPPORTED — incomplete research, no stop condition met`, distinguishable from a searched-and-found-nothing verdict. An incomplete search establishes nothing in either direction: it licenses neither the claim nor its negation. See § Claim-Permission Classes → Evidenced Negatives vs Absence of Evidence.

**Conditions 3 and 4 record an absence of evidence, never an evidenced negative.** "Three source classes checked and no direct evidence exists" and "all searches failed" both mean *the search ran out of sources* — they do **not** establish that the thing searched for does not exist. **A claim closed via Cond. 3 or Cond. 4 may not be stated, and neither may its negation**; do not let an exhausted search become a finding.

> **Cond. 3 / Cond. 4 closure does NOT assign a class** (corrected 2026-07-14 — this sentence previously read "*a claim closed via Cond. 3 or 4 **is `NOT-SUPPORTED`***", which contradicted the class table). Closure is **provenance**, and provenance never selects a class — the class is set at the gate by **counting evidentiary roles**, however the subtask closed. The two are usually consistent (Cond. 4 typically leaves zero roles → `NOT-SUPPORTED`), but **Cond. 3 does not**: it says only that no *direct* evidence exists, so a claim may close via Cond. 3 while still carrying **two or more proxy roles** — which is `PROXY-SUPPORTED`, not `NOT-SUPPORTED`. Reading closure as a class assignment made such a claim match both, breaking the partition. Count the roles.

**Evidence-ceiling marking.** Extracts that closed via condition 3 or 4 are marked `EVIDENCE-CEILING-REACHED` by `research-extract-verifier`.

> **The marking is provenance, not a class** (corrected 2026-07-14). This rule previously said such claims are "**pre-classified** PROXY-SUPPORTED or NOT-SUPPORTED" — which contradicts the class table, since `PROXY-SUPPORTED` requires **≥2 independent evidentiary roles** and a Cond. 3 / Cond. 4 closure asserts nothing about the role count (Cond. 3 says only that no *direct* evidence exists — proxy roles may still be present; Cond. 4 typically leaves zero). A provenance marker may **not** select a class. `EVIDENCE-CEILING-REACHED` records *how the search ended* and travels with the extract as a caution flag; the claim's class is determined **at the gate, by counting roles**, exactly as for any other claim. Where the marking is useful is in the Rationale — it tells the operator the evidence base was ceiling-limited — and in § Evidenced Negatives, where it is the signal that this is a **failed search, not an established negative**.

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
