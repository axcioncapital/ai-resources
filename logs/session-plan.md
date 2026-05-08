# Session Plan — 2026-05-08

## Intent
Execute the 7 friday-act plan files generated 2026-05-08 (15 fix-now items across consult, settings, commands, risk-topology, qc-pass, cadence, cleanup-worktree).

## Model
sonnet — → /model sonnet

(Work is dominantly execution-tier — applying defined fixes from plan files. Judgment-heavy substeps are off-loaded to Opus subagents via `/risk-check` gates already declared in each plan.)

## Source Material
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-plans/2026-05-08-consult.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-plans/2026-05-08-settings.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-plans/2026-05-08-commands.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-plans/2026-05-08-risk-topology.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-plans/2026-05-08-qc-pass.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-plans/2026-05-08-cadence.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-plans/2026-05-08-cleanup-worktree.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md

## Autonomy Posture
Gated

**Stop points:**
- Before each plan file's `/risk-check` gate fires (consult, settings, commands, risk-topology, cadence have risk-check declared).
- `{{WORKSPACE_ROOT}}` operator (a)/(b) decision in settings plan item 5 (deferred to execution per 2026-05-08 decision — operator chooses template-source vs. deployed-copy interpretation).
- Coupling check before commit on settings plan: items 5+6 must land together (decision: 2026-05-08).
- Before invoking `/cleanup-worktree` (run last, after all other plans).
- After `/permission-sweep` runs (settings item 1) — confirm no unexpected drift before continuing.

## Risk
Run `/risk-check` per the plan-time gates declared in each plan file (consult: new symlink; settings: bundled permission changes per the plan's bundling note; commands: schema fields; risk-topology: dead-link cleanup; cadence: command wiring + cadence-doc edits). Run end-time `/risk-check` again before commit per `docs/audit-discipline.md`, unless the end-time skip rule applies (plan-time covered with mitigations applied AND commits already shipped AND drift bounded — document the skip in the wrap note).
