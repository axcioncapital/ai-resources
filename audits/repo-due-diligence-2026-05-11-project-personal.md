# Repo Due Diligence Audit — 2026-05-11
Repo: projects/personal
Scope: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/personal
Commit: d8e2631
Previous audit: None

---

## Section 1: Inventory

### 1.1 Slash Commands

**Project-local commands (2 — non-symlink):**

| Name | File | References |
|---|---|---|
| `/destination-dossier` | `.claude/commands/destination-dossier.md` (94 lines) | `dossier-orchestrator` agent; `projects/personal/trips/{slug}/trip-context.md` (runtime); `profile/universal-traveler-profile.md`; `profile/travel-principles.md`; `logs/dossier-runs.md` |
| `/trip-init` | `.claude/commands/trip-init.md` (120 lines) | Creates `trips/{slug}/trip-context.md`, `trips/{slug}/journal.md`, `trips/{slug}/dossier/` |

**Shared commands (54 — symlinks to ai-resources/.claude/commands/):**

All 54 are symlinked from `ai-resources/.claude/commands/`. Named (all present and resolvable): `analyze-workflow`, `architecture-review`, `audit-claude-md`, `audit-critical-resources`, `audit-repo`, `clarify`, `cleanup-worktree`, `coach`, `consult`, `create-skill`, `deploy-kb`, `explain`, `friction-log`, `friday-act`, `friday-checkup`, `friday-journal`, `friday-so`, `graduate-resource`, `implementation-triage`, `improve`, `improve-skill`, `innovation-sweep`, `log-sweep`, `migrate-skill`, `monday-prep`, `note`, `open-items`, `permission-sweep`, `prime`, `project-consultant`, `qc-pass`, `recommend`, `refinement-deep`, `refinement-pass`, `repo-dd`, `request-skill`, `resolve`, `resolve-improvement-log`, `risk-check`, `route-change`, `save-session`, `scope`, `session-guide`, `session-plan`, `session-start`, `so-monthly`, `summary`, `sync-workflow`, `systems-review`, `token-audit`, `triage`, `update-claude-md`, `usage-analysis`, `wrap-session`.

Total commands: 56 (2 local, 54 symlinks).

---

### 1.2 Hooks

**Configured in `.claude/settings.json` — two `SessionStart` hooks:**

| Trigger | What it does | Files referenced |
|---|---|---|
| `SessionStart` | Auto-sync: walks up from `$CLAUDE_PROJECT_DIR` to find `ai-resources/.claude/hooks/auto-sync-shared.sh` and executes it (timeout 10s). Status message: "Syncing shared commands from ai-resources..." | `ai-resources/.claude/hooks/auto-sync-shared.sh` |
| `SessionStart` | Permission sanity check: walks up from `$CLAUDE_PROJECT_DIR` to find `ai-resources/.claude/hooks/check-permission-sanity.sh` and executes it (timeout 5s). Status message: "Permission sanity check..." | `ai-resources/.claude/hooks/check-permission-sanity.sh` |

Both hook scripts exist at their expected paths (`ai-resources/.claude/hooks/auto-sync-shared.sh` — verified accessible; `ai-resources/.claude/hooks/check-permission-sanity.sh` — verified accessible).

No `.claude/settings.local.json` exists in `projects/personal/` (gitignored per workspace `.gitignore`; section "Model Selection" in CLAUDE.md notes each operator applies it manually).

---

### 1.3 Template Files

| File | Purpose | Used By | Last Commit Date |
|---|---|---|---|
| `references/dossier-template.md` (189 lines) | Output structure spec for destination dossier — 8 sections, mobile formatting rules, versioning rules | `dossier-orchestrator` agent (Phase D, Step 7); also read by `references/dossier-workflow.md` as input | 2026-05-11 |
| `references/dossier-workflow.md` (179 lines) | Workflow contract for `/destination-dossier` — sequence, halt conditions, step-by-step procedure | `dossier-orchestrator` agent (Phase A, Step 1); also read by `references/dossier-template.md` as co-input | 2026-05-11 |
| `references/subagent-prompts.md` (348 lines) | Eight handoff prompt templates (one per dossier section) for ChatGPT Pro / Perplexity Pro | `dossier-orchestrator` agent (Phase A, Step 3) | 2026-05-11 |

Three template files total. No other template files found.

---

### 1.4 Scripts

No bash, Python, or other scripts found anywhere under `projects/personal/`. None found — checked with `find` for `*.sh` and `*.py` across the full AUDIT_ROOT.

---

### 1.5 Skills

No `skills/` directory exists under `projects/personal/`. Zero skills in scope.

N/A — no skills present. Q4.3 is not applicable: No skill creation template file exists. Skills are created via `/create-skill` which references ai-resource-builder/SKILL.md for format standards.

---

### 1.6 Uncategorized Files

