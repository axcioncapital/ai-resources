# Risk Check — 2026-05-26

## Change

**Bundle 1 of Phase B execution — slimmed-S-10 + S-12 plan-time gate.**

Two paired remediations to be landed together (per v6 § Slimmed Risk-Check Bundles → Bundle 1):

- **S-10 (slimmed):** Stages 2–3 four-pass architectural restructure. Rewrites `reference/stage-instructions.md` Stages 2–3 sections around a four-pass model (Discovery → Extraction → Sufficiency → Synthesis). Edits 4 existing commands (`run-execution`, `run-cluster`, `run-analysis`, `run-synthesis`). Creates 1 new command (`run-sufficiency`, Opus, 5-phase: A claim-permission → C country-parity → D stop-conditions → E source-conflict → F gate-clearance — Phase B counter-search dropped because S-08 is v6-deferred). Creates 3 new skills (`source-class-mapper` Sonnet, `country-parity-checker` Sonnet, `claim-permission-gate` Opus); `transaction-table-builder` is a Bundle-2 / S-05 target and is confirm-only in Bundle 1 (do not create twice); `counter-search-runner` dropped entirely. Stage-instructions Pass 2 spec drops the "Memo bucket structure applied (S-14)" line; Pass 3 spec drops the "Monitoring-vs-catalyst classification (S-15)" line.
- **S-12:** Evidence-First Principle. Adds new top-level section "Evidence-First Principle (Project Operating Rule)" to `quality-standards.md` (placed first, above Evidence Calibration). Edits `research-prompt-creator/SKILL.md` to prefix every research prompt with a short preamble citing the principle. Adds a one-line pointer in project `CLAUDE.md` Project Context section.

Bundle 1 `/run-sufficiency` ships with pre-flight checks that reference Bundle-2 reference docs (`reference/source-class-hierarchy.md` from S-01; `reference/known-limits.md` from S-11) — invocable-but-blocked until Bundle 2 lands.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/report/diagnostics/1.1/1.1-source-pipeline-workflow-fix-proposal-v4-2026-05-26.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/stage-instructions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/run-execution.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/run-cluster.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/run-analysis.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/run-synthesis.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/run-sufficiency.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/source-class-mapper/SKILL.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/country-parity-checker/SKILL.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/claim-permission-gate/SKILL.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/transaction-table-builder/SKILL.md — not yet present (S-05/Bundle-2 target)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/quality-standards.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-prompt-creator/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/source-class-hierarchy.md — not yet present (S-01/Bundle-2 target)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/known-limits.md — not yet present (S-11/Bundle-2 target)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/SKILL.template.md — not yet present

## Verdict

**PROCEED-WITH-CAUTION**

**Summary:** Bundle 1 lands large coupled architectural changes (4 command rewrites + 1 new command + 3 new skills + reference-doc rewrite + always-loaded project CLAUDE.md edit) and ships with a known invocable-but-blocked state for `/run-sufficiency` until Bundle 2 lands — three Mediums and one High, all with viable paired mitigations.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- S-12 adds a one-line pointer to project `CLAUDE.md` Project Context section (lines 3–15) — project CLAUDE.md is always-loaded; one line is ~25–40 tokens of permanent cost per session. Low marginal cost. Evidence: `projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md` lines 3–15 show the Project Context section the pointer will land at the end of.
- S-12 adds a new top-level section "Evidence-First Principle (Project Operating Rule)" to `reference/quality-standards.md` containing the operator's two-paragraph verbatim instruction — quality-standards.md is read on-demand (per the file's own line 3 "When to read this file" tag), not always-loaded, so the cost is per-stage, not per-turn. Current quality-standards.md is 72 lines (ai-resources canonical) / 9650 bytes (project copy). The new section adds ~10–15 lines.
- S-12 prefixes every research prompt with a project-level preamble (verbatim per v4 line 863). Cost lands once per prompt construction in Step 2.1, not per session. `research-prompt-creator/SKILL.md` is already 222 lines; new preamble adds 1–2 lines of standing skill instruction plus a constant per-prompt prefix.
- S-10 enlarges `stage-instructions.md` (155 lines today) via "major rewrite of Stages 2–3 sections" — stage-instructions.md is on-demand per its own header (line 3), not always-loaded; cost is per-stage-transition, not per-turn.
- New `/run-sufficiency` command (Opus tier per v4 frontmatter, line 729) is invoked per section, on demand — pay-as-used, no always-loaded cost.
- 3 new skills are invoked from `/run-sufficiency` only (Pass 3) — pay-as-used per Stage 3 run.
- No new SessionStart / Stop / PreToolUse hooks. No @import chains added.

