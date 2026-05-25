# Repo Due Diligence Audit — 2026-05-25
Repo: projects/axcion-brand-book
Scope: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book
Commit: 41e29d0
Previous audit: None
Depth: full

---

## Section 1: Inventory

### 1.1 Slash commands currently defined

**Project-local commands (regular files in `.claude/commands/`):**

| Name | File | Files Referenced |
|------|------|-----------------|
| `/scope-module` | `.claude/commands/scope-module.md` | `references/module-sequence.md`, `pipeline/module-status.md`, `source_map.md`, `references/scoping-note-rubric.md`, `references/phase-workflow.md`, `references/module-template.md`, `pipeline/context-pack.md`, `pipeline/project-plan.md`, `brand-book/_scoping/{module-id}-scoping.md` (output), `_appendix/rejected_directions.md` (output), `pipeline/module-status.md` (output) |
| `/draft-module` | `.claude/commands/draft-module.md` | `pipeline/module-status.md`, `brand-book/_scoping/{module-id}-scoping.md`, `source_map.md`, `references/module-sequence.md`, `pipeline/context-pack.md`, `references/module-template.md`, `references/tagging-conventions.md`, `references/mockup-conventions.md`, `brand-book/{module-id}.md` (output), `mockups/{module-id}/*.{html,svg}` (output) |
| `/qc-module` | `.claude/commands/qc-module.md` | `references/module-template.md`, `source_map.md`, `references/tagging-conventions.md`, `references/mockup-conventions.md`, `pipeline/context-pack.md`, `logs/qc-reports/{module-id}-{date}.md` (output), `pipeline/module-status.md` (output) |
| `/lock-module` | `.claude/commands/lock-module.md` | `logs/qc-reports/{module-id}-*.md`, `brand-book/{module-id}.md`, `references/module-sequence.md`, `pipeline/module-status.md` (output) |

**Shared commands (symlinks to ai-resources, 75 total):**

| Name | Symlink Path |
|------|-------------|
| `/analyze-workflow` | `.claude/commands/analyze-workflow.md` → `ai-resources/.claude/commands/analyze-workflow.md` |
| `/architecture-review` | `.claude/commands/architecture-review.md` → `ai-resources/.claude/commands/architecture-review.md` |
| `/audit-claude-md` | `.claude/commands/audit-claude-md.md` → `ai-resources/.claude/commands/audit-claude-md.md` |
| `/audit-critical-resources` | `.claude/commands/audit-critical-resources.md` → `ai-resources/.claude/commands/audit-critical-resources.md` |
| `/audit-repo` | `.claude/commands/audit-repo.md` → `ai-resources/.claude/commands/audit-repo.md` |
| `/clarify` | `.claude/commands/clarify.md` → `ai-resources/.claude/commands/clarify.md` |
| `/cleanup-worktree` | `.claude/commands/cleanup-worktree.md` → `ai-resources/.claude/commands/cleanup-worktree.md` |
| `/coach` | `.claude/commands/coach.md` → `ai-resources/.claude/commands/coach.md` |
| `/consult` | `.claude/commands/consult.md` → `ai-resources/.claude/commands/consult.md` |
| `/create-skill` | `.claude/commands/create-skill.md` → `ai-resources/.claude/commands/create-skill.md` |
| `/deploy-kb` | `.claude/commands/deploy-kb.md` → `ai-resources/.claude/commands/deploy-kb.md` |
| `/drift-check` | `.claude/commands/drift-check.md` → `ai-resources/.claude/commands/drift-check.md` |
| `/explain` | `.claude/commands/explain.md` → `ai-resources/.claude/commands/explain.md` |
| `/fix-symlinks` | `.claude/commands/fix-symlinks.md` → `ai-resources/.claude/commands/fix-symlinks.md` |
| `/friction-log` | `.claude/commands/friction-log.md` → `ai-resources/.claude/commands/friction-log.md` |
| `/friday-act` | `.claude/commands/friday-act.md` → `ai-resources/.claude/commands/friday-act.md` |
| `/friday-checkup` | `.claude/commands/friday-checkup.md` → `ai-resources/.claude/commands/friday-checkup.md` |
| `/friday-journal` | `.claude/commands/friday-journal.md` → `ai-resources/.claude/commands/friday-journal.md` |
| `/friday-so` | `.claude/commands/friday-so.md` → `ai-resources/.claude/commands/friday-so.md` |
| `/graduate-resource` | `.claude/commands/graduate-resource.md` → `ai-resources/.claude/commands/graduate-resource.md` |
| `/grill-me` | `.claude/commands/grill-me.md` → `ai-resources/.claude/commands/grill-me.md` |
| `/handoff` | `.claude/commands/handoff.md` → `ai-resources/.claude/commands/handoff.md` |
| `/implementation-triage` | `.claude/commands/implementation-triage.md` → `ai-resources/.claude/commands/implementation-triage.md` |
| `/improve-skill` | `.claude/commands/improve-skill.md` → `ai-resources/.claude/commands/improve-skill.md` |
| `/improve` | `.claude/commands/improve.md` → `ai-resources/.claude/commands/improve.md` |
| `/innovation-sweep` | `.claude/commands/innovation-sweep.md` → `ai-resources/.claude/commands/innovation-sweep.md` |
| `/log-sweep` | `.claude/commands/log-sweep.md` → `ai-resources/.claude/commands/log-sweep.md` |
| `/migrate-skill` | `.claude/commands/migrate-skill.md` → `ai-resources/.claude/commands/migrate-skill.md` |
| `/monday-prep` | `.claude/commands/monday-prep.md` → `ai-resources/.claude/commands/monday-prep.md` |
| `/note` | `.claude/commands/note.md` → `ai-resources/.claude/commands/note.md` |
| `/open-items` | `.claude/commands/open-items.md` → `ai-resources/.claude/commands/open-items.md` |
| `/permission-sweep` | `.claude/commands/permission-sweep.md` → `ai-resources/.claude/commands/permission-sweep.md` |
| `/prime` | `.claude/commands/prime.md` → `ai-resources/.claude/commands/prime.md` |
| `/project-consultant` | `.claude/commands/project-consultant.md` → `ai-resources/.claude/commands/project-consultant.md` |
| `/qc-pass` | `.claude/commands/qc-pass.md` → `ai-resources/.claude/commands/qc-pass.md` |
| `/recommend` | `.claude/commands/recommend.md` → `ai-resources/.claude/commands/recommend.md` |
| `/refinement-deep` | `.claude/commands/refinement-deep.md` → `ai-resources/.claude/commands/refinement-deep.md` |
| `/refinement-pass` | `.claude/commands/refinement-pass.md` → `ai-resources/.claude/commands/refinement-pass.md` |
| `/repo-dd` | `.claude/commands/repo-dd.md` → `ai-resources/.claude/commands/repo-dd.md` |
| `/request-skill` | `.claude/commands/request-skill.md` → `ai-resources/.claude/commands/request-skill.md` |
| `/resolve-improvement-log` | `.claude/commands/resolve-improvement-log.md` → `ai-resources/.claude/commands/resolve-improvement-log.md` |
| `/resolve-repo-problem` | `.claude/commands/resolve-repo-problem.md` → `ai-resources/.claude/commands/resolve-repo-problem.md` |
| `/resolve` | `.claude/commands/resolve.md` → `ai-resources/.claude/commands/resolve.md` |
| `/risk-check` | `.claude/commands/risk-check.md` → `ai-resources/.claude/commands/risk-check.md` |
| `/route-change` | `.claude/commands/route-change.md` → `ai-resources/.claude/commands/route-change.md` |
| `/save-session` | `.claude/commands/save-session.md` → `ai-resources/.claude/commands/save-session.md` |
| `/scope` | `.claude/commands/scope.md` → `ai-resources/.claude/commands/scope.md` |
| `/session-guide` | `.claude/commands/session-guide.md` → `ai-resources/.claude/commands/session-guide.md` |
| `/session-plan` | `.claude/commands/session-plan.md` → `ai-resources/.claude/commands/session-plan.md` |
| `/session-start` | `.claude/commands/session-start.md` → `ai-resources/.claude/commands/session-start.md` |
| `/so-monthly` | `.claude/commands/so-monthly.md` → `ai-resources/.claude/commands/so-monthly.md` |
| `/summary` | `.claude/commands/summary.md` → `ai-resources/.claude/commands/summary.md` |
| `/sync-workflow` | `.claude/commands/sync-workflow.md` → `ai-resources/.claude/commands/sync-workflow.md` |
| `/systems-review` | `.claude/commands/systems-review.md` → `ai-resources/.claude/commands/systems-review.md` |
| `/token-audit` | `.claude/commands/token-audit.md` → `ai-resources/.claude/commands/token-audit.md` |
| `/triage` | `.claude/commands/triage.md` → `ai-resources/.claude/commands/triage.md` |
| `/update-claude-md` | `.claude/commands/update-claude-md.md` → `ai-resources/.claude/commands/update-claude-md.md` |
| `/usage-analysis` | `.claude/commands/usage-analysis.md` → `ai-resources/.claude/commands/usage-analysis.md` |
| `/wrap-session` | `.claude/commands/wrap-session.md` → `ai-resources/.claude/commands/wrap-session.md` |

