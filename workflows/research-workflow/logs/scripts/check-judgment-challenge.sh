#!/usr/bin/env bash
# check-judgment-challenge.sh — the independent-challenge gate on a Unit Judgment Brief.
#
# WHAT THIS IS FOR. The first judgment trial ran producer -> operator approval
# with NOTHING between them. A fresh-context reviewer returned findings naming
# evidence-permission breaches, and a bare `approved` reply promoted the brief
# anyway, carrying all of them into downstream authority including a live
# conflict with an unrevoked operator decision.
#
# This script is the machine-checkable half of the repair. It answers one
# question: HAS THE INDEPENDENT CHALLENGE BEEN RUN AGAINST THIS EXACT PROPOSAL,
# AND HAS EVERY REQUIRED-CHANGE FINDING BEEN DISPOSED OF DURABLY? It judges the
# challenge record's shape, its binding and its dispositions. It never judges
# analytical quality — that is the reviewer's job, and the reviewer is a human or
# a fresh-context agent, never this file.
#
# THE CHALLENGE RECORD. Derived, never passed: `-proposed.md` -> `-review.md`.
# The pairing is part of the contract and is not a caller's choice.
#
#   ---
#   unit: demo-unit
#   artifact: unit-judgment-brief-review
#   reviews: .../demo-unit-unit-judgment-brief-proposed.md
#   reviews_sha256: <sha256 of the proposal file, exactly as reviewed>
#   review_round: 1
#   status: findings-only
#   as_of: 2026-08-18
#   ---
#
#   ## Required-change findings
#
#   finding: F1
#   tags: permission-breach, decision-conflict: D-12
#   disposition: PENDING
#   reason:
#
# `findings: none` is the explicit empty ledger. An absent ledger is malformed —
# a reviewer that raised nothing must say so, because silence and omission read
# identically and only one of them is a review.
#
# ROUNDS ARE KEPT, NOT OVERWRITTEN. Before a new round is written, the current
# record is archived at `{base}-review-round-{N}.md`. That is not bookkeeping: a
# later reviewer writing the same sole path could otherwise replace a round-1
# permission breach with `findings: none`, and a gate reading only the current
# ledger would clear it. So this gate reads every archived round, and requires
# every finding id any of them raised to still appear in the current ledger —
# where the ordinary disposition rules then apply to it. An archive that is
# missing or mislabelled breaks the chain and is refused rather than assumed
# empty.
#
# THE TWO TERMINAL DISPOSITIONS, and why there are exactly two:
#
#   REVISED-AND-RE-REVIEWED  — raised in an earlier round, the proposal was
#                              revised, and THIS round confirms it resolved.
#                              Requires review_round >= 2, because nothing can
#                              have been re-reviewed in round 1.
#   OPERATOR-ACCEPTED        — the operator read it and accepts the brief as it
#                              stands, with reasons. REFUSED for a
#                              `permission-breach` finding: that is the exact
#                              laundering the first trial performed.
#
# PENDING (or an absent disposition) is the un-disposed state and never clears.
#
# RE-REVIEW IS MECHANICAL, NOT PROMISED. `reviews_sha256:` binds the record to the
# bytes that were actually reviewed. Revise the proposal and the binding breaks,
# so the challenge goes STALE and promotion refuses until a new round is run
# against the revised text. Nothing has to remember to ask for a re-review.
#
# VERDICTS, each with its own exit code so a caller can branch on which failure
# it hit rather than on prose:
#
#   3  NO-CHALLENGE                  — no readable review beside the proposal
#   4  STALE-CHALLENGE               — the review is bound to different bytes
#   5  MALFORMED-CHALLENGE           — the record's shape, status or a
#                                      disposition claim is wrong
#   6  UNRESOLVED-FINDING            — a required-change finding is not disposed
#   7  LAUNDERED-BREACH              — a permission breach was accepted by fiat
#   8  UNRESOLVED-DECISION-CONFLICT  — a conflict with an operator decision was
#                                      accepted with no decision named, or was
#                                      "resolved" by citing the very decision it
#                                      conflicts with
#   9  DROPPED-FINDING               — an earlier round raised a finding the
#                                      current ledger no longer carries
#  12  LOST-ROUND                    — an earlier round's record is missing or
#                                      mislabelled, so the chain cannot be read
#   0  CLEARED / SHAPE-OK
#
# Exit 10 is bad usage.
#
# Usage:
#   check-judgment-challenge.sh <path-to-proposed-brief> [--shape-only]
#
#   --shape-only   check that a challenge exists, is well formed and is bound to
#                  these exact bytes; do NOT require the findings to be disposed
#                  of yet. For the point in the flow where the reviewer has just
#                  reported and the operator has not decided.
#
# Regression coverage: logs/scripts/check-judgment-challenge.test.sh

