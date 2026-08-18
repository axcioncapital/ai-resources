#!/bin/bash
# Tracer bullet 7 — checkout binding, migration, and live concurrency proof.
#
# WHAT THIS IS. The frozen durable-state plan assigns nine scenarios to Tracer
# bullet 7: which stale-owner rows clear and which hold; two worktrees with
# different tasks; multiple claims and multiple unowned copies; two actors on one
# task; an attended/unattended collision; explicit migration and its interrupted
# half; and three bounded LIVE recoveries — fresh session, compaction/Reorient,
# and cross-courier. Each is executed against the REAL seam: the owner helper at
# repository depth over REAL linked git worktrees, the shipped shared lease
# library held by REAL concurrent processes, and the REAL attended carrier and
# unattended dispatcher launched as top-level programs.
#
# WHAT IT IS NOT. Not a framework, and not a second copy of the component suites.
# work-loop-owner.test.sh, work-loop-lease.test.sh, carry-turn.test.sh and
# dispatch.test.sh already prove their parts in isolation and are cited, not
# re-run. Tracer 6 already proves the deterministic lifecycle half. What is
# missing, and what this file adds, is the COMPOSITION — the scenario as the plan
# states it, across checkouts and across processes, with its own verdict.
#
# NO NESTED MODEL IS LAUNCHED, EVER. Both transports take their leases and run
# their ownership admission BEFORE any actor starts, so the contention this file
# proves happens entirely in the real transport process. Where an actor must
# actually run, it is a sentinel binary passed through the transports' ordinary
# --claude-bin / --codex-bin arguments — the same seam carry-turn.test.sh uses.
# The sentinel is PROVEN CAPABLE of writing its marker in a control run, so
# "actor_launched=no" is a result the run could have failed on rather than an
# absence that proves nothing.
#
# LIVE MEANS SIMULTANEOUS. Scenarios 2, 4, 5 and 9 rendezvous their processes
# through the filesystem and assert the decisive observation while the other side
# is provably still running. A sequential approximation is not a concurrency
# proof and is not accepted here.
#
# EVERY SCENARIO CARRIES A NEGATIVE CONTROL. Most of these outcomes are "it
# refused", and a check that only asserts a refusal passes equally well against
# something that refuses at everything. So each scenario also runs the nearest
# case that must NOT refuse, or must refuse differently.
#
# Case 0 is the suite-level falsifiability proof: it substitutes a rubber-stamp
# owner helper and asserts the verdict-bearing scenarios would go red.
#
# Usage:  bash work-loop-v2-tracer-7.test.sh

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# logs/scripts -> logs -> checkout root. Two levels, not one.
REPO_ROOT="${REPO_ROOT:-$(cd "$HERE/../.." && pwd)}"
STATE_BIN="$HERE/work-loop-state.sh"
# Overridable for the FAILING-FIRST control only, the same device the shared
# lease suite uses (`WL_LEASE_LIB=`): point it at an earlier build of the helper
# and the rows that build gets wrong must go red. Unset, it is the shipped file.
OWNER_BIN="${WL_OWNER_BIN:-$HERE/work-loop-owner.sh}"
LEASE_BIN="$HERE/work-loop-lease.sh"
CARRY_BIN="$REPO_ROOT/scripts/axcion-harness-v0.2/carry-turn.sh"
DISPATCH_BIN="$REPO_ROOT/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh"
REORIENT_HOOK="$REPO_ROOT/.codex/hooks/work-loop-reorient.sh"

PASS=0; FAIL=0
SANDBOX_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/wl2-tracer7.XXXXXX")"

# Worktrees created below live inside $SANDBOX_ROOT, and their base repositories
# do too, so removing the root removes both halves. Any background sentinel still
# alive at exit is killed first: a live process holding a lease under a directory
# that is about to vanish is how a suite leaves a wedged machine behind.
cleanup() {
  local p
  for p in $BG_PIDS; do kill -TERM "$p" 2>/dev/null; done
  sleep 1
  for p in $BG_PIDS; do kill -KILL "$p" 2>/dev/null; done
  rm -rf "$SANDBOX_ROOT"
}
BG_PIDS=""
trap cleanup EXIT

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
expect_has() { # haystack needle label
  case "$1" in *"$2"*) ok "$3" ;; *) bad "$3" "[$2] not found in: $(printf '%s' "$1" | head -c 400)" ;; esac
}
expect_lacks() { # haystack needle label
  case "$1" in *"$2"*) bad "$3" "[$2] IS present in: $(printf '%s' "$1" | head -c 400)" ;; *) ok "$3" ;; esac
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

# The five content fields and the two protocol fields, read the way a reader with
# no conversation would have to read them: off the file. Same shape as Tracer 6,
# so scenario 7's field-level equality is comparable across the two proofs.
fm_of()    { sed -n "s/^$2: *//p" "$1" | head -1; }
field_of() { awk -v h="## $2" '$0==h{f=1;next} /^## /{f=0} f' "$1" | sed '/^[[:space:]]*$/d'; }
five_fields() { # file -> one blob holding all five, for equality comparison
  printf 'status=%s\nturn=%s\n' "$(fm_of "$1" status)" "$(fm_of "$1" turn)"
  printf -- '--latest--\n%s\n--blocker--\n%s\n--next--\n%s\n' \
    "$(field_of "$1" 'Latest result')" "$(field_of "$1" 'Blocker')" "$(field_of "$1" 'Next action')"
}

# A base repository on `main`, carrying the three helpers TRACKED. Tracked and
# committed for the reason carry-turn.test.sh documents: logs/scripts/ is outside
# the transports' default allow-path set, so an untracked helper is an
# out-of-allowlist working-tree change and a transport would correctly stop on it
# before ever reaching the behaviour under test.
new_base() { # -> path
  local d; d="$(mktemp -d "$SANDBOX_ROOT/base.XXXXXX")"
  d="$(cd "$d" && pwd -P)"
  mkdir -p "$d/logs/work-loop" "$d/logs/scripts"
  git -C "$d" init -q -b main
  git -C "$d" config user.email harness@example.invalid
  git -C "$d" config user.name harness
  git -C "$d" config commit.gpgsign false
  cp "$OWNER_BIN" "$d/logs/scripts/work-loop-owner.sh"
  cp "$STATE_BIN" "$d/logs/scripts/work-loop-state.sh"
  cp "$LEASE_BIN" "$d/logs/scripts/work-loop-lease.sh"
  printf 'sandbox\n' >"$d/README.md"
  printf 'logs/work-loop/.owner\n' >"$d/.gitignore"
  git -C "$d" add -A >/dev/null 2>&1
  git -C "$d" commit -qm "sandbox base" >/dev/null 2>&1
  printf '%s' "$d"
}

# A REAL linked worktree of that repository — the thing `--depth repo` enumerates.
# A second `git init` would not do: the whole point of repository depth is that
# one Git object store binds several checkouts, and two unrelated repositories
# share nothing for the helper to see.
add_worktree() { # base name -> path
  local p="$SANDBOX_ROOT/wt-$2-$$-$RANDOM"
  git -C "$1" worktree add -q "$p" -b "$2" main >/dev/null 2>&1
  [ -d "$p" ] || { printf 'HARNESS ERROR: worktree %s was not created\n' "$2" >&2; exit 2; }
  mkdir -p "$p/logs/work-loop"
  (cd "$p" && pwd -P)
}

# An open record whose five fields are all DISTINCTIVE, so field-level equality is
# a real comparison rather than two empty strings agreeing.
open_record() { # dir task status turn [commit?]
  local d="$1" task="$2" status="$3" turn="$4" blocker='None.'
  [ "$status" = blocked ] && blocker="Waiting on the operator to choose between design A and design B."
  cat >"$d/logs/work-loop/$task.md" <<EOF
---
task: $task
status: $status
turn: $turn
---

## Objective and scope
Tracer 7 fixture for $task. Nothing real depends on this file.

## Lane and unit
Standard. Implementation mode. Unit 1 — the fixture unit.

## Latest result
Distinctive marker LR-$task: the twenty-third check returned exit 17.

## Blocker
$blocker

## Next action
Distinctive marker NA-$task: run the twenty-fourth check and report the exit.
EOF
  if [ "${5:-commit}" = commit ]; then
    git -C "$d" add "logs/work-loop/$task.md" >/dev/null 2>&1
    git -C "$d" commit -qm "fixture: $task" >/dev/null 2>&1
  fi
}

closed_record() { # dir task [commit?]
  cat >"$1/logs/work-loop/$2.md" <<EOF
---
task: $2
status: closed
turn: operator
---

## Outcome
Tracer 7 fixture for $2 — closed.

## Decisions that matter
Nothing real depends on this file.

## Evidence
Harness fixture.

## Accepted limitations
None.
EOF
  if [ "${3:-commit}" = commit ]; then
    git -C "$1" add "logs/work-loop/$2.md" >/dev/null 2>&1
    git -C "$1" commit -qm "close: $2" >/dev/null 2>&1
  fi
}

classify()     { bash "$1/logs/scripts/work-loop-state.sh" validate --checkout "$1" --task "$2" 2>&1; }
# mkdir first: `git rm` of the last record in logs/work-loop removes the now-empty
# directory, and a declaration is written into a checkout that may legitimately
# store no record at all.
declare_owner(){ mkdir -p "$1/logs/work-loop"; printf '%s\n' "$2" >"$1/logs/work-loop/.owner"; }
owner_of()     { [ -f "$1/logs/work-loop/.owner" ] && tr -d '\n' <"$1/logs/work-loop/.owner" || printf '(none)'; }
# Sets OWNV (verdict word) and OWNRC (exit). The verdict word is read off the
# helper's own `verdict:` line rather than inferred from the exit code, so a
# helper whose two channels disagreed would show up rather than be smoothed over.
own() { # checkout task depth [verb]
  local out
  out="$(bash "$1/logs/scripts/work-loop-owner.sh" "${4:-check}" --checkout "$1" --task "$2" --depth "$3" 2>&1)"
  OWNRC=$?
  OWNV="$(printf '%s\n' "$out" | sed -n 's/^verdict: //p' | head -1)"
  OWNOUT="$out"
}

