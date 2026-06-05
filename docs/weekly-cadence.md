# Weekly Maintenance Cadence

Two cadence days per week. Monday prepares infrastructure for the week. Friday reviews, fixes, and advances harness development.

## Tunable defaults

These thresholds apply to Phase B checks. Any session-specific override goes in that week's mandate file.

| Default | Value |
|---|---|
| Log length flag threshold | 200 lines |
| CLAUDE.md audit skip — days since last edit | 14 days |
| CLAUDE.md audit skip — file size | 100 lines |

Both CLAUDE.md skip conditions must hold simultaneously to skip the audit.

---

## Monday — "Oil the Gears"

**Recovery note:** If Monday is missed, run the cadence on the next available morning and note in `logs/session-notes.md` that the week mandate is late. No automated gate — self-declared recovery.

---

### Phase A — Status reset (~5 min)

1. `git pull` — workspace root
2. Working tree scan — `git status --short` in workspace root and ai-resources. Surface uncommitted files to the operator; do not auto-commit.
3. Worktree scan — `git worktree list`. Flag dead worktrees for cleanup.
4. Read last 30 lines of `ai-resources/logs/session-notes.md` — open threads from last week.
5. Read last Friday's autonomy-axis targets from `ai-resources/logs/maintenance-observations.md` — what posture did you set for this week?

---

### Phase B — Infrastructure check (~15 min)

6. **Symlink audit** — for each project under `projects/`, verify all symlinks in `.claude/commands/` and `.claude/agents/` resolve. Flag broken ones.

7. **CLAUDE.md audit for active projects** — run `/audit-claude-md project <name>` for each project active this week. Skip if CLAUDE.md was not modified in the last 14 days AND is under 100 lines (see tunable defaults above).

8. **Log health check** — check line count of the following logs.

   Per-project (for each active project):
   - `logs/session-notes.md`
   - `logs/friction-log.md`

   Workspace-level:
   - `ai-resources/logs/improvement-log.md`
   - `ai-resources/logs/maintenance-observations.md`

   Flag any file over 200 lines. For `improvement-log.md`: run `/resolve-improvement-log` if resolved+verified entries exist. For all other logs over threshold: flag for manual archive — no auto-action; operator decides during Phase C.

9. **Permission spot-check** — verify `defaultMode: bypassPermissions` in `settings.json` and `settings.local.json` for each active project. Quick bash scan, not a full `/permission-sweep`.

10. **Inbox check** — any pending entries in `ai-resources/inbox/`? Flag for this week.

11. **Harness state** — read `harness/CHANGELOG.md` last 20 lines + list `harness/session/`. What phase is active? What was last completed?

---

### Phase C — Week setup (~10 min)

12. Review last Friday's checkup follow-ups (from `ai-resources/audits/friday-checkup-YYYY-MM-DD.md`) — which tactical items to action this week?

13. Review `ai-resources/logs/improvement-log.md` pending items — any that fit this week?

14. **Write week mandate** — create `harness/session/week-mandate-YYYY-Www.md` (e.g., `week-mandate-2026-W19.md`) with:
    - What work should be done this week
    - What is out of scope
    - What counts as done
    - What files may be edited
    - When to stop and check in
    - What quality checks must run
    - Any threshold overrides for this week

15. **Session plan scaffold** (optional) — write a stub `logs/session-plan-next.md` with the intent line from the week mandate. Do not invoke `/session-plan` here.

**Scope separation:** The week mandate (`harness/session/week-mandate-*.md`) is week-scope — it covers all planned work for the week. The per-session plan (`logs/session-plan-{YYYY-MM-DD}-{marker}.md`, produced by `/session-plan`; date + marker-scoped per `docs/session-marker.md`) is session-scope — it covers how one specific session will run. These are written in separate sessions: the mandate on Monday, the session plan at the start of each work session. `/monday-prep` must never invoke `/session-plan` inline; doing so conflates the two scopes and causes the session planner to assume the current session when it should be planning the next one.

---

### Phase D — Exit (~2 min)

16. Log flagged issues to `logs/session-notes.md`.
17. Commit any cleanup done during the session. Stage only what Monday's cadence produced — do not bundle pre-existing uncommitted changes.

---

## Friday — Two Sessions

### Session and cwd map

| Step | Command | Run from |
|---|---|---|
| F0 | Pre-checkup review (no command) | — |
| F1 | `/friday-checkup` | ai-resources or workspace root |
| F3 | `/friday-so` | `projects/axcion-ai-system-owner/` |
| F2 | `/so-monthly` (monthly only) | `projects/axcion-ai-system-owner/` |
| F2b | `/systems-review` (monthly only) | workspace root |
| F3.5 | `/friday-journal` | workspace root or ai-resources |
| F4 | `/friday-act` | workspace root or ai-resources |
| F5 | Graduate resource review | workspace root |
| F6 | Harness work | workspace root |

