# Repo Due Diligence Audit — 2026-04-27
Repo: projects/repo-documentation
Scope: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation
Commit: e72aeee (main repo HEAD, 2026-04-25)
Previous audit: None
First audit for this scope.

---

## Section 1: Inventory

### 1.1 Slash commands defined

| Command | Defined At | Files Referenced |
|---|---|---|
| `/archaeology` | `.claude/commands/archaeology.md` (regular file — project-local) | `ai-resources/scripts/skill-inventory.sh` (optional shell-out); `ai-resources/scripts/repo-audit.sh` (optional); writes to `output/phase-1/inventory/components.md`, `fragments.md`, `phase-2-prototypes.md`, `complexity-signal.md` |
| `/analyze-workflow` | `.claude/commands/analyze-workflow.md` (symlink → `ai-resources/.claude/commands/analyze-workflow.md`) | External target — not audited within this scope |
| `/audit-claude-md` | `.claude/commands/audit-claude-md.md` (symlink → `ai-resources/.claude/commands/audit-claude-md.md`) | External target |
| `/audit-critical-resources` | `.claude/commands/audit-critical-resources.md` (symlink → `ai-resources/.claude/commands/audit-critical-resources.md`) | External target |
| `/audit-repo` | `.claude/commands/audit-repo.md` (symlink → `ai-resources/.claude/commands/audit-repo.md`) | External target |
| `/clarify` | `.claude/commands/clarify.md` (symlink → `ai-resources/.claude/commands/clarify.md`) | External target |
| `/cleanup-worktree` | `.claude/commands/cleanup-worktree.md` (symlink → `ai-resources/.claude/commands/cleanup-worktree.md`) | External target |
| `/coach` | `.claude/commands/coach.md` (symlink → `ai-resources/.claude/commands/coach.md`) | External target |
| `/create-skill` | `.claude/commands/create-skill.md` (symlink → `ai-resources/.claude/commands/create-skill.md`) | External target |
| `/friction-log` | `.claude/commands/friction-log.md` (symlink → `ai-resources/.claude/commands/friction-log.md`) | External target |
| `/friday-act` | `.claude/commands/friday-act.md` (symlink → `ai-resources/.claude/commands/friday-act.md`) | External target |
| `/friday-checkup` | `.claude/commands/friday-checkup.md` (symlink → `ai-resources/.claude/commands/friday-checkup.md`) | External target |
| `/graduate-resource` | `.claude/commands/graduate-resource.md` (symlink → `ai-resources/.claude/commands/graduate-resource.md`) | External target |
| `/improve` | `.claude/commands/improve.md` (symlink → `ai-resources/.claude/commands/improve.md`) | External target |
| `/improve-skill` | `.claude/commands/improve-skill.md` (symlink → `ai-resources/.claude/commands/improve-skill.md`) | External target |
| `/migrate-skill` | `.claude/commands/migrate-skill.md` (symlink → `ai-resources/.claude/commands/migrate-skill.md`) | External target |
| `/note` | `.claude/commands/note.md` (symlink → `ai-resources/.claude/commands/note.md`) | External target |
| `/permission-sweep` | `.claude/commands/permission-sweep.md` (symlink → `ai-resources/.claude/commands/permission-sweep.md`) | External target |
| `/prime` | `.claude/commands/prime.md` (symlink → `ai-resources/.claude/commands/prime.md`) | External target |
| `/project-consultant` | `.claude/commands/project-consultant.md` (symlink → `ai-resources/.claude/commands/project-consultant.md`) | External target |
| `/qc-pass` | `.claude/commands/qc-pass.md` (symlink → `ai-resources/.claude/commands/qc-pass.md`) | External target |
| `/recommend` | `.claude/commands/recommend.md` (symlink → `ai-resources/.claude/commands/recommend.md`) | External target |
| `/refinement-deep` | `.claude/commands/refinement-deep.md` (symlink → `ai-resources/.claude/commands/refinement-deep.md`) | External target |
| `/refinement-pass` | `.claude/commands/refinement-pass.md` (symlink → `ai-resources/.claude/commands/refinement-pass.md`) | External target |
| `/repo-dd` | `.claude/commands/repo-dd.md` (symlink → `ai-resources/.claude/commands/repo-dd.md`) | External target |
| `/request-skill` | `.claude/commands/request-skill.md` (symlink → `ai-resources/.claude/commands/request-skill.md`) | External target |
| `/resolve-improvements` | `.claude/commands/resolve-improvements.md` (symlink → `ai-resources/.claude/commands/resolve-improvements.md`) | External target |
| `/risk-check` | `.claude/commands/risk-check.md` (symlink → `ai-resources/.claude/commands/risk-check.md`) | External target |
| `/route-change` | `.claude/commands/route-change.md` (symlink → `ai-resources/.claude/commands/route-change.md`) | External target |
| `/scope` | `.claude/commands/scope.md` (symlink → `ai-resources/.claude/commands/scope.md`) | External target |
| `/session-guide` | `.claude/commands/session-guide.md` (symlink → `ai-resources/.claude/commands/session-guide.md`) | External target |
| `/summary` | `.claude/commands/summary.md` (symlink → `ai-resources/.claude/commands/summary.md`) | External target |
| `/sync-workflow` | `.claude/commands/sync-workflow.md` (symlink → `ai-resources/.claude/commands/sync-workflow.md`) | External target |
| `/token-audit` | `.claude/commands/token-audit.md` (symlink → `ai-resources/.claude/commands/token-audit.md`) | External target |
| `/triage` | `.claude/commands/triage.md` (symlink → `ai-resources/.claude/commands/triage.md`) | External target |
| `/update-claude-md` | `.claude/commands/update-claude-md.md` (symlink → `ai-resources/.claude/commands/update-claude-md.md`) | External target |
| `/usage-analysis` | `.claude/commands/usage-analysis.md` (symlink → `ai-resources/.claude/commands/usage-analysis.md`) | External target |
| `/wrap-session` | `.claude/commands/wrap-session.md` (symlink → `ai-resources/.claude/commands/wrap-session.md`) | External target |

