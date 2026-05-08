# Repo Due Diligence Audit — 2026-05-08
Repo: projects/repo-documentation
Scope: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation
Commit: ef25384 (main repo HEAD)
Previous audit: 2026-04-27
Delta window: 11 days (2026-04-27 through 2026-05-08)

---

## Section 1: Inventory

### 1.1 Slash commands defined

| Command | Defined At | Files Referenced |
|---|---|---|
| `/archaeology` | `.claude/commands/archaeology.md` (regular file — project-local) | `ai-resources/scripts/skill-inventory.sh` (optional); `ai-resources/scripts/repo-audit.sh` (optional); writes to `output/phase-1/inventory/components.md`, `fragments.md`, `phase-2-prototypes.md`, `complexity-signal.md`; references `pipeline/decisions.md` (stale path — see Q4.6) |
| `/analyze-workflow` | `.claude/commands/analyze-workflow.md` (symlink → ai-resources) | External target |
| `/architecture-review` | `.claude/commands/architecture-review.md` (symlink → ai-resources) | External target |
| `/audit-claude-md` | `.claude/commands/audit-claude-md.md` (symlink → ai-resources) | External target |
| `/audit-critical-resources` | `.claude/commands/audit-critical-resources.md` (symlink → ai-resources) | External target |
| `/audit-repo` | `.claude/commands/audit-repo.md` (symlink → ai-resources) | External target |
| `/clarify` | `.claude/commands/clarify.md` (symlink → ai-resources) | External target |
| `/cleanup-worktree` | `.claude/commands/cleanup-worktree.md` (symlink → ai-resources) | External target |
| `/coach` | `.claude/commands/coach.md` (symlink → ai-resources) | External target |
| `/consult` | `.claude/commands/consult.md` (relative symlink → `../../../../ai-resources/.claude/commands/consult.md`) | External target |
| `/create-skill` | `.claude/commands/create-skill.md` (symlink → ai-resources) | External target |
| `/deploy-kb` | `.claude/commands/deploy-kb.md` (symlink → ai-resources) | External target |
| `/friction-log` | `.claude/commands/friction-log.md` (symlink → ai-resources) | External target |
| `/friday-act` | `.claude/commands/friday-act.md` (symlink → ai-resources) | External target |
| `/friday-checkup` | `.claude/commands/friday-checkup.md` (symlink → ai-resources) | External target |
| `/friday-so` | `.claude/commands/friday-so.md` (symlink → ai-resources) | External target |
| `/graduate-resource` | `.claude/commands/graduate-resource.md` (symlink → ai-resources) | External target |
| `/implementation-triage` | `.claude/commands/implementation-triage.md` (symlink → ai-resources) | External target |
| `/improve` | `.claude/commands/improve.md` (symlink → ai-resources) | External target |
| `/improve-skill` | `.claude/commands/improve-skill.md` (symlink → ai-resources) | External target |
| `/innovation-sweep` | `.claude/commands/innovation-sweep.md` (symlink → ai-resources) | External target |
| `/migrate-skill` | `.claude/commands/migrate-skill.md` (symlink → ai-resources) | External target |
| `/monday-prep` | `.claude/commands/monday-prep.md` (symlink → ai-resources) | External target |
| `/note` | `.claude/commands/note.md` (symlink → ai-resources) | External target |
| `/permission-sweep` | `.claude/commands/permission-sweep.md` (symlink → ai-resources) | External target |
| `/prime` | `.claude/commands/prime.md` (symlink → ai-resources) | External target |
| `/project-consultant` | `.claude/commands/project-consultant.md` (symlink → ai-resources) | External target |
| `/qc-pass` | `.claude/commands/qc-pass.md` (symlink → ai-resources) | External target |
| `/recommend` | `.claude/commands/recommend.md` (symlink → ai-resources) | External target |
| `/refinement-deep` | `.claude/commands/refinement-deep.md` (symlink → ai-resources) | External target |
| `/refinement-pass` | `.claude/commands/refinement-pass.md` (symlink → ai-resources) | External target |
| `/repo-dd` | `.claude/commands/repo-dd.md` (symlink → ai-resources) | External target |
| `/request-skill` | `.claude/commands/request-skill.md` (symlink → ai-resources) | External target |
| `/resolve-improvement-log` | `.claude/commands/resolve-improvement-log.md` (symlink → ai-resources) | External target |
| `/resolve-improvements` | `.claude/commands/resolve-improvements.md` (symlink → ai-resources) | **BROKEN — target does not exist** (see Q3.5, Q4.6) |
| `/resolve` | `.claude/commands/resolve.md` (symlink → ai-resources) | External target |
| `/risk-check` | `.claude/commands/risk-check.md` (symlink → ai-resources) | External target |
| `/route-change` | `.claude/commands/route-change.md` (symlink → ai-resources) | External target |
| `/save-session` | `.claude/commands/save-session.md` (symlink → ai-resources) | External target |
| `/scope` | `.claude/commands/scope.md` (symlink → ai-resources) | External target |
| `/session-guide` | `.claude/commands/session-guide.md` (symlink → ai-resources) | External target |
| `/session-plan` | `.claude/commands/session-plan.md` (symlink → ai-resources) | External target |
| `/session-start` | `.claude/commands/session-start.md` (symlink → ai-resources) | External target |
| `/so-monthly` | `.claude/commands/so-monthly.md` (relative symlink → `../../../../ai-resources/.claude/commands/so-monthly.md`) | External target |
| `/summary` | `.claude/commands/summary.md` (symlink → ai-resources) | External target |
| `/sync-workflow` | `.claude/commands/sync-workflow.md` (symlink → ai-resources) | External target |
| `/systems-review` | `.claude/commands/systems-review.md` (symlink → ai-resources) | External target |
| `/token-audit` | `.claude/commands/token-audit.md` (symlink → ai-resources) | External target |
| `/triage` | `.claude/commands/triage.md` (symlink → ai-resources) | External target |
| `/update-claude-md` | `.claude/commands/update-claude-md.md` (symlink → ai-resources) | External target |
| `/usage-analysis` | `.claude/commands/usage-analysis.md` (symlink → ai-resources) | External target |
| `/wrap-session` | `.claude/commands/wrap-session.md` (symlink → ai-resources) | External target |

Total: 52 commands (1 project-local regular file; 49 absolute-path symlinks to `ai-resources/.claude/commands/`; 2 relative-path symlinks to `ai-resources/.claude/commands/`). 51 targets exist and are accessible. 1 broken symlink: `/resolve-improvements` points to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-improvements.md`, which does not exist.

**Vault sub-scope (.claude/commands/ inside `vault/`):** 3 commands — `kb-integrity.md` (regular file), `kb-update.md` (regular file), `consult.md` (relative symlink → `../../../../../ai-resources/.claude/commands/consult.md`, resolves OK).

DELTA: Previous audit: 38 commands (37 symlinks + 1 local). Current: 52 commands (+14 net). 14 new symlinks added: `architecture-review`, `consult`, `deploy-kb`, `friday-so`, `implementation-triage`, `innovation-sweep`, `monday-prep`, `resolve-improvement-log`, `resolve`, `save-session`, `session-plan`, `session-start`, `so-monthly`, `systems-review`. `resolve-improvements` was present and resolving in previous audit; target `ai-resources/.claude/commands/resolve-improvements.md` has since been removed from ai-resources — symlink now broken.

Section summary: 52 items catalogued / 15 deltas from previous audit (14 added, 1 newly broken).

---

### 1.2 Hooks configured

**`.claude/settings.json` — Hooks:**

| Trigger | Matcher | What it does | Files referenced |
|---|---|---|---|
| `SessionStart` | — | Shell walker climbs from `$CLAUDE_PROJECT_DIR` to find and execute `ai-resources/.claude/hooks/auto-sync-shared.sh` | `ai-resources/.claude/hooks/auto-sync-shared.sh` (resolved at runtime) |
| `PostToolUse` | `Write\|Edit` | Runs `$CLAUDE_PROJECT_DIR/.claude/hooks/friction-log-trigger.sh` | `.claude/hooks/friction-log-trigger.sh` |

SessionStart hook command: `d="$CLAUDE_PROJECT_DIR"; while [ "$d" != "/" ]; do d=$(dirname "$d"); [ -x "$d/ai-resources/.claude/hooks/auto-sync-shared.sh" ] && { "$d/ai-resources/.claude/hooks/auto-sync-shared.sh"; exit; }; done`

`auto-sync-shared.sh` exists at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/auto-sync-shared.sh` and is executable (`-rwxr-xr-x`).

