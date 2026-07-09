# Repo Architecture (Stage 1)

> **When to read this file:** Whenever you propose adding, moving, or restructuring an AI resource (skill, command, agent, hook, doc, log, prompt, workflow, audit artifact). Consulted by `/placement` to recommend placement; consulted by operators making architectural decisions.
>
> **Maintenance:** Hand-maintained. Review at quarterly `/friday-checkup` tier. If repo layout shifts, this file must be updated in the same commit.

---

## Top-level layout

```
~/Claude Code/Axcion AI Repo/                    # workspace root (git repo)
├── CLAUDE.md                                    # workspace-level always-loaded rules
├── .claude/                                     # workspace harness
│   ├── settings.json                            # workspace-level permissions, hooks, defaults
│   ├── settings.local.json                      # gitignored, per-machine
│   ├── hooks/                                   # workspace-level hooks (model-classifier, sync, etc.)
│   ├── agents/                                  # workspace-only agents (rare)
│   ├── commands/                                # workspace-only commands (rare; e.g., `status`, `validate`)
│   ├── references/                              # harness reference files (e.g., `harness-rules.md`)
│   ├── skills/                                  # workspace-only skills (rare)
│   └── worktrees/                               # claude-code worktree state
├── ai-resources/                                # shared resource library (sub-repo, --add-dir)
├── archive/                                     # GITIGNORED. Retired project repos, relocated by /archive-project (each keeps its own .git). Restore recipe = the per-project manifest in ai-resources/audits/working/.
├── artifacts/                                   # TRACKED. Durable workspace-level artifacts that belong to no single project — operator-fillable scaffolds, project-retirement context packs.
├── harness/                                     # harness dev project (separate concern)
│   └── prep/                                    # Phase 3 harness preparation material (templates, checklists, hardening log)
├── knowledge-bases/                             # standalone Obsidian KB vaults for cross-project reuse, deployed via /deploy-kb
├── logs/                                        # workspace-level logs (decisions, innovation, sessions)
├── projects/                                    # research/advisory projects (each = sub-repo; current set varies)
├── reports/                                     # workspace-level audit reports
└── workflows/                                   # workflow development workspace (templates graduate to ai-resources/workflows/)
```

```
~/Claude Code/Axcion AI Repo/ai-resources/       # shared resource library
├── CLAUDE.md                                    # ai-resources project rules
├── .claude/
│   ├── settings.json                            # ai-resources permissions, hooks, defaults
│   ├── commands/                                # canonical slash commands (autosynced to projects)
│   ├── agents/                                  # canonical agents (autosynced to projects)
│   └── hooks/                                   # ai-resources hooks
├── audits/                                      # audit artifacts
│   ├── risk-checks/                             # `/risk-check` reports
│   ├── incidents/                               # `/resolve-incident` per-incident full records
│   ├── pipeline-review-registry.md              # registry for `/pipeline-review` (subsumed `/audit-critical-resources` on 2026-05-29)
│   ├── friday-checkup-YYYY-MM-DD.md             # weekly/monthly/quarterly checkup reports
│   ├── permission-sweep-YYYY-MM-DD.md
│   ├── repo-due-diligence-YYYY-MM-DD.md
│   └── working/                                 # transient subagent working notes
├── docs/                                        # process documentation (load-on-demand)
├── inbox/                                       # skill request briefs (active queue)
│   └── archive/                                 # fulfilled briefs preserved as record
├── logs/                                        # canonical operational logs
│   ├── session-notes.md
│   ├── decisions.md
│   ├── friction-log.md
│   ├── coaching-log.md
│   ├── coaching-data.md
│   ├── improvement-log.md
│   ├── incident-log.md                          # `/resolve-incident` per-incident index (append-only)
│   ├── innovation-registry.md
│   ├── maintenance-observations.md
│   ├── tweak-log.md                             # `/tweak` per-invocation audit record
│   ├── usage-log.md
│   └── workflow-observations.md
├── plans/                                       # plan artifacts retained from sessions
├── prompts/                                     # standalone prompts for non-Claude tools (GPT-5, Perplexity)
├── reports/                                     # generated reports (less formal than audits/)
├── scripts/                                     # utility scripts
├── skills/                                      # canonical skill library (each in own folder)
│   └── <skill-name>/SKILL.md
├── style-references/                            # style materials for prose/formatting skills
├── templates/                                   # canonical deployable fragments consumed at scaffold time (project-settings + project CLAUDE.md sections)
├── usage/                                       # usage analytics scratch
└── workflows/                                   # graduated workflow templates
```

