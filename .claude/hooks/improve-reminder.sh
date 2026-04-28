#!/usr/bin/env bash
# Stop hook: remind operator to run /improve at session end if significant artifacts were produced.
# Fires once at session end. Non-blocking — always exits 0.

# Dedup: one reminder per session (parent PID as session proxy)
SESSION_MARKER="/tmp/claude-improve-reminded-$PPID"
[ -f "$SESSION_MARKER" ] && exit 0

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
cd "$PROJECT_DIR" 2>/dev/null || exit 0

# Skip if not in a git repo (artifact detection relies on git status)
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

# Check git status for changes (staged, unstaged, untracked) under artifact directories.
# Path patterns are research-workflow / draft-pipeline-shaped: projects without
# these directory names will never trigger the nudge. Override by editing this
# regex if your project uses different artifact paths.
ARTIFACT_RE='^(approved|output|report/chapters|final/modules)/'

if git status --porcelain 2>/dev/null | awk '{ print $NF }' | grep -qE "$ARTIFACT_RE"; then
  touch "$SESSION_MARKER"
  echo '{"systemMessage":"Significant artifact produced this session. Consider running /improve before wrapping the session."}'
fi

exit 0
