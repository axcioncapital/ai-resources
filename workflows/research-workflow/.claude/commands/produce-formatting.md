---
friction-log: true
model: sonnet
---
Format prose for: $ARGUMENTS

> **Path A parameterized.** This canonical command reads project paths from `reference/stage-5-paths.md` (instantiated per project from `ai-resources/workflows/research-workflow/reference/stage-5-paths.template.md`) and dispatches on `Document model:` declared in the project's `## Project Config`. See `plans/fx-b1-path-a-design-v3.md` and `docs/project-config-schema.md § Default-value semantics for Document model`.

Apply formatting, H3 placement/refinement, and document-level integration QC to one section's reviewed and decontaminated prose. Chains four skills across two delegated phases: prose formatting + H3 pass (prose-formatter + h3-title-pass, merged) and two-stage formatting + editorial integration QC (formatting-qc + document-integration-qc). Operates on prose that has already passed `/produce-prose-draft` (review + decontamination).

Per-section run: 2 subagent launches, target ~6–10 min wall time.

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

3. **Read project `reference/stage-5-paths.md`.** Verify it exists; if missing: halt — `reference/stage-5-paths.md is missing. Stage 5 commands require explicit path-config; create from canonical template at ai-resources/workflows/research-workflow/reference/stage-5-paths.template.md.`

4. **Verify mode match.** Locate the `Mode:` line. If absent or mismatched: halt with the documented error message (see `stage-5-paths.template.md § Mode-mismatch halting`).

5. **Parse path-config.** Read the `## Stage 5 Path Roots` block. Cache resolved values for Phases 1–4.

6. **Resolve `Mechanical trigger threshold`.** This is a graceful-default field — absence does NOT halt. Behavior:
   - If `Mechanical trigger threshold:` line is absent from `stage-5-paths.md`, OR present with empty value: set `threshold = "5+"` (canonical default).
   - If present with value matching `^[0-9]+\+?$` (e.g., `"3+"`, `"5"`, `"7+"`): set `threshold` = the provided value verbatim.
   - If present with malformed value: halt — `Mechanical trigger threshold value '<X>' is malformed. Expected pattern: ^[0-9]+\+?$ (e.g., '3+', '5+', '7+'). See ai-resources/workflows/research-workflow/reference/stage-5-paths.template.md § Default-value semantics for Mechanical trigger threshold:.`
   - The resolved `threshold` value is passed explicitly to the prose-formatter subagent in Phase 2 step 6 (overrides the SKILL.md default for this invocation).

---

## Phase 1 — Plan (main session)

Keep this phase lightweight. Do NOT read source files yet.

1. **Locate the prose file** at `prose_file_path`, resolved from the path-config + parsed arg.
   - report-mode: `<prose_output_root>/<prose_output_filename>` (e.g., `report/produced/{section}/R{N}/R{N}-prosed.md`).
   - section-mode: glob `<prose_output_root>/<prose_output_filename_glob>` (e.g., `output/part-{part}-prose/{section}-*.md`). Multi-match resolution per the path-config's `Source filename multi-match selector`.
   - If no matching prose file exists: PAUSE — `No prose file found for {arg}. Run /produce-prose-draft {arg} first.`

2. **`prose_output_dir`** — directory containing `prose_file_path`. Used as base for log and working-dir paths.

3. **Decontamination check.** Verify the decontamination log exists at `<prose_output_dir>/<decon-log-filename>`.
   - **If present** (either as a per-section entry or a per-report log, depending on mode): proceed.
   - **If absent:** WARN — `Decontamination log not found at <path>. The prose may not have passed the decontamination phase of /produce-prose-draft. Options: proceed anyway (formatting will still run), or cancel and run /produce-prose-draft {arg} first.`

