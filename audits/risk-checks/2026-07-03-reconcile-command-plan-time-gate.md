# Risk Check — 2026-07-03

## Change

PLAN-TIME gate for the approved /reconcile build (plan: /Users/patrik.lindeberg/.claude/plans/evaluate-the-idea-of-purring-bachman.md). Design under evaluation: a new reusable command+agent pair added to ai-resources — ai-resources/.claude/commands/reconcile.md (operator-invoked, delegates internally to /contract-check for mandate comparison, adds new resource-activation-audit and genericness-detector logic, forensic-only — reconstructs process from existing session-notes.md/decisions.md/git rather than requiring a new trace format) + ai-resources/.claude/agents/reconcile-reviewer.md (opus-tier context-isolated judgment subagent, follows the subagent contract: full notes to disk, ≤30-line summary back). Plus 4 new flat shared docs under ai-resources/docs/ (reconcile-failure-taxonomy.md, reconcile-verdict-definitions.md, reconcile-genericness-heuristics.md, reconcile-report-template.md), an edit to ai-resources/docs/agent-tier-table.md to register the new agent, and a new per-invocation dated-report convention at ai-resources/audits/reconcile/YYYY-MM-DD-<project-slug>.md (mirrors the existing /risk-check → audits/risk-checks/ pattern). First per-project pair (mandate-rubric.md + resource-activation-map.md) lands in projects/buy-side-service-plan/context/. Change class triggering this gate: "New commands or skills" + "New symlinks" (ai-resources/.claude/commands and .claude/agents are auto-symlinked into every project via the SessionStart sync hook, so this new command+agent becomes available in every project on next session start). /placement already confirmed canonical homes and flagged: no formal creation pipeline applies (command+agent pairs are authored directly, following /risk-check + risk-check-reviewer.md as the closest structural template — same shape: diagnostic command → opus-tier judgment subagent → verdict + dated report). Evaluate usage cost, permissions surface, blast radius (auto-symlinks into every project immediately), reversibility, hidden coupling (delegation into /contract-check; reliance on session-notes.md/decisions.md as forensic sources rather than a dedicated trace), and principle alignment (workspace CLAUDE.md AI Resource Creation rules, Subagent Contracts, Model Tier).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/reconcile.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/reconcile-reviewer.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/reconcile-failure-taxonomy.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/reconcile-verdict-definitions.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/reconcile-genericness-heuristics.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/reconcile-report-template.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/agent-tier-table.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/contract-check.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/risk-check-reviewer.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/risk-check.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/context/mandate-rubric.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/context/resource-activation-map.md — not yet present
- /Users/patrik.lindeberg/.claude/plans/evaluate-the-idea-of-purring-bachman.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A well-scoped, advisory, operator-invoked command+agent pair with no permission or always-loaded-token cost, but four Medium risks — a 20-project auto-symlink broadcast, a symlink-cleanup burden on revert, an unpinned nested-delegation boundary (reconcile-reviewer vs /contract-check both want to spawn subagents), and an OP-12 detection-ahead-of-closure tension — that each need a specific paired action before landing.

## Consumer Inventory

