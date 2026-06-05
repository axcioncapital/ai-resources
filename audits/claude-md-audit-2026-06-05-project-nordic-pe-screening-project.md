# CLAUDE.md Audit — 2026-06-05

**Scope:** workspace + project (project file is the audit target; workspace used as redundancy reference)
**Files audited:**
- Project: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-screening-project/CLAUDE.md — 117 lines, ~1921 tokens
- Workspace (reference only): /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — not block-audited; used to detect cross-file redundancy

**Token-estimation caveat:** Counts are word × 1.3, ±30% drift vs. a real tokenizer. Findings within ±15% of a threshold are tagged `(boundary)`.

## Executive Summary

- Total findings: HIGH: 4 / MEDIUM: 5 / LOW: 2
- Projected token savings if all HIGH+MEDIUM applied: ~760 tokens/turn (~22,800 tokens/session at 30 turns; ~38,000 at 50 turns)
- Net verdict: The project file is roughly 4x the external-guidance target (~500 tokens) and ~40% of its weight is verbatim-mirrored workspace rules that the file itself labels "repeated here" — collapse those to pointers and trim the two largest blocks to reclaim the majority of per-turn cost.

## Per-File Inventory

### Project CLAUDE.md
| Block | ~Tokens | Type | @-refs |
|---|---|---|---|
| Purpose | 190 | Context/explanatory | pipeline/project-plan.md |
| Upstream Inputs (canonical) | 110 | Context + pointer | 3 paths |
| Program Shape | 200 | Context + ASCII diagram | ref-project-plan.md |
| Bottom-up Principle | 95 | Discretionary guidance | — |
| Cross-Model Workflow | 85 | Rule + pointer | cross-model-rules.md |
| Confidence and Sourcing | 130 | Bright-line rule | project-plan.md §3 |
| Layer 2 Child Cycles | 140 | Workflow methodology | project-planning paths |
| Model Selection | 270 | Rule + recommendation | workspace Model Tier |
| Adaptive Thinking Override | 40 | Rule (duplicate) | settings.local.json |
| Input File Handling | 330 | Rule (self-declared mirror) | workspace CLAUDE.md |
| Commit Rules | 150 | Rule (self-declared mirror) | workspace CLAUDE.md |
| Compaction | 165 | Rule (overlap) | — |
| Session Boundaries | 25 | Pointer (duplicate) | session-boundaries.md |

(Workspace blocks not inventoried — reference file only, per scope.)

## Tier 1 — Token Cost

- **HIGH — `Input File Handling`** (~330 tok, ~17% of file). Largest block; six sub-bullets of write-discipline mechanics (cp/cat/tee enumeration, materialize-chat rule, provenance rule, exception clause). Applies to a minority of turns (only when an input file is in play) yet loads every turn. The block's own closing line says it "mirrors the canonical Input File Handling section in the workspace CLAUDE.md." A pointer would serve. Exceeds 15% of file AND applies to <25% of turns.
- **HIGH — `Model Selection`** (~270 tok, ~14% of file) `(boundary)`. Half the block re-states the no-model-default prohibition mechanics (settings.json field, frontmatter-only mechanism) already canonical in workspace Model Tier; only the "Recommended posture" paragraph is legitimate project content. The prohibition restatement is the trimmable portion (~120 tok). (Prohibition rule itself is a standing decision — not flagged; only its verbatim duplication is.)
- **MEDIUM — `Purpose` + `Program Shape`** (~390 tok combined, ~20% of file). Long explanatory prose plus a full ASCII artifact-chain diagram. Useful orientation but reads as design narrative duplicated from `pipeline/project-plan.md` (cited as "canonical v3"). Compressible to a 4–5 line summary + pointer; the diagram could lazy-load from the plan.
- **MEDIUM — `Compaction`** (~165 tok). Detailed compaction mechanics that apply only at `/compact` boundaries (<25% of turns). Overlaps workspace `compaction-protocol.md` and the auto-memory "trust the compaction summary" note.

## Tier 2 — Redundancy (cross-file)

