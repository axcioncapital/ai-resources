#!/bin/bash
# Tracer bullet 6 — deterministic lifecycle and recovery proof.
#
# WHAT THIS IS. The frozen durable-state plan assigns nine scenarios to Tracer
# bullet 6: what must happen when a session is fresh, a summary is misleading, an
# actor dies, a write is truncated, a task is blocked, a closure is interrupted
# at either cut point, state and Git disagree, and a closure completes cleanly.
# Each is executed here against the REAL seam — the validator, the owner helper,
# the dispatcher, and Reorient's own resolution route — with a deliberately
# created failure, in a throwaway Git repository.
#
# WHAT IT IS NOT. Not a framework, and not a second copy of the component
# suites. work-loop-state.test.sh, work-loop-owner.test.sh and dispatch.test.sh
# already prove those parts in isolation and are cited, not re-run: T14 in the
# owner suite already cuts a closure at both points, and dispatcher cases 13b and
# 15b already cover a partial edit and a post-edit crash. What is missing, and
# what this file adds, is the COMPOSITION — the scenario as the plan states it,
# end to end, with its own verdict. A scenario that merely re-ran a component
# assertion to collect a new number would add a count and no evidence.
#
# EVERY SCENARIO CARRIES A NEGATIVE CONTROL. Not decoration: several of these
# outcomes are "it stopped", and a check that only asserts a stop passes equally
# well against something that stops at everything. So each scenario also runs the
# nearest case that must NOT stop, or must stop differently, and both halves must
# hold for the scenario to pass. Where the control is the more interesting half
# it is written first.
#
# Case 0 is the suite-level falsifiability proof: it substitutes a rubber-stamp
# validator and asserts the classification-bearing scenarios would go red.
#
# Usage:  bash work-loop-v2-tracer-6.test.sh

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# logs/scripts -> logs -> checkout root. Two levels, not one.
REPO_ROOT="${REPO_ROOT:-$(cd "$HERE/../.." && pwd)}"
STATE_BIN="$HERE/work-loop-state.sh"
OWNER_BIN="$HERE/work-loop-owner.sh"
LEASE_BIN="$HERE/work-loop-lease.sh"
DISPATCH_BIN="$REPO_ROOT/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh"

PASS=0; FAIL=0
SANDBOX_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/wl2-tracer6.XXXXXX")"
trap 'rm -rf "$SANDBOX_ROOT"' EXIT

VERDICTS=""
SCENARIO=""; SCENARIO_FAILS_AT_START=0

ok()  { PASS=$((PASS+1)); printf '  PASS  %s\n' "$1"; }
bad() { FAIL=$((FAIL+1)); printf '  FAIL  %s\n' "$1"; [ -n "${2:-}" ] && printf '        %s\n' "$2"; }

expect_rc() { # want got label output
  [ "$1" = "$2" ] && ok "$3" || bad "$3" "expected exit $1, got $2 — $4"
}
expect_eq() { # want got label
  [ "$1" = "$2" ] && ok "$3" || bad "$3" "expected [$1], got [$2]"
}
expect_ne() { # a b label
  [ "$1" != "$2" ] && ok "$3" || bad "$3" "both sides are [$1] — the control proves nothing"
}

scenario() { # n title
  SCENARIO="S$1"
  SCENARIO_FAILS_AT_START=$FAIL
  printf '\n=== S%s — %s\n' "$1" "$2"
  VERDICTS="${VERDICTS}S$1|$2|"
}
close_scenario() {
  if [ "$FAIL" -eq "$SCENARIO_FAILS_AT_START" ]; then
    VERDICTS="${VERDICTS}PASS"$'\n'
  else
    VERDICTS="${VERDICTS}FAIL"$'\n'
  fi
}

# ---------------------------------------------------------------- fixtures

# The five content fields and the two protocol fields, read the way a reader
# with no conversation would have to read them: off the file.
fm_of()    { sed -n "s/^$2: *//p" "$1" | head -1; }
field_of() { awk -v h="## $2" '$0==h{f=1;next} /^## /{f=0} f' "$1" | sed '/^[[:space:]]*$/d'; }
five_fields() { # file -> one blob holding all five, for equality comparison
  printf 'status=%s\nturn=%s\n' "$(fm_of "$1" status)" "$(fm_of "$1" turn)"
  printf -- '--latest--\n%s\n--blocker--\n%s\n--next--\n%s\n' \
    "$(field_of "$1" 'Latest result')" "$(field_of "$1" 'Blocker')" "$(field_of "$1" 'Next action')"
}

