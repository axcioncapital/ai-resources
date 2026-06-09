# Risk Check — 2026-06-09

## Change

Declare-inputs change to the canonical cluster-memo-refiner skill (input-contract breaking-change class) plus additive convention edits across three canonical research-workflow skills. Specifically: (1) cluster-memo-refiner/SKILL.md — declare research extracts (consumed by Check 10.1 + Check 8) and source-conflict-log.md (consumed by Check 10.2-3) as Input Requirements, each with an absent-mode/degraded branch; add an Example Output block; make Completion Criterion 11 conditional on the extracts presence-gate; add Runtime Recommendations + frontmatter rulings (C6/C7/C8) + C19 progress-tracking; trim C3 description under 1024. (2) claim-permission-gate/SKILL.md — 3 Minor convention gaps (C8 paths ruling, untruncate regime_note Output Example, C19 progress line). (3) execution-manifest-creator/SKILL.md — C7 allowed-tools fence + C13 Runtime Recommendations section. All three are canonical symlinked skills consumed by every research project; 11 canonical files are already drift-flagged with /sync-workflow pending. The cluster-memo-refiner input-contract change was explicitly flagged as needing its own /risk-check envelope when parked (S9, 2026-06-08). Edits intended additive-only (no check/column rename or reorder). Each skill independently cold-eval'd + /qc-pass'd before commit via /improve-skill.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/cluster-memo-refiner/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/claim-permission-gate/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/execution-manifest-creator/SKILL.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The convention edits to all three skills and the additive degraded-branch input declarations are low-risk and backward-compatible, but the cluster-memo-refiner input-contract change collides with a pre-existing stale contract in the consuming command (`run-cluster.md` invokes a "six-check refinement" against a ten-check skill), so the change must land paired with the consumer-side correction it implies.

## Consumer Inventory

