# Risk Check — 2026-05-08

## Change

Fix broken relative path in symlink: `workflows/research-workflow/.claude/commands/consult.md` currently points to `../../../.claude/commands/consult.md` (3-level, resolves to `workflows/.claude/commands/consult.md` which does not exist). Fix: recreate the symlink pointing to `../../../../.claude/commands/consult.md` (4-level, resolves to `ai-resources/.claude/commands/consult.md` which is the correct target). Command: `cd workflows/research-workflow/.claude/commands && ln -sf ../../../../.claude/commands/consult.md consult.md`. Change class: New symlinks (existing symlink replacement with corrected path).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/consult.md — exists (broken symlink)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/consult.md — exists (canonical target, 4428 bytes)

## Verdict

GO

**Summary:** Single-symlink repair from a broken 3-level relative path to a working 4-level relative path; the target file already exists, no callers/contracts change, and `git revert` cleanly restores prior state.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No content added to always-loaded files. The symlink lives under `workflows/research-workflow/.claude/commands/`, which is a per-workflow command directory loaded only when that workflow is active — not auto-loaded across sessions.
- No hooks, no `@import`, no skill triggers. Verified by reading the change-description verbatim: only one `ln -sf` invocation.
- The target file (`.claude/commands/consult.md`, 4428 bytes per `ls -la`) is unchanged. Token cost of `/consult` invocation is identical pre- and post-fix; the only difference is whether the symlink resolves.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` entries touched. Change is filesystem-only (`ln -sf`), no settings.json modification mentioned in CHANGE_DESCRIPTION.
- `Bash(ln:*)` is the only permission category implicated; this is a one-shot operator command, not a registered tool pattern. No scope escalation.

### Dimension 3: Blast Radius
**Risk:** Low

- One file touched: `workflows/research-workflow/.claude/commands/consult.md` (the symlink itself).
- Caller enumeration via `grep -rln "consult.md\|consult\b" --include="*.md"` across `ai-resources/`: 22 hits. Inspection shows references are either (a) the canonical command file at `.claude/commands/consult.md`, (b) audit/risk-check artifacts that mention `/consult` as a slash-command invocation (Claude Code resolves slash commands via the loaded command directory, not by following this symlink), or (c) the broken symlink itself. No caller imports or links *through* the broken symlink.
- The companion symlink `session-plan.md` in the same directory uses an absolute path (`/Users/.../ai-resources/.claude/commands/session-plan.md` per `find -type l`), confirming the per-workflow `.claude/commands/` directory is the only consumer pattern and there is no second-order chain to break.
- No contract change: the symlink target file is unchanged (frontmatter, body, signature all preserved). Pre-fix: `/consult` from a research-workflow session is broken. Post-fix: `/consult` resolves to the same canonical command every other session already uses.

### Dimension 4: Reversibility
**Risk:** Low

- `git revert` restores the prior symlink (3-level relative path) in a single commit. Symlinks are tracked by git as their target string, so revert is mechanical.
- No data/log mutation, no append-only state, no external write, no hook firing in between. The change is a pure metadata flip on one inode.
- Prior state was already broken; reverting only "restores brokenness," which the operator can re-fix at will. No sticky side effects.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The fix aligns with an explicit, documented change class: `docs/audit-discipline.md:23` lists "New symlinks" as a risk-check change class, and the CHANGE_DESCRIPTION self-tags the change accordingly.
- No new contract introduced. The symlink merely points to an existing canonical file; no parse markers, filename conventions, or output-format expectations are added.
- No silent auto-firing. Symlinks resolve at access time only; no hook ordering or cross-session mutation.
- One implicit dependency: relative path arithmetic must be correct for the directory depth. Verified empirically — `ls -la .../research-workflow/.claude/commands/../../../../.claude/commands/consult.md` resolves to the 4428-byte canonical file. The 4-level count is correct (commands → .claude → research-workflow → workflows → ai-resources root).
- No functional overlap with existing mechanisms; this *restores* the intended single mechanism (per-workflow access to the shared command).

## Evidence-Grounding Note

All risk levels grounded in direct evidence: `ls -la` output for both the broken symlink and the proposed target, `readlink` output confirming the current 3-level target string, `readlink -f` exit-code-1 proving the broken resolution, `find -type l` enumeration of sibling symlinks, `grep -rln` caller enumeration (22 hits, none chained through the broken link), and `docs/audit-discipline.md:23` confirming the named change class. No training-data fallback used.
