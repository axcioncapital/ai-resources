---
task: fixture-continue-malformed
status: active
turn: claude
---

## Objective and scope
CONSTRUCTED NEGATIVE FIXTURE — a malformed state file, not a Continue. Core § 4 makes the
active field headings normative and exact: "a file written under different headings is
malformed". This file writes `## Next steps` where core § 4 requires `## Next action`, so
a consumer reading the protocol literally finds no Next action at all.

It is deliberately malformed in a way that is easy to miss by eye and impossible to miss
structurally: every other heading is correct, the frontmatter is valid, and the content
below reads like an ordinary continue — accepted prior unit, new brief, no protocol token.
A check that looked only for an accepted result and an absent token would classify this as
a Continue and act on a file the protocol cannot address.

Scope: the fixture project's two stale reference lines. Excluded: any other file.

## Lane and unit
Standard. Unit 2 — bring the second reference line current.

## Brief
Why: unit 1's accepted result covered the first line only; the objective's named exit
condition remains unmet.
Check against the repository: (1) fixture-target-2.md still carries a second stale
reference line.
Evidence required: the second line current, the first untouched.
Stop if: claim (1) is wrong.

## Latest result
Unit 1 accepted at assessment: the first reference line was brought current, with
evidence, and the assessment continued the task because its named exit condition
(both lines current) remains unmet.

## Blocker
None.

## Next steps
Claude: check claim (1), then implement unit 2 on the brief above.
