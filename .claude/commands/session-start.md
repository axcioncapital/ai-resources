Capture a lightweight session mandate for Phase 3 harness-style sessions. The operator's mandate context (if any) follows this prompt: $ARGUMENTS

---

**Boundary note — three session-start mechanisms exist:**
- `session-start.sh` hook — fires automatically at session init; writes `harness/session/startup-state.json`; detects crashes. Not operator-invoked.
- `/session-start` (this command) — operator-invoked; captures a Phase 3 lightweight mandate; writes a single `**Mandate:**` line to `logs/session-notes.md`. Run after `/prime`.
- `mandate-parser` skill — full harness mandate capture; produces `harness/session/mandate.json`; used in Phase 5+ harness sessions. Not for Phase 3.

**Revert note:** If this command is removed, any `**Mandate:**` lines and `### Session Report` subsections already written to `logs/session-notes.md` remain and must be cleaned manually.

---

## Instructions

### Step 0 — Precondition check

Read `logs/session-notes.md` (last 10 lines). Check for a today-dated header matching `## YYYY-MM-DD` (today's date).

If no today-dated header is found: emit one warning line — `Note: /prime may not have run yet today. Proceeding.` — then continue. Do NOT block.

### Step 1 — Read the mandate

If `$ARGUMENTS` is non-empty, use it verbatim as `MANDATE_TEXT`.

Otherwise, ask the operator **one prompt** (wait for one answer):

> "State the session mandate in 2–5 sentences. Include: what you're doing, what's out of scope, and when you're done."

### Step 2 — Parse and confirm

Extract from `MANDATE_TEXT`:

- `work_scope` — what work will be done, including explicit scope boundaries
- `exit_condition` — what "done" looks like; must be observable or countable
- `files_in_scope` — which files may be edited; infer from `work_scope` if not stated

Echo to the operator:

```
---
MANDATE CONFIRMATION
Work:       {work_scope}
Done when:  {exit_condition}
Files:      {files_in_scope}
---
```

Ask: `"Confirm, or correct any field."` Wait. Accept one correction pass only.

### Step 3 — Write the mandate line

**Mandate line format (exact):**

```
**Mandate:** {one-sentence summary of work_scope} — done when: {exit_condition}
```

Read `logs/session-notes.md` (last 10 lines) to locate today's session header.

- If today's header (`## YYYY-MM-DD`) exists: append the mandate line immediately after the header, before any existing body content.
- If today's header is absent: append to the file:
  ```
  ## YYYY-MM-DD
  **Mandate:** {one-sentence summary of work_scope} — done when: {exit_condition}
  ```

### Step 4 — Confirm

Output exactly:

```
Mandate written → logs/session-notes.md
Ready. Commit after each work unit.
```
