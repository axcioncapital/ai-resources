---
task: fixture-continue-correction
turn: claude
---

## Objective and scope
CONSTRUCTED NEGATIVE FIXTURE — a correction hand-off, not a Continue. Like
`fixture-continue-close.md` it satisfies the Continue precondition, and like a Continue
it keeps the task open and passes the turn to Claude with work to do. Only core § 3's
correction token at the head of `## Next action` separates it. This is the negative case
closest to a Continue, and the one a prose-reading check would most easily miss: a
correction is not an acceptance, and routing it as one would smuggle findings past the
bounded correction round.

Scope: the fixture project's two stale reference lines. Excluded: any other file.

## Lane and unit
Standard. Unit 2 — bring the second reference line current.

## Brief
Why: unit 1's accepted result covered the first line only.
Check against the repository: (1) fixture-target-2.md still carries a second stale
reference line.
Evidence required: the second line current, the first untouched.
Stop if: claim (1) is wrong.

## Latest result
Unit 2 delivered the second reference line, and unit 1's earlier result stays accepted.
The assessment found two material problems in unit 2's work, so the unit is not accepted
and the task does not continue past it.

## Blocker
None.

## Next action
Correct once — frozen findings:

1. The second reference line was updated but its surrounding sentence still names the
   superseded document, so the line reads correct in isolation and wrong in place.
2. The evidence greps for a string the brief itself supplied, so it would pass whether or
   not the line changed (core § 6 rule 5).
