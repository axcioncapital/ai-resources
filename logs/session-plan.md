# Session Plan — 2026-05-16

## Intent
Execute 8 Tier 3 items from `audits/friday-plans/2026-05-16-journal-improvements.md` (5 items) and `audits/friday-plans/2026-05-16-friday-journal.md` (3 items) in 4 sequenced waves; commit each item separately; defer any item that returns RECONSIDER from `/risk-check`.

## Class
execution

## Model
opus — match

(Mixed mechanical + architectural workload. Mechanical portions — friday-act required-reads spec edit, friday-journal command-spec edits, CLAUDE.md wording strengthening — would be Sonnet-tier in isolation. Architectural portions — SessionStart hook chain, `/new-project` pipeline fix, audit-repo vs repo-dd synthesis — are Opus-tier. Heavy items dominate; staying on Opus avoids mid-session tier switches.)

## Source Material
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-plans/2026-05-16-journal-improvements.md — execution spec for items 1–5
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-plans/2026-05-16-friday-journal.md — execution spec for items 1–3
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-journal-2026-05-16.md — upstream journal report (source items 1, 2, 3, 4, 6 referenced by journal-improvements; items 9, 11, 14 referenced by friday-journal)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-journal.md — target for friday-journal #1, #2, #3 (Step 5.5 + new step before Step 6)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-act.md — target for journal-improvements #4 (Step 1.5 + Step 16a)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-project.md — target for journal-improvements #2 (pipeline stages 3a–5)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/audit-repo.md — input for journal-improvements #5 synthesis
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/repo-dd.md — input for journal-improvements #5 synthesis
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md — touched by journal-improvements #1 (SessionStart hook chain)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md — touched by journal-improvements #1 (auto-invoke target)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — target for journal-improvements #3 (§Decision-Point Posture wording)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.json — target for journal-improvements #1 (SessionStart hook wiring)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md — risk-check change-class reference (consulted by friday-journal #3 and by every risk-check pause in this session)

## Autonomy Posture
Gated

**Stop points:**
- After each `/risk-check` verdict (estimated 3 mandatory: journal-improvements #1, #2, #3; possibly +1 batched call if friday-journal #1/#2/#3 cross the shared-state-automation boundary on re-evaluation). RECONSIDER → defer that item, continue rest. PROCEED-WITH-CAUTION → apply listed mitigations before commit.
- Before entering Wave 4 (the two heaviest items — SessionStart hook chain + `/new-project` fix): confirm context budget remains; if <50% headroom, commit Waves 1–3 and defer Wave 4.
- At ~30 turns elapsed without natural break: checkpoint, summarize progress, and wrap to a fresh session.
- If a wave's target file diverges materially from what the plan-file spec assumes (e.g., the Step 5.5 anchor in `friday-journal.md` doesn't exist as described): pause and reassess before editing.

## Risk
Run `/risk-check` after the plan is approved (plan-time gate) on these items: journal-improvements #1 (SessionStart hook + shared-state automation; touches `.claude/settings.json` + two command files), #2 (`/new-project` pipeline edit — affects every future project, shared-state automation), #3 (cross-cutting workspace `CLAUDE.md` edit). Re-evaluate the risk-check boundary for friday-journal #1/#2/#3 at execution time — all three add automation logic to a shared command (subagent invocation, deterministic check, cross-reference step) and may cross the shared-state-automation boundary, even though the literal change-class list says no. If reclassified, run one batched `/risk-check` on the friday-journal trio (single command file, single change unit).

Run `/risk-check` once at end-time (end-time gate), batched across every in-class change made this session, per the two-gate model in `docs/audit-discipline.md`. This fires regardless of individual plan-time verdicts — it is not conditional on PROCEED-WITH-CAUTION.

Items with no structural class: journal-improvements #4 (friday-act.md spec edit — command-spec edit only, no shared-state automation introduced), #5 (analysis artifact only — produces a new recommendation doc, no structural change).
