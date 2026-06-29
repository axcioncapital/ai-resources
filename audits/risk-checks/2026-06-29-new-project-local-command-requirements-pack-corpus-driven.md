# Risk Check — 2026-06-29

## Change

New project-local command /requirements-pack added to projects/project-planning/.claude/commands/requirements-pack.md (model: opus, argument-hint {project}), plus a new template playbook projects/project-planning/requirements-playbooks/_template.md, plus a registration edit to projects/project-planning/CLAUDE.md (one Commands-table row + one "when to use which" paragraph). The command reads the projects/strategic-os/ corpus (read-only; authority-ranked read map over state/live/*, inputs/*, output/2026-06-*.md; honors a *deal-*/*client-*/*confidential* sensitivity guard; never writes into strategic-os) and emits a pipeline-native context-pack.md + requirements-ledger.md sidecar into projects/project-planning/Project Plans/{project}/, versioned -v{n} with a bare canonical copy. It is a corpus-driven sibling to the interview-driven /context-builder, feeding /plan-draft. Built per approved, SO-vetted plan ~/.claude/plans/toasty-twirling-map.md (which already passed a plan-time /risk-check expectation and two /consult passes; SO B1/B2 blocking findings were overturned on filesystem evidence). v1 ships command + one template only; NO changes to /context-builder, /plan-draft, /new-project, or /create-requirements-doc.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/.claude/commands/requirements-pack.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/requirements-playbooks/_template.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/ — exists (corpus, read-only)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/pipeline/ref-context-pack.md — exists (output-shape reference)

## Verdict

GO

**Summary:** A pay-as-used, project-local analytical command that reads an existing corpus read-only and writes pipeline-native output into an established directory — isolated, cleanly revertible, and aligned with the operating principles (OP-9/DR-7 second-consumer test satisfied by the existing `/context-builder` sibling pattern; OP-12 closure-not-detection respected).

## Consumer Inventory

Search terms: `requirements-pack`, `/requirements-pack`, `requirements-playbooks`, `requirements-ledger`, `_template.md` (playbook). Grepped across the canonical repo and the workspace root (`grep -rniI --exclude-dir=.git`).

The only repo references to the three new tokens (`requirements-pack`, `requirements-playbooks`, `requirements-ledger`) are inside the change's own files plus the CLAUDE.md registration. No external file invokes, parses, or imports the new command or its output filenames.

| Consumer path | Reference type | Must change? |
|---|---|---|
| projects/project-planning/CLAUDE.md | documents | yes (already edited — part of the change) |
| projects/project-planning/.claude/commands/plan-draft.md | invokes (consumes the emitted `context-pack.md` downstream) | no |
| ai-resources/.claude/commands/new-project.md | invokes (discovers bare `context-pack.md` at First Run, copies it) | no |

Total: 3 consumers, 1 must-change (the CLAUDE.md registration, which is itself authored as part of this change). The two downstream consumers (`/plan-draft`, `/new-project`) depend only on the *bare `context-pack.md` contract* — a filename + loose prose-marker shape they already accept from `/context-builder`. They do not reference `/requirements-pack` by name and require no modification. The new command emits the same handoff artifact a sibling already produces, so the contract is pre-existing, not introduced.

Note: `requirements-ledger.md` is a brand-new sidecar with zero current consumers — it is read by a human reviewer, not by any downstream command (verified: no grep hits outside the change's own files). This is an isolated additive artifact, not a contract others must honor.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file gains material weight. The only edit to an always-loaded file is `projects/project-planning/CLAUDE.md` — one Commands-table row (line 23) + one "when to use which" paragraph (line 15). That CLAUDE.md loads only in project-planning sessions, not workspace-wide, and the addition is ~120 words / a single table row — a Commands table the file already maintains (lines 19–29).
- No hook registered. The change adds no SessionStart/Stop/PreToolUse/UserPromptSubmit hook (no hook files referenced; grep of the change surfaced none).
- No `@import` into an always-loaded file. The command is a slash command — pay-as-used, loaded only when `/requirements-pack` is invoked.
- The command itself (`model: opus`, ~147 lines) costs tokens only on invocation, and it is an on-demand Stage-1 intake command, not a frequently-spawned subagent.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings file is referenced or edited by the change. No `allow`/`ask`/`deny` entry is added, removed, or narrowed (REFERENCED_FILE_PATHS contains no settings.json; CHANGE_DESCRIPTION names none).
- The command's tool surface is Read (corpus) + Write (into `projects/project-planning/Project Plans/{project}/`) + `git add` via the real path — all already-established patterns in this workspace; sibling `/context-builder` writes context packs into the same output tree (context-builder.md line 187–199).
- No cross-repo write: the command is explicit that it "never writes into `projects/strategic-os/`" (requirements-pack.md line 22) — it only reads that corpus. Read of `projects/strategic-os/` is governed by strategic-os's own Cross-Project Read Protocol (CLAUDE.md lines 27–33), which the command honors via the `*deal-*`/`*client-*`/`*confidential*` sensitivity guard (requirements-pack.md line 20).
- No external API or MCP capability introduced.

### Dimension 3: Blast Radius
**Risk:** Low

- Grounded in the Step 1.5 inventory: 3 consumers found, 1 must-change — and that must-change (the project-planning CLAUDE.md registration) is authored *as part of* this change, not a separate file forced to adapt.
- Direct files touched: 3 (the new command, the new `_template.md`, the CLAUDE.md edit) — all inside `projects/project-planning/`, a single project tier.
- No contract change. The `parses` dependency is the downstream `context-pack.md` shape, which `/plan-draft` validates with a loose prose-marker sniff ("look for structured sections like Project Purpose, Scope, Constraints, or similar context-pack markers" — plan-draft.md line 11). A well-formed 11-element pack passes that sniff; the command builds against `ref-context-pack.md` (the same 11-element reference the pipeline already uses). The handoff contract is pre-existing and unchanged.
- No unanticipated consumer surfaced by the grep — the inventory matches CHANGE_DESCRIPTION's claim of "NO changes to /context-builder, /plan-draft, /new-project, or /create-requirements-doc." Confirmed: zero external references to the new tokens.
- Shared infra untouched: no logs, hooks, scripts, or always-loaded workspace CLAUDE.md modified.

### Dimension 4: Reversibility
**Risk:** Low

- The command + template are new sibling files; `git revert` (or `git rm`) removes them cleanly. The CLAUDE.md edit is a localized addition (one row + one paragraph) that reverts cleanly within the same working tree.
- No data/log mutation. The change does not append to innovation-registry / improvement-log / session-notes / archives — revert leaves no stale log entries.
- No settings.json change requiring manual cleanup beyond git.
- No state pushed beyond the local repo by the change itself (no git push, no Notion/external write in the change). The command, when *run*, writes versioned output under `Project Plans/{project}/`, but that is per-invocation output the operator controls — not part of landing the change.
- No automation (hook/cron/symlink) added that could fire between landing and a potential revert.

### Dimension 5: Hidden Coupling
**Risk:** Low

- One implicit dependency on an established repo convention, and it is documented at the change site: the bare `context-pack.md` canonical-copy handoff that `/plan-draft` and `/new-project` discover. The command names this explicitly (requirements-pack.md lines 45, 51) and the project CLAUDE.md "Output Convention" already encodes the never-overwrite + bare-canonical pattern — so the contract is honored, not silently assumed.
- The output-shape ground truth is pinned against the correct reference and explicitly disambiguated from the wrong one: build against `pipeline/ref-context-pack.md` (the 11-element interview-pack reference), NOT `ai-resources/docs/context-pack-schema.md` (the Context Engine's 6-section schema) — requirements-pack.md line 51. This pre-empts the most likely silent-coupling failure (building to the wrong schema).
- The strategic-os read map is mechanical-by-path and the corpus exists on disk (verified: `state/live/` contains strategy.md, priorities.md, decisions-log.md, open-decisions.md, assumptions.md, risks.md, workstreams.md). The sensitivity guard mirrors strategic-os's own Cross-Project Read Protocol — an explicit, documented dependency, not a silent one.
- No auto-firing in unexpected contexts (no hook; on-demand command only). No functional overlap that creates a two-systems-handling-one-concern hazard: `/context-builder` (interview-driven) and `/requirements-pack` (corpus-driven) are disjoint intakes by source, and the CLAUDE.md "Choosing the Stage-1 intake" paragraph (line 15) documents the boundary so the operator picks one deliberately.

### Dimension 6: Principle Alignment
**Risk:** Low

- principles-base read OK at `projects/strategic-os/ai-strategy/principles-base.md` (41 active principles).
- **OP-9 / DR-7 / AP-7 (speculative abstraction).** The change does NOT generalize for an absent consumer. It is a *specific* second intake sibling to the existing `/context-builder`, both feeding the existing `/plan-draft` — the "second confirmed consumer" exists (the planning pipeline is live, with `Project Plans/` already populated). Crucially, v1 is deliberately *trimmed*: the command's own Notes (requirements-pack.md line 144) defer the cross-project source-map, the challenge-pass subagent, and per-project playbooks "until those projects exist as repos and a second corpus location exists" — this is textbook DR-7 compliance (build specific now, generalize only when the second consumer arrives). No "hooks for Phase 2."
- **OP-12 (closure before detection).** The command's adversarial Stage 3 ("Challenge") surfaces tensions and open questions but feeds them straight into the `context-pack.md` / `requirements-ledger.md` that `/plan-draft` consumes — detection ships *behind* a working closure channel (the planning pipeline), not ahead of it. Not a free-floating finding-generator.
- **OP-10 (system boundary).** The command reads firm strategy documents on disk inside Claude Code; it does not govern or coordinate GPT/Perplexity/NotebookLM/Notion behavior. Boundary respected.
- **OP-5 (advisory vs enforcement).** The command "states requirements; it does not choose tools or vendors" (line 10) and surfaces tensions without arbitrating (line 95) — advisory posture, no enforcement upgrade.
- **DR-1 / DR-3 (placement).** Correctly placed: a project-local command in `projects/project-planning/.claude/commands/` for a tool tightly coupled to that project's pipeline and the strategic-os corpus — not a candidate for the canonical `ai-resources/` tier (it would not serve more than one project as-is). The companion `requirements-playbooks/` and output under `Project Plans/{project}/` sit in the same project tier.
- **Model Tier rule.** Declares `model: opus` in frontmatter (line 2) per the workspace prohibition on settings-level model defaults — and the command notes the deliberate compliance choice (line 146). Aligned.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION and referenced files, principle IDs from `projects/strategic-os/ai-strategy/principles-base.md`). The consumer grep, corpus-directory existence, and `/plan-draft` validation marker were all verified on disk. No training-data fallback was used on any fetch/read.
