# Risk Check — 2026-05-26

## Change

END-TIME GATE for Bundle 2a (Scaffolding) — executed this session.

Bundle 2a landed all four scaffolding remediations (S-01, S-05, S-11, S-16) of the v6 source-pipeline workflow fix. The plan-time gate cleared with PROCEED-WITH-CAUTION (3 High dimensions: Blast radius, Reversibility, Hidden coupling) + 11 mitigations (A–K) + system-owner advisory with 3 additional risks (inert-fields ledger, project-side divergence breadcrumbs, gate-scope category error). This end-time gate evaluates the as-executed change set against the plan and the plan-time mitigations.

Executed change set:
- NEW project-side: `reference/source-class-hierarchy.md`, `reference/known-limits.md`, `execution/transaction-table/.gitkeep`
- EDITS project-side: `reference/file-conventions.md`, `reference/stage-instructions.md`
- NEW canonical: `ai-resources/skills/transaction-table-builder/SKILL.md`, `ai-resources/skills/chapter-revision-applier/SKILL.md`
- EDITS canonical: `research-prompt-creator/SKILL.md`, `cluster-memo-refiner/SKILL.md`, `evidence-to-report-writer/SKILL.md`, `research-extract-creator/SKILL.md`, `citation-converter/SKILL.md`, `workflows/research-workflow/.claude/commands/run-report.md`, `workflows/research-workflow/reference/stage-instructions.md`, `workflows/research-workflow/.claude/commands/run-execution.md`

Mitigations applied: A ✅, B ✅, C deferred to commit message, D ✅, E ✅, F ✅, G ✅, H ✅, I ✅, J + K heads-up only (Bundle 2b).

SO Risks applied: Risk 1 ✅, Risk 2 ✅, Risk 3 partially deferred (recommend amending the plan-time risk-check report header at end-time wrap).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/source-class-hierarchy.md — exists (created this session)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/known-limits.md — exists (created this session)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/file-conventions.md — exists (edited this session)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/stage-instructions.md — exists (edited this session)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/execution/transaction-table/.gitkeep — exists (created this session)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/transaction-table-builder/SKILL.md — exists (created this session)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/chapter-revision-applier/SKILL.md — exists (created this session)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-prompt-creator/SKILL.md — exists (edited this session)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/cluster-memo-refiner/SKILL.md — exists (edited this session)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/evidence-to-report-writer/SKILL.md — exists (edited this session)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-extract-creator/SKILL.md — exists (edited this session)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/citation-converter/SKILL.md — exists (edited this session)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/run-report.md — exists (edited this session)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/stage-instructions.md — exists (edited this session)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/run-execution.md — exists (edited this session)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-05-26-plan-time-gate-for-bundle-2-covers-both-bundle-2a-this.md — exists (plan-time gate carried forward)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/country-parity-checker/SKILL.md — exists (Bundle 1 reference for Mitigation D verification)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md — exists

## Verdict

**PROCEED-WITH-CAUTION**

**Summary:** The as-executed change set matches the plan-time gate's design with high fidelity — all 11 mitigations (A–K) and all 3 system-owner risks are addressed in the on-disk artifacts; the only residual is SO Risk 3 (plan-time-gate header amendment), pending. Dimension scoring remains stable from plan-time: Usage Cost Low, Permissions Low, Blast Radius High (mitigated), Reversibility High (mitigated), Hidden Coupling High (mitigated). No new structural risks surfaced during execution; the change is land-ready pending the dual commit + SO Risk 3 housekeeping.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The two new canonical skills (`transaction-table-builder/SKILL.md` 251 lines, `chapter-revision-applier/SKILL.md` 148 lines) live at `ai-resources/skills/` and are read on-demand by `/run-report` (line 92 reads `chapter-revision-applier`) and by `/run-execution` Step 2.3b (which the canonical `stage-instructions.md` line 47 marks "conditionally invocable"). Neither is auto-loaded via SessionStart or `@import`. Pay-as-used posture preserved.
- The two new project reference docs (`source-class-hierarchy.md` 148 lines, `known-limits.md` 84 lines) carry the standard "When to read this file" gating (file-conventions.md line 3 pattern) — loaded per-stage, not per-turn.
- Skill extensions (`research-prompt-creator`, `cluster-memo-refiner`, `evidence-to-report-writer`, `research-extract-creator`, `citation-converter`) are content additions inside files that are themselves on-demand loaded per pipeline step. Each was already on-demand; the additions add length within an already pay-as-used file.
- One row added to project `reference/file-conventions.md` (Bundle 2a divergence breadcrumb at line 5) and four new rows in the canonical naming table (lines 62, 63, 64, 66 — three S-16 + one S-05). Small additions to an already on-demand file.
- No new SessionStart, Stop, PreToolUse, or UserPromptSubmit hooks registered. No new `@import` chains.
- `.gitkeep` file at `execution/transaction-table/` is a 3-line directory placeholder — zero session cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No edits to any `.claude/settings.json` or `.claude/settings.local.json` in the executed change set (verified — change description lists no settings files; referenced-paths list contains zero settings paths).
- The two new skills operate within Read/Write patterns the research-workflow pipeline already authorizes. `transaction-table-builder` reads `execution/extracts/{section}/` + `execution/reports/{section}/` and writes `execution/transaction-table/{section}/...` — same shape as `research-extract-creator`. `chapter-revision-applier` reads `report/chapters/{section}/{section}-chapter-NN-draft.md` and writes `{section}-chapter-NN-revised.md` — same shape as `citation-converter`.
- No deny rule removed; no new MCP server; no external API access introduced. No shell command additions.
- `run-report.md` edit (S-16 integration at lines 65–105) is a behavior change inside an existing command — no new tool families authorized.

