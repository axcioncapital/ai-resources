# Execution Manifest Template

Use this template for the output. Adapt section counts to match the actual routing results — omit the Research GPT Sessions section entirely if all questions route to CustomGPT, and omit the CustomGPT Research Queue if all route to Research GPT.

---

```markdown
# Execution Manifest: [Section ID] — [Section Title]

## Routing Summary

| Question ID | Question Short Title | Route | Routing Rationale |
|-------------|---------------------|-------|-------------------|
| Q1 | [Title] | Research GPT | [1-line reason specific to this question] |
| Q2 | [Title] | CustomGPT | [1-line reason specific to this question] |
| ... | ... | ... | ... |

**Distribution:** [X] questions → Research GPT, [Y] questions → CustomGPT

## Source-Plan Table (#1-lite)

Per-question paywall classification and search plan. Embedded here in the manifest — not a standalone artifact.

| Research Question | Required Source Classes | Native-Language Requirement | Paywall Risk | Stop Condition |
|-------------------|------------------------|----------------------------|--------------|----------------|
| Q1 | [source classes from source-class-hierarchy] | [per § Country-Specific Language-Block Routing — e.g., Swedish; or "English-only"] | [public-answerable \| public-proxyable \| public-gated → Tier-X route \| not-worth-pursuing (reason)] | [tier + paywall route — e.g., "Fast-lane: 5–8 proxy searches + #24 check, then stop unless operator overrides"; or "Tier-A gated: full deep session"; or "normal sourcing"] |
| ... | ... | ... | ... | ... |

**Paywall-risk classes:** `public-answerable` (direct public source plausibly exists) · `public-proxyable` (public proxy only; ceiling = PROXY-SUPPORTED) · `public-gated` (paywalled; route by risk tier per § Risk-Tier Model control matrix) · `not-worth-pursuing` (below worth-doing floor; record reason).

**If no #24 register (`reference/known-limits.md § Known-Unavailable-Evidence Register`) is present:** add a loud degraded-mode note here — *"Paywall classification ran without a #24 register — gated calls are best-effort, anchored on search results only."*

## Research GPT Sessions

**Sessions: [count]**

| Session | Questions | Cluster Logic | Dependencies | Tool |
|---------|-----------|---------------|--------------|------|
| A | Q1, Q2 | [Why grouped — source overlap, conceptual chain, or analytical lens] | None | Research GPT |
| B | Q3, Q5 | [Why grouped] | After Session A | Perplexity |
| C | Q6, Q7 | [Why grouped] | None | Research GPT |

**Parallel opportunities:** [Which sessions can run simultaneously]

## CustomGPT Research Queue

| Question ID | Question Short Title | Batch | Notes |
|-------------|---------------------|-------|-------|
| Q4 | [Title] | 1 | [Execution notes — specific sources to target, known constraints] |
| Q10 | [Title] | 1 | [Notes] |
| Q11 | [Title] | 2 | [Notes] |

**Execution approach:** Run in the Research CustomGPT with web access. Batch 2–3 questions per run. Paste the Answer Specs for the batch. Each question should produce a sourced research report that Claude can extract from downstream.

## Operator Notes

[Any flags, uncertainties, or recommendations for the operator — e.g., borderline routing decisions that may need override, anticipated thin-results areas, suggestions for execution order between Research GPT and CustomGPT paths]
```

---

## Worked Example

The template above stays a literal fill-in-the-blank — do not edit it. This section walks one question end-to-end (Answer Spec → routing decision → session assignment → source-plan row) so the placeholder brackets above have a concrete reference point.

**Example section:** 5 questions total. **Distribution:** 4 questions → Research GPT, 1 question → CustomGPT. **Research GPT Sessions: 2.**

**Answer Spec input for Q3** (abbreviated): "What is the typical hold period for Swedish lower-mid-market PE exits via secondary buyout, 2020–2025?" Risk tier: Tier B. Source independence: 3+ sources required for a COVERED verdict. Note: Nordic lower-mid-market secondary-buyout data isn't aggregated in any public deal tracker — large-cap Nordic deals are well covered by English-language deal press, lower-mid-market less so.

**Routing decision:** Research GPT, on source scarcity (§ Routing Criteria) — no single accessible source aggregates Swedish lower-mid-market hold periods; the answer needs cross-referencing across practitioner reports, Nordic PE association publications, and deal-database fragments. This is a Sweden-specific question, so it also carries a Swedish-language pass (§ Country-Specific Language-Block Routing, S-04).

**Routing Summary row (filled):**

| Question ID | Question Short Title | Route | Routing Rationale |
|-------------|---------------------|-------|-------------------|
| Q3 | Swedish LMM secondary-buyout hold periods | Research GPT | Source scarcity — no public aggregator covers Swedish lower-mid-market hold periods; needs cross-referenced practitioner sources |

**Research GPT Sessions row (filled):** Q3 is clustered with Q4 (buyer-side rationale for the same deal set) into Session 2 — a soft dependency, so both prompts embed the same Nordic-market baseline assumptions rather than being sequenced. Q3's own English pass is single-directive, so its Swedish pass lands as a sub-block inside Session 2 rather than a separate session (§ Country-Specific Language-Block Routing, block-or-session rule): Session 2 runs English + Swedish (sub-block).

| Session | Questions | Cluster Logic | Dependencies | Tool |
|---------|-----------|---------------|--------------|------|
| 2 | Q3, Q4 | Both address Swedish LMM secondary-buyout dynamics — Q3 quantifies hold period, Q4 covers buyer rationale for the same deals | Soft: Q4 shares deal set and Nordic-market baseline assumptions with Q3 | Research GPT |

**Source-Plan Table row (#1-lite, filled):** Hold-period data at this granularity lives mainly in paywalled deal databases (PitchBook, Mergermarket); no strong public proxy exists, so this need classifies `public-gated`. At Tier B, that routes to the fast-lane scarcity audit, not a full deep session.

| Research Question | Required Source Classes | Native-Language Requirement | Paywall Risk | Stop Condition |
|-------------------|------------------------|----------------------------|--------------|----------------|
| Q3 | Practitioner deal reports, Nordic PE association publications, deal-database fragments | Swedish (Sweden-specific question, S-04) | public-gated → Tier B fast-lane | Fast-lane: 5–8 proxy searches + #24 check, then stop unless operator overrides |
