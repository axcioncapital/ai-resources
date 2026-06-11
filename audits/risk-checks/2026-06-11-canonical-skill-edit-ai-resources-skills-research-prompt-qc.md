# Risk Check — 2026-06-11

## Change

Canonical skill edit — ai-resources/skills/research-prompt-qc/SKILL.md § Autonomy Rules (line 165): split the rule "REVISE verdict with any Critical findings: Pause for operator review" into a mechanical-vs-judgment pair: (a) mechanical Critical — the finding has exactly one correct fix and requires no editorial or scope judgment (e.g., a forbidden-terminology strip, a missing literal scope line with known content) → apply the fix automatically and re-run QC, one iteration, pausing only if still FLAG; (b) judgment Critical — the finding requires an editorial, scope, or content decision → pause for operator review. Conservative default: if classification is ambiguous, treat as judgment → pause. Wording stays generic (no project-specific terms). This is the lockstep companion to the already-risk-checked project-local C5 edit (run-execution.md Step 2.1b.9 + quality-standards.md Critical Finding Classification section, prior verdict PROCEED-WITH-CAUTION, report ai-resources/audits/risk-checks/2026-06-11-c5-split-pause-on-critical-rule-in-run-execution-md-step-2.md). The skill is canonical and multi-project (read by qc-gate subagents at run-execution Step 2.1b in every project deploying the research workflow). The project-local edits land in the same session immediately after this skill edit (skill-first ordering per SO advisory consult-2026-06-11-c5-pause-critical-split.md).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-prompt-qc/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/positioning-research/.claude/commands/run-execution.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/positioning-research/reference/quality-standards.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-06-11-c5-split-pause-on-critical-rule-in-run-execution-md-step-2.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/output/consultations/consult-2026-06-11-c5-pause-critical-split.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A small, low-cost, cleanly-reversible reword of one canonical skill rule that is the structurally-correct lockstep target the prior C5 risk-check explicitly required — but because the skill is multi-project, the relaxed behaviour propagates to three *other* deploying projects whose Step 2.1b commands still say "pause on any Critical," recreating the very two-end mismatch this edit closes for positioning-research, in those projects, with the polarity reversed (skill now auto-applies while their command says pause).

## Consumer Inventory

Search terms: `research-prompt-qc`, the skill basename `SKILL.md` at that path, the verbatim rule `REVISE verdict with any Critical findings`, the Step 2.1b dispatch token, and `Critical Finding Classification`. Searched `ai-resources/skills/`, `ai-resources/.claude/commands/`, `ai-resources/workflows/`, all `projects/*/.claude/commands/`, `ai-resources/skills/CATALOG.md`, and the workspace root one level up, across repo and workspace.

The change edits the skill's **§ Autonomy Rules** runtime behaviour (the rule the qc-gate subagent executes at Step 2.1b). Consumers are scored against *that behaviour*, not against every file that merely names the skill. The skill is invoked by `run-execution.md` Step 2.1b in **every deploying project** (verified: `run-execution.md:55` in positioning-research loads `/ai-resources/skills/research-prompt-qc/SKILL.md`; identical line in the canonical workflow template and in two other live projects). Audit reports, token tables, repo-health "missing trigger keyword" lists, and archive copies merely `document` the skill name and do not parse its Autonomy Rules — excluded from must-change.

| Consumer path | Reference type | Must change? |
|---|---|---|
| projects/positioning-research/.claude/commands/run-execution.md (Step 2.1b.9, line 60) | invokes / co-edits — loads the skill at line 55; its line-60 pause rule mirrors the skill rule; this is the lockstep companion landing the same session | yes (the paired C5 edit) |
| projects/positioning-research/reference/quality-standards.md | co-edits — receives the Critical Finding Classification section the skill should reference | yes (the paired C5 edit) |
| ai-resources/workflows/research-workflow/.claude/commands/run-execution.md (Step 2.1b.9, line 60) | invokes / parses — canonical workflow template; loads the same skill (line 55); still says "If REVISE with any Critical findings: pause for operator review before proceeding" | yes — to stay consistent with the relaxed skill (else template ships a contradiction to every future deployment) |
| ai-resources/workflows/research-workflow/reference/stage-instructions.md (line 36) | parses / documents — describes Step 2.1b autonomy as "If Critical findings ... pause for operator"; unsplit | yes — template-level mirror of the same rule |
| projects/research-pe-regime-shift-advisory-gap/.claude/commands/run-execution.md (line 60) | invokes — live project, loads the same skill; command still says "pause on any Critical" (verified) | no, but NOW MISMATCHED — see Blast Radius |
| projects/buy-side-service-plan/.claude/commands/run-execution.md (line 56) | invokes — live project, loads the same skill; command still says "pause on any Critical" (verified) | no, but NOW MISMATCHED — see Blast Radius |
| ai-resources/skills/CATALOG.md (line 19) | documents — one-line catalog entry, no behaviour parse | no |
| ai-resources/skills/workflow-system-analyzer/SKILL.md (line 260) | documents — names the skill in a workflow inventory table | no |
| ~30 audit/report/archive files (repo-due-diligence, repo-health, token-audit, log-sweep, workflow-analysis) | documents — name the skill in inventories; do not parse Autonomy Rules | no |

