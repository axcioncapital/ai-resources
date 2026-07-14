# Commit Discipline (edge cases)

> **When to read this file:** When sequencing edits across multiple commits (commit-boundary sequencing), when leftover uncommitted work from prior sessions is found in the tree (scoped commits, not catch-all sweeps), when a concurrent Claude Code session is disclosed (concurrent-session staging discipline), or before a full-file rewrite of a shared log (shared-log write-path integrity). Workspace CLAUDE.md keeps the bright-line commit behavior; this file holds the edge-case rules.

## Commit-boundary sequencing

When a plan specifies multiple commits and a single file carries changes for more than one commit group, sequence the edits — apply the edits belonging to commit N, stage and commit, then apply the edits belonging to commit N+1 — rather than editing the file once with all changes and relying on `git add` to split them. `git add` cannot split a file by intent.

## Scoped commits, not catch-all sweeps

A catch-all sweep commit ("commit leftover uncommitted artifacts from prior sessions") is a hygiene anti-pattern: the untargeted snapshot mixes unrelated workstreams, obscures provenance, and makes cross-machine conflict reasoning harder (real case: remote commit `4392131`, 2026-06-09 — a leftover-sweep from a second machine produced a non-fast-forward divergence whose disjointness then had to be proven file-by-file). Commit leftover work in scoped batches — one commit per workstream, staged by explicit path — or surface it to the operator; never as one undifferentiated snapshot.

## Concurrent-session staging discipline

When the operator has disclosed a concurrent Claude Code session on the same repo, `git add` must enumerate explicit file paths. Directory wildcards (`git add logs/`, `git add .claude/`, `git add -A`) are prohibited until the concurrent session wraps. Enumerate the files produced by the current session — the conversation-context-derived path list the wrap passes as `--file` flags to the run manifest (`logs/runs/{date}-{marker}.json`, field `files_changed`). The session note's "Files Created" / "Files Modified" sections were retired on 2026-07-13 by `RR-03`, so the manifest — not the note — is the file record to enumerate from. (In a project running an un-migrated *forked* `wrap-session.md`, no manifest is written and those note sections still exist — enumerate from them there. Either way, enumerate explicit paths; never a directory wildcard.)

**Scope the commit verb too — `add` and `commit` are not symmetric.** Explicit-path `git add` scopes only what *this session stages*; a follow-up bare `git commit` (no pathspec) commits *everything in the shared index*, including a sibling session's mid-flight staging (real incident: commit `9660bf2`, 2026-07-03 — a single-file open-items fix swept two files a concurrent log-sweep session had staged; benign only because both were exempt log-rotation archives, and the tripwire correctly did not block — the over-inclusion under the wrong commit message is the un-flagged failure). While a concurrent session is active, commit with a pathspec — `git commit -m "…" -- <explicit paths>` — or verify the index holds no foreign entries immediately before a bare commit.

**Shared-file exception to the no-pre-commit-inspection bright-line.** Explicit-path staging stops you sweeping a *sibling* file the other session is editing, but it does **not** protect a *shared* file that both sessions touch (e.g. `CLAUDE.md`, a shared command/doc): `git add CLAUDE.md` stages whatever is in the working tree for that path, including the concurrent session's in-progress edits. The workspace "no pre-commit `git status`/`git diff`" rule is therefore **suspended for shared files when a concurrent session is active**: before committing such a file, run `git diff --cached <file>` and confirm every staged hunk is yours. If a foreign hunk appears, `git restore --staged <file>`, isolate your own change, and coordinate — do not commit the bundle. Real incident (ai-development-lab, commit `9fc3c7d`): explicit-path staging of `CLAUDE.md` + `ai-engineer.md` silently bundled another session's edits and required a `git commit --amend` un-bundling because the bright-line blocked the pre-commit diff that would have caught it.

`/cleanup-worktree` and `/permission-sweep` MUST NOT run while a concurrent Claude Code session is active on the same repo or machine. Both act on shared state (git index, `.claude/settings.json`) and can clobber the other session's in-flight work. `/cleanup-worktree` enforces this via a mandatory operator-disclosure prompt at Step 1; `/permission-sweep` relies on operator discipline.

