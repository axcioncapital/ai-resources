# Risk Check — 2026-06-05

## Change

Add a "grounding files absent on disk → stop-and-flag (escalate)" branch to advisory agents that depend on a reference corpus — primary edit to .claude/agents/system-owner.md, with .claude/agents/project-manager.md and .claude/agents/expert-check-reviewer.md audited and edited only if they currently silently proceed-degrade when grounding files are missing. The change alters when these agents halt (judgment-class behavior change). Scope strictly to .claude/agents/. Out of scope: logs/improvement-log.md, Friday-cadence commands, fix-repo-issues.md, resolve-improvement-log.md, docs/session-marker.md — all owned by a live concurrent session.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/system-owner.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/project-manager.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/expert-check-reviewer.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A self-contained, additive preamble change to three advisory agents that is reversible and adds no token/permission cost — but it is a judgment-class behavior change (when the agent halts) reaching a large invoker set (14 commands across system-owner alone), so the principal risk is divergent halt semantics drifting from each agent's already-existing ungrounded-decline contract.

## Consumer Inventory

Search terms: `system-owner`, `project-manager`, `expert-check-reviewer` (agent names), plus the grounding-corpus markers the change keys on (`references/grounding.md`, `references/persona.md`, `references/toolkit-relationship.md`, `systems-building-principles.md`). The change touches each agent's grounding/fallback preamble; the consumers below are the commands and agents that invoke or co-depend on these three agents. Grep run across `ai-resources/` and the workspace root.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/commands/consult.md | invokes (system-owner Fn A/B; project-manager) | no |
| ai-resources/.claude/commands/architecture-review.md | invokes (system-owner Fn C) | no |
| ai-resources/.claude/commands/implementation-triage.md | invokes (system-owner Fn D) | no |
| ai-resources/.claude/commands/systems-review.md | invokes (system-owner Fn E) | no |
| ai-resources/.claude/commands/friday-so.md | invokes (system-owner Fn F) | no |
| ai-resources/.claude/commands/so-monthly.md | invokes (system-owner Fn G) | no |
| ai-resources/.claude/commands/pm.md | invokes (project-manager) | no |
| ai-resources/.claude/commands/expert-check.md | invokes (expert-check-reviewer) | no |
| ai-resources/.claude/commands/friday-act.md | invokes/documents (system-owner advisory wave) | no |
| ai-resources/.claude/commands/pipeline-review.md | documents (System-Owner-grounded review) | no |
| ai-resources/.claude/commands/diagnostics-plan.md | documents (system-owner reference) | no |
| ai-resources/.claude/commands/resolve-incident.md | documents (system-owner reference) | no |
| ai-resources/.claude/commands/new-project.md | documents (system-owner reference) | no |
| ai-resources/.claude/commands/risk-check.md | documents (system-owner reference) | no |
| ai-resources/.claude/agents/project-manager.md | invokes (Task → system-owner Fn A, Phase 4) | no |
| ai-resources/.claude/agents/pipeline-review-auditor.md | documents (system-owner + grounding refs) | no |

Total: 16 consumers, 0 must-change. All consume the agents through the invocation contract (brief in → ≤30/≤40-line summary out) or merely name them in prose. The change is declared additive to preamble/fallback logic and does not alter any output schema, summary cap, or invocation brief — so no consumer must change. Note: `project-manager` is both a target of the change AND a consumer of `system-owner` (it spawns system-owner via Task in Phase 4); a halt-semantics change in system-owner therefore propagates one hop into PM's folded System-Owner Consultation block. The brief surfaced the system-owner invoker list (consult/friday-so/so-monthly/architecture-review + PM sub-consult) but not the full 14-command system-owner footprint or the PM-as-consumer self-edge — see Dimension 3.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file is touched. The change is scoped strictly to `.claude/agents/` per CHANGE_DESCRIPTION ("Scope strictly to .claude/agents."); agent definition files load only when the agent is spawned, not every turn.
- No hook is registered. None of the three referenced files is a hook; no SessionStart/Stop/PreToolUse/UserPromptSubmit registration is described.
- No `@import` chain is added to a CLAUDE.md. The change is preamble text inside agent bodies.
- These agents are spawned on demand (per `/consult`, `/pm`, `/expert-check`, Friday cadence), not auto-loaded broadly. A short preamble branch (a stop-and-flag rule) adds a few lines to each spawned agent's prompt — pay-as-used, well under the 50-token always-loaded threshold for Medium.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings file is touched. The change is to agent body prose, not to any `.claude/settings.json` allow/ask/deny list.
- No new tool capability is introduced. system-owner already declares `Read, Grep, Glob, Task, Skill, Write` (system-owner.md:5-11); project-manager declares `Read, Grep, Glob, Task` (project-manager.md:5-9); expert-check-reviewer declares `Read, Glob, Grep` (expert-check-reviewer.md:5-8). A stop-and-flag branch detects file absence using the already-granted Read/Glob and halts — it removes work rather than adding capability.
- No scope escalation (project→user) and no cross-repo/external write described.

