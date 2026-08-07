---
task: fixture-noprem-prose
turn: codex
---

## Objective and scope
CONSTRUCTED FIXTURE — a completed documentation-only unit with no load-bearing premise
to test. Its subject is one sentence of its own brief's wording: the unit rewrote that
sentence for clarity and changed nothing else. The only premise such a unit rests on is
the current text, which is visible in the change itself, so there is nothing an
inspection could have found that a reader of the change cannot see.

This fixture is what the command's Step 2 proportionality rule is held to. It is the
opposite case to `fixture-slice1-true.md`, which carries real load-bearing claims and
must still write one line for every one of them.

Scope: the wording of this file's own brief. Excluded: every other file.

## Lane and unit
Standard. Implementation mode. Unit 1 — reword one sentence of the brief below.

Named reason for the loop: the fixture must survive as a constructed end state that a
later reader can hold the proportionality rule to, so it is recorded rather than done
and forgotten.

## Brief
Why: the sentence read awkwardly and no reader could act on it with confidence.

Check against the repository: none. This unit rests on no repository claim beyond the
text it is changing, and that text is visible in the change.

Evidence required: the sentence as it read before, the sentence as it reads now, and one
line saying why no automated check distinguishes the two.

Stop if: the change would touch any file outside the scope above.

## Latest result
There was no load-bearing premise to check: this unit's only premise is the sentence it
rewrote, which is visible in the change itself.

Result: the sentence now reads as a single active statement instead of two clauses joined
by a semicolon. Nothing else changed.

Evidence: the old sentence read "the wording was unclear; it should be improved" and the
new one reads "the sentence read awkwardly and no reader could act on it with confidence".
No automated check distinguishes the two — both are grammatical prose in the same file, and
any grep that separated them would be greping for a word this brief already supplied.

## Blocker
None.

## Next action
Codex: assess the reworded sentence and close or continue.
