# Repo Due Diligence Audit — 2026-05-08
Repo: ai-resources repo
Scope: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources
Commit: e6911ec
Previous audit: 2026-04-18

---

## Section 1: Inventory

### 1.1 Slash Commands

All commands defined in `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/`. **53 commands total** (was 29 at prior audit; 24 new commands added since 2026-04-18).

| Command | File | Referenced Files |
|---|---|---|
| analyze-workflow | analyze-workflow.md | `{AI_RESOURCES}/audits/`, `{WORKFLOW_PATH}/reference/stage-instructions.md`, various workflow agents |
| architecture-review | architecture-review.md | `{WORKSPACE_ROOT}/ai-resources/audits/`, `system-owner` agent |
| audit-claude-md | audit-claude-md.md | `{WORKSPACE}/ai-resources/audits/`, `claude-md-auditor` agent |
| audit-critical-resources | audit-critical-resources.md | `audits/critical-resources-manifest.md`, `{AI_RESOURCES}/.claude/agents/critical-resource-auditor.md` |
| audit-repo | audit-repo.md | `reference/skills/repo-health-analyzer/agents/` (project-relative path) |
| clarify | clarify.md | None |
| cleanup-worktree | cleanup-worktree.md | `skills/worktree-cleanup-investigator/SKILL.md`, `skills/worktree-cleanup-investigator/scripts/find-template.sh` |
| coach | coach.md | `logs/session-notes.md`, `logs/coaching-log.md`, `logs/coaching-log-archive.md`, `collaboration-coach` agent |
| consult | consult.md | `ai-resources/docs/repo-architecture.md`, `system-owner` agent |
| create-skill | create-skill.md | `skills/ai-resource-builder/SKILL.md`, `skills/ai-resource-builder/references/evaluation-framework.md`, `logs/improvement-log.md`, `qc-reviewer` agent |
| deploy-kb | deploy-kb.md | `skills/obsidian-kb-builder/templates/` |
| deploy-workflow | deploy-workflow.md | `ai-resources/.claude/hooks/auto-sync-shared.sh`, `check-template-drift.sh`, `reference/skills/` (project-relative), `workflows/{TEMPLATE}/` |
| friction-log | friction-log.md | `logs/friction-log.md` |
| friday-act | friday-act.md | `ai-resources/audits/friday-checkup-*.md`, `ai-resources/docs/audit-discipline.md`, `ai-resources/audits/friday-plans/`, `logs/maintenance-observations.md`, `system-owner` agent |
| friday-checkup | friday-checkup.md | `ai-resources/audits/`, `logs/improvement-log.md`, `logs/session-notes.md`, `logs/friction-log.md`, `permission-sweep-auditor` agent, `ai-resources/audits/permission-sweep-{TODAY}.md`, `improvement-analyst` agent |
| friday-journal | friday-journal.md | `ai-resources/logs/ai-journal.md`, `ai-resources/audits/friday-checkup-*.md`, `ai-resources/audits/friday-journal-{TODAY}.md`, `ai-resources/audits/working/journal-qc-{TODAY}.md` |
| friday-so | friday-so.md | `ai-resources/audits/friday-checkup-*.md`, `projects/axcion-ai-system-owner/output/friday-advisories/`, `system-owner` agent |
| graduate-resource | graduate-resource.md | `logs/innovation-registry.md`, `ai-resources/skills/` |
| implementation-triage | implementation-triage.md | `system-owner` agent |
| improve-skill | improve-skill.md | `skills/ai-resource-builder/SKILL.md`, `skills/ai-resource-builder/references/evaluation-framework.md`, `skills/ai-resource-builder/references/operational-frontmatter.md`, `logs/improvement-log.md`, `qc-reviewer` agent |
| improve | improve.md | `logs/friction-log.md`, `logs/improvement-log.md`, `improvement-analyst` agent |
| innovation-sweep | innovation-sweep.md | `{AI_RESOURCES}/.claude/agents/innovation-triage-auditor.md`, `{TARGET_PROJECT}/logs/innovation-registry.md` |
| migrate-skill | migrate-skill.md | `skills/ai-resource-builder/SKILL.md`, `skills/ai-resource-builder/references/evaluation-framework.md`, `qc-reviewer` agent |
| monday-prep | monday-prep.md | `ai-resources/docs/weekly-cadence.md`, `logs/session-notes.md`, `logs/maintenance-observations.md`, `logs/improvement-log.md`, `ai-resources/audits/friday-checkup-*.md` |
| new-project | new-project.md | `ai-resources/.claude/hooks/auto-sync-shared.sh`, `ai-resources/.claude/hooks/check-permission-sanity.sh`, `pipeline-stage-3a/3b/3c/4/5.md`, `session-guide-generator` agent |
| note | note.md | `logs/friction-log.md`, `logs/workflow-observations.md` |
| permission-sweep | permission-sweep.md | `{AI_RESOURCES}/docs/permission-template.md`, `permission-sweep-auditor` agent |
| prime | prime.md | `logs/session-notes.md`, `logs/innovation-registry.md`, `logs/decisions.md` |
| project-consultant | project-consultant.md | `projects/global-macro-analysis/` (multiple paths, workspace-relative) |
| qc-pass | qc-pass.md | `qc-reviewer` agent |
| recommend | recommend.md | None identified beyond conversation context |
| refinement-deep | refinement-deep.md | `refinement-reviewer` agent |
| refinement-pass | refinement-pass.md | `refinement-reviewer` agent |
| repo-dd | repo-dd.md | `audits/questionnaire.md`, `repo-dd-auditor` agent, `dd-extract-agent`, `dd-log-sweep-agent`, log files, `session-guide-generator` agent |
| request-skill | request-skill.md | `ai-resources/skills/` (search) |
| resolve-improvement-log | resolve-improvement-log.md | `ai-resources/logs/improvement-log.md`, `ai-resources/logs/improvement-log-archive.md` |
| resolve | resolve.md | `logs/improvement-log.md` |
| risk-check | risk-check.md | `{AI_RESOURCES}/audits/risk-checks/`, `{AI_RESOURCES}/docs/audit-discipline.md`, `{AI_RESOURCES}/docs/repo-architecture.md`, `{AI_RESOURCES}/docs/permission-template.md`, `{AI_RESOURCES}/docs/agent-tier-table.md`, `{AI_RESOURCES}/docs/ai-resource-creation.md`, `risk-check-reviewer` agent |
| route-change | route-change.md | `{AI_RESOURCES}/docs/repo-architecture.md`, `{AI_RESOURCES}/docs/audit-discipline.md`, `{AI_RESOURCES}/docs/permission-template.md`, `{AI_RESOURCES}/docs/agent-tier-table.md`, `{AI_RESOURCES}/docs/ai-resource-creation.md`, `system-owner` agent |
| save-session | save-session.md | `logs/scratchpads/{YYYY-MM-DD}-{HH-MM}-scratchpad.md` (project-relative, created at run time) |
| scope | scope.md | None |
| session-guide | session-guide.md | `session-guide-generator` agent |
| session-plan | session-plan.md | `logs/session-notes.md`, `logs/session-plan.md`, `skills/ai-resource-builder/references/operational-frontmatter.md`, `ai-resources/docs/audit-discipline.md`, `ai-resources/docs/repo-architecture.md`, `ai-resources/docs/permission-template.md` |
| session-start | session-start.md | `logs/session-notes.md` |
| so-monthly | so-monthly.md | `ai-resources/audits/friday-checkup-*.md`, `ai-resources/logs/maintenance-observations.md`, `projects/axcion-ai-system-owner/output/monthly-reviews/`, `system-owner` agent |
| summary | summary.md | `skills/summary/SKILL.md` |
| sync-workflow | sync-workflow.md | `reference/skills/` (project-relative), workflow template files |
| systems-review | systems-review.md | `projects/axcion-ai-system-owner/vault/research/systems-thinking-for-claude-code.md`, `projects/axcion-ai-system-owner/output/systems-reviews/`, `system-owner` agent |
| token-audit | token-audit.md | `{WORKSPACE}/ai-resources/audits/`, `token-audit-auditor` agent, `token-audit-auditor-mechanical` agent |
| triage | triage.md | `triage-reviewer` agent |
| update-claude-md | update-claude-md.md | CLAUDE.md (current project) |
| usage-analysis | usage-analysis.md | `logs/usage-log.md`, `skills/session-usage-analyzer/SKILL.md`, `session-usage-analyzer` skill |
| wrap-session | wrap-session.md | `logs/session-notes.md`, `logs/decisions.md`, `logs/coaching-data.md`, `logs/improvement-log.md`, `logs/improvement-log-archive.md`, `logs/innovation-registry.md`, `logs/usage-log.md`, `logs/friction-log.md`, `logs/scripts/check-archive.sh`, `logs/scripts/split-log.sh`, `skills/session-usage-analyzer/SKILL.md` |

