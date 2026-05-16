---
model: sonnet
---

Orient the session. Read state, brief the operator, wait for direction.

**Principle:** Prime never asserts state from a single source. Each surfaced next-step or status claim must be cross-checked against git log since the claim's source timestamp before being reported as current.

0. **Pull latest.** Determine the cwd's git root: `CWD_REPO=$(git -C "$(pwd)" rev-parse --show-toplevel 2>/dev/null)`.
   If this fails, note `Pulled: n/a (not a git repo)` in the brief and skip to step 1.

   Define `AI_RESOURCES="/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources"`.

   Run `GIT_TERMINAL_PROMPT=0 git -C "$CWD_REPO" pull`. If `$CWD_REPO` differs from `$AI_RESOURCES`,
   also run `GIT_TERMINAL_PROMPT=0 git -C "$AI_RESOURCES" pull`. Capture each result:
   - Exit 0 + "Already up to date." → `up to date`
   - Exit 0, no "Already up to date." → `updated`
   - Exit non-zero + "no tracking information" → `skip (no upstream configured)`
   - Exit non-zero, other → `failed: {first relevant stderr line}`

   After pulling each repo, check for unpushed commits:
   `git -C "$REPO" log @{u}..HEAD --oneline 2>/dev/null | wc -l`
   If count > 0, append ` — {N} unpushed` to that repo's result string (e.g., `up to date — 3 unpushed`).
   If the upstream check itself fails (detached HEAD, no upstream), omit the unpushed clause silently.

   Do not stop on failure — record and continue. Results appear as `**Pulled:**` in the step 5 brief.

1. Read the last entry from `/logs/session-notes.md`. Extract: date, summary, next steps, open questions.
   If the file doesn't exist or is empty, this is the first session — note that and skip to step 2.

1a. **Cross-check Next Steps against git log and sibling entries.**

   *Git cross-check:* Parse the `## YYYY-MM-DD` header date from the source entry. Run:
   `git -C "$CWD_REPO" log --since="<entry-date>T00:00:00" --pretty="%h %s" --all 2>/dev/null`
   For each Next Steps bullet, check if any commit subject contains keywords from that bullet. Flag any match as `(likely DONE — commit <hash>)` in the output. Do not remove the bullet — preserve it so the operator can verify. If the git command fails or returns nothing, skip silently and report steps as-is.

   *Sibling-entry sweep:* Scan `logs/session-notes.md` for additional `## <source-entry-date>` headers that appear **after** the source entry (same calendar date, later position in file). If any exist, emit this warning before the Next Steps list:
   > WARNING: Multiple same-day entries exist (parallel wraps possible). Next Steps inherited from `{source entry title}`; also review: `{list of sibling entry titles}`.

2. Read `/logs/innovation-registry.md`. The registry is a pipe-delimited markdown table with columns
   `| Date | Type | File | Status | Graduated To |`. Count data rows whose Status column equals
   exactly `detected` (do NOT count `triaged:*`, `graduated`, or other statuses). Use:
   `awk -F'|' 'NR>2 && $5~/^ detected $/{c++}END{print c+0}' "$AI_RESOURCES/logs/innovation-registry.md"`
   Do not use grep with `\|` escapes — BSD grep on macOS treats `\|` as BRE alternation, causing
   the pattern to match every row. Do not grep for list-item / YAML / JSON patterns — they do not match this table format.
   If the file doesn't exist, report 0.

3. Check `/inbox/` for pending skill request briefs. Count files excluding `.gitkeep`.
   If the directory is empty or doesn't exist, report 0.

4. Read `/logs/decisions.md`. Extract the 3 most recent entries.
   If the file doesn't exist or is empty, note "No decisions logged yet" and continue.

4a. If the environment's git-status snapshot is non-empty (shows modified or untracked files), run
    `git status --short` and `git diff --stat HEAD` once to confirm it is still current. The env
    snapshot is point-in-time from session start and can be stale vs actual HEAD (e.g., files
    already committed in the prior session). Use the live result, not the snapshot, when reporting
    working-tree state or next steps. This is a Prime-time orientation check, distinct from the
    commit-time "no pre-commit git status" rule.

4b. Determine the active session model and the active project default for the model brief in step 5.
    - **Active session model:** read your own model identifier from the system-prompt context (e.g., `claude-opus-4-7[1m]` or `claude-sonnet-4-6[1m]`). Do not run any external command — the identifier is already in context.
    - **Project default:** identify which project's `CLAUDE.md` is loaded (the cwd-nearest one). Read its `Model Selection` section to extract the declared default identifier. If the session is opened at the workspace root with no project `CLAUDE.md` loaded, the fallback default is Sonnet 1M (`claude-sonnet-4-6[1m]`).
    - **Compare:** if session model and project default differ, mark the line with a `→ /model {default}` hint so the operator can switch with one keystroke. If they match, mark it `match`.


5. Output this and nothing else:

```
## Prime — {date}

**Last session:** {date} — {one-line summary}

**Inbox:** {N} skill request(s) pending
**Innovations:** {N} detected, pending triage
**Recent decisions:** {list or "None"}
**Working tree:** {clean | list of live-verified changes from step 4a}
**Pulled:** {basename of CWD_REPO}: {result[ — N unpushed]}[; ai-resources: {result[ — N unpushed]} — omit when cwd IS ai-resources]
**Model:** {session model} — project default {project default} ({match | → /model {default} to align})

**Next steps (from last session):**
{bulleted list from session notes}

**Open questions:** {list or "None"}

**Backlog check:** Run `/open-items` to surface unresolved work in this folder.
```

6. After the status block, ask **"What are we working on?"** and wait for the operator's answer.

7. Once the operator has named the work, log a new session entry header to `/logs/session-notes.md` containing the date and the work description. If the operator states a scope boundary inline (e.g., "just the refactor, not the follow-up PRs"), capture it in the header too; otherwise omit.

8. Begin execution immediately under full autonomy (per workspace CLAUDE.md Autonomy Rules). No second "go/proceed" confirmation required.

**Next:** Run `/session-start` to capture the session mandate, then `/session-plan` to plan model tier, autonomy posture, and structural risk.
