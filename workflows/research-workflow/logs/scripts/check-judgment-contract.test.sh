#!/usr/bin/env bash
# check-judgment-contract.test.sh — regression proof for the Unit Judgment Brief
# structural gate.
#
# WHAT MAKES THIS TRUSTWORTHY. Every assertion below states an exit code, not a
# prose fragment, because the exit code is what a caller branches on and prose is
# what drifts. And the suite ends with a falsifiability control (V19): it runs the
# whole V-series against a rubber-stamp checker that always exits 0, and asserts
# that the series FAILS. Without that, a suite of "expect nonzero" assertions
# could be quietly satisfied by a broken script, and a green run would mean
# nothing.
#
# Run:  bash logs/scripts/check-judgment-contract.test.sh

set -uo pipefail

HERE="$(cd "$(dirname "$0")" && pwd -P)"
CHECK="${CHECK_OVERRIDE:-$HERE/check-judgment-contract.sh}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

PASS=0; FAIL=0
ok()  { PASS=$((PASS+1)); printf '  PASS  %s\n' "$1"; }
bad() { FAIL=$((FAIL+1)); printf '  FAIL  %s\n' "$1"; [ -n "${2:-}" ] && printf '        %s\n' "$2"; }

# A structurally valid APPROVED brief. Every mutation below starts from this, so
# a failure is attributable to the one thing that changed.
valid_brief() { # path [status-line-extra]
  cat > "$1" <<'EOF'
---
unit: demo-unit
artifact: unit-judgment-brief
status: approved
as_of: 2026-08-18
approved_by: Patrik Lindeberg
---

# Unit Judgment Brief — demo-unit

**APPROVED.**

## Theses

### Thesis 1 — consolidation is running ahead of disclosure

Deal count rose across the period [Q1-C05], while only one transaction disclosed a
price [Q2-A03]. The gap matters commercially because it removes the usual basis for
inferring a clearing multiple.

Context: this bears on the current mid-market industrials priority.

Countercase: the disclosed transaction sits outside the consolidation set, so it may
not be representative at all.

### Thesis 2 — buyer mix is narrowing

Two of the three active acquirers are the same strategic group [Q1-C11], which
concentrates process risk for any seller entering now.

### Thesis 3 — timing pressure is asymmetric

Sellers face a closing window the buyers do not [GF3-C02], so negotiating leverage
decays with delay rather than holding steady.

## Provisional verdict

Selective. The evidence supports entry on a narrow basis [Q1-C05], and does not
support a general thesis about the sector.

## What would change the view

A second disclosed price inside the consolidation set, or a new acquirer completing
a process without the incumbent group.
EOF
}

run() { bash "$CHECK" "$@" >/dev/null 2>&1; printf '%s' "$?"; }

expect() { # label expected-exit args...
  local label="$1" want="$2"; shift 2
  local got; got="$(run "$@")"
  if [ "$got" = "$want" ]; then ok "$label (exit $got)"
  else bad "$label" "expected exit $want, got $got"; fi
}

# --- V1 absence -------------------------------------------------------------
expect 'V1  a missing brief is MISSING, not a silent pass' 3 "$TMP/nope.md"

# --- V2/V3 the proposed/authority distinction -------------------------------
valid_brief "$TMP/prop.md"
sed -i.bak 's/^status: approved$/status: proposed/; /^approved_by:/d' "$TMP/prop.md"
expect 'V2  a proposal presented as authority is NOT-APPROVED' 4 "$TMP/prop.md"
expect 'V3  --allow-proposed accepts a structurally sound proposal' 0 "$TMP/prop.md" --allow-proposed

# --- V4/V5 rejection is terminal --------------------------------------------
valid_brief "$TMP/rej.md"
sed -i.bak 's/^status: approved$/status: rejected/; s/^approved_by:/rejected_by:/' "$TMP/rej.md"
expect 'V4  a rejected brief is not authority' 4 "$TMP/rej.md"
expect 'V5  --allow-proposed does not rescue a rejected brief' 4 "$TMP/rej.md" --allow-proposed

# --- V6/V7 a decision needs a decider ---------------------------------------
valid_brief "$TMP/noapprover.md"
sed -i.bak '/^approved_by:/d' "$TMP/noapprover.md"
expect 'V6  approval with no approver is refused' 6 "$TMP/noapprover.md"

valid_brief "$TMP/norejecter.md"
sed -i.bak 's/^status: approved$/status: rejected/; /^approved_by:/d' "$TMP/norejecter.md"
expect 'V7  rejection with no rejecter is refused' 6 "$TMP/norejecter.md"

# --- V8 illegal status ------------------------------------------------------
valid_brief "$TMP/badstatus.md"
sed -i.bak 's/^status: approved$/status: endorsed/' "$TMP/badstatus.md"
expect 'V8  an invented status is refused' 6 "$TMP/badstatus.md"

# --- V9 length is a target, not a gate --------------------------------------
# Pinned so a later edit cannot quietly promote the 500-800 band into a gate.
valid_brief "$TMP/short.md"
short_exit="$(run "$TMP/short.md")"
short_warn="$(bash "$CHECK" "$TMP/short.md" 2>&1 | grep -c 'target band')"
if [ "$short_exit" = "0" ] && [ "$short_warn" -ge 1 ]; then
  ok 'V9  an under-band brief warns and is still accepted (band is a target)'
else
  bad 'V9  the length band must warn, never gate' "exit=$short_exit warnings=$short_warn"
fi

