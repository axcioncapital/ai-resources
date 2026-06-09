# Risk Check — 2026-06-09

## Change

Land fix-spec Milestone 4 (#5 paywall-exposed fast lane + #1-lite source-plan table) into two canonical symlinked skills. Edit 1 — execution-manifest-creator/SKILL.md: add a four-way up-front paywall classification (public-answerable / public-proxyable / public-gated / not-worth-pursuing) as a field per manifest row, plus an embedded #1-lite source-plan table (columns: research question | required source classes | native-language requirement | paywall risk | stop condition) and the corresponding manifest-template + Self-Check wiring. This is an OUTPUT-CONTRACT change to a canonical skill consumed by ~all research projects via symlink. Edit 2 — research-prompt-creator/SKILL.md (and possibly the project run-execution.md command): add the fast-lane scarcity-audit execution rule — a public-gated need triggers a bounded 5-8 proxy-search audit + #24 register check (known-limits.md) + residual classification (Proprietary/Gated/Opaque), then stop, continuing to a deep session ONLY on explicit operator override (rides the existing manifest-approval gate, no new gate). Authoritative design: audits/2026-06-08-design-note-5-1lite-paywall-fast-lane.md (its §6 self-assessed PROCEED at implementation via /improve-skill + /risk-check). Dependencies #17 (tier model, DONE — risk-tier model live in quality-standards.md + 3 gate skills), #24 register (present — reference/known-limits.md § Known-Unavailable-Evidence Register), #3 native-language column (present — execution-manifest-creator § Country-Specific Language-Block Routing) all satisfied. Both edits routed through /improve-skill with independent cold-eval + post-edit QC. Mitigations already designed: keep #1-lite a manifest table never a standalone artifact (bloat guard); fast-lane must stay operator-overridable so it cannot silently drop an important gated need.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/execution-manifest-creator/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/execution-manifest-creator/references/manifest-template.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-prompt-creator/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/.claude/commands/run-execution.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/audits/2026-06-08-design-note-5-1lite-paywall-fast-lane.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/reference/known-limits.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** An additive, backwards-compatible output-contract extension to two canonical Stage-2 skills that formalizes already-practiced behavior, well-anchored in an authoritative design note with mitigations pre-designed — but moderate because the edit fans out to all research projects and the fast-lane introduces an early-stop execution rule whose safety depends entirely on the operator-override escape hatch being wired and the #1-lite table staying additive.

## Consumer Inventory

Search terms: `execution-manifest-creator`, `research-prompt-creator`, `manifest-template`, "Execution Manifest", `known-limits`, plus contract markers for the new section (`paywall`, `public-gated`, `fast-lane`, `source-plan`). Grepped across `ai-resources/` and `projects/`, filtered to live consumer files (audit reports, session logs, repo snapshots, prior generated extracts/checkpoints excluded as non-consumers).

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/skills/execution-manifest-creator/SKILL.md | co-edits (Edit 1 target) | yes |
| ai-resources/skills/execution-manifest-creator/references/manifest-template.md | co-edits (template must carry the new row/table per Edit 1) | yes |
| ai-resources/skills/research-prompt-creator/SKILL.md | co-edits (Edit 2 target) + parses manifest (session groupings only) | yes |
| projects/research-pe-regime-shift-advisory-gap/.claude/commands/run-execution.md | invokes both skills (Step 2.0, Step 2.1); possible Edit 2 surface | no (per-design: fast-lane rides existing gate, no command rewrite required) |
| ai-resources/workflows/research-workflow/.claude/commands/run-execution.md | invokes both skills (canonical template the per-project command derives from) | no (not in scope; propagate separately if behavior promotes to template) |
| projects/buy-side-service-plan/.claude/commands/run-execution.md | invokes both skills | no (additive section — does not break existing invocation) |
| ai-resources/skills/research-extract-creator/SKILL.md | documents/parses upstream (consumes raw reports + known-limits register, not the manifest table directly) | no |
| ai-resources/skills/research-prompt-qc/SKILL.md | documents (QCs prompt output against manifest groupings) | no |
| ai-resources/skills/source-class-mapper/SKILL.md | documents (Stage 2.0b sibling step; feeds source classes the #1-lite table cites) | no |
| ai-resources/skills/CATALOG.md | documents (skill registry entry) | no (unless skill purpose-line changes) |
| ai-resources/workflows/research-workflow/reference/stage-instructions.md | documents (Stage 2 sequence) | no (additive) |
| projects/.../reference/known-limits.md (#24 register) | imports/depends (fast-lane consults the register) | no (already present; read-only dependency) |
| projects/research-pe-regime-shift-advisory-gap/execution/manifest/1.1/1.1-execution-manifest.md | (prior output instance) — already encodes the behavior informally ("Q2 HIGH / GATED", scarcity classification) | no (evidence the contract is additive, not a downstream parser) |

**Total: 13 distinct consumers, 3 must-change** (the two skill targets + the manifest-template; all three are the deliberate edit surface). The two non-target `run-execution.md` commands and the canonical template are invokers that remain compatible because the change is additive. No downstream component parses a `paywall risk` / `source-plan` column today, so no parser is broken.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Neither skill is always-loaded. Both are read on demand by `run-execution.md` Step 2.0 / 2.1 via absolute path (`run-execution.md:27`, `:42`) and passed to a delegated sub-agent — pay-as-used, not per-turn. No CLAUDE.md edit, no hook, no `@import`.
- Both skills are `model: sonnet` (SKILL.md:18 in each) — added content is processed once per Stage-2 run, not per session or per tool call.
- Net token addition is bounded: a four-way classification field per row + a five-column embedded table + Self-Check lines. Per the design note §4 the #1-lite table is deliberately "compact... NOT a new standalone artifact" (design-note:46), so the brief growth is contained to one manifest section.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings.json change, no allow/ask/deny entry, no new tool family. The change is content-only inside two SKILL.md files plus a template.
- The fast-lane rule adds no new capability — it *narrows* execution effort (stop early) rather than widening it. The only behavioral "permission" is the operator-override path, which the design explicitly routes through the **existing** manifest-approval gate (design-note §7 Q3 / CHANGE_DESCRIPTION: "rides the existing manifest-approval gate, no new gate").

### Dimension 3: Blast Radius
**Risk:** Medium

- Consumer inventory (Step 1.5): 13 consumers, 3 must-change — all three are the intended edit surface (the two skill targets + manifest-template). No unanticipated must-change consumer surfaced.
- Output-contract change to a **canonical** skill consumed by all research projects. CHANGE_DESCRIPTION says "symlinked"; the actual mechanism is absolute-path read inside each project's `run-execution.md` (no symlinked skill found under `projects/.../.claude/skills`). Either way the edit propagates to every consuming project (buy-side-service-plan and research-pe-regime-shift-advisory-gap both invoke it) — this is the breadth that lifts the dimension above Low.
- **The contract change is additive / backwards-compatible.** `research-prompt-creator` parses the manifest only for "session groupings, tool assignments... dependencies, and parallel execution opportunities" (research-prompt-creator SKILL.md:27, :69). It does not read a `paywall risk` or `source-plan` column, so adding those rows/columns does not break its parse. Grep of the live `1.1-execution-manifest.md` confirms no existing parser depends on the new section, and that manifest *already* encodes the behavior informally (Q2 "HIGH / GATED", scarcity classification) — the change formalizes existing practice rather than introducing a foreign contract.
- No caller requires modification to keep working: the two non-target `run-execution.md` commands and the canonical workflow template invoke the skills but tolerate an additive output section. This keeps the dimension at Medium (broad but compatible), not High.

### Dimension 4: Reversibility
**Risk:** Low

- Both edits are single-file content edits to versioned SKILL.md / template files in `ai-resources/`. `git revert` fully restores prior state within the working tree — no sibling files, no new directories, no data/log mutation.
- The #1-lite table is a section *inside* the generated manifest, not a new standalone artifact (design-note:46) — so a revert leaves no orphaned artifact type behind.
- No state propagates beyond git: no push (batched/gated), no external write, no hook or symlink that could fire between landing and revert. Already-generated manifests are prior outputs and are unaffected by reverting the skill.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The fast-lane rule **depends on the #24 register existing and being current**: step 2 of the audit consults `reference/known-limits.md § Known-Unavailable-Evidence Register` (design-note §3). That register is project-local and was added as an "additive divergence" not yet in the canonical `known-limits.template.md` (known-limits.md:110). So the canonical skill edit will assume a register that exists in this project but is NOT guaranteed in every project the canonical skill serves — a silent cross-tier coupling. This must be handled gracefully (skip the register step, not halt) when the register is absent.
- The `native-language requirement` column of the #1-lite table couples to #3's `Country-Specific Language-Block Routing` (execution-manifest-creator SKILL.md:87–104) and, downstream, to research-prompt-creator's S-04 local-language block + the `Languages:` Project Config field. This coupling is real but documented at both change sites — keeps it at Medium, not High.
- The new contract (the classification field + table columns) is documented at the change site (the SKILL.md itself + the manifest-template + the design note), which is the Medium (not High) condition. The residual-classification vocabulary (`Proprietary`/`Gated`/`Opaque`) overlaps conceptually with the existing source-class-hierarchy ladder and the No-Source-Substitution tags (`IN-LENS`/`PROXY-DOWNGRADE`/`NO-EVIDENCE`, research-prompt-creator SKILL.md:138–142) — confirm the new labels are additive and not a competing third taxonomy callers must reconcile.

### Dimension 6: Principle Alignment
**Risk:** Low

- Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md` (frozen-ID index, 41 active principles).
- **OP-12 (closure before detection): aligned, actively serving.** The fast-lane is the *closure* channel for a detection that already exists — the #24 register catalogues unavailable evidence; #5 is "the *execution rule* that consults the catalogue and routes accordingly" (design-note §1). It does not add a new detector ahead of closure; it closes the existing Q2-class search-burn. This counts *for* the change.
- **OP-9 / AP-7 / DR-7 (no speculative abstraction): aligned.** The change has a confirmed live consumer — the 1.1 run's Q2 dispersion question is the canonical failure case the change closes (design-note §1; live manifest Q2 "HIGH / GATED"). This is not building for an absent Phase-2 consumer; it formalizes a pattern already practiced informally.
- **OP-5 (advisory vs enforcement): aligned.** The fast-lane *advises and stops* (record classification + proxy + ceiling) and explicitly does NOT auto-act — continuation to a deep session requires explicit operator override (design-note §3 step 4). It is not a silent enforcement upgrade.
- **OP-2 / AP-4 (automate execution, gate judgment): aligned.** The genuine judgment ("is this gated need important enough to spend deep effort anyway?") stays operator-gated via the override; only the routine execution (the bounded 5–8-search audit) is automated.
- **DR-1 / DR-3 (placement): aligned.** The classification logic lands in the canonical skill; the register stays project-local; #1-lite stays a manifest table not a new artifact (design-note:46) — correct tiering, no new home.
- **DR-2 / DR-8 (canonical pipeline + risk-check): aligned and being honored** — the change routes through `/improve-skill` + this `/risk-check` rather than a hand-edit (design-note §6 mitigation a).

## Mitigations

- **Dimension 3 (Blast Radius):** Land the edit through `/improve-skill` with independent cold-eval + post-edit QC (as CHANGE_DESCRIPTION already commits), and explicitly verify the additive property during QC — confirm the post-edit manifest still satisfies every existing `research-prompt-creator` Self-Check item (session groupings, tool assignments, dependencies, `Language passes` column) so no downstream parse regresses. Keep the new section additive: do NOT reorder or rename existing manifest-template columns/sections that callers already read.
- **Dimension 5 (Hidden Coupling):** Make the #24-register check in the fast-lane **graceful-absent** — when `reference/known-limits.md § Known-Unavailable-Evidence Register` is missing (it is project-local and NOT in the canonical template per known-limits.md:110), the audit must skip the register step and rely on the 5–8 proxy searches alone, not halt. Document this absent-register behavior in the skill body so the canonical skill is safe in projects that lack the register. Additionally, state in the skill that the residual labels `Proprietary`/`Gated`/`Opaque` are a fast-lane scarcity classification, distinct from and not a replacement for the source-class ladder or the `IN-LENS`/`PROXY-DOWNGRADE`/`NO-EVIDENCE` tags, so callers do not treat them as a competing taxonomy.

## Recommended redesign

(Omitted — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to the two SKILL.md targets, the manifest-template, the design note, known-limits.md, and run-execution.md; grep counts for the consumer inventory; principle IDs from principles-base.md). No training-data fallback was used on any read.

## Architectural Commentary

_System-owner second opinion (Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION. `/consult` is operator-only (disable-model-invocation); the `system-owner` agent — the same advisor `/consult` delegates to — was spawned directly to fulfil Step 4a. Full advisory on disk: `projects/axcion-ai-system-owner/output/consultations/consult-2026-06-09-second-opinion-risk-check-milestone-4-paywall-fast-lane.md`._

**1. Position — CONCUR with PROCEED-WITH-CAUTION.** GO is wrong: a canonical-skill output-contract edit fans out to every research project and is never GO-eligible (risk-topology.md § 3 "Canonical command/agent edit"; DR-8). RECONSIDER is wrong: additive, cleanly reversible, confirmed live consumer (the Q2 burn), serves OP-12 closure-before-detection. PROCEED-WITH-CAUTION is correctly calibrated.

**2. Mitigations — right path, both kept, both strengthened.**
- (a) Additive-only is under-specified. Make it falsifiable: regression-diff `research-prompt-creator`'s parser output (session groupings) on a before/after manifest — not an eyeballed column check. Two-end producer/parser contract (risk-topology.md § 5).
- (b) Graceful-absent register check + distinct residual taxonomy — correct and necessary. Keep both halves.

**3. Three risks the six-dimension review under-weighted:**
- **(i) Canonical-vs-project-local split is the real risk, not a Medium sub-point.** A canonical skill now hard-depends on a project-local register not in the canonical template — the cross-tier coupling DR-1/DR-3 prevent. Graceful-absent demotes the register from guarantee to best-effort, reopening the "misclassified gated" failure. Structural fix: promote an empty register slot into `known-limits.template.md`. At minimum the skip must emit a **loud** degraded-mode note in the manifest (OP-3), not a silent fallback.
- **(ii) #17 interaction is NOT a contradiction — it's the designed seam, but untested at row level.** Axes are orthogonal (#17 = rigor by importance; #5 = public obtainability); STOP + operator-override reconciles them. But the new `stop condition` column must defer to #17's landed "most-restrictive binds" precedence: gated Tier-A ⇒ "fast-lane THEN override," not "Tier-A ⇒ full ladder" (nulls the fast lane) nor "gated ⇒ hard stop" (nulls the override). Assert this precedence explicitly. [CITATION NEEDED] on the exact current wording of the #17 rule in the 3 gate skills — verify before wiring the column.
- **(iii) Template-drift, the missed operational risk.** Editing 3 canonical files while 11 are already drift-flagged means these edits close out via `/sync-workflow`, not hand-copy; the canonical-template propagation (out of scope here) **is** the drift-creation event. Log both the canonical-template propagation and the register-template promotion as explicit follow-ups, not silent defers.

**Net:** Verdict stands. Land via `/improve-skill` + post-edit QC. Treat §3(i) as primary. The change is sound; the close-out checklist is where it's currently thin.
