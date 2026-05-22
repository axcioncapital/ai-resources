---
model: sonnet
---

Orient the session. Read state, brief the operator with a short task menu, wait for direction.

**Principle:** Prime never asserts state from a single source. Each surfaced next-step or status claim must be cross-checked against git log since the claim's source timestamp before being reported as current.

**Output discipline:** The operator (Patrik) is a non-developer. The brief must be short and scannable — convert terse log shorthand into plain English (short sentences, common words). Show only what the operator needs to choose the next task; everything else stays silent unless it needs attention.

0. **Pull latest.** Determine the cwd's git root: `CWD_REPO=$(git -C "$(pwd)" rev-parse --show-toplevel 2>/dev/null)`.
   If this fails, note `Pulled: n/a (not a git repo)` and skip to step 1.

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

   Do not stop on failure — record and continue. The result is carried to step 4 and surfaced in the step 6 brief only as an exception (pull failure or unpushed commits).

1. Read the last entry from `/logs/session-notes.md`. Extract: date, summary, next steps, open questions.
   If the file doesn't exist or is empty, this is the first session — note that and skip to step 2.

1a. **Cross-check Next Steps against git log and sibling entries.** Detection logic only — this command has no brief-level Next Steps list; see steps 5–6.

   *Git cross-check:* Parse the `## YYYY-MM-DD` header date from the source entry. Run:
   `git -C "$CWD_REPO" log --since="<entry-date>T00:00:00" --pretty="%h %s" --all 2>/dev/null`
   For each Next Steps bullet, check if any commit subject contains keywords from that bullet. Classify the bullet:
   - **Match found → likely-DONE.** Do NOT promote it into the numbered menu (step 5) — a 3-slot menu must not spend a slot on probably-finished work.
   - **No match → still open.** It becomes a carryover/menu candidate for step 5.

   `/prime` never edits `session-notes.md`, so every Next Step bullet stays untouched in the source file — the operator can verify there directly if a likely-DONE call looks wrong. If the git command fails or returns nothing, treat all bullets as still-open and continue.

   *Sibling-entry sweep:* Scan `logs/session-notes.md` for additional `## <source-entry-date>` headers that appear **after** the source entry (same calendar date, later position in file). If any exist, set a flag so step 6 can emit this exception line:
   > ⚠ Multiple same-day entries exist (parallel wraps possible). Next steps taken from `{source entry title}`; also review: `{list of sibling entry titles}`.

1b. **Detect a resumable continuity scratchpad.** `/handoff` continuity mode and `/wrap-session` Step 0.5 both write session-state scratchpads to `logs/scratchpads/`. Surface the most recent one so the operator can choose to resume it.

   - List `logs/scratchpads/` for files matching the glob `*-scratchpad.md` **exactly** — this excludes other files that may share the directory (e.g., `*-implementation-plan.md`).
   - Select the most recent by **filesystem mtime** — the most-recently-modified `*-scratchpad.md` file wins (e.g. `ls -t` over the matches). Do NOT sort by the `YYYY-MM-DD-HH-MM` timestamp in the filename: that timestamp is typed by the AI session that produced the scratchpad and its time-of-day component is unreliable (observed skew of 2–3 hours ahead of real write time), so lexical filename order does NOT track chronological order. `logs/scratchpads/` is gitignored — it is never populated by `git checkout` or `git pull` — so mtime always reflects the actual local write time and is the reliable chronological signal here.
   - Compare the selected scratchpad's date — the `YYYY-MM-DD` date portion of its mtime — to the date of the last `session-notes.md` entry from Step 1:
     - Scratchpad date **≥** last entry date → surface it. Read its `## Resume With` section and take the first content line.
     - Scratchpad date **<** last entry date → a later wrap superseded it; skip silently.
   - If `logs/scratchpads/` is absent or has no `*-scratchpad.md` file, skip silently.
   - When surfaced, the scratchpad is a **carryover** signal: its path appears as an exception line in the step 6 brief, and the first content line of its `## Resume With` section is a strong candidate for menu item 1 (step 5). This step does NOT auto-resume — the operator decides by picking that menu item or answering the direction prompt.

