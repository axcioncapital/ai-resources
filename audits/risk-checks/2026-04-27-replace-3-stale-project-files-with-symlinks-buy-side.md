# Risk Check — 2026-04-27

## Change

Replace 3 stale project files in `projects/buy-side-service-plan/.claude/` with relative symlinks (`../../../../ai-resources/.claude/...`) pointing to canonical, matching the existing established symlink pattern in this project (~30 existing symlinks under .claude/agents and .claude/commands).

Files:
1. `.claude/commands/wrap-session.md` — project copy ~80 lines smaller than canonical; canonical adds preflight, dirt-check, telemetry, risk-check end-time gate, archive logic.
2. `.claude/commands/improve.md` — project older; canonical adds escalation protocol, specificity gate, archive de-dup, known-solutions phase.
3. `.claude/agents/improvement-analyst.md` — paired with /improve; canonical adds Recurrence Escalation, Specificity Gate, Phase 5.

Source: 2026-04-27 innovation-sweep report (`ai-resources/audits/innovation-sweep-buy-side-service-plan-2026-04-27.md`) classified all three as Accept-fork stale forks with no improvements worth backporting.

Pattern context: Identical symlink shape was just applied earlier in this session to `commands/prime.md` and `commands/audit-repo.md` in the same project without issue (those symlinks resolve and work). The buy-side-service-plan project already has ~30 existing symlinks under `.claude/agents/` and `.claude/commands/` pointing back to `../../../../ai-resources/.claude/...`. Project has its own `.git`; workspace root sees `projects/buy-side-service-plan/` as untracked but the project commits internally.

Specific concerns the operator wants weighed:
- The buy-side-service-plan's `.claude/settings.json` has wrap-session-related hook entries; canonical /wrap-session has different mechanics (dirt-check, archive-aware, risk-check end-time gate). May behave unexpectedly against the project's directory layout if invoked.
- /improve and improvement-analyst run as a paired duo. Symlinking only one would break the pair — both must symlink together.
- The project itself appears near-completion (a polished final document is in `output/`). Whether commands like /wrap-session are actually invoked frequently within this project may be low. If wrap-session is rarely run, the risk surface for behavioral mismatch shrinks.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/commands/wrap-session.md — exists (regular file, 3404 bytes, mtime Apr 22)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/commands/improve.md — exists (regular file, 2588 bytes, mtime Apr 12)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/agents/improvement-analyst.md — exists (regular file, 4791 bytes, mtime Apr 12)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists (regular file, 13134 bytes, mtime Apr 27 17:59)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/improve.md — exists (regular file, 3032 bytes, mtime Apr 22)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/improvement-analyst.md — exists (regular file, 8405 bytes, mtime Apr 21)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/settings.json — exists (regular file, 6955 bytes, mtime Apr 25)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The symlink pattern itself is mature and the swap is mechanically safe (revert-clean), but adopting the canonical wrap-session expands runtime expectations against the project's directory layout in ways that warrant a single explicit smoke-pass before relying on it.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No content added to always-loaded files. Project CLAUDE.md and workspace CLAUDE.md are not touched by the change.
- No new auto-load hook registered. Existing SessionStart `auto-sync-shared.sh` hook (project `.claude/settings.json` lines 80–84) already runs once per session regardless of whether these three files are symlinks or copies.
- Replacing local copies with symlinks does NOT increase per-turn token cost — slash commands and subagent definitions load on invocation, not on every turn. The canonical wrap-session is ~9.7KB larger than the project copy (13134 vs 3404 bytes), but that load only happens when `/wrap-session` is actually invoked, not on every session.
- Canonical improvement-analyst is ~3.6KB larger than project copy (8405 vs 4791); only loaded when `/improve` actually spawns the subagent.

### Dimension 2: Permissions Surface
**Risk:** Low

