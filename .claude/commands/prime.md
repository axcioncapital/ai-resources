---
model: sonnet
---

Orient the session. Read state, brief the operator with a short task menu, wait for direction.

**Principle:** Prime never asserts state from a single source. Each surfaced next-step or status claim must be cross-checked against git log since the claim's source timestamp before being reported as current.

**Output + execution discipline:** The operator is a non-developer — the brief is short, scannable, plain English (short sentences, common words), and shows only what is needed to pick the next task; everything else stays silent unless it needs attention. Orientation's reads are now **two script calls** — Step 0's sync and Step 1's collector — plus Step 4's exception checks. **Batch Steps 0 and 1 into one message**; firing them serially is the main avoidable latency, and the collector resolves its own repo root, so it does not wait on the sync. **One ordering dependency must survive the batching:** Step 4's working-tree `git status` runs *after* Step 0's sync, so it sees post-pull state. Steps 1a–1d, 2 and 5 read `STATE` and issue no calls of their own — a step that finds itself running a `git log`, a `grep` over a log file or a directory listing has re-implemented the collector and should be corrected, not extended.

W. **Work Loop preflight — run this before Step 0, and before anything else.** This checkout may be
   held by an open Work Loop v2 task, which keeps its own durable state in `logs/work-loop/{task-id}.md`.
   Orienting a legacy session on top of that starts a **second state system** over the first. Step 0
   below is already a write — it pulls with `--rebase --autostash`, which moves HEAD and can stash an
   uncommitted task record — so this gate sits above it, not after it.

   The check is **read-only**: it asks `work-loop-owner.sh` and `work-loop-state.sh` and mutates nothing.

   ```bash
   bash "$(git rev-parse --show-toplevel)/logs/scripts/work-loop-session-preflight.sh" --command "/prime"
   ```

   - `verdict: PROCEED` — no valid open Work Loop task owns this checkout (the ordinary case, including
     a checkout with no Work Loop at all). Continue to Step 0 with behaviour **unchanged**.
   - `verdict: STOP` — write nothing, run no later step. Give the operator the `route:` and `reason:`
     lines as printed, then stop.

   **Never work around a STOP.** Do not edit, clear or re-claim `logs/work-loop/.owner`, and do not
   touch the task record — `/prime` owns neither, and a legacy command repairing Work Loop ownership is
   the exact confusion this gate exists to prevent. A stale declaration over a `CLOSED` task already
   returns `PROCEED` on its own; anything else is the operator's to decide.

0. **Sync.** Run the sync owner. It fetches, **skips the pull entirely when the repo is not behind**,
   pulls with `--rebase --autostash`, aborts and restores on a conflicted rebase, classifies the outcome
   and counts unpushed commits — for this repo and for `ai-resources`. The behind-check removes an
   incident class rather than saving time; the four result shapes and the autostash-pop case:
   `docs/commit-discipline.md` § Orientation pull.

   ```bash
   AI_RESOURCES="/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources"
   SYNC=$(bash "$AI_RESOURCES/logs/scripts/prime-sync.sh")
   ```

   `SYNC` returns `CWD_REPO: {absolute path}` — **the repository root every later step scopes its reads
   to** — followed by one `SYNC: {repo} — {result}` line per repo. Outside a git repo `CWD_REPO` reads
   `(none)`; carry that and continue. **Never stop on a sync failure:** every failure comes back as a
   classified result string, and Step 6 shows it only as an exception (a failure, unpushed commits, or
   `autostash-conflict`). Tripwire: `logs/scripts/prime-sync.test.sh`.

