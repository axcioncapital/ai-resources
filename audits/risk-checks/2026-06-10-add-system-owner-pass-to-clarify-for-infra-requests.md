# Risk Check — 2026-06-10

## Change

Add one conditional step to ai-resources/.claude/commands/clarify.md (after §3 clarifying-questions, before the "Do not proceed until the user responds" line). The step: for infrastructure-implementation requests only (a /clarify whose target is a Claude Code harness resource — command, agent, hook, skill/SKILL.md, workflow template, settings.json, or CLAUDE.md rule — detected via the change-shape framing in docs/change-shape-classifier.md, fenced to that substrate, explicitly adding skills + CLAUDE.md which the classifier omits), AND only when §3 produced ≥1 question: emit [HEAVY], spawn the system-owner agent ONCE via Task (Function B, pre-change advisory) with the §1 restate + §2 assumptions + §3 questions verbatim, ask for a /decide-style three-bucket resolution (Self-resolved / Recommendable / Operator-only) written to disk per the agent's Phase 5 contract. Then escalate to operator using the /decide contract: Operator-only → ask as questions; Recommendable → one-line confirm/override with SO default; Self-resolved → apply silently with an audit-path note. Skip the step entirely for non-infra /clarify or when §3 was empty. clarify.md stays model:sonnet and delegates to the opus system-owner agent. No new files, no classifier edit, no CLAUDE.md rule. Guardrails: single SO spawn per /clarify (not per question), skip when zero §3 questions, [HEAVY] at spawn.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/clarify.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/change-shape-classifier.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/system-owner.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/decide.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/consult.md — exists

## Verdict

RECONSIDER

**Summary:** The change makes `/clarify` — a minimal, broadly-symlinked first-touch command — silently auto-spawn an Opus System-Owner subagent on every infra-shaped clarification, which both creates ongoing token cost on a high-frequency entry command and crosses the advisory→enforcement / pick-and-proceed line (OP-5, decision-point posture) by inserting heavyweight judgment machinery the operator did not invoke.

## Consumer Inventory

clarify.md is a canonical command symlinked into 20 locations (workspace root + harness + 18 projects/archives). Symlink-verified: `.claude/commands/clarify.md`, `harness/`, `projects/strategic-os/`, `projects/repo-documentation/` all resolve to the canonical file. An edit propagates instantly to every consumer — no sync step, but the runtime blast radius is all of them.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `.claude/commands/clarify.md` (canonical) symlinked into 20 locations (workspace root, harness, 18 project/archive `.claude/commands/clarify.md`) | invokes (symlink — all sessions run the changed body) | no (auto-picks up) |
| `ai-resources/.claude/commands/decide.md` (line 19, line 130) | parses (`**Clarifying questions**` heading marker as `/decide` auto-detect source; "verified against `clarify.md:11`") | no — heading marker unchanged; see Blast Radius |
| `ai-resources/.claude/agents/system-owner.md` | invokes (NEW runtime dependency — `/clarify` now Task-spawns this agent, Function B) | no — but see Hidden Coupling (Function B brief currently passed only by `/consult`) |
| `ai-resources/docs/change-shape-classifier.md` | imports / parses (NEW runtime read dependency — `/clarify` now reads the classifier definition; the change also re-fences and extends it inline with skills + CLAUDE.md) | no file edit (change says "no classifier edit"), but a new consumer of its contract |
| `ai-resources/.claude/commands/consult.md` | documents (precedent for the SO Function-B spawn pattern; not invoked by the change) | no |
| `ai-resources/docs/repo-architecture.md` | imports (Function B per system-owner.md Phase 2 expects `/consult` to have read this and passed ROUTING_CONTEXT; `/clarify` does not) | no edit, but a coupling gap — see Hidden Coupling |

