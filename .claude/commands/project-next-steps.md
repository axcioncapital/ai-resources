---
model: opus
description: Plain-language project resume briefing — where the project stands, whether it's ready to continue, and the next steps to take before resuming.
argument-hint: "[project name or path — optional; defaults to current directory]"
---

# /project-next-steps — Resume Briefing

You are coming back to a project you have not touched in a while. This command reads the
project's plan and recent state, then tells you three things in plain language:

1. **Where we are** — what the project is, what is done, and the current position.
2. **Are we ready to continue** — a quick check on the very next planned step.
3. **What to do before resuming** — a short, concrete list of next steps to clear first.

It produces a report you read now (in chat) **and** saves a dated copy in the project's
`logs/` folder. It is read-only: it never changes project files, and it does not do the
work — it only tells you what the work is.

This is different from the neighbours:
- `/session-guide` looks *forward* and renders the plan's upcoming sessions. This command
  looks at *where you are right now* and what is blocking the restart.
- `/prime` orients a single session ("what were we doing last time?"). This command reads
  the whole project plan and maps progress against it.
- `/open-items` lists backlog. This command ties state to the plan and gives a go / no-go.

## Writing style (use it in every part of the report)

- Plain, clear, human-friendly. Short sentences. Common words.
- No unexplained jargon. If a technical or domain term is needed, explain it in one short
  clause the first time it appears.
- Lead each section with the answer, then the supporting detail. The reader should grasp
  "where we are" and "what to do next" in the first few lines, without hunting.

## Step 1 — Pick the project

- If `$ARGUMENTS` names a project, resolve it in this order (so it works from any folder,
  not just the workspace root): (1) treat `$ARGUMENTS` as a path and use it if it exists;
  (2) find the workspace root (the parent that holds a `projects/` directory — walk up from
  the current folder) and try `{workspace-root}/projects/$ARGUMENTS`. If neither resolves,
  say so and stop.
- If `$ARGUMENTS` is empty, use the current working directory's project (its git root).
- State which project was picked in one line before continuing.

## Step 2 — Read the plan and recent state (token-lean cascade)

Read only what you need. Skip any file that does not exist — silently. Use `Read`, `Glob`,
and `Grep`; never write or edit a source file. Reuse the detection approach from the
`session-guide-generator` skill (`skills/session-guide-generator/SKILL.md`, Step 2) rather
than reinventing it. Stop reading for state as soon as you can confidently say where the
project is — do not read everything.

**The plan (the spine — find the first that exists):**
1. `{project}/pipeline/project-plan.md` (canonical).
2. A `plan/` directory at the project root.
3. Phase / workflow definitions in the project `CLAUDE.md`.
4. The latest `logs/session-plan*.md`.

**Current position (authoritative completion signal first, stop when confident):**
1. `{project}/pipeline/pipeline-state.md` — if present, read it; the stage table tells you
   what is done.
2. `{project}/logs/session-notes.md` — read only the **latest** dated entry. `Grep` the
   `^## \d{4}-\d{2}-\d{2}` headers, take the last one, `Read` a bounded slice around it,
   and pull its Summary / Next Steps / Open Questions.
3. Status markers in the plan itself (`- [x]`, `✅`, "complete") as a fallback.

**Supporting context (read lightly, only what bears on the next step):**
- `context/project-brief.md` — the original goal, if you need to restate what the project is.
- `logs/decisions.md` — note any `Deferred:` decisions and the trigger that would unblock them.
- `logs/next-up.md`, `logs/friction-log.md`, `logs/improvement-log.md` — high-signal open
  items only.

**Ground-truth check:** run a recent `git log` and compare what the plan and notes *claim*
is done against what is actually committed. If a "next step" already appears done in the
commits, say so — do not list finished work as pending. (Same cross-check `/prime` uses.)

## Step 3 — Write the report

Build the report with these four parts, in this order.

### A. Where we are
A short, plain narrative:
- What the project is (one or two sentences).
- What was completed last.
- The current position — the phase or step the project is sitting at right now.

Anchor each claim to the file it came from, as a clickable link. Do not guess progress; if
the state is unclear, say what you checked and what you could not confirm.

### B. Are we ready to continue?
A quick check on the **very next** planned step — four points, each one line, marked **OK**
or **GAP**:
- **Inputs in place** — the files, data, or upstream results the next step needs exist and
  are not broken (watch for broken symlinks or a missing context-pack).
- **Decisions settled** — no open decision or `[AMBIGUOUS]` flag is blocking the next step.
- **Plan still current** — the plan still matches reality and has not gone stale against
  recent work.
- **No loose ends** — no unresolved question or backlog item bears on the next step.

This is a quick check on the next step, not a full health audit of the whole project.

### C. Before you resume — next steps
A short, concrete checklist: the things to clear before execution can restart. For each
item, say **what to do** and **why it is blocking** in one line. Order them so the operator
can work top to bottom. An empty list is a good result — say "Nothing blocking — ready to
resume."

### D. Verdict (one line)
One of:
- `GO` — ready to pick up where you left off.
- `BLOCKED — next steps` — clear the Section C list first.
- `BLOCKED — needs a decision` — an open decision must be made before work can continue.

## Step 4 — Save and report back

- Write the full A–D report to `{project}/logs/{YYYY-MM-DD}-project-next-steps.md`. The
  date prefix keeps a history of resume points; if the file for today already exists,
  overwrite it.
- Then echo to chat, short: the one-line "where we are" summary, the verdict, the single
  top next action, and the saved file path as a clickable link. Do not paste the whole
  report into chat — point to the file.

$ARGUMENTS
