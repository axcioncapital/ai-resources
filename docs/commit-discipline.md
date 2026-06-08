# Commit Discipline (edge cases)

> **When to read this file:** When sequencing edits across multiple commits (commit-boundary sequencing), when a concurrent Claude Code session is disclosed (concurrent-session staging discipline), or before a full-file rewrite of a shared log (shared-log write-path integrity). Workspace CLAUDE.md keeps the bright-line commit behavior; this file holds the edge-case rules.

## Commit-boundary sequencing

When a plan specifies multiple commits and a single file carries changes for more than one commit group, sequence the edits — apply the edits belonging to commit N, stage and commit, then apply the edits belonging to commit N+1 — rather than editing the file once with all changes and relying on `git add` to split them. `git add` cannot split a file by intent.

## Concurrent-session staging discipline

When the operator has disclosed a concurrent Claude Code session on the same repo, `git add` must enumerate explicit file paths. Directory wildcards (`git add logs/`, `git add .claude/`, `git add -A`) are prohibited until the concurrent session wraps. Enumerate the files produced by the current session — typically those listed under the "Files Created" / "Files Modified" section of the session note the command just wrote.

**Shared-file exception to the no-pre-commit-inspection bright-line.** Explicit-path staging stops you sweeping a *sibling* file the other session is editing, but it does **not** protect a *shared* file that both sessions touch (e.g. `CLAUDE.md`, a shared command/doc): `git add CLAUDE.md` stages whatever is in the working tree for that path, including the concurrent session's in-progress edits. The workspace "no pre-commit `git status`/`git diff`" rule is therefore **suspended for shared files when a concurrent session is active**: before committing such a file, run `git diff --cached <file>` and confirm every staged hunk is yours. If a foreign hunk appears, `git restore --staged <file>`, isolate your own change, and coordinate — do not commit the bundle. Real incident (ai-development-lab, commit `9fc3c7d`): explicit-path staging of `CLAUDE.md` + `ai-engineer.md` silently bundled another session's edits and required a `git commit --amend` un-bundling because the bright-line blocked the pre-commit diff that would have caught it.

`/cleanup-worktree` and `/permission-sweep` MUST NOT run while a concurrent Claude Code session is active on the same repo or machine. Both act on shared state (git index, `.claude/settings.json`) and can clobber the other session's in-flight work. `/cleanup-worktree` enforces this via a mandatory operator-disclosure prompt at Step 1; `/permission-sweep` relies on operator discipline.

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

## Foreign-files diagnostic shortcut

When `git status` flags many `?? .claude/commands/*.md` files at workspace-root, check symlinks first — most are symlinks to canonical bodies in `ai-resources/`, not real new files from a runaway session. Run this before escalating to `/resolve-repo-problem`:

```bash
find .claude/commands -type l | wc -l
```

If the count matches (or nearly matches) the untracked-file count, the alarm is benign — the symlinks just aren't checked in. Investigate only the residual non-symlink files.