| File | Description |
|---|---|
| `logs/session-notes.md` | Session journal; appended by `/wrap-session` and `/prime` |
| `logs/decisions.md` | Decision log; one entry (D7) |
| `logs/dossier-runs.md` | Append-only run log for `/destination-dossier`; currently empty (no runs yet) |
| `logs/innovation-registry.md` | Innovation registry table; currently empty (header row only) |
| `logs/session-plan.md` | Current session plan (untracked); 2026-05-11 |
| `pipeline/architecture.md` (458 lines) | Architecture document from `/new-project` pipeline stage 3b |
| `pipeline/context-pack.md` (142 lines) | Context pack from `/new-project` pipeline input |
| `pipeline/decisions.md` (5 lines) | Pipeline decisions table; one entry |
| `pipeline/implementation-log.md` (126 lines) | Implementation log from pipeline stage 4 |
| `pipeline/implementation-spec.md` (1261 lines) | Implementation spec from pipeline stage 3c |
| `pipeline/pipeline-state.md` (15 lines) | Pipeline-stage tracker; all 6 stages completed |
| `pipeline/project-plan.md` (156 lines) | Project plan from planning input |
| `pipeline/repo-snapshot.md` (425 lines) | Repo snapshot from pipeline stage 3a |
| `pipeline/sources.md` (9 lines) | Input provenance record for pipeline |
| `pipeline/technical-spec.md` (136 lines) | Technical spec from planning input |
| `pipeline/test-results.md` (137 lines) | Test results from pipeline stage 5 |
| `profile/universal-traveler-profile.md` (301 lines) | Traveler profile v1; populated 2026-05-11 |
| `profile/travel-principles.md` (444 lines) | Travel principles v3; populated 2026-05-11 |
| `red-team.md` (83 lines) | Red-team log for the travel planning system; partially populated (Phase 2 and Phase 3 have entries; Phases 1, 4, 5, 6, Cross-Cutting are empty placeholder sections) |
| `session-guide.md` (206 lines) | Session guide generated at pipeline stage 6 |
| `.claude/shared-manifest.json` (5 lines) | Lists project-local commands and agents for auto-sync hook |
| `.claude/settings.json` (60 lines) | Project permissions and hooks configuration (currently untracked — see Q6.2 below) |
| `CLAUDE.md` (93 lines) | Project persistent context |
| `trips/` | Empty directory (no trips scaffolded yet) |
| `outputs/` | Empty directory (placeholder for future dossier outputs) |

---

### 1.7 Symlinks

**`.claude/agents/` — 21 symlinks (all to ai-resources/.claude/agents/):**

| Symlink | Target | Target Exists |
|---|---|---|
| `claude-md-auditor.md` | `.../ai-resources/.claude/agents/claude-md-auditor.md` | Yes |
| `collaboration-coach.md` | `.../ai-resources/.claude/agents/collaboration-coach.md` | Yes |
| `critical-resource-auditor.md` | `.../ai-resources/.claude/agents/critical-resource-auditor.md` | Yes |
| `dd-extract-agent.md` | `.../ai-resources/.claude/agents/dd-extract-agent.md` | Yes |
| `dd-log-sweep-agent.md` | `.../ai-resources/.claude/agents/dd-log-sweep-agent.md` | Yes |
| `execution-agent.md` | `.../ai-resources/.claude/agents/execution-agent.md` | Yes |
| `findings-extractor.md` | `.../ai-resources/.claude/agents/findings-extractor.md` | Yes |
| `improvement-analyst.md` | `.../ai-resources/.claude/agents/improvement-analyst.md` | Yes |
| `innovation-triage-auditor.md` | `.../ai-resources/.claude/agents/innovation-triage-auditor.md` | Yes |
| `log-sweep-auditor.md` | `.../ai-resources/.claude/agents/log-sweep-auditor.md` | Yes |
| `permission-sweep-auditor.md` | `.../ai-resources/.claude/agents/permission-sweep-auditor.md` | Yes |
| `qc-reviewer.md` | `.../ai-resources/.claude/agents/qc-reviewer.md` | Yes |
| `refinement-reviewer.md` | `.../ai-resources/.claude/agents/refinement-reviewer.md` | Yes |
| `repo-dd-auditor.md` | `.../ai-resources/.claude/agents/repo-dd-auditor.md` | Yes |
| `risk-check-reviewer.md` | `.../ai-resources/.claude/agents/risk-check-reviewer.md` | Yes |
| `system-owner.md` | `.../ai-resources/.claude/agents/system-owner.md` | Yes |
| `token-audit-auditor-mechanical.md` | `.../ai-resources/.claude/agents/token-audit-auditor-mechanical.md` | Yes |
| `token-audit-auditor.md` | `.../ai-resources/.claude/agents/token-audit-auditor.md` | Yes |
| `triage-reviewer.md` | `.../ai-resources/.claude/agents/triage-reviewer.md` | Yes |
| `workflow-analysis-agent.md` | `.../ai-resources/.claude/agents/workflow-analysis-agent.md` | Yes |
| `workflow-critique-agent.md` | `.../ai-resources/.claude/agents/workflow-critique-agent.md` | Yes |

