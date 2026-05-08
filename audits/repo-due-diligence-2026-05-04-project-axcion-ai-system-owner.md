# Repo Due Diligence Audit — 2026-05-04
Repo: projects/axcion-ai-system-owner
Scope: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner
Commit: 2ddff85
Previous audit: None
Depth: standard

---

## Section 1: Inventory

### 1.1 Slash commands currently defined

Three project-local commands and 41 symlinked commands are present under `.claude/commands/`.

**Project-local commands:**

| Name | File | Referenced Agents / Files |
|---|---|---|
| `/consult` | `.claude/commands/consult.md` | `system-owner` agent (Task tool); `ai-resources/docs/repo-architecture.md` (change-shape path) |
| `/architecture-review` | `.claude/commands/architecture-review.md` | `system-owner` agent (Task tool); `ai-resources/audits/` (glob for 4 audit types) |
| `/implementation-triage` | `.claude/commands/implementation-triage.md` | `system-owner` agent (Task tool) |

**Symlinked commands (41 total — symlinks to ai-resources; all broken; see Q1.7):**
analyze-workflow.md, audit-claude-md.md, audit-critical-resources.md, audit-repo.md, clarify.md, cleanup-worktree.md, coach.md, create-skill.md, friction-log.md, friday-act.md, friday-checkup.md, graduate-resource.md, improve-skill.md, improve.md, innovation-sweep.md, migrate-skill.md, note.md, permission-sweep.md, prime.md, project-consultant.md, qc-pass.md, recommend.md, refinement-deep.md, refinement-pass.md, repo-dd.md, request-skill.md, resolve-improvement-log.md, resolve.md, risk-check.md, route-change.md, save-session.md, scope.md, session-guide.md, session-plan.md, summary.md, sync-workflow.md, token-audit.md, triage.md, update-claude-md.md, usage-analysis.md, wrap-session.md

### 1.2 Hooks configured

Source: `.claude/settings.json`. No `.claude/settings.local.json` present.

**SessionStart — hook 1:**
- Trigger: `SessionStart`
- Action: walks up from `$CLAUDE_PROJECT_DIR` to find `ai-resources/.claude/hooks/auto-sync-shared.sh` and executes it
- Referenced file: `ai-resources/.claude/hooks/auto-sync-shared.sh` — exists at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/auto-sync-shared.sh`
- Timeout: 10 seconds
- Status message: "Syncing shared commands from ai-resources..."

**SessionStart — hook 2:**
- Trigger: `SessionStart`
- Action: walks up from `$CLAUDE_PROJECT_DIR` to find `ai-resources/.claude/hooks/check-permission-sanity.sh` and executes it
- Referenced file: `ai-resources/.claude/hooks/check-permission-sanity.sh` — exists at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-permission-sanity.sh`
- Timeout: 5 seconds
- Status message: "Permission sanity check..."

No other hook triggers configured (no PreToolCall, PostToolCall, Stop, or other hooks).

### 1.3 Template files

None found — checked all files under AUDIT_ROOT for template naming patterns and template-role descriptions. No file serves as a template that slash commands populate. The three local commands do not reference any template files; they construct agent briefs inline.

### 1.4 Scripts (bash, python, or other)

None found within AUDIT_ROOT — checked all files under `projects/axcion-ai-system-owner/` for `.sh`, `.py`, `.js`, and similar extensions. The hook scripts referenced in settings.json (`auto-sync-shared.sh`, `check-permission-sanity.sh`) reside in `ai-resources/.claude/hooks/` which is outside AUDIT_ROOT.

### 1.5 Skills

0 skills in AUDIT_ROOT. No `SKILL.md` files found — checked all paths under `projects/axcion-ai-system-owner/` recursively.

CLAUDE.md explicitly states "No skill symlinks at v1" and notes that `additionalDirectories` permission grant covers cross-project reads of skill files.

### 1.6 Uncategorized files

The following files are not categorized as skills, templates, scripts, slash commands, hooks, CLAUDE.md, audits, or standard git files:

| Path | Category |
|---|---|
| `pipeline/architecture.md` (459 lines) | Pipeline artifact (Stage 3b — architecture design) |
| `pipeline/context-pack.md` (172 lines) | Pipeline artifact (Stage 3a input — copied from project-planning output) |
| `pipeline/decisions.md` (9 lines) | Pipeline artifact (locked decisions log) |
| `pipeline/implementation-log.md` (99 lines) | Pipeline artifact (Stage 4 — implementation log) |
| `pipeline/implementation-spec.md` (1380 lines) | Pipeline artifact (Stage 3c — implementation spec) |
| `pipeline/pipeline-state.md` (14 lines) | Pipeline artifact (stage-completion tracker) |
| `pipeline/project-plan.md` (733 lines) | Pipeline artifact (Stage 3a — operator-approved project plan) |
| `pipeline/repo-snapshot.md` (457 lines) | Pipeline artifact (Stage 3a — repo state at project start) |
| `pipeline/sources.md` (6 lines) | Pipeline provenance log (records copy sources for pipeline inputs) |
| `pipeline/test-results.md` (208 lines) | Pipeline artifact (Stage 5 — test results) |
| `references/persona.md` (91 lines) | Agent reference doc (read by system-owner on every invocation) |
| `references/grounding.md` (136 lines) | Agent reference doc (per-function read map) |
| `references/toolkit-relationship.md` (69 lines) | Agent reference doc (integration mechanism map) |
| `references/systems-building-principles.md` (17 lines) | Placeholder reference doc (not-yet-active; status: TBD) |
| `.claude/shared-manifest.json` | Auto-sync control file (declares local agents/commands to skip during sync) |
| `logs/.gitkeep` | Empty placeholder file (git-tracked placeholder for empty directory) |
| `output/.gitkeep` | Empty placeholder file (git-tracked placeholder for empty directory) |
| `output/architecture-reviews/` (empty directory) | Output directory for `/architecture-review` reports |

