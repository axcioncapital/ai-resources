---
name: kb-query
description: Query the {{KB_NAME}} knowledge base using the root→branch→leaf navigation path. Reasons only against canonical notes. Hard cap: 5 reads per query.
model: sonnet
---

# /kb-query — Query the Knowledge Base

Query the {{KB_NAME}} vault using structured navigation. Do not scan the full vault directory.

## Navigation path (mandatory)

Follow this exact sequence — do not skip steps:

1. **Read `_master-index.md`.** Identify which content folder(s) are relevant to the query.
2. **Read `{folder}/_index.md`** for the identified folder(s). Scan the table to find relevant note(s).
3. **Read the specific note(s).** Follow `Related:` links if the initial note doesn't fully answer the question.

**Hard cap: 5 file reads per query.** If 5 reads are insufficient, summarize findings from those reads and ask the operator which note to open next.

## Reasoning rules

- Reason only against notes with `status: canonical`. `draft` and `scratch` entries exist but are not authoritative.
- If the vault has no information on the topic, say so explicitly. Name the gap — do not fill it from general knowledge.
- Cite every note used. Use standard markdown links `[note-name](folder/note-name.md)` — Claude Code does not render `[[wiki-links]]` in responses.

## What NOT to do

- Do not run `ls`, `Glob`, or directory listings across the vault.
- Do not open notes speculatively because the name looks relevant.
- Do not answer from training data without consulting the vault first.
- Do not modify any vault file.