new_checkout() { # -> path
  local d; d="$(mktemp -d "$SANDBOX_ROOT/co.XXXXXX")"
  mkdir -p "$d/logs/work-loop" "$d/logs/scripts"
  git -C "$d" init -q
  git -C "$d" config user.email harness@example.invalid
  git -C "$d" config user.name harness
  git -C "$d" config commit.gpgsign false
  cp "$OWNER_BIN" "$d/logs/scripts/work-loop-owner.sh"
  cp "$STATE_BIN" "$d/logs/scripts/work-loop-state.sh"
  [ -f "$LEASE_BIN" ] && cp "$LEASE_BIN" "$d/logs/scripts/work-loop-lease.sh"
  printf 'sandbox\n' >"$d/README.md"
  printf 'logs/work-loop/.owner\n' >"$d/.gitignore"
  git -C "$d" add -A >/dev/null 2>&1
  git -C "$d" commit -qm "sandbox base" >/dev/null 2>&1
  printf '%s' "$d"
}

# An open record whose five fields are all DISTINCTIVE, so field-level equality
# is a real comparison rather than two empty strings agreeing.
open_record() { # dir task status turn
  local d="$1" task="$2" status="$3" turn="$4" blocker='None.'
  [ "$status" = blocked ] && blocker="Waiting on the operator to choose between design A and design B."
  cat >"$d/logs/work-loop/$task.md" <<EOF
---
task: $task
status: $status
turn: $turn
---

## Objective and scope
Tracer 6 fixture for $task. Nothing real depends on this file.

## Lane and unit
Standard. Implementation mode. Unit 1 — the fixture unit.

## Latest result
Distinctive marker LR-$task: the seventeenth check returned exit 3.

## Blocker
$blocker

## Next action
Distinctive marker NA-$task: run the eighteenth check and report the exit.
EOF
  git -C "$d" add "logs/work-loop/$task.md" >/dev/null 2>&1
  git -C "$d" commit -qm "fixture: $task" >/dev/null 2>&1
}

closed_record() { # dir task
  cat >"$1/logs/work-loop/$2.md" <<EOF
---
task: $2
status: closed
turn: operator
---

## Outcome
Tracer 6 fixture for $2 — closed.

## Decisions that matter
Nothing real depends on this file.

## Evidence
Harness fixture.

## Accepted limitations
None.
EOF
}

classify() { bash "$1/logs/scripts/work-loop-state.sh" validate --checkout "$1" --task "$2" 2>&1; }
declare_owner() { printf '%s\n' "$2" >"$1/logs/work-loop/.owner"; }
owner_of() { [ -f "$1/logs/work-loop/.owner" ] && cat "$1/logs/work-loop/.owner" || printf '(none)'; }

# Reorient's SECOND route, executed literally: the five checks its SKILL.md
# lists, in its order, with no extra reading and no scan. This is the route a
# fresh session must take when the exact task path did not survive compaction,
# and it is deliberately the harder of the two. It returns the five fields plus
# the classification, or a named stop.
reorient_route2() { # checkout -> five-field blob + classification, or STOP:<check>
  local co="$1" decl lines
  # (1) exists, exactly one id, one line, no second field
  [ -f "$co/logs/work-loop/.owner" ] || { printf 'STOP:1 no declaration\n'; return 1; }
  lines="$(wc -l <"$co/logs/work-loop/.owner" | tr -d ' ')"
  decl="$(head -1 "$co/logs/work-loop/.owner")"
  [ -n "$decl" ] || { printf 'STOP:1 empty declaration\n'; return 1; }
  case "$decl" in *[[:space:]]*) printf 'STOP:1 retired two-field shape\n'; return 1 ;; esac
  [ "$lines" -le 1 ] || { printf 'STOP:1 more than one line\n'; return 1; }
  # (2) owner helper confirms the id already read
  bash "$co/logs/scripts/work-loop-owner.sh" check --depth local --checkout "$co" --task "$decl" \
    >/dev/null 2>&1 || { printf 'STOP:2 owner check did not return PROCEED\n'; return 1; }
  # (3) the record exists
  [ -f "$co/logs/work-loop/$decl.md" ] || { printf 'STOP:3 no record for the declared id\n'; return 1; }
  # (4) the validator exits 0 — the single authority, no private re-read
  local class
  class="$(bash "$co/logs/scripts/work-loop-state.sh" validate --checkout "$co" --task "$decl" 2>&1)" \
    || { printf 'STOP:4 validator non-zero\n'; return 1; }
  # (5) the classification is resumable
  case "$class" in
    ACTIVE_CLAUDE|ACTIVE_CODEX) ;;
    *) printf 'STOP:5 %s is not resumable\n' "$class"; return 1 ;;
  esac
  five_fields "$co/logs/work-loop/$decl.md"
  printf 'classification=%s\ntask=%s\n' "$class" "$decl"
}

