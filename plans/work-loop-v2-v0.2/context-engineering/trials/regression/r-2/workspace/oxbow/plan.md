FIXTURE — not a project artifact; seeded for planning-record evaluation. Carries no authority.

# Oxbow — plan

Approved by Dana Ellery on 2026-02-19, against the three outcomes and the output naming
rule set out below as they stood on that date.

Oxbow archives finished run logs to cold storage.

## Outcomes

1. Logs older than 30 days are moved to the archive bucket.
2. Moved logs are verified by checksum before the local copy is deleted.
3. A manifest row is appended for every move.

## Output naming

Manifest rows open with the move timestamp, then the checksum, then the original path.

## Revisions since approval

- 2026-06-11 — reworded outcome 2 from "verified by checksum prior to deletion of the local
  copy" to "verified by checksum before the local copy is deleted", and corrected the
  spelling of "manifest" in the output naming rule. What the plan requires is unchanged.
