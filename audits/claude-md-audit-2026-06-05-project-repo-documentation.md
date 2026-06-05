# CLAUDE.md Audit — 2026-06-05

**Scope:** project (repo-documentation) + workspace (redundancy reference only)
**Files audited:**
- Project: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/CLAUDE.md` — 49 lines, ~988 tokens
- Workspace: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` — redundancy reference (not block-audited)

**Token-estimation caveat:** Counts are word × 1.3, ±30% drift vs. a real tokenizer. Findings within ±15% of a threshold are tagged `(boundary)`.

**Standing-decision exclusions (per operator):** model-default prohibition and bypassPermissions are NOT flagged.

## Executive Summary

- Total findings: HIGH: 3 / MEDIUM: 3 / LOW: 2
- Projected token savings if all HIGH+MEDIUM applied: ~430 tokens/turn (~12,900 tokens/session at 30 turns; ~21,500 at 50 turns)
- Net verdict: The file is roughly 988 tokens but carries a ~430-token within-file duplication (two sections governing input-file handling, one of them a 12-line near-canonical restatement) plus a stale self-reference asserting a workspace section name that does not exist; trimming the duplicate and the verbose "Input File Handling" block roughly halves the file.

## Per-File Inventory

### Project CLAUDE.md (repo-documentation)

