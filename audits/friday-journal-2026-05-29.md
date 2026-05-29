---
report_date: 2026-05-29
type: friday-journal
source: ai-resources/logs/ai-journal.md
entry_count: 4
items_generated: 4
---

# /friday-journal report — 2026-05-29

## Summary

Four entries this week, all targeting the QC and resource-pipeline surface area. One [high] item (auto-apply QC fixes when verdict is REVISE and all findings are wording-level) is a direct recurrence of decision-point-posture friction — operator flagged a concrete example from the nordic project. Two [med] items strengthen existing pipelines (mandate QC at session-start, graduate-resource genericization); one [med] adds a new workspace-level command for project-folder cleanup. Calibration note: latest friday-checkup is 2026-05-22 (7 days old) — within the 10-day window, so priority signals are still reliable.

## Items

[high] Auto-apply /qc-pass fixes when verdict is REVISE and all findings are wording-level or mechanical, instead of prompting the operator.
[med] Add a self-check QC step to /session-start that validates the mandate before presenting it to the operator.
[med] Create a workspace-level /clean-folder command that produces a restructure plan for grown project folders (plan-only, no direct mutations).
[med] Strengthen /graduate-resource Step 4 generalization and Step 5 verification so graduated resources are reliably project-agnostic.

## Item context

### Auto-apply /qc-pass fixes when verdict is REVISE and all findings are wording-level or mechanical, instead of prompting the operator.
- **Files:** `ai-resources/.claude/commands/resolve.md`, `ai-resources/.claude/commands/qc-pass.md` (for finding-classification metadata), `ai-resources/docs/qc-independence.md` (auto-loop semantics)
- **Effort:** medium
- **Recommended approach:** Define a "wording-level / mechanical" finding class explicitly (typo fixes, factual reference corrections, line-number corrections, label-only mapping fixes — no editorial or scope changes). When `/qc-pass` returns REVISE AND every finding matches that class AND no finding carries a DISAGREE annotation, `/resolve` (or the QC → Triage auto-loop) applies all findings inline without the fix / fix N / approve prompt. Log the auto-apply event in `decisions.md` so operator sees the trail. Surface the prompt only when at least one finding is editorial or any DISAGREE is present. This realigns the QC-resolve flow with the workspace Decision-Point Posture rule (CLAUDE.md § Decision-Point Posture).
- **Risk-check required:** Yes (deterministic match: CLAUDE.md edits — cross-cutting). /friday-act must run /risk-check before landing this fix.
- **Source entry:** #. How can I automate qc pass fixes?
- Why can't Claude autonomously decide here? Example from nordic landscape project: QC verdict REVISE with 3 minor findings (typo at §4 line 207, B-MASTER-05 closure mapping under-counts at §3 line 193, optional clarification at Work Unit 4 line 140). All wording-level — none invalidate the plan's executability. Claude asked operator to pick fix / fix 1 2 / approve, with recommendation "fix all three." Why didn't Claude just apply the recommendation autonomously per decision-point posture?

### Add a self-check QC step to /session-start that validates the mandate before presenting it to the operator.
- **Files:** `ai-resources/.claude/commands/session-start.md`
- **Effort:** medium
- **Recommended approach:** Add a Step 2.5 (between mandate-draft and operator-confirmation) that runs a lightweight self-check against the mandate fields (work_scope, exit_condition, files_in_scope, stop_if): is the exit condition observable? is work_scope a single sentence with a verb and object? are inferred files marked `(inferred)`? Inline self-check is sufficient for the mandate's small surface area — no subagent needed, matches `/session-plan` Step 7 self-check pattern. If any check fails, revise inline before presenting. Operator-decision (Q3.1): scope is mandate-only, not /session-plan (which already has a Step 7 self-check).
- **Source entry:** #. QC pass on mandate creation (and session plan)
- Add a dedicated qc pass to mandate creation. Make it a command/skill/agent pipeline so it returns with a "qc'd" mandate before presenting it to you.
- Do the same thing for the session plan?

### Create a workspace-level /clean-folder command that produces a restructure plan for grown project folders (plan-only, no direct mutations).
- **Files:** new `ai-resources/.claude/commands/clean-folder.md` (placement TBD via /placement at build time — workspace shared command per operator answer Q1.1)
- **Effort:** medium
- **Recommended approach:** Workspace-level command (lives in `ai-resources/.claude/commands/`) that takes a project folder as argument. Steps: (1) inventory files and directories; (2) ask operator what to keep, archive, or remove; (3) produce a restructure plan (rename / move / archive proposals) to `audits/restructure-plans/{project}-{date}.md`. Plan-only output — no direct mutations, like /placement is advisory (operator Q1.2). Execution happens separately, ideally through a follow-on session that runs the plan. Naming candidates: `/clean-folder`, `/restructure-project`, `/folder-tidy` — pick at build time after `/placement` advisory.
- **Source entry:** #. Create a "clean folder" command
- After a project has grown, create a command for "cleaning" or "restructuring" the folder so its more clean and logical. Example: Buy-side service plan.
    - Include a step which asks what to keep, what to remove
    - Create a plan for restructuring, renaming things etc.

### Strengthen /graduate-resource Step 4 generalization and Step 5 verification so graduated resources are reliably project-agnostic.
- **Files:** `ai-resources/.claude/commands/graduate-resource.md` (Steps 4 + 5)
- **Effort:** low
- **Recommended approach:** The command already has Step 4 (generalize) and Step 5 (verify "no project-specific references remain"). The recurring problem the operator flagged suggests the verification is leaking project-specific content through. Audit Step 5's checks — currently a self-check; consider adding a brief subagent verification pass that grep-scans the generalized output for project names, hardcoded paths, and domain-specific terminology drawn from the source project's `CLAUDE.md`. Add a "fail and revise" loop: if Step 5 finds residue, Step 4 re-runs with the specific residue items called out. Run this against 2–3 recently-graduated resources to confirm the gap is real before redesigning the step.
- **Risk-check required:** Yes (deterministic match: CLAUDE.md edits — cross-cutting). /friday-act must run /risk-check before landing this fix.
- **Source entry:** #. fix in graduate resource command
- When graduating the resource from a local project, make sure that the resource is written in a way it can be used "uniformally" across the repo and is not project specific.
    - Problem: Many current project specific resources are written for the project itself. We need to come up with a process to "clean" the resources so they can work IN ANY PROJECT!