### 1.7 Symlinks

All symlinks in the project are located in `.claude/agents/` (19 symlinks) and `.claude/commands/` (41 symlinks). All 60 symlinks use relative target paths of the form `./ai-resources/.claude/agents/<name>.md` or `./ai-resources/.claude/commands/<name>.md`. These relative paths are evaluated from within the `.claude/agents/` or `.claude/commands/` directory respectively, resolving to paths of the form `.claude/agents/ai-resources/.claude/agents/<name>.md` — a path that does not exist. All 60 symlinks are broken.

**Agent symlinks (19 — all broken):**

| Symlink Path | Declared Target (relative) | Resolved Absolute Path | Accessible |
|---|---|---|---|
| `.claude/agents/claude-md-auditor.md` | `./ai-resources/.claude/agents/claude-md-auditor.md` | `.claude/agents/ai-resources/.claude/agents/claude-md-auditor.md` | NO |
| `.claude/agents/collaboration-coach.md` | `./ai-resources/.claude/agents/collaboration-coach.md` | `.claude/agents/ai-resources/.claude/agents/collaboration-coach.md` | NO |
| `.claude/agents/critical-resource-auditor.md` | `./ai-resources/.claude/agents/critical-resource-auditor.md` | `.claude/agents/ai-resources/.claude/agents/critical-resource-auditor.md` | NO |
| `.claude/agents/dd-extract-agent.md` | `./ai-resources/.claude/agents/dd-extract-agent.md` | `.claude/agents/ai-resources/.claude/agents/dd-extract-agent.md` | NO |
| `.claude/agents/dd-log-sweep-agent.md` | `./ai-resources/.claude/agents/dd-log-sweep-agent.md` | `.claude/agents/ai-resources/.claude/agents/dd-log-sweep-agent.md` | NO |
| `.claude/agents/execution-agent.md` | `./ai-resources/.claude/agents/execution-agent.md` | `.claude/agents/ai-resources/.claude/agents/execution-agent.md` | NO |
| `.claude/agents/findings-extractor.md` | `./ai-resources/.claude/agents/findings-extractor.md` | `.claude/agents/ai-resources/.claude/agents/findings-extractor.md` | NO |
| `.claude/agents/improvement-analyst.md` | `./ai-resources/.claude/agents/improvement-analyst.md` | `.claude/agents/ai-resources/.claude/agents/improvement-analyst.md` | NO |
| `.claude/agents/innovation-triage-auditor.md` | `./ai-resources/.claude/agents/innovation-triage-auditor.md` | `.claude/agents/ai-resources/.claude/agents/innovation-triage-auditor.md` | NO |
| `.claude/agents/permission-sweep-auditor.md` | `./ai-resources/.claude/agents/permission-sweep-auditor.md` | `.claude/agents/ai-resources/.claude/agents/permission-sweep-auditor.md` | NO |
| `.claude/agents/qc-reviewer.md` | `./ai-resources/.claude/agents/qc-reviewer.md` | `.claude/agents/ai-resources/.claude/agents/qc-reviewer.md` | NO |
| `.claude/agents/refinement-reviewer.md` | `./ai-resources/.claude/agents/refinement-reviewer.md` | `.claude/agents/ai-resources/.claude/agents/refinement-reviewer.md` | NO |
| `.claude/agents/repo-dd-auditor.md` | `./ai-resources/.claude/agents/repo-dd-auditor.md` | `.claude/agents/ai-resources/.claude/agents/repo-dd-auditor.md` | NO |
| `.claude/agents/risk-check-reviewer.md` | `./ai-resources/.claude/agents/risk-check-reviewer.md` | `.claude/agents/ai-resources/.claude/agents/risk-check-reviewer.md` | NO |
| `.claude/agents/token-audit-auditor-mechanical.md` | `./ai-resources/.claude/agents/token-audit-auditor-mechanical.md` | `.claude/agents/ai-resources/.claude/agents/token-audit-auditor-mechanical.md` | NO |
| `.claude/agents/token-audit-auditor.md` | `./ai-resources/.claude/agents/token-audit-auditor.md` | `.claude/agents/ai-resources/.claude/agents/token-audit-auditor.md` | NO |
| `.claude/agents/triage-reviewer.md` | `./ai-resources/.claude/agents/triage-reviewer.md` | `.claude/agents/ai-resources/.claude/agents/triage-reviewer.md` | NO |
| `.claude/agents/workflow-analysis-agent.md` | `./ai-resources/.claude/agents/workflow-analysis-agent.md` | `.claude/agents/ai-resources/.claude/agents/workflow-analysis-agent.md` | NO |
| `.claude/agents/workflow-critique-agent.md` | `./ai-resources/.claude/agents/workflow-critique-agent.md` | `.claude/agents/ai-resources/.claude/agents/workflow-critique-agent.md` | NO |