**`.claude/commands/` — 54 symlinks (all to ai-resources/.claude/commands/):**

All 54 command symlinks resolve successfully to existing targets (verified above in Q1.1). Targets reside under `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/`.

No broken symlinks found — all 75 symlinks (21 agents + 54 commands) are accessible.

Section summary: 106 items catalogued / no previous audit for delta.

---

## Section 2: CLAUDE.md Health

### 2.1 CLAUDE.md Size and Sections

Line count: 93 lines. Distinct sections: 12.

Section headings:
1. `## Personalization Spine Gate` (line 5)
2. `## Phase Gating` (line 14)
3. `## Output Standards` (line 20)
4. `## Hard Constraints` (line 29)
5. `## Subagent Delegation Default` (line 37)
6. `## Model Selection` (line 41)
7. `## Input File Handling` (line 45)
8. `## Commit Rules` (line 58)
9. `## Compaction` (line 66)
10. `## Session Boundaries` (line 77)
11. `## Workflow References` (line 81)
12. `## Trip Directory Convention` (line 91)

---

### 2.2 Dead References in CLAUDE.md

| Reference | Exists? | Notes |
|---|---|---|
| `profile/universal-traveler-profile.md` | Yes | 301 lines, populated 2026-05-11 |
| `profile/travel-principles.md` | Yes | 444 lines, populated 2026-05-11 |
| `references/dossier-workflow.md` | Yes | 179 lines |
| `references/dossier-template.md` | Yes | 189 lines |
| `references/subagent-prompts.md` | Yes | 348 lines |
| `dossier-orchestrator` agent | Yes | `.claude/agents/dossier-orchestrator.md` exists |
| `/daily-program` command | No | Mentioned as a future command in "Workflow References" ("Future commands (`/daily-program`, `/tomorrow-spar`) will add parallel reference files under `references/`"). Neither command file exists. Not claimed to exist — explicitly labeled "Future." |
| `/tomorrow-spar` command | No | Same as above — explicitly labeled "Future." |
| `.claude/settings.local.json` | Not present on disk | Referenced in "Model Selection" as the location for the model default; CLAUDE.md correctly notes it is gitignored and must be applied per-machine. Absence is expected behavior. |
| `trips/{slug}/` convention | No trips exist yet | `trips/` directory is present and empty. Convention is correct; no trips have been initialized. |

Two references (`/daily-program`, `/tomorrow-spar`) point to non-existent commands, but both are explicitly marked as "Future" in CLAUDE.md — not implicit gaps.

---

### 2.3 Contradictions in CLAUDE.md

None found — checked all 12 sections for conflicting statements. The "Model Selection" section notes the default model is declared in `.claude/settings.local.json` but also that this file is gitignored; no contradiction (the absence is expected and documented).

---

### 2.4 Conventions Defined But Not Followed

| Convention | Convention Source | Compliance Status |
|---|---|---|
| Trip directory slug format `{destination-kebab}-{YYYY-MM}` | "Trip Directory Convention" (line 91) | No trips created yet; directory convention is defined but untested. `trips/` directory exists and is empty. No violation. |
| Per-trip layout: `trip-context.md`, `destination-dossier.md`, `dossier/`, `journal.md` | "Trip Directory Convention" | No trips created yet. No violation. |
| Phase transitions require Patrik's explicit approval | "Phase Gating" | Phase 0 is complete. Phase 1 has not been started. No violation observed. |
| Profile and principles updated only via Phase 3 retro workflow | "Phase Gating" | Both files are at v1/v3 initial population (operator-pasted). No ad-hoc update detected. No violation. |

None found — checked conventions against actual files. No violations.

---

### 2.5 Partially-Satisfied Features

| Feature | What Exists | What Is Missing |
|---|---|---|
| "Workflow References" — dossier workflow via three reference files | All three files exist: `references/dossier-workflow.md`, `references/dossier-template.md`, `references/subagent-prompts.md` | Nothing missing for the current Phase 1 scope. |
| "Workflow References" — "Future commands (`/daily-program`, `/tomorrow-spar`) will add parallel reference files under `references/`" | `references/` directory exists; three current reference files are present | `/daily-program` command, `/tomorrow-spar` command, and their corresponding `references/` files do not exist. Labeled "Future" in CLAUDE.md. |
| `dossier-orchestrator` agent writes to `projects/personal/outputs/` | `outputs/` directory exists as empty placeholder | No trips run yet; no outputs produced. The empty directory is the correct pre-run state. |

One feature is partially satisfied: the "Future commands" mention in CLAUDE.md names two commands and their reference files that do not yet exist. This is by design.

---

### 2.6 CLAUDE.md Scoping Violations

