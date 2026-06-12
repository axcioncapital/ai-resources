---
friction-log: true
model: opus
---
Produce prose draft for: $ARGUMENTS

> **Path A parameterized — supports both document models.** This canonical command reads project paths from `reference/stage-5-paths.md` and dispatches on `Document model:` declared in the project's `## Project Config`. Two pipeline shapes coexist: section-mode (Part 2 / Part 3 / etc. — 7 phases) and report-mode (R1/R2/R3 — 5 phases). Phases 3 and 4 are section-mode-only and explicitly skipped in report-mode. See `plans/fx-b1-path-a-design-v3.md` and `docs/project-config-schema.md § Default-value semantics for Document model`.

Convert one source document into reviewed, decontaminated, jargon-glossed prose. Chains skills across phases that vary by mode. Output is prose ready for `/produce-formatting`.

> **Scope: light polish only.** This command does NOT re-architect, re-prose, or revise substantive content. Structural changes belong upstream (e.g., a Stage 5.2 bright-line fix application for report-mode projects, or `/produce-architecture` for section-mode projects); `document-integration-qc` validates narrative structure separately. If the source document needs structural rework, do it upstream before invoking this command.

**Mode-specific overview:**
- **section-mode:** 7 phases. Chains decision-to-prose-writing (`decision-to-prose-writer`), merged review + fix (`chapter-prose-reviewer` + `prose-compliance-qc`), cross-section integration check (conditional), AI prose decontamination (`ai-prose-decontamination`), and jargon-gloss (`jargon-gloss`). Requires architecture to exist (`/produce-architecture` runs first). Per-section run: 4–5 subagent launches, target ~12–16 min wall time.
- **report-mode:** 5 phases. Chains prose-refinement (`prose-refinement-writer`), AI prose decontamination, jargon-gloss. No architecture requirement (the post-bright-line-fix source carries its own structure). Per-report run: 3 subagent launches, target ~14–18 min wall time.

Uses `context/prose-quality-standards.md` (section-mode; project-specific) and the document's `style-reference.md` where available. The command passes both files to the relevant subagents.

---

## Phase 0 — Mode detection + arg validation + path-config load (main session)

**Required precondition gate. No fallback. Halt loudly on any missing/mismatched input** (per `principles.md § OP-3` and `docs/project-config-schema.md § Default-value semantics for Document model`).

1. **Read project `## Project Config`.** Locate `Document model:` line in the project's `CLAUDE.md`.
   - If line absent: halt — `Project Config missing required field 'Document model'. Add the field per ai-resources/workflows/research-workflow/docs/project-config-schema.md row 13.`
   - If value not `"report"` or `"section"`: halt — `Document model must be 'report' or 'section'. See ai-resources/workflows/research-workflow/docs/project-config-schema.md row 13.`
   - If line malformed: halt — `Document model field is malformed; see project-config-schema.md § Field naming + value convention.`

2. **Validate `$ARGUMENTS` against declared mode.**
   - `Document model: "report"` → arg must match `^[rR][0-9]+$`. Mismatch: halt — `Arg "<X>" does not match the project's declared mode 'report' (expected pattern: rN).` Parse: arg `r1` → `report=r1`, `N=1`, `RN=R1`.
   - `Document model: "section"` → arg must match `^[0-9]+\.[0-9]+$`. Mismatch: halt — `Arg "<X>" does not match the project's declared mode 'section' (expected pattern: N.M).` Parse: arg `2.4` → `section=2.4`, `part=2`.

3. **Read project `reference/stage-5-paths.md` (present-AND-filled, hard blocker).** Per the Stage-Entry Reference-File Completeness Gate (`reference/stage-instructions.md`), this is a hard blocker: it must exist AND be filled.
   - If missing: halt — `reference/stage-5-paths.md is missing. Stage 5 commands require explicit path-config; create from canonical template at ai-resources/workflows/research-workflow/reference/stage-5-paths.template.md.`
   - If present but unfilled (the `## Stage 5 Path Roots` block is empty or still carries `<placeholder>`-style template tokens): halt — `reference/stage-5-paths.md is present but unfilled (path-roots block is placeholder/empty). Fill it from the template before running Stage 5 — a placeholder path would mis-route every output.` Do not fall back to a default path.

4. **Verify mode match.** Locate the `Mode:` line. If absent or mismatched: halt per `stage-5-paths.template.md § Mode-mismatch halting`.

