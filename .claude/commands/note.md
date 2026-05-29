---
model: sonnet
---

The user wants to log a workflow observation. Their note follows this prompt.

## Routing

Parse $ARGUMENTS for a prefix:
- If $ARGUMENTS starts with "friction:" (case-insensitive), strip the prefix and route to the friction log (see Step A below).
- Otherwise, route to the workflow observations log (see Step B below).

## Step A: Friction routing

1. Read `/logs/friction-log.md` (last 30 lines). If the file doesn't exist, create it with `# Friction Log` as the first line.
2. If no `### Friction Events` section exists in the last 30 lines, append a new session block — the **canonical block** below. It is byte-identical to what `/friction-log` writes and what the `friction-log-auto.sh` hook writes; the three writers emit the same `## Session —` / `### Friction Events` / `#### Write Activity` block, and detection keys reliably on every header. Do not invent a `/note`-specific header:
   ```
   ## Session — {YYYY-MM-DD HH:MM}

   ### Friction Events

   #### Write Activity
   ```
3. **Capture context, then append the entry.**
   - Capture two cheap context signals: the latest commit short-hash (`git log -1 --pretty=%h`) and the title of the most recent `## {today}` header in `logs/session-notes.md` (the text after the date). Either may be unavailable.
   - Append the friction entry under the most recent `### Friction Events` heading, before the `#### Write Activity` line, with a `(context: …)` suffix:
     ```
     - **{HH:MM}** — {text after "friction:" prefix} (context: {short-hash}, {session-note title})
     ```
     Include whichever signals are available; if only one, list just that one; if neither, use `(context: none captured)`.
3a. **Stub check.** Evaluate the operator's friction text only (the text after the `friction:` prefix — not the `(context: …)` suffix). If it is under ~15 characters OR matches the placeholder pattern `^(note this|todo|tbd|fixme|xxx|\.\.\.)\.?$` (case-insensitive), append ` [STUB — expand before next /improve]` to the end of that entry line, after the `(context: …)` suffix. This is non-blocking — the entry is still logged immediately; the marker just flags it as incomplete for the operator and the next `/improve` run.
4. Confirm:
   - Normal entry: "Friction event logged."
   - Stub entry: "Logged as a stub. Add detail with another `/note friction: ...` when you have a moment."

## Step B: Workflow observation routing

1. Append the note to /logs/workflow-observations.md
2. Add a timestamp and the current session context (which phase, which section)
3. If the file doesn't exist, create it with a header: "# Workflow Observations"
4. Confirm the note was added with a one-line summary

$ARGUMENTS