**Command symlinks (41 — all broken, using same relative-path pattern). Paths:** `.claude/commands/analyze-workflow.md` through `.claude/commands/wrap-session.md` (41 files, all declaring relative targets of the form `./ai-resources/.claude/commands/<name>.md`, all resolving to broken paths).

Note: The `auto-sync-shared.sh` hook uses `ln -s "$src" "$target"` where `$src` is the absolute path discovered by walking up the directory tree — this would produce absolute-path symlinks. The current broken relative-path symlinks were not produced by the hook; they were created by a different mechanism before the first session start of this project.

Section summary: 60 items catalogued in commands + agents, 0 templates, 0 scripts, 0 skills / 0 deltas from previous audit (no previous audit)

---

## Section 2: CLAUDE.md Health

### 2.1 CLAUDE.md line count and sections

Line count: 99 lines. Distinct sections: 10.

Section headings:
1. (Title / introductory paragraph — no heading)
2. `## Persona`
3. `## Model Selection`
4. `## Grounding Paths`
5. `## Toolkit Relationship`
6. `## Out of Scope at v1`
7. `## Project Layout`
8. `## Input File Handling`
9. `## Commit Rules`
10. `## Compaction`
11. `## Session Boundaries`

(Title paragraph at line 1 acts as an unnumbered introduction; 10 numbered `##` sections follow.)

### 2.2 Dead references in CLAUDE.md

Checked every path and file reference in CLAUDE.md against the filesystem.

| Reference | Location in CLAUDE.md | Exists | Notes |
|---|---|---|---|
| `references/persona.md` | Line 12 | YES | `/projects/axcion-ai-system-owner/references/persona.md` |
| `references/systems-building-principles.md` | Lines 24, 61 | YES | Placeholder file; intentionally not-yet-active |
| `references/grounding.md` | Line 26 | YES | |
| `references/toolkit-relationship.md` | Line 30 | YES | |
| `projects/repo-documentation/output/phase-1/` | Lines 3, 22 | YES | Directory exists; all 5 named files present |
| `projects/repo-documentation/vault/` | Line 23 | YES | Directory exists (but declared not-yet-canonical) |
| `ai-resources/docs/agent-tier-table.md` | Line 16 | YES | |
| `.claude/settings.local.json` | Line 16 | NO | Absent on this machine; declared as gitignored, per-machine |
| `output/architecture-reviews/` | Lines 34, 64 | YES | Directory exists (empty) |
| `output/{project}/` | Line 75 | YES (interpreted as `output/`) | Path convention, not a literal directory name |
| `ai-resources/audits/repo-health-report-*.md` | Line 30 (example) | YES (pattern exists) | Referenced as example in Toolkit Relationship prose |

No dead references found — checked every named file path against the filesystem. `.claude/settings.local.json` is absent but CLAUDE.md explains this is expected (gitignored, per-machine).

None found — checked all named paths in CLAUDE.md against the filesystem.

### 2.3 Contradictions in CLAUDE.md

None found — checked each section against others for conflicting statements.

One apparent tension, not a contradiction: CLAUDE.md `## Model Selection` says the default model is `claude-sonnet-4-6[1m]` set via `settings.local.json`, while `settings.json` declares `"model": "sonnet"` (bare Sonnet). These are compatible: `settings.json` provides the base default; `settings.local.json` (absent) would override it to the 1M-context form when present per-machine.

### 2.4 Conventions defined in CLAUDE.md not followed by actual files

| Convention | Defined In | Violation |
|---|---|---|
| `logs/` should contain `decisions.md`, `friction-log.md`, `session-notes.md` | CLAUDE.md `## Project Layout` (line 65) | `logs/` contains only `.gitkeep`. None of the three log files exist. The pipeline directory contains a `decisions.md` but that is a different artifact (pipeline locked-decisions log, not the workspace-convention session log). |

### 2.5 Partially implemented features (referenced file exists but another referenced file is missing)

| Feature | What Exists | What is Missing |
|---|---|---|
| `settings.local.json` Sonnet 1M override | `settings.json` with bare `"model": "sonnet"` | `settings.local.json` not present on this machine. CLAUDE.md declares it gitignored and per-machine — absence is expected behavior, not a defect. |

No partial implementations found beyond the above expected absence.

### 2.6 Task-type-specific instructions in CLAUDE.md that belong elsewhere per the scoping rule

