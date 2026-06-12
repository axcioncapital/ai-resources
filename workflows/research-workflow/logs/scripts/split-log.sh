#!/usr/bin/env bash
# split-log.sh <file-path> <keep-entries> <order:top|bottom>
# Splits an append-only log at `## ` header boundaries, archiving the older portion.

set -euo pipefail

FILE="${1:?file-path required}"
KEEP="${2:?keep-entries required}"
ORDER="${3:?order required (top|bottom)}"

[ -f "$FILE" ] || { echo "split-log: file not found: $FILE" >&2; exit 1; }
case "$ORDER" in top|bottom) ;; *) echo "split-log: order must be top|bottom" >&2; exit 1;; esac

DIR=$(dirname "$FILE")
BASE=$(basename "$FILE" .md)

# Fence-aware header extraction: `## ` lines inside fenced code blocks (``` or ~~~)
# are NOT entry headers — template placeholders like `## YYYY-MM-DD` inside fences
# previously corrupted the header list (improvement-log 2026-06-12).
# Prints header text from stdin, skipping fenced spans.
headers_only() {
    awk '/^(```|~~~)/ { fence = !fence; next } !fence && /^## / { print }'
}

# Header lines (line numbers of every true `## ` block, fence-aware)
# Portable across bash 3.2 (macOS default) — no mapfile/readarray.
HEADERS=()
while IFS= read -r _line; do
    HEADERS+=("$_line")
done < <(awk '/^(```|~~~)/ { fence = !fence; next } !fence && /^## / { print NR }' "$FILE")
TOTAL=${#HEADERS[@]}
[ "$TOTAL" -le "$KEEP" ] && exit 0

H1=$(head -1 "$FILE")

# Preamble = everything before the first real entry header (H1, description,
# fenced usage templates). Previously only H1 was kept on rewrite — preamble
# content was silently lost (improvement-log 2026-06-12). Strip any existing
# `> Archive: [` pointer line (the script's own emission, see the rewrite
# block below) so re-runs keep exactly one pointer. Anchored to the exact
# emitted format — a prose line merely mentioning "Archive:" is preserved.
FIRST_HEADER_LINE=${HEADERS[0]}
if [ "$FIRST_HEADER_LINE" -gt 1 ]; then
    # Command substitution strips trailing newlines, so the preamble ends clean;
    # the rewrite block re-adds exactly one blank-line separator.
    PREAMBLE=$(sed -n "1,$((FIRST_HEADER_LINE - 1))p" "$FILE" | grep -v '^> Archive: \[' || true)
else
    PREAMBLE="$H1"
fi

if [ "$ORDER" = "top" ]; then
    # Newest at top: keep first KEEP entries, archive the rest
    KEEP_START=${HEADERS[0]}
    ARCHIVE_START=${HEADERS[$KEEP]}
    KEEP_END=$((ARCHIVE_START - 1))
    KEEP_BLOCK=$(sed -n "${KEEP_START},${KEEP_END}p" "$FILE")
    ARCHIVE_BLOCK=$(sed -n "${ARCHIVE_START},\$p" "$FILE")
    OLDEST_HEADER_LINE=${HEADERS[$KEEP]}
else
    # Newest at bottom: archive first (TOTAL-KEEP) entries, keep the last KEEP
    ARCHIVE_START=${HEADERS[0]}
    KEEP_START=${HEADERS[$((TOTAL - KEEP))]}
    ARCHIVE_END=$((KEEP_START - 1))
    ARCHIVE_BLOCK=$(sed -n "${ARCHIVE_START},${ARCHIVE_END}p" "$FILE")
    KEEP_BLOCK=$(sed -n "${KEEP_START},\$p" "$FILE")
    OLDEST_HEADER_LINE=${HEADERS[0]}
fi

# Derive YYYY-MM from oldest archived header. Look for a YYYY-MM-DD anywhere on the line.
OLDEST_HEADER=$(sed -n "${OLDEST_HEADER_LINE}p" "$FILE")
YYYYMM=$(echo "$OLDEST_HEADER" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1 | cut -d- -f1,2)
[ -n "$YYYYMM" ] || { echo "split-log: could not derive YYYY-MM from header: $OLDEST_HEADER" >&2; exit 1; }

ARCHIVE_FILE="${DIR}/${BASE}-archive-${YYYYMM}.md"

# Idempotency: if archive file's last `## ` matches archive block's first `## `, skip append (already done)
SKIP_APPEND=0
if [ -f "$ARCHIVE_FILE" ]; then
    LAST_ARCHIVE_HEADER=$(headers_only < "$ARCHIVE_FILE" | tail -1 || true)
    FIRST_BLOCK_HEADER=$(echo "$ARCHIVE_BLOCK" | headers_only | head -1 || true)
    if [ -n "$LAST_ARCHIVE_HEADER" ] && [ "$LAST_ARCHIVE_HEADER" = "$FIRST_BLOCK_HEADER" ]; then
        SKIP_APPEND=1
    fi
fi

if [ "$SKIP_APPEND" -eq 0 ]; then
    if [ ! -f "$ARCHIVE_FILE" ]; then
        # Strip leading "# " from H1 to use as archive title
        TITLE=${H1#\# }
        printf '# %s — Archive %s\n\n' "$TITLE" "$YYYYMM" > "$ARCHIVE_FILE"
    fi
    printf '%s\n' "$ARCHIVE_BLOCK" >> "$ARCHIVE_FILE"
fi

# Rewrite active file: full preamble + blank + pointer + blank + keep block
TMP=$(mktemp)
{
    printf '%s\n\n' "$PREAMBLE"
    printf '> Archive: [%s](%s)\n\n' "$(basename "$ARCHIVE_FILE")" "$(basename "$ARCHIVE_FILE")"
    printf '%s\n' "$KEEP_BLOCK"
} > "$TMP"
mv "$TMP" "$FILE"

ARCHIVED_COUNT=$((TOTAL - KEEP))
echo "Auto-archived $(basename "$FILE") → $(basename "$ARCHIVE_FILE") (archived $ARCHIVED_COUNT entries, kept $KEEP)"