2. **Read `next-up.md`.** Read `logs/next-up.md` if it exists. Collect every unchecked checkbox item (`- [ ]` lines). These are routine menu candidates for step 5.

   `next-up.md` is **not** a universal file — it exists in some project log directories and is absent in others. `/prime` does not create it. If the file is absent, skip silently; the menu falls back to the still-open Next Steps from step 1a plus the urgent items from step 3. An absent or empty `next-up.md` is normal, not an error.

3. **Scan for urgent problems.** Read `logs/friction-log.md` and `logs/improvement-log.md` if they exist. Collect only **unresolved HIGH / urgent** items:
   - Include an item only if its text carries a HIGH-severity marker (`HIGH`, `urgent`, or `do-now` attached to a HIGH item).
   - Exclude anything marked `LOW` or `MED`, and exclude entries whose status is `resolved`, `applied`, or `verified`.
   - If neither file exists, skip silently.

   Each surviving item becomes an **urgent** menu candidate for step 5.

4. **Exception checks.** Compute the following, but carry each to step 6 only when it is abnormal — a normal value is never displayed.
   - **Working tree:** if the environment's git-status snapshot is non-empty, run `git status --short` and `git diff --stat HEAD` once to confirm it is still current. The env snapshot is point-in-time from session start and can be stale vs actual HEAD (e.g., files already committed in the prior session). Carry forward only if the live result shows unexpected uncommitted changes. This is a Prime-time orientation check, distinct from the commit-time "no pre-commit git status" rule.
   - **Model alignment:** read the active session model identifier from the system-prompt context (e.g., `claude-opus-4-7[1m]` or `claude-sonnet-4-6[1m]`) — do not run any external command, the identifier is already in context. Identify the cwd-nearest project `CLAUDE.md` and read its `Model Selection` section for the project's recommended model. If the session is opened at the workspace root with no project `CLAUDE.md` loaded, the fallback is Sonnet 1M (`claude-sonnet-4-6[1m]`). Carry forward a `→ /model {recommended}` hint only on mismatch.
   - **Pull result:** carry forward the step 0 result only on failure or when there are unpushed commits.

5. **Build the numbered task menu.** Merge candidates from:
   - Step 1a — still-open Next Steps from the last session → tag `[carryover]`.
   - Step 1b — the scratchpad `## Resume With` line, if any → tag `[carryover]`.
   - Step 2 — unchecked `next-up.md` items → tag `[next-up]`.
   - Step 3 — unresolved HIGH/urgent problems → tag `[urgent]`.

   Rank: **urgent → carryover → next-up.** Cap the menu at **3 items.** If fewer than 3 candidates exist, show fewer. If zero candidates exist, show no menu (step 6 handles this).

   Convert each menu item to **one plain-English sentence** (short sentences, common words — the operator is a non-developer):
   - Keep command names and file names literal (`/kb-review`, `next-up.md`).
   - Drop priority codes (`HIGH`/`MED`/`LOW`), status tags, and section anchors (`§3`, `WU3`) from the displayed text — keep a step number only when it aids meaning.
   - Append one short tag: `[urgent]`, `[carryover]`, or `[next-up]`.

   Example conversions:
   - `**/kb-review Step 7 registry-stub spec contradicts the registry convention** — MED, do-now` → `Fix the /kb-review command — its Step 7 instructions clash with the registry format.`
   - `Resolve Q1 (core v2 motivation) — without it, Goals (§3) cannot be populated` → `Decide the main reason for the KB v2 rebuild — other plan sections are blocked until this is settled.`

6. **Output the brief — this and nothing else.** All displayed text (the summary, exception lines, menu items) uses the plain-English conversion rules from step 5. Emit an exception line only when it is real; omit the whole line otherwise.

