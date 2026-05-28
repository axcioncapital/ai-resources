# Risk Check — 2026-05-28

## Change

FX-E1 — Graduate `backup-session-plan.sh` to canonical hooks.

**Proposal (minimal scope):**
1. Copy `projects/nordic-pe-macro-landscape-H1-2026/.claude/hooks/backup-session-plan.sh` to `ai-resources/.claude/hooks/backup-session-plan.sh` (byte-identical lift; the hook is a PreToolUse Write handler that backs up `logs/session-plan.md` and its variants to `logs/.session-plan-history/` before any overwrite).
2. Remove the original project file.
3. Create a symlink from the project hook path to the canonical file (relative symlink walking up to ai-resources).
4. Verify the existing project `.claude/settings.json` wiring (`bash $CLAUDE_PROJECT_DIR/.claude/hooks/backup-session-plan.sh`) still resolves through the symlink and the hook fires as expected.

**Explicitly NOT in this proposal:** adding new hook wiring to `ai-resources/.claude/settings.json` or `Axcion AI Repo/.claude/settings.json`. If we want the canonical hook to fire in ai-resources or workspace-root sessions, that is a separate permission-changes decision and a separate /risk-check.

**Context:**
- Plan source: `projects/nordic-pe-macro-landscape-H1-2026/plans/graduate-phase-plan-v1.md` Step 4 (lines 125–135). Estimated ~0.5 session.
- Hook content: 35 lines bash; uses `$CLAUDE_PROJECT_DIR` (set by Claude Code per project session); writes to `$CLAUDE_PROJECT_DIR/logs/.session-plan-history/`. No hardcoded project-specific paths.
- The hook has been observed to work cleanly in nordic-pe over the last several sessions.
- Known caveat: `$CLAUDE_PROJECT_DIR` can be unset in some hook contexts (recurring `check-archive.sh` failure per usage-log) — the hook handles missing source files gracefully (`[ -f "$SRC" ] || exit 0`), but a missing `$CLAUDE_PROJECT_DIR` would cause `mkdir -p` and `cp` to write to absolute paths starting with `/logs/...` which would fail silently.
- Other projects in the workspace (if any) would NOT be affected by this graduation — they would only pick up the hook if they explicitly wire it in their own settings.json.

**Structural class:** hook-edits (new canonical hook file, project-to-canonical symlink).

**Reversibility:** straightforward — `git revert` the lift commit, restore project-local file, delete canonical file.

**Blast radius:** project-local for now (only nordic-pe wires this hook). The canonical file becomes available for future projects to wire.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/hooks/backup-session-plan.sh` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/backup-session-plan.sh` — not yet present
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/` — exists (directory)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/plans/graduate-phase-plan-v1.md` — exists

## Verdict

GO

