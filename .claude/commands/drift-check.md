---
description: Mid-session drift check — compares the actual work trajectory of the current session against its mandate and approved plan, and returns ALIGNED / MINOR-DRIFT / MAJOR-DRIFT with bulleted deviations. Advisory only; modifies no files.
model: opus
---

Check whether the current session is still doing what it set out to do. `/drift-check` resolves the session mandate, then delegates an **independent** comparison to a fresh-context subagent that gathers the actual work evidence itself and judges trajectory drift. Advisory only — it modifies no files and does not correct course; it tells the operator whether a correction is needed.

`/drift-check` is the operator-invoked deeper check. It complements the automatic **between-gate summary** (workspace `CLAUDE.md` § Working Principles), which emits a lightweight visibility block at each phase boundary of a numbered plan. The between-gate summary is automatic and visibility-only; `/drift-check` is the operator-invoked deeper check — run it when a between-gate summary surfaces a possible deviation, or any time mid-session you want an independent trajectory check.

Input: `$ARGUMENTS` — optional. If provided, it is treated as an explicit statement of the session mandate and overrides mandate auto-detection. If empty, the mandate is auto-detected (Step 2).

---

### Step 1 — Path setup

1. Set `DATE` = today, `YYYY-MM-DD`.
2. Determine `REPO_ROOT` = `git -C "$(pwd)" rev-parse --show-toplevel`. If the cwd is not a git repo, `/drift-check` can still run — set `REPO_ROOT` = cwd and have the subagent skip the git-evidence steps in Step 3.
3. Locate `logs/session-notes.md` and `logs/session-plan.md` under `REPO_ROOT`. Either or both may be absent.

---

### Step 2 — Resolve the session mandate

4. **If `$ARGUMENTS` is non-empty:** set `MANDATE` = `$ARGUMENTS` verbatim. Skip to Step 3.

5. **If `$ARGUMENTS` is empty, auto-detect.** The current session's mandate is the **last (bottom-most) `## {DATE}` entry block** in `logs/session-notes.md` — the file uses append-to-end ordering, so the final dated block is the most recently started session. Read that block; capture its mandate content as `MANDATE` — the `**Mandate:**` line plus any `Out of scope` / `Files in scope` / `Stop if` / `Allowed inputs` / `Required outputs` lines that follow it. Those scope clauses are the standard against which drift is judged. (Note: `Allowed inputs` and `Required outputs` are optional bullets — absent from older mandate blocks. Treat absence as "no constraint specified." Older mandate blocks may also include a `Class:` line — ignore it; the field was retired and carries no drift signal.)

6. **Multiple same-day entries — isolation rule.** If `logs/session-notes.md` holds more than one entry dated today, the bottom-most one is still the current session's (Step 5 rule). Additionally: if `logs/session-plan.md` exists and was modified today, read its mandate and cross-check it against the bottom-most block. If the two **agree**, proceed. If they **conflict**, do not guess — carry both versions into the subagent brief (Step 3) and instruct the subagent to surface the ambiguity in its report.

7. **If no mandate can be resolved** (no `session-notes.md`, no dated block, no `session-plan.md`, and no `$ARGUMENTS`): abort with:
   ```
   /drift-check could not find a session mandate.
   Pass one explicitly:  /drift-check {one-line statement of what this session is supposed to do}
   Or run /session-start or /prime first to record one.
   ```

---

### Step 3 — Delegate the independent drift comparison

8. Spawn one general-purpose subagent (fresh context) with this brief:

   ```
   You are an independent drift reviewer for an in-progress Claude Code session. Judge whether the session's actual work trajectory still matches its mandate. You have NO view of the session's conversation — gather evidence only from the artifacts named below, so your judgment is independent of the main session's self-assessment.

   SESSION MANDATE (the reference standard):
   {MANDATE verbatim}
   {If Step 6 found a conflict, append: "MANDATE CONFLICT — logs/session-notes.md and logs/session-plan.md disagree. Version A (session-notes): ... Version B (session-plan): ... Surface this in your report under a `Mandate ambiguity:` line; do not silently pick one."}

   Gather the actual work evidence yourself:
   - Run `git -C {REPO_ROOT} log --since="{DATE} 00:00:00" --pretty="%h %s"` for commits made today.
   - Run `git -C {REPO_ROOT} diff --stat HEAD` and `git -C {REPO_ROOT} status --short` for uncommitted changes.
   - Read the last (bottom-most) `## {DATE}` block in {REPO_ROOT}/logs/session-notes.md in full.
   - If that block references an in-progress plan file, read it and assess how far execution has progressed.
   {If REPO_ROOT is not a git repo: omit the git steps; rely on session-notes and the plan file.}

   Compare the evidence against the MANDATE. Decide a verdict:
   - ALIGNED — the work matches the mandate; no correction needed.
   - MINOR-DRIFT — small scope additions or ordering changes the mandate did not name but that do not contradict it.
   - MAJOR-DRIFT — work has moved onto goals the mandate excludes, skipped mandated work, or contradicts a stated scope boundary / "out of scope" / "stop if" clause.

   Return AT MOST 20 lines. Write no file to disk — the verdict is short by construction.
   - Line 1: `VERDICT: ALIGNED | MINOR-DRIFT | MAJOR-DRIFT`
   - `Deviations:` — bulleted; each bullet names the specific evidence (commit, file, plan step) and the mandate clause it diverges from. If ALIGNED, state "none".
   - `Recommended correction:` — one or two lines. For ALIGNED, "continue". For drift, the smallest corrective step (re-scope, drop an item, flag to the operator).
   - If a mandate conflict was passed in, a `Mandate ambiguity:` line stating it.
   ```

   The drift verdict is short by construction, so the subagent returns it directly with no working-notes file — the `ai-resources/CLAUDE.md` Subagent Contracts disk-notes rule targets many-file audits with long findings, not this focused comparison.

---

### Step 4 — Present the verdict

9. Display the subagent's verdict verbatim to the operator, prefixed with `Drift check — {DATE}`.

10. Append guidance by verdict:
    - `ALIGNED` → "On track. Continue."
    - `MINOR-DRIFT` → "Minor drift — review the deviations; decide whether to absorb them into scope or drop them."
    - `MAJOR-DRIFT` → "Major drift — stop and reconcile with the operator before continuing."

11. `/drift-check` modifies no files and commits nothing. It is an advisory read-only check; the operator decides what to do with the verdict.
