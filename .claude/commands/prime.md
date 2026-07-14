---
model: sonnet
---

Orient the session. Read state, brief the operator with a short task menu, wait for direction.

**Principle:** Prime never asserts state from a single source. Each surfaced next-step or status claim must be cross-checked against git log since the claim's source timestamp before being reported as current.

**Output discipline:** The operator is a non-developer. The brief must be short and scannable — convert terse log shorthand into plain English (short sentences, common words). Show only what the operator needs to choose the next task; everything else stays silent unless it needs attention.

**Execution discipline:** The orientation steps issue many *independent* read-only git/file calls; running them one-at-a-time is the main avoidable latency. Batch independent calls into a single message with multiple tool calls rather than firing them serially. Safe to fire together: **Step 1** (session-notes + log-trio reads), **Step 1b** (scratchpad listing), **Step 2** (`next-up.md`), **Step 3** (`friction-log.md` + `improvement-log.md`); **Step 0**'s per-repo `pull` may join the same batch. **Two ordering dependencies must be preserved — do not hoist a dependent call into the batch ahead of what it needs:** (1) **Step 1a**'s git cross-check consumes both `CWD_REPO` / `AI_RESOURCES` (established in Step 0) *and* the entry date parsed in Step 1, so it runs *after* Step 0 and Step 1, never alongside them; (2) **Step 4**'s working-tree `git status` must run *after* the Step 0 pulls so it sees post-pull state. Everything else across steps 0–4 is independent and should be batched.

0. **Pull latest.** Determine the cwd's git root: `CWD_REPO=$(git -C "$(pwd)" rev-parse --show-toplevel 2>/dev/null)`.
   If this fails, note `Pulled: n/a (not a git repo)` and skip to step 1.

   Define `AI_RESOURCES="/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources"`.

   Run `GIT_TERMINAL_PROMPT=0 git -C "$CWD_REPO" pull --rebase --autostash`. If `$CWD_REPO` differs
   from `$AI_RESOURCES`, also run `GIT_TERMINAL_PROMPT=0 git -C "$AI_RESOURCES" pull --rebase --autostash`.
   `--rebase --autostash` is explicit (not left to per-machine `pull.rebase` config) so a dirty working
   tree from a prior same-day session is stashed, rebased over, and popped back in one command — the
   rebase no longer refuses to start, removing the failure-and-recovery round-trip. Capture each result:
   - **Autostash pop conflict — detect FIRST, before the exit-code cases below.** With `--autostash`, the history rebase can succeed (exit 0) while the *pop* of the stashed dirty tree conflicts. Git prints `Applying autostash resulted in conflicts. Your changes are safe in the stash.` but still **returns exit 0**, so the exit-code cases below would mislabel it `updated`. Detect it via any of three signals (OR — robust to git wording changes): the captured pull output contains `Applying autostash resulted in conflicts`; OR `git -C "$REPO" stash list` shows a residual `autostash` entry; OR `git -C "$REPO" status --short` shows a conflicted (`UU`) path. If any fires → `autostash-conflict` (the working tree now carries conflict markers and `stash@{0}` is preserved). Classify this BEFORE the two exit-0 cases.
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

   **Read method (deterministic — do not improvise against same-day clutter).** Several same-day entries
   (`S1`, `S2`, …) commonly stack in this file and a single entry can run 30+ lines, so any fixed
   "last N lines" window is unreliable. Locate the last entry's date-header with one grep, then read
   from that line to EOF in one targeted call:
   ```
   Bash(grep -n "^## [0-9]" logs/session-notes.md | tail -1)   # → START line of the last entry
   Read(logs/session-notes.md, offset=START)                   # header-to-EOF, single read
   ```
   The grep is anchored to a date header (`^## [0-9]`) so a `## Heading` inside an entry body or fenced
   code block cannot false-match. This captures the full last entry in two calls regardless of length
   or how many same-day sessions stacked.

   **Pre-fetch the log-trio** (token-audit R4, 2026-05-25). After reading `session-notes.md`, also tail-read the last 10 lines of `logs/decisions.md` and the last 30 lines of `logs/usage-log.md` — these files are touched by `/wrap-session` at session-end and a recurring Edit-before-Read failure on `session-notes.md` (3 of last 4 sessions per usage-log telemetry) is eliminated when the log-trio is already in `/prime`'s context. Use:
   ```
   Bash(tail -n 10 logs/decisions.md)
   Bash(tail -n 30 logs/usage-log.md)
   ```
   Skip silently if either file does not exist. The pre-fetch is bounded read scope; no main-session reasoning happens over these lines at /prime time — they live in context for the eventual wrap.

   **Telemetry-gap nudge (2026-07-04 — `/wrap-session` telemetry is opt-in, so a forgotten `+telemetry` silently drops a session from the `usage-log` baseline).** This is the one cheap exception to "no reasoning over the pre-fetched log-trio": take the date of the most recent `## ` header in `session-notes.md` (the last wrapped session). If that date does **not** appear in the last 30 lines of `logs/usage-log.md` just read, AND that last session was non-trivial (its note carries a real `### Summary`, not a one-line or aborted entry), then the prior substantive session captured no telemetry — set a telemetry-gap flag and emit the ⚠ telemetry line in the brief (Step 6 template). Skip silently if either file is absent, the dates match, or the last session was trivial. Advisory only — it never blocks; it prompts a backfill.

