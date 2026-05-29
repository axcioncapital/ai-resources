---
model: sonnet
---

Scan the current project folder for unresolved items and produce a tiered inline backlog report.

## Usage

- `/open-items` — Default mode: full detail for Tier 1 + Tier 2, counts only for Tier 3
- `/open-items full` — Expanded mode: full detail for all tiers

## Purpose

Surface what actually warrants attention. Tier 1 items are explicit asks or unresolved pain. Tier 2 items are awaiting a trigger. Tier 3 is volume awareness only — counts, no detail — so the operator isn't drowned in "dust corners under the sofa."

Scoped to current working directory. No file output.

## Hard exclusions (applied to every source)

Never surface, even in `full` mode:
- Files matching `*archive*.md` (case-insensitive)
- Anything inside `inbox/archive/`
- Items containing `[LOW]`, `someday`, `nice-to-have`, or `deferred indefinitely` (case-insensitive)

## Instructions

### Step 1 — Detect and scan sources

Resolve `cwd`. For each source below, skip silently if the file or directory doesn't exist. If none of `logs/` or `inbox/` exists, print `No backlog sources found in this folder.` and stop.

Use `Read` (and `Grep` where helpful) — do not write or edit any source file.

| Source | Tier | Extract |
|---|---|---|
| `logs/friction-log.md` | T1 | An entry is a top-level `-` bullet under a `### Friction Events` heading; annotations and timestamps inside that bullet's body bind to it. Skip an entry if any of three signals match: (1) explicit `Resolved:` field with non-empty value (not `no`/`pending`); (2) inline `[FADING-GATE] verified` annotation on the entry text; (3) cross-match with an improvement-log entry having `Status: applied` + non-empty `Verified:` AND all four of: (a) the entry body contains the friction entry's `HH:MM` token; (b) the entry body contains the friction entry's `YYYY-MM-DD` date OR the `Verified:` date is within ±1 day of the friction-entry session date; (c) the term `friction-log` (case-insensitive — matches `friction-log`, `Friction-log`, etc.) appears within the same sentence or top-level bullet as the `HH:MM` token in the entry body, with arbitrary intervening words allowed between the term and the timestamp; (d) the improvement-log entry's `### YYYY-MM-DD` header date is on or after the friction entry's `## Session — YYYY-MM-DD` date (date-bounded outer guard against same-`HH:MM`-different-date collisions). Cross-match contract widened 2026-05-29 from strict-adjacency literal patterns to four-condition tolerance match — see improvement-log entry "2026-05-29 — /open-items friction-log cross-match too literal" + audits/working/2026-05-29-resolve-open-items-cross-match-too-literal.md for the miss that motivated the change. |
| `inbox/*.md` (top level only) | T1 | Every file (skip `archive/`). Pull filename + first heading or first non-empty line |
| `logs/next-up.md` | T1 | Every `- [ ]` checkbox line under any heading |
| `logs/improvement-log.md` | T1 (applied-unverified) / T3 (logged/pending) | **T1:** entries with `Status: applied` but no non-empty `Verified:` line. **T3:** entries whose `Status:` matches `logged`, `proposed`, `pending`, or `logged (pending)` |
| `logs/decisions.md` | T2 | Entries containing `Defer` or `Deferred` (case-insensitive) AND having a `Trigger for action:` field. Capture entry date, title, and trigger text |
| `logs/session-notes.md` | T2 (recent) / T3 (stale) | **Open Questions** sections where content is NOT `None`, `None.`, `None blocking`, or `None blocking.` (case-insensitive, trimmed). Recent = entry dated within 14 days of today |
| `logs/session-plan-*.md` (glob) | T1 (recent) / T3 (stale) | `- [ ]` checkbox lines across all marker-scoped session plans. Recent = file modified within 14 days; otherwise stale. Each scanned independently; the attribution line in the output includes the source filename so the operator sees which session's plan a checkbox belongs to. The glob covers both `session-plan-S{N}.md` (canonical) and `session-plan-S{N}-pass2.md` (re-invocation forks); both are first-class sources of unfinished work. See `docs/session-marker.md` for the marker-scoping contract. |

### Step 2 — Apply priority override

Re-scan all collected items (any tier) for these markers (case-insensitive): `[BLOCKING]`, `[HIGH]`, `[CRITICAL]`, `[URGENT]`. Promote any matches to a top "PRIORITY" section. The promoted items still appear in their normal tier section as well (don't lose them).

### Step 3 — Print the report

Always print every heading. For empty sections, print `None.` underneath. Use markdown links `[label](path)` for file references so the operator can click through.

```
## PRIORITY
(only shown if any priority-marked items exist)
- <item text> — <source path>

## Tier 1 — Likely needs action

### Unresolved friction
- <entry title> — [logs/friction-log.md](logs/friction-log.md)

### Active inbox briefs
- <filename>: <first heading> — [inbox/<file>.md](inbox/<file>.md)

### Active next-up queue
- <checkbox text> — [logs/next-up.md](logs/next-up.md)

### Recent marker-scoped session-plan steps
- <checkbox text> — [logs/session-plan-{marker}.md](logs/session-plan-{marker}.md) (across all marker-scoped session plans; see `docs/session-marker.md`)

### Applied improvements awaiting verification
- <entry title> — [logs/improvement-log.md](logs/improvement-log.md)

## Tier 2 — Awaiting trigger / context

### Deferred decisions (trigger-bound)
- <date — title> | Trigger: <trigger text> — [logs/decisions.md](logs/decisions.md)

### Open session questions
- <question text> — [logs/session-notes.md](logs/session-notes.md)

## Tier 3 — Backlog (counts only)
- Improvement-log logged/pending: <N> items
- Stale marker-scoped session-plan checkboxes (>14 days, glob `logs/session-plan-*.md`): <N> items
- Stale open questions (>14 days): <N> items

(Run `/open-items full` to expand Tier 3.)
```

End with one summary line:
`<X> high-signal items + <Y> trigger-bound + <Z> in backlog.`

### Step 4 — `full` mode

If `$ARGUMENTS` contains `full` (case-insensitive), expand Tier 3 to full per-item listings using the same per-item shape as Tier 1/2. Omit the `(Run /open-items full to expand Tier 3.)` hint.

$ARGUMENTS
