# Risk Check — 2026-05-27

## Change

Add `## Project Config` schema block (12 declarative fields per Pass 5 §3.3 of `audits/workflow-audit/05-template-fitness.md`) to canonical research-workflow template's `CLAUDE.md` (at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/CLAUDE.md`); recommended placement: immediately after `## Operator Profile`. Create new `docs/` directory in canonical workflow + write `docs/project-config-schema.md` documenting each field (name, type, default, description, where consumed). This is FX-B7 of `plans/fix-phase-plan-v1.md` Work Unit 3. Structural change classes touched: (1) always-loaded canonical CLAUDE.md content addition (highest blast-radius class — every research-workflow deployment will inherit this section); (2) new directory creation in canonical workflow root. Lightweight GR-2-default-anchor note will be added to commit message + `logs/decisions.md` explaining CLAUDE.md-vs-`.project-config.yml` choice and future-migration triggers (>20 fields, machine-parsed consumers, non-Axcíon forks). Stage: plan-time gate, before any edits. End-time risk-check will run again before commit.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/audits/workflow-audit/05-template-fitness.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/plans/fix-phase-plan-v1.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/docs/project-config-schema.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/decisions.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A net-new always-loaded schema block in canonical workflow CLAUDE.md and a brand-new `docs/` directory; reversibility and permissions surface are clean, but the schema sets a contract that ~6 future consumers (Stage 5 commands, three Stage-2 skills, country-parity-checker, Bundle-2 reference docs) will read at runtime, and the template currently has zero downstream consumers that actually parse it — single-consumer-template trap is the live failure mode.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- Canonical workflow CLAUDE.md is currently 131 lines (`wc -l` on `ai-resources/workflows/research-workflow/CLAUDE.md`); the schema block from Pass 5 §3.3 lines 378–393 is a 14-line markdown block with 12 field definitions plus inline comments. Adding the block at always-loaded scope adds ~150–200 tokens on every session loaded against a deployed project (matches the Medium calibration: "adds ~50–150 tokens to always-loaded files" — this nudges into the upper Medium band).
- The block is `## Project Config` plain markdown; no `@import` chain, no hook registration, no skill auto-trigger. Cost is per-session, not per-tool-call.
- `docs/project-config-schema.md` is NOT always-loaded — it sits in `docs/` and is read on-demand by consumers / the operator. No ongoing token cost from the schema doc itself.
- Token cost compounds across the two confirmed deployment instances (nordic-pe-macro-landscape-H1-2026 deployed; buy-side-service-plan frozen pre-Bundle-1 per `decisions.md` 2026-05-26 entry) — but in practice only one project actively loads the workflow CLAUDE.md today.

### Dimension 2: Permissions Surface
**Risk:** Low

- No edits to any `.claude/settings.json` or `.claude/settings.local.json`. No `allow` / `ask` / `deny` rule additions, removals, or scope changes.
- No new tool families (Bash, Write, external APIs, MCP servers) introduced.
- The change is markdown content + a new directory; no executable surface, no hook wiring, no skill auto-trigger pattern that would broaden invocation-permission surface.

### Dimension 3: Blast Radius
**Risk:** High

- Direct file touches: 1 edit (`ai-resources/workflows/research-workflow/CLAUDE.md`) + 1 new file (`ai-resources/workflows/research-workflow/docs/project-config-schema.md`) + 1 new directory (`docs/`). Edit count itself is small.
- Pass 5 §3.3 line 395 verbatim names six downstream consumers that "all read this config at runtime": **(a)** Stage 5 commands (3 commands per FX-B1 — `produce-prose-draft`, `produce-formatting`, `produce-jargon-gloss`); **(b)** `research-prompt-creator` skill; **(c)** `execution-manifest-creator` skill; **(d)** `transaction-table-builder` skill; **(e)** `country-parity-checker` skill; **(f)** `reference/source-class-hierarchy.md` and `reference/known-limits.md` (Bundle-2 reference docs).
- The current canonical template ships ZERO of those consumers wired to read this block — grep `grep -r "Project Config\|project-config" ai-resources` returns no hits. The schema is a forward contract; today no caller reads it.
- Grep across `ai-resources/.claude/commands/` confirms 4 commands (`analyze-workflow.md`, `session-plan.md`, `graduate-resource.md`, `repo-dd.md`, `deploy-workflow.md`) reference the canonical research-workflow path — none of these parse CLAUDE.md content; they reference the directory by path only.
- Per Pass 5 §3.3 line 397 the schema is intentionally markdown rather than YAML to keep it "always loaded" and human-readable — but the consequence is that ~6 future consumers must each implement their own markdown parser (or read literal lines). Each consumer becomes a parse-coupling site to the field shape chosen in this change.
- Single-consumer-template trap: the additional-context note from the orchestrator explicitly flags "Canonical research-workflow currently has only ONE consumer (this nordic-pe project); Pass 4's fitness audit hypothesized 3 adjacent projects but did not run them — single-consumer template trap is a known risk surface for this graduation arc." This bumps the dimension to High: the schema's field shape will harden on first-consumer needs without a second-consumer pull test.