Total: 6 distinct consumer classes (1 of them = 20 symlinked invocation sites), 0 must-change-to-keep-working at the file level. The notable inventory finding: the change adds **two new runtime dependencies** (`system-owner` agent + `change-shape-classifier.md`) to a command that today has none beyond `docs/session-marker.md` nudge logic — and a **third implicit one** (`repo-architecture.md` routing context) that the change does not wire up.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- `/clarify` is a high-frequency, often-first command — its own preamble says so: "`/clarify` is often a session's first command" (`clarify.md:7`). Any per-invocation cost added here is paid broadly.
- The change does not add always-loaded tokens (no CLAUDE.md edit, no `@import`, no hook) — it is pay-as-used, which caps the risk below High.
- But the "used" path now spawns an **Opus** subagent (`system-owner.md:4` `model: opus`) that, per its own Phase 1, reads three reference files plus `systems-building-principles.md` on every invocation (`system-owner.md:29-37`), then per Function B reads vault docs via the per-function read map (`system-owner.md:64-67`). That is a non-trivial Opus spawn fired automatically inside a Sonnet command, on every infra-shaped `/clarify` with ≥1 question.
- Net: meaningful recurring cost on a frequent entry command, but gated (infra-only AND ≥1 question), so Medium not High.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` edits; the change description states "No new files, no classifier edit, no CLAUDE.md rule."
- The `system-owner` agent already holds `Task`, `Read`, `Grep`, `Glob`, `Skill`, `Write` (`system-owner.md:5-11`) scoped to `output/` — no new capability is granted. `/clarify` already runs in a `bypassPermissions` workspace (per MEMORY), and `Task`-spawning an existing agent introduces no new permission surface.

### Dimension 3: Blast Radius
**Risk:** High

- Direct files touched: 1 (`clarify.md`). But that file is symlinked into 20 locations (inventory, symlink-verified) — the behavior change reaches every project and the harness simultaneously.
- New runtime consumers introduced: 2 (`system-owner` agent + `change-shape-classifier.md`), per inventory. `/clarify` today has zero subagent/agent dependencies; this makes a minimal Sonnet command depend on the Opus SO agent and the classifier doc at runtime.
- `/decide` parse-contract (`decide.md:19`): `/decide` auto-detects the `**Clarifying questions**` numbered list as its source, "verified against `clarify.md:11`." The change inserts a step *after* §3, shifting line numbers and inserting a new SO-pass / three-bucket block between §3 and the rest of the command. The `**Clarifying questions**` heading marker itself is unchanged (the change inserts after it), so `/decide` auto-detect still matches — but the inserted step *also reproduces a `/decide`-style three-bucket resolution inline*, which means two overlapping mechanisms now produce three-bucket output around the same question list (see Hidden Coupling). The stale `clarify.md:11` line anchor in `decide.md` is pre-existing drift (line 11 is the session-marker note, not §3), not caused here, but the change widens the gap between that anchor and the real structure.
- Shared infra: `/clarify` is the canonical first-touch command across the whole workspace. A regression in its body (e.g., the infra-detection misfires, or the SO spawn errors) degrades session entry for all 20 consumers at once.
- Any caller requires modification to keep working? No — but ">5 dependent callers" (20 symlinks) and "shared infra touched in a way that affects multiple workflows" both independently push this to High under the heuristic.

### Dimension 4: Reversibility
**Risk:** Medium

- The `clarify.md` edit itself is a clean single-file `git revert` (the symlinks auto-revert with it).
- But the SO pass writes a per-invocation advisory to disk under `projects/axcion-ai-system-owner/output/consultations/` (`system-owner.md:87`, Phase 5 contract). A revert of `clarify.md` does not remove advisory files already generated by the new step — they persist as orphaned artifacts. One extra cleanup step → Medium, not Low.
- No external writes, no push, no hook/cron that fires between landing and revert. The added automation is in-command (only fires when `/clarify` is invoked), so there is no autonomous firing window.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Function B brief contract not honored.** `system-owner.md:54` (Function B) states the calling command "will have read `ai-resources/docs/repo-architecture.md` and passed the routing baseline in your brief" — and `/consult` Step 3 (`consult.md:64-68`) is the component that does this read and passes `ROUTING_CONTEXT`. The change spawns Function B from `/clarify` but does not wire up the `repo-architecture.md` read or `ROUTING_CONTEXT`. The SO agent will run Function B with a missing routing baseline — an implicit dependency the change site does not satisfy.
- **Function B contract is `/consult`-shaped, not `/clarify`-shaped.** The agent's Function B output shape (`system-owner.md:95-101`) is routing position + architectural commentary + downstream impact, written to `output/consultations/` — not a "three-bucket Self/Recommendable/Operator-only resolution." The change asks the SO agent for a `/decide`-style three-bucket output that the agent's Phase 5 does not define for Function B. The agent is being asked to honor a contract (`/decide` three-bucket) it does not implement; this is a new undocumented contract pushed onto an existing agent.
- **Two overlapping mechanisms for the same concern.** `/decide` already exists precisely to take a `/clarify` §3 list and produce a three-bucket resolution (`decide.md:130` "After `/clarify` → `/decide` pre-researches each clarifying question"; `clarify.md:24` already offers `/decide` on the §3 list). The change builds a *second*, auto-firing three-bucket path inside `/clarify` itself, overlapping `/decide`'s purpose. Functional overlap with an existing mechanism is a High coupling signal under the heuristic.
- **Classifier re-fencing.** The change "fences" the classifier to the harness substrate and "explicitly adds skills + CLAUDE.md which the classifier omits" — but says "no classifier edit." So `/clarify` carries an inline, divergent copy of the change-shape definition that drifts from the canonical `change-shape-classifier.md` (which the classifier doc itself warns against: "no verbatim copies to keep in sync," `change-shape-classifier.md:9`). The classifier's own consumer list (`change-shape-classifier.md:5-8`) is a two-consumer contract; adding a third consumer with a *locally modified* definition reintroduces the drift the DR-7 extraction closed (`change-shape-classifier.md:41`).

### Dimension 6: Principle Alignment
**Risk:** High

Principles-base read OK (`projects/strategic-os/ai-strategy/principles-base.md`).

- **OP-5 (advisory ≠ enforcement) + OP-2 (gate judgment, automate execution).** `/clarify` today is a pure advisory, operator-paced step: it restates, lists assumptions, asks questions, and *stops* ("Do not proceed until the user responds," `clarify.md:22`). The change inserts an *auto-firing* heavyweight judgment pass (Opus SO spawn + three-bucket resolution + "Self-resolved → apply silently") into that advisory pause. "Apply silently with an audit-path note" moves an advisory step toward auto-acting on judgment calls — exactly the advisory→enforcement upgrade OP-5 says must be an explicit per-component decision, not a silent build.
- **Decision-point posture / AP-4 conflict.** Workspace CLAUDE.md decision-point posture and `/decide`'s own design (`decide.md:7` "Operator-invoked only. Do NOT auto-fire."; `decide.md:139`) establish that the three-bucket resolution is an *operator-invoked* tool. The change auto-fires that machinery from `/clarify` without operator invocation, contradicting the established posture that `/decide` is opt-in. `consult.md:24` likewise reserves SO consultation "for genuinely contested or load-bearing system-shape questions, not for verification of already-confident recommendations" — auto-spawning it on every infra `/clarify` with a question is the over-firing that line guards against.
- **OP-9 / AP-7 / DR-7 (speculative abstraction) — tension, not clear violation.** The change does have a confirmed consumer (infra `/clarify` requests exist), so it is not building for an absent consumer. But it generalizes the SO-spawn pattern from its one designed home (`/consult`) into a second command without the routing-context wiring that pattern requires (see Hidden Coupling) — a partial, premature generalization. This is the secondary signal; the primary violations are OP-5/OP-2.
- **OP-11 (loud revision).** The change does NOT loudly acknowledge that it is relaxing the advisory posture of `/clarify` and the opt-in posture of `/decide`/`/consult`. It is framed as "add one conditional step," which understates a posture shift. Per the Dimension-6 special handling, a High that does not loudly acknowledge the revision stays High and pushes the verdict to RECONSIDER.

## Recommended redesign

- **Rescope to advisory + operator-gated (resolves OP-5/OP-2/decision-point).** Do not auto-spawn the SO agent inside `/clarify`. Instead, keep `/clarify`'s existing one-line offer pattern (`clarify.md:24` already offers `/decide`): add a *single advisory line* for infra-shaped requests — "Infra-implementation request detected; consider `/consult` (SO pre-change advisory) or `/decide` on the §3 list before answering." This keeps `/clarify` minimal and advisory, makes the heavyweight pass operator-invoked (preserving `/decide`/`/consult`'s opt-in posture), and adds zero recurring Opus cost. This is the minimal-infra subset and likely the QC-clean path.
- **If the auto-spawn is genuinely wanted, make the posture revision loud and recorded (OP-11).** Land it as an explicit, recorded decision that `/clarify` is being upgraded from advisory-only to auto-consultative for infra requests — not as "one conditional step." Then also (a) wire the Function B `repo-architecture.md` / `ROUTING_CONTEXT` read into `/clarify` so the agent's contract is honored, (b) define the three-bucket output for Function B in `system-owner.md` (or route through the real `/decide` rather than a reimplementation), and (c) avoid the inline classifier copy — read `change-shape-classifier.md` and, if skills + CLAUDE.md must be in scope, add those categories to the canonical doc (DR-7 one-end contract) rather than fencing a divergent copy in `clarify.md`.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: symlink-verified consumer inventory (`ls -la` on 4 representative project copies; 20 symlinks enumerated via `find`), line-cited reads of `clarify.md`, `decide.md`, `consult.md`, `system-owner.md`, `change-shape-classifier.md`, and principle IDs cited from `principles-base.md` (read OK). No training-data fallback was used.
