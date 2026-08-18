#!/usr/bin/env bash
# check-judgment-seam.test.sh — the fail-capable proof for the seam check.
#
# A command-path check is only worth anything if it can go red on a real edit.
# This suite earns that in three ways, and each answers a different way the
# check could be fake:
#
#   Tpre  — the check WAS red. It runs against the pre-seam command body taken
#           from Git, not a synthetic stand-in, and requires every assertion to
#           fail. Without this, an always-green check looks identical.
#   T0b   — prose cannot buy a pass. Appending paragraphs to the pre-seam body
#           that ASSERT the seam is wired must move no verdict.
#   M1-M10 — every assertion is independently live. Each applies ONE mechanical
#           edit to a copy of the REAL command body and requires exactly the
#           targeted assertion to flip, with nothing else moving. An edit that
#           degraded the whole file would fail these, not pass them.
#
# The N-series is different in kind. It does not read the command body at all:
# it builds the five artifact states the route must refuse — no approved brief,
# a proposal only, a rejected proposal, a structurally broken approval, a stale
# challenge — and runs the REAL gate helpers the command body invokes against
# them. That proves the halt is real rather than described.
#
# Run:  bash tests/judgment-seam/check-judgment-seam.test.sh

set -u

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WF="$(cd "$HERE/../.." && pwd)"
CHECK="$HERE/check-judgment-seam.sh"
LIVE="$WF/.claude/commands/run-analysis.md"

pass=0; fail=0
ok()  { pass=$((pass + 1)); printf '  ok   %s\n' "$1"; }
bad() { fail=$((fail + 1)); printf '  FAIL %s\n     %s\n' "$1" "${2:-}"; }

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# The set of assertion ids currently failing, comma-joined and sorted.
failing() { bash "$CHECK" "$1" --format tsv 2>/dev/null |
            awk -F'\t' '$2 == "FAIL" { print $1 }' | sort | paste -sd, - ; }

printf '\n=== live surface ===\n'

if bash "$CHECK" "$LIVE" >/dev/null 2>&1; then
  ok 'T0a  the live command body passes every assertion'
else
  bad 'T0a  the live command body passes every assertion' "still failing: $(failing "$LIVE")"
fi

printf '\n=== the check was red before the seam was wired ===\n'

PRE="$TMP/run-analysis.pre.md"
if git -C "$WF" show HEAD:workflows/research-workflow/.claude/commands/run-analysis.md > "$PRE" 2>/dev/null; then
  pre_fail="$(failing "$PRE")"
  n_pre="$(printf '%s' "$pre_fail" | tr ',' '\n' | grep -c .)"
  if [ "$n_pre" -eq 11 ]; then
    ok "Tpre the pre-seam body fails all 11 assertions"
  else
    bad "Tpre the pre-seam body fails all 11 assertions" "failed $n_pre: $pre_fail"
  fi

  # T0b — the falsifiability control. Prose asserting compliance is not compliance.
  CLAIMY="$TMP/run-analysis.claimy.md"
  { cat "$PRE"
    printf '\n%s\n' \
      'This command produces a Unit Judgment Brief, runs an independent challenge,' \
      'binds it with reviews_sha256, pauses unconditionally for the founder with no' \
      'auto-approve, calls promote-judgment-brief.sh with --approval and --approved-by,' \
      'and refuses to continue on a proposed, stale, rejected or unapproved brief.'
  } > "$CLAIMY"
  if [ "$(failing "$CLAIMY")" = "$pre_fail" ]; then
    ok 'T0b  prose asserting the seam is wired moves no verdict'
  else
    bad 'T0b  prose asserting the seam is wired moves no verdict' "moved to: $(failing "$CLAIMY")"
  fi
else
  bad 'Tpre the pre-seam body fails all 11 assertions' 'could not read the pre-seam body from HEAD'
  bad 'T0b  prose asserting the seam is wired moves no verdict' 'skipped — no pre-seam body'
fi

printf '\n=== every assertion is independently live ===\n'

