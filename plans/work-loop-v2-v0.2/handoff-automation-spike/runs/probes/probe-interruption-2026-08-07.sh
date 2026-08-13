#!/bin/bash
# Phase 1a probe — does SIGTERM actually stop a dispatcher run?
#
# The plan (v0.2 § 1a) marks its claim INFERRED and says the first task is
# confirmation, not repair. This script confirms by execution.
#
# Observes four things the analysis could not settle by reading:
#   1. is the dispatcher process still alive after SIGTERM?
#   2. is the actor (the --actor-cmd child) still alive?
#   3. are the actor's DESCENDANTS still alive?  <-- explicitly unsettled in the plan
#   4. is the lock released, i.e. can a second dispatcher start on the same task?

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DISPATCH="${DISPATCH_BIN:-$1}"
ROOT="$(mktemp -d "${TMPDIR:-/tmp}/wl2-probe1a.XXXXXX")"
trap 'rm -rf "$ROOT"' EXIT

echo "probe root: $ROOT"
echo "dispatcher: $DISPATCH"
echo

# --------------------------------------------------------------- sandbox
d="$ROOT/co"
mkdir -p "$d/logs/work-loop"
git -C "$d" init -q 2>/dev/null || { git init -q "$d"; }
git -C "$d" config user.email probe@example.invalid
git -C "$d" config user.name probe
printf 'sandbox\n' >"$d/README.md"
git -C "$d" add README.md; git -C "$d" commit -qm base >/dev/null

cat >"$d/logs/work-loop/probe-task.md" <<'EOF'
---
task: probe-task
turn: claude
---

## Objective and scope
Probe fixture. No real work.

## Blocker
None.

## Next action
Nothing real depends on this file.
EOF
git -C "$d" add logs/work-loop/probe-task.md
git -C "$d" commit -qm fixture >/dev/null

# The simulated actor: spawn a grandchild, then sleep a long time.
# The grandchild is what settles observation 3.
ACTOR='
  ( sleep 600 ) &
  echo "$!" > "'"$ROOT"'/grandchild.pid"
  echo $$ > "'"$ROOT"'/actor.pid"
  sleep 600
'

# --------------------------------------------------------------- launch
bash "$DISPATCH" --checkout "$d" --task probe-task \
  --log-dir "$ROOT/runs" --timeout 600 --max-hops 4 \
  --actor-cmd "$ACTOR" >"$ROOT/dispatch.out" 2>&1 &
DPID=$!
echo "dispatcher pid: $DPID"

# wait for the actor to be genuinely running
for _ in $(seq 1 40); do
  [ -f "$ROOT/grandchild.pid" ] && break
  sleep 0.5
done
sleep 1

APID="$(cat "$ROOT/actor.pid" 2>/dev/null)"
GPID="$(cat "$ROOT/grandchild.pid" 2>/dev/null)"
echo "actor pid: ${APID:-<none>}   grandchild pid: ${GPID:-<none>}"

if [ -z "$APID" ]; then
  echo "ABORT: the actor never started; probe is inconclusive."
  cat "$ROOT/dispatch.out"
  exit 1
fi

LOCK_KEY="$(printf '%s|%s' "$(cd "$d" && pwd -P)" "probe-task" | shasum -a 256 | cut -c1-16)"
LOCK_DIR="${TMPDIR:-/tmp}/work-loop-dispatch-$LOCK_KEY.lock"
echo "lock dir: $LOCK_DIR (present before signal: $([ -d "$LOCK_DIR" ] && echo yes || echo no))"
echo

# --------------------------------------------------------------- signal
echo "=== sending SIGTERM to the dispatcher ($DPID) ==="
kill -TERM "$DPID" 2>/dev/null
sleep 3

alive() { kill -0 "$1" 2>/dev/null && echo ALIVE || echo gone; }

echo
echo "--- 3 seconds after SIGTERM ---"
echo "  dispatcher $DPID   : $(alive "$DPID")"
echo "  actor      $APID   : $(alive "$APID")"
echo "  grandchild $GPID   : $(alive "$GPID")"
echo "  lock dir           : $([ -d "$LOCK_DIR" ] && echo HELD || echo released)"

echo
echo "--- can a second dispatcher start on the same checkout+task? ---"
bash "$DISPATCH" --checkout "$d" --task probe-task \
  --log-dir "$ROOT/runs2" --dry-run >"$ROOT/second.out" 2>&1
SRC=$?
if [ "$SRC" -eq 17 ]; then
  echo "  no — exit 17 LOCK_HELD (the lock still protects the task)"
else
  echo "  YES — exit $SRC. A second dispatcher was admitted while the first is $(alive "$DPID")."
  echo "  ---- second dispatcher output ----"
  sed 's/^/  /' "$ROOT/second.out"
fi

sleep 5
echo
echo "--- 8 seconds after SIGTERM ---"
echo "  dispatcher $DPID   : $(alive "$DPID")"
echo "  actor      $APID   : $(alive "$APID")"
echo "  grandchild $GPID   : $(alive "$GPID")"

echo
echo "--- dispatcher output so far ---"
sed 's/^/  /' "$ROOT/dispatch.out"

# --------------------------------------------------------------- cleanup
kill -KILL "$DPID" "$APID" "$GPID" 2>/dev/null
rm -rf "$LOCK_DIR" 2>/dev/null
wait 2>/dev/null
echo
echo "probe complete."
