#!/bin/bash
# Isolation checker for the two-worktree parallel proof (SPIKE, not production).
#
# Judges one completed sandbox run against the properties the proof claims. It is
# deliberately separable from the run itself: the run produces facts, this reads
# them back and asserts. Every assertion prints PASS or FAIL with the value it
# actually saw, so a green line is readable as evidence rather than as reassurance.
#
# The expectations are overridable ON PURPOSE. A checker nobody has ever seen fail
# is not evidence that the run was clean — it is an untested instrument. Pass
# --expect-worktree-alpha with a path the run never used and A8 must go red; that
# controlled negative witness is what makes the green run mean something. It
# manufactures the failure by lying to the checker, never by writing across a real
# worktree boundary.
#
# Usage:
#   parallel-isolation-check.sh --sandbox <root> --base <sha>
#       [--expect-worktree-alpha <abs-path>] [--expect-worktree-beta <abs-path>]
#       [--expect-marker-alpha <string>]     [--expect-marker-beta <string>]
#       [--sampler <file>]
#
# Exit: 0 when every assertion passed, 1 otherwise.

set -uo pipefail

SANDBOX=""; BASE=""; SAMPLER=""
EXP_WT_ALPHA=""; EXP_WT_BETA=""
EXP_MK_ALPHA="WL2-ALPHA-UNIQUE-MARKER-7Q4X"
EXP_MK_BETA="WL2-BETA-UNIQUE-MARKER-3M8P"

while [ $# -gt 0 ]; do
  case "$1" in
    --sandbox)               SANDBOX="${2:-}"; shift 2 ;;
    --base)                  BASE="${2:-}"; shift 2 ;;
    --sampler)               SAMPLER="${2:-}"; shift 2 ;;
    --expect-worktree-alpha) EXP_WT_ALPHA="${2:-}"; shift 2 ;;
    --expect-worktree-beta)  EXP_WT_BETA="${2:-}"; shift 2 ;;
    --expect-marker-alpha)   EXP_MK_ALPHA="${2:-}"; shift 2 ;;
    --expect-marker-beta)    EXP_MK_BETA="${2:-}"; shift 2 ;;
    *) printf 'unknown argument: %s\n' "$1" >&2; exit 2 ;;
  esac
done
[ -n "$SANDBOX" ] || { echo "--sandbox is required" >&2; exit 2; }
[ -n "$BASE" ]    || { echo "--base is required" >&2; exit 2; }
[ -n "$EXP_WT_ALPHA" ] || EXP_WT_ALPHA="$(cd "$SANDBOX/wt-alpha" 2>/dev/null && pwd -P)"
[ -n "$EXP_WT_BETA" ]  || EXP_WT_BETA="$(cd "$SANDBOX/wt-beta" 2>/dev/null && pwd -P)"
[ -n "$SAMPLER" ] || SAMPLER="$SANDBOX/evidence/parallel-sampler.txt"

INTEGRATION="$SANDBOX/integration"
FAILED=0

ok()   { printf 'PASS  %-4s %s\n' "$1" "$2"; }
bad()  { printf 'FAIL  %-4s %s\n' "$1" "$2"; FAILED=1; }
check(){ # id, condition-result(0/1), message
  if [ "$2" -eq 0 ]; then ok "$1" "$3"; else bad "$1" "$3"; fi
}

owned_alpha=$'logs/work-loop/wl2-alpha.md\nplans/work-loop-v2-v0.2/handoff-automation-spike/sandbox-fixtures/alpha-result.md'
owned_beta=$'logs/work-loop/wl2-beta.md\nplans/work-loop-v2-v0.2/handoff-automation-spike/sandbox-fixtures/beta-result.md'

branch_paths() { git -C "$INTEGRATION" diff --name-only "$BASE".."$1" 2>/dev/null | sort; }

# --- A1/A2: each branch changed only the paths its task owns -----------------
for pair in "alpha:wl2/alpha" "beta:wl2/beta"; do
  name="${pair%%:*}"; branch="${pair#*:}"
  eval "owned=\$owned_$name"
  actual="$(branch_paths "$branch")"
  expected="$(printf '%s\n' "$owned" | sort)"
  extra="$(comm -23 <(printf '%s\n' "$actual") <(printf '%s\n' "$expected"))"
  id="A1"; [ "$name" = "beta" ] && id="A2"
  if [ -z "$extra" ] && [ -n "$actual" ]; then
    check "$id" 0 "$name branch changed only owned paths: $(printf '%s' "$actual" | tr '\n' ' ')"
  else
    check "$id" 1 "$name branch changed unowned or no paths — extra: [$(printf '%s' "$extra" | tr '\n' ' ')] all: [$(printf '%s' "$actual" | tr '\n' ' ')]"
  fi
done

