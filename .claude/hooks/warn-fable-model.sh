#!/usr/bin/env bash
# Fable-guard hook (SessionStart).
#
# Warns the operator when the active session model is Fable (claude-fable-5).
# The operator does not want Fable used for Axcion work; this hook is the
# guard that surfaces it loudly at session start.
#
# WHY SessionStart: it is the ONLY hook event that receives the active model.
# Other events (UserPromptSubmit, PreToolUse, Stop, ...) do not, and there is
# no $CLAUDE_MODEL env var. So SessionStart is the single reliable detection
# point. Consequence: the check runs once, at session start — a mid-session
# /model switch to Fable is not caught until the next session start.
#
# The `.model` field is a string (e.g. "claude-fable-5") and is NOT guaranteed
# to be present. When it is absent, empty, or non-Fable, the hook stays
# completely silent — fail-safe, so it never raises a false alarm.
#
# Detection: case-insensitive substring match on "fable" in the model id, so
# it also catches suffixed forms like "claude-fable-5[1m]".
#
# Output (only when Fable is detected):
#   - systemMessage       -> operator-visible banner (not shown to Claude)
#   - additionalContext   -> nudge so the assistant also flags it proactively
# Built with jq so any special characters in the model id are safely escaped.

set -uo pipefail

input=$(cat)

# Extract the model id. jq -r yields empty string if the field is missing.
model=$(printf '%s' "$input" | jq -r '.model // empty' 2>/dev/null)

# No model field (field absent, or not a SessionStart payload) — stay silent.
if [ -z "$model" ]; then
  exit 0
fi

# Case-insensitive substring test for "fable".
case "$(printf '%s' "$model" | tr '[:upper:]' '[:lower:]')" in
  *fable*)
    jq -cn --arg m "$model" '{
      systemMessage: ("⚠️  FABLE MODEL ACTIVE (" + $m + ") — you are on Fable. Run /model to switch to Opus or Sonnet before doing Axcion work."),
      hookSpecificOutput: {
        hookEventName: "SessionStart",
        additionalContext: ("MODEL GUARD: the active session model is " + $m + " (Fable tier). The operator does not want Fable used for Axcion work. Before doing anything else, tell the operator plainly that they are on Fable and recommend running /model to switch to Opus or Sonnet.")
      }
    }'
    ;;
  *)
    # Non-Fable model — silent.
    exit 0
    ;;
esac

exit 0
