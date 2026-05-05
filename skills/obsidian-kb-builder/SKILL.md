---
name: obsidian-kb-builder
description: >
  Defines and scaffolds Claude Code-queryable Obsidian knowledge bases for general-purpose
  project documentation vaults (4-folder schema: research, architecture, decisions, findings).
  Bundles vault folder schema, branching-context-graph navigation spec, governance rules,
  and all template files consumed by /deploy-kb. Use when creating or auditing the
  structure of a project documentation KB vault. Do NOT use for querying or updating notes in
  an existing vault — those are governed by the vault's own CLAUDE.md and /kb-query, /kb-update
  commands deployed alongside it. For multi-theme research systems with atomic-note intake
  pipelines and synthesis layers, see `projects/global-macro-analysis/macro-kb/` as a reference
  for a different pattern.
model: sonnet
effort: medium
---

# Obsidian KB Builder

Specification and template library for Claude Code-queryable Obsidian knowledge bases. This skill defines what a vault IS and how Claude Code should behave inside one. `/deploy-kb` reads from this skill's bundled templates to create a new vault.

**Scope.** This skill targets general-purpose project documentation vaults using the 4-folder schema below (research, architecture, decisions, findings). Multi-theme research KBs with atomic-note intake pipelines and synthesis layers — e.g., `projects/global-macro-analysis/macro-kb/` — are a different pattern and do not use this skill or its templates.

## Vault Schema

Every vault this skill deploys has the following structure:

```
vault/
├── CLAUDE.md                   (operating rules + governance)
├── _master-index.md            (root pointer → subfolder _index.md files)
├── .obsidian/                  (app.json, workspace.json, core-plugins.json, appearance.json)
├── .claude/                    (settings.json, kb-query.md, kb-update.md, kb-integrity.md)
├── research/
│   ├── _index.md               (branch pointer — note list with status + last_updated)
│   └── [notes]
├── architecture/
│   ├── _index.md
│   └── [notes]
├── decisions/
│   ├── _index.md
│   └── [notes]
├── findings/
│   ├── _index.md
│   └── [notes]
├── templates/                  (operator note templates — deployed from note-templates/)
└── inbox/                      (staging area — operator drops new content here)
```

## Branching Context Graph

The vault is a navigable graph, not a flat dump. Claude Code navigates it via three tiers:

1. **Root** — `_master-index.md`. Read first. Contains one section per content type, each linking to its branch index: `[[research/_index]]`.
2. **Branch** — `{folder}/_index.md`. A markdown table listing all notes with status, last_updated, and summary.
3. **Leaf** — individual notes. Each carries a `Related:` field with wikilinks to connected notes across folders.

Navigation path: root → branch → leaf. Load only what the current task needs. Never scan the full vault directory.

## Governance Rules

Four rules apply in every deployed vault. They are specified in `vault/CLAUDE.md` and enforced by `/kb-update` and `/kb-integrity`:

1. **Operator is sole writer.** Claude proposes changes via `/kb-update`; writes require explicit operator approval (`y`). Claude never writes vault notes directly.
2. **Status tiers.** Every note carries `status: draft | canonical | scratch`. Claude Code reasons only against `canonical` entries. `draft` entries await review. `scratch` entries are ephemeral and ignored during queries.
3. **Staleness.** Notes not updated in >90 days are flagged by `/kb-integrity` for operator review.
4. **Conflict resolution.** When two canonical notes conflict, the newer `last_updated` takes precedence. The operator is the sole resolver for substantive conflicts.

## Note Frontmatter Convention

Every note in a deployed vault must carry these three fields:

```yaml
status: draft
last_updated: YYYY-MM-DD
Related: []
```

Notes enter as `status: draft`. The operator promotes to `canonical` after review. `scratch` entries are never promoted. The `Related:` field is a YAML list of Obsidian wikilinks: `["[[decisions/some-decision]]", "[[research/source-note]]"]`.

## Template Files

Bundled templates live in two subdirectories of this skill folder.

**`templates/scaffold/`** — Files `/deploy-kb` writes to create the vault infrastructure:

| Template file | Deployed to |
|---|---|
| `vault-claude-md.md` | `vault/CLAUDE.md` |
| `_master-index.md` | `vault/_master-index.md` |
| `subfolder-index.md` | `vault/{folder}/_index.md` (once per content folder) |
| `kb-query.md` | `vault/.claude/commands/kb-query.md` |
| `kb-update.md` | `vault/.claude/commands/kb-update.md` |
| `kb-integrity.md` | `vault/.claude/commands/kb-integrity.md` |
| `settings.json` | `vault/.claude/settings.json` |
| `obsidian-app.json` | `vault/.obsidian/app.json` |
| `obsidian-workspace.json` | `vault/.obsidian/workspace.json` |
| `obsidian-appearance.json` | `vault/.obsidian/appearance.json` |
| `obsidian-core-plugins.json` | `vault/.obsidian/core-plugins.json` |

**`templates/note-templates/`** — Operator note templates, deployed into `vault/templates/`:

| Template file | Note type |
|---|---|
| `research-note.md` | Research output entry |
| `decision-note.md` | Decision record |
| `architecture-note.md` | System/code documentation note |
| `finding-note.md` | Session finding |

## Placeholder Schema

Template files use `{{...}}` placeholders. `/deploy-kb` substitutes all of them at deploy time before writing each file.

| Placeholder | Value | Used in |
|---|---|---|
| `{{KB_NAME}}` | KB display name (e.g., "Global Macro Analysis") | All template files |
| `{{PROJECT_NAME}}` | Project folder name (option A) or same as `{{KB_NAME}}` (option B) | `vault-claude-md.md`, `_master-index.md` |
| `{{DATE}}` | Today's date — YYYY-MM-DD | `vault-claude-md.md`, `_master-index.md`, `subfolder-index.md` |
| `{{VAULT_PATH}}` | Full absolute path to the deployed vault | `vault-claude-md.md`, `kb-integrity.md` |
| `{{FOLDER_NAME}}` | Content folder name — `research`, `architecture`, `decisions`, `findings` | `subfolder-index.md` (4 deployments) |
| `{{FOLDER_TITLE}}` | Title-case label — `Research`, `Architecture`, `Decisions`, `Findings` | `subfolder-index.md` (4 deployments) |

## Scaffolding Constraints

These rules govern Claude's behavior during a `/deploy-kb` scaffolding run — not inside the vault afterward.

- **No invention.** Derive all values from operator-provided inputs and the templates as defined in this SKILL.md. Do not fill placeholder values from general knowledge, invent folder names not in the schema, or extend the vault structure beyond what is defined here without explicit operator instruction.
- **Missing template — stop and report.** If a template file is absent from `templates/scaffold/` or `templates/note-templates/`, stop immediately and report which file is missing. Do not reconstruct it from memory or substitute a similar template. The correct response is "file X is absent from the skill folder — reinstall the skill or restore the missing file."
- **Ambiguity — surface, don't assume.** If any input is ambiguous (vault path, display name, option A vs B), surface it before any file writes begin. Do not proceed on an assumption about operator intent for load-bearing inputs.

## Failure Behavior

- **Vault already exists at target path.** Do not overwrite. Report the path and tell the operator to delete or rename before re-running `/deploy-kb`.
- **Unresolved `{{...}}` tokens after substitution.** Report which tokens remain and ask the operator for the missing values.
- **Ambiguous vault location.** Always ask — do not default to either option A or B.
- **`jq` not available.** `/deploy-kb` does not require `jq` (unlike `/deploy-workflow`) — template files are plain markdown. If any shell step fails, report the error and the manual alternative.
- **Write failure mid-scaffold.** If a file write fails partway through Step 6, stop. Leave the partially-written vault in place — do not attempt to delete it. Report: which file failed, which files were already written successfully (list them), and the vault path. The operator decides whether to clean up and re-run or recover manually.
- **Git init fails (Option B).** If the git init or initial commit fails, leave the vault files intact and report the git error. The vault is usable without git — instruct the operator to `git init` manually when ready.

## Validation Checklist

After `/deploy-kb` completes, verify:

- [ ] All `{{...}}` placeholders resolved in every deployed file
- [ ] `_master-index.md` links to all four subfolder `_index.md` files
- [ ] Each content-type folder has its own `_index.md`
- [ ] `vault/CLAUDE.md` defines both Query and Update modes
- [ ] `vault/CLAUDE.md` states all four governance rules
- [ ] `vault/.claude/commands/kb-query.md` enforces the root→branch→leaf path and 5-read cap
- [ ] `vault/templates/` contains all four note templates
- [ ] Each note template includes `status:`, `last_updated:`, and `Related:` fields
