#!/bin/bash
# Acceptance harness for the shared Work Loop v2 live lease.
#
# Every case here drives the library through REAL processes that source it and
# take real leases. Nothing greps the library's text: a case that asserted the
# source contains the word "rollback" would stay green against a rollback that
# removed the wrong directory.
#
# Cases 0 and 0b are the harness's own falsifiability proof, and they are two
# different proofs:
#
#   0   points a contender at an ABSENT library and asserts it cannot proceed.
#       A harness that stays green with the thing under test removed is not
#       evidence.
#   0b  points the SAME two-contender scenario at a NAIVE lease — one composite
#       checkout|task key, no second resource, no rollback — and asserts that it
#       admits BOTH contenders. This is the stronger of the two: it shows the
#       scenario discriminates between a correct lease and a plausible wrong
#       one, rather than merely between a library and no library.
#
# Usage:  bash work-loop-lease.test.sh
#         WL_LEASE_LIB=/path/to/other.sh bash work-loop-lease.test.sh

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LEASE_LIB="${WL_LEASE_LIB:-$HERE/work-loop-lease.sh}"

PASS=0; FAIL=0
SANDBOX_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/wl2-lease-test.XXXXXX")"
trap 'rm -rf "$SANDBOX_ROOT"' EXIT

ok()  { PASS=$((PASS+1)); printf '  PASS  %s\n' "$1"; }
bad() { FAIL=$((FAIL+1)); printf '  FAIL  %s\n' "$1"; [ -n "${2:-}" ] && printf '        %s\n' "$2"; }

# ---------------------------------------------------------------- fixtures

new_checkout() { # -> path on stdout
  local d; d="$(mktemp -d "$SANDBOX_ROOT/co.XXXXXX")"
  git -C "$d" init -q
  git -C "$d" config user.email lease-harness@example.invalid
  git -C "$d" config user.name  lease-harness
  printf 'sandbox\n' >"$d/README.md"
  git -C "$d" add README.md >/dev/null 2>&1
  git -C "$d" commit -qm "sandbox base" >/dev/null 2>&1
  printf '%s' "$d"
}

# The contender. A separate process, because a lease is held by a PROCESS and
# two contenders that were the same process would never contend.
#
# argv: lib checkout task program hold-secs outfile [mode] [barrier]
DRIVER="$SANDBOX_ROOT/contend.sh"
cat >"$DRIVER" <<'DRV'
#!/bin/bash
set -uo pipefail
LIB="$1"; CO="$2"; TK="$3"; PROG="$4"; HOLD="$5"; OUT="$6"; MODE="${7:-run}"; BARRIER="${8:-}"
[ -r "$LIB" ] || { printf 'LIB-UNREADABLE %s\n' "$LIB" >"$OUT"; exit 70; }
# shellcheck disable=SC1090
. "$LIB" || { printf 'LIB-SOURCE-FAILED\n' >"$OUT"; exit 70; }
wl_lease_init "$CO" "$TK"; irc=$?
[ "$irc" -eq 0 ] || { printf 'INIT-FAIL rc=%s\n' "$irc" >"$OUT"; exit 71; }

present() { [ -d "$1" ] && printf 'present' || printf 'absent'; }

if [ "$MODE" = "status" ]; then
  { printf 'STATUS\n'; wl_lease_status; } >"$OUT"
  exit 0
fi

# All contenders in a race spin here until the barrier file appears, so they
# reach mkdir(2) as close together as this harness can arrange.
if [ -n "$BARRIER" ]; then
  while [ ! -f "$BARRIER" ]; do :; done
fi

wl_lease_acquire "$PROG" "$$"; arc=$?
if [ "$arc" -ne 0 ]; then
  printf 'REFUSED rc=%s resource=%s refusal=%s holder_pid=%s holder_program=%s holder_task=%s holder_checkout=%s survivors=%s\n' \
    "$arc" "$WL_LEASE_RESOURCE" "$WL_LEASE_REFUSAL" "$WL_LEASE_HOLDER_PID" \
    "$WL_LEASE_HOLDER_PROGRAM" "$WL_LEASE_HOLDER_TASK" "$WL_LEASE_HOLDER_CHECKOUT" \
    "$WL_LEASE_SURVIVORS" >"$OUT"
  # The liveness verdict, on its OWN line. Appending rather than widening the
  # line above keeps every existing case's grep intact. `${...-}` and not
  # `${...}`: under a helper that has no three-state probe these variables do
  # not exist, and `set -u` would kill the driver before it could report the
  # missing verdict the new cases exist to show.
  printf 'REFUSED-STATE state=%s reason=%s\n' \
    "${WL_LEASE_HOLDER_STATE-<unset>}" "${WL_LEASE_HOLDER_REASON-<unset>}" >>"$OUT"
  # A refused run owns nothing, so its teardown pin must claim nothing. This is
  # the reachable half of the partial-acquisition guard.
  if [ "$MODE" = "pin-after-refusal" ]; then
    wl_lease_pin "9991" "" "$TK"; prc=$?
    printf 'PIN-AFTER-REFUSAL rc=%s pinned=%s task=%s checkout=%s\n' \
      "$prc" "$WL_LEASE_PINNED" \
      "$(present "$WL_LEASE_TASK_DIR")" "$(present "$WL_LEASE_CHECKOUT_DIR")" >>"$OUT"
  fi
  exit 17
fi

printf 'ACQUIRED task_owned=%s checkout_owned=%s task_dir=%s checkout_dir=%s\n' \
  "$WL_LEASE_TASK_OWNED" "$WL_LEASE_CHECKOUT_OWNED" \
  "$WL_LEASE_TASK_DIR" "$WL_LEASE_CHECKOUT_DIR" >"$OUT"

case "$MODE" in
  pin)
    wl_lease_pin "4242" "" "$TK"; prc=$?
    printf 'PIN rc=%s pinned=%s\n' "$prc" "$WL_LEASE_PINNED" >>"$OUT"
    wl_lease_release
    printf 'AFTER-RELEASE task=%s checkout=%s\n' \
      "$(present "$WL_LEASE_TASK_DIR")" "$(present "$WL_LEASE_CHECKOUT_DIR")" >>"$OUT"
    exit 0 ;;
  pin-task-only)
    # Acquire's rollback makes "owns the task lease but not the checkout lease"
    # unreachable through acquire alone, so the library is driven into that
    # state directly. What is under test is the GUARD — that pin writes into a
    # resource only when this run owns it — not the route into the state.
    WL_LEASE_CHECKOUT_OWNED=0
    wl_lease_pin "5353" "" "$TK"; prc=$?
    printf 'PIN rc=%s pinned=%s task_survivors=%s checkout_survivors=%s\n' \
      "$prc" "$WL_LEASE_PINNED" \
      "$([ -f "$WL_LEASE_TASK_DIR/survivors" ] && printf yes || printf no)" \
      "$([ -f "$WL_LEASE_CHECKOUT_DIR/survivors" ] && printf yes || printf no)" >>"$OUT"
    exit 0 ;;
  pin-block-task|pin-block-checkout)
    # FORCE the durable pin evidence to be unpersistable, deterministically.
    #
    # A DIRECTORY is put where the `survivors` FILE has to go. `>` then cannot
    # create the file for ANY user, root included, so the forcing does not
    # depend on privilege and needs nothing destructive. And `[ -f .../survivors ]`
    # — the exact test wl_lease_acquire and wl_lease_status use to recognise a
    # pin — is false afterwards, so what a later process sees is precisely the
    # state a lost write leaves behind. Blocking one resource at a time is what
    # separates a task-evidence failure from a checkout-replication failure.
    if [ "$MODE" = "pin-block-task" ]; then BLOCKED="$WL_LEASE_TASK_DIR"
    else BLOCKED="$WL_LEASE_CHECKOUT_DIR"; fi
    mkdir "$BLOCKED/survivors" 2>/dev/null \
      || { printf 'BLOCK-SETUP-FAILED %s\n' "$BLOCKED" >>"$OUT"; exit 72; }
    wl_lease_pin "7777" "" "$TK"; prc=$?
    # `${...-}` and not `${...}`: under the PRE-FIX library the variable does not
    # exist, and `set -u` would kill the driver before it could report the false
    # success this case exists to show.
    printf 'PIN rc=%s pinned=%s failed=[%s] task_evidence=%s checkout_evidence=%s\n' \
      "$prc" "$WL_LEASE_PINNED" "${WL_LEASE_PIN_FAILED-<unset>}" \
      "$([ -f "$WL_LEASE_TASK_DIR/survivors" ] && printf yes || printf no)" \
      "$([ -f "$WL_LEASE_CHECKOUT_DIR/survivors" ] && printf yes || printf no)" >>"$OUT"
    wl_lease_release
    printf 'AFTER-RELEASE task=%s checkout=%s\n' \
      "$(present "$WL_LEASE_TASK_DIR")" "$(present "$WL_LEASE_CHECKOUT_DIR")" >>"$OUT"
    exit 0 ;;
  abandon)
    # Leave the lease behind on purpose: no release. Models a run still holding.
    [ "$HOLD" -gt 0 ] && sleep "$HOLD"
    exit 0 ;;
esac

[ "$HOLD" -gt 0 ] && sleep "$HOLD"
wl_lease_release
printf 'RELEASED task=%s checkout=%s\n' \
  "$(present "$WL_LEASE_TASK_DIR")" "$(present "$WL_LEASE_CHECKOUT_DIR")" >>"$OUT"
exit 0
DRV
chmod +x "$DRIVER"

contend() { # lib checkout task program hold outfile [mode] [barrier] -> rc
  bash "$DRIVER" "$@"
}