# --- A3/A4: each task produced its own unique result ------------------------
a_res="$SANDBOX/wt-alpha/plans/work-loop-v2-v0.2/handoff-automation-spike/sandbox-fixtures/alpha-result.md"
b_res="$SANDBOX/wt-beta/plans/work-loop-v2-v0.2/handoff-automation-spike/sandbox-fixtures/beta-result.md"
grep -qF "$EXP_MK_ALPHA" "$a_res" 2>/dev/null; check A3 $? "alpha result carries $EXP_MK_ALPHA"
grep -qF "$EXP_MK_BETA"  "$b_res" 2>/dev/null; check A4 $? "beta result carries $EXP_MK_BETA"

# --- A5: neither task's output leaked into the sibling worktree -------------
# Scoped to the two directories a task may write, so an unrelated repo file that
# happens to mention a marker cannot mask a real leak or fake one.
leak=0
grep -rqF "$EXP_MK_ALPHA" "$SANDBOX/wt-beta/logs/work-loop" "$SANDBOX/wt-beta/plans/work-loop-v2-v0.2/handoff-automation-spike/sandbox-fixtures" 2>/dev/null && leak=1
grep -rqF "$EXP_MK_BETA"  "$SANDBOX/wt-alpha/logs/work-loop" "$SANDBOX/wt-alpha/plans/work-loop-v2-v0.2/handoff-automation-spike/sandbox-fixtures" 2>/dev/null && leak=1
check A5 "$leak" "no task's marker appears in the sibling worktree"

# --- A6: neither branch touched the sibling's state file --------------------
cross=0
branch_paths wl2/alpha | grep -q 'wl2-beta\.md'  && cross=1
branch_paths wl2/beta  | grep -q 'wl2-alpha\.md' && cross=1
check A6 "$cross" "neither branch touched the sibling's state file"

# --- A7: both tasks reached a terminal turn: operator -----------------------
turn_of() { awk 'NR==1{if($0!="---")exit} /^turn:/{gsub(/^turn:[ \t]*/,"");print;exit} /^---$/&&NR>1{exit}' "$1" 2>/dev/null; }
ta="$(turn_of "$SANDBOX/wt-alpha/logs/work-loop/wl2-alpha.md")"
tb="$(turn_of "$SANDBOX/wt-beta/logs/work-loop/wl2-beta.md")"
[ "$ta" = "operator" ] && [ "$tb" = "operator" ]; check A7 $? "both state files terminal at turn: operator (alpha=$ta beta=$tb)"

# --- A8: every live child ran in the worktree it was routed to --------------
# The sampler's cwd column is a kernel fact about the process, not a re-reading of
# the dispatcher's source. Claude is routed by cwd; Codex by its -C argument, so
# each is judged against the mechanism that actually carries it.
if [ -f "$SAMPLER" ]; then
  wrong="$(awk -v wa="$EXP_WT_ALPHA" -v wb="$EXP_WT_BETA" '
    /^  t=/ {
      kind=""; cwd=""; route=""
      for (i = 1; i <= NF; i++) {
        if ($i == "claude" || $i == "codex" || $i == "dispatcher") kind = $i
        if ($i ~ /^cwd=/)   cwd   = substr($i, 5)
        if ($i ~ /^route=/) route = substr($i, 7)
      }
      if (kind == "claude") {
        if (route == "wl2-alpha" && cwd != wa) print "claude/" route " cwd=" cwd
        if (route == "wl2-beta"  && cwd != wb) print "claude/" route " cwd=" cwd
      }
      if (kind == "codex") {
        if (route != wa && route != wb) print "codex -C=" route
      }
    }' "$SAMPLER" | sort -u)"
  observed="$(grep -cE '^  t=[0-9]+ +(claude|codex) ' "$SAMPLER" 2>/dev/null)"
  if [ -z "$wrong" ] && [ "${observed:-0}" -gt 0 ]; then
    check A8 0 "all $observed sampled actor processes ran in their routed worktree"
  else
    check A8 1 "actor routing mismatch (observed=$observed): $(printf '%s' "$wrong" | tr '\n' '; ')"
  fi
else
  check A8 1 "sampler file missing: $SAMPLER"
fi

# --- A9: the integration checkout was never used as a workspace -------------
ihead="$(git -C "$INTEGRATION" rev-parse HEAD 2>/dev/null)"
idirty="$(git -C "$INTEGRATION" status --porcelain 2>/dev/null | wc -l | tr -d ' ')"
istaged="$(git -C "$INTEGRATION" diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')"
[ "$ihead" = "$BASE" ] && [ "$idirty" -eq 0 ] && [ "$istaged" -eq 0 ]
check A9 $? "integration checkout still at base, clean index and tree (head=${ihead:0:7} dirty=$idirty staged=$istaged)"

echo
[ "$FAILED" -eq 0 ] && { echo "RESULT: all assertions passed"; exit 0; }
echo "RESULT: at least one assertion failed"; exit 1