Total: 38 commands (1 project-local regular file; 37 symlinks to `ai-resources/.claude/commands/`). All 37 symlink targets exist and are accessible.

Section summary: 38 items catalogued / First audit — no delta.

### 1.2 Hooks configured

**`.claude/settings.json` — SessionStart hook:**

| Trigger | What it does | Files referenced |
|---|---|---|
| `SessionStart` | Shell walker climbs from `$CLAUDE_PROJECT_DIR` to find and execute `ai-resources/.claude/hooks/auto-sync-shared.sh` | `ai-resources/.claude/hooks/auto-sync-shared.sh` (absolute path resolved at runtime) |

The hook command is: `d="$CLAUDE_PROJECT_DIR"; while [ "$d" != "/" ]; do d=$(dirname "$d"); [ -x "$d/ai-resources/.claude/hooks/auto-sync-shared.sh" ] && { "$d/ai-resources/.claude/hooks/auto-sync-shared.sh"; exit; }; done`

`auto-sync-shared.sh` exists at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/auto-sync-shared.sh` and is executable (`-rwxr-xr-x`).

**`.claude/hooks/` directory:** Contains only `.gitkeep`. No hook scripts defined in the project directory itself.

**`.claude/settings.local.json`:** No hooks defined (file contains only `{"model": "claude-sonnet-4-6[1m]"}`).

Section summary: 1 hook configured / First audit — no delta.

### 1.3 Template files

| File Path | Purpose | Used By | Last Commit Date |
|---|---|---|---|
| `references/documentation-structure.md` | Skeleton placeholder for M1.3 documentation structure spec. Single source of truth for TOC, section conventions, principle ID scheme, component-description schema once filled. | M1.3 (drafts it), M1.4 (drafts against), M1.5 (verifies against), M2.P (Phase 2 design input), Phase 2 W2.1/W2.2 (machine-parseable shape) | 2026-04-25 |

Status of `references/documentation-structure.md`: **SKELETON** — all content sections contain `[POPULATED IN M1.3]` or `[POPULATED IN M2.P — Phase 2 second planning round]` placeholders. Not yet filled by M1.3.

Section summary: 1 template file catalogued / First audit — no delta.

### 1.4 Scripts

None found — checked all files in AUDIT_ROOT. The project itself contains no bash, python, or other scripts. The `/archaeology` command shells out to `ai-resources/scripts/skill-inventory.sh` and `ai-resources/scripts/repo-audit.sh` (external, outside AUDIT_ROOT scope).

Section summary: 0 scripts / First audit — no delta.

### 1.5 Skills

None found — checked all paths in AUDIT_ROOT for `SKILL.md` files. The project contains no skills. Architecture Decision D-5 in `pipeline/architecture.md` explicitly records "No new project-level skill" for Phase 1.

N/A — No skill creation template file exists. Skills are created via /create-skill which references ai-resource-builder/SKILL.md for format standards.

Section summary: 0 skills / First audit — no delta.

### 1.6 Uncategorized items

| File | Category |
|---|---|
| `pipeline/architecture.md` | Pipeline artifact (Stage 3b output) — project planning document |
| `pipeline/context-pack.md` | Pipeline artifact (Stage 3a input) — project context pack |
| `pipeline/decisions.md` | Pipeline artifact — stage-level decision log (frozen, separate from `logs/decisions.md`) |
| `pipeline/implementation-log.md` | Pipeline artifact (Stage 4 output) — implementation execution log |
| `pipeline/implementation-spec.md` | Pipeline artifact (Stage 3c output) — implementation specification |
| `pipeline/pipeline-state.md` | Pipeline artifact — stage completion tracker |
| `pipeline/project-plan.md` | Pipeline artifact (Stage 3a output) — project plan |
| `pipeline/repo-snapshot.md` | Pipeline artifact (Stage 3a output) — repo state snapshot at planning time |
| `pipeline/sources.md` | Pipeline artifact — source attribution for pipeline documents |
| `pipeline/test-results.md` | Pipeline artifact (Stage 5 output) — post-implementation test results |
| `output/session-guide.md` | Pipeline artifact (Stage 6 output) — operator session guide for Phase 1 execution |
| `logs/decisions.md` | Project execution log (append-only, currently has only placeholder row) |
| `logs/friction-log.md` | Project execution log (append-only, currently has only header/format stub) |
| `logs/session-notes.md` | Project execution log (append-only, currently has only header/format stub) |
| `inputs/.gitkeep` | Placeholder — `inputs/` directory reserved for operator-supplied input files |
| `CLAUDE.md` | Project-level persistent context |
| `.gitignore` | Git ignore rules for project |
| `.claude/settings.json` | Project Claude Code settings |
| `.claude/settings.local.json` | Per-machine model default (gitignored) |
| `.claude/shared-manifest.json` | Auto-sync hook manifest — lists project-local commands/agents |
| `.claude/agents/.gitkeep` | Placeholder — `.claude/agents/` reserved for Phase 2 subagents |
| `.claude/hooks/.gitkeep` | Placeholder — `.claude/hooks/` reserved for potential Phase 2 hooks |
| `output/phase-1/.gitkeep` | Placeholder — `output/phase-1/` awaiting M1.2–M1.5 deliverables |
| `output/phase-1/inventory/.gitkeep` | Placeholder — inventory awaiting M1.1 execution |
| `output/phase-2/.gitkeep` | Placeholder — Phase 2 passive placeholder |
| `working/archaeology/.gitkeep` | Placeholder — scratch dir for M1.1 raw outputs (gitignored contents) |
| `working/elicitation/.gitkeep` | Placeholder — scratch dir for M1.2 session notes (gitignored contents) |

Section summary: 27 uncategorized items catalogued / First audit — no delta.

### 1.7 Symlinks

**`.claude/commands/` symlinks (37 total — all point to `ai-resources/.claude/commands/`):**

| Symlink | Target | Exists |
|---|---|---|
| `.claude/commands/analyze-workflow.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/analyze-workflow.md` | Y |
| `.claude/commands/audit-claude-md.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/audit-claude-md.md` | Y |
| `.claude/commands/audit-critical-resources.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/audit-critical-resources.md` | Y |
| `.claude/commands/audit-repo.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/audit-repo.md` | Y |
| `.claude/commands/clarify.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/clarify.md` | Y |
| `.claude/commands/cleanup-worktree.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/cleanup-worktree.md` | Y |
| `.claude/commands/coach.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/coach.md` | Y |
| `.claude/commands/create-skill.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/create-skill.md` | Y |
| `.claude/commands/friction-log.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friction-log.md` | Y |
| `.claude/commands/friday-act.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-act.md` | Y |
| `.claude/commands/friday-checkup.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-checkup.md` | Y |
| `.claude/commands/graduate-resource.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/graduate-resource.md` | Y |
| `.claude/commands/improve.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/improve.md` | Y |
| `.claude/commands/improve-skill.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/improve-skill.md` | Y |
| `.claude/commands/migrate-skill.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/migrate-skill.md` | Y |
| `.claude/commands/note.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/note.md` | Y |
| `.claude/commands/permission-sweep.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/permission-sweep.md` | Y |
| `.claude/commands/prime.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md` | Y |
| `.claude/commands/project-consultant.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/project-consultant.md` | Y |
| `.claude/commands/qc-pass.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/qc-pass.md` | Y |
| `.claude/commands/recommend.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/recommend.md` | Y |
| `.claude/commands/refinement-deep.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/refinement-deep.md` | Y |
| `.claude/commands/refinement-pass.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/refinement-pass.md` | Y |
| `.claude/commands/repo-dd.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/repo-dd.md` | Y |
| `.claude/commands/request-skill.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/request-skill.md` | Y |
| `.claude/commands/resolve-improvements.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-improvements.md` | Y |
| `.claude/commands/risk-check.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/risk-check.md` | Y |
| `.claude/commands/route-change.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/route-change.md` | Y |
| `.claude/commands/scope.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/scope.md` | Y |
| `.claude/commands/session-guide.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-guide.md` | Y |
| `.claude/commands/summary.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/summary.md` | Y |
| `.claude/commands/sync-workflow.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/sync-workflow.md` | Y |
| `.claude/commands/token-audit.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/token-audit.md` | Y |
| `.claude/commands/triage.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/triage.md` | Y |
| `.claude/commands/update-claude-md.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/update-claude-md.md` | Y |
| `.claude/commands/usage-analysis.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/usage-analysis.md` | Y |
| `.claude/commands/wrap-session.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md` | Y |

**`.claude/agents/` symlinks (17 total — all point to `ai-resources/.claude/agents/`):**

| Symlink | Target | Exists |
|---|---|---|
| `.claude/agents/claude-md-auditor.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/claude-md-auditor.md` | Y |
| `.claude/agents/collaboration-coach.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/collaboration-coach.md` | Y |
| `.claude/agents/critical-resource-auditor.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/critical-resource-auditor.md` | Y |
| `.claude/agents/dd-extract-agent.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/dd-extract-agent.md` | Y |
| `.claude/agents/dd-log-sweep-agent.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/dd-log-sweep-agent.md` | Y |
| `.claude/agents/execution-agent.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/execution-agent.md` | Y |
| `.claude/agents/improvement-analyst.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/improvement-analyst.md` | Y |
| `.claude/agents/permission-sweep-auditor.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/permission-sweep-auditor.md` | Y |
| `.claude/agents/qc-reviewer.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/qc-reviewer.md` | Y |
| `.claude/agents/refinement-reviewer.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/refinement-reviewer.md` | Y |
| `.claude/agents/repo-dd-auditor.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/repo-dd-auditor.md` | Y |
| `.claude/agents/risk-check-reviewer.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/risk-check-reviewer.md` | Y |
| `.claude/agents/token-audit-auditor-mechanical.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/token-audit-auditor-mechanical.md` | Y |
| `.claude/agents/token-audit-auditor.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/token-audit-auditor.md` | Y |
| `.claude/agents/triage-reviewer.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/triage-reviewer.md` | Y |
| `.claude/agents/workflow-analysis-agent.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/workflow-analysis-agent.md` | Y |
| `.claude/agents/workflow-critique-agent.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/workflow-critique-agent.md` | Y |

Total symlinks: 54 (37 commands + 17 agents). All targets exist and are accessible. No broken symlinks found.

Section summary: 54 symlinks catalogued, 0 broken / First audit — no delta.

---

## Section 2: CLAUDE.md Health

### 2.1 CLAUDE.md line count and sections

**Line count:** 51 lines (including blank lines)

**Sections (6 distinct headings):**
1. `## Project Layout` — 10 lines
2. `## Model Selection` — 3 lines
3. `## Input File Handling` — 11 lines
4. `## Commit Rules` — 7 lines
5. `## Compaction` — 8 lines
6. `## Session Boundaries` — 2 lines