### Dimension 3: Blast Radius
**Risk:** High (mitigated)

**Files directly touched — verified on disk:**
- Canonical NEW (2): `ai-resources/skills/transaction-table-builder/SKILL.md`, `ai-resources/skills/chapter-revision-applier/SKILL.md`.
- Canonical EDIT (7): `research-prompt-creator/SKILL.md`, `cluster-memo-refiner/SKILL.md`, `evidence-to-report-writer/SKILL.md` (edited TWICE per plan — S-05 size-lens verification at lines 330–343 + S-16 footer block at lines 287–305 + draft-path note at line 287), `research-extract-creator/SKILL.md`, `citation-converter/SKILL.md`, `workflows/research-workflow/reference/stage-instructions.md` (Stage 2 four-pass restructure already from Bundle 1; Bundle 2a edits at lines 47, 127–133 for S-05/S-16 integration), `workflows/research-workflow/.claude/commands/run-report.md` (lines 65–105 for S-16 integration), `workflows/research-workflow/.claude/commands/run-execution.md` (line 7 deferral text flipped to "conditionally invocable").
- Project NEW (3): `reference/source-class-hierarchy.md`, `reference/known-limits.md`, `execution/transaction-table/.gitkeep`.
- Project EDIT (2): `reference/file-conventions.md` (Bundle 2a breadcrumb at line 5 + 4 new rows at lines 62–64, 66 + directory entry at line 110), `reference/stage-instructions.md` (Bundle 2a divergence breadcrumb at line 5).

**Edit-collision check (`evidence-to-report-writer` — Mitigation A):**
The plan-time gate flagged this file as the highest-collision risk because Bundle 2a stacks both S-05 (size-lens verification) and S-16 (footer block + draft-path) on it. Verified on disk:
- S-16 footer block at lines 287–305 (`§ Reviewer Findings Summary` section).
- S-16 draft-path note at line 287 (`{section}-chapter-NN-draft.md`).
- S-05 named-transaction size-lens verification at lines 330–343 (existence check + size-lens consistency rules + degraded-mode behavior).
- The two sections coexist without conflict. Mitigation A satisfied.

**Two-end string-literal contract check (`approved` / `-OPERATOR-APPROVED.md` — Mitigation B / E):**
Both ends verified on disk. `run-report.md` line 83 writes the marker file at `/report/chapters/{section}/{section}-chapter-NN-OPERATOR-APPROVED.md` when the operator reply contains `approved` (case-insensitive whole-word match, or first word — line 83). `citation-converter/SKILL.md` Step 0a (lines 57–87) reads the same marker filename pattern (line 62) and refuses to proceed if absent. Both files name the contract verbatim in inline text: `run-report.md` line 89 (`Two-end string-literal contract`) and `citation-converter/SKILL.md` line 87 (same heading). Atomic two-end contract satisfied.

**Chapter-output schema check (Mitigation F):**
Project `reference/file-conventions.md` confirmed to carry three S-16 rows at lines 62, 63, 64 (`{section}-chapter-NN-draft.md`, `{section}-chapter-NN-revised.md`, `{section}-chapter-NN-OPERATOR-APPROVED.md`) plus one S-05 row at line 66 (`{section}-transaction-table.md`). All four required new patterns added in one session.