set -uo pipefail

PROPOSED=""; SHAPE_ONLY=0

die() { printf 'STOP [%s] %s\n' "$1" "$2" >&2; exit "$1"; }

verdict() { # VERDICT code reason...
  local v="$1" code="$2"; shift 2
  printf 'verdict: %s\n' "$v"
  [ "$#" -gt 0 ] && printf 'reason: %s\n' "$*"
  exit "$code"
}

sha_of() { shasum -a 256 "$1" 2>/dev/null | cut -d' ' -f1; }

# ------------------------------------------------------------------ arguments
[ "$#" -ge 1 ] || die 10 "usage: check-judgment-challenge.sh <path-to-proposed-brief> [--shape-only]"
while [ "$#" -gt 0 ]; do
  case "$1" in
    --shape-only) SHAPE_ONLY=1; shift ;;
    -h|--help) sed -n '2,95p' "$0"; exit 0 ;;
    -*) die 10 "unknown argument '$1'" ;;
    *) [ -z "$PROPOSED" ] || die 10 "only one proposal path is accepted; got a second: $1"
       PROPOSED="$1"; shift ;;
  esac
done
[ -n "$PROPOSED" ] || die 10 "a path to the proposed brief is required"

case "$PROPOSED" in
  *-proposed.md) ;;
  *) die 10 "the challenge is derived from a proposal path ending '-proposed.md'; got: $PROPOSED" ;;
esac
[ -f "$PROPOSED" ] && [ -r "$PROPOSED" ] \
  || die 10 "no readable proposal at $PROPOSED — the challenge is checked against the proposal's bytes, so the proposal must be present"

BASE="${PROPOSED%-proposed.md}"
REVIEW="$BASE-review.md"

# ------------------------------------------------------------- 3. NO-CHALLENGE
if [ ! -f "$REVIEW" ] || [ ! -r "$REVIEW" ]; then
  verdict NO-CHALLENGE 3 "no readable challenge record at $REVIEW — this proposal has not been independently challenged, and an unchallenged brief may not be promoted"
fi

fm_value() { # file key -> value | ""
  awk -v key="$2" '
    NR==1 { if ($0 != "---") exit; inb=1; next }
    inb && $0 == "---" { exit }
    inb {
      if ($0 ~ "^" key ":[[:space:]]*") {
        sub("^" key ":[[:space:]]*", "")
        sub(/[[:space:]]+$/, "")
        print
        exit
      }
    }
  ' "$1"
}

head -1 "$REVIEW" | grep -q '^---$' \
  || verdict MALFORMED-CHALLENGE 5 "the challenge record has no frontmatter block — the first line of $REVIEW must be '---'"

R_ARTIFACT="$(fm_value "$REVIEW" artifact)"
R_SHA="$(fm_value "$REVIEW" reviews_sha256)"
R_ROUND="$(fm_value "$REVIEW" review_round)"
R_STATUS="$(fm_value "$REVIEW" status)"

[ "$R_ARTIFACT" = "unit-judgment-brief-review" ] \
  || verdict MALFORMED-CHALLENGE 5 "challenge 'artifact:' is '${R_ARTIFACT:-<absent>}', expected 'unit-judgment-brief-review'"
[ -n "$R_SHA" ] \
  || verdict MALFORMED-CHALLENGE 5 "challenge has no 'reviews_sha256:' — without it nothing binds the review to the bytes that were reviewed, and a later revision would silently keep the old clearance"
case "$R_ROUND" in
  ''|*[!0-9]*) verdict MALFORMED-CHALLENGE 5 "challenge 'review_round:' is '${R_ROUND:-<absent>}', expected a positive integer" ;;
  *) [ "$R_ROUND" -ge 1 ] || verdict MALFORMED-CHALLENGE 5 "challenge 'review_round:' is '$R_ROUND', expected a positive integer" ;;
