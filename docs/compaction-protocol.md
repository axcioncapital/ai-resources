# Compaction Protocol

> **When to read this file:** When `[COST]` fires (see workspace CLAUDE.md `Session Guardrails`), or when `/compact` is imminent or just completed — for the pre-compact scratchpad rule and the post-compact resumption rule.

Two rules govern Claude Code session compaction in this workspace.

- **Pre-compact checkpoint.** When `[COST]` fires (see workspace CLAUDE.md `Session Guardrails`), write a session-state scratchpad to the working directory containing: current step, decisions since last checkpoint, partial findings, and file paths of artifacts produced. Then prefer `/clear` + restart (reading the scratchpad) over `/compact` — you control exactly what survives rather than relying on lossy auto-summarization. If using `/compact` instead, write the scratchpad first.
- **Post-compact resumption — trust the summary.** When resuming after compaction, treat the summary's "commits made" / "files modified" / "decisions" lists as authoritative. Do NOT re-derive them via `git log`, `git show`, or repeated Reads of `session-notes.md`/`decisions.md`. Verify only when the next action requires a specific detail the summary didn't capture (e.g., line numbers for an Edit). Cost test: if your verification doesn't change the next tool call, skip it.

## Named checkpoints

Four points in a typical session where pre-compact discipline matters most. At each, write the listed state to disk before compacting (or before `/clear`). All four points share the rule above — `/clear` + restart beats `/compact` when you control the scratchpad.

1. **Post-inspection.** After initial discovery / file reads, before edits begin.
   - On disk before compact: list of files read with one-line purpose each; the question or task framing the inspection; any conclusions reached.
   - Target file: `logs/scratchpads/{YYYY-MM-DD}-{HH-MM}-inspection.md`.
   - Preferred next step: `/clear` + restart reading the scratchpad. Use `/compact` only if the inspection produced live state worth keeping in turn-by-turn form.

2. **Post-implementation.** After the main edit/draft phase, before QC.
   - On disk before compact: files written or modified (path + one-line change summary); decisions made during implementation; remaining acceptance criteria not yet checked.
   - Target file: append to the active `logs/session-plan-${YYYY-MM-DD}-${MARKER}.md` (resolve marker per `docs/session-marker.md`) or write a `logs/scratchpads/` file.
   - Preferred next step: `/clear` + restart, loading the implementation summary into a fresh `/qc-pass`. QC benefits from a clean reading.

3. **Post-QC.** After QC findings recorded, before fix application.
   - On disk before compact: the QC findings list verbatim; each finding's proposed fix; per-finding disposition (ACCEPT / DISAGREE / DEFER).
   - Target file: `audits/working/qc-{date}-{topic}.md` (or in conversation context if QC produced a structured artifact).
   - Preferred next step: `/clear` + restart to apply fixes mechanically. Fix application is mechanical doing, not deciding — fresh context speeds it up.

4. **Pre-closeout.** Before `/wrap-session` runs.
   - On disk before compact: files created / modified this session; decisions made; next steps for the next session; open questions.
   - Target file: `logs/scratchpads/{YYYY-MM-DD}-{HH-MM}-scratchpad.md` (the continuity scratchpad `/wrap-session` Step 0.5 produces — same file, written by that step).
   - Preferred next step: usually no compact needed — `/wrap-session` is short and runs on existing conversation context. If the session has already crossed a high tool-call count and the wrap itself risks compaction, `/clear` after the scratchpad write and re-enter `/wrap-session`.

Common across all four: a scratchpad is cheap; a lost decision is expensive. Write before you compact.
