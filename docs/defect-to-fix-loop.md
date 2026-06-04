# Defect-to-Fix Loop

The process that converts a *repeated* output-quality defect into a durable system improvement — so the operator's judgment becomes reusable system memory instead of being re-applied by hand every time the same weakness recurs.

Source: AI strategy governing document §5.8 (Defect capture). Paired log: `../logs/defect-log.md`.

**Binding principle — closure-before-detection.** A defect that is captured but never closed is new surface, not improvement; it amplifies the system's stated binding constraint (detection has outrun closure). The log exists *only* to feed this loop. Do not run capture without a working closure path.

## The loop

1. **Capture (per session).** When a weak output is corrected by hand, run `/log-defect` (or add one line to `defect-log.md` directly), tagged by defect class. First occurrence: `Action: captured`. No routing decision yet — capture is cheap. `/log-defect` also detects and loudly flags a recurrence at capture time.
2. **Detect recurrence (Friday cadence).** The `/friday-checkup` Step 6 **Defect-log recurrence scan** (all tiers) flags any class with **2 or more** un-routed (`captured`) entries. It emits a `[DEFECT-RECURRENCE]` follow-up line per flagged class for `/friday-act` to route.
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

- **Capture:** per session, one log line, at correction time — via `/log-defect` (or by hand). The command captures the entry and, on a 2nd+ occurrence, loudly flags that routing is now due.
- **Recurrence scan:** wired into `/friday-checkup` Step 6 (Tactical follow-ups) on **every tier** — a cheap single-file grep, so weekly coverage satisfies the original fortnightly-or-better intent rather than gating to monthly+. It surfaces `[DEFECT-RECURRENCE]` lines; it does not route.
- **Routing:** judgment work, performed at `/friday-act` from the surfaced recurrence lines. It stays gated, not hooked. (Structural precedent for the cadence-step shape: the gate-calibration suppression check inside `/friday-checkup`.)

## Acceptance test

The arc is not done when the log exists. It is done when the **first defect class is actually closed** into a rule, eval, or example. A log that captures but never closes is precisely the failure mode this loop exists to prevent — treat first-close as the proof the loop works.

## Wiring status

Session 1 (2026-06-04) built this document and `defect-log.md` — the detection-and-closure *design*. Session 2 (2026-06-04, S8, risk-checked GO) wired the capture and detection paths:

- ✅ **`/log-defect` capture command** — `ai-resources/.claude/commands/log-defect.md` (shipped S8). Captures one entry, classifies, detects recurrence at capture time.
- ✅ **Recurrence-scan step** — `/friday-checkup` Step 6 Defect-log recurrence scan, all tiers (shipped S8). Surfaces `[DEFECT-RECURRENCE]` follow-up lines.
- ⏳ **First real close (the acceptance test)** — still deferred: route the first real recurring defect class into a rule / eval / example, proving the loop end-to-end. Awaits a real recurring defect (no backfill). Routing happens at `/friday-act` from a surfaced `[DEFECT-RECURRENCE]` line.