# The lease locations, mirrored from logs/scripts/work-loop-lease.sh, so an
# assertion can look at the lease a transport really took.
lease_root_for() { # checkout -> lease root
  local c g
  c="$(cd "$1" && pwd -P)"
  g="$(git -C "$c" rev-parse --git-common-dir 2>/dev/null)"
  case "$g" in /*) ;; *) g="$c/$g" ;; esac
  printf '%s/work-loop-dispatch-locks' "$(cd "$g" && pwd -P)"
}
task_lease_for()     { printf '%s/task-%s.lock' "$(lease_root_for "$1")" "$(printf '%s' "$2" | shasum -a 256 | cut -c1-16)"; }
checkout_lease_for() { printf '%s/checkout-%s.lock' "$(lease_root_for "$1")" "$(printf '%s' "$(cd "$1" && pwd -P)" | shasum -a 256 | cut -c1-16)"; }

# Bounded wait for a filesystem condition. Every live scenario below is bounded
# by one of these rather than by a fixed sleep: a fixed sleep either wastes time
# or races, and a race here would show up as a flaky concurrency claim.
wait_for_file() { # path seconds
  local i=0 n=$(( ${2:-20} * 10 ))
  while [ "$i" -lt "$n" ]; do [ -e "$1" ] && return 0; sleep 0.1; i=$((i+1)); done
  return 1
}
wait_for_gone() { # path seconds
  local i=0 n=$(( ${2:-20} * 10 ))
  while [ "$i" -lt "$n" ]; do [ -e "$1" ] || return 0; sleep 0.1; i=$((i+1)); done
  return 1
}
alive() { kill -0 "$1" 2>/dev/null; }

# A sentinel actor binary. It answers --version, records that it launched, holds
# for a bounded window so the other transport can contend against a provably live
# holder, and then performs one scripted action on the state file.
#
# Its marker is what makes `actor_launched=no` falsifiable: the control run below
# launches this same binary successfully and the marker appears, so its absence
# in the refused run is a result, not an untested assumption.
make_sentinel() { # path marker-file action-file state-file
  cat >"$1" <<'SENT'
#!/bin/bash
MARKER="__MARKER__"; ACTION_FILE="__ACTION__"; STATE="__STATE__"
for a in "$@"; do [ "$a" = "--version" ] && { echo "sentinel 0.0.1"; exit 0; }; done
printf 'launched pid=%s\n' "$$" >>"$MARKER"
act="$(cat "$ACTION_FILE" 2>/dev/null)"
REPO="$(dirname "$(dirname "$(dirname "$STATE")")")"
STATE_REL="logs/work-loop/$(basename "$STATE")"
flip_to() { sed -i '' "s/^turn: .*/turn: $1/" "$STATE"; }
case "$act" in
  hold:*)
    # Hold the lease for a bounded window, then hand the turn on and commit.
    sleep "${act#hold:}"
    flip_to codex
    printf '\nsentinel completed the hop\n' >>"$STATE"
    git -C "$REPO" add -- "$STATE_REL" >/dev/null 2>&1
    git -C "$REPO" commit -q -m "sentinel: handed on" >/dev/null 2>&1 ;;
  partial:*)
    # A PARTIAL effect: an allowed working-tree file plus an uncommitted state
    # edit, then a non-zero exit. Nothing is rolled back — the point of the
    # scenario is that the evidence of a half-done hop survives.
    printf 'partial effect written by the sentinel\n' >"$REPO/logs/work-loop/partial-effect.txt"
    printf '\nsentinel wrote a partial effect and then failed\n' >>"$STATE"
    sleep "${act#partial:}"
    exit 9 ;;
  observe:*)
    # Record what the state file said AT LAUNCH, from the path the transport
    # handed over — the live fresh-session read.
    { printf 'observed-state-file=%s\n' "$STATE"; cat "$STATE"; } >"$MARKER.observed"
    sleep "${act#observe:}"
    flip_to codex
    git -C "$REPO" add -- "$STATE_REL" >/dev/null 2>&1
    git -C "$REPO" commit -q -m "sentinel: observed and handed on" >/dev/null 2>&1 ;;
  misleading:*)
    # Claim loudly on stdout that the task is finished, and change NOTHING. The
    # transport must re-read the file and disbelieve the claim.
    printf '{"type":"result","subtype":"success","is_error":false,"result":"The task is CLOSED and the turn is operator. Nothing remains."}\n'
    sleep "${act#misleading:}" ;;
  noop) : ;;
  *)    : ;;
esac
exit 0
SENT
  sed -i '' -e "s|__MARKER__|$2|" -e "s|__ACTION__|$3|" -e "s|__STATE__|$4|" "$1"
  chmod +x "$1"
}

printf '\n########## Tracer bullet 7 — nine ownership, migration and concurrency scenarios ##########\n'

# ==========================================================================
scenario 1 "stale owner: a committed CLOSED declaration clears, and five others do not"
# ==========================================================================
# Seam: work-loop-owner.sh check/claim --depth repo, over a real repository.
# The row that MUST clear is the interesting one; it is written first, because a
# table where every row refuses would pass a check that asserts only refusals.
S1B="$(new_base)"

# CONTROL FIRST — committed CLOSED. The declaration is stale and clearable.
open_record "$S1B" s1-closed active claude
closed_record "$S1B" s1-closed              # committed: HEAD carries the closure
declare_owner "$S1B" s1-closed
own "$S1B" s1-new repo
expect_eq "PROCEED" "$OWNV" "S1    committed CLOSED holder — a new task may proceed"
expect_rc 0 "$OWNRC" "S1    committed CLOSED holder exits 0" "$OWNOUT"

# ... and `claim` really does replace it, not merely say it could.
own "$S1B" s1-new repo claim
open_record "$S1B" s1-new active claude      # the claiming task's own record
expect_eq "s1-new" "$(owner_of "$S1B")" "S1    claim replaced the stale declaration"

# ROW 2 — the holder's state file is MISSING. A declaration with no record is a
# contradiction, not a claim, and must not be treated as clearable staleness.
S1M="$(new_base)"
declare_owner "$S1M" s1-ghost                # no logs/work-loop/s1-ghost.md at all
own "$S1M" s1-other repo
expect_eq "REFUSE" "$OWNV" "S1    missing state file for the holder — refuses"
expect_has "$OWNOUT" "does not exist" "S1    the refusal names the absent record"

# ROW 3 — a MALFORMED declaration (two ids on one line). Nobody is named, so
# nothing may be claimed and nothing may be cleared.
S1X="$(new_base)"
open_record "$S1X" s1-a active claude
printf 's1-a s1-b\n' >"$S1X/logs/work-loop/.owner"
own "$S1X" s1-a repo
expect_eq "AMBIGUOUS" "$OWNV" "S1    malformed declaration — ambiguous"
expect_rc 4 "$OWNRC" "S1    malformed declaration exits 4" "$OWNOUT"
own "$S1X" s1-a repo clear
expect_eq "s1-a s1-b" "$(owner_of "$S1X")" "S1    an ambiguous declaration survives clear"

# ROW 4 — an ACTIVE holder. An open task leases its checkout until closure.
S1A="$(new_base)"
open_record "$S1A" s1-active active claude
declare_owner "$S1A" s1-active
own "$S1A" s1-intruder repo
expect_eq "REFUSE" "$OWNV" "S1    active holder — refuses"

# ROW 5 — a BLOCKED holder. Waiting is not finished; the lease holds.
S1K="$(new_base)"
open_record "$S1K" s1-blocked blocked operator
declare_owner "$S1K" s1-blocked
own "$S1K" s1-intruder repo
expect_eq "REFUSE" "$OWNV" "S1    blocked holder — refuses"
expect_has "$OWNOUT" "BLOCKED_OPERATOR" "S1    the refusal names the blocked classification"

# ROW 6 — COMPLETE BUT UNCOMMITTED closure. The record validates CLOSED, but HEAD
# does not carry it, so the closure has not happened and the lease holds. This is
# the Tracer 6 correction, re-asserted here at repository depth because Tracer 7
# is where the stale-owner row is stated as a table.
S1U="$(new_base)"
open_record "$S1U" s1-uncommitted active claude
closed_record "$S1U" s1-uncommitted nocommit     # reduction written, NOT committed
declare_owner "$S1U" s1-uncommitted
expect_eq "CLOSED" "$(classify "$S1U" s1-uncommitted)" "S1    the uncommitted reduction is valid CLOSED"
own "$S1U" s1-next repo
expect_eq "REFUSE" "$OWNV" "S1    complete but UNCOMMITTED closure — refuses"
expect_has "$OWNOUT" "HEAD does not carry" "S1    the refusal names the missing commit"
expect_eq "s1-uncommitted" "$(owner_of "$S1U")" "S1    the declaration is preserved"
close_scenario

# ==========================================================================
scenario 2 "two concurrent worktrees with different tasks proceed; non-owner replicas refuse"
# ==========================================================================
# Seam: work-loop-owner.sh --depth repo over TWO REAL linked worktrees of ONE
# repository, checked SIMULTANEOUSLY. Sequential checks would prove only that the
# helper is stateless, which is not the claim.
S2B="$(new_base)"
S2W1="$(add_worktree "$S2B" s2one)"
S2W2="$(add_worktree "$S2B" s2two)"
cp "$OWNER_BIN" "$S2W1/logs/scripts/work-loop-owner.sh" 2>/dev/null
cp "$STATE_BIN" "$S2W1/logs/scripts/work-loop-state.sh" 2>/dev/null
open_record "$S2W1" s2-alpha active claude
open_record "$S2W2" s2-beta  active claude
declare_owner "$S2W1" s2-alpha
declare_owner "$S2W2" s2-beta