| Section | Approx. Line Count | Task Type | Scoping Assessment |
|---|---|---|---|
| `## Input File Handling` | ~14 lines | Workspace-canonical rule | CLAUDE.md explicitly acknowledges this mirrors the workspace CLAUDE.md and is repeated "because projects are sometimes opened without the parent workspace context loaded." This is verbatim duplication of a workspace canonical rule, flagged by the workspace scoping rule as not appropriate for project CLAUDE.md. |
| `## Commit Rules` | ~6 lines | Workspace-canonical rule | Same situation as above — explicitly noted as mirroring the workspace CLAUDE.md canonical `Commit behavior` section. Verbatim duplication. |

Section summary: 1 convention violation (missing log files), 2 sections containing verbatim workspace-canonical rule duplications / 0 deltas from previous audit

---

## Section 3: Dependency References

### 3.1 Files referenced by each slash command

**`/consult`:**

| Referenced File | Exists |
|---|---|
| `system-owner` agent (`.claude/agents/system-owner.md`) | YES (local file) |
| `ai-resources/docs/repo-architecture.md` (read only on change-shaped questions) | YES |
| `references/grounding.md` (read by agent inside its Phase 1 procedure) | YES |
| `references/persona.md` (read by agent) | YES |
| `references/toolkit-relationship.md` (read by agent) | YES |
| `references/systems-building-principles.md` (read by agent) | YES |
| `projects/repo-documentation/output/phase-1/principles.md` (read by agent) | YES |
| `projects/repo-documentation/output/phase-1/system-doc.md` (read by agent) | YES |
| `projects/repo-documentation/output/phase-1/risk-topology.md` (conditional) | YES |
| `projects/repo-documentation/output/phase-1/blueprint.md` (conditional) | YES |
| `projects/repo-documentation/output/phase-1/repo-state.md` (conditional) | YES |

**`/architecture-review`:**

| Referenced File | Exists |
|---|---|
| `system-owner` agent (`.claude/agents/system-owner.md`) | YES |
| `ai-resources/audits/` directory (glob for repo-health-*.md, token-audit-*.md, etc.) | YES (directory exists; no current audit outputs match the glob patterns for this scope) |
| Same agent-side references as `/consult` | YES (all) |

**`/implementation-triage`:**

| Referenced File | Exists |
|---|---|
| `system-owner` agent (`.claude/agents/system-owner.md`) | YES |
| Same agent-side references as `/consult` | YES (all) |

### 3.2 Command output chains

| Command | Output | Consumed By |
|---|---|---|
| `/consult` | Chat-only response | No downstream command at v1 |
| `/architecture-review` | Chat response (Executive Summary) + disk file at `output/architecture-reviews/architecture-review-{DATE}.md` | Disk output can be read by future `/architecture-review` or operator-directed reads; no automated downstream consumer at v1 |
| `/implementation-triage` | Chat-only response | No downstream command at v1 |

No automated command chains exist. All three commands are terminal (operator-invoked, no programmatic output routing).

### 3.3 Files referenced by more than one command / hook / script

| File | Referenced By |
|---|---|
| `system-owner` agent (`.claude/agents/system-owner.md`) | `/consult`, `/architecture-review`, `/implementation-triage` |
| `references/persona.md` | `system-owner` agent (read on every invocation); transitively by all 3 commands |
| `references/grounding.md` | `system-owner` agent (read on every invocation); transitively by all 3 commands |
| `references/toolkit-relationship.md` | `system-owner` agent (read on every invocation); transitively by all 3 commands |
| `references/systems-building-principles.md` | `system-owner` agent (read on every invocation, but treated as inactive); transitively by all 3 commands |
| `projects/repo-documentation/output/phase-1/principles.md` | `system-owner` agent for Functions A, B, C, D; transitively by all 3 commands |
| `projects/repo-documentation/output/phase-1/system-doc.md` | `system-owner` agent for Functions A, B, C; transitively by `/consult`, `/architecture-review`, conditionally by `/implementation-triage` |
| `projects/repo-documentation/output/phase-1/risk-topology.md` | `system-owner` agent for Functions B, C, D; conditionally by `/consult` (Function A) |
| `projects/repo-documentation/output/phase-1/blueprint.md` | `system-owner` agent conditionally for Functions A, B, D; always for Function C |
| `projects/repo-documentation/output/phase-1/repo-state.md` | `system-owner` agent conditionally for Functions A, B |
| `ai-resources/.claude/hooks/auto-sync-shared.sh` | SessionStart hook (hook 1) |
| `ai-resources/.claude/hooks/check-permission-sanity.sh` | SessionStart hook (hook 2) |

### 3.4 Files ranked by downstream reference count (top 10)