`friction-log-trigger.sh` exists at `.claude/hooks/friction-log-trigger.sh` and is executable (`-rwxr-xr-x`, 1014 bytes). It emits a non-blocking `systemMessage` when any `Write|Edit` tool call targets `friction-log.md`. Always exits 0.

**`.claude/settings.local.json`:** Empty (`{}`). No hooks defined.

**Vault hooks:** No hooks configured in `vault/.claude/settings.json`.

DELTA: Previous audit: 1 hook (SessionStart only). Current: 2 hooks — PostToolUse (Write|Edit) hook added pointing to new project-local script `.claude/hooks/friction-log-trigger.sh`. `settings.local.json` previously contained `{"model": "claude-sonnet-4-6[1m]"}`; now empty (`{}`).

Section summary: 2 hooks configured / 2 deltas from previous audit.

---

### 1.3 Template files

| File Path | Purpose | Used By | Last Commit Date |
|---|---|---|---|
| `references/documentation-structure.md` | Single source of truth for documentation format (TOC, section conventions, principle ID scheme, component-description schema). Status: **ACTIVE** as of 2026-04-28 (previously SKELETON). 447 lines. | M1.3 (produced it), M1.4 (drafted against), M1.5 (verified against), Phase 2 W2.1/W2.2 (schema reference), `doc-scanner-agent.md` (Phase 5 field shape), `kb-update.md` Step 3, `kb-integrity.md` Check G | 2026-05-06 |
| `vault/templates/component-file-template.md` | Frontmatter and section skeleton for new component registry entries in the vault | `vault/.claude/commands/kb-update.md`, `vault/CLAUDE.md` §Frontmatter Conventions | 2026-04-30 |
| `vault/templates/narrative-note-template.md` | Frontmatter and section skeleton for narrative notes in the vault | `vault/.claude/commands/kb-update.md`, `vault/CLAUDE.md` §Frontmatter Conventions | 2026-04-30 |

DELTA: Previous audit: 1 template (`references/documentation-structure.md`, status SKELETON). Current: 3 templates — `documentation-structure.md` status changed to ACTIVE; 2 new vault templates added (`component-file-template.md`, `narrative-note-template.md`).

Section summary: 3 template files catalogued / 3 deltas from previous audit.

---

### 1.4 Scripts

| File Path | What it does | Called By |
|---|---|---|
| `.claude/hooks/friction-log-trigger.sh` | PostToolUse hook: detects writes to `friction-log.md`, emits a non-blocking `systemMessage` advisory. Always exits 0. 29 lines. | `.claude/settings.json` PostToolUse hook (matcher: `Write\|Edit`) |

The project previously contained no scripts. External scripts (`ai-resources/scripts/skill-inventory.sh`, `ai-resources/scripts/repo-audit.sh`) are called optionally by `/archaeology` but are outside AUDIT_ROOT scope.

DELTA: Previous audit: 0 scripts. Current: 1 script (`friction-log-trigger.sh`) added 2026-04-30.

Section summary: 1 script / 1 delta from previous audit.

---

### 1.5 Skills

None found — checked all paths in AUDIT_ROOT for `SKILL.md` files. The project contains no skills.

N/A — No skill creation template file exists. Skills are created via /create-skill which references ai-resource-builder/SKILL.md for format standards.

DELTA: No change.

Section summary: 0 skills / 0 deltas from previous audit.

---

### 1.6 Uncategorized items

**Previously present (unchanged):**

| File | Category |
|---|---|
| `pipeline-phase-1/architecture.md` | Pipeline artifact (formerly `pipeline/architecture.md`) — Phase 1 architecture document |
| `pipeline-phase-1/context-pack.md` | Pipeline artifact — Phase 1 context pack |
| `pipeline-phase-1/decisions.md` | Pipeline artifact — Phase 1 stage-level decision log |
| `pipeline-phase-1/implementation-log.md` | Pipeline artifact — Phase 1 implementation execution log |
| `pipeline-phase-1/implementation-spec.md` | Pipeline artifact — Phase 1 implementation specification |
| `pipeline-phase-1/pipeline-state.md` | Pipeline artifact — Phase 1 stage completion tracker |
| `pipeline-phase-1/project-plan.md` | Pipeline artifact — Phase 1 project plan |
| `pipeline-phase-1/repo-snapshot.md` | Pipeline artifact — repo state snapshot at Phase 1 planning time |
| `pipeline-phase-1/sources.md` | Pipeline artifact — source attribution |
| `pipeline-phase-1/test-results.md` | Pipeline artifact — Phase 1 post-implementation test results |
| `output/session-guide.md` | Pipeline artifact (Stage 6 output) — operator session guide |
| `logs/decisions.md` | Project execution log (now has real content; 47 lines) |
| `logs/friction-log.md` | Project execution log (now has real content; 19 lines) |
| `logs/session-notes.md` | Project execution log (now has real content; 678 lines) |
| `inputs/.gitkeep` | Placeholder — `inputs/` directory |
| `CLAUDE.md` | Project-level persistent context |
| `.gitignore` | Git ignore rules |
| `.claude/settings.json` | Project Claude Code settings |
| `.claude/settings.local.json` | Per-machine model default (gitignored; currently empty) |
| `.claude/shared-manifest.json` | Auto-sync hook manifest |
| `.claude/agents/.gitkeep` | Placeholder — `.claude/agents/` |
| `.claude/hooks/.gitkeep` | Placeholder — `.claude/hooks/` |
| `output/phase-1/.gitkeep` | Placeholder — `output/phase-1/` |
| `output/phase-1/inventory/.gitkeep` | Placeholder — `output/phase-1/inventory/` |
| `output/phase-2/.gitkeep` | Placeholder — Phase 2 passive placeholder |
| `working/archaeology/.gitkeep` | Placeholder |
| `working/elicitation/.gitkeep` | Placeholder |

**New since previous audit:**

