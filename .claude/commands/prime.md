---
model: sonnet
---

Orient the session. Read state, brief the operator with a short task menu, wait for direction.

**Principle:** Prime never asserts state from a single source. Each surfaced next-step or status claim must be cross-checked against git log since the claim's source timestamp before being reported as current.

**Output + execution discipline:** The operator is a non-developer — the brief is short, scannable, plain English (short sentences, common words), and shows only what is needed to pick the next task; everything else stays silent unless it needs attention. Orientation issues many *independent* read-only git/file calls, so **batch them into one message**; firing them serially is the main avoidable latency. Safe to batch: **Step 1** (session-notes + the `usage-log` tail), **Step 1b**, and **Step 2**. **Three ordering dependencies must survive the batching — never hoist a dependent call ahead of what it needs:** (1) **Step 1a** needs `CWD_REPO`/`AI_RESOURCES` from Step 0 *and* the entry date from Step 1; (2) **Step 4**'s working-tree `git status` must run *after* Step 0's sync, so it sees post-pull state; (3) **Step 1c** needs Step 0 only — hoisted ahead of it, `CWD_REPO` is unresolved, the read silently misses and the brief block never renders. Step 1c does **not** depend on Step 1a — it deliberately does not consume that merged result set (wrongly scoped for plan position; see its ground-truth rule) — so those two may batch together once Step 0 has run. Everything else across steps 0–4 is independent and should be batched.

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

1. Read the last entry from `/logs/session-notes.md`. Extract: date, summary, next steps, open questions.
   If the file doesn't exist or is empty, this is the first session — note that and skip to step 2.

   **Read method (deterministic — do not improvise against same-day clutter).** Locate the last entry's
   date-header with `Bash(grep -n "^## [0-9]" logs/session-notes.md | tail -1)` → `START`, then read
   header-to-EOF in one call: `Read(logs/session-notes.md, offset=START)`. **Never substitute a fixed
   last-N-lines window.** Why the `^## [0-9]` anchor and the offset read take these shapes:
   `docs/heavy-read-discipline.md` § Bounded-read recipes → Step 1.

   **Telemetry-gap nudge.** Read the tail of the telemetry log — `Bash(tail -n 30 logs/usage-log.md)`, skipped silently if absent. Take the date of the most recent `## ` header in `session-notes.md` (the last wrapped session). If that date does **not** appear in those 30 lines, AND that last session was non-trivial (its note carries a real `### Summary`, not a one-line or aborted entry), then the prior substantive session captured no telemetry — set a telemetry-gap flag and emit the ⚠ telemetry line in the brief (Step 6 template). Skip silently if either file is absent, the dates match, or the last session was trivial. Advisory only — it never blocks; it prompts a backfill.