Section summary: 1 issue flagged — see 2.2 / First audit — no delta.

### 2.2 References to files, paths, commands, or features that do not exist

**DISCREPANCY — Decision source mismatch:**

CLAUDE.md line 14: `"- **Out of scope:** \`harness/\` (entire directory), per architecture Decision D-1 in \`pipeline/decisions.md\`."`

The file `pipeline/decisions.md` exists but its D-1 entry reads: "`/archaeology` command is project-local (not graduated to workspace)." That is not the harness-exclusion decision. The harness-exclusion Decision D-1 is defined in `pipeline/architecture.md` §6 (Design Decision Log), which reads: "Exclude `harness/` from Phase 1 archaeology and Phase 2 enforcement scope."

The reference in CLAUDE.md points to `pipeline/decisions.md` for a decision that is not recorded there. The correct source for the harness-exclusion D-1 is `pipeline/architecture.md`.

Note: Both files exist. The D-numbering is reused across the two files for different decisions — `pipeline/decisions.md` D-1 and `pipeline/architecture.md` D-1 refer to different things. CLAUDE.md cites the wrong file.

**All other references checked and found to resolve:**
- `references/documentation-structure.md` — exists
- `output/phase-1/` — exists (placeholder with `.gitkeep`)
- `output/phase-2/` — exists (placeholder with `.gitkeep`)
- `working/archaeology/` — exists
- `working/elicitation/` — exists
- `logs/decisions.md`, `logs/friction-log.md`, `logs/session-notes.md` — all exist
- `.claude/commands/archaeology.md` — exists
- `pipeline/decisions.md` — exists
- `ai-resources/docs/model-routing.md` — exists (referenced in Model Selection section)

