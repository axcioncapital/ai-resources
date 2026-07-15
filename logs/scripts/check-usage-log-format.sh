#!/usr/bin/env bash
# check-usage-log-format.sh — assert the newest usage-log.md entry is APPENDED AT THE TAIL,
# where /prime's reader (`tail -n 30 logs/usage-log.md`, prime.md Step 1) can reach it.
#
# WHY THIS EXISTS. On 2026-07-14 a session's telemetry entry (`### 2026-07-14 (S2)`) was
# PREPENDED — written directly under the `<!-- entries below -->` marker instead of appended at
# the tail — while the reader only ever reads the last 30 lines. The entry sat ~900 lines above
# the reader's window and was invisible to its own consumer: a record that its readers cannot
# reach is a record that does not exist. This guard makes that failure loud at wrap time instead
# of silent. (logs/improvement-log.md 2026-07-14 "Logs are being written in shapes their own
# readers cannot parse".)
#
# The convention it enforces: usage-log entries are APPEND-AT-TAIL (newest wrap at the bottom).
# It does NOT enforce full chronological sort — the historical head of the file is deliberately
# unsorted and that is not a reader-visibility problem.
#
# Usage:
#   check-usage-log-format.sh [LOG_PATH] [EXPECTED_NEWEST]
#     LOG_PATH       default: logs/usage-log.md (relative to cwd)
#     EXPECTED_NEWEST optional, the just-written entry's unique id, e.g. "2026-07-15 (S1-d99)".
#       When given (the wrap SHOULD pass it), the guard asserts the LAST entry header contains it —
#       this is the only check that catches a SAME-DAY prepend, where a bare date match cannot,
#       because several entries can share one date. Without it, the guard still catches cross-day
#       misordering (check 4) and shape violations (check 2).
#
# Exit 0 = OK (prints a one-line confirmation); exit 1 = format violation (diagnostic on stderr).
# Read-only: never writes the log. Cheap: grep/sort/tail only.

set -u
LOG="${1:-logs/usage-log.md}"
EXPECTED="${2:-}"

[ -f "$LOG" ] || { echo "check-usage-log-format: $LOG not found" >&2; exit 1; }

# 1. Reader anchor present.
grep -q '<!-- entries below -->' "$LOG" || {
  echo "check-usage-log-format: FAIL — '<!-- entries below -->' marker missing (reader anchor gone)" >&2; exit 1; }

# 2. Last entry header matches the reader's expected shape.
LAST_HEADER="$(grep -E '^### [0-9]{4}-[0-9]{2}-[0-9]{2}' "$LOG" | tail -n 1)"
[ -n "$LAST_HEADER" ] || {
  echo "check-usage-log-format: FAIL — no dated '### YYYY-MM-DD' entry found" >&2; exit 1; }
printf '%s\n' "$LAST_HEADER" | grep -qE '^### [0-9]{4}-[0-9]{2}-[0-9]{2}.*\| (Efficient|Acceptable|Wasteful)$' || {
  echo "check-usage-log-format: FAIL — last entry header does not match '### YYYY-MM-DD ... | (Efficient|Acceptable|Wasteful)': ${LAST_HEADER}" >&2; exit 1; }

# 3. Load-bearing (needs EXPECTED): the just-written entry must BE the last entry — not prepended.
if [ -n "$EXPECTED" ]; then
  case "$LAST_HEADER" in
    *"$EXPECTED"*) : ;;
    *) echo "check-usage-log-format: FAIL — newest entry '${EXPECTED}' is NOT the last entry (prepended or misplaced). /prime's tail-read will not see it. Last entry is: ${LAST_HEADER}" >&2; exit 1 ;;
  esac
fi

# 4. Cross-day guard (runs with or without EXPECTED): the newest DATE must sit on the last entry.
MAX_DATE="$(grep -oE '^### [0-9]{4}-[0-9]{2}-[0-9]{2}' "$LOG" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | sort | tail -n 1)"
LAST_DATE="$(printf '%s\n' "$LAST_HEADER" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -n 1)"
if [ "$MAX_DATE" != "$LAST_DATE" ]; then
  echo "check-usage-log-format: FAIL — newest date in file (${MAX_DATE}) is above the tail; last entry is ${LAST_DATE}. An entry newer than the tail was prepended/misplaced; /prime's tail-read cannot see it." >&2; exit 1
fi

echo "check-usage-log-format: OK — newest entry at tail, reader-visible (${LAST_HEADER})"
exit 0
