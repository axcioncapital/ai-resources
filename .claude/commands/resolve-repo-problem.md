---
description: Investigate an unexpected repo error, broken state, or structural inconsistency. Spawns an investigator subagent that diagnoses the root cause and writes a ranked three-option fix plan (quick patch / structural fix / defer) to audits/working/. Triage only — applies no fix.
model: opus
---

Diagnose a repo problem and produce a fix plan. `/resolve-repo-problem` takes a problem description, delegates investigation to a fresh-context subagent that locates the relevant files, reads the governing rules, and diagnoses the root cause, then writes a ranked three-option fix plan. **Triage only — it applies no fix.** The operator (or a follow-up session) decides which option to execute.

Input: `$ARGUMENTS` — a short description of the problem: the error seen, the broken state, or the inconsistency noticed.

---

### Step 1 — Input validation

1. If `$ARGUMENTS` is empty, abort with:
   ```
   /resolve-repo-problem requires a problem description.
   Example: /resolve-repo-problem the auto-sync hook symlinks commands the manifest lists as local
   ```
   Set `PROBLEM` = `$ARGUMENTS` verbatim.

---

### Step 2 — Path setup

2. Set `DATE` = today, `YYYY-MM-DD`.
3. Set `REPO_ROOT` = `git -C "$(pwd)" rev-parse --show-toplevel` (fall back to cwd if not a git repo).
4. Set `WORKING_DIR` = `{REPO_ROOT}/audits/working/`. Create it if missing (`mkdir -p`).
5. Compute `SLUG` from `PROBLEM`: lowercase, replace non-alphanumeric runs with a single `-`, strip leading/trailing `-`, truncate to 50 characters at a `-` boundary. If empty, fall back to `problem-{HHMMSS}`.
6. Set `NOTES_PATH` = `{WORKING_DIR}/{DATE}-resolve-{SLUG}.md`. If it already exists, append `-2`, `-3`, … until unique.

---

### Step 3 — Delegate the investigation

7. Spawn one general-purpose investigator subagent (fresh context) with this brief:

   ```
   You are a repo-problem investigator. Diagnose a reported problem and produce a fix plan. You do NOT apply any fix — this is triage only.

   PROBLEM (operator's description):
   {PROBLEM verbatim}

   REPO_ROOT: {REPO_ROOT}

   Procedure:
   1. Locate the relevant files. Use Glob and Grep from REPO_ROOT to find the files, commands, agents, hooks, or config the problem touches.
   2. Read the governing context: the nearest CLAUDE.md (project and workspace), and the most recent ~10 entries of logs/decisions.md if it exists — a past decision may explain the current state.
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

---

### Step 4 — Present the result

8. If the returned summary lacks the `NOTES: {NOTES_PATH}` last line, re-invoke the subagent once with the same brief. If it still lacks the marker, report the malformed summary and the expected notes path to the operator.

9. Display the subagent's summary to the operator, prefixed with `Repo-problem triage — {DATE}`, and state the full notes path.

10. `/resolve-repo-problem` applies no fix and commits nothing. The diagnosis and fix plan are advisory. The operator chooses an option; executing it is separate work — and if the chosen option is a structural fix flagged for `/risk-check`, run that gate before landing it.
