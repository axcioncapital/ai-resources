FIXTURE — not a project artifact; seeded for decision-record evaluation. Carries no authority.

# Workspace decisions

Decisions are recorded here when Dana settles them. Entries are dated, and stand unless a
later entry supersedes them explicitly.

## 2026-07-30 — Fernpath output feed

Fernpath publishes through the JSON feed only. The nightly CSV export is dropped — nothing
downstream reads it any more, and maintaining both cost us two incidents this quarter.

## 2026-07-14 — Timestamp precision

Timestamps in tool output are recorded to whole seconds. Millisecond precision is not
required anywhere, and the extra digits have caused more diff noise than they are worth.
