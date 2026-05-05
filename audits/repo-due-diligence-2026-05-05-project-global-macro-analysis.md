# Repo Due Diligence Audit — 2026-05-05
Repo: projects/global-macro-analysis
Scope: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/global-macro-analysis
Commit: bfcc809
Previous audit: None
Depth: standard

---

## Section 1: Inventory

### 1.1 Slash Commands

All 35 command files in `.claude/commands/` are symlinks (22 to ai-resources, 1 to axcion-ai-system-owner, 13 local). The 13 local commands are the kb-* suite; 22 are symlinked from ai-resources; 1 (`consult.md`) is symlinked from `projects/axcion-ai-system-owner`.

| Command | Defined In | Referenced Files |
|---------|-----------|-----------------|
| `/analyze-workflow` | symlink → ai-resources/.claude/commands/analyze-workflow.md | workflow-analysis-agent, workflow-critique-agent |
| `/audit-repo` | symlink → ai-resources/.claude/commands/audit-repo.md | repo-health-analyzer skill |
| `/clarify` | symlink → ai-resources/.claude/commands/clarify.md | none explicit |
| `/coach` | symlink → ai-resources/.claude/commands/coach.md | collaboration-coach agent, logs/coaching-data.md |
| `/consult` | symlink → projects/axcion-ai-system-owner/.claude/commands/consult.md | system-owner agent |
| `/create-skill` | symlink → ai-resources/.claude/commands/create-skill.md | ai-resource-builder skill |
| `/friction-log` | symlink → ai-resources/.claude/commands/friction-log.md | logs/friction-log.md |
| `/improve-skill` | symlink → ai-resources/.claude/commands/improve-skill.md | ai-resource-builder skill |
| `/improve` | symlink → ai-resources/.claude/commands/improve.md | improvement-analyst agent, logs/friction-log.md, logs/improvement-log.md, logs/improvement-log-archive.md |
| `/kb-audit` | local: .claude/commands/kb-audit.md | macro-kb/ (all), macro-kb/_meta/audit-report.md (write) |
| `/kb-cross-theme` | local: .claude/commands/kb-cross-theme.md | macro-kb/*/`_theme-file.md`, macro-kb/*/`_synthesis.md` |
| `/kb-gap-audit` | local: .claude/commands/kb-gap-audit.md | macro-kb/_sources/registry.md, macro-kb/*/`_theme-file.md`, macro-kb/*/`_synthesis.md` |
| `/kb-ingest` | local: .claude/commands/kb-ingest.md | macro-kb/_inbox/, macro-kb/_meta/taxonomy.md, skills/intake-processor/SKILL.md, macro-kb/_meta/confidence-rubric.md |
| `/kb-populate` | local: .claude/commands/kb-populate.md | macro-kb/_meta/taxonomy.md, theme synthesis + entries, macro-kb/_meta/templates/atomic-entry-template.md, web |
| `/kb-query` | local: .claude/commands/kb-query.md | macro-kb/_meta/index.json, macro-kb/_meta/taxonomy.md, macro-kb/*/`_synthesis.md`, atomic entries |
| `/kb-registry-query` | local: .claude/commands/kb-registry-query.md | macro-kb/_sources/registry.md |
| `/kb-reindex` | local: .claude/commands/kb-reindex.md | all theme folders (reads), macro-kb/_meta/index.json (write) |
| `/kb-review` | local: .claude/commands/kb-review.md | macro-kb/_staging/, theme folders, macro-kb/_meta/index.json, macro-kb/_meta/changelog.md, macro-kb/_meta/changelog.json |
| `/kb-stale` | local: .claude/commands/kb-stale.md | macro-kb/_meta/index.json, macro-kb/*/`_synthesis.md` frontmatter |
| `/kb-synthesize` | local: .claude/commands/kb-synthesize.md | theme folder entries, macro-kb/*/`_history/`, macro-kb/_meta/taxonomy.md, macro-kb/_meta/index.json, macro-kb/_meta/prompts/synthesis-prompt.md |
| `/kb-theme-health` | local: .claude/commands/kb-theme-health.md | macro-kb/*/`_theme-file.md` |
| `/kb-triage-stats` | local: .claude/commands/kb-triage-stats.md | macro-kb/_sources/registry.md |
| `/migrate-skill` | symlink → ai-resources/.claude/commands/migrate-skill.md | ai-resource-builder skill |
| `/note` | symlink → ai-resources/.claude/commands/note.md | logs/friction-log.md (friction: prefix routing) |
| `/prime` | symlink → ai-resources/.claude/commands/prime.md | logs/session-notes.md, logs/innovation-registry.md, /inbox/ (ai-resources/inbox/), logs/decisions.md |
| `/qc-pass` | symlink → ai-resources/.claude/commands/qc-pass.md | qc-reviewer agent |
| `/refinement-deep` | symlink → ai-resources/.claude/commands/refinement-deep.md | refinement-reviewer agent |
| `/refinement-pass` | symlink → ai-resources/.claude/commands/refinement-pass.md | refinement-reviewer agent |
| `/repo-dd` | symlink → ai-resources/.claude/commands/repo-dd.md | repo-dd-auditor agent, ai-resources/audits/ |
| `/request-skill` | symlink → ai-resources/.claude/commands/request-skill.md | ai-resources/inbox/ |
| `/scope` | symlink → ai-resources/.claude/commands/scope.md | none explicit |
| `/triage` | symlink → ai-resources/.claude/commands/triage.md | triage-reviewer agent |
| `/update-claude-md` | symlink → ai-resources/.claude/commands/update-claude-md.md | CLAUDE.md |
| `/usage-analysis` | symlink → ai-resources/.claude/commands/usage-analysis.md | ai-resources/skills/session-usage-analyzer/SKILL.md, logs/usage-log.md |
| `/wrap-session` | symlink → ai-resources/.claude/commands/wrap-session.md | logs/session-notes.md, logs/decisions.md, logs/coaching-data.md, logs/improvement-log.md, logs/improvement-log-archive.md, logs/innovation-registry.md, logs/usage-log.md, logs/scripts/check-archive.sh, logs/scripts/split-log.sh, logs/friction-log.md |

Section summary: 35 commands catalogued / no previous audit (no delta)

---

### 1.2 Hooks

Hooks are defined in `.claude/settings.json`. No hooks in `.claude/settings.local.json` (contains only `{"model": "claude-sonnet-4-6[1m]"}`).

