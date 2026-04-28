#!/usr/bin/env bash
# Stop hook: remind operator to run /coach after 7+ sessions since last coaching run.
# Fires once at session end when the threshold is met. Non-blocking — always exits 0.

# Dedup: one reminder per session (parent PID as session proxy)
SESSION_MARKER="/tmp/claude-coach-reminded-$PPID"
[ -f "$SESSION_MARKER" ] && exit 0

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
NOTES="$PROJECT_DIR/logs/session-notes.md"
COACHING_LOG="$PROJECT_DIR/logs/coaching-log.md"

# If session-notes doesn't exist (new project), nothing to count
[ -f "$NOTES" ] || exit 0

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
