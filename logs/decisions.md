# Decision Journal

> Archive: [decisions-archive-2026-05.md](decisions-archive-2026-05.md)

## 2026-05-29 — Friday-act session-qc-pipeline: 1 APPLIED, 3 SCHEDULE-DEDICATED

**Scope.** Plan session-qc-pipeline had 4 items, 2 [high]. 3 of 4 require /risk-check (shared-state automation OR workspace CLAUDE.md cross-cutting). Substantial structural work; dedicated sessions preferred over multi-task burst.

### Item 1 — Complete TOCTOU mitigation Phases 2-4
SCHEDULE-DEDICATED [high]. Phase 1 (write-only) shipped 2026-05-28 (commit ea93d62). Remaining: `/session-start` + `/session-plan` consume `.session-marker`; downstream consumers `/wrap-session` + `/handoff`; legacy-fallback cleanup. 4 commands to patch with cross-coordinated read protocol. /risk-check required (shared-state automation). Dedicated session within 2 weeks. Phase 1 already mitigates the worst silent-leak path; remaining phases are formalization.

### Item 2 — Auto-apply /qc-pass fixes (REVISE + wording-level + no DISAGREE)
SCHEDULE-DEDICATED [high]. Requires: (a) define "wording-level/mechanical" finding class explicitly, (b) update `/resolve` or the QC → Triage Auto-Loop to skip the prompt and log the auto-apply event in decisions.md, (c) update workspace `CLAUDE.md` § QC → Triage Auto-Loop pointer AND `docs/qc-independence.md` § QC → Triage Auto-Loop. /risk-check required (workspace CLAUDE.md cross-cutting). Dedicated session within 2 weeks — auto-apply rule design is high-leverage and warrants careful boundary-drawing on the "mechanical" class.

### Item 3 — Add Step 2.5 self-check QC to /session-start
✓ APPLIED. Inserted Step 2.5 with four floor checks (work_scope is a sentence not a topic; exit_condition is observable; files_in_scope ≥1 path or `(inferred)`; stop_if is concrete or `(none stated)`). Re-asks max once per field; otherwise auto-fix silently with one-line log appended to Step 4 confirmation. Mirrors `/session-plan` Step 7 self-check pattern. No /risk-check (single-file command edit).

### Item 4 — Strengthen /graduate-resource Step 4+5 generalization + verification
SCHEDULE-DEDICATED [med]. Requires a verify-the-gap-is-real pre-step (run subagent grep-scan against 2-3 recently-graduated resources to confirm the gap is real) BEFORE designing the fix. Then design + edit ai-resources/docs/ai-resource-creation.md § graduation rules. /risk-check required (workspace CLAUDE.md cross-cutting AI Resource Creation pointer). Dedicated session — gap-verification + design + risk-check is a natural 1-hour focused unit.

### Closure note
This dispatch converts 4 plan items into 1 APPLIED (item 3), 3 SCHEDULE-DEDICATED (items 1, 2, 4). All 3 deferred items target 2-week horizon; none are silent drops — each will get its own /session-start mandate when picked.

---

## 2026-05-29 — Friday-act general: 2 APPLIED, 5 SCHEDULE-DEDICATED, 2 PENDING, 1 LAST

**Scope.** Plan general had 10 items, 2 [high]. Item 1 hard-stops without operator GO (DR-8). Item 9 is /cleanup-worktree (runs last per plan ordering).

### Item 1 — Concurrent-session detection hook (DR-8 gate)
SCHEDULE-DEDICATED [high]. DR-8 gate waiting for explicit operator GO before build. Not actioned this session because the hard-stop pre-build approval has not fired. Operator-driven: when ready, invoke a dedicated build session.

### Item 2 — Fix log-sweep-auditor Cat A2 heuristic
✓ APPLIED. Cat A1/A2 and Cat B threshold logic updated: over-threshold now requires `line_count ≥ threshold AND entry_count > KEEP`. Eliminates the long-line / few-entry false-positive pattern. Edit at ai-resources/.claude/agents/log-sweep-auditor.md.

