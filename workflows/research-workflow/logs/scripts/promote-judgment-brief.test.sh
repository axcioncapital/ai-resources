#!/usr/bin/env bash
# promote-judgment-brief.test.sh — regression proof for the approval transition,
# plus the command-path fixture for the whole authority seam.
#
# TWO PARTS.
#
#   P-series — the refusals and the byte-for-byte guarantee, each asserted by
#              exit code, and each checked to have written NOTHING on refusal.
#              A refusal that still leaves a file behind is not a refusal.
#
#   S-series — the seam fixture: produce -> challenge -> disposition -> founder
#              decision -> promotion, driven end to end against the real scripts.
#              It exercises the contract's minimum command path without
#              implementing the producer or any downstream consumer, which is
#              what makes it a contract fixture rather than a pipeline test.
#
# The suite ends with a falsifiability control (P14) that runs the whole series
# against a promoter which always exits 0, and asserts the series FAILS.
#
# Run:  bash logs/scripts/promote-judgment-brief.test.sh

set -uo pipefail

HERE="$(cd "$(dirname "$0")" && pwd -P)"
PROMOTE="${PROMOTE_OVERRIDE:-$HERE/promote-judgment-brief.sh}"
CONTRACT="$HERE/check-judgment-contract.sh"
CHALLENGE="$HERE/check-judgment-challenge.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

PASS=0; FAIL=0
ok()  { PASS=$((PASS+1)); printf '  PASS  %s\n' "$1"; }
bad() { FAIL=$((FAIL+1)); printf '  FAIL  %s\n' "$1"; [ -n "${2:-}" ] && printf '        %s\n' "$2"; }

sha_of() { shasum -a 256 "$1" | cut -d' ' -f1; }

new_case() { # name -> echoes proposal path
  local d="$TMP/$1"; mkdir -p "$d"
  cat > "$d/u-unit-judgment-brief-proposed.md" <<'EOF'
---
unit: demo-unit
artifact: unit-judgment-brief
status: proposed
as_of: 2026-08-18
---

# Unit Judgment Brief — demo-unit

**PROPOSED — FOR INDEPENDENT CHALLENGE AND OPERATOR DECISION.**

## Theses

### Thesis 1 — consolidation is running ahead of disclosure

Deal count rose [Q1-C05] while only one transaction disclosed a price [Q2-A03].

Context: this bears on the current mid-market industrials priority.

Countercase: the disclosed deal sits outside the consolidation set.

### Thesis 2 — buyer mix is narrowing

Two of three active acquirers are the same strategic group [Q1-C11].

### Thesis 3 — timing pressure is asymmetric

Sellers face a closing window buyers do not [GF3-C02].

## Provisional verdict

Selective [Q1-C05].

## What would change the view

A second disclosed price inside the consolidation set.
EOF
  printf '%s' "$d/u-unit-judgment-brief-proposed.md"
}

clear_challenge() { # proposal
  local prop="$1" base="${1%-proposed.md}"
  cat > "$base-review.md" <<EOF
---
unit: demo-unit
artifact: unit-judgment-brief-review
reviews: $prop
reviews_sha256: $(sha_of "$prop")
review_round: 1
status: findings-only
as_of: 2026-08-18
---

## Required-change findings

findings: none
EOF
}

run() { bash "$PROMOTE" "$@" >/dev/null 2>&1; printf '%s' "$?"; }

expect() { # label expected-exit args...
  local label="$1" want="$2"; shift 2
  local got; got="$(run "$@")"
  if [ "$got" = "$want" ]; then ok "$label (exit $got)"
  else bad "$label" "expected exit $want, got $got"; fi
}

# Every refusal must also leave no approved file behind.
expect_no_write() { # label expected-exit proposal args...
  local label="$1" want="$2" prop="$3"; shift 3
  local got; got="$(run "$prop" "$@")"
  local approved="${prop%-proposed.md}-approved.md"
  if [ "$got" = "$want" ] && [ ! -e "$approved" ]; then
    ok "$label (exit $got, nothing written)"
  elif [ "$got" != "$want" ]; then
    bad "$label" "expected exit $want, got $got"
  else
    bad "$label" "refused with exit $got but still wrote $approved"
  fi
}

OKAPP='Approved.'
WHO='Patrik Lindeberg'

# --- P1 no proposal ---------------------------------------------------------
expect 'P1  a missing proposal is NO-PROPOSAL' 3 "$TMP/nope-proposed.md" --approval "$OKAPP" --approved-by "$WHO"

# --- P2/P3/P4 the reply must actually approve -------------------------------
P="$(new_case p2)"; clear_challenge "$P"
expect_no_write 'P2  silence is not approval' 4 "$P" --approval "" --approved-by "$WHO"

P="$(new_case p3)"; clear_challenge "$P"
expect_no_write 'P3  "not approved" cannot promote' 4 "$P" --approval "This is not approved yet." --approved-by "$WHO"

P="$(new_case p4)"; clear_challenge "$P"
expect_no_write 'P4  a conditional approval cannot promote' 4 "$P" --approval "Approved once you fix Thesis 2." --approved-by "$WHO"

