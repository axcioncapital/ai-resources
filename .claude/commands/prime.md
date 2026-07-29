---
model: sonnet
---

Orient the session. Read state, brief the operator with a short task menu, wait for direction.

**Principle:** Prime never asserts state from a single source. Each surfaced next-step or status claim must be cross-checked against git log since the claim's source timestamp before being reported as current.

**Output discipline:** The operator is a non-developer. The brief must be short and scannable — convert terse log shorthand into plain English (short sentences, common words). Show only what the operator needs to choose the next task; everything else stays silent unless it needs attention.

**Execution discipline:** The orientation steps issue many *independent* read-only git/file calls; running them one-at-a-time is the main avoidable latency. Batch independent calls into a single message with multiple tool calls rather than firing them serially. Safe to fire together: **Step 1** (session-notes + log-trio reads), **Step 1b** (scratchpad listing), **Step 2** (`next-up.md`), **Step 3** (`friction-log.md` + `improvement-log.md`); **Step 0**'s per-repo `pull` may join the same batch. **Three ordering dependencies must be preserved — do not hoist a dependent call into the batch ahead of what it needs:** (1) **Step 1a**'s git cross-check consumes both `CWD_REPO` / `AI_RESOURCES` (established in Step 0) *and* the entry date parsed in Step 1, so it runs *after* Step 0 and Step 1, never alongside them; (2) **Step 4**'s working-tree `git status` must run *after* the Step 0 pulls so it sees post-pull state; (3) **Step 1c** depends on **Step 0 only** — both its file reads and its one optional path-2 `git log` resolve against `CWD_REPO`. Hoisted into the batch ahead of Step 0, the path is unresolved, the read silently misses, and the brief block never renders — the same failure mode as (1). It does **not** depend on Step 1a: Step 1c deliberately does not consume Step 1a's merged result set (that set spans sibling repos and is wrongly scoped for plan position — see Step 1c's ground-truth rule), so the two are independent and may batch together once Step 0 has run. Everything else across steps 0–4 is independent and should be batched.

0. **Pull latest.** Determine the cwd's git root: `CWD_REPO=$(git -C "$(pwd)" rev-parse --show-toplevel 2>/dev/null)`.
   If this fails, note `Pulled: n/a (not a git repo)` and skip to step 1.

   Define `AI_RESOURCES="/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources"`.

   **BEHIND-CHECK FIRST — do not pull a repo that has nothing to pull.** For each repo, fetch and ask
   how far behind it is *before* running any rebase:

   ```bash
   GIT_TERMINAL_PROMPT=0 git -C "$REPO" fetch --quiet 2>/dev/null
   BEHIND=$(git -C "$REPO" rev-list --count HEAD..@{u} 2>/dev/null || echo "")
   ```

   - `BEHIND` = `0` → **skip the pull entirely.** Record `up to date`. **Do not run `pull --rebase`.**
   - `BEHIND` empty (no upstream / detached HEAD) → record `skip (no upstream configured)`; no pull.
   - `BEHIND` ≥ 1 → run the pull below.

   **Why this guard exists, and why it is not merely an optimisation (2026-07-14, S5 → fixed S8).**
   `/prime` ran `pull --rebase --autostash` unconditionally, hit a content conflict in
   `logs/session-notes.md`, and **halted orientation mid-rebase** — leaving the repo in a
   `rebase-in-progress` state at the very start of a session. **The conflict was entirely spurious:
   `origin/main` had not moved at all** (`[ahead 5]`, zero behind), so there was nothing to pull.
   `--rebase` nonetheless replayed local commits — including a local **merge** commit — flattening it
   and re-applying conflicts that the merge had already resolved.
   **This repo creates local merge commits by design** (`/close-worktree-session` Step 4 makes them),
   so rebasing local history re-litigates settled conflicts. It will happen again on any
   merge-bearing history. The behind-check removes the whole class: with nothing to pull, there is
   nothing to rebase.

   Run `GIT_TERMINAL_PROMPT=0 git -C "$CWD_REPO" pull --rebase --autostash`. If `$CWD_REPO` differs
   from `$AI_RESOURCES`, also run `GIT_TERMINAL_PROMPT=0 git -C "$AI_RESOURCES" pull --rebase --autostash`.
   `--rebase --autostash` is explicit (not left to per-machine `pull.rebase` config) so a dirty working
   tree from a prior same-day session is stashed, rebased over, and popped back in one command — the
   rebase no longer refuses to start, removing the failure-and-recovery round-trip. Capture each result:
   - **Rebase conflicted mid-flight — the case that had NO defined handling and halted a session start.**
     If the pull leaves the repo mid-rebase (`git -C "$REPO" rev-parse --verify -q REBASE_HEAD` succeeds,
     or `git -C "$REPO" status` reports `rebase in progress`), **do not attempt to resolve it and do not
     stop the session.** Restore the repo and keep orienting:
     ```bash
     git -C "$REPO" rebase --abort 2>/dev/null
     ```
     Record `failed: rebase conflicted — aborted, repo restored; local history unchanged`. Carry it to
     the Step 6 brief as a ⚠ line. Orientation continues on the pre-pull state, which is a perfectly
     good state to work from. **A failed pull must never leave the operator in a half-rebased repo at
     the moment they are trying to start work** — that turns a no-op into an incident.
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

   *Live-foreign-session check → `/concurrent-session-check` nudge (S3, 2026-06-12).* `SIBLING_COUNT` above counts same-day *headers* — it cannot tell a live session from one that already wrapped (the marker is date-pruned, not liveness-pruned), so it is the wrong gate for a "you have a concurrent session right now" nudge. Reuse instead the per-id marker set. `/prime` writes this session's own per-id marker only at Step 8 (after orientation), so at Step 1a time **every** today-dated `logs/.session-marker-*` other than this session's own is a foreign session that primed in this checkout today and has not torn down. (Since 2026-07-18 this set is pre-cleaned: `detect-concurrent-session.sh` runs at every session start — i.e. before any `/prime` — and prunes markers whose session provably has no Claude CLI process left in this checkout, so a surviving foreign marker here is much more likely to be genuinely live. This step's own read stays today-scoped and heuristic; the hook is the authority on liveness.) Run one **read-only** scan:

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

1c. **Read the project's plan position.** Detect where the project actually stands against its plan, so the brief can lead with *where we are and what is next* rather than only a backlog menu. This step is a **zero-cost no-op in any repo without a plan** — including `ai-resources` itself, which has no `pipeline/` — and adds no reads, no line, and no menu item there.

   *Cascade source.* This reuses the detection cascade documented in `.claude/commands/project-next-steps.md` (Step 2), which in turn derives from `skills/session-guide-generator/SKILL.md` Step 2. One deliberate divergence: **position is checked before the plan spine, reordered for cost.** The source command lists the plan first; here `pipeline-state.md` is small and authoritative, so it is the cheap happy path and short-circuits the expensive one. That inversion is intentional — do not "correct" it back.

   Detect in this order and **stop as soon as position is confident**:

   1. `$CWD_REPO/pipeline/pipeline-state.md` — if present, read it. Its stage table states position directly. This is the common case — 19 project repos carry this file as of 2026-07-19, the large majority.
   2. Otherwise, the plan spine — first that exists: `pipeline/project-plan.md`, a `plan/` directory at the project root, phase/workflow definitions in the project `CLAUDE.md`, the latest `logs/session-plan*.md`.
   3. Neither exists → **skip silently.** No `PROJECT_POSITION`, no brief block, no cost.

   **Resolve the spine to exactly one file before going further.** Two of the four spine options are not single files, and the bounded-read recipe below is undefined for them — resolve first, then apply it to the resolved `<plan-file>`:
   - `pipeline/project-plan.md` or `logs/session-plan*.md` → already a file (for the glob, take the most recent by mtime, same `ls -t` rule Step 1b uses).
   - A `plan/` **directory** → take the lowest-numbered / lexically-first `*.md` inside it that still carries an incomplete marker; that file is `<plan-file>`. Do not read the directory's other files.
   - Project **`CLAUDE.md`** → `<plan-file>` is `CLAUDE.md` itself, and the grep below is scoped to its phase/workflow section rather than the whole file.

   If the spine resolves to nothing readable, treat it as case 3 above and skip silently. Do **not** fall back to reading several candidates "to be sure" — that is the unbounded behaviour this step exists to prevent.

   **Bounded read — NEVER a full read of the plan file.** On the step-2 fallback, do **not** `Read` the plan whole. Plan files run long and grow monotonically, and a full read here re-opens the exact cost class that Step 3 below exists to prevent (see its warning: ~50–60k tokens per orientation, named in five consecutive telemetry entries before the 2026-07-13 fix). Instead, grep for stage/phase headers and completion markers and read only a bounded slice around the first incomplete one:
   ```
   Bash(grep -nE "^#{2,3} +(Stage|Phase|W[0-9])|^- \[[ x]\]|✅|\*\*(complete|done)\*\*" <plan-file> | head -n 40)
   Read(<plan-file>, offset=<first incomplete marker>, limit=40)
   ```
   If the grep returns **stage/phase headers but no completion markers at all** — a real and common shape (verified 2026-07-19 against a live 900-line project plan, which carries `### Phase Vn` headers and no checkboxes) — anchor the slice on the **last** header instead, as the furthest-along section, and say the position is inferred from plan structure rather than from an explicit completion marker. If the grep returns nothing at all, skip silently per case 3. Do not improvise a wider read to find markers that are not there.

   A future edit that "simplifies" this into a plain `Read` is a regression, not a simplification — do not.

   **Ground truth — Step 1a's merged result set is deliberately NOT reused by either path.** Step 1a's merged git log is anchored to `--since=<last session-notes entry date>`. That window is correct for adjudicating last session's Next Steps and **too narrow for plan position**: a plan step completed weeks ago falls outside it entirely and would be reported as still-pending — the precise defect the cross-check exists to prevent. So:
   - **Path 1 (`pipeline-state.md` present):** trust the file as-is and issue **no git call at all.** It is a maintained completion signal, not an inference. Do **not** try to corroborate it against Step 1a's result set: that set merges commits from `$CWD_REPO`, `$AI_RESOURCES`, *and* every sibling repo under `projects/*/` into one unattributed list (see Step 1a), so a commit from ai-resources or an unrelated project reads as movement on this project's stage. There is also no cheap way to learn when the state file was last updated — `Read` returns no mtime. Trusting the file is both cheaper and more honest than a corroboration this step cannot actually perform.
   - **Path 2 (plan-marker fallback):** Step 1a's window is insufficient, and plan markers are the one signal stale enough to need checking. Resolve the plan file's own last-modified date first, then issue **exactly one** git call scoped to `$CWD_REPO`:
     ```
     Bash(date -r <plan-file> +%F 2>/dev/null)                                  # filesystem stat, not a git call
     Bash(git -C "$CWD_REPO" log --since=<that date> --pretty="%h %s" 2>/dev/null)
     ```
     Check whether the first incomplete marker already appears done in those commit subjects. **One git call is the ceiling** — do not fan out across sibling repos the way Step 1a does. If `date -r` fails, skip the corroboration entirely and report the marker as-is rather than spending a second call hunting for a date.

   **Readiness verdict.** Derive from the plan position plus the open questions already extracted from `session-notes.md` in Step 1 — both are in context, so this costs nothing extra. Emit a verdict plus one short reason. Keep it to that: the full four-point OK/GAP readiness check belongs to `/project-next-steps`, not here.

   Set `PROJECT_POSITION` = `{where_we_are, status, next_action}`, each **one short plain-English sentence** per the Step 5 conversion rules, and carry it to Step 6. If detection reached step 3 above (no plan, no state), leave `PROJECT_POSITION` unset and carry nothing.

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

   Issue exactly these three bounded scans:

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

   The three scans do different jobs — the files have different shapes, and the third measures a gap rather than reading content:
   - **`improvement-log.md` is schema'd** (`### {date} — {title}` / `- **Status:**` / `- **Severity:**`). The `-B6` window is sized to carry each severity hit's **header and status lines** back with it — that is what makes the filter below applicable without a second read. Do not narrow it: at `-B4` the header is lost on entries whose status runs to multiple lines.

     The severity anchor is `^-? ?\*\*Severity:\*\*` — the `-? ?` tolerates the **un-dashed** variant (`**Severity:** …` with no leading `- `), which two live entries use. Widened 2026-07-18; the old `^- ` anchor silently skipped them.

     The `\*{0,2}` before the value tolerates a **bolded severity value** (`- **Severity:** **high**`), which two live entries use. Widened 2026-07-19; the old anchor required the value to start immediately after the colon-space and silently skipped both. **Do not widen further to admit a delimiter before the value** — `logs/improvement-log.md:13` is the log's own schema block and reads ``- **Severity:** `low` | `medium` | `medium-high` | `high` | `critical` ``. An anchor loose enough to match that vocabulary *declaration* injects a phantom urgent item into the task menu of every consumer. The backtick is what excludes it today; `\*{0,2}` matches zero asterisks and then fails on it. That exclusion is load-bearing and was verified by execution before this widening shipped.
   - **The third scan is a COUNT, not a content read — and that distinction is the whole design.** Entries carrying no `Severity` field cannot be reached by any severity anchor. The tempting fix is to widen the scan until it sees them; that is wrong, and it is why the backlog item asking for it was mis-scoped. An entry with no Severity field is not *hidden HIGH work* — it is **unclassified**, and dumping unclassified entries into the task menu would make the menu worse while multiplying the token cost this step exists to bound. So the scan reports the *number* in one line and stops. Visible, bounded, honest: the operator learns the backlog has an unclassified tail without paying to read it. The real remedy is to give those entries a `Severity` field (a log-hygiene task for `/friday-act`), not to loosen this scan. Print nothing when the count is zero.
   - **`friction-log.md` has no severity field** — its severity words are free text inside prose bullets, and its resolution stamps (`— **Resolved:**`, `[FADING-GATE] verified`) sit on the *same* line as the finding, which is why the same-line `grep -v` works. Treat its hits as **candidates to judge, not findings**: incidental matches are expected (a shell variable named `HIGH`, a quoted phrase), and they are cheap to discard in-context because only the matching lines are returned.

   Then apply the filter to the returned lines only:
   - Include an item if it carries `high`, `medium-high`, `critical`, `urgent`, or `do-now`. **`medium-high` IS included — it is the deliberate second tier of menu-reach, not a borderline case.**
   - Exclude anything marked `low` or `medium`, and exclude entries whose status is `resolved`, `applied`, `verified`, or operator-`DECLINED`.

     **`medium-high` is load-bearing here and this wording was stale until 2026-07-24.** The rule previously read *"include only if it carries a HIGH-severity marker (`HIGH`, `urgent`, `critical`, or `do-now`)"* and *"exclude anything marked `LOW` or `MED`"* — naming `medium-high` in **neither** clause. That silence read as an anchor-vs-filter contradiction and nearly cost the tier its menu-reach: a 2026-07-24 change proposed deleting `medium-high` from the anchor above (a ~70% emit reduction), on the premise that the filter already discarded it. **It does not, and three other files say so explicitly** — `wrap-session.md` Step 12e (*"Only `high` and `medium-high` reach the `/prime` task menu"*), `.claude/agents/session-feedback-collector.md:138` (*"`high` / `medium-high` → reaches the `/prime` task menu. Use for anything that should be worked on."*), and `logs/improvement-log.md:13`, the log's own schema. The anchor was right; this prose was wrong. `/risk-check` returned RECONSIDER on the deletion (report: `audits/risk-checks/2026-07-24-narrow-prime-step3-severity-anchor-medium-high.md`).

     **So: narrowing this tier is a POLICY change to what earns a place on the task menu, not a cost optimisation, and it may not be made here alone.** Changing it requires updating the writer-side guidance in `wrap-session.md` Step 12e and `session-feedback-collector.md` in the same commit, plus a `logs/decisions.md` record. A large Step 3 emit is a signal that too many `medium-high` items are genuinely open — the remedy is backlog triage, not a quieter scan.
   - If either file does not exist, its scan returns nothing — skip silently.

   Each surviving item becomes an **urgent** menu candidate for step 5.

4. **Exception checks.** Compute the following, but carry each to step 6 only when it is abnormal — a normal value is never displayed. **Model alignment (below) is the one exception:** it is always carried to Step 6 regardless of match/mismatch — see its bullet for the display-styling split.
   - **Working tree:** if the environment's git-status snapshot is non-empty, run `git status --short` and `git diff --stat HEAD` once to confirm it is still current. The env snapshot is point-in-time from session start and can be stale vs actual HEAD (e.g., files already committed in the prior session). Carry forward only if the live result shows unexpected uncommitted changes. This is a Prime-time orientation check, distinct from the commit-time "no pre-commit git status" rule.
   - **Model alignment:** read the active session model identifier from the system-prompt context — do not run any external command, the identifier is already in context. Identify the cwd-nearest project `CLAUDE.md` and read its `## Model Selection` section for the project's **recommended posture** (advisory prose — never a declared default; defaults are prohibited per workspace `CLAUDE.md` § Model Tier). Three cases, all defined:
     - **Section present, and it names exactly ONE tier** → compare the session model against it. On match, plain styling (`Model: {session model}`); on mismatch, warning styling with a hint (`⚠ Model: you are on {session model}; this project recommends {recommended} → /model {recommended}`).
     - **Section present, but it names MORE THAN ONE tier** (e.g. "lean Sonnet for routine edits; reach for Opus on plan drafting") → emit the plain line only (`Model: {session model}`). **Never emit a `→ /model` nudge here.** A conditional posture resolves against the *task*, and Step 4 does not yet know the task — collapsing it to a single tier would fire a false downgrade warning at nearly every session start. This is the **normal** shape of the section as `/new-project` step 11a now writes it, not an edge case.
     - **No project `CLAUDE.md`** (session opened at the workspace root) → emit the plain line only (`Model: {session model}`). There is nothing to compare against; do **not** invent a recommendation.
     - **Project `CLAUDE.md` present but carries no `## Model Selection` section** → same as above: emit the plain line only, no warning. This is a *normal* state, not a defect — the section is optional, and a missing one means the project has expressed no preference. (Defined 2026-07-12. As of 2026-07-27 it is the **only** state for a newly scaffolded project: `/new-project` step 11a, the section's sole writer, was deleted, so nothing generates the section any more. A handful of legacy projects still carry one; the two branches above continue to apply to them.)

     Unlike the other checks in this step, ALWAYS carry the model line forward to Step 6.
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

Where we are:
  {PROJECT_POSITION.where_we_are}
  Status: {PROJECT_POSITION.status}
  Next: {PROJECT_POSITION.next_action}

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

   **Caller contract — ordering is the caller's responsibility (mirrors 8m's Wiring note).** This sub-step produces `${MARKER}` and writes only the marker files; it does NOT touch `session-notes.md`. The calling branch owns the rest of the marker → header → mtime ordering: after 8k returns, run the `grep -Fxq` header-existence check, append this session's marker-bearing header (with the branch's own work-description text), then write `logs/.prime-mtime` — in that order. Marker before header so the header can embed `${MARKER}`; mtime after the append so `/session-start` Step 0.5 sees this session's own write. `/session-start` Step 3 and `/session-plan` Step 0 both require THIS session's marker-bearing header to exist.

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
       # SUFFIX-TOLERANT, AND THIS IS THE MOST DANGEROUS LINE IN THE ALLOCATOR.
       # Markers now read `2026-07-14 S7-a4f`, not just `2026-07-14 S7`. The old
       # `${PREV##*S}` yielded `7-a4f`, which the `*[!0-9]*` guard below REJECTS — leaving
       # HIGH=0, so the next allocation is S1 ON TOP OF AN EXISTING S7. That is precisely the
       # "destructive regression" the invariant above warns against, and it would have shipped
       # silently. Strip the date, strip the leading S, then strip the suffix — never `##*S`,
       # which would also cut at an `S` inside the id suffix.
       "${TODAY} S"*) tok="${PREV#* }"; n="${tok#S}"; n="${n%%-*}"
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
   # SESSION-ID SUFFIX — this is what actually makes collisions IMPOSSIBLE, rather than merely
   # unlikely. The claim-dir mutex below narrows the race but cannot close it: a checkout
   # running an older copy of prime.md neither writes claims nor reads them, so it allocates
   # blind (the "known gap" above — it produced FOUR real collisions in two days). A marker
   # carrying 3 characters of this session's own id cannot collide with another session's
   # marker no matter what N either picks, because no two sessions share an id. The uniqueness
   # now lives in the NAME, not in a lock every participant must honour. (The mutex is retained
   # as belt-and-braces — it still yields tidy sequential numbers — but it is no longer
   # load-bearing for correctness.)
   #
   # Degrades safe: no CLAUDE_CODE_SESSION_ID (older CLI) → empty suffix → legacy bare S{N},
   # exactly today's behaviour. Readers accept both grammars.
   ID3=$(printf '%s' "${CLAUDE_CODE_SESSION_ID:-}" | tr -cd 'A-Za-z0-9' | cut -c1-3)
   if [ -n "$ID3" ]; then SFX="-${ID3}"; else SFX=""; fi

   # Atomic claim loop. mkdir succeeds for exactly one caller; the loser bumps and retries.
   N=$((HIGH + 1))
   while : ; do
     if [ -z "$CLAIMS" ]; then MARKER="S${N}${SFX}"; break; fi        # no common dir → no mutex, old behaviour
     if mkdir "$CLAIMS/${TODAY}-S${N}" 2>/dev/null; then        # ← the atomic step
       MARKER="S${N}${SFX}"
       printf '%s\n' "${CLAUDE_CODE_SESSION_ID:-unknown} $(date '+%H:%M:%S')" \
         > "$CLAIMS/${TODAY}-S${N}/owner" 2>/dev/null           # debug breadcrumb only; never read for logic
       break
     fi
     N=$((N + 1))
     if [ "$N" -gt 999 ]; then MARKER="S${N}${SFX}"; break; fi        # runaway guard — cannot spin forever
   done
   echo "${TODAY} ${MARKER}" > logs/.session-marker
   # Identity oracle (Option 2′): also write a per-session-id marker file no concurrent /prime can clobber.
   [ -n "${CLAUDE_CODE_SESSION_ID}" ] && echo "${TODAY} ${MARKER}" > "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}"
   # Orphan cleanup — REMOVED here (2026-07-18), owned by detect-concurrent-session.sh.
   # The old "prune per-id markers not dated today" loop was a category error: a marker's
   # date records when its session STARTED, never whether it ENDED — so it deleted a live
   # overnight session's marker (making that session invisible to every guard) while
   # leaving same-day ghosts armed. The SessionStart hook now prunes markers on LIVENESS
   # (no foreign Claude CLI process with cwd in this checkout → provably dead → rm),
   # fires before any /prime can run, and is registered once at the user level by
   # absolute path — so stale worktree copies of THIS file cannot carry the old
   # behaviour the way a prime-side prune would. Do not re-add a date-based prune.
   ```

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
         > Plan ready — review `logs/session-plan-${TODAY}-${MARKER}.md`. Reply `go` to start execution, or run `/qc-pass` on the plan first.

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

   8. **Derive `STRUCTURAL_RISK` — and nothing else.** Boolean: true if any picked item touches a structural change class (full list: `ai-resources/docs/audit-discipline.md`). **`/prime` is this field's sole owner**, because 8c.11 owns the `/risk-check` call it drives. Model tier and autonomy posture are **not** derived here — `/session-plan` owns both and discloses them after the plan write.

   9. **Dispatch to `/session-start`, which holds the approval gate.** Invoke it via the Skill tool with `args = "{gate:auto} {plan:overwrite} {mission:<MISSION_ID>, only if bound} {MANDATE_TEXT}"`, and hand it `STRUCTURAL_RISK` for the gate block. Under `{gate:auto}` that command suppresses its Step 2 echo and wait, runs Step 2.4 discovery and Step 2.5 validation in their existing order, then holds **one** approval gate — on **every** engine outcome, including skipped and failed — and on `go` writes the mandate (its Step 3), the run-manifest stub (3.5) and the plan (via `/session-plan`), returning here **without beginning execution**. `{plan:overwrite}` pre-selects `/session-plan` Step 0's overwrite option so the chain does not stop to ask.

      **On `abort` nothing further is written and control returns here.** The marker, header and mtime written at 8c.5 remain, because they precede the gate. Output `Auto mode aborted. No mandate, manifest or plan written — today's session header remains.` and stop.

   10. **Direct route.** When `DIRECT=1`, `/session-start` Step 4 does not chain to `/session-plan` and no `logs/session-plan-*.md` is written; the mandate and run-manifest still are. The gate block at 8c.9 disclosed this.

   11. **Run `/risk-check` if `STRUCTURAL_RISK` is true.** The plan-time gate per workspace Autonomy Rules #9; the 8c.9 gate disclosed it in advance, so the operator is not surprised. **GO** → continue to 8c.12. **RECONSIDER / NO-GO** → output `Risk-check verdict: {verdict}. Mandate and plan retained on disk. Auto mode paused — review {risk-check report path} before resuming.` and stop; mandate and plan stay on disk for revision. If `STRUCTURAL_RISK` is false, skip silently. **No structural edit may precede this step.**

   12. **Begin execution under the autonomy posture `/session-plan` set.** No further confirmation gate — the 8c.9 approval covered execution for every picked item. Run multi-item picks in the operator-given order and do NOT pause between items; emit a one-line between-gate summary at each item boundary (workspace `Between-gate summaries`). Complete the mandate fully within this session where context allows; if context is clearly constrained, follow the workspace `Context constraint deferral` rule — flag the deferral and log it, do not rush. During execution: run `/qc-pass` on substantive artifacts before declaring them complete, follow `ai-resources/docs/compaction-protocol.md` checkpoints on long work, surface `[SCOPE]` / `[HEAVY]` / `[AMBIGUOUS]` / `[COST]` guardrail flags, and commit directly per the workspace `Commit behavior` rule.

   13. **On mandate completion.** Output `Mandate complete. Run /wrap-session to capture telemetry and journal the session. Push pending — let me know when to push.` Do not auto-invoke `/wrap-session` — the operator decides when to wrap.
