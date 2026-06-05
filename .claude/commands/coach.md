---
model: opus
---

Run the collaboration coach to analyze operator-AI collaboration patterns across sessions.

## Instructions

0. **Resolve project root.** Run `git rev-parse --show-toplevel 2>/dev/null` to get the absolute project root path. Store as `PROJECT_ROOT`. If the command fails (not a git repo), use `pwd` as the fallback. All subsequent file paths in this command use `{PROJECT_ROOT}/logs/...` — do NOT use bare relative paths (e.g., `/logs/session-notes.md`) which may resolve to the wrong project when invoked during cross-scope runs like `/friday-checkup`.

1. **Check for sufficient data.** Read `{PROJECT_ROOT}/logs/session-notes.md` and count session entries (lines starting with `## 20`). If fewer than 5 entries exist, tell the user:
   > Not enough session data for meaningful coaching analysis. Need at least 5 wrapped sessions. Currently have {N}.
   
   Stop here.

2. **Check for prior coaching runs.** Check if `{PROJECT_ROOT}/logs/coaching-log.md` exists. If it does, note the most recent entry date for progression tracking.

3. **Parse focus area.** If `$ARGUMENTS` is non-empty, pass it as the focus area to the agent (e.g., `/coach decision-making` → focus on decision patterns).

4. **Launch the collaboration-coach agent.** Pass it:
   - `PROJECT_ROOT` — the absolute path resolved in Step 0. The agent MUST anchor all file reads to this path.
   - Focus area (from arguments, or "none — analyze all dimensions equally")
   - Whether coaching-log.md exists (for progression tracking)
   
   The agent reads all log files directly using absolute paths under `PROJECT_ROOT`. Do not load or pass log contents from this session.

5. **Present findings to the operator.** Show the full coaching analysis output from the agent.

6. **Persist results.** Append a compact entry to `{PROJECT_ROOT}/logs/coaching-log.md`:

   ```markdown
   ### {YYYY-MM-DD}
   **Coverage:** {N} sessions ({date range})

   | Dimension | Rating | Trend |
   |-----------|--------|-------|
   | Iteration Efficiency | {rating} | {arrow} |
   | Decision Patterns | {rating} | {arrow} |
   | QC Disposition | {rating} | {arrow} |
   | Delegation Effectiveness | {rating} | {arrow} |
   | Workflow Evolution | {rating} | {arrow} |

   **The One Thing:** {recommendation}
   **Prior recommendation status:** {acted on / not acted on / N/A}
   **Promotion candidates:** {N flagged — see full output} | none this cycle
   ```

   If the file doesn't exist, create it with `# Coaching Log` as the first line before appending.

7. **Archive maintenance.** If `{PROJECT_ROOT}/logs/coaching-log.md` has 15+ entries, archive older entries to `{PROJECT_ROOT}/logs/coaching-log-archive.md` and produce a one-paragraph trend summary at the top of the archive.

$ARGUMENTS