DELTA: Command count increased from 29 to 53. New commands added since 2026-04-18: `architecture-review`, `audit-claude-md`, `audit-critical-resources`, `consult`, `deploy-kb`, `friday-act`, `friday-checkup`, `friday-journal`, `friday-so`, `implementation-triage`, `innovation-sweep`, `monday-prep`, `permission-sweep`, `recommend`, `resolve-improvement-log`, `resolve`, `risk-check`, `route-change`, `save-session`, `session-plan`, `session-start`, `so-monthly`, `summary`, `systems-review`.

Section summary: 53 commands catalogued / 24 new commands since 2026-04-18.

---

### 1.2 Hooks

**Registered in `.claude/settings.json` (project-level) — significantly expanded since prior audit:**

| Trigger | Matcher | Type | What It Does | Files Referenced |
|---|---|---|---|---|
| PreToolUse | Read\|Grep\|Bash | command | Runs `check-heavy-tool.sh` — emits [HEAVY] warning for heavy tool calls | `.claude/hooks/check-heavy-tool.sh` |
| PreToolUse | Skill | command | Runs `friction-log-auto.sh` — checks friction log before skill invocations | `.claude/hooks/friction-log-auto.sh` |
| PostToolUse | Write\|Edit | command | Runs `log-write-activity.sh` — logs write activity | `.claude/hooks/log-write-activity.sh` |
| PostToolUse | Write\|Edit | command | Runs `auto-qc-nudge.sh` — checks for significant artifact writes | `.claude/hooks/auto-qc-nudge.sh` |
| Stop | — | command | Runs `check-stop-reminders.sh` — checks session-end reminders including telemetry freshness | `.claude/hooks/check-stop-reminders.sh` |
| Stop | — | command | Runs `coach-reminder.sh` — checks for coach reminder | `.claude/hooks/coach-reminder.sh` |
| Stop | — | command | Runs `improve-reminder.sh` — checks for improvement reminder | `.claude/hooks/improve-reminder.sh` |
| Stop | — | command | Runs `auto-resolve-nudge.sh` — checks for QC findings to resolve | `.claude/hooks/auto-resolve-nudge.sh` |
| SessionStart | — | command | Runs `friday-checkup-reminder.sh` — checks Friday cadence | `.claude/hooks/friday-checkup-reminder.sh` |

All 9 hook scripts registered in `settings.json` exist on disk and are verified accessible.

**Registered in `~/.claude/settings.json` (global user-level):**

| Trigger | Matcher | Type | What It Does | Files Referenced |
|---|---|---|---|---|
| PostToolUse | Write | command | Runs `detect-innovation.sh` | `.claude/hooks/detect-innovation.sh` |
| PostToolUse | Edit | command | Runs `detect-innovation.sh` | `.claude/hooks/detect-innovation.sh` |
| Stop | — | command | Plays system sound (`afplay /System/Library/Sounds/Pop.aiff`) | None |
| Notification | — | command | Plays system sound | None |

**Hook scripts present in `.claude/hooks/` but not registered in ai-resources `settings.json`:**

| Script | Declared Role | Why Not Registered |
|---|---|---|
| `auto-sync-shared.sh` | SessionStart hook for deployed projects | Deployed via `/new-project` and `/deploy-workflow` into project settings.json |
| `check-template-drift.sh` | SessionStart hook for deployed projects | Same — designed for project-level SessionStart |
| `check-permission-sanity.sh` | SessionStart hook for deployed projects | Deployed via `/new-project` into project settings.json; not registered in ai-resources own settings |
| `detect-innovation.sh` | PostToolUse hook for write events | Registered in global `~/.claude/settings.json` |
| `pre-commit` | Pre-commit git hook | Git hook, not a Claude Code hook |
| `check-skill-size.sh` | Called by `pre-commit` | Called from `pre-commit` hook script |

DELTA: Hooks section expanded substantially. Previous audit found 1 hook in project settings.json (inline bash Stop hook checking innovation-registry.md). Current settings.json has 9 hooks across PreToolUse, PostToolUse, Stop, and SessionStart triggers. All previously unregistered hook scripts remain unregistered for the same declared reasons. New hook scripts added since 2026-04-18: `auto-qc-nudge.sh`, `auto-resolve-nudge.sh`, `coach-reminder.sh`, `check-permission-sanity.sh`, `friday-checkup-reminder.sh`, `friction-log-auto.sh`, `improve-reminder.sh`, `log-write-activity.sh`.

Section summary: 9 hooks registered in project settings.json, 4 in global settings.json, 6 hook scripts present but not registered in ai-resources own settings / 8 hooks added since 2026-04-18.

---

### 1.3 Template Files

| File Path | Used By | Last Commit Date |
|---|---|---|
| `skills/execution-manifest-creator/references/manifest-template.md` | `execution-manifest-creator` skill | 2026-03-25 |
| `skills/answer-spec-generator/references/component-templates.md` | `answer-spec-generator` skill | 2026-03-26 |
| `skills/research-prompt-creator/references/prompt-construction-guide.md` | `research-prompt-creator` skill | 2026-03-29 |
| `skills/ai-resource-builder/references/operational-frontmatter.md` | `ai-resource-builder` skill, `/create-skill`, `/improve-skill`, `/session-plan` | 2026-04-18 |
| `skills/ai-resource-builder/references/examples.md` | `ai-resource-builder` skill | 2026-04-05 |
| `skills/ai-resource-builder/references/review-principles.md` | `ai-resource-builder` skill | 2026-04-09 |
| `skills/ai-resource-builder/references/evaluation-framework.md` | `ai-resource-builder` skill, `/create-skill`, `/improve-skill`, `/migrate-skill` | 2026-04-09 |
| `skills/ai-resource-builder/references/writing-standards.md` | `ai-resource-builder` skill | 2026-04-05 |
| `skills/ai-resource-builder/references/required-sections.md` | `ai-resource-builder` skill | 2026-04-18 (added in relocation refactor) |
| `skills/ai-resource-builder/references/skill-architecture.md` | `ai-resource-builder` skill | 2026-04-18 (added in relocation refactor) |
| `skills/claude-code-workflow-builder/references/feature-patterns.md` | `claude-code-workflow-builder` skill | 2026-02-21 |
| `skills/citation-converter/references/instruction-a.md` | `citation-converter` skill | 2026-03-22 |
| `skills/citation-converter/references/instruction-b.md` | `citation-converter` skill | 2026-03-22 |
| `skills/research-extract-creator/references/extract-template.md` | `research-extract-creator` skill | 2026-03-24 |
| `skills/research-plan-creator/references/example-output.md` | `research-plan-creator` skill | 2026-03-22 |
| `skills/ai-prose-decontamination/references/change-log-template.md` | `ai-prose-decontamination` skill | 2026-04-18 (added in relocation refactor) |
| `skills/ai-prose-decontamination/references/sub-pattern-examples.md` | `ai-prose-decontamination` skill | 2026-04-18 (added in relocation refactor) |
| `skills/ai-prose-decontamination/references/worked-example.md` | `ai-prose-decontamination` skill | 2026-04-18 (added in relocation refactor) |
| `skills/prose-compliance-qc/references/anti-pattern-checks.md` | `prose-compliance-qc` skill | 2026-04-18 (added in relocation refactor) |
| `skills/prose-compliance-qc/references/output-template.md` | `prose-compliance-qc` skill | 2026-04-18 (added in relocation refactor) |
| `skills/worktree-cleanup-investigator/references/execution-protocol.md` | `worktree-cleanup-investigator` skill | 2026-04-18 |
| `skills/worktree-cleanup-investigator/references/decision-taxonomy.md` | `worktree-cleanup-investigator` skill | 2026-04-13 |
| `skills/obsidian-kb-builder/templates/` (11 files) | `/deploy-kb` command and `obsidian-kb-builder` skill | 2026-05-04 |
| `audits/questionnaire.md` | `/repo-dd` command (`repo-dd-auditor` agent) | 2026-04-18 |
| `workflows/research-workflow/reference/file-conventions.md` | research-workflow deployed projects | 2026-04-18 |
| `workflows/research-workflow/reference/stage-instructions.md` | research-workflow deployed projects | 2026-04-18 |
| `workflows/research-workflow/reference/quality-standards.md` | research-workflow deployed projects | 2026-04-18 |
| `workflows/research-workflow/reference/style-guide.md` | research-workflow deployed projects | 2026-04-18 |

DELTA: 10 new reference/template files added since 2026-04-18, all in skill `references/` subdirectories or the new `obsidian-kb-builder/templates/` tree. `required-sections.md` and `skill-architecture.md` added to `ai-resource-builder/references/`. `ai-prose-decontamination` and `prose-compliance-qc` gained `references/` subdirectories via the 2026-04-18 relocation refactor.

Section summary: 28 template/reference file groups catalogued (vs 21 at prior audit) / 7 new groups since 2026-04-18.

---

### 1.4 Scripts

