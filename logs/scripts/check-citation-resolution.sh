#!/usr/bin/env bash
# check-citation-resolution.sh — do the `file:line` citations in a log actually resolve?
#
# ADVISORY RULE: this script REPORTS. It never writes, never blocks, never exits non-zero
# on a finding. Nothing gates on it. Exit 1 means the script itself failed to run.
#
# ── WHAT IT CHECKS, AND WHAT IT DELIBERATELY DOES NOT ────────────────────────────────
# Checks:      that a cited `path:NNN` (or `path:NNN-MMM`) points at a file that EXISTS
#              and is LONG ENOUGH to have that line.
# Does NOT:    verify that the cited line SAYS what the citing entry claims it says.
#
# That ceiling is deliberate and was scored at the gate. Of the five recorded instances of
# the defect this comes from ("a queued fix instruction is an unverified claim" —
# improvement-log.md, 2026-07-14 entry), a PRESENCE check would have caught zero: every
# instance carried a plausible-looking citation that was simply wrong. Resolution is the
# part a machine can actually settle. Semantic truth still needs a reader.
#
# ── WHY IT IS NOT WIRED TO ANYTHING (OP-11: record the tension loudly) ────────────────
# Registered in no settings.json event and called by no command. That is a decision, not an
# oversight: hook wiring in this workspace is unversioned (open HIGH, mission thread 3), so a
# new hook would inherit that defect the day it shipped. But an unwired guard is its own known
# failure mode here — cf. `F-11 — two dead guards`, and `warn-settings-change.sh`, deleted
# 2026-07-19 as "an unwired guard that failed open".
#
# REVISIT TRIGGER (concrete, per /risk-check 2026-07-19 PROCEED-WITH-CAUTION mitigation 2):
#   Wire this into /friday-act's log-hygiene pass at the NEXT monthly-tier /friday-checkup,
#   OR delete it. If neither has happened by the following monthly checkup, delete it —
#   do not let it sit unwired for a third cycle.
#   Gate report: audits/risk-checks/2026-07-19-citation-resolution-scan-logs-scripts.md
#
# ── SEARCH-SCOPE WARNING (this script's own blind spots, stated in its output) ────────
# Uses `command grep`, NOT the ambient shell `grep`. The harness replaces grep with a
# .gitignore-honouring ugrep, which silently returns nothing for ignored paths — the trap
# documented at docs/audit-discipline.md:37 and guarded by logs/scripts/search-canary.sh.
# A scan that reported false absences would be worse than no scan.
#
# Usage: bash logs/scripts/check-citation-resolution.sh [logfile ...]
#        defaults to logs/improvement-log.md
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
WORKSPACE_ROOT="$(dirname "$REPO_ROOT")"
cd "$REPO_ROOT" || { echo "FATAL: cannot cd to repo root" >&2; exit 1; }