# ---------------------------------------------------------- dispatcher seam

dispatch_sandbox() { # -> path. Mirrors the dispatcher harness's own sandbox shape.
  local d; d="$(new_checkout)"
  mkdir -p "$d/plans/work-loop-v2-v0.2/handoff-automation-spike"
  printf '%s' "$d"
}
run_dispatch() { # sandbox task [args...] -> $OUT, $RC
  local d="$1" t="$2"; shift 2
  OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task "$t" \
        --log-dir "$d/runs" --timeout 20 "$@" 2>&1)"
  RC=$?
}
calls() { [ -f "$1.calls" ] && wc -l <"$1.calls" | tr -d ' ' || printf '0'; }

# Actor bodies, addressed by pattern rather than line number — the frontmatter
# carries three keys now, so a position-addressed actor would corrupt lifecycle.
FLIP_BODY='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls";
      t=$(sed -n "/^turn: /{p;q;}" "$WL_STATE_FILE");
      case "$t" in
        "turn: codex")  n="turn: claude" ;;
        "turn: claude") n="turn: codex"  ;;
        *) n="$t" ;;
      esac;
      awk -v n="$n" "/^turn: /&&!done{print n; done=1; next}{print}" "$WL_STATE_FILE" > "$WL_STATE_FILE.tmp";
      mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"'
COMMIT_IF_CLAUDE='; if [ "$WL_ACTOR" = "claude" ]; then
        git -C "$WL_CHECKOUT" add "logs/work-loop/$WL_TASK.md" >/dev/null 2>&1;
        git -C "$WL_CHECKOUT" commit -qm "actor commit" >/dev/null 2>&1 || true; fi'
FLIP="$FLIP_BODY$COMMIT_IF_CLAUDE"
CRASH_BEFORE_EDIT='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls"; exit 9'
CRASH_AFTER_EDIT="$FLIP_BODY"'; exit 9'

printf '\n########## Tracer bullet 6 — nine deterministic scenarios ##########\n'

# ==========================================================================
scenario 1 "a fresh session reconstructs the record from durable evidence alone"
# ==========================================================================
# Seam: Reorient route 2 (the validated checkout declaration) + the validator.
# The exact task path is treated as not having survived, which is the harder
# route and the one that can silently guess.
CO="$(new_checkout)"
open_record "$CO" fresh-task active claude
declare_owner "$CO" fresh-task
TRUTH="$(five_fields "$CO/logs/work-loop/fresh-task.md")"

RECON="$(reorient_route2 "$CO")"; RRC=$?
expect_rc 0 "$RRC" "S1    route 2 resolves without a scan" "$RECON"
# The reconstruction appends its classification and the id it resolved; strip
# only those two trailing lines and the remainder must equal the record's fields.
expect_eq "$TRUTH" "$(printf '%s\n' "$RECON" | sed '/^classification=/d;/^task=/d')" \
  "S1    all five fields match the committed record"
# Field by field, so a failure names which one.
expect_eq "active"  "$(printf '%s\n' "$RECON" | sed -n 's/^status=//p')" "S1    status"
expect_eq "claude"  "$(printf '%s\n' "$RECON" | sed -n 's/^turn=//p')"   "S1    turn"
printf '%s\n' "$RECON" | grep -q 'LR-fresh-task'   && ok "S1    latest result" || bad "S1    latest result"
printf '%s\n' "$RECON" | grep -q '^None\.$'        && ok "S1    blocker"       || bad "S1    blocker"
printf '%s\n' "$RECON" | grep -q 'NA-fresh-task'   && ok "S1    next action"   || bad "S1    next action"
expect_eq "ACTIVE_CLAUDE" "$(printf '%s\n' "$RECON" | sed -n 's/^classification=//p')" \
  "S1    classification matches the validator"

# CONTROL — the reconstruction must be READING, not remembering. Change the
# committed record and the same call must return the changed values. A route
# that echoed a constant would pass every assertion above and fail here.
perl -pi -e 's/^Distinctive marker NA-fresh-task.*$/Distinctive marker NA-CHANGED: the record moved on./' \
  "$CO/logs/work-loop/fresh-task.md"
git -C "$CO" commit -qam "the record moves on" >/dev/null 2>&1
RECON2="$(reorient_route2 "$CO")"
printf '%s\n' "$RECON2" | grep -q 'NA-CHANGED' && ok "S1    control: it re-reads the file rather than echoing" \
  || bad "S1    control: it re-reads the file rather than echoing" "$RECON2"
expect_ne "$RECON" "$RECON2" "S1    control: the two reconstructions genuinely differ"
close_scenario

