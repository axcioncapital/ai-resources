# Project Config Schema — Research Workflow Canonical

> **Status — forward contract (no live consumer as of 2026-05-27).** This schema declares 12 declarative project values that downstream skills, commands, and reference docs are *intended* to read at runtime. Today, zero of those consumers parse the block. The schema is being landed one work-unit ahead of FX-B1 (Stage 5 parameterization), which is the first confirmed consumer-builder. Until FX-B1 lands, this file describes a contract that will be honored, not a contract that is in force.
>
> **Rollback rule:** if FX-B1 does not land within the current fix-phase plan window (`plans/fix-phase-plan-v1.md` Work Unit 4), the schema either gets a live consumer or gets reverted — it does not sit idle indefinitely (`principles.md § DR-7` — no speculative generalization without a downstream consumer).
>
> **Where the block lives:** the schema block itself is in the project's `CLAUDE.md` under `## Project Config` (always-loaded). This doc is the load-on-demand reference — operators read it when authoring or modifying a project's config block; future consumer authors read it when implementing parsers.

---

## Single source of truth — `Country set`

`Country set` overlaps with `reference/source-class-hierarchy.md § Project Country Set` (the existing Bundle-2 block consumed by `country-parity-checker`). To prevent silent drift:

- **CLAUDE.md `## Project Config` `Country set:` is canonical.**
- `reference/source-class-hierarchy.md § Project Country Set` is the derived mirror — it must reflect the canonical value verbatim.
- When the canonical value changes, the mirror updates in the same commit. A divergence between the two is a defect, not a configuration choice.
- Any future consumer that needs the country set reads from the canonical CLAUDE.md block, never from the mirror.

This rule covers `Country set` only. If future fields develop overlap with other reference docs, declare canonical-vs-mirror direction here in the same shape before the overlap lands.

---

## Canonical parse format

All consumers MUST parse the schema using ONE pattern so the contract surface is single-documented, not 6-implicit.

**Pattern:** for each field, match the line `^\*\*<field-label>:\*\* <value>` after the `## Project Config` heading, then split off any trailing `# comment` (the part after the first `  # ` token pair). `<value>` is captured raw; type coercion happens per-consumer per the "Type" column below.

**Reference regex** (Python-style; adapt syntax per consumer language):
```
^\*\*(?P<label>[A-Z][A-Za-z- ]+):\*\*\s+(?P<value>.+?)(?:\s+#\s+(?P<comment>.+))?$
```

**Single-section assumption:** consumers locate the section header `## Project Config` first, then read forward until the next `## ` heading. Multi-section schemas are not supported in v1.