| Hook | Trigger | What It Does | Files Referenced |
|------|---------|-------------|-----------------|
| Write guard | PreToolUse on `Write` | Intercepts Write calls targeting `macro-kb/[a-z]*` paths not under `_staging/`, `_inbox/`, `_meta/`, `_sources/`, or `_decisions/`. If matched, returns `{"decision":"ask"}` prompt enforcing Hard Rule 1 & 3. | None (inline shell via jq) |
| Edit guard | PreToolUse on `Edit` | Intercepts Edit calls targeting `macro-kb/[a-z]*` paths not under `_staging/`, `_inbox/`, `_meta/`, `_sources/`, or `_decisions/`. If matched, returns `{"decision":"ask"}` prompt enforcing Hard Rule 3. | None (inline shell via jq) |

Both hooks use `jq` to extract `tool_input.file_path` from the tool call JSON, apply a regex match, and conditionally emit an `ask` decision. Timeout is 5 seconds each.

Section summary: 2 hooks catalogued / no previous audit (no delta)

---

### 1.3 Template Files

All templates have the same last commit date: 2026-04-11 (cab5304 — initial build).

| File Path | Purpose | Used By | Last Commit Date |
|-----------|---------|---------|-----------------|
| macro-kb/_meta/templates/atomic-entry-template.md (40 lines) | YAML frontmatter + body structure for atomic entries | /kb-ingest (via intake-processor skill), /kb-populate | 2026-04-11 |
| macro-kb/_meta/templates/batch-manifest-schema.yaml (56 lines) | Schema for staging batch manifest files | /kb-ingest (via intake-processor skill) | 2026-04-11 |
| macro-kb/_meta/templates/changelog-format.md (44 lines) | Format for human-readable changelog entries | /kb-review | 2026-04-11 |
| macro-kb/_meta/templates/decision-memo-template.md (39 lines) | Structure for decision memos in _decisions/ | Not referenced by any command — operator-used reference | 2026-04-11 |
| macro-kb/_meta/templates/index-schema.json (15 lines) | Schema for index.json structure | /kb-reindex (implicit) | 2026-04-11 |
| macro-kb/_meta/templates/source-registry-template.md (26 lines) | Per-author entry format for registry.md | Not referenced by any command — operator-used reference | 2026-04-11 |
| macro-kb/_meta/templates/synthesis-template.md (68 lines) | Structure for _synthesis.md files | /kb-synthesize (implicitly via synthesis-prompt.md) | 2026-04-11 |
| macro-kb/_meta/templates/theme-file-template.md (85 lines) | Structure for _theme-file.md per theme | /kb-theme-health, /kb-cross-theme, /kb-gap-audit (expected input) | 2026-04-11 |
| macro-kb/_meta/templates/processing-workflow/conversation-template.md (32 lines) | NotebookLM conversation guide for source processing | Operator-used outside Claude Code per CLAUDE.md | 2026-04-11 |
| macro-kb/_meta/templates/processing-workflow/priming-template.md (19 lines) | NotebookLM priming template | Operator-used outside Claude Code per CLAUDE.md | 2026-04-11 |
| macro-kb/_meta/templates/processing-workflow/substance-extraction-checkpoint.md (30 lines) | Checkpoint template for research processing | Operator-used outside Claude Code per CLAUDE.md | 2026-04-11 |
| macro-kb/_meta/templates/processing-workflow/triage-tiers.md (51 lines) | Source triage tier definitions | Operator-used outside Claude Code per CLAUDE.md | 2026-04-11 |

Section summary: 12 template files catalogued / no previous audit (no delta)

---

### 1.4 Scripts

| File Path | What It Does | What Calls It |
|-----------|-------------|--------------|
| logs/scripts/check-archive.sh (53 lines) | Iterates session-notes.md and decisions.md; archives files exceeding line thresholds by calling split-log.sh. With `--warn-only`, emits a JSON systemMessage if files exceed 1.5x threshold without writing. | /wrap-session (Step 11) |
| logs/scripts/split-log.sh (82 lines) | Splits an append-only log at `## ` header boundaries; archives older portion to a dated file; rewrites active file with kept entries and archive pointer. | check-archive.sh |

Section summary: 2 scripts catalogued / no previous audit (no delta)

---

### 1.5 Skills

3 skills are present in `skills/`, all as symlinks to ai-resources.

| Skill | Path | Has SKILL.md | Structure |
|-------|------|-------------|-----------|
| intake-processor | skills/intake-processor → ai-resources/skills/intake-processor | YES | SKILL.md only (no sub-agents, no command.md in skill dir) |
| repo-health-analyzer | skills/repo-health-analyzer → ai-resources/skills/repo-health-analyzer | YES | SKILL.md + agents/ subdir + command.md |
| ai-resource-builder | skills/ai-resource-builder → ai-resources/skills/ai-resource-builder | YES | SKILL.md + references/ subdir |

All 3 skills have SKILL.md. None are missing SKILL.md.

Section summary: 3 skills catalogued / no previous audit (no delta)

---

### 1.6 Uncategorized Items

| File/Directory | Category Note |
|---------------|--------------|
| .DS_Store (repo root) | macOS filesystem artifact, not gitignored from project root |
| macro-kb/.DS_Store | macOS filesystem artifact within macro-kb |
| macro-kb/food-security/.DS_Store | macOS filesystem artifact within theme folder |
| pipeline/ directory (14 files) | Project construction artifacts — architecture, implementation spec, session guides, test results, source docs. Not referenced by CLAUDE.md, any command, or hook. These are build-phase documentation. |
| reports/repo-health-report.md (116 lines, last commit 2026-04-11) | Output of a prior audit run. Not referenced by CLAUDE.md or any command. |
| macro-kb/_decisions/ (5 files) | Decision memos — 5 files, all unpopulated stubs (all `[Not yet populated]`). Referenced in CLAUDE.md Key File Paths section. |
| macro-kb/_meta/changelog.md (3 lines — header only) | Initialized but empty; no intake runs have occurred. |
| macro-kb/_meta/changelog.json (1 line — `[]`) | Initialized but empty. |
| macro-kb/_meta/index.json (1 line — `[]`) | Initialized but empty. |
| macro-kb/_sources/registry.md (27 lines — header + template only) | Initialized but no authors registered. |
| macro-kb/_inbox/ | Empty directory. |
| macro-kb/_staging/ | Empty directory. |
| 42 theme folders (each with empty _history/ subdirectory) | All 42 theme folders contain only the _history/ subdirectory — no entries, no _synthesis.md, no _theme-file.md in any theme. |

Section summary: 16 uncategorized item groups catalogued / no previous audit (no delta)

---

### 1.7 Symlinks

**Commands (22 symlinks to ai-resources):**

