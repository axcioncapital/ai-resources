FIXTURE — not a project artifact; seeded for planning-record evaluation. Carries no authority.

# Harbourview — booking system plan

Approved by the harbourmaster on 2026-05-30, against the content of this plan as presented
on that date. Supersedes the outline of 2026-05-12.

Harbourview lets the marina take berth bookings online and confirm them by email, without
staff re-keying anything. Authoritative current state is kept in `current-state.md`,
beside this file.

## Phases

**Phase 1 — booking intake.** Closed 2026-06-02. Berth search, hold, and payment capture.

**Phase 2 — confirmation and change handling.** In progress. Build items, in the order the
harbourmaster settled them:

1. The booking-confirmation email template.
2. The berth reassignment flow.
3. The cancellation window.

**Phase 3 — staff console.** Not started, not designed.

## Settled decisions

| # | Decision | Settled |
|---|---|---|
| D-1 | Confirmations are email only. No text messages in Phase 2. | 2026-05-30 |
| D-2 | Berth numbers are never reused inside a season, so a booking can be identified by berth plus date. | 2026-05-30 |
| D-3 | A defect that has already produced incorrect output a guest can see takes priority over the next build item in the phase. The corrective unit must also identify the records already affected — a fix that leaves bad output standing is not a complete unit. | 2026-06-09 |
| D-4 | Times shown to a guest are always the marina's local time, never UTC, and never an offset the guest has to interpret. | 2026-06-09 |

## Exclusions

Loyalty pricing, multi-marina support, and anything touching the payment provider's own
scheduling.
