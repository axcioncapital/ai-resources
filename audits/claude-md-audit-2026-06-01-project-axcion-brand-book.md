# CLAUDE.md Audit — 2026-06-01

**Scope:** project (axcion-brand-book) audited; workspace read for cross-file comparison only
**Files audited:**
- Project (subject): /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/CLAUDE.md — 72 lines, ~1393 tokens
- Workspace (reference only): /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — 217 lines, ~2935 tokens (NOT audited for internal findings; used for Tier-2/Tier-3 cross-file checks only)

**Token-estimation caveat:** Counts are word × 1.3, ±30% drift vs. real tokenizer. Findings within ±15% of a threshold are tagged `(boundary)`.

## Executive Summary

- Total findings: HIGH: 2 / MEDIUM: 3 / LOW: 2
- Projected token savings if all HIGH+MEDIUM applied: ~430 tokens/turn (~12,900 tokens/session at 30 turns; ~21,500 at 50 turns). The dominant component is collapsing three verbatim-mirrored canonical blocks (Input File Handling, Commit Rules, Compaction) to thin pointers.
- Net verdict: One confirmed HIGH contradiction (auto-push vs. canonical gated push) plus heavy mirror-duplication of canonical workspace rules — the project file carries ~410 tokens of verbatim canonical content that should be thin pointers per the workspace's own CLAUDE.md Scoping rule.

## Per-File Inventory

### Project CLAUDE.md (subject)

| Block | ~Tokens | Block type | @-refs |
|---|---|---|---|
| (preamble/title line 3) | ~95 | descriptive | no |
| Model Selection | ~135 | spec ref / discretionary | no (cites workspace § Model Tier) |
| Project structure pointers | ~175 | spec ref (pointers) | no (lists `references/*.md`) |
| Current state | ~145 | spec ref (pointers) | no |
| Project-local commands | ~95 | spec ref | no |
| Input File Handling | ~360 | bright-line (mirrored canonical) | no |
| Commit Rules | ~140 | bright-line (mirrored canonical) | no |
| Compaction | ~165 | bright-line (mirrored canonical) | no |
| Session Boundaries | ~45 | bright-line (mirrored canonical) | no |

(Workspace inventory omitted — workspace is reference-only this run.)

## Tier 1 — Token Cost

**Input File Handling — MEDIUM.** File: project. Evidence: ~360 tokens = ~26% of the 1393-token file, the single largest block. It is a 7-bullet bright-line rule that applies to input-handling turns only (well under 50% of typical brand-book turns, which are drafting/QC). Why it costs: it exceeds the 15% Tier-1-HIGH size bar but is a genuine bright-line rule, so the cost driver is duplication (see Tier 2), not prose verbosity — capped at MEDIUM here and resolved via the Tier-2 pointer collapse. Source: priors + guidance "Bloat tax per turn" / "Mirror-duplication across a workspace file and N project files multiplies the same bloat."

**Compaction — MEDIUM (boundary).** File: project. Evidence: ~165 tokens = ~12% of file; applies only at `/compact` events (<25% of turns). Why it costs: standing per-turn prepend for an event-triggered rule that already exists canonically. Boundary-tagged (12% sits near the 8–15% band edge). Source: guidance "Larger context windows do NOT make bloat free."

## Tier 2 — Redundancy

**Input File Handling — HIGH (cross-file).** Project lines 38–49 restate the workspace canonical Input-handling rule. The project block self-labels (line 49): "This rule mirrors the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded." The workspace File Write Discipline block (lines 101–103) is itself a thin pointer to `ai-resources/docs/file-write-discipline.md`, so the project carries ~360 tokens of detail that the workspace deliberately externalized. Duplication spans files → HIGH. Stated rationale ("opened without parent context") is weighed and noted, but the workspace CLAUDE.md Scoping rule (line 156) explicitly says "Canonical workspace rules. Short pointer is acceptable; verbatim duplication is not."

**Commit Rules — HIGH (cross-file).** Project lines 51–57 restate workspace `Commit behavior` (lines 191–193). Self-labeled at line 57. Quoted duplicate clause: "Commit directly. Do not ask for permission… the filesystem is the source of truth for what you just changed." Cross-file → HIGH. (Note: the push half of this block is ALSO a Tier-3 contradiction — see below.)

**Compaction — MEDIUM→HIGH (cross-file).** Project lines 59–68 restate workspace Working Principles compaction pointer (line 85–86) plus the user-memory "trust the compaction summary" rule (line 68). Workspace externalizes this to `ai-resources/docs/compaction-protocol.md`; the project inlines ~165 tokens. Cross-file duplication → HIGH.

**Session Boundaries — HIGH (cross-file).** Project lines 70–72 are a near-verbatim copy of the workspace Working Principles "Session boundaries" bullet (line 86). Quoted: "prefer `/clear` over continuing in dirty context. Stale context from a prior task compounds and contaminates the next one." Cross-file → HIGH (small, ~45 tokens, so low savings, but still redundant).

## Tier 3 — Contradictions

**Commit Rules push directive — HIGH. CONFIRMED.** Rule A (project, line 55): "After committing, push automatically." Rule B (workspace, lines 195–205, `Push behavior`): "Push is **gated and batched**, not autonomous. Do NOT run `git push` mid-session after a commit… Never push mid-session, even for 'critical' fixes." User auto-memory corroborates Rule B ("Push is gated and batched — rule inverted 2026-05-29, replaces prior autonomous-push rule"). Concrete divergence scenario: after a committed module draft in an axcion-brand-book session, the project file directs an immediate autonomous `git push`, while the canonical workspace rule forbids any mid-session push and requires a single batched confirmation at `/wrap-session`. The project mirror is the **stale side** (predates the 2026-05-29 inversion). HIGH (contradictions silently corrupt behavior). Resolving this is subsumed by the Tier-2 Commit Rules pointer collapse (Delete the inline mirror → contradiction disappears).