| File Path | What It Does | What Calls It |
|---|---|---|
| `scripts/repo-audit.sh` | Full workspace health audit script | None found — checked all `.claude/commands/`, `CLAUDE.md`, `skills/` |
| `scripts/skill-inventory.sh` | Skill inventory generation script | None found — checked all `.claude/commands/`, `CLAUDE.md`, `skills/` |
| `.claude/hooks/auto-qc-nudge.sh` | PostToolUse hook: checks for significant artifact writes | Registered in `settings.json` PostToolUse (Write\|Edit) |
| `.claude/hooks/auto-resolve-nudge.sh` | Stop hook: checks for QC findings to resolve | Registered in `settings.json` Stop |
| `.claude/hooks/auto-sync-shared.sh` | SessionStart hook for projects: symlinks commands/agents | Referenced in `/new-project` and `/deploy-workflow`; deployed into project settings.json |
| `.claude/hooks/check-heavy-tool.sh` | PreToolUse hook: emits [HEAVY] warning | Registered in `settings.json` PreToolUse |
| `.claude/hooks/check-permission-sanity.sh` | SessionStart hook for deployed projects: permission drift nudge | Referenced in `/new-project` and `/permission-sweep` docs; deployed into project settings.json via `/new-project` |
| `.claude/hooks/check-skill-size.sh` | Informational warning when staged SKILL.md exceeds 300 lines | Called by `.claude/hooks/pre-commit` |
| `.claude/hooks/check-stop-reminders.sh` | Stop hook: session-end reminders including telemetry freshness | Registered in `settings.json` Stop |
| `.claude/hooks/check-template-drift.sh` | SessionStart hook for deployed projects: template drift detection | Referenced in `/deploy-workflow`; deployed into project settings.json |
| `.claude/hooks/coach-reminder.sh` | Stop hook: checks whether to suggest /coach | Registered in `settings.json` Stop |
| `.claude/hooks/detect-innovation.sh` | PostToolUse hook: detects new commands/agents/hooks for innovation-registry | Registered in `~/.claude/settings.json` (global) |
| `.claude/hooks/friction-log-auto.sh` | PreToolUse hook: checks friction log before skill invocations | Registered in `settings.json` PreToolUse |
| `.claude/hooks/friday-checkup-reminder.sh` | SessionStart hook: checks Friday cadence timing | Registered in `settings.json` SessionStart |
| `.claude/hooks/improve-reminder.sh` | Stop hook: checks whether to suggest /improve | Registered in `settings.json` Stop |
| `.claude/hooks/log-write-activity.sh` | PostToolUse hook: logs write activity | Registered in `settings.json` PostToolUse |
| `.claude/hooks/pre-commit` | Pre-commit git hook: validates SKILL.md, naming, prohibited files | Git pre-commit hook (`.git/hooks/`); not a Claude Code hook |
| `skills/worktree-cleanup-investigator/scripts/find-template.sh` | Searches ai-resources for canonical template matching a file path | `/cleanup-worktree` command and `worktree-cleanup-investigator` skill |
| `logs/scripts/check-archive.sh` | Checks log file sizes; invokes split-log.sh to archive oversized logs | `/wrap-session` command; `research-workflow` SessionStart hook |
| `logs/scripts/split-log.sh` | Archives log entries over threshold to dated archive file | Called by `check-archive.sh` |

DELTA: 12 new scripts since 2026-04-18 (8 new hook scripts, 2 new `logs/scripts/` scripts). `check-archive.sh` and `split-log.sh` added to `logs/scripts/` directory. 8 new hook scripts added to `.claude/hooks/`. Count increased from 8 to 20 scripts.

Section summary: 20 scripts catalogued / 12 new since 2026-04-18.

---

### 1.5 Skills

**Total skill directories: 70** (was 67 at prior audit; 3 new skills added since 2026-04-18).

New skills since 2026-04-18: `obsidian-kb-builder` (2026-05-04), `prose-refinement-writer` (2026-04-21), `summary` (2026-04-23).

All 70 skill directories contain a `SKILL.md` file. None are missing a `SKILL.md`.

DELTA: Count increased from 67 to 70 (3 new skills: `prose-refinement-writer`, `summary`, `obsidian-kb-builder`).

Section summary: 70 skills catalogued, all have SKILL.md / 3 new skills since 2026-04-18.

---

### 1.6 Uncategorized Items

| Item | Category Assignment |
|---|---|
| `skills/CATALOG.md` | Skill catalog index file — not a skill, template, or command. Standalone inventory document. |
| `skills/repo-health-analyzer/command.md` | Skill-bundled command definition. Non-standard: this skill includes a command.md alongside its agents/ subdirectory. |
| `skills/repo-health-analyzer/agents/` (8 .md files) | Skill-bundled agent definitions. Stored inside skill directory rather than `.claude/agents/`. |
| `inbox/codex-second-opinion-brief.md` | Active resource brief in intake queue (not yet fulfilled). Last commit 2026-04-14. |
| `inbox/repo-review-brief.md` | Active resource brief in intake queue. Last commit 2026-04-07. |
| `inbox/innovation-sweep-plan.md` | Active intake document. Last commit 2026-04-27. |
| `inbox/.gitkeep` | Empty placeholder file. |
| `inbox/archive/prose-refinement-writer-brief.md` | Archived fulfilled brief. Last commit 2026-04-21. |
| `inbox/archive/summary-skill-brief.md` | Archived fulfilled brief. Last commit 2026-04-23. |
| `inbox/archive/worktree-cleanup-brief.md` | Archived fulfilled brief. Last commit 2026-04-18. |
| `audits/working/` | ~57 working-notes files from audit runs (token-audit, repo-dd, permission-sweep, etc.). Operational artifacts; gitignored. |
| `audits/risk-checks/` | 34 risk-check report files. Untracked in git (gitignored per `.gitignore`). |
| `audits/friday-plans/` | 6 plan files from `/friday-act` runs. |
| `audits/critical-resources-manifest.md` | Manifest file listing nominated critical resources for `/audit-critical-resources`. |
| `audits/questionnaire.md` | Questionnaire for `/repo-dd`. |
| Prior audit/report files in `audits/` | 28 report files (claude-md-audits, friday-checkups, friday-journal, improvement-plan, innovation-sweep, permission-sweeps, repo-dd reports, repo-health reports, token-audit reports, workflow-analysis/critique). |
| `logs/coaching-data.md` | Session coaching profile log. |
| `logs/decisions.md` | Decision journal. |
| `logs/friction-log.md` | Friction event log. |
| `logs/improvement-log.md` | Improvement tracking log. |
| `logs/improvement-log-archive.md` | Archive of applied improvement entries. |
| `logs/innovation-registry.md` | Innovation detection registry. |
| `logs/session-notes.md` | Session wrap notes. |
| `logs/coaching-log.md` | Coaching session log. (Previously did not exist; created since 2026-04-18.) |
| `logs/workflow-observations.md` | Workflow observations log. (Previously did not exist; created 2026-04-18.) |
| `logs/maintenance-observations.md` | Maintenance observations log. New since 2026-04-18. |
| `logs/session-plan.md` | Session plan output file. New since 2026-04-18. |
| `logs/ai-journal.md` | AI improvement journal. New since 2026-04-18. |
| `logs/usage-log.md` | Token usage telemetry log. Previously at `usage/usage-log.md`; now in `logs/`. |
| `logs/decisions-archive-2026-04.md` | Archived decisions entries from April 2026. |
| `logs/session-notes-archive-2026-04.md` | Archived session notes entries from April 2026. |
| `logs/session-notes-archive-2026-05.md` | Archived session notes entries from May 2026. |
| `logs/improvement-log-archive.md` | Archive of resolved improvement entries. |
| `logs/scripts/check-archive.sh` | Log archival script. (Catalogued under 1.4 as well.) |
| `logs/scripts/split-log.sh` | Log split script. (Catalogued under 1.4 as well.) |
| `usage/` | Now empty directory. `usage-log.md` moved to `logs/`. |
| `reports/repo-health-report.md` | Generated repo health report (from `/audit-repo`). |
| `docs/` | 19 process documentation files (see Section 2 for CLAUDE.md context). New docs added since 2026-04-18: `agent-tier-table.md`, `ai-resource-creation.md`, `analytical-output-principles.md`, `audit-discipline.md`, `autonomy-rules.md`, `commit-discipline.md`, `compaction-protocol.md`, `cross-model-rules.md`, `file-write-discipline.md`, `operator-maintenance-cadence.md`, `permission-template.md`, `plan-mode-discipline.md`, `qc-independence.md`, `repo-architecture.md`, `session-guardrails.md`, `weekly-cadence.md`, `weekly-session-guide.md`. Existing before: `operator-principles.md`, `session-rituals.md`. |
| `style-references/internal-material.md` | Style reference for formatting/prose-compliance skills. |
| `prompts/supplementary-research/` (5 .md files) | Standalone prompts for GPT supplementary research workflow. |
| `workflows/research-workflow/` | Research workflow template (full directory tree). |
| `.gitignore` | Standard git file. |

DELTA: Significant growth in uncategorized items. Notable changes: `coaching-log.md` and `workflow-observations.md` now exist (both were flagged missing in prior audit). `usage-log.md` moved from `usage/` to `logs/`. `usage/` directory is now empty. 7 new log files added to `logs/` (maintenance-observations, session-plan, ai-journal, decisions-archive-2026-04, session-notes-archive-2026-04, session-notes-archive-2026-05, improvement-log-archive). `docs/` expanded from 2 files to 19 files (17 new docs/ files added; most extracted from workspace CLAUDE.md 2026-05-04). `audits/` directory gained risk-checks/, friday-plans/ subdirectories and ~20 new report files.

