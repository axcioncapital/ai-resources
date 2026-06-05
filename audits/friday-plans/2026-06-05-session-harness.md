# Friday Act Plan — 2026-06-05 — session-harness

**Source report:** friday-checkup-2026-06-05.md (monthly tier)
**Journal report:** (none)
**Generated:** 2026-06-05
**Items:** 5

## Items

### 1. [high] Add a pre-push `git fetch` + rebase-prompt to the `/wrap-session` push gate; decide whether to set `pull.rebase=true` policy (via /risk-check)
- **Source:** checkup
- **Risk-check required:** yes — change class: cross-repo git automation / policy (pull.rebase decision)
- **W2.4 auto-draft:** no

The `/wrap-session` push gate has no pre-push pull, so concurrent-machine push rejection is structurally guaranteed; pairs with the no-reconciliation-policy gap (no `pull.rebase` set). Cross-machine git divergence seen at 2 logged occurrences, trending. (This same divergence is live right now in ai-resources: 4 local commits + 1 unmerged remote.) Add a pre-push `git fetch` + rebase prompt to the wrap-session push gate. Separately decide via `/risk-check` whether to set a `pull.rebase=true` reconciliation policy.

### 2. [med] Add a session-entry guard / retroactive-mandate synthesis so sessions started outside `/prime` still get a marker + mandate
- **Source:** checkup
- **Risk-check required:** yes — change class: likely SessionStart hook (.sh) — confirm at execution; if pure command-text nudge, no
- **W2.4 auto-draft:** no

Sessions started outside `/prime` bypass marker-numbering AND the mandate ceremony, so wrap has nothing to grade; multi-stage pipelines run with no `**Mandate:**` block → low-confidence wrap. Cheap fix: a `/clarify` + pipeline-entry mandate nudge, or a session-entry guard that synthesizes a retroactive marker + mandate. Confirm at execution whether the chosen fix touches a hook file (risk-check class) or is a pure command-text edit (no gate).

### 3. [med] Date-qualify the session-plan filename (`session-plan-{YYYY-MM-DD}-S{N}.md`) in session-marker.md + writers + glob consumers
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no

`session-plan-S{n}.md` omits the date, so cross-day marker reuse collides (seen 3× — including this very session, where today's S1 plan collided with yesterday's S1 plan file). Date-qualify to `session-plan-{YYYY-MM-DD}-S{N}.md` in `docs/session-marker.md` plus all writers (`/prime` Step 8, `/session-plan`) and glob consumers. Instruction-fix across multiple files; no settings/hook/CLAUDE.md class touched.

### 4. [med] Add per-item done-condition presence-check before auto-multi-item bundles execute in `/prime` Step 8c
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no

Surfaced independently by ai-resources `/improve` + W2.4. Before an auto-multi-item bundle executes in `/prime` Step 8c, check that each picked item has a concrete done-condition. Command-text edit to `/prime`; no risk-check class.

### 5. [med] [SESSION-ISSUE] Step 3.5 CONCURRENT block strands a no-own-marker session whose work is already committed (2026-06-04) — decide: fix, defer, or close
- **Source:** checkup
- **Risk-check required:** conditional — no for a pure decision (defer/close); yes if the fix restructures the `/wrap-session` Step 3.5 concurrent-session staging / shared-state write logic — change class: automation with shared-state effects (reordering of existing shared-state ops)
- **W2.4 auto-draft:** no

The `/wrap-session` Step 3.5 CONCURRENT guard can strand a session that has no own-marker but whose work is already committed. Decide at execution whether to fix (extend the guard to recognize already-committed no-marker work), defer, or close. Command-text edit to `/wrap-session` (paired copies); no risk-check class.

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- For any item marked "Risk-check required: yes", run `/risk-check` before executing that item.
- For any item marked "W2.4 auto-draft: yes", decide auto-draft vs. manual at execution time per the W2.4 sub-disposition in the `/friday-act` Step 3 W2.4 instructions.
- Run `/wrap-session` when all items in this plan are done.
