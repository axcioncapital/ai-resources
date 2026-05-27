# Jargon-Gloss Configuration — {{PROJECT_TITLE}}

> **Purpose.** Project-fillable two-section configuration consumed by the `jargon-gloss` skill at Stage 5. The project copies this template to `reference/jargon-gloss-config.md` and fills the two sections with its own domain-specific terms.
>
> **Consumed by:** `jargon-gloss` skill (Stage 5.4 polish step, invoked via `/produce-jargon-gloss`). The skill reads this file at runtime; if absent, the skill falls back to its built-in default categories and whitelist.
>
> **Canonical-ordering rule.** The gloss-format conventions (`Term (5–15 word definition)`, acronym-treatment rules, edge-case handling for footnotes / quoted material / self-glossed terms, the additive-pass rule) live in `ai-resources/skills/jargon-gloss/SKILL.md` and are canonical. This file is the source of truth for **which terms to gloss** (Section 1) and **which terms to whitelist as standard vocabulary** (Section 2) for this project. Edits to format conventions belong in the skill, not here.

---

## Section 1 — Gloss-Required Term Categories

Project fills 4–8 categories. Each category names a class of terms whose first mention in any report should be glossed inline. Categories typically combine named entities (named directives, regulators, institutional vehicles) with niche-vocabulary buckets (sector-specific operating concepts that a fluent reader without sector-domain expertise would not know).

### {{CATEGORY_1}}

{{CATEGORY_1_DESCRIPTION}}

**Example named entries in this category:** {{CATEGORY_1_EXAMPLES}}

### {{CATEGORY_2}}

{{CATEGORY_2_DESCRIPTION}}

**Example named entries in this category:** {{CATEGORY_2_EXAMPLES}}

### {{CATEGORY_N}}

(Project fills additional categories.)

---

**Authoring guidance.** Categories should be both observable to the gloss-pass (so the skill can detect first-mention occurrences automatically) and meaningful to the reader (so glossing actually aids comprehension). Common category shapes:

- **Named regulatory frameworks** (directives, acts, screening regimes — both supranational and project-relevant national instruments).
- **Named regulatory authorities** (agencies, inspectorates, supervisory bodies, named regulators).
- **Named institutional vehicles or programs** (development banks, sovereign-wealth vehicles, pension funds, named programs on first mention).
- **Sector-specific compliance frameworks** (ESG-reporting acronyms, taxonomy frameworks, sector-specific named tools).
- **Niche acronyms** outside the project's standard whitelist (Section 2 below). If an acronym appears bare on first mention and is not on the whitelist, gloss it.
- **Sector-specific operating concepts** that the document treats as if the reader knows them but a fluent reader without sector-domain expertise would not.

---

## Section 2 — Glossary Whitelist (Do-Not-Gloss List)

Project fills 6–12 buckets. Each bucket lists terms the project considers standard vocabulary for its target reader; these terms are NEVER glossed even on first mention.

### {{WHITELIST_BUCKET_1}}

{{WHITELIST_BUCKET_1_TERMS}}

### {{WHITELIST_BUCKET_2}}

{{WHITELIST_BUCKET_2_TERMS}}

### {{WHITELIST_BUCKET_N}}

(Project fills additional buckets.)

---

**Authoring guidance.** Whitelist buckets should reflect the **assumed reader's vocabulary**, not the writer's. A PE-fluent reader knows fund-structure jargon; a macro-research reader knows central-bank jargon; an M&A-fluent reader knows deal-structure jargon. Whitelist what the target reader already knows; gloss everything else.

Common whitelist-bucket shapes (project includes the ones that match its target reader; project may add buckets not listed here):

- **Domain core vocabulary** (the project's central professional vocabulary — fund-structure terms, deal-structure terms, performance metrics, process terms).
- **Market-segment vocabulary** (size-class labels, sponsor-type labels, deal-type labels relevant to the project's scope).
- **Standard supranational institutions** (assumed reader knowledge — major intergovernmental bodies relevant to the project's coverage area).
- **Standard country names and adjectives** (the countries in scope, plus near neighbors that recur in pan-region framing — should match the country set in `reference/source-class-hierarchy.md § Project Country Set`).
- **Standard currency and unit terms** (currencies in scope for the project, plus standard quantity abbreviations).
- **Domain methodology acronyms** that are universal within the target reader's profession.

---

## How the Skill Reads This File

1. **`jargon-gloss`** reads Section 1 categories to identify candidate first-mention occurrences in the report prose. The skill applies its canonical format conventions (per `ai-resources/skills/jargon-gloss/SKILL.md`) to produce the inline gloss.
2. **`jargon-gloss`** reads Section 2 whitelist buckets to filter out terms the project has marked as do-not-gloss — these are never glossed regardless of first-mention status.
3. **Conflict resolution.** If a term appears in both a Section 1 category and a Section 2 whitelist bucket, the whitelist wins (the term is not glossed). Project authors should avoid this overlap; if intentional, document the rationale inline next to the whitelist entry.