5. **Parse path-config.** Read the `## Stage 5 Path Roots` block. Cache resolved values for Phases 1–7.

---

## Phase 1 — Plan (main session)

Keep this phase lightweight. Do NOT read source files yet.

**Common steps (both modes):**

1. **Determine source-document path.**
   - **report-mode:** `<compiled-source-root>/<compiled-source-filename>` (e.g., `report/compiled/{section}/{section}-R{N}-compiled-v2.md`). If missing: PAUSE — `No post-fix file found for R{N} at <path>. Run Stage 5.2 (apply bright-line fixes from document-integration-qc) first.`
   - **section-mode:** glob `<source-draft-root>/<source-filename-glob>` (e.g., `parts/part-{part}-{partname}/drafts/{section}-*.md`). Multi-match resolution per the path-config's `Source filename multi-match selector`. Fall back to `<source-approved-root>/<source-filename-glob>` if no draft found. If neither resolves: PAUSE — no source document available.

2. **`prose_output_dir`** — `<prose_output_root>` interpolated with parsed arg.

3. **Check existing prose versions** at the resolved `prose_file_path` to understand iteration state. If present, note it.

**Mode-specific steps:**

**section-mode only:**

4. **Architecture requirement:** check that `<prose_output_dir>/<architecture-filename>` exists.
   - **If exists:** read first 50 lines to verify the target section ($ARGUMENTS) appears in the section hierarchy. If covered → proceed. If not covered → PAUSE: `Architecture exists but doesn't cover {section}. Options: regenerate architecture (/produce-architecture {part} after deleting current architecture files), or proceed with architecture-missing override for this section.`
   - **If does not exist:** PAUSE: `Architecture required. Run /produce-architecture {part} first to generate it. Or proceed with architecture-missing override (downstream prose will be written without depth/seam guidance — not recommended for documents with 2+ sections).`

5. **Style reference gate:** check if `<prose_output_dir>/<style-reference-filename>` exists.
   - **If exists:** note it — this is the locked style reference. Proceed to Phase 2.
   - **If does not exist:** Run the **first-run style-reference selection sub-flow** below. After operator approves the style reference, auto-continue to Phase 2 within the same invocation.

**report-mode only:**

6. **Style reference is project-locked.** Resolve from the path-config's `Style-reference path` value (e.g., `report/style-reference/{section}/{section}-style-reference.md`). The report-mode pipeline does NOT do a first-run selection — the project-level style reference is the authority across all reports.

Present the plan: source document path, mode, architecture status (section-mode only), style reference status, output file path. Wait for operator approval before proceeding.

### First-run style-reference selection sub-flow (section-mode only, first section)

> Triggered when `<prose_output_dir>/<style-reference-filename>` does not exist in section-mode.