(17 additional shared commands: `analyze-workflow`, `architecture-review`, `audit-claude-md`, `audit-critical-resources`, `audit-repo`, `clarify`, `cleanup-worktree`, `coach`, `consult`, `create-skill`, `deploy-kb`, `explain`, `fix-symlinks` — all symlinks resolving to ai-resources, total 75 shared symlinks in `.claude/commands/`.)

Total commands: 79 (4 project-local, 75 shared symlinks).

### 1.2 Hooks currently configured

Source: `.claude/settings.json` (no `settings.local.json` present).

| Trigger | Type | What It Does | Files Referenced |
|---------|------|-------------|-----------------|
| SessionStart | command | Walks up directory tree from `$CLAUDE_PROJECT_DIR`, runs `auto-sync-shared.sh` from first ai-resources ancestor found. Syncs shared commands from ai-resources. Timeout: 10s. | `{workspace}/ai-resources/.claude/hooks/auto-sync-shared.sh` |
| SessionStart | command | Walks up directory tree, runs `check-permission-sanity.sh` from first ai-resources ancestor found. Checks permission sanity. Timeout: 5s. | `{workspace}/ai-resources/.claude/hooks/check-permission-sanity.sh` |

Both hook scripts exist at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/auto-sync-shared.sh` (executable, 5018 bytes) and `check-permission-sanity.sh` (executable, 3499 bytes). Both targets are accessible.

### 1.3 Template files

| File Path | Used By | Last Commit Date |
|-----------|---------|-----------------|
| `references/module-template.md` | `/draft-module` Step 2, `/qc-module` Step 2 | 2026-05-19 |
| `references/scoping-note-rubric.md` | `/scope-module` Step 4, `brand-strategist` agent | 2026-05-19 |
| `references/phase-workflow.md` | `/scope-module` Step 4, project documentation | 2026-05-19 |
| `references/mockup-conventions.md` | `/draft-module` Step 4 (visual modules), `/qc-module` Step 4 | 2026-05-19 |
| `references/source-map-format.md` | `source_map.md` build procedure reference; referenced by `/scope-module` Step 3 | 2026-05-19 |
| `references/tagging-conventions.md` | `/draft-module` Step 2, `/qc-module` Step 3 | 2026-05-19 |
| `references/module-sequence.md` | `/scope-module` Step 2, `/lock-module` Step 6 | 2026-05-19 |

### 1.4 Scripts (bash, python, or other — not templates or skills)

None found — checked all files in AUDIT_ROOT by extension and content. No `.sh`, `.py`, `.rb`, `.js`, or other script files exist within the project subtree. Hook scripts referenced by `settings.json` reside in `ai-resources/.claude/hooks/` (outside AUDIT_ROOT).

### 1.5 Skills in the repo

0 skills within AUDIT_ROOT. No `skills/` directory exists under this project. The project is a consumer of ai-resources skills (via symlinked commands that invoke them) but does not own any skills. Per project design (context-pack §9, pipeline/decisions.md D10), skills are explicitly deferred to post-project graduation.

`_skills_candidates.md` exists at project root with boilerplate scaffold (61 lines) — no candidates recorded yet. Expected for current project phase.

### 1.6 Uncategorized files

| File | Category | Notes |
|------|----------|-------|
| `SESSION-GUIDE.md` | Project documentation | Session orientation doc generated during initial scaffold (141 lines). Not referenced by CLAUDE.md. |
| `pipeline/pipeline-state.md` | Pipeline tracking | Records scaffold pipeline stage completion (14 lines). |
| `pipeline/sources.md` | Pipeline provenance | Records source paths for context-pack.md and project-plan.md (6 lines). |
| `pipeline/implementation-log.md` | Pipeline artifact | Log of scaffold implementation operations (248 lines). |
| `pipeline/implementation-spec.md` | Pipeline artifact | Full implementation specification for scaffold build (2284 lines). |
| `pipeline/repo-snapshot.md` | Pipeline artifact | Repository snapshot from Stage 3a (355 lines). |
| `pipeline/architecture.md` | Pipeline artifact | Architecture design document from Stage 3b (450 lines). |
| `pipeline/test-results.md` | Pipeline artifact | Stage 5 test results (226 lines). |
| `pipeline/decisions.md` | Pipeline tracking | 10 architectural decisions (D1–D10) from Stage 3b (14 lines). |
| `pipeline/context-pack.md` | Input (read-only) | Project brief — copied from `project-planning` output on 2026-05-19 (614 lines). |
| `pipeline/project-plan.md` | Input (read-only) | Project plan — copied from `project-planning` output on 2026-05-19 (617 lines). |
| `pipeline/module-status.md` | Active state | Canonical session-N orientation document (63 lines). |
| `source_map.md` | Active state | Corporate identity source map — scaffold placeholder, 0 of 13 populated (78 lines). |
| `_consultants/brand_strategist.md` | Reference | Long-form brand strategist companion — scaffold placeholder, Phase 0.1 not yet executed (77 lines). |
| `_skills_candidates.md` | Reference | Skill candidates log — scaffold only, no entries (61 lines). |
| `_appendix/mood.md` | Appendix | Mood appendix — scaffold stub with section headers, Phase 3.1 not yet started (48 lines). |
| `_appendix/references.md` | Appendix | References appendix — scaffold stub, Phase 1.1 not yet started (44 lines). |
| `_appendix/rejected_directions.md` | Appendix | Rejected directions log — scaffold with format instructions only (17 lines). |
| `logs/session-notes.md` | Logs | Session notes — one entry (today's session, 2026-05-25) (9 lines). |
| `logs/decisions.md` | Logs | Decisions log — template only, no entries (19 lines). |
| `.claude/shared-manifest.json` | Config | Declares project-local vs. shared command/agent split (9 lines). |

### 1.7 Symlinks

Total symlinks in AUDIT_ROOT: 82. All 82 resolve successfully. No broken symlinks.

**Symlink path styles:**
- 76 symlinks use relative paths (format: `../../../../ai-resources/.claude/{type}/{file}.md`)
- 6 symlinks use absolute paths (format: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/{type}/{file}.md`)

