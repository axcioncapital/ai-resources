# /reconcile Verdict Definitions

> **When to read this file:** Loaded by `reconcile-reviewer` (and by `/reconcile` when presenting a result) when producing the final verdict on a reconciliation report. Not needed for every turn.

`/reconcile` judges whether a project output fulfilled its mandate — not whether the output reads well. Seven verdicts, chosen by where the failure (if any) actually lives, not by how bad the prose feels.

| Verdict | Meaning | Fires when |
|---|---|---|
| **Pass** | Output meets the project's mandate rubric and the workflow that produced it used the resources it should have. | No dimension in `reconcile-failure-taxonomy.md` scores below "meets bar." |
| **Conditional Pass** | Output is usable as-is but has named, specific weaknesses. | One or two rubric dimensions score "partial" with a concrete, statable gap — not vague dissatisfaction. |
| **Fail** | Output does not meet the mandate rubric on a load-bearing dimension. | A rubric dimension the project marked required (see `mandate-rubric.md` § Required dimensions) scores below bar, and the gap is in the *output itself* — the workflow ran correctly but produced weak content. |
| **Misfire** | The output solves a different problem than the one the mandate implies. | The output answers a real question — just not the one the task or mandate posed. Distinguish from Fail: a Fail is a weak answer to the right question; a Misfire is a good answer to the wrong one. |
| **Workflow Fault** | The final output may be partly usable, but the *process* that produced it skipped a step the project's resource-activation map calls for. | The resource-activation audit (see `reconcile-reviewer.md`) finds a should-have-been-consulted resource with no evidence of use, and that omission plausibly explains the output gap. |
| **Mandate Fault** | The project's own mandate rubric is too vague, internally contradictory, or missing the dimension needed to judge this output. | `/reconcile` cannot score a dimension because `mandate-rubric.md` doesn't define what "good" means for it, or two rubric lines conflict. |
| **Rerun Required** | The output should be regenerated under a corrected workflow — the diagnosis points at a fixable process gap, not a fixable sentence. | Combination verdict: pair with Workflow Fault or Mandate Fault when the fix is upstream of the artifact, not a local edit. |

## Selection order

Work top-to-bottom; stop at the first that fires. This keeps the verdict pointing at the *earliest* real cause rather than the most visible symptom.

1. **Mandate Fault** — can the rubric even judge this? If not, nothing below is reliable. Diagnose the rubric before the output.
2. **Misfire** — did the output answer the right question at all? A well-executed answer to the wrong question is not a Fail.
3. **Workflow Fault** — does the resource-activation audit explain the gap? If a required resource was skipped and that plausibly caused the weakness, the fault is upstream of the artifact.
4. **Fail / Conditional Pass / Pass** — score the rubric dimensions directly once 1–3 are ruled out.
5. **Rerun Required** — append when the diagnosis (2 or 3) implies the existing artifact can't be locally patched into shape; a corrected process must produce a new one.

## Scoring the bar

`mandate-rubric.md` dimensions score Weak / Partial / Moderate / Strong. Relative to the verdict logic above: **Moderate and Strong both meet the bar** — Moderate is not a partial credit tier, it is "solidly adequate, not exceptional." **Partial** is the Conditional-Pass trigger (a named, specific gap). **Weak** is the Fail trigger (falls below the bar entirely). A dimension sitting exactly between Partial and Moderate should be resolved by asking: is the gap specific and nameable (→ Partial), or is there no clear gap to name even though the dimension isn't outstanding (→ Moderate)?

## Do not conflate

- **Fail ≠ Misfire.** A Fail took the right shot and missed; a Misfire aimed at the wrong target.
- **Workflow Fault ≠ Fail.** A Workflow Fault names a process gap (a resource that should have been read); a Fail names a content gap in an output produced by an otherwise-sound process. When both are true, lead with Workflow Fault — it's the earlier cause.
- **Mandate Fault is not an escape hatch.** Only fires when the rubric genuinely cannot judge the dimension — not when the rubric is inconvenient or the output merely underperforms a clear bar.
