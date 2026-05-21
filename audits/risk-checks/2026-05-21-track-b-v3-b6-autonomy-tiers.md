# Risk Check — 2026-05-21

## Change

Track B v3 amendment B6 — per-unit autonomy tiers A/B/C/D. Proposed structural change: each work unit in a harness workflow config carries an autonomy tier — A (fully autonomous), B (autonomous with logged assumptions), C (operator checkpoint), D (defer). The governor's Phase A execution planning becomes tier-aware and weights unit selection toward A and B. The change is specified in `project-plan-v3.md` (the Workflow Config Interface section + Phase 3 governor) THIS session — v3 is a plan document. The structural risk: this edits the **workflow config interface**, which the context pack (`inputs/01-context-pack-v7.md` §The Workflow Config Interface) names a load-bearing feed-forward artifact — "a mis-shaped config blocks every downstream test"; every testable harness phase (governor, verification, failure detector, reporter) consumes the workflow config. The actual edits are DEFERRED to a follow-on Track B phase 2 and consist of: (1) the workflow config interface spec in v3 gains a per-unit `tier` field; (2) `harness/test-workflows/minimal-markdown/workflow-config.yaml` gains `tier` values for its 3 work units. Constraint to respect (carried from the diagnosis): tiers must REFERENCE the existing workspace Autonomy Rules (`ai-resources/docs/autonomy-rules.md` + workspace CLAUDE.md Autonomy Rules) — they must NOT introduce a new `autonomy-policy.md` or a second autonomy-policy surface. Note: the harness is currently at Phase 2 complete; the governor (Phase 3) that would consume the `tier` field is NOT yet built — so the config-interface change lands before its consumer exists. This is a plan-time risk gate per the implementation plan §7.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/test-workflows/minimal-markdown/workflow-config.yaml — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/Project Plans/agent-harness/inputs/01-context-pack-v7.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/Project Plans/agent-harness/project-plan-v3.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/autonomy-rules.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A backwards-compatible additive field on a load-bearing feed-forward interface, landed plan-time before its consumer is built — low cost and clean revert, but the blast radius across downstream harness phases plus the new `tier` parse contract require explicit mitigations before the deferred phase-2 edits land.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The change touches a project-internal plan document (`project-plan-v3.md`) and a harness test-fixture YAML — neither is an always-loaded file. Workspace `CLAUDE.md` and `ai-resources/CLAUDE.md` are not edited by this change; verified by reading both — no harness `tier` content present in either.
- No hook is registered. The change description names governor Phase A execution planning as the consumer, and the governor is a skill-driven state machine, not a hook chain — plan v3 line 43: "the governor is a skill-driven state machine with filesystem-persisted state, not a hook chain."
- No `@import` is added to an always-loaded file. The workflow config is read at harness runtime by the governor skill when a harness session runs, not on every turn of every session.
- The `tier` field adds a few tokens per work unit to a config the governor already loads — `inputs/01-context-pack-v7.md` line 800: "Governor iterates through work_units." This is pay-as-used: cost is incurred only when a harness session runs, and the config is already being read in full.
- C1 explicitly forbids a new always-loaded policy doc — plan v3 line 46: "No `autonomy-policy.md` ... it must not create a second policy file." Honoring C1 keeps usage cost Low; violating it would add a standing doc surface.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `.claude/settings.json` or `.claude/settings.local.json` file is referenced or edited by this change. No `allow`, `ask`, or `deny` entry is added, removed, or narrowed.
- No new tool invocation pattern is introduced — the change adds a YAML field and plan-document prose; it does not add a Bash command family, a Write path, or an external API call.
- The word "autonomy" here is a harness-internal work-unit scheduling tier (A/B/C/D), not a Claude Code permission grant. Tier A "fully autonomous" governs whether the governor pauses for an operator checkpoint on a work unit — it does not widen what tools the agent may call. C1 reinforces this separation: tiers "reference the existing workspace Autonomy Rules," they do not redefine them (plan v3 line 46).