**Absolute-path symlinks (6):**

| Symlink | Target |
|---------|--------|
| `.claude/agents/fading-gate-scanner.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/fading-gate-scanner.md` |
| `.claude/agents/friday-act-16a-summarizer.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/friday-act-16a-summarizer.md` |
| `.claude/commands/drift-check.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/drift-check.md` |
| `.claude/commands/grill-me.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/grill-me.md` |
| `.claude/commands/handoff.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/handoff.md` |
| `.claude/commands/resolve-repo-problem.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-repo-problem.md` |

All 6 absolute-path symlinks resolve correctly. All 76 relative-path symlinks resolve correctly. All 82 targets exist in ai-resources (external to AUDIT_ROOT — expected).

Section summary: 135 items catalogued (39 regular files + 82 symlinks + 14 directories, excluding .git) / No previous audit.

---

## Section 2: CLAUDE.md Health

### 2.1 CLAUDE.md line count and sections

Project CLAUDE.md (`projects/axcion-brand-book/CLAUDE.md`): **70 lines**, **8 sections**.

Section headings:
1. *(title only — no section heading for opening paragraph)*
2. `## Model Selection`
3. `## Project structure pointers`
4. `## Current state`
5. `## Project-local commands (not synced from ai-resources)`
6. `## Input File Handling`
7. `## Commit Rules`
8. `## Compaction`
9. `## Session Boundaries`

(8 distinct `##` headings, plus an untitled opening paragraph.)

### 2.2 Dead references in CLAUDE.md

