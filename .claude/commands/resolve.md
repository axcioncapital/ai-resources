---
model: opus
---

After a `/qc-pass`, run this command to get an importance verdict and concrete fix recommendation for each finding — so you only need to approve or reject, not diagnose.

## Steps

1. **Find the QC review.** Scan recent conversation context for a `## QC Review` block containing a `### Findings` section. If none found → tell the operator: *"No recent QC review in context. Run `/qc-pass` first, then `/resolve`."* Stop. Note: QC findings dropped from context after `/clear` or `/compact` are correctly caught by this gate — the operator re-runs `/qc-pass` on the artifact.

2. **Extract from the QC block:**
   - The full `### Findings` section (verbatim)
   - The `**Artifact:**` line from the QC header
   - The `**Scope:**` line from the QC header

3. **Translate findings into `triage-reviewer` input format.** Extraction is format-agnostic — condense each finding to one line regardless of format (full-rubric numbered dimensions or mechanical-mode M1/M2/M3 bullets):
   - Each finding → numbered item: `"Fix: {condensed finding description}"`
   - Findings under `### Findings` → tag `[In-scope]`
   - Findings under `### Notes` (out-of-scope observations) → tag `[Out-of-scope]`
   - Context line: `"QC findings on: {artifact description} — {scope line}"`

4. **Launch the `triage-reviewer` subagent** with the translated list and context line. Do not pass conversation history.

5. **Map triage output back to importance labels:**
   - **Do** → `Real`
   - **Park** → `Low-signal`
   - **Parked by scope** → `Skip (out-of-scope)`

6. **Draft a specific, concrete recommended fix for each `Real` item** (main session — not a subagent). The fix must be specific enough to execute without further judgment. If a fix cannot be made concrete, mark it `Needs operator judgment: {what to decide}`.

7. **Present the combined table:**

   | # | Finding (condensed) | Importance | Recommended Fix |
   |---|---|---|---|
   | 1 | {finding} | Real / Low-signal / Skip | {action or N/A} |

8. **If all items are Low-signal or Skip:** announce "All findings are low-signal — nothing to fix." Done.

9. **If any items need operator judgment:** surface those rows first and wait for guidance before proceeding. Operator may invoke `/decide` to evidence-ground those rows against project files before answering.

10. **If any Real items with concrete fixes:** wait for operator approval row-by-row (or blanket approval). Before executing fixes, set: `touch /tmp/claude-resolve-executing-$PPID` — this tells the auto-QC nudge hook to suppress re-nudging during fix execution. Execute each approved fix. After all fixes complete (or if interrupted), remove the marker: `rm -f /tmp/claude-resolve-executing-$PPID`. Report completion per fix.
