# repo-architecture.md — Document knowledge-bases/ Top-Level Directory

**Date:** 2026-05-26
**Source entry:** `ai-resources/logs/improvement-log.md` § "2026-05-26 — repo-architecture.md is stale on `knowledge-bases/` (top-level directory + canonical-homes row)"
**Status:** Plan draft (no code edits this session)
**Intended execution:** Separate session

---

## Source citation

- **Logged:** 2026-05-26 in `ai-resources/logs/improvement-log.md` (the canonical improvement-log).
- **Surfaced by:** `/consult` system-owner advisory during `/context-builder` for the `strategic-os` project (operator asked where a planned Karpathy-style Obsidian frameworks KB should be deployed via `/deploy-kb`).
- **Severity:** Documentation drift, MED. Routed to next `/friday-checkup` cadence per the improvement-log entry's own triage.
- **System-owner principles cited:** OP-11 (surfacing tacit principles); `system-doc.md § 4.5` (documentation-accuracy open loop).

## Diagnosis

`ai-resources/docs/repo-architecture.md` is the canonical placement reference, consulted by:
- `/route-change` (routing advisor)
- `/consult` system-owner (architectural decisions)
- Operators making placement decisions
- Any session deciding "where does X live?"

Two drift gaps are present today:

**Gap 1 — Top-level layout omits `knowledge-bases/`.**

The workspace-root tree (lines 11–30) lists `CLAUDE.md`, `.claude/`, `ai-resources/`, `harness/`, `logs/`, `projects/`, `reports/`, `workflows/`. It does **not** list `knowledge-bases/`. But `knowledge-bases/` exists at workspace root and currently contains `pe-kb-vault/` (verified by `ls /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/knowledge-bases/` during this scope session — one entry: `pe-kb-vault/`).

**Gap 2 — Canonical-homes table has no row for "Obsidian KB vault".**

The artifact-type table (lines 90–110) lists 16 artifact types but has no row for cross-project Obsidian KB vaults. The implicit principle — "KB vaults intended for cross-project reuse live in `knowledge-bases/{name}/`; project-scoped vaults live under `projects/{name}/vault/`" — is currently tacit. `/deploy-kb` already offers `knowledge-bases/{name}/` as a first-class deployment option, so the principle has operational consequences; documentation should make it explicit.

### Why this matters

`repo-architecture.md` is a load-bearing reference, not a polish document. When future placement decisions reach for it (next `/deploy-kb`, next `/consult` on where a KB belongs, next operator decision on a new vault), the tacit principle is the placement signal. If the doc is silent, the decision relies on memory and `/consult` token-budget instead of a one-line lookup.

This is exactly the type of documentation-accuracy gap `repo-architecture.md`'s own "When this file needs to change" section is designed to catch — it already lists "A new top-level directory under workspace root or ai-resources" as a trigger. The gap is execution-discipline (the directory existed before the doc rule was added; the doc was never backfilled), not rule-design.

### Secondary observation (out of scope for this plan)

`ls /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/` shows a second top-level directory not listed in the top-level layout: `artifacts/`. The implementation session can confirm or fold this into the same edit pass if appropriate — but this plan's scope is `knowledge-bases/`; `artifacts/` is a separate decision and a separate source entry would normally be required to add it. Flag this for the operator at implementation time.

## Implementation plan

**Target file:** `ai-resources/docs/repo-architecture.md`
**Edit type:** Single coordinated pass with three additions and zero deletions.

### Edit 1 — Add `knowledge-bases/` to the workspace-root tree (lines 11–30)

Insert a new line in the workspace-root tree, after `├── harness/                                     # harness dev project (separate concern)` and before `├── logs/`:

```
├── knowledge-bases/                             # standalone Obsidian KB vaults for cross-project reuse, deployed via /deploy-kb
```

