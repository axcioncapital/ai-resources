---
friction-log: true
model: opus
---
Apply jargon-gloss pass to an existing prose draft: $ARGUMENTS

> **Path A parameterized.** This canonical command reads project paths from `reference/stage-5-paths.md` (instantiated per project from `ai-resources/workflows/research-workflow/reference/stage-5-paths.template.md`) and dispatches on `Document model:` declared in the project's `## Project Config`. See `plans/fx-b1-path-a-design-v3.md` and `docs/project-config-schema.md § Default-value semantics for Document model`.

Runs only the jargon-gloss phase against an existing prose-draft file on disk. Standalone wrapper around the `jargon-gloss` skill. Use when a prose draft has already been produced (via `/produce-prose-draft` or otherwise) and needs first-mention gloss insertion for undefined domain-specific terms — without re-running the full prose-draft pipeline.

> **Reversibility note.** The pass overwrites the prose file in place. Before invoking on a prose file with uncommitted changes, commit (or stash) the current state so the pre-gloss version is recoverable via git.

Per-section run: 1 subagent launch, target ~3–5 min wall time.

**When to use:**
- A prose draft was produced before the gloss phase existed in `/produce-prose-draft` and needs the treatment retroactively.
- A new term or regulation has been introduced into existing prose and a fresh gloss pass is needed.
- The gloss pass needs to be re-run after manual edits to the whitelist or skill.

**Stage 5 placement:** sits alongside `/produce-prose-draft`'s jargon-gloss phase. Identical behavior, isolated invocation. After this command runs, the standard next step is `/produce-formatting` if not already run.

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

4. **Verify mode match.** Locate the `Mode:` line in `reference/stage-5-paths.md`.
   - If absent: halt — `reference/stage-5-paths.md is missing the Mode: line. See ai-resources/workflows/research-workflow/reference/stage-5-paths.template.md.`
   - If value does not match `Document model`: halt — `Mode mismatch: Project Config declares '<X>', reference/stage-5-paths.md declares '<Y>'. Resolve before invoking.`

5. **Parse path-config.** Read the `## Stage 5 Path Roots` block. Cache the resolved path values (per-mode schema in `stage-5-paths.template.md`) for use in Phase 1. Interpolate placeholders: `{section}`, `{report}`, `{N}` (report-mode) or `{section}`, `{part}` (section-mode).

---

## Phase 1 — Plan (main session)

Keep this phase lightweight. Do NOT read source files yet.

1. **`prose_file_path`** — resolved from the path-config + parsed arg.
   - report-mode: `<prose_output_root>/<prose_output_filename>` (e.g., `report/produced/{section}/R{N}/R{N}-prosed.md`).
   - section-mode: glob `<prose_output_root>/<prose_output_filename_glob>` (e.g., `output/part-{part}-prose/{section}-*.md`). Multi-match resolution per the path-config's `Source filename multi-match selector` (e.g., `highest-numeric-suffix` or `most-recent-mtime`). If multi-match looks ambiguous, PAUSE and ask the operator to confirm the target file.

2. **`prose_output_dir`** — the directory containing `prose_file_path`. Used as the base for log paths.

3. **Style reference** — resolved from the path-config's `Style-reference path` (report-mode) or `Style-reference filename` relative to `prose_output_dir` (section-mode). If absent, note in the change log header — the skill is non-blocking on style reference.

4. **Check whether a previous `gloss-additions-log.md` exists** at `<prose_output_dir>/<gloss-log-filename>`. If so, note it — the new pass produces a fresh log, overwriting the previous one. The previous log is recoverable from git if needed.

5. If `prose_file_path` does not exist: PAUSE — `No prose draft found for {arg}. Run /produce-prose-draft {arg} first, or pass an explicit path.`

Present the plan: prose file path, style reference path (or note absent), change-log path, expected overwrite behavior. Wait for operator approval before proceeding.

---

## Phase 2 — Jargon Gloss

See `reference/stage-5-common-phases.md` anchor `phase-jargon-gloss` for the full phase definition.

**Mode-vars for this invocation:**
- `{PHASE_NUMBER}`: 2
- `{NEXT_PHASE}`: Phase 3 (handoff)
- `{prose_output_dir}`: resolved in Phase 0 + Phase 1

---

## Phase 3 — Handoff (main session)

See `reference/stage-5-common-phases.md` anchor `phase-handoff-jargon-gloss` for the full handoff definition.

**Mode-vars for this invocation:**
- `{arg}`: the validated arg from Phase 0 (`r1`/`r2`/`r3` for report-mode; `2.4`/`3.1` etc. for section-mode).
