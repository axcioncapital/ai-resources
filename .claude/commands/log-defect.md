---
model: sonnet
---

Capture one output-quality defect to `ai-resources/logs/defect-log.md`. The operator's defect description follows this prompt: $ARGUMENTS

This is the **capture** step of the defect-to-fix loop (`ai-resources/docs/defect-to-fix-loop.md`). Capture is cheap and per-session: one log line when a weak output was corrected by hand. This command does **not** route or close — routing is gated judgment work that runs on the Friday cadence. It only writes the entry and, on a detected recurrence, loudly tells the operator that routing is now due.

## Step 0: Validate input

`$ARGUMENTS` is the description of the weak output that was just corrected. It may optionally begin with one or both of these prefixes (case-insensitive, space-separated, in any order):

- `class:<defect-class>` — force the defect class (one of the seven below). Skips auto-classification.
- `where:<location>` — the project / artifact / command where the weak output appeared.

If `$ARGUMENTS` (after stripping any prefixes) is empty, print this and stop:

```
/log-defect captures one output-quality defect. Describe the weak output that was corrected.
Example: /log-defect the regime-shift draft restated the source figures without interpreting them
Optional prefixes: class:<class>  where:<project/artifact>
```

## Step 1: Read the log and its schema

Read `ai-resources/logs/defect-log.md`. It carries (a) the seven defect classes, (b) the HTML-commented per-entry schema, and (c) existing entries below the `<!-- entries below, most recent first -->` marker. The seven classes:

- `missed-contradiction` — failed to surface a conflict between inputs, sources, or claims
- `generic-prose` — vague, templated, or non-specific writing where specificity was needed
- `invented-detail` — asserted a fact, figure, or citation not supported by provided sources
- `weak-prioritisation` — ordered or ranked poorly; buried the load-bearing point
- `poor-sourcing` — citation missing, wrong, or not traceable to a provided source
- `wrong-tone` — register mismatched the audience or document type
- `shallow-analysis` — restated inputs without adding interpretation or depth

## Step 2: Resolve the entry fields

- **CLASS** — if the operator gave `class:`, validate it against the seven (abort with the list if invalid) and use it. Otherwise classify the description into **exactly one** class. If genuinely split between two, pick the more load-bearing one and name the alternative in the Step 5 chat notice — do not write two entries for one correction.
- **WHERE** — from `where:` if given, else inferred from the description and the current session (project / artifact / command).
- **WHAT** — one concrete line stating the specific weak output (not a category — the actual thing that was wrong).

## Step 3: Detect recurrence

Count existing entries whose `**Class:**` value equals CLASS (scan the entries below the marker). Let `PRIOR_COUNT` be that count.

- `OCCURRENCE = PRIOR_COUNT + 1`.
- If `PRIOR_COUNT ≥ 1`, capture the **most-recent** prior same-class entry's date and Where for the occurrence reference (e.g. `2nd (1st: 2026-05-20, marketing-positioning brief)`). For the 3rd+ occurrence, reference the immediately-prior one and note the count (`3rd (prior: 2026-06-01, ...)`).

## Step 4: Write the entry

Compose the entry exactly per the schema (header separator is U+2014 EM DASH `—`, not a hyphen):

```
## {YYYY-MM-DD} — {CLASS}

- **Class:** {CLASS}
- **Where:** {WHERE}
- **What:** {WHAT}
- **Occurrence:** {1st | Nth — with the prior reference when ≥2}
- **Action:** captured
- **Route detail:**
- **Status:** open
- **Closed:**
```

`Action` is always `captured` — this command never routes. `Route detail` and `Closed` stay blank.

Insert the block immediately **after** the `<!-- entries below, most recent first -->` marker line (most-recent-at-top), with one blank line separating it from the next entry. Do not append at end of file, and do not touch the schema comment or the class list.

## Step 5: Confirm — and flag recurrence loudly

Print a one-line confirmation: `Captured {CLASS} defect ({OCCURRENCE}) → logs/defect-log.md`.

**If `OCCURRENCE ≥ 2`, additionally emit a loud notice** (this is the signal the whole loop exists for):

```
⚠ Recurrence: this is the {OCCURRENCE} occurrence of `{CLASS}` (prior: {date, where}).
The recurrence rule requires routing this class to a rule / eval / example
(see docs/defect-to-fix-loop.md § The three routes). Routing is gated judgment —
route it now, or it will be flagged at the next /friday-checkup recurrence scan.
The entry is left as `captured` so the Friday scan surfaces it.
```

Do not auto-route and do not change `Action` — routing stays gated per the loop's firing model. Leaving a 2nd-occurrence entry as `captured` is intentional: it is exactly what the Friday scan keys on.

## Notes

- This command only writes `defect-log.md`. It does not commit (commit per the workspace commit rule at session boundaries) and does not edit any skill, agent, or principle file — those are routing actions, gated to the Friday cadence.
- One class per correction. If a single output had two distinct defects, the operator runs `/log-defect` twice.
