# Friday Act Plan — 2026-07-17 — repo-hygiene

**Source report:** friday-checkup-2026-07-17.md (weekly tier, recovery run)
**Journal report:** (none — freshest is 2026-05-29, outside the 7-day window)
**Generated:** 2026-07-17
**Items:** 4

> **Cluster 4 + remaining fix-now items (System Owner triage).** Small, mostly independent maintenance
> fixes. Item 4 (delete the scratch dir) clears audit-repo's only YELLOW — cheapest close in the set.

> **⚠ EXECUTION PRECONDITION (DR-10 — concurrent session), partial.** Item 3 edits `wrap-session.md`
> (both copies) — shared command files. Item 4 deletes a dir in the checkout. A live foreign session
> marker was present at plan time. Confirm the concurrent session cleared before item 3; item 4 targets
> a **gitignored** scratch dir (low collision risk) but still verify nothing else references it first.

## Items

### 1. [med] Fix the log-sweep-auditor shared-scratchpad race under parallel dispatch
- **Source:** checkup
- **Risk-check required:** no
  - (Edits the `log-sweep-auditor` agent definition — an existing agent `.md`, not a hook/settings/CLAUDE.md/new-command change class.)
- **W2.4 auto-draft:** no
- Detail: under parallel dispatch, multiple `log-sweep-auditor` instances write to one shared scratchpad path and race. Fix: derive a per-invocation unique temp filename (e.g., include the scope slug + a unique token) so concurrent instances cannot collide. Verify by reasoning through a 2-instance parallel dispatch.

### 2. [med] Resolve the 2026-06-09 graduated-agent same-session dispatch item (workspace, logged-pending)
- **Source:** checkup
- **Risk-check required:** no
  - (Re-assess at execution — if the fix edits an existing command/agent it is not a "new command/skill path" class; if it turns out to add a new symlink or auto-write, re-classify and run `/risk-check`.)
- **W2.4 auto-draft:** no
- Detail: a long-standing logged-pending backlog item — a graduated agent dispatched in the same session it was graduated. Investigate the current state first (it may already be resolved), then either fix or close. Confirm before editing.

### 3. [med] [COACH] Mirror rule-class decisions into `decisions.md` in the wrap pass
- **Source:** checkup (coach actionable, Act-rated)
- **Risk-check required:** yes — change class: auto-write / shared-state automation (adds a new automatic write of `decisions.md` at wrap, across both `wrap-session.md` copies)
- **W2.4 auto-draft:** no
- Detail: **4th consecutive cycle** flagging workspace `decisions.md` as stale (newest entry still 2026-05-26) — the prior recommendation was not acted on. The structural fix (per workspace "structural fix as default"): add a wrap-pass step that mirrors any rule-class decision made during the session into `decisions.md`, so it stops depending on the operator remembering. Edit both `wrap-session.md` copies (canonical + workspace-root) in lockstep. Run `/risk-check` — this adds shared-state auto-write behavior to a load-bearing harness command.

### 4. [low] Delete the gitignored `output/deploy-test-scratch-2026-06-12/`
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- Detail: clears audit-repo's only YELLOW — its 1 Important + 2 Minor findings all trace to this gitignored/untracked scratch dir. Verify it is genuinely a disposable test-scratch (created 2026-06-12) and nothing references it, then delete. (File deletion outside session output scope — confirm the target before removing, per Autonomy Rule #3.)

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- **Item 3 is the only `/risk-check` change class here** — run `/risk-check` before editing the wrap-session commands.
- Item 3 edits BOTH `wrap-session.md` copies; keep them in lockstep.
- Confirm the concurrent session cleared before item 3 (shared command files).
- Run `/wrap-session` when all items in this plan are done.