1a. **Cross-check Next Steps against git log and sibling entries.** Detection logic only — this command has no brief-level Next Steps list; see steps 5–6.

   *Canonical primitive.* The merged-multi-repo git cross-check below is the **reference implementation** of the reconcile-at-read primitive now documented in `docs/backlog-reconciliation.md` (shared by `/fix-project-issues`, `/fix-repo-issues`, `/open-items`). The mechanism here and the doc must stay in sync — if you change the scan/classification logic in one, update the other.

   *Git cross-check:* Parse the `## YYYY-MM-DD` header date from the source entry. Run:
   `git -C "$CWD_REPO" log --since="<entry-date>T00:00:00" --pretty="%h %s" --all 2>/dev/null`

   If `$CWD_REPO` differs from `$AI_RESOURCES` (the variable established in Step 0), ALSO run the same command against `$AI_RESOURCES` and merge the two result sets before the keyword-match pass below:
   `git -C "$AI_RESOURCES" log --since="<entry-date>T00:00:00" --pretty="%h %s" --all 2>/dev/null`

   Rationale: dual-repo Cluster A blindspot — Next Steps written in a project session may have been resolved by commits that landed in the ai-resources repo (canonical command edits, doc edits, log-status flips), and vice versa. Checking only the cwd-repo's git log misses those cross-repo resolutions and surfaces likely-DONE items as still-open in the menu.

   *Sibling project-repo extension (id-01, fix-plan 2026-06-04-1823):* the dual-repo merge above still misses a third class — a Next Step resolved by a commit that landed in **another project repo** (project A's session primed while the resolving commit is in project B, or a cwd=`ai-resources` prime whose Next Step was closed by a commit in, say, `strategic-os`). Extend the merge to also scan the active sibling project repos. Derive `WORKSPACE_ROOT` as the parent of `$AI_RESOURCES`, enumerate git repos one level under `projects/`, and run the same `--since` query against each, merging all non-empty results into the same result set:

   ```bash
   WORKSPACE_ROOT="$(dirname "$AI_RESOURCES")"
   for d in "$WORKSPACE_ROOT"/projects/*/; do
     repo="$(git -C "$d" rev-parse --show-toplevel 2>/dev/null)" || continue   # skip non-repos
     [ "$repo" = "$CWD_REPO" ] && continue                                     # already scanned above
     [ "$repo" = "$AI_RESOURCES" ] && continue                                 # already scanned above
     git -C "$repo" log --since="<entry-date>T00:00:00" --pretty="%h %s" --all 2>/dev/null
   done
   ```

   Cost note: this scans **all** repos under `projects/*/` (one `rev-parse` + `git log` per repo) — `/prime` has no operator scope menu, so unlike `/fix-repo-issues` Step 1 there is no interactive active/selected filter; the scan is bounded by *output* (`--since` returns nothing for repos with no commits since the entry date), not by *invocation count* (every project repo still gets the two cheap git calls). A repo that is `--show-toplevel`-equal to one already scanned is skipped (no double-count). Any directory that is not a git repo, or whose `git` call errors, is skipped silently — same fall-through posture as the dual-repo check below. The merged set (cwd + ai-resources + sibling project repos) feeds the single keyword-match pass below; the match/classify logic is unchanged.

   For each Next Steps bullet, check if any commit subject across the merged result set contains keywords from that bullet. Classify the bullet:
   - **Match found → likely-DONE.** Do NOT promote it into the numbered menu (step 5) — the menu must not spend slots on probably-finished work.
   - **No match → still open.** It becomes a carryover/menu candidate for step 5.

   `/prime` never edits `session-notes.md`, so every Next Step bullet stays untouched in the source file — the operator can verify there directly if a likely-DONE call looks wrong. If either git command fails or returns nothing, fall through to whichever result set succeeded; if both fail, treat all bullets as still-open and continue.

   *Sibling-entry informational note (TOCTOU Phase 2+3 atomic shape):* Under marker-scoped session writes (see `docs/session-marker.md`), each session writes its own marker-bearing header `## YYYY-MM-DD — Session ${MARKER}`. Multiple same-day headers is the EXPECTED shape, not a hazard — do NOT emit a `⚠` warning (per `principles.md § AP-10`: no error handling for impossible-or-normal scenarios).

   Count distinct marker-bearing headers — `SIBLING_COUNT` is consumed downstream only as a gate (the shared-dir advisory immediately below, and the `/concurrent-session-check` liveness note); it no longer drives its own standalone Step 6 display line:

   ```bash
   TODAY=$(date '+%Y-%m-%d')
   SIBLING_COUNT=$(grep -c "^## ${TODAY}" logs/session-notes.md 2>/dev/null || echo 0)
   ```

   `SIBLING_COUNT`'s own standalone Step 6 informational line was trimmed in the 2026-07 brief-simplification pass; it now exists solely to gate the shared-dir advisory below and to inform the `/concurrent-session-check` liveness note (Step 1a below).

   *Concurrent-detected shared-dir advisory (C.2, 2026-06-05; extended id-15, 2026-06-05).* When `SIBLING_COUNT > 1` — a concurrent same-day session is likely active — the marker protocol protects per-session log writes, but two surfaces are watched by no guard: **foreign uncommitted edits to shared command/doc files** (`.claude/commands/`, `docs/`) AND **foreign in-place edits to the non-append shared logs** under `logs/` (`improvement-log.md`, `improvement-log-archive.md`, `decisions.md`) — these logs take in-place status flips / entry archiving (not atomic appends), so a foreign mid-edit there is a genuine lost-update surface (see `audits/2026-06-05-concurrent-session-collision-diagnostics-fix.md` § 5). The append-only marker-disambiguated `logs/session-notes.md` is deliberately EXCLUDED — the marker/header model already protects it, and including it would false-positive on every concurrent session. Run one **read-only** check to make both surfaces visible:

   ```bash
   FOREIGN_SHARED=$(git status --short -- .claude/commands docs logs/improvement-log.md logs/improvement-log-archive.md logs/decisions.md 2>/dev/null)
   ```

   This is read-only (no `git add`, no write). If `FOREIGN_SHARED` is non-empty, carry the dirty paths to Step 6 as an exception line naming the foreign-dirty shared files/logs — these are files a concurrent session may be mid-edit on, so editing them this session risks a lost-update collision. If `SIBLING_COUNT ≤ 1` or the check returns nothing, skip silently (no line). The advisory only *names* the surface; it does not block.

   *Live-foreign-session check → `/concurrent-session-check` nudge (S3, 2026-06-12).* `SIBLING_COUNT` above counts same-day *headers* — it cannot tell a live session from one that already wrapped (the marker is date-pruned, not liveness-pruned), so it is the wrong gate for a "you have a concurrent session right now" nudge. Reuse instead the precise liveness oracle that `detect-concurrent-session.sh` already uses: the per-id marker set. `/prime` writes this session's own per-id marker only at Step 8 (after orientation), so at Step 1a time **every** today-dated `logs/.session-marker-*` other than this session's own is a foreign session that primed in this checkout today and has not wrapped (≈ live). Run one **read-only** scan:

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

   If `CLAUDE_CODE_SESSION_ID` is unset (old CLI), the oracle is unavailable — leave `LIVE_FOREIGN_HERE=0` and skip the nudge silently (degrade safe; `detect-concurrent-session.sh` still covers the SessionStart-level alert via its own old-CLI fallback). If `LIVE_FOREIGN_HERE >= 1`, carry it to Step 6, which emits the `/concurrent-session-check` nudge line. This is the planning-time pair of the SessionStart hook: the hook says "a session is live — isolate"; this line says "a session is live — so check your next task won't collide before you pick it." Independent of `SIBLING_COUNT` (strictly more precise); never blocks.

1b. **Detect a resumable continuity scratchpad.** `/handoff` continuity mode and `/wrap-session` Step 0.5 both write session-state scratchpads to `logs/scratchpads/`. Surface the most recent one so the operator can choose to resume it.

   - List `logs/scratchpads/` for files matching the glob `*-scratchpad.md` **exactly** — this excludes other files that may share the directory (e.g., `*-implementation-plan.md`).
   - Select the most recent by **filesystem mtime** — the most-recently-modified `*-scratchpad.md` file wins (e.g. `ls -t` over the matches). Do NOT sort by the `YYYY-MM-DD-HH-MM` timestamp in the filename: that timestamp is typed by the AI session that produced the scratchpad and its time-of-day component is unreliable (observed skew of 2–3 hours ahead of real write time), so lexical filename order does NOT track chronological order. `logs/scratchpads/` is gitignored — it is never populated by `git checkout` or `git pull` — so mtime always reflects the actual local write time and is the reliable chronological signal here.
   - **QC-PENDING precedence (commit-block).** Before applying the date comparison below, check whether any `*-scratchpad.md` carries an unresolved `**QC-PENDING:**` marker — a deferred architectural-change commit-block (see `docs/qc-independence.md` § Subagent-unavailable fallback). If one does, **select that scratchpad** (the most recent such, if several) regardless of mtime, and treat it as **exempt from the date-supersession skip below** — it surfaces until the deferred `/qc-pass` passes, the commit lands, and the resume flow deletes the scratchpad. A QC-PENDING scratchpad must never be silently buried by a newer trivial scratchpad.
   - Compare the selected scratchpad's date — the `YYYY-MM-DD` date portion of its mtime — to the date of the last `session-notes.md` entry from Step 1:
     - Scratchpad date **≥** last entry date → surface it. Read its `## Resume With` section and take the first content line.
     - Scratchpad date **<** last entry date → a later wrap superseded it; skip silently. **Exception:** a `**QC-PENDING:**` scratchpad is never skipped on this rule — surface it regardless of date.
   - If `logs/scratchpads/` is absent or has no `*-scratchpad.md` file, skip silently.
   - When surfaced, the scratchpad feeds a **carryover** menu candidate: the first content line of its `## Resume With` section is a strong candidate for menu item 1 (step 5). (The standalone `↩ Resumable scratchpad: {path}` Step 6 display line was trimmed in the 2026-07 brief-simplification pass — the scratchpad's existence now surfaces only via that menu candidate, or via the QC-PENDING advisory below when applicable. Line 137's QC-PENDING commit-block advisory is a separate line and still emits.) This step does NOT auto-resume — the operator decides by picking that menu item or answering the direction prompt.
   - **QC-PENDING surfacing.** When the surfaced scratchpad carries a `**QC-PENDING:**` marker, flag it prominently as a **commit-block** — emit an advisory line, "⚠ Architectural artifact awaits independent QC — do NOT commit until `/qc-pass` passes (per the QC-PENDING scratchpad)", in addition to placing its `## Resume With` first line (the QC instruction) as menu item 1. Do not let the marker line itself be mistaken for the next action; the action is the `## Resume With` first line.

1d. **Scan active missions (mission-contract subsystem).** A *mission* is a multi-session goal (`/mission`); a session can bind to one so `/drift-check` measures its trajectory against the mission's validation contract. This step makes active missions visible and is a **zero-cost no-op when none exist** — when no `logs/missions/` dir is present in any enumerated repo, this step adds no prompt, no menu item, and no brief line.

   Reuse the Step 1a repo enumeration (`CWD_REPO`, `AI_RESOURCES`, sibling `projects/*/` repos — already de-duped there). For each enumerated repo, scan **`<repo>/logs/missions/*.md` only — never `<repo>/logs/missions/archive/`** (closed missions are archived and must not reappear here, keeping the scan bounded as missions accumulate):

   ```bash
   # ACTIVE_MISSIONS — one entry per active mission across enumerated repos.
   WORKSPACE_ROOT="$(dirname "$AI_RESOURCES")"   # same derivation as Step 1a
   for repo in "$CWD_REPO" "$AI_RESOURCES" "$WORKSPACE_ROOT"/projects/*/; do
     [ -d "$repo/logs/missions" ] || continue
     for m in "$repo"/logs/missions/*.md; do
       [ -f "$m" ] || continue
       grep -q '^status: active' "$m" || continue   # active only
       # capture: mission_id (frontmatter), mission_name, repo, and the `## Open threads` unchecked `- [ ]` lines
     done
   done
   ```

   Build `ACTIVE_MISSIONS` = list of `{id, name, repo, open_threads[]}`. If the list is empty, set a flag and skip all mission-related additions below (the common case). Carry `ACTIVE_MISSIONS` to Step 5 (menu candidates), Step 6 (brief), and the Step 8 binding sub-step.

2. **Read `next-up.md`.** Read `logs/next-up.md` if it exists. Collect every unchecked checkbox item (`- [ ]` lines). These are routine menu candidates for step 5.

   `next-up.md` is **not** a universal file — it exists in some project log directories and is absent in others. `/prime` does not create it. If the file is absent, skip silently; the menu falls back to the still-open Next Steps from step 1a plus the urgent items from step 3. An absent or empty `next-up.md` is normal, not an error.

3. **Scan for urgent problems — bounded scan, NEVER a full read.** Collect only **unresolved HIGH / urgent** items from `logs/friction-log.md` and `logs/improvement-log.md`.

   **Do NOT `Read` either file.** They are long (~400 L and ~650 L, and both grow monotonically) and a full read of the pair cost ~50–60k tokens at *every* orientation in *every* project — a defect named in five consecutive `usage-log` telemetry entries before it was fixed (2026-07-13; see `logs/improvement-log.md` of that date). The `decisions.md` pre-fetch in Step 1 is already bounded; this step now matches it. A future edit that "simplifies" this back into a `Read` re-opens the single most expensive recurring leak in the harness — do not.

   Issue exactly these two bounded scans:

   ```
   Bash(grep -nE -B6 "^- \*\*Severity:\*\* *(high|HIGH|medium-high|critical|urgent)" logs/improvement-log.md)
   Bash(grep -nE "HIGH|urgent|do-now" logs/friction-log.md | grep -viE "resolved|verified|shipped|archived|declined" | head -n 40)
   ```

   The two files have different shapes, so the two scans do different jobs:
   - **`improvement-log.md` is schema'd** (`### {date} — {title}` / `- **Status:**` / `- **Severity:**`). The `-B6` window is sized to carry each severity hit's **header and status lines** back with it — that is what makes the filter below applicable without a second read. Do not narrow it: at `-B4` the header is lost on entries whose status runs to multiple lines.
   - **`friction-log.md` has no severity field** — its severity words are free text inside prose bullets, and its resolution stamps (`— **Resolved:**`, `[FADING-GATE] verified`) sit on the *same* line as the finding, which is why the same-line `grep -v` works. Treat its hits as **candidates to judge, not findings**: incidental matches are expected (a shell variable named `HIGH`, a quoted phrase), and they are cheap to discard in-context because only the matching lines are returned.

   Then apply the filter to the returned lines only:
   - Include an item only if it carries a HIGH-severity marker (`HIGH`, `urgent`, `critical`, or `do-now` attached to a HIGH item).
   - Exclude anything marked `LOW` or `MED`, and exclude entries whose status is `resolved`, `applied`, `verified`, or operator-`DECLINED`.
   - If either file does not exist, its scan returns nothing — skip silently.

   Each surviving item becomes an **urgent** menu candidate for step 5.

4. **Exception checks.** Compute the following, but carry each to step 6 only when it is abnormal — a normal value is never displayed. **Model alignment (below) is the one exception:** it is always carried to Step 6 regardless of match/mismatch — see its bullet for the display-styling split.
   - **Working tree:** if the environment's git-status snapshot is non-empty, run `git status --short` and `git diff --stat HEAD` once to confirm it is still current. The env snapshot is point-in-time from session start and can be stale vs actual HEAD (e.g., files already committed in the prior session). Carry forward only if the live result shows unexpected uncommitted changes. This is a Prime-time orientation check, distinct from the commit-time "no pre-commit git status" rule.
   - **Model alignment:** read the active session model identifier from the system-prompt context — do not run any external command, the identifier is already in context. Identify the cwd-nearest project `CLAUDE.md` and read its `## Model Selection` section for the project's **recommended posture** (advisory prose — never a declared default; defaults are prohibited per workspace `CLAUDE.md` § Model Tier). Three cases, all defined:
     - **Section present, and it names exactly ONE tier** → compare the session model against it. On match, plain styling (`Model: {session model}`); on mismatch, warning styling with a hint (`⚠ Model: you are on {session model}; this project recommends {recommended} → /model {recommended}`).
     - **Section present, but it names MORE THAN ONE tier** (e.g. "lean Sonnet for routine edits; reach for Opus on plan drafting") → emit the plain line only (`Model: {session model}`). **Never emit a `→ /model` nudge here.** A conditional posture resolves against the *task*, and Step 4 does not yet know the task — collapsing it to a single tier would fire a false downgrade warning at nearly every session start. This is the **normal** shape of the section as `/new-project` step 11a now writes it, not an edge case.
     - **No project `CLAUDE.md`** (session opened at the workspace root) → emit the plain line only (`Model: {session model}`). There is nothing to compare against; do **not** invent a recommendation.
     - **Project `CLAUDE.md` present but carries no `## Model Selection` section** → same as above: emit the plain line only, no warning. This is a *normal* state, not a defect — the section is optional, and a missing one means the project has expressed no preference. (Defined 2026-07-12: previously undefined, and `/new-project` step 11a is the section's only writer, so every project scaffolded before that step existed lands here.)

     Unlike the other checks in this step, ALWAYS carry the model line forward to Step 6.
   - **Pull result:** carry forward the step 0 result only on failure, when there are unpushed commits, or on an `autostash-conflict` (a pop conflict that returned exit 0 — see Step 0). The `autostash-conflict` case is the highest-priority pull exception: the working tree silently holds conflict markers, so the brief must say so.
   - **Phase READMEs.** If the cwd-rooted project has a `work/` directory, scan it (one level deep) for files matching `W*-*-README.md` (or `Wn-*-README.md`). Capture the matching file paths only — do not read file bodies. Skip silently if `work/` is absent or contains no matches. Bounded scan: one `ls`/`find -maxdepth 2`-equivalent; do not recurse deeper.

5. **Build the numbered task menu.** Merge candidates from:
   - Step 1a — still-open Next Steps from the last session → tag `[carryover]`.
   - Step 1b — the scratchpad `## Resume With` line, if any → tag `[carryover]`.
   - Step 1d — each active mission's `## Open threads` unchecked items, but ONLY for missions whose repo (from `ACTIVE_MISSIONS`, Step 1d) equals `CWD_REPO` (Step 0) → tag `[mission:<id>]`. Skip building a candidate for any mission whose repo ≠ `CWD_REPO` — it is not actionable from this checkout (the Step 8a/8c cross-repo guard would stop it anyway). Step 1d's multi-repo scan and those guards are unchanged and remain in place as defense-in-depth. Omit entirely if `ACTIVE_MISSIONS` is empty or none of its entries match `CWD_REPO`.
   - Step 2 — unchecked `next-up.md` items → tag `[next-up]`.
   - Step 3 — unresolved HIGH/urgent problems → tag `[urgent]`.

   Rank: **urgent → mission → carryover → next-up.** Cap the menu at **6 items.** If fewer than 6 candidates exist, show fewer. If zero candidates exist, show no menu (step 6 handles this). A `[mission:<id>]`-tagged item carries its source mission id so the Step 8 binding sub-step can auto-bind without asking.

   Convert each menu item to **one plain-English sentence** (short sentences, common words — the operator is a non-developer):
   - Keep command names and file names literal (`/kb-review`, `next-up.md`).
   - Drop priority codes (`HIGH`/`MED`/`LOW`), status tags, and section anchors (`§3`, `WU3`) from the displayed text — keep a step number only when it aids meaning.
   - Append one short tag: `[urgent]`, `[mission: <id>]`, `[carryover]`, or `[next-up]`. (Every `[mission:<id>]` candidate reaching this step already has repo == `CWD_REPO` per the Step 5 filter above, so no cross-repo tag variant is needed here; the Step 8a/8c cross-repo guards remain in place as defense-in-depth regardless.)

   Example conversions:
   - `**/kb-review Step 7 registry-stub spec contradicts the registry convention** — MED, do-now` → `Fix the /kb-review command — its Step 7 instructions clash with the registry format.`
   - `Resolve Q1 (core v2 motivation) — without it, Goals (§3) cannot be populated` → `Decide the main reason for the KB v2 rebuild — other plan sections are blocked until this is settled.`

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
{⚠ Architectural artifact awaits independent QC — do NOT commit until `/qc-pass` passes (per the QC-PENDING scratchpad at {path}). — only when step 1b surfaced a QC-PENDING scratchpad}
{⚠ Last substantive session ({date}) left no `usage-log` telemetry — run `/usage-analysis` now to backfill it, or wrap future substantive sessions with `/wrap-session +telemetry`. — only when the Step 1 telemetry-gap flag fired}
{◎ Active mission(s): {for each mission in ACTIVE_MISSIONS where mission.repo == CWD_REPO: "<id> — <name>"} — only if at least one same-repo active mission exists; advisory, names the multi-session goal(s) this work can serve}

Next tasks:
  1. {plain-English task}   [{tag}]
  2. {plain-English task}   [{tag}]
  3. {plain-English task}   [{tag}]
  4. {plain-English task}   [{tag}]
  5. {plain-English task}   [{tag}]
  6. {plain-English task}   [{tag}]

Type 1–6 to start that task. Type `auto` to run the #1 item end-to-end with a single approval gate, or `auto 1,3` (or `auto 1 3`) to run several items back-to-back under one combined approval gate. Or tell me something else.

Full backlog & inbox: /open-items
```

   Render only as many numbered lines as step 5 produced (1 to 6). If step 5 produced no menu items, replace the `Next tasks:` block and the `Type 1–6 …` line with the single line: `No tracked next steps — tell me what to work on.`

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

   **Wiring:** 8a and 8b prepend `{mission:<id>}` to the args passed to `/session-start` (which strips and records it — see `session-start.md` Step 1). 8c writes the `- Mission: <id>` bullet inline in its Step 8c.7 mandate block. When `MISSION_ID` is unset, none of this happens.

   **Cross-repo note:** the pre-write cross-repo mission guard (Steps 8a sub-step a0, 8c sub-step 2.5) fires *before* this binding, deriving the picked mission's repo from `ACTIVE_MISSIONS` (Step 1d), not from `MISSION_ID` here — so a wrong-repo pick is caught before any marker/header write. Do not move Step 8m earlier to "cover" that case; the guard already does, and 8m must stay after the write per the marker contract. (8b/free-text needs no guard — there is no `[mission:<id>]` menu item to mis-pick.)

8a. **Task selected by number.**
   1. Resolve the number to its menu item → `TASK_TEXT` (the plain-English task text).
   2. **Plan-mode guard.** If a plan-mode system reminder is present in context (plan mode is active), do NOT run `/session-start` or `/session-plan`, and do NOT write anything. Output:
      > Task {N} noted: {TASK_TEXT}. You're in plan mode — I won't run `/session-start` yet. Exit plan mode when you're ready to execute, then re-send `{N}` (or say `go`) and I'll run `/session-start` and `/session-plan` for this task.

      Then stop.
   3. If plan mode is **not** active:
      a0. **Cross-repo mission guard.** If the picked item is `[mission:<id>]`-sourced AND that mission's repo (from `ACTIVE_MISSIONS`, Step 1d) ≠ `CWD_REPO` (Step 0), STOP before any write and emit:
         > ⚠ This task belongs to mission `{id}`, which lives in `{repo}` — but you're priming in `{CWD_REPO}`. Setting it up here would write the marker/header and run `/session-start` in the *wrong* repo. Open `{repo}` as your session folder and re-run `/prime` there to work on this mission. (Reply `here` to override and set it up in the current repo anyway.)

         Wait for the operator. On `here` → proceed to sub-step a. On anything else → stop, write nothing. A same-repo pick (mission repo == `CWD_REPO`) skips this guard silently. Derive the repo from `ACTIVE_MISSIONS` here, not from Step 8m's later `MISSION_ID` — this guard must fire before the sub-step-a marker/header write.
      a. **Determine this session's marker** (TOCTOU Phase 2+3 atomic — see `docs/session-marker.md` for the canonical contract):

         ```bash
         TODAY=$(date '+%Y-%m-%d')
         # Allocate N = 1 + the highest S{N} seen across FOUR sources, then CLAIM it atomically.
         # Take the MAX of all four; never trust one alone (each sees a different slice of the
         # same S{N} namespace):
         #   (a) logs/.session-marker        — this checkout's last allocation.
         #   (b) session-notes.md, worktree  — headers this checkout has written.
         #   (c) session-notes.md, ALL refs  — headers a WORKTREE session allocated and COMMITTED.
         #   (d) the shared claim dir        — allocations IN FLIGHT in any checkout, committed or not.
         #
         # (d) is the fix for the defect (a)-(c) cannot see. A git worktree is a separate checkout
         # with its own (a) and its own (b), and (c) only sees what has been COMMITTED — so an
         # UNCOMMITTED, in-flight allocation in another checkout is invisible to all three, and two
         # checkouts hand out the SAME S{N}. The duplicate `## <today> — Session S{N}` header then
         # lands the moment the branch merges, breaking the `grep -Fxq` "does my header exist" check
         # that /prime 8a, /session-start Step 3 and /session-plan Step 0 all rely on.
         # Real incidents: 2026-07-13 S6 (committed-header collision → fixed by (c)) and
         # 2026-07-13 S11 (uncommitted in-flight collision → (c) did not cover it; S12 yielded by hand).
         #
         # CLAIMING IS ATOMIC, NOT ADVISORY. `mkdir` is atomic on POSIX: exactly one caller can create
         # a given directory, and every other caller gets EEXIST. So the claim loop below is a genuine
         # mutex across checkouts — not merely a narrower race window. Two /prime runs firing at the
         # same instant CANNOT both win the same S{N}; the loser sees EEXIST and takes the next number.
         #
         # Do NOT "fix" this by making worktrees reserve markers up front — that reintroduces the
         # shared allocator worktrees exist to remove. A claim is made at allocation time, by whoever
         # allocates. Nothing is held; nothing is reserved ahead.
         #
         # ⚠ KNOWN GAP, ACCEPTED (operator call, 2026-07-13 S13): a checkout running an OLD copy of
         # this block neither writes claims nor reads them. `prime.md` is a REAL FILE in a worktree
         # (not a symlink), so a worktree on a branch predating this change keeps allocating blind, and
         # the mutex protects only the checkouts that have it. Not a flaw in the mechanism — the cost of
         # the mechanism living in a branch-tracked file. Refresh (rebase/merge) a long-lived worktree
         # branch before trusting the mutex across it. See docs/session-marker.md § Known gap.
         #
         # FAIL-SAFE INVARIANT — LOAD-BEARING, DO NOT INVERT:
         # HIGH is seeded from the marker file BEFORE any scan, and every scan below only ever RAISES
         # it. So a git failure, a missing common dir, or /prime running outside a git repo degrades to
         # the old marker-file-only behaviour — it can NEVER reset HIGH to 0 and allocate S1 over an
         # existing S5. Any future edit that scans first and consults the marker file second
         # reintroduces exactly that destructive regression. (friction-log.md 2026-07-13.)
         HIGH=0
         if [ -f logs/.session-marker ]; then                         # (a) — seeds HIGH. Must stay first.
           PREV=$(cat logs/.session-marker)
           case "$PREV" in
             "${TODAY} S"*) n="${PREV##*S}"
                            case "$n" in ''|*[!0-9]*) ;; *) [ "$n" -gt "$HIGH" ] && HIGH="$n";; esac;;
           esac
         fi
         for n in $( { grep -hoE "^## ${TODAY} — Session S[0-9]+" logs/session-notes.md 2>/dev/null   # (b)
                       git grep -hoE "^## ${TODAY} — Session S[0-9]+" \
                           $(git for-each-ref --format='%(refname)' refs/heads 2>/dev/null) \
                           -- logs/session-notes.md 2>/dev/null                                       # (c)
                     } | grep -oE '[0-9]+$' ); do
           case "$n" in ''|*[!0-9]*) continue;; esac
           [ "$n" -gt "$HIGH" ] && HIGH="$n"
         done
         # (d) Shared claim dir. Empty CLAIMS => degrade to (a)-(c) silently and safely (fail-safe).
         CLAIMS=""
         GIT_COMMON=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
         if [ -n "$GIT_COMMON" ] && [ -d "$GIT_COMMON" ]; then
           # `--path-format=absolute` is REQUIRED: the bare command returns a RELATIVE `.git` from a
           # main checkout but an ABSOLUTE path from a worktree. Without it this resolves against the
           # wrong cwd. (Verified 2026-07-13.)
           #
           # SCOPE the namespace by the cwd's path INSIDE the repo. Worktrees of one repo share a common
           # dir AND sit at the repo root (empty prefix) → they SHARE a claim namespace, which is exactly
           # what the mutex needs. But a project that is a plain SUBDIRECTORY of a repo — e.g.
           # projects/axcion-website/, which is NOT its own repo yet keeps its own logs/session-notes.md
           # and therefore its own S{N} sequence — would otherwise share a claim namespace with unrelated
           # siblings under the same .git, inflating its S{N}. Scoping keeps namespace == session-notes.
           SCOPE=$(git rev-parse --show-prefix 2>/dev/null | tr -d '\n' | tr -c 'A-Za-z0-9._-' '-')
           [ -z "$SCOPE" ] && SCOPE="_root"
           CLAIMS="$GIT_COMMON/axcion-session-markers/$SCOPE"
           mkdir -p "$CLAIMS" 2>/dev/null || CLAIMS=""
         fi
         if [ -n "$CLAIMS" ]; then
           # `find`, NOT a glob. The Bash tool's real shell is ZSH, where an UNMATCHED glob triggers
           # NOMATCH: the command errors and the loop body never runs — which is exactly the state on
           # the FIRST /prime of every day, in every repo. Under bash the literal survives and `[ -d ]`
           # skips it, so a bash-only test PASSES while the real shell CRASHES. Verified both ways,
           # 2026-07-13 (caught by the end-time /risk-check). Do NOT "simplify" this back to a glob.
           for n in $(find "$CLAIMS" -mindepth 1 -maxdepth 1 -type d -name "${TODAY}-S*" 2>/dev/null \
                      | sed 's|.*-S||'); do
             case "$n" in ''|*[!0-9]*) continue;; esac
             [ "$n" -gt "$HIGH" ] && HIGH="$n"
           done
           # Prune claims not dated today (bounded growth). -type d never follows symlinks here, and
           # -mindepth 1 plus the non-empty CLAIMS guard above make the rm -rf reach nothing outside
           # this directory.
           find "$CLAIMS" -mindepth 1 -maxdepth 1 -type d ! -name "${TODAY}-*" -exec rm -rf {} + 2>/dev/null
         fi
         # Atomic claim loop. mkdir succeeds for exactly one caller; the loser bumps and retries.
         N=$((HIGH + 1))
         while : ; do
           if [ -z "$CLAIMS" ]; then MARKER="S${N}"; break; fi        # no common dir → no mutex, old behaviour
           if mkdir "$CLAIMS/${TODAY}-S${N}" 2>/dev/null; then        # ← the atomic step
             MARKER="S${N}"
             printf '%s\n' "${CLAUDE_CODE_SESSION_ID:-unknown} $(date '+%H:%M:%S')" \
               > "$CLAIMS/${TODAY}-S${N}/owner" 2>/dev/null           # debug breadcrumb only; never read for logic
             break
           fi
           N=$((N + 1))
           if [ "$N" -gt 999 ]; then MARKER="S${N}"; break; fi        # runaway guard — cannot spin forever
         done
         echo "${TODAY} ${MARKER}" > logs/.session-marker
         # Identity oracle (Option 2′): also write a per-session-id marker file no concurrent /prime can clobber.
         [ -n "${CLAUDE_CODE_SESSION_ID}" ] && echo "${TODAY} ${MARKER}" > "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}"
         # Orphan cleanup: prune per-id marker files not dated today.
         for f in logs/.session-marker-*; do
           [ -f "$f" ] || continue
           case "$(cat "$f" 2>/dev/null)" in "${TODAY} "*) ;; *) rm -f "$f";; esac
         done
         ```

         Same-day re-invocations increment within the day (`S1` → `S2` → …); a new day resets to `S1`.

         **Ensure this session's marker-bearing entry exists** in `/logs/session-notes.md`. Check for THIS session's header with a literal whole-line grep (full-file, so immune to entry length; `-Fx` matches the em-dash and `${MARKER}` verbatim with no regex risk):
         ```
         Bash(grep -Fxq "## ${TODAY} — Session ${MARKER}" logs/session-notes.md)
         ```
         **exit 0 → header already present** (rare — same-marker re-invocation): reuse it, append `TASK_TEXT` as a work-description line beneath it. **exit 1 → header absent** (the common case at `/prime` time): append a new `## ${TODAY} — Session ${MARKER}` header with `TASK_TEXT` as the work description. Treat exit 1 strictly as "not found → create", never as "command failed → skip the write" — suppressing this session's header breaks the `/session-start` / `/session-plan` precondition noted below.

         Foreign concurrent sessions write under their own marker-bearing headers (e.g., `## YYYY-MM-DD — Session S2`); those do NOT count as "this session's header." The marker is the disambiguator. The pre-Phase-2 "no duplicate same-day header" rule is replaced by "this session writes only under its own marker-bearing header." This must happen before step c — `/session-start` Step 3 and `/session-plan` Step 0 require THIS session's marker-bearing header to exist.

         **After the append succeeds**, write `session-notes.md`'s mtime to `logs/.prime-mtime` (for `/session-start` Step 0.5's foreign-write check):

         ```bash
         stat -f %m logs/session-notes.md 2>/dev/null > logs/.prime-mtime \
           || stat -c %Y logs/session-notes.md 2>/dev/null > logs/.prime-mtime
         ```

         Order: marker first (top of step a), header append (middle), mtime last. Marker before append so the header can embed `${MARKER}`; mtime after append so `/session-start` Step 0.5's check sees this session's own write.
      a2. **Mission binding.** Run the Step 8m sub-step (skips silently if no active missions). If it resolves a `MISSION_ID`, prepend `{mission:<id>}` to the `/session-start` args in step b.
      b. Invoke the `/session-start` command with `TASK_TEXT` as its arguments (becomes the mandate), prefixed with `{mission:<id>}` if step a2 bound one. It runs its own mandate-confirmation prompt — that is expected; do not suppress it.
      c. After `/session-start` finishes, invoke the `/session-plan` command with `TASK_TEXT` as its arguments (becomes the intent). It writes `logs/session-plan-${TODAY}-${MARKER}.md` (marker-scoped per `docs/session-marker.md`). If THIS session's marker-scoped plan already exists, `/session-plan` Step 0 surfaces a 3-option keep/overwrite/pass2 prompt — that is expected mid-chain; the operator answers it normally.
      d. **Pause.** After `/session-plan` finishes, output:
         > Plan ready — review `logs/session-plan-${TODAY}-${MARKER}.md`. Reply `go` to start execution, or run `/qc-pass` on the plan first.

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
         # Allocate N = 1 + the highest S{N} seen across FOUR sources, then CLAIM it atomically.
         # Take the MAX of all four; never trust one alone (each sees a different slice of the
         # same S{N} namespace):
         #   (a) logs/.session-marker        — this checkout's last allocation.
         #   (b) session-notes.md, worktree  — headers this checkout has written.
         #   (c) session-notes.md, ALL refs  — headers a WORKTREE session allocated and COMMITTED.
         #   (d) the shared claim dir        — allocations IN FLIGHT in any checkout, committed or not.
         #
         # (d) is the fix for the defect (a)-(c) cannot see. A git worktree is a separate checkout
         # with its own (a) and its own (b), and (c) only sees what has been COMMITTED — so an
         # UNCOMMITTED, in-flight allocation in another checkout is invisible to all three, and two
         # checkouts hand out the SAME S{N}. The duplicate `## <today> — Session S{N}` header then
         # lands the moment the branch merges, breaking the `grep -Fxq` "does my header exist" check
         # that /prime 8a, /session-start Step 3 and /session-plan Step 0 all rely on.
         # Real incidents: 2026-07-13 S6 (committed-header collision → fixed by (c)) and
         # 2026-07-13 S11 (uncommitted in-flight collision → (c) did not cover it; S12 yielded by hand).
         #
         # CLAIMING IS ATOMIC, NOT ADVISORY. `mkdir` is atomic on POSIX: exactly one caller can create
         # a given directory, and every other caller gets EEXIST. So the claim loop below is a genuine
         # mutex across checkouts — not merely a narrower race window. Two /prime runs firing at the
         # same instant CANNOT both win the same S{N}; the loser sees EEXIST and takes the next number.
         #
         # Do NOT "fix" this by making worktrees reserve markers up front — that reintroduces the
         # shared allocator worktrees exist to remove. A claim is made at allocation time, by whoever
         # allocates. Nothing is held; nothing is reserved ahead.
         #
         # ⚠ KNOWN GAP, ACCEPTED (operator call, 2026-07-13 S13): a checkout running an OLD copy of
         # this block neither writes claims nor reads them. `prime.md` is a REAL FILE in a worktree
         # (not a symlink), so a worktree on a branch predating this change keeps allocating blind, and
         # the mutex protects only the checkouts that have it. Not a flaw in the mechanism — the cost of
         # the mechanism living in a branch-tracked file. Refresh (rebase/merge) a long-lived worktree
         # branch before trusting the mutex across it. See docs/session-marker.md § Known gap.
         #
         # FAIL-SAFE INVARIANT — LOAD-BEARING, DO NOT INVERT:
         # HIGH is seeded from the marker file BEFORE any scan, and every scan below only ever RAISES
         # it. So a git failure, a missing common dir, or /prime running outside a git repo degrades to
         # the old marker-file-only behaviour — it can NEVER reset HIGH to 0 and allocate S1 over an
         # existing S5. Any future edit that scans first and consults the marker file second
         # reintroduces exactly that destructive regression. (friction-log.md 2026-07-13.)
         HIGH=0
         if [ -f logs/.session-marker ]; then                         # (a) — seeds HIGH. Must stay first.
           PREV=$(cat logs/.session-marker)
           case "$PREV" in
             "${TODAY} S"*) n="${PREV##*S}"
                            case "$n" in ''|*[!0-9]*) ;; *) [ "$n" -gt "$HIGH" ] && HIGH="$n";; esac;;
           esac
         fi
         for n in $( { grep -hoE "^## ${TODAY} — Session S[0-9]+" logs/session-notes.md 2>/dev/null   # (b)
                       git grep -hoE "^## ${TODAY} — Session S[0-9]+" \
                           $(git for-each-ref --format='%(refname)' refs/heads 2>/dev/null) \
                           -- logs/session-notes.md 2>/dev/null                                       # (c)
                     } | grep -oE '[0-9]+$' ); do
           case "$n" in ''|*[!0-9]*) continue;; esac
           [ "$n" -gt "$HIGH" ] && HIGH="$n"
         done
         # (d) Shared claim dir. Empty CLAIMS => degrade to (a)-(c) silently and safely (fail-safe).
         CLAIMS=""
         GIT_COMMON=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
         if [ -n "$GIT_COMMON" ] && [ -d "$GIT_COMMON" ]; then
           # `--path-format=absolute` is REQUIRED: the bare command returns a RELATIVE `.git` from a
           # main checkout but an ABSOLUTE path from a worktree. Without it this resolves against the
           # wrong cwd. (Verified 2026-07-13.)
           #
           # SCOPE the namespace by the cwd's path INSIDE the repo. Worktrees of one repo share a common
           # dir AND sit at the repo root (empty prefix) → they SHARE a claim namespace, which is exactly
           # what the mutex needs. But a project that is a plain SUBDIRECTORY of a repo — e.g.
           # projects/axcion-website/, which is NOT its own repo yet keeps its own logs/session-notes.md
           # and therefore its own S{N} sequence — would otherwise share a claim namespace with unrelated
           # siblings under the same .git, inflating its S{N}. Scoping keeps namespace == session-notes.
           SCOPE=$(git rev-parse --show-prefix 2>/dev/null | tr -d '\n' | tr -c 'A-Za-z0-9._-' '-')
           [ -z "$SCOPE" ] && SCOPE="_root"
           CLAIMS="$GIT_COMMON/axcion-session-markers/$SCOPE"
           mkdir -p "$CLAIMS" 2>/dev/null || CLAIMS=""
         fi
         if [ -n "$CLAIMS" ]; then
           # `find`, NOT a glob. The Bash tool's real shell is ZSH, where an UNMATCHED glob triggers
           # NOMATCH: the command errors and the loop body never runs — which is exactly the state on
           # the FIRST /prime of every day, in every repo. Under bash the literal survives and `[ -d ]`
           # skips it, so a bash-only test PASSES while the real shell CRASHES. Verified both ways,
           # 2026-07-13 (caught by the end-time /risk-check). Do NOT "simplify" this back to a glob.
           for n in $(find "$CLAIMS" -mindepth 1 -maxdepth 1 -type d -name "${TODAY}-S*" 2>/dev/null \
                      | sed 's|.*-S||'); do
             case "$n" in ''|*[!0-9]*) continue;; esac
             [ "$n" -gt "$HIGH" ] && HIGH="$n"
           done
           # Prune claims not dated today (bounded growth). -type d never follows symlinks here, and
           # -mindepth 1 plus the non-empty CLAIMS guard above make the rm -rf reach nothing outside
           # this directory.
           find "$CLAIMS" -mindepth 1 -maxdepth 1 -type d ! -name "${TODAY}-*" -exec rm -rf {} + 2>/dev/null
         fi
         # Atomic claim loop. mkdir succeeds for exactly one caller; the loser bumps and retries.
         N=$((HIGH + 1))
         while : ; do
           if [ -z "$CLAIMS" ]; then MARKER="S${N}"; break; fi        # no common dir → no mutex, old behaviour
           if mkdir "$CLAIMS/${TODAY}-S${N}" 2>/dev/null; then        # ← the atomic step
             MARKER="S${N}"
             printf '%s\n' "${CLAUDE_CODE_SESSION_ID:-unknown} $(date '+%H:%M:%S')" \
               > "$CLAIMS/${TODAY}-S${N}/owner" 2>/dev/null           # debug breadcrumb only; never read for logic
             break
           fi
           N=$((N + 1))
           if [ "$N" -gt 999 ]; then MARKER="S${N}"; break; fi        # runaway guard — cannot spin forever
         done
         echo "${TODAY} ${MARKER}" > logs/.session-marker
         # Identity oracle (Option 2′): also write a per-session-id marker file no concurrent /prime can clobber.
         [ -n "${CLAUDE_CODE_SESSION_ID}" ] && echo "${TODAY} ${MARKER}" > "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}"
         # Orphan cleanup: prune per-id marker files not dated today.
         for f in logs/.session-marker-*; do
           [ -f "$f" ] || continue
           case "$(cat "$f" 2>/dev/null)" in "${TODAY} "*) ;; *) rm -f "$f";; esac
         done
         ```

         Check for THIS session's header with a literal whole-line grep (full-file, immune to entry length; `-Fx` matches the em-dash verbatim):
         ```
         Bash(grep -Fxq "## ${TODAY} — Session ${MARKER}" logs/session-notes.md)
         ```
         **exit 0** → reuse the existing header, append `TASK_TEXT`. **exit 1** → create a new `## ${TODAY} — Session ${MARKER}` header with `TASK_TEXT`. Exit 1 means "not found → create", never "command failed → skip".

         **After the append succeeds**, write `session-notes.md`'s mtime to `logs/.prime-mtime`:

         ```bash
         stat -f %m logs/session-notes.md 2>/dev/null > logs/.prime-mtime \
           || stat -c %Y logs/session-notes.md 2>/dev/null > logs/.prime-mtime
         ```

         Order: marker → header append → mtime (same contract as Step 8a.3.a).
      a2. **Mission binding.** Run the Step 8m sub-step (skips silently if no active missions). If it resolves a `MISSION_ID`, prepend `{mission:<id>}` to the `/session-start` args in step b.
      b. Invoke the `/session-start` command with `TASK_TEXT` as its arguments (becomes the mandate), prefixed with `{mission:<id>}` if step a2 bound one. It runs its own mandate-confirmation prompt — that is expected; do not suppress it.
      c. After `/session-start` finishes, invoke the `/session-plan` command with `TASK_TEXT` as its arguments (becomes the intent). It writes `logs/session-plan-${TODAY}-${MARKER}.md` (marker-scoped per `docs/session-marker.md`). If THIS session's marker-scoped plan already exists, `/session-plan` Step 0 surfaces a 3-option keep/overwrite/pass2 prompt — that is expected mid-chain; the operator answers it normally.
      d. **Begin execution immediately** under full autonomy (per workspace CLAUDE.md Autonomy Rules). No second `go`/`proceed` confirmation required — the operator stating the work directly IS the go signal. This is 8b's structural delta vs 8a, which pauses for explicit `go` after `/session-plan`.

