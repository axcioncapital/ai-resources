# CLAUDE.md Audit — 2026-06-08 (always-loaded layer)

**Scope:** Two always-loaded CLAUDE.md files (workspace + ai-resources). The second file is **not** a project CLAUDE.md — it is `ai-resources/CLAUDE.md`, also always-loaded via `--add-dir`. Both load into every session, every turn. Cross-file redundancy between them therefore carries **full per-session weight** (a duplicated rule is paid twice every turn) and is the priority-tier-2 focus.

**Files audited:**
- Workspace: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — 218 lines, ~3,095 tokens
- ai-resources (2nd always-loaded): /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md — 98 lines, ~1,466 tokens
- Combined always-loaded baseline: ~4,561 tokens/turn

**Token-estimation caveat:** Counts are word × 1.3, ±30% drift vs. real tokenizer. Findings within ±15% of a threshold are tagged `(boundary)`.

## Executive Summary

- Total findings: **HIGH: 4 / MEDIUM: 7 / LOW: 4**
- Projected token savings if all HIGH+MEDIUM applied: **~620 tokens/turn** (~18,600 tokens/session at 30 turns; ~31,000 at 50 turns)
- Net verdict: Both files already follow the "thin-pointer index" best practice well, but the two always-loaded layers **duplicate the entire git commit/push ruleset, the model-defaults prohibition, and the session-boundaries rule** — these cross-file duplications are the dominant, highest-value cuts because each is paid twice every turn. The workspace file additionally carries three over-long prose blocks (Model Tier, Structural-fix principle, Push behavior) that exceed the thin-pointer norm.

## Per-File Inventory

### Workspace CLAUDE.md

| Block | ~Tokens | Type | @-refs |
|---|---|---|---|
| What This Workspace Is For | ~25 | descriptive | — |
| Projects | ~75 | descriptive | — |
| Axcíon's Tool Ecosystem | ~80 | descriptive | — |
| Cross-Model Rules | ~45 | rule + ptr | docs ptr |
| Skill Library | ~70 | bright-line | — |
| AI Resource Creation | ~60 | rule + ptr | docs ptr |
| Placement Discipline | ~200 | rule | docs ptr |
| Design Judgment Principles | ~55 | rule + ptr | docs ptr |
| QC Independence Rule | ~55 | rule + ptr | docs ptr |
| Contract-Conformance Check | ~175 | rule | — |
| Assumptions Gate | ~95 | rule | — |
| Completion Standard | ~80 | rule | — |
| Working Principles | ~330 | rule + ptr | docs ptrs |
| Chat Communication Style | ~140 | rule | — |
| File Write Discipline | ~35 | rule + ptr | docs ptr |
| Autonomy Rules | ~225 | bright-line + ptr | docs ptrs |
| Decision-Point Posture | ~140 | rule | — |
| QC → Triage Auto-Loop | ~30 | ptr | docs ptr |
| Session Guardrails | ~165 | rule + ptr | docs ptr |
| Plan Mode Discipline | ~50 | rule + ptr | docs ptr |
| CLAUDE.md Scoping | ~90 | rule | — |
| Model Tier | ~290 | bright-line | docs ptr |
| Model Escalation | ~135 | rule + ptr | docs ptr |
| Adaptive Thinking Override | ~40 | rule | — |
| File verification and git commits (H2 + 5×H3) | ~360 | bright-line | docs ptr |
| Delivery | ~30 | descriptive | — |
| Agent Harness | ~55 | rule | @-ref |

### ai-resources CLAUDE.md

