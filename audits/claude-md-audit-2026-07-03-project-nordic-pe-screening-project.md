# CLAUDE.md Audit — 2026-07-03

**Scope:** workspace + project (project-weighted; workspace findings covered by separate committed workspace audit)
**Files audited:**
- Workspace: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` — 231 lines, ~3,600 tokens
- Project: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-screening-project/CLAUDE.md` — 117 lines, ~1,690 tokens

**Token-estimation caveat:** Counts are word × 1.3, ±30% drift vs. real tokenizer. Findings within ±15% of a threshold are tagged `(boundary)`.

**Weighting note:** Per the invocation, findings are weighted toward the PROJECT file and cross-file redundancy. Workspace blocks appear in the verdict table (completeness requirement) but carry `Keep — audited separately` unless a project-side duplicate implicates them. Where a project block duplicates a workspace/ai-resources rule, the **workspace/ai-resources copy is canonical** and the **project copy is the trim/move target** — never the reverse.

**Ancestor-walk fact (load-bearing for redundancy findings):** The workspace CLAUDE.md loads in this project's sessions via ancestor-walk (project lives under the workspace root). Four project blocks justify verbatim duplication with the phrase "repeated here because projects are sometimes opened without the parent workspace context loaded." That premise is false for this project's normal launch path, so the self-justification for full duplication does not hold. External guidance corroborates: ancestor-walk from cwd loads workspace-root CLAUDE.md normally (guidance § long-context notes).

## Executive Summary

- Total findings: **HIGH: 4 / MEDIUM: 7 / LOW: 3**
- Projected token savings if all HIGH+MEDIUM applied: **~800 tokens/turn** (~24,000 tokens/session at 30 turns; ~40,000 at 50 turns) — roughly **47% of the project file's always-loaded weight**, recoverable with no loss of behavioral coverage because the trimmed content remains reachable via the canonical workspace rules and named reference docs.
- Net verdict: The project file is well-structured, clearly written, and under the 200-line target, but it carries heavy cross-file redundancy — four blocks are near-verbatim restatements of canonical workspace/ai-resources rules (Input File Handling, Commit Rules, Compaction, Session Boundaries) plus partial duplication in three more — so nearly half its weight is recoverable by replacing restatements with pointers and moving procedural/analytical methodology to the reference layer.

## Per-File Inventory

### Workspace CLAUDE.md
(Audited separately; listed for completeness — ~ token figures approximate)

| Block | ~Tokens | Type | @-refs |
|---|---|---|---|
| What This Workspace Is For | ~30 | orientation | no |
| Projects | ~70 | orientation | no |
| Axcíon's Tool Ecosystem | ~70 | reference | no |
| Cross-Model Rules | ~40 | rule + pointer | doc pointer |
| Skill Library | ~70 | bright-line | no |
| AI Resource Creation | ~70 | rule + pointer | doc pointer |
| Placement Discipline | ~230 | rule | no |
| Design Judgment Principles | ~55 | rule + pointer | doc pointer |
| QC Independence Rule | ~190 | rule + pointer | doc pointer |
| Contract-Conformance Check | ~160 | rule | no |
| Blind-Spot Scan Gate | ~190 | rule | no |
| Assumptions Gate | ~90 | rule | no |
| Completion Standard | ~80 | rule | no |
| Requirements-Doc Default | ~150 | rule | no |
| Working Principles | ~320 | rule + pointers | doc pointers |
| Chat Communication Style | ~140 | rule | no |
| File Write Discipline | ~35 | pointer | doc pointer |
| Autonomy Rules | ~230 | bright-line + pointer | doc pointer |
| Decision-Point Posture | ~170 | rule | no |
| QC → Triage Auto-Loop | ~25 | pointer | doc pointer |
| Session Guardrails | ~170 | rule + pointer | doc pointer |
| Plan Mode Discipline | ~55 | rule + pointer | doc pointer |
| CLAUDE.md Scoping | ~90 | meta-rule | no |
| Model Tier | ~230 | bright-line + pointer | doc pointer |
| Model Escalation | ~150 | rule + pointer | doc pointer |
| Adaptive Thinking Override | ~35 | rule | no |
| File verification and git commits (Commit/Push/etc.) | ~330 | bright-line + pointer | doc pointer |
| Delivery | ~30 | rule | no |
| Agent Harness | ~55 | rule + @-ref | @-ref |

