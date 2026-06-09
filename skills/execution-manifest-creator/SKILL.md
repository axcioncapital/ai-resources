---
name: execution-manifest-creator
description: >
  Analyze a section's Answer Specs and Research Plan to route each research
  question to the optimal execution tool — Research GPT (primary) or
  Perplexity (secondary) for high-complexity questions, or a Research
  CustomGPT with web access for standard questions. Groups Research GPT
  questions into sessions. Produces an Execution Manifest the operator
  follows during research
  execution. Trigger when Answer Specs are complete and the operator needs to
  plan execution routing, or on requests like "create execution manifest,"
  "route these questions," or "plan the execution." This is the first step in
  Stage 2 of the Axcion Research Workflow — it runs before
  research-prompt-creator. Do NOT use for research plan creation
  (research-plan-creator), answer spec generation (answer-spec-generator),
  writing execution prompts (research-prompt-creator), or evidence
  extraction.
model: sonnet
effort: medium
---

# Execution Manifest Creator

## Purpose

Route research questions to the right execution tool, group Research GPT questions into sessions, and produce a manifest the operator follows during execution. This preserves cross-model separation: GPT handles all evidence gathering (both paths), Claude handles synthesis, extraction, and QC.

## Input Requirements

**Required:**
1. **Answer Specs** — per-question specifications for all questions in the current research section
2. **Research Plan** — scope, source landscape context, key terms for the current section

Both provided by the operator. Do not generate these.

**If inputs are incomplete:** Flag missing elements. Halt for critical gaps (missing Answer Specs, missing scope parameters). Proceed with best-effort routing for non-critical gaps (e.g., missing source preferences) and flag assumptions.

## Routing Criteria

Evaluate each question against these criteria to determine routing.

### Route to Research GPT when:

- **Source scarcity** — the topic has sparse, niche, or hard-to-find sources (e.g., Nordic mid-market PE practices, practitioner behavioral patterns, unpublished industry data). Research GPT's autonomous browsing across 30+ sources is needed to surface what exists.
- **Source breadth required** — the answer requires synthesizing many sources of different types (academic, practitioner, industry reports, vendor publications). A single search session won't cover it.
- **Exploratory scope** — the question is open-ended enough that the researcher doesn't know in advance which sources will be valuable. Research GPT's ability to pivot during execution is the advantage.
- **Cross-referencing needed** — the answer requires comparing claims across multiple source types to assess reliability (e.g., validating a specific data claim against original sources).

### Route to CustomGPT when:

- **Well-sourced topics** — abundant, accessible, high-quality sources exist (published frameworks, standard industry practices, established academic research). Standard web browsing surfaces the key sources efficiently.
- **Definitional or structural questions** — the answer is primarily about defining concepts, mapping structures, or describing established processes where a few authoritative sources suffice.
- **Known source landscape** — the Answer Spec or Research Plan identifies specific source types or publications likely to contain the answer. Targeted browsing is sufficient.
- **Synthesis over discovery** — the question primarily needs analytical synthesis of known material rather than discovery of unknown sources.
- **Low independence requirement** — the Answer Spec doesn't require high source independence counts — a few credible sources are sufficient for a COVERED verdict.

### Tie-breaking rules:

1. When a question could go either way, route to CustomGPT. Preserve Research GPT sessions for questions that genuinely need browsing depth.
2. If a question is borderline between Research GPT and CustomGPT, route to CustomGPT. Preserve Research GPT sessions for questions that genuinely need browsing depth.
3. Questions with MISSING-risk components (anticipated thin results) should stay on Research GPT — supplementary research is more expensive than getting depth on the first pass.

### Tool selection — Research GPT vs Perplexity:

- **Research GPT (default):** Better for broad exploratory research, longer reports, more source depth. Use unless a Perplexity-specific condition applies.
- **Perplexity:** Better when the source landscape is known and targeted, when Nordic/Scandinavian source bias is valuable, or when the question benefits from Perplexity's citation style.
- **Tie-breaker:** When conditions point in different directions, prefer Research GPT. Consider assigning Perplexity to a later session to diversify source coverage across the section.

## Session Grouping Logic (Research GPT only)

After routing, group Research GPT questions into sessions:

1. **Respect dependencies first:** Map all dependencies before grouping. Dependencies are hard constraints that override clustering preferences.
2. **Target 2 questions per session.** Sessions of 1 or 3 are acceptable when dependency constraints or strong source overlap justify it. Avoid sessions larger than 3 — smaller sessions produce deeper coverage.
3. **Optimize by source overlap** (strongest signal), then conceptual chain, then analytical lens.

### Dependency Classification

Classify every inter-question relationship before grouping. Each pair of questions with a relationship gets exactly one classification:

- **Hard dependency:** Question B requires Question A's output as input (e.g., B synthesizes A's findings, B's scope is defined by A's results). **Handling:** Place in sequential sessions. The manifest's dependency column must show the upstream session. The downstream session cannot execute until the upstream session's extracts are available.
- **Soft dependency:** Questions A and B analyze overlapping phenomena from different angles — consistency matters but neither requires the other's output. (e.g., both address capacity constraints, one maps the bottleneck while the other maps the role structure that creates it). **Handling:** Either (a) sequence the sessions and note that the later session benefits from the earlier session's context, or (b) embed shared analytical assumptions from the Research Plan into both prompts so they work from the same baseline. The manifest's dependency column must show "Soft: [brief description]" — never "None."
- **None:** No analytical relationship. Questions address unrelated phenomena with no overlap in scope, actors, or mechanisms.

**Classification test:** If a steering note would reference another session's findings (e.g., "should be consistent with Session A's coverage gap findings"), that is at minimum a soft dependency. If the reference would say "requires" or "depends on," it is a hard dependency. Do not classify a relationship as "None" and then add a cross-session flag in the prompt — that is a contradiction.

## Country-Specific Language-Block Routing (S-04)

When a research question targets country-specific evidence (Sweden, Norway, or Finland individually — not a Nordic-wide aggregate question), the manifest must route a dedicated local-language search block alongside the English-language pass. The block can land as either (a) a sub-block within the same Research GPT session as the English pass, or (b) a dedicated session for the local-language pass when the country's evidence load is large enough to warrant separation.

**Language-block assignments:**

| Country in question | Required local-language pass |
|---|---|
| Sweden-specific | Swedish |
| Norway-specific | Norwegian |
| Finland-specific | Finnish |
| Two-country (e.g., Sweden + Finland) | Both relevant languages, separate blocks |
| Three-country (Sweden + Norway + Finland) | All three languages, separate blocks |
| Pan-Nordic aggregate (no country breakdown required) | English-only is acceptable |

**Block-or-session decision rule.** If the country-specific question is paired with an English pass that already targets ≥3 directives, route the local-language pass as a separate session to preserve session-depth budgets (per the 2-questions-per-session target rule above). If the English pass is single-directive or two-directive, the local-language pass lands as a sub-block within the same session.

**Manifest column.** The manifest must include a `Language passes` column for every Research GPT session, listing which language passes (English + which local languages) the session contains. CustomGPT-routed questions do not require this column (CustomGPT lacks the search-language steerability for native-language passes).

**Rationale.** Stage 2 English-only searches over-represent large-cap deals because the international press picks up large transactions; native-language press picks up lower-mid-market deals that don't reach the English wires. The dedicated local-language block is the primary remediation for the "Norway / Finland evidence thin because English-only" failure mode that R1 exposed. This is a Bundle 2b enforcement coupled to `research-prompt-creator`'s native-language search-term blocks.

## CustomGPT Batching Logic

Group CustomGPT questions into batches of 2–3 questions per run:

1. Group by source overlap where possible (questions likely answered by the same literature).
2. No hard session cap — CustomGPT runs are independent of Research GPT sessions.
3. Recommend starting a new chat after 2–3 batches to prevent context degradation.

## Paywall Classification & Source-Plan Table (#5 / #1-lite)

PE/M&A evidence is structurally paywall-exposed (PitchBook, Preqin, Dealogic, Mergermarket, Cambridge Associates). Classifying paywall exposure **at manifest time** prevents the workflow from spending a full deep session discovering, expensively, that the answer is not publicly obtainable. This is an additive manifest section — it does not change the GPT-vs-CustomGPT routing **criteria** (§ Routing Criteria) or session grouping. It annotates each need before execution and may additionally mark a need out-of-scope (`not-worth-pursuing`), removing it from both queues.

**Ordering:** evaluate paywall class **first**, before tool routing. A `not-worth-pursuing` need is removed before § Routing Criteria is applied; routing and session grouping then run only over the surviving (routed) needs.

