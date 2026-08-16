---
name: handoff-thread
description: "Hands the current Codex task off to a new Codex thread with a concise continuation prompt. Use when the user asks to hand work to a new task/thread or continue in a fresh Codex task. Do not use for subagents, forks, or Local/Worktree host handoff."
---

# Handoff Thread

Create exactly one fresh, user-owned Codex task that can continue the current
work by re-reading its authoritative sources, not by trusting conversational
memory.

## Workflow

1. Confirm that the user explicitly asked for a new task or thread. Explicitly
   invoking `$handoff-thread` counts. If they only ask how handoff works,
   explain it without creating anything.

2. Resolve the project and authority:

   - If `list_projects` or `create_thread` is not callable, use tool discovery
     to load it.
   - Call `list_projects` before creating repository work. Match the current
     working directory to a returned saved project; copy its opaque
     `projectId` exactly.
   - **First, check whether an open Work Loop v2 task holds this checkout.** Run
     the read-only preflight; it mutates nothing and needs no git:

     ```bash
     bash "$(git rev-parse --show-toplevel)/logs/scripts/work-loop-session-preflight.sh" --command "handoff-thread"
     ```

     `verdict: STOP` with an `ACTIVE_CLAUDE`, `ACTIVE_CODEX` or `BLOCKED_OPERATOR`
     reason means an open task is bound to **this** checkout. Take the Work Loop
     branch below instead of the Git default. `verdict: PROCEED` means no open
     task owns it — apply the ordinary defaults that follow, unchanged. A
     `verdict: STOP` that reports ownership as unestablished stops the handoff:
     say which check failed and create no task.
   - **Work Loop branch — target the bound checkout as Local.** A Work Loop task
     is bound to one physical checkout: its `.owner` declaration and its state
     file live there, and the task continues there or not at all. A worktree
     would hand the new thread a *different* checkout, where the ownership check
     refuses the task on arrival — so this branch uses **Local**, on the checkout
     already open, and never creates a worktree.

     Its Brief carries **paths, not state**. Field 3 names the exact
     `logs/work-loop/{task-id}.md`, the governing plan or workflow, and the
     executable core. Field 5 is the task record's own `## Next action`,
     identified as such and cited to that file. Field 4 carries only what is
     genuinely unreconstructable from those sources — usually nothing, because
     the task record is the state.

     **Create and copy no second Work Loop record.** Do not write a new task file,
     do not duplicate the existing one into the Brief, do not re-state its
     `## Latest result` as settled fact, and do not claim, clear or edit
     `.owner`. The receiving thread reads the record; the Brief only tells it
     which record to read. A handoff that copies the state has produced the two
     disagreeing records this branch exists to prevent.
   - For a Git project **with no open Work Loop task**, use a worktree with
     `startingState: { type: "working-tree" }`. A handoff means the current
     repository state, including uncommitted work, must travel with the task.
   - For a saved non-Git project, use its local environment.
   - Follow an explicit user request for Local or Worktree instead of applying
     the defaults above.
   - For work with no repository, create a projectless task.
   - If repository work has no unambiguous saved-project match, stop and name
     the missing match. Do not guess a project.
   - Identify the governing project, active workflow and phase, current mode,
     and the authoritative project plan, implementation plan, specifications,
     current-state source, or other original context that controls the work.
     Verify every named path with read-only inspection. Do not infer authority
     from a filename.
   - If no authoritative source can be identified for project work, stop and
     ask for it. A handoff without an authority path merely transfers memory.

3. Write the Brief before creating the task. Keep exactly these five fields;
   group related facts inside them rather than adding fields:

   ```text
   Continue this project in a fresh Codex thread.

   1. Governing project: {project name, saved-project identity, and root}
   2. Workflow position: {active workflow, exact phase, and current mode}
   3. Authoritative context sources: {ordered paths with each source's role}
   4. Settled state: {material decisions, accepted/completed work, blockers,
      and anything the next task cannot reliably reconstruct}
   5. Exact next action: {one concrete action, its completion condition, and
      required verification}

   First verify the working directory. Then read every authoritative context
   source in the listed order, including the original project plan,
   implementation plan, or specifications at hand. Reconstruct the project's
   current position and next step from those sources before changing anything.
   Treat this Brief as navigation, not as a substitute for the sources; it is
   authoritative only for handoff-only context explicitly preserved in field 4.
   If a source is missing or conflicts with the Brief, stop and surface the
   discrepancy. Otherwise preserve accepted work and continue with field 5.
   ```

   Include only facts established in the conversation or repository. Prefer
   file paths over copied file contents. Never include credentials, secrets, or
   guessed state. Use the project's own workflow, phase, and mode vocabulary;
   when no mode exists, record `not defined by the governing workflow`. For
   fields 2–4, cite the source path or section beside every reconstructable
   claim; reserve unsourced text for explicitly labelled handoff-only context.

   Do not create a handoff file, state snapshot, progress log, or diary. Do not
   update repository state merely because a handoff occurred. If a governing
   workflow already owns an event-driven five-field state record, leave its
   shape and update cadence unchanged; the Brief adds no fields to it.

4. Call `create_thread` once with the prompt and resolved target. A short title
   derived from the objective is optional. Omit `model` and `thinking` unless
   the user explicitly requested overrides, so the new task uses their
   configured defaults.

5. Report the result and stop work in the current task:

   - A returned `threadId` means the task is ready. Emit
     `::created-thread{threadId="..."}` on its own line.
   - A returned `clientThreadId` means worktree setup is queued. Emit
     `::created-thread{clientThreadId="..."}` on its own line.
   - Do not wait for or monitor the new task unless the user separately asks.

Completion means one new task was accepted with a five-field Brief that points
it to the original authority, preserves what cannot be reconstructed, and lets
it derive and take the exact next action.

## Known Pitfalls

- `handoff_thread` moves another task between Local, Worktree, or a remote host;
  it does not create the new task requested here.
- `fork_thread` copies completed conversation history. Use it only when the
  user explicitly asks for a fork rather than a fresh handoff.
- A polished summary can still be wrong or stale. The receiving task must
  re-read the original sources before treating the stated position as current.
- The new task does not know the current in-flight turn. Preserve any
  non-reconstructable instruction or work from that turn in field 4 or 5.
- One invocation creates one task. Never create a second task to recover from
  an uncertain first response.

## Failure Behavior

- If project resolution is ambiguous, ask for the intended saved project.
- If `create_thread` fails, report the error and leave the current task intact.
- If the result is unclear, do not retry blindly; state what is known and let
  the user decide whether to try again.

## Runtime Recommendations

- Use the user's configured model and reasoning defaults unless they explicitly
  request overrides.
- Require only the Codex project-listing and task-creation tools. The workflow
  needs no filesystem write, Git mutation, subagent, or external service.

## Examples

- "Hand this task off to a new Codex thread" → create one fresh task with the
  five-field Brief; the receiving task reads the named original sources before
  continuing.
- "Fork this conversation so both tasks can continue" → do not use this
  workflow; use a thread fork because the user explicitly requested history.
