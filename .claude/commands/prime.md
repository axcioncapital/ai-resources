---
model: sonnet
---

Orient the session. Read state, brief the operator with a short task menu, wait for direction.

**Principle:** Prime never asserts state from a single source. Each surfaced next-step or status claim must be cross-checked against git log since the claim's source timestamp before being reported as current.

**Output + execution discipline:** The operator is a non-developer — the brief is short, scannable, plain English (short sentences, common words), and shows only what is needed to pick the next task; everything else stays silent unless it needs attention. Orientation's reads are now **two script calls** — Step 0's sync and Step 1's collector — plus Step 4's exception checks. **Batch Steps 0 and 1 into one message**; firing them serially is the main avoidable latency, and the collector resolves its own repo root, so it does not wait on the sync. **One ordering dependency must survive the batching:** Step 4's working-tree `git status` runs *after* Step 0's sync, so it sees post-pull state. Steps 1a–1d, 2 and 5 read `STATE` and issue no calls of their own — a step that finds itself running a `git log`, a `grep` over a log file or a directory listing has re-implemented the collector and should be corrected, not extended.

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

8m. **Mission binding (shared sub-step — referenced by 8a / 8b / 8c).** Resolves which active mission, if any, this session serves. **Skip entirely — no prompt, no output — when `ACTIVE_MISSIONS` (Step 1d) is empty** (the common case). Run only after a non-plan-mode dispatch is confirmed (i.e., past each branch's plan-mode guard), and before the branch calls `/session-start` (8a/8b) or writes the inline mandate (8c). Resolve `MISSION_ID`:
   - If the picked/stated task came from a `[mission:<id>]` menu item → `MISSION_ID = <id>`. **Auto-bound; no prompt.** (Primary path — picking a mission's open thread IS the binding.)
   - Else, emit exactly one line: `This session serves which active mission? {[1] <id> — <name> … [N] …} — or 'none'.` Parse the reply: a number → that mission's id; `none` / empty / anything else → no mission. One prompt only; default is `none`.
   - Carry `MISSION_ID` forward. If unset/`none`, the session has no mission bullet and everything downstream proceeds exactly as today.

   **Wiring:** all three branches prepend `{mission:<id>}` to the args passed to `/session-start`, which strips it and writes the `- Mission: <id>` bullet (see `session-start.md` Step 1). 8c does this at its Step 8c.9 dispatch, alongside `{gate:auto}` and `{plan:overwrite}`; it no longer writes the bullet itself. When `MISSION_ID` is unset, none of this happens.

   **Cross-repo note:** the pre-write cross-repo mission guard (Steps 8a sub-step a0, 8c sub-step 2.5) fires *before* this binding, deriving the picked mission's repo from `ACTIVE_MISSIONS` (Step 1d), not from `MISSION_ID` here — so a wrong-repo pick is caught before any marker/header write. Do not move Step 8m earlier to "cover" that case; the guard already does, and 8m must stay after the write per the marker contract. (8b/free-text needs no guard — there is no `[mission:<id>]` menu item to mis-pick.)

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

8a. **Task selected by number.**
   1. Resolve the number to its menu item → `TASK_TEXT` (the plain-English task text).
   2. **Plan-mode guard.** If a plan-mode system reminder is present in context (plan mode is active), do NOT run `/session-start` or `/session-plan`, and do NOT write anything. Output:
      > Task {N} noted: {TASK_TEXT}. You're in plan mode — I won't run `/session-start` yet. Exit plan mode when you're ready to execute, then re-send `{N}` (or say `go`) and I'll run `/session-start` and `/session-plan` for this task.

      Then stop.
   3. If plan mode is **not** active:
      a0. **Cross-repo mission guard.** If the picked item is `[mission:<id>]`-sourced AND that mission's repo (from `ACTIVE_MISSIONS`, Step 1d) ≠ `CWD_REPO` (Step 0), STOP before any write and emit:
         > ⚠ This task belongs to mission `{id}`, which lives in `{repo}` — but you're priming in `{CWD_REPO}`. Setting it up here would write the marker/header and run `/session-start` in the *wrong* repo. Open `{repo}` as your session folder and re-run `/prime` there to work on this mission. (Reply `here` to override and set it up in the current repo anyway.)

         Wait for the operator. On `here` → proceed to sub-step a. On anything else → stop, write nothing. A same-repo pick (mission repo == `CWD_REPO`) skips this guard silently. Derive the repo from `ACTIVE_MISSIONS` here, not from Step 8m's later `MISSION_ID` — this guard must fire before the sub-step-a marker/header write.
      a. **Session-entry write.** Run the **Step 8h shared sub-step** with `WORK_DESC = TASK_TEXT`. It allocates the marker, appends this session's marker-bearing header, and stamps `logs/.prime-mtime`, in that order. This must happen before step c — `/session-start` Step 3 and `/session-plan` Step 0 both require THIS session's marker-bearing header to exist.
      a2. **Mission binding.** Run the Step 8m sub-step (skips silently if no active missions). If it resolves a `MISSION_ID`, prepend `{mission:<id>}` to the `/session-start` args in step b.
      b. Invoke the `/session-start` command with `TASK_TEXT` as its arguments (becomes the mandate), prefixed with **`{gate:post-plan}`** — always, on this branch — and additionally with `{mission:<id>}` if step a2 bound one. It runs its own mandate-confirmation prompt — that is expected; do not suppress it.

         **The `{gate:post-plan}` token is what makes step d's pause survive the chain**, and it is mandatory on 8a. `/session-start` Step 1 strips and captures it, Step 4 forwards it to `/session-plan`, and `/session-plan` Step 8 branches on it to hand control back here instead of auto-executing. Omitting it silently reverts to the pre-2026-07-18 defect: `/session-plan`'s auto-proceed instruction is the freshest one at the decision point and wins over step d below, so the session begins executing a plan the operator has never approved. **8b must NOT pass this token** — see 8b.3.d. Source: `logs/improvement-log.md` 2026-07-18.
      c. After `/session-start` finishes, invoke the `/session-plan` command with `TASK_TEXT` as its arguments (becomes the intent). It writes `logs/session-plan-${TODAY}-${MARKER}.md` (marker-scoped per `docs/session-marker.md`). If THIS session's marker-scoped plan already exists, `/session-plan` Step 0 surfaces a 3-option keep/overwrite/pass2 prompt — that is expected mid-chain; the operator answers it normally.

         **Note on the real call path:** `/session-start` Step 4 already chain-invokes `/session-plan`, so in practice the chain reaches it there and this sub-step is satisfied by that hop. Either way the gate token travels with it.

         **Direct-route branch (Commit 2, 2026-07-23).** For a direct-route project (`DIRECT=1` via the canonical predicate, `docs/session-marker.md` § Direct-route detection), `/session-start` Step 4 **skips** this chain — no `/session-plan` is invoked and **no plan file is written.** This sub-step c is a no-op on the direct route; go straight to step d's direct branch.
      d. **Pause.** After `/session-plan` finishes (engineered) or after `/session-start` returns (direct), output the review prompt:

         **Engineered route (`DIRECT=0`, plan file written):**
         > Plan ready — review `logs/session-plan-${TODAY}-${MARKER}.md`. Reply `go` to start execution.

         **Direct route (`DIRECT=1`, no plan file):** there is no plan file to review. Output instead:
         > Mandate written — review it in `logs/session-notes.md` (this session's `## ${TODAY} — Session ${MARKER}` block). Reply `go` to start execution, or run `/session-plan` first if you want a durable plan.

         Wait for the operator either way. Do NOT begin execution on your own.

         As of 2026-07-18 this pause is **also carried mechanically** by the `{gate:post-plan}` token from step b (engineered route), so it no longer depends on this instruction being recalled at a decision point many turns downstream. If a future edit removes the token, this sentence alone will not hold the gate — that is precisely the failure the token was added to fix. On the direct route no plan exists to gate, so the pause is this sub-step's own lean go-prompt above.

8b. **Free-text intent.** The operator named the work directly instead of picking a number.
   1. Resolve the operator's stated work → `TASK_TEXT` (the work description, including any inline scope boundary like "just the refactor, not the follow-up PRs").
   2. **Plan-mode guard.** If a plan-mode system reminder is present in context (plan mode is active), do NOT run `/session-start` or `/session-plan`, and do NOT write anything. Output:
      > Free-text task noted: {TASK_TEXT}. You're in plan mode — I won't run `/session-start` yet. Exit plan mode when you're ready to execute, then re-send the task (or say `go`) and I'll run `/session-start` and `/session-plan` for it.

      Then stop.
   3. If plan mode is **not** active:
      a. **Session-entry write.** Run the **Step 8h shared sub-step** with `WORK_DESC = TASK_TEXT`.
      a2. **Mission binding.** Run the Step 8m sub-step (skips silently if no active missions). If it resolves a `MISSION_ID`, prepend `{mission:<id>}` to the `/session-start` args in step b.
      b. Invoke the `/session-start` command with `TASK_TEXT` as its arguments (becomes the mandate), prefixed with `{mission:<id>}` if step a2 bound one. It runs its own mandate-confirmation prompt — that is expected; do not suppress it.
      c. After `/session-start` finishes, invoke the `/session-plan` command with `TASK_TEXT` as its arguments (becomes the intent). It writes `logs/session-plan-${TODAY}-${MARKER}.md` (marker-scoped per `docs/session-marker.md`). If THIS session's marker-scoped plan already exists, `/session-plan` Step 0 surfaces a 3-option keep/overwrite/pass2 prompt — that is expected mid-chain; the operator answers it normally.

         **Direct-route branch (Commit 2, 2026-07-23).** For a direct-route project (`DIRECT=1`, `docs/session-marker.md` § Direct-route detection), `/session-start` Step 4 **skips** the `/session-plan` chain — no plan file is written. This sub-step c is a no-op on the direct route; go straight to step d (which begins execution regardless).
      d. **Begin execution immediately** under full autonomy (per workspace CLAUDE.md Autonomy Rules). No second `go`/`proceed` confirmation required — the operator stating the work directly IS the go signal. This is 8b's structural delta vs 8a, which pauses for explicit `go` after `/session-plan`. (On the direct route the only difference is that no plan artifact exists — execution still begins immediately.)

         **8b passes no `{gate:post-plan}` token** (contrast 8a.3.b). That absence is what preserves this branch's auto-execute behaviour: `/session-plan` Step 8 treats an unset gate as the default and proceeds. Adding the token here would convert 8b into 8a and introduce a pause the operator has not asked for.

8c. **Auto mode.** The operator typed `auto` (optionally with an item number) — run the picked menu item end-to-end with a single approval gate and no per-stage prompts. **One item only.** **8c owns picking, the guards and dispatch. It does not derive, echo or write the mandate, the manifest or the plan** — `/session-start` and `/session-plan` own those, and 8c reaches them by invoking `/session-start` under `{gate:auto}`.

   1. **Resolve `PICKED_ITEM`.** Parse the operator's reply:
      - `auto` / `a` (no number) → item #1 from the menu built in Step 5.
      - `auto N` — or the equivalent `N auto` shape (`^[1-6]\s+auto$`, normalized by Step 7) → item #N.

      Validate that the requested number is within the rendered menu range. If it is out of range, ask once for a valid `auto` reply and re-classify (per Step 7 ambiguity rule). If the menu has zero items, output `No tracked next steps — auto mode needs a task. Tell me what to work on.` and stop. `PICKED_ITEM_TEXT` is the picked item's text.

   2. **Done-condition presence-check.** Before any disk write, verify the picked item carries a derivable done-condition — an observable deliverable, check or target (file written, item checked off, finding addressed, commit landed, count reached). The item text plus its source line is the evidence. An item naming only an activity with no observable end-state ("review X", "look into Y", "think about Z") whose source line supplies no target **fails**. Rationale and the logged trigger: `docs/session-marker.md` § Auto-mode done-condition check.

      It passes → continue to 8c.3. It fails → hold it, write nothing, and emit:

      > Auto mode — `{PICKED_ITEM_TEXT}` has no concrete done-condition, so I've held it.
      > Restate it with a deliverable (file / check / target), then re-send `auto`.

      On a restated item → re-run this check against the restatement. If the operator does not restate, stop without writing.

   3. **Plan-mode guard.** If a plan-mode system reminder is present in context, output `Auto mode noted: {PICKED_ITEM_TEXT}. You're in plan mode — I won't write anything yet. Exit plan mode and re-send 'auto' (or 'go') to proceed.` Then stop.

   4. **Cross-repo mission guard.** If the picked item is `[mission:<id>]`-sourced AND that mission's repo (from `ACTIVE_MISSIONS`, Step 1d) ≠ `CWD_REPO` (Step 0), STOP and emit the same wrong-repo warning as Step 8a's cross-repo guard, naming the item and its repo. Wait; on `here` → continue to 8c.5; on anything else → stop, write nothing. This is a **deliberate single-condition exception** to auto mode's "single approval gate, no per-stage prompts" contract (it fires ONLY when the picked mission's repo ≠ `CWD_REPO`) — do not remove it as a stray prompt. It is load-bearing precisely because the 8c.5 header write precedes the approval gate, so this is the only point that stops a wrong-repo header before disk. Derive the repo from `ACTIVE_MISSIONS`, not from the 8c.6 auto-bind (which runs after the write). Same-repo picks skip it silently.

   5. **Session-entry write.** Run the **Step 8h shared sub-step** with `WORK_DESC = PICKED_ITEM_TEXT`.

      **These three writes precede the approval gate by necessity, and `abort` does not roll them back** — see 8c.9.

   6. **Mission auto-bind, then route.** Run the **Step 8m** sub-step in auto-bind-only mode: if the picked item is `[mission:<id>]`-sourced, set `MISSION_ID` to that mission. **Do not emit the interactive binding prompt** — auto mode's contract is one approval gate with no per-stage prompts. If the picked item is not mission-sourced, `MISSION_ID` stays unset. Then evaluate `DIRECT` once via the canonical predicate (`docs/session-marker.md` § Direct-route detection). If it cannot be evaluated for any reason, treat it as `DIRECT=0` — fail-safe, meaning the plan file is written.

   7. **Compose `MANDATE_TEXT`.** Build the single string `/session-start` Step 2 will parse: the picked item's work and its concrete deliverable, plus any bound the item states. **8c does not derive the individual mandate fields and does not echo them.**

      *(Sub-step 8 retired 2026-07-30 — `STRUCTURAL_RISK` derivation. The numbering gap is deliberate; retained identifiers keep their numbers.)*

   9. **Dispatch to `/session-start`, which holds the approval gate.** Invoke it via the Skill tool with `args = "{gate:auto} {plan:overwrite} {mission:<MISSION_ID>, only if bound} {MANDATE_TEXT}"`. Under `{gate:auto}` that command suppresses its Step 2 echo and wait, runs Step 2.4 discovery and Step 2.5 validation in their existing order, then holds **one** approval gate — on **every** engine outcome, including skipped and failed — and on `go` writes the mandate (its Step 3), the run-manifest stub (3.5) and the plan (via `/session-plan`), returning here **without beginning execution**. `{plan:overwrite}` pre-selects `/session-plan` Step 0's overwrite option so the chain does not stop to ask.

      **On `abort` nothing further is written and control returns here.** The marker, header and mtime written at 8c.5 remain, because they precede the gate. Output `Auto mode aborted. No mandate, manifest or plan written — today's session header remains.` and stop.

   10. **Direct route.** When `DIRECT=1`, `/session-start` Step 4 does not chain to `/session-plan` and no `logs/session-plan-*.md` is written; the mandate and run-manifest still are. The gate block at 8c.9 disclosed this.

      *(Sub-step 11 retired 2026-07-30 — the `STRUCTURAL_RISK` review-sizing disclosure went with the field it read. A structural class still makes the change high-consequence; that is carried inside the review sizing, `ai-resources/docs/qc-independence.md` § The rule.)*

   12. **Begin execution under the autonomy posture `/session-plan` set.** No further confirmation gate — the 8c.9 approval covered execution. Complete the mandate fully within this session where context allows; if context is clearly constrained, follow the workspace `Context constraint deferral` rule — flag the deferral and log it, do not rush. During execution: size the independent review to the change per `ai-resources/docs/qc-independence.md` (no review fires automatically), follow `ai-resources/docs/compaction-protocol.md` checkpoints on long work, surface `[SCOPE]` / `[HEAVY]` / `[AMBIGUOUS]` / `[COST]` guardrail flags, and commit directly per the workspace `Commit behavior` rule.

   13. **On mandate completion.** Output `Mandate complete. Run /wrap-session to capture telemetry and journal the session. Push pending — let me know when to push.` Do not auto-invoke `/wrap-session` — the operator decides when to wrap.