# ==========================================================================
scenario 2 "an empty or misleading summary cannot override durable state"
# ==========================================================================
# Seam: the same route plus the validator. The "summary" is the compacted
# conversation — navigation only, never authority. It is deliberately given
# values that contradict the record on every one of the five fields.
CO="$(new_checkout)"
open_record "$CO" summary-task active codex
declare_owner "$CO" summary-task
TRUTH="$(reorient_route2 "$CO")"
TRUTH_CLASS="$(printf '%s\n' "$TRUTH" | sed -n 's/^classification=//p')"
expect_eq "ACTIVE_CODEX" "$TRUTH_CLASS" "S2    the durable classification is established first"

MISLEADING="status=closed
turn=claude
--latest--
The unit finished and was accepted.
--blocker--
None, everything is done.
--next--
Start the next task."
EMPTY=""

for variant in none empty misleading; do
  case "$variant" in
    none)       SUMMARY="$TRUTH" ;;   # unused; the route never reads it
    empty)      SUMMARY="$EMPTY" ;;
    misleading) SUMMARY="$MISLEADING" ;;
  esac
  # The route reads the repository and nothing else — the summary is in scope of
  # the test, not of the route. That IS the property under proof.
  R="$(reorient_route2 "$CO")"
  expect_eq "$TRUTH" "$R" "S2    with a $variant summary, the five fields are unchanged"
  expect_eq "$TRUTH_CLASS" "$(printf '%s\n' "$R" | sed -n 's/^classification=//p')" \
    "S2    with a $variant summary, the classification is unchanged"
done

# CONTROL — the misleading summary must actually contradict the record, or the
# scenario proves nothing. Two of its claims are checked against the truth.
printf '%s\n' "$MISLEADING" | grep -q '^status=closed' \
  && [ "$(fm_of "$CO/logs/work-loop/summary-task.md" status)" = active ] \
  && ok "S2    control: the summary claims closed while the record says active" \
  || bad "S2    control: the summary claims closed while the record says active"
expect_ne "$MISLEADING" "$TRUTH" "S2    control: the summary and the record genuinely disagree"
# And the summary's claim, if believed, would have changed the classification.
CO2="$(new_checkout)"; closed_record "$CO2" summary-task
git -C "$CO2" add -A >/dev/null 2>&1; git -C "$CO2" commit -qm closed >/dev/null 2>&1
expect_eq "CLOSED" "$(classify "$CO2" summary-task)" \
  "S2    control: a record that really is closed classifies CLOSED, so the two are distinguishable"
close_scenario

# ==========================================================================
scenario 3 "unexpected actor termination preserves partial effects and does not relaunch"
# ==========================================================================
# Seam: the real dispatcher. Failpoint: the actor edits the state file, then dies.
CO="$(dispatch_sandbox)"
open_record "$CO" term-task active codex
run_dispatch "$CO" term-task --actor-cmd "$CRASH_AFTER_EDIT"
expect_rc 20 "$RC" "S3    a post-edit crash stops at ACTOR_FAILED" "$OUT"
expect_eq "1" "$(calls "$CO")" "S3    the actor was launched exactly once — no blind relaunch"
printf '%s' "$OUT" | grep -q 'PARTIAL FILE EFFECTS' \
  && ok "S3    the stop names the partial effects" || bad "S3    the stop names the partial effects" "$OUT"
printf '%s' "$OUT" | grep -Fq "logs/work-loop/term-task.md" \
  && ok "S3    and names the file the dead actor left modified" || bad "S3    and names the file the dead actor left modified"
git -C "$CO" diff --quiet -- logs/work-loop/term-task.md \
  && bad "S3    the partial edit is still on disk, not discarded" "the working tree is clean" \
  || ok "S3    the partial edit is still on disk, not discarded"

# CONTROL — a crash that changed NOTHING is retried exactly once. Without this,
# "launched once" would be indistinguishable from "never retries anything".
CO="$(dispatch_sandbox)"
open_record "$CO" preedit-task active codex
run_dispatch "$CO" preedit-task --actor-cmd "$CRASH_BEFORE_EDIT"
expect_rc 20 "$RC" "S3    control: a pre-edit crash also stops at ACTOR_FAILED" "$OUT"
expect_eq "2" "$(calls "$CO")" "S3    control: but it IS retried once, so the retry rule is real"
close_scenario

