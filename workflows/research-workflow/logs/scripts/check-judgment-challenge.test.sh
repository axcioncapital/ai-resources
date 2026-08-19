#!/usr/bin/env bash
# check-judgment-challenge.test.sh — regression proof for the independent-challenge gate.
#
# WHAT MAKES THIS TRUSTWORTHY. Each assertion states an exit code, because that is
# what a caller branches on. The suite ends with a falsifiability control (C20)
# that runs the whole series against a checker which always exits 0 and asserts
# the series FAILS — without it, "expect nonzero" assertions could be satisfied by
# a broken script and a green run would prove nothing.
#
# The two assertions this suite exists for above all others are C6 (a revision
# breaks the binding, so the old clearance cannot carry forward) and C12 (a
# permission breach cannot be disposed of by operator acceptance). Those are the
# two failures the first judgment trial actually committed.
#
# Run:  bash logs/scripts/check-judgment-challenge.test.sh

set -uo pipefail

HERE="$(cd "$(dirname "$0")" && pwd -P)"
CHECK="${CHECK_OVERRIDE:-$HERE/check-judgment-challenge.sh}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

PASS=0; FAIL=0
ok()  { PASS=$((PASS+1)); printf '  PASS  %s\n' "$1"; }
bad() { FAIL=$((FAIL+1)); printf '  FAIL  %s\n' "$1"; [ -n "${2:-}" ] && printf '        %s\n' "$2"; }

sha_of() { shasum -a 256 "$1" | cut -d' ' -f1; }

# Each case gets its own directory so a mutation cannot leak into the next.
new_case() { # name -> echoes the proposal path
  local d="$TMP/$1"; mkdir -p "$d"
  cat > "$d/u-unit-judgment-brief-proposed.md" <<'EOF'
---
unit: demo-unit
artifact: unit-judgment-brief
status: proposed
as_of: 2026-08-18
---

# Unit Judgment Brief — demo-unit

## Theses
### Thesis 1 — a claim [Q1-C05]
## Provisional verdict
Selective [Q1-C05].
## What would change the view
A disclosed price.
EOF
  printf '%s' "$d/u-unit-judgment-brief-proposed.md"
}

# A challenge record bound to the proposal as it currently stands.
write_review() { # proposal round status body-file-content...
  local prop="$1" round="$2" status="$3"; shift 3
  local base="${prop%-proposed.md}"
  { printf -- '---\nunit: demo-unit\nartifact: unit-judgment-brief-review\nreviews: %s\nreviews_sha256: %s\nreview_round: %s\nstatus: %s\nas_of: 2026-08-18\n---\n\n## Required-change findings\n\n' \
      "$prop" "$(sha_of "$prop")" "$round" "$status"
    printf '%s\n' "$@"
  } > "$base-review.md"
}

write_archive() { # proposal round body...
  local prop="$1" round="$2"; shift 2
  local base="${prop%-proposed.md}"
  { printf -- '---\nunit: demo-unit\nartifact: unit-judgment-brief-review\nreviews: %s\nreviews_sha256: %s\nreview_round: %s\nstatus: dispositioned\nas_of: 2026-08-18\n---\n\n## Required-change findings\n\n' \
      "$prop" "$(sha_of "$prop")" "$round"
    printf '%s\n' "$@"
  } > "$base-review-round-$round.md"
}

run() { bash "$CHECK" "$@" >/dev/null 2>&1; printf '%s' "$?"; }

expect() { # label expected-exit args...
  local label="$1" want="$2"; shift 2
  local got; got="$(run "$@")"
  if [ "$got" = "$want" ]; then ok "$label (exit $got)"
  else bad "$label" "expected exit $want, got $got"; fi
}

FIND_CLEAN='finding: F1
tags: internal-inconsistency
disposition: OPERATOR-ACCEPTED
reason: accepted as a disclosure limitation'

# --- C1 no challenge at all -------------------------------------------------
P="$(new_case c1)"
expect 'C1  a proposal with no challenge record is NO-CHALLENGE' 3 "$P"