Section summary: 1 issue flagged / First audit — no delta.

### 2.3 Contradictions within CLAUDE.md

None found — checked all six sections for internal contradictions. The `## Input File Handling` and `## Commit Rules` sections explicitly note they mirror workspace CLAUDE.md rules and state the duplication rationale.

Section summary: 0 issues flagged / First audit — no delta.

### 2.4 Conventions not followed by actual files

**DISCREPANCY — `output/session-guide.md` not in CLAUDE.md's output layout description:**

CLAUDE.md `## Project Layout` describes `output/phase-1/` and `output/phase-2/` as the only output locations. The file `output/session-guide.md` exists at `output/session-guide.md` (not inside either phase directory). This file was produced by Stage 6 of the `/new-project` pipeline and is recorded in `pipeline/pipeline-state.md` as the Stage 6 artifact, but it is not mentioned in the CLAUDE.md project layout description.

**DISCREPANCY — CLAUDE.md describes `output/phase-1/` as holding `principles.md`, `system-doc.md`, `blueprint.md`:**

These three files do not currently exist. The project has not yet executed M1.2–M1.4, so the absence is expected (scaffolding phase). The CLAUDE.md is describing anticipated future state, not current state. Recorded for completeness.

Section summary: 2 discrepancies flagged / First audit — no delta.

### 2.5 Features where one referenced file exists but another does not

None found — every file referenced in CLAUDE.md either exists (referenced infrastructure files) or is an anticipated deliverable whose absence is expected at this project stage (M1.4 outputs: `principles.md`, `system-doc.md`, `blueprint.md`). The `/archaeology` command exists and its referenced scripts (`skill-inventory.sh`, `repo-audit.sh`) exist.

Section summary: 0 issues flagged / First audit — no delta.

### 2.6 Sections containing task-type-specific instructions that scoping rules say belong elsewhere

| Section | Line count | Task-type addressed | Note |
|---|---|---|---|
| `## Input File Handling` | 11 | Input handling methodology (which tool to use for reading files, what counts as a legitimate copy) | Explicitly acknowledged in CLAUDE.md as mirroring workspace canonical rule: "This rule mirrors the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded." Workspace CLAUDE.md scoping rule permits this with stated rationale. |
| `## Commit Rules` | 7 | Commit behavior methodology | Explicitly acknowledged in CLAUDE.md: "This rule mirrors the canonical `Commit behavior` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded." Same rationale as above. |
| `## Compaction` | 8 | Compaction handling (what to preserve when `/compact` fires) | Project-specific context-preservation instructions. Not duplicated from workspace CLAUDE.md. Workspace CLAUDE.md `## Session Guardrails` covers pre-compact checkpoint behavior generally; this section adds project-specific "what to preserve" content (current stage, pending reads, operator gates). This is project-specific state guidance, not a generic methodology. |

Section summary: 2 sections flagged as methodology duplication (both with explicit self-acknowledged rationale); 1 section with project-specific content / First audit — no delta.

