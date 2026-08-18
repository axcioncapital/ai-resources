#!/usr/bin/env bash
# research-route-memo-check.sh — structural floor for a Standard-route research memo.
#
# What it is for: a Standard memo can look finished while quietly asserting something no
# source supports. Each rule below closes one of those routes. It checks STRUCTURE — that
# claims carry sources, that sources carry dates, that evidence and inference stay apart,
# and that a memo cannot mark itself complete over an unresolved claim or a live Deep
# trigger. It does NOT judge whether the analysis is any good; nothing automated can.
#
# Usage:  research-route-memo-check.sh --memo <path>
#
# Prints `verdict: PASS` (exit 0) or `verdict: REJECT` (exit 1) followed by one
# `reason:` line per failure. Exits 2 on a usage error.

set -u

die() { printf 'ERROR: %s\n' "$1" >&2; exit 2; }

memo=""
while [ $# -gt 0 ]; do
  case "$1" in
    --memo) [ $# -ge 2 ] || die "--memo needs a path"; memo="$2"; shift 2 ;;
    *) die "unknown argument: $1" ;;
  esac
done
[ -n "$memo" ] || die "--memo is required"
[ -r "$memo" ] || die "memo is not readable: $memo"

reasons=()
add() { reasons+=("$1"); }

# --- the claim blocks -------------------------------------------------------
# A claim block runs from its `### C<n> — ` heading to the next `###`/`##` heading.
claim_ids="$(grep -oE '^### C[0-9]+ ' "$memo" | tr -d '#' | tr -d ' ')"

if [ -z "$claim_ids" ]; then
  add "the memo declares no claims — a Standard memo states its claims under '## Claims' as '### C1 — ...'"
fi

for id in $claim_ids; do
  block="$(awk -v id="$id" '
    /^#{2,3} / { inside = (index($0, "### " id " ") == 1) }
    inside { print }
  ' "$memo")"

  class="$(printf '%s\n' "$block" | sed -n 's/^Class: *//p' | head -1)"

  case "$class" in
    SUPPORTED|PROXY-SUPPORTED|ILLUSTRATIVE-ONLY|NOT-SUPPORTED) ;;
    "") add "$id has no Class: line — every claim carries one of the four permission classes" ;;
    *)  add "$id has an unknown Class '$class' — use SUPPORTED, PROXY-SUPPORTED, ILLUSTRATIVE-ONLY or NOT-SUPPORTED" ;;
  esac

  sources="$(printf '%s\n' "$block" | grep -c '^Source: ' || true)"

  # A claim that is not NOT-SUPPORTED asserts something, so it must map to evidence.
  if [ "$class" != "NOT-SUPPORTED" ] && [ "$sources" -eq 0 ]; then
    add "$id is classed '$class' but maps to no Source line — a load-bearing claim without a mapped source cannot be graded"
  fi

  # Every source line must carry a date or an explicit undated marker.
  while IFS= read -r line; do
    [ -n "$line" ] || continue
    if ! printf '%s' "$line" | grep -qE '(—|--) *Date: *[^ ]'; then
      add "$id has a Source with no Date: field — give the source's date or the explicit marker 'undated'"
    fi
  done < <(printf '%s\n' "$block" | grep '^Source: ' || true)

  # Evidence and inference must not be collapsed into the claim block.
  if printf '%s\n' "$block" | grep -qF '[INFERENCE]'; then
    add "$id carries an [INFERENCE] marker inside the claim block — inference belongs under '## Inference', separate from the evidence it rests on"
  fi
done

# --- completion -------------------------------------------------------------
status="$(sed -n 's/^Status: *//p' "$memo" | head -1)"
triggers="$(sed -n 's/^Deep triggers: *//p' "$memo" | head -1)"

case "$status" in
  COMPLETE|ESCALATED-TO-DEEP) ;;
  "") add "the memo has no Status: line — a Standard memo declares COMPLETE or ESCALATED-TO-DEEP" ;;
  *)  add "unknown Status '$status' — use COMPLETE or ESCALATED-TO-DEEP" ;;
esac

if [ -z "$triggers" ]; then
  add "the memo has no 'Deep triggers:' line — state the trigger that fired, or 'none'"
elif [ "$status" = "COMPLETE" ] && [ "$triggers" != "none" ]; then
  add "Status is COMPLETE while a Deep trigger is live ('$triggers') — escalation is one way; set ESCALATED-TO-DEEP"
fi

if [ "$status" = "COMPLETE" ] && printf '%s' "$claim_ids" | grep -q .; then
  for id in $claim_ids; do
    c="$(awk -v id="$id" '
      /^#{2,3} / { inside = (index($0, "### " id " ") == 1) }
      inside { print }
    ' "$memo" | sed -n 's/^Class: *//p' | head -1)"
    if [ "$c" = "NOT-SUPPORTED" ]; then
      add "Status is COMPLETE while $id is NOT-SUPPORTED — an unresolved load-bearing claim cannot be completed as Standard work"
    fi
  done
fi

# --- the verb rule ----------------------------------------------------------
# A SUPPORTED verb over evidence that never reached SUPPORTED overstates the memo.
if ! grep -qE '^Class: SUPPORTED *$' "$memo"; then
  answer="$(awk '
    /^```/ { fence = !fence }
    !fence && /^## / { inside = (index($0, "## Answer") == 1) }
    inside { print }
  ' "$memo")"
  if printf '%s' "$answer" | grep -qiE '\b(establishes|confirms|demonstrates)\b'; then
    add "the Answer uses a SUPPORTED-only verb (establishes / confirms / demonstrates) but no claim reached SUPPORTED — use the verb list for the class the evidence actually earned"
  fi
fi

# --- the closed seam --------------------------------------------------------
# Standard may compare interpretations; it may not promote one to governing authority.
# A mention that carries a negation is the memo declining to cross the line, which is fine.
while IFS= read -r line; do
  [ -n "$line" ] || continue
  printf '%s' "$line" | grep -qiE 'no house|not a house|do not|does not|never|cannot|not authoriz|await|forbid' \
    || add "the memo promotes an interpretation to a House View — Standard may compare readings but may not promote one; that authority contract does not exist yet"
done < <(grep -iE 'house[ -]?view' "$memo" || true)

# --- verdict ----------------------------------------------------------------
if [ "${#reasons[@]}" -eq 0 ]; then
  printf 'verdict: PASS\n'
  exit 0
fi

printf 'verdict: REJECT\n'
for r in "${reasons[@]}"; do printf 'reason: %s\n' "$r"; done
exit 1
