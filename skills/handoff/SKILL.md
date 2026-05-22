---
name: handoff
description: >
  Unified session handoff. No args (continuity mode): saves full session state
  to logs/scratchpads/ for same-session resume after /clear — use before
  /clear or /compact. With args (fork mode): compresses a scoped task to /tmp/
  for a child session to pick up while the parent continues. Triggers: /handoff,
  "save session", "hand this off", "fork this task", [SCOPE] flag resolution.
  Do NOT trigger on unrelated mentions of "hand off" in prose. Do NOT trigger
  for an end-of-session wrap — /wrap-session runs continuity mode itself as
  its Step 0.5.
model: sonnet
effort: medium
disable-model-invocation: true
---

# handoff

Unified session-state skill. Operates in two modes based on whether the
operator provides a purpose argument.

## Purpose

**Continuity mode (no args):** Captures the current session's full state so
a clean session can resume the exact same work after `/clear` or `/compact`.
Replaces `/save-session`. Output lives in `logs/scratchpads/` (persistent,
project-relative) so it survives reboots and is readable by `/prime`, which
detects the newest scratchpad at session start and offers it as a resume
point. `/wrap-session` runs this mode as its Step 0.5, so every planned wrap
leaves a scratchpad behind automatically.

**Fork mode (with args):** Compresses a specific task slice into a file a
separate child session can read to execute that task independently, while the
parent session continues on its original scope. Output lives in `/tmp/`
(ephemeral — cleared on OS reboot) because the handoff is a one-time message,
not a documentation artifact.

## When to use

| Trigger | Mode |
|---|---|
| `/handoff` with no args | Continuity |
| "save session", "save state before /clear" | Continuity |
| `/handoff [purpose]` | Fork |
| "hand this off", "fork this task", "spin up a session for X" | Fork |
| `[SCOPE]` flag fires — drifted work needs a clean outlet | Fork |

**Do NOT use for:**
- End-of-session wrap → use `/wrap-session`. It runs continuity mode itself
  as its Step 0.5, then additionally handles telemetry, log appends,
  innovation triage, and the commit. Invoke `/handoff` directly only for
  *mid-session* continuity — saving state before `/clear` when you intend to
  keep working the same thread — not as a substitute for a full wrap.
- Returning child-session results to the parent → run `/handoff` (no args) in
  the child session to save state, then tell the parent the scratchpad path

## Input contract

`$ARGUMENTS` (optional):
- **Absent:** continuity mode
- **Present:** fork mode — the argument is the purpose statement describing
  the task the child session should execute

## Output structure

### Continuity mode output

Written to: `logs/scratchpads/{YYYY-MM-DD}-{HH-MM}-scratchpad.md`
(project-relative path; directory created at runtime if absent)

```
# Session Scratchpad — {date} {time}

**Saved at:** {ISO 8601 timestamp}

## Current Task
{Stage, step, command, specific activity}

## Files Produced
- `path/to/file.md` — description

## Files Modified
- `path/to/file.md` — what changed

## Decisions Made
- **Decision title.** Rationale. (Note if not yet logged to decisions.md)

## Partial Work State
{Draft iteration count, QC status, anything in-flight not yet in a file}

## Artifact State
{Only if actively iterating on a deliverable: artifact path, current version,
review layers completed + verdicts, open findings, editorial direction.}

## Session Context
{Key reasoning, rejected approaches, corrections expensive to rediscover.
Not a transcript — the non-obvious things the next session needs.}

## Working Assumptions
{Things established as true for this work that aren't in any file.
Resolved ambiguities, scope boundaries, closed questions.}

## Operator Directives
{Instructions the operator gave this session that affect how work continues}

## Resume With
{Specific next action — e.g., "Run /run-cluster for cluster 03"}

## Key Files for Context
{Files specific to the current task that /prime wouldn't load by default}
```

### Fork mode output

Written to: `/tmp/handoff-{YYYY-MM-DD}-{HH-MM}-{slug}.md`

Slug: 2–3 load-bearing words from the purpose statement in kebab-case
(e.g., "refactor cluster-analysis bias section" → `refactor-cluster-analysis`).
Timestamp: `HH-MM` format (no colons — filesystem-safe).

```
# Handoff — {purpose statement}

**Created:** {ISO 8601 timestamp}
**Parent session scope:** {one sentence — what the parent is working on}

## Task for child session

{2–4 sentences: what must be done, what "done" looks like, constraints.}

## Context

### Files in scope
{Absolute file paths, one-phrase role note each. Paths only — no content.}

### Relevant decisions
{Decisions made this session that constrain the child's work. One line each.}

### Working assumptions
{Facts established in this session not written in any file — resolved
ambiguities, scope boundaries, things the child must not reopen.}

### Avoid
{Approaches tried and rejected, known pitfalls. Prevents retreading ground.}

## Suggested entry point

{Specific first action — e.g., "Run /prime, then read [path], then [action]."}

## Suggested skills / commands

{Bulleted list: - /skill-name — one-line rationale}
```

## Execution workflow

### Step 1 — Detect mode

