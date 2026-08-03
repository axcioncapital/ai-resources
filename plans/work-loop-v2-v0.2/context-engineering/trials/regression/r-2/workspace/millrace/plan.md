FIXTURE — not a project artifact; seeded for planning-record evaluation. Carries no authority.

# Millrace — plan

Approved: Dana approved this file on 2026-04-02.

Millrace reconciles the weekly meter readings against the billing extract.

## Outcomes

1. Meter readings are pulled from the site controller each Monday.
2. Readings are matched to the billing extract by meter id.
3. Unmatched rows are written to `out/millrace-exceptions.txt`.
4. Every output row opens with the reading timestamp.
