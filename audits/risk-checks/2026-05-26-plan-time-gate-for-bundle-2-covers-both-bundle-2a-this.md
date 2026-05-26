# Risk Check — 2026-05-26

> **SCOPE AMENDMENT (2026-05-26, post-execution, per SO Risk 3 from the end-time gate).** This report authorizes **Bundle 2a ONLY** at plan-time. Bundle 2b is **cross-referenced for visibility** — to surface cross-bundle structural risks during Bundle 2a's design — but is **NOT authorized** by this report. Per `audit-discipline.md` two-gate firing model (per-change, not per-bundle-of-changes), Bundle 2b's execution requires its own plan-time `/risk-check` gate after R2 production data lands, in addition to its own end-time gate. Downstream operators citing this report for Bundle 2b authorization should treat the citation as invalid and run a fresh Bundle 2b plan-time gate. See also the corresponding end-time report at `2026-05-26-end-time-gate-for-bundle-2a-scaffolding-executed-this.md`.

## Change

PLAN-TIME GATE for Bundle 2 (covers both Bundle 2a — this session — and Bundle 2b — deferred to a later session — in one gate, per the Bundle 2a mandate).

**Proposed structural change:** Execute the full 11-item Bundle 2 surface of the v6 source-pipeline workflow fix plan against the canonical research-workflow library and this project. Per v4 per-item spec at `projects/nordic-pe-macro-landscape-H1-2026/report/diagnostics/1.1/1.1-source-pipeline-workflow-fix-proposal-v4-2026-05-26.md`.

Bundle 2a (executing this session — scaffolding tier):
- S-01: NEW project reference doc `reference/source-class-hierarchy.md` (with `## Project Country Set` section consumed by `country-parity-checker` Bundle 1 sub-agent) + EXTEND canonical `ai-resources/skills/research-prompt-creator/SKILL.md` (prompts must name target source class + order fallbacks)
- S-05: NEW canonical skill `ai-resources/skills/transaction-table-builder/SKILL.md` via `/create-skill` + EXTEND canonical `cluster-memo-refiner/SKILL.md` (transaction-row-ID ref + <3-deal generalization) + EXTEND canonical `evidence-to-report-writer/SKILL.md` (size-lens classification at chapter-write time) + EDIT project `reference/file-conventions.md` (add transaction-table row) + CREATE new project directory `execution/transaction-table/{section}/`
- S-11: NEW project reference doc `reference/known-limits.md` + EXTEND canonical `research-extract-creator/SKILL.md` (add `evidence_date` field + freshness classes)
- S-16: NEW canonical skill `ai-resources/skills/chapter-revision-applier/SKILL.md` via `/create-skill` + EXTEND canonical `evidence-to-report-writer/SKILL.md` (footer block + draft-path change — S-16 portion) + EXTEND canonical `citation-converter/SKILL.md` (Step 0 pre-flight marker check) + EDIT canonical `workflows/research-workflow/reference/stage-instructions.md` (integrate chapter-revision-applier) + EDIT canonical `workflows/research-workflow/.claude/commands/run-report.md` (integrate chapter-revision-applier)

Bundle 2b (deferred — included in this gate for cross-bundle visibility):
- S-02, S-03, S-04, S-06, S-07, S-13, S-19 (rule additions to `quality-standards.md` + skill behavior tweaks across `research-prompt-creator`, `research-extract-creator`, `cluster-memo-refiner`, `cluster-analysis-pass`, `section-directive-drafter`, `execution-manifest-creator`).

Repos affected: Both — canonical `ai-resources/` (12 files modified; 2 files created) and project `nordic-pe-macro-landscape-H1-2026` (3 files created + 1 new directory + 1 file edited).

Project-deployment status: Per the "sync permanently removed from v6 plan" decision in `logs/decisions.md`, Bundle 2's canonical edits to existing skills + canonical commands stay canonical-only and remain inert in this project. Only the project-side files (S-01 + S-11 reference docs, S-05 file-conventions edit + new execution dir) will be live. Bundle 1's three sub-agents (already auto-deployed via hook) are still inert because the four-pass stage-instructions rewrite was not propagated.

Key boundary: Bundle 2b execution is deferred — this gate covers 2b only to surface cross-bundle structural risks, not to authorize 2b execution.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/report/diagnostics/1.1/1.1-source-pipeline-workflow-fix-proposal-v6-mvp-scope-decision-2026-05-26.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/report/diagnostics/1.1/1.1-source-pipeline-workflow-fix-proposal-v4-2026-05-26.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/decisions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-05-26-end-time-gate-for-bundle-1-slimmed-s-10-s-12-of-the-source.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/source-class-hierarchy.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/known-limits.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/file-conventions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/transaction-table-builder/SKILL.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/chapter-revision-applier/SKILL.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-prompt-creator/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-extract-creator/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/cluster-memo-refiner/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/evidence-to-report-writer/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/citation-converter/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/stage-instructions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/run-report.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/quality-standards.md — exists

