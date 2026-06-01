# CLAUDE.md Audit — 2026-06-01

**Scope:** workspace only
**Files audited:**
- Workspace: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — 217 lines, ~2935 tokens
- Project: not in scope

**Token-estimation caveat:** Counts are word × 1.3, ±30% drift vs. real tokenizer. Findings within ±15% of a threshold are tagged `(boundary)`. Per-block token figures below are auditor estimates from the passed content; the file-level ~2935 is from NOTES_PATH.

## Executive Summary

- Total findings: HIGH: 2 / MEDIUM: 9 / LOW: 5
- Projected token savings if all HIGH+MEDIUM applied: ~620 tokens/turn (~18,600 tokens/session at 30 turns; ~31,000 at 50 turns)
- Net verdict: A well-disciplined, mostly thin-pointer file that is right at Anthropic's ~200-line ceiling; the largest wins come from compressing five long-prose blocks (Model Tier, Push behavior, Decision-Point Posture, Contract-Conformance Check, Placement Discipline) to pointer+summary, plus two known cross-file contradictions/redundancies that must be resolved at the project layer (not in this file).

## Per-File Inventory

### Workspace CLAUDE.md

| Block | ~Tokens | Type | @-refs |
|---|---|---|---|
| What This Workspace Is For | ~30 | context | — |
| Projects | ~95 | context | — |
| Axcíon's Tool Ecosystem | ~85 | context | — |
| Cross-Model Rules | ~45 | bright-line + pointer | docs/cross-model-rules.md |
| Skill Library | ~75 | bright-line | — |
| AI Resource Creation | ~70 | bright-line + pointer | docs/ai-resource-creation.md |
| Placement Discipline | ~210 | bright-line + pointer | logs/friction-log.md |
| Design Judgment Principles | ~60 | bright-line + pointer | docs/analytical-output-principles.md |
| QC Independence Rule | ~55 | bright-line + pointer | docs/qc-independence.md |
| Contract-Conformance Check | ~185 | discretionary + pointer | — |
| Assumptions Gate | ~95 | bright-line | — |
| Completion Standard | ~75 | bright-line | — |
| Working Principles | ~190 | mixed + pointer | docs/compaction-protocol.md |
| Chat Communication Style | ~135 | bright-line | — |
| File Write Discipline | ~40 | bright-line + pointer | docs/file-write-discipline.md |
| Autonomy Rules | ~185 | bright-line + pointer | docs/autonomy-rules.md, audit-discipline.md |
| Decision-Point Posture | ~170 | bright-line | — |
| QC → Triage Auto-Loop | ~30 | pointer | docs/qc-independence.md |
| Session Guardrails | ~155 | bright-line + pointer | docs/session-guardrails.md |
| Plan Mode Discipline | ~55 | bright-line + pointer | docs/plan-mode-discipline.md |
| CLAUDE.md Scoping | ~90 | bright-line | reference/stage-instructions.md (mention) |
| Model Tier | ~290 | bright-line + pointer | docs/agent-tier-table.md |
| Model Escalation | ~140 | bright-line + pointer | docs/autonomy-rules.md |
| Adaptive Thinking Override | ~40 | bright-line | — |
| File verification and git commits (4 H3s) | ~330 | bright-line + pointer | docs/commit-discipline.md |
| Delivery | ~30 | context | — |
| Agent Harness | ~55 | bright-line + pointer | .claude/references/harness-rules.md |

## Tier 1 — Token Cost

**[HIGH] Model Tier — ~290 tokens (~10% of file), applies to <10% of turns.** Longest block in the file. Carries a full rationale paragraph ("Reason: when a model is set in settings.json … get contested by the declared default") plus an enforcement paragraph plus a project-level Model Selection carve-out. The bright-line rule ("no `model` field in settings.json; no default-model line in any CLAUDE.md; frontmatter is the only tier mechanism") is ~3 lines; the remaining ~200 tokens are rationale and edge-cases that belong in a `docs/model-tier.md` pointer. The rule fires only on harness/settings work — a small fraction of turns. Verdict: Trim. Guidance: "Move detail out… keep CLAUDE.md as a thin routing layer." [G-move]