### Dimension 2: Permissions Surface
**Risk:** Low

- No edits to any `.claude/settings.json` or `.claude/settings.local.json` declared in CHANGE_DESCRIPTION.
- No new Bash, Write, or Read globs requested. New skills (`source-class-mapper`, `country-parity-checker`, `claim-permission-gate`) and the new `/run-sufficiency` command all operate within existing read/write patterns already authorized for the research-workflow pipeline (read from `analysis/{section}/`, `preparation/`, `execution/`; write to `analysis/{family}/{section}/` and sentinel files in `analysis/{section}/`).
- No deny rule removed; no MCP server added; no external API access introduced.

### Dimension 3: Blast Radius
**Risk:** High

**Files directly edited or created (Bundle 1, ai-resources side):**
1. `ai-resources/workflows/research-workflow/reference/stage-instructions.md` — major rewrite of Stages 2–3 sections (current file: 155 lines)
2. `ai-resources/workflows/research-workflow/.claude/commands/run-execution.md` — edit (Pass 1 + Pass 2 framing)
3. `ai-resources/workflows/research-workflow/.claude/commands/run-cluster.md` — edit (Pass 3 cluster analysis framing)
4. `ai-resources/workflows/research-workflow/.claude/commands/run-analysis.md` — edit (Pass 4 + gate-clearance pre-flight)
5. `ai-resources/workflows/research-workflow/.claude/commands/run-synthesis.md` — edit (Pass 4 + gate-clearance pre-flight)
6. `ai-resources/workflows/research-workflow/.claude/commands/run-sufficiency.md` — NEW (Opus, 5 phases)
7. `ai-resources/skills/source-class-mapper/SKILL.md` — NEW (Sonnet)
8. `ai-resources/skills/country-parity-checker/SKILL.md` — NEW (Sonnet)
9. `ai-resources/skills/claim-permission-gate/SKILL.md` — NEW (Opus)
10. `ai-resources/workflows/research-workflow/reference/quality-standards.md` — edit (new Evidence-First Principle top section)
11. `ai-resources/skills/research-prompt-creator/SKILL.md` — edit (preamble injection)
12. `projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md` — edit (Project Context pointer)

Twelve artifacts in a single bundle. v4 line 774 self-declares Bundle 1 as "Major rewrite + 4 command rewrites + 5 new sub-agent roles. **HIGH BLAST RADIUS.** Per leverage: HIGHEST (foundational)." Slimming reduces the new sub-agent role count from 5 to 3 but leaves the "major rewrite + 4 command rewrites" surface intact.

**Caller enumeration (where the edited components are referenced):**

- `stage-instructions.md` is referenced from project `CLAUDE.md` line 29 and the canonical research-workflow template. Grep hits across `ai-resources/` and `projects/`: 30+ references in audits, logs, project CLAUDE.md, project reference/, and the diagnostic v1–v6 plan files. Active callers (non-audit): project `CLAUDE.md`, the four `/run-*` commands, and the project's local `reference/stage-instructions.md` copy (23209 bytes, regular file).
- `quality-standards.md` is referenced from project `CLAUDE.md` line 31, several skill SKILL.md files (`gap-assessment-gate`, `cluster-memo-refiner`, `chapter-prose-reviewer`, `evidence-to-report-writer`), and the four pipeline `/run-*` commands. The same file is also a Bundle 2 edit target (S-02, S-03, S-06, S-07, S-13, S-19 all add new sections). Two-edit-pass on the same file across bundles.
- `research-prompt-creator/SKILL.md` is called by `/run-execution` Step 2.1 (verified: `run-execution.md` line 39). Single primary caller plus downstream skills that consume its output (`research-extract-creator`, `research-prompt-qc`).
- `run-execution.md`, `run-cluster.md`, `run-analysis.md`, `run-synthesis.md` are the project's primary Stage 2/Stage 3 pipeline. Editing all four simultaneously in the same bundle widens the regression surface.