## Verdict

**PROCEED-WITH-CAUTION**

**Summary:** Bundle 2 is a high-blast-radius scaffolding bundle (2 new canonical skills + 4 canonical skill extensions + 2 canonical command/reference edits + 3 new project files), but the change is well-specified in v4 per-item form, the project-side deployment posture is explicitly contained (sync removed from v6), and the project intercepts on a known dependency from Bundle 1 (S-01's `## Project Country Set` unblocks `country-parity-checker`). Three Highs (blast radius, reversibility, hidden coupling) all have viable mitigations; usage cost stays Low because Bundle 2 work is canonical-only and pay-as-used.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No new always-loaded content. The two new skill SKILL.md files (`transaction-table-builder`, `chapter-revision-applier`) live in `ai-resources/skills/` and are loaded on-demand by command-driven sub-agent spawns (per `/run-report` Step 4.2 pattern at run-report.md lines 49–79). No SessionStart hook registration. Evidence: `/run-report` reads skills via "Read `/ai-resources/skills/[skill-name]/SKILL.md`" pattern (line 9, 29, 39, 56, 58, 62, 77) — invoked per chapter, pay-as-used.
- Skill extensions on `research-prompt-creator`, `cluster-memo-refiner`, `evidence-to-report-writer`, `citation-converter`, `research-extract-creator` are content additions inside files that are themselves on-demand loaded per pipeline step. The Bundle 1 risk-check (referenced report, Dimension 1) confirmed `research-prompt-creator` Evidence-First preamble cost lands "once per Step 2.1 prompt construction; not per-session."
- Project-side `reference/source-class-hierarchy.md` and `reference/known-limits.md` are project-scoped reference docs. Per project `reference/file-conventions.md` line 3 ("When to read this file: ... Not needed for every turn.") and the workspace pattern established for `quality-standards.md` / `stage-instructions.md`, these load per-stage, not per-turn.
- `reference/file-conventions.md` edit adds 1 row to the canonical naming table (lines 27–66) — small addition to an already on-demand file.
- No new hooks (SessionStart, Stop, PreToolUse, UserPromptSubmit). No new `@import` chains in always-loaded files.
- `auto-sync-shared.sh` line 46 already excludes `run-sufficiency`; new skills are NOT symlinked into projects (the hook syncs `.claude/commands/` and `.claude/agents/` only, lines 3–4 — `ai-resources/skills/` is unaffected). So Bundle 2's new skills cost zero in every project until they're called.

### Dimension 2: Permissions Surface
**Risk:** Low

- No edits to any `.claude/settings.json` or `.claude/settings.local.json` named in either Bundle 2a or 2b. The CHANGE_DESCRIPTION lists only skill SKILL.md files, project reference docs, canonical reference docs, and one canonical command edit (`run-report.md`).
- The two new skills (`transaction-table-builder`, `chapter-revision-applier`) per their v4 specs (v4 lines 311–390 for S-05; lines 1091–1113 for S-16 Part B) operate within Read + Write patterns already authorized for the research-workflow pipeline. `transaction-table-builder` reads raw reports + research extracts and writes `execution/transaction-table/{section}/` — same Read/Write shape as `research-extract-creator`. `chapter-revision-applier` reads `report/chapters/{section}/{section}-chapter-NN-draft.md` and writes `{section}-chapter-NN-revised.md` — same shape as `citation-converter`.
- No deny rule removed; no new MCP server; no external API access introduced. No shell command additions.
- `run-report.md` edit (S-16 integration) is a behavior change inside an existing command — no new tool families authorized.

### Dimension 3: Blast Radius
**Risk:** High

**Files directly touched (Bundle 2a):**
- Canonical: 2 new skills (`transaction-table-builder`, `chapter-revision-applier`) + 4 existing skill files extended (`research-prompt-creator`, `cluster-memo-refiner`, `evidence-to-report-writer`, `citation-converter`, `research-extract-creator`) + 1 canonical reference (`workflows/research-workflow/reference/stage-instructions.md`, 194 lines) + 1 canonical command (`workflows/research-workflow/.claude/commands/run-report.md`, 85 lines). Note: `evidence-to-report-writer` is edited TWICE in this bundle — S-05 size-lens classification + S-16 footer-block-and-draft-path — risk of edit collision; one author must reconcile both.
- Project: 3 new files (`reference/source-class-hierarchy.md`, `reference/known-limits.md`, new directory `execution/transaction-table/{section}/`) + 1 file edited (`reference/file-conventions.md`).

**Files directly touched (Bundle 2b, deferred but in-bundle scope):**
- Canonical: `workflows/research-workflow/reference/quality-standards.md` (80 lines, already edited by Bundle 1 — Evidence-First Principle top section + Bundle 2 breadcrumb at line 3). Bundle 2b will add 6 new sections per Bundle 1's breadcrumb (S-02 / S-03 / S-06 / S-07 / S-13 / S-19). Skill behavior tweaks land in `research-prompt-creator`, `cluster-memo-refiner`, `cluster-analysis-pass`, `execution-manifest-creator`, `section-directive-drafter`, `research-extract-creator`.

**Caller enumeration (Grep across `ai-resources/` and project for the five canonical skills extended in Bundle 2a):**
- `research-prompt-creator` — referenced from `workflows/research-workflow/.claude/commands/run-execution.md` (primary caller, Step 2.1). Project-side checkpoints `execution/checkpoints/1.1/1.1-step-2.1b-prompt-qc.md` and `1.1-step-2.1-checkpoint.md` reference it historically. Bundle 1 already edited it (Evidence-First preamble per Bundle 1 end-time report Dim 1).
- `cluster-memo-refiner` — referenced from `workflows/research-workflow/.claude/commands/run-cluster.md`. Bundle 2a (S-05) + Bundle 2b (S-03, S-15-was-deferred, S-19) all stack edits on this file — three remediation IDs in scope.
- `evidence-to-report-writer` — referenced from `workflows/research-workflow/.claude/commands/run-report.md` line 56 (Step 4.2a). Bundle 2a stacks TWO remediations on this single file (S-05 and S-16) — collision risk noted above.
- `citation-converter` — referenced from `run-report.md` line 77 (Step 4.2i). Bundle 2a adds Step 0 pre-flight marker check (S-16) — a contract change.
- `research-extract-creator` — referenced from `run-execution.md` (Pass 2 / Stage 2.3). Bundle 2a (S-11) adds `evidence_date` field + freshness classes.

**Contract changes:**
- S-16 introduces new operator-approval marker contract (`report/chapters/{section}/{section}-chapter-NN-OPERATOR-APPROVED.md`, format `APPROVED: YYYY-MM-DD-HH-MM | <optional note>` per v4 lines 1075–1088). `/run-report` writes the marker; `citation-converter` Step 0 reads it. This is a two-end contract: a string-literal-and-path match. Per audit-discipline.md § Risk-check change classes, this is "Change modifies a string literal matched by another component" territory — flagged as elevated structural risk.
- S-16 introduces new file in chapter-output schema: `{section}-chapter-NN-revised.md` (produced by `chapter-revision-applier`, consumed by `citation-converter` per v4 lines 1116–1119). The canonical chapter file `{section}-chapter-NN.md` (file-conventions.md line 59) is now the **post-citation** artifact; pre-citation is `-draft.md` then `-revised.md`. file-conventions.md line 59 currently shows only `{section}-chapter-NN.md` — Bundle 2a must add new rows for `-draft.md`, `-revised.md`, `-OPERATOR-APPROVED.md` (v4 line 1089 calls this out as required).
- S-05's transaction table introduces 13-field schema with `Claim supported` field (v4 lines 326–342) referencing cluster-memo claim IDs — a new cross-artifact ID matching contract between transaction table rows and cluster-memo claims.

**Project-deployment status interaction with blast radius:**
Per the 2026-05-26 "sync permanently removed from v6 plan" decision (logs/decisions.md lines 267–284), the project's deployed copies of `run-report.md`, `stage-instructions.md`, and `evidence-to-report-writer`/`citation-converter`/`cluster-memo-refiner` SKILL.md remain on the pre-Bundle-1 shape. This MITIGATES near-term project blast radius — Bundle 2's canonical edits to existing skills/commands are inert in this project. But it AMPLIFIES future re-derivation cost: the divergence between canonical and project grows from "Bundle 1 unsynced" to "Bundle 1 + Bundle 2 unsynced." The 2026-05-26 end-time risk-check for Bundle 1 (Dimension 5 Coupling 5) flagged this as the standing gap — it grows by Bundle 2's surface area.

**Cross-repo writes:** Yes — both `ai-resources/` AND `projects/nordic-pe-macro-landscape-H1-2026/` are written in the same Bundle 2a session. Per audit-discipline.md § Risk-check change classes, "cross-repo writes" is named as a change class warranting `/risk-check`.

**Buy-side-service-plan deployment:** Per the 2026-05-26 FREEZE decision (logs/decisions.md lines 226–235), `buy-side-service-plan` stays pinned to pre-Bundle-1 shape. Bundle 2's canonical edits do NOT propagate to it; SessionStart `check-template-drift.sh` will continue to flag drift in that project. Acceptable per the freeze decision but worth visibility.

### Dimension 4: Reversibility
**Risk:** High

- 2 new skill folders (`transaction-table-builder/`, `chapter-revision-applier/`) — `git revert` of the Bundle 2a commit removes them cleanly. But: if either skill has been invoked at least once between land and revert, working artifacts will exist on disk:
  - `chapter-revision-applier` writes `report/chapters/{section}/{section}-chapter-NN-revised.md` (v4 line 1105) AND archives operator-approval markers to `report/chapters/{section}/.archive/{section}-chapter-NN-OPERATOR-APPROVED-{timestamp}.md` (v4 line 1087). `git revert` does not delete these.
  - `transaction-table-builder` writes `execution/transaction-table/{section}/{section}-transaction-table.md` (v4 line 344). `git revert` does not delete this.
- 3 new project files (`source-class-hierarchy.md`, `known-limits.md`, plus the `file-conventions.md` row addition) are file edits/creates under git — revert cleanly via `git revert`.
- Cross-repo revert dependency: a revert of Bundle 2a means reverting BOTH `ai-resources/` and `projects/nordic-pe-macro-landscape-H1-2026/` separately. Two commits in two repos → two revert operations. This is the same shape as Bundle 1 (where `/sync-workflow` was deferred) but now with two new dimensions: (a) Bundle 1's canonical state is currently divergent from project, so a Bundle 2 revert leaves the project in a mixed state if any S-01/S-11/file-conventions project-side files were committed; (b) the project-side `source-class-hierarchy.md` carries the `## Project Country Set` section that `country-parity-checker` (already deployed via Bundle 1 auto-sync) reads — revert removes the unblock without removing the consumer.
- Operator-approval-marker side-effect — S-16's "marker is moved to `.archive/` on successful citation completion" lifecycle (v4 line 1087) means that even WITHOUT a revert, normal pipeline operation creates files under `.archive/` that accumulate. Not a revert problem per se, but accumulation discipline that didn't exist before.
- No state pushed beyond local repos (no remote push, no Notion write, no external API call introduced). No automation registered that auto-fires between land and revert.
- v4 line 774 ("HIGH BLAST RADIUS") and Bundle 1's end-time risk-check Dimension 4 (Medium — "the revert burden grows the moment `/sync-workflow` runs") both anticipated this growth. Sync is now removed, so the project-side revert burden is bounded — but the canonical-side revert burden grows linearly with Bundle 2's 8 canonical files.

### Dimension 5: Hidden Coupling
**Risk:** High

Bundle 2 introduces or extends multiple cross-artifact contracts. Each is documented in v4 but each is also load-bearing for a downstream consumer that the change site doesn't directly name.

**Coupling A — S-01 `## Project Country Set` section closes a known dependency (intentional, surfaced):**
`country-parity-checker/SKILL.md` line 14: "This skill reads the project's country set from `reference/source-class-hierarchy.md` (project-level), specifically the `## Project Country Set` section. ... Until a project provides it, the skill exits at pre-flight with a remediation prompt." Bundle 1 deployed `country-parity-checker` into projects via auto-sync but the project-side dependency file did not exist. Bundle 2a's S-01 closes this dependency. POSITIVE coupling — Bundle 2a deliberately resolves a Bundle 1 known-pending edge. Risk: if the section schema (target / region / region_superset / thresholds per `country-parity-checker/SKILL.md` line 48) drifts between authoring and consumption, the skill exits. Mitigation: schema must match `country-parity-checker/SKILL.md` lines 41–48 verbatim.

**Coupling B — S-16 two-end string-literal contract (new):**
`/run-report` writes the operator-approval marker file when the operator's reply contains the literal `approved` (v4 line 1084: "case-insensitive, must be a whole word or first word of the reply"). `citation-converter` Step 0 reads the file's presence (not content) to clear the gate (v4 line 1085). String-literal match between Claude's reply parsing and the file-write trigger is invisible from either skill's SKILL.md alone — a hidden coupling unless both editors share spec context. The marker filename pattern `{section}-chapter-NN-OPERATOR-APPROVED.md` (v4 line 1076) is the second string literal — `citation-converter` looks for this exact filename. Risk: future edit to either side that changes the filename or the `approved` token breaks the contract silently.

**Coupling C — S-16 multi-file chapter-output schema change (new):**
The chapter-output schema changes from a single `{section}-chapter-NN.md` to a four-file lifecycle: `-draft.md` → operator edits → `-revised.md` → `-OPERATOR-APPROVED.md` marker → `-cited.md` (existing) → `.md` canonical (existing). Per v4 line 1089, file-conventions.md MUST add three new rows for the working files. Risk: any other skill or command that has hardcoded `{section}-chapter-NN.md` as the chapter draft path will silently miss the revised file. `run-report.md` line 65 currently writes to `{section}-chapter-NN.md` as the chapter output; the S-16 integration must rewrite this path correctly or risk routing past the operator gate.

**Coupling D — S-05 transaction-table-builder is the same skill called by Bundle 1's slimmed S-10 as a Pass 2 sub-agent (already named, not yet existing):**
Per v6 line 124 Locked Decision: "**`transaction-table-builder` reused from S-05** as the Pass 2 sub-agent (not a new skill)." Per Bundle 1 end-time risk-check Coupling 6: `stage-instructions.md` line 47 says "Step 2.3b — Transaction Table Build ... *Deferred — lands in a later bundle*" and `run-execution.md` line 7 says "Pass 2's transaction-table-builder step (Step 2.3b) is deferred — it lands in a later bundle of the source-pipeline workflow fix." Bundle 2a's S-05 is precisely "the later bundle" that lands it. POSITIVE coupling — Bundle 2a fulfills a Bundle 1 deferred dependency. Risk: the deferral text in `stage-instructions.md` and `run-execution.md` must be rewritten to "active" when S-05 lands, or operators will see contradictory state ("deferred" in stage-instructions, "live" in skill registry).

**Coupling E — S-05 transaction-table row IDs ↔ cluster-memo claim IDs (new):**
v4 line 342 declares a `Claim supported` field: "Specific cluster-memo claim ID this transaction substantiates." Per v4 line 374: "Extend `cluster-memo-refiner/SKILL.md`: claims involving named transactions must reference transaction-table row IDs." This is a two-way ID-matching contract between transaction table rows and cluster-memo claims — neither file format currently has a stable claim-ID schema. Risk: undocumented ID scheme. The v4 spec does not define the format of "cluster-memo claim ID" — implementer must pick a stable convention or both ends will drift.

**Coupling F — S-11's `evidence_date` field threads through to downstream freshness checks (new):**
v4 lines 821–830 add `evidence_date` to every research extract claim and define four freshness classes (CURRENT / RECENT / BASELINE / STRUCTURAL). v4 line 830: "Claims attempting to support current-state from BASELINE or STRUCTURAL evidence are flagged for downgrade." The downgrade mechanism is not named — it's silently expected to live in `claim-permission-gate` (per Bundle 1, already deployed) or `cluster-memo-refiner`. Risk: a "freshness-downgrade" rule that is referenced but not implemented in the same bundle. Bundle 2a lands the field; some downstream skill must read it for the freshness discipline to be operative.

**Coupling G — Bundle 2b adds 6 new sections to `quality-standards.md` named in Bundle 1's breadcrumb (declared, future-load-bearing):**
Per the Bundle 1 end-time report (Dimension 5 Coupling 4): `quality-standards.md` line 3 currently reads (verbatim): "The following rule sections are designed to land but not yet present: source-class-substitution rules, country-parity enforcement, claim-permission classes, source-diversity matrix, stop-conditions for research subtasks, source-conflict resolution. Projects ... may reference these by the identifiers S-02 / S-03 / S-06 / S-07 / S-13 / S-19." Bundle 2b is precisely the bundle that fulfills this breadcrumb. POSITIVE coupling. Risk: the section headings Bundle 2b lands must match the names called out in the breadcrumb, OR the breadcrumb must be updated to match. Either way, this is a load-bearing rename if the names don't match exactly.

**Coupling H — S-16's chapter-revision-applier reads inline HTML comments as a parse contract (new):**
v4 lines 1063–1068: the operator edits the draft and adds `<!-- improve: [idea] -->` and `<!-- KEEP -->` markers. `chapter-revision-applier` parses these markers and applies them paragraph-scope. Two risks: (a) the comment-marker syntax is undocumented anywhere except v4 spec — operators rediscovering the feature later may use a different convention; (b) other Stage 4 skills (`chapter-prose-reviewer`, `evidence-to-report-writer`) may emit HTML comments that look like these markers but aren't operator intent.

**Coupling I — `auto-sync-shared.sh` does NOT auto-distribute new skills (architecture, not new in Bundle 2):**
Per `auto-sync-shared.sh` lines 3–4: "Walks `ai-resources/.claude/{commands,agents}/` and symlinks every file into the project." Skills in `ai-resources/skills/` are read by path at runtime via the `Read /ai-resources/skills/[skill-name]/SKILL.md` pattern (run-report.md line 9). Bundle 2's two new skills are read from `ai-resources/`, not symlinked. POSITIVE for cost (Dimension 1 Low) — new skills don't bloat every project. NEGATIVE for hidden-coupling visibility — operators expecting symlinks (because commands and agents auto-deploy) may not realize skills do not. This is an existing architectural property, not new to Bundle 2; flagged here because Bundle 2 doubles skill count and the property becomes more load-bearing.

### Cross-bundle finding (Bundle 2a + Bundle 2b interaction)

The CHANGE_DESCRIPTION asks this gate to cover both Bundle 2a (this session) and Bundle 2b (deferred) "in one gate." Per the audit-discipline.md two-gate model (lines 28–35), `/risk-check` fires once at plan-time and once at end-time per session. A single plan-time gate can validly cover a multi-session work plan IF the design intent is stable. The dimension findings above evaluate both bundles together. However: Bundle 2b lands AFTER Bundle 2a executes and AFTER (per v6) an R2 production run, which may calibrate the 30%/40% thresholds (Bundle 1 Locked Decision #8). A separate end-time gate for Bundle 2b is required by the two-gate model — this plan-time gate authorizes design only, not execution of 2b.

## Mitigations

- **Mitigation A (Dimension 3, blast radius — `evidence-to-report-writer` collision):** Bundle 2a stacks TWO remediations on `evidence-to-report-writer/SKILL.md` (S-05 size-lens classification + S-16 footer-block-and-draft-path). Apply both as a single coherent edit in one operation — do not land S-05's portion in one sub-step and S-16's in a later sub-step. Read the file once, plan both edits, write once. Verify in the post-edit Read that both behaviors are present and don't conflict (e.g., the footer block must be stripped before the size-lens classification fires at chapter-write time, OR the order must be specified). Log the integration order in the commit message.

- **Mitigation B (Dimension 3, contract change — `citation-converter` Step 0 marker check):** The new pre-flight check (S-16, v4 lines 1060–1061) is a not-backwards-compatible contract change matching Bundle 1's `/run-analysis` + `/run-synthesis` fail-safe pattern. Bundle 2a commit message must name the contract: "after Bundle 2a, `citation-converter` requires an operator-approval marker file at `report/chapters/{section}/{section}-chapter-NN-OPERATOR-APPROVED.md` before it will execute." Add the marker file pattern to project `.gitignore` if operator-approval markers should not be committed (decide explicitly — Bundle 1 sentinel pattern `analysis/*/.*.done` is gitignored per project line 6; the marker may want the same treatment, OR may want to be committed as audit trail).

- **Mitigation C (Dimension 4, reversibility — sub-files outside git revert):** Before Bundle 2a execution, decide and document the cleanup policy for `chapter-revision-applier` outputs (`{section}-chapter-NN-revised.md`, `.archive/*-OPERATOR-APPROVED-{timestamp}.md`) and `transaction-table-builder` outputs (`execution/transaction-table/{section}/{section}-transaction-table.md`). If a Bundle 2 revert becomes necessary mid-R2, the operator needs a known cleanup sequence. Recommendation: a short "Bundle 2 revert procedure" section in `logs/decisions.md` at land time.

- **Mitigation D (Dimension 5 Coupling A — `## Project Country Set` schema must match `country-parity-checker` exactly):** When authoring `reference/source-class-hierarchy.md` (S-01), the `## Project Country Set` section MUST follow the schema named in `ai-resources/skills/country-parity-checker/SKILL.md` lines 41–48 verbatim. Read that skill file before authoring the section. If the schema in the skill doesn't match v4's spec text (v4 § S-01 doesn't enumerate this section's schema — it was added by Bundle 1's `country-parity-checker` design), `country-parity-checker` is the canonical source. Do not author the section from v4 alone.

- **Mitigation E (Dimension 5 Coupling B — operator-approval marker string-literal contract):** Both ends of the S-16 marker contract (`/run-report` writes, `citation-converter` reads) must be edited in the same Bundle 2a commit. Verify after edit: the filename pattern in `run-report.md`'s marker-write step must match the filename pattern in `citation-converter/SKILL.md`'s Step 0 read check, character-for-character. If a workspace-level contract inventory exists (per Bundle 1 end-time advisory Risk 2 — `repo-state.md § Pending Manual Step #10` pattern), add this contract to it.

- **Mitigation F (Dimension 5 Coupling C — chapter-output schema files-conventions update):** Bundle 2a MUST add three rows to project `reference/file-conventions.md`: `{section}-chapter-NN-draft.md`, `{section}-chapter-NN-revised.md`, `{section}-chapter-NN-OPERATOR-APPROVED.md`. Per project file-conventions.md Rule 3 (line 21): "If you are about to write a file and no canonical pattern matches ... add a new row to the Canonical Naming Standard table." S-16 introduces three new patterns at once; all three must be added in the same Bundle 2a session, or future write-discipline checks will flag drift.

- **Mitigation G (Dimension 5 Coupling D — stage-instructions and run-execution deferral text must be flipped to active):** When S-05's `transaction-table-builder` skill lands, the deferral text in `ai-resources/workflows/research-workflow/reference/stage-instructions.md` line 47 ("Step 2.3b — Transaction Table Build ... *Deferred*") and `run-execution.md` line 7 ("transaction-table-builder step (Step 2.3b) is deferred") must be rewritten to active language in the same Bundle 2a commit. Search for the literal string "Deferred" in both files post-edit; if either still contains it referencing S-05, the spec is inconsistent.

- **Mitigation H (Dimension 5 Coupling E — define cluster-memo claim ID scheme):** Before landing the `Claim supported` field in S-05's transaction-table schema, define and document a stable claim-ID convention for cluster-memo claims. Suggested: `{section}-cluster-NN-claim-MM` (e.g., `1.1-cluster-01-claim-03`). Add this convention to project `reference/file-conventions.md` AND to `cluster-memo-refiner/SKILL.md` so both producer and consumer agree. Without this, the `Claim supported` field will be populated with ad-hoc strings and the cross-artifact link will be unverifiable.

- **Mitigation I (Dimension 5 Coupling F — S-11 freshness downgrade implementation site):** Bundle 2a's S-11 lands the `evidence_date` field. The "claims attempting to support current-state from BASELINE or STRUCTURAL evidence are flagged for downgrade" mechanism (v4 line 830) must be implemented somewhere — either in `cluster-memo-refiner` (where claim-permission classes are assigned, Bundle 2b S-06 target) or in `claim-permission-gate` (Bundle 1 skill, already deployed). Decide explicitly in the session-plan which file owns the freshness downgrade rule. If deferred to Bundle 2b, the `evidence_date` field is inert in Bundle 2a — flag this consciously rather than allowing silent inertness.

- **Mitigation J (Dimension 5 Coupling G — Bundle 2b breadcrumb-to-section-name match):** When Bundle 2b lands, its 6 new sections in `quality-standards.md` must use heading names matching `quality-standards.md` line 3's breadcrumb verbatim — "source-class-substitution rules" (not "no-source-substitution rule"), "country-parity enforcement" (not "country-parity gate"), "claim-permission classes", "source-diversity matrix", "stop-conditions for research subtasks", "source-conflict resolution". If the planned section names differ (per v4 § S-02 / § S-03 etc., the actual section names may not match), update the breadcrumb in Bundle 2b's first edit so the strings align before adding the sections.

- **Mitigation K (Cross-bundle — Bundle 2b requires its own end-time gate):** The plan-time gate authorizes Bundle 2b's design, not execution. When Bundle 2b executes (deferred to a later session per the v6 split decision, logs/decisions.md line 292), it must run its own `/risk-check` at end-time. Do not skip the end-time gate on the rationale that "this plan-time gate already covered it."

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

# Pre-Change Advisory — Bundle 2 Plan-Time Gate

## Verdict on Concurrence

**We concur with PROCEED-WITH-CAUTION.** The dimension scoring is well-evidenced and the verdict matches the change's actual shape. The 11 mitigations (A–K) are largely the right ones — but the verdict is **load-bearing on Mitigation E being executed atomically**, and there are three structural risks the dimension review did not name. We do not recommend downgrading to GO; we recommend tightening, not loosening, before execution starts.

## Architectural Commentary on Top of Routing

**Routing position is correct.** Per `repo-architecture.md` § Canonical homes, the two new skills land at `ai-resources/skills/<name>/SKILL.md` (read-by-reference, not auto-distributed); the canonical command and stage-instructions edits live in `ai-resources/workflows/research-workflow/`; project reference docs live in the project's own `reference/`. Nothing in the change description proposes a routing violation. The "sync permanently removed from v6" posture is consistent with `repo-architecture.md` § Symlink topology Rule 1 (existing files at the target are never overwritten) — that rule is precisely why sync-as-overwrite is the wrong mental model and a deliberate decision to keep canonical-only was the right call (principles.md § DR-1, DR-3).

The change correctly fires the `/risk-check` gate per `risk-topology.md § 3` ("New canonical command/agent" + "Canonical command/agent edit" + "Change modifies a string literal matched by another component"). All three applicable change classes are in scope; the gate is not redundant.

## What the Mitigations Get Right

- **Mitigation A (collision on `evidence-to-report-writer`)** is the single highest-leverage mitigation in the set. Two remediations writing the same file in one bundle is the textbook case of `principles.md § AP-6` (audit recommendations applied without impact analysis) when applied piecewise. Atomic edit is mandatory, not optional.
- **Mitigation E (two-end marker contract in same commit)** is the right shape and the right boundary. `risk-topology.md § 5` explicitly names "Change modifies a string literal matched by another component (two-end contract)" as a signal that elevates to structural risk — both ends must land in one commit or the contract is undefined for any state between them.
- **Mitigation K (Bundle 2b requires its own end-time gate)** is correct per `principles.md § DR-8` two-gate firing model. The plan-time gate authorizes design, not execution.
- **Mitigation H (define claim-ID scheme before the `Claim supported` field lands)** correctly catches the speculative-abstraction risk (`principles.md § DR-7` / `§ AP-7`) — landing a field that references an undefined ID convention guarantees ad-hoc strings.

## Risks the Dimension Review Did Not Fully Name

### Risk 1 — Inert-field anti-pattern is broader than Mitigation I captures

Mitigation I correctly flags the freshness-downgrade implementation site for `evidence_date`. The same anti-pattern exists in two other Bundle 2a items and is not called out:

- **S-05's `Claim supported` field** is inert until `cluster-memo-refiner` actually emits the claim-ID format the field consumes (Mitigation H addresses the ID scheme but not the producer-side wiring — `cluster-memo-refiner` must emit IDs in the new scheme, not just acknowledge it).
- **S-16's HTML-comment markers** (`<!-- improve: -->`, `<!-- KEEP -->`) are inert until operators are told the convention exists. Coupling H names the parse-contract risk but not the operator-side discoverability gap.

This is `principles.md § OP-3` (loud failure over silent continuation) territory: a field that exists but does nothing fails silently. The right answer is to add to the session plan an explicit list of "fields landing inert in Bundle 2a, with the bundle that activates each" — Coupling F's pattern, generalized.

### Risk 2 — Bundle 1 ↔ Bundle 2a divergence amplification is structural, not just a revert problem

The risk-check report names this under Dimension 3 ("AMPLIFIES future re-derivation cost") and Dimension 4 (cross-repo revert). It is treated as a reversibility concern. The deeper architectural risk: with sync removed, every subsequent canonical edit widens the canonical-vs-project gap. After Bundle 2a lands, the project will be running stage-instructions and `/run-report` from pre-Bundle-1 shape, while canonical advertises Bundle 1 + 2a behavior. **The project's `repo-architecture.md`-style mental model becomes wrong for this project's own operators.** This is `principles.md § OP-3` + `§ AP-1` (silent conflict resolution): the divergence is not surfaced anywhere except `logs/decisions.md`. The right answer is to add a one-line breadcrumb to the project's `reference/stage-instructions.md` and `reference/file-conventions.md` naming the canonical version drift explicitly. Not in the v4 spec, not in the mitigation list.

### Risk 3 — The plan-time gate covering Bundle 2b is a category error worth naming

The risk-check report's "Cross-bundle finding" notes Bundle 2b requires its own end-time gate (correct, captured in Mitigation K). It does not name the deeper issue: **a plan-time gate is a design-stability gate**. Per `principles.md § DR-8` the gate validates a plan that is about to execute. Bundle 2b is gated to execute AFTER an R2 production run that may recalibrate thresholds (Locked Decision #8) — i.e., Bundle 2b's design is explicitly not yet stable. This plan-time gate cannot validate Bundle 2b's design because Bundle 2b's design is conditional on data that does not exist yet. The right framing: **this gate is a Bundle 2a plan-time gate with Bundle 2b cross-referenced for visibility**, not a joint gate. Treating it as joint risks downstream operators citing this gate as Bundle 2b's plan-time authorization — which it is not. Recommend the gate's verdict header be amended at land-time to explicitly say "Bundle 2b requires its own plan-time gate after R2 production data lands, in addition to Mitigation K's end-time gate."

## Position

The right answer is **PROCEED-WITH-CAUTION as verdicted, with three additions before execution begins**:

1. Generalize Mitigation I into a session-plan inert-fields ledger (Risk 1). The ledger names every field/marker/file Bundle 2a lands that is consumed by something not yet built, and the bundle that activates each. This converts silent inertness into surfaced inertness (`principles.md § OP-3`).

2. Add project-side divergence breadcrumbs to `reference/stage-instructions.md` and `reference/file-conventions.md` in the same Bundle 2a commit (Risk 2). One line each, pointing operators at `logs/decisions.md` for the canonical-vs-project divergence map. Closes the silent-conflict gap (`principles.md § AP-1`).

3. Restate the gate's scope at land-time to clarify it is a Bundle 2a plan-time gate with Bundle 2b cross-referenced — not a joint plan-time authorization (Risk 3). Bundle 2b's plan-time gate fires after R2 production data lands (`principles.md § DR-8` two-gate model applied per-bundle).

The 11 existing mitigations stay. The verdict stays. These three additions are the gap between the dimension review (which is rigorous) and what `principles.md § OP-3` and `§ AP-1` together require.

## Files Cited

- `principles.md` — OP-3, AP-1, AP-6, AP-7, DR-1, DR-3, DR-7, DR-8
- `architecture/risk-topology.md` — § 3, § 5
- `ai-resources/docs/repo-architecture.md` — Canonical homes, Symlink topology
- This report — full risk-check under second opinion

## Evidence-Grounding Note

All risk levels grounded in direct evidence: read of v6 scope-decision (full file, 224 lines), Bundle 1 end-time risk-check report (full file, 206 lines), v4 spec sections S-01 / S-05 / S-11 / S-16 (lines 107–204, 311–390, 798–840, 1030–1131), project `logs/decisions.md` (full file, 301 lines), project `reference/file-conventions.md` (full file, 144 lines), `audit-discipline.md` (full file, 55 lines), `country-parity-checker/SKILL.md` Reference dependency block (lines 14–48, 132–178), `auto-sync-shared.sh` (lines 1–80 including line 46 EXCLUDE_COMMANDS), canonical `workflows/research-workflow/.claude/commands/run-report.md` (full file, 85 lines), `research-prompt-creator/SKILL.md` (full file, 229 lines). File line-counts confirmed via wc: `evidence-to-report-writer/SKILL.md` 355 lines, `citation-converter/SKILL.md` 254 lines, `cluster-memo-refiner/SKILL.md` 185 lines, `research-extract-creator/SKILL.md` 109 lines, canonical `stage-instructions.md` 194 lines, canonical `quality-standards.md` 80 lines. Two files referenced in change description are tagged "not yet present" and were not read — their contribution to risk is evaluated from v4 spec intent only (flagged in dimension findings). No training-data fallback used.