- No edits to `permissions.allow`, `permissions.ask`, or `permissions.deny` in `.claude/settings.json`. The change is filesystem-level (replace file with symlink), not settings-level.
- Project already has `defaultMode: bypassPermissions` (settings.json line 181) and `Read`/`Edit`/`Write` on `**/.claude/**` (lines 156, 151, 164) — symlinks under `.claude/` resolve and write within the already-authorized scope.
- Canonical wrap-session step 12b invokes `/risk-check` (a slash command, not a new tool). The command itself is already symlinked at `projects/buy-side-service-plan/.claude/commands/risk-check.md` (verified — exists as symlink to ai-resources). No new permission needed.
- Canonical wrap-session step 11 runs `bash logs/scripts/check-archive.sh` — the script already exists at the project's `logs/scripts/` (verified). The project copy at line 28 already shells out to the same path.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct files touched: 3 (the symlink swaps).
- Callers of the affected files (grep `wrap-session\|improvement-analyst` across `projects/buy-side-service-plan/`):
  - `.claude/settings.json` line 109 references `/wrap-session` by name in a Stop hook (does NOT invoke the command — just appends an "ended without /wrap-session" line). Compatible.
  - `.claude/hooks/improve-reminder.sh` line 18 emits "Consider running /improve" systemMessage. Reads no file content; just suggests the command. Compatible.
  - `.claude/hooks/log-write-activity.sh` line 4 mentions improvement-analyst in a comment. No code dependency. Compatible.
  - `.claude/hooks/detect-innovation.sh` line 49 mentions "/wrap-session" in a systemMessage string. Compatible.
  - `.claude/shared-manifest.json` lists all three names under `commands.local` / `agents.local` (lines 25, 43). The auto-sync-shared.sh hook (verified at ai-resources `.claude/hooks/auto-sync-shared.sh` lines 65, 78) treats these names as exclusions ("do not auto-symlink") — the hook also short-circuits at line 67/80 if the target already exists as ANY kind of file or symlink, so once the swap is made, the hook leaves it untouched. Compatible.
  - `logs/coaching-data.md` and `logs/friction-log-archive-part1.md` reference `/wrap-session` historically — log content, no executable dependency. Compatible.
- Contract changes for callers:
  - Canonical wrap-session adds Step 12b end-time `/risk-check` gate, dirt-check (12a), telemetry (12), preflight prompt at top. The Stop-hook in settings.json (line 109) only appends to session-notes if `/tmp/claude-wrap-session-done` lockfile is missing — canonical wrap-session step 0 still creates this lockfile, same as the project copy. The race-suppression contract is preserved.
  - Canonical wrap-session step 7 reads `/logs/innovation-registry.md` — present in project (verified).
  - Canonical wrap-session step 9 reads `/logs/improvement-log.md` — present in project (verified).
- Behavioral expansion: canonical wrap-session expects an interactive preflight prompt (Y/N for telemetry + coaching). This adds one operator-pause point not present in the current project version. For a near-complete project where wrap-session may run rarely, this is a small UX delta, not a blocker.
- Pair coupling honored: the change description correctly bundles `/improve` + `improvement-analyst` together. Symlinking only one would split the pair (improve.md step 2 invokes the improvement-analyst subagent by name; mismatched versions would create the contract problem the change explicitly avoids).

### Dimension 4: Reversibility
**Risk:** Low

