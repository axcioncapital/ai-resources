# CLAUDE.md Audit — 2026-06-01 (ai-resources)

**Scope:** project (ai-resources) audited; workspace read for cross-file comparison only
**Files audited:**
- Subject — Project: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md — 98 lines, ~1491 tokens
- Cross-ref — Workspace: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — 217 lines, ~2935 tokens (NOT audited; used solely for Tier-2/Tier-3 cross-file detection)

**Token-estimation caveat:** Counts are word × 1.3, ±30% drift vs. real tokenizer. Findings within ±15% of a threshold are tagged `(boundary)`. File thresholds: 15% = ~224 tokens; 8% = ~119 tokens.

**Auditor scope note:** Per batch instructions, workspace-internal findings are owned by another auditor and are NOT reported here. Only the ai-resources blocks receive verdicts.

## Executive Summary

- Total findings: HIGH: 3 / MEDIUM: 4 / LOW: 2
- Projected token savings if all HIGH+MEDIUM applied: ~430 tokens/turn (~12,900 tokens/session at 30 turns; ~21,500 at 50 turns)
- Net verdict: The ai-resources file is reasonably lean (~1491 tokens) but carries three cross-file mirror blocks (Commit Rules, Model Selection, Session Boundaries) and one near-duplicate (Git Rules push clause vs. Commit Rules) that together account for the bulk of recoverable tokens; the self-labeled "repeated because projects open without parent context" rationale is weaker for ai-resources than for standalone projects because ai-resources is connected via `--add-dir` and the workspace file is therefore typically loaded.

## Per-File Inventory

### Project CLAUDE.md (ai-resources) — subject

| Block | ~Tokens | Block type | @-refs |
|---|---|---|---|
| What This Repo Contains | ~330 | Reference (directory map) | templates/README.md (inline path) |
| How I Work | ~50 | Discretionary + pointer | — |
| Skill Creation and Improvement | ~40 | Pointer | SKILL.md path |
| Model Selection | ~110 | Bright-line (mirror) | workspace CLAUDE.md, Agent Tier Table |
| Subagent Contracts | ~150 | Bright-line + spec | — |
| Session Telemetry | ~95 | Bright-line | — |
| Maintenance Cadence | ~165 | Bright-line + history | friday-checkup.md, registry |
| Permission Management | ~95 | Reference | docs/permission-template.md |
| General Session Rules | ~40 | Bright-line | — |
| Git Rules | ~90 | Bright-line (partial mirror) | — |
| Commit Rules | ~175 | Bright-line (mirror) | workspace CLAUDE.md |
| Compaction | ~75 | Bright-line | — |
| Session Boundaries | ~45 | Bright-line (mirror) | — |

(Workspace inventory omitted — not in audit scope.)

## Tier 1 — Token Cost

**T1-a — What This Repo Contains — MEDIUM.** ~330 tokens = ~22% of the file, the single largest block, exceeding the 15% threshold. It is a directory map (orientation reference), not a per-turn behavioral rule — applies to <25% of turns (only when creating/placing a file). Per external guidance ("Move detail out … keep CLAUDE.md as a thin routing layer"), a directory inventory of this length is a candidate to compress to a short list or lazy-load. The multi-tool ecosystem clause (line 19) is genuinely load-bearing and should stay; the per-directory descriptions are the trimmable part. Verdict: Trim.

**T1-b — Commit Rules — MEDIUM.** ~175 tokens = ~12% of the file (exceeds 8%). The block self-labels as a verbatim mirror of workspace Commit/Push behavior. Cost recurs every turn. See Tier 2 for the redundancy axis; flagged here for the per-turn weight. Verdict: Trim (to a thin pointer).

**T1-c — Maintenance Cadence — LOW (boundary).** ~165 tokens = ~11%. Contains a dated history clause ("Subsumed `/audit-critical-resources` on 2026-05-29 …") that is change-log narrative rather than standing behavior — see Tier 4. The cadence rules themselves apply weekly, not per-turn. Verdict: Trim.

## Tier 2 — Redundancy