The workspace CLAUDE.md `## CLAUDE.md Scoping` rule states: "Do not put in project CLAUDE.md: Skill methodology (belongs in SKILL.md); Workflow methodology (belongs in workflow reference docs); Canonical workspace rules (short pointer acceptable, verbatim duplication not)."

| Section | Line Count (approx.) | Task-Type | Violation Status |
|---|---|---|---|
| `## Input File Handling` | 12 lines of rules | File-handling methodology | Verbatim duplication of canonical workspace CLAUDE.md section. The section itself acknowledges: "This rule mirrors the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded." This is a declared duplication, not an inadvertent one. Per scoping rule, a "short pointer is acceptable; verbatim duplication is not." |
| `## Commit Rules` | 5 lines of rules | Commit methodology | Verbatim duplication of canonical workspace CLAUDE.md section. Same acknowledgment: "This rule mirrors the canonical `Commit behavior` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded." |
| `## Compaction` | 9 lines | Compaction methodology | Content mirrors workspace-level compaction guidance. No explicit "mirrors" acknowledgment in this section, but content is project-specific enough (references session-notes.md, decisions.md, which are project files). Borderline — not a clear violation. |

Two sections (`Input File Handling`, `Commit Rules`) are verbatim duplications of canonical workspace CLAUDE.md content. Both sections self-declare this duplication with a rationale (projects sometimes opened without parent workspace context).

Section summary: 3 issues flagged / no previous audit for delta.

---

## Section 3: Dependency References

### 3.1 File References Per Command

**Project-local commands:**

| Command | Referenced File | File Exists |
|---|---|---|
| `/destination-dossier` | `dossier-orchestrator` agent (`.claude/agents/dossier-orchestrator.md`) | Yes |
| `/destination-dossier` | `projects/personal/trips/{slug}/trip-context.md` (runtime path) | N/A — runtime |
| `/destination-dossier` | `projects/personal/profile/universal-traveler-profile.md` | Yes |
| `/destination-dossier` | `projects/personal/profile/travel-principles.md` | Yes |
| `/destination-dossier` | `projects/personal/logs/dossier-runs.md` (output append) | Yes |
| `/trip-init` | `projects/personal/trips/{slug}/trip-context.md` (creates at runtime) | N/A — creates |
| `/trip-init` | `projects/personal/trips/{slug}/journal.md` (creates at runtime) | N/A — creates |
| `/trip-init` | `projects/personal/trips/{slug}/dossier/` (creates at runtime) | N/A — creates |

**`dossier-orchestrator` agent referenced files:**

| Referenced File | File Exists |
|---|---|
| `projects/personal/references/dossier-workflow.md` | Yes |
| `projects/personal/references/dossier-template.md` | Yes |
| `projects/personal/references/subagent-prompts.md` | Yes |
| `projects/personal/profile/universal-traveler-profile.md` | Yes |
| `projects/personal/profile/travel-principles.md` | Yes |
| `projects/personal/trips/{slug}/trip-context.md` | N/A — runtime |
| `projects/personal/logs/dossier-runs.md` | Yes |
| `projects/personal/trips/{slug}/destination-dossier.md` | N/A — creates at runtime |
| `projects/personal/outputs/` | Exists as empty directory |
| `projects/personal/pipeline/decisions.md` | Yes |

All statically-resolvable references resolve. Shared (symlinked) commands are not re-analyzed here — their internal references point to ai-resources infrastructure out of scope for this audit.

---

### 3.2 Output → Input Chains

| Producing Command | Output | Consuming Command |
|---|---|---|
| `/trip-init` | `trips/{slug}/trip-context.md` | `/destination-dossier` (required input — fails Halt 2 without it) |
| `/destination-dossier` → `dossier-orchestrator` | `trips/{slug}/destination-dossier.md` | Future Phase 3 retro workflow (not yet implemented) |
| `/destination-dossier` → `dossier-orchestrator` | `logs/dossier-runs.md` append | Future Phase 3 retro workflow (not yet implemented) |

One active chain: `/trip-init` → `/destination-dossier`. The two-command pipeline is the only operative chain at Phase 1.

---

### 3.3 Files Referenced by Multiple Commands/Agents

| File | Referenced By |
|---|---|
| `profile/universal-traveler-profile.md` | `/destination-dossier` (pre-check, Step 2); `dossier-orchestrator` agent (Phase B gate); `references/dossier-workflow.md` (input spec); `CLAUDE.md` § Personalization Spine Gate |
| `profile/travel-principles.md` | Same as above — identical reference set |
| `references/dossier-workflow.md` | `dossier-orchestrator` agent (Phase A, Step 1); CLAUDE.md § Workflow References |
| `references/dossier-template.md` | `dossier-orchestrator` agent (Phase A, Step 2); CLAUDE.md § Workflow References |
| `references/subagent-prompts.md` | `dossier-orchestrator` agent (Phase A, Step 3); CLAUDE.md § Workflow References |
| `logs/dossier-runs.md` | `dossier-orchestrator` agent (Step 9 — appends); `references/dossier-workflow.md` (Step 9 spec) |
| `pipeline/decisions.md` | `dossier-orchestrator` agent (references D7); `references/dossier-workflow.md` (references D7 via Step 6) |

