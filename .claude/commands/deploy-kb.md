---
model: sonnet
---

# /deploy-kb — Deploy an Obsidian Knowledge Base Vault

Scaffolds a new Claude Code-queryable Obsidian KB vault for any project. Reads templates from `skills/obsidian-kb-builder/templates/` and deploys them with operator-provided values.

**Arguments:** `$ARGUMENTS` — optional project name in kebab-case. If omitted, you will be asked.

---

## Step 1: Detect paths

Identify two paths:

- `AI_RESOURCES` — the `ai-resources/` directory. This command lives at `{AI_RESOURCES}/.claude/commands/deploy-kb.md` — derive `AI_RESOURCES` as the grandparent of this file's directory.
- `WORKSPACE_ROOT` — parent of `AI_RESOURCES` (the directory containing `ai-resources/`, `projects/`, `knowledge-bases/`, etc.).

Set `SKILL_TEMPLATES` to `{AI_RESOURCES}/skills/obsidian-kb-builder/templates/`.

Verify `{SKILL_TEMPLATES}scaffold/` and `{SKILL_TEMPLATES}note-templates/` exist. If either is missing, stop and report: "obsidian-kb-builder skill templates not found — run `/create-skill obsidian-kb-builder` first."

## Step 2: Collect inputs

Ask the operator three questions (present all at once so they can answer in one message):

1. **Project name** — kebab-case folder name (e.g., `global-macro-analysis`). Or use `$ARGUMENTS` if already provided and valid. Validate against pattern `^[a-z0-9-]+$` — reject names with uppercase, spaces, or special characters.
2. **Vault location:**
   - **[A] Inside project** — `{WORKSPACE_ROOT}/projects/{project-name}/vault/`
   - **[B] Standalone** — `{WORKSPACE_ROOT}/knowledge-bases/{project-name}/` (useful when the KB will grow beyond one project)
3. **KB display name** — human-readable title used in the vault's CLAUDE.md and master index (e.g., "Global Macro Analysis").

Do not proceed until all three are provided.

## Step 3: Resolve target path

Compute `VAULT_PATH` from the operator's choice:
- Option A: `{WORKSPACE_ROOT}/projects/{project-name}/vault`
- Option B: `{WORKSPACE_ROOT}/knowledge-bases/{project-name}`

Set placeholder values:
- `KB_NAME` = operator's KB display name
- `PROJECT_NAME` = project folder name (option A) or same as `KB_NAME` (option B)
- `DATE` = today's date in YYYY-MM-DD format

## Step 4: Existence check

Check whether `{VAULT_PATH}` already exists:

```bash
[ -d "{VAULT_PATH}" ] && echo "EXISTS" || echo "CLEAR"
```

If output is `EXISTS`: **Stop.** Report: "Vault already exists at `{VAULT_PATH}`. Delete or rename it before re-running `/deploy-kb`." Do not proceed.

If output is `CLEAR`: continue to Step 5.

## Step 5: Scaffold folder structure

Create all vault subdirectories:

```bash
mkdir -p "{VAULT_PATH}/.obsidian"
mkdir -p "{VAULT_PATH}/.claude/commands"
mkdir -p "{VAULT_PATH}/research"
mkdir -p "{VAULT_PATH}/architecture"
mkdir -p "{VAULT_PATH}/decisions"
mkdir -p "{VAULT_PATH}/findings"
mkdir -p "{VAULT_PATH}/templates"
mkdir -p "{VAULT_PATH}/inbox"
```

Note: `templates/` and `inbox/` are intentionally indexless — they are not content folders and do not receive `_index.md` files. Only the four content-type folders (research, architecture, decisions, findings) get branch indexes.

## Step 6: Deploy scaffold files

For each file in `{SKILL_TEMPLATES}scaffold/`, read the template, substitute all `{{...}}` placeholders, and write to the target path.

Placeholder substitution rules:
- `{{KB_NAME}}` → KB display name
- `{{PROJECT_NAME}}` → project folder name
- `{{DATE}}` → today's date YYYY-MM-DD
- `{{VAULT_PATH}}` → full resolved vault path

Deploy each file:

| Template | Target path |
|---|---|
| `vault-claude-md.md` | `{VAULT_PATH}/CLAUDE.md` |
| `_master-index.md` | `{VAULT_PATH}/_master-index.md` |
| `kb-query.md` | `{VAULT_PATH}/.claude/commands/kb-query.md` |
| `kb-update.md` | `{VAULT_PATH}/.claude/commands/kb-update.md` |
| `kb-integrity.md` | `{VAULT_PATH}/.claude/commands/kb-integrity.md` |
| `settings.json` | `{VAULT_PATH}/.claude/settings.json` |
| `obsidian-app.json` | `{VAULT_PATH}/.obsidian/app.json` |
| `obsidian-workspace.json` | `{VAULT_PATH}/.obsidian/workspace.json` |
| `obsidian-appearance.json` | `{VAULT_PATH}/.obsidian/appearance.json` |
| `obsidian-core-plugins.json` | `{VAULT_PATH}/.obsidian/core-plugins.json` |

Deploy `subfolder-index.md` four times — once per content-type folder. For each deployment, additionally substitute:
- `{{FOLDER_NAME}}` → folder name (research, architecture, decisions, findings)
- `{{FOLDER_TITLE}}` → title-case label (Research, Architecture, Decisions, Findings)

| Deployment | Target path |
|---|---|
| FOLDER_NAME=research, FOLDER_TITLE=Research | `{VAULT_PATH}/research/_index.md` |
| FOLDER_NAME=architecture, FOLDER_TITLE=Architecture | `{VAULT_PATH}/architecture/_index.md` |
| FOLDER_NAME=decisions, FOLDER_TITLE=Decisions | `{VAULT_PATH}/decisions/_index.md` |
| FOLDER_NAME=findings, FOLDER_TITLE=Findings | `{VAULT_PATH}/findings/_index.md` |

## Step 7: Deploy note templates

Read each file from `{SKILL_TEMPLATES}note-templates/` and write to `{VAULT_PATH}/templates/`. Apply `{{KB_NAME}}` substitution. No other placeholders are used in note templates.

| Template | Target path |
|---|---|
| `research-note.md` | `{VAULT_PATH}/templates/research-note.md` |
| `decision-note.md` | `{VAULT_PATH}/templates/decision-note.md` |
| `architecture-note.md` | `{VAULT_PATH}/templates/architecture-note.md` |
| `finding-note.md` | `{VAULT_PATH}/templates/finding-note.md` |

## Step 8: Verify placeholder resolution

Scan all deployed `.md` and `.json` files for remaining `{{...}}` tokens:

```bash
grep -r '{{' "{VAULT_PATH}/" --include="*.md" --include="*.json" || true
```

No output means all tokens are resolved — proceed to Step 9. If any `{{...}}` tokens appear in the output, report them and ask the operator for the missing values before continuing.

## Step 9: Git init (option B only)

If the operator chose option B (standalone vault):

Ask: **"Initialize a git repo in this vault? [y/n]"**

If yes, run:
```bash
cd "{VAULT_PATH}"
git init
cat > .gitignore << 'EOF'
.obsidian/workspace.json
.DS_Store
EOF
git add -A
```

Then commit with the resolved KB display name (substitute the actual value — do not pass `{{KB_NAME}}` literally):
```
git commit -m "init: {RESOLVED_KB_NAME} KB vault"
```
where `{RESOLVED_KB_NAME}` is the display name the operator provided (e.g., `"Global Macro Analysis"`).

If no, skip.

## Step 10: Report

List all files created and confirm the vault is ready:

```
Vault deployed at: {VAULT_PATH}

Files created:
  CLAUDE.md
  _master-index.md
  .obsidian/ (app.json, workspace.json, appearance.json, core-plugins.json)
  .claude/ (settings.json, kb-query.md, kb-update.md, kb-integrity.md)
  research/_index.md
  architecture/_index.md
  decisions/_index.md
  findings/_index.md
  inbox/
  templates/ (research-note.md, decision-note.md, architecture-note.md, finding-note.md)

Next steps:
  1. Open {VAULT_PATH} as an Obsidian vault to confirm the graph loads.
  2. Open {VAULT_PATH} in Claude Code to query and update notes via /kb-query and /kb-update.
  3. Drop new content in inbox/ and use /kb-update to file it into the appropriate folder.
```
