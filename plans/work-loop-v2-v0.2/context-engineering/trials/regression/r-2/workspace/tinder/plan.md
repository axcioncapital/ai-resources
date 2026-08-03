FIXTURE — not a project artifact; seeded for planning-record evaluation. Carries no authority.

# Tinder — plan

Approved by Dana Ellery on 2026-05-21, against the three outcomes and the stated premise
below.

Tinder exports the burn-permit register for the county return.

## Premise

The exporter already writes every timestamp as a full ISO-8601 string with an offset, so
Tinder needs no change when the shared format lands. It is the one tool already correct.

## Outcomes

1. The register is exported monthly to `out/tinder-permits.txt`.
2. Rows are ordered by permit issue time.
3. The county's row-count check is reproduced before the file is sent.