| Rank | File | Reference Count | Referenced By |
|---|---|---|---|
| 1 | `system-owner` agent | 3 direct | `/consult`, `/architecture-review`, `/implementation-triage` |
| 2 | `references/persona.md` | 3 (via agent) | All 3 commands via system-owner |
| 2 | `references/grounding.md` | 3 (via agent) | All 3 commands via system-owner |
| 2 | `references/toolkit-relationship.md` | 3 (via agent) | All 3 commands via system-owner |
| 2 | `references/systems-building-principles.md` | 3 (via agent) | All 3 commands via system-owner |
| 2 | `projects/repo-documentation/output/phase-1/principles.md` | 3 (via agent) | All 3 commands via system-owner |
| 7 | `projects/repo-documentation/output/phase-1/system-doc.md` | 2–3 (via agent) | `/consult` (A+B), `/architecture-review` (C), conditionally `/implementation-triage` (D) |
| 8 | `projects/repo-documentation/output/phase-1/risk-topology.md` | 2–3 (via agent) | `/consult` (conditional A), `/architecture-review` (C), `/implementation-triage` (D) |
| 9 | `projects/repo-documentation/output/phase-1/blueprint.md` | 1–3 (via agent) | Conditional for A, B, D; always for C |
| 10 | `ai-resources/docs/repo-architecture.md` | 1 | `/consult` (change-shaped path only) |

### 3.5 Symlinks in `.claude/commands/` or `.claude/agents/` with targets not covered by `permissions.additionalDirectories`

`permissions.additionalDirectories` contains one entry: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` (the workspace root).

All 60 symlinks (41 commands + 19 agents) declare relative targets of the form `./ai-resources/.claude/{agents,commands}/<name>.md`. These relative targets resolve to non-existent paths inside the project's own `.claude/` subtree (not to `ai-resources/`). The symlinks are broken and do not resolve to any path.

For coverage analysis: the intended targets (if the symlinks were correct absolute-path symlinks) would lie under `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/`, which IS covered by the `additionalDirectories` entry. Coverage: all 60 intended targets are covered. Accessibility: all 60 symlinks are currently broken and do not resolve.

### 3.6 Projects referencing ai-resources without adequate `additionalDirectories` coverage

The project references `ai-resources/` via:
- SessionStart hook 1 (auto-sync-shared.sh, which walks up to find ai-resources)
- SessionStart hook 2 (check-permission-sanity.sh, same pattern)
- All 60 symlinks (intended targets in ai-resources; currently broken)
- Three local command bodies (read `ai-resources/docs/repo-architecture.md`, `ai-resources/audits/`)

`permissions.additionalDirectories` entry `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` is an ancestor of `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/`. Coverage is present.

None found — checked `additionalDirectories` against all ai-resources reference paths.

Section summary: 0 missing file references (all external paths resolve), 1 dependency note (60 symlinks broken, coverage analysis above) / 0 deltas from previous audit

---

## Section 4: Consistency Checks

### 4.1 Skills structural pattern compliance

No skills in AUDIT_ROOT. N/A — no items to compare.

### 4.2 Slash command definition pattern consistency

**Project-local commands** (3 files — the only locally readable command definitions):

| Command | Has YAML Frontmatter | `description` field | `model` field | Body format |
|---|---|---|---|---|
| `/consult` | YES | YES | `opus` | Step-numbered prose with code blocks |
| `/architecture-review` | YES | YES | `opus` | Step-numbered prose with code blocks and table |
| `/implementation-triage` | YES | YES | `opus` | Step-numbered prose with code blocks |

All 3 local commands follow the same pattern: YAML frontmatter with `description` and `model`, step-numbered body with inline code blocks for output examples or templates, and a "Notes for the executor" section at the end.

The 41 symlinked commands are broken (not readable); their pattern cannot be verified from AUDIT_ROOT.

### 4.3 Skill template comparison

N/A — No skill creation template file exists. Skills are created via /create-skill which references ai-resource-builder/SKILL.md for format standards.

### 4.4 Naming convention inconsistencies

None found — checked all file names in AUDIT_ROOT.

- Commands: kebab-case `.md` files (consult.md, architecture-review.md, implementation-triage.md). Consistent.
- Agents: kebab-case `.md` files (system-owner.md, plus 19 symlinks following ai-resources naming). Consistent.
- References: kebab-case `.md` files. Consistent.
- Pipeline artifacts: kebab-case `.md` files. Consistent.

### 4.5 Directory structure violations

CLAUDE.md `## Project Layout` declares the following structure. Checking actual state:

| Declared Path | Declared Content | Actual State |
|---|---|---|
| `.claude/settings.json` | Layer D canonical shape | EXISTS — content matches |
| `.claude/settings.local.json` | Gitignored, per-machine | ABSENT — expected (gitignored) |
| `.claude/shared-manifest.json` | Declares 1 local agent + 3 local commands | EXISTS — matches (lists 3 commands + 1 agent) |
| `.claude/commands/consult.md` | Function A + B | EXISTS |
| `.claude/commands/architecture-review.md` | Function C | EXISTS |
| `.claude/commands/implementation-triage.md` | Function D | EXISTS |
| `.claude/commands/{symlinks}` | Symlinks from ai-resources via auto-sync | EXISTS — 41 symlinks present, all broken |
| `.claude/agents/system-owner.md` | Judgment agent, project-local, Opus | EXISTS |
| `.claude/agents/{symlinks}` | Symlinks from ai-resources via auto-sync | EXISTS — 19 symlinks present, all broken |
| `references/persona.md` | Full persona definition | EXISTS |
| `references/grounding.md` | Per-function read map | EXISTS |
| `references/toolkit-relationship.md` | Integration mechanisms | EXISTS |
| `references/systems-building-principles.md` | Placeholder | EXISTS |
| `pipeline/` | Stage 3a–3c artifacts | EXISTS — contains 10 files including stages beyond 3c |
| `output/architecture-reviews/` | Review output directory | EXISTS (empty — no reviews generated yet) |
| `logs/` | decisions.md, friction-log.md, session-notes.md | EXISTS as directory — contains only `.gitkeep`; all 3 named files absent |

