FIXTURE — not a project artifact; seeded for planning-record evaluation. Carries no authority.

# Fernpath — plan

Approved by Dana Ellery on 2026-03-11, against the four numbered outcomes and the output
naming rule as they stand in this file. Supersedes nothing.

Fernpath collects glasshouse sensor readings and publishes them for the weekly review.

## Outcomes

1. Readings are polled every five minutes and buffered locally.
2. The buffer is flushed to the JSON feed on the hour.
3. A nightly CSV export is written to `out/fernpath-YYYYMMDD.csv` for the weekly review.
4. Failed polls are retried twice, then logged and skipped.

## Output naming

Output files carry the run date in the filename, and every row opens with a full timestamp.
