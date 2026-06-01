# CLAUDE.md Audit — 2026-06-01

**Scope:** workspace (reference only) + project (audit subject)
**Files audited:**
- Workspace: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — 217 lines, ~2935 tokens (cross-file reference only; not re-audited)
- Project: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-screening-project/CLAUDE.md — 117 lines, ~1909 tokens (full audit)

**Token-estimation caveat:** Counts are word × 1.3, ±30% drift vs. real tokenizer. Findings within ±15% of a threshold are tagged `(boundary)`.

## Executive Summary

- Total findings: HIGH: 2 / MEDIUM: 4 / LOW: 2
- Projected token savings if all HIGH+MEDIUM applied: ~720 tokens/turn (~21,600 tokens/session at 30 turns; ~36,000 at 50 turns)
- Net verdict: A well-structured project scaffold whose project-specific blocks earn their place, but ~38% of the file is verbatim workspace-mirror content — one block of which (Commit Rules) is now STALE and CONTRADICTS the canonical gated-push policy. The mirror strategy multiplies workspace bloat across N project files; consolidation to thin pointers is the higher-leverage shape.

## Per-File Inventory

### Project CLAUDE.md (subject)

| Block | ~Tokens | Type | @-refs |
|---|---|---|---|
| Purpose | ~190 | Discretionary (project context) | pipeline/project-plan.md |
| Upstream Inputs (canonical) | ~135 | Spec reference | pipeline/context-pack.md, project-plan.md, inputs/README.md |
| Program Shape | ~180 | Spec reference (artifact chain) | ref-project-plan.md |
| Bottom-up Principle | ~110 | Bright-line (do not pre-decide taxonomy) | — |
| Cross-Model Workflow | ~100 | Pointer + bright-line | cross-model-rules.md |
| Confidence and Sourcing | ~140 | Bright-line (sourcing/confidence) | project-plan.md §3 |
| Layer 2 Child Cycles | ~150 | Procedural | — |
| Model Selection | ~290 | Discretionary posture | workspace § Model Tier |
| Adaptive Thinking Override | ~45 | Bright-line | — |
| Input File Handling | ~330 | Mirror (workspace canonical) | workspace CLAUDE.md |
| Commit Rules | ~145 | Mirror (workspace canonical) — STALE | workspace CLAUDE.md |
| Compaction | ~150 | Mirror (workspace canonical) | — |
| Session Boundaries | ~45 | Mirror (workspace canonical) | — |

Mirror blocks total ~715 tokens (~37% of file). Project-specific blocks ~1194 tokens.

## Tier 1 — Token Cost

**MEDIUM — Input File Handling (~330 tokens, ~17% of file).** Largest single block. It is a six-bullet verbatim mirror of the workspace canonical rule (workspace routes detail to `ai-resources/docs/file-write-discipline.md`; this project inlines the full long form). Applies to <50% of turns (only when an input file is touched). The block exceeds the 15%-of-file Tier-1 threshold. Heavy per-turn prepend cost for a rule already canonical upstream. `(boundary)` — 17% is near the 15% line but clears it.

**MEDIUM — Model Selection (~290 tokens, ~15% of file).** Two-paragraph discretionary posture. Paragraph 1 (the prohibition: no `"model"` field, no default declaration) is a verbatim restatement of the workspace § Model Tier rule. Paragraph 2 (the Opus-4.7 recommended posture with per-phase justification) IS legitimately project-specific and permitted by workspace § Model Tier ("may include a Model Selection section that describes the recommended posture"). The prohibition paragraph is the redundant half; the posture paragraph earns its place. `(boundary)`.