---

## Section 3: Dependency References

### 3.1 Files referenced by each slash command and whether they exist

**`/archaeology` (project-local):**

| Referenced File | Exists |
|---|---|
| `ai-resources/scripts/skill-inventory.sh` (optional shell-out) | Y |
| `ai-resources/scripts/repo-audit.sh` (optional shell-out) | Y |
| `output/phase-1/inventory/components.md` (output — written by command) | N (does not yet exist; M1.1 not yet run) |
| `output/phase-1/inventory/fragments.md` (output — written by command) | N (does not yet exist) |
| `output/phase-1/inventory/phase-2-prototypes.md` (output — written by command) | N (does not yet exist) |
| `output/phase-1/inventory/complexity-signal.md` (output — written by command) | N (does not yet exist) |
| `pipeline/decisions.md` (referenced in command scope text) | Y |

The four "output" files that do not exist are the command's intended outputs, not inputs. They will be created when `/archaeology` executes M1.1.

**Symlinked commands (37 total):** Each is a symlink to an external target in `ai-resources/`. All targets exist. Internal references within those commands are outside this audit's scope.

Section summary: 0 issues flagged (missing output files are expected pre-execution) / First audit — no delta.

### 3.2 Command output → input chains

**`/archaeology` → M1.2, M1.3, M1.4, M2.P (operator-driven sessions):**
- `/archaeology` produces `output/phase-1/inventory/*.md` (4 files)
- These files serve as inputs to M1.2 elicitation sessions, M1.3 structure design, M1.4 drafting, and M2.P Phase 2 planning
- This chain is documented in `pipeline/architecture.md` §4.2 Data Flow and `output/session-guide.md`
- No command-to-command automation exists — all downstream consumption is by operator-initiated sessions, not by other slash commands

**`/friction-log`, `/note`, `/wrap-session` (symlinks to ai-resources) → `logs/friction-log.md`, `logs/session-notes.md`:**
- These commands append to project log files. The log files exist and are writable.

Section summary: 1 chain documented (archaeology → session-driven milestones) / First audit — no delta.

### 3.3 Files referenced by more than one command, hook, or script

Within AUDIT_ROOT scope:

| File | Referenced By |
|---|---|
| `ai-resources/.claude/hooks/auto-sync-shared.sh` | SessionStart hook in `.claude/settings.json` |
| `references/documentation-structure.md` | Referenced in CLAUDE.md (line 9), `pipeline/architecture.md` (multiple), `pipeline/implementation-spec.md`, `pipeline/implementation-log.md`, `pipeline/test-results.md`, `output/session-guide.md`, `.claude/commands/archaeology.md` (indirectly via project-plan references) |
| `pipeline/decisions.md` | Referenced in CLAUDE.md (line 14), `.claude/commands/archaeology.md` (scope section) |
| `output/phase-1/inventory/complexity-signal.md` | Referenced in `.claude/commands/archaeology.md` (output contract) and `output/session-guide.md` (Session 1 instructions) |

Section summary: 4 multi-referenced files identified / First audit — no delta.

### 3.4 Files ranked by downstream reference count (top 10)

| Rank | File | Reference Count | Referenced By |
|---|---|---|---|
| 1 | `references/documentation-structure.md` | 7 | CLAUDE.md; pipeline/architecture.md; pipeline/implementation-spec.md; pipeline/implementation-log.md; pipeline/test-results.md; output/session-guide.md; .claude/commands/archaeology.md |
| 2 | `.claude/commands/archaeology.md` | 6 (project docs referencing it) | CLAUDE.md; pipeline/decisions.md; pipeline/implementation-log.md; pipeline/architecture.md; output/session-guide.md; .claude/shared-manifest.json |
| 3 | `pipeline/decisions.md` | 2 | CLAUDE.md; .claude/commands/archaeology.md |
| 4 | `ai-resources/scripts/skill-inventory.sh` | 1 | .claude/commands/archaeology.md |
| 5 | `ai-resources/scripts/repo-audit.sh` | 1 | .claude/commands/archaeology.md |
| 6 | `ai-resources/.claude/hooks/auto-sync-shared.sh` | 1 | .claude/settings.json (SessionStart hook) |
| 7 | `output/phase-1/inventory/complexity-signal.md` | 2 | .claude/commands/archaeology.md (output contract); output/session-guide.md |
| 8 | `logs/friction-log.md` | 1 | .claude/commands/friction-log.md (symlink) |
| 9 | `logs/session-notes.md` | 1 | .claude/commands/note.md (symlink); .claude/commands/wrap-session.md (symlink) |
| 10 | `output/phase-1/inventory/components.md` | 2 | .claude/commands/archaeology.md (output contract); pipeline/architecture.md (data flow) |

Section summary: 0 issues flagged / First audit — no delta.

### 3.5 Symlinks in `.claude/commands/` and `.claude/agents/` — coverage check

All 54 symlinks (37 commands + 17 agents) point to targets inside `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/`. The `permissions.additionalDirectories` in `.claude/settings.json` contains `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`. This workspace root is an ancestor of all symlink targets via string-prefix match. All symlink targets are covered.

None found — checked all 54 symlinks against `permissions.additionalDirectories`; all targets covered by workspace root entry.

Section summary: 0 issues flagged / First audit — no delta.

### 3.6 Projects referencing ai-resources without proper additionalDirectories entry

