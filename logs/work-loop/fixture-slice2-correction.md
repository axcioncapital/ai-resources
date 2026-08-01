---
task: fixture-slice2-correction
turn: claude
---

## Objective and scope
`logs/work-loop/fixture-target.md` ends with a `## Correction exercise` section containing
exactly two lines: `Round: one` and `Scope: frozen`.
Scope: `logs/work-loop/fixture-target.md` only. Excluded: every other file.

## Lane and unit
Standard. Unit 1 — add the section. Named reason for the loop: the result must be assessed
by someone other than whoever built it before it counts as done.

## Brief
Why: Slice 2 behaviours 2.3 and 2.4 need a real unit whose result carries material findings
for the assessment to name, and whose one bounded correction is exercised for real.
Check against the repository: (1) `logs/work-loop/fixture-target.md` contains no
`## Correction exercise` heading; (2) the same file contains no `Round:` line.
Evidence required: the section present at the end of the file with both lines, shown by a
check that returned differently before the unit.
Stop if: claim (1) or (2) is wrong, or the change would touch any file outside the scope.

## Latest result
(empty — not started)

## Blocker
None.

## Next action
Claude: check both claims by inspection, then implement if they hold.
