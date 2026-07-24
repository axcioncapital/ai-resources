#!/usr/bin/env bash
# check-append-order.sh <log-path> <header-regex>
#
# Commit-boundary guard for APPEND-ONLY, NEWEST-LAST logs (session-notes.md, decisions.md,
# usage-log.md). It enforces one invariant on the STAGED content of <log-path>:
#
#     Every newly-added dated entry whose date is >= the newest RETAINED entry's date
#     must sit BELOW every retained entry (i.e. be appended at the end, not prepended).
#
# WHY THIS SHAPE, and not "the file is sorted":
#   - It reads the STAGED diff, so it fires exactly where the recorded failure escaped —
#     a mid-session COMMIT (c3d5fe7 prepended decisions.md at line 2 and shipped), which a
#     wrap-time check runs too late to stop.
#   - It checks EACH added entry, so two entries appended in one session with the *earlier*
#     one misplaced is caught even when the last entry is correct.
#   - It only constrains NEW entries against RETAINED ones, so pre-existing interior disorder
#     (e.g. usage-log.md's older-dated top entry) never trips it.
#   - The ">= newest retained date" gate means an in-place edit of an OLD interior entry
#     (older date) is ignored — only a plausibly-new newest entry is position-checked — so a
#     legitimate body edit or typo fix does not false-positive.
#
# Reads git state only (staged blob + cached diff); never touches the working tree.
# Exit 1 on violation (naming the misplaced entries); exit 0 otherwise. Not gated by set -e
# in the caller — the pre-commit hook invokes it under `if ! ...`.
#
# KNOWN LIMIT: editing a dated header line *in place* to a date >= the newest retained date,
# at an interior position, would be flagged. That does not happen in normal use of these three
# append-only logs (entries are appended and left immutable); `git commit --no-verify` escapes it.

set -uo pipefail

LOG_PATH="${1:?usage: check-append-order.sh <log-path> <header-regex>}"
HEADER_RE="${2:?usage: check-append-order.sh <log-path> <header-regex>}"
DATE_RE='[0-9]{4}-[0-9]{2}-[0-9]{2}'

# Staged content of the file (what is about to be committed). Empty → not staged → nothing to do.
staged="$(git show ":$LOG_PATH" 2>/dev/null || true)"
[ -n "$staged" ] || exit 0

# Header lines actually ADDED by this commit (staged-diff '+' lines that match the header regex).
added="$(git diff --cached -U0 -- "$LOG_PATH" | grep -E '^\+' | sed 's/^+//' | grep -E "$HEADER_RE" || true)"
[ -n "$added" ] || exit 0   # this commit adds no dated header → nothing to check

# Pass 1 — over the staged headers, find the newest RETAINED date and the last RETAINED line.
max_retained_date=""
last_retained_line=0
while IFS= read -r hline; do
    lineno="${hline%%:*}"
    text="${hline#*:}"
    if printf '%s\n' "$added" | grep -Fxq "$text"; then
        continue   # this header is one of the added ones — handled in pass 2
    fi
    [ "$lineno" -gt "$last_retained_line" ] && last_retained_line="$lineno"
    hdate="$(printf '%s' "$text" | grep -oE "$DATE_RE" | head -1)"
    if [ -z "$max_retained_date" ] || [[ "$hdate" > "$max_retained_date" ]]; then
        max_retained_date="$hdate"
    fi
done < <(printf '%s\n' "$staged" | grep -nE "$HEADER_RE")

# No retained headers (brand-new file) → the added entries define their own order; nothing to check.
[ -n "$max_retained_date" ] || exit 0

# Pass 2 — any ADDED header dated >= newest-retained that sits ABOVE the last retained header
# is a prepend/misplacement.
violation=0
offenders=""
while IFS= read -r hline; do
    lineno="${hline%%:*}"
    text="${hline#*:}"
    printf '%s\n' "$added" | grep -Fxq "$text" || continue
    hdate="$(printf '%s' "$text" | grep -oE "$DATE_RE" | head -1)"
    # date >= max_retained_date  <=>  NOT (date < max_retained_date)
    if ! [[ "$hdate" < "$max_retained_date" ]] && [ "$lineno" -lt "$last_retained_line" ]; then
        violation=1
        offenders="${offenders}    misplaced (added above an existing entry): ${text}"$'\n'
    fi
done < <(printf '%s\n' "$staged" | grep -nE "$HEADER_RE")

if [ "$violation" -ne 0 ]; then
    echo "check-append-order: BLOCKED — $LOG_PATH: a newly-added entry is placed above existing entries." >&2
    echo "  These logs are append-only and newest-LAST; add new entries at the END." >&2
    printf '%s' "$offenders" >&2
    exit 1
fi
exit 0