# ==========================================================================
scenario 4 "an interrupted state update is rejected before launch, and repair evidence survives"
# ==========================================================================
# Seam: the dispatcher's pre-launch guard. Failpoint: a truncated uncommitted
# edit under turn: codex — the shape a Claude hop killed between editing and
# committing leaves behind.
CO="$(dispatch_sandbox)"
open_record "$CO" trunc-task active codex
COMMITTED="$(git -C "$CO" show "HEAD:logs/work-loop/trunc-task.md")"
head -8 "$CO/logs/work-loop/trunc-task.md" >"$CO/logs/work-loop/trunc-task.md.tmp"
printf 'Distinctive marker TRUNCATED-MID-WRITE\n' >>"$CO/logs/work-loop/trunc-task.md.tmp"
mv "$CO/logs/work-loop/trunc-task.md.tmp" "$CO/logs/work-loop/trunc-task.md"
BEFORE_SUM="$(shasum "$CO/logs/work-loop/trunc-task.md" | cut -d' ' -f1)"

run_dispatch "$CO" trunc-task --actor-cmd "$FLIP"
# 26, not 25: a truncation is caught by the structural check before the
# uncommitted-handback check is ever reached. Which guard fires is part of the
# evidence — the stop must name the damage, not just refuse.
expect_rc 26 "$RC" "S4    the truncated update is rejected before launch" "$OUT"
printf '%s' "$OUT" | grep -q "required heading '## Lane and unit' is missing" \
  && ok "S4    the stop names exactly what the interruption removed" \
  || bad "S4    the stop names exactly what the interruption removed" "$OUT"
printf '%s' "$OUT" | grep -q 'No actor was launched' \
  && ok "S4    and says so, rather than leaving it to be inferred" || bad "S4    and says so, rather than leaving it to be inferred"
expect_eq "0" "$(calls "$CO")" "S4    no actor was launched over it"
expect_eq "$BEFORE_SUM" "$(shasum "$CO/logs/work-loop/trunc-task.md" | cut -d' ' -f1)" \
  "S4    the damaged file was not automatically repaired"
# The two halves of deterministic repair evidence.
expect_eq "$COMMITTED" "$(git -C "$CO" show "HEAD:logs/work-loop/trunc-task.md")" \
  "S4    the last committed state is intact and readable"
git -C "$CO" diff -- logs/work-loop/trunc-task.md | grep -q 'TRUNCATED-MID-WRITE' \
  && ok "S4    the working diff shows exactly what the interruption did" \
  || bad "S4    the working diff shows exactly what the interruption did"

# CONTROL — an uncommitted file under turn: claude is the EXPECTED Codex handoff
# (Codex writes and never runs git), and must run. Without this, S4 could be
# satisfied by a dispatcher that refuses every uncommitted file.
CO="$(dispatch_sandbox)"
open_record "$CO" handoff-task active claude
printf '\nCodex just wrote this and cannot commit it.\n' >>"$CO/logs/work-loop/handoff-task.md"
run_dispatch "$CO" handoff-task --max-hops 1 --actor-cmd "$FLIP"
if [ "$RC" -eq 23 ] && [ "$(calls "$CO")" = "1" ]; then
  ok "S4    control: an uncommitted turn: claude handoff is accepted and runs"
else
  bad "S4    control: an uncommitted turn: claude handoff is accepted and runs" "rc=$RC calls=$(calls "$CO")"
fi
close_scenario

# ==========================================================================
scenario 5 "operator-blocked recovery retains ownership and refuses a new task"
# ==========================================================================
CO="$(new_checkout)"
open_record "$CO" blocked-task blocked operator
declare_owner "$CO" blocked-task
expect_eq "BLOCKED_OPERATOR" "$(classify "$CO" blocked-task)" "S5    the blocked record classifies BLOCKED_OPERATOR"
OWNER_BEFORE="$(owner_of "$CO")"
OUT="$(bash "$CO/logs/scripts/work-loop-owner.sh" claim --checkout "$CO" --task new-task --depth local 2>&1)"; RC=$?
[ "$RC" -ne 0 ] && ok "S5    a new task's claim is refused (exit $RC)" \
                || bad "S5    a new task's claim is refused" "claim succeeded: $OUT"
printf '%s' "$OUT" | grep -q 'blocked-task' \
  && ok "S5    the refusal names the task still holding the checkout" || bad "S5    the refusal names the task still holding the checkout" "$OUT"
expect_eq "$OWNER_BEFORE" "$(owner_of "$CO")" "S5    the declaration is byte-unchanged — ownership retained"
# Blocked is waiting, not finished: it must not read as resumable either.
printf '%s\n' "$(reorient_route2 "$CO")" | grep -q '^STOP:5' \
  && ok "S5    Reorient stops rather than resuming a blocked task" || bad "S5    Reorient stops rather than resuming a blocked task"

