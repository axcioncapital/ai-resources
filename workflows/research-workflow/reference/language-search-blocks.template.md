# Language-Search Blocks — {{PROJECT_TITLE}}

> **Purpose.** Project-fillable per-language search-term blocks consumed by `research-prompt-creator` Step 2b § S-04 strategic-choice rule (Mandatory Local-Language Search Pass). The project copies this template to `reference/language-search-blocks.md` and fills one block per ISO 639-1 code declared in the Project Config `Languages:` field.
>
> **Consumed by:** `research-prompt-creator` skill. The skill reads this file at runtime when building country-specific directive blocks; absent-file behavior is codified below under **Absent-File Semantics** (3-case contract — do not collapse into a single fallback).
>
> **Canonical-ordering rule.** The S-04 framing — *local-language block runs in parallel with the English block, not as fallback* — lives in `ai-resources/skills/research-prompt-creator/SKILL.md § S-04` and is canonical. This file is the source of truth for the **per-language term sets** ONLY. Edits to the parallel-pass framing belong in the skill, not here.

---

## Project Config Dependency

This file is paired with the Project Config `Languages:` field (declared in the project's `CLAUDE.md § Project Config` block per `ai-resources/workflows/research-workflow/docs/project-config-schema.md` field 5). The contract:

- `Languages:` is the **single source of truth** for which languages apply to this project. The list of ISO 639-1 codes in `Languages:` determines which per-language blocks `research-prompt-creator` will iterate.
- This file holds the **term content** for each language declared in `Languages:`. Every code in `Languages:` must have a matching `## {{LANG_CODE}}` section below.
- Drift between the two surfaces is a configuration error and is detected at the consumer (see **Absent-File Semantics** case 3 below).

---

## Absent-File Semantics

`research-prompt-creator`'s S-04 loader applies the following 3-case contract when constructing country-specific directives. Do not collapse the cases into a single fallback — the cases reflect genuinely different operator intents.

1. **`Languages:` absent or `[]`** → emit English-only directives, no warning. Correct posture for monolingual projects (e.g., buy-side advisory work). The skill MUST NOT emit a local-language search block.

2. **`Languages:` populated AND this file absent** → **HALT with a clear error**: `language-search-blocks.md missing; project declared Languages: {{declared list}} but the per-language blocks file is absent. Either remove the Languages: field (monolingual posture) or author reference/language-search-blocks.md from the canonical template.` Do not fall back to English-only — silent fallback for a multi-language project degrades evidence integrity for evidence the operator explicitly asked for (AP-2 / OP-3 violation).

3. **`Languages:` populated AND this file present** → iterate over every code in `Languages:`. For each code:
   - If a `## {{LANG_CODE}}` section exists in this file, emit the per-language search block in the directive.
   - If the section is missing, HALT with: `Languages: declares {{code}} but reference/language-search-blocks.md has no matching block. Add the section or remove the language from the Project Config.`
   - If this file contains a `## {{LANG_CODE}}` section for a code NOT in `Languages:`, emit a one-line operator warning at prompt-build time (`Block for {{code}} in language-search-blocks.md but not declared in Languages:; ignoring.`) and skip it. Project Config wins.

---

## Per-Language Block Format

Project fills one section per language code declared in `Languages:`. Each section follows the same shape:

```markdown
## {{LANG_CODE}}

**Language:** {{LANGUAGE_NAME}}

**Search-term pairs (project-curated, operator-verbatim):**
- `{{SEARCH_TERM_PAIR_1}}`
- `{{SEARCH_TERM_PAIR_2}}`
- `{{SEARCH_TERM_PAIR_3}}`
- `{{SEARCH_TERM_PAIR_4}}`

**Native-language site searches:** {{SITE_SEARCH_LIST}}
```

**Authoring guidance.**

- **Search-term pairs.** 3–6 pairs per language. Each pair should combine an operating verb (acquire, sell, divest, add-on) with a domain noun (private equity, portfolio company, riskkapital, pääomasijoittaja). Aim for pairs that produce keyword-driven matches against native-language coverage of the domain. The pairs are project-curated — these are intentionally operator-verbatim values, NOT auto-generated translations of English equivalents.
- **Native-language site searches.** 2–6 site-restricted searches per language. Prefer trade-press domains, sector-association domains, and national business news domains that publish in the local language. Use `site:domain.tld` format (the consumer pastes this verbatim into the execution tool's search syntax).
- **Recency markers.** When the project's research period is a calendar year (e.g., "2025-2026"), include the relevant year as a literal token in 1–2 search-term pairs per language. This narrows recall to current coverage. Operator updates the year token at project boundary.

---

## Example Block (illustrative — replace with project-specific terms)

```markdown
## en

**Language:** English

**Search-term pairs (project-curated, operator-verbatim):**
- `"acquires" "private equity" "2025"`
- `"sells to" "portfolio company"`
- `"buyout" "growth equity"`
- `"add-on acquisition" "2025"`

**Native-language site searches:** `site:pehub.com`, `site:bloomberg.com`, `site:reuters.com`
```

(The example is illustrative only; English is the default in `research-prompt-creator` and does NOT require a per-language block here — English-language searches are part of the canonical S-04 framing in the skill. Project blocks below cover ADDITIONAL languages declared in `Languages:`.)

---

## How Consumers Read This File

1. **`research-prompt-creator`** reads the Project Config `Languages:` field (via the project's `CLAUDE.md § Project Config` block). For each ISO 639-1 code in `Languages:`, the skill reads the matching `## {{LANG_CODE}}` section from this file and emits a per-language search block in country-specific directives, alongside (not as fallback to) the English-language block.
2. **Absent-file behavior** follows the 3-case contract above. The skill MUST NOT silently degrade to English-only when this file is absent but `Languages:` is populated.
3. **The S-04 framing rule** — local-language block runs in parallel with English, never as fallback — is enforced by the skill, not by this file. This file holds term content only.

---

## Cross-References

- Project Config `Languages:` field: `ai-resources/workflows/research-workflow/docs/project-config-schema.md` field 5
- S-04 framing rule: `ai-resources/skills/research-prompt-creator/SKILL.md § S-04`
- Project's filled instance: `reference/language-search-blocks.md` (per-project copy of this template)
- Sibling templates: `claim-permission.template.md`, `jargon-gloss-config.template.md`, `source-class-hierarchy.template.md`, `known-limits.template.md`, `stage-5-paths.template.md`
