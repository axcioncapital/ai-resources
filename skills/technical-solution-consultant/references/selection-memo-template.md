# Technical Solution Selection Memo — Template

The fixed structure for the Stage 2–3 output (the recommendation artifact). Compress any section to fit the project, but do not drop a section silently — if a section is empty, state why (e.g., "No options disqualified — all three remain viable at different stages").

This memo is the trust mechanism: it makes the reasoning auditable. The two highest-leverage parts are the **decision matrix** (forces weighted comparison) and the **disqualified options** (explaining what *not* to do is what makes the recommendation credible).

---

## Structure

### 1. Objective
One sentence: what this project must achieve, in business terms. Not the tool, not the feature list — the outcome.

### 2. Decision criteria (weighted)
Define what "best" means *for this project* before showing options. 4–7 criteria, each with a weight (e.g., 1–5 or a %). Typical axes: time-to-first-version, maintenance burden on a non-developer, cost (setup + ongoing), scalability headroom, lock-in risk, data/privacy fit, quality ceiling. Weights are chosen from the intake — make them visible so the operator can challenge them.

### 3. Confirmed facts / Assumptions / Unknowns
Three short lists. Every input from intake lands in exactly one. Assumptions are framed as conditions ("holds if X"). Unknowns that are decision-critical are flagged — they may gate the recommendation.

### 4. Viable solution categories
At three levels — do not collapse them:
- **Solution model** — what *type* of solution (e.g., static site vs. CMS vs. web app).
- **Tool stack** — which tools deliver that model.
- **Implementation path** — how it actually gets built (manual / no-code / AI-assisted / freelancer / custom code).

**Always include a manual / lightweight first version as an explicit category**, compared against every more advanced option. The baseline is mandatory, not a formality.

### 5. Shortlisted options
3–5 concrete options that survive into comparison. Each named, with a one-line description of model + stack + path.

### 6. Decision matrix
Options as rows, weighted criteria as columns. Score each cell, show the weighted total. The matrix is the mechanism that makes trade-offs visible — do not replace it with prose.

### 7. Option-by-option trade-offs
For each shortlisted option: where it wins, where it costs, what it assumes, and the realistic failure mode.

### 8. Disqualified options
Every option considered and rejected, each with a one-line reason from a fixed vocabulary: *too fragile · too costly for this stage · lock-in risk · wrong project stage · maintenance burden too high for a non-developer · overbuilds the requirement · adds more risk than value.* This section is load-bearing — skipping it hides the reasoning.

### 9. Recommendation
The single chosen path. No hedging. (If a decision-critical unknown blocks a firm call, give the best *provisional* recommendation plus the one condition that would change it — see the forced-recommendation rule in SKILL.md.)

### 10. Why it wins
Tie back to the weighted criteria explicitly — "it wins on time-to-first-version (weight 5) and maintenance (weight 4), and loses only on quality ceiling (weight 2)."

### 11. Why it might be wrong (red-team)
Attack the recommendation. Which assumptions, if false, break it? What would a skeptic say? This is mandatory — a recommendation without a red-team is incomplete.

### 12. Runner-up + when it would win
Name the second-best option and the specific condition under which it beats the recommendation (e.g., "if the timeline extends past 3 months, Webflow's quality ceiling starts to pay off").

### 13. MVP vs. later architecture
Separate best-now from best-later: what ships in v1 (and what is deliberately manual in v1), versus what the architecture grows into. Make the manual-in-v1 parts explicit.

### 14. Next-step execution plan
The immediate, concrete next actions — the bridge into Stage 4 (Specification) or directly into a builder prompt if the operator stops here.
