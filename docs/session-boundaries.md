# Session Boundaries

> Single source of truth for the session-boundary rule. Pointed to from the workspace-root `CLAUDE.md` and `ai-resources/CLAUDE.md`, which load in every session. Pointer paths to this file are written `ai-resources/docs/session-boundaries.md` and resolve **from the workspace root** (the `ai-resources/` directory is a workspace-root sibling reached via `--add-dir`, not a child of any project).
>
> Project `CLAUDE.md` files no longer carry a `## Session Boundaries` section. `/new-project` stopped writing one on 2026-07-27, and the copies that existed were removed from 26 project files the same day — the rule is workspace-level and already in force in every session, so a per-project restatement was pure duplication. A few older project files may still carry one; treat those as leftovers, not as the convention.

When switching between unrelated tasks in the same terminal, prefer `/clear` over continuing in dirty context — stale context from a prior task compounds and contaminates the next one.

When context pressure rises, prefer a session-state scratchpad + `/clear` + restart over `/compact` (which applies lossy auto-summarization).