# Two real processes, rendezvoused on one gate file so their checks overlap in
# time. Each records its verdict and the fact that it was inside the check when
# the other one was too.
S2GATE="$SANDBOX_ROOT/s2.gate"
s2_run() { # worktree task out
  ( while [ ! -e "$S2GATE" ]; do sleep 0.02; done
    printf 'in\n' >"$3.in"
    bash "$1/logs/scripts/work-loop-owner.sh" check --checkout "$1" --task "$2" --depth repo >"$3" 2>&1
    printf '%s\n' "$?" >"$3.rc" ) &
  BG_PIDS="$BG_PIDS $!"
}
s2_run "$S2W1" s2-alpha "$SANDBOX_ROOT/s2.a"
s2_run "$S2W2" s2-beta  "$SANDBOX_ROOT/s2.b"
touch "$S2GATE"
wait_for_file "$SANDBOX_ROOT/s2.a.rc" 30; wait_for_file "$SANDBOX_ROOT/s2.b.rc" 30
S2A="$(sed -n 's/^verdict: //p' "$SANDBOX_ROOT/s2.a" 2>/dev/null | head -1)"
S2Bv="$(sed -n 's/^verdict: //p' "$SANDBOX_ROOT/s2.b" 2>/dev/null | head -1)"
expect_eq "PROCEED" "$S2A"  "S2    worktree one, task alpha — proceeds"
expect_eq "PROCEED" "$S2Bv" "S2    worktree two, task beta — proceeds"
[ -e "$SANDBOX_ROOT/s2.a.in" ] && [ -e "$SANDBOX_ROOT/s2.b.in" ] \
  && ok "S2    both checks entered the same gate — the runs were simultaneous" \
  || bad "S2    both checks entered the same gate"

# The decisive half: a REPLICA. A committed state file replicates across
# worktrees, and its presence is not evidence of ownership.
#
# The replica goes into a THIRD, UNDECLARED worktree on purpose. Worktree two
# would also refuse — but it would refuse for the wrong reason: the checkout half
# runs first, so a checkout already leased by task beta is turned away before the
# task half is ever consulted. That refusal proves checkout occupancy, not task
# binding, and the two must not be conflated. Both are asserted, each against the
# reason that actually produced it.
git -C "$S2W1" add -A >/dev/null 2>&1; git -C "$S2W1" commit -qm "alpha" >/dev/null 2>&1
S2W3="$(add_worktree "$S2B" s2three)"
cp "$S2W1/logs/work-loop/s2-alpha.md" "$S2W3/logs/work-loop/s2-alpha.md"
own "$S2W3" s2-alpha repo
expect_eq "REFUSE" "$OWNV" "S2    a non-owner replica of alpha refuses in an undeclared worktree"
expect_has "$OWNOUT" "$S2W1" "S2    the refusal names the owning checkout"

cp "$S2W1/logs/work-loop/s2-alpha.md" "$S2W2/logs/work-loop/s2-alpha.md"
own "$S2W2" s2-alpha repo
expect_eq "REFUSE" "$OWNV" "S2    a replica in a checkout already leased by beta also refuses"
expect_has "$OWNOUT" "s2-beta" "S2    and that refusal names the checkout's own holder, not alpha's owner"

# CONTROL — the owner itself is still free to proceed on the same task while the
# replica exists. Without this the refusal above could just mean "replicas break
# everything", which is a different and wrong behaviour.
own "$S2W1" s2-alpha repo
expect_eq "PROCEED" "$OWNV" "S2    the declared owner still proceeds on alpha"
close_scenario

# ==========================================================================
scenario 3 "multiple owner claims and multiple unowned open copies both fail closed"
# ==========================================================================
S3B="$(new_base)"
S3W1="$(add_worktree "$S3B" s3one)"
S3W2="$(add_worktree "$S3B" s3two)"
open_record "$S3W1" s3-task active claude nocommit
cp "$S3W1/logs/work-loop/s3-task.md" "$S3W2/logs/work-loop/s3-task.md"

# CONTROL FIRST — exactly one declaration. This must NOT be ambiguous.
declare_owner "$S3W1" s3-task
own "$S3W1" s3-task repo
expect_eq "PROCEED" "$OWNV" "S3    control: one declaration is not ambiguous"
own "$S3W2" s3-task repo
expect_eq "REFUSE" "$OWNV" "S3    control: the other copy refuses, it does not go ambiguous"

# TWO DECLARATIONS of the same task.
declare_owner "$S3W2" s3-task
own "$S3W1" s3-task repo
expect_eq "AMBIGUOUS" "$OWNV" "S3    two claims — ambiguous from checkout one"
expect_rc 4 "$OWNRC" "S3    two claims exit 4" "$OWNOUT"
own "$S3W2" s3-task repo
expect_eq "AMBIGUOUS" "$OWNV" "S3    two claims — ambiguous from checkout two as well"
expect_has "$OWNOUT" "more than one checkout" "S3    the reason names the duplicate claim"

# NO declaration anywhere, two copies. Replicated copies authorise nobody.
rm -f "$S3W1/logs/work-loop/.owner" "$S3W2/logs/work-loop/.owner"
own "$S3W1" s3-task repo
expect_eq "AMBIGUOUS" "$OWNV" "S3    two unowned copies — ambiguous"
expect_has "$OWNOUT" "replicated copies authorise nobody" "S3    the reason names replication"

# And neither side may resolve it by claiming — the operator names the owner.
own "$S3W1" s3-task repo claim
expect_eq "AMBIGUOUS" "$OWNV" "S3    claim refuses to resolve the ambiguity"
expect_eq "(none)" "$(owner_of "$S3W1")" "S3    nothing was written by the refused claim"
close_scenario

# ==========================================================================
scenario 4 "two actors attempt the same task and exactly one task lease succeeds"
# ==========================================================================
# Seam: the SHIPPED shared lease library, sourced unmodified by two REAL
# processes that rendezvous so their acquisitions overlap.
S4B="$(new_base)"
open_record "$S4B" s4-task active claude
S4GATE="$SANDBOX_ROOT/s4.gate"
s4_runner() { # out-file hold-seconds
  cat >"$1.sh" <<EOF
#!/bin/bash
set -uo pipefail
. "$S4B/logs/scripts/work-loop-lease.sh"
wl_lease_init "$S4B" s4-task
while [ ! -e "$S4GATE" ]; do sleep 0.02; done
wl_lease_acquire contender \$\$
rc=\$?
printf 'rc=%s resource=%s\n' "\$rc" "\${WL_LEASE_RESOURCE:-none}" >"$1"
if [ "\$rc" = 0 ]; then
  printf 'held\n' >"$1.held"
  sleep $2
  wl_lease_release
fi
printf 'done\n' >"$1.done"
EOF
  chmod +x "$1.sh"
  bash "$1.sh" & BG_PIDS="$BG_PIDS $!"
}
s4_runner "$SANDBOX_ROOT/s4.a" 4
s4_runner "$SANDBOX_ROOT/s4.b" 4
sleep 0.4          # let both reach the gate before it opens
touch "$S4GATE"
wait_for_file "$SANDBOX_ROOT/s4.a" 30; wait_for_file "$SANDBOX_ROOT/s4.b" 30
S4RA="$(sed -n 's/^rc=\([0-9]*\) .*/\1/p' "$SANDBOX_ROOT/s4.a")"
S4RB="$(sed -n 's/^rc=\([0-9]*\) .*/\1/p' "$SANDBOX_ROOT/s4.b")"
S4WIN=$(( ${S4RA:-9} == 0 ? 1 : 0 )); S4WIN=$(( S4WIN + ( ${S4RB:-9} == 0 ? 1 : 0 ) ))
expect_eq "1" "$S4WIN" "S4    exactly one of the two acquisitions succeeded"
S4LOSE="$S4RA"; [ "${S4RA:-9}" = 0 ] && S4LOSE="$S4RB"
expect_eq "2" "$S4LOSE" "S4    the loser returned 2 (refused), not an error"
# The refusal must be CONTENTION on a real resource, not a generic failure.
grep -h 'resource=' "$SANDBOX_ROOT/s4.a" "$SANDBOX_ROOT/s4.b" | grep -q 'resource=task' \
  && ok "S4    the loser names the TASK lease as the contended resource" \
  || bad "S4    the loser names the TASK lease as the contended resource" \
        "$(cat "$SANDBOX_ROOT/s4.a" "$SANDBOX_ROOT/s4.b")"
# The winner really holds a lease on disk while the loser is being refused.
[ -d "$(task_lease_for "$S4B" s4-task)" ] \
  && ok "S4    the task lease exists on disk while it is held" \
  || bad "S4    the task lease exists on disk while it is held"

# CONTROL — once the winner releases, a third acquisition succeeds. Without this
# the refusal above could mean the lease refuses everybody.
wait_for_file "$SANDBOX_ROOT/s4.a.done" 30; wait_for_file "$SANDBOX_ROOT/s4.b.done" 30
s4_runner "$SANDBOX_ROOT/s4.c" 0
wait_for_file "$SANDBOX_ROOT/s4.c" 30
expect_eq "0" "$(sed -n 's/^rc=\([0-9]*\) .*/\1/p' "$SANDBOX_ROOT/s4.c")" \
  "S4    control: after release a third run acquires the same lease"
close_scenario

# ==========================================================================
scenario 5 "attended/unattended collision contends through the same task and checkout leases"
# ==========================================================================
# Seam: the REAL attended carrier and the REAL unattended dispatcher, launched as
# top-level programs against one task in one checkout. This is the durable-state
# refresh of the accepted Phase 1 live case 23: the lease library is byte-
# unchanged since that closure, but both transports were rewritten onto the
# validator at the Tracer 3 cutover, so the live observation is re-taken here.
S5CO="$(new_base)"
open_record "$S5CO" s5-task active claude
declare_owner "$S5CO" s5-task
S5MARK="$SANDBOX_ROOT/s5.actor"
S5ACT="$SANDBOX_ROOT/s5.action"; printf 'hold:9' >"$S5ACT"
S5BIN="$SANDBOX_ROOT/s5.sentinel"
make_sentinel "$S5BIN" "$S5MARK" "$S5ACT" "$S5CO/logs/work-loop/s5-task.md"
S5LOGD="$SANDBOX_ROOT/s5.runs"

( bash "$CARRY_BIN" --checkout "$S5CO" --task s5-task --claude-bin "$S5BIN" \
    --timeout 60 --log-dir "$S5LOGD" >"$SANDBOX_ROOT/s5.carry.out" 2>&1
  printf '%s\n' "$?" >"$SANDBOX_ROOT/s5.carry.rc" ) &
S5CARRYPID=$!; BG_PIDS="$BG_PIDS $S5CARRYPID"

