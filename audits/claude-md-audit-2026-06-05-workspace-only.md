# CLAUDE.md Audit — 2026-06-05

**Scope:** Workspace only (cross-file redundancy checked against ai-resources/CLAUDE.md)
**Files audited:**
- Workspace: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — 217 lines, ~2888 tokens, 27 H2
- Reference for Tier 2 redundancy (not audited as target): /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md — 98 lines, ~1390 tokens

**Token-estimation caveat:** Counts are word × 1.3, ±30% drift vs. real tokenizer. Findings within ±15% of a threshold are tagged `(boundary)`.

## Executive Summary

- Total findings: HIGH: 3 / MEDIUM: 7 / LOW: 4
- Projected token savings if all HIGH+MEDIUM applied: ~470 tokens/turn (~14,100 tokens/session at 30 turns; ~23,500 at 50 turns)
- Net verdict: The workspace file is well-structured and pointer-heavy, but it sits at ~2888 tokens vs. the external-guidance target of ~500; the largest gains come from collapsing the git/commit/push prose (duplicated across the workspace's own `### Commit behavior`/`### Push behavior`, `Autonomy Rules` item 2, and ai-resources' `## Commit Rules`/`## Git Rules`) into a single canonical block, plus trimming a handful of long discretionary prose blocks (`Model Tier`, `Contract-Conformance Check`, `Push behavior`) to bullet form.

## Per-File Inventory

### Workspace CLAUDE.md

| # | Block (heading) | ~Tokens | Type | @-refs |
|---|---|---|---|---|
| 1 | What This Workspace Is For | 30 | context | — |
| 2 | Projects | 105 | context | ai-resources/CLAUDE.md |
| 3 | Axcíon's Tool Ecosystem | 85 | context + rule | — |
| 4 | Cross-Model Rules | 50 | rule + ptr | cross-model-rules.md |
| 5 | Skill Library | 80 | rule | — |
| 6 | AI Resource Creation | 75 | rule + ptr | ai-resource-creation.md |
| 7 | Placement Discipline | 215 | rule + ptr | friction-log.md |
| 8 | Design Judgment Principles | 70 | rule + ptr | analytical-output-principles.md |
| 9 | QC Independence Rule | 70 | rule + ptr | qc-independence.md |
| 10 | Contract-Conformance Check | 200 | discretionary + ptr | — |
| 11 | Assumptions Gate | 110 | rule | — |
| 12 | Completion Standard | 90 | rule | — |
| 13 | Working Principles | 200 | rule + ptr | compaction-protocol.md, session-boundaries.md |
| 14 | Chat Communication Style | 165 | rule | — |
| 15 | File Write Discipline | 50 | rule + ptr | file-write-discipline.md |
| 16 | Autonomy Rules | 235 | rule + ptr | audit-discipline.md, autonomy-rules.md |
| 17 | Decision-Point Posture | 165 | rule + ptr | — |
| 18 | QC → Triage Auto-Loop | 40 | ptr | qc-independence.md |
| 19 | Session Guardrails | 175 | rule + ptr | session-guardrails.md |
| 20 | Plan Mode Discipline | 75 | rule + ptr | plan-mode-discipline.md |
| 21 | CLAUDE.md Scoping | 110 | rule | — |
| 22 | Model Tier | 290 | rule + ptr | agent-tier-table.md |
| 23 | Model Escalation | 150 | rule + ptr | autonomy-rules.md |
| 24 | Adaptive Thinking Override | 50 | rule | — |
| 25 | File verification and git commits (H2 + 5 H3) | 360 | rule + ptr | commit-discipline.md |
| 26 | Delivery | 30 | context | — |
| 27 | Agent Harness | 60 | rule + ptr | harness-rules.md |

Total inventoried ≈ 3,635 raw block tokens (block-level word×1.3 sums run higher than the whole-file ~2888 figure due to heading/markdown overhead counted per-block; whole-file figure is authoritative for savings %).

## Tier 1 — Token Cost

