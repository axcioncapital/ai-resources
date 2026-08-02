FIXTURE — not a project artifact; seeded for CE-9. Carries no authority.

# Harbourview — booking system plan

*Fictional project. Nothing in this file describes Axcíon work, and no statement in it governs anything.*

**Stage:** approved plan of record · **Approved by:** the operator, 2026-05-30 · **Approval binds to:**
the content of this plan as presented on 2026-05-30 (fixture-internal identity; no Git binding is claimed
for seeded material) · **Supersedes:** the 2026-05-12 outline · **Authoritative current state is
maintained in:** `task-state.md`, beside this file.

This is the durable source that plays spec §5.7 category 2 — *one canonical project plan* — in the CE-9
recovery scenario.

---

## Objective

Harbourview lets a marina take berth bookings online and confirm them by email, without staff re-keying
anything.

## Phases

**Phase 1 — booking intake.** Closed 2026-06-02. Berth search, hold, and payment capture.

**Phase 2 — confirmation and change handling.** In progress. Build items, in the order the operator
settled them:

1. The booking-confirmation email template.
2. The berth reassignment flow.
3. The cancellation window.

**Phase 3 — staff console.** Not started, not designed.

## Settled decisions

| # | Decision | Settled |
|---|---|---|
| SD-1 | Confirmations are email only. No SMS in Phase 2. | 2026-05-30 |
| SD-2 | Berth numbers are never reused inside a season, so a booking can be identified by berth plus date. | 2026-05-30 |
| SD-3 | **A defect that has already produced incorrect operator-visible output takes priority over the next build item in the phase.** The corrective unit must also identify the records already affected — a fix that leaves bad output standing is not a complete unit. | 2026-06-09 |
| SD-4 | Times shown to a guest are always the marina's local time, never UTC, and never an offset the guest has to interpret. | 2026-06-09 |

## Exclusions

Loyalty pricing, multi-marina support, and anything touching the payment provider's own scheduling.