### Dimension 3: Blast Radius
**Risk:** Medium

- Files touched directly: 1 primary (system-owner.md) + up to 2 conditional (project-manager.md, expert-check-reviewer.md) — the latter two only "if they currently silently proceed-degrade when grounding files are missing" (CHANGE_DESCRIPTION).
- Consumer inventory: 16 consumers, 0 must-change. system-owner alone is referenced by 14 command files (grep: so-monthly, implementation-triage, risk-check, pipeline-review, diagnostics-plan, resolve-incident, systems-review, architecture-review, new-project, pm, consult, friday-act, friday-so + the agent self-ref). This is a wide invoker set — the >5-caller Medium/High threshold is met on raw count.
- The reason it is Medium and not High: the change is declared schema-preserving ("does not alter the agents' output schemas or their invocation contracts," per the context note). No invoker parses agent output structurally in a way the change breaks — the `parses` row count against the change is 0. The new halt path emits inside the existing returned-summary channel (system-owner already returns a path-back line + ≤30-line body; the decline-when-ungrounded block at system-owner.md:142-155 already exits via this same channel).
- Self-edge finding (not anticipated by the brief): project-manager invokes system-owner via Task in Phase 4 (project-manager.md:73-94) and folds the verbatim response into a "System-Owner Consultation (folded in)" block (project-manager.md:136-138). A new system-owner halt string therefore appears inside PM's ruling; the ≤8-line fold cap (project-manager.md:138) must still hold. Note: PM ships in degraded mode where this Task dispatch fails deterministically (project-manager.md:108), so the self-edge is latent today but becomes live if/when sub-agent Task dispatch is restored.
- Shared infra: none. No log, script, or always-loaded CLAUDE.md is touched (out-of-scope list explicitly excludes logs/improvement-log.md and the Friday-cadence commands).

### Dimension 4: Reversibility
**Risk:** Low

- Each edit is an in-place preamble addition to an agent `.md` file in the working tree; `git revert` of the commit fully restores prior state. No sibling files or directories are created.
- No data/log mutation. The out-of-scope list explicitly fences off logs/improvement-log.md; the change writes no append-only state.
- No settings.json change, no push beyond local repo, no automation (hook/cron/symlink) that could fire between landing and revert. Agents only run when explicitly invoked.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The change creates an implicit consistency contract across three agents that each already have a distinct, established ungrounded-handling mechanism, and the contract is not documented in one canonical place:
  - system-owner: `Decline-when-ungrounded` block (system-owner.md:142-155) — covers "cannot ground the central recommendation," and Function F already handles a passed `MISSING note` (system-owner.md:48). The new branch must distinguish *grounding file absent on disk* (read failure) from *grounding base lacks the needed claim* (the existing decline) — overlapping mechanisms for an adjacent concern (Dimension-5 overlap signal).
  - project-manager: already has Fallback 5a (cannot ground, project-manager.md:143-159) and Fallback 5c (no constitution docs found, project-manager.md:173-187), plus a Read-before-adopt existence check on steering overrides (project-manager.md:49). PM largely already does NOT silently proceed-degrade when its corpus is absent — Fallback 5c IS the absent-on-disk path. So the "edit only if it silently proceed-degrades" condition in CHANGE_DESCRIPTION may resolve to *no edit* for PM; the auditor must verify rather than add a redundant fourth fallback (would functionally overlap 5c).
  - expert-check-reviewer: already returns `INPUT ERROR: no KB target supplied` (expert-check-reviewer.md:21) and `NO APPLICABLE REFERENCE` (expert-check-reviewer.md:38, 78), and is explicitly forbidden from training-data fallback. Its corpus-absent behavior already halts-and-reports; a new branch risks overlapping these outcomes.
