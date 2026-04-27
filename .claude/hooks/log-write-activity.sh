#!/bin/bash
# PostToolUse hook: Log file write/edit activity to friction log.
# Non-blocking (always exit 0). Lightweight append, no pattern detection.
# The improvement-analyst agent does the interpretive work.

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "Write"')

# Skip if no file path
[ -z "$FILE_PATH" ] && exit 0

# Skip writes to friction-log.md (recursion guard) and improvement-log.md
echo "$FILE_PATH" | grep -q 'friction-log.md' && exit 0
echo "$FILE_PATH" | grep -q 'improvement-log.md' && exit 0

# Derive project directory
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"

# Only log writes within the project directory
echo "$FILE_PATH" | grep -q "$PROJECT_DIR" || exit 0

FRICTION_LOG="$PROJECT_DIR/logs/friction-log.md"

# Only log if a friction session is active
[ -f "$FRICTION_LOG" ] || exit 0
grep -q '#### Write Activity' "$FRICTION_LOG" || exit 0

# Make path relative for readability
REL_PATH=$(echo "$FILE_PATH" | sed "s|$PROJECT_DIR/||")

TIMESTAMP=$(date '+%Y-%m-%d %H:%M')

# Append to the Write Activity section (at end of file)
echo "- \`$TIMESTAMP\` — $TOOL_NAME: \`$REL_PATH\`" >> "$FRICTION_LOG"

exit 0