TARGETS=("$@")
[ ${#TARGETS[@]} -eq 0 ] && TARGETS=("logs/improvement-log.md")

TOTAL=0; UNRESOLVED=0; SKIPPED=0

for LOGFILE in "${TARGETS[@]}"; do
  if [ ! -f "$LOGFILE" ]; then
    echo "SKIP    $LOGFILE — not found"
    continue
  fi

  # Citations: path.ext:NNN or path.ext:NNN-MMM. For a range we validate the UPPER bound —
  # it is the stricter test, and 17 range citations are live in improvement-log.md today
  # (e.g. `prime.md:206-224` at :37). Matching only the start line would pass a range whose
  # end has fallen off the file, which is the exact staleness this exists to catch.
  while IFS= read -r CITATION; do
    TOTAL=$((TOTAL + 1))
    CPATH="${CITATION%%:*}"
    LINESPEC="${CITATION#*:}"
    WANT="${LINESPEC##*-}"          # upper bound for a range; the number itself otherwise

    # Resolve against repo root first, then workspace root (citations appear in both
    # `logs/x.md:12` and `ai-resources/logs/x.md:12` forms).
    RESOLVED=""
    for BASE in "$REPO_ROOT" "$WORKSPACE_ROOT"; do
      [ -f "$BASE/$CPATH" ] && { RESOLVED="$BASE/$CPATH"; break; }
    done

    if [ -z "$RESOLVED" ]; then
      # Fall back to a WORKSPACE-WIDE search, matching on the full cited suffix.
      #
      # Searching only this repo produced a 5-in-7 false-positive rate on first run:
      # citations like `vault/blueprint/blueprint.md:105` name real files that live in
      # sibling trees (knowledge bases, other projects), and calling them MISSING would
      # train the reader to ignore the output — the pencil-whip failure this check exists
      # to avoid. Match on the whole cited path, not just the basename, so
      # `vault/components/hooks.md` cannot be satisfied by an unrelated `hooks.md`.
      #
      # Resolve ONLY on exactly one match. Several matches means UNCHECKED, never a guess:
      # three copies of check-foreign-staging.sh live here, each with the cited predicate
      # at a different line, so picking one would be a coin flip dressed as a result.
      BASENAME="${CPATH##*/}"
      MATCHES=$(command find "$WORKSPACE_ROOT" -name "$BASENAME" -type f \
                  -not -path "*/.git/*" -not -path "*/node_modules/*" 2>/dev/null \
                | command grep -E "${CPATH}$")
      # NOTE the anchor is `${CPATH}$` (ends-with), NOT `(^|/)${CPATH}$` (ends-with-on-a-
      # component-boundary). This workspace has directories containing SPACES — e.g.
      # `projects/project-planning/Project Plans/...` — and the citation extractor's
      # character class cannot include a space without over-capturing surrounding prose.
      # It therefore truncates such a path at the space, yielding `Plans/system-owner-v2/…`,
      # which is a real suffix of a real file but does not start on a component boundary.
      # The boundary anchor reported that as MISSING: a phantom finding manufactured by the
      # extractor, not a defect in the log. Precision is retained because the ENTIRE cited
      # string must still appear at the end of the path (verified by test D: a citation
      # naming a directory that does not exist is still not satisfied by a same-named file
      # elsewhere).
      COUNT=$(printf '%s\n' "$MATCHES" | command grep -c .)
      if [ "$COUNT" -eq 1 ]; then
        RESOLVED="$MATCHES"
      elif [ "$COUNT" -eq 0 ]; then
        echo "MISSING $CITATION — no file matching that path anywhere in the workspace"
        UNRESOLVED=$((UNRESOLVED + 1)); continue
      else
        echo "AMBIG   $CITATION — $COUNT files match this path; not guessed"
        SKIPPED=$((SKIPPED + 1)); continue
      fi
    fi

    HAVE=$(wc -l < "$RESOLVED" | tr -d ' ')
    if [ "$WANT" -gt "$HAVE" ] 2>/dev/null; then
      echo "STALE   $CITATION — file has $HAVE lines"
      UNRESOLVED=$((UNRESOLVED + 1))
    fi
  done < <(command grep -ohE '[A-Za-z0-9._/-]+\.(md|sh|json|ya?ml|py|ts|js):[0-9]+(-[0-9]+)?' "$LOGFILE" | sort -u)
done

echo
echo "── $TOTAL citations checked, $UNRESOLVED unresolved, $SKIPPED unchecked ──"
echo "SCOPE LIMITS — read before treating a clean run as an all-clear:"
echo "  · Checks that a citation RESOLVES, not that the cited line says what is claimed."
echo "  · A bare filename is resolved ONLY when exactly one file in the repo carries that"
echo "    name; when several do, it is reported UNCHECKED (AMBIG) and never guessed."
echo "  · Only these extensions: .md .sh .json .yaml .yml .py .ts .js"
echo "  · Line numbers shift as files are edited; a clean run is true only at this commit."
exit 0