### Dimension 3: Blast Radius
**Risk:** Medium

- Enumeration — files directly touched by the described change: 2. (1) `project-plan-v3.md` Workflow Config Interface section + Phase 3 governor spec; (2) `harness/test-workflows/minimal-markdown/workflow-config.yaml` (3 work units gain `tier`). Note: the actual edits are DEFERRED to Track B phase 2 — this risk-check evaluates described intent; only the plan-document spec edits land THIS session.
- Downstream consumers of the workflow config interface — grep `grep -rln "workflow-config\|workflow config"` across `harness/`: `harness/schemas/learnings-schema.md`, `current-state-schema.md`, `operator-corrections-schema.md`, `hardening-registry-schema.md`, `mandate-history-schema.md`, plus the test-workflow fixture and two spec-files (`unit-2.md`, `unit-3.md`). Plus the reports directory.
- The context pack names the consumer set explicitly — `inputs/01-context-pack-v7.md` line 800: "Mandate parser loads and validates it ... Governor iterates through work_units ... Verification layer uses `exit_criteria` and `outputs` ... Failure mode detector classifies ... Reporter references work_units." Five distinct harness components consume the config. This exceeds the >5-caller High threshold borderline, but see the contract note below.
- The interface is explicitly flagged load-bearing — `inputs/01-context-pack-v7.md` line 537: "Every testable phase uses the test workflow config. A mis-shaped config blocks every downstream test. This is a load-bearing artifact — get it right in Phase 1 or every later phase will limp."
- The change is backwards-compatible by the interface's own evolution rule — `inputs/01-context-pack-v7.md` line 804: "The config schema should evolve without breaking existing configs — add fields with defaults, don't remove fields without deprecation." `tier` is a pure addition; no existing field is removed or reshaped. Existing consumers that do not read `tier` (mandate parser validation, verification layer, failure detector, reporter) continue to parse the config unchanged — they simply ignore the new key.
- Only one consumer requires modification to act on the new field: the governor's Phase A planning (described as becoming "tier-aware"). The governor (Phase 3) is NOT yet built — harness is at Phase 2 complete. So the modification lands in net-new Phase 3 code, not as a retrofit of shipped code. No currently-built component requires modification to keep working.
- Net assessment: 5 nominal consumers, but the contract change is additive and backwards-compatible, and zero built callers need modification — this lands at Medium (a backwards-compatible contract change on a load-bearing artifact with multiple downstream readers), not High.

### Dimension 4: Reversibility
**Risk:** Low