**LOW — Program Shape (~180 tokens).** The ASCII artifact-chain diagram is verbose but high-value (it is the project's spine and applies to most turns). Prose around it ("Sequencing is strictly linear...") restates what the diagram already shows. Minor trim opportunity only.

## Tier 2 — Redundancy

**HIGH (cross-file) — Input File Handling.** Project lines 84-94 verbatim-mirror the workspace canonical input-handling rule. Self-labeled at line 94: "This rule mirrors the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded." Note: the workspace file itself routes this rule to `ai-resources/docs/file-write-discipline.md` via a thin pointer ("File Write Discipline... Full write-discipline rules: ...") — so the project inlines an even longer form than the canonical file keeps. External guidance flags mirror-duplication as HIGH cross-file and notes "consolidation to a single canonical block with thin project pointers is the higher-leverage shape" [G-19, G-33].

**HIGH (cross-file) — Compaction.** Project lines 104-113 restate the workspace Compaction protocol pointer plus the auto-memory "trust the compaction summary" rule. Workspace routes to `ai-resources/docs/compaction-protocol.md`; project inlines. Project adds a few project-flavored items (pipeline/stage identifier) but the bulk is canonical mirror. The "trust the summary" paragraph duplicates the user auto-memory entry of the same name.

**MEDIUM (cross-file) — Session Boundaries.** Project lines 115-117 are a near-verbatim duplicate of the workspace "Session boundaries" bullet. No project-specific content. Pure mirror.

**MEDIUM (cross-file) — Commit Rules (redundancy dimension).** Project lines 96-102 mirror workspace Commit behavior. Beyond redundancy, this block is also a contradiction — see Tier 3.

Note on stated rationale: each mirror block justifies itself with "projects are sometimes opened without the parent workspace context loaded." This is a real concern, but the Commit Rules finding below demonstrates the cost: mirrors drift out of sync with the canonical and silently corrupt behavior. Per guidance [G-33], the lower-risk shape is a single thin pointer per block, not a full inline copy.

## Tier 3 — Contradictions

**HIGH — Commit Rules push directive CONTRADICTS workspace canonical push policy. CONFIRMED.**

- Project line 100: "After committing, push automatically. Remind the operator to run `/wrap-session` if the work is complete."
- Workspace § Push behavior: "Push is **gated and batched**, not autonomous. Do NOT run `git push` mid-session after a commit. Commits accumulate locally until the session is ending. Push happens only at session end... ask the operator with a single confirmation prompt before pushing... Never push mid-session, even for 'critical' fixes."

The two rules direct opposite behavior for the same situation (what to do after a commit). The project mirror is the STALE side — workspace policy was inverted to gated/batched on 2026-05-29 (confirmed by user auto-memory: "Push is gated and batched... rule inverted 2026-05-29, replaces prior autonomous-push rule"). The project file (last edited 2026-05-27 per the W0-setup date) predates the inversion. Concrete divergence: in this project's session, Claude reading the project CLAUDE.md would run `git push` immediately after each commit, violating the canonical batched-push gate and bypassing the operator confirmation prompt. The block also self-labels as "mirrors the canonical `Commit behavior` section" — but it now mirrors a superseded version. Verdict: Delete the stale push line; the whole block is a Delete-or-replace-with-pointer candidate.

## Tier 4 — Staleness

**HIGH — Commit Rules (stale + behavior-corrupting).** Covered in Tier 3. The "push automatically" directive references a workflow that was superseded 2026-05-29. Both stale and behavior-corrupting → HIGH.

**MEDIUM — Model Selection model identifier.** Line 75 recommends "Opus 4.7 (`claude-opus-4-7`)". Identifier currency cannot be filesystem-verified from passed content, but the recommended-model pin is the kind of detail that goes stale as model versions advance (the operator selects via `/model` regardless). Flagged for currency review, not removal — the posture rationale (heavy-judgment project) remains valid even if the specific tier label dates. MEDIUM.

**MEDIUM — Upstream Inputs placeholder.** Line 13: "`inputs/nordic-pe-funds-raw.xlsx` — *operator-supplied, placeholder pending.* W0 cannot begin without this file." This is a live W0-gate note, not stale per se, but it is a transient setup-phase status that will be obsolete once W0 begins. Re-check at next phase boundary; remove once the file lands. MEDIUM (transient-status, low urgency).

## Tier 5 — Misplacement

**MEDIUM — Input File Handling, Compaction, Session Boundaries (mirror blocks).** Per workspace § CLAUDE.md Scoping: "Do not put in project CLAUDE.md: ... Canonical workspace rules. Short pointer is acceptable; verbatim duplication is not." All three mirror blocks are verbatim duplications of canonical workspace rules, which Scoping explicitly prohibits. Proposed target: replace each with a one-line pointer to the workspace section (or the underlying `ai-resources/docs/*.md`). These three blocks total ~525 tokens; thin pointers would cost ~30 tokens. The stated "opened without parent context" rationale conflicts with the explicit Scoping rule — Scoping wins, and the Commit Rules drift proves why. MEDIUM (each <300 tokens; Input File Handling at ~330 is the one HIGH-by-size candidate).

**Note (not flagged):** Purpose, Program Shape, Bottom-up Principle, Confidence and Sourcing, Layer 2 Child Cycles, Cross-Model Workflow are all genuinely project-specific cross-session rules that cannot live elsewhere — correctly placed per Scoping.

## Tier 6 — Clarity

**LOW — Model Selection "acceptable for routine ops" (line 77).** "Sonnet 1M is acceptable for routine ops: mechanical W0 dedupe verification, ... large-batch markdown profile QC where the per-record judgment is light." The threshold for "light judgment" vs the Opus default is left to operator discretion ("Set the session model... based on the unit's analytical density") — appropriate for a recommendation-only block, but the boundary is soft. No bright-line. Acceptable given workspace prohibits model defaults; flagged LOW for awareness only.

**LOW — Adaptive Thinking Override.** Line 79-81 is clear and correctly scoped (project is analytical/multi-step → apply override). Minor: it restates the workspace Adaptive Thinking Override rule, but the per-project applicability decision ("this project IS analytical") is legitimately project-specific. Keep. Flagged LOW only as a near-mirror.

## Per-Block Verdict Table

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| Purpose | project | ~190 | Keep | Project-specific scaffold context; passes deletion test | — | priors |
| Upstream Inputs (canonical) | project | ~135 | Keep (re-check placeholder) | Canonical input registry; line-13 placeholder is transient | — | priors |
| Program Shape | project | ~180 | Trim | Diagram high-value; surrounding prose restates it | — | priors |
| Bottom-up Principle | project | ~110 | Keep | Load-bearing bright-line unique to this program | — | priors |
| Cross-Model Workflow | project | ~100 | Keep | Project-specific tool-per-step rule + thin pointer | — | priors |
| Confidence and Sourcing | project | ~140 | Keep | Core project bright-line (sourcing/confidence tiers) | — | priors |
| Layer 2 Child Cycles | project | ~150 | Keep | Project-specific procedural rule (two-layer model) | — | priors |
| Model Selection | project | ~290 | Trim | Para 2 posture is project-specific (keep); para 1 prohibition mirrors workspace § Model Tier (cut) | workspace § Model Tier (for para 1) | G-19 |
| Adaptive Thinking Override | project | ~45 | Keep | Per-project applicability decision is legitimate | — | priors |
| Input File Handling | project | ~330 | Move | Verbatim canonical mirror; Scoping prohibits duplication | pointer → workspace § File Write Discipline / file-write-discipline.md | G-19, G-33 |
| Commit Rules | project | ~145 | Delete | STALE + CONTRADICTS canonical gated-push; replace with pointer | pointer → workspace § Commit/Push behavior | G-19; notes line 15 |
| Compaction | project | ~150 | Move | Verbatim canonical mirror; project-flavor items can fold into pointer | pointer → workspace § Compaction / compaction-protocol.md | G-19, G-33 |
| Session Boundaries | project | ~45 | Move | Pure verbatim canonical mirror | pointer → workspace § Session boundaries | G-19 |

## Estimated Savings

- Per turn: ~720 tokens (Input File Handling trim-to-pointer ~300; Commit Rules delete/pointer ~115; Compaction trim-to-pointer ~120; Session Boundaries trim-to-pointer ~40; Model Selection para-1 cut ~145)
- Per 30-turn session: ~21,600 tokens
- Per 50-turn session: ~36,000 tokens
- Breakdown by tier: Tier 1 ~445 (Input File Handling + Model Selection prohibition para); Tier 2/5 overlap ~160 (Compaction + Session Boundaries pointers); Tier 3/4 ~115 (Commit Rules). Overlapping attributions counted once in the per-turn total.

Caveat: the ~720/turn figure assumes the operator accepts converting mirrors to pointers. If the operator retains the "opened without parent context" mirror strategy, only the Commit Rules HIGH fix (~115 tokens + correctness) is non-negotiable; the rest is leanness-optional.

## External Guidance Cited

- [G-16] Bloat tax per turn — CLAUDE.md prepended every request; HIGH when broad but long. (working notes / guidance synthesis 2026-06-01)
- [G-19] Redundant separate content — duplicated rule-blocks across files waste tokens; HIGH cross-file. (guidance synthesis 2026-06-01)
- [G-27] The deletion test — would removing the rule cause a specific mistake? Applied to mirror blocks. (guidance synthesis 2026-06-01)
- [G-32] Long-context does not make bloat free — per-turn prepend recurs regardless of window. (guidance synthesis, Opus-specific notes)
- [G-33] Mirror-duplication across workspace + N project files multiplies bloat N+1×; thin project pointers are higher-leverage. (guidance synthesis, Opus-specific notes)
- Source: best-practices & memory docs at code.claude.com/docs/en/best-practices, /memory; Bijit Ghosh "Complete Guide to CLAUDE.md" (Medium, May 2026).
