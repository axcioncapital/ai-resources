# Session Guide

Quick-reference for running the week — repo maintenance and harness preparation in one place.
Full details: `weekly-cadence.md`, `session-rituals.md`, `harness-prep/phase3-session-guide.md`.

---

## Weekly rhythm

| Day | What runs |
|---|---|
| Monday | `/monday-prep` — infrastructure check + week mandate |
| Tue–Thu | Standard work sessions or Phase 3 harness sessions |
| Friday | Two sessions: Review + Checkup + SO Advisory, then Act + Graduate + Harness |

---

## Monday — `/monday-prep`

Run at workspace root or ai-resources.

```
/prime          Orient: read last session, check state
/monday-prep    Full Monday cadence (Phases A–D)
```

What it does:
- **Phase A** — git pull, working-tree scan, worktree scan, last session threads, last week's autonomy targets
- **Phase B** — symlink audit, CLAUDE.md audit (guarded), log health, permission spot-check, inbox check, harness state
- **Phase C** — review last Friday's checkup follow-ups, review improvement-log, write week mandate to `harness/session/week-mandate-YYYY-Www.md`
- **Phase D** — log flags to session-notes, commit cleanup

Output: a flags list and a week mandate file. Start every work session this week from the mandate.

---

## Work session (Tue–Thu)

### Standard session

**Start**
```
/prime              Read state, open threads, model check
/session-plan       (optional) Plan model tier + autonomy posture
```
Declare exit condition ("done when X") and autonomy level ("auto-proceed except bright-line items").

**During**
```
/friction-log       Log anything awkward or slow — describe it, don't diagnose
/note               Log a workflow observation
/triage             Before approving a set of suggestions from Claude
```
After each approved section: ask Claude to "flag contradictions across all approved sections" (60-second coherence scan).

**End**
```
/qc-pass            Quality check on what you produced
/refinement-pass    Refinement pass (after QC passes)
/wrap-session       Wraps session, triggers logging
/improve            Reviews friction log, proposes fixes
/usage-analysis     (optional) Token efficiency review
```

---

### Phase 3 harness session

Run when doing a harness simulation session. Open `harness-prep/phase3-session-guide.md` first — that's the habit.

**Start**
```
/prime
/session-start      Claude asks: state mandate in 2–5 sentences
```

Or skip the prompt and pass it directly:
```
/session-start Update the QC checklist and verification docs. Out of scope: projects/. Done when both files are committed.
```

Use `harness-prep/session-mandate-template.md` to draft the mandate before you start if the scope is complex.

**During — 3 habits**

1. **Work in units.** One unit = one thing that can be verified and committed.

2. **Commit after each unit.** Before committing, run this mental check:
   - Output exists at the expected path ✓
   - Matches the exit condition ✓
   - No out-of-scope files touched ✓
   - Uncertainty logged if anything was unclear ✓

   For the full checklist: `harness-prep/work-unit-checklist.md`.

3. **Log friction and judgment calls.**
   - Something awkward or broken → `/friction-log what happened`
   - Decision made without stopping → `/note judgment: what I decided and why`

**Verification standard:** "Verified" means you can state which check passed — file exists at path, content matches spec, command exited 0, test passed, or operator confirmed. "Verified: yes" is not enough. See `harness-prep/verification-checklist.md`.

**End**
```
/wrap-session
```
Because you ran `/session-start`, Claude auto-detects a Phase 3 session and generates the report. It will ask you two questions — answer both in one message:
1. Judgment calls made this session (or "none")
2. What should improve next time (or "none")

The report appears in `logs/session-notes.md` under `### Session Report`.

**What Phase 3 is collecting** (after 5 sessions, run `/improve` and `/coach`):
- A mandate — what was intended
- A commit trail — what was done
- A session report — what worked, what didn't, what to change
- Friction log entries — where Claude was slow or wrong
- Judgment calls — decisions made autonomously

---

## Friday — Session 1: Review + Checkup + SO Advisory

Start with `/prime`. Declare exit condition and autonomy level. Switch cwd mid-session as shown.

| Step | Command | cwd |
|---|---|---|
| F0 | Read harness session reports, friction-log (since last Friday), last 50 lines of session-notes, week mandate — did the week deliver what was planned? Also scan `harness-prep/logs/prompt-hardening-log.md` for this week's entries — if Claude repeated a mistake twice, log it. (no command) | — |
| F1 | `/friday-checkup` | ai-resources or workspace root |
| F3 | `/friday-so` | `projects/axcion-ai-system-owner/` |
| F2 | `/so-monthly` *(first Friday of every month — monthly + quarterly tiers; aborts automatically on weekly tier)* | `projects/axcion-ai-system-owner/` |

Switch back to workspace root after F2/F3.

F1 must complete before F3 and F2 — both abort if no checkup report is found.

---

## Friday — Session 2: Act + Graduate + Harness

Start with `/prime`. Declare exit condition and autonomy level. Run from workspace root or ai-resources.

| Step | Command | What it does |
|---|---|---|
| F4 | `/friday-act` | Works through checkup follow-ups, policy review, autonomy-axis targets |
| F5 | `/graduate-resource` (no args) | Reviews `innovation-registry.md` for `triaged:graduate` entries; scans new resources created this week |
| F6 | Harness work | Phase 3: one manual harness-style session on a real work item |

**F6 Phase 3 output:** session report at `harness/session/YYYY-MM-DD-session-report.md`. Target: 5 session reports by end of month.

---

## Quick command reference

| Command | When |
|---|---|
| `/prime` | Every session start |
| `/monday-prep` | Every Monday |
| `/session-plan` | Non-trivial sessions (optional) |
| `/session-start` | Phase 3 harness sessions |
| `/clarify` | Before executing something ambiguous |
| `/friction-log` | Anything awkward or slow during session |
| `/note` | Judgment call or workflow observation |
| `/qc-pass` | After every creation or improvement |
| `/wrap-session` | Every session end |
| `/friday-checkup` | Every Friday Session 1 |
| `/friday-so` | Every Friday Session 1 (after checkup) |
| `/so-monthly` | First Friday of every month (monthly + quarterly tiers) |
| `/friday-act` | Every Friday Session 2 |
| `/graduate-resource` | Every Friday Session 2 |

---

## Harness-prep reference files

All in `harness-prep/` at workspace root.

| File | When to use |
|---|---|
| `phase3-session-guide.md` | Open at the start of every Phase 3 session |
| `session-mandate-template.md` | Pre-session: draft your mandate before typing it |
| `work-unit-checklist.md` | Before each commit |
| `verification-checklist.md` | When deciding if a unit counts as "verified" |
| `session-report-template.md` | Reference for what the auto-generated report looks like |
| `logs/prompt-hardening-log.md` | Log Claude mistakes that needed correction |
| `logs/judgment-call-log.md` | Log autonomous decisions made during sessions |

---

## Tier detection (auto)

`/friday-checkup` auto-detects the tier from the date:

| Tier | Condition |
|---|---|
| quarterly | First Friday of Jan, Apr, Jul, Oct |
| monthly | First Friday of any other month |
| weekly | Any other Friday |

Pass `weekly`, `monthly`, or `quarterly` as an argument to override.
