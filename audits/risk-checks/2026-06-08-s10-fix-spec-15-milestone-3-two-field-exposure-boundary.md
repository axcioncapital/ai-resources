# Risk Check — 2026-06-08

## Change

Proposed change (fix-spec #15 Milestone 3): add a minimal additive boundary-assertion note to two canonical drafter skills — ai-resources/skills/section-directive-drafter/SKILL.md and ai-resources/skills/cluster-synthesis-drafter/SKILL.md. The note states that these late-stage non-extract artifacts (chapter directives, prose drafts) expose only two operational fields — source type + claim permission (the existing four-class field SUPPORTED/PROXY-SUPPORTED/ILLUSTRATIVE-ONLY/NOT-SUPPORTED) — and must NOT introduce or carry the upstream risk-tier (Tier A–D) or evidentiary-lens (independence-basis) axes, which remain only in Stage-2 extracts and Stage-3 sufficiency tables. Grep gate (design-note §6 Q3) already run and GREEN: neither skill currently exposes or parses tier/lens, so this is a defensive boundary assertion, NOT a field removal — no parser changes, no enforcer-parsed-region (the four canonical permission classes) touched, no new tool/consumer, fully backward-compatible. Routed via /improve-skill, each independently /qc-pass'd before commit. Context: design-note projects/research-pe-regime-shift-advisory-gap/audits/2026-06-08-design-note-17-15-risk-tiering-model.md §3.3 + §6 Q3.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/section-directive-drafter/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/cluster-synthesis-drafter/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/audits/2026-06-08-design-note-17-15-risk-tiering-model.md — exists

## Verdict

GO

**Summary:** A purely additive, backward-compatible prose note that hardens an already-true boundary (neither skill exposes tier/lens) without touching any parser, contract, permission, or consumer — every dimension is Low.

## Consumer Inventory

The change edits two skill bodies. It introduces **no new contract** — it asserts that two axes (tier/lens) must stay absent from these artifacts, and those axes are already absent (verified GREEN below). So the inventory covers (a) components that *invoke* these skills and could be affected if the skill body changed behaviour, and (b) the contract the skills already share — the four permission classes — to confirm the change does not perturb it.

Invoking consumers were identified by grep across `ai-resources/` and the workspace root (`..`). The two skills are referenced by 80+ files combined, but the overwhelming majority are documents — repo snapshots, audits, archives, catalogs, session logs — that *name* the skill, not parse its output. The functional invokers are the workflow commands and the pipeline-sibling skills.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/workflows/research-workflow/.claude/commands/produce-architecture.md | invokes (section-directive-drafter) | no |
| ai-resources/workflows/research-workflow/.claude/commands/run-analysis.md | invokes (section-directive-drafter) | no |
| ai-resources/workflows/research-workflow/.claude/commands/run-synthesis.md | invokes (cluster-synthesis-drafter) | no |
| projects/research-pe-regime-shift-advisory-gap/.claude/commands/produce-architecture.md | invokes (section-directive-drafter) | no |
| projects/research-pe-regime-shift-advisory-gap/.claude/commands/run-analysis.md | invokes (section-directive-drafter) | no |
| projects/research-pe-regime-shift-advisory-gap/.claude/commands/run-synthesis.md | invokes (cluster-synthesis-drafter) | no |
| projects/buy-side-service-plan/.claude/commands/run-analysis.md | invokes (section-directive-drafter) | no |
| projects/buy-side-service-plan/.claude/commands/run-synthesis.md | invokes (cluster-synthesis-drafter) | no |
| ai-resources/skills/section-directive-drafter/SKILL.md (Permission-Class Constraints, lines 195–208) | parses (the four permission classes — shared contract) | no |
| ai-resources/skills/claim-permission-gate/SKILL.md | documents (cluster-synthesis-drafter in pipeline) | no |
| ai-resources/skills/country-parity-checker/SKILL.md | documents | no |
| ai-resources/skills/research-structure-creator/SKILL.md | documents | no |
| ai-resources/skills/editorial-recommendations-generator/SKILL.md | documents | no |
| ai-resources/skills/CATALOG.md | documents | no |
| ai-resources/workflows/research-workflow/reference/stage-instructions.md | documents | no |
| (40+ further files: repo-snapshots, audits, archives, session logs, checkpoints) | documents | no |

Total: ~55 distinct consumers, **0 must-change**. The functional set (8 invoking commands + pipeline-sibling skills) is unaffected because the change adds non-behavioural boundary prose, not a new field or parse marker. No consumer parses tier/lens from these two skills (verified: grep for tier/lens in both skill bodies returns empty — see Dimension 5). The grep also surfaced no *unanticipated* consumer that the CHANGE_DESCRIPTION missed; the consumer set matches the "no parser changes, no new consumer" claim.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The change adds a short prose note to two SKILL.md bodies — both are pay-as-used skills loaded only when the relevant pipeline stage runs, not always-loaded files. `section-directive-drafter` is `model: opus`/`effort: high` (line 17–18); `cluster-synthesis-drafter` is `model: sonnet`/`effort: medium` (line 14–15). Neither is auto-loaded per session or per tool call.
- No hook (SessionStart/Stop/PreToolUse/UserPromptSubmit) is registered; no `@import` into an always-loaded CLAUDE.md; no skill description/trigger-keyword change (the change is in the body, not frontmatter `description:`). Evidence: CHANGE_DESCRIPTION — "no parser changes … no new tool/consumer."
- Marginal token cost is a few sentences per skill, incurred only when that skill is invoked. Below the ~50-token always-loaded threshold and not always-loaded regardless.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings file is touched. The change edits two SKILL.md prose bodies only. No `allow`/`ask`/`deny` entry added, removed, or narrowed; no new Bash/Write/external-API pattern introduced; no scope escalation. Evidence: REFERENCED_FILE_PATHS contains only two SKILL.md files plus a read-only design-note; no `settings.json` in scope.

### Dimension 3: Blast Radius
**Risk:** Low

- Per the Step 1.5 inventory: ~55 distinct consumers, **0 must-change**. The functional invokers (8 commands + a few pipeline-sibling skills) consume the skills' *outputs*, and the change does not alter output shape — it asserts an existing absence.
- No contract change. The shared contract these skills touch is the four permission classes (the enforcer-parsed region). Grep confirms `section-directive-drafter` carries the four class names 8× (lines 199–208, the Permission-Class Constraints table) and `cluster-synthesis-drafter` carries them 0× — the change leaves all of these byte-identical (it adds a *boundary note about tier/lens*, a different axis). Evidence: `grep -cE "SUPPORTED|PROXY-SUPPORTED|ILLUSTRATIVE-ONLY|NOT-SUPPORTED"` → 8 and 0.
- No shared infrastructure (logs, hooks, always-loaded CLAUDE.md) is touched. The two edits are independent (one skill each), each independently `/qc-pass`'d per CHANGE_DESCRIPTION.
- The grep surfaced no consumer that the CHANGE_DESCRIPTION did not anticipate; the "no new consumer, fully backward-compatible" claim holds against the inventory.

### Dimension 4: Reversibility
**Risk:** Low

- Two single-file prose edits. `git revert` (or a follow-up edit removing the note) fully restores prior state within the working tree. No sibling files or directories created; no data/log/registry mutation; no settings change requiring manual cleanup; no state pushed beyond the local repo at change time (push is separately gated at `/wrap-session`); no automation (hook/cron/symlink) added that could fire between landing and revert. Evidence: REFERENCED_FILE_PATHS — two SKILL.md files only.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The grep gate claim (design-note §6 Q3) is independently verified GREEN: `grep -niE "risk.tier|tier a|independence.basis|evidentiary.lens"` against both skill bodies returns **empty** — neither skill currently exposes or parses the tier or lens axes. The change therefore documents an existing boundary rather than removing a live field, so no downstream parser can break.
- No new contract is introduced. The note is a prohibition ("must NOT carry tier/lens"), not a parse marker, filename convention, or output-format key that callers must honour. It is documented at the change site (inside the two SKILL.md files), which is the correct home.
- No silent auto-firing, no cross-session side effect, no functional overlap with an existing mechanism — the tier/lens axes' real home (Stage-2 extracts, Stage-3 sufficiency tables) is asserted by the design-note (§2 table, §3.3) and is unchanged. The change reinforces the design-note's explicit anti-axis-confusion rule (§2: "never merged and never substituted") rather than competing with it.

### Dimension 6: Principle Alignment
**Risk:** Low

- principles-base read at `projects/strategic-os/ai-strategy/principles-base.md` (lines 27–63, 82–106).
- **OP-12 (closure before detection) — actively served.** The change adds **no new detection** (no scan, audit, flag, or finding-generator). It *closes* an open design question — design-note §6 Q3, "deferred to Milestone 3" — by hardening the field-exposure boundary. This is consolidation, which OP-12 counts *for* a change, not against it.
- **OP-5 (advisory vs enforcement) — respected.** The note is an advisory boundary assertion in prose; it does not add an enforcer, auto-correct, or move an advisory mechanism toward enforcement. The enforcer-parsed region (the four permission classes) is explicitly untouched (Dimension 3). No silent enforcement upgrade.
- **OP-9 / AP-7 / DR-7 (speculative abstraction) — not triggered.** The change does not generalize or build for an absent consumer; it *narrows* what two existing artifacts may carry. It introduces a contract with zero new consumers, but the contract is a *prohibition that reduces surface*, the opposite of speculative abstraction — there is nothing to "build for later" here.
- **DR-1 / DR-3 (placement) — correct.** The boundary rule lives inside the two SKILL.md files it governs (skill methodology belongs in SKILL.md per workspace CLAUDE.md § CLAUDE.md Scoping), and these are canonical `ai-resources/skills/` — the right tier.
- **OP-10 (system boundary), OP-2 (gate judgment), OP-11 (loud revision) — not engaged.** No cross-tool reach; no judgment automated; no principle revised (so no loud-revision obligation arises).

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION and the referenced skills/design-note, and principle IDs read from principles-base). No training-data fallback was used on any read; no dimension was marked INCOMPLETE.