### Wrap-owns-session-notes (mid-session commits never stage `logs/session-notes.md`)

`logs/session-notes.md` is **wrap-owned**: only `/wrap-session` stages and commits it, because only the wrap path carries the Step 3.5 foreign-session pre-write guard that detects a sibling session's uncommitted header/mandate before staging. A mid-session work commit must NEVER include `logs/session-notes.md` — not even when the session legitimately wrote to it (the `/prime`-written header and mandate line sit uncommitted in the working tree until wrap; that is the designed state, not a loose end). Real incident (2026-06-09 S1): a mid-session project commit staged `session-notes.md` while a concurrent S2's marker-bearing header + mandate were in the working tree, shipping S2's content under S1's commit with no detection — the exact contamination this rule prevents. The same wrap-owned posture applies to the wrap-written telemetry logs (`usage-log.md`, `coaching-data.md`). If a mid-session commit genuinely must capture session-notes state (rare — e.g., an incident record), surface it to the operator first; do not stage silently.

### Foreign-staging tripwire (`check-foreign-staging.sh`)

A `PreToolUse(Bash)` hook (`.claude/hooks/check-foreign-staging.sh`) automates the *whole-file* half of the discipline above.

> **⚠ Where it is actually wired — corrected 2026-07-14 (this line previously said "wired in `.claude/settings.json`", which is false).** Both this hook and `check-destructive-liveness.sh` are wired in the **user-level** `~/.claude/settings.json`, not in any repo settings file (grep confirms zero mention of either hook in any `ai-resources/.claude/settings*.json`). **This is a real structural weakness, not a detail:** the hook *bodies* are versioned in git and propagate to every clone; their *wiring* is machine-local and unversioned, so **on any other machine the hooks exist and never fire.** A `git clone` of this repo gets the guards' code and none of their protection, silently. Backing up and versioning `~/.claude/` is tracked as R-5 in `logs/improvement-log.md`.
 Before a gated git verb runs — `git commit`, `git commit --amend`, `git commit -a`, and the working-tree-wide adds `git add -A` / `--all` / `-u` / `.` (explicit-pathspec `git add <path>` is **not** gated) — it compares the files that verb would stage against this session's declared footprint and **blocks (exit 2)** if any staged file is neither in the footprint nor exempt. This is the automation of Fix 2 in `audits/2026-06-09-concurrent-session-isolation-fix-plan.md`; it exists because the S3 (2026-06-09) `git commit --amend` swept a foreign session's staged `claim-permission.template.md` with no guard.

**It is an advisory tripwire, not enforcement** (principle OP-5). `exit 2` feeds the foreign-file list back to the *agent* (not an operator permission prompt — this respects the zero-permission-prompt / `bypassPermissions` floor), and the agent could technically re-run the commit. So the block message instructs **stop and surface the files to the operator**, not silent self-correction. The tripwire **pairs with — does not replace — the `git diff --cached` shared-file review** above: it catches whole *foreign files*; the diff review catches foreign *hunks* inside files you legitimately own (e.g. `CLAUDE.md`), which the hook cannot see.

**Footprint source and fail-open.** The hook resolves this session's marker (per-id oracle `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}` → shared `logs/.session-marker` fallback) and reads the `- Files in scope:` bullet under this session's `## DATE — Session S{N}` header in `logs/session-notes.md` (the same bullet `/session-start` writes and `concurrent-session-check.md` reads). If that footprint is absent, or reads `(inferred)` / `(none stated)` / has no concrete path, the hook **fails open** — it emits a soft non-blocking warn and allows the commit (a guard that blocked on its own parse failure would be worse). **Known blind spot:** a primed-but-not-planned session, or one with an `(inferred)` footprint, gets *no* protection from this tripwire — the same gap `concurrent-session-check.md` documents as its #1 failure. Declare a concrete `Files in scope` (run `/session-start`/`/session-plan`) to arm the guard.