**Violations:**
1. `logs/decisions.md` — absent. CLAUDE.md layout declares it as a workspace convention.
2. `logs/friction-log.md` — absent. CLAUDE.md layout declares it as a workspace convention.
3. `logs/session-notes.md` — absent. CLAUDE.md layout declares it as a workspace convention.

Note: The pipeline directory contains a `decisions.md` at `pipeline/decisions.md` but this is the pipeline-specific locked-decisions log, not the workspace-convention session log.

### 4.6 Slash command syntax and path resolution checks

**Project-local commands (all 3 verified):**

| Command | YAML Frontmatter Valid | All Referenced Paths Resolve |
|---|---|---|
| `/consult` | YES | YES — `ai-resources/docs/repo-architecture.md` exists; `system-owner` agent exists |
| `/architecture-review` | YES | YES — `ai-resources/audits/` exists; `system-owner` agent exists |
| `/implementation-triage` | YES | YES — `system-owner` agent exists |

**Symlinked commands (41):** All broken — cannot read content from AUDIT_ROOT; path resolution cannot be verified.

### 4.7 Duplicate or built-in command name conflicts

**Duplicates:** None found — each of the 3 local commands has a unique name not present in any other local command or in the ai-resources command set. `/consult`, `/architecture-review`, and `/implementation-triage` do not appear in `ai-resources/.claude/commands/`.

**Built-in conflicts:** None found — checked against known Claude Code built-in slash commands (`/clear`, `/compact`, `/model`, `/cost`, `/help`, `/status`). None of the 3 project-local commands conflict.

### 4.8 Agent tier compliance

**Scope:** Agents readable from AUDIT_ROOT. Only `system-owner.md` is readable (project-local file). All 19 symlinked agents are broken and their content cannot be verified from AUDIT_ROOT.

**`system-owner.md`:** Declares `model: opus`. This agent is project-local to `projects/axcion-ai-system-owner/`. The agent tier table in `ai-resources/docs/agent-tier-table.md` covers only `ai-resources/.claude/agents/` — `system-owner` is not listed there. Per CLAUDE.md `## Model Tier` → "Agents": "Every agent must declare `model:` explicitly — no implicit inherit. Tier by work type: Opus for judgment work." The agent performs judgment work (architectural consultation, synthesis, triage). Declared tier (opus) matches expected tier for this work type. The agent is missing from the tier table — the tier table's scope is `ai-resources/.claude/agents/`; whether project-local agents must be listed in that table is not explicitly defined in the tier table or CLAUDE.md.

| Agent | File | Declared Model | Expected Tier (by work type) | Table Entry | Assessment |
|---|---|---|---|---|---|
| system-owner | `.claude/agents/system-owner.md` | opus | opus (judgment work) | Not listed (project-local) | Tier correct; not in ai-resources table |

### 4.9 Project settings.json vs. canonical baseline

**Canonical baseline source:** `ai-resources/.claude/commands/new-project.md` `CANONICAL_PERMS` block.

| Check | Expected | Actual | Pass/Fail |
|---|---|---|---|
| `permissions.deny` contains `Read(archive/**)` | YES | YES | PASS |
| `permissions.deny` contains `Read(**/*.archive.*)` | YES | YES | PASS |
| `permissions.deny` contains `Read(**/deprecated/**)` | YES | YES | PASS |
| `permissions.deny` contains `Read(**/old/**)` | YES | YES | PASS |
| `permissions.deny` contains `Bash(git push*)` | YES | YES | PASS |
| `permissions.deny` contains `Bash(rm -rf *)` | YES | YES | PASS |
| `permissions.deny` contains `Bash(sudo *)` | YES | YES | PASS |
| Top-level `"model": "sonnet"` | YES | YES | PASS |

**Commit dates:** The entire project is untracked in git (0 tracked files — all 83 files are in `git ls-files --others`). No commit date for `.claude/settings.json` is available. `new-project.md` also has no git-recorded commits in the repository log (0 entries from `git log -- ai-resources/.claude/commands/new-project.md`). The `CANONICAL_PERMS` block comparison date cannot be established from git history.

Section summary: 3 directory structure violations (missing log files), 60 symlinks unverifiable (all broken), 1 tier table gap (system-owner not listed), settings.json fully matches canonical / 0 deltas from previous audit

---

## Section 5: Context Load

### 5.1 Estimated context at session start

| File | Lines | Approximate Tokens |
|---|---|---|
| Workspace CLAUDE.md (`/CLAUDE.md`) | 219 | ~5,000 |
| Project CLAUDE.md (`projects/axcion-ai-system-owner/CLAUDE.md`) | 99 | ~2,300 |
| **Total auto-loaded** | **318** | **~7,300** |

