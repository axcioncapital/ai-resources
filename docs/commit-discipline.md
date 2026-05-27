# Commit Discipline (edge cases)

> **When to read this file:** When sequencing edits across multiple commits (commit-boundary sequencing) or when a concurrent Claude Code session is disclosed (concurrent-session staging discipline). Workspace CLAUDE.md keeps the bright-line commit behavior; this file holds the edge-case rules.

## Commit-boundary sequencing

When a plan specifies multiple commits and a single file carries changes for more than one commit group, sequence the edits — apply the edits belonging to commit N, stage and commit, then apply the edits belonging to commit N+1 — rather than editing the file once with all changes and relying on `git add` to split them. `git add` cannot split a file by intent.

## Concurrent-session staging discipline

When the operator has disclosed a concurrent Claude Code session on the same repo, `git add` must enumerate explicit file paths. Directory wildcards (`git add logs/`, `git add .claude/`, `git add -A`) are prohibited until the concurrent session wraps. Enumerate the files produced by the current session — typically those listed under the "Files Created" / "Files Modified" section of the session note the command just wrote.

`/cleanup-worktree` and `/permission-sweep` MUST NOT run while a concurrent Claude Code session is active on the same repo or machine. Both act on shared state (git index, `.claude/settings.json`) and can clobber the other session's in-flight work. `/cleanup-worktree` enforces this via a mandatory operator-disclosure prompt at Step 1; `/permission-sweep` relies on operator discipline.

## Foreign-files diagnostic shortcut

When `git status` flags many `?? .claude/commands/*.md` files at workspace-root, check symlinks first — most are symlinks to canonical bodies in `ai-resources/`, not real new files from a runaway session. Run this before escalating to `/resolve-repo-problem`:

```bash
find .claude/commands -type l | wc -l
```

If the count matches (or nearly matches) the untracked-file count, the alarm is benign — the symlinks just aren't checked in. Investigate only the residual non-symlink files.