Section summary: ~42 uncategorized item categories catalogued / substantial growth since 2026-04-18.

---

### 1.7 Symlinks

Two symlinks found in `workflows/research-workflow/.claude/commands/`:

| Symlink Path | Target Path | Target Exists and Accessible |
|---|---|---|
| `workflows/research-workflow/.claude/commands/consult.md` | `../../../.claude/commands/consult.md` (resolves to `ai-resources/.claude/commands/consult.md`) | Yes — file exists at resolved path |
| `workflows/research-workflow/.claude/commands/session-plan.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md` | Yes — file exists at absolute path |

Both symlink targets are within AUDIT_ROOT (`ai-resources/`). No broken symlinks. No symlinks in `.claude/commands/` or `.claude/agents/` at the top-level repo directories.

DELTA: 2 symlinks added since 2026-04-18. Previous audit found 0 symlinks. Both new symlinks are within the `workflows/research-workflow/` template directory, pointing to `ai-resources/.claude/commands/` targets.

Section summary: 2 symlinks found, both accessible / 2 new since 2026-04-18.

---

## Section 2: CLAUDE.md Health

### 2.1 CLAUDE.md Size and Structure

**Line count:** 92 lines (was 83 lines at prior audit)
**Sections:** 13 (was 11 at prior audit)

| Section Heading |
|---|
| What This Repo Contains |
| How I Work |
| Skill Creation and Improvement |
| Model Selection |
| Subagent Contracts |
| Session Telemetry |
| Maintenance Cadence |
| Permission Management |
| General Session Rules |
| Git Rules |
| Commit Rules |
| Compaction |
| Session Boundaries |

DELTA: 2 new sections added since 2026-04-18: `Maintenance Cadence` (3 lines, added 2026-04-22) and `Permission Management` (3 lines, added 2026-04-24). Section "Model Preference" renamed to "Model Selection" and content revised (2026-04-22). Line count grew from 83 to 92, then a 92-line version with model-routing content was briefly present (2026-04-25), then content removed (2026-04-29) back to 92 lines. Net change: +9 lines from 2026-04-18 baseline of 83.

Section summary: 0 issues flagged on this sub-check / 2 new sections since 2026-04-18.

---

### 2.2 Dead References in CLAUDE.md

**Two discrepancies found:**

1. **Line 56 (`Permission Management` section):** References `/fewer-permission-prompts` as a paired command ("Pairs with `/fewer-permission-prompts`"). No command named `/fewer-permission-prompts` exists in `.claude/commands/`. No skill with that name exists in `skills/`. No docs file with that name exists in `docs/`. This reference is a dead reference.

2. **Line 16 (`What This Repo Contains` section):** States "this repo itself does not host a canonical usage log." However, `logs/usage-log.md` exists in this repo (52,193 bytes as of 2026-05-08) and is actively written to by `/wrap-session` and `/usage-analysis`. The statement is factually inaccurate about current repo state.

No other dead references found — checked: `skills/ai-resource-builder/SKILL.md` (exists), `docs/permission-template.md` (exists), `/permission-sweep` command (exists), `/create-skill`, `/improve-skill`, `/friday-checkup` commands (all exist), `.claude/commands/friday-checkup.md` (exists).

DELTA: 1 new dead reference since 2026-04-18 (`/fewer-permission-prompts`). 1 new factual inaccuracy since 2026-04-18 (line 16 "does not host" contradicted by the existence of `logs/usage-log.md`, which replaced `usage/usage-log.md`). Prior audit found 0 dead references.

Section summary: 2 issues flagged / 2 new since 2026-04-18.

---

### 2.3 Contradictions in CLAUDE.md

**One contradiction found (partially resolved from prior audit):**

| Location | Statement A | Statement B |
|---|---|---|
| Line 22 ("How I Work") | "I review and approve all changes before they are committed or pushed." | Line 75 ("Commit Rules"): "**Commit directly. Do not ask for permission.** After completing approved work, stage the relevant files and commit in a single step." |

The "How I Work" section states changes require review before committing. The "Commit Rules" section says to commit directly without asking permission. These instructions are in direct conflict on whether pre-commit review is required.

**Note:** The prior audit identified a three-way conflict (How I Work, Git Rules bullet, Commit Rules). The "Git Rules" bullet "Always show me the diff before committing" no longer exists in the current `Git Rules` section. The conflict is now between two sections only, not three.

DELTA: Three-way contradiction reduced to two-way. The "Always show me the diff before committing" bullet in Git Rules was removed, eliminating one side of the conflict. The core contradiction between "How I Work" (line 22) and "Commit Rules" (line 75) persists.

Section summary: 1 issue flagged / partial resolution since 2026-04-18.

---

### 2.4 Conventions Defined but Not Followed

**Two violations found (unchanged from prior audit, plus new note on CATALOG.md staleness):**

1. **`skills/repo-health-analyzer/` non-standard structure:** CLAUDE.md defines each skill as living in its own folder under `skills/`. `repo-health-analyzer/` contains `command.md` and `agents/` subdirectory with 8 agent definition files — non-standard for a skill directory. Unchanged since prior audit.

2. **CATALOG.md out of date:** CLAUDE.md documents `skills/` as the canonical skill library but does not define a CATALOG.md maintenance convention. CATALOG.md was last committed 2026-04-06 and lists 60 skills. Actual skill count is 70. The 10 skills absent from CATALOG.md are: `ai-prose-decontamination`, `formatting-qc`, `fund-triage-scanner`, `intake-processor`, `obsidian-kb-builder`, `prose-refinement-writer`, `summary`, `workflow-system-analyzer`, `workflow-system-critic`, `worktree-cleanup-investigator`.

DELTA: CATALOG.md gap increased from 7 missing skills to 10. At prior audit: 7 skills absent (catalog dated 2026-04-06 vs 67 actual). Now: 10 skills absent (catalog still dated 2026-04-06 vs 70 actual). Both violations persist from prior audit.

Section summary: 2 issues flagged / CATALOG.md gap grew from 7 to 10 missing skills.

---

### 2.5 Partially-Existing Features

**One partially-existing feature resolved; new issue identified:**

| Feature | What Exists | What Is Missing |
|---|---|---|
| `CLAUDE.md` line 56 — `/fewer-permission-prompts` | `docs/permission-template.md` (exists), `/permission-sweep` command (exists) | `/fewer-permission-prompts` command or skill does not exist anywhere in the repo |
| `CLAUDE.md` line 56 — `check-permission-sanity.sh SessionStart hook` | `check-permission-sanity.sh` script (exists in `.claude/hooks/`) | Not registered as a SessionStart hook in `ai-resources/.claude/settings.json`; only deployed into project-level settings via `/new-project` |

**Resolved since prior audit:** `logs/coaching-log.md` and `logs/workflow-observations.md` now exist. Both were flagged as missing in prior audit.

