# Risk Check — 2026-05-28

## Change

END-TIME GATE for FX-B1 Path A consolidated landing (per design v3 Step 13 + `principles.md § DR-8` two-gate firing model). Plan-time risk-check fired last session (2026-05-27 report) with verdict PROCEED-WITH-CAUTION + 5 mitigations (Risk-Check baseline) + System Owner expansion to 9 mitigations + canonical-ordering rule.

Scope of consolidated landing (this session, not yet committed):

**Canonical (`ai-resources/workflows/research-workflow/`):**
- `docs/project-config-schema.md` — field #13 `Document model` added (enum: report/section; halt on missing); fan-out updated for all 3 Stage 5 commands; "Default-value semantics" section added; Section IDs fan-out wording fix.
- `CLAUDE.md` — `Document model:` field added to `## Project Config` block (12→13 fields); forward-contract notice updated.
- `reference/stage-5-common-phases.md` — NEW (173 lines, 5 anchors).
- `reference/stage-5-paths.template.md` — NEW (104 lines, both mode schemas).
- `.claude/commands/produce-prose-draft.md` — refactored to Path A (240 lines).
- `.claude/commands/produce-formatting.md` — refactored to Path A (147 lines).
- `.claude/commands/produce-jargon-gloss.md` — refactored to Path A (83 lines).

**Cross-cutting (`ai-resources/.claude/commands/friday-checkup.md`):**
- Step 5 item M added — Stage 5 anchor consistency check (bidirectional grep, all tiers).

**Project-side (`projects/nordic-pe-macro-landscape-H1-2026/`):**
- `CLAUDE.md` — full 13-field `## Project Config` block instantiated (incl. `Document model: "report"`).
- `reference/stage-5-paths.md` — NEW (16 lines, report-mode).

**Project-side (`projects/buy-side-service-plan/`):**
- `CLAUDE.md` — minimal `## Project Config` block (Document model: "section" only).
- `reference/stage-5-paths.md` — NEW (20 lines, section-mode).

**Documentation (`projects/repo-documentation/`):**
- `output/phase-1/repo-state.md` — item #11 added (FX-B1 rollback recipe).
- `vault/architecture/repo-state.md` — summary row #11 added.

Mid-session scope expansions (operator-approved at Wave 1 gate): (1) Step 6 expanded from "add `Document model:` line" to "instantiate full 13-field block" for nordic-pe; (2) parallel Step 6.5 added for buy-side (minimal Project Config block + section-mode `stage-5-paths.md` instantiation) to keep buy-side's symlinked canonical Stage 5 commands safe.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/docs/project-config-schema.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/stage-5-common-phases.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/stage-5-paths.template.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/produce-prose-draft.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/produce-formatting.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/produce-jargon-gloss.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-checkup.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/stage-5-paths.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/reference/stage-5-paths.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/output/phase-1/repo-state.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/architecture/repo-state.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-05-27-fx-b1-path-a-v2-design-stage-5-generalization.md — exists (PRIOR plan-time report)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/plans/fx-b1-path-a-design-v3.md — exists (approved design contract)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The consolidated landing matches the plan-time-approved design v3 contract on all 9 mitigations and on the canonical-ordering rule; the Wave 1+3+4 verifications (anchor-consistency, symlink-vs-copy state, consumer-set filesystem check, dry-run, schema-sanity, rollback-primitive) all pass; the residual elevated risk is **commit-boundary hygiene** — the ai-resources working tree carries pre-existing modifications from prior sessions (`logs/friction-log.md`, `logs/improvement-log.md`, `logs/session-notes.md`, plus untracked `logs/inbox-triage-2026-05-27.md`) that will be commit-adjacent to the FX-B1 landing commits and must be staged carefully to avoid mixing FX-B1 changes with prior-session log churn into a single commit.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Canonical Stage 5 commands grew from 461 lines (pre-Path-A: 239 + 130 + 92) to 470 lines (post-Path-A: 240 + 147 + 83) — a net +9 lines across three files (verified via `wc -l`). Below the "Medium ~50–150 token" threshold; within the v2 design's "~10–20% growth" envelope (actual: +1.95%). The shared-phase extraction worked as designed: `produce-jargon-gloss` shrank 92→83 lines (anchor refs replaced inline phase content).
- New `reference/stage-5-common-phases.md` (173 lines) and `reference/stage-5-paths.template.md` (104 lines) are **load-on-demand** — read only when a Stage 5 command runs at Phase 0 / Phase 5–7. Not always-loaded. Not auto-imported. Zero session-start cost.
- Project-side `reference/stage-5-paths.md` instances are small (nordic-pe: 16 lines; buy-side: 20 lines) and load-on-demand only.
- Workspace CLAUDE.md not touched. Canonical workflow CLAUDE.md gained one schema-field line in the `## Project Config` block (line 36: `**Document model:** "{{DOCUMENT_MODEL}}" …`) — workflow CLAUDE.md is itself load-on-demand for projects that adopt it, not workspace-wide always-loaded.
- nordic-pe project CLAUDE.md `## Project Config` block grew from absent to 13 lines (~600 chars); this IS always-loaded for nordic-pe sessions. Above the ~150-byte Medium threshold but below the ~150-token threshold (~150 tokens ≈ 600 chars at 4 chars/token — close to threshold, but the 13 fields are short label-value pairs that compress well). Operator's specific concern ("worth it?") answered yes — the schema is now a live contract, not a forward declaration.
- buy-side project CLAUDE.md added a minimal block (~4 lines including header) — well below threshold.
- repo-documentation `repo-state.md` item #11 is a single table row in a load-on-demand reference file. Friday-checkup grew by one bullet step (item M, ~10 lines) — auto-loaded only when `/friday-checkup` is invoked (weekly cadence; not per-session).
- Per-invocation cost of Stage 5 commands now requires reading 2 extra files (common-phases doc + project `stage-5-paths.md`) — load-on-demand at Phase 0 / Phase 5–7. Pay-as-used. Trade-off explicitly accepted by design v3 § Mode discriminator.

