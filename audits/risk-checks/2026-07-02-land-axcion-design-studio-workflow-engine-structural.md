# Risk Check — 2026-07-02

## Change

Land the Axcíon Design Studio workflow engine as a structural set: one new project-local skill (visual-design-spec, orchestrator for the spec→explore→3-critiques→QC→Figma-brief chain, built from pipeline/create-skill-brief.md, installed to projects/axcion-design-studio/.claude/skills/visual-design-spec/) plus a four-agent roster already on disk (layout-architect [creator, opus], brand-guardian [critic, sonnet], visual-red-team [critic, opus], implementation-bridge [critic, sonnet]). 6 new Claude Code components total. This is the Phase-2 entry gate per pipeline/project-plan.md §8 (W2.1) and audit-discipline.md structural change class. All components are project-local under projects/axcion-design-studio/.claude/; 0 modifications to shared ai-resources. Evaluate the roster as a set before the skill lands.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/pipeline/create-skill-brief.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/pipeline/project-plan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.claude/skills/visual-design-spec/SKILL.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.claude/agents/layout-architect.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.claude/agents/brand-guardian.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.claude/agents/visual-red-team.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.claude/agents/implementation-bridge.md — exists

## Verdict

GO

**Summary:** A cleanly project-local, on-demand orchestration set built via the canonical `/create-skill` pipeline against a fully-pinned contract, with zero external must-change callers, no permission or always-loaded-cost delta, and clean git reversibility.

## Consumer Inventory

Search terms: skill/agent basenames (`visual-design-spec`, `layout-architect`, `brand-guardian`, `visual-red-team`, `implementation-bridge`), plus contract markers (`positioning-hazards`, `figma-build-brief`, `design-studio-mandate`). Grep run across `{AI_RESOURCES}` and `{AI_RESOURCES}/..`. Only ONE referencing file lives outside the design-studio project (`logs/session-notes.md`, workspace root, documents-only). All functional coupling is internal to the co-designed set.