1. **Collect state.** Run the collector from the repository root. It performs every bounded read
   orientation needs — the last `session-notes.md` entry, its Next Steps bullets, the merged
   multi-repo commit set for a bounded window since that entry's date, the newest scratchpad, the
   plan-position cascade, active missions, `logs/next-up.md`, the shared-file concurrency advisory,
   the calling repository's identity and the telemetry-gap test. Read bounds live in the collector,
   not here: `docs/heavy-read-discipline.md` § Bounded-read recipes.

   ```bash
   STATE=$(bash "$AI_RESOURCES/logs/scripts/prime-collect.sh")
   ```

   `STATE` carries `CWD_REPO` and `TELEMETRY_GAP` as scalars, and fenced blocks — `LAST_ENTRY`,
   `NEXT_STEPS`, `COMMITS`, `SCRATCHPAD`, `POSITION`, `MISSIONS`, `NEXT_UP`, `FOREIGN_SHARED`. **A
   block being absent means that source does not exist here:** skip it silently, add no brief line,
   spend no menu slot. `CWD_REPO` repeats Step 0's value and never disagrees with it. **Concurrent-session
   liveness is NOT collected** — the SessionStart hook already reported it in this session's context;
   read that and issue no scan of your own. `TELEMETRY_GAP` is the collector's own bounded `usage-log.md`
   test, so the nudge survives without `/prime` reading either log (`ai-resources/CLAUDE.md`
   § Session Telemetry requires the nudge; it never required the prefetch). Tripwire:
   `logs/scripts/prime-collect.test.sh`.

1a. **Judge which Next Steps are done.** For each `NEXT_STEPS` bullet, test whether any `COMMITS`
   subject carries its distinctive keywords. Match → likely-DONE; keep it out of the menu. No match →
   still open; it becomes a carryover candidate for step 5. When in doubt, still-open. `/prime` never
   edits `session-notes.md`, so the operator can always check the source if a likely-DONE call looks
   wrong. The scan and its fall-through posture belong to `docs/backlog-reconciliation.md` — the
   collector is that primitive's reference implementation; the classification is judgement and stays
   here. `COMMITS` opens with a `window:` line and may end with a `truncated:` line — **when it is
   truncated, an unmatched bullet proves nothing**, so keep it still-open and never report it DONE.
   When `FOREIGN_SHARED` is present, carry its paths to Step 6 as the shared-file advisory: a
   concurrent session may be mid-edit on them. It names a surface; it never blocks.

1b. **Scratchpad.** When `SCRATCHPAD` is present, its `resume_with:` line is a strong candidate for
   menu item 1, tagged `[carryover]`. No brief line of its own; never auto-resumes — the operator
   decides by picking it.

1c. **Plan position.** When `POSITION` is present, set `PROJECT_POSITION` = `{where_we_are, status,
   next_action}` from it — each **one short plain-English sentence** per the Step 5 conversion rules —
   and derive a one-line readiness verdict from it plus the open questions in `LAST_ENTRY`. An
   `anchor:` of `inferred-from-plan-structure` means no completion marker was found: say the position
   is inferred rather than stated. When `POSITION` is absent — the normal shape in any repo without a
   plan — leave `PROJECT_POSITION` unset and omit the block entirely rather than showing empty labels.
   The full four-point readiness check belongs to `/project-next-steps`, not here.

1d. **Missions.** When `MISSIONS` is present, set `ACTIVE_MISSIONS` = its entries, each
   `{id, name, repo, open_threads[]}`, and carry it to Steps 5, 6 and the 8m binding sub-step. Absent
   is the common case: no prompt, no line, no item.

2. **Next-up queue.** Take every line in `STATE`'s `NEXT_UP` block as a menu candidate for step 5 — the collector already filtered them to unchecked items. This is now the **only** channel by which a severity-tagged finding reaches the menu — `logs/scripts/promote-findings.sh` fills the queue at wrap. An absent or empty file is normal, not an error: skip silently, and the menu falls back to step 1a's still-open Next Steps.

   *(Step 3 — the bounded urgent-log scan — was retired 2026-07-30. Orientation no longer greps the backlog: promotion is a write, orientation is a read, and the scan re-ran at every `/prime` in every project to re-derive a set that changes only when a finding is written. The severity contract it carried, including the `medium-high` menu-reach tier that must not be narrowed alone, moved to `logs/scripts/promote-findings.sh` with it. Record: `logs/decisions.md`, 2026-07-30. The numbering gap is deliberate.)*

