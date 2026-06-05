# CLAUDE.md Audit — 2026-06-05

**Scope:** workspace + project (project file is the audit target; workspace used as redundancy reference)
**Files audited:**
- Project (target): /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/interpersonal-communication/CLAUDE.md — 45 lines, ~1020 tokens
- Workspace (reference only): /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — used for cross-file redundancy/contradiction checks; not itself scored

**Token-estimation caveat:** Counts are word × 1.3, ±30% drift vs. a real tokenizer. Findings within ±15% of a threshold are tagged `(boundary)`.

## Executive Summary

- Total findings: HIGH: 3 / MEDIUM: 3 / LOW: 2
- Projected token savings if all HIGH+MEDIUM applied: ~620 tokens/turn (~18,600 tokens/session at 30 turns; ~31,000 at 50 turns)
- Net verdict: The project file is ~2x the external-guidance target (~500 tokens) and roughly 60% of its weight is verbatim/near-verbatim restatement of canonical workspace rules; the largest block ("Input File Handling") is both bloated and carries a false "mirrors canonical workspace section" claim — the workspace has no such section. Trim to pointers + a small set of project-specific lines.

## Per-File Inventory

### Project CLAUDE.md (target)

| Block (H2) | Approx tokens | Block type | @-refs |
|---|---|---|---|
| Input File Handling | ~430 | Bright-line + discretionary | — (claims mirror of workspace; no real ref) |
| Commit Rules | ~150 | Bright-line | — (claims mirror of workspace) |
| Compaction | ~190 | Bright-line + guidance | — |
| Session Boundaries | ~35 | Pointer | `ai-resources/docs/session-boundaries.md` |
| Model Selection | ~165 | Bright-line + recommendation | workspace `§ Model Tier` (pointer) |
| (preamble, lines 1–3) | ~40 | Description | — |

Project total ~1010 tokens / 45 lines. External-guidance target: ~500 tokens, behavior-only.

### Workspace CLAUDE.md
Reference only — not scored in this pass (audit target is the project file). Relevant sections cited below: File Write Discipline, Commit behavior, Push behavior, Compaction protocol pointer, Session Boundaries, Model Tier.

## Tier 1 — Token Cost

