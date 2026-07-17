#!/usr/bin/env bash
# check-duplicate-session-headers.sh — post-merge collision detector for the union-merged logs.
#
# WHY. logs/session-notes.md, logs/decisions.md and logs/coaching-data.md carry `merge=union`
# (see ../../.gitattributes) so parallel worktree branches stop conflicting at merge. Union always
# keeps BOTH blocks — correct for two DIFFERENT sessions, but it ALSO silently concatenates two
# sessions that collided under the SAME marker header (the rare stale-worktree case). A plain merge
# conflict used to catch that by accident; union removes that forcing function. This restores it
# mechanically: a duplicate session-header line is unambiguous evidence of a marker collision,
# because the marker is unique per session — two different sessions never share a full header line.
#
# USAGE. Run AFTER a merge into main (wired into /close-worktree-session Step 4):
#     check-duplicate-session-headers.sh [LOGS_DIR]
# LOGS_DIR defaults to ./logs. Exit 0 = clean; exit 1 = duplicate header(s) found (STOP and review).
#
# It matches only DATE-BEARING markdown headers (`##`/`###` … YYYY-MM-DD), so ordinary in-block
# headings (`## Summary`, `## Decisions Made`) never trip it. Verified by execution before shipping.
set -u

LOGS_DIR="${1:-logs}"
FILES="session-notes.md decisions.md coaching-data.md"
found=0

for f in $FILES; do
  path="$LOGS_DIR/$f"
  [ -f "$path" ] || continue
  dups="$(grep -E '^#{2,3} .*[0-9]{4}-[0-9]{2}-[0-9]{2}' "$path" | sort | uniq -d)"
  if [ -n "$dups" ]; then
    found=1
    echo "DUPLICATE session header(s) in $path — a union merge concatenated a marker collision:"
    printf '%s\n' "$dups" | sed 's/^/  /'
  fi
done

if [ "$found" -ne 0 ]; then
  echo ""
  echo "STOP: a duplicate header means two sessions share one marker. Review before proceeding —"
  echo "do NOT tear down the worktree; the collision needs both sides intact to disambiguate."
  exit 1
fi

echo "OK: no duplicate session headers in the union-merged logs ($LOGS_DIR)."
exit 0