| Block (H2) | ~Tokens | Block type | @-refs |
|---|---|---|---|
| (preamble line 3) | ~25 | descriptive | none |
| Project Layout | ~250 | spec reference / context | references/*.md (×3), ai-resources docs |
| Model Selection | ~110 | bright-line + posture | workspace CLAUDE.md § Model Tier |
| File Write Discipline | ~95 | bright-line + pointer | workspace § File Write Discipline → file-write-discipline.md |
| Commit Rules | ~12 | pointer | workspace § File verification and git commits |
| Compaction | ~35 | pointer | compaction-protocol.md |
| Session Boundaries | ~25 | pointer | session-boundaries.md |
| Input File Handling | ~430 | bright-line (verbatim-style) | "mirrors workspace § Input File Handling" |

(8 blocks incl. preamble; verdict table below has ≥ 8 rows.)

## Tier 1 — Token Cost

- **HIGH — `Input File Handling`.** ~430 tokens = ~44% of the file's ~988 tokens, far exceeding the 15% Tier-1 threshold, and it governs a narrow situation (operator drops an input file) that applies to well under 25% of turns. It is a 12-line prose expansion of a rule that the file ALSO states tersely four sections earlier (`File Write Discipline`, ~95 tokens, pointer-style). The external guidance flags exactly this: "CLAUDE.md bloat — costs every turn, every session… target behavior-only" and "Methodology that belongs in skills/docs — only include what's needed in ~80% of sessions; the rest goes to… separate docs (pointers, not verbatim)." Verdict driver: guidance §Identified anti-patterns. Source: guidance.
- **MEDIUM — `Project Layout`.** ~250 tokens = ~25% of the file. Most bullets are durable per-turn context (output split, vault gitignore, harness scope) and justify their weight, but the per-phase archival narration ("`output/phase-1/` is an archived baseline", session-guide provenance) is reference detail that could live in `references/phase-2-cadence.md` (already linked). Trim candidate, not delete. Source: priors.

## Tier 2 — Redundancy

- **HIGH — within-file duplication: `File Write Discipline` (line 20) vs. `Input File Handling` (line 38).** Both govern the identical rule. `File Write Discipline`: *"Input files referenced by the operator are read-only — use `Read` by path; never `Write`/`Edit`/`MultiEdit`/`cp`/redirection against them."* `Input File Handling`: *"Input files… are read-only references. Use them by path, do not copy or rewrite them… Never invoke `Write`, `Edit`, `MultiEdit`, or shell file-creation commands… against a file whose content originated outside the current session."* Same substance, stated twice, ~525 combined tokens. Severity HIGH per tier rule (spans… here within-file but the two blocks are large and the file explicitly carries both). Recommend collapsing to one block (keep the terse pointer; relocate the operator-paste/exception nuances to the workspace doc if not already there).
- **MEDIUM — cross-file: `Input File Handling` mirror claim vs. workspace.** The block's closing line asserts it "mirrors the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`." The workspace CLAUDE.md's canonical section is titled **`File Write Discipline`** (which itself points to `ai-resources/docs/file-write-discipline.md`); there is no workspace `Input File Handling` section. So this block verbatim-restates a canonical doc the workspace already pointers to — duplication across layers, which the guidance rates HIGH ("Verbatim duplication across CLAUDE.md layers… Pointer is acceptable; duplication is not"). Rated MEDIUM here only because the mirror target is mislabeled (see Tier 4); the underlying duplication itself is the HIGH in Tier 2 above.

## Tier 3 — Contradictions

- None. The two input-handling blocks are redundant, not contradictory — they agree on the rule. No autonomy/commit/scope conflicts detected.

## Tier 4 — Staleness

- **MEDIUM — `Input File Handling` stale mirror reference.** Closing line claims to mirror a workspace section named "Input File Handling." The workspace section was renamed to "File Write Discipline" — and this project file's OWN line-24 note documents that rename ("previously titled 'Input File Handling'… the canonical workspace section is 'File Write Discipline'"). So the file simultaneously documents the rename AND retains a stale block named/justified by the old title. The `Input File Handling` block is the un-migrated legacy `/new-project` template artifact the line-24 note says is "deferred." Stale + large → leans HIGH, but capped at MEDIUM because it is internally flagged and traceable. Source: priors + project's own line-24 decision note.

## Tier 5 — Misplacement

- **MEDIUM — `Input File Handling` operator-paste + exception sub-bullets.** The "Operator-pasted content — save verbatim" and "Exception: legitimate copying" bullets are detailed methodology (~180 tokens) that belongs in `ai-resources/docs/file-write-discipline.md` (already the canonical pointer target), not always-loaded in a project file. Per workspace § CLAUDE.md Scoping: "Canonical workspace rules. Short pointer is acceptable; verbatim duplication is not." Move target: `ai-resources/docs/file-write-discipline.md`. Source: workspace § CLAUDE.md Scoping + guidance.

## Tier 6 — Clarity

- **LOW — `Project Layout` → "Harness scope" bullet.** "harness governance rules do not apply here. Documentation describes the harness; the harness is governed separately." Durable and correct, but lacks an explicit pointer to WHERE harness rules live (workspace § Agent Harness / `@.claude/references/harness-rules.md`) for the reader who needs the boundary. Minor; add a one-clause pointer. Source: priors.
- **LOW — `Model Selection` posture clause.** "Recommended posture: Sonnet for execution… Opus for analytical commands" is clear and compliant (recommendation, not default). No threshold ambiguity; flagged only as a watch-item that this stays a recommendation. Keep. Source: priors.

## Per-Block Verdict Table

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| (preamble) | project | ~25 | Keep | One-line project identity; cheap, orienting | — | priors |
| Project Layout | project | ~250 | Trim | Core context Keep; archival-narration + session-guide provenance can shed | `references/phase-2-cadence.md` (detail only) | priors |
| Model Selection | project | ~110 | Keep | Compliant recommendation-posture; standing-decision exclusion applies | — | guidance (best-practice match) |
| File Write Discipline | project | ~95 | Keep | Terse pointer-style; this is the version to retain | — | priors |
| Commit Rules | project | ~12 | Keep | Pure pointer; minimal cost | — | priors |
| Compaction | project | ~35 | Keep | Pointer + one durable nuance | — | priors |
| Session Boundaries | project | ~25 | Keep | Pointer; mirrors workspace cleanly | — | priors |
| Input File Handling | project | ~430 | Delete | Duplicates `File Write Discipline`; stale mirror label; verbose methodology belonging in the canonical doc | `ai-resources/docs/file-write-discipline.md` (any non-dup nuance) | guidance + workspace § CLAUDE.md Scoping |

## Estimated Savings

- Per turn: ~430 tokens (Delete `Input File Handling`) + ~60 tokens (Trim `Project Layout`) ≈ **~430–490 tokens/turn** (conservative ~430).
- Per 30-turn session: ~12,900 tokens
- Per 50-turn session: ~21,500 tokens
- Breakdown by tier:
  - Tier 1: ~430 (Input File Handling bloat) + ~60 (Project Layout trim)
  - Tier 2: same ~430 tokens (the duplication IS the bloat — not additive)
  - Tier 4/5: subset of the same ~430 block (not additive)
- Net non-overlapping saving: **~430–490 tokens/turn**, cutting the file from ~988 to ~500–560 tokens — landing near the guidance "under ~500 tokens, behavior-only" target.

## External Guidance Cited

- [G1] CLAUDE.md bloat — costs every turn; target under ~500 tokens / 150–200 lines, behavior-only — guidance §Identified anti-patterns. (drives Tier 1 HIGH)
- [G2] Verbatim duplication across CLAUDE.md layers — pointer acceptable, duplication is not; SEVERITY high — guidance §Identified anti-patterns. (drives Tier 2)
- [G3] Methodology that belongs in skills/docs — pointers, not verbatim — guidance §Identified anti-patterns. (drives Tier 5)
- [G4] Long context does NOT excuse bloat — per-turn baseline tax — guidance §Notes on Opus 4.x. (frames per-turn savings)