4. **Formatted-output path resolution.**
   - report-mode: `<prose_output_dir>/<formatted-output-filename>` (typically a fresh file, non-overwriting — e.g., `R{N}-formatted.md`).
   - section-mode: same file as `prose_file_path` (overwrites in place; the prose-formatter skill's versioning default is overridden by this command).

Present the plan: prose file path, decontamination status, output path (overwrite-in-place for section-mode; fresh file for report-mode). Wait for operator approval before proceeding.

---

## Phase 2 — Formatting + H3 Full Pass [delegate, sonnet]

Merged formatting, H3 placement, and H3 refinement in a single sonnet agent. KEEP/RENAME/REMOVE verdicts auto-apply mid-pipeline; all REMOVE verdicts are reported in Phase 4 (handoff) with rationale and reversal instructions so the operator can catch structural deletions at the end.

1. Read the prose file located in Phase 1.
2. Read `/ai-resources/skills/prose-formatter/SKILL.md`.
3. Read `/ai-resources/skills/h3-title-pass/SKILL.md`.
4. Resolve the absolute path to the style reference: `{project_root_abs}/<style-reference-path>` (interpolated from the path-config — report-mode uses the explicit `Style-reference path` value; section-mode joins `<prose_output_dir>/<style-reference-filename>`). Do NOT read it into main-agent context — the subagent reads reference files directly per the workflow's "Context Isolation Rules" exception for large read-only references. Cache `{prose_output_dir_abs}` (derive from Phase 1 paths and `pwd` if not already resolved).
5. Create the working directory for subagent findings files: `mkdir -p "{prose_output_dir_abs}/<working-dir-name>"` (idempotent; needed for Phase 2 and Phase 3 subagent-to-disk pattern).
6. Launch a general-purpose sub-agent with `model: "sonnet"`. Pass it:
   - The prose-formatter skill content
   - The h3-title-pass skill content
   - The prose file content
   - The absolute path to the style reference — the subagent reads it directly before applying the skills
   - Output path: the Phase 1-resolved formatted-output path (section-mode = same file; report-mode = fresh `<formatted-output-filename>` next to the prosed input)
   - **`Mechanical trigger threshold: {threshold}`** (verbatim, interpolated from Phase 0 step 6 — typically `"5+"` canonical default, or a project override like `"3+"`). The subagent MUST honor this passed threshold for Mechanical Trigger #1 (parallel-items detection), overriding the SKILL.md `5+` default for this invocation. If this parameter is not passed, the subagent falls back to the SKILL.md default — but this command always passes it, so the fallback is a defensive position only.
   - Task: Execute in this order as a single continuous pass:
     0. **Run the Mechanical Triggers pre-scan per the prose-formatter skill.** Scan the full document for the eight mandatory triggers: (1) `{threshold}` parallel items in prose — use the passed threshold value, NOT the SKILL.md default; (2) category comparison across repeated dimensions; (3) subsection with multiple internal blocks; (4) bold on labels but not on named frameworks; (5) paragraph carrying framework + exceptions + implications; (6) trend-trajectory paragraph with 3+ data points; (7) 2+ named geographies OR 2+ named sectors compared across 2+ named dimensions; (8) paragraph-split coordination with `ai-prose-decontamination` Pass 5b. Record which triggers fire and at which locations. Produce the trigger-hit list — it feeds Steps 1–3 and is returned to the main agent. Trigger hits are MANDATORY decisions, not interpretive calls; when a trigger fires, the mapped operation applies and the "when uncertain, defer" fallback does NOT override it.
     1. Run all formatting operations per the prose-formatter skill (bold/italic, lists, tables, paragraph length, horizontal rules, spacing). Record a formatting change log. Operation 1 may detect additional pseudo-heading bold labels that belong on the trigger #3 hit list — add them, do NOT bold them.
     2. Run H3 title pass Step 1 (placement) per the h3-title-pass skill, consuming the trigger #3 hit list as candidate SPLIT verdicts. Record a verdict per heading: KEEP / RENAME / REMOVE / SPLIT with rationale.
     3. Run H3 title pass Step 2 (refinement) per the skill. Apply KEEP/RENAME/REMOVE verdicts. For RENAME, apply the refined wording. For REMOVE, delete the heading. **Do NOT auto-apply SPLIT verdicts** — they are operator-gated and surfaced at Phase 4 for approval.
     4. Write the final formatted file.
   - **Output-to-disk pattern (required — subagent-contract compliance):** Write the full structured output below to `{prose_output_dir_abs}/<working-dir-name>/formatting-phase-2-{arg}.md`. Sections of the working file (all required, do not omit):
     - Mechanical Trigger pre-scan results: which triggers fired, document locations, brief description of each hit
     - Formatting change log (per-operation summary)
     - H3 decisions table: every heading processed, with verdict (KEPT / RENAMED / REMOVED / SPLIT), original text, final text (for RENAMED), rationale, and for REMOVED a one-line reversal instruction
     - SPLIT verdicts (if any): for each, (a) subsection being split, (b) proposed insertion line reference, (c) proposed new H3 title, (d) block-boundary rationale naming the two resulting blocks
     - Final H3 count
     - Any flagged items
   - **Return to main session (no more than 20 lines):**
     - `working_file`: absolute path to the file just written
     - `final_h3_count`: integer
     - `h3_verdicts`: counts by category — `kept`, `renamed`, `removed`, `split`
     - `removed_highlights`: up to 3 one-line summaries of REMOVED verdicts
     - `mtc_triggers_fired`: count
     - `flagged_items_count`: integer
     - `verdict`: one line
7. ▸ /compact — skill content no longer needed.

---

## Phase 3 — Merged Formatting + Editorial Integration QC [delegate-qc]

Merged two-stage QC. One qc-reviewer subagent runs both checks in explicit sequence: formatting-qc first (including any mechanical fixes), then document-integration-qc on the post-fix prose. The merge preserves the editorial pass's dependency on the formatting pass — the editorial pass explicitly receives the formatting pass's output as "already addressed" context.

1. Read the prose file (post-Phase 2 — final formatted version with H3 applied).
2. Read `/ai-resources/skills/formatting-qc/SKILL.md`.
3. Read `/ai-resources/skills/document-integration-qc/SKILL.md`.
4. Read the architecture (section-mode only) at `<prose_output_dir>/<architecture-filename>` if exists — provides document structure context for completeness checks. (Report-mode skips this; report-mode projects do not use architecture.md.)
5. Resolve the absolute path to the style reference (per Phase 2 step 4).
6. Collect from Phase 2: the formatting change log and any deferred/flagged items.
7. Gather any cross-section integration findings carried forward from `/produce-prose-draft` (section-mode Phase 4, if available in the session context).
8. Launch a qc-reviewer sub-agent. Pass it:
   - The formatting-qc skill content (labeled: "STAGE 1 SKILL — formatting mechanics")
   - The document-integration-qc skill content (labeled: "STAGE 2 SKILL — editorial quality")
   - The prose file content
   - Absolute path to the Phase 2 working file: `{prose_output_dir_abs}/<working-dir-name>/formatting-phase-2-{arg}.md`
   - Cross-section integration findings from `/produce-prose-draft` (if available)
   - Module identifier: `{arg}` + section/report title; position in the document derived from the architecture's processing order if available, otherwise from arg numbering
   - The architecture content (section-mode only, if exists)
   - The absolute path to the style reference — the subagent reads it directly before running formatting-qc
   - **Two-stage execution instructions (critical — execute strictly in this order):**
     - **STAGE 1 — Formatting QC:** Run all five checks per the formatting-qc skill (Formatting Integrity, Visual Rhythm, Standalone Coherence, Footnote Integrity, Mechanical Trigger Compliance). Produce a Stage 1 findings list with severity ratings. For mechanical formatting fixes (broken list structure, missing table caption, orphaned sentence fragment, spacing errors): apply them directly to the prose file and record in a "Stage 1 fixes applied" log. For fixes that affect standalone coherence (missing orientation, vague cross-references) or Mechanical Trigger Compliance findings: flag them as bright-line candidates and do NOT apply — these are substantive formatting decisions that should surface to the operator. Write the post-fix prose to the output path.
     - **STAGE 2 — Editorial Integration QC:** Only begin after Stage 1 is complete and the post-fix prose is written. Read the post-fix prose. Run all four check categories per the document-integration-qc skill (Narrative Structure, Consistency, Redundancy & Contradiction, Completeness). Draft transition passages where transitions are weak. **Do NOT re-flag any item from the Stage 1 findings, Stage 1 fixes applied log, the Phase 2 deferred items list, or the cross-section integration findings.** Focus redundancy/contradiction checks on issues internal to this module only. The `RELEASE ARTIFACT` protocol in the document-integration-qc skill is overridden — produce the full QC report directly.
   - Adaptation notes:
     - "This module has already passed prose quality review and AI prose decontamination via `/produce-prose-draft`, plus formatting + H3 (Phase 2 of this command). Decontamination removed AI-pattern prose (ornamental language, repetition, over-argumentation, flat rhythm) without changing analytical content. If you find an abrupt section ending or a transition that feels missing, check whether it may be a decontamination artifact rather than a pre-existing issue."
   - Task summary: Execute Stage 1 then Stage 2 as described. **Output-to-disk pattern:** Write the full structured QC report to `{prose_output_dir_abs}/<working-dir-name>/formatting-phase-3-qc-{arg}.md`. Sections of the working file (all required): Stage 1 findings (formatting) with severity, Stage 1 fixes-applied log, Stage 1 bright-line candidates, Stage 2 findings grouped by check category (Narrative Structure / Consistency / Redundancy & Contradiction / Completeness), transition drafts (if any), and overall verdict.
   - **Return to main session (no more than 20 lines):**
     - `working_file`: absolute path to the file just written
     - `stage_1_substantive_count`, `stage_1_bright_line_count`, `stage_1_auto_fixed_count`
     - `stage_2_substantive_count` (total), plus per-category: `narrative`, `consistency`, `redundancy`, `completeness`
     - `transition_drafts_count`
     - `verdict`: one line
9. Route on findings:
   - **No SUBSTANTIVE findings in either stage:** Note results and any NON-SUBSTANTIVE items. Proceed to Phase 4 (handoff).
   - **Stage 1 bright-line candidates:** Present to the operator before applying. These are formatting fixes that cross into prose changes.
   - **Stage 2 SUBSTANTIVE findings without transition drafts:** Present findings to the operator. Apply bright-line rule — SUBSTANTIVE narrative or consistency issues likely require prose changes. Proceed to Phase 4 after the operator reviews.
   - **Stage 2 transition drafts produced:** Present transition drafts to the operator. The operator decides which to incorporate. Approved transitions are inserted into the prose file. (Transition passages of 1–3 sentences are not bright-line items. If a transition draft exceeds one paragraph, apply the bright-line rule check before inserting.) Proceed to Phase 4.
   - **Findings that suggest issues in other sections:** Log to `logs/decisions.md` as cross-section revision notes. Do not modify other sections' prose.
10. ▸ /compact — skill content no longer needed.

---

## Phase 4 — Handoff

See `reference/stage-5-common-phases.md` anchor `phase-handoff-formatting` for the full handoff definition.

**Mode-vars for this invocation:**
- `{arg}`: the validated arg from Phase 0.
- `{PART2_REVIEW_LAYER_REMINDER}`: section-mode only — surface if `{arg}` matches a Part 2 section. Report-mode: omit.
