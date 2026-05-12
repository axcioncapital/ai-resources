# Repo Due Diligence Audit — 2026-05-12
Repo: projects/interpersonal-communication
Scope: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/interpersonal-communication
Commit: afc42e1
Previous audit: None (first scoped audit for this project)
Depth: standard (factual audit only — Steps 1–6)

---

## Section 1: Inventory

### 1.1 Slash Commands

**Project-local commands (regular files — not symlinks):**

| Name | File | References | Last Commit Date |
|------|------|-----------|-----------------|
| meeting-prep | `.claude/commands/meeting-prep.md` (66 lines) | `knowledge-base/04-tactical-tools/run-sheets/{surface}-{counter-party}.md`, `knowledge-base/04-tactical-tools/question-library.md`, `knowledge-base/01-frameworks/warmth-competence.md`, `knowledge-base/02-swedish-calibration/calibration-overlay.md`, `knowledge-base/03-adversarial-playbook/*.md` (conditional), `knowledge-base/06-practitioner-exemplars/*.md`, `output/meeting-prep/meeting-prep-{slug}-{YYYYMMDD}.md` | 2026-05-11 |
| today-drill | `.claude/commands/today-drill.md` (64 lines) | `knowledge-base/05-mastery/drill-set.md`, `output/today-drill-state.json` | 2026-05-11 |
| ic-consult | `.claude/commands/ic-consult.md` (43 lines) | `.claude/skills/interpersonal-consultant/SKILL.md` | 2026-05-11 |

**Shared commands (symlinked from ai-resources at runtime — not tracked in git):**

At commit HEAD (afc42e1), the `.claude/commands/` directory contains only the 3 local regular files above. The SessionStart hook (`auto-sync-shared.sh`) creates runtime-only absolute-path symlinks for all non-excluded ai-resources commands on each session start. These symlinks are not committed to git. The initial scaffold commit (10571d6) included 54 command symlinks with broken relative paths (`./ai-resources/...`); all 54 were deleted in commit afc42e1. The full shared command list is governed by what exists in `ai-resources/.claude/commands/` at session time.

Section summary: 3 project-local commands catalogued; 0 deltas from previous audit (first audit).

---

### 1.2 Hooks

Hooks are defined in `.claude/settings.json`. No `.claude/settings.local.json` exists in the repo (it is gitignored and per-operator).

| Trigger | Hook | Timeout | What It Does | Files Referenced |
|---------|------|---------|-------------|-----------------|
| SessionStart (1) | `command` — walks up from `$CLAUDE_PROJECT_DIR` to find and execute `ai-resources/.claude/hooks/auto-sync-shared.sh` | 10s | Symlinks all shared commands and agents from ai-resources into the project on session start, skipping local-manifest exclusions | `ai-resources/.claude/hooks/auto-sync-shared.sh` (external), `shared-manifest.json` (read by the hook) |
| SessionStart (2) | `command` — walks up from `$CLAUDE_PROJECT_DIR` to find and execute `ai-resources/.claude/hooks/check-permission-sanity.sh` | 5s | Checks that `defaultMode: "bypassPermissions"` is set in the project settings; emits a nudge to run `/permission-sweep` if missing | `ai-resources/.claude/hooks/check-permission-sanity.sh` (external) |

Both hooks are defined inline in `settings.json` using shell walk-up idioms — no hook scripts live inside the project itself.

Section summary: 2 hooks catalogued; 0 deltas from previous audit (first audit).

---

### 1.3 Template Files

No dedicated template files exist in AUDIT_ROOT. The `pipeline/technical-spec.md` (1,279 lines) contains inline template definitions for KB file formats (principle template, exemplar template, persona template, scenario template) in its §8 section — these are specification text for Phase 0.2 deployment, not standalone template files.

None found — checked `.claude/`, `pipeline/`, `output/`, `logs/`, and root of AUDIT_ROOT for any file matching `*.template.*`, `*-template.md`, `templates/`, or `_templates/` directories.

Section summary: 0 template files catalogued; 0 deltas from previous audit (first audit).

---

### 1.4 Scripts

No bash, Python, or other scripts exist inside AUDIT_ROOT. The SessionStart hooks reference external scripts in `ai-resources/.claude/hooks/` but those are outside AUDIT_ROOT.

None found — checked all directories under AUDIT_ROOT for `.sh`, `.py`, `.js`, or other executable files.

Section summary: 0 scripts catalogued; 0 deltas from previous audit (first audit).

---

### 1.5 Skills

2 skills exist in `.claude/skills/`:

| Skill | SKILL.md Present | SKILL.md Path | Model Declared | Line Count |
|-------|-----------------|--------------|----------------|-----------|
| interpersonal-consultant | Yes | `.claude/skills/interpersonal-consultant/SKILL.md` | opus | 78 lines |
| role-play | Yes | `.claude/skills/role-play/SKILL.md` | opus | 71 lines |

Both SKILL.md files are regular files (not symlinks). Both declare `model: opus`. Neither is present in the canonical `ai-resources/skills/` library (checked: no `interpersonal-consultant` or `role-play` directory under `ai-resources/skills/`). These are project-local skills not yet graduated to ai-resources.