**Critical project-deployment finding:**
The Nordic-PE project's `.claude/commands/run-*.md` are **regular files, not symlinks** (verified: `projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/run-execution.md` is a 16709-byte regular file dated May 12; `run-cluster.md` 2977 bytes; `run-analysis.md` 12653 bytes; `run-synthesis.md` 1703 bytes). Same pattern for `projects/nordic-pe-macro-landscape-H1-2026/reference/stage-instructions.md` (23209 bytes regular file) and `reference/quality-standards.md` (9650 bytes regular file). Bundle 1 edits to `ai-resources/` will **NOT** automatically propagate to the running project. The operator (or a `/sync-workflow` pass — verified present at `ai-resources/.claude/commands/sync-workflow.md`) must explicitly sync. This is an additional blast-radius dimension: Bundle 1 also implies a project-side sync step or the changes are inert in the project that prompted them.

**Contract changes:**
- New gate-clearance artifact contract: `/run-analysis` and `/run-synthesis` will fail-exit if gate-clearance file is missing (per v4 line 768, "Locked behavior: fail-safe / refuse-to-run is the default"). This is a not-backwards-compatible contract change for any pipeline run between Bundle 1 land and the first `/run-sufficiency` execution. Old `/run-cluster` → `/run-analysis` flow without `/run-sufficiency` is now broken.
- New sentinel-file contract (`.{phase}.done` markers in `analysis/{section}/`) introduces operator responsibility for cleanup — v4 line 761 explicitly notes "command does NOT auto-clean stale sentinels — that's the operator's responsibility."

**Backwards-compatibility verdict:** Bundle 1's Pass 4 gate is fail-safe. Any in-progress Stage 3 work that has not yet produced a gate-clearance file will be blocked on `/run-analysis` and `/run-synthesis` after Bundle 1 lands. Per phase B0 verification context: R1 has shipped; the v4 plan itself notes Bundle 1 lands FIRST and all other remediations land inside the restructured architecture. The 21 unpushed commits in the project are diagnostic/plan files (v2–v6 of the source-pipeline-fix proposal), not in-flight Stage 3 analysis state — they will not be regressed by Bundle 1 because they don't depend on the pipeline commands' contract.

### Dimension 4: Reversibility
**Risk:** Medium

- 9 of 12 artifacts are file edits or new files under git — clean `git revert` of the Bundle 1 commit fully restores prior state for those files (ai-resources side).
- Project CLAUDE.md edit reverts cleanly via git.
- However: if the operator runs `/sync-workflow` to push Bundle 1 into the Nordic-PE project's `.claude/commands/` and `reference/` directories (which are file-copies, not symlinks — see Dimension 3), the project-side copies become a second revert target. `git revert` of Bundle 1 in `ai-resources/` does NOT undo the project-side copies — operator must also revert the project-side changes or re-run `/sync-workflow` to repropagate the reverted state.
- If `/run-sufficiency` has been invoked at least once between Bundle 1 land and a revert, sentinel files (`.claim-permission-gate.done` etc.) and per-phase output artifacts (`analysis/claim-permission/{section}/`, `analysis/country-parity/{section}/`, `analysis/gate-clearance/{section}/`, `analysis/stop-conditions/{section}/`, `analysis/source-conflicts/{section}/`) will exist on disk. `git revert` of the command/skill files does not delete those generated artifacts — they remain as orphan state. Operator cleanup needed.
- No state pushed beyond the local repo (no remote push, no Notion write, no external API call introduced by Bundle 1 itself). Push is gated on operator approval per workspace Autonomy Rule #2.
- No hook auto-registration that could fire between change-land and revert.

### Dimension 5: Hidden Coupling
**Risk:** High