4. **Exception checks.** Compute the following, but carry each to step 6 only when it is abnormal — a normal value is never displayed.
   - **Working tree:** if the environment's git-status snapshot is non-empty, run `git status --short` and `git diff --stat HEAD` once to confirm it is still current. The env snapshot is point-in-time from session start and can be stale vs actual HEAD (e.g., files already committed in the prior session). Carry forward only if the live result shows unexpected uncommitted changes. This is a Prime-time orientation check, distinct from the commit-time "no pre-commit git status" rule.
   - **Sync result:** carry forward a `SYNC` line from Step 0 only on a `failed:` result, when it carries an unpushed clause, or on `autostash-conflict`. The `autostash-conflict` case is the highest-priority exception: the working tree silently holds conflict markers, so the brief must say so.
   - **Phase READMEs.** If the cwd-rooted project has a `work/` directory, scan it (one level deep) for files matching `W*-*-README.md` (or `Wn-*-README.md`). Capture the matching file paths only — do not read file bodies. Skip silently if `work/` is absent or contains no matches. Bounded scan: one `ls`/`find -maxdepth 2`-equivalent; do not recurse deeper.

5. **Build the numbered task menu.** Merge candidates from:
   - Step 1a — still-open Next Steps from the last session → tag `[carryover]`.
   - Step 1b — the scratchpad `resume_with:` line, if any → tag `[carryover]`.
   - Step 1d — each active mission's `## Open threads` unchecked items, but ONLY for missions whose repo (from `ACTIVE_MISSIONS`, Step 1d) equals `CWD_REPO` (Step 0) → tag `[mission:<id>]`. Skip building a candidate for any mission whose repo ≠ `CWD_REPO` — it is not actionable from this checkout (the Step 8a/8c cross-repo guard would stop it anyway). Step 1d's multi-repo scan and those guards are unchanged and remain in place as defense-in-depth. Omit entirely if `ACTIVE_MISSIONS` is empty or none of its entries match `CWD_REPO`.
   - Step 2 — unchecked `next-up.md` items. An item carrying a `<!-- promote:… -->` id was promoted from a severity-tagged backlog finding → tag `[urgent]`; any other item → tag `[next-up]`. **That id is what preserves the two tiers now that one queue feeds both** — without the split, a promoted `high` finding would rank below ordinary carryover.

   Step 1c's `PROJECT_POSITION` is **not** a menu candidate — it renders as its own block in Step 6 and does not consume a numbered slot. Overlap between that block's `Next:` line and menu item 1 is **expected and deliberately not deduped**: the block *explains* the next step, the menu *selects* it, and a stable numbered selector is worth the small repetition. Do not add dedupe logic here.

   Rank: **urgent → mission → carryover → next-up.** Cap the menu at **6 items.** If fewer than 6 candidates exist, show fewer. If zero candidates exist, show no menu (step 6 handles this). A `[mission:<id>]`-tagged item carries its source mission id so the Step 8 binding sub-step can auto-bind without asking.

   Convert each menu item to **one plain-English sentence** (short sentences, common words — the operator is a non-developer):
   - Keep command names and file names literal (`/kb-review`, `next-up.md`).
   - Drop priority codes (`HIGH`/`MED`/`LOW`), status tags, section anchors (`§3`, `WU3`), the trailing source path and the `<!-- promote:… -->` id from the displayed text — keep a step number only when it aids meaning.
   - Append one short tag: `[urgent]`, `[mission: <id>]`, `[carryover]`, or `[next-up]`. Every `[mission:<id>]` candidate reaching this step already has repo == `CWD_REPO`, so no cross-repo tag variant is needed.

6. **Output the brief — this and nothing else.** All displayed text (exception lines, menu items) uses the plain-English conversion rules from step 5. Emit an exception line only when it is real; omit the whole line otherwise.

