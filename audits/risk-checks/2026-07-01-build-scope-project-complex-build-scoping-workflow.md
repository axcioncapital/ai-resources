# Risk Check — 2026-07-01

## Change

Build the /scope-project complex-build scoping workflow: new command (.claude/commands/scope-project.md, opus orchestrator), 3 new agents (scope-synthesis-agent sonnet, scope-architecture-agent opus, scope-qc-evaluator opus), new skill (skills/project-scoping/SKILL.md via /create-skill), new reference doc (docs/control-pack-schema.md), and a pointer-note edit to projects/project-planning/CLAUDE.md. Canonical placement in ai-resources/. Approved build plan: ~/.claude/plans/i-want-to-develop-cached-blum.md. No existing consumers; edits project-planning CLAUDE.md; no automation/hooks.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/scope-project.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/scope-synthesis-agent.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/scope-architecture-agent.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/scope-qc-evaluator.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/project-scoping/SKILL.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/control-pack-schema.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/CLAUDE.md — exists
- /Users/patrik.lindeberg/.claude/plans/i-want-to-develop-cached-blum.md — exists (approved build plan)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A well-scoped, pay-as-used, all-new workflow with near-zero blast radius, but it carries one clear speculative-abstraction principle tension (canonical placement with zero current consumers) that the plan mitigates only by making the override loud and recorded — so the change is safe to build provided the recorded-rationale and tier-table steps land before commit.

## Consumer Inventory

Search terms (basenames + component tokens + contract markers): `scope-project`, `/scope-project`, `project-scoping`, `scope-synthesis-agent`, `scope-architecture-agent`, `scope-qc-evaluator`, `control-pack-schema`, `control-pack`, `control-note`, plus the handoff contract markers `context-pack.md` and `ref-context-pack.md`. Searched `ai-resources/` and the workspace root one level up (`.claude/commands`, `.claude/agents`, `.claude/hooks`, `skills/`, `workflows/`, `docs/`, `projects/`, and always-loaded CLAUDE.md files).

Every hit for a *new-component name* (`scope-project`, `project-scoping`, the three agents, `control-pack-schema`) resolved to the planning trail only — `logs/session-plan-2026-07-01-S2.md`, `logs/session-notes.md`, `logs/decisions.md`, `logs/scratchpads/2026-07-01-16-11-scratchpad.md`. None are runtime consumers. The new components have **no live consumers yet** (expected — all six artifacts are `not yet present`). The inventory below therefore covers (a) the one existing file the change edits, (b) the downstream *contract* the new workflow plugs into, and (c) the registry a new agent/skill must appear in.

| Consumer path | Reference type | Must change? |
|---|---|---|
| projects/project-planning/CLAUDE.md | documents | yes |
| ai-resources/docs/agent-tier-table.md | documents | yes |
| projects/project-planning/.claude/commands/plan-draft.md (reads the emitted `context-pack.md` brief) | parses | no |
| projects/project-planning/pipeline/ref-context-pack.md (11-element shape the brief must conform to) | co-edits | no |
| projects/project-planning/.claude/agents/context-evaluator.md (contract copied by scope-qc-evaluator) | documents | no |
| ai-resources/docs/control-pack-schema.md ← project-scoping SKILL + 3 agents (intra-change) | imports | no |

