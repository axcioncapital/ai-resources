# Repo Due Diligence Audit — 2026-06-03
Repo: projects/marketing-positioning
Scope: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/marketing-positioning
Commit: 3d30ede
Previous audit: None
Depth: standard

---

## Section 1: Inventory

### 1.1 Slash commands

All 67 slash commands in `.claude/commands/` are symlinks to `ai-resources/.claude/commands/`. No project-local commands exist. Confirmed by `shared-manifest.json` (`"commands": { "local": [] }`).

| Name | Defined at | Referenced files |
|------|------------|-----------------|
| analyze-workflow | symlink → ai-resources/.claude/commands/analyze-workflow.md | (external — not audited in this scope) |
| architecture-review | symlink → ai-resources/.claude/commands/architecture-review.md | (external) |
| archive-project | symlink → ai-resources/.claude/commands/archive-project.md | (external) |
| audit-claude-md | symlink → ai-resources/.claude/commands/audit-claude-md.md | (external) |
| audit-repo | symlink → ai-resources/.claude/commands/audit-repo.md | (external) |
| build-context | symlink → ai-resources/.claude/commands/build-context.md | (external) |
| clarify | symlink → ai-resources/.claude/commands/clarify.md | (external) |
| cleanup-worktree | symlink → ai-resources/.claude/commands/cleanup-worktree.md | (external) |
| coach | symlink → ai-resources/.claude/commands/coach.md | (external) |
| consult | symlink → ai-resources/.claude/commands/consult.md | (external) |
| contract-check | symlink → ai-resources/.claude/commands/contract-check.md | (external) |
| create-skill | symlink → ai-resources/.claude/commands/create-skill.md | (external) |
| decide | symlink → ai-resources/.claude/commands/decide.md | (external) |
| deploy-kb | symlink → ai-resources/.claude/commands/deploy-kb.md | (external) |
| drift-check | symlink → ai-resources/.claude/commands/drift-check.md | (external) |
| explain | symlink → ai-resources/.claude/commands/explain.md | (external) |
| fix-repo-issues | symlink → ai-resources/.claude/commands/fix-repo-issues.md | (external) |
| fix-symlinks | symlink → ai-resources/.claude/commands/fix-symlinks.md | (external) |
| friction-log | symlink → ai-resources/.claude/commands/friction-log.md | (external) |
| friday-act | symlink → ai-resources/.claude/commands/friday-act.md | (external) |
| friday-checkup | symlink → ai-resources/.claude/commands/friday-checkup.md | (external) |
| friday-journal | symlink → ai-resources/.claude/commands/friday-journal.md | (external) |
| friday-so | symlink → ai-resources/.claude/commands/friday-so.md | (external) |
| graduate-resource | symlink → ai-resources/.claude/commands/graduate-resource.md | (external) |
| grill-me | symlink → ai-resources/.claude/commands/grill-me.md | (external) |
| handoff | symlink → ai-resources/.claude/commands/handoff.md | (external) |
| implementation-triage | symlink → ai-resources/.claude/commands/implementation-triage.md | (external) |
| improve-skill | symlink → ai-resources/.claude/commands/improve-skill.md | (external) |
| improve | symlink → ai-resources/.claude/commands/improve.md | (external) |
| innovation-sweep | symlink → ai-resources/.claude/commands/innovation-sweep.md | (external) |
| list-critical-resources | symlink → ai-resources/.claude/commands/list-critical-resources.md | (external) |
| log-sweep | symlink → ai-resources/.claude/commands/log-sweep.md | (external) |
| migrate-skill | symlink → ai-resources/.claude/commands/migrate-skill.md | (external) |
| monday-prep | symlink → ai-resources/.claude/commands/monday-prep.md | (external) |
| note | symlink → ai-resources/.claude/commands/note.md | (external) |
| open-items | symlink → ai-resources/.claude/commands/open-items.md | (external) |
| permission-sweep | symlink → ai-resources/.claude/commands/permission-sweep.md | (external) |
| placement | symlink → ai-resources/.claude/commands/placement.md | (external) |
| pm | symlink → ai-resources/.claude/commands/pm.md | (external) |
| prime | symlink → ai-resources/.claude/commands/prime.md | (external) |
| project-consultant | symlink → ai-resources/.claude/commands/project-consultant.md | (external) |
| qc-pass | symlink → ai-resources/.claude/commands/qc-pass.md | (external) |
| recommend | symlink → ai-resources/.claude/commands/recommend.md | (external) |
| refinement-deep | symlink → ai-resources/.claude/commands/refinement-deep.md | (external) |
| refinement-pass | symlink → ai-resources/.claude/commands/refinement-pass.md | (external) |
| repo-dd | symlink → ai-resources/.claude/commands/repo-dd.md | (external) |
| request-skill | symlink → ai-resources/.claude/commands/request-skill.md | (external) |
| resolve-improvement-log | symlink → ai-resources/.claude/commands/resolve-improvement-log.md | (external) |
| resolve-incident | symlink → ai-resources/.claude/commands/resolve-incident.md | (external) |
| resolve-repo-problem | symlink → ai-resources/.claude/commands/resolve-repo-problem.md | (external) |
| resolve | symlink → ai-resources/.claude/commands/resolve.md | (external) |
| risk-check | symlink → ai-resources/.claude/commands/risk-check.md | (external) |
| save-session | symlink → ai-resources/.claude/commands/save-session.md | (external) |
| scope | symlink → ai-resources/.claude/commands/scope.md | (external) |
| session-guide | symlink → ai-resources/.claude/commands/session-guide.md | (external) |
| session-plan | symlink → ai-resources/.claude/commands/session-plan.md | (external) |
| session-start | symlink → ai-resources/.claude/commands/session-start.md | (external) |
| so-monthly | symlink → ai-resources/.claude/commands/so-monthly.md | (external) |
| summary | symlink → ai-resources/.claude/commands/summary.md | (external) |
| sync-workflow | symlink → ai-resources/.claude/commands/sync-workflow.md | (external) |
| systems-review | symlink → ai-resources/.claude/commands/systems-review.md | (external) |
| token-audit | symlink → ai-resources/.claude/commands/token-audit.md | (external) |
| triage | symlink → ai-resources/.claude/commands/triage.md | (external) |
| tweak | symlink → ai-resources/.claude/commands/tweak.md | (external) |
| update-claude-md | symlink → ai-resources/.claude/commands/update-claude-md.md | (external) |
| usage-analysis | symlink → ai-resources/.claude/commands/usage-analysis.md | (external) |
| wrap-session | symlink → ai-resources/.claude/commands/wrap-session.md | (external) |