lease_dirs() { # checkout task -> "taskdir|checkoutdir"
  local c g
  c="$(cd "$1" && pwd -P)"
  g="$(git -C "$c" rev-parse --git-common-dir 2>/dev/null)"
  case "$g" in /*) ;; *) g="$c/$g" ;; esac
  g="$(cd "$g" && pwd -P)/work-loop-dispatch-locks"
  printf '%s/task-%s.lock|%s/checkout-%s.lock' \
    "$g" "$(printf '%s' "$2" | shasum -a 256 | cut -c1-16)" \
    "$g" "$(printf '%s' "$c" | shasum -a 256 | cut -c1-16)"
}
task_dir()     { local p; p="$(lease_dirs "$1" "$2")"; printf '%s' "${p%%|*}"; }
checkout_dir() { local p; p="$(lease_dirs "$1" "$2")"; printf '%s' "${p##*|}"; }

# ------------------------------------------------- liveness fixtures (13–18)
#
# A stale lease is not something a contender can be asked to produce, because a
# contender that could still write its own lease is by definition not dead. So
# the lease directory is FABRICATED here, with a pid whose state this harness
# has established independently, and the library is then asked what it makes of
# it. That is the only way to hold the pid's state fixed while the verdict
# varies.
fabricate_lease() { # dir pid|__none__ [program] [task] [checkout]
  mkdir -p "$1" || return 1
  [ "$2" = "__none__" ] || printf '%s\n' "$2" >"$1/pid"
  printf '%s\n' "${4:-fabricated-task}"  >"$1/task"
  printf '%s\n' "${5:-/nowhere}"         >"$1/checkout"
  printf '%s\n' "${3:-fabricated}"       >"$1/program"
  return 0
}

# A pid that is POSITIVELY gone: started, reaped, and then confirmed by the same
# `kill -0` wording the library has to rely on. Confirming it here is what stops
# a green case 16 from resting on the harness's assumption rather than on fact.
#
# The message is CAPTURED and then matched, never piped straight out of `kill`.
# This harness runs under `pipefail`, and in `kill -0 $p 2>&1 | grep -q ...` the
# failing `kill` — which is the very outcome being looked for — sets the whole
# pipeline's status, so the match reads as a failure.
absent_pid() { # -> pid on stdout, or empty if absence could not be established
  local p err
  bash -c 'exit 0' & p=$!
  wait "$p" 2>/dev/null
  err="$(LC_ALL=C kill -0 "$p" 2>&1)"
  case "$err" in
    *[Nn]o\ such\ process*) printf '%s' "$p" ;;
    *) return 1 ;;
  esac
}

# A pid that is certainly alive for the length of a case. The caller kills it.
#
# The redirections are load-bearing, not tidiness. This runs inside `$( )`, so
# the background job inherits the command substitution's PIPE: left attached, it
# holds that pipe open and `$( )` blocks for the full sleep — after which the
# pid handed back is of a process that has just EXITED, and the "live holder"
# case silently becomes a stale-holder case that the library correctly reclaims.
live_pid() { # -> pid on stdout
  sleep 30 >/dev/null 2>&1 </dev/null &
  printf '%s' $!
}

# Is an uninspectable pid reachable for this test user at all? pid 1 answers
# `kill -0` with EPERM for an ordinary user and with success for root, so the
# case adapts rather than asserting something the environment cannot produce.
uninspectable_pid() { # -> pid on stdout, or empty
  local err
  LC_ALL=C kill -0 1 >/dev/null 2>&1 && return 1   # running privileged: pid 1 reads LIVE
  err="$(LC_ALL=C kill -0 1 2>&1)"
  case "$err" in
    *[Nn]o\ such\ process*) return 1 ;;
    *) printf '1' ;;
  esac
}

# ================================================================== case 0
echo
echo "Case 0 — harness falsifiability (library absent)"
d="$(new_checkout)"
O="$SANDBOX_ROOT/c0.out"
contend "$SANDBOX_ROOT/no-such-lease.sh" "$d" t0 harness 0 "$O" >/dev/null 2>&1; RC=$?
if [ "$RC" -eq 0 ]; then
  bad "a contender pointed at an ABSENT library must not report success" "rc=0"
else
  ok "a contender pointed at an ABSENT library cannot proceed (rc=$RC)"
fi
grep -q 'LIB-UNREADABLE' "$O" \
  && ok "and it says the library was unreadable rather than acquiring anything" \
  || bad "and it says the library was unreadable" "$(cat "$O")"
[ -d "$(task_dir "$d" t0)" ] \
  && bad "and it created no lease" "lease exists at $(task_dir "$d" t0)" \
  || ok "and it created no lease"

# ================================================================= case 0b
echo
echo "Case 0b — the race scenario discriminates: a NAIVE lease admits both contenders"
# One composite checkout|task key, no second resource, no rollback. This is the
# plausible wrong implementation — it is what the dispatcher's lease used to be
# — and every case below would be worthless if the scenario could not tell it
# apart from the real one.
NAIVE="$SANDBOX_ROOT/naive-lease.sh"
cat >"$NAIVE" <<'NAIVE_LIB'
WL_LEASE_ROOT=''; WL_LEASE_TASK_DIR=''; WL_LEASE_CHECKOUT_DIR=''
WL_LEASE_TASK_OWNED=0; WL_LEASE_CHECKOUT_OWNED=0; WL_LEASE_PINNED=0
WL_LEASE_RESOURCE=''; WL_LEASE_REFUSAL=''; WL_LEASE_SURVIVORS=''
WL_LEASE_HOLDER_PID=''; WL_LEASE_HOLDER_TASK=''; WL_LEASE_HOLDER_CHECKOUT=''
WL_LEASE_HOLDER_PROGRAM=''
wl_lease_init() {
  WL_LEASE_ROOT="${TMPDIR:-/tmp}/naive-lease"
  local k; k="$(printf '%s|%s' "$1" "$2" | shasum -a 256 | cut -c1-16)"
  WL_LEASE_TASK_DIR="$WL_LEASE_ROOT/$k.lock"
  WL_LEASE_CHECKOUT_DIR="$WL_LEASE_TASK_DIR"
  return 0
}
wl_lease_acquire() {
  mkdir -p "$WL_LEASE_ROOT" 2>/dev/null || return 1
  mkdir "$WL_LEASE_TASK_DIR" 2>/dev/null || { WL_LEASE_RESOURCE=composite; WL_LEASE_REFUSAL=held; return 2; }
  WL_LEASE_TASK_OWNED=1; WL_LEASE_CHECKOUT_OWNED=1
  return 0
}
wl_lease_pin() { return 1; }
wl_lease_release() { [ "$WL_LEASE_TASK_OWNED" -eq 1 ] && rm -rf "$WL_LEASE_TASK_DIR" 2>/dev/null; WL_LEASE_TASK_OWNED=0; return 0; }
wl_lease_status() { printf 'lease-root: %s\n' "$WL_LEASE_ROOT"; return 0; }
NAIVE_LIB
d="$(new_checkout)"
NA="$SANDBOX_ROOT/naive-a.out"; NB="$SANDBOX_ROOT/naive-b.out"
contend "$NAIVE" "$d" naive-alpha progA 4 "$NA" abandon >/dev/null 2>&1 &
naive_pid=$!
sleep 1
contend "$NAIVE" "$d" naive-beta progB 0 "$NB" >/dev/null 2>&1; RC=$?
wait "$naive_pid" 2>/dev/null
if grep -q '^ACQUIRED' "$NA" && grep -q '^ACQUIRED' "$NB"; then
  ok "the naive composite-key lease admits BOTH — so the scenario below is a real test"
else
  bad "the naive composite-key lease admits BOTH" \
      "A: $(head -1 "$NA" 2>/dev/null) / B: $(head -1 "$NB" 2>/dev/null)"
fi
rm -rf "${TMPDIR:-/tmp}/naive-lease"

# ================================================================== case 1
echo
echo "Case 1 — the lease root is derived from the repository, not from the caller's environment"
d="$(new_checkout)"
O1="$SANDBOX_ROOT/c1a.out"; O2="$SANDBOX_ROOT/c1b.out"
contend "$LEASE_LIB" "$d" env-task progA 4 "$O1" >/dev/null 2>&1 &
holder=$!
sleep 1
# A DIFFERENT TMPDIR is the exact condition under which the old ${TMPDIR}-rooted
# key silently failed to contend at all.
TMPDIR="$SANDBOX_ROOT/other-tmp" contend "$LEASE_LIB" "$d" env-task progB 0 "$O2" >/dev/null 2>&1; RC=$?
wait "$holder" 2>/dev/null
[ "$RC" -eq 17 ] \
  && ok "a second contender with a different TMPDIR is still refused" \
  || bad "a second contender with a different TMPDIR is still refused" "rc=$RC $(cat "$O2")"
grep -q 'resource=task' "$O2" \
  && ok "and the refusal names the TASK lease as the resource" \
  || bad "and the refusal names the TASK lease" "$(cat "$O2")"
# The path the LIBRARY itself reported, against a Git common directory resolved
# here without going through the library. Comparing the harness's own
# lease_dirs() with itself would assert nothing.
LIB_TASK_DIR="$(sed -n 's/.*task_dir=\([^ ]*\).*/\1/p' "$O1" | head -1)"
GIT_COMMON="$(cd "$d" && cd "$(git rev-parse --git-common-dir)" && pwd -P)"
case "$LIB_TASK_DIR" in
  "$GIT_COMMON/work-loop-dispatch-locks/task-"*) ok "the lease the library took lives under the Git common directory" ;;
  *) bad "the lease lives under the Git common directory" "library said: ${LIB_TASK_DIR:-<none>} / git common: $GIT_COMMON" ;;