The project references `ai-resources/` via: the SessionStart auto-sync hook (reads `ai-resources/.claude/hooks/auto-sync-shared.sh`), 37 command symlinks, 17 agent symlinks, and `/archaeology` command body references to `ai-resources/scripts/*.sh`.

`permissions.additionalDirectories` in `.claude/settings.json` contains `"/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"` (the workspace root), which is an ancestor of `ai-resources/`. This covers all `ai-resources/` references.

None found — the workspace root in `additionalDirectories` covers all ai-resources references.

Section summary: 0 issues flagged / First audit — no delta.

---

## Section 4: Consistency Checks

### 4.1 Skill structural pattern

No skills exist in this project. N/A — no skills to compare.

Section summary: N/A — out of scope for projects/repo-documentation (no skills present).

### 4.2 Slash command definition pattern

**Project-local command (`/archaeology`):**
- Has YAML frontmatter with `name:`, `description:`, `model:` fields
- `model: sonnet` (explicit tier declaration)
- Frontmatter delimited by `---` open/close
- Body has section headings: `# /archaeology — System Archaeology (Project-Local)`, then `## Scope`, `## Inputs`, `## Output Contract`, `## Workflow`, `## Verification`, `## Output Announcement`
- Follows expected Claude Code slash command pattern

**Symlinked commands (37 total):** All are symlinks to `ai-resources/.claude/commands/`. Internal definition patterns of those commands are outside this scope. All symlink targets exist.

No deviation found within the project-local command.

Section summary: 0 issues flagged / First audit — no delta.

### 4.3 Skill template comparison

N/A — No skill creation template file exists. Skills are created via /create-skill which references ai-resource-builder/SKILL.md for format standards.

### 4.4 Naming convention inconsistencies

All files and directories in AUDIT_ROOT use lowercase with hyphens (e.g., `documentation-structure.md`, `friction-log.md`, `session-notes.md`, `implementation-spec.md`). `CLAUDE.md` uses conventional uppercase, consistent with all other Axcion projects.

None found — checked all file and directory names in AUDIT_ROOT against lowercase-with-hyphens convention.

Section summary: 0 issues flagged / First audit — no delta.

### 4.5 Directory structure violations

CLAUDE.md `## Project Layout` describes the directory structure. Actual structure compared to description:

| Item | Expected | Actual | Match |
|---|---|---|---|
| `output/phase-1/` with `inventory/`, `principles.md`, `system-doc.md`, `blueprint.md` | Present (3 deliverables pending M1.2–M1.4) | `output/phase-1/` exists; `inventory/` subdirectory exists; `principles.md`, `system-doc.md`, `blueprint.md` absent (not yet produced) | Expected given project stage |
| `output/phase-2/` placeholder | Present | Exists with `.gitkeep` | Match |
| `working/archaeology/` and `working/elicitation/` | Present, gitignored contents | Both exist with `.gitkeep` | Match |
| `logs/decisions.md`, `logs/friction-log.md`, `logs/session-notes.md` | Present | All exist | Match |
| `.claude/commands/archaeology.md` | Present | Exists | Match |

**DISCREPANCY — `output/session-guide.md` not in CLAUDE.md layout:**
The file `output/session-guide.md` exists at `output/` root (not in `output/phase-1/` or `output/phase-2/`). CLAUDE.md's layout description does not mention this file or this path. `pipeline/pipeline-state.md` records it as the Stage 6 artifact at `output/session-guide.md`.

Section summary: 1 discrepancy flagged (output/session-guide.md outside described layout) / First audit — no delta.

### 4.6 Command syntax and path resolution check

**`/archaeology`:**
- YAML frontmatter: well-formed (opens and closes with `---`, contains `name`, `description`, `model`)
- All referenced input paths resolve: `ai-resources/scripts/skill-inventory.sh` (Y), `ai-resources/scripts/repo-audit.sh` (Y), `pipeline/decisions.md` (Y)
- Output paths (`output/phase-1/inventory/*.md`) do not yet exist — expected pre-execution
- Disambiguation clause "NOT a health audit (use /audit-repo or /repo-dd for health)" present in description frontmatter and in body scope section
- Harness-exclusion clause present in `## Scope` (out-of-scope list) and `## Workflow` Step 1

None found — `/archaeology` passes all syntax and path-resolution checks.

Section summary: 0 issues flagged / First audit — no delta.

### 4.7 Duplicate or conflicting command names

**Duplicates within project scope:** None found — all 38 command names are unique. No two `.claude/commands/*.md` files share a basename.

**Conflicts with Claude Code built-in commands:** No conflicts found — checked all 38 command names against known Claude Code built-ins (`help`, `clear`, `compact`, `model`, `new`). None match.

Section summary: 0 issues flagged / First audit — no delta.

### 4.8 Agent tier declarations vs tier table

The tier table is at `ai-resources/docs/agent-tier-table.md`. All 17 agents in this project are symlinks to `ai-resources/.claude/agents/`. The tier table covers the ai-resources canonical list.

**Agents with declared tiers (read from symlink targets):**