**[MEDIUM] Push behavior — ~150 tokens (part of the ~330 git H2), applies to ~1 turn/session (wrap).** Carries the full confirmation-prompt blockquote, the on-`y`/on-`n` branches, and the VS Code carve-out — operational detail that fires once per session at wrap. The standing rule a mid-session turn needs is two lines ("push is gated/batched; never push mid-session; confirm once at wrap"). The branch mechanics belong in `docs/commit-discipline.md` (already referenced) or the `/wrap-session` command. Verdict: Trim. [G-move]

**[MEDIUM] Decision-Point Posture — ~170 tokens (~6%), broadly applicable but verbose.** This rule applies often, so it earns standing residence — but it restates the same idea three times ("pick and proceed", "picking and proceeding IS the recommendation", "surfacing the recommendation back … is the anti-pattern"). Compressible to ~60 tokens without losing the bright line. Verdict: Trim (verbose phrasing where terse serves). Source: priors.

**[MEDIUM] Contract-Conformance Check — ~185 tokens (~6%), applies to <25% of turns (multi-round QC wrap-ups only).** Four trigger bullets plus a rationale paragraph distinguishing it from `/qc-pass`. The triggers are useful but the "feels off but /drift-check returns ALIGNED" prose and the qc-pass-is-scope-bounded explanation could compress; consider folding the trigger list into the referenced doc with a 2-line summary here. Verdict: Trim. [G-move]

**[MEDIUM] Placement Discipline — ~210 tokens (~7%), applies to <25% of turns (new-file-in-new-location only).** Four trigger bullets + skip clause + advisory note + friction-log clause. The standing rule ("before creating a file in a new/uncertain location, run `/placement` and use the recommendation") is two lines; the trigger enumeration and skip conditions are reference-doc material. Verdict: Trim. [G-move]

**[LOW] Working Principles — ~190 tokens, mixed grab-bag.** Five sub-bullets of unrelated rules (versioning, compaction pointer, session boundaries, context-deferral, read-scope floors, between-gate summaries). Each is individually thin, but the "Session boundaries" sub-bullet duplicates content also implied elsewhere; the block reads as a catch-all. Low severity — most bullets are genuinely per-turn. Verdict: Keep (consider splitting the compaction + session-boundary bullets to their referenced docs). Source: priors.

## Tier 2 — Redundancy

Cross-file redundancy cannot be fully adjudicated in workspace-only scope (project content was not passed). Recorded from NOTES_PATH for the operator; confirm at the project-layer audit:

**[HIGH — cross-file, deferred to project audit] Input File Handling / Compaction / Session Boundaries mirrored verbatim in 3 project files.** NOTES_PATH reports all three project CLAUDE.md files carry verbatim-mirrored **Input File Handling**, **Compaction**, and **Session Boundaries** blocks that restate workspace canonical content. Workspace blocks involved: `File Write Discipline` (l.101-103), `Working Principles → Session boundaries` (l.86) + compaction pointer (l.85). Per guidance [G-mirror], mirror-duplication multiplies the same bloat N+1 times. The workspace blocks themselves are thin and correct; the fix is at the project layer (replace verbatim mirror with a thin pointer). No workspace edit indicated. Source: NOTES_PATH + [G-mirror].

**Within-file:** No material within-file duplication found. Minor: `Session Guardrails` `[AMBIGUOUS]` description (l.136) restates `Autonomy Rules` item 6 (l.114) — both say ambiguous-with-load-bearing-interpretation pauses/blocks. Equivalent substance, two locations. Verdict on Session Guardrails block: Keep (the guardrail framing is distinct from the autonomy-gate list), but note the overlap. Severity: LOW.

## Tier 3 — Contradictions

**[HIGH — cross-file, deferred to project audit] Push policy contradiction.** NOTES_PATH reports all three project CLAUDE.md files carry a mirrored **Commit Rules** section ending "After committing, push automatically." The workspace file's `Push behavior` (l.195-205) and `Autonomy Rules` item 2 (l.110) direct the opposite: push is gated/batched, never mid-session, single confirmation at wrap. This is a direct behavioral contradiction (project: auto-push; workspace canonical: gated push). Concrete divergence: in any project session, after a commit, the project file says push now, the workspace says do not push until wrap. The workspace side is internally consistent and reflects the 2026-05-29 inversion (corroborated by MEMORY.md). **No workspace edit needed — the stale side is the project mirror.** Resolution belongs in the project-layer audit. Source: NOTES_PATH.