Total: 67 commands, all symlinks to external ai-resources targets.

### 1.2 Hooks

Two SessionStart hooks are configured in `.claude/settings.json`. No other hooks are configured in this project's settings file. No `.claude/settings.local.json` exists.

| Trigger | What it does | Files referenced |
|---------|-------------|-----------------|
| SessionStart (hook 1) | Traverses parent directories to find and run `ai-resources/.claude/hooks/auto-sync-shared.sh`. Timeout: 10s. Status message: "Syncing shared commands from ai-resources..." | `ai-resources/.claude/hooks/auto-sync-shared.sh` (external, resolved at runtime) |
| SessionStart (hook 2) | Traverses parent directories to find and run `ai-resources/.claude/hooks/check-permission-sanity.sh`. Timeout: 5s. Status message: "Permission sanity check..." | `ai-resources/.claude/hooks/check-permission-sanity.sh` (external, resolved at runtime) |

### 1.3 Template files

None found — checked all 21 non-.git files in AUDIT_ROOT. No files with template characteristics (e.g., `{{placeholder}}` syntax, `.template` extension, or files in a `templates/` directory) exist within the audit scope.

### 1.4 Scripts (bash, python, or other)

None found — checked all 21 non-.git files in AUDIT_ROOT. No bash, python, or other scripts exist within the project subtree.

