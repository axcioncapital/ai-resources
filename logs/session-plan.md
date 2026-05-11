# Session Plan — 2026-05-11

## Intent
Apply CLAUDE.md audit findings for three projects (axcion-ai-system-owner, global-macro-analysis, repo-documentation) — each gets /risk-check + edit + /qc-pass per the ready audit specs in `audits/working/`.

## Class
execution

## Model
sonnet — match (active session: `claude-sonnet-4-6[1m]`; "doing" tier — mechanical edits from a clear plan)

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/audit-claude-md-project-axcion-ai-system-owner.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/audit-claude-md-global-macro-analysis-2026-05-11.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/audit-claude-md-repo-documentation-2026-05-11.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/CLAUDE.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/global-macro-analysis/CLAUDE.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/CLAUDE.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md`

## Autonomy Posture
Full autonomy — audit specs are complete and execution-ready; per-project /risk-check and /qc-pass are the structural gates. Token-saving "trim vs. move" decisions where the audit spec lists alternatives: pick the recommended default and proceed; surface the choice inline.

**Stop points:**
- /risk-check returns BLOCK on any project's planned edits
- /qc-pass DISAGREE on editorial choice that requires operator judgment
- Any project fails QC twice in a row (per mandate stop-condition)

## Risk
CLAUDE.md edits are a structural change class (cross-cutting always-loaded content per `audit-discipline.md`). Run `/risk-check` per project at plan-time (before edits) and per project at end-time (before commit) — six gate invocations total, but each is bounded to a single file and a documented audit spec, so cost per gate is low.
