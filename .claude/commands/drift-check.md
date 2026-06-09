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
3. Locate `logs/session-notes.md` under `REPO_ROOT`. Resolve this session's marker via `docs/session-marker.md` § Marker resolution. If marker resolves, locate the plan file via glob `logs/session-plan-*${MARKER}.md` under `REPO_ROOT` (matches both date-qualified `session-plan-YYYY-MM-DD-S{N}.md` and bare-marker `session-plan-S{N}.md` forms). Either may be absent — `/drift-check` is advisory and tolerates absence of the plan; marker absence indicates `/prime` did not run (which `/drift-check` flags but does not hard-fail; read-only auxiliary consumer per `docs/session-marker.md`).

---

### Step 2 — Resolve the session mandate

4. **If `$ARGUMENTS` is non-empty:** set `MANDATE` = `$ARGUMENTS` verbatim. Skip to Step 3.

5. **If `$ARGUMENTS` is empty, auto-detect.** The current session's mandate is the **last (bottom-most) `## {DATE}` entry block** in `logs/session-notes.md` — the file uses append-to-end ordering, so the final dated block is the most recently started session. Read that block; capture its mandate content as `MANDATE` — the `**Mandate:**` line plus any `Out of scope` / `Files in scope` / `Stop if` / `Allowed inputs` / `Required outputs` lines that follow it. Those scope clauses are the standard against which drift is judged. (Note: `Allowed inputs` and `Required outputs` are optional bullets — absent from older mandate blocks. Treat absence as "no constraint specified." Older mandate blocks may also include a `Class:` line — ignore it; the field was retired and carries no drift signal.)

6. **Multiple same-day entries — marker disambiguation rule.** Under TOCTOU Phase 2+3 atomic, each session writes its own marker-bearing header (`## YYYY-MM-DD — Session ${MARKER}`). If `MARKER` resolves, the current session's block is the one matching `${MARKER}` (not necessarily the bottom-most — though it usually is). If `MARKER` is absent/stale (pre-Phase-2 or post-session), fall through to the bottom-most-block heuristic from Step 5. Additionally: if the plan file located in Step 1 (glob `logs/session-plan-*${MARKER}.md`) exists and was modified today, read its mandate and cross-check it against this session's marker-bearing block. If the two **agree**, proceed. If they **conflict**, do not guess — carry both versions into the subagent brief (Step 3) and instruct the subagent to surface the ambiguity in its report.

7. **If no mandate can be resolved** (no `session-notes.md`, no dated block, marker absent and no marker-scoped plan, and no `$ARGUMENTS`): abort with:
   ```
   /drift-check could not find a session mandate.
   Pass one explicitly:  /drift-check {one-line statement of what this session is supposed to do}
   Or run /session-start or /prime first to record one.
   ```

7a. **Resolve the bound mission (mission-contract subsystem).** Inspect the resolved mandate block for a `- Mission: <id>` bullet (written by `/session-start` / `/prime` when the session bound a mission). **If absent, skip silently** — `MISSION_CONTRACT` is unset and drift is judged against the mandate alone, exactly as before (the common case). If present, locate the mission file: try `REPO_ROOT/logs/missions/<id>.md` first, then `{AI_RESOURCES}/logs/missions/<id>.md` (`AI_RESOURCES` = `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`), then its `archive/` subdir.
   - **Found and parseable** → set `MISSION_CONTRACT` = the file's `## Goal`, `## In scope / Out of scope`, and `## Validation contract` sections (acceptance assertions, non-negotiables, off-mission signals). This becomes a **second reference standard** for the subagent in Step 3.
   - **Absent or malformed** (id names no file anywhere, or the file has no `## Validation contract` section) → **do not hard-fail and do not silently ignore.** Emit one visible notice — `Note: mandate names mission '<id>' but no readable mission contract was found (looked in REPO_ROOT and ai-resources logs/missions/). Judging drift against the mandate only.` — then proceed with `MISSION_CONTRACT` unset. This degrade-loud behavior is the mitigation registered in `docs/session-marker.md` § Mandate-line bullet contract.