Section summary: 2 skills catalogued, 0 missing SKILL.md; 0 deltas from previous audit (first audit).

---

### 1.6 Uncategorized Items

| Item | Path | Category |
|------|------|---------|
| Session guide | `session-guide.md` (369 lines) | Project-generated planning artifact |
| Pipeline directory | `pipeline/` (9 files, 3,691 lines total) | New-project pipeline artifacts (stages 3a–6) |
| `pipeline/architecture.md` (294 lines) | Pipeline artifact | Stage 3b output |
| `pipeline/context-pack.md` (263 lines) | Pipeline artifact | Stage input artifact |
| `pipeline/decisions.md` (6 lines) | Pipeline artifact | Decision log |
| `pipeline/implementation-log.md` (153 lines) | Pipeline artifact | Stage 4 log |
| `pipeline/implementation-spec.md` (580 lines) | Pipeline artifact | Stage 3c output |
| `pipeline/pipeline-state.md` (14 lines) | Pipeline artifact | Stage status tracker |
| `pipeline/project-plan.md` (893 lines) | Pipeline artifact | Stage input artifact |
| `pipeline/repo-snapshot.md` (325 lines) | Pipeline artifact | Stage 3a output |
| `pipeline/sources.md` (7 lines) | Pipeline artifact | Input source provenance |
| `pipeline/technical-spec.md` (1,279 lines) | Pipeline artifact | Stage 3c technical spec |
| `pipeline/test-results.md` (171 lines) | Pipeline artifact | Stage 5 test results |
| Logs directory | `logs/` | Session log directory |
| `logs/session-notes.md` (5 lines) | Log file | Session notes (untracked by git — git status shows it as untracked `??`) |
| Output directory | `output/` | Runtime output directory |
| `output/meeting-prep/.gitkeep` (0 bytes) | Placeholder | Holds output directory in git |
| `output/role-play-transcripts/.gitkeep` (0 bytes) | Placeholder | Holds output directory in git |
| `.gitignore` (6 lines) | Standard git file | Excludes `output/today-drill-state.json` and `.claude/settings.local.json` |
| `.claude/shared-manifest.json` (13 lines) | Config | Declares 3 project-local commands |

Section summary: 19 uncategorized items catalogued; 0 deltas from previous audit (first audit).

---

### 1.7 Symlinks

**Current committed state (HEAD, afc42e1):**

No symlinks exist in the committed AUDIT_ROOT. Commit afc42e1 (2026-05-12 09:08) deleted 75 broken relative-path symlinks that had been committed by the initial scaffold commit (10571d6).

**Runtime state (created by SessionStart hook, not committed):**

The `auto-sync-shared.sh` SessionStart hook creates absolute-path symlinks in `.claude/commands/` and `.claude/agents/` at session start. These symlinks are not tracked in git. At the time of this audit, the agents/ directory is empty and commands/ contains only the 3 local regular files — the hook-created symlinks are not present on the filesystem.

**Historical note (pre-afc42e1):**

The scaffold commit included 75 symlinks with the broken relative target pattern `./ai-resources/.claude/{agents,commands}/{name}.md`. These resolved incorrectly: relative to the symlink's own directory (`.claude/agents/` or `.claude/commands/`), the path resolved to `.claude/agents/ai-resources/...`, which did not exist. Verified broken via `cat` returning "No such file or directory" for `.claude/agents/claude-md-auditor.md`. All 75 were deleted in afc42e1.

**Q3.5 coverage check (symlinks in `.claude/commands/` or `.claude/agents/` pointing outside AUDIT_ROOT):**

Current committed state: no symlinks exist in AUDIT_ROOT to check. Runtime symlinks (when recreated by hook) will point to absolute paths under `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/`. The `additionalDirectories` in `.claude/settings.json` lists `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` (the workspace root), which is an ancestor of ai-resources. Coverage is satisfied for runtime symlinks once the hook recreates them.

Section summary: 0 committed symlinks; 75 broken symlinks deleted in afc42e1; 0 deltas from previous audit (first audit).

---

## Section 2: CLAUDE.md Health

### 2.1 Line Count and Section Headings

CLAUDE.md is 43 lines with 5 distinct sections:

1. `## Input File Handling`
2. `## Commit Rules`
3. `## Compaction`
4. `## Session Boundaries`
5. `## Model Selection`

(Plus the document title `# interpersonal-communication` as a level-1 heading.)

Section summary: 43 lines, 5 sections.

---

### 2.2 Dead References in CLAUDE.md

CLAUDE.md references the following items:

| Referenced Item | Exists? | Notes |
|----------------|---------|-------|
| `output/{project}/` (write target pattern) | Partially — `output/meeting-prep/` and `output/role-play-transcripts/` exist; `{project}` is a placeholder pattern, not a literal path | Not a dead reference — it's an instruction pattern |
| `/compact` (command) | N/A — built-in Claude Code command | Not checked against filesystem |
| `/clear` (command) | N/A — built-in Claude Code command | Not checked against filesystem |
| `/wrap-session` (command) | Resolved at runtime via auto-sync hook from ai-resources | Not committed to project |
| `.claude/settings.local.json` | Does not exist (correctly gitignored — per-operator) | Mentioned as the location for model setting; this is correct per CLAUDE.md |
| `claude-sonnet-4-6[1m]` (model identifier) | N/A — runtime context | Not a file reference |