### Dimension 4: Reversibility
**Risk:** Low

- Two artifacts created: an edit (clean `git revert` restores prior CLAUDE.md) and a new directory + file (untracked-until-committed; `git rm -r docs/` after commit reverses cleanly).
- No state propagates beyond the local repo at this stage: no `git push`, no external write, no log mutation, no symlink, no hook registration.
- The GR-2-default-anchor note in `logs/decisions.md` is an append-only log entry — `git revert` cleanly removes the line if rollback is needed (no compounding semantic state).
- No automation (hook, cron, symlink) fires between landing the change and a potential revert.
- One minor manual step in a revert scenario: any caller authored after this change that reads the `## Project Config` block must also be rolled back. This is a "Low+" concern since no caller exists yet — but it shifts toward Medium if FX-B1 lands before the rollback decision.

### Dimension 5: Hidden Coupling
**Risk:** High

- The schema introduces a NEW contract — 12 named fields with specific markdown format (`**field-name:** value  # comment`) — that ~6 future consumers will parse. Pass 5 §3.3 line 395 names them but no consumer skill or command has the parser implemented yet. Each consumer becomes an implicit dependency on (a) field naming, (b) value-format conventions (list-of-strings vs string vs enum), (c) markdown-section presence at the path inferred from the consumer's read pattern.
- The change description names `docs/project-config-schema.md` as documenting "where consumed" for each field — this is a positive design move but the contract is only verbally documented; no machine-readable schema (JSON Schema, YAML with explicit types) backs it. Future consumers can drift in their parsing assumptions without a single source-of-truth check.
- Field overlap risk: `reference/source-class-hierarchy.md § Project Country Set` (cited at Pass 5 §3.3 line 383 — "mirrors") already encodes `Country set`. Two encodings of the same value (CLAUDE.md `Country set: [SE, NO, FI]` AND `source-class-hierarchy.md § Project Country Set`) creates a drift risk — the two can disagree silently, and Pass 5 §3.3 line 397(c) frames mirroring as a design feature, not a one-way derivation. No "single source of truth" rule is stated.
- Single-consumer-template trap (also a coupling risk): with only one deployed project actually reading the workflow CLAUDE.md today, the field naming and value conventions will be tuned to nordic-pe's specifics — but the change description claims the schema is the basis for FX-B1's parameterization syntax. If a second deployment surfaces a field that doesn't fit (e.g., a project with no `Languages` axis, or `Deal-size lens` as a multi-band list), the contract must be edited and ~6 consumers re-aligned.
- GR-2 deferral mechanism (CLAUDE.md vs `.project-config.yml`): the change description acknowledges GR-2 may later move the schema. Until then, the markdown-format choice is a hidden coupling — moving to YAML later means rewriting all consumer parsers. The migration-trigger note in `logs/decisions.md` (">20 fields, machine-parsed consumers, non-Axcíon forks") mitigates this somewhat by naming the inflection points loudly.

## Mitigations

- **Dimension 3 (Blast Radius — High):** Defer wiring the 6 named downstream consumers (Stage 5 commands, three Stage-2 skills, country-parity-checker, Bundle-2 reference docs) to FX-B1+ work units. This change lands the schema + docs ONLY — no consumer edits. Spec it in `docs/project-config-schema.md` so future consumer authors have a single canonical source, and explicitly state in the schema doc that no consumer reads it yet (forward contract, not a live contract). Re-run end-time `/risk-check` after FX-B1 lands to re-evaluate blast radius once parsers exist.
- **Dimension 3 (Blast Radius — High):** In `docs/project-config-schema.md`, list each of the 6 named consumers from Pass 5 §3.3 line 395 with a "Reads:" sub-bullet per field showing which consumer reads which field (the audit names consumers globally but not field-by-field). This makes downstream parser-author work concrete and surfaces field-fan-out for any future refactor.
- **Dimension 5 (Hidden Coupling — High):** In `docs/project-config-schema.md`, write an explicit "Single source of truth" rule for overlapping fields — for `Country set` specifically, declare which file is canonical (CLAUDE.md `## Project Config` OR `reference/source-class-hierarchy.md § Project Country Set`) and which is the mirror. Pass 5 §3.3 line 397(c) implies the source-class-hierarchy is the legacy source; declare CLAUDE.md the new canonical and source-class-hierarchy the derived mirror, or vice versa. Without this, the two encodings WILL drift silently.
- **Dimension 5 (Hidden Coupling — High):** Add a parse-format note to `docs/project-config-schema.md` showing one canonical parse pattern (e.g., regex or read-instruction) that consumer skills should standardize on. Pass 5 §3.3 line 397 calls markdown "human-readable" but does not specify the parse format — each downstream skill author would otherwise invent their own (`grep -E "^\*\*field-name:\*\*"` vs full markdown-AST parse vs literal-line read). One canonical pattern reduces 6 implicit dependencies to 1 documented one.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files). Specifically: schema field count + line range verified by direct read of `05-template-fitness.md` lines 378–393; CLAUDE.md size verified via `wc -l` (131 lines); existence of `docs/` directory verified via `ls` (does not exist); consumer enumeration quoted verbatim from `05-template-fitness.md` line 395; absence of existing parsers confirmed via `grep -r "Project Config\|project-config" ai-resources` (no hits); two deployment instances verified via `decisions.md` 2026-05-26 entry "buy-side-service-plan Bundle 1 sync-or-freeze"; consumer-wiring scope of FX-B7 vs FX-B1 separation verified via `fix-phase-plan-v1.md` lines 104–116 + 130 (FX-B7 spec) and 130 (FX-B1 dependency). No training-data fallback was used on fetch/read failures.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