- **MEDIUM — `Model Tier`** (~290 tokens, ~10% of file). Largest single block. Long prose argument ("Reason: when a model is set… the operator cannot reliably change…") explaining *why* the rule exists. The rule itself is a bright line and operator-protected (do NOT remove), but the justification prose could compress to a one-clause parenthetical, with the rationale living in a pointer. Applies to <25% of turns (only when settings/frontmatter is touched). Source: external guidance — "Over-specification… important rules lost in noise" + "pointer-to-doc for deep methodology."
- **MEDIUM — `Autonomy Rules`** (~235 tokens). High applicability (autonomy posture is every-turn), so the weight is partly justified, but item 2's push prose duplicates `### Push behavior` (see Tier 2) and items 8/9 are near-identical pointers to the same `audit-discipline.md` doc that could merge. Trim, don't move.
- **MEDIUM — `Contract-Conformance Check`** (~200 tokens, ~7% boundary). Four-bullet trigger list plus a prose preamble about `/qc-pass` scope-bounding. Applies to <25% of turns (only multi-round QC on a complex artifact). Candidate to compress preamble and move trigger detail behind the command file. Source: external guidance — "only include what's needed in ~80% of sessions."
- **MEDIUM — `Placement Discipline`** (~215 tokens). Four-trigger + skip-list + advisory-note prose. Applies to <25% of turns (new-file-in-new-location only). The trigger enumeration could live in the `/placement` command; CLAUDE.md keeps the one-line trigger summary. Source: external guidance — methodology-that-belongs-in-commands.
- **LOW — `File verification and git commits` (H2 umbrella, ~360 tokens across 5 H3)** — the umbrella is the largest by total tokens but each H3 is a distinct high-applicability git rule; flagged here only because `### Push behavior` prose is verbose (see Tier 1 next item) and `### Commit behavior` overlaps Autonomy item 2.
- **LOW — `### Push behavior`** (~140 tokens). Verbose phrasing including a worked y/n example block that is also present verbatim in ai-resources `## Commit Rules`. The example block is the duplicated payload (Tier 2); terse phrasing would serve.

## Tier 2 — Redundancy

- **HIGH — git push/commit duplication spans files.** Workspace `### Commit behavior` + `### Push behavior` restate the same rules as ai-resources `## Commit Rules` + `## Git Rules`. Quoted duplicate clause (verbatim in both files): *"Ready to push N commits across M repos: [list]. Push now? y/n"* and *"No mid-session pushes, even for 'critical' fixes — surface the situation and ask the operator instead."* Note: ai-resources' block self-documents the duplication ("This rule mirrors the canonical… repeated because projects are sometimes opened without the parent workspace context loaded"), which is a deliberate design choice — so the FIX is not deletion but recognizing the workspace file is the canonical home and the ai-resources copy is the intentional mirror. Severity HIGH per tier rule (spans files) and external guidance flags this as the workspace's own top anti-pattern, but the operator-acknowledged rationale tempers the remediation to "trim verbose prose in both, keep the pointer relationship."
- **HIGH — `Autonomy Rules` item 2 restates `### Push behavior` within the same file.** Item 2: *"`git push` is also gated, batched until session end, and confirmed via a single prompt at wrap (see `Push behavior` below)."* This is a forward-reference to a full block 80 lines later that says the same thing in expanded form. Within-file would be MEDIUM, but combined with the cross-file push duplication the push rule now exists in ~3 places; flagging HIGH to consolidate to one canonical push block + bare pointers elsewhere.
- **MEDIUM — `Session Boundaries` appears twice, both as pointers.** Workspace `Working Principles` bullet ("**Session boundaries.** Prefer `/clear`… Full rule: `…/session-boundaries.md`") AND ai-resources `## Session Boundaries` (identical sentence + same pointer). Cross-file, but both are one-line pointers so payload is small. Source: external guidance — verbatim duplication across layers.
- **MEDIUM — Model-default rule duplicated across files (protected content, redundancy noted only).** Workspace `Model Tier` and ai-resources `## Model Selection` both state the no-model-default rule. ai-resources already points to workspace ("See workspace `CLAUDE.md` → Model Tier for the full rule") so the relationship is pointer-correct; the ai-resources copy still restates the full prohibition rather than just pointing. Per operator standing decision the RULE is non-removable; this finding is informational only — the redundancy could shrink to a pure pointer in ai-resources without touching the protected workspace rule.
- **LOW — `Skill Library` vs `AI Resource Creation`** partially overlap (both say "make changes in ai-resources, not project workspaces"). Within-file, minor.

## Tier 3 — Contradictions