| Agent | Declared Tier | In Tier Table | Expected Tier Per Table | Match |
|---|---|---|---|---|
| `claude-md-auditor.md` | opus | NO — not in table | N/A | Missing from table |
| `collaboration-coach.md` | opus | YES | opus | Match |
| `critical-resource-auditor.md` | opus | NO — not in table | N/A | Missing from table |
| `dd-extract-agent.md` | haiku | YES | haiku | Match |
| `dd-log-sweep-agent.md` | haiku | YES | haiku | Match |
| `execution-agent.md` | sonnet | YES | sonnet | Match |
| `improvement-analyst.md` | opus | YES | opus | Match |
| `permission-sweep-auditor.md` | sonnet | NO — not in table | N/A | Missing from table |
| `qc-reviewer.md` | opus | YES | opus | Match |
| `refinement-reviewer.md` | opus | YES | opus | Match |
| `repo-dd-auditor.md` | sonnet | YES | sonnet | Match |
| `risk-check-reviewer.md` | opus | NO — not in table | N/A | Missing from table |
| `token-audit-auditor-mechanical.md` | haiku | YES | haiku | Match |
| `token-audit-auditor.md` | opus | YES | opus | Match |
| `triage-reviewer.md` | opus | YES | opus | Match |
| `workflow-analysis-agent.md` | opus | YES | opus | Match |
| `workflow-critique-agent.md` | opus | YES | opus | Match |

**4 agents present in this project are missing from the tier table:**
- `claude-md-auditor.md` — declared `opus`; not in `ai-resources/docs/agent-tier-table.md`
- `critical-resource-auditor.md` — declared `opus`; not in table
- `permission-sweep-auditor.md` — declared `sonnet`; not in table
- `risk-check-reviewer.md` — declared `opus`; not in table

Note: These agents exist in `ai-resources/.claude/agents/` and are accessible via symlinks. The missing entries are in the ai-resources agent-tier-table.md, which is outside this project's AUDIT_ROOT but affects governance of agents used in this project.

Section summary: 4 discrepancies flagged (agents present in project but absent from tier table) / First audit — no delta.

### 4.9 settings.json comparison against canonical new-project.md baseline

**Canonical baseline source:** `ai-resources/.claude/commands/new-project.md` `CANONICAL_PERMS` block (last commit to ai-resources: 2026-04-25).

**Project `.claude/settings.json` last commit:** 2026-04-25.

| Check | Canonical | Project | Status |
|---|---|---|---|
| `permissions.deny` — `Read(archive/**)` | Required | Present | Match |
| `permissions.deny` — `Read(**/*.archive.*)` | Required | Present | Match |
| `permissions.deny` — `Read(**/deprecated/**)` | Required | Present | Match |
| `permissions.deny` — `Read(**/old/**)` | Required | Present | Match |
| `permissions.deny` — `Bash(git push*)` | Required | Present | Match |
| `permissions.deny` — `Bash(rm -rf *)` | Required | Present | Match |
| `permissions.deny` — `Bash(sudo *)` | Required | Present | Match |
| `permissions.allow` — all canonical entries | Required (16 entries) | Present (16 entries) | Match — zero diff |
| Top-level `model` value | `"sonnet"` | `"sonnet[1m]"` | DISCREPANCY — see note |

**DISCREPANCY — model value differs from canonical default:**
Canonical `new-project.md` sets `"model": "sonnet"` at the top level. The project `settings.json` declares `"model": "sonnet[1m]"`. The project CLAUDE.md `## Model Selection` section explicitly states the project default is Sonnet 1M and notes that `settings.local.json` (gitignored) sets `"model": "claude-sonnet-4-6[1m]"`. The discrepancy between canonical (`sonnet`) and project (`sonnet[1m]`) is a deliberate override documented in the project's CLAUDE.md.

Section summary: 1 discrepancy flagged (model value differs from canonical baseline; deliberate per CLAUDE.md) / First audit — no delta.

---

## Section 5: Context Load

### 5.1 Total context loaded at session start