Total: 6 consumers, 2 must-change. Both must-change consumers are *documentation/registry* edits (a pointer note and a tier-table row), not behavioural rewires. The critical downstream contract (`/plan-draft` reads `context-pack.md`) is **consumed, not modified** — the plan's whole two-lane design is built to leave `/plan-draft` untouched (plan Decision 3, plan § Integration line 132). The five wired adjunct commands (`/grill-me`, `/tech-consult`, `/consult`, `/implementation-triage`, `/blindspot-scan`) were all confirmed present and are *pointed at*, not edited — they are not consumers of this change (the dependency runs the other way, and is covered under Hidden Coupling).

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No content is added to any always-loaded file. The one edit to an always-loaded CLAUDE.md is a *pointer note* in `projects/project-planning/CLAUDE.md` § How It Works — plan line 133: "keep it to a pointer, no methodology." That file loads only in project-planning sessions, not globally, and the addition is ~2 sentences (a "Two intake lanes" note). Estimated <60 tokens, project-scoped. (project-planning CLAUDE.md is 106 lines; the new note sits in § How It Works.)
- No hook, SessionStart/Stop/PreToolUse/UserPromptSubmit registration, or `@import` chain — plan § Out of scope line 166: "No automation/hooks. Operator-invoked command only." Grep for the new tokens in `ai-resources/.claude/settings*.json` returned zero hits.
- The command, 3 agents, skill, and reference doc are all **pay-as-used**: the command loads only when `/scope-project` is invoked; the agents spawn only on demand within a run; the skill is read by the command at invocation, not auto-loaded; the reference doc is read by the skill/agents at runtime. None pattern-match broadly into unrelated sessions.
- The skill's frontmatter description is the one broad-trigger risk to watch, but the change is a scoping *command* front door, not an ambient skill — no evidence of a broad auto-load trigger in the plan.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings file is in scope. Grep of `ai-resources/.claude/settings*.json` for the change's tokens returned zero hits; the change list (plan § What to build, table lines 60–67; plan § Integration) contains no `settings.json`/`settings.local.json` edit, no `allow`/`ask`/`deny` change, and no scope move between settings layers.
- No new tool-invocation pattern outside established repo norms: the agents follow the existing Subagent Contract (notes-to-disk + ≤30-line summary — plan lines 64–66, 146), the same Read/Write pattern `context-evaluator` and `new-project` stage agents already use.
- No shell/external/cross-repo/MCP capability introduced. Outputs land in `projects/project-planning/output/{project-name}/` (plan line 107) — an already-authorized write location for the planning pipeline.

### Dimension 3: Blast Radius
**Risk:** Low

Grounded in the Step 1.5 inventory: **6 consumers, 2 must-change**, both documentation/registry edits (not behavioural rewires).

- Files touched directly: 8 total — 6 new (command, 3 agents, skill, reference doc) + 1 pointer edit to `projects/project-planning/CLAUDE.md` + 1 registry row in `ai-resources/docs/agent-tier-table.md`. The plan's own change list (lines 60–67, 133–134) matches; no consumer surfaced beyond what the plan anticipated *except* the tier-table registration, which the plan does not explicitly list — see below.
- The primary downstream contract (`/plan-draft` parses `context-pack.md`) is **consumed, not modified**. Verified: `plan-draft` discovers the bare `context-pack.md` (requirements-pack.md line 45 confirms "the handoff `/plan-draft` and `/new-project` discover"), and the new workflow emits a brief in that exact shape (plan Decision 3, lines 30, 111). The contract is honoured, not broken — backwards-compatible by construction.
- No shared infrastructure (logs, hooks, scripts, workspace CLAUDE.md) is touched in a way that affects multiple workflows. The only CLAUDE.md edit is project-scoped and additive.
- **Inventory gap surfaced:** the plan's change list does not name `ai-resources/docs/agent-tier-table.md`, but workspace CLAUDE.md § Model Tier and repo QS-6 require every new `ai-resources/` agent to declare a tier and appear in the tier table. Three new agents ⇒ a tier-table row each. This is a small, mechanical must-change consumer the plan under-specifies — flagged as a mitigation, not a blocker.

### Dimension 4: Reversibility
**Risk:** Low

