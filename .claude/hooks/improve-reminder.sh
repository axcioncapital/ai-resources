#!/usr/bin/env bash
# PostToolUse (Write) hook: remind operator to run /improve after writing a significant artifact.
# Fires once per session — uses a temp marker to avoid repeating.
# Non-blocking — always exits 0.

MARKER="/tmp/claude-improve-reminded-$$"
# Dedup: one reminder per session (parent PID as session proxy)
SESSION_MARKER="/tmp/claude-improve-reminded-$PPID"
[ -f "$SESSION_MARKER" ] && exit 0

# Read the file path from tool input
FILE_PATH=$(jq -r '.tool_input.file_path // empty' 2>/dev/null)
[ -z "$FILE_PATH" ] && exit 0

# Check if the written file is a significant artifact.
# Path patterns are research-workflow / draft-pipeline-shaped: projects
# without these directory names will never trigger the nudge. Override
# by editing this regex if your project uses different artifact paths.
if echo "$FILE_PATH" | grep -qE '/(approved|output|report/chapters|final/modules)/'; then
  touch "$SESSION_MARKER"
  echo '{"systemMessage":"Significant artifact produced. Consider running /improve before wrapping the session."}'
fi

exit 0