None found — no dead file references in CLAUDE.md. All non-command references are either patterns, gitignored per-operator files, or runtime items.

Section summary: 0 issues flagged; 0 deltas from previous audit (first audit).

---

### 2.3 Contradictions in CLAUDE.md

None found — checked all 5 sections for conflicting instructions. No two sections assert contradictory rules.

Section summary: 0 issues flagged; 0 deltas from previous audit (first audit).

---

### 2.4 Convention Violations in CLAUDE.md

CLAUDE.md defines these conventions:

| Convention | Expected | Actual | Violation? |
|-----------|---------|--------|-----------|
| Output files written to `output/{project}/` | Yes | `output/meeting-prep/` and `output/role-play-transcripts/` exist | No violation |
| Input files accessed via `Read` only | Behavioral rule | Not checkable against static files | N/A |
| Commit directly without pre-commit checks | Behavioral rule | Not checkable against static files | N/A |
| Model set in `.claude/settings.local.json` (gitignored) | Per-operator | File doesn't exist in repo (correct — gitignored) | No violation |

None found — checked file structure against conventions stated in CLAUDE.md.

Section summary: 0 issues flagged; 0 deltas from previous audit (first audit).

---

### 2.5 Partially Implemented Features in CLAUDE.md

None found — CLAUDE.md does not describe features requiring specific files beyond what is verified above. The model selection section references `.claude/settings.local.json` as gitignored and per-operator, which is the correct state.

Section summary: 0 issues flagged; 0 deltas from previous audit (first audit).

---

### 2.6 Misplaced Content in CLAUDE.md (Scoping Rule)

The workspace CLAUDE.md → "CLAUDE.md Scoping" rule states: project CLAUDE.md must not contain skill methodology, workflow methodology, or canonical workspace rules (verbatim duplication).

| Section | Content Type | In-Scope? | Notes |
|---------|-------------|-----------|-------|
| `## Input File Handling` | Canonical workspace rule (verbatim duplication) | Out of scope per CLAUDE.md Scoping rule | CLAUDE.md states explicitly: "This rule mirrors the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded." |
| `## Commit Rules` | Canonical workspace rule (verbatim duplication) | Out of scope per CLAUDE.md Scoping rule | CLAUDE.md states: "This rule mirrors the canonical `Commit behavior` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded." |
| `## Compaction` | Cross-session project-specific rule | In scope — project-specific behavior (what to preserve through compact) | |
| `## Session Boundaries` | Cross-session project-specific rule | In scope — project-specific operational guidance | |
| `## Model Selection` | Cross-session project-specific rule | In scope — declares model tier per workspace instructions | |

2 sections (`## Input File Handling`, `## Commit Rules`) are verbatim duplications of workspace CLAUDE.md rules. Both self-document their rationale for duplication ("projects are sometimes opened without the parent workspace context loaded"). The workspace CLAUDE.md Scoping rule classifies these as violations; the project's CLAUDE.md documents the reason for the exception.

Section summary: 2 issues flagged (verbatim workspace rule duplication with stated rationale); 0 deltas from previous audit (first audit).

---

## Section 3: Dependency References

### 3.1 Referenced Files per Command

| Command | Referenced File | Exists? | Notes |
|---------|----------------|---------|-------|
| `/meeting-prep` | `knowledge-base/04-tactical-tools/run-sheets/{surface}-{counter-party}.md` | No | KB not yet deployed (Phase 0.2 pending) |
| `/meeting-prep` | `knowledge-base/04-tactical-tools/question-library.md` | No | KB not yet deployed |
| `/meeting-prep` | `knowledge-base/01-frameworks/warmth-competence.md` | No | KB not yet deployed |
| `/meeting-prep` | `knowledge-base/02-swedish-calibration/calibration-overlay.md` | No | KB not yet deployed |
| `/meeting-prep` | `knowledge-base/03-adversarial-playbook/*.md` | No | KB not yet deployed |
| `/meeting-prep` | `knowledge-base/06-practitioner-exemplars/*.md` | No | KB not yet deployed |
| `/meeting-prep` | `output/meeting-prep/meeting-prep-{slug}-{YYYYMMDD}.md` | Directory exists (`output/meeting-prep/`); individual files generated at runtime | Partial |
| `/today-drill` | `knowledge-base/05-mastery/drill-set.md` | No | KB not yet deployed |
| `/today-drill` | `output/today-drill-state.json` | No (gitignored, per-operator runtime file) | By design |
| `/ic-consult` | `.claude/skills/interpersonal-consultant/SKILL.md` | Yes | |

**Skill references (interpersonal-consultant SKILL.md):**