No within-workspace contradictions found. `Push behavior` (l.195), `Autonomy Rules` item 2 (l.110), and the workspace `Commit behavior` (l.193, commit directly / no push) are mutually consistent.

## Tier 4 — Staleness

No stale artifacts detected within the workspace file. All `@`/path references point to plausibly-live `docs/` targets (cross-model-rules, ai-resource-creation, qc-independence, autonomy-rules, audit-discipline, session-guardrails, plan-mode-discipline, agent-tier-table, compaction-protocol, file-write-discipline, commit-discipline, analytical-output-principles) and `.claude/references/harness-rules.md`. These were not filesystem-verified per contract (no FS checks in audit). No dated-incident blocks, no "complete/superseded" phase markers, no corrections-log content. The push-policy inversion (2026-05-29) is fully baked into the standing rule here — no stale residue on the workspace side.

## Tier 5 — Misplacement

Per the file's own **CLAUDE.md Scoping** section, skill/workflow methodology and detail that applies to <25% of turns should lazy-load via pointer, not always-load. Candidates:

**[MEDIUM] Model Tier rationale + edge-cases → `docs/model-tier.md`.** ~200 tokens of rationale/enforcement detail is reference material; keep a 3-line bright line + pointer. (>300-token block borderline; the *movable portion* is ~200, so MEDIUM.) Source: [G-move] + CLAUDE.md Scoping.

**[MEDIUM] Push behavior mechanics → `docs/commit-discipline.md` (already referenced) or `/wrap-session`.** The confirmation-prompt branches fire once at wrap, not per turn. Source: CLAUDE.md Scoping (<25%-of-turns → lazy-load).

**[LOW] Placement Discipline trigger/skip enumeration → reference doc or `/placement` command body.** The command already exists; the four triggers + skip clause can live in the command's own definition with a 2-line summary here. Source: CLAUDE.md Scoping.

**[LOW] Contract-Conformance Check trigger list → `/contract-check` command body.** Same pattern — the command exists; the standing CLAUDE.md text needs only "when 2+ QC rounds completed or a long iterated artifact nears wrap, run `/contract-check`." Source: CLAUDE.md Scoping.

## Tier 6 — Clarity

**[MEDIUM] Adaptive Thinking Override (l.177-179) — vague applicability scope.** "For analytical or multi-step projects, set … . Lightweight projects leave it default." No bright-line threshold separates "analytical/multi-step" from "lightweight" — the operator/agent must guess. The condition that triggers the env-var change is unspecified. Verdict: Keep with reword. Source: priors.

**[LOW] Assumptions Gate (l.74-76) — modal ambiguity.** "Stop only if the concern is a genuine structural conflict … that cannot be resolved from context" — "genuine" and "cannot be resolved from context" are judgment calls without a bright line. Acceptable for a judgment rule but worth a concrete example. Source: priors.

**[LOW] Completion Standard (l.78-80) — BLOCKING/IMPORTANT boundary.** The two examples help, but the dividing line ("would prevent downstream stages from working") still requires interpretation per artifact. Low. Source: priors.

**[LOW] Working Principles → Context constraint deferral (l.87) — "clearly constrained."** "Extended session, approaching compaction threshold" gives partial scope but no numeric trigger (contrast `[COST]` which has explicit thresholds). Low. Source: priors.

**[LOW] Model Escalation "shallow" trigger (l.171) — "plausible but shallow … repeats your inputs without improving them."** Subjective; hard to self-detect. Low. Source: priors.