No other files are auto-loaded at session start. The agent reference files (`references/persona.md`, `references/grounding.md`, etc.) and Phase 1 grounding docs are read at command invocation time by the `system-owner` agent, not at session start.

### 5.2 CLAUDE.md sections not referenced by any command, hook, or operational instruction

All 10 sections in the project CLAUDE.md are operationally referenced:

- `## Persona` — defines the persona character that all 3 commands deliver via the system-owner agent
- `## Model Selection` — declares model defaults operative for settings.json and command frontmatter
- `## Grounding Paths` — declares the Phase 1 read path operative for system-owner agent
- `## Toolkit Relationship` — documents the integration mechanism decision operative for all 3 commands
- `## Out of Scope at v1` — constrains system-owner agent tool scope and question types
- `## Project Layout` — declares the directory structure the project uses
- `## Input File Handling` — applies to any session turn involving input files
- `## Commit Rules` — applies to any commit operation
- `## Compaction` — applies when `/compact` fires
- `## Session Boundaries` — applies when switching tasks

No sections are unreferenced dead weight — checked all 10 sections against command bodies, hook logic, and session operational rules.

### 5.3 CLAUDE.md line count at last 5 commits modifying it

The project directory (`projects/axcion-ai-system-owner/`) is entirely untracked in git (confirmed via `git ls-files` returning 0 tracked files and `git ls-files --others` returning all 83 project files). No git history exists for `CLAUDE.md` in this project. Line count history cannot be determined.

Current state: 99 lines (as of audit date 2026-05-04).

Section summary: 0 issues flagged (context load is minimal at 318 lines; all sections referenced; no git history available for drift tracking) / 0 deltas from previous audit

---

## Section 6: Drift and Staleness

### 6.1 Files not modified in last 90 days but referenced by active commands

The project is entirely untracked in git — no commit dates exist for any file under AUDIT_ROOT. File modification dates from the filesystem show all files were created on 2026-05-02 (the project was scaffolded on that date). No file is older than 90 days.

The Phase 1 grounding docs referenced by the system-owner agent (`projects/repo-documentation/output/phase-1/`) are outside AUDIT_ROOT and are not assessed here per scope rules.

None found within AUDIT_ROOT — checked all file creation dates (all 2026-05-02).

### 6.2 TODO, FIXME, PLACEHOLDER, or similar marker comments

| File | Line | Marker | Text |
|---|---|---|---|
| `pipeline/pipeline-state.md` | 4 | TBD | `- **GitHub:** TBD` |
| `references/systems-building-principles.md` | 2 | TBD | `status: TBD — operator-provided` (frontmatter field) |
| `references/systems-building-principles.md` | 6 | placeholder | File heading: `# Systems-Building Principles (placeholder)` |

The `references/systems-building-principles.md` placeholder is intentional by design — CLAUDE.md and the pipeline artifacts document this as expected v1 state. The agent reads the status field and skips the file content while status is TBD.

The `pipeline/pipeline-state.md` `GitHub: TBD` entry indicates no GitHub repository URL has been assigned to the project.

Additional TBD and PLACEHOLDER markers exist in pipeline files (`pipeline/architecture.md`, `pipeline/context-pack.md`, `pipeline/implementation-spec.md`, `pipeline/implementation-log.md`, `pipeline/project-plan.md`) — these are historical references to the systems-building-principles slot during project design and are pipeline audit trail artifacts, not active operational markers.

### 6.3 Empty files, stub files, or files containing only boilerplate

| File | State | Contents |
|---|---|---|
| `logs/.gitkeep` | Empty (0 bytes) | Git placeholder for empty directory |
| `output/.gitkeep` | Empty (0 bytes) | Git placeholder for empty directory |
| `references/systems-building-principles.md` | Stub (17 lines) | Intentional placeholder; frontmatter declares `status: TBD — operator-provided`; body is activation instructions only |

Section summary: 2 active TBD markers (pipeline-state.md GitHub URL, systems-building-principles.md status), 2 empty .gitkeep files, 1 intentional stub (systems-building-principles.md) / 0 deltas from previous audit

---

## Summary of Findings

### Discrepancies (actual state differs from declared/expected state)

| # | Finding | Location | Details |
|---|---|---|---|
| D1 | All 60 symlinks are broken | `.claude/agents/` (19), `.claude/commands/` (41) | Symlinks use relative paths (`./ai-resources/...`) evaluated from within the `.claude/{agents,commands}/` subdirectory, resolving to non-existent paths. The `auto-sync-shared.sh` hook creates absolute-path symlinks; current symlinks were not created by the hook. `cat` on any symlinked file returns "No such file or directory." |
| D2 | CLAUDE.md layout declares `logs/` contains 3 files; none exist | `logs/` directory | `decisions.md`, `friction-log.md`, `session-notes.md` are all absent. Only `.gitkeep` is present. |
| D3 | Entire project is untracked in git | All 83 files | `git ls-files` returns 0 tracked files. `git ls-files --others` returns all 83 project files. The workspace `logs/session-notes.md` from HEAD commit (2026-05-02) references this project by name but the project directory itself has never been committed. |

