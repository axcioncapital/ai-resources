#!/usr/bin/env bash
# PostToolUse (Write|Edit): nudge Claude to run /qc-pass after significant writes.
# Advisory only. Always exits 0.
# Timeout: 5s

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
[ -z "$FILE_PATH" ] && exit 0

# Skip if /resolve is currently executing fixes (prevents nudge loop)
[ -f "/tmp/claude-resolve-executing-$PPID" ] && exit 0

# Skip noise files (ephemeral appends that are never QC candidates)
echo "$FILE_PATH" | grep -qE '(friction-log|improvement-log|session-notes|innovation-registry|usage-log|audits/working/)' && exit 0

# Skip if file doesn't exist or is < 50 lines
[ -f "$FILE_PATH" ] || exit 0
LINE_COUNT=$(wc -l < "$FILE_PATH" 2>/dev/null || echo 0)
[ "$LINE_COUNT" -lt 50 ] && exit 0

# Dedup: hash path string (not content) so sentinel is stable across re-edits of same file
# cksum is macOS-portable; awk extracts checksum field only (full output includes byte count + filename)
FILE_HASH=$(echo "$FILE_PATH" | cksum | awk '{print $1}')
SESSION_MARKER="/tmp/claude-auto-qc-${FILE_HASH}-$PPID"
[ -f "$SESSION_MARKER" ] && exit 0
touch "$SESSION_MARKER"

# Signal to auto-resolve-nudge that QC was nudged this session
touch "/tmp/claude-qc-ran-$PPID"

BASENAME=$(basename "$FILE_PATH")
echo "{\"systemMessage\": \"Significant write: $BASENAME ($LINE_COUNT lines). Consider running /qc-pass before continuing.\"}"
exit 0
