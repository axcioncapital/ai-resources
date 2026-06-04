# Defect-to-Fix Loop

The process that converts a *repeated* output-quality defect into a durable system improvement — so the operator's judgment becomes reusable system memory instead of being re-applied by hand every time the same weakness recurs.

Source: AI strategy governing document §5.8 (Defect capture). Paired log: `../logs/defect-log.md`.

**Binding principle — closure-before-detection.** A defect that is captured but never closed is new surface, not improvement; it amplifies the system's stated binding constraint (detection has outrun closure). The log exists *only* to feed this loop. Do not run capture without a working closure path.

## The loop

1. **Capture (per session).** When a weak output is corrected by hand, add one line to `defect-log.md`, tagged by defect class. First occurrence: `Action: captured`. No routing decision yet — capture is cheap.
2. **Detect recurrence (Friday cadence).** A scan over the log flags any class that has appeared a **second time** while still tagged `captured`. (Scan wiring is deferred — see below; until then the scan is run by hand during the Friday cadence.)
3. **Route the second occurrence to a fix.** Pick exactly one of the three routes below and record it in the entry's `Action` + `Route detail`. From this point the defect is closure work, not new surface.
4. **Close.** When the routed fix is live, set `Status: closed` + `Closed: {date}`.

## The three routes

Choose by *what the system is missing*, not by convenience:

- **Rule** — when the system needs a **clearer constraint**. The desired behaviour can be stated as a short instruction. Lands in the relevant skill's `SKILL.md`, a `docs/` principle file (e.g. `analytical-output-principles.md`), or an always-loaded `CLAUDE.md` rule. *(An always-loaded `CLAUDE.md` rule is a `/risk-check` change class — gate it.)*
- **Eval case** — when the defect **must be tested and prevented from silently returning**. A constraint alone won't catch regression; you need a check that re-fires on future work. (Landing place below.)
- **Example** — when the system needs a **better model of the desired output**. The fix is a concrete sample, not a rule. Lands in `style-references/` or a skill's examples.

### Where an eval case lands (route-by-locality)

This workspace has no automated output-quality test harness yet, so "eval" maps to the nearest re-firing check, chosen by where the defect lives:

- **Cross-cutting class** (e.g. `generic-prose`, `missed-contradiction`, `wrong-tone` — defects that recur across many artifacts) → add a re-firing check to the `qc-reviewer` agent or its `skills/ai-resource-builder/references/review-principles.md`. Precedent: the gate-calibration bright-line fix codified into `review-principles.md`.
- **Skill-local class** (a defect specific to one skill's output) → add a check to that skill's own quality-check section (Step 6 "Quality Check" in `skills/ai-resource-builder/SKILL.md`).

Eval cases created here should **feed** the planned slot-5 eval substrate (governing-doc roadmap), not fork a parallel one. Until that substrate exists, an eval-routed defect is a re-firing QC check; when the substrate lands, these checks become its seed cases.

## Firing model

- **Capture:** per session, one log line, by hand at correction time.
- **Recurrence scan + routing:** fortnightly, on the Friday maintenance cadence, as a gated step. Exact precedent: the gate-calibration suppression check that fires monthly+ inside `/friday-checkup`. Routing is judgment work — it stays gated, not hooked.

## Acceptance test

The arc is not done when the log exists. It is done when the **first defect class is actually closed** into a rule, eval, or example. A log that captures but never closes is precisely the failure mode this loop exists to prevent — treat first-close as the proof the loop works.

## Deferred wiring (session 2, risk-checked)

This document and `defect-log.md` are scaffolding — the detection-and-closure *design*. The following are deferred to a risk-checked session, because each is a structurally gated change class:

- A `/log-defect` capture command (new command).
- A `/wrap-session` or `/friday-checkup` step that runs the recurrence scan and surfaces 2nd-occurrence classes (cadence-pipeline edit).
- The concrete routing of the first real recurring defect class into a rule / eval / example (proves the loop end-to-end and satisfies the acceptance test above).