- **HIGH — "Input File Handling"** (project). ~430 tokens = ~42% of the project file's total, well past the 15% threshold, and it applies to a minority of turns (only turns where the operator drops an input file). Six sub-bullets of explanatory prose (materialize, co-locate, outputs, operator-paste, exception) where the workspace handles the same ground in two lines pointing to `ai-resources/docs/file-write-discipline.md`. This is the single biggest cost driver. Verdict pressure: Trim to a 2-line pointer. Source: external guidance (CLAUDE.md bloat; methodology-belongs-in-docs).
- **MEDIUM — "Compaction"** (project). ~190 tokens (~19% of file), applies only at `/compact` boundaries (<25% of turns). Substance duplicates workspace Compaction protocol + the "trust the summary" auto-memory rule. Candidate for pointer. Source: external guidance (only include what's needed in ~80% of sessions).
- **MEDIUM (boundary) — "Model Selection"** (project). ~165 tokens (~16% of file). The prohibition rationale is fully covered by workspace § Model Tier; only the last "Recommended posture" sentence (Sonnet 1M for KB ops / Opus for synthesis) is project-specific and load-bearing. The prohibition paragraph is redundant restatement. (boundary: 16% vs 15% line.) Note per operator: do not flag the model-default prohibition itself — flagged here only as redundant prose, not as a rule objection.

## Tier 2 — Redundancy

- **HIGH — "Commit Rules" duplicates workspace "Commit behavior" + "Push behavior."** Project lines 20–22 restate, near-verbatim, the canonical commit/push rule. The block even self-declares: *"This rule mirrors the canonical `Commit behavior` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded."* External guidance flags verbatim cross-layer duplication as HIGH (workspace's own CLAUDE.md Scoping rule: "Short pointer is acceptable; verbatim duplication is not"). The "opened without parent context" justification is contested by that scoping rule. Verdict: Trim to pointer.
- **HIGH — "Input File Handling" duplicates workspace "File Write Discipline" (and falsely claims to mirror a non-existent section).** The block asserts it "mirrors the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`" — but the workspace file has **no** `Input File Handling` section (confirmed by grep). The canonical home is workspace "File Write Discipline" → `ai-resources/docs/file-write-discipline.md`. So the block is both redundant (substance lives in the canonical doc) and carries a broken cross-reference. See also Tier 4.
- **MEDIUM — "Session Boundaries"** (project) duplicates workspace "Session Boundaries." Both are one-line pointers to the same `ai-resources/docs/session-boundaries.md`. Within-target this is cheap (~35 tokens), but it is a verbatim cross-layer restatement of a workspace pointer; the project adds nothing project-specific. Within-file severity floor → MEDIUM as cross-layer pointer dup.
- **MEDIUM — "Compaction"** (project) overlaps workspace Compaction protocol pointer + the "trust the compaction summary" auto-memory entry. The post-compact "trust the summary" paragraph (lines 35) restates an existing standing rule.

## Tier 3 — Contradictions

- None found. Project Commit/Push, Compaction, and Model rules align in direction with the workspace canon (they duplicate rather than contradict). No autonomy/commit/scope divergence detected.

## Tier 4 — Staleness

- **HIGH — "Input File Handling" cross-reference is false.** The block's closing line points to a "canonical `Input File Handling` section in the workspace-level `CLAUDE.md`" that does not exist (workspace uses "File Write Discipline"). This is a stale/broken reference on a large block → HIGH (stale + large, per Tier 4 severity rule). Also note a likely editing artifact: line 7 ends with the stray token **"Ninja"** appended to a sentence — orphan text, no meaning in context. Flag for cleanup (clarity/staleness).

## Tier 5 — Misplacement

- The deep input-handling methodology (materialize / co-locate / exception-copy semantics) belongs in `ai-resources/docs/file-write-discipline.md`, not always-loaded project context — per workspace "CLAUDE.md Scoping" (canonical workspace rules: "Short pointer is acceptable; verbatim duplication is not") and external guidance (methodology → docs, pointers not verbatim). Covered under Tier 1/2 HIGH; no separate severity added to avoid double-counting.

## Tier 6 — Clarity

- **LOW — stray "Ninja" token** (project line 7). Orphaned word at end of the Input File Handling intro sentence; no scope or meaning. Likely paste artifact. Remove.
- **LOW — "Recommended posture" lacks a bright-line trigger** (project Model Selection, line 45). "Sonnet 1M for KB operations … Opus for strategic analysis or consultant synthesis" states a preference without a crisp threshold for when a task counts as "strategic analysis." Acceptable as a recommendation (the workspace permits a project Model Selection recommendation), so LOW only.

## Per-Block Verdict Table

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| Input File Handling | project | ~430 | Trim→pointer | 42% of file, minority-turn applicability, duplicates workspace File Write Discipline, false "mirrors" claim, stray "Ninja" token | pointer to `ai-resources/docs/file-write-discipline.md` | external guidance (bloat; methodology→docs) |
| Commit Rules | project | ~150 | Trim→pointer | Near-verbatim cross-layer dup of workspace Commit/Push behavior | pointer to workspace `## Commit behavior` / `## Push behavior` | external guidance (verbatim cross-layer dup) + workspace CLAUDE.md Scoping |
| Compaction | project | ~190 | Trim | <25%-turn applicability; overlaps workspace Compaction protocol + "trust the summary" rule; keep only project-specific preserve-items if any | pointer to `ai-resources/docs/compaction-protocol.md` | external guidance (80%-session rule) |
| Session Boundaries | project | ~35 | Keep | Already a minimal pointer; cheap. Optional delete as cross-layer dup, but low value either way | — | priors |
| Model Selection | project | ~165 | Trim | Keep the project-specific "Recommended posture" line; drop the prohibition-rationale paragraph (covered by workspace § Model Tier). Do NOT touch the prohibition itself (standing decision) | pointer to workspace `§ Model Tier` for rationale | priors (per operator: prohibition not flagged) |
| Preamble (lines 1–3) | project | ~40 | Keep | Legitimate project description; persistent context not inferable from code | — | external guidance (persistent context) |

## Estimated Savings

- Per turn: ~620 tokens (Input File Handling trim ~380; Commit Rules trim ~110; Compaction trim ~90; Model Selection trim ~110; minus ~70 retained as new pointers)
- Per 30-turn session: ~18,600 tokens
- Per 50-turn session: ~31,000 tokens
- Breakdown by tier: Tier 1 ~380 (Input File Handling bloat) · Tier 2 ~200 (Commit + Compaction + Model redundancy) · Tier 4/6 ~40 (stale claim + stray token cleanup, minimal token but corrects a broken reference)

## External Guidance Cited

- CLAUDE.md bloat / per-turn baseline cost, ~500-token target — guidance §"Identified anti-patterns" + §"Notes specific to Opus 4.x" (code.claude.com/docs/en/best-practices; buildtolaunch.substack.com).
- Methodology belongs in skills/docs (pointers, not verbatim) — guidance §"Identified anti-patterns" / §"Identified best practices."
- Verbatim duplication across CLAUDE.md layers is HIGH — guidance §"Identified anti-patterns" (this workspace's own CLAUDE.md Scoping rule).
