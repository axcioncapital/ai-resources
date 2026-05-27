# Repo Due Diligence Audit — 2026-05-27
Repo: projects/nordic-pe-screening-project
Scope: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-screening-project
Commit: 277ae25
Previous audit: None
Depth: full

---

## Section 1: Inventory

### 1.1 Slash commands currently defined

All 62 commands under `.claude/commands/` are symlinks pointing into `ai-resources/.claude/commands/`. There are no project-local (non-symlink) command files.

| Command | Defined At | References / Notes |
|---|---|---|
| analyze-workflow | symlink → ai-resources/.claude/commands/analyze-workflow.md | Opus |
| architecture-review | symlink → ai-resources/.claude/commands/architecture-review.md | Opus |
| audit-claude-md | symlink → ai-resources/.claude/commands/audit-claude-md.md | Opus |
| audit-critical-resources | symlink → ai-resources/.claude/commands/audit-critical-resources.md | Opus |
| audit-repo | symlink → ai-resources/.claude/commands/audit-repo.md | Sonnet |
| clarify | symlink → ai-resources/.claude/commands/clarify.md | Sonnet |
| cleanup-worktree | symlink → ai-resources/.claude/commands/cleanup-worktree.md | Sonnet |
| coach | symlink → ai-resources/.claude/commands/coach.md | Opus |
| consult | symlink → ai-resources/.claude/commands/consult.md | Opus |
| contract-check | symlink → ai-resources/.claude/commands/contract-check.md | Opus |
| create-skill | symlink → ai-resources/.claude/commands/create-skill.md | Opus |
| decide | symlink → ai-resources/.claude/commands/decide.md | Opus |
| deploy-kb | symlink → ai-resources/.claude/commands/deploy-kb.md | Sonnet |
| drift-check | symlink → ai-resources/.claude/commands/drift-check.md | Opus |
| explain | symlink → ai-resources/.claude/commands/explain.md | Sonnet |
| fix-repo-issues | symlink → ai-resources/.claude/commands/fix-repo-issues.md | Opus |
| fix-symlinks | symlink → ai-resources/.claude/commands/fix-symlinks.md | Sonnet |
| friction-log | symlink → ai-resources/.claude/commands/friction-log.md | Sonnet |
| friday-act | symlink → ai-resources/.claude/commands/friday-act.md | Sonnet |
| friday-checkup | symlink → ai-resources/.claude/commands/friday-checkup.md | Sonnet |
| friday-journal | symlink → ai-resources/.claude/commands/friday-journal.md | Opus |
| friday-so | symlink → ai-resources/.claude/commands/friday-so.md | Opus |
| graduate-resource | symlink → ai-resources/.claude/commands/graduate-resource.md | Sonnet |
| grill-me | symlink → ai-resources/.claude/commands/grill-me.md | Opus |
| handoff | symlink → ai-resources/.claude/commands/handoff.md | Sonnet |
| implementation-triage | symlink → ai-resources/.claude/commands/implementation-triage.md | Opus |
| improve-skill | symlink → ai-resources/.claude/commands/improve-skill.md | Opus |
| improve | symlink → ai-resources/.claude/commands/improve.md | Opus |
| innovation-sweep | symlink → ai-resources/.claude/commands/innovation-sweep.md | Opus |
| log-sweep | symlink → ai-resources/.claude/commands/log-sweep.md | claude-sonnet-4-6[1m] |
| migrate-skill | symlink → ai-resources/.claude/commands/migrate-skill.md | Opus |
| monday-prep | symlink → ai-resources/.claude/commands/monday-prep.md | Sonnet |
| note | symlink → ai-resources/.claude/commands/note.md | Sonnet |
| open-items | symlink → ai-resources/.claude/commands/open-items.md | Sonnet |
| permission-sweep | symlink → ai-resources/.claude/commands/permission-sweep.md | Sonnet |
| prime | symlink → ai-resources/.claude/commands/prime.md | Sonnet |
| project-consultant | symlink → ai-resources/.claude/commands/project-consultant.md | Opus |
| qc-pass | symlink → ai-resources/.claude/commands/qc-pass.md | Sonnet |
| recommend | symlink → ai-resources/.claude/commands/recommend.md | Sonnet |
| refinement-deep | symlink → ai-resources/.claude/commands/refinement-deep.md | Opus |
| refinement-pass | symlink → ai-resources/.claude/commands/refinement-pass.md | Sonnet |
| repo-dd | symlink → ai-resources/.claude/commands/repo-dd.md | Opus |
| request-skill | symlink → ai-resources/.claude/commands/request-skill.md | Sonnet |
| resolve-improvement-log | symlink → ai-resources/.claude/commands/resolve-improvement-log.md | Sonnet |
| resolve-repo-problem | symlink → ai-resources/.claude/commands/resolve-repo-problem.md | Opus |
| resolve | symlink → ai-resources/.claude/commands/resolve.md | Opus |
| risk-check | symlink → ai-resources/.claude/commands/risk-check.md | Opus |
| route-change | symlink → ai-resources/.claude/commands/route-change.md | Sonnet |
| save-session | symlink → ai-resources/.claude/commands/save-session.md | Sonnet |
| scope | symlink → ai-resources/.claude/commands/scope.md | Sonnet |
| session-guide | symlink → ai-resources/.claude/commands/session-guide.md | Sonnet |
| session-plan | symlink → ai-resources/.claude/commands/session-plan.md | Opus |
| session-start | symlink → ai-resources/.claude/commands/session-start.md | Sonnet |
| so-monthly | symlink → ai-resources/.claude/commands/so-monthly.md | Opus |
| summary | symlink → ai-resources/.claude/commands/summary.md | Opus |
| sync-workflow | symlink → ai-resources/.claude/commands/sync-workflow.md | Sonnet |
| systems-review | symlink → ai-resources/.claude/commands/systems-review.md | Opus |
| token-audit | symlink → ai-resources/.claude/commands/token-audit.md | Opus |
| triage | symlink → ai-resources/.claude/commands/triage.md | Sonnet |
| update-claude-md | symlink → ai-resources/.claude/commands/update-claude-md.md | Sonnet |
| usage-analysis | symlink → ai-resources/.claude/commands/usage-analysis.md | Sonnet |
| wrap-session | symlink → ai-resources/.claude/commands/wrap-session.md | Sonnet |