if wait_for_file "$S5MARK" 45; then
  ok "S5    the attended carrier launched its actor and holds the leases"
  # It is genuinely still running while the dispatcher contends — asserted, not
  # assumed, because a contention against a finished holder proves nothing.
  alive "$S5CARRYPID" && ok "S5    the carrier process is live at the moment of contention" \
                      || bad "S5    the carrier process is live at the moment of contention"
  [ -d "$(task_lease_for "$S5CO" s5-task)" ] && ok "S5    the task lease is held" \
                                             || bad "S5    the task lease is held"
  [ -d "$(checkout_lease_for "$S5CO")" ] && ok "S5    the checkout lease is held" \
                                         || bad "S5    the checkout lease is held"

  S5DMARK="$SANDBOX_ROOT/s5.dispatcher-actor"
  S5DBIN="$SANDBOX_ROOT/s5.dsentinel"
  make_sentinel "$S5DBIN" "$S5DMARK" "$S5ACT" "$S5CO/logs/work-loop/s5-task.md"
  S5BEFORE="$(cd "$S5CO" && git status --porcelain; ls -A "$S5CO")"
  S5DOUT="$(bash "$DISPATCH_BIN" --checkout "$S5CO" --task s5-task \
              --claude-bin "$S5DBIN" --codex-bin "$S5DBIN" \
              --log-dir "$SANDBOX_ROOT/s5.drun" --timeout 20 --max-hops 1 2>&1)"
  S5DRC=$?
  expect_rc 17 "$S5DRC" "S5    the unattended dispatcher is refused at exit 17" "$S5DOUT"
  expect_has "$S5DOUT" "attended" "S5    the refusal names an ATTENDED holder, not a dispatcher"
  [ -e "$S5DMARK" ] && bad "S5    no actor launched on the losing side" "the sentinel marker exists" \
                    || ok "S5    no actor launched on the losing side"
  S5AFTER="$(cd "$S5CO" && git status --porcelain; ls -A "$S5CO")"
  expect_eq "$S5BEFORE" "$S5AFTER" "S5    the losing run created nothing inside the checkout"
  # The durable refusal record, under the shared lease root and outside every
  # working tree.
  S5REF="$(ls -1 "$(lease_root_for "$S5CO")/refusals/"*s5-task* 2>/dev/null | head -1)"
  if [ -n "$S5REF" ]; then
    ok "S5    a durable refusal record was written under the shared lease root"
    expect_has "$(cat "$S5REF")" "actor_launched=no" "S5    the record states no actor launched"
    expect_has "$(cat "$S5REF")" "holder_program=carry" "S5    the record names the attended carrier"
  else
    bad "S5    a durable refusal record was written under the shared lease root"
  fi
else
  bad "S5    the attended carrier launched its actor and holds the leases" "sentinel marker never appeared"
fi

wait "$S5CARRYPID" 2>/dev/null
S5CRC="$(cat "$SANDBOX_ROOT/s5.carry.rc" 2>/dev/null)"
expect_eq "0" "${S5CRC:-none}" "S5    the winning carrier completed its hop undisturbed"
expect_eq "ACTIVE_CODEX" "$(classify "$S5CO" s5-task)" "S5    the carried turn really moved"

# CONTROL — the leases are now free, and the SAME dispatcher invocation against
# the SAME task and checkout no longer exits 17. That is what makes 17 a
# contention result rather than an unconditional refusal, and the control also
# proves the sentinel binary can launch and write its marker.
wait_for_gone "$(task_lease_for "$S5CO" s5-task)" 20
printf 'noop' >"$S5ACT"
S5COUT="$(bash "$DISPATCH_BIN" --checkout "$S5CO" --task s5-task \
            --claude-bin "$S5DBIN" --codex-bin "$S5DBIN" \
            --log-dir "$SANDBOX_ROOT/s5.crun" --timeout 20 --max-hops 1 2>&1)"
S5CRC2=$?
expect_ne "17" "$S5CRC2" "S5    control: with the leases free the dispatcher is not refused at 17"
[ -e "$S5DMARK" ] && ok "S5    control: the sentinel binary CAN launch and write its marker" \
                  || bad "S5    control: the sentinel binary CAN launch and write its marker" \
                         "exit was $S5CRC2 — $(printf '%s' "$S5COUT" | head -c 300)"
close_scenario

# ==========================================================================
scenario 6 "explicit task migration ends with one owner; an interruption leaves visible ambiguity"
# ==========================================================================
# The accepted migration sequence (frozen plan, exceptional-migration procedure):
# commit and validate the source state, validate the target checkout and
# repository-depth ownership, transfer the owner under the ownership mutation
# guard, then verify exactly one bound checkout. An interruption must fail closed.
#
# THE RECORD IS NEVER COPIED, AND IT DOES NOT LIVE IN BOTH PLACES. The plan says
# in one sentence that copying a live state file is not a repair, and the owner
# helper says in another that replicated copies authorise nobody. Together those
# settle what a migration actually is: the DURABLE RECORD MOVES THROUGH GIT —
# committed onto the target's branch and removed from the source's — and the
# declaration follows it through the helper. A migration that leaves the record
# on both branches cannot complete, by design, and the interrupted half below is
# exactly that state.
#
# An earlier draft got this wrong twice over: it wrote the record uncommitted and
# `cp`-ed it into the target, and its "completed migration" then claimed from a
# target that was already declaring the task, so it never exercised a real claim
# at all. Both are fixed here.
S6B="$(new_base)"
S6W1="$(add_worktree "$S6B" s6src)"
S6W2="$(add_worktree "$S6B" s6dst)"
open_record "$S6W1" s6-task active claude          # committed on the SOURCE branch only
S6COMMIT="$(git -C "$S6W1" rev-parse HEAD)"
S6BLOB="$(git -C "$S6W1" rev-parse "HEAD:logs/work-loop/s6-task.md")"
S6_OWNERS() { printf 'src=%s dst=%s' "$(owner_of "$S6W1")" "$(owner_of "$S6W2")"; }

# STEP 1 — COMMIT AND VALIDATE THE SOURCE STATE. Committed is asserted from Git
# rather than assumed: the record must be reachable from the source's own HEAD,
# and its working tree must carry no uncommitted edit to it. A live, half-written
# record is precisely what may not be transferred.
git -C "$S6W1" cat-file -e "HEAD:logs/work-loop/s6-task.md" 2>/dev/null \
  && ok "S6    source: the record is reachable from the source HEAD" \
  || bad "S6    source: the record is reachable from the source HEAD"
expect_eq "" "$(git -C "$S6W1" status --porcelain -- logs/work-loop/s6-task.md)" \
  "S6    source: no uncommitted edit to the record"
expect_eq "ACTIVE_CLAUDE" "$(classify "$S6W1" s6-task)" "S6    source: the state validates"

# STEP 2 — VALIDATE THE TARGET CHECKOUT AND REPOSITORY-DEPTH OWNERSHIP. Before
# the move the target has no record at all — neither in its HEAD nor in its
# working tree — and repository-depth ownership says so in as many words.
git -C "$S6W2" cat-file -e "HEAD:logs/work-loop/s6-task.md" 2>/dev/null \
  && bad "S6    target: the record is NOT in the target before the move" "it is in the target HEAD" \
  || ok "S6    target: the record is NOT in the target before the move"
[ -f "$S6W2/logs/work-loop/s6-task.md" ] \
  && bad "S6    target: no live copy sits in the target working tree" "the file is there" \
  || ok "S6    target: no live copy sits in the target working tree"
declare_owner "$S6W1" s6-task
own "$S6W2" s6-task repo
expect_eq "REFUSE" "$OWNV" "S6    target: repository-depth ownership refuses the target before the move"
expect_has "$OWNOUT" "$S6W1" "S6    target: and the refusal names the source as the owner"

# BEFORE — one owner, the source.
expect_eq "src=s6-task dst=(none)" "$(S6_OWNERS)" "S6    before: exactly one declaration, in the source"

# STEP 3 — TRANSFER, WITH AN INJECTED INTERRUPTION IN THE MIDDLE. The declaration
# is released by the shipped helper (which takes the mutation lock internally),
# then the record is committed onto the target branch by cherry-picking its own
# commit. The interruption is a crash right here: the record is now on BOTH
# branches and nothing declares it.
own "$S6W1" s6-task repo clear
expect_eq "PROCEED" "$OWNV" "S6    transfer: the source declaration is released by the helper"
S6CP="$(git -C "$S6W2" cherry-pick "$S6COMMIT" 2>&1)"
[ -f "$S6W2/logs/work-loop/s6-task.md" ] \
  && ok "S6    transfer: the record's own commit lands on the target branch" \
  || bad "S6    transfer: the record's own commit lands on the target branch" "$S6CP"

# INTERRUPTED — visible, fail-closed ambiguity from both sides. This is the state
# the plan requires to stop rather than resolve itself.
expect_eq "src=(none) dst=(none)" "$(S6_OWNERS)" "S6    interrupted: no checkout declares the task"
own "$S6W1" s6-task repo
expect_eq "AMBIGUOUS" "$OWNV" "S6    interrupted: the source reads AMBIGUOUS"
own "$S6W2" s6-task repo
expect_eq "AMBIGUOUS" "$OWNV" "S6    interrupted: the target reads AMBIGUOUS too"
expect_rc 4 "$OWNRC" "S6    interrupted: exit 4, the operator names the owner" "$OWNOUT"
expect_has "$OWNOUT" "replicated copies authorise nobody" "S6    interrupted: the reason names the two copies"
# And neither side may resolve it by claiming — which is what makes it fail
# closed rather than merely noisy.
own "$S6W2" s6-task repo claim
expect_eq "AMBIGUOUS" "$OWNV" "S6    interrupted: the target may not claim its way out"
expect_eq "(none)" "$(owner_of "$S6W2")" "S6    interrupted: the refused claim wrote nothing"

# COMPLETE THE MOVE — remove the record from the source branch, so exactly one
# checkout stores it. Only now can the transfer finish.
git -C "$S6W1" rm -q "logs/work-loop/s6-task.md" >/dev/null 2>&1
git -C "$S6W1" commit -qm "migrate: the record moves to the target checkout" >/dev/null 2>&1
own "$S6W2" s6-task repo claim
expect_eq "PROCEED" "$OWNV" "S6    transfer: the target takes the declaration through the helper"

