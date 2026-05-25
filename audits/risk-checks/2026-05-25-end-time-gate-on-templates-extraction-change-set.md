# Risk Check — 2026-05-25

## Change

End-time gate on the executed change set for Item 8 Sequencing Session 2 (templates extraction). Plan-time verdict was PROCEED-WITH-CAUTION; all 4 mitigations applied; one QC-driven scope addition that warrants verification.

Executed change set (12 files):

CREATED (7):
- ai-resources/templates/README.md — consumer contract + 2026-04-13 KEEP verdict
- ai-resources/templates/project-settings.json.template — valid JSON; canonical permissions + 2 SessionStart hooks
- ai-resources/templates/project-claude-md/header.md — uses {{NAME}} and {{PROJECT_DESCRIPTION}} mustache placeholders (CHANGED FROM PLAN — was {name}/{project-description}; see QC-fix below)
- ai-resources/templates/project-claude-md/input-file-handling.md — canonical fragment
- ai-resources/templates/project-claude-md/commit-rules.md — canonical fragment
- ai-resources/templates/project-claude-md/compaction.md — canonical fragment
- ai-resources/templates/project-claude-md/session-boundaries.md — canonical fragment

MODIFIED (5):
- ai-resources/.claude/commands/new-project.md — step 2 settings merge reads template via walk-up + jq -c (mitigation #2 applied); step 4 CLAUDE.md sections uses python3 substitution + cat-appends (CHANGED FROM PLAN — original plan used bash native ${VAR//pattern/repl}; QC review found that approach unsafe under (a) apostrophe/ampersand/backslash in project description and (b) calling agent's global {name} substitution corrupting the bash search pattern). Stale "heredoc" comment in Policy block also updated.
- ai-resources/docs/permission-template.md — lines 157 + 349 redirected to templates/project-settings.json.template (mitigation #1 applied)
- ai-resources/docs/repo-architecture.md — tree row + canonical-homes row + Q8 sub-bullet added (mitigation #4 applied, system-owner request)
- ai-resources/workflows/research-workflow/CLAUDE.md — added "Operator-pasted content" bullet (Input File Handling); added "Post-compact resumption" paragraph (Compaction); `## File Verification and Git Commits` preserved verbatim per mitigation #3
- ai-resources/CLAUDE.md — one-line pointer to templates/ added under "Other directories"

NOT MODIFIED (intentional narrowing): ai-resources/workflows/research-workflow/.claude/settings.json — settings has workflow-specific hooks + intentional {{WORKSPACE_ROOT}} placeholder; no canonical drift to fix; alignment ≠ enhancement.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/README.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/project-settings.json.template — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/project-claude-md/header.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/project-claude-md/input-file-handling.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/project-claude-md/commit-rules.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/project-claude-md/compaction.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/project-claude-md/session-boundaries.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-project.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/settings.json — exists (NOT modified)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-05-25-extract-canonical-project-settings-claude-md-into-templates.md — exists (plan-time report)

## Verdict

GO

**Summary:** End-time review confirms all 4 plan-time mitigations applied verbatim in file contents, the python3/mustache QC-swap reduces risk versus the bash-native plan (does not introduce new structural risk), and the research-workflow settings.json narrowing is correctly bounded — no scope drift detected.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- `ai-resources/CLAUDE.md` always-loaded footprint increased by exactly one bullet line. Evidence: `ai-resources/CLAUDE.md:15` — "`templates/` — Canonical deployable fragments consumed at scaffold time (project settings + project CLAUDE.md sections); edit the fragment, not the consuming command. See `templates/README.md` for the consumer contract." ≈ 35 tokens. Net per-session always-loaded delta is ~1 line.
- No new auto-load hooks. The two `SessionStart` hooks inside `templates/project-settings.json.template` are byte-identical to the inline pair previously in `new-project.md` (lines 296–311 in plan-time view) and ship only to deployed projects at scaffold time — not into ai-resources sessions. Evidence: `templates/project-settings.json.template:33–55` matches `permission-template.md:258–280` verbatim.
- `/new-project` body net per-invocation cost is unchanged or slightly negative — sonnet-tier (`new-project.md:2` frontmatter), reads 6 small template files (combined ~3.8 KB) instead of carrying ~225 lines of inline JSON literal + heredocs.
- No new `@import` chains; no new skill descriptions added; no new agent briefs to spawn.
- Per-invocation: the python3 step adds one tiny inline script (~3 lines) — runs once per fresh-project scaffold, not in any always-on path. Cost impact zero.

### Dimension 2: Permissions Surface
**Risk:** Low

- The settings template emitted to new projects is shape-identical to the inline `CANONICAL_PERMS` block previously embedded in `new-project.md`. Confirmed by diff between `templates/project-settings.json.template:2–32` and `permission-template.md` Layer D canonical shape at `:161–182`: same 16-entry allow list, same 7-entry deny list, same `defaultMode: "bypassPermissions"`.
- Template validates as parseable JSON (verified via `python3 -c "json.load(...)"`). No structural drift introduced by extraction.
- No `deny` rules removed; no scope-escalation (project → user); no new tool families granted.
- No permission changes inside ai-resources itself — none of the modified files are `.claude/settings.json`.
- The research-workflow `settings.json` non-modification preserves the intentional `{{WORKSPACE_ROOT}}` placeholder (evidence: `workflows/research-workflow/.claude/settings.json:34`) and the workflow-specific hooks (PreToolUse Skill, Edit bright-line, PostToolUse Write auto-commit/log/innovation, Stop checkpoint/wrap, UserPromptSubmit) — all untouched. The `permission-sweep` template-class silencer at `permission-template.md:248` documents this file as a known template exception.

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly: 12 (7 new templates + 5 modifications). Verified against CHANGE_DESCRIPTION enumeration; spot-checked filesystem (`ls templates/` shows 5 fragment files + README.md + project-settings.json.template — all present).
- `/new-project` callers and references (grep `grep -rn "new-project" docs/ .claude/commands/`): **26 hits** across docs and commands; none invoke `/new-project` programmatically — all are documentation references. No caller binds to the prior inline `CANONICAL_PERMS` symbol name or inline heredoc shape.
- `CANONICAL_PERMS` lingering references (grep `grep -rn "CANONICAL_PERMS" docs/ .claude/commands/`): **3 hits** — `new-project.md:342` and `:346` are now intentional (the local jq variable name inside step 2's merge — uses extracted template), and `deploy-workflow.md:209` is a separate inline literal in a different command's wiring. The plan-time `permission-template.md:157, :349` references to "update `CANONICAL_PERMS` literal in `new-project.md`" are gone — confirmed by reading `permission-template.md:157` and `:349`, which now both name `templates/project-settings.json.template`. Mitigation #1 verified.
- Contract preservation: predicate "already has non-empty `permissions.allow`" still gates the merge at `new-project.md:347` (`if (.permissions.allow // []) | length > 0 then . else .permissions = $perms end`). Per-section grep idempotency still gates CLAUDE.md appends at `new-project.md:471` (`if grep -q "^${HEADING}" "$CLAUDE_MD"`). Both behavioral contracts preserved verbatim.
- Architecture map update (mitigation #4): `repo-architecture.md:68` (tree), `:110` (canonical-homes table row), `:226` (Q8 sub-bullet) all landed and are factually consistent with the templates that now exist on disk. Verified by reading each line.
- `deploy-workflow.md:209` still carries its own inline `CANONICAL_PERMS` literal. Not in scope for this change set (Sequencing Session 2 narrowed to `/new-project`); not a regression of this change. Note as follow-on candidate if a future session sets out to unify all consumers on the template.

### Dimension 4: Reversibility
**Risk:** Low

- New `templates/` tree (7 files) — `git revert` removes them cleanly. The directory is currently a leaf under `ai-resources/` with no symlinks pointing in.
- `/new-project` rewire — single-file edit to `.claude/commands/new-project.md` — revert restores prior inline literals.
- `permission-template.md` two line edits at `:157` and `:349` — revert restores the prior `CANONICAL_PERMS literal in new-project.md` instruction text.
- `repo-architecture.md` three line edits (`:68, :110, :226`) — revert removes them; no derived state.
- `ai-resources/CLAUDE.md` one-line pointer at `:15` — single-line revert.
- `workflows/research-workflow/CLAUDE.md` two paragraph additions (Operator-pasted content bullet at `:99`; Post-compact resumption paragraph at `:127`) — revert removes them; no derived state.
- No `git push` performed inside the change set (verified: CHANGE_DESCRIPTION does not name a push; workspace policy requires operator approval for push). No external API writes; no Notion writes; no symlinks created.
- One mild edge: if `/new-project` is invoked between landing and a hypothetical revert, the deployed project will already have received the (byte-equivalent) settings + CLAUDE.md output — no operator-visible drift because template content matches the prior inline content.

### Dimension 5: Hidden Coupling
**Risk:** Low

- **Path resolution explicit and load-bearing.** Walk-up-to-`ai-resources/` idiom present in both consumer sites: step 2 (`new-project.md:330–337`) and step 4 (`new-project.md:413–420`). Both use the identical pattern (`while [ "$d" != "/" ]; do d=$(dirname "$d"); [ -d "$d/ai-resources" ] && AI_RES="$d/ai-resources" && break; done`), matching the canonical idiom at `new-project.md:48–55` (planning workspace walk) and `:378–384` (additionalDirectories walk). The accompanying load-bearing comment at `new-project.md:321` ("this is load-bearing — a relative path would hard-fail on any invocation from outside `ai-resources/`...") makes the constraint self-documenting. Mitigation #2 verified.
- **Documented update-protocol redirection present.** Both `permission-template.md:157` ("Emitted by `/new-project` Post-Pipeline Enrichment step 2 — read from `ai-resources/templates/project-settings.json.template`") and `:349` ("Update `ai-resources/templates/project-settings.json.template` — `/new-project` reads its `permissions` block and `hooks.SessionStart` entries from there…The literals no longer live inline in `new-project.md`; they are extracted via `jq -c` at deploy time.") are rewritten to point at the template. Mitigation #1 verified.
- **Read-only template contract is documented at the change site** (`templates/README.md:22` — "Templates are read-only"). Correct location for the new contract.
- **Placeholder namespace separation (QC-fix) is sound and reduces risk vs the plan.** `header.md` uses `{{NAME}}` and `{{PROJECT_DESCRIPTION}}` (verified by reading `header.md:1, :3` — file is 4 lines total, mustache-style placeholders only). The python3 step at `new-project.md:445–449` passes `PROJECT_NAME` and `PROJECT_DESCRIPTION` as `sys.argv[2]` and `sys.argv[3]` to a `str.replace` call against `sys.argv[1]` (header.md content). Argv passing avoids all shell-quoting hazards (apostrophe, ampersand, backslash, dollar sign all safe), and the mustache `{{...}}` syntax is intentionally distinct from the agent's single-brace `{name}` / `{project-description}` global-substitution tokens — agent global-text-substitution over this bash source cannot corrupt the python search strings or the template content. Two namespaces, no collision. This is genuinely safer than the originally-planned bash-native `${VAR//pattern/repl}` (which would have broken on apostrophes via the bash expansion and on the agent's text-pass via single-brace collision). The substitution-mechanics comment at `new-project.md:430–442` self-documents this for future editors.
- **python3 dependency on macOS:** python3 is bundled with macOS and is already an implicit dependency of other ai-resources tooling. The new-project.md comment at `:437–439` names this and lists awk-with-`-v` as a fallback alternative; sed is explicitly called out as unsafe (`&` in PROJECT_DESCRIPTION expands to the match). Dependency risk: Low — python3 is universally present on the operator's machine and reflected in every active session.
- **Research-workflow `## File Verification and Git Commits` preserved verbatim** at `workflows/research-workflow/CLAUDE.md:104–108`. Mitigation #3 verified.
- **Research-workflow settings.json narrowing is acceptable scope bounding.** The file contains workflow-specific hooks (PreToolUse Skill, Edit bright-line block, PostToolUse Write auto-commit + log + innovation, SessionStart checkpoint + template-drift + auto-sync + check-archive, Stop checkpoint + wrap, UserPromptSubmit decision log) plus the intentional `{{WORKSPACE_ROOT}}` placeholder. None of these are canonical drift to be reconciled against the project-deploy template — the file is template-class with documented exception status at `permission-template.md:248`. The decision to skip alignment is consistent with the plan-time mitigation #3 spirit ("preserve … as workflow-local") and CHANGE_DESCRIPTION's "alignment ≠ enhancement" framing. No hidden coupling introduced.
- **Architecture map (mitigation #4) is consistent with what landed.** `repo-architecture.md:68` describes `templates/` exactly as it exists on disk; `:110` describes the canonical-fragment artifact type matching the new files' role; `:226` Q8 sub-bullet routes future similar additions to the same location. No drift between the map and the actual filesystem state.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: line-anchored reads of the 12 changed files plus repo CLAUDE.md and workspace CLAUDE.md; grep enumerations for `CANONICAL_PERMS` (3 hits — explained), `new-project` references (26 hits — all documentation), and `templates/` references (verified in docs/, .claude/commands/, and ai-resources/CLAUDE.md); python3 JSON-validate of the settings template; ls of `templates/` and `templates/project-claude-md/` to confirm presence of all 7 new files. No training-data fallback was used.
