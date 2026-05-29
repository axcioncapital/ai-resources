# Risk Check — 2026-05-29

## Change

Remove `Bash(git push*)` from the deny list in `ai-resources/skills/obsidian-kb-builder/templates/scaffold/settings.json`. This is a SCAFFOLD TEMPLATE — applied to NEW vaults created by the obsidian-kb-builder skill. The current value contradicts the workspace zero-permission-prompts policy and operator memory `feedback_push_autonomous` ("Run git push immediately after commit"). Removing it from the scaffold prevents future vaults from inheriting the gate. Existing vaults already deployed from this scaffold are NOT affected by editing the template — they have their own copies. Scope: 1 line in a template file. Class: settings.json edit (template).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/obsidian-kb-builder/templates/scaffold/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md — exists

## Verdict

GO

**Summary:** Single-line deletion in a scaffold template that affects only future vault deploys; aligns the scaffold with workspace zero-permission-prompts policy; destructive denies (`rm -rf`, `sudo`) remain intact.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The file edited is a scaffold template under `templates/scaffold/`, copied by `/deploy-kb` at vault-creation time (`deploy-kb.md` line 76: "For each file in `{SKILL_TEMPLATES}scaffold/`, read the template, substitute all `{{...}}` placeholders, and write to the target path"). It is not loaded into any session context.
- No always-loaded file is touched. No CLAUDE.md, no SKILL.md, no auto-load hook, no `@import` chain affected.
- No subagent brief or system prompt modified.
- Change is pay-as-used (only consumed at `/deploy-kb` invocation), so ongoing token cost is unchanged.

### Dimension 2: Permissions Surface
**Risk:** Low

- The change *narrows* the deny list (removes one entry) and does not add any `allow` entry. Net effect on what is denied: `Bash(git push*)` becomes permitted in future-deployed vaults.
- Destructive shapes remain on the deny list: `Bash(rm -rf *)` and `Bash(sudo *)` (verbatim, scaffold/settings.json lines 17–18). The lethality envelope is preserved.
- `git push` is a non-destructive shape (reversible via further commits/revert; pushed history is not lost on the local machine). It is already authorized at the user and workspace layers by `Bash(*)` allow + `defaultMode: bypassPermissions` (permission-template.md Layer A line 31 and Layer B line 62) — the scaffold deny was the only layer reasserting a prompt against an established workspace-wide allow.
- Operator memory `feedback_push_autonomous` and `feedback_zero_permission_prompts` both contradict the current scaffold value (cited verbatim in CHANGE_DESCRIPTION).
- Scope of effect: future-deployed vaults only. Existing deployed vaults hold their own forked copies — untouched.

### Dimension 3: Blast Radius
**Risk:** Low

- Files directly touched: 1 (`templates/scaffold/settings.json`).
- Consumers of this template: 1 command — `/deploy-kb` (grep for `scaffold/settings.json` across ai-resources returns the template file itself as the only match; `deploy-kb.md` line 95 maps `settings.json` → `{VAULT_PATH}/.claude/settings.json`).
- Existing-vault impact: zero. `/deploy-kb` *copies* the template at vault creation; previously-deployed vaults do not re-read from the template. Confirmed in SKILL.md line 19: "`/deploy-kb` reads from this skill's bundled templates to create a new vault."
- References to the skill across ai-resources (grep `obsidian-kb-builder`): 16 hits, dominated by audit/log mentions; no caller depends on the deny shape of this template (`grep "git push" skills/obsidian-kb-builder/` returns 1 result — the line being removed).
- No contract changes (no subagent schema, no hook output shape, no slash-command syntax altered).

### Dimension 4: Reversibility
**Risk:** Low

- Change is a single-line deletion in a tracked file under git. `git revert` cleanly restores prior state.
- No data files, no append-only logs mutated. No external API writes. No state propagates beyond the local repo before push, and push of this edit itself is reversible by further commits.
- Vaults deployed during the window between this edit and a hypothetical revert would carry the new (deny-less) shape. Those forked copies are not auto-reconciled by reverting the template — but this is exactly the intended boundary stated in CHANGE_DESCRIPTION ("Existing vaults already deployed from this scaffold are NOT affected by editing the template"). The asymmetry is the design, not a leak.
- No hook / cron / symlink automation registered by this edit.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The scaffold template is a documented, single-purpose artifact named in `skills/obsidian-kb-builder/SKILL.md` (lines 84–100) and consumed at one explicit call site in `/deploy-kb` Step 6. No silent auto-fire context.
- No new contract created. The shape of the deployed `settings.json` is unchanged structurally (same JSON keys, same allow list) — only the count of deny entries decreases by one.
- No overlap with other deny-managing mechanisms. The canonical permission-template.md does not define a project-layer deny for `Bash(git push*)` (Layer D `deny` is `Bash(rm -rf *)`, `Bash(sudo *)`, plus Read-deny archival patterns — permission-template.md lines 172–175). The scaffold's `Bash(git push*)` deny was an outlier specific to this skill, not a workspace convention.
- No implicit dependency on filename-sort order, downstream marker, or undocumented sibling artifact.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: scaffold/settings.json lines 16–18 (current deny list), permission-template.md Layer A/B/D (workspace policy and project-layer canonical denies), deploy-kb.md lines 76 and 95 (template consumption site), SKILL.md lines 19 and 84–100 (scaffold template scope), and grep counts across `ai-resources/` for `obsidian-kb-builder` (16 hits, no caller depends on the deny shape) and `git push` inside the skill (1 hit — the line being removed). Operator memory citations (`feedback_push_autonomous`, `feedback_zero_permission_prompts`) taken from CHANGE_DESCRIPTION verbatim. No training-data fallback used.
