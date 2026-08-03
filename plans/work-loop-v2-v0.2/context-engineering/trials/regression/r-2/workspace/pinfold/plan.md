FIXTURE — not a project artifact; seeded for planning-record evaluation. Carries no authority.

# Pinfold — plan

Approved by Dana Ellery on 2026-02-19, against the three outcomes and the acceptance
condition set out below as they stood on that date.

Pinfold summarises the daily sensor rollup for the morning report.

## Outcomes

1. The rollup runs at 05:00 and covers the previous calendar day, and the trailing seven
   days as well.
2. Missing hours are reported rather than interpolated.
3. The summary is written to `out/pinfold-daily.md`.

## Acceptance

The morning report is accepted when the summary is present by 07:00 and every timestamp in
it carries an explicit UTC offset.

## Revisions since approval

- 2026-06-11 — extended outcome 1 from the previous calendar day to the previous day plus
  the trailing seven days, and moved the acceptance deadline from 05:30 to 07:00 so the
  wider window has time to finish.
