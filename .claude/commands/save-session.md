Save mid-session state before `/clear` or `/compact`. The operator's context note (optional) follows: $ARGUMENTS

## Instructions

**Do NOT run git commands or bash commands to discover files.** You already know what was produced from conversation context.

1. Using conversation context and the operator's note (if provided), write a scratchpad file to `logs/scratchpads/{YYYY-MM-DD}-{HH-MM}-scratchpad.md` (project-relative) with this structure:

   ```
   # Session Scratchpad — {date} {time}

   **Saved at:** {ISO 8601 timestamp}

   ## Current Task
   {What we were working on — stage, step, command, specific activity}

   ## Files Produced
   - `path/to/file.md` — description

   ## Files Modified
   - `path/to/file.md` — what changed

   ## Decisions Made
   - **Decision title.** Rationale. (Note if not yet logged to decisions.md)

   ## Partial Work State
   {Draft iteration count, QC status, anything in-flight that isn't in a file yet}

   ## Artifact State
   {Only if actively iterating on a deliverable. Include: artifact path,
   current version, review layers completed + verdicts, open findings
   not yet addressed, and editorial direction from the operator.}

   ## Session Context
   {Key reasoning, rejected approaches, or corrections that would be
   expensive to rediscover. Not a transcript — the non-obvious things
   the next session needs to avoid retreading ground.}

   ## Working Assumptions
   {Things established as true for this work that aren't written in any
   file. Resolved ambiguities, scope boundaries agreed on, hypotheses
   treated as settled. The stuff that prevents the next session from
   reopening closed questions.}

   ## Operator Directives
   {Instructions the operator gave this session that affect how work should continue}

   ## Resume With
   {The specific next action — e.g., "Run /run-cluster for cluster 03"}

   ## Key Files for Context
   {Files specific to the current task that /prime wouldn't load by default — e.g., the draft under revision, the QC report with open findings}
   ```

2. Omit any section that has no content (e.g., no decisions made → skip the section entirely).

3. After writing, confirm the file path and remind the operator:
   - Run `/clear` to start fresh, then `/prime` to resume
   - Or run `/compact` if you prefer lossy summarization over a clean restart
