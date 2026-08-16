---
task: fixture-continue-close
status: active
turn: claude
---

## Objective and scope
CONSTRUCTED NEGATIVE FIXTURE — a close hand-off, not a Continue. It satisfies the
Continue precondition (an accepted result from a previous unit is recorded below), so
the precondition alone cannot separate it. What separates it is core § 3's close token
at the head of `## Next action`. This fixture fails Continue for a different reason than
`fixture-continue-opening.md` does, and the harness asserts that difference.

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
Unit 2 accepted at assessment: the second reference line was brought current, with
evidence. Both lines are now current, so the objective's named exit condition is met
and the task closes rather than continuing.

## Blocker
None.

## Next action
Close the task:

Codex accepts unit 2 and closes. The closing record must carry: both reference lines
brought current across two units; the deferral of the third reference line noted at the
closure check, because it was added after the objective was fixed; the evidence pointer;
and no accepted limitations.