---

### 3.4 Files Ranked by Downstream References (Top 10)

| Rank | File | Reference Count | Referenced By |
|---|---|---|---|
| 1 | `profile/universal-traveler-profile.md` | 4 | `/destination-dossier` (pre-check), `dossier-orchestrator` agent (Phase B), `references/dossier-workflow.md` (input spec), CLAUDE.md |
| 1 | `profile/travel-principles.md` | 4 | Same as above |
| 3 | `references/dossier-workflow.md` | 2 | `dossier-orchestrator` agent, CLAUDE.md |
| 3 | `references/dossier-template.md` | 2 | `dossier-orchestrator` agent, CLAUDE.md |
| 3 | `references/subagent-prompts.md` | 2 | `dossier-orchestrator` agent, CLAUDE.md |
| 3 | `logs/dossier-runs.md` | 2 | `dossier-orchestrator` agent (writes), `references/dossier-workflow.md` (spec) |
| 3 | `pipeline/decisions.md` | 2 | `dossier-orchestrator` agent, `references/dossier-workflow.md` |
| 8 | `trips/{slug}/trip-context.md` | 2 | `/trip-init` (creates), `/destination-dossier` + `dossier-orchestrator` (reads) |
| 9 | `CLAUDE.md` | 1 | Referenced by all commands for project context |
| 10 | `.claude/settings.json` | 1 | Referenced by hooks in settings themselves |

(Shared/symlinked commands not included in reference counts — their internal references are out of scope for this audit.)

---

### 3.5 Symlink Coverage Check (permissions.additionalDirectories)

`projects/personal/.claude/settings.json` declares `permissions.additionalDirectories` containing one entry:
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`

All 21 agent symlinks and 54 command symlinks resolve to targets under `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/`. This path is a descendant of the listed `additionalDirectories` entry (string-prefix match: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` is an ancestor of `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/`).

None found — all 75 symlink targets are covered by the `additionalDirectories` entry.

---

### 3.6 ai-resources References Without additionalDirectories Coverage

`projects/personal` references `ai-resources/` via:
1. CLAUDE.md (workspace-loaded context mentioning ai-resources paths)
2. 75 symlinks in `.claude/commands/` and `.claude/agents/` pointing into ai-resources
3. Two SessionStart hooks that walk up to find `ai-resources/.claude/hooks/`

The workspace root `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` is listed in `permissions.additionalDirectories`. This covers ai-resources (a subdirectory of the workspace root).

None found — no uncovered ai-resources references.

Section summary: 0 issues flagged / no previous audit for delta.

---

## Section 4: Consistency Checks

### 4.1 Skills Structural Pattern

N/A — No skills exist in `projects/personal/`.

---

### 4.2 Slash Command Definition Pattern

All project-local commands use YAML frontmatter with `model:` and optional `description:` fields. Both follow the same pattern as shared commands.

| Command | Has `model:` | Has `description:` | Has YAML frontmatter |
|---|---|---|---|
| `destination-dossier.md` | Yes (`model: opus`) | Yes | Yes |
| `trip-init.md` | Yes (`model: sonnet`) | Yes | Yes |

The two project-local commands follow the same definition pattern as the 54 shared commands. No deviations found.

---

### 4.3 Skill Template Comparison

N/A — No skill creation template file exists. Skills are created via /create-skill which references ai-resource-builder/SKILL.md for format standards.

---

### 4.4 Naming Convention Inconsistencies

Files checked: commands, agents, logs, pipeline files, profile files, references.

| Item | Convention | Status |
|---|---|---|
| All command files | `kebab-case.md` | Consistent across all 56 |
| All agent files | `kebab-case.md` | Consistent across all 22 |
| Log files | `kebab-case.md` | Consistent: `session-notes.md`, `decisions.md`, `dossier-runs.md`, `innovation-registry.md`, `session-plan.md` |
| Pipeline files | `kebab-case.md` | Consistent |
| Profile files | `kebab-case.md` | Consistent |
| Reference files | `kebab-case.md` | Consistent |

None found — naming convention is consistent across the project.

---

### 4.5 Directory Structure Pattern Violations

CLAUDE.md "Trip Directory Convention" defines: `trips/{slug}/` with `trip-context.md`, `destination-dossier.md`, `dossier/`, `journal.md`. No trips have been created, so no violations are possible yet.

Other directories present: `logs/`, `pipeline/`, `profile/`, `references/`, `outputs/`, `trips/` (empty), `.claude/commands/`, `.claude/agents/`. All match the architecture defined in `pipeline/architecture.md`.

None found — directory structure matches declared architecture.

---

### 4.6 Command Syntax and Path Resolution Failures

