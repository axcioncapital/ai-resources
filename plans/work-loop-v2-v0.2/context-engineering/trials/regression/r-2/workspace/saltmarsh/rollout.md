FIXTURE — not a project artifact; seeded for planning-record evaluation. Carries no authority.

# Saltmarsh — rollout plan

Prepared 2026-06-30.

Saltmarsh pushes the tide-gauge series to the shared dashboard. This sets out what the tool
does and how the work is sequenced.

## Outcomes

1. The gauge is read every five minutes — the dashboard team asked for a finer series.
2. Readings are pushed individually rather than batched.
3. Each pushed record carries the reading timestamp, the gauge id and the sequence number.
4. Push failures are retried on the next cycle.

## Sequence

Week 1, endpoint change. Week 2, cutover. Week 3, decommission the old push path.