| Symlink Path | Target | Resolved Path | Accessible |
|-------------|--------|--------------|-----------|
| .claude/commands/analyze-workflow.md | ../../../../ai-resources/.claude/commands/analyze-workflow.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/analyze-workflow.md | YES |
| .claude/commands/audit-repo.md | ../../../../ai-resources/.claude/commands/audit-repo.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/audit-repo.md | YES |
| .claude/commands/clarify.md | ../../../../ai-resources/.claude/commands/clarify.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/clarify.md | YES |
| .claude/commands/coach.md | ../../../../ai-resources/.claude/commands/coach.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/coach.md | YES |
| .claude/commands/create-skill.md | ../../../../ai-resources/.claude/commands/create-skill.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/create-skill.md | YES |
| .claude/commands/friction-log.md | ../../../../ai-resources/.claude/commands/friction-log.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friction-log.md | YES |
| .claude/commands/improve-skill.md | ../../../../ai-resources/.claude/commands/improve-skill.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/improve-skill.md | YES |
| .claude/commands/improve.md | ../../../../ai-resources/.claude/commands/improve.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/improve.md | YES |
| .claude/commands/migrate-skill.md | ../../../../ai-resources/.claude/commands/migrate-skill.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/migrate-skill.md | YES |
| .claude/commands/note.md | ../../../../ai-resources/.claude/commands/note.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/note.md | YES |
| .claude/commands/prime.md | ../../../../ai-resources/.claude/commands/prime.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md | YES |
| .claude/commands/qc-pass.md | ../../../../ai-resources/.claude/commands/qc-pass.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/qc-pass.md | YES |
| .claude/commands/refinement-deep.md | ../../../../ai-resources/.claude/commands/refinement-deep.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/refinement-deep.md | YES |
| .claude/commands/refinement-pass.md | ../../../../ai-resources/.claude/commands/refinement-pass.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/refinement-pass.md | YES |
| .claude/commands/repo-dd.md | ../../../../ai-resources/.claude/commands/repo-dd.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/repo-dd.md | YES |
| .claude/commands/request-skill.md | ../../../../ai-resources/.claude/commands/request-skill.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/request-skill.md | YES |
| .claude/commands/scope.md | ../../../../ai-resources/.claude/commands/scope.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/scope.md | YES |
| .claude/commands/triage.md | ../../../../ai-resources/.claude/commands/triage.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/triage.md | YES |
| .claude/commands/update-claude-md.md | ../../../../ai-resources/.claude/commands/update-claude-md.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/update-claude-md.md | YES |
| .claude/commands/usage-analysis.md | ../../../../ai-resources/.claude/commands/usage-analysis.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/usage-analysis.md | YES |
| .claude/commands/wrap-session.md | ../../../../ai-resources/.claude/commands/wrap-session.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md | YES |

**Commands (1 symlink to axcion-ai-system-owner):**

| Symlink Path | Target | Resolved Path | Accessible |
|-------------|--------|--------------|-----------|
| .claude/commands/consult.md | ../../../axcion-ai-system-owner/.claude/commands/consult.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/.claude/commands/consult.md | YES |

**Agents (8 symlinks to ai-resources):**

| Symlink Path | Target | Resolved Path | Accessible |
|-------------|--------|--------------|-----------|
| .claude/agents/collaboration-coach.md | ../../../../ai-resources/.claude/agents/collaboration-coach.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/collaboration-coach.md | YES |
| .claude/agents/improvement-analyst.md | ../../../../ai-resources/.claude/agents/improvement-analyst.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/improvement-analyst.md | YES |
| .claude/agents/qc-reviewer.md | ../../../../ai-resources/.claude/agents/qc-reviewer.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/qc-reviewer.md | YES |
| .claude/agents/refinement-reviewer.md | ../../../../ai-resources/.claude/agents/refinement-reviewer.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/refinement-reviewer.md | YES |
| .claude/agents/repo-dd-auditor.md | ../../../../ai-resources/.claude/agents/repo-dd-auditor.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/repo-dd-auditor.md | YES |
| .claude/agents/triage-reviewer.md | ../../../../ai-resources/.claude/agents/triage-reviewer.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/triage-reviewer.md | YES |
| .claude/agents/workflow-analysis-agent.md | ../../../../ai-resources/.claude/agents/workflow-analysis-agent.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/workflow-analysis-agent.md | YES |
| .claude/agents/workflow-critique-agent.md | ../../../../ai-resources/.claude/agents/workflow-critique-agent.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/workflow-critique-agent.md | YES |

**Agents (1 symlink to axcion-ai-system-owner):**

| Symlink Path | Target | Resolved Path | Accessible |
|-------------|--------|--------------|-----------|
| .claude/agents/system-owner.md | ../../../axcion-ai-system-owner/.claude/agents/system-owner.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/.claude/agents/system-owner.md | YES |

**Skills (3 symlinks to ai-resources):**

| Symlink Path | Target | Resolved Path | Accessible |
|-------------|--------|--------------|-----------|
| skills/ai-resource-builder | ../../../ai-resources/skills/ai-resource-builder | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/ai-resource-builder | YES |
| skills/intake-processor | ../../../ai-resources/skills/intake-processor | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/intake-processor | YES |
| skills/repo-health-analyzer | ../../../ai-resources/skills/repo-health-analyzer | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/repo-health-analyzer | YES |

Total symlinks: 34. All 34 resolve successfully.

Section summary: 34 symlinks catalogued, all accessible / no previous audit (no delta)

---

## Section 2: CLAUDE.md Health

### 2.1 CLAUDE.md Line Count and Sections

CLAUDE.md: **89 lines**, **10 sections**.

Section headings:
1. `## What This Is`
2. `## Overview`
3. `## Command Scope Table`
4. `## Hard Rules`
5. `## Operator Gates`
6. `## Intake Processing Rules`
7. `## Key File Paths`
8. `## Operational Notes`
9. `## Model Selection`
10. `## Commit Rules`

Section summary: 0 issues flagged / no previous audit (no delta)

---

### 2.2 References in CLAUDE.md to Non-Existent Files or Paths

| Reference | Exists? | Notes |
|-----------|---------|-------|
| `macro-kb/_meta/taxonomy.md` | YES | Present at stated path |
| `macro-kb/_meta/index.json` | YES | Present (empty `[]`) |
| `macro-kb/_meta/confidence-rubric.md` | YES | 16 lines |
| `macro-kb/_meta/prompts/synthesis-prompt.md` | YES | 105 lines |
| `macro-kb/_meta/templates/` | YES | Directory with 8 files + processing-workflow subdir |
| `macro-kb/_sources/registry.md` | YES | 27 lines (header only) |
| `macro-kb/_decisions/` | YES | 5 stub files |
| `skills/intake-processor/SKILL.md` | YES | Via symlink to ai-resources |
| `macro-kb/_meta/templates/processing-workflow/` | YES | 4 files |

