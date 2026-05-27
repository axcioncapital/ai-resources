---
model: opus
---

# /fix-repo-issues — Backlog Fix-Plan Composer

Scan accumulated friction-log, improvement-log, and similar sources; triage by priority; write a self-contained fix plan to disk. Execution happens in a separate fresh session — this command does NOT apply fixes.

**Two-session contract.** Logs accumulate during work sessions. Fixing them inside the same session that produced them muddles cause and effect and risks compaction dropping the plan mid-execution. The natural cadence:

1. **Session A** (work) — produces friction-log entries, improvement-log items, decisions.
2. **Session B** (this command) — scans Session A's outputs, writes a fix plan to disk.
3. **Session C** (execute) — fresh session, operator reads the plan file and instructs Claude to apply each fix with clean context per item.

Sessions B and C may be the same calendar moment but are separate Claude Code sessions. This mirrors `/friday-act`'s plan-then-execute split.

**Boundary vs `/resolve-repo-problem`.** `/resolve-repo-problem` is reactive single-fault triage (something broke right now → investigate one fault → three ranked options). `/fix-repo-issues` is proactive batch-planning from the persistent backlog (drain accumulated items → ordered multi-item plan). No overlap in trigger, scope, or input source.

Input: `$ARGUMENTS` (optional) — free-form scope hint (e.g., "improvement-log only", "skip inbox"). If empty, scan all seven sources.

---

## Step 1 — Initialize and invoke scanner subagent

1. Set `WORKING_DIR` = absolute path to the current working directory (typically the `ai-resources/` repo root).
2. Set `TODAY` = today's date in `YYYY-MM-DD`.
3. Set `TIMESTAMP` = current time in `HHMM` (24-hour, no separator).
4. Set `AUDITS_WORKING_DIR` = `{WORKING_DIR}/audits/working/`.
5. Set `PLANS_DIR` = `{WORKING_DIR}/audits/fix-plans/`.

Invoke the `fix-repo-issues-scanner` agent with:
- `WORKING_DIR` = `WORKING_DIR`
- `TODAY` = `TODAY`
- `TIMESTAMP` = `TIMESTAMP`
- `AUDITS_WORKING_DIR` = `AUDITS_WORKING_DIR`

Capture the returned summary. The last line of the summary has shape `NOTES: {WORKING_NOTES_PATH}` — extract `WORKING_NOTES_PATH` from it.

If the summary starts with `ERROR:`, surface it to the operator verbatim and stop.

If the summary reports `Total items: 0`, print:
```
/fix-repo-issues — no backlog items found in {WORKING_DIR}.
Nothing to plan.
```
and stop.

---

## Step 2 — Prioritize and shortlist

Read the scanner summary in main context. Re-read `WORKING_NOTES_PATH` only if the summary's top-candidate list is insufficient to make a triage decision (default: rely on summary).

Rank items in this order:

1. **Explicit priority tags** — `[BLOCKING]` > `[CRITICAL]` > `[URGENT]` > `[HIGH]` (mirrors "Step 2 — Apply priority override" in `open-items.md`).
2. **Age** — improvement-log entries with `age_days > 42` (stale) get bumped one rank.
3. **Source weight** — active friction > applied-unverified improvement-log > inbox brief > deferred decision > stale checkbox.
4. **Estimated effort** — small + clear fixes (single-file edit, log-status flip, copy edit) preferred over open-ended investigations.

Group items into:

- **Plan-into-batch** (P1) — clear scope, well-defined fix, target 3–6 items. Items the execution session can apply without further research.
- **Park** — out of scope for this plan. Reason: needs dedicated session, blocked on decision, multi-file refactor, or scope ambiguity.
- **Skip** — already resolved (cross-matched against improvement-log applied + verified), or low-signal (`[LOW]` already filtered by scanner, but catch operator-flagged trivia here).

Honor any operator scope hint in `$ARGUMENTS` — e.g., "improvement-log only" restricts Plan-into-batch to items whose source is `logs/improvement-log.md`.

---

## Step 3 — Plan preview + inline clarify gate

Print the plan preview in chat (NOT yet written to disk):

```
## /fix-repo-issues plan preview — {N} items proposed

### Plan-into-batch
1. [id-NN] {one-line description} — source: {path} — fix: {one-line approach}
2. [id-NN] ...
...

### Park (not this plan)
- [id-NN] {description} — reason: {scope|needs-dedicated-session|decision-needed|multi-file-refactor}

### Skip
- [id-NN] {description} — reason: {already-resolved|low-signal}

Scanner notes: {WORKING_NOTES_PATH}
```

Then run an inline clarify-style gate (operator-confirmed shape, mirrors `/clarify`):

1. **Restate** — one short paragraph in plain English: what we're fixing and why these picks.
2. **Assumptions** — bullet list of load-bearing assumptions (e.g., "this improvement-log entry is still relevant," "fix scope = update file X only").
3. **Questions** — ask **≤5** questions, but ONLY if a question would change which items go into the plan or how a fix is scoped. Per repo decision-point posture, default to no questions when no genuine ambiguity remains.