DELTA: 2 missing files from prior audit (`coaching-log.md`, `workflow-observations.md`) now exist. 1 new partial-feature issue: `/fewer-permission-prompts` referenced in CLAUDE.md does not exist. 1 persistent partial-feature: `check-permission-sanity.sh` described as a SessionStart hook in CLAUDE.md but not registered in ai-resources own settings.json (this is the designed behavior for project deployment, but CLAUDE.md's phrasing implies it runs in ai-resources sessions).

Section summary: 2 issues flagged / 2 prior issues resolved, 2 new issues since 2026-04-18.

---

### 2.6 Task-Type-Specific Instructions in CLAUDE.md

**No violations found.**

The 2 new sections added since 2026-04-18:
- `Maintenance Cadence` (3 lines): Points to `/friday-checkup` command and its output location. No embedded methodology.
- `Permission Management` (3 lines): Describes structural approach and points to `docs/permission-template.md`, `/permission-sweep`, and `check-permission-sanity.sh`. No embedded methodology.

Revised `Model Selection` section (3 lines): States default model tier and rationale; points to workspace CLAUDE.md for the Agent Tier Table. No embedded methodology.

No section embeds skill-creation methodology, workflow-stage instructions, evaluation frameworks, or file-format conventions for a single artifact type.

DELTA: 0 new violations. Prior audit finding of 0 violations unchanged.

Section summary: 0 issues flagged / no change since 2026-04-18.

---

## Section 3: Dependency References

### 3.1 Command File References and Existence Check

All references confirmed or flagged from the prior audit remain. New findings for new commands only:

| Slash Command | Referenced File | File Exists |
|---|---|---|
| architecture-review | `{WORKSPACE_ROOT}/ai-resources/audits/` | Y |
| architecture-review | `system-owner` agent | Y |
| audit-claude-md | `{WORKSPACE}/ai-resources/audits/` | Y |
| audit-claude-md | `.claude/agents/claude-md-auditor.md` | Y |
| audit-critical-resources | `audits/critical-resources-manifest.md` | Y |
| audit-critical-resources | `.claude/agents/critical-resource-auditor.md` | Y |
| consult | `ai-resources/docs/repo-architecture.md` | Y |
| consult | `system-owner` agent | Y |
| deploy-kb | `skills/obsidian-kb-builder/templates/scaffold/` | Y |
| deploy-kb | `skills/obsidian-kb-builder/templates/note-templates/` | Y |
| friday-act | `ai-resources/audits/friday-checkup-*.md` | Y |
| friday-act | `ai-resources/docs/audit-discipline.md` | Y |
| friday-act | `ai-resources/audits/friday-plans/` | Y |
| friday-act | `logs/maintenance-observations.md` | Y |
| friday-checkup | `logs/improvement-log.md` | Y |
| friday-checkup | `logs/session-notes.md` | Y |
| friday-checkup | `logs/friction-log.md` | Y |
| friday-checkup | `permission-sweep-auditor` agent | Y |
| friday-checkup | `improvement-analyst` agent | Y |
| friday-journal | `ai-resources/logs/ai-journal.md` | Y |
| friday-journal | `ai-resources/audits/friday-checkup-*.md` | Y |
| friday-so | `ai-resources/audits/friday-checkup-*.md` | Y |
| friday-so | `projects/axcion-ai-system-owner/output/friday-advisories/` | Y (path exists in projects scope) |
| friday-so | `system-owner` agent | Y |
| implementation-triage | `system-owner` agent | Y |
| innovation-sweep | `.claude/agents/innovation-triage-auditor.md` | Y |
| monday-prep | `ai-resources/docs/weekly-cadence.md` | Y |
| monday-prep | `logs/session-notes.md` | Y |
| monday-prep | `logs/maintenance-observations.md` | Y |
| permission-sweep | `docs/permission-template.md` | Y |
| permission-sweep | `permission-sweep-auditor` agent | Y |
| resolve-improvement-log | `ai-resources/logs/improvement-log.md` | Y |
| resolve-improvement-log | `ai-resources/logs/improvement-log-archive.md` | Y |
| risk-check | `audits/risk-checks/` | Y |
| risk-check | `docs/audit-discipline.md` | Y |
| risk-check | `docs/repo-architecture.md` | Y |
| risk-check | `risk-check-reviewer` agent | Y |
| route-change | `docs/repo-architecture.md` | Y |
| route-change | `docs/audit-discipline.md` | Y |
| route-change | `system-owner` agent | Y |
| session-plan | `logs/session-notes.md` | Y |
| session-plan | `logs/session-plan.md` | Y (created at runtime if absent) |
| session-plan | `skills/ai-resource-builder/references/operational-frontmatter.md` | Y |
| session-plan | `docs/audit-discipline.md` | Y |
| session-start | `logs/session-notes.md` | Y |
| so-monthly | `ai-resources/audits/friday-checkup-*.md` | Y |
| so-monthly | `ai-resources/logs/maintenance-observations.md` | Y |
| so-monthly | `projects/axcion-ai-system-owner/output/monthly-reviews/` | Y (path exists) |
| so-monthly | `system-owner` agent | Y |
| summary | `skills/summary/SKILL.md` | Y |
| systems-review | `projects/axcion-ai-system-owner/vault/research/systems-thinking-for-claude-code.md` | Y |
| systems-review | `projects/axcion-ai-system-owner/output/systems-reviews/` | Y (directory exists) |
| systems-review | `system-owner` agent | Y |
| audit-repo | `reference/skills/repo-health-analyzer/agents/` (project-relative) | **Conditional — N in ai-resources, Y in deployed projects** (unchanged from prior audit) |

**Previously flagged missing files — now resolved:**
- `logs/coaching-log.md` — now exists
- `logs/workflow-observations.md` — now exists

DELTA: All 4 previously flagged missing files resolved (coaching-log.md, workflow-observations.md both now exist). 1 conditional path (audit-repo) persists from prior audit. All 24 new commands have all referenced files present.

Section summary: 1 issue flagged (audit-repo conditional path) / 4 prior issues resolved since 2026-04-18.

---

### 3.2 Command Chain Relationships

All 18 chains from prior audit persist. New chains:

| Chain | Description |
|---|---|
| `/friday-checkup` → `/repo-dd`, `/token-audit`, `/audit-repo`, `/permission-sweep`, `/improve` | friday-checkup orchestrates multiple audit sub-commands depending on cadence tier |
| `/friday-act` → `system-owner` agent (Function F) | friday-act spawns system-owner for advisory synthesis; writes to `friday-plans/` |
| `/friday-so` → `system-owner` agent (Function F) | friday-so spawns system-owner for weekly strategic advisory |
| `/friday-journal` → QC subagent | friday-journal runs inline QC on journal-to-implementation synthesis |
| `/so-monthly` → `system-owner` agent (Function G) | so-monthly spawns system-owner for monthly strategic review |
| `/systems-review` → `system-owner` agent (Function E) | systems-review spawns system-owner for systems-dynamics analysis |
| `/consult` → `system-owner` agent (Function A) | consult spawns system-owner for targeted architectural advisory |
| `/architecture-review` → `system-owner` agent (Function C) | architecture-review synthesizes audit outputs via system-owner |
| `/implementation-triage` → `system-owner` agent (Function D) | implementation-triage delegates ROI verdict to system-owner |
| `/risk-check` → `risk-check-reviewer` agent | risk-check delegates risk verdict to subagent |
| `/route-change` → `system-owner` agent | route-change reads repo-architecture.md and delegates advisory to system-owner |
| `/permission-sweep` → `permission-sweep-auditor` agent | permission-sweep delegates factual settings scan |
| `/audit-claude-md` → `claude-md-auditor` agent | audit-claude-md delegates CLAUDE.md quality audit |
| `/audit-critical-resources` → `critical-resource-auditor` agent | audit-critical-resources delegates multi-dimension resource audit |
| `/innovation-sweep` → `innovation-triage-auditor` agent | innovation-sweep delegates per-item triage verdict |
| `/session-plan` → `qc-reviewer` agent (optional) | session-plan suggests running /qc-pass on the produced plan |
| `/resolve-improvement-log` → `logs/improvement-log-archive.md` | resolve-improvement-log archives applied entries |
| `/monday-prep` → (session setup only) | monday-prep reads logs and writes to session-notes.md; no subagent delegation |

DELTA: 18 new chain relationships added. Total command chains increased from 18 to 36.

Section summary: 36 chain relationships mapped / 18 new since 2026-04-18.

---

### 3.3 Files Referenced by Multiple Commands, Hooks, or Scripts

| File | Referenced By |
|---|---|
| `logs/improvement-log.md` | `/create-skill`, `/improve-skill`, `/improve`, `/wrap-session`, `/resolve-improvement-log`, `/friday-checkup`, `/monday-prep`, `repo-dd` sweep — 8 references |
| `logs/session-notes.md` | `/wrap-session`, `/prime`, `/coach`, `/session-plan`, `/session-start`, `/monday-prep`, `repo-dd` sweep — 7 references |
| `logs/friction-log.md` | `/friction-log`, `/improve`, `/note`, `/wrap-session`, `/friday-checkup`, `repo-dd` sweep — 6 references |
| `logs/innovation-registry.md` | Stop hook, `/wrap-session`, `/prime`, `/graduate-resource`, `repo-dd` sweep — 5 references |
| `logs/decisions.md` | `/wrap-session`, `/prime`, `repo-dd` sweep — 3 references |
| `logs/usage-log.md` | `/usage-analysis`, `/wrap-session` — 2 references |
| `logs/coaching-log.md` | `/coach`, `repo-dd` sweep — 2 references |
| `logs/workflow-observations.md` | `/note`, `repo-dd` sweep — 2 references |
| `skills/ai-resource-builder/SKILL.md` | `/create-skill`, `/improve-skill`, `/migrate-skill` — 3 references |
| `skills/ai-resource-builder/references/evaluation-framework.md` | `/create-skill`, `/improve-skill`, `/migrate-skill` — 3 references |
| `skills/ai-resource-builder/references/operational-frontmatter.md` | `/improve-skill`, `/session-plan` — 2 references |
| `logs/maintenance-observations.md` | `/friday-act`, `/monday-prep`, `/so-monthly` — 3 references |
| `docs/audit-discipline.md` | `/risk-check`, `/route-change`, `/friday-act`, `/session-plan` — 4 references |
| `docs/repo-architecture.md` | `/consult`, `/route-change`, `/risk-check` — 3 references |
| `ai-resources/audits/friday-checkup-*.md` | `/friday-so`, `/friday-act`, `/friday-journal`, `/so-monthly`, `/monday-prep` — 5 references |
| `system-owner` agent | `/consult`, `/architecture-review`, `/implementation-triage`, `/systems-review`, `/friday-so`, `/so-monthly`, `/route-change`, `/friday-act` — 8 references |

DELTA: Significant increase in multi-referenced files. `logs/improvement-log.md` grew from 5 to 8 references. New multi-referenced items: `logs/maintenance-observations.md`, `docs/audit-discipline.md`, `docs/repo-architecture.md`, `audits/friday-checkup-*.md`, `system-owner` agent. All previously missing files (`coaching-log.md`, `workflow-observations.md`) now exist.

Section summary: 16 multi-referenced files identified / significant growth since 2026-04-18.

---

### 3.4 Files Ranked by Downstream Reference Count (Top 10)

| Rank | File | Reference Count | Referenced By |
|---|---|---|---|
| 1 | `system-owner` agent | 8 | `/consult`, `/architecture-review`, `/implementation-triage`, `/systems-review`, `/friday-so`, `/so-monthly`, `/route-change`, `/friday-act` |
| 2 | `logs/improvement-log.md` | 8 | `/create-skill`, `/improve-skill`, `/improve`, `/wrap-session`, `/resolve-improvement-log`, `/friday-checkup`, `/monday-prep`, `repo-dd` sweep |
| 3 | `logs/session-notes.md` | 7 | `/wrap-session`, `/prime`, `/coach`, `/session-plan`, `/session-start`, `/monday-prep`, `repo-dd` sweep |
| 4 | `ai-resources/audits/friday-checkup-*.md` | 5 | `/friday-so`, `/friday-act`, `/friday-journal`, `/so-monthly`, `/monday-prep` |
| 5 | `logs/friction-log.md` | 6 | `/friction-log`, `/improve`, `/note`, `/wrap-session`, `/friday-checkup`, `repo-dd` sweep |
| 6 | `logs/innovation-registry.md` | 5 | Stop hook, `/wrap-session`, `/prime`, `/graduate-resource`, `repo-dd` sweep |
| 7 | `docs/audit-discipline.md` | 4 | `/risk-check`, `/route-change`, `/friday-act`, `/session-plan` |
| 8 | `logs/maintenance-observations.md` | 3 | `/friday-act`, `/monday-prep`, `/so-monthly` |
| 9 | `skills/ai-resource-builder/SKILL.md` | 3 | `/create-skill`, `/improve-skill`, `/migrate-skill` |
| 10 | `docs/repo-architecture.md` | 3 | `/consult`, `/route-change`, `/risk-check` |

DELTA: Rankings shifted substantially. `system-owner` agent entered at rank 1 (8 references). `logs/improvement-log.md` grew from 5 to 8 references. New high-reference files: `docs/audit-discipline.md`, `docs/repo-architecture.md`, `audits/friday-checkup-*.md`, `logs/maintenance-observations.md`. `logs/coaching-data.md` dropped off the top 10 (not referenced by 3+ items).

Section summary: 10 items listed / significant ranking changes since 2026-04-18.

---

### 3.5 Symlinks in .claude/commands/ or .claude/agents/ Without Permission Coverage

Two symlinks exist within AUDIT_ROOT in `workflows/research-workflow/.claude/commands/`:

1. `consult.md` → `../../../.claude/commands/consult.md` (resolves to `ai-resources/.claude/commands/consult.md`)
2. `session-plan.md` → `ai-resources/.claude/commands/session-plan.md` (absolute path)

Both symlink targets are within AUDIT_ROOT (`ai-resources/`). The symlinks are in the workflow **template** directory (`workflows/research-workflow/`), not in the top-level `ai-resources/.claude/commands/` or `.claude/agents/` directories. The template's `settings.json` lists `additionalDirectories: ["{{WORKSPACE_ROOT}}"]` — this is a template placeholder (not a real path) awaiting deployment substitution, which is the expected state for a template.

No symlinks in the top-level `ai-resources/.claude/commands/` or `ai-resources/.claude/agents/` directories.

DELTA: 2 new symlinks since 2026-04-18. Both targets are within AUDIT_ROOT. Permission coverage question is not applicable to the top-level command/agent directories (no symlinks there).

Section summary: 0 issues flagged for top-level command/agent symlinks / 2 workflow-template symlinks with targets internal to AUDIT_ROOT.

---

### 3.6 Projects Referencing ai-resources Without Adequate additionalDirectories Coverage

5 projects in the workspace reference ai-resources (via auto-sync hook and CLAUDE.md):

| Project | How It References ai-resources | additionalDirectories Entry | Coverage |
|---|---|---|---|
| `buy-side-service-plan` | SessionStart hook, symlinked commands/agents | Workspace root `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` | Covered |
| `global-macro-analysis` | SessionStart hook, symlinked commands/agents | Workspace root | Covered |
| `nordic-pe-landscape-mapping-4-26` | SessionStart hook, symlinked commands/agents | Workspace root | Covered |
| `obsidian-pe-kb` | SessionStart hook, symlinked commands/agents | Workspace root | Covered |
| `project-planning` | SessionStart hook, symlinked commands/agents | Workspace root | Covered |

All 5 projects list the workspace root in `permissions.additionalDirectories`. The workspace root is an ancestor of `ai-resources/`, providing coverage.

DELTA: No change. All 5 projects remain covered as in prior audit.

Section summary: 0 issues flagged / no change since 2026-04-18.

---

## Section 4: Consistency Checks

### 4.1 Skill Structural Pattern Consistency

All 70 skills have YAML frontmatter (starting with `---`) containing at minimum `name:` and `description:` fields. All use the lowercase-hyphenated directory naming convention.

**Structural deviations identified:**

| Item | Expected Pattern | Actual State |
|---|---|---|
| `skills/repo-health-analyzer/` | SKILL.md only (or with references/ and scripts/) | Contains `command.md` and `agents/` subdirectory with 8 agent definition files — non-standard. Unchanged from prior audit. |
| 40+ skills predating 2026-04-06 template update | Current template includes "Failure Behavior" section | Non-uniform conformance. Prior audit spot-checked confirmed. Unchanged. |
| 7 skills exceeding 300-line convention | Convention: under 300 lines (per `check-skill-size.sh`) | `answer-spec-generator` 487, `research-plan-creator` 466, `ai-resource-builder` 415, `evidence-to-report-writer` 334, `workflow-evaluator` 318, `ai-prose-decontamination` 316, `workflow-system-critic` 302 |

DELTA: Over-300-line count decreased from 8 to 7 skills. `prose-compliance-qc` dropped from 330 to 212 lines (trimmed). `session-guide-generator` dropped from 320 to 247 lines (trimmed). `ai-prose-decontamination` dropped from 484 to 316 lines (trimmed via relocation refactor). `ai-resource-builder` dropped from 463 to 415 lines (trimmed). `workflow-system-critic` (302 lines) is a new entrant. `answer-spec-generator` slightly grew from 485 to 487. `research-plan-creator` grew from 464 to 466.

Section summary: 3 issues flagged / over-300-line count reduced from 8 to 7 since 2026-04-18.

---

### 4.2 Slash Command Definition Pattern Consistency

All 53 commands are markdown files in `.claude/commands/`. No command uses a non-.md extension.

**Pattern inconsistencies found:**

Commands use varied opening patterns. The prior audit finding (no single enforced format standard) persists. Two newly identified deviations:

| Item | Expected Pattern | Actual State |
|---|---|---|
| `save-session.md` | Explicit `model:` in YAML frontmatter (per workspace CLAUDE.md) | No YAML frontmatter at all — starts with prose |
| `session-start.md` | Explicit `model:` in YAML frontmatter | Has `---` separators but they are markdown separators (line 1 is prose), not YAML frontmatter; no `model:` declaration |
| All other commands | Variable (as noted in prior audit) | All other 51 commands have YAML frontmatter with `model:` declared |

DELTA: 51 out of 53 commands now have YAML frontmatter with `model:`. `save-session.md` and `session-start.md` are the only 2 without a `model:` declaration. Prior audit noted general format inconsistency; the specific `model:` frontmatter requirement is now the operative standard per workspace CLAUDE.md ("New commands: declare an explicit tier in frontmatter — never inherit").

Section summary: 1 issue flagged (2 commands missing model: declaration) / most commands now comply with frontmatter standard.

---

### 4.3 Skill Template Comparison

N/A — No skill creation template file exists. Skills are created via `/create-skill` which references `ai-resources/skills/ai-resource-builder/SKILL.md` for format standards.

**5 most recently modified skills:** `obsidian-kb-builder` (2026-05-04/05), `supplementary-query-brief-drafter` (2026-05-02), `ai-resource-builder` (2026-04-29), `ai-prose-decontamination` (2026-04-29), `session-usage-analyzer` (2026-04-25).

**ai-resource-builder SKILL.md last modified:** 2026-04-29. Referenced `evaluation-framework.md` last modified: 2026-04-09.

All 5 most recently modified skills contain "Failure" mentions (failure behavior present): `obsidian-kb-builder` (2 mentions), `supplementary-query-brief-drafter` (5 mentions), `ai-resource-builder` (6 mentions), `ai-prose-decontamination` (3 mentions), `session-usage-analyzer` (1 mention).

The 40 skills created before the 2026-04-06 template update (when "Failure Behavior" section was added) continue to have non-uniform conformance. Spot-checks from prior audit remain valid.

DELTA: 5 most recently modified skills all conform to current template standards. No new structural discrepancies found in recent skills.

Section summary: 0 new issues flagged for recent skills / pre-template conformance non-uniformity persists for ~40 older skills.

---

### 4.4 Naming Convention Inconsistencies

**One naming inconsistency persists (unchanged from prior audit):**

| Item | Convention | Deviation |
|---|---|---|
| `skills/CATALOG.md` | All files under `skills/` are expected to be in per-skill subdirectories | `CATALOG.md` is a flat file at `skills/` root, not in a subdirectory |
| All 70 skill directories | Lowercase-hyphenated names | All comply |
| All 53 commands | Lowercase-hyphenated `.md` names | All comply |
| All 26 agents | Lowercase-hyphenated `.md` names | All comply |

DELTA: No new naming convention violations. Prior finding persists.

Section summary: 1 issue flagged / unchanged since 2026-04-18.

---

### 4.5 Directory Structure Violations

**CLAUDE.md-declared structure:**

| Directory | Declared Purpose | Actual State |
|---|---|---|
| `skills/` | Canonical skill library | Contains 70 skill dirs + `CATALOG.md` (flat file) + `.gitkeep` |
| `prompts/` | Standalone prompts for cross-tool workflows | Contains `supplementary-research/` subdirectory only |
| `reports/` | Generated audit and health reports | Contains `repo-health-report.md` only |
| `logs/` | Session notes, decisions, innovation registry | Contains 14 files + `scripts/` subdirectory (2 scripts). All referenced files now exist. |
| `audits/` | Due diligence and audit artifacts | Contains 28+ report files + `working/` + `risk-checks/` + `friday-plans/` subdirectories |
| `docs/` | Process documentation (session rituals, etc.) | Contains 19 files. CLAUDE.md says "session rituals, etc." — understates the directory's current scope (17 new docs added since 2026-04-18). |
| `scripts/` | Utility scripts for repo maintenance | Contains `repo-audit.sh` and `skill-inventory.sh` |
| `style-references/` | Style reference materials | Contains `internal-material.md` only |
| `usage/` | Not declared in CLAUDE.md | Now empty — `usage-log.md` moved to `logs/`. Empty directory persists but is unlisted in CLAUDE.md. |
| `inbox/` | Intake queue for resource briefs | Contains 3 active documents + `archive/` subdirectory + `.gitkeep` |
| `workflows/` | Deployable workflow templates | Contains `research-workflow/` template only |

**Active violations:**
1. `usage/` directory exists but is not listed in CLAUDE.md "What This Repo Contains" section. Now empty; prior violation of having undocumented content resolved by migration to `logs/`.
2. `docs/` description in CLAUDE.md ("session rituals, etc.") understates the directory's actual scope — 19 files spanning process docs, canonical rules, tier tables, discipline documents extracted from workspace CLAUDE.md. Not a hard violation but a staleness note.

DELTA: Prior violations 2 and 3 (`logs/coaching-log.md` and `logs/workflow-observations.md` missing) resolved — both files now exist. `usage/usage-log.md` moved to `logs/usage-log.md`. `usage/` is now empty but persists as an undocumented empty directory. `docs/` grew from 2 to 19 files without corresponding CLAUDE.md update to its description.

Section summary: 2 issues flagged (empty unlisted `usage/` dir; `docs/` description understates scope) / 2 prior issues resolved since 2026-04-18.

---

### 4.6 Command Syntax and File Path Resolution Check

All 53 commands have syntactically valid markdown. New commands checked:

| Command | Syntax Valid | All Referenced Paths Resolve |
|---|---|---|
| architecture-review | Y | Y |
| audit-claude-md | Y | Y |
| audit-critical-resources | Y | Y |
| consult | Y | Y |
| deploy-kb | Y | Y |
| friday-act | Y | Y |
| friday-checkup | Y | Y |
| friday-journal | Y | Y |
| friday-so | Y | Y |
| implementation-triage | Y | Y |
| innovation-sweep | Y | Y |
| monday-prep | Y | Y |
| permission-sweep | Y | Y |
| recommend | Y | Y |
| resolve-improvement-log | Y | Y |
| resolve | Y | Y |
| risk-check | Y | Y |
| route-change | Y | Y |
| save-session | Y | Conditional — references `logs/scratchpads/` directory (created at runtime; no pre-existing directory required) |
| session-plan | Y | Y |
| session-start | Y | Y |
| so-monthly | Y | Y |
| summary | Y | Y |
| systems-review | Y | Y — references `projects/axcion-ai-system-owner/vault/research/systems-thinking-for-claude-code.md` (exists outside AUDIT_ROOT; verified accessible) |
| audit-repo | Y | Conditional — unchanged from prior audit |

DELTA: All 24 new commands pass syntax and path resolution checks. `audit-repo` context-dependent path persists from prior audit.

Section summary: 1 issue flagged (audit-repo conditional path, unchanged) / 0 new path resolution issues in new commands.

---

### 4.7 Duplicate or Built-in Command Name Conflicts

No duplicate command names found among the 53 commands.

Known Claude Code built-ins checked: `/clear`, `/compact`, `/help`, `/exit`, `/quit`, `/memory`, `/config`, `/add-dir`. None of the 53 commands match these names.

`/summary` and `/resolve` are common words but are not known Claude Code built-ins.

DELTA: No new conflicts. 24 new commands checked against built-ins and against each other.

Section summary: 0 issues flagged / unchanged since 2026-04-18.

---

### 4.8 Agent Model Tier Compliance

Compared against Agent Tier Table in `ai-resources/docs/agent-tier-table.md` (26 agents total, all in table).

| Agent File | Declared Tier | Expected Tier (Table) | Status |
|---|---|---|---|
| claude-md-auditor.md | opus | opus | Match |
| collaboration-coach.md | opus | opus | Match |
| critical-resource-auditor.md | opus | opus | Match |
| dd-extract-agent.md | haiku | haiku | Match |
| dd-log-sweep-agent.md | haiku | haiku | Match |
| execution-agent.md | sonnet | sonnet | Match |
| findings-extractor.md | haiku | haiku | Match |
| improvement-analyst.md | opus | opus | Match |
| innovation-triage-auditor.md | opus | opus | Match |
| permission-sweep-auditor.md | sonnet | sonnet | Match |
| pipeline-stage-3a.md | sonnet | sonnet | Match |
| pipeline-stage-3b.md | opus | opus | Match |
| pipeline-stage-3c.md | opus | opus | Match |
| pipeline-stage-4.md | sonnet | sonnet | Match |
| pipeline-stage-5.md | sonnet | sonnet | Match |
| qc-reviewer.md | opus | opus | Match |
| refinement-reviewer.md | opus | opus | Match |
| repo-dd-auditor.md | sonnet | sonnet | Match |
| risk-check-reviewer.md | opus | opus | Match |
| session-guide-generator.md | sonnet | sonnet | Match |
| system-owner.md | opus | opus | Match |
| token-audit-auditor-mechanical.md | haiku | haiku | Match |
| token-audit-auditor.md | opus | opus | Match |
| triage-reviewer.md | opus | opus | Match |
| workflow-analysis-agent.md | opus | opus | Match |
| workflow-critique-agent.md | opus | opus | Match |

All 26 agents match the tier table. `pipeline-stage-4` was at `inherit` in the prior audit and has been retrofitted to `sonnet` (both in the agent file and the tier table). `pipeline-stage-2.md` and `pipeline-stage-2-5.md` were removed; they no longer exist as files and are absent from the tier table.

DELTA: Agent count grew from 21 to 26. 5 new agents added: `claude-md-auditor`, `critical-resource-auditor`, `findings-extractor`, `innovation-triage-auditor`, `risk-check-reviewer`, `permission-sweep-auditor`, `system-owner`. (Note: the operator instruction states findings-extractor, innovation-triage-auditor, and system-owner were just added and should not be flagged missing — all are now present in both the table and as agent files.) `pipeline-stage-4` retrofitted from `inherit` to `sonnet`. `pipeline-stage-2` and `pipeline-stage-2-5` deleted.

Section summary: 0 issues flagged / all 26 agents match tier table.

---

### 4.9 Project Settings Comparison Against Canonical Baseline

N/A — out of scope for ai-resources repo. No `projects/` directory exists within AUDIT_ROOT. Projects reside at the workspace level (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/`), outside AUDIT_ROOT scope.

Section summary: N/A — out of scope for ai-resources repo.

---

## Section 5: Context Load

### 5.1 Context Load at Session Start

When a new session starts in the `ai-resources` repo:

| File | Line Count | Load Mechanism |
|---|---|---|
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` (workspace) | 161 lines | Loaded because workspace root is in `additionalDirectories` (`~/.claude/settings.json`) |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md` (project) | 92 lines | Loaded as project CLAUDE.md |

**Estimated total context at session start: ~253 lines** (two CLAUDE.md files).

DELTA: Total context load decreased from ~365 lines to ~253 lines (-112 lines). Workspace CLAUDE.md decreased from 282 to 161 lines (8 methodology blocks extracted to `docs/` files on 2026-05-04). ai-resources CLAUDE.md grew from 83 to 92 lines (+9 lines, 2 new sections).

Section summary: 0 issues flagged / context load decreased by ~112 lines since 2026-04-18.

---

### 5.2 CLAUDE.md Sections Not Referenced by Any Command or Hook

| Section | Approximate Lines | Assessment |
|---|---|---|
| What This Repo Contains | 14 | Orienting context only. Not directly invoked by any command. Describes directory layout. |
| How I Work | 3 | Identity/working style context. Not referenced by commands. |
| General Session Rules | 5 | Behavioral rules (don't create unrequested files, pull latest, etc.). Not referenced by any specific command. |
| Session Boundaries | 3 | Behavioral rule for operator. Referenced as a canonical block in `/new-project`. |

DELTA: No change from prior audit. Same 3 sections identified as unreferenced by commands/hooks.

Section summary: 3 sections identified as unreferenced by commands/hooks / unchanged since 2026-04-18.

---

### 5.3 CLAUDE.md Line Count History (Last 5 Modifying Commits)

| Commit Hash | Date | Line Count |
|---|---|---|
| f76c1fe | 2026-04-29 | 92 lines |
| fd3523e | 2026-04-25 | 92 lines |
| 820e7fa | 2026-04-24 | 92 lines |
| ffc9b2d | 2026-04-22 | 88 lines |
| 5f4223e | 2026-04-18 | 83 lines |

The file grew steadily from 83 (2026-04-18) → 88 (2026-04-22, Maintenance Cadence + Permission Management sections added) → 92 (2026-04-24/25, model-routing content briefly present then removed). Current 92-line state is stable.

DELTA: Prior audit showed all 5 commits on 2026-04-18 with range 74–92 lines. Current history spans 2026-04-18 through 2026-04-29, showing net growth from 83 to 92 lines.

Section summary: 0 issues flagged / stable at 92 lines since 2026-04-22.

---

## Section 6: Drift & Staleness

### 6.1 Files Not Modified in Last 90 Days But Referenced by Active Commands

90-day cutoff: 2026-02-07 (90 days before 2026-05-08).

Checked all files referenced by active commands. All script files under `scripts/` (last modified 2026-02-20) and all `skills/` SKILL.md files are more recent than 2026-02-07.

The oldest referenced files found:
- `skills/claude-code-workflow-builder/references/feature-patterns.md` — last commit 2026-02-21 (not referenced by any active command, only by its own skill)
- `skills/context-pack-builder/SKILL.md` — last commit 2026-04-29 (was 2026-02-20 at prior audit; has been updated)

None found — checked all command-referenced files. No file referenced by an active command (slash command, hook, or CLAUDE.md) was last modified before 2026-02-07.

DELTA: No staleness flags. Previously borderline files (`context-pack-builder/SKILL.md`, `workflow-consultant/SKILL.md`) have been updated since 2026-04-18.

Section summary: 0 issues flagged / unchanged since 2026-04-18.

---

### 6.2 TODO, FIXME, PLACEHOLDER Marker Comments

| File | Line | Marker | Context |
|---|---|---|---|
| `.claude/commands/new-project.md` | Multiple | "placeholder" | `{{PLACEHOLDER}}` substitution instructions — operational content |
| `.claude/commands/deploy-workflow.md` | 265–266 | "placeholder" | `{{PLACEHOLDER_1}}`, `{{PLACEHOLDER_2}}` substitution instructions — operational content |
| `.claude/commands/repo-dd.md` | 286, 298 | "placeholder" | "placeholder definitions" check and "Replace the Section 4 placeholder" — operational instruction |
| `skills/implementation-spec-writer/SKILL.md` | 50, 254, 257 | "PLACEHOLDER" | `{{PLACEHOLDER}}` template markers — operational content |
| `skills/workflow-evaluator/SKILL.md` | 314 | "TODO" | "do not penalize TODO sections" — describes evaluation behavior, not a task marker |
| `skills/workspace-template-extractor/SKILL.md` | 31, 100 | "placeholder" | `{{PLACEHOLDER}}` markers — operational content |
| `workflows/research-workflow/SETUP.md` | 26, 135 | "PLACEHOLDER" | `{{PLACEHOLDER}}` substitution instructions — operational content |

No standalone `TODO:`, `FIXME:`, or `PLACEHOLDER:` markers indicating incomplete or deferred work found in new files added since 2026-04-18 (checked all new `.claude/commands/`, `.claude/agents/`, `docs/`, `.claude/hooks/` files).

DELTA: No new task-marker comments found in any files added since 2026-04-18.

Section summary: 0 issues flagged / unchanged since 2026-04-18.

---

### 6.3 Empty, Stub, or Boilerplate-Only Files

| File | State |
|---|---|
| `skills/.gitkeep` | Empty placeholder file — intentional |
| `inbox/.gitkeep` | Empty placeholder file — intentional |
| `workflows/research-workflow/**/.gitkeep` (multiple) | Empty placeholder files — intentional |
| `usage/` directory | Now empty — `usage-log.md` migrated to `logs/`. Directory itself has no `.gitkeep` but persists as an empty directory. Not tracked by git as an empty directory (git does not track empty directories without `.gitkeep`). |
| `.claude/settings.local.json` | Contains only `{}` (2 bytes of content, empty JSON object). |

No stub SKILL.md files found. New `docs/` files (analytical-output-principles.md, compaction-protocol.md, plan-mode-discipline.md, etc.) contain real content ranging from 8 to 287 lines; none are boilerplate-only.

DELTA: `usage/` directory is now empty (previously contained `usage-log.md`). `settings.local.json` contains an empty JSON object `{}` — technically valid but contains no configuration.

Section summary: 0 issues flagged / `usage/` directory now empty, `settings.local.json` is empty `{}`.

---

## Audit Summary

**Total findings: 18**

| Category | Count |
|---|---|
| Discrepancy (item exists but is inconsistent with spec or another item) | 7 |
| Missing item (referenced file or content that does not exist) | 1 |
| Violation (rule or convention defined and not followed) | 5 |
| Clean check (no issues found) | 5 |

**Findings by section:**

| Section | Finding | Type |
|---|---|---|
| 2.2 | `/fewer-permission-prompts` referenced in CLAUDE.md line 56 does not exist as a command or skill | Missing item |
| 2.2 | CLAUDE.md line 16 states "this repo itself does not host a canonical usage log" — factually inaccurate; `logs/usage-log.md` exists and is actively written | Discrepancy |
| 2.3 | CLAUDE.md contradiction persists: "How I Work" line 22 vs "Commit Rules" line 75 | Discrepancy |
| 2.4 | CATALOG.md out of date: 10 skills absent (ai-prose-decontamination, formatting-qc, fund-triage-scanner, intake-processor, obsidian-kb-builder, prose-refinement-writer, summary, workflow-system-analyzer, workflow-system-critic, worktree-cleanup-investigator) | Missing item (content gap) |
| 2.4 | `skills/repo-health-analyzer/` contains non-standard `command.md` and `agents/` subdir | Violation |
| 2.5 | `check-permission-sanity.sh` described in CLAUDE.md as "SessionStart hook" but not registered in ai-resources own `settings.json` | Discrepancy |
| 4.1 | 7 skills exceed 300-line convention: answer-spec-generator (487), research-plan-creator (466), ai-resource-builder (415), evidence-to-report-writer (334), workflow-evaluator (318), ai-prose-decontamination (316), workflow-system-critic (302) | Violation |
| 4.1 | 40+ skills predate 2026-04-06 template update; conformance to "Failure Behavior" section is non-uniform | Discrepancy |
| 4.2 | `save-session.md` has no YAML frontmatter and no `model:` declaration (required per workspace CLAUDE.md) | Violation |
| 4.2 | `session-start.md` has no `model:` declaration (required per workspace CLAUDE.md) | Violation |
| 4.4 | `skills/CATALOG.md` is a flat file at `skills/` root, not in a subdirectory | Violation |
| 4.5 | `usage/` directory exists but is empty and not listed in CLAUDE.md "What This Repo Contains" | Discrepancy |
| 4.5 | `docs/` description in CLAUDE.md ("session rituals, etc.") understates directory scope: 19 files, 17 added since 2026-04-18 | Discrepancy |
| 4.7 | No duplicate or built-in command conflicts | Clean check |
| 4.8 | All 26 agents match Agent Tier Table | Clean check |
| 5.2 | "What This Repo Contains", "How I Work", "General Session Rules" sections not referenced by commands/hooks — load context overhead | Discrepancy |
| 6.1 | No stale referenced files found | Clean check |
| 6.2 | No task-marker TODO/FIXME/PLACEHOLDER comments found | Clean check |
| 6.3 | No empty stub files beyond intentional .gitkeep; `settings.local.json` is empty `{}` | Clean check |

**Resolved since 2026-04-18 audit:**

| Prior Finding | Resolution |
|---|---|
| `logs/coaching-log.md` missing | Now exists |
| `logs/workflow-observations.md` missing | Now exists |
| Three-way CLAUDE.md contradiction (How I Work + Git Rules + Commit Rules) | Reduced to two-way (Git Rules "Always show diff" bullet removed) |
| `pipeline-stage-4` at `inherit` tier, deferred migration | Retrofitted to `sonnet` |
| 8 skills over 300 lines | Reduced to 7 (prose-compliance-qc, session-guide-generator, ai-prose-decontamination, ai-resource-builder all trimmed) |

**Previous audit finding count: 19. Current finding count: 18.**