| File Referenced | Exists? | Notes |
|----------------|---------|-------|
| `knowledge-base/01-frameworks/*.md` | No | KB not yet deployed |
| `knowledge-base/02-swedish-calibration/calibration-overlay.md` | No | KB not yet deployed |
| `knowledge-base/03-adversarial-playbook/*.md` | No | KB not yet deployed |
| `knowledge-base/04-tactical-tools/` | No | KB not yet deployed |
| `knowledge-base/06-practitioner-exemplars/*.md` | No | KB not yet deployed |
| `knowledge-base/08-references/` | No | KB not yet deployed |

**Skill references (role-play SKILL.md):**

| File Referenced | Exists? | Notes |
|----------------|---------|-------|
| `knowledge-base/07-practice-layer/scenarios/S-{NN}-*.md` | No | KB not yet deployed |
| `knowledge-base/07-practice-layer/personas/P-{NN}-*.md` | No | KB not yet deployed |
| `knowledge-base/00-meta/rubric.md` | No | KB not yet deployed |
| `knowledge-base/03-adversarial-playbook/` | No | KB not yet deployed |
| `knowledge-base/02-swedish-calibration/calibration-overlay.md` | No | KB not yet deployed |
| `knowledge-base/07-practice-layer/feedback-protocol.md` | No | KB not yet deployed |
| `knowledge-base/06-practitioner-exemplars/` | No | KB not yet deployed |
| `output/role-play-transcripts/S-{NN}-{YYYYMMDD}.md` | Directory exists; individual files runtime-generated | Partial |

**Summary count:** 1 referenced file exists (`.claude/skills/interpersonal-consultant/SKILL.md`). 2 output directories exist as placeholders. 17 distinct KB path patterns do not exist — all within `knowledge-base/` which is not yet deployed (Phase 0.2 pending, documented in `session-guide.md` and `pipeline/pipeline-state.md`).

Section summary: 19 references checked; 17 files/directories missing (all within undeployed knowledge-base); 0 deltas from previous audit (first audit).

---

### 3.2 Command Output Chains

| Source Command | Output | Consumed By |
|---------------|--------|------------|
| `/ic-consult` | Activates `interpersonal-consultant` skill for the session; may suggest running `/meeting-prep` or role-play | `/meeting-prep` (advisory suggestion only — not auto-invoked); `role-play` skill (advisory suggestion only) |
| `/meeting-prep` | Writes `output/meeting-prep/meeting-prep-{slug}-{YYYYMMDD}.md` | No downstream command consumes this file |
| `/today-drill` | Reads and writes `output/today-drill-state.json` (rotation state); outputs drill prompts to chat | No downstream command consumes output |
| `role-play` skill | Optionally writes `output/role-play-transcripts/S-{NN}-{YYYYMMDD}.md` (opt-in only) | No downstream command consumes transcript |

Section summary: 1 advisory cross-coupling chain (`/ic-consult` → advisory suggestion → `role-play` or `/meeting-prep`); no hard dependency chains; 0 deltas from previous audit (first audit).

---

### 3.3 Files Referenced by Multiple Commands/Hooks

| File | Referenced By | Count |
|------|--------------|-------|
| `knowledge-base/02-swedish-calibration/calibration-overlay.md` | `/meeting-prep`, `interpersonal-consultant` skill, `role-play` skill | 3 |
| `knowledge-base/03-adversarial-playbook/*.md` | `/meeting-prep`, `interpersonal-consultant` skill, `role-play` skill | 3 |
| `knowledge-base/06-practitioner-exemplars/*.md` | `/meeting-prep`, `interpersonal-consultant` skill | 2 |
| `.claude/skills/interpersonal-consultant/SKILL.md` | `/ic-consult` (loads it), `role-play` skill (cross-coupling reference) | 2 |
| `auto-sync-shared.sh` (external) | SessionStart hook (1), `check-permission-sanity.sh` lookup idiom mirrors it (not a direct reference) | 1 direct |

Section summary: 4 files referenced by 2+ components (all KB files do not yet exist); 0 deltas from previous audit (first audit).

---

### 3.4 Top 10 Files by Downstream Reference Count

| Rank | File | Reference Count | Referenced By |
|------|------|----------------|--------------|
| 1 | `knowledge-base/02-swedish-calibration/calibration-overlay.md` | 3 | `/meeting-prep`, `interpersonal-consultant` SKILL.md, `role-play` SKILL.md |
| 2 | `knowledge-base/03-adversarial-playbook/*.md` | 3 | `/meeting-prep`, `interpersonal-consultant` SKILL.md, `role-play` SKILL.md |
| 3 | `.claude/skills/interpersonal-consultant/SKILL.md` | 2 | `/ic-consult`, `role-play` SKILL.md (cross-coupling mention) |
| 4 | `knowledge-base/06-practitioner-exemplars/*.md` | 2 | `/meeting-prep`, `interpersonal-consultant` SKILL.md |
| 5 | `output/meeting-prep/` (directory) | 2 | `/meeting-prep` (writes to it), `CLAUDE.md` (output pattern) |
| 6 | `knowledge-base/01-frameworks/*.md` | 2 | `/meeting-prep` (`warmth-competence.md`), `interpersonal-consultant` SKILL.md |
| 7 | `knowledge-base/04-tactical-tools/` | 2 | `/meeting-prep` (2 files), `interpersonal-consultant` SKILL.md |
| 8 | `knowledge-base/07-practice-layer/` | 2 | `role-play` SKILL.md (scenarios/, personas/, feedback-protocol.md) |
| 9 | `output/today-drill-state.json` | 1 | `/today-drill` |
| 10 | `knowledge-base/05-mastery/drill-set.md` | 1 | `/today-drill` |