End the gate with:
```
Approve this plan? (y / edit / abort)
  y     — write plan file to {PLANS_DIR}
  edit  — describe the edit (which items to add/remove/re-scope); re-run Step 2 and 3
  abort — no plan written, exit
```

Wait for the operator's reply. Plan-mode discipline applies — do not write the plan file until approved.

On `edit`: capture the operator's instructions, return to Step 2 with the adjustments. Loop up to 3 times; on the 4th edit, ask the operator whether to abort or accept current state.

On `abort`: print `/fix-repo-issues — aborted, no plan written.` and stop.

On `y`: proceed to Step 4.

---

## Step 4 — Write the plan file

1. Ensure `PLANS_DIR` exists. The directory `audits/fix-plans/` does not exist in the repo yet — create it on first run:
   ```bash
   mkdir -p "{PLANS_DIR}"
   ```
2. Compute `PLAN_PATH = {PLANS_DIR}/fix-repo-issues-{TODAY}-{TIMESTAMP}.md`.
3. Write the plan file using this exact schema:

```markdown
# Fix plan — {TODAY} {HH:MM from TIMESTAMP}

**Source command:** `/fix-repo-issues`
**Scanner notes:** [audits/working/fix-repo-issues-{TODAY}-{TIMESTAMP}.md]({WORKING_NOTES_PATH})
**Working directory:** {WORKING_DIR}
**Items:** {N}

## How to execute

Open a fresh Claude Code session in `{WORKING_DIR}`. Reference this file by path and instruct Claude:

> Execute the fix plan at `{PLAN_PATH}`.

Each item below is self-contained — apply in order. Commit per item or per logical batch (operator preference). For improvement-log status updates, read `ai-resources/.claude/commands/resolve-improvement-log.md` first to confirm the canonical `**Status:** applied YYYY-MM-DD` + `**Verified:**` schema before editing.

Do NOT execute fixes in the planning session that produced this file.

## Items

### [id-01] {one-line description}
- **Source:** [{source-path}]({source-path}){:line N if applicable}
- **Fix:** {concrete instruction — file to edit, edit shape, expected outcome}
- **Post-fix log update:** {improvement-log status flip / friction-log `[FADING-GATE] verified` annotation / none}
- **QC needed:** {yes — run /qc-pass after applying | no — log-hygiene-only edit}

### [id-02] {one-line description}
- **Source:** ...
- ...

(repeat for each Plan-into-batch item, ordered by priority then source weight)

## Parked items (not this plan)

- [id-NN] {description} — reason: {scope|needs-dedicated-session|decision-needed|multi-file-refactor}
- ...

## Skipped items

- [id-NN] {description} — reason: {already-resolved|low-signal}
- ...

## Scanner working-notes path (traceability)

{WORKING_NOTES_PATH}
```

4. Verify the file was written by reading it back. If any required section is empty or malformed, regenerate.

---

## Step 5 — Handoff

Print to the operator:

```
## /fix-repo-issues plan written — {N items}

Plan: [{relative path from WORKING_DIR}]({PLAN_PATH})
Scanner notes: [{relative path}]({WORKING_NOTES_PATH})

To execute: open a fresh session in {WORKING_DIR}, then say:
  "Execute the fix plan at {relative plan path}"

Suggested cadence:
  • Clear the plan in one focused session.
  • Commit per item or per logical batch (workspace commit-directly rules apply).
  • Run /usage-analysis + /wrap-session when done.
```

Do NOT execute any fixes in this session. Do NOT auto-spawn the execution session — handoff is operator-driven.

---

## Notes

- **No execution in this command.** The command writes a plan only. Any inline fix-application here would defeat the two-session split that motivates this command.
- **Subagent contract.** The scanner writes full normalized notes to `audits/working/` and returns a ≤30-line summary, per the subagent-contract rule in `ai-resources/CLAUDE.md`.
- **Scope hint.** `$ARGUMENTS` is a free-form filter, not a structured flag. Honor it in Step 2 prioritization. If unparseable, ignore and note in Step 3 assumptions.
- **Plan-file QC.** Plan files are substantive artifacts. After Step 4, an operator running `/qc-pass` on the written plan is appropriate but not auto-triggered — the inline clarify gate at Step 3 already provided one round of operator review.
- **Boundary recap.** Sibling commands and their distinct triggers:
  - `/open-items` — read-only inline backlog report (no plan file).
  - `/fix-repo-issues` — proactive batch-plan from the persistent backlog (this command).
  - `/resolve-repo-problem` — reactive single-fault triage (something broke).
  - `/friday-act` — Friday-cadence orchestrator (audit-driven, tier-aware).
  - `/resolve` — post-QC triage (QC-finding-sourced fixes only).
- **No companion execute command.** The plan file is self-explanatory enough that fresh-session Claude can pick it up via natural language. If execution sessions repeatedly need scaffolding, revisit and consider a `/execute-fix-plan` sibling.

$ARGUMENTS
