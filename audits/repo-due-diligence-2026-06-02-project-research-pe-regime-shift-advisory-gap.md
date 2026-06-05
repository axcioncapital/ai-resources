# Repo Due Diligence Audit — 2026-06-02
Repo: projects/research-pe-regime-shift-advisory-gap
Scope: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap
Commit: 2b59d46
Previous audit: None (baseline audit)
Depth: standard

---

## Section 1: Inventory

### 1.1 Slash commands

86 total commands under `.claude/commands/`. 55 are symlinks to `../../../../ai-resources/.claude/commands/`. 31 are local (non-symlink) files.

**Local (non-symlink) commands:**

| Command file | Purpose (from frontmatter/header) | References |
|---|---|---|
| audit-repo.md | Full workspace health audit; spawns repo-health-analyzer via subagent | `reference/skills/repo-health-analyzer/agents/` (7 agent files) |
| audit-structure.md | Structure audit command | (external details not read) |
| consult.md | Consult Axcíon AI System Owner | `ai-resources/docs/change-shape-classifier.md`; delegates to `system-owner` agent |
| create-context-pack.md | Create context pack | (external details not read) |
| friction-log.md | Start/append friction log session | `logs/friction-log.md` |
| improve.md | Run improvement analyst on session friction | delegates to `improvement-analyst` agent |
| inject-dependency.md | Inject prior research into downstream prompts | `/execution/research-prompts/{section}/session-plan.md`, raw reports |
| intake-reports.md | Intake raw research reports | (external details not read) |
| note.md | Append note | (external details not read) |
| prime.md | Orient session; read state and brief operator | `logs/session-notes.md`, checkpoint files |
| produce-architecture.md | Produce document architecture | (external details not read) |
| produce-formatting.md | Apply formatting/H3/integration QC | `reference/stage-5-paths.md` (runtime required), `reference/skills/` |
| produce-jargon-gloss.md | Apply jargon-gloss pass | `reference/stage-5-paths.md` (runtime required), `reference/skills/jargon-gloss/` |
| produce-knowledge-file.md | Produce knowledge file from completed section | `reference/skills/knowledge-file-producer/SKILL.md` |
| produce-prose-draft.md | Produce prose draft | `reference/stage-5-paths.md` (runtime required, must be created from template), skills chain |
| qc-pass.md | QC gate pass | delegates to `qc-reviewer` agent |
| refinement-pass.md | Refinement pass | delegates to `refinement-reviewer` agent |
| review-chapter.md | Review chapter prose | (external details not read) |
| run-analysis.md | Cross-cluster Pass 4 synthesis | `/analysis/gate-clearance/{section}/`, skills via `ai-resources` |
| run-cluster.md | Parallel cluster analysis (Pass 3 entry) | `reference/source-class-hierarchy.md`, `reference/quality-standards.md`, `reference/known-limits.md`; skill files |
| run-execution.md | Stage 2 research pipeline | `reference/source-class-hierarchy.md`, `reference/quality-standards.md`, skill files |
| run-preparation.md | Stage 1 preparation pipeline | `/ai-resources/skills/` (task-plan-creator, research-plan-creator, answer-spec-generator, answer-spec-qc) |
| run-report.md | Stage 4 report production | (external details not read) |
| run-sufficiency.md | Pass 3 sufficiency check; emits gate-clearance file | `reference/source-class-hierarchy.md`, `reference/quality-standards.md`, `reference/known-limits.md`; skill files |
| run-synthesis.md | Stage 3 cluster synthesis (Pass 4) | `/analysis/gate-clearance/{section}/`, skill files |
| session-plan.md | Session orchestrator; produces marker-scoped plan | `logs/session-notes.md`, `docs/session-marker.md` |
| status.md | Project status report | `logs/qc-log.md`, `logs/session-notes.md` |
| update-claude-md.md | Update CLAUDE.md | (external details not read) |
| verify-chapter.md | Verify chapter | (external details not read) |
| workflow-status.md | Research workflow status + QC health check | `reference/stage-instructions.md`, `workflow-evaluator` skill |
| wrap-session.md | Wrap current session | `logs/session-notes.md`, `logs/decisions.md`, `logs/innovation-registry.md`, `logs/scripts/check-archive.sh` |

**Symlinked commands (55 total, all targets resolve — target: `../../../../ai-resources/.claude/commands/`):**

analyze-workflow, architecture-review, archive-project, audit-claude-md, build-context, clarify, cleanup-worktree, coach, contract-check, create-skill, decide, deploy-kb, drift-check, explain, fix-repo-issues, fix-symlinks, friday-act, friday-checkup, friday-journal, friday-so, graduate-resource, grill-me, handoff, implementation-triage, improve-skill, innovation-sweep, log-sweep, migrate-skill, monday-prep, open-items, permission-sweep, placement, pm, project-consultant, recommend, refinement-deep, repo-dd, request-skill, resolve, resolve-improvement-log, resolve-incident, resolve-repo-problem, risk-check, save-session, scope, session-guide, session-start, so-monthly, summary, sync-workflow, systems-review, token-audit, triage, tweak, usage-analysis

Section summary: 86 commands catalogued (55 symlinked, 31 local) / no previous audit (baseline)

---

### 1.2 Hooks

Hooks are configured in `.claude/settings.json`. There is no `.claude/settings.local.json`.

**PreToolUse hooks:**

| Trigger | Hook | What it does | Files referenced |
|---|---|---|---|
| Skill | `friction-log-auto.sh` | Auto-starts friction log session when command has `friction-log: true` | `logs/friction-log.md` |
| Edit | Inline bash (bright-line check) | Blocks edits to `report/chapters/` and `final/modules/` without operator approval | (inline logic only) |