| Consumer path | Reference type | Must change? |
|---|---|---|
| .../.claude/agents/layout-architect.md | invokes (skill dispatches by name; agent documents "Dispatched by the visual-design-spec skill (Step 1)") | no — built to the same brief; contract aligned |
| .../.claude/agents/brand-guardian.md | invokes (dispatched Step 2; writes `work/{surface}/critiques/brand-guardian.md`) | no |
| .../.claude/agents/visual-red-team.md | invokes (dispatched Step 2; imports `20_criteria/positioning-hazards.md`) | no |
| .../.claude/agents/implementation-bridge.md | invokes (dispatched Step 2; reads website project-plan as reference) | no |
| .../20_criteria/positioning-hazards.md | imports (read by visual-red-team at dispatch) | no — present on disk, unchanged |
| .../CLAUDE.md | documents (describes the chain + roster) | no |
| .../00_mandate/design-studio-mandate.md | documents | no |
| .../10_brand-system/README.md | documents | no |
| .../pipeline/{architecture,technical-spec,implementation-spec,implementation-log,test-results}.md | documents (the build's own spec/log set) | no |
| .../logs/session-notes.md, session-plan-2026-07-02-S1.md | documents | no |
| logs/session-notes.md (workspace root) | documents | no |

Total: 11 distinct consumer paths (agents counted individually), 0 must-change. The 4 agents are members of the set under evaluation, dispatched by the not-yet-present skill against a contract pinned in create-skill-brief.md; they require no edit to land the skill. Every other consumer is documentation or log.

## Dimensions

### Dimension 1: Usage Cost

**Risk:** Low

- On-demand, not always-loaded — the skill is invoked with a surface identifier (create-skill-brief.md L19: "Invoke with a surface identifier"); it is not an @import or turn-level load. Evidence: pay-as-used.
- Narrow trigger — the SKILL.md description scopes firing to "running a design pass on a web surface (Phase-1 surface = homepage)" and explicitly excludes final Figma/code (create-skill-brief.md L20). Not a broad-trigger description.
- No SessionStart/PreToolUse hook added — project `.claude/settings.json` SessionStart hooks (auto-sync-shared, check-permission-sanity) are unchanged by this change; the skill adds no hook.
- Subagent briefs are spawned per design pass, not per turn: layout-architect.md ~7.8 KB, the three critics ~5.7–6.4 KB each (measured `ls -la`). This fan-out (Step 2 spawns 3 concurrently) is on-demand within a design run, not a hot-path recurring spawn. Below the "frequently-spawned oversized brief" bar.

### Dimension 2: Permissions Surface

**Risk:** Low

- No new allow/ask — `Skill` and `Agent` are already in the project `settings.json` allow-list (verified inline); the skill install invokes no new tool pattern.
- Skill and all 4 agents declare `tools: Read, Write` only (agent frontmatter, L5 each) — no Bash, no external capability, no scope escalation.
- No deny narrowed — the brand-book protection deny rules (`Edit(../axcion-brand-book/**)`, `Write(../axcion-brand-book/**)`) remain intact; the change respects them (creator/critics read the brand book, never write it).
- Install adds a skill directory only; no settings edit is part of the change (change description: "0 modifications to shared ai-resources").

### Dimension 3: Blast Radius

**Risk:** Low

- Consumer inventory (above): 11 consumer paths, 0 must-change. The only referencing file outside the project is a workspace-root log (`logs/session-notes.md`), documents-only.
- No contract change to an existing consumer — the skill is net-new; the 4 agents are net-new (landed one commit prior) with no pre-existing external callers (project-plan.md §5: "All four Studio agents are project-local and net-new").
- No shared infra touched — 0 modifications to `ai-resources`; grep confirms no `ai-resources` file references any of the five component names.
- The skill↔agent dispatch is an internal contract of the co-designed set, aligned by construction (both built from create-skill-brief.md). Falls in the Low band: isolated, 0 external callers, no contract change.

### Dimension 4: Reversibility

**Risk:** Low

- Clean git revert — the skill lands as new files under `.claude/skills/visual-design-spec/` (SKILL.md, optionally `references/vds-template.md` + `references/figma-build-brief-schema.md` per create-skill-brief.md L37–47). Reverting the adding commit deletes them; nothing pre-existing is mutated.
- No log/data mutation — the skill writes only into `work/{surface}/` at runtime (not at install); install itself appends to no append-only log.
- No state beyond the repo — no external push, no third-party renderer, no settings requiring manual cleanup.
- No automation could fire before revert — the skill runs only on explicit operator invocation; it is not hook-triggered.

### Dimension 5: Hidden Coupling

**Risk:** Low

- Contracts named at the change site — create-skill-brief.md pins every dispatch name and artifact path (L56–96): the four agent names, the `work/{surface}/...` path convention, the critique filenames, and the QC-report/Figma-brief paths. The skill is built to honor them.
- Dispatch-name coupling is satisfied — the skill dispatches by name; agent frontmatter `name:` fields (`layout-architect`, `brand-guardian`, `visual-red-team`, `implementation-bridge`) match the brief's dispatch strings exactly (verified against each agent file L2).
- One read-only cross-repo dependency, documented — implementation-bridge reads `projects/axcion-website/pipeline/project-plan.md` and the agents read brand-book chapters by path (agent files, Step 1). These are pre-existing read-only inputs of the already-landed agents, named at the change site; the skill introduces no new undocumented contract.
- `20_criteria/positioning-hazards.md` (visual-red-team's operating brief) is present on disk (verified) — no dangling dependency.
- No silent auto-firing, no functional overlap with an existing mechanism (no prior Studio skill/agent of these names exists — project-plan.md §5).

### Dimension 6: Principle Alignment

**Risk:** Low

- Not speculative abstraction (OP-9/AP-7/DR-7) — the skill has a live consumer: it is the orchestrator that makes the four already-landed agents runnable as a chain, and its immediate downstream is the Phase-3 homepage proof (project-plan.md W3.1). Non-zero consumer; closes the gap between "agents on disk" and "a runnable engine."
- Correct placement (DR-1/DR-3) — installed project-local under `.claude/skills/`, deliberately NOT graduated to `ai-resources/skills/` (create-skill-brief.md L33; context-pack §8 deferral: prove-before-graduate). An orchestrating skill is the right tier for a multi-step chain; agents for the roles. Built via the canonical `/create-skill` pipeline, honoring the workspace AI-Resource-Creation rule.
- System boundary respected (OP-10) — the skill stops at the Figma build brief and does not cross into Figma/code/strategy/copy (CLAUDE.md Boundaries; create-skill-brief.md L159 "Terminal Studio output").
- Automate execution, gate judgment (OP-2) + advisory-vs-enforcement (OP-5) — the skill automates chain execution and enforces the non-negotiable sequence as hard stops (create-skill-brief.md L100–108), while the operator remains the approver (L158); enforcement is applied to a process gate, judgment stays with the operator. Correct posture.
- Loud not silent (OP-11/OP-3) — Step 3 mechanical consolidation surfaces critic conflicts as explicit operator decisions rather than silently resolving them (create-skill-brief.md L87). Creation/critique separation is structural via context isolation (L76), upholding no-self-approval.
- Model Tier rule honored — skill declares `model: opus` in frontmatter, agents declare opus/sonnet per role, and no `model` default exists in `settings.json` (verified inline).

## Evidence-Grounding Note

All six risk levels are grounded in direct evidence: agent frontmatter and body reads (L2/L5 and Step sections of each of the four agent files), create-skill-brief.md (cited by line for chain paths, enforcement, placement, and terminal boundary), project-plan.md (§5 net-new status, §8 W2.1, W3.1 consumer), the inline `settings.json` read (permissions + no model default), directory listings (skill dir absent; four agents present with sizes; positioning-hazards.md present), and the cross-repo grep (only `logs/session-notes.md` references the set outside the project; 0 must-change). No training-data fallback was used; no dimension is INCOMPLETE.