## Tier 4 — Staleness

**Commit Rules — MEDIUM (overlaps Tier-3 HIGH).** The "push automatically" clause references a superseded policy (inverted 2026-05-29; file last edited 12 days ago per NOTES = ~2026-05-20, predating the inversion). Standalone staleness severity MEDIUM; escalates to HIGH via Tier-3. No other stale references found: `references/*.md` pointers, `pipeline/module-status.md`, `source_map.md`, `SESSION-GUIDE.md`, and `.claude/shared-manifest.json` are all forward-looking Phase-0 buildout pointers (cannot filesystem-verify per contract; no internal contradiction observed).

## Tier 5 — Misplacement

**Model Selection (recommended-posture half) — KEEP, no finding.** Lines 5–9 are explicitly permitted by workspace Model Tier (line 164): project CLAUDE.md "may include a `Model Selection` section that describes the *recommended posture*." The block correctly states "no project default" and declares no `"model"` field. Compliant. (Minor: it names "Opus 4.7" / "Sonnet 1M" — verify these tier labels are current, but not a misplacement.)

**Input File Handling / Commit Rules / Compaction / Session Boundaries — see Tier 2.** Per workspace CLAUDE.md Scoping (lines 149–156), canonical workspace rules belong as short pointers, not verbatim duplication. These four blocks are misplaced-by-duplication; the Tier-2 verdicts (Move to thin pointer / Delete inline body) carry the remediation. Each >300-token case (Input File Handling) would be Tier-5 HIGH on size alone; reported under Tier 2 to avoid double-counting.

## Tier 6 — Clarity

**Model Selection — LOW.** "lean Opus 4.7 for identity drafting… Sonnet 1M is acceptable for routine sync" uses soft modal ("acceptable") without a bright-line threshold for when a turn counts as "on-brand judgment" vs. "routine." Acceptable for a recommended-posture block (recommendations are intentionally soft), so LOW only.

**Project structure pointers vs. Current state — LOW.** Two adjacent pointer blocks (lines 11–27) with overlapping function (both route to project files). Mild ambiguity about which to consult first; no behavioral drift evidence. LOW.

## Per-Block Verdict Table

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| Preamble/title | project | ~95 | Keep | Project purpose; applies every turn | — | priors |
| Model Selection | project | ~135 | Keep | Permitted recommended-posture per workspace line 164; verify tier labels current | — | priors |
| Project structure pointers | project | ~175 | Keep | Thin pointers to `references/*.md`; correct shape | — | guidance "thin routing layer" |
| Current state | project | ~145 | Keep | Project-specific session-orientation; cannot live elsewhere | — | priors |
| Project-local commands | project | ~95 | Keep | Project-specific; not in workspace | — | priors |
| Input File Handling | project | ~360 | Trim→pointer | Cross-file verbatim mirror of canonical; >300 tokens | replace body with pointer to workspace File Write Discipline / `ai-resources/docs/file-write-discipline.md` | guidance "Redundant separate content" |
| Commit Rules | project | ~140 | Delete (inline)→pointer | Cross-file mirror AND stale push clause contradicts canonical | pointer to workspace `Commit behavior`/`Push behavior` | guidance + NOTES |
| Compaction | project | ~165 | Trim→pointer | Cross-file mirror of compaction-protocol + memory rule | pointer to `ai-resources/docs/compaction-protocol.md` | guidance |
| Session Boundaries | project | ~45 | Delete→pointer | Near-verbatim copy of workspace Working Principles bullet | pointer to workspace Working Principles | guidance |

## Estimated Savings

- Per turn: ~430 tokens (Input File Handling ~360 minus ~20 retained pointer; Compaction ~165 minus ~15; Session Boundaries ~45 minus ~10; Commit Rules ~140 minus ~20 — net ~645 gross less ~215 retained pointers ≈ 430)
- Per 30-turn session: ~12,900 tokens
- Per 50-turn session: ~21,500 tokens
- Breakdown by tier: Tier 1 (overlaps Tier 2, not separately additive); Tier 2 redundancy collapse ~430/turn (dominant); Tier 3 fix is structural (removes contradiction, savings counted under Tier 2 Commit Rules); Tiers 4–6 are correctness/clarity, ~0 net tokens.

## External Guidance Cited

- "Bloat tax per turn" / "Mirror-duplication across a workspace file and N project files multiplies the same bloat N+1 times" — GUIDANCE 2026-06-01 (drives Tier-1 + Tier-2 verdicts).
- "Redundant separate content… consolidation is preferred. Severity: HIGH cross-file" — GUIDANCE 2026-06-01 (Tier-2 severity).
- "Move detail out… keep CLAUDE.md as a thin routing layer" / "Short-file-with-pointers wins" — GUIDANCE 2026-06-01 (Move-target rationale).
- "Larger context windows do NOT make bloat free — the per-turn prepend cost recurs every session" — GUIDANCE 2026-06-01 (counters the "opened without parent context" self-justification on Opus/long-context).
- Workspace CLAUDE.md Scoping line 156: "Short pointer is acceptable; verbatim duplication is not" (project file's own governing rule).