# --- V10 evidence basis -----------------------------------------------------
valid_brief "$TMP/noids.md"
sed -i.bak -E 's/\[(Q|GF)[0-9]+-[A-Z]+[0-9]+\]//g' "$TMP/noids.md"
expect 'V10 a brief citing no claim IDs is NO-CLAIM-IDS' 5 "$TMP/noids.md"

# --- V11 separation 1: every thesis rests on evidence -----------------------
# Strip the IDs from Thesis 2 only. The document still cites plenty, so a
# document-wide count would pass this and miss the failure.
valid_brief "$TMP/barethesis.md"
perl -0pi -e 's/(### Thesis 2 .*?)\[Q1-C11\]/$1/s' "$TMP/barethesis.md"
expect 'V11 a thesis with no claim ID is refused (document-wide count would miss it)' 6 "$TMP/barethesis.md"

# --- V11b separation 1: the FINAL thesis may not borrow later citations ------
# V11 mutates a middle thesis, so the next '### Thesis ' heading closes its
# block. The last thesis has no such heading after it: unless the block also
# closes at the next level-two section, it runs on through
# '## Provisional verdict' and picks up the citation living there. Five theses
# with an uncited Thesis 5 and a cited verdict is exactly that position.
valid_brief "$TMP/barefinal.md"
perl -0pi -e 's/(?=^## Provisional verdict)/### Thesis 4 — pricing discipline is holding\n\nBid spreads narrowed across the same window [Q2-A03], which leaves little room for an\nopportunistic entry at the current level.\n\n### Thesis 5 — the exit route is untested\n\nNo participant in this set has completed a full exit cycle, so the assumed route out\nrests on nothing that has been observed.\n\n/ms' "$TMP/barefinal.md"
expect 'V11b an uncited final thesis is refused (it must not borrow the verdict citation)' 6 "$TMP/barefinal.md"

# --- V12 separation 2: context may not carry evidence -----------------------
valid_brief "$TMP/ctxev.md"
sed -i.bak 's/^Context: this bears on.*$/Context: this bears on the current priority [Q1-C05]./' "$TMP/ctxev.md"
expect 'V12 a Context: line citing a claim ID is refused' 6 "$TMP/ctxev.md"

# --- V12b separation 2: markdown decoration must not defeat the rule ----------
# V12 mutates a bare `Context:` line, so it only ever exercised the undecorated
# form. Real briefs decorate that lead-in — a bullet, bold, a blockquote marker —
# and a rule anchored on whitespace alone let `- **Context:** … [Q1-C05]` through
# as VALID. That is the precise move this separation exists to catch, wearing
# list syntax, and it failed open rather than closed.
valid_brief "$TMP/ctxbullet.md"
sed -i.bak 's/^Context: this bears on.*$/- **Context:** this bears on the current priority [Q1-C05]./' "$TMP/ctxbullet.md"
expect 'V12b a decorated Context: line citing a claim ID is refused' 6 "$TMP/ctxbullet.md"

# --- V13 separation 3: the verdict rests on evidence ------------------------
valid_brief "$TMP/bareverdict.md"
perl -0pi -e 's/(## Provisional verdict.*?)\[Q1-C05\]/$1/s' "$TMP/bareverdict.md"
expect 'V13 a verdict citing no claim ID is refused' 6 "$TMP/bareverdict.md"

# --- V14 countercase --------------------------------------------------------
valid_brief "$TMP/nocc.md"
sed -i.bak '/^Countercase:/,+1d' "$TMP/nocc.md"
expect 'V14 a brief with no countercase anywhere is refused' 6 "$TMP/nocc.md"

# --- V15 thesis count -------------------------------------------------------
valid_brief "$TMP/twothesis.md"
perl -0pi -e 's/### Thesis 3 .*?(?=## Provisional)//s' "$TMP/twothesis.md"
expect 'V15 fewer than three theses is refused' 6 "$TMP/twothesis.md"

# --- V16 required headings --------------------------------------------------
valid_brief "$TMP/nohead.md"
sed -i.bak 's/^## What would change the view$/## Notes/' "$TMP/nohead.md"
expect 'V16 a missing required heading is refused' 6 "$TMP/nohead.md"

# --- V17 the positive case --------------------------------------------------
valid_brief "$TMP/good.md"
expect 'V17 a valid approved brief is accepted as authority' 0 "$TMP/good.md"

# --- V18 frontmatter is not the body ----------------------------------------
# A body line that looks like frontmatter must never be able to approve a brief.
valid_brief "$TMP/bodyfake.md"
sed -i.bak 's/^status: approved$/status: proposed/; /^approved_by:/d' "$TMP/bodyfake.md"
printf '\nstatus: approved\napproved_by: Not A Real Approval\n' >> "$TMP/bodyfake.md"
expect 'V18 a body line reading "status: approved" cannot approve a brief' 4 "$TMP/bodyfake.md"

# --- V19 falsifiability control ---------------------------------------------
# Everything above asserts specific exit codes. If the checker were replaced by
# something that always succeeded, the "expect nonzero" assertions must break.
# This runs the whole suite against exactly that and asserts it FAILS.
if [ -z "${CHECK_OVERRIDE:-}" ]; then
  stub="$TMP/rubber-stamp.sh"
  printf '#!/usr/bin/env bash\nexit 0\n' > "$stub"
  chmod +x "$stub"
  if CHECK_OVERRIDE="$stub" bash "$0" >/dev/null 2>&1; then
    bad 'V19 falsifiability: a rubber-stamp checker must fail this suite' \
        'the suite passed against a checker that always exits 0 — its assertions cannot fail'
  else
    ok 'V19 falsifiability: a rubber-stamp checker fails this suite'
  fi
fi

printf '\n%s passed, %s failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] || exit 1
