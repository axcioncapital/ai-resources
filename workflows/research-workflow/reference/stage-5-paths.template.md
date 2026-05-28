# Stage 5 Path Config — Project Template

> **Workflow-instantiated reference doc.** Each project that uses Stage 5 commands instantiates this template at `reference/stage-5-paths.md` in its project root. Canonical Stage 5 commands (`produce-prose-draft`, `produce-formatting`, `produce-jargon-gloss`) read this file at Phase 0 to resolve project-specific paths. **No fallback** — Phase 0 halts loudly when this file is missing or its `Mode:` value mismatches the `Document model:` declared in the project's `## Project Config`.
>
> **How to instantiate:** copy this file to `<project>/reference/stage-5-paths.md`, pick the schema block matching the project's `Document model:` (`report` or `section`), fill in the project-specific values, and delete the other schema block + the operator notes. The result is a small file (~10–15 lines of values) the canonical commands parse mechanically.
>
> **Placeholder set (v1):** `{section}` (from `## Project Config` `Section IDs:`); `{report}` (from `Report set:`; report-mode only); `{N}` (numeric index derived from arg, e.g., `R1` → `N=1`); `{part}` (section-mode only — first numeric component of arg, e.g., `2.4` → `part=2`). Adding placeholders requires a Path A v4-style design + `/risk-check`.

---

## How Phase 0 reads this doc

1. Locate the `## Stage 5 Path Roots` heading.
2. Read forward until the next `## ` heading. Within that block, parse each `^\*\*<label>:\*\* <value>` line.
3. Verify the `Mode:` value matches the project's `Document model:` (from `## Project Config` in CLAUDE.md). Mismatch halts.
4. Interpolate placeholders against arg + schema-derived values.

---

## Stage 5 Path Roots — report-mode schema

Choose this block if the project's `Document model:` is `"report"`. Arg pattern: `r[NN]` (e.g., `r1`, `r2`, `r3`). The arg parses to `R{N}` (uppercase) for path interpolation.

```markdown
## Stage 5 Path Roots

**Mode:** report
**Compiled-source root:** "{{COMPILED_SOURCE_ROOT}}"          # e.g., "report/compiled/{section}"
**Compiled-source filename:** "{{COMPILED_SOURCE_FILENAME}}"  # e.g., "{section}-R{N}-compiled-v2.md"
**Prose-output root:** "{{PROSE_OUTPUT_ROOT}}"                # e.g., "report/produced/{section}/R{N}"
**Prose-output filename:** "{{PROSE_OUTPUT_FILENAME}}"        # e.g., "R{N}-prosed.md"
**Formatted-output filename:** "{{FORMATTED_OUTPUT_FILENAME}}"  # e.g., "R{N}-formatted.md"
**Style-reference path:** "{{STYLE_REFERENCE_PATH}}"          # e.g., "report/style-reference/{section}/{section}-style-reference.md"
**Decontamination-log filename:** "{{DECON_LOG_FILENAME}}"    # e.g., "decontamination-log.md" (relative to prose-output root)
**Gloss-log filename:** "{{GLOSS_LOG_FILENAME}}"              # e.g., "gloss-additions-log.md" (relative to prose-output root)
**Working-dir name:** "{{WORKING_DIR_NAME}}"                  # e.g., "working" (relative to prose-output root; subagent-findings files)
```

**Per-placeholder rules (report-mode):**

| Placeholder | Source | Notes |
|---|---|---|
| `{section}` | `## Project Config` `Section IDs:` (must be exactly one active section per invocation — multi-section projects pass the section explicitly or invoke once per section) | Used in path patterns where the section identifier appears. |
| `{report}` | Parsed from arg (`r1` → `report=r1`) | Operator-facing form. |
| `{N}` | Parsed from arg (`r1` → `N=1`) | Used in `R{N}` patterns. |

---

## Stage 5 Path Roots — section-mode schema

Choose this block if the project's `Document model:` is `"section"`. Arg pattern: `<part>.<sub>` (e.g., `2.4`, `3.1`). The arg's first numeric component is the `{part}` placeholder; the full arg is `{section}`.

Section-mode commonly uses multi-part documents (Part 2, Part 3, etc.). The `Section sets` table enumerates the per-part path mappings — projects MAY collapse to a single set if only one part exists.