Total: 8 functionally-relevant consumers, **2 must-change as the paired C5 edit** (positioning-research command + reference doc), **2 should-change for template consistency** (canonical workflow `run-execution.md` + `stage-instructions.md`), and **2 live projects (`research-pe-regime-shift-advisory-gap`, `buy-side-service-plan`) that the skill edit silently changes the behaviour of without touching their command text.** The remaining consumers `document` only. No `not yet present` files are involved — the skill exists.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The skill is read on demand by the Step 2.1b qc-gate subagent, not auto-loaded — `run-execution.md:55` reads it only when `/run-execution` runs Step 2.1b. It is not in any always-loaded CLAUDE.md, registers no hook, and adds no `@import`.
- The edit replaces one rule line (SKILL.md:165) with a two-branch rule of a few sentences; current file length ~177 lines (log-sweep-ai-resources-2026-05-22.md:421). The token delta is marginal and pay-as-used (only when the QC subagent is spawned).
- The subagent (`model: sonnet`, SKILL.md:11) is spawned once per section's Step 2.1b, not per turn or per tool call — no frequent-spawn cost concern.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings file, `allow`/`ask`/`deny` rule, tool-invocation pattern, or external/cross-repo capability is touched. The change is markdown content inside one SKILL.md.
- The change widens *workflow autonomy* (auto-apply on mechanical Critical) but that is a process posture inside an already-permitted edit surface (the subagent already applies fixes for Moderate findings, SKILL.md:164), not a tool-permission grant. It is gated by the conservative "ambiguous → judgment → pause" default (CHANGE_DESCRIPTION).

### Dimension 3: Blast Radius
**Risk:** High

