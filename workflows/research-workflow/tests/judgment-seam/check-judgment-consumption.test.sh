#!/usr/bin/env bash
# check-judgment-consumption.test.sh — the fail-capable proof for the downstream
# consumption check.
#
# The claim under test is "approved judgment governs the downstream owners". That
# claim decomposes into two halves that have to be proved separately, because
# each is satisfiable without the other:
#
#   the ENTRY calls the contract helper and halts on a nonzero exit  → C2a, C3a
#   the HELPER returns nonzero on exactly the states that must not pass → A-series
#
# Proving only the first gives a command that dutifully calls something that
# always says yes. Proving only the second gives a correct helper nothing calls.
#
# The mutation series is built around the one failure that is hardest to see from
# the outside: an owner that receives the approved brief, confirms it is there,
# and then drafts from the memo as before. `U1`-`U5` reduce each owner's use
# instruction to exactly that — an existence check — on a copy of the REAL command
# bodies, and require the owner's assertion to fail. An existence-only gate cannot
# pass this suite for free.
#
# Run:  bash tests/judgment-seam/check-judgment-consumption.test.sh

set -u

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WF="$(cd "$HERE/../.." && pwd)"
CHECK="$HERE/check-judgment-consumption.sh"
LIVE="$WF/.claude/commands"

# Pinned, never HEAD: the pre-Unit-3 state of all three command bodies. 06c90e66
# is Unit 2's accepted correction — the last commit before any downstream owner
# consumed judgment. A floating baseline would compare the post-change bodies
# against themselves the moment this unit commits.
PRE_REF=06c90e66

pass=0; fail=0
ok()  { pass=$((pass + 1)); printf '  ok   %s\n' "$1"; }
bad() { fail=$((fail + 1)); printf '  FAIL %s\n     %s\n' "$1" "${2:-}"; }

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

failing() { bash "$CHECK" --commands "$1" --format tsv 2>/dev/null |
            awk -F'\t' '$2 == "FAIL" { print $1 }' | sort | paste -sd, - ; }

printf '\n=== live surface ===\n'
if bash "$CHECK" --commands "$LIVE" >/dev/null 2>&1; then
  ok 'T0a  every downstream owner passes on the live command bodies'
else
  bad 'T0a  every downstream owner passes on the live command bodies' "still failing: $(failing "$LIVE")"
fi

printf '\n=== the check was red before this unit ===\n'
PRE="$TMP/pre"; mkdir -p "$PRE"
pre_ok=1
for f in run-analysis run-synthesis run-report produce-prose-draft produce-formatting; do
  git -C "$WF" show "$PRE_REF:workflows/research-workflow/.claude/commands/$f.md" > "$PRE/$f.md" 2>/dev/null || pre_ok=0