All 62 symlinks resolve. Two commands present in ai-resources but absent from this project (by design — excluded by `auto-sync-shared.sh` baked-in list): `new-project` and `deploy-workflow`.

Section summary: 62 commands catalogued / no previous audit

### 1.2 Hooks currently configured

Source: `.claude/settings.json` (60 lines). No `.claude/settings.local.json` exists.

| Trigger | Command | Files Referenced | Timeout |
|---|---|---|---|
| SessionStart | Walk-up loop; calls `ai-resources/.claude/hooks/auto-sync-shared.sh` when found | `auto-sync-shared.sh` (exists, executable) | 10 s |
| SessionStart | Walk-up loop; calls `ai-resources/.claude/hooks/check-permission-sanity.sh` when found | `check-permission-sanity.sh` (exists, executable) | 5 s |

No PreToolUse, PostToolUse, or Stop hooks are registered in the project's `settings.json`. Those hooks (check-heavy-tool.sh, friction-log-auto.sh, log-write-activity.sh, auto-qc-nudge.sh, auto-resolve-nudge.sh, check-stop-reminders.sh, coach-reminder.sh, improve-reminder.sh, detect-innovation.sh, friday-checkup-reminder.sh) are registered in `ai-resources/.claude/settings.json` and would be active only when sessions are opened against the ai-resources root, not from this project root. The project's `.claude/hooks/` directory does not exist; hooks beyond the two SessionStart entries above are not locally registered.

Section summary: 2 hooks configured / no previous audit

### 1.3 Template files

None found — checked all non-symlink, non-directory files under AUDIT_ROOT. No file in the project is classified as a template. The project consumes templates from ai-resources (e.g., `ai-resources/templates/project-settings.json.template`) by reference; no template is copied into this project.

Section summary: 0 template files catalogued / no previous audit

### 1.4 Scripts (bash, python, or other)

None found — checked all non-symlink, non-directory files under AUDIT_ROOT. No `.sh`, `.py`, or script files exist inside the project directory. Hook scripts reside in `ai-resources/.claude/hooks/` and are referenced by the SessionStart hooks via walk-up; they are not owned by or copied into this project.

Section summary: 0 scripts catalogued / no previous audit

### 1.5 Skills in the repo

None. The project owns no skills at scaffold time. Skills are held in `ai-resources/skills/` (71 skills per repo-snapshot.md) and referenced by path. No `SKILL.md` file exists anywhere under AUDIT_ROOT.

Section summary: 0 skills / no previous audit

### 1.6 Uncategorized files

All non-symlink files in AUDIT_ROOT:

| Path | Category | Notes |
|---|---|---|
| `CLAUDE.md` | Project instructions | 117 lines |
| `.gitignore` | Repo hygiene | 23 lines |
| `.claude/settings.json` | Configuration | 60 lines |
| `.claude/shared-manifest.json` | Inheritance manifest | 9 lines |
| `inputs/README.md` | Input placeholder | 22 lines |
| `logs/decisions.md` | Session telemetry stub | 10 lines |
| `pipeline/architecture.md` | Pipeline planning artifact | 440 lines |
| `pipeline/context-pack.md` | Pipeline planning artifact | 270 lines |
| `pipeline/decisions.md` | Pipeline decisions log | 11 lines |
| `pipeline/implementation-log.md` | Pipeline stage artifact | 60 lines |
| `pipeline/implementation-spec.md` | Pipeline stage artifact | 555 lines |
| `pipeline/pipeline-state.md` | Pipeline orchestrator state | 15 lines |
| `pipeline/project-plan.md` | Pipeline planning artifact | 559 lines |
| `pipeline/repo-snapshot.md` | Pipeline stage artifact | 417 lines |
| `pipeline/sources.md` | Pipeline provenance | 17 lines |
| `pipeline/test-results.md` | Pipeline stage artifact | 253 lines |
| `work/W0-SETUP-README.md` | W-unit placeholder | 28 lines |
| `work/W1-SCREENING-README.md` | W-unit placeholder | 46 lines |
| `work/W2-ENRICHMENT-README.md` | W-unit placeholder | 43 lines |
| `work/W3-LANDSCAPE-README.md` | W-unit placeholder | 43 lines |
| `work/W4-WORKFLOW-HARDENING-README.md` | W-unit placeholder | 47 lines |
| `workflow-artifacts/` | Directory (empty) | W4-exclusive write target per architecture |

No uncategorized items found. Every file maps cleanly to a recognized category: project instructions, repo hygiene, configuration, pipeline artifacts, W-unit shells, or intentionally empty directories.

Section summary: 22 files + 1 empty directory catalogued — none uncategorized / no previous audit

### 1.7 Symlinks

