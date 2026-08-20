---
name: execution-manifest-creator
description: >
  Turn a section's approved Answer Specs and Research Plan into an operator-
  approved Execution Manifest. Classifies each question by execution role and
  search mode, checks the project-configured evidence executor against required
  capabilities, keeps supplementary leads separate from evidence of record,
  and groups eligible questions into sessions. Trigger on "create execution
  manifest," "route these questions," or "plan the execution." This is Step
  2.0 of the Axcion Research Workflow. Do NOT execute research, call external
  tools, create prompts, or silently choose an undeclared executor.
model: sonnet
effort: medium
---

# Execution Manifest Creator

## Purpose

Create one explicit, operator-reviewable plan for Stage 2. The skill routes by
required role and capability, then binds the project-approved product name. It
does not dispatch prompts and it does not maintain its own tool defaults.

## Input Requirements

**Required:**

1. **Answer Specs** — all approved per-question specifications for the section.
2. **Research Plan** — scope, source landscape, dependencies, risk tiers, and key terms.
3. **Project Config executor-routing fields** — read from the project's `CLAUDE.md` `## Project Config` block:
   - `Evidence executor` — the product/tool approved to produce evidence of record.
   - `Evidence executor capabilities` — verified capability tokens for that executor.
   - `Supplementary lead provider` — an approved lead provider or `none`.

Do not infer any field from product reputation, a previous project, or a worked
example. If the executor or capabilities field is missing, blank, malformed, or
still contains a placeholder, halt and name the field. If the supplementary
field is missing, halt and ask the operator to resolve it to a product name or
`none`.

## Routing Contract

### 1. Classify the execution role

Assign every question exactly one role before considering a product:

- **Evidence gathering** — new external evidence must be found, opened, and recorded.
- **Mechanical / no research** — deterministic consolidation, intake validation, register freezing,
  or gate recomputation over already-provided artifacts. Record it in Operator Notes;
  name the current workflow actor, and do not create a research session or bind a research product.
- **Not worth pursuing** — every evidence need falls below the worth-doing floor.
  Record it out of scope with a one-line reason; do not create a research session.

Do not route a question to a product merely because it is definitional, well
sourced, broad, or difficult. Those properties change search mode and prompt
depth, not the project-approved evidence executor.

Independent verification is a separate downstream role governed by the Stage 4
cross-model contract. Do not bind or redesign it in a Stage 2 manifest.

### 2. Diagnose search mode

For each evidence-gathering question, record one mode:

- **Search-led** — useful sources must be discovered through varied search routes.
- **URL-led** — the relevant sources or domains are already named or trivially derivable;
  opening and checking them is the dominant job.

This diagnosis controls search budget, source-opening emphasis, and whether a
supplementary lead pass is useful. It never changes the approved executor by itself.

### 3. Derive required capabilities

Every evidence-gathering session requires all four baseline capabilities:

- `full-source-access` — open the full page or PDF; snippets are not evidence.
- `lossless-artifact-handoff` — write to disk or deliver the required artifact without lossy transformation.
- `audit-log` — record queries and direct source opens in the project's required audit form.
- `required-output-schema` — produce the governed session/report schema without dropping required fields.

Add `native-language-search` whenever a local-language pass is load-bearing. This
token means the executor is verified for every language declared in Project Config
`Languages`; partial language support does not satisfy it.
Compare the resulting set with `Evidence executor capabilities`. Product names
do not imply capabilities; only the project declaration counts.

If any required capability is absent, halt with:

> No qualifying evidence executor: `[configured executor]` lacks `[capability list]`
> for `[question/session]`. Update the verified Project Config declaration or
> obtain an operator decision; no fallback executor is authorized.

Do not silently substitute the supplementary provider or any familiar product.
When even one research session is ineligible, emit only a concise stop report;
do not produce an executable manifest for the remaining sessions.

### 4. Decide whether supplementary leads help

Supplementary leads are eligible only when a provider is configured and both
conditions hold:

1. the question is search-led; and
2. a thin search result could be misread downstream as a substantive negative
   (for example, an open-ended census or holdings sweep).

Otherwise record `No` with a short reason. Supplementary leads are not evidence of record.
They surface candidate URLs only; the evidence executor must perform
and log its own search, open each underlying source, and tag lead origin before use.
Two tools finding the same originating source still count as one source.
The manifest records the pass for operator execution; this skill never calls the provider.

## Session Grouping

After eligibility passes, group evidence-gathering questions into sessions:

1. Respect hard dependencies before clustering.
2. Target two questions per session; one or three is acceptable with a reason.
3. Optimize by source overlap, then conceptual chain, then analytical lens.
4. Keep search-led and URL-led questions separate unless combining them clearly
   reduces source work without obscuring capability or dependency requirements.

Classify every relationship as:

- **Hard** — downstream work requires upstream output; use sequential sessions.
- **Soft** — shared assumptions or source surfaces matter, but neither requires the other's output.
- **None** — no analytical or source relationship.

Never label a dependency `None` if steering notes refer to another session.

## Country and Language Routing

Use the project's `Country set` and `Languages` fields plus the Research Plan to
identify required local-language passes. Do not hard-code a country set or infer
that a named product can perform native-language work. A country-specific question
gets each load-bearing local-language pass named explicitly. Pan-region aggregate
questions may remain English-only when the Answer Spec does not require a country breakdown.