**Exempt (never counted as foreign):** the append-only shared logs (`session-notes.md`, `decisions.md`, `usage-log.md`, `improvement-log.md`, `coaching-data.md`), this session's own process byproducts under `logs/` (`.session-marker*`, `.prime-mtime`, `session-plan-*.md`, `*-scratchpad.md`), log-rotation archives under `logs/` (any `logs/` file with `archive` in its name — e.g. `session-notes-archive-YYYY-MM.md`, `improvement-log-archive.md` — since a wrap commit legitimately stages a freshly-rotated archive alongside its source log), and the write-once audit-artifact dirs (`audits/risk-checks/`, `audits/working/`). These are append-only or write-once, so a cross-session overlap on them is benign (no lost update); the tripwire deliberately targets only **edit-in-place content** (commands, docs, skills, templates, `CLAUDE.md`) — the real lost-update surface. (The status logs in this list — `improvement-log.md`, `friction-log.md`, `decisions.md` — are exempt for the **append** operation a work session performs on them, whose cross-session overlap git unions safely. Those same logs also receive **in-place mutations** — status flips and archiving — which *are* a lost-update surface; those mutations are confined to dedicated single-purpose sessions and governed by § Maintenance-owned in-place mutations below, so they never collide with a work session's appends.) Without this exempt-list, every wrap commit (which stages the shared logs) would false-block.

**Narrow exception (2026-07-03, incident `9660bf2`).** "Benign" above assumes no live foreign session — with a concurrent session actually active, an exempt file can still be that session's in-flight work, and a bare `git commit` folding it in silently misattributes it. The hook now warns (never blocks) in exactly that case: a `git commit` would include exempt-but-outside-footprint files AND a live foreign per-id marker is present. The exempt-list's benign-by-default classification is unchanged; this only adds a signal for the one case where "benign" isn't guaranteed.

**Distinct from the parked QC-PENDING commit-block hook** (`logs/decisions.md`, 2026-06-08, "Decision 3 — hook parked"): that hook would block committing an architectural change before its independent QC passes; this one blocks committing another session's files. Different trigger, different purpose — they do not overlap and must not be merged.

## Destructive-op pre-flight (liveness probe)

Before any destructive git op on a checkout — `git worktree remove`, `git branch -d`/`-D`, `git reset --hard`, `git clean -f` — the **target** checkout must be probed for signs that a session is working in it. **The target, not the current one.**

**This is enforced by a hook, not by this section.** `.claude/hooks/check-destructive-liveness.sh` (`PreToolUse(Bash)`) runs the probes automatically, at execution time, immediately before the command. It blocks (`exit 2`) on any hit. This section documents *what it does and why*; it is not the control. **Do not treat reading this file as satisfying the check** — that inversion is exactly the failure recorded below.

The three probes, run against the resolved target:

1. `git -C <target> status --short` — uncommitted work?
2. `<target>/logs/.session-marker-*` — a session primed there and has not wrapped? **Any date, not just today.** An overnight session's marker is dated yesterday; a today-only filter silently passes it. (`close-worktree-session.md` Step 3 carried precisely that bug until 2026-07-14.)
3. mtimes of the target's dirty files — written in the last two hours?

Any hit → **STOP and ask the operator.** Liveness is the one fact only the operator holds.

**Why a hook and not this doctrine.** On 2026-07-14 (S2) a session planned `git worktree remove` on a worktree holding a **live Claude session with 173+ lines of uncommitted work** across five files, two of them canonical skills, with no other copy anywhere. Every gate passed it. What caught it was the operator noticing an open editor window.

A prose warning saying exactly this — *"Never remove a worktree a live session still occupies"* — **already existed** in `new-worktree-session.md` and `close-worktree-session.md` before that incident, **and it did not fire**, because the destructive command was assembled directly in a session plan and never touched either file. Adding a fourth prose location would have changed nothing about that causal path. **A rule you must remember to read is not a control; it is a wish.** The 2026-07-14 plan-time `/risk-check` said so in as many words, and the doc-only design was replaced with the hook.