### 1.5 Skills

0 skills in this repo. No `skills/` directory exists. No `SKILL.md` files exist anywhere in AUDIT_ROOT. This is by design: the project is a lean content vessel; all skills are consumed from `ai-resources/skills/` via the shared command set (confirmed in `pipeline/architecture.md` §"Components explicitly NOT created").

### 1.6 Uncategorized items

The following files do not fall into skills, templates, scripts, slash commands (they are symlinks counted separately), hooks, CLAUDE.md, audits, or standard git files:

| Path | Category |
|------|----------|
| `.claude/settings.json` | Settings file |
| `.claude/shared-manifest.json` | Manifest file (lists project-local commands/agents; both are empty in this project) |
| `.gitignore` | Standard git file (intentionally listed — content audited below) |
| `_consultants/embedded-consultant.md` | Project-local persona stub (reference file) |
| `logs/decisions.md` | Decision log (seed, 6 rows, execution-append target) |
| `logs/session-notes.md` | Session notes log (seed, 3 lines) |
| `output/.gitkeep` | Placeholder for empty tracked directory |
| `pipeline/architecture.md` | Pipeline artifact (Stage 3b output, frozen) |
| `pipeline/context-pack.md` | Pipeline artifact (Stage 0, frozen) |
| `pipeline/decisions.md` | Pipeline artifact (pipeline-level decisions, frozen) |
| `pipeline/implementation-log.md` | Pipeline artifact (Stage 4 log, frozen) |
| `pipeline/implementation-spec.md` | Pipeline artifact (Stage 3c output, frozen) |
| `pipeline/pipeline-state.md` | Pipeline artifact (stage-status tracker) |
| `pipeline/project-plan.md` | Pipeline artifact (Stage 2 output, frozen) |
| `pipeline/repo-snapshot.md` | Pipeline artifact (Stage 3a output, frozen) |
| `pipeline/session-guide.md` | Pipeline artifact (Stage 6 output) |
| `pipeline/sources.md` | Pipeline artifact (input-source provenance log) |
| `pipeline/test-results.md` | Pipeline artifact (Stage 5 output, frozen) |
| `reference/method-notes.md` | Capped byproduct seed (17 lines, near-empty) |
| `reference/source-map.md` | Read-only source pointer (thin pointer, 39 lines) |

### 1.7 Symlinks

All 93 symlinks in AUDIT_ROOT are in `.claude/commands/` (67) and `.claude/agents/` (26). All symlinks use relative paths of the form `../../../../ai-resources/.claude/{commands|agents}/{name}.md`.

Resolved absolute targets all fall under `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/`. Checked via `readlink -f` on representative samples (`qc-pass.md` → `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/qc-pass.md`; `qc-reviewer.md` → `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/qc-reviewer.md`).

Accessibility: 0 broken symlinks found — verified by `find` with `-type l` followed by existence check (`[ ! -e "$f" ]`) across all 93 symlinks.

Section summary: 21 files catalogued, 93 symlinks catalogued, 0 deltas from previous audit (no previous audit).

---

## Section 2: CLAUDE.md Health

### 2.1 Line count and section headings

CLAUDE.md: **161 lines**, **17 distinct sections** (`##`-level headings).

Section headings in order:
1. `## What This Project Is`
2. `## Organizing Framework — the verbal system, built in dependency order`
3. `## Channel-Copy Ownership Boundary`
4. `## AI-as-Substrate Rule`
5. `## Voice-Authoring Discipline`
6. `## Embedded Consultant`
7. `## Reference-Input Map (read-only sources)`
8. `## Method-Notes Byproduct (capped)`
9. `## Autonomy Posture & Decision Gates`
10. `## Checkpoints`
11. `## Cross-Project Deferred Writes`
12. `## Model Selection`
13. `## Directory Layout`
14. `## Input File Handling`
15. `## Commit Rules`
16. `## Compaction`
17. `## Session Boundaries`

