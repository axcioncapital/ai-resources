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

# ==================================================================== done
echo
echo "-----------------------------------------------"
printf 'pass=%d fail=%d  (library-level; no actor and no transport involved)\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] || exit 1