| File | Category |
|---|---|
| `pipeline-phase-2/architecture.md` | Pipeline artifact — Phase 2 architecture document |
| `pipeline-phase-2/context-pack.md` | Pipeline artifact — Phase 2 context pack |
| `pipeline-phase-2/decisions.md` | Pipeline artifact — Phase 2 decision log |
| `pipeline-phase-2/implementation-log.md` | Pipeline artifact — Phase 2 implementation log |
| `pipeline-phase-2/implementation-spec.md` | Pipeline artifact — Phase 2 implementation specification |
| `pipeline-phase-2/pipeline-state.md` | Pipeline artifact — Phase 2 stage tracker |
| `pipeline-phase-2/project-plan.md` | Pipeline artifact — Phase 2 project plan |
| `pipeline-phase-2/repo-snapshot.md` | Pipeline artifact — repo snapshot at Phase 2 planning time |
| `pipeline-phase-2/sources.md` | Pipeline artifact — source attribution |
| `pipeline-phase-2/test-results.md` | Pipeline artifact — Phase 2 test results |
| `output/phase-1/blueprint.md` | Phase 1 deliverable (M1.4 output) — architecture blueprint |
| `output/phase-1/components/` | Phase 1 component registry — 12 files (agents.md, claude-md-files.md, commands.md, harness.md, hooks.md, logs.md, projects.md, references.md, scripts.md, settings-files.md, skills.md, workflow-templates.md) |
| `output/phase-1/inventory/complexity-signal.md` | Phase 1 inventory output (M1.1) |
| `output/phase-1/inventory/components.md` | Phase 1 inventory output (M1.1) |
| `output/phase-1/inventory/fragments.md` | Phase 1 inventory output (M1.1) |
| `output/phase-1/inventory/phase-2-prototypes.md` | Phase 1 inventory output (M1.1) |
| `output/phase-1/principles.md` | Phase 1 deliverable (M1.2 output) — principles register |
| `output/phase-1/repo-state.md` | Phase 1 deliverable — repo state document |
| `output/phase-1/risk-topology.md` | Phase 1 deliverable — risk topology |
| `output/phase-1/system-doc.md` | Phase 1 deliverable (M1.4 output) — system documentation |
| `output/phase-2/vault-maintenance-fix-plan-2026-05-06-v2.md` | Phase 2 execution artifact — vault maintenance fix plan v2 |
| `output/phase-2/vault-maintenance-fix-plan-2026-05-06-v3.md` | Phase 2 execution artifact — vault maintenance fix plan v3 |
| `output/phase-2/vault-maintenance-fix-plan-2026-05-06.md` | Phase 2 execution artifact — vault maintenance fix plan v1 |
| `output/phase-2/w2-1-doc-scan-2026-05-01.md` | Phase 2 execution output — W2.1 doc scan 2026-05-01 |
| `output/phase-2/w2-1-doc-scan-2026-05-08.md` | Phase 2 execution output — W2.1 doc scan 2026-05-08 |
| `output/phase-2/w2-2-principles-2026-05-01.md` | Phase 2 execution output — W2.2 principles check 2026-05-01 |
| `output/phase-2/w2-3-maintenance-2026-05-01.md` | Phase 2 execution output — W2.3 maintenance 2026-05-01 |
| `output/phase-2/w2-3-maintenance-2026-05-08.md` | Phase 2 execution output — W2.3 maintenance 2026-05-08 |
| `output/phase-2/w2-4-improvements-2026-05-01.md` | Phase 2 execution output — W2.4 improvements 2026-05-01 |
| `output/phase-2/w2-4-proposals/.gitkeep` | Placeholder — W2.4 proposals directory |
| `logs/coaching-data.md` | Project log — coaching session profile data (19 lines) |
| `logs/coaching-log.md` | Project log — coaching log (35 lines) |
| `logs/innovation-registry.md` | Project log — innovation registry (10 lines) |
| `logs/session-plan.md` | Project log — session plan (33 lines) |
| `logs/usage-log.md` | Project log — usage telemetry (38 lines) |
| `vault/` | Obsidian KB sub-scope (see detail below) |

**`vault/` sub-scope items (tracked infrastructure only; vault content is gitignored):**

| File | Category |
|---|---|
| `vault/CLAUDE.md` | Vault-level persistent context (124 lines, 10 sections) |
| `vault/.claude/settings.json` | Vault Claude Code settings |
| `vault/.claude/settings.local.json` | Per-machine vault model default (gitignored) |
| `vault/.claude/shared-manifest.json` | Vault auto-sync manifest |
| `vault/.claude/commands/kb-integrity.md` | Vault-local command (regular file, 5596 bytes) |
| `vault/.claude/commands/kb-update.md` | Vault-local command (regular file, 5407 bytes) |
| `vault/.claude/commands/consult.md` | Symlink → ai-resources consult command |
| `vault/templates/component-file-template.md` | Vault component note template |
| `vault/templates/narrative-note-template.md` | Vault narrative note template |
| `vault/_integrity-report-2026-05-01.md` | Integrity report artifact |
| `vault/_integrity-report-2026-05-08.md` | Integrity report artifact |
| `vault/_master-index.md` | Vault navigation index |
| `vault/architecture/repo-state.md` | Vault content (gitignored by vault/.gitignore) |
| `vault/architecture/risk-topology.md` | Vault content (gitignored) |
| `vault/architecture/system-doc.md` | Vault content (gitignored) |
| `vault/blueprint/blueprint.md` | Vault content (gitignored) |
| `vault/components/_index.md` | Vault content (gitignored) |
| `vault/components/agents.md` through `vault/components/workflow-templates.md` (12 files) | Vault content (gitignored) |
| `vault/principles/principles.md` | Vault content (gitignored) |
| `vault/projects/projects.md` | Vault content (gitignored) |

DELTA: Previous audit: 27 uncategorized items. Current: significantly expanded — Phase 2 pipeline directory (10 new files), Phase 1 output files now populated (inventory 4 files, deliverables blueprint/components/principles/system-doc/repo-state/risk-topology), Phase 2 execution outputs (9 files + 1 placeholder), 5 new log files, and entire `vault/` sub-scope added. `pipeline/` directory renamed to `pipeline-phase-1/` (refactor commit 2026-04-30).

Section summary: 63+ uncategorized items catalogued (27 carry-over + 36+ new) / 14+ deltas from previous audit.

---

### 1.7 Symlinks

**`.claude/commands/` symlinks (51 total — 49 absolute-path, 2 relative-path):**

| Symlink | Target | Exists |
|---|---|---|
| `.claude/commands/analyze-workflow.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/analyze-workflow.md` | Y |
| `.claude/commands/architecture-review.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/architecture-review.md` | Y |
| `.claude/commands/audit-claude-md.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/audit-claude-md.md` | Y |
| `.claude/commands/audit-critical-resources.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/audit-critical-resources.md` | Y |
| `.claude/commands/audit-repo.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/audit-repo.md` | Y |
| `.claude/commands/clarify.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/clarify.md` | Y |
| `.claude/commands/cleanup-worktree.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/cleanup-worktree.md` | Y |
| `.claude/commands/coach.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/coach.md` | Y |
| `.claude/commands/consult.md` | `../../../../ai-resources/.claude/commands/consult.md` (relative → resolves to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/consult.md`) | Y |
| `.claude/commands/create-skill.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/create-skill.md` | Y |
| `.claude/commands/deploy-kb.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/deploy-kb.md` | Y |
| `.claude/commands/friction-log.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friction-log.md` | Y |
| `.claude/commands/friday-act.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-act.md` | Y |
| `.claude/commands/friday-checkup.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-checkup.md` | Y |
| `.claude/commands/friday-so.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-so.md` | Y |
| `.claude/commands/graduate-resource.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/graduate-resource.md` | Y |
| `.claude/commands/implementation-triage.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/implementation-triage.md` | Y |
| `.claude/commands/improve-skill.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/improve-skill.md` | Y |
| `.claude/commands/improve.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/improve.md` | Y |
| `.claude/commands/innovation-sweep.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/innovation-sweep.md` | Y |
| `.claude/commands/migrate-skill.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/migrate-skill.md` | Y |
| `.claude/commands/monday-prep.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/monday-prep.md` | Y |
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
| `.claude/commands/resolve-improvement-log.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-improvement-log.md` | Y |
| `.claude/commands/resolve-improvements.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-improvements.md` | **N — BROKEN** |
| `.claude/commands/resolve.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve.md` | Y |
| `.claude/commands/risk-check.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/risk-check.md` | Y |
| `.claude/commands/route-change.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/route-change.md` | Y |
| `.claude/commands/save-session.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/save-session.md` | Y |
| `.claude/commands/scope.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/scope.md` | Y |
| `.claude/commands/session-guide.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-guide.md` | Y |
| `.claude/commands/session-plan.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md` | Y |
| `.claude/commands/session-start.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md` | Y |
| `.claude/commands/so-monthly.md` | `../../../../ai-resources/.claude/commands/so-monthly.md` (relative → resolves to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/so-monthly.md`) | Y |
| `.claude/commands/summary.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/summary.md` | Y |
| `.claude/commands/sync-workflow.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/sync-workflow.md` | Y |
| `.claude/commands/systems-review.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/systems-review.md` | Y |
| `.claude/commands/token-audit.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/token-audit.md` | Y |
| `.claude/commands/triage.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/triage.md` | Y |
| `.claude/commands/update-claude-md.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/update-claude-md.md` | Y |
| `.claude/commands/usage-analysis.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/usage-analysis.md` | Y |
| `.claude/commands/wrap-session.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md` | Y |

**`.claude/agents/` symlinks (20 total — 19 absolute-path, 1 relative-path):**