### Project CLAUDE.md

| Block | ~Tokens | % of file | Type | @-refs |
|---|---|---|---|---|
| Purpose | ~156 | 9.2% | orientation (prose) | path pointer (project-plan) |
| Upstream Inputs (canonical) | ~68 | 4.0% | reference + status | path pointers |
| Program Shape | ~145 | 8.6% | workflow methodology (diagram) | path pointer (ref-project-plan) |
| Bottom-up Principle | ~70 | 4.1% | bright-line | no |
| Cross-Model Workflow | ~62 | 3.7% | rule (partial dup) | doc pointer |
| Confidence and Sourcing | ~107 | 6.3% | analytical methodology | path pointer (plan §3) |
| Layer 2 Child Cycles | ~124 | 7.3% | stage-by-stage procedure | path pointers |
| Model Selection | ~212 | 12.5% | posture + prohibition dup | doc/workspace pointer |
| Adaptive Thinking Override | ~21 | 1.2% | rule (dup) | no |
| Input File Handling | ~378 | 22.3% | canonical-rule dup | workspace pointer |
| Commit Rules | ~153 | 9.0% | canonical-rule dup | workspace pointer |
| Compaction | ~180 | 10.6% | canonical-rule dup | no |
| Session Boundaries | ~16 | 0.9% | canonical-rule dup (verbatim) | doc pointer |

## Tier 1 — Token Cost

- **[HIGH] Input File Handling · project · ~378 tokens (22.3% of file).** Largest block in the file; exceeds the 15% HIGH line. Meets two independent HIGH criteria: (a) it duplicates content available in a lazy-loaded reference (`ai-resources/docs/file-write-discipline.md`, which the workspace itself points to rather than restates), and (b) it is a six-bullet prose expansion whose detailed sub-rules (operator-pasted verbatim save, legitimate-copying exception, provenance handling) apply to well under 25% of turns. The core "use Read, never Write, on inputs" is one sentence; the other ~340 tokens restate the canonical doc. (Guidance: methodology/pointer-not-restatement.)
- **[MEDIUM] Model Selection · project · ~212 tokens (12.5%).** Exceeds 8% and applies to <50% of turns (session-start concern, not per-turn). Roughly the first third (line 73) restates the workspace Model Tier prohibition; the recommended-posture content (lines 75–77) is legitimately project-specific and explicitly permitted by workspace Model Tier. Trim the prohibition restatement to the pointer that is already present ("See workspace CLAUDE.md § Model Tier"); keep the posture.
- **[MEDIUM] Compaction · project · ~180 tokens (10.6%).** Exceeds 8%; fires only on `/compact` (<25% of turns). The generic preserve-list and "trust the summary" paragraph duplicate the ai-resources Compaction section and workspace compaction-protocol; only the project-specific preserves (pipeline/stage identifier, pending subagent paths, held gate) are non-recoverable elsewhere.
- **[MEDIUM] Commit Rules · project · ~153 tokens (9.0%) (boundary).** Just over the 8% line; self-declared restatement of canonical workspace commit/push behavior. Applies at end-of-work, not per turn. (Redundancy driver below is the primary basis for the HIGH verdict on this block.)
- **[LOW] Purpose · project · ~156 tokens (9.2%) (boundary).** Legitimate orienting context, but line 7 is prose that restates the `pipeline/project-plan.md` design it already points to; compressible to a few bullets without loss.
- **[LOW] Program Shape · project · ~145 tokens (8.6%) (boundary).** The high-level W0→W4 arc is useful always-load; the per-step transformation detail duplicates `project-plan.md` and the referenced `ref-project-plan.md`.

## Tier 2 — Redundancy (cross-file = HIGH)

