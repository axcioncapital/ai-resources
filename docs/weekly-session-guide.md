# Weekly Session Guide

Quick-reference for running a week. Full details: `weekly-cadence.md` and `session-rituals.md`.

---

## Weekly rhythm

| Day | What runs |
|---|---|
| Monday | `/monday-prep` — infrastructure check + week mandate |
| Tue–Thu | Regular work sessions |
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

## Regular work session (Tue–Thu)

**Start**
```
/prime              Read state, open threads, model check
/session-plan       (optional) Plan model tier + autonomy posture for the session
```

Before working: declare the exit condition ("done when X") and autonomy level ("auto-proceed except bright-line items").

**During**
```
/friction-log       Log anything awkward or slow — describe it, don't diagnose
/note               Log a workflow observation
/triage             Before approving a set of suggestions
```

After each approved section: 60-second coherence scan ("flag contradictions across all approved sections").

**End**
```
/qc-pass            Quality check on what you produced
/refinement-pass    Refinement pass (after QC passes)
/wrap-session       Wraps session, triggers logging
/improve            Reviews friction log, proposes fixes
/usage-analysis     (optional) Token efficiency review
```

### Phase 3 harness session (Tue–Thu, when running a harness simulation)

```
/prime
/session-start      State mandate in 2–5 sentences → writes to session-notes.md
[work units]        One commit per unit; run work-unit-checklist before/after each
/wrap-session       Auto-generates Phase 3 session report
```

Reference material: `harness-prep/` at workspace root (mandate template, report template, checklists, hardening log).

---

## Friday — Session 1: Review + Checkup + SO Advisory

Start at ai-resources or workspace root. Switch cwd mid-session as shown.

| Step | Command | cwd |
|---|---|---|
| F0 | Read harness session reports, friction-log, session-notes, week mandate (no command) | — |
| F1 | `/friday-checkup` | ai-resources or workspace root |
| F3 | `/friday-so` | `projects/axcion-ai-system-owner/` |
| F2 | `/so-monthly` *(monthly only — first Friday of month)* | `projects/axcion-ai-system-owner/` |

Switch back to workspace root after F2/F3.

F1 must complete before F3 and F2 — both abort if no checkup report is found.

---

## Friday — Session 2: Act + Graduate + Harness

Run from workspace root or ai-resources.

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
| `/qc-pass` | After every creation or improvement |
| `/wrap-session` | Every session end |
| `/friday-checkup` | Every Friday Session 1 |
| `/friday-so` | Every Friday Session 1 (after checkup) |
| `/so-monthly` | First Friday of month only |
| `/friday-act` | Every Friday Session 2 |
| `/graduate-resource` | Every Friday Session 2 |

---

## Tier detection (auto)

`/friday-checkup` auto-detects the tier from the date:

| Tier | Condition |
|---|---|
| quarterly | First Friday of Jan, Apr, Jul, Oct |
| monthly | First Friday of any other month |
| weekly | Any other Friday |

Pass `weekly`, `monthly`, or `quarterly` as an argument to override.
