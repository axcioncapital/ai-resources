# Risk Check — 2026-06-11

## Change

C5 — Split the pause-on-Critical rule in run-execution.md Step 2.1b: reword Step 2.1b line 60 ("If REVISE with any Critical findings: pause for operator review before proceeding") to distinguish a mechanical Critical (one correct answer, no editorial judgment — auto-apply and re-QC under the no-manual-tasks-during-execution directive) from a judgment Critical (needs an editorial or scope decision — pause for operator). Conservative default: ambiguous → judgment → pause. Also add a Critical Finding Classification section to reference/quality-standards.md (after line 22, before Evidence Calibration) defining the mechanical-vs-judgment distinction for REVISE-finding criticality. Note: run-report.md:48 and produce-architecture.md:84 also "PAUSE on FAIL with critical findings" but those are QC-gate FAIL rules (a different rule class), not REVISE-finding criticality — the quality-standards.md section governs REVISE-finding criticality only. Files: projects/positioning-research/.claude/commands/run-execution.md, projects/positioning-research/reference/quality-standards.md.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/positioning-research/.claude/commands/run-execution.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/positioning-research/reference/quality-standards.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A small, well-scoped, easily-reversible project-local advisory-rule edit that correctly relaxes an over-strict pause gate to match a standing autonomy directive — but it omits one co-edit consumer (the canonical `research-prompt-qc` SKILL.md, which carries the identical pause-on-Critical rule), so without lockstep wording the change leaves the F5 contradiction in place rather than closing it.

## Consumer Inventory

Search terms: `run-execution`, `/run-execution`, `quality-standards`, `Step 2.1b`, `Critical Finding Classification`, `pause on Critical`, the REVISE-finding criticality rule, and the `no-manual-tasks-during-execution` directive. Searched `ai-resources/.claude/`, `ai-resources/skills/`, `ai-resources/workflows/`, `projects/positioning-research/.claude/`, and `projects/positioning-research/reference/` across the repo and the workspace root.

The change touches two *specific contracts*: (1) the REVISE-finding pause rule at `run-execution.md` Step 2.1b.9, and (2) the new "Critical Finding Classification" section in `quality-standards.md`. Consumers are scored against those contracts, not against every file that merely names the two filenames (audit reports, token-audit tables, session logs — these `document` the files historically and do not parse the changed lines).

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/skills/research-prompt-qc/SKILL.md (§ Autonomy Rules, line 165) | parses / co-edits — carries the identical rule "REVISE verdict with any Critical findings: Pause for operator review" that drives Step 2.1b.9's subagent behaviour | yes |
| projects/positioning-research/reference/quality-standards.md | co-edits — receives the new Critical Finding Classification section the command will reference | yes (part of the change) |
| projects/positioning-research/.claude/commands/run-execution.md | co-edits — the reworded Step 2.1b.9 (part of the change) | yes (part of the change) |
| projects/positioning-research/.claude/commands/run-report.md (line 48) | documents — sibling "PAUSE on FAIL with critical findings", explicitly out of scope (QC-gate FAIL class, not REVISE-finding criticality) | no |
| projects/positioning-research/.claude/commands/produce-architecture.md (line 84/line 5) | documents — sibling "FAIL with critical findings: PAUSE", explicitly out of scope (QC-gate FAIL class) | no |
| ai-resources/workflows/research-workflow/.claude/commands/intake-reports.md | documents — names run-execution Step 2.2b as the intake entry path; does not parse the 2.1b pause rule | no |
| ai-resources/skills/workflow-system-analyzer/SKILL.md | documents — names run-execution in workflow analysis; no parse of the pause rule | no |