### Four-way paywall classification

Classify **each evidence need** into exactly one class:

| Class | Meaning | Route |
|---|---|---|
| `public-answerable` | A direct public source plausibly exists | Normal sourcing (full ladder per the question's risk tier) |
| `public-proxyable` | No direct public source, but a public proxy exists (lagged, adjacent, aggregate) | Normal sourcing against the proxy; permission ceiling = PROXY-SUPPORTED |
| `public-gated` | The real answer lives behind a paywall; public proxies are weak or absent | Route by risk tier — see the tier rule below |
| `not-worth-pursuing` | Below the worth-doing floor (immaterial, or answerable only at disproportionate cost) | Skip; record as out-of-scope with a one-line reason |

The `not-worth-pursuing` call is an **inline worth-doing judgment** with the reason recorded in the manifest. Do NOT route it through `/implementation-triage` — per-question triage is too heavy.

**Question-vs-need granularity (most-restrictive binds).** Classification is per *evidence need*; the #1-lite table and the Self-Check are per *research question*. Resolve a multi-need question in two steps:
1. **Skip test first.** A question whose *every* need is `not-worth-pursuing` is skipped out-of-scope entirely — no row in the routed manifest; record it in Operator Notes with the one-line reason. A question with at least one routable need stays routed.
2. **Row label for routed questions.** The row carries the **most-restrictive routable** class (`public-gated` > `public-proxyable` > `public-answerable`); any `not-worth-pursuing` sub-needs are noted as dropped in the `stop condition` cell, not as the row's class. This mirrors the most-restrictive-binds rule the risk-tier model already uses (`reference/quality-standards.md § Risk-Tier Model`).

### The public-gated route defers to the #17 control matrix

A `public-gated` need does NOT take a flat "gated → stop" route. It defers to the already-landed risk-tier control matrix in `reference/quality-standards.md § Risk-Tier Model` (control-matrix row **"Paywall fast-lane (#5)"**). Read the need's `risk-tier:` from the research plan (presence-gated — absent tier defaults to Tier B, per § Risk-Tier Model):

| Risk tier of the gated need | Route |
|---|---|
| **Tier A** | **Full deep session** — a Tier-A need carries the thesis verdict; it is the case important enough to accept a proxy-only or anecdote-only answer, so it earns the deep search. NOT fast-lane. |
| **Tier B / Tier C** | **Fast-lane scarcity audit** — the bounded audit (5–8 proxy searches + #24 register check, then stop) runs in `research-prompt-creator`. The operator may promote a fast-laned B/C need to a deep session; that override rides the **existing** manifest-approval gate — no new gate. |
| **Tier D** | **Not pursued** — illustrative-only by construction; a gated Tier-D need is recorded as not-pursued. Applies only to needs **explicitly** tagged Tier D in the research plan; the Tier-B default (for an absent `risk-tier:`) never produces a Tier-D route. |

This column must **not** null the fast lane (do not apply Tier-A's full-ladder route to B/C) and must **not** null the override (do not turn `gated` into a hard stop for B/C). The tier sets the route; the operator override is the escape hatch for a wrongly-fast-laned important need.

**Authoring boundary.** This skill *records the route label only* — the actual 5–8-search fast-lane audit is authored and executed by `research-prompt-creator`. The manifest's `stop condition` cell carries the label verbatim (e.g., "Fast-lane: 5–8 proxy searches + #24 check, then stop unless operator overrides"); it does not expand into a per-search plan here.

### #1-lite — embedded source-plan table

Add a compact per-question **source-plan table to the manifest output** (never a standalone artifact — bloat guard). Columns:

| Column | Source |
|---|---|
| `research question` | the manifest question |
| `required source classes` | `reference/source-class-hierarchy.md` |
| `native-language requirement` | per § Country-Specific Language-Block Routing above — reference that section's logic; do not restate it here. For a **CustomGPT-routed** country-specific question (CustomGPT lacks native-language steerability), the cell reads `N/A (CustomGPT — no native-language pass); flag for Research GPT reroute if native evidence is load-bearing` |
| `paywall risk` | the four-way classification above (e.g., `public-gated → Tier B fast-lane`) |
| `stop condition` | the tier (#17) + paywall route (e.g., "Fast-lane: 5–8 proxy searches + #24 check, then stop unless operator overrides"; or "Tier-A gated: full deep session") |

This table is the **prospective** counterpart to `research-extract-verifier`'s retrospective Source-Surface Coverage check — it designs the search before it runs. The table (and its loud degraded-mode note, below) is rendered in the manifest at the location shown in `references/manifest-template.md`.

### #24 register consult is graceful-absent

The downstream fast-lane audit checks the project's known-unavailable-evidence register (`reference/known-limits.md § Known-Unavailable-Evidence Register`) to anchor a `public-gated` classification in a curated catalogue rather than search luck. The register is **project-local** and is NOT carried by the canonical workflow template. If it is absent, **skip the register anchor — do not halt** — and emit a **loud degraded-mode note** in the manifest: e.g., *"Paywall classification ran without a #24 known-unavailable-evidence register — gated calls are best-effort, anchored on search results only."* Never silent.

The residual scarcity labels the downstream audit emits (`Proprietary` = exists, paywalled; `Gated` = exists, partially public/lagged; `Opaque` = may not exist at all) are a **distinct scarcity taxonomy** describing public-obtainability. They are NOT a competitor to the claim-permission classes (SUPPORTED / PROXY-SUPPORTED / ILLUSTRATIVE-ONLY / NOT-SUPPORTED), which grade evidential strength — the two axes coexist.

## Dependency: Research CustomGPT

The CustomGPT execution path requires a Research CustomGPT with web access. This is a lighter research tool that handles well-sourced, lower-complexity questions without the full research execution workflow. Research extraction and QC are handled downstream by `research-extract-creator`.

## Failure Behavior

- **All questions route to Research GPT** — that's fine. Produce a manifest with no CustomGPT queue. Verify session groupings follow the 2-question target.
- **All questions route to CustomGPT** — that's fine. Produce a manifest with no Research GPT sessions. The `research-prompt-creator` step is skipped entirely.
- **Routing rationale genuinely unclear** — route to CustomGPT with a note: "Borderline — rerouted to CustomGPT. Consider Research GPT if CustomGPT results are thin."
- **Answer Specs ambiguous about source requirements** — flag the ambiguity in the routing rationale, make a best-effort decision, and note the uncertainty.

## Accuracy Over Completeness

If the provided inputs are insufficient to route confidently, say so rather than inferring. It is acceptable to flag uncertainty in routing rationale rather than invent confident-sounding justifications. If the Answer Specs contain questionable assumptions about source availability, flag them constructively.

## Output Protocol

Produce the full Execution Manifest in a single pass using the template in `references/manifest-template.md`. No refinement mode — the operator reviews the manifest and can override individual routing decisions before execution begins.

The manifest's session groupings are authoritative for downstream steps. When the operator passes this manifest to `research-prompt-creator`, that skill accepts the session groupings as given input and writes prompts accordingly.

**Operator overrides:** If the operator overrides a routing decision, update the manifest accordingly — adjust session groupings and the routing summary table to reflect the change, then re-run the self-check. Do not regenerate from scratch unless the override changes the majority of routing decisions.

Deliver as markdown.

## Self-Check

Before delivering, verify:

- Every research question is either routed to exactly one execution tool (Research GPT or CustomGPT) OR classified `not-worth-pursuing` and recorded out-of-scope with a one-line reason (§ Paywall Classification & Source-Plan Table)
- Research GPT sessions target 2 questions each (1 or 3 acceptable with justification)
- All dependencies between questions are reflected in session ordering — every inter-question relationship is classified as Hard, Soft, or None
- No session's dependency column shows "None" while its steering notes or downstream prompts would reference another session's findings
- Parallel execution opportunities are explicitly identified
- Routing rationale is specific to each question (not generic)
- The routing summary table matches the detailed session/queue sections
- CustomGPT batches are 2–3 questions each
- Every Research GPT session has a `Language passes` column populated (English + local languages as applicable per country-specific question routing per § Country-Specific Language-Block Routing); pan-Nordic aggregate sessions may list English only (S-04)
- Every research question carries a paywall-risk classification — one of `public-answerable` / `public-proxyable` / `public-gated` / `not-worth-pursuing` (§ Paywall Classification & Source-Plan Table)
- The #1-lite source-plan table is present with all five columns; every `public-gated` row's `stop condition` matches its risk tier per the #17 control matrix (Tier A → full deep session; Tier B/C → fast-lane; Tier D → not pursued). If the #24 register is absent, the loud degraded-mode note is present