**Coupling 1 (declared, intended — Bundle 2 sequencing):**
`/run-sufficiency` pre-flight (per v4 line 737) verifies `reference/source-class-hierarchy.md` (S-01, Bundle 2) and `reference/known-limits.md` (S-11, Bundle 2) exist. Both are absent in Bundle 1. The command's documented failure mode is exit-with-remediation-prompt — which means the new command is invocable-but-blocked between Bundle 1 land and Bundle 2 land. The operator-facing surface during this window: anyone who runs `/run-sufficiency` gets "missing reference doc" exit. This is documented behavior, not silent breakage, but it creates a soft-broken state in the live pipeline that lasts until Bundle 2.

**Coupling 2 (induced by slimming — counter-search removal):**
v4 line 677 states the design principle: *"The same agent that finds evidence should not be the only agent judging whether the evidence is sufficient. The 5 new roles enforce this by splitting evidence acquisition (source-class-mapper, transaction-table-builder) from sufficiency adjudication (country-parity-checker, claim-permission-gate, counter-search-runner)."* Slimming drops `counter-search-runner` from the sufficiency-adjudication trio. The claim-permission-gate (Phase A) classifies claims as SUPPORTED / PROXY-SUPPORTED / ILLUSTRATIVE-ONLY / NOT-SUPPORTED. In v4's design, `counter-search-runner` (Phase B) then runs disconfirming-evidence search on SUPPORTED claims and downgrades where disconfirmation surfaces (v4 line 718). Without Phase B, every SUPPORTED claim flows to Pass 4 synthesis without disconfirmation pressure. The structural separation principle (find vs judge) is preserved (the same agent that found evidence is not the one that judges it), but the disconfirmation half of sufficiency adjudication is missing. This is not a structural break of the claim-permission gate — the gate still produces a verdict — but it materially weakens the "is this enough?" question by removing the "but is there contradicting evidence?" half. Operator-facing risk: SUPPORTED claims flowing through to chapter drafts that a counter-search would have downgraded. Until Bundle 2 (which is not yet specified to include S-08), this gap is permanent.

**Coupling 3 (silent contract dependency — sentinel files):**
v4 line 720 notes sentinels "deliberately do not follow the canonical `analysis/{family}/{section}/` pattern — they are ephemeral, gitignored, and must be glob-deletable via `analysis/{section}/.*.done`." This requires (a) gitignore patterns in projects to include `analysis/{section}/.*.done`, and (b) operator awareness of sentinel-cleanup discipline for re-runs (v4 line 761). Neither is mentioned as a Bundle 1 deliverable — and gitignore changes are not in the Bundle 1 edit surface listed in CHANGE_DESCRIPTION. If sentinels get committed by mistake (no gitignore entry), the project gets noisy diffs; if operator doesn't clean sentinels, re-runs silently skip phases.

**Coupling 4 (two-bundle edit on same file — `quality-standards.md`):**
S-12 lands "Evidence-First Principle" section first (above Evidence Calibration). Bundle 2 will land six more sections (S-02 No-Source-Substitution, S-03 Country-Parity, S-06 Claim-Permission extension, S-07 Source-Diversity, S-13 Stop Conditions, S-19 Source-Conflict). Two separate authoring passes on the same file means: (a) Bundle 2 must read Bundle 1's post-edit version (not the baseline) when authoring its sections, (b) document-structure decisions made in Bundle 1 (section ordering, heading levels, prose voice) implicitly constrain Bundle 2. Risk: if Bundle 2 is authored against the baseline by mistake, sections collide or the Evidence-First Principle is silently demoted. Mitigation requires explicit Bundle 2 authoring instruction to re-read post-Bundle-1 state.

**Coupling 5 (project-side file-copies not symlinks):**
The Nordic-PE project has file-copies of `run-*.md` and `reference/` docs — not symlinks. Bundle 1 implicitly assumes the operator will sync (via `/sync-workflow` or manual copy). If the operator forgets, the canonical template diverges from the running project — exactly the drift `/sync-workflow` exists to detect. This is silent unless the operator runs `/sync-workflow` after Bundle 1.