| Command | Syntax Valid | All Referenced Paths Resolve |
|---|---|---|
| `/destination-dossier` | Yes (YAML frontmatter + steps) | Yes — static paths resolve; runtime paths (`trips/{slug}/`) do not need to pre-exist |
| `/trip-init` | Yes | Yes — creates paths at runtime; no pre-existing files required |

No failures found.

---

### 4.7 Duplicate or Built-in Name Conflicts

Checked all 56 command names against known Claude Code built-in commands (`/doctor`, `/help`, `/init`, `/login`, `/logout`, `/model`, `/permissions`, `/pr-comments`, `/review`, `/status`, `/terminal-setup`, `/vim`).

None found — no duplicates, no conflicts with built-in commands.

---

### 4.8 Agent Tier Declarations vs. Agent Tier Table

**Project-local agent (not in ai-resources tier table):**

| Agent File | Declared `model:` | In Tier Table | Status |
|---|---|---|---|
| `dossier-orchestrator.md` | `sonnet` | No — project-local, not in `ai-resources/docs/agent-tier-table.md` | Missing from table — project-local agent |

**Shared agents (symlinks to ai-resources — tier verified against table):**

All 21 shared agents are symlinks to ai-resources. Their declared tiers and tier table entries were compared. All match the table:

| Agent | Declared tier | Table tier | Match |
|---|---|---|---|
| `claude-md-auditor` | opus | opus | Yes |
| `collaboration-coach` | opus | opus | Yes |
| `critical-resource-auditor` | opus | opus | Yes |
| `dd-extract-agent` | haiku | haiku | Yes |
| `dd-log-sweep-agent` | haiku | haiku | Yes |
| `execution-agent` | sonnet | sonnet | Yes |
| `findings-extractor` | haiku | haiku | Yes |
| `improvement-analyst` | opus | opus | Yes |
| `innovation-triage-auditor` | opus | opus | Yes |
| `log-sweep-auditor` | haiku | Not in table | Missing from table — exists in ai-resources but no table entry |
| `permission-sweep-auditor` | sonnet | sonnet | Yes |
| `qc-reviewer` | opus | opus | Yes |
| `refinement-reviewer` | opus | opus | Yes |
| `repo-dd-auditor` | sonnet | sonnet | Yes |
| `risk-check-reviewer` | opus | opus | Yes |
| `system-owner` | opus | opus | Yes |
| `token-audit-auditor-mechanical` | haiku | haiku | Yes |
| `token-audit-auditor` | opus | opus | Yes |
| `triage-reviewer` | opus | opus | Yes |
| `workflow-analysis-agent` | opus | opus | Yes |
| `workflow-critique-agent` | opus | opus | Yes |

Two agents are not in the tier table:
1. `dossier-orchestrator` — project-local agent, deliberately not in the shared table (expected).
2. `log-sweep-auditor` — exists in `ai-resources/.claude/agents/` and is symlinked here, but absent from `ai-resources/docs/agent-tier-table.md`. Declared tier: haiku. Table tier: missing.

---

### 4.9 Project settings.json vs. Canonical Baseline

Canonical baseline from `ai-resources/.claude/commands/new-project.md` (CANONICAL_PERMS block, line 310):

**Deny entries required:**
- `Bash(git push*)` — Present in `projects/personal/.claude/settings.json`
- `Bash(rm -rf *)` — Present
- `Bash(sudo *)` — Present
- `Read(archive/**)` — Present
- `Read(**/*.archive.*)` — Present
- `Read(**/deprecated/**)` — Present
- `Read(**/old/**)` — Present

All 7 canonical deny entries are present. No missing deny entries.

**Top-level `model: sonnet` declaration:**

The canonical baseline (`new-project.md` line ~179 region) specifies a `"model": "sonnet"` top-level default. `projects/personal/.claude/settings.json` does NOT declare a top-level `model` key. `TOP-LEVEL MODEL: NOT SET` (verified via `python3` parse).

This is a discrepancy — the canonical baseline includes `"model": "sonnet"` at the top level; the project settings.json omits it. However, CLAUDE.md "Model Selection" states the default is `claude-sonnet-4-6[1m]` set in `.claude/settings.local.json` (gitignored, per-machine). The 1M variant cannot be expressed as `"sonnet"` at the top level — the distinction may be intentional.

**Commit dates:**

| File | Most Recent Commit |
|---|---|
| `projects/personal/.claude/settings.json` | Untracked — no git commit date (not yet in version control) |
| `ai-resources/.claude/commands/new-project.md` (CANONICAL_PERMS block) | Most recent commit touching `new-project.md` was not retrievable via `git log` in the current session |

`projects/personal/.claude/settings.json` is currently untracked in git (confirmed via `git ls-files` and `git status`). It exists on disk but has no commit date.

Section summary: 3 issues flagged (log-sweep-auditor missing from tier table; settings.json missing top-level `model` key; settings.json untracked in git) / no previous audit for delta.