esac
case "$LIB_TASK_DIR" in
  "${TMPDIR:-/tmp}"/axcion*|"${TMPDIR:-/tmp}"/*lease*) bad "and not under the caller's TMPDIR" "$LIB_TASK_DIR" ;;
  *) ok "and not under the caller's TMPDIR, which is what silently failed to contend before" ;;
esac

# ================================================================== case 2
echo
echo "Case 2 — N simultaneous contenders on one free (task, checkout) pair: exactly one proceeds"
d="$(new_checkout)"
BARRIER="$SANDBOX_ROOT/barrier-2"
rm -f "$BARRIER"
N=6
pids=(); outs=()
for i in $(seq 1 "$N"); do
  o="$SANDBOX_ROOT/race-$i.out"; : >"$o"; outs+=("$o")
  contend "$LEASE_LIB" "$d" race-task "prog$i" 2 "$o" run "$BARRIER" >/dev/null 2>&1 &
  pids+=($!)
done
sleep 1
: >"$BARRIER"          # release them all at once
for p in "${pids[@]}"; do wait "$p" 2>/dev/null; done
acq=0; ref=0; other=0
for o in "${outs[@]}"; do
  if   grep -q '^ACQUIRED' "$o"; then acq=$((acq+1))
  elif grep -q '^REFUSED'  "$o"; then ref=$((ref+1))
  else other=$((other+1)); fi
done
[ "$acq" -eq 1 ] \
  && ok "exactly one of $N simultaneous contenders acquired (acquired=$acq)" \
  || bad "exactly one of $N simultaneous contenders acquired" "acquired=$acq refused=$ref other=$other"
[ "$ref" -eq $((N-1)) ] \
  && ok "and the other $((N-1)) were refused, none silently" \
  || bad "and the other $((N-1)) were refused" "acquired=$acq refused=$ref other=$other"
[ -d "$(task_dir "$d" race-task)" ] \
  && bad "and the winner released its lease on exit" "still held" \
  || ok "and the winner released its lease on exit"

# ================================================================== case 3
echo
echo "Case 3 — task lease taken, checkout lease refused: the task lease is released before exit"
d="$(new_checkout)"
HOLD_OUT="$SANDBOX_ROOT/c3-hold.out"; TRY_OUT="$SANDBOX_ROOT/c3-try.out"
contend "$LEASE_LIB" "$d" task-alpha holder 6 "$HOLD_OUT" >/dev/null 2>&1 &
holder=$!
sleep 1
grep -q '^ACQUIRED' "$HOLD_OUT" \
  && ok "setup — the first run holds both leases" \
  || bad "setup — the first run holds both leases" "$(cat "$HOLD_OUT")"
# A DIFFERENT task in the SAME checkout: its task lease is free, its checkout
# lease is not. This is the only route into the two-resource rollback.
contend "$LEASE_LIB" "$d" task-beta second 0 "$TRY_OUT" >/dev/null 2>&1; RC=$?
[ "$RC" -eq 17 ] \
  && ok "the second run is refused on the CHECKOUT lease" \
  || bad "the second run is refused" "rc=$RC $(cat "$TRY_OUT")"
grep -q 'resource=checkout' "$TRY_OUT" \
  && ok "and the refusal names the checkout lease, not the task lease" \
  || bad "and the refusal names the checkout lease" "$(cat "$TRY_OUT")"
grep -q 'holder_task=task-alpha' "$TRY_OUT" \
  && ok "and it names the task already running in this checkout" \
  || bad "and it names the task already running in this checkout" "$(cat "$TRY_OUT")"
grep -q 'holder_program=holder' "$TRY_OUT" \
  && ok "and it names the PROGRAM holding it — a refusal the operator can act on" \
  || bad "and it names the program holding it" "$(cat "$TRY_OUT")"
# The rollback. Without it, task-beta's lease would outlive the run that never
# used it and refuse the next run for a reason that no longer exists.
[ -d "$(task_dir "$d" task-beta)" ] \
  && bad "and the refused run left NO orphan task lease behind" "orphan at $(task_dir "$d" task-beta)" \
  || ok "and the refused run left NO orphan task lease behind"
[ -d "$(task_dir "$d" task-alpha)" ] \
  && ok "and the rollback did not touch the holder's own task lease" \
  || bad "and the rollback did not touch the holder's own task lease" "holder's lease is gone"
wait "$holder" 2>/dev/null

# ================================================================== case 4
echo
echo "Case 4 — after the rollback, a third run acquires both cleanly"
# Same checkout, same task the rolled-back run used. If the rollback had left an
# orphan, this is the run that would be refused for no live reason.
THIRD="$SANDBOX_ROOT/c4.out"
contend "$LEASE_LIB" "$d" task-beta third 0 "$THIRD" >/dev/null 2>&1; RC=$?
[ "$RC" -eq 0 ] \
  && ok "a third run on the rolled-back task acquires both leases (rc=0)" \
  || bad "a third run acquires both leases" "rc=$RC $(cat "$THIRD")"
grep -q 'task_owned=1 checkout_owned=1' "$THIRD" \
  && ok "and it owns BOTH resources, not one" \
  || bad "and it owns both resources" "$(cat "$THIRD")"
grep -q 'RELEASED task=absent checkout=absent' "$THIRD" \
  && ok "and an ordinary exit releases both" \
  || bad "and an ordinary exit releases both" "$(cat "$THIRD")"

# ================================================================== case 5
echo
echo "Case 5 — a refused run pins nothing: pin never claims a resource it did not acquire"
d="$(new_checkout)"
H5="$SANDBOX_ROOT/c5-hold.out"; P5="$SANDBOX_ROOT/c5-pin.out"
contend "$LEASE_LIB" "$d" pin-alpha holder 6 "$H5" >/dev/null 2>&1 &
holder=$!
sleep 1
contend "$LEASE_LIB" "$d" pin-beta refused 0 "$P5" pin-after-refusal >/dev/null 2>&1; RC=$?
[ "$RC" -eq 17 ] && ok "setup — the run was refused" || bad "setup — the run was refused" "rc=$RC"
grep -q 'PIN-AFTER-REFUSAL rc=1 pinned=0' "$P5" \
  && ok "pin refuses to run when nothing was acquired" \
  || bad "pin refuses to run when nothing was acquired" "$(cat "$P5")"
# Its OWN task lease, which the rollback removed. The checkout lease is present
# throughout and that is the holder's, not this run's — asserting it absent here
# would be asserting that a refused run can delete a live holder's lease.
grep -q 'PIN-AFTER-REFUSAL .*task=absent' "$P5" \
  && ok "and it created no lease directory as a side effect of pinning" \
  || bad "and it created no lease directory" "$(cat "$P5")"
[ -f "$(checkout_dir "$d" pin-beta)/survivors" ] \
  && bad "and it did not pin the lease the OTHER run holds" "survivors written into the holder's checkout lease" \
  || ok "and it did not pin the lease the OTHER run holds"
wait "$holder" 2>/dev/null

# ================================================================== case 6
echo
echo "Case 6 — partial acquisition: pin writes into the task lease only, never the unowned one"
d="$(new_checkout)"
P6="$SANDBOX_ROOT/c6.out"
contend "$LEASE_LIB" "$d" partial-task pinner 0 "$P6" pin-task-only >/dev/null 2>&1; RC=$?
[ "$RC" -eq 0 ] && ok "setup — the run acquired and then pinned" || bad "setup" "rc=$RC $(cat "$P6")"
grep -q 'PIN rc=0 pinned=1 task_survivors=yes checkout_survivors=no' "$P6" \
  && ok "the pin claimed the owned task lease and NOT the unowned checkout lease" \
  || bad "the pin claimed only the owned lease" "$(cat "$P6")"

# ================================================================== case 7
echo
echo "Case 7 — a pinned lease is not released, and refuses the next run"
d="$(new_checkout)"
P7="$SANDBOX_ROOT/c7-pin.out"; N7="$SANDBOX_ROOT/c7-next.out"
contend "$LEASE_LIB" "$d" pinned-task pinner 0 "$P7" pin >/dev/null 2>&1; RC=$?
[ "$RC" -eq 0 ] && ok "setup — the run acquired and pinned" || bad "setup" "rc=$RC $(cat "$P7")"
grep -q 'PIN rc=0 pinned=1' "$P7" \
  && ok "the pin took effect" || bad "the pin took effect" "$(cat "$P7")"
# The whole point: release ran, on the ordinary exit path, and changed nothing.
grep -q 'AFTER-RELEASE task=present checkout=present' "$P7" \
  && ok "release left BOTH pinned leases in place — pinned beats owned" \
  || bad "release left both pinned leases in place" "$(cat "$P7")"
grep -q '^descendants still running: 4242$' "$(task_dir "$d" pinned-task)/survivors" \
  && ok "the survivors file records the pids in the format --status reads back" \
  || bad "the survivors file records the pids" "$(cat "$(task_dir "$d" pinned-task)/survivors" 2>/dev/null)"
contend "$LEASE_LIB" "$d" pinned-task next 0 "$N7" >/dev/null 2>&1; RC=$?
[ "$RC" -eq 17 ] && ok "the next run is refused by the pinned lease" \
                 || bad "the next run is refused" "rc=$RC $(cat "$N7")"
grep -q 'refusal=pinned' "$N7" \
  && ok "and the refusal says PINNED, not merely held — the two need different remedies" \
  || bad "and the refusal says pinned" "$(cat "$N7")"
grep -q "survivors=$(task_dir "$d" pinned-task)/survivors" "$N7" \
  && ok "and it hands back the pin evidence the operator has to read" \
  || bad "and it hands back the pin evidence" "$(cat "$N7")"

# ================================================================== case 8
echo
echo "Case 8 — unreadable holder metadata refuses and deletes nothing"
d="$(new_checkout)"
TD="$(task_dir "$d" orphan-task)"
mkdir -p "$TD"          # a lease directory with no pid, task, checkout or program
U8="$SANDBOX_ROOT/c8.out"
contend "$LEASE_LIB" "$d" orphan-task probe 0 "$U8" >/dev/null 2>&1; RC=$?
[ "$RC" -eq 17 ] \
  && ok "a lease whose holder cannot be read is treated as HELD" \
  || bad "a lease whose holder cannot be read is treated as held" "rc=$RC $(cat "$U8")"
grep -q 'holder_pid= holder_program= holder_task=' "$U8" \
  && ok "and the holder fields come back empty rather than invented" \
  || bad "and the holder fields come back empty" "$(cat "$U8")"
[ -d "$TD" ] \
  && ok "and the unreadable lease was NOT deleted" \
  || bad "and the unreadable lease was not deleted" "$TD is gone"
# Same again with the metadata present but unreadable, which is the case a
# permission-restricted holder actually produces.
d="$(new_checkout)"
TD="$(task_dir "$d" noperm-task)"
mkdir -p "$TD"; printf '4242\n' >"$TD/pid"; chmod 000 "$TD/pid"
U8b="$SANDBOX_ROOT/c8b.out"
contend "$LEASE_LIB" "$d" noperm-task probe 0 "$U8b" >/dev/null 2>&1; RC=$?
[ "$RC" -eq 17 ] \
  && ok "an unreadable pid file refuses too, rather than reading absence as free" \
  || bad "an unreadable pid file refuses" "rc=$RC $(cat "$U8b")"
[ -f "$TD/pid" ] \
  && ok "and nothing was deleted on that path either" \
  || bad "and nothing was deleted on that path" "$TD/pid is gone"
chmod 644 "$TD/pid" 2>/dev/null

# ================================================================== case 9
echo
echo "Case 9 — status is read-only: it takes no lease and creates nothing"
d="$(new_checkout)"
S9="$SANDBOX_ROOT/c9-free.out"
ROOT9="$(dirname "$(task_dir "$d" status-task)")"
[ -d "$ROOT9" ] && bad "setup — the lease root does not exist yet" "$ROOT9 exists" \
                || ok "setup — the lease root does not exist yet"
contend "$LEASE_LIB" "$d" status-task viewer 0 "$S9" status >/dev/null 2>&1; RC=$?
[ "$RC" -eq 0 ] && ok "status over a free lease exits 0" || bad "status exits 0" "rc=$RC"
grep -q 'task-lease: FREE' "$S9" && ok "and reports the task lease FREE" \
                                 || bad "and reports the task lease FREE" "$(cat "$S9")"
grep -q 'checkout-lease: FREE' "$S9" && ok "and reports the checkout lease FREE" \
                                     || bad "and reports the checkout lease FREE" "$(cat "$S9")"
[ -d "$ROOT9" ] \
  && bad "and status created NOTHING — not even the lease root" "$ROOT9 was created" \
  || ok "and status created NOTHING — not even the lease root"
# Now over a held lease, which is the case status exists for.
H9="$SANDBOX_ROOT/c9-hold.out"; S9b="$SANDBOX_ROOT/c9-held.out"
contend "$LEASE_LIB" "$d" status-task attended 6 "$H9" >/dev/null 2>&1 &
holder=$!
sleep 1
contend "$LEASE_LIB" "$d" status-task viewer 0 "$S9b" status >/dev/null 2>&1; RC=$?
[ "$RC" -eq 0 ] && ok "status over a HELD lease exits 0 and does not contend" \
               || bad "status over a held lease exits 0" "rc=$RC"
grep -q 'task-lease: HELD' "$S9b" && ok "and reports it HELD" \
                                  || bad "and reports it HELD" "$(cat "$S9b")"
grep -q 'task-holder: .*program=attended' "$S9b" \
  && ok "and names the program holding it" || bad "and names the program" "$(cat "$S9b")"
[ -d "$(task_dir "$d" status-task)" ] \
  && ok "and the holder's lease survived the status call" \
  || bad "and the holder's lease survived the status call" "the lease is gone"
wait "$holder" 2>/dev/null

# ================================================================= case 10
echo
echo "Case 10 — the library refuses to be run as a command"
OUT="$(bash "$LEASE_LIB" acquire 2>&1)"; RC=$?
[ "$RC" -eq 64 ] \
  && ok "executing the library directly exits 64 instead of succeeding silently" \
  || bad "executing the library directly exits 64" "rc=$RC $OUT"
printf '%s' "$OUT" | grep -q 'SOURCED' \
  && ok "and it says it must be sourced" || bad "and it says it must be sourced" "$OUT"

# ================================================================= case 11
echo
echo "Case 11 — the TASK pin evidence cannot persist: the pin says so instead of reporting success"
# The failure this pair exists to catch is not a lost file. It is a pin that
# RETURNS SUCCESS having recorded nothing a later process can read, so the
# caller announces a pin that is not there and the operator is told to inspect
# survivors that were never written down.
d="$(new_checkout)"
B11="$SANDBOX_ROOT/c11.out"
contend "$LEASE_LIB" "$d" block-task-evidence pinner 0 "$B11" pin-block-task >/dev/null 2>&1; RC=$?
[ "$RC" -eq 0 ] && ok "setup — the run acquired both leases and then pinned with the task evidence blocked" \
               || bad "setup — the run acquired and pinned" "rc=$RC $(cat "$B11")"
grep -q 'PIN rc=2 pinned=1 ' "$B11" \
  && ok "the pin reports the OWNED-BUT-NOT-DURABLY-PINNED outcome (rc=2), not ordinary success" \
  || bad "the pin reports rc=2 rather than success" "$(cat "$B11")"
grep -q 'failed=\[task\]' "$B11" \
  && ok "and it names the TASK resource as the one without durable evidence" \
  || bad "and it names the task resource" "$(cat "$B11")"
grep -q 'task_evidence=no checkout_evidence=yes' "$B11" \
  && ok "and the checkout evidence still persisted — the two writes fail independently" \
  || bad "the checkout evidence still persisted independently" "$(cat "$B11")"
# The safety half. Whatever the evidence did, the lease directories are the
# thing that refuses the next run, and PINNED must keep release away from them.
grep -q 'AFTER-RELEASE task=present checkout=present' "$B11" \
  && ok "and release left BOTH leases in place — a pin whose evidence failed is still a pin" \
  || bad "release left both leases in place" "$(cat "$B11")"
L11="$SANDBOX_ROOT/c11-later.out"
contend "$LEASE_LIB" "$d" block-task-evidence later 0 "$L11" >/dev/null 2>&1; RC=$?
[ "$RC" -eq 17 ] \
  && ok "a later run on the same task is still REFUSED, not admitted" \
  || bad "a later run on the same task is refused" "rc=$RC $(cat "$L11")"
grep -q 'resource=task' "$L11" \
  && ok "and it is the task lease that refuses it" \
  || bad "and the task lease refuses it" "$(cat "$L11")"
# The other affected owned resource: a DIFFERENT task in the same checkout.
L11b="$SANDBOX_ROOT/c11-later-other.out"
contend "$LEASE_LIB" "$d" block-task-other later 0 "$L11b" >/dev/null 2>&1; RC=$?
[ "$RC" -eq 17 ] \
  && ok "and a different task in the same checkout is refused by the checkout lease" \
  || bad "a different task in the same checkout is refused" "rc=$RC $(cat "$L11b")"
grep -q 'resource=checkout refusal=pinned' "$L11b" \
  && ok "and THAT refusal reads PINNED, because its own evidence did persist" \
  || bad "and that refusal reads pinned" "$(cat "$L11b")"

# ================================================================= case 12
echo
echo "Case 12 — the CHECKOUT pin evidence cannot replicate: reported distinctly from a task failure"
d="$(new_checkout)"
B12="$SANDBOX_ROOT/c12.out"
contend "$LEASE_LIB" "$d" block-checkout-evidence pinner 0 "$B12" pin-block-checkout >/dev/null 2>&1; RC=$?
[ "$RC" -eq 0 ] && ok "setup — the run acquired both leases and then pinned with the checkout evidence blocked" \
               || bad "setup — the run acquired and pinned" "rc=$RC $(cat "$B12")"
grep -q 'PIN rc=2 pinned=1 ' "$B12" \
  && ok "the pin reports rc=2 here too" \
  || bad "the pin reports rc=2" "$(cat "$B12")"
grep -q 'failed=\[checkout\]' "$B12" \
  && ok "and it names the CHECKOUT resource — distinguishable from the task failure in case 11" \
  || bad "and it names the checkout resource" "$(cat "$B12")"
grep -q 'task_evidence=yes checkout_evidence=no' "$B12" \
  && ok "and the task evidence persisted, so one failure did not become two" \
  || bad "the task evidence persisted" "$(cat "$B12")"
grep -q 'AFTER-RELEASE task=present checkout=present' "$B12" \
  && ok "and release left both leases in place" \
  || bad "release left both leases in place" "$(cat "$B12")"
L12="$SANDBOX_ROOT/c12-later.out"
contend "$LEASE_LIB" "$d" block-checkout-evidence later 0 "$L12" >/dev/null 2>&1; RC=$?
[ "$RC" -eq 17 ] \
  && ok "a later run on the same task is refused" \
  || bad "a later run on the same task is refused" "rc=$RC $(cat "$L12")"
grep -q 'refusal=pinned' "$L12" \
  && ok "and the surviving task evidence still gives it the PINNED reason" \
  || bad "and it reads pinned" "$(cat "$L12")"
L12b="$SANDBOX_ROOT/c12-later-other.out"
contend "$LEASE_LIB" "$d" block-checkout-other later 0 "$L12b" >/dev/null 2>&1; RC=$?
[ "$RC" -eq 17 ] \
  && ok "and a different task in the same checkout is still refused by the checkout lease" \
  || bad "a different task in the same checkout is refused" "rc=$RC $(cat "$L12b")"

# ================================================================= case 13
echo
echo "Case 13 — a LIVE holder refuses, and its lease directory survives untouched"
# The positive control for every reclaim case below. If the helper could not
# tell a live holder from a dead one, case 16 would be indistinguishable from
# a lease that deletes whatever it finds.
d="$(new_checkout)"
LP="$(live_pid)"
TD13="$(task_dir "$d" live-holder)"
fabricate_lease "$TD13" "$LP" carry live-holder "$d" \
  && ok "setup — a lease fabricated with a live pid ($LP)" \
  || bad "setup — a lease fabricated with a live pid" "could not create $TD13"
C13="$SANDBOX_ROOT/c13.out"
contend "$LEASE_LIB" "$d" live-holder probe 0 "$C13" >/dev/null 2>&1; RC=$?
[ "$RC" -eq 17 ] \
  && ok "a live holder refuses the next run" \
  || bad "a live holder refuses the next run" "rc=$RC $(cat "$C13")"
grep -q 'refusal=held' "$C13" \
  && ok "and the refusal reads HELD" || bad "and the refusal reads held" "$(cat "$C13")"
grep -q 'REFUSED-STATE state=LIVE ' "$C13" \
  && ok "and the liveness verdict is LIVE, not merely 'a directory exists'" \
  || bad "and the liveness verdict is LIVE" "$(cat "$C13")"
[ -d "$TD13" ] && [ "$(cat "$TD13/pid")" = "$LP" ] \
  && ok "and the live holder's lease survived byte-identical" \
  || bad "and the live holder's lease survived" "$TD13 changed or is gone"
kill "$LP" 2>/dev/null; wait "$LP" 2>/dev/null

# ================================================================= case 14
echo
echo "Case 14 — an UNINSPECTABLE holder refuses, and its lease directory survives"
# The Phase 0 failure in one case: a live process the caller is not permitted to
# signal. Reading that refusal as a death certificate is what told an operator to
# delete a lock that was doing its job.
UP="$(uninspectable_pid)"
if [ -z "$UP" ]; then
  ok "SKIPPED — this user cannot produce an uninspectable pid (running privileged, or pid 1 absent)"
else
  d="$(new_checkout)"
  TD14="$(task_dir "$d" unknown-holder)"
  fabricate_lease "$TD14" "$UP" dispatch unknown-holder "$d" \
    && ok "setup — a lease fabricated with an uninspectable pid ($UP)" \
    || bad "setup — a lease fabricated with an uninspectable pid" "could not create $TD14"
  C14="$SANDBOX_ROOT/c14.out"
  contend "$LEASE_LIB" "$d" unknown-holder probe 0 "$C14" >/dev/null 2>&1; RC=$?
  [ "$RC" -eq 17 ] \
    && ok "an uninspectable holder refuses the next run" \
    || bad "an uninspectable holder refuses" "rc=$RC $(cat "$C14")"
  grep -q 'REFUSED-STATE state=UNKNOWN ' "$C14" \
    && ok "and the verdict is UNKNOWN — not ABSENT, which is the dangerous misread" \
    || bad "and the verdict is UNKNOWN" "$(cat "$C14")"
  grep -q 'REFUSED-STATE .*reason=.*kill -0 failed WITHOUT proving absence' "$C14" \
    && ok "and it says WHY inspection was inconclusive" \
    || bad "and it says why inspection was inconclusive" "$(cat "$C14")"
  [ -d "$TD14" ] && [ "$(cat "$TD14/pid")" = "$UP" ] \
    && ok "and the uninspectable holder's lease survived untouched" \
    || bad "and the uninspectable lease survived" "$TD14 changed or is gone"
fi

# ================================================================= case 15
echo
echo "Case 15 — missing, empty, malformed, zero and zero-prefixed pids are UNKNOWN, refuse, and survive"
# `0` is the one that is not merely useless but dangerous: kill(2) reads it as
# the CALLER'S OWN process group, so `kill -0 0` succeeds and a corrupt lease
# would read as a live holder — or, reclaimed, as a signal aimed at the operator.
# `007` is the quiet version: it reaches kill(2) as pid 7.
d="$(new_checkout)"
for spec in "__none__:missing pid file" ":empty pid file" "abc:non-numeric pid" \
            "0:pid zero" "007:zero-prefixed pid"; do
  raw="${spec%%:*}"; label="${spec#*:}"
  tk="corrupt-$(printf '%s' "$label" | tr -c 'a-z0-9' '-')"
  TD15="$(task_dir "$d" "$tk")"
  fabricate_lease "$TD15" "$raw" carry "$tk" "$d" || { bad "setup — $label" "$TD15"; continue; }
  C15="$SANDBOX_ROOT/c15-$RANDOM.out"
  contend "$LEASE_LIB" "$d" "$tk" probe 0 "$C15" >/dev/null 2>&1; RC=$?
  if [ "$RC" -eq 17 ] && grep -q 'REFUSED-STATE state=UNKNOWN ' "$C15" && [ -d "$TD15" ]; then
    ok "$label — UNKNOWN, refused (rc=17), and the lease survived"
  else
    bad "$label — UNKNOWN, refused, and the lease survived" \
        "rc=$RC present=$([ -d "$TD15" ] && printf yes || printf no) $(cat "$C15")"
  fi
done

# ================================================================= case 16
echo
echo "Case 16 — a POSITIVELY ABSENT unpinned holder is reclaimed, and the next run acquires both"
# The half that the "unknown is held" rule must not swallow: a lease whose
# holder is provably gone has to stop refusing, or a crashed run strands its
# task for good and the only remedy is a hand-edited lock directory.
d="$(new_checkout)"
AP="$(absent_pid)"
if [ -z "$AP" ]; then
  bad "setup — a positively absent pid could be established" "kill -0 did not report 'no such process'"
else
  ok "setup — pid $AP is positively absent, confirmed by kill -0 wording"
  TD16="$(task_dir "$d" stale-holder)"
  fabricate_lease "$TD16" "$AP" dispatch stale-holder "$d" \
    && ok "setup — a stale lease fabricated with that dead pid" \
    || bad "setup — a stale lease fabricated" "could not create $TD16"
  C16="$SANDBOX_ROOT/c16.out"
  contend "$LEASE_LIB" "$d" stale-holder recoverer 0 "$C16" >/dev/null 2>&1; RC=$?
  [ "$RC" -eq 0 ] \
    && ok "the new run is ADMITTED over the dead holder (rc=0)" \
    || bad "the new run is admitted over the dead holder" "rc=$RC $(cat "$C16")"
  grep -q 'task_owned=1 checkout_owned=1' "$C16" \
    && ok "and it owns BOTH resources, so recovery is not a half-admission" \
    || bad "and it owns both resources" "$(cat "$C16")"
  grep -q 'RELEASED task=absent checkout=absent' "$C16" \
    && ok "and its ordinary exit releases both, leaving the task clean" \
    || bad "and its ordinary exit releases both" "$(cat "$C16")"
  # Reclaim must not litter. Named artifacts are asserted by NAME first, and
  # then the whole lease root is asserted to hold nothing but lease directories
  # — because a name-matched assertion can only ever catch the residue whose
  # name it was told, and the residue that matters is the kind nobody predicted.
  ROOT16="$(dirname "$TD16")"
  LEFT="$(find "$ROOT16" -maxdepth 1 \( -name '*.stale.*' -o -name '*.reclaiming' \) 2>/dev/null)"
  [ -z "$LEFT" ] \
    && ok "and reclaim left no tombstone and no reclaim marker behind" \
    || bad "and reclaim left no tombstone or reclaim marker behind" "$LEFT"
  STRAY="$(find "$ROOT16" -mindepth 1 -maxdepth 1 ! -name '*.lock' 2>/dev/null)"
  [ -z "$STRAY" ] \
    && ok "and the lease root holds nothing but lease directories" \
    || bad "and the lease root holds nothing but lease directories" "$STRAY"
  WITNESS="$(find "$ROOT16" -mindepth 2 -maxdepth 2 -name 'wl-reclaim-*' 2>/dev/null)"
  [ -z "$WITNESS" ] \
    && ok "and no reclaim witness survived inside the acquired lease" \
    || bad "and no reclaim witness survived inside the lease" "$WITNESS"
fi

# ================================================================= case 17
echo
echo "Case 17 — two or more contenders reclaiming the SAME stale lease still produce exactly one winner"
# The failure this case exists to catch is subtle and only appears under a
# rename-and-recreate reclaim: A renames the stale lease away and recreates it,
# and B — whose ABSENT verdict is now about a directory that no longer exists —
# renames A's LIVE lease away and takes the task as well. Two winners, from two
# individually correct decisions.
d="$(new_checkout)"
AP2="$(absent_pid)"
if [ -z "$AP2" ]; then
  bad "setup — a positively absent pid could be established" "kill -0 did not report 'no such process'"
else
  TD17="$(task_dir "$d" stale-race)"
  fabricate_lease "$TD17" "$AP2" dispatch stale-race "$d" \
    && ok "setup — one stale lease, pid $AP2, and $N contenders about to race for it" \
    || bad "setup — one stale lease" "could not create $TD17"
  BARRIER17="$SANDBOX_ROOT/barrier-17"; rm -f "$BARRIER17"
  pids=(); outs=()
  for i in $(seq 1 "$N"); do
    o="$SANDBOX_ROOT/stale-race-$i.out"; : >"$o"; outs+=("$o")
    contend "$LEASE_LIB" "$d" stale-race "prog$i" 2 "$o" run "$BARRIER17" >/dev/null 2>&1 &
    pids+=($!)
  done
  sleep 1
  : >"$BARRIER17"
  for p in "${pids[@]}"; do wait "$p" 2>/dev/null; done
  acq=0; ref=0; other=0
  for o in "${outs[@]}"; do
    if   grep -q '^ACQUIRED' "$o"; then acq=$((acq+1))
    elif grep -q '^REFUSED'  "$o"; then ref=$((ref+1))
    else other=$((other+1)); fi
  done
  [ "$acq" -eq 1 ] \
    && ok "exactly one contender reclaimed the stale lease (acquired=$acq)" \
    || bad "exactly one contender reclaimed the stale lease" "acquired=$acq refused=$ref other=$other"
  [ "$ref" -eq $((N-1)) ] \
    && ok "and the other $((N-1)) were refused, none silently" \
    || bad "and the other $((N-1)) were refused" "acquired=$acq refused=$ref other=$other"
  [ "$other" -eq 0 ] \
    && ok "and no contender ended in a state that is neither" \
    || bad "and no contender ended in a state that is neither" "other=$other"
fi

# ================================================================= case 18
echo
echo "Case 18 — a PINNED lease whose recorded holder is DEAD is still never reclaimed"
# Pin evidence is checked BEFORE liveness, and this is the case that proves the
# order rather than assuming it: the pid is provably gone, so a helper that
# probed first would reclaim, and the survivors the operator was told to inspect
# would be deleted along with the reason they existed.
d="$(new_checkout)"
AP3="$(absent_pid)"
if [ -z "$AP3" ]; then
  bad "setup — a positively absent pid could be established" "kill -0 did not report 'no such process'"
else
  TD18="$(task_dir "$d" pinned-dead)"
  fabricate_lease "$TD18" "$AP3" dispatch pinned-dead "$d" \
    && ok "setup — a lease fabricated with a dead pid ($AP3)" \
    || bad "setup — a lease fabricated with a dead pid" "could not create $TD18"
  printf 'PINNED by pid %s at 2026-08-15T00:00:00\ntask: pinned-dead\ndescendants still running: 9999\n' \
    "$AP3" >"$TD18/survivors"
  C18="$SANDBOX_ROOT/c18.out"
  contend "$LEASE_LIB" "$d" pinned-dead later 0 "$C18" >/dev/null 2>&1; RC=$?
  [ "$RC" -eq 17 ] \
    && ok "the pinned lease still refuses, though its launcher is provably gone" \
    || bad "the pinned lease still refuses" "rc=$RC $(cat "$C18")"
  grep -q 'refusal=pinned' "$C18" \
    && ok "and the refusal reads PINNED — the remedy is the operator's, not automatic" \
    || bad "and the refusal reads pinned" "$(cat "$C18")"
  grep -q 'REFUSED-STATE state=PINNED ' "$C18" \
    && ok "and pin evidence outranked the liveness question rather than following it" \
    || bad "and pin evidence outranked the liveness question" "$(cat "$C18")"
  [ -d "$TD18" ] && [ -f "$TD18/survivors" ] \
    && ok "and the survivors record the operator has to read was not deleted" \
    || bad "and the survivors record was not deleted" "$TD18/survivors is gone"
fi

# ================================================================= case 19
echo
echo "Case 19 — a reclaimer that DIED mid-reclaim does not strand the lease it was reclaiming"
# The stranding this case exists to catch is second-order and easy to create by
# accident: the mechanism that stops two reclaimers colliding becomes, when its
# owner dies holding it, exactly the permanent refusal that liveness recovery
# was added to remove. The dead holder no longer strands the task — the dead
# RECLAIMER does.
#
# Both representations of the interrupted state are fabricated, because the
# correction changed which one exists: a `<lease>.reclaiming` marker directory
# owned by a dead pid, which is what the exclusive-marker mechanism left behind,
# and a `wl-reclaim-<deadpid>-N` witness inside the stale lease, which is what
# the witness-set mechanism leaves behind. Whichever the implementation under
# test uses, the interrupted state is present, so the case is a real test of
# both rather than a description of one.
d="$(new_checkout)"
AP4="$(absent_pid)"
DEAD_RECLAIMER="$(absent_pid)"
if [ -z "$AP4" ] || [ -z "$DEAD_RECLAIMER" ]; then
  bad "setup — two positively absent pids could be established" "kill -0 did not report 'no such process'"
else
  TD19="$(task_dir "$d" interrupted-reclaim)"
  fabricate_lease "$TD19" "$AP4" dispatch interrupted-reclaim "$d" \
    && ok "setup — a stale lease (holder pid $AP4, gone)" \
    || bad "setup — a stale lease" "could not create $TD19"
  mkdir -p "$TD19.reclaiming" && printf '%s\n' "$DEAD_RECLAIMER" >"$TD19.reclaiming/pid"
  mkdir -p "$TD19/wl-reclaim-$DEAD_RECLAIMER-1"
  ok "setup — and a reclaimer (pid $DEAD_RECLAIMER, also gone) interrupted part-way through it"
  C19="$SANDBOX_ROOT/c19.out"
  contend "$LEASE_LIB" "$d" interrupted-reclaim recoverer 0 "$C19" >/dev/null 2>&1; RC=$?
  [ "$RC" -eq 0 ] \
    && ok "the next run still acquires — a dead reclaimer does not strand the task" \
    || bad "the next run still acquires over a dead reclaimer" "rc=$RC $(cat "$C19")"
  grep -q 'task_owned=1 checkout_owned=1' "$C19" \
    && ok "and it owns both resources, so recovery is not a half-admission" \
    || bad "and it owns both resources" "$(cat "$C19")"
  grep -q 'RELEASED task=absent checkout=absent' "$C19" \
    && ok "and its ordinary exit releases both, leaving the task clean" \
    || bad "and its ordinary exit releases both" "$(cat "$C19")"
  [ -z "$(find "$(dirname "$TD19")" -mindepth 2 -maxdepth 2 -name 'wl-reclaim-*' 2>/dev/null)" ] \
    && ok "and the dead reclaimer's witness went with the lease it was reclaiming" \
    || bad "and the dead reclaimer's witness was cleaned up" \
        "$(find "$(dirname "$TD19")" -mindepth 2 -maxdepth 2 -name 'wl-reclaim-*' 2>/dev/null)"
  [ -z "$(find "$(dirname "$TD19")" -maxdepth 1 -name '*.stale.*' 2>/dev/null)" ] \
    && ok "and no tombstone was left behind" \
    || bad "and no tombstone was left behind" \
        "$(find "$(dirname "$TD19")" -maxdepth 1 -name '*.stale.*' 2>/dev/null)"
  # BOTH representations have to be cleaned up, not just the one the current
  # build writes. A dead marker left sitting beside a recovered lease is
  # unexplained residue: the next reader cannot tell it from a live reclaim.
  [ ! -e "$TD19.reclaiming" ] \
    && ok "and the dead reclaimer's old-format marker was cleaned up too" \
    || bad "and the dead reclaimer's old-format marker was cleaned up" "$TD19.reclaiming survives"
fi

# ================================================================= case 20
echo
echo "Case 20 — a reclaimer that is STILL WORKING is preserved and keeps the next run out"
# The other half of case 19, and the one that stops the fix from being "delete
# whatever is in the way". Recovering a dead reclaimer's witness must not become
# a licence to overrun a live one. Both sub-cases fabricate a stale lease — so
# the reclaim path is genuinely entered — and then a witness whose owner this
# process must not step over.
d="$(new_checkout)"
AP5="$(absent_pid)"
UP2="$(uninspectable_pid)"
if [ -z "$AP5" ]; then
  bad "setup — a positively absent pid could be established" "kill -0 did not report 'no such process'"
else
  # (a) UNINSPECTABLE reclaimer. pid 1 is deterministic here: it is lower than
  #     every contender pid and it answers `kill -0` with a refusal rather than
  #     with absence, so the verdict cannot come out ABSENT by accident.
  if [ -z "$UP2" ]; then
    ok "SKIPPED (a) — this user cannot produce an uninspectable pid"
  else
    TD20a="$(task_dir "$d" reclaimer-unknown)"
    fabricate_lease "$TD20a" "$AP5" dispatch reclaimer-unknown "$d" >/dev/null
    mkdir -p "$TD20a/wl-reclaim-$UP2-1"
    C20a="$SANDBOX_ROOT/c20a.out"
    contend "$LEASE_LIB" "$d" reclaimer-unknown probe 0 "$C20a" >/dev/null 2>&1; RC=$?
    [ "$RC" -eq 17 ] \
      && ok "an UNINSPECTABLE reclaimer keeps the next run out (rc=17)" \
      || bad "an uninspectable reclaimer keeps the next run out" "rc=$RC $(cat "$C20a")"
    grep -q 'REFUSED-STATE state=CONTENDED ' "$C20a" \
      && ok "and the refusal says CONTENDED — a reclaim in progress, not a dead holder" \
      || bad "and the refusal says CONTENDED" "$(cat "$C20a")"
    [ -d "$TD20a/wl-reclaim-$UP2-1" ] \
      && ok "and that reclaimer's witness was PRESERVED, not cleared out of the way" \
      || bad "and that reclaimer's witness was preserved" "$TD20a/wl-reclaim-$UP2-1 is gone"
    [ -d "$TD20a" ] && [ "$(cat "$TD20a/pid")" = "$AP5" ] \
      && ok "and the lease it was reclaiming survived untouched" \
      || bad "and the lease survived untouched" "$TD20a changed or is gone"
  fi

  # (b) LIVE reclaimer, started BEFORE the contender so its pid is the lower of
  #     the two — which is the order that decides between two live reclaimers.
  LP2="$(live_pid)"
  TD20b="$(task_dir "$d" reclaimer-live)"
  fabricate_lease "$TD20b" "$AP5" dispatch reclaimer-live "$d" >/dev/null
  mkdir -p "$TD20b/wl-reclaim-$LP2-1"
  C20b="$SANDBOX_ROOT/c20b.out"
  contend "$LEASE_LIB" "$d" reclaimer-live probe 0 "$C20b" >/dev/null 2>&1; RC=$?
  [ "$RC" -eq 17 ] \
    && ok "a LIVE reclaimer that went first keeps the next run out (rc=17)" \
    || bad "a live reclaimer that went first keeps the next run out" "rc=$RC $(cat "$C20b")"
  [ -d "$TD20b/wl-reclaim-$LP2-1" ] \
    && ok "and its witness was preserved too" \
    || bad "and its witness was preserved" "$TD20b/wl-reclaim-$LP2-1 is gone"
  [ -d "$TD20b" ] \
    && ok "and the lease it was reclaiming was not renamed away underneath it" \
    || bad "and the lease was not renamed away underneath it" "$TD20b is gone"
  kill "$LP2" 2>/dev/null; wait "$LP2" 2>/dev/null
fi

# ================================================================= case 21
echo
echo "Case 21 — a reclaim claim left by ANOTHER run fails closed, across all three owner states"
# A `<lease>.reclaiming` directory says a reclaimer is part-way through this
# lease. Two things write one — the current helper, before its own destructive
# section, and an older build that used it as its only exclusion — so a
# repository upgraded mid-flight is covered by the same sub-cases as a live
# reclaim. Nothing here is fabricated by the helper: the marker is planted, so
# what is under test is the READING of it.
#
# The lease is left FREE in all three sub-cases on purpose. That is the exact
# window a reclaim opens — the reclaimer has renamed the stale lease away and
# not yet recreated it — and it is where ignoring the marker costs two winners
# rather than merely some residue. It is also what makes the sub-cases
# falsifying: against a build that ignores the marker, (a) and (b) acquire.
d="$(new_checkout)"
LP3="$(live_pid)"
UP3="$(uninspectable_pid)"
AP6="$(absent_pid)"

# (a) LIVE marker owner
TD21a="$(task_dir "$d" marker-live)"
mkdir -p "$TD21a.reclaiming" && printf '%s\n' "$LP3" >"$TD21a.reclaiming/pid"
C21a="$SANDBOX_ROOT/c21a.out"
contend "$LEASE_LIB" "$d" marker-live probe 0 "$C21a" >/dev/null 2>&1; RC=$?
[ "$RC" -eq 17 ] \
  && ok "(a) a LIVE marker owner refuses admission (rc=17), though the lease itself is free" \
  || bad "(a) a live marker owner refuses admission" "rc=$RC $(cat "$C21a")"
grep -q 'REFUSED-STATE state=CONTENDED ' "$C21a" \
  && ok "(a) and the refusal reads CONTENDED, naming a reclaim in progress" \
  || bad "(a) and the refusal reads CONTENDED" "$(cat "$C21a")"
[ -d "$TD21a.reclaiming" ] && [ "$(cat "$TD21a.reclaiming/pid")" = "$LP3" ] \
  && ok "(a) and the marker was PRESERVED byte-identical" \
  || bad "(a) and the marker was preserved" "$TD21a.reclaiming changed or is gone"
[ ! -d "$TD21a" ] \
  && ok "(a) and no lease was created behind the live reclaimer's back" \
  || bad "(a) and no lease was created" "$TD21a exists"
kill "$LP3" 2>/dev/null; wait "$LP3" 2>/dev/null

# (b) UNINSPECTABLE marker owner
if [ -z "$UP3" ]; then
  ok "SKIPPED (b) — this user cannot produce an uninspectable pid"
else
  TD21b="$(task_dir "$d" marker-unknown)"
  mkdir -p "$TD21b.reclaiming" && printf '%s\n' "$UP3" >"$TD21b.reclaiming/pid"
  C21b="$SANDBOX_ROOT/c21b.out"
  contend "$LEASE_LIB" "$d" marker-unknown probe 0 "$C21b" >/dev/null 2>&1; RC=$?
  [ "$RC" -eq 17 ] \
    && ok "(b) an UNINSPECTABLE marker owner refuses admission (rc=17)" \
    || bad "(b) an uninspectable marker owner refuses admission" "rc=$RC $(cat "$C21b")"
  [ -d "$TD21b.reclaiming" ] \
    && ok "(b) and the marker was preserved — unknown is held here too" \
    || bad "(b) and the marker was preserved" "$TD21b.reclaiming is gone"
  [ ! -d "$TD21b" ] \
    && ok "(b) and no lease was created" || bad "(b) and no lease was created" "$TD21b exists"
fi

# (c) ABSENT marker owner
if [ -z "$AP6" ]; then
  bad "setup (c) — a positively absent pid could be established" "kill -0 did not report 'no such process'"
else
  TD21c="$(task_dir "$d" marker-dead)"
  mkdir -p "$TD21c.reclaiming" && printf '%s\n' "$AP6" >"$TD21c.reclaiming/pid"
  C21c="$SANDBOX_ROOT/c21c.out"
  contend "$LEASE_LIB" "$d" marker-dead recoverer 0 "$C21c" >/dev/null 2>&1; RC=$?
  [ "$RC" -eq 0 ] \
    && ok "(c) an ABSENT marker owner permits recovery (rc=0) — it does not strand the task" \
    || bad "(c) an absent marker owner permits recovery" "rc=$RC $(cat "$C21c")"
  grep -q 'task_owned=1 checkout_owned=1' "$C21c" \
    && ok "(c) and the recovering run owns both resources" \
    || bad "(c) and the recovering run owns both resources" "$(cat "$C21c")"
  [ ! -e "$TD21c.reclaiming" ] \
    && ok "(c) and the dead marker was CLEANED UP, not left as residue" \
    || bad "(c) and the dead marker was cleaned up" "$TD21c.reclaiming survives"
  [ -z "$(find "$(dirname "$TD21c")" -maxdepth 1 -name '*.stale.*' 2>/dev/null)" ] \
    && ok "(c) and clearing it left no tombstone behind" \
    || bad "(c) and clearing it left no tombstone" \
        "$(find "$(dirname "$TD21c")" -maxdepth 1 -name '*.stale.*' 2>/dev/null)"
fi

# (d) A dead marker must not become a way for two runs to both proceed. Same
#     stale-lease race as case 17, with an old-format dead marker in the way.
if [ -n "$AP6" ]; then
  d="$(new_checkout)"
  AP7="$(absent_pid)"
  AP8="$(absent_pid)"
  if [ -z "$AP7" ] || [ -z "$AP8" ]; then
    bad "setup (d) — two positively absent pids" "kill -0 did not report 'no such process'"
  else
    TD21d="$(task_dir "$d" marker-dead-race)"
    fabricate_lease "$TD21d" "$AP7" dispatch marker-dead-race "$d" >/dev/null
    mkdir -p "$TD21d.reclaiming" && printf '%s\n' "$AP8" >"$TD21d.reclaiming/pid"
    BARRIER21="$SANDBOX_ROOT/barrier-21"; rm -f "$BARRIER21"
    pids=(); outs=()
    for i in $(seq 1 "$N"); do
      o="$SANDBOX_ROOT/marker-race-$i.out"; : >"$o"; outs+=("$o")
      contend "$LEASE_LIB" "$d" marker-dead-race "prog$i" 2 "$o" run "$BARRIER21" >/dev/null 2>&1 &
      pids+=($!)
    done
    sleep 1
    : >"$BARRIER21"
    for p in "${pids[@]}"; do wait "$p" 2>/dev/null; done
    acq=0; ref=0; other=0
    for o in "${outs[@]}"; do
      if   grep -q '^ACQUIRED' "$o"; then acq=$((acq+1))
      elif grep -q '^REFUSED'  "$o"; then ref=$((ref+1))
      else other=$((other+1)); fi
    done
    [ "$acq" -eq 1 ] \
      && ok "(d) with a dead marker AND a stale lease, exactly one of $N contenders proceeds (acquired=$acq)" \
      || bad "(d) exactly one contender proceeds" "acquired=$acq refused=$ref other=$other"
    [ "$other" -eq 0 ] \
      && ok "(d) and none ended in a state that is neither" \
      || bad "(d) and none ended in a state that is neither" "other=$other"
  fi
fi

# ================================================================= case 22
echo
echo "Case 22 — a LOWER-pid reclaimer that publishes AFTER a higher-pid scan still leaves one winner"
# Case 17 starts its contenders together and reports the winner count it happens
# to observe. That is a real race, and it is worth having — but it does not
# FORCE the one interleaving that breaks a scan-based arbitration, so a green
# case 17 says nothing about it. This case schedules that interleaving exactly:
#
#   H (higher pid) publishes its witness and scans — it is alone, so it proceeds
#   only THEN does L (lower pid) publish, scan, see only H, and proceed too,
#     because H does not outrank it
#   both re-read the same stale holder while neither has renamed
#   H renames, recreates, and records itself as the live holder
#   L renames H's LIVE lease away and records itself
#
# Two winners, from two individually correct decisions. Against the helper that
# scanned the witness set once and treated the result as permission that
# survived to its `mv`, BOTH processes return 0 here.
#
# HOW THE SCHEDULE IS FORCED. Each process shadows `mkdir` and `mv` with shell
# functions, which bash resolves before any PATH lookup, and the two rendezvous
# through files. The library under test is not modified, not copied and not
# read for its text — it is the shipped file, sourced, doing its real work with
# its real syscalls, paused at two named points. Nothing here sleeps and hopes.
RACER="$SANDBOX_ROOT/racer.sh"
cat >"$RACER" <<'RCR'
#!/bin/bash
set -uo pipefail
LIB="$1"; CO="$2"; TK="$3"; SYNC="$4"; OUT="$5"; SLOT="$6"
[ -r "$LIB" ] || { printf 'LIB-UNREADABLE %s\n' "$LIB" >"$OUT"; exit 70; }
# shellcheck disable=SC1090
. "$LIB" || { printf 'LIB-SOURCE-FAILED\n' >"$OUT"; exit 70; }
wl_lease_init "$CO" "$TK" || { printf 'INIT-FAIL\n' >"$OUT"; exit 71; }
command -v wl_lease__acquire_one >/dev/null 2>&1 \
  || { printf 'NO-ACQUIRE-ONE\n' >"$OUT"; exit 72; }
LEASE="$WL_LEASE_TASK_DIR"
WITPFX="${WL_LEASE_WITNESS_PREFIX-wl-reclaim-}"

# The roles are decided from the two REAL pids, once both are known. The
# schedule under test is defined by which reclaimer has the LOWER pid, and that
# is not something the harness can choose by starting one process first.
printf '%s\n' "$$" >"$SYNC/pid.$SLOT"
while [ ! -f "$SYNC/roles" ]; do sleep 0.01; done
if [ "$$" = "$(cat "$SYNC/roles")" ]; then ROLE=L; else ROLE=H; fi

# Bounded, so no interleaving can hang this harness. A wait that ends in a
# timeout is not a hidden pass: every outcome below is asserted from the two
# return codes and the surviving lease, never from whether a signal arrived.
await() { # timeout-tenths file...
  local n="$1" i=0 f; shift
  while :; do
    for f in "$@"; do [ -e "$f" ] && return 0; done
    i=$((i+1)); [ "$i" -gt "$n" ] && return 1
    sleep 0.1
  done
}

mkdir() {
  case "$*" in
    *"$WITPFX"*)
      # L publishes only after H has scanned. This one line IS the interleaving:
      # a set that is read by scanning cannot see a witness written after it.
      [ "$ROLE" = L ] && await 100 "$SYNC/H-at-rename"
      ;;
  esac
  command mkdir "$@"
}

mv() {
  case "${2:-}" in
    *.stale.*)
      if [ "$ROLE" = H ]; then
        # Hold the rename until L has either reached its own rename (the race is
        # open) or finished (the race is closed — L never gets a rename).
        : >"$SYNC/H-at-rename"
        await 100 "$SYNC/L-at-rename" "$SYNC/L-done"
      else
        : >"$SYNC/L-at-rename"
        await 100 "$SYNC/H-done"
      fi ;;
  esac
  command mv "$@"
}

wl_lease__acquire_one "$LEASE" "prog-$ROLE" "$$"; rc=$?
: >"$SYNC/$ROLE-done"
printf 'ROLE=%s pid=%s rc=%s holder=%s state=%s\n' \
  "$ROLE" "$$" "$rc" "$(cat "$LEASE/pid" 2>/dev/null)" \
  "${WL_LEASE_HOLDER_STATE-<unset>}" >"$OUT"
exit "$rc"
RCR
chmod +x "$RACER"

d="$(new_checkout)"
AP9="$(absent_pid)"
if [ -z "$AP9" ]; then
  bad "setup — a positively absent pid could be established" "kill -0 did not report 'no such process'"
else
  TD22="$(task_dir "$d" late-witness-race)"
  fabricate_lease "$TD22" "$AP9" dispatch late-witness-race "$d" \
    && ok "setup — one stale lease, pid $AP9, and two reclaimers on a forced schedule" \
    || bad "setup — one stale lease" "could not create $TD22"
  SYNC22="$SANDBOX_ROOT/sync-22"; rm -rf "$SYNC22"; mkdir -p "$SYNC22"
  O22A="$SANDBOX_ROOT/late-race-A.out"; : >"$O22A"
  O22B="$SANDBOX_ROOT/late-race-B.out"; : >"$O22B"
  bash "$RACER" "$LEASE_LIB" "$d" late-witness-race "$SYNC22" "$O22A" A >/dev/null 2>&1 &
  P22A=$!
  bash "$RACER" "$LEASE_LIB" "$d" late-witness-race "$SYNC22" "$O22B" B >/dev/null 2>&1 &
  P22B=$!
  W=0
  while { [ ! -f "$SYNC22/pid.A" ] || [ ! -f "$SYNC22/pid.B" ]; } && [ "$W" -lt 500 ]; do
    W=$((W+1)); sleep 0.02
  done
  PIDA="$(cat "$SYNC22/pid.A" 2>/dev/null)"; PIDB="$(cat "$SYNC22/pid.B" 2>/dev/null)"
  if [ -z "$PIDA" ] || [ -z "$PIDB" ]; then
    bad "setup — both reclaimers announced their pids" "A='$PIDA' B='$PIDB'"
    kill "$P22A" "$P22B" 2>/dev/null
  else
    if [ "$PIDA" -lt "$PIDB" ]; then printf '%s\n' "$PIDA" >"$SYNC22/roles"
    else printf '%s\n' "$PIDB" >"$SYNC22/roles"; fi
    ok "setup — roles fixed from the real pids (A=$PIDA B=$PIDB, lower goes second)"
  fi
  wait "$P22A" 2>/dev/null; R22A=$?
  wait "$P22B" 2>/dev/null; R22B=$?

  won=0
  [ "$R22A" -eq 0 ] && won=$((won+1))
  [ "$R22B" -eq 0 ] && won=$((won+1))
  [ "$won" -eq 1 ] \
    && ok "exactly one reclaimer succeeded on the forced late-witness schedule (rc A=$R22A B=$R22B)" \
    || bad "exactly one reclaimer succeeded on the forced late-witness schedule" \
        "rc A=$R22A B=$R22B | $(cat "$O22A") | $(cat "$O22B")"

  # The loser must be REFUSED, not merely non-zero: an infrastructure failure or
  # a crash would also read as "not two winners" and would prove nothing.
  loser_rc=2; [ "$R22A" -eq 0 ] && loser_rc="$R22B" || loser_rc="$R22A"
  [ "$loser_rc" -eq 2 ] \
    && ok "and the loser was REFUSED (rc=2), not failed some other way" \
    || bad "and the loser was refused (rc=2)" "loser rc=$loser_rc | $(cat "$O22A") | $(cat "$O22B")"
  { grep -q 'state=CONTENDED' "$O22A" || grep -q 'state=CONTENDED' "$O22B"; } \
    && ok "and its refusal reads CONTENDED — a reclaim in progress, not a dead holder" \
    || bad "and its refusal reads CONTENDED" "$(cat "$O22A") | $(cat "$O22B")"

  # The winner's lease must be the one that survives, intact. Two winners can
  # also leave exactly one directory standing — the second one's — so the pid
  # inside it is what separates "one winner" from "the last writer won".
  WINPID=''
  [ "$R22A" -eq 0 ] && WINPID="$PIDA"
  [ "$R22B" -eq 0 ] && WINPID="$PIDB"
  [ -d "$TD22" ] && [ "$(cat "$TD22/pid" 2>/dev/null)" = "$WINPID" ] \
    && ok "and the surviving lease records the winner's pid ($WINPID)" \
    || bad "and the surviving lease records the winner's pid" \
        "expected=$WINPID found=$(cat "$TD22/pid" 2>/dev/null) present=$([ -d "$TD22" ] && printf yes || printf no)"
  [ "$(cat "$TD22/task" 2>/dev/null)" = late-witness-race ] \
    && [ "$(cat "$TD22/checkout" 2>/dev/null)" = "$d" ] \
    && [ -n "$(cat "$TD22/program" 2>/dev/null)" ] \
    && ok "and the winner's lease carries complete holder metadata" \
    || bad "and the winner's lease carries complete holder metadata" \
        "task=$(cat "$TD22/task" 2>/dev/null) checkout=$(cat "$TD22/checkout" 2>/dev/null) program=$(cat "$TD22/program" 2>/dev/null)"

  ROOT22="$(dirname "$TD22")"
  LEFT22="$(find "$ROOT22" -mindepth 1 -maxdepth 1 ! -name '*.lock' 2>/dev/null)"
  [ -z "$LEFT22" ] \
    && ok "and the forced schedule left no tombstone, claim or other residue" \
    || bad "and the forced schedule left no residue" "$LEFT22"
  WIT22="$(find "$ROOT22" -mindepth 2 -maxdepth 2 -name 'wl-reclaim-*' 2>/dev/null)"
  [ -z "$WIT22" ] \
    && ok "and no reclaim witness survived inside the winner's lease" \
    || bad "and no reclaim witness survived inside the lease" "$WIT22"
fi

# ==================================================================== done
echo
echo "-----------------------------------------------"
printf 'pass=%d fail=%d  (library-level; no actor and no transport involved)\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] || exit 1
