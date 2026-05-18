# Gate Calibration Log

Records calibration decisions for workflow gates that have faded (≥90% confirm-rate over 30 days).
Detection fires monthly+ in `/friday-checkup`. Record decisions here during that session or the following `/friday-act`.

<!--
Schema per entry (prepend — most recent at top):

## {YYYY-MM-DD} — {scope_slug}/{gate_name}

- **Scope:** {scope_slug}
- **Gate:** {gate_name}
- **Trigger:** {confirmed}/{total} confirmed ({pct}%) over 30 days ending {date}
- **Action:** retire | lower-frequency | recalibrate
- **Detail:** {one-line description of the change made or deferred}
- **Review-cycle:** {YYYY-MM-DD} or permanent

Notes:
- The separator between date and scope/gate in the header is U+2014 EM DASH (—), not hyphen-minus or en-dash.
  Hand-edited entries using the wrong character will silently fail suppression matching.
- Review-cycle: permanent = never re-flag. YYYY-MM-DD = re-surface after that date.
- Action vocab must match exactly: retire | lower-frequency | recalibrate
-->

Example entry (not a real record — for reference only):

```
## 2026-05-18 — global-macro/content-review

- **Scope:** global-macro
- **Gate:** content-review
- **Trigger:** 28/30 confirmed (93%) over 30 days ending 2026-05-18
- **Action:** lower-frequency
- **Detail:** Gate now fires only when new sources are cited; skip for routine batch confirmations
- **Review-cycle:** 2026-08-18
```
