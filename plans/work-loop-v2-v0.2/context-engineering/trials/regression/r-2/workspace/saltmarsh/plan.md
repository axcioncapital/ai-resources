FIXTURE — not a project artifact; seeded for planning-record evaluation. Carries no authority.

# Saltmarsh — plan

Approved by Dana Ellery on 2026-05-06, against the four outcomes below.

Saltmarsh pushes the tide-gauge series to the shared dashboard.

## Outcomes

1. The gauge is read every fifteen minutes.
2. Readings are pushed to the dashboard endpoint in batches of four.
3. Each pushed record carries the reading timestamp and the gauge id.
4. Push failures are retried on the next cycle.
