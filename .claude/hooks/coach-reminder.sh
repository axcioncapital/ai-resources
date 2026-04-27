#!/usr/bin/env bash
# PostToolUse (Write) hook: remind operator to run /coach after accumulating enough sessions.
# Fires when writing to session-notes.md and enough sessions have passed since last coaching run.
# Non-blocking — always exits 0.

# Dedup: one reminder per session
SESSION_MARKER="/tmp/claude-coach-reminded-$PPID"
[ -f "$SESSION_MARKER" ] && exit 0

# Only trigger on writes to session-notes.md
FILE_PATH=$(jq -r '.tool_input.file_path // empty' 2>/dev/null)
[ -z "$FILE_PATH" ] && exit 0
echo "$FILE_PATH" | grep -q 'session-notes\.md' || exit 0

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
NOTES="$PROJECT_DIR/logs/session-notes.md"
COACHING_LOG="$PROJECT_DIR/logs/coaching-log.md"

# Count total session entries in session-notes
TOTAL_SESSIONS=$(grep -c '^## 20' "$NOTES" 2>/dev/null || echo "0")

# If coaching log exists, find sessions since last coach run
if [ -f "$COACHING_LOG" ]; then
  LAST_COACH_DATE=$(grep -E '^### 20' "$COACHING_LOG" | tail -1 | sed 's/^### //')
  if [ -n "$LAST_COACH_DATE" ]; then
    # Count session entries dated after the last coach run
    SESSIONS_SINCE=$(awk -v d="$LAST_COACH_DATE" '/^## 20/{date=substr($2,1,10); if(date > d) count++} END{print count+0}' "$NOTES" 2>/dev/null)
  else
    SESSIONS_SINCE=$TOTAL_SESSIONS
  fi
else
  # No coaching log — count all sessions
  SESSIONS_SINCE=$TOTAL_SESSIONS
fi

# Nudge if 7+ sessions since last coach run
if [ "$SESSIONS_SINCE" -ge 7 ] 2>/dev/null; then
  touch "$SESSION_MARKER"
  echo "{\"systemMessage\":\"$SESSIONS_SINCE sessions since last /coach run. Consider running /coach for a collaboration pattern analysis.\"}"
fi

exit 0