### Missing Items

| # | Finding | Location | Details |
|---|---|---|---|
| M1 | `logs/decisions.md` absent | `logs/` | Declared in CLAUDE.md Project Layout as a workspace convention file. |
| M2 | `logs/friction-log.md` absent | `logs/` | Declared in CLAUDE.md Project Layout as a workspace convention file. |
| M3 | `logs/session-notes.md` absent | `logs/` | Declared in CLAUDE.md Project Layout as a workspace convention file. |
| M4 | `settings.local.json` absent | `.claude/` | Expected (gitignored, per-machine); not a defect. Sonnet 1M model override is not active on this machine. |
| M5 | `pipeline-state.md` GitHub URL not set | `pipeline/pipeline-state.md` line 4 | `GitHub: TBD` — no repository URL assigned. |

### Violations

| # | Finding | Location | Rule Violated | Details |
|---|---|---|---|---|
| V1 | Two CLAUDE.md sections duplicate workspace canonical rules verbatim | CLAUDE.md `## Input File Handling` (~14 lines), `## Commit Rules` (~6 lines) | Workspace CLAUDE.md "CLAUDE.md Scoping" rule: "Do not put in project CLAUDE.md: Canonical workspace rules. Short pointer is acceptable; verbatim duplication is not." | Both sections explicitly note they mirror workspace-level CLAUDE.md content; the rationale given is standalone-session use. The violation is acknowledged in-file. |
| V2 | `toolkit-relationship.md` lists only 10 of 41 workspace commands | `references/toolkit-relationship.md` § 2 | `toolkit-relationship.md` § 5 Maintenance Rule: "Whenever a new workspace command ships, this file is reviewed for the new command's integration mechanism." | 31 commands present in ai-resources (and symlinked into this project) have no disposition entry. Listed commands: `/route-change`, `/audit-repo`, `/token-audit`, `/analyze-workflow`, `/risk-check`, `/repo-dd`, `/innovation-sweep`, `/permission-sweep`, `/improve`, `/friday-checkup`, `/friday-act`. Unlisted: audit-claude-md, audit-critical-resources, clarify, cleanup-worktree, coach, create-skill, friction-log, graduate-resource, improve-skill, migrate-skill, note, prime, project-consultant, qc-pass, recommend, refinement-deep, refinement-pass, request-skill, resolve-improvement-log, resolve, save-session, scope, session-guide, session-plan, summary, sync-workflow, triage, update-claude-md, usage-analysis, wrap-session (31 commands). |
| V3 | `system-owner` agent not listed in agent tier table | `ai-resources/docs/agent-tier-table.md` | Workspace CLAUDE.md "Model Tier" → "Agents": "Every agent must declare `model:` explicitly." The table header covers `ai-resources/.claude/agents/`; whether project-local agents must be listed is not explicitly stated. The agent does declare `model: opus` explicitly; the tier is correct for the work type. | The tier table's stated scope covers ai-resources agents only. Project-local agents have no designated registry. Ambiguity in the rule as written — does not clearly require project-local agents to be listed. |

### Clean Checks

| # | Check | Result |
|---|---|---|
| C1 | All 3 project-local command frontmatter valid (YAML, description, model) | Clean |
| C2 | All 3 project-local commands declare `model: opus` | Clean |
| C3 | `system-owner` agent declares `model: opus` (correct for judgment work) | Clean |
| C4 | `settings.json` deny list matches all 7 canonical entries from `new-project.md` CANONICAL_PERMS | Clean |
| C5 | `settings.json` allow list matches canonical allow list | Clean |
| C6 | `settings.json` top-level `"model": "sonnet"` present | Clean |
| C7 | `settings.json` `additionalDirectories` includes workspace root | Clean |
| C8 | `settings.json` SessionStart hooks both reference existing and executable scripts | Clean |
| C9 | All 5 Phase 1 grounding docs exist at `projects/repo-documentation/output/phase-1/` | Clean |
| C10 | `ai-resources/docs/repo-architecture.md` exists (referenced by `/consult` change-shape path) | Clean |
| C11 | `ai-resources/audits/` directory exists (referenced by `/architecture-review`) | Clean |
| C12 | No command name duplicates within project; no conflicts with known Claude Code built-ins | Clean |
| C13 | `shared-manifest.json` correctly lists 3 local commands and 1 local agent | Clean |
| C14 | All 3 local commands follow consistent definition pattern (frontmatter + steps + notes section) | Clean |
| C15 | `references/systems-building-principles.md` intentional placeholder status is correctly flagged | Clean |
| C16 | No CLAUDE.md dead references (all named paths exist on disk or are expected-absent) | Clean |
| C17 | `additionalDirectories` covers the intended symlink targets (ai-resources is under workspace root) | Clean |
| C18 | `output/architecture-reviews/` directory exists as declared | Clean |
| C19 | No naming convention inconsistencies across files | Clean |
| C20 | Pipeline stage completion matches pipeline-state.md: stages 3a–5 completed, stage 6 skipped | Clean |