```
~/Claude Code/Axcion AI Repo/projects/<project>/  # one project sub-repo
├── CLAUDE.md                                     # project-specific always-loaded rules (no default model — prohibited)
├── .claude/
│   ├── settings.json                             # project permissions (no "model" field — prohibited)
│   ├── settings.local.json                       # per-machine overrides (no "model" field — prohibited)
│   ├── shared-manifest.json                      # declares which commands/agents are local vs shared
│   ├── commands/                                 # symlinks to ai-resources + project-local files
│   ├── agents/                                   # symlinks to ai-resources + project-local files
│   └── hooks/                                    # project-only hooks (rare)
├── logs/                                         # project-specific logs (decisions, friction, sessions)
├── output/                                       # generated project outputs
└── …                                             # project-specific structure
```

---

## Canonical homes by artifact type

| Artifact type | Canonical home | Distribution to projects |
|---|---|---|
| **Skill** (reusable procedural instructions) | `ai-resources/skills/<name>/SKILL.md` | Read by reference; never copied. |
| **Slash command** (operator-invoked, on-demand) | `ai-resources/.claude/commands/<name>.md` | Auto-symlinked into every project's `.claude/commands/` (subject to manifest opt-out). |
| **Agent definition** (subagent invoked by main session) | `ai-resources/.claude/agents/<name>.md` | Auto-symlinked into every project's `.claude/agents/` (subject to manifest opt-out). |
| **Hook** (event-driven shell script) | `ai-resources/.claude/hooks/*.sh` (ai-resources side) **or** `~/Claude Code/Axcion AI Repo/.claude/hooks/*.sh` (workspace side) | Not auto-distributed — declared in the relevant `settings.json`. |
| **Process documentation** (load-on-demand reference) | `ai-resources/docs/<name>.md` | Read on demand by commands or operator. |
| **Operational log** (session-notes, decisions, friction, etc.) | `ai-resources/logs/<name>.md` | Project-specific logs live in the project's own `logs/`. |
| **Audit artifact** (dated audit/checkup output) | `ai-resources/audits/<name-or-subdir>/<YYYY-MM-DD>-<slug>.md` | Audit-specific subdirs (e.g., `audits/risk-checks/`) keep the root tidy. |
| **Standalone prompt** (consumed by non-Claude tools) | `ai-resources/prompts/<name>.md` | Read directly by GPT-5/Perplexity flows. |
| **Workflow template** (graduated from `workflows/active/`) | `ai-resources/workflows/<name>/` | Graduated via `/graduate-resource`. |
| **Obsidian KB vault** (cross-project reuse) | `knowledge-bases/<name>/` | Deployed via `/deploy-kb` standalone option. Project-scoped vaults instead live under `projects/<project>/vault/`. |
| **Style reference** (style/formatting source) | `ai-resources/style-references/<name>.md` | Loaded by prose/formatting skills. |
| **Skill request brief** (intake) | `ai-resources/inbox/<slug>-brief.md` | Moved to `inbox/archive/` once `/create-skill` fulfills it. |
| **Plan artifact** (retained from a session) | `ai-resources/plans/<name>.md` (in-repo) **or** `~/.claude/plans/<auto-slug>.md` (Claude Code plan-mode default; outside repo) | Retain in-repo when load-bearing; otherwise let plan-mode default location apply. |
| **Workspace-level rule (cross-project)** | `~/Claude Code/Axcion AI Repo/CLAUDE.md` | Always loaded in every workspace session. |
| **ai-resources project rule** | `ai-resources/CLAUDE.md` | Always loaded in ai-resources sessions. |
| **Project-specific rule** | `projects/<project>/CLAUDE.md` | Always loaded in that project's sessions. |
| **Permission shape (canonical)** | `ai-resources/docs/permission-template.md` | Source of truth referenced by `/permission-sweep` and `/new-project`. |
| **Deployable canonical fragment** (consumed at scaffold time, not at runtime) | `ai-resources/templates/<name>` | Read by `/new-project` via walk-up to `ai-resources/`; never auto-distributed. Edit the fragment, not the consuming command. Examples: `templates/project-settings.json.template`, `templates/project-claude-md/*.md`. |
| **Project-retirement context pack** (content + briefing + git bundles preserved from one or more projects being retired) | `artifacts/<slug>-context/` | Tracked by the root repo, so it survives the retirement of the projects it describes and is pushed off-machine. Distinct from `archive/` (gitignored, holds the relocated repos themselves). Pairs with `/archive-project`: the pack is the *reading* path, the archived repo is the *recovery* path. Built by hand; no pipeline. Example: `artifacts/merged-os-context/`. |

