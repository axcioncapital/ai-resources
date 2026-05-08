# Repo Due Diligence Audit — 2026-05-08
Repo: projects/global-macro-analysis
Scope: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/global-macro-analysis
Commit: 52806c9
Previous audit: 2026-05-05
Depth: standard

---

## Section 1: Inventory

### 1.1 Slash Commands

As of this audit, 52 command files exist in `.claude/commands/`: 13 local kb-* commands (regular files) and 39 symlinks (34 to ai-resources, 4 to ai-resources added since previous audit, 1 to axcion-ai-system-owner). The previous audit counted 35 commands total; the current count is 52 (+17).

**New symlinks added since 2026-05-05 (committed 2026-05-05 in d8a2967 + 2026-05-06 in untracked group):**
- 12 new ai-resources symlinks via commit d8a2967 (2026-05-05): `resolve.md`, `resolve-improvement-log.md`, `project-consultant.md`, `session-plan.md`, `recommend.md`, `risk-check.md`, `audit-claude-md.md`, `audit-critical-resources.md`, `permission-sweep.md`, `token-audit.md`, `innovation-sweep.md`, `graduate-resource.md`
- 5 new ai-resources symlinks present but **untracked in git** (filesystem date 2026-05-06): `friday-so.md`, `so-monthly.md`, `systems-review.md`, `architecture-review.md`, `implementation-triage.md`

| Command | Defined In | Referenced Files |
|---------|-----------|-----------------|
| `/analyze-workflow` | symlink → ai-resources/.claude/commands/analyze-workflow.md | workflow-analysis-agent, workflow-critique-agent |
| `/architecture-review` | symlink → ai-resources/.claude/commands/architecture-review.md (UNTRACKED) | architecture-review agent |
| `/audit-claude-md` | symlink → ai-resources/.claude/commands/audit-claude-md.md | claude-md-auditor agent |
| `/audit-critical-resources` | symlink → ai-resources/.claude/commands/audit-critical-resources.md | critical-resource-auditor agent |
| `/audit-repo` | symlink → ai-resources/.claude/commands/audit-repo.md | repo-health-analyzer skill |
| `/clarify` | symlink → ai-resources/.claude/commands/clarify.md | none explicit |
| `/coach` | symlink → ai-resources/.claude/commands/coach.md | collaboration-coach agent, logs/coaching-data.md |
| `/consult` | symlink → projects/axcion-ai-system-owner/.claude/commands/consult.md | system-owner agent |
| `/create-skill` | symlink → ai-resources/.claude/commands/create-skill.md | ai-resource-builder skill |
| `/friction-log` | symlink → ai-resources/.claude/commands/friction-log.md | logs/friction-log.md |
| `/friday-so` | symlink → ai-resources/.claude/commands/friday-so.md (UNTRACKED) | system-owner-related agents |
| `/graduate-resource` | symlink → ai-resources/.claude/commands/graduate-resource.md | ai-resources repo |
| `/implementation-triage` | symlink → ai-resources/.claude/commands/implementation-triage.md (UNTRACKED) | none explicit |
| `/improve-skill` | symlink → ai-resources/.claude/commands/improve-skill.md | ai-resource-builder skill |
| `/improve` | symlink → ai-resources/.claude/commands/improve.md | improvement-analyst agent, logs/friction-log.md, logs/improvement-log.md, logs/improvement-log-archive.md |
| `/innovation-sweep` | symlink → ai-resources/.claude/commands/innovation-sweep.md | innovation-triage-auditor agent |
| `/kb-audit` | local: .claude/commands/kb-audit.md | macro-kb/ (all), macro-kb/_meta/audit-report.md (write) |
| `/kb-cross-theme` | local: .claude/commands/kb-cross-theme.md | macro-kb/*/`_theme-file.md`, macro-kb/*/`_synthesis.md` |
| `/kb-gap-audit` | local: .claude/commands/kb-gap-audit.md | macro-kb/_sources/registry.md, macro-kb/*/`_theme-file.md`, macro-kb/*/`_synthesis.md` |
| `/kb-ingest` | local: .claude/commands/kb-ingest.md | macro-kb/_inbox/, macro-kb/_meta/taxonomy.md, skills/intake-processor/SKILL.md, macro-kb/_meta/confidence-rubric.md |
| `/kb-populate` | local: .claude/commands/kb-populate.md | macro-kb/_meta/taxonomy.md, theme synthesis + entries, macro-kb/_meta/templates/atomic-entry-template.md, web |
| `/kb-query` | local: .claude/commands/kb-query.md | macro-kb/_meta/index.json, macro-kb/_meta/taxonomy.md, macro-kb/*/`_synthesis.md`, atomic entries |
| `/kb-registry-query` | local: .claude/commands/kb-registry-query.md | macro-kb/_sources/registry.md |
| `/kb-reindex` | local: .claude/commands/kb-reindex.md | all theme folders (reads), macro-kb/_meta/index.json (write) |
| `/kb-review` | local: .claude/commands/kb-review.md | macro-kb/_staging/, theme folders, macro-kb/_meta/index.json, macro-kb/_meta/changelog.md, macro-kb/_meta/changelog.json |
| `/kb-stale` | local: .claude/commands/kb-stale.md | macro-kb/_meta/index.json, macro-kb/*/`_synthesis.md` |
| `/kb-synthesize` | local: .claude/commands/kb-synthesize.md | theme folder entries, macro-kb/*/`_history/`, macro-kb/_meta/taxonomy.md, macro-kb/_meta/index.json, macro-kb/_meta/prompts/synthesis-prompt.md |
| `/kb-theme-health` | local: .claude/commands/kb-theme-health.md | macro-kb/*/`_theme-file.md` |
| `/kb-triage-stats` | local: .claude/commands/kb-triage-stats.md | macro-kb/_sources/registry.md |
| `/migrate-skill` | symlink → ai-resources/.claude/commands/migrate-skill.md | ai-resource-builder skill |
| `/note` | symlink → ai-resources/.claude/commands/note.md | logs/friction-log.md (friction: prefix routing) |
| `/permission-sweep` | symlink → ai-resources/.claude/commands/permission-sweep.md | permission-sweep-auditor agent |
| `/prime` | symlink → ai-resources/.claude/commands/prime.md | logs/session-notes.md, logs/innovation-registry.md, ai-resources/inbox/, logs/decisions.md |
| `/project-consultant` | symlink → ai-resources/.claude/commands/project-consultant.md | none explicit |
| `/qc-pass` | symlink → ai-resources/.claude/commands/qc-pass.md | qc-reviewer agent |
| `/recommend` | symlink → ai-resources/.claude/commands/recommend.md | none explicit |
| `/refinement-deep` | symlink → ai-resources/.claude/commands/refinement-deep.md | refinement-reviewer agent |
| `/refinement-pass` | symlink → ai-resources/.claude/commands/refinement-pass.md | refinement-reviewer agent |
| `/repo-dd` | symlink → ai-resources/.claude/commands/repo-dd.md | repo-dd-auditor agent, ai-resources/audits/ |
| `/request-skill` | symlink → ai-resources/.claude/commands/request-skill.md | ai-resources/inbox/ |
| `/resolve` | symlink → ai-resources/.claude/commands/resolve.md | none explicit |
| `/resolve-improvement-log` | symlink → ai-resources/.claude/commands/resolve-improvement-log.md | logs/improvement-log.md |
| `/risk-check` | symlink → ai-resources/.claude/commands/risk-check.md | risk-check-reviewer agent |
| `/scope` | symlink → ai-resources/.claude/commands/scope.md | none explicit |
| `/session-plan` | symlink → ai-resources/.claude/commands/session-plan.md | logs/session-plan.md |
| `/so-monthly` | symlink → ai-resources/.claude/commands/so-monthly.md (UNTRACKED) | system-owner-related agents |
| `/systems-review` | symlink → ai-resources/.claude/commands/systems-review.md (UNTRACKED) | none explicit |
| `/token-audit` | symlink → ai-resources/.claude/commands/token-audit.md | token-audit-auditor agent, token-audit-auditor-mechanical agent |
| `/triage` | symlink → ai-resources/.claude/commands/triage.md | triage-reviewer agent |
| `/update-claude-md` | symlink → ai-resources/.claude/commands/update-claude-md.md | CLAUDE.md |
| `/usage-analysis` | symlink → ai-resources/.claude/commands/usage-analysis.md | ai-resources/skills/session-usage-analyzer/SKILL.md, logs/usage-log.md |
| `/wrap-session` | symlink → ai-resources/.claude/commands/wrap-session.md | logs/session-notes.md, logs/decisions.md, logs/coaching-data.md, logs/improvement-log.md, logs/improvement-log-archive.md, logs/innovation-registry.md, logs/usage-log.md, logs/scripts/check-archive.sh, logs/scripts/split-log.sh, logs/friction-log.md |