**Coupling 6 (transaction-table-builder confirm-only):**
CHANGE_DESCRIPTION states Bundle 1 should "confirm-only" the `transaction-table-builder` SKILL since it's a Bundle 2 / S-05 target. v4 line 693 explicitly says "Do not create a new skill folder." But Bundle 1's Pass 2 spec in stage-instructions.md references `transaction-table-builder runs (S-05)` as part of the four-pass model. Operator-facing risk: Pass 2 spec mentions a skill that does not yet exist on disk between Bundle 1 land and Bundle 2 land. Same invocable-but-blocked pattern as Coupling 1, but for Pass 2 rather than `/run-sufficiency`.

## Mitigations

- **Mitigation for Dimension 3 (Blast Radius) — project-side sync:** Immediately after committing Bundle 1 in `ai-resources/`, run `/sync-workflow projects/nordic-pe-macro-landscape-H1-2026` and inspect the dry-run report. Apply the proposed updates to the project's `.claude/commands/` and `reference/` directories in the same operator session. Otherwise, the canonical template diverges from the running project and Bundle 1 is inert in the project that prompted it.

- **Mitigation for Dimension 3 (Blast Radius) — contract-change announcement in commit message:** The Bundle 1 commit message must call out the fail-safe gate on `/run-analysis` and `/run-synthesis` ("after Bundle 1, these commands require a gate-clearance file from `/run-sufficiency`; without it they exit"). Operator memory becomes the dependency; making it visible in git log reduces the risk of stale `/run-analysis` invocations producing surprising exit-with-prompt behavior.

- **Mitigation for Dimension 5 (Hidden Coupling) — Bundle-2 prerequisite documented in `/run-sufficiency` itself:** The pre-flight check at Step 0 of `run-sufficiency.md` must emit, in its exit-with-prompt message, the explicit text "This command requires Bundle 2 (S-01 + S-11 reference docs) to be landed before it can run. See `report/diagnostics/1.1/1.1-source-pipeline-workflow-fix-proposal-v6-mvp-scope-decision-2026-05-26.md` § Bundle 2." This converts the soft-broken window into an unambiguous operator-facing remediation pointer.

- **Mitigation for Dimension 5 (Hidden Coupling) — counter-search gap documented at the claim-permission-gate skill level:** `ai-resources/skills/claim-permission-gate/SKILL.md` must include a top-of-file note that SUPPORTED verdicts in this slimmed-Bundle-1 build are NOT disconfirmation-tested (because S-08 counter-search-runner is deferred). This documents the weakened gate's known limitation so any operator reading the skill in isolation understands the scope. Optional: add an output-table column "disconfirmation_tested: false" so the limitation is visible in every per-claim row of the gate's output artifact.

- **Mitigation for Dimension 5 (Hidden Coupling) — gitignore entry for sentinels:** Bundle 1 must include a one-line addition to the project's `.gitignore`: `analysis/*/.*.done`. This prevents sentinel files from being accidentally committed and keeps the re-entry semantics clean.

- **Mitigation for Dimension 5 (Hidden Coupling) — quality-standards.md two-pass note:** The Bundle 2 spec (when implementer picks it up) must include an explicit step to read the post-Bundle-1 version of `quality-standards.md` as the baseline for the Bundle 2 edits, not the pre-Bundle-1 baseline. Recommended: add a one-line comment at the top of `quality-standards.md` in Bundle 1 noting "Bundle 2 adds: S-02, S-03, S-06, S-07, S-13, S-19 sections — see v6 plan for placement." This creates a visible bread-crumb for Bundle 2 authoring.

- **Mitigation for Dimension 5 (Hidden Coupling) — Pass 2 stage-instructions deferral note:** The Pass 2 spec in `stage-instructions.md` must explicitly note "transaction-table-builder runs (S-05 — lands in Bundle 2; until Bundle 2, this Pass 2 step is skipped)." This converts another silent invocable-but-blocked into an unambiguous documented deferral.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: line references to v4 (lines 580–873 read), line references to current `stage-instructions.md` (155 lines), `quality-standards.md` (72 lines canonical / 9650 bytes project), `research-prompt-creator/SKILL.md` (222 lines), the four `/run-*.md` commands (read in full), and project `CLAUDE.md` Project Context section (lines 3–15). Project-side file-vs-symlink status verified via `ls -la` on `projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/` and `projects/nordic-pe-macro-landscape-H1-2026/reference/`. Sync-workflow command presence verified via grep + `Read` of `ai-resources/.claude/commands/sync-workflow.md`. No training-data fallback was used.

