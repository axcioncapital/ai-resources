# W2.4 Implementation Plan — 2026-05-08 to 2026-05-15

**Source:** `/systems-review` 2026-05-08 (full AI infrastructure)
**Target:** Ship the smallest viable W2.4 improvement-loop slice before next `/friday-checkup`.
**Anti-goal:** Do not mix with W2.2 or W2.3. Do not add new detection.

---

## TODAY (2026-05-08, Friday — what's left of the day)

**1. Wrap this systems-review session.**
Run `/wrap-session`. Push the 5 pending commits when prompted. Estimated time: 10 min.

**2. (Optional) Open one short session to write the W2.4 brief.**
Goal: before stopping for the day, have a clear written brief of what the smallest W2.4 slice actually is. Not the code — just the brief. One page, in `inbox/` so `/create-skill` or a planning session can pick it up next.

What the brief should answer:
- **Trigger:** when does W2.4 fire? (proposed: at the end of `/wrap-session`, OR as a `/friday-checkup` step)
- **Input:** which file does it read? (`logs/improvement-log.md`)
- **Action:** what does it do to a "no active friction" entry? (proposed: archive — move to a dated `improvement-log-archive-YYYY-MM.md`)
- **Boundary:** what does it NOT do? (no rule edits, no command edits, no CLAUDE.md edits — only archive operations on the log)
- **Rollback:** how do you turn it off? (proposed: a single config flag in settings)

Estimated time: 30–45 min. Skip if energy is low — Saturday or Monday is fine.

---

## MONDAY 2026-05-11 — risk-check + plan

**1. `/risk-check`** on the W2.4 brief. Expect either GO or PROCEED-WITH-CAUTION (it touches a log file but is reversible).

**2. Plan-mode session** to design the implementation. Enter plan mode, lay out:
- New files (likely: 1 command, 1 subagent OR 1 script)
- Modified files (probably 0–2)
- Data flow
- Test target: the 3 "no active friction" entries already flagged in `improvement-log.md`

**3. `/qc-pass`** on the plan. Resolve findings before exit.

**4. Approve plan, exit plan mode.** Estimated session time: 60–90 min.

---

## TUESDAY 2026-05-12 — execute + first test

**1. Execute the approved plan.** Build the command/subagent/script.

**2. Run W2.4 against the live `improvement-log.md`.** Confirm it archives the 3 stale "no active friction" entries and leaves everything else alone.

**3. `/risk-check` end-time gate.** Verify nothing drifted. Commit.

Estimated time: 60–90 min.

---

## WEDNESDAY 2026-05-13 — verify + push

**1. Re-read `improvement-log.md`.** Confirm it reflects the W2.4 archive correctly.

**2. Push commits** (manual step — your approval).

**3. Start a backlog burn-down session for the smallest friday-act plans.** In priority order:
- `risk-topology.md` plan (4 dead wiki-links — mechanical, ≤15 min)
- `commands.md` plan (innovation-sweep schema fields — mechanical, ≤15 min)
- `qc-pass.md` plan (2 small items — ≤30 min)

**Stop after 90 min total**, even if items remain. The point is to drain the backlog, not to clear it perfectly.

---

## THURSDAY 2026-05-14 — buffer + finish

**1. If W2.4 needs a fix** (something misbehaved on Tuesday's run): use this day for the fix. Do NOT extend scope.

**2. If W2.4 is clean:** continue draining friday-act backlog in the same priority shape:
- `cadence.md` plan
- `settings.md` narrowed Gate A (run `/permission-sweep` for allow grants only — already designed)
- `cleanup-worktree.md` plan (runs last by design)

**3. Skip any plan that would take >60 min.** Defer it past Friday.

---

## FRIDAY 2026-05-15 — `/friday-checkup`

Run the normal Friday cadence. The system review said success looks like:
- W2.4 closure rate ≥ improvement-log intake rate over the last 7 days
- No new operator paste-step introduced
- Rollback path tested (or at least confirmed reversible)

If yes → next-Friday's review can plan W2.3 design. If no → W2.4 needs a second iteration; do not start W2.3.

---

## What to NOT do this week

- **Do not start W2.2 or W2.3.** They share design DNA with W2.4 — let W2.4 prove the pattern first.
- **Do not add new detection tools.** No new `/coach` metrics, no new audit subagents, no new drift scans.
- **Do not rewrite any CLAUDE.md** based on the systems review. One review is one data point — wait for trend.
- **Do not run J16** in this window. It's a separate investigation; queue it for after 2026-05-15.
- **Do not push every day.** Batch pushes — Wednesday and Thursday end-of-day are enough.
- **Do not chase the friday-act backlog perfection.** Burn down what fits in the time budget; defer the rest.

---

## Definition of done by 2026-05-15 morning

| Item | Required |
|---|---|
| W2.4 minimum slice shipped and tested | **Yes** |
| 3 stale "no active friction" entries archived | **Yes** |
| 5+ commits pushed to origin | **Yes** |
| 2–3 smallest friday-act plans executed | Nice-to-have |
| All friday-act plans executed | **No** — explicitly out of scope |
| W2.2 / W2.3 designed | **No** |

---

## References

- Systems review: [systems-review-2026-05-08-full-ai-infrastructure.md](../../../projects/axcion-ai-system-owner/output/systems-reviews/systems-review-2026-05-08-full-ai-infrastructure.md)
- Source binding-constraint analysis: § Binding Constraint
- Source leverage points: § Leverage Point Assessment (LP-4 self-organization is the highest-leverage move)
- Recommended session focus: § Recommended Session Focus

*End of plan.*
