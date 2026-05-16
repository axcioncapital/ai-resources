# Workspace Health Report

**Date:** 2026-05-16
**Mode:** Full Audit
**Target:** `projects/nordic-pe-macro-landscape-H1-2026`
**Overall:** RED

---

## Executive Summary

The Nordic PE Macro Landscape project is structurally mature and well-organized, with clean symlink integrity, a lean CLAUDE.md, comprehensive hook automation, and strong QC/subagent isolation practices throughout the pipeline. The single Critical finding — `context/prose-quality-standards.md` referenced by three pipeline commands but absent from disk — is the #1 issue to fix: without it, `produce-prose-draft`, `produce-formatting`, and `verify-chapter` will fail or produce degraded output at the phases that instruct subagents to read this file. One Important finding covers the project-local `knowledge-file-producer` skill missing `model:` and `effort:` frontmatter fields, and 20 project-specific commands using a frontmatter-header pattern not documented as an approved project norm.

## Scores

| Area | Score | Critical | Important | Minor |
|------|-------|----------|-----------|-------|
| File Organization | GREEN | 0 | 0 | 1 |
| CLAUDE.md Health | GREEN | 0 | 0 | 0 |
| Skill Inventory | YELLOW | 0 | 1 | 2 |
| Commands & Subagents | YELLOW | 0 | 1 | 1 |
| Settings & Permissions | GREEN | 0 | 0 | 1 |
| 2026 Best Practices | YELLOW | 0 | 0 | 2 |
| Context Health | RED | 1 | 0 | 1 |

## Findings

### Critical (Fix Now)

**[Context Health] context/prose-quality-standards.md missing from disk**

Three pipeline commands (`produce-prose-draft.md`, `produce-formatting.md`, `verify-chapter.md`) instruct subagents to read `context/prose-quality-standards.md` by absolute path before applying prose-writing and review skills. The `context/` directory does not exist at the project root. `stage-instructions.md` explicitly documents this as a legitimate exception to the content-passing rule (large read-only reference files may be passed by path to avoid duplicating ~1,200 lines across subagent briefs). The exception requires the file to exist — without it, these pipeline stages will fail or produce degraded output. The file is described in `produce-prose-draft.md` as "v3 (13 standards)" covering prose quality including Standards 10–13 added post-ship.

*Recommendation:* Create `context/prose-quality-standards.md` with the v3 writing standards. If the standards are documented in Notion or prior session notes, extract and materialize them on disk. Then create the `context/` directory structure.

### Important (Fix Soon)

**[Skill Inventory] knowledge-file-producer missing model: and effort: frontmatter**

The project-local skill `reference/skills/knowledge-file-producer/SKILL.md` (the only skill not symlinked from ai-resources) has `name` and `description` fields but is missing `model:` and `effort:`. Without `model:`, the skill inherits the session model instead of declaring its own tier. Without `effort:`, the effort budget is undefined.

*Recommendation:* Add `model: opus` and `effort: high` to the frontmatter (knowledge file production involves editorial judgment over large multi-chapter inputs, consistent with the opus/high tier).

**[Commands & Subagents] 20 project commands use frontmatter headers instead of Usage: lines**

All 20 project-specific real-file commands use YAML frontmatter (with `model:` field) rather than a `Usage:` line as the first meaningful content. This is a consistent, apparently intentional project pattern, but it is not documented in `CLAUDE.md` as an approved deviation from workspace convention. Future audits will continue flagging this.

*Recommendation:* Add a note to `CLAUDE.md` (under Workflow Overview or a new Commands section) stating that project pipeline commands use YAML frontmatter headers. This locks the pattern as intentional.

### Improvement Opportunities

- **[File Organization]** `knowledge-file-producer` is a real directory rather than a symlink to ai-resources. If this skill is generalizable beyond this project, graduate it to ai-resources and replace with a symlink.
- **[Skill Inventory]** 7 skills exceed 300 lines (advisory threshold): `ai-resource-builder` (415), `answer-spec-generator` (487), `research-plan-creator` (466), `evidence-to-report-writer` (334), `workflow-evaluator` (318), `ai-prose-decontamination` (316), `workflow-system-critic` (302). None exceed 500 lines. Changes require editing in ai-resources.
- **[Skill Inventory]** Trigger overlap between closely related QC skill pairs (`answer-spec-qc`/`research-prompt-qc`, `formatting-qc`/`document-integration-qc`) is expected given their similar domains. The strong exclusion language in description fields adequately differentiates routing.
- **[Settings & Permissions]** `Read(archive/**)` in the deny list references a non-existent `archive/` directory. Harmless but represents a stale entry — remove if no archive directory is planned.
- **[2026 Best Practices]** The context isolation exception (passing large read-only reference files by path) is well-documented in `stage-instructions.md`. Periodically verify no new commands add path-passing outside this documented exception.
- **[Context Health]** Last 10 commits are all auto-committed report chapters. No infrastructure changes in scope — no downstream reference tracing needed.

---

## Detailed Analysis

### File Organization

File organization is healthy. All 81 symlinks (25 agent symlinks + 56 command symlinks) resolve correctly to their `ai-resources` targets. All 68 skill symlinks in `reference/skills/` point to valid `ai-resources/skills/{name}/SKILL.md` files. The single CLAUDE.md is at the project root as expected. The `.claude/` directory contains `commands/`, `agents/`, `hooks/`, `settings.json`, `settings.local.json`, and `shared-manifest.json`.