- The plan-document edit (`project-plan-v3.md`) is a single-file edit in a tracked repo — `git revert` of the commit fully restores the prior plan text. v3 is a versioned plan document; the workspace convention is to create new version files rather than overwrite (workspace `CLAUDE.md` § Working Principles), and v2 is retained, so even a non-git rollback path exists.
- The fixture edit (`workflow-config.yaml`) is a single-file additive change — reverting deletes the three `tier:` lines and restores the file verbatim. No sibling files or directories are created by the change as described.
- No log or append-only data file is mutated — the change does not touch `innovation-registry.md`, `improvement-log.md`, session notes, or any archive. Plan-document and fixture edits are not append-only mutations.
- No `settings.json` change, so no cached permission state to clean up.
- No state propagates beyond the local repo — no `git push`, no Notion write, no external API call is part of the described change. (Push remains a separate operator-gated step under Autonomy Rule #2; that gate is unaffected.)
- No automation is added that could fire between landing and revert — no hook, cron, or symlink. The governor that would consume `tier` does not exist yet, so there is no live consumer that could act on the field before a revert.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- New parse contract: the `tier` field is a new key that the governor's Phase A planner must read and that fixture authors must populate. The change introduces an A/B/C/D enumeration whose semantics (A = fully autonomous, B = autonomous with logged assumptions, C = operator checkpoint, D = defer) callers must honor. This is a Medium-level coupling: one new contract — acceptable if it is documented at the change site (the Workflow Config Interface section of v3 and the fixture), which the change description states it will be ("the workflow config interface spec in v3 gains a per-unit `tier` field").
- Cross-document semantic dependency on the workspace Autonomy Rules: C1 mandates that tiers "REFERENCE the existing workspace Autonomy Rules" rather than restate them (plan v3 line 46; `ai-resources/docs/autonomy-rules.md` enumerates the 10 pause-triggers). This is a deliberate coupling — but it is also a latent drift risk: if `autonomy-rules.md` changes its posture, a `tier` enumeration that paraphrases rather than points at it would silently fall out of sync. The constraint exists precisely to bound this; honoring it as a pointer (not a paraphrase) keeps the coupling Medium rather than High.
- Consumer-before-producer ordering: the config-interface change lands while the governor (Phase 3) that consumes `tier` does not yet exist (harness at Phase 2 complete). This is a benign ordering for a feed-forward artifact — Phase 1 deliberately builds the config ahead of its Phase 3 consumer (`inputs/01-context-pack-v7.md` line 537) — but it means the `tier` field will sit unexercised until Phase 3, so a mis-shaped enumeration would not surface until then. The risk gate is the compensating control (implementation plan §7; plan v3 line 162 names this exact item a "`/risk-check` candidate").
- Potential terminology overlap: the harness B6 "autonomy tier" and the workspace "Autonomy Rules" share the word "autonomy" but are different mechanisms — a work-unit scheduling tier vs. a pause-trigger enumeration. Two surfaces using the same word for different concerns is a documented-contract hazard: a reader could conflate "tier D = defer" with an Autonomy Rule pause-trigger. C1 prevents a second policy *file*; it does not by itself prevent terminology collision. This is the residual coupling that pushes the dimension to Medium.
- No silent auto-firing: the change adds no hook and no cross-session side effect. The `tier` field is inert data until the Phase 3 governor reads it.

## Mitigations

- **Dimension 3 (Blast Radius):** Before the Track B phase-2 edits land, restate verbatim in the Workflow Config Interface section of v3 the interface evolution rule from `inputs/01-context-pack-v7.md` line 804 ("add fields with defaults, don't remove fields without deprecation") and specify a default value for `tier` (recommend `tier: A` or an explicit "absent = A" rule) so that any pre-existing or externally-authored config without a `tier` key still parses and the governor's Phase A planner has a defined fallback. This guarantees the four non-governor consumers (mandate parser, verification layer, failure detector, reporter) remain unaffected and no built component breaks.
- **Dimension 3 (Blast Radius):** When the deferred phase-2 work runs, gate it behind the §7 risk-check as already planned (plan v3 line 162) and verify against the test fixture that the mandate parser's structural validation still passes the config with the new `tier` key before Phase 3 governor code is wired — i.e., confirm the additive field does not trip validation.
- **Dimension 5 (Hidden Coupling):** Document the `tier` field's A/B/C/D enumeration and its semantics inline in the Workflow Config Interface section of v3 (the change site), and make the `tier` description an explicit cross-reference to `ai-resources/docs/autonomy-rules.md` — a pointer, not a paraphrase — so the C1 constraint is satisfied structurally and the enumeration cannot drift from the workspace Autonomy Rules.
- **Dimension 5 (Hidden Coupling):** Add a one-clause disambiguation note at the change site stating that the harness work-unit "autonomy tier" is a governor scheduling attribute and is distinct from the workspace "Autonomy Rules" pause-trigger enumeration, to prevent a future reader or executor from conflating "tier D = defer" with an Autonomy Rule pause-trigger.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures. Note: the "Track B Amendment Record" section referenced by the v3 changelog (line 16, line 29) is not yet present in the current `project-plan-v3.md` (the file ends at Appendix A, line 689) — consistent with the change description that B6 is being specified THIS session; evaluation of that section's contribution is based on described intent and is noted under Dimensions 3 and 5.