All symlinks reside in `.claude/commands/` (62 symlinks) and `.claude/agents/` (24 symlinks). Total: 86 symlinks. All point into `ai-resources/.claude/commands/` or `ai-resources/.claude/agents/` via the relative path `../../../../ai-resources/.claude/{commands,agents}/{file}.md`.

All 86 symlinks resolve successfully. Resolved targets reside at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/{commands,agents}/`.

**Commands symlinks (62):** All target files exist and are accessible. See Q1.1 for the full list.

**Agents symlinks (24):**

| Symlink | Target (relative) | Resolved | Accessible |
|---|---|---|---|
| claude-md-auditor.md | ../../../../ai-resources/.claude/agents/claude-md-auditor.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/claude-md-auditor.md | Y |
| collaboration-coach.md | ../../../../ai-resources/.claude/agents/collaboration-coach.md | (same pattern) | Y |
| critical-resource-auditor.md | ../../../../ai-resources/.claude/agents/critical-resource-auditor.md | (same pattern) | Y |
| dd-extract-agent.md | ../../../../ai-resources/.claude/agents/dd-extract-agent.md | (same pattern) | Y |
| dd-log-sweep-agent.md | ../../../../ai-resources/.claude/agents/dd-log-sweep-agent.md | (same pattern) | Y |
| execution-agent.md | ../../../../ai-resources/.claude/agents/execution-agent.md | (same pattern) | Y |
| fading-gate-scanner.md | ../../../../ai-resources/.claude/agents/fading-gate-scanner.md | (same pattern) | Y |
| findings-extractor.md | ../../../../ai-resources/.claude/agents/findings-extractor.md | (same pattern) | Y |
| fix-repo-issues-scanner.md | ../../../../ai-resources/.claude/agents/fix-repo-issues-scanner.md | (same pattern) | Y |
| friday-act-16a-summarizer.md | ../../../../ai-resources/.claude/agents/friday-act-16a-summarizer.md | (same pattern) | Y |
| improvement-analyst.md | ../../../../ai-resources/.claude/agents/improvement-analyst.md | (same pattern) | Y |
| innovation-triage-auditor.md | ../../../../ai-resources/.claude/agents/innovation-triage-auditor.md | (same pattern) | Y |
| log-sweep-auditor.md | ../../../../ai-resources/.claude/agents/log-sweep-auditor.md | (same pattern) | Y |
| permission-sweep-auditor.md | ../../../../ai-resources/.claude/agents/permission-sweep-auditor.md | (same pattern) | Y |
| qc-reviewer.md | ../../../../ai-resources/.claude/agents/qc-reviewer.md | (same pattern) | Y |
| refinement-reviewer.md | ../../../../ai-resources/.claude/agents/refinement-reviewer.md | (same pattern) | Y |
| repo-dd-auditor.md | ../../../../ai-resources/.claude/agents/repo-dd-auditor.md | (same pattern) | Y |
| risk-check-reviewer.md | ../../../../ai-resources/.claude/agents/risk-check-reviewer.md | (same pattern) | Y |
| system-owner.md | ../../../../ai-resources/.claude/agents/system-owner.md | (same pattern) | Y |
| token-audit-auditor-mechanical.md | ../../../../ai-resources/.claude/agents/token-audit-auditor-mechanical.md | (same pattern) | Y |
| token-audit-auditor.md | ../../../../ai-resources/.claude/agents/token-audit-auditor.md | (same pattern) | Y |
| triage-reviewer.md | ../../../../ai-resources/.claude/agents/triage-reviewer.md | (same pattern) | Y |
| workflow-analysis-agent.md | ../../../../ai-resources/.claude/agents/workflow-analysis-agent.md | (same pattern) | Y |
| workflow-critique-agent.md | ../../../../ai-resources/.claude/agents/workflow-critique-agent.md | (same pattern) | Y |

6 agents present in ai-resources but absent from the project (by design — excluded by `auto-sync-shared.sh`): `pipeline-stage-3a`, `pipeline-stage-3b`, `pipeline-stage-3c`, `pipeline-stage-4`, `pipeline-stage-5`, `session-guide-generator`.

Section summary: 86 symlinks catalogued, all resolve / no previous audit

---

## Section 2: CLAUDE.md Health

### 2.1 Line count and sections

CLAUDE.md: **117 lines**, **13 sections**.

Section headings:
1. `## Purpose` (line 3)
2. `## Upstream Inputs (canonical)` (line 9)
3. `## Program Shape` (line 17)
4. `## Bottom-up Principle` (line 42)
5. `## Cross-Model Workflow` (line 46)
6. `## Confidence and Sourcing` (line 50)
7. `## Layer 2 Child Cycles` (line 60)
8. `## Model Selection` (line 71)
9. `## Adaptive Thinking Override` (line 79)
10. `## Input File Handling` (line 83)
11. `## Commit Rules` (line 96)
12. `## Compaction` (line 104)
13. `## Session Boundaries` (line 115)

Section summary: 1 issue flagged (settings.local.json not yet created) / no previous audit

### 2.2 References in CLAUDE.md that do not exist