- The six new files are `git revert`-clean: deleting them removes the command, agents, skill, and reference doc with no residue (no siblings generated at build time, no data files mutated).
- The two edits are single-file, in-place, additive text (a pointer paragraph in project-planning CLAUDE.md; three rows in the tier table) — `git revert` restores prior state fully. The `decisions.md` entry the plan requires (line 134) is an append-only log line; a revert would leave it, but that is a *record of a decision*, harmless and arguably desirable to retain.
- No state propagates beyond git: no push (batched to wrap per workspace rules), no external write, no Notion write, no automation that could fire between landing and revert (plan line 166: no hooks). Nothing creates operator muscle-memory beyond a new optional command the operator chooses to invoke.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **New contract, documented at the change site (acceptable):** the change introduces the *control pack* artifact and its `context-pack.md`-shaped planning brief. The contract is explicitly defined in the new `docs/control-pack-schema.md` and the `project-scoping` SKILL, and the brief conforms to the existing `ref-context-pack.md` 11-element shape (plan lines 67, 73, 111). This is a documented new contract — Medium-tier, not High.
- **Implicit dependency on an existing convention (the real coupling):** the zero-touch handoff depends on `/plan-draft`'s discovery of a *bare* `context-pack.md` at a specific path and its "loose prose-marker sniff" validation. Evidence: `requirements-pack.md` line 51 states "`/plan-draft`'s validation is a loose prose-marker sniff, so a well-formed 11-element pack passes." The new workflow's brief must land at `output/{project-name}/context-pack.md` with the exact heading shape (`## Context Pack: {project} — Axcíon`, then `### {element}` — requirements-pack.md line 104). If the emitted brief drifts from that filename/heading convention, the handoff silently fails to be discovered — a coupling not visible from the `/scope-project` change site alone.
- **Functional-overlap check — clean:** the workflow deliberately does *not* re-route through `/context-builder` (plan Decision 2, line 50) and does *not* edit `/plan-draft`; the two-lane design keeps the simple and complex front doors separate rather than having two mechanisms fight over the same concern. This avoids the classic overlap anti-pattern.
- No silent auto-firing: the command is operator-invoked, all adjuncts are optional and gate-placed (plan § Adjunct table lines 120–126), and the scale-to-project principle governs which fire. No hook ordering or cross-session side effects.

### Dimension 6: Principle Alignment
**Risk:** Medium

Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md` (frozen-ID index, 41 active).

- **DR-7 / OP-9 / AP-7 — Speculative abstraction (the load-bearing tension).** The change places a brand-new, six-artifact workflow **canonically in `ai-resources/` with zero current consumers** — the inventory found no live consumer, and the plan itself states "No existing consumers." DR-7 forbids generalising before a *second confirmed consumer* exists; canonical-from-day-one is precisely the "generalize early" move. This is a genuine tension. **However**, the plan does not do this silently: Decision 5 (plan lines 32, 134) explicitly names it "the largest architecture decision in this plan, deliberately overriding the repo's usual 'wait for a second consumer' rule," and *mandates* recording the four-point rationale in `decisions.md` at build time (reusable standard method; serves future complex builds across Axcíon; extends the project-planning pipeline; canonical-from-day-one therefore defensible). Under OP-11 (revising/overriding a guardrail is legitimate when *loud and recorded, never drift*), a deliberate, operator-owned, recorded override is the sanctioned path — which converts a would-be High violation into a Medium tension. The rating stays Medium *conditional on the recorded rationale actually landing*; if the `decisions.md` entry is skipped, this reverts to an unrecorded DR-7 override (High).
- **OP-12 — Closure before detection.** The workflow adds *detection-flavoured* capability (a five-way readiness verdict incl. `Park` / `Do Not Build`, a QC evaluator, a decision ledger). OP-12 counts new detection that does not close findings *against* a change. Here the detection **ships behind a working closure channel**: verdicts route to persisted outputs, `Ready`/`Ready with Revisions`/`Reduce Scope` emit the planning brief into the live `/plan-draft` pipeline, and `Park`/`Do Not Build` persist a documented stop (plan lines 97, 103). The findings close into planning or a recorded stop — OP-12 is *served*, not violated. Low on this axis.
- **OP-5 — Advisory vs enforcement.** The workflow advises and stops (verdicts, gates, recommendations); it auto-corrects nothing and auto-acts on nothing. `/implementation-triage`'s ROI call is folded in as *one input*, explicitly *not* an override of the evaluator (plan line 99). Aligned.
- **OP-10 — System boundary.** The workflow governs Claude Code artifacts only; it *reads* GPT/Notion material as raw input but does not coordinate cross-tool behaviour. No boundary expansion. Aligned.
- **DR-1 / DR-3 — Placement.** Component homes are canonical and correct (command → `.claude/commands/`, agents → `.claude/agents/`, skill → `skills/`, reference → `docs/`; matches `repo-architecture.md § Canonical homes`, confirmed present). The only placement *judgment* is the canonical-vs-project-local call, which is the DR-7 tension above, handled via recorded override.
- **DR-2 — Canonical pipeline.** The skill is built via `/create-skill` (plan line 62, 145) — no improvised SKILL.md. Aligned.

## Mitigations

- **Dimension 5 (Hidden Coupling — Medium):** Before commit, run the plan's own end-to-end handoff test (plan § Verification lines 132, 156) — point `/plan-draft` at the emitted `context-pack.md` and confirm zero-touch discovery. Make the `project-scoping` SKILL / `control-pack-schema.md` state the exact handoff contract verbatim: bare filename `context-pack.md` at `output/{project-name}/`, heading shape `## Context Pack: {project} — Axcíon` then `### {element}` (per `requirements-pack.md` lines 104, 51). This pins the implicit filename/heading convention at the change site so a future edit cannot silently break discovery.
- **Dimension 6 (Principle Alignment — Medium, DR-7 override):** The `decisions.md` four-point rationale entry (plan Decision 5, line 134) is **not optional** — it is the mechanism that keeps the canonical-placement override loud and recorded (OP-11) rather than silent drift. Land it in the same commit as the artifacts, before or with wrap. If the rationale is skipped, the placement decision reverts to an unrecorded DR-7 violation and the verdict should be re-taken.
- **Dimension 3 (Blast Radius — inventory gap):** Register all three new agents in `ai-resources/docs/agent-tier-table.md` (scope-synthesis-agent → sonnet; scope-architecture-agent → opus; scope-qc-evaluator → opus) per workspace CLAUDE.md § Model Tier and QS-6. The plan's change list omits this must-change consumer; add the rows in the build.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: the approved plan (`~/.claude/plans/i-want-to-develop-cached-blum.md`, cited by line), `projects/project-planning/CLAUDE.md`, `projects/project-planning/.claude/commands/requirements-pack.md` (the `context-pack.md` handoff contract), `principles-base.md` (principle IDs), and grep counts across `ai-resources/` + workspace root (new-component names resolve to the planning trail only; adjunct commands and dependency files confirmed present on disk). No training-data fallback was used on any read.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

