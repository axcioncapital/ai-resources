# AI Journal

Log things to fix, implement, or investigate as you work in the repo.
Format is freeform — be as messy as you like. `/friday-journal` will
clarify entries on Friday.

---

<!-- Active entries below this line. Add one per line or short paragraph. -->

## Archive

<!-- Processed entries get appended here by /friday-journal as
     `## Archive — YYYY-MM-DD` blocks. Archive is one-way (active
     section is cleared on operator confirmation); recovery path is
     `git log` / `git checkout` of this file. -->

## Archive — 2026-05-08

Permission prompts — root cause is the deny list in ai-resources/.claude/settings.json (8 entries: Bash rm/sudo/git push + 5 Read denies on archive/deprecated/old paths). Per memory rule "never add to deny list, bypass mode is the floor", this list should not exist. Deny rules override bypassPermissions and trigger prompts on matching paths. Fix: remove the entire "deny": [...] array from ai-resources/.claude/settings.json (lines 10–19). Falls under "Permission changes" in audit-discipline.md § Risk-check change classes — needs /risk-check before applying. Logged 2026-05-08.

Fix /friday-checkup scope behaviour — currently checks only the folder it is run in. Should ask operator (like friday-checkup already does for project tier?) which folders/projects to scan. Also: /friday-so doesn't scan the repo itself, only reads the existing checkup report and synthesizes from it. Depth is bounded by what the checkup captured. Need /friday-so to analyze more than the checkup's surface output.

Is /architecture-review part of the /friday-so cadence routine? Investigate whether architecture-review should be wired into the Friday so/monthly so cadence or remain a separately invoked command.

/session-plan should ask autonomy level. Currently does not. Add autonomy-posture question (e.g., full / approved-only / interactive) as part of the session-plan output.

Reminder to use /implementation-triage on Fridays when doing systems checks. The triage skill is specifically meant for choosing options from a systems point of view. Wire a reminder into /friday-checkup, /friday-so, or /friday-act so this isn't forgotten.

Push permission problem — push was denied twice (both `cd` form and bare `git push`) and Claude couldn't proceed without approval. Either pre-allow push on the next attempt or document that operator pushes manually from terminal. Note: cwd at session start is the project dir, so bare `git push` is the right form.

Model-pin problem — a "model" key in `.claude/settings.local.json` or `.claude/settings.json` pins the session to that model. /model selections are silently overridden on next turn, so switching to Opus appears to "not work." Fix: remove the "model" key from both settings files. To check across projects: `grep -l '"model"' projects/*/.claude/settings*.json`. Open each hit, delete the "model" line. Then /model works freely and `/model default` resolves to account default (Opus 4.7 1M).

Create a "notes cleanup" prompt — takes operator notes, produces a list of things to fix in the right format with potential remedy. Then a "fix observations report" generator that takes the cleaned notes and produces a context document for Friday execution. Then run an automated session that fixes everything from that report. Routine: see Notion "Routine Repo Friday Check" page.

When should /risk-check actually be used? Not on something simple like merging two commands (it writes a full report and is heavyweight). Document the actual use cases for this skill. Make the trigger conditions explicit before invoking.

Create autonomy-fix log command — every time Claude stops mid-workflow and operator doesn't like the stop, invoke a command that logs that event (timestamp, what blocked, was the stop justified). On Friday, review the log and pre-allow those classes of operations so next time Claude runs autonomously past them.

Reminder to log sessions — as part of harness development, logging sessions at the end is important. Operator forgets to do it. Solution: Create a reminder (hook? wrap-session prompt?) to log sessions and mention harness preparation. Question to resolve: which sessions to log and which not?

Fix /session-plan multiple things: (1) skill says "do not invoke /qc-pass automatically" but this is a soft directive — clarify whether soft or hard. (2) Add a reminder to /prime that /session-plan should be invoked after priming, bold and visible. (3) Declare exit condition for /session-plan. (4) Context-engineer the coding-agent session by having it context-engineer its own context for the session.

Create /autonomy command — like /session-plan but invoked mid-session to hand Claude Code autonomy at any point in a session, not just at the start.

Hook to prevent Claude from writing detailed plans inline (cadence plan example). When Claude is about to emit a long plan in chat, hook should stop it and say "make a file out of this." Avoids dumping plans into the conversation transcript.

