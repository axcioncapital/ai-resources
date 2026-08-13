---
task: fixture-continue
turn: claude
---

## Objective and scope
The fixture project's two stale reference lines are brought current, one per unit.
Scope: fixture-target-2.md reference lines and this state file. Excluded: any other
file, any change beyond the two named lines.

## Lane and unit
Standard. Unit 2 — bring the second reference line current. Named reason for the
loop: the objective spans more than one unit, so it must survive a unit boundary
without closing the task.

## Brief
Why: unit 1's accepted result covers only the first line; the objective's named exit
condition — both lines current — remains unmet, so the task continues instead of
closing.
Check against the repository: (1) fixture-target-2.md still carries a second stale
reference line (search fixture-target-2.md for the pattern the brief names).
Evidence required: the second line current, the first line untouched.
Stop if: claim (1) is wrong, or the change would touch files outside the scope above.

## Latest result
Unit 1 accepted at assessment: the first reference line was brought current, with
evidence, and the assessment continued the task because its named exit condition
(both lines current) remains unmet.

## Blocker
None.

## Next action
Claude: check claim (1), then implement unit 2 on the brief above.
