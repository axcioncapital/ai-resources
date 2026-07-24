#!/usr/bin/env bash
# check-archive.sh [--warn-only]
# Iterates the append-only log files and archives any over threshold.
# --warn-only emits a JSON systemMessage if any file exceeds 1.5x threshold; performs no writes.

set -euo pipefail

WARN_ONLY=0
[ "${1:-}" = "--warn-only" ] && WARN_ONLY=1

# Tool path: this script's own directory (split-log.sh is a sibling — $0-relative is correct here).
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SPLIT="$SCRIPT_DIR/split-log.sh"

# Data/target path: the CALLER's project — NOT guessed from $0 or pwd. Every caller passes it
# explicitly (wrap-session.md Step 3, log-sweep.md Cat A1). A missing target means a broken
# caller, so refuse loudly rather than archive the wrong repo's logs (the wrong-repo defect).
if [ -n "${CLAUDE_PROJECT_DIR:-}" ] && [ -d "${CLAUDE_PROJECT_DIR}/logs" ]; then
    PROJECT_DIR="$(cd "$CLAUDE_PROJECT_DIR" && pwd)"
else
    echo "check-archive: ERROR — no archive target. CLAUDE_PROJECT_DIR is unset or has no logs/." >&2
    echo "  Every caller must pass CLAUDE_PROJECT_DIR=\"\$(pwd)\". Nothing archived." >&2
    exit 1
fi
LOGS="$PROJECT_DIR/logs"

# file:threshold:keep:order  (order is bottom for all — /wrap-session appends to end)
# coaching-data.md deliberately excluded — uses ### headers only, split-log.sh requires ## headers.
ENTRIES=(
    "session-notes.md:500:10:bottom"
    "decisions.md:400:3:bottom"
)

WARNS=()
FAILED=0
for entry in "${ENTRIES[@]}"; do
    IFS=: read -r FILE THRESHOLD KEEP ORDER <<< "$entry"
    PATH_FULL="$LOGS/$FILE"
    [ -f "$PATH_FULL" ] || continue
    LINES=$(wc -l < "$PATH_FULL" | tr -d ' ')

    if [ "$WARN_ONLY" -eq 1 ]; then
        WARN_THRESHOLD=$((THRESHOLD * 3 / 2))
        if [ "$LINES" -gt "$WARN_THRESHOLD" ]; then
            WARNS+=("$FILE: $LINES lines (warn threshold $WARN_THRESHOLD)")
        fi
        continue
    fi

    if [ "$LINES" -gt "$THRESHOLD" ]; then
        # Date-guard: refuse to archive when the first dated entry is today's.
        # Protects against silent-clobber when a writer prepends today's entry at the top
        # of a bottom-ordered file and split-log.sh would then archive it as the "oldest".
        TODAY="$(date +%Y-%m-%d)"
        FIRST_DATED=$(grep -m1 "^## [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]" "$PATH_FULL" | awk '{print $2}')
        if [ "$FIRST_DATED" = "$TODAY" ]; then
            echo "Skipped archive of $FILE — first dated entry is today's ($TODAY); refusing to archive a fresh write."
            continue
        fi
        if ! bash "$SPLIT" "$PATH_FULL" "$KEEP" "$ORDER"; then
            echo "ARCHIVE FAILED for $FILE"
            FAILED=1
        fi
    fi
done

if [ "$WARN_ONLY" -eq 1 ] && [ "${#WARNS[@]}" -gt 0 ]; then
    MSG="Log files exceed 1.5x archive threshold — run /wrap-session to trigger archive: $(IFS='; '; echo "${WARNS[*]}")"
    printf '{"systemMessage":"%s"}\n' "$MSG"
fi

[ "$FAILED" -eq 1 ] && exit 1
exit 0