---

## Section 5: Context Load

### 5.1 Total Context at Session Start

Files auto-loaded at every session:

| File | Lines | Notes |
|---|---|---|
| `projects/personal/CLAUDE.md` | 93 | Always loaded by Claude Code for project context |
| Workspace `CLAUDE.md` (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md`) | ~69 | Loaded when workspace is in context (out of scope but adds to actual load) |

Within `projects/personal/` scope only: **93 lines** of always-loaded CLAUDE.md.

No auto-read files beyond CLAUDE.md are loaded at session start. The two SessionStart hooks run scripts (not file reads); they produce no direct context injection. No `@` references in CLAUDE.md (it does not `@`-include any other files).

Estimated total context (project-scoped): approximately 93 lines.

---

### 5.2 CLAUDE.md Sections Not Referenced Elsewhere

| Section | Line Count (approx.) | Referenced by Commands/Hooks/Operations? |
|---|---|---|
| `## Personalization Spine Gate` | 6 lines | Yes — referenced by `/destination-dossier` (Step 2 abort message), `dossier-orchestrator` agent (Phase B), `references/dossier-workflow.md` (Halt 1) |
| `## Phase Gating` | 4 lines | Referenced by `dossier-orchestrator` agent implicitly (Phase transitions); no direct command reference |
| `## Output Standards` | 7 lines | Referenced by `references/dossier-template.md` (mobile formatting rules repeat these standards); no direct command invoke |
| `## Hard Constraints` | 6 lines | Referenced by profile/principles gate logic and `references/dossier-workflow.md` (weather ceiling) |
| `## Subagent Delegation Default` | 2 lines | Referenced by `dossier-orchestrator` agent (explicit mention of "Mode 1 only at Phase 1") |
| `## Model Selection` | 3 lines | Referenced in architecture.md (Decision 4); no direct command reference |
| `## Input File Handling` | 12 lines | No direct command reference — applies to all file operations in the project |
| `## Commit Rules` | 5 lines | No direct command reference — applies to all commit operations |
| `## Compaction` | 9 lines | No direct command reference — applies to all `/compact` events |
| `## Session Boundaries` | 2 lines | No direct command reference — applies to all `/clear` events |
| `## Workflow References` | 7 lines | Read by `dossier-orchestrator` agent (Phase A) and `/destination-dossier` (Step 3) indirectly |
| `## Trip Directory Convention` | 3 lines | Referenced by `/trip-init` (Step 2 slug generation) and `/destination-dossier` (Step 1 glob) |

Sections with no direct slash-command or hook references: `Phase Gating`, `Output Standards`, `Hard Constraints`, `Model Selection`, `Input File Handling`, `Commit Rules`, `Compaction`, `Session Boundaries`. These are behavioral rules that apply to the session rather than being invoked by name — none are dead weight.

None found — all 12 sections apply to active behavior, even if not directly invoked by a command name.

---

### 5.3 CLAUDE.md Line Count at Last 5 Commits

Only one commit has touched `projects/personal/CLAUDE.md` (the project was created on 2026-05-11):

| Date | Commit Hash | Line Count | Commit Message |
|---|---|---|---|
| 2026-05-11 | `2ab4307` | 93 | `feat(personal): implement Phase 1 destination-dossier workflow` |

Fewer than 5 commits exist for CLAUDE.md — only 1 recorded commit.

Section summary: 0 issues flagged / no previous audit for delta.

---

## Section 6: Drift and Staleness

### 6.1 Files Not Modified in 90 Days But Still Referenced

All files in `projects/personal/` were created on 2026-05-11 (today's date is 2026-05-11). No files are older than 90 days. None found — all files created within the last 1 day.

---

### 6.2 TODO / FIXME / PLACEHOLDER Markers

| File | Line | Marker | Content |
|---|---|---|---|
| `pipeline/repo-snapshot.md` | 58 | `EMPTY PLACEHOLDER` | `projects/personal/profile/universal-traveler-profile.md — EMPTY PLACEHOLDER` |
| `pipeline/repo-snapshot.md` | 59 | `EMPTY PLACEHOLDER` | `projects/personal/profile/travel-principles.md — EMPTY PLACEHOLDER` |

Both markers are in `pipeline/repo-snapshot.md`, which is a historical artifact (captured at pipeline stage 3a before the profile files were populated). The profile files are now populated (301 and 444 lines respectively). The markers in `repo-snapshot.md` reflect the state at the time the snapshot was taken — the snapshot is not a live document.

No TODO, FIXME, or PLACEHOLDER markers found in: `references/`, `logs/`, `profile/`, `CLAUDE.md`, `.claude/commands/`, `.claude/agents/`, `red-team.md`, `session-guide.md`.

2 marker instances found — both in a historical pipeline artifact (`pipeline/repo-snapshot.md`).

---

### 6.3 Empty, Stub, or Boilerplate-Only Files

| File | Lines | Status |
|---|---|---|
| `logs/innovation-registry.md` | 4 | Stub — contains header row only (`# Innovation Registry` + table header + empty table). No data rows. Expected state at project start. |
| `logs/dossier-runs.md` | 47 | Initialized but contains no run entries. Has a format spec header and empty "## Runs" section. Expected state — no trips have been run yet. |
| `pipeline/decisions.md` | 5 | One decision row (D7). Not empty but minimal. |
| `red-team.md` | 83 | Partially populated — Phase 2 and Phase 3 have entries with real content; Phases 1, 4, 5, 6, and Cross-Cutting contain section headers with HTML comment placeholders and no entries. |
| `trips/` | — | Empty directory. Expected pre-trip state. |
| `outputs/` | — | Empty directory. Expected pre-trip state. |

Files that are empty or stub-only by design (expected pre-operational state):
- `logs/innovation-registry.md` — header-only table, expected at project start
- `logs/dossier-runs.md` — initialized with format spec, no runs yet
- `red-team.md` — 4 of 8 phase sections are placeholders (Phases 1, 4, 5, 6, Cross-Cutting have only the `## ` header and an HTML comment, no entries)

Additional untracked files that exist on disk but are not in git:
- `projects/personal/.claude/settings.json` — present on disk, not tracked in git
- `projects/personal/logs/session-plan.md` — present on disk, not tracked in git
- All 21 agent symlinks and 54 command symlinks under `.claude/` — present on disk, not tracked in git (the symlinks themselves are untracked; their targets are tracked in ai-resources)
- Multiple `pipeline/` files: `architecture.md`, `context-pack.md`, `decisions.md`, `implementation-spec.md`, `project-plan.md`, `repo-snapshot.md`, `sources.md`, `technical-spec.md` — present on disk, not tracked in git

The untracked state of `.claude/settings.json` is notable: it contains the project's permission configuration and both SessionStart hook definitions, but it is not committed to version control.

Section summary: 4 issues flagged (red-team.md has 5 empty phase sections; settings.json untracked; session-plan.md untracked; 8 pipeline files untracked) / no previous audit for delta.

---

## Findings Summary

**Total issues flagged: 10**

| # | Section | Finding | Type |
|---|---|---|---|
| 1 | 2.5 | `/daily-program` and `/tomorrow-spar` commands referenced in CLAUDE.md "Workflow References" do not exist; explicitly labeled "Future" | Missing item (expected) |
| 2 | 2.6 | `## Input File Handling` in CLAUDE.md is verbatim duplication of canonical workspace CLAUDE.md content (self-declared) | Scoping violation (declared) |
| 3 | 2.6 | `## Commit Rules` in CLAUDE.md is verbatim duplication of canonical workspace CLAUDE.md content (self-declared) | Scoping violation (declared) |
| 4 | 4.8 | `log-sweep-auditor` agent (declared tier: haiku) is missing from `ai-resources/docs/agent-tier-table.md` | Discrepancy |
| 5 | 4.8 | `dossier-orchestrator` (project-local, Sonnet) is not in the tier table | Missing item (by design — project-local) |
| 6 | 4.9 | `projects/personal/.claude/settings.json` does not declare a top-level `"model": "sonnet"` key, which the canonical new-project baseline specifies | Discrepancy |
| 7 | 4.9 | `projects/personal/.claude/settings.json` is untracked in git (not committed) | Missing item |
| 8 | 6.2 | `pipeline/repo-snapshot.md` lines 58–59 contain `EMPTY PLACEHOLDER` markers for profile files that are now populated | Stale marker (in historical artifact) |
| 9 | 6.3 | `red-team.md` has 5 of 8 phase sections as empty placeholder sections (Phases 1, 4, 5, 6, Cross-Cutting) | Stub content |
| 10 | 6.3 | 8 `pipeline/` files, `logs/session-plan.md`, and all 75 `.claude/` symlinks are present on disk but untracked in git | Untracked files |

**Breakdown by type:**
- Discrepancy: 2 (log-sweep-auditor missing from tier table; settings.json missing top-level model key)
- Missing item: 4 (future commands not yet built; dossier-orchestrator not in tier table by design; settings.json not committed; untracked pipeline/symlink files)
- Scoping violation: 2 (declared verbatim duplications in CLAUDE.md)
- Stale marker: 1 (pipeline/repo-snapshot.md — historical artifact)
- Stub content: 1 (red-team.md empty sections)

**Clean checks:**
- All 75 symlinks resolve to existing targets
- All canonical deny entries present in settings.json
- Both SessionStart hook scripts exist and are accessible
- Both personalization spine files populated (Phase 0 complete)
- All three workflow reference files exist
- No naming convention violations
- No built-in command name conflicts
- No broken file references in CLAUDE.md (future items are explicitly labeled as such)
- No contradictions in CLAUDE.md
- No files older than 90 days
