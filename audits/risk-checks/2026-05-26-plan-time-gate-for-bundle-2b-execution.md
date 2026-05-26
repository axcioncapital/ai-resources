# Risk Check — 2026-05-26

## Change

Plan-time gate for Bundle 2b execution. Full plan at `logs/session-plan.md`. Mandate at `logs/session-notes.md` under the `## 2026-05-26 — Bundle 2b (Rules + skill behavior) — S-02, S-03, S-04, S-06, S-07, S-13, S-19` header.

Bundle 2b scope: 7 source-pipeline workflow remediations per v4 spec (S-02 line 192, S-03 line 223, S-04 line 264, S-06 line 393, S-07 line 488, S-13 line 877, S-19 line 1245), scoped per v6 MVP decision.

Edit surface (9 files):
- `reference/quality-standards.md` (project) — 5 new normative sections
- `reference/file-conventions.md` (project) — 3 new rows
- `ai-resources/skills/research-prompt-creator/SKILL.md` — atomic 4-edit (S-02+S-03+S-04+S-13)
- `ai-resources/skills/research-extract-creator/SKILL.md` — atomic 2-edit (S-02+S-19)
- `ai-resources/skills/cluster-analysis-pass/SKILL.md` — S-03 only
- `ai-resources/skills/cluster-memo-refiner/SKILL.md` — **atomic 3-stack (S-03+S-06+S-19), pre-drafted as one factored edit**
- `ai-resources/skills/execution-manifest-creator/SKILL.md` — S-04 only
- `ai-resources/skills/section-directive-drafter/SKILL.md` — S-06 only
- `ai-resources/skills/research-extract-verifier/SKILL.md` — S-13 only

Operator-flagged risk-shapes: ai-resources canonical edits, reference-doc blocking-semantics changes (S-06 30%/40% thresholds + fail-safe), cluster-memo-refiner 3-stack coordination, pre-existing gate-clearance integration.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/session-plan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/session-notes.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/report/diagnostics/1.1/1.1-source-pipeline-workflow-fix-proposal-v4-2026-05-26.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/report/diagnostics/1.1/1.1-source-pipeline-workflow-fix-proposal-v6-mvp-scope-decision-2026-05-26.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/quality-standards.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/file-conventions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-prompt-creator/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-extract-creator/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/cluster-analysis-pass/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/cluster-memo-refiner/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/execution-manifest-creator/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/section-directive-drafter/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-extract-verifier/SKILL.md — exists

## Verdict

**PROCEED-WITH-CAUTION**

**Summary:** All 5 dimensions hold either Low or Medium-with-mitigation; Hidden Coupling is High because the S-06 blocking-gate introduces a four-end string contract (cluster-memo-refiner producer → file-conventions row → claim-permission-gate sub-agent → run-analysis/run-synthesis Step 0 readers) that the plan addresses through pre-draft + post-S-06 sanity check but where verbatim verification on landing is load-bearing. The cluster-memo-refiner 3-stack is real but well-staged via Plan Step 3's pre-draft + operator-review stop point.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Edits are content additions to files that are already on-demand loaded per pipeline step, not always-loaded. `quality-standards.md` carries explicit gating at line 3 ("When to read this file: When running QC checks, applying fixes to prose, or handling evidence gaps. Not needed for every turn.") — 5 added sections inherit that gating.
- `file-conventions.md` is on-demand loaded per file-write decision (line 3 pattern); 3 added rows are zero-cost to non-file-creation turns.
- 7 skill files are read by sub-agents on invocation, never auto-loaded. Current line counts (236 / 126 / 160 / 243 / 131 / 261 / 185 = 1,342 total) gain modest content additions; even doubling cluster-memo-refiner's 243 lines via the 3-stack remains in per-invocation territory.
- No new SessionStart, Stop, PreToolUse, UserPromptSubmit hooks introduced (plan Execution Sequence steps 4–7 are file edits only).
- No new `@import` chains; no project `CLAUDE.md` edit declared in Bundle 2b scope (mandate `Out of scope` line: `project CLAUDE.md edits`).
- No new skill auto-load triggers via description-keyword broadening — extensions stay inside existing skill files.

