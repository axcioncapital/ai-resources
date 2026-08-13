---
task: fixture-mode-discovery
turn: claude
---

## Objective and scope

Establish whether `fixture-target-3.md` carries a step marker that a later unit could build on.
Scope: reading `logs/work-loop/fixture-target-3.md` and this state file. Excluded: changing the
target, adding a marker, or any other file.

## Lane and unit

Standard. Discovery mode. Unit 1 — establish what the target actually carries today.

Named reason for the loop: the ownership boundary is uncertain — it is not settled whether this
marker is the acceptance harness's to own or the fixture's, and building either way before that is
answered would encode the wrong owner.

## Brief

Why: a later unit wants to extend the target's step markers, and the brief for it cannot be written
until it is known what is there.

Check against the repository: (1) `logs/work-loop/fixture-target-3.md` exists.

Evidence required: what the file carries, with the searched surface and pattern named, such that the
record would read differently had the file said something else.

Stop if: the answer requires changing any file other than this one.

Completion: write the findings into `## Latest result` and hand back for Codex to reframe or stop;
do not implement the eventual target.

## Latest result

(empty — not started)

## Blocker

None.

## Next action

Claude: inspect the named surface and hand back what is there.
