---
model: sonnet
---

Manually invoke the context engine: discover and assemble a cited context pack for a stated repo-modification task. Task description follows this prompt: $ARGUMENTS

## Why a subagent?

The discovery work — classifying the task, reading the project's CLAUDE.md as a routing map, inspecting candidate files, ranking by authority tier, surfacing conflicts and missing context — is the `context-discovery` agent's job. This command is a thin dispatcher: it captures the task description, resolves the project context, and invokes the agent. The agent writes the pack; this command returns the path.

## When to use

- **Pre-task exploration** — before committing to a task, see what context the engine would assemble.
- **Mid-session pivot** — switching to a sub-task; refresh context for the narrower scope without writing a new mandate.
- **Phase 1 evaluation** — testing the engine on real tasks against Brief 1's evaluation rubric (right files / no missing dep / no stale content / handoff improves execution / reduces operator effort / safe to act from pack alone).

This command does NOT write a mandate, does NOT chain into `/session-plan`, and does NOT begin any session-init flow. For session-init context, the engine auto-fires inside `/session-start` Step 2.4 and `/prime` Step 8c.4.5.

## Steps

1. **Identify the task.** Read `$ARGUMENTS` as `TASK_DESCRIPTION`. If `$ARGUMENTS` is empty, ask one prompt and wait for one answer:

   > State the task. Example: `improve the Friday checkup workflow`, `fix the wrong-host-command bug in /session-start`, or `refactor the ai-engineer agent in ai-development-lab`.

   Pass the answer verbatim as `TASK_DESCRIPTION`. Do not paraphrase or split.

2. **Resolve the project context.** Compute `CWD_PROJECT` from the current working directory:

   ```bash
   CWD_PROJECT=$(git rev-parse --show-toplevel 2>/dev/null)
   ```

   If the command fails (not a git repo), emit one line: `Not inside a git repository — the engine needs a project root to use CLAUDE.md as a routing map. Cd into a project or the workspace root and try again.` Then stop.

   If `CWD_PROJECT` resolves but no `CLAUDE.md` exists at that path, emit one line: `No CLAUDE.md at {CWD_PROJECT} — the engine has no routing map to work from. Either create a CLAUDE.md or invoke from a project with one.` Then stop.

3. **Launch the `context-discovery` subagent.** Pass exactly three fields:

   - `TASK_DESCRIPTION` (verbatim from Step 1)
   - `CWD_PROJECT` (from Step 2)
   - `INVOCATION_MODE: manual`

   Do NOT pass conversation history, your reasoning, or session context. The agent works from these three fields and its own bounded Read budget per `ai-resources/.claude/agents/context-discovery.md`.

4. **Present the agent's return summary verbatim.** The agent returns a ≤30-line summary with `**Pack:** {pack_path}` on the first line and the pack's mandate fields, readiness booleans, and surfaced conflicts / missing context listed below. Show the summary as-returned — do not paraphrase, summarize, or filter.

   Append one operator hint line at the end:

   > Pack at: `{pack_path}`. To use it as session input, run `/session-start <task>` from this project — engine auto-loads if cwd has a CLAUDE.md.

5. **Wait.** Do not chain into `/session-start`, `/session-plan`, or any other command. Do not begin implementation. The operator decides whether to use the pack, run `/session-start` with the task, refine the description and re-invoke, or ignore the pack.

## Notes

- The pack lands at `{CWD_PROJECT}/output/context-packs/{slug}/pack.md`. Persistence depends on whether the project tracks `output/` in git (heterogeneous across projects per Pre-flight B in the Context Engine plan).
- Re-invoking on the same task description produces a new pack with a new slug. Old packs persist as historical artifacts when `output/` is git-tracked.
- The schema is canonical at `ai-resources/docs/context-pack-schema.md`. Field semantics and authority-tier hierarchy live there.
