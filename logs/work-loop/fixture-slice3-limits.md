---
task: fixture-slice3-limits
turn: claude
---

## Objective and scope
`logs/work-loop/fixture-target-2.md` carries a `Slice3-limits-note:` line summarising the file's
acceptance role, worded to cover every Slice 3 run.
Scope: `logs/work-loop/fixture-target-2.md` only. Excluded: every other file.

## Lane and unit
Standard. Unit 1 — add the summary line. Named reason for the loop: the result must be assessed
by someone other than whoever built it before it counts as done.

## Brief
Why: the fixture's acceptance role should be readable from the file itself once Slice 3 is done.
Check against the repository: (1) `logs/work-loop/fixture-target-2.md` contains no
`Slice3-limits-note:` line; (2) the same file has a `## Body` section.
Evidence required: `grep -c '^Slice3-limits-note:' logs/work-loop/fixture-target-2.md` — 0 before
this unit, 1 after, with the 0-state visible at the commit that opened this task.
Stop if: claim (1) is wrong, or the change would touch any file outside the scope.

## Latest result
(empty — not started)

## Blocker
None.

## Next action
Claude: check both claims, then implement if they hold.
