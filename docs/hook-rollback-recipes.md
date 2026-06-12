# Hook Rollback Recipes

> **When to read this file:** When reverting a hook commit whose runtime writes outlive the code change. A `git revert` removes the hook's code but does NOT remove the lines the hook already appended to live logs — each recipe below documents the manual cleanup that completes the rollback.

## friction-log-auto.sh — dual-mode (C6, landed 2026-06-12)

**What the commit added:** a PostToolUse branch that auto-appends tool-error friction events to `logs/friction-log.md` (lines matching `- HH:MM — [auto] {tool} error: …` under `### Friction Events`), plus a `PostToolUse` registration in `ai-resources/.claude/settings.json` (matcher `Bash|Write|Edit|Agent|Skill`).

**Full rollback:**

1. `git revert {commit}` in `ai-resources/` — restores the single-mode hook AND removes the settings.json PostToolUse registration (they land in the same commit by design; reverting one without the other leaves either a dead registration or an unreachable branch).
2. **Manual strip of surviving log lines** — the auto-appended friction events persist in every `logs/friction-log.md` the hook wrote to while live:

   ```bash
   # dry-run: list surviving auto-appended lines
   grep -n "— \[auto\] .* error: " logs/friction-log.md
   # strip them (BSD/macOS sed)
   sed -i '' '/— \[auto\] .* error: /d' logs/friction-log.md
   ```

   Run per repo whose sessions ran with the hook live (`ai-resources/` itself; consumer projects only if they re-synced the hook copy + registration).
3. Operator-logged friction events (via `/friction-log`) do NOT match the `[auto]` marker and are untouched by the strip — the marker exists precisely to keep manual and automatic entries separable.

**Why this is needed:** append-only logs are a safe zone until rollback — the hook's writes are data, not code, so version control cannot undo them (reversibility inversion).

## Recipe index maintenance

Add a section here whenever a hook commit introduces runtime writes to live state. The commit message should point at this file rather than inlining the recipe (commit messages explain *why*; rollback procedure is a *what* that operators need findable under pressure).