### Dimension 2: Permissions Surface
**Risk:** Low

- No edits to any `.claude/settings.json` or `.claude/settings.local.json` in the in-scope file list (verified — mandate file list at session-notes line 418, plan Source Material at session-plan lines 20–29, neither names a settings file).
- 7 skill behavior edits operate within Read/Write patterns the research-workflow pipeline already authorizes — `research-prompt-creator` adds preamble + per-country ordering + native-language blocks + stop-condition declarations (all in-prompt text); `research-extract-creator` adds tagging and conflict-recording (extract content); `cluster-analysis-pass` emits coverage table (memo content); `cluster-memo-refiner` adds 3 check types (already runs Check 7 today); `execution-manifest-creator` routes additional session blocks (same Write pattern); `section-directive-drafter` references permission table (Read addition); `research-extract-verifier` records stop-condition status (verification content).
- No new MCP server, no new external API, no shell command additions, no deny-rule removals.
- New artifact directories implied by file-conventions rows (`analysis/claim-permission/{section}/`, `analysis/gate-clearance/{section}/`, `analysis/source-conflicts/{section}/`) sit under the existing `analysis/` write scope already used by cluster-memos, section-directives, etc.

### Dimension 3: Blast Radius
**Risk:** Medium

**Files directly touched:** 9 (2 project reference docs, 7 canonical skill files). Plus 3 new artifact-family rows in file-conventions implying 3 new directory creates by downstream skills on first invocation.

**Caller enumeration (greps `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/` + `ai-resources/.claude/`):**
- `cluster-memo-refiner` referenced by: `run-cluster.md` (Pass 3 entry). 1 direct caller. Downstream consumer of memo output: section-directive-drafter, gap-assessment-gate, run-analysis. The Claim-ID Format section added in Bundle 2a already names cluster-memo-refiner as canonical PRODUCER consumed by transaction-table-builder and (deferred) claim-permission gate. Bundle 2b's S-06 + S-19 add two more downstream consumer contracts (permission-table emission, conflict-validation).
- `section-directive-drafter` referenced by: `run-analysis.md` line 58. 1 direct caller. S-06 adds permission-table reference and NOT-SUPPORTED refusal.
- `research-extract-verifier` referenced by: present in skills directory. S-13 adds stop-condition recording + EVIDENCE-CEILING-REACHED marker.
- `execution-manifest-creator` referenced by: `run-execution.md`. S-04 adds local-language session routing.
- `research-prompt-creator` referenced by: `run-execution.md`, plus Bundle 1's Evidence-First preamble already prepends every prompt. S-02 + S-03 + S-04 + S-13 stack on the same file; each is an additive prompt-section change rather than a structural rewrite.
- `research-extract-creator` referenced by: `run-execution.md`. Bundle 2a's S-11 freshness fields already landed. S-02 (tagging) + S-19 (conflict-recording) atomic 2-edit.
- `cluster-analysis-pass` referenced by: invoked by Pass 3 entry. S-03 only — adds country-coverage table emission.
- `quality-standards.md` (project): read by QC commands; 5 new sections (No-Source-Substitution, Country Coverage Table, Claim-Permission Classes + Source-Diversity Matrix co-located, Research Stop Conditions, Source-Conflict Resolution Procedure). Pre-existing run-analysis Step 0 (lines 13–26) + run-synthesis Step 0 (lines 13–28) already gate on the gate-clearance file produced by run-sufficiency Phase F; S-06's blocking-gate semantics make the threshold values normative inside quality-standards.md, with run-analysis line 21 already naming "see `per_cluster_ratios` in the gate-clearance file" — the contract between this file and the runtime gate is established.
- `file-conventions.md` (project): consumed at file-write decisions. 3 new artifact-family rows.

**Contract changes:**
- New: cluster-memo-refiner emits per-cluster permission table (S-06) consumed by section-directive-drafter + run-synthesis line 28 ("read the per-cluster permission tables from `/analysis/claim-permission/{section}/`"). The consumer-side reader already exists in run-synthesis from Bundle 1; Bundle 2b makes the producer-side emission contract real.
- New: cluster-memo-refiner six-check (currently seven checks per the in-scope file) adds Check 8 (country-parity), Check 9 (permission-table validation against synthesis), Check 10 (conflict-log entry validation). Existing Check 7 (Named-Transaction Verification, Bundle 2a) plus 3 new checks = 10 checks total. The Completion Criteria block (current lines 202–215) must grow correspondingly or fall out of sync.
- New: research-extract-creator extracts conflict-log triggering (S-19) — extract is no longer self-contained when a conflict exists.