If `$ARGUMENTS` is non-empty → **fork mode** (Steps F1–F7).
If `$ARGUMENTS` is absent → **continuity mode** (Steps C1–C2).

---

### Continuity mode

**Do NOT run git commands or bash commands to discover files.** Use conversation
context — you already know what was produced this session.

**C1 — Write scratchpad.** From conversation context, populate the scratchpad
format above. Omit any section that has no content (e.g., no decisions → skip
that section entirely).

**C2 — Confirm.** After writing, output the file path and remind the operator:
- Run `/clear` to start fresh, then `/prime` to resume
- Or run `/compact` if you prefer lossy summarization over a clean restart

---

### Fork mode

**F1 — Confirm scope.** Use `$ARGUMENTS` as the purpose statement. If the
purpose covers multiple unrelated tasks, tell the operator: "The scope covers
multiple tasks — handoff works best for one bounded task. Narrow to one, or
I will create separate files." Do not silently combine.

**F2 — Identify relevant files.** From conversation context, list absolute file
paths read, created, or modified this session that are relevant to the scoped
task. Add a one-phrase role note per file (e.g., "recently modified",
"reference only"). Exclude session-global files (e.g., `logs/session-notes.md`)
unless directly relevant. Annotate uncertain paths with
`[path unverified — from conversation context]`.

Do NOT open files to extract content. Paths only.

**F3 — Extract context slice.** From conversation context:
- **Decisions:** choices made this session that constrain the child's work
- **Working assumptions:** resolved ambiguities and scope boundaries not in
  any file — things the child must not reopen
- **Avoid list:** approaches tried and abandoned, known pitfalls this session

**F4 — Redact.** Scan extracted context for:
- API keys (patterns: `sk-`, `Bearer `, long alphanumeric credential strings)
- Passwords or passphrases
- PII (name + contact info, account numbers, government IDs)

Replace each sensitive value with `[REDACTED — {type}]`. Preserve surrounding
context so the child can obtain the value through proper channels. Redaction
is best-effort — novel credential formats may not match known patterns.

**F5 — Suggested skills.** Extract 3–5 keywords from the purpose statement.
Match against skills and commands relevant to the task type. Always include
as universal entry points: `/prime`, `/session-start`, `/session-plan`.
Format: `- /skill-name — one-line rationale`.

**F6 — Construct path.**
1. Build slug: 2–3 load-bearing words from purpose in kebab-case.
2. Build path: `/tmp/handoff-{YYYY-MM-DD}-{HH-MM}-{slug}.md`.
3. Collision check: attempt to `Read` the target path. If the file already
   exists, append `-2` to the slug and warn the operator before writing.

**F7 — Write and confirm.** Write the handoff file. Omit sections with no
content. Then output:
```
Handoff written → {absolute path}
Slug: {slug}
Scope: {purpose statement}
```
Remind the operator: "Open a new Claude Code session and read `{path}` to
begin — run `/prime` first if the child session needs project context."

## Failure behavior

- **No args, no recognizable session context:** Write what is known; leave
  ambiguous sections empty rather than fabricating. Note gaps in the file.
- **Multiple tasks in purpose statement:** Surface to operator, ask to narrow
  or confirm separate files. Do not silently combine.
- **Write to `/tmp/` fails:** Report the error. Suggest writing to
  `logs/scratchpads/` as an alternative. Do not substitute silently.
- **Slug collision (same minute, same slug):** Append `-2`; warn operator.

## Bias countering

**Do not copy file content (fork mode).** The pull toward "being helpful by
including more" is strong. The child session has full filesystem access — it
can read files directly. Copying content inflates context load without adding
information and risks staleness if the parent modifies the file after handoff.

**Do not invent session state (continuity mode).** Only record what actually
occurred this session. If a section is empty, omit it rather than filling it
with plausible-sounding content.

**Scope discipline (fork mode).** One bounded task per handoff. Multi-task
purpose statements are a signal to stop and clarify, not to combine silently.

## Known pitfalls

**`/tmp/` impermanence.** macOS clears `/tmp/` on reboot. If the child session
won't start until the next day, consider using continuity mode (no args) with
`logs/scratchpads/` output instead, then manually scope the scratchpad.

**Return path.** For child-session results back to the parent: run `/handoff`
(no args) in the child session to save its state to `logs/scratchpads/`; report
the path to the parent session's operator.

**File path drift (fork mode).** Files listed in the handoff are path pointers,
not snapshots. If the parent modifies a listed file after writing the handoff,
the child reads the updated version — this is correct behavior, not a bug.

## Runtime recommendations

- **Model:** Sonnet. Both modes are structured extraction and formatting work.
- **Effort:** Medium. Continuity: ~60 lines of structured output from context.
  Fork: scope extraction + redaction + path construction + ~50 lines output.
- **`disable-model-invocation: true`:** Set. This skill writes to the
  filesystem; must not fire as a side effect of conversational mentions of
  "hand off" in unrelated prose.
- **Tools required:** Write (output file). Fork mode additionally needs Read
  (collision check on target path, Step F6 only). No Bash.