DELTA: Command count increased from 35 to 52 (+17). 12 new symlinks committed 2026-05-05 (d8a2967). 5 new symlinks present on filesystem but untracked in git (filesystem mtime 2026-05-06): `friday-so.md`, `so-monthly.md`, `systems-review.md`, `architecture-review.md`, `implementation-triage.md`.

Section summary: 52 commands catalogued / 17 added since previous audit

---

### 1.2 Hooks

Hooks are unchanged since previous audit. Defined in `.claude/settings.json`. No hooks in `.claude/settings.local.json` (contains only `{}`).

| Hook | Trigger | What It Does | Files Referenced |
|------|---------|-------------|-----------------|
| Write guard | PreToolUse on `Write` | Intercepts Write calls targeting `macro-kb/[a-z]*` paths not under `_staging/`, `_inbox/`, `_meta/`, `_sources/`, or `_decisions/`. If matched, returns `{"decision":"ask"}` enforcing Hard Rule 1 & 3. | None (inline shell via jq) |
| Edit guard | PreToolUse on `Edit` | Intercepts Edit calls targeting `macro-kb/[a-z]*` paths not under `_staging/`, `_inbox/`, `_meta/`, `_sources/`, or `_decisions/`. If matched, returns `{"decision":"ask"}` enforcing Hard Rule 3. | None (inline shell via jq) |

DELTA: No changes to hooks since 2026-05-05.

Section summary: 2 hooks catalogued / 0 deltas since previous audit

---

### 1.3 Template Files

All 12 templates from the previous audit remain unchanged. Template last commit dates remain 2026-04-11 for all 12 files.

| File Path | Purpose | Used By | Last Commit Date |
|-----------|---------|---------|-----------------|
| macro-kb/_meta/templates/atomic-entry-template.md (40 lines) | YAML frontmatter + body structure for atomic entries | /kb-ingest, /kb-populate | 2026-04-11 |
| macro-kb/_meta/templates/batch-manifest-schema.yaml (56 lines) | Schema for staging batch manifest files | /kb-ingest | 2026-04-11 |
| macro-kb/_meta/templates/changelog-format.md (44 lines) | Format for human-readable changelog entries | /kb-review | 2026-04-11 |
| macro-kb/_meta/templates/decision-memo-template.md (39 lines) | Structure for decision memos in _decisions/ | Operator-used reference | 2026-04-11 |
| macro-kb/_meta/templates/index-schema.json (15 lines) | Schema for index.json structure | /kb-reindex (implicit) | 2026-04-11 |
| macro-kb/_meta/templates/source-registry-template.md (26 lines) | Per-author entry format for registry.md | Operator-used reference | 2026-04-11 |
| macro-kb/_meta/templates/synthesis-template.md (68 lines) | Structure for _synthesis.md files | /kb-synthesize (via synthesis-prompt.md) | 2026-04-11 |
| macro-kb/_meta/templates/theme-file-template.md (85 lines) | Structure for _theme-file.md per theme | /kb-theme-health, /kb-cross-theme, /kb-gap-audit | 2026-04-11 |
| macro-kb/_meta/templates/processing-workflow/conversation-template.md (32 lines) | NotebookLM conversation guide | Operator-used outside Claude Code | 2026-04-11 |
| macro-kb/_meta/templates/processing-workflow/priming-template.md (19 lines) | NotebookLM priming template | Operator-used outside Claude Code | 2026-04-11 |
| macro-kb/_meta/templates/processing-workflow/substance-extraction-checkpoint.md (30 lines) | Checkpoint template for research processing | Operator-used outside Claude Code | 2026-04-11 |
| macro-kb/_meta/templates/processing-workflow/triage-tiers.md (51 lines) | Source triage tier definitions | Operator-used outside Claude Code | 2026-04-11 |

DELTA: No changes to template files since 2026-05-05.

Section summary: 12 template files catalogued / 0 deltas since previous audit

---

### 1.4 Scripts

Scripts are unchanged since previous audit.

| File Path | What It Does | What Calls It |
|-----------|-------------|--------------|
| logs/scripts/check-archive.sh (53 lines) | Iterates session-notes.md and decisions.md; archives files exceeding line thresholds by calling split-log.sh. With `--warn-only`, emits a JSON systemMessage if files exceed 1.5x threshold. | /wrap-session (Step 11) |
| logs/scripts/split-log.sh (82 lines) | Splits an append-only log at `## ` header boundaries; archives older portion to a dated file; rewrites active file with kept entries and archive pointer. | check-archive.sh |

DELTA: No changes to scripts since 2026-05-05.

Section summary: 2 scripts catalogued / 0 deltas since previous audit

---

### 1.5 Skills

3 skills present in `skills/`, all as symlinks to ai-resources. Unchanged since previous audit.

| Skill | Path | Has SKILL.md | Structure |
|-------|------|-------------|-----------|
| intake-processor | skills/intake-processor → ai-resources/skills/intake-processor | YES | SKILL.md only |
| repo-health-analyzer | skills/repo-health-analyzer → ai-resources/skills/repo-health-analyzer | YES | SKILL.md + agents/ + command.md |
| ai-resource-builder | skills/ai-resource-builder → ai-resources/skills/ai-resource-builder | YES | SKILL.md + references/ |

DELTA: No changes to skills since 2026-05-05.

Section summary: 3 skills catalogued / 0 deltas since previous audit