**Deferral text flip (Mitigation G):**
Verified via grep: in `ai-resources/workflows/research-workflow/reference/stage-instructions.md`, the literal `Deferred` no longer appears against Step 2.3b. Line 47 now reads "*Conditionally invocable — runs when the project's `reference/source-class-hierarchy.md` exists and the project has named-transaction content in scope.*" In `ai-resources/workflows/research-workflow/.claude/commands/run-execution.md`, line 7 reads "...transaction-table build (Step 2.3b — conditionally invocable when the project has named-transaction content in scope)..." Both ends flipped to "active / conditionally invocable" language. Mitigation G satisfied.

**Cross-repo writes:** Yes — both `ai-resources/` AND `projects/nordic-pe-macro-landscape-H1-2026/` carry working-tree modifications. Dual commit pending. This is the same shape as Bundle 1 and within the explicitly-scoped change classes in `audit-discipline.md`.

### Dimension 4: Reversibility
**Risk:** High (mitigated)

- 2 new skill folders (`transaction-table-builder/`, `chapter-revision-applier/`) — `git revert` removes them cleanly because no skill output files have been generated yet (skills not invoked in this session). Once invoked downstream, working artifacts (`-revised.md`, `.archive/*-OPERATOR-APPROVED-{timestamp}.md`, `{section}-transaction-table.md`) would persist beyond a revert — but this is a future-state risk, not an as-executed one.
- 3 new project files (`source-class-hierarchy.md`, `known-limits.md`, `execution/transaction-table/.gitkeep`) — file creates under git, revert cleanly.
- 2 edited project files (`file-conventions.md`, `stage-instructions.md`) — diff revert cleanly.
- Mitigation C (revert procedure documentation in `logs/decisions.md`) is named as "deferred to commit message" in CHANGE_DESCRIPTION. The commit message must carry the revert sequence (delete revised files, delete `.archive/` subtree, delete `execution/transaction-table/{section}/` outputs, then `git revert`). This is the as-executed posture — Mitigation C is satisfied if the commit message names the procedure; otherwise it remains an outstanding mitigation. Recommend the operator verify the dual-commit messages name the revert procedure before push approval.
- Cross-repo revert dependency: revert of Bundle 2a requires reverting BOTH `ai-resources/` and `projects/nordic-pe-macro-landscape-H1-2026/` separately. Two commits in two repos → two revert operations. Same shape as Bundle 1.
- No state pushed beyond local repos. No automation registered that auto-fires between land and revert.

### Dimension 5: Hidden Coupling
**Risk:** High (mitigated)

All seven plan-time couplings (A–H, minus G which referenced Bundle 2b) were addressed in the executed change set. End-time verification:

**Coupling A — `## Project Country Set` schema match (Mitigation D):**
Verified by reading both ends.
- `ai-resources/skills/country-parity-checker/SKILL.md` lines 50–54 declare the schema: `target / region / region_superset / thinness_threshold / dominance_threshold`.
- `projects/nordic-pe-macro-landscape-H1-2026/reference/source-class-hierarchy.md` lines 118–122 carry the same five fields in the same order with the same default values (0.15 thinness, 0.60 dominance).
- Schema match verbatim. The project file also includes an explicit schema-reference breadcrumb at line 124 pointing operators back at the skill for any future schema change. Mitigation D satisfied.

**Coupling B — two-end string-literal contract:** see Dimension 3 above. Both ends carry inline "Two-end string-literal contract" annotations naming the atomic-edit requirement (`run-report.md` line 89; `citation-converter/SKILL.md` line 87). Mitigation E satisfied.

**Coupling C — chapter-output schema rows in file-conventions:** see Dimension 3 above. Four new rows added (3 S-16 + 1 S-05). Mitigation F satisfied.

**Coupling D — stage-instructions and run-execution deferral text flipped:** see Dimension 3 above. Mitigation G satisfied.

**Coupling E — cluster-memo claim-ID format (Mitigation H):**
Verified on disk. `cluster-memo-refiner/SKILL.md` lines 44–63 contain a new `## Claim-ID Format` section declaring `cluster-memo-refiner` as the canonical PRODUCER of IDs, the canonical format `{section}-cluster-NN-claim-NN`, the emission rule, the numbering scope (per-cluster, not per-section), and the merge-survivor stability rule. `transaction-table-builder/SKILL.md` lines 159–175 contain the matching `## Claim-ID Contract` section declaring itself a CONSUMER of the same format, with the `UNVERIFIED` placeholder for unfilled rows. Producer / consumer both name the canonical format and the producer-consumer relationship. Mitigation H satisfied.