---

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

# Pre-Change Advisory — Bundle 1 (slimmed-S-10 + S-12)

## Concurrence with PROCEED-WITH-CAUTION

We concur with the verdict. Three Mediums and one High in a single bundle that lands four canonical command edits, a new canonical command, three new skills, a workflow reference-doc rewrite, and a project CLAUDE.md edit is exactly the change shape DR-8 contemplates as gated (`principles.md § DR-8`), and the High in Hidden Coupling is structurally correct — Bundle 1 ships an invocable-but-blocked `/run-sufficiency` whose unblock dependency lives in a separate bundle. That is two-end-contract territory (`risk-topology.md § 5 — signals that elevate structural risk: "Change modifies a string literal matched by another component"`), and it's the kind of coupling that historically fails silently.

The reviewer's top concern — slimming dropped `counter-search-runner`, so SUPPORTED claims reach Pass 4 without disconfirmation pressure — is the right concern to surface. The principle at stake is OP-3 (loud failure over silent continuation) and QS-4 (evidence and interpretation separated; gaps marked, not filled). A claim-permission gate that grants permission without disconfirmation testing is structurally a weaker gate than the one S-08 was designed to produce. The structural separation principle is preserved, but the enforcement strength is degraded. Mitigation #4 (the SKILL.md top-of-file note) records the degradation; it does not close it. We accept that gap because closing it requires S-08, which v6 deferred — but the gap should be tracked, not normalized.

## The 7 paired mitigations — assessment

The mitigation set is the right shape. Specific notes per item:

**Mitigation 1 (`/sync-workflow` immediately after commit).** Necessary, not optional. Project-side `.claude/commands/run-*.md` and `reference/` are file-copies, not symlinks (`repo-architecture.md § Symlink topology` confirms workflow templates are NOT auto-symlinked to projects — they land as file-copies via `/deploy-workflow` and `/sync-workflow`). Without this, Bundle 1 is inert in the project that prompted it — that's a silent failure mode (AP-1 / OP-3). Strengthening: commit Bundle 1 and run `/sync-workflow projects/nordic-pe-macro-landscape-H1-2026` as a single operator gesture, not two separate steps the operator might forget to chain.

**Mitigation 2 (commit message names the fail-safe gate).** Right. QS-7 (commit messages explain *why*). The fail-safe gate is the *why* — it is what makes the High in Hidden Coupling tolerable rather than dangerous.

**Mitigation 3 (`/run-sufficiency` Step 0 names Bundle 2 as unblock).** Right. This is OP-3 made concrete: the invocable-but-blocked state must announce itself loudly when invoked. Strengthening: the exit message should name the specific Bundle 2 items (S-01 + S-11) AND the date Bundle 2 is expected to land — a dangling "Bundle 2 pending" with no horizon decays into permanent debt.

**Mitigation 4 (`claim-permission-gate/SKILL.md` top-of-file note on SUPPORTED-not-disconfirmation-tested).** Necessary but weak by itself. A SKILL.md note is read by the agent at invocation but does not propagate to anyone reading the skill's *outputs* downstream. Strengthening: the gate's emitted artifact (whatever file or memo records a gate verdict) should carry the same disclaimer inline — so a future reader of a SUPPORTED claim in a Pass 4 synthesis sees that it was permitted under the slimmed regime, not the full regime. Otherwise the note degrades to local knowledge that the operator forgets in three weeks.

**Mitigation 5 (`.gitignore` for `analysis/*/.*.done` sentinels).** Right. Standard hygiene. Low-risk.

**Mitigation 6 (`quality-standards.md` breadcrumb listing deferred Bundle 2 sections).** Right and load-bearing. This is the documentation-side equivalent of mitigation 3 — the deferred surface must announce itself in the document the operator and downstream agents read. Without it, six months from now a reader of `quality-standards.md` will read the slimmed version as canonical and not know S-02/S-03/S-06/S-07/S-13/S-19 were ever planned. AP-1 (silent conflict resolution) at the document layer.