---

### 1.6 Uncategorized Items

| File/Directory | Category Note |
|---------------|--------------|
| .DS_Store (repo root) | macOS filesystem artifact, not gitignored from project root |
| macro-kb/.DS_Store | macOS filesystem artifact within macro-kb |
| macro-kb/food-security/.DS_Store | macOS filesystem artifact within theme folder |
| pipeline/ directory (11 files + source-docs/ subdirectory) | Project construction artifacts — architecture, implementation spec, session guides, test results, source docs. Not referenced by CLAUDE.md, any command, or hook. |
| reports/ directory | Not found at project root as of this audit — directory referenced in previous audit but not present now. The single prior output, `reports/repo-health-report.md`, appears to have been part of pipeline artifacts. |
| macro-kb/_decisions/ (5 files) | Decision memos — 5 files, all unpopulated stubs. Referenced in CLAUDE.md Key File Paths section. |
| macro-kb/_meta/docs/ (4 new files, 787 total lines) | New subdirectory added since previous audit: `report-layer-spec.md` (166 lines, added 2026-05-05), `book-transcript-ingestion.md` (190 lines, added 2026-05-06), `pointer-source-ingestion.md` (186 lines, added 2026-05-06), `transcript-claim-miner-gpt-spec.md` (245 lines, added 2026-05-07). Referenced by CLAUDE.md (report-layer-spec.md). Not yet referenced by any active slash command. |
| macro-kb/.obsidian/ (4 files) | Obsidian vault configuration directory: app.json, appearance.json, core-plugins.json, workspace.json. Committed 2026-04-29. Not referenced by CLAUDE.md or any command. |
| macro-kb/_meta/audit-report.md | Generated by /kb-audit; now populated (was absent in previous audit). Last run 2026-05-06. |
| macro-kb/_meta/changelog.md (532 lines) | Active changelog with entries from system use (was stub in previous audit — 3 lines). |
| macro-kb/_meta/changelog.json (398 lines) | Active JSON changelog (was empty `[]` in previous audit). |
| macro-kb/_meta/index.json (2475 lines) | Populated index (was empty `[]` in previous audit). |
| macro-kb/_sources/registry.md (47 lines) | Registry with registered authors (was header-only in previous audit). |
| macro-kb/_inbox/ (5 files) | 5 transcript files added 2026-05-07, awaiting ingestion. |
| macro-kb/_staging/ (57 files) | 57 files: 25 manifest .yaml files (batches 2026-05-05 through 2026-05-07) and 32 entry .md files from kb-populate runs. System is actively staging entries. |
| 43 theme folders | 23 themes now have atomic entries (169 total entry .md files across those themes); 20 themes remain empty. 21 themes have _synthesis.md files. 27 _history/ archive files exist across 11 themes. No theme has a _theme-file.md. |
| logs/cadence-metrics.md | New file tracking cadence metrics. Not referenced by any command. Last commit 2026-05-05. |
| logs/next-up.md (39 lines) | Queue management file. Not referenced by any command. Last commit 2026-05-05. |
| logs/session-plan.md (28 lines) | Session plan document. Referenced by /session-plan command. Last commit 2026-05-07. |
| logs/session-notes-archive-2026-04.md (261 lines) | Archive of April session notes. Created by split-log.sh. |
| logs/session-notes-archive-2026-05.md (579 lines) | Archive of May session notes. Created by split-log.sh. |
| logs/coaching-log.md | Present on filesystem, untracked in git. |

DELTA: Significant change in system state since 2026-05-05: system transitioned from pre-use (empty) to active. 169 atomic entries now exist across 23 themes. 21 synthesis files generated. Index, changelog, and audit-report now populated. 5 new untracked command symlinks. 4 new docs in macro-kb/_meta/docs/. 5 inbox transcripts pending. 57 staging files queued. New logs: cadence-metrics.md, next-up.md, session-plan.md, coaching-log.md (untracked), two session-notes archives.

Section summary: 24 uncategorized item groups catalogued / 8 deltas from previous audit

---

### 1.7 Symlinks

**Commands — 34 symlinks to ai-resources (committed):**

All 22 original ai-resources command symlinks from previous audit remain in place and accessible. 12 new committed symlinks added 2026-05-05 (d8a2967):

| Symlink Path | Target | Accessible |
|-------------|--------|-----------|
| .claude/commands/resolve.md | ../../../../ai-resources/.claude/commands/resolve.md | YES |
| .claude/commands/resolve-improvement-log.md | ../../../../ai-resources/.claude/commands/resolve-improvement-log.md | YES |
| .claude/commands/project-consultant.md | ../../../../ai-resources/.claude/commands/project-consultant.md | YES |
| .claude/commands/session-plan.md | ../../../../ai-resources/.claude/commands/session-plan.md | YES |
| .claude/commands/recommend.md | ../../../../ai-resources/.claude/commands/recommend.md | YES |
| .claude/commands/risk-check.md | ../../../../ai-resources/.claude/commands/risk-check.md | YES |
| .claude/commands/audit-claude-md.md | ../../../../ai-resources/.claude/commands/audit-claude-md.md | YES |
| .claude/commands/audit-critical-resources.md | ../../../../ai-resources/.claude/commands/audit-critical-resources.md | YES |
| .claude/commands/permission-sweep.md | ../../../../ai-resources/.claude/commands/permission-sweep.md | YES |
| .claude/commands/token-audit.md | ../../../../ai-resources/.claude/commands/token-audit.md | YES |
| .claude/commands/innovation-sweep.md | ../../../../ai-resources/.claude/commands/innovation-sweep.md | YES |
| .claude/commands/graduate-resource.md | ../../../../ai-resources/.claude/commands/graduate-resource.md | YES |

**Commands — 5 symlinks to ai-resources (UNTRACKED, filesystem mtime 2026-05-06):**

| Symlink Path | Target Resolved Path | Accessible |
|-------------|---------------------|-----------|
| .claude/commands/friday-so.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-so.md | YES |
| .claude/commands/so-monthly.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/so-monthly.md | YES |
| .claude/commands/systems-review.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/systems-review.md | YES |
| .claude/commands/architecture-review.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/architecture-review.md | YES |
| .claude/commands/implementation-triage.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/implementation-triage.md | YES |

**Commands — 1 symlink to axcion-ai-system-owner (unchanged):**

| Symlink Path | Target | Accessible |
|-------------|--------|-----------|
| .claude/commands/consult.md | ../../../axcion-ai-system-owner/.claude/commands/consult.md | YES |

**Agents — 16 symlinks (all to ai-resources except system-owner):**

Previous audit had 9 agents. 7 new agents added 2026-05-05 (d8a2967):

