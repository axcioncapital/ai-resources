---
model: opus
---

# /fix-repo-issues — Backlog Fix-Plan Composer

Scan accumulated friction-log, improvement-log, innovation-registry, and similar sources across the workspace; triage by priority; write a self-contained fix plan to disk. Execution happens in a separate fresh session — this command does NOT apply fixes.

**Two-session contract.** Logs accumulate during work sessions. Fixing them inside the same session that produced them muddles cause and effect and risks compaction dropping the plan mid-execution. The natural cadence:

1. **Session A** (work) — produces friction-log entries, improvement-log items, decisions.
2. **Session B** (this command) — scans Session A's outputs, writes a fix plan to disk.
3. **Session C** (execute) — fresh session, operator reads the plan file and instructs Claude to apply each fix with clean context per item.

Sessions B and C may be the same calendar moment but are separate Claude Code sessions. This mirrors `/friday-act`'s plan-then-execute split.

**Boundary vs `/resolve-repo-problem`.** `/resolve-repo-problem` is reactive single-fault triage (something broke right now → investigate one fault → three ranked options). `/fix-repo-issues` is proactive batch-planning from the persistent backlog (drain accumulated items → ordered multi-item plan). No overlap in trigger, scope, or input source.

**Boundary vs `/fix-project-issues`.** `/fix-project-issues` operates on exactly one scope (the project at hand), reads its dated diagnostic *reports* plus its logs, and **executes** the do-now fixes in the same session. This command is multi-scope (operator-selected across the workspace), logs-only, and **plan-only** (execution happens in a separate session). Use `/fix-project-issues` to clean up one project now; use this to drain the accumulated backlog across scopes for a later fix session.

**Multi-scope.** The command scans across operator-selected workspace scopes: `ai-resources` (always on), `workspace` root, and any active project under `projects/`. The plan aggregates findings across all selected scopes, with per-item scope attribution so the execution session knows where to apply each fix.

Input: `$ARGUMENTS` (optional) — free-form triage hint (e.g., "improvement-log only", "skip inbox"). Applies to triage (Step 3), not scope selection (Step 1). If empty, no hint applied.

---

## Step 1 — Initialize and select scopes

1. Set `AI_RESOURCES = "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources"`.
2. Set `WORKSPACE_ROOT = "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"`.
3. Set `TODAY` = today's date in `YYYY-MM-DD`.
4. Set `TIMESTAMP` = current time in `HHMM` (24-hour, no separator).
5. Set `AUDITS_WORKING_DIR = "{AI_RESOURCES}/audits/working/"`.
6. Set `PLANS_DIR = "{AI_RESOURCES}/audits/fix-plans/"`.

**Enumerate active projects** under `{WORKSPACE_ROOT}/projects/`:

```bash
ls -1d /Users/patrik.lindeberg/Claude\ Code/Axcion\ AI\ Repo/projects/*/ 2>/dev/null
```

For each enumerated project directory, derive:
- `project_name` = basename (e.g., `nordic-pe-macro-landscape-H1-2026`)
- `project_path` = absolute path to the project directory
- `project_slug` = `project-{project_name}` (used in file names and id prefixes)

**Build the scope menu.** Present a numbered menu mirroring `/friday-checkup` Step 3:

```
## /fix-repo-issues — select scopes

   1. ai-resources           (always on — cannot be deselected)
   2. workspace              (workspace-root logs/)
   3a. project {name-1}
   3b. project {name-2}
   3c. project {name-3}
   ...

Reply with a comma-separated list of scope numbers to include, or `all`.
Examples:
  1                      (ai-resources only — equivalent to old single-scope behavior)
  1,2                    (ai-resources + workspace)
  1,3a,3c                (ai-resources + 2 selected projects)
  all                    (every scope)
```

**Parse the operator's reply:**
- `all` (case-insensitive, trimmed) → select every scope shown.
- `none` (case-insensitive, trimmed) → ai-resources only (mirrors `/friday-checkup` Step 3 parity — `none` means "no extra scopes beyond the always-on one").
- Comma-separated number/letter list → select matching scopes; `1` is implicit and always selected even if omitted.
- Empty reply or bare `1` → ai-resources only.
- Unparseable → re-ask once with the same menu; on second unparseable, default to `1` only and proceed.

