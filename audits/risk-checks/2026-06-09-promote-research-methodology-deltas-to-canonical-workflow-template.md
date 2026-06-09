# Risk Check — 2026-06-09

## Change

Promote a coherent group of research-methodology deltas from project research-pe-regime-shift-advisory-gap UP into the canonical research-workflow template (ai-resources/workflows/research-workflow/). All edits are additive/corrective to canonical methodology reference docs + one canonical skill; same change class (canonical research-workflow template/skill edit); same blast radius = every future research project that deploys or syncs from this template. Phase 1 manifest already produced and operator-approved (projects/research-pe-regime-shift-advisory-gap/audits/2026-06-09-workflow-promotion-manifest.md). The proposed canonical writes:

P1 (flagship) — ai-resources/workflows/research-workflow/reference/quality-standards.md § Source-Diversity Matrix: ADD the cross-class triangulation rule (two channels tracing to one underlying dataset/press-release/primary release collapse to ONE evidentiary role even across different source classes; operationalised by the existing `independence basis` field in research-extract-creator; a claim resting on ≥2 channels that collapse to one role downgrades to PROXY-SUPPORTED). Genericized: no PE/Europe specifics, keep existing {{...}} placeholders and claim-permission.md project-fillable pointers, soften the "Bain/Preqin" example to a generic "trade-body summary + specialist-press article restating the same underlying figure." Do NOT bring the project's "claim-permission.md not instantiated" residue notes.

P1-companion — ai-resources/skills/research-extract-creator/SKILL.md line ~117: update the consumption-status note that currently reads "landed in research-pe... 2026-06-08; not yet promoted to the canonical workflow template" to reflect that the cross-class collapse clause is now IN the canonical template. Without this, the canonical skill carries a now-false "not yet promoted" statement.

P2 — ai-resources/workflows/research-workflow/reference/stage-instructions.md line ~42: correct the stale deferred-items note. It currently lists 3 Pass-1 items as deferred; 2 of 3 have landed in canonical research-prompt-creator (verified: §S-02 No-Source-Substitution, §S-03 country ordering, §S-04 mandatory local-language pass). Update the note so only the session-level country-first structure remains listed as deferred. Genericize: strip the Nordic "Sweden→Norway→Finland" example, refer generically to the Project Config Languages: field ordering.

P3 — ai-resources/workflows/research-workflow/reference/known-limits.template.md: ADD a new OPTIONAL section "Known-Unavailable-Evidence Register" (Purpose + stable 5-column schema: Evidence need / Why unavailable / Public proxy / Limit ref / Last-checked + a Stop rule that governs search-effort not claim-grading). Strip all 9 PE-specific table rows, leave one {{...}} placeholder example row; strip project-internal IDs. Matches the template's existing optional-section convention.

P4 (optional, light enrichment) — ai-resources/workflows/research-workflow/reference/sops/fact-verification-prompt.md: the canonical is a bare {{FACT_VERIFICATION_SYSTEM_PROMPT}} stub; enrich it with the project's 2 domain-agnostic operating rules (positioning-vs-fact; don't-fact-check-interpretation) + the output format (Claim / Claim ID / Issue type / Why / Recommended correction / APPROVED) as guidance scaffolding, keeping the operator-fills-the-domain-prompt posture. Leave the domain/source-constraint-specific rules as operator-fill territory.

Per-file commit for reversibility. After GO, each file gets written then independently /qc-pass'd.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/quality-standards.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-extract-creator/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/stage-instructions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/known-limits.template.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/sops/fact-verification-prompt.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/audits/2026-06-09-workflow-promotion-manifest.md — exists

## Verdict

GO

**Summary:** Four additive/corrective edits to canonical research-workflow reference docs plus one truth-restoring skill-note update; every dependency the rules rest on is verified present, the changes are template-only (not retro-synced to deployed projects), each lands as an independently revertible per-file commit, and the one behavioral tightening surfaces only for NEW project deployments — no dimension exceeds Low, and the principle posture (closing a documented promotion, not building speculatively) actively serves OP-12/DR-7.

## Consumer Inventory

