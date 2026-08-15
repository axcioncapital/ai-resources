---
task: fixture-mode-implementation
status: active
turn: claude
---

## Objective and scope

A `Mode-fixture:` line is present and current in `logs/work-loop/fixture-target-3.md`.
Scope: that one file and this state file. Excluded: every other file.

## Lane and unit

Standard. Implementation mode. Unit 1 — add the line and show it.

Named reason for the loop: the scope needs bounding before work starts, or it will spread.
`fixture-target-3.md` is the live-seam target — the seam assertions read its `Seam-step-1:` and
`Seam-step-2:` lines at specific commits — so "add a line to it" reaches into the ordering and
content those assertions depend on unless the boundary is fixed first.

## Brief

Why: the mode contract needs one worked Implementation example whose evidence has a failing case.

Check against the repository: (1) `logs/work-loop/fixture-target-3.md` exists; (2) it carries no
`Mode-fixture:` line — searched that file for `^Mode-fixture:`.

Evidence required: the check returns 0 before the work and 1 after.

Stop if: claim (2) is wrong, or the change would touch a file outside the scope above.

Completion: the implemented result is in place with its failing case shown and the regression
protection relevant to it, evidence written into `## Latest result`, `turn: codex`.

## Latest result

(empty — not started)

## Blocker

None.

## Next action

Claude: check both claims, then implement if they hold.