**Build the `SCOPES` list** as ordered `[(scope_label, scope_slug, scope_path), ...]`:
1. ai-resources first (always): `("ai-resources", "ai-resources", "{AI_RESOURCES}")`.
2. workspace second (if selected): `("workspace", "workspace", "{WORKSPACE_ROOT}")`.
3. Each selected project, alphabetical by `project_name`: `("project {name}", "project-{name}", "{project_path}")`.

Print the selected scope list back to the operator in one line for confirmation:
```
Scanning {N} scope(s): {comma-separated labels}
```

---

## Step 2 — Invoke scanner subagent per scope

For each `(scope_label, scope_slug, scope_path)` in `SCOPES`, invoke `fix-repo-issues-scanner` once. Inputs to each invocation:

- `WORKING_DIR` = `scope_path`
- `SCOPE_SLUG` = `scope_slug`
- `TODAY` = `TODAY`
- `TIMESTAMP` = `TIMESTAMP`
- `AUDITS_WORKING_DIR` = `AUDITS_WORKING_DIR` (always the ai-resources audits/working/ path, regardless of scope — all scanner notes co-locate there)

The scanner writes its working-notes file to `{AUDITS_WORKING_DIR}/fix-repo-issues-{TODAY}-{TIMESTAMP}-{scope_slug}.md` and returns a ≤30-line summary. Each summary ends with `NOTES: {working_notes_path}`.

Capture all summaries in main context — one per scope. If a summary starts with `ERROR:`, surface it verbatim, note the scope as failed, and skip it (continue with the remaining scopes).

**Multi-scope efficiency.** Invocations are independent — fire all scanner subagents in parallel via a single message with N Agent tool calls. Wait for all summaries before proceeding to Step 3.

If every scope returns `Total items: 0` (after all scanners complete), print:
```
/fix-repo-issues — no backlog items found across {N} scopes.
Nothing to plan.
```
and stop.

---

## Step 3 — Aggregate, prioritize, and shortlist

Read all scanner summaries in main context. Re-read individual working-notes paths only if a summary's top-candidate list is insufficient (default: rely on summaries).

**Item ids are scope-prefixed**: `[ai-resources/id-NN]`, `[workspace/id-NN]`, `[project-{name}/id-NN]`. The scope prefix is the `scope_slug` from Step 1. Within each scope, ids match that scanner's own numbering — no global renumbering.

### Step 3.0 — Reconcile against live state (reconcile-at-read)

Before aggregating, demote items the live repo shows are already done. Apply the canonical primitive in `ai-resources/docs/backlog-reconciliation.md` (read it for the full mechanism, tolerance posture, and contract). The scanner's log-to-log friction↔improvement cross-match catches only one staleness mode; this adds git evidence for items fixed by a commit but never status-flipped.

- **Anchored-only.** Reconcile only candidates carrying a commit-resolvable anchor (dated improvement-log / friction-log entries). Anchorless candidates (inbox briefs, `next-up.md` and session-plan checkboxes) pass through untouched.
- **Merged multi-repo scan (required for this command).** `/fix-repo-issues` is multi-scope, so the git cross-check MUST run the primitive's merged scan across **cwd + `ai-resources` + sibling `projects/*/` repos**, NOT a per-scope-repo-only scan. A `project-{name}` item is frequently resolved by a commit in `ai-resources` (canonical command/doc/log edits) or another project repo; a per-scope-only scan would miss those cross-repo resolutions. Reuse one `--since=<earliest-anchor>` result set across all candidates regardless of which scope they came from.
- **Classify** with the conservative posture (commit-hash / `id-NN` token first; distinctive keywords otherwise; when in doubt → still-open). Match candidates from every scope against the single merged result set.
- **Route matches to Skip.** A `LIKELY_DONE` candidate folds into the **Skip** group below with reason `already-resolved (commit {hash})`. Still-open candidates flow into the normal aggregation/ranking unchanged.
- **Fall-through:** if git fails or returns nothing, treat all candidates as still-open and continue.

Aggregate all items across scopes into a unified ranking, applying:

1. **Explicit priority tags** — `[BLOCKING]` > `[CRITICAL]` > `[URGENT]` > `[HIGH]` (mirrors "Step 2 — Apply priority override" in `open-items.md`).
2. **Age** — improvement-log entries with `age_days > 42` (stale) get bumped one rank.
3. **Source weight** — active friction > applied-unverified improvement-log > inbox brief > deferred decision > stale checkbox > innovation-registry pending-triage > innovation-registry triaged-stale > coaching-log carry-forward > gate-calibration follow-up.
4. **Estimated effort** — small + clear fixes (single-file edit, log-status flip, copy edit) preferred over open-ended investigations.

Group items into:

- **Plan-into-batch** (P1) — clear scope, well-defined fix, target 3–6 items. Items the execution session can apply without further research.
- **Park** — out of scope for this plan. Reason: `needs-dedicated-session`, `decision-needed`, `multi-file-refactor`, `needs-/innovation-sweep`, `needs-/create-skill`, `risk-check-class`, `low-roi` (the item fails the named-consequence test per `docs/materiality-bar.md` — no statable consequence of leaving it unfixed; mirrors `/friday-act` Step 3.1a's named-consequence overlay). `low-roi` is a free-text Park *reason* only — never promote it to a scanned status token in the source logs.
- **Skip** — already resolved (cross-matched against improvement-log applied + verified, OR git-reconciled at Step 3.0 with reason `already-resolved (commit {hash})`), or low-signal (`[LOW]` already filtered by scanner, but catch operator-flagged trivia here).

Honor any free-form hint in `$ARGUMENTS` — e.g., "improvement-log only" restricts Plan-into-batch to items whose source is `logs/improvement-log.md` across all selected scopes.

---

## Step 4 — Plan preview + inline clarify gate

Print the plan preview in chat (NOT yet written to disk):

```
## /fix-repo-issues plan preview — {N} items proposed across {M} scope(s)

Scopes scanned: {comma-separated labels}

### Plan-into-batch
1. [{scope_slug}/id-NN] {one-line description} — source: {path} — fix: {one-line approach}
2. [{scope_slug}/id-NN] ...
...

### Park (not this plan)
- [{scope_slug}/id-NN] {description} — reason: {reason-tag}

### Skip
- [{scope_slug}/id-NN] {description} — reason: {already-resolved|already-resolved (commit {hash})|low-signal}

Scanner notes per scope:
  - {scope_label}: {working_notes_path}
  - ...
```

Then run the inline clarify-style gate (mirrors `/clarify`):

1. **Restate** — one short paragraph in plain English: what we're fixing, which scopes, why these picks.
2. **Assumptions** — bullet list of load-bearing assumptions (e.g., "this improvement-log entry is still relevant," "fix scope = update file X only").
3. **Questions** — ask **≤5** questions, but ONLY if a question would change which items go into the plan or how a fix is scoped. Per repo decision-point posture, default to no questions when no genuine ambiguity remains.

End the gate with:
```
Approve this plan? (y / edit / abort)
  y     — write plan file to {PLANS_DIR}
  edit  — describe the edit (which items to add/remove/re-scope); re-run Step 3 and 4
  abort — no plan written, exit
```

Wait for the operator's reply. Plan-mode discipline applies — do not write the plan file until approved.

On `edit`: capture the operator's instructions, return to Step 3 with the adjustments. Loop up to 3 times; on the 4th edit, ask the operator whether to abort or accept current state.

On `abort`: print `/fix-repo-issues — aborted, no plan written.` and stop.

On `y`: proceed to Step 5.

---

## Step 5 — Write the plan file

1. Ensure `PLANS_DIR` exists. The directory `audits/fix-plans/` may not exist yet — create on first run:
   ```bash
   mkdir -p "{PLANS_DIR}"
   ```
2. Compute `PLAN_PATH = {PLANS_DIR}/fix-repo-issues-{TODAY}-{TIMESTAMP}.md`.
3. Write the plan file using this exact schema:

```markdown
# Fix plan — {TODAY} {HH:MM from TIMESTAMP}

**Source command:** `/fix-repo-issues`
**Scopes scanned:** {comma-separated scope labels}
**Scanner notes (per scope):**
- {scope_label}: [audits/working/fix-repo-issues-{TODAY}-{TIMESTAMP}-{scope_slug}.md]({absolute path})
- ...
**Plans directory:** {PLANS_DIR}
**Items:** {N}

## How to execute

Open a fresh Claude Code session. Each item's `**Scope:**` field names the working directory it applies in — `cd` into that directory before applying its fix.

Instruct fresh-session Claude:

> Execute the fix plan at `{PLAN_PATH}`.

Each item below is self-contained — apply in order, in the scope its `**Scope:**` field names. Commit per item or per logical batch (operator preference). For improvement-log status updates, read `ai-resources/.claude/commands/resolve-improvement-log.md` first to confirm the canonical `**Status:** applied YYYY-MM-DD` + `**Verified:**` schema before editing.

Do NOT execute fixes in the planning session that produced this file.

## Items

### [{scope_slug}/id-01] {one-line description}
- **Scope:** {scope_label} — path: `{scope_path}`
- **Source:** [{absolute_source_path}]({absolute_source_path}){:line N if applicable}  *(always render the absolute path — the plan file lives in `ai-resources/audits/fix-plans/` but item sources span scopes; absolute paths keep links resolvable regardless of where the execution session is `cd`'d)*
- **Fix:** {concrete instruction — file to edit, edit shape, expected outcome}
- **Post-fix log update:** {improvement-log status flip / friction-log `[FADING-GATE] verified` annotation / innovation-registry status update / none}
- **QC needed:** {yes — run /qc-pass after applying | no — log-hygiene-only edit}

### [{scope_slug}/id-02] {one-line description}
- ...

(repeat for each Plan-into-batch item; ordered by priority then source weight, with ai-resources items first, then workspace, then projects alphabetically)

## Parked items (not this plan)

- [{scope_slug}/id-NN] {description} — reason: {reason-tag}
- ...

## Skipped items

- [{scope_slug}/id-NN] {description} — reason: {already-resolved|already-resolved (commit {hash})|low-signal}
- ...
```

4. Verify the file was written by reading it back. If any required section is empty or malformed, regenerate.

---

## Step 6 — Handoff

Print to the operator:

```
## /fix-repo-issues plan written — {N items across {M} scope(s)}

Plan: [{relative path}]({PLAN_PATH})
Scanner notes:
  - {scope_label}: {relative_notes_path}
  - ...

To execute: open a fresh session, then say:
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
- **Subagent contract.** The scanner writes full normalized notes to `audits/working/` per scope and returns a ≤30-line summary per invocation, per the subagent-contract rule in `ai-resources/CLAUDE.md`.
- **Scope-prefixed ids.** Each scanner has its own `id-01..id-NN` numbering scoped to its working directory. The main session aggregates across scopes using scope-slug prefixes (`[ai-resources/id-01]`, `[workspace/id-01]`, `[project-{name}/id-01]`) — no global renumbering. Notes files always co-locate under `ai-resources/audits/working/` regardless of source scope (single audit-trail directory).
- **Triage hint.** `$ARGUMENTS` is a free-form filter applied to triage (Step 3), not to scope selection (Step 1). If unparseable, ignore and note in Step 4 assumptions.
- **Plan-file QC.** Plan files are substantive artifacts. After Step 5, an operator running `/qc-pass` on the written plan is appropriate but not auto-triggered — the inline clarify gate at Step 4 already provided one round of operator review.
- **Boundary recap.** Sibling commands and their distinct triggers:
  - `/open-items` — read-only inline backlog report (no plan file).
  - `/fix-repo-issues` — proactive batch-plan from the persistent backlog (this command).
  - `/resolve-repo-problem` — reactive single-fault triage (something broke).
  - `/friday-act` — Friday-cadence orchestrator (audit-driven, tier-aware).
  - `/resolve` — post-QC triage (QC-finding-sourced fixes only).
  - `/innovation-sweep` — innovation-registry triage (untriaged detected entries).
  - `/create-skill` — inbox brief fulfillment (build-shaped items).
- **No companion execute command.** The plan file is self-explanatory enough that fresh-session Claude can pick it up via natural language. If execution sessions repeatedly need scaffolding, revisit and consider a `/execute-fix-plan` sibling.

$ARGUMENTS
