---
task: fixture-slice1-codex
turn: claude
---

## Objective and scope
`logs/work-loop/fixture-target.md` carries a standalone ownership declaration that names Work Loop v2, so its owning system remains explicit when the file is read by itself.

Implementation scope: `logs/work-loop/fixture-target.md` only. Excluded from implementation: every other repository file, Work Loop v1 bookkeeping, and any broader cleanup of the fixture. The task-state hand-off remains protocol, not implementation scope.

## Lane and unit
Standard. Unit 1 — add the explicit Work Loop ownership declaration. The named reason for using the loop is that this is a Work Loop v2 Slice 1 acceptance unit whose Codex→Claude hand-off and independently assessed evidence are part of the result.

## Brief
Why: the target currently mentions Work Loop v2 as acceptance context, but a dedicated ownership declaration makes the governing version unambiguous and protects the file from being mistaken for Work Loop v1 bookkeeping.

Check against the repository:
(1) The executable core assigns Work Loop v2 task-state files to `logs/work-loop/` and says Work Loop v1 scans `logs/loop/`.
(2) `logs/work-loop/fixture-target.md` contains contextual references to Work Loop v2.
(3) `logs/work-loop/fixture-target.md` contains no standalone line beginning `Work Loop owner:`; search that file for the anchored pattern `^Work Loop owner:`.

If all claims hold, add one concise standalone ownership declaration naming Work Loop v2 without changing the fixture's other meaning.

Evidence required: record that `grep -c '^Work Loop owner: v2$' logs/work-loop/fixture-target.md` returns `0` before the change and `1` after it, and that `grep -c '^Work Loop owner:' logs/work-loop/fixture-target.md` returns exactly `1` after the change. These checks must fail if the declaration is absent, names the wrong version, or is duplicated.

Stop if: any claim is false; the repository defines a different canonical ownership marker; the result would require changing another implementation file; or the change would alter more than the target's ownership declaration.

## Next action
Claude: validate the state file and all three claims read-only, implement only if they hold, record the inspection and failing-capable evidence here, set `turn: codex`, and commit the complete hand-off.
