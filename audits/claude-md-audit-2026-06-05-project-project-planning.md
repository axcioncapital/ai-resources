# CLAUDE.md Audit — 2026-06-05

**Scope:** project (project-planning) + workspace (redundancy reference only)
**Files audited:**
- Project: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/CLAUDE.md` — 102 lines, ~1709 tokens
- Workspace: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` — redundancy reference only (not block-audited)

**Token-estimation caveat:** Counts are word × 1.3, ±30% drift vs. real tokenizer. Findings within ±15% of a threshold are tagged `(boundary)`. 8% of file = ~137 tokens; 15% = ~256 tokens.

## Executive Summary

- Total findings: HIGH: 2 / MEDIUM: 4 / LOW: 2
- Projected token savings if all HIGH+MEDIUM applied: ~620 tokens/turn (~18,600 tokens/session at 30 turns; ~31,000 at 50 turns)
- Net verdict: The file is roughly 3.4× the external-guidance target (~500 tokens) and is dominated by two large rule-blocks (`Input File Handling`, `Commit Rules`) that the file itself flags as verbatim mirrors of workspace rules — trimming the duplicates and the descriptive scaffolding (`How It Works`, `Commands`, `Output Convention`) to pointers gets the file close to a behavior-only baseline.

## Per-File Inventory

### Project CLAUDE.md

| Block | ~Tokens | Type | @-refs |
|---|---|---|---|
| Purpose | ~55 | descriptive | — |
| How It Works | ~190 | descriptive/workflow | refs commands |
| Commands | ~175 | descriptive (table) | refs commands |
| Output Convention | ~70 | descriptive | — |
| Reference Documents | ~50 | pointer | 3 pipeline refs |
| Skill References | ~60 | pointer | 2 SKILL.md |
| Versioning | ~50 | rule | — |
| Relationship to /new-project | ~75 | descriptive | — |
| Model Selection | ~150 | guidance/posture | refs workspace |
| Commit Rules | ~210 | bright-line rule | mirrors workspace |
| Input File Handling | ~330 | bright-line rule | mirrors workspace |
| Compaction | ~150 | rule | — |
| Session Boundaries | ~30 | pointer | 1 doc |

(13 H2 blocks; total ~1709 tokens.)

## Tier 1 — Token Cost

- **HIGH — `Input File Handling`** (~330 tokens, ~19% of file). Largest block; six sub-bullets of prose. Applies only on turns where an external input file is dropped in — well under 25% of typical planning turns. Exceeds the 15% share threshold and is low-frequency. Guidance flags methodology/edge-case prose as pointer-eligible.[g13]
- **MEDIUM — `Commit Rules`** (~210 tokens, ~12% of file) `(boundary)`. Long prose restating workspace commit/push behavior plus a symlink edge-case. The symlink `git add` caveat is project-specific and worth keeping; the commit/push prose is duplicated (see Tier 2). Over 8% share, applies only on commit turns (<50%).
- **MEDIUM — `How It Works` + `Commands`** (~365 tokens combined, ~21% of file). Two descriptive blocks that explain the pipeline and list command purposes — facts inferable from the command files themselves and not behavior rules. Guidance: exclude facts Claude can read from the repo; descriptive scaffolding is not always-load material.[g12][g17]

## Tier 2 — Redundancy

