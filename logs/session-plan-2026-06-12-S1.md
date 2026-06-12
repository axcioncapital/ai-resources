# Session Plan — 2026-06-12

## Intent
Fix the two P3 first-firing hook defects: (A) date-anchor the mandate-header lookup in `check-foreign-staging.sh` so an older same-S session entry cannot shadow today's footprint, and (B) add per-id session-marker teardown to the `/handoff` deferral path so a handoff-ended session does not leave a live-looking marker. Both are `/risk-check` change classes.

## Model
opus — match (active session is opus; fix design for a guard hook + a handoff teardown carries judgment under ambiguity, especially Defect B's three candidate options).

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh` — target of Defect A (mandate-header lookup regex)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/handoff.md` — target of Defect B (deferral-path teardown)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md` — reference: Step 13 teardown pattern (line 464) is the exact one-liner to port
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md` — marker contract (both fixes touch marker semantics; two-end teardown contract registered here)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — risk-check change-class definitions
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` — the PENDING defect entry (2026-06-11) that specifies both defects + their fixes

## Findings / Items to Address
1. **Defect A — undated header lookup** (improvement-log 2026-06-11 "check-foreign-staging.sh first live firing", Defect A). The hook resolves the marker (`S2`) then finds the mandate footprint via a header regex of shape `^## \d{4}-\d{2}-\d{2} — Session S2\b` — **any** date matches. An older `## 2026-06-10 — Session S2` entry matches first, so its `(inferred)` footprint shadows today's CONCRETE footprint → the no-concrete-footprint branch is wrongly entered. **Fix:** anchor the header date to TODAY. `logs/.session-marker` already stores `YYYY-MM-DD SX` — use both fields, not just the S-number.
2. **Defect B — handoff leaves a live-looking marker** (same entry, Defect B). `_live_foreign_session()` in the hook treats any today-dated foreign per-id marker as a live session. A session ended via `/handoff` (deferral) never runs wrap Step 13 teardown, so its per-id marker survives and reads as a live concurrent session → escalates warn→BLOCK. **Fix (option 1, the cheap structural close):** `/handoff` gains the same per-id marker teardown wrap Step 13 has — `[ -n "${CLAUDE_CODE_SESSION_ID}" ] && rm -f "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}"` — on its deferral path, as a final action.

## Execution Sequence
1. **Read both targets fully.** Read `check-foreign-staging.sh` around the header-lookup logic (locate the exact regex + the marker-read that supplies the date) and `handoff.md` (locate the deferral/continuity-mode path and its final actions). Verify: the marker-read already exposes the date field, or determine how to obtain TODAY.
2. **Defect A edit.** Anchor the header regex to today's date sourced from the marker file (`YYYY-MM-DD` + `SX`), not S-number alone. Preserve the existing fail-open/escalation behavior for genuinely-absent footprints. Verify: a stale same-S entry from a prior date no longer matches; today's concrete footprint resolves.
3. **Defect B edit.** Add the per-id marker teardown one-liner to `/handoff`'s deferral path as a final step, mirroring wrap Step 13 (including the `CLAUDE_CODE_SESSION_ID` guard and the "leave shared marker untouched" rule). Verify: a deferral handoff removes `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`; the shared marker is untouched.
4. **Plan-time `/risk-check`** (before any commit). Two change classes: PreToolUse hook edit + canonical command edit. Apply any mitigations.
5. **`/qc-pass`** on both edits (independent subagent). On GO → commit. On unreachable subagent → defer via `/handoff` QC-PENDING per the Stop-if rule.
6. **Commit** across the affected repo(s); update the improvement-log entry status (PENDING → resolved) referencing the commit.

## Scope Alternatives
- **Min:** Defect A only (the commit-blocking false-fire — higher operational severity). Leaves Defect B's stale-marker over-nudge unaddressed.
- **Recommended:** both A and B — they are the paired first-firing defects named in one entry; same hook-firing root-cause family; one risk-check + QC pass covers both.
- **Max:** both + also port the Defect B teardown to the workspace-root `wrap-session.md` mirror (the MIRROR NOTE at wrap Step 13 line 467 flags this independent copy). Defer to a sync session unless trivially in-scope.

## Autonomy Posture
Gated — two structural change classes touched, but scope is bounded to two named defects.

**Stop points:**
- After this plan is approved: run `/risk-check` (plan-time gate) before editing.
- Before commit: `/qc-pass` GO required; on unreachable QC subagent, defer commit via `/handoff` QC-PENDING (do not self-QC-and-commit).

## Risk
Run `/risk-check` after the plan is approved (plan-time gate). Run it again before commit (end-time gate). Change classes: PreToolUse hook edit (`check-foreign-staging.sh`) + canonical command edit (`handoff.md`) — both automation-with-shared-state-effects (marker/footprint semantics).