**PostToolUse hooks:**

| Trigger | Hook | What it does | Files referenced |
|---|---|---|---|
| Write | Inline bash (auto-commit) | Auto-commits files in preparation/execution/analysis/report directories | git |
| Write | `log-write-activity.sh` | Logs write activity to friction log | `logs/friction-log.md` |
| Write | `detect-innovation.sh` | Detects when commands/agents/hooks are created/modified | `logs/innovation-registry.md` |
| Edit | `log-write-activity.sh` | Same as Write trigger | `logs/friction-log.md` |
| Edit | `detect-innovation.sh` | Same as Write trigger | `logs/innovation-registry.md` |

**SessionStart hooks (4):**

| Hook | What it does | Files referenced |
|---|---|---|
| Inline bash (checkpoint loader) | Finds most recent checkpoint and emits section/stage context | Checkpoint files under `preparation/execution/analysis/report/checkpoints/` |
| Inline bash (template drift check) | Walks up to find `ai-resources/.claude/hooks/check-template-drift.sh` | `ai-resources/.claude/hooks/check-template-drift.sh` (external) |
| Inline bash (auto-sync shared) | Walks up to find and run `ai-resources/.claude/hooks/auto-sync-shared.sh` | `ai-resources/.claude/hooks/auto-sync-shared.sh` (external) |
| Inline bash (log size check) | Runs `logs/scripts/check-archive.sh` | `logs/scripts/check-archive.sh` |

**Stop hooks (2 entries, 3 total hooks):**

| Hook | What it does | Files referenced |
|---|---|---|
| Inline bash (checkpoint check) | Warns if no checkpoint written this session | Checkpoint directories |
| Inline bash (session wrap check) | Warns if session not wrapped today | `logs/session-notes.md` |

**UserPromptSubmit hooks (1):**

| Hook | What it does | Files referenced |
|---|---|---|
| Inline bash (decision logger) | Logs operator decisions after gate/bright-line events | `logs/decisions.md` |

**15 hook scripts** exist under `.claude/hooks/`:

auto-qc-nudge.sh, auto-resolve-nudge.sh, backup-session-plan.sh, check-claim-ids.sh, check-heavy-tool.sh, check-permission-sanity.sh, check-skill-size.sh, check-stop-reminders.sh, coach-reminder.sh, detect-concurrent-session.sh, detect-innovation.sh, friction-log-auto.sh, friday-checkup-reminder.sh, improve-reminder.sh, log-write-activity.sh

Note: None of the 15 scripts under `.claude/hooks/` are directly wired to hooks in `settings.json`. The hooks in `settings.json` reference only 3 of these scripts by name (`friction-log-auto.sh`, `log-write-activity.sh`, `detect-innovation.sh`). The remaining 12 scripts exist in the hooks directory but are not called by `settings.json`. They may be referenced by symlinked commands or by external ai-resources hooks.

Section summary: 10 hook definitions in settings.json (5 inline, 3 named scripts, 2 external-path scripts) / no previous audit (baseline)

---

### 1.3 Template files

| File path | Used by | Last commit date |
|---|---|---|
| `reference/claim-permission.template.md` | claim-permission-gate skill (via symlink) | 2026-06-01 |
| `reference/jargon-gloss-config.template.md` | jargon-gloss skill | 2026-06-01 |
| `reference/stage-5-paths.template.md` | produce-prose-draft, produce-formatting, produce-jargon-gloss (referenced as source for creating `reference/stage-5-paths.md`) | 2026-06-01 |
| `reference/templates/.gitkeep` | placeholder only (directory empty) | 2026-06-01 |

Section summary: 3 substantive template files catalogued / no previous audit (baseline)

---

### 1.4 Scripts

| File path | What it does | What calls it |
|---|---|---|
| `.claude/hooks/auto-qc-nudge.sh` | PostToolUse advisory nudge to run /qc-pass after significant writes | Not wired in settings.json |
| `.claude/hooks/auto-resolve-nudge.sh` | Stop hook: suggests /resolve after QC was nudged | Not wired in settings.json |
| `.claude/hooks/backup-session-plan.sh` | Copies existing session-plan.md before Write | Not wired in settings.json |
| `.claude/hooks/check-claim-ids.sh` | Checks for [CITATION NEEDED] tags in pipeline artifacts | Not wired in settings.json |
| `.claude/hooks/check-heavy-tool.sh` | Emits [HEAVY] reminder on Read/Grep/Bash heavy-tool use | Not wired in settings.json |
| `.claude/hooks/check-permission-sanity.sh` | SessionStart: checks defaultMode is bypassPermissions | Not wired in settings.json |
| `.claude/hooks/check-skill-size.sh` | Warns if SKILL.md files exceed 300-line convention | Not wired in settings.json |
| `.claude/hooks/check-stop-reminders.sh` | Stop hook: checks innovation-registry and usage telemetry | Not wired in settings.json |
| `.claude/hooks/coach-reminder.sh` | Stop hook: reminds operator to run /coach after 7+ sessions | Not wired in settings.json |
| `.claude/hooks/detect-concurrent-session.sh` | SessionStart: warns when multiple Claude Code sessions running | Not wired in settings.json |
| `.claude/hooks/detect-innovation.sh` | PostToolUse Write/Edit: detects command/agent/hook creation | Called by Write/Edit PostToolUse hooks in settings.json |
| `.claude/hooks/friction-log-auto.sh` | PreToolUse Skill: auto-starts friction log session | Called by Skill PreToolUse hook in settings.json |
| `.claude/hooks/friday-checkup-reminder.sh` | SessionStart: reminds to run /friday-checkup on Fridays | Not wired in settings.json |
| `.claude/hooks/improve-reminder.sh` | Stop hook: reminds to run /improve at session end | Not wired in settings.json |
| `.claude/hooks/log-write-activity.sh` | PostToolUse Write/Edit: logs file write/edit activity | Called by Write/Edit PostToolUse hooks in settings.json |
| `logs/scripts/check-archive.sh` | Iterates log files and archives those over threshold | Called by SessionStart hook (inline bash) and wrap-session command |
| `logs/scripts/split-log.sh` | Splits append-only log at ## header boundaries; archives older portion | Called by check-archive.sh |

