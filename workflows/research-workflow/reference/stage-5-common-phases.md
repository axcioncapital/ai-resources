# Stage 5 Common Phases

> Workflow-reference doc consumed by canonical Stage 5 commands (`produce-prose-draft`, `produce-formatting`, `produce-jargon-gloss`). Each anchored section is a self-contained phase definition. Command files reference these by anchor instead of inlining the phase. Mode-specific variation points are marked with `{MODE-VAR-NAME}` callouts that the consuming command interpolates from its mode-block at runtime.

## Contract

**Anchor convention.** Each shared-phase section carries an HTML-comment anchor immediately above its heading (e.g., `<!-- anchor: phase-decontamination -->`). Canonical Stage 5 command files cite anchors verbatim in their phase-dispatch lines: `See reference/stage-5-common-phases.md anchor \`phase-decontamination\`.`

**Mode-variation convention.** Where a shared phase has mode-specific behavior, the variation point is marked `{MODE-VAR-NAME}` in this doc. The consuming command provides the per-mode value in its own command-file mode-block. Variation points used by the phases below:

- `{SOURCE_DOC_AVAILABILITY}` — `"available"` in section-mode (source document is passed as input); `"skipped"` in report-mode (source already consumed upstream).
- `{PROSE_QUALITY_STANDARDS_PATH}` — absolute path to `context/prose-quality-standards.md` in section-mode; empty/omitted in report-mode.
- `{PHASE_NUMBER}` — the integer phase number this command-file assigns to this shared phase (e.g., `Phase 5` in canonical section-mode produce-prose-draft, `Phase 3` in nordic-pe report-mode produce-prose-draft).
- `{NEXT_PHASE}` — the next-phase reference for routing (e.g., `Phase 6 (jargon gloss)` in section-mode, `Phase 4 (jargon gloss)` in report-mode).

**Drift detection.** A `friday-checkup` grep line verifies bidirectionally that every `anchor: phase-X` declared here has at least one matching `anchor \`phase-X\`` reference in the canonical Stage 5 commands, and every `anchor \`phase-X\`` referenced in a command exists as a declared anchor here. Mismatch surfaces as a Friday-checkup finding. Same enforcement pattern as the existing `Country set` same-commit mirror rule.

**Scope of this doc.** Truly shared phases only — phases that appear in ≥2 canonical Stage 5 commands. Phases unique to a single command (e.g., produce-formatting's Merged Formatting + Editorial Integration QC; produce-prose-draft's section-mode Decision-to-Prose Conversion) remain in their command files even when long; extracting single-use content here would conflate "shared" with "long."

---

<!-- anchor: phase-decontamination -->
## Phase — AI Prose Decontamination