| Block | ~Tokens | Type | @-refs |
|---|---|---|---|
| What This Repo Contains | ~270 | descriptive | — |
| How I Work | ~50 | rule (dup) | — |
| Skill Creation and Improvement | ~45 | ptr | — |
| Model Selection | ~120 | bright-line (dup) | — |
| Subagent Contracts | ~165 | rule | — |
| Session Telemetry | ~95 | rule | — |
| Maintenance Cadence | ~145 | rule | — |
| Permission Management | ~110 | rule + ptr | docs ptr |
| General Session Rules | ~45 | rule | — |
| Git Rules | ~85 | rule (dup) | — |
| Commit Rules | ~190 | bright-line (dup) | — |
| Compaction | ~70 | rule | — |
| Session Boundaries | ~25 | rule (dup) | docs ptr |

## Tier 1 — Token Cost

**[MEDIUM] Model Tier — workspace — ~290 tokens (9.4% of file).** Long explanatory prose ("Reason: when a model is set in settings.json or asserted as default…the operator cannot reliably change the model…") restates rationale that belongs in a `docs/` pointer. The behavior rule compresses to the bright-line ("no `model` field in any settings.json; no default-model line in any CLAUDE.md; per-frontmatter tiering is the only mechanism") plus a docs pointer for rationale. Applies to <25% of turns (only when editing settings/frontmatter). Source: guidance "Detail that belongs in docs/" + "deletion test".

**[MEDIUM] Working Principles → Structural-fix bullet — workspace — ~210 tokens within a ~330-token block.** The single "Structural fix as default style; ROI decides scope" bullet is a long prose argument (multiple explanatory sentences) inside an otherwise terse bullet list. It restates one rule ("default to structural fixes; park low-ROI items; a patch is a logged exception") across ~160 words. Candidate to compress to 2 sentences + a docs pointer. Source: guidance "general guidance over trigger-action" + "move detail to referenced docs".

**[MEDIUM] What This Repo Contains — ai-resources — ~270 tokens (18.4% of file).** Largest block in the ai-resources file; a directory-by-directory inventory (`prompts/`, `reports/`, `logs/`, `audits/`, …). This is "facts Claude can infer from code after one session" (guidance HIGH anti-pattern) — the directory tree is discoverable. Applies to <25% of turns. Trim to the load-bearing non-obvious facts (inbox→archive flow; usage-log lives in consuming project, not here) and drop the self-evident directory glossary. Tagged MEDIUM not HIGH because some entries encode non-discoverable conventions. Source: guidance "facts Claude can infer from code".

**[MEDIUM] Contract-Conformance Check — workspace — ~175 tokens (5.7%), <25% of turns.** Four-bullet trigger list plus prose. Applies only late in multi-round QC sessions. The triggers could compress or move to the `/contract-check` command file (the command already exists). Source: guidance "move detail to referenced docs".

**[LOW] Session Guardrails — workspace — ~165 tokens.** Each flag's definition is partly re-explained though the flags are also defined by their bracket tags elsewhere. Mild compression candidate; already ends in a docs pointer. Source: priors.

## Tier 2 — Cross-File Redundancy (priority focus — paid twice/turn)

**[HIGH] Git commit + push ruleset duplicated across both always-loaded files.**
- Workspace `### Commit behavior` + `### Push behavior` (within "File verification and git commits", ~250 tokens of the two sub-blocks) vs. ai-resources `## Commit Rules` (~190 tokens) + `## Git Rules` (~85 tokens).
- The duplication is near-verbatim and includes the full push-confirmation prompt in **both** files: workspace — *"Ready to push N commits across M repos: [list of repos]. Push now? y/n"*; ai-resources — *"Ready to push N commits across M repos: [list]. Push now? y/n"*.
- ai-resources self-documents the duplication: *"This rule mirrors the canonical `Commit behavior` and `Push behavior` sections in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded."* That rationale is **invalid for this scope** — ai-resources/CLAUDE.md is always-loaded *alongside* the workspace file in this workspace (via `--add-dir`), so the parent context is never absent here. The full restatement is paid twice every turn.
- Recommendation: collapse ai-resources Commit Rules to a one-line pointer ("Commit/push behavior: see workspace CLAUDE.md → File verification and git commits") OR, if the "opened standalone" case is real for *other* entry points, keep a 2-line bright-line summary and drop the verbatim prompt + prose. Either way the verbatim prompt should not appear twice.
- Estimated saving: ~200–240 tokens/turn. Source: guidance "Consolidate, don't duplicate" (highest-value cross-layer redundancy).