Section summary: 17 scripts catalogued / no previous audit (baseline)

---

### 1.5 Skills

**Local skills (2, with SKILL.md):**

| Skill | Location | Has SKILL.md |
|---|---|---|
| knowledge-file-producer | `reference/skills/knowledge-file-producer/` | Yes |
| report-compliance-qc | `reference/skills/report-compliance-qc/` | Yes |

**Symlinked skills (76):** All are symlinks pointing to `../../../../ai-resources/skills/[name]`. All 76 targets resolve and have accessible SKILL.md files.

Total skills in `reference/skills/`: 78 (76 symlinks + 2 local). All 78 have SKILL.md files. None found without SKILL.md — checked by iterating all 78 directories.

Section summary: 78 skills catalogued, 0 missing SKILL.md / no previous audit (baseline)

---

### 1.6 Uncategorized files

The following files exist in the repo and are not slash commands, hooks, templates, scripts, skills, CLAUDE.md, or standard git files:

| File path | Description |
|---|---|
| `.claude/settings.json` | Project permissions and hook configuration |
| `.claude/shared-manifest.json` | Declares which .claude/ files are shared (symlinked) vs local |
| `.gitignore` | Git ignore rules (excludes .DS_Store, session-marker state files) |
| `docs/project-config-schema.md` | Schema documentation for Project Config block in CLAUDE.md |
| `docs/required-reference-files.md` | List of reference files required by workflow deployment |
| `logs/.gitkeep` | Directory placeholder |
| `logs/.prime-mtime` | Session-marker protocol state (gitignored) |
| `logs/.session-marker` | Active session marker (gitignored) |
| `logs/.session-marker-6a83bfc8-8776-49e0-8149-a689b4d983d8` | Session marker instance (gitignored) |
| `logs/decisions.md` | Decision journal (11 lines) |
| `logs/friction-log.md` | Friction log (22 lines) |
| `logs/innovation-registry.md` | Innovation registry (4 lines) |
| `logs/qc-log.md` | QC log (5 lines) |
| `logs/research-quality-log.md` | Cross-project extract quality tracking (12 lines) |
| `logs/session-notes.md` | Session notes (34 lines) |
| `preparation/answer-specs/1.1/answer-specs-qc.md` | QC verdicts for answer specs |
| `preparation/answer-specs/1.1/chapter-01-specs.md` through `chapter-05-specs.md` | Answer specifications, 5 files |
| `preparation/checkpoints/1.1-step-1-checkpoint.md` | Step 1 checkpoint |
| `preparation/checkpoints/1.1-step-3-checkpoint.md` | Step 3 checkpoint |
| `preparation/checkpoints/1.1-step-4-checkpoint.md` | Step 4 checkpoint |
| `preparation/checkpoints/1.1-step-5-checkpoint.md` | Step 5 checkpoint |
| `preparation/research-plans/1.1-research-plan-v1.md` | Research plan v1 |
| `preparation/research-plans/1.1-research-plan-v2.md` | Research plan v2 |
| `preparation/task-plans/1.1-task-plan-v1.md` | Task plan v1 |
| `reference/file-conventions.md` | File naming rules |
| `reference/known-limits.md` | Known limits reference |
| `reference/language-search-blocks.md` | Language search blocks |
| `reference/quality-standards.md` | QC standards and evidence handling |
| `reference/source-class-hierarchy.md` | Source classification hierarchy |
| `reference/stage-5-common-phases.md` | Stage 5 common phases reference |
| `reference/stage-5-paths.template.md` | Stage 5 path configuration template |
| `reference/stage-instructions.md` | Full stage sequence instructions |
| `reference/style-guide.md` | Writing voice and style |
| `reference/sops/evidence-pack-compressor-gpt.md` | SOP for evidence pack compression |
| `reference/sops/fact-verification-prompt.md` | SOP for fact verification |
| `reference/sops/research-executor-gpt.md` | SOP for research execution GPT |
| Multiple `.gitkeep` files | Directory placeholders (analysis/, execution/, final/, output/, report/ subdirs, reference/templates/, reference/scoping-notes/, usage/, reports/) |

Section summary: 37 non-standard files catalogued (excluding gitkeeps) / no previous audit (baseline)

---

### 1.7 Symlinks

Total symlinks: 155 (55 command symlinks, 24 agent symlinks, 76 skill symlinks).

All symlinks point into the parent workspace's `ai-resources/` directory using relative paths (`../../../../ai-resources/...`). All 155 targets exist and are accessible.

**Command symlinks** (55): all at `.claude/commands/[name].md → ../../../../ai-resources/.claude/commands/[name].md`. All resolve.

**Agent symlinks** (24): all at `.claude/agents/[name].md → ../../../../ai-resources/.claude/agents/[name].md`. All resolve.

**Skill symlinks** (76): all at `reference/skills/[name] → ../../../../ai-resources/skills/[name]`. All resolve.

Section summary: 155 symlinks catalogued, 0 broken / no previous audit (baseline)