Hook to prevent executing extensive plans from diagnosing in the same session. Example: CLAUDE.md analysis + fix in one session was too tight. Better to split diagnosis sessions and execution sessions. Hook should detect that pattern and force a session-split prompt.

Improve /audit-claude-md skill — (1) make sure to ask clarifying questions to confirm the info there is up to date. (2) QC the CLAUDE.md output with the systems-owner agent before finalizing.

Implement guardrail to prevent two concurrent sessions working on the same files leading to conflicts. How to detect/avoid concurrent edits across two open Claude Code sessions on the same repo? Investigate.

Default-model 200k drift — some projects (e.g., systems-owner agent) defaulted to Sonnet 200k instead of Sonnet 1M. Root cause: settings.local.json is gitignored and never created on this machine, so no model override is in effect and session falls back to harness default (Sonnet 200k). CLAUDE.md says each operator applies it manually per machine. Need to create the local settings.json on this machine for those projects, or change the harness default, or add a SessionStart hook that warns when no override is present.

Reminder to QC context packs / project plans with GPT — when creating project plans that have to do with AI infrastructure, run them through ChatGPT first as a QC/refinement pass. Have Claude generate the QC prompt automatically. Wire as a step in /create-skill or as a separate command.

Targeted edits vs rewriting entire artifacts — when Claude proposes a plan and operator runs /refinement-pass or /qc-pass on it, Claude often rewrites the entire plan rather than making targeted edits. This is costing lots of tokens. Investigate root cause: is it the resolve/refinement skill instructions, or default Edit-vs-Write behaviour? Add explicit "use targeted edits, not rewrites" guidance.

Create /explain command — explains the next step or what Claude Code has just done in very simple English, clear and short format so operator understands. Different from existing summary skills (more pedagogical, less archival).

Skills mechanics to investigate: (1) Fork parameter — allows Claude Code to run the skill in a "forked separate context window" in a subagent with a different model. Allows for more model control and saves tokens. (2) Arguments parameter — allows passing extra information before calling a specific skill. Investigate use cases for both.

Background-agent pattern — context priming in parallel research. When preparing to add a new feature to an existing session, use a sub-agent in the background to collect context to prime the main agent on how to implement the new feature on top of the current session. Sub-agents can also be asked to search info online. Document this pattern as a usage guide.

Hooks for agentic workflows — investigate use cases for leveraging hooks during agentic workflows. Example: when agent produces a v1 output, hook can automatically spawn /qc-pass and then /refinement-pass like operator would do manually. Investigate other use cases for where hooks could have saved time, improved output, etc.

New commands not always linked to existing projects — example: /resolve and /session-plan commands not automatically visible in obsidian project after being created. Add a step to ai-resources so it automatically adds new commands to current/active projects. Possibly related to /graduate-resource function — investigate gap.

Prevent reading too much context — ran into issue when ingesting KB modules where Claude read all the modules at once (100 pages). Develop a hook that prevents this type of context overloading and suggests session-splitting in the future.

Auto-compact firing prematurely — Claude Code is auto-compacting even though 1M window is not reached. Investigate why and how to disable until window is genuinely close to full. Related: GAP-1 (workspace-root commands outside ai-resources/) — DR-1 says shared resources belong in ai-resources/ but 7 commands exist at workspace root .claude/commands/ that are not in ai-resources/.claude/commands/ (prime, wrap-session, repo-dd, etc). Are these workspace-specific (not candidates for ai-resources/), or shared resources that haven't been graduated yet? If workspace-specific, should DR-1 explicitly note workspace-root command tier as distinct level from ai-resources/ canonical?

Full-autonomy default for all sessions — start giving Claude full autonomy every session. Tell it to run automatic /triage pass after /qc-pass results (automate). Don't ask operator what to implement — automate it. Make this part of every project as a standard feature: "autonomy as standard."

New cadence: daily improvement journal — keep a journal every day on identifying potential areas of improvement, potential waste, redundant operations, etc. Different from /friday-journal (which is weekly). Daily cadence captures friction in flight. Could be a /daily-journal command or a hook that prompts at session-end.

End-of-session unresolved-items check — at session end, before /wrap-session, ask Claude Code if there are any "things that need to be resolved" before session end (unknowns, clarifications, pending decisions). Create a command for this, or add as a sub-step to /wrap-session.

Wrap-session addition: "are there any decisions or actions I need to take before finishing this session?" — useful prompt at end of day. Add to /wrap-session.