esac
case "$R_STATUS" in
  findings-only|dispositioned) ;;
  *) verdict MALFORMED-CHALLENGE 5 "challenge 'status:' is '${R_STATUS:-<absent>}' — the only legal values are 'findings-only' and 'dispositioned'" ;;
esac

# ------------------------------------------------------------ 4. STALE-CHALLENGE
# The binding is the whole mechanism: it is what makes a re-review happen without
# anyone remembering to ask for one.
ACTUAL_SHA="$(sha_of "$PROPOSED")"
[ -n "$ACTUAL_SHA" ] || die 10 "could not hash $PROPOSED — the binding cannot be checked, and an unchecked binding is not a binding"
if [ "$ACTUAL_SHA" != "$R_SHA" ]; then
  verdict STALE-CHALLENGE 4 "the challenge is bound to $R_SHA but the proposal now hashes to $ACTUAL_SHA — the proposal was revised after this review, so a new round must run against the revised text"
fi

# ------------------------------------------------------------- ledger parsing
# One TSV row per finding: id, tags, disposition, reason, settled-by.
parse_ledger() { # file
  awk -F': ' '
    /^finding:[[:space:]]*/ {
      if (id != "") print id "\t" tags "\t" disp "\t" reason "\t" settled
      id = $0; sub(/^finding:[[:space:]]*/, "", id)
      tags = ""; disp = ""; reason = ""; settled = ""
      next
    }
    /^tags:[[:space:]]*/       { v = $0; sub(/^tags:[[:space:]]*/, "", v);       tags = v;    next }
    /^disposition:[[:space:]]*/{ v = $0; sub(/^disposition:[[:space:]]*/, "", v); disp = v;   next }
    /^reason:[[:space:]]*/     { v = $0; sub(/^reason:[[:space:]]*/, "", v);     reason = v;  next }
    /^settled-by:[[:space:]]*/ { v = $0; sub(/^settled-by:[[:space:]]*/, "", v); settled = v; next }
    END { if (id != "") print id "\t" tags "\t" disp "\t" reason "\t" settled }
  ' "$1"
}

has_empty_ledger() { grep -qE '^findings:[[:space:]]*none[[:space:]]*$' "$1"; }

CURRENT="$(parse_ledger "$REVIEW")"
if [ -z "$CURRENT" ] && ! has_empty_ledger "$REVIEW"; then
  verdict MALFORMED-CHALLENGE 5 "the challenge record carries neither a finding nor the explicit empty ledger 'findings: none' — silence and omission read identically, and only one of them is a review"
fi

# ----------------------------------------------------------------- 12/9 rounds
# Every earlier round must be present, correctly labelled, and every finding it
# raised must still be carried by the current ledger.
if [ "$R_ROUND" -gt 1 ]; then
  n=1
  while [ "$n" -lt "$R_ROUND" ]; do
    ARCH="$BASE-review-round-$n.md"
    if [ ! -f "$ARCH" ] || [ ! -r "$ARCH" ]; then
      verdict LOST-ROUND 12 "round $n of the challenge is missing at $ARCH — the review chain cannot be read, and a missing round is refused rather than assumed empty"
    fi
    ARCH_ROUND="$(fm_value "$ARCH" review_round)"
    if [ "$ARCH_ROUND" != "$n" ]; then
      verdict LOST-ROUND 12 "the archive at $ARCH declares review_round '$ARCH_ROUND' but is filed as round $n — a mislabelled round breaks the chain"
    fi
    while IFS=$'\t' read -r aid _; do
      [ -n "$aid" ] || continue
      printf '%s\n' "$CURRENT" | cut -f1 | grep -qxF "$aid" \
        || verdict DROPPED-FINDING 9 "round $n raised finding '$aid' and the current ledger no longer carries it — an earlier finding cannot be resolved by disappearing"
    done <<< "$(parse_ledger "$ARCH")"
    n=$((n+1))
  done
fi

COUNT="$(printf '%s' "$CURRENT" | grep -c . || true)"