P="$(new_case p4b)"; clear_challenge "$P"
expect_no_write 'P4b a revision request cannot promote' 4 "$P" --approval "Please revise Thesis 2 first." --approved-by "$WHO"

# --- P5 the approver must be real -------------------------------------------
P="$(new_case p5)"; clear_challenge "$P"
expect_no_write 'P5  a missing approver is refused' 5 "$P" --approval "$OKAPP" --approved-by ""

P="$(new_case p5b)"; clear_challenge "$P"
expect_no_write 'P5b a placeholder approver is refused' 5 "$P" --approval "$OKAPP" --approved-by "the operator"

P="$(new_case p5c)"; clear_challenge "$P"
expect_no_write 'P5c an angle-bracket placeholder is refused' 5 "$P" --approval "$OKAPP" --approved-by "<name>"

# --- P6 rejection is the operator's decision --------------------------------
P="$(new_case p6)"; clear_challenge "$P"
sed -i.bak 's/^status: proposed$/status: rejected/' "$P"
printf -- '---\n' >/dev/null
sed -i.bak 's/^as_of: 2026-08-18$/as_of: 2026-08-18\nrejected_by: Patrik Lindeberg/' "$P"
expect_no_write 'P6  a rejected brief cannot be promoted, whatever reply is waved at it' 13 "$P" --approval "$OKAPP" --approved-by "$WHO"

# --- P7 the challenge is a hard precondition --------------------------------
P="$(new_case p7)"   # no challenge record written at all
expect_no_write 'P7  an unchallenged brief cannot be promoted' 11 "$P" --approval "$OKAPP" --approved-by "$WHO"

P="$(new_case p7b)"; clear_challenge "$P"
printf '\nA sentence added after the review.\n' >> "$P"
expect_no_write 'P7b a stale challenge blocks promotion' 11 "$P" --approval "$OKAPP" --approved-by "$WHO"

P="$(new_case p7c)"
cat > "${P%-proposed.md}-review.md" <<EOF
---
unit: demo-unit
artifact: unit-judgment-brief-review
reviews: $P
reviews_sha256: $(sha_of "$P")
review_round: 1
status: dispositioned
as_of: 2026-08-18
---

## Required-change findings

finding: F1
tags: permission-breach
disposition: OPERATOR-ACCEPTED
reason: the operator is content with this
EOF
expect_no_write 'P7c a laundered permission breach blocks promotion' 11 "$P" --approval "$OKAPP" --approved-by "$WHO"

# --- P8 an invalid proposal cannot become authority -------------------------
P="$(new_case p8)"
perl -0pi -e 's/### Thesis 3 .*?(?=## Provisional)//s' "$P"
clear_challenge "$P"
expect_no_write 'P8  a structurally unsound proposal is refused' 7 "$P" --approval "$OKAPP" --approved-by "$WHO"

# --- P9 the positive case, and the byte-for-byte guarantee ------------------
P="$(new_case p9)"; clear_challenge "$P"
src_tail="$(awk '/^## Theses/ {p=1} p' "$P" | shasum -a 256 | cut -d' ' -f1)"
got="$(run "$P" --approval "$OKAPP" --approved-by "$WHO")"
A="${P%-proposed.md}-approved.md"
if [ "$got" = "0" ] && [ -f "$A" ]; then
  ok 'P9  a challenged, approved proposal promotes (exit 0)'
  out_tail="$(awk '/^## Theses/ {p=1} p' "$A" | shasum -a 256 | cut -d' ' -f1)"
  [ "$src_tail" = "$out_tail" ] \
    && ok 'P9b the analytical content is carried byte for byte' \
    || bad 'P9b analytical content must survive promotion unchanged' "proposal $src_tail, approved $out_tail"
  grep -q '^status: approved$' "$A" \
    && ok 'P9c the promoted brief carries status: approved' \
    || bad 'P9c the promoted brief must carry status: approved'
  grep -q "^approved_by: $WHO$" "$A" \
    && ok 'P9d the promoted brief records the real approver' \
    || bad 'P9d the promoted brief must record the approver'
  grep -q '^\*\*APPROVED' "$A" \
    && ok 'P9e the PROPOSED banner was replaced' \
    || bad 'P9e the banner must be swapped'
  bash "$CONTRACT" "$A" >/dev/null 2>&1 \
    && ok 'P9f the promoted brief validates as downstream authority' \
    || bad 'P9f the promoted brief must validate as authority'
else
  bad 'P9  a challenged, approved proposal must promote' "exit=$got"
fi

# --- P10 no overwrite -------------------------------------------------------
expect 'P10 an existing approved brief is never overwritten' 6 "$P" --approval "$OKAPP" --approved-by "$WHO"

