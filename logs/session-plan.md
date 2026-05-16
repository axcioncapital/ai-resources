# Session Plan — 2026-05-16

## Intent
Execute 6 improvement-log items (prime staleness fix, session-start token, session-plan template, monday-prep C15 semantics, consult Read-first gate, friday-act floor note + workspace CLAUDE.md) to eliminate recurring friction patterns across the session infrastructure.

## Class
execution

## Model
sonnet — match

(All 6 items are executing edits from a defined improvement-log plan — "doing" not "deciding". Active model claude-sonnet-4-6[1m] is sonnet-tier. No design or architectural judgment required; the improvement-log entries specify the changes.)

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` — execution spec for all 6 items
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md` — item #1 target
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md` — item #2 target
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md` — item #3 target
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/monday-prep.md` — item #4 target (+ new `docs/weekly-cadence.md` containing one paragraph: week mandate is week-scope, per-session plan is session-scope, they are written in separate sessions — do not call `/session-plan` from inside `/monday-prep`)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/consult.md` — item #5 target
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-act.md` — item #6 target
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-so.md` — item #6 conditional: scan for a "first N lines" or "30-line peek" read-scope instruction applied to the SO advisory or systems-review doc; if found, add the same floor-not-ceiling note used in friday-act.md; if not found, skip friday-so.md entirely
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` — item #6 CLAUDE.md target (workspace-level, cross-cutting)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — structural change class reference (item #6 class boundary)

## Autonomy Posture
Gated

**Stop points:**
- Before item #6 execution: plan-time `/risk-check` must return GO or PROCEED-WITH-CAUTION before any edits to `CLAUDE.md` or `friday-act.md`. RECONSIDER → defer item #6 entirely (or defer only the CLAUDE.md part); proceed with items 1–5.
- Before committing each item: run `/qc-pass` on that item's edit, then commit. QC is pre-commit, not post-commit.
- Before committing item #6: end-time `/risk-check` batched across all class-crossing changes this session. Item #6 ships as one commit covering all its sub-targets (friday-act.md + friday-so.md if edited + workspace CLAUDE.md) — the end-time gate fires once, after that commit group is staged but before it lands.

## Risk
Run `/risk-check` after the plan is approved (plan-time gate) — item #6 touches workspace `CLAUDE.md` (cross-cutting always-loaded content, in-class). Run it again before committing item #6 (end-time gate). Items 1–5 and the `friday-act.md`/`friday-so.md` parts of item #6 are not in class — no risk-check required for those.

Item #4 creates a new file (`docs/weekly-cadence.md`) — new markdown docs are not a structural change class; no risk-check needed.
