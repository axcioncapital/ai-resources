---
name: kb-integrity
description: Read-only drift scan of the {{KB_NAME}} vault. Flags stale drafts, missing frontmatter, and broken Related links. No vault content edited.
model: sonnet
---

# /kb-integrity — Vault Drift Scan (Read-Only)

Scans the {{KB_NAME}} vault for integrity violations. Produces a dated report. Does NOT edit any vault content.

## Output

Report written to `_integrity-report-{TODAY}.md` in the vault root, where `{TODAY}` is today's date in YYYY-MM-DD format.

## Checks

### Check A — Stale drafts

Notes with `status: draft` and `last_updated` older than 90 days. These are awaiting operator review.

Severity: `warn`. Suggested action: promote to `canonical` or delete.

### Check B — Missing frontmatter

Notes missing any of `status`, `last_updated`, or `Related`. These violate the vault's note convention.

Severity: `error`. Suggested action: open the note and add the missing field.

### Check C — Broken `Related:` links

For each note, parse the `Related:` YAML list. Attempt to resolve each wikilink against the vault folder structure. Links pointing to non-existent notes are broken.

Severity: `warn`. Suggested action: update or remove the broken link.

### Check D — Index drift

For each content folder (`research/`, `architecture/`, `decisions/`, `findings/`), compare notes on disk against rows in the folder's `_index.md`. Flag:
- Notes on disk not in `_index.md` (orphaned notes) → `warn`
- Entries in `_index.md` with no corresponding file (stale entries) → `error`

## Report format

```markdown
# Vault Integrity Report — {TODAY}

**Vault:** {{VAULT_PATH}}
**Scan time:** {ISO-8601 timestamp}
**Total notes scanned:** {N}
**Total findings:** {M} ({error_count} errors, {warn_count} warnings)

---

## Errors

### {finding-title}
- **Check:** {check-id}
- **Location:** {path or note name}
- **Evidence:** {excerpt}
- **Suggested action:** {direction}

---

## Warnings

(same shape)

---

## Clean checks

- {check-id}: no findings
```

## Rules

- **Read-only.** The only file this command writes is the dated integrity report.
- **No auto-fixes.** Report findings to the operator; the operator decides what to fix.
- **Bounded scan.** If notes on disk exceed 500, stop and report `[SCAN TOO LARGE]`.
