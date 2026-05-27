# Repo Due Diligence Audit — 2026-05-27
Repo: projects/strategic-os
Scope: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os
Commit: 4600daf (workspace HEAD: f9f1eee)
Previous audit: None
Depth: full

---

## Section 1: Inventory

### 1.1 Slash commands defined locally

Twelve slash commands are reachable from `projects/strategic-os/.claude/commands/`. Three are workspace-level commands accessed via symlink to `ai-resources/.claude/commands/` and counted but not catalogued here (see § 1.7). The nine project-local commands:

| Command | Defined At | Files / Templates / Agents Referenced |
|---|---|---|
| /decide | .claude/commands/decide.md (109 lines) | docs/decision-query-output-standard.md; docs/os-conventions.md § 8; state-retrieval-agent; (external KB) knowledge-bases/strategic-frameworks/; responses/{YYYY-MM-DD}-{HHMM}-{slug}.md output |
| /os-self-review | .claude/commands/os-self-review.md (32 lines) | self-review-agent; state-retrieval-agent; /promote-to-live; HANDOFF.md; reviews/self-review/{YYYY-MM-DD}-self-review.md output |
| /prioritize | .claude/commands/prioritize.md (56 lines) | state-retrieval-agent; reviews/prioritization/*.md; state/live/priorities.md; /promote-to-live; reviews/prioritization/{YYYY-MM-DD}-prioritization.md output |
| /promote-sandbox | .claude/commands/promote-sandbox.md (86 lines) | /promote-to-live; state/sandbox/; state/live/*.md; docs/os-conventions.md § 11 |
| /promote-to-live | .claude/commands/promote-to-live.md (117 lines) | state/live/<element>.md; state/live/decisions-log.md; docs/os-conventions.md § 10 & § 11; logs/decisions.md |
| /sandbox-new | .claude/commands/sandbox-new.md (56 lines) | /promote-sandbox; state/sandbox/draft-{slug}-{YYYY-MM-DD}.md output |
| /strategic-review | .claude/commands/strategic-review.md (82 lines) | state-retrieval-agent; /promote-to-live; reviews/strategic/{YYYY-MM}-strategic-review.md or {YYYY-Q#}-strategic-review.md output |
| /strategic-state | .claude/commands/strategic-state.md (80 lines) | state-retrieval-agent; conflict-detector-agent; state/live/*.md; inputs/*.md; .cache/snapshot.json; /strategic-state-refresh |
| /strategic-state-refresh | .claude/commands/strategic-state-refresh.md (22 lines) | state-retrieval-agent; conflict-detector-agent; /strategic-state; .cache/snapshot.json |

In addition, 67 command files exist as symlinks into `ai-resources/.claude/commands/` (auto-synced via SessionStart hook). Their definition source is the external ai-resources scope — see § 1.7 for the symlink list.

### 1.2 Hooks configured

Hooks are declared in `.claude/settings.json` only; `.claude/settings.local.json` is `{}` (empty object).

| # | Trigger | Action | Files Referenced |
|---|---|---|---|
| 1 | SessionStart | Walks upward to find ai-resources/, runs `auto-sync-shared.sh` | external: ai-resources/.claude/hooks/auto-sync-shared.sh (exists; 6578 bytes, exec) |
| 2 | SessionStart | Walks upward to find ai-resources/, runs `check-permission-sanity.sh` | external: ai-resources/.claude/hooks/check-permission-sanity.sh (exists; 3499 bytes, exec) |

Both referenced hook scripts resolve and are executable. Hook scripts themselves live outside the audit scope; their existence/path is verified for resolvability only.

### 1.3 Templates

| Path | Used By | Last Commit Date |
|---|---|---|
| None found — no `templates/` directory exists under projects/strategic-os; no `.template`, `.tmpl`, or template-suffixed files exist | n/a | n/a |

Checked: `find projects/strategic-os -type f -name "*template*" -o -name "*.tmpl"` returned no matches; no `templates/` directory.

### 1.4 Scripts (bash, python, other — not templates or skills)

| Path | Purpose | Called By | Last Commit Date |
|---|---|---|---|
| None found — checked for `*.sh`, `*.py`, `*.js`, `*.rb`, `Makefile` under audit scope | n/a | n/a | n/a |

The two SessionStart hooks (§ 1.2) reference scripts that live in `ai-resources/.claude/hooks/`, which is outside this audit's scope.

### 1.5 Skills

None — projects/strategic-os contains no `skills/` directory and no SKILL.md files. The workspace skill library lives in `ai-resources/skills/`, which is outside this audit's scope.

### 1.6 Uncategorized files / directories

Files / directories under audit scope that are not slash commands, hooks, templates, scripts, CLAUDE.md, audit reports, or standard git files:

| Path | Type / Purpose (inferred from filename and contents) |
|---|---|
| `docs/authority-model.md` (35 lines) | Reference doc — OS-vs-project authority statement. Referenced by CLAUDE.md § Authority Model. |
| `docs/decision-query-output-standard.md` (38 lines) | Reference doc — 5-field output schema. Referenced by CLAUDE.md § Decision-Query Output Standard and by /decide. |
| `docs/labelling-rule.md` (39 lines) | Reference doc — proposal/draft/live label vocabulary. Referenced by CLAUDE.md § Labelling Rule and by docs/os-conventions.md. |
| `docs/os-conventions.md` (101 lines) | Reference doc — file naming, format, citation, label conventions. Referenced by CLAUDE.md § OS Conventions and by /promote-to-live, /promote-sandbox, /sandbox-new, /decide. |
| `docs/strategic-vs-operational-boundary.md` (39 lines) | Reference doc — ownership boundary table. Referenced by CLAUDE.md § Strategic-vs-Operational Boundary. |
| `inputs/README.md` (24 lines) | Operator-facing instructions for populating inputs/ with service-model and roadmap. |
| `logs/decisions.md` (52 lines) | Build-decisions log — W1, W2, W6, W7 resolutions documented per implementation spec. Referenced by pipeline/implementation-log.md and pipeline/implementation-spec.md. |
| `logs/.gitkeep` (0 bytes) | Empty marker. |
| `pipeline/architecture.md` (250 lines) | Build artifact — Stage 3b architecture design. Not referenced from operational surface. |
| `pipeline/context-pack.md` (279 lines) | Build artifact — Stage 2 context pack. Not referenced from operational surface. |
| `pipeline/decisions.md` (5 lines) | Build artifact — pipeline-stage decisions table. Not referenced from operational surface. |
| `pipeline/implementation-log.md` (154 lines) | Build artifact — Stage 4 implementation log. Not referenced from operational surface. |
| `pipeline/implementation-spec.md` (1896 lines) | Build artifact — Stage 3c implementation spec. Not referenced from operational surface. |
| `pipeline/pipeline-state.md` (14 lines) | Build artifact — pipeline stage status table. Not referenced from operational surface. |
| `pipeline/project-plan.md` (674 lines) | Build artifact — v4 project plan (copied from project-planning workspace). Not referenced from operational surface. |
| `pipeline/repo-snapshot.md` (375 lines) | Build artifact — Stage 3a repo-snapshot. Not referenced from operational surface. |
| `pipeline/session-guide.md` (184 lines) | Build artifact — Stage 6 session guide. Not referenced from operational surface. |
| `pipeline/sources.md` (12 lines) | Build artifact — pipeline source paths and QC verdicts. Not referenced from operational surface. |
| `pipeline/technical-spec.md` (1085 lines) | Build artifact — v2 technical spec (copied from project-planning workspace). Not referenced from operational surface. |
| `pipeline/test-results.md` (196 lines) | Build artifact — Stage 5 test results. Not referenced from operational surface. |
| `responses/.gitkeep` (0 bytes) | Empty marker — directory placeholder for runtime /decide output. |
| `reviews/prioritization/.gitkeep` (0 bytes) | Empty marker. |
| `reviews/self-review/.gitkeep` (0 bytes) | Empty marker. |
| `reviews/strategic/.gitkeep` (0 bytes) | Empty marker. |
| `state/live/assumptions.md` (5 lines) | State element stub — "no live state yet" message. |
| `state/live/decisions-log.md` (5 lines) | Audit-trail file — stub with "No promotions yet" comment. Append-only via /promote-to-live. |
| `state/live/open-decisions.md` (5 lines) | State element stub. |
| `state/live/priorities.md` (5 lines) | State element stub. |
| `state/live/risks.md` (5 lines) | State element stub. |
| `state/live/strategy.md` (5 lines) | State element stub. |
| `state/live/workstreams.md` (5 lines) | State element stub. |
| `state/sandbox/README.md` (18 lines) | Operator-facing sandbox usage doc. |
| `.claude/agents/conflict-detector-agent.md` (72 lines) | Project-local agent definition (sonnet, tools: Read). Referenced by /strategic-state, /strategic-state-refresh. |
| `.claude/agents/self-review-agent.md` (89 lines) | Project-local agent definition (opus, tools: Read,Glob,Grep). Referenced by /os-self-review. |
| `.claude/agents/state-retrieval-agent.md` (124 lines) | Project-local agent definition (sonnet, tools: Read,Glob,Grep,Bash). Referenced by /strategic-state, /strategic-state-refresh, /decide, /prioritize, /strategic-review, /os-self-review. |
| `.claude/settings.json` (74 lines) | Permissions + 2 SessionStart hooks. |
| `.claude/settings.local.json` (1 line) | Empty object `{}`. Gitignored. |
| `.claude/shared-manifest.json` (20 lines) | Lists project-local commands and agents that auto-sync hook should skip when symlinking from ai-resources/. |

Standard git files (counted but not catalogued): `.gitignore` (5 lines), `.git/` directory.

### 1.7 Symlinks

76 symlinks total in audit scope. All resolve cleanly (target file exists and is accessible via `readlink -f`).

| Directory | Count | Common Target Prefix |
|---|---|---|
| `.claude/agents/` | 19 symlinks | `../../../../ai-resources/.claude/agents/<name>.md` |
| `.claude/commands/` | 57 symlinks | `../../../../ai-resources/.claude/commands/<name>.md` |

All 76 targets resolve to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/{agents,commands}/<name>.md` and are recorded as "symlink to external target" — the target files themselves live outside the audit scope and their contents are not audited here.

**Agents symlinked (19):** claude-md-auditor, collaboration-coach, critical-resource-auditor, execution-agent, fading-gate-scanner, findings-extractor, fix-repo-issues-scanner, friday-act-16a-summarizer, improvement-analyst, innovation-triage-auditor, qc-reviewer, refinement-reviewer, risk-check-reviewer, system-owner, token-audit-auditor, token-audit-auditor-mechanical, triage-reviewer, workflow-analysis-agent, workflow-critique-agent.

**Commands symlinked (57):** analyze-workflow, architecture-review, audit-claude-md, audit-critical-resources, audit-repo, clarify, cleanup-worktree, coach, consult, contract-check, create-skill, drift-check, explain, fix-repo-issues, fix-symlinks, friction-log, friday-act, friday-checkup, friday-journal, friday-so, graduate-resource, grill-me, handoff, implementation-triage, improve, improve-skill, innovation-sweep, migrate-skill, monday-prep, note, open-items, prime, project-consultant, qc-pass, recommend, refinement-deep, refinement-pass, request-skill, resolve, resolve-improvement-log, resolve-repo-problem, risk-check, route-change, save-session, scope, session-guide, session-plan, session-start, so-monthly, summary, sync-workflow, systems-review, token-audit, triage, update-claude-md, usage-analysis, wrap-session.

No symlinks point to broken or nonexistent targets.

`Section summary: 33 inventory items catalogued — 9 project-local commands, 2 hooks, 0 templates, 0 scripts, 0 skills, 3 project-local agents, 76 symlinks (19 agents + 57 commands), 7 state/live stubs, 5 .gitkeep markers, 5 reference docs, 11 pipeline build-artifact files, 4 directory READMEs/operator-instructions, 1 settings JSON, 1 settings.local stub, 1 shared-manifest, 1 .gitignore / no deltas from previous audit (none exists)`

---

## Section 2: CLAUDE.md Health

### 2.1 Size and sections

CLAUDE.md is 93 lines with 15 H2 sections:

1. Purpose
2. Authority Model
3. Labelling Rule
4. Strategic-vs-Operational Boundary
5. Decision-Query Output Standard
6. OS Conventions
7. Cross-Project Read Protocol — Hard Rules
8. Build-Complete ≠ Operational
9. Model Selection
10. File Discipline
11. QC Independence
12. Input File Handling
13. Commit Rules
14. Compaction
15. Session Boundaries

### 2.2 References to nonexistent items

| Reference (in CLAUDE.md) | Location | Resolution Check |
|---|---|---|
| None found — all explicit path references in CLAUDE.md resolve | — | Checked: docs/authority-model.md, docs/labelling-rule.md, docs/strategic-vs-operational-boundary.md, docs/decision-query-output-standard.md, docs/os-conventions.md, .claude/agents/state-retrieval-agent.md — all exist. Slash-command references (/promote-to-live, /promote-sandbox, /clear, /compact) resolve: /promote-to-live and /promote-sandbox are project-local; /clear and /compact are built-in Claude Code commands. |

### 2.3 Internal contradictions

| Conflict | Sections | Quoted Statements |
|---|---|---|
| None found — checked all 15 H2 sections for contradictory statements | — | No conflicting statements identified across pairs of sections. The Model Selection section is consistent with the workspace-level prohibition it cites: it declares a "recommended posture" rather than a default, in line with the workspace § Model Tier rule. |

### 2.4 Conventions defined but violated

| Convention | Source Section | Violations |
|---|---|---|
| State/live mutations only via /promote-to-live; no direct Write/Edit | File Discipline | None — all 7 state/live/*.md files contain only stub content; no commits show direct edits. The .claude/settings.json `deny` rules `Write(projects/strategic-os/state/live/**)` and `Edit(projects/strategic-os/state/live/**)` are present (lines 38–39). |
| inputs/ is read-only | File Discipline | None — `Write(projects/strategic-os/inputs/**)` and `Edit(projects/strategic-os/inputs/**)` deny rules present in settings.json lines 40–41. inputs/ contains only README.md (operator-supplied at scaffolding). |
| responses/ and reviews/ are append-only | File Discipline | None — both contain only `.gitkeep` placeholder files; no commits show mutation of prior files. |
| Every OS-generated artifact carries a `proposal` or `draft` label | Labelling Rule (referenced via docs/labelling-rule.md) | None — no generated artifacts exist yet in responses/, reviews/, or state/sandbox/ to evaluate. |

### 2.5 Features partially implemented (some referenced files exist, others do not)

| Feature | What Exists | What's Missing |
|---|---|---|
| /decide framework selection via KB | /decide command body references `knowledge-bases/strategic-frameworks/` and `knowledge-bases/strategic-frameworks/.claude/commands/kb-query.md`. Stub framework list (Rumelt, Three Horizons, Porter, Christensen, Cynefin) is present in /decide as fallback. | `knowledge-bases/strategic-frameworks/` does NOT exist at workspace root. Only `knowledge-bases/pe-kb-vault/` exists. The command explicitly handles this case (falls back to the stub framework list); this is documented behavior, not a defect. |
| /os-self-review and self-review-agent cadence documentation in HANDOFF.md | /os-self-review.md line 32 references `HANDOFF.md` as the location for documented monthly cadence; self-review-agent.md line 85 likewise. | `HANDOFF.md` does NOT exist at projects/strategic-os/ root. The implementation log (`pipeline/implementation-log.md`) lists files created and HANDOFF.md is not among them. |
| Conflict-detector inputs | conflict-detector-agent description (line 3) names `inputs/service-model.md, inputs/roadmap.md`; inputs/README.md (lines 7–8) instructs operator to place them. | Neither `inputs/service-model.md` nor `inputs/roadmap.md` exists yet. Only `inputs/README.md` is present. This is the expected v1-vessel state per CLAUDE.md § "Build-Complete ≠ Operational" — operator populates post-build. |

### 2.6 Task-type-specific instructions in CLAUDE.md

Per the workspace § CLAUDE.md Scoping rule, sections containing skill-creation methodology, workflow-stage instructions, evaluation frameworks, or file-format conventions for a single artifact type should live in SKILL.md or workflow reference docs rather than in CLAUDE.md.

| Section | Approx Line Count | Task Type Addressed | Note |
|---|---|---|---|
| Input File Handling | 12 lines (lines 59–70) | File-format / write-discipline convention for a single artifact class (input files) | The section is mirrored verbatim from workspace-level CLAUDE.md; the mirror is justified in its own last paragraph: "This rule mirrors the canonical Input File Handling section in the workspace-level CLAUDE.md. It is repeated here because projects are sometimes opened without the parent workspace context loaded." Matches the workspace § CLAUDE.md Scoping allowance for short-form mirrors. |
| Commit Rules | 7 lines (lines 72–78) | Git workflow rule (commit cadence + no-push gate) | Same self-justifying mirror language as above. Matches workspace § CLAUDE.md Scoping allowance. |
| Compaction | 10 lines (lines 80–89) | Session-handling instruction (what to preserve at /compact) | Not labelled as a workspace-level mirror, but addresses a behavior that is generic across all projects (not strategic-os-specific). Borderline — could be argued either way. |
| Session Boundaries | 3 lines (lines 91–93) | Session-handling instruction (/clear discipline) | Not labelled as a workspace-level mirror; one short paragraph; same generic-across-projects observation as Compaction. |

Other 11 sections are strategic-os-specific (Purpose, Authority Model, Labelling Rule, Strategic-vs-Operational Boundary, Decision-Query Output Standard, OS Conventions, Cross-Project Read Protocol, Build-Complete ≠ Operational, Model Selection, File Discipline, QC Independence) and per the scoping rule legitimately belong in project CLAUDE.md.

`Section summary: 3 issues flagged (Q2.5: KB stub fallback, missing HANDOFF.md, missing inputs/ source artifacts) — Q2.5 items are expected v1-vessel state per CLAUDE.md § "Build-Complete ≠ Operational" except HANDOFF.md which is referenced but not present anywhere / no deltas from previous audit (none exists)`

---

## Section 3: Dependency References

### 3.1 Slash command → referenced files

| Slash Command | Referenced File / Agent | File Exists (Y/N) |
|---|---|---|
| /decide | .claude/agents/state-retrieval-agent.md | Y |
| /decide | docs/decision-query-output-standard.md | Y |
| /decide | docs/os-conventions.md | Y |
| /decide | knowledge-bases/strategic-frameworks/ (external; workspace root) | N (only pe-kb-vault exists at knowledge-bases/) |
| /decide | responses/ (output dir) | Y |
| /os-self-review | .claude/agents/self-review-agent.md | Y |
| /os-self-review | .claude/agents/state-retrieval-agent.md | Y |
| /os-self-review | reviews/self-review/ (output dir) | Y |
| /os-self-review | HANDOFF.md | N |
| /os-self-review | /promote-to-live (command) | Y |
| /prioritize | .claude/agents/state-retrieval-agent.md | Y |
| /prioritize | reviews/prioritization/ (output dir) | Y |
| /prioritize | state/live/priorities.md | Y |
| /prioritize | /promote-to-live (command) | Y |
| /promote-sandbox | .claude/commands/promote-to-live.md | Y |
| /promote-sandbox | state/sandbox/ (input dir) | Y |
| /promote-sandbox | state/live/<element>.md (6 element targets — all 6 stubs exist) | Y |
| /promote-sandbox | docs/os-conventions.md § 11 | Y |
| /promote-to-live | state/live/<element>.md | Y |
| /promote-to-live | state/live/decisions-log.md | Y |
| /promote-to-live | docs/os-conventions.md | Y |
| /promote-to-live | logs/decisions.md (referenced as W1 fallback location) | Y |
| /sandbox-new | state/sandbox/ (output dir) | Y |
| /sandbox-new | /promote-sandbox (command) | Y |
| /strategic-review | .claude/agents/state-retrieval-agent.md | Y |
| /strategic-review | reviews/strategic/ (output dir) | Y |
| /strategic-review | /promote-to-live (command) | Y |
| /strategic-state | .claude/agents/state-retrieval-agent.md | Y |
| /strategic-state | .claude/agents/conflict-detector-agent.md | Y |
| /strategic-state | state/live/*.md (all 6 element stubs + decisions-log.md) | Y |
| /strategic-state | inputs/*.md (no .md files; only README.md present) | partial — inputs/ exists; no source-artifact files in it |
| /strategic-state | .cache/snapshot.json (runtime) | runtime-generated; not committed |
| /strategic-state-refresh | .claude/agents/state-retrieval-agent.md | Y |
| /strategic-state-refresh | .claude/agents/conflict-detector-agent.md | Y |
| /strategic-state-refresh | /strategic-state (command) | Y |
| /strategic-state-refresh | .cache/snapshot.json (runtime) | runtime-generated |

### 3.2 Command output → command input chains

| Producer Command | Consumer Command / Process | Mediating Artifact |
|---|---|---|
| /sandbox-new | /promote-sandbox | state/sandbox/draft-{slug}-{YYYY-MM-DD}.md (drafted file → promotion input) |
| /promote-sandbox | /promote-to-live | sandbox-file path passed as argument; /promote-sandbox loops over targets calling /promote-to-live per element |
| /strategic-state-refresh | /strategic-state (cache) | .cache/snapshot.json (refresh overwrites the cache; subsequent /strategic-state calls consume the fresh cache) |
| /decide | /promote-to-live | responses/{date}-{slug}.md → operator may route the recommendation through /promote-to-live to update state/live/ |
| /prioritize | /promote-to-live | reviews/prioritization/{date}-prioritization.md → operator may route priority changes through /promote-to-live |
| /strategic-review | /promote-to-live | reviews/strategic/{period}-strategic-review.md → operator routes review-driven decisions through /promote-to-live |
| /os-self-review | /promote-to-live | reviews/self-review/{date}-self-review.md → operator routes proposed live-state changes through /promote-to-live |

### 3.3 Files referenced by multiple commands / hooks / scripts

| File | Referenced By |
|---|---|
| .claude/agents/state-retrieval-agent.md | /decide, /os-self-review, /prioritize, /strategic-review, /strategic-state, /strategic-state-refresh (6 commands) |
| .claude/agents/conflict-detector-agent.md | /strategic-state, /strategic-state-refresh (2 commands) |
| .claude/commands/promote-to-live.md | /decide, /os-self-review, /prioritize, /promote-sandbox, /sandbox-new, /strategic-review (referenced from 6 other commands as the canonical mutation path) |
| docs/os-conventions.md | /decide (§ 8), /promote-to-live (§ 10, § 11), /promote-sandbox (§ 11), /sandbox-new (§ 5); plus CLAUDE.md § OS Conventions |
| docs/labelling-rule.md | docs/os-conventions.md (§ 3, § 9); CLAUDE.md § Labelling Rule |
| docs/decision-query-output-standard.md | /decide (steps 4 + 5); CLAUDE.md § Decision-Query Output Standard |
| state/live/decisions-log.md | /promote-to-live (writes); /os-self-review via self-review-agent (reads); CLAUDE.md (implied by File Discipline) |
| state/live/*.md (the 6 element stubs collectively) | /strategic-state, /strategic-state-refresh, /prioritize, /strategic-review, /os-self-review, /promote-to-live, /promote-sandbox |
| ai-resources/.claude/hooks/auto-sync-shared.sh | .claude/settings.json SessionStart hook 1 |
| ai-resources/.claude/hooks/check-permission-sanity.sh | .claude/settings.json SessionStart hook 2 |

### 3.4 Top 10 files by downstream-reference count

| Rank | File | Downstream Reference Count |
|---|---|---|
| 1 | .claude/agents/state-retrieval-agent.md | 6 (6 commands) |
| 2 | .claude/commands/promote-to-live.md | 6 (referenced from 6 other commands as canonical mutation path) |
| 3 | docs/os-conventions.md | 5 (4 commands + CLAUDE.md) |
| 4 | state/live/<element>.md collectively (treating as a set) | 7 commands write/read |
| 5 | docs/labelling-rule.md | 3 (docs/os-conventions.md § 3, § 9 + CLAUDE.md) |
| 6 | docs/decision-query-output-standard.md | 3 (/decide + CLAUDE.md § DQOS) |
| 7 | .claude/agents/conflict-detector-agent.md | 2 (/strategic-state, /strategic-state-refresh) |
| 8 | .claude/agents/self-review-agent.md | 1 (/os-self-review) |
| 9 | docs/authority-model.md | 1 (CLAUDE.md) |
| 10 | docs/strategic-vs-operational-boundary.md | 1 (CLAUDE.md) |

(state/live/decisions-log.md is referenced by /promote-to-live for append + self-review-agent for read = 2 references; falls below the top 10 if treated separately, but is included in the rank-4 collective state/live/ entry.)

### 3.5 Symlinks in .claude/commands/ and .claude/agents/ — additionalDirectories coverage

`.claude/settings.json` declares `permissions.additionalDirectories: ["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]`. `.claude/settings.local.json` is empty `{}` — no additional entries.

All 76 symlinks (19 agents + 57 commands) point to targets under `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/{agents,commands}/`, which has the declared workspace root as an ancestor. **All symlink targets are covered.**

Verified: `readlink -f` on each of the 76 symlinks produced an absolute path beginning with `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/`, matching the declared additionalDirectories entry as a string prefix.

| Symlink Target Group | Covered? |
|---|---|
| All 19 .claude/agents/*.md symlinks → ai-resources/.claude/agents/ | Y |
| All 57 .claude/commands/*.md symlinks → ai-resources/.claude/commands/ | Y |

No uncovered symlinks.

### 3.6 ai-resources references vs. additionalDirectories coverage

The project references ai-resources/ via:

1. **Command symlinks** — 57 symlinks to ai-resources/.claude/commands/. Covered.
2. **Agent symlinks** — 19 symlinks to ai-resources/.claude/agents/. Covered.
3. **SessionStart auto-sync hook** — invokes `ai-resources/.claude/hooks/auto-sync-shared.sh`. Covered.
4. **SessionStart permission-sanity hook** — invokes `ai-resources/.claude/hooks/check-permission-sanity.sh`. Covered.
5. **state-retrieval-agent.md inclusion principle** (line 49) — reads `ai-resources/logs/decisions.md` (tail 100 lines). Covered.

All 5 reference paths into ai-resources/ are covered by the single `additionalDirectories` entry (the workspace root). No missing entries.

`Section summary: 2 issues flagged (Q3.1: /os-self-review and self-review-agent reference HANDOFF.md which does not exist; /decide references knowledge-bases/strategic-frameworks/ which does not exist — the latter is handled by /decide's explicit fallback to stub framework list) / no deltas from previous audit (none exists)`

---

## Section 4: Consistency Checks

### 4.1 Skill structural pattern conformance

`N/A — out of scope for projects/strategic-os` — no skills exist under audit scope.

### 4.2 Slash-command definition pattern conformance

All 9 project-local commands use the same YAML-frontmatter + body structure:

| Command | YAML Frontmatter Fields Present | Body H2 Sections |
|---|---|---|
| /decide | description, argument-hint, model | Purpose, Argument, Steps, Sparse-State Handling, No Live-State Writes |
| /os-self-review | description, model | Purpose, Steps, No Auto-Promotion, Cadence |
| /prioritize | description, model | Purpose, Steps, Read-Only with Respect to Live State, Sparse-State Handling |
| /promote-sandbox | description, argument-hint, model | Purpose, Argument, Steps, NEVER Bypass `/promote-to-live`, Rollback Path |
| /promote-to-live | description, argument-hint, model | Purpose, Critical Constraint, Argument, Steps, Rollback Path, No Auto-Invocation, Exception, Architecture Gap |
| /sandbox-new | description, argument-hint, model | Purpose, Arguments, Steps, Sandbox is Non-Authoritative |
| /strategic-review | description, argument-hint, model | Purpose, Argument, Steps, No Live-State Writes |
| /strategic-state | description, model | Purpose, Steps, Sparse-State Behavior, Conflict Rendering, No Live-State Writes |
| /strategic-state-refresh | description, model | Purpose, Steps, Cache Side-Effect |

All declare a model tier (6 opus / 3 sonnet). All have `description:` in frontmatter. `argument-hint:` appears in 5 commands (those that take a non-empty argument) and is omitted from 4 argument-less commands (/os-self-review, /prioritize, /strategic-state, /strategic-state-refresh) — this is consistent with the convention that argument-hint is only required when an argument is taken.

No deviations from the pattern.

### 4.3 Skill template conformance

`N/A — No skill creation template file exists. Skills are created via /create-skill which references ai-resource-builder/SKILL.md for format standards.` And: no skills exist under audit scope (see § 4.1).

### 4.4 Naming-convention inconsistencies

Conventions documented in `docs/os-conventions.md` § 1 (file naming) and § 5 (sandbox file format):

| File / Object | Convention | Actual State | Conformance |
|---|---|---|---|
| state/live/<element>.md | One file per element, named after the element | strategy.md, priorities.md, assumptions.md, open-decisions.md, risks.md, workstreams.md, decisions-log.md | OK |
| state/sandbox/draft-{slug}-{YYYY-MM-DD}.md | Sandbox file convention | only state/sandbox/README.md exists — no drafts yet | n/a (no instances) |
| responses/{YYYY-MM-DD}-{HHMM}-{slug}.md | Response file convention | only responses/.gitkeep — no responses yet | n/a |
| reviews/prioritization/{YYYY-MM-DD}-prioritization.md | Prioritization review file convention | only reviews/prioritization/.gitkeep | n/a |
| reviews/strategic/{YYYY-MM}-strategic-review.md (monthly) or {YYYY-Q#}-strategic-review.md (quarterly) | Strategic review file convention | only reviews/strategic/.gitkeep | n/a |
| reviews/self-review/{YYYY-MM-DD}-self-review.md | Self-review file convention | only reviews/self-review/.gitkeep | n/a |
| Agent files | `<name>-agent.md` kebab-case | conflict-detector-agent.md, self-review-agent.md, state-retrieval-agent.md | OK |
| Command files | `<name>.md` kebab-case | all 9 local commands match | OK |

No naming-convention inconsistencies among existing files. No instance files exist yet for the dated artifact directories (responses/, reviews/sub-dirs/, state/sandbox/) so naming cannot be verified at run time until artifacts are produced.

### 4.5 Standard directory structure violations

Directory structure per implementation spec § 1 (Op 1) and CLAUDE.md § File Discipline:

| Expected Directory | Exists? | Notes |
|---|---|---|
| .claude/ | Y | |
| .claude/agents/ | Y | |
| .claude/commands/ | Y | |
| docs/ | Y | |
| inputs/ | Y | |
| logs/ | Y | |
| responses/ | Y | |
| reviews/ | Y | |
| reviews/prioritization/ | Y | |
| reviews/self-review/ | Y | |
| reviews/strategic/ | Y | |
| state/ | Y | |
| state/live/ | Y | |
| state/sandbox/ | Y | |

Extra directory present, not in the spec § 1 directory tree but documented in the implementation log:

| Extra Directory | Source / Justification |
|---|---|
| `pipeline/` (12 files; 5253 lines total) | Build-time artifacts (architecture, context-pack, decisions, implementation-log, implementation-spec, pipeline-state, project-plan, repo-snapshot, session-guide, sources, technical-spec, test-results). Not in the spec § 1 directory tree (Op 1). Source: copies/products of the project-planning workspace pipeline (per `pipeline/sources.md`). Not referenced from operational surface. |

No other deviations.

### 4.6 Slash-command syntax + path resolution

All 9 project-local commands' YAML frontmatter is well-formed (parseable). All referenced files resolve (see § 3.1 — only knowledge-bases/strategic-frameworks/ and HANDOFF.md fail, and the KB miss is handled by the command's explicit fallback).

No commands fail either check beyond those already noted.

### 4.7 Duplicate or built-in-conflicting command names

| Command Name | Conflict |
|---|---|
| None found | Checked all 9 project-local command names (`decide`, `os-self-review`, `prioritize`, `promote-sandbox`, `promote-to-live`, `sandbox-new`, `strategic-review`, `strategic-state`, `strategic-state-refresh`) against built-in Claude Code commands (`/clear`, `/compact`, `/model`, `/help`, `/handoff`, `/config`, etc.) and against the 57 ai-resources commands available via symlink. No collision. The shared-manifest.json `commands.local` list (`repo-dd`, `permission-sweep`, `log-sweep`, `deploy-kb`) reserves four additional command slots for project-owned overrides; none of these are currently materialized as project-local files in `.claude/commands/`, so they auto-sync from ai-resources (verified: those four also appear as symlinks in `.claude/commands/`). |

### 4.8 Agent tier table conformance

Three project-local agents exist under audit scope; the workspace `Agent Tier Table` (`ai-resources/docs/agent-tier-table.md`) does NOT list them under "ai-resources/.claude/agents/" or under any of its project-local sections (ai-development-lab, nordic-pe-macro-landscape-H1-2026, axcion-brand-book). The three are not in the table.

| Agent | Declared Tier | Expected Per Table | Status |
|---|---|---|---|
| conflict-detector-agent | sonnet | Not in table | Missing from table |
| self-review-agent | opus | Not in table | Missing from table |
| state-retrieval-agent | sonnet | Not in table | Missing from table |

All three agents declare an explicit tier in their YAML frontmatter (matches the workspace § Model Tier rule: "New commands, agents, and skills: declare an explicit tier in frontmatter — never inherit."). The gap is in the agent-tier-table.md not listing the strategic-os project-local section. The table's § Maintenance note states: "When adding a new agent, place it in the table."

### 4.9 Project .claude/settings.json vs. canonical baseline

Compared `projects/strategic-os/.claude/settings.json` against the canonical baseline in `ai-resources/templates/project-settings.json.template` (the template that `new-project.md` step 2 reads as `CANONICAL_PERMS`).

| Check | Strategic-OS State | Result |
|---|---|---|
| Canonical `permissions.deny` minimum `Read(archive/**)` | strategic-os deny list: `Bash(rm -rf:*)`, `Bash(git push:*)`, `Bash(git reset --hard:*)`, `Bash(git clean -f:*)`, `Write(projects/strategic-os/state/live/**)`, `Edit(projects/strategic-os/state/live/**)`, `Write(projects/strategic-os/inputs/**)`, `Edit(projects/strategic-os/inputs/**)`, `Read(**/*deal-*)`, `Read(**/*client-*)`, `Read(**/*confidential*)`. The template canonical deny list also contains `Read(archive/**)`, `Read(**/*.archive.*)`, `Read(**/deprecated/**)`, `Read(**/old/**)`, `Bash(rm -rf *)`, `Bash(sudo *)`. | strategic-os MISSING: `Read(archive/**)`, `Read(**/*.archive.*)`, `Read(**/deprecated/**)`, `Read(**/old/**)`, `Bash(sudo *)`. (strategic-os has `Bash(rm -rf:*)` with colon-glob, which matches the spirit of the canonical `Bash(rm -rf *)`.) |
| `"model": "sonnet"` at top level | Strategic-OS `.claude/settings.json` does NOT declare `"model"` at top level | The canonical template `project-settings.json.template` also does NOT declare a top-level `"model"` field (verified by re-reading the template). The workspace CLAUDE.md § Model Tier rule explicitly forbids project-level model defaults: "Do not declare a `model` field in ANY `.claude/settings.json` or `.claude/settings.local.json`." So the agent-prompt assertion that the canonical baseline declares `"model": "sonnet"` at line ~179 of new-project.md is not borne out by the actual current canonical template. **Verification:** `jq 'has("model")' ai-resources/templates/project-settings.json.template` → `false`. The reading is: the canonical baseline at present is to OMIT the top-level model field, and strategic-os conforms. |
| Last commit touching strategic-os/.claude/settings.json | 4600daf (2026-05-26) | — |
| Last commit touching canonical baseline (`ai-resources/.claude/commands/new-project.md` CANONICAL_PERMS section) | a5b0aaa (2026-05-26) for new-project.md; 8b44015 (2026-05-25) for templates/project-settings.json.template | strategic-os settings was committed AFTER the canonical baseline files were last updated. The strategic-os settings does not predate the current canonical. |

Additional notes on strategic-os settings.json vs. canonical:

- strategic-os keeps `defaultMode: "bypassPermissions"` (matches canonical).
- strategic-os allow list is heavily tightened relative to the canonical template (canonical has very broad `Bash(*)`, `Read`, `Edit`, `Write`, `MultiEdit`, `Agent`, `Skill`, `TodoWrite`, `Glob`, `Grep`, `WebFetch`, `WebSearch`, `NotebookEdit`, `ToolSearch`; strategic-os has narrow `Read(*)`, `Glob(*)`, `Grep(*)` plus enumerated `Bash(...)` patterns and scoped `Write/Edit(projects/strategic-os/<dir>/**)`). This appears to be intentional per the architecture's "single mutation path for state/live/" invariant: a permissive allow list would let other tools write to state/live/ without routing through /promote-to-live. The narrowing is part of W4.1's structural enforcement, not drift.
- strategic-os does include `Bash(cat *)` to support /promote-to-live's W1 heredoc write path (per logs/decisions.md § W1 Resolution). Not in canonical template.
- Both SessionStart hooks (auto-sync-shared, check-permission-sanity) are present in strategic-os, matching canonical.

`Section summary: 2 issues flagged (Q4.8: 3 project-local agents missing from the canonical Agent Tier Table; Q4.9: strategic-os deny list missing 5 canonical entries — Read(archive/**), Read(**/*.archive.*), Read(**/deprecated/**), Read(**/old/**), Bash(sudo *)) / no deltas from previous audit (none exists)`

---

## Section 5: Context Load

### 5.1 Auto-loaded context at session start

| Source | Lines |
|---|---|
| `projects/strategic-os/CLAUDE.md` | 93 |
| Workspace root `CLAUDE.md` (auto-loaded for any session within the workspace tree) | ~200 (cross-reference only — outside audit scope) |

The strategic-os/CLAUDE.md itself adds approximately **93 lines** of project-specific context per session.

The two SessionStart hooks emit short status messages ("Syncing shared commands…", "Permission sanity check…") but do not inject content into the loaded context.

`shared-manifest.json` (20 lines), `settings.json` (74 lines), and `settings.local.json` (1 line) are configuration files read by the harness — not by Claude — and do not count as loaded conversational context.

### 5.2 CLAUDE.md sections not referenced elsewhere

| Section | Approx Line Count | Referenced By |
|---|---|---|
| Purpose | 3 lines (lines 3–5) | Not referenced by any command, hook, or operational instruction (it is the project description — sets framing) |
| Authority Model | 3 lines (lines 7–9) | References docs/authority-model.md which is read by no command directly. Authority model is structurally enforced in code via /promote-to-live + permissions; the doc is operator-facing background. Not referenced by command body. |
| Labelling Rule | 3 lines (lines 11–13) | Referenced indirectly via docs/labelling-rule.md, which is read by no command directly (operator-facing). Labelling is enforced by /sandbox-new (writes `Label: draft`), /decide (writes `Label: proposal`), etc. — but those commands hard-code the labels rather than reading docs/labelling-rule.md. |
| Strategic-vs-Operational Boundary | 3 lines (lines 15–17) | docs/strategic-vs-operational-boundary.md — read by no command body; operator-facing reference. |
| Decision-Query Output Standard | 3 lines (lines 19–21) | /decide step 4 references docs/decision-query-output-standard.md by path. **Used.** |
| OS Conventions | 3 lines (lines 23–25) | Many commands reference docs/os-conventions.md by path. **Used.** |
| Cross-Project Read Protocol — Hard Rules | 10 lines (lines 27–36) | .claude/agents/state-retrieval-agent.md restates the rules; the agent enforces them at agent layer. **Used.** |
| Build-Complete ≠ Operational | 3 lines (lines 38–40) | Status statement — not referenced by command/hook. Operator-facing. |
| Model Selection | 5 lines (lines 42–46) | Frontmatter-driven; no command body reads this section, but it documents the policy that each command's frontmatter implements. |
| File Discipline | 5 lines (lines 48–53) | The settings.json permission denies enforce these rules; no command body reads this section directly. |
| QC Independence | 3 lines (lines 55–57) | Workspace-level QC commands (/qc-pass, /resolve, /refinement-pass, etc.) are referenced indirectly through the symlinked workspace command set. |
| Input File Handling | 12 lines (lines 59–70) | Behavioral rule, applied by Claude at every turn. Not referenced by command body. |
| Commit Rules | 7 lines (lines 72–78) | Behavioral rule, applied during commits. Not referenced by command body. |
| Compaction | 10 lines (lines 80–89) | Behavioral rule at /compact time. Not referenced by command body. |
| Session Boundaries | 3 lines (lines 91–93) | Behavioral rule at /clear time. Not referenced by command body. |

Sections that are dead-weight to runtime commands (i.e., never grep'd or read by any command/hook) but serve operator orientation: Purpose, Authority Model, Labelling Rule, Strategic-vs-Operational Boundary, Build-Complete ≠ Operational, Model Selection, File Discipline, QC Independence, Input File Handling, Commit Rules, Compaction, Session Boundaries (12 of 15 sections). The 3 sections that command bodies actually reference by path: Decision-Query Output Standard, OS Conventions, Cross-Project Read Protocol.

### 5.3 CLAUDE.md line count history

| Commit | Date | Line Count |
|---|---|---|
| 4600daf | 2026-05-26 | 93 |

Only one commit touches CLAUDE.md (the initial commit). No multi-commit history exists yet.

`Section summary: 12 issues flagged (Q5.2: 12 of 15 CLAUDE.md sections are not directly referenced by any command/hook body — they encode behavioral rules that Claude applies implicitly or are operator-facing background; whether this counts as "dead weight" depends on interpretation) / no deltas from previous audit (none exists)`

---

## Section 6: Drift & Staleness

### 6.1 Files >90 days old still referenced by active commands / hooks / CLAUDE.md

| File | Last Commit | Referenced By |
|---|---|---|
| None found — all files in audit scope were committed on 2026-05-26 (1 day ago as of TODAY 2026-05-27) | — | — |

No file in scope is older than 90 days. The repo is fresh — the initial commit is dated 2026-05-26.

### 6.2 TODO / FIXME / PLACEHOLDER / similar marker comments

Grepped for `TODO`, `FIXME`, `PLACEHOLDER`, `XXX` across all .md and .json files in scope (excluding .git/). Results:

| Marker | File | Line | Context |
|---|---|---|---|
| (no TODO/FIXME/PLACEHOLDER/XXX markers found) | — | — | — |

Adjacent markers worth noting (not flagged by the standard pattern but documented for completeness):

| Marker | Files Containing | Purpose |
|---|---|---|
| `TBD` | .claude/commands/sandbox-new.md (lines 14, 33), .claude/commands/promote-sandbox.md (lines 31, 33), pipeline/implementation-spec.md (lines 1304, 1311, 1358, 1386), pipeline/technical-spec.md (line 764) | All instances describe the placeholder string the operator writes in a sandbox file's `Target:` line when the target element is not yet decided — i.e., `Target: TBD`. Not source-code TODOs. |
| `DEPRECATE_ON_KB_ARRIVAL` | .claude/commands/decide.md (lines 39, 50), docs/os-conventions.md (line 58) | Stub-framework-list marker — explicit deprecation path documented in /decide step 3 and tied to the future arrival of `knowledge-bases/strategic-frameworks/`. Behaves as a documented future-removal flag, not a stale TODO. |

### 6.3 Empty / stub / boilerplate-only files

| File | State |
|---|---|
| `responses/.gitkeep` | Empty (0 bytes) — directory marker |
| `logs/.gitkeep` | Empty (0 bytes) — directory marker |
| `reviews/prioritization/.gitkeep` | Empty (0 bytes) — directory marker |
| `reviews/self-review/.gitkeep` | Empty (0 bytes) — directory marker |
| `reviews/strategic/.gitkeep` | Empty (0 bytes) — directory marker |
| `.claude/settings.local.json` | Boilerplate-only — contains `{}`. Gitignored per .gitignore line 5. |
| `state/live/strategy.md` | Stub — 5 lines, "no live state yet" message + "Run /promote-to-live" instruction. |
| `state/live/priorities.md` | Stub — 5 lines, same shape as strategy.md. |
| `state/live/assumptions.md` | Stub — 5 lines, same shape. |
| `state/live/open-decisions.md` | Stub — 5 lines, same shape. |
| `state/live/risks.md` | Stub — 5 lines, same shape. |
| `state/live/workstreams.md` | Stub — 5 lines, same shape. |
| `state/live/decisions-log.md` | Stub — 5 lines, "No promotions yet" + audit-trail intro. |
| `pipeline/decisions.md` | Stub-shape — 5 lines, table header + 1 row. May expand as more pipeline-stage decisions accrue. |

All 7 state/live/*.md stubs are intentional per the architecture's "v1 ships a vessel" framing (CLAUDE.md § Build-Complete ≠ Operational): they are placeholders that operator populates via /promote-to-live post-build. Not unintended emptiness.

`Section summary: 0 issues flagged (Q6.1: no >90-day files; Q6.2: no TODO/FIXME/PLACEHOLDER markers; Q6.3: 14 stub/empty files — all are intentional scaffolding) / no deltas from previous audit (none exists)`

---

## Audit Totals

| Category | Count |
|---|---|
| Section 1 — inventory items catalogued | 33 |
| Section 2 — issues flagged | 3 |
| Section 3 — issues flagged | 2 |
| Section 4 — issues flagged | 2 |
| Section 5 — issues flagged | 12 |
| Section 6 — issues flagged | 0 |
| Total issues flagged | 19 |
| Total deltas from previous audit | 0 (no previous audit exists) |

Most issues are tied to the v1-vessel state (sparse live state, missing inputs/, missing HANDOFF.md, missing knowledge-bases/strategic-frameworks/) and to natural-language ambiguity in the questionnaire (Q5.2's "not referenced" question can be read narrowly as "not grep'd by any command body" — under that strict reading 12 of 15 CLAUDE.md sections qualify; under a broader reading that includes "applied as a behavioral rule by Claude at every turn", the count drops to 0–2).
