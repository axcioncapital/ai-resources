---
name: research-extract-creator
description: >
  Produce structured Research Extracts from a component-organized research
  report and its corresponding Answer Specs — one extract per research question.
  Each extract contains a claims inventory with source attribution, evidence
  strength ratings, coverage verdicts per Answer Spec component, component
  syntheses, and gap/conflict documentation. Use when Patrik provides a research
  session output alongside Answer Specs and says "extract this," "create research
  extracts," "process this research output," "run extraction," or when a
  research report is provided with Answer Specs and the expectation of structured
  extracts. This is Step 2.3 of Stage 2 in the Axcion Research
  Workflow. Do NOT use for evidence verification against specs
  (evidence-spec-verifier), cluster-level analysis (cluster-analysis-pass),
  report prose writing (evidence-to-report-writer), or supplementary research
  decisions (operator's review at Step 2.4).
model: sonnet
effort: medium
---

# Research Extract Creator

## Inputs

Both provided by the operator in a single message:

1. **Component-organized research report** — one session's output from the Research Executor, covering 2–4 research questions. Findings are organized under `Q[n]-A##` headers (question → answer spec component), with source citations carrying page title, URL, and access date. The report includes a **Source Log** (consolidated list of all sources cited), a **Known Gaps** section (components where the executor found insufficient evidence), and a **Conflicts** section (where sources disagree).
2. **Answer Specs** — for the specific questions covered in this session. Each spec lists required components and completion gates.

If either input is missing, ask for it before proceeding. If Answer Specs don't match the question/component headers in the report, flag the mismatch and ask for clarification.

## Output

One Research Extract per research question, written to a single markdown file. Use the template in `references/extract-template.md`.

Write output to the project's working directory using the naming convention: `research-extract-[session identifier].md` (e.g., `research-extract-A.md`). If no session identifier is provided, ask.

## Extraction Logic

### Claim Extraction

- Read the research report component by component (each `Q[n]-A##` section).
- Extract individual claims from the prose under each component header. Restate each claim in own words — do not copy verbatim from the report.
- Assign Claim IDs: `[Question ID]-C[sequential number]` (e.g., Q1-C01, Q1-C02).
- A single paragraph or table row may yield multiple claims if it contains distinct factual assertions.
- Primary component mapping is given by the report structure — a claim extracted from a `Q[n]-A##` section belongs to that component. When a finding under one component is also relevant to another, cross-reference it in the secondary component.

### Source Attribution

- Carry over source citations (page title, URL, access date) exactly as cited in the research report. Cross-check against the report's Source Log for completeness.
- Do not verify, modify, or enrich source citations — take them at face value.
- Record the source locator: component header (`Q[n]-A##`) and position within it (paragraph number, table label, bullet position) in the research report.

### Evidence Strength (per claim)

| Rating | Criteria |
|--------|----------|
| **H** | Multiple independent credible sources; primary or institutional data; direct evidence from a primary or institutional source |
| **M** | Single credible source, or multiple sources with shared editorial origin; indirect but reasonable evidence |
| **L** | Single source of uncertain quality; inferential; tangential relevance; vendor/advocacy source without corroboration |

### Evidence Freshness (per claim)

Every extracted claim carries an `evidence_date` field — the date of the evidence supporting the claim (publication / event / disclosure date, not the access date). Use the format `YYYY-MM` (or `YYYY-MM-DD` if available). Where a claim is supported by multiple sources of different ages, record the date of the **most recent** load-bearing source.

Apply the freshness classification using the table below. The class is canonical (exact-string match required by downstream consumers):

| Class | Period | Permitted use |
|---|---|---|
| `CURRENT` | 2025–2026 | Current-state claims |
| `RECENT` | 2023–2024 | Recent-trend claims |
| `BASELINE` | 2020–2022 | Baseline or pre/post comparison only |
| `STRUCTURAL` | Pre-2020 | Structural background only |

(Periods are project-agnostic relative to the "current" rolling 2-year window declared in the project's `reference/known-limits.md` or equivalent reference doc. If the project does not declare a window, default to a current-window-equals-rolling-2-years posture and emit a one-line warning naming the absent declaration.)

**Mismatch flag.** When a claim attempts to support a current-state assertion from `BASELINE` or `STRUCTURAL` evidence, attach a `[FRESHNESS-MISMATCH]` tag inline with the claim. Downstream consumers (`cluster-memo-refiner`, the deferred claim-permission gate) use this tag to downgrade or filter. This skill emits the flag; it does NOT downgrade — downgrade is the consumer's job.

### Evidence Lens (per claim — S-02 No-Source-Substitution Rule)

Every extracted claim carries an evidence-lens tag indicating whether the claim is supported by direct in-lens evidence, by proxy evidence with downgrade, or by no evidence at all. Tags are canonical (exact-string match required by downstream consumers per `reference/quality-standards.md § No-Source-Substitution Rule`):

| Tag | Conditions |
|---|---|
| `IN-LENS` | Claim is supported by evidence matching the research question's exact lens (geography + deal-size band + sponsor tier + time frame as applicable). |
| `PROXY-DOWNGRADE` | Claim is supported only by proxy evidence (above-lens deal, pan-Nordic aggregate for country-specific claim, adjacent-country example, etc.). The proxy nature MUST be named explicitly in the claim's Notes field (e.g., "above-lens — €120M deal cited as illustration of pattern"). |
| `NO-EVIDENCE` | No direct or proxy evidence found at any source class. The component's coverage verdict for this claim is MISSING. |

**No-substitution rule (the load-bearing constraint).** This skill MUST NOT absorb proxy evidence into IN-LENS-tagged claims. If the research report's claim about Finnish €2–25M PE deals is actually supported only by a Nordic-wide aggregate or a Swedish example, the claim is tagged `PROXY-DOWNGRADE` (or `NO-EVIDENCE` if no proxy is named), not `IN-LENS`. The proxy nature is the load-bearing fact; silent substitution is the precise anti-pattern this tag exists to prevent.

**Operating rule.** If the report broadens the claim's scope to match available evidence (e.g., a question about Finland answered with "Nordic PE activity has grown"), the extract MUST:
- (a) preserve the claim's original lens (the Finland scope), and
- (b) tag the claim `PROXY-DOWNGRADE` (or `NO-EVIDENCE` if even the Nordic aggregate doesn't address the original claim), and
- (c) name the substitution in the claim's Notes (e.g., "answered with Nordic aggregate; Finland-specific evidence not found").

The extract does not "fix" the report's scope drift by re-narrowing the claim to fit the evidence. It documents the gap, tags accordingly, and routes downstream.

### Independence Counting

- Count editorially independent sources supporting each claim.
- Syndicated content, derivative reports citing the same primary data, and secondary sources restating the same original finding count as one.
- If independence is unclear, note the uncertainty rather than guessing.

### Coverage Verdicts (per Answer Spec component)

| Verdict | Threshold |
|---------|-----------|
| **COVERED** | ≥2 claims with ≥1 at H strength, OR ≥3 claims at M strength with ≥2 independent sources across them |
| **THIN** | 1 claim at any strength, OR 2+ claims but all L strength, OR only sources with shared editorial origin |
| **MISSING** | No claims extracted for this component |

**Label correction discipline.** When correcting a verdict label (e.g., COVERED → THIN), update **all occurrences in a single pass** — the Coverage Verdicts table row, the Gaps section entry, and the Component Synthesis — before flagging for re-verification. Partial correction (table only, Gaps left stale) forces a second QC cycle and leaves a residual mismatch that downstream consumers may misread.

### Component Synthesis

Per component, write 2–3 sentences summarizing what the evidence collectively shows. State what is established (H-grade claims), what is suggested (M), and what remains uncertain (L or gaps). This is analytical framing — what the evidence means, not a claim recap. The synthesis must be derivable from the claims listed below it. Do not introduce framing the claims don't support.

### Gaps

Start from the report's Known Gaps section — these are components the executor flagged as insufficiently evidenced. Ingest each, then apply the extract-creator's own coverage verdicts to confirm or reclassify. Final gap classification:

- **Not addressed** — component absent from the report entirely
- **Searched but not found** — report's Known Gaps flags scarcity, confirmed by extract coverage
- **Found but weak** — evidence exists but below COVERED threshold (may or may not appear in Known Gaps)

Note whether the gap matters for downstream narrative.

### Conflicts (S-19 Source-Conflict Mitigation Procedure)

Start from the report's Conflicts section — these are disagreements the executor documented. Ingest each, then assess which position has stronger support based on source credibility and independence, and recommend handling (resolve, present both, flag as open). If additional conflicts emerge during claim extraction that the report did not flag, document those as well.

**No-silent-selection rule (the load-bearing constraint).** When an extract claim's evidence base includes two sources reporting different values or classifications for the same fact, the extract MUST record BOTH values AND trigger a conflict-log entry. The extract MUST NOT silently pick one value, average them, or omit the conflict. Examples:

- EY reports €14.2B total Nordic PE deal value (H1 2025); KPMG reports €11.8B for the same period → record both in the claim's Notes, emit a conflict-log entry.
- Source A classifies a deal as "platform"; Source B classifies the same deal as "add-on" → record both classifications, emit a conflict-log entry.

**Conflict-log emission.** For every conflict identified (whether pre-flagged by the report or newly surfaced during extraction), emit an entry to `analysis/source-conflicts/{section}/{section}-source-conflict-log.md` per the canonical file-conventions row. Required fields per entry:

| Field | Content |
|---|---|
| Conflict ID | Auto-incrementing within the section |
| Claim | The specific claim text being conflicted |
| Source A | Name |
| Source A value | Value/finding |
| Source B | Name |
| Source B value | Value/finding |
| Conflict type | `numeric` / `categorical` / `interpretive` |
| Triggering extract | Section + Q[n] + Claim ID (e.g., `1.1-Q3-C04`) |
| Initial status | `OPEN` (resolution status is set downstream by the cluster-memo-refiner Check 10 routing or the Source-Conflict Resolution Procedure in `quality-standards.md`) |

This skill emits the conflict-log entry with `status: OPEN`. Resolution (triangulation per Step 2, or adjudication per Step 3 of the procedure) happens in `cluster-memo-refiner` Check 10 or operator review — NOT in this skill. The downstream consumer updates the entry's status to `RESOLVED-METHODOLOGY` / `RESOLVED-GRANULARITY` / `RESOLVED-TRIANGULATION` / `UNRESOLVED`.

## Failure Behavior

- **Component not covered in report** → mark MISSING in Coverage Verdicts. Component Synthesis: "No evidence found in the research report for this component." Do not synthesize from training data or infer from adjacent evidence.
- **Evidence is thin** → extract claims that exist, mark THIN, write Component Synthesis reflecting the limited evidence. Do not complete the component with plausible-sounding filler.
- **Ambiguous source citation** (URL missing, source name unclear) → carry through with a caveat in Notes: "[Source citation unclear in original report]". Cross-check the report's Source Log. Do not fabricate source metadata.
- **Contradictory claims** → capture both as separate claims in the Claims Inventory and document in the Conflicts section. Do not silently resolve by picking one.

If the provided information is insufficient to extract confidently, say so rather than inferring. Leave gaps rather than invent plausible-sounding details.

## Scope Boundaries

This skill extracts and structures — it does not verify sources, supplement evidence from training data, make editorial judgments about report inclusion, or compress/summarize content.

## Output Protocol

No refinement mode. Produce all Research Extracts for the session in a single file. The operator reviews extracts at Step 2.4 and requests re-extraction if needed.
