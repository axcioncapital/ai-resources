---
task: fixture-continue-opening
status: active
turn: claude
---

## Objective and scope
CONSTRUCTED NEGATIVE FIXTURE — an ordinary first unit, not a Continue. It carries the
exact shape a Continue also has (a new brief, and a `## Next action` opening with
neither protocol token) and differs only in the precondition: no previous unit of this
task has been accepted. Core § 3 *Continuing* is what this fixture holds the classifier to.

Scope: the fixture project's two stale reference lines. Excluded: any other file.

## Lane and unit
Standard. Unit 1 — bring the first reference line current. Named reason for the loop:
the objective spans more than one unit, so it must survive a unit boundary.

## Brief
Why: both reference lines are stale; the first is the smallest unit that delivers
something observable.
Check against the repository: (1) fixture-target-2.md still carries a first stale
reference line (search fixture-target-2.md for the pattern the brief names).
Evidence required: the first line current, the second untouched.
Stop if: claim (1) is wrong, or the change would touch files outside the scope above.

## Latest result
(empty — not started)

## Blocker
None.

## Next action
Claude: check claim (1), then implement unit 1 on the brief above.