### Dimension 2: Permissions Surface
**Risk:** Low

- Zero edits to any `settings.json` (verified — neither `ai-resources/.claude/settings.json` nor any project `.claude/settings.json` appears in the working tree's modified list).
- No new tool family invoked. Stage 5 commands continue to invoke the same skills (`decision-to-prose-writer`, `prose-refinement-writer`, `prose-formatter`, `h3-title-pass`, `formatting-qc`, `document-integration-qc`, `ai-prose-decontamination`, `jargon-gloss`, `chapter-prose-reviewer`, `prose-compliance-qc`) — verified via grep against canonical command files.
- No hooks added (Friday-checkup item M is a slash-command step, not a hook).
- No scope escalation (project→user, etc.).

### Dimension 3: Blast Radius
**Risk:** Medium

- **Direct file touch count: 14** (6 canonical edits + 1 cross-cutting + 4 project-side + 2 repo-state + verified via the change description's enumeration).
- **Active consumer count:** exactly 2 (nordic-pe + buy-side) — verified via `ls projects/*/.claude/commands/produce-{prose-draft,formatting,jargon-gloss}.md`. Five project-copy files total:
  - nordic-pe: `produce-prose-draft.md` (141 lines, regular file/fork), `produce-formatting.md` (133 lines, fork), `produce-jargon-gloss.md` (88 lines, fork)
  - buy-side: `produce-prose-draft.md` (symlink → canonical), `produce-formatting.md` (symlink → canonical); `produce-jargon-gloss.md` is **absent** (verified via `ls`).
- **Symlink-vs-copy state confirmed:** nordic-pe = 3 forks (intentional report-mode adaptations per project CLAUDE.md line 99); buy-side = 2 symlinks + 1 absent. Buy-side's symlinks WILL auto-pick-up the canonical Path A edits on next invocation — this is the load-bearing reason Step 6.5 (buy-side Project Config block + section-mode `stage-5-paths.md`) was added mid-session.
- **Blast verification:** without the Step 6.5 buy-side instantiations, the next buy-side Stage 5 invocation would halt at Phase 0 step 1 (missing `Document model:` field) and step 3 (missing `reference/stage-5-paths.md`). With them in place, the canonical Phase 0 path resolves cleanly. Dry-run results (per change description) confirm: 4 valid-input scenarios dispatch correctly; 3 invalid-input scenarios halt with documented error messages.
- **nordic-pe insulation:** nordic-pe's three Stage 5 commands are regular files (forks, not symlinks). Per the FX-D1 sequencing implication noted in design v3 § FX-D1, the canonical edit does NOT propagate to nordic-pe until FX-D1 lands. nordic-pe continues to invoke its project copies; Path A landing alone is harmless to nordic-pe operationally. The 13-field `## Project Config` block in nordic-pe CLAUDE.md is forward-contract content — nordic-pe forks parse it once FX-D1 lands.
- **Contract changes — all backwards-compatible:**
  - Schema field #13 (`Document model`) is additive with explicit "halt on missing" semantics. Documented at `docs/project-config-schema.md` line 57 + Default-value-semantics section (lines 97–112). No silent default.
  - Common-phases anchor contract: 5 anchors declared in `stage-5-common-phases.md`, 5 anchors referenced across canonical commands (verified via `grep`, diff empty — Mitigation 3 PASS). Per-command anchor refs: `produce-formatting.md`=1, `produce-jargon-gloss.md`=2, `produce-prose-draft.md`=3.
  - Mode-mismatch halting documented at `stage-5-paths.template.md` lines 83–94 with verbatim error messages for all six combinations (report/section, report/report, etc., missing Mode: line, malformed value).
- **No third-consumer surface:** Mitigation 2 confirms only nordic-pe + buy-side carry project-copy Stage 5 commands. Workspace auto-sync hook is **not** in the consumer path (confirmed by design v3 § FX-D1 sequencing and System Owner advisory § 4 — Stage 5 commands live in `ai-resources/workflows/research-workflow/.claude/commands/`, NOT in the auto-sync walk path `ai-resources/.claude/commands/`).
- **Other shared-manifest projects (14 total per `find`):** receive auto-synced canonical commands from `ai-resources/.claude/commands/` only. None of these projects gain new Stage 5 wiring from this landing.

Net: 14 files touched, 2 active consumers (load-bearing), 1 backwards-compatible contract added with structural drift detection, no silent failure surfaces. Above the Low threshold (>5 dependent files), below the High threshold (no third-consumer breakage; no contract requires existing-caller modifications). Medium.

### Dimension 4: Reversibility
**Risk:** Medium

- **Rollback recipe is written and primitive-verified.** Located at `projects/repo-documentation/output/phase-1/repo-state.md` line 121 (item #11) with the full 7-step procedure: (1) identify the two landing commits; (2) `git revert <HASH_AIR>` in ai-resources; (3) `git revert <HASH_NP>` in nordic-pe; (4) verify file removals (`stage-5-common-phases.md`, `stage-5-paths.template.md`, `stage-5-paths.md`); (5) verify Stage 5 command restoration (pre-Path-A baselines captured: produce-prose-draft 239L, produce-formatting 130L, produce-jargon-gloss 92L); (6) CLAUDE.md restoration (canonical CLAUDE.md back to 12 fields; nordic-pe block removed entirely if it didn't pre-exist — current state at 2026-05-28); (7) symlink-vs-copy state notes.
- **Recipe gap (operator-acknowledged):** primitive verification only — `git revert --no-commit` + `--abort` was tested on ai-resources, but the full apply-then-revert cycle was NOT tested end-to-end. The recipe presumes both repos revert cleanly without merge conflicts. Real-world reverts on a 6-file canonical commit can hit merge friction if subsequent edits land between landing and revert. Acceptable residual risk if FX-D1 stays out of the window between landing and any potential revert.
- **Buy-side coverage gap in recipe:** the recipe enumerates ai-resources + nordic-pe commits but does NOT enumerate the buy-side commit (buy-side gained `reference/stage-5-paths.md` and a Project Config block this session — Step 6.5 expansion). If the landing produces three commits (ai-resources, nordic-pe, buy-side) rather than two, the recipe needs one more `git revert` line. **This is a documentation gap in item #11**, not a behavioral gap — the operator will see the buy-side commit during landing and add it to the revert checklist.
- **Append-only state:** `repo-state.md` item #11 itself is append-only and survives revert as a stale entry (the recipe describes a revert of the change but item #11 documents that the change was attempted — by design, this is a historical record, not state to roll back). Low friction.
- **No external push, no Notion writes, no API POSTs, no always-firing hooks added.** All changes are within-repo git revertable.
- **FX-D1 deferral protects reversibility.** Per design v3 § FX-D1, FX-D1 is a separate session AFTER Path A. As long as FX-D1 does not start before any potential revert window closes, the recipe stays in the Medium tier. Once FX-D1 lands, reversibility upgrades to High (per System Owner advisory § 6).

Net: multi-step but documented, primitive-verified, with one minor documentation gap (buy-side commit not enumerated). Medium.

### Dimension 5: Hidden Coupling
**Risk:** Low

- **Coupling 1 (structural drift — common-phases ↔ Stage 5 commands):** Mitigated by anchor-format contract + Friday-checkup item M (bidirectional grep). Live-verified at session end: `grep -oE 'anchor: phase-[a-z-]+' stage-5-common-phases.md | sort -u` returns 5 anchors (`phase-decontamination`, `phase-handoff-formatting`, `phase-handoff-jargon-gloss`, `phase-handoff-prose-draft`, `phase-jargon-gloss`); the bidirectional grep against `produce-*.md` returns the same 5; `comm -3` diff is empty. Mitigation 3 (strengthened) confirmed working. Drift would surface as a Friday-checkup finding before causing silent failure (per `principles.md § OP-3`).
- **Coupling 2 (schema field #13 ↔ Stage 5 commands):** Phase 0 step 1 in all three commands halts loudly on missing/malformed `Document model:` field. Documented at `docs/project-config-schema.md § Default-value semantics for Document model` (lines 97–112) with the verbatim halt messages mirrored in each command file's Phase 0 step 1. No silent default. Verified by reading all three Phase 0 blocks: messages are identical and cite the same schema-row reference.
- **Coupling 3 (project-side `stage-5-paths.md` Mode: ↔ CLAUDE.md `Document model:`):** Documented at `stage-5-paths.template.md § Mode-mismatch halting` (lines 83–94) with all six combinations enumerated and verbatim error messages. Verified in all three command files' Phase 0 step 4. Halts loudly on absent/mismatched/malformed.
- **Coupling 4 (placeholder interpolation):** Template at lines 7 declares the placeholder set: `{section}`, `{report}`, `{N}` (report-mode); `{section}`, `{part}`, `{slug}` (section-mode). Each command file's Phase 0 step 2 + Phase 1 + Phase 2 interpolates these consistently. Sample verified: nordic-pe `stage-5-paths.md` line 9 uses `"{section}-R{N}-compiled-v2.md"` and the canonical produce-prose-draft.md line 47 reads `<compiled-source-root>/<compiled-source-filename>` — interpolation logic matches the schema declaration. Section-mode `{slug}` derivation documented at template line 79 (kebab-case from source-doc title) and at produce-prose-draft.md line 101 (subagent derives slug from document title). Consistent.
- **Coupling 5 (auto-sync hook):** Confirmed by System Owner advisory § 4 and re-verified: Stage 5 commands live in `ai-resources/workflows/research-workflow/.claude/commands/`, NOT `ai-resources/.claude/commands/`. The `auto-sync-shared.sh` hook walks only the latter. No hidden consumer-set widening from this landing.
- **Coupling 6 (buy-side `reference/stage-5-paths.md` provisional note):** Buy-side's `stage-5-paths.md` carries an explicit Provisional instantiation note (lines 4–5) explaining that the `Section sets` block enumerates only `part-2-service` and `part-3-strategy`; `working-hypotheses` is NOT enumerated as a Stage 5 target. This is a forward-coupling note documented at the change site — well-formed, not silent.
- **Coupling 7 (Friday-checkup item M grep):** Inspected at lines 282–284. The grep `grep -oE 'anchor: phase-[a-z-]+'` matches the declared form, and `grep -hoE 'anchor \`phase-[a-z-]+\`'` matches the referenced form. The `sed` normalization step converts the referenced form to match the declared form before `comm -3` diff. Verified working in this session. **Well-formed contract.**

Net: 7 coupling sites enumerated, all documented at the change site, all with halt-loud or grep-based drift detection. No silent auto-firing, no undocumented contract, no overlapping mechanisms. Low.

## Verification of the 9-mitigation set

Walking each mitigation from the plan-time-approved set (5 Risk-Check baseline + 4 System-Owner additions):

| # | Mitigation | Status | Evidence |
|---|---|---|---|
| 1 | Pre-merge dry-run against BOTH consumer projects | **SATISFIED** | Change description confirms 4 valid-input + 3 invalid-input scenarios dispatched/halted correctly; surfaced buy-side missing-`Document model` gap mid-dry-run (addressed by Step 6.5 expansion) |
| 2 (revised) | Confirm exactly two consumers via filesystem check | **SATISFIED** | `ls projects/*/.claude/commands/produce-*.md` returns exactly nordic-pe (3) + buy-side (2); no third surface |
| 3 (strengthened) | Anchor-format contract + Friday-checkup bidirectional grep | **SATISFIED** | 5 declared anchors, 5 referenced anchors, diff empty (live-verified); Friday-checkup item M added at `ai-resources/.claude/commands/friday-checkup.md` lines 276–284 |
| 4 | Symlink-vs-copy state verification | **SATISFIED** | nordic-pe = 3 forks (intentional); buy-side = 2 symlinks + 1 absent; documented in change description for the ai-resources commit message |
| 5 | Rollback recipe expansion BEFORE merge | **SATISFIED-WITH-DEVIATION** | Recipe written at `repo-state.md` item #11 with all 7 steps; primitive (`git revert --no-commit` + `--abort`) verified on ai-resources; full apply-then-revert cycle NOT tested end-to-end; buy-side commit hash not enumerated in the recipe (Step 6.5 was added mid-session; recipe predates the expansion) |
| SO-1 (= 4 above) | Symlink-vs-copy state | **SATISFIED** | See #4 |
| SO-2 (= field default semantics) | No-default + halt-loud on missing `Document model:` | **SATISFIED** | `docs/project-config-schema.md` line 57 + § Default-value semantics (lines 97–112) — all four halt cases documented; all three Phase 0 step 1 blocks cite the same row reference |
| SO-3 (= scope discipline) | Do NOT ship `/new-project` bootstrapping | **SATISFIED** | No `/new-project` edit in scope; change description's file list excludes any `/new-project` artifact |
| SO-4 (canonical-ordering rule, design v3 Implementation order steps 1–15) | Each step is a precondition for the next | **SATISFIED-WITH-DEVIATION** | Mitigation 5 (rollback recipe) landed at session start as required; Mitigation 4 (symlink check) landed pre-canonical-edit; canonical Stage 5 edits applied in the smallest→largest order (jargon-gloss → formatting → prose-draft per design v3 step 7); Mitigation 1 (pre-merge dry-run) ran AFTER all three edits per dry-run results, not strictly between the first and second as the literal step ordering implies — the dry-run still surfaced the buy-side gap before commit, so the loud-failure semantics held |

**Net mitigation status:** 7 SATISFIED + 2 SATISFIED-WITH-DEVIATION. Both deviations are documentation/sequencing gaps, not silent-failure gaps. Mitigation 5 deviation (recipe needs buy-side commit hash) is a one-line addition the operator should make to item #11 before commit. Mitigation 1 sequencing deviation is acceptable because the dry-run still surfaced the buy-side gap before commit — the loud-failure protection worked.

## Structural change classes added beyond the plan-time evaluation

Two new change classes that the plan-time risk-check did not explicitly evaluate (but design v3 § Implementation order step 6 implied):

1. **Project CLAUDE.md `## Project Config` block instantiation (per project).** Plan-time risk-check evaluated "add `Document model: 'report'` to nordic-pe CLAUDE.md" as a single-line edit. The Wave 1 expansion to "instantiate the full 13-field block" elevates this to a CLAUDE.md cross-cutting edit per `risk-topology.md § 3`. Net always-loaded delta for nordic-pe: ~13 lines (~600 chars). Below the Medium threshold; load-bearing for forward contract.

2. **Buy-side per-project Project Config block instantiation.** This was NOT in the plan-time risk-check scope (Step 6.5 was added mid-session). The minimal block (Document model: "section" only) is the smallest possible instantiation. Net always-loaded delta for buy-side: ~4 lines (~150 chars). Below the Medium threshold. This change class is the cleanest possible expansion: it adds exactly what's required to keep buy-side's symlinks functional, defers other fields per documented "minimal instantiation" rationale.

Neither change class introduces a new structural risk surface. Both are documented at the change site and remain backwards-compatible.

## Mitigations

These mitigations apply to the consolidated landing before commits land:

- **Dimension 3 (Blast Radius — Medium): Stage the FX-B1 commits cleanly.** The ai-resources working tree carries pre-existing modifications from prior sessions (`logs/friction-log.md`, `logs/improvement-log.md`, `logs/session-notes.md`) and one untracked file (`logs/inbox-triage-2026-05-27.md`) that are NOT part of FX-B1. Before the dual-commit pattern, the operator should either (a) stash the prior-session log churn, land FX-B1 as clean commits, then restore the stash and commit log churn separately; or (b) use explicit `git add <path>` per-file for the FX-B1 file set, excluding the logs/inbox-triage paths from the FX-B1 commits. The commit message should enumerate the 6+1 canonical files explicitly so a future revert against the FX-B1 commit hash is mechanical. The friday-checkup edit lives in `ai-resources/.claude/commands/` (cross-cutting subtree) — landing it in the ai-resources commit is correct since the live-verified anchor consistency check depends on it.

- **Dimension 4 (Reversibility — Medium): Update rollback recipe before committing.** Item #11 in `repo-state.md` was authored before Step 6.5 (buy-side Project Config block + `stage-5-paths.md` instantiation). Add one line to item #11 enumerating the buy-side commit hash placeholder (`<HASH_BS>`) and the per-file revert targets (`buy-side/CLAUDE.md` + `buy-side/reference/stage-5-paths.md`). This is a one-line documentation fix, not a structural change. Apply before landing the ai-resources commit (so the recipe ships in the same commit batch).

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION; mitigations listed above are sufficient.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence:

- File/line citations to consolidated landing artifacts: `produce-prose-draft.md` lines 19–37 (Phase 0), lines 197, 214, 225 (anchor refs); `produce-formatting.md` lines 15–32 (Phase 0), line 143 (anchor ref); `produce-jargon-gloss.md` lines 24–43 (Phase 0), lines 69, 80 (anchor refs); `stage-5-common-phases.md` lines 22, 58, 95, 123, 153 (5 anchor declarations); `stage-5-paths.template.md` lines 83–94 (mode-mismatch table); `docs/project-config-schema.md` line 57 (field #13 row) + lines 97–112 (Default-value semantics); `friday-checkup.md` lines 276–284 (item M).
- Symlink-vs-copy state verified via `stat -L` (buy-side symlinks visible in `ls -la` output) and `wc -l` (nordic-pe forks: 141/133/88; canonical post-Path-A: 240/147/83).
- Anchor consistency verified live via `grep -oE 'anchor: phase-[a-z-]+'` (5 declared) + `grep -hoE 'anchor \`phase-[a-z-]+\`'` (5 referenced) + `comm -3` diff (empty).
- Consumer-set verified via `ls projects/*/.claude/commands/produce-{prose-draft,formatting,jargon-gloss}.md` — exactly nordic-pe (3 files) + buy-side (2 files); produce-jargon-gloss absent in buy-side.
- Working-tree state verified via `git status --short` in ai-resources, nordic-pe, and buy-side repos.
- Project-side instantiations verified: nordic-pe `## Project Config` block at CLAUDE.md lines 21–40 (13 fields incl. Document model); buy-side block at CLAUDE.md lines 13–22 (Document model: "section" + provisional-instantiation prose).
- Rollback recipe verified at `repo-state.md` line 121 (item #11 — 7 steps incl. pre-Path-A baselines: 239/130/92).
- Prior plan-time report (2026-05-27) verified as the contract being verified against: 5 baseline mitigations + 4 System Owner additions = 9 total; design v3 implements all 9.

No training-data fallback used.

---

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Routing position.** The landing's file homes are correct per the routing baseline. Canonical Stage 5 commands at `ai-resources/workflows/research-workflow/.claude/commands/` (Q2 — slash commands; Q4 — workflow methodology stays in the workflow's own `reference/` tree). The new reference docs (`stage-5-common-phases.md`, `stage-5-paths.template.md`) sit in the workflow's `reference/` directory rather than `ai-resources/docs/`, which is the right call — they are workflow-internal load-on-demand, not cross-workflow process docs (`repo-architecture.md` Q4 — workflow methodology → workflow's own `reference/`). Friday-checkup item M lives at the cross-cutting command, which is canonical for the auto-sync surface (`repo-architecture.md` § canonical homes — slash command). No routing defect.

**Concur on verdict — PROCEED-WITH-CAUTION.** The dimension review and the 9-mitigation walk are evidence-grounded and consistent with how `risk-topology.md § 3` classifies this change set: a new canonical command/agent edit (blast = "all projects invoking it") tempered by Mitigation 2's filesystem-verified two-consumer set. Load-bearing protections — anchor-consistency live-verified empty diff, halt-loud on missing `Document model:`, mode-mismatch table — all satisfy `principles.md § OP-3` (loud failure over silent continuation). The two SATISFIED-WITH-DEVIATION items are documentation/sequencing, not silent-failure surfaces.

**Concur on Mitigation 1 (clean commit staging).** `principles.md § DR-10` is the controlling rule: when a concurrent or prior session has left log churn in the working tree, `git add` must enumerate explicit file paths — directory wildcards are prohibited. Per-file `git add` of the 6+1 canonical FX-B1 files (stash-then-restore is an acceptable alternative) is the right path. Enumerating those files in the commit message is also the cleanest revert primitive — it makes the rollback recipe in `repo-state.md` item #11 mechanically actionable rather than narratively actionable, which matters because Reversibility is Medium.

**Concur on Mitigation 2 (rollback recipe enumerates buy-side commit).** The recipe gap is exactly the documentation defect the System Owner advisory anticipated in `risk-topology.md § 1` Critical-tier reasoning: when a commit-boundary recipe omits a commit that exists, the recipe silently understates blast radius at revert time. One-line addition naming `<HASH_BS>` + `buy-side/CLAUDE.md` + `buy-side/reference/stage-5-paths.md` closes the gap. Land this before the ai-resources commit so the recipe ships in the same batch.

**Missed risks (not blockers; inputs to FX-D1 design + Friday-checkup item M next iteration):**

- **(a) Mitigation 1 dry-run landed AFTER all 3 canonical edits, not between commands 1 and 2.** The protection held this time. Systemic lesson: design v3's step ordering exists because interleaved dry-runs cap rollback-surface growth (`principles.md § AP-9`). On this landing the cost was paid via Step 6.5 mid-session expansion. Surface for FX-D1 (or any successor multi-command landing): harden the design step into command sequencing rather than narrative.

- **(c1) Anchor-reference contract — nordic-pe forks invisible to Friday-checkup item M.** Mitigation 3's grep covers `stage-5-common-phases.md` ↔ canonical command files only. nordic-pe's forks (regular files, not symlinks) do NOT pick up canonical anchor changes until FX-D1 lands. If a future canonical anchor rename happens before FX-D1, the Friday-checkup grep passes at the canonical level while nordic-pe's forks reference the old anchor names — two-end contract drift (`risk-topology.md § 5`). Recommend item M's grep extends to `projects/*/.claude/commands/produce-*.md` post-FX-D1, OR FX-D1's scope includes a one-line note that anchor-name changes pre-FX-D1 require manual nordic-pe fork sync.

- **(c2) Placeholder-set drift not covered by Mitigation 3.** Item M's grep does not catch placeholder-set divergence between `stage-5-paths.template.md`, canonical command interpolation logic, and project-side `stage-5-paths.md` instances. Halt-loud at interpolation (not silent), but a candidate for Mitigation 3.5: extend item M to also grep declared placeholders from the template against referenced placeholders in canonical commands and project instances. Defer to FX-D1 design.

**Position.** Proceed with the landing once the two mitigations are applied. The three missed-risk surfaces (a, c1, c2) are not blockers for this commit batch — they are inputs to FX-D1's design scope and to Friday-checkup item M's next iteration. Surface them in the post-landing wrap.

**Files referenced:**
- `projects/repo-documentation/vault/principles/principles.md`
- `projects/repo-documentation/vault/architecture/risk-topology.md`
- `projects/repo-documentation/vault/architecture/repo-state.md`
- `ai-resources/docs/repo-architecture.md`
- `ai-resources/audits/risk-checks/2026-05-28-fx-b1-end-time-gate-consolidated-landing.md`