| Symlink | Target | Exists |
|---|---|---|
| `.claude/agents/claude-md-auditor.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/claude-md-auditor.md` | Y |
| `.claude/agents/collaboration-coach.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/collaboration-coach.md` | Y |
| `.claude/agents/critical-resource-auditor.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/critical-resource-auditor.md` | Y |
| `.claude/agents/dd-extract-agent.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/dd-extract-agent.md` | Y |
| `.claude/agents/dd-log-sweep-agent.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/dd-log-sweep-agent.md` | Y |
| `.claude/agents/execution-agent.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/execution-agent.md` | Y |
| `.claude/agents/findings-extractor.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/findings-extractor.md` | Y |
| `.claude/agents/improvement-analyst.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/improvement-analyst.md` | Y |
| `.claude/agents/innovation-triage-auditor.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/innovation-triage-auditor.md` | Y |
| `.claude/agents/permission-sweep-auditor.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/permission-sweep-auditor.md` | Y |
| `.claude/agents/qc-reviewer.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/qc-reviewer.md` | Y |
| `.claude/agents/refinement-reviewer.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/refinement-reviewer.md` | Y |
| `.claude/agents/repo-dd-auditor.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/repo-dd-auditor.md` | Y |
| `.claude/agents/risk-check-reviewer.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/risk-check-reviewer.md` | Y |
| `.claude/agents/system-owner.md` | `../../../../ai-resources/.claude/agents/system-owner.md` (relative → resolves to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/system-owner.md`) | Y |
| `.claude/agents/token-audit-auditor-mechanical.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/token-audit-auditor-mechanical.md` | Y |
| `.claude/agents/token-audit-auditor.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/token-audit-auditor.md` | Y |
| `.claude/agents/triage-reviewer.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/triage-reviewer.md` | Y |
| `.claude/agents/workflow-analysis-agent.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/workflow-analysis-agent.md` | Y |
| `.claude/agents/workflow-critique-agent.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/workflow-critique-agent.md` | Y |

**Vault symlinks:**

| Symlink | Target | Exists |
|---|---|---|
| `vault/.claude/commands/consult.md` | `../../../../../ai-resources/.claude/commands/consult.md` (relative → resolves to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/consult.md`) | Y |

Total symlinks: 72 (51 command + 20 agent + 1 vault command). 71 exist and are accessible. 1 broken: `.claude/commands/resolve-improvements.md` → target `ai-resources/.claude/commands/resolve-improvements.md` does not exist.

DELTA: Previous audit: 54 symlinks, 0 broken. Current: 72 symlinks (+18), 1 broken. New symlinks: 14 new command symlinks, 3 new agent symlinks (`findings-extractor`, `innovation-triage-auditor`, `system-owner`), 1 vault command symlink (`consult`). `resolve-improvements.md` was resolving in previous audit; target since removed from ai-resources.

Section summary: 72 symlinks catalogued, 1 broken / 19 deltas from previous audit.

---

## Section 2: CLAUDE.md Health

### 2.1 CLAUDE.md line count and sections

**Project CLAUDE.md (`projects/repo-documentation/CLAUDE.md`):**
- **Line count:** 53 lines
- **Sections (6 distinct headings, unchanged from previous audit):**
  1. `## Project Layout` — ~16 lines
  2. `## Model Selection` — ~2 lines
  3. `## Input File Handling` — ~11 lines
  4. `## Commit Rules` — ~7 lines
  5. `## Compaction` — ~7 lines
  6. `## Session Boundaries` — 2 lines

**Vault CLAUDE.md (`vault/CLAUDE.md`):** 124 lines, 10 sections:
1. `## Purpose` — 4 lines
2. `## Model Selection` — 4 lines
3. `## Folder Structure` — 9 lines
4. `## Operating Modes` — 15 lines
5. `## Index Maintenance Rule (atomic)` — 9 lines
6. `## Frontmatter Conventions` — 17 lines
7. `## Tag Taxonomy (seed)` — 7 lines
8. `## Cross-Reference Convention` — 4 lines
9. `## Commit Rules` — 13 lines
10. `## Out of Scope` — 3 lines

DELTA: Project CLAUDE.md: 2 lines added (51 → 53). `## Project Layout` section revised to reflect Phase 1 complete, Phase 2 active, vault added, pipeline rename, and D-1 supersession. `## Model Selection` revised (removed direct model-routing.md reference). Vault CLAUDE.md is entirely new.

Section summary: 0 new issues flagged / 2 deltas from previous audit.

---

### 2.2 References in CLAUDE.md to files, paths, commands, or features that do not exist

