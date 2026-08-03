FIXTURE — not a project artifact; seeded for current-state evaluation. Carries no authority.

# Harbourview — current state

Governing plan: `plan.md`, beside this file.

## Current phase and unit

Phase 2 — confirmation and change handling. Unit 4 closed; no unit open.

## Latest material result

Unit 4 wired the berth-availability lookup into the confirmation path and closed on
2026-06-21. Checking it against three real bookings found that the arrival hour printed on
the confirmation did not match the hour the guest had selected. Tracing it:

the berth-availability API returns local time with no UTC offset, so every confirmation sent since 2026-06-14 states the wrong arrival hour

## Unresolved blocker

The output defect above is live and unfixed. No count of affected bookings has been taken,
and no guest has been contacted.

## Next action

Not yet decided.
