## Commit Rules

**Commit directly. Do not ask for permission.** After completing approved work, stage the relevant files and commit in a single step using a heredoc commit message. Do not run `git status`, `git diff`, or `git status --short` as pre-commit checks or post-commit verification — the filesystem is the source of truth for what you just changed.

**Do NOT push after committing.** Pushes are batched until session end and gated by a single operator confirmation at `/wrap-session`. Remind the operator to run `/wrap-session` if the work is complete. Never commit files that may contain secrets (`.env`, credentials, tokens).

This rule mirrors the canonical `Commit behavior` and `Push behavior` sections in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded.