1. **[HIGH] Input File Handling (project, lines 83–94) ⇄ File Write Discipline (workspace, lines 114–116) + `docs/file-write-discipline.md`.** The project block self-declares (line 94): "This rule mirrors the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`." The workspace does not carry a full "Input File Handling" section — it carries a one-line pointer ("Input files are read-only references — use `Read`, never `Write`/`Edit` against them. Full write-discipline rules: `ai-resources/docs/file-write-discipline.md`."). So the project expands to 378 tokens what the workspace deliberately kept as a pointer. Verbatim-duplication anti-pattern; also creates divergence risk if the canonical doc changes. (Guidance: verbatim duplication across layers.)
2. **[HIGH] Commit Rules (project, lines 96–102) ⇄ File verification and git commits → Commit behavior + Push behavior (workspace, lines 204–218).** Self-declared (line 102): "This rule mirrors the canonical `Commit behavior` section in the workspace-level `CLAUDE.md`." Duplicate clause — project: "Commit directly. Do not ask for permission... Do not run `git status`, `git diff`... do NOT push. Pushes are batched until session end and gated by a single operator confirmation at `/wrap-session`." Workspace: "Commit directly. Do not ask for permission, do not run pre-commit checks (git status, git diff)... Push is **gated and batched**... confirmed via a single prompt at wrap." Also duplicated a third time in ai-resources `## Commit Rules`. Three-layer restatement.
3. **[HIGH] Compaction (project, lines 104–113) ⇄ ai-resources `## Compaction` + workspace Working Principles → Compaction protocol pointer + auto-memory "trust the compaction summary."** Project "preserve on `/compact`" list (pipeline stage, pending subagent paths, held gate) is near-identical to the ai-resources Compaction list; the "Post-compact resumption — trust the summary" paragraph (line 113) restates the standing auto-memory/workspace rule.
4. **[HIGH] Session Boundaries (project, lines 115–117) ⇄ Working Principles → Session boundaries bullet (workspace, line 98).** Near-verbatim: project "Prefer `/clear` over dirty context when switching tasks. Full rule: `ai-resources/docs/session-boundaries.md`." vs. workspace "**Session boundaries.** Prefer `/clear` over dirty context when switching tasks. Full rule: `ai-resources/docs/session-boundaries.md`." Adds zero project-specific content — a clean pure-duplicate. Small in tokens (~16) but flagged HIGH on the divergence-risk basis the guidance attaches to verbatim cross-layer duplication.
5. **[MEDIUM] Model Selection (project, line 73) ⇄ Model Tier (workspace, lines 171–177).** Prohibition restated ("Do not declare a `"model"` field in any `.claude/settings.json`... do not state a default model in this CLAUDE.md") alongside a correct pointer to the workspace section. The pointer is the sanctioned form; the restatement is the redundant part. Spans files but the block also holds legitimate permitted posture — hence MEDIUM (trim the restatement, keep the posture) rather than HIGH-delete.
6. **[MEDIUM] Cross-Model Workflow (project, lines 46–48) ⇄ Cross-Model Rules (workspace, line 25).** "Claude does not substitute its own work for the tool assigned to a task" is restated verbatim; the surrounding project-specific content (spans Claude/GPT-5/Perplexity; each child cycle declares tool-per-step) is legitimate and non-recoverable elsewhere. Trim the duplicated substitution clause to the existing pointer.
7. **[MEDIUM] Adaptive Thinking Override (project, lines 79–81) ⇄ Adaptive Thinking Override (workspace, lines 190–192).** Near-verbatim env-var rule. By strict rubric cross-file duplication is HIGH, but the project version encodes a project-specific determination ("This project is analytical and multi-step" → the workspace conditional resolves to "apply here"), and it is only ~21 tokens — so MEDIUM. Could compress to a single "override applies (analytical project)" line.

## Tier 3 — Contradictions

No contradictions found. Checked specifically:
- **Model default vs. prohibition:** Model Selection's "Recommended posture: Opus for nearly all program work" is **not** a default declaration — it is framed as recommended posture with an explicit "there is no project default" disclaimer, which is exactly what workspace Model Tier permits ("Project-level `CLAUDE.md` may include a `Model Selection` section describing the project's *recommended posture* — recommendations only"). Compliant.
- **Commit/push:** project and workspace agree (commit directly, no mid-session push, gated at wrap). Consistent.
- **Input-handling "ask before writing" (line 91) vs. autonomy/decision-point "pick and proceed":** the ask is narrowly scoped to a missing target path for saving operator-pasted content — a bounded exception, not a conflicting general posture. Not a contradiction.

## Tier 4 — Staleness

