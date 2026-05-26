# Session Plan — 2026-05-26

## Intent
Implement three pre-drafted plans — (1) mechanical sibling-entry sweep bash check in `/prime` Step 1a, (2) live concurrent-session mtime guard in `/session-start` Step 0.5, and (3) `repo-architecture.md` docs update for `knowledge-bases/`. `/risk-check` at plan-time required on plans 1 + 2 per their own briefs; plan 3 is a docs-only edit exempt per `docs/audit-discipline.md`.

## Class
mixed (execution dominant) — plans 1 + 3 are mechanical; plan 2 carries one judgment call (own-session vs foreign-session write distinction).

## Model
opus — match (active session is `claude-opus-4-7[1m]`). Judgment work is plan 2's mitigation choice + synthesizing two `/risk-check` and three `/qc-pass` returns.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/prime-step-1a-sibling-sweep.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/concurrent-session-live-detection.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/repo-architecture-knowledge-bases-update.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md` (target for Plans 1 + 2)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md` (target for Plan 2)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md` (target for Plan 3)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` (risk-class reference for /risk-check)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/logs/improvement-log.md` (annotate source entries for Plans 1 + 2)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` (annotate source entry for Plan 3)

## Findings / Items to Address

1. **Plan 1 — `/prime` Step 1a sibling-entry sweep (mechanical enforcement).** [`plans/prime-step-1a-sibling-sweep.md`] Current sub-step is prose; the executing model can silently skip the scan (the 2026-05-26 brand-book session was live evidence). Replace prose with a discrete `SIBLING_COUNT=$(grep -c "^## ${TODAY}" logs/session-notes.md)` bash block in Step 1a. Existing Step 6 emission contract preserved verbatim. Source: brand-book improvement-log § 2026-05-26.
2. **Plan 2 — `/session-start` Step 0.5 mtime-delta guard (live concurrent-session detection).** [`plans/concurrent-session-live-detection.md`] Current `/prime` → `/session-start` chain has no live signal — the sibling-entry sweep is retrospective only. Add a new Step 0.5 to `session-start.md` that captures `session-notes.md` mtime, computes delta against `NOW`, and pauses with a 2-option prompt when DELTA < 120s. **Open design choice (judgment call):** distinguish own-session write from foreign-session write via (a) read-back content match, (b) marker file in `logs/`, or (c) tail-content authorship check. Plan defers the choice to the implementation session; this session will pick and document. Also: one-line advisory note added to `/prime` Step 8a. Source: brand-book improvement-log § 2026-05-26 deeper structural gap.
3. **Plan 3 — `repo-architecture.md` `knowledge-bases/` documentation update.** [`plans/repo-architecture-knowledge-bases-update.md`] Workspace-root tree omits the `knowledge-bases/` top-level directory; canonical-homes table has no row for cross-project Obsidian KB vaults. Add one tree entry (alphabetical between `harness/` and `logs/`) + one canonical-homes table row capturing the implicit "cross-project reuse → `knowledge-bases/{name}/`; project-scoped → `projects/{name}/vault/`" principle. Verification: confirm `pe-kb-vault/` is the current sole vault before writing the framing. Source: ai-resources improvement-log § 2026-05-26.

## Execution Sequence

Plans are independent — no inter-dependency. Recommended order: lowest-risk first to bank a clean commit before tackling the more complex plan 2.

1. **Wave 3 — Plan 3 (docs-only, no `/risk-check`).** Read current `repo-architecture.md`; verify `knowledge-bases/` contents via `ls`; apply Edits 1 + 2 (tree entry + canonical-homes row) in one `Edit` pass; annotate ai-resources improvement-log entry as applied + Verified; commit. **Verify:** the two additions appear in the file; no existing content changed. **`/qc-pass`** after edit; commit on no REVISE.
2. **Wave 1 — Plan 1 (mechanical edit + `/risk-check`).** Run `/risk-check` at plan-time using Plan 1's pre-filled brief; expected GO or PROCEED-WITH-CAUTION. Edit `/prime` Step 1a: inject the `SIBLING_COUNT=$(grep -c …)` bash sub-step at end of the *Git cross-check* block; collapse the existing prose sibling-sweep paragraph to a single explanatory line. Annotate brand-book improvement-log entry as applied + Verified. **Verify:** new bash sub-step present; prose paragraph collapsed; Step 6 emission contract unchanged. **`/qc-pass`** after edit; commit on no REVISE.
3. **Wave 2 — Plan 2 (design choice + structural edits + `/risk-check`).** Pick the own-vs-foreign-write distinction (a/b/c) — inline decision, surface the choice with rationale before editing. Run `/risk-check` at plan-time using Plan 2's pre-filled brief (false-positive mitigation must be designed in); expected PROCEED-WITH-CAUTION with mitigation list. Add Step 0.5 to `/session-start` (mtime check + own-write distinction + 2-option pause prompt); add one-line advisory to `/prime` Step 8a. Annotate brand-book improvement-log entry as applied + Verified (single annotation covering both plans). **Verify:** Step 0.5 present with correct mtime/distinction logic; advisory note present in `/prime` Step 8a. **`/qc-pass`** after edit; commit on no REVISE.
4. **Wrap.** After Waves 3 + 1 + 2 each committed, decide whether to `/usage-analysis` inline or defer to `/wrap-session`. Remind operator to push (push gate from prior session is still open — 7 unpushed commits will be 10+ by end of this session).

## Scope Alternatives

- **Min scope:** Plan 3 only (docs-only, zero risk, ~5 min). Banks documentation accuracy; leaves Plans 1 + 2 for a follow-up session.
- **Recommended scope:** All three plans, in the order above. Total expected: 2 `/risk-check` invocations + 3 `/qc-pass` invocations + 3 commits + improvement-log annotations.
- **Max scope:** All three plans + immediate `/usage-analysis` + push. Stretches into push approval territory and conflates the implementation session with the deferred push gate; recommended only if scope holds and context is unfrayed at the end of Wave 2.

## Autonomy Posture
Gated.

**Stop points:**
- After Plan 1 `/risk-check` plan-time → NO-GO halts Wave 1; PROCEED-WITH-CAUTION applies mitigations inline.
- Before Plan 2 implementation → present the (a) / (b) / (c) mitigation choice with rationale; pick the recommended one and proceed (per CLAUDE.md decision-point posture — no opinion-seeking ask).
- After Plan 2 `/risk-check` plan-time → NO-GO halts Wave 2; PROCEED-WITH-CAUTION applies mitigations inline.
- After any plan's `/qc-pass` REVISE that cannot be self-resolved.
- Context-lean check at end of Wave 1 — if context is fraying, defer Wave 2 to a follow-up session per the workspace context-constraint deferral rule.

## Risk
Run `/risk-check` at plan-time before each of Wave 1 (Plan 1) and Wave 2 (Plan 2). Run again at end-time before commit on each — unless documented end-time skip criteria are met (see `feedback_end_time_risk_check_skip` memory: plan-time gate ran, mitigations applied, QC clean, drift bounded). Plan 3 is docs-only and not on the canonical change-class list per `docs/audit-discipline.md` — no `/risk-check` required.

**Tripwire check (Plan 2):** Step 0.5 reorders operations against `session-notes.md` shared state at `/session-start` entry — qualifies as automation-with-shared-state-effects per the Step 6 tripwire. `/risk-check` is required regardless of any "existing-command refactor" framing.