# STEP 4 — VERIFY EXACTLY ONE BOUND CHECKOUT.
expect_eq "src=(none) dst=s6-task" "$(S6_OWNERS)" "S6    after: exactly one declaration, in the target"
own "$S6W2" s6-task repo
expect_eq "PROCEED" "$OWNV" "S6    after: the target proceeds"
own "$S6W1" s6-task repo
expect_eq "REFUSE" "$OWNV" "S6    after: the source refuses"
# The durable record moved intact: the target's committed blob is byte-identical
# to the one the source validated in step 1, and the source no longer stores it.
expect_eq "$S6BLOB" "$(git -C "$S6W2" rev-parse "HEAD:logs/work-loop/s6-task.md")" \
  "S6    after: the target carries the identical committed record"
git -C "$S6W1" cat-file -e "HEAD:logs/work-loop/s6-task.md" 2>/dev/null \
  && bad "S6    after: the source no longer stores the record" "it is still in the source HEAD" \
  || ok "S6    after: the source no longer stores the record"
expect_eq "ACTIVE_CLAUDE" "$(classify "$S6W2" s6-task)" "S6    after: the migrated record still validates"

# INTERRUPTION AT THE OTHER CUT POINT — claimed in the target before the source
# was cleared. Two declarations: also fail-closed, and distinguishable by reason.
declare_owner "$S6W1" s6-task
own "$S6W2" s6-task repo
expect_eq "AMBIGUOUS" "$OWNV" "S6    interrupted the other way: two declarations, ambiguous"
expect_has "$OWNOUT" "more than one checkout" "S6    and the reason names the double claim"
rm -f "$S6W1/logs/work-loop/.owner"

# CONTROL — a checkout that declares nothing cannot clear the target's
# declaration from a distance. Without this, "exactly one owner" could just mean
# any caller can delete any declaration.
own "$S6W1" s6-task repo clear
expect_eq "s6-task" "$(owner_of "$S6W2")" "S6    control: the target's declaration survives a foreign clear"
close_scenario

# ==========================================================================
scenario 7 "a bounded fresh-session live recovery reconstructs all five fields"
# ==========================================================================
# Two live readers, neither of which has any conversational state at all:
#   (a) a fresh OS process started with `env -i`, running Reorient's second
#       route — the validated checkout declaration — against the real helpers;
#   (b) the REAL dispatcher, which reconstructs from disk on every hop and hands
#       the state path to its actor. The sentinel records what it was handed.
S7CO="$(new_base)"
open_record "$S7CO" s7-task active claude
declare_owner "$S7CO" s7-task
S7TRUTH="$(five_fields "$S7CO/logs/work-loop/s7-task.md")"

cat >"$SANDBOX_ROOT/s7.route" <<'ROUTE'
#!/bin/bash
# Reorient route 2, executed literally: the declaration, the owner helper, the
# record, the validator, the resumable classification. No scan, no guessing.
set -uo pipefail
co="$1"
[ -f "$co/logs/work-loop/.owner" ] || { echo "STOP:1"; exit 1; }
decl="$(head -1 "$co/logs/work-loop/.owner")"
[ -n "$decl" ] || { echo "STOP:1"; exit 1; }
case "$decl" in *[[:space:]]*) echo "STOP:1"; exit 1 ;; esac
bash "$co/logs/scripts/work-loop-owner.sh" check --depth local --checkout "$co" --task "$decl" >/dev/null 2>&1 \
  || { echo "STOP:2"; exit 1; }
[ -f "$co/logs/work-loop/$decl.md" ] || { echo "STOP:3"; exit 1; }
class="$(bash "$co/logs/scripts/work-loop-state.sh" validate --checkout "$co" --task "$decl" 2>&1)" \
  || { echo "STOP:4"; exit 1; }
case "$class" in ACTIVE_CLAUDE|ACTIVE_CODEX) ;; *) echo "STOP:5 $class"; exit 1 ;; esac
f="$co/logs/work-loop/$decl.md"
printf 'status=%s\nturn=%s\n' "$(sed -n 's/^status: *//p' "$f" | head -1)" "$(sed -n 's/^turn: *//p' "$f" | head -1)"
printf -- '--latest--\n%s\n--blocker--\n%s\n--next--\n%s\n' \
  "$(awk '$0=="## Latest result"{f=1;next} /^## /{f=0} f' "$f" | sed '/^[[:space:]]*$/d')" \
  "$(awk '$0=="## Blocker"{f=1;next} /^## /{f=0} f' "$f" | sed '/^[[:space:]]*$/d')" \
  "$(awk '$0=="## Next action"{f=1;next} /^## /{f=0} f' "$f" | sed '/^[[:space:]]*$/d')"
printf 'classification=%s\ntask=%s\n' "$class" "$decl"
ROUTE
chmod +x "$SANDBOX_ROOT/s7.route"

# `env -i` with a minimal PATH: a genuinely empty environment, so nothing this
# suite knows can leak into the reader.
S7OUT="$(env -i PATH=/usr/bin:/bin:/usr/sbin:/sbin HOME="$SANDBOX_ROOT" \
          /bin/bash "$SANDBOX_ROOT/s7.route" "$S7CO" 2>&1)"; S7RC=$?
expect_rc 0 "$S7RC" "S7    a fresh empty-environment process resolves the task" "$S7OUT"
expect_eq "$S7TRUTH" "$(printf '%s\n' "$S7OUT" | sed '/^classification=/d;/^task=/d')" \
  "S7    all five fields match the committed record"
expect_eq "active" "$(printf '%s\n' "$S7OUT" | sed -n 's/^status=//p')" "S7    status"
expect_eq "claude" "$(printf '%s\n' "$S7OUT" | sed -n 's/^turn=//p')"   "S7    turn"
expect_has "$S7OUT" "LR-s7-task"   "S7    latest result"
expect_has "$S7OUT" "None."        "S7    blocker"
expect_has "$S7OUT" "NA-s7-task"   "S7    next action"
expect_eq "ACTIVE_CLAUDE" "$(printf '%s\n' "$S7OUT" | sed -n 's/^classification=//p')" \
  "S7    classification matches the validator"

# (b) THE LIVE TRANSPORT. A real dispatcher hop, whose sentinel records the state
# file it was handed. What the actor saw must be the committed record.
S7MARK="$SANDBOX_ROOT/s7.actor"
S7ACT="$SANDBOX_ROOT/s7.action"; printf 'observe:0' >"$S7ACT"
S7BIN="$SANDBOX_ROOT/s7.sentinel"
make_sentinel "$S7BIN" "$S7MARK" "$S7ACT" "$S7CO/logs/work-loop/s7-task.md"
bash "$DISPATCH_BIN" --checkout "$S7CO" --task s7-task --claude-bin "$S7BIN" \
  --codex-bin "$S7BIN" --log-dir "$SANDBOX_ROOT/s7.runs" --timeout 30 --max-hops 1 \
  >"$SANDBOX_ROOT/s7.dout" 2>&1
if [ -f "$S7MARK.observed" ]; then
  ok "S7    the live dispatcher handed its actor the real state file"
  expect_has "$(cat "$S7MARK.observed")" "LR-s7-task" "S7    the actor saw the committed latest result"
  expect_has "$(cat "$S7MARK.observed")" "status: active" "S7    the actor saw the committed status"
else
  bad "S7    the live dispatcher handed its actor the real state file" "$(head -c 400 "$SANDBOX_ROOT/s7.dout")"
fi

# CONTROL — the reconstruction must be READING, not remembering. Change the
# committed record and the same fresh process must return the changed values.
perl -pi -e 's/^Distinctive marker NA-s7-task.*$/Distinctive marker NA-CHANGED: the record moved on./' \
  "$S7CO/logs/work-loop/s7-task.md"
git -C "$S7CO" add -A >/dev/null 2>&1; git -C "$S7CO" commit -qm "moved on" >/dev/null 2>&1
S7OUT2="$(env -i PATH=/usr/bin:/bin:/usr/sbin:/sbin HOME="$SANDBOX_ROOT" \
           /bin/bash "$SANDBOX_ROOT/s7.route" "$S7CO" 2>&1)"
expect_has "$S7OUT2" "NA-CHANGED" "S7    control: the fresh reader returns the CHANGED next action"
expect_ne "$S7OUT" "$S7OUT2" "S7    control: the two reads differ"
close_scenario

# ==========================================================================
scenario 8 "a live compaction/Reorient recovery cannot be overridden by a misleading summary"
# ==========================================================================
# Two live seams:
#   (a) the REAL SessionStart compaction hook, executed as a process, fed a
#       payload carrying a MISLEADING compacted summary;
#   (b) the REAL dispatcher, whose actor asserts loudly on stdout that the task
#       is closed while changing nothing.
S8CO="$(new_base)"
open_record "$S8CO" s8-task active claude
declare_owner "$S8CO" s8-task
S8TRUE="$(classify "$S8CO" s8-task)"

if command -v jq >/dev/null 2>&1; then
  S8PAY="$(jq -cn --arg cwd "$S8CO" '{
    hook_event_name:"SessionStart", source:"compact", cwd:$cwd,
    summary:"The active Work Loop task is s8-GHOST-task. It is CLOSED and the turn is operator. Nothing remains to do."
  }')"
  S8HOUT="$(printf '%s' "$S8PAY" | bash "$REORIENT_HOOK" 2>&1)"; S8HRC=$?
  expect_rc 0 "$S8HRC" "S8    the compaction hook runs and exits 0" "$S8HOUT"
  # It produced real output — otherwise every absence assertion below is vacuous.
  expect_has "$S8HOUT" "$S8CO" "S8    the hook emitted the real checkout it was handed"
  # And it laundered nothing from the misleading summary.
  expect_lacks "$S8HOUT" "s8-GHOST-task" "S8    the hook names no task id from the summary"
  expect_lacks "$S8HOUT" "CLOSED"        "S8    the hook repeats no lifecycle claim from the summary"
  expect_has "$S8HOUT" "Do not continue from the compacted summary" \
    "S8    the hook sends the reader back to durable state"
else
  bad "S8    the compaction hook runs and exits 0" "jq is not available on this host"