| Reference | Location | Exists? | Notes |
|-----------|----------|---------|-------|
| `references/phase-workflow.md` | Line 13 | YES | File exists at expected path |
| `references/module-template.md` | Line 14 | YES | File exists at expected path |
| `references/scoping-note-rubric.md` | Line 15 | YES | File exists at expected path |
| `references/tagging-conventions.md` | Line 16 | YES | File exists at expected path |
| `references/mockup-conventions.md` | Line 17 | YES | File exists at expected path |
| `references/source-map-format.md` | Line 18 | YES | File exists at expected path |
| `references/module-sequence.md` | Line 19 | YES | File exists at expected path |
| `pipeline/module-status.md` | Line 23 | YES | File exists at expected path |
| `.claude/agents/brand-strategist.md` | Line 24 | YES | File exists at expected path |
| `_consultants/brand_strategist.md` | Line 24 | YES | File exists but is a scaffold stub — Phase 0.1 not executed |
| `source_map.md` | Line 25 | YES | File exists but is scaffold placeholder (0 of 13 artifacts indexed) |
| `.claude/shared-manifest.json` | Line 34 | YES | File exists at expected path |
| `workspace CLAUDE.md` | Line 7, 47, 55 | YES (external) | Cross-reference to workspace root CLAUDE.md — external to AUDIT_ROOT |
| `ai-resources/docs/...` | Various | External | Referenced via workspace CLAUDE.md cross-pointers; outside AUDIT_ROOT |

No dead references found. All files referenced by CLAUDE.md exist. Checked each path against filesystem.

### 2.3 Contradictions in CLAUDE.md

None found — checked all sections against each other. No conflicting statements identified.

**One inaccuracy (not a contradiction):** Line 24 describes `_consultants/brand_strategist.md` as "(long-form validated reference)" but the file's own `**Status:**` field reads "Scaffold (Phase 0.1 deliverable — built out and validated manually during the first Phase 0 session)." The file is a scaffold with build instructions; Phase 0.1 has not been executed. The description in CLAUDE.md implies the file is already validated; it is not.

**One inaccuracy (not a contradiction):** Line 25 describes `source_map.md` as "the 13 corporate identity artifacts indexed." The file's current state is "Artifact count: 0 of 13" with all rows as scaffold placeholders. The 13 artifacts have not been provided or indexed.

### 2.4 Conventions defined in CLAUDE.md not followed by actual files

| Convention | Files That Would Violate It |
|------------|---------------------------|
| Outputs written via `Write` into `output/{project}/` (Input File Handling section, line 43) | No module outputs exist yet — expected for Phase 0. Not a violation at this stage. |
| "When iterating, create a new version file rather than overwriting — `v2.md` alongside `v1.md` in the same `output/{project}/` directory" (from workspace CLAUDE.md, inherited by project) | No output files yet — expected for Phase 0. Not a violation. |

None found — checked actual file patterns against all conventions defined in project CLAUDE.md. No violations at current project phase.

### 2.5 Partially-referenced features (file exists but companion file missing)

None found — checked all feature references:
- Strategist: both `.claude/agents/brand-strategist.md` (runtime) and `_consultants/brand_strategist.md` (companion) exist. The companion is a scaffold stub, not missing.
- All 4 project-local commands exist as regular files.
- All 7 reference docs in `references/` exist.
- `source_map.md` exists (scaffold stub).
- `pipeline/module-status.md` exists.
- `session-guide-generator` skill referenced in `pipeline/module-status.md` — verified to exist at `ai-resources/skills/session-guide-generator/` (external to AUDIT_ROOT; resolvable via symlinked `/session-guide` command).

### 2.6 CLAUDE.md sections containing task-type-specific methodology that belongs in SKILL.md or workflow reference docs

| Section | Line Count (approx) | Task Type | Notes |
|---------|-------------------|-----------|-------|
| `## Input File Handling` | ~18 lines | File-handling methodology | Duplicated verbatim from workspace CLAUDE.md. The file itself states "This rule mirrors the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded." Per workspace CLAUDE.md § CLAUDE.md Scoping, canonical workspace rules should be short pointers, not verbatim duplications. |
| `## Commit Rules` | ~7 lines | Git commit methodology | Duplicated verbatim from workspace CLAUDE.md. Same self-annotation: "This rule mirrors the canonical `Commit behavior` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded." Same scoping-rule concern as above. |
| `## Compaction` | ~9 lines | Compaction protocol | Not present in workspace CLAUDE.md as a project CLAUDE.md entry. Contains operational instructions for compaction behavior. Workspace CLAUDE.md references `ai-resources/docs/compaction-protocol.md` for full rules. |

Section summary: 2 inaccuracies in CLAUDE.md (lines 24 and 25 describe scaffold stubs as completed artifacts); 2 sections (Input File Handling, Commit Rules) are verbatim duplications of workspace rules rather than pointers, per the CLAUDE.md Scoping rule / 0 deltas from previous audit.

---

## Section 3: Dependency References

### 3.1 Files referenced by each project-local slash command and existence status

**`/scope-module`:**

| Referenced File | Exists |
|----------------|--------|
| `references/module-sequence.md` | Y |
| `pipeline/module-status.md` | Y |
| `source_map.md` | Y (scaffold) |
| `references/scoping-note-rubric.md` | Y |
| `references/phase-workflow.md` | Y |
| `references/module-template.md` | Y |
| `pipeline/context-pack.md` | Y |
| `pipeline/project-plan.md` | Y |
| `brand-book/_scoping/{module-id}-scoping.md` (output) | N — expected; written by command at runtime |
| `_appendix/rejected_directions.md` (output) | Y (scaffold) |
| `_consultants/brand_strategist.md` (Phase 0 prerequisite check) | Y (scaffold stub) |

**`/draft-module`:**

| Referenced File | Exists |
|----------------|--------|
| `pipeline/module-status.md` | Y |
| `brand-book/_scoping/{module-id}-scoping.md` | N — produced by `/scope-module`; expected absent at Phase 0 |
| `source_map.md` | Y (scaffold, 0 of 13) |
| `references/module-sequence.md` | Y |
| `pipeline/context-pack.md` | Y |
| `references/module-template.md` | Y |
| `references/tagging-conventions.md` | Y |
| `references/mockup-conventions.md` | Y |
| `brand-book/{module-id}.md` (output) | N — expected; written by command |
| `mockups/{module-id}/*.{html,svg}` (output) | N — expected; written by command |