# CONTROL — the same checkout with a CLOSED record lets the next task claim it.
# Without this, "refuses a new task" could just mean "never lets anything claim".
# --depth repo, because since the S6 correction the stale row also needs HEAD to
# carry the closing record, and only the git-capable depth can see that. The
# record here IS committed, so the control still measures what it always did.
CO="$(new_checkout)"
closed_record "$CO" done-task
git -C "$CO" add -A >/dev/null 2>&1; git -C "$CO" commit -qm closed >/dev/null 2>&1
declare_owner "$CO" done-task
OUT="$(bash "$CO/logs/scripts/work-loop-owner.sh" claim --checkout "$CO" --task new-task --depth repo 2>&1)"; RC=$?
expect_rc 0 "$RC" "S5    control: over a CLOSED task the new claim succeeds" "$OUT"
expect_eq "new-task" "$(owner_of "$CO")" "S5    control: and the checkout now declares the new task"
close_scenario

# ==========================================================================
scenario 6 "closure interrupted before the commit retains ownership"
# ==========================================================================
# Failpoint: the closing record is written, and the process dies before step 2.
#
# TWO SHAPES OF PRE-COMMIT INTERRUPTION, and only one was covered before.
# work-loop-owner.test.sh T14(b) writes a HALF-written reduction — status flipped
# to closed with the active body still standing — which the validator refuses, so
# staleness is never reached and the declaration is plainly intact. That case is
# green and stays green.
#
# This is the OTHER shape, and the likelier one: core § 4 requires the reduction
# to be ONE write, so a real closing write lands a complete, valid closing record
# and the interruption falls AFTER it. The record on disk is then valid CLOSED
# while HEAD still says active. Everything the plan asks for is asserted below;
# the last two assertions are the ones that matter.
CO="$(new_checkout)"
open_record "$CO" precommit-task active claude
declare_owner "$CO" precommit-task
closed_record "$CO" precommit-task          # step 1: write valid closed state
#                                             step 2: commit — NOT reached
expect_eq "precommit-task" "$(owner_of "$CO")" "S6    the declaration survives the interruption itself"
git -C "$CO" show "HEAD:logs/work-loop/precommit-task.md" | grep -q '^status: closed' \
  && bad "S6    no closure was committed" "HEAD already carries closed state" \
  || ok "S6    no closure was committed"
git -C "$CO" show "HEAD:logs/work-loop/precommit-task.md" | grep -q '^status: active' \
  && ok "S6    the committed record is still the open one" || bad "S6    the committed record is still the open one"
# The reduction on disk is valid, so the validator answers CLOSED for a closure
# that Git has no record of. This is the input to the two assertions below.
expect_eq "CLOSED" "$(classify "$CO" precommit-task)" \
  "S6    the validator reads the uncommitted reduction as CLOSED"

# THE REQUIREMENT. Tracer 6 scenario 6 is "closure interruption before commit
# retains owner", and core § Closing the task names the state this protects
# against: "the lease is gone while the closure is still uncommitted", which it
# calls the one state that cannot be recovered from. Retaining the declaration
# against a passive read is not the property — surviving the next task start is.
# BOTH DEPTHS, because the defect this corrects reached both. --depth local
# cannot establish committedness at all and refuses on that ground; --depth repo
# can, finds HEAD does not carry the closing record, and refuses on that ground.
# One depth alone would leave the other's path unmeasured.
for D in local repo; do
  OUT="$(bash "$CO/logs/scripts/work-loop-owner.sh" claim --checkout "$CO" --task follow-on --depth "$D" 2>&1)"; RC=$?
  [ "$RC" -ne 0 ] && ok "S6    a follow-on task cannot claim the checkout at --depth $D (exit $RC)" \
                  || bad "S6    a follow-on task cannot claim the checkout at --depth $D" "the claim SUCCEEDED over an uncommitted closure: $OUT"
  expect_eq "precommit-task" "$(owner_of "$CO")" "S6    and at --depth $D the declaration is still the interrupted task's"
  # If a claim did go through, record the resulting state exactly — this is the
  # evidence Codex assesses, not a hint that the harness should be relaxed.
  if [ "$RC" -eq 0 ]; then
    printf '        FINDING: after the clear, HEAD still says status: %s while the working tree says status: %s,\n' \
      "$(git -C "$CO" show HEAD:logs/work-loop/precommit-task.md | sed -n 's/^status: //p')" \
      "$(sed -n 's/^status: //p' "$CO/logs/work-loop/precommit-task.md")"
    printf '        and the checkout now declares %s. Lease released, closure uncommitted.\n' "$(owner_of "$CO")"
    declare_owner "$CO" precommit-task   # restore, so the next depth measures the same state
  fi
done

