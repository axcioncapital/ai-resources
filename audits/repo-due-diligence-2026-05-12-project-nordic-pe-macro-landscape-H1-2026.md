# Repo Due Diligence Audit — 2026-05-12
Repo: projects/nordic-pe-macro-landscape-H1-2026
Scope: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026
Commit: a42d382
Previous audit: None
Depth: standard

---

## Section 1: Inventory

### 1.1 Slash Commands

**Local commands** (regular files in `.claude/commands/`, not symlinks — 21 files):

| Command | File | References |
|---|---|---|
| audit-structure | `.claude/commands/audit-structure.md` | `reference/file-conventions.md`, `reference/stage-instructions.md`, `reference/style-guide.md`, `reference/quality-standards.md` |
| create-context-pack | `.claude/commands/create-context-pack.md` | `ai-resources/skills/context-pack-builder/SKILL.md` |
| inject-dependency | `.claude/commands/inject-dependency.md` | No specific file references (conceptual instructions) |
| intake-reports | `.claude/commands/intake-reports.md` | `ai-resources/skills/research-extract-creator/SKILL.md`, `ai-resources/skills/research-extract-verifier/SKILL.md` |
| produce-architecture | `.claude/commands/produce-architecture.md` | `ai-resources/skills/architecture-designer/SKILL.md`, `ai-resources/skills/architecture-qc/SKILL.md` |
| produce-formatting | `.claude/commands/produce-formatting.md` | `ai-resources/skills/prose-formatter/SKILL.md`, `ai-resources/skills/h3-title-pass/SKILL.md`, `ai-resources/skills/formatting-qc/SKILL.md`, `ai-resources/skills/document-integration-qc/SKILL.md`, `logs/decisions.md` |
| produce-knowledge-file | `.claude/commands/produce-knowledge-file.md` | `reference/skills/knowledge-file-producer/SKILL.md` (local skill) |
| produce-prose-draft | `.claude/commands/produce-prose-draft.md` | `ai-resources/skills/evidence-to-report-writer/SKILL.md`, `ai-resources/skills/ai-prose-decontamination/SKILL.md`, `ai-resources/skills/chapter-prose-reviewer/SKILL.md`, `ai-resources/skills/editorial-recommendations-generator/SKILL.md`, `ai-resources/skills/prose-compliance-qc/SKILL.md`, `ai-resources/skills/editorial-recommendations-qc/SKILL.md`, `logs/decisions.md` |
| review-chapter | `.claude/commands/review-chapter.md` | `ai-resources/skills/chapter-review/SKILL.md`, `logs/qc-log.md` |
| run-analysis | `.claude/commands/run-analysis.md` | `ai-resources/skills/gap-assessment-gate/SKILL.md`, `ai-resources/skills/analysis-pass-memo-review/SKILL.md`, `ai-resources/skills/editorial-recommendations-generator/SKILL.md`, `ai-resources/skills/editorial-recommendations-qc/SKILL.md`, `ai-resources/skills/citation-converter/SKILL.md`, `ai-resources/skills/section-directive-drafter/SKILL.md`, `logs/qc-log.md` |
| run-cluster | `.claude/commands/run-cluster.md` | `ai-resources/skills/cluster-analysis-pass/SKILL.md`, `ai-resources/skills/cluster-memo-refiner/SKILL.md`, `logs/qc-log.md` |
| run-execution | `.claude/commands/run-execution.md` | `ai-resources/skills/answer-spec-qc/SKILL.md`, `ai-resources/skills/execution-manifest-creator/SKILL.md`, `ai-resources/skills/research-prompt-creator/SKILL.md`, `ai-resources/skills/research-prompt-qc/SKILL.md`, `ai-resources/skills/research-extract-creator/SKILL.md`, `ai-resources/skills/research-extract-verifier/SKILL.md`, `ai-resources/skills/supplementary-query-brief-drafter/SKILL.md`, `ai-resources/skills/supplementary-evidence-merger/SKILL.md`, `ai-resources/skills/supplementary-research-qc/SKILL.md` |
| run-preparation | `.claude/commands/run-preparation.md` | `ai-resources/skills/task-plan-creator/SKILL.md`, `ai-resources/skills/research-plan-creator/SKILL.md`, `ai-resources/skills/answer-spec-generator/SKILL.md`, `ai-resources/skills/answer-spec-qc/SKILL.md`, `logs/qc-log.md` |
| run-report | `.claude/commands/run-report.md` | `ai-resources/skills/evidence-prose-fixer/SKILL.md`, `ai-resources/skills/cluster-synthesis-drafter/SKILL.md`, `ai-resources/skills/report-compliance-qc/SKILL.md` (via ai-resources path), `logs/qc-log.md`, `logs/decisions.md` |
| run-synthesis | `.claude/commands/run-synthesis.md` | `ai-resources/skills/decision-to-prose-writer/SKILL.md`, `logs/qc-log.md` |
| session-plan | `.claude/commands/session-plan.md` | `logs/session-notes.md`, `logs/improvement-log.md`, `logs/friction-log.md`, `logs/decisions.md` |
| status | `.claude/commands/status.md` | `logs/qc-log.md` |
| update-claude-md | `.claude/commands/update-claude-md.md` | `CLAUDE.md` |
| verify-chapter | `.claude/commands/verify-chapter.md` | `ai-resources/skills/evidence-spec-verifier/SKILL.md`, `logs/decisions.md`, `logs/qc-log.md` |
| workflow-status | `.claude/commands/workflow-status.md` | `reference/stage-instructions.md`, `ai-resources/skills/workflow-evaluator/SKILL.md`, `.claude/agents/verification-agent.md` |
| wrap-session | `.claude/commands/wrap-session.md` | `logs/session-notes.md`, `logs/decisions.md`, `logs/innovation-registry.md` |

**Symlinked commands** (54 symlinks pointing to `ai-resources/.claude/commands/`):

analyze-workflow, architecture-review, audit-claude-md, audit-critical-resources, audit-repo, clarify, cleanup-worktree, coach, consult, create-skill, deploy-kb, deploy-workflow, explain, friction-log, friday-act, friday-checkup, friday-journal, friday-so, graduate-resource, implementation-triage, improve, improve-skill, innovation-sweep, log-sweep, migrate-skill, monday-prep, new-project, note, open-items, permission-sweep, prime, project-consultant, qc-pass, recommend, refinement-deep, refinement-pass, repo-dd, request-skill, resolve, resolve-improvement-log, risk-check, route-change, save-session, scope, session-guide, session-start, so-monthly, summary, sync-workflow, systems-review, token-audit, triage, usage-analysis

Total: 75 commands (21 local + 54 symlinked).

Section summary: 75 commands catalogued / no previous audit.

### 1.2 Hooks

Configured in `.claude/settings.json`:

| Trigger | Hook | Script | Action |
|---|---|---|---|
| PreToolUse (Read\|Grep\|Bash) | check-heavy-tool | `.claude/hooks/check-heavy-tool.sh` | Flags heavy tool use |
| PreToolUse (Skill) | friction-log-auto | `.claude/hooks/friction-log-auto.sh` | Checks friction log before skill invocation |
| PreToolUse (Edit) | bright-line check | Inline jq command (no external script) | Blocks edits to `report/chapters/` or `final/modules/` without operator approval |
| PostToolUse (Write) | auto-commit | Inline shell command (no external script) | Auto-commits artifacts under `preparation/`, `execution/`, `analysis/`, `report/` |
| PostToolUse (Write) | log-write-activity | `.claude/hooks/log-write-activity.sh` | Logs write activity |
| PostToolUse (Write) | detect-innovation | `.claude/hooks/detect-innovation.sh` | Checks for innovation patterns |
| PostToolUse (Write) | auto-qc-nudge | `.claude/hooks/auto-qc-nudge.sh` | Nudges QC after significant artifact writes |
| PostToolUse (Edit) | log-write-activity | `.claude/hooks/log-write-activity.sh` | Logs write activity |
| PostToolUse (Edit) | detect-innovation | `.claude/hooks/detect-innovation.sh` | Checks for innovation patterns |
| PostToolUse (Edit) | auto-qc-nudge | `.claude/hooks/auto-qc-nudge.sh` | Nudges QC after significant edits |
| SessionStart (1 of 2) | checkpoint-loader | Inline shell command | Finds latest checkpoint and surfaces context |
| SessionStart (1 of 2) | check-template-drift | Walker → `ai-resources/.claude/hooks/check-template-drift.sh` | Checks for template drift |
| SessionStart (1 of 2) | auto-sync-shared | Walker → `ai-resources/.claude/hooks/auto-sync-shared.sh` | Syncs shared commands from ai-resources |
| SessionStart (1 of 2) | check-archive | `logs/scripts/check-archive.sh` | Checks log file sizes, archives if over threshold |
| SessionStart (2 of 2) | friday-checkup-reminder | `.claude/hooks/friday-checkup-reminder.sh` | Checks Friday cadence |
| Stop (1 of 4) | checkpoint-check | Inline shell command | Warns if no checkpoint written this session |
| Stop (2 of 4) | session-wrap-check | Inline shell command | Warns if `/wrap-session` not run |
| Stop (3 of 4) | check-stop-reminders | `.claude/hooks/check-stop-reminders.sh` | Session-end reminder checks |
| Stop (4 of 4) | coach-reminder | `.claude/hooks/coach-reminder.sh` | Checks coach reminder |
| Stop (4 of 4) | improve-reminder | `.claude/hooks/improve-reminder.sh` | Checks improve reminder |
| Stop (5 of 5) | auto-resolve-nudge | `.claude/hooks/auto-resolve-nudge.sh` | Checks for unresolved QC findings |
| UserPromptSubmit | decision-logger | Inline jq command | Appends operator decisions to `logs/decisions.md` |

No `.claude/settings.local.json` file exists in AUDIT_ROOT.

Section summary: 22 hook trigger/script pairs catalogued across 5 event types / no previous audit.

### 1.3 Template Files

| File | Purpose | Referenced By | Last Commit Date |
|---|---|---|---|
| `reference/templates/.gitkeep` | Placeholder to keep empty templates directory in git | No commands reference this; directory noted in `audit-structure.md` | 2026-05-12 |

No populated template files exist in AUDIT_ROOT. The `reference/templates/` directory contains only a `.gitkeep`.

Section summary: 1 placeholder template file (empty directory) catalogued / no previous audit.

### 1.4 Scripts (Non-Template, Non-Skill)

| File | What It Does | What Calls It |
|---|---|---|
| `.claude/hooks/auto-qc-nudge.sh` | Nudges operator toward QC after significant artifact writes | PostToolUse Write and Edit hooks in settings.json |
| `.claude/hooks/auto-resolve-nudge.sh` | Checks for unresolved QC findings at session end | Stop hook in settings.json |
| `.claude/hooks/check-claim-ids.sh` | Checks claim IDs (purpose: validate claim ID formatting) | Not referenced in settings.json — present but unconfigured |
| `.claude/hooks/check-heavy-tool.sh` | Flags heavy tool calls | PreToolUse Read\|Grep\|Bash hook in settings.json |
| `.claude/hooks/check-permission-sanity.sh` | Checks permissions for sanity | Not referenced in settings.json — present but unconfigured |
| `.claude/hooks/check-skill-size.sh` | Checks skill file sizes | Not referenced in settings.json — present but unconfigured |
| `.claude/hooks/check-stop-reminders.sh` | Session-end reminder checks | Stop hook in settings.json |
| `.claude/hooks/coach-reminder.sh` | Coach reminder at session end | Stop hook in settings.json |
| `.claude/hooks/detect-innovation.sh` | Detects innovation patterns in written artifacts | PostToolUse Write and Edit hooks in settings.json |
| `.claude/hooks/friction-log-auto.sh` | Auto-starts friction log when Skill tool is called | PreToolUse Skill hook in settings.json |
| `.claude/hooks/friday-checkup-reminder.sh` | Friday cadence reminder | SessionStart hook in settings.json |
| `.claude/hooks/improve-reminder.sh` | Improve reminder at session end | Stop hook in settings.json |
| `.claude/hooks/log-write-activity.sh` | Logs write/edit activity | PostToolUse Write and Edit hooks in settings.json |
| `logs/scripts/check-archive.sh` | Archives log files when they exceed line thresholds; warns if at 1.5x threshold | SessionStart hook in settings.json |
| `logs/scripts/split-log.sh` | Splits and archives a log file, keeping N entries | Called by check-archive.sh |

Section summary: 15 scripts catalogued (13 hooks, 2 log-management scripts); 3 hook scripts present but not configured in settings.json / no previous audit.

### 1.5 Skills

**Total skills in AUDIT_ROOT:** 70 (68 symlinks to ai-resources + 2 local directories).

**Location:** `reference/skills/`

**All 70 skill directories have a SKILL.md file.** No skills are missing a SKILL.md.

