#!/usr/bin/env bash
# check-judgment-consumption.sh — does approved judgment actually GOVERN the
# downstream owners, or does it merely exist before they run?
#
# WHAT THIS IS FOR. Unit 2 wired the seam that CREATES approved judgment, and
# gated `/run-analysis` on it. That gate protects exactly one command. The three
# owners that turn judgment into consequential output — synthesis, report
# architecture, report prose — live in `/run-synthesis` and `/run-report`, which
# are separate commands the operator invokes directly in a fresh session. Before
# this check existed, both could run start to finish with no approved brief at
# all, and every artifact they produced would look complete.
#
# Sequence is not consumption. An owner that runs after the gate, or that checks
# the approved file exists and then drafts from something else, has proved
# nothing. So each owner is checked on four separate things, and the assertions
# are written so that satisfying one cannot satisfy another:
#
#   VALIDATE  the entry point refuses to run on missing/proposed/rejected/invalid
#             authority, by exit code from the contract's own helper
#   PASS      the approved brief reaches the sub-agent BY PATH, which the agent
#             reads itself — not by filename, not by content relay
#   USE       the sub-agent is required to shape its output from the theses,
#             verdict, countercases and change conditions
#   TRACE     the output names which thesis each consequential claim or
#             structural choice implements
#
# HOW IT AVOIDS BEING A KEYWORD CHECK. Every assertion reads a labelled clause
# inside one owner's own dispatch region, never the file at large: a directive
# that satisfies an assertion from some other step is not the same wiring.
# `check-judgment-consumption.test.sh` proves each is live by mutating a copy of
# the REAL command bodies — including the mutation that matters most, reducing a
# use instruction to an existence check.
#
# Usage:
#   check-judgment-consumption.sh [--commands <dir>] [--format tsv]
#
# Exit: 0 every assertion holds, 1 one or more failed, 2 usage or input error.

set -u

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CMDS="$HERE/../../.claude/commands"
FORMAT=text

while [ "$#" -gt 0 ]; do
  case "$1" in
    --commands) [ "$#" -ge 2 ] || { echo "--commands needs a value" >&2; exit 2; }
                CMDS="$2"; shift 2 ;;
    --format)   [ "$#" -ge 2 ] || { echo "--format needs a value" >&2; exit 2; }
                FORMAT="$2"; shift 2 ;;
    -h|--help)  sed -n '2,36p' "$0"; exit 0 ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
done

ANALYSIS="$CMDS/run-analysis.md"
SYNTH="$CMDS/run-synthesis.md"
REPORT="$CMDS/run-report.md"
for f in "$ANALYSIS" "$SYNTH" "$REPORT"; do
  [ -f "$f" ] && [ -r "$f" ] || { echo "not a readable file: $f" >&2; exit 2; }
done

# ---------------------------------------------------------------------------
# One owner = one region of one command body. Reading the region rather than the
# file is what makes "this owner consumes judgment" a different claim from "this
# command mentions judgment somewhere".
# ---------------------------------------------------------------------------
region() {  # $1 = file, $2 = start ERE, $3 = end ERE
  awk -v s="$2" -v e="$3" '
    $0 ~ s { inb = 1; print; next }
    inb && $0 ~ e { inb = 0 }
    inb { print }
  ' "$1"
}

# The clause a bold label introduces, to the next label, numbered item, lettered
# sub-step or heading.
clause() {  # $1 = label ERE
  awk -v pat="$1" '
    $0 ~ pat { inb = 1; print; next }
    inb && /^[*][*]/ { inb = 0 }
    inb && /^[0-9]+\. / { inb = 0 }
    inb && /^#+ / { inb = 0 }
    inb { print }
  '
}