The two primary targets (`reconcile.md`, `reconcile-reviewer.md`) are `not yet present`, so they have no consumers yet; the inventory below covers the *contract* they introduce (the `/reconcile` command token, the `reconcile-reviewer` agent name) plus the files the change edits or depends on.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/docs/agent-tier-table.md | co-edits (register `reconcile-reviewer` row + opus tier) | yes |
| ai-resources/.claude/hooks/auto-sync-shared.sh | imports (auto-symlinks `reconcile.md` + `reconcile-reviewer.md` into every shared-manifest project on SessionStart) | no |
| 20 projects with `.claude/shared-manifest.json` (buy-side-service-plan, strategic-os, management-os, axcion-ai-system-redesign, repo-documentation, …) | imports (receive the symlinked command+agent on next SessionStart) | no |
| ai-resources/.claude/commands/contract-check.md | invoked-by (reconcile delegates into `/contract-check`; reverse dependency — reconcile breaks if contract-check's interface changes, not vice versa) | no |
| projects/buy-side-service-plan/logs/{session-notes.md, decisions.md} | data-source (forensic reconstruction reads these; both confirmed present) | no |

**Total: 5 distinct consumer rows, 1 must-change** (`agent-tier-table.md`, a lockstep co-edit inside the change itself). The `/reconcile` token and `reconcile-reviewer` name have **zero pre-existing consumers** (grep across repo + workspace root: every "reconcile" hit is either the English verb in prose or the distinct existing command `/reconcile-backlog`). The auto-sync hook is the mechanism that turns a single canonical add into a 20-project broadcast — that is the dominant blast-radius fact, and it was correctly anticipated by CHANGE_DESCRIPTION.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Command is operator-invoked with no auto-gating — pay-as-used, no per-session/per-tool hook cost. CHANGE_DESCRIPTION: "operator-invoked … no auto-gating"; plan Out-of-Scope (line 33): "No auto-gating or hook wiring — operator-invoked only." No SessionStart/Stop/PreToolUse/UserPromptSubmit registration.
- `reconcile-reviewer` is an opus subagent spawned only when `/reconcile` runs, on outputs that "feel off" (plan line 11) — infrequent, on-demand, not a frequently-spawned brief.
- No always-loaded file is touched: no workspace/project CLAUDE.md edit, no `@import`. The 4 support docs are read by the command at invocation time, not loaded every turn.
- `agent-tier-table.md` is explicitly not always-loaded ("Not needed for every turn," line 3) — the one-row edit adds no per-turn cost.
- Marginal per-session cost: the command+agent descriptions enter the available-command/agent registry of all 20 shared-manifest projects at session start. This is ~one description line each per project — well under the ~50-token Medium threshold. Noted, not elevated.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` `allow`/`ask`/`deny` edit is described. No new tool family, no external API, no cross-repo write, no MCP surface.
- The command's tool needs (Read, git, Task to spawn the subagent) sit inside already-established patterns: `contract-check.md` frontmatter (line 6) already declares `allowed-tools: Bash(git *), Read, Task`; `risk-check-reviewer.md` (lines 5–10) already uses Read/Write/Bash/Glob/Grep. The `reconcile-reviewer` subagent's write-notes-to-disk pattern matches the existing subagent contract.
- Report writes land in `audits/reconcile/` — a new sibling under the already-authorized `audits/` tree (`audits/risk-checks/` already exists and is written to). No scope escalation (project → user), no deny-rule removal.

### Dimension 3: Blast Radius
**Risk:** Medium

- Directly touches ~9 new files (command, agent, 4 docs, per-project mandate-rubric + resource-activation-map, first dated report) plus one edit (`agent-tier-table.md`).
- Consumer inventory (Step 1.5): **5 consumer rows, 1 must-change.** The only must-change is `agent-tier-table.md` — a lockstep co-edit the plan already owns; nothing *breaks* if omitted (a QS-6 registry inconsistency, not a runtime failure).
- **Dominant driver — shared-infra broadcast.** `auto-sync-shared.sh` (lines 82–96, 98–113) walks `ai-resources/.claude/{commands,agents}/*.md` and symlinks each into every project carrying a `shared-manifest.json`. `EXCLUDE_COMMANDS` (line 46: `new-project deploy-workflow run-sufficiency pipeline-review scope-project`) and `EXCLUDE_AGENT_GLOBS` (line 47: `pipeline-stage-* session-guide-generator pipeline-review-* scope-*`) do **not** cover `reconcile` or `reconcile-reviewer`, so both auto-symlink into all **20** shared-manifest projects (grep count of `shared-manifest.json` outside ai-resources = 20) on their next SessionStart.
- Why Medium, not High: the 20-project broadcast is **additive** — each project gains an available command; no existing project workflow is altered or broken, and no downstream file must change to keep working. The one must-change is in-scope and non-breaking. This is "shared infra touched, all consumers compatible," which sits at Medium rather than the >5-breaking-callers High band.
- No consumer surfaced that CHANGE_DESCRIPTION failed to anticipate — the description explicitly names the auto-symlink-into-every-project effect. Inventory confirms it rather than adding a surprise.

### Dimension 4: Reversibility
**Risk:** Medium

- Source-side revert is clean: `git revert` in ai-resources removes the new command, agent, 4 docs, and the `agent-tier-table.md` row in one step.
- **Extra cleanup step required downstream.** Once landed, the next SessionStart in each of the up-to-20 projects creates real symlinks to `reconcile.md`/`reconcile-reviewer.md`. `git revert` in ai-resources does **not** remove those symlinks — and `auto-sync-shared.sh`'s idempotency guard (`[ -e "$target" ] || [ -L "$target" ] && continue`, lines 88, 105) never cleans a symlink up, so a reverted-away target leaves a **dangling symlink** in every synced project that the hook will then "permanently skip." This is exactly the reversibility rubric's flagged case: "adds automation (symlink) that could fire between the change landing and a potential revert."
- Bounded and mechanical, hence Medium not High: cleanup is a known one-step sweep (`/fix-symlinks`, or manual dangling-symlink deletion across synced projects). Nothing propagates beyond git — no push, no external write, no Notion/API POST.
- The per-project `mandate-rubric.md`/`resource-activation-map.md` and any `audits/reconcile/*.md` reports are separate authored artifacts; a command revert intentionally leaves them (they are not stale log mutations).

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Nested-delegation boundary is unpinned (load-bearing).** `/reconcile` both spawns `reconcile-reviewer` (an opus subagent doing "the actual comparison/audit work," plan line 25) AND "delegates internally to /contract-check." But `/contract-check` itself spawns its own fresh-context subagent (`contract-check.md` line 6 `Task`; lines 114–172 "Spawn one general-purpose subagent"). If the `reconcile-reviewer` subagent is the one that calls `/contract-check`, a subagent generally cannot spawn a further Task subagent — so the orchestration must keep the `/contract-check` call in the MAIN command, not inside the subagent. This boundary is not fixed in CHANGE_DESCRIPTION and is a genuine build-time design decision, not a detail.
- **Forensic-source convention reliance.** Reconstruction reads `session-notes.md`/`decisions.md`/git and silently assumes their conventions (mandate blocks, append direction). Confirmed present for the first target (`buy-side-service-plan/logs/{session-notes.md, decisions.md}` both exist), but per-project shape is not guaranteed for later targets — one implicit dependency on an established repo convention. Mostly documented-at-site (the command names its sources).
- **Naming adjacency.** `/reconcile-backlog` already exists (`ai-resources/.claude/commands/reconcile-backlog.md`, opus, backlog open-vs-done reconciliation). A second `reconcile*` command with a different concern (workflow/mandate reconciliation) risks operator mental-model confusion. No dispatch collision (distinct filenames), so this is ergonomic, not a functional break.
- Why Medium, not High: the couplings are real but each is namable and addressable at build time, and the two contracts (forensic sources, `/contract-check` delegation) are stated in the change description itself rather than left implicit. The nested-delegation item is the one that must be explicitly pinned.
- Surfaced conflict (Design Judgment Principle — surface, don't silently resolve): CHANGE_DESCRIPTION specifies **flat** docs (`docs/reconcile-failure-taxonomy.md`, …) while the plan (line 26) specifies a **subdirectory** (`ai-resources/docs/reconcile/failure-taxonomy.md`, …). A placement detail to reconcile before authoring.

### Dimension 6: Principle Alignment
**Risk:** Medium

Principles-base read from `projects/strategic-os/ai-strategy/principles-base.md` (frozen-ID index, 41 active).

- **OP-12 (Closure before detection) — the live tension.** `/reconcile` is fundamentally a new *detection* engine: a genericness detector, a resource-activation audit, and a failure-mode classifier that emits verdicts + findings. OP-12: "new detection that does not close findings counts against a candidate … a detection capability ships behind a working closure channel, never ahead." Reconcile's own scope *excludes* closing (plan line 34: "diagnosis and recommendations only … do not become a rewrite agent"). It is defensible because the closure channels already exist (`/resolve`, `/resolve-incident`, `/resolve-repo-problem`, defect/improvement-log loops — plan line 7), so reconcile ships *behind* them, not ahead — that is OP-12-consistent. The tension: repo evidence shows those channels empirically under-fire (an in-repo audit records the self-repair drain as memory-only, backlog net +35/30d, `/reconcile-backlog` "never ran" — `projects/axcion-ai-system-redesign/window-outputs/W1.5-orchestration-autofire-health.md` §5). Adding another finding-generator whose fixes drain only on operator memory is a real, evidence-grounded OP-12 tension worth an explicit routing decision — not a clear violation.
- **OP-9 / DR-7 / AP-7 (Speculative abstraction) — aligned.** Built for a *present, confirmed* consumer: the operator's locked proposal plus the first end-to-end target (buy-side-service-plan) is authored in this same change. The per-project rubric pattern generalizes, but only one project's pair is authored now; others are "authored later, per-project, on demand" (plan line 36) — start-specific, generalize-on-second-consumer. The `audits/reconcile/` convention mirrors the existing `audits/risk-checks/` pattern. No "hooks for later."
- **OP-5 (Advisory vs enforcement) — aligned / actively served.** Operator-invoked, advises-and-stops, no auto-correct, no rewrite. No silent enforcement upgrade.
- **OP-2 / AP-4 (Automate execution, gate judgment) — aligned.** Judgment stays operator-gated (operator decides when to run and what to do with the verdict); no routine execution is re-gated.
- **OP-10 (System boundary) — aligned.** Operates only on Claude Code project artifacts (session-notes, decisions, git, project outputs). No governance of GPT/Perplexity/Notion/NotebookLM behavior.
- **DR-1 / DR-3 (Placement) — aligned, one open detail.** Canonical command+agent in `ai-resources/.claude/`, shared docs in `ai-resources/docs/`, project-specific rubric in `projects/buy-side-service-plan/context/` — correct tiers; `/placement` already confirmed homes. Open detail: the flat-vs-subdirectory docs discrepancy noted under Dimension 5.
- **DR-2 / AP-5 (Canonical pipeline / no improvised resources) — aligned.** Workspace CLAUDE.md "AI Resource Creation" routes *skills* through `/create-skill` etc.; there is no `/create-command` pipeline, and command+agent pairs (risk-check, contract-check) are authored directly. CHANGE_DESCRIPTION follows the accepted path (risk-check as structural template) with `/qc-pass` as the QC gate (plan Verification, line 43). QS-6 completeness is met (explicit opus tier, canonical home, tier-table registration).

Net: no clear, unacknowledged principle violation (so not High). One genuine Medium tension on OP-12 that a specific routing decision resolves.

## Mitigations

- **Blast radius (Medium):** Land the `agent-tier-table.md` registration (opus tier for `reconcile-reviewer`) in the SAME commit as `reconcile-reviewer.md` (QS-6 lockstep), and record in the wrap note that the command+agent will auto-symlink into all 20 shared-manifest projects on their next SessionStart — the broadcast is intended and needs no per-project action, but should be a known, logged fact, not a surprise.
- **Reversibility (Medium):** In the landing note, record the revert procedure explicitly — a later `git revert` in ai-resources must be paired with `/fix-symlinks` (or a manual dangling-symlink sweep) across any project that already synced, because `auto-sync-shared.sh`'s idempotency guard never removes a symlink whose canonical target was deleted.
- **Hidden coupling (Medium):** Before authoring, pin the orchestration boundary in `reconcile.md` — the MAIN command (not the `reconcile-reviewer` subagent) must be the caller of `/contract-check`, since a subagent cannot spawn contract-check's own Task subagent. Confirm at build time via the plan's own Verification item (line 42, "genuine internal call, not a re-derived comparison"). Also resolve the flat-vs-subdirectory docs placement and confirm the `/reconcile` vs `/reconcile-backlog` naming is acceptable (or rename) before landing.
- **Principle alignment / OP-12 (Medium):** Before shipping, name in `reconcile-report-template.md` which existing closure channel each of the three fix levels routes into (`/resolve` / `/resolve-repo-problem` / improvement-log loop), so the new detection provably ships behind a working closure channel. Given the W1.5 evidence that drain is memory-only, prefer routing findings into a channel with a firing trigger over a chat-only recommendation.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION, the plan, referenced files, and the principles-base). Auto-symlink behavior verified by reading `auto-sync-shared.sh` and counting `shared-manifest.json` occurrences (20). Naming adjacency and zero-existing-consumer findings verified by grep across repo + workspace root. No training-data fallback was used on any read.
