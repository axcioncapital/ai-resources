# Risk Check — 2026-05-22

## Change

Add two entries — "Bash(rm *)" and "NotebookEdit" — to the `permissions.allow` array of two project settings.json files: `projects/ai-development-lab/.claude/settings.json` and `projects/axcion-brand-book/.claude/settings.json`. Both files already declare `defaultMode: bypassPermissions` and already include `Bash(*)`, bare `Edit`, bare `Write`, `MultiEdit`. This executes items 1, 2, and the realizable (NotebookEdit) part of item 4 of the 2026-05-22 friday-act permissions plan. Change class: settings.json permission changes (Autonomy Rule #8). `/permission-sweep` (2026-05-22) confirmed the two `Bash(rm *)` additions as HIGH findings (Rule 6 — no narrow-rm allow) and the two `NotebookEdit` additions as advisory (Rule 13 — missing canonical allow entry). Plan item 3 (remove a `model` field from `~/.claude/settings.json`) is dropped — no `model` field exists there. The two `Edit(**/.claude/**)` / `Write(**/.claude/**)` globs from plan item 4 are dropped as redundant (permission-sweep Rules 3 & 4 did not fire — bare `Edit`/`Write` already cover all paths). Application method: idempotent jq merge (`allow` array, then `unique`). Net effect: each of the two project settings.json files gains exactly two allow entries; nothing is removed; deny lists, defaultMode, hooks, and additionalDirectories are untouched.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/.claude/settings.json — exists
- /Users/patrik.lindeberg/.claude/settings.json — exists (referenced only — NOT modified by this change)

## Verdict

GO

**Summary:** A two-entry, idempotent, additive permission edit that brings two project settings files into alignment with the canonical Layer D template; no contract change, clean revert, and the only widened capability (`rm` without `-rf`) is already bounded by the unchanged `Bash(rm -rf *)` deny.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The change touches `settings.json` files, which are configuration — not always-loaded prompt content. `settings.json` is not a CLAUDE.md and is not `@import`-ed into any turn; it adds zero ongoing token cost to future sessions.
- No hook is registered or modified. The change description states "deny lists, defaultMode, hooks, and additionalDirectories are untouched"; the current files show two unchanged SessionStart hook blocks (ai-development-lab lines 31–53; axcion-brand-book lines 33–55).
- No subagent brief, skill, or system prompt is expanded.
- Net effect is two short string entries per `allow` array — pay-as-used config, not per-turn cost.

### Dimension 2: Permissions Surface
**Risk:** Medium

- The change widens the permission surface by two entries per file. `Bash(rm *)` grants `rm` invocations that the files do not currently authorize via a narrow rule — evidence: ai-development-lab `allow` (lines 4–19) and axcion-brand-book `allow` (lines 4–19) contain no `rm` entry.
- However, `Bash(*)` is already present in both `allow` lists (line 5 in each file), and both files already declare `defaultMode: bypassPermissions` (line 3 in each). Under `bypassPermissions` with `Bash(*)` allowed, `rm` already executes without a prompt today — the `Bash(rm *)` entry does not grant a *new runtime capability*; it suppresses the residual Delete/Remove permission prompt that fires independently of `Bash(*)` (this is exactly the Rule 6 failure mode in `docs/permission-template.md` lines 316–317: "No `Bash(rm *)` in allow (Delete/Remove failure mode, separate from Edit)").
- The destructive form remains denied: `Bash(rm -rf *)` is present in both files' `deny` lists (ai-development-lab line 22; axcion-brand-book line 22) and is explicitly untouched by this change. The widening is therefore bounded — recursive-force deletes still hit the deny rule.
- `NotebookEdit` is a narrow, non-shell tool grant for editing Jupyter notebooks; it introduces no shell, no cross-repo write, and no external API capability.
- Both additions move the files *toward* the canonical Layer D template, which lists `NotebookEdit` and `Bash(rm *)` verbatim (`docs/permission-template.md` lines 168–170). This is template-alignment, not novel surface expansion. Risk is Medium only because `rm` is a destructive verb; the bounded deny and prior `Bash(*)` coverage keep it from being High.

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly: 2 (`projects/ai-development-lab/.claude/settings.json`, `projects/axcion-brand-book/.claude/settings.json`). No third file is modified — `~/.claude/settings.json` is referenced only and confirmed unchanged.
- Enumeration of dependents — grep across `{AI_RESOURCES}` for `ai-development-lab` / `axcion-brand-book`: 16 files matched (`audits/friday-checkup-2026-05-22.md`, `audits/repo-due-diligence-2026-05-19-project-ai-development-lab.md`, `audits/permission-sweep-2026-05-22.md`, `audits/permission-sweep-2026-05-19.md`, `audits/repo-dd-deep-2026-05-19-project-ai-development-lab.md`, four `audits/risk-checks/*.md`, `audits/friday-plans/2026-05-22-permissions.md`, `docs/agent-tier-table.md`, `logs/session-notes.md`, `logs/session-notes-archive-2026-05.md`, `logs/maintenance-observations.md`, `reports/graduate-resource-candidates-2026-05-22.md`). All matches are audit/log/report prose that *names* the projects — none reads or parses the `permissions.allow` array of these settings files as a contract. No command, skill, agent, or hook consumes the contents of these `allow` arrays.
- `/permission-sweep` and `/new-project` reference the canonical template in `docs/permission-template.md`, not these specific files; the change brings the files closer to that template, so it reduces (does not create) future sweep findings.
- No contract change: the `settings.json` schema is fixed by Claude Code; adding entries to an existing `allow` array honors the schema. Slash-command syntax, frontmatter, hook output shape, and subagent input schemas are all untouched.
- Zero callers require modification to keep working. Single-class, two-file, additive edit.

### Dimension 4: Reversibility
**Risk:** Low

- Both target files are tracked in git (they sit under `projects/*/.claude/`, and `settings.json` — unlike `settings.local.json` — is not gitignored by Claude Code convention; `docs/permission-template.md` line 329 notes the gitignore convention applies to `settings.local.json`, not `settings.json`).
- The change is a two-line addition to an `allow` array in each file. `git revert` of the commit fully restores the prior `allow` arrays in the same working tree — no sibling files, directories, or generated artifacts are created.
- No log/registry mutation: the change does not append to `innovation-registry.md`, `improvement-log.md`, or `session-notes.md` as part of the edit itself (any wrap-session logging is a separate, later step outside this change's scope).
- No state propagates beyond the local repo: no `git push`, no Notion write, no external API call is part of this change.
- No automation is added that could fire between landing and revert — no hook, cron, or symlink is created.
- The application method (idempotent jq merge with `unique`) means a re-run is a no-op and a revert is a clean single-commit undo.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The change is self-contained: each added entry is an independent allow rule with no dependency on another component's presence or behavior.
- No new contract is introduced — no parse marker, filename convention, YAML key, or output format. `allow`-array entries are consumed only by the Claude Code permission engine, whose schema is external and stable.
- No auto-firing: `settings.json` is read at session start by the harness; the change does not add or alter a hook, so it introduces no new ordering dependency or silent state mutation. The two existing SessionStart hooks are unchanged and unrelated to the `allow` array.
- The change does not silently rely on a mutable repo convention. It does depend on the canonical Layer D template in `docs/permission-template.md` (lines 161–182) — but that dependency is explicit, documented, and the change *converges toward* the template rather than diverging from it. The `check-permission-sanity.sh` SessionStart hook and `/permission-sweep` both reference that same template, so the three mechanisms agree rather than overlap-conflict.
- No functional overlap: no second mechanism also tries to manage these `allow` entries. `/permission-sweep` *detects* the gap (Rule 6 / Rule 13) and this change *closes* it — that is the intended division of labor, not a collision.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
