# Risk Check — 2026-05-29

## Change

Replace the stale absolute path `/Users/danielniklander/Axcion Claude Code/Axcion AI Repo` in `projects/interpersonal-communication/.claude/settings.json` `permissions.additionalDirectories` with the current operator's actual workspace path `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`. The stale path points to a user not present on this machine; without a valid workspace path, the project's ~60+ symlinks to ai-resources commands and agents will fail to resolve. Scope: single project's settings.json, additionalDirectories field only. Class: settings.json edit (Rule 9 permission-template fix).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/interpersonal-communication/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md — exists

## Verdict

GO

**Summary:** Single-field literal-path replacement that restores the canonical Layer D shape exactly as documented in `permission-template.md`; risk is Low across all five dimensions.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No content added to always-loaded files. The change replaces one string inside one field in one project's `.claude/settings.json` (line 32) — `settings.json` is configuration consumed by Claude Code at session start, not loaded into prompt context.
- No hook is registered, removed, or modified. The existing `SessionStart` hook block (lines 36–57) is untouched.
- No `@import` chain, no subagent brief expansion, no skill description change. Pay-as-used path only.

### Dimension 2: Permissions Surface
**Risk:** Low

- The edit is to `permissions.additionalDirectories` — a directory grant for resource discovery (symlink resolution), not a tool-capability allow/deny rule. The `allow` list (lines 4–22) and `deny` list (lines 23–30) are unchanged.
- The new path matches the canonical Layer D shape verbatim: `permission-template.md` line 177 prescribes `"/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"` as the project-level `additionalDirectories` entry.
- Functionally, the change *restores* an intended grant (workspace root) that currently fails because the prior path does not exist on disk (`STALE_MISSING` verified via `test -d`). No widening beyond the canonical shape.
- Project uses `defaultMode: "bypassPermissions"` (line 3), so the `additionalDirectories` field governs directory-discovery scope rather than per-tool prompting — but even under stricter modes this is the documented canonical entry.

### Dimension 3: Blast Radius
**Risk:** Low

- Files directly touched: 1 (`projects/interpersonal-communication/.claude/settings.json`).
- Symlinks dependent on `additionalDirectories` resolving the workspace root: 83 symlinks under `projects/interpersonal-communication/.claude/` (verified via `find -type l | wc -l`). All 83 currently resolve to relative paths (`../../../../ai-resources/.claude/...`), so the symlink targets themselves are not affected by this change — but the harness's permission scope for *reading* those resolved targets depends on `additionalDirectories` granting access to the workspace root.
- Other `danielniklander` mentions found in the project (`grep -rn`): 16 hits, all in `logs/session-plan.md` (lines 13–19), `logs/session-plan-pass2.md` (lines 15–26), and `logs/session-notes-archive-2026-05.md` (lines 567, 1049). These are historical narrative text in log files — they do not gate behavior, are not consumed by any hook or command, and are out of scope for this change. (Note: the 2026-05-16 archive entry explicitly records the earlier migration `patrik.lindeberg` → `danielniklander` across 5 files based on "operator confirmed sole-operator status" — that earlier change is what produced the present stale-path state.)
- Contract changes: none. The `additionalDirectories` schema is unchanged; only the string value is updated.
- No cross-repo writes, no shared infra touched, no caller modifications required.

### Dimension 4: Reversibility
**Risk:** Low

- `git revert` cleanly restores the prior string in a single file. The change is a one-line value replacement inside JSON.
- No sibling files created. No log entries appended by the change itself. No external state mutated.
- The only operator-side residue is that a revert would re-break symlink resolution on this machine (the prior state was already broken), so revert is mechanically clean even though it would not be functionally desirable.

### Dimension 5: Hidden Coupling
**Risk:** Low

- No new contract introduced. The `additionalDirectories` field's contract is documented at `permission-template.md` § Layer D (line 188): *"`additionalDirectories` granting workspace root — required for ai-resources symlinks to resolve."* The change conforms to that contract.
- No silent auto-firing. `additionalDirectories` is consumed declaratively at session start; it does not trigger callbacks or hooks of its own.
- No functional overlap with existing mechanisms. The SessionStart hooks (`auto-sync-shared.sh`, `check-permission-sanity.sh`) use the upward-walk idiom (lines 41, 51) — they discover ai-resources by walking parent directories from `$CLAUDE_PROJECT_DIR`, not from `additionalDirectories`. The two mechanisms are independent and do not race.
- One implicit dependency exists and is satisfied: the new literal path `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` must exist on disk. Verified via `test -d` (`NEW_EXISTS`).

## Evidence-Grounding Note

All risk levels grounded in direct evidence: settings.json line numbers, `permission-template.md` line citations, filesystem checks (`test -d` confirming stale-MISSING / new-EXISTS), `find -type l | wc -l` returning 83 symlinks, and a `grep -rn` enumeration of the 16 other `danielniklander` mentions in the project (all in inert log files). No training-data fallback used.