Sort order: alphabetical, which puts `knowledge-bases/` between `harness/` and `logs/`. (Verify the current tree's sort convention at implementation time; if other entries are not strictly alphabetical, follow the existing pattern.)

### Edit 2 — Add a canonical-homes row for Obsidian KB vault (lines 90–110)

Add one row to the canonical-homes table. Insert it after the "Workflow template" row (currently around line 102) and before the "Style reference" row:

```
| **Obsidian KB vault (cross-project reuse)** | `knowledge-bases/{name}/` | Deployed via `/deploy-kb` standalone option. Project-scoped vaults instead live under `projects/{name}/vault/`. |
```

This row captures the implicit principle (cross-project reuse → workspace-root `knowledge-bases/`; project-scoped → inside the project) that is currently tacit knowledge held by `/deploy-kb` and the operator.

### Edit 3 — Confirm "When this file needs to change" already covers this case

The section (lines 231–241) already lists "A new top-level directory under workspace root or ai-resources" as a trigger. **No change needed to this section.** The Wave 3 / 2026-05-26 entry's proposal explicitly notes this. The gap was execution discipline, not rule design.

### Non-edits

- Do not touch the symlink topology section.
- Do not touch the placement heuristics section (Q1–Q8); the new row in the canonical-homes table is sufficient. If the implementation session finds an existing Q-block where adding a one-line cross-reference would improve discoverability, it may add one — but the canonical-homes row is the load-bearing change.
- Do not touch the "Related canonical sources" footer.

### Verification step before writing

Confirm via `ls` that `pe-kb-vault/` is the only existing entry under `knowledge-bases/` at implementation time. If a second vault has been added in the meantime, the row's framing ("standalone Obsidian KB vaults") still applies — but flag for the operator so they confirm the framing.

## Risk-check brief

**Pre-filled brief — concise because no `/risk-check` is required:**

- **Change class:** Documentation edit (`ai-resources/docs/repo-architecture.md`).
- **Not on the canonical change-class list** per `ai-resources/docs/audit-discipline.md` § Risk-check change classes. The list covers hooks, permissions, CLAUDE.md edits, new commands or skills, new symlinks, automation with shared-state effects. A docs-only edit to a single reference file is none of those.
- **Blast radius:** Documentation reach is repo-wide, but the change is additive: adds one tree-entry and one table-row. No existing content is altered or removed; no consumer is broken.
- **Reversibility:** Full — single-file revert.
- **Hidden coupling risk:** Low. `repo-architecture.md` is referenced by `/route-change` and `/consult` system-owner; both consume the file as prose context, not as a parsed structure. New entries do not break parsers (there are none).

**`/risk-check` not required at plan-time.** This is a docs-only edit, not on the canonical change-class list per `ai-resources/docs/audit-discipline.md`; see workspace `CLAUDE.md` Autonomy Rule #9 (gates apply only to listed classes).

## Acceptance criteria

1. The workspace-root tree in `repo-architecture.md` (lines 11–30 region) contains a `├── knowledge-bases/` entry with the one-line description from Edit 1.
2. The canonical-homes table (lines 90–110 region) contains a new row for "Obsidian KB vault (cross-project reuse)" with `knowledge-bases/{name}/` as the canonical home and the distribution note from Edit 2.
3. No existing tree entries, table rows, or section content are modified or removed.
4. `/route-change` and `/consult` continue to read the file without parser errors (sanity check — there are no parsers; this is a freeness check on the structural change).
5. Verification step (the `ls` confirmation that `pe-kb-vault/` is the current sole vault) is documented in the commit message or the implementation session's notes.
6. Improvement-log entry in `ai-resources/logs/improvement-log.md` is updated to `Status: applied YYYY-MM-DD` and `Verified: YYYY-MM-DD` after operator confirmation.

## Out of scope

- Adding `artifacts/` to the top-level layout (flagged in Diagnosis § "Secondary observation"; requires its own decision).
- Any change to `/deploy-kb` or `/consult`.
- Reorganization or restructuring of `repo-architecture.md` beyond the two additions above.
- Any propagation of the new principle to project-level `CLAUDE.md` files or to `/deploy-kb`'s prompt text (this plan documents the principle in one place; downstream consumers can be updated separately if drift surfaces).