| Reference | Location | Exists? | Notes |
|---|---|---|---|
| `pipeline/context-pack.md` | Line 11 | Y | Present, 270 lines |
| `pipeline/project-plan.md` | Line 12 | Y | Present, 559 lines |
| `inputs/nordic-pe-funds-raw.xlsx` | Line 13 | N | Operator-supplied; documented as "placeholder pending." Expected to be absent at scaffold time per `inputs/README.md`. |
| `inputs/README.md` | Line 13 | Y | Present |
| `projects/project-planning/pipeline/ref-project-plan.md` | Line 19 | Y | Present in workspace |
| `ai-resources/docs/cross-model-rules.md` | Line 48 | Y | Present in workspace |
| `projects/project-planning/` | Line 64 | Y | Directory exists |
| `/context-builder` command | Line 64 | Y | Exists at `projects/project-planning/.claude/commands/context-builder.md` |
| `/plan-draft`, `/plan-refine`, `/plan-evaluate` | Line 65 | Y | All present in `projects/project-planning/.claude/commands/` |
| `pipeline/children/{phase}/` | Line 66 | N | Intentionally not pre-created; architecture §6 mandates lazy creation. No git history shows deletion. |
| `.claude/settings.local.json` | Lines 73, 81 | N | File does not exist. Architecture §2 lists it as a planned file ("operator-local overrides; declares CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1"). Implementation spec §1 defers it to "post-pipeline enrichment." File was never created. |
| `pipeline/project-plan.md §3` | Line 58 | Y | Present |

**Issues identified:**
1. `.claude/settings.local.json` — referenced at lines 73 and 81; does not exist. CLAUDE.md line 81 says "set `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1` in `.claude/settings.local.json`" — this instruction cannot be honored until the file is created. Architecture §2 describes the file as existing; implementation spec §1 defers creation to post-pipeline enrichment; the enrichment step was never completed for this file.
2. `inputs/nordic-pe-funds-raw.xlsx` — referenced as a required input that is "placeholder pending." The absence is documented and expected. Not a broken reference.
3. `pipeline/children/{phase}/` — referenced as a future artifact; absence is by design (lazy creation). Not a broken reference.

Section summary: 1 issue flagged (settings.local.json missing) / no previous audit

### 2.3 Contradicting sections

None found — checked all 13 sections against each other.

The Model Selection section (line 71) states "there is no project default" and also states "Recommended posture: Opus 4.7 … for nearly all program work." These are not contradictory: the first is a prohibition on default declarations (a structural constraint); the second is a session-selection recommendation (advisory). The distinction is consistent with workspace CLAUDE.md § Model Tier.

Section summary: 0 issues flagged / no previous audit

### 2.4 Conventions defined in CLAUDE.md not followed by actual files

| Convention | Files Affected | State |
|---|---|---|
| `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1` in `.claude/settings.local.json` (Adaptive Thinking Override, line 81) | `.claude/settings.local.json` | `.claude/settings.local.json` does not exist. The override has not been applied. |
| Execution outputs written to `work/{w-unit}/` subdirectories (Program Shape, line 17) | `work/w0-setup/`, `work/w1-screening/`, etc. | Not yet created; all W-units are at placeholder state. Absence is by design — subdirectories are created lazily at execution time. |
| Child cycle artifacts in `pipeline/children/{phase}/` (Layer 2 Child Cycles, line 66) | `pipeline/children/` | Not yet created; by design (lazy creation). No phases have opened. |

Section summary: 1 convention-violation flagged (settings.local.json absent, CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1 unapplied) / no previous audit

### 2.5 Features where some referenced files exist and others do not

| Feature | Files That Exist | Files That Do Not Exist |
|---|---|---|
| Adaptive Thinking Override | CLAUDE.md instruction (line 81) | `.claude/settings.local.json` — the file into which the override must be written |

Section summary: 1 issue flagged / no previous audit

### 2.6 Task-type-specific content that belongs elsewhere per CLAUDE.md Scoping rule

Workspace CLAUDE.md § CLAUDE.md Scoping prohibits verbatim duplication of canonical workspace rules in project CLAUDE.md. Four sections in the project CLAUDE.md are explicitly labelled as verbatim copies of workspace-canonical rules:

| Section Heading | Lines | Task Type | Workspace Rule Violated |
|---|---|---|---|
| `## Input File Handling` | 83–95 (13 lines) | File-write discipline for inputs | Verbatim duplication of workspace canonical rule. The section explicitly states: "This rule mirrors the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded." |
| `## Commit Rules` | 96–103 (8 lines) | Commit behavior | Verbatim duplication. The section explicitly states: "This rule mirrors the canonical `Commit behavior` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded." |
| `## Compaction` | 104–114 (11 lines) | Compaction protocol | Duplication of workspace compaction protocol. Does not include an explicit "mirrors" statement but the content mirrors workspace CLAUDE.md references to `ai-resources/docs/compaction-protocol.md`. |
| `## Session Boundaries` | 115–117 (3 lines) | Session-switching guidance | Canonical workspace behavioral rule duplicated. |

The implementation spec (§1) explicitly notes these four sections as "post-pipeline enrichment §4 appends these," stating the justification as "projects are sometimes opened without the parent workspace context loaded." The sections self-describe as duplicates with stated rationale. Per the questionnaire instructions, this is a factual observation: four sections are verbatim or near-verbatim duplications of canonical workspace rules, which the workspace CLAUDE.md Scoping rule names as prohibited.

Section summary: 4 issues flagged (verbatim canonical section duplications) / no previous audit

---

## Section 3: Dependency References

### 3.1 Files referenced by each slash command

All 62 commands are symlinks into `ai-resources/.claude/commands/`. The command file contents are external to AUDIT_ROOT. Per scoped-audit rules, targets are recorded as "symlink to external target" — content of the target files is not audited here. All 62 target files exist and are accessible (confirmed via `readlink -f` in Q1.7).

### 3.2 Slash command output chains

