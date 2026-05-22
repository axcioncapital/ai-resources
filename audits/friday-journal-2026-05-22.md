---
report_date: 2026-05-22
type: friday-journal
source: ai-resources/logs/ai-journal.md
entry_count: 5
items_generated: 5
---

# /friday-journal report — 2026-05-22

## Summary

Five entries this week, all focused on two themes: (1) closing the human-oversight gap during complex AI-driven work (between-gate summaries, drift check, resolve-repo-problem) and (2) wiring the system-owner agent into two key execution points (/risk-check high-risk verdicts, /new-project architecture gate). The grounding pass used the 2026-05-16 checkup report (6 days old, within the 10-day calibration threshold; no 2026-05-22 checkup has been run yet). The coaching note from that checkup — "bright-line-review gate slipping to rubber-stamp (78% confirm)" — directly supports prioritising the between-gate summary rule. All five items touch risk-check change classes and are flagged accordingly.

## Items

[high] Add between-gate executive summary rule to workspace CLAUDE.md for multi-phase complex work
[high] Wire system-owner QC step into /new-project Stage 3b→3c gate to review architecture before spec-writing begins
[med] Update /risk-check to add system-owner second-opinion step on PROCEED-WITH-CAUTION and RECONSIDER verdicts
[med] Create /drift-check command that compares current session trajectory against session mandate and approved plan
[med] Create /resolve-repo-problem command that spawns a subagent to investigate a repo error and produce a fix plan

## Item context

### Add between-gate executive summary rule to workspace CLAUDE.md for multi-phase complex work
- **Files:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md`
- **Effort:** low
- **Recommended approach:** Add a new rule under the `## Working Principles` section in workspace CLAUDE.md. Rule text (draft): "When work involves two or more approved plan phases (e.g., `/new-project` pipeline, multi-wave `/friday-act`, any session with a phased plan file), generate a brief human-readable gate summary at each phase boundary before starting the next phase. The summary must cover: (1) what was done in this phase (2–4 bullets), (2) what the next phase will do (2–4 bullets), (3) any deviation from the session mandate detected. Output this summary in chat as a visible block — not buried in tool output. Operator has a chance to correct before execution continues." The rule should reference the `[AMBIGUOUS]` guardrail (operator can halt if the next phase looks wrong) and the decision-point posture (Claude still picks and proceeds; the summary is not a blocking approval prompt, just a visibility step).
- **Risk-check required:** Yes (deterministic match: CLAUDE.md, always-loaded). /friday-act must run /risk-check before landing this fix.
- **Source entry:** #. Add reporting steps between complex implementations and plans.\n- When developing complex specs, plans etc, have Claude generate executive summaries between steps where it generates reports for you to read that explains what has been done, what will be done between gates so you (the human) you stay in the loop in terms of what the AI is planning to do → so that you have a change to fix if its drifting from what you need.\n- Create a command pipeline for this? (reads files → qc's → generates report etc)\n- Add this instruction to Claude.md?

### Wire system-owner QC step into /new-project Stage 3b→3c gate to review architecture before spec-writing begins
- **Files:** `ai-resources/.claude/commands/new-project.md`
- **Effort:** medium
- **Recommended approach:** Locate the Stage 3b → Stage 3c transition in `/new-project`. After Stage 3b (architecture design) produces its output artifact and before Stage 3c (line-level implementation spec) is delegated, add a gate step that invokes `/implementation-triage` (the proper entry point for Function D of the system-owner agent) with the Stage 3b architecture document path as input. If verdict is `NOT-WORTH-DOING` or `MARGINAL`, surface the rationale to the operator and pause for direction before proceeding to Stage 3c. If verdict is `WORTH-DOING`, proceed automatically. This is the highest-value insertion point because architecture decisions made in 3b are far cheaper to fix before Stage 3c than after. **Design note:** Journal entry said "technical spec qc" — this item interprets that as gating the *architecture* (3b output) before spec-writing begins, rather than QC'ing the spec after it's written. If the intent is to QC Stage 3c output instead, revise this item before executing.
- **Risk-check required:** Yes (deterministic match: command edit — modifying a canonical pipeline command). /friday-act must run /risk-check before landing this fix.
- **Source entry:** #. technical spec qc with ai system agent.\n- Make sure technical specs are qc'd with SYSTEM OWNER AGENT! Add to command pipeline or instructions, claude should do this automatically so I don't have to remember to do it manually.