The one minor structural anomaly: `reference/skills/knowledge-file-producer/` is a real directory (not a symlink), indicating a project-local skill not yet graduated to the shared library. The `shared-manifest.json` correctly omits this from its symlink management scope, so it will not be affected by auto-sync.

### CLAUDE.md Health

The project CLAUDE.md is 60 lines (~864 estimated tokens) — well within all thresholds (Important at >200 lines / >4,000 tokens; Critical at >400 lines / >8,000 tokens). It has a clear orientation section ("Project Context") at the top. No `@import` references are used; the file is appropriately lean and delegates detail to `reference/stage-instructions.md` and other reference files. No secrets patterns detected. No contradictions with workspace-level CLAUDE.md rules (project adds workflow-specific gate rules that complement rather than contradict workspace defaults).

### Skill Inventory

69 skills in scope (68 ai-resources symlinks + 1 project-local). All have `name` and `description` fields. All symlinked skills have `model:` and `effort:` declared. Only the project-local `knowledge-file-producer` is missing these fields. Average skill length is approximately 221 lines; no skill exceeds 500 lines. Trigger overlap between skill pairs is within acceptable bounds given strong exclusion language in all description fields. No orphaned skills found — all skills are referenced from pipeline commands or shared commands.

### Commands & Subagents

74 total commands (54 symlinks to ai-resources, 20 project-specific real files). 29 total agents (25 symlinks to ai-resources, 4 project-local). All symlinks resolve cleanly. All 4 project-local agents (`execution-agent`, `improvement-analyst`, `qc-gate`, `verification-agent`) have required `name`, `description`, `tools`, and `model` frontmatter fields. All 4 are referenced by commands that exist and resolve. No dead skill references from commands — all `/ai-resources/skills/` paths referenced in pipeline commands resolve to existing SKILL.md files. The `produce-knowledge-file.md` command references `knowledge-file-producer` via `/reference/skills/knowledge-file-producer/SKILL.md` (project-local path) which also resolves correctly.

### Settings & Permissions

Both settings files are valid JSON. `settings.json` has a comprehensive permission structure: 20 allow entries, 8 deny entries, and an extensive hooks section covering PreToolUse, PostToolUse, SessionStart, Stop, and UserPromptSubmit. All 12 hook scripts referenced in `settings.json` exist and are executable. `settings.local.json` correctly sets `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1` for this analytical project. The `bypassPermissions` default mode with targeted deny entries is the agreed workspace setup. The `additionalDirectories` entry for the workspace root is expected for cross-project skill file reads. The one minor finding: `Read(archive/**)` in the deny list references a non-existent `archive/` directory — harmless but stale.

### 2026 Best Practices

The project demonstrates high workflow maturity across multiple dimensions:

- **QC isolation:** QC runs through the `qc-gate` subagent with fresh context across all pipeline stage commands (`run-cluster`, `run-analysis`, `review-chapter`, `produce-prose-draft`, `run-execution`). Not inline in the main session.
- **Context isolation:** `stage-instructions.md` explicitly documents the content-passing rule and its narrow exception for large read-only reference files. Exception is correctly applied in commands.
- **Filesystem verification:** `cleanup-worktree.md` explicitly states "post-commit verification from the filesystem (not git status or git diff)." `git status` appears in context-inspection roles only (not as output verification).
- **Model assignments:** All subagent models are appropriate to task complexity. `workflow-system-analyzer` uses `haiku` for structural analysis — appropriate. Opus used for judgment-intensive tasks.
- **Session management:** SessionStart loads checkpoint state, Stop hooks enforce session-wrap and checkpoint reminders. Friction logging is automated via hook.

The gap identified by the practices auditor — that the frontmatter-header command pattern is not documented — is an Important finding in Commands & Subagents.

### Context Health

Cross-reference integrity is sound for all infrastructure (hooks, agent definitions, skill references). The single Critical finding is the missing `context/prose-quality-standards.md` file. This file is referenced in three commands and explicitly documented as a legitimate exception to content-passing in `stage-instructions.md`, but the file itself does not exist. This is a runtime blocker for the produce-prose-draft → produce-formatting → verify-chapter pipeline sequence.

All 14 hook scripts resolve and are executable. All 15 checked pipeline skill references resolve to valid files. The `execution-agent` is referenced by `verify-chapter.md` and exists as a project-local agent. No CLAUDE.md-to-skill references were found (CLAUDE.md delegates to stage-instructions rather than directly naming skills). No high-impact file changes in the last 10 commits — the project is in late-stage production with report chapter auto-commits only.

---

## Prioritized Recommendations

1. **[Critical] Create `context/prose-quality-standards.md`** — Materialize the v3 prose quality standards (13 standards) on disk. This unblocks `produce-prose-draft`, `produce-formatting`, and `verify-chapter`. Without it, the pipeline prose stages are broken.

2. **[Important] Add `model: opus` / `effort: high` to `knowledge-file-producer` SKILL.md** — Two-line fix; eliminates the frontmatter gap for the project-local skill.

3. **[Important] Document the frontmatter-header command pattern in CLAUDE.md** — Add a line under Workflow Overview noting that project pipeline commands use YAML frontmatter headers instead of `Usage:` lines. Prevents recurring audit flags.

4. **[Minor] Consider graduating `knowledge-file-producer` to ai-resources** — If the skill has value beyond this project, promote it to the shared library and replace the project directory with a symlink. Alternatively, document it as intentionally project-local.

5. **[Minor] Remove stale `Read(archive/**)` from settings.json deny list** — One-entry cleanup. Only needed if no `archive/` directory is planned.

---

*Generated by repo-health-analyzer v2 (sequential mode). Auditors: 7 run, 0 skipped.*