All commands are inherited from ai-resources. No project-local command chains are defined within AUDIT_ROOT. The CLAUDE.md describes command usage chains (e.g., `/context-builder` → `/plan-draft` → `/plan-refine` → `/plan-evaluate`) but those commands live in `projects/project-planning/`, outside AUDIT_ROOT.

### 3.3 Files referenced by more than one command, hook, or script

Within AUDIT_ROOT, the following files are referenced by multiple elements:

| File | Referenced By |
|---|---|
| `pipeline/project-plan.md` | CLAUDE.md (line 12, 58), W-unit READMEs (W0, W1, W2, W3, W4), `pipeline/architecture.md`, `pipeline/implementation-spec.md`, `pipeline/sources.md`, `pipeline/implementation-log.md`, `pipeline/test-results.md` |
| `pipeline/context-pack.md` | CLAUDE.md (line 11), `pipeline/architecture.md`, `pipeline/sources.md`, `pipeline/test-results.md` |
| `pipeline/architecture.md` | `pipeline/implementation-spec.md` (traceability table), `pipeline/implementation-log.md`, `pipeline/pipeline-state.md` |
| `.claude/settings.json` | Referenced by hook walk-up logic (auto-sync-shared.sh, check-permission-sanity.sh) |
| `ai-resources/docs/cross-model-rules.md` | CLAUDE.md (line 48), W-unit READMEs (W1, W2, W3), `pipeline/architecture.md` (§6) |
| `ai-resources/docs/analytical-output-principles.md` | W-unit READMEs (W1, W2, W3), `pipeline/architecture.md` (§3.2) |
| `inputs/README.md` | CLAUDE.md (line 13), `pipeline/implementation-spec.md`, `pipeline/implementation-log.md`, `pipeline/test-results.md` |

### 3.4 Files ranked by downstream references (top 10)

| Rank | File | References From (count) |
|---|---|---|
| 1 | `pipeline/project-plan.md` | 9 (CLAUDE.md, 5 W-unit READMEs, architecture, implementation-spec, sources, implementation-log, test-results) |
| 2 | `pipeline/architecture.md` | 4 (implementation-spec, implementation-log, pipeline-state, test-results) |
| 3 | `pipeline/context-pack.md` | 4 (CLAUDE.md, architecture, sources, test-results) |
| 4 | `ai-resources/docs/cross-model-rules.md` (external) | 4 (CLAUDE.md, W1/W2/W3 READMEs, architecture) |
| 5 | `ai-resources/docs/analytical-output-principles.md` (external) | 4 (W1/W2/W3 READMEs, architecture) |
| 6 | `inputs/README.md` | 4 (CLAUDE.md, implementation-spec, implementation-log, test-results) |
| 7 | `.claude/settings.json` | 3 (hook walk-up logic in both SessionStart hooks, architecture §2) |
| 8 | `pipeline/implementation-spec.md` | 2 (implementation-log, pipeline-state) |
| 9 | `.claude/shared-manifest.json` | 2 (auto-sync-shared.sh at session time, architecture §3.1) |
| 10 | `pipeline/repo-snapshot.md` | 2 (architecture, pipeline-state) |

### 3.5 Symlinks in `.claude/commands/` or `.claude/agents/` whose targets are not covered by `permissions.additionalDirectories`

The project's `.claude/settings.json` lists `permissions.additionalDirectories`: `["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]`.

All 86 symlinks (62 commands + 24 agents) resolve to targets under `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/{commands,agents}/`. The `additionalDirectories` entry `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` is a string-prefix match (ancestor) of all resolved targets.

None found — checked all 86 symlink resolved paths against the `additionalDirectories` entry. All targets are covered.

### 3.6 Projects that reference `ai-resources/` but do not list workspace root or `ai-resources/` in `permissions.additionalDirectories`

Within AUDIT_ROOT: this project references `ai-resources/` via 86 command/agent symlinks and two SessionStart hook walk-up commands. The project's `.claude/settings.json` `permissions.additionalDirectories` entry is `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` — the workspace root, which is an ancestor of all `ai-resources/` paths.

None found — checked project `settings.json` additionalDirectories; workspace root entry covers all ai-resources references.

Section summary: 0 issues flagged / no previous audit

---

## Section 4: Consistency Checks

### 4.1 Skill structural pattern consistency

N/A — no skills exist within AUDIT_ROOT.

### 4.2 Slash command definition pattern consistency

All 62 commands are symlinks. No project-local command files exist. All symlinks use the same relative target pattern (`../../../../ai-resources/.claude/commands/{name}.md`). Pattern is consistent across all 62 entries.

None found — checked all 62 command symlinks; all follow the same relative path pattern.

Section summary: 0 issues flagged / no previous audit

### 4.3 Skill template comparison

N/A — No skill creation template file exists. Skills are created via /create-skill which references ai-resource-builder/SKILL.md for format standards.

### 4.4 Naming convention inconsistencies

Within AUDIT_ROOT (project-owned files only; symlink names are governed by ai-resources):

- W-unit README naming: `W0-SETUP-README.md`, `W1-SCREENING-README.md`, `W2-ENRICHMENT-README.md`, `W3-LANDSCAPE-README.md`, `W4-WORKFLOW-HARDENING-README.md` — all follow UPPERCASE-DESCRIPTION-README.md pattern. Consistent.
- Pipeline files: all lowercase with hyphens (`architecture.md`, `context-pack.md`, `decisions.md`, etc.). Consistent.
- Log files: lowercase with hyphens (`decisions.md`). Consistent with pipeline convention.