Inventory grep run across `ai-resources/` and the workspace root, restricted to functional consumers (skills, workflow commands, template docs) — audit and log hits excluded as non-functional. Search terms: `Source-Diversity Matrix`, `independence basis` / `same-underlying-dataset`, `known-limits`, `fact-verification-prompt` / `FACT_VERIFICATION_SYSTEM_PROMPT`, `stage-instructions`, plus the basis-field 4-value contract.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/skills/cluster-memo-refiner/SKILL.md | parses (§ Source-Diversity Matrix + independence basis → Check 9 permission grading) | no |
| ai-resources/skills/claim-permission-gate/SKILL.md | parses (§ Source-Diversity Matrix permission classes) | no |
| ai-resources/skills/research-extract-creator/SKILL.md | co-edits (P1-companion truth-update; produces the `independence basis` field P1 consumes) | yes (P1-companion) |
| ai-resources/skills/research-extract-creator/references/extract-template.md | documents (carries `independence basis` field shape) | no |
| ai-resources/workflows/research-workflow/.claude/commands/run-cluster.md | invokes (reads § Source-Diversity Matrix + known-limits at runtime) | no |
| ai-resources/workflows/research-workflow/.claude/commands/run-sufficiency.md | invokes (reads § Source-Diversity Matrix + known-limits) | no |
| ai-resources/workflows/research-workflow/.claude/commands/run-execution.md | invokes (reads known-limits) | no |
| ai-resources/workflows/research-workflow/reference/claim-permission.template.md | documents (§ Source-Diversity Matrix project-fillable pointer) | no |
| ai-resources/skills/research-prompt-creator/SKILL.md | parses (S-02/S-03/S-04 — the items P2's note reconciles against; reads known-limits) | no |
| ai-resources/skills/execution-manifest-creator/SKILL.md | documents/reads (known-limits) | no |
| ai-resources/workflows/research-workflow/docs/required-reference-files.md | documents (known-limits in deployment contract) | no |
| ai-resources/workflows/research-workflow/docs/project-config-schema.md | documents (known-limits + Languages: field referenced by P2 genericization) | no |
| ai-resources/workflows/research-workflow/SETUP.md | documents (fact-verification-prompt SETUP instantiation convention) | no |
| ai-resources/workflows/research-workflow/.claude/commands (verify-chapter path) | invokes (reads fact-verification-prompt Step 2) | no |
| projects/research-pe-regime-shift-advisory-gap/reference/quality-standards.md | (deployed instance — already carries cross-class clause; not retro-synced) | no |
| projects/buy-side-service-plan/reference/quality-standards.md | (deployed instance — same-class-only; not retro-synced) | no |
| archive/nordic-pe-macro-landscape-H1-2026/reference/quality-standards.md | (archived instance; inert) | no |

Total: 17 consumers, 1 must-change (research-extract-creator SKILL.md — the P1-companion truth-update, which is itself part of the proposed change, not a downstream breakage). The deployed-project `quality-standards.md` instances are listed because they are the blast-radius surface for the P1 tightening, but `/sync-workflow` does NOT flow `reference/` docs canonical→project (verified: it syncs only `.claude/{commands,agents,hooks}` — sync-workflow.md lines 36–45), so they are not retroactively affected.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file is touched. CLAUDE.md (workspace + repo + project) is untouched by all four edits — the targets are reference docs loaded only when the relevant stage runs ("When to read this file. When running QC checks..." — quality-standards.md line 9; "Only load these when actively working on the relevant stage" — project CLAUDE.md Workflow Overview).
- No hook, `@import`, or auto-load registration is added — none of the five edits introduce frontmatter or a SessionStart/Stop/PreToolUse trigger.
- P1/P2/P3/P4 add bounded content to per-stage reference docs already loaded on demand; the marginal token cost lands only inside the stage where that doc is already read, not per-session or per-turn.
- P3 and P4 sections are OPTIONAL by construction (P3 "ADD as an (optional) section"; P4 keeps the operator-fills posture) — projects that do not use them carry only the template lines, not an active cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings file is touched. No `allow`/`ask`/`deny` entry is added, removed, or narrowed by any of the five edits — all writes are to `.md` reference docs and one SKILL.md prose note.
- No new tool-invocation pattern (Bash command, Write path, external API, MCP) is introduced.
- No scope escalation (project→user) and no cross-repo write capability is added.

### Dimension 3: Blast Radius
**Risk:** Low

- Per the Step 1.5 inventory: 17 consumers, 1 must-change — and that single must-change (research-extract-creator SKILL.md, the P1-companion) is part of the proposed change set, not an unanticipated downstream breakage. Every other consumer stays compatible.
- The P1 rule extends, not breaks, an existing contract. The `independence basis` field and its 4 canonical values (`independently-observed` / `same-underlying-dataset` / `same-press-release` / `unclear`) already exist in canonical research-extract-creator SKILL.md (lines 104–111) — verified. P1's enforceability dependency, flagged by the manifest's pre-write verification, is satisfied; the rule does not invent a new field, it consumes one already shipped.
- The § Source-Diversity Matrix is project-fillable and carries an existing same-class triangulation rule ("Three independent reports from the same source class count as ONE evidentiary role" — quality-standards.md line 191). P1 is an additive extension of that same rule to the cross-class case; the six canonical-immutable structural section headings (line 7) are untouched, so the canonical-immutable boundary is not crossed.
- P2's reconciliation is verified, not asserted: S-02 (No-Source-Substitution), S-03 (country ordering), S-04 (mandatory local-language pass) all exist in canonical research-prompt-creator SKILL.md (lines 145, 150, 151). P2 is therefore not void; it corrects a now-false "still deferred" note (stage-instructions.md line 42 lists all three as deferred).
- Deployed projects are NOT retroactively affected: `/sync-workflow` syncs only `.claude/{commands,agents,hooks}`, never `reference/` docs (sync-workflow.md lines 36–45). The two active deployed instances (research-pe — already carries the clause; buy-side-service-plan — same-class-only) and the archived nordic instance keep their instantiated copies unchanged.
- No inventory consumer surfaced that the CHANGE_DESCRIPTION did not anticipate — the manifest's per-file diff already enumerated the same surface.

### Dimension 4: Reversibility
**Risk:** Low

- Per-file commit is explicitly the plan ("Per-file commit for reversibility... each file gets written then independently /qc-pass'd"), so each of the five edits is an independently `git revert`-able single-file diff within the working tree.
- No data/log mutation is among the five writes — no append to innovation-registry.md, improvement-log.md, or session-notes; the P1-companion is a prose-note correction inside SKILL.md, fully revertible.
- No state propagates beyond git: no push (push is gated to wrap), no external write, no Notion/API POST in the change set.
- No automation (hook/cron/symlink) is added that could fire between landing and a potential revert.
- One mild note (not a risk elevation): once P1 lands and the P1-companion flips the skill note to "now in canonical," a revert of P1 alone would re-introduce the contradiction the companion fixed — but per-file commits keep them paired and individually revertible, and the QC step catches an unpaired revert. This is a sequencing nicety, not a multi-step manual rollback.

### Dimension 5: Hidden Coupling
**Risk:** Low

- P1's rule depends on the `independence basis` field — but that dependency is explicit and documented at both ends: named in the rule itself, and defined in research-extract-creator SKILL.md lines 104–111 with the consuming relationship stated. Not a hidden coupling; it is a named, verified contract.
- P1-companion exists specifically to keep the cross-file contract honest — it removes the "not yet promoted" status (SKILL.md line 117) that would otherwise become silently false once P1 lands. The change closes a coupling gap rather than opening one.
- P3 follows the template's existing optional-section convention (known-limits.template.md already carries optional sections — § Asymmetric Blocking-Semantics Gap line 73, § Project-Side Drift Note line 81), so it introduces no new contract callers must honor; the 5-column schema is self-contained and the Stop rule explicitly governs search-effort not claim-grading (no overlap with the permission-class machinery).
- P4 keeps the `{{FACT_VERIFICATION_SYSTEM_PROMPT}}` operator-fill posture (fact-verification-prompt.md line 8) and adds guidance scaffolding only — no new auto-firing behavior, no silent state mutation, and the verify-chapter read contract (Step 2) is unchanged.
- No functional overlap with an existing mechanism: P1 extends the same § Source-Diversity Matrix rule (not a second, competing rule); P2 reconciles a note against skills that already own the behavior.

### Dimension 6: Principle Alignment
**Risk:** Low

- Principles-base read OK (`projects/strategic-os/ai-strategy/principles-base.md`). Checks applied: DR-7/AP-7/OP-9 (speculative abstraction), OP-12 (closure before detection), OP-5 (advisory vs enforcement), OP-11/OP-3 (loud revision), DR-1/DR-3 (placement).
- DR-7 / AP-7 / OP-9 (speculative abstraction) — NOT violated. The generalization is licensed by a confirmed consumer: the cross-class rule already runs in research-pe (quality-standards.md cross-class clause landed 2026-06-08) and the `independence basis` field it consumes is already canonical (SKILL.md lines 104–111). This is promotion of a working, used mechanism, not "hooks for Phase 2." The inventory shows a real current consumer, not zero.
- OP-12 (closure before detection) — actively SERVED. The change adds no new detection engine; P1 ties a downgrade (PROXY-SUPPORTED) to an existing gate (cluster-memo-refiner Check 9), i.e., a closing channel already exists. P1-companion and P2 close documented truth-drift (a now-false "not yet promoted" note; a stale deferred-list). This is consolidation/closure, which OP-12 counts in favor.
- OP-5 (advisory vs enforcement) — no silent upgrade. P1's downgrade rides the existing claim-permission gate semantics (quality-standards.md § Claim-Permission Classes, unchanged); P4 explicitly preserves the operator-fill/advisory posture. No advisory mechanism is converted to enforcement.
- DR-1 / DR-3 (placement) — correct tier. All targets are the canonical `ai-resources/workflows/research-workflow/` template and the canonical skill — the right home for shared research methodology; the change moves project-local methodology UP to canonical, the DR-1 direction of travel ("could this serve more than one project?").
- OP-11 — no principle is being revised, so the loud-revision obligation is not triggered. The one behavioral change (P1 tightens the source-diversity bar for NEW project deployments) is a methodology refinement within an existing rule, not a guardrail revision; it is recorded in the operator-approved manifest, so it is surfaced rather than silent.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references — quality-standards.md lines 7/9/191, research-extract-creator SKILL.md lines 104–111/117, research-prompt-creator SKILL.md lines 145/150/151, stage-instructions.md line 42, known-limits.template.md lines 73/81, fact-verification-prompt.md line 8, sync-workflow.md lines 36–45; grep counts for the consumer inventory; verbatim quotes from CHANGE_DESCRIPTION and the manifest). The principles-base was readable and cited by ID. No training-data fallback was used.
