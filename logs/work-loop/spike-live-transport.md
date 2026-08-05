---
task: spike-live-transport
turn: codex
---

## Objective and scope

**This is a Work Loop v2 spike fixture, not a genuine backlog task.** It exists to carry one real
Codex → Claude → Codex sequence through the handoff dispatcher under
`plans/work-loop-v2-v0.2/handoff-automation-spike/`, so that live product transport can be observed
rather than assumed. A later reader should not treat it as evidence of demand for the work below.

The work itself is real and small: write `plans/work-loop-v2-v0.2/handoff-automation-spike/README.md`
so the spike explains itself — what it is, how to run `dispatch.sh` and `dispatch.test.sh`, what the
exit codes mean, and what it deliberately does not prove.

Scope: that one file. Excluded: `dispatch.sh` and `dispatch.test.sh` themselves, anything outside
`plans/work-loop-v2-v0.2/handoff-automation-spike/`, any hook or settings file, the executable core,
the proposal, the investigation report, and any production installation.

## Lane and unit

Standard. Unit 1 — write the spike README.

Named reason for the loop: the unit is being run to prove that two products can carry a turn between
them without operator transport, which requires the sequence itself to be assessed by the other
model rather than accepted from the builder. The state file must therefore survive between two
separate non-interactive processes.

## Latest result

Not started.

## Blocker

None.

## Next action

Codex: write the brief for Unit 1 into this file and set `turn: claude`. Keep it inside the scope
above — this is a spike fixture and must not grow.
