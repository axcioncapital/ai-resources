---
name: kb-update
description: Add or revise a note in the {{KB_NAME}} vault. Atomic index update enforced. Pauses for operator approval before writing.
model: sonnet
---

# /kb-update — Add or Revise a Vault Note

Atomic workflow for adding or revising a single note. Three writes happen together or not at all: the note, the folder's `_index.md`, and `_master-index.md`.

## Argument

`$ARGUMENTS` — describe what to add or change. Examples:
- `research my-source-name` — add or update a research note
- `decision decision-slug` — add or update a decision record
- `architecture component-name` — add or update an architecture note
- `finding finding-slug` — add or update a finding

If `$ARGUMENTS` is empty, ask the operator for the target folder and note name before proceeding.

## Workflow

### Step 1: Read current state

1. Read the target note end-to-end (if it exists).
2. Read `_master-index.md`.
3. Read the folder's `_index.md`.
4. Read the relevant template from `templates/` for the note type.

### Step 2: Draft the change

Produce three diffs:
1. **The note** — new entry or updated content.
2. **`{folder}/_index.md`** — row added or updated; `last_updated` bumped.
3. **`_master-index.md`** — `last_updated` bumped; "Recent updates" entry added.

All new notes enter with `status: draft`. Never set `status: canonical` automatically.

### Step 3: Pause for approval (mandatory)

Display the three diffs and ask: **"Apply these three writes atomically? (y / n / revise)"**

Wait for operator response. Do not write anything without explicit `y`.

### Step 4: Write atomically

1. Write the note.
2. Write `{folder}/_index.md`.
3. Write `_master-index.md`.

If any write fails, undo the others by re-writing the prior content (held in memory from Step 1).

## Rules

- **One note per invocation.** Multi-note changes require multiple invocations.
- **Status is operator-only.** Never promote `draft` → `canonical` automatically.
- **No partial writes.** All three files update together or none does.
- **`Related:` links encouraged.** Cross-link to related notes across folders — this is where graph value comes from.
