---
model: sonnet
---

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

> "State the session mandate."

### Step 2 — Parse and confirm

Extract from `MANDATE_TEXT`:

- `work_scope` — what work will be done, including explicit scope boundaries
- `out_of_scope` — what is explicitly excluded; default `"(none stated)"` if not mentioned
- `exit_condition` — what "done" looks like; must be observable or countable
- `files_in_scope` — which files may be edited; if not stated by the operator, infer from `work_scope` for the **echo only** so the operator can verify or correct it; flag internally as **inferred** (`files_inferred = true`). If the operator provides a correction via the confirmation step → set `files_inferred = false` and use the correction.
- `stop_if` — conditions that should halt the session; default `"(none stated)"` if not mentioned

Echo to the operator:

```
---
MANDATE CONFIRMATION
Work:         {work_scope}
Out of scope: {out_of_scope}
Done when:    {exit_condition}
Files:        {files_in_scope}
Stop if:      {stop_if}
---
```

`(none stated)` fields will be recorded as omitted — only correct if actively wrong.

Ask:

> "Reply `confirm` (or `y`) to accept, or list field corrections in the form `b: <new text>`. Bare single letters other than `y` are treated as ambiguous and re-asked."

Wait for one response. Apply these parser rules:
- **Confirmation:** response is exactly `confirm`, `y`, or `yes` (case-insensitive, trimmed) → proceed to Step 3.
- **Ambiguous single letter:** response matches `^[a-z]\.?(\s|$)` and is NOT exactly `y` → re-ask once:
  `"Reply 'confirm' or 'y' to accept, or use 'b: new text' syntax for corrections. Single letters other than 'y' are ambiguous."` Accept the re-response and proceed regardless.
- **Correction:** correction syntax is `<letter>: <replacement text>` (colon required, not period). Multiple corrections may appear on separate lines. Parse and apply each; unrecognised syntax is treated as free-text amendment to `work_scope`.

### Step 3 — Write the mandate line

**Mandate line format (exact):**

```
**Mandate:** {one-sentence summary of work_scope} — done when: {exit_condition}
- Out of scope: {out_of_scope}
- Files in scope: {files_in_scope_written}
- Stop if: {stop_if}
```

**Parse contract:** `wrap-session.md` Step 6a depends on the exact bullet labels (`- Out of scope:`, `- Files in scope:`, `- Stop if:`), the `(inferred)` marker, and the `(none stated)` marker written here. Do not rename these labels or marker strings without updating Step 6a.

Where `files_in_scope_written` is:
- `(inferred)` — if `files_inferred = true` (operator did not state or correct this field)
- the operator's stated/corrected value — if `files_inferred = false`

Read `logs/session-notes.md` (last 10 lines) to locate today's session header.

- If today's header (`## YYYY-MM-DD`) exists: append the mandate line immediately after the header, before any existing body content.
- If today's header is absent: append to the file:
  ```
  ## YYYY-MM-DD
  **Mandate:** {one-sentence summary of work_scope} — done when: {exit_condition}
  - Out of scope: {out_of_scope}
  - Files in scope: {files_in_scope_written}
  - Stop if: {stop_if}
  ```

### Step 4 — Confirm

Output exactly:

```
Mandate written → logs/session-notes.md
Ready. Commit after each work unit.
```

**Next:** Run `/session-plan` to plan model tier, source material, autonomy posture, and structural risk for the session.