None found — checked all project-owned file names.

Section summary: 0 issues flagged / no previous audit

### 4.5 Directory structure violations

Architecture §2 specifies the program-shell layout. Actual state vs. specified state:

| Specified Path | Expected State | Actual State | Match? |
|---|---|---|---|
| `CLAUDE.md` | exists | exists (117 lines) | Y |
| `.gitignore` | exists | exists (23 lines) | Y |
| `.claude/settings.json` | exists | exists (60 lines) | Y |
| `.claude/settings.local.json` | "operator-local overrides; declares CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1" | does not exist | N |
| `.claude/commands/` | populated at session start | 62 symlinks present | Y |
| `.claude/agents/` | populated at session start | 24 symlinks present | Y |
| `.claude/hooks/` | populated at session start | directory does not exist | N (minor — populated only when auto-sync runs hooks) |
| `inputs/README.md` | exists | exists (22 lines) | Y |
| `inputs/nordic-pe-funds-raw.xlsx` | operator-supplied at runtime | does not exist | Y (expected absent at scaffold) |
| `pipeline/context-pack.md` | exists | exists (270 lines) | Y |
| `pipeline/project-plan.md` | exists | exists (559 lines) | Y |
| `pipeline/repo-snapshot.md` | exists | exists (417 lines) | Y |
| `pipeline/architecture.md` | exists | exists (440 lines) | Y |
| `pipeline/decisions.md` | exists | exists (11 lines) | Y |
| `pipeline/sources.md` | exists | exists (17 lines) | Y |
| `pipeline/pipeline-state.md` | exists | exists (15 lines) | Y |
| `pipeline/children/` | lazy creation | does not exist | Y (by design) |
| `work/` | exists (empty) | exists | Y |
| `work/w0-setup/` through `work/w3-landscape/` | lazy creation | do not exist | Y (by design) |
| `workflow-artifacts/` | exists (empty) | exists (empty) | Y |
| `logs/decisions.md` | exists | exists (10 lines) | Y |
| `logs/friction-log.md` | created on first append | does not exist | Y (by design) |
| `logs/usage-log.md` | created on first append | does not exist | Y (by design) |
| `logs/notes.md` | created on first append | does not exist | Y (by design) |

**Issue:** `.claude/settings.local.json` is listed in architecture §2 as existing with content; it does not exist. `.claude/hooks/` directory is not pre-created (no hooks are locally registered beyond the SessionStart entries in settings.json; this is consistent with architecture §3.3 which notes most hooks are "inherited" via ai-resources settings, not locally registered).

Section summary: 1 issue flagged (settings.local.json absent) / no previous audit

### 4.6 Slash command definition syntax and path resolution

All 62 commands are symlinks to ai-resources targets. All symlinks resolve (confirmed in Q1.7). No project-local command files define syntax that could be malformed.

None found — checked all 62 command symlinks resolve successfully.

Section summary: 0 issues flagged / no previous audit

### 4.7 Duplicate or built-in command names

None found — checked all 62 command names against each other (all are unique) and against known Claude Code built-in commands. No duplicates within the 62. The command names follow the ai-resources canonical naming conventions.

Section summary: 0 issues flagged / no previous audit

### 4.8 Agent tier table compliance

Agents present in the project (24 symlinks) compared against `ai-resources/docs/agent-tier-table.md`:

| Agent | Declared Tier | Expected Tier (table) | In Table? | Status |
|---|---|---|---|---|
| claude-md-auditor | opus | opus | Y | Match |
| collaboration-coach | opus | opus | Y | Match |
| critical-resource-auditor | opus | opus | Y | Match |
| dd-extract-agent | haiku | haiku | Y | Match |
| dd-log-sweep-agent | haiku | haiku | Y | Match |
| execution-agent | sonnet | sonnet | Y | Match |
| fading-gate-scanner | haiku | — | N | Missing from table |
| findings-extractor | haiku | haiku | Y | Match |
| fix-repo-issues-scanner | sonnet | — | N | Missing from table |
| friday-act-16a-summarizer | sonnet | — | N | Missing from table |
| improvement-analyst | opus | opus | Y | Match |
| innovation-triage-auditor | opus | opus | Y | Match |
| log-sweep-auditor | haiku | haiku | Y | Match |
| permission-sweep-auditor | sonnet | sonnet | Y | Match |
| qc-reviewer | opus | opus | Y | Match |
| refinement-reviewer | opus | opus | Y | Match |
| repo-dd-auditor | sonnet | sonnet | Y | Match |
| risk-check-reviewer | opus | opus | Y | Match |
| system-owner | opus | opus | Y | Match |
| token-audit-auditor-mechanical | haiku | haiku | Y | Match |
| token-audit-auditor | opus | opus | Y | Match |
| triage-reviewer | opus | opus | Y | Match |
| workflow-analysis-agent | opus | opus | Y | Match |
| workflow-critique-agent | opus | opus | Y | Match |

**Issues:** 3 agents are deployed (via symlink) in this project but are absent from the agent tier table in `ai-resources/docs/agent-tier-table.md`:
1. `fading-gate-scanner` — declared tier: haiku
2. `fix-repo-issues-scanner` — declared tier: sonnet
3. `friday-act-16a-summarizer` — declared tier: sonnet

No tier mismatches found among the 21 agents that do appear in the table.

Section summary: 3 issues flagged (agents missing from tier table) / no previous audit

### 4.9 Project `.claude/settings.json` vs. canonical baseline