| Source | Line count |
|---|---|
| Workspace CLAUDE.md (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md`) | 204 |
| Project CLAUDE.md (`projects/repo-documentation/CLAUDE.md`) | 51 |
| **Total auto-loaded** | **~255 lines** |

No auto-loaded skills or references are configured in this project. The SessionStart hook performs symlink sync (does not load any CLAUDE.md content). No `@import` directives in the project CLAUDE.md.

Section summary: ~255 lines total context load / First audit — no delta.

### 5.2 CLAUDE.md sections not referenced by any slash command, hook, or operational instruction

All six sections of the project CLAUDE.md address cross-session operational behavior:

| Section | Referenced by commands/hooks | Operational purpose |
|---|---|---|
| `## Project Layout` | Not directly by any command; provides orientation for operator sessions | Navigation pointer |
| `## Model Selection` | Indirectly via settings.json model field | Model routing |
| `## Input File Handling` | Referenced whenever files are read in-session; applies to all session work | File discipline |
| `## Commit Rules` | Referenced whenever commits are made; applies to all session work | Commit behavior |
| `## Compaction` | Referenced when `/compact` fires | Context management |
| `## Session Boundaries` | Referenced at session start/clear | Session hygiene |

No section is "dead weight" in the sense of being unreachable — all sections address behaviors that apply across sessions. However, `## Project Layout` is purely navigational and contains no operational rules. It is referenced by no command or hook; its function is orientation for the operator. This is consistent with its design intent (architecture §3.1: "navigation pointer").

Section summary: 0 issues flagged (no dead-weight sections) / First audit — no delta.

### 5.3 CLAUDE.md line count at last 5 commits

| Date | Commit | Line count |
|---|---|---|
| 2026-04-25 | e72aeee | 51 |

Only one commit in git history modifies `projects/repo-documentation/CLAUDE.md`. The project was created as a single commit batch on 2026-04-25 covering all Stage 3–6 pipeline outputs.

Section summary: 0 issues flagged / First audit — no delta.

---

## Section 6: Drift & Staleness

### 6.1 Files not modified in last 90 days but still referenced

Audit date: 2026-04-27. 90-day lookback: since 2026-01-27.

All files in AUDIT_ROOT were committed on 2026-04-25 (2 days before audit date). No file in this project predates the 90-day window.

None found — checked git commit dates; all project files committed 2026-04-25, within 90-day window.

Section summary: 0 issues flagged / First audit — no delta.

### 6.2 TODO, FIXME, PLACEHOLDER, or similar marker comments

Searched all `.md` and `.json` files in AUDIT_ROOT for: `TODO`, `FIXME`, `HACK`, `XXX`, `PLACEHOLDER`.

| Marker | Count | Locations |
|---|---|---|
| `TODO` | 0 | None found |
| `FIXME` | 0 | None found |
| `HACK` | 0 | None found |
| `XXX` | 0 | None found |
| `PLACEHOLDER` | 0 | None found (the term "passive placeholder" and similar appear in pipeline docs but as descriptive prose, not marker comments) |

The `references/documentation-structure.md` file contains `[POPULATED IN M1.3]` and `[POPULATED IN M2.P — Phase 2 second planning round]` markers. These are intentional skeleton placeholders, not TODO/FIXME-style issue markers — they are the documented design of this file (status line explicitly reads "SKELETON — populated in M1.3").

None found — checked all .md and .json files for standard marker patterns.

Section summary: 0 issues flagged / First audit — no delta.

### 6.3 Empty files, stub files, or files with only boilerplate

| File | State | Expected |
|---|---|---|
| `references/documentation-structure.md` | Skeleton — all 4 content sections contain `[POPULATED IN M1.3]` or `[POPULATED IN M2.P]` placeholders; only Section 5 (Evidence-Gap Markers) and Section 7 (Phase 2 Hooks) have real content | Intentional — status line reads "SKELETON — populated in M1.3"; this is the designed state before M1.3 executes |
| `logs/decisions.md` | Contains only header and a placeholder table row `| — | — | — | (entries added as project proceeds) | — | — |` | Expected — no decisions logged yet; project is in scaffolding state |
| `logs/friction-log.md` | Contains header, entry format template, and note "(No friction logged yet — project scaffolding just completed.)" | Expected — no friction logged yet |
| `logs/session-notes.md` | Contains header, entry format template, and note "(No session notes yet — project scaffolding just completed.)" | Expected — no sessions run yet |
| `inputs/.gitkeep` | Zero bytes | Expected — inputs directory is empty; no operator inputs supplied yet |
| All other `.gitkeep` files (7 more) | Zero bytes | Expected — placeholder files for empty directories |

All stub/skeleton files are in their expected state for a project that has completed scaffolding but not yet begun Phase 1 execution (M1.1 not yet run).

Section summary: 0 issues flagged (all stubs are intentional and documented) / First audit — no delta.

---

## Findings Summary

**Total findings: 7**

| # | Type | Finding |
|---|---|---|
| F-1 | Discrepancy | CLAUDE.md line 14 references `pipeline/decisions.md` for the harness-exclusion Decision D-1, but that file's D-1 is about `/archaeology` being project-local. The harness-exclusion D-1 is in `pipeline/architecture.md` §6. |
| F-2 | Discrepancy | `output/session-guide.md` exists at `output/` root but is not mentioned in CLAUDE.md `## Project Layout` section, which only describes `output/phase-1/` and `output/phase-2/`. |
| F-3 | Discrepancy | CLAUDE.md describes `output/phase-1/` as holding `principles.md`, `system-doc.md`, `blueprint.md` — none of these files exist yet. Expected at current project stage (pre-M1.1 execution); recorded for completeness. |
| F-4 | Discrepancy | `settings.json` declares `"model": "sonnet[1m]"` vs. canonical new-project.md baseline of `"model": "sonnet"`. Deliberate — documented in project CLAUDE.md `## Model Selection`. |
| F-5 | Missing item | `claude-md-auditor` agent is present in this project (symlink to ai-resources) but is absent from `ai-resources/docs/agent-tier-table.md`. Declared tier: `opus`. |
| F-6 | Missing item | `critical-resource-auditor` agent is present in this project (symlink to ai-resources) but is absent from `ai-resources/docs/agent-tier-table.md`. Declared tier: `opus`. |
| F-7 | Missing item | `permission-sweep-auditor` agent is present in this project (symlink to ai-resources) but is absent from `ai-resources/docs/agent-tier-table.md`. Declared tier: `sonnet`. |
| F-8 | Missing item | `risk-check-reviewer` agent is present in this project (symlink to ai-resources) but is absent from `ai-resources/docs/agent-tier-table.md`. Declared tier: `opus`. |

**Total findings: 8** (adjusted — F-5 through F-8 are separate items)

**Breakdown:**
- Discrepancies: 4 (F-1, F-2, F-3, F-4)
- Missing items: 4 (F-5, F-6, F-7, F-8 — agents missing from tier table in ai-resources, outside AUDIT_ROOT)
- Violations: 0
- Clean checks: 24 (all symlinks resolve; all settings.json deny entries present; no broken references except F-1; no duplicate commands; no naming violations; no TODO markers; no stale files; no dead-weight CLAUDE.md sections; all hook scripts exist and are executable)