# NEGATIVE CONTROL — the ONE difference that should change the answer is the
# commit. Without it, S6 would pass just as well for a helper that had stopped
# clearing stale declarations altogether, which would break scenarios 5, 7 and 9.
git -C "$CO" add logs/work-loop/precommit-task.md >/dev/null 2>&1
git -C "$CO" commit -qm "the commit the interruption missed" >/dev/null 2>&1
OUT="$(bash "$CO/logs/scripts/work-loop-owner.sh" claim --checkout "$CO" --task follow-on --depth repo 2>&1)"; RC=$?
expect_rc 0 "$RC" "S6    control: once that same closure IS committed, the follow-on task claims it" "$OUT"
expect_eq "follow-on" "$(owner_of "$CO")" "S6    control: and the checkout is now the follow-on task's"
close_scenario

# ==========================================================================
scenario 7 "closure interrupted after the commit yields CLOSED and a clearable stale owner"
# ==========================================================================
# The safe side of the same cut. This is why the order is commit-then-clear.
CO="$(new_checkout)"
open_record "$CO" postcommit-task active claude
declare_owner "$CO" postcommit-task
closed_record "$CO" postcommit-task                                  # step 1
git -C "$CO" add logs/work-loop/postcommit-task.md >/dev/null 2>&1
git -C "$CO" commit -qm "closing record" >/dev/null 2>&1              # step 2
#                                                                      step 3: NOT reached
expect_eq "CLOSED" "$(classify "$CO" postcommit-task)" "S7    the committed state classifies CLOSED"
git -C "$CO" show "HEAD:logs/work-loop/postcommit-task.md" | grep -q '^status: closed' \
  && ok "S7    valid closed state survived the interruption, committed" \
  || bad "S7    valid closed state survived the interruption, committed"
expect_eq "postcommit-task" "$(owner_of "$CO")" "S7    the stale declaration survives rather than being dropped"
# --depth repo: since the S6 correction, clearing a stale declaration needs HEAD
# to carry the closing record, and only this depth can see that. Here it does, so
# the accepted post-commit recovery is unchanged and still needs no operator.
OUT="$(bash "$CO/logs/scripts/work-loop-owner.sh" claim --checkout "$CO" --task next-task --depth repo 2>&1)"; RC=$?
expect_rc 0 "$RC" "S7    the next task start clears the stale declaration by itself" "$OUT"
expect_eq "next-task" "$(owner_of "$CO")" "S7    and the checkout is now the next task's"

# CONTROL — the same clearing must NOT happen over an ACTIVE record. If a stale
# declaration and a live one were cleared alike, S7's recovery would be a bug.
CO="$(new_checkout)"
open_record "$CO" live-task active claude
declare_owner "$CO" live-task
OUT="$(bash "$CO/logs/scripts/work-loop-owner.sh" claim --checkout "$CO" --task next-task --depth local 2>&1)"; RC=$?
[ "$RC" -ne 0 ] && ok "S7    control: an ACTIVE record's declaration is not cleared (exit $RC)" \
                || bad "S7    control: an ACTIVE record's declaration is not cleared" "$OUT"
expect_eq "live-task" "$(owner_of "$CO")" "S7    control: and it still names the live task"
close_scenario

# ==========================================================================
scenario 8 "task state and Git disagreement stops without automatic rewrite"
# ==========================================================================
# Two forms of disagreement, both proved by the same property: the stop mutates
# nothing. Byte identity before and after is the whole assertion.
CO="$(dispatch_sandbox)"
open_record "$CO" disagree-task active codex
# (a) the working tree says something the commit does not.
printf '\nDistinctive marker UNCOMMITTED-DIVERGENCE\n' >>"$CO/logs/work-loop/disagree-task.md"
SUM_BEFORE="$(shasum "$CO/logs/work-loop/disagree-task.md" | cut -d' ' -f1)"
HEAD_BEFORE="$(git -C "$CO" rev-parse HEAD)"
run_dispatch "$CO" disagree-task --actor-cmd "$FLIP"
expect_rc 25 "$RC" "S8a   the dispatcher stops on state/Git divergence" "$OUT"
expect_eq "$SUM_BEFORE" "$(shasum "$CO/logs/work-loop/disagree-task.md" | cut -d' ' -f1)" \
  "S8a   the working file was not rewritten"
expect_eq "$HEAD_BEFORE" "$(git -C "$CO" rev-parse HEAD)" "S8a   and nothing was committed to reconcile it"

