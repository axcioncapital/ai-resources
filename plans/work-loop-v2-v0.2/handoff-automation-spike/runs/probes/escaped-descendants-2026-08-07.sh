#!/bin/bash
# Probe — Phase 1a, escaped descendants: which handle actually reaches one, and
# does the dispatcher's stop leave the tree running?
#
# Two halves, because they answer different questions:
#   Part A — MECHANISM. Which of SIX candidate handles reaches which of FOUR
#            escape shapes, measured on this host rather than reasoned from man
#            pages. It ends with the measurement that decides Phase 1a: whether
#            the one handle that reaches a fully-detached daemon can be used at
#            all, or whether it also reaches processes the dispatcher does not
#            own.
#   Part B — EFFECT. The real dispatcher is launched, given an escaping actor,
#            and stopped. What is observed is the post-stop PROCESS STATE — not
#            which signal the dispatcher says it sent. It includes the detached
#            daemon (which must survive, and is why 1a stays open) and an
#            unrelated `tail -f` on the hop log (which must survive, and is why
#            the public log was replaced by a private marker).
#
# REVISED 2026-08-07, second round. The first round measured four handles against
# three shapes and concluded the residual was "closes both inherited
# descriptors". That was too narrow twice over: the dispatcher now opens a
# PRIVATE marker descriptor, so closing 0/1/2 no longer escapes it, and the
# handle that does reach the remaining shape was never measured for over-reach.
# Both gaps are closed here.
#
# Simulated transport, real OS processes. The actor is supplied through
# --actor-cmd, so this is NOT live product transport; every process it observes
# is nonetheless a real Darwin process.
#
# Self-cleaning: every process it starts is killed on the way out, including on
# failure, because a probe for escaped descendants must not leave one behind.
#
# Usage:  bash escaped-descendants-2026-08-07.sh
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SPIKE="$(cd "$HERE/../.." && pwd)"
DISPATCH="${DISPATCH_BIN:-$SPIKE/dispatch.sh}"
TMP="$(mktemp -d "${TMPDIR:-/tmp}/wl2-escape-probe.XXXXXX")"
TRACKED=""