**Coupling F — S-11 freshness-downgrade implementation site (Mitigation I):**
Verified on disk. `research-extract-creator/SKILL.md` lines 62–77 add the `evidence_date` field and the four freshness classes (`CURRENT` / `RECENT` / `BASELINE` / `STRUCTURAL`) and the `[FRESHNESS-MISMATCH]` flag-emission rule (line 77: "This skill emits the flag; it does NOT downgrade — downgrade is the consumer's job."). The downgrade-application site is named as deferred Bundle 2b (S-06's `claim-permission-gate`). The deferral is also captured in two inert-fields ledgers: `source-class-hierarchy.md` lines 130–139 and `known-limits.md` lines 68–77. Mitigation I satisfied — the freshness field lands inert in Bundle 2a, but the inertness is surfaced explicitly in both reference docs.

**Coupling H — HTML-comment marker conventions (operator discoverability):**
The plan-time gate flagged this as a discoverability gap. `run-report.md` lines 75–77 surface both markers (`<!-- improve: [idea] -->`, `<!-- KEEP -->`) in the operator-facing PAUSE prompt at Step 4.1b — the operator reads the convention exactly where they need to apply it. `chapter-revision-applier/SKILL.md` lines 132–138 also document the discoverability surface (Step 4.1b operator prompt + the chapter-draft `§ Reviewer Findings Summary` footer). Discoverability gap closed.

**SO Risks verification:**
- **SO Risk 1 (inert-fields ledger generalization):** Three on-disk locations verified — `source-class-hierarchy.md` lines 130–139 (ladder-depth thresholds + country-set thresholds), `known-limits.md` lines 68–77 (evidence_date + downgrade), `transaction-table-builder/SKILL.md` lines 202–211 (Claim supported + Size-lens cite check). Each ledger names the field, the activating bundle, and the manual-fill-in until activation. SO Risk 1 satisfied.
- **SO Risk 2 (project-side divergence breadcrumbs):** Four on-disk locations verified — `reference/stage-instructions.md` line 5 (project-side pinned to pre-Bundle-1 shape + pointer to `logs/decisions.md`), `reference/file-conventions.md` line 5 (canonical-vs-project divergence note + S-16/S-05 additions noted as project-direct), `reference/source-class-hierarchy.md` lines 143–147 (Project-Side Drift Note), `reference/known-limits.md` lines 81–83 (Project-Side Drift Note). SO Risk 2 satisfied.
- **SO Risk 3 (plan-time-gate scope amendment):** Not yet applied. CHANGE_DESCRIPTION explicitly lists this as "partially deferred — recommend amending the plan-time risk-check report header at end-time wrap." Outstanding housekeeping. Does not affect as-executed correctness, but should be applied before the session closes per the SO advisory; otherwise downstream operators may cite the plan-time gate as Bundle 2b's plan-time authorization.

## Mitigations

End-time mitigations (residual items the operator must apply before push approval):

- **Mitigation C (Reversibility — revert procedure):** The CHANGE_DESCRIPTION names Mitigation C as "deferred to commit message." Before push approval, verify that both commit messages (ai-resources + project) name the revert sequence explicitly: (1) delete any working files produced by Bundle 2a skills (none yet, but a future invocation would create `report/chapters/{section}/*-revised.md`, `.archive/*-OPERATOR-APPROVED-{timestamp}.md`, `execution/transaction-table/{section}/{section}-transaction-table.md`); (2) `git revert` each commit in its own repo; (3) note the cross-repo revert ordering (project first if any project-side files reference canonical artifacts — actual sequence depends on which side is reverted alone). Recommend a one-line pointer in `logs/decisions.md` to the commit hashes so the procedure is locatable.

- **SO Risk 3 (Hidden coupling — plan-time gate scope amendment):** Apply a one-line amendment at the top of `ai-resources/audits/risk-checks/2026-05-26-plan-time-gate-for-bundle-2-covers-both-bundle-2a-this.md` clarifying that the gate authorizes Bundle 2a design only; Bundle 2b requires its own plan-time gate after R2 production data lands. Without this, the gate's verdict header (line 47 "PROCEED-WITH-CAUTION") is ambiguous about which bundle's execution it authorizes. Apply before session closes, per the SO advisory.

- **Mitigation K (Cross-bundle — Bundle 2b end-time gate):** Heads-up only — when Bundle 2b executes (deferred to a later session after R2 production), it must run its own plan-time AND end-time `/risk-check`. This plan-time gate does NOT authorize Bundle 2b's execution; the SO Risk 3 amendment above closes the ambiguity.

## Evidence-Grounding Note

All risk levels grounded in direct evidence:
- Plan-time gate report read in full (236 lines).
- Two new SKILL.md files read in full (`transaction-table-builder` 251 lines, `chapter-revision-applier` 148 lines).
- Project-side new files read in full (`source-class-hierarchy.md` 148 lines, `known-limits.md` 84 lines, `.gitkeep` 3 lines).
- Project-side edited files read in full (`file-conventions.md` 151 lines, `stage-instructions.md` 172 lines).
- Canonical edited files read in full (`run-report.md` 113 lines, canonical `stage-instructions.md` 197 lines, `run-execution.md` line 7 verified via Read).
- Five canonical skill extensions read in full (`research-prompt-creator` lines 1–80 covering source-class hierarchy edit, `cluster-memo-refiner` 244 lines, `evidence-to-report-writer` 394 lines, `research-extract-creator` 127 lines, `citation-converter` 287 lines).
- Schema match (Coupling A) cross-verified between `country-parity-checker/SKILL.md` lines 50–54 (declared) and project `source-class-hierarchy.md` lines 118–122 (consumed) via grep — character-for-character match.
- Mitigation G (deferral-text flip) verified via grep: no `Deferred` referencing Step 2.3b in canonical `stage-instructions.md` or `run-execution.md`.
- Two-end contract (Mitigation E) verified by direct reads of both ends carrying the inline `Two-end string-literal contract` annotation.
- No training-data fallback used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

# Pre-Change Advisory — End-Time Gate, Bundle 2a (Scaffolding)

## Concurrence with PROCEED-WITH-CAUTION-mitigated

**We concur.** The end-time verdict is correct, and the dimension scoring is grounded in direct on-disk reads of every load-bearing artifact. The change is land-ready conditional on the three pre-commit actions.

The verdict is well-supported because:

1. **The two-end string-literal contract (Mitigation E) is genuinely atomic.** Both ends of the `approved` / `-OPERATOR-APPROVED.md` contract carry inline `Two-end string-literal contract` annotations in their own text. This is the canonical mitigation for the change class flagged in `risk-topology.md § 5`.
2. **The producer/consumer claim-ID contract (Mitigation H) is symmetric on disk.** Both `cluster-memo-refiner` (producer) and `transaction-table-builder` (consumer) name the canonical format `{section}-cluster-NN-claim-NN`. Textbook close on Hidden-Coupling dimension cross-file string contracts.
3. **Mitigation D schema match was verified character-for-character via grep.** Direct evidence of close, not inference.
4. **The inert-fields ledger (SO Risk 1) is documented in all three locations it needs to be**, with each entry naming the activating bundle. This neutralizes the silent-drift risk that AP-1 + AP-2 would otherwise create in Bundle 2b consumers.

## The three pre-commit actions — are they the right ones?

**Yes, and they are necessary, not optional.**

- **Action 1 — Mitigation C (revert procedure in both commit messages):** The right action. The revert procedure is *why* (a recovery path that the diff alone doesn't reveal — future skill outputs aren't in the diff), so it belongs in the commit message under QS-7's intent. Include a one-line pointer in `logs/decisions.md` naming the commit hashes.
- **Action 2 — SO Risk 3 (plan-time-gate header amendment):** The right action, and the most operationally consequential of the three. Without this, a downstream operator searching for "Bundle 2b plan-time authorization" will retrieve the existing report and reasonably conclude Bundle 2b is authorized — silent-conflict failure mode (`OP-3`, `AP-1`).
- **Action 3 — Mitigation K heads-up (Bundle 2b runs its own gates):** The right action. Two-gate firing model is per-change, not per-bundle.

## Execution-introduced risks the dimension review may have missed

**Risk E1 — Auto-sync window between dual commits.** Between commit A (ai-resources) and commit B (project), a concurrent session in `nordic-pe-macro-landscape-H1-2026` would see canonical skill instructions referencing project artifacts that don't yet exist on its side. **Mitigation:** commit the project side first if a concurrent nordic-pe session is open; commit either order if not. `DR-10` (no directory wildcards during concurrent sessions) is the canonical rule.

**Risk E2 — `evidence-to-report-writer` carrying two stacked S-edits in one Bundle.** Bundle 2b is likely to stack again on the same file. `DR-7` (generalize only when a second confirmed consumer exists) implies that if Bundle 2b plans a third stacked edit, the appropriate next step is to factor the file, not stack a third time. **Surface in Bundle 2b heads-up.**

**Risk E3 — Two new skills land inert until first invocation.** Both new skills are read-by-reference and conditionally invocable. The first invocation of each is effectively a runtime QC pass. Operator awareness: if either skill misbehaves at first invocation, classify the failure (`AP-9`) and route to the right fix, not patch in-flight.

## Position

**Apply all three pre-commit actions before commit, then commit both repos in single-commit-per-repo posture.** Bundle 2b heads-up should additionally name Risk E2 (stacked-edits warning on `evidence-to-report-writer`).
