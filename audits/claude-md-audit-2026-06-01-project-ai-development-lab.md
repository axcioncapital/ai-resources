# CLAUDE.md Audit — 2026-06-01

**Scope:** project (ai-development-lab) audited; workspace used for cross-file comparison only
**Files audited:**
- Subject — Project: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/CLAUDE.md — 155 lines, ~2065 tokens
- Reference (cross-file only, NOT re-reported): /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — 217 lines, ~2935 tokens

**Token-estimation caveat:** Counts are word × 1.3, ±30% drift vs. real tokenizer. Findings within ±15% of a threshold are tagged `(boundary)`.

**Cross-file reporting boundary:** Per the run contract, workspace-internal findings are owned by another auditor. The workspace file is used here only for Tier-2 redundancy and Tier-3 contradiction detection against the project subject.

## Executive Summary

- Total findings: HIGH: 2 / MEDIUM: 4 / LOW: 2
- **Push contradiction CONFIRMED.** Project `Commit Rules` directs "push automatically"; workspace canonical `Push behavior` (inverted 2026-05-29) directs gated/batched push with single `/wrap-session` confirmation and explicit "Do NOT run `git push` mid-session." The project mirror is the stale side. HIGH Tier-3.
- Projected token savings if all HIGH+MEDIUM applied: ~640 tokens/turn (~19,200 tokens/session at 30 turns; ~32,000 at 50 turns). Dominated by the three mirror blocks (Input File Handling, Compaction, Session Boundaries) which carry ~590 tokens of always-loaded duplication.
- Net verdict: Solid project-specific core (Purpose, Pipeline, Agent scope, Memo discipline, Cross-project coupling). The four "mirror" blocks at the tail (Input File Handling, Commit Rules, Compaction, Session Boundaries) are the liability — one is a hard contradiction, the rest are cross-file bloat the workspace already lazy-loads or owns canonically.

## Per-File Inventory

### Project CLAUDE.md (subject)

| Block | ~Tokens | Block type | @-refs |
|---|---|---|---|
| Purpose | ~150 | Project orientation | none (path mentions) |
| Pipeline | ~290 | Workflow methodology / orientation | none (path/command mentions) |
| How to invoke | ~120 | Command index | none |
| Out of scope | ~55 | Scope boundary (bright-line) | none |
| Reference docs | ~190 | Pointer index | lists `pipeline/ref-*.md` |
| Agent scope boundary | ~210 | Bright-line scope rule | `.claude/agents/ai-engineer.md` mention |
| Memo discipline | ~180 | Bright-line + discretionary | none |
| Cross-project coupling notes | ~150 | Project-specific config rule | settings.json / shared-manifest.json mention |
| Model selection | ~80 | Recommended posture (compliant) | none |
| Input File Handling | ~365 | Mirror of canonical detail | self-labels workspace mirror |
| Commit Rules | ~120 | Mirror of canonical (STALE) | self-labels workspace mirror |
| Compaction | ~150 | Mirror of canonical | self-labels via content overlap |
| Session Boundaries | ~40 | Mirror of canonical (verbatim) | self-labels via content overlap |

## Tier 1 — Token Cost

**[HIGH] Input File Handling — ~365 tokens (~18% of file), applies to a minority of turns.**
This is the single largest block in the file (~18% of ~2065 total, exceeds the 15% bright-line). It is six bullets of detailed write-discipline prose (default-to-Read, do-not-materialize, no-co-locate, outputs-are-different, operator-pasted-save-verbatim, exception-legitimate-copying). The workspace deliberately lazy-loads this exact detail to `ai-resources/docs/file-write-discipline.md` behind a one-line `## File Write Discipline` pointer. Carrying the full prose always-loaded in the project file is precisely the bloat the workspace pattern avoids. Guidance: "Move detail out... keep CLAUDE.md as a thin routing layer" and "Mirror-duplication across a workspace file and N project files multiplies the same bloat N+1 times." Verdict: Trim to a thin pointer (`## File Write Discipline → ai-resources/docs/file-write-discipline.md`, plus the one project-specific guard if any).

**[MEDIUM] Pipeline — ~290 tokens (~14% of file), orientation prose.**
Long descriptive walk-through of the five stages with Step-6a/6b/7/8b internals. Much of this restates what the consuming command (`/analyze-transcript`) and the `ref-*.md` specs own. It applies to every pipeline run, so it is not pure waste, but the stage-internal detail (which agent runs at which step, QC verdict file names) is methodology that the guidance says belongs in reference docs. `(boundary)` on the 15% threshold. Verdict: Trim — keep the one-line "one transcript → one run → one memo, five stages" frame and the stage names; push step-internal mechanics to the existing `pipeline/ref-*.md` it already references.

**[MEDIUM] Reference docs — ~190 tokens, pointer index with embedded commentary.**
The index itself is appropriate (thin routing). But several entries carry inline methodology ("Step 6a hardcodes a verbatim copy; re-verify when consult.md changes") that is maintenance-trigger detail, not per-turn routing. Verdict: Keep the index; Trim the inline re-verify caveats into the referenced docs' own headers.