done
if [ "$pre_ok" -eq 1 ]; then
  # Self-check on the pin, the same one the seam suite carries: a baseline that
  # already consumes judgment is not a baseline.
  if grep -q 'Required use of approved judgment' "$PRE"/*.md; then
    bad "Tpre the pinned baseline $PRE_REF predates downstream consumption" 'the pinned commit already consumes judgment — the pin is wrong'
  fi
  pre_fail="$(failing "$PRE")"
  n_pre="$(printf '%s' "$pre_fail" | tr ',' '\n' | grep -c .)"
  if [ "$n_pre" -eq 16 ]; then
    ok 'Tpre all 16 assertions fail on the pre-Unit-3 command bodies'
  else
    bad 'Tpre all 16 assertions fail on the pre-Unit-3 command bodies' "failed $n_pre: $pre_fail"
  fi

  # Tpre5 is the sharper baseline, and it is what makes this correction's red
  # attributable. At a8671275 — Unit 3 accepted — Stage 3-4 was already governed
  # and Stage 5 was not, so exactly the six S-assertions must fail and the six
  # C-assertions must pass. A correction claiming to close a Stage 5 gap should
  # be red on Stage 5 alone, not on everything.
  PRE5="$TMP/pre5"; mkdir -p "$PRE5"; ok5=1
  for f in run-analysis run-synthesis run-report produce-prose-draft produce-formatting; do
    git -C "$WF" show "a8671275:workflows/research-workflow/.claude/commands/$f.md" > "$PRE5/$f.md" 2>/dev/null || ok5=0
  done
  if [ "$ok5" -eq 1 ]; then
    want5='S1a-prose-draft-gate,S1b-prose-draft-consume,S2a-formatting-gate,S2b-formatting-consume,S3-final-qc-fidelity,S4-section-mode-exempt,S5-stage3-result-returned,S6-stage3-fail-blocks'
    got5="$(failing "$PRE5")"
    if [ "$got5" = "$want5" ]; then
      ok 'Tpre5 at Unit 3 accepted, exactly the eight Stage-5 assertions fail and Stage 3-4 passes'
    else
      bad 'Tpre5 at Unit 3 accepted, exactly the eight Stage-5 assertions fail and Stage 3-4 passes' "got=[$got5]"
    fi
  else
    bad 'Tpre5 at Unit 3 accepted, exactly the eight Stage-5 assertions fail' 'could not read a8671275'
  fi

  CLAIMY="$TMP/claimy"; mkdir -p "$CLAIMY"; cp "$PRE"/*.md "$CLAIMY/"
  printf '\n%s\n' \
    'This command validates the approved Unit Judgment Brief, passes it by path,' \
    'and requires the sub-agent to use its theses, provisional verdict, countercases' \
    'and change conditions, tracing each claim to Thesis N, halting on any conflict' \
    'with the permission tables.' >> "$CLAIMY/run-synthesis.md"
  if [ "$(failing "$CLAIMY")" = "$pre_fail" ]; then
    ok 'T0b  prose asserting the owners consume judgment moves no verdict'
  else
    bad 'T0b  prose asserting the owners consume judgment moves no verdict' "moved to: $(failing "$CLAIMY")"
  fi
else
  bad 'Tpre all 16 assertions fail on the pre-Unit-3 command bodies' "could not read the baseline from $PRE_REF"
  bad 'T0b  prose asserting the owners consume judgment moves no verdict' 'skipped — no baseline'
fi

printf '\n=== every owner is independently live ===\n'

# mutate <label> <expected-failing-set> <file-stem> <awk-program>
# The awk program rewrites one command body; the other two are copied verbatim,
# so a mutation that degraded everything would fail these rather than pass them.
mutate() {
  local label="$1" want="$2" stem="$3" prog="$4"
  local dir="$TMP/m"; rm -rf "$dir"; mkdir -p "$dir"
  cp "$LIVE"/run-analysis.md "$LIVE"/run-synthesis.md "$LIVE"/run-report.md \
     "$LIVE"/produce-prose-draft.md "$LIVE"/produce-formatting.md "$dir/"
  awk "$prog" "$LIVE/$stem.md" > "$dir/$stem.md"
  if cmp -s "$LIVE/$stem.md" "$dir/$stem.md"; then
    bad "$label" "the mutation changed nothing in $stem.md — the anchor is stale"
    return
  fi
  local got; got="$(failing "$dir")"
  if [ "$got" = "$want" ]; then ok "$label"; else bad "$label" "expected failing=[$want] got=[$got]"; fi
}

# Drop the nth line carrying a label.
drop_nth() { printf 'index($0, "%s") > 0 { n++; if (n == %s) next } { print }' "$1" "$2"; }
# Replace the nth line carrying a label with an existence-check-only instruction.
existence_nth() {
  printf 'index($0, "%s") > 0 { n++; if (n == %s) { print "**Required use of approved judgment:** verify the approved brief exists at that path."; next } } { print }' "$1" "$2"
}

P='**Approved judgment (PATH'
U='**Required use of approved judgment:**'

# --- P-series: remove one owner's path handoff ----------------------------
mutate 'P1  section directives lose the approved-brief path'  C1-directives-consume     run-analysis  "$(drop_nth "$P" 1)"
mutate 'P2  cluster synthesis loses the approved-brief path'  C2b-synthesis-consume     run-synthesis "$(drop_nth "$P" 1)"
mutate 'P3  report architecture loses the approved-brief path' C3b-architecture-consume run-report    "$(drop_nth "$P" 1)"
mutate 'P4  chapter prose loses the approved-brief path'      C4-prose-consume          run-report    "$(drop_nth "$P" 2)"
mutate 'P5  compliance QC loses the approved-brief path'      C5-qc-checks-fidelity     run-report    "$(drop_nth "$P" 3)"

# --- U-series: reduce one owner's use instruction to an existence check ---
# This is the failure the whole check exists for. The path handoff survives every
# one of these, so the owner still receives the brief — it just stops being told
# to do anything with it.
mutate 'U1  section directives check existence only'  C1-directives-consume     run-analysis  "$(existence_nth "$U" 1)"
mutate 'U2  cluster synthesis checks existence only'  C2b-synthesis-consume     run-synthesis "$(existence_nth "$U" 1)"
mutate 'U3  report architecture checks existence only' C3b-architecture-consume run-report    "$(existence_nth "$U" 1)"
mutate 'U4  chapter prose checks existence only'      C4-prose-consume          run-report    "$(existence_nth "$U" 2)"
mutate 'U5  compliance QC checks existence only'      C5-qc-checks-fidelity     run-report    "$(existence_nth "$U" 3)"

# --- G-series: remove an entry gate ---------------------------------------
mutate 'G1  /run-synthesis loses its judgment gate' C2a-synthesis-gate run-synthesis "$(drop_nth 'check-judgment-contract.sh' 1)"
mutate 'G2  /run-report loses its judgment gate'    C3a-report-gate    run-report    "$(drop_nth 'check-judgment-contract.sh' 1)"

# --- Q — the compliance QC stops being independent of the drafter ---------
# Drift and permission-overreach survive, so the flip is attributable to the one
# thing removed: the QC being told the brief reaches it without step (a)'s account.
q_prog='index($0, "**Required use of approved judgment:**") > 0 { n++; if (n == 3) { print "**Required use of approved judgment:** check the chapter for drift and evidence-permission overreach."; next } } { print }'
mutate 'Q   compliance QC loses its independence from the drafter' C5-qc-checks-fidelity run-report "$q_prog"

# --- X — the conflict rule disappears -------------------------------------
mutate 'X   run-analysis loses the authority-conflict rule' C6-conflict-surfaced run-analysis "$(drop_nth '**Authority conflict:**' 1)"

# --- S-series: Stage 5, report mode --------------------------------------
mutate 'SP1 report-mode prose refinement loses the approved-brief path' S1b-prose-draft-consume produce-prose-draft "$(drop_nth "$P" 1)"
mutate 'SP2 formatting + H3 loses the approved-brief path'              S2b-formatting-consume  produce-formatting  "$(drop_nth "$P" 1)"
mutate 'SP3 the final editorial QC loses the approved-brief path'       S3-final-qc-fidelity    produce-formatting  "$(drop_nth "$P" 2)"

mutate 'SU1 report-mode prose refinement checks existence only' S1b-prose-draft-consume produce-prose-draft "$(existence_nth "$U" 1)"
mutate 'SU2 formatting + H3 checks existence only'              S2b-formatting-consume  produce-formatting  "$(existence_nth "$U" 1)"
mutate 'SU3 the final editorial QC checks existence only'       S3-final-qc-fidelity    produce-formatting  "$(existence_nth "$U" 2)"

mutate 'SG1 /produce-prose-draft loses its judgment gate' S1a-prose-draft-gate produce-prose-draft "$(drop_nth 'check-judgment-contract.sh' 1)"
mutate 'SG2 /produce-formatting loses its judgment gate'  S2a-formatting-gate  produce-formatting  "$(drop_nth 'check-judgment-contract.sh' 1)"

# SM — the section-mode exemption disappears from one gate. This is the control
# running in the direction the others do not: the danger here is a governance
# check that quietly imposes a judgment prerequisite on section-mode projects,
# which have no Unit Judgment Brief to consume.
mutate 'SM  a Stage 5 gate loses its section-mode exemption' S4-section-mode-exempt produce-prose-draft "$(drop_nth 'Section-mode skips this phase entirely' 1)"

# SQ — the final QC may satisfy House View fidelity from the producers' change
# logs. Trace continuity, drift and permission checks all survive, so the flip is
# attributable to the one thing removed: judging the report rather than the
# producers' account of it.
sq_prog='index($0, "**Required use of approved judgment:**") > 0 { n++; if (n == 2) { print "**Required use of approved judgment:** add a STAGE 3 — House View fidelity check covering thesis trace continuity, authority drift and evidence-permission overreach."; next } } { print }'
mutate 'SQ  the final QC may rest on the producers accounts' S3-final-qc-fidelity produce-formatting "$sq_prog"

# --- SR / SF: the House View result must reach the route ------------------
# Two INDEPENDENT mutations, because the two failures are independent. SR leaves
# the routing branch intact and removes the result the branch reads; SF leaves the
# result intact and removes the branch. Either one alone puts the command back in
# the state the correction was found in: a reviewer identifying authority drift
# while the main route proceeds to handoff with a clean verdict.
sr_prog='index($0, "stage_3_verdict") > 0 && index($0, "report-mode only") > 0 { next } { print }'
mutate 'SR  the Stage 3 result is never returned to the main session' S5-stage3-result-returned produce-formatting "$sr_prog"

# Anchor on text unique to the ROUTING line. `stage_3_verdict: FAIL` also appears
# in the return contract (the could-not-run clause), and matching that would
# delete both lines — collapsing two independent mutations into one.
sf_prog='index($0, "this route does not reach handoff") > 0 { next } { print }'
mutate 'SF  a Stage 3 FAIL has no routing branch and reaches handoff' S6-stage3-fail-blocks produce-formatting "$sf_prog"

printf '\n=== the helper those gates call refuses the right states ===\n'

CONTRACT="$WF/logs/scripts/check-judgment-contract.sh"
BASE="$TMP/j/1.1-unit-judgment-brief"
mkdir -p "$TMP/j"

brief() { # path status [extra-frontmatter-line]
  { printf -- '---\nunit: 1.1\nartifact: unit-judgment-brief\nstatus: %s\nas_of: 2026-08-19\n' "$2"
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
expect_exit() { if [ "$2" = "$3" ]; then ok "$1"; else bad "$1" "expected exit $2, got $3"; fi }

rm -f "$BASE-approved.md"
expect_exit 'A1  missing authority is refused (3)' 3 "$(gate "$BASE-approved.md")"

brief "$BASE-approved.md" proposed
expect_exit 'A2  a proposal at the approved path is refused (4)' 4 "$(gate "$BASE-approved.md")"

brief "$BASE-approved.md" rejected 'rejected_by: Patrik Lindeberg'
expect_exit 'A3  a rejected brief is refused (4)' 4 "$(gate "$BASE-approved.md")"

brief "$BASE-approved.md" approved 'approved_by: Patrik Lindeberg'
sed -i.bak 's/## Provisional verdict/## Verdict/' "$BASE-approved.md"; rm -f "$BASE-approved.md.bak"
expect_exit 'A4  a structurally invalid approval is refused (6)' 6 "$(gate "$BASE-approved.md")"

# A5 is the control that stops A1-A4 from passing for free. Without a state the
# helper ACCEPTS, an always-refusing gate would satisfy every case above.
brief "$BASE-approved.md" approved 'approved_by: Patrik Lindeberg'
expect_exit 'A5  a valid approved brief is accepted (control, 0)' 0 "$(gate "$BASE-approved.md")"

printf '\n%d passed, %d failed\n\n' "$pass" "$fail"
[ "$fail" -eq 0 ] || exit 1
exit 0