- Each symlink swap is two filesystem ops: `rm <file>` then `ln -s ../../../../ai-resources/.claude/... <file>`. Revert is `rm <symlink>` then restoring the original file from git history (the project has its own `.git`; the original files are committed there).
- Pattern verified clean: same symlink shape was applied to `commands/prime.md` and `commands/audit-repo.md` earlier this session (verified via `readlink` — both resolve correctly to `../../../../ai-resources/.claude/commands/...`). Revert path proven.
- No state propagation beyond local repo. No git push, no external API write, no Notion update triggered by the swap itself.
- Canonical wrap-session, when first invoked, will NOT auto-fire between the swap and a hypothetical revert — wrap-session is operator-invoked, not hooked.
- The auto-sync-shared.sh hook's no-overwrite guard (lines 67, 80) means even if the operator reverts the symlinks back to copies, the hook will not silently re-symlink them in the next session. Safe.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- shared-manifest.json classifies the three target files as `commands.local` / `agents.local` (lines 25, 43). This is a documented contract: "files listed here are project-owned, not auto-managed." Symlinking these files is a deliberate override of that classification — the manifest now misrepresents reality. Auto-sync-shared.sh still works correctly (it only reads the list to skip; it does not enforce file-type), but the manifest lies about file ownership for these three names. Future readers of the manifest (operator, audit subagent, /innovation-sweep) may infer the wrong policy.
- Canonical wrap-session step 12a (dirt-check) runs `git -C "$git_root" status` scoped to the session's project directory and uses `stat -f` (macOS-only, documented at line 89). The project has its own `.git` (mentioned in the change description) — the dirt-check will scope to `projects/buy-side-service-plan/` and operate as designed. No coupling break.
- Canonical wrap-session step 12 ("Session telemetry") delegates to `session-usage-analyzer` SKILL — the skill exists at `ai-resources/skills/session-usage-analyzer/SKILL.md` (verified). The project's `permissions.additionalDirectories` includes the workspace root (settings.json line 179), so the SKILL is reachable from the project session.
- Canonical wrap-session step 12b invokes `/risk-check` only if the wrapping session itself touched a structural change class. For a near-completion project that mostly produces document content, this gate will rarely fire — minimal coupling effect.
- Project Stop-hook entries reference `/wrap-session` by name in lockfile and message strings (settings.json lines 109, 119, 124, 119). The lockfile contract (`/tmp/claude-wrap-session-done`) is preserved by canonical step 0 — verified identical wording in both versions. No silent behavior overlap.
- Pair-coupling between `/improve` and `improvement-analyst`: the change description acknowledges this and bundles the swap correctly. Canonical /improve step 2 passes friction-log path, improvement-log path, archive path, and project root path to the subagent (canonical step 2 lines 14–21). Canonical improvement-analyst declares those exact inputs (canonical lines 14–19). Contract aligned.

## Mitigations

- **Mitigation for Dimension 3 (Blast Radius):** Run a smoke test — invoke `/wrap-session` once in this project after the swap (e.g., on the swap commit itself). Confirm: (a) preflight prompt appears and accepts shorthand; (b) Step 12a dirt-check completes without zsh `path`-clobber; (c) Step 11 archive script runs; (d) Step 12b risk-check gate skips quietly when the session has no in-class changes. If any step fails, revert the wrap-session symlink only (leaving improve and improvement-analyst symlinked, since they pair together independently of wrap-session) and file the failure as a buy-side-specific layout issue.
- **Mitigation for Dimension 5 (Hidden Coupling):** Update `projects/buy-side-service-plan/.claude/shared-manifest.json` in the same commit — move `wrap-session` from `commands.local` to `commands.shared`, move `improve` from `commands.local` to `commands.shared`, and move `improvement-analyst` from `agents.local` to `agents.shared`. This restores the manifest's descriptive accuracy and prevents future readers (and audit subagents) from misclassifying the three files as project-owned forks. Without this update, the manifest becomes a stale lie about file ownership.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file existence verified via `ls -la`; symlink pattern verified via `readlink` on the recently-swapped `prime.md` and `audit-repo.md`; caller enumeration via `grep -rn` across `projects/buy-side-service-plan/`; hook semantics verified by reading `ai-resources/.claude/hooks/auto-sync-shared.sh` lines 65–84; manifest classification verified by reading `shared-manifest.json` lines 5–48; canonical wrap-session steps verified by reading the canonical file directly; risk-check class definitions verified against `ai-resources/docs/audit-discipline.md` § Risk-check change classes (lines 15–35). No training-data fallback was used.