1a. **Cross-check Next Steps against git log and sibling entries.** Detection logic only — this command has no brief-level Next Steps list; see steps 5–6.

   *Canonical primitive.* The merged multi-repo git cross-check below is the **reference implementation** of the reconcile-at-read primitive documented in `docs/backlog-reconciliation.md` (shared by `/fix-project-issues`, `/fix-repo-issues`, `/open-items`). The mechanism here and the doc must stay in sync — if you change the scan or classification logic in one, update the other. That doc also holds this scan's rationale: the dual-repo blindspot, the sibling-repo extension, the cost note and the fall-through posture.

   *Git cross-check:* Parse the `## YYYY-MM-DD` header date from the source entry, then run
   `git -C "$CWD_REPO" log --since="<entry-date>T00:00:00" --pretty="%h %s" --all 2>/dev/null`.

   If `$CWD_REPO` differs from `$AI_RESOURCES` (the variable established in Step 0), ALSO run
   `git -C "$AI_RESOURCES" log --since="<entry-date>T00:00:00" --pretty="%h %s" --all 2>/dev/null`
   and merge the two result sets before the keyword-match pass below. Then extend the merge to the active sibling project repos — a Next Step is frequently resolved by a commit that landed in another project repo, which a cwd-only or dual-repo scan would surface as still-open:

   ```bash
   WORKSPACE_ROOT="$(dirname "$AI_RESOURCES")"
   for d in "$WORKSPACE_ROOT"/projects/*/; do
     repo="$(git -C "$d" rev-parse --show-toplevel 2>/dev/null)" || continue   # skip non-repos
     [ "$repo" = "$CWD_REPO" ] && continue                                     # already scanned above
     [ "$repo" = "$AI_RESOURCES" ] && continue                                 # already scanned above
     git -C "$repo" log --since="<entry-date>T00:00:00" --pretty="%h %s" --all 2>/dev/null
   done
   ```

   For each Next Steps bullet, check if any commit subject across the merged result set contains keywords from that bullet. Classify the bullet:
   - **Match found → likely-DONE.** Do NOT promote it into the numbered menu (step 5) — the menu must not spend slots on probably-finished work.
   - **No match → still open.** It becomes a carryover/menu candidate for step 5.

   `/prime` never edits `session-notes.md`, so every Next Step bullet stays untouched in the source file — the operator can verify there directly if a likely-DONE call looks wrong. If either git command fails or returns nothing, fall through to whichever result set succeeded; if both fail, treat all bullets as still-open and continue.

   *Sibling-entry note.* Multiple same-day marker-bearing headers are the EXPECTED shape — **do NOT emit a `⚠` for them.** Count them with `TODAY=$(date '+%Y-%m-%d')` and `SIBLING_COUNT=$(grep -c "^## ${TODAY}" logs/session-notes.md 2>/dev/null || echo 0)`. `SIBLING_COUNT` is consumed only as a gate — for the shared-dir advisory below and the liveness nudge after it — never as its own Step 6 display line.

   *Concurrent-detected shared-dir advisory.* When `SIBLING_COUNT > 1`, run one **read-only** check (no `git add`, no write) over the two surfaces no other guard watches — shared command/doc files, and the **non-append** shared logs:

   ```bash
   FOREIGN_SHARED=$(git status --short -- .claude/commands docs logs/improvement-log.md logs/improvement-log-archive.md logs/decisions.md 2>/dev/null)
   ```

   `logs/session-notes.md` is deliberately absent from that pathspec. If `FOREIGN_SHARED` is non-empty, carry the dirty paths to Step 6 as an exception line naming the foreign-dirty shared files/logs — a concurrent session may be mid-edit on them, so editing them this session risks a lost update. If `SIBLING_COUNT ≤ 1` or the check returns nothing, skip silently (no line). The advisory only *names* the surface; it does not block.

   *Live-foreign-session check → `/concurrent-session-check` nudge.* `SIBLING_COUNT` counts same-day *headers* and cannot tell a live session from one that already wrapped, so the nudge uses the per-id marker set instead. `/prime` writes this session's own per-id marker only at Step 8 (after orientation), so at Step 1a time **every** today-dated `logs/.session-marker-*` other than this session's own is a foreign session that primed in this checkout today and has not torn down. Run one **read-only** scan:

   ```bash
   # LIVE_FOREIGN_HERE — count of un-wrapped foreign sessions in THIS checkout (same signal as detect-concurrent-session.sh).
   LIVE_FOREIGN_HERE=0
   if [ -n "${CLAUDE_CODE_SESSION_ID}" ]; then
     SELF_MARKER="logs/.session-marker-${CLAUDE_CODE_SESSION_ID}"
     for f in logs/.session-marker-*; do
       [ -f "$f" ] || continue                       # glob matched nothing → no per-id markers
       [ "$f" = "$SELF_MARKER" ] && continue          # exclude this session's own (defensive — not yet written at orientation)
       c=$(cat "$f" 2>/dev/null)
       [ "${c%% *}" = "$TODAY" ] && LIVE_FOREIGN_HERE=$((LIVE_FOREIGN_HERE + 1))
     done
   fi
   ```

   If `CLAUDE_CODE_SESSION_ID` is unset (old CLI), leave `LIVE_FOREIGN_HERE=0` and skip the nudge silently — degrade safe. If `LIVE_FOREIGN_HERE >= 1`, carry it to Step 6, which emits the `/concurrent-session-check` nudge line. Never blocks. Why these three signals differ, why `logs/session-notes.md` is excluded above, and why the SessionStart hook rather than this step is the authority on liveness: `docs/session-marker.md` § Concurrent-session detection.

1b. **Detect a resumable continuity scratchpad.** `/handoff` continuity mode and `/wrap-session` Step 0.5 both write session-state scratchpads to `logs/scratchpads/`. Surface the most recent one so the operator can choose to resume it.

   - List `logs/scratchpads/` for files matching the glob `*-scratchpad.md` **exactly** — this excludes other files that may share the directory (e.g., `*-implementation-plan.md`).
   - Select the most recent by **filesystem mtime** (`ls -t` over the matches). Do NOT sort by the `YYYY-MM-DD-HH-MM` timestamp in the filename: it is typed by the AI session that wrote the scratchpad and skews 2–3 hours, so lexical filename order does NOT track chronological order. `logs/scratchpads/` is gitignored, so mtime always reflects the real local write time.
   - Compare the selected scratchpad's mtime date to the date of the last `session-notes.md` entry from Step 1. **≥** → surface it: read its `## Resume With` section and take the first content line. **<** → a later wrap superseded it; skip silently.
   - If `logs/scratchpads/` is absent or has no `*-scratchpad.md` file, skip silently.
   - When surfaced, the scratchpad feeds a **carryover** menu candidate: the first content line of its `## Resume With` section is a strong candidate for menu item 1 (step 5). It has no standalone Step 6 display line. This step does NOT auto-resume — the operator decides by picking that menu item or answering the direction prompt.