## Per-Block Verdict Table

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| What This Workspace Is For | workspace | ~30 | Keep | Minimal orienting context | — | priors |
| Projects | workspace | ~95 | Keep | Layout map; per-turn useful | — | priors |
| Axcíon's Tool Ecosystem | workspace | ~85 | Keep | Multi-tool environment is load-bearing | — | priors |
| Cross-Model Rules | workspace | ~45 | Keep | Thin pointer + bright line | — | priors |
| Skill Library | workspace | ~75 | Keep | Bright-line, no pointer needed | — | priors |
| AI Resource Creation | workspace | ~70 | Keep | Thin pointer pattern | — | priors |
| Placement Discipline | workspace | ~210 | Trim | Triggers/skip → reference; keep 2-line rule | /placement command body | [G-move] |
| Design Judgment Principles | workspace | ~60 | Keep | Bright line + pointer | — | priors |
| QC Independence Rule | workspace | ~55 | Keep | Thin pointer pattern | — | priors |
| Contract-Conformance Check | workspace | ~185 | Trim | Trigger list + rationale → command/doc | /contract-check command body | [G-move] |
| Assumptions Gate | workspace | ~95 | Keep | Reword for example (Tier 6 LOW) | — | priors |
| Completion Standard | workspace | ~75 | Keep | Boundary slightly soft (LOW) | — | priors |
| Working Principles | workspace | ~190 | Trim | Move compaction + session-boundary bullets to their docs | docs/compaction-protocol.md | priors |
| Chat Communication Style | workspace | ~135 | Keep | Per-turn applicable; distinctive | — | priors |
| File Write Discipline | workspace | ~40 | Keep | Thin pointer pattern | — | priors |
| Autonomy Rules | workspace | ~185 | Keep | High-value per-turn gate list; pointer present | — | priors |
| Decision-Point Posture | workspace | ~170 | Trim | Restates same idea 3×; compress to ~60 | — | priors |
| QC → Triage Auto-Loop | workspace | ~30 | Keep | Pure pointer | — | priors |
| Session Guardrails | workspace | ~155 | Keep | Per-turn flags; minor overlap w/ Autonomy item 6 | — | priors |
| Plan Mode Discipline | workspace | ~55 | Keep | Thin pointer + bright line | — | priors |
| CLAUDE.md Scoping | workspace | ~90 | Keep | Governs the audit itself; per-turn relevant | — | priors |
| Model Tier | workspace | ~290 | Trim | Move rationale/edge-cases; keep bright line + pointer | docs/model-tier.md | [G-move] |
| Model Escalation | workspace | ~140 | Keep | Triggers concrete; "shallow" soft (LOW) | — | priors |
| Adaptive Thinking Override | workspace | ~40 | Keep | Reword applicability threshold (Tier 6 MEDIUM) | — | priors |
| File verification and git commits | workspace | ~330 | Trim | Push-behavior mechanics → commit-discipline/wrap-session | docs/commit-discipline.md | [G-move] |
| Delivery | workspace | ~30 | Keep | Minimal, load-bearing | — | priors |
| Agent Harness | workspace | ~55 | Keep | Thin pointer + scope guard | — | priors |

## Estimated Savings

- Per turn: ~620 tokens (Model Tier ~200, git/Push mechanics ~150, Contract-Conformance ~110, Placement ~90, Decision-Point ~110, minus retained summaries/pointers — net ~620)
- Per 30-turn session: ~18,600 tokens
- Per 50-turn session: ~31,000 tokens
- Breakdown by tier: Tier 1 ~620 (the savings driver); Tier 5 overlaps Tier 1 (same blocks, do not double-count); Tier 2/Tier 3 cross-file savings accrue at the project layer, not here (workspace blocks stay); Tier 4 ~0; Tier 6 ~0 (rewords are clarity-neutral on tokens).

## External Guidance Cited

- [G-move] "Move detail out — push long detail to a `docs/` folder referenced via `@docs/...`; keep CLAUDE.md as a thin routing layer." / "Short-file-with-pointers wins." — GUIDANCE_PATH, Identified best practices (Claude Code Docs memory; Bijit Ghosh, Medium 2026).
- [G-mirror] "Mirror-duplication across a workspace file and N project files multiplies the same bloat N+1 times; consolidation to a single canonical block with thin project pointers is the higher-leverage shape." — GUIDANCE_PATH, Notes specific to long-context / Opus models.
- Bloat-tax-per-turn and the ~200-line ceiling (file is at 217 lines / ~2935 tokens) — GUIDANCE_PATH, Identified anti-patterns + best practices.