track() { TRACKED="$TRACKED $*"; }
cleanup() {
  local p f
  for f in "$TMP"/*.pid; do
    [ -f "$f" ] || continue
    p="$(cat "$f" 2>/dev/null)"; [ -n "$p" ] && kill -KILL "$p" 2>/dev/null
  done
  for p in $TRACKED; do kill -KILL "$p" 2>/dev/null; done
  rm -rf "$TMP"
}
trap cleanup EXIT

alive() { [ -n "${1:-}" ] && kill -0 "$1" 2>/dev/null; }
verdict() { if alive "$1"; then printf 'ALIVE'; else printf 'GONE'; fi; }

echo "=================================================================="
echo " Phase 1a probe — escaped descendants"
echo " date:       $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo " host:       $(uname -srm)"
echo " macOS:      $(sw_vers -productVersion 2>/dev/null) ($(sw_vers -buildVersion 2>/dev/null))"
echo " dispatcher: $DISPATCH"
echo " sha256:     $(shasum -a 256 "$DISPATCH" | cut -d' ' -f1)"
echo " python3:    $(command -v python3 || echo '<absent>')"
echo " lsof:       $(command -v lsof || echo '<absent>')"
echo "=================================================================="
echo

command -v python3 >/dev/null 2>&1 || { echo "ABORT: python3 is required to create the escape shapes"; exit 2; }

# ------------------------------------------------------------------ Part A
echo "### PART A — which handle reaches which escape shape?"
echo
echo "FOUR descendant shapes are started under one parent, which is itself a"
echo "process-group leader, with stdout/stderr redirected to a file exactly as"
echo "the dispatcher redirects a hop, and with a PRIVATE MARKER file on fd 9"
echo "exactly as the dispatcher now opens one per hop."
echo
echo "The fourth shape is the one that decides Phase 1a: a conventional daemon"
echo "that double-forks, leaves the session, and then CLOSES EVERY inherited"
echo "descriptor. It keeps the working directory it inherited, which is the only"
echo "thing left that still links it to the actor."
echo

OUTFILE="$TMP/hop.out"; : >"$OUTFILE"
MARKER="$TMP/hop.tree"; : >"$MARKER"
CWDDIR="$TMP/cwd"; mkdir -p "$CWDDIR"
export WLPROBE_ENVTAG="wl2-escape-probe-$$"

PARENT_SH='
cd "'"$CWDDIR"'"
( sleep 120 ) & echo $! > "'"$TMP"'/ingroup.pid"
python3 -c "
import os,sys,time
os.setsid()
with open(sys.argv[1],\"w\") as f: f.write(str(os.getpid()))
time.sleep(120)
" "'"$TMP"'/setsid.pid" &
python3 -c "
import os,sys
if os.fork() > 0: os._exit(0)
os.setsid()
if os.fork() > 0: os._exit(0)
with open(sys.argv[1],\"w\") as f: f.write(str(os.getpid()))
os.execv(\"/bin/sleep\", [\"sleep\",\"120\"])
" "'"$TMP"'/orphan.pid" &
python3 -c "
import os,sys
if os.fork() > 0: os._exit(0)
os.setsid()
if os.fork() > 0: os._exit(0)
# the pid is written BEFORE the descriptors go, because writing it needs one
with open(sys.argv[1],\"w\") as f: f.write(str(os.getpid()))
os.closerange(0, 1024)
os.execv(\"/bin/sleep\", [\"sleep\",\"120\"])
" "'"$TMP"'/daemon.pid" &
echo $$ > "'"$TMP"'/parent.pid"
sleep 120'

set -m
exec 9>"$MARKER"
env "WLPROBE_TAG=$WLPROBE_ENVTAG" bash -c "$PARENT_SH" >>"$OUTFILE" 2>&1 &
PARENT=$!
exec 9>&-
set +m
track "$PARENT"

for _ in $(seq 1 60); do
  [ -s "$TMP/setsid.pid" ] && [ -s "$TMP/orphan.pid" ] && [ -s "$TMP/ingroup.pid" ] \
    && [ -s "$TMP/daemon.pid" ] && break
  sleep 0.25
done
sleep 1
IN="$(cat "$TMP/ingroup.pid" 2>/dev/null)"
SS="$(cat "$TMP/setsid.pid" 2>/dev/null)"
OR="$(cat "$TMP/orphan.pid" 2>/dev/null)"
DM="$(cat "$TMP/daemon.pid" 2>/dev/null)"
PPGID="$(ps -o pgid= -p "$PARENT" 2>/dev/null | tr -d ' ')"

echo "parent pid=$PARENT pgid=$PPGID"
ps -o pid,ppid,pgid -p "$PARENT" -p "$IN" -p "$SS" -p "$OR" -p "$DM" 2>&1
echo
echo "  in-group child      = $IN"
echo "  setsid, parented    = $SS   (ppid $(ps -o ppid= -p "$SS" 2>/dev/null | tr -d ' '), own pgid $(ps -o pgid= -p "$SS" 2>/dev/null | tr -d ' '))"
echo "  double-fork orphan  = $OR   (ppid $(ps -o ppid= -p "$OR" 2>/dev/null | tr -d ' '), own pgid $(ps -o pgid= -p "$OR" 2>/dev/null | tr -d ' '), exec'd /bin/sleep)"
echo "  detached daemon     = $DM   (ppid $(ps -o ppid= -p "$DM" 2>/dev/null | tr -d ' '), own pgid $(ps -o pgid= -p "$DM" 2>/dev/null | tr -d ' '), closerange(0,1024) then exec'd /bin/sleep)"
echo
echo "  open descriptors held by the daemon: [$(lsof -p "$DM" -a -d 0-1024 -Fn 2>/dev/null | tr '\n' ' ')]"
echo

# handle 1 — process group membership
GRP=" $(ps -ax -o pid=,pgid= 2>/dev/null | awk -v g="$PPGID" '$2==g{print $1}' | tr '\n' ' ')"
# handle 2 — recursive ancestry walk
census_ppid() {
  local out="" frontier="$1" next kid c seen=" $1 "
  while [ -n "$frontier" ]; do
    next=""
    for kid in $frontier; do
      for c in $(pgrep -P "$kid" 2>/dev/null); do
        case "$seen" in *" $c "*) continue ;; esac
        seen="$seen$c "; next="$next $c"; out="$out $c"
      done
    done
    frontier="$next"
  done
  printf '%s ' "$out"
}
ANC="$(census_ppid "$PARENT")"
# handle 3 — environment tag
ENVT=" $(ps -Eww -ax -o pid=,command= 2>/dev/null | grep "$WLPROBE_ENVTAG" | grep -v ' grep ' | awk '{print $1}' | tr '\n' ' ')"
# handle 4 — inherited descriptor on the PUBLIC hop output file. This is the one
#            the first round shipped, and the one finding 3 rejected: an operator
#            may `tail -f` this file, so holding it is not evidence of descent.
FDH=" $(lsof -t -- "$OUTFILE" 2>/dev/null | tr '\n' ' ')"
# handle 5 — inherited descriptor on the PRIVATE per-hop marker. Nothing but the
#            actor's tree has a reason to hold this file. This is what the
#            dispatcher uses now.
MKH=" $(lsof -t -- "$MARKER" 2>/dev/null | tr '\n' ' ')"
# handle 6 — inherited working directory. The last link the detached daemon keeps.
CWH=" $(lsof -t -a -d cwd -- "$CWDDIR" 2>/dev/null | tr '\n' ' ')"

reach() { case "$1" in *" $2 "*) printf 'reaches' ;; *) printf 'MISSES ' ;; esac; }

printf '%-34s %-10s %-10s %-10s %-10s\n' "handle" "in-group" "setsid" "orphan" "daemon"
printf '%-34s %-10s %-10s %-10s %-10s\n' "----------------------------------" "----------" "----------" "----------" "----------"
printf '%-34s %-10s %-10s %-10s %-10s\n' "1 process group"         "$(reach "$GRP" "$IN")"  "$(reach "$GRP" "$SS")"  "$(reach "$GRP" "$OR")"  "$(reach "$GRP" "$DM")"
printf '%-34s %-10s %-10s %-10s %-10s\n' "2 recursive PPID walk"   "$(reach "$ANC" "$IN")"  "$(reach "$ANC" "$SS")"  "$(reach "$ANC" "$OR")"  "$(reach "$ANC" "$DM")"
printf '%-34s %-10s %-10s %-10s %-10s\n' "3 environment tag"       "$(reach "$ENVT" "$IN")" "$(reach "$ENVT" "$SS")" "$(reach "$ENVT" "$OR")" "$(reach "$ENVT" "$DM")"
printf '%-34s %-10s %-10s %-10s %-10s\n' "4 inherited fd, hop log" "$(reach "$FDH" "$IN")"  "$(reach "$FDH" "$SS")"  "$(reach "$FDH" "$OR")"  "$(reach "$FDH" "$DM")"
printf '%-34s %-10s %-10s %-10s %-10s\n' "5 inherited fd, MARKER"  "$(reach "$MKH" "$IN")"  "$(reach "$MKH" "$SS")"  "$(reach "$MKH" "$OR")"  "$(reach "$MKH" "$DM")"
printf '%-34s %-10s %-10s %-10s %-10s\n' "6 inherited cwd"         "$(reach "$CWH" "$IN")"  "$(reach "$CWH" "$SS")"  "$(reach "$CWH" "$OR")"  "$(reach "$CWH" "$DM")"
echo
echo "  raw: group=[$GRP] ancestry=[$ANC] envtag=[$ENVT]"
echo "       hoplog=[$FDH] marker=[$MKH] cwd=[$CWH]"
echo

# ---------------------------------------------------------------------------
# THE DECIDING MEASUREMENT FOR PHASE 1a.
#
# Handle 6 is the only one that reaches the detached daemon. The question is
# whether it can be used, and the answer is measured here rather than argued: an
# UNRELATED process is parked in the same directory, holding nothing of the
# actor's. If handle 6 lists it, then the only handle broad enough to catch the
# daemon is also broad enough to kill a bystander — which is precisely the defect
# finding 3 rejected. Findings 1 and 3 then bound the outcome from both sides.
echo "-- can handle 6 be used? an UNRELATED process sits in the same directory --"
( cd "$CWDDIR" && exec sleep 60 ) &
BYST=$!; track "$BYST"; sleep 1
CWH2=" $(lsof -t -a -d cwd -- "$CWDDIR" 2>/dev/null | tr '\n' ' ')"
echo "   unrelated bystander pid   = $BYST (never touched the actor, the hop log or the marker)"
echo "   handle 6 now returns        [$CWH2]"
case "$CWH2" in
  *" $BYST "*) echo "   VERDICT: handle 6 REACHES THE BYSTANDER — unusable as a kill list." ;;
  *)           echo "   VERDICT: handle 6 did not list the bystander." ;;
esac
case "$CWH2" in
  *" $DM "*) echo "            and it still reaches the daemon, so the over-reach is not incidental." ;;
esac
kill -KILL "$BYST" 2>/dev/null
echo

echo "-- why handle 3 misses what it misses: SIP-protected platform binaries --"
for b in /bin/sleep /bin/bash "$(command -v python3)"; do
  env "WLPROBE_TAG=$WLPROBE_ENVTAG" "$b" -c 'import time;time.sleep(20)' >/dev/null 2>&1 &
  bp=$!; track "$bp"; sleep 0.6
  if ps -Eww -o command= -p "$bp" 2>/dev/null | grep -q "$WLPROBE_ENVTAG"; then r="env READABLE"; else r="env NOT readable"; fi
  printf '   %-62s %s\n' "$b" "$r"
  kill -KILL "$bp" 2>/dev/null
done
echo

echo "-- handle rejected on availability: kqueue NOTE_TRACK --"
python3 - <<'PY'
import os, select, sys
try:
    kq = select.kqueue()
    pid = os.fork()
    if pid == 0:
        import time; time.sleep(3); os._exit(0)
    try:
        kq.control([select.kevent(pid, filter=select.KQ_FILTER_PROC,
                    flags=select.KQ_EV_ADD | select.KQ_EV_ENABLE,
                    fflags=select.KQ_NOTE_EXIT | select.KQ_NOTE_FORK | select.KQ_NOTE_TRACK)], 0, 0)
        print("   NOTE_TRACK: registered (available)")
    except OSError as e:
        print(f"   NOTE_TRACK: UNAVAILABLE — {e}")
    os.kill(pid, 9); os.waitpid(pid, 0)
except Exception as e:
    print("   NOTE_TRACK: could not be tested —", e)
PY
kill -KILL "$PARENT" 2>/dev/null
for p in "$IN" "$SS" "$OR" "$DM"; do kill -KILL "$p" 2>/dev/null; done
sleep 1
echo
echo "  Part A processes cleaned: in-group=$(verdict "$IN") setsid=$(verdict "$SS") orphan=$(verdict "$OR") daemon=$(verdict "$DM")"
echo

# ------------------------------------------------------------------ Part B
echo
echo "### PART B — the real dispatcher's stop, observed as process state"
echo

CO="$TMP/checkout"
mkdir -p "$CO/logs/work-loop"
git -C "$CO" init -q
git -C "$CO" config user.email probe@example.invalid
git -C "$CO" config user.name probe
cat >"$CO/logs/work-loop/escape-probe.md" <<'EOF'
---
task: escape-probe
turn: claude
---

## Objective and scope
Probe fixture. No real work.

## Lane and unit
Standard. Unit 1 — probe fixture.

## Latest result
Not started.

## Blocker
None.

## Next action
Probe fixture.
EOF
git -C "$CO" add -A >/dev/null 2>&1
git -C "$CO" commit -qm "probe fixture" >/dev/null 2>&1

# The actor spawns THREE escape shapes. The setsid one IGNORES SIGTERM so the
# SIGKILL half of the escalation is exercised rather than described. The third is
# the detached daemon of Part A — the shape the dispatcher is now known not to
# reach — so Part B measures the limit in effect, not only in principle.
ACTOR='python3 -c "
import os,sys,signal,time
os.setsid()
signal.signal(signal.SIGTERM, signal.SIG_IGN)
with open(\"'"$TMP"'/b_setsid.pid\",\"w\") as f: f.write(str(os.getpid()))
time.sleep(300)
" &
python3 -c "
import os,sys
if os.fork() > 0: os._exit(0)
os.setsid()
if os.fork() > 0: os._exit(0)
with open(\"'"$TMP"'/b_orphan.pid\",\"w\") as f: f.write(str(os.getpid()))
os.execv(\"/bin/sleep\", [\"sleep\",\"300\"])
" &
python3 -c "
import os,sys
if os.fork() > 0: os._exit(0)
os.setsid()
if os.fork() > 0: os._exit(0)
with open(\"'"$TMP"'/b_daemon.pid\",\"w\") as f: f.write(str(os.getpid()))
os.closerange(0, 1024)
os.execv(\"/bin/sleep\", [\"sleep\",\"300\"])
" &
echo $$ > "'"$TMP"'/b_actor.pid"
sleep 300'

bash "$DISPATCH" --checkout "$CO" --task escape-probe --log-dir "$CO/runs" \
  --timeout 300 --actor-cmd "$ACTOR" >"$TMP/b.out" 2>&1 &
DISP=$!
track "$DISP"
for _ in $(seq 1 60); do
  [ -s "$TMP/b_setsid.pid" ] && [ -s "$TMP/b_orphan.pid" ] && [ -s "$TMP/b_daemon.pid" ] && break
  sleep 0.25
done
sleep 1
BA="$(cat "$TMP/b_actor.pid" 2>/dev/null)"
BS="$(cat "$TMP/b_setsid.pid" 2>/dev/null)"
BO="$(cat "$TMP/b_orphan.pid" 2>/dev/null)"
BD="$(cat "$TMP/b_daemon.pid" 2>/dev/null)"
LOCK="${TMPDIR:-/tmp}/work-loop-dispatch-$(printf '%s|%s' "$(cd "$CO" && pwd -P)" "escape-probe" | shasum -a 256 | cut -c1-16).lock"

# The bystander finding 3 is about. An operator watching the hop log is the
# ordinary case, not a contrived one, and the first round killed exactly this.
HOPLOG="$(ls "$CO"/runs/*.out 2>/dev/null | head -1)"
BYST2=""
if [ -n "$HOPLOG" ]; then
  tail -f "$HOPLOG" >/dev/null 2>&1 &
  BYST2=$!; track "$BYST2"; sleep 1
fi

echo "=== BEFORE the stop ==="
echo "dispatcher=$DISP actor=$BA setsid-escapee=$BS orphan-escapee=$BO daemon=$BD"
echo "unrelated operator tail -f on the hop log = ${BYST2:-<none>}  (log: ${HOPLOG:-<none>})"
ps -o pid,ppid,pgid,command -p "$DISP" -p "$BA" -p "$BS" -p "$BO" -p "$BD" 2>&1 | cut -c1-100
echo "actor=$(verdict "$BA") setsid=$(verdict "$BS") orphan=$(verdict "$BO") daemon=$(verdict "$BD")  lock present: $([ -d "$LOCK" ] && echo yes || echo no)"
echo
echo "=== sending SIGTERM to the dispatcher ($DISP), and to nothing else ==="
kill -TERM "$DISP" 2>/dev/null
for t in 3 8 13; do
  sleep $(( t == 3 ? 3 : 5 ))
  echo "  +${t}s  dispatcher=$(verdict "$DISP") actor=$(verdict "$BA") setsid=$(verdict "$BS") orphan=$(verdict "$BO") daemon=$(verdict "$BD")  lock: $([ -d "$LOCK" ] && echo held || echo released)"
done
wait "$DISP" 2>/dev/null; DRC=$?
echo
echo "=== AFTER: effective post-stop process state ==="
echo "  dispatcher exit code : $DRC   (28 = INTERRUPTED)"
echo "  actor                : $(verdict "$BA")"
echo "  setsid escapee       : $(verdict "$BS")   <- survived every group-only teardown before this unit"
echo "  double-fork orphan   : $(verdict "$BO")   <- reachable by NO ancestry link"
echo "  DETACHED DAEMON      : $(verdict "$BD")   <- THE RESIDUAL: 1a is not closed while this is ALIVE"
echo "  unrelated tail -f    : $(verdict "$BYST2")   <- finding 3: must be ALIVE; the first round killed it"
echo "  lock                 : $([ -d "$LOCK" ] && echo 'STILL HELD (pinned)' || echo 'released')"
echo "  pinned?              : $([ -f "$LOCK/survivors" ] && echo 'yes — survivors file present' || echo 'no')"
echo "  pids holding the PRIVATE marker: [$(lsof -t -- "$CO"/runs/*.tree 2>/dev/null | tr '\n' ' ')]"
echo "  pids holding the PUBLIC hop log: [$(lsof -t -- "$CO"/runs/*.out 2>/dev/null | tr '\n' ' ')]  <- a bystander here is NOT a descendant"
echo
echo "=== what the dispatcher SAID (for comparison with the state above) ==="
grep -E "STOP \[|terminating|teardown|PINNED" "$TMP/b.out" | sed 's/^/  /'
echo
[ -n "$BYST2" ] && kill -KILL "$BYST2" 2>/dev/null
kill -KILL "$BD" 2>/dev/null
rm -rf "$LOCK" 2>/dev/null
echo "probe complete"