- **HIGH — `Input File Handling`** ↔ workspace `File Write Discipline`. Project block self-declares: *"This rule mirrors the canonical Input File Handling section in the workspace-level CLAUDE.md. It is repeated here because projects are sometimes opened without the parent workspace context loaded."* Workspace handles this with a one-line pointer to `ai-resources/docs/file-write-discipline.md`; the project re-expands ~330 tokens of it. Verbatim-duplication-across-layers anti-pattern (guidance §"Verbatim duplication across CLAUDE.md layers", SEVERITY high).
- **HIGH — `Commit Rules`** ↔ workspace `Commit behavior` + `Push behavior`. Project block self-declares it *"mirrors the canonical Commit behavior section."* ~150 tokens restating commit-direct + gated-push, already canonical at workspace level. Same anti-pattern.
- **MEDIUM — `Adaptive Thinking Override`** ↔ workspace `Adaptive Thinking Override` (same heading). Both say "set `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1` in settings.local.json." Project adds only "this project is analytical" — one fact, ~40 tok of duplication.
- **MEDIUM — `Session Boundaries`** ↔ workspace `Working Principles › Session boundaries`. Both reduce to the identical pointer "`Prefer /clear … Full rule: ai-resources/docs/session-boundaries.md`." Duplicate pointer adds no project-specific content.
- **MEDIUM — `Cross-Model Workflow`** ↔ workspace `Axcíon's Tool Ecosystem` + `Cross-Model Rules`. Project restates "Claude does not substitute its own work for the tool assigned to a task" verbatim from workspace. The project-specific part (which 3 tools, step-level declaration) is legitimate; the substitution rule is duplicate.

**Self-justification note:** The "repeated here because projects are sometimes opened without parent workspace context" rationale recurs in three blocks. Under this workspace's own CLAUDE.md Scoping rule ("Short pointer is acceptable; verbatim duplication is not") that rationale does not license full duplication — a pointer satisfies the same need at ~1/10 the cost.

## Tier 3 — Contradictions

- None found. Project autonomy/commit/push posture is consistent with workspace; model guidance is framed as recommendation (not a default), consistent with the prohibition.

## Tier 4 — Staleness

- **MEDIUM — `Model Selection`** references the recommended model as **`Opus 4.7 (claude-opus-4-7)`**. The current operating model line is Opus 4.8 (`claude-opus-4-8[1m]`). The pinned `claude-opus-4-7` identifier is a dated artifact tied to the 2026-05-27 `/new-project` setup; if left, it recommends a superseded model. The recommendation framing is sound; the version string is stale. (Tagged MEDIUM, not HIGH — block is large but the staleness is one identifier, not the whole block.)
- **Note (not a finding):** `claude-sonnet-4-6[1m]` correctly carries the `[1m]` suffix per the standing convention — verified correct, not stale.

## Tier 5 — Misplacement

- **HIGH — `Input File Handling`** belongs in `ai-resources/docs/file-write-discipline.md` (where the workspace already points), not duplicated in a project file. >300 tokens → HIGH per tier rule. Project file should carry at most a one-line pointer.
- **MEDIUM — `Layer 2 Child Cycles`** (~140 tok) is workflow methodology — the `/context-builder → /plan-draft → /plan-refine → /plan-evaluate` sequence and "do not scaffold speculatively" rule read as procedure that belongs in the program plan or a workflow reference, not always-loaded project context. Per workspace CLAUDE.md Scoping: "Workflow methodology belongs in the workflow's reference docs."
- **MEDIUM — `Commit Rules`** belongs as a workspace-level canonical (already is) referenced by pointer; the project re-host is misplacement of canonical workspace rules ("Canonical workspace rules — short pointer is acceptable; verbatim duplication is not").

## Tier 6 — Clarity

- **LOW — `Bottom-up Principle`**. "Do not pre-decide taxonomy boundaries when working on this project" is directionally clear but lacks an applicability threshold — when does a working assumption become a "pre-decided boundary"? The rule states a preference without a bright-line. Minor; project is early-stage so drift risk is low.
- **LOW — `Confidence and Sourcing`**. "Flag borderline funds for review" — "borderline" is undefined (no numeric/criterion threshold). The calibration maxim is clear; the trigger is soft. Acceptable as judgment guidance but worth a threshold if drift appears.