**`/risk-check` is also the wrong home, and this is not a matter of taste.** It runs at *plan* time and reads the repo *at rest*. A session can go live between the gate and the act — which is not hypothetical: on 2026-07-14 (S4) the target worktree was verified clean and idle at 10:50, and was **occupied by a new live session by 11:10**, twenty-five minutes later, while the fix for this very defect was being written. Putting the probe in a plan-time gate relocates the bug one layer up. **Liveness must be probed at execution time, by the executor, or it is a reading of a moving system.**

**The generalisable statement.** Every other gate in this repo (`/risk-check`, `/blindspot-scan`, `/lean-repo`, `/qc-pass`) inspects the artifact **at rest**. This hazard is the artifact **in motion**. A file census cannot see a running process. *A clean worktree is not an idle worktree.*

**Reference implementation:** `close-worktree-session.md` Steps 2–3 — its guards correctly probe `$WT_PATH` (the target), and are sound. They are simply not in the path when a session invokes the destructive verb directly, which is what the hook covers.

**Known limit, stated rather than papered over:** a *crashed* session leaves a stale marker, so probe (2) can fire on a genuinely idle checkout. That is the correct trade — a false stop costs one operator sentence; a false pass costs unrecoverable work. Probe (3) exists to help tell the two apart (stale marker + clean tree + no recent writes ≈ a corpse). The operator decides; the hook never decides for them.

**Test harness:** `logs/scripts/test-destructive-liveness.sh` (14 cases: negative / self-target / idle-target / live-target). It went **red twice** before it went green — once because the hook degraded *open* on the very command it exists to stop (a quoted path containing spaces resolved to an empty target). Run it after any edit to the hook. A test that has never failed has never been tested.

## Shared-log write-path integrity (read-during-rewrite hazard)

The non-append shared logs (`logs/improvement-log.md`, `logs/friction-log.md`) are written by several actors (the `session-feedback-collector` agent, `/improve`, manual edits, `/resolve-improvement-log`). When two run concurrently, a `Read` that lands inside another actor's non-atomic full-file rewrite returns a **silently truncated** file that looks complete — and a downstream `Write` of that "full" content persists the truncation as a mass deletion. Real near-miss (2026-06-05 S7): a `Read` returned a 17-line snapshot of a ~24-entry `improvement-log.md` mid-rewrite; had it been written back, ~23 entries would have been destroyed.

**Two-part discipline:**

1. **Prefer minimal append-only edits.** Append one block at END with the `Edit` tool. A minimal append cannot truncate the rest of the file, so it carries no read-during-rewrite risk and needs no check.
2. **Guard the full-rewrite fallback.** Only when you must `Read`-then-`Write` the whole file, first compare the entry count you are about to persist against the committed `HEAD` baseline:

   ```bash
   git show HEAD:logs/improvement-log.md 2>/dev/null | grep -c '^### '      # improvement-log entries
   git show HEAD:logs/friction-log.md 2>/dev/null | grep -c '^## Session'   # friction-log sessions
   ```

   You are appending, so your working count can only be **≥** the baseline. If it is **lower**, that is the read-during-rewrite truncation signature — **STOP loud, do not write**, and report the abort. The check is a count-proxy: it assumes `'^### '` / `'^## Session'` remain the entry markers (true as of 2026-06-05); revisit if the entry format changes. It does **not** apply to `/resolve-improvement-log`'s legitimate archive-shrink, which is a deliberate entry-removal writer with its own integrity logic — only the append writers (`session-feedback-collector`, `/improve`) carry this guard.

Companion to the concurrent-session advisory in `/prime` Step 1a and `/session-start` Step 0.5, which *names* a foreign-dirty shared log so a session knows to expect contention before it writes.

## Maintenance-owned in-place mutations (shared-log serialization)