# ------------------------------------------------------------------ SHAPE-OK
if [ "$SHAPE_ONLY" -eq 1 ]; then
  UNDISPOSED=0
  while IFS=$'\t' read -r id tags disp reason settled; do
    [ -n "$id" ] || continue
    case "$disp" in ''|PENDING) UNDISPOSED=$((UNDISPOSED+1)) ;; esac
  done <<< "$CURRENT"
  verdict SHAPE-OK 0 "challenge round $R_ROUND is well formed and bound to the current proposal — $COUNT required-change finding(s), $UNDISPOSED undisposed"
fi

# ------------------------------------------------------------- disposition rules
while IFS=$'\t' read -r id tags disp reason settled; do
  [ -n "$id" ] || continue

  case "$disp" in
    ''|PENDING)
      verdict UNRESOLVED-FINDING 6 "finding '$id' carries disposition '${disp:-<absent>}' — every required-change finding needs a terminal disposition (REVISED-AND-RE-REVIEWED or OPERATOR-ACCEPTED) before the brief can be promoted"
      ;;
    REVISED-AND-RE-REVIEWED)
      if [ "$R_ROUND" -lt 2 ]; then
        verdict MALFORMED-CHALLENGE 5 "finding '$id' claims REVISED-AND-RE-REVIEWED in review round $R_ROUND — nothing can have been re-reviewed in round 1, so the claim is false on its face"
      fi
      ;;
    OPERATOR-ACCEPTED)
      case ",$tags," in
        *permission-breach*)
          verdict LAUNDERED-BREACH 7 "finding '$id' is tagged permission-breach and was disposed of as OPERATOR-ACCEPTED — an evidence-permission breach cannot be accepted by approval; it must be revised and re-reviewed"
          ;;
      esac
      [ -n "$reason" ] \
        || verdict MALFORMED-CHALLENGE 5 "finding '$id' is OPERATOR-ACCEPTED with an empty 'reason:' — acceptance without a stated reason is a bare approval under another name"
      ;;
    *)
      verdict MALFORMED-CHALLENGE 5 "finding '$id' carries disposition '$disp', which is not one of the two terminal dispositions (REVISED-AND-RE-REVIEWED, OPERATOR-ACCEPTED)"
      ;;
  esac

  # A conflict with an operator decision must name the decision that settles it,
  # and that may not be the decision it conflicts with.
  #
  # This applies to OPERATOR-ACCEPTED only, and the asymmetry is the point. To
  # accept a conflict as it stands is to assert that some other decision permits
  # it, so the record must name which. A finding that was REVISED and then
  # re-reviewed no longer conflicts — the revision removed it, and the following
  # round confirmed that. Requiring a settling decision there would refuse the
  # ordinary way a conflict gets resolved, and the repeat L1 trial's F2 is
  # exactly that case: tagged permission-breach plus decision-conflict, resolved
  # by revision, cleared on re-review.
  CONFLICT_ID=""
  if [ "$disp" = "OPERATOR-ACCEPTED" ]; then
    CONFLICT_ID="$(printf '%s' "$tags" | grep -oE 'decision-conflict:[[:space:]]*[A-Za-z0-9._-]+' | head -1 | sed -E 's/^decision-conflict:[[:space:]]*//')"
  fi
  if [ -n "$CONFLICT_ID" ]; then
    if [ -z "$settled" ]; then
      verdict UNRESOLVED-DECISION-CONFLICT 8 "finding '$id' conflicts with operator decision '$CONFLICT_ID' and names no 'settled-by:' — a conflict with an unrevoked decision must name the decision that settles it"
    fi
    if [ "$settled" = "$CONFLICT_ID" ]; then
      verdict UNRESOLVED-DECISION-CONFLICT 8 "finding '$id' conflicts with operator decision '$CONFLICT_ID' and cites that same decision as settling it — citing the decision it conflicts with settles nothing"
    fi
  fi
done <<< "$CURRENT"

# A record still claiming findings-only cannot clear a ledger that has findings.
if [ "$COUNT" -gt 0 ] && [ "$R_STATUS" != "dispositioned" ]; then
  verdict MALFORMED-CHALLENGE 5 "the challenge carries $COUNT finding(s) but declares 'status: findings-only' — a record that has dispositioned its findings must say so"
fi

verdict CLEARED 0 "challenge round $R_ROUND is bound to the current proposal, and all $COUNT required-change finding(s) carry a terminal disposition"