---

## Section 2: CLAUDE.md Health

### 2.1 CLAUDE.md size and sections

CLAUDE.md: **149 lines**. **18 distinct sections.**

Section headings:
1. Project Context
2. Operator Profile
3. Project Config
4. Confidentiality Boundaries
5. Workflow Overview
6. Skill Dependency Chain
7. Workflow Status Command
8. Utility Commands
9. Cross-Model Rules
10. Autonomy Rules
11. Context Isolation Rules
12. Friction Logging
13. Citation Conversion Rule
14. Bright-Line Rule
15. Input File Handling
16. File Verification and Git Commits
17. Commit Rules
18. Compaction
19. Session Boundaries

(Note: 19 headings in document, 18 distinct sections — one heading is from `## Project Context` through `## Session Boundaries` yielding 19 `##`-level sections.)

Section summary: 1 item / no previous audit (baseline)

---

### 2.2 Dead references in CLAUDE.md

Checked all file/path references in CLAUDE.md against the AUDIT_ROOT filesystem and ai-resources/:

| Reference | Exists? | Notes |
|---|---|---|
| `reference/stage-instructions.md` | Yes | Exists at `reference/stage-instructions.md` |
| `reference/file-conventions.md` | Yes | Exists at `reference/file-conventions.md` |
| `reference/quality-standards.md` | Yes | Exists |
| `reference/style-guide.md` | Yes | Exists |
| `docs/project-config-schema.md` | Yes | Exists at `docs/project-config-schema.md` |
| `docs/required-reference-files.md` | Yes | Exists |
| `preparation/research-plans/1.1-research-plan-v2.md` | Yes | Exists |
| `ai-resources/skills/` (referenced in `## Workflow Status Command`) | Yes | Accessible via additionalDirectories |
| `reference/skills/workflow-evaluator` (implied by workflow-status cmd) | Yes | Symlink resolves |

None found — checked all file references in CLAUDE.md against the filesystem. All referenced paths exist.

Section summary: 0 issues flagged / no previous audit (baseline)

---

### 2.3 Contradictions in CLAUDE.md

One potential inconsistency found:

**Item:** CLAUDE.md § Skill Dependency Chain (line 61) lists `answer-spec-generator` as a step in the chain. The run-preparation.md command (line 49) reads `/ai-resources/skills/answer-spec-generator/SKILL.md`. This skill exists. However, the chain also reads `→ [external: GPT-5 execution]` while § Cross-Model Rules (line 75) says "Research Execution GPT produces evidence." The Skill Dependency Chain labels the external tool as "GPT-5 execution" and the Cross-Model Rules and run-execution.md command consistently call it "Research Execution GPT." These are two names for the same tool but are not identical strings.

No other contradictions found — checked all 18 sections for conflicting statements.

Section summary: 1 inconsistency flagged (GPT-5 vs Research Execution GPT naming) / no previous audit (baseline)

---

### 2.4 Conventions defined in CLAUDE.md not followed by actual files

CLAUDE.md § Workflow Overview states: "For file naming rules, read `reference/file-conventions.md`." No violations detectable from a structural audit without reading every artifact file against the full naming spec.

CLAUDE.md § Project Config mentions `reference/stage-5-paths.md` (indirectly via Stage 5 commands). That file is **missing** — only `reference/stage-5-paths.template.md` exists. The three Stage 5 commands (produce-prose-draft, produce-formatting, produce-jargon-gloss) each halt at runtime if `reference/stage-5-paths.md` is absent. This is a pre-production required artifact, not yet needed at current pipeline stage (Stage 1 complete; Stage 5 is the final stage).

Section summary: 1 issue flagged (reference/stage-5-paths.md missing) / no previous audit (baseline)

---

### 2.5 Partially-present features

| Feature | What exists | What is missing |
|---|---|---|
| Stage 5 path-config | `reference/stage-5-paths.template.md` exists | `reference/stage-5-paths.md` does not exist; required at runtime by produce-prose-draft, produce-formatting, produce-jargon-gloss |
| `audit-repo.md` command | Command file exists; skill symlink `reference/skills/repo-health-analyzer` resolves | `reference/skills/repo-health-analyzer/agents/` directory resolves via symlink target; exists in ai-resources |
| `session-plan.md` command | Command file exists | `docs/session-marker.md` referenced by session-plan.md is not in project `docs/` (only `docs/project-config-schema.md` and `docs/required-reference-files.md` exist); the file exists at `ai-resources/docs/session-marker.md`. The session-plan.md command uses bare `docs/session-marker.md` path, which in the project context resolves to local `docs/` — meaning the reference is to a non-existent local file. Note: symlinked commands (drift-check, contract-check, open-items) also reference `docs/session-marker.md` but execute in the ai-resources context where the file exists. |

Section summary: 2 partially-present features / no previous audit (baseline)

---

### 2.6 Task-type-specific instructions in CLAUDE.md

Per the questionnaire: checking for sections containing skill-creation methodology, workflow-stage instructions, evaluation frameworks, or file-format conventions that belong in SKILL.md or workflow reference docs rather than CLAUDE.md.

| Section | Approximate line count | Task-type addressed | Scoping assessment |
|---|---|---|---|
| Input File Handling | ~18 lines | File write discipline | Self-describes as a repeat: "This rule mirrors the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded." |
| Commit Rules | ~7 lines | Git commit behavior | Self-describes as a repeat: "This rule mirrors the canonical `Commit behavior` section in the workspace-level `CLAUDE.md`." |
| Autonomy Rules | ~9 lines | When to pause for operator | Project-specific variant (different pause conditions from workspace); not a repeat |
| Skill Dependency Chain | ~5 lines | Pipeline sequencing | Describes which skills form a chain; belongs to workflow methodology. Referenced structure exists in `reference/stage-instructions.md` |