The title line `# Axcíon Marketing & Positioning Project` is the H1; the 17 listed above are all H2 sections.

### 2.2 Dead references in CLAUDE.md

Checked every file, path, command, and feature reference in CLAUDE.md against AUDIT_ROOT and the workspace.

| Reference | Exists? | Notes |
|-----------|---------|-------|
| `_consultants/embedded-consultant.md` | Yes | Found at exact path |
| `reference/source-map.md` | Yes | Found at exact path |
| `reference/method-notes.md` | Yes | Found at exact path |
| `logs/decisions.md` | Yes | Found at exact path |
| `logs/session-notes.md` | Yes | Found at exact path |
| `projects/corporate-identity/logs/decisions.md` | Yes | Found in workspace (deferred write target, not within AUDIT_ROOT) |
| `projects/corporate-identity/artifacts/positioning.md` | Yes | Found in workspace (deferred write target, not within AUDIT_ROOT) |
| `corporate-identity/tone-of-voice.md` | Does not exist | Referenced as the slot this project supersedes. CLAUDE.md explicitly states it is "non-existent" — this is by design and accurate. |
| `/qc-pass` command | Yes | Symlink present in `.claude/commands/qc-pass.md` |
| `pipeline/decisions.md` | Yes | Found at exact path |
| `output/` directory | Yes | Directory exists (contains `.gitkeep`) |

None found that represent genuine dead references — the `tone-of-voice.md` reference is intentionally noting a non-existent file as the superseded slot.

### 2.3 Contradictions in CLAUDE.md

None found — checked all 17 sections for conflicting instructions.

Two potential surface-level tensions exist but are not contradictions:

1. `## Organizing Framework` states Part 2 Discovery "may begin alongside Part 1" while `## Checkpoints` states Checkpoint A (after Part 1) gates entry to Part 3, and Part 2 must be "complete before Part 3." These are consistent: Parts 1 and 2 may run in parallel; both must complete before Part 3 begins.

2. `## Autonomy Posture & Decision Gates` states the project "skews tier B" while listing five tier-C gates. These are consistent: the default is tier B, with named tier-C exceptions.

### 2.4 CLAUDE.md conventions not followed by actual files

The spec (pipeline/implementation-spec.md Operation 2) required an enrichment marker comment `<!-- ENRICHMENT: canonical sections ... -->` at the end of the project-specific sections, to be removed after the four canonical sections were inserted. The marker is no longer present in CLAUDE.md (confirmed by grep), and the four canonical sections (Input File Handling, Commit Rules, Compaction, Session Boundaries) are present at lines 127–161. This indicates the enrichment step ran and removed the marker after insertion. The absence of the marker is therefore the expected post-enrichment state.

No other convention violations found.

### 2.5 Partially-implemented features

None found — checked each referenced file against what the corresponding sections in CLAUDE.md describe:

- Embedded Consultant section references `_consultants/embedded-consultant.md` → exists (stub, correct by design at pre-execution stage).
- Reference-Input Map section references `reference/source-map.md` → exists.
- Method-Notes Byproduct section references `reference/method-notes.md` → exists.
- Directory Layout lists `output/`, `reference/`, `_consultants/`, `logs/`, `pipeline/` → all directories exist.
- Cross-Project Deferred Writes names two external write targets → both external files confirmed to exist in the workspace; neither has been written to (correct — they are deferred to execution).
- Both SessionStart hooks reference scripts under `ai-resources/.claude/hooks/` → `auto-sync-shared.sh` and `check-permission-sanity.sh` confirmed present in workspace (external to AUDIT_ROOT; verified accessible).

### 2.6 Task-type-specific instructions that belong in SKILL.md or workflow docs