# --- P11 CONTENT-DRIFT is reachable, not decorative -------------------------
# Proves the guarantee has teeth: with the copy step sabotaged, the drift check
# is what stops the write. Without this, P9b could pass on a script that simply
# never alters anything, and the check itself would be untested.
P="$(new_case p11)"; clear_challenge "$P"
# The sabotaged copy needs its sibling helpers beside it: the script resolves
# them relative to its own directory, and a copy that cannot find them would
# exit 10 on usage and prove nothing about drift.
sabdir="$TMP/sab"; mkdir -p "$sabdir"
cp "$CONTRACT" "$CHALLENGE" "$sabdir/"
sabotage="$sabdir/promote-judgment-brief.sh"
sed 's|^  /\^## Theses/ { theses=1 }$|  /^## Theses/ { theses=1; print "INJECTED"; next }|' \
  "$HERE/promote-judgment-brief.sh" > "$sabotage"
if ! grep -q 'INJECTED' "$sabotage"; then
  bad 'P11 fixture: the sabotage edit did not apply' 'the drift control cannot be exercised'
fi
got="$(bash "$sabotage" "$P" --approval "$OKAPP" --approved-by "$WHO" >/dev/null 2>&1; printf '%s' "$?")"
if [ "$got" = "9" ] && [ ! -e "${P%-proposed.md}-approved.md" ]; then
  ok 'P11 a promoter that alters the content is caught by CONTENT-DRIFT (exit 9, nothing written)'
else
  bad 'P11 the drift check must catch an altering promoter' "exit=$got"
fi

# --- S-series: the command-path seam ----------------------------------------
# produce -> challenge -> revise -> re-challenge -> disposition -> approve -> promote
S="$(new_case seam)"
BASE="${S%-proposed.md}"
s_ok=1

# 1. the proposal is shape-valid but not authority
bash "$CONTRACT" "$S" --allow-proposed >/dev/null 2>&1 || s_ok=0
bash "$CONTRACT" "$S" >/dev/null 2>&1 && s_ok=0          # must NOT be authority yet

# 2. round 1 raises a permission breach
cat > "$BASE-review.md" <<EOF
---
unit: demo-unit
artifact: unit-judgment-brief-review
reviews: $S
reviews_sha256: $(sha_of "$S")
review_round: 1
status: findings-only
as_of: 2026-08-18
---

## Required-change findings

finding: F1
tags: permission-breach
disposition: PENDING
reason:
EOF
bash "$CHALLENGE" "$S" --shape-only >/dev/null 2>&1 || s_ok=0   # well formed
bash "$CHALLENGE" "$S" >/dev/null 2>&1 && s_ok=0                # but undisposed
[ "$(run "$S" --approval "$OKAPP" --approved-by "$WHO")" = "11" ] || s_ok=0

# 3. the operator directs a revision; the revision breaks the binding
cp "$BASE-review.md" "$BASE-review-round-1.md"
printf '\nRevised after the round-1 finding.\n' >> "$S"
[ "$(bash "$CHALLENGE" "$S" >/dev/null 2>&1; printf '%s' "$?")" = "4" ] || s_ok=0   # STALE, unprompted

# 4. round 2 re-reviews the revised bytes and disposes the finding
cat > "$BASE-review.md" <<EOF
---
unit: demo-unit
artifact: unit-judgment-brief-review
reviews: $S
reviews_sha256: $(sha_of "$S")
review_round: 2
status: dispositioned
as_of: 2026-08-18
---

## Required-change findings

finding: F1
tags: permission-breach
disposition: REVISED-AND-RE-REVIEWED
reason: rewritten inside the permission class and re-reviewed this round
EOF
bash "$CHALLENGE" "$S" >/dev/null 2>&1 || s_ok=0                # now CLEARED

# 5. the founder decision promotes it
[ "$(run "$S" --approval "$OKAPP" --approved-by "$WHO")" = "0" ] || s_ok=0
[ -f "$BASE-approved.md" ] || s_ok=0
bash "$CONTRACT" "$BASE-approved.md" >/dev/null 2>&1 || s_ok=0  # authority at last

if [ "$s_ok" = "1" ]; then
  ok 'S1  the full seam runs: produce -> challenge -> revise -> re-challenge -> approve -> promote'
else
  bad 'S1  the full command-path seam must run end to end'
fi

# The round-1 record survived the revision, so the earlier breach is still on record.
if [ -f "$BASE-review-round-1.md" ] && grep -q 'permission-breach' "$BASE-review-round-1.md"; then
  ok 'S2  the earlier review round is preserved, not overwritten'
else
  bad 'S2  the earlier review round must be preserved'
fi

# --- P14 falsifiability control ---------------------------------------------
if [ -z "${PROMOTE_OVERRIDE:-}" ]; then
  stub="$TMP/rubber-stamp.sh"
  printf '#!/usr/bin/env bash\nexit 0\n' > "$stub"
  chmod +x "$stub"
  if PROMOTE_OVERRIDE="$stub" bash "$0" >/dev/null 2>&1; then
    bad 'P14 falsifiability: a rubber-stamp promoter must fail this suite' \
        'the suite passed against a promoter that always exits 0 — its assertions cannot fail'
  else
    ok 'P14 falsifiability: a rubber-stamp promoter fails this suite'
  fi
fi

printf '\n%s passed, %s failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] || exit 1