1c. **Read the project's plan position.** Detect where the project actually stands against its plan, so the brief can lead with *where we are and what is next* rather than only a backlog menu. This step is a **zero-cost no-op in any repo without a plan** — including `ai-resources` itself, which has no `pipeline/` — and adds no reads, no line, and no menu item there.

   *Cascade source.* This reuses the detection cascade in `.claude/commands/project-next-steps.md` (Step 2), which derives from `skills/session-guide-generator/SKILL.md` Step 2 — with one deliberate divergence: **position is checked before the plan spine.** That inversion is intentional; do not "correct" it back. Its reasoning, and why every read below is bounded: `docs/heavy-read-discipline.md` § Bounded-read recipes → Step 1c.

   Detect in this order and **stop as soon as position is confident**:

   1. `$CWD_REPO/pipeline/pipeline-state.md` — if present, read it. Its stage table states position directly. This is the common case — 19 project repos carry this file as of 2026-07-19, the large majority.
   2. Otherwise, the plan spine — first that exists: `pipeline/project-plan.md`, a `plan/` directory at the project root, phase/workflow definitions in the project `CLAUDE.md`, the latest `logs/session-plan*.md`.
   3. Neither exists → **skip silently.** No `PROJECT_POSITION`, no brief block, no cost.

   **Resolve the spine to exactly one `<plan-file>` before going further** — two of the four options are not single files, and the read recipe below is undefined for them. `pipeline/project-plan.md` or `logs/session-plan*.md` → already a file (for the glob, most recent by mtime, the `ls -t` rule Step 1b uses). A `plan/` **directory** → the lowest-numbered / lexically-first `*.md` inside it still carrying an incomplete marker; do not read the directory's other files. Project **`CLAUDE.md`** → `<plan-file>` is `CLAUDE.md` itself, with the grep scoped to its phase/workflow section rather than the whole file. If the spine resolves to nothing readable, treat it as case 3 and skip silently — do **not** read several candidates "to be sure".

   **Bounded read — NEVER a full read of the plan file, and a later edit that "simplifies" this into a plain `Read` is a regression.** Grep for stage/phase headers and completion markers with `Bash(grep -nE "^#{2,3} +(Stage|Phase|W[0-9])|^- \[[ x]\]|✅|\*\*(complete|done)\*\*" <plan-file> | head -n 40)`, then read only a bounded slice around the first incomplete one: `Read(<plan-file>, offset=<first incomplete marker>, limit=40)`. If the grep returns **stage/phase headers but no completion markers at all** — a real and common shape — anchor the slice on the **last** header instead, as the furthest-along section, and say the position is inferred from plan structure rather than from an explicit completion marker. If the grep returns nothing at all, skip silently per case 3. Do not improvise a wider read to find markers that are not there.

   **Ground truth — Step 1a's merged result set is deliberately NOT reused by either path.** Its `--since` window is anchored to the last session-notes entry date: right for adjudicating last session's Next Steps, and **too narrow for plan position**, where a step completed weeks ago falls outside it and would read as still-pending.
   - **Path 1 (`pipeline-state.md` present):** trust the file as-is and issue **no git call at all.** It is a maintained completion signal, not an inference, and Step 1a's set merges commits from `$AI_RESOURCES` and every sibling repo into one unattributed list — so an unrelated project's commit would read as movement on this project's stage.
   - **Path 2 (plan-marker fallback):** resolve the plan file's own last-modified date with `Bash(date -r <plan-file> +%F 2>/dev/null)` (a filesystem stat, not a git call), then issue **exactly one** git call scoped to `$CWD_REPO`: `Bash(git -C "$CWD_REPO" log --since=<that date> --pretty="%h %s" 2>/dev/null)`. Check whether the first incomplete marker already appears done in those commit subjects. **One git call is the ceiling** — do not fan out across sibling repos the way Step 1a does. If `date -r` fails, skip the corroboration and report the marker as-is.

   **Readiness verdict.** Derive from the plan position plus the open questions already extracted from `session-notes.md` in Step 1 — both are in context, so this costs nothing extra. Emit a verdict plus one short reason. Keep it to that: the full four-point OK/GAP readiness check belongs to `/project-next-steps`, not here.

   Set `PROJECT_POSITION` = `{where_we_are, status, next_action}`, each **one short plain-English sentence** per the Step 5 conversion rules, and carry it to Step 6. If detection reached case 3 above (no plan, no state), leave `PROJECT_POSITION` unset and carry nothing.