None found — all references in CLAUDE.md resolve to existing files or directories. Checked all 9 explicit path references in the Key File Paths and Intake Processing Rules sections.

Section summary: 0 issues flagged / no previous audit (no delta)

---

### 2.3 Contradictions in CLAUDE.md

None found — checked all 10 sections. The `## Command Scope Table` lists 13 kb-* commands; the `## Overview` states "13 slash commands" — these match. The `## Model Selection` section notes Sonnet 1M as default and states `/kb-synthesize` opts into Opus via frontmatter; the actual `/kb-synthesize` command file has no `model:` frontmatter line (see Q2.5 and Q4.2), which is a gap between stated intent and implementation but is not an internal CLAUDE.md contradiction.

Section summary: 0 issues flagged / no previous audit (no delta)

---

### 2.4 Conventions Defined in CLAUDE.md Not Followed by Actual Files

| Convention | Defined Where | Violation |
|-----------|--------------|-----------|
| `/kb-synthesize` uses `model: opus` in frontmatter | CLAUDE.md `## Model Selection`: "Theme synthesis, decision-memo drafting, and judgment-heavy triage opt in via `/model opus` or via slash commands that declare `model: opus` in frontmatter (e.g., `/kb-synthesize`)" | `/kb-synthesize` has no YAML frontmatter and no `model:` line — the convention is stated as fact but not implemented |
| All 13 kb-* commands should declare a model | CLAUDE.md `## Model Selection` and workspace CLAUDE.md `## Model Tier` ("New commands: declare an explicit tier in frontmatter — never inherit") | All 13 local kb-* command files have no YAML frontmatter and no `model:` declaration |

Section summary: 2 issues flagged / no previous audit (no delta)

---

### 2.5 Partial Feature References (File Exists, Other File Missing)

| Feature | Exists | Missing |
|---------|--------|---------|
| `/kb-audit` writes to `macro-kb/_meta/audit-report.md` | Command file exists, directory exists | `macro-kb/_meta/audit-report.md` does not exist (created by first run, not pre-seeded) |
| `/kb-theme-health`, `/kb-cross-theme`, `/kb-gap-audit` read `_theme-file.md` | Commands exist, `theme-file-template.md` exists | No `_theme-file.md` exists in any of the 42 theme folders — all three commands will find nothing to read |
| `/kb-synthesize`, `/kb-stale`, `/kb-query` read `_synthesis.md` | Commands exist | No `_synthesis.md` exists in any of the 42 theme folders |
| `/wrap-session` reads `logs/improvement-log.md` | Command file exists (symlink) | `logs/improvement-log.md` does not exist |
| `/wrap-session` reads `logs/friction-log.md` | Command file exists (symlink) | `logs/friction-log.md` does not exist |
| `/wrap-session` reads and writes `logs/usage-log.md` | Command file exists (symlink) | `logs/usage-log.md` does not exist |
| `/improve` reads `logs/friction-log.md` and `logs/improvement-log.md` | Command file exists (symlink) | Both files do not exist |

Note: `wrap-session.md` and `improve.md` include conditional guards ("if it exists" / "if the file doesn't exist") for `improvement-log.md` and `friction-log.md`, so these missing files do not break execution — they cause those steps to skip. `usage-log.md` has no such guard in `wrap-session.md` Step 12 but the `/usage-analysis` command delegates to a subagent which handles the missing case.

Section summary: 7 items flagged (5 operational gaps where commands will find no data, 2 log files absent but guarded) / no previous audit (no delta)

---

### 2.6 Task-Type-Specific Instructions in CLAUDE.md

| Section | Approximate Lines | Task-Type Addressed | Assessment |
|---------|------------------|---------------------|-----------|
| `## Command Scope Table` | ~18 lines | Per-command read/write scope rules — a structured reference table | This is cross-session project-wide state (which command writes where), not methodology that belongs in a skill file. No violation. |
| `## Hard Rules` | ~9 lines | KB system invariants | These are cross-session project-wide constraints on system behavior. No violation. |
| `## Operator Gates` | ~7 lines | Specific gate behavior for /kb-ingest and /kb-review | These are cross-session system rules. No violation. |
| `## Intake Processing Rules` | ~6 lines | Entry boundary rule, primary theme rule, uncertain routing rule | These are intake methodology rules that could belong in `skills/intake-processor/SKILL.md`. The CLAUDE.md itself states "The intake-processor skill at `skills/intake-processor/SKILL.md` contains the full processing logic" — so these 3 rules duplicate (or summarize) content that the skill owns. Approximate 6-line section. |

The `## Intake Processing Rules` section contains 3 methodology rules (entry boundary, primary theme, uncertain routing) that the workspace `## CLAUDE.md Scoping` rule identifies as belonging in SKILL.md — these are "file-format conventions for a single artifact type" and "skill methodology." The section itself acknowledges the skill holds the full logic, making this a partial duplication.

Section summary: 1 issue flagged / no previous audit (no delta)

---

## Section 3: Dependency References

### 3.1 Per-Command File References with Existence Check

**Local kb-* commands:**

