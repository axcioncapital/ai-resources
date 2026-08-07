#!/bin/bash
# Probe — Phase 1a, escaped descendants: which handle actually reaches one, and
# does the dispatcher's stop leave the tree running?
#
# Two halves, because they answer different questions:
#   Part A — MECHANISM. Which of four candidate handles reaches which escape
#            shape, measured on this host rather than reasoned from man pages.
#   Part B — EFFECT. The real dispatcher is launched, given an escaping actor,
#            and stopped. What is observed is the post-stop PROCESS STATE — not
#            which signal the dispatcher says it sent.
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
echo "Three descendant shapes are started under one parent, which is itself a"
echo "process-group leader, with stdout/stderr redirected to a file exactly as"
echo "the dispatcher redirects a hop."
echo

OUTFILE="$TMP/hop.out"; : >"$OUTFILE"
export WLPROBE_ENVTAG="wl2-escape-probe-$$"

PARENT_SH='
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
echo $$ > "'"$TMP"'/parent.pid"
sleep 120'

set -m
env "WLPROBE_TAG=$WLPROBE_ENVTAG" bash -c "$PARENT_SH" >>"$OUTFILE" 2>&1 &
PARENT=$!
set +m
track "$PARENT"

for _ in $(seq 1 60); do
  [ -s "$TMP/setsid.pid" ] && [ -s "$TMP/orphan.pid" ] && [ -s "$TMP/ingroup.pid" ] && break
  sleep 0.25
done
sleep 1
IN="$(cat "$TMP/ingroup.pid" 2>/dev/null)"
SS="$(cat "$TMP/setsid.pid" 2>/dev/null)"
OR="$(cat "$TMP/orphan.pid" 2>/dev/null)"
PPGID="$(ps -o pgid= -p "$PARENT" 2>/dev/null | tr -d ' ')"

echo "parent pid=$PARENT pgid=$PPGID"
ps -o pid,ppid,pgid -p "$PARENT" -p "$IN" -p "$SS" -p "$OR" 2>&1
echo
echo "  in-group child      = $IN"
echo "  setsid, parented    = $SS   (ppid $(ps -o ppid= -p "$SS" 2>/dev/null | tr -d ' '), own pgid $(ps -o pgid= -p "$SS" 2>/dev/null | tr -d ' '))"
echo "  double-fork orphan  = $OR   (ppid $(ps -o ppid= -p "$OR" 2>/dev/null | tr -d ' '), own pgid $(ps -o pgid= -p "$OR" 2>/dev/null | tr -d ' '), exec'd /bin/sleep)"
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
# handle 4 — inherited descriptor on the hop output file
FDH=" $(lsof -t -- "$OUTFILE" 2>/dev/null | tr '\n' ' ')"

reach() { case "$1" in *" $2 "*) printf 'reaches' ;; *) printf 'MISSES ' ;; esac; }

printf '%-32s %-12s %-12s %-12s\n' "handle" "in-group" "setsid" "orphan"
printf '%-32s %-12s %-12s %-12s\n' "--------------------------------" "------------" "------------" "------------"
printf '%-32s %-12s %-12s %-12s\n' "1 process group"       "$(reach "$GRP" "$IN")"  "$(reach "$GRP" "$SS")"  "$(reach "$GRP" "$OR")"
printf '%-32s %-12s %-12s %-12s\n' "2 recursive PPID walk" "$(reach "$ANC" "$IN")"  "$(reach "$ANC" "$SS")"  "$(reach "$ANC" "$OR")"
printf '%-32s %-12s %-12s %-12s\n' "3 environment tag"     "$(reach "$ENVT" "$IN")" "$(reach "$ENVT" "$SS")" "$(reach "$ENVT" "$OR")"
printf '%-32s %-12s %-12s %-12s\n' "4 inherited fd (lsof)" "$(reach "$FDH" "$IN")"  "$(reach "$FDH" "$SS")"  "$(reach "$FDH" "$OR")"
echo
echo "  raw: group=[$GRP] ancestry=[$ANC] envtag=[$ENVT] fd=[$FDH]"
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
for p in "$IN" "$SS" "$OR"; do kill -KILL "$p" 2>/dev/null; done
sleep 1
echo
echo "  Part A processes cleaned: in-group=$(verdict "$IN") setsid=$(verdict "$SS") orphan=$(verdict "$OR")"
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

# The actor spawns both escape shapes, and the setsid one IGNORES SIGTERM so the
# SIGKILL half of the escalation is exercised rather than described.
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
echo $$ > "'"$TMP"'/b_actor.pid"
sleep 300'

bash "$DISPATCH" --checkout "$CO" --task escape-probe --log-dir "$CO/runs" \
  --timeout 300 --actor-cmd "$ACTOR" >"$TMP/b.out" 2>&1 &
DISP=$!
track "$DISP"
for _ in $(seq 1 60); do
  [ -s "$TMP/b_setsid.pid" ] && [ -s "$TMP/b_orphan.pid" ] && break
  sleep 0.25
done
sleep 1
BA="$(cat "$TMP/b_actor.pid" 2>/dev/null)"
BS="$(cat "$TMP/b_setsid.pid" 2>/dev/null)"
BO="$(cat "$TMP/b_orphan.pid" 2>/dev/null)"
LOCK="${TMPDIR:-/tmp}/work-loop-dispatch-$(printf '%s|%s' "$(cd "$CO" && pwd -P)" "escape-probe" | shasum -a 256 | cut -c1-16).lock"

echo "=== BEFORE the stop ==="
echo "dispatcher=$DISP actor=$BA setsid-escapee=$BS orphan-escapee=$BO"
ps -o pid,ppid,pgid,command -p "$DISP" -p "$BA" -p "$BS" -p "$BO" 2>&1 | cut -c1-100
echo "actor=$(verdict "$BA") setsid=$(verdict "$BS") orphan=$(verdict "$BO")  lock present: $([ -d "$LOCK" ] && echo yes || echo no)"
echo
echo "=== sending SIGTERM to the dispatcher ($DISP), and to nothing else ==="
kill -TERM "$DISP" 2>/dev/null
for t in 3 8 13; do
  sleep $(( t == 3 ? 3 : 5 ))
  echo "  +${t}s  dispatcher=$(verdict "$DISP") actor=$(verdict "$BA") setsid-escapee=$(verdict "$BS") orphan-escapee=$(verdict "$BO")  lock: $([ -d "$LOCK" ] && echo held || echo released)"
done
wait "$DISP" 2>/dev/null; DRC=$?
echo
echo "=== AFTER: effective post-stop process state ==="
echo "  dispatcher exit code : $DRC   (28 = INTERRUPTED)"
echo "  actor                : $(verdict "$BA")"
echo "  setsid escapee       : $(verdict "$BS")   <- survived every group-only teardown before this unit"
echo "  double-fork orphan   : $(verdict "$BO")   <- reachable by NO ancestry link"
echo "  lock                 : $([ -d "$LOCK" ] && echo 'STILL HELD' || echo 'released')"
echo "  any pid still holding the hop output file: [$(lsof -t -- "$CO"/runs/*.out 2>/dev/null | tr '\n' ' ')]"
echo
echo "=== what the dispatcher SAID (for comparison with the state above) ==="
grep -E "STOP \[|terminating|teardown" "$TMP/b.out" | sed 's/^/  /'
echo
rm -rf "$LOCK" 2>/dev/null
echo "probe complete"
