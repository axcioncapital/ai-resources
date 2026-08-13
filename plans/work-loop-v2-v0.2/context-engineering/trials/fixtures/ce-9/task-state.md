FIXTURE — not a project artifact; seeded for CE-9. Carries no authority.

# Harbourview — current state

*Fictional project, seeded for a trial. This file carries **no authority over any real Axcíon work**, and
it is not a live Work Loop state file — nothing in it describes, governs or constrains anything outside
the CE-9 scenario, and no reader should act on it in the repository.*

**Inside the CE-9 scenario, this file is Harbourview's authoritative current state: its phase, latest
material result and blocker are authoritative for that fictional project, and a thread preparing a brief
for it should treat them as such.**

The two statements hold together because they operate at different levels. The authority is
trial-internal and stops at the boundary of this fixture set. A blanket denial would be the wrong shape
here: the scenario measures whether a thread recovers the blocker below and reads it against the
governing plan, which it cannot do if the file has told it the blocker is not authoritative for
anything.

This is the durable source that plays spec §5.7 category 3 — *the existing authoritative current-state
interface* — in the CE-9 recovery scenario. The `FIXTURE —` notice occupies the first line deliberately,
so this file cannot parse as YAML frontmatter and therefore cannot be mistaken by any tool for a real
Work Loop state file. It also sits outside `logs/work-loop/`, which is the only directory the live
command resolves task ids from.

**Governing plan:** `project-plan.md`, beside this file.

## Current phase and unit

Phase 2 — confirmation and change handling. Unit 4 closed; no unit open.

## Latest material result

Unit 4 wired the berth-availability lookup into the confirmation path and closed on 2026-06-21.
Verification against three real bookings found that the arrival hour printed on the confirmation did not
match the hour the guest selected. Tracing it:

the berth-availability API returns local time with no UTC offset, so every confirmation sent since 2026-06-14 states the wrong arrival hour

The sentence above is kept on one unbroken line on purpose. It is the scenario's discriminator, and the
absence check that keeps this instrument honest is line-based — a wrapped sentence would make the
presence grep miss it and the whole measurement silently vacuous.

## Unresolved blocker

The output defect above is live and unfixed. No count of affected bookings has been taken, and no guest
has been contacted.

## Next action

Not yet decided. Recorded here as undecided on purpose: what comes next follows from the blocker above
read against the governing plan, and no one has written that conclusion down.
