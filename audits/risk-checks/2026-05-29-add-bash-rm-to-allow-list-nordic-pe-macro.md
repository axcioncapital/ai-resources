# Risk Check — 2026-05-29

## Change

Add `Bash(rm *)` to the `permissions.allow` list in `projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json`. The deny list already contains `Bash(rm -rf *)` and `Bash(sudo *)`, so the destructive rm-rf form remains denied. This implements canonical permission-template Rule 6: explicit allow for Delete/Remove operations so they don't trigger prompts. Scope: single project's settings.json. No hooks, no shared-resource changes. Class: settings.json edit.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md — exists

## Verdict

GO

**Summary:** Single-entry, additive, idempotent allow-list edit that brings the project file into alignment with the canonical Layer D template; widens no runtime capability beyond what `Bash(*)` already grants under `bypassPermissions`, and the destructive `rm -rf` form remains denied.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- `settings.json` is configuration consumed by the Claude Code harness at session start; it is not always-loaded prompt content and not `@import`-ed into any turn. Adding one entry to an `allow` array adds zero ongoing token cost to future sessions.
- No hook is added or modified. The change description states "No hooks, no shared-resource changes." Verified against the file: the existing `hooks.PreToolUse`, `PostToolUse`, `SessionStart`, `Stop`, and `UserPromptSubmit` blocks (lines 35-257) are untouched.
- No subagent brief, skill description, or system prompt is expanded.

### Dimension 2: Permissions Surface
**Risk:** Medium

- The change widens the `allow` list by one entry. `Bash(rm *)` grants `rm` invocations that the file does not currently authorize via a narrow rule — verified: the only existing `rm` entry in the file is `"Bash(rm -rf *)"` on line 22 (deny). No narrow `rm` allow entry exists today.
- However, `Bash(*)` is already present in the allow list (line 5) and `defaultMode: "bypassPermissions"` is already set (line 30). Under that combination, `rm` already executes without operator confirmation today — the `Bash(rm *)` entry does not grant a new runtime capability; it suppresses the residual Delete/Remove permission prompt that fires independently of `Bash(*)` coverage. This is exactly the Rule 6 failure mode documented in `docs/permission-template.md` line 369: "No `Bash(rm *)` in allow (Delete/Remove failure mode, separate from Edit)."
- The destructive form remains denied: `"Bash(rm -rf *)"` (line 22) and `"Bash(sudo *)"` (line 23) are explicitly untouched. Recursive-force deletes still hit the deny rule.
- The addition moves the file *toward* the canonical Layer D template (`docs/permission-template.md` lines 160-181), which lists `"Bash(rm *)"` verbatim in allow at line 169 and `"Bash(rm -rf *)"` in deny at line 172. This is template-alignment, not novel surface expansion.
- Risk is Medium (not Low) only because `rm` is a destructive verb name; the bounded deny and prior `Bash(*)` coverage keep it from being High.

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly: 1 (`projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json`). No other file is modified.
- Enumeration of dependents — grep for `nordic-pe-macro-landscape` across `{AI_RESOURCES}` outside `audits/`: 30 matches, all in `inbox/`, `.claude/commands/{fix-repo-issues,friday-act}.md`, `docs/agent-tier-table.md`, `docs/permission-template.md`, and `logs/` (session-notes, scratchpads, friction-log, decisions, etc.). Inspection: all matches are prose references that *name* the project; none parses the `permissions.allow` array as a contract. The one structural reference is `docs/permission-template.md` line 285, which documents the project's PostToolUse[Write] fan-out as a reference wiring shape — that section is unchanged by this edit.
- No contract change: `settings.json`'s schema is fixed by the Claude Code harness. Adding one entry to an existing `allow` array honors the schema. Slash-command syntax, frontmatter, hook output shape, and subagent input schemas are all untouched.
- Zero callers require modification. No command, skill, agent, or hook consumes the contents of this `allow` array.
- Single-class, single-file, additive edit.

### Dimension 4: Reversibility
**Risk:** Low

- The target file is git-tracked (under `projects/*/.claude/settings.json`; the gitignore convention in `docs/permission-template.md` lines 91-92 applies to `settings.local.json`, not `settings.json`).
- The change is a single-line addition to the `allow` array. `git revert` of the commit fully restores the prior `allow` array in the same working tree — no sibling files, generated artifacts, or directories are created.
- No log/registry mutation occurs as part of the edit itself (any wrap-session logging is separate).
- No state propagates beyond the local repo: no `git push` is part of the edit semantics, no Notion write, no external API call.
- No automation is added that could fire between landing and revert — no hook, cron, or symlink is created.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The change is self-contained: the added entry is an independent allow rule with no dependency on another component's presence or behavior.
- No new contract is introduced — no parse marker, filename convention, YAML key, or output format. The `allow`-array entry is consumed only by the Claude Code permission engine, whose schema is external and stable.
- No auto-firing: the change does not add or alter a hook, so it introduces no new ordering dependency or silent state mutation. The existing SessionStart `check-permission-sanity.sh` hook (line 171) is unchanged; its check is *satisfied* by this edit (reduces drift it would otherwise flag).
- The change depends on the canonical Layer D template in `docs/permission-template.md` lines 160-181 — but that dependency is explicit, documented, and convergent. `/permission-sweep` (Rule 6, line 369) and `check-permission-sanity.sh` both reference the same template; the three mechanisms agree rather than overlap-conflict.
- No functional overlap: no second mechanism manages this `allow` entry. `/permission-sweep` *detects* the gap (Rule 6 HIGH) and this change *closes* it — intended division of labor, not collision.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
