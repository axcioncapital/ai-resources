# CLAUDE.md Audit — 2026-06-05

**Scope:** project (axcion-ai-system-owner), with workspace CLAUDE.md as cross-file redundancy reference
**Files audited:**
- Project: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/CLAUDE.md — 78 lines, ~1385 tokens
- Workspace (redundancy reference only, not block-audited): /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md

**Token-estimation caveat:** Counts are word × 1.3, ±30% drift vs. a real tokenizer. Findings within ±15% of a threshold are tagged `(boundary)`.

## Executive Summary

- Total findings: HIGH: 3 / MEDIUM: 4 / LOW: 2
- Projected token savings if all HIGH+MEDIUM applied: ~560 tokens/turn (~16,800 tokens/session at 30 turns; ~28,000 at 50 turns)
- Net verdict: The file is ~1385 tokens against an external-guidance target of ~500; the dominant cost is the 430-token **Input File Handling** block, which verbatim-restates a doc that is already lazy-loaded AND duplicates the file's own **File Write Discipline** pointer — and its "mirrors the canonical Input File Handling section in workspace CLAUDE.md" footer is stale (no such section exists in the workspace file). Collapsing it to a pointer plus three smaller trims brings the file close to target.

## Per-File Inventory — Project CLAUDE.md

| Block (H2) | ~Tokens | Type | @-refs |
|---|---|---|---|
| (preamble, untitled) | ~120 | descriptive context | references/* (implied) |
| Persona | ~110 | descriptive + pointer | references/persona.md |
| Model Selection | ~140 | bright-line + recommendation | agent-tier-table.md |
| Grounding Paths | ~25 | pointer | references/grounding.md |
| Toolkit Relationship | ~95 | descriptive + pointer | references/toolkit-relationship.md |
| Out of Scope at v1 | ~210 | bright-line (5 bullets) | references/toolkit-relationship.md |
| Project Layout | ~25 | pointer | references/project-layout.md |
| File Write Discipline | ~55 | pointer | workspace CLAUDE.md, file-write-discipline.md |
| Commit Rules | ~40 | pointer | workspace CLAUDE.md |
| Compaction | ~70 | bright-line | — |
| Plan-Mode Constraints | ~130 | bright-line + incident note | — |
| Session Boundaries | ~30 | pointer | session-boundaries.md |
| Input File Handling | ~430 | bright-line (verbatim, 6 bullets) | workspace CLAUDE.md, file-write-discipline.md |

Total ~1385 tokens (12 H2 blocks + untitled preamble).

## Tier 1 — Token Cost

- **HIGH — `Input File Handling`** (~430 tokens, 31% of file). Largest block by far; >15% of file tokens and applies to <25% of turns (only when an operator drops an input file into the working dir). It is 6 prose bullets that reproduce, near-verbatim, `ai-resources/docs/file-write-discipline.md` (already a lazy-loadable doc) and overlap the file's own ~55-token `File Write Discipline` pointer. Guidance flags "methodology that belongs in skills/docs" and "CLAUDE.md bloat" as the top per-turn cost driver.[G1][G2] Verdict: Trim to a pointer.
- **MEDIUM — `Out of Scope at v1`** (~210 tokens, 15% of file) `(boundary)`. Five bullets of scoping prose, several of which are inferable from the agent's tool grant (e.g., "No Edit/MultiEdit/Bash" is enforced by the agent's permission scope, not CLAUDE.md). Applies to <50% of turns. Candidate for compression to terse bullets; the tool-scope facts are guidance-class "facts Claude already knows" via settings.[G3] Verdict: Trim.
- **MEDIUM — `Model Selection`** (~140 tokens). The prohibition bright-line + rationale pointer is justified, but the per-command tiering enumeration (listing all six commands again) and the "Recommended posture" sentence restate what frontmatter already binds. Note: the model-default prohibition itself is a standing operator decision — NOT flagged for removal; only the redundant command re-enumeration is trimmable. Verdict: Trim (enumeration only).

## Tier 2 — Cross-File Redundancy

- **HIGH — `Input File Handling` (project) vs. `file-write-discipline.md` (lazy-loaded doc).** The project block's six bullets reproduce the doc near-verbatim (Default to Read, Do not materialize chat content, Operator-pasted save-verbatim with identical flag conditions, Exception — legitimate copying). Quote (project line 75) vs. doc line 11 — the "Operator-pasted content — save verbatim" bullet is word-for-word identical including "do not describe the content." Confirmed by reading the referenced doc. The doc is already reachable via the `File Write Discipline` pointer block. Guidance: "Verbatim duplication across CLAUDE.md layers... duplication is not [acceptable]."[G4] Verdict: Delete the verbatim body, keep a one-line pointer.
- **MEDIUM (within-file) — `File Write Discipline` block vs. `Input File Handling` block.** Both blocks (project lines 38–40 and 67–78) govern the same input-read-only / output-write rule and both point at the same workspace rule + same doc. Two blocks, one rule. Verdict: Merge into the single `File Write Discipline` pointer.
- **MEDIUM — `Commit Rules` (project) vs. workspace `Commit behavior` / `Push behavior`.** Project block is a short faithful pointer ("Follow the canonical Commit behavior rule...") — this is the *acceptable* pattern, not duplication. Listed for completeness; no action. Verdict: Keep.

## Tier 3 — Contradictions

- None found. Autonomy, commit, push, and model rules in the project file are consistent with the workspace file (all are pointers or non-conflicting restatements). The project's "No autonomous action" (Out of Scope) is scoped to the System Owner *persona/agent*, not the session, so it does not contradict the workspace "full autonomy" default.

## Tier 4 — Staleness

- **HIGH — `Input File Handling` footer claim (project line 78).** States: "This rule mirrors the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`." Grep of the workspace CLAUDE.md returns **no `Input File Handling` section** — the workspace file carries `## File Write Discipline` (a short pointer to `file-write-discipline.md`). The footer asserts a canonical anchor that does not exist, so a future reader "reconciling against workspace" will chase a missing section. Stale AND large → HIGH per tier rule. Verdict: the block should collapse to a pointer at the real anchor (`File Write Discipline` → `file-write-discipline.md`).
- **MEDIUM — `Plan-Mode Constraints` incident note (project line 61).** "the 2026-05-20 session lost ~100K tokens..." The standing rule (don't dispatch the agent in plan mode for disk-write commands) is already stated above it in lines 57–59. The dated incident is now baked into the standing rule; it informs nothing on a per-turn basis. Verdict: Trim the incident sentence (keep the rule).

## Tier 5 — Misplacement

- **MEDIUM — `Input File Handling`** belongs in `ai-resources/docs/file-write-discipline.md` (where it already lives) and should lazy-load via the `File Write Discipline` pointer, not always-load. Block is >300 tokens → would be HIGH, but it is downgraded here because the *primary* finding is Tier 2 redundancy (the content is not merely misplaced, it is duplicated). Per workspace "CLAUDE.md Scoping": project CLAUDE.md is for cross-session rules that "cannot live elsewhere" — this content demonstrably lives elsewhere. Verdict: Move (to doc; pointer remains).
- **LOW — preamble (untitled, project lines 1–3).** ~120 tokens describing what v1 exposes (six commands, delegation, agent read map). This is orientation prose largely inferable from the command/agent files. A one-line purpose statement plus pointer to `references/` would serve. Verdict: Trim.

## Tier 6 — Clarity

- **LOW — `Model Selection`** "Recommended posture: Sonnet for routine log appends... Opus for judgment-heavy work (commands handle this via frontmatter)." Since frontmatter binds the tier, the recommended-posture sentence states a preference with no live decision point — mild ambiguity about whether the operator is meant to act on it. Verdict: Trim (covered under Tier 1).
- **LOW — `Out of Scope at v1` → "No skill symlinks at v1."** "if one emerges in v1.1 use, add the symlink then" — conditional with an unspecified trigger ("emerges"). Low-impact. Verdict: Keep (acceptable as a v1 scoping note).

## Per-Block Verdict Table

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| (preamble, untitled) | project | ~120 | Trim | Orientation prose largely inferable from command/agent files | references/ pointer | [G3] |
| Persona | project | ~110 | Keep | Persona voice is genuine per-turn context; already pointer-backed | — | priors |
| Model Selection | project | ~140 | Trim | Prohibition is standing (keep); command re-enumeration + posture sentence are redundant with frontmatter | — | priors |
| Grounding Paths | project | ~25 | Keep | Clean pointer | — | priors |
| Toolkit Relationship | project | ~95 | Keep | Pointer + one load-bearing locked decision | — | priors |
| Out of Scope at v1 | project | ~210 | Trim | Compress to terse bullets; tool-scope facts enforced by permissions | — | [G3] |
| Project Layout | project | ~25 | Keep | Clean pointer | — | priors |
| File Write Discipline | project | ~55 | Keep | Correct pointer pattern; absorb Input File Handling into this | — | [G4] |
| Commit Rules | project | ~40 | Keep | Faithful pointer, not duplication | — | priors |
| Compaction | project | ~70 | Keep | Project-specific preserve-list; per-turn relevant at compact | — | priors |
| Plan-Mode Constraints | project | ~130 | Trim | Keep rule; drop the 2026-05-20 incident narrative | — | priors |
| Session Boundaries | project | ~30 | Keep | Clean pointer | — | priors |
| Input File Handling | project | ~430 | Delete | Verbatim restatement of file-write-discipline.md; duplicates File Write Discipline block; footer cites a non-existent workspace section | ai-resources/docs/file-write-discipline.md (collapse to pointer) | [G1][G2][G4] |

## Estimated Savings

- Per turn: ~560 tokens (Input File Handling collapse ~400; Out of Scope trim ~70; Plan-Mode incident ~40; Model Selection enumeration ~30; preamble trim ~20 — netted against retained pointers)
- Per 30-turn session: ~16,800 tokens
- Per 50-turn session: ~28,000 tokens
- Breakdown by tier: Tier 1 ~470 (Input File Handling + Out of Scope + Model Selection) · Tier 2 overlaps Tier 1 (same Input File Handling block, not additive) · Tier 4 ~40 (Plan-Mode incident) · Tier 5 overlaps Tier 1/2 · Tier 6 negligible (folded into Tier 1)
- Post-trim file estimate: ~825 tokens (from ~1385) — still above the ~500 guidance target but within reach via the preamble/Out-of-Scope compressions.

## External Guidance Cited

- [G1] "CLAUDE.md bloat — file loads before anything; costs every turn. Target under ~500 tokens, behavior-only." — guidance synthesis line 10
- [G2] "Methodology that belongs in skills/docs — only include what's needed in ~80% of sessions; the rest goes to skills/docs as pointers, not verbatim." — guidance synthesis line 13
- [G3] "Including facts Claude already knows... inferable from the repo. Belongs nowhere in always-loaded context." — guidance synthesis line 12
- [G4] "Verbatim duplication across CLAUDE.md layers — workspace rule restated in project CLAUDE.md. Pointer is acceptable; duplication is not." — guidance synthesis line 14
