#!/usr/bin/env bash
# Stop hook: suggest /resolve after QC was nudged this session.
# Advisory only. Always exits 0.
# Timeout: 5s
#
# Known limitation: sentinel proves a significant write happened and QC nudge fired,
# not that the operator actually ran /qc-pass. False-positive is acceptable: /resolve
# Step 1 gates on finding actual QC findings in context and tells operator to run
# /qc-pass first if none exist.

# Only fire if QC nudge happened this session
[ -f "/tmp/claude-qc-ran-$PPID" ] || exit 0

# Dedup: one nudge per session
SESSION_MARKER="/tmp/claude-resolve-nudged-$PPID"
[ -f "$SESSION_MARKER" ] && exit 0
touch "$SESSION_MARKER"

echo '{"systemMessage": "QC findings present this session. Run /resolve to assess importance and get ready-to-execute fixes."}'
exit 0