**[HIGH] Model-defaults prohibition duplicated.**
- Workspace `## Model Tier` (~290 tokens) vs. ai-resources `## Model Selection` (~120 tokens). Same core rule: no `"model"` field in any settings.json; no default-model line in any CLAUDE.md; frontmatter tiering is the only mechanism.
- ai-resources already ends with *"See workspace `CLAUDE.md` → Model Tier for the full rule"* — confirming it is a deliberate restatement, not an independent rule. The first ~3 sentences before that pointer duplicate the workspace bright-line.
- Recommendation: reduce ai-resources Model Selection to the pointer line plus, at most, the one-line bright-line. Drop the restated prohibition prose.
- Estimated saving: ~90 tokens/turn. Source: guidance "Restating model defaults" + "Consolidate, don't duplicate".

**[HIGH] Session Boundaries duplicated verbatim.**
- Workspace "Working Principles → Session boundaries" bullet (*"Prefer `/clear` over dirty context when switching tasks. Full rule: `ai-resources/docs/session-boundaries.md`."*) vs. ai-resources `## Session Boundaries` (identical sentence + identical pointer).
- Both point to the same `docs/session-boundaries.md`. One copy is pure waste in the always-loaded baseline.
- Recommendation: delete the ai-resources standalone Session Boundaries block (it adds nothing the workspace bullet does not).
- Estimated saving: ~25 tokens/turn. Source: guidance "Consolidate, don't duplicate".

**[MEDIUM] Push-gated rule triple-stated.**
- ai-resources `## How I Work` (*"Pushes are gated — batched until session end, with a single operator confirmation prompt before pushing"*) restates the push rule a third time (after workspace Push behavior and ai-resources Commit Rules). Within-file-plus-cross-file overlap.
- Recommendation: drop the push clause from "How I Work"; it is fully covered by the consolidated commit/push rule.
- Estimated saving: ~20 tokens/turn. Source: guidance "Consolidate, don't duplicate".

**[MEDIUM] "Commit directly" rule stated in three places.** Workspace `### Commit behavior`, ai-resources `## Commit Rules`, and ai-resources `## How I Work` (*"Commits proceed directly per `## Commit Rules` below"*) all assert commit-without-asking. Folds into the Tier-2 commit consolidation above; flagged separately so the count is visible. Source: priors.

## Tier 3 — Contradictions

No hard contradictions found. The two files are consistent on autonomy, commit, push, and model posture (they duplicate rather than conflict). One near-miss worth noting (not a contradiction): workspace "General Session Rules" does not exist in workspace, but ai-resources "Pull the latest from GitHub at the start of each session" is a session-start rule with no workspace counterpart — consistent, not conflicting.

## Tier 4 — Staleness

**[LOW] ai-resources "What This Repo Contains" — GPT-5 reference.** The block names "GPT-5 (via API/CustomGPT)" while the workspace file names the tool "Research Execution GPT (CustomGPT)". Not stale per se, but the model-version label ("GPT-5") is the kind of detail that ages; the abstract role label used in the workspace file is more durable. Verify-and-align rather than delete. Source: priors.

No other staleness: no dated-incident blocks, no "complete/superseded" phase markers, no corrections-log blocks in either always-loaded file.

## Tier 5 — Misplacement

**[MEDIUM] Model Tier rationale (workspace) → `docs/`.** The "Reason: …" explanatory paragraph is methodology/rationale, which per the workspace's own "CLAUDE.md Scoping" and the guidance ("move detail to referenced docs") should live in a referenced doc, leaving an always-loaded bright-line + pointer. Target: `ai-resources/docs/` (a model-policy doc) referenced via pointer. >300-token-block-adjacent but the misplaced portion alone is ~150 tokens → MEDIUM. Source: guidance "Detail that belongs in docs/".