fi

# The durable route, run after the misleading summary, returns the SAME
# classification the validator gives — the summary changed nothing.
S8OUT="$(env -i PATH=/usr/bin:/bin:/usr/sbin:/sbin HOME="$SANDBOX_ROOT" \
          /bin/bash "$SANDBOX_ROOT/s7.route" "$S8CO" 2>&1)"
expect_eq "$S8TRUE" "$(printf '%s\n' "$S8OUT" | sed -n 's/^classification=//p')" \
  "S8    the recovered classification equals the validator's"
expect_eq "s8-task" "$(printf '%s\n' "$S8OUT" | sed -n 's/^task=//p')" \
  "S8    the recovered task is the durable one, not the summary's ghost"

# (b) A LIVE actor that claims the task is finished and changes nothing.
S8MARK="$SANDBOX_ROOT/s8.actor"
S8ACT="$SANDBOX_ROOT/s8.action"; printf 'misleading:0' >"$S8ACT"
S8BIN="$SANDBOX_ROOT/s8.sentinel"
make_sentinel "$S8BIN" "$S8MARK" "$S8ACT" "$S8CO/logs/work-loop/s8-task.md"
S8DOUT="$(bash "$DISPATCH_BIN" --checkout "$S8CO" --task s8-task --claude-bin "$S8BIN" \
            --codex-bin "$S8BIN" --log-dir "$SANDBOX_ROOT/s8.runs" --timeout 30 --max-hops 2 2>&1)"
[ -e "$S8MARK" ] && ok "S8    the misleading actor really ran" \
                 || bad "S8    the misleading actor really ran" "$(printf '%s' "$S8DOUT" | head -c 300)"
expect_eq "$S8TRUE" "$(classify "$S8CO" s8-task)" \
  "S8    the classification is unchanged by the actor's claim"
expect_eq "active" "$(fm_of "$S8CO/logs/work-loop/s8-task.md" status)" \
  "S8    the durable status is unchanged"

# CONTROL — an actor that actually WRITES the file does change the
# classification. Without this, "unchanged" could just mean nothing can ever
# change it, which would prove the opposite of durability.
printf 'hold:0' >"$S8ACT"
bash "$DISPATCH_BIN" --checkout "$S8CO" --task s8-task --claude-bin "$S8BIN" \
  --codex-bin "$S8BIN" --log-dir "$SANDBOX_ROOT/s8.runs2" --timeout 30 --max-hops 1 \
  >"$SANDBOX_ROOT/s8.dout2" 2>&1
expect_ne "$S8TRUE" "$(classify "$S8CO" s8-task)" \
  "S8    control: an actor that really writes DOES move the classification"

# --------------------------------------------------------------------------
# (c) THE RECOVERY / REALIGNMENT BOUNDARY — the instruction contract.
# Plan §§ 3.2, 3.3 and Unit 2. These read the two skills as artifacts. Phrase
# presence alone would pass on any file that quoted the brief, so each check is
# paired with a fixture the SAME predicate must reject:
#   * the ORDER checks get a wrong-order fixture — the identical file with the
#     two anchor lines exchanged, so both phrases are present and the sequence
#     is wrong. That is the actual defect being repaired, not a proxy for it.
#   * the CLAUSE checks get the pre-edit artifact at HEAD, in which the clause
#     is genuinely absent. A clause green in both states proves nothing.
# --------------------------------------------------------------------------
REALIGN_F="$REPO_ROOT/.agents/skills/realign/SKILL.md"
REORIENT_F="$REPO_ROOT/.agents/skills/reorient/SKILL.md"
S8FIX="$SANDBOX_ROOT/s8.fixtures"; mkdir -p "$S8FIX"
# The pre-edit artifacts, pinned to the commit that PERMANENTLY holds them —
# Unit 0's commit, the last one before this repair. `HEAD` was wrong and would
# have rotted on the very next commit: once Unit 2 lands, HEAD carries the
# repaired skills, every clause reads "present in both", and the control would
# report a false failure. A fixed commit cannot drift.
S8PRE_REF="${WL_UNIT2_PRE_REF:-072438b3}"
git -C "$REPO_ROOT" show "$S8PRE_REF:.agents/skills/realign/SKILL.md"  >"$S8FIX/realign-pre.md"  2>/dev/null
git -C "$REPO_ROOT" show "$S8PRE_REF:.agents/skills/reorient/SKILL.md" >"$S8FIX/reorient-pre.md" 2>/dev/null
[ -s "$S8FIX/realign-pre.md" ] && [ -s "$S8FIX/reorient-pre.md" ] \
  && ok "S8    the pre-edit artifacts are readable at $S8PRE_REF" \
  || bad "S8    the pre-edit artifacts are readable at $S8PRE_REF" \
         "without them every clause control below is vacuous"

line_of() { grep -nF "$2" "$1" 2>/dev/null | head -1 | cut -d: -f1; }
# Both anchors present AND the first strictly earlier. Missing anchor fails too:
# an instruction that never states the branch has not ordered it correctly.
order_ok() { # file early late
  local a b
  a="$(line_of "$1" "$2")"; b="$(line_of "$1" "$3")"
  [ -n "$a" ] && [ -n "$b" ] && [ "$a" -lt "$b" ]
}
# The wrong-order fixture: the same file with those two lines exchanged.
swap_anchors() { # file early late out
  local a b
  a="$(line_of "$1" "$2")"; b="$(line_of "$1" "$3")"
  [ -n "$a" ] && [ -n "$b" ] || return 1
  awk -v a="$a" -v b="$b" '
    NR==FNR { if (FNR==a) la=$0; if (FNR==b) lb=$0; next }
    FNR==a { print lb; next }
    FNR==b { print la; next }
    { print }' "$1" "$1" >"$4"
}
check_order() { # label file early late
  if order_ok "$2" "$3" "$4"; then ok "$1"
  else bad "$1" "early anchor at line [$(line_of "$2" "$3")], late anchor at [$(line_of "$2" "$4")]"; fi
  local wrong="$S8FIX/$(basename "$2").wrong-order"
  if swap_anchors "$2" "$3" "$4" "$wrong"; then
    if order_ok "$wrong" "$3" "$4"; then
      bad "$1 — control: the swapped fixture is rejected" "it passed with the order reversed"
    else ok "$1 — control: the swapped fixture is rejected"; fi
  else
    bad "$1 — control: the swapped fixture is rejected" "fixture unbuildable: an anchor is missing"
  fi
}
# These phrases legitimately wrap across lines in the prose, and a line-based
# grep would force the source to be reflowed to suit the test rather than the
# other way round. Normalize whitespace first, exactly as the Slice 1 suite does.
flat_f() { tr -s '[:space:]' ' ' <"$1"; }
# `--` is load-bearing: several of these patterns begin with "-", which grep
# would otherwise read as an option rather than as text to find.
has_flat() { flat_f "$1" | grep -qF -- "$2"; }
# Present now, absent in the pre-edit artifact. Both halves are load-bearing.
check_clause() { # label file prefile phrase
  local now=absent pre=absent
  has_flat "$2" "$4" && now=present
  # An unreadable pre-edit fixture is a FAILURE, not an absence. Treating it as
  # "absent" would make every control below pass on a checkout that could not
  # produce the comparison at all — the fail-open this pairing exists to close.
  [ -s "$3" ] || { bad "$1" "the pre-edit fixture is missing or empty — the control cannot run"; return; }
  has_flat "$3" "$4" && pre=present
  if [ "$now" = present ] && [ "$pre" = absent ]; then ok "$1"
  else bad "$1" "live=$now pre-edit=$pre — $4"; fi
}
# A preserved property: green before AND after. Stated separately from
# check_clause so the two intents cannot be confused when one goes red.
check_preserved() { # label file phrase
  if has_flat "$2" "$3"; then ok "$1"; else bad "$1" "absent: $3"; fi
}

A_REC='invoke `$reorient` immediately'
A_AUTH='Read the complete `work-loop-v2` skill'
check_order "S8    \$realign delegates recovery BEFORE loading Work Loop authority" \
  "$REALIGN_F" "$A_REC" "$A_AUTH"

check_clause "S8    \$realign's recovery branch emits no realignment verdict" \
  "$REALIGN_F" "$S8FIX/realign-pre.md" 'Emit no `ALIGNED`, `REALIGNED`, `OPERATOR DECISION NEEDED` or `STOPPED`'
check_clause "S8    \$realign's recovery branch edits no task state" \
  "$REALIGN_F" "$S8FIX/realign-pre.md" 'edit no task state and reconstruct no decision at risk'
check_clause "S8    the realignment pass ends when \$reorient reports or fails" \
  "$REALIGN_F" "$S8FIX/realign-pre.md" 'The realignment pass ends when `$reorient` reports or fails'
check_clause "S8    ending the pass does not close the task or force a new thread" \
  "$REALIGN_F" "$S8FIX/realign-pre.md" 'does not close the Work Loop task or force a new thread'
# Preserved, and stated as preserved: healthy context keeps the old behaviour.
check_preserved "S8    \$realign keeps its four-verdict output contract" \
  "$REALIGN_F" 'ALIGNED | REALIGNED | OPERATOR DECISION NEEDED | STOPPED'
check_preserved "S8    \$realign keeps its actor-correct Next: contract" \
  "$REALIGN_F" 'Next: {the actor-correct instruction required by Work Loop v2}'
check_preserved "S8    \$realign still loads Work Loop authority on a healthy pass" \
  "$REALIGN_F" 'It remains authoritative for roles, turns, state shape, correction, and hand-off behavior.'

A_TASK='Resolve the authoritative task without guessing'
check_order "S8    \$reorient resolves the exact task BEFORE loading Work Loop authority" \
  "$REORIENT_F" "$A_TASK" "$A_AUTH"

check_clause "S8    \$reorient names the split-out core resolver reference" \
  "$REORIENT_F" "$S8FIX/reorient-pre.md" 'references/core-resolution.md'
check_clause "S8    \$reorient reads the plan header and only the task-named sections" \
  "$REORIENT_F" "$S8FIX/reorient-pre.md" 'the exact sections that state names'
