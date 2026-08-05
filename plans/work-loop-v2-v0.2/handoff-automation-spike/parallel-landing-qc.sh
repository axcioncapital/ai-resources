#!/bin/bash
# Both-sides-present integration QC for the two-worktree parallel proof (SPIKE).
#
# Runs against the integration checkout AFTER both branches have been landed one
# at a time. The playbook's § 5.6 point is the whole reason this exists: grepping
# for leftover conflict markers proves clean *resolution*, and says nothing about
# whether a result was silently dropped. So the first four assertions are
# presence assertions — each task's deliverable, each task's closing record —
# and the marker sweeps come after, as the secondary check they are.
#
# Usage: parallel-landing-qc.sh --integration <abs-path> [--base <sha>]
#          [--marker-alpha <s>] [--marker-beta <s>]
# Exit: 0 when every assertion passed, 1 otherwise.

set -uo pipefail

INTEGRATION=""; BASE=""
MK_ALPHA="WL2-ALPHA-UNIQUE-MARKER-7Q4X"
MK_BETA="WL2-BETA-UNIQUE-MARKER-3M8P"

while [ $# -gt 0 ]; do
  case "$1" in
    --integration)  INTEGRATION="${2:-}"; shift 2 ;;
    --base)         BASE="${2:-}"; shift 2 ;;
    --marker-alpha) MK_ALPHA="${2:-}"; shift 2 ;;
    --marker-beta)  MK_BETA="${2:-}"; shift 2 ;;
    *) printf 'unknown argument: %s\n' "$1" >&2; exit 2 ;;
  esac
done
[ -n "$INTEGRATION" ] || { echo "--integration is required" >&2; exit 2; }

FAILED=0
check() { if [ "$2" -eq 0 ]; then printf 'PASS  %-4s %s\n' "$1" "$3"; else printf 'FAIL  %-4s %s\n' "$1" "$3"; FAILED=1; fi; }

FIX="$INTEGRATION/plans/work-loop-v2-v0.2/handoff-automation-spike/sandbox-fixtures"
SA="$INTEGRATION/logs/work-loop/wl2-alpha.md"
SB="$INTEGRATION/logs/work-loop/wl2-beta.md"

# --- B1/B2: both deliverables survived the landing --------------------------
grep -qF "$MK_ALPHA" "$FIX/alpha-result.md" 2>/dev/null; check B1 $? "alpha deliverable present in integration with its marker"
grep -qF "$MK_BETA"  "$FIX/beta-result.md"  2>/dev/null; check B2 $? "beta deliverable present in integration with its marker"

# --- B3/B4: both closing records survived ------------------------------------
closing_ok() { # state file -> 0 when it is a core § 4 closing record at turn: operator
  [ -f "$1" ] || return 1
  awk 'NR<=6 && /^turn: operator$/ {t=1} END {exit !t}' "$1" || return 1
  for h in '^## Outcome$' '^## Decisions that matter$' '^## Evidence$' '^## Accepted limitations$'; do
    grep -qE "$h" "$1" || return 1
  done
  return 0
}
closing_ok "$SA"; check B3 $? "alpha closing record present in integration (turn: operator + the four headings)"
closing_ok "$SB"; check B4 $? "beta closing record present in integration (turn: operator + the four headings)"

# --- B5: neither task's history was dropped by the second merge -------------
# A merge that resolves by taking one side wholesale loses the other's commits
# without leaving a conflict marker behind. Reachability is the check that sees it.
reach=0
for c in $(git -C "$INTEGRATION" rev-list --all --grep='wl2-alpha' 2>/dev/null | head -5); do :; done
git -C "$INTEGRATION" merge-base --is-ancestor wl2/alpha HEAD 2>/dev/null || reach=1
git -C "$INTEGRATION" merge-base --is-ancestor wl2/beta  HEAD 2>/dev/null || reach=1
check B5 "$reach" "both branch tips are ancestors of the integration HEAD — no side was dropped"

# --- B6: no conflict markers left anywhere in the landed paths --------------
conf=0
grep -rqE '^(<<<<<<<|>>>>>>>|=======)$' "$FIX" "$SA" "$SB" 2>/dev/null && conf=1
check B6 "$conf" "no conflict markers in the landed deliverables or state files"

# --- B7: no stale in-flight coordination markers ----------------------------
inflight=0
grep -rqF '[IN FLIGHT]' "$FIX" "$SA" "$SB" 2>/dev/null && inflight=1
check B7 "$inflight" "no stale [IN FLIGHT] markers in the landed paths"

# --- B8: the integration tree is clean after landing ------------------------
dirty="$(git -C "$INTEGRATION" status --porcelain 2>/dev/null | wc -l | tr -d ' ')"
[ "$dirty" -eq 0 ]; check B8 $? "integration working tree clean after landing (dirty=$dirty)"

# --- B9: the landing advanced the integration branch ------------------------
if [ -n "$BASE" ]; then
  head="$(git -C "$INTEGRATION" rev-parse HEAD 2>/dev/null)"
  [ "$head" != "$BASE" ]; check B9 $? "integration HEAD advanced past the base (base=${BASE:0:7} head=${head:0:7})"
fi

echo
[ "$FAILED" -eq 0 ] && { echo "RESULT: integration QC passed"; exit 0; }
echo "RESULT: integration QC failed"; exit 1