# Pre-Change Advisory — FX-B7 (Project Config schema block + new `docs/` directory)

## 1. Routing position — concur

The change is routed correctly. The schema is rule-shaped, always-loaded, declarative per-project content meant to be operator-visible on every turn — Q4 puts that in a CLAUDE.md at the appropriate scope, and the workflow-template's own CLAUDE.md is the workflow-scope analogue. The `templates/<name>` pattern is correctly ruled out: those fragments are read at scaffold time by a consuming command, not always-loaded at runtime (`repo-architecture.md § Q8` and the "Deployable canonical fragment" row of the canonical-homes table). The companion `docs/project-config-schema.md` is correctly placed under `ai-resources/workflows/research-workflow/docs/` — process docs are load-on-demand reference and `docs/<name>.md` is the canonical home (`repo-architecture.md § Q2` and § "Process documentation" row).

## 2. Concurrence on PROCEED-WITH-CAUTION

We concur with the verdict. The risk-check is internally consistent and the architectural failure mode it names — single-consumer-template trap with zero current parsers and ~6 forward consumers — is the right one to flag. Critically, the dimension review correctly resists the temptation to escalate to RECONSIDER on the basis of forward consumers that do not yet exist. That is the right call: a forward schema with no live readers is not a violated principle, it is a managed-risk decision. (`risk-topology.md § 3 Risk Classification by Change Type` — cross-cutting CLAUDE.md edit + new canonical command/agent-class artifact, both at `/risk-check` gate scope.)

The verdict aligns with how `principles.md § DR-8` frames structural changes: the gate fires, the verdict is binding, mitigations attach.

## 3. Concurrence on the four mitigations — with one tightening

The four mitigations are the right shape. They convert the High blast-radius + High hidden-coupling pair into a Medium-Medium posture for the present landing, which is what a PROCEED-WITH-CAUTION exit should look like.

But mitigations 1 and 2 together encode a load-bearing architectural rule that is not yet stated in writing — and it warrants explicit naming, not just being implied by sequencing:

- **The schema is a forward contract, not a live contract, until FX-B1 lands.** Mitigation 1 names "no consumer reads it yet" as a schema-doc note; this should be elevated to a structural disclaimer at the **top** of `## Project Config` in CLAUDE.md itself, not buried in `docs/project-config-schema.md`. Reason: the schema doc is load-on-demand; the CLAUDE.md block is always-loaded. The "no live consumer" status is exactly the kind of fact every session needs to know on every turn (`principles.md § OP-3 — loud failure over silent continuation` and `§ DR-5` on what earns its place in always-loaded content). A future contributor who skims the schema in CLAUDE.md without reading the doc will otherwise assume the consumers exist.

The other three mitigations are correctly scoped:
- Per-consumer field-fan-out table (mitigation 2): correct application of `principles.md § DR-7` — when generalization is committed before consumers exist, the documentation must make the future-consumer dependency explicit and concrete.
- Single source of truth rule for `Country set` (mitigation 3): non-negotiable. `risk-topology.md § 3` flags "string literal matched by another component (two-end contract)" as a signal that elevates a change to structural risk; the `Country set` overlap with `reference/source-class-hierarchy.md § Project Country Set` is exactly that contract. Not declaring canonical-vs-mirror direction is silent drift waiting to happen (`principles.md § AP-1 — silent conflict resolution`).
- Canonical parse-format note (mitigation 4): correct application of `principles.md § OP-6 — the operator's mental model, not just instructions`. Specifying one parse pattern transfers the *why* (consistency reduces 6 implicit dependencies to 1 documented one), not just a procedure.