| Slash Command | Referenced File | Exists |
|---------------|----------------|--------|
| /kb-ingest | macro-kb/_inbox/ | YES (empty dir) |
| /kb-ingest | macro-kb/_meta/taxonomy.md | YES |
| /kb-ingest | skills/intake-processor/SKILL.md | YES (via symlink) |
| /kb-ingest | macro-kb/_meta/confidence-rubric.md | YES |
| /kb-ingest | macro-kb/_staging/ | YES (empty dir) |
| /kb-review | macro-kb/_staging/ | YES |
| /kb-review | theme folders | YES |
| /kb-review | macro-kb/_meta/index.json | YES |
| /kb-review | macro-kb/_meta/changelog.md | YES |
| /kb-review | macro-kb/_meta/changelog.json | YES |
| /kb-synthesize | theme entries | YES (0 entries per theme) |
| /kb-synthesize | macro-kb/{theme}/_history/ | YES (42 empty dirs) |
| /kb-synthesize | macro-kb/_meta/taxonomy.md | YES |
| /kb-synthesize | macro-kb/_meta/index.json | YES |
| /kb-synthesize | macro-kb/_meta/prompts/synthesis-prompt.md | YES |
| /kb-populate | macro-kb/_meta/taxonomy.md | YES |
| /kb-populate | macro-kb/_meta/templates/atomic-entry-template.md | YES |
| /kb-populate | macro-kb/_staging/ | YES |
| /kb-query | macro-kb/_meta/index.json | YES |
| /kb-query | macro-kb/_meta/taxonomy.md | YES |
| /kb-query | macro-kb/*/`_synthesis.md` | NO (none exist yet) |
| /kb-audit | macro-kb/ (all) | YES |
| /kb-audit | macro-kb/_meta/audit-report.md | NO (not yet created) |
| /kb-reindex | all theme folders | YES |
| /kb-reindex | macro-kb/_meta/index.json | YES |
| /kb-stale | macro-kb/_meta/index.json | YES |
| /kb-stale | macro-kb/*/`_synthesis.md` | NO (none exist yet) |
| /kb-registry-query | macro-kb/_sources/registry.md | YES |
| /kb-gap-audit | macro-kb/_sources/registry.md | YES |
| /kb-gap-audit | macro-kb/*/`_theme-file.md` | NO (none exist in any theme folder) |
| /kb-gap-audit | macro-kb/*/`_synthesis.md` | NO (none exist yet) |
| /kb-theme-health | macro-kb/*/`_theme-file.md` | NO (none exist in any theme folder) |
| /kb-cross-theme | macro-kb/*/`_theme-file.md` | NO (none exist in any theme folder) |
| /kb-cross-theme | macro-kb/*/`_synthesis.md` | NO (none exist yet) |
| /kb-triage-stats | macro-kb/_sources/registry.md | YES |

**Symlinked commands (external targets verified in 1.7; references within those commands are out of audit scope):**

All 22 ai-resources symlinks and 1 axcion-ai-system-owner symlink resolve. Internal file references within those commands are in the ai-resources scope.

Section summary: 10 issues flagged (referenced files that do not yet exist — all are data files created by first system use, not misconfigured paths) / no previous audit (no delta)

---

### 3.2 Command Output Chains

| Chain | Description |
|-------|-------------|
| /kb-ingest → /kb-review | `/kb-ingest` writes staged entries to `macro-kb/_staging/`. Output (batch manifest + entry files) is the required input for `/kb-review`. |
| /kb-review → /kb-synthesize | `/kb-review` files entries to theme folders and updates index.json. `/kb-synthesize` reads filed entries and index. CLAUDE.md Operational Notes: "After review, suggest running `/kb-synthesize` on affected themes." |
| /kb-populate → /kb-review | `/kb-populate` writes staged entries to `macro-kb/_staging/`. Same staging output as `/kb-ingest`; processed by `/kb-review`. |
| /kb-reindex → /kb-stale | `/kb-reindex` rebuilds index.json. `/kb-stale` reads index.json for entry counts. |
| /kb-reindex → /kb-query | `/kb-reindex` rebuilds index.json. `/kb-query` reads index.json as its search index. |
| /kb-synthesize → /kb-query | `/kb-synthesize` writes `_synthesis.md` files. `/kb-query` reads synthesis files as primary knowledge source. |
| /kb-synthesize → /kb-cross-theme | `/kb-synthesize` writes `_synthesis.md`. `/kb-cross-theme` reads synthesis files. |
| /kb-synthesize → /kb-stale | `/kb-synthesize` updates `entries_at_last_synthesis` in synthesis frontmatter. `/kb-stale` reads this field. |
| /friction-log or /note → /improve | `/friction-log` or `/note friction:` writes `logs/friction-log.md`. `/improve` reads that file. |
| /improve → /wrap-session | `/improve` writes `logs/improvement-log.md`. `/wrap-session` Step 9 reads it. |
| /wrap-session → check-archive.sh → split-log.sh | `/wrap-session` Step 11 runs `check-archive.sh` which calls `split-log.sh`. |
| /request-skill → /create-skill | `/request-skill` writes a brief to `ai-resources/inbox/`. `/create-skill` reads it. |

Section summary: 0 issues flagged / no previous audit (no delta)

---

### 3.3 Files Referenced by More Than One Command, Hook, or Script

| File | Referenced By |
|------|--------------|
| macro-kb/_meta/taxonomy.md | /kb-ingest, /kb-synthesize, /kb-populate, /kb-query (implied), /kb-reindex (excluded list), /kb-gap-audit (implicit via theme slugs) |
| macro-kb/_meta/index.json | /kb-review (write), /kb-reindex (write), /kb-stale (read), /kb-query (read), /kb-synthesize (read) |
| macro-kb/_sources/registry.md | /kb-registry-query, /kb-gap-audit, /kb-triage-stats |
| macro-kb/_staging/ | /kb-ingest (write), /kb-populate (write), /kb-review (read) |
| macro-kb/*/`_synthesis.md` | /kb-synthesize (write), /kb-query (read), /kb-stale (read), /kb-cross-theme (read), /kb-populate (read) |
| macro-kb/*/`_theme-file.md` | /kb-theme-health (read), /kb-cross-theme (read), /kb-gap-audit (read) |
| macro-kb/_meta/changelog.md | /kb-review (write) — only one command |
| macro-kb/_meta/changelog.json | /kb-review (write) — only one command |
| logs/friction-log.md | /friction-log (write), /note (write via friction: prefix), /improve (read), /wrap-session (read, conditional) |
| logs/improvement-log.md | /improve (write), /wrap-session (read, Step 9) |
| logs/session-notes.md | /prime (read last entry), /wrap-session (write) |
| logs/innovation-registry.md | /prime (read), /wrap-session (read/write Step 7) |
| logs/decisions.md | /prime (read), /wrap-session (write) |
| logs/coaching-data.md | /wrap-session (write Step 6) |
| Write guard hook | Any Write call to macro-kb/[a-z]* paths |
| Edit guard hook | Any Edit call to macro-kb/[a-z]* paths |

Section summary: 0 issues flagged / no previous audit (no delta)

---

### 3.4 Files Ranked by Downstream References (Top 10)

| Rank | File | Reference Count | Referenced By |
|------|------|----------------|--------------|
| 1 | macro-kb/_meta/taxonomy.md | 6 | /kb-ingest, /kb-synthesize, /kb-populate, /kb-query, /kb-reindex, /kb-gap-audit |
| 2 | macro-kb/_meta/index.json | 5 | /kb-review, /kb-reindex, /kb-stale, /kb-query, /kb-synthesize |
| 3 | macro-kb/*/`_synthesis.md` (class) | 5 | /kb-synthesize, /kb-query, /kb-stale, /kb-cross-theme, /kb-populate |
| 4 | macro-kb/_staging/ | 3 | /kb-ingest, /kb-populate, /kb-review |
| 5 | macro-kb/_sources/registry.md | 3 | /kb-registry-query, /kb-gap-audit, /kb-triage-stats |
| 6 | macro-kb/*/`_theme-file.md` (class) | 3 | /kb-theme-health, /kb-cross-theme, /kb-gap-audit |
| 7 | logs/friction-log.md | 4 | /friction-log, /note, /improve, /wrap-session |
| 8 | logs/improvement-log.md | 2 | /improve, /wrap-session |
| 9 | logs/session-notes.md | 2 | /prime, /wrap-session |
| 10 | logs/innovation-registry.md | 2 | /prime, /wrap-session |

Section summary: 0 issues flagged / no previous audit (no delta)

---

### 3.5 Symlink Targets vs. permissions.additionalDirectories

`permissions.additionalDirectories` in `.claude/settings.json` contains one entry: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`.

All symlink targets are within this directory tree:
- ai-resources targets: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/...` — covered (prefix match)
- axcion-ai-system-owner targets: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/...` — covered (prefix match)
- skill targets: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/...` — covered (prefix match)

None found — all 34 symlink targets are covered by `additionalDirectories`. Checked by string-prefix match of resolved paths against the single `additionalDirectories` entry.

Section summary: 0 issues flagged / no previous audit (no delta)

---

### 3.6 Projects Referencing ai-resources Without Listing It in additionalDirectories

This project (global-macro-analysis) references ai-resources via:
- 22 command symlinks to ai-resources/.claude/commands/
- 8 agent symlinks to ai-resources/.claude/agents/
- 3 skill symlinks to ai-resources/skills/
- wrap-session.md (symlink) references `ai-resources/skills/session-usage-analyzer/SKILL.md` by path

`.claude/settings.json` `permissions.additionalDirectories` contains `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`, which is an ancestor of `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/`. This covers the ai-resources reference.

None found — the project lists the workspace root in `additionalDirectories`, which covers ai-resources as a subdirectory. Checked both `.claude/settings.json` and `.claude/settings.local.json`.

Section summary: 0 issues flagged / no previous audit (no delta)

---

## Section 4: Consistency Checks

### 4.1 Skill Structural Pattern Consistency

3 skills are present (all symlinks to ai-resources). Their structures differ:

| Skill | SKILL.md | agents/ | command.md | references/ |
|-------|----------|---------|------------|-------------|
| intake-processor | YES | NO | NO | NO |
| repo-health-analyzer | YES | YES | YES | NO |
| ai-resource-builder | YES | NO | NO | YES |

All have SKILL.md. The structural differences (some have agents/, some have references/, one has command.md) are not violations — no uniform structure is mandated by CLAUDE.md for this project. The workspace CLAUDE.md states only "Read the relevant SKILL.md before performing any task that has a corresponding skill." The ai-resources repo owns skill structure standards; variations are out of scope here.

Section summary: 0 issues flagged / no previous audit (no delta)

---

### 4.2 Slash Command Definition Pattern Consistency

All symlinked commands (22 to ai-resources + 1 to axcion-ai-system-owner) have YAML frontmatter with `model:` declared. The 13 local kb-* command files have no YAML frontmatter at all.

| Deviating Commands | Expected Pattern | Actual State |
|--------------------|-----------------|-------------|
| kb-audit.md | YAML frontmatter with `model:` | No frontmatter |
| kb-cross-theme.md | YAML frontmatter with `model:` | No frontmatter |
| kb-gap-audit.md | YAML frontmatter with `model:` | No frontmatter |
| kb-ingest.md | YAML frontmatter with `model:` | No frontmatter |
| kb-populate.md | YAML frontmatter with `model:` | No frontmatter |
| kb-query.md | YAML frontmatter with `model:` | No frontmatter |
| kb-registry-query.md | YAML frontmatter with `model:` | No frontmatter |
| kb-reindex.md | YAML frontmatter with `model:` | No frontmatter |
| kb-review.md | YAML frontmatter with `model:` | No frontmatter |
| kb-stale.md | YAML frontmatter with `model:` | No frontmatter |
| kb-synthesize.md | YAML frontmatter with `model:` | No frontmatter |
| kb-theme-health.md | YAML frontmatter with `model:` | No frontmatter |
| kb-triage-stats.md | YAML frontmatter with `model:` | No frontmatter |

The workspace CLAUDE.md `## Model Tier` rule states: "New commands: declare an explicit tier in frontmatter — never inherit." All 13 local kb-* commands violate this rule. Additionally, CLAUDE.md `## Model Selection` states `/kb-synthesize` should declare `model: opus` — it does not.

Section summary: 13 issues flagged (all 13 local kb-* commands missing model frontmatter) / no previous audit (no delta)

---

### 4.3 Skill Template Comparison

N/A — No skill creation template file exists in this project's scope. Skills are created via `/create-skill` which references ai-resource-builder/SKILL.md for format standards.

---

### 4.4 Naming Convention Inconsistencies

None found — checked across 35 commands, 9 agents, 3 skills, and 12 templates. All kb-* commands use consistent `kb-` prefix. All templates use kebab-case naming. Agent files use kebab-case. Skill directories use kebab-case. No inconsistencies detected.

Section summary: 0 issues flagged / no previous audit (no delta)

---

### 4.5 Directory Structure Pattern Violations

CLAUDE.md states: "All data lives in `macro-kb/`. All operations run through Claude Code commands." The following items exist outside the stated structure:

| Item | Location | Expected Location |
|------|---------|-------------------|
| `pipeline/` directory (14 files) | Project root | Not defined by CLAUDE.md structure — build-phase artifacts, no standard home |
| `reports/repo-health-report.md` | `reports/` at project root | Not defined by CLAUDE.md structure |
| `.DS_Store` (3 instances) | Root, macro-kb/, macro-kb/food-security/ | Not tracked files — filesystem artifacts |
| All 42 theme `_theme-file.md` files | Missing from theme folders | Expected per `kb-theme-health` command which flags missing theme files |
| All 42 theme `_synthesis.md` files | Missing from theme folders | Expected output of `/kb-synthesize`; system not yet populated |

Section summary: 2 issues flagged (pipeline/ and reports/ directories exist outside the CLAUDE.md-defined structure with no standard home) / no previous audit (no delta)

---

### 4.6 Slash Command Syntax and Path Resolution

Local kb-* commands: all use the pattern `/kb-commandname $ARGUMENTS — Description` as the first line. File paths referenced in Scope sections have been verified in Q3.1.

Missing frontmatter for all 13 kb-* commands is flagged in Q4.2.

Symlinked commands: syntax checked via target file reads; all include YAML frontmatter and structured steps. All symlink targets resolve (verified Q1.7).

Path failures: `macro-kb/_meta/audit-report.md` (written by /kb-audit, does not pre-exist) and all `_synthesis.md` and `_theme-file.md` paths do not exist. These are data-creation paths, not configuration paths.

Section summary: 13 issues flagged (missing frontmatter in kb-* commands, already counted in Q4.2) / no previous audit (no delta)

---

### 4.7 Duplicate or Built-in Conflicting Command Names

None found — checked all 35 command names against the list and against Claude Code built-in commands (read, write, bash, glob, grep, etc.). No duplicates within the local set. `/prime` and `/note` and `/scope` and `/triage` and `/improve` and `/coach` are not Claude Code built-ins. No duplicates detected.

Section summary: 0 issues flagged / no previous audit (no delta)

---

### 4.8 Agent Tier Compliance

Compared declared `model:` in frontmatter of each agent file against the Agent Tier Table in `ai-resources/docs/agent-tier-table.md`.

| Agent File | Declared Tier | Expected Tier (Table) | Status |
|-----------|--------------|----------------------|--------|
| collaboration-coach.md | opus | opus | MATCH |
| improvement-analyst.md | opus | opus | MATCH |
| qc-reviewer.md | opus | opus | MATCH |
| refinement-reviewer.md | opus | opus | MATCH |
| repo-dd-auditor.md | sonnet | sonnet | MATCH |
| system-owner.md | opus | opus (in table, project-local note) | MATCH |
| triage-reviewer.md | opus | opus | MATCH |
| workflow-analysis-agent.md | opus | opus | MATCH |
| workflow-critique-agent.md | opus | opus | MATCH |

All 9 agents match the table. `system-owner.md` is listed in the table as `opus` with note "Project-local to projects/axcion-ai-system-owner/ at v1."

Section summary: 0 issues flagged / no previous audit (no delta)

---

### 4.9 settings.json vs. Canonical Baseline (new-project.md)

The canonical baseline is defined in `ai-resources/.claude/commands/new-project.md` at `CANONICAL_PERMS` (line 312) and requires `"model": "sonnet"` at the top level (line ~320).

**Deny entries — canonical set:** `Bash(git push*)`, `Bash(rm -rf *)`, `Bash(sudo *)`, `Read(archive/**)`, `Read(**/*.archive.*)`, `Read(**/deprecated/**)`, `Read(**/old/**)`

**Actual deny entries in `.claude/settings.json`:** `Bash(git push*)`, `Bash(rm -rf *)`, `Bash(sudo *)`, `Read(archive/**)`, `Read(**/*.archive.*)`, `Read(**/deprecated/**)`, `Read(**/old/**)`

All 7 canonical deny entries are present. No missing entries.

**Model at top level of settings.json:** NOT SET. The canonical baseline requires `"model": "sonnet"` at the top level of `settings.json`. This project does not have it. The project-level model is declared in `.claude/settings.local.json` as `"model": "claude-sonnet-4-6[1m]"` (the 1M variant), but the canonical baseline's `"model": "sonnet"` entry is absent from `settings.json`.

**Date comparison:**
- Most recent commit touching `.claude/settings.json`: 2026-05-05
- Most recent commit touching `new-project.md` CANONICAL_PERMS block (in ai-resources repo): 2026-05-02

Section summary: 1 issue flagged (missing `"model": "sonnet"` at top level of settings.json) / no previous audit (no delta)

---

## Section 5: Context Load

### 5.1 Estimated Context on Session Start

Files auto-loaded by Claude Code when opening this project directory:

| File | Line Count | Notes |
|------|-----------|-------|
| CLAUDE.md (project) | 89 lines | Auto-loaded |
| Workspace CLAUDE.md | ~200+ lines | Auto-loaded if opened within workspace |
| .claude/settings.json | 62 lines | Settings, not context |
| .claude/settings.local.json | 3 lines | Settings, not context |

CLAUDE.md (project-level): 89 lines.
Workspace CLAUDE.md (from `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md`): not directly in AUDIT_ROOT but loaded by Claude Code when the project is opened within the workspace. Workspace CLAUDE.md is approximately 200+ lines.

Estimated total auto-loaded context: ~300 lines (project CLAUDE.md 89 lines + workspace CLAUDE.md ~200+ lines). No SessionStart hooks exist in `.claude/settings.json` for this project. No auto-loaded reference files beyond CLAUDE.md.

Section summary: 0 issues flagged / no previous audit (no delta)

---

### 5.2 CLAUDE.md Sections Not Referenced by Any Command, Hook, or Operational Instruction

| Section | Approximate Lines | Assessment |
|---------|------------------|-----------|
| `## What This Is` | ~5 lines | Descriptive overview — not operationally referenced but standard orientation content |
| `## Overview` | ~6 lines | Describes two subsystems — orientation content, not operationally referenced by commands |
| `## Operational Notes` | ~7 lines | Human reminders ("After ingest, always remind...") — these are meta-instructions for the model, not referenced by any specific command. They inform model behavior across all sessions. |
| `## Commit Rules` | ~7 lines | Duplicates workspace CLAUDE.md `## Commit behavior`. CLAUDE.md itself states: "This rule mirrors the canonical `Commit behavior` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded." |

`## Commit Rules` is a deliberate duplication, justified in CLAUDE.md. `## Operational Notes` functions as persistent model-behavior guidance loaded every session. `## What This Is` and `## Overview` are standard project orientation.

Section summary: 0 issues flagged / no previous audit (no delta)

---

### 5.3 CLAUDE.md Line Count at Last 5 Commits

| Commit | Date | Line Count |
|--------|------|-----------|
| e6df92d | 2026-04-29 | 89 lines |
| 352d951 | 2026-04-25 | 89 lines |
| 9de4cec | 2026-04-13 | 85 lines |
| 6561c4f | 2026-04-11 | 71 lines |
| cab5304 | 2026-04-11 | 62 lines |

Section summary: 0 issues flagged / no previous audit (no delta)

---

## Section 6: Drift & Staleness

### 6.1 Files Not Modified in Last 90 Days Still Referenced by Active Commands

90-day lookback from 2026-05-05 = files with last commit before 2026-02-04.

All files in this project were committed on or after 2026-04-10. The earliest commit in the full git log is `cab5304` at 2026-04-11. No files predate the 90-day window.

None found — all files have been modified within the last 90 days. Earliest commit in repo is 2026-04-11 (24 days ago from audit date 2026-05-05).

Section summary: 0 issues flagged / no previous audit (no delta)

---

### 6.2 TODO, FIXME, PLACEHOLDER, and Similar Markers

| File | Line | Marker | Content |
|------|------|--------|---------|
| pipeline/implementation-spec.md | 596 | placeholder (lowercase) | "...followed by a placeholder indicating the registry is empty:" — this is a description of expected registry content, not an action item marker |
| macro-kb/_decisions/career-positioning.md | 2, 7, 10, 13, 16, 19, 22 | `[Not yet populated]`, `[Not yet assessed.]`, `[Not yet identified...]`, `[Not yet defined.]`, `[Not yet mapped.]` | Stub content — all 5 decision memo files contain identical unpopulated stubs |
| macro-kb/_decisions/family-planning.md | Multiple | Same stub pattern | Identical to career-positioning.md |
| macro-kb/_decisions/financial-exposure.md | Multiple | Same stub pattern | Identical structure |
| macro-kb/_decisions/geographic-positioning.md | Multiple | Same stub pattern | Identical structure |
| macro-kb/_decisions/network-opportunity.md | Multiple | Same stub pattern | Identical structure |

The `pipeline/implementation-spec.md:596` reference is a description, not an action marker. The 5 decision memo stubs use bracket-delimited not-yet-populated markers consistently across all 22 lines in each file.

No `TODO`, `FIXME`, or `PLACEHOLDER` (uppercase) markers found in any file. Searched all .md, .json, .yaml, and .sh files.

Section summary: 1 issue flagged (5 decision memo files contain only stub content with `[Not yet populated]` markers throughout) / no previous audit (no delta)

---

### 6.3 Empty Files, Stub Files, or Boilerplate-Only Files

| File | State | Content |
|------|-------|---------|
| macro-kb/_meta/changelog.json | Stub | `[]` — empty JSON array (1 line) |
| macro-kb/_meta/changelog.md | Stub | Header line + 2 description lines — no changelog entries |
| macro-kb/_meta/index.json | Stub | `[]` — empty JSON array (1 line) |
| macro-kb/_sources/registry.md | Stub | 27-line template header with "No authors registered yet" placeholder |
| macro-kb/_decisions/career-positioning.md | Stub | 22-line template, all fields `[Not yet populated]` |
| macro-kb/_decisions/family-planning.md | Stub | 22-line template, all fields `[Not yet populated]` |
| macro-kb/_decisions/financial-exposure.md | Stub | 22-line template, all fields `[Not yet populated]` |
| macro-kb/_decisions/geographic-positioning.md | Stub | 22-line template, all fields `[Not yet populated]` |
| macro-kb/_decisions/network-opportunity.md | Stub | 22-line template, all fields `[Not yet populated]` |
| macro-kb/_inbox/ | Empty directory | No files |
| macro-kb/_staging/ | Empty directory | No files |
| 42 × macro-kb/{theme}/_history/ | Empty directories | No history files (no synthesis runs yet) |
| 42 × macro-kb/{theme}/ | Theme folders with no content files | Each contains only the empty _history/ subdirectory — no entries, no _synthesis.md, no _theme-file.md |

The system is in pre-use state: taxonomy and templates are fully built (2026-04-11), but no intake runs have been executed. All theme folders are empty scaffolding.

Section summary: 9 stub/empty files flagged + 44 empty directories (2 functional, 42 theme history dirs) + 42 contentless theme folders / no previous audit (no delta)

---

## Findings Summary

**Total findings: 26**

| # | Section | Finding | Type |
|---|---------|---------|------|
| 1 | 2.4 | /kb-synthesize command does not declare `model: opus` despite CLAUDE.md stating it does | Discrepancy |
| 2 | 2.4 | All 13 kb-* commands have no model frontmatter despite workspace CLAUDE.md "never inherit" rule | Violation |
| 3 | 2.5 | `macro-kb/_meta/audit-report.md` does not exist (created by first /kb-audit run) | Missing item |
| 4 | 2.5 | No `_theme-file.md` exists in any of 42 theme folders; /kb-theme-health, /kb-cross-theme, /kb-gap-audit will find no data | Missing item |
| 5 | 2.5 | No `_synthesis.md` exists in any theme folder; /kb-query, /kb-stale, /kb-synthesize will find no synthesis data | Missing item |
| 6 | 2.5 | `logs/improvement-log.md` does not exist (referenced by /wrap-session and /improve; conditionally guarded) | Missing item |
| 7 | 2.5 | `logs/friction-log.md` does not exist (referenced by /friction-log, /note, /improve, /wrap-session; conditionally guarded) | Missing item |
| 8 | 2.5 | `logs/usage-log.md` does not exist (referenced by /usage-analysis and /wrap-session Step 12) | Missing item |
| 9 | 2.6 | `## Intake Processing Rules` in CLAUDE.md (6 lines) duplicates methodology that CLAUDE.md attributes to the intake-processor SKILL.md | Violation |
| 10 | 3.1 | 10 referenced files do not exist: `_synthesis.md` (×42), `_theme-file.md` (×42), `audit-report.md` (×1) — all are data-creation targets not pre-seeded | Missing item |
| 11 | 4.2 | All 13 local kb-* commands missing YAML frontmatter and `model:` declaration (same as finding #2) | Violation |
| 12 | 4.5 | `pipeline/` directory (14 files) exists outside CLAUDE.md-defined structure with no standard home | Discrepancy |
| 13 | 4.5 | `reports/` directory exists outside CLAUDE.md-defined structure with no standard home | Discrepancy |
| 14 | 4.9 | `.claude/settings.json` missing `"model": "sonnet"` at top level (canonical baseline requirement) | Missing item |
| 15 | 6.2 | 5 decision memo files contain only `[Not yet populated]` stub content | Missing item |
| 16–26 | 6.3 | 9 stub/empty data files; 42 contentless theme folders; 44 empty directories — system in pre-use state | Clean check (expected initial state) |

**Breakdown by type:**
- Discrepancies (what exists differs from what is stated): 3 (findings 1, 12, 13)
- Missing items (files or declarations absent): 10 (findings 3–8, 10, 14, 15, and the model declaration gap)
- Violations (rule stated, not followed): 2 finding groups (findings 2/11 are the same 13-command set; finding 9)
- Clean checks (expected empty/stub state for an uninitialized system): findings 16–26

**Deduplicated count by issue class:**
- 13 commands missing `model:` frontmatter (1 violation class, 13 instances)
- 1 CLAUDE.md scoping violation (Intake Processing Rules)
- 1 settings.json missing top-level model declaration
- 3 operational log files absent (improvement-log.md, friction-log.md, usage-log.md)
- 2 unlinked directories (pipeline/, reports/)
- 5 unpopulated decision memos
- 1 CLAUDE.md/command discrepancy (kb-synthesize model claim)
- System-state empty data files (expected for pre-use system — 42 theme folders, empty meta files)