| Symlink Path | Target | Accessible |
|-------------|--------|-----------|
| .claude/agents/claude-md-auditor.md | ../../../../ai-resources/.claude/agents/claude-md-auditor.md | YES |
| .claude/agents/critical-resource-auditor.md | ../../../../ai-resources/.claude/agents/critical-resource-auditor.md | YES |
| .claude/agents/innovation-triage-auditor.md | ../../../../ai-resources/.claude/agents/innovation-triage-auditor.md | YES |
| .claude/agents/permission-sweep-auditor.md | ../../../../ai-resources/.claude/agents/permission-sweep-auditor.md | YES |
| .claude/agents/risk-check-reviewer.md | ../../../../ai-resources/.claude/agents/risk-check-reviewer.md | YES |
| .claude/agents/token-audit-auditor.md | ../../../../ai-resources/.claude/agents/token-audit-auditor.md | YES |
| .claude/agents/token-audit-auditor-mechanical.md | ../../../../ai-resources/.claude/agents/token-audit-auditor-mechanical.md | YES |

All 9 original agent symlinks from previous audit remain in place and accessible.

**Skills — 3 symlinks (unchanged):**

All 3 from previous audit remain accessible (intake-processor, repo-health-analyzer, ai-resource-builder — all to ai-resources).

Total symlinks: 55 (34 committed command symlinks to ai-resources + 5 untracked command symlinks to ai-resources + 1 committed command symlink to axcion-ai-system-owner + 16 committed agent symlinks to ai-resources/axcion-ai-system-owner + 3 committed skill symlinks to ai-resources). All 55 resolve successfully.

DELTA: Previous audit: 34 symlinks. Current: 55 symlinks (+21). 12 new committed command symlinks, 7 new agent symlinks (all from d8a2967). 5 new untracked command symlinks on filesystem. All new symlinks accessible.

Section summary: 55 symlinks catalogued, all accessible / 21 added since previous audit

---

## Section 2: CLAUDE.md Health

### 2.1 CLAUDE.md Line Count and Sections

CLAUDE.md: **82 lines** (was 89 lines in previous audit — 7 lines removed), **9 sections** (was 10 sections — `## Intake Processing Rules` removed).

Section headings:
1. `## What This Is`
2. `## Overview`
3. `## Command Scope Table`
4. `## Hard Rules`
5. `## Operator Gates`
6. `## Key File Paths`
7. `## Operational Notes`
8. `## Model Selection`
9. `## Commit Rules`

DELTA: CLAUDE.md reduced from 89 to 82 lines. Section `## Intake Processing Rules` removed (commit 08245e6, 2026-05-05). Section `## Overview` updated to reference 14 slash commands (was 13) and includes `/kb-create-report` as spec-only. `## Command Scope Table` updated to include `/kb-create-report` row (spec-only, not yet built).

Section summary: 0 issues flagged / 2 deltas (line count, section removal)

---

### 2.2 References in CLAUDE.md to Non-Existent Files or Paths

| Reference | Exists? | Notes |
|-----------|---------|-------|
| `macro-kb/_meta/taxonomy.md` | YES | Present |
| `macro-kb/_meta/index.json` | YES | Populated (2475 lines) |
| `macro-kb/_meta/confidence-rubric.md` | YES | 16 lines |
| `macro-kb/_meta/prompts/synthesis-prompt.md` | YES | 154 lines (updated since previous audit) |
| `macro-kb/_meta/templates/` | YES | 8 files + processing-workflow/ subdir |
| `macro-kb/_sources/registry.md` | YES | 47 lines |
| `macro-kb/_decisions/` | YES | 5 stub files |
| `skills/intake-processor/SKILL.md` | YES | Via symlink to ai-resources |
| `macro-kb/_meta/templates/processing-workflow/` | YES | 4 files |
| `macro-kb/_meta/docs/report-layer-spec.md` | YES | 166 lines — new reference added in this version of CLAUDE.md |

None found — all references in CLAUDE.md resolve to existing files or directories. Checked all 10 explicit path references.

DELTA: One new path reference added: `macro-kb/_meta/docs/report-layer-spec.md` (present in `## Overview` inline reference). File exists.

Section summary: 0 issues flagged / 1 delta (new valid reference)

---

### 2.3 Contradictions in CLAUDE.md

None found — checked all 9 sections. `## Overview` states 14 slash commands (13 active + 1 spec-only) which matches the `## Command Scope Table` row count of 14. `## Model Selection` states `/kb-synthesize` declares `model: opus` in frontmatter — confirmed true as of this audit (Q4.2).

DELTA: Previous audit flagged a gap: CLAUDE.md stated `/kb-synthesize` declares `model: opus` but the file did not. This gap is now resolved — `/kb-synthesize` does declare `model: opus` (commit 08245e6).

Section summary: 0 issues flagged / 1 delta (previous discrepancy resolved)

---

### 2.4 Conventions Defined in CLAUDE.md Not Followed by Actual Files

| Convention | Defined Where | Status |
|-----------|--------------|--------|
| `/kb-synthesize` uses `model: opus` in frontmatter | CLAUDE.md `## Model Selection` | RESOLVED — `/kb-synthesize` now has `model: opus` frontmatter (commit 08245e6, 2026-05-05) |
| All 13 kb-* commands should declare a model | workspace CLAUDE.md `## Model Tier` | RESOLVED — all 13 local kb-* commands now have YAML frontmatter with `model:` declaration (commit 08245e6) |

None found — both violations from the previous audit have been resolved.