**[MEDIUM] ai-resources Commit Rules prose → consolidate, do not relocate.** The duplicated prose does not belong in a second always-loaded file at all (see Tier 2). Proposed target: a single pointer to the workspace canonical block. Source: guidance "Consolidate, don't duplicate".

**[LOW] Contract-Conformance Check trigger list (workspace) → `/contract-check` command file.** The four-trigger enumeration is command mechanics; the command already exists. A thinner always-loaded pointer would suffice. Source: guidance "move detail to referenced docs".

## Tier 6 — Clarity

**[MEDIUM] Assumptions Gate — "genuine structural conflict … that cannot be resolved from context."** The stop-condition leans on "genuine" and "cannot be resolved" without a bright-line — the same soft boundary that decision-point/autonomy rules elsewhere try to make crisp. Drift risk: when does a concern become "genuine structural"? Consider an enumerated short list (as the Autonomy Rules block does). Source: priors.

**[LOW] Working Principles — "Context constraint deferral" → "when context is clearly constrained."** "Clearly constrained" is a vague threshold; the parenthetical ("extended session, approaching compaction threshold") helps but is illustrative, not a bright line. Source: priors.

**[LOW] Session Telemetry — "If the session was trivial (single-file edit, one-question read)…"** Reasonable examples but "trivial" remains operator-judgment; acceptable as-is given the examples. Source: priors.

## Per-Block Verdict Table

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| What This Workspace Is For | WS | 25 | Keep | Minimal orienting context | — | priors |
| Projects | WS | 75 | Keep | Non-obvious layer map | — | priors |
| Axcíon's Tool Ecosystem | WS | 80 | Keep | Multi-tool roles, non-discoverable | — | priors |
| Cross-Model Rules | WS | 45 | Keep | Thin pointer, behavior rule | — | priors |
| Skill Library | WS | 70 | Keep | Bright-line ownership rule | — | priors |
| AI Resource Creation | WS | 60 | Keep | Thin pointer + rule | — | priors |
| Placement Discipline | WS | 200 | Trim | Trigger list could tighten; mostly load-bearing | — | guidance¹ |
| Design Judgment Principles | WS | 55 | Keep | Thin pointer + rule | — | priors |
| QC Independence Rule | WS | 55 | Keep | Thin pointer + rule | — | priors |
| Contract-Conformance Check | WS | 175 | Trim | <25%-turn trigger list → command file | `/contract-check` cmd | guidance² |
| Assumptions Gate | WS | 95 | Trim | Soft stop-condition; tighten threshold | — | priors |
| Completion Standard | WS | 80 | Keep | Bright-line BLOCKING/IMPORTANT | — | priors |
| Working Principles | WS | 330 | Trim | Structural-fix bullet over-long → compress + docs ptr | `ai-resources/docs/` | guidance¹ |
| Chat Communication Style | WS | 140 | Keep | Non-discoverable operator preference | — | priors |
| File Write Discipline | WS | 35 | Keep | Thin pointer + rule | — | priors |
| Autonomy Rules | WS | 225 | Keep | Bright-line enumerated gates; high-value | — | guidance³ |
| Decision-Point Posture | WS | 140 | Keep | Core behavior rule, frequently applies | — | priors |
| QC → Triage Auto-Loop | WS | 30 | Keep | Thin pointer | — | priors |
| Session Guardrails | WS | 165 | Keep | Behavior flags; mild trim possible | — | priors |
| Plan Mode Discipline | WS | 50 | Keep | Thin pointer + rule | — | priors |
| CLAUDE.md Scoping | WS | 90 | Keep | Governs this very audit class | — | priors |
| Model Tier | WS | 290 | Trim | Rationale prose → docs; keep bright-line | `ai-resources/docs/` | guidance¹² |
| Model Escalation | WS | 135 | Keep | Trigger-action rule + pointer | — | priors |
| Adaptive Thinking Override | WS | 40 | Keep | Bright-line env-var rule | — | priors |
| File verification and git commits | WS | 360 | Trim | Canonical commit/push home; trim Push prose, keep as source of truth | — | guidance⁴ |
| Delivery | WS | 30 | Keep | Non-obvious Notion-vs-local rule | — | priors |
| Agent Harness | WS | 55 | Keep | Conditional @-ref load rule | — | priors |
| What This Repo Contains | AR | 270 | Trim | Drop discoverable directory glossary; keep non-obvious flows | — | guidance⁵ |
| How I Work | AR | 50 | Trim | Drop duplicated push/commit clauses | — | guidance⁴ |
| Skill Creation and Improvement | AR | 45 | Keep | Thin pointer to SKILL.md | — | priors |
| Model Selection | AR | 120 | Delete | Duplicates workspace Model Tier; reduce to pointer line | WS → Model Tier | guidance⁴ |
| Subagent Contracts | AR | 165 | Keep | Concrete cap rule, no workspace dup | — | priors |
| Session Telemetry | AR | 95 | Keep | Repo-specific telemetry rule | — | priors |
| Maintenance Cadence | AR | 145 | Keep | Repo-specific cadence rules | — | priors |
| Permission Management | AR | 110 | Keep | Repo-specific, pointer-backed | — | priors |
| General Session Rules | AR | 45 | Keep | Repo session rules; no dup | — | priors |
| Git Rules | AR | 85 | Trim | Commit-msg format keep; push clause dup → pointer | WS → File verification | guidance⁴ |
| Commit Rules | AR | 190 | Delete | Verbatim dup of WS commit/push; reduce to pointer | WS → File verification | guidance⁴ |
| Compaction | AR | 70 | Keep | Repo-specific compaction priorities | — | priors |
| Session Boundaries | AR | 25 | Delete | Verbatim dup of WS Working Principles bullet | WS → Working Principles | guidance⁴ |

