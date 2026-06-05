# CLAUDE.md Audit — 2026-06-05

**Scope:** workspace + project (project file is the target; workspace used as redundancy reference)
**Files audited:**
- Project (target): `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/marketing-positioning/CLAUDE.md` — 161 lines, ~2,776 tokens
- Workspace (reference only): `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` — redundancy comparison only, not itself audited

**Token-estimation caveat:** Counts are word × 1.3, ±30% drift vs. a real tokenizer. Findings within ±15% of a threshold are tagged `(boundary)`. The ~2,776-token project file is ~5.5× the external-guidance target of ~500 tokens / 150–200 behavior-only lines.

## Executive Summary

- Total findings: **HIGH: 4 / MEDIUM: 6 / LOW: 3**
- The project file is dominated by **methodology and project-narrative prose** (sequence rationale, framework anchors, checkpoint logic, channel-ownership theory) that does not apply to every turn and largely belongs in the project plan / pipeline docs, not always-loaded context. Roughly **half the file's tokens** (~1,400) describe the *production method*, not standing per-turn behavior.
- One **contradiction** (HIGH): the project's `Commit Rules` push instruction conflicts with the workspace's gated-batch-push rule.
- One **stale mirror claim** (HIGH): `Input File Handling` says it mirrors a canonical workspace section that **does not exist** — the workspace has only a 2-line `File Write Discipline` pointer; the project section instead duplicates the lazy-loaded `file-write-discipline.md` doc near-verbatim.
- Projected token savings if all HIGH+MEDIUM applied: **~1,250 tokens/turn** (~37,500 tokens / 30-turn session; ~62,500 / 50-turn session).
- **Net verdict:** Prime trim target — convert four methodology blocks to a single project-plan pointer, delete two duplicated mirror blocks, and reconcile the push contradiction. Standing behavioral rules (autonomy gates, AI-as-substrate, model posture) stay.

## Per-File Inventory

### Project CLAUDE.md (`projects/marketing-positioning/CLAUDE.md`)

| Block (H2) | ~Tokens | Type | @-refs |
|---|---|---|---|
| What This Project Is | 130 | project-narrative | — |
| Organizing Framework — verbal system | 320 | methodology | `00_foundation.md §4.5` (textual) |
| Channel-Copy Ownership Boundary | 120 | methodology | — |
| AI-as-Substrate Rule | 100 | bright-line guidance | — |
| Voice-Authoring Discipline | 180 | methodology + bright-line | `logs/decisions.md` |
| Embedded Consultant | 140 | behavior (load-rule) | `_consultants/embedded-consultant.md` |
| Reference-Input Map | 140 | behavior + pointer | `reference/source-map.md` |
| Method-Notes Byproduct (capped) | 110 | methodology | `reference/method-notes.md` |
| Autonomy Posture & Decision Gates | 230 | bright-line gates | — |
| Checkpoints | 200 | methodology | project-plan §8 (textual) |
| Cross-Project Deferred Writes | 230 | bright-line (rare) | `corporate-identity/...` paths |
| Model Selection | 130 | posture + pointer | workspace § Model Tier |
| Directory Layout | 150 | facts/structure | — |
| Input File Handling | 520 | duplicate-of-doc | mirrors (nonexistent) workspace §; dup of `file-write-discipline.md` |
| Commit Rules | 180 | duplicate + contradiction | mirrors workspace § |
| Compaction | 180 | behavior | — |
| Session Boundaries | 40 | pointer | `ai-resources/docs/session-boundaries.md` |

17 H2 blocks. Total ~2,776 tokens (matches brief estimate).

## Tier 1 — Token Cost

