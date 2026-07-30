---
model: sonnet
---

Orient the session. Read state, brief the operator with a short task menu, wait for direction.

**Principle:** Prime never asserts state from a single source. Each surfaced next-step or status claim must be cross-checked against git log since the claim's source timestamp before being reported as current.

**Output + execution discipline:** The operator is a non-developer — the brief is short, scannable, plain English (short sentences, common words), and shows only what is needed to pick the next task; everything else stays silent unless it needs attention. Orientation issues many *independent* read-only git/file calls, so **batch them into one message**; firing them serially is the main avoidable latency. Safe to batch: **Step 1** (session-notes + log-trio), **Step 1b**, **Step 2**, **Step 3**, and **Step 0**'s per-repo `pull`. **Three ordering dependencies must survive the batching — never hoist a dependent call ahead of what it needs:** (1) **Step 1a** needs `CWD_REPO`/`AI_RESOURCES` from Step 0 *and* the entry date from Step 1; (2) **Step 4**'s working-tree `git status` must run *after* the Step 0 pulls, so it sees post-pull state; (3) **Step 1c** needs Step 0 only — hoisted ahead of it, `CWD_REPO` is unresolved, the read silently misses and the brief block never renders. Step 1c does **not** depend on Step 1a — it deliberately does not consume that merged result set (wrongly scoped for plan position; see its ground-truth rule) — so those two may batch together once Step 0 has run. Everything else across steps 0–4 is independent and should be batched.