- Implicit dependency on the read-order convention: system-owner's grounding files are read in a fixed order (system-owner.md:27-37). An "absent on disk" branch couples to *which* files count as load-bearing grounding vs optional (e.g., `systems-building-principles.md` is conditionally skipped when `status: TBD`, system-owner.md:37) — the branch must not stop-and-flag on a file that is intentionally optional, or it will halt valid invocations.
- These are established-convention dependencies with partly-documented contracts at each change site, not silent auto-firing — hence Medium, not High. The risk is divergent halt semantics across three agents that look similar but differ (decline vs INPUT ERROR vs Fallback 5a/5c), plus the optional-vs-required-file distinction.

### Dimension 6: Principle Alignment
**Risk:** Low

- The change actively serves **OP-3** (loud failure over silent continuation): "A plausible wrong answer is worse than 'I don't know'" (principles-base.md:41). Stop-and-flag when grounding is absent is the canonical OP-3 behavior and is the stated intent ("halts and reports the missing files instead of silently producing ungrounded output").
- It also serves **AP-2** (fabrication when evidence insufficient — principles-base.md:80) and **QS-4** (no training-data fill, mark the gap — principles-base.md:70): an ungrounded advisory agent producing authoritative output is exactly the fabrication failure these principles forbid; the change closes that path.
- **OP-5** (advisory ≠ enforcement — principles-base.md:43) check: the change keeps the agents advisory. "Stop-and-flag (escalate)" here means the agent halts and reports to the operator/caller — it does not auto-correct, auto-act, or take enforcement authority. system-owner's existing decline block already "offers a bounded next step" (system-owner.md:142-155) and the new branch follows that advise-and-stop shape. No silent advisory→enforcement upgrade. (If, contrary to the description, "escalate" were implemented as the agent auto-invoking another component or auto-modifying state, that would flip OP-5 — but agents lack the slash-command and out-of-output Write capability to do so: system-owner.md:157-163, project-manager.md:209-217.)
- **OP-9 / DR-7 / AP-7** (speculative abstraction — principles-base.md:47, 60, 85) check: the change adds behavior to existing, in-use agents for a real, present concern (ungrounded output today). It is not building infrastructure for an absent consumer; the consumer set is live (16 consumers). No speculative-abstraction signal.
- **OP-2** (automate execution, gate judgment — principles-base.md:40): the description self-labels this a "judgment-class behavior change." It does not automate a judgment that should stay operator-gated — it makes the agent *refuse to exercise judgment without grounding* and hand back to the operator, which strengthens the gate rather than removing it. Aligned.
- Principles-base.md was readable; checks grounded in IDs above.

## Mitigations

- **Dimension 3 (Medium):** Before landing, the operator/implementer confirms the new halt string fits the existing returned-summary channels without schema change — specifically that system-owner's branch exits via the same path-back-line + ≤30-line body shape as the decline-when-ungrounded block (system-owner.md:142-155, 78-83), and that any PM-folded system-owner halt still respects the ≤8-line fold cap (project-manager.md:138). Do not add a new top-level output section to any agent.
- **Dimension 5 (Medium):** For each of the three agents, reconcile the new branch against the agent's *existing* corpus-absent mechanism rather than adding a parallel one — system-owner: extend/disambiguate the decline-when-ungrounded block (file-absent vs claim-absent), do not create a second decline path; project-manager: verify whether Fallback 5c already covers absent-on-disk and edit ONLY if a genuine silent-degrade gap exists (the description's stated condition), else leave PM unchanged and record "no gap"; expert-check-reviewer: confirm `NO APPLICABLE REFERENCE` / `INPUT ERROR` already halt-and-report and edit only on a real gap. Run `/qc-pass` on each edited agent against the contract that the three halt behaviors stay mutually consistent and each distinguishes a *required* grounding file from an *intentionally optional* one (e.g., system-owner's `status: TBD` skip at system-owner.md:37).

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to the three agent definitions, grep-derived consumer counts across `ai-resources/` and the workspace root, verbatim quotes from CHANGE_DESCRIPTION and the agent files, and principle IDs from the readable principles-base.md). No training-data fallback was used on fetch/read failures.

## Architectural Commentary