The shared status logs — `logs/improvement-log.md` and `logs/friction-log.md` — carry **two distinct operation classes.** Conflating them is what made the two rules above look contradictory: the foreign-staging exempt-list (§ above) calls these logs "append-only … benign (no lost update)", while § Shared-log write-path integrity calls them "non-append … lost-update hazard." **Both are correct — about different operations:**

| Operation | Who performs it | Cross-session safety |
|-----------|-----------------|----------------------|
| **Atomic append** — add one new entry at end-of-file | `/improve`, `/resolve-incident`, `/resolve-repo-problem`, `session-feedback-collector` — all **mid-session** | **Benign.** git unions concurrent appends (worst case a data-safe keep-both append conflict). This is the operation the foreign-staging tripwire exempts. |
| **In-place mutation** — flip an entry's `**Status:**` (`logged`→`applied`/`verified`), or archive an entry out to `*-archive.md` | `/friday-act` (status flips) and `/resolve-improvement-log` (archiving) in the maintenance cadence; `/fix-repo-issues` plan execution (a per-item "improvement-log status flip") — all in **dedicated, single-purpose sessions** | **Lost-update surface.** Rewrites existing lines; "keep both" is semantically wrong. Two sessions mutating overlapping lines collide at pull (Failure B) or clobber in a shared index (Failure A). |

**The rule — in-place mutations belong to dedicated single-purpose sessions, never to ordinary work.** Status flips and archiving of these logs happen **only inside a dedicated, single-purpose session** — the maintenance cadence (`/friday-act`, `/resolve-improvement-log`, invoked from `/friday-checkup`) and `/fix-repo-issues` plan execution (which already mandates a *fresh* session and explicitly forbids running in the planning session). These sessions are operator-initiated one-at-a-time and do no ordinary work alongside the mutation. An **ordinary work session appends only**; it never reaches into an existing entry to change its status or move it out. Because every in-place mutator today is one of these dedicated-session paths, this rule **codifies an invariant that already holds** — it is a guardrail against future drift (a new command that "helpfully" flips a status as a side-effect of ordinary mid-session work would violate it), not a change to current behavior.

**Why this removes the conflict surface.** Two concurrent *work* sessions can both safely append (git unions them); they cannot both be mid-mutation on the same entry, because mutation is confined to dedicated single-purpose sessions that do no concurrent ordinary work. This closes most of Failure B — the recurring pull-time conflict on these logs (fix-plan `audits/2026-06-09-concurrent-session-isolation-fix-plan.md` §3 Fix 4 route (a)). **Known residual:** the dedicated-session paths are not mutually serialized — two of them (two clones/machines each in the maintenance cadence, or a `/fix-repo-issues` execution overlapping a Friday session) can still conflict on the in-place mutations. Eliminating that entirely needs per-session log namespacing (the same plan's Fix 4(b)), the escalation only if this discipline proves insufficient. What the rule does guarantee is that the *common, high-frequency* path — ordinary work sessions — never mutates, so it never collides on these logs.

**Not governed by this rule:** `session-notes.md` (marker-disambiguated, append-only), `usage-log.md`, and `coaching-data.md` are append-only in *both* senses — new entries only, no status flips — so two sessions only ever union them. `decisions.md` is append-only in practice (no in-place status-flip writer exists for it); if it is ever archived, that archiving is likewise a maintenance-cadence operation. Companion to `docs/parallel-sessions-playbook.md` § 2 (file-shape classification) and § 3 (log-shaped vs content-shaped), which this rule refines for the two status logs that are *both* append-shaped and mutation-bearing.

## Foreign-files diagnostic shortcut

When `git status` flags many `?? .claude/commands/*.md` files at workspace-root, check symlinks first — most are symlinks to canonical bodies in `ai-resources/`, not real new files from a runaway session. Run this before escalating to `/resolve-repo-problem`:

```bash
find .claude/commands -type l | wc -l
```

If the count matches (or nearly matches) the untracked-file count, the alarm is benign — the symlinks just aren't checked in. Investigate only the residual non-symlink files.