8c. **Auto mode.** The operator typed `auto` (optionally with item numbers) — run the picked menu item(s) end-to-end with a single combined approval gate and no per-stage prompts.

   1. **Resolve PICKED_ITEMS.** Parse the operator's reply:
      - `auto` / `a` (no number) → `PICKED_ITEMS` = [item #1 from the menu built in Step 5].
      - `auto N` — or the equivalent `N auto` shape (`^[1-6]\s+auto$`, normalized by Step 7) → `PICKED_ITEMS` = [item #N].
      - `auto N,M,...` or `auto N M ...` → `PICKED_ITEMS` = [item #N, item #M, ...] in the order the operator gave them. Deduplicate while preserving first-seen order.

      Validate that every requested number is within the rendered menu range. If any number is out of range, ask once for a valid `auto` reply and re-classify (per Step 7 ambiguity rule). If the menu has zero items, output `No tracked next steps — auto mode needs a task. Tell me what to work on.` and stop.

      `PICKED_ITEMS_TEXT` is a short comma-joined preview of the picked items' plain-English text (used in operator-facing messages below). `SINGLE_ITEM` is true when `PICKED_ITEMS` has exactly one entry.

   1.5. **Per-item done-condition presence-check.** Before any disk write (marker, header, mandate, plan — all at Step 8c.3 and later), verify every picked item carries a derivable done-condition. An auto-bundle that includes an unscoped item wastes the single approval gate (and any `/risk-check`) on work that cannot be graded — the item is recognized as unscoped only mid-execution, after the gate has passed (logged: vault W2.4 finding #1 + session-harness friday-act #4, 2026-06-04 S6 — "review the System Owner reference files" entered the executable set with no specifiable done-condition).

      For each item in `PICKED_ITEMS`, attempt to derive a one-line done-condition — an observable deliverable, check, or target (file written, item checked off, finding addressed, commit landed, count reached). The item text plus its source (the `[urgent]` / `[carryover]` / `[next-up]` line it came from) is the evidence. An item whose text names only an activity with no observable end-state (e.g. "review X", "look into Y", "think about Z") and whose source line supplies no target fails the check.

      - **All items pass** → proceed to Step 8c.2 unchanged.
      - **One or more items fail** → hold the failing items back. Do NOT write anything yet. Emit:

        > Auto mode — {K} of {N} picked items have no concrete done-condition and were held back:
        > {for each held item: `  • {item text} — needs a concrete deliverable (file / check / target). Define it, then re-pick this item.`}
        >
        > {if any items passed:} I can proceed with the {M} scoped item(s): {passed-items-text}. Reply `go` to run those, or restate the held item(s) with a deliverable.
        > {if zero items passed:} Restate the held item(s) with a deliverable (file / check / target), then re-send `auto`.

        On `go` with a non-empty passed set → set `PICKED_ITEMS` to the passed subset (preserve order), recompute `PICKED_ITEMS_TEXT` / `SINGLE_ITEM`, and proceed to Step 8c.2. On a restated item → re-run this check against the restatement. If zero items passed and the operator does not restate, stop without writing.

   2. **Plan-mode guard.** If a plan-mode system reminder is present in context, output: `Auto mode noted: {PICKED_ITEMS_TEXT}. You're in plan mode — I won't write anything yet. Exit plan mode and re-send 'auto' (or 'go') to proceed.` Then stop.

   2.5. **Cross-repo mission guard (deliberate auto-mode exception).** Before the Step 8c.3 marker/header write: if any picked item is `[mission:<id>]`-sourced AND that mission's repo (from `ACTIVE_MISSIONS`, Step 1d) ≠ `CWD_REPO` (Step 0), STOP and emit the same wrong-repo warning as Step 8a's cross-repo guard, listing each offending picked item and its repo. Wait; on `here` → proceed to 8c.3; on anything else → stop, write nothing. This is a **deliberate single-condition exception** to auto mode's "single approval gate, no per-stage prompts" contract (fires ONLY when a picked mission's repo ≠ `CWD_REPO`) — do not remove it as a stray prompt. It is load-bearing here because the 8c.3 header write precedes the 8c.6 approval gate, so this is the only point that stops a wrong-repo header before disk. Derive the repo from `ACTIVE_MISSIONS`, not from the Step 8c.3.5 auto-bind (which runs after the write). Same-repo picks skip it silently.

   3. **Marker resolution + marker-bearing header + mtime marker** (same contract as Step 8a.3.a — see `docs/session-marker.md`):

      ```bash
      TODAY=$(date '+%Y-%m-%d')
      # Allocate N = 1 + the highest S{N} seen across FOUR sources, then CLAIM it atomically.
      # Take the MAX of all four; never trust one alone (each sees a different slice of the
      # same S{N} namespace):
      #   (a) logs/.session-marker        — this checkout's last allocation.
      #   (b) session-notes.md, worktree  — headers this checkout has written.
      #   (c) session-notes.md, ALL refs  — headers a WORKTREE session allocated and COMMITTED.
      #   (d) the shared claim dir        — allocations IN FLIGHT in any checkout, committed or not.
      #
      # (d) is the fix for the defect (a)-(c) cannot see. A git worktree is a separate checkout
      # with its own (a) and its own (b), and (c) only sees what has been COMMITTED — so an
      # UNCOMMITTED, in-flight allocation in another checkout is invisible to all three, and two
      # checkouts hand out the SAME S{N}. The duplicate `## <today> — Session S{N}` header then
      # lands the moment the branch merges, breaking the `grep -Fxq` "does my header exist" check
      # that /prime 8a, /session-start Step 3 and /session-plan Step 0 all rely on.
      # Real incidents: 2026-07-13 S6 (committed-header collision → fixed by (c)) and
      # 2026-07-13 S11 (uncommitted in-flight collision → (c) did not cover it; S12 yielded by hand).
      #
      # CLAIMING IS ATOMIC, NOT ADVISORY. `mkdir` is atomic on POSIX: exactly one caller can create
      # a given directory, and every other caller gets EEXIST. So the claim loop below is a genuine
      # mutex across checkouts — not merely a narrower race window. Two /prime runs firing at the
      # same instant CANNOT both win the same S{N}; the loser sees EEXIST and takes the next number.
      #
      # Do NOT "fix" this by making worktrees reserve markers up front — that reintroduces the
      # shared allocator worktrees exist to remove. A claim is made at allocation time, by whoever
      # allocates. Nothing is held; nothing is reserved ahead.
      #
      # ⚠ KNOWN GAP, ACCEPTED (operator call, 2026-07-13 S13): a checkout running an OLD copy of
      # this block neither writes claims nor reads them. `prime.md` is a REAL FILE in a worktree
      # (not a symlink), so a worktree on a branch predating this change keeps allocating blind, and
      # the mutex protects only the checkouts that have it. Not a flaw in the mechanism — the cost of
      # the mechanism living in a branch-tracked file. Refresh (rebase/merge) a long-lived worktree
      # branch before trusting the mutex across it. See docs/session-marker.md § Known gap.
      #
      # FAIL-SAFE INVARIANT — LOAD-BEARING, DO NOT INVERT:
      # HIGH is seeded from the marker file BEFORE any scan, and every scan below only ever RAISES
      # it. So a git failure, a missing common dir, or /prime running outside a git repo degrades to
      # the old marker-file-only behaviour — it can NEVER reset HIGH to 0 and allocate S1 over an
      # existing S5. Any future edit that scans first and consults the marker file second
      # reintroduces exactly that destructive regression. (friction-log.md 2026-07-13.)
      HIGH=0
      if [ -f logs/.session-marker ]; then                         # (a) — seeds HIGH. Must stay first.
        PREV=$(cat logs/.session-marker)
        case "$PREV" in
          "${TODAY} S"*) n="${PREV##*S}"
                         case "$n" in ''|*[!0-9]*) ;; *) [ "$n" -gt "$HIGH" ] && HIGH="$n";; esac;;
        esac
      fi
      for n in $( { grep -hoE "^## ${TODAY} — Session S[0-9]+" logs/session-notes.md 2>/dev/null   # (b)
                    git grep -hoE "^## ${TODAY} — Session S[0-9]+" \
                        $(git for-each-ref --format='%(refname)' refs/heads 2>/dev/null) \
                        -- logs/session-notes.md 2>/dev/null                                       # (c)
                  } | grep -oE '[0-9]+$' ); do
        case "$n" in ''|*[!0-9]*) continue;; esac
        [ "$n" -gt "$HIGH" ] && HIGH="$n"
      done
      # (d) Shared claim dir. Empty CLAIMS => degrade to (a)-(c) silently and safely (fail-safe).
      CLAIMS=""
      GIT_COMMON=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
      if [ -n "$GIT_COMMON" ] && [ -d "$GIT_COMMON" ]; then
        # `--path-format=absolute` is REQUIRED: the bare command returns a RELATIVE `.git` from a
        # main checkout but an ABSOLUTE path from a worktree. Without it this resolves against the
        # wrong cwd. (Verified 2026-07-13.)
        #
        # SCOPE the namespace by the cwd's path INSIDE the repo. Worktrees of one repo share a common
        # dir AND sit at the repo root (empty prefix) → they SHARE a claim namespace, which is exactly
        # what the mutex needs. But a project that is a plain SUBDIRECTORY of a repo — e.g.
        # projects/axcion-website/, which is NOT its own repo yet keeps its own logs/session-notes.md
        # and therefore its own S{N} sequence — would otherwise share a claim namespace with unrelated
        # siblings under the same .git, inflating its S{N}. Scoping keeps namespace == session-notes.
        SCOPE=$(git rev-parse --show-prefix 2>/dev/null | tr -d '\n' | tr -c 'A-Za-z0-9._-' '-')
        [ -z "$SCOPE" ] && SCOPE="_root"
        CLAIMS="$GIT_COMMON/axcion-session-markers/$SCOPE"
        mkdir -p "$CLAIMS" 2>/dev/null || CLAIMS=""
      fi
      if [ -n "$CLAIMS" ]; then
        # `find`, NOT a glob. The Bash tool's real shell is ZSH, where an UNMATCHED glob triggers
        # NOMATCH: the command errors and the loop body never runs — which is exactly the state on
        # the FIRST /prime of every day, in every repo. Under bash the literal survives and `[ -d ]`
        # skips it, so a bash-only test PASSES while the real shell CRASHES. Verified both ways,
        # 2026-07-13 (caught by the end-time /risk-check). Do NOT "simplify" this back to a glob.
        for n in $(find "$CLAIMS" -mindepth 1 -maxdepth 1 -type d -name "${TODAY}-S*" 2>/dev/null \
                   | sed 's|.*-S||'); do
          case "$n" in ''|*[!0-9]*) continue;; esac
          [ "$n" -gt "$HIGH" ] && HIGH="$n"
        done
        # Prune claims not dated today (bounded growth). -type d never follows symlinks here, and
        # -mindepth 1 plus the non-empty CLAIMS guard above make the rm -rf reach nothing outside
        # this directory.
        find "$CLAIMS" -mindepth 1 -maxdepth 1 -type d ! -name "${TODAY}-*" -exec rm -rf {} + 2>/dev/null
      fi
      # Atomic claim loop. mkdir succeeds for exactly one caller; the loser bumps and retries.
      N=$((HIGH + 1))
      while : ; do
        if [ -z "$CLAIMS" ]; then MARKER="S${N}"; break; fi        # no common dir → no mutex, old behaviour
        if mkdir "$CLAIMS/${TODAY}-S${N}" 2>/dev/null; then        # ← the atomic step
          MARKER="S${N}"
          printf '%s\n' "${CLAUDE_CODE_SESSION_ID:-unknown} $(date '+%H:%M:%S')" \
            > "$CLAIMS/${TODAY}-S${N}/owner" 2>/dev/null           # debug breadcrumb only; never read for logic
          break
        fi
        N=$((N + 1))
        if [ "$N" -gt 999 ]; then MARKER="S${N}"; break; fi        # runaway guard — cannot spin forever
      done
      echo "${TODAY} ${MARKER}" > logs/.session-marker
      # Identity oracle (Option 2′): also write a per-session-id marker file no concurrent /prime can clobber.
      [ -n "${CLAUDE_CODE_SESSION_ID}" ] && echo "${TODAY} ${MARKER}" > "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}"
      # Orphan cleanup: prune per-id marker files not dated today.
      for f in logs/.session-marker-*; do
        [ -f "$f" ] || continue
        case "$(cat "$f" 2>/dev/null)" in "${TODAY} "*) ;; *) rm -f "$f";; esac
      done
      ```

      Check for THIS session's header with a literal whole-line grep (full-file, immune to entry length; `-Fx` matches the em-dash verbatim):
      ```
      Bash(grep -Fxq "## ${TODAY} — Session ${MARKER}" logs/session-notes.md)
      ```
      **exit 0** → reuse the existing header, append the work-description line. **exit 1** → create a new `## ${TODAY} — Session ${MARKER}` header. Exit 1 means "not found → create", never "command failed → skip".

      Work-description line text:
      - If `SINGLE_ITEM`: the picked item's plain-English text.
      - If multi-item: `Auto multi-item: {item-N text}; {item-M text}; ...` listing every picked item separated by `;` in operator order.

      Then write `logs/.prime-mtime` (after the header append, never before):

      ```bash
      stat -f %m logs/session-notes.md 2>/dev/null > logs/.prime-mtime \
        || stat -c %Y logs/session-notes.md 2>/dev/null > logs/.prime-mtime
      ```

   3.5. **Mission binding (auto-bind only).** Run the Step 8m sub-step in **auto-bind-only mode**: if any picked item is `[mission:<id>]`-sourced, set `MISSION_ID` to that mission (first such, if several). **Do NOT emit the interactive binding prompt in auto mode** — auto mode's contract is a single approval gate with no per-stage prompts. If no picked item is mission-sourced, `MISSION_ID` stays unset. The bound mission (if any) is disclosed in the Step 8c.6 approval gate and written as the `- Mission:` bullet in Step 8c.7.

   4. **Derive mandate fields** inline (matches `/session-start` Step 2 logic without the confirmation prompt). Apply to each picked item, then compose:
      - `work_scope` — one sentence naming the work and its concrete deliverable. For `SINGLE_ITEM`, derived from the picked item. For multi-item, compose as `Complete picked menu items: (1) {item-N work + deliverable}; (2) {item-M work + deliverable}; ...` listing every picked item.
      - `exit_condition` — an observable condition (file written, item checked off, finding addressed, commit landed). For `SINGLE_ITEM`, the item's exit. For multi-item, `all picked items closed in their respective source files` unless every item shares a single concrete exit, in which case use that.
      - `out_of_scope` — `(none stated)` unless any picked item explicitly bounds itself; in multi-item mode, combine any bounds with `;`.
      - `files_in_scope` — union of inferred source paths across all picked items. Flag as `(inferred)` per `/session-start` Step 3 convention.
      - `stop_if` — `(none stated)` unless any picked item carries a `[BLOCKING]`-style halt condition; if multiple do, combine with `;`.
      - `allowed_inputs`, `required_outputs` — leave absent (no `(none stated)` placeholder).

   4.5. **Context discovery (engine pre-step).** Optionally invoke the **`context-discovery` agent** to pre-populate `files_in_scope` / `allowed_inputs` / `required_outputs` from the active project's CLAUDE.md routing map. Mirrors `/session-start` Step 2.4 but runs inline without re-emit (the Step 8c.6 approval gate is the operator's first sight of the mandate).

      **Skip silently if any of these conditions hold** — no warning, no agent invocation, proceed to Step 8c.5:

      a. `work_scope` is fewer than 5 whitespace-separated tokens.
      b. `work_scope` matches a known meta-command literal: `/prime`, `/open-items`, `/wrap-session`, `/handoff`, `/clear`.
      c. No `CLAUDE.md` exists at the project root: `! [ -f "$(git rev-parse --show-toplevel 2>/dev/null)/CLAUDE.md" ]`.

      **Otherwise, invoke the agent** via the Agent tool with `subagent_type: context-discovery` and three fields:

      - `TASK_DESCRIPTION = {work_scope}` (from Step 8c.4)
      - `CWD_PROJECT = $(git rev-parse --show-toplevel)`
      - `INVOCATION_MODE = auto-prime`

      Parse the agent's first line for outcome class per `ai-resources/docs/context-pack-schema.md § 5b`:

      | First line shape | Outcome | Action |
      |---|---|---|
      | `**Pack:** {abs path} \| tracked` or `\| untracked` | `success-enriched` or `success-insufficient` (read readiness booleans in summary lines 5–6 to distinguish) | Read pack frontmatter; apply fields below |
      | `**Pack:** (skipped — {reason})` | `engine-skipped` | Carry no pack; proceed to 8c.5 |
      | `**Pack:** (none — engine failed){...}` | `engine-error` | Log one chat line: `Note: context engine failed — {cause from summary, or "no cause given"}. Proceeding with derived mandate.` Carry no pack |

      **No timeout enforcement.** The Agent tool runs to completion; the engine is best-effort. If it never returns, the chain stalls — operator can interrupt and re-invoke without the engine pre-step.

      **For `success-enriched` and `success-insufficient`:** Read the pack file at the path from line 1. Parse YAML frontmatter for `files_in_scope`, `allowed_inputs`, `required_outputs`, `sufficient_to_plan`, `sufficient_to_implement`.

      Apply to derived mandate state:
      1. `files_in_scope` — REPLACE the `(inferred)` value from Step 8c.4 with the engine's concrete list.
      2. `allowed_inputs` — SET to engine value if absent in Step 8c.4.
      3. `required_outputs` — SET to engine value if absent in Step 8c.4.
      4. Capture `PACK_PATH` (line 1), `PACK_TRACKED` (`tracked` or `untracked` token from line 1), `PACK_OUTCOME` (`success-enriched` or `success-insufficient`), and `PACK_INSUFFICIENT_NOTE` if `success-insufficient` (one short sentence: `"sufficient_to_implement=false, {N} missing-context items"`).

      Carry `PACK_PATH`, `PACK_TRACKED`, `PACK_OUTCOME`, `PACK_INSUFFICIENT_NOTE` forward to Step 8c.6 (approval gate) and Step 8c.7 (mandate write).

   5. **Derive plan fields** inline (matches `/session-plan` Step 2 + 5–7 logic without the per-stage prompts):
      - `INTENT` — one-sentence summary. For `SINGLE_ITEM`, the item's summary. For multi-item, e.g. `Run {N} picked menu items in order: {short label-1}; {short label-2}; ...`.
      - `RECOMMENDED_MODEL` — apply `/session-plan` Step 2 three-tier heuristic (deciding → opus; doing → sonnet; mechanical → haiku) to the picked items as a whole. For multi-item, pick the higher-cognitive-load tier across the set (e.g., one deciding item + four doing items → opus). Compare to `ACTIVE_MODEL` from the system-prompt context. Emit `→ /model {shortname}` on mismatch.
      - `AUTONOMY_POSTURE` — `Full autonomy` default; downgrade to `Gated` if any picked item touches structural change classes (hook edits, permission changes, cross-cutting CLAUDE.md edits, new commands/skills, new symlinks, new always-loaded content, automation with shared-state effects — full list: `ai-resources/docs/audit-discipline.md`).
      - `STRUCTURAL_RISK` — boolean: true if any picked item triggers any structural class.

   6. **Single approval gate.** Emit one block — this is the only operator-facing pause in auto mode, regardless of how many items were picked. The block below uses chat-echo styling (icons `→` / `·`, multi-bullet layout); the disk-write at Step 8c.7 follows the load-bearing parse contract instead. Do not propagate the gate-block styling to the disk write.

      For `SINGLE_ITEM`, render the **Picked item** line as `**Picked item:** {item text}` with a single **Source** line.

      For multi-item, replace the single **Picked item** / **Source** pair with a `**Picked items:**` numbered list — one line per picked item with its menu number, plain-English text, and source path link. Example:

      ```
      **Picked items:**
        1. {item-1 text}  ·  [{source-1 path}]({source-1 path})
        3. {item-3 text}  ·  [{source-3 path}]({source-3 path})
        5. {item-5 text}  ·  [{source-5 path}]({source-5 path})
      ```

      Full gate block:

      ```
      ## Auto Mode — {YYYY-MM-DD}

      {single-item: **Picked item:** {item text}  /  **Source:** [{source path}]({source path})}
      {multi-item: **Picked items:** block as shown above}

      **Mandate**
      → Work: {work_scope} — complete fully within this session where context allows.
      · Out of scope: {out_of_scope}
      · Files in scope: {files_in_scope_written}{ (inferred) if applicable}
      · Done when: {exit_condition}
      · Stop if: {stop_if}
      {· Mission: {MISSION_ID} — only if Step 8c.3.5 bound one}

      {if PACK_PATH is set (Step 8c.4.5 produced a pack):}
      **Context pack** — {PACK_OUTCOME} ({PACK_TRACKED})
      → `{PACK_PATH}`
      {if PACK_OUTCOME == success-insufficient:}
      ⚠ {PACK_INSUFFICIENT_NOTE} — review missing-context items in the pack before execution.

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

   6.5. **`Files in scope` mechanical check (pre-write).** Auto mode has no `/session-start` Step 2.5 equivalent — it derives `files_in_scope` at Step 8c.4 and writes it at 8c.7 with **nothing in between** — which makes it the *less* guarded of the two mandate-writing paths, and the one the operator never sees the field on before it lands. Apply `/session-start` Step 2.5 check 3 verbatim before the write:

   a. **Shape test — HARD REJECT.** Every entry must look like a path (contains `/`, or a known extension, or is a bare `CLAUDE.md`/`SKILL.md`; globs pass). **Prose never reaches disk.** `(inferred)` remains the one legal non-listed shape. On failure, re-derive mechanically — `git diff --name-only`, `find`, `grep -rl` — and paste the output.
   b. **Existence test — HARD REJECT, made safe by routing.** `test -e` each entry. A file this session will **create** is not a file *in scope* — it is a **required output**, and the mandate has a field for it (`- Required outputs:`). Route it there; then everything left in `files_in_scope` already exists, and the hard reject carries zero false-positive risk. Auto mode derives both fields itself at Step 8c.4, so it can do this routing without asking. *(A "warn, never reject" variant was cut on 2026-07-14 System-Owner review — a warning is a soft nudge to a model that can rationalise past it, which is the exact failure this check exists to stop. Do not re-weaken it.)*

   **The companion rule: paste the paths themselves, from a command's output. A reference to the command is not a footprint** — its consumer (`check-foreign-staging.sh`) is a parser, not a reader, and a prose footprint makes that guard **fail open**, leaving the session with no staging protection while appearing to have declared a scope.

   *(Added 2026-07-14. The five-for-five recall-assertion pattern in `logs/improvement-log.md` is the trigger; the fifth instance was committed **inside the session shipping this check**, in the prompt handed to the reviewer whose job was to catch it. The habit is not "I forget to check" — it is that a plausible recollection is indistinguishable from an observation from the inside. Only the machine separates them, so the machine has to do it.)*

   7. **Write mandate.** Locate today's `## YYYY-MM-DD` header in `logs/session-notes.md`. **Append the mandate line immediately after the header, before any existing body content** — placement contract identical to `/session-start` Step 3. Format identical to `/session-start` Step 3 exact bullet structure:

      ```
      **Mandate:** {work_scope} — done when: {exit_condition}
      - Out of scope: {out_of_scope}
      - Files in scope: {files_in_scope_written}
      - Stop if: {stop_if}
      - Allowed inputs: {allowed_inputs}      ← write only if set; omit the bullet entirely if absent
      - Required outputs: {required_outputs}  ← write only if set; omit if absent
      - Context pack: {PACK_PATH}             ← write only if Step 8c.4.5 produced a pack; omit if absent
      - Mission: {MISSION_ID}                 ← write only if Step 8c.3.5 bound a mission; omit if absent
      ```

      **Parse contract:** the `**Mandate:**` line shape, the bullet labels (`- Out of scope:`, `- Files in scope:`, `- Stop if:`, `- Allowed inputs:`, `- Required outputs:`), and the `(inferred)` / `(none stated)` markers are load-bearing. Four downstream readers depend on them (verified pre-flight, 2026-05-29): canonical `/wrap-session` Step 7a, workspace-root `wrap-session.md` Step 2b, `/drift-check` Step 5, and `/contract-check` Step 2.5c. Do not insert extra prose into the `**Mandate:**` line itself or rename labels. The "complete fully within this session where context allows" posture lives in Step 8c.10's execution behavior, not in the mandate line — keeping it out of the disk-write preserves the two-segment parse contract (head ` — done when: ` tail).

      The `- Context pack:` bullet (added 2026-05-29 for the Context Engine Phase 2) and the `- Mission:` bullet (added 2026-06-09 for the mission-contract subsystem) are **informational pass-through, not part of the five-label parse contract.** All four readers above use fixed-list extraction or labeled-bullet pass-through; they silently ignore both. The `- Context pack:` bullet locates the pack; the `- Mission:` bullet records which multi-session mission this session served and is read by **`/drift-check` only**, as a second reference standard (see `docs/session-marker.md` § Mandate-line bullet contract).

   7.5. **Write the run-manifest start-stub (W3.2 R3).** After the mandate line lands on disk, write this session's durable start-stub. Auto mode never calls `/session-start`, so without this step every auto-mode session would be invisible to crash/orphan detection — the exact blind spot R3 exists to close. Schema: `docs/spine-schemas.md` § 1. Mirrors `/session-start` Step 3.5; keep the two in sync.

      > **⚠ `MARKER`, `MISSION_ID`, and `PACK_PATH` are values YOU hold from earlier steps — NOT shell variables.** Each Bash call gets a fresh shell (env vars do not persist across tool calls), so `--marker "${MARKER}"` would expand empty and no stub would be written. **Substitute the literal values**; omit a flag whose value is unset. `--date` / `--marker` may be omitted entirely — the script self-resolves them from the marker oracle written in step 3 above.

      ```bash
      d="$(pwd)"; RM=""
      while [ "$d" != "/" ]; do
        for cand in "$d/ai-resources/logs/scripts/run-manifest.sh" "$d/logs/scripts/run-manifest.sh"; do
          [ -f "$cand" ] && { RM="$cand"; break 2; }
        done
        d=$(dirname "$d")
      done
      # Marker + date omitted on purpose — the script resolves them itself.
      # Add --mission / --pack-path ONLY if this session actually bound one.
      [ -n "$RM" ] && bash "$RM" start \
        --model "<the active session model identifier, e.g. claude-opus-4-8[1m]>" \
        --mandate-ref "logs/session-notes.md#<today>-<MARKER>" \
        --mission "<MISSION_ID from step 3.5 — omit this flag if none was bound>" \
        --pack-path "<PACK_PATH from step 4.5 — omit this flag if no pack>"
      ```

      `start` is idempotent. If the walk-up finds no script, skip silently — an additive durable-state substrate must never block the auto-mode chain. **Not a gate** (`principles.md § OP-5`): nothing reads the manifest yet.

   8. **Write plan.** Write to `logs/session-plan-${TODAY}-${MARKER}.md` (marker + date resolved in step 3; canonical contract `docs/session-marker.md`) using `/session-plan` Step 7 schema (`## Intent`, `## Model`, `## Source Material`, `## Findings / Items to Address`, `## Execution Sequence`, `## Scope Alternatives`, `## Autonomy Posture`, `## Risk`). Apply `/session-plan` Step 7 self-check (length floor ≥25 substantive lines, concrete Findings, concrete Execution Sequence, realistic Scope Alternatives).

      For multi-item auto, structure the plan so each picked item is visible:
      - `## Source Material` lists every picked item's source path (one bullet per item).
      - `## Findings / Items to Address` has one subsection (`### Item N — {short label}`) per picked item, capturing the concrete findings for that item.
      - `## Execution Sequence` groups stages by picked item in the operator-given order (e.g., `### Stage 1 — Item 1: {label}`, `### Stage 2 — Item 3: {label}`, …). No per-item operator pause between stages — the single approval gate at Step 8c.6 covers them all.

      Under TOCTOU Phase 2+3 atomic, no concurrent-session collision check is needed — each session writes its own marker-scoped plan, so foreign-session collisions are structurally impossible.

   9. **Run `/risk-check` if STRUCTURAL_RISK is true.** This is the plan-time gate per workspace Autonomy Rules #9. The single approval gate at step 8c.6 disclosed this in advance, so the operator is not surprised. Verdict handling:
       - **GO** → proceed to 8c.10.
       - **RECONSIDER / NO-GO** → output `Risk-check verdict: {verdict}. Mandate and plan retained on disk. Auto mode paused — review {risk-check report path} before resuming.` Stop. The plan and mandate stay on disk for the operator to revise.

       If STRUCTURAL_RISK is false, skip this step silently.

   10. **Begin execution under {AUTONOMY_POSTURE}.** No further confirmation gate — the Step 8c.6 approval covered execution for every picked item. For multi-item auto, run the items in the operator-given order; do NOT pause between items. Complete the mandate fully within this session where context allows; if context is clearly constrained (extended session, approaching compaction), follow the workspace `Context constraint deferral` rule — flag the deferral and log it, do not rush. Between items, emit a brief between-gate summary per workspace `Between-gate summaries` rule (one short line: what just finished, what's next).

       **During execution:**
       - Run `/qc-pass` on substantive artifacts before declaring them complete.
       - For long-running work, follow `ai-resources/docs/compaction-protocol.md` named checkpoints.
       - Surface `[SCOPE]`, `[HEAVY]`, `[AMBIGUOUS]`, `[COST]` guardrail flags per workspace rules.
       - Commit directly per workspace `Commit behavior` rule (no pre-commit checks, no permission asks).

   11. **On mandate completion.** Output: `Mandate complete. Run /wrap-session to capture telemetry and journal the session. Push pending — let me know when to push.` Do not auto-invoke `/wrap-session` — the operator decides when to wrap.