---

### Step 3 — Delegate the independent drift comparison

8. Spawn one general-purpose subagent (fresh context) with this brief:

   ```
   You are an independent drift reviewer for an in-progress Claude Code session. Judge whether the session's actual work trajectory still matches its mandate. You have NO view of the session's conversation — gather evidence only from the artifacts named below, so your judgment is independent of the main session's self-assessment.

   SESSION MANDATE (the primary reference standard — this session's local task):
   {MANDATE verbatim}
   {If Step 6 found a conflict, append: "MANDATE CONFLICT — logs/session-notes.md (Session ${MARKER} block) and {PLAN_FILE_PATH} disagree. Version A (session-notes): ... Version B (session-plan): ... Surface this in your report under a `Mandate ambiguity:` line; do not silently pick one."}

   {If MISSION_CONTRACT is set (Step 7a bound a mission), append:}
   MISSION CONTRACT (a SECOND reference standard — the multi-session goal this session serves):
   {MISSION_CONTRACT verbatim — Goal, In/Out scope, and Validation contract}
   This is the multi-session "north star." The session's local mandate should advance this mission and must not cross its non-negotiables or trip its off-mission signals. Judge mission-fit SEPARATELY from mandate-fit: a session can be ALIGNED with its narrow mandate yet drifting from the mission (e.g., doing in-scope work that quietly violates a mission non-negotiable), or vice versa.

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

   Return AT MOST 20 lines (AT MOST 24 if a MISSION CONTRACT was provided). Write no file to disk — the verdict is short by construction.
   - Line 1: `VERDICT: ALIGNED | MINOR-DRIFT | MAJOR-DRIFT` — this is the verdict against the SESSION MANDATE.
   - `Deviations:` — bulleted; each bullet names the specific evidence (commit, file, plan step) and the mandate clause it diverges from. If ALIGNED, state "none".
   {If a MISSION CONTRACT was provided, add these two lines:}
   - `MISSION VERDICT: ON-MISSION | MISSION-MINOR-DRIFT | OFF-MISSION` — trajectory vs the mission's Goal + Validation contract. OFF-MISSION = trips a non-negotiable, matches an off-mission signal, or abandons the mission goal.
   - `Mission deviations:` — bulleted; each names the evidence and the mission acceptance-assertion / non-negotiable / off-mission-signal it diverges from. If ON-MISSION, state "none".
   - `Recommended correction:` — one or two lines. For ALIGNED + ON-MISSION, "continue". For drift, the smallest corrective step (re-scope, drop an item, flag to the operator).
   - If a mandate conflict was passed in, a `Mandate ambiguity:` line stating it.
   ```

   The drift verdict is short by construction, so the subagent returns it directly with no working-notes file — the `ai-resources/CLAUDE.md` Subagent Contracts disk-notes rule targets many-file audits with long findings, not this focused comparison.

---

### Step 4 — Present the verdict

9. Display the subagent's verdict verbatim to the operator, prefixed with `Drift check — {DATE}`.

10. Append guidance by verdict (mandate verdict):
    - `ALIGNED` → "On track. Continue."
    - `MINOR-DRIFT` → "Minor drift — review the deviations; decide whether to absorb them into scope or drop them."
    - `MAJOR-DRIFT` → "Major drift — stop and reconcile with the operator before continuing."

    If a `MISSION VERDICT` line is present, append its guidance too (mandate and mission verdicts are independent — show both):
    - `ON-MISSION` → "Serving the mission. Continue."
    - `MISSION-MINOR-DRIFT` → "Mild mission drift — the local task is fine but is wandering from the mission goal; decide whether to re-aim."
    - `OFF-MISSION` → "Off the mission — this session is advancing its local task but breaking a mission non-negotiable or abandoning the mission goal. Reconcile with the operator before continuing."

11. `/drift-check` modifies no files and commits nothing. It is an advisory read-only check; the operator decides what to do with the verdict.