```
## Prime — {date}

{⚠ Working tree: {short summary} — only if unexpectedly dirty}
{⚠ Sync: {result} — only on a `failed:` result or an unpushed clause}
{⚠ Sync: autostash pop conflicted — working tree has conflict markers; stash@{0} preserved. Resolve the markers (or `git checkout --theirs`/`--ours`) and `git stash drop` before starting work. — only on an `autostash-conflict` result from Step 0}
{⚠ Concurrent session may be editing shared files: {the paths in STATE's FOREIGN_SHARED block}; check before editing them — only when that block is present}
{⚠ Concurrent session live in this checkout — before starting a task, run `/concurrent-session-check <task>` to confirm it won't collide, or `/concurrent-session-check` (no argument) to see which menu items are safe. — only when the SessionStart concurrency hook reported a live foreign session in this checkout; `/prime` reads that message from context and runs no scan of its own}
{⚠ Phase READMEs detected: {paths}; read before opening the relevant work unit — only if step 4 surfaced any}
{⚠ Last substantive session ({date}) left no `usage-log` telemetry — run `/usage-analysis` now to backfill it, or wrap future substantive sessions with `/wrap-session +telemetry`. — only when the Step 1 telemetry-gap flag fired}
{◎ Active mission(s): {for each mission in ACTIVE_MISSIONS where mission.repo == CWD_REPO: "<id> — <name>"} — only if at least one same-repo active mission exists; advisory, names the multi-session goal(s) this work can serve}

Where we are:
  {PROJECT_POSITION.where_we_are}
  Status: {PROJECT_POSITION.status}
  Next: {PROJECT_POSITION.next_action}

Next tasks:
  1. {plain-English task}   [{tag}]
  2. {plain-English task}   [{tag}]     … one line per candidate, up to 6

Type 1–6 to start that task. Type `auto` to run the #1 item end-to-end with a single approval gate, or `auto N` for a different item. Or tell me something else.

Full backlog & inbox: /open-items
```

   Render only as many numbered lines as step 5 produced (1 to 6). If step 5 produced no menu items, replace the `Next tasks:` block and the `Type 1–6 …` line with the single line: `No tracked next steps — tell me what to work on.`

   **`Where we are:` block — omit entirely when Step 1c left `PROJECT_POSITION` unset** (no plan and no `pipeline-state.md` in this repo). Drop the heading and all three lines, not just their values — an empty labelled block is worse than no block, and this is the normal shape in any non-project repo. Same "emit only when real" rule the exception lines above follow.

7. **Wait for the operator's response.** Classify the reply:
   - `N auto` (a single menu number followed by the word "auto", e.g. `2 auto` — trimmed input matching `^[1-6]\s+auto$`, N within menu range) → **auto mode**, picked item = #N. Treat identically to `auto N` and go to step 8c. (Check this branch BEFORE the bare-number rule below — otherwise `2 auto` is misread as a bare-number selection of item 2, silently skipping auto-mode and its mandate/plan ceremony.)
   - A bare number `1` through `6` (within the rendered menu range) — or `do 2` / `task 2` / `option 2` — → **task selection.** Go to step 8a.
   - `auto` / `a` (case-insensitive, trimmed) — or `do auto` / `run auto` → **auto mode**, picked item = #1. Go to step 8c.
   - `auto N` (single number within menu range) → **auto mode**, picked item = #N. Go to step 8c.
   - Anything else (a sentence, a different task, a question) → **free-text intent.** Go to step 8b.
   - If the reply is ambiguous (a number outside the rendered menu range, an `auto N` where N is outside range, or "2 but first do X"), ask once for a plain number, the word `auto` (optionally followed by one item number), or a sentence, then classify the re-response.

8m. **Mission binding (shared sub-step — 8a / 8b / 8c).** Resolves which active mission, if any, this
   session serves. **Skip entirely — no prompt, no output — when `ACTIVE_MISSIONS` (Step 1d) is empty**
   (the common case). Run after the branch's guards (8g) and before 8h.
   - Picked item is `[mission:<id>]`-sourced → `MISSION_ID = <id>`, **auto-bound, no prompt.** Picking a
     mission's open thread IS the binding.
   - Otherwise emit exactly one line: `This session serves which active mission? {[1] <id> — <name> … [N] …} — or 'none'.`
     A number → that mission's id; `none` / empty / anything else → no mission. One prompt only; default `none`.

   **Wiring:** all three branches prepend `{mission:<id>}` to the `/session-start` args; that command
   strips it and writes the `- Mission: <id>` mandate bullet (`session-start.md` Step 1). When
   `MISSION_ID` is unset, none of this happens. The cross-repo guard is **8g.2**, which fires before this
   binding and before any write — do not move 8m earlier to "cover" that case.