**Summary:** Byte-identical lift of a self-contained, project-agnostic 35-line hook into ai-resources with a project-side symlink; no permission widening, no auto-propagation to other projects, no new wiring beyond what already exists in nordic-pe settings.json.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No token cost added to any always-loaded file. The change touches `ai-resources/.claude/hooks/backup-session-plan.sh` (new canonical file), `projects/nordic-pe-macro-landscape-H1-2026/.claude/hooks/backup-session-plan.sh` (becomes a symlink), and creates no CLAUDE.md additions or `@import` chains — verified by reading both CLAUDE.md files (workspace root and ai-resources/CLAUDE.md) for the project's existing references; neither references this hook.
- The hook is a PreToolUse Write hook that already fires in nordic-pe per `projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json` lines 71–80 — graduating to canonical does not change firing frequency (same wiring, same matcher, same matcher path-filter inside the hook script body line 16).
- Hook execution itself is shell-only, not LLM tokens — no token surface from execution.
- The new canonical file becomes available for future projects to wire, but the proposal explicitly does NOT wire it in `ai-resources/.claude/settings.json` (verified — no PreToolUse Write hook block in that file) or any workspace-root settings (workspace root has no `.claude/settings.json`, only `settings.local.json`).

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`, `ask`, or `deny` entries change. The proposal explicitly excludes adding new hook wiring to `ai-resources/.claude/settings.json` or workspace-root settings — verbatim from CHANGE_DESCRIPTION: "Explicitly NOT in this proposal: adding new hook wiring to `ai-resources/.claude/settings.json` or `Axcion AI Repo/.claude/settings.json`."
- The project settings.json wiring at lines 71–80 (`bash $CLAUDE_PROJECT_DIR/.claude/hooks/backup-session-plan.sh`) is path-stable across the symlink swap. `$CLAUDE_PROJECT_DIR/.claude/hooks/backup-session-plan.sh` resolves identically whether the path is a regular file or a symlink to canonical.
- No new tool capability or `Bash(...)` pattern is introduced — the hook already runs via the existing PreToolUse Write matcher.

### Dimension 3: Blast Radius
**Risk:** Low

- Files directly touched: 2 (one new canonical file, one project file converted from regular file to symlink).
- Dependent callers: 1 — the nordic-pe `.claude/settings.json` PreToolUse Write wiring (verified at lines 71–80). Path expression `$CLAUDE_PROJECT_DIR/.claude/hooks/backup-session-plan.sh` is unchanged by the symlink swap.
- Repo-wide grep for `backup-session-plan` returned 18 hits across plans, audit working notes, innovation-registry, and session-notes-archive (verified via `grep -rln "backup-session-plan"`). Of these, only ONE is a runtime call site — the nordic-pe `settings.json` line 76. The other 17 are documentation/log references and are unaffected by a symlink swap.
- Auto-sync coverage: `ai-resources/.claude/hooks/auto-sync-shared.sh` walks `commands/` and `agents/`, NOT `hooks/` (verified — script header at lines 1–17 names only those two dirs). So the new canonical hook will NOT auto-propagate to any other project; future projects must opt in by wiring it manually. This is the intended behavior per the proposal.
- No contract changes — the hook reads `tool_input.file_path` from stdin (Claude Code-standard PreToolUse contract) and writes to `$CLAUDE_PROJECT_DIR/logs/.session-plan-history/` (relative-to-project path). Same contract pre- and post-graduation.

### Dimension 4: Reversibility
**Risk:** Low

- `git revert` cleanly undoes the lift: removes `ai-resources/.claude/hooks/backup-session-plan.sh`, restores the original project file at `projects/.../hooks/backup-session-plan.sh`, removes the symlink replacement. All three changes are tracked.
- One ephemeral byproduct: backup files in `projects/nordic-pe-macro-landscape-H1-2026/logs/.session-plan-history/` accumulate as the hook fires. These are NOT created by the graduation itself (the hook already fires today) and are unaffected by revert — same disposition before and after graduation.
- No external state propagated (no `git push`, no Notion write, no API call). Local-only change.
- Settings.json wiring is unchanged across the swap — no operator muscle memory or cached permission state to reset.

### Dimension 5: Hidden Coupling
**Risk:** Low

- Hook contract is explicit: reads `tool_input.file_path` from stdin (Claude Code-standard PreToolUse hook protocol), exits 0 if file_path doesn't match the path-filter regex (verified at line 16 of the hook). The contract is self-documented in the script's header comment (lines 1–9).
- Known caveat from CHANGE_DESCRIPTION about `$CLAUDE_PROJECT_DIR` being unset in some hook contexts — this is a pre-existing behavior of the project-local version, not introduced by the graduation. The hook handles missing source files via `[ -f "$SRC" ] || exit 0` (line 21). The "silent fail to absolute `/logs/...`" risk on unset `$CLAUDE_PROJECT_DIR` exists today; graduation does not change it.
- No silent auto-firing in unexpected contexts: the hook only fires under PreToolUse Write, and only when the wiring is present. Other projects do not auto-pick-up the hook (verified — `auto-sync-shared.sh` walks `commands/` and `agents/` only, not `hooks/`).
- No functional overlap with existing canonical hooks (verified directory listing of `ai-resources/.claude/hooks/`: 13 hooks present, none named `backup-*` or with a session-plan backup function).
- The symlink creates one new implicit dependency: the project hook is now a relative symlink to ai-resources. If ai-resources is moved or the canonical file is deleted, the symlink breaks. Mitigated by the workspace convention that ai-resources is a stable sibling — the same convention already underpins the existing command symlinks (e.g., the `/produce-prose-draft` symlinks per nordic-pe CLAUDE.md "Stage 5 Polish Commands" section).

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file contents (the 35-line hook script, project `settings.json` PreToolUse Write block lines 71–80, ai-resources `settings.json` confirmed no Write PreToolUse block, auto-sync-shared.sh scope at lines 1–17), grep counts (18 references to `backup-session-plan` across the repo; only 1 runtime call site), directory listing of `ai-resources/.claude/hooks/` (no naming or functional overlap), and verbatim quote of the proposal's exclusion of permission/wiring changes. No training-data fallback used.
