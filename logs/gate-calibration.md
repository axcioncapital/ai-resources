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

---

## 2026-05-28 — ai-resources/bright-line-review

- **Scope:** ai-resources
- **Gate:** bright-line-review
- **Trigger:** Durable-enforcement landing of the 2026-05-22 entry below — that entry's Note flagged coaching-note recalibration as insufficient (failed across 3 prior coaching cycles); codification into `skills/ai-resource-builder/references/review-principles.md` ("All Reviews" section) ships the structural fix.
- **Action:** recalibrate
- **Detail:** Skip-detection criterion now formalised: review-class work produced without an explicit bright-line statement in the same turn qualifies as a skip. Bright-line-naming principle codified in `skills/ai-resource-builder/references/review-principles.md` § "All Reviews" — loaded by `qc-reviewer` and any review-class agent that consumes review-principles. Cross-link: fix-plan wave-1 item id-20 (commit lands same session).
- **Review-cycle:** 2026-08-28

---

## 2026-05-22 — ai-resources/bright-line-review

- **Scope:** ai-resources
- **Gate:** bright-line-review
- **Trigger:** ~79–83% confirmed across 4 consecutive `/coach` cycles ending 2026-05-22 (18% changed — 2 of 11 — in the 2026-05-16 window). Surfaced by `/coach` rubber-stamp detection, **not** the friday-checkup `[FADING-GATE]` auto-trigger — note this gate sits below the ≥90% auto-fade threshold this log is nominally calibrated for; it is recorded here because the friday-checkup explicitly directed a calibration decision and an 80% confirm rate over 4 cycles is a legitimate rubber-stamp.
- **Action:** recalibrate
- **Detail:** Gate fires only when a specific bright-line can be named. Before verbalizing a `bright-line-review` pause, name the bright-line in one sentence — a named `/risk-check` change class (`audit-discipline.md`), a permission-surface change, a file deletion, or a `[COST]` threshold. If no specific bright-line can be named, do not verbalize the gate: proceed (commit-discipline already authorizes direct commits). This converts the gate from a per-commit confirmation receipt into a conditional structural check. Evidence: the ~20% of invocations that changed all had a nameable concern (e.g. the `/fewer-permission-prompts` under-delivery catch, the sonnet-tier challenge); the ~80% rubber-stamps were routine commits with none.
- **Review-cycle:** 2026-08-22
- **Note:** durable behavioral enforcement (a rule in an always-loaded `CLAUDE.md`, or the `collaboration-coach` "The One Thing" pattern) is the fix that would actually land — the recalibration has failed to stick across 3 prior coaching cycles as a coaching-note alone. That enforcement is an always-loaded-CLAUDE.md edit (a `/risk-check` change class) and is out of scope for this ungated calibration entry; flagged for a separate gated item.