1d. **Scan active missions (mission-contract subsystem).** A *mission* is a multi-session goal owned by `/mission`; a session binds to one so `/drift-check` can measure its trajectory against the mission's validation contract. **Zero-cost no-op when none exist** — with no `logs/missions/` dir in any enumerated repo this step adds no prompt, no menu item and no brief line. Reuse the Step 1a repo enumeration (`CWD_REPO`, `AI_RESOURCES`, sibling `projects/*/` repos — already de-duped there), and scan **`<repo>/logs/missions/*.md` only — never `<repo>/logs/missions/archive/`**, so closed missions cannot reappear and the scan stays bounded as missions accumulate:

   ```bash
   WORKSPACE_ROOT="$(dirname "$AI_RESOURCES")"   # same derivation as Step 1a
   for repo in "$CWD_REPO" "$AI_RESOURCES" "$WORKSPACE_ROOT"/projects/*/; do
     [ -d "$repo/logs/missions" ] || continue
     for m in "$repo"/logs/missions/*.md; do
       [ -f "$m" ] || continue
       grep -q '^status: active' "$m" || continue   # active only
     done
   done
   ```

   From each matched file capture the `mission_id` and `mission_name` frontmatter, the owning repo, and the unchecked `- [ ]` lines under `## Open threads`. Build `ACTIVE_MISSIONS` = list of `{id, name, repo, open_threads[]}`. If the list is empty, set a flag and skip every mission-related addition below (the common case). Carry `ACTIVE_MISSIONS` to Step 5 (menu candidates), Step 6 (brief), and the Step 8 binding sub-step.

2. **Read `next-up.md`.** Read `logs/next-up.md` if it exists and collect every unchecked checkbox item (`- [ ]` lines) as a menu candidate for step 5. This is now the **only** channel by which a severity-tagged finding reaches the menu — `logs/scripts/promote-findings.sh` fills the queue at wrap. An absent or empty file is normal, not an error: skip silently, and the menu falls back to step 1a's still-open Next Steps.

   *(Step 3 — the bounded urgent-log scan — was retired 2026-07-30. Orientation no longer greps the backlog: promotion is a write, orientation is a read, and the scan re-ran at every `/prime` in every project to re-derive a set that changes only when a finding is written. The severity contract it carried, including the `medium-high` menu-reach tier that must not be narrowed alone, moved to `logs/scripts/promote-findings.sh` with it. Record: `logs/decisions.md`, 2026-07-30. The numbering gap is deliberate.)*

4. **Exception checks.** Compute the following, but carry each to step 6 only when it is abnormal — a normal value is never displayed.
   - **Working tree:** if the environment's git-status snapshot is non-empty, run `git status --short` and `git diff --stat HEAD` once to confirm it is still current. The env snapshot is point-in-time from session start and can be stale vs actual HEAD (e.g., files already committed in the prior session). Carry forward only if the live result shows unexpected uncommitted changes. This is a Prime-time orientation check, distinct from the commit-time "no pre-commit git status" rule.
   - **Sync result:** carry forward a `SYNC` line from Step 0 only on a `failed:` result, when it carries an unpushed clause, or on `autostash-conflict`. The `autostash-conflict` case is the highest-priority exception: the working tree silently holds conflict markers, so the brief must say so.
   - **Phase READMEs.** If the cwd-rooted project has a `work/` directory, scan it (one level deep) for files matching `W*-*-README.md` (or `Wn-*-README.md`). Capture the matching file paths only — do not read file bodies. Skip silently if `work/` is absent or contains no matches. Bounded scan: one `ls`/`find -maxdepth 2`-equivalent; do not recurse deeper.

5. **Build the numbered task menu.** Merge candidates from:
   - Step 1a — still-open Next Steps from the last session → tag `[carryover]`.
   - Step 1b — the scratchpad `## Resume With` line, if any → tag `[carryover]`.
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
{⚠ Concurrent session may be editing shared files: {foreign-dirty paths under .claude/commands / docs / the non-append logs improvement-log.md / improvement-log-archive.md / decisions.md}; check before editing them — only when SIBLING_COUNT > 1 and the Step 1a read-only `git status` found foreign-dirty shared files/logs}
{⚠ Concurrent session live in this checkout — before starting a task, run `/concurrent-session-check <task>` to confirm it won't collide, or `/concurrent-session-check` (no argument) to see which menu items are safe. — only when Step 1a found LIVE_FOREIGN_HERE >= 1}
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