check_clause "S8    widening inside the plan must be recorded with its reason" \
  "$REORIENT_F" "$S8FIX/reorient-pre.md" 'record why the widening was necessary'
check_clause "S8    the routing index is not read for an established task" \
  "$REORIENT_F" "$S8FIX/reorient-pre.md" 'Do not read the routing index for an already-established task'
check_clause "S8    large files are not batched into one truncatable read" \
  "$REORIENT_F" "$S8FIX/reorient-pre.md" 'Do not batch several large files into one read'
check_clause "S8    a full plan read stays allowed when genuinely necessary" \
  "$REORIENT_F" "$S8FIX/reorient-pre.md" 'never forbidden by an arbitrary byte limit'
# Preserved: the seven-field block and the seam rule survive the rewrite.
for f in '- Objective:' '- Current task:' '- Verified state:' '- Next action:' \
         '- Key constraints:' '- Drift detected:' '- Evidence consulted:'; do
  check_preserved "S8    \$reorient keeps REORIENTED field \"$f\"" "$REORIENT_F" "$f"
done
check_preserved "S8    \$reorient keeps its actor-correct Next: contract" \
  "$REORIENT_F" 'end with the explicit `Next:` instruction for the actor whose turn it actually is'
check_preserved "S8    \$reorient stays read-only" \
  "$REORIENT_F" 'Keep this skill instruction-only and read-only.'

# --------------------------------------------------------------------------
# THE MANDATORY RECOVERY READS ARE UNCONDITIONAL — and phrase presence cannot
# see that. Every check_clause above stayed green against disposable commit
# a0f4f6ec, which reversed the approved contract while keeping the words: it
# demoted the complete Work Loop skill read and the core read below a trigger
# ("read anything below only when this pass goes on to a Work-Loop-owned
# action") and dropped the requirement to read the resolved core at all. A guard
# that only asks whether a sentence is somewhere in the file passes a file that
# says the opposite of what it used to.
#
# Two properties separate the approved contract from that reversal, and each is
# paired with a wrong fixture built from the LIVE file. Building the fixture
# rather than checking out a0f4f6ec is deliberate: that commit lives on a
# disposable branch scheduled for removal, and a control that disappears with it
# is a control that silently stops running.
#
# NEITHER CHECK EDITS THE CONTRACT. Both read wording that is already there.
# --------------------------------------------------------------------------

# (i) No conditional gate stands between Step 3's heading and the first
# mandatory read. That span is the reversal's entire mechanism. It stops AT the
# skill read on purpose: "you read a reference only when its stated condition is
# met" sits immediately below and is a legitimate conditional about references,
# so a whole-step scan would flag the approved file.
recovery_gate() { # file; prints each trigger word gating the first mandatory read
  command sed -n '/^### 3\. Read the minimum authoritative context$/,/Read the complete `work-loop-v2` skill/p' \
    "$1" 2>/dev/null \
    | command grep -oiE 'mandatory set|conditional|only when|read anything below'
}
if [ -z "$(recovery_gate "$REORIENT_F")" ]; then
  ok "S8    \$reorient's mandatory recovery reads carry no conditional gate"
else
  bad "S8    \$reorient's mandatory recovery reads carry no conditional gate" \
      "gated by: $(recovery_gate "$REORIENT_F" | tr '\n' ' ')"
fi
S8GATED="$S8FIX/reorient-gated.md"
awk -v skill='Read the complete `work-loop-v2` skill' '
  index($0, skill) && !done {
    print "**Read anything below only when this pass goes on to a Work-Loop-owned action.**"
    print ""
    done = 1
  }
  { print }' "$REORIENT_F" >"$S8GATED" 2>/dev/null
if [ -s "$S8GATED" ] && [ -n "$(recovery_gate "$S8GATED")" ]; then
  ok "S8    control: a conditional gate on the mandatory reads is rejected"
else
  bad "S8    control: a conditional gate on the mandatory reads is rejected" \
      "the gated fixture passed — every phrase check above passes it too"
fi

# (ii) The resolved core is READ COMPLETE, not merely resolved. a0f4f6ec kept
# `references/core-resolution.md` and the resolver, and replaced the read of what
# it prints with "do with what it prints exactly what that reference directs" —
# which the clause check above cannot distinguish from the approved wording.
S8CORE_READ='read the complete core file that resolver prints'
check_preserved "S8    \$reorient reads the COMPLETE core the resolver prints" \
  "$REORIENT_F" "$S8CORE_READ"
S8NOCORE="$S8FIX/reorient-core-not-read.md"
command grep -vF 'the complete core file that resolver prints' "$REORIENT_F" >"$S8NOCORE" 2>/dev/null
if [ -s "$S8NOCORE" ] && ! has_flat "$S8NOCORE" "$S8CORE_READ"; then
  ok "S8    control: dropping the complete-core read is rejected"
else
  bad "S8    control: dropping the complete-core read is rejected" \
      "the fixture without that requirement still read as present"
fi

# --------------------------------------------------------------------------
# (d) THE RECOVERY ROUTE under Unit 2's five named controls, executed.
# One checkout, THREE open task files, exactly one declared. No hook runs here
# at all — that is the "explicit $reorient still works" control, and it is a
# real one because the checkout carries no hook to fire.
# --------------------------------------------------------------------------
S8MC="$(new_base)"
open_record "$S8MC" s8-decoy-a active claude
open_record "$S8MC" s8-decoy-b active codex
cat >"$S8MC/logs/work-loop/s8-real-task.md" <<'EOF'
---
task: s8-real-task
status: active
turn: claude
---

## Objective and scope
Tracer 7 fixture for s8-real-task. Nothing real depends on this file.

## Lane and unit
Standard. Implementation mode. Unit 1 — the fixture unit.

## Latest result
Distinctive marker LR-s8-real-task: the twenty-third check returned exit 17.

## Blocker
None.

## Next action
Distinctive marker NA-s8-real-task: continue under `plans/s8-fixture-plan.md` section "Unit 1 constraints".
EOF
mkdir -p "$S8MC/plans"
cat >"$S8MC/plans/s8-fixture-plan.md" <<'EOF'
# S8 fixture plan

**Authority.** Operator-approved on 2026-08-17.

## Unit 1 constraints
DURABLE-FACT-S8: the fixture unit may not exceed two files.

## Unit 9 constraints
DECOY-FACT-S8: this section is not the one the task names.
EOF
declare_owner "$S8MC" s8-real-task
git -C "$S8MC" add -A >/dev/null 2>&1
git -C "$S8MC" commit -qm "s8 multi-task fixture" >/dev/null 2>&1

# The cascade, executed literally for the steps Unit 2 fixes: declaration, then
# the exact task, then the task state, then ONLY the plan section the task names.
cat >"$SANDBOX_ROOT/s8.route" <<'ROUTE'
#!/bin/bash
set -uo pipefail
co="$1"
[ -f "$co/logs/work-loop/.owner" ] || { echo "STOP:1"; exit 1; }
decl="$(head -1 "$co/logs/work-loop/.owner")"
[ -n "$decl" ] || { echo "STOP:1"; exit 1; }
case "$decl" in *[[:space:]]*) echo "STOP:1"; exit 1 ;; esac
bash "$co/logs/scripts/work-loop-owner.sh" check --depth local --checkout "$co" --task "$decl" >/dev/null 2>&1 \
  || { echo "STOP:2"; exit 1; }
f="$co/logs/work-loop/$decl.md"
[ -f "$f" ] || { echo "STOP:3"; exit 1; }
class="$(bash "$co/logs/scripts/work-loop-state.sh" validate --checkout "$co" --task "$decl" 2>&1)" \
  || { echo "STOP:4"; exit 1; }
