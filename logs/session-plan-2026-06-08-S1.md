# Session Plan — 2026-06-08

## Intent
Apply the W24 always-loaded CLAUDE.md audit fixes — collapse the 3 HIGH cross-file duplications to pointers and compress the MED over-long prose blocks per the 2026-06-08 audit, targeting ~620 tokens/turn saved.

## Model
opus — match (active: claude-opus-4-8[1m]). Justified: collapsing duplicated rules to pointers without losing load-bearing meaning is judgment work, not mechanical find-replace.

## Source Material
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/claude-md-audit-2026-06-08-always-loaded.md (the audit — source of all findings)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md (workspace, always-loaded — canonical commit/push + Model Tier home)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md (2nd always-loaded — holds the duplications to collapse)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md (structural-change discipline for harness-config-derived audit fixes)

## Findings / Items to Address
HIGH (cross-file dups — paid twice/turn; primary cuts):
1. **Commit/push ruleset duplicated** (audit §Tier 2, HIGH) — ai-resources `## Commit Rules` (~190 tok) + `## Git Rules` push clause (~85 tok) near-verbatim restate workspace `File verification and git commits`, including the full push prompt twice. → Collapse ai-resources Commit Rules to a pointer into workspace; keep only the commit-message-format convention in Git Rules; drop the duplicated push prompt + prose. Saving ~200–240 tok/turn.
2. **Model-defaults prohibition duplicated** (audit §Tier 2, HIGH) — ai-resources `## Model Selection` (~120 tok) restates workspace `## Model Tier` bright-line, already ending in a pointer. → Reduce to the pointer line + at most one bright-line sentence. Saving ~90 tok/turn.
3. **Session Boundaries duplicated verbatim** (audit §Tier 2, HIGH) — ai-resources `## Session Boundaries` (~25 tok) is identical to the workspace Working Principles bullet + same docs pointer. → Delete the ai-resources standalone block. Saving ~25 tok/turn.

MED (over-long prose; secondary):
4. **Model Tier rationale** (workspace, audit §Tier 1/5 MED) — the "Reason: …" paragraph (~120–150 tok) is rationale that belongs in docs. → Relocate to a new `ai-resources/docs/` model-policy doc; keep workspace bright-line + pointer.
5. **Working Principles → Structural-fix bullet** (workspace, audit §Tier 1 MED) — ~160-word prose argument inside a terse bullet list. → Compress to ~2 sentences + docs pointer.
6. **What This Repo Contains** (ai-resources, audit §Tier 1 MED) — ~270 tok directory glossary, largely discoverable. → Drop the self-evident directory tree; keep non-obvious flows (inbox→archive; usage-log lives in consuming project).
7. **How I Work / push-triple-statement + "commit directly" triple** (ai-resources, audit §Tier 2 MED) — push/commit clauses restated a third time. → Drop the duplicated clauses from `## How I Work`; fold into the consolidated pointer.

Out of scope: project-level CLAUDE.md audits; `.claude/` git-hygiene Option B (W24 item 2); LOW-tier findings (4 items, optional — apply only if zero-risk and adjacent).

## Execution Sequence
1. **Re-read both CLAUDE.md files in full** to confirm exact current block text before editing (audit line refs are estimates). Verify: both files read, target blocks located.
2. **ai-resources/CLAUDE.md HIGH cuts** — collapse Commit Rules → pointer; trim Git Rules push clause → pointer (keep commit-msg format); reduce Model Selection → pointer + bright-line; delete Session Boundaries block. Verify: 4 blocks collapsed, every dropped rule has a live pointer to its canonical workspace home; no orphaned reference.
3. **ai-resources/CLAUDE.md MED cuts** — trim What This Repo Contains glossary; drop push/commit dup clauses from How I Work. Verify: non-obvious flows retained; no rule lost.
4. **Workspace CLAUDE.md MED cuts** — create `ai-resources/docs/model-policy.md` (or similar) hosting Model Tier rationale; replace workspace Model Tier rationale paragraph with bright-line + pointer; compress Structural-fix bullet + docs pointer. Verify: new doc exists with relocated rationale; workspace bright-line intact + pointer resolves.
5. **/risk-check (plan-time gate)** — run before execution lands, structural class confirmed. On non-GO, pause and revise.
6. **/qc-pass** on the edited files — verify no rule meaning lost, all pointers resolve, token reduction directionally consistent with ~620 target.
7. **Commit** the two CLAUDE.md files + the new docs file (batch commit). Verify via filesystem read, not git.

## Scope Alternatives
- **Min:** 3 HIGH cross-file dups only (~360 tok/turn) — the dominant, lowest-risk cuts (collapse-to-pointer, near-zero meaning risk).
- **Recommended:** 3 HIGH + 4 MED (~620 tok/turn) — the full mandate; MED #4 adds a new docs file (slightly higher touch).
- **Max:** HIGH + MED + the 4 LOW clarity/staleness fixes (GPT-5 label align, Assumptions Gate bright-line, Session Guardrails trim) — only if QC-clean and zero added risk.

## Autonomy Posture
Gated — structural change class (cross-cutting always-loaded CLAUDE.md edits + one new always-loaded-adjacent docs file). Bounded by the audit, but rule-meaning preservation needs checkpoints.

**Stop points:**
- After re-reading both files (Step 1): confirm the audit's block descriptions match actual current text before any edit.
- /risk-check verdict (Step 5): non-GO pauses execution.
- If collapsing any rule to a pointer would drop a load-bearing standalone-entry-point case the audit did not account for (mandate stop-if).

## Risk
Run `/risk-check` after the plan is approved (plan-time gate). Run it again before commit (end-time gate). Structural class: cross-cutting edits to always-loaded CLAUDE.md files + new always-loaded-adjacent docs content — per `docs/audit-discipline.md` (harness-config-derived audit fixes).
