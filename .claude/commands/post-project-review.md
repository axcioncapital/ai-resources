---
model: opus
---

Point this at a completed (or paused) project and get a process diagnosis plus a v2 improvement plan. Reads the project's declared workflow and its logs, then writes a **diagnosis** of frictions, unproductive steps, and approach-level "was this the right process at all" findings — and, after one operator gate, a separate **v2 implementation plan**.

## Relationship to other commands

This fills a project-level gap; it does not duplicate the session- or workspace-level tools.

- **`/improve`** diagnoses one **session's** friction. This command consumes the `improvement-log.md` it produces rather than re-deriving it — it never re-proposes an already-logged improvement.
- **`/coach`** reads operator collaboration patterns; this reads the **project's process**.
- **`/analyze-workflow`** reads canonical templates under `workflows/`; this reads a single **deployed project's** own workflow + logs.
- **`/archive-project`** closes a project out but diagnoses nothing. Run `/post-project-review` *before* archival — its v2 plan is the thing archival would otherwise lose.

## Usage

- `/post-project-review <project-name>` — diagnose one project (e.g. `research-pe-regime-shift-advisory-gap`).
- `/post-project-review <project-name> deep` — same, but read `session-notes.md` in full instead of targeted (use for short projects or when standard mode flags gaps).

## Instructions

### Step 1 — Resolve the project

Parse `$ARGUMENTS`: the first token is the project name; an optional `deep` token anywhere sets deep mode.

- If no project name is given, list the directories under `projects/` and ask the operator which one to review. Stop until answered.
- Resolve `PROJECT = projects/<name>/`. If it does not exist, print the available project names and stop.
- Resolve `TODAY` from the environment date.

Do not write or edit any project source file. Use `Read`, `Grep`, `Bash` (`ls`) for input gathering, and `Write` only for the two output artifacts in Steps 4 and 6.

### Step 2 — Read the declared workflow (intended process)

1. Read `PROJECT/CLAUDE.md`. Extract the **Workflow Overview** and **Artifact chain** sections — most projects declare both; capture the nearest equivalent (e.g. some projects name the artifact sequence "Skill Dependency Chain" or similar). This is the workflow the project was *supposed* to follow.
2. `ls -1` the top level of `PROJECT/` to capture the **actual** lifecycle stages present on disk (e.g. `preparation/`, `execution/`, `analysis/`, `report/`, `final/`).
3. Hold both for the Step-4 alignment check. If `CLAUDE.md` is missing or declares no workflow, note that as the first finding (a project with no declared process is itself a diagnosis result) and diagnose from logs alone.

### Step 3 — Read the logs (graceful source table)

Run `ls -1 PROJECT/logs/` first. If the `logs/` directory is absent entirely, note it in the Method line of the Step-4 report and diagnose from CLAUDE.md and on-disk directory structure alone — do not stop.

For each file in the table below, **skip silently if absent** — projects vary significantly (data-driven projects may have only `session-notes.md` + `coaching-data.md`). The read strategy is **size-aware but must never silently truncate**: if you sample rather than read a file in full, say so explicitly in the report's Method line (no-silent-caps rule).

| Source | Read | Mine for |
|---|---|---|
| `PROJECT/logs/decisions.md` | full | reversals, skill-vs-stage-instructions drift, `Defer`/`Deferred` items with a `Trigger for action:` |
| `PROJECT/logs/friction-log.md` | full | friction events — **cluster by recurring root cause, not single incidents** |
| `PROJECT/logs/qc-log.md` *(if present)* | full | QC churn — repeated REVISE/FAIL on the same artifact |
| `PROJECT/logs/usage-log.md` *(if present)* | full | token-cost trajectory across sessions (a waste signal) |
| `PROJECT/logs/coaching-data.md` *(if present)* | full | iteration counts, QC saturation, mandate-completeness drift |
| `PROJECT/logs/session-notes.md` | **targeted** (standard) / **full** (`deep`) | per-session **Mandate**, **Outcome**, **Session Assessment**, and **Next Steps** blocks. This file can exceed 80k — in standard mode read it in offset windows and pull only those four block types; in `deep` mode read it whole. Also read any `PROJECT/logs/session-notes-archive-*.md`. |
| `PROJECT/logs/improvement-log.md` *(if present)* | full | already-logged improvements — **do not re-propose these; reference them by entry title instead**. Also read `PROJECT/logs/improvement-log-archive.md` if present (mirrors `/improve`'s dedup scope). |

While reading, build a **carry-forward trace**: collect each session's `Next Steps` items and check whether the same item reappears as an unmet need in a later session — recurring-but-unresolved carry-forwards are a primary waste signal for Step 4 §3.

### Step 4 — Write the diagnosis report

Before writing, ensure `PROJECT/audits/` exists — run `mkdir -p PROJECT/audits` if needed. Write to `PROJECT/audits/post-project-review-<TODAY>.md`. Open with a one-line **Method** note stating which logs were read, which were absent, and whether `session-notes.md` was sampled or read in full. Then:

1. **Lifecycle alignment** — declared workflow (Step 2) vs. actual stages on disk. Flag merged stages, missing stages, and dead/empty stages.
2. **Friction clusters** — recurring frictions grouped by root cause, each citing the underlying `friction-log` entries by date. Give each cluster a severity tier.
3. **Unproductive / wasteful steps** — rework, QC churn, token-cost spikes, and carry-forwards that recurred across sessions without resolution (from the Step-3 trace).
4. **Approach-level findings** — the strategy lens: *was this pipeline shape right at all?* Should stages be merged, a validation gate added, a tool reassigned (per the multi-tool ecosystem), or a manual step automated? Keep this **evidence-cited and separated from execution-level friction** — an approach finding claims the process was mis-shaped, not merely bumpy.
5. **Severity-tiered finding list** — every finding from §1–4 as one consolidated list, tiered **Critical / Important / Minor**. This list is the spine the v2 plan consumes; give each finding a short stable ID (e.g. `F1`, `F2`).

### Step 5 — Operator gate

Print the diagnosis summary and the tiered finding list in chat. Ask which findings to carry into the v2 plan. Default, stated explicitly: **all Critical + Important**. Wait for the operator's selection (e.g. "all", "carry F1 F3 F5", "Critical only"). This is the command's single gate — it honors the diagnosis-*then*-plan sequence.

### Step 6 — Write the v2 implementation plan

Write to `PROJECT/audits/post-project-review-v2-plan-<TODAY>.md`. For each carried finding, one entry:

- **Addresses:** the finding ID + one-line restatement.
- **Change:** the concrete process change — targeted at the **project's own** `CLAUDE.md` workflow, its `reference/stage-instructions.md`, or its tool assignments. **Not** the canonical `workflows/` templates.
- **Effort:** rough estimate (trivial / moderate / heavy).
- **Risk:** one-line note (what could regress, or "low").

Order entries by severity, then effort (quick high-value first). Close with a short **Sequencing** note if some changes depend on others.

### Step 7 — Summarize

In chat: finding counts by tier, the two output file paths (as markdown links), and one line naming the top approach-level finding. No extra log file. No auto-commit beyond the two artifacts — leave staging/commit to the normal session flow.

$ARGUMENTS