results=""
failures=0
record() { results="${results}$1	$2	$3
"; [ "$2" = FAIL ] && failures=$((failures + 1)); return 0; }
has() { printf '%s\n' "$1" | grep -qE -- "$2"; }

# Bracket every literal metacharacter: awk's ERE rejects `\(`, and the failure is
# silent in the worst way — the region reads empty and the assertion fails for a
# reason that has nothing to do with the command body.
PATH_LABEL='[*][*]Approved judgment [(]PATH'
USE_LABEL='[*][*]Required use of approved judgment:[*][*]'

# Checks PASS/USE/TRACE for one owner region. VALIDATE is separate: it belongs to
# the entry point, and several owners share one entry point.
owner() {  # $1 = id, $2 = region text, $3 = human name
  local id="$1" reg="$2" name="$3" why="" pth use
  pth="$(printf '%s\n' "$reg" | clause "$PATH_LABEL")"
  use="$(printf '%s\n' "$reg" | clause "$USE_LABEL")"

  [ -n "$pth" ] || why="${why}no **Approved judgment (PATH ...)** handoff; "
  has "$pth" '\-approved\.md' || why="${why}the handoff must name {base}-approved.md; "

  [ -n "$use" ] || why="${why}no **Required use of approved judgment:** instruction; "
  # An existence check is the failure this assertion exists to catch, so the use
  # instruction has to name what the owner must actually read out of the brief.
  has "$use" '[Tt]hes[ei]s' || why="${why}the use instruction must name the theses; "
  has "$use" '[Vv]erdict' || why="${why}the use instruction must name the provisional verdict; "
  has "$use" '[Cc]ountercase' || why="${why}the use instruction must name the countercases; "
  has "$use" '[Cc]hange the view|[Cc]hange condition' || why="${why}the use instruction must name the change conditions; "
  has "$use" 'Thesis N|thesis it implements|thesis each' || why="${why}the use instruction must require per-item thesis traceability; "

  if [ -z "$why" ]; then
    record "$id" PASS "$name: path handoff + use of theses/verdict/countercases/change conditions + trace"
  else
    record "$id" FAIL "$name: ${why%; }"
  fi
}

# VALIDATE for one entry point: it must run the contract helper on the approved
# brief and branch on the exit code, and it must refuse rather than warn.
entry_gate() {  # $1 = id, $2 = region, $3 = name
  local id="$1" reg="$2" name="$3" why=""
  has "$reg" 'check-judgment-contract\.sh.*-approved\.md' || why="${why}the entry must validate {base}-approved.md; "
  has "$reg" 'check-judgment-contract\.sh.*-approved\.md.*--allow-proposed' && why="${why}the entry must not accept a proposal; "
  has "$reg" 'Exit 0' || why="${why}the entry must branch on exit 0; "
  has "$reg" 'exit|halt|refuse' || why="${why}a nonzero exit must stop the command, not warn; "
  has "$reg" '[*][*]Authority conflict:[*][*]' || why="${why}the entry must carry the **Authority conflict:** rule; "
  if [ -z "$why" ]; then
    record "$id" PASS "$name: validates approved authority and surfaces conflicts"
  else
    record "$id" FAIL "$name: ${why%; }"
  fi
}

# --- C1  section directives — /run-analysis Step 4 -------------------------
# Entry-point validation is Unit 2's Step 3.5e gate in this same command, and
# Step 4 is not independently invokable, so this owner is checked on consumption
# only. Adding a second gate here would stack ceremony without closing anything.
owner C1-directives-consume "$(region "$ANALYSIS" '^### Step 4:' '^### Step [0-9]')" 'section directives'

# --- C2  synthesis — /run-synthesis ----------------------------------------
entry_gate C2a-synthesis-gate "$(region "$SYNTH" '^### Step 0b:' '^### Step [0-9]')" '/run-synthesis entry'
owner C2b-synthesis-consume "$(region "$SYNTH" '^### Step 2:' '^### Step [0-9]')" 'cluster synthesis'

# --- C3  report architecture — /run-report ---------------------------------
entry_gate C3a-report-gate "$(region "$REPORT" '^### Step 4.0b:' '^### Step 4')" '/run-report entry'
owner C3b-architecture-consume "$(region "$REPORT" '^### Step 4.1:' '^### Step 4')" 'report architecture'

# --- C4  report prose — /run-report Step 4.2a ------------------------------
owner C4-prose-consume "$(region "$REPORT" '^[*][*]a[.] Draft chapter prose' '^[*][*][b-z][.] ')" 'chapter prose'

# --- C5  independent compliance QC — /run-report Step 4.2c -----------------
# This owner carries two conditions the others do not: the brief must reach it
# WITHOUT the drafting sub-agent's account of what it did, and it must be told to
# look for drift, not just for compliance with the sources it already had.
qc="$(region "$REPORT" '^[*][*]c[.] Compliance QC' '^[*][*][d-z][.] ')"
qc_use="$(printf '%s\n' "$qc" | clause "$USE_LABEL")"
qc_path="$(printf '%s\n' "$qc" | clause "$PATH_LABEL")"
c5=""
[ -n "$qc_path" ] || c5="${c5}the QC must receive the approved brief by path; "
has "$qc_path" '\-approved\.md' || c5="${c5}the QC handoff must name {base}-approved.md; "
[ -n "$qc_use" ] || c5="${c5}no **Required use of approved judgment:** instruction; "
has "$qc_use" 'step \(a\)|drafting sub-agent|producer' || c5="${c5}the QC must be told the brief arrives independently of the drafter's account; "
has "$qc_use" 'drift' || c5="${c5}the QC must check drift beyond the approved view; "
has "$qc_use" 'permission' || c5="${c5}the QC must check evidence-permission overreach; "
if [ -z "$c5" ]; then
  record C5-qc-checks-fidelity PASS 'compliance QC: independent path handoff + drift and permission-overreach checks'
else
  record C5-qc-checks-fidelity FAIL "compliance QC: ${c5%; }"
fi

# --- C6  the approved brief does not outrank the other controls ------------
# Judgment governs downstream work; it does not replace permission tables,
# scarcity instructions, gate-clearance caveats or operator decisions. Where two
# genuinely conflict the command halts, because silently preferring either one is
# a decision no owner here is entitled to make.
c6=""
for pair in "run-analysis:$ANALYSIS" "run-synthesis:$SYNTH" "run-report:$REPORT"; do
  name="${pair%%:*}"; file="${pair#*:}"
  cl="$(clause '[*][*]Authority conflict:[*][*]' < "$file")"
  [ -n "$cl" ] || { c6="${c6}$name carries no **Authority conflict:** rule; "; continue; }
  has "$cl" 'permission' || c6="${c6}$name's conflict rule omits the permission tables; "
  has "$cl" 'halt|stop' || c6="${c6}$name's conflict rule must halt rather than choose; "
done
if [ -z "$c6" ]; then
  record C6-conflict-surfaced PASS 'all three commands halt on a genuine authority conflict'
else
  record C6-conflict-surfaced FAIL "${c6%; }"
fi

if [ "$FORMAT" = tsv ]; then
  printf '%s' "$results"
else
  printf 'judgment consumption — %s\n\n' "$CMDS"
  printf '%s' "$results" | while IFS=$'\t' read -r id verdict detail; do
    printf '  %-26s %-4s %s\n' "$id" "$verdict" "$detail"
  done
  printf '\n'
  if [ "$failures" -eq 0 ]; then
    printf 'APPROVED JUDGMENT GOVERNS — all assertions hold.\n'
  else
    printf 'NOT GOVERNING — %d assertion(s) failed.\n' "$failures"
  fi
fi

[ "$failures" -eq 0 ] || exit 1
exit 0