The workspace CLAUDE.md "CLAUDE.md Scoping" rule states: "Do not put in project CLAUDE.md: Skill methodology. Belongs in SKILL.md. Workflow methodology. Belongs in the workflow's reference docs." The Skill Dependency Chain section (~5 lines) describes workflow stage sequencing, not cross-session project-specific rules.

Section summary: 1 scoping issue flagged (Skill Dependency Chain section carries workflow methodology that belongs in reference docs) / no previous audit (baseline)

---

## Section 3: Dependency References

### 3.1 Files referenced by each slash command with existence check

**Local commands — key file references:**

| Command | Referenced file | Exists |
|---|---|---|
| audit-repo.md | `reference/skills/repo-health-analyzer/agents/repo-health-analyzer.md` | Yes (via symlink target) |
| audit-repo.md | `reference/skills/repo-health-analyzer/agents/file-org-auditor.md` | Yes (via symlink target) |
| audit-repo.md | `reference/skills/repo-health-analyzer/agents/claude-md-auditor.md` | Yes (via symlink target) |
| audit-repo.md | `reference/skills/repo-health-analyzer/agents/skill-auditor.md` | Yes (via symlink target) |
| audit-repo.md | `reference/skills/repo-health-analyzer/agents/command-auditor.md` | Yes (via symlink target) |
| audit-repo.md | `reference/skills/repo-health-analyzer/agents/settings-auditor.md` | Yes (via symlink target) |
| audit-repo.md | `reference/skills/repo-health-analyzer/agents/practices-auditor.md` | Yes (via symlink target) |
| consult.md | `ai-resources/docs/change-shape-classifier.md` | Yes (accessible via additionalDirectories) |
| produce-prose-draft.md | `reference/stage-5-paths.md` | **No** (missing; only template exists) |
| produce-prose-draft.md | `reference/skills/` (multiple skills via chain) | Yes (all symlinks resolve) |
| produce-formatting.md | `reference/stage-5-paths.md` | **No** (missing) |
| produce-jargon-gloss.md | `reference/stage-5-paths.md` | **No** (missing) |
| run-cluster.md | `reference/source-class-hierarchy.md` | Yes |
| run-cluster.md | `reference/quality-standards.md` | Yes |
| run-cluster.md | `reference/known-limits.md` | Yes |
| run-execution.md | `reference/source-class-hierarchy.md` | Yes |
| run-execution.md | `reference/quality-standards.md` | Yes |
| run-preparation.md | `/ai-resources/skills/task-plan-creator/SKILL.md` | Yes |
| run-preparation.md | `/ai-resources/skills/research-plan-creator/SKILL.md` | Yes |
| run-preparation.md | `/ai-resources/skills/answer-spec-generator/SKILL.md` | Yes |
| run-preparation.md | `/ai-resources/skills/answer-spec-qc/SKILL.md` | Yes |
| run-sufficiency.md | `reference/source-class-hierarchy.md` | Yes |
| run-sufficiency.md | `reference/quality-standards.md` | Yes |
| run-sufficiency.md | `reference/known-limits.md` | Yes |
| session-plan.md | `logs/session-notes.md` | Yes |
| session-plan.md | `docs/session-marker.md` | **No** (not in local `docs/`; exists at `ai-resources/docs/session-marker.md`) |
| workflow-status.md | `reference/stage-instructions.md` | Yes |
| wrap-session.md | `logs/session-notes.md` | Yes |
| wrap-session.md | `logs/decisions.md` | Yes |
| wrap-session.md | `logs/innovation-registry.md` | Yes |
| wrap-session.md | `logs/scripts/check-archive.sh` | Yes |

**Symlinked commands** resolve against the ai-resources repo context. Not audited for internal file references (out of scope for project-level audit).

Section summary: 4 reference failures flagged (`reference/stage-5-paths.md` — 3 commands; `docs/session-marker.md` — 1 command) / no previous audit (baseline)

---

### 3.2 Command output chains

| Producer command | Output | Consumer command |
|---|---|---|
| run-preparation | `/preparation/task-plans/{section}-task-plan-v1.md` | (operator gate then) run-execution |
| run-preparation | `/preparation/research-plans/{section}-research-plan-v{n}.md` | run-execution |
| run-preparation | `/preparation/answer-specs/{section}/chapter-NN-specs.md` | run-execution |
| run-execution | `/execution/manifest/{section}/`, research prompts | (manual GPT execution, then) run-cluster |
| run-execution | `/execution/research-extracts/{section}/` | run-cluster |
| run-cluster | `/analysis/{section}/cluster-memos-refined/` | run-sufficiency |
| run-sufficiency | `/analysis/gate-clearance/{section}/{section}-gate-clearance.md` | run-analysis, run-synthesis |
| run-analysis | Section directives, gap-assessment | run-synthesis, run-report |
| run-synthesis | Chapter drafts | run-report, produce-prose-draft |
| produce-prose-draft | Reviewed prose | produce-formatting |
| produce-formatting | Formatted prose | (final delivery) |
| produce-jargon-gloss | Glossed prose | produce-formatting (standalone use) |
| produce-knowledge-file | Knowledge file | (manual deploy to Notion) |

Section summary: Pipeline chain well-defined / no previous audit (baseline)

---

### 3.3 Files referenced by more than one command/hook/script