> Used by: `produce-prose-draft` (both modes). Skill: `ai-prose-decontamination`. Subagent tier: `sonnet` (pattern-based; overrides skill's declared opus tier — command-layer authority per workspace `CLAUDE.md`).

Removes AI writing patterns (ornamental language, repetition, over-argumentation, flat rhythm) from substantively correct prose. Runs four sequential passes that progressively clean the voice without changing analytical content.

**Condition:** Always runs. Skip only if the operator explicitly opts out during Phase 1 planning.

**Execution:**

1. Read the prose file (the prior phase's output).
2. If `{SOURCE_DOC_AVAILABILITY}` is `"available"`: read the source document identified in Phase 1 (if available after compaction — if not, proceed without and note in the handoff). If `"skipped"`: omit this step.
3. Read `/ai-resources/skills/ai-prose-decontamination/SKILL.md`.
4. Launch a general-purpose sub-agent with `model: "sonnet"`. Pass it:
   - The skill content
   - The prose file content
   - The style reference absolute path (resolved from the command's Phase 1 cache) — subagent reads this file before applying the skill.
   - If `{PROSE_QUALITY_STANDARDS_PATH}` is non-empty: also pass the prose quality standards absolute path — subagent reads this file before applying the skill. Project-specific file resolved from the project root (NOT from ai-resources).
   - The source document content (only if `{SOURCE_DOC_AVAILABILITY}` is `"available"`).
   - Output path: same prose file (explicit overwrite — Stage 5 commands own the file-versioning contract; the skill's standalone default of writing to a new path does not apply here).
   - Change log output path: `{prose_output_dir}/decontamination-log.md`
   - Task: **First, read the style reference (and prose quality standards if provided) at the absolute paths.** Then execute all four decontamination passes per the skill logic, including the five named sub-patterns (1a contrast-template overuse, 1b abstract-noun stacking, 1c Flagged-Word Registry application, 2a pivot closings, 4a pseudo-maxim budget) the skill carries natively. Write the corrected prose file. Write the change log. Return: change counts per pass and per sub-pattern, any bright-line flags, and any passages where decontamination was constrained by style reference or evidence calibration preservation.
   - **Bright-line rule override for `{PHASE_NUMBER}`:** The decontamination pass is exempt from the multi-paragraph scope check (bright-line check 1) because it operates across the entire document by design. Checks 2 and 3 still apply: if any change alters an analytical claim or modifies a sourced statement, the sub-agent must flag it in the bright-line-flags section of the change log and must NOT apply that change. If bright-line flags are populated, the main agent PAUSEs for operator approval before proceeding.

5. Route on result:
   - **Zero bright-line flags:** Proceed to `{NEXT_PHASE}` automatically.
   - **Bright-line flags present:** PAUSE — present flags to the operator. Apply or discard per operator decision, then proceed to `{NEXT_PHASE}`.
   - **Zero changes across all passes:** Note "Prose already clean — no decontamination needed." Proceed to `{NEXT_PHASE}`.

6. Write a phase handoff note: total changes, per-pass breakdown, any bright-line flags and their disposition, any constrained passages.

7. ▸ /compact — skill content and source document no longer needed.

---

<!-- anchor: phase-jargon-gloss -->
## Phase — Jargon Gloss

> Used by: `produce-prose-draft` (both modes), `produce-jargon-gloss` (standalone). Skill: `jargon-gloss`. Subagent tier: `sonnet` (pattern-based detection against an explicit whitelist + category list; analytical judgment not required — overrides the skill's declared opus tier; command-layer authority per workspace `CLAUDE.md`).

Detects undefined domain-specific terms (named regulations, frameworks, agency programs, niche acronyms) on first mention and inserts short parenthetical glosses (5–15 words) in place. Standard PE/finance vocabulary is whitelisted and left bare. Voice and rhythm established by the prior phase are preserved.

**Condition:** Always runs in `produce-prose-draft`. Standalone in `produce-jargon-gloss`. Skip only if the operator explicitly opts out during Phase 1 planning.

**Execution:**

1. Read the prose file (the prior phase's output, or the input file when invoked standalone).
2. Read `/ai-resources/skills/jargon-gloss/SKILL.md`.
3. Launch a general-purpose sub-agent with `model: "sonnet"`. Pass it:
   - The skill content
   - The prose file content
   - The style reference absolute path (resolved from the command's Phase 1 cache; may be absent in `produce-jargon-gloss` standalone — subagent uses neutral analytical phrasing per the skill default if so).
   - Output path: same prose file (explicit overwrite; Stage 5 commands own the file-versioning contract).
   - Change log output path: `{prose_output_dir}/gloss-additions-log.md`
   - Task: **First, read the style reference at the absolute path if provided.** Then execute the jargon-gloss pass per the skill logic: detect first-mention occurrences of undefined domain-specific terms across the document, check each against the PE Vocabulary Whitelist in the skill, apply the standard gloss format `Term (5–15 word definition)` on the first mention only, apply the sentence-split rule when a glossed sentence would exceed 35 words, preserve idempotency where the source prose already contains a definition. Write the glossed prose file. Write the change log. Return: terms-glossed count, idempotent-skip count, sentence-split count, bright-line flags count, and a brief summary of any constrained passages.
   - **Bright-line rule override for `{PHASE_NUMBER}`:** The gloss pass is exempt from the multi-paragraph scope check (bright-line check 1) because first-mention detection requires document-wide scanning by design. Checks 2 and 3 still apply: if applying a gloss would alter an analytical claim or modify a sourced statement (e.g., inside a quote), the sub-agent must flag it in the bright-line-flags section of the change log and must NOT apply that change. If bright-line flags are populated, the main agent PAUSEs for operator approval before proceeding.

4. Route on result:
   - **Zero bright-line flags:** Proceed to `{NEXT_PHASE}` automatically.
   - **Bright-line flags present:** PAUSE — present flags to the operator. Apply or discard per operator decision, then proceed to `{NEXT_PHASE}`.
   - **Zero terms glossed:** Note "Prose already accessible — no gloss insertions needed." Proceed to `{NEXT_PHASE}`.

5. Write a phase handoff note: terms-glossed count, idempotent-skip count, sentence-split count, any bright-line flags and their disposition.

6. ▸ /compact — skill content no longer needed.

---

## Handoff blocks (per-command)

The three Stage 5 commands have substantially different handoff content, so each command anchors its own handoff block. Per-command sub-sections below.

<!-- anchor: phase-handoff-prose-draft -->
### Handoff — produce-prose-draft

> Used by: `produce-prose-draft` (both modes). Main session phase.

Operator-facing presentation at the end of the prose-draft pipeline. Mode-specific sections are marked with `{MODE-VAR-NAME}` callouts.

**Execution:**

1. Read the post-gloss prose file (from the prior phase).

2. If `{SECTION_MODE_QC_WORKING_FILE}` is non-empty (section-mode only): read the working-file path to retrieve the full Phase 3 QC findings for operator surfacing.

3. Present to the operator:
   - **Source file path used** + (mode-specific draft/version reference) + final word count.
   - **`{PHASE_2_OR_3_SUMMARY}`** — section-mode: Phase 3 review score (1–5) + critical findings (HIGH severity, from working file); report-mode: Phase 2 refinement summary (change count by category — logical-linkage fixes, hardest-claim development).
   - **`{CROSS_SECTION_INTEGRATION_SUMMARY}`** — section-mode only (when Phase 4 integration check ran): transitions added, redundancy/contradiction findings and their disposition.
   - **Decontamination log path** + per-pass change summary. Full log at `{prose_output_dir}/decontamination-log.md`.
   - **Jargon-gloss log path** + summary (terms-glossed count, idempotent-skip count, sentence-split count). Full log at `{prose_output_dir}/gloss-additions-log.md`.
   - **`{ARCHITECTURE_COMPLIANCE_NOTES}`** — section-mode only (when architecture was used): depth allocation honored, must-land content implemented, seam notes implemented.
   - **Bright-line items deferred for operator decision** (any unresolved items from prior phases).

4. Suggest next step:
   - **Standard path:** "Run `/produce-formatting {arg}` to apply formatting, H3 placement, and document-level integration QC." `{arg}` is the section ID (section-mode) or report ID (report-mode).
   - **If unresolved bright-line items:** "Resolve flagged items first (apply or discard per your decision), then run `/produce-formatting {arg}`."

---

<!-- anchor: phase-handoff-formatting -->
### Handoff — produce-formatting

> Used by: `produce-formatting` (both modes). Main session phase.

Operator-facing presentation at the end of the formatting pipeline. Mode-specific sections are marked with `{MODE-VAR-NAME}` callouts.

**Execution:**

1. Read the final formatted prose file.

2. Read the Phase 2 working file (`{prose_output_dir}/working/formatting-phase-2-{arg}.md`) to retrieve the full Mechanical Trigger pre-scan, formatting change log, H3 decisions table, and SPLIT verdicts for operator surfacing.

3. Read the Phase 3 working file (`{prose_output_dir}/working/formatting-phase-3-qc-{arg}.md`) to retrieve the full Stage 1 and Stage 2 findings and transition drafts for operator surfacing.

4. Present to the operator:
   - **Final prose file path** + final word count.
   - **Mechanical Trigger pre-scan results** (from Phase 2 Step 0): which triggers fired, document locations, brief description of each hit. So the operator sees which categories of format were caught and which were judged non-applicable.
   - **Formatting change log** (from Phase 2).
   - **H3 decisions table** (from Phase 2): present the full verdict table. **Highlight every REMOVED heading explicitly at the top** with its original text, rationale, and the reversal instruction from Phase 2. REMOVED verdicts were auto-applied mid-pipeline; surfacing them here is the operator's opportunity to reverse a structural deletion.
   - **SPLIT verdicts** (from Phase 2, if any): list each with (a) the subsection being split, (b) proposed insertion line reference, (c) proposed new H3 title, (d) block-boundary rationale. SPLIT verdicts are NOT auto-applied; they are surfaced here for operator decision. **Application path:** if the operator approves a SPLIT, the main agent applies it directly as a post-handoff edit — insert the approved H3 at the specified line, read the file back to confirm, log the change to `logs/decisions.md`. The operator's handoff approval of the specific SPLIT constitutes the required operator approval for the project bright-line rule; no additional bright-line pause is needed for the insertion. If the operator declines a SPLIT, leave the subsection unchanged and record the declined verdict for traceability.
   - **Phase 3 Stage 1 (formatting-qc) findings** + auto-fixes applied. Note: formatting-qc runs five checks (Formatting Integrity, Visual Rhythm, Standalone Coherence, Footnote Integrity, Mechanical Trigger Compliance). MTC findings flag miss patterns the Mechanical Triggers were designed to prevent — if present, the pre-scan did not fire on the corresponding pattern.
   - **Phase 3 Stage 2 (document-integration-qc) findings** + transition drafts produced (and disposition).
   - **`{PART2_REVIEW_LAYER_REMINDER}`** — section-mode only: if `{arg}` is a Part 2 section, surface the project rule requiring three review layers (`/review` + `/challenge` + `/service-design-review`) before promotion to `parts/part-2-service/approved/`. Report-mode: omit.
   - **Bright-line items deferred for operator decision** (any unresolved items from Phase 2 or Phase 3).

5. Suggest next step: prose is formatted and integration QC has passed. The operator decides whether to accept or route to further review per project rules.

---

<!-- anchor: phase-handoff-jargon-gloss -->
### Handoff — produce-jargon-gloss

> Used by: `produce-jargon-gloss` (standalone). Main session phase.

Operator-facing presentation at the end of the standalone jargon-gloss pass.

**Execution:**

1. Read the post-gloss prose file at the input file path.

2. Present to the operator:
   - **Input file path used:** the input file's resolved path.
   - **Output file path:** same path (overwritten in place) + final word count.
   - **Jargon-gloss log path:** `{prose_output_dir}/gloss-additions-log.md` + summary (terms-glossed count, idempotent-skip count, sentence-split count).
   - **Bright-line items deferred for operator decision** (any unresolved items from the gloss phase).

3. Suggest next step:
   - **If the prose has not yet been through `/produce-formatting`:** "Run `/produce-formatting {arg}` to apply formatting polish."
   - **If formatting was already applied:** "Review the glossed output. Re-run `/produce-formatting {arg}` only if the gloss insertions disturbed formatting structure (rare)."
   - **If unresolved bright-line items:** "Resolve flagged items first (apply or discard per your decision), then proceed."
