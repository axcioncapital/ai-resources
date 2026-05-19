# Risk Check — 2026-05-19

## Change

Permission sweep remediations applied across 3 settings files: (1) ai-resources/.claude/settings.local.json — permissions block removed entirely (had stale one-time Bash allow entries and no defaultMode); (2) .claude/settings.json (workspace root) — Bash(git push*) moved from allow[] to deny[]; canonical deny floor added ["Bash(rm -rf *)", "Bash(sudo *)", "Bash(git reset --hard *)", "Bash(git checkout *)", "Bash(git push*)"]; (3) ~/.claude/settings.json (user-level) — deny floor ["Bash(rm -rf *)", "Bash(sudo *)"] added to previously-empty deny list.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.local.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.json — exists
- /Users/patrik.lindeberg/.claude/settings.json — exists

## Verdict

GO

**Summary:** Three remediations that tighten the deny floor (no allow widening) and align all three layers with the canonical templates in `docs/permission-template.md`; reversible by `git revert` for the two tracked files, and the user-level file change is a two-element deny addition that is trivially reversible.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No content added to any always-loaded file (workspace CLAUDE.md, ai-resources CLAUDE.md, or project CLAUDE.md). All three changes are in `settings.json` / `settings.local.json` — not @import'd into session context. Evidence: workspace `CLAUDE.md` reviewed in full (165 lines), contains no `@import settings.json`; same for `ai-resources/CLAUDE.md` (91 lines).
- No new hook registered. The `hooks` blocks in workspace and ai-resources settings are untouched per the CHANGE_DESCRIPTION scope (permissions block only). Confirmed by reading both settings files — hook blocks present (workspace lines 52–99, ai-resources lines 39–133) but not part of this change.
- No new skill, command, or agent introduced. Pure configuration change.

### Dimension 2: Permissions Surface
**Risk:** Low

- All three changes either narrow the surface or remove stale entries — no allow widening anywhere. Evidence per file:
  - ai-resources `settings.local.json` (read post-change): contents are `{}` (line 1). Removing a `settings.local.json` permissions block defers to the sibling `ai-resources/.claude/settings.json` (already canonical with `defaultMode: bypassPermissions` at line 34). Per `docs/permission-template.md` Layer B′ / D′ (line 108): *"If the local file has no `permissions` block, the sibling `settings.json` applies unmodified. This is the cleanest form…"* — the change matches the canonical "cleanest form".
  - Workspace root `settings.json` (read post-change): `Bash(git push*)` appears only in `deny` (line 32), not in `allow` (lines 3–25). Deny list (lines 27–33) now contains the canonical floor matching `permission-template.md` Layer B (lines 73–75 of the template) — plus `Bash(git push*)` which the template assigns to Layer C but is harmless on the root.
  - User-level `~/.claude/settings.json`: not directly readable in this evaluation pass, but the CHANGE_DESCRIPTION states deny floor added to a previously-empty deny list. The added entries (`Bash(rm -rf *)`, `Bash(sudo *)`) match `permission-template.md` Layer A canonical shape (lines 38–40 of the template).
- No deny rule is removed or narrowed. The `Bash(git push*)` move is allow → deny (strictly more restrictive).
- No new tool family or external API capability introduced. No scope escalation (project → user); the user-level change is additive deny only.

### Dimension 3: Blast Radius
**Risk:** Low

