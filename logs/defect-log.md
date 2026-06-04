# Defect Log

Captures repeated weaknesses in Claude's **output quality** — distinct from process friction (`friction-log.md`) and workflow improvements (`improvement-log.md`). Those track *how the work ran*; this tracks *how good the output was*. The point is not to record every mistake; it is to make *repeated defect classes* visible, so the second occurrence of a class triggers a durable fix instead of another one-off correction.

Loop that consumes this log: `../docs/defect-to-fix-loop.md`. Capture is per session (one line when a weak output is corrected); the recurrence scan runs on the Friday cadence (planned — scan/routing wiring deferred to session 2; until then the scan is manual).

Source: AI strategy governing document §5.8 (Defect capture).

## Defect classes

Tag each entry with exactly one class. Six are named in governing-doc §5.8; `shallow-analysis` is an operator addition from the defect-class brief (not in §5.8):

- `missed-contradiction` — failed to surface a conflict between inputs, sources, or claims
- `generic-prose` — vague, templated, or non-specific writing where specificity was needed
- `invented-detail` — asserted a fact, figure, or citation not supported by provided sources
- `weak-prioritisation` — ordered or ranked poorly; buried the load-bearing point
- `poor-sourcing` — citation missing, wrong, or not traceable to a provided source
- `wrong-tone` — register mismatched the audience or document type
- `shallow-analysis` — restated inputs without adding interpretation or depth

<!--
Schema per entry (prepend — most recent at top):

## {YYYY-MM-DD} — {defect-class}

- **Class:** {one of the seven classes above}
- **Where:** {project / artifact / command where the weak output appeared}
- **What:** {one line — the specific weak output, concretely}
- **Occurrence:** 1st | 2nd+ (Nth) — note the prior occurrence's date + location when 2nd+
- **Action:** captured | routed → rule | routed → eval | routed → example
- **Route detail:** {only when Action is routed — what was added and where, e.g. "constraint added to skills/X/SKILL.md"; blank on a 1st-occurrence capture}
- **Status:** open | closed
- **Closed:** {YYYY-MM-DD — present only when Status is closed AND the routed fix is live}

Notes:
- The separator between date and class in the header is U+2014 EM DASH (—), not hyphen-minus or en-dash.
- One class per entry. If an output has two defects, log two entries.
- Recurrence rule: on the **2nd occurrence of a class** (same class — need not be the same artifact), the entry's Action must move from `captured` to a `routed → …` value. A 2nd occurrence still tagged `captured` is the signal the Friday scan flags.
- "Closed" requires the routed fix to be live (rule committed / eval check added / example written), not merely proposed — mirrors the improvement-log `applied + Verified` discipline.
- Route choice (rule vs eval vs example) and the eval-branch landing place are defined in `../docs/defect-to-fix-loop.md`.
-->

Example entry (not a real record — for reference only):

```
## 2026-06-04 — missed-contradiction

- **Class:** missed-contradiction
- **Where:** research-pe-regime-shift / advisory draft v2
- **What:** Two source figures on fund-vintage returns conflicted; draft used one without flagging the gap.
- **Occurrence:** 2nd (1st: 2026-05-20, marketing-positioning brief)
- **Action:** routed → rule
- **Route detail:** Added "surface source-figure conflicts before using either" to docs/analytical-output-principles.md.
- **Status:** open
- **Closed:**
```

---

<!-- entries below, most recent first -->
