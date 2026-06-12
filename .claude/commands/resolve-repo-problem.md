---
description: Investigate a repo error, broken state, or structural inconsistency — OR a session/workflow fault (a command misbehaving, a gate firing at the wrong time, conflicting instructions, a hook nudging wrongly). Two operator-invoked modes — MANUAL (a problem description; subagent investigation; ranked three-option fix plan to audits/working/) and AUTO (no argument; inline investigation auto-detected from the conversation). Both log a pending entry to improvement-log.md for the Friday cadence. Triage only — applies no fix.
model: opus
---

> **Routing rule (2026-06-12, supersedes the 2026-05-28 note):** `/resolve-repo-problem` is the **triage front door**; `/resolve-incident` (classify → bounded fix → verify → log) is the **fix path it hands off to**. The handoff is the end-of-run **fix-path bridge line** — when triage ends with an actionable recommended fix, this command emits a ready-to-invoke `Fix path: /resolve-incident "..."` line carrying the diagnosis forward, so `/resolve-incident` resumes from the triage instead of re-investigating. The bridge is advisory chat output only: this command never invokes `/resolve-incident` itself, and applies no fix in either mode. Use `/resolve-incident` directly when you already know the fault and want the fix in-session without a triage pass.

Diagnose a problem and produce a fix plan. `/resolve-repo-problem` covers two kinds of problem — a repo error or structural inconsistency, and a session/workflow fault that surfaced mid-session (a command misbehaved, a gate fired at the wrong time, two loaded instructions conflicted, a hook nudged wrongly). It runs in one of two operator-invoked modes and **applies no fix in either — triage only.**

- **MANUAL mode** — invoked with a problem description. A fresh-context subagent locates the relevant files, diagnoses the root cause, and writes a ranked three-option fix plan to `audits/working/`. The operator (or a follow-up session) decides which option to execute.
- **AUTO mode** — invoked with no argument, typically right after Claude reports a fault in chat. The issue is auto-detected from the recent conversation and the investigation runs **inline in the main session** (the live conversation already holds the evidence — no subagent).

Both modes append a `Status: logged (pending)` entry to `improvement-log.md`, which `/friday-checkup` surfaces for the Friday fix cadence.

Input: `$ARGUMENTS` — optional. A short description of the problem (the error seen, the broken state, the inconsistency or fault noticed). Empty `$ARGUMENTS` routes to AUTO mode.

---

### Step 0 — Mode and issue resolution

1. **Select the mode:**
   - `$ARGUMENTS` non-empty → **MANUAL mode**. Set `ISSUE` = `$ARGUMENTS` verbatim. Go to MANUAL Step 1.
   - `$ARGUMENTS` empty → **AUTO mode**. Resolve the issue via Step 0a, then go to the AUTO routine.

2. **Step 0a — auto-detect the issue (AUTO mode only).** Scan the recent conversation for the surfaced problem: the most recent operator message or Claude observation describing a command misbehaving, a gate or guardrail flag firing at the wrong time, two loaded instructions conflicting, or a hook nudging/blocking wrongly. Write a 1–2 sentence `ISSUE` statement — what was expected, what happened, and which command / hook / rule was involved. If no concrete issue can be identified, abort AUTO mode with one chat line — `No session issue found to investigate` — and do **not** write an `improvement-log.md` entry.

---

## MANUAL mode

### MANUAL Step 1 — Path setup

3. Set `DATE` = today, `YYYY-MM-DD`.
4. Set `REPO_ROOT` = `git -C "$(pwd)" rev-parse --show-toplevel` (fall back to cwd if not a git repo).
5. Set `WORKING_DIR` = `{REPO_ROOT}/audits/working/`. Create it if missing (`mkdir -p`).
6. Compute `SLUG` from `ISSUE`: lowercase, replace non-alphanumeric runs with a single `-`, strip leading/trailing `-`, truncate to 50 characters at a `-` boundary. If empty, fall back to `problem-{HHMMSS}`.
7. Set `NOTES_PATH` = `{WORKING_DIR}/{DATE}-resolve-{SLUG}.md`. If it already exists, append `-2`, `-3`, … until unique.

### MANUAL Step 2 — Delegate the investigation

8. Spawn one general-purpose investigator subagent (fresh context) with this brief:

   ```
   You are a repo-problem investigator. Diagnose a reported problem and produce a fix plan. You do NOT apply any fix — this is triage only.

   PROBLEM (operator's description):
   {ISSUE verbatim}

   REPO_ROOT: {REPO_ROOT}

   Procedure:
   1. Locate the relevant files. Use Glob and Grep from REPO_ROOT to find the files, commands, agents, hooks, or config the problem touches.
   2. Read the governing context: the nearest CLAUDE.md (project and workspace), and the most recent ~10 entries of logs/decisions.md if it exists — a past decision may explain the current state. If the problem is a session/workflow fault (a command, gate, hook, or instruction misbehaving), also read the most recent block of logs/friction-log.md and logs/session-notes.md.
   3. Diagnose the root cause. Distinguish the symptom from the cause. If the evidence does not support a single root cause, say so and list the candidate causes rather than forcing one.
   4. Produce a ranked three-option fix plan:
      - Quick patch — the smallest change that resolves the symptom. Note what it leaves unaddressed.
      - Structural fix — addresses the root cause. Note its blast radius and whether it needs a /risk-check gate.
      - Defer — what is lost or risked by not fixing now, and what signal would make it urgent.
      Rank the three by a risk-vs-effort judgment and name your recommended option.

   Write your FULL findings to: {NOTES_PATH}
   Structure: ## Problem / ## Files examined / ## Root-cause diagnosis / ## Fix options (the three, ranked) / ## Recommended option.

   Then return a summary of AT MOST 25 lines to the main session:
   - The root-cause diagnosis in 1–3 sentences.
   - The three options, one line each, with the recommended one marked.
   - The last line must be exactly: `NOTES: {NOTES_PATH}`

   Do not apply any fix. Do not edit, create, or delete any file other than {NOTES_PATH}.
   ```

