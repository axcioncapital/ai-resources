#!/bin/bash
# backup-session-plan.sh — PreToolUse Write hook (nordic-pe project-local)
#
# Before any Write to logs/session-plan-*.md (marker-scoped variants per
# docs/session-marker.md), copies the existing plan to
# logs/.session-plan-history/YYYY-MM-DD-HHMM.md for recovery without
# commit-history pollution. Silently exits if no prior plan exists.
#
# Wired via settings.json PreToolUse Write matcher; path filter is in-script
# (Claude Code matchers are tool-name only, not path-scoped).

file_path=$(jq -r '.tool_input.file_path // empty' 2>/dev/null)

# Only act on writes to logs/session-plan-<marker>.md or logs/session-plan-<marker>-<suffix>.md.
# Under TOCTOU Phase 2+3 atomic (Option A), the bare logs/session-plan.md no longer exists —
# every session writes its own marker-scoped plan (logs/session-plan-S1.md, S2.md, etc.) plus
# any pass2/next fork variants (logs/session-plan-S1-pass2.md). The regex captures both shapes:
# canonical (one segment) and fork (two segments). Without the two-segment branch, pass2 plans
# written under marker-scoped naming would be silently un-backed-up.
echo "$file_path" | grep -qE '(^|/)logs/session-plan(-[a-zA-Z0-9]+){0,2}\.md$' || exit 0

# Derive SRC and BACKUP from the matched file path so the backup name tracks the variant
# (e.g., a write to session-plan-pass2.md backs up as 2026-05-28-1930-session-plan-pass2.md).
SRC="$file_path"
[ -f "$SRC" ] || exit 0  # Nothing to back up if file doesn't exist yet

HIST_DIR="$CLAUDE_PROJECT_DIR/logs/.session-plan-history"
mkdir -p "$HIST_DIR"

FILENAME=$(basename "$file_path" .md)
TIMESTAMP=$(date '+%Y-%m-%d-%H%M')
BACKUP="$HIST_DIR/$TIMESTAMP-$FILENAME.md"

# Skip if a same-minute backup already exists for this variant
[ -f "$BACKUP" ] && exit 0

cp "$SRC" "$BACKUP"
exit 0