- No HIGH contradictions found. Autonomy posture (`Decision-Point Posture`, `Autonomy Rules`, `Assumptions Gate`) is internally consistent: full autonomy with an enumerated pause list, and the Assumptions Gate "proceed with recommendation, stop only on irreconcilable conflict" framing matches Decision-Point Posture's "pick and proceed." Commit ("commit directly") vs. Push ("gated, ask at wrap") are complementary, not contradictory. No scope statements conflict.

## Tier 4 — Staleness

- No staleness found in the workspace file. All `@`-referenced docs and commands (`/placement`, `/contract-check`, `/drift-check`, `/qc-pass`, `/risk-check`, `audit-discipline.md`, etc.) are referenced as live; no dated-incident blocks, no "complete/superseded" phase markers, no corrections-applied log. (Staleness checked only against passed content — no filesystem existence check performed per audit rules.)

## Tier 5 — Misplacement

- **MEDIUM — `Contract-Conformance Check` trigger enumeration** (~200 tokens) reads as command methodology (the four-trigger firing logic). Per workspace `CLAUDE.md Scoping`, deep trigger mechanics belong behind the command; CLAUDE.md should keep the one-line "run `/contract-check` when an artifact has been iterated multiple times" trigger and lazy-load the rest. Move-target: `.claude/commands/contract-check.md`. Source: CLAUDE.md Scoping + external guidance.
- **MEDIUM — `Session Guardrails` flag enumeration** (~175 tokens). The four-flag definitions and threshold values (≥4 subagents, ~20 turns, ≥8 artifacts) are methodology already pointed at `session-guardrails.md` ("Full trigger enumeration… and tuning"). The always-loaded copy could shrink to the flag names + the one blocking rule for `[AMBIGUOUS]`. Move-target: `ai-resources/docs/session-guardrails.md` (already exists). Source: CLAUDE.md Scoping.
- **LOW — `Model Escalation` action steps** (~150 tokens). The "Stop / Spawn an Opus subagent / Apply diagnosis" procedure is operational detail; triggers belong in CLAUDE.md, the action sequence could lazy-load via the existing `autonomy-rules.md` pointer. Move-target: `ai-resources/docs/autonomy-rules.md`.

## Tier 6 — Clarity

- **LOW — `Working Principles` → "Context constraint deferral"** uses "when context is *clearly* constrained" with no bright-line threshold (which % / which turn count). Adjacent `[COST]` guardrail has explicit thresholds; this one does not. Proposed: tie to a named threshold (e.g., "past compaction warning" or a turn count).
- **LOW — `Assumptions Gate`** uses "genuine structural conflict… that cannot be resolved from context" — the boundary between "surface and proceed" and "stop" rests on the word *genuine*, undefined. Low because Decision-Point Posture and Autonomy item 10 jointly constrain it.
- **LOW — `Adaptive Thinking Override`** "For analytical or multi-step projects" vs. "Lightweight projects" — no definition of the analytical/lightweight boundary; relies on operator judgment. Low impact (one env-var toggle).
- **LOW — `Completion Standard`** BLOCKING vs IMPORTANT classification is clear, but "verify output against input requirements" does not name where the requirements live (brief? spec? handoff schema?). Minor.