- **[MEDIUM] Upstream Inputs — `inputs/nordic-pe-funds-raw.xlsx` "operator-supplied, *placeholder pending*. W0 cannot begin without this file" (line 13).** This is project-status state embedded in an always-loaded file, and it is already tracked in the referenced `inputs/README.md`. Once the operator supplies the file, "placeholder pending" silently goes stale and misleads. Guidance lists "frequently-changing information" as an official exclude. Keep the input identity and the read-only rule; move the pending/status flag to `inputs/README.md` (its existing pointer target).
- **[LOW] Model Selection — dated rationale "Per the operator's task-profile selection at `/new-project` setup (2026-05-27)" (line 75)** and **Upstream Inputs version/date stamps ("approved v3 (2026-05-27)").** These are provenance/version references that must be hand-maintained as artifacts evolve; currently accurate. Low-priority — provenance is arguably better carried in the artifacts' own frontmatter than restated in always-loaded prose.

## Tier 5 — Misplacement

Rationale basis: workspace **CLAUDE.md Scoping** — project CLAUDE.md is for cross-session, every-turn, project-specific rules that cannot live elsewhere; do **not** put skill methodology, workflow methodology, or verbatim canonical workspace rules (short pointer OK, verbatim duplication not). Guidance corroborates ("methodology in the always-loaded file" anti-pattern; content applying to <25% of turns should lazy-load).

- **[HIGH] Input File Handling · project · ~378 tokens (>300).** Verbatim canonical-rule duplication — Scoping says "Canonical workspace rules. Short pointer is acceptable; verbatim duplication is not." >300 tokens ⇒ HIGH per tier rule. **Move target:** replace with a pointer to workspace § File Write Discipline / `ai-resources/docs/file-write-discipline.md`.
- **[MEDIUM] Commit Rules · project · ~153 tokens.** Same class, under 300 tokens ⇒ MEDIUM. **Move target:** pointer to workspace § File verification and git commits (the project already knows this is the canonical home — line 102).
- **[MEDIUM] Layer 2 Child Cycles · project · ~124 tokens.** A numbered stage-by-stage procedure ("1. Open `projects/project-planning/`... 2. Run `/plan-draft` → `/plan-refine` → `/plan-evaluate`... 3. Drop... 4. Execute"). Per Scoping, stage-by-stage instructions belong in reference docs; the procedure fires only when a child cycle opens (<25% of turns). **Move target:** `pipeline/project-plan.md` or a `reference/child-cycle-procedure.md`; keep a one-line pointer plus the "do not scaffold speculatively" bright-line.
- **[MEDIUM] Confidence and Sourcing · project · ~107 tokens.** Analytical methodology (three confidence states + calibration rule) that the block itself sources to `pipeline/project-plan.md §3`. Applies during Phase 2 enrichment turns, not every turn. **Move target:** keep the calibration bright-line ("cost of missing a good fund > cost of reviewing a borderline one") as the standing principle; move the three-state definitions to the plan §3 it already cites.
- **[MEDIUM] Program Shape · project · ~145 tokens.** The detailed per-step transform list duplicates `project-plan.md` / `ref-project-plan.md` methodology. **Move target:** keep the linear W0→W4 arc line as orientation; trim the per-step transform detail to the plan pointer.
- **[MEDIUM] Compaction · project · ~180 tokens.** Fires <25% of turns; largely canonical. **Move target:** keep only the project-specific preserves; point the rest to the ai-resources/workspace compaction rules.
- **[MEDIUM] Model Selection · project.** Partial — the prohibition third belongs behind the pointer; the posture stays. (Same block as Tier 1/Tier 2 MEDIUM.)

## Tier 6 — Clarity

- **[LOW] Program Shape (line 40) — "The Phase 1 pilot must complete before the full-scale Phase 1 run."** "Pilot" is not defined anywhere in the file (scope, size, exit criteria); a reader without `project-plan.md` open cannot tell what the pilot is. Proposed handling: add a two-word gloss or a section pointer to where the pilot is defined.
- **[LOW] Model Selection (line 77) — "large-batch markdown profile QC where the per-record judgment is light."** "Light" is a soft threshold with no bright line; borderline but acceptable given the surrounding concrete examples. Optional tightening only.
- **[LOW] Bottom-up Principle / Confidence and Sourcing — clarity is otherwise strong.** Both carry clean bright lines ("Do not pre-decide taxonomy boundaries"; three explicitly-defined field states). No action.