# mutate <label> <expected-failing-set> <transform...>
# The transform reads the live body on stdin and writes the mutated copy to stdout.
mutate() {
  local label="$1" want="$2"; shift 2
  local out="$TMP/m.md"
  "$@" < "$LIVE" > "$out"
  if ! cmp -s "$LIVE" "$out"; then
    local got; got="$(failing "$out")"
    if [ "$got" = "$want" ]; then
      ok "$label"
    else
      bad "$label" "expected failing=[$want] got=[$got]"
    fi
  else
    bad "$label" 'the mutation changed nothing — the anchor is stale'
  fi
}

# M1 — merge the two producer bundles by repeating an evidence path in the
#      context list. Both labels survive; only disjointness breaks.
m1() { awk '{ print }
  /[*][*]Axcíon context bundle:[*][*]/ { print "   - `/analysis/cluster-memos/{section}/` — merged in" }'; }
mutate 'M1  merging the two producer bundles fails J1' J1-separated-inputs m1

# M2 — shape-check the proposal as though it were already authority.
m2() { sed 's/ --allow-proposed//'; }
mutate 'M2  dropping --allow-proposed fails J2' J2-proposal-validated m2

# M3 — let the reviewer inherit what the producer said about the brief.
m3() { sed '/Withheld from the reviewer:/d'; }
mutate 'M3  removing the withholding directive fails J3' J3-reviewer-independent m3

# M4 — take the binding digest from a model instead of from the file.
m4() { sed 's/^   shasum -a 256 .*/   ask the reviewer to report the digest/'; }
mutate 'M4  taking the digest from a sub-agent fails J4' J4-byte-binding m4

# M5 — open a fifth decision branch. The three decisions and the else-branch all
#      survive, so only the closed-branch-set assertion moves.
m5() { awk '{ print }
  /^- [*][*]reject[*][*]/ { print "- **proceed** — continue to Step 4 without deciding." }'; }
mutate 'M5  adding a fifth decision branch fails J5' J5-decision-branches m5

# M6 — let a non-decision promote.
m6() { awk '{ print }
  /^- [*][*]anything else[*][*]/ { print "    Then run promote-judgment-brief.sh anyway." }'; }
mutate 'M6  promoting from the else-branch fails J6' J6-silence-cannot-promote m6

# M7 — accept a revision without re-running the challenge against the new bytes.
m7() { sed 's/run Step 3\.5b again as the next review round/keep the existing clearance/'; }
mutate 'M7  revising without a new challenge round fails J7' J7-revision-restales m7

# M8 — approve with no named approver.
m8() { sed '/--approved-by /d'; }
mutate 'M8  dropping --approved-by fails J8' J8-approval-mechanical m8

# M9 — promote a rejected brief.
m9() { awk '{ print }
  /^- [*][*]reject[*][*]/ { print "    Then run promote-judgment-brief.sh on it." }'; }
mutate 'M9  promoting from the reject branch fails J9' J9-rejection-no-approved m9

# M10 — let the downstream gate accept a proposal as authority.
m10() { sed 's|"{base}-approved.md"$|"{base}-approved.md" --allow-proposed|'; }
mutate 'M10 accepting a proposal at the gate fails J10' J10-authority-gate m10

printf '\n=== the route cannot continue past the seam on a bad brief ===\n'

CONTRACT="$WF/logs/scripts/check-judgment-contract.sh"
CHALLENGE="$WF/logs/scripts/check-judgment-challenge.sh"
BASE="$TMP/j/1.1-unit-judgment-brief"
mkdir -p "$TMP/j"

brief() { # path status [approver-line]
  { printf -- '---\nunit: 1.1\nartifact: unit-judgment-brief\nstatus: %s\nas_of: 2026-08-18\n' "$2"
    [ -n "${3:-}" ] && printf '%s\n' "$3"
    cat <<'EOF'
---

# Unit Judgment Brief — 1.1

## Theses

### Thesis 1 — consolidation is running ahead of disclosure

Deal count rose across the period [Q1-C05], while only one transaction disclosed a
price [Q2-A03]. The gap removes the usual basis for inferring a clearing multiple.

Context: this bears on the current mid-market industrials priority.

Countercase: the disclosed transaction sits outside the consolidation set.

### Thesis 2 — buyer mix is narrowing

Two of the three active acquirers are the same strategic group [Q1-C11], which
concentrates process risk for any seller entering now.

### Thesis 3 — timing pressure is asymmetric

Sellers face a closing window the buyers do not [GF3-C02], so negotiating leverage
decays with delay.

## Provisional verdict

Selective. The evidence supports entry on a narrow basis [Q1-C05].

## What would change the view

A second disclosed price inside the consolidation set.
EOF
  } > "$1"
}

gate() { bash "$CONTRACT" "$1" >/dev/null 2>&1; printf '%s' "$?"; }

expect_exit() { # label want got
  if [ "$2" = "$3" ]; then ok "$1"; else bad "$1" "expected exit $2, got $3"; fi
}

# N1 — nothing produced at all.
rm -f "$BASE-approved.md"
expect_exit 'N1  no approved brief halts the gate (3)' 3 "$(gate "$BASE-approved.md")"

# N2 — a proposal exists and is sound, but has not been approved. The gate must
#      still refuse it, AND the --allow-proposed control must accept it: without
#      the second half, a gate that refused everything would pass N2 for free.
brief "$BASE-proposed.md" proposed
expect_exit 'N2a a proposal is not authority (3 — no approved path)' 3 "$(gate "$BASE-approved.md")"
bash "$CONTRACT" "$BASE-proposed.md" --allow-proposed >/dev/null 2>&1
expect_exit 'N2b the same proposal is structurally sound (control, 0)' 0 "$?"

# N3 — a rejected brief sitting at the approved path is still not authority.
brief "$BASE-approved.md" rejected 'rejected_by: Patrik Lindeberg'
expect_exit 'N3  a rejected brief halts the gate (4)' 4 "$(gate "$BASE-approved.md")"

# N4 — approved, but structurally broken: theses stripped of their evidence.
brief "$BASE-approved.md" approved 'approved_by: Patrik Lindeberg'
sed -i.bak 's/\[Q1-C05\]//g; s/\[Q2-A03\]//g; s/\[Q1-C11\]//g; s/\[GF3-C02\]//g' "$BASE-approved.md"
rm -f "$BASE-approved.md.bak"
n4="$(gate "$BASE-approved.md")"
if [ "$n4" = 5 ] || [ "$n4" = 6 ]; then
  ok "N4  an approved brief with no evidence basis halts the gate ($n4)"
else
  bad 'N4  an approved brief with no evidence basis halts the gate' "expected 5 or 6, got $n4"
fi

# N5 — the challenge is bound to bytes that no longer exist. Revising the
#      proposal after review must make the clearance stale on its own.
rm -f "$BASE-approved.md"
brief "$BASE-proposed.md" proposed
sha="$(shasum -a 256 "$BASE-proposed.md" | cut -d' ' -f1)"
{ printf -- '---\nunit: 1.1\nartifact: unit-judgment-brief-review\nreviews: %s\nreviews_sha256: %s\nreview_round: 1\nstatus: dispositioned\nas_of: 2026-08-18\n---\n\n## Required-change findings\n\nfindings: none\n' \
    "$BASE-proposed.md" "$sha"
} > "$BASE-review.md"
bash "$CHALLENGE" "$BASE-proposed.md" >/dev/null 2>&1
expect_exit 'N5a a challenge bound to the current bytes clears (control, 0)' 0 "$?"
printf '\nA sentence added after review.\n' >> "$BASE-proposed.md"
bash "$CHALLENGE" "$BASE-proposed.md" >/dev/null 2>&1
expect_exit 'N5b revising the proposal makes the clearance stale (4)' 4 "$?"

# N6 — an undisposed required-change finding blocks clearance.
sha="$(shasum -a 256 "$BASE-proposed.md" | cut -d' ' -f1)"
{ printf -- '---\nunit: 1.1\nartifact: unit-judgment-brief-review\nreviews: %s\nreviews_sha256: %s\nreview_round: 1\nstatus: findings-only\nas_of: 2026-08-18\n---\n\n## Required-change findings\n\nfinding: F1\ntags: permission-breach\ndisposition: PENDING\nreason:\n' \
    "$BASE-proposed.md" "$sha"
} > "$BASE-review.md"
bash "$CHALLENGE" "$BASE-proposed.md" >/dev/null 2>&1
expect_exit 'N6  an undisposed finding blocks clearance (6)' 6 "$?"

printf '\n%d passed, %d failed\n\n' "$pass" "$fail"
[ "$fail" -eq 0 ] || exit 1
exit 0
