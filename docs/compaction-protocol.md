# Compaction Protocol

> **When to read this file:** When `[COST]` fires (see workspace CLAUDE.md `Session Guardrails`), or when `/compact` is imminent or just completed — for the pre-compact scratchpad rule and the post-compact resumption rule.

Two rules govern Claude Code session compaction in this workspace.

- **Pre-compact checkpoint.** When `[COST]` fires (see workspace CLAUDE.md `Session Guardrails`), write a session-state scratchpad to the working directory containing: current step, decisions since last checkpoint, partial findings, and file paths of artifacts produced. Then prefer `/clear` + restart (reading the scratchpad) over `/compact` — you control exactly what survives rather than relying on lossy auto-summarization. If using `/compact` instead, write the scratchpad first.
- **Post-compact resumption — trust the summary.** When resuming after compaction, treat the summary's "commits made" / "files modified" / "decisions" lists as authoritative. Do NOT re-derive them via `git log`, `git show`, or repeated Reads of `session-notes.md`/`decisions.md`. Verify only when the next action requires a specific detail the summary didn't capture (e.g., line numbers for an Edit). Cost test: if your verification doesn't change the next tool call, skip it.

### Exception — an active Work Loop v2 task

The trust-the-summary rule above is scoped to ordinary sessions and **does not apply while a Work Loop v2 task is active.** There, the compacted summary is orientation material, not authoritative task state.

Different kinds of authority are at work, and collapsing them into a single ranking is the error this section has to avoid. **Governing-rule authority** says what the rules are and how everything else is read; **current-state authority** says what is true right now. These are not rungs on one ladder: a source that governs interpretation is not competing with a source that reports state, so asking which of the two "wins" is already the wrong question. Each source has one role, and stays inside it:

- **Govern interpretation** — permanent repository and agent instructions, the Work Loop v2 skill and its executable core, and the governing plan with the applicable approved workflow. These settle what the task's contents are allowed to mean and which sources may settle anything at all. Nothing below overrides them.
- **Establish current task state** — the validated task-state file, `logs/work-loop/{task-id}.md`, within the constraints above. It is authoritative for what the task's state *is*. It is never authoritative for what the rules are, and it does not outrank the plan or workflow that give its contents meaning.
- **Verify factual claims** — repository and Git evidence. It settles what the repository actually contains, including where a task file's claim about the repository is wrong.
- **Orient only** — the conversation or the compacted summary. Never authoritative for any of the three roles above.

**"Validated" means one specific thing: `logs/scripts/work-loop-state.sh` classified it.** That single reader is the lifecycle authority (executable core § 4), and reading `status:` or `turn:` yourself after a compaction is exactly when a second reader gets invented — the summary supplies a remembered lifecycle, and hand-parsing the file appears to confirm it. Two sources, one guess. Ask the validator.

**Two things establish the task, and nothing else does.** The exact `logs/work-loop/{task-id}.md` path preserved through the compaction, or — only if that did not survive — this checkout's `.owner` declaration under every check the `reorient` skill lists. **If neither establishes the task, stop and ask the operator.** Do not scan `logs/work-loop/`, take the newest file, infer the task from a branch name, or reconstruct a record. An absent or invalid pointer is a stop, not a prompt to search: the whole failure mode here is a plausible reconstruction of the wrong task.

**No legacy session state is consulted or written to establish Work Loop state.** Session notes, markers, plans, scratchpads and run manifests answer a different question for a different system, and none of them is evidence about a Work Loop task. Nor does the unwired staging hook (`.claude/hooks/check-foreign-staging.sh`) supply any commit or state boundary here — it is registered in no settings layer and guards nothing. Work Loop's boundaries are the validator, the checkout declaration, the shared live leases and Git itself.

Where the summary conflicts with any durable source, **follow the durable evidence and report the discrepancy** rather than resolving it silently. Where the task file conflicts with a governing source, the governing source settles it and the conflict is reported as a defect in the task file — not resolved quietly in either direction. Re-deriving state from durable sources is the expected cost here, not a violation of the cost test — the cost test governs the ordinary rule only. The `reorient` skill owns the recovery procedure; this section only settles which source carries which kind of authority.

## Named checkpoints

Four points in a typical session where pre-compact discipline matters most. At each, write the listed state to disk before compacting (or before `/clear`). All four points share the rule above — `/clear` + restart beats `/compact` when you control the scratchpad.

1. **Post-inspection.** After initial discovery / file reads, before edits begin.
   - On disk before compact: list of files read with one-line purpose each; the question or task framing the inspection; any conclusions reached.
   - Target file: `logs/scratchpads/{YYYY-MM-DD}-{HH-MM}-inspection.md`.
   - Preferred next step: `/clear` + restart reading the scratchpad. Use `/compact` only if the inspection produced live state worth keeping in turn-by-turn form.

2. **Post-implementation.** After the main edit/draft phase, before QC.
   - On disk before compact: files written or modified (path + one-line change summary); decisions made during implementation; remaining acceptance criteria not yet checked.
   - Target file: append to the active `logs/session-plan-${YYYY-MM-DD}-${MARKER}.md` (resolve marker per `docs/session-marker.md`) or write a `logs/scratchpads/` file.
   - Preferred next step: `/clear` + restart, loading the implementation summary into a fresh review. A review benefits from a clean reading.

3. **Post-QC.** After QC findings recorded, before fix application.
   - On disk before compact: the QC findings list verbatim; each finding's proposed fix; per-finding disposition (ACCEPT / DISAGREE / DEFER).
   - Target file: `audits/working/qc-{date}-{topic}.md` (or in conversation context if QC produced a structured artifact).
   - Preferred next step: `/clear` + restart to apply fixes mechanically. Fix application is mechanical doing, not deciding — fresh context speeds it up.

4. **Pre-closeout.** Before `/wrap-session` runs.
   - On disk before compact: files created / modified this session; decisions made; next steps for the next session; open questions.
   - Target file: `logs/scratchpads/{YYYY-MM-DD}-{HH-MM}-scratchpad.md` (the continuity scratchpad `/wrap-session` Step 0.5 produces — same file, written by that step).
   - Preferred next step: usually no compact needed — `/wrap-session` is short and runs on existing conversation context. If the session has already crossed a high tool-call count and the wrap itself risks compaction, `/clear` after the scratchpad write and re-enter `/wrap-session`.

Common across all four: a scratchpad is cheap; a lost decision is expensive. Write before you compact.