Section summary: 10 items ranked; top references are all to not-yet-deployed KB paths; 0 deltas from previous audit (first audit).

---

### 3.5 Symlink Coverage Check (Q3.5)

Current committed state: no symlinks exist in `.claude/commands/` or `.claude/agents/`. The `additionalDirectories` in `.claude/settings.json` lists `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` (the workspace root).

Runtime symlinks (created by `auto-sync-shared.sh` at session start): these will point to absolute paths under `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/`. The workspace root is an ancestor of that path (prefix match: YES). Coverage is satisfied.

No coverage gaps found — checked `permissions.additionalDirectories` in `.claude/settings.json`; no `.claude/settings.local.json` exists in the repo.

Section summary: 0 issues flagged; 0 deltas from previous audit (first audit).

---

### 3.6 Projects Referencing ai-resources Without Proper additionalDirectories

This project references ai-resources via:
- SessionStart hook (auto-sync-shared.sh)
- SessionStart hook (check-permission-sanity.sh)
- `shared-manifest.json` (consumed by the sync hook)

The workspace root (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`) is listed in `permissions.additionalDirectories`. This is an ancestor of `ai-resources/`. Coverage is satisfied.

None found — checked `.claude/settings.json`; workspace root is in additionalDirectories.

Section summary: 0 issues flagged; 0 deltas from previous audit (first audit).

---

## Section 4: Consistency Checks

### 4.1 Skill Structural Consistency

Both skills follow the same structural pattern: YAML frontmatter with `name`, `description`, `model` fields, followed by markdown sections. Both are stored in `.claude/skills/{skill-name}/SKILL.md`.

| Skill | Has YAML Frontmatter | Model Declared | Has Activation Section | Has Workflow/Posture Section | Has Constraints Section |
|-------|---------------------|----------------|----------------------|------------------------------|------------------------|
| interpersonal-consultant | Yes | opus | Yes (`## Activation`) | Yes (posture, KB-grounding, etc.) | Yes (via `## Boundary Discipline`, `## No Manipulative Drift`) |
| role-play | Yes | opus | Yes (`## Activation`) | Yes (`## Workflow`) | Yes (`## Constraints`) |

No structural deviations. Both skills declare `model: opus` in frontmatter, consistent with the workspace CLAUDE.md rule that analytical/judgment commands declare `model: opus`.

Section summary: 0 issues flagged; 0 deltas from previous audit (first audit).

---

### 4.2 Command Definition Pattern Consistency

All 3 local commands use the same pattern: YAML frontmatter (`name`, `description`, `model`, `argument-hint`), followed by a markdown heading and structured workflow steps.

| Command | Has YAML | Has name | Has model | Has argument-hint | Has Workflow Steps | Has Constraints |
|---------|----------|---------|-----------|------------------|-------------------|----------------|
| meeting-prep | Yes | Yes | sonnet | Yes | Yes (8 steps) | Yes |
| today-drill | Yes | Yes | sonnet | Yes | Yes (7 steps) | Yes |
| ic-consult | Yes | Yes | sonnet | Yes | Yes (4 steps) | Yes |

No deviations. All 3 commands declare `model: sonnet` — consistent with workspace rule that orchestrator/dispatch commands declare sonnet; these are session-flow entry point commands rather than analytical commands.

Section summary: 0 issues flagged; 0 deltas from previous audit (first audit).

---

### 4.3 Skill Template Comparison

N/A — No skill creation template file exists in AUDIT_ROOT. Skills are created via `/create-skill` which references ai-resource-builder/SKILL.md for format standards. The two skills in this project were created directly via the new-project pipeline (Stage 4), not via `/create-skill`.

Section summary: N/A — no skill creation template file exists. Skills are created via /create-skill which references ai-resource-builder/SKILL.md for format standards.

---

### 4.4 Naming Convention Inconsistencies

| Item Type | Naming Pattern | Items | Inconsistencies |
|-----------|--------------|-------|----------------|
| Skills | kebab-case directory under `.claude/skills/` | `interpersonal-consultant`, `role-play` | None |
| Local commands | kebab-case `.md` files | `meeting-prep.md`, `today-drill.md`, `ic-consult.md` | None |
| Output directories | kebab-case under `output/` | `meeting-prep`, `role-play-transcripts` | None — consistent with skill/command naming |
| Pipeline files | kebab-case `.md` files | All 9 files consistent | None |

None found — all items follow consistent kebab-case naming.

Section summary: 0 issues flagged; 0 deltas from previous audit (first audit).

---

### 4.5 Directory Structure Violations

The workspace CLAUDE.md specifies: "Outputs are written normally via `Write` into `output/{project}/`." The project contains:

- `output/meeting-prep/` — matches (used by `/meeting-prep`)
- `output/role-play-transcripts/` — matches (used by `role-play` skill)
- `logs/` — session logs directory (consistent with other projects)
- `pipeline/` — new-project pipeline artifacts (consistent with other projects)

None found — directory structure follows the expected pattern.

Section summary: 0 issues flagged; 0 deltas from previous audit (first audit).

---

### 4.6 Command Syntax and File Path Verification

| Command | Valid YAML Frontmatter | Referenced Paths Resolve |
|---------|----------------------|------------------------|
| `meeting-prep.md` | Yes — all 4 YAML fields present and valid | No — all `knowledge-base/` paths missing (KB not yet deployed); `output/meeting-prep/` directory exists |
| `today-drill.md` | Yes — all 4 YAML fields present and valid | No — `knowledge-base/05-mastery/drill-set.md` missing; `output/today-drill-state.json` is runtime-generated/gitignored |
| `ic-consult.md` | Yes — all 4 YAML fields present and valid | Yes — `.claude/skills/interpersonal-consultant/SKILL.md` exists |

2 commands have unresolvable KB file paths. These are documented architectural deferreds, not defects: the `pipeline/pipeline-state.md` and `session-guide.md` document that KB deployment (Phase 0.2) is the next pending work.

Section summary: 2 commands with unresolvable KB paths (documented deferreds); 0 deltas from previous audit (first audit).

---

### 4.7 Duplicate or Built-in Command Name Conflicts

**Local command names:** `meeting-prep`, `today-drill`, `ic-consult`.

- `meeting-prep`: not a known Claude Code built-in. Not present as a name in ai-resources shared commands.
- `today-drill`: not a known Claude Code built-in. Not present as a name in ai-resources shared commands.
- `ic-consult`: not a known Claude Code built-in. Distinct from workspace `/consult` command (the workspace command is `consult.md`, this project's command is `ic-consult.md`). The rename from `consult` to `ic-consult` was Decision 1 in `pipeline/decisions.md`.

None found — no duplicates or built-in conflicts. Checked: all 3 local command names; verified `ic-consult` ≠ `consult`.

Section summary: 0 issues flagged; 0 deltas from previous audit (first audit).

---

### 4.8 Agent Tier Declarations

Current committed state: no agent files exist in `.claude/agents/` (all 21 broken symlinks were deleted in afc42e1). At runtime, the hook recreates symlinks pointing to agent files in `ai-resources/.claude/agents/`. The tier table is maintained in `ai-resources/docs/agent-tier-table.md`.

For the 21 agents that were previously symlinked (all from ai-resources), the following tier check is performed against the agent-tier-table.md:

| Agent | Declared Model (ai-resources file) | Expected Tier (table) | Match? | In Table? |
|-------|-----------------------------------|-----------------------|--------|----------|
| claude-md-auditor | opus | opus | Yes | Yes |
| collaboration-coach | opus | opus | Yes | Yes |
| critical-resource-auditor | opus | opus | Yes | Yes |
| dd-extract-agent | haiku | haiku | Yes | Yes |
| dd-log-sweep-agent | haiku | haiku | Yes | Yes |
| execution-agent | sonnet | sonnet | Yes | Yes |
| findings-extractor | haiku | haiku | Yes | Yes |
| improvement-analyst | opus | opus | Yes | Yes |
| innovation-triage-auditor | opus | opus | Yes | Yes |
| log-sweep-auditor | haiku | — | — | **No — missing from table** |
| permission-sweep-auditor | sonnet | sonnet | Yes | Yes |
| qc-reviewer | opus | opus | Yes | Yes |
| refinement-reviewer | opus | opus | Yes | Yes |
| repo-dd-auditor | sonnet | sonnet | Yes | Yes |
| risk-check-reviewer | opus | opus | Yes | Yes |
| system-owner | opus | opus | Yes | Yes |
| token-audit-auditor | opus | opus | Yes | Yes |
| token-audit-auditor-mechanical | haiku | haiku | Yes | Yes |
| triage-reviewer | opus | opus | Yes | Yes |
| workflow-analysis-agent | opus | opus | Yes | Yes |
| workflow-critique-agent | opus | opus | Yes | Yes |

1 agent (`log-sweep-auditor`) is deployed as a runtime symlink but is missing from the agent-tier-table.md in ai-resources. The actual model declaration in the ai-resources file is `haiku`. The table entry is absent — the agent exists in ai-resources but was not registered in the tier table.

Note: This finding is in the ai-resources scope, not AUDIT_ROOT. It is surfaced here because the agent is deployed from this project context.

Section summary: 1 issue flagged (`log-sweep-auditor` missing from agent-tier-table.md); 0 deltas from previous audit (first audit).

---

### 4.9 settings.json Canonical Baseline Check

**Canonical baseline** (from `ai-resources/.claude/commands/new-project.md`, `CANONICAL_PERMS` block):

```
deny: ["Bash(git push*)", "Bash(rm -rf *)", "Bash(sudo *)", "Read(archive/**)", "Read(**/*.archive.*)", "Read(**/deprecated/**)", "Read(**/old/**)"]
allow: ["Bash(*)", "Read", "Edit", "Write", "MultiEdit", "Agent", "Skill", "TodoWrite", "Glob", "Grep", "WebFetch", "WebSearch", "NotebookEdit", "ToolSearch", "Edit(**/.claude/**)", "Write(**/.claude/**)", "Bash(rm *)"]
```

The canonical also requires `"model": "sonnet"` at the top level.

**Project `.claude/settings.json` actual:**

- `deny`: `["Bash(git push*)", "Bash(rm -rf *)", "Bash(sudo *)", "Read(archive/**)", "Read(**/*.archive.*)", "Read(**/deprecated/**)", "Read(**/old/**)"]` — **matches canonical exactly**
- `allow`: `["Bash(*)", "Read", "Edit", "Write", "MultiEdit", "Agent", "Skill", "TodoWrite", "Glob", "Grep", "WebFetch", "WebSearch", "NotebookEdit", "ToolSearch", "Edit(**/.claude/**)", "Write(**/.claude/**)", "Bash(rm *)"]` — **matches canonical exactly**
- `"model"` top-level: **NOT SET** (absent from settings.json)

| Check | Result |
|-------|--------|
| All canonical `deny` entries present | Pass |
| Missing deny entries | None |
| `"model": "sonnet"` top-level declared | **Fail — not set** |
| `settings.json` last commit | 2026-05-11 |
| `new-project.md` CANONICAL_PERMS last commit | Unknown — no commit history returned for this file (may predate tracked history or has no recent modification) |

Section summary: 1 issue flagged (`"model": "sonnet"` missing from top-level of `.claude/settings.json`); 0 deltas from previous audit (first audit).

---

## Section 5: Context Load

### 5.1 Context Load at Session Start

| Source | Lines | Notes |
|--------|-------|-------|
| `CLAUDE.md` (project) | 43 lines | Auto-loaded by Claude Code |
| Workspace `CLAUDE.md` | 164 lines | Auto-loaded (workspace root) |
| SessionStart hook 1 (auto-sync-shared.sh) | — | Runs script, no context added directly |
| SessionStart hook 2 (check-permission-sanity.sh) | — | Runs script, no context added directly |

Total estimated auto-loaded context: ~207 lines (43 project + 164 workspace CLAUDE.md).

Skills and command files are not auto-loaded — they are loaded on demand when commands are invoked or skills are explicitly read.

Section summary: ~207 lines estimated at session start; 0 deltas from previous audit (first audit).

---

### 5.2 CLAUDE.md Sections Not Referenced by Commands/Hooks

| Section | Lines | Referenced by Command or Hook? |
|---------|-------|-------------------------------|
| `## Input File Handling` | ~16 lines | Referenced indirectly by all commands (behavioral rule for input handling); not referenced by any specific command or hook definition |
| `## Commit Rules` | ~9 lines | Not referenced by any command or hook; behavioral rule for direct commits |
| `## Compaction` | ~10 lines | Not referenced by any command or hook; behavioral rule for `/compact` events |
| `## Session Boundaries` | ~4 lines | Not referenced by any command or hook; behavioral rule for `/clear` usage |
| `## Model Selection` | ~4 lines | Not referenced by any command or hook; declares Sonnet 1M default |

All 5 sections are behavioral modifiers or cross-session rules — none are referenced by specific command files because they govern session behavior rather than command-specific behavior. All sections are operationally meaningful for every session.

Section summary: 0 dead-weight sections identified; all 5 sections are behavioral modifiers that apply to every session; 0 deltas from previous audit (first audit).

---

### 5.3 CLAUDE.md Line Count History

| Commit | Date | Line Count | Notes |
|--------|------|-----------|-------|
| 10571d6 | 2026-05-11 | 43 | Initial scaffold — only commit touching CLAUDE.md |

Only 1 commit in history modifies CLAUDE.md. Only 1 data point available.

Section summary: 1 commit history point; 43 lines at creation; 0 deltas from previous audit (first audit).

---

## Section 6: Drift and Staleness

### 6.1 Files Unmodified for 90+ Days Referenced by Active Commands

The entire project was created on 2026-05-11 (1 day before this audit, 2026-05-12). All files have a last commit date of 2026-05-11 or 2026-05-12. No file is older than 90 days.

None found — all files created within the last 2 days.

Section summary: 0 issues flagged; 0 deltas from previous audit (first audit).

---

### 6.2 TODO / FIXME / PLACEHOLDER / TBD Markers

| File | Line | Marker | Content |
|------|------|--------|---------|
| `pipeline/technical-spec.md` | 8 | TODO (historical reference) | "§6.2 today-drill: filled in full command body (was abbreviated TODO in v1 — actionability gap)." — This is a changelog note, not an active TODO |
| `pipeline/technical-spec.md` | 178 | TODO (spec instruction) | "Write `README.md` skeleton (sections marked TODO; Phase 7.2 populates worked walkthroughs)." — A Phase 7.2 deliverable instruction in the spec |
| `pipeline/technical-spec.md` | 299 | placeholder (spec instruction) | "replace bracketed placeholders with actual artifact excerpts before v1 ships" — A README authoring instruction in the spec |
| `pipeline/technical-spec.md` | 422 | TODO (spec artifact list) | "README.md skeleton written (TODOs for the two worked walkthroughs Phase 7.2 produces)." — Post-pipeline artifact description |
| `pipeline/technical-spec.md` | 1226 | placeholder (spec decision) | "Templates ship with section headers and frontmatter placeholders; content is filled at use time." — Specification decision text |
| `pipeline/context-pack.md` | 78 | TBD (input artifact) | "An Obsidian knowledge base deployed via `/deploy-kb`, located inside the project (path TBD by `/plan-draft`…)" — Planning input artifact |
| `pipeline/context-pack.md` | 178 | TBD (input artifact) | "External source materials — Giannamore (book; exact title TBD), Van Edwards…, Boutique PE Fundamentals Handbook (exact title TBD)." — Source identification deferred to execution |
| `pipeline/project-plan.md` | 72 | TBD (plan text) | "Operator-supplied external sources (tier TBD at framework definition)" — Phase-gated definition |
| `pipeline/pipeline-state.md` | 4 | TBD (operational field) | "GitHub: TBD" — GitHub repo URL not yet created |

All markers are in pipeline/ artifact files (planning inputs and specs). None appear in active command files, SKILL.md files, CLAUDE.md, or settings files. The `pipeline/pipeline-state.md` TBD (GitHub URL) is the only one in an operational tracking file.

Section summary: 9 markers found; all in pipeline artifact or planning files; 1 in operational tracking file (pipeline-state.md line 4); 0 deltas from previous audit (first audit).

---

### 6.3 Empty, Stub, or Boilerplate-Only Files

| File | Content | Assessment |
|------|---------|-----------|
| `output/meeting-prep/.gitkeep` | 0 bytes | Placeholder to hold directory in git — expected |
| `output/role-play-transcripts/.gitkeep` | 0 bytes | Placeholder to hold directory in git — expected |
| `logs/session-notes.md` | 5 lines — 2026-05-12 entry with scope note | Minimal content; this is the first session note |

No stub files with boilerplate-only content beyond what is expected. The two `.gitkeep` files are intentional directory holders.

Section summary: 2 empty placeholder files (expected); 1 minimal-content log file (first session); 0 deltas from previous audit (first audit).

---

## Findings Summary

Total issues flagged across all sections: **10**

| # | Section | Finding | Type |
|---|---------|---------|------|
| F1 | 1.7 | 75 broken relative-path symlinks were committed in the scaffold (10571d6) and deleted in fix commit (afc42e1); root cause was incorrect relative path format (`./ai-resources/...` relative to symlink directory rather than repo root) | Historical discrepancy — resolved |
| F2 | 2.6 | `## Input File Handling` in CLAUDE.md is a verbatim duplication of workspace-level CLAUDE.md rule, with self-documented rationale for the exception | Convention violation (self-documented exception) |
| F3 | 2.6 | `## Commit Rules` in CLAUDE.md is a verbatim duplication of workspace-level CLAUDE.md rule, with self-documented rationale for the exception | Convention violation (self-documented exception) |
| F4 | 3.1 | 17 distinct `knowledge-base/` file/directory paths referenced by commands and skills do not exist | Missing items — documented architectural deferred (Phase 0.2 pending) |
| F5 | 4.6 | `/meeting-prep` has 6 unresolvable KB file paths | Dependency missing — documented deferred |
| F6 | 4.6 | `/today-drill` has 1 unresolvable KB file path | Dependency missing — documented deferred |
| F7 | 4.8 | `log-sweep-auditor` agent is deployed (via runtime hook symlink) but is absent from `ai-resources/docs/agent-tier-table.md` | Missing item (in ai-resources scope) |
| F8 | 4.9 | `.claude/settings.json` does not declare `"model": "sonnet"` at the top level, which the canonical baseline requires | Discrepancy vs. canonical |
| F9 | 6.2 | `pipeline/pipeline-state.md` line 4 has TBD marker for GitHub URL | Missing item (operational tracking) |
| F10 | 1.5 | `interpersonal-consultant` and `role-play` skills are project-local only — not present in `ai-resources/skills/` canonical library | Inventory fact (no canonical graduation yet) |

**Clean checks (no issues):**
- CLAUDE.md dead references: clean
- CLAUDE.md contradictions: clean
- CLAUDE.md convention violations: clean
- Partially implemented features in CLAUDE.md: clean
- Command output chains: clean (all advisory)
- Symlink coverage (Q3.5): clean
- ai-resources additionalDirectories (Q3.6): clean
- Skill structural consistency: clean
- Command definition pattern consistency: clean
- Naming convention inconsistencies: clean
- Directory structure violations: clean
- Duplicate command names: clean
- 90-day staleness: clean (project is 1 day old)
- CLAUDE.md dead-weight sections: clean

**Count by type:**
- Historical discrepancy (resolved): 1 (F1)
- Convention violations with self-documented rationale: 2 (F2, F3)
- Missing items — documented architectural deferreds: 3 (F4, F5, F6)
- Missing item — ai-resources scope: 1 (F7)
- Discrepancy vs. canonical: 1 (F8)
- Missing item — operational: 1 (F9)
- Inventory facts: 1 (F10)
