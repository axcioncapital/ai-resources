#!/usr/bin/env bash
# log-archiver.sh — helper for /log-sweep
#
# Handles the two gap categories that check-archive.sh and split-log.sh cannot cover:
#   --mode header3        Cat B: rotate files with ### YYYY-MM-DD dated headers
#   --mode whole-file-by-mtime   Cat D: whole-file age-based move to archive/YYYY-MM/
#
# Accepts ABSOLUTE FILE PATHS ONLY. Does not derive PROJECT_DIR from its own location.
# Requires python3 for symlink-escape checks (BSD readlink lacks -f).

set -euo pipefail

# ---------------------------------------------------------------------------
# Usage
# ---------------------------------------------------------------------------

usage() {
  echo "Usage:"
  echo "  log-archiver.sh --mode header3 <ABSOLUTE_FILE> <KEEP>"
  echo "  log-archiver.sh --mode whole-file-by-mtime <ABSOLUTE_FILE>"
  echo ""
  echo "  KEEP: number of ### entries to keep in the live file (header3 mode only)"
  exit 1
}

if [ $# -lt 2 ]; then usage; fi

MODE=""
FILE=""
KEEP=""

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)
      MODE="$2"; shift 2 ;;
    --*)
      echo "ERROR: Unknown flag $1"; usage ;;
    *)
      if [ -z "$FILE" ]; then FILE="$1"
      elif [ -z "$KEEP" ]; then KEEP="$1"
      else echo "ERROR: Unexpected argument $1"; usage
      fi
      shift ;;
  esac
done

if [ -z "$MODE" ] || [ -z "$FILE" ]; then usage; fi

# ---------------------------------------------------------------------------
# Require python3
# ---------------------------------------------------------------------------

if ! command -v python3 &>/dev/null; then
  echo "ERROR: python3 required for symlink-safety check — aborting"
  exit 2
fi

# ---------------------------------------------------------------------------
# Validate file path is absolute
# ---------------------------------------------------------------------------