**T2-a — Commit Rules (ai-resources) vs. workspace Commit behavior + Push behavior — HIGH.** The ai-resources block (lines 73–85) self-labels: *"This rule mirrors the canonical `Commit behavior` and `Push behavior` sections in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded."* Substance is equivalent: "Commit directly. Do not ask for permission" (ai-resources line 75) vs. workspace line 193 "Commit directly. Do not ask for permission"; the push-confirmation prompt "Ready to push N commits across M repos: [list]. Push now? y/n" is byte-identical to workspace line 201. Cross-file duplication → HIGH. Mitigating note: the stated rationale (projects opened without parent context) is the operator's deliberate design choice. However, ai-resources is connected via `--add-dir` (per workspace line 9), so the workspace file is normally co-loaded — the rationale that applies to standalone `projects/*` is weaker here. Verdict: Trim to a one-line pointer.

**T2-b — Model Selection (ai-resources) vs. workspace Model Tier — HIGH.** ai-resources lines 29–31 restate the model-defaults prohibition ("Never add a `\"model\"` field to any `.claude/settings.json` …") which is the workspace Model Tier rule (workspace line 160). ai-resources already includes the pointer "See workspace `CLAUDE.md` → Model Tier for the full rule" — so the full restatement before the pointer is the redundant part. Cross-file → HIGH. Verdict: Trim to the pointer + the one project-specific clause (frontmatter is the only permitted tier mechanism).

**T2-c — Session Boundaries (ai-resources) vs. workspace Working Principles → Session boundaries — HIGH.** ai-resources lines 96–98 ("When switching between unrelated tasks in the same terminal, prefer `/clear` over continuing in dirty context. Stale context from a prior task compounds and contaminates the next one.") is a near-verbatim subset of workspace line 86. No project-specific content added. Cross-file duplication with zero delta → HIGH. Verdict: Delete (workspace canonical fully covers it).

**T2-d — Git Rules push clause vs. Commit Rules push clause — MEDIUM (within-file).** ai-resources Git Rules line 70 ("After committing, do NOT push. Pushes are batched until session end and gated by a single operator confirmation prompt (see `## Commit Rules` below)…") restates the same push policy that Commit Rules lines 77–81 spell out in full. Within-file duplication → MEDIUM. Verdict: Trim (Git Rules should keep only the message-format bullets and cross-reference Commit Rules for push).

## Tier 3 — Contradictions

No HIGH contradiction found between ai-resources and workspace. Both files now state gated/batched push with a single wrap-time confirmation (ai-resources lines 77–81; workspace lines 195–205) — consistent. NOTE: the NOTES_PATH cross-file observation about project files directing "push automatically" applies to `projects/*` mirrors, NOT to ai-resources; the ai-resources Commit Rules block is already on the post-2026-05-29 gated policy. No contradiction to report for this subject file.

## Tier 4 — Staleness

**T4-a — Maintenance Cadence change-history clause — MEDIUM.** Line 53: "Subsumed `/audit-critical-resources` on 2026-05-29 (its currency-check folded into the auditor's Brokenness section)." This is a change-log entry describing a past consolidation; the standing behavior ("run `/pipeline-review` weekly") does not need the merge history to function. Per the deletion test (guidance), removing the parenthetical would not cause a specific mistake. Verdict: Trim (drop the dated subsumption narrative; keep the active cadence rule).

**T4-b — Session Telemetry R14/R1–R13 reference — LOW.** Line 45 references "R14 (telemetry)" and "R1–R13 optimizations" without defining them in-file. Not stale per se, but the rule numbering assumes an external token-audit ruleset the reader cannot resolve from this file. Flagged under Tier 6 as well. Verdict: Keep (rule is active) but see T6-a.

## Tier 5 — Misplacement

**T5-a — What This Repo Contains directory map — MEDIUM.** Per workspace "CLAUDE.md Scoping" (lines 149–156): project CLAUDE.md is for "content that applies to *every turn* … and cannot live elsewhere." A directory inventory does not apply every turn and could live in a `docs/repo-layout.md` referenced on demand. Guidance: "keep CLAUDE.md as a thin routing layer." Proposed target: `ai-resources/docs/repo-layout.md` (lazy-loaded) or compress in place. Verdict: Trim/Move. Source: external guidance (thin-routing-layer best practice).

**T5-b — Subagent Contracts — LOW.** ~150 tokens of subagent output-shape spec (summary caps, notes-to-disk contract). This is methodology that mostly applies when authoring/running audit subagents, not every turn. Per CLAUDE.md Scoping it is a borderline candidate for a `docs/subagent-contracts.md` pointer. However it is bright-line and compact, and the cap numbers are load-bearing for any subagent author. Verdict: Keep (marginal; below the >300-token HIGH bar and genuinely cross-cutting for this repo).

## Tier 6 — Clarity