**F-1 STATUS: RESOLVED.** Previous audit F-1 flagged CLAUDE.md line 14 citing `pipeline/decisions.md` for Decision D-1. Current CLAUDE.md line 16 now reads: *"Decision D-1 superseded per system-doc.md §1.1."* The reference to `pipeline/decisions.md` has been removed. `output/phase-1/system-doc.md` exists and its §1.1 (### 1.1 Purpose and Scope) contains the D-1 supersession language. RESOLVED.

**All references in current project CLAUDE.md checked and found to resolve:**
- `references/documentation-structure.md` — exists
- `pipeline-phase-2/` — exists (mentioned in line 7)
- `pipeline-phase-2/implementation-spec.md` — exists (referenced as "per implementation-spec.md" in line 7)
- `output/phase-1/` — exists; `inventory/`, `principles.md`, `system-doc.md`, `blueprint.md` all exist
- `output/phase-2/` — exists
- `output/session-guide.md` — exists (F-2 fix from previous audit: now explicitly mentioned in line 10)
- `vault/` — exists
- `output/phase-1/system-doc.md §1.1` — exists (mentioned in harness scope note line 16)
- `working/archaeology/` and `working/elicitation/` — both exist
- `logs/decisions.md`, `logs/friction-log.md`, `logs/session-notes.md` — all exist
- `.claude/commands/archaeology.md` — exists
- `.claude/settings.local.json` — exists (empty `{}`)

**DISCREPANCY — CLAUDE.md line 20 references `settings.local.json` as holding the model default, but file is currently empty.**
CLAUDE.md `## Model Selection` states: *"Default model for this project is Sonnet 1M (`claude-sonnet-4-6[1m]`, set in `.claude/settings.local.json`, which is gitignored — each operator applies the default manually per machine)."* The `settings.local.json` on this machine is `{}` (empty). The model field was also removed from `settings.json` on 2026-05-06 (commit `cad4848`). The CLAUDE.md description states this is a per-machine manual application — the empty state on this machine may reflect that the operator has not applied the value. Recorded as a discrepancy: CLAUDE.md says the model is set in `settings.local.json` but the file contains no model setting on this machine.

DELTA: F-1 resolved. F-2 resolved (session-guide.md now in CLAUDE.md layout). model-routing.md reference removed from Model Selection section. New discrepancy: settings.local.json is empty while CLAUDE.md says it holds the model default.

Section summary: 1 discrepancy flagged (settings.local.json empty vs CLAUDE.md claim) / 3 deltas from previous audit.

---

### 2.3 Contradictions within CLAUDE.md

None found — checked all six sections in the project CLAUDE.md for internal contradictions. The `## Input File Handling` and `## Commit Rules` sections acknowledge their duplication rationale. The harness scope note (line 16) is consistent with the Project Layout description of vault as canonical layer.

DELTA: No change.

Section summary: 0 issues flagged / 0 deltas from previous audit.

---

### 2.4 Conventions not followed by actual files in the repo

**F-2 STATUS: RESOLVED.** Previous audit F-2 flagged `output/session-guide.md` not mentioned in CLAUDE.md layout. Current CLAUDE.md line 10 now reads: *"`output/session-guide.md` is a generated session-planning guide from `/session-guide`."* RESOLVED.

**F-3 STATUS: RESOLVED.** Previous audit F-3 flagged `principles.md`, `system-doc.md`, `blueprint.md` absent. All three now exist in `output/phase-1/`. RESOLVED.

**DISCREPANCY — `output/phase-1/` contains files not described in CLAUDE.md layout.**
CLAUDE.md line 10 describes `output/phase-1/` as holding: `inventory/`, `principles.md`, `system-doc.md`, `blueprint.md`. The directory also contains `components/` (12 files), `repo-state.md`, and `risk-topology.md` — none mentioned in the CLAUDE.md layout description.

DELTA: F-2 resolved (output/session-guide.md added to CLAUDE.md). F-3 resolved (output files now exist). New discrepancy: output/phase-1/components/, repo-state.md, risk-topology.md not in CLAUDE.md layout.

Section summary: 1 discrepancy flagged (output/phase-1 has 3 undescribed items) / 3 deltas from previous audit.

---

### 2.5 Features where one referenced file exists but another does not

None found. All referenced files and directories in the project CLAUDE.md exist. The `/archaeology` command exists; its optional reference scripts (`skill-inventory.sh`, `repo-audit.sh`) exist in ai-resources. The vault infrastructure files referenced in vault/CLAUDE.md all exist.

DELTA: Previous audit found 0 issues. No change.

Section summary: 0 issues flagged / 0 deltas from previous audit.

---

### 2.6 Sections containing task-type-specific instructions that scoping rules say belong elsewhere

**Project CLAUDE.md:**

| Section | Line count | Task-type addressed | Note |
|---|---|---|---|
| `## Input File Handling` | 11 | Input handling methodology | Explicitly acknowledged as mirroring workspace canonical rule. Self-stated rationale for duplication present. |
| `## Commit Rules` | 7 | Commit behavior methodology | Explicitly acknowledged as mirroring workspace canonical rule. Self-stated rationale for duplication present. |
| `## Compaction` | 7 | Compaction handling (what to preserve) | Project-specific state guidance — not duplicated from workspace CLAUDE.md. Adds project-specific context (stage identifier, pending reads, operator gates). |

**Vault CLAUDE.md:**

| Section | Line count | Task-type addressed | Note |
|---|---|---|---|
| `## Frontmatter Conventions` | 17 | File-format conventions for vault note frontmatter (required fields, shapes, status lifecycle) | Describes a file-format convention specific to vault notes. Content is vault-operation-specific and applies to every vault write operation. |
| `## Tag Taxonomy (seed)` | 7 | File-tagging conventions for vault notes | Describes allowed tag values for vault notes. Vault-operation-specific. |
| `## Index Maintenance Rule (atomic)` | 9 | Operational process for maintaining vault indexes on writes | Describes a write-discipline rule (3-part atomic update). Vault-operation-specific process rule. |
| `## Cross-Reference Convention` | 4 | Wiki-link syntax convention for vault notes | File-format convention for linking inside vault. Vault-operation-specific. |

DELTA: Project CLAUDE.md sections unchanged from previous audit. Vault CLAUDE.md is new — 4 sections contain task-methodology content (frontmatter conventions, tag taxonomy, index maintenance, cross-reference convention). These are vault-specific operational rules and file-format conventions.

Section summary: 6 sections flagged (2 with acknowledged duplication rationale; 1 project-specific; 4 vault-specific) / 5 new vault sections added.

---

## Section 3: Dependency References

### 3.1 Files referenced by each slash command and whether they exist

**`/archaeology` (project-local):**

| Referenced File | Exists |
|---|---|
| `ai-resources/scripts/skill-inventory.sh` (optional) | Y |
| `ai-resources/scripts/repo-audit.sh` (optional) | Y |
| `pipeline/decisions.md` (referenced in scope text, line 20) | **N — BROKEN** (directory renamed to `pipeline-phase-1/`; correct path is `pipeline-phase-1/decisions.md`) |
| `output/phase-1/inventory/components.md` (output) | Y (now exists) |
| `output/phase-1/inventory/fragments.md` (output) | Y (now exists) |
| `output/phase-1/inventory/phase-2-prototypes.md` (output) | Y (now exists) |
| `output/phase-1/inventory/complexity-signal.md` (output) | Y (now exists) |

**Symlinked commands (51 total):** All are symlinks to external `ai-resources/.claude/commands/`. All targets exist except `/resolve-improvements` (broken). Internal references within those commands are outside this scope.

**Vault-local commands:**

| Command | Referenced File | Exists |
|---|---|---|
| `vault/.claude/commands/kb-integrity.md` | `references/documentation-structure.md` (Check G schema ref) | Y |
| `vault/.claude/commands/kb-update.md` | `vault/templates/component-file-template.md`, `vault/templates/narrative-note-template.md` | Y, Y |

DELTA: Previous audit: 0 broken references in /archaeology (output files were expected-absent pre-M1.1). Current: 1 broken path reference in `/archaeology` line 20 (`pipeline/decisions.md` no longer exists — directory renamed to `pipeline-phase-1/`). Output files that were missing are now present. Vault commands are new.

Section summary: 2 issues flagged (1 broken path in /archaeology; 1 broken /resolve-improvements symlink) / 2 new issues since previous audit.

---

### 3.2 Command output → input chains

**`/archaeology` → Phase 1 milestones (complete):**
- `/archaeology` produced `output/phase-1/inventory/*.md` (4 files) — these have been executed (M1.1 complete)
- These fed M1.2 (principles), M1.3 (structure), M1.4 (system-doc, blueprint, components)
- Phase 1 complete as of 2026-04-29

**Phase 2 chains:**
- `doc-scanner-agent` (W2.1) writes `output/phase-2/w2-1-doc-scan-YYYY-MM-DD.md`; these feed `/implementation-triage` and operator triage sessions
- `principles-checker-agent` (W2.2) writes `output/phase-2/w2-2-principles-YYYY-MM-DD.md`; feeds operator review
- Phase 2 maintenance subagents fire from `/friday-checkup` (monthly+ tier) per CLAUDE.md
- `/kb-update` writes vault component files; `/kb-integrity` reads vault + `references/documentation-structure.md`

**Log append chains (unchanged):**
- `/friction-log`, `/note`, `/wrap-session` (symlinks) append to project log files

DELTA: Phase 1 archaeology→milestones chain completed. Phase 2 chains are new (W2.1, W2.2, W2.3, W2.4 subagent flows). Vault commands (`kb-update`, `kb-integrity`) added as new chains.

Section summary: 4 chains documented / 3 new chains since previous audit.

---

### 3.3 Files referenced by more than one command, hook, or script

| File | Referenced By |
|---|---|
| `ai-resources/.claude/hooks/auto-sync-shared.sh` | SessionStart hook in `.claude/settings.json` |
| `references/documentation-structure.md` | CLAUDE.md (line 9), `pipeline-phase-1/architecture.md`, `pipeline-phase-2/implementation-spec.md`, `vault/.claude/commands/kb-update.md` (Step 3 schema), `vault/.claude/commands/kb-integrity.md` (Check G), `.claude/agents/doc-scanner-agent.md` (Phase 5 field shape) |
| `pipeline-phase-1/decisions.md` | `.claude/commands/archaeology.md` (stale path `pipeline/decisions.md`); `pipeline-phase-1/architecture.md` (internal cross-ref) |
| `output/phase-1/inventory/complexity-signal.md` | `.claude/commands/archaeology.md` (output contract); `output/session-guide.md` (Session 1 instructions) |
| `output/phase-1/system-doc.md` | CLAUDE.md line 16 (D-1 supersession reference); `output/phase-1/blueprint.md` (cross-ref) |
| `.claude/hooks/friction-log-trigger.sh` | `.claude/settings.json` PostToolUse hook |

DELTA: Previous audit: 4 multi-referenced files. Current: 6 — `references/documentation-structure.md` reference count increased (vault commands and doc-scanner-agent added as referencing parties). `output/phase-1/system-doc.md` and `friction-log-trigger.sh` are new multi-referenced items.

Section summary: 6 multi-referenced files identified / 2 new since previous audit.

---

### 3.4 Files ranked by downstream reference count (top 10)

| Rank | File | Reference Count | Referenced By |
|---|---|---|---|
| 1 | `references/documentation-structure.md` | 7 | CLAUDE.md; pipeline-phase-1/architecture.md; pipeline-phase-2/implementation-spec.md; vault/.claude/commands/kb-update.md; vault/.claude/commands/kb-integrity.md; .claude/agents/doc-scanner-agent.md; pipeline-phase-2/architecture.md |
| 2 | `.claude/commands/archaeology.md` | 5 | CLAUDE.md; pipeline-phase-1/decisions.md; pipeline-phase-1/implementation-log.md; pipeline-phase-1/architecture.md; .claude/shared-manifest.json |
| 3 | `output/phase-1/inventory/complexity-signal.md` | 2 | .claude/commands/archaeology.md (output contract); output/session-guide.md |
| 4 | `output/phase-1/inventory/components.md` | 2 | .claude/commands/archaeology.md (output contract); pipeline-phase-1/architecture.md (data flow) |
| 5 | `pipeline-phase-1/decisions.md` | 2 | .claude/commands/archaeology.md (stale path); pipeline-phase-1/architecture.md |
| 6 | `output/phase-1/system-doc.md` | 2 | CLAUDE.md (line 16); output/phase-1/blueprint.md |
| 7 | `ai-resources/scripts/skill-inventory.sh` | 1 | .claude/commands/archaeology.md |
| 8 | `ai-resources/scripts/repo-audit.sh` | 1 | .claude/commands/archaeology.md |
| 9 | `ai-resources/.claude/hooks/auto-sync-shared.sh` | 1 | .claude/settings.json (SessionStart) |
| 10 | `.claude/hooks/friction-log-trigger.sh` | 1 | .claude/settings.json (PostToolUse) |

DELTA: `references/documentation-structure.md` reference count grew from 7 to 7+ (same rank 1, additional referencing parties). `output/session-guide.md` dropped from top-10 (lower reference count relative to new items). New entries: `output/phase-1/system-doc.md`, `friction-log-trigger.sh`.

Section summary: 0 issues flagged / 0 deltas from previous audit.

---

### 3.5 Symlinks in `.claude/commands/` or `.claude/agents/` — coverage check

All 71 valid symlinks (50 command symlinks with existing targets + 20 agent symlinks + 1 vault command symlink) resolve to targets inside `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/`. The `permissions.additionalDirectories` in `.claude/settings.json` contains `"/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"`. This workspace root is an ancestor of all symlink targets (string-prefix match). All valid symlink targets are covered.

The broken symlink (`.claude/commands/resolve-improvements.md`) points to a non-existent target at `ai-resources/.claude/commands/resolve-improvements.md`. Coverage check is moot for a broken symlink.

Vault `settings.json` also contains `additionalDirectories: ["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]`, covering the vault's `consult.md` symlink target.

None found (for resolvable symlinks) — checked all 71 valid symlinks against `permissions.additionalDirectories`; all targets covered by workspace root entry.

DELTA: 18 new symlinks; all have targets under workspace root. 1 broken symlink (new finding). Vault symlink coverage check passed.

Section summary: 1 issue flagged (broken /resolve-improvements symlink) / 1 new issue since previous audit.

---

### 3.6 Projects referencing ai-resources without proper additionalDirectories entry

The project references `ai-resources/` via: the SessionStart auto-sync hook, 51 command symlinks, 20 agent symlinks, and `/archaeology` command body references to `ai-resources/scripts/*.sh`.

`permissions.additionalDirectories` in `.claude/settings.json` contains `"/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"` (workspace root), which is an ancestor of `ai-resources/`. This covers all `ai-resources/` references.

None found — workspace root in `additionalDirectories` covers all ai-resources references.

DELTA: No change.

Section summary: 0 issues flagged / 0 deltas from previous audit.

---

## Section 4: Consistency Checks

### 4.1 Skill structural pattern

No skills exist in this project. N/A — out of scope for projects/repo-documentation (no skills present).

DELTA: No change.

Section summary: N/A.

---

### 4.2 Slash command definition pattern

**Project-local command (`/archaeology`):** Unchanged from previous audit. Has YAML frontmatter with `name:`, `description:`, `model: sonnet`. Frontmatter delimited by `---`. Body follows expected Claude Code structure. No deviation found.

**Symlinked commands:** All are symlinks to ai-resources. Internal definition patterns are outside this scope. All targets exist except `/resolve-improvements` (broken).

**Vault-local commands (`/kb-integrity`, `/kb-update`):** Both are regular files. Read by `cat` to check structure: both have YAML frontmatter with `name:`, `description:`, `model:` fields. Frontmatter delimited by `---`. Body has numbered step sections. Follow expected pattern.

No deviation found within project-local and vault-local commands.

DELTA: 2 new vault-local commands added; both follow expected pattern. No new deviations.

Section summary: 0 issues flagged / 2 new commands checked, 0 issues.

---

### 4.3 Skill template comparison

N/A — No skill creation template file exists. Skills are created via /create-skill which references ai-resource-builder/SKILL.md for format standards.

---

### 4.4 Naming convention inconsistencies

All files and directories in AUDIT_ROOT use lowercase with hyphens (e.g., `vault-maintenance-fix-plan-2026-05-06.md`, `w2-1-doc-scan-2026-05-01.md`, `friction-log-trigger.sh`). Dated output files use `YYYY-MM-DD` suffix convention. `CLAUDE.md` uses conventional uppercase. `_master-index.md` and `_integrity-report-*.md` use leading underscore — consistent within the vault sub-scope where this is a vault convention (Obsidian sorting).

None found — checked all file and directory names in AUDIT_ROOT against lowercase-with-hyphens convention.

DELTA: No new violations. Vault uses leading-underscore convention for index and integrity files; consistent within vault scope.

Section summary: 0 issues flagged / 0 deltas from previous audit.

---

### 4.5 Directory structure violations

| Item | Expected (per CLAUDE.md) | Actual | Match |
|---|---|---|---|
| `output/phase-1/` with `inventory/`, `principles.md`, `system-doc.md`, `blueprint.md` | Present | All present | Match |
| `output/phase-2/` for Phase 2 outputs | Present | Exists; 9 execution output files + 1 placeholder | Match |
| `output/session-guide.md` | Present (mentioned in CLAUDE.md line 10) | Exists | Match |
| `vault/` — Obsidian KB infrastructure | Present (mentioned in CLAUDE.md line 11) | Exists | Match |
| `working/archaeology/` and `working/elicitation/` | Present, gitignored contents | Both exist | Match |
| `logs/decisions.md`, `logs/friction-log.md`, `logs/session-notes.md` | Present | All exist | Match |
| `.claude/commands/archaeology.md` | Present | Exists | Match |
| `pipeline-phase-2/` | Present (mentioned in CLAUDE.md line 7) | Exists (10 files) | Match |

**DISCREPANCY — `output/phase-1/` contains files not described in CLAUDE.md layout:**
`output/phase-1/` contains `components/` (12 files), `repo-state.md`, and `risk-topology.md` — not mentioned in CLAUDE.md `## Project Layout` description. The layout description enumerates `inventory/`, `principles.md`, `system-doc.md`, `blueprint.md` only.

**DISCREPANCY — `pipeline-phase-1/` is the actual directory name; CLAUDE.md line 7 refers to `pipeline-phase-2/` (correct) but the Phase 1 pipeline directory is now `pipeline-phase-1/` (not mentioned in CLAUDE.md layout).**
CLAUDE.md `## Project Layout` does not describe the `pipeline-phase-1/` directory or `pipeline-phase-2/` directory. These are real directories with 10 files each but are not covered in the layout description.

DELTA: F-2 resolved (session-guide.md now in CLAUDE.md). F-3 resolved (output files now present). New discrepancy: output/phase-1/components/, repo-state.md, risk-topology.md unlisted in CLAUDE.md. pipeline-phase-1/ and pipeline-phase-2/ directories not listed in CLAUDE.md layout (though previously `pipeline/` was also not listed).

Section summary: 2 discrepancies flagged / 2 old discrepancies resolved, 1 new discrepancy.

---

### 4.6 Command syntax and path resolution check

**`/archaeology`:**
- YAML frontmatter: well-formed (`name`, `description`, `model: sonnet`)
- **BROKEN path reference:** Line 20 reads: *"`harness/` — entire directory excluded per architecture Decision D-1 (recorded in `pipeline/decisions.md`, repo-documentation project)."* The directory `pipeline/` no longer exists — it was renamed to `pipeline-phase-1/` on 2026-04-30 (commit `46e9a88`). The correct path is `pipeline-phase-1/decisions.md`, which exists.
- All other input paths resolve: `ai-resources/scripts/skill-inventory.sh` (Y), `ai-resources/scripts/repo-audit.sh` (Y)
- Output paths (`output/phase-1/inventory/*.md`) now exist (M1.1 complete)

**`/resolve-improvements` (symlink):** Target `ai-resources/.claude/commands/resolve-improvements.md` does not exist. Command is broken.

**Vault commands (`/kb-integrity`, `/kb-update`):** Both have well-formed frontmatter. Referenced file `references/documentation-structure.md` exists. Vault template files referenced in `kb-update.md` exist.

DELTA: Previous audit: /archaeology passed all checks. Current: /archaeology has 1 broken path reference (`pipeline/decisions.md`). `/resolve-improvements` symlink is broken (new finding). Vault commands are new and pass checks.

Section summary: 2 issues flagged (1 broken path in /archaeology, 1 broken /resolve-improvements symlink) / 2 new issues.

---

### 4.7 Duplicate or conflicting command names

**Duplicates within project scope:** None found — all 52 command names are unique. No two `.claude/commands/*.md` files share a basename.

**Conflicts with Claude Code built-in commands (`help`, `clear`, `compact`, `model`, `new`, `auto`, `plan`):** None found. New commands checked: `architecture-review`, `consult`, `deploy-kb`, `friday-so`, `implementation-triage`, `innovation-sweep`, `monday-prep`, `resolve-improvement-log`, `resolve`, `save-session`, `session-plan`, `session-start`, `so-monthly`, `systems-review`. None match built-ins.

DELTA: 14 new command names added; none duplicate existing commands or built-ins.

Section summary: 0 issues flagged / 0 deltas from previous audit.

---

### 4.8 Agent tier declarations vs tier table

Read `model:` frontmatter from all 23 agent files; compared against `ai-resources/docs/agent-tier-table.md`.

**Agents previously checked (tier table status unchanged):**

| Agent | Declared Tier | In Tier Table | Expected Tier | Match |
|---|---|---|---|---|
| `claude-md-auditor.md` | opus | YES (added 2026-04-27) | opus | Match |
| `collaboration-coach.md` | opus | YES | opus | Match |
| `critical-resource-auditor.md` | opus | YES (added 2026-04-27) | opus | Match |
| `dd-extract-agent.md` | haiku | YES | haiku | Match |
| `dd-log-sweep-agent.md` | haiku | YES | haiku | Match |
| `execution-agent.md` | sonnet | YES | sonnet | Match |
| `improvement-analyst.md` | opus | YES | opus | Match |
| `permission-sweep-auditor.md` | sonnet | YES (added 2026-04-27) | sonnet | Match |
| `qc-reviewer.md` | opus | YES | opus | Match |
| `refinement-reviewer.md` | opus | YES | opus | Match |
| `repo-dd-auditor.md` | sonnet | YES | sonnet | Match |
| `risk-check-reviewer.md` | opus | YES (added 2026-04-27) | opus | Match |
| `token-audit-auditor-mechanical.md` | haiku | YES | haiku | Match |
| `token-audit-auditor.md` | opus | YES | opus | Match |
| `triage-reviewer.md` | opus | YES | opus | Match |
| `workflow-analysis-agent.md` | opus | YES | opus | Match |
| `workflow-critique-agent.md` | opus | YES | opus | Match |

**New agents added since previous audit — tier table check:**

| Agent | Declared Tier | In Tier Table | Expected Tier | Match |
|---|---|---|---|---|
| `doc-scanner-agent.md` (local file) | sonnet | NO | N/A | Missing from table |
| `findings-extractor.md` (symlink to ai-resources) | haiku | NO | N/A | Missing from table |
| `innovation-triage-auditor.md` (symlink to ai-resources) | opus | NO | N/A | Missing from table |
| `principles-checker-agent.md` (local file) | sonnet | NO | N/A | Missing from table |
| `system-developer-agent.md` (local file) | opus | NO | N/A | Missing from table |
| `system-owner.md` (symlink to ai-resources) | opus | NO | N/A | Missing from table |

6 new agents present in this project are absent from `ai-resources/docs/agent-tier-table.md`: `doc-scanner-agent` (sonnet), `findings-extractor` (haiku), `innovation-triage-auditor` (opus), `principles-checker-agent` (sonnet), `system-developer-agent` (opus), `system-owner` (opus).

DELTA: Previous audit: 4 agents missing from tier table (claude-md-auditor, critical-resource-auditor, permission-sweep-auditor, risk-check-reviewer). Those 4 have since been added to the tier table (all now match). 6 new agents added to this project since the previous audit — all 6 are absent from the tier table.

Section summary: 6 discrepancies flagged (6 new agents missing from tier table) / 4 old discrepancies resolved, 6 new.

---

### 4.9 settings.json comparison against canonical new-project.md baseline

**Canonical baseline source:** `ai-resources/.claude/commands/new-project.md` (last commit: no git-tracked commits found; file last modified 2026-04-30 per filesystem). `CANONICAL_PERMS` block is at line ~312.

**Project `.claude/settings.json` last commit:** 2026-05-06 (commit `cad4848` — removed `model` field).

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
| `defaultMode: bypassPermissions` | Required | Present | Match |
| Top-level `model` value | `"sonnet"` per canonical | **Absent** — model field removed 2026-05-06 | Informational only per operator preference |

Note: The `model` field was previously `"sonnet[1m]"` (reported as deliberate discrepancy in prior audit); it has since been removed entirely (commit `cad4848`, 2026-05-06). Per operator preference stated in the audit invocation, a missing `model` field in `.claude/settings.json` is treated as informational, not a finding.

**Vault `settings.json`:** Contains `"model": "sonnet[1m]"` at top level. Vault deny list differs from canonical project baseline: includes vault-specific deny entries (`Read(../output/phase-1/**)`, `Write(../output/phase-1/**)`, `Edit(../output/phase-1/**)`) and omits some canonical project allow entries (`Agent`, `MultiEdit`, `NotebookEdit`, etc.). This is expected for the vault's restricted scope.

DELTA: Previous audit: `model` field was `"sonnet[1m]"` (discrepancy vs canonical `"sonnet"`). Current: `model` field removed entirely from project `settings.json` (2026-05-06). Per operator preference, treated as informational. All deny entries still match canonical. PostToolUse hook entry is new in settings.json (not present in canonical — project-specific addition).

Section summary: 0 issues flagged (model field treated as informational per operator preference) / 1 delta from previous audit (model field removed).

---

## Section 5: Context Load

### 5.1 Total context loaded at session start

| Source | Line count |
|---|---|
| Workspace CLAUDE.md (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md`) | 161 |
| Project CLAUDE.md (`projects/repo-documentation/CLAUDE.md`) | 53 |
| **Total auto-loaded** | **~214 lines** |

No auto-loaded skills or references configured. SessionStart hook performs symlink sync; does not load CLAUDE.md content. No `@import` directives in project CLAUDE.md.

Note: Vault sessions load `vault/CLAUDE.md` (124 lines) instead of project CLAUDE.md — vault is a separate Claude Code project scope within the parent project.

DELTA: Workspace CLAUDE.md grew from 204 to 161 lines (net decrease — workspace CLAUDE.md was refactored between audits; line count appears to have decreased, possibly from section removals or compressions). Project CLAUDE.md grew from 51 to 53 lines.

Section summary: ~214 lines total context load / 2 deltas from previous audit.

---

### 5.2 CLAUDE.md sections not referenced by any slash command, hook, or operational instruction

All six sections of the project CLAUDE.md address cross-session operational behavior. `## Project Layout` is purely navigational (no command or hook references it) — consistent with previous audit finding. No dead-weight sections.

DELTA: No change from previous audit.

Section summary: 0 issues flagged / 0 deltas from previous audit.

---

### 5.3 CLAUDE.md line count at last 5 commits

| Date | Commit | Line count | Subject |
|---|---|---|---|
| 2026-04-30 | d164068 | 53 | feat(repo-documentation): B1 — W2.5 vault infrastructure |
| 2026-04-30 | 303e64d | 52 | feat(repo-documentation): add W2.5 (Obsidian vault) to Phase 2 plan; fix CLAUDE.md |
| 2026-04-30 | 46e9a88 | 51 | refactor(repo-documentation): rename pipeline/ → pipeline-phase-1/ |
| 2026-04-29 | 1bfe340 | 51 | batch: remove model-routing.md references from workspace and project files |
| 2026-04-27 | c1ecb5b | 51 | fix: document output/session-guide.md in Project Layout (F-2) |

Note: 7 total commits have modified CLAUDE.md (including the 2026-04-25 initial commit and the 2026-04-27 audit-triggered fix). The 5 most recent are shown.

DELTA: Previous audit: only 1 commit modifying CLAUDE.md (2026-04-25). Current: 7 total commits; 6 since the project was created. 3 commits on 2026-04-30 (pipeline rename, vault plan addition, vault infrastructure). CLAUDE.md grew from 51 to 53 lines.

Section summary: 0 issues flagged / 5 deltas from previous audit (5 new commits).

---

## Section 6: Drift & Staleness

### 6.1 Files not modified in last 90 days but still referenced

Audit date: 2026-05-08. 90-day lookback: since 2026-02-07.

All files in AUDIT_ROOT were committed on or after 2026-04-25. Earliest project commit date: 2026-04-25. No file in this project predates the 90-day window.

None found — checked git commit dates; all project files committed 2026-04-25 or later, well within 90-day window.

DELTA: No change.

Section summary: 0 issues flagged / 0 deltas from previous audit.

---

### 6.2 TODO, FIXME, PLACEHOLDER, or similar marker comments

Searched all `.md`, `.json`, and `.sh` files in AUDIT_ROOT for: `TODO`, `FIXME`, `HACK`, `XXX`, `PLACEHOLDER`.

| Marker | Count | Locations |
|---|---|---|
| `TODO` | 0 | None found |
| `FIXME` | 0 | None found |
| `HACK` | 0 | None found |
| `XXX` | 0 | None found |
| `PLACEHOLDER` | 0 | None found |

The `references/documentation-structure.md` previously contained `[POPULATED IN M1.3]` skeleton placeholders. These are gone — file is now ACTIVE with real content (447 lines).

DELTA: Previous audit: `[POPULATED IN M1.3]` skeleton markers in `references/documentation-structure.md`. Current: no markers — file is now ACTIVE. No new markers found in any of the extensive new content added since the previous audit.

Section summary: 0 issues flagged / 1 delta from previous audit (skeleton placeholders removed).

---

### 6.3 Empty files, stub files, or files that contain only boilerplate

| File | State | Expected |
|---|---|---|
| `inputs/.gitkeep` | Zero bytes | Expected — inputs directory is empty; no operator inputs supplied |
| `output/phase-1/.gitkeep` | Zero bytes | Expected — placeholder alongside real content |
| `output/phase-1/inventory/.gitkeep` | Zero bytes | Expected — inventory directory has 4 real files + placeholder |
| `output/phase-2/.gitkeep` | Zero bytes | Expected — Phase 2 output directory has real content |
| `output/phase-2/w2-4-proposals/.gitkeep` | Zero bytes | Expected — proposals directory is empty pending W2.4 execution |
| `.claude/agents/.gitkeep` | Zero bytes | Expected — directory now has 23 agent files alongside placeholder |
| `.claude/hooks/.gitkeep` | Zero bytes | Expected — directory now has 1 real script alongside placeholder |
| `working/archaeology/.gitkeep` | Zero bytes | Expected — gitignored working directory |
| `working/elicitation/.gitkeep` | Zero bytes | Expected — gitignored working directory |

**Previously stub, now populated:**
- `logs/decisions.md` — 47 lines with real content
- `logs/friction-log.md` — 19 lines with real content
- `logs/session-notes.md` — 678 lines with real content
- `references/documentation-structure.md` — 447 lines, status ACTIVE
- All `output/phase-1/` deliverables — real content produced by M1.1–M1.5

No empty or stub files found beyond the expected `.gitkeep` placeholders.

DELTA: Previous audit had 4 stub log files and 1 skeleton template. All are now populated with real content. 9 `.gitkeep` files remain (same count as before; 1 new placeholder added: `output/phase-2/w2-4-proposals/.gitkeep`).

Section summary: 0 issues flagged / 6 deltas from previous audit (stubs populated).

---

## Findings Summary

**Total findings: 11**

| # | Type | Finding |
|---|---|---|
| F-1 | RESOLVED | ~~CLAUDE.md cited wrong file for Decision D-1~~ — Fixed 2026-04-27 |
| F-2 | RESOLVED | ~~output/session-guide.md not in CLAUDE.md layout~~ — Fixed 2026-04-27 |
| F-3 | RESOLVED | ~~output/phase-1 deliverables absent~~ — Phase 1 complete 2026-04-29 |
| F-4 | RESOLVED | ~~model value sonnet[1m] vs canonical sonnet~~ — Field removed 2026-05-06 (informational per operator preference) |
| F-5 | RESOLVED | ~~claude-md-auditor missing from tier table~~ — Added to tier table 2026-04-27 |
| F-6 | RESOLVED | ~~critical-resource-auditor missing from tier table~~ — Added 2026-04-27 |
| F-7 | RESOLVED | ~~permission-sweep-auditor missing from tier table~~ — Added 2026-04-27 |
| F-8 | RESOLVED | ~~risk-check-reviewer missing from tier table~~ — Added 2026-04-27 |
| F-9 | Discrepancy | `settings.local.json` is empty `{}` on this machine; CLAUDE.md `## Model Selection` states the model default is set there. Per CLAUDE.md the file is gitignored and per-machine — this is the on-machine state at audit time. |
| F-10 | Discrepancy | `output/phase-1/` contains `components/` (12 files), `repo-state.md`, and `risk-topology.md` — none mentioned in CLAUDE.md `## Project Layout` section, which lists only `inventory/`, `principles.md`, `system-doc.md`, `blueprint.md`. |
| F-11 | Discrepancy (broken reference) | `.claude/commands/archaeology.md` line 20 references `pipeline/decisions.md` — that directory was renamed to `pipeline-phase-1/` on 2026-04-30. Correct path is `pipeline-phase-1/decisions.md`. |
| F-12 | Violation (broken symlink) | `.claude/commands/resolve-improvements.md` is a symlink to `ai-resources/.claude/commands/resolve-improvements.md`. That target file does not exist. The symlink was resolving at the time of the previous audit; the target has since been removed from ai-resources (no matching file found; appears to have been superseded by `/resolve` and `/resolve-improvement-log`). |
| F-13 | Missing item | `doc-scanner-agent` (declared `sonnet`) is present in this project (local file) but absent from `ai-resources/docs/agent-tier-table.md`. |
| F-14 | Missing item | `findings-extractor` (declared `haiku`) is present in this project (symlink to ai-resources) but absent from `ai-resources/docs/agent-tier-table.md`. |
| F-15 | Missing item | `innovation-triage-auditor` (declared `opus`) is present in this project (symlink to ai-resources) but absent from `ai-resources/docs/agent-tier-table.md`. |
| F-16 | Missing item | `principles-checker-agent` (declared `sonnet`) is present in this project (local file) but absent from `ai-resources/docs/agent-tier-table.md`. |
| F-17 | Missing item | `system-developer-agent` (declared `opus`) is present in this project (local file) but absent from `ai-resources/docs/agent-tier-table.md`. |
| F-18 | Missing item | `system-owner` (declared `opus`) is present in this project (symlink to ai-resources) but absent from `ai-resources/docs/agent-tier-table.md`. |

**Active findings: 10** (F-9 through F-18; F-1 through F-8 all resolved since previous audit)

**Breakdown:**
- Discrepancies: 3 (F-9, F-10, F-11)
- Violations: 1 (F-12 — broken symlink)
- Missing items: 6 (F-13 through F-18 — agents absent from tier table in ai-resources)
- Resolved since previous audit: 8 (F-1 through F-8)
- Clean checks: All symlinks resolve except 1 (F-12); all settings.json deny entries present; no duplicate commands; no naming violations; no TODO markers; no stale files (all within 90-day window); no dead-weight CLAUDE.md sections; hook scripts exist and are executable; all deny entries match canonical baseline.