case "$class" in ACTIVE_CLAUDE|ACTIVE_CODEX) ;; *) echo "STOP:5 $class"; exit 1 ;; esac
printf 'task=%s\nclassification=%s\n' "$decl" "$class"
next="$(awk '$0=="## Next action"{f=1;next} /^## /{f=0} f' "$f")"
printf 'next=%s\n' "$(printf '%s' "$next" | tr -d '\n')"
plan="$(printf '%s' "$next" | sed -n 's/.*`\([^`]*\.md\)`.*/\1/p')"
sect="$(printf '%s' "$next" | sed -n 's/.*section "\([^"]*\)".*/\1/p')"
[ -n "$plan" ] && [ -n "$sect" ] || { echo "STOP:6"; exit 1; }
printf 'plan=%s\nsection=%s\n' "$plan" "$sect"
printf 'authority=%s\n' "$(sed -n '1,/^## /p' "$co/$plan" | grep -c '\*\*Authority\.\*\*')"
printf 'sectbody=%s\n' "$(awk -v h="## $sect" '$0==h{f=1;next} /^## /{f=0} f' "$co/$plan" | tr -d '\n')"
ROUTE
chmod +x "$SANDBOX_ROOT/s8.route"

S8SUM_BEFORE="$(shasum -a 256 "$S8MC/logs/work-loop/s8-real-task.md" | cut -d' ' -f1)"
S8MOUT="$(env -i PATH=/usr/bin:/bin:/usr/sbin:/sbin HOME="$SANDBOX_ROOT" \
           /bin/bash "$SANDBOX_ROOT/s8.route" "$S8MC" 2>&1)"; S8MRC=$?
expect_rc 0 "$S8MRC" "S8    the recovery route resolves among three open task files" "$S8MOUT"
expect_eq "s8-real-task" "$(printf '%s\n' "$S8MOUT" | sed -n 's/^task=//p')" \
  "S8    it returns the declared task, not a scan result"
expect_lacks "$S8MOUT" "s8-decoy-a" "S8    it never names the first undeclared open task"
expect_lacks "$S8MOUT" "s8-decoy-b" "S8    it never names the second undeclared open task"
# The hidden durable facts: one in the task, one in the plan section the task names.
expect_has "$S8MOUT" "NA-s8-real-task"  "S8    the durable fact hidden in the task is recovered"
expect_has "$S8MOUT" "DURABLE-FACT-S8"  "S8    the durable fact in the task-named plan section is recovered"
expect_has "$S8MOUT" "authority=1"      "S8    the plan's authority header is read"
# Targeted, not a whole-plan slurp — the decoy section must NOT come back.
expect_lacks "$S8MOUT" "DECOY-FACT-S8"  "S8    the plan section NOT named by the task is not read"
# Explicit recovery with no hook anywhere: the control for "the hook is absent".
[ ! -e "$S8MC/.codex/hooks/work-loop-reorient.sh" ] \
  && ok "S8    this checkout carries no compaction hook, so recovery was explicit" \
  || bad "S8    this checkout carries no compaction hook, so recovery was explicit" "a hook exists"
# Read-only: the state file is byte-identical across the recovery pass.
S8SUM_AFTER="$(shasum -a 256 "$S8MC/logs/work-loop/s8-real-task.md" | cut -d' ' -f1)"
expect_eq "$S8SUM_BEFORE" "$S8SUM_AFTER" "S8    recovery leaves the task state byte-identical"
# CONTROL — the checksum must be capable of noticing. Without this, "identical"
# could mean the comparison can never differ.
printf '\nMutation.\n' >>"$S8MC/logs/work-loop/s8-real-task.md"
expect_ne "$S8SUM_BEFORE" "$(shasum -a 256 "$S8MC/logs/work-loop/s8-real-task.md" | cut -d' ' -f1)" \
  "S8    control: the byte comparison DOES notice a real write"

# A blocked task must stop the recovery, not be resumed from.
S8BK="$(new_base)"
open_record "$S8BK" s8-blocked-task blocked operator
declare_owner "$S8BK" s8-blocked-task
S8BOUT="$(env -i PATH=/usr/bin:/bin:/usr/sbin:/sbin HOME="$SANDBOX_ROOT" \
           /bin/bash "$SANDBOX_ROOT/s8.route" "$S8BK" 2>&1)"; S8BRC=$?
expect_rc 1 "$S8BRC" "S8    a BLOCKED_OPERATOR task stops recovery instead of resuming" "$S8BOUT"
expect_has "$S8BOUT" "STOP:5" "S8    it stops at the resumable-classification check"
expect_has "$S8BOUT" "BLOCKED_OPERATOR" "S8    it names the classification that stopped it"

# A record the validator refuses must stop at the validator, not one check later.
S8RF="$(new_base)"
open_record "$S8RF" s8-refused-task active operator   # illegal pair: active/operator
declare_owner "$S8RF" s8-refused-task
git -C "$S8RF" add -A >/dev/null 2>&1; git -C "$S8RF" commit -qm "refused fixture" >/dev/null 2>&1
S8ROUT="$(env -i PATH=/usr/bin:/bin:/usr/sbin:/sbin HOME="$SANDBOX_ROOT" \
           /bin/bash "$SANDBOX_ROOT/s8.route" "$S8RF" 2>&1)"; S8RRC=$?
expect_rc 1 "$S8RRC" "S8    a validator refusal stops recovery" "$S8ROUT"
expect_has "$S8ROUT" "STOP:4" "S8    it stops at the validator, not at a later check"
close_scenario

# ==========================================================================
scenario 9 "a bounded cross-courier live proof preserves state and partial-effect evidence"
# ==========================================================================
# The attended carrier's actor writes a partial effect and then fails, while the
# unattended dispatcher contends for the same task. What must survive: the
# partial evidence on disk, the state record itself, and a losing run that wrote
# nothing into the checkout.
S9CO="$(new_base)"
open_record "$S9CO" s9-task active claude
declare_owner "$S9CO" s9-task
S9STATE="$S9CO/logs/work-loop/s9-task.md"
S9BEFORE="$(five_fields "$S9STATE")"
S9MARK="$SANDBOX_ROOT/s9.actor"
S9ACT="$SANDBOX_ROOT/s9.action"; printf 'partial:9' >"$S9ACT"
S9BIN="$SANDBOX_ROOT/s9.sentinel"
make_sentinel "$S9BIN" "$S9MARK" "$S9ACT" "$S9STATE"

( bash "$CARRY_BIN" --checkout "$S9CO" --task s9-task --claude-bin "$S9BIN" \
    --timeout 60 --log-dir "$SANDBOX_ROOT/s9.runs" >"$SANDBOX_ROOT/s9.carry.out" 2>&1
  printf '%s\n' "$?" >"$SANDBOX_ROOT/s9.carry.rc" ) &
S9PID=$!; BG_PIDS="$BG_PIDS $S9PID"

if wait_for_file "$S9MARK" 45; then
  ok "S9    the attended carrier's actor launched"
  # The marker proves the actor launched and NOTHING MORE. The sentinel appends it
  # before it reads its action file and dispatches into the partial branch, so
  # releasing on the marker alone lands here with the partial effect not yet
  # written — intermittently, whenever those few command substitutions lose the
  # race. Wait for the evidence the assertion below actually reads.
  #
  # This is a synchronization gate, NOT the assertion. An effect that never
  # arrives still fails at the `[ -f ]` below, so the check stays falsifiable; the
  # bound is 8s, well inside the actor's 9s post-write hold, so the carrier is
  # still provably live when the assertion runs and "during the hop" remains what
  # is being asserted rather than "eventually".
  S9PARTIAL="$S9CO/logs/work-loop/partial-effect.txt"
  wait_for_file "$S9PARTIAL" 8 >/dev/null
  alive "$S9PID" && ok "S9    the carrier is live while the dispatcher contends" \
                 || bad "S9    the carrier is live while the dispatcher contends"
  [ -f "$S9PARTIAL" ] \
    && ok "S9    the partial effect is visible on disk during the hop" \
    || bad "S9    the partial effect is visible on disk during the hop"

  S9DMARK="$SANDBOX_ROOT/s9.dactor"
  S9DBIN="$SANDBOX_ROOT/s9.dsentinel"
  make_sentinel "$S9DBIN" "$S9DMARK" "$S9ACT" "$S9STATE"
  S9LSBEFORE="$(cd "$S9CO" && git status --porcelain)"
  S9DOUT="$(bash "$DISPATCH_BIN" --checkout "$S9CO" --task s9-task \
              --claude-bin "$S9DBIN" --codex-bin "$S9DBIN" \
              --log-dir "$SANDBOX_ROOT/s9.drun" --timeout 20 --max-hops 1 2>&1)"
  S9DRC=$?
  expect_rc 17 "$S9DRC" "S9    the second courier is refused at 17 mid-hop" "$S9DOUT"
  [ -e "$S9DMARK" ] && bad "S9    the losing courier launched no actor" "marker exists" \
                    || ok "S9    the losing courier launched no actor"
  expect_eq "$S9LSBEFORE" "$(cd "$S9CO" && git status --porcelain)" \
    "S9    the losing courier changed nothing in the working tree"
else
  bad "S9    the attended carrier's actor launched" "sentinel marker never appeared"
fi

wait "$S9PID" 2>/dev/null
S9CRC="$(cat "$SANDBOX_ROOT/s9.carry.rc" 2>/dev/null)"
expect_ne "0" "${S9CRC:-none}" "S9    the carrier reports the failed hop rather than success"
# What survives the failure — the point of the scenario.
[ -f "$S9CO/logs/work-loop/partial-effect.txt" ] \
  && ok "S9    the partial effect SURVIVES the failed hop" \
  || bad "S9    the partial effect SURVIVES the failed hop"
grep -q 'partial effect' "$S9STATE" \
  && ok "S9    the actor's uncommitted state edit survives" \
  || bad "S9    the actor's uncommitted state edit survives"
expect_eq "ACTIVE_CLAUDE" "$(classify "$S9CO" s9-task)" \
  "S9    the record is still valid and still owes the same actor"
git -C "$S9CO" diff --quiet -- logs/work-loop/s9-task.md \
  && bad "S9    the last committed state plus the working diff shows the repair" "no diff" \
  || ok "S9    the last committed state plus the working diff shows the repair"
# The leases were released even though the hop failed.
wait_for_gone "$(task_lease_for "$S9CO" s9-task)" 20 \
  && ok "S9    the failed hop released its task lease" \
  || bad "S9    the failed hop released its task lease"

# CONTROL — with the leases free, the same dispatcher invocation is no longer
# refused at 17, so the refusal above was contention and not the failed hop.
printf 'noop' >"$S9ACT"
bash "$DISPATCH_BIN" --checkout "$S9CO" --task s9-task \
  --claude-bin "$S9DBIN" --codex-bin "$S9DBIN" \
  --log-dir "$SANDBOX_ROOT/s9.crun" --timeout 20 --max-hops 1 >"$SANDBOX_ROOT/s9.cout" 2>&1
S9CTL=$?
expect_ne "17" "$S9CTL" "S9    control: with the leases free the dispatcher is not refused at 17"
close_scenario

# ==========================================================================
# Case 0 — suite-level falsifiability. Substitute a rubber-stamp owner helper
# that returns PROCEED for everything, and assert the verdict-bearing scenarios
# would go red against it. A proof that cannot be made to fail is not a proof.
# ==========================================================================
printf '\n=== C0 — falsifiability: a rubber-stamp owner helper must break the suite\n'
C0="$(new_base)"
cat >"$C0/logs/scripts/work-loop-owner.sh" <<'STAMP'
#!/bin/bash
echo "verdict: PROCEED"
echo "reason: rubber stamp"
exit 0
STAMP
open_record "$C0" c0-task active claude
declare_owner "$C0" c0-holder            # a declaration with NO state file: S1 row 2
own "$C0" c0-task repo
expect_eq "PROCEED" "$OWNV" "C0    the rubber stamp really does approve everything"
expect_ne "REFUSE" "$OWNV" "C0    which is the OPPOSITE of S1's missing-record row"
# And the real helper, on the identical fixture, refuses — so the S1 assertion
# discriminates between the two helpers rather than passing against both.
cp "$OWNER_BIN" "$C0/logs/scripts/work-loop-owner.sh"
own "$C0" c0-task repo
expect_eq "REFUSE" "$OWNV" "C0    the shipped helper refuses the same fixture"

# ==========================================================================
printf '\n########## scenario verdicts ##########\n'
printf '%s' "$VERDICTS" | while IFS='|' read -r n t v; do
  [ -n "$n" ] && printf '  %-4s %-6s %s\n' "$n" "$v" "$t"
done
printf '\n########## Tracer bullet 7: %s passed, %s failed ##########\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] || exit 1
exit 0