| File | Referenced by |
|---|---|
| `reference/stage-instructions.md` | workflow-status, CLAUDE.md (Context Isolation Rules, Citation Conversion Rule, Bright-Line Rule pointers) |
| `reference/source-class-hierarchy.md` | run-execution, run-cluster, run-sufficiency |
| `reference/quality-standards.md` | run-execution, run-cluster, run-sufficiency |
| `reference/known-limits.md` | run-cluster, run-sufficiency |
| `reference/stage-5-paths.md` | produce-prose-draft, produce-formatting, produce-jargon-gloss |
| `logs/session-notes.md` | prime, session-plan, wrap-session, status, drift-check (symlink), contract-check (symlink), open-items (symlink) |
| `logs/decisions.md` | wrap-session, UserPromptSubmit hook (inline), run-synthesis (auto-appended on OPERATOR-OVERRIDE), run-analysis |
| `logs/friction-log.md` | friction-log-auto.sh, log-write-activity.sh |
| `logs/innovation-registry.md` | detect-innovation.sh, wrap-session |
| `/ai-resources/skills/answer-spec-qc/SKILL.md` | run-preparation, run-execution (prerequisite QC step) |
| `docs/session-marker.md` | session-plan (local), drift-check (symlink), contract-check (symlink), open-items (symlink) |

Section summary: 11 multiply-referenced files / no previous audit (baseline)

---

### 3.4 Top 10 files by downstream reference count

| Rank | File | Reference count | Referenced by |
|---|---|---|---|
| 1 | `reference/stage-instructions.md` | 4+ | workflow-status, CLAUDE.md (×3 section pointers), run-cluster preamble |
| 2 | `logs/session-notes.md` | 6 | prime, session-plan, wrap-session, status, drift-check, contract-check |
| 3 | `reference/quality-standards.md` | 3 | run-execution, run-cluster, run-sufficiency |
| 4 | `reference/source-class-hierarchy.md` | 3 | run-execution, run-cluster, run-sufficiency |
| 5 | `reference/stage-5-paths.md` | 3 | produce-prose-draft, produce-formatting, produce-jargon-gloss |
| 6 | `reference/known-limits.md` | 2 | run-cluster, run-sufficiency |
| 7 | `logs/decisions.md` | 3 | wrap-session, UserPromptSubmit hook, run-synthesis/run-analysis |
| 8 | `docs/session-marker.md` | 4 | session-plan, drift-check, contract-check, open-items |
| 9 | `logs/friction-log.md` | 2 | friction-log-auto.sh, log-write-activity.sh |
| 10 | `logs/innovation-registry.md` | 2 | detect-innovation.sh, wrap-session |

Section summary: 10 files ranked / no previous audit (baseline)

---

### 3.5 Symlinks with targets not covered by permissions.additionalDirectories

`permissions.additionalDirectories` contains: `["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]`

All 155 symlinks target paths under `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/`. The workspace root `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` is a string-prefix ancestor of all symlink targets. All targets are covered.

None found — checked all 155 symlink targets against `permissions.additionalDirectories` entries. All are covered.

Section summary: 0 issues flagged / no previous audit (baseline)

---

### 3.6 Projects referencing ai-resources without coverage in additionalDirectories

This project (the only project in AUDIT_ROOT) references `ai-resources/` via 155 symlinks and CLAUDE.md § Workflow Status Command. `permissions.additionalDirectories` lists `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`, which covers `ai-resources/` as a subdirectory.

None found — checked `.claude/settings.json` and confirmed workspace root covers ai-resources path.

Section summary: 0 issues flagged / no previous audit (baseline)

---

## Section 4: Consistency Checks

### 4.1 Skills structural pattern consistency

All 78 skills in `reference/skills/` have a `SKILL.md` file at the top level of their directory. No skills without SKILL.md. Local skills (knowledge-file-producer, report-compliance-qc) follow the same SKILL.md pattern as the symlinked skills.

Checked: 78 skill directories, all contain SKILL.md. None deviate from the structural pattern.

Section summary: 0 issues flagged / no previous audit (baseline)

---

### 4.2 Slash command definition pattern consistency

All 86 commands have YAML frontmatter. Sampled local commands confirm `model:` field present in all checked files. One deviation found:

**log-sweep.md** (symlink to ai-resources): declares `model: claude-sonnet-4-6[1m]`. This is a non-standard model identifier compared to all other commands which use `model: sonnet`, `model: opus`, or `model: haiku`. This is in a symlinked command (ai-resources scope) but is surfaced here for completeness.

All local commands have `model:` frontmatter. Checked all 31 local command files.

Section summary: 1 deviation flagged (log-sweep.md uses `model: claude-sonnet-4-6[1m]`) / no previous audit (baseline)

---

### 4.3 Skill template comparison

N/A — No skill creation template file exists. Skills are created via /create-skill which references ai-resource-builder/SKILL.md for format standards.

---

### 4.4 Naming convention inconsistencies

No naming convention inconsistencies found among the 86 commands (all use kebab-case `.md` filenames), 28 agents (all use kebab-case `.md` filenames), and 78 skills (all use kebab-case directory names).

The two local skills (`knowledge-file-producer`, `report-compliance-qc`) follow the same naming pattern as all symlinked skills.

Section summary: 0 issues flagged / no previous audit (baseline)

---

### 4.5 Directory structure violations

CLAUDE.md describes these directories: `preparation/`, `execution/`, `analysis/`, `report/`, `final/`, `logs/`, `reference/`, `docs/`, `output/`.