The workspace CLAUDE.md "CLAUDE.md Scoping" rule states that skill methodology, workflow-stage instructions, evaluation frameworks, and file-format conventions for a single artifact type belong in SKILL.md or workflow reference docs, not in CLAUDE.md.

Applying this check to the project CLAUDE.md:

| Section | Approximate line count | Task-type addressed | Assessment |
|---------|----------------------|--------------------|-|
| `## Voice-Authoring Discipline` | ~12 lines | Voice synthesis methodology (§4.5 floor rule, flag-gaps-never-invent, escalation trigger) | This is project-specific authoring governance that applies every turn in this project — not a reusable skill methodology. It is not a skill (no procedural recipe), not a workflow stage (no multi-step sequence). Consistent with CLAUDE.md Scoping rule. |
| `## Organizing Framework` | ~18 lines | Production sequencing (B-L1 → A → B-L2) and method anchors | This is the project's structural dependency order — cross-session behavioral rule. Not skill methodology. Consistent with CLAUDE.md Scoping rule. |
| `## Checkpoints` | ~10 lines | Checkpoint gating conditions | Project-specific decision gates, not a skill. Consistent. |
| `## Autonomy Posture & Decision Gates` | ~12 lines | Tier-B/C gate enumeration | Project-specific autonomy configuration. Consistent. |

None found that fall into the prohibited category under the CLAUDE.md Scoping rule. The sections contain project-specific governance rules, not reusable skill or workflow methodology.

Section summary: 0 issues flagged / 0 deltas from previous audit.

---

## Section 3: Dependency References

### 3.1 Files referenced by each slash command

All 67 commands are symlinks to external ai-resources files. The targets and their contents are outside AUDIT_ROOT scope. Within AUDIT_ROOT, no command file has local file references.

None found within AUDIT_ROOT — checked by confirming all command files are symlinks to external targets; no project-local command definitions exist.

### 3.2 Slash command output chains

None found within AUDIT_ROOT — no project-local commands exist that produce output consumed by other commands. The two hooks call external scripts; neither produces output that feeds another hook or command.

### 3.3 Files referenced by more than one slash command, hook, or script

Within AUDIT_ROOT:

The two SessionStart hooks both walk the parent directory chain looking for scripts under `ai-resources/.claude/hooks/`. They reference different scripts (`auto-sync-shared.sh` vs `check-permission-sanity.sh`) and share only the traversal pattern — no single file is referenced by multiple hooks.

None found within AUDIT_ROOT — checked by examining both hooks in settings.json and confirming they reference distinct external scripts.

### 3.4 Files ranked by downstream references (top 10)

Within AUDIT_ROOT only:

| Rank | Item | Reference count | Referenced by |
|------|------|----------------|---------------|
| 1 | `_consultants/embedded-consultant.md` | 3 | CLAUDE.md (§Embedded Consultant, §Directory Layout), pipeline/session-guide.md (7 session descriptions) |
| 2 | `reference/source-map.md` | 2 | CLAUDE.md (§Reference-Input Map, §Directory Layout) |
| 3 | `reference/method-notes.md` | 2 | CLAUDE.md (§Method-Notes Byproduct, §Directory Layout) |
| 4 | `logs/decisions.md` | 2 | CLAUDE.md (§Cross-Project Deferred Writes target, §Directory Layout) |
| 5 | `logs/session-notes.md` | 2 | CLAUDE.md (§Directory Layout), pipeline/session-guide.md (multiple references) |
| 6 | `pipeline/project-plan.md` | 2 | pipeline/pipeline-state.md (stage reference), pipeline/implementation-spec.md (source doc) |
| 7 | `pipeline/architecture.md` | 2 | pipeline/pipeline-state.md (stage reference), pipeline/implementation-spec.md (source doc) |
| 8–10 | Remaining pipeline files | 1 each | Referenced by pipeline-state.md only |

All other files (output/.gitkeep, .gitignore, .claude/settings.json, .claude/shared-manifest.json) have 0–1 downstream references within AUDIT_ROOT.

