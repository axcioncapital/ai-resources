---
description: Log a friction event or start a new friction log session — side-effect-bearing log writer; operator-invoked.
model: sonnet
disable-model-invocation: true
argument-hint: "start | [description]"
---

Log a friction event or start a new friction log session.

## Usage
- `/friction-log start` — Initialize a new session block in the friction log
- `/friction-log [description]` — Append a friction entry to the current session block

## Instructions

1. Parse $ARGUMENTS:
   - If the first word is "start", go to step 2 (start a session block)
   - If $ARGUMENTS is empty, show the usage lines above and stop
   - Otherwise, go to step 3 (append a friction entry)

2. **Start a session block:**
   - Read `logs/friction-log.md` (last 5 lines to find the append point). If the file doesn't exist, create it with `# Friction Log` as the first line.
   - Append a new session block:
     ```
     ## Session — {YYYY-MM-DD HH:MM}

     ### Friction Events

     #### Write Activity
     ```
   - Confirm: "Friction log session started."
   - Stop.

3. **Append a friction entry:**
   - Read `logs/friction-log.md` (last 30 lines to find the current session's Friction Events section).
   - If no `### Friction Events` section exists, run step 2 first to create a session block, then continue.
   - **Capture context:** the latest commit short-hash (`git log -1 --pretty=%h`) and the title of the most recent `## {today}` header in `logs/session-notes.md` (the text after the date). Either may be unavailable.
   - Append under the most recent `### Friction Events` heading (before `#### Write Activity`), with a `(context: …)` suffix:
     ```
     - **{HH:MM}** — {description from $ARGUMENTS} (context: {short-hash}, {session-note title})
     ```
     Include whichever signals are available; if only one, list just that one; if neither, use `(context: none captured)`.
   - **Stub check:** evaluate the `$ARGUMENTS` description only (not the `(context: …)` suffix). If it is under ~15 characters OR matches the placeholder pattern `^(note this|todo|tbd|fixme|xxx|\.\.\.)\.?$` (case-insensitive), append ` [STUB — expand before next /improve]` after the `(context: …)` suffix on that same entry line. Non-blocking — the entry is still logged immediately.
   - Confirm with a one-line acknowledgment. Do NOT ask clarifying questions — log exactly what the user typed. If the entry was flagged a stub, the acknowledgment is instead: "Logged as a stub. Add detail with another `/friction-log ...` when you have a moment."

$ARGUMENTS