- **HIGH — `Input File Handling` (project) vs. workspace `File Write Discipline`.** The project block self-declares: *"This rule mirrors the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`."* Workspace already covers input read-only handling (`File Write Discipline` → `ai-resources/docs/file-write-discipline.md`). ~330 tokens of largely verbatim duplication across layers. Guidance: verbatim duplication across layers is HIGH (workspace's own rule).[g14] Note: the "opened without parent workspace context" justification is real but is satisfied by a short pointer, not a full restatement.
- **HIGH — `Commit Rules` (project) vs. workspace `Commit behavior` + `Push behavior`.** Block self-declares it *"mirrors the canonical `Commit behavior` section in the workspace-level `CLAUDE.md`."* The commit-directly / push-gated prose duplicates workspace verbatim. Only the **symlink `git add` caveat** (lines 74) is project-unique and non-redundant.
- **MEDIUM — `Compaction` (project) vs. workspace `Working Principles` → compaction-protocol + project `Post-compact resumption` vs. MEMORY "trust the compaction summary."** The post-compact "trust the summary" paragraph (line 98) restates a standing memory/workspace rule. Within project file it pairs with the generic compaction list; the "trust summary" half is duplicative of established cross-session guidance.
- **LOW — `Session Boundaries` (project) vs. workspace `Working Principles` → Session boundaries.** Identical pointer to the same doc. Harmless (pure pointer), but redundant with the always-loaded workspace line.

## Tier 3 — Contradictions

- None found. Model Selection, commit/push, and autonomy statements are consistent with workspace rules.

## Tier 4 — Staleness

- **MEDIUM — `Model Selection`** references *"Opus 4.7"* (line 64) as the recommended drafting model. The current operating model is Opus 4.8; "4.7" is a dated/pinned version that will drift further each release. Recommendation: state the tier as "Opus" (tier, not point version) consistent with the workspace's tier-not-version posture. Not HIGH (block is medium-sized and the rule still functions).

## Tier 5 — Misplacement

- **MEDIUM — `How It Works` (~190 tokens).** Step-by-step pipeline narrative is workflow methodology. Per workspace `CLAUDE.md Scoping`: *"Workflow methodology … Belongs in the workflow's reference docs."* This belongs in a pipeline README / `pipeline/ref-*.md`, surfaced as a one-line pointer in CLAUDE.md.[scoping]
- **MEDIUM — `Commands` table (~175 tokens).** Command purposes are discoverable from the command files' own descriptions; an always-loaded catalogue is reference material, not per-turn behavior. Move to a pipeline README or rely on `/help`-style discovery; keep at most a pointer.[g13][scoping]
- **LOW — `Input File Handling` move target.** Beyond the redundancy finding, the project-unique nuances (operator-pasted verbatim save; legitimate-copy exception) could live in `ai-resources/docs/file-write-discipline.md` and be pointer-referenced, since they apply to <25% of turns.

## Tier 6 — Clarity

- **LOW — `Output Convention`** "(latest approved version is the one that passed QC)" overlaps with `Versioning`'s "latest version that passes QC is the approved version." Same rule stated twice in adjacent blocks with slightly different wording — minor ambiguity about which is canonical. Consolidate.
- **LOW — `Model Selection`** "Sonnet is acceptable for routine refine/edit cycles" — "routine" is an unspecified threshold (which refine cycles count as routine?). Posture-level guidance so LOW; acceptable as a recommendation but note the soft modal.

## Per-Block Verdict Table

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| Purpose | project | ~55 | Keep | Concise scope anchor; behavior-relevant. | — | priors |
| How It Works | project | ~190 | Move | Workflow methodology; descriptive scaffolding. | pipeline README / `pipeline/ref-*.md` | [g13][scoping] |
| Commands | project | ~175 | Move | Command catalogue inferable from command files. | pipeline README | [g12][scoping] |
| Output Convention | project | ~70 | Trim | Useful path convention; drop QC-version clause (dup of Versioning). | — | priors |
| Reference Documents | project | ~50 | Keep | Pure pointer; low cost, high value. | — | priors |
| Skill References | project | ~60 | Keep | Pure pointer; clarifies skill ownership. | — | priors |
| Versioning | project | ~50 | Keep | Bright-line rule, project-specific. | — | priors |
| Relationship to /new-project | project | ~75 | Trim | Descriptive; compress to one pointer line. | — | [g12] |
| Model Selection | project | ~150 | Trim | Allowed posture block, but de-version "Opus 4.7" → "Opus". | — | priors (staleness) |
| Commit Rules | project | ~210 | Trim | Keep only the symlink `git add` caveat; drop duplicated commit/push prose → pointer. | workspace `Commit behavior` (pointer) | [g14] |
| Input File Handling | project | ~330 | Delete/Move | Verbatim cross-layer duplication; replace with pointer + project-unique nuances in doc. | `ai-resources/docs/file-write-discipline.md` (pointer) | [g14][g13] |
| Compaction | project | ~150 | Trim | Keep project compaction preservation list; drop "trust the summary" dup. | — | priors |
| Session Boundaries | project | ~30 | Keep | Pointer-only; near-zero cost. | — | priors |

## Estimated Savings

Assuming HIGH+MEDIUM applied (Input File Handling → pointer ~280 saved; Commit Rules → pointer keeping symlink caveat ~120 saved; How It Works → pointer ~160 saved; Commands → pointer ~150 saved; minor trims (Compaction/Relationship/Output dup) ~110 saved):

- Per turn: ~620 tokens (from ~1709 → ~1090; further trims could reach the ~500-token guidance target)
- Per 30-turn session: ~18,600 tokens
- Per 50-turn session: ~31,000 tokens
- Breakdown by tier: Tier 1 ~290 (frequency-weighted overlap with Tier 2/5) · Tier 2 ~400 (the two cross-layer dups dominate) · Tier 4 ~0 (de-versioning is correctness, not token) · Tier 5 ~310 (How It Works + Commands) — tiers overlap on the same blocks; net non-double-counted savings ~620.

## External Guidance Cited

- [g12] Including facts Claude already knows — exclude repo-inferable content (guidance line 12).
- [g13] Methodology that belongs in skills/docs — pointers, not verbatim; ~80%-of-sessions test (line 13).
- [g14] Verbatim duplication across CLAUDE.md layers — HIGH, workspace's own rule (line 14).
- [g17] Behavior/workflow rules only; persistent context Claude can't infer from code (line 17).
- [scoping] Workspace `CLAUDE.md` § CLAUDE.md Scoping — workflow methodology belongs in reference docs; no verbatim duplication of canonical workspace rules.