**Why one format:** see `principles.md § OP-6` (the operator's mental model, not just instructions). Six future consumer parsers each inventing their own read pattern is a textbook hidden-coupling site; one documented pattern reduces 6 implicit dependencies to 1 explicit one. Consumer authors who diverge from this pattern create silent contract drift.

---

## The 12 fields

| # | Field | Type | Example | Description | Reads (future consumers) |
|---|---|---|---|---|---|
| 1 | `Report set` | list of strings | `[r1, r2, r3]` | Identifiers of the reports the project produces. Stage 5 commands derive `report-count` from `len(Report set)` and iterate per-report. | `produce-prose-draft` (per-report); `produce-formatting` (per-report); `produce-jargon-gloss` (per-report) |
| 2 | `Section IDs` | list of strings | `[1.1, 1.2]` | Identifiers of the active sections within the project. Parameterizes per-section path conventions (`preparation/task-plans/X.X-…`). | `produce-prose-draft` (per-section iteration); `execution-manifest-creator` (manifest filename slugs); `transaction-table-builder` (per-section transaction tables) |
| 3 | `Country set` | list of country codes | `[SE, NO, FI]` | Primary geographic scope. **Canonical** — `reference/source-class-hierarchy.md § Project Country Set` is the derived mirror. | `country-parity-checker` (parity test set); `source-class-hierarchy.md` (mirror, updated same-commit); `research-prompt-creator` (regional-source preamble) |
| 4 | `Country superset` | list of country codes | `[SE, NO, FI, DK]` | Wider geographic scope used for "pan-region leakage" detection. Always a superset of `Country set`. | `country-parity-checker` (leakage allowlist); `research-prompt-creator` (boundary disambiguation) |
| 5 | `Languages` | list of ISO 639-1 codes | `[sv, fi, no]` | Project's research-source languages. Parameterizes the language-search blocks in research prompts. Omit or empty list = English-only single-language project. | `research-prompt-creator` (language-search block iteration); `reference/language-search-blocks.md` (block-template instantiation) |
| 6 | `Deal-size lens` | string | `"€2-25M EV"` | Operator-facing label for the project's deal-size focus. Cited verbatim in size-class tags throughout outputs; not parsed as a numeric range. | (operator-facing only — no consumer parser; cited in prose/tags) |
| 7 | `Domain` | string | `"private equity"` | Project's analytical domain. Parameterizes which jargon-gloss whitelist activates (PE-style, M&A-style, macro-style, industry-style). | `produce-jargon-gloss` (whitelist activation); `jargon-gloss-config.md` (config row matching) |
| 8 | `Verification posture` | enum | `"lighter-than-formal"` | One of: `per-claim-cited` / `lighter-than-formal` / `interpretive-only`. Sets the verification-rigor floor for `verify-chapter` and the source-attribution norm for synthesis. | `verify-chapter` (rigor floor); `evidence-to-report-writer` (citation norm); `reference/quality-standards.md` (Evidence-First calibration row) |
| 9 | `Source-availability` | enum | `"public-only"` | One of: `public-only` / `mixed` / `paid-databases-allowed`. Defines which source classes the research-prompt-creator may reference. | `research-prompt-creator` (allowed source-class list); `reference/source-class-hierarchy.md` (claim-permission gates) |
| 10 | `Research-area-phrase` | string | `"Nordic mid-market private equity"` | Plain-English research-domain label. Parameterizes the Perplexity-prefix in run-execution.md (forms the leading clause of every Perplexity query) and the framing line in stage-instructions.md. | `run-execution.md` (Perplexity-prefix); `reference/stage-instructions.md` (intro framing) |
| 11 | `Current period` | string | `"2025-2026"` | Project's "current" time band. Parameterizes the freshness classes (CURRENT / RECENT / BASELINE) used by source-class-hierarchy.md and verify-chapter. | `reference/source-class-hierarchy.md` (freshness-class formula); `verify-chapter` (date-range gates); `reference/known-limits.md` (freshness-date calibration) |
| 12 | `Delivery vault` | string (optional) | `"pe-kb"` | Optional. Name of the Obsidian knowledge-base vault the project's chapter outputs should be deployed into. Default: no-op (skip vault deploy step). | `produce-knowledge-file` (vault target); `/deploy-kb` (target vault resolution) |

---

## Consumer fan-out summary

| Consumer | Reads field(s) |
|---|---|
| `produce-prose-draft` | `Report set`, `Section IDs` |
| `produce-formatting` | `Report set` |
| `produce-jargon-gloss` | `Report set`, `Domain` |
| `research-prompt-creator` skill | `Country set`, `Country superset`, `Languages`, `Source-availability` |
| `execution-manifest-creator` skill | `Section IDs` |
| `transaction-table-builder` skill | `Section IDs` |
| `country-parity-checker` skill | `Country set`, `Country superset` |
| `verify-chapter` | `Verification posture`, `Current period` |
| `evidence-to-report-writer` (via Stage 3/4) | `Verification posture` |
| `run-execution.md` | `Research-area-phrase` |
| `reference/stage-instructions.md` | `Research-area-phrase` |
| `reference/source-class-hierarchy.md` | `Country set` (mirror); `Source-availability`; `Current period` |
| `reference/known-limits.md` | `Current period` |
| `reference/quality-standards.md` | `Verification posture` |
| `jargon-gloss-config.md` | `Domain` |
| `produce-knowledge-file` / `/deploy-kb` | `Delivery vault` (optional) |

This table is the per-field-fan-out view; the "Reads" column in the field table above is the per-consumer-by-field view. Both are kept consistent; if you edit one, edit the other.

---

## Field naming + value convention

- Field labels use **Title-Case-Hyphen-or-Space** (e.g., `Report set`, `Country superset`, `Verification posture`). Existing 12 labels are normative; do not change capitalization or punctuation without updating every consumer.
- List values are bracket-delimited, comma-separated, with one space after each comma: `[r1, r2, r3]`. No quoting for short identifiers.
- String values are double-quoted: `"private equity"`. Always quote strings even when they don't contain spaces, so consumers can use the same parse path for all string fields.
- Enum values are double-quoted strings matching one of the documented enumeration members exactly. Case-sensitive.
- The trailing `  # ` comment is operator-facing only — consumers must strip and discard.
- Omitting an optional field (e.g., `Delivery vault`) is allowed; consumers default to no-op behavior.

---

## When to migrate this schema to a separate file (GR-2 triggers)

The `## Project Config` block lives in canonical CLAUDE.md per Pass 5 §3.3 reasoning (always-loaded, operator-readable, mirror-compatible with existing `reference/source-class-hierarchy.md § Project Country Set`). Migrate the schema to a separate `.project-config.yml` (or similar) when ANY of the following triggers fires:

1. **Field count exceeds ~20.** A 12-field block in CLAUDE.md is operator-scannable; 25 fields is not. Cost is operator cognitive load on every session start.
2. **Machine-parsed consumers extend beyond Claude.** If non-Claude tooling (CI scripts, external orchestration) needs to read the schema, YAML or JSON beats markdown for those readers.
3. **Non-Axcíon operators fork the workflow.** If a non-Axcíon project deploys this template and needs to maintain a config layer independently, a separate file is easier to merge / diff than CLAUDE.md edits.

Until one of those triggers fires, CLAUDE.md is the right home — keep it.

---

## Related references

- `audits/workflow-audit/05-template-fitness.md` §3.3 — original schema source-of-truth (12-field block + consumer enumeration)
- `audits/workflow-audit/05-template-fitness.md` §3.4 — worked example showing schema instantiation for a hypothetical "European industrial M&A H2 2026" project
- `ai-resources/docs/audit-discipline.md` — `/risk-check` change classes (CLAUDE.md edit + new doc creation both apply)
- `plans/fix-phase-plan-v1.md` Work Unit 3 (FX-B7) — fix-phase landing scope; Work Unit 4 (FX-B1) — first consumer-builder
