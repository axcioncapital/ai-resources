# {{KB_NAME}} Knowledge Base — CLAUDE.md

## Purpose

This vault is the knowledge base for {{PROJECT_NAME}}. It holds structured research, architecture documentation, decisions, and findings. It is optimized for Obsidian graph navigation and Claude Code query efficiency.

This is NOT a general file store or collaborative editing space. It is a single-operator knowledge base governed by the rules below.

## Operating Modes

You operate in exactly one mode at any time. Patrik's instruction determines the mode.

### Query mode

**Triggered by:** Patrik asks a question, with no instruction to update or add a note.

**Your read path — fixed and minimal:**
1. Read `_master-index.md`.
2. Identify the relevant folder(s) from the index.
3. Read that folder's `_index.md`.
4. Read 1–3 specific notes from the table. Hard cap: **5 reads per query**.

If the first 5 reads do not answer the question, summarize what you found and ask Patrik which note to open next. Do not scan the full vault.

**In query mode you NEVER:**
- Run directory listings (`ls`, `Glob`) across the vault.
- Open notes speculatively because the name looks relevant.
- Answer from training data without consulting the vault first.
- Modify any vault file.

**When answering:** Cite every note you used. Use standard markdown links `[note-name](folder/note-name.md)` since Claude Code does not render `[[wiki-links]]` in responses. If the vault has no information on the topic, say so explicitly — do not fill the gap from general knowledge.

**Reasoning against `canonical` entries only.** `draft` entries exist but are pending review. `scratch` entries are ephemeral and ignored.

### Update mode

**Triggered by:** Patrik asks to add a new note, update an existing note, or promote a note's status.

**In update mode:**
1. Read the target note end-to-end (if it exists).
2. Read `_master-index.md` and the folder's `_index.md`.
3. Draft the three changes atomically: the note, the `_index.md`, and `_master-index.md`.
4. **Pause and show the operator the three diffs. Wait for explicit `y` before writing.**
5. Write all three atomically. If any write fails, undo the others.

**Atomic index rule.** When a note is added or revised, three writes happen as a unit: the note, the folder's `_index.md`, and `_master-index.md`. All three update together or none does. Indexes drifting from content is the primary failure mode in this vault.

**In update mode you NEVER:**
- Promote `status: draft` → `status: canonical` without explicit operator instruction.
- Write notes without operator approval.
- Skip the index update.

## Governance Rules

1. **Operator is sole writer.** Claude proposes changes; the operator approves before any write.
2. **Status tiers.** `status: draft | canonical | scratch`. Reason only against `canonical` entries in query mode. Never auto-promote.
3. **Staleness.** `/kb-integrity` flags notes not updated in >90 days for review.
4. **Conflict resolution.** When two canonical notes conflict, the newer `last_updated` takes precedence. The operator resolves substantive conflicts.

## Note Frontmatter

Every note must carry:

```yaml
status: draft
last_updated: YYYY-MM-DD
Related: []
```

`Related:` is a YAML list of Obsidian wikilinks: `["[[decisions/some-decision]]", "[[research/source-note]]"]`. Cross-link liberally — the graph value comes from the links.

## Commands

- `/kb-query` — Query the vault using the root→branch→leaf navigation path.
- `/kb-update` — Propose and apply an atomic note addition or revision.
- `/kb-integrity` — Drift scan: stale drafts, missing frontmatter, broken `Related:` links. Read-only.

## Vault path

`{{VAULT_PATH}}`