- Three files touched; all are configuration leaves with no callers that import their content directly. Settings files are consumed only by the Claude Code harness, not by skills/commands/agents at runtime.
- `Bash(git push*)` deny pattern is widely established across the repo, so the new deny in workspace root + ai-resources is consistent with existing convention. Grep evidence: 4 project `settings.json` files already deny `Bash(git push*)` (`projects/buy-side-service-plan/`, `projects/personal/travel-os/`, `projects/nordic-pe-macro-landscape-H1-2026/`, `projects/project-planning/.claude/settings.json`); 2 ai-resources commands (`new-project.md`, `deploy-workflow.md`) emit `Bash(git push*)` in their CANONICAL_PERMS templates (`new-project.md:264`, `deploy-workflow.md:187`). No caller relies on `git push` being allow-listed.
- Operator-side impact: `git push` is already an Autonomy Rules #2 manual operator step per workspace `CLAUDE.md` (line 152: *"Push requires operator approval"*) and `ai-resources/CLAUDE.md` Git Rules (line 67: *"Never push without my explicit approval"*). The new deny matches established workflow — the operator already runs push outside Claude's tool surface.
- No contract change (no subagent schema, hook output shape, frontmatter schema, or slash-command syntax affected).
- Shared infra (`detect-innovation.sh`, `auto-sync-shared.sh`, `check-permission-sanity.sh`, etc.) is untouched.

### Dimension 4: Reversibility
**Risk:** Low

- Workspace root `settings.json` and ai-resources `settings.local.json` are tracked in git — `git revert` of the commit restores the prior shape cleanly. Single-file edits, no sibling files generated.
- User-level `~/.claude/settings.json` is outside the repo (not git-tracked from the workspace), so revert is a manual two-line removal of `Bash(rm -rf *)` and `Bash(sudo *)` from the deny list. Trivial cleanup; both entries are explicit strings to delete.
- No state propagated beyond the local repo. No push, no Notion write, no external API call resulting from this change.
- No automation could fire between the change and a potential revert. The PostToolUse / Stop / SessionStart hooks present in the workspace and ai-resources settings are unchanged.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The three changes implement shapes that are **explicitly documented** in `ai-resources/docs/permission-template.md` (Layer A lines 38–40, Layer B lines 73–75, Layer B′ lines 108–109). Coupling is to a named, documented contract — not implicit.
- `check-permission-sanity.sh` (SessionStart hook in `ai-resources/.claude/hooks/`) consumes these shapes. After the change, ai-resources `settings.local.json` is `{}` and Layer B′ rule allows omitting `permissions` (template line 108); the sanity hook's drift detection is satisfied. No implicit dependency on a non-template shape.
- No new contract introduced by the change itself (no parse marker, filename convention, YAML key, or output format added).
- No silent overlap with existing mechanisms. The deny entries (`Bash(rm -rf *)`, `Bash(sudo *)`, `Bash(git reset --hard *)`, `Bash(git checkout *)`, `Bash(git push*)`) are the canonical deny floor; there is no second mechanism in the repo enforcing the same surface that could conflict (e.g., no pre-tool hook also blocks `git push`).
- Minor observation (not a coupling risk, surfaced as advisory): the workspace-root deny list now contains `Bash(git push*)` (line 32), which `permission-template.md` Layer B (lines 73–75) does not list explicitly — Layer B's canonical floor is `Bash(rm -rf *)`, `Bash(sudo *)`, `Bash(git reset --hard *)`, `Bash(git checkout *)` only. The extra `Bash(git push*)` is consistent with Layer C and Layer D shapes and matches the operator's intent (push requires explicit approval per Autonomy Rules #2), so it is not a drift finding — but if `/permission-sweep` runs strict-template diff, it may report this as "Layer B has an extra deny vs template". Operator may want to either accept the extra entry as a workspace-root tightening, or amend the template to add `Bash(git push*)` to Layer B explicitly. Either resolution is safe.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: post-change reads of `ai-resources/.claude/settings.local.json` (line 1 = `{}`), `.claude/settings.json` (workspace root, full file read, 38 lines), and `ai-resources/.claude/settings.json` (Layer C reference, 134 lines); cross-referenced against `ai-resources/docs/permission-template.md` Layer A/B/B′/C/D canonical shapes; grep counts for `Bash(git push*)` deny usage (4 project files + 2 command-emitter files); verbatim quote from `permission-template.md` line 108 on Layer B′ omit-permissions rule; verbatim quotes from workspace `CLAUDE.md` line 152 and `ai-resources/CLAUDE.md` line 67 on push-approval discipline. No training-data fallback was used.