- **HIGH — `Organizing Framework — the verbal system` (~320 tokens, ~11.5% of file).** Long prose explaining the B-L1 → A → B-L2 dependency order, the bidirectional coupling rationale, and three "method anchors" (Dunford, §4.5, Pyramid Principle). This is one-time production-sequencing logic decided at planning — it applies to *sequencing decisions*, not every turn (<25% of turns). The rationale paragraph (lines 20) restates lines 9 verbatim. Belongs in the project plan / `pipeline/` artifact with a one-line pointer here. Source: external-guidance "methodology that belongs in skills/docs" + "CLAUDE.md bloat."
- **HIGH — `Input File Handling` (~520 tokens, ~19% of file).** Single largest block, near-verbatim copy of the lazy-loaded `ai-resources/docs/file-write-discipline.md`. See Tier 2 — duplicates always-loaded what is already a pointer-able doc. Source: external-guidance "verbatim duplication across CLAUDE.md layers."
- **MEDIUM — `Checkpoints` (~200 tokens, ~7% of file) (boundary).** Three-checkpoint gate logic with embedded test questions. This is workflow-phase methodology (project-plan §8 is even cited) that applies only at checkpoint transitions, not per turn. Compress to a pointer into the project plan. Source: external-guidance "methodology belongs in docs."
- **MEDIUM — `Autonomy Posture & Decision Gates` (~230 tokens).** The five enumerated tier-C gates (W2.3/W2.5/W3.1/W3.6/W3.7) are project-specific decision points that fire at specific work-units, not every turn. The *posture* statement (tier-B skew; don't mix tier-C with tier-B in one session) is legitimately standing and should stay; the five-gate enumeration could move to the project plan. Partial trim.
- **MEDIUM — `Cross-Project Deferred Writes` (~230 tokens).** Two execution-time write actions (W4.3, W3.1) that fire once each, late in the project. Heavy always-loaded weight for two rare-but-critical actions. The "never silently omit/execute" guard is the load-bearing part; the surrounding detail (which file, which §, repoint logic) can live in the project plan with a one-line standing pointer. Keep a thin guard, move the detail.
- **LOW — `What This Project Is` (~130 tokens).** Project-narrative. Some is inferable/one-time orientation, but a short project identity block is defensible as standing context. Trim the parenthetical asides.

## Tier 2 — Redundancy

- **HIGH — `Input File Handling` duplicates `ai-resources/docs/file-write-discipline.md`.** The block's bullets (Default to Read; Do not materialize chat content; Operator-pasted content save verbatim; Exception — legitimate copying) are near-verbatim with the doc's lines 9–12. The doc is lazy-loaded via the workspace `File Write Discipline` pointer. The project file should carry at most a one-line bright-line + pointer, not the full enumeration. The closing claim *"This rule mirrors the canonical `Input File Handling` section in the workspace-level CLAUDE.md"* is **false** — the workspace has no `Input File Handling` section (it has `## File Write Discipline`, a 2-line pointer). See also Tier 4 (stale mirror claim).
- **HIGH — `Commit Rules` duplicates workspace `Commit behavior` / `Push behavior`.** Cross-file verbatim-equivalent duplication. Quote (project): *"Commit directly. Do not ask for permission… Do not run `git status`, `git diff`… the filesystem is the source of truth."* Quote (workspace `Commit behavior`): *"Commit directly. Do not ask for permission, do not run pre-commit checks (git status, git diff)…"*. The "repeated because projects are opened without parent workspace context" justification is the project's standing pattern, but per workspace `CLAUDE.md Scoping` ("Short pointer is acceptable; verbatim duplication is not") this should be a pointer. (Note: this block also *contradicts* the workspace on push — see Tier 3.)
- **MEDIUM — `Session Boundaries` (~40 tokens) duplicates workspace `Working Principles → Session boundaries`,** both pointing to the same `ai-resources/docs/session-boundaries.md`. The project block is already a thin pointer; near-zero cost but strictly redundant with the workspace pointer.
- **MEDIUM — `Compaction` overlaps workspace `Compaction protocol` pointer + ai-resources `Compaction` block.** The project's preserve-list (pipeline/stage id, unread subagent paths, pending gate) and "trust the summary" rule restate the ai-resources `Compaction` block and the MEMORY "trust the compaction summary" prior. Project-specific items (pending operator gate) justify a *short* block; the "trust the summary / cost test" paragraph is duplicated standing behavior — compress to a pointer.

## Tier 3 — Contradictions

- **HIGH — `Commit Rules` (project) vs. workspace `Push behavior` + ai-resources `Commit Rules`.** Project says: *"Do not push. Pushing is a manual operator step. After committing, remind the operator to push…"*. Workspace says push is **gated and batched** and **executed by Claude at wrap** after a single y/n confirmation: *"On `y`: run `git push` per repo."* The ai-resources file matches the workspace (gated-batch, Claude pushes on `y`). The project file instead frames push as a fully manual operator step Claude never runs. **Divergent behavior scenario:** at `/wrap-session`, operator says "ship it" → workspace/ai-resources rule has Claude issue the y/n prompt and run `git push`; the project rule tells Claude push is manual and to *remind the operator to push themselves*. The MEMORY prior ("Push is gated and batched… rule inverted 2026-05-29") confirms the workspace/ai-resources version is current and the project block is the stale loser. HIGH (contradictions silently corrupt behavior).

## Tier 4 — Staleness

- **HIGH — `Input File Handling` stale mirror claim (also large).** Line 138: *"This rule mirrors the canonical `Input File Handling` section in the workspace-level CLAUDE.md."* No such section exists in the current workspace file (confirmed by grep — only `## File Write Discipline` is present, a pointer to the doc). The mirror target was apparently refactored into a pointer + doc; the project copy was not updated. Stale + large (~520 tokens) → HIGH.
- **MEDIUM — `Commit Rules` mirror claim drifted.** Line 146 says it mirrors "the canonical `Commit behavior` section" — that section does exist, but the project copy's push instruction is the **pre-2026-05-29 (inverted) version**, so the mirror is stale on the push half. Reconcile or repoint to a pointer.
- **LOW — `Model Selection` cites `pipeline/decisions.md #2`; `Voice-Authoring Discipline` cites `logs/decisions.md entry #6` / "architecture Decision 4"; `Method-Notes` cites "architecture Decision 5."** These decision-log references can't be filesystem-verified from the passed inputs and may drift as logs are renumbered. Not flagged as broken — noted as a currency-risk for the operator to spot-check.

## Tier 5 — Misplacement

Per workspace `CLAUDE.md Scoping` ("Project-level CLAUDE.md is for cross-session project-specific rules only — content that applies to *every turn*… Workflow methodology belongs in the workflow's reference docs"):

- **HIGH — `Organizing Framework` (~320 tokens) → project plan / `pipeline/` reference.** Production-sequence methodology and framework anchors. >300 tokens → HIGH. Source: external-guidance + workspace Scoping.
- **MEDIUM — `Channel-Copy Ownership Boundary` (~120 tokens) → project plan or Deliverable A/B spec.** "Load-bearing across Part 3 and Part 4" by its own admission — i.e., it applies in two phases, not every turn. The A-decides-content / B-decides-voice bright-line could survive as one line; the W3.7↔W4.2 seam detail moves.
- **MEDIUM — `Checkpoints` (~200 tokens) → project plan §8 (already cited).** Phase-gate methodology.
- **MEDIUM — `Method-Notes Byproduct` (~110 tokens) → project plan / reference.** Describes how to cap a byproduct file; this is an authoring-method note, not a per-turn rule. A one-line "method-notes are capped — see plan" pointer suffices.
- **LOW — `Directory Layout` (~150 tokens) → inferable/orientation.** Partly inferable from the filesystem (external-guidance: "facts Claude already knows / inferable from the repo"). The load-rules embedded in it (consultant loaded every work unit; reference loaded on-demand) duplicate the `Embedded Consultant` / `Reference-Input Map` blocks. Trim to the non-obvious load-timing notes.

## Tier 6 — Clarity

- **MEDIUM — `AI-as-Substrate Rule`.** "When unsure whether a difference should be foregrounded, default to keeping AI as substrate and surface the question" — the bright-line (default = substrate) is clear, but "when unsure" lacks a threshold. Acceptable as judgment guidance; minor.
- **LOW — `Autonomy Posture` "soft gate."** "the deferred free-model elevation decision at Checkpoint B… do not silently default it" — "free-model elevation" is unglossed jargon; the condition that triggers surfacing it beyond "at Checkpoint B" is unspecified. Low.
- **LOW — `Voice-Authoring Discipline` "non-binding starting point" vs. "must trace to."** Slot 5 tone seed is both a permitted trace-target *and* "non-binding" — mild tension in whether a principle tracing only to Slot 5 is adequately grounded. Clarify precedence.

## Per-Block Verdict Table

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| What This Project Is | project | 130 | Trim | Project-narrative; keep short identity, drop asides | — | external-guidance |
| Organizing Framework — verbal system | project | 320 | Move | Production-sequence methodology, <25% of turns, >300 tok | `projects/marketing-positioning/pipeline/` plan + 1-line pointer | external-guidance + workspace Scoping |
| Channel-Copy Ownership Boundary | project | 120 | Move (partial) | Applies in Part 3/4 only; keep 1-line bright-line | project plan / Deliverable spec | workspace Scoping |
| AI-as-Substrate Rule | project | 100 | Keep | Standing positioning bright-line, every-turn relevant | — | priors |
| Voice-Authoring Discipline | project | 180 | Trim | Keep flag-gaps/escalation bright-line; move §4.5-trace method detail | project plan | workspace Scoping |
| Embedded Consultant | project | 140 | Keep | Standing per-work-unit load rule + role boundary | — | priors |
| Reference-Input Map | project | 140 | Keep | Standing read-only source pointer; legitimate | — | priors |
| Method-Notes Byproduct (capped) | project | 110 | Move | Authoring-method note, not per-turn | project plan / reference | external-guidance |
| Autonomy Posture & Decision Gates | project | 230 | Trim | Keep posture + no-mix rule; move 5-gate enumeration | project plan | workspace Scoping |
| Checkpoints | project | 200 | Move | Phase-gate methodology; §8 already cited | project plan §8 | external-guidance |
| Cross-Project Deferred Writes | project | 230 | Trim | Keep thin never-silent guard; move per-write detail | project plan | workspace Scoping |
| Model Selection | project | 130 | Keep | Standing posture + no-default rule (do NOT flag per brief) | — | priors |
| Directory Layout | project | 150 | Trim | Partly inferable; dedup load-rules vs other blocks | — | external-guidance |
| Input File Handling | project | 520 | Delete | Duplicates lazy-loaded doc; mirror target nonexistent | replace w/ 1-line pointer to `file-write-discipline.md` | external-guidance + grep |
| Commit Rules | project | 180 | Delete | Duplicates workspace; push half contradicts current rule | replace w/ pointer to workspace Commit/Push behavior | external-guidance + MEMORY prior |
| Compaction | project | 180 | Trim | Keep project-specific preserve items; dedup "trust summary" | pointer to compaction-protocol doc | external-guidance |
| Session Boundaries | project | 40 | Keep | Already a thin pointer; near-zero cost | — | priors |

## Estimated Savings

Assumes Delete = full removal (less ~15-token pointer), Move = full removal from always-loaded (less ~15-token pointer), Trim = ~50% reduction.

- **Per turn: ~1,250 tokens** (HIGH+MEDIUM applied).
- Per 30-turn session: **~37,500 tokens**.
- Per 50-turn session: **~62,500 tokens**.
- Breakdown by tier:
  - Tier 1/5 Moves (Organizing Framework 305, Checkpoints 185, Method-Notes 95): **~585**
  - Tier 1/5 Trims (Autonomy gates ~115, Cross-Project ~115, Voice-Authoring ~90, Directory ~75, Compaction ~90, Channel-Copy ~60): **~545**
  - Tier 2/4 Deletes (Input File Handling ~505, Commit Rules ~165): **~670** — overlaps Tier 1 count for Input File Handling; net unique ~120 beyond Tier 1 attribution.
  - Net (deduplicated across tiers): **~1,250 tokens/turn**.

## External Guidance Cited

- CLAUDE.md bloat / ~500-token, 150–200-line, behavior-only target — `code.claude.com/docs/en/best-practices`; synthesis lines 10, 17.
- Methodology belongs in skills/docs; ~80%-of-sessions inclusion test — synthesis line 13.
- Verbatim duplication across CLAUDE.md layers is an anti-pattern (workspace's own rule); pointer acceptable — synthesis line 14.
- Facts inferable from the repo do not belong in always-loaded context — synthesis line 12.
- Long context does not excuse bloat; per-turn baseline tax — synthesis lines 22–24.