### MANUAL Step 3 — Present the result

9. If the returned summary lacks the `NOTES: {NOTES_PATH}` last line, re-invoke the subagent once with the same brief. If it still lacks the marker, report the malformed summary and the expected notes path to the operator.

10. Display the subagent's summary to the operator, prefixed with `Repo-problem triage — {DATE}`, and state the full notes path.

### MANUAL Step 3a — Fix-path bridge

10a. Read the recommended-option marker in the subagent's returned summary (the summary lists the three options one line each, with the recommended one marked — it is free text, not a structured field).
    - Recommended option is **Quick patch** or **Structural fix** → emit the bridge block below as the final chat output of this run.
    - Recommended option is **Defer** → suppress the bridge; emit nothing extra.

    ```
    Fix path: /resolve-incident "{1-line diagnosis + the recommended fix} — triage notes: {NOTES_PATH}"
    ```

    The argument carries the diagnosis and cites `{NOTES_PATH}` so `/resolve-incident` Step 3 builds on the existing triage notes instead of re-investigating. If the subagent's plan flagged the recommended option as a `/risk-check` change class, append ` [risk-check class]` inside the quoted argument so the fix session enters with eyes open.

    The bridge is **advisory chat output only** — do not invoke `/resolve-incident`; the operator's re-invocation is the gate-preserving turn.

### MANUAL Step 4 — Log a pending improvement-log entry

11. Append a `logged (pending)` entry to `{REPO_ROOT}/logs/improvement-log.md` using the **Improvement-log entry schema** below. The `Proposal` field summarises the subagent's **recommended option** in 2–4 sentences; the `Notes` field cites `{NOTES_PATH}`. This puts the triage on the `/friday-checkup` queue. If `{REPO_ROOT}/logs/improvement-log.md` does not exist, create it first — see the schema section.

---

## AUTO mode — inline investigation

Runs entirely in the main session. **No subagent** — the operator invokes AUTO mode right after the fault was reported, so the live conversation is the evidence. The issue is `ISSUE` from Step 0a.

**A. Gather evidence.** Use the recent conversation already in context. Supplement it with scoped greps — only if the files exist — of `logs/friction-log.md` (recent session block), `logs/decisions.md` (last ~10 entries), and `logs/session-notes.md` (current exit condition / open threads).

**B. Diagnose.** Distinguish symptom from root cause. If the evidence supports more than one cause, list the candidates rather than forcing one.

**C. Propose a fix.** Name ONE recommended fix (not a three-option ranked plan), naming the target files. If the fix is itself a `/risk-check` change class (hook, settings.json, CLAUDE.md, new command, symlink), say so in the proposal.

**D. Write the entry.** Append one self-contained `logged (pending)` entry to `{scope}/logs/improvement-log.md` using the schema below. `{scope}` = `git rev-parse --show-toplevel` of the cwd (fall back to cwd). No `audits/working/` notes file in AUTO mode — the entry is the write-up.

**E. Report.** Display in chat: `Session-issue triage — {DATE}`, the root-cause diagnosis (1–3 sentences), the recommended fix (one line), and `Logged to {scope}/logs/improvement-log.md`.

**F. Fix-path bridge.** If the recommended fix from step C is actionable (not a defer-shaped proposal), emit one bridge line **after** the `Logged to ...` line, as the final chat output:

```
Fix path: /resolve-incident "{1-line diagnosis + the recommended fix}"
```

The argument is the **inline diagnosis text only — never cite a notes path** (AUTO mode writes no `audits/working/` file; citing one would fabricate a reference). If step C flagged the fix as a `/risk-check` change class, append ` [risk-check class]` inside the quoted argument — step F reads that determination from step C; it makes none of its own. AUTO mode may *offer* the fix via this bridge, never perform it — the operator's re-invocation of `/resolve-incident` is the gate-preserving turn.

---

### Improvement-log entry schema

Both modes append entries in this shape. It conforms to the `## Schema` block of `improvement-log.md`; `Status` uses the compound `logged (pending)` form that `/friday-checkup` Step 6 matches.

```
### YYYY-MM-DD — {short issue title}

- **Status:** logged (pending)
- **Category:** session-issue
- **Source:** {AUTO: "/resolve-repo-problem AUTO mode YYYY-MM-DD" | MANUAL: "/resolve-repo-problem YYYY-MM-DD"}
- **Friction source:** {1-2 sentences — what was expected, what happened, which command/hook/rule was involved}
- **Proposal:** {AUTO: the single recommended fix, 2-4 sentences, naming target files, flagging if the fix is itself a /risk-check change class | MANUAL: a 2-4 sentence summary of the subagent's recommended option}
- **Target files:** {files to edit when the fix is executed}
- **Notes:** {MANUAL only — the audits/working/ notes path; omit this field entirely in AUTO mode}
```

`Category: session-issue` is a recognised value under the schema's free-text "broad classification" definition. If `{scope}/logs/improvement-log.md` does not exist, create it first with the `# Improvement Log` header followed by the `## Schema` block copied from the canonical `ai-resources/logs/improvement-log.md`, then append the entry.

---

### Triage only — no fix, no commit

`/resolve-repo-problem` applies no fix and commits nothing in either mode. The diagnosis and fix plan are advisory. In MANUAL mode the operator chooses an option; executing it is separate work — and if the chosen option is a structural fix flagged for `/risk-check`, run that gate before landing it. The `logged (pending)` entry — written by either mode — is resolved through `/friday-checkup` → `/friday-act`, not in the session that logged it.