**Cross-repo writes:** Yes — both `ai-resources/` AND project `reference/` carry working-tree modifications. Dual commit pattern matches Bundle 1 and Bundle 2a; the project-side divergence breadcrumb (Bundle 2a SO Risk 2) at `reference/file-conventions.md` line 5 already declares "sync permanently removed from v6 plan" — Bundle 2b project-side edits inherit that posture and should extend the breadcrumb to name Bundle 2b additions.

**Mitigation already in plan:** Step 3 (pre-draft consolidated factored shape for cluster-memo-refiner with operator-review stop point); Step 4 sequencing of quality-standards.md sections in dependency order (S-02 vocab before S-06 consumes it; S-06+S-07 co-located per v4 line 491); Step 6 atomic multi-edit per file. These collectively land the change set without splaying coordination across multiple sessions.

### Dimension 4: Reversibility
**Risk:** Medium

- All 9 files are edits to existing files (no new files in Bundle 2b's primary scope). `git revert` returns each file to pre-edit state cleanly.
- Cross-repo revert dependency: dual revert in two repos (ai-resources commit + project commit) — same shape as Bundle 1 and Bundle 2a. Bundle 2a's end-time gate Mitigation C established the "name the revert sequence in commit message" pattern; carry the same posture forward.
- New artifact directories implied by file-conventions rows do not create on this session (they are downstream skill-invocation creates) — file-conventions rows themselves revert cleanly.
- Downstream side-effects: Bundle 2b activates several Bundle 2a inert fields:
  - `research-extract-creator` evidence_date + freshness classes (inert-field ledger at `source-class-hierarchy.md` lines 130–139 + `known-limits.md` lines 68–77 per the Bundle 2a end-time gate). Once S-06 lands, freshness-downgrade becomes live. A revert of Bundle 2b returns these to inert without leaving stale extract content — the freshness fields themselves stay populated but the downgrade consumer disappears.
  - Once `cluster-memo-refiner` emits per-cluster permission tables, the run-synthesis Step 0 (line 28) reader will start finding them. If Bundle 2b is reverted but a synthesis run already happened, the produced chapter drafts will reference per-cluster permission tables that no longer have a producer skill — a partial-revert hazard, not a hard failure.
- The S-06 blocking-gate semantics + 30%/40% thresholds reach project state via `quality-standards.md`. If thresholds prove wrong post-land, calibration adjustment is a single-value edit in quality-standards.md (plan locked-decision 8 explicitly permits "Calibration after first production run permitted"). Not a structural revert — a parametric adjustment.
- No state pushed beyond local repos. No automation registered that auto-fires between land and revert.
- Operator-memory side-effect: once operator internalizes new commands (none added in Bundle 2b) or new sections in quality-standards.md, a revert leaves operator referring to text no longer on disk. Low-grade muscle-memory cost, not a blocker.

### Dimension 5: Hidden Coupling
**Risk:** High

The operator-flagged 3-stack + the gate-clearance integration are the load-bearing couplings.

**Coupling A — cluster-memo-refiner 3-stack coherence (operator-named top risk):** Three edits land in one file's six-check section (already grown to a seven-check section in Bundle 2a, so this is actually edits on top of the seventh check):
- S-03 adds country-parity check (consumes Country Coverage Table from quality-standards.md and consumes cluster-analysis-pass's table emission)
- S-06 adds per-cluster permission-table emission (produces the table that run-synthesis line 28 reads and that section-directive-drafter consumes)
- S-19 adds conflict-log entry validation (consumes research-extract-creator's conflict-log triggering)
The risk is silent collision in the six-check section structure if applied as three independent edits — a check numbered "Check 8" by edit 1 may clash with edit 2 also numbering "Check 8". The plan's Step 3 stop point (pre-draft the consolidated factored shape, operator-review) is the canonical mitigation. **Verbatim verification required at apply time:** the pre-drafted edit must show ONE coherent additions block (not 3 hunks); existing Completion Criteria block (currently 8 numbered items at lines 204–213) must grow to match (3 new criteria for the 3 new checks).

**Coupling B — S-06 four-end string contract (highest-cardinality coupling in Bundle 2b):**
- End 1: `quality-standards.md` § Claim-Permission Classes — declares the 4 classes (SUPPORTED / PROXY-SUPPORTED / ILLUSTRATIVE-ONLY / NOT-SUPPORTED), the verb lists, the 30%/40% thresholds, the fail-safe behavior.
- End 2: `cluster-memo-refiner/SKILL.md` six-check Check 9 (S-06) — produces per-cluster permission tables at `analysis/claim-permission/{section}/{section}-cluster-NN-permission-table.md`.
- End 3: `section-directive-drafter/SKILL.md` — references the permission table; refuses NOT-SUPPORTED claims.
- End 4: `run-analysis.md` / `run-synthesis.md` Step 0 — already-live consumers of `analysis/gate-clearance/{section}/{section}-gate-clearance.md`. The gate-clearance file itself is produced by `/run-sufficiency` Phase F (Bundle 1), not by Bundle 2b. **The coupling Bundle 2b adds is the per-cluster permission table consumer in run-synthesis line 28**, which until Bundle 2b lands has no producer — Bundle 2b makes the consumer's read targets exist on disk. The fail-safe means absence of the gate-clearance file means run-analysis/run-synthesis refuse to run; absence of permission tables (separate read target) is currently not checked. Once Bundle 2b lands, downstream run-synthesis runs may encounter per-cluster permission tables that are present but content-malformed; the wiring back from "malformed permission table" to "claim-permission-gate sub-agent" is not in scope for Bundle 2b.
- File-conventions ends: 2 new rows (claim-permission-table + gate-clearance file, per S-06 v4 lines 450–452 and 473–475 — though the gate-clearance row may already exist from Bundle 1; plan calls out "3 new rows" total including S-19 source-conflict log, suggesting claim-permission table + source-conflict log + ONE of {gate-clearance, or a third row} — verbatim check required at apply time).

**Coupling C — vocabulary cascade through quality-standards.md sections (intra-file):** S-02 declares `IN-LENS / PROXY-DOWNGRADE / NO-EVIDENCE` vocabulary; S-06 consumes those labels in the SUPPORTED / PROXY-SUPPORTED / ILLUSTRATIVE-ONLY / NOT-SUPPORTED matrix; S-13 stop conditions feed into S-06 via "extracts that closed via condition 3 or 4 are marked EVIDENCE-CEILING-REACHED and the affected claims are pre-classified PROXY-SUPPORTED or NOT-SUPPORTED before reaching the S-06 gate" (v4 line 900). Plan Step 4 sequences sections in dependency order to preserve forward-reference integrity. **Verbatim verification required:** no S-06 section text references the S-02 labels by name unless the S-02 section has been written; no S-13 section text references S-06 classes unless S-06 has been written.

**Coupling D — Bundle 2a inert-field activation:** The `evidence_date` + freshness classes (already on disk in `research-extract-creator/SKILL.md` from Bundle 2a) become live consumers via S-06. The Bundle 2a inert-fields ledgers at `source-class-hierarchy.md` lines 130–139 and `known-limits.md` lines 68–77 explicitly named "Bundle 2b S-06 claim-permission-gate" as the activator. Bundle 2b should remove or update those ledger entries to reflect that activation has occurred — otherwise operators reading those reference docs after Bundle 2b lands see ledger entries claiming the fields are inert when they are not.

**Coupling E — six-check section name drift in cluster-memo-refiner:** The SKILL file's title-level text says "Run six structured refinement checks" (line 27) but the file already runs 7 checks (Check 7 from Bundle 2a). Bundle 2b adds 3 more — 10 total. The "six-check" naming is now ambiguous; the Completion Criteria block uses numbered items (1–8) not the six-check phrase. Drift accumulates silently if not addressed in the consolidated factored edit (Plan Step 3).

**Coupling F — file-conventions divergence breadcrumb:** Bundle 2a added an SO Risk 2 breadcrumb at line 5 declaring "sync permanently removed from v6 plan" and naming Bundle 2a additions. Bundle 2b adds 3 more rows; the breadcrumb must be extended (or the operator reading it post-Bundle-2b will see Bundle 2b additions without breadcrumb coverage). Same posture for `reference/stage-instructions.md` if any Bundle 2b implication touches Stage 3 instruction text — Plan does not name stage-instructions edits, so no action required here, but the breadcrumb's "Bundle 1 + 2a" framing becomes stale on Bundle 2b land.

**The plan addresses these:** Plan Step 3 (pre-draft cluster-memo-refiner with operator review — Coupling A + E); Plan Step 4 sequencing (Couplings B + C intra-file ordering); Plan Step 4 verification ("v3 blocking-gate semantics + 30%/40% thresholds + fail-safe present" — Coupling B end 1). The plan does NOT explicitly address Coupling D (inert-field ledger update) or Coupling F (breadcrumb extension) — see Mitigations.

## Mitigations

- **Coupling A + E (cluster-memo-refiner consolidated factored edit) — apply Plan Step 3 verbatim.** Pre-draft the full additions block as ONE coherent extension covering S-03 country-parity check, S-06 permission-table emission, S-19 conflict-validation. Update the title-level "Run six structured refinement checks" line (current line 27) to "Run ten structured refinement checks" (or equivalent). Grow Completion Criteria block from 8 numbered items to 11. STOP for operator review (Plan Step 3) before applying. The plan's stop point already does this — confirm the apply step (Plan Step 7) is the same factored edit, not three independent hunks.

- **Coupling B (S-06 four-end contract) — at Plan Step 4 verification, verbatim-check all four ends.** The plan currently verifies "v3 blocking-gate semantics + 30%/40% thresholds + fail-safe present" in quality-standards.md (End 1). Extend the verification to: (a) cluster-memo-refiner Check N emits the canonical permission-table file path `analysis/claim-permission/{section}/{section}-cluster-NN-permission-table.md` matching the file-conventions row exactly (End 2 ↔ file-conventions); (b) section-directive-drafter reads from the same path (End 3 ↔ file-conventions); (c) the file-conventions row matches the v4 § S-06 line 452 example `1.1-cluster-01-permission-table.md` verbatim (End 4 row exists). Mismatches at any end break the producer-consumer chain silently — the run-synthesis Step 0 (line 28) reader will load nothing if End 2 writes to a different path than the file-conventions row declares.

- **Coupling C (vocabulary cascade in quality-standards.md) — Plan Step 4 sequencing is correct; add a verbatim grep after apply.** After all 5 sections are written, grep for `IN-LENS`, `PROXY-DOWNGRADE`, `NO-EVIDENCE`, `EVIDENCE-CEILING-REACHED`, `SUPPORTED`, `PROXY-SUPPORTED`, `ILLUSTRATIVE-ONLY`, `NOT-SUPPORTED` across the 5 sections; verify each consumer reference resolves to a producer definition earlier in the file. Existing Plan Step 4 verification list says "no internal contradictions" — make this verification concrete by enumerating the labels.

- **Coupling D (Bundle 2a inert-field ledger activation) — add explicit step before commit.** After Bundle 2b's S-06 lands, update or annotate the inert-fields ledgers at `reference/source-class-hierarchy.md` lines 130–139 and `reference/known-limits.md` lines 68–77 to reflect that evidence_date + freshness classes are now active (consumer landed via S-06). Without this update, operators reading those ledgers see stale claims that the fields are inert. One-line edit per ledger; do not delete the ledger entries (audit trail of when activation happened is useful).

- **Coupling F (file-conventions breadcrumb extension) — extend line 5 breadcrumb during Plan Step 5 apply.** The current breadcrumb at `reference/file-conventions.md` line 5 frames divergence as "Bundle 1 + 2a"; extend to "Bundle 1 + 2a + 2b" with the 3 new artifact families (claim-permission table, gate-clearance file if not already from Bundle 1, source-conflict log) named. Same pattern as Bundle 2a's breadcrumb application; do not silently inherit Bundle 2a's framing.

- **Reversibility (Dimension 4) — carry forward Bundle 2a's commit-message revert procedure pattern.** Name the revert sequence in both commit messages (ai-resources commit + project commit). Sequence: (1) noted: any per-cluster permission tables produced by downstream skill invocations after Bundle 2b lands persist beyond a revert; revert procedure should name the artifact path globs to clean (`analysis/claim-permission/{section}/*.md`, `analysis/source-conflicts/{section}/*.md`); (2) `git revert` each commit in its own repo; (3) note that Bundle 2a inert-field ledger updates also require manual undo because the activation premise reverses. Same posture as Bundle 2a's Mitigation C.

- **Hidden Coupling 3-stack stop-point adequacy (per operator's prompt question) — the plan's pre-draft + operator-review IS adequate provided the apply step (Step 7) re-uses the approved pre-draft verbatim, not a from-scratch re-draft.** Plan Step 7 says "Apply the consolidated cluster-memo-refiner edit — single factored edit per the Step 3 pre-draft" — this is correct posture. The failure mode would be: pre-draft approved, then Step 7 re-drafts and lands a different shape. Guardrail: Step 7 verification line "all 3 S-items represented in their pre-drafted form" — make this concrete by requiring the operator-approved pre-draft text to be preserved as the apply-step input (no re-judgment between approval and apply).

## Evidence-Grounding Note

All risk levels grounded in direct evidence:
- Session-plan read in full (110 lines).
- Session-notes read for the Bundle 2b mandate block (lines 414–423) and the cross-context for Bundle 2a (lines 425–478).
- v4 spec sections read in full for S-02 (lines 192–219), S-03 (lines 223–261), S-04 (lines 264–308), S-05 (lines 311–392), S-06 (lines 393–485 including v3 blocking-gate extension), S-07 (lines 488–517), S-13 (lines 877–908), S-19 (lines 1245–1302).
- v6 scope decision read in full (224 lines) — verified S-06's 30%/40% thresholds and fail-safe are locked decisions #8 + #9 at lines 197–198.
- audit-discipline.md read for risk-check class enumeration and two-gate model.
- All 9 in-scope edit targets confirmed to exist via Read of file headers + Bash line-count: cluster-memo-refiner 243 lines, quality-standards 122, file-conventions 150, research-prompt-creator 236, research-extract-creator 126, cluster-analysis-pass 160, execution-manifest-creator 131, section-directive-drafter 261, research-extract-verifier 185.
- Caller enumeration via grep across `ai-resources/workflows/` + `ai-resources/.claude/` — 7 caller files found; references counted per skill.
- run-analysis.md and run-synthesis.md gate-clearance Step 0 wiring read directly (run-analysis lines 13–28, run-synthesis lines 13–28) — confirmed already-live consumers of the gate-clearance file produced by Bundle 1's `/run-sufficiency`.
- Bundle 2a end-time gate read in full to inherit the inert-fields ledger and divergence breadcrumb postures (Couplings D + F).
- No training-data fallback used.

---

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

# Function B Pre-Change Advisory — Bundle 2b Plan-Time Gate Second Opinion

## Routing position

The change touches three canonical-home zones, all correctly routed:

- **7 ai-resources skill files** — canonical home per `repo-architecture.md` Q2/§ "Canonical homes by artifact type" (skills live at `ai-resources/skills/<name>/SKILL.md`). Extensions to existing skills, not new skills.
- **2 project reference docs** — correctly project-local; these encode research-pipeline methodology (Country-Coverage table, Claim-Permission Classes, Stop Conditions, Source-Conflict procedure) — methodology rules per `principles.md § DR-5` belong in reference docs, not CLAUDE.md, not workspace-shared. Promotion to `ai-resources/` fails the DR-7 test (`principles.md § DR-7 — Generalize only when a second confirmed consumer exists`): there is one consumer (this project's research pipeline). Correct to keep project-local.
- **Risk-check fired** — even though Bundle 2b's edit surface does not strictly trip a canonical structural change class per `repo-architecture.md § Q5` (no hook edit, no permission change, no CLAUDE.md edit, no new commands/skills/symlinks), the S-06 blocking-gate semantics qualify as "automation with shared-state effects" per `repo-architecture.md § Q5` and `principles.md § DR-8`. The operator's posture of running risk-check anyway is **correct per OP-3** (`principles.md § OP-3 — Loud failure over silent continuation`) — when in doubt about gate triggering, trip the gate.

## Concurrence with the PROCEED-WITH-CAUTION verdict

**We concur.** Dimension-by-dimension, the report is well-grounded; the verdict shape is right. Two layered architectural observations:

**1. The Hidden Coupling rating of High is correctly calibrated**, but it understates one structural feature: the S-06 blocking-gate is precisely the class of change that `principles.md § QS-9` (`Automation-produced system changes pass the same quality gates as operator-produced changes`) and `risk-topology.md § 3 ("automation with shared-state effects" — `/risk-check` required)` are designed for. The four-end string contract (Coupling B) is the canonical instance of `risk-topology.md § 5` ("Signals that elevate a change to structural risk: change modifies a string literal matched by another component (two-end contract)"). Here we have a **four-end** contract — quality-standards.md threshold values → cluster-memo-refiner producer path → file-conventions row → run-synthesis Step 0 reader. This is the strongest form of the pattern the risk-topology warns about. The mitigation set covers it via verbatim verification (Mitigation B), which is the right response. Concurrence: yes.

**2. The 6-mitigation set is the right path,** with one named gap noted below.

## Risk the dimension review missed — interaction between blocking-gate semantics and Bundle 1 / Bundle 2a

The risk-check report enumerates Coupling D (Bundle 2a inert-field activation) cleanly, but it under-states the **temporal-ordering risk between the live Bundle 1 gate-clearance contract and Bundle 2b's new producer-consumer additions**. Specifically:

- Bundle 1 already wired `/run-analysis` + `/run-synthesis` Step 0 to **refuse-to-run** when the `analysis/gate-clearance/{section}/{section}-gate-clearance.md` file is missing (fail-safe per v6 LD #9).
- Bundle 2b's S-06 adds a **second** read target — per-cluster permission tables at `analysis/claim-permission/{section}/{section}-cluster-NN-permission-table.md` — read by `run-synthesis` line 28.
- The fail-safe currently checks **only the gate-clearance file's presence**, not the permission tables' presence. The risk-check correctly notes this ("absence of permission tables (separate read target) is currently not checked").

This creates an **asymmetric blocking semantics gap**: after Bundle 2b lands, an operator running `/run-synthesis` will get the fail-safe refusal if `gate-clearance.md` is absent, but will get a **silent empty read** if the permission tables are absent (e.g., if a cluster memo was produced under a Bundle 2a-era cluster-memo-refiner that does not yet emit them). This violates `principles.md § OP-3 — Loud failure over silent continuation` directly. The plan does not currently address this.

The right answer is to **extend the Bundle 2b apply step to either**: (a) add a parallel fail-safe in `run-synthesis` Step 0 for permission-table absence (this is a `risk-topology.md § 3` "automation with shared-state effects" change of its own and warrants the same gate posture); or (b) accept the asymmetry explicitly as a known limit and log it in the Bundle 2a inert-field ledger update (Mitigation 4 already touches that ledger — extend that one-line edit to record the asymmetric-blocking known-limit). Option (b) is the lean choice (`principles.md § DR-7` and the v6 MVP scope discipline both favor it); option (a) is scope creep into Bundle 2c territory. **Recommended: option (b)** — extend Mitigation 4's ledger update to record this asymmetry as a known-limit so any operator running a synthesis pass between Bundle 2b land and a future Bundle 2c knows to verify permission-table presence manually.

A second under-emphasized interaction: the **R2 cluster memos already on disk** from any pre-Bundle-2b cluster-memo-refiner invocation are now structurally incomplete (no per-cluster permission table, no country-parity check entry, no conflict-validation entry) per the new Completion Criteria. The risk-check notes the Completion Criteria block must grow from 8 to 11 numbered items (Mitigation A) but does not name what happens to **already-produced memos that pre-date the new Criteria**. The pragmatic answer per `principles.md § OP-9` (paired-constraint: ambition does not license speculative re-work) is: do not retroactively re-refine R1 memos; the new Criteria apply forward only. **This should be stated explicitly in either the Bundle 2b commit message or the `quality-standards.md` Claim-Permission Classes section** so the eventual R2 cluster-memo run is the first under the new contract, and R1 memos are grandfathered. Without this clarification, the next operator session may interpret the new criteria as retroactive and trigger unnecessary re-refinement.

## Routing-context correction (minor but load-bearing)

The operator's brief states the `cluster-memo-refiner` 3-stack "auto-distributes via `auto-sync-shared.sh` to every project with a `shared-manifest.json` — so the edit lands in 8+ project workspaces on next session start." This **conflates two distribution mechanisms** and overstates the symlink propagation:

- Per `repo-architecture.md § Symlink topology` (lines 122–135), `auto-sync-shared.sh` syncs `ai-resources/.claude/{commands,agents}/*.md` into project `.claude/` directories. **It does not sync skills.**
- Per `repo-architecture.md § Canonical homes` (line 95), skills are "Read by reference; never copied."
- `cluster-memo-refiner` lives at `ai-resources/skills/cluster-memo-refiner/SKILL.md` — it is a **skill**, distributed via `--add-dir` visibility, not via symlink.

The blast-radius **conclusion** the operator drew is still correct (the edit is live for every project that invokes the research workflow on next session), but the **mechanism** matters for the revert model: there are no symlinks to clean up, and the edit is single-source-of-truth at the canonical path. Revert is `git revert` in `ai-resources/` and the change disappears from every consuming project on the next session start. This is **simpler** than the brief implies, not more complex.

## Sufficiency of Plan Step 3 pre-draft + operator review for the 3-stack coupling risk

**The plan's containment is sufficient — with one tightening.** Plan Step 3 (pre-draft consolidated factored shape) + Plan Step 7 (apply the same pre-drafted shape) + the explicit Stop Point at Step 3 is the canonical pattern for this risk shape, and it directly addresses both Coupling A (3-stack coherence) and Coupling E (six-check name drift). The risk-check's final Mitigation observation ("Guardrail: Step 7 verification line 'all 3 S-items represented in their pre-drafted form' — make this concrete by requiring the operator-approved pre-draft text to be preserved as the apply-step input") is the **load-bearing tightening**. Apply this verbatim. The failure mode it guards against — pre-draft approved, then Step 7 re-drafts from scratch and lands a different shape — is the specific instance of `principles.md § AP-1 — Silent conflict resolution` (the conflict here being "approved draft vs. fresh-judgment draft" silently resolved in favor of fresh judgment).

One additional concrete check for Step 7: after applying the consolidated edit, **grep the file for the count of `### Check N` headers** and confirm it equals 10 (7 pre-existing + 3 new). This is a 5-second mechanical verification that catches numbering collisions before they propagate into Completion Criteria misalignment. Concrete grep beats narrative verification per `principles.md § QS-3 — Verify output against requirements before announcing complete`.

## Position

The right answer is to **proceed with the plan as drafted, apply all 6 mitigations as specified, and add these two tightenings**:

1. **Extend Mitigation 4 (inert-field ledger activation) to also record the asymmetric blocking-semantics known-limit** — `gate-clearance.md` absence triggers fail-safe; permission-tables absence does not. This makes the known-limit visible to the next operator who runs `/run-synthesis` post-Bundle-2b. Lean alternative to building a parallel fail-safe now (`principles.md § DR-7`).

2. **State explicitly that the new Completion Criteria apply forward only** — R1-era cluster memos are not retroactively re-refined. Place this in either the Bundle 2b commit message or as a sentence in the new `quality-standards.md § Claim-Permission Classes` section. Prevents speculative re-work in the next session (`principles.md § OP-9` paired constraint; `principles.md § AP-7 — Speculative abstraction`).

The PROCEED-WITH-CAUTION verdict holds. The 6-mitigation set plus these 2 tightenings is the containment. The cluster-memo-refiner 3-stack pre-draft + operator-review stop point is **adequate** containment for the coupling risk provided Plan Step 7 preserves the operator-approved draft verbatim and adds the 10-check grep check.