The following directories exist in the repo:
- `preparation/` — present, has subdirs (answer-specs, checkpoints, research-plans, task-plans)
- `execution/` — present, has subdirs (all empty with .gitkeep)
- `analysis/` — present, has subdirs (all empty with .gitkeep)
- `report/` — present, has subdirs (all empty with .gitkeep)
- `final/` — present, has `modules/` (empty)
- `logs/` — present, has content
- `reference/` — present, has content
- `docs/` — present, has 2 files
- `output/` — present, has `knowledge-files/` (empty)
- `reports/` — present (empty with .gitkeep); distinct from `report/`
- `usage/` — present (empty with .gitkeep)

`reports/` and `usage/` are not mentioned in CLAUDE.md. Both exist and are empty (placeholder only).

Section summary: 2 uncatalogued directories (reports/, usage/) / no previous audit (baseline)

---

### 4.6 Command definition syntax and path resolution failures

Checked all 31 local commands for syntax and path resolution. Failures:

| Command | Failure type | Detail |
|---|---|---|
| produce-prose-draft.md | Runtime path resolution failure | `reference/stage-5-paths.md` missing; command halts at Phase 0 Step 3 if invoked |
| produce-formatting.md | Runtime path resolution failure | `reference/stage-5-paths.md` missing; command halts at Phase 0 if invoked |
| produce-jargon-gloss.md | Runtime path resolution failure | `reference/stage-5-paths.md` missing; command halts at Phase 0 if invoked |
| session-plan.md | Runtime path resolution failure | `docs/session-marker.md` referenced but not in local `docs/`; command hard-fails at Step 0 if marker resolution is attempted |

All 3 Stage 5 commands (produce-prose-draft, produce-formatting, produce-jargon-gloss) are not needed until Stage 5. The pipeline is currently at the start of Stage 2.

Section summary: 4 commands with path resolution failures / no previous audit (baseline)

---

### 4.7 Duplicate or built-in command name conflicts

Checked all 86 command names for duplicates within the project. No duplicate command names found.

Checked for conflicts with known Claude Code built-in commands (clear, compact, model, add, remove, resume). No conflicts found.

Section summary: 0 issues flagged / no previous audit (baseline)

---

### 4.8 Agent tier compliance

The Agent Tier Table is at `ai-resources/docs/agent-tier-table.md`. The table covers agents in the canonical `ai-resources/.claude/agents/` scope and explicitly lists project-local copies for other projects. This project's 4 local agents are not yet in the Agent Tier Table.

Checking declared tiers against the table for symlinked agents (24):

| Agent | Declared tier | Table entry | Status |
|---|---|---|---|
| claude-md-auditor | opus | opus | Match |
| collaboration-coach | opus | opus | Match |
| context-discovery | opus | Not in table | Missing from table |
| dd-extract-agent | haiku | haiku | Match |
| dd-log-sweep-agent | haiku | haiku | Match |
| fading-gate-scanner | haiku | haiku | Match |
| findings-extractor | haiku | haiku | Match |
| fix-repo-issues-scanner | sonnet | sonnet | Match |
| friday-act-16a-summarizer | sonnet | sonnet | Match |
| innovation-triage-auditor | opus | opus | Match |
| log-sweep-auditor | haiku | haiku | Match |
| permission-sweep-auditor | sonnet | sonnet | Match |
| project-manager | opus | opus | Match |
| qc-reviewer | opus | opus | Match |
| refinement-reviewer | opus | opus | Match |
| repo-dd-auditor | sonnet | sonnet | Match |
| risk-check-reviewer | opus | opus | Match |
| session-feedback-collector | opus | opus | Match |
| system-owner | opus | opus | Match |
| token-audit-auditor | opus | opus | Match |
| token-audit-auditor-mechanical | haiku | haiku | Match |
| triage-reviewer | opus | opus | Match |
| workflow-analysis-agent | opus | opus | Match |
| workflow-critique-agent | opus | opus | Match |

**context-discovery** declares `model: opus` but is not listed in the Agent Tier Table.

For the 4 local agents (not symlinked), the Agent Tier Table has a section for each other project's local copies but no section for this project (research-pe-regime-shift-advisory-gap). The 4 local agents and their declared tiers:

| Agent | Declared tier | Table entry |
|---|---|---|
| execution-agent | sonnet | Not in table (no section for this project) |
| improvement-analyst | opus | Not in table |
| qc-gate | sonnet | Not in table |
| verification-agent | sonnet | Not in table |

The table maintains sections for other projects (nordic-pe-macro-landscape-H1-2026, axcion-brand-book, strategic-os, ai-development-lab). No section exists for research-pe-regime-shift-advisory-gap.

Section summary: 5 agents missing from Agent Tier Table (context-discovery, plus 4 local agents with no project section) / no previous audit (baseline)

---

### 4.9 Settings.json canonical baseline comparison

Reference: `ai-resources/.claude/commands/new-project.md` CANONICAL_PERMS block (last commit: 2026-06-01 20:23:22).

**Project `.claude/settings.json`** (last commit: 2026-06-01 20:23:22):

`permissions.deny` entries in this project:
- `Bash(rm -rf *)`
- `Bash(sudo *)`
- `Read(archive/**)`
- `Read(**/*.archive.*)`
- `Read(logs/*-archive-*.md)`
- `Read(**/deprecated/**)`
- `Read(**/old/**)`

Canonical minimum per new-project.md: `Read(archive/**)`. Present in this project.

`"model"` at top level of settings.json: **NOT SET**. The workspace CLAUDE.md "Model Tier" rule explicitly prohibits declaring `"model"` at the top level. Correct.

The project settings.json and new-project.md canonical CANONICAL_PERMS block share the same commit date (2026-06-01 20:23:22), indicating the settings.json was created from the template at the same point.

Section summary: 0 issues flagged (settings.json conforms to canonical baseline; model field correctly absent) / no previous audit (baseline)

---