```
## Prime — {date}

Last session ({date}): {one-line plain-English summary}.

{↩ Unfinished from last session: {plain-English carryover} — only if last session had still-open Next Steps}
{⚠ Needs a fix: {plain-English urgent problem} — one line per step 3 item, only if any}
{⚠ Model: you are on {session model}; this project recommends {recommended} → /model {recommended} — only on mismatch}
{⚠ Working tree: {short summary} — only if unexpectedly dirty}
{⚠ Pull: {result} — only on failure or unpushed commits}
{⚠ Multiple same-day session entries — sibling-entry warning from step 1a, only if triggered}
{↩ Resumable scratchpad: {path} — only if step 1b surfaced one}

Next tasks:
  1. {plain-English task}   [{tag}]
  2. {plain-English task}   [{tag}]
  3. {plain-English task}   [{tag}]

Type 1–3 to start that task, or tell me something else.

Full backlog & inbox: /open-items
```

   If step 5 produced no menu items, replace the `Next tasks:` block and the `Type 1–3 …` line with the single line: `No tracked next steps — tell me what to work on.`

   First session ever (no `session-notes.md` from step 1): replace the `Last session` line with `First session — no prior notes.`

7. **Wait for the operator's response.** Classify the reply:
   - A bare number `1`, `2`, or `3` — or `do 2` / `task 2` / `option 2` — → **task selection.** Go to step 8a.
   - Anything else (a sentence, a different task, a question) → **free-text intent.** Go to step 8b.
   - If the reply is ambiguous (a number outside 1–3, or "2 but first do X"), ask once for a plain number or a sentence, then classify the re-response.

8a. **Task selected by number.**
   1. Resolve the number to its menu item → `TASK_TEXT` (the plain-English task text).
   2. **Plan-mode guard.** If a plan-mode system reminder is present in context (plan mode is active), do NOT run `/session-start` or `/session-plan`, and do NOT write anything. Output:
      > Task {N} noted: {TASK_TEXT}. You're in plan mode — I won't run `/session-start` yet. Exit plan mode when you're ready to execute, then re-send `{N}` (or say `go`) and I'll run `/session-start` and `/session-plan` for this task.

      Then stop.
   3. If plan mode is **not** active:
      a. Ensure today's session entry exists in `/logs/session-notes.md`. Read the last ~10 lines: if a `## YYYY-MM-DD` header for today is already present, reuse it — append `TASK_TEXT` as a work-description line beneath it. If today's header is absent, append a new `## YYYY-MM-DD` header with `TASK_TEXT` as the work description. Do NOT create a second same-day header (this is the duplicate-header hazard the step 1a sibling-entry sweep exists to catch). This must happen before step c — `/session-plan` Step 0 requires today's header to exist. If the operator stated a scope boundary, capture it too.
      b. Invoke the `/session-start` command with `TASK_TEXT` as its arguments (becomes the mandate). It runs its own mandate-confirmation prompt — that is expected; do not suppress it.
      c. After `/session-start` finishes, invoke the `/session-plan` command with `TASK_TEXT` as its arguments (becomes the intent). It runs its own design/execution/mixed question and writes `logs/session-plan.md`. If a same-day `session-plan.md` already exists, `/session-plan` may also surface a 3-option keep/overwrite/pass-2 prompt — that is expected mid-chain; the operator answers it normally.
      d. **Pause.** After `/session-plan` finishes, output:
         > Plan ready — review `logs/session-plan.md`. Reply `go` to start execution, or run `/qc-pass` on the plan first.

         Wait for the operator. Do NOT begin execution on your own.

8b. **Free-text intent.** The operator named the work directly instead of picking a number — original prime behavior:
   1. Ensure today's session entry exists in `/logs/session-notes.md`. Read the last ~10 lines: if a `## YYYY-MM-DD` header for today is already present, reuse it — append the work description beneath it. If today's header is absent, append a new `## YYYY-MM-DD` header with the work description. Do NOT create a second same-day header. If the operator stated a scope boundary inline (e.g., "just the refactor, not the follow-up PRs"), capture it too; otherwise omit.
   2. Begin execution immediately under full autonomy (per workspace CLAUDE.md Autonomy Rules). No second "go/proceed" confirmation required.

   **Next:** Run `/session-start` to capture the session mandate, then `/session-plan` to plan model tier, autonomy posture, and structural risk.