## Estimated Savings

- Per turn: **~620 tokens** (HIGH+MEDIUM applied)
- Per 30-turn session: **~18,600 tokens**
- Per 50-turn session: **~31,000 tokens**
- Breakdown by tier:
  - Tier 2 (cross-file redundancy) — ~360 tokens/turn (commit/push consolidation ~220; Model Selection ~90; Session Boundaries ~25; push/commit triple-statement ~25). **Dominant.**
  - Tier 1 (token cost) — ~190 tokens/turn (Model Tier rationale ~120; What This Repo Contains glossary ~50; Contract-Conformance/Working Principles compression ~20 net after Tier-2/5 overlap removed).
  - Tier 5 (misplacement) — overlaps Tier 1/2; ~70 tokens/turn net-new (Model Tier rationale relocation portion not already counted).
  - Tier 4/6 — negligible token impact; clarity/accuracy fixes.
- Note: Tier 1, 2 and 5 figures overlap on the Model Tier / Model Selection and commit blocks; the ~620 headline already de-duplicates the overlap rather than summing the per-tier lines.

## External Guidance Cited

1. Anthropic — Best practices / buildtolaunch Token Optimization — "move detail to referenced docs"; general-guidance-over-trigger-action; deletion test. (guidance §Identified best practices, §anti-patterns)
2. Anthropic — memory docs / Bijit Ghosh guide — "Detail that belongs in docs/"; restating model defaults. (guidance §anti-patterns)
3. Anthropic — Best practices — trigger-action format favored; enumerated bright-line gates are exemplary. (guidance §best practices)
4. **Consolidate, don't duplicate** — cross-file redundancy between always-loaded layers is the highest-value redundancy; duplicated rules pay double. (guidance §best practices line 23; §long-context per-turn multiplier line 26) — primary driver of all Tier-2 HIGH findings.
5. Jamie Lord — "Facts Claude can infer from code are pure waste." (guidance §anti-patterns line 13)
