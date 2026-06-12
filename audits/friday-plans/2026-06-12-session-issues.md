# Friday Act Plan — 2026-06-12 — session-issues

**Source report:** friday-checkup-2026-06-12.md (weekly tier)
**Journal report:** (none)
**Generated:** 2026-06-12
**Items:** 4

> Investigated session issues, fix-ready. The two staging-guard items from the checkup's session-issue list ("two naive-matching false-fires") and the working-tree edit disposition are NOT here — both already landed in S2 commit `96151cd`; they were dispositioned `skip` (already done) at triage.

## Items

### 1. [med] "Step 3.5 CONCURRENT block strands a no-own-marker session" (2026-06-04)
- **Source:** checkup
- **Risk-check required:** yes — change class: hook (.sh) and/or `/wrap-session` command logic
- **W2.4 auto-draft:** no
- Detail: a session with no own marker hits the Step 3.5 CONCURRENT guard and cannot cleanly write its wrap. Decide the fix (e.g., a no-own-marker write path) and gate the hook/command edit on `/risk-check`. Related to the markerless friday-checkup session that produced this very report.

### 2. [med] "ai-resources cross-machine push divergence (non-fast-forward)" (2026-06-09)
- **Source:** checkup
- **Risk-check required:** yes — change class: workspace/project CLAUDE.md (commit-discipline rule)
- **W2.4 auto-draft:** no
- Detail: pushes from a second machine diverge (non-fast-forward). Likely a commit-discipline / pull-before-push rule in CLAUDE.md or `docs/commit-discipline.md`. The rule edit gates on `/risk-check`.

### 3. [med] "system-owner agent reports 'Full advisory on disk' without write" (2026-06-10)
- **Source:** checkup
- **Risk-check required:** no — agent-definition edit (not on the canonical change-class list)
- **W2.4 auto-draft:** no
- Detail: the system-owner agent claims a disk write that did not happen → silent data loss. Fix the agent's write path / output contract in its `.claude/agents/` definition. Same subagent-write-contract class flagged for `session-feedback-collector` in recent usage analyses — consider a shared fix.

### 4. [med] "Unmarked /clarify-first session risks false-CONCURRENT write" (2026-06-10)
- **Source:** checkup
- **Risk-check required:** yes — change class: hook (.sh) — `check-foreign-staging.sh` / `detect-concurrent-session.sh`
- **W2.4 auto-draft:** no
- Detail: a session that starts with `/clarify` (no marker yet) can trip the foreign-staging guard into a false-CONCURRENT classification. Fix in the staging/concurrent-detection hooks; gate on `/risk-check`.

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- For any item marked "Risk-check required: yes", run `/risk-check` before executing that item.
- Items 1 and 4 both touch the concurrent-session hook surface (`check-foreign-staging.sh` / `detect-concurrent-session.sh`) — consider executing them together so one `/risk-check` covers the shared blast radius.
- Item 3 is an agent-definition fix; pair it with the `session-feedback-collector` write-contract gap if that fix is also scheduled.
- Run `/wrap-session` when all items in this plan are done.
