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

   **Pre-fetch the log-trio** (token-audit R4, 2026-05-25). After reading `session-notes.md`, also tail-read the last 10 lines of `logs/decisions.md` and the last 30 lines of `logs/usage-log.md` — these files are touched by `/wrap-session` at session-end and a recurring Edit-before-Read failure on `session-notes.md` (3 of last 4 sessions per usage-log telemetry) is eliminated when the log-trio is already in `/prime`'s context. Use:
   ```
   Bash(tail -n 10 logs/decisions.md)
   Bash(tail -n 30 logs/usage-log.md)
   ```
   Skip silently if either file does not exist. The pre-fetch is bounded read scope; no main-session reasoning happens over these lines at /prime time — they live in context for the eventual wrap.

1a. **Cross-check Next Steps against git log and sibling entries.** Detection logic only — this command has no brief-level Next Steps list; see steps 5–6.

   *Git cross-check:* Parse the `## YYYY-MM-DD` header date from the source entry. Run:
   `git -C "$CWD_REPO" log --since="<entry-date>T00:00:00" --pretty="%h %s" --all 2>/dev/null`

   If `$CWD_REPO` differs from `$AI_RESOURCES` (the variable established in Step 0), ALSO run the same command against `$AI_RESOURCES` and merge the two result sets before the keyword-match pass below:
   `git -C "$AI_RESOURCES" log --since="<entry-date>T00:00:00" --pretty="%h %s" --all 2>/dev/null`

   Rationale: dual-repo Cluster A blindspot — Next Steps written in a project session may have been resolved by commits that landed in the ai-resources repo (canonical command edits, doc edits, log-status flips), and vice versa. Checking only the cwd-repo's git log misses those cross-repo resolutions and surfaces likely-DONE items as still-open in the menu.

   For each Next Steps bullet, check if any commit subject across the merged result set contains keywords from that bullet. Classify the bullet:
   - **Match found → likely-DONE.** Do NOT promote it into the numbered menu (step 5) — a 3-slot menu must not spend a slot on probably-finished work.
   - **No match → still open.** It becomes a carryover/menu candidate for step 5.

   `/prime` never edits `session-notes.md`, so every Next Step bullet stays untouched in the source file — the operator can verify there directly if a likely-DONE call looks wrong. If either git command fails or returns nothing, fall through to whichever result set succeeded; if both fail, treat all bullets as still-open and continue.

   *Sibling-entry informational note (TOCTOU Phase 2+3 atomic shape):* Under marker-scoped session writes (see `docs/session-marker.md`), each session writes its own marker-bearing header `## YYYY-MM-DD — Session ${MARKER}`. Multiple same-day headers is the EXPECTED shape, not a hazard — do NOT emit a `⚠` warning (per `principles.md § AP-10`: no error handling for impossible-or-normal scenarios).

   If brief visibility into concurrent same-day sessions is wanted, count distinct marker-bearing headers and emit one informational line at Step 6:

   ```bash
   TODAY=$(date '+%Y-%m-%d')
   SIBLING_COUNT=$(grep -c "^## ${TODAY}" logs/session-notes.md 2>/dev/null || echo 0)
   ```

   If `SIBLING_COUNT > 1`, Step 6 emits (no warning icon): `Today's session count: {N} marker-bearing entries ({list of markers, e.g., 'S1, S2, S3'}). This session is {MARKER}.`

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
   - **Phase READMEs.** If the cwd-rooted project has a `work/` directory, scan it (one level deep) for files matching `W*-*-README.md` (or `Wn-*-README.md`). Capture the matching file paths only — do not read file bodies. Skip silently if `work/` is absent or contains no matches. Bounded scan: one `ls`/`find -maxdepth 2`-equivalent; do not recurse deeper.

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
{Today's session count: {N} marker-bearing entries ({list of markers}). This session is {MARKER}. — informational only, no `⚠` icon; only when SIBLING_COUNT > 1}
{⚠ Phase READMEs detected: {paths}; read before opening the relevant work unit — only if step 4 surfaced any}
{↩ Resumable scratchpad: {path} — only if step 1b surfaced one}

Next tasks:
  1. {plain-English task}   [{tag}]
  2. {plain-English task}   [{tag}]
  3. {plain-English task}   [{tag}]

Type 1–3 to start that task, type `auto` to run the #1 item end-to-end with a single approval gate (no per-stage prompts), or tell me something else.

Full backlog & inbox: /open-items
```

   If step 5 produced no menu items, replace the `Next tasks:` block and the `Type 1–3 …` line with the single line: `No tracked next steps — tell me what to work on.`

   First session ever (no `session-notes.md` from step 1): replace the `Last session` line with `First session — no prior notes.`

7. **Wait for the operator's response.** Classify the reply:
   - A bare number `1`, `2`, or `3` — or `do 2` / `task 2` / `option 2` — → **task selection.** Go to step 8a.
   - `auto` / `a` (case-insensitive, trimmed) — or `do auto` / `run auto` → **auto mode.** Go to step 8c.
   - Anything else (a sentence, a different task, a question) → **free-text intent.** Go to step 8b.
   - If the reply is ambiguous (a number outside 1–3, or "2 but first do X"), ask once for a plain number, the word `auto`, or a sentence, then classify the re-response.

8a. **Task selected by number.**
   1. Resolve the number to its menu item → `TASK_TEXT` (the plain-English task text).
   2. **Plan-mode guard.** If a plan-mode system reminder is present in context (plan mode is active), do NOT run `/session-start` or `/session-plan`, and do NOT write anything. Output:
      > Task {N} noted: {TASK_TEXT}. You're in plan mode — I won't run `/session-start` yet. Exit plan mode when you're ready to execute, then re-send `{N}` (or say `go`) and I'll run `/session-start` and `/session-plan` for this task.

      Then stop.
   3. If plan mode is **not** active:
      a. **Determine this session's marker** (TOCTOU Phase 2+3 atomic — see `docs/session-marker.md` for the canonical contract):

         ```bash
         TODAY=$(date '+%Y-%m-%d')
         N=1
         if [ -f logs/.session-marker ]; then
           PREV=$(cat logs/.session-marker)
           case "$PREV" in
             "${TODAY} S"*) N=$((${PREV##*S} + 1));;
           esac
         fi
         MARKER="S${N}"
         echo "${TODAY} ${MARKER}" > logs/.session-marker
         ```

         Same-day re-invocations increment within the day (`S1` → `S2` → …); a new day resets to `S1`.

         **Ensure this session's marker-bearing entry exists** in `/logs/session-notes.md`. Read the last ~10 lines: if a `## YYYY-MM-DD — Session ${MARKER}` header for THIS session's marker is already present (rare — same-marker re-invocation), reuse it — append `TASK_TEXT` as a work-description line beneath it. If THIS session's marker-bearing header is absent (the common case at `/prime` time), append a new `## YYYY-MM-DD — Session ${MARKER}` header with `TASK_TEXT` as the work description.

         Foreign concurrent sessions write under their own marker-bearing headers (e.g., `## YYYY-MM-DD — Session S2`); those do NOT count as "this session's header." The marker is the disambiguator. The pre-Phase-2 "no duplicate same-day header" rule is replaced by "this session writes only under its own marker-bearing header." This must happen before step c — `/session-start` Step 3 and `/session-plan` Step 0 require THIS session's marker-bearing header to exist.

         **After the append succeeds**, write `session-notes.md`'s mtime to `logs/.prime-mtime` (for `/session-start` Step 0.5's foreign-write check):

         ```bash
         stat -f %m logs/session-notes.md 2>/dev/null > logs/.prime-mtime \
           || stat -c %Y logs/session-notes.md 2>/dev/null > logs/.prime-mtime
         ```

         Order: marker first (top of step a), header append (middle), mtime last. Marker before append so the header can embed `${MARKER}`; mtime after append so `/session-start` Step 0.5's check sees this session's own write.
      b. Invoke the `/session-start` command with `TASK_TEXT` as its arguments (becomes the mandate). It runs its own mandate-confirmation prompt — that is expected; do not suppress it.
      c. After `/session-start` finishes, invoke the `/session-plan` command with `TASK_TEXT` as its arguments (becomes the intent). It writes `logs/session-plan-${MARKER}.md` (marker-scoped per `docs/session-marker.md`). If THIS session's marker-scoped plan already exists, `/session-plan` Step 0 surfaces a 3-option keep/overwrite/pass2 prompt — that is expected mid-chain; the operator answers it normally.
      d. **Pause.** After `/session-plan` finishes, output:
         > Plan ready — review `logs/session-plan-${MARKER}.md`. Reply `go` to start execution, or run `/qc-pass` on the plan first.

         Wait for the operator. Do NOT begin execution on your own.

8b. **Free-text intent.** The operator named the work directly instead of picking a number.
   1. Resolve the operator's stated work → `TASK_TEXT` (the work description, including any inline scope boundary like "just the refactor, not the follow-up PRs").
   2. **Plan-mode guard.** If a plan-mode system reminder is present in context (plan mode is active), do NOT run `/session-start` or `/session-plan`, and do NOT write anything. Output:
      > Free-text task noted: {TASK_TEXT}. You're in plan mode — I won't run `/session-start` yet. Exit plan mode when you're ready to execute, then re-send the task (or say `go`) and I'll run `/session-start` and `/session-plan` for it.

      Then stop.
   3. If plan mode is **not** active:
      a. **Determine this session's marker** and ensure this session's marker-bearing entry exists (same contract as Step 8a.3.a — see `docs/session-marker.md`):

         ```bash
         TODAY=$(date '+%Y-%m-%d')
         N=1
         if [ -f logs/.session-marker ]; then
           PREV=$(cat logs/.session-marker)
           case "$PREV" in
             "${TODAY} S"*) N=$((${PREV##*S} + 1));;
           esac
         fi
         MARKER="S${N}"
         echo "${TODAY} ${MARKER}" > logs/.session-marker
         ```

         Read the last ~10 lines of `logs/session-notes.md`: if `## YYYY-MM-DD — Session ${MARKER}` is already present, reuse and append `TASK_TEXT`. Else create new `## YYYY-MM-DD — Session ${MARKER}` header with `TASK_TEXT`.

         **After the append succeeds**, write `session-notes.md`'s mtime to `logs/.prime-mtime`:

         ```bash
         stat -f %m logs/session-notes.md 2>/dev/null > logs/.prime-mtime \
           || stat -c %Y logs/session-notes.md 2>/dev/null > logs/.prime-mtime
         ```

         Order: marker → header append → mtime (same contract as Step 8a.3.a).
      b. Invoke the `/session-start` command with `TASK_TEXT` as its arguments (becomes the mandate). It runs its own mandate-confirmation prompt — that is expected; do not suppress it.
      c. After `/session-start` finishes, invoke the `/session-plan` command with `TASK_TEXT` as its arguments (becomes the intent). It writes `logs/session-plan-${MARKER}.md` (marker-scoped per `docs/session-marker.md`). If THIS session's marker-scoped plan already exists, `/session-plan` Step 0 surfaces a 3-option keep/overwrite/pass2 prompt — that is expected mid-chain; the operator answers it normally.
      d. **Begin execution immediately** under full autonomy (per workspace CLAUDE.md Autonomy Rules). No second `go`/`proceed` confirmation required — the operator stating the work directly IS the go signal. This is 8b's structural delta vs 8a, which pauses for explicit `go` after `/session-plan`.

8c. **Auto mode.** The operator typed `auto` — run the top menu item end-to-end with a single approval gate and no per-stage prompts.

   1. **Resolve PICKED_ITEM.** Set `PICKED_ITEM` = the #1 item from the menu built in Step 5 (rank order: urgent → carryover → next-up). If the menu has zero items, output `No tracked next steps — auto mode needs a task. Tell me what to work on.` and stop.

   2. **Plan-mode guard.** If a plan-mode system reminder is present in context, output: `Auto mode noted: {PICKED_ITEM}. You're in plan mode — I won't write anything yet. Exit plan mode and re-send 'auto' (or 'go') to proceed.` Then stop.

   3. **Marker resolution + marker-bearing header + mtime marker** (same contract as Step 8a.3.a — see `docs/session-marker.md`):

      ```bash
      TODAY=$(date '+%Y-%m-%d')
      N=1
      if [ -f logs/.session-marker ]; then
        PREV=$(cat logs/.session-marker)
        case "$PREV" in
          "${TODAY} S"*) N=$((${PREV##*S} + 1));;
        esac
      fi
      MARKER="S${N}"
      echo "${TODAY} ${MARKER}" > logs/.session-marker
      ```

      Read last ~10 lines of `logs/session-notes.md`: if `## YYYY-MM-DD — Session ${MARKER}` is present, reuse and append `PICKED_ITEM` text as a work-description line. Else create new `## YYYY-MM-DD — Session ${MARKER}` header with `PICKED_ITEM`.

      Then write `logs/.prime-mtime` (after the header append, never before):

      ```bash
      stat -f %m logs/session-notes.md 2>/dev/null > logs/.prime-mtime \
        || stat -c %Y logs/session-notes.md 2>/dev/null > logs/.prime-mtime
      ```

   4. **Derive mandate fields** inline (matches `/session-start` Step 2 logic without the confirmation prompt):
      - `work_scope` — one sentence from `PICKED_ITEM` naming the work and its concrete deliverable.
      - `exit_condition` — an observable condition (file written, item checked off, finding addressed, commit landed). If not derivable, default to `task closed in source file`.
      - `out_of_scope` — `(none stated)` unless `PICKED_ITEM` explicitly bounds itself.
      - `files_in_scope` — infer from `PICKED_ITEM` source path and any file references in its body. Flag as `(inferred)` per `/session-start` Step 3 convention.
      - `stop_if` — `(none stated)` unless `PICKED_ITEM` carries a `[BLOCKING]`-style halt condition.
      - `allowed_inputs`, `required_outputs` — leave absent (no `(none stated)` placeholder).

   5. **Derive plan fields** inline (matches `/session-plan` Step 2 + 5–7 logic without the per-stage prompts):
      - `INTENT` — one-sentence summary of `PICKED_ITEM`.
      - `RECOMMENDED_MODEL` — apply `/session-plan` Step 2 three-tier heuristic (deciding → opus; doing → sonnet; mechanical → haiku). Compare to `ACTIVE_MODEL` from the system-prompt context. Emit `→ /model {shortname}` on mismatch.
      - `AUTONOMY_POSTURE` — `Full autonomy` default; downgrade to `Gated` if `PICKED_ITEM` touches structural change classes (hook edits, permission changes, cross-cutting CLAUDE.md edits, new commands/skills, new symlinks, new always-loaded content, automation with shared-state effects — full list: `ai-resources/docs/audit-discipline.md`).
      - `STRUCTURAL_RISK` — boolean: true if any structural class is likely.

   6. **Single approval gate.** Emit one block — this is the only operator-facing pause in auto mode. The block below uses chat-echo styling (icons `→` / `·`, multi-bullet layout); the disk-write at Step 8c.7 follows the load-bearing parse contract instead. Do not propagate the gate-block styling to the disk write.

      ```
      ## Auto Mode — {YYYY-MM-DD}

      **Picked item:** {PICKED_ITEM}
      **Source:** [{source path}]({source path})

      **Mandate**
      → Work: {work_scope} — complete fully within this session where context allows.
      · Out of scope: {out_of_scope}
      · Files in scope: {files_in_scope_written}{ (inferred) if applicable}
      · Done when: {exit_condition}
      · Stop if: {stop_if}

      **Plan**
      → Intent: {INTENT}
      → Model: {RECOMMENDED_MODEL} — {match | → /model {shortname}}
      → Autonomy: {AUTONOMY_POSTURE}

      {if STRUCTURAL_RISK is true:}
      **Risk-check**
      → Will run before execution begins (structural class detected). On RECONSIDER or NO-GO, auto mode pauses; mandate and plan are retained on disk for revision.

      ---

      Reply `go` to write mandate + plan and begin execution.
      Reply `edit` to adjust before writing.
      Reply `abort` to stop without writing anything.

      Default (no response within the turn): **abort** — nothing written.
      ```

      **Parser:**
      - `go` / `y` / `yes` (case-insensitive, trimmed) → proceed to 8c.7.
      - `abort` → output `Auto mode aborted. Nothing written.` Stop.
      - `edit` → ask one prompt: `What should change? State corrections in 'b: / a: / r: / f:' syntax (b=work_scope, a=allowed_inputs, r=required_outputs, f=files_in_scope), or other text as a free amendment to work_scope.` Apply corrections, re-emit the gate block once, accept only `go` or `abort` on the re-response. Do not loop further.
      - Anything else (including free text not preceded by `edit`) → re-ask once: `Reply 'go', 'edit', or 'abort'. Free-text refinements require 'edit' first.` Accept only `go` / `edit` / `abort` on the re-response.

   7. **Write mandate.** Locate today's `## YYYY-MM-DD` header in `logs/session-notes.md`. **Append the mandate line immediately after the header, before any existing body content** — placement contract identical to `/session-start` Step 3. Format identical to `/session-start` Step 3 exact bullet structure:

      ```
      **Mandate:** {work_scope} — done when: {exit_condition}
      - Out of scope: {out_of_scope}
      - Files in scope: {files_in_scope_written}
      - Stop if: {stop_if}
      - Allowed inputs: {allowed_inputs}      ← write only if set; omit the bullet entirely if absent
      - Required outputs: {required_outputs}  ← write only if set; omit if absent
      ```

      **Parse contract:** the `**Mandate:**` line shape, the bullet labels (`- Out of scope:`, `- Files in scope:`, `- Stop if:`, `- Allowed inputs:`, `- Required outputs:`), and the `(inferred)` / `(none stated)` markers are load-bearing. Three downstream readers depend on them: canonical `/wrap-session` Step 7a, workspace-root `wrap-session.md` Step 2b, and `/drift-check` Step 5. Do not insert extra prose into the `**Mandate:**` line itself or rename labels. The "complete fully within this session where context allows" posture lives in Step 8c.10's execution behavior, not in the mandate line — keeping it out of the disk-write preserves the two-segment parse contract (head ` — done when: ` tail).

   8. **Write plan.** Write to `logs/session-plan-${MARKER}.md` (marker resolved in step 3; canonical contract `docs/session-marker.md`) using `/session-plan` Step 7 schema (`## Intent`, `## Model`, `## Source Material`, `## Findings / Items to Address`, `## Execution Sequence`, `## Scope Alternatives`, `## Autonomy Posture`, `## Risk`). Apply `/session-plan` Step 7 self-check (length floor ≥25 substantive lines, concrete Findings, concrete Execution Sequence, realistic Scope Alternatives).

      Under TOCTOU Phase 2+3 atomic, no concurrent-session collision check is needed — each session writes its own marker-scoped plan, so foreign-session collisions are structurally impossible.

   9. **Run `/risk-check` if STRUCTURAL_RISK is true.** This is the plan-time gate per workspace Autonomy Rules #9. The single approval gate at step 8c.6 disclosed this in advance, so the operator is not surprised. Verdict handling:
       - **GO** → proceed to 8c.10.
       - **RECONSIDER / NO-GO** → output `Risk-check verdict: {verdict}. Mandate and plan retained on disk. Auto mode paused — review {risk-check report path} before resuming.` Stop. The plan and mandate stay on disk for the operator to revise.

       If STRUCTURAL_RISK is false, skip this step silently.

   10. **Begin execution under {AUTONOMY_POSTURE}.** No further confirmation gate — the Step 8c.6 approval covered execution. Run the plan to completion. Complete the mandate fully within this session where context allows; if context is clearly constrained (extended session, approaching compaction), follow the workspace `Context constraint deferral` rule — flag the deferral and log it, do not rush.

       **During execution:**
       - Run `/qc-pass` on substantive artifacts before declaring them complete.
       - For long-running work, follow `ai-resources/docs/compaction-protocol.md` named checkpoints.
       - Surface `[SCOPE]`, `[HEAVY]`, `[AMBIGUOUS]`, `[COST]` guardrail flags per workspace rules.
       - Commit directly per workspace `Commit behavior` rule (no pre-commit checks, no permission asks).

   11. **On mandate completion.** Output: `Mandate complete. Run /wrap-session to capture telemetry and journal the session. Push pending — let me know when to push.` Do not auto-invoke `/wrap-session` — the operator decides when to wrap.
