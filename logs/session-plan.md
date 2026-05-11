# Session Plan — 2026-05-11

## Intent
Apply Bundle 1 (permission-sweep fixes: 4 CRITICAL + 5 HIGH from `audits/permission-sweep-2026-05-11.md`) and Bundle 2 (settings items 5+6: 5-file risk-checked fix per `audits/risk-checks/2026-05-11-two-part-settings-fix-for-deploy-workflow-permission-sweep.md`, with 4 required mitigations applied first).

## Class
execution

## Model
sonnet — → /model sonnet

Rationale: both bundles are spec-following execution from ready briefs (audit report + risk-check report). Bundle 2's judgment work (deciding mitigations, scope expansion) was done at /risk-check time during W20; what's left is mechanical application.

## Source Material

**Bundle 1 (permission-sweep fixes):**
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/permission-sweep-2026-05-11.md` — primary execution brief (4C + 5H targets)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md` — canonical permission-file shapes (target state)

**Bundle 2 (settings items 5+6):**
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-05-11-two-part-settings-fix-for-deploy-workflow-permission-sweep.md` — primary execution brief (PROCEED-WITH-CAUTION verdict + 4 mitigations)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/deploy-workflow.md` — jq snippet target
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-project.md` — canonical template emitter (already has uncommitted edits from prior session — see Risk)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/permission-sweep.md` — sweep command logic
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md` — shared canonical reference (also Bundle 1)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/permission-sweep-auditor.md` — auditor template-class rule

**Cross-cutting:**
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — structural change class guidance

## Autonomy Posture
Gated

**Stop points:**
- Before committing Bundle 1 (after fixes applied + QC) — verify 4C + 5H all addressed; no fix introduced regression
- Before starting Bundle 2 — confirm the 4 mitigations from the risk-check report are understood and which will be applied first vs. concurrent
- Before committing Bundle 2 (after fixes applied + QC) — verify all 5 files updated coherently; mitigations not bypassed
- If new-project.md (touched by Bundle 2) has uncommitted prior-session changes that conflict with Bundle 2 edits — pause and reconcile

## Risk

**Both bundles touch structural change classes** (permission infrastructure + command edits + agent edits + canonical template). Bundle 2 already has a plan-time `/risk-check` from W20 — end-time `/risk-check` likely skippable per the End-time skip rule (memory: covered + bounded + committed).

**Run `/risk-check` if scope expands beyond the briefs** — e.g., if Bundle 1 reveals additional permission drift not in the 4C+5H list, or if Bundle 2 requires touching files outside the 5 named.

**Working-tree hazard:** prior-session uncommitted state present (M `new-project.md`, M `friction-log.md`, M `session-plan.md`, ?? the W20 risk-check file itself). `new-project.md` is in Bundle 2 scope — uncommitted prior edits will tangle with Bundle 2 commits if not reconciled first. Plan: at Bundle 2 start, read the uncommitted diff on `new-project.md`, decide (a) commit prior-session work as own commit first, (b) include in Bundle 2 commit with explicit note, or (c) stash/revert. Also: the W20 risk-check file should be committed as part of W20 retro before this session's commits start.