**T6-a — Session Telemetry "R14 / R1–R13" — MEDIUM.** Lines 45 references rule identifiers with no in-file or pointed definition; a reader cannot resolve which optimizations are meant. Ambiguity is real (unresolvable scope reference). Proposed: add a pointer to the token-audit ruleset that defines R1–R14, or drop the identifiers and state the dependency in plain terms. Verdict flagged; rewording deferred to operator.

**T6-b — "substantive session" / "trivial" telemetry threshold — LOW.** Line 47 ("If the session was trivial (single-file edit, one-question read), dismiss …") gives examples but the boundary for "substantive" remains soft. Low impact; examples partially anchor it. Verdict: Keep.

## Per-Block Verdict Table

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| What This Repo Contains | ai-resources | ~330 | Trim/Move | Largest block (~22%); directory map, <25%-of-turns applicability; thin-routing-layer guidance | ai-resources/docs/repo-layout.md (or compress in place) | guidance (thin-routing) |
| How I Work | ai-resources | ~50 | Keep | Compact; project-specific operator profile + valid pointers | — | priors |
| Skill Creation and Improvement | ai-resources | ~40 | Keep | Thin pointer to SKILL.md; correct shape | — | priors |
| Model Selection | ai-resources | ~110 | Trim | Cross-file mirror of workspace Model Tier; pointer already present, restatement redundant | — | guidance (redundancy) |
| Subagent Contracts | ai-resources | ~150 | Keep | Bright-line, repo-cross-cutting, below HIGH misplacement bar | — | priors |
| Session Telemetry | ai-resources | ~95 | Keep | Active rule; clarify R-identifiers (T6-a) | — | priors |
| Maintenance Cadence | ai-resources | ~165 | Trim | Active cadence kept; drop dated subsumption history (T4-a) | — | guidance (deletion test) |
| Permission Management | ai-resources | ~95 | Keep | Reference + pointers; structurally correct routing | — | priors |
| General Session Rules | ai-resources | ~40 | Keep | Compact bright-line rules, per-turn applicable | — | priors |
| Git Rules | ai-resources | ~90 | Trim | Keep message-format bullets; push clause duplicates Commit Rules (T2-d) | — | priors |
| Commit Rules | ai-resources | ~175 | Trim | Cross-file mirror of workspace Commit/Push behavior; reduce to pointer + project delta | — | guidance (redundancy) |
| Compaction | ai-resources | ~75 | Keep | Project-specific preserve-list (inbox brief, pipeline stage); genuine delta over workspace | — | priors |
| Session Boundaries | ai-resources | ~45 | Delete | Zero-delta near-verbatim mirror of workspace (T2-c) | — | guidance (redundancy) |

## Estimated Savings

- Per turn: ~430 tokens (Trim/Delete on Commit Rules ~120, Model Selection ~70, Session Boundaries ~45, What This Repo Contains ~150, Git Rules ~40, Maintenance Cadence ~5)
- Per 30-turn session: ~12,900 tokens
- Per 50-turn session: ~21,500 tokens
- Breakdown by tier: Tier 1 ~190 (What This Repo Contains trim, Maintenance trim); Tier 2 ~235 (Commit Rules, Model Selection, Session Boundaries, Git Rules push clause); Tier 4 ~5 (subsumption narrative). Tiers 3/5/6 overlap with above blocks (no additive double-count).

**Savings caveat:** The three cross-file mirror trims (Commit Rules, Model Selection, Session Boundaries) are only safe if ai-resources is reliably co-loaded with the workspace file. Per workspace line 9 it is connected via `--add-dir`, which supports co-loading — but the operator's stated rationale (line 85) is that projects are "sometimes opened without the parent workspace context." Operator should confirm the co-load assumption before applying T2-a/b/c. If standalone-open is common, downgrade those to Keep.

## External Guidance Cited

- [1] Redundant separate content across files is HIGH-severity bloat; consolidation preferred — guidance § Identified anti-patterns (drives T2-a/b/c).
- [2] "Keep CLAUDE.md as a thin routing layer / move detail to docs" — guidance § Identified best practices (drives T1-a, T5-a).
- [3] The deletion test — guidance § best practices (drives T4-a).
- [4] Mirror-duplication across workspace + N project files multiplies bloat N+1×; single canonical block + thin pointers is higher-leverage — guidance § long-context notes (drives the savings caveat and T2 framing).
- [5] Larger context windows do NOT make per-turn prepend bloat free — guidance § long-context notes (drives Tier-1 emphasis despite the file being short).
