---
friction-log: true
model: opus
---
Apply jargon-gloss pass to an existing prose draft: $ARGUMENTS

> **Dual-copy sync contract.** This file is one of two near-identical wrappers (canonical + project copy, not symlinked). When editing, diff against the companion at `projects/{project}/.claude/commands/produce-jargon-gloss.md` (or `ai-resources/workflows/research-workflow/.claude/commands/produce-jargon-gloss.md` if editing a project copy) and propagate changes to the other. Same convention as `/produce-prose-draft` and `/produce-formatting` per project CLAUDE.md.

Runs only the jargon-gloss phase against an existing prose-draft file on disk. Standalone wrapper around the `jargon-gloss` skill. Use when a prose draft has already been produced (via `/produce-prose-draft` or otherwise) and needs first-mention gloss insertion for undefined domain-specific terms — without re-running the full prose-draft pipeline.

> **Reversibility note.** The pass overwrites the prose file in place. Before invoking on a prose file with uncommitted changes, commit (or stash) the current state so the pre-gloss version is recoverable via git.

Per-section run: 1 subagent launch, target ~3–5 min wall time.

**When to use:**
- A prose draft was produced before the gloss phase existed in `/produce-prose-draft` and needs the treatment retroactively.
- A new term or regulation has been introduced into existing prose and a fresh gloss pass is needed.
- The gloss pass needs to be re-run after manual edits to the whitelist or skill.

**Stage 5 placement:** sits alongside `/produce-prose-draft` Phase 6 (or Phase 4 in adapted pipelines). Identical behavior, isolated invocation. After this command runs, the standard next step is `/produce-formatting` if not already run.

---

## Phase 1 — Plan (main session)

Keep this phase lightweight. Do NOT read source files yet.

1. Parse $ARGUMENTS as a section or report identifier matching the convention of the calling project. Two common forms:
   - **Generic section identifier** (e.g., `2.4`, `3.1`): used in document-section pipelines.
   - **Report identifier** (e.g., `r1`, `r2`, `r3`): used in report-based pipelines. Case-insensitive; map to `R{N}`.
   Reject any other value with a one-line error.

2. Locate the existing prose file. Detection order:
   - Look first under the prose output directory for the calling project. Common patterns: `output/part-{N}-prose/{section}-*.md`, `report/produced/{section}/R{N}/R{N}-prosed.md`, or `{prose_output_dir}/{section}-prosed.md`.
   - **Multi-match resolution.** If the detection glob returns more than one prose file (e.g., multiple iterations of the same section), select by this order: (a) the file with the highest version suffix if a `-v{N}` convention is in use, otherwise (b) the file with the most recent modification time (`mtime`). Report the file selected and the count of files considered to the operator in Phase 1's plan summary. If the multi-match resolution looks ambiguous or two files have the same mtime, PAUSE and ask the operator to confirm the target file.
   - If no prose file is found at the expected location, PAUSE: "No prose draft found for {arg}. Run `/produce-prose-draft {arg}` first, or pass an explicit path."

3. Determine paths:
   - `prose_file_path` = the located prose file
   - `prose_output_dir` = directory containing the prose file
   - Style reference: detect at the project-standard location (e.g., `{prose_output_dir}/style-reference.md` or `report/style-reference/{section}/{section}-style-reference.md`). If absent, note in the change log header — the skill is non-blocking on style reference.

4. Check whether a previous `gloss-additions-log.md` exists at `{prose_output_dir}/gloss-additions-log.md`. If so, note it — the new pass produces a fresh log, overwriting the previous one. The previous log is logged by name in the new run's header so the operator can recover it from git if needed.

Present the plan: prose file path, style reference path (or note absent), change-log path, expected overwrite behavior. Wait for operator approval before proceeding.

---

## Phase 2 — Jargon Gloss [delegate, sonnet]

Detects undefined domain-specific terms on first mention and inserts short parenthetical glosses (5–15 words) in place. Standard PE/finance vocabulary is whitelisted. Voice and rhythm of the input prose are preserved.

0. **Path setup.** Determine the absolute project-root path (the CWD at invocation) and cache it as `project_root_abs`. Resolve `prose_file_path_abs = {project_root_abs}/{prose_file_path}` and `prose_output_dir_abs = {project_root_abs}/{prose_output_dir}`. If unsure of the absolute root, run `pwd` once and cache the result.

1. Read the prose file identified in Phase 1.

2. Read `/ai-resources/skills/jargon-gloss/SKILL.md`.

3. Launch a general-purpose sub-agent with `model: "sonnet"` (pattern-based detection against an explicit whitelist + category list; analytical judgment not required — this overrides the skill's declared opus tier; command-layer authority per workspace CLAUDE.md). Pass it:
   - The skill content
   - The prose file content
   - The style reference absolute path (if found in Phase 1) — subagent reads this file before applying the skill (used for voice alignment of gloss phrasing). If no style reference is available, the subagent proceeds with neutral analytical phrasing per the skill's default.
   - Output path: `prose_file_path_abs` — same file (explicit overwrite; this command owns the file-versioning contract; the skill's standalone default does not apply here).
   - Change log output path: `{prose_output_dir_abs}/gloss-additions-log.md`
   - Task: **First, read the style reference at the provided absolute path if available.** Then execute the jargon-gloss pass per the skill logic. Detect first-mention occurrences of undefined domain-specific terms across the document; check each against the PE Vocabulary Whitelist; apply the standard gloss format `Term (5–15 word definition)` on the first mention only; apply the sentence-split rule when a glossed sentence would exceed 35 words; preserve idempotency where the source prose already contains a definition. Write the glossed prose file (overwriting the input). Write the change log to the log output path. Return: terms-glossed count, idempotent-skip count, sentence-split count, bright-line flags count, and a brief summary of any constrained passages.
   - **Bright-line rule override:** The gloss pass is exempt from the multi-paragraph scope check (bright-line check 1) because first-mention detection requires document-wide scanning by design. Checks 2 and 3 still apply: if applying a gloss would alter an analytical claim or modify a sourced statement (e.g., inside a quote), the sub-agent must flag it in the bright-line-flags section of the change log and must NOT apply that change. If bright-line flags are populated, the main agent PAUSEs for operator approval before proceeding.

4. Route on result:
   - **Zero bright-line flags:** Proceed to Phase 3 (handoff) automatically.
   - **Bright-line flags present:** PAUSE — present flags to the operator. Apply or discard per operator decision, then proceed to Phase 3.
   - **Zero terms glossed:** Note "Prose already accessible — no gloss insertions needed." Proceed to Phase 3.

5. Write Phase 2 handoff note: terms-glossed count, idempotent-skip count, sentence-split count, any bright-line flags and their disposition.

6. ▸ /compact — skill content no longer needed.

---

## Phase 3 — Handoff (main session)

1. Read the post-gloss prose file at `prose_file_path`.

2. Present to the operator:
   - **Input file path used:** `prose_file_path`
   - **Output file path:** `prose_file_path` (overwritten in place) + final word count
   - **Jargon-gloss log path:** `{prose_output_dir}/gloss-additions-log.md` + summary (terms-glossed count, idempotent-skip count, sentence-split count)
   - **Bright-line items deferred for operator decision** (any unresolved items from Phase 2)

3. Suggest next step:
   - **If the prose has not yet been through `/produce-formatting`:** "Run `/produce-formatting {arg}` to apply formatting polish."
   - **If formatting was already applied:** "Review the glossed output. Re-run `/produce-formatting {arg}` only if the gloss insertions disturbed formatting structure (rare)."
   - **If unresolved bright-line items:** "Resolve flagged items first (apply or discard per your decision), then proceed."