Canonical baseline source: `ai-resources/templates/project-settings.json.template`. The questionnaire references a "model: sonnet" top-level default at line ~179 of `new-project.md` — that line is a CLAUDE.md Model Selection section template (not a `settings.json` directive). The actual `project-settings.json.template` contains no `"model"` field, which is consistent with the workspace CLAUDE.md prohibition on model defaults in settings files.

| Check | Expected | Actual | Status |
|---|---|---|---|
| `permissions.deny` contains `Read(archive/**)` | Y | Y — present | Match |
| `permissions.deny` contains `Read(**/*.archive.*)` | Y | Y — present | Match |
| `permissions.deny` contains `Read(**/deprecated/**)` | Y | Y — present | Match |
| `permissions.deny` contains `Read(**/old/**)` | Y | Y — present | Match |
| `permissions.deny` contains `Bash(git push*)` | Y | Y — present | Match |
| `permissions.deny` contains `Bash(rm -rf *)` | Y | Y — present | Match |
| `permissions.deny` contains `Bash(sudo *)` | Y | Y — present | Match |
| `"model"` field at top level | Absent (workspace prohibition) | Absent | Match |
| `permissions.defaultMode` = `"bypassPermissions"` | Y | Y — present | Match |
| auto-sync SessionStart hook registered | Y | Y — present | Match |
| permission-sanity SessionStart hook registered | Y | Y — present | Match |

**Deny entries comparison:** No entries missing from project settings.json. No extra entries beyond the canonical set.

**Date comparison:**
- Last commit touching `projects/nordic-pe-screening-project/.claude/settings.json`: 2026-05-27 (commit 277ae25 — initial scaffold)
- Last commit touching `ai-resources/.claude/commands/new-project.md` (CANONICAL_PERMS source): 2026-05-26 (commit a5b0aaa)

The project's settings.json was written after the most recent canonical baseline change, so no stale-template risk exists.

Section summary: 0 issues flagged / no previous audit

---

## Section 5: Context Load

### 5.1 Estimated context loaded at session start

When a session opens at `projects/nordic-pe-screening-project/`:

| File | Lines | Notes |
|---|---|---|
| Workspace CLAUDE.md (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md`) | 189 | Auto-loaded as parent workspace |
| Project CLAUDE.md (`CLAUDE.md`) | 117 | Auto-loaded as project |
| **Total auto-loaded** | **306** | |

No `@import` or `@file` directives found in either CLAUDE.md. No other files are auto-loaded at session start by default. The SessionStart hooks (auto-sync-shared.sh, check-permission-sanity.sh) execute scripts but do not load additional context into the session.

Approximate context: **306 lines** across 2 CLAUDE.md files.

### 5.2 CLAUDE.md sections not referenced by any command, hook, or operational instruction

All 13 sections of the project CLAUDE.md serve a documented purpose:

| Section | Referenced By |
|---|---|
| Purpose | No command reference; provides operator orientation at every session start |
| Upstream Inputs (canonical) | Operational grounding for W0 dependency; referenced in W-unit READMEs |
| Program Shape | Defines W-unit sequencing that all downstream sessions must honor |
| Bottom-up Principle | Behavioral constraint; not referenced by a specific command but applies to all phases |
| Cross-Model Workflow | References ai-resources/docs/cross-model-rules.md; governs multi-tool sessions |
| Confidence and Sourcing | Per-fund sourcing rule; applies to W1-W3 analytical work |
| Layer 2 Child Cycles | References /context-builder, /plan-draft, /plan-refine, /plan-evaluate |
| Model Selection | References /model; governs session model selection |
| Adaptive Thinking Override | References settings.local.json (currently absent) |
| Input File Handling | Behavioral rule for Read tool usage |
| Commit Rules | Behavioral rule for git commit behavior |
| Compaction | Behavioral rule for /compact handling |
| Session Boundaries | Behavioral rule for /clear usage |

No sections found that are unreferenced by any command, hook, or operational instruction. Note: "Bottom-up Principle" and "Confidence and Sourcing" are domain-specific behavioral rules with no corresponding command invocation, but they are operational instructions that apply to every analytical turn in the project.

Section summary: 0 issues flagged / no previous audit

### 5.3 CLAUDE.md line count at each of the last 5 commits

The project has only 1 commit that touches CLAUDE.md:

| Commit | Date | CLAUDE.md Line Count |
|---|---|---|
| 277ae25 | 2026-05-27 | 117 |

Only 1 commit exists in the project's git history. There are no prior CLAUDE.md modification commits to report.

Section summary: 1 commit in history / no previous audit

---

## Section 6: Drift & Staleness

### 6.1 Files not modified in the last 90 days but still referenced by active commands, hooks, or CLAUDE.md

None found — checked all files in AUDIT_ROOT. The project has a single commit dated 2026-05-27. Today's date is 2026-05-27. No file in the project is older than 1 day (0 days old). The 90-day threshold is not met by any file.

Section summary: 0 issues flagged / no previous audit

### 6.2 TODO, FIXME, PLACEHOLDER, or similar marker comments

The following occurrences were found in project-owned non-pipeline files (grep -rni on `CLAUDE.md`, `inputs/`, `logs/`, `work/`, `.gitignore`, `.claude/settings.json`, `.claude/shared-manifest.json`):

| File | Line(s) | Marker | Nature |
|---|---|---|---|
| `CLAUDE.md` | 13 | "placeholder pending" | References the absent `inputs/nordic-pe-funds-raw.xlsx`; intentional scaffold-state marker |
| `inputs/README.md` | 7, 18 | "placeholder pending", "placeholder" | W0 binding documentation; intentional |
| `work/W0-SETUP-README.md` | 3 | "Placeholder — execution not yet started" | Intentional W-unit shell state marker |
| `work/W1-SCREENING-README.md` | 3, 23 | "Placeholder — execution not yet started", "intentionally a placeholder" | Intentional W-unit shell |
| `work/W2-ENRICHMENT-README.md` | 3 | "Placeholder — execution not yet started" | Intentional W-unit shell |
| `work/W3-LANDSCAPE-README.md` | 3 | "Placeholder — execution not yet started" | Intentional W-unit shell |
| `work/W4-WORKFLOW-HARDENING-README.md` | 3 | "Placeholder — execution not yet started" | Intentional W-unit shell |

All "placeholder" occurrences are intentional scaffold-state markers per the architecture and implementation spec. No TODO, FIXME, HACK, XXX, or TBD markers found in project-owned files. The `pipeline/` files (architecture.md, implementation-spec.md, etc.) contain additional "placeholder" text but these are pipeline documentation files describing scaffold design, not markers indicating incomplete work.

Section summary: 0 issues flagged (all markers are intentional scaffold-state labels) / no previous audit

### 6.3 Empty files, stub files, or files containing only boilerplate

| File | Lines | State |
|---|---|---|
| `logs/decisions.md` | 10 | Intentional stub: contains header, column definitions, and an empty table with one instructional note. Per implementation spec operation 15, this is the designed scaffold-time state. |
| `pipeline/decisions.md` | 11 | Contains 7 rows of actual decision data from pipeline stages 1–3c. Not empty or stub. |
| `workflow-artifacts/` | — | Empty directory. Per architecture §5 W4, this is the designed state: "Pre-created so the directory exists when W4 starts; W4 child cycle populates contents." |

`logs/decisions.md` is a stub by design. `workflow-artifacts/` is an intentionally empty directory by design. No other files are empty or contain only boilerplate without real content.

Section summary: 0 issues flagged (empty/stub items are by design) / no previous audit

---

## Summary of All Issues

| # | Section | Issue | Type |
|---|---|---|---|
| F-1 | 2.2, 2.4, 2.5, 4.5 | `.claude/settings.local.json` does not exist. CLAUDE.md line 81 instructs setting `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1` in this file. Architecture §2 describes it as existing. Implementation spec §1 defers creation to "post-pipeline enrichment." The enrichment step was never completed for this file. | Missing item |
| F-2 | 2.6 | `## Input File Handling` (lines 83–95, 13 lines) is a verbatim copy of a canonical workspace rule, which workspace CLAUDE.md § CLAUDE.md Scoping names as prohibited ("verbatim duplication is not" acceptable). The section self-identifies as a duplicate. | Violation |
| F-3 | 2.6 | `## Commit Rules` (lines 96–103, 8 lines) is a verbatim copy of the canonical `Commit behavior` section from workspace CLAUDE.md. Same prohibition applies. The section self-identifies as a duplicate. | Violation |
| F-4 | 2.6 | `## Compaction` (lines 104–114, 11 lines) duplicates workspace compaction protocol content. | Violation |
| F-5 | 2.6 | `## Session Boundaries` (lines 115–117, 3 lines) duplicates a canonical workspace behavioral rule. | Violation |
| F-6 | 4.8 | `fading-gate-scanner` agent (declared tier: haiku) is deployed via symlink in this project but is absent from `ai-resources/docs/agent-tier-table.md`. | Discrepancy |
| F-7 | 4.8 | `fix-repo-issues-scanner` agent (declared tier: sonnet) is deployed via symlink in this project but is absent from `ai-resources/docs/agent-tier-table.md`. | Discrepancy |
| F-8 | 4.8 | `friday-act-16a-summarizer` agent (declared tier: sonnet) is deployed via symlink in this project but is absent from `ai-resources/docs/agent-tier-table.md`. | Discrepancy |

**Informational observations (not findings):**

| # | Observation |
|---|---|
| I-1 | `pipeline/repo-snapshot.md` states "63 commands" and "29 agents" in ai-resources. The actual count at the stated commit (460d43b) was 64 commands and 30 agents. The repo-snapshot document has incorrect counts (off by 1 each). The project symlink count (62 commands, 24 agents) reflects the baked-in exclusions in `auto-sync-shared.sh`. |
| I-2 | `auto-sync-shared.sh` baked-in exclusions intentionally omit `new-project` and `deploy-workflow` from commands and `pipeline-stage-*` and `session-guide-generator` from agents. These are expected absences, not errors. |
| I-3 | No `.claude/hooks/` directory exists. Hooks beyond the two SessionStart entries in `settings.json` are not locally registered in this project. The architecture notes most hooks are "inherited" via ai-resources settings (active when sessions open from the ai-resources root). |
| I-4 | GitHub remote recorded as `https://github.com/axcion-ai/nordic-pe-screening-project` in `pipeline/decisions.md` #7 and `pipeline/pipeline-state.md`. No `git push` has been performed; this is consistent with workspace autonomy rules. |
| I-5 | Planning slug (`nordic-pe-screening-program`) differs from live project slug (`nordic-pe-screening-project`). The deviation is documented in `pipeline/sources.md` and `pipeline/decisions.md` #1. |

**Counts by type:**
- Discrepancies: 3 (F-6, F-7, F-8)
- Missing items: 1 (F-1)
- Violations: 4 (F-2, F-3, F-4, F-5)
- Clean checks: 40+