**Mitigation 7 (Pass 2 spec notes `transaction-table-builder` deferred).** Right. Same reasoning as #6 — Pass 2 must announce its own incompleteness rather than presenting a skipped step as if it were complete.

## Risks the dimension review missed

Three risks the 7 mitigations do not cover:

**1. `ai-resources/.claude/commands/run-sufficiency.md` auto-symlinks into every project, not just the prompting project.** The auto-sync hook walks every project with `.claude/shared-manifest.json` and symlinks `ai-resources/.claude/commands/*.md` into each (`repo-architecture.md § Symlink topology`). `/run-sufficiency` will appear as an invocable command in *all 7 active projects* on next SessionStart — not just `nordic-pe-macro-landscape-H1-2026`. In projects that are not running the slimmed research workflow (most of them), invoking `/run-sufficiency` will hit Step 0 and exit with the Bundle 2 message — which is misleading, because Bundle 2 doesn't apply to projects that aren't running this workflow at all. Mitigation: either add `/run-sufficiency` to the `EXCLUDE_COMMANDS` list in `auto-sync-shared.sh`, OR make Step 0 detect "is this project running the slimmed-Bundle-1 research workflow?" before emitting the Bundle 2 dependency message, OR add `run-sufficiency` to each non-research project's `shared-manifest.json` opt-out list. The cleanest option is the exclusion-list path because it matches how the hook already handles workflow-meta commands.

**2. The workflow template's `reference/` directory rewrite affects the template, not the deployed copies in other projects.** `repo-architecture.md` is explicit: workflow templates are NOT auto-symlinked — projects hold file-copies. If any OTHER project has previously deployed `research-workflow` via `/deploy-workflow`, that project's `reference/stage-instructions.md` and `reference/quality-standards.md` are now stale relative to the template. Mitigation 1 covers `nordic-pe-macro-landscape-H1-2026` specifically. The risk-check did not surface what happens to other deployments. The operator should confirm: is `nordic-pe-macro-landscape-H1-2026` the only project running `research-workflow`? If so, the risk is null. If not, mitigation 1 must extend to those projects, OR they should be explicitly excluded from sync until they're ready for Bundle 1. (`repo-state.md § 1` lists `nordic-pe-landscape-mapping` as on Step 1 — that's a different project name but worth disambiguating.)

**3. Bundle 1 introduces three new skills without confirming each meets QS-6 completeness.** QS-6 is explicit: a skill is complete when its SKILL.md frontmatter is fully populated (`name`, `description`, `model`, `trigger`, `when_to_use`, behavioral instructions) AND it has passed the `/create-skill` canonical pipeline (DR-2). The bundle description names the three skills as being created but does not confirm they will go through `/create-skill`. If they are improvised inline as part of the bundle rollout, that's AP-5 (improvised AI resources). The Bundle 1 plan should explicitly state: each new skill is created via `/create-skill` before commit, or the bundle is rejected.

## Position

The right answer is: proceed with the 7 paired mitigations, *and* add the three coverage extensions above (auto-sync exclusion for `/run-sufficiency`, confirm `research-workflow` deployment scope, route the three new skills through `/create-skill`). The reviewer's PROCEED-WITH-CAUTION verdict is correct; the mitigation set is the right *shape* but has a coverage gap at the boundary between `ai-resources/` (where the bundle lands) and the rest of the workspace (which inherits the bundle whether it wants it or not).

The dropped-disconfirmation concern is genuine and not fixable in Bundle 1 — accept the degradation, document it loudly per mitigation #4 (strengthened to propagate to gate outputs, not just SKILL.md), and treat S-08 as a non-negotiable Bundle 2 dependency. Do not let Bundle 2 slip on S-08 specifically without re-opening this risk-check.

---

**Grounding sources cited:** `principles.md § DR-8`, `principles.md § OP-3`, `principles.md § QS-4`, `principles.md § QS-6`, `principles.md § QS-7`, `principles.md § DR-2`, `principles.md § AP-1`, `principles.md § AP-5`, `risk-topology.md § 5 (signals elevating to structural risk)`, `repo-architecture.md § Symlink topology`, `repo-architecture.md § Canonical homes by artifact type`, `repo-state.md § 1`.