**`/qc-module`:**

| Referenced File | Exists |
|----------------|--------|
| `brand-book/{module-id}.md` (input) | N — produced by `/draft-module`; expected absent at Phase 0 |
| `source_map.md` | Y (scaffold) |
| `references/tagging-conventions.md` | Y |
| `references/mockup-conventions.md` | Y |
| `pipeline/context-pack.md` | Y |
| `logs/qc-reports/{module-id}-{date}.md` (output) | N — expected; written by command |
| `pipeline/module-status.md` (output) | Y |

**`/lock-module`:**

| Referenced File | Exists |
|----------------|--------|
| `logs/qc-reports/{module-id}-*.md` (input) | N — produced by `/qc-module`; expected absent at Phase 0 |
| `brand-book/{module-id}.md` (input/output) | N — expected absent at Phase 0 |
| `references/module-sequence.md` | Y |
| `pipeline/module-status.md` (output) | Y |

All absent files are Phase 1+ runtime outputs. No missing input dependencies for the current Phase 0 state.

### 3.2 Command output chains

| Chain | Description |
|-------|-------------|
| `/scope-module` → `/draft-module` | `/scope-module` produces `brand-book/_scoping/{module-id}-scoping.md`; `/draft-module` Step 1 verifies it exists and reads it as primary spec input. |
| `/draft-module` → `/qc-module` | `/draft-module` produces `brand-book/{module-id}.md` and `mockups/{module-id}/*.{html,svg}`; `/qc-module` takes `brand-book/{module-id}.md` as its `$ARGUMENTS` input. |
| `/qc-module` → `/triage` | `/qc-module` Step 6 invokes `/triage` (ai-resources shared command) with the QC report path when verdict is FAIL. |
| `/qc-module` → `/lock-module` | `/qc-module` produces `logs/qc-reports/{module-id}-{date}.md`; `/lock-module` Step 2 reads the most recent QC report for that module and verifies PASS verdict. |
| `/lock-module` → (next `/scope-module`)` | `/lock-module` computes which downstream modules become unblocked; announces module IDs ready for `/scope-module`. |

### 3.3 Files referenced by more than one command, hook, or script

| File | Referenced By |
|------|--------------|
| `pipeline/module-status.md` | `/scope-module` (read + write), `/draft-module` (read + write), `/qc-module` (read + write), `/lock-module` (read + write), `session-guide` (read, external command) |
| `source_map.md` | `/scope-module` (read), `/draft-module` (read), `/qc-module` (read — for LOCKED tag verification) |
| `references/module-sequence.md` | `/scope-module` (read — upstream check), `/lock-module` (read — downstream compute) |
| `references/module-template.md` | `/draft-module` (read — template structure), `/qc-module` (read — Section 10 location) |
| `references/tagging-conventions.md` | `/draft-module` (read — tag application), `/qc-module` (read — tag compliance check) |
| `references/mockup-conventions.md` | `/draft-module` (read — visual modules only), `/qc-module` (read — spec-match check) |
| `pipeline/context-pack.md` | `/scope-module` (read — project brief), `/draft-module` (read — project brief) |

### 3.4 Files ranked by number of downstream references (top 10, within AUDIT_ROOT)

| Rank | File | Reference Count | Referenced By |
|------|------|----------------|---------------|
| 1 | `pipeline/module-status.md` | 5 | `/scope-module`, `/draft-module`, `/qc-module`, `/lock-module`, `session-guide` (external) |
| 2 | `source_map.md` | 3 | `/scope-module`, `/draft-module`, `/qc-module` |
| 3 | `references/module-sequence.md` | 2 | `/scope-module`, `/lock-module` |
| 3 | `references/module-template.md` | 2 | `/draft-module`, `/qc-module` |
| 3 | `references/tagging-conventions.md` | 2 | `/draft-module`, `/qc-module` |
| 3 | `references/mockup-conventions.md` | 2 | `/draft-module`, `/qc-module` |
| 3 | `pipeline/context-pack.md` | 2 | `/scope-module`, `/draft-module` |
| 8 | `references/scoping-note-rubric.md` | 1 | `/scope-module` |
| 8 | `references/phase-workflow.md` | 1 | `/scope-module` |
| 8 | `pipeline/project-plan.md` | 1 | `/scope-module` |

### 3.5 Symlinks in `.claude/commands/` or `.claude/agents/` with targets outside this repo — permissions coverage check

All 82 symlinks (79 in `.claude/commands/`, 1 in `.claude/agents/brand-strategist.md` is a regular file, 23 in `.claude/agents/`) point to targets under `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/`.

`permissions.additionalDirectories` in `.claude/settings.json` contains one entry: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`.

String-prefix check: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` is an ancestor of `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/` — covered.

**All 82 external symlink targets are covered by `additionalDirectories`.**

No `.claude/settings.local.json` exists in AUDIT_ROOT to check.

### 3.6 Projects referencing ai-resources without it listed in `additionalDirectories`

**Within AUDIT_ROOT:** The project references ai-resources via 82 symlinks and via the SessionStart auto-sync hook. `additionalDirectories` lists `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` which covers the ai-resources path as a descendant.

No missing entry.

Section summary: 0 issues flagged / No previous audit.

---

## Section 4: Consistency Checks

### 4.1 Skill structural pattern consistency

N/A — No skills exist within AUDIT_ROOT. AUDIT_ROOT contains 0 skill files.

### 4.2 Slash command definition pattern consistency

The 4 project-local commands all follow the same pattern:
- YAML frontmatter with `description:`, `model:`, and `argument-hint:` fields
- Numbered step structure (`## Step N: ...`)
- Explicit argument validation in Step 1
- Explicit file read/write operations with named paths
- Completion announcement in final step