### Update /risk-check to add system-owner second-opinion step on PROCEED-WITH-CAUTION and RECONSIDER verdicts
- **Files:** `ai-resources/.claude/commands/risk-check.md`
- **Effort:** medium
- **Recommended approach:** After Step 4 (Structural Validation) and the verdict is determined, add a new Step 4a: if VERDICT is `PROCEED-WITH-CAUTION` or `RECONSIDER`, invoke `/consult` (the proper entry point for Function B of the system-owner agent — pre-change advisory) with the change description and the risk-check report's Dimensions section as context. The system-owner agent adds an architectural-fit and systems-thinking lens on top of the five-dimension risk rating. Append the system-owner commentary as a new `## Architectural Commentary` section in both the report file and the Step 5 chat output. This step is skipped for GO verdicts (low-risk changes don't need architectural review).
- **Risk-check required:** Yes (deterministic match: command edit — modifying a canonical command file). /friday-act must run /risk-check before landing this fix.
- **Source entry:** #. Update risk check command\n- Make sure risk check command is up to date. Can we link it to system owner agent?

### Create /drift-check command that compares current session trajectory against session mandate and approved plan
- **Files:** `ai-resources/.claude/commands/drift-check.md` (new), `ai-resources/inbox/` (brief if via /request-skill pipeline)
- **Effort:** medium
- **Recommended approach:** New command invokable at any point mid-session. Reads: (1) session mandate from `logs/session-plan.md` (the mandated scope and stop-conditions), (2) today's entries in `logs/session-notes.md` and any in-progress plan file. Spawns a lightweight subagent (similar to qc-reviewer pattern) that compares work done + work planned against the original mandate. Returns: `ALIGNED` / `MINOR-DRIFT` / `MAJOR-DRIFT` plus a bulleted list of specific deviations (e.g., "files modified outside stated scope", "stop condition not checked", "mandate goal not addressed"). Does not modify any files — advisory only. Consider using the `/consult` skill internally (Function A) to anchor the judgment in system-building principles. Complements the between-gate summary rule (first item in this report) — that rule provides lightweight automatic phase summaries at gates; this command provides a deeper on-demand comparison at any point mid-session.
- **Risk-check required:** Yes (deterministic match: new command). /friday-act must run /risk-check before landing this fix.
- **Source entry:** #. Drift check command\n- When developing complex implementations and projects, develop a drift check command that ensures that the solution has not driften from the original intent.

### Create /resolve-repo-problem command that spawns a subagent to investigate a repo error and produce a fix plan
- **Files:** `ai-resources/.claude/commands/resolve-repo-problem.md` (new)
- **Effort:** medium
- **Recommended approach:** New command invoked when Claude (or the operator) encounters an unexpected repo error, broken state, or structural inconsistency. Operator passes a brief description of the problem. Command spawns an investigator subagent (uses Read, Glob, Grep) that: (1) locates relevant files, (2) reads CLAUDE.md and recent decisions.md for context, (3) produces a short root-cause diagnosis, (4) writes a 3-option fix plan (quick patch / structural fix / defer) ranked by risk and effort. Returns summary to main session; full notes written to `audits/working/`. Command does NOT apply any fix — it is an advisory/triage command only. The operator then decides which option to action (potentially via /risk-check if the chosen fix touches a gated class). This separates diagnosis work from the main session context.
- **Risk-check required:** Yes (deterministic match: new command). /friday-act must run /risk-check before landing this fix.
- **Source entry:** #. "resolve-repo-problem" command\n- If claude stumbles upon an repo related error or problem which needs to be resolved, develop a command that can spawn a subagent that investigates the issue, develops a plan and a fix suggestion. The goal is to save me time from having to investigate and come up with a fix.
