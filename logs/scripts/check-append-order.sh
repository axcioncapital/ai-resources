#!/usr/bin/env bash
# check-append-order.sh <log-path> <header-regex>
#
# Commit-boundary guard for APPEND-ONLY, NEWEST-LAST logs (session-notes.md, decisions.md,
# usage-log.md). It enforces ONE POSITIONAL invariant on the STAGED content of <log-path>:
#
#     Every dated header ADDED by this commit must sit BELOW every RETAINED dated header.
#     Violation iff any added header's line number < the last retained header's line number.
#
# The check is PURELY POSITIONAL — it does NOT look at the entry's DATE and does NOT identify
# additions by header TEXT. Both of those were weaker forms that let real prepends through
# (corrected 2026-07-25, Codex R3):
#   - The archive hazard is about POSITION: check-archive.sh treats the TOP of the file as the
#     OLDEST entry. A prepended entry — WHATEVER its date — sits where the newest can be
#     archived. A date gate ("only check entries dated >= the newest retained") let a BACKDATED
#     prepend slip through, even though it is exactly the hazardous position.
#   - Additions are identified by DIFF POSITION (the new-file line number of each added '+'
#     header line), never by matching header text. Text-identity could not tell a freshly
#     prepended entry from a pre-existing entry with an IDENTICAL header, and let duplicates
#     through.
#
# WHY A COMMIT-BOUNDARY CHECK, not a wrap-time one, and not "is the whole file sorted":
#   - It reads the STAGED diff, so it fires exactly where the recorded failure escaped —
#     a mid-session COMMIT (c3d5fe7 prepended decisions.md at line 2 and shipped), which a
#     wrap-time check runs too late to stop.
#   - It checks EACH added header's position, so two entries appended in one session with the
#     *earlier* one prepended is caught even when the last entry is correctly at the tail.
#   - It only constrains NEW headers against RETAINED ones, so pre-existing interior disorder
#     (e.g. usage-log.md's older-dated top entry) never trips it.
#
# Reads git state only (staged blob + cached diff); never touches the working tree.
# Exit 1 on violation (naming the misplaced entries); exit 0 otherwise.
#
# KNOWN LIMIT: editing a dated header line *in place* at an interior position registers as an
# added header above the tail and would be flagged. These append-only logs are not edited that
# way in normal use (entries are appended and left immutable); `git commit --no-verify` escapes.

set -uo pipefail

LOG_PATH="${1:?usage: check-append-order.sh <log-path> <header-regex>}"
HEADER_RE="${2:?usage: check-append-order.sh <log-path> <header-regex>}"

# Staged content of the file (what is about to be committed). Empty → not staged → nothing to do.
staged="$(git show ":$LOG_PATH" 2>/dev/null || true)"
[ -n "$staged" ] || exit 0

# All header lines in the staged blob, as "lineno:text". grep -n line numbers are the NEW-FILE
# line numbers — identical to the +side line numbers reported by `git diff --cached`.
staged_headers="$(printf '%s\n' "$staged" | grep -nE "$HEADER_RE" || true)"
[ -n "$staged_headers" ] || exit 0   # no dated headers at all → nothing to order

# ADDED header positions: parse `git diff --cached -U0` and record the new-file line number of
# every '+' line that is a dated header. Walk each hunk from its +newstart, advancing the
# new-file counter on '+' content lines only. With -U0 there are no context lines, and '-'
# (deletion) lines do not advance the new-file side. Identity is POSITION, never text.
added_positions=""   # newline-separated new-file line numbers of added headers
cur=0
while IFS= read -r dl; do
    case "$dl" in
        @@*)
            # @@ -a,b +c,d @@ [section]  →  c is the new-file start of this hunk.
            rest="${dl#*+}"          # drop through the first '+' (start of the +range)
            rest="${rest%% *}"       # "c,d" or "c"
            cur="${rest%%,*}"        # "c"
            ;;
        '+++'*) : ;;                  # file header line ("+++ b/..."), not content
        '+'*)
            text="${dl#+}"
            if printf '%s\n' "$text" | grep -qE "$HEADER_RE"; then
                added_positions="${added_positions}${cur}"$'\n'
            fi
            cur=$((cur + 1))
            ;;
        '-'*) : ;;                    # deletion — new-file side does not advance
        *) : ;;                       # (no context lines under -U0; "\ No newline" etc. ignored)
    esac
done < <(git diff --cached -U0 -- "$LOG_PATH")

# No dated header added by this commit → nothing to check (e.g. an in-place body edit).
[ -n "$added_positions" ] || exit 0

# RETAINED = staged headers whose line number is NOT an added position. Find the last one.
last_retained_line=0
have_retained=0
while IFS= read -r sh; do
    [ -n "$sh" ] || continue
    lineno="${sh%%:*}"
    if printf '%s\n' "$added_positions" | grep -Fxq "$lineno"; then
        continue   # this staged header line was added by this commit
    fi
    have_retained=1
    [ "$lineno" -gt "$last_retained_line" ] && last_retained_line="$lineno"
done <<EOF
$staged_headers
EOF

# Brand-new file (every header added, nothing retained) → the added entries define their own
# order; there is nothing prior to sit below. Nothing to enforce.
[ "$have_retained" -eq 1 ] || exit 0

# Any ADDED header positioned ABOVE the last retained header is a prepend/misplacement.
violation=0
offenders=""
while IFS= read -r pos; do
    [ -n "$pos" ] || continue
    if [ "$pos" -lt "$last_retained_line" ]; then
        text="$(printf '%s\n' "$staged_headers" | awk -F: -v p="$pos" '$1==p{sub(/^[0-9]+:/,""); print; exit}')"
        violation=1
        offenders="${offenders}    misplaced (added above an existing entry): ${text}"$'\n'
    fi
done <<EOF
$added_positions
EOF

if [ "$violation" -ne 0 ]; then
    echo "check-append-order: BLOCKED — $LOG_PATH: a newly-added entry is placed above existing entries." >&2
    echo "  These logs are append-only and newest-LAST; add new entries at the END." >&2
    printf '%s' "$offenders" >&2
    exit 1
fi
exit 0