All 4 project-local commands conform to this pattern. No deviations.

**Model declarations:**
- `/scope-module`: `model: sonnet`
- `/draft-module`: `model: opus`
- `/qc-module`: `model: sonnet`
- `/lock-module`: `model: sonnet`

All 4 have explicit `model:` frontmatter. No inheritance. Consistent with workspace Model Tier rule.

### 4.3 Skill template vs. actual skill comparison

N/A — No skill creation template file exists within AUDIT_ROOT. Skills are created via `/create-skill` which references ai-resource-builder/SKILL.md for format standards. No skills exist within this project.

### 4.4 Naming convention inconsistencies

**File naming conventions in use:**
- Commands: `kebab-case.md` — all 4 project-local commands follow this. Consistent.
- Agent: `brand-strategist.md` (kebab-case) — consistent with shared agents.
- `_consultants/brand_strategist.md`: uses underscore rather than hyphen separator. This file is NOT a Claude Code agent definition — it is a project documentation file. The naming convention for documentation files is not explicitly defined in CLAUDE.md or any reference doc within AUDIT_ROOT.
- References: `kebab-case.md` — all 7 reference files follow this. Consistent.
- Mockups (per `references/mockup-conventions.md` OD-2): `{NN}-{descriptor}.{html|svg}` — no mockup files exist yet; convention not applicable.

**Inconsistency found:** `.claude/agents/brand-strategist.md` (kebab-case, the runtime agent) vs. `_consultants/brand_strategist.md` (underscore, the companion reference). These are different file categories (agent definition vs. documentation), so the inconsistency is cross-category, not within a single file type.

### 4.5 Directory structure violations

Defined structure (from `pipeline/context-pack.md` §6, `pipeline/architecture.md`, and `pipeline/implementation-spec.md`):

```
brand-book/
  {module-id}.md         — module drafts (Phase 1+ output)
  _scoping/              — scoping notes (Phase 0 output)
mockups/
  {module-id}/           — mockup files (Phase 1 output)
logs/
  session-notes.md
  decisions.md
  qc-reports/            — QC reports (Phase 2 output)
pipeline/                — read-only scaffold artifacts
_appendix/
_consultants/
references/
source_map.md
```

**Current state vs. defined structure:**

| Expected Path | Exists | Notes |
|--------------|--------|-------|
| `brand-book/_scoping/` | YES (empty, `.gitkeep`) | Expected empty at Phase 0 |
| `mockups/` | YES (empty, `.gitkeep`) | Expected empty at Phase 0 |
| `logs/qc-reports/` | YES (empty, `.gitkeep`) | Expected empty at Phase 0 |
| `_inputs/corporate-identity/` | NO | Expected absent — SESSION-GUIDE.md explicitly notes it does not exist; Patrik creates it when providing artifacts |
| `brand-book/{module-id}.md` files | NO | Expected absent at Phase 0 |

No violations found. All absences are expected for current project phase.

### 4.6 Command syntax and referenced file path resolution

All 4 project-local commands verified:

| Command | Syntax Valid | Referenced Paths Resolve |
|---------|-------------|------------------------|
| `/scope-module` | YES | YES — all static input paths exist; runtime output paths absent as expected |
| `/draft-module` | YES | YES — all static input paths exist; runtime paths absent as expected |
| `/qc-module` | YES | YES — all static input paths exist; accepts `brand-book/*.md` pattern as `$ARGUMENTS` |
| `/lock-module` | YES | YES — all static input paths exist; reads QC report by glob `{module-id}-*.md` |

**Note on `/qc-module` argument pattern:** Step 1 validates `$ARGUMENTS` matches pattern `brand-book/*.md`. The command's `argument-hint` is `<module-path>`. CLAUDE.md line 31 shows usage as `/qc-module brand-book/{id}.md` — consistent.

### 4.7 Duplicate or built-in command name conflicts

No duplicate command names within the project's command set. All 4 project-local command names (`scope-module`, `draft-module`, `qc-module`, `lock-module`) are project-specific and do not collide with any of the 75 shared symlinked commands.

No conflicts with known Claude Code built-in commands (none of the 4 names match built-in Claude Code slash commands).

### 4.8 Agent model tier vs. Agent Tier Table

The Agent Tier Table (`ai-resources/docs/agent-tier-table.md`) does not contain a section for project-local agents in `projects/axcion-brand-book/`. The table has sections for ai-resources agents, ai-development-lab project-local agents, and nordic-pe-macro-landscape project-local agents — but not for axcion-brand-book.

| Agent File | Declared Tier | Expected Tier per Table | Status |
|------------|--------------|------------------------|--------|
| `.claude/agents/brand-strategist.md` | `model: opus` | Not in table — project-local agent not registered | Not in Agent Tier Table |

The 22 shared agents (symlinks to ai-resources) are all in the Agent Tier Table with correct declared tiers — verification of ai-resources agent tiers is outside AUDIT_ROOT scope for this audit; the symlinked files are external references.

**`brand-strategist` is not registered in the Agent Tier Table.** The table's maintenance instructions state: "When adding a new agent, place it in the table." Project-local agents in two other projects (ai-development-lab, nordic-pe-macro-landscape) have sections in the table. axcion-brand-book does not.

### 4.9 `.claude/settings.json` vs. canonical `new-project.md` baseline

**Canonical CANONICAL_PERMS deny entries** (from `new-project.md` ~line 281-288):
```
"Bash(git push*)", "Bash(rm -rf *)", "Bash(sudo *)",
"Read(archive/**)", "Read(**/*.archive.*)", "Read(**/deprecated/**)", "Read(**/old/**)"
```

**Brand-book `.claude/settings.json` deny entries:**
```
"Bash(git push*)", "Bash(rm -rf *)", "Bash(sudo *)",
"Write(./pipeline/**)", "Edit(./pipeline/**)", "Write(./brand-book/**)", "Edit(./brand-book/**)"
```

