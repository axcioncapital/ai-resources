# Build Brief: W2.4 Improvement Loop Closure

**Source:** `/systems-review` 2026-05-08 (full AI infrastructure) — Leverage Point 4 (self-organization); binding constraint: operator attention on closure exceeds intake rate.  
**Requested:** 2026-05-08  
**Priority:** High — the improvement-log stock is accumulating faster than it closes; 3 of 5 current entries have no active friction reinforcing them.

---

## What This Is

A minimal automated closure mechanic for `logs/improvement-log.md`. It detects improvement-log entries where no current friction is driving action, and archives them automatically — without operator paste-step, without rule edits, without CLAUDE.md changes.

Success criterion: closure rate ≥ intake rate within two weekly cycles, no new operator paste-step introduced.

---

## The Five Design Questions

### 1. Trigger — when does it fire?

**Proposed:** as a step in `/friday-checkup` (the existing weekly health scan already reads `improvement-log.md`). `/resolve-improvement-log` is the natural companion and is already wired into the Friday cadence.

**Alternative:** at the end of `/wrap-session` (fires per-session, catches entries sooner). Higher frequency but adds ~1 tool call to every wrap.

**Decision deferred to Monday plan-mode.** Brief covers both shapes.

### 2. Input — what does it read?

- `logs/improvement-log.md` — primary target (all `logged (pending)` entries)
- `logs/friction-log.md` — to determine whether a friction event reinforces each entry within the recency window (proposed: 21 days, matching the new STALE threshold from `friday-checkup.md` Step 6)

### 3. Action — what does it do?

For each `logged (pending)` entry in the improvement-log:
1. Check whether a matching friction-log entry exists within the recency window (same category or keyword overlap).
2. If no friction reinforces the entry within the window → classify as "no active friction."
3. Archive "no active friction" entries: move the full entry block to `logs/improvement-log-archive-YYYY-MM.md` (same format as `/resolve-improvement-log` archive output).
4. Leave all entries with active friction, all `applied` entries, and all `completed` entries untouched.

**Test target (Tuesday execution):** 3 entries already flagged "no active friction" in the May 8 systems review. Confirm those 3 archive and the remaining 2 active entries stay.

### 4. Boundary — what does it NOT do?

- Does not edit any command files, agent files, or CLAUDE.md content.
- Does not apply or resolve improvements (that is `/resolve-improvement-log`'s job).
- Does not delete entries — archives only (reversible; archive file is append-only).
- Does not introduce a new friction-log entry.
- Does not modify `logs/friction-log.md`.
- Does not classify entries as "applied" or "verified."

### 5. Rollback — how do you turn it off?

A single env flag: `W24_ARCHIVE_ENABLED` in `.claude/settings.local.json` (or equivalent). When absent or `false`, the closure mechanic runs in dry-run mode: reports candidates but does not write to the archive. Default for first run: dry-run so operator can verify candidates before live archival.

---

## Implementation Shape (open for Monday plan-mode)

Three viable shapes — leave the decision to the plan-mode session:

| Shape | Files | Notes |
|-------|-------|-------|
| Extend `/resolve-improvement-log` | 1 command modified | Adds a "no active friction" detection path before the existing "applied+verified" path. Simplest. |
| New standalone command `/archive-stale-improvements` | 1 command new | Cleaner separation from `/resolve-improvement-log`. Easier to test in isolation. |
| New subagent called from `/friday-checkup` | 1 agent new + 1 command modified | Most modular; follows the existing `/friday-checkup` delegation pattern. Higher token cost. |

---

## References

- Systems review: `projects/axcion-ai-system-owner/output/systems-reviews/systems-review-2026-05-08-full-ai-infrastructure.md` § Binding Constraint, § Leverage Point Assessment (LP-4)
- W2.4 week plan: `logs/scratchpads/2026-05-08-w24-implementation-plan.md`
- Companion command: `ai-resources/.claude/commands/resolve-improvement-log.md`
- Archive format: `logs/improvement-log.md` Schema section (entries are `### YYYY-MM-DD — {title}` blocks)
- STALE threshold reference: `ai-resources/.claude/commands/friday-checkup.md` Step 6 (>21 days)