## 4. Risks the dimension review missed

Three risks are not surfaced in the risk-check report and should be added to the schema doc or the GR-2-default-anchor decision note before commit:

**(a) `principles.md § DR-7` and `§ AP-7` tension is structural, not just cautionary.**
The risk-check names "single-consumer-template trap" as a blast-radius factor but does not name it as a principle violation. It is one — or close to one. DR-7 states: "Components start specific. No speculative generalization, shared interfaces, or pre-emptive 'hooks for Phase 2' unless a downstream consumer exists and requires them." AP-7 is the matching anti-pattern. FX-B7 is, on its face, speculative abstraction: it adds a 12-field schema for ~6 consumers that don't exist yet. The argument that rescues it from outright DR-7 violation is that FX-B7 is paired with FX-B1 in the same fix-phase plan and FX-B1 is the first confirmed consumer-builder — the schema is being landed one work-unit ahead of its first parser. That makes it a sequencing choice, not speculation. **But the sequencing argument must be written into the GR-2-default-anchor note**, otherwise this change is the textbook AP-7 a future audit would flag. The decision note already names migration triggers; it should also name the DR-7 sequencing justification (FX-B1 within the same fix-phase plan is the first confirmed consumer, landing within N work units) and the rollback rule (if FX-B1 does not land within the fix-phase plan window, the schema either gets a consumer or gets reverted — it does not sit idle indefinitely).

**(b) Workflow-template CLAUDE.md is not the same blast-radius class as a deployed CLAUDE.md, and that distinction is not made in the risk-check.**
The risk-check treats the change as "cross-cutting CLAUDE.md edit" (the highest blast-radius row in `risk-topology.md § 3`). That is the correct gate trigger — but the blast radius itself is bounded by `/deploy-workflow` consumption: the template's CLAUDE.md only reaches a session when a project deploys the workflow. Today that is one active project (nordic-pe) plus one frozen (buy-side-service-plan). Compare to a workspace `CLAUDE.md` edit, which hits every session of every project at the next session start. The risk-check's blast-radius reasoning is anchored on the *future* consumer count (~6 parsers × N deployments), not the present session-load count (1 active deployment × 1 always-load). This is fine — the future count is the right thing to govern by — but it should be stated explicitly so a later reviewer doesn't conflate workflow-template CLAUDE.md edits with workspace CLAUDE.md edits as a general rule. (`risk-topology.md § 1` distinguishes workspace `CLAUDE.md` and `ai-resources/CLAUDE.md` as Critical / system-wide; workflow-template CLAUDE.md is not in that table — it belongs in a lower row that does not yet exist. Surface this as a vault gap for the next monthly cadence: the risk-topology has no row for workflow-template CLAUDE.md as a distinct class.)

**(c) FX-B1's parser-author work needs a `/risk-check` gate of its own, and the mitigation 1 re-evaluation does not by itself ensure that.**
Mitigation 1 says "end-time risk-check re-evaluates blast radius after FX-B1 lands." That is necessary but not sufficient. FX-B1 will introduce six parsers — three Stage 5 commands, three Stage-2 skills, plus the country-parity-checker and Bundle-2 doc updates — and each is itself a `principles.md § DR-8` structural change (command edit or new skill code that consumes always-loaded content). The right framing is: FX-B7's PROCEED-WITH-CAUTION verdict is contingent on FX-B1 each running its own plan-time `/risk-check` before parser implementation, not just one rolled-up end-time check after the fact. Add this dependency to the fix-phase plan and to the GR-2 decision note: "FX-B1 inherits the schema contract from FX-B7 and must run plan-time `/risk-check` per parser-batch before consumer wiring."

## 5. Position

**Proceed with FX-B7 under the four mitigations, plus three additions:**

1. Elevate the "no live consumer yet" disclaimer to the top of the `## Project Config` block in CLAUDE.md itself, not just the schema doc.
2. Write the DR-7 sequencing justification into the GR-2-default-anchor note in `logs/decisions.md` — name FX-B1 as the first confirmed consumer, name the rollback trigger if FX-B1 doesn't land within the fix-phase plan window.
3. Add to the fix-phase plan: FX-B1 inherits FX-B7's contract and must run plan-time `/risk-check` per parser-batch before consumer wiring; FX-B7's end-time `/risk-check` is the second gate, not the only gate.

Surface to the next Friday cadence: `risk-topology.md § 1` has no row for workflow-template CLAUDE.md as a distinct load-bearing class; add one so future audits don't conflate it with workspace CLAUDE.md edits.

The change is the right shape, the routing is right, the mitigations are right. The three additions close the gap between "this looks like speculative abstraction" and "this is a sequenced, bounded, reversible forward-contract decision documented as such."
