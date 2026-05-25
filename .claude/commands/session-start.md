---
model: sonnet
---

Capture a lightweight session mandate for Phase 3 harness-style sessions. The operator's mandate context (if any) follows this prompt: $ARGUMENTS

---

**Boundary note — three session-start mechanisms exist:**
- `session-start.sh` script — run by the `mandate-parser` skill at harness entry (its Step 1); writes `harness/session/startup-state.json`; detects crashes. Not a `SessionStart` hook, not operator-invoked.
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

Echo the following confirmation block to the operator. Render it as Markdown — do NOT emit a raw pre-formatted code block, and do NOT emit the ``` fences shown below; those fences only delimit the template structure for this instruction. Follow these rendering rules exactly:

<!-- TODO: extract to shared rendering convention -->
<!-- Style applies to chat echo only. Step 3 disk-write contract is plain bullet labels; see Step 3 comment. -->

**Semantic marker set** (icons inside content only — never on section labels):
- `⚠` — warning / risk / attention-needed
- `↩` — resumable / continuation point
- `→` — forward action / to be done
- `✓` — done / verified / already in place
- `✗` — blocked / failed
- `·` — deferred / informational / out of scope

**Rendering rules:**
- Section labels: **bold inline** on their own line, content on the next line.
- Multi-item content: Markdown bulleted list, one item per line. Never inline `•` separators.
- File-to-change mappings: Markdown table when ≥3 files. Collapse to one row per file with all changes comma-separated. Use `inline code` for all paths, filenames, env vars, and command names.
- `---` horizontal rules separate the body zone (Work through Stop if) from the reply prompt.
- No paragraph exceeds ~3 lines — break into bullets if it would.
- One icon per list item maximum.
- The only `##` header is `## Mandate Confirmation`.

**Derivation constraints for synthesized fields:**
- `**Summary:**` — one sentence, ≤20 words. Capture the structural shape of the work: counts, file types, affected scopes. Append a brief deferred-scope clause only if out_of_scope is stated. Do not restate work_scope literally.
- `**{Section label}**` — present only when work_scope contains discrete deliverables (numbered steps, named items, or bullet-style tasks). Derive the label from the nature of the items: "Quick wins" for QW-framed batches, "Steps" for sequential work, "Tasks" for general items. Enumerate verbatim from work_scope. No re-ordering, no invention, no paraphrase.

**Output shape:**

```
## Mandate Confirmation

**Summary:** {one sentence, ≤20 words — structural shape of the work}  <!-- chat-echo only — NOT a parse field -->

**Work:** {work_scope — one sentence}

---

**{Section label}**  <!-- chat-echo only — NOT a parse field; label derived from work type -->
{for each discrete item in work_scope — if work_scope contains enumerable items:}
- → **{item label}** — {item description}
{if work_scope is a single undivided statement, omit this section entirely}

**Files**
{if ≥3 files:}
| Path | Changes |
|---|---|
| `{file}` | {what changes} |
{else: one bullet per file:}
- `{file}` — {what changes}
{if files_inferred = true, append "(inferred — correct with f: <paths> if wrong)" after the table/list}

**Out of scope**
{if out_of_scope is not "(none stated)":}
- · {out_of_scope — one bullet per item if multiple}
{else: omit this section entirely}

**Done when**
- ✓ {exit_condition — split into separate bullets if multiple observable conditions are stated}

**Stop if**
{if stop_if is not "(none stated)":}
- ⚠ {stop_if — one bullet per condition}
{else: omit this section entirely}

---

Reply `confirm` / `y` to accept, or correct fields with `b: <new text>` syntax.
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

<!-- LOAD-BEARING: bullet labels below are parsed verbatim by /wrap-session Step 7a. Do not stylize. If Step 2 echo styling changes, do NOT propagate here. -->

**Mandate line format (exact):**

```
**Mandate:** {one-sentence summary of work_scope} — done when: {exit_condition}
- Out of scope: {out_of_scope}
- Files in scope: {files_in_scope_written}
- Stop if: {stop_if}
```

**Parse contract:** `wrap-session.md` Step 7a depends on the exact bullet labels (`- Out of scope:`, `- Files in scope:`, `- Stop if:`), the `(inferred)` marker, and the `(none stated)` marker written here. Do not rename these labels or marker strings without updating Step 7a.

Where `files_in_scope_written` is:
- `(inferred)` — if `files_inferred = true` (operator did not state or correct this field)
- the operator's stated/corrected value — if `files_inferred = false`

Using the `logs/session-notes.md` content already read in Step 0, locate today's session header. If Step 2 took longer than ~30s or a concurrent session may have written to `logs/session-notes.md` during Step 1/Step 2, re-read the last 10 lines before locating the header.

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