**Project-local exceptions** (live in project's own `.claude/`, never in ai-resources):
- Pipeline-stage commands tightly coupled to one project's workflow (e.g., `pipeline-stage-3a.md` for `/new-project`).
- Project evaluator agents (e.g., `plan-evaluator`, `spec-evaluator` in `project-planning/`).
- Project-specific commands not intended for reuse (e.g., `kb-audit`, `kb-cross-theme` in `global-macro-analysis/`).
- Files listed in the project's `.claude/shared-manifest.json` under `commands.local` / `agents.local`.

---

## Symlink topology

The workspace's auto-sync hook (`ai-resources/.claude/hooks/auto-sync-shared.sh`, registered as a SessionStart hook) walks every project that has a `.claude/shared-manifest.json` and symlinks all `ai-resources/.claude/{commands,agents}/*.md` files into the project's `.claude/{commands,agents}/`.

**Sync rules:**
1. Existing files at the target are never overwritten (any kind: file, symlink, broken symlink).
2. Files listed in the manifest's `commands.local[]` / `agents.local[]` are skipped (project-owned).
3. Baked-in exclusions are skipped: `EXCLUDE_COMMANDS = "new-project deploy-workflow"`, `EXCLUDE_AGENT_GLOBS = "pipeline-stage-* session-guide-generator"` — these are ai-resources-meta and never belong inside a downstream project.
4. The hook walks upward from `$CLAUDE_PROJECT_DIR` to find the nearest `ai-resources/`, so it works for any project under the workspace root.
5. Symlinks are relative (`../../../../ai-resources/.claude/...`).

**Effect:** When you add a new command or agent to ai-resources, every project picks it up automatically on the next session start. No manifest edits required unless the project needs to opt out.

**Hooks are NOT auto-distributed** — they remain in their declared `.claude/hooks/` directory and are referenced explicitly from the corresponding `settings.json`.

---

## Cross-repo coupling points

| Coupling | Direction | Mechanism |
|---|---|---|
| Workspace ↔ ai-resources | bidirectional | `--add-dir` makes ai-resources visible to workspace and project sessions; auto-sync hook flows commands/agents downward into projects. |
| ai-resources → projects | downward | SessionStart symlink hook (above). |
| Project → ai-resources | upward | `shared-manifest.json` declares which shared resources are local-only (opt-out); skill request briefs land in `inbox/`; new innovations bubble up via `detect-innovation.sh` hook. |
| CLAUDE.md layering | three layers | Workspace CLAUDE.md (cross-project) + ai-resources CLAUDE.md (resource-repo rules) + project CLAUDE.md (project-specific). All always-loaded for sessions in their scope. |
| Permission template | one source of truth | `ai-resources/docs/permission-template.md` defines canonical settings shapes for all four layers (user / workspace / ai-resources / project). `/permission-sweep` audits drift; `/new-project` emits canonical shape per project. |

| Audit discipline | one source of truth | `ai-resources/docs/audit-discipline.md` lists `/risk-check` change classes, two-gate firing model, and Friday-cadence tiers. |
| Logs split | parallel | Workspace `logs/` (workspace-level decisions, innovations, sessions). ai-resources `logs/` (canonical resource-work logs). Project `logs/` (project-specific sessions). Each session writes to its own scope. |
| Command/agent ↔ knowledge-bases | read-only, downward | `/expert-check` (via the `expert-check-reviewer` agent) reads book-summary notes from a target KB vault under `knowledge-bases/` by path, topic-matched against the step subject. Read-only; advisory output only; requires an explicit KB target (no all-KB default). First shared consumer of `knowledge-bases/` vault content as command input. |

---

## Placement heuristics — "When adding X, consider Y"

### Q1: Is the artifact reusable across more than one project?

- **Yes** → ai-resources/ (skill, command, agent, doc, hook, prompt, workflow).
- **No, tightly coupled to one project** → that project's own `.claude/` or root.

### Q2: For reusable artifacts — which kind of artifact is it?

| If the artifact is… | …it's a |
|---|---|
| A reusable, procedural set of instructions auto-loaded by a skill index when its trigger pattern matches | **Skill** → `skills/<name>/SKILL.md` |
| Operator-invoked on-demand with specific input → produces specific output | **Slash command** → `.claude/commands/<name>.md` |
| A subprocess invoked by a slash command (or another agent) with fresh context | **Agent** → `.claude/agents/<name>.md` |
| Event-driven (SessionStart, PreToolUse, Stop, etc.); no operator invocation | **Hook** → `.claude/hooks/<name>.sh` |
| Reference text consulted by commands or operators on demand | **Process doc** → `docs/<name>.md` |
| Prompt consumed by GPT-5 / Perplexity / NotebookLM (not Claude) | **Standalone prompt** → `prompts/<name>.md` |
| Style/formatting source for prose work | **Style reference** → `style-references/<name>.md` |

### Q3: Is the artifact a slash command? Then which spawn shape?

- **Operator-invoked routing/diagnostic that doesn't need full context** → command + subagent (subagent contract: ≤30-line summary, full notes to disk).
- **Operator-invoked transformation that mutates files** → command runs in main session.
- **Operator-invoked advisory that produces a recommendation only** → command runs in main session, no subagent (e.g., `/recommend`, `/placement`).

### Q4: Is the artifact rule-shaped or prose-shaped?

- **Cross-project rule** (always-loaded) → workspace `CLAUDE.md`.
- **ai-resources rule** (always-loaded for ai-resources sessions) → `ai-resources/CLAUDE.md`.
- **Project rule** (always-loaded for one project) → that project's `CLAUDE.md`.
- **Methodology, methodology rule, multi-section reference** → `docs/<name>.md` (load-on-demand).
- **Skill methodology** → `skills/<name>/SKILL.md`.
- **Workflow methodology** → workflow's own `reference/` directory.

> **CLAUDE.md scoping rule** (from workspace CLAUDE.md): project CLAUDE.md is for cross-session project-specific rules only — content that applies to *every turn* in that project's sessions and cannot live elsewhere. Do not duplicate skill methodology, workflow methodology, or canonical workspace rules.

### Q5: Is the change a structural change class? Then run `/risk-check`.

Change classes (per `audit-discipline.md`):
- Hook edits (`.claude/hooks/*.sh`)
- Permission changes (`settings.json` allow/ask/deny)
- CLAUDE.md edits (workspace-level or always-loaded)
- New commands or skills
- New symlinks
- Automation with shared-state effects

**Two-gate firing model:** plan-time once (after plan approval) + end-time once (before commit). Per-change firing is the failure mode the gate model exists to prevent.

### Q6: Will the artifact write a log? Pick the right log.

| Log | What it captures | Written by |
|---|---|---|
| `logs/session-notes.md` | Per-session summary, decisions made, files created/modified | `/wrap-session` |
| `logs/decisions.md` | Significant decisions with rationale + alternatives | Operator-driven, often via wrap-session |
| `logs/friction-log.md` | Operator-observed friction events | `/friction-log` |
| `logs/coaching-log.md` | Backward-looking session pattern ratings (5 dims) | `/coach` |
| `logs/improvement-log.md` | Proposed improvements (Pending → Applied/Resolved) | `/improve`, `/resolve-improvement-log` |
| `logs/incident-log.md` | Per-incident one-line index (resolved/escalated/deferred); full records in `audits/incidents/` | `/resolve-incident` |
| `logs/innovation-registry.md` | Auto-detected new resources / patterns | `detect-innovation.sh` hook |
| `logs/maintenance-observations.md` | Repo-health observations from `/friday-act` | `/friday-act` |
| `logs/tweak-log.md` | Per-invocation audit record of cosmetic edits applied via `/tweak` | `/tweak` |
| `logs/usage-log.md` | Per-session usage telemetry | `/usage-analysis` |
| `logs/workflow-observations.md` | Workflow-pipeline observations | Workflow commands |
| `logs/session-plan-{YYYY-MM-DD}-{marker}.md` | Session orchestration plan (intent, model, source material, autonomy posture, risk). Date + marker-scoped per session — see `docs/session-marker.md` for the marker contract. | `/session-plan` |
| `logs/session-plan-{YYYY-MM-DD}-{marker}-pass2.md` | Companion plan file written by `/session-plan` when the operator picks option 3 from the same-session 3-option prompt (re-invocation fork). Concurrent-session collision routing was removed in atomic Phase 2+3 (Option A) — each session writes its own marker-scoped plan, so cross-session collision is structurally impossible. Known consumers: `/open-items` table (glob scan `logs/session-plan-*.md` covers both canonical and pass2). | `/session-plan` Step 0 |
| `logs/missions/{id}.md` (+ `missions/archive/`) | **Mission contract** — a multi-session goal (Goal / scope / Validation contract / Open threads). NOT an append-log: a frozen per-mission state file (only `status` + `Open threads` mutate). Read by `/prime` Step 1d (active scan), `/drift-check` Step 7a (validation-contract reference). Closed missions move to `missions/archive/`. Lives in the repo whose work the mission primarily mutates. | `/mission` (create/close) — never written from inside a session |

### Q7: Is the artifact a dated audit output? Use `audits/`.

- One-off comprehensive audits → `audits/<audit-type>-YYYY-MM-DD.md`.
- Recurring audit type with many entries → `audits/<audit-subdir>/YYYY-MM-DD-<slug>.md` (e.g., `audits/risk-checks/`).

### Q8: Is the artifact a manifest, configuration, or template?

- **Pipeline-review registry** → `audits/pipeline-review-registry.md`. (Replaced `critical-resources-manifest.md` on 2026-05-29 when `/pipeline-review` subsumed `/audit-critical-resources`.)
- **Permission template** → `docs/permission-template.md`.
- **Project shared-manifest** → `projects/<project>/.claude/shared-manifest.json`.
- **Settings layers** → see `docs/permission-template.md` for canonical shapes.
- **Deployable canonical fragment** (a file's contents are read at scaffold time by a consumer command and written into a target project) → `templates/<name>` under `ai-resources/`. Distinct from `docs/permission-template.md` (a doc that describes a shape) — these are the canonical bytes themselves, consumed verbatim. Read by walking up to `ai-resources/` (same idiom as `auto-sync-shared.sh`); never auto-distributed.

---

## When this file needs to change

Update `repo-architecture.md` in the same commit when any of the following lands:

- A new top-level directory under workspace root or ai-resources.
- A new artifact type that doesn't fit an existing canonical home.
- A change to the symlink topology (auto-sync rules, exclusion lists, manifest semantics).
- A new cross-repo coupling point.
- A new canonical doc that becomes a load-bearing source of truth.

Mechanical changes (renaming a single skill, adding the 71st skill, etc.) do **not** require an update — only structural changes do.

---

## Related canonical sources

- `ai-resources/CLAUDE.md` — repo-level rules
- `~/Claude Code/Axcion AI Repo/CLAUDE.md` — workspace-level rules
- `ai-resources/docs/ai-resource-creation.md` — placement rules + canonical pipelines
- `ai-resources/docs/audit-discipline.md` — `/risk-check` classes, Friday-cadence tiers
- `ai-resources/docs/permission-template.md` — canonical settings shapes

- `ai-resources/docs/agent-tier-table.md` — agent model tiering
- `ai-resources/docs/session-guardrails.md` — session-flag triggers
- `ai-resources/docs/session-rituals.md` — session opening/closing rituals
- `ai-resources/docs/operator-principles.md` — operator-side principles