| Canonical Deny Entry | Present in Project |
|---------------------|-------------------|
| `Bash(git push*)` | YES |
| `Bash(rm -rf *)` | YES |
| `Bash(sudo *)` | YES |
| `Read(archive/**)` | NO |
| `Read(**/*.archive.*)` | NO |
| `Read(**/deprecated/**)` | NO |
| `Read(**/old/**)` | NO |

**Missing canonical deny entries:** `Read(archive/**)`, `Read(**/*.archive.*)`, `Read(**/deprecated/**)`, `Read(**/old/**)` — all four `Read` deny entries from the canonical baseline are absent. The brand-book project substitutes write-protect patterns (`Write(./pipeline/**)`, `Edit(./pipeline/**)`, `Write(./brand-book/**)`, `Edit(./brand-book/**)`) which are project-specific additions not in the canonical baseline.

**`"model": "sonnet"` top-level declaration:** Not present in brand-book `settings.json`. The canonical `new-project.md` line 160 references declaring a model in `settings.local.json` (gitignored), not `settings.json`. No `settings.local.json` exists in AUDIT_ROOT. Per workspace CLAUDE.md § Model Tier, model defaults are **prohibited** in `settings.json` and `settings.local.json`. The canonical `new-project.md` guidance (line ~160) itself directs the model declaration into `settings.local.json` with instructions that this is per-operator. The absence of a `"model"` field in `settings.json` is correct per workspace rule.

**Date comparison:**
- Brand-book `.claude/settings.json` most recent commit: 2026-05-22
- `new-project.md` most recent commit: 2026-05-25 (3 days after the brand-book settings.json was last touched)

The brand-book settings.json was created on 2026-05-19 and last modified 2026-05-22. The `new-project.md` had a commit on 2026-05-25, indicating the canonical baseline may have changed after the project was scaffolded.

Section summary: 3 issues flagged (brand-strategist missing from Agent Tier Table; 4 canonical Read deny entries absent from settings.json; 2 CLAUDE.md inaccuracies noted in Section 2) / No previous audit.

---

## Section 5: Context Load

### 5.1 Total context loaded when a new session starts (line count estimate)

| File | Line Count | Load Mechanism |
|------|-----------|----------------|
| Workspace CLAUDE.md | 174 | Auto-loaded as workspace root context |
| Project CLAUDE.md | 70 | Auto-loaded as project context |
| **Subtotal (auto-loaded)** | **244** | |

**SessionStart hooks:** Both hooks run shell scripts (`auto-sync-shared.sh`, `check-permission-sanity.sh`) that do not load file content into context. They produce terminal output only.

**No other files are auto-loaded.** CLAUDE.md does not contain `@` include directives. No `.claude/references/` directory exists in AUDIT_ROOT.

Estimated auto-load context: **~244 lines** (workspace CLAUDE.md 174 + project CLAUDE.md 70).

### 5.2 CLAUDE.md sections not referenced by any slash command, hook, or operational instruction

| Section | Line Count (approx) | Referenced By | Assessment |
|---------|-------------------|--------------|------------|
| `## Model Selection` | ~9 lines | Not referenced by any command or hook — orientation for operator/Claude at session start | Used for session-start orientation only |
| `## Compaction` | ~9 lines | Not referenced by any command or hook — activated by operator `/compact` invocation | Used for compaction events |
| `## Session Boundaries` | ~2 lines | Not referenced by any command or hook — guidance for operator behavior | Operator guidance |

All other sections are referenced by or describe project-local commands (`## Project structure pointers`, `## Current state`, `## Project-local commands`), workspace-level operational rules (`## Input File Handling`, `## Commit Rules`), or are self-explaining.

### 5.3 CLAUDE.md line count at last 5 commits touching it

| Commit Hash | Date | Commit Message | CLAUDE.md Line Count |
|-------------|------|----------------|---------------------|
| 7aba2bb | 2026-05-19 | init: initial commit — axcion-brand-book project | 70 |

Only 1 commit touches CLAUDE.md (the initial commit). The file has not been modified since project creation. The last 5 commits touching CLAUDE.md: only 1 exists.

Section summary: 0 issues flagged / No previous audit.

---

## Section 6: Drift & Staleness

### 6.1 Files not modified in last 90 days but still referenced by active commands/hooks/CLAUDE.md

**90-day window:** 2026-02-24 to 2026-05-25.

All files in AUDIT_ROOT were created in the initial commit on 2026-05-19 (6 days before audit date) or in the subsequent commit on 2026-05-22 (3 days before audit date). No files are older than 6 days.

None found — checked all files; all are within the 90-day window.

### 6.2 TODO, FIXME, PLACEHOLDER markers in any file

The following files contain literal placeholder text (not the word "placeholder" as part of documentation or convention-defining prose, but unfilled template slots):

| File | Line(s) | Content |
|------|---------|---------|
| `pipeline/module-status.md` | Line 4 | `{YYYY-MM-DD — initial scaffold; updated by \`/scope-module\`, ...}` — literal template string in "Last updated" field. Confirmed intentional scaffold state (noted as WARN-1 in `pipeline/test-results.md` and `SESSION-GUIDE.md`). |
| `source_map.md` | Lines 13–25 | All 13 artifact rows contain `_to be populated_` for all three columns. Confirmed scaffold state — Phase 0.2 prerequisite not yet executed. |
| `source_map.md` | Lines 29–43, 47–55 | Governance-domain and module-coverage check tables: all entries `_to be populated_` or `[GAP]`. Confirmed scaffold state. |
| `_consultants/brand_strategist.md` | Lines 23–75 | Section bodies contain build instructions in italic (e.g., `_Reproduce the seven domains from the agent definition. Then add:_`) — scaffold instructions, not populated content. Phase 0.1 not yet executed. |
| `_appendix/mood.md` | All content | Three section headers with `_(Populated during 3.N ...)_` stubs. Phase 3.1 not yet reached. |
| `_appendix/references.md` | All section bodies | Section headers with unpopulated stubs. Phase 1.1 not yet started. |
| `_appendix/rejected_directions.md` | Lines 9–11 | Entries section contains only format instructions in italic. No entries yet — expected; no modules have been scoped. |
| `_skills_candidates.md` | All content after format instructions | No candidates recorded yet. Expected — project not yet started. |
| `logs/decisions.md` | All content | Template format only — no decision entries. Expected — no cross-session decisions logged yet. |