DELTA: Both violations (findings #1 and #2 from previous audit) resolved in commit 08245e6 on 2026-05-05.

Section summary: 0 issues flagged / 2 deltas (2 violations resolved)

---

### 2.5 Partial Feature References (File Exists, Other File Missing)

| Feature | Exists | Missing |
|---------|--------|---------|
| `/kb-audit` writes to `macro-kb/_meta/audit-report.md` | Command file exists, directory exists, audit-report.md now exists (populated 2026-05-06) | Nothing missing — RESOLVED |
| `/kb-theme-health`, `/kb-cross-theme`, `/kb-gap-audit` read `_theme-file.md` | Commands exist, template exists | No `_theme-file.md` exists in any of 43 theme folders — all three commands will find no data |
| `/kb-synthesize`, `/kb-stale`, `/kb-query` read `_synthesis.md` | Commands exist, 21 themes now have _synthesis.md | 22 themes still have no `_synthesis.md` (20 empty themes + ai-disruption which has synthesis + 1 china-taiwan entry but no synthesis yet) |
| `/wrap-session` reads `logs/improvement-log.md` | NOW EXISTS — 21 lines | No longer missing |
| `/wrap-session` reads `logs/friction-log.md` | NOW EXISTS — 24 lines | No longer missing |
| `/wrap-session` reads/writes `logs/usage-log.md` | NOW EXISTS — 411 lines | No longer missing |
| `/improve` reads `logs/friction-log.md` and `logs/improvement-log.md` | Both NOW EXIST | No longer missing |
| `/kb-create-report` referenced in CLAUDE.md Command Scope Table (spec-only) | Spec at `macro-kb/_meta/docs/report-layer-spec.md` exists | No `/kb-create-report` command file exists — CLAUDE.md explicitly notes "spec only, not yet built" |

DELTA: 4 missing items from previous audit resolved: audit-report.md, friction-log.md, improvement-log.md, usage-log.md. New partial feature: `/kb-create-report` spec file exists but command not yet built (acknowledged in CLAUDE.md as intentional). Synthesis gap reduced from 42 themes to 22 themes without synthesis.

Section summary: 2 items flagged (no `_theme-file.md` in any theme; 22 themes without `_synthesis.md`) + 1 acknowledged spec-only item (`/kb-create-report`) / 4 deltas from previous audit (4 missing log files now exist)

---

### 2.6 Task-Type-Specific Instructions in CLAUDE.md

| Section | Approximate Lines | Task-Type Addressed | Assessment |
|---------|------------------|---------------------|-----------|
| `## Command Scope Table` | ~20 lines | Per-command read/write scope rules | Cross-session project-wide state. No violation. |
| `## Hard Rules` | ~9 lines | KB system invariants | Cross-session project-wide constraints. No violation. |
| `## Operator Gates` | ~7 lines | Gate behavior for /kb-ingest and /kb-review | Cross-session system rules. No violation. |

The `## Intake Processing Rules` section (6 lines, flagged in previous audit) has been removed in commit 08245e6.

DELTA: Previous finding (finding #9 in prior audit) resolved — `## Intake Processing Rules` section removed from CLAUDE.md.

Section summary: 0 issues flagged / 1 delta (violation resolved)

---

## Section 3: Dependency References

### 3.1 Per-Command File References with Existence Check

**Local kb-* commands (changes from previous audit only; unchanged references omitted):**

| Slash Command | Referenced File | Exists | Change vs. Previous |
|---------------|----------------|--------|---------------------|
| /kb-audit | macro-kb/_meta/audit-report.md | YES | Was NO — now created |
| /kb-query | macro-kb/*/`_synthesis.md` | PARTIAL | Was NO — 21 of 43 themes now have _synthesis.md |
| /kb-stale | macro-kb/*/`_synthesis.md` | PARTIAL | Was NO — 21 of 43 themes now have _synthesis.md |
| /kb-gap-audit | macro-kb/*/`_theme-file.md` | NO | Unchanged — no _theme-file.md exists |
| /kb-gap-audit | macro-kb/*/`_synthesis.md` | PARTIAL | Was NO — 21 themes now have synthesis |
| /kb-theme-health | macro-kb/*/`_theme-file.md` | NO | Unchanged |
| /kb-cross-theme | macro-kb/*/`_theme-file.md` | NO | Unchanged |
| /kb-cross-theme | macro-kb/*/`_synthesis.md` | PARTIAL | Was NO — 21 themes now have synthesis |

**New symlinked commands:** All 17 new symlinked commands resolve to accessible ai-resources targets. Internal file references within those commands are in ai-resources scope.

DELTA: audit-report.md now exists (was missing). Log files (friction-log.md, improvement-log.md, usage-log.md) now exist. Synthesis files now exist in 21 of 43 themes. No _theme-file.md exists in any theme (unchanged).

Section summary: 3 items still flagged (no _theme-file.md; 22 themes without synthesis; /kb-create-report command missing) / 4 deltas from previous audit

---

### 3.2 Command Output Chains

Chains from previous audit are unchanged. No new chains introduced by the 17 new symlinked commands (those commands are general-purpose ai-resources utilities without project-specific output chains).

| Chain | Description |
|-------|-------------|
| /kb-ingest → /kb-review | `/kb-ingest` writes staged entries to `macro-kb/_staging/`. Output is required input for `/kb-review`. |
| /kb-review → /kb-synthesize | `/kb-review` files entries to theme folders and updates index.json. CLAUDE.md Operational Notes: "After review, suggest running `/kb-synthesize` on affected themes." |
| /kb-populate → /kb-review | `/kb-populate` writes staged entries to `macro-kb/_staging/`. Same staging output as `/kb-ingest`; processed by `/kb-review`. |
| /kb-reindex → /kb-stale | `/kb-reindex` rebuilds index.json. `/kb-stale` reads index.json. |
| /kb-reindex → /kb-query | `/kb-reindex` rebuilds index.json. `/kb-query` reads index.json. |
| /kb-synthesize → /kb-query | `/kb-synthesize` writes `_synthesis.md` files. `/kb-query` reads synthesis files. |
| /kb-synthesize → /kb-cross-theme | `/kb-synthesize` writes `_synthesis.md`. `/kb-cross-theme` reads synthesis files. |
| /kb-synthesize → /kb-stale | `/kb-synthesize` updates `entries_at_last_synthesis` in synthesis frontmatter. `/kb-stale` reads this field. |
| /friction-log or /note → /improve | `/friction-log` or `/note friction:` writes `logs/friction-log.md`. `/improve` reads that file. |
| /improve → /wrap-session | `/improve` writes `logs/improvement-log.md`. `/wrap-session` Step 9 reads it. |
| /wrap-session → check-archive.sh → split-log.sh | `/wrap-session` Step 11 runs `check-archive.sh` which calls `split-log.sh`. |
| /request-skill → /create-skill | `/request-skill` writes a brief to `ai-resources/inbox/`. `/create-skill` reads it. |

DELTA: No new chains. Split-log chain is now confirmed active: session-notes-archive-2026-04.md and session-notes-archive-2026-05.md exist as outputs.

Section summary: 0 issues flagged / 0 deltas from previous audit

---

### 3.3 Files Referenced by More Than One Command, Hook, or Script

Unchanged from previous audit. The addition of 17 new commands does not create new shared-file dependencies within the project scope (those commands reference ai-resources-scope files).

| File | Referenced By |
|------|--------------|
| macro-kb/_meta/taxonomy.md | /kb-ingest, /kb-synthesize, /kb-populate, /kb-query, /kb-reindex, /kb-gap-audit |
| macro-kb/_meta/index.json | /kb-review (write), /kb-reindex (write), /kb-stale (read), /kb-query (read), /kb-synthesize (read) |
| macro-kb/_sources/registry.md | /kb-registry-query, /kb-gap-audit, /kb-triage-stats |
| macro-kb/_staging/ | /kb-ingest (write), /kb-populate (write), /kb-review (read) |
| macro-kb/*/`_synthesis.md` | /kb-synthesize (write), /kb-query (read), /kb-stale (read), /kb-cross-theme (read), /kb-populate (read) |
| macro-kb/*/`_theme-file.md` | /kb-theme-health (read), /kb-cross-theme (read), /kb-gap-audit (read) |
| logs/friction-log.md | /friction-log (write), /note (write via friction: prefix), /improve (read), /wrap-session (read, conditional) |
| logs/improvement-log.md | /improve (write), /wrap-session (read, Step 9), /resolve-improvement-log (read/write) |
| logs/session-notes.md | /prime (read last entry), /wrap-session (write) |
| logs/innovation-registry.md | /prime (read), /wrap-session (read/write Step 7) |
| logs/decisions.md | /prime (read), /wrap-session (write) |
| logs/coaching-data.md | /wrap-session (write Step 6) |
| Write guard hook | Any Write call to macro-kb/[a-z]* paths |
| Edit guard hook | Any Edit call to macro-kb/[a-z]* paths |

DELTA: `logs/improvement-log.md` now also referenced by `/resolve-improvement-log` (new command). All previously absent log files now exist on disk.

Section summary: 0 issues flagged / 1 delta (resolve-improvement-log added as referencing improvement-log.md)

---

### 3.4 Files Ranked by Downstream References (Top 10)

Unchanged from previous audit. Rankings and counts are the same.

| Rank | File | Reference Count | Referenced By |
|------|------|----------------|--------------|
| 1 | macro-kb/_meta/taxonomy.md | 6 | /kb-ingest, /kb-synthesize, /kb-populate, /kb-query, /kb-reindex, /kb-gap-audit |
| 2 | macro-kb/_meta/index.json | 5 | /kb-review, /kb-reindex, /kb-stale, /kb-query, /kb-synthesize |
| 3 | macro-kb/*/`_synthesis.md` (class) | 5 | /kb-synthesize, /kb-query, /kb-stale, /kb-cross-theme, /kb-populate |
| 4 | logs/friction-log.md | 4 | /friction-log, /note, /improve, /wrap-session |
| 5 | macro-kb/_staging/ | 3 | /kb-ingest, /kb-populate, /kb-review |
| 6 | macro-kb/_sources/registry.md | 3 | /kb-registry-query, /kb-gap-audit, /kb-triage-stats |
| 7 | macro-kb/*/`_theme-file.md` (class) | 3 | /kb-theme-health, /kb-cross-theme, /kb-gap-audit |
| 8 | logs/improvement-log.md | 3 | /improve, /wrap-session, /resolve-improvement-log |
| 9 | logs/session-notes.md | 2 | /prime, /wrap-session |
| 10 | logs/innovation-registry.md | 2 | /prime, /wrap-session |

DELTA: `logs/improvement-log.md` reference count increased from 2 to 3 (new /resolve-improvement-log command).

Section summary: 0 issues flagged / 1 delta

---

### 3.5 Symlink Targets vs. permissions.additionalDirectories

`permissions.additionalDirectories` in `.claude/settings.json` remains unchanged: one entry: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`.

All 55 symlink targets are within this directory tree:
- ai-resources targets: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/...` — covered (prefix match)
- axcion-ai-system-owner targets: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/...` — covered (prefix match)
- skill targets: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/...` — covered (prefix match)

None found — all 55 symlink targets (including 21 new ones) are covered by `additionalDirectories`. Checked by string-prefix match of resolved paths against the single `additionalDirectories` entry.

DELTA: 21 new symlinks added since previous audit — all targets covered by existing additionalDirectories entry.

Section summary: 0 issues flagged / 0 deltas (no new coverage gaps)

---

### 3.6 Projects Referencing ai-resources Without Listing It in additionalDirectories

This project (global-macro-analysis) references ai-resources via:
- 34 committed command symlinks to ai-resources/.claude/commands/ (was 22 in previous audit)
- 5 untracked command symlinks to ai-resources/.claude/commands/
- 15 agent symlinks to ai-resources/.claude/agents/ (was 8 in previous audit)
- 3 skill symlinks to ai-resources/skills/
- wrap-session.md references `ai-resources/skills/session-usage-analyzer/SKILL.md` by path

`.claude/settings.json` `permissions.additionalDirectories` contains `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`, which covers ai-resources as a subdirectory.

None found — the project lists the workspace root in `additionalDirectories`, which covers ai-resources. Checked both `.claude/settings.json` and `.claude/settings.local.json`.

DELTA: No change to coverage status. Number of ai-resources references increased significantly.

Section summary: 0 issues flagged / 0 deltas

---

## Section 4: Consistency Checks

### 4.1 Skill Structural Pattern Consistency

Unchanged from previous audit. 3 skills, all symlinks to ai-resources. Structural variations (agents/, references/, command.md) are not violations — no uniform structure is mandated by this project's CLAUDE.md.

DELTA: No changes.

Section summary: 0 issues flagged / 0 deltas from previous audit

---

### 4.2 Slash Command Definition Pattern Consistency

All 13 local kb-* commands now have YAML frontmatter with `model:` declared (added 2026-05-05 in commit 08245e6). Previous audit's 13-violation finding is resolved.

Current state: 12 of 13 local kb-* commands declare `model: sonnet`; `/kb-synthesize` declares `model: opus`. All 34 committed symlinked commands (ai-resources + axcion-ai-system-owner) have YAML frontmatter in their target files. The 5 untracked symlinks resolve to ai-resources files; those files have frontmatter (out of scope to audit here).

DELTA: All 13 violations from previous audit resolved in commit 08245e6.

Section summary: 0 issues flagged / 13 deltas (all 13 violations resolved)

---

### 4.3 Skill Template Comparison

N/A — No skill creation template file exists in this project's scope. Skills are created via `/create-skill` which references ai-resource-builder/SKILL.md for format standards.

---

### 4.4 Naming Convention Inconsistencies

None found — checked across 52 commands, 16 agents, 3 skills, and 12 templates. All kb-* commands use consistent `kb-` prefix. All templates use kebab-case naming. Agent files use kebab-case. Skill directories use kebab-case. No inconsistencies detected.

DELTA: No new inconsistencies introduced by 17 new command symlinks or 7 new agent symlinks.

Section summary: 0 issues flagged / 0 deltas from previous audit

---

### 4.5 Directory Structure Pattern Violations

CLAUDE.md states: "All data lives in `macro-kb/`. All operations run through Claude Code commands."

| Item | Location | Status |
|------|---------|--------|
| `pipeline/` directory (11 files + source-docs/ subdir) | Project root | Still exists outside CLAUDE.md-defined structure. |
| `reports/` directory | Project root | Not present in this audit — previous audit found `reports/repo-health-report.md`; that file is no longer present at project root level. |
| `.DS_Store` (3 instances) | Root, macro-kb/, macro-kb/food-security/ | Filesystem artifacts — unchanged. |
| All 43 theme `_theme-file.md` files | Missing from all theme folders | 0 theme-file.md in any theme — the `/kb-theme-health` command flags absent theme files; no theme files have been created. |
| 22 theme folders with no content | Present in taxonomy but empty | 20 themes have no entries. |

DELTA: `reports/` directory no longer present (1 issue resolved). `pipeline/` still exists (unchanged). `_theme-file.md` gap unchanged (43 themes, 0 theme files).

Section summary: 1 issue flagged (pipeline/ exists outside CLAUDE.md-defined structure) / 1 delta (reports/ absence resolved)

---

### 4.6 Slash Command Syntax and Path Resolution

Local kb-* commands: all now include YAML frontmatter (see Q4.2). All file paths referenced in Scope sections verified in Q3.1.

Symlinked commands: all symlink targets resolve (verified Q1.7). Internal syntax and path references within those commands are in ai-resources scope.

Path resolvability for local command references: all infrastructure paths exist. Data paths (`_synthesis.md`, `_theme-file.md`) are data-generation targets — 21 synthesis files exist, 0 theme files exist.

DELTA: Previous audit flagged all 13 kb-* commands for missing frontmatter — resolved.

Section summary: 0 issues flagged / 13 deltas (all previous frontmatter violations resolved)

---

### 4.7 Duplicate or Built-in Conflicting Command Names

None found — checked all 52 command names against each other and against Claude Code built-in commands. No duplicates within the local set. No matches to Claude Code built-ins. No new conflicts introduced by the 17 new symlinked commands.

DELTA: No new conflicts identified.

Section summary: 0 issues flagged / 0 deltas from previous audit

---

### 4.8 Agent Tier Compliance

Compared declared `model:` in frontmatter of each agent file against the Agent Tier Table in `ai-resources/docs/agent-tier-table.md`.

**Agents present in previous audit (unchanged):**

| Agent File | Declared Tier | Expected Tier (Table) | Status |
|-----------|--------------|----------------------|--------|
| collaboration-coach.md | opus | opus | MATCH |
| improvement-analyst.md | opus | opus | MATCH |
| qc-reviewer.md | opus | opus | MATCH |
| refinement-reviewer.md | opus | opus | MATCH |
| repo-dd-auditor.md | sonnet | sonnet | MATCH |
| system-owner.md | opus | opus | MATCH |
| triage-reviewer.md | opus | opus | MATCH |
| workflow-analysis-agent.md | opus | opus | MATCH |
| workflow-critique-agent.md | opus | opus | MATCH |

**New agents added 2026-05-05 (commit d8a2967):**

| Agent File | Declared Tier | Expected Tier (Table) | Status |
|-----------|--------------|----------------------|--------|
| claude-md-auditor.md | opus | opus | MATCH |
| critical-resource-auditor.md | opus | opus | MATCH |
| permission-sweep-auditor.md | sonnet | sonnet | MATCH |
| risk-check-reviewer.md | opus | opus | MATCH |
| token-audit-auditor.md | opus | opus | MATCH |
| token-audit-auditor-mechanical.md | haiku | haiku | MATCH |
| innovation-triage-auditor.md | opus | Not in table | MISSING FROM TABLE |

`innovation-triage-auditor.md` declares `model: opus` but is not listed in `ai-resources/docs/agent-tier-table.md`. The agent file exists in ai-resources/.claude/agents/ and is symlinked into this project as of 2026-05-05.

DELTA: 7 new agents added since previous audit. 6 of 7 match the table. 1 (`innovation-triage-auditor`) is absent from the agent tier table — new finding.

Section summary: 1 issue flagged (innovation-triage-auditor missing from agent tier table) / 7 deltas (7 new agents; 6 match, 1 missing from table)

---

### 4.9 settings.json vs. Canonical Baseline (new-project.md)

The canonical baseline is defined in `ai-resources/.claude/commands/new-project.md` at `CANONICAL_PERMS` and requires `"model": "sonnet"` at the top level.

**Deny entries — canonical set:** `Bash(git push*)`, `Bash(rm -rf *)`, `Bash(sudo *)`, `Read(archive/**)`, `Read(**/*.archive.*)`, `Read(**/deprecated/**)`, `Read(**/old/**)`

**Actual deny entries in `.claude/settings.json`:** `Bash(git push*)`, `Bash(rm -rf *)`, `Bash(sudo *)`, `Read(archive/**)`, `Read(**/*.archive.*)`, `Read(**/deprecated/**)`, `Read(**/old/**)`

All 7 canonical deny entries present. No missing entries.

**Model at top level of settings.json:** NOT SET. The canonical baseline requires `"model": "sonnet"` at the top level of `settings.json`. This project does not have it. `.claude/settings.local.json` is `{}` (empty; no model declared there either, compared to previous audit where it contained `{"model": "claude-sonnet-4-6[1m]"}`).

**Date comparison:**
- Most recent commit touching `.claude/settings.json`: 2026-04-11 (no changes since previous audit)
- Most recent commit touching `new-project.md` CANONICAL_PERMS block: 2026-05-02

DELTA: `.claude/settings.local.json` changed from `{"model": "claude-sonnet-4-6[1m]"}` to `{}` (empty). The model declaration that was in settings.local.json is now absent from both settings files. The missing top-level `"model": "sonnet"` finding from previous audit persists; the 1M model override that was in settings.local.json is now also gone.

Section summary: 1 issue flagged (missing `"model": "sonnet"` at top level of settings.json — and the 1M model override that was in settings.local.json is now absent) / 1 delta (settings.local.json changed from model declaration to empty)

---

## Section 5: Context Load

### 5.1 Estimated Context on Session Start

| File | Line Count | Notes |
|------|-----------|-------|
| CLAUDE.md (project) | 82 lines | Auto-loaded; was 89 lines in previous audit |
| Workspace CLAUDE.md | ~200+ lines | Auto-loaded when opened within workspace |
| .claude/settings.json | 62 lines | Settings, not context |
| .claude/settings.local.json | 1 line (`{}`) | Settings, not context; was 3 lines in previous audit |

Estimated total auto-loaded context: ~285 lines (project CLAUDE.md 82 lines + workspace CLAUDE.md ~200+ lines). No SessionStart hooks exist in `.claude/settings.json` for this project. No auto-loaded reference files beyond CLAUDE.md.

DELTA: Context reduced by ~7 lines from previous audit (CLAUDE.md shrunk from 89 to 82 lines due to removal of `## Intake Processing Rules`).

Section summary: 0 issues flagged / 1 delta (CLAUDE.md size reduced)

---

### 5.2 CLAUDE.md Sections Not Referenced by Any Command, Hook, or Operational Instruction

| Section | Approximate Lines | Assessment |
|---------|------------------|-----------|
| `## What This Is` | ~5 lines | Descriptive overview — standard orientation content, not operationally referenced |
| `## Overview` | ~6 lines | Describes subsystems — orientation content |
| `## Operational Notes` | ~7 lines | Human reminders — meta-instructions for the model, inform behavior across all sessions |
| `## Commit Rules` | ~7 lines | Deliberate duplication of workspace CLAUDE.md `## Commit behavior`; justified in CLAUDE.md text |

DELTA: `## Intake Processing Rules` (previously flagged) removed. The 4 sections flagged here were also present in the previous audit but were classified as no-violation; that classification is unchanged.

Section summary: 0 issues flagged / 1 delta (one section removed)

---

### 5.3 CLAUDE.md Line Count at Last 5 Commits

| Commit | Date | Line Count |
|--------|------|-----------|
| 3d9b170 | 2026-05-06 | 82 lines |
| e0b0972 | 2026-05-05 | 82 lines |
| 08245e6 | 2026-05-05 | 82 lines |
| e6df92d | 2026-04-29 | 89 lines |
| 352d951 | 2026-04-25 | 89 lines |

DELTA: Two new commits added to the window since previous audit. Previous audit's 5 most recent commits: e6df92d (89), 352d951 (89), 9de4cec (85), 6561c4f (71), cab5304 (62). Current window shows the 08245e6 and subsequent commits that brought CLAUDE.md to 82 lines.

Section summary: 0 issues flagged / 2 deltas (2 new commits touching CLAUDE.md)

---

## Section 6: Drift & Staleness

### 6.1 Files Not Modified in Last 90 Days Still Referenced by Active Commands

90-day lookback from 2026-05-08 = files with last commit before 2026-02-07.

All files in this project were committed on or after 2026-04-11. The earliest commit in the project git log is `cab5304` at 2026-04-11 (27 days before this audit). No files predate the 90-day window.

None found — all files have been modified within the last 90 days. Earliest commit in repo is 2026-04-11.

DELTA: No change from previous audit's finding. Still 0 stale files.

Section summary: 0 issues flagged / 0 deltas from previous audit

---

### 6.2 TODO, FIXME, PLACEHOLDER, and Similar Markers

No `TODO`, `FIXME`, or `PLACEHOLDER` (uppercase) markers found in any file. Searched all .md, .json, .yaml, and .sh files.

| File | Line | Marker | Content |
|------|------|--------|---------|
| macro-kb/_decisions/career-positioning.md | 7, 10, 13, 16, 19, 22 | `[Not yet populated]`, `[Not yet assessed.]`, `[Not yet identified...]`, `[Not yet defined.]`, `[Not yet mapped.]` | Stub content — unchanged |
| macro-kb/_decisions/family-planning.md | Multiple | Same stub pattern | Unchanged |
| macro-kb/_decisions/financial-exposure.md | Multiple | Same stub pattern | Unchanged |
| macro-kb/_decisions/geographic-positioning.md | Multiple | Same stub pattern | Unchanged |
| macro-kb/_decisions/network-opportunity.md | Multiple | Same stub pattern | Unchanged |

DELTA: No change from previous audit. Decision memo stubs remain unpopulated.

Section summary: 1 issue flagged (5 decision memo files contain only stub content) / 0 deltas from previous audit

---

### 6.3 Empty Files, Stub Files, or Boilerplate-Only Files

**Resolved since previous audit:**
- `macro-kb/_meta/changelog.json`: was `[]`, now 398 lines with entries
- `macro-kb/_meta/changelog.md`: was header-only, now 532 lines with entries
- `macro-kb/_meta/index.json`: was `[]`, now 2475 lines with entries
- `macro-kb/_sources/registry.md`: was header-only, now 47 lines with registered authors
- `macro-kb/_inbox/`: was empty, now 5 transcript files
- `macro-kb/_staging/`: was empty, now 57 files

**Remaining stubs/empty items:**

| File | State | Content |
|------|-------|---------|
| macro-kb/_decisions/career-positioning.md | Stub | 22-line template, all fields `[Not yet populated]` |
| macro-kb/_decisions/family-planning.md | Stub | 22-line template, all fields `[Not yet populated]` |
| macro-kb/_decisions/financial-exposure.md | Stub | 22-line template, all fields `[Not yet populated]` |
| macro-kb/_decisions/geographic-positioning.md | Stub | 22-line template, all fields `[Not yet populated]` |
| macro-kb/_decisions/network-opportunity.md | Stub | 22-line template, all fields `[Not yet populated]` |
| 20 theme folders (no entries) | Empty scaffolding | No entry files in: youth-unemployment, uk-fragmentation, social-cohesion-breakdown, semiconductor-supply-chain, rare-earths-critical-commodities, pension-crisis, mass-psychological-deterioration, insurance-collapse, institutional-capture, inequality-acceleration, healthcare-stress, global-famine-risk, food-security, elite-exit-capital-flight, corporate-viability-crisis, climate-physical-impacts, capital-controls-financial-repression, ai-winter, ai-winners-losers |
| 22 theme `_history/` dirs | Empty | No synthesis runs for those themes yet |
| 22 themes without `_synthesis.md` | Missing synthesis layer | 21 themes have synthesis; 22 do not |
| .claude/settings.local.json | `{}` | Empty settings file — was previously `{"model": "claude-sonnet-4-6[1m]"}` |

Note: 1 additional theme without a dedicated entry count: `china-taiwan` has 1 entry but no synthesis.

DELTA: 6 previously empty/stub items resolved (changelog.json, changelog.md, index.json, registry.md, _inbox/, _staging/). System transitioned from pre-use to actively used state. 5 decision memo stubs remain. 20 themes still empty (was 42 in previous audit — 23 themes now have entries, but counting reveals 20 without any entries vs 42 in previous audit). settings.local.json changed from having a model declaration to empty `{}`.

Section summary: 5 stub files (decision memos) + 20 empty theme folders + 22 themes without synthesis remain / 6 deltas (6 empty items resolved as system entered active use)

---

## Findings Summary

**Total findings: 10**

| # | Section | Finding | Type |
|---|---------|---------|------|
| 1 | 2.5 | No `_theme-file.md` exists in any of 43 theme folders; /kb-theme-health, /kb-cross-theme, /kb-gap-audit will find no data | Missing item |
| 2 | 2.5 | 22 of 43 themes have no `_synthesis.md`; /kb-query, /kb-stale will return partial data | Missing item |
| 3 | 2.5 | `/kb-create-report` referenced in CLAUDE.md Command Scope Table but command file does not exist (acknowledged in CLAUDE.md as spec-only) | Missing item (acknowledged) |
| 4 | 4.5 | `pipeline/` directory (11 files + source-docs/) exists outside CLAUDE.md-defined structure with no standard home | Discrepancy |
| 5 | 4.8 | `innovation-triage-auditor.md` declares `model: opus` but is not listed in `ai-resources/docs/agent-tier-table.md` | Missing item |
| 6 | 4.9 | `.claude/settings.json` missing `"model": "sonnet"` at top level (canonical baseline requirement) | Missing item |
| 7 | 4.9 | `.claude/settings.local.json` is now empty `{}`; the `"model": "claude-sonnet-4-6[1m]"` declaration present in the previous audit is gone — no model is declared in either settings file | Discrepancy |
| 8 | 1.7 | 5 command symlinks (friday-so.md, so-monthly.md, systems-review.md, architecture-review.md, implementation-triage.md) present on filesystem but untracked in git | Discrepancy |
| 9 | 6.2 | 5 decision memo files contain only `[Not yet populated]` stub content | Missing item |
| 10 | 6.3 | 20 theme folders have no atomic entries; 22 themes have no synthesis layer (partial data state, expected for a system in early active use) | Clean check (expected state) |

**Breakdown by type:**
- Discrepancies (what exists differs from what is stated or tracked): 3 (findings 4, 7, 8)
- Missing items (files or declarations absent): 6 (findings 1, 2, 3, 5, 6, 9)
  - Finding 3 is acknowledged in CLAUDE.md as intentional (spec-only)
- Clean checks (expected empty/partial state): 1 (finding 10)

**Resolved since 2026-05-05 (13 items resolved):**
- All 13 kb-* commands missing model frontmatter — resolved (commit 08245e6)
- CLAUDE.md `## Intake Processing Rules` CLAUDE.md scoping violation — resolved (commit 08245e6)
- CLAUDE.md/command discrepancy on kb-synthesize model claim — resolved (commit 08245e6)
- `macro-kb/_meta/audit-report.md` missing — resolved (first /kb-audit run 2026-05-06)
- `logs/friction-log.md` missing — resolved (system use)
- `logs/improvement-log.md` missing — resolved (system use)
- `logs/usage-log.md` missing — resolved (system use)
- `reports/` directory outside CLAUDE.md structure — no longer present
- 42 empty theme folders, empty changelog, empty index, empty registry — partially resolved (system transitioned to active use)