## Tier 2 — Redundancy

**[HIGH] Compaction — cross-file duplication with workspace `Working Principles` → Compaction pointer AND ai-resources `Compaction` block.**
Project `Compaction` (lines 142–151) restates the compaction-preservation list and the "trust the summary" post-compact rule. The workspace owns compaction canonically via `ai-resources/docs/compaction-protocol.md` (pointer) plus the auto-memory `Trust the compaction summary` prior. The "trust the summary / cost test" paragraph is substantively identical to the canonical behavior. Quoted duplicate clause: *"Do NOT re-derive them via `git log`, `git show`, or repeated Reads... Cost test: if your verification doesn't change the next tool call, skip it."* Verdict: Trim to a project-specific pointer keeping ONLY the project-unique preserve-items (pipeline/stage identifier, pending subagent-output paths, operator gate) and routing the generic protocol to the canonical doc.

**[HIGH] Session Boundaries — verbatim cross-file duplicate.**
Project lines 153–155 are a near-verbatim copy of the workspace `Working Principles` → Session boundaries clause: *"When switching between unrelated tasks in the same terminal, prefer `/clear` over continuing in dirty context. Stale context from a prior task compounds and contaminates the next one."* No project-specific content. This is pure cross-file bloat (~40 tokens). The stated "opened without parent context" rationale does not hold for ai-development-lab, which is a sub-project always under the workspace root. Verdict: Delete (or replace with nothing — it carries zero project-specific signal).

**[MEDIUM] Input File Handling — cross-file redundancy against workspace `File Write Discipline`.**
Counted under Tier 1 for token cost; noted here as redundancy too. The project block reproduces the full detail that the workspace lazy-loads to a doc. Cross-file HIGH-class by guidance, but the workspace side is a pointer (not verbatim), so the duplication is project-block-vs-canonical-doc rather than block-vs-block. Verdict reconciled under Tier 1 (Trim).

## Tier 3 — Contradictions

**[HIGH] Commit Rules "push automatically" CONTRADICTS workspace canonical gated/batched push. CONFIRMED.**
- Project (line 138): *"After committing, push automatically."*
- Workspace `Push behavior`: *"Push is gated and batched, not autonomous. Do NOT run `git push` mid-session after a commit... Push happens only at session end... ask the operator with a single confirmation prompt before pushing."* Inverted 2026-05-29 (confirmed by workspace content and the auto-memory prior `feedback_push_gated`: "rule inverted 2026-05-29, replaces prior autonomous-push rule").
- **Divergent scenario:** Claude completes approved work in an ai-development-lab session and commits. The project file directs an immediate autonomous `git push`; the canonical rule forbids any mid-session push and requires holding commits for a single `/wrap-session` confirmation. A session driven by the project file will push commits the operator intended to batch and review — silently violating the standing policy.
- The project mirror is the stale side (last edited 12 days ago per NOTES; the inversion is 3 days old as of audit). Verdict: Delete the "push automatically" sentence and re-mirror the canonical gated/batched push language (operator-directed rewrite in a follow-up turn — this report does not rewrite).

No other contradictions detected. Project `Model selection` (no default, `/model` per session, recommended-posture only) is fully compliant with workspace `Model Tier`. Agent-tier note (ai-engineer `model: opus` frontmatter) is the permitted mechanism — no conflict.

## Tier 4 — Staleness

**[MEDIUM] Input File Handling self-label references a non-existent workspace section.**
The block closes (line 132): *"This rule mirrors the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`."* The workspace CLAUDE.md has NO section by that name — confirmed via grep (no matches). The workspace uses `## File Write Discipline` with a pointer to `ai-resources/docs/file-write-discipline.md`. The cross-reference is stale/inaccurate; a reader trying to reconcile the mirror against its claimed source will not find it. Verdict: Trim (folds into the Tier-1 Trim-to-pointer fix; correct the reference target to `File Write Discipline` / the doc).

**[MEDIUM] Commit Rules self-label + content predate the 2026-05-29 push inversion.**
Same root as Tier-3. The block is stale relative to canonical. Flagged MEDIUM here for the staleness dimension; the behavioral contradiction is the HIGH in Tier-3. (Not double-counted in severity totals — the HIGH is the governing finding.)

**[LOW] Legacy handoff path note.**
`How to invoke` line 45 carries `/produce-handoff` "(deprecated 2026-05-27)" as a still-listed option with a narrow surviving use-case. This is a deliberate deprecation pointer, not dead content — borderline keep. Verdict: Keep (it documents an intentional fallback and names the condition); revisit if the fallback is ever fully retired.

## Tier 5 — Misplacement

**[MEDIUM] Pipeline stage-internal mechanics belong in reference docs.**
Per workspace `CLAUDE.md Scoping`: "Workflow methodology... Belongs in the workflow's reference docs (e.g., `reference/stage-instructions.md`)." The step-by-step internals in `Pipeline` (which agent at Step 6a/6b/7, the Step 8b QC file `memo-qc.md`, the QS-1/QS-3 fresh-context note) are workflow methodology that should live in `pipeline/ref-*.md` (which already exist and are referenced). Verdict: Move the stage-internal mechanics to the relevant `pipeline/ref-*.md`; keep the orientation skeleton. Source: workspace CLAUDE.md Scoping section.