F3 and F2 require the `axcion-ai-system-owner` project as the active cwd. Switch to that project before F3, then switch back to workspace root before F4.

---

### Session 1: Review + Checkup + SO Advisory

**F0 — Pre-checkup log review** (~10 min, operator-driven, no command)

Read before running the checkup:
- This week's harness session reports in `harness/session/`
- `ai-resources/logs/friction-log.md` entries since last Friday
- `ai-resources/logs/session-notes.md` last 50 lines
- Week mandate at `harness/session/week-mandate-YYYY-Www.md` — did the week deliver what was planned?

**F1 — `/friday-checkup`**

Produces the consolidated audit report. Required before F3 and F2 — both commands abort if no checkup report is found.

**F3 — `/friday-so`** (every Friday)

Reads the latest checkup report through a systems-thinking lens. Produces written output at:
`projects/axcion-ai-system-owner/output/friday-advisories/friday-advisory-YYYY-MM-DD.md`

**F2 — `/so-monthly`** (monthly only — first Friday of each month, when checkup tier is monthly or quarterly)

Reads the past month's Friday advisories and deferred items. Aborts automatically if the checkup tier is weekly. Produces written output at:
`projects/axcion-ai-system-owner/output/monthly-reviews/so-monthly-YYYY-MM-DD.md`

**F2b — `/systems-review`** (monthly only — first Friday of each month, same tier condition as F2)

Runs a systems-thinking analysis of the workspace. Run from workspace root after switching back from `projects/axcion-ai-system-owner/`.

**F3.5 — `/friday-journal`** (every Friday — closes Session 1)

Reads `ai-resources/logs/ai-journal.md` (operator's freeform weekly notes), runs a clarification pass on messy entries, and writes a structured implementation report to `ai-resources/audits/friday-journal-YYYY-MM-DD.md`. The report is auto-loaded by `/friday-act` Step 1.5/3.5 alongside Friday Advisory and Systems Review. After the operator confirms, processed entries archive in-file. Run from workspace root or ai-resources.

---

### Session 2: Act + Graduate + Harness

**F4 — `/friday-act`** (workspace root or ai-resources)

Reads the checkup report, works through follow-ups, policy review, autonomy-axis targets.

**F5 — Graduate resource review** (workspace root)

Run `/graduate-resource` with no arguments — checks `logs/innovation-registry.md` for entries with status `triaged:graduate`. Also scan each active project's `.claude/commands/` and `.claude/agents/` for resources created or modified this week. For any candidate: decide whether to graduate in this session.

**F6 — Harness work** (workspace root, phase-dependent)

*Phase 3 (current):* One manual harness-style session on a real work item.
- Refine this week's mandate for the specific session
- Work in explicit units, commit after each unit, keep a running session log
- Produce session report at `harness/session/YYYY-MM-DD-session-report.md`
- Target: 5 session reports by end of month

*Phase 4:* Build one primitive per Friday (session-mandate-template → session-report-template → work-unit-checklist → verification-checklist → prompt-hardening-log → judgment-call-log → workflow-config-draft). Use Phase 3 session structure for each.

*Phase 5 (monthly, first Friday):* Review all session reports + logs. Classify recurring issues (must automate / should template / human judgment / ignore). Produce classification document.

*Phase 6 (one month):* Write decision memo — "What the Agent Harness v1 Actually Needs to Solve."

---

## Full function map

| Function | Day | Session/Step | Frequency |
|---|---|---|---|
| Symlink audit | Monday | Phase B, 6 | Every Monday |
| CLAUDE.md audit (active projects) | Monday | Phase B, 7 | Weekly (guarded) |
| Per-project log health check | Monday | Phase B, 8 | Every Monday |
| Workspace log health check | Monday | Phase B, 8 | Every Monday |
| Permission spot-check | Monday | Phase B, 9 | Every Monday |
| Inbox check | Monday | Phase B, 10 | Every Monday |
| Harness state read | Monday | Phase B, 11 | Every Monday |
| Week mandate | Monday | Phase C, 14 | Every Monday |
| Pre-checkup log review | Friday | Session 1, F0 | Every Friday |
| `/friday-checkup` | Friday | Session 1, F1 | Every Friday |
| `/friday-so` | Friday | Session 1, F3 | Every Friday |
| `/so-monthly` | Friday | Session 1, F2 | Monthly (first Friday, monthly/quarterly tier) |
| `/systems-review` | Friday | Session 1, F2b | Monthly (first Friday, monthly/quarterly tier) |
| `/friday-journal` | Friday | Session 1, F3.5 | Every Friday |
| `/friday-act` | Friday | Session 2, F4 | Every Friday |
| Graduate resource review | Friday | Session 2, F5 | Every Friday |
| Harness work | Friday | Session 2, F6 | Every Friday (phase-dependent) |
