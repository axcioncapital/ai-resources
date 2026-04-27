#!/bin/bash
# PreToolUse hook for Skill: auto-start friction log session when a command
# declares friction-log: true in its YAML frontmatter.
# Dedup: skips if a session block was created in the last 30 minutes.

INPUT=$(cat)
SKILL_NAME=$(echo "$INPUT" | jq -r '.tool_input.skill // empty')

# Skip if no skill name
[ -z "$SKILL_NAME" ] && exit 0

# Strip any namespace prefix (e.g., "ms-office-suite:pdf" → "pdf")
SKILL_NAME="${SKILL_NAME##*:}"

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
CMD_FILE="$PROJECT_DIR/.claude/commands/$SKILL_NAME.md"

# Skip if command file doesn't exist
[ -f "$CMD_FILE" ] || exit 0

# Check for friction-log: true in YAML frontmatter (between --- delimiters)
HAS_FLAG=$(sed -n '/^---$/,/^---$/p' "$CMD_FILE" | grep -c 'friction-log: *true')
[ "$HAS_FLAG" -gt 0 ] || exit 0

FRICTION_LOG="$PROJECT_DIR/logs/friction-log.md"

# Create file if it doesn't exist
if [ ! -f "$FRICTION_LOG" ]; then
    echo "# Friction Log" > "$FRICTION_LOG"
fi

# Dedup: skip if a session block was created in the last 30 minutes
LAST_SESSION=$(grep -o 'Session — [0-9-]* [0-9:]*' "$FRICTION_LOG" | tail -1)
if [ -n "$LAST_SESSION" ]; then
    LAST_TS=$(echo "$LAST_SESSION" | sed 's/Session — //')
    LAST_EPOCH=$(date -j -f '%Y-%m-%d %H:%M' "$LAST_TS" '+%s' 2>/dev/null || echo 0)
    NOW_EPOCH=$(date '+%s')
    DIFF=$(( NOW_EPOCH - LAST_EPOCH ))
    [ "$DIFF" -lt 1800 ] && exit 0
fi

# Append session block
TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
{
    echo ""
    echo "## Session — $TIMESTAMP"
    echo ""
    echo "**Trigger:** \`/$SKILL_NAME\`"
    echo ""
    echo "### Friction Events"
    echo ""
    echo "#### Write Activity"
} >> "$FRICTION_LOG"

exit 0
