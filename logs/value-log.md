# Value Log

Records the realised value of **accepted builds** — distinct from output quality (`defect-log.md`) and workflow improvements (`improvement-log.md`). Each accepted build (a command, agent, skill, hook, or automation that passed the §5 gate and shipped) gets three lines: what operator-time it was *expected* to save, how much it was *actually* used after a month, and what *closure* it produced. The point is not to track every change; it is to turn the strategy's ordinal D1–D4 scores (§5.3) into measured evidence so the rubric can self-correct.

Loop that consumes this log: the quarterly strategy review (`projects/strategic-os/ai-strategy/`). Capture is per accepted build (one entry at ship time, `Actual usage` left blank); the entry is revisited ~1 month later (the `Review-by` date) to fill `Actual usage`. After a quarter of entries, the gap between `Expected` and `Actual` is the evidence that re-grades the rubric.

Source: AI strategy governing document §5.7 (Measurement requirement).

## What counts as an accepted build

An entry is warranted when a build passes the §5 gate + score and ships — i.e. a new or materially-extended command / agent / skill / hook / automation with a confirmed consumer. Decision-only outcomes (DECIDE, PARK, RETIRE) and pure doc edits do **not** get an entry; they leave their trace in `decisions.md` and the slot records instead.

<!--
Schema per entry (prepend — most recent at top):

## {YYYY-MM-DD} — {build name / candidate code}

- **Build:** {what shipped — name + one line, e.g. "/log-defect command + defect-to-fix-loop"}
- **Expected operator-time saved:** {estimate at ship time — be concrete, e.g. "~10 min per affected session" or "one re-correction avoided per recurrence"}
- **Actual usage (after 1 month):** {filled on the Review-by date — how often it was actually invoked / fired; blank at ship time}
- **Closure produced:** {what it closed, consolidated, or decided — the §5.3 D2 claim, now observed}
- **Review-by:** {ship date + 1 month — when to fill the Actual-usage line}

Notes:
- The separator between date and build in the header is U+2014 EM DASH (—), not hyphen-minus or en-dash.
- One entry per accepted build. A build that ships in phases gets one entry per shipped phase.
- `Actual usage` is the load-bearing field — an empty one a month past its Review-by date is the signal the quarterly review flags (built-but-unused = a candidate to prune, per the closure-over-creation bias).
- Keep it to the three measured lines plus the two anchors (Build, Review-by). No prose write-ups; the detail lives in the slot record or decisions.md.
-->

Example entry (not a real record — for reference only):

```
## 2026-06-04 — /log-defect + defect-to-fix-loop (§5.8 defect capture)

- **Build:** /log-defect command + docs/defect-to-fix-loop.md + /friday-checkup Step 6 recurrence scan.
- **Expected operator-time saved:** one re-correction avoided each time a defect class recurs (the 2nd occurrence routes to a durable fix instead of another manual fix).
- **Actual usage (after 1 month):**
- **Closure produced:** turns a repeated manual correction into a committed rule / eval / example — closure work, not new surface.
- **Review-by: 2026-07-04**
```

---

<!-- entries below, most recent first -->