Draft/approved artifact drift — develop a hook or detector that reminds of drift between draft/approved status. Example: buy-side service plan situation — original docs need to stay in check (e.g., when updating doc 2 vs 2.1–2.9 docs, the v1/v2 master doc and the working sub-docs drift). Permission prompt log: subagent making tool calls in ai-resources/ from a different project's session triggered Claude Code UI approval dialogs even with bypassPermissions in the project settings — sibling-directory edits surface prompts because each directory has its own settings. Fix: wire ai-resources settings to bypass before running heavy implementation stages from other projects.

## Archive — 2026-05-16

Hook to session start — at session start, capture mandate and wait for operator confirmation. Once confirmed, auto-invoke /session-plan. When /session-plan completes, auto-invoke /qc-pass on the session plan output, then auto-invoke /scope. No operator prompting needed at any step after mandate confirmation.

Add QC pass to research-plan-creator — the command currently has no QC subagent by default. Investigate why and add a QC pass as a standard step.

Audit-repo vs repo-dd — both commands exist; investigate overlap and produce a written recommendation on whether to merge, delete one, or keep both with clearly distinct roles.

Fix repo-dd — add a step that compares CLAUDE.md and file structure between the project being audited and ai-resources. Treat ai-resources as the authoritative, always-most-up-to-date reference.

Fix new-project pipeline — two issues: (1) new commands (e.g., session-start, session-plan) are not appearing in newly created projects; fix the pipeline to include all current canonical commands. (2) New projects don't get a decisions.md by default — add it to the project template.

Strengthen decision-point posture — Claude stops too often at gates asking "what do you recommend" when the operator already trusts its judgment. Update CLAUDE.md (or equivalent) to explicitly allow Claude to make decisions freely at gates, pick a recommendation and proceed, and only surface decisions that are genuinely novel or high-risk. QC passes catch problems; operator will flag exceptions if something looks wrong.

Improve /friday-act — after generating the execution plan, auto-QC it with the systems agent before presenting to operator.

Improve /systems-review — investigate whether the command actually reviews the repo as a whole and surfaces systems-thinking improvement ideas. Clarify its scope and improve if not.

Fix /friday-journal (QC sub-agent pass) — after the initial report is written, run a QC sub-agent pass that highlights vague or unclear content and combines items that should be merged. Approach: either ask the operator clarifying questions or search repo-documentation for answers.

Fix /friday-journal (refinement pass from repo-docs) — run a second refinement pass where Claude adds relevant context from repo-documentation to enrich entries before finalising.

Fix /friday-journal (drop-check) — after QC and refinement, verify that nothing from the original notes was silently dropped. Flag any missing items explicitly.

Fix /friday-journal (risk-check) — run a risk-check on the final report; flag anything that carries implementation risk or shouldn't be there.

Fix /friday-act input scope — the spec's minimum read is insufficient on heavy-disposition Fridays. Missing sources: SO Recommendations + Observations (always past line 30), Systems Review Leverage Points (always past line 30), improvement-log files, and project-internal session-notes/friction-logs. Fix: expand the spec's required reads to include these sources.

Add coaching logs to Friday cadences — check whether coaching logs are already linked to /friday-checkup. If not, wire them in.

Link /resolve-improvement-log to /friday-act — currently not connected. Connect them so /friday-act triggers or references /resolve-improvement-log as part of its execution flow.

## Archive — 2026-05-22

#. Update risk check command
- Make sure risk check command is up to date. Can we link it to system owner agent?

#. "resolve-repo-problem" command
- If claude stumbles upon an repo related error or problem which needs to be resolved, develop a command that can spawn a subagent that investigates the issue, develops a plan and a fix suggestion. The goal is to save me time from having to investigate and come up with a fix.

#. Add reporting steps between complex implementations and plans.
- When developing complex specs, plans etc, have Claude generate executive summaries between steps where it generates reports for you to read that explains what has been done, what will be done between gates so you (the human) you stay in the loop in terms of what the AI is planning to do → so that you have a change to fix if its drifting from what you need.
- Create a command pipeline for this? (reads files → qc's → generates report etc)
- Add this instruction to Claude.md?

#. Drift check command
- When developing complex implementations and projects, develop a drift check command that ensures that the solution has not driften from the original intent.

#. technical spec qc with ai system agent.
- Make sure technical specs are qc'd with SYSTEM OWNER AGENT! Add to command pipeline or instructions, claude should do this automatically so I don't have to remember to do it manually.
