---
task: fixture-slice3-close
turn: claude
---

## Objective and scope
`logs/work-loop/fixture-target-2.md` carries a `Slice3-close-note:` line marking the Slice 3
admission-discipline runs as complete.
Scope: `logs/work-loop/fixture-target-2.md` only. Excluded: every other file.

## Lane and unit
Standard. Unit 1 — add the line. Named reason for the loop: the result must be assessed by
someone other than whoever built it before it counts as done.

## Brief
Why: the fixture should record, in the file itself, that the admission-discipline runs it served
are finished — a reader opening it later should not have to reconstruct that from Git.
Check against the repository: (1) `logs/work-loop/fixture-target-2.md` contains no
`Slice3-close-note:` line; (2) the same file has a `## Body` section.
Evidence required: `grep -c '^Slice3-close-note:' logs/work-loop/fixture-target-2.md` — 0 before
this unit, 1 after, with the 0-state visible at the commit that opened this task.
Stop if: claim (1) is wrong, or the change would touch any file outside the scope.

## Latest result
(empty — not started)

## Blocker
None.

## Next action
Claude: check both claims, then implement if they hold.