# --- C2 empty ledger must be explicit ---------------------------------------
P="$(new_case c2)"; write_review "$P" 1 findings-only ''
expect 'C2  a record with neither a finding nor "findings: none" is malformed' 5 "$P"

P="$(new_case c2b)"; write_review "$P" 1 findings-only 'findings: none'
expect 'C2b an explicit empty ledger clears' 0 "$P"

# --- C3/C4/C5 frontmatter shape ---------------------------------------------
P="$(new_case c3)"; write_review "$P" 1 findings-only 'findings: none'
sed -i.bak 's/^artifact: .*/artifact: some-other-thing/' "${P%-proposed.md}-review.md"
expect 'C3  a record with the wrong artifact type is malformed' 5 "$P"

P="$(new_case c4)"; write_review "$P" 1 findings-only 'findings: none'
sed -i.bak '/^reviews_sha256:/d' "${P%-proposed.md}-review.md"
expect 'C4  a record with no binding hash is malformed' 5 "$P"

P="$(new_case c5)"; write_review "$P" 1 findings-only 'findings: none'
sed -i.bak 's/^status: .*/status: looks-fine/' "${P%-proposed.md}-review.md"
expect 'C5  an invented challenge status is malformed' 5 "$P"

# --- C6 THE BINDING: a revision invalidates its own clearance ---------------
# This is the control the first trial lacked. Nothing has to remember to ask.
P="$(new_case c6)"; write_review "$P" 1 findings-only 'findings: none'
before="$(run "$P")"
printf '\nOne more sentence added after review.\n' >> "$P"
after="$(run "$P")"
if [ "$before" = "0" ] && [ "$after" = "4" ]; then
  ok 'C6  revising the proposal breaks the binding and goes STALE (0 -> 4)'
else
  bad 'C6  a revision must invalidate the prior clearance' "before=$before after=$after (want 0 then 4)"
fi

# --- C7 --shape-only reports without requiring dispositions -----------------
P="$(new_case c7)"
write_review "$P" 1 findings-only 'finding: F1
tags: internal-inconsistency
disposition: PENDING
reason:'
expect 'C7  --shape-only accepts an undisposed round' 0 "$P" --shape-only
expect 'C7b the same record without --shape-only is UNRESOLVED' 6 "$P"

# --- C8 undisposed findings never clear -------------------------------------
P="$(new_case c8)"
write_review "$P" 1 dispositioned 'finding: F1
tags: internal-inconsistency
disposition:
reason:'
expect 'C8  an absent disposition is UNRESOLVED' 6 "$P"

# --- C9 unknown disposition -------------------------------------------------
P="$(new_case c9)"
write_review "$P" 1 dispositioned 'finding: F1
tags: internal-inconsistency
disposition: LOOKS-FINE-TO-ME
reason: because'
expect 'C9  a disposition outside the two terminal values is malformed' 5 "$P"

# --- C10 re-review cannot be claimed in round 1 -----------------------------
P="$(new_case c10)"
write_review "$P" 1 dispositioned 'finding: F1
tags: internal-inconsistency
disposition: REVISED-AND-RE-REVIEWED
reason: fixed'
expect 'C10 REVISED-AND-RE-REVIEWED claimed in round 1 is false on its face' 5 "$P"

# --- C11 acceptance needs a reason ------------------------------------------
P="$(new_case c11)"
write_review "$P" 1 dispositioned 'finding: F1
tags: internal-inconsistency
disposition: OPERATOR-ACCEPTED
reason:'
expect 'C11 acceptance with an empty reason is a bare approval renamed' 5 "$P"

# --- C12 THE LAUNDERING CONTROL ---------------------------------------------
# The exact move the first trial performed: a permission breach cleared by approval.
P="$(new_case c12)"
write_review "$P" 1 dispositioned 'finding: F1
tags: permission-breach
disposition: OPERATOR-ACCEPTED
reason: the operator is content with this'
expect 'C12 a permission breach accepted by fiat is LAUNDERED-BREACH' 7 "$P"

# --- C13/C14 decision conflicts ---------------------------------------------
P="$(new_case c13)"
write_review "$P" 1 dispositioned 'finding: F1
tags: decision-conflict: D-12
disposition: OPERATOR-ACCEPTED
reason: accepted'
expect 'C13 a decision conflict with no settling decision is unresolved' 8 "$P"