- Grounded in the Consumer Inventory. The skill is canonical and multi-project: `run-execution.md:55` loads it in positioning-research, in the canonical workflow template, and in at least two other live projects (`research-pe-regime-shift-advisory-gap/.claude/commands/run-execution.md`, `buy-side-service-plan/.claude/commands/run-execution.md` — both verified to still carry "If REVISE with any Critical findings: pause for operator review" at lines 60 and 56). Editing the skill changes the qc-gate subagent's behaviour for **every deploying project at once** (DR-1: shared canonical resource, "all projects invoking it" blast radius).
- **The driving finding (inverted-polarity mismatch in non-target projects):** the prior C5 risk-check (this report's sibling) correctly identified that editing the *command* while leaving the *skill* unsplit recreates the F5 collision inside the skill. This change is the fix for positioning-research. But for the two other live projects, the polarity reverses: the skill will now say "auto-apply mechanical Critical" while their Step 2.1b.9 command text still says "pause on any Critical." Those projects get the relaxed subagent behaviour without having opted into it and without a matching command line — a two-end mismatch identical in kind to the one C5 closes, now opened in three other places (the two live projects plus the canonical template that seeds all future deployments).
- **Template-seed finding:** `ai-resources/workflows/research-workflow/.claude/commands/run-execution.md:60` and `reference/stage-instructions.md:36` both carry the unsplit "pause on any Critical" rule. Every future project scaffolded from the template will inherit the contradiction unless the template is updated in the same pass.
- Counter-weight (why this is not catastrophic): the change is behaviourally *safe in the conservative direction* — the worst case in a non-updated project is that a mechanical Critical now auto-applies-and-re-QCs instead of pausing, which is the intended improvement, not a regression of output quality; and the conservative default keeps genuine judgment Criticals pausing. The risk is **governance/consistency drift across projects**, not a correctness break in any single run. But per DR-8 a canonical multi-project edit is its own gated change class, and the cross-project mismatch has no in-this-change technical fix — it requires either propagating the split to the template + live projects, or explicitly accepting the skill-leads-command posture. Hence High, with a paired mitigation.

### Dimension 4: Reversibility
**Risk:** Low

- The edit is an in-place content change to one version-controlled file (SKILL.md:165). A single `git revert` (or re-edit) fully restores the prior rule — no sibling files created, no data/log/registry mutated, no settings cached state, no symlink or hook registered.
- No state propagates beyond git: no push (push is gated to wrap), no external write, no Notion/API call. The skill is read fresh on each Step 2.1b invocation, so a revert takes effect on the next run with no stale cache.
- Caveat (minor): if the skill edit lands and the paired project-local + template edits also land, a clean rollback means reverting all of them together; reverting the skill alone would leave positioning-research's command/reference describing a split the skill no longer honours. This is a "revert the set together" note, not a multi-step manual cleanup — still Low.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The change creates a **cross-tier behavioural contract** between the canonical skill and project-local files. CHANGE_DESCRIPTION states wording "stays generic (no project-specific terms)" — good, the skill does not hard-code positioning-research's `quality-standards.md` § Critical Finding Classification. But that means the skill must carry the mechanical-vs-judgment *test* self-contained, OR reference a section that the subagent actually receives in context.
- **Unclosed subagent-context dependency (carried forward from the SO advisory, consult-2026-06-11-c5-pause-critical-split.md § 5):** the Step 2.1b dispatch (run-execution.md:56) passes the qc-gate subagent the skill content, the prompts, the Answer Specs, and the Research Plan — it does **not** list `quality-standards.md`. So if the classification logic lives only in `quality-standards.md` and the skill merely points at it, the subagent never reads the classification at runtime and the split is inert. The mitigation is that the skill itself must carry the generic mechanical-vs-judgment test (which CHANGE_DESCRIPTION says it will — "the finding has exactly one correct fix ... e.g., a forbidden-terminology strip"). Verify the skill is self-contained on this point before landing. This keeps the coupling Medium (one documented contract that must be honoured at the executing site), not High.
- The mechanical-vs-judgment boundary is a soft classification the Sonnet subagent must apply consistently; the conservative "ambiguous → judgment → pause" default is the correct guard and is named in the change, containing the coupling rather than letting it auto-fire unsafely. The skill's existing Integrity Rules ("Do not soften FLAG to PASS to avoid rework," SKILL.md:174) remain compatible.

### Dimension 6: Principle Alignment
**Risk:** Low

- principles-base.md was readable (`projects/strategic-os/ai-strategy/principles-base.md`); checks applied against frozen IDs.
- **OP-2 / AP-4 (automate execution, gate judgment / no rubber-stamps) — actively served.** The current rule pauses on *every* Critical including a mechanical forbidden-terminology strip with one correct fix — a rubber-stamp gate (AP-4) on routine execution. The split routes genuine judgment Criticals to the operator and auto-applies mechanical ones — precisely OP-2. This is the principal reason the change is *right*.
- **OP-5 (advisory vs enforcement) — aligned.** The gate stays advisory-with-pause for judgment; it does not silently upgrade an advisory mechanism to auto-enforcement of editorial decisions. It relaxes an over-strict pause for a provably mechanical case.
- **OP-9 / DR-7 / AP-7 (no speculative abstraction) — not triggered.** The consumer is confirmed and present: the F5 collision, the standing `no-manual-tasks-during-execution` directive, and Step 2.1b itself. Not a Phase-2 hook.
- **OP-11 / OP-3 (loud revision, not silent drift) — the principle that constrains this edit.** The relaxation is recorded loudly (prior C5 risk-check, SO advisory, F5/C5 plan trail). For *positioning-research* this is a recorded evolution, not drift. **But** the cross-project propagation (Dimension 3) means the skill's behaviour changes for `research-pe-regime-shift-advisory-gap` and `buy-side-service-plan` and all future template deployments *without a matching loud record in those projects*. That is the OP-3/OP-11 edge: the revision is loud *here* and silent *there*. It does not rise to a Dimension-6 High because the cross-project effect is a blast-radius/consistency problem with a technical mitigation (propagate or explicitly accept), not an unacknowledged principle revision — but it is the reason the OP-11 obligation extends to the other projects, not just this one. Flagged for the mitigation.
- **DR-1 / DR-3 / DR-8 (placement + gating) — correct and observed.** Canonical skill rule → canonical `ai-resources/skills/` home (right placement). DR-8 names canonical-skill edits as a gated `/risk-check` class — this review IS that gate, fired correctly.

## Mitigations

- **Dimension 3 (Blast Radius) — required:** Do not land the canonical skill split in isolation. In the same pass, propagate the split to the two template-seed files that mirror the rule — `ai-resources/workflows/research-workflow/.claude/commands/run-execution.md:60` and `reference/stage-instructions.md:36` — so future deployments inherit the consistent rule, AND make an explicit, recorded decision about the two live non-target projects (`research-pe-regime-shift-advisory-gap`, `buy-side-service-plan`): either (a) update their Step 2.1b.9 command line to match the relaxed skill in the same session, or (b) record (decisions log / friction log) that the skill-leads-command posture is accepted for them as an interim state with a tracked follow-up, since the behavioural change is conservative-direction-only and does not regress output quality. Do not leave the mismatch unrecorded (OP-11).
- **Dimension 5 (Hidden Coupling) — required (verify before landing):** Confirm the edited skill carries the mechanical-vs-judgment test *self-contained* (generic wording, no dependency on `quality-standards.md` being in the subagent's context), because the Step 2.1b dispatch (run-execution.md:56) does not pass `quality-standards.md` to the qc-gate subagent. If the skill instead defers to a project reference doc, either add that doc to the Step 2.1b subagent's context or move the test into the skill — otherwise the split is inert at runtime.
- **Ordering / concurrency (advisory, from SO consult § 5):** Land skill-first (per CHANGE_DESCRIPTION and the SO advisory), then the project-local C5 edits in the same session. Confirm `ai-resources` is in a clean state before the canonical edit — `git status` shows `main...origin/main [ahead 4]` with `.claude/settings.json`, `logs/session-notes.md`, and a template file already modified; that is a local-ahead working tree, not a divergence from origin, so the edit is safe, but avoid directory-wildcard `git add` if a concurrent session is disclosed (DR-10).

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (SKILL.md:11/55-context/164/165/174; positioning-research run-execution.md:55/56/60; workflow-template run-execution.md:55/60 and stage-instructions.md:36; research-pe-regime-shift-advisory-gap run-execution.md:60; buy-side-service-plan run-execution.md:56; CATALOG.md:19; workflow-system-analyzer SKILL.md:260; log-sweep-ai-resources-2026-05-22.md:421), grep-based consumer inventory across repo and workspace root, verified `ai-resources` git state, the prior C5 risk-check and SO advisory (both read in full), and principle IDs from the readable principles-base.md. No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Concurrence:** We concur with PROCEED-WITH-CAUTION. The verdict is correctly calibrated and names the right load-bearing tension. Dimension-3 "High" blast radius is the correct headline — and skills are read *by reference at runtime*, so propagation is even more immediate than the auto-sync symlink path (`risk-topology.md § 3`; `system-doc.md § 4.4`). Do not downgrade the verdict (`principles.md § DR-8`).

**The dominant risk:** the polarity-reversed two-end mismatch is binding, not a footnote. Post-edit, the skill auto-applies mechanical Criticals while three non-target projects' Step 2.1b commands still say "pause on any Critical" — a fresh behavioural contract break (`risk-topology.md § 5`) that silently relaxes an operator gate those projects never opted into (`OP-5`, `AP-1`).

**Recommended path — concur, treat all three mitigations as required:**
1. Propagate to the canonical template (`run-execution.md:60` + `stage-instructions.md:36`) — required, or new deployments re-create the mismatch (`DR-1`). For the two live non-target projects: explicit binary choice (`OP-3`) — update in-session (preferred) or record a skill-leads-command interim posture naming the conservative-default bound.
2. Verify the mechanical-vs-judgment test is **self-contained in the skill body** — a context-isolated subagent only sees what's handed to it; if Step 2.1b doesn't pass `quality-standards.md`, an un-passed discriminator is an instruction failure (`QS-1`, `AP-9`).
3. Land skill-first, per-file staging — and enumerate the file explicitly if a concurrent `ai-resources` session is live (`DR-10`; `repo-state.md § 4`).

**Risk the dimension review missed:** the new "mechanical Critical → auto-apply + re-QC, one iteration" path must be reconciled with the existing QC→Triage **two-pass cap** (`QS-2`). Confirm the one-iteration re-QC does not stack past the structural-escalation ceiling, and that a mechanical fix re-QC'ing dirty routes to judgment/pause rather than getting a fresh iteration budget. Secondary: Dimension-6 "Low" is load-bearing on the conservative default (ambiguous → pause) surviving QC — flag it as conditional, not unconditional.

**Position:** Proceed, with all three mitigations required and the QS-2 reconciliation added to the verification checklist. The gate this advisory holds: the mismatch closed for positioning-research must not be silently re-opened, polarity-reversed, in three other projects.

_Full advisory: projects/axcion-ai-system-owner/output/consultations/consult-2026-06-11-c5-canonical-skill-edit-second-opinion.md_