## Per-Block Verdict Table

### Project CLAUDE.md

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| Purpose | project | ~156 | Trim | Orienting value is real; line-7 prose restates project-plan design it points to | — | guidance: deletion-test |
| Upstream Inputs (canonical) | project | ~68 | Trim | Keep input identity + read-only rule; move "placeholder pending" status to inputs/README.md | `inputs/README.md` (status only) | guidance: frequently-changing-info |
| Program Shape | project | ~145 | Trim | Keep W0→W4 arc; per-step transforms duplicate project-plan | `pipeline/project-plan.md` (detail) | guidance: methodology-in-always-loaded |
| Bottom-up Principle | project | ~70 | Keep | Project-specific bright-line, every-turn relevance, non-recoverable elsewhere | — | priors |
| Cross-Model Workflow | project | ~62 | Trim | Substitution clause duplicates workspace; project tool-list stays | pointer to workspace § Cross-Model Rules | guidance: verbatim-dup |
| Confidence and Sourcing | project | ~107 | Trim/Move | Keep calibration bright-line; move 3-state defs to plan §3 | `pipeline/project-plan.md §3` | guidance: methodology-in-always-loaded |
| Layer 2 Child Cycles | project | ~124 | Move | Stage-by-stage procedure, fires <25% of turns | `pipeline/project-plan.md` / `reference/` | Scoping + guidance: methodology |
| Model Selection | project | ~212 | Trim | Keep permitted posture; trim prohibition restatement to existing pointer | workspace § Model Tier (pointer present) | Scoping + guidance: verbatim-dup |
| Adaptive Thinking Override | project | ~21 | Trim | Cross-file dup; compress to "override applies (analytical project)" | workspace § Adaptive Thinking Override | guidance: verbatim-dup |
| Input File Handling | project | ~378 | Move | >300-token verbatim canonical-rule dup; false "not loaded" premise | workspace § File Write Discipline / `docs/file-write-discipline.md` | Scoping + guidance: pointer-not-restatement |
| Commit Rules | project | ~153 | Move | Self-declared canonical-rule dup (3-layer) | workspace § File verification and git commits | Scoping + guidance: verbatim-dup |
| Compaction | project | ~180 | Trim | Keep project-specific preserves; rest duplicates ai-resources/workspace | ai-resources § Compaction / workspace | guidance: verbatim-dup |
| Session Boundaries | project | ~16 | Delete | Pure verbatim dup of workspace bullet; zero project-specific content | (covered by workspace via ancestor-walk) | guidance: verbatim-dup |

### Workspace CLAUDE.md (audited separately — listed for completeness)

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| What This Workspace Is For | workspace | ~30 | Keep — audited separately | — | — | — |
| Projects | workspace | ~70 | Keep — audited separately | — | — | — |
| Axcíon's Tool Ecosystem | workspace | ~70 | Keep — audited separately | — | — | — |
| Cross-Model Rules | workspace | ~40 | Keep (canonical) | Project Cross-Model Workflow should point here, not restate | — | — |
| Skill Library | workspace | ~70 | Keep — audited separately | — | — | — |
| AI Resource Creation | workspace | ~70 | Keep — audited separately | — | — | — |
| Placement Discipline | workspace | ~230 | Keep — audited separately | — | — | — |
| Design Judgment Principles | workspace | ~55 | Keep — audited separately | — | — | — |
| QC Independence Rule | workspace | ~190 | Keep — audited separately | — | — | — |
| Contract-Conformance Check | workspace | ~160 | Keep — audited separately | — | — | — |
| Blind-Spot Scan Gate | workspace | ~190 | Keep — audited separately | — | — | — |
| Assumptions Gate | workspace | ~90 | Keep — audited separately | — | — | — |
| Completion Standard | workspace | ~80 | Keep — audited separately | — | — | — |
| Requirements-Doc Default | workspace | ~150 | Keep — audited separately | — | — | — |
| Working Principles | workspace | ~320 | Keep (canonical) | Holds the Session boundaries + Compaction pointers the project duplicates | — | — |
| Chat Communication Style | workspace | ~140 | Keep — audited separately | — | — | — |
| File Write Discipline | workspace | ~35 | Keep (canonical) | Canonical home for the project's Input File Handling dup | — | — |
| Autonomy Rules | workspace | ~230 | Keep — audited separately | — | — | — |
| Decision-Point Posture | workspace | ~170 | Keep — audited separately | — | — | — |
| QC → Triage Auto-Loop | workspace | ~25 | Keep — audited separately | — | — | — |
| Session Guardrails | workspace | ~170 | Keep — audited separately | — | — | — |
| Plan Mode Discipline | workspace | ~55 | Keep — audited separately | — | — | — |
| CLAUDE.md Scoping | workspace | ~90 | Keep (canonical) | The meta-rule this project audit enforces | — | — |
| Model Tier | workspace | ~230 | Keep (canonical) | Canonical home for the project Model Selection prohibition dup | — | — |
| Model Escalation | workspace | ~150 | Keep — audited separately | — | — | — |
| Adaptive Thinking Override | workspace | ~35 | Keep (canonical) | Canonical home for the project override dup | — | — |
| File verification and git commits | workspace | ~330 | Keep (canonical) | Canonical home for the project Commit Rules dup | — | — |
| Delivery | workspace | ~30 | Keep — audited separately | — | — | — |
| Agent Harness | workspace | ~55 | Keep — audited separately | — | — | — |