## Section 5: Context Load

### 5.1 Estimated context loaded at session start

| Source | Approximate lines |
|---|---|
| Project CLAUDE.md | 149 |
| Workspace CLAUDE.md (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md`) | 217 |
| SessionStart hooks (checkpoint output, template drift, auto-sync, log size check) | Runtime output; variable, typically <30 lines |
| **Estimated total** | ~366+ lines (static) |

No `.claude/references/` directory exists in this project, so no additional reference files are auto-loaded via that mechanism.

Section summary: ~366 lines estimated context at session start / no previous audit (baseline)

---

### 5.2 CLAUDE.md sections not referenced by any command, hook, or operational instruction

| Section | Approximate lines | Assessment |
|---|---|---|
| Project Context | ~15 | Referenced implicitly as background; no command explicitly reads it |
| Operator Profile | ~4 | Background; no command reads it |
| Confidentiality Boundaries | ~2 | Background; no command reads it |
| Skill Dependency Chain | ~6 | Informational; no command reads it by reference; the actual skill loading is done directly in run-preparation.md |
| Workflow Status Command | ~3 | Documents /workflow-status command; is effectively index/pointer |
| Utility Commands | ~2 | Documents /audit-repo; is index/pointer |

The following sections ARE referenced by operational instructions: Project Config (produce-prose-draft, produce-formatting, produce-jargon-gloss all read Document model field), Workflow Overview (pointers to referenced files), Autonomy Rules (operative rules for pipeline execution), Cross-Model Rules (operative), Context Isolation Rules (pointer to stage-instructions.md), Friction Logging (operative), Citation Conversion Rule (pointer), Bright-Line Rule (pointer + enforced by Edit PreToolUse hook), Input File Handling (operative), File Verification and Git Commits (operative), Commit Rules (operative), Compaction (operative), Session Boundaries (operative).

Section summary: 6 sections not directly referenced by commands/hooks (all are background/informational context) / no previous audit (baseline)

---

### 5.3 CLAUDE.md line count history

| Commit hash | Date | Line count |
|---|---|---|
| 77ea2ea | 2026-06-01 20:23:22 | 149 |

Only 1 commit has modified CLAUDE.md (the init commit). No prior history.

Section summary: 1 commit in CLAUDE.md history (baseline init only) / no previous audit (baseline)

---

## Section 6: Drift & Staleness

### 6.1 Files not modified in last 90 days but still referenced

The oldest commit in this repository is 2026-06-01 (less than 2 days old). All files were committed on 2026-06-01 or 2026-06-02. No files in the repository are older than 90 days.

None found — checked by repository age (oldest commit: 2026-06-01). All files are within 2 days of audit date.

Section summary: 0 issues flagged / no previous audit (baseline)

---

### 6.2 TODO, FIXME, PLACEHOLDER, or similar markers

Searched all `.md`, `.sh`, and `.json` files under AUDIT_ROOT excluding `.git/` and `reference/skills/` (external symlink targets).

No TODO, FIXME, PLACEHOLDER, or XXX markers found in any file.

One pending-work item is noted in CLAUDE.md prose (not a formal marker): line 7 states "The Task Plan v1 still carries the old single-thesis framing and is pending a follow-up update." This is a prose note, not a formal `TODO:` or `FIXME:` marker. The task plan v1 content confirms it does not carry explicit sourcing-edge-thesis walling as described in the CLAUDE.md note about pre-re-aim framing (the framing is narrower than the re-aimed version but not in explicit contradiction).

Section summary: 0 formal markers found; 1 prose pending-work note in CLAUDE.md line 7 / no previous audit (baseline)

---

### 6.3 Empty files, stub files, or files with only boilerplate

| File | Status |
|---|---|
| `reference/templates/.gitkeep` | Empty (0 bytes, placeholder only) |
| All other `.gitkeep` files (12 total across analysis/, execution/, final/, output/, preparation/, reference/scoping-notes/, reference/templates/, report/, reports/, usage/) | Empty (0 bytes, placeholders only) |
| `logs/research-quality-log.md` | Contains only header/column-definitions row; table body has no data rows. Boilerplate with no data content yet. |
| `logs/innovation-registry.md` | 4 lines; contains header only with no entries. Boilerplate. |
| `logs/qc-log.md` | 5 lines; contains header only. Boilerplate. |

Empty files: 13 `.gitkeep` files. Stub/boilerplate files: `logs/research-quality-log.md`, `logs/innovation-registry.md`, `logs/qc-log.md`.

Section summary: 16 empty/stub files (13 gitkeeps, 3 log stubs) / no previous audit (baseline)

---

## Shared-manifest consistency note

The `.claude/shared-manifest.json` lists commands and agents as `"local"` or `"shared"`. Cross-checking against actual file types:

**Discrepancy: 4 commands listed as `"shared"` are NOT symlinks:**

| Command | Manifest declaration | Actual type |
|---|---|---|
| note.md | shared | Regular file (not symlink) |
| qc-pass.md | shared | Regular file (not symlink) |
| refinement-pass.md | shared | Regular file (not symlink) |
| update-claude-md.md | shared | Regular file (not symlink) |

**Discrepancy: 52 commands are symlinks but not listed in shared-manifest at all.** The manifest's `"shared"` section lists only 10 commands, and `"local"` lists 24, totaling 34. However, 86 commands exist. The remaining 52 (all symlinks) are not classified in the manifest.

Similarly, the manifest lists 6 shared agents and 4 local agents (10 total), but 28 agents exist. The remaining 18 symlinked agents are not in the manifest.

The manifest appears to be a subset declaration, not a complete inventory.

---

*End of audit report.*
