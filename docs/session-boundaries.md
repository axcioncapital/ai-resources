# Session Boundaries

> Single source of truth for the session-boundary rule. Pointed to from the workspace-root `CLAUDE.md`, `ai-resources/CLAUDE.md`, and every project `CLAUDE.md`. Pointer paths to this file are written `ai-resources/docs/session-boundaries.md` and resolve **from the workspace root** (the `ai-resources/` directory is a workspace-root sibling reached via `--add-dir`, not a child of any project).

When switching between unrelated tasks in the same terminal, prefer `/clear` over continuing in dirty context — stale context from a prior task compounds and contaminates the next one.

When context pressure rises, prefer a session-state scratchpad + `/clear` + restart over `/compact` (which applies lossy auto-summarization).
