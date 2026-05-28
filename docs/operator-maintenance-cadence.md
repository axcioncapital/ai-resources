# Operator Maintenance Cadence

This cadence exists to keep the four-project system compounding faster than it accumulates drift, with bounded operator attention. Every step decision (add / keep / remove) should be tested against that goal.

Personal weekly rhythm — what to run, when, and what to watch for. Technical details in `weekly-cadence.md` and `weekly-session-guide.md`.

---

## Monday

Run `/monday-prep` at workspace root or ai-resources.

That command handles everything: git pull, working-tree scan, log health checks, symlink audit, CLAUDE.md audit (active projects), permission spot-check, inbox check, harness state read, and week mandate.

**Read the output.** The value is in what it surfaces — flagged logs, broken symlinks, open threads from last week.

**Recovery:** If Monday is missed, run the cadence on the next available morning. Note in `logs/session-notes.md` that the week mandate is late.

---

## Tue–Thu

### Standard session

```
/prime              Read state, open threads
/session-plan       (optional) Plan scope and autonomy posture for non-trivial sessions
```

For complex scope: draft the mandate first using `harness/prep/session-mandate-template.md` before typing it into `/session-plan`.

**Three habits every session:**
1. Work in units — one thing that can be verified and committed
2. Commit after each unit
3. Log anything awkward with `/friction-log what happened`

End every session with `/wrap-session`.

---

### Phase 3 harness session

Use this when running a deliberate harness simulation session.

```
/prime
/session-start      State mandate in 2–5 sentences
```

Open `harness/prep/phase3-session-guide.md` first — that file has the full ritual.

Same three habits apply. End with `/wrap-session` — Claude auto-detects the Phase 3 session and generates the report.

---

## Weekly — Pipeline review

Run `/pipeline-review` once per week (any day; operator-invoked). The command surfaces a ranked shortlist of 5 critical pipelines (oldest-reviewed first; friction-flagged rows promoted). Pick 1–3. The `pipeline-review-auditor` produces a System-Owner-grounded design memo per pipeline — innovations, leanness fixes, brokenness, cross-resource interactions, recommended next session. No auto-fix.

**Cadence shape:**
- Skipped-cycle warning fires at `>10 days` since the last bump (one missed weekly cycle + slack). The command emits a `[CADENCE-LATE]` marker before showing the shortlist.
- Memos land in `audits/pipeline-reviews/{pipeline-slug}-{date}.md`.
- Registry: `audits/pipeline-review-registry.md`. Bumped once per cycle, batched after all subagents return.

**Fix session is separate.** The memo says what to do; a follow-up session does it — `/improve-skill` for skill-shaped memos, manual edit + `/qc-pass` for command-shaped memos.

Distinct from `/audit-critical-resources` (drift detection) and `/friday-checkup` (housekeeping). This cadence answers *what could be better?*, not *what is broken?*.

**Known design risk.** Two operator-invoked cadences with independent skipped-cycle gates (`/friday-checkup` weekly + `/pipeline-review` weekly) can stall together. The `[CADENCE-LATE]` marker is the mitigation. If skipped more than twice per quarter, revisit folding into `/friday-checkup` as a new tier.

---

## Friday — Session 1: Review + Checkup + Advisory

Start with `/prime`. Declare exit condition and autonomy level.

| Step | Action | cwd |
|---|---|---|
| F0 | Read: last 4 `projects/axcion-ai-system-owner/output/friday-advisories/*.md` (note recurring patterns vs single-instance signals); harness session reports this week; friction-log since last Friday; last 50 lines of session-notes; week mandate — did the week deliver what was planned? | — |
| F1 | `/friday-checkup` | ai-resources or workspace root |
| F3 | `/friday-so` | `projects/axcion-ai-system-owner/` |
| F2 | `/so-monthly` — monthly only (first Friday of month, monthly/quarterly tiers) | `projects/axcion-ai-system-owner/` |
| F2b | `/systems-review` — monthly only (first Friday of month) | workspace root |
| F3.5 | `/friday-journal` — clarify the week's AI journal entries; produces report consumed by F4 | workspace root or ai-resources |
| — | Check CC Fixes & Improvements panel for ideas | — |

Switch back to workspace root after F3/F2. F1 must complete before F3 and F2 — both abort if no checkup report is found.

**Note on F-numbering:** F3 before F2 follows the canonical order in the existing cadence docs — F3 = `/friday-so`, F2 = `/so-monthly`.

---

## Friday — Session 2: Act + Graduate + Harness + Housekeeping

Start with `/prime`. Run from workspace root or ai-resources.

| Step | Action |
|---|---|
| F4 | `/friday-act` — works through checkup follow-ups, policy review, autonomy-axis targets |
| F5 | `/graduate-resource` (no args) — checks innovation registry for `triaged:graduate` entries; scans active project commands/agents for candidates |
| F6 | Harness work — Phase 3: one manual harness-style session on a real work item. See `weekly-session-guide.md` → Phase 3 harness session. |
| Graduate to docs | Review whether any resources created or modified this week should graduate to the repo-documentation repository |
| Log hygiene | Manually check and archive logs on all active projects (no command yet — see Backlog) |
| Repo audit | Run `/repo-dd` on every project worked on this week |

---

## Learning routine (every Friday)

Run at the end of Session 2.

Prompt: **"What is one AI operator skill or competence I should focus on this week to become a better operator?"**

Log the answer to `logs/learning-log.md` (file to create — see Backlog item 4).

---

## Backlog

Ideas to act on — not active steps yet.

1. **`/archive-logs` skill** — command to clean and archive logs across all active projects. Current gap: log hygiene in Session 2 is fully manual.
2. **`/lean-resources` command** — reviews skills and commands for token efficiency; suggests trimming and restructuring.
3. **`logs/learning-log.md`** — create this file to hold the weekly learning-routine entries.
