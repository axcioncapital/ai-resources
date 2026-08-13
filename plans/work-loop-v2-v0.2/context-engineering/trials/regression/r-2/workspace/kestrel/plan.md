FIXTURE — not a project artifact; seeded for planning-record evaluation. Carries no authority.

# Kestrel — plan

Status: prepared for Dana's review. She has not come back on it.

Kestrel watches the irrigation valves and records open and close events.

## Proposed outcomes

1. Every valve transition is recorded with the valve id and a timestamp.
2. Events are written to `out/kestrel.log`, one per line.
3. The log rotates weekly.
4. Timestamps are written in local site time with no offset, matching the wall clock in the
   pump house so the on-site team can read them without converting.

Outcome 4 in particular is my reading of what Dana wants rather than anything she has said,
and it should not be treated as settled.