if [[ "$FILE" != /* ]]; then
  echo "ERROR: FILE must be an absolute path (got: $FILE)"
  exit 3
fi

# ---------------------------------------------------------------------------
# Safety checks (apply to both modes)
# ---------------------------------------------------------------------------

BASENAME=$(basename "$FILE")

# Refuse to operate on already-archived files (defense-in-depth; auditor also excludes these)
if [[ "$BASENAME" == *-archive-*.md ]]; then
  echo "SKIP: $FILE is an already-canonical archive file (matches *-archive-*.md)"
  exit 0
fi

# Self-exclusion: never operate on /log-sweep working notes or manifests (mitigation #2)
if [[ "$BASENAME" == log-sweep-*.md ]] || [[ "$BASENAME" == log-sweep-manifest-*.md ]]; then
  echo "SKIP: $FILE is a log-sweep working file — self-exclusion applies"
  exit 0
fi

# Check file exists
if [ ! -f "$FILE" ]; then
  echo "ERROR: File not found: $FILE"
  exit 4
fi

# Check file is writable (header3) or readable (whole-file-by-mtime)
if [ "$MODE" = "header3" ] && [ ! -w "$FILE" ]; then
  echo "SKIP: $FILE is not writable"
  exit 0
fi

# Symlink-escape check
REAL=$(python3 -c "import os,sys; print(os.path.realpath(sys.argv[1]))" "$FILE")
FILEDIR=$(dirname "$FILE")
REAL_DIR=$(python3 -c "import os,sys; print(os.path.realpath(sys.argv[1]))" "$FILEDIR")

# We cannot determine the "allowed scope" here (log-archiver.sh takes absolute paths,
# not a scope root argument). The auditor performs scope validation before calling us.
# We perform a basic check: if REAL differs from FILE by more than trailing slashes,
# the file is accessed via symlink — log it for transparency but do not abort.
if [ "$REAL" != "$FILE" ]; then
  echo "NOTE: $FILE resolves via symlink to $REAL — proceeding (scope check was performed by auditor)"
fi

TODAY=$(date +%Y-%m-%d)

# ---------------------------------------------------------------------------
# MODE: header3 — rotate ### YYYY-MM-DD headers (Cat B)
# ---------------------------------------------------------------------------

if [ "$MODE" = "header3" ]; then

  if [ -z "$KEEP" ]; then
    echo "ERROR: --mode header3 requires KEEP argument"
    usage
  fi

  if ! [[ "$KEEP" =~ ^[0-9]+$ ]] || [ "$KEEP" -lt 1 ]; then
    echo "ERROR: KEEP must be a positive integer (got: $KEEP)"
    exit 5
  fi

  # Date-guard: skip if the FIRST dated ### header is today (file actively being written)
  FIRST_DATE=$(grep -m1 -oE "^### [0-9]{4}-[0-9]{2}-[0-9]{2}" "$FILE" 2>/dev/null | awk '{print $2}' || true)
  if [ "$FIRST_DATE" = "$TODAY" ]; then
    echo "SKIP: $FILE — first ### header is today ($TODAY) — file actively being written"
    exit 0
  fi

  # Count total ### YYYY-MM-DD entries
  TOTAL=$(grep -cE "^### [0-9]{4}-[0-9]{2}-[0-9]{2}" "$FILE" 2>/dev/null || echo 0)

  if [ "$TOTAL" -le "$KEEP" ]; then
    echo "BELOW_THRESHOLD: $FILE — $TOTAL entries ≤ KEEP=$KEEP, nothing to archive"
    exit 0
  fi

  ARCHIVE_COUNT=$(( TOTAL - KEEP ))

  # Extract the date of the OLDEST (first) entry that will be archived
  # The bottom KEEP entries stay; the top ARCHIVE_COUNT entries are archived.
  OLDEST_DATE=$(grep -oE "^### [0-9]{4}-[0-9]{2}-[0-9]{2}" "$FILE" 2>/dev/null | head -"$ARCHIVE_COUNT" | awk '{print $2}' | head -1 || true)

  if [ -z "$OLDEST_DATE" ]; then
    echo "ERROR: Could not derive archive date from headers in $FILE"
    exit 6
  fi

  ARCHIVE_YYYYMM="${OLDEST_DATE:0:7}"   # YYYY-MM
  BASEPATH="${FILE%.md}"
  ARCHIVE_FILE="${BASEPATH}-archive-${ARCHIVE_YYYYMM}.md"

  # Check idempotency: if archive file already contains the same oldest header, skip
  if [ -f "$ARCHIVE_FILE" ]; then
    if grep -qF "### $OLDEST_DATE" "$ARCHIVE_FILE" 2>/dev/null; then
      echo "IDEMPOTENT: $FILE — oldest archived entry ### $OLDEST_DATE already in $ARCHIVE_FILE — skipping"
      exit 0
    fi
  fi

  # Split the file:
  # - Find the line number of the (ARCHIVE_COUNT + 1)-th ### header — that's where the KEEP section begins
  SPLIT_LINE=$(grep -nE "^### [0-9]{4}-[0-9]{2}-[0-9]{2}" "$FILE" | awk -F: "NR==$(( ARCHIVE_COUNT + 1 )) {print \$1}")

  if [ -z "$SPLIT_LINE" ]; then
    echo "ERROR: Could not determine split line in $FILE (expected $((ARCHIVE_COUNT + 1)) entries)"
    exit 7
  fi

  LINES_BEFORE=$(wc -l < "$FILE" | tr -d ' ')

  # Append archived portion to archive file
  head -n $(( SPLIT_LINE - 1 )) "$FILE" >> "$ARCHIVE_FILE"

  # Overwrite source file with kept portion
  tail -n +"$SPLIT_LINE" "$FILE" > "${FILE}.tmp"
  mv "${FILE}.tmp" "$FILE"

  LINES_AFTER=$(wc -l < "$FILE" | tr -d ' ')

  echo "ARCHIVED: $FILE — archived $ARCHIVE_COUNT entries to $ARCHIVE_FILE (${LINES_BEFORE} → ${LINES_AFTER} lines)"
  exit 0
fi

# ---------------------------------------------------------------------------
# MODE: whole-file-by-mtime — age-based whole-file move (Cat D)
# ---------------------------------------------------------------------------

if [ "$MODE" = "whole-file-by-mtime" ]; then

  NOW=$(python3 -c "import time; print(int(time.time()))")
  MTIME=$(python3 -c "import os,sys; print(int(os.stat(sys.argv[1]).st_mtime))" "$FILE")
  ATIME=$(python3 -c "import os,sys; print(int(os.stat(sys.argv[1]).st_atime))" "$FILE")

  MTIME_AGE_SECS=$(( NOW - MTIME ))
  ATIME_AGE_SECS=$(( NOW - ATIME ))

  SIXTY_DAYS=$(( 60 * 86400 ))
  THIRTY_DAYS=$(( 30 * 86400 ))
  ONE_HOUR=3600

  # Skip if modified within last hour (actively being written this session)
  if [ "$MTIME_AGE_SECS" -lt "$ONE_HOUR" ]; then
    echo "SKIP: $FILE — modified within last hour (actively being written)"
    exit 0
  fi

  # Skip if not old enough
  if [ "$MTIME_AGE_SECS" -le "$SIXTY_DAYS" ]; then
    echo "SKIP: $FILE — mtime only $(( MTIME_AGE_SECS / 86400 )) days ago (threshold: 60 days)"
    exit 0
  fi

  if [ "$ATIME_AGE_SECS" -le "$THIRTY_DAYS" ]; then
    echo "SKIP: $FILE — atime only $(( ATIME_AGE_SECS / 86400 )) days ago (threshold: 30 days idle)"
    exit 0
  fi

  # Compute destination: audits/working/archive/YYYY-MM/{basename}
  # YYYY-MM comes from mtime
  MTIME_YYYYMM=$(python3 -c "import datetime,os,sys; t=os.stat(sys.argv[1]).st_mtime; print(datetime.datetime.fromtimestamp(t).strftime('%Y-%m'))" "$FILE")

  # Destination dir: replace the file's parent with archive/YYYY-MM
  # Strategy: find the audits/working/ ancestor and build dest relative to it
  PARENT=$(dirname "$FILE")
  DEST_DIR="${PARENT}/archive/${MTIME_YYYYMM}"

  mkdir -p "$DEST_DIR"

  DEST="${DEST_DIR}/${BASENAME}"

  # Refuse to overwrite an existing file at destination
  if [ -f "$DEST" ]; then
    echo "ERROR: Destination already exists: $DEST — will not overwrite. Move or rename manually."
    exit 8
  fi

  mv "$FILE" "$DEST"

  echo "MOVED: $FILE → $DEST"
  exit 0
fi

# ---------------------------------------------------------------------------
# Unknown mode
# ---------------------------------------------------------------------------

echo "ERROR: Unknown --mode '$MODE'. Valid modes: header3, whole-file-by-mtime"
exit 9
