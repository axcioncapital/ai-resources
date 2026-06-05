# Friday Maintenance Cadence — Operator Runbook

> **When to read this file:** every time you run the Friday maintenance cadence. Follow it top to bottom.
>
> **Deeper reference (don't read these mid-run unless something breaks):**
> `weekly-cadence.md` (full technical detail) · `operator-maintenance-cadence.md` (the wider weekly rhythm) · `parallel-sessions-playbook.md` (running work in parallel safely) · `session-marker.md` + `commit-discipline.md` (shared-state and staging rules).

This runbook exists because the Friday cadence is many sessions × many commands × shared files. That mix is where errors hide. The other guides tell you *what* to run; this one adds *how to run it without breaking things*.

---

## How to use this runbook

- Follow it top to bottom. Tick each box as you go.
- **Do not skip the pre-flight (§0).** It is the part that prevents the errors.
- If something goes wrong, jump to **Troubleshooting** at the bottom.

---

## 0. Pre-flight — before you open any session

> ### The golden rule
> **Run the Friday cadence as a single serial chain.**
> Finish one session and `/wrap-session` it **before** you start the next.
> **Never run two cadence sessions at the same time in the same folder.**
>
> Almost every error from a heavy maintenance day comes from breaking this one rule — two live sessions in one folder, stepping on each other's files.

Pre-flight checklist:

- [ ] **Only one Claude Code session is open on this folder right now.** Close any others.
- [ ] **If you genuinely need parallel work — STOP.** Do not run two sessions in one folder. Read `parallel-sessions-playbook.md` first, then use a `git worktree` (a separate folder) for the second session. Parallel work is a deliberate setup, not something you start by opening a second terminal.
- [ ] **`git pull` is done and the working tree is clean.** Run `git status` — it should show nothing you didn't put there. If it shows files you don't recognise, see Troubleshooting #1 before doing anything else.
- [ ] **The right model is selected** (`/model`) for the work.
- [ ] **You know which folder each step runs in.** The cwd ("current folder") column is in the tables below — some steps switch folders.

Start every session below with `/prime`, and state your exit condition ("done when X") and autonomy level.

---

## 1. Session 1 — Review + Checkup + Advisory

Start with `/prime`.

| Step | Command | Run it from (cwd) | Before you run | What it writes |
|---|---|---|---|---|
| F0 | *(manual read — no command)* | — | — | nothing — you read the week mandate, last 4 SO advisories, friction-log since last Friday, last 50 lines of session-notes |
| F1 | `/friday-checkup` | ai-resources **or** workspace root | working tree clean? (§0) | `audits/friday-checkup-{date}.md` |
| F3 | `/friday-so` | `projects/axcion-ai-system-owner/` | F1 finished? | `…/output/friday-advisories/friday-advisory-{date}.md` |
| F2 | `/so-monthly` | `projects/axcion-ai-system-owner/` | **monthly tier only** (first Friday of the month) | `…/output/monthly-reviews/so-monthly-{date}.md` |
| F2b | `/systems-review` | workspace root | **monthly tier only** | `…/output/systems-reviews/systems-review-{date}.md` |
| F3.5 | `/friday-journal` | workspace root **or** ai-resources | — | `audits/friday-journal-{date}.md` |

**Key rules for Session 1:**
- **F1 must finish before F3 and F2.** They both abort if no checkup report exists.
- **Tier is auto-detected.** `/friday-checkup` decides weekly / monthly / quarterly from the date. F2 and F2b only run on monthly and quarterly tiers — on a normal weekly Friday they are skipped (they abort on their own if you run them). You can force a tier by passing `weekly` / `monthly` / `quarterly` as an argument.
- **Watch the cwd column** — F3/F2 run inside the system-owner project; switch back to the root afterwards.

**Close Session 1:** run `/wrap-session` → commit → confirm `git status` is clean.

---

## 2. Between sessions — the handoff

This short gate is what keeps Session 1 and Session 2 from colliding.

- [ ] Session 1 is wrapped and committed.
- [ ] `git status` is clean — no leftover files carried into Session 2.
- [ ] (Recommended) `/clear` or a fresh session, so Session 2 starts with a clean context.

---

## 3. Session 2 — Act + Graduate + Harness

Start with `/prime`. Run from workspace root or ai-resources.

| Step | Command | Before you run | What it writes |
|---|---|---|---|
| F4 | `/friday-act` | checkup report ≤ 10 days old? | `audits/friday-plans/{date}-{slug}.md` (one or more) + appends `logs/maintenance-observations.md` |
| F5 | `/graduate-resource` *(no args)* | — | nothing by default — checks the innovation registry and scans project commands/agents; you decide per resource |
| F6 | harness work | — | `harness/session/{date}-session-report.md` |

**What to expect inside F4** (so the prompts don't surprise you):
- Per tactical item, you choose **f** (fix now) / **d** (defer) / **s** (skip).
- F4 auto-runs `/qc-pass` on the plan files it writes.
- On monthly+ tiers it adds a **policy review** (r / n / d per observation).
- It ends by asking for a 7-character **autonomy-axis** posture string.

**Important:** F4 **writes plans, it does not execute them.** The actual fixes happen in separate follow-up sessions later.

**Close Session 2:** run `/wrap-session`.

---

## 4. Closing the week

- [ ] All fix-now plans are queued for follow-up sessions (remember: F4 only plans).
- [ ] **Push gate:** at wrap you get one prompt — *"Ready to push N commits across M repos: […]. Push now? y/n"*. Pushes are batched to here; there are no mid-session pushes.
- [ ] Run `/usage-analysis` if the session was substantive.

---

## Troubleshooting — when something breaks

| # | What you see | Why | What to do |
|---|---|---|---|
| 1 | `git status` shows changed files **you didn't touch** | Another session is, or was, live in the same folder | Do **not** `git add .` or `git add -A`. Stage **only your own files, by name**. Leave the foreign files alone. (→ `commit-discipline.md`) |
| 2 | At wrap, a guard warns that your own work looks "foreign" (a foreign-write or no-own-marker warning) | A concurrent session, or a half-finished marker setup | Check by hand: is the only new header in `session-notes.md` yours? If yes, it's a false alarm — proceed. For the exact guard wording and rules, see `session-marker.md`. |
| 3 | Two sessions both edited the **same command or doc file** (e.g. `prime.md`) | No guard watches `.claude/commands/` or `docs/` for foreign writes — only `session-notes.md` is watched | The single-serial-chain rule (§0) prevents this. If it already happened: run `git log` on the file, reconcile the two versions by hand **before** committing |
| 4 | A command "can't find the plan", or does nothing after a file was renamed | A file that reads the renamed file wasn't updated too | Before any rename: grep the **unchanging part of the name** (e.g. `session-plan`, not `session-plan-${MARKER}`), then check it against the registry in `session-marker.md`. (→ improvement-log id-40) |
| 5 | A command aborts: **"no checkup report found"** | You ran F3 / F2 / F4 before F1, or the checkup is more than 10 days old | Run `/friday-checkup` (F1) first — it is the prerequisite for everything after it |

---

## Why these rules exist

The cadence runs many sessions, each firing many commands, and they all write to the same shared files (logs, markers, command files). When two sessions are live in one folder, they overwrite each other's work — that is the whole class of errors behind a heavy maintenance day. The **single-serial-chain rule** (§0) removes the collision surface entirely: if only one session ever touches the folder at a time, there is nothing to collide with. Everything else in this runbook is sequencing detail; that one rule is the safety net.