All placeholder instances above are intentional scaffold state for a Phase 0 project. None represent unexpected gaps.

**One WARN-level placeholder noted separately:** `pipeline/module-status.md` line 4 "Last updated" header is a literal template string. If any tooling parses this field as a date, it will fail. Confirmed advisory-only per `pipeline/test-results.md` WARN-1.

### 6.3 Empty files, stub files, or files containing only boilerplate with no real content

| File | State | Notes |
|------|-------|-------|
| `brand-book/_scoping/.gitkeep` | Empty (0 bytes) | Intentional empty placeholder to keep directory in git |
| `mockups/.gitkeep` | Empty (0 bytes) | Intentional empty placeholder |
| `logs/.gitkeep` | Empty (0 bytes) | Intentional empty placeholder |
| `logs/qc-reports/.gitkeep` | Empty (0 bytes) | Intentional empty placeholder |
| `_consultants/brand_strategist.md` | Scaffold stub (77 lines) | Contains section headers + build instructions, no substantive content. Phase 0.1 prerequisite. |
| `_appendix/mood.md` | Scaffold stub (48 lines) | Section headers + `_(Populated during ...)_` placeholders only. Phase 3.1 prerequisite. |
| `_appendix/references.md` | Scaffold stub (44 lines) | Section headers only, no content. Phase 1.1 prerequisite. |
| `_appendix/rejected_directions.md` | Scaffold stub (17 lines) | Format instructions only, no entries. Expected. |
| `_skills_candidates.md` | Scaffold stub (61 lines) | Format instructions only, no candidates. Expected. |
| `logs/decisions.md` | Template only (19 lines) | Decision template format, no entries. Expected. |
| `source_map.md` | Scaffold stub (78 lines) | 0 of 13 artifacts indexed. Phase 0.2 prerequisite. |

All empty and stub files are expected for the current project phase (Phase 0 — no module work has begun). No unexpected empty files found.

Section summary: 0 issues flagged (all placeholder and stub content is intentional scaffold state for a Phase 0 project) / No previous audit.

---

## Appendix: Additional Findings Not Captured in Questionnaire Sections

### A1: Write-protect deny rules vs. module command write paths

The `.claude/settings.json` deny list includes `Write(./pipeline/**)` and `Edit(./pipeline/**)`. All 4 project-local commands (`/scope-module` Step 8, `/draft-module` Step 6, `/qc-module` Step 8, `/lock-module` Step 5) write to `pipeline/module-status.md`.

Per `pipeline/implementation-spec.md` §OD-1 (lines ~2119–2121): "The `Write(./pipeline/**)` and `Write(./brand-book/**)` deny patterns operate under the bypassPermissions default — they surface a confirmation prompt for direct manual edits but do not hard-block command-internal writes from `/scope-module`, `/draft-module`, etc. This is the intended UX (OD-1)."

The deny patterns are intentional friction-nudges, not hard blocks. Documented in `pipeline/implementation-spec.md` and `pipeline/decisions.md` (D8). This is consistent with `defaultMode: "bypassPermissions"` in settings.json.

### A2: `brand-strategist` agent not in Agent Tier Table

Per Section 4.8: `brand-strategist` (project-local to axcion-brand-book) is declared `model: opus` in frontmatter but is not registered in `ai-resources/docs/agent-tier-table.md`. Other project-local agents (ai-development-lab, nordic-pe-macro-landscape) have dedicated sections in the table. The table's maintenance instructions require registration.

### A3: 6 absolute-path symlinks vs. 76 relative-path symlinks

6 symlinks in `.claude/commands/` and `.claude/agents/` use absolute paths; 76 use relative paths. All 82 resolve correctly. The mixed style does not cause functional issues but is inconsistent. Absolute-path symlinks will break if the workspace is relocated. The 6 absolute-path symlinks are: `fading-gate-scanner.md` (agent), `friday-act-16a-summarizer.md` (agent), `drift-check.md`, `grill-me.md`, `handoff.md`, `resolve-repo-problem.md` (commands).

### A4: `SESSION-GUIDE.md` not referenced in `CLAUDE.md`

`SESSION-GUIDE.md` (141 lines) exists at project root and contains a detailed session orientation guide. It is not referenced anywhere in `CLAUDE.md`. CLAUDE.md line 23 references `pipeline/module-status.md` as the canonical session-N orientation document. `SESSION-GUIDE.md` contains a "Fresh Claude orientation (session start checklist)" section that partially overlaps with what `pipeline/module-status.md` and a `/session-guide` run would provide. The file's relationship to CLAUDE.md's session-start guidance is not defined in any project document within AUDIT_ROOT.

### A5: `pipeline/module-status.md` "Last updated" header is a literal template string

Documented as WARN-1 in `pipeline/test-results.md` and `SESSION-GUIDE.md`. The field reads `{YYYY-MM-DD — initial scaffold; updated by `/scope-module`, `/draft-module`, `/qc-module`, `/lock-module` automatically}`. If `session-guide-generator` skill parses this header field as a date, it will fail. The test results note the skill should key off per-module date columns instead. No file change was made at scaffold time.