# (b) the record's identity disagrees with the file it is in.
CO="$(new_checkout)"
open_record "$CO" ident-task active claude
perl -pi -e 's/^task: ident-task$/task: some-other-task/' "$CO/logs/work-loop/ident-task.md"
SUM_BEFORE="$(shasum "$CO/logs/work-loop/ident-task.md" | cut -d' ' -f1)"
OUT="$(classify "$CO" ident-task)"; RC=$?
[ "$RC" -ne 0 ] && ok "S8b   the validator rejects the identity mismatch (exit $RC)" \
                || bad "S8b   the validator rejects the identity mismatch" "classified: $OUT"
expect_eq "$SUM_BEFORE" "$(shasum "$CO/logs/work-loop/ident-task.md" | cut -d' ' -f1)" \
  "S8b   and the rejection left the record byte-unchanged"

# CONTROL — an agreeing checkout must proceed, or "stops" would be unconditional.
CO="$(dispatch_sandbox)"
open_record "$CO" agree-task active claude
run_dispatch "$CO" agree-task --max-hops 1 --actor-cmd "$FLIP"
if [ "$RC" -eq 23 ] && [ "$(calls "$CO")" = "1" ]; then
  ok "S8    control: with state and Git agreeing, the run proceeds"
else
  bad "S8    control: with state and Git agreeing, the run proceeds" "rc=$RC calls=$(calls "$CO")"
fi
close_scenario

# ==========================================================================
scenario 9 "a clean closure clears ownership and permits checkout reuse"
# ==========================================================================
CO="$(new_checkout)"
open_record "$CO" clean-task active claude
declare_owner "$CO" clean-task
# CONTROL first: while the task is open, the checkout is not reusable.
OUT="$(bash "$CO/logs/scripts/work-loop-owner.sh" claim --checkout "$CO" --task reuse-task --depth local 2>&1)"; RC=$?
[ "$RC" -ne 0 ] && ok "S9    control: before closure a second task cannot claim the checkout (exit $RC)" \
                || bad "S9    control: before closure a second task cannot claim the checkout" "$OUT"

closed_record "$CO" clean-task                                        # step 1
git -C "$CO" add logs/work-loop/clean-task.md >/dev/null 2>&1
git -C "$CO" commit -qm "closing record" >/dev/null 2>&1               # step 2
expect_eq "CLOSED" "$(classify "$CO" clean-task)" "S9    the closing record validates CLOSED before the clear"
OUT="$(bash "$CO/logs/scripts/work-loop-owner.sh" clear --checkout "$CO" --task clean-task 2>&1)"; RC=$?
expect_rc 0 "$RC" "S9    the declaration is cleared, and only after the commit" "$OUT"                # step 3
[ -f "$CO/logs/work-loop/.owner" ] && bad "S9    the declaration is gone" "still present" \
                                   || ok "S9    the declaration is gone"
OUT="$(bash "$CO/logs/scripts/work-loop-owner.sh" claim --checkout "$CO" --task reuse-task --depth local 2>&1)"; RC=$?
expect_rc 0 "$RC" "S9    a new task can now claim the checkout" "$OUT"
expect_eq "reuse-task" "$(owner_of "$CO")" "S9    and the checkout declares it"
close_scenario

# ==========================================================================
printf '\n=== Case 0 — falsifiability of the suite itself\n'
# ==========================================================================
# Substitute a validator that always answers ACTIVE_CLAUDE. Every scenario that
# turns on a classification — 2, 5, 7, 9 — must then read the wrong answer. If
# the stub changed nothing, those scenarios were not testing the validator.
CO="$(new_checkout)"
closed_record "$CO" stub-task
git -C "$CO" add -A >/dev/null 2>&1; git -C "$CO" commit -qm closed >/dev/null 2>&1
REAL="$(classify "$CO" stub-task)"
printf '#!/bin/bash\nprintf "ACTIVE_CLAUDE\\n"\nexit 0\n' >"$CO/logs/scripts/work-loop-state.sh"
STUBBED="$(classify "$CO" stub-task)"
expect_eq "CLOSED" "$REAL" "0     the real validator classifies the closed record CLOSED"
expect_eq "ACTIVE_CLAUDE" "$STUBBED" "0     the stub answers ACTIVE_CLAUDE for the same record"
expect_ne "$REAL" "$STUBBED" "0     so S2/S5/S7/S9's classification assertions would go red under the stub"

# ==========================================================================
printf '\n########## scenario verdicts ##########\n'
printf '%s' "$VERDICTS" | while IFS='|' read -r n title v; do
  [ -n "$n" ] || continue
  printf '  %-4s %-6s %s\n' "$n" "$v" "$title"
done
printf '\n-----------------------------------------------\n'
printf 'pass=%s fail=%s  (component proof at the validator, owner helper and dispatcher is cited, not re-run)\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] || exit 1