8h. **Session entry (shared sub-step — referenced by 8a / 8b / 8c).** One owner performs the complete
   sequence — allocate the marker, append this session's marker-bearing header, stamp the mtime — in that
   order. The order is load-bearing and is enforced inside the script rather than restated here. Takes one
   parameter, `WORK_DESC`. Run it after the caller's guards and before `/session-start`.

   ```bash
   MARKER_LINE=$(bash "$AI_RESOURCES/logs/scripts/prime-session-entry.sh" "$WORK_DESC") || exit 1
   TODAY="${MARKER_LINE%% *}"; MARKER="${MARKER_LINE#* }"
   ```

   **Located absolutely; runs against the current repository.** cwd owns the `logs/` it writes, so each
   checkout keeps its own marker sequence and the call resolves from every consumer, not only
   `ai-resources`. If any step fails the script exits non-zero and `|| exit 1` stops the branch before the
   next write; re-running `/prime` recovers, at the cost of one burned marker number. Marker grammar, the
   header shape and the ordering rule live in the script beside the code they guard, with
   `logs/scripts/prime-allocator.test.sh` as the tripwire. **Never reinline this logic:** code inside an
   executable prompt is validated by reading rather than by running, which is the defect the extraction
   fixed. Canonical protocol: `docs/session-marker.md`.

8g. **Guards (shared sub-step — 8a / 8b / 8c).** Two, in this order, **before any write.**

   1. **Plan mode.** If a plan-mode system reminder is in context, write nothing — no marker, no header,
      no mtime — and output `{TASK_TEXT} noted. You're in plan mode — nothing written. Exit plan mode and
      re-send to proceed.` Then stop.
   2. **Cross-repo mission.** If the picked item is `[mission:<id>]`-sourced AND that mission's repo (from
      `ACTIVE_MISSIONS`, Step 1d) ≠ `CWD_REPO` (Step 1), STOP before any write and emit:

      > ⚠ This task belongs to mission `{id}`, which lives in `{repo}` — but you're priming in
      > `{CWD_REPO}`. Setting it up here would write the marker/header and run `/session-start` in the
      > *wrong* repo. Open `{repo}` as your session folder and re-run `/prime` there. (Reply `here` to
      > override and set it up in the current repo anyway.)

      Wait. On `here` proceed; on anything else stop, having written nothing. Same-repo picks skip
      silently. Derive the repo from `ACTIVE_MISSIONS`, never from 8m's later `MISSION_ID` — this guard
      must fire before 8h writes. In auto mode this is a **deliberate single-condition exception** to the
      one-gate contract; do not remove it as a stray prompt.

8a. **Numbered selection.** Resolve the number to its menu item → `TASK_TEXT`. Run 8g, then 8m, then 8h
   with `WORK_DESC = TASK_TEXT`. Dispatch: invoke `/session-start` with
   `"{gate:post-plan} {mission:<id>, if bound} TASK_TEXT"`. Then Step 9.

   **`{gate:post-plan}` is mandatory on this branch.** `/session-start` Step 1 captures it, Step 4
   forwards it (engineered) or branches on it (direct), and `/session-plan` Step 8 holds the pause and
   owns the `go` continuation. It is the *only* thing distinguishing a numbered pick from free-text on
   either route: omit it and the session begins executing a plan nobody approved
   (`logs/improvement-log.md` 2026-07-18). **8b must NOT pass it.**

8b. **Free-text intent.** Resolve the operator's stated work → `TASK_TEXT`, keeping any inline scope bound
   ("just the refactor, not the follow-up PRs"). Run 8g, then 8m, then 8h with `WORK_DESC = TASK_TEXT`.
   Dispatch: invoke `/session-start` with `"{mission:<id>, if bound} TASK_TEXT"`. Then Step 9.

   **Pass no `{gate:post-plan}` token.** Its absence is what lets this branch proceed without a second
   confirmation — the operator stating the work IS the go signal — and that is 8b's only structural
   difference from 8a. Adding the token here would convert 8b into 8a.

