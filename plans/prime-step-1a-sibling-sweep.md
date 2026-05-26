# /prime Step 1a Sibling-Entry Sweep — Mechanical Enforcement Plan

**Date:** 2026-05-26
**Source entry:** `projects/axcion-brand-book/logs/improvement-log.md` § "2026-05-26 — /prime Step 1a sibling-entry sweep not mechanically enforced; missed live parallel-session signal"
**Status:** Plan draft (no code edits this session)
**Intended execution:** Separate session

---

## Source citation

- **Logged:** 2026-05-26 in `projects/axcion-brand-book/logs/improvement-log.md` (the brand-book improvement-log).
- **Friction trigger:** During the `/prime` → task-1 → `/session-start` chain in the axcion-brand-book project, `/prime` did not emit its Step 1a "⚠ Multiple same-day entries exist (parallel wraps possible)" warning even though `grep -c "^## 2026-05-26" logs/session-notes.md` returned 2 at that moment.
- **Severity:** not explicitly tagged; operator-flagged within the broader "concurrent-session" priority surfaced 2026-05-26.

## Distinguishing this plan from the already-shipped /prime work

The 2026-05-11 friction-log entry "`/prime` Next Steps goes stale when same-day parallel sessions wrap out of order" was marked `[FADING-GATE] verified 2026-05-26` — that earlier work added the Step 1a sibling-entry sweep **as a written spec rule**. This plan handles a different, residual gap: the spec rule is **prose only** and can be silently skipped by the executing model when context is constrained. The 2026-05-26 brand-book session was the live evidence. This plan replaces prose with a mechanical bash command so the sweep cannot be skipped.

## Diagnosis

Current `ai-resources/.claude/commands/prime.md` Step 1a (the "Sibling-entry sweep" sub-paragraph, around lines 50–51) reads:

> *Sibling-entry sweep:* Scan `logs/session-notes.md` for additional `## <source-entry-date>` headers that appear **after** the source entry (same calendar date, later position in file). If any exist, set a flag so step 6 can emit this exception line:
> > ⚠ Multiple same-day entries exist (parallel wraps possible). ...

The sub-step is a prose instruction. It tells the agent to "scan for additional headers" but provides no command and no explicit verification gate. In practice the agent reads `tail -n 60 session-notes.md`, sees the most recent block, builds the brief, and never re-greps for sibling headers — exactly what happened in the 2026-05-26 brand-book session.

This matters for concurrent-session conflicts because the sibling-entry warning is one of two retrospective signals `/prime` has for detecting parallel sessions on the same repo (the other being scratchpad mtime, Step 1b). Silently skipping it removes a load-bearing safety net.

## Implementation plan

**Target file:** `ai-resources/.claude/commands/prime.md`
**Target step:** Step 1a (Sibling-entry sweep sub-paragraph), immediately after the *Git cross-check* sub-paragraph and before (or replacing) the existing prose sweep paragraph.

**Insert this discrete bash sub-step at the end of the *Git cross-check* block:**

```
Sibling-entry sweep — mechanical check:

  TODAY=$(date '+%Y-%m-%d')
  SIBLING_COUNT=$(grep -c "^## ${TODAY}" logs/session-notes.md 2>/dev/null || echo 0)

  If SIBLING_COUNT > 1, set the Step 6 sibling-entry flag and capture the list of
  same-day header titles for the brief's exception line:

  grep -n "^## ${TODAY}" logs/session-notes.md
```

**Then collapse the existing prose paragraph into a single explanatory line below the bash block:**

> If the flag is set, Step 6 emits: "⚠ Multiple same-day entries exist (parallel wraps possible). Next steps taken from `{source entry title}`; also review: `{list of sibling entry titles}`."

**Result:** the agent cannot proceed past Step 1a without having run the `grep -c` command. Whether or not the flag is then surfaced still depends on the agent setting the flag, but the count itself is now a deterministic bash output rather than a prose instruction.

## Risk-check brief

**Pre-filled brief for the implementation session's `/risk-check` call:**

- **Change class:** Edit to a universally-loaded command (`/prime` runs at every session start).
- **Blast radius:** Every session, every project. The edit is bounded to Step 1a (sub-step injection + one paragraph rewrite); other Step 1a content unchanged.
- **Reversibility:** Full — single-step `Edit` revert restores the prior prose.
- **Hidden coupling risk:** Low. The bash command is read-only (`grep -c`) and uses `logs/session-notes.md`, which `/prime` already reads in Step 1. No new shared-state touch.
- **Permissions surface:** No change — `grep` already permitted.
- **Usage cost:** Negligible (one `grep -c` per `/prime` invocation; outputs a single integer).

Expected verdict: GO or PROCEED-WITH-CAUTION (minor mitigation: ensure the bash block uses `2>/dev/null || echo 0` so a missing log file does not break the chain).

**Run `/risk-check` at plan-time before execution.** This is a structural change to a universally-loaded command; see workspace `CLAUDE.md` Autonomy Rule #9.

## Acceptance criteria

1. `prime.md` Step 1a contains a `SIBLING_COUNT=$(grep -c "^## ${TODAY}" ...)` bash block as a discrete sub-step.
2. The prose "Scan `logs/session-notes.md` for additional `## <source-entry-date>` headers" paragraph is replaced or collapsed — no duplicate instruction.
3. The Step 6 emission contract for the sibling-entry warning line is preserved verbatim.
4. Test fixture: a `logs/session-notes.md` containing two `## YYYY-MM-DD` headers for today produces `SIBLING_COUNT=2` and surfaces the warning in the `/prime` brief.
5. Implementation session runs `/risk-check` at plan-time; verdict GO or PROCEED-WITH-CAUTION-with-mitigations.
6. Implementation session runs `/qc-pass` after the edit; no REVISE findings.
7. Improvement-log entry in `projects/axcion-brand-book/logs/improvement-log.md` is updated to `Status: applied YYYY-MM-DD` and `Verified: YYYY-MM-DD` after operator confirmation.
