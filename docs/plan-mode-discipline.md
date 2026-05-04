# Plan Mode Discipline

> **When to read this file:** When entering or exiting plan mode in a QC-fix flow, when the harness forces plan-mode re-entry, or when a fix targets a previously approved plan — for the QC-fix re-entry exception and the plan-QC tiebreaker.

**For QC-fix re-entry only —** do not re-enter plan mode to address QC findings on work you just completed in the same session. When `/qc-pass` surfaces issues on recently-landed work and the operator directs a fix, execute the fix in the same flow as the original work — no fresh Explore pass, no new Plan agent, no AskUserQuestion-before-ExitPlanMode ritual.

Re-enter plan mode only for genuinely new planning work: a new task, a direction change, or a fix whose scope the operator has not already seen. A follow-up correction to your own recently-announced output is not new planning.

If the harness forces plan mode re-entry (system-reminder on slash command, keyboard toggle), still avoid the full five-phase ritual for small fixes: write a minimal plan file (3–5 lines), exit plan mode, and execute.

**Tiebreaker for the overlap case:** When fixing QC findings on previously approved report prose, this rule takes precedence over any project-level "plan mode before drafting" directive. Extending: when a QC fix targets a previously approved *plan* (not yet executed), the QC Independence Rule plan-QC requirement fires only on the *first* presentation of the plan, not on revisions. Subsequent revisions to a plan that has already been QC'd in this session do not require re-running the plan-QC pass — apply the fix in the same flow as the original plan presentation.