0. **Pull latest.** Determine the cwd's git root: `CWD_REPO=$(git -C "$(pwd)" rev-parse --show-toplevel 2>/dev/null)`.
   If this fails, note `Pulled: n/a (not a git repo)` and skip to step 1. Define
   `AI_RESOURCES="/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources"`.

   **BEHIND-CHECK FIRST — do not pull a repo that has nothing to pull.** For each repo, fetch and ask
   how far behind it is *before* running any rebase:

   ```bash
   GIT_TERMINAL_PROMPT=0 git -C "$REPO" fetch --quiet 2>/dev/null
   BEHIND=$(git -C "$REPO" rev-list --count HEAD..@{u} 2>/dev/null || echo "")
   ```

   - `BEHIND` = `0` → **skip the pull entirely.** Record `up to date`. **Do not run `pull --rebase`.**
   - `BEHIND` empty (no upstream / detached HEAD) → record `skip (no upstream configured)`; no pull.
   - `BEHIND` ≥ 1 → run the pull below.

   This guard is **not** an optimisation — it removes an incident class (2026-07-14 S5 → fixed S8).
   Why, and why the other three shapes below are what they are: `docs/commit-discipline.md` § Orientation pull.

   Run `GIT_TERMINAL_PROMPT=0 git -C "$CWD_REPO" pull --rebase --autostash`. If `$CWD_REPO` differs
   from `$AI_RESOURCES`, also run `GIT_TERMINAL_PROMPT=0 git -C "$AI_RESOURCES" pull --rebase --autostash`.
   Both flags stay explicit, never left to per-machine config. Capture each result:
   - **Rebase conflicted mid-flight.** If the pull leaves the repo mid-rebase (`git -C "$REPO" rev-parse
     --verify -q REBASE_HEAD` succeeds, or `git -C "$REPO" status` reports `rebase in progress`), **do not
     attempt to resolve it and do not stop the session** — restore the repo and keep orienting:
     ```bash
     git -C "$REPO" rebase --abort 2>/dev/null
     ```
     Record `failed: rebase conflicted — aborted, repo restored; local history unchanged` and carry it to
     the Step 6 brief as a ⚠ line. Orientation continues on the pre-pull state. **A failed pull must never
     leave the operator in a half-rebased repo at the moment they are trying to start work.**
   - **Autostash pop conflict — detect FIRST, before the exit-code cases below.** With `--autostash`, the history rebase can succeed (exit 0) while the *pop* of the stashed dirty tree conflicts, so the exit-code cases below would mislabel it `updated`. Detect via any of three signals (OR — git's wording is not a stable interface): the captured pull output contains `Applying autostash resulted in conflicts`; OR `git -C "$REPO" stash list` shows a residual `autostash` entry; OR `git -C "$REPO" status --short` shows a conflicted (`UU`) path. If any fires → `autostash-conflict` (working tree carries conflict markers; `stash@{0}` preserved). Classify this BEFORE the two exit-0 cases.
   - Exit 0 + "Already up to date." → `up to date`
   - Exit 0, no "Already up to date." → `updated`
   - Exit non-zero + "no tracking information" → `skip (no upstream configured)`
   - Exit non-zero, other → `failed: {first relevant stderr line}`

   After pulling each repo, check for unpushed commits:
   `git -C "$REPO" log @{u}..HEAD --oneline 2>/dev/null | wc -l`
   If count > 0, append ` — {N} unpushed` to that repo's result string (e.g., `up to date — 3 unpushed`).
   If the upstream check itself fails (detached HEAD, no upstream), omit the unpushed clause silently.

   Do not stop on failure — record and continue. The result is carried to step 4 and surfaced in the step 6 brief only as an exception (pull failure, unpushed commits, or an `autostash-conflict`).

1. Read the last entry from `/logs/session-notes.md`. Extract: date, summary, next steps, open questions.
   If the file doesn't exist or is empty, this is the first session — note that and skip to step 2.

   **Read method (deterministic — do not improvise against same-day clutter).** Locate the last entry's
   date-header with `Bash(grep -n "^## [0-9]" logs/session-notes.md | tail -1)` → `START`, then read
   header-to-EOF in one call: `Read(logs/session-notes.md, offset=START)`. **Never substitute a fixed
   last-N-lines window.** Then pre-fetch the log-trio — `Bash(tail -n 10 logs/decisions.md)` and
   `Bash(tail -n 30 logs/usage-log.md)`, each skipped silently if absent. No main-session reasoning
   happens over the trio at `/prime` time; it lives in context for the eventual wrap. Why the `^## [0-9]`
   anchor, the offset read and the pre-fetch take these shapes: `docs/heavy-read-discipline.md`
   § Bounded-read recipes → Step 1.

   **Telemetry-gap nudge.** The one cheap exception to "no reasoning over the pre-fetched log-trio": take the date of the most recent `## ` header in `session-notes.md` (the last wrapped session). If that date does **not** appear in the last 30 lines of `logs/usage-log.md` just read, AND that last session was non-trivial (its note carries a real `### Summary`, not a one-line or aborted entry), then the prior substantive session captured no telemetry — set a telemetry-gap flag and emit the ⚠ telemetry line in the brief (Step 6 template). Skip silently if either file is absent, the dates match, or the last session was trivial. Advisory only — it never blocks; it prompts a backfill.

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
   - **Legacy `**QC-PENDING:**` markers.** The commit-block they encoded was retired on 2026-07-30 (`docs/qc-independence.md`). Treat such a marker as ordinary scratchpad text: it grants no mtime exemption, blocks no commit, and must not be surfaced as an advisory.

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

2. **Read `next-up.md`.** Read `logs/next-up.md` if it exists and collect every unchecked checkbox item (`- [ ]` lines) as a routine menu candidate for step 5. The file is **not** universal — `/prime` never creates it, and an absent or empty one is normal, not an error. If absent, skip silently; the menu falls back to step 1a's still-open Next Steps plus step 3's urgent items.

3. **Scan for urgent problems — bounded scan, NEVER a full read.** Collect only **unresolved HIGH / urgent** items from `logs/friction-log.md` and `logs/improvement-log.md`. **Do NOT `Read` either file** — a full read of the pair cost ~50–60k tokens at *every* orientation in *every* project until it was fixed on 2026-07-13, and re-opening it restores the single most expensive recurring leak this harness has had. Issue exactly these three bounded scans:

   ```
   Bash(grep -nE -B6 "^-? ?\*\*Severity:\*\* *\*{0,2}(high|HIGH|medium-high|critical|urgent)" logs/improvement-log.md)
   Bash(grep -nE "HIGH|urgent|do-now" logs/friction-log.md | grep -viE "resolved|verified|shipped|archived|declined" | head -n 40)
   Bash(python3 -c "
import re,os
p='logs/improvement-log.md'
if os.path.exists(p):
    L=open(p,encoding='utf-8').read().split('\n')
    H=[i for i,l in enumerate(L) if re.match(r'^#{2,3} \d{4}-\d{2}-\d{2}',l)]
    n=sum(1 for k,s in enumerate(H) if not any(re.match(r'^-? ?\*\*Severity:\*\*',x) for x in L[s:(H[k+1] if k+1<len(H) else len(L))]))
    print(f'UNCLASSIFIED: {n} of {len(H)} entries carry no Severity field') if n else None")
   ```

   The three do different jobs. `improvement-log.md` is schema'd, so the `-B6` window carries each hit's **header and status lines** back with it, which is what makes the filter below applicable without a second read. `friction-log.md` has no severity field, so its hits are **candidates to judge, not findings** — incidental matches are expected and are cheap to discard in-context. The third is a **count, not a content read**: it reports how many entries carry no `Severity` field and stops, printing nothing when that count is zero. Why each anchor has exactly the shape it does — the `-B6` sizing, the two widenings, and the backtick exclusion that must **not** be loosened — is in `docs/heavy-read-discipline.md` § Bounded-read recipes → Step 3.

   Then apply the filter to the returned lines only:
   - Include an item if it carries `high`, `medium-high`, `critical`, `urgent`, or `do-now`. **`medium-high` IS included — it is the deliberate second tier of menu-reach, not a borderline case.**
   - Exclude anything marked `low` or `medium`, and exclude entries whose status is `resolved`, `applied`, `verified`, or operator-`DECLINED`.
   - If either file does not exist, its scan returns nothing — skip silently.

   **Narrowing the `medium-high` tier is a POLICY change to what earns a place on the task menu, not a cost optimisation, and it may not be made here alone.** Three other files carry the same contract — `wrap-session.md` Step 12e, `.claude/agents/session-feedback-collector.md:138`, and `logs/improvement-log.md:13` (the log's own schema) — so changing it requires updating the writer-side guidance in the first two **in the same commit**, plus a `logs/decisions.md` record. A large Step 3 emit signals that too many `medium-high` items are genuinely open; the remedy is backlog triage, not a quieter scan. This narrowing was proposed once, on 2026-07-24, and returned RECONSIDER.

   Each surviving item becomes an **urgent** menu candidate for step 5.

4. **Exception checks.** Compute the following, but carry each to step 6 only when it is abnormal — a normal value is never displayed. **Model alignment is the one exception:** it is ALWAYS carried to Step 6, matched or not.
   - **Working tree:** if the environment's git-status snapshot is non-empty, run `git status --short` and `git diff --stat HEAD` once to confirm it is still current. The env snapshot is point-in-time from session start and can be stale vs actual HEAD (e.g., files already committed in the prior session). Carry forward only if the live result shows unexpected uncommitted changes. This is a Prime-time orientation check, distinct from the commit-time "no pre-commit git status" rule.
   - **Model alignment:** read the active session model identifier from the system-prompt context — do not run any external command, it is already in context. Identify the cwd-nearest project `CLAUDE.md` and read its `## Model Selection` section for the project's **recommended posture** (advisory prose — never a declared default; defaults are prohibited per workspace `CLAUDE.md` § Model Tier). Two cases:
     - The section exists **and names exactly ONE tier** → compare the session model against it. On match, plain styling (`Model: {session model}`); on mismatch, warning styling with a hint (`⚠ Model: you are on {session model}; this project recommends {recommended} → /model {recommended}`).
     - **Anything else** — no project `CLAUDE.md`, no `## Model Selection` section, or a section naming more than one tier → emit the plain line only (`Model: {session model}`) and **never a `→ /model` nudge**. A multi-tier posture resolves against the *task*, which Step 4 does not yet know, so collapsing it to one tier would fire a false downgrade warning at nearly every session start; and with nothing to compare against, do not invent a recommendation. **An absent section is the normal state, not a defect** — nothing has written one since `/new-project` step 11a was deleted on 2026-07-27, and only a handful of legacy projects still carry one.
   - **Pull result:** carry forward the step 0 result only on failure, when there are unpushed commits, or on an `autostash-conflict` (a pop conflict that returned exit 0 — see Step 0). The `autostash-conflict` case is the highest-priority pull exception: the working tree silently holds conflict markers, so the brief must say so.
   - **Phase READMEs.** If the cwd-rooted project has a `work/` directory, scan it (one level deep) for files matching `W*-*-README.md` (or `Wn-*-README.md`). Capture the matching file paths only — do not read file bodies. Skip silently if `work/` is absent or contains no matches. Bounded scan: one `ls`/`find -maxdepth 2`-equivalent; do not recurse deeper.

5. **Build the numbered task menu.** Merge candidates from:
   - Step 1a — still-open Next Steps from the last session → tag `[carryover]`.
   - Step 1b — the scratchpad `## Resume With` line, if any → tag `[carryover]`.
   - Step 1d — each active mission's `## Open threads` unchecked items, but ONLY for missions whose repo (from `ACTIVE_MISSIONS`, Step 1d) equals `CWD_REPO` (Step 0) → tag `[mission:<id>]`. Skip building a candidate for any mission whose repo ≠ `CWD_REPO` — it is not actionable from this checkout (the Step 8a/8c cross-repo guard would stop it anyway). Step 1d's multi-repo scan and those guards are unchanged and remain in place as defense-in-depth. Omit entirely if `ACTIVE_MISSIONS` is empty or none of its entries match `CWD_REPO`.
   - Step 2 — unchecked `next-up.md` items → tag `[next-up]`.
   - Step 3 — unresolved HIGH/urgent problems → tag `[urgent]`.

   Step 1c's `PROJECT_POSITION` is **not** a menu candidate — it renders as its own block in Step 6 and does not consume a numbered slot. Overlap between that block's `Next:` line and menu item 1 is **expected and deliberately not deduped**: the block *explains* the next step, the menu *selects* it, and a stable numbered selector is worth the small repetition. Do not add dedupe logic here.

   Rank: **urgent → mission → carryover → next-up.** Cap the menu at **6 items.** If fewer than 6 candidates exist, show fewer. If zero candidates exist, show no menu (step 6 handles this). A `[mission:<id>]`-tagged item carries its source mission id so the Step 8 binding sub-step can auto-bind without asking.

   Convert each menu item to **one plain-English sentence** (short sentences, common words — the operator is a non-developer):
   - Keep command names and file names literal (`/kb-review`, `next-up.md`).
   - Drop priority codes (`HIGH`/`MED`/`LOW`), status tags, and section anchors (`§3`, `WU3`) from the displayed text — keep a step number only when it aids meaning.
   - Append one short tag: `[urgent]`, `[mission: <id>]`, `[carryover]`, or `[next-up]`. Every `[mission:<id>]` candidate reaching this step already has repo == `CWD_REPO`, so no cross-repo tag variant is needed.

6. **Output the brief — this and nothing else.** All displayed text (exception lines, menu items) uses the plain-English conversion rules from step 5. Emit an exception line only when it is real; omit the whole line otherwise.

```
## Prime — {date}

Model: {session model}
{⚠ Model: you are on {session model}; this project recommends {recommended} → /model {recommended} — replaces the plain line above; only on mismatch}
{⚠ Working tree: {short summary} — only if unexpectedly dirty}
{⚠ Pull: {result} — only on failure or unpushed commits}
{⚠ Pull: autostash pop conflicted — working tree has conflict markers; stash@{0} preserved. Resolve the markers (or `git checkout --theirs`/`--ours`) and `git stash drop` before starting work. — only on an `autostash-conflict` result from Step 0}
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

Type 1–6 to start that task. Type `auto` to run the #1 item end-to-end with a single approval gate, or `auto 1,3` (or `auto 1 3`) to run several items back-to-back under one combined approval gate. Or tell me something else.

Full backlog & inbox: /open-items
```

   Render only as many numbered lines as step 5 produced (1 to 6). If step 5 produced no menu items, replace the `Next tasks:` block and the `Type 1–6 …` line with the single line: `No tracked next steps — tell me what to work on.`

   **`Where we are:` block — omit entirely when Step 1c left `PROJECT_POSITION` unset** (no plan and no `pipeline-state.md` in this repo). Drop the heading and all three lines, not just their values — an empty labelled block is worse than no block, and this is the normal shape in any non-project repo. Same "emit only when real" rule the exception lines above follow.

7. **Wait for the operator's response.** Classify the reply:
   - `N auto` (a single menu number followed by the word "auto", e.g. `2 auto` — trimmed input matching `^[1-6]\s+auto$`, N within menu range) → **auto mode**, picked item = #N. Treat identically to `auto N` and go to step 8c. (Check this branch BEFORE the bare-number rule below — otherwise `2 auto` is misread as a bare-number selection of item 2, silently skipping auto-mode and its mandate/plan ceremony.)
   - A bare number `1` through `6` (within the rendered menu range) — or `do 2` / `task 2` / `option 2` — → **task selection.** Go to step 8a.
   - `auto` / `a` (case-insensitive, trimmed) — or `do auto` / `run auto` → **auto mode**, picked item = #1. Go to step 8c.
   - `auto N` (single number within menu range) → **auto mode**, picked item = #N. Go to step 8c.
   - `auto N,M,...` or `auto N M ...` (multiple numbers within menu range, separated by commas or spaces) → **auto mode (multi-item)**, picked items = those numbers in the order given. Go to step 8c.
   - Anything else (a sentence, a different task, a question) → **free-text intent.** Go to step 8b.
   - If the reply is ambiguous (a number outside the rendered menu range, an `auto N` where N is outside range, or "2 but first do X"), ask once for a plain number, the word `auto` (optionally followed by one or more item numbers), or a sentence, then classify the re-response.

8m. **Mission binding (shared sub-step — referenced by 8a / 8b / 8c).** Resolves which active mission, if any, this session serves. **Skip entirely — no prompt, no output — when `ACTIVE_MISSIONS` (Step 1d) is empty** (the common case). Run only after a non-plan-mode dispatch is confirmed (i.e., past each branch's plan-mode guard), and before the branch calls `/session-start` (8a/8b) or writes the inline mandate (8c). Resolve `MISSION_ID`:
   - If the picked/stated task came from a `[mission:<id>]` menu item → `MISSION_ID = <id>`. **Auto-bound; no prompt.** (Primary path — picking a mission's open thread IS the binding.)
   - Else, emit exactly one line: `This session serves which active mission? {[1] <id> — <name> … [N] …} — or 'none'.` Parse the reply: a number → that mission's id; `none` / empty / anything else → no mission. One prompt only; default is `none`.
   - Carry `MISSION_ID` forward. If unset/`none`, the session has no mission bullet and everything downstream proceeds exactly as today.

   **Wiring:** all three branches prepend `{mission:<id>}` to the args passed to `/session-start`, which strips it and writes the `- Mission: <id>` bullet (see `session-start.md` Step 1). 8c does this at its Step 8c.9 dispatch, alongside `{gate:auto}` and `{plan:overwrite}`; it no longer writes the bullet itself. When `MISSION_ID` is unset, none of this happens.

   **Cross-repo note:** the pre-write cross-repo mission guard (Steps 8a sub-step a0, 8c sub-step 2.5) fires *before* this binding, deriving the picked mission's repo from `ACTIVE_MISSIONS` (Step 1d), not from `MISSION_ID` here — so a wrong-repo pick is caught before any marker/header write. Do not move Step 8m earlier to "cover" that case; the guard already does, and 8m must stay after the write per the marker contract. (8b/free-text needs no guard — there is no `[mission:<id>]` menu item to mis-pick.)

8k. **Marker allocation (shared sub-step — referenced by 8a / 8b / 8c).** Allocate this session's marker per the TOCTOU Phase 2+3 atomic contract (canonical: `docs/session-marker.md`). Produces `${TODAY}` and `${MARKER}`, and writes `logs/.session-marker` plus the per-id `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`. Run it once per non-plan-mode dispatch — after the branch's cross-repo mission guard (8a sub-step a0 / 8c sub-step 2.5) and before the branch's header-existence check.

   **`logs/scripts/prime-marker.sh` is the executing owner of this logic — call it, never reinline it.** Run it from the repository root and split its single stdout line:

   ```bash
   MARKER_LINE=$(bash logs/scripts/prime-marker.sh) || exit 1
   TODAY="${MARKER_LINE%% *}"; MARKER="${MARKER_LINE#* }"
   ```

   The fail-safe seed invariant, the atomic `mkdir` claim, the zsh `find`-not-glob rule and the session-id suffix are all load-bearing. They live in the script beside the code they guard, and `logs/scripts/prime-allocator.test.sh` is the tripwire that holds them. **Reinlining this logic here would restore the defect the extraction fixed** — code inside an executable prompt is validated by *reading* rather than by *running*, and its one executing consumer had to scrape it out of markdown by awk. That scrape reported "12 passed, 0 failed" against a stale copy on 2026-07-14. (Extracted 2026-07-29, capability `prime-runtime-delegation`.)

   **Caller contract — ordering is the caller's responsibility (mirrors 8m's Wiring note).** This sub-step produces `${MARKER}` and writes only the marker files; it does NOT touch `session-notes.md`. The calling branch owns the rest of the marker → header → mtime ordering: after 8k returns, run the `grep -Fxq` header-existence check, append this session's marker-bearing header (with the branch's own work-description text), then write `logs/.prime-mtime` — in that order. Marker before header so the header can embed `${MARKER}`; mtime after the append so `/session-start` Step 0.5 sees this session's own write. `/session-start` Step 3 and `/session-plan` Step 0 both require THIS session's marker-bearing header to exist.

   Same-day re-invocations increment within the day (`S1` → `S2` → …); a new day resets to `S1`.

8h. **Session-entry write (shared sub-step — referenced by 8a / 8b / 8c).** Allocate the marker, ensure this session's marker-bearing header exists, and stamp the mtime — in that order, which is load-bearing. Takes one parameter, `WORK_DESC` (the work-description line the caller wants recorded under the header); everything else is identical across the three branches, which is why this lives once.

   Run it after the caller's cross-repo mission guard (8a sub-step a0 / 8c.4) and before the caller invokes `/session-start`.

   1. **Marker.** Run the **Step 8k marker-allocation sub-step** to obtain `${TODAY}` and `${MARKER}`. 8k writes `logs/.session-marker` and the per-id marker; it does NOT touch `session-notes.md` — that is this sub-step's job.

   2. **Marker-bearing header.** Check for THIS session's header with a literal whole-line grep (full-file, so immune to entry length; `-Fx` matches the em-dash and `${MARKER}` verbatim with no regex risk):

      ```
      Bash(grep -Fxq "## ${TODAY} — Session ${MARKER}" logs/session-notes.md)
      ```

      **exit 0 → header already present** (rare — same-marker re-invocation): reuse it and append `WORK_DESC` beneath it. **exit 1 → header absent** (the common case at `/prime` time): append a new `## ${TODAY} — Session ${MARKER}` header with `WORK_DESC` as its work description. Treat exit 1 strictly as "not found → create", **never** as "command failed → skip the write" — suppressing this session's header breaks the `/session-start` Step 3 and `/session-plan` Step 0 preconditions, both of which require it to exist.

      Foreign concurrent sessions write under their own marker-bearing headers (e.g. `## YYYY-MM-DD — Session S2`); those do **not** count as "this session's header". The marker is the disambiguator. The pre-Phase-2 "no duplicate same-day header" rule is replaced by "this session writes only under its own marker-bearing header".

   3. **mtime.** **After the append succeeds**, write `session-notes.md`'s mtime to `logs/.prime-mtime` (consumed by `/session-start` Step 0.5's foreign-write check):

      ```bash
      stat -f %m logs/session-notes.md 2>/dev/null > logs/.prime-mtime \
        || stat -c %Y logs/session-notes.md 2>/dev/null > logs/.prime-mtime
      ```

   **Order is marker → header append → mtime, and it is not arbitrary.** Marker first, so the header can embed `${MARKER}`. mtime last, so `/session-start` Step 0.5 sees this session's own write rather than a pre-write timestamp — reversing these two makes every session look like it was written by a foreign one.

   *(Consolidated 2026-07-29. This sequence was previously written three times — 8a.3.a, 8b.3.a and 8c.3 — wrapped around the already-shared 8k allocator. The three differed only in `WORK_DESC`, which is now the parameter. Edit this one block; there is nothing to keep in sync across branches.)*

8a. **Task selected by number.**
   1. Resolve the number to its menu item → `TASK_TEXT` (the plain-English task text).
   2. **Plan-mode guard.** If a plan-mode system reminder is present in context (plan mode is active), do NOT run `/session-start` or `/session-plan`, and do NOT write anything. Output:
      > Task {N} noted: {TASK_TEXT}. You're in plan mode — I won't run `/session-start` yet. Exit plan mode when you're ready to execute, then re-send `{N}` (or say `go`) and I'll run `/session-start` and `/session-plan` for this task.

      Then stop.
   3. If plan mode is **not** active:
      a0. **Cross-repo mission guard.** If the picked item is `[mission:<id>]`-sourced AND that mission's repo (from `ACTIVE_MISSIONS`, Step 1d) ≠ `CWD_REPO` (Step 0), STOP before any write and emit:
         > ⚠ This task belongs to mission `{id}`, which lives in `{repo}` — but you're priming in `{CWD_REPO}`. Setting it up here would write the marker/header and run `/session-start` in the *wrong* repo. Open `{repo}` as your session folder and re-run `/prime` there to work on this mission. (Reply `here` to override and set it up in the current repo anyway.)

         Wait for the operator. On `here` → proceed to sub-step a. On anything else → stop, write nothing. A same-repo pick (mission repo == `CWD_REPO`) skips this guard silently. Derive the repo from `ACTIVE_MISSIONS` here, not from Step 8m's later `MISSION_ID` — this guard must fire before the sub-step-a marker/header write.
      a. **Session-entry write.** Run the **Step 8h shared sub-step** with `WORK_DESC = TASK_TEXT`. It allocates the marker (via 8k), ensures this session's marker-bearing header exists, and stamps `logs/.prime-mtime`, in that order. This must happen before step c — `/session-start` Step 3 and `/session-plan` Step 0 both require THIS session's marker-bearing header to exist.
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

8c. **Auto mode.** The operator typed `auto` (optionally with item numbers) — run the picked menu item(s) end-to-end with a single combined approval gate and no per-stage prompts. **8c owns picking, the guards and dispatch. It does not derive, echo or write the mandate, the manifest or the plan** — `/session-start` and `/session-plan` own those, and 8c reaches them by invoking `/session-start` under `{gate:auto}`.

   1. **Resolve PICKED_ITEMS.** Parse the operator's reply:
      - `auto` / `a` (no number) → [item #1 from the menu built in Step 5].
      - `auto N` — or the equivalent `N auto` shape (`^[1-6]\s+auto$`, normalized by Step 7) → [item #N].
      - `auto N,M,...` or `auto N M ...` → [item #N, item #M, ...] in the order the operator gave them. Deduplicate while preserving first-seen order.

      Validate that every requested number is within the rendered menu range. If any is out of range, ask once for a valid `auto` reply and re-classify (per Step 7 ambiguity rule). If the menu has zero items, output `No tracked next steps — auto mode needs a task. Tell me what to work on.` and stop. `PICKED_ITEMS_TEXT` is a short comma-joined preview of the picked items' text; `SINGLE_ITEM` is true when exactly one entry was picked.

   2. **Per-item done-condition presence-check.** Before any disk write, verify every picked item carries a derivable done-condition — an observable deliverable, check or target (file written, item checked off, finding addressed, commit landed, count reached). The item text plus its source line is the evidence. An item naming only an activity with no observable end-state ("review X", "look into Y", "think about Z") whose source line supplies no target **fails**. Rationale and the logged trigger: `docs/session-marker.md` § Auto-mode done-condition check.

      All items pass → continue to 8c.3. One or more fail → hold them back, write nothing, and emit:

      > Auto mode — {K} of {N} picked items have no concrete done-condition and were held back:
      > {for each held item: `  • {item text} — needs a concrete deliverable (file / check / target). Define it, then re-pick this item.`}
      >
      > {if any items passed:} I can proceed with the {M} scoped item(s): {passed-items-text}. Reply `go` to run those, or restate the held item(s) with a deliverable.
      > {if zero items passed:} Restate the held item(s) with a deliverable (file / check / target), then re-send `auto`.

      On `go` with a non-empty passed set → set `PICKED_ITEMS` to the passed subset (preserving order), recompute `PICKED_ITEMS_TEXT` / `SINGLE_ITEM`, and continue. On a restated item → re-run this check against the restatement. If zero items passed and the operator does not restate, stop without writing.

   3. **Plan-mode guard.** If a plan-mode system reminder is present in context, output `Auto mode noted: {PICKED_ITEMS_TEXT}. You're in plan mode — I won't write anything yet. Exit plan mode and re-send 'auto' (or 'go') to proceed.` Then stop.

   4. **Cross-repo mission guard.** If any picked item is `[mission:<id>]`-sourced AND that mission's repo (from `ACTIVE_MISSIONS`, Step 1d) ≠ `CWD_REPO` (Step 0), STOP and emit the same wrong-repo warning as Step 8a's cross-repo guard, listing each offending item and its repo. Wait; on `here` → continue to 8c.5; on anything else → stop, write nothing. This is a **deliberate single-condition exception** to auto mode's "single approval gate, no per-stage prompts" contract (it fires ONLY when a picked mission's repo ≠ `CWD_REPO`) — do not remove it as a stray prompt. It is load-bearing precisely because the 8c.5 header write precedes the approval gate, so this is the only point that stops a wrong-repo header before disk. Derive the repo from `ACTIVE_MISSIONS`, not from the 8c.6 auto-bind (which runs after the write). Same-repo picks skip it silently.

   5. **Session-entry write.** Run the **Step 8h shared sub-step** with `WORK_DESC` = the picked item's plain-English text if `SINGLE_ITEM`, otherwise `Auto multi-item: {item-N text}; {item-M text}; …` listing every picked item separated by `;` in operator order.

      **These three writes precede the approval gate by necessity, and `abort` does not roll them back** — see 8c.9.

   6. **Mission auto-bind, then route.** Run the **Step 8m** sub-step in auto-bind-only mode: if any picked item is `[mission:<id>]`-sourced, set `MISSION_ID` to that mission (the first, if several). **Do not emit the interactive binding prompt** — auto mode's contract is one approval gate with no per-stage prompts. If no picked item is mission-sourced, `MISSION_ID` stays unset. Then evaluate `DIRECT` once via the canonical predicate (`docs/session-marker.md` § Direct-route detection). If it cannot be evaluated for any reason, treat it as `DIRECT=0` — fail-safe, meaning the plan file is written.

   7. **Compose `MANDATE_TEXT`.** Build the single string `/session-start` Step 2 will parse. **8c does not derive the individual mandate fields and does not echo them.** For `SINGLE_ITEM`, the picked item's work and its concrete deliverable, plus any bound the item states. For multi-item: `Complete picked menu items: (1) {item-N work + deliverable}; (2) {item-M work + deliverable}; …` covering every picked item in operator order, followed by any per-item scope bounds joined with `;`.

   8. **Derive `STRUCTURAL_RISK` — and nothing else.** Boolean: true if any picked item touches a structural change class (full list: `ai-resources/docs/audit-discipline.md`). **`/prime` is this field's sole owner**, because 8c.11 owns the review-sizing disclosure it drives. Model tier and autonomy posture are **not** derived here — `/session-plan` owns both and discloses them after the plan write.

   9. **Dispatch to `/session-start`, which holds the approval gate.** Invoke it via the Skill tool with `args = "{gate:auto} {plan:overwrite} {mission:<MISSION_ID>, only if bound} {MANDATE_TEXT}"`, and hand it `STRUCTURAL_RISK` for the gate block. Under `{gate:auto}` that command suppresses its Step 2 echo and wait, runs Step 2.4 discovery and Step 2.5 validation in their existing order, then holds **one** approval gate — on **every** engine outcome, including skipped and failed — and on `go` writes the mandate (its Step 3), the run-manifest stub (3.5) and the plan (via `/session-plan`), returning here **without beginning execution**. `{plan:overwrite}` pre-selects `/session-plan` Step 0's overwrite option so the chain does not stop to ask.

      **On `abort` nothing further is written and control returns here.** The marker, header and mtime written at 8c.5 remain, because they precede the gate. Output `Auto mode aborted. No mandate, manifest or plan written — today's session header remains.` and stop.

   10. **Direct route.** When `DIRECT=1`, `/session-start` Step 4 does not chain to `/session-plan` and no `logs/session-plan-*.md` is written; the mandate and run-manifest still are. The gate block at 8c.9 disclosed this.

   11. **Disclose review sizing if `STRUCTURAL_RISK` is true.** No separate gate runs — a structural class does not fire a check of its own; it makes the change high-consequence, which is carried inside the review sizing (`ai-resources/docs/qc-independence.md` § The rule). Emit one line — `Structural change class touched — the independent review for this work is briefed risk-aware.` — and continue to 8c.12. If `STRUCTURAL_RISK` is false, skip silently.

   12. **Begin execution under the autonomy posture `/session-plan` set.** No further confirmation gate — the 8c.9 approval covered execution for every picked item. Run multi-item picks in the operator-given order and do NOT pause between items; emit a one-line between-gate summary at each item boundary (workspace `Between-gate summaries`). Complete the mandate fully within this session where context allows; if context is clearly constrained, follow the workspace `Context constraint deferral` rule — flag the deferral and log it, do not rush. During execution: size the independent review to the change per `ai-resources/docs/qc-independence.md` (no review fires automatically), follow `ai-resources/docs/compaction-protocol.md` checkpoints on long work, surface `[SCOPE]` / `[HEAVY]` / `[AMBIGUOUS]` / `[COST]` guardrail flags, and commit directly per the workspace `Commit behavior` rule.

   13. **On mandate completion.** Output `Mandate complete. Run /wrap-session to capture telemetry and journal the session. Push pending — let me know when to push.` Do not auto-invoke `/wrap-session` — the operator decides when to wrap.