_System-owner second opinion (`/consult` Function B — pre-change advisory). `/consult` could not be invoked programmatically (model-invocation disabled), so the `system-owner` agent was invoked directly via the Agent tool — equivalent grounding. Invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Grounding-integrity note (this IS the #14 scenario, live):** The brief asserted `principles.md` and `blueprint.md` were absent on disk and invited the agent to decline. The agent verified directly — both are present and readable at the canonical vault paths, along with `risk-topology.md` and `system-doc.md`. The claim was false (the main session's `ls` used a wrong relative path). The agent grounded normally and did NOT decline. An asserted-absent-but-actually-present input is the mirror of #14: same root cause (acting on a grounding-state claim without checking the filesystem). That shapes the answer below.

**Q1 — Concur with PROCEED-WITH-CAUTION?** Yes. Canonical-agent edit reaching a wide invoker set is a DR-8 `/risk-check` class; Reversibility:Low is correct (reversible in source, not in effect once advice ships). One reservation: the verdict names "divergent halt behavior" as the central risk; the deeper risk is false grounding-state detection.

**Q2 — Required-vs-optional the right lever?** Necessary and correct — it maps onto grounding.md's existing Default (required) vs Conditional (optional) reads. But not the deepest invariant. The cleaner one sits above it:

> Verify grounding state from the filesystem before acting; halt only on verified absence of a REQUIRED file; never proceed on asserted presence nor decline on asserted absence without a Read.

Required-vs-optional answers "halt on which files"; verify-before-act answers "halt on what evidence." Reframe required-vs-optional as subordinate to a verify step.

**Q3 — False-halt risk, and bounding it?** Real. PM's Fallback 5c (corpus-absent halt) is already separate from 5a (topic-not-covered decline) — good. expert-check **conflates** them in NO APPLICABLE REFERENCE. The false-halt path is exactly this conflation: halting on "file present but topic thin" when that should route to decline. Bounds: (1) halt fires only on `Read`-failure of a REQUIRED file; (2) conditional/optional miss → proceed-degraded with a note, never halt; (3) trigger is a verified disk check, not a subjective "I feel ungrounded."

**Q4 — Risks the six-dimension review missed:**
1. **Trigger-trust** (load-bearing) — review assumes grounding-presence is reliable; never requires the halt trigger to be a verified Read. Fix: specify trigger as Read-result on REQUIRED paths.
2. **Halt-then-fabricate residual** — halt-semantics ≠ fabrication-suppression. #14 needed both. Reassert the no-fabrication rule alongside the halt.
3. **expert-check is in-scope, not optional** — its conflation IS a real silent-degrade gap, so recommendation (c) puts it in scope.
4. **No smoke test ships** — a halt that can mis-fire silently is itself a #14-class object. Land a documented smoke test: required path → halt fires; present-but-thin → does NOT halt.

**Position:** Proceed, but make verify-before-act the primary lever with required-vs-optional as its partition. Keep the halt narrow (Read-failure only). Treat expert-check's conflation as in-scope. Ship fabrication-suppression + a smoke test alongside. Concur on reusing the existing output channel. This is a `/risk-check`-gated change (DR-8) — the advisory is a second opinion, not an approval; the binding verdict stays with the risk-check gate.

## Verification — documented smoke test (behavioral)

Agent halt behavior cannot be unit-tested mechanically; these are the behavioral scenarios the edit must satisfy, recorded per the second opinion's "land a documented smoke test" point. To re-verify after any future edit to the grounding logic, run the agent against each scenario and confirm the expected branch.

**system-owner.md**
1. REQUIRED absent → HALT. Remove/rename a REQUIRED file (e.g., `grounding.md`) and invoke any function → expect `GROUNDING UNAVAILABLE` (Shape 1), naming the unreadable path; no advisory produced.
2. OPTIONAL absent → proceed-degraded. Remove only `systems-building-principles.md` (status TBD) or a conditional vault doc → expect a normal advisory with an inline gap note; NO halt.
3. REQUIRED present but recommendation unsupported → DECLINE (Shape 2), not GROUNDING UNAVAILABLE.
4. Asserted-absent-but-actually-present (the live #14-mirror that occurred this session) → agent verifies by Read, finds the file present, grounds normally; does NOT decline on the false claim.

**expert-check-reviewer.md**
5. KB path absent/unreadable/zero candidate files → `GROUNDING UNAVAILABLE` (corpus absent), naming what failed to read.
6. KB present with ≥1 candidate summary but none topic-matches the Step subject → `NO APPLICABLE REFERENCE` (topic miss), NOT GROUNDING UNAVAILABLE.
7. KB present, summary matches → normal `ALIGNED` / `DIVERGENCES FOUND` output.

**Pass criterion:** scenarios 1 & 5 halt (corpus-absent escalation); scenarios 2, 3, 4, 6, 7 do NOT halt (no false-halt on optional/thin/present grounding). This separation is the core property the fix protects.
