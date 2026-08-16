---
task: eval-v0-3-partial-fixes
status: closed
turn: operator
---

## Outcome

Accepted. The live Codex Work Loop skill now requires the approved project outcome and the authoritative
current-state position, at source-supported precision, to reach the brief at all four orientation
boundaries — a fresh task, a continuation, a post-compaction reorientation, and a material context change.

The correction is minimal and preserves the existing constraints intact: the one-line operator orientation,
the single preparation pass, the relevance boundary, the nine orientation determinations, the seven
fresh-thread recovery items, and the no-stage / no-artifact prohibitions.

## Decisions that matter

- **No `## Scope of this version` entry is owed, and this is not a deferral.** That section records a
  capability or behaviour family being added. This correction implements already-approved CE-9 meaning
  rather than adding anything, so no dated line belongs there. The item raised at hand-back is closed as
  not-owed, not carried forward.
- **The approved specification was not amended.** CE-9 already required the distinguishing fact to reach
  the brief; the gap was in the live instruction surface, so only that surface changed.
- **The fresh-thread path points at the one rule instead of holding a second copy of it**, and an assertion
  enforces that the carry duty appears exactly once.

## Evidence

Implementation commit `1c89229d`. Changed paths: `.agents/skills/work-loop-v2/SKILL.md` and
`logs/scripts/work-loop-v2-slice-1.test.sh`.

Red/green contract evidence on the live skill, as reported by Claude and accepted by Codex: baseline
`300 passed / 0 failed`; pre-change, with the new assertions in place and the skill untouched,
`302 passed / 6 failed`; post-change `308 passed / 0 failed`. The committed diff contains **eight** new
CE-9 assertions in total — six that fail if the carry duty is absent or weakened, and two that fail if it
grows into a stage or a second artifact. The exact-once assertion is one of those eight.

No CE-9 command, scenario, run sheet, fixture, model turn or paired trial ran, and no existing eval
evidence changed.

## Accepted limitations

This proves the live textual contract and its regression guard. It does **not** prove changed model
behaviour — only a CE-9 paired trial would, and the operator required that CE-9 not be rerun. No harness
result here should be read as behavioural proof.
