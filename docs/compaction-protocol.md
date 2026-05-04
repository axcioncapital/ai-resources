# Compaction Protocol

> **When to read this file:** When `[COST]` fires (see workspace CLAUDE.md `Session Guardrails`), or when `/compact` is imminent or just completed — for the pre-compact scratchpad rule and the post-compact resumption rule.

Two rules govern Claude Code session compaction in this workspace.

- **Pre-compact checkpoint.** When `[COST]` fires (see workspace CLAUDE.md `Session Guardrails`), write a session-state scratchpad to the working directory containing: current step, decisions since last checkpoint, partial findings, and file paths of artifacts produced. Then prefer `/clear` + restart (reading the scratchpad) over `/compact` — you control exactly what survives rather than relying on lossy auto-summarization. If using `/compact` instead, write the scratchpad first.
- **Post-compact resumption — trust the summary.** When resuming after compaction, treat the summary's "commits made" / "files modified" / "decisions" lists as authoritative. Do NOT re-derive them via `git log`, `git show`, or repeated Reads of `session-notes.md`/`decisions.md`. Verify only when the next action requires a specific detail the summary didn't capture (e.g., line numbers for an Edit). Cost test: if your verification doesn't change the next tool call, skip it.