## Per-Block Verdict Table

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| What This Workspace Is For | ws | 30 | Keep | Minimal orienting context | — | priors |
| Projects | ws | 105 | Keep | Cross-project map, every-session relevance | — | priors |
| Axcíon's Tool Ecosystem | ws | 85 | Keep | Multi-tool assignment rule is load-bearing | — | priors |
| Cross-Model Rules | ws | 50 | Keep | Pointer + one rule, lean | — | priors |
| Skill Library | ws | 80 | Trim | Overlaps AI Resource Creation; merge the "edit in ai-resources" clause | — | priors |
| AI Resource Creation | ws | 75 | Keep | Pointer + bright line | — | priors |
| Placement Discipline | ws | 215 | Trim | Trigger/skip enumeration → command; keep 1-line trigger | .claude/commands/placement.md | guidance |
| Design Judgment Principles | ws | 70 | Keep | Two pointers + conflict-surfacing rule | — | priors |
| QC Independence Rule | ws | 70 | Keep | Pointer + every-turn QC rule | — | priors |
| Contract-Conformance Check | ws | 200 | Move | Trigger mechanics belong behind command | .claude/commands/contract-check.md | guidance + Scoping |
| Assumptions Gate | ws | 110 | Keep | Every-turn gate; clarity LOW only | — | priors |
| Completion Standard | ws | 90 | Keep | Bright-line BLOCKING/IMPORTANT split | — | priors |
| Working Principles | ws | 200 | Trim | Session-boundaries bullet duplicates ai-resources; tighten deferral threshold | — | guidance |
| Chat Communication Style | ws | 165 | Keep | Operator-specific standing rule, every chat turn | — | priors |
| File Write Discipline | ws | 50 | Keep | Pointer + bright line | — | priors |
| Autonomy Rules | ws | 235 | Trim | Item 2 push-prose dup; items 8/9 merge | — | priors |
| Decision-Point Posture | ws | 165 | Keep | Core every-turn posture; operator-reinforced | — | priors |
| QC → Triage Auto-Loop | ws | 40 | Keep | Pure pointer, lean | — | priors |
| Session Guardrails | ws | 175 | Trim | Flag enumeration → existing doc; keep names + [AMBIGUOUS] block rule | ai-resources/docs/session-guardrails.md | Scoping |
| Plan Mode Discipline | ws | 75 | Keep | Pointer + post-plan wait rule | — | priors |
| CLAUDE.md Scoping | ws | 110 | Keep | Governs this audit's own move targets | — | priors |
| Model Tier | ws | 290 | Trim | Operator-protected RULE stays; compress rationale prose to pointer | — | guidance |
| Model Escalation | ws | 150 | Trim | Action steps → autonomy-rules.md; keep triggers | ai-resources/docs/autonomy-rules.md | Scoping |
| Adaptive Thinking Override | ws | 50 | Keep | One env-var rule; clarity LOW only | — | priors |
| File verification and git commits (H2) | ws | (umbrella) | Keep | Container heading | — | priors |
| → Use filesystem not git | ws | 60 | Keep | Bright-line self-verify rule | — | priors |
| → Repo-status reporting | ws | 90 | Keep | Distinct fetch/verify rule | — | priors |
| → Commit behavior | ws | 70 | Trim | Cross-file dup w/ ai-resources Commit Rules; keep canonical here, trim mirror | — | guidance |
| → Push behavior | ws | 140 | Trim | Verbose; y/n example dup'd in ai-resources + Autonomy item 2 | — | guidance |
| → Git edge-case rules | ws | 30 | Keep | Pure pointer | — | priors |
| Delivery | ws | 30 | Keep | Notion source-of-truth rule | — | priors |
| Agent Harness | ws | 60 | Keep | Conditional lazy-load pointer, correct pattern | — | priors |

## Estimated Savings

- **Per turn:** ~470 tokens (HIGH+MEDIUM applied). Breakdown:
  - Tier 2 (git/commit/push consolidation across files + Autonomy item 2): ~140 tokens/turn (workspace-side trim of Push verbosity + Commit overlap + item-2 forward-ref).
  - Tier 1 / Tier 5 prose compression: `Model Tier` rationale ~110; `Contract-Conformance Check` ~90; `Placement Discipline` ~70; `Session Guardrails` ~60.
  - (LOW findings not counted in the savings figure.)
- **Per 30-turn session:** ~14,100 tokens
- **Per 50-turn session:** ~23,500 tokens
- Note: The single highest-leverage structural change is collapsing the push rule to one canonical block; it currently exists in three locations (workspace `### Push behavior`, Autonomy item 2, ai-resources `## Commit Rules`).

## External Guidance Cited

- [G1] CLAUDE.md bloat — per-turn baseline cost, target ~500 tokens/150–200 lines (drives Tier 1 sizing context). — code.claude.com/docs/en/best-practices; buildtolaunch.substack.com
- [G2] Over-specification — "important rules lost in noise" (drives `Model Tier` rationale-prose trim). — agensi.io
- [G3] Methodology belongs in skills/docs, pointer not verbatim (drives Tier 5 moves: Contract-Conformance, Session Guardrails, Model Escalation). — composio.dev
- [G4] Verbatim duplication across CLAUDE.md layers = HIGH, workspace's own rule (drives Tier 2 git/session-boundaries/model findings). — workspace CLAUDE.md Scoping, restated in guidance
- [G5] Model-routing posture as recommendation not hard default — matches and protects the no-model-default rule (informs why Model Tier rule is kept, only rationale trimmed). — code.claude.com/docs/en/best-practices
