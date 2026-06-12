#!/bin/bash
# Dual-mode friction-log hook (C6 repair, 2026-06-12):
#  - PreToolUse on Skill matcher: auto-start a friction log session block when a
#    command has friction-log: true (original behavior, unchanged).
#  - PostToolUse (registered matchers in settings.json): auto-populate the
#    "### Friction Events" subsection on tool errors — the C6 repair. Before this,
#    the subsection was created but never auto-populated; an empty section read
#    as "no friction occurred" when it actually meant "nothing wrote here".
# Dedup (PreToolUse): skips if session created in last 30 minutes
# Recursion guard (PostToolUse): skips friction-log.md and improvement-log.md targets.
#   Recursion-safe by construction: this branch runs only shell utilities (jq/grep/sed/date)
#   inside the hook process and writes via sed directly — it makes no Claude tool calls,
#   so it can never re-trigger PostToolUse. (Verified 2026-06-12; closes repo-state § 2 Step 9.)
# PORTABILITY: `sed -i ''` and `date -j -f` are BSD/macOS forms. A Linux-host copy needs
#   `sed -i` (no '' arg) and `date -d` instead. Rollback recipe: docs/hook-rollback-recipes.md.

PROJECT_DIR="$CLAUDE_PROJECT_DIR"
FRICTION_LOG="$PROJECT_DIR/logs/friction-log.md"
DEDUP_MINUTES=30

# Read hook input once; both branches parse from it
INPUT=$(cat)
EVENT=$(jq -r '.hook_event_name // empty' <<<"$INPUT" 2>/dev/null)

# ---------------------------------------------------------------------------
# PostToolUse branch — C6: capture tool errors as friction events
# ---------------------------------------------------------------------------
if [ "$EVENT" = "PostToolUse" ]; then
  # Only log into an existing friction log (a session block must already exist)
  [ -f "$FRICTION_LOG" ] || exit 0

  # Error detection: conservative — only fire on an explicit error signal
  IS_ERROR=$(jq -r '.tool_response.is_error // empty' <<<"$INPUT" 2>/dev/null)
  [ "$IS_ERROR" = "true" ] || exit 0

  # Recursion guard: never log friction about writing the logs themselves
  FILE_PATH=$(jq -r '.tool_input.file_path // empty' <<<"$INPUT" 2>/dev/null)
  if [ -n "$FILE_PATH" ]; then
    case "$(basename "$FILE_PATH")" in
      friction-log.md|improvement-log.md) exit 0 ;;
    esac
  fi

  TOOL_NAME=$(jq -r '.tool_name // "unknown-tool"' <<<"$INPUT" 2>/dev/null)
  # Short snippet of the error content; sanitized for the sed append below
  SNIPPET=$(jq -r '(.tool_response.error // .tool_response.message // .tool_response.content // "tool error") | tostring' <<<"$INPUT" 2>/dev/null \
    | tr '\n' ' ' | tr -cd '[:alnum:][:space:]._:/()-' | cut -c1-140)
  [ -n "$SNIPPET" ] || SNIPPET="tool error"

  # Append under the most recent "### Friction Events" heading (before "#### Write Activity")
  LAST_EVENTS_LINE=$(grep -n "^### Friction Events" "$FRICTION_LOG" | tail -1 | cut -d: -f1)
  [ -z "$LAST_EVENTS_LINE" ] && exit 0

  NOW=$(date "+%H:%M")
  sed -i '' "${LAST_EVENTS_LINE}a\\
- ${NOW} — [auto] ${TOOL_NAME} error: ${SNIPPET}" "$FRICTION_LOG" 2>/dev/null || true

  exit 0
fi

# ---------------------------------------------------------------------------
# PreToolUse branch (Skill matcher) — original session-block creation
# ---------------------------------------------------------------------------

# Read the tool input to get the skill/command name
SKILL_NAME=$(jq -r '.tool_input.skill // empty' <<<"$INPUT" 2>/dev/null)
[ -z "$SKILL_NAME" ] && exit 0

# Check if the command has friction-log: true in frontmatter
CMD_FILE="$PROJECT_DIR/.claude/commands/$SKILL_NAME.md"
[ -f "$CMD_FILE" ] || exit 0
grep -q 'friction-log: true' "$CMD_FILE" || exit 0

# Dedup: skip if a session block was created recently
if [ -f "$FRICTION_LOG" ]; then
  LAST_SESSION=$(grep -n "^## Session —" "$FRICTION_LOG" | tail -1 | cut -d: -f1)
  if [ -n "$LAST_SESSION" ]; then
    LAST_TIME=$(sed -n "${LAST_SESSION}p" "$FRICTION_LOG" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}')
    if [ -n "$LAST_TIME" ]; then
      LAST_EPOCH=$(date -j -f "%Y-%m-%d %H:%M" "$LAST_TIME" "+%s" 2>/dev/null || echo 0)
      NOW_EPOCH=$(date "+%s")
      DIFF=$(( (NOW_EPOCH - LAST_EPOCH) / 60 ))
      [ "$DIFF" -lt "$DEDUP_MINUTES" ] && exit 0
    fi
  fi
fi

# Create friction log if it doesn't exist
if [ ! -f "$FRICTION_LOG" ]; then
  echo "# Friction Log" > "$FRICTION_LOG"
  echo "" >> "$FRICTION_LOG"
fi

# Append new session block
NOW=$(date "+%Y-%m-%d %H:%M")
{
  echo ""
  echo "## Session — $NOW"
  echo ""
  echo "### Friction Events"
  echo ""
  echo "#### Write Activity"
  echo ""
} >> "$FRICTION_LOG"

exit 0
