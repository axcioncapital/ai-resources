## Compaction

When `/compact` fires, preserve:
- The current pipeline/stage identifier and active working directory (which section, which stage, which command is mid-run).
- Paths to any subagent-output files the main session has not yet read.
- Any pending operator gate the session is holding at.

Auto-compact drops these by priority; name them explicitly so they survive. Before `/compact`, prefer writing a short session-state scratchpad (current step, decisions, partial findings, artifact paths) and `/clear` + restart from the scratchpad over lossy auto-summarization.

**Post-compact resumption — trust the summary.** When resuming after compaction, treat the summary's "commits made" / "files modified" / "decisions" lists as authoritative. Do NOT re-derive them via `git log`, `git show`, or repeated Reads of `session-notes.md`/`decisions.md`. Verify only when the next action requires a specific detail the summary didn't capture (e.g., line numbers for an Edit). Cost test: if your verification doesn't change the next tool call, skip it.