Full advisory on disk: `projects/axcion-ai-system-owner/output/consultations/consult-2026-07-01-scope-project-riskcheck-2nd-opinion.md`

**Concurrence:** Concur with PROCEED-WITH-CAUTION. Hidden coupling / Principle alignment are the right two Medium dimensions. Canonical-from-day-one with zero consumers *is* speculative abstraction (DR-7, AP-7) — held at Medium not RECONSIDER only because the override is recorded, not silent (OP-11, OP-3). A silent version would be RECONSIDER.

**Three mitigations correctly targeted — keep all three as hard gates:**
1. Pin handoff contract + run discovery test — highest value (QS-3). *Tightening:* the brief names the handoff artifact three ways (context-pack.md / control-pack-schema.md / context-pack). Pin ONE canonical name across schema/SKILL/command/agents before the test.
2. decisions.md rationale in the build commit — this is what earns the Medium hold. Record the DR-7 override as an assertion of a known consumer AND the revert path.
3. Register 3 agents in agent-tier-table.md — mandatory completeness gate (QS-6). Tiers correct.

**Three risks the six-dimension review missed:**
- **Blast radius understated at Low.** `auto-sync-shared.sh` symlinks the command + 3 agents into every project (none match EXCLUDE lists) — new canonical command/agent = all-projects reach (risk-topology § 3). Low severity, not low reach. Decide deliberately whether a zero-consumer command should ship into all 12+ project surfaces, or wait behind an EXCLUDE / manifest opt-out. **→ Fourth gate.**
- **`/create-skill` is a nested QC-gated pipeline, not a file write.** Run it as its own fresh-context step or the skill's QC loses isolation (QS-1, DR-2).
- **Commit atomicity** — 6 artifacts + cross-cutting CLAUDE.md edit across active projects; enumerate paths, no `git add -A` if any concurrent session (DR-10).

**Position:** Proceed under PROCEED-WITH-CAUTION with the three mitigations as hard gates plus a fourth — make the auto-sync exposure a deliberate decision, not a default. Placement stays defensible precisely because it is recorded.