If a local-language pass is required and `native-language-search` is absent from
the configured executor's capabilities, apply the fail-visible rule above.

## Paywall Classification and Source Plan

Classify each evidence need before session routing:

| Class | Meaning | Route |
|---|---|---|
| `public-answerable` | A direct public source plausibly exists | Normal sourcing |
| `public-proxyable` | Only a public proxy is plausible | Normal sourcing; permission ceiling = PROXY-SUPPORTED |
| `public-gated` | The real answer is paywalled; public proxies are weak or absent | Route by risk tier below |
| `not-worth-pursuing` | Immaterial or answerable only at disproportionate cost | Skip and record the reason |

For a multi-need question, skip it only if every need is `not-worth-pursuing`.
Otherwise label the row with the most restrictive routable class:
`public-gated` > `public-proxyable` > `public-answerable`.

For `public-gated` needs, follow `reference/quality-standards.md § Risk-Tier Model`:

| Risk tier | Route |
|---|---|
| Tier A | Full deep session |
| Tier B / Tier C | Fast-lane scarcity audit: 5–8 proxy searches plus the known-limits register check, then stop unless the operator overrides |
| Tier D | Not pursued |

The manifest records the route label only. `research-prompt-creator` authors the
actual search instructions. If `reference/known-limits.md` or its register is
absent, continue but add a loud degraded-mode note that paywall calls are based
on search results only.

Embed one source-plan table in the manifest with:

| Column | Source |
|---|---|
| `research question` | manifest question |
| `required source classes` | `reference/source-class-hierarchy.md` |
| `native-language requirement` | Country and Language Routing above |
| `paywall risk` | classification and tier route |
| `stop condition` | risk-tier and paywall route |

## Failure Behavior

- **Missing Answer Specs or scope parameters** — halt and name the missing input.
- **Ambiguous non-critical source preference** — proceed, label the assumption, and flag it for operator review.
- **No qualifying evidence executor** — halt; do not produce an executable manifest.
- **Supplementary provider is `none`** — proceed without a lead pass; never invent one.
- **All questions are mechanical/no-research or not worth pursuing** — produce Operator Notes only and state that Stage 2 has no research sessions.
- **Routing rationale unclear** — describe the uncertainty; do not change product assignment.

## Known Pitfalls

- Treating a familiar product name as proof of a capability. Project Config is the authority.
- Letting a supplementary citation become evidence without reopening the underlying source.
- Adding every project language to every session. Add only the language passes the question requires.
- Producing a partial executable manifest after one session fails eligibility. A partial plan hides the stop.
- Sending deterministic consolidation through research because it appears in a Research Plan. Classify the work itself as mechanical/no-research.

## Bias Countering

Do not optimize for using every configured product or for keeping every question
in scope. Prefer an explicit gap, no-research classification, or eligibility stop
over a plausible but unauthorized route. If the inputs do not establish a
capability or lead-pass need, say so rather than inferring it.

## Validation Loop

Before delivery, walk these representative cases through the actual manifest:

| Case | Expected result |
|---|---|
| Open-ended census; qualified executor; lead provider configured | Configured executor remains evidence executor; lead pass is separate |
| Frozen entity list with known URLs | URL-led; configured executor; no lead pass by default |
| Load-bearing local-language pass but capability absent | Stop with `native-language-search` named |
| Deterministic consolidation over supplied artifacts | Mechanical/no-research role; no research session |
| No qualifying executor | Stop; no fallback and no executable partial manifest |

Then run the Self-Check and present the result at the existing operator approval gate.

## Example

Given `Evidence executor: "[configured executor]"`, all four baseline capability
tokens, and `Supplementary lead provider: "[configured provider]"`, a search-led
census may receive a lead pass while a URL-led verification session does not.
Both still name the same configured evidence executor. If the census also needs
a local-language pass and `native-language-search` is absent, neither session is
released: the output is the fail-visible stop block.

## Output Protocol

Use `references/manifest-template.md`. Produce the complete manifest in one pass.
The operator may override classifications or lead-pass decisions at the mandatory
approval gate, but changing the executor binding or declared capabilities requires
an explicit operator decision applied to Project Config before the manifest is regenerated.

The approved manifest is authoritative for `research-prompt-creator`. Deliver as Markdown.

## Self-Check

Before delivery, verify:

- Every question is exactly one of evidence gathering, mechanical/no-research, or not worth pursuing.
- Every evidence session names the configured evidence executor verbatim.
- Every session records search mode, required capabilities, and `ELIGIBLE`.
- No required capability is inferred from a product name.
- No ineligible session or silent fallback appears in the manifest.
- Supplementary leads are a separate field and never the evidence executor.
- Every lead-enabled session states that underlying sources must be reopened and logged by the evidence executor.
- Session sizes and dependencies follow the grouping rules.
- Every evidence session lists its language passes.
- Every routed question has one paywall-risk class and a complete five-column source-plan row.
- The routing summary, session table, and distribution counts agree.
- The operator approval gate is stated.

## Runtime Recommendations

- Routing is declarative planning only: no shell, network, API dispatch, queue, or autonomous router.
- Read the inputs and write one manifest. Do not create a second planning artifact.
- `model: sonnet`, `effort: medium` are sufficient for rule application and grouping.