**68 symlinked skills** (all link to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/[name]/`):
ai-prose-decontamination, ai-resource-builder, analysis-pass-memo-review, answer-spec-generator, answer-spec-qc, architecture-designer, architecture-qc, chapter-prose-reviewer, chapter-review, citation-converter, claude-code-workflow-builder, cluster-analysis-pass, cluster-memo-refiner, cluster-synthesis-drafter, context-pack-builder, curiosity-hub-article-writer, decision-to-prose-writer, document-integration-qc, editorial-recommendations-generator, editorial-recommendations-qc, evidence-prose-fixer, evidence-spec-verifier, evidence-to-report-writer, execution-manifest-creator, formatting-qc, fund-triage-scanner, gap-assessment-gate, h3-title-pass, implementation-project-planner, implementation-spec-writer, intake-processor, journal-thinking-clarifier, journal-wiki-creator, journal-wiki-improver, journal-wiki-integrator, knowledge-file-completeness-qc, obsidian-kb-builder, project-implementer, project-tester, prompt-creator, prose-compliance-qc, prose-formatter, prose-refinement-writer, repo-health-analyzer, research-extract-creator, research-extract-verifier, research-plan-creator, research-prompt-creator, research-prompt-qc, research-structure-creator, section-directive-drafter, session-guide-generator, session-usage-analyzer, spec-writer, specifying-output-style, summary, supplementary-evidence-merger, supplementary-query-brief-drafter, supplementary-research-qc, task-plan-creator, workflow-consultant, workflow-creator, workflow-documenter, workflow-evaluator, workflow-system-analyzer, workflow-system-critic, workspace-template-extractor, worktree-cleanup-investigator

**2 local skill directories** (not symlinks — project-owned copies):
- `reference/skills/knowledge-file-producer/` — contains SKILL.md; also exists in `ai-resources/skills/`
- `reference/skills/report-compliance-qc/` — contains SKILL.md; also exists in `ai-resources/skills/`

Section summary: 70 skills catalogued; 0 missing SKILL.md; 2 local copies duplicate ai-resources skills / no previous audit.

### 1.6 Uncategorized Items

| Item | Path | Notes |
|---|---|---|
| Shared manifest | `.claude/shared-manifest.json` | Auto-sync configuration file for `auto-sync-shared.sh` hook |
| Project artifacts | `pipeline/context-pack.md`, `pipeline/project-plan.md` | Planning documents; inputs to the project pipeline |
| Log stub files | `logs/innovation-registry.md`, `logs/research-quality-log.md`, `logs/session-notes.md`, `logs/session-plan.md` | Operational log files with boilerplate headers and one session entry |
| SOP documents | `reference/sops/evidence-pack-compressor-gpt.md`, `reference/sops/fact-verification-prompt.md`, `reference/sops/research-executor-gpt.md` | Standard operating procedures for Research Execution GPT and Perplexity |
| Reference scoping notes | `reference/scoping-notes/.gitkeep` | Empty placeholder directory |
| Stage placeholder directories | 22 `.gitkeep` files across `analysis/`, `execution/`, `preparation/`, `report/`, `final/`, `output/`, `reports/`, `usage/` | Empty directories awaiting pipeline artifact production |
| Gitignore | `.gitignore` | Contains only `.DS_Store` — `settings.local.json` is not gitignored |

Section summary: 7 item categories uncategorized / no previous audit.

### 1.7 Symlinks

**Commands symlinks** (54 total — all in `.claude/commands/`):

All 54 command symlinks point to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/[name].md` and are accessible (targets exist).

**Note on link style:** 54 command symlinks use absolute paths. None use relative paths.

**Agent symlinks** (25 total — all in `.claude/agents/`):

| Symlink | Target | Style | Accessible |
|---|---|---|---|
| claude-md-auditor.md | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/claude-md-auditor.md` | Absolute | Yes |
| collaboration-coach.md | `../../../../ai-resources/.claude/agents/collaboration-coach.md` | Relative | Yes |
| critical-resource-auditor.md | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/critical-resource-auditor.md` | Absolute | Yes |
| dd-extract-agent.md | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/dd-extract-agent.md` | Absolute | Yes |
| dd-log-sweep-agent.md | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/dd-log-sweep-agent.md` | Absolute | Yes |
| findings-extractor.md | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/findings-extractor.md` | Absolute | Yes |
| innovation-triage-auditor.md | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/innovation-triage-auditor.md` | Absolute | Yes |
| log-sweep-auditor.md | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/log-sweep-auditor.md` | Absolute | Yes |
| permission-sweep-auditor.md | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/permission-sweep-auditor.md` | Absolute | Yes |
| pipeline-stage-3a.md | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/pipeline-stage-3a.md` | Absolute | Yes |
| pipeline-stage-3b.md | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/pipeline-stage-3b.md` | Absolute | Yes |
| pipeline-stage-3c.md | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/pipeline-stage-3c.md` | Absolute | Yes |
| pipeline-stage-4.md | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/pipeline-stage-4.md` | Absolute | Yes |
| pipeline-stage-5.md | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/pipeline-stage-5.md` | Absolute | Yes |
| qc-reviewer.md | `../../../../ai-resources/.claude/agents/qc-reviewer.md` | Relative | Yes |
| refinement-reviewer.md | `../../../../ai-resources/.claude/agents/refinement-reviewer.md` | Relative | Yes |
| repo-dd-auditor.md | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/repo-dd-auditor.md` | Absolute | Yes |
| risk-check-reviewer.md | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/risk-check-reviewer.md` | Absolute | Yes |
| session-guide-generator.md | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/session-guide-generator.md` | Absolute | Yes |
| system-owner.md | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/system-owner.md` | Absolute | Yes |
| token-audit-auditor-mechanical.md | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/token-audit-auditor-mechanical.md` | Absolute | Yes |
| token-audit-auditor.md | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/token-audit-auditor.md` | Absolute | Yes |
| triage-reviewer.md | `../../../../ai-resources/.claude/agents/triage-reviewer.md` | Relative | Yes |
| workflow-analysis-agent.md | `../../../../ai-resources/.claude/agents/workflow-analysis-agent.md` | Relative | Yes |
| workflow-critique-agent.md | `../../../../ai-resources/.claude/agents/workflow-critique-agent.md` | Relative | Yes |

**Skill symlinks** (68 total — all in `reference/skills/`):

All 68 skill symlinks point to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/[name]/` using absolute paths and are accessible (targets exist).

**Mixed symlink styles in agents directory:** 21 agent symlinks use absolute paths; 4 use relative paths (collaboration-coach, qc-reviewer, refinement-reviewer, triage-reviewer, workflow-analysis-agent, workflow-critique-agent). The command symlinks were normalized to absolute paths in commit `2e6f023`; agent symlinks were not fully normalized.

Section summary: 147 symlinks catalogued (54 commands + 25 agents + 68 skills); all targets exist and are accessible; mixed symlink styles (absolute vs relative) in .claude/agents/ / no previous audit.

---

## Section 2: CLAUDE.md Health

### 2.1 CLAUDE.md Size and Structure

**Line count:** 121 lines  
**Distinct sections:** 18 (`## ` headings)

| # | Section Heading | Lines (approx.) |
|---|---|---|
| 1 | Project Context | 12 |
| 2 | Operator Profile | 3 |
| 3 | Confidentiality Boundaries | 1 |
| 4 | Workflow Overview | 7 |
| 5 | Skill Dependency Chain | 9 |
| 6 | Workflow Status Command | 3 |
| 7 | Utility Commands | 3 |
| 8 | Cross-Model Rules | 4 |
| 9 | Autonomy Rules | 9 |
| 10 | Context Isolation Rules | 2 |
| 11 | Friction Logging | 7 |
| 12 | Citation Conversion Rule | 2 |
| 13 | Bright-Line Rule | 2 |
| 14 | Input File Handling | 12 |
| 15 | File Verification and Git Commits | 5 |
| 16 | Commit Rules | 8 |
| 17 | Compaction | 8 |
| 18 | Session Boundaries | 3 |

### 2.2 Dead References in CLAUDE.md

The following paths referenced in CLAUDE.md were checked:

| Reference | Exists | Notes |
|---|---|---|
| `reference/stage-instructions.md` | Yes | File exists |
| `reference/file-conventions.md` | Yes | File exists |
| `reference/quality-standards.md` | Yes | File exists |
| `reference/style-guide.md` | Yes | File exists |
| `/workflow-status` command | Yes | `.claude/commands/workflow-status.md` exists |
| `workflow-evaluator` skill | Yes | `reference/skills/workflow-evaluator` symlink exists |
| `ai-resources/skills/` | Yes | Accessible via additionalDirectories |
| `/audit-repo` command | Yes | `.claude/commands/audit-repo.md` symlink exists |
| `reports/repo-health-report.md` (as audit-repo output path) | No — file not yet created | Expected to be created when `/audit-repo` is run; directory `reports/` exists with only `.gitkeep` |
| `/friction-log` command | Yes | `.claude/commands/friction-log.md` symlink exists |
| `/improve` command | Yes | `.claude/commands/improve.md` symlink exists |

None found that are dead references to renamed, moved, or deleted items — checked git history for all items, all were either present or not-yet-created runtime outputs.

**Missing section:** CLAUDE.md does not contain a `## Model Selection` section. The `/new-project` command (step 11) specifies that all new projects must have this section appended to CLAUDE.md. This section was not added during project initialization.

### 2.3 Contradictions in CLAUDE.md

None found — checked all 18 sections for conflicting statements.

**Note:** The project CLAUDE.md `## Autonomy Rules` section defines workflow-specific gate conditions ("when executing a process or workflow, proceed unless…"). The workspace-level CLAUDE.md `## Autonomy Rules` section defines 10 full workspace-level pause conditions. These operate at different scope levels (project workflow execution vs. general workspace behavior) and do not contradict each other.

### 2.4 Conventions Defined but Not Followed

| Convention | Defined Where | Violation |
|---|---|---|
| "Outputs are written to `output/{project}/`" | CLAUDE.md line 91 (Input File Handling) | The project's pipeline commands write outputs to `preparation/`, `execution/`, `analysis/`, `report/`, `final/` stage directories — not to `output/{project}/`. The `output/` directory exists but contains only `knowledge-files/.gitkeep`. The reference in CLAUDE.md appears to be a verbatim copy from the workspace-level rule which uses a different output structure than this project's pipeline. |

### 2.5 Partially-Present Features

| Feature | What Exists | What Is Missing |
|---|---|---|
| `check-archive.sh` archiving | `logs/scripts/check-archive.sh` exists and is wired to SessionStart hook; `logs/scripts/split-log.sh` exists | `logs/decisions.md`, `logs/friction-log.md` — both listed in check-archive.sh ENTRIES array but do not yet exist as files (new project, no sessions have created them) |
| Decision logging (UserPromptSubmit hook) | Hook configured to write to `logs/decisions.md` | `logs/decisions.md` does not exist |
| QC logging | `run-preparation.md`, `run-cluster.md`, `run-analysis.md`, `run-report.md`, `run-synthesis.md`, `review-chapter.md`, `verify-chapter.md`, `status.md` all reference `/logs/qc-log.md` | `logs/qc-log.md` does not exist |
| Improvement log | `session-plan.md`, `improve.md`, `friday-checkup.md` reference `logs/improvement-log.md` | `logs/improvement-log.md` does not exist |
| Maintenance observations | `log-sweep.md`, `session-plan.md` reference `logs/maintenance-observations.md` | `logs/maintenance-observations.md` does not exist |
| Usage log | `usage-analysis.md` references `logs/usage-log.md` | `logs/usage-log.md` does not exist |

**Note:** All 6 missing log files are expected to be created at first use. Commands that create them explicitly guard for non-existence (e.g., `friction-log.md` creates `# Friction Log` header if missing; `session-notes.md` creates header if missing). The `check-archive.sh` uses `[ -f "$PATH_FULL" ] || continue` guards. The files are missing because the project was initialized but no pipeline stages have been run.

### 2.6 CLAUDE.md Sections Containing Task-Specific Methodology

Per the workspace `CLAUDE.md → CLAUDE.md Scoping` rule, task-specific methodology belongs in SKILL.md or workflow reference docs, not in CLAUDE.md.

| Section | Lines | Task-Type | Note |
|---|---|---|---|
| Input File Handling (lines 84–95) | 12 | File handling methodology — canonical workspace rule | Explicitly self-declared as a copy: "This rule mirrors the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`." Rationale given: projects opened without parent workspace context. |
| File Verification and Git Commits (lines 96–101) | 6 | Commit process — canonical workspace rule | Partially self-declared as a copy: does not call out the duplication but partially mirrors workspace-level `File verification and git commits`. |
| Commit Rules (lines 102–109) | 8 | Commit process — canonical workspace rule | Explicitly self-declared as a copy: "This rule mirrors the canonical `Commit behavior` section in the workspace-level `CLAUDE.md`." Rationale given: same as above. |

Section summary: 3 issues flagged (1 dead reference scenario — reports/repo-health-report.md not yet created; 1 missing Model Selection section; 1 output path convention mismatch; 3 sections containing verbatim-copy workspace rules) / no previous audit.

---

## Section 3: Dependency References

### 3.1 Per-Command File References (Local Commands Only)

| Slash Command | Referenced File | File Exists |
|---|---|---|
| /audit-structure | `reference/file-conventions.md` | Yes |
| /audit-structure | `reference/stage-instructions.md` | Yes |
| /audit-structure | `reference/style-guide.md` | Yes |
| /audit-structure | `reference/quality-standards.md` | Yes |
| /create-context-pack | `ai-resources/skills/context-pack-builder/SKILL.md` | Yes (via symlink in reference/skills/) |
| /intake-reports | `ai-resources/skills/research-extract-creator/SKILL.md` | Yes |
| /intake-reports | `ai-resources/skills/research-extract-verifier/SKILL.md` | Yes |
| /produce-architecture | `ai-resources/skills/architecture-designer/SKILL.md` | Yes |
| /produce-architecture | `ai-resources/skills/architecture-qc/SKILL.md` | Yes |
| /produce-formatting | `ai-resources/skills/prose-formatter/SKILL.md` | Yes |
| /produce-formatting | `ai-resources/skills/h3-title-pass/SKILL.md` | Yes |
| /produce-formatting | `ai-resources/skills/formatting-qc/SKILL.md` | Yes |
| /produce-formatting | `ai-resources/skills/document-integration-qc/SKILL.md` | Yes |
| /produce-formatting | `logs/decisions.md` | No (not yet created) |
| /produce-knowledge-file | `reference/skills/knowledge-file-producer/SKILL.md` | Yes (local skill directory) |
| /produce-prose-draft | `ai-resources/skills/evidence-to-report-writer/SKILL.md` | Yes |
| /produce-prose-draft | `ai-resources/skills/ai-prose-decontamination/SKILL.md` | Yes |
| /produce-prose-draft | `ai-resources/skills/chapter-prose-reviewer/SKILL.md` | Yes |
| /produce-prose-draft | `ai-resources/skills/editorial-recommendations-generator/SKILL.md` | Yes |
| /produce-prose-draft | `ai-resources/skills/prose-compliance-qc/SKILL.md` | Yes |
| /produce-prose-draft | `ai-resources/skills/editorial-recommendations-qc/SKILL.md` | Yes |
| /produce-prose-draft | `logs/decisions.md` | No (not yet created) |
| /review-chapter | `ai-resources/skills/chapter-review/SKILL.md` | Yes |
| /review-chapter | `logs/qc-log.md` | No (not yet created) |
| /run-analysis | `ai-resources/skills/gap-assessment-gate/SKILL.md` | Yes |
| /run-analysis | `ai-resources/skills/analysis-pass-memo-review/SKILL.md` | Yes |
| /run-analysis | `ai-resources/skills/editorial-recommendations-generator/SKILL.md` | Yes |
| /run-analysis | `ai-resources/skills/editorial-recommendations-qc/SKILL.md` | Yes |
| /run-analysis | `ai-resources/skills/citation-converter/SKILL.md` | Yes |
| /run-analysis | `ai-resources/skills/section-directive-drafter/SKILL.md` | Yes |
| /run-analysis | `logs/qc-log.md` | No (not yet created) |
| /run-cluster | `ai-resources/skills/cluster-analysis-pass/SKILL.md` | Yes |
| /run-cluster | `ai-resources/skills/cluster-memo-refiner/SKILL.md` | Yes |
| /run-cluster | `logs/qc-log.md` | No (not yet created) |
| /run-execution | `ai-resources/skills/answer-spec-qc/SKILL.md` | Yes |
| /run-execution | `ai-resources/skills/execution-manifest-creator/SKILL.md` | Yes |
| /run-execution | `ai-resources/skills/research-prompt-creator/SKILL.md` | Yes |
| /run-execution | `ai-resources/skills/research-prompt-qc/SKILL.md` | Yes |
| /run-execution | `ai-resources/skills/research-extract-creator/SKILL.md` | Yes |
| /run-execution | `ai-resources/skills/research-extract-verifier/SKILL.md` | Yes |
| /run-execution | `ai-resources/skills/supplementary-query-brief-drafter/SKILL.md` | Yes |
| /run-execution | `ai-resources/skills/supplementary-evidence-merger/SKILL.md` | Yes |
| /run-execution | `ai-resources/skills/supplementary-research-qc/SKILL.md` | Yes |
| /run-preparation | `ai-resources/skills/task-plan-creator/SKILL.md` | Yes |
| /run-preparation | `ai-resources/skills/research-plan-creator/SKILL.md` | Yes |
| /run-preparation | `ai-resources/skills/answer-spec-generator/SKILL.md` | Yes |
| /run-preparation | `ai-resources/skills/answer-spec-qc/SKILL.md` | Yes |
| /run-preparation | `logs/qc-log.md` | No (not yet created) |
| /run-report | `ai-resources/skills/evidence-prose-fixer/SKILL.md` | Yes |
| /run-report | `ai-resources/skills/cluster-synthesis-drafter/SKILL.md` | Yes |
| /run-report | `ai-resources/skills/report-compliance-qc/SKILL.md` (via /ai-resources path) | Yes |
| /run-report | `logs/qc-log.md` | No (not yet created) |
| /run-report | `logs/decisions.md` | No (not yet created) |
| /run-synthesis | `ai-resources/skills/decision-to-prose-writer/SKILL.md` | Yes |
| /run-synthesis | `logs/qc-log.md` | No (not yet created) |
| /session-plan | `logs/session-notes.md` | Yes |
| /session-plan | `logs/improvement-log.md` | No (not yet created) |
| /session-plan | `logs/friction-log.md` | No (not yet created) |
| /session-plan | `logs/decisions.md` | No (not yet created) |
| /status | `logs/qc-log.md` | No (not yet created) |
| /verify-chapter | `ai-resources/skills/evidence-spec-verifier/SKILL.md` | Yes |
| /verify-chapter | `logs/decisions.md` | No (not yet created) |
| /verify-chapter | `logs/qc-log.md` | No (not yet created) |
| /workflow-status | `reference/stage-instructions.md` | Yes |
| /workflow-status | `ai-resources/skills/workflow-evaluator/SKILL.md` | Yes |
| /workflow-status | `.claude/agents/verification-agent.md` | Yes |
| /wrap-session | `logs/session-notes.md` | Yes |
| /wrap-session | `logs/decisions.md` | No (not yet created) |
| /wrap-session | `logs/innovation-registry.md` | Yes |

**Summary of missing referenced files:** 6 runtime log files not yet created (`logs/qc-log.md`, `logs/decisions.md`, `logs/friction-log.md`, `logs/improvement-log.md`, `logs/maintenance-observations.md`, `logs/usage-log.md`). All have creation guards or are appended-to only when relevant events occur.

### 3.2 Command Output-to-Input Chains

| Chain | Commands | Output Artifact → Input Artifact |
|---|---|---|
| Research pipeline (main) | /run-preparation → /run-execution → /run-cluster → /run-analysis → /run-report → /run-synthesis | Task Plans → Research Plans → Answer Specs → Research Prompts → Raw Reports → Research Extracts → Cluster Memos → Section Directives → Report Prose → Final Synthesis |
| QC chain within preparation | /run-preparation (internal) | Answer Specs → answer-specs-qc.md (QC verdict) → gate for /run-execution |
| Report review chain | /run-report → /review-chapter → /verify-chapter | Report chapter → QC review → Fact verification |
| Format chain | /produce-prose-draft → /produce-formatting | Reviewed prose → Formatted and H3-optimized prose |
| Session tracking chain | /wrap-session → /session-plan → /improve | session-notes.md → session-plan output → improvement-log.md |

### 3.3 Files Referenced by More Than One Command, Hook, or Script

| File | Referenced By |
|---|---|
| `logs/qc-log.md` | /run-preparation, /run-cluster, /run-analysis, /run-report, /run-synthesis, /review-chapter, /verify-chapter, /status (8 commands) |
| `logs/decisions.md` | /produce-formatting, /produce-prose-draft, /run-report, /verify-chapter, /session-plan, /wrap-session, UserPromptSubmit hook, bright-line PreToolUse hook (8 commands/hooks) |
| `logs/session-notes.md` | /session-plan, /wrap-session, Stop hook session-wrap-check (3 commands/hooks) |
| `logs/friction-log.md` | /session-plan, friction-log-auto PreToolUse hook (2 commands/hooks) |
| `logs/improvement-log.md` | /session-plan, /improve (symlinked) (2 commands) |
| `reference/stage-instructions.md` | /audit-structure, /workflow-status, CLAUDE.md (Context Isolation Rules, Citation Conversion Rule, Bright-Line Rule) (2 commands + CLAUDE.md) |
| `ai-resources/skills/answer-spec-qc/SKILL.md` | /run-preparation, /run-execution (2 commands) |
| `ai-resources/skills/editorial-recommendations-generator/SKILL.md` | /produce-prose-draft, /run-analysis (2 commands) |
| `ai-resources/skills/editorial-recommendations-qc/SKILL.md` | /produce-prose-draft, /run-analysis (2 commands) |
| `ai-resources/skills/research-extract-creator/SKILL.md` | /intake-reports, /run-execution (2 commands) |
| `ai-resources/skills/research-extract-verifier/SKILL.md` | /intake-reports, /run-execution (2 commands) |
| `.claude/agents/verification-agent.md` | /workflow-status (1 command — local agent used in workflow-status) |

### 3.4 Files Ranked by Downstream References (Top 10)

| Rank | File | Reference Count | Referenced By |
|---|---|---|---|
| 1 | `logs/qc-log.md` | 8 | /run-preparation, /run-cluster, /run-analysis, /run-report, /run-synthesis, /review-chapter, /verify-chapter, /status |
| 2 | `logs/decisions.md` | 8 | /produce-formatting, /produce-prose-draft, /run-report, /verify-chapter, /session-plan, /wrap-session, UserPromptSubmit hook, PreToolUse Edit hook |
| 3 | `logs/session-notes.md` | 3 | /session-plan, /wrap-session, Stop hook |
| 4 | `reference/stage-instructions.md` | 3 | /audit-structure, /workflow-status, CLAUDE.md (3 sections) |
| 5 | `ai-resources/skills/answer-spec-qc/SKILL.md` | 2 | /run-preparation, /run-execution |
| 6 | `ai-resources/skills/editorial-recommendations-generator/SKILL.md` | 2 | /produce-prose-draft, /run-analysis |
| 7 | `ai-resources/skills/editorial-recommendations-qc/SKILL.md` | 2 | /produce-prose-draft, /run-analysis |
| 8 | `ai-resources/skills/research-extract-creator/SKILL.md` | 2 | /intake-reports, /run-execution |
| 9 | `ai-resources/skills/research-extract-verifier/SKILL.md` | 2 | /intake-reports, /run-execution |
| 10 | `logs/friction-log.md` | 2 | /session-plan, PreToolUse Skill hook |

### 3.5 Symlinks Outside Project Not Covered by additionalDirectories

`permissions.additionalDirectories` in `.claude/settings.json` contains:
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`

All command and agent symlinks outside AUDIT_ROOT point to targets under `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/`, which is a subdirectory of the listed workspace root. All skill symlinks point to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/[name]/`, also covered.

None found — all external symlink targets are covered by the `additionalDirectories` entry. Checked: 54 command symlinks, 25 agent symlinks, 68 skill symlinks; all targets have `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` as an ancestor.

### 3.6 Projects Referencing ai-resources Without Coverage in additionalDirectories

This project references `ai-resources/` via:
1. Command symlinks pointing to `ai-resources/.claude/commands/`
2. Agent symlinks pointing to `ai-resources/.claude/agents/`
3. Skill symlinks pointing to `ai-resources/skills/`
4. SessionStart hook walker that calls `ai-resources/.claude/hooks/auto-sync-shared.sh` and `ai-resources/.claude/hooks/check-template-drift.sh`
5. Local commands referencing `/ai-resources/skills/[name]/SKILL.md` by path

`permissions.additionalDirectories` includes `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` which is the workspace root and an ancestor of `ai-resources/`. Coverage is confirmed.

None found — the workspace root entry covers all ai-resources paths. No missing entry.

Section summary: 0 broken symlink references; 6 runtime log files referenced but not yet created (expected behavior for new project); 1 coverage gap confirmed clean / no previous audit.

---

## Section 4: Consistency Checks

### 4.1 Skill Structural Pattern

All 68 symlinked skills follow the ai-resources pattern: each is a directory containing at minimum a `SKILL.md` file (verified via symlink resolution). The 2 local skill directories (`knowledge-file-producer`, `report-compliance-qc`) each contain only `SKILL.md` — both conform to the minimal SKILL.md pattern.

None found — all 70 skill directories have SKILL.md; no structural deviations identified within AUDIT_ROOT.

### 4.2 Slash Command Definition Pattern

Expected pattern: YAML frontmatter (`---`) at line 1, followed by markdown body.

All 21 local command files have `---` at line 1 (YAML frontmatter present). All 21 declare `model:` in frontmatter.

**Deviation:** `update-claude-md.md` is listed as `"shared"` in `shared-manifest.json` (implying it should be a symlink to ai-resources) but is a local regular file. Its content reads as a minimal local stub (4 lines, model: sonnet, generic instruction).

None found in structure — all local commands follow the frontmatter + markdown body pattern.

### 4.3 Skill Template Comparison

N/A — No skill creation template file exists in AUDIT_ROOT. Skills are created via `/create-skill` which references `ai-resource-builder/SKILL.md` for format standards.

### 4.4 Naming Convention Inconsistencies

All command filenames are `lowercase-hyphenated.md`. No violations found — checked all 75 command names.

All agent filenames are `lowercase-hyphenated.md`. No violations found — checked all 29 agent entries.

All skill directory names are `lowercase-hyphenated`. No violations found — checked all 70 skill directory names.

**Mixed symlink styles:** 21 agent symlinks use absolute paths; 4 use relative paths (collaboration-coach, qc-reviewer, refinement-reviewer, triage-reviewer, workflow-analysis-agent, workflow-critique-agent). Command symlinks are all absolute (normalized in commit `2e6f023`). This is inconsistent within the agents directory.

**shared-manifest.json inconsistencies:**
- 4 commands listed as `"local"` in manifest are actually symlinks: `audit-repo`, `friction-log`, `improve`, `prime`.
- 1 command listed as `"shared"` in manifest is actually a local file: `update-claude-md`.
- 40 symlinked commands exist but are not listed in the manifest at all (neither as local nor shared).
- 19 symlinked agents exist but are not listed in the manifest at all.

### 4.5 Directory Structure Violations

Expected top-level directories per CLAUDE.md and `audit-structure.md` commands: `preparation/`, `execution/`, `analysis/`, `report/`, `final/`, `logs/`, `reference/`.

All 7 expected top-level directories exist. Additional directories present: `output/`, `pipeline/`, `reports/`, `usage/`.

Per `audit-structure.md` line 36, `reference/` should contain: `skills/`, `sops/`, `templates/`, `scoping-notes/`. All 4 subdirectories exist.

**Deviation:** The `pipeline/` directory is present and contains project planning artifacts (`context-pack.md`, `project-plan.md`). This directory is not listed as expected in `reference/stage-instructions.md` or `audit-structure.md`. It is a staging workspace for planning phase artifacts.

### 4.6 Command Syntax and Path Resolution

All 21 local commands have valid YAML frontmatter with `model:` declared. Paths referenced within commands were checked against the filesystem.

**Issue:** `run-report.md` references `/ai-resources/skills/report-compliance-qc/SKILL.md`. A local copy of this skill also exists at `reference/skills/report-compliance-qc/`. The command reads from the `ai-resources/` path, not the local copy, creating a silent discrepancy: the local directory exists but the command bypasses it.

All other path references in local commands resolve correctly (verified in Section 3.1).

### 4.7 Duplicate or Conflicting Command Names

No duplicate command names found — all 75 command names are unique.

No conflicts with standard Claude Code built-in commands found — checked against known built-ins (`/clear`, `/compact`, `/model`, `/help`, `/memory`, `/logout`, `/login`, `/doctor`, `/cost`, `/feedback`, `/init`, `/status`, `/vim`). The project defines `/status` as a local command (13 lines, reads `logs/qc-log.md`); the Claude Code built-in `/status` is a different function. **Potential conflict:** `/status` name is shared with a Claude Code built-in.

### 4.8 Agent Tier Declarations vs. Agent Tier Table

The agent tier table at `ai-resources/docs/agent-tier-table.md` covers `ai-resources/.claude/agents/` entries only. Local project agents are not in the table.

**Symlinked agents (25):** All symlink to agents in `ai-resources/.claude/agents/`. Their model declarations come from the target files. Based on the tier table entries, all 25 symlinked agents are at correct tiers (cross-checked: claude-md-auditor=opus, dd-extract-agent=haiku, dd-log-sweep-agent=haiku, findings-extractor=haiku, improvement-analyst=opus, innovation-triage-auditor=opus, log-sweep-auditor=not in table, permission-sweep-auditor=sonnet, pipeline-stage-3a=sonnet, pipeline-stage-3b=opus, pipeline-stage-3c=opus, pipeline-stage-4=sonnet, pipeline-stage-5=sonnet, qc-reviewer=opus, refinement-reviewer=opus, repo-dd-auditor=sonnet, risk-check-reviewer=opus, session-guide-generator=sonnet, system-owner=opus, token-audit-auditor=opus, token-audit-auditor-mechanical=haiku, triage-reviewer=opus, workflow-analysis-agent=opus, workflow-critique-agent=opus).

**Agent `log-sweep-auditor`:** Present as symlink in AUDIT_ROOT but not listed in the agent tier table. Cannot confirm tier assignment — the table would need to be checked externally (outside AUDIT_ROOT scope).

**Local agents (4 — regular files, not in tier table):**

| Agent File | Declared Model | Notes |
|---|---|---|
| `execution-agent.md` | sonnet | Not in tier table (project-local). Agent handles API calls — sonnet is consistent with "structured factual work" per tier table principles. |
| `improvement-analyst.md` | opus | Not in tier table (project-local). Agent does judgment work (friction analysis) — opus is consistent with tier table principles. |
| `qc-gate.md` | sonnet | Not in tier table (project-local). Agent runs structured QC checks — sonnet consistent with tier table principles. |
| `verification-agent.md` | sonnet | Not in tier table (project-local). Agent does independent re-derivation — sonnet consistent with tier table principles. |

All 4 local agent tier declarations are internally consistent with the tier table's principles, but none are registered in the tier table.

### 4.9 Project settings.json vs. Canonical Baseline

**Canonical baseline** from `new-project.md` line 310 (CANONICAL_PERMS):
```
deny: ["Bash(git push*)","Bash(rm -rf *)","Bash(sudo *)","Read(archive/**)","Read(**/*.archive.*)","Read(**/deprecated/**)","Read(**/old/**)"]
```

**Project `.claude/settings.json` deny entries:**
```
"Bash(git push*)", "Bash(rm -rf *)", "Bash(sudo *)", "Read(archive/**)", "Read(**/*.archive.*)", "Read(logs/*-archive-*.md)", "Read(**/deprecated/**)", "Read(**/old/**)"
```

**Comparison:**
- Canonical `Read(archive/**)` → Project has `Read(archive/**)` — PRESENT (match, note trailing `**` vs `/**` difference — functionally equivalent)
- Canonical `Read(**/*.archive.*)` → Project has `Read(**/*.archive.*)` — PRESENT
- Canonical `Read(**/deprecated/**)` → Project has `Read(**/deprecated/**)` — PRESENT
- Canonical `Read(**/old/**)` → Project has `Read(**/old/**)` — PRESENT
- **Extra entry not in CANONICAL_PERMS:** `Read(logs/*-archive-*.md)` — present in project but not in canonical baseline

All canonical deny entries are present. No canonical deny entries are missing.

**Top-level `"model"` declaration:** The current `settings.json` does not contain a `"model"` key at the top level. The most recent commit to settings.json (`a42d382`, 2026-05-12) is titled "config: remove hard-locked model from project settings.json", confirming the model field was present and was deliberately removed. The `new-project.md` canonical baseline does not include a `"model"` key in CANONICAL_PERMS; it directs that the model be set in `settings.local.json` (gitignored). **No `settings.local.json` exists.** Per `new-project.md` step 11, the default model should be declared in `settings.local.json` — this file is absent.

**Commit dates:**
- Most recent commit touching `settings.json`: 2026-05-12 (`a42d382`)
- Most recent commit touching CANONICAL_PERMS block in `new-project.md` (in ai-resources repo): 2026-05-11

Section summary: 6 issues flagged (1 manifest-vs-reality mismatch for 4+1+40+19 items; 1 mixed symlink styles in agents; 1 potential command name conflict with built-in /status; 1 local skill directory bypassed by run-report.md; 1 missing settings.local.json; 4 local agents not in tier table) / no previous audit.

---

## Section 5: Context Load

### 5.1 Total Context Loaded at Session Start

When a session starts in this project directory, the following files are auto-loaded:

| File | Line Count |
|---|---|
| Workspace CLAUDE.md (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md`) | 161 lines |
| Project CLAUDE.md (`CLAUDE.md`) | 121 lines |
| SessionStart hooks inject additional content (checkpoint context, template drift warnings, auto-sync output) | Variable; typically 0–5 lines of hook output |

**Estimated total auto-loaded context at session start:** approximately 282 lines of CLAUDE.md text plus any SessionStart hook output.

No `@`-prefixed file references in CLAUDE.md that would force additional file loads at startup.

### 5.2 CLAUDE.md Sections Not Referenced by Any Command, Hook, or Operational Instruction

| Section | Lines | Notes |
|---|---|---|
| Operator Profile (lines 15–17) | 3 | States Patrik is sole operator; no command or hook references this. |
| Confidentiality Boundaries (lines 19–21) | 3 | States "no confidentiality constraints"; no command references this. |
| Session Boundaries (lines 119–121) | 3 | Instructs /clear between unrelated tasks; not wired to any command or hook. |

All other sections are referenced by at least one command, hook entry in settings.json, or CLAUDE.md cross-reference.

### 5.3 CLAUDE.md Line Count History (Last 5 Commits)

Only 1 commit touches `CLAUDE.md` in this project's git history:

| Date | Commit | CLAUDE.md Line Count |
|---|---|---|
| 2026-05-12 | d3a60f2 | 121 lines |

The CLAUDE.md has not been modified since project initialization. The project has 7 commits total; only 1 touches CLAUDE.md.

Section summary: 1 issue flagged (3 CLAUDE.md sections with no command/hook reference — low impact, informational content); CLAUDE.md has 1 commit history point / no previous audit.

---

## Section 6: Drift and Staleness

### 6.1 Files Not Modified in Last 90 Days but Referenced by Active Commands

All files in AUDIT_ROOT have git commit dates of 2026-05-12. The project was initialized 2026-05-12 (7 commits, all same date). No files predate 90 days.

None found — checked all tracked files; earliest commit date is 2026-05-12 (0 days ago as of audit date 2026-05-12).

### 6.2 TODO, FIXME, PLACEHOLDER, or Similar Markers

Searched all `.md`, `.sh`, and `.json` files in AUDIT_ROOT (excluding `.git/`). No matches found for `TODO`, `FIXME`, `PLACEHOLDER`, `XXX`, or `HACK` in any file.

None found — searched all markdown, shell, and JSON files in AUDIT_ROOT.

### 6.3 Empty, Stub, or Boilerplate-Only Files

| File | Content | Notes |
|---|---|---|
| `reference/templates/.gitkeep` | 0 bytes | Empty placeholder to preserve directory in git |
| `reference/scoping-notes/.gitkeep` | 0 bytes | Empty placeholder |
| `logs/.gitkeep` | 0 bytes | Empty placeholder |
| `analysis/chapters/.gitkeep` | 0 bytes | Empty placeholder |
| `analysis/checkpoints/.gitkeep` | 0 bytes | Empty placeholder |
| `analysis/cluster-memos/.gitkeep` | 0 bytes | Empty placeholder |
| `analysis/editorial-review/.gitkeep` | 0 bytes | Empty placeholder |
| `analysis/gap-assessment/.gitkeep` | 0 bytes | Empty placeholder |
| `analysis/gap-supplementary/.gitkeep` | 0 bytes | Empty placeholder |
| `analysis/section-directives/.gitkeep` | 0 bytes | Empty placeholder |
| `execution/checkpoints/.gitkeep` | 0 bytes | Empty placeholder |
| `execution/extract-verification/.gitkeep` | 0 bytes | Empty placeholder |
| `execution/manifest/.gitkeep` | 0 bytes | Empty placeholder |
| `execution/raw-reports/.gitkeep` | 0 bytes | Empty placeholder |
| `execution/research-extracts/.gitkeep` | 0 bytes | Empty placeholder |
| `execution/research-prompts/.gitkeep` | 0 bytes | Empty placeholder |
| `execution/scarcity-register/.gitkeep` | 0 bytes | Empty placeholder |
| `execution/supplementary/.gitkeep` | 0 bytes | Empty placeholder |
| `final/modules/.gitkeep` | 0 bytes | Empty placeholder |
| `output/knowledge-files/.gitkeep` | 0 bytes | Empty placeholder |
| `preparation/answer-specs/.gitkeep` | 0 bytes | Empty placeholder |
| `preparation/checkpoints/.gitkeep` | 0 bytes | Empty placeholder |
| `preparation/research-plans/.gitkeep` | 0 bytes | Empty placeholder |
| `preparation/task-plans/.gitkeep` | 0 bytes | Empty placeholder |
| `report/architecture/.gitkeep` | 0 bytes | Empty placeholder |
| `report/chapters/.gitkeep` | 0 bytes | Empty placeholder |
| `report/checkpoints/.gitkeep` | 0 bytes | Empty placeholder |
| `report/enrichment/.gitkeep` | 0 bytes | Empty placeholder |
| `report/style-reference/.gitkeep` | 0 bytes | Empty placeholder |
| `reports/.gitkeep` | 0 bytes | Empty placeholder |
| `usage/.gitkeep` | 0 bytes | Empty placeholder |
| `logs/innovation-registry.md` | 4 lines | Header + empty table (no data rows — boilerplate stub) |
| `logs/research-quality-log.md` | 12 lines | Header + column definitions + empty table (no data rows — boilerplate stub) |

Files with content (not stubs):
- `logs/session-notes.md` — 29 lines, contains one real session entry (2026-05-12)
- `logs/session-plan.md` — 23 lines, contains content
- `pipeline/context-pack.md` — populated planning artifact
- `pipeline/project-plan.md` — populated planning artifact

Section summary: 2 issues flagged (2 log files with boilerplate headers and no data rows; 31 empty .gitkeep placeholder files — all expected for a newly initialized pipeline project) / no previous audit.

---

## Findings Summary

### By Type

| Type | Count |
|---|---|
| Discrepancy (state differs from declared/expected) | 8 |
| Missing item (referenced file or config absent) | 4 |
| Violation (rule or convention not followed) | 2 |
| Clean check (no issues found) | 16 |

### Discrepancy Items

1. **shared-manifest.json vs. actual symlink state** — 4 commands listed as "local" are symlinks (`audit-repo`, `friction-log`, `improve`, `prime`); 1 command listed as "shared" is a local file (`update-claude-md`); 40 symlinked commands and 19 symlinked agents exist with no manifest entry.
2. **Mixed symlink styles in `.claude/agents/`** — 4 agent symlinks use relative paths; 21 use absolute. Command symlinks were normalized to absolute in commit `2e6f023`; agent symlinks were not.
3. **`run-report.md` references `report-compliance-qc` via `/ai-resources/` path** while a local copy exists at `reference/skills/report-compliance-qc/`. The command bypasses the local copy silently.
4. **`output/` directory convention mismatch** — CLAUDE.md (Input File Handling line 91) references `output/{project}/` as the write target for produced artifacts, but the pipeline writes to stage directories (`preparation/`, `execution/`, `analysis/`, `report/`, `final/`). The `output/` directory exists but contains only `knowledge-files/.gitkeep`.
5. **`log-sweep-auditor` agent** — present as a symlink in `.claude/agents/` but missing from the agent tier table in `ai-resources/docs/agent-tier-table.md`.
6. **4 local agents not registered in agent tier table** — `qc-gate`, `verification-agent`, `execution-agent`, `improvement-analyst` are project-local agents not in the tier table.
7. **`/status` command name conflict** — project defines `/status` (reads `logs/qc-log.md`) and the Claude Code CLI also has a built-in `/status` command.
8. **Model removal from settings.json without settings.local.json** — top-level `"model"` was removed from `settings.json` (commit `a42d382`) but no `settings.local.json` exists to declare the per-operator default, and `.gitignore` does not include `settings.local.json`.

### Missing Items

1. **`CLAUDE.md` missing `## Model Selection` section** — required by `/new-project` command step 11; not present.
2. **`settings.local.json` absent** — per `/new-project` step 11, the model default should be in this gitignored file; file does not exist; `.gitignore` does not include `settings.local.json`.
3. **3 hook scripts present but not configured in settings.json** — `check-claim-ids.sh`, `check-skill-size.sh`, `check-permission-sanity.sh` are in `.claude/hooks/` but not referenced in settings.json.
4. **6 runtime log files not yet created** — `logs/qc-log.md`, `logs/decisions.md`, `logs/friction-log.md`, `logs/improvement-log.md`, `logs/maintenance-observations.md`, `logs/usage-log.md` — all referenced by commands but do not yet exist. Expected behavior for a new project with no pipeline stages run.

### Violation Items

1. **`CLAUDE.md` contains 3 sections that are verbatim copies of workspace-level rules** — "Input File Handling" (12 lines), "File Verification and Git Commits" (6 lines), "Commit Rules" (8 lines) — per workspace CLAUDE.md § "CLAUDE.md Scoping", canonical workspace rules should be pointed to, not duplicated. Two of three self-declare the duplication with rationale ("projects are sometimes opened without the parent workspace context loaded").
2. **`update-claude-md` symlink/manifest mismatch** — manifest declares it "shared" (implying it should be synced from ai-resources), but it is a local file with project-local content. The auto-sync hook would overwrite it if the manifest were accurate.