## Estimated Savings

Savings are from trimming/moving the **project** copy only; canonical workspace/ai-resources copies are retained.

- Per turn: **~800 tokens** (conservative)
- Per 30-turn session: **~24,000 tokens**
- Per 50-turn session: **~40,000 tokens**

Breakdown by driver (project blocks):

| Block | Action | ~Tokens saved |
|---|---|---|
| Input File Handling | Move → pointer | ~350 |
| Commit Rules | Move → pointer | ~130 |
| Compaction | Trim to project-specific + pointer | ~110 |
| Layer 2 Child Cycles | Move procedure to reference | ~95 |
| Model Selection | Trim prohibition restatement | ~40 |
| Confidence and Sourcing | Trim 3-state defs → plan §3 | ~35 |
| Program Shape | Trim per-step transforms | ~35 |
| Session Boundaries | Delete (pure dup) | ~16 |
| Cross-Model Workflow | Trim substitution clause | ~15 |
| Adaptive Thinking Override | Compress | ~13 |
| **Total (HIGH+MEDIUM)** | | **~840** (headline rounded to ~800) |

By tier: Tier 1 and Tier 2 overlap heavily (the redundant blocks are also the heavy blocks) — combined ~700 tokens. Tier 5 misplacement (procedure/methodology moves not already counted under redundancy) ~130 tokens. Tier 4 staleness (status-line move) negligible token but removes a drift source. Tiers 3 and 6 carry no token savings.

**Deletion-test summary (official best practice):** every project block was checked against "would removing this cause Claude to make a mistake?" The four Move/Delete blocks fail the test **as full text** because the identical rule is already loaded from the canonical layer via ancestor-walk — removing the restatement changes nothing about behavior, only about token weight and divergence risk.

## External Guidance Cited

- **Verbatim duplication across files/layers** (anti-pattern; contradiction-risk-on-divergence + double cost) — `audit-claude-md-external-guidance-2026-07-03.md` § Identified anti-patterns → drives Tier 2 findings 1–7.
- **Pointer-not-restatement** (best practice; sanctioned way to keep detail out of the always-loaded layer; matches this workspace's own CLAUDE.md Scoping rule) — same file § Identified best practices → drives Input File Handling / Commit Rules move targets.
- **Methodology in the always-loaded file** (anti-pattern; multi-step procedures belong in skills/reference or path-scoped rules) — § anti-patterns → drives Layer 2 Child Cycles, Confidence and Sourcing, Program Shape (Tier 5).
- **Frequently-changing information** (official exclude; goes stale then misleads) — § anti-patterns → drives Upstream Inputs "placeholder pending" (Tier 4).
- **The deletion test** (official) — § best practices → drives the deletion-test summary and Move verdicts.
- **Ancestor-walk loading of workspace-root CLAUDE.md** (long-context note) — § Notes specific to long-context models → refutes the project's "sometimes opened without parent context" duplication rationale.
- **200-line size target** (official; HIGH when materially over) — § anti-patterns → project file at 117 lines is under target (noted as a strength; no finding).