```markdown
## Stage 5 Path Roots

**Mode:** section
**Section sets:**
  - **Part {{PART_NUMBER_1}}** ({{PART_NAME_1}}) → arg matches `{{PART_REGEX_1}}`; source draft root `{{SOURCE_DRAFT_ROOT_1}}`; source approved root `{{SOURCE_APPROVED_ROOT_1}}`; prose-output root `{{PROSE_OUTPUT_ROOT_1}}`
  - **Part {{PART_NUMBER_2}}** ({{PART_NAME_2}}) → arg matches `{{PART_REGEX_2}}`; source draft root `{{SOURCE_DRAFT_ROOT_2}}`; source approved root `{{SOURCE_APPROVED_ROOT_2}}`; prose-output root `{{PROSE_OUTPUT_ROOT_2}}`
  # Add additional parts as needed; remove unused slots.
**Source filename glob:** "{{SOURCE_FILENAME_GLOB}}"            # e.g., "{section}-*.md" (relative to source draft/approved root)
**Source filename multi-match selector:** "{{MULTI_MATCH_RULE}}"  # e.g., "highest-numeric-suffix" or "most-recent-mtime"
**Prose-output filename glob:** "{{PROSE_OUTPUT_FILENAME_GLOB}}"  # e.g., "{section}-{slug}.md" (relative to prose-output root)
**Style-reference filename:** "{{STYLE_REFERENCE_FILENAME}}"      # e.g., "style-reference.md" (relative to prose-output root)
**Architecture filename:** "{{ARCHITECTURE_FILENAME}}"            # e.g., "architecture.md" (relative to prose-output root; section-mode only)
**Decontamination-log filename:** "{{DECON_LOG_FILENAME}}"        # e.g., "decontamination-log.md" (relative to prose-output root)
**Gloss-log filename:** "{{GLOSS_LOG_FILENAME}}"                  # e.g., "gloss-additions-log.md" (relative to prose-output root)
**Working-dir name:** "{{WORKING_DIR_NAME}}"                      # e.g., "working" (relative to prose-output root; subagent-findings files)
```

**Per-placeholder rules (section-mode):**

| Placeholder | Source | Notes |
|---|---|---|
| `{section}` | Parsed from arg verbatim (e.g., `2.4` → `section=2.4`) | Used in source filename glob and prose-output filename glob. |
| `{part}` | First numeric component of arg (e.g., `2.4` → `part=2`) | Used to select the matching `Section sets` row at Phase 0. |
| `{slug}` | Derived from source document title at write time (kebab-case) | Used in prose-output filename pattern. |

---

## Mode-mismatch halting

Phase 0 in each Stage 5 command runs this check verbatim. Mismatch fires `principles.md § OP-3` (loud failure):

| Project Config `Document model:` | This file's `Mode:` | Behavior |
|---|---|---|
| `"report"` | `report` | Proceed. |
| `"section"` | `section` | Proceed. |
| `"report"` | `section` | Halt: `Mode mismatch: Project Config declares 'report', reference/stage-5-paths.md declares 'section'. Resolve before invoking.` |
| `"section"` | `report` | Halt: same shape with values swapped. |
| Any value | `Mode:` line missing | Halt: `reference/stage-5-paths.md is missing the Mode: line. See ai-resources/workflows/research-workflow/reference/stage-5-paths.template.md.` |
| Any value | `Mode:` value other than `report` or `section` | Halt: `Mode must be 'report' or 'section'. See template.` |

---

## Operator notes (delete before saving as project instance)

- **Delete this entire "Operator notes" section** after instantiation. It exists only in the canonical template, never in a project instance.
- **Delete the schema block you did NOT pick.** A project instance carries exactly one `## Stage 5 Path Roots` block — either report-mode or section-mode.
- **Delete unused `Section sets` rows** (section-mode only). Each row maps an arg-pattern to a path set; unused rows are dead weight.
- **Comments after `#` are operator-facing only.** The canonical parse format (`docs/project-config-schema.md § Canonical parse format`) discards trailing `# comment` content — strip if you prefer cleaner instance files.
- **Existing-project migration:** to instantiate this template for a project that already has hard-coded Stage 5 path patterns in its forked command files, capture the existing patterns verbatim into the appropriate block, then proceed with FX-D1 (canonical Stage 5 command reconciliation to symlinks).