Search terms: the three skill basenames; the contract markers the cluster-memo-refiner change touches — research extracts (consumed by Check 8 + Check 10.1), `source-conflict-log.md`, the shared `analysis/claim-permission/{section}/{section}-cluster-NN-permission-table.md` path, Completion Criterion 11. Greps run across `ai-resources/` and the workspace root. Audit/log/risk-check files are documentation noise (they *name* the skills in past reports) and are excluded from the functional inventory below; the rows are runtime/contract consumers only.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/workflows/research-workflow/.claude/commands/run-cluster.md | invokes (reads & passes cluster-memo-refiner content; line 35 says "six-check refinement"; line 32/35 passes extract **paths**) | yes |
| ai-resources/workflows/research-workflow/.claude/commands/run-sufficiency.md | invokes (delegates to claim-permission-gate; references source-conflict-log, permission-table path) | no |
| ai-resources/workflows/research-workflow/.claude/commands/run-execution.md | invokes (reads execution-manifest-creator SKILL.md, line 27) | no |
| ai-resources/skills/claim-permission-gate/SKILL.md | co-edits / parses (Cross-References line 207: cluster-memo-refiner Check 9 "first-pass" table superseded at shared permission-table path; itself edited in this batch) | no (additive) |
| ai-resources/skills/cluster-analysis-pass/SKILL.md | imports (upstream producer; feeds memos + Research Extracts the refiner now declares Required) | no |
| ai-resources/skills/research-extract-creator/SKILL.md | parses (produces extracts + source-conflict-log entries the refiner's new Required inputs / Check 10 consume) | no |
| ai-resources/skills/transaction-table-builder/SKILL.md | parses (consumes claim-ID format the refiner emits; Check 7 reads its table) | no |
| ai-resources/skills/country-parity-checker/SKILL.md | parses (reads the shared permission-table path) | no |
| ai-resources/skills/section-directive-drafter/SKILL.md | parses (reads the shared permission-table path) | no |
| ai-resources/workflows/research-workflow/reference/quality-standards.md | documents (defines §Claim-Permission Classes / §Source-Conflict Resolution / §Risk-Tier Model the refiner + gate read) | no |
| ai-resources/workflows/research-workflow/.claude/commands/run-synthesis.md | parses (reads permission-table path) | no |
| projects/research-pe-regime-shift-advisory-gap/reference/skills/{cluster-memo-refiner, claim-permission-gate, execution-manifest-creator} | imports (symlinks to the three canonical skills) | no (symlink resolves to edited file automatically) |
| projects/buy-side-service-plan/reference/skills/cluster-memo-refiner | imports (symlink to canonical) | no (symlink auto-resolves) |

Total: 13 distinct functional consumers, **1 must-change** (`run-cluster.md`). The symlinked project copies (2 projects confirmed via `find -lname`) auto-resolve to the edited canonical file — no per-project edit needed — but every project that runs the cluster pass inherits the contract change simultaneously. The `run-cluster.md` "six-check" reference is a consumer the CHANGE_DESCRIPTION did not anticipate (it predates the ten-check / additive framing) — that gap is a blast-radius finding (Dimension 3).

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file is touched. All three targets are skills (`skills/*/SKILL.md`), loaded on-demand by their invoking command, not per-turn or per-session — evidence: each is read by a command step (`run-cluster.md:26`, `run-sufficiency.md:44`, `run-execution.md:27`), not `@import`ed into any CLAUDE.md.
- No hook (SessionStart/Stop/PreToolUse/UserPromptSubmit) is registered by this change — CHANGE_DESCRIPTION adds no hook; greps surfaced no hook reference.
- The cluster-memo-refiner additions (Example Output block, Runtime Recommendations, C19 progress line) grow the *on-demand* SKILL.md body, paid only when `/run-cluster` spawns the sub-agent — pay-as-used, not ongoing.
- The C3 "trim description under 1024" edit *reduces* the always-parsed `description:` frontmatter (currently 1335 chars per `awk` count) — a net token reduction in the only part of the skill that loads at description-match time.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings.json (`allow`/`ask`/`deny`) entry is added, removed, or narrowed — CHANGE_DESCRIPTION names none; the edits are skill-body content only.
- The execution-manifest-creator "C7 allowed-tools fence" is a documentation convention inside the SKILL.md (declaring the skill's Read/Write tool footprint in prose, mirroring claim-permission-gate's existing "Tool footprint. Read + Write only" line at SKILL.md:200) — it does not grant a capability; it records the already-used surface.
- No shell, network, cross-repo write, or external-API capability is introduced. claim-permission-gate's own body confirms the family posture: "Read + Write only. No shell, no network" (SKILL.md:200).

### Dimension 3: Blast Radius
**Risk:** High

- Consumer inventory: **13 functional consumers, 1 must-change.** The must-change is `run-cluster.md`, the sole invoker of cluster-memo-refiner.
- **Stale-contract collision (the driving finding).** `run-cluster.md:35` instructs the sub-agent to "execute `cluster-memo-refiner` **six-check** refinement," but the current SKILL.md defines **ten checks** (Check 1–10, SKILL.md:72–279) and **eleven completion criteria** (SKILL.md:300–310). The consumer command is already drifted from the skill *before* this change. Making Completion Criterion 11 conditional on a new extracts presence-gate, and declaring research extracts + `source-conflict-log.md` as Input Requirements, deepens the gap between what the command tells the sub-agent to run and what the skill now requires. This is a contract change a caller depends on, and that caller is not backward-compatible as written.
- **Symlink fan-out.** `find -lname` confirms the canonical skill is symlinked into at least 2 projects (`research-pe-regime-shift-advisory-gap`, `buy-side-service-plan`). Every project running the cluster pass inherits the new Required-input contract at once. The change is correctly classed "input-contract breaking-change."
- **Shared permission-table path.** cluster-memo-refiner Check 9 and claim-permission-gate write the same `analysis/claim-permission/{section}/{section}-cluster-NN-permission-table.md` (refiner SKILL.md:248; gate SKILL.md:77,207). The coupling is documented ("this skill's authoritative Pass-3 table supersedes it at the shared path") and this change is additive (no column rename/reorder per CHANGE_DESCRIPTION), so the shared path is not newly endangered — but it is live shared infrastructure that the additive edits sit adjacent to.
- Mitigating: the input declarations carry explicit absent-mode/degraded branches (the pattern already used at refiner SKILL.md:38,43–45 for the transaction table and risk-tier plan), so a project lacking the new inputs degrades rather than breaks — *provided the command is updated to invoke the current check set*.

### Dimension 4: Reversibility
**Risk:** Low

- All edits are to four tracked files under version control (three SKILL.md + the paired `run-cluster.md` correction the mitigation requires). `git revert` restores prior state fully within the working tree.
- No data/log mutation (no innovation-registry / improvement-log / session-notes append is part of *this* change's substance), no settings.json change, no external write, no push, no hook/cron/symlink creation that could fire between landing and revert (the symlinks already exist; the change does not add new ones).
- Symlink note: because the project copies are symlinks, reverting the canonical file reverts every project simultaneously — this is a reversibility *advantage* (one revert, not N), not a cleanup burden.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **One implicit dependency made explicit, one still latent.** Declaring research extracts as a Required input formalizes a dependency that was previously implicit (Check 8 country-status and Check 10.1 extract-to-conflict-log coverage already read extracts — SKILL.md:199–212, 266). The change *documents* this at the change site (Input Requirements + degraded branch), which is the Low-risk pattern. The latent coupling is the `run-cluster.md` invocation contract (Dimension 3) — the skill now assumes inputs and a check set the command does not currently name. That contract is not documented at a single source of truth; it is split between the command's "six-check" prose and the skill's ten-check body.
- **Shared-path concurrency.** Two skills (refiner Check 9, claim-permission-gate) emit to the same permission-table path with a documented supersede rule (gate SKILL.md:207). The additive edits do not change column order, so positional parsers (`country-parity-checker`, `section-directive-drafter`, `run-synthesis.md`) are unaffected — but this is an existing two-writer coupling the change sits inside, hence Medium not Low.
- **source-conflict-log.md contract.** Declaring it a Required input (Check 10.2–3) couples the refiner to `research-extract-creator`'s log-writing convention and `quality-standards.md § Source-Conflict Resolution`'s `status:` enum (RESOLVED-METHODOLOGY / -GRANULARITY / -TRIANGULATION / UNRESOLVED — SKILL.md:268). This enum is an existing convention the new Required input now silently relies on; if the enum changes upstream, the refiner's Check 10.2 breaks. Documented at the change site, so not High.

### Dimension 6: Principle Alignment
**Risk:** Low

- Principles-base was readable (`projects/strategic-os/ai-strategy/principles-base.md`); checks applied against frozen IDs.
- **OP-9 / AP-7 / DR-7 (speculative abstraction).** Not triggered. The new Required inputs have *confirmed current consumers* — Check 8 and Check 10 already read extracts and the conflict-log in the live skill body (SKILL.md:199–212, 266–270). This is formalizing an existing dependency, not building a hook for an absent Phase-2 consumer. The consumer inventory shows real, present consumers (not zero). Aligned.
- **OP-12 (closure before detection).** Aligned. The change adds no new detection/scan/finding-generator; it declares inputs and adds degraded branches that *close* the absent-input case gracefully rather than emitting unhandled findings.
- **OP-5 (advisory vs enforcement).** No advisory→enforcement upgrade. The refiner remains an advisory refinement pass (operator reviews refined memos at the `run-cluster.md:48` PAUSE gate); the degraded branches advise-and-proceed, they do not auto-correct.
- **DR-1 / DR-3 (placement).** Aligned. All edits stay in the canonical `ai-resources/skills/*/SKILL.md` tier — correct home for skill methodology; no content is being pushed into CLAUDE.md (DR-5 respected).
- **DR-8 (gated structural change requires /risk-check).** This review *is* that gate; the input-contract change was correctly parked for its own envelope (S9, 2026-06-08) rather than slipped through — consistent with OP-11/OP-3 loud-not-silent posture.

## Mitigations

- **Dimension 3 (High → Medium):** Land the cluster-memo-refiner edit *paired with* a correction to `ai-resources/workflows/research-workflow/.claude/commands/run-cluster.md:35` — replace "execute `cluster-memo-refiner` six-check refinement" with the current ten-check wording, and add the new Required inputs (research extracts paths are already passed at line 32; add `source-conflict-log.md` path to the sub-agent's passed inputs, or confirm the degraded branch is the intended default when the log is absent). Without this paired edit the consumer command instructs a stale check count and omits a now-Required input. This is the consumer the CHANGE_DESCRIPTION did not anticipate; it must be in the same commit/batch.
- **Dimension 3 (supporting):** Because the skill is symlinked into ≥2 projects, run `/sync-workflow` (confirmed present at `ai-resources/.claude/commands/sync-workflow.md`) as the CHANGE_DESCRIPTION already flags pending — verify the 11 drift-flagged canonical files include `run-cluster.md` and the three skills, so the project-side workflow copies and any non-symlinked deployments pick up the contract together rather than drifting per-project.
- **Dimension 5 (supporting):** State the cluster-memo-refiner ↔ run-cluster check-set contract in one place (the skill body is the source of truth for the check count; the command should reference "the refiner's full check set" rather than hard-coding a number) so the count cannot drift again on the next edit.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (SKILL.md line references, `run-cluster.md:35` verbatim "six-check" vs ten-check body, `find -lname` symlink confirmation, `awk` description-length count of 1335 chars, principles-base frozen-ID citations). No training-data fallback was used on fetch/read failures.

## Architectural Commentary

_System-owner second opinion (Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION. Note: `/consult` is guarded by `disable-model-invocation` and cannot be dispatched model-side; the underlying `system-owner` agent was invoked directly to obtain the equivalent advisory. Full advisory on disk: `projects/axcion-ai-system-owner/output/consultations/consult-2026-06-09-pre-change-advisory-input-contract-cluster-memo-refiner.md`._

**Q1 — Concurs with PROCEED-WITH-CAUTION.** Not GO (the conditional-Required input declaration is not self-contained — see Q4). Not RECONSIDER (real defects, safe mechanism already exists in-file). "Principle alignment: Low" correctly flags the Q4 half-contract.

**Q2 — Reviewer's mitigation #1 is WRONG. Leave `run-cluster.md:35` at six-check.** The six-check refiner is logged intentional contract (project decisions.md 2026-06-03 S2): Checks 8/9/10 deferred to `/run-sufficiency` to avoid permission-table double-emission. The `:35` literal encodes that decision; forcing ten-check reverses it and re-creates the collision. The reviewer missed it for lack of the decision record. The skill's own Check 9 (`SKILL.md:36`) already demonstrates the correct mechanism: presence-gate, "opt-in enrichment, never a breaking change."

**Q3 — Conditional-required IS the right framing — and it is the skill's own existing pattern.** Check 9 already declares its research-plan input as Optional + presence-gate + degraded branch. Mirror that structure verbatim. Unconditional-Required would validate an impossible condition in the 6-check deployment (principles.md § AP-10).

**Q4 — Couple it; the dependency is deeper than F3 alone.** The conditional-Required form needs a *declared run-condition* to be conditional on. That run-condition is the parked F3 declared-check-count contract — and F3 is itself blocked on F1's `sync-and-authority.md` doc (improvement-log lines 263/259). Real chain: **F1 → F3 → this change.** **Recommended = Option A:** land everything contract-independent now (both convention skills + the additive cluster-memo-refiner items); declare the two new inputs as **Optional-with-degraded-branch (NOT Required-when-check-runs)**; route the conditional-Required *upgrade* to F3 behind F1. Mirrors the #23 "Option A + loud log" precedent (decisions.md 2026-06-08 S2; principles.md § OP-11). Pulling the conditional-Required form into this session means pulling F1 forward first — a materially bigger session; do not ride it on a defect-cleanup pass.

**Q5 — Three missed risks:**
1. The F1→F3 sequencing dependency above (most material; "Hidden coupling: Medium" only half-caught it).
2. `source-conflict-log.md` is a two-end contract, not just an input. This workflow has live path-convention drift (decisions.md 2026-06-03 S2 Dec 2). Grep the producer's emitted path before declaring it Required-on-read, or the presence-gate fails on a path mismatch, not a true absence (#15 grep-gate discipline).
3. C3 `description` trim is a trigger-surface edit, not cosmetic (QS-6). QC the trimmed text against the original trigger phrases, not just the 1024-char count.

**Verdict impact:** Advisory only — does not override the PROCEED-WITH-CAUTION verdict. The system owner CONCURS with the verdict and SHARPENS the recommended path (Option A: convention-skills + additive items now, inputs declared Optional-not-Required, conditional-Required upgrade deferred to the F1→F3 chain). It also REJECTS the reviewer's mitigation #1 (run-cluster six→ten-check) as a misread of an intentional contract.