## Per-Block Verdict Table

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| Purpose | project | 190 | Trim | Explanatory narrative duplicated from canonical plan; compress to summary + pointer | — | guidance §CLAUDE.md bloat |
| Upstream Inputs (canonical) | project | 110 | Keep | Project-specific, load-bearing paths (incl. W0 blocker file); pointer-shaped | — | priors |
| Program Shape | project | 200 | Trim | ASCII diagram + prose duplicates project-plan.md; summarize, lazy-load diagram | pipeline/project-plan.md | guidance §bloat |
| Bottom-up Principle | project | 95 | Keep | Genuine per-turn project rule, not inferable; tighten threshold optionally | — | priors |
| Cross-Model Workflow | project | 85 | Trim | Keep tool list; drop substitution sentence (workspace canonical) | — | guidance §duplication |
| Confidence and Sourcing | project | 130 | Keep | Bright-line project rule, applies broadly; soft "borderline" trigger only | — | priors |
| Layer 2 Child Cycles | project | 140 | Move | Workflow methodology, not every-turn rule | pipeline/project-plan.md or workflow reference | CLAUDE.md Scoping |
| Model Selection | project | 270 | Trim | Keep recommended-posture para; drop duplicated prohibition mechanics; fix stale `claude-opus-4-7` | workspace Model Tier (pointer) | guidance §duplication + staleness |
| Adaptive Thinking Override | project | 40 | Trim | Collapse to one-line pointer to workspace section | workspace Adaptive Thinking Override | guidance §duplication |
| Input File Handling | project | 330 | Delete | Self-declared verbatim mirror of workspace canonical; replace with pointer | ai-resources/docs/file-write-discipline.md | guidance §duplication |
| Commit Rules | project | 150 | Delete | Self-declared verbatim mirror of workspace canonical; replace with pointer | workspace Commit/Push behavior | guidance §duplication |
| Compaction | project | 165 | Trim | Applies only at /compact; overlaps workspace protocol + memory; compress to pointer + project-specific preserve-list | ai-resources/docs/compaction-protocol.md | guidance §methodology-in-docs |
| Session Boundaries | project | 25 | Delete | Duplicate pointer identical to workspace; no project content | — | guidance §duplication |

## Estimated Savings

- Per turn: ~760 tokens (Input File Handling delete-to-pointer ~300; Commit Rules ~130; Model Selection trim ~120; Compaction trim ~90; Purpose/Program Shape trim ~80; Adaptive Thinking ~30; Session Boundaries ~10)
- Per 30-turn session: ~22,800 tokens
- Per 50-turn session: ~38,000 tokens
- Breakdown by tier: Tier 1 ~290 (Input/Model/Purpose/Shape trims) · Tier 2 ~400 (Commit, Input mirror, Adaptive, Session Boundaries, Cross-Model) · Tier 4 ~0 (correctness fix, not size) · Tier 5 overlaps Tier 2 (Input File Handling, Layer 2 ~140 if moved). Figures overlap where one block triggers multiple tiers — counted once in the per-turn total.

## External Guidance Cited

- CLAUDE.md bloat — per-turn baseline cost; target ~500 tokens / 150–200 lines (file is ~1921 tokens, ~4x target). [guidance: code.claude.com best-practices; buildtolaunch; agensi.io]
- Verbatim duplication across CLAUDE.md layers — "pointer is acceptable; duplication is not," SEVERITY high; flagged as this workspace's own rule. [guidance §anti-patterns; workspace CLAUDE.md Scoping]
- Methodology that belongs in skills/docs — pointer-not-verbatim for deep methodology (Layer 2 Child Cycles, Compaction, Input File Handling). [guidance §best practices]
- Long context does NOT excuse bloat — Opus 1M still pays the always-loaded tax every turn. [guidance §Opus 4.x notes]