8c. **Auto mode.** Run one picked menu item end-to-end with a single approval gate and no per-stage
   prompts. **One item only.** 8c owns picking, the guards and dispatch; it does not derive, echo or write
   the mandate, the manifest or the plan.

   1. **Resolve `PICKED_ITEM`.** `auto` / `a` → item #1. `auto N`, or the equivalent `N auto` shape
      (`^[1-6]\s+auto$`, normalized by Step 7) → item #N. Validate N against the rendered menu range; out
      of range → ask once for a valid `auto` reply and re-classify (Step 7 ambiguity rule). Empty menu →
      `No tracked next steps — auto mode needs a task. Tell me what to work on.` and stop.

   2. **Done-condition presence-check.** Before any disk write, the picked item must carry an observable
      deliverable — a file written, an item checked off, a finding addressed, a commit landed, a count
      reached. The item text plus its source line is the evidence. An item naming only an activity
      ("review X", "look into Y", "think about Z") whose source line supplies no target **fails**: hold
      it, write nothing, and emit:

      > Auto mode — `{PICKED_ITEM_TEXT}` has no concrete done-condition, so I've held it.
      > Restate it with a deliverable (file / check / target), then re-send `auto`.

      Re-run this check against any restatement. If the operator does not restate, stop without writing.
      Rationale and the logged trigger: `docs/session-marker.md` § Auto-mode done-condition check.

   3. **Guards, write, bind.** Run 8g, then 8h with `WORK_DESC = PICKED_ITEM_TEXT`, then 8m in
      **auto-bind-only** mode — set `MISSION_ID` from a `[mission:<id>]` item without emitting the
      interactive prompt, because auto mode holds one gate. Then evaluate `DIRECT` once via the canonical
      predicate (`docs/session-marker.md` § Direct-route detection); if it cannot be evaluated for any
      reason treat it as `DIRECT=0` — fail-safe, meaning the plan file is written. **8h's three writes
      precede the approval gate by necessity and `abort` does not roll them back** — see 8c.9.

      *(Sub-steps 4–8 retired 2026-07-30 — the plan-mode and cross-repo guards moved to the shared 8g, the
      mandate composition to `/session-start`, and `STRUCTURAL_RISK` was deleted with `/risk-check`. The
      numbering gap is deliberate; retained identifiers keep their numbers.)*

   9. **Dispatch.** Invoke `/session-start` via the Skill tool with
      `args = "{gate:auto} {plan:overwrite} {mission:<id>, if bound} {MANDATE_TEXT}"`, where
      `MANDATE_TEXT` is the picked item's work plus its concrete deliverable and any bound it states.
      Under `{gate:auto}` that command suppresses its Step 2 echo and wait, runs Step 2.4 discovery and
      Step 2.5 validation in order, then holds **one** approval gate — on **every** engine outcome,
      including skipped and failed. On `go` it writes the mandate and the run-manifest stub and reaches
      `/session-plan`, which writes the plan and begins execution. `{plan:overwrite}` pre-answers
      `/session-plan` Step 0 so the chain does not stop to ask. On `abort` nothing further is written;
      the marker, header and mtime from 8h remain because they precede the gate — say so:
      `Auto mode aborted. No mandate, manifest or plan written — today's session header remains.`
      Then Step 9.

   10. **Direct route.** When `DIRECT=1`, `/session-start` Step 4 does not chain to `/session-plan` and no
      `logs/session-plan-*.md` is written; the mandate and run-manifest still are, and Step 4 becomes the
      terminal owner. The gate block at 8c.9 disclosed this.

      *(Sub-steps 11–13 retired 2026-07-30 — 11 with `STRUCTURAL_RISK`, 12 (execution start, posture,
      guardrail flags, between-item summaries, checkpoints) and 13 (the wrap reminder) to `/session-plan`
      § Post-plan execution, which every terminal path reaches; 13 previously sat on the auto route alone.)*

9. **Stop.** **`/prime` ends at dispatch.** Execution, the autonomy posture, the post-plan pause and its
   `go`, the guardrail flags, between-item summaries, compaction checkpoints and the wrap reminder all
   belong to `/session-start` Step 4 (direct route) and `/session-plan` Step 8 + § Post-plan execution
   (all routes). Do not begin work here, and do not chain into `/wrap-session`. The step is named so that
   "did `/prime` stop?" is an observation rather than an inference.