Total: 7 distinct consumers, 3 must-change (2 are the change targets themselves; **1 — `research-prompt-qc/SKILL.md` — is a must-change consumer not named in CHANGE_DESCRIPTION**). The `not yet present` case does not apply — both target files exist. The new "Critical Finding Classification" heading has **zero current parsers** beyond the reworded command that will reference it (verified: no existing file references that heading; the audit/plan files that name the concept are the change's own provenance trail, not runtime parsers).

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file is touched. `run-execution.md` is a command body loaded only when `/run-execution` runs; `quality-standards.md` self-declares "Not needed for every turn" (quality-standards.md:9) and is read only "When running QC checks, applying fixes to prose, or handling evidence gaps."
- No hook is registered, no `@import` added, no subagent brief expanded. The reword is a few sentences in Step 2.1b.9 (run-execution.md:60); the new section is one self-contained block inserted after quality-standards.md:22.
- The new section adds ongoing read cost only inside Step 2.1 / Step 2.3 / QC contexts that already read `quality-standards.md` (run-execution.md:41, :107) — a marginal, pay-as-used addition, not a per-turn cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings file, `allow`/`ask`/`deny` rule, tool-invocation pattern, or external/cross-repo capability is touched. The change is pure markdown content in a command body and a reference doc.
- If anything, the change *narrows* autonomous action surface in the conservative direction is unchanged and *widens* auto-apply only for the mechanical-Critical case — but that is a workflow-autonomy posture, not a tool-permission grant, and it is gated by the conservative "ambiguous → judgment → pause" default (CHANGE_DESCRIPTION).

### Dimension 3: Blast Radius
**Risk:** Medium

- Grounded in the Step 1.5 inventory: 7 consumers, 3 must-change. Two of the three must-change rows are the change's own target files. The driving finding is the **third**: `ai-resources/skills/research-prompt-qc/SKILL.md` § Autonomy Rules line 165 carries the rule verbatim — "**REVISE verdict with any Critical findings:** Pause for operator review." Step 2.1b.9 is the command-level mirror of this skill rule; the skill is what the qc-gate subagent actually reads at Step 2.1b (run-execution.md:55 loads `research-prompt-qc/SKILL.md`).
- **Inventory gap vs. CHANGE_DESCRIPTION:** the change names only the two project files and the two out-of-scope siblings (run-report.md:48, produce-architecture.md:84). It does not name `research-prompt-qc/SKILL.md`. If only the command is reworded, the subagent still executes the skill's unqualified "pause on any Critical," so the very F5 collision this change exists to resolve is displaced into the skill rather than closed. This is a blast-radius finding the change must absorb.
- Counter-weight keeping this Medium not High: the two explicitly-excluded siblings are correctly excluded — they are QC-gate FAIL rules (a different rule class), confirmed at run-report.md:48 and produce-architecture.md:84/5. The contract change is backwards-compatible (a stricter pause is being *split into* a stricter-or-equal pair with a conservative default), and no other workflow stage parses the REVISE-finding pause shape. The remaining 4 consumers merely `document` the filenames.
- Scope-escalation watch: if the fix is applied to `research-prompt-qc/SKILL.md` (the structurally-correct lockstep target), blast radius expands from project-local to **canonical multi-project** — that skill is shared by every project deploying the research workflow (DR-1). That is the right fix but a wider one; see Mitigations.

### Dimension 4: Reversibility
**Risk:** Low

- Both edits are in-place content changes to two version-controlled files (one command body, one reference doc). A single `git revert` fully restores prior state — no sibling files or directories are created, no data/log/registry is mutated, no `settings.json` cached state.
- No state propagates beyond git: no push, no external write, no Notion/API call, no symlink or hook registered that could fire between landing and revert.
- The new section is additive (insert after line 22) and the reword is local to one numbered step — revert is clean with no stale-entry residue.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The change creates a **new cross-file contract**: Step 2.1b.9 in `run-execution.md` will *reference* the "Critical Finding Classification" section defined once in `quality-standards.md` (CHANGE_DESCRIPTION: "define mechanical-vs-judgment Critical once, referenced by the pipeline"). This is a single new contract, and it is documented at the change site (the section lives in the reference doc the command already loads at run-execution.md:41/:107) — that keeps it Medium, not High.
- **Undocumented implicit dependency (the coupling that drives Medium):** the operative pause behaviour at Step 2.1b is sourced from `research-prompt-qc/SKILL.md` line 165, not from the command line alone. The new classification section silently assumes the subagent will honour the mechanical-vs-judgment split — but the subagent reads the *skill*, which still says "pause on any Critical." Unless the skill is updated in lockstep (or explicitly pointed at the new section), the classification contract is honoured by the command narrative but not by the executing subagent. This is exactly the "silently relies on a downstream component returning/obeying a specific behaviour" coupling pattern.
- The mechanical-vs-judgment test itself introduces a soft classification boundary ("one correct answer, no editorial content") that the subagent must apply consistently; the conservative default (ambiguous → judgment → pause) is the correct guard and is named in the change, which contains the coupling rather than letting it auto-fire unsafely.

### Dimension 6: Principle Alignment
**Risk:** Low

- principles-base.md was readable (`projects/strategic-os/ai-strategy/principles-base.md`); checks applied against frozen IDs.
- **OP-5 (advisory vs enforcement) — aligned.** The change keeps the gate advisory-with-pause; it does not silently upgrade an advisory mechanism to auto-enforcement. It *relaxes* an over-strict pause for a provably mechanical case, with a conservative pause-by-default for ambiguity — the opposite of a silent enforcement creep.
- **OP-2 / AP-4 (automate execution, gate judgment / no rubber-stamps) — actively served.** The current rule pauses on *every* Critical, including a mechanical ID-strip with one correct answer — that is a rubber-stamp gate (AP-4) on routine execution. The split routes genuine judgment Criticals to the operator and auto-applies mechanical ones, which is precisely OP-2's "automate execution, gate judgment." Grounded in the F5 finding (post-project-review-2026-06-11.md:37, :75) and the standing `no-manual-tasks-during-execution` directive.
- **OP-9 / DR-7 / AP-7 (no speculative abstraction) — not triggered.** The new "Critical Finding Classification" section has zero current parsers beyond the reworded command, which could read as building a contract for an absent consumer — but the consumer is **confirmed and present** (Step 2.1b.9 itself, plus the documented F5 defect and the standing directive it resolves). This is a fix for a real, observed collision, not a Phase-2 hook.
- **OP-11 / OP-3 (loud revision, not silent drift) — satisfied.** The relaxation is recorded loudly: F5 in the post-project review (post-project-review-2026-06-11.md), the C5 plan entry (post-project-review-v2-plan-2026-06-11.md:53–55), and decisions.md:37. It is a recorded evolution, not drift.
- **DR-1 / DR-3 (placement) — correct.** Project-specific pipeline rule → project command + project reference doc. No tier or home misplacement *as scoped*. (Caveat: the lockstep skill fix, if taken, correctly lands in canonical `ai-resources/skills/` — also right placement.)

## Mitigations

- **Dimension 3 (Blast Radius) — required:** Update `ai-resources/skills/research-prompt-qc/SKILL.md` § Autonomy Rules (line 165) in lockstep, so the rule the qc-gate subagent actually executes carries the same mechanical-vs-judgment split (or explicitly defers to `quality-standards.md` § Critical Finding Classification). Editing only the command leaves the executing skill saying "pause on any Critical," which re-creates F5 inside the skill. Because this skill is canonical and multi-project (DR-1), treat the skill edit as its own change: route it through the proper skill-edit path, keep the project-tunable test in `quality-standards.md` and have the skill *reference* it rather than hard-code project specifics, and re-fire `/risk-check` if the skill edit widens scope beyond a one-rule reword.
- **Dimension 5 (Hidden Coupling) — recommended:** At Step 2.1b.9, make the reference to `quality-standards.md` § Critical Finding Classification explicit (named section, not an implicit "as classified"), and confirm the new section is reachable in the subagent's context at Step 2.1b — `quality-standards.md` is loaded at Step 2.1 (run-execution.md:41) but verify it is passed to the Step 2.1b qc-gate subagent (run-execution.md:55–56 lists the skill, prompts, specs, plan — not `quality-standards.md`); if it is not, the subagent cannot apply the classification. Either pass the section to the subagent or encode the test in the skill itself.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Concurrence:** Yes — concur with PROCEED-WITH-CAUTION. The project-local edit is low-risk in isolation. What holds it off GO is the **two-end contract** the change half-implements (risk-topology.md § 5 — behavioral mismatch across command and skill). That is the F5 collision, and it is the right reason.

**Routing:** Two tiers. `run-execution.md` + `quality-standards.md` are project-local — no propagation. `research-prompt-qc/SKILL.md` is canonical (`ai-resources/skills/`) — all-projects blast radius, its own `/risk-check` class (DR-8). Decomposition is correct.

**⚠ DISAGREES with the recommended path sequence.** The reviewer's ordering (project-local first, skill later) opens a silent-drift window. The subagent's *behavior* is governed by the skill, so a project-local-first landing runs the **old over-strict gate** while the project's docs claim the relaxed one — a direct OP-3 violation (silent two-end mismatch).
- **Right answer:** land both in lockstep in one session, **or** skill-first. The forbidden ordering is project-local-ahead-of-skill.
- **Defer entirely? No.** Bind them: if the skill edit can't run now, defer the project-local edit *with* it. "One without the other" is what is forbidden.

**Two risks the dimension review missed:**
1. **ai-resources concurrent state.** Confirm ai-resources is clean before the canonical skill edit lands — divergent-branch or unpushed commits risk a clobbered edit (DR-10).
2. **Subagent-context delivery (under-weighted).** If the qc-gate subagent receives the skill but not `quality-standards.md`, the new Critical Finding Classification section is **inert at runtime**. The classification must live where it executes. Verify which files the Step 2.1b dispatch block passes before landing.

_Full advisory: projects/axcion-ai-system-owner/output/consultations/consult-2026-06-11-c5-pause-critical-split.md_

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (run-execution.md:41/55/60/107, quality-standards.md:9/22, research-prompt-qc/SKILL.md:165, run-report.md:48, produce-architecture.md:5/84), grep-based consumer inventory across repo and workspace root, the `no-manual-tasks-during-execution` memory file, the F5 finding and C5 plan (post-project-review-2026-06-11.md:37/75, post-project-review-v2-plan-2026-06-11.md:53–55), decisions.md:37, and principle IDs from the readable principles-base.md. No training-data fallback was used.