### 3.5 Symlinks in .claude/commands/ or .claude/agents/ whose targets are not covered by permissions.additionalDirectories

`permissions.additionalDirectories` in `.claude/settings.json` contains one entry: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`.

All 93 symlink targets resolve (via `readlink -f`) to paths under `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/`, which is a descendant of the listed additional directory. String-prefix check passes for all 93 symlinks.

None found — all symlink targets are covered.

### 3.6 Projects referencing ai-resources without listing it in permissions.additionalDirectories

Within AUDIT_ROOT: this project references ai-resources via two SessionStart hooks (traversal to `ai-resources/.claude/hooks/`) and via 93 symlinks pointing into `ai-resources/.claude/`.

`permissions.additionalDirectories` lists `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`, which is an ancestor of both `ai-resources/` and all symlink targets. The workspace root entry covers ai-resources.

None found — checked `.claude/settings.json` in AUDIT_ROOT; coverage confirmed.

Section summary: 0 issues flagged / 0 deltas from previous audit.

---

## Section 4: Consistency Checks

### 4.1 Skill structural pattern consistency

N/A — no skills exist in this repo. Checked by confirming 0 SKILL.md files in AUDIT_ROOT.

### 4.2 Slash command definition pattern consistency

All 67 commands are symlinks to external ai-resources files. No project-local command definitions exist to compare. All symlinks follow the identical pattern: relative path `../../../../ai-resources/.claude/commands/{name}.md`.

None found — checked all 67 symlinks for consistent relative-path pattern.

### 4.3 Skill template vs. actual skills

N/A — No skill creation template file exists. Skills are created via /create-skill which references ai-resource-builder/SKILL.md for format standards.

### 4.4 Naming convention inconsistencies

Within AUDIT_ROOT:

- Command symlinks: all use kebab-case filenames ending `.md`. Pattern is consistent across all 67 files.
- Agent symlinks: all use kebab-case filenames ending `.md`. Pattern is consistent across all 26 files.
- Project directories: `output/`, `reference/`, `_consultants/`, `logs/`, `pipeline/` — consistent with documented convention in CLAUDE.md §Directory Layout.
- Log files: `decisions.md`, `session-notes.md` — consistent with convention described in CLAUDE.md.

None found within AUDIT_ROOT.

### 4.5 Directory structure violations

CLAUDE.md §Directory Layout specifies: `output/`, `reference/`, `_consultants/`, `logs/`, `pipeline/`. All five exist. No extra top-level directories exist (beyond `.claude/` and the git-standard `.git/`).

None found — checked by listing all directories under AUDIT_ROOT.

### 4.6 Slash command syntax and path resolution

All 67 commands are symlinks to external targets. All 67 resolve (confirmed via bulk existence check: 0 broken symlinks). The command definitions themselves are external files — their internal syntax is outside AUDIT_ROOT scope.

None found within AUDIT_ROOT.

### 4.7 Duplicate or colliding slash command names

No duplicate command names exist — each of the 67 command filenames is unique within `.claude/commands/`. Cross-check against built-in Claude Code commands: the command names (`qc-pass`, `repo-dd`, `wrap-session`, etc.) are not names of built-in Claude Code slash commands (built-ins are `/help`, `/clear`, `/compact`, `/model`, `/cost`, `/status`, `/init`, `/memory`, `/logout`, `/pr_comments`, `/terminal-setup` — none overlap with the project's command set).

None found — checked all 67 filenames for uniqueness and against the known built-in command set.

### 4.8 Agent model tier compliance

All 26 agents in `.claude/agents/` are symlinks to external ai-resources agents. Model declarations read from resolved targets via `model:` frontmatter. Cross-checked against `ai-resources/docs/agent-tier-table.md`.

| Agent | Declared tier | Expected tier (table) | Status |
|-------|--------------|----------------------|--------|
| claude-md-auditor | opus | opus | MATCH |
| collaboration-coach | opus | opus | MATCH |
| context-discovery | opus | Not in table | MISSING FROM TABLE |
| dd-extract-agent | haiku | haiku | MATCH |
| dd-log-sweep-agent | haiku | haiku | MATCH |
| execution-agent | sonnet | sonnet | MATCH |
| fading-gate-scanner | haiku | haiku | MATCH |
| findings-extractor | haiku | haiku | MATCH |
| fix-repo-issues-scanner | sonnet | sonnet | MATCH |
| friday-act-16a-summarizer | sonnet | sonnet | MATCH |
| improvement-analyst | opus | opus | MATCH |
| innovation-triage-auditor | opus | opus | MATCH |
| log-sweep-auditor | haiku | haiku | MATCH |
| permission-sweep-auditor | sonnet | sonnet | MATCH |
| project-manager | opus | opus | MATCH |
| qc-reviewer | opus | opus | MATCH |
| refinement-reviewer | opus | opus | MATCH |
| repo-dd-auditor | sonnet | sonnet | MATCH |
| risk-check-reviewer | opus | opus | MATCH |
| session-feedback-collector | opus | opus | MATCH |
| system-owner | opus | opus | MATCH |
| token-audit-auditor-mechanical | haiku | haiku | MATCH |
| token-audit-auditor | opus | opus | MATCH |
| triage-reviewer | opus | opus | MATCH |
| workflow-analysis-agent | opus | opus | MATCH |
| workflow-critique-agent | opus | opus | MATCH |

1 finding: `context-discovery` declares `model: opus` in its frontmatter but is absent from the agent tier table in `ai-resources/docs/agent-tier-table.md`. The declared opus tier is consistent with its work type (judgment — context discovery and selection). The issue is the missing table entry, not a tier mismatch.

### 4.9 .claude/settings.json vs. canonical baseline

The canonical baseline is `ai-resources/templates/project-settings.json.template`. Compared field by field:

**Deny entries (minimum: `Read(archive/**)`)**

Template deny set: `Bash(rm -rf *)`, `Bash(sudo *)`, `Read(archive/**)`, `Read(**/*.archive.*)`, `Read(**/deprecated/**)`, `Read(**/old/**)`.

Project deny set: all 6 entries present — exact match.

**Model field at top level**

Template: no `"model"` field at top level. Project settings.json: no `"model"` field at top level. Match.

Note: Q4.9 references "the `\"model\": \"sonnet\"` top-level default at line ~179" of new-project.md. Inspection of new-project.md shows that text appears in a `Model Selection` CLAUDE.md template fragment (a description of what a Model Selection section should say in a CLAUDE.md), not as an instruction to add `"model"` to settings.json. The `project-settings.json.template` itself has no `"model"` field. The marketing-positioning settings.json correctly has no `"model"` field. No violation.

**Commit dates**

Most recent commit touching `.claude/settings.json` in this project: 2026-06-03 (sole commit, `3d30ede`).
Most recent commit touching `CANONICAL_PERMS` block in `new-project.md`: cannot determine from AUDIT_ROOT — new-project.md is an external file outside this repo's git history.

Section summary: 1 issue flagged (context-discovery agent missing from tier table) / 0 deltas from previous audit.

---

## Section 5: Context Load

### 5.1 Total context loaded at session start

Automatically loaded at session start: `CLAUDE.md` (161 lines) + workspace `CLAUDE.md` (217 lines, loaded from parent). The project CLAUDE.md contains no `@import` directives.

The two SessionStart hooks execute shell commands but do not add files to context.

Estimate: ~378 lines of CLAUDE.md content auto-loaded (project + workspace). In approximate tokens: ~4,900 tokens (161 lines × ~12 tokens/line for CLAUDE.md prose = ~1,930 tokens project; 217 × ~12 = ~2,600 tokens workspace).

Additional context loaded manually per session (per CLAUDE.md §Embedded Consultant): `_consultants/embedded-consultant.md` (26 lines) and relevant source artifacts from corporate-identity and brand-book (external, loaded per session-guide instructions).

### 5.2 CLAUDE.md sections not referenced by any operational instruction

All 17 sections in project CLAUDE.md serve active operational purposes:

- Sections 1–13 (project-specific): each governs specific execution-session behavior (sequencing, boundary rules, gate enumeration, checkpoints, deferred writes, model posture, directory layout).
- Sections 14–17 (canonical enrichment: Input File Handling, Commit Rules, Compaction, Session Boundaries): standard operational rules that apply every session.

None found — checked each section for whether it governs active session behavior within the project.

### 5.3 CLAUDE.md line count history (last 5 commits modifying it)

This project has exactly 1 git commit (`3d30ede`, 2026-06-03). CLAUDE.md was created in that commit at 161 lines.

| Commit | Date | Lines |
|--------|------|-------|
| 3d30ede | 2026-06-03 | 161 |

No further history available — single-commit project.

Section summary: 0 issues flagged / 0 deltas from previous audit.

---

## Section 6: Drift & Staleness

### 6.1 Files not modified in 90 days but referenced by active commands, hooks, or CLAUDE.md

All files in this project were created in a single commit on 2026-06-03. The audit date is 2026-06-03. No file is more than 0 days old. The 90-day staleness threshold does not apply.

None found — all files are 0 days old (single commit, audit date equals commit date).

### 6.2 TODO, FIXME, PLACEHOLDER, or similar marker comments

Searched the following project files: `CLAUDE.md`, `_consultants/embedded-consultant.md`, `reference/source-map.md`, `reference/method-notes.md`, `logs/decisions.md`, `logs/session-notes.md`. Also searched pipeline files.

None found in any of the above files — confirmed by grep for `TODO`, `FIXME`, `PLACEHOLDER`, `BLOCKING`.

Note: `_consultants/embedded-consultant.md` contains a `STATUS: stub` line and italic "to author:" prompts. These are intentional authoring guidance markers, not code-style TODO comments. The spec (pipeline/implementation-spec.md Operation 3) required these markers by design.

### 6.3 Empty, stub, or boilerplate-only files

| File | Line count | Content assessment |
|------|-----------|-------------------|
| `output/.gitkeep` | 1 | Single comment line: "Deliverables A and B are authored here..." — intentional placeholder |
| `logs/session-notes.md` | 3 | Title + one-line seed ("Session-by-session progress notes...") — intentional empty seed |
| `reference/method-notes.md` | 17 | CAP statement + 3 empty stub sections — intentional capped byproduct seed by design |
| `_consultants/embedded-consultant.md` | 26 | STATUS stub header + 4 empty spec headers with to-author prompts + Sufficiency and Input sources — intentional stub awaiting W0.1 execution |

All 4 stub/near-empty files are intentional per `pipeline/implementation-spec.md` Operations 3, 5, 6, and 8. The implementation-log.md and test-results.md both confirm these are by-design scaffold states, not unfinished work.

Section summary: 0 issues flagged / 0 deltas from previous audit.

---

## Findings Summary

**Total findings: 1**

| # | Type | Location | Description |
|---|------|----------|-------------|
| F-1 | Missing item | `ai-resources/docs/agent-tier-table.md` | Agent `context-discovery` (symlinked into this project at `.claude/agents/context-discovery.md`) declares `model: opus` in frontmatter but has no entry in the agent tier table. The declared opus tier is consistent with the work type (judgment). The missing entry is in the external table file, outside AUDIT_ROOT. |

**Breakdown by type:**
- Discrepancy: 0
- Missing item: 1 (context-discovery agent absent from tier table — external file)
- Violation: 0
- Clean checks: all other questionnaire items

**Report file:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/repo-due-diligence-2026-06-03-project-marketing-positioning.md`