### Item 3 — Extract change-shape classifier to shared reference doc
SCHEDULE-DEDICATED [med]. Two-end contract (`/consult` + `/pm` share the classifier). Dedicated session needed to: (a) extract the logic to a new docs/ reference file, (b) update both consumer commands to point at the doc, (c) verify both readers still resolve. Not a /risk-check class but the cross-resource consistency check (Step 6 Tripwire reminder in the session plan) means careful work.

### Item 4 — Extract Q1-Q8 placement logic into skills/placement-classification/SKILL.md
SCHEDULE-DEDICATED [med]. New skill path → /risk-check required. Two confirmed consumers. Dedicated session: create skill, /risk-check, /qc-pass, update consumers.

### Item 5 — Investigate sub-subagent dispatch limitation in /pm
PENDING [med]. Investigation-only at this stage. Recorded here as `Status: pending` (NOT applied). Findings:
- `/pm` (project-manager) ships in degraded mode for structure escalation because Task tool is not available agent-to-agent.
- Workaround paths: (a) operator-mediated escalation (have main session re-invoke /consult); (b) main-session pre-dispatch (caller decides escalation before invoking /pm); (c) extend Task tool agent-to-agent (Claude Code platform feature, not actionable here).
- No fix this session. Schedule a tighter investigation if escalation rate grows.

### Item 6 — Create improvement-log.md in obsidian-pe-kb + project-planning
✓ PARTIALLY APPLIED. obsidian-pe-kb log seeded with canonical header (no entries). project-planning already has an existing improvement-log.md — no creation needed; verified in pass.

### Item 7 — Schedule dedicated session for /wrap-session refactor + permission-sweep-auditor follow-ups
SCHEDULED [med]. Target: dedicated session within next 2 weeks. Both deferred twice; third defer would be silent drift. /wrap-session refactor is leaner-rewrite (token-audit lever); permission-sweep-auditor follow-ups are the deferred auditor enhancements. Block out 1 hour.

### Item 8 — Build /clean-folder workspace-level command
SCHEDULE-DEDICATED [med]. New command path → /risk-check required. Plan-only output (restructure plan to audits/restructure-plans/). Dedicated session: design + /placement at build time + /risk-check + /qc-pass.

### Item 9 — /cleanup-worktree ai-resources
RUNS AS FINAL ITEM this session — after all preceding Plan 6 items dispatched.

### Item 10 — /improve-skill friday-act
SCHEDULE-DEDICATED [med]. /improve-skill runs its own internal /risk-check at structural-change gate. Auto-triage Step 3 + 3.5 disposition loops (HIGH=f, MED=f unless duplicate/low-value, LOW=d unless decision/chain-blocking, then f). Operator directive 2026-05-29 explicit ("triage the follows AUTOMATICALLY"). Dedicated session within 2 weeks.

### Closure note
Plan 6 dispatch: 2 APPLIED (items 2, 6), 1 PENDING (item 5), 1 SCHEDULED (item 7), 5 SCHEDULE-DEDICATED (items 1, 3, 4, 8, 10), 1 RUNS-LAST (item 9, this session).

---

## 2026-05-29 — Friday-act general item 9 (/cleanup-worktree) deferred to dedicated session

**Context.** Plan general item 9 specified running /cleanup-worktree against ai-resources after the other items landed. End-of-session reality: 12 commits shipped across 5 repos; concurrent session activity confirmed earlier (8 commits rebased over on interpersonal-communication during Plan 1 item 3); /cleanup-worktree itself is a substantial protocol (plan mode + 2 QC + triage + hard gates).

**Decision.** Defer to dedicated /cleanup-worktree session.

**Rationale.** (1) /cleanup-worktree is explicitly designed as its own focused session by the skill itself ("not a sidebar"); (2) running a heavy QC/triage protocol after a long mandate execution adds error risk; (3) the 6 currently-modified files in ai-resources are mostly hook-auto-mods (coaching-data, innovation-registry, session-notes-archive) plus the session's own session-notes/session-plan + a CLAUDE.md change that warrants investigation in fresh context — none are blocking.

**Trigger to revisit.** Operator invokes /cleanup-worktree directly when next sitting down to a maintenance window. Suggested ≤1 week so the dirty files don't accumulate.

**Item closure.** Friday-act plan general item 9 closed as DEFERRED-TO-DEDICATED-SESSION.
