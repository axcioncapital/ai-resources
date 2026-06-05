# Materiality Bar

> **When to read this file:** When a review agent generates findings — QC (`qc-reviewer`),
> refinement (`refinement-reviewer`), or friction analysis (`improvement-analyst`). The bar governs
> what becomes a Finding, not whether to review.

A review pass should surface issues that **matter** and stay quiet on the rest. Findings that are
real-but-trivial don't just waste a line — they carry forward as a perceived fix backlog and bury the
issues that actually need attention. The principle: **match the review to the stakes, not to the
apparatus.**

## The test

A finding is **material** only if you can name a concrete consequence of *not* addressing it — to:

- the artifact's **stated purpose** (it won't do its job), or
- a **downstream consumer** (a command, agent, or reader that depends on it breaks or degrades), or
- the **operator's request** (it misses or contradicts what was asked), or
- a **convention with real teeth** (violating it causes a named failure, not just inconsistency).

If the only consequence you can state is "slightly cleaner / nicer / more consistent / I'd have
phrased it differently" — with **no named harm** — the observation is **immaterial**. Apply this test
to *every* finding before it enters the Findings list, not after.

## Mapping to existing tiers (reuse, don't reinvent)

This bar does not mint a new severity system. It maps onto vocabulary already in use:

- **Material** ⊇ `BLOCKING` + `IMPORTANT` (Completion Standard, workspace `CLAUDE.md`). BLOCKING =
  breaks a downstream stage; IMPORTANT = degrades downstream quality. **Both pass the bar.**
- **Immaterial** = `Low-signal` territory (`resolve.md` Real / Low-signal / Skip) that should never
  have become a finding in the first place. The bar moves that judgment *upstream*, to generation,
  so triage/resolve get less noise to sort.
- Echoes `triage-reviewer`'s standing rule: *"If skipping something truly doesn't matter, say so —
  don't inflate importance."* The bar applies that instinct at the point findings are written.

## Disposition of immaterial observations

- **Drop it**, or at most record it as a **single Notes line**.
- Never a numbered **Finding**. Never an entry in a backlog or `improvement-log.md`.
- An immaterial observation never flips a verdict (never `REVISE`, never `REFINE`).

## Worked contrast

| | Observation | Verdict |
|---|---|---|
| **Material** | "Line 42 references `scripts/validate.sh`, which does not exist." | Finding — named consequence: the consumer breaks. |
| **Material** | "The handoff omits the `scope` field the next stage requires." | Finding — BLOCKING: downstream stage fails. |
| **Immaterial** | "This bullet could be tightened by three words." | Drop / Notes — no named harm. |
| **Immaterial** | "I'd order these two sections the other way." | Drop / Notes — preference, nothing breaks. |

## The stakes clause (guardrail against the guardrail)

This bar governs **what counts as a finding**, NOT **whether to review**. It is not a license to skip
QC or thin out coverage.

High-stakes work — client-facing, investment-facing, decision-critical — still gets the **full pass**
and the `FLAG FOR EXTERNAL QC` path. On that work the bar simply doesn't suppress much, because most
findings there *do* have a named consequence. The bar raises the floor on **noise**; it never lowers
the ceiling on **coverage** for work that matters.