1. List available style reference templates by globbing `/ai-resources/style-references/*.md`. Present each template with its name, document type description (from the file's header), and typical audience. Ask the operator which template to use, or whether to generate a style reference from scratch.
2. Read the selected template.
3. Read the source document identified in step 1 above (for customization context).
4. Customize the template for this document part. Apply the template's Customization Notes section. Adjustments may include: audience specificity, evidence calibration level, domain terminology, or document-specific constraints. Note which template was used and what was changed.
5. Write the customized style reference to `<prose_output_dir>/<style-reference-filename>`.
6. PAUSE — present the style reference to the operator for approval. Do not proceed until approved.
7. **Once approved, the style reference is locked. Auto-continue to Phase 2 within the same invocation.**

---

## Phase 2 — Initial Prose Production [delegate]

Mode-specific. Two skills, two delegation patterns; final output is the same `prose_file_path`.

0. **Path setup (first phase that launches a subagent, reused across phases).** Determine the absolute project-root path (the CWD at invocation) and cache it as `project_root_abs`. Resolve `prose_output_dir_abs = {project_root_abs}/{prose_output_dir}`. If unsure of the absolute root, run `pwd` once and cache the result. Then create the working directory: `mkdir -p "{prose_output_dir_abs}/<working-dir-name>"` (idempotent; needed for section-mode Phase 3 subagent-to-disk pattern; report-mode tolerates the no-op create).

**section-mode (Decision-to-Prose Conversion):**

1. Read the source document identified in Phase 1.
2. Read `/ai-resources/skills/decision-to-prose-writer/SKILL.md`.
3. Launch a general-purpose sub-agent. Pass it:
   - The skill content
   - The source document content
   - The style reference absolute path: `{prose_output_dir_abs}/<style-reference-filename>` — subagent reads this file before applying the skill.
   - The prose quality standards absolute path: `{project_root_abs}/context/prose-quality-standards.md` — subagent reads this file before applying the skill. Project-specific (NOT from ai-resources). Internalize the standards and write accordingly, not mechanically verify each one.
   - Output path: the Phase 1-resolved `prose_file_path` (interpolated from path-config — e.g., `output/part-{part}-prose/{section}-{slug}.md`; derive slug from the document title, kebab-case).
   - **Architecture specification** (if exists): read the architecture from `<prose_output_dir>/<architecture-filename>` and extract sections relevant to $ARGUMENTS — section hierarchy entry, depth allocation, cross-references, traceability table entries, structural overrides.
   - Task: Execute the decision-to-prose transformation per the skill logic. Apply the style reference and prose quality standards throughout (Tier 1 / 2 / 3 priority per the standards file's violation guide). Apply the style-reference Governing Voice Test as a passage-level filter. If a Plain-Language Register section is present in the style reference, apply it during writing. If architecture is provided: honor the depth allocation, implement must-land content, respect seam notes. Write the prose file and return: file path, word count, section count, any flags.
4. Write a brief status note (file path, word count) — do not read the full output yet.
5. ▸ /compact — skill content and source document no longer needed.

**report-mode (Prose Refinement):**

1. Read the source document identified in Phase 1.
2. Read `/ai-resources/skills/prose-refinement-writer/SKILL.md`.
3. Launch a general-purpose sub-agent. Pass it:
   - The skill content
   - The source document content (the post-fix R{N} prose)
   - The style reference absolute path (project-locked, resolved from path-config) — subagent reads this file before applying the skill.
   - Output path: the Phase 1-resolved `prose_file_path` (e.g., `report/produced/{section}/R{N}/R{N}-prosed.md`).
   - Task:
     1. **Read the style reference at the absolute path.** It is the authority for voice and tone.
     2. Execute the prose-refinement-writer skill's targeted intervention logic. Address only: unclear logical relationships between adjacent sentences; underdeveloped hardest claims in paragraphs.
     3. **This is a targeted intervention, not a rewrite.** Most sentences in any paragraph remain untouched (typically 1–2 changes per paragraph, sometimes none, occasionally 3). If you find yourself rewriting most sentences in a paragraph, stop and re-read this instruction.
     4. Preserve voice. Avoid AI-register smoothing — treat AI-register patterns (tricolons, pseudo-maxims, pivot closings, banned-word instances) as **constraints on your own fixes**, not as the primary target (those are addressed in Phase 5 by `ai-prose-decontamination`).
     5. Write the refined prose file and return: file path, word count, change count by category (logical-linkage fixes, hardest-claim development), any flags.
4. Write a brief status note — do not read the full output yet.
5. ▸ /compact — skill content and source document no longer needed.

---

## Phase 3 — Review and Fix [SECTION-MODE ONLY] [delegate-qc]

**Report-mode skips this phase entirely.** Proceed directly to Phase 5.

Merged diagnostic review (`chapter-prose-reviewer`) and compliance gate (`prose-compliance-qc`) in a single pass, followed by conditional fix application.

1. Read the prose file produced in Phase 2.
2. Read the source document (for transformation comparison and Degraded mode).
3. Read `/ai-resources/skills/chapter-prose-reviewer/SKILL.md`.
4. Read `/ai-resources/skills/prose-compliance-qc/SKILL.md`.
5. Launch a qc-reviewer sub-agent. Pass it:
   - Both skill contents
   - The prose file content
   - The source document content
   - The style reference absolute path — subagent reads this file before evaluating.
   - The prose quality standards absolute path: `{project_root_abs}/context/prose-quality-standards.md` — subagent reads before evaluating.
   - Adaptation notes conditional on architecture: pass architecture content if `<prose_output_dir>/<architecture-filename>` exists (extract sections relevant to $ARGUMENTS, same as Phase 2). The reviewer's §1 (architecture compliance) applies; compliance QC Scan 3 runs in Standard mode. If absent: override the chapter-prose-reviewer's blocking requirement; reviewer proceeds with §2–§5 only; compliance QC Scan 3 runs in Degraded mode.
   - The chapter-prose-reviewer skill content serves as anti-pattern reference for compliance QC Scan 1.
   - **Sequencing note:** Diagnostic review and compliance scans run against the same unmodified prose. When running compliance scans, treat findings from the diagnostic review as "pending fixes" — only flag as compliance violations items that would survive after the diagnostic review's recommended fixes are applied. Do not double-count.
   - **Anti-scaffolding instruction:** Do NOT restore cross-reference codes (WH, OQ, DP, section numbers as references), chain-activity anchors, value-chain stage labels used as structural markers, or any scaffolding from the source document. These were intentionally removed during prose conversion. Do NOT flag their absence as a gap.
   - **Prose quality checks:** Apply the detection tests from all 13 standards as additional review criteria alongside the skill frameworks, checking in the priority order from the violation guide. Apply expanded detection tests for Standards 10–13 explicitly (contrast-construction count per section; abstract-noun-compound rewrite test; pseudo-maxim sentence count per section; pivot-closing detection; flagged-vocabulary scan against any Plain-Language Register in the style reference).
   - Task: Read the style reference and prose quality standards at the provided absolute paths. Run the diagnostic review and produce a score (1–5) and flag report. Run all four compliance scans (treating diagnostic findings as pending fixes per the sequencing note). Apply the 13 prose quality checks. Produce a unified findings list combining all passes, with severity ratings (HIGH/MEDIUM/LOW) and per-spec verdicts.
   - **Output-to-disk pattern:** Write the full unified findings list to `{prose_output_dir_abs}/<working-dir-name>/phase-3-qc-{section}.md`. Return to the main session a summary of no more than 20 lines with exactly these fields: `working_file`, `score`, `high_count`, `medium_count`, `low_count`, `bright_line_items_count`, `verdict` (one line — `auto-proceed` / `fix-agent-needed` / `pause-for-operator`).

6. Route on score and findings:
   - **Score 4-5 with only LOW findings:** Note findings. Proceed to Phase 4 (or Phase 5 if Phase 4 skipped). No fix agent needed.
   - **Score 4-5 with MEDIUM+ findings:** Launch a general-purpose sub-agent with the prose file, the path to the Phase 3 findings file, the style reference absolute path, the source document, and the anti-scaffolding instruction. Task: apply all non-bright-line fixes and write the corrected file. For bright-line items (multi-paragraph changes, analytical claim alterations, sourced statement modifications): log and present to the operator. After fixes, proceed to Phase 4.
   - **Score 3 with fewer than 3 HIGH findings:** Same as above — launch fix sub-agent. Present bright-line items and any HIGH findings to the operator before proceeding.
   - **Score 3 with 3+ HIGH findings:** PAUSE — present findings to the operator. Options: re-run Phase 2 with editorial annotations, or proceed with fix sub-agent.
   - **Score 1-2:** PAUSE — present findings to the operator. The prose conversion has failed. Options: re-run Phase 2 with editorial annotations, or override and proceed.

7. Write a brief Phase 3 handoff note for the main session: working-file path, score, severity counts, count of findings auto-fixed, count of bright-line items deferred for operator review. This note feeds Phase 7 (handoff).
8. ▸ /compact — skill content and source document no longer needed.

---

## Phase 4 — Integration Check [SECTION-MODE ONLY, CONDITIONAL] [delegate]

**Report-mode skips this phase entirely.** Proceed directly to Phase 5.

**Condition (section-mode):** Only runs if other completed prose sections exist in `<prose_output_dir>` (i.e., this is not the first section being converted). If this is the first section, skip to Phase 5.

This phase catches cross-section issues that single-section review cannot detect: transition quality at section boundaries and redundancy/contradiction between independently written sections.

1. Glob `<prose_output_dir>/*.md` to find all completed prose sections. Exclude non-prose files by name: `<architecture-filename>`, `architecture-qc.md`, `<style-reference-filename>`, `<decon-log-filename>`. Remaining files are prose sections.
2. If no other prose sections exist: skip this phase entirely, proceed to Phase 5.
3. Read the current section's prose file (post-Phase 3 fixes).
4. Read the architecture (if exists) — specifically the cross-reference map and processing order, to identify which sections are adjacent to and dependent on the current section.
5. Read adjacent sections' prose files — "adjacent" means the sections immediately before and after this section in the architecture's processing order. If no architecture exists, use section numbering order.
6. Read all other completed prose sections (non-adjacent) — for redundancy/contradiction checking. For large document parts (6+ completed sections), read only the opening and closing paragraphs of non-adjacent sections to manage context size.
7. Launch a general-purpose sub-agent. Pass it the current section's prose, adjacent sections' prose, non-adjacent sections' prose (excerpted per step 6), architecture cross-reference map + seam notes (if architecture exists), style reference absolute path. Task: read the style reference at the provided path, then run two focused checks:

   **A. Transitions** — Examine the boundary between this section and each adjacent section: does this section's opening connect to the preceding section's conclusion? Does this section's conclusion set up the following section's opening? If architecture seam notes exist for these boundaries, are they implemented? For each weak or missing transition: draft a transition passage (1–3 sentences), labeled `[TRANSITION DRAFT — Section X.X to Y.Y]`. Indicate placement (end of preceding section / start of current section).

   **B. Redundancy & Contradiction** — Compare this section against all other completed prose: same conclusion or argument restated across sections without cross-reference; same statistic, data point, or claim stated with different figures or framing; same concept explained in multiple sections without acknowledgment. For each finding: location in both sections, description, severity (SUBSTANTIVE if it affects credibility or creates confusion, NON-SUBSTANTIVE if minor repetition).

   Return: transition drafts (if any), redundancy/contradiction findings (if any), clean-pass note if no issues.

8. Route on findings:
   - **No findings:** Note clean pass. Proceed to Phase 5.
   - **Transition drafts only:** Present drafts to the operator. The operator decides which to incorporate. Apply approved transitions. (Transition passages of 1–3 sentences are not bright-line items. If a draft exceeds one paragraph, apply the bright-line rule check before inserting.) Proceed to Phase 5.
   - **Redundancy/contradiction findings:** Present all findings to the operator. SUBSTANTIVE findings require a decision before proceeding — the operator chooses which section to adjust, or accepts the repetition. NON-SUBSTANTIVE findings are noted for future reference. Proceed to Phase 5 after the operator reviews.
   - Redundancy/contradiction fixes that require changes to *other* sections are logged to `logs/decisions.md` as cross-section revision notes, not applied directly.

9. ▸ /compact — adjacent section content no longer needed.

---

## Phase 5 — AI Prose Decontamination [delegate, sonnet]

See `reference/stage-5-common-phases.md` anchor `phase-decontamination` for the full phase definition.

**Mode-vars for this invocation:**
- `{PHASE_NUMBER}`: 5
- `{NEXT_PHASE}`: Phase 6 (jargon gloss)
- `{SOURCE_DOC_AVAILABILITY}`:
  - section-mode: `"available"` (source document was identified in Phase 1 and may be passed if still in context)
  - report-mode: `"skipped"` (source already consumed in Phase 2's prose refinement)
- `{PROSE_QUALITY_STANDARDS_PATH}`:
  - section-mode: `{project_root_abs}/context/prose-quality-standards.md`
  - report-mode: empty (report-mode does not pass a project-level prose-quality-standards file)
- `{prose_output_dir}`: resolved in Phase 0 + Phase 1

---

## Phase 6 — Jargon Gloss [delegate, sonnet]

See `reference/stage-5-common-phases.md` anchor `phase-jargon-gloss` for the full phase definition.

**Mode-vars for this invocation:**
- `{PHASE_NUMBER}`: 6
- `{NEXT_PHASE}`: Phase 7 (handoff)
- `{prose_output_dir}`: resolved in Phase 0 + Phase 1

---

## Phase 7 — Handoff (main session)

See `reference/stage-5-common-phases.md` anchor `phase-handoff-prose-draft` for the full handoff definition.

**Mode-vars for this invocation:**
- `{arg}`: the validated arg from Phase 0.
- `{SECTION_MODE_QC_WORKING_FILE}`:
  - section-mode: `{prose_output_dir_abs}/<working-dir-name>/phase-3-qc-{section}.md`
  - report-mode: empty (no QC working file in report-mode; report-mode skips Phase 3)
- `{PHASE_2_OR_3_SUMMARY}`:
  - section-mode: Phase 3 review score (1–5) + critical findings (HIGH severity, from the QC working file)
  - report-mode: Phase 2 refinement summary (change count by category — logical-linkage fixes, hardest-claim development)
- `{CROSS_SECTION_INTEGRATION_SUMMARY}`:
  - section-mode (only when Phase 4 ran): transitions added, redundancy/contradiction findings + disposition
  - report-mode: empty
- `{ARCHITECTURE_COMPLIANCE_NOTES}`:
  - section-mode (only when architecture exists): depth allocation honored, must-land content implemented, seam notes implemented
  - report-mode: empty