P="$(new_case c14)"
write_review "$P" 1 dispositioned 'finding: F1
tags: decision-conflict: D-12
disposition: OPERATOR-ACCEPTED
reason: accepted
settled-by: D-12'
expect 'C14 citing the conflicting decision as its own settlement is unresolved' 8 "$P"

P="$(new_case c15)"
write_review "$P" 1 dispositioned 'finding: F1
tags: decision-conflict: D-12
disposition: OPERATOR-ACCEPTED
reason: accepted
settled-by: D-20'
expect 'C15 a conflict settled by a different decision clears' 0 "$P"

# --- C15b a conflict resolved by revision needs no settling decision --------
# The asymmetry is deliberate, and this is the repeat L1 trial's real F2 shape:
# permission-breach plus decision-conflict, resolved by revision and confirmed on
# re-review. Requiring settled-by here would refuse the ordinary resolution route.
P="$(new_case c15b)"
write_archive "$P" 1 'finding: F1
tags: permission-breach, decision-conflict: D-12
disposition: PENDING
reason:'
write_review "$P" 2 dispositioned 'finding: F1
tags: permission-breach, decision-conflict: D-12
disposition: REVISED-AND-RE-REVIEWED
reason: rewritten so the conflict no longer arises, re-reviewed this round'
expect 'C15b a conflict removed by revision clears without a settling decision' 0 "$P"

# --- C16 lost round ---------------------------------------------------------
P="$(new_case c16)"; write_review "$P" 2 dispositioned "$FIND_CLEAN"
expect 'C16 round 2 with no archived round 1 is LOST-ROUND' 12 "$P"

# --- C17 mislabelled archive ------------------------------------------------
P="$(new_case c17)"; write_archive "$P" 1 "$FIND_CLEAN"
sed -i.bak 's/^review_round: 1$/review_round: 7/' "${P%-proposed.md}-review-round-1.md"
write_review "$P" 2 dispositioned "$FIND_CLEAN"
expect 'C17 an archive whose declared round disagrees with its filename is LOST-ROUND' 12 "$P"

# --- C18 THE DROPPED-FINDING CONTROL ----------------------------------------
# A later reviewer must not be able to clear a round-1 breach by writing a
# cleaner ledger over the same path.
P="$(new_case c18)"
write_archive "$P" 1 'finding: F1
tags: permission-breach
disposition: PENDING
reason:'
write_review "$P" 2 dispositioned 'findings: none'
expect 'C18 a finding raised in round 1 and absent from round 2 is DROPPED' 9 "$P"

# --- C19 the full positive path ---------------------------------------------
P="$(new_case c19)"
write_archive "$P" 1 'finding: F1
tags: permission-breach
disposition: PENDING
reason:'
write_review "$P" 2 dispositioned 'finding: F1
tags: permission-breach
disposition: REVISED-AND-RE-REVIEWED
reason: rewritten to stay inside the permission class, re-reviewed this round'
expect 'C19 a breach carried forward, revised and re-reviewed clears' 0 "$P"

# --- C19b status must match the ledger --------------------------------------
P="$(new_case c19b)"
write_review "$P" 1 findings-only "$FIND_CLEAN"
expect 'C19b a record with dispositioned findings still declaring findings-only is malformed' 5 "$P"

# --- C20 falsifiability control ---------------------------------------------
if [ -z "${CHECK_OVERRIDE:-}" ]; then
  stub="$TMP/rubber-stamp.sh"
  printf '#!/usr/bin/env bash\nexit 0\n' > "$stub"
  chmod +x "$stub"
  if CHECK_OVERRIDE="$stub" bash "$0" >/dev/null 2>&1; then
    bad 'C20 falsifiability: a rubber-stamp checker must fail this suite' \
        'the suite passed against a checker that always exits 0 — its assertions cannot fail'
  else
    ok 'C20 falsifiability: a rubber-stamp checker fails this suite'
  fi
fi

printf '\n%s passed, %s failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] || exit 1