**[HIGH-adjacent / reported MEDIUM] Input File Handling content belongs in the lazy-loaded doc.**
At ~365 tokens (>300-token Tier-5 HIGH threshold) this would be Tier-5 HIGH on size; it is reported as the Tier-1 HIGH to avoid double-counting. Target location: `ai-resources/docs/file-write-discipline.md` (already the canonical home). Source: workspace CLAUDE.md Scoping + guidance "Move detail out."

## Tier 6 — Clarity

**[LOW] Memo discipline — `Relevancy` fixed-text rule.**
Lines 86–88 hardcode a verbatim fixed-text string. Clear and bright-line; no ambiguity. Noted only because it is fixed v1 text that may date — Keep.

**[LOW] Agent scope boundary — "If their scopes overlap in practice, surface to Patrik."**
Clear escalation rule with a defined trigger (scope overlap) and action (surface, do not arbitrate). No vague modal. Keep. Listed for completeness.

No MEDIUM/HIGH clarity findings — the project-specific blocks are well-scoped and use bright-line phrasing.

## Per-Block Verdict Table

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| Purpose | project | ~150 | Keep | Project-unique orientation; defines lab boundary (no execution) | — | priors |
| Pipeline | project | ~290 | Trim | Keep frame + stage names; push step-internal mechanics to ref docs | `pipeline/ref-*.md` | guidance (move detail out) |
| How to invoke | project | ~120 | Keep | Command index; project-specific | — | priors |
| Out of scope | project | ~55 | Keep | Bright-line scope; high value per token | — | priors |
| Reference docs | project | ~190 | Trim | Keep index; move inline re-verify caveats into the docs' headers | `pipeline/ref-step6a/7-brief.md` | priors |
| Agent scope boundary | project | ~210 | Keep | Bright-line, project-unique, prevents real mistake (deletion test passes) | — | priors |
| Memo discipline | project | ~180 | Keep | Project-unique durable-artifact rules; bright-line | — | priors |
| Cross-project coupling notes | project | ~150 | Keep | Project-specific sync/permission config; cannot live elsewhere | — | priors |
| Model selection | project | ~80 | Keep | Compliant recommended-posture; no default declared | — | workspace Model Tier |
| Input File Handling | project | ~365 | Trim | Largest block; duplicates lazy-loaded canonical detail; stale self-ref | `ai-resources/docs/file-write-discipline.md` | guidance (bloat/move detail) |
| Commit Rules | project | ~120 | Delete (then re-mirror) | "push automatically" contradicts canonical gated push; stale side | canonical Push behavior | priors + auto-memory push-gated |
| Compaction | project | ~150 | Trim | Keep project-unique preserve-items; route generic protocol to canonical doc | `ai-resources/docs/compaction-protocol.md` | guidance (redundancy) |
| Session Boundaries | project | ~40 | Delete | Verbatim cross-file duplicate; zero project-specific signal | — | guidance (redundancy) |

## Estimated Savings

- Per turn: ~640 tokens (Tier-1 Input File Handling trim ~300; Pipeline trim ~150; Compaction trim ~110; Session Boundaries delete ~40; Reference-docs trim ~40)
- Per 30-turn session: ~19,200 tokens
- Per 50-turn session: ~32,000 tokens
- Breakdown by tier:
  - Tier 1 (Input File Handling + Pipeline + Reference docs trims): ~490 tokens/turn
  - Tier 2 (Compaction trim + Session Boundaries delete): ~150 tokens/turn
  - Tier 3 (Commit Rules — net token change minimal; the value is correctness, not savings): ~0 tokens/turn (delete stale line, re-mirror correct line)
  - Tiers 4–6: subsumed in the above (staleness/misplacement fixes are the same edits)

## External Guidance Cited

- [1] "Mirror-duplication across a workspace file and N project files multiplies the same bloat N+1 times; consolidation to a single canonical block with thin project pointers is the higher-leverage shape." — GUIDANCE, Long-context notes. Drives Tier-1 Input File Handling and Tier-2 Compaction/Session Boundaries verdicts.
- [2] "Move detail out — push long detail to a `docs/` folder referenced via `@docs/...`; keep CLAUDE.md as a thin routing layer." — GUIDANCE, best practices. Drives Input File Handling and Pipeline Trim verdicts.
- [3] "Redundant separate content... Severity: HIGH cross-file, MEDIUM within-file." — GUIDANCE, anti-patterns. Drives Tier-2 severity assignment.
- [4] "Bloat tax per turn — CLAUDE.md is prepended to every request... Larger context windows do NOT make bloat free." — GUIDANCE. Drives the per-turn savings framing on an Opus/long-context session.
- Workspace `CLAUDE.md Scoping` section — basis for Tier-5 Move targets (workflow methodology → reference docs).
- Auto-memory `feedback_push_gated` ("rule inverted 2026-05-29, replaces prior autonomous-push rule") — corroborates Tier-3 stale-side determination.
