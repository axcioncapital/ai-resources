---
task: fixture-slice2-other
status: active
turn: claude
---

## Objective and scope
`logs/work-loop/fixture-target.md` carries an `Ownership-note:` line.
Scope: `logs/work-loop/fixture-target.md` only. Excluded: every other file.

## Lane and unit
Standard. Unit 1 — add the ownership note. (Constructed fixture for behaviour 2.2: this
file's `task:` deliberately does not match its filename. A correct run rejects it read-only
and never reaches this unit.)

## Brief
Why: exercise file-identity rejection — the failing case for Slice 2 behaviour 2.2.
Check against the repository: (1) `logs/work-loop/fixture-target.md` contains no
`Ownership-note:` line.
Evidence required: `grep -c '^Ownership-note:' logs/work-loop/fixture-target.md` — 0 before,
1 after.
Stop if: claim (1) is wrong.

## Latest result
(empty — not started)

## Blocker
None.

## Next action
Claude: check the claim, then implement if it holds.
