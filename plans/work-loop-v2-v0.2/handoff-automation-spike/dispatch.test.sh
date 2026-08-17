#!/bin/bash
# Focused failing-case harness for the Work Loop v2 handoff dispatcher spike.
#
# Every case here is SIMULATED: actors are replaced by --actor-cmd, so this
# harness proves controller logic only. It deliberately cannot prove live
# product transport — that is a separate, explicitly-labelled live run.
#
# ONE EXCEPTION TO "replaced by --actor-cmd", and it is not a relaxation. The
# cross-transport cases (12e) launch the ATTENDED CARRIER as well, and
# carry-turn.sh REFUSES --actor-cmd, --simulate and --fake-actor outright
# (carry-turn.sh 316-317). Its sanctioned test route is a stub binary passed
# with --claude-bin, which is how carry-turn.test.sh works. So those cases are
# still controller evidence with no real model involved — the seam is a
# different one because the other program's boundary says it must be.
#
# Case 0 is the harness's own falsifiability proof: it points the suite at an
# ABSENT dispatcher and asserts the suite fails. A harness that stays green with
# the thing under test removed is not evidence.
#
# Usage:  bash dispatch.test.sh
#         DISPATCH_BIN=/path/to/dispatch.sh bash dispatch.test.sh

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DISPATCH_BIN="${DISPATCH_BIN:-$HERE/dispatch.sh}"
# handoff-automation-spike -> work-loop-v2-v0.2 -> plans -> checkout root
REPO_ROOT="${REPO_ROOT:-$(cd "$HERE/../../.." && pwd)}"
OWNER_BIN="${OWNER_BIN:-$REPO_ROOT/logs/scripts/work-loop-owner.sh}"
# The shared live-lease library. Sourced by the dispatcher out of the CHECKOUT it
# drives — the same resolution the ownership helper uses — so every sandbox has
# to carry it for the same reason every sandbox carries the ownership helper.
LEASE_BIN="${LEASE_BIN:-$REPO_ROOT/logs/scripts/work-loop-lease.sh}"
# The canonical state validator. Since the Tracer 3 cutover the dispatcher asks it
# for the state's classification instead of reading `turn:` and the body headings
# itself, and fail-closes at exit 13 when it is absent. A sandbox without it is
# not modelling a real checkout.
STATE_BIN="${STATE_BIN:-$REPO_ROOT/logs/scripts/work-loop-state.sh}"

PASS=0; FAIL=0
SANDBOX_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/wl2-dispatch-test.XXXXXX")"
trap 'rm -rf "$SANDBOX_ROOT"' EXIT

ok()   { PASS=$((PASS+1)); printf '  PASS  %s\n' "$1"; }
bad()  { FAIL=$((FAIL+1)); printf '  FAIL  %s\n' "$1"; [ -n "${2:-}" ] && printf '        %s\n' "$2"; }

# ---------------------------------------------------------------- fixtures

# Writes a record that satisfies the contract work-loop-state.sh enforces:
# explicit `status`, one of the four legal status/turn pairs, and that pair's body
# shape. Before the Tracer 3 cutover this wrote a status-free record with the OPEN
# body for every turn, `operator` included — which the validator rejects, and
# rightly: a closing record is not an open record with the turn changed. Status is
# derived from the turn unless the caller states it.
state_file() { # dir task turn [declared-task] [status]
  local dir="$1" task="$2" turn="$3" declared="${4:-$2}" status="${5:-}" blocker
  if [ -z "$status" ]; then
    case "$turn" in
      codex|claude) status=active ;;
      operator)     status=closed ;;
    esac
  fi
  if [ "$status" = closed ]; then
    cat >"$dir/logs/work-loop/$task.md" <<EOF
---
task: $declared
status: closed
turn: operator
---

## Outcome
Sandbox fixture for the dispatcher harness. Closed record.

## Decisions that matter
Nothing real depends on this file.

## Evidence
Harness fixture — no commit.

## Accepted limitations
None.
EOF
    if git -C "$dir" rev-parse --git-dir >/dev/null 2>&1; then
      git -C "$dir" add "logs/work-loop/$task.md" >/dev/null 2>&1
      git -C "$dir" commit -qm "fixture: $task" >/dev/null 2>&1
    fi
    return 0
  fi
  blocker='None.'
  [ "$status" = blocked ] && blocker='Waiting on the operator to decide the fixture question.'
  cat >"$dir/logs/work-loop/$task.md" <<EOF
---
task: $declared
status: $status
turn: $turn
---

## Objective and scope
Sandbox fixture for the dispatcher harness. No real work.

## Lane and unit
Standard. Unit 1 — harness fixture.

## Latest result
Not started.

## Blocker
$blocker

## Next action
Harness fixture. Nothing real depends on this file.
EOF
  # Fixtures are committed, so "the state file is uncommitted" means what it
  # means in the live repo rather than being true of every fixture by default.
  if git -C "$dir" rev-parse --git-dir >/dev/null 2>&1; then
    git -C "$dir" add "logs/work-loop/$task.md" >/dev/null 2>&1
    git -C "$dir" commit -qm "fixture: $task" >/dev/null 2>&1
  fi
}

new_sandbox() { # -> path on stdout
  local d; d="$(mktemp -d "$SANDBOX_ROOT/co.XXXXXX")"
  mkdir -p "$d/logs/work-loop" "$d/logs/scripts" \
           "$d/plans/work-loop-v2-v0.2/handoff-automation-spike"
  git -C "$d" init -q
  git -C "$d" config user.email harness@example.invalid
  git -C "$d" config user.name  harness
  printf 'sandbox\n' >"$d/README.md"
  printf 'unrelated tracked file\n' >"$d/other.txt"
  # The ownership helper ships inside a real checkout, and admission now FAILS
  # CLOSED without it, so every sandbox must carry it or it is not modelling a
  # real checkout. Tracked, not dropped in loose, or the dispatcher would
  # correctly read it as an out-of-allowlist foreign file. Case 12d removes it
  # deliberately — that is the fail-closed case, and it must be the only one.
  cp "$OWNER_BIN" "$d/logs/scripts/work-loop-owner.sh" 2>/dev/null || true
  # Same argument for the lease library, and the same single exception: case 12f
  # removes it deliberately, and that must be the only case without it.
  cp "$LEASE_BIN" "$d/logs/scripts/work-loop-lease.sh" 2>/dev/null || true
  # And the validator, for the same reason and with the same single-exception rule.
  cp "$STATE_BIN" "$d/logs/scripts/work-loop-state.sh" 2>/dev/null || true
  git -C "$d" add README.md other.txt logs/scripts 2>/dev/null
  git -C "$d" commit -qm "sandbox base"

  # The decoys. These mirror the live folder: files that advertise a turn and
  # would be picked up by any glob-and-guess dispatcher.
  state_file "$d" "decoy-alpha"   "codex"
  state_file "$d" "decoy-beta"    "claude"
  state_file "$d" "decoy-mismatch" "claude" "some-other-task"
  printf '%s' "$d"
}

# A simulated Claude commits the state file, because the real one does (core § 4).
# Appended to the actors below so the well-behaved cases are not tripped by the
# uncommitted-handback guard, which case 13 exercises on its own.
# `|| true` because these ping-pong actors sometimes flip the turn back to the
# committed value, leaving nothing to stage. That is a fixture artifact, not a
# failed commit — the dispatcher still sees a clean state file either way.
COMMIT_IF_CLAUDE='; if [ "$WL_ACTOR" = "claude" ]; then
        git -C "$WL_CHECKOUT" add "logs/work-loop/$WL_TASK.md" >/dev/null 2>&1;
        git -C "$WL_CHECKOUT" commit -qm "actor commit" >/dev/null 2>&1 || true; fi'

# Records which task an actor was invoked for, then flips the turn.
#
# ADDRESSED BY PATTERN, NOT BY LINE NUMBER. These actors used to rewrite line 3,
# which was `turn:` only because the frontmatter happened to be exactly two keys.
# The canonical contract adds `status:`, so line 3 is now `status:` and a
# position-addressed actor would corrupt the lifecycle instead of flipping the
# turn — silently, and in every case at once.
FLIP_BODY='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls";
      t=$(sed -n "/^turn: /{p;q;}" "$WL_STATE_FILE");
      case "$t" in
        "turn: codex")  n="turn: claude" ;;
        "turn: claude") n="turn: codex"  ;;
        *) n="$t" ;;
      esac;
      awk -v n="$n" "/^turn: /&&!done{print n; done=1; next}{print}" "$WL_STATE_FILE" > "$WL_STATE_FILE.tmp";
      mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"'

FLIP="$FLIP_BODY$COMMIT_IF_CLAUDE"

# Handing a record to the operator is a LIFECYCLE change, not just a turn change:
# the canonical contract has no active/operator pair, so an actor that rewrote
# only `turn:` would leave a record no consumer may act on. A real Claude closing
# write reduces the file to the closing record, and so does this one.
FLIP_TO_OPERATOR='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls";
      d=$(sed -n "s/^task: //p" "$WL_STATE_FILE" | head -1);
      printf -- "---\ntask: %s\nstatus: closed\nturn: operator\n---\n\n## Outcome\nHanded to the operator by the fixture actor.\n\n## Decisions that matter\nNothing real depends on this file.\n\n## Evidence\nHarness fixture.\n\n## Accepted limitations\nNone.\n" "$d" > "$WL_STATE_FILE.tmp";
      mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"'"$COMMIT_IF_CLAUDE"

NOOP='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls"; exit 0'

# The lease locations, mirrored from logs/scripts/work-loop-lease.sh — the shared
# library BOTH transports now source (dispatch.sh 671-697, carry-turn.sh 679-706).
# They moved out of ${TMPDIR} and into the repository's Git common directory, and
# the one composite checkout|task key became two independent leases — see the
# "lease" block in dispatch.sh for why. Defined ONCE here, above every user: six
# copies of the old expression had drifted into the suite, and each was a place
# this change could have been missed.
#
# Mirrored rather than imported, deliberately. Sourcing the library to assert the
# library's own output would make every assertion below true by construction: the
# oracle would move whenever the thing it checks moved. The mirror is the whole
# point, and it carries the matching hazard — if this and the two launchers ever
# disagree, the assertions pass against a directory neither launcher writes. Case
# 12e's controls are what catch that: each one requires the OTHER side to have
# really launched, which a phantom lease path cannot produce.
lock_root_for() { # checkout -> lock root dir
  local c g
  c="$(cd "$1" && pwd -P)"
  g="$(git -C "$c" rev-parse --git-common-dir 2>/dev/null)"
  case "$g" in /*) ;; *) g="$c/$g" ;; esac
  printf '%s/work-loop-dispatch-locks' "$(cd "$g" && pwd -P)"
}
task_lock_for() { # checkout task -> task lock dir
  printf '%s/task-%s.lock' "$(lock_root_for "$1")" \
    "$(printf '%s' "$2" | shasum -a 256 | cut -c1-16)"
}
checkout_lock_for() { # checkout -> checkout lock dir
  local c; c="$(cd "$1" && pwd -P)"
  printf '%s/checkout-%s.lock' "$(lock_root_for "$1")" \
    "$(printf '%s' "$c" | shasum -a 256 | cut -c1-16)"
}

# ------------------------------------------------------- the OTHER transport
# The attended carrier. Cross-transport contention cannot be proven by planting
# a lock directory: what is under test is precisely whether one program's code
# OBSERVES the lease the other program's code takes, so both sides are launched
# for real and each takes its own lease through its own acquire path.
CARRY_BIN="${CARRY_BIN:-$REPO_ROOT/scripts/axcion-harness-v0.2/carry-turn.sh}"

# THERE IS NO SEPARATE CARRIER ORACLE, and its absence is the point of this
# change. The carrier used to key ONE lock on the canonical checkout path under
# the caller's ${TMPDIR}; it now canonicalizes --checkout (carry-turn.sh 408) and
# hands it to wl_lease_init (696), exactly as the dispatcher does (503, 685). One
# derivation, so one mirror: task_lock_for and checkout_lock_for above answer for
# BOTH transports. A second carrier-shaped helper here would be the drift the
# shared library exists to remove.
#
# The carrier also still READS the old ${TMPDIR} lock for one release
# (legacy_lock_check, carry-turn.sh 724-741). That path is a refusal-only
# compatibility read, never a lease this suite plants or observes, so nothing
# below derives it.

# A stub `claude` for the carrier. It answers --version, because the carrier
# probes it before every launch; it records each REAL launch, which is what the
# "nothing was launched" assertions read; and it then does what a Claude hop
# does — move the turn and commit it (core § 4).
#
# The count is the load-bearing part. An exit code alone cannot separate "the
# lease refused this run" from "the run failed for some other reason", so every
# case below asserts the exit code AND that the actor never started.
make_carry_stub() { # path count-file state-file hold-secs
  cat >"$1" <<'STUB'
#!/bin/bash
COUNT="__COUNT__"; STATE="__STATE__"; HOLD="__HOLD__"
for a in "$@"; do [ "$a" = "--version" ] && { echo "carry-stub 0.0.1"; exit 0; }; done
printf 'x' >>"$COUNT"
[ "$HOLD" -gt 0 ] && sleep "$HOLD"
REPO="$(cd "$(dirname "$STATE")/../.." && pwd -P)"
awk '/^turn: /&&!d{print "turn: codex"; d=1; next}{print}' "$STATE" >"$STATE.tmp" && mv "$STATE.tmp" "$STATE"
printf '\ncarrier stub ran\n' >>"$STATE"
git -C "$REPO" add -- "logs/work-loop/$(basename "$STATE")" >/dev/null 2>&1
git -C "$REPO" commit -qm "carrier stub: handed on" >/dev/null 2>&1
printf '{"type":"result","subtype":"success","is_error":false,"result":"done","permission_denials":[]}\n'
exit 0
STUB
  sed -e "s|__COUNT__|$2|" -e "s|__STATE__|$3|" -e "s|__HOLD__|$4|" "$1" >"$1.tmp"
  mv "$1.tmp" "$1"
  chmod +x "$1"
}

carry_calls() { # count-file -> number of real carrier actor launches
  [ -f "$1" ] && wc -c <"$1" | tr -d ' ' || printf '0'
}

# The carrier's default allowlist is ^logs/work-loop/ and ^logs/harness-runs/.
# A dispatcher sharing the checkout writes its run log to runs/, which is
# outside that set, so an unwidened carrier would stop at 18 FOREIGN_UNSTAGED —
# a refusal that has nothing to do with a lease. Widening it here keeps the
# thing being measured the thing under test. The carrier's own run log goes
# OUTSIDE the checkout for the mirror-image reason: logs/harness-runs/ is not in
# the DISPATCHER's allowlist.
CARRY_ALLOW=(--allow-path '^logs/work-loop/' --allow-path '^runs/')

run_dispatch() { # sandbox task [extra args...] -> writes $OUT, sets $RC
  local d="$1" t="$2"; shift 2
  OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task "$t" \
        --log-dir "$d/runs" --timeout 20 "$@" 2>&1)"
  RC=$?
}

calls() { # sandbox -> number of actor invocations
  [ -f "$1.calls" ] && wc -l <"$1.calls" | tr -d ' ' || printf '0'
}

# Every file in a checkout's WORKING TREE, with its hash. `.git` is pruned, and
# that prune is the claim being made rather than a convenience: the shared lease
# root lives inside the Git common directory, so a refusal that writes its
# evidence there writes NOTHING a checkout's working tree can see. A manifest
# that included `.git` could not tell that apart from a refusal scribbling in the
# operator's files, which is the distinction case 12h exists to draw.
#
# Content, not mtime: a file rewritten with identical bytes is not a change the
# operator would ever have to reconcile, and a timestamp comparison would report
# one. Paths are included so the diff on failure names what moved.
tree_manifest() { # checkout -> "<sha>  <relative path>" per line, sorted
  ( cd "$1" 2>/dev/null || return 1
    find . -path ./.git -prune -o -type f -print 2>/dev/null | LC_ALL=C sort |
      while IFS= read -r f; do
        printf '%s  %s\n' "$(shasum -a 256 "$f" 2>/dev/null | cut -d' ' -f1)" "$f"
      done )
}

expect_rc() { # want got label [detail]
  if [ "$2" -eq "$1" ]; then ok "$3"; else bad "$3" "expected exit $1, got $2 — ${4:-}"; fi
}

# Substring assertions over a captured refusal, for the holder-identity checks
# below. `case` rather than `grep`: one of the phrases under test contains
# parentheses, which grep would read as pattern syntax rather than as text.
#
# The NEGATIVE half is the load-bearing one. "an attended carry holds task X"
# also contains no "a dispatcher", but a message that named both would
# satisfy the positive assertion alone while still telling the operator to go
# looking for the wrong process.
out_has()   { # needle out label
  case "$2" in *"$1"*) ok "$3" ;; *) bad "$3" "expected to contain: $1 — got: $2" ;; esac
}
out_lacks() { # needle out label
  case "$2" in *"$1"*) bad "$3" "expected NOT to contain: $1 — got: $2" ;; *) ok "$3" ;; esac
}

# Exactly one occurrence of FLAG in a recorded argv, immediately followed by
# VALUE on the next line. Two separate `grep -Fqx` calls would pass on an argv
# that carried the flag and the value in unrelated positions — which is not the
# same claim as "the pair was passed". The count is part of it: a flag repeated
# with a different value is a policy the log line cannot describe.
argv_pair() { # argv-file flag value
  local f="$1" flag="$2" value="$3" n
  n="$(grep -Fxc -- "$flag" "$f" 2>/dev/null || printf '0')"
  [ "$n" = "1" ] || return 1
  grep -A1 -Fx -- "$flag" "$f" | tail -1 | grep -Fqx -- "$value"
}

# ================================================================== case 0
echo
echo "Case 0 — harness falsifiability (dispatcher absent)"
d="$(new_sandbox)"; state_file "$d" "live-task" "codex"
ABSENT="$SANDBOX_ROOT/no-such-dispatcher.sh"
OUT="$(DISPATCH_BIN="$ABSENT" bash "$ABSENT" --checkout "$d" --task live-task 2>&1)"; RC=$?
if [ "$RC" -eq 0 ]; then
  bad "suite fails when the dispatcher is absent" "an absent dispatcher exited 0 — the harness cannot detect its own subject"
else
  ok "suite fails when the dispatcher is absent (exit $RC)"
fi
if [ ! -x "$DISPATCH_BIN" ] && [ ! -f "$DISPATCH_BIN" ]; then
  bad "dispatcher under test exists at $DISPATCH_BIN"
  echo; echo "ABORT: nothing to test."; exit 1
else
  ok "dispatcher under test exists at $DISPATCH_BIN"
fi

# ================================================================== case 1
echo
echo "Case 1 — exact-task routing; decoys are never selected"
d="$(new_sandbox)"; state_file "$d" "live-task" "codex"
run_dispatch "$d" live-task --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 0 "$RC" "reaches turn: operator and exits 0" "$OUT"
if [ "$(calls "$d")" = "1" ] && grep -qx "live-task" "$d.calls"; then
  ok "exactly one actor call, for the named task"
else
  bad "exactly one actor call, for the named task" "calls=$(calls "$d") content=$(cat "$d.calls" 2>/dev/null)"
fi
untouched=1
for decoy in decoy-alpha decoy-beta decoy-mismatch; do
  grep -q "^turn: \(codex\|claude\)$" "$d/logs/work-loop/$decoy.md" || untouched=0
done
[ "$untouched" -eq 1 ] && ok "all three decoy files still hold their original turn" \
                       || bad "all three decoy files still hold their original turn"

# ================================================================== case 2
echo
echo "Case 2 — filename / frontmatter identity mismatch is rejected read-only"
d="$(new_sandbox)"
before="$(shasum -a 256 "$d/logs/work-loop/decoy-mismatch.md" | cut -d' ' -f1)"
run_dispatch "$d" decoy-mismatch --actor-cmd "$FLIP"
expect_rc 14 "$RC" "exits 14 on identity mismatch" "$OUT"
after="$(shasum -a 256 "$d/logs/work-loop/decoy-mismatch.md" | cut -d' ' -f1)"
[ "$before" = "$after" ] && ok "the mismatched file is byte-identical afterwards" \
                         || bad "the mismatched file is byte-identical afterwards"
[ "$(calls "$d")" = "0" ] && ok "no actor was launched" || bad "no actor was launched" "calls=$(calls "$d")"

# ================================================================== case 3
echo
echo "Case 3 — path traversal in the task id"
d="$(new_sandbox)"
run_dispatch "$d" "../../etc/passwd" --actor-cmd "$FLIP"
expect_rc 12 "$RC" "exits 12 on a traversal task id" "$OUT"
run_dispatch "$d" "live task" --actor-cmd "$FLIP"
expect_rc 12 "$RC" "exits 12 on an illegal-character task id" "$OUT"

# ================================================================== case 4
echo
echo "Case 4 — missing and malformed state"
d="$(new_sandbox)"
run_dispatch "$d" no-such-task --actor-cmd "$FLIP"
expect_rc 13 "$RC" "exits 13 when the state file is missing" "$OUT"
d="$(new_sandbox)"; state_file "$d" "bad-turn" "robot"
run_dispatch "$d" bad-turn --actor-cmd "$FLIP"
expect_rc 15 "$RC" "exits 15 on an out-of-domain turn: value" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "no actor launched for malformed state" || bad "no actor launched for malformed state"

# ================================================================== case 5
echo
echo "Case 5 — turn: operator is terminal"
d="$(new_sandbox)"; state_file "$d" "op-task" "operator"
run_dispatch "$d" op-task --actor-cmd "$FLIP"
expect_rc 0 "$RC" "exits 0 on turn: operator" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "zero model launches for an operator stop" || bad "zero model launches for an operator stop" "calls=$(calls "$d")"

# ================================================================== case 6
echo
echo "Case 6 — an actor that changes nothing stops the loop once"
d="$(new_sandbox)"; state_file "$d" "noop-task" "codex"
run_dispatch "$d" noop-task --actor-cmd "$NOOP"
expect_rc 22 "$RC" "exits 22 on no observable transition" "$OUT"
[ "$(calls "$d")" = "1" ] && ok "the no-op actor was launched exactly once, not repeatedly" \
                          || bad "the no-op actor was launched exactly once" "calls=$(calls "$d")"

# ================================================================== case 7
echo
echo "Case 7 — actor failure and actor timeout"
d="$(new_sandbox)"; state_file "$d" "fail-task" "codex"
run_dispatch "$d" fail-task --actor-cmd 'exit 3'
expect_rc 20 "$RC" "exits 20 when the actor exits non-zero" "$OUT"
d="$(new_sandbox)"; state_file "$d" "slow-task" "codex"
t0="$(date '+%s')"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task slow-task --log-dir "$d/runs" \
       --timeout 3 --actor-cmd 'sleep 60' 2>&1)"; RC=$?
took=$(( $(date '+%s') - t0 ))
expect_rc 21 "$RC" "exits 21 when the actor exceeds the timeout" "$OUT"
# Regression for the drift the 2026-08-05 live run exposed: the deadline used to
# count poll iterations, so real elapsed time ran well past --timeout. 3s
# requested + 2s TERM->KILL grace; anything at or beyond 20s means it is
# counting loops again rather than the clock.
if [ "$took" -lt 20 ]; then
  ok "the timeout fired on wall-clock time (${took}s for a 3s deadline)"
else
  bad "the timeout fired on wall-clock time" "took ${took}s for a 3s deadline — the deadline is drifting"
fi

# ================================================================== case 8
echo
echo "Case 8 — hop limit"
d="$(new_sandbox)"; state_file "$d" "ping-task" "codex"
run_dispatch "$d" ping-task --max-hops 2 --actor-cmd "$FLIP"
expect_rc 23 "$RC" "exits 23 at the hop limit" "$OUT"
[ "$(calls "$d")" = "2" ] && ok "stopped after exactly 2 launches" || bad "stopped after exactly 2 launches" "calls=$(calls "$d")"

echo
echo "Case 8b — a post-launch hop-limit stop reports the last hop's partial effect"
d="$(new_sandbox)"; state_file "$d" "limit-effects-task" "codex"
run_dispatch "$d" limit-effects-task --max-hops 1 --actor-cmd "$FLIP"
expect_rc 23 "$RC" "exits 23 after the single allowed launch" "$OUT"
printf '%s' "$OUT" | grep -q "PARTIAL FILE EFFECTS — since launch" \
  && ok "the post-launch hop-limit stop carries partial effects" \
  || bad "the post-launch hop-limit stop carries partial effects" "$OUT"
printf '%s' "$OUT" | sed -n '/PARTIAL FILE EFFECTS/,$p' | grep -Fq "logs/work-loop/limit-effects-task.md" \
  && ok "the Codex handoff left by the launched hop is named" \
  || bad "the Codex handoff left by the launched hop is named" "$OUT"

# ================================================================== case 9
echo
echo "Case 9 — foreign staged state stops the spike"
d="$(new_sandbox)"; state_file "$d" "staged-task" "codex"
printf 'foreign edit\n' >>"$d/other.txt"
git -C "$d" add other.txt
run_dispatch "$d" staged-task --actor-cmd "$FLIP"
expect_rc 16 "$RC" "exits 16 when something is already staged" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "no actor launched over foreign staged state" || bad "no actor launched over foreign staged state"

# ================================================================= case 10
echo
echo "Case 10 — unexpected repository effects"
d="$(new_sandbox)"; state_file "$d" "head-task" "codex"
MOVE_HEAD="$FLIP"'; printf "x\n" >> "$WL_CHECKOUT/other.txt";
      git -C "$WL_CHECKOUT" add other.txt; git -C "$WL_CHECKOUT" commit -qm "codex should never do this"'
run_dispatch "$d" head-task --actor-cmd "$MOVE_HEAD"
expect_rc 24 "$RC" "exits 24 when the Codex actor moves HEAD" "$OUT"

d="$(new_sandbox)"; state_file "$d" "stray-task" "codex"
STRAY="$FLIP"'; printf "stray\n" > "$WL_CHECKOUT/stray-file.txt"'
run_dispatch "$d" stray-task --actor-cmd "$STRAY"
expect_rc 24 "$RC" "exits 24 when an actor writes outside the allowlist" "$OUT"

# ================================================================= case 11
echo
echo "Case 11 — a simulated round trip runs unattended and ends at operator"
d="$(new_sandbox)"; state_file "$d" "trip-task" "codex"
TRIP='printf "%s:%s\n" "$WL_HOP" "$WL_ACTOR" >> "$WL_CHECKOUT.calls";
      if [ "$WL_HOP" -ge 3 ]; then
        d=$(sed -n "s/^task: //p" "$WL_STATE_FILE" | head -1);
        printf -- "---\ntask: %s\nstatus: closed\nturn: operator\n---\n\n## Outcome\nRound trip finished.\n\n## Decisions that matter\nNothing real depends on this file.\n\n## Evidence\nHarness fixture.\n\n## Accepted limitations\nNone.\n" "$d" > "$WL_STATE_FILE.tmp";
      else
        if [ "$WL_ACTOR" = "codex" ]; then n="turn: claude"; else n="turn: codex"; fi;
        awk -v n="$n" "/^turn: /&&!d{print n; d=1; next}{print}" "$WL_STATE_FILE" > "$WL_STATE_FILE.tmp";
      fi;
      mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"'"$COMMIT_IF_CLAUDE"
run_dispatch "$d" trip-task --max-hops 6 --actor-cmd "$TRIP"
expect_rc 0 "$RC" "codex -> claude -> codex -> operator completes and exits 0" "$OUT"
if [ "$(tr '\n' ' ' <"$d.calls")" = "1:codex 2:claude 3:codex " ]; then
  ok "the actor sequence was exactly codex, claude, codex"
else
  bad "the actor sequence was exactly codex, claude, codex" "got: $(tr '\n' ' ' <"$d.calls")"
fi
grep -q '^turn: operator$' "$d/logs/work-loop/trip-task.md" && ok "the file ends at turn: operator" \
                                                            || bad "the file ends at turn: operator"

# ================================================================= case 12
echo
echo "Case 12 — a second dispatcher on the same checkout/task is refused"
d="$(new_sandbox)"; state_file "$d" "lock-task" "codex"
( bash "$DISPATCH_BIN" --checkout "$d" --task lock-task --log-dir "$d/runs" \
    --timeout 30 --actor-cmd 'sleep 6; exit 0' >/dev/null 2>&1 ) &
outer=$!
sleep 2
run_dispatch "$d" lock-task --actor-cmd "$FLIP"
expect_rc 17 "$RC" "exits 17 while another dispatcher holds the task" "$OUT"
# The DISPATCHER-HELD control for the holder-identity assertions in 12e. Those
# check that a carrier-held lease is not reported as a dispatcher; this checks
# the other direction, that reading the holder did not lose the case it was
# already getting right. Without it, a refusal that said "an attended carry"
# unconditionally would pass 12e and be just as wrong.
out_has 'a dispatcher holds task lock-task' "$OUT" \
  "  and the TASK refusal names a dispatcher, because a dispatcher holds it"

# Case 12b/12c — the two halves the composite ${TMPDIR} key could not enforce.
# Both are exercised against the SAME live holder above, so they measure real
# contention rather than a hand-placed lock directory.
#
# 12b: the caller's TMPDIR is not part of the answer any more. Two dispatchers
# launched with different TMPDIR roots used to compute one key under two parents
# and never contend at all.
OUT="$(TMPDIR="$SANDBOX_ROOT/elsewhere-$$" bash "$DISPATCH_BIN" --checkout "$d" \
        --task lock-task --log-dir "$d/runs" --dry-run 2>&1)"; RC=$?
expect_rc 17 "$RC" "exits 17 even when the second caller's TMPDIR differs" "$OUT"

# 12c: a DIFFERENT task in the SAME checkout. Two tasks sharing one working tree
# and index is how either sweeps the other's paths into a commit, and the old
# key — which included the task — let both in.
state_file "$d" "lock-other" "codex"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task lock-other \
        --log-dir "$d/runs" --dry-run 2>&1)"; RC=$?
expect_rc 17 "$RC" "exits 17 for a DIFFERENT task in the same checkout" "$OUT"
case "$OUT" in
  *lock-task*) ok "the checkout refusal names the task already running there" ;;
  *)           bad "the checkout refusal names the task already running there" "$OUT" ;;
esac
# The CHECKOUT half of the same control.
out_has 'a dispatcher is already running in this checkout' "$OUT" \
  "the checkout refusal names a dispatcher, because a dispatcher holds it"

wait "$outer" 2>/dev/null

# Both locks are released once the holder exits — otherwise the exclusion above
# would be indistinguishable from a leak.
[ -d "$(task_lock_for "$d" lock-task)" ] \
  && bad "the task lock is released after the run" "still held" \
  || ok "the task lock is released after the run"
[ -d "$(checkout_lock_for "$d")" ] \
  && bad "the checkout lock is released after the run" "still held" \
  || ok "the checkout lock is released after the run"

# The lock root is inside the repository, not under a caller-controlled TMPDIR.
# That is what makes the exclusion above hold across sessions with different
# environments — the property, not the path, is the claim.
LR="$(lock_root_for "$d")"
case "$LR" in
  "$(cd "$d" && pwd -P)"/.git/*) ok "the lock root lives in the Git common directory" ;;
  *) bad "the lock root lives in the Git common directory" "got $LR" ;;
esac

# ---------------------------------------------------------------- case 12d
# Ownership admission FAILS CLOSED. This used to print "ownership: SKIPPED" and
# launch anyway, which is the same outcome as a passing check for anyone reading
# the exit code — and it applied to exactly the checkouts most likely to hold a
# conflicting writer. The two sub-cases are the two ways the check can fail to
# run: the helper is absent, and the helper is present but broken.
echo
echo "case 12d — admission fails closed when the ownership check cannot run"
d="$(new_sandbox)"
state_file "$d" "fc-task" "codex"

# The measurement that makes this more than an exit-code assertion: no actor may
# be invoked. run_dispatch's actors append to "$d.calls".
rm -f "$d.calls"
git -C "$d" rm -q --cached logs/scripts/work-loop-owner.sh >/dev/null 2>&1
rm -f "$d/logs/scripts/work-loop-owner.sh"
git -C "$d" commit -qm "remove the ownership helper" >/dev/null 2>&1
BEFORE="$(git -C "$d" rev-parse HEAD)"
run_dispatch "$d" fc-task --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 35 "$RC" "an ABSENT ownership helper refuses with exit 35" "$OUT"
case "$OUT" in
  *"ownership check is unavailable"*) ok "the refusal says the check could not run" ;;
  *) bad "the refusal says the check could not run" "$OUT" ;;
esac
[ -s "$d.calls" ] && bad "no actor was launched with the check unavailable" \
                         "actors ran: $(tr '\n' ';' <"$d.calls")" \
                      || ok "no actor was launched with the check unavailable"
[ "$(git -C "$d" rev-parse HEAD)" = "$BEFORE" ] \
  && ok "no commit was made with the check unavailable" \
  || bad "no commit was made with the check unavailable"

# The control. Same fixture recipe, same command, helper PRESENT — it must
# proceed and must launch. Without it, case 12d would pass just as well for a
# dispatcher that refuses everything, which is not the behaviour claimed.
#
# It gets its own sandbox on purpose. Reusing the one above would make the
# control depend on the refused run having left the task untouched — which is
# the very thing under test, so a broken dispatcher would fail the control for
# the wrong reason and the evidence would no longer separate the two facts.
dc="$(new_sandbox)"
state_file "$dc" "fc-task" "codex"
rm -f "$dc.calls"
run_dispatch "$dc" fc-task --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 0 "$RC" "control — with the helper present the same run proceeds" "$OUT"
[ -s "$dc.calls" ] && ok "control — the actor did run once the check was available" \
                   || bad "control — the actor did run once the check was available" "no calls"

# Present but unusable is the same fact as absent: the check did not run.
d="$(new_sandbox)"
state_file "$d" "fc-broken" "codex"
printf '#!/bin/bash\nexit 99\n' >"$d/logs/scripts/work-loop-owner.sh"
git -C "$d" add logs/scripts/work-loop-owner.sh >/dev/null 2>&1
git -C "$d" commit -qm "break the ownership helper" >/dev/null 2>&1
rm -f "$d.calls"
run_dispatch "$d" fc-broken --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 35 "$RC" "a BROKEN ownership helper refuses with exit 35 too" "$OUT"
[ -s "$d.calls" ] && bad "no actor was launched with a broken check" \
                         "actors ran: $(tr '\n' ';' <"$d.calls")" \
                      || ok "no actor was launched with a broken check"

# ---------------------------------------------------------------- case 12e
# CROSS-TRANSPORT CONTENTION — the attended carrier against the unattended
# dispatcher. These four were written FAILING FIRST against the pre-shared-lease
# code, and the failure each recorded was UNSAFE ADMISSION — the second program
# launched an actor while the first was live in the same working tree, or on the
# same logical task in another one.
#
# WHY THEY FAILED THEN, and it was an inference from two absences rather than
# from the presence of two locks. dispatch.sh rooted its two leases in the Git
# common directory; carry-turn.sh keyed a single lease under the caller's
# ${TMPDIR}. Neither source read the other's path. Each program was internally
# correct and jointly blind, which is also why this is the contention least
# likely to be noticed: both programs reported a clean single-writer run.
#
# WHAT HOLDS NOW: both transports resolve their leases through the one shared
# library (see the mirror block above), so the second program refuses with 17 and
# launches nothing. That is asserted rather than asserted-in-a-comment, so these
# turn green by behaviour and not by being rewritten — the expected exit codes,
# launch counts and HEAD checks below are unchanged from the failing version.
#
# The setup assertions moved with the code, and only the setup assertions. They
# used to observe a carrier-shaped ${TMPDIR} lock that no longer exists; they now
# observe the shared lease the carrier actually takes. An oracle pointing at a
# directory nobody writes is the one way these cases could go green while proving
# nothing, so each is paired with a control that requires a REAL launch.
#
# The four are the two acquisition directions across the two resources:
#   12e-1  carrier holds a CHECKOUT   -> dispatcher on another task refused
#   12e-2  dispatcher holds a CHECKOUT -> carrier on another task refused
#   12e-3  carrier holds a TASK        -> dispatcher on that task refused
#   12e-4  dispatcher holds a TASK     -> carrier on that task refused
echo
echo "Case 12e-1 — a live CARRIER holds the checkout; a DISPATCHER on ANOTHER task starts"
d="$(new_sandbox)"
state_file "$d" "xt-carried"    "claude"
state_file "$d" "xt-dispatched" "codex"
CCOUNT="$SANDBOX_ROOT/xt1.count"; : >"$CCOUNT"
CSTUB="$SANDBOX_ROOT/xt1.stub"
make_carry_stub "$CSTUB" "$CCOUNT" "$d/logs/work-loop/xt-carried.md" 8
( bash "$CARRY_BIN" --checkout "$d" --task xt-carried --claude-bin "$CSTUB" \
    --timeout 60 "${CARRY_ALLOW[@]}" --log-dir "$SANDBOX_ROOT/xt1-carry-runs" \
    >/dev/null 2>&1 ) &
carrier=$!
sleep 3
# The setup assertion is not ceremony. Without it a green result could mean the
# carrier never took a lease at all, and the case would be proving nothing.
# The CHECKOUT lease is the one under test here: the dispatcher below runs a
# DIFFERENT task in the same working tree, so the task lease cannot refuse it.
[ -d "$(checkout_lock_for "$d")" ] \
  && ok "12e-1 setup — the carrier's CHECKOUT lease is live before the dispatcher starts" \
  || bad "12e-1 setup — the carrier's CHECKOUT lease is live before the dispatcher starts" \
         "no lease at $(checkout_lock_for "$d")"
rm -f "$d.calls"
BEFORE="$(git -C "$d" rev-parse HEAD)"
run_dispatch "$d" xt-dispatched --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 17 "$RC" "a dispatcher is refused while a CARRIER holds the checkout" "$OUT"
# REFUSING IS NOT THE WHOLE CONTRACT. The proposal's § 4.1 property 5 and its
# § 5 case 3 both require the refusal to NAME the attended holder, because the
# operator's next move is to find that process — and this line said "another
# dispatcher" for a lease whose recorded program is `carry`, sending them after
# a process that does not exist. The exit code was already right when this was
# wrong, which is why the code alone could not catch it.
out_has 'an attended carry is already running in this checkout' "$OUT" \
  "  and the refusal names the ATTENDED CARRIER as the holder"
out_lacks 'a dispatcher' "$OUT" \
  "  and does not call the carrier a dispatcher"
[ -s "$d.calls" ] && bad "  and the dispatcher launched no actor" \
                         "actors ran: $(tr '\n' ';' <"$d.calls")" \
                  || ok "  and the dispatcher launched no actor"
[ "$(git -C "$d" rev-parse HEAD)" = "$BEFORE" ] \
  && ok "  and committed nothing" \
  || bad "  and committed nothing" "HEAD moved from $BEFORE"
wait "$carrier" 2>/dev/null
# The control. Without it this case would pass just as well against a carrier
# that never launched anything and a dispatcher that refuses everything.
[ "$(carry_calls "$CCOUNT")" = "1" ] \
  && ok "  control — the carrier that HELD the lease did launch its own actor" \
  || bad "  control — the carrier that HELD the lease did launch its own actor" \
         "launches: $(carry_calls "$CCOUNT")"

echo
echo "Case 12e-2 — a live DISPATCHER holds the checkout; a CARRIER on ANOTHER task starts"
d="$(new_sandbox)"
state_file "$d" "xt-carried"    "claude"
state_file "$d" "xt-dispatched" "codex"
rm -f "$d.calls"
( bash "$DISPATCH_BIN" --checkout "$d" --task xt-dispatched --log-dir "$d/runs" \
    --timeout 40 --actor-cmd 'sleep 8; exit 0' >/dev/null 2>&1 ) &
dispatcher=$!
sleep 3
[ -d "$(checkout_lock_for "$d")" ] \
  && ok "12e-2 setup — the dispatcher's checkout lease is live before the carrier starts" \
  || bad "12e-2 setup — the dispatcher's checkout lease is live before the carrier starts" \
         "no lock at $(checkout_lock_for "$d")"
CCOUNT="$SANDBOX_ROOT/xt2.count"; : >"$CCOUNT"
CSTUB="$SANDBOX_ROOT/xt2.stub"
make_carry_stub "$CSTUB" "$CCOUNT" "$d/logs/work-loop/xt-carried.md" 0
BEFORE="$(git -C "$d" rev-parse HEAD)"
OUT="$(bash "$CARRY_BIN" --checkout "$d" --task xt-carried --claude-bin "$CSTUB" \
        --timeout 60 "${CARRY_ALLOW[@]}" --log-dir "$SANDBOX_ROOT/xt2-carry-runs" 2>&1)"; RC=$?
expect_rc 17 "$RC" "a carrier is refused while a DISPATCHER holds the checkout" "$OUT"
[ "$(carry_calls "$CCOUNT")" = "0" ] \
  && ok "  and the carrier launched no actor" \
  || bad "  and the carrier launched no actor" "launches: $(carry_calls "$CCOUNT")"
[ "$(git -C "$d" rev-parse HEAD)" = "$BEFORE" ] \
  && ok "  and committed nothing" \
  || bad "  and committed nothing" "HEAD moved from $BEFORE"
wait "$dispatcher" 2>/dev/null

echo
echo "Case 12e-3 — a live CARRIER holds the TASK in a linked worktree; a DISPATCHER starts on it here"
d="$(new_sandbox)"
state_file "$d" "xt-shared" "claude"
WT="$SANDBOX_ROOT/xt3-wt"
git -C "$d" worktree add -q -b xt3-lane "$WT" >/dev/null 2>&1
[ -f "$WT/logs/work-loop/xt-shared.md" ] \
  && ok "12e-3 setup — the state file replicates into the linked worktree" \
  || bad "12e-3 setup — the state file replicates into the linked worktree" "absent"
# THE DECLARATION BELONGS TO THE CARRIER'S CHECKOUT, and which checkout holds it
# IS the setup. The carrier gained its own repo-depth ownership admission in this
# change (carry-turn.sh 1496-1508), so it launches only where the task is
# ownership-valid. It runs in $WT, so $WT is where the task must be declared.
# Declaring it in $d instead — which this case did until the carrier acquired
# that check — leaves $WT REFUSED at 33 before launch: no actor, no task lease,
# and a dispatcher that then sails through. That is precisely the unsafe
# admission this case exists to catch, so it must never be the setup.
#
# --depth local, and the depth is not incidental. The worktree add above
# replicated the state file into a second checkout with neither one declaring
# it, and a repo-depth claim runs exactly that read, returns AMBIGUOUS and
# writes nothing (work-loop-owner.sh 278-282) — claiming is never the way out of
# an ambiguity. Local is the depth that can still record a declaration here, and
# it is what carry-turn.test.sh's own ownership-settled control uses.
#
# $d is left undeclared deliberately, and one declaration is the maximum: a
# second one in $d would make the task claimed by two checkouts, which is
# AMBIGUOUS for both and would refuse the carrier again by another route.
# Nothing is lost by leaving $d undeclared, because the dispatcher takes its
# leases (dispatch.sh 1249) before it performs ownership admission (2370): it
# meets the carrier's live task lease first and refuses with 17. If that order
# were ever reversed it would refuse with 33 here — still refused, still nothing
# launched, but a loud failure in this case rather than a silent pass.
bash "$WT/logs/scripts/work-loop-owner.sh" claim --checkout "$WT" --task xt-shared \
  --depth local >/dev/null 2>&1 \
  && ok "12e-3 setup — the carrier's worktree declares the task" \
  || bad "12e-3 setup — the carrier's worktree declares the task" "claim did not succeed"
CCOUNT="$SANDBOX_ROOT/xt3.count"; : >"$CCOUNT"
CSTUB="$SANDBOX_ROOT/xt3.stub"
make_carry_stub "$CSTUB" "$CCOUNT" "$WT/logs/work-loop/xt-shared.md" 8
( bash "$CARRY_BIN" --checkout "$WT" --task xt-shared --claude-bin "$CSTUB" \
    --timeout 60 "${CARRY_ALLOW[@]}" --log-dir "$SANDBOX_ROOT/xt3-carry-runs" \
    >/dev/null 2>&1 ) &
carrier=$!
sleep 3
# The TASK lease is the one under test here, and it is the mirror image of 12e-1:
# the dispatcher below runs in a DIFFERENT checkout, so the checkout lease cannot
# refuse it. The lease root is the repository's, not the worktree's, which is
# exactly what lets a lease taken in $WT be seen from $d — deriving it from $WT
# is what proves that, since a per-worktree root would resolve somewhere else.
[ -d "$(task_lock_for "$WT" xt-shared)" ] \
  && ok "12e-3 setup — the carrier's TASK lease is live before the dispatcher starts" \
  || bad "12e-3 setup — the carrier's TASK lease is live before the dispatcher starts" \
         "no lease at $(task_lock_for "$WT" xt-shared)"
rm -f "$d.calls"
BEFORE="$(git -C "$d" rev-parse HEAD)"
run_dispatch "$d" xt-shared --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 17 "$RC" "a dispatcher is refused while a CARRIER holds the same task elsewhere" "$OUT"
# The TASK half of the holder-identity contract, and the one this defect was
# first reproduced on. The detail line below it — the holder's checkout — was
# already right, which made the wrong subject harder to notice: the message
# named a real directory and the wrong kind of process holding it.
out_has 'an attended carry holds task xt-shared' "$OUT" \
  "  and the refusal names the ATTENDED CARRIER as the task holder"
out_lacks 'a dispatcher' "$OUT" \
  "  and does not call the carrier a dispatcher"
[ -s "$d.calls" ] && bad "  and the dispatcher launched no actor" \
                         "actors ran: $(tr '\n' ';' <"$d.calls")" \
                  || ok "  and the dispatcher launched no actor"
[ "$(git -C "$d" rev-parse HEAD)" = "$BEFORE" ] \
  && ok "  and committed nothing" \
  || bad "  and committed nothing" "HEAD moved from $BEFORE"
wait "$carrier" 2>/dev/null
[ "$(carry_calls "$CCOUNT")" = "1" ] \
  && ok "  control — the carrier that HELD the task did launch its own actor" \
  || bad "  control — the carrier that HELD the task did launch its own actor" \
         "launches: $(carry_calls "$CCOUNT")"
git -C "$d" worktree remove --force "$WT" >/dev/null 2>&1

echo
echo "Case 12e-4 — a live DISPATCHER holds the TASK here; a CARRIER starts on it in a linked worktree"
d="$(new_sandbox)"
state_file "$d" "xt-shared" "claude"
bash "$d/logs/scripts/work-loop-owner.sh" claim --checkout "$d" --task xt-shared \
  --depth repo >/dev/null 2>&1 \
  && ok "12e-4 setup — this checkout declares the task" \
  || bad "12e-4 setup — this checkout declares the task" "claim did not succeed"
WT="$SANDBOX_ROOT/xt4-wt"
git -C "$d" worktree add -q -b xt4-lane "$WT" >/dev/null 2>&1
rm -f "$d.calls"
( bash "$DISPATCH_BIN" --checkout "$d" --task xt-shared --log-dir "$d/runs" \
    --timeout 40 --actor-cmd 'sleep 8; exit 0' >/dev/null 2>&1 ) &
dispatcher=$!
sleep 3
[ -d "$(task_lock_for "$d" xt-shared)" ] \
  && ok "12e-4 setup — the dispatcher's TASK lease is live before the carrier starts" \
  || bad "12e-4 setup — the dispatcher's TASK lease is live before the carrier starts" \
         "no lock at $(task_lock_for "$d" xt-shared)"
CCOUNT="$SANDBOX_ROOT/xt4.count"; : >"$CCOUNT"
CSTUB="$SANDBOX_ROOT/xt4.stub"
make_carry_stub "$CSTUB" "$CCOUNT" "$WT/logs/work-loop/xt-shared.md" 0
BEFORE="$(git -C "$WT" rev-parse HEAD)"
# 17, not 33. The carrier gains a repo-depth ownership check in the same change,
# and this worktree does NOT declare the task — so ownership alone would also
# refuse this run. The expected code is the LEASE code because the dispatcher
# takes its leases before it performs ownership admission (dispatch.sh 1192 vs
# 2336) and the shared contract is written against what the dispatcher already
# does. If the implementation orders admission first, this becomes 33; the
# behaviour under test — refused, nothing launched — is the same either way, and
# the launch count below is the assertion that does not move.
expect_rc_note="lease refusal precedes ownership admission"
OUT="$(bash "$CARRY_BIN" --checkout "$WT" --task xt-shared --claude-bin "$CSTUB" \
        --timeout 60 "${CARRY_ALLOW[@]}" --log-dir "$SANDBOX_ROOT/xt4-carry-runs" 2>&1)"; RC=$?
expect_rc 17 "$RC" "a carrier is refused while a DISPATCHER holds the same task elsewhere ($expect_rc_note)" "$OUT"
[ "$(carry_calls "$CCOUNT")" = "0" ] \
  && ok "  and the carrier launched no actor" \
  || bad "  and the carrier launched no actor" "launches: $(carry_calls "$CCOUNT")"
[ "$(git -C "$WT" rev-parse HEAD)" = "$BEFORE" ] \
  && ok "  and committed nothing in the worktree" \
  || bad "  and committed nothing in the worktree" "HEAD moved from $BEFORE"
wait "$dispatcher" 2>/dev/null
git -C "$d" worktree remove --force "$WT" >/dev/null 2>&1

# --------------------------------------------------- cases 12e-5 .. 12e-7
# THE PROPOSAL'S CASES 3, 4 AND 12 — the three rows of the acceptance matrix
# that had no case of their own.
#
# WHY 12e-1..4 DID NOT ALREADY COVER THEM, which is the whole reason these
# exist. The four above are cross-transport, but each is a DIFFERENT row of the
# proposal's matrix, and the difference is the axis being isolated:
#
#   12e-1 / 12e-2  one checkout, DIFFERENT tasks  -> the proposal's case 11
#   12e-3 / 12e-4  one task, DIFFERENT checkouts  -> the proposal's cases 7 / 8
#
# The proposal's cases 3 and 4 are the plain collision neither pair states: the
# SAME task in the SAME checkout, one transport against the other. Both leases
# refuse it, which is exactly why an indirect argument from the four above is
# not evidence — a suite can be green on every neighbouring row while the
# straightforward one is untested, and "it must be covered, look at 12e" is the
# reasoning the correction plan's finding 6 names.
#
# Case 12 is the other direction, and it is the one a refusal-shaped change
# breaks silently: two DIFFERENT tasks in two DIFFERENT worktrees must BOTH be
# admitted. Nothing here asserted that two runs ever hold leases at the same
# moment. carry-turn.test.sh 12b has an over-refusal control, but it is carrier
# against a planted lease, sequential, and single-transport — it cannot show
# two live programs concurrent in one repository.
#
# Numbered in this suite's own 12e series, with the proposal's number in the
# header, for the reason case 30g gives: "case 3", "case 4" and "case 12" are
# all already taken here by unrelated local cases, and renumbering those would
# break every reference to them.
echo
echo "Case 12e-5 — proposal case 3: a CARRIER holds this task in THIS checkout; a DISPATCHER starts on it"
d="$(new_sandbox)"
state_file "$d" "xt-same" "claude"
CCOUNT="$SANDBOX_ROOT/xt5.count"; : >"$CCOUNT"
CSTUB="$SANDBOX_ROOT/xt5.stub"
make_carry_stub "$CSTUB" "$CCOUNT" "$d/logs/work-loop/xt-same.md" 8
( bash "$CARRY_BIN" --checkout "$d" --task xt-same --claude-bin "$CSTUB" \
    --timeout 60 "${CARRY_ALLOW[@]}" --log-dir "$SANDBOX_ROOT/xt5-carry-runs" \
    >/dev/null 2>&1 ) &
carrier=$!
sleep 3
CK5="$(checkout_lock_for "$d")"; TK5="$(task_lock_for "$d" xt-same)"
# BOTH leases, and both are asserted rather than one: this is the row where the
# task lease and the checkout lease would each refuse on their own, so a setup
# that established only one would leave which lease did the work unsettled.
{ [ -d "$CK5" ] && [ -d "$TK5" ]; } \
  && ok "12e-5 setup — the carrier holds BOTH the task and the checkout lease" \
  || bad "12e-5 setup — the carrier holds BOTH the task and the checkout lease" \
         "checkout=$([ -d "$CK5" ] && echo held || echo absent) task=$([ -d "$TK5" ] && echo held || echo absent)"
[ "$(cat "$TK5/program" 2>/dev/null)" = carry ] \
  && ok "12e-5 setup — and the task lease records a CARRIER as its holder" \
  || bad "12e-5 setup — and the task lease records a CARRIER as its holder" \
         "program=$(cat "$TK5/program" 2>/dev/null)"
rm -f "$d.calls"
BEFORE="$(git -C "$d" rev-parse HEAD)"
run_dispatch "$d" xt-same --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 17 "$RC" "a dispatcher is refused on the SAME task in the SAME checkout as a live carrier" "$OUT"
# The proposal's case 3 requires the refusal to NAME the attended holder, not
# merely to happen. The acquisition order is task lease first (work-loop-lease.sh
# 457), so this is the task-lease refusal.
out_has 'an attended carry holds task xt-same' "$OUT" \
  "  and the refusal names the ATTENDED CARRIER as the holder"
out_lacks 'a dispatcher' "$OUT" \
  "  and does not call the carrier a dispatcher"
[ -s "$d.calls" ] && bad "  and the dispatcher launched no actor" \
                         "actors ran: $(tr '\n' ';' <"$d.calls")" \
                  || ok "  and the dispatcher launched no actor"
[ "$(git -C "$d" rev-parse HEAD)" = "$BEFORE" ] \
  && ok "  and committed nothing" \
  || bad "  and committed nothing" "HEAD moved from $BEFORE"
wait "$carrier" 2>/dev/null
# The control. Without it every assertion above would pass just as well against
# a carrier that took a lease and never launched anything, and against a
# dispatcher that refuses unconditionally.
[ "$(carry_calls "$CCOUNT")" = "1" ] \
  && ok "  control — the carrier that HELD the leases did launch its own actor" \
  || bad "  control — the carrier that HELD the leases did launch its own actor" \
         "launches: $(carry_calls "$CCOUNT")"

echo
echo "Case 12e-6 — proposal case 4: a DISPATCHER holds this task in THIS checkout; a CARRIER starts on it"
d="$(new_sandbox)"
state_file "$d" "xt-same2" "claude"
rm -f "$d.calls"
# The actor RECORDS itself before it sleeps. 12e-2's dispatcher used a bare
# `sleep`, which cannot answer "did the holder actually launch?" — the control
# the proposal requires on this row.
( bash "$DISPATCH_BIN" --checkout "$d" --task xt-same2 --log-dir "$d/runs" \
    --timeout 40 --actor-cmd 'printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls"; sleep 8; exit 0' \
    >/dev/null 2>&1 ) &
dispatcher=$!
sleep 3
CK6="$(checkout_lock_for "$d")"; TK6="$(task_lock_for "$d" xt-same2)"
{ [ -d "$CK6" ] && [ -d "$TK6" ]; } \
  && ok "12e-6 setup — the dispatcher holds BOTH the task and the checkout lease" \
  || bad "12e-6 setup — the dispatcher holds BOTH the task and the checkout lease" \
         "checkout=$([ -d "$CK6" ] && echo held || echo absent) task=$([ -d "$TK6" ] && echo held || echo absent)"
[ "$(cat "$TK6/program" 2>/dev/null)" = dispatch ] \
  && ok "12e-6 setup — and the task lease records a DISPATCHER as its holder" \
  || bad "12e-6 setup — and the task lease records a DISPATCHER as its holder" \
         "program=$(cat "$TK6/program" 2>/dev/null)"
CCOUNT="$SANDBOX_ROOT/xt6.count"; : >"$CCOUNT"
CSTUB="$SANDBOX_ROOT/xt6.stub"
make_carry_stub "$CSTUB" "$CCOUNT" "$d/logs/work-loop/xt-same2.md" 0
BEFORE="$(git -C "$d" rev-parse HEAD)"
OUT="$(bash "$CARRY_BIN" --checkout "$d" --task xt-same2 --claude-bin "$CSTUB" \
        --timeout 60 "${CARRY_ALLOW[@]}" --log-dir "$SANDBOX_ROOT/xt6-carry-runs" 2>&1)"; RC=$?
expect_rc 17 "$RC" "a carrier is refused on the SAME task in the SAME checkout as a live dispatcher" "$OUT"
# The mirror image of 12e-5, on the carrier's own wording (carry-turn.sh 831).
# The negative half is the load-bearing one: a launcher that named the holder
# after the program doing the looking would say "an attended carry" here.
out_has "an unattended dispatched run already holds the TASK lease for 'xt-same2'" "$OUT" \
  "  and the refusal names the DISPATCHED RUN as the holder"
out_lacks 'an attended carry' "$OUT" \
  "  and does not call the dispatcher an attended carry"
[ "$(carry_calls "$CCOUNT")" = "0" ] \
  && ok "  and the carrier launched no actor" \
  || bad "  and the carrier launched no actor" "launches: $(carry_calls "$CCOUNT")"
[ "$(git -C "$d" rev-parse HEAD)" = "$BEFORE" ] \
  && ok "  and committed nothing" \
  || bad "  and committed nothing" "HEAD moved from $BEFORE"
wait "$dispatcher" 2>/dev/null
[ "$(calls "$d")" = "1" ] \
  && ok "  control — the dispatcher that HELD the leases did launch its own actor" \
  || bad "  control — the dispatcher that HELD the leases did launch its own actor" \
         "actor launches: $(calls "$d")"

echo
echo "Case 12e-7 — proposal case 12: DIFFERENT tasks in DIFFERENT worktrees are BOTH admitted, concurrently"
# The over-refusal row. Everything else in this section proves a refusal, and a
# lease that refused everything would satisfy all of it. This is the row that
# fails against such a lease, so it is where the section's own falsifiability
# sits — and it is proven CONCURRENTLY, because "both were admitted at different
# times" is not the claim: legitimate parallel work needs both leases held at
# one moment.
d="$(new_sandbox)"
state_file "$d" "iso-here"  "claude"
state_file "$d" "iso-there" "claude"
WT="$SANDBOX_ROOT/iso-wt"
git -C "$d" worktree add -q -b iso-lane "$WT" >/dev/null 2>&1
[ -f "$WT/logs/work-loop/iso-here.md" ] && [ -f "$WT/logs/work-loop/iso-there.md" ] \
  && ok "12e-7 setup — both state files replicate into the linked worktree" \
  || bad "12e-7 setup — both state files replicate into the linked worktree" "absent"
# THE SHARED LEASE ROOT IS THE POINT. Two worktrees of one repository resolve to
# ONE lease root, so these two runs are visible to each other and are admitted
# anyway. If the root were per-worktree, this case would pass by never having
# been a contention at all.
[ "$(lock_root_for "$d")" = "$(lock_root_for "$WT")" ] \
  && ok "12e-7 setup — both checkouts resolve the SAME lease root, so each could see the other" \
  || bad "12e-7 setup — both checkouts resolve the same lease root" \
         "$(lock_root_for "$d") vs $(lock_root_for "$WT")"
# Ownership has to be SETTLED in both, for the reason 12b and 12e-3 give: the
# worktree add replicated BOTH state files, and repository-depth ownership reads
# an undeclared replicated task as AMBIGUOUS. Each checkout declares the ONE
# task it runs — a second declaration in either would make that task claimed
# twice and refuse it by another route. --depth local, because a repo-depth
# claim runs the same replicated-state read and writes nothing.
bash "$d/logs/scripts/work-loop-owner.sh"  claim --checkout "$d"  --task iso-here \
     --depth local >/dev/null 2>&1 \
  && ok "12e-7 setup — this checkout declares iso-here" \
  || bad "12e-7 setup — this checkout declares iso-here" "claim did not succeed"
bash "$WT/logs/scripts/work-loop-owner.sh" claim --checkout "$WT" --task iso-there \
     --depth local >/dev/null 2>&1 \
  && ok "12e-7 setup — the worktree declares iso-there" \
  || bad "12e-7 setup — the worktree declares iso-there" "claim did not succeed"
ICOUNT="$SANDBOX_ROOT/iso.count"; : >"$ICOUNT"
ISTUB="$SANDBOX_ROOT/iso.stub"
make_carry_stub "$ISTUB" "$ICOUNT" "$d/logs/work-loop/iso-here.md" 8
rm -f "$d.calls" "$WT.calls"
ICRC="$SANDBOX_ROOT/iso-carry.rc"; IDRC="$SANDBOX_ROOT/iso-disp.rc"
ICOUT="$SANDBOX_ROOT/iso-carry.out"; IDOUT="$SANDBOX_ROOT/iso-disp.out"
( bash "$CARRY_BIN" --checkout "$d" --task iso-here --claude-bin "$ISTUB" \
    --timeout 60 "${CARRY_ALLOW[@]}" --log-dir "$SANDBOX_ROOT/iso-carry-runs" \
    >"$ICOUT" 2>&1; printf '%s' "$?" >"$ICRC" ) &
carrier=$!
( bash "$DISPATCH_BIN" --checkout "$WT" --task iso-there --log-dir "$WT/runs" \
    --timeout 40 --actor-cmd "sleep 6; $FLIP_TO_OPERATOR" \
    >"$IDOUT" 2>&1; printf '%s' "$?" >"$IDRC" ) &
dispatcher=$!
sleep 3
# THE CONCURRENCY ASSERTION, and it is read while both are still running. After
# they exit, four absent directories look exactly like two runs that never
# started, so this cannot be checked at the end.
CKh="$(checkout_lock_for "$d")";  TKh="$(task_lock_for "$d" iso-here)"
CKt="$(checkout_lock_for "$WT")"; TKt="$(task_lock_for "$WT" iso-there)"
{ [ -d "$CKh" ] && [ -d "$TKh" ] && [ -d "$CKt" ] && [ -d "$TKt" ]; } \
  && ok "  BOTH runs hold BOTH of their leases AT THE SAME MOMENT" \
  || bad "  BOTH runs hold BOTH of their leases AT THE SAME MOMENT" \
         "here: checkout=$([ -d "$CKh" ] && echo held || echo absent) task=$([ -d "$TKh" ] && echo held || echo absent); there: checkout=$([ -d "$CKt" ] && echo held || echo absent) task=$([ -d "$TKt" ] && echo held || echo absent)"
# MIXED PATHS would produce the same four `-d` results above while the two runs
# shared a resource, so the distinctness is asserted rather than assumed.
[ "$CKh" != "$CKt" ] \
  && ok "  and the two checkout leases are distinct paths" \
  || bad "  and the two checkout leases are distinct paths" "both resolve to $CKh"
[ "$TKh" != "$TKt" ] \
  && ok "  and the two task leases are distinct paths" \
  || bad "  and the two task leases are distinct paths" "both resolve to $TKh"
[ "$(cat "$CKh/program" 2>/dev/null)" = carry ] && [ "$(cat "$CKt/program" 2>/dev/null)" = dispatch ] \
  && ok "  and each lease records the program that actually took it" \
  || bad "  and each lease records the program that actually took it" \
         "here=$(cat "$CKh/program" 2>/dev/null) there=$(cat "$CKt/program" 2>/dev/null)"
wait "$carrier" 2>/dev/null
wait "$dispatcher" 2>/dev/null
# NEITHER WAS REFUSED. 17 is the code under test; the exit codes are asserted as
# "not 17" rather than as 0 because what follows admission — the carrier's
# post-hop verdict, the dispatcher's turn: operator stop — is other cases' subject
# and would couple this row to verdicts it is not about.
#
# The recorded code has to EXIST for that comparison to mean anything: a run
# that died without writing its rc file leaves an empty string, which is also
# "not 17". Read once into a variable so the emptiness and the value are the
# same reading.
irc="$(cat "$ICRC" 2>/dev/null)"; idrc="$(cat "$IDRC" 2>/dev/null)"
{ [ -n "$irc" ] && [ "$irc" != "17" ]; } \
  && ok "  and the carrier was NOT refused (exit $irc)" \
  || bad "  and the carrier was NOT refused" \
         "rc=[$irc] ${ICOUT}: $(head -5 "$ICOUT" 2>/dev/null | tr '\n' ' ')"
{ [ -n "$idrc" ] && [ "$idrc" != "17" ]; } \
  && ok "  and the dispatcher was NOT refused (exit $idrc)" \
  || bad "  and the dispatcher was NOT refused" \
         "rc=[$idrc] ${IDOUT}: $(head -5 "$IDOUT" 2>/dev/null | tr '\n' ' ')"
# The controls. Both of them: a lease that admitted both runs and neither of
# which launched would satisfy every assertion above.
[ "$(carry_calls "$ICOUNT")" = "1" ] \
  && ok "  control — the carrier launched its own actor" \
  || bad "  control — the carrier launched its own actor" "launches: $(carry_calls "$ICOUNT")"
[ "$(calls "$WT")" = "1" ] \
  && ok "  control — the dispatcher launched its own actor" \
  || bad "  control — the dispatcher launched its own actor" "launches: $(calls "$WT")"
[ "$(calls "$d")" = "0" ] \
  && ok "  and no actor ran against the OTHER checkout" \
  || bad "  and no actor ran against the OTHER checkout" "$(tr '\n' ';' <"$d.calls" 2>/dev/null)"
# ISOLATION, on the working trees rather than on the leases. The carrier's hop
# rewrote iso-here in ITS checkout; the worktree's replica of the same file must
# be untouched, or the two runs were never separated in the way this row claims.
grep -q 'carrier stub ran' "$d/logs/work-loop/iso-here.md" 2>/dev/null \
  && ok "  and the carrier's hop landed in ITS OWN checkout's state file" \
  || bad "  and the carrier's hop landed in ITS OWN checkout's state file" "no hop recorded"
grep -q 'carrier stub ran' "$WT/logs/work-loop/iso-here.md" 2>/dev/null \
  && bad "  and the worktree's replica of that file is untouched" "the hop reached the other checkout" \
  || ok "  and the worktree's replica of that file is untouched"
[ -d "$WT/runs" ] && [ ! -e "$d/runs" ] \
  && ok "  and the dispatcher's run log exists only in the worktree it ran in" \
  || bad "  and the dispatcher's run log exists only in the worktree it ran in" \
         "worktree=$([ -d "$WT/runs" ] && echo present || echo absent) other=$([ -e "$d/runs" ] && echo present || echo absent)"
# No leak: two admitted runs that exit normally leave nothing behind, so the
# next pair is admitted for the same reason this one was.
{ [ ! -d "$CKh" ] && [ ! -d "$TKh" ] && [ ! -d "$CKt" ] && [ ! -d "$TKt" ]; } \
  && ok "  and all four leases were released when the two runs ended" \
  || bad "  and all four leases were released when the two runs ended" \
         "here: checkout=$([ -d "$CKh" ] && echo held || echo gone) task=$([ -d "$TKh" ] && echo held || echo gone); there: checkout=$([ -d "$CKt" ] && echo held || echo gone) task=$([ -d "$TKt" ] && echo held || echo gone)"
git -C "$d" worktree remove --force "$WT" >/dev/null 2>&1

# ---------------------------------------------------------------- case 12f
# THE LEASE ITSELF FAILS CLOSED when its shared library cannot be sourced.
#
# This is the sibling of 12d, one control over. 12d covers a checkout whose
# OWNERSHIP check cannot run; this covers a checkout whose LIVE LEASE cannot be
# taken, because the library that implements it is not there. Both are absences,
# and an absent check is not a passed check: the checkouts most likely to lack
# the library — older siblings, partial copies — are exactly the ones most likely
# to hold a conflicting writer.
#
# The code is 11, not 33/34/35. Those three are the OWNERSHIP taxonomy and this
# is not an ownership fact; 11 is the outcome this dispatcher already uses for
# every other lease-infrastructure failure (an unresolvable Git common directory,
# an uncreatable lock root). Reusing it keeps leases and durable ownership
# separate, which is the distinction the whole shared-lease design rests on.
#
# The exit code alone would not be evidence. A dispatcher that refuses
# everything passes an exit-code assertion, so the case also measures that NO
# actor was launched, that HEAD did not move, and — in the control below — that
# the same run proceeds and does launch once the library is present.
echo
echo "Case 12f — an ABSENT lease library refuses before launch and takes no lease"
d="$(new_sandbox)"
state_file "$d" "lease-missing" "codex"
rm -f "$d.calls"
git -C "$d" rm -q --cached logs/scripts/work-loop-lease.sh >/dev/null 2>&1
rm -f "$d/logs/scripts/work-loop-lease.sh"
git -C "$d" commit -qm "remove the lease library" >/dev/null 2>&1
BEFORE="$(git -C "$d" rev-parse HEAD)"
run_dispatch "$d" lease-missing --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 11 "$RC" "an ABSENT lease library refuses with exit 11" "$OUT"
case "$OUT" in
  *"lease"*"missing or unreadable"*) ok "the refusal names the missing lease library" ;;
  *) bad "the refusal names the missing lease library" "$OUT" ;;
esac
[ -s "$d.calls" ] && bad "no actor was launched without the lease library" \
                         "actors ran: $(tr '\n' ';' <"$d.calls")" \
                      || ok "no actor was launched without the lease library"
[ "$(git -C "$d" rev-parse HEAD)" = "$BEFORE" ] \
  && ok "no commit was made without the lease library" \
  || bad "no commit was made without the lease library" "HEAD moved from $BEFORE"
# A refusal must not leave a lease behind. The run never took one, so the two
# lease directories must be absent — a refusal that half-acquired would refuse
# the NEXT run for a reason that never existed.
{ [ ! -d "$(task_lock_for "$d" lease-missing)" ] && [ ! -d "$(checkout_lock_for "$d")" ]; } \
  && ok "the refused run left no lease directory behind" \
  || bad "the refused run left no lease directory behind" \
         "$(task_lock_for "$d" lease-missing) / $(checkout_lock_for "$d")"

# The control. Same fixture recipe, same command, library PRESENT — it must
# proceed and must launch. Its own sandbox, for the reason case 12d's control
# spells out: reusing the refused one would make the control depend on the very
# thing under test.
dl="$(new_sandbox)"
state_file "$dl" "lease-present" "codex"
rm -f "$dl.calls"
run_dispatch "$dl" lease-present --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 0 "$RC" "control — with the lease library present the same run proceeds" "$OUT"
[ -s "$dl.calls" ] && ok "control — the actor did run once the lease could be taken" \
                   || bad "control — the actor did run once the lease could be taken" "no calls"

# ---------------------------------------------------------------- case 12g
# THE HOLDER LABEL'S TWO FALLBACKS. A held lease whose `program` file is missing,
# empty or unrecognised is still HELD — the refusal must say so without guessing
# which transport left it. Guessing is the specific failure: naming a dispatcher
# by default is exactly what 12e caught, and naming a carrier by default would be
# the same mistake pointing the other way.
#
# These two PLANT a lease directory rather than launching a second program, and
# that is the one place in this suite where planting is the right instrument.
# 12e asks whether one program OBSERVES the other's lease, which a planted
# directory cannot answer. This asks what the message SAYS about metadata that no
# healthy program writes — an absent `program` file (an older lease predating the
# shared library, or a partially-written one) and a value from some future
# program. Neither can be produced by running a program that is working
# correctly, so a real launch could not set up either case.
#
# The lease is planted with pid/task/checkout but no `survivors` file, so it is
# HELD and not PINNED — the pinned branches exit before the label is used.
plant_lease() { # lease-dir holding-task holding-checkout [program]
  mkdir -p "$1"
  printf '%s\n' "$$"  >"$1/pid"
  printf '%s\n' "$2"  >"$1/task"
  printf '%s\n' "$3"  >"$1/checkout"
  [ "$#" -ge 4 ] && printf '%s\n' "$4" >"$1/program"
  return 0
}

echo
echo "Case 12g — a held lease with no recorded program, and one from an unknown program"
d="$(new_sandbox)"
state_file "$d" "label-task" "codex"
rm -f "$d.calls"
BEFORE="$(git -C "$d" rev-parse HEAD)"
# No `program` file at all: WL_LEASE_HOLDER_PROGRAM comes back empty.
plant_lease "$(task_lock_for "$d" label-task)" label-task "$d"
run_dispatch "$d" label-task --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 17 "$RC" "a lease with no recorded program still refuses with 17" "$OUT"
out_has 'a Work Loop run (program unrecorded) holds task label-task' "$OUT" \
  "  and the refusal says the program is unrecorded rather than guessing"
out_lacks 'a dispatcher' "$OUT" \
  "  and does not guess a dispatcher"
[ -s "$d.calls" ] && bad "  and launched no actor" "actors ran: $(tr '\n' ';' <"$d.calls")" \
                  || ok "  and launched no actor"
[ "$(git -C "$d" rev-parse HEAD)" = "$BEFORE" ] \
  && ok "  and committed nothing" || bad "  and committed nothing" "HEAD moved from $BEFORE"
rm -rf "$(task_lock_for "$d" label-task)"

# An unrecognised program name is reported verbatim: the operator can act on a
# name they can search for, and a name this dispatcher does not know is still
# more than "another run".
plant_lease "$(checkout_lock_for "$d")" other-task "$d" some-future-runner
rm -f "$d.calls"
run_dispatch "$d" label-task --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 17 "$RC" "a lease held by an UNKNOWN program still refuses with 17" "$OUT"
out_has 'a Work Loop run (some-future-runner) is already running in this checkout' "$OUT" \
  "  and the refusal reports the unknown program name verbatim"
[ -s "$d.calls" ] && bad "  and launched no actor" "actors ran: $(tr '\n' ';' <"$d.calls")" \
                  || ok "  and launched no actor"
rm -rf "$(checkout_lock_for "$d")" "$(task_lock_for "$d" label-task)"

# ---------------------------------------------------------------- case 12h
# A PRE-ADMISSION REFUSAL LEAVES DURABLE EVIDENCE — AND LEAVES THE CHECKOUT ALONE.
#
# The live cross-transport hop of 2026-08-14 found the first half the hard way.
# The dispatcher refused correctly at 17 while the attended carrier held the
# shared lease — the concurrency control worked — but the refusal reached stderr
# and nowhere else, and an unattended dispatcher's stderr goes nowhere anybody is
# watching. Every case 12 assertion above passed throughout, because they all
# read the exit code and the message.
#
# The FIRST fix opened the run log before the lease was asked for, which bought
# the durable record at a price that is not payable: a dispatcher that has lost
# admission would create a directory and a file inside a checkout it does not own
# and is not entitled to touch. Two runs racing for one checkout would each leave
# marks in the other's working tree, and the whole point of losing admission is
# that the loser changes nothing.
#
# So the record moved, and this case asserts BOTH halves at once. Neither is
# sufficient alone — a refusal that writes nothing is unprovable, and a refusal
# that writes into the checkout is a trespass — and it is the pair that pins the
# behaviour:
#
#   1. the requested --log-dir, inside the checkout, is NEVER created;
#   2. the checkout's working-tree bytes and `git status` are unchanged;
#   3. a durable record still exists, under the shared lease root in the Git
#      common directory, carrying the human refusal AND a stable machine-readable
#      terminal record a later reader can match without parsing prose;
#   4. the refusal names that record's path, so an operator can find it;
#   5. no actor started, so the record describes a refusal and not a run.
#
# THE HOLDER'S OWN LOG DIRECTORY IS OUTSIDE THE CHECKOUT. It is admitted, so it
# is entitled to write wherever it was asked to — but its writes would land in
# the same working tree the loser is being measured against, and the manifest
# could not say which run moved a byte.
#
# The lease is HELD BY A REAL SECOND DISPATCHER, not planted. What is under test
# is a stop taken on the live acquisition path, and a planted directory would
# reach the same branch without proving the ordering that caused the defect.
echo
echo "Case 12h — a pre-admission exit-17 refusal writes durable evidence, and not into the checkout"
d="$(new_sandbox)"; state_file "$d" "record-task" "codex"
rm -f "$d.calls" "$d.holder"
LOSER_LOGS="$d/refused-runs"                    # INSIDE the checkout, and must stay absent
HOLDER_LOGS="$SANDBOX_ROOT/12h-holder-runs"     # outside it, so only the loser can move the bytes
REFUSALS="$(lock_root_for "$d")/refusals"
BEFORE="$(git -C "$d" rev-parse HEAD)"
( bash "$DISPATCH_BIN" --checkout "$d" --task record-task --log-dir "$HOLDER_LOGS" \
    --timeout 90 \
    --actor-cmd 'printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.holder"; sleep 30; exit 0' \
    >/dev/null 2>&1 ) &
holder=$!
# WAITED ON THE ACTOR, NOT ON THE LEASE, and the difference is load-bearing. The
# holder writes its own ownership declaration into the checkout somewhere between
# taking the lease and launching, so a manifest captured in that window would
# move for the HOLDER's reasons and this case would fail for something it is not
# testing. Once the actor is running, the holder touches the working tree no more.
for _ in $(seq 1 120); do [ -f "$d.holder" ] && break; sleep 0.5; done
[ -f "$d.holder" ] \
  && ok "12h setup — the holding dispatcher is admitted and inside its actor" \
  || bad "12h setup — the holding dispatcher is admitted and inside its actor" "no $d.holder marker"

TREE_BEFORE="$(tree_manifest "$d")"
STATUS_BEFORE="$(git -C "$d" status --porcelain)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task record-task \
        --log-dir "$LOSER_LOGS" --timeout 20 --actor-cmd "$FLIP" 2>&1)"; RC=$?
TREE_AFTER="$(tree_manifest "$d")"
STATUS_AFTER="$(git -C "$d" status --porcelain)"
expect_rc 17 "$RC" "the second dispatcher is refused at 17 by a REAL held lease" "$OUT"

# THE CHECKOUT IS UNTOUCHED. This is the assertion the previous implementation
# failed, and it fails LOUDLY rather than by absence: the diff names the file.
[ ! -e "$LOSER_LOGS" ] \
  && ok "  and the requested --log-dir inside the checkout was never created" \
  || bad "  and the requested --log-dir inside the checkout was never created" \
         "$(ls -a "$LOSER_LOGS" 2>&1 | tr '\n' ' ')"
if [ "$TREE_BEFORE" = "$TREE_AFTER" ]; then
  ok "  and every byte of the checkout's working tree is unchanged"
else
  bad "  and every byte of the checkout's working tree is unchanged" \
      "$(diff <(printf '%s\n' "$TREE_BEFORE") <(printf '%s\n' "$TREE_AFTER") | head -10 | tr '\n' ' ')"
fi
[ "$STATUS_BEFORE" = "$STATUS_AFTER" ] \
  && ok "  and git status is unchanged" \
  || bad "  and git status is unchanged" "before [$STATUS_BEFORE] after [$STATUS_AFTER]"

# THE RECORD STILL EXISTS, somewhere the loser is entitled to write.
RR="$(ls -t "$REFUSALS"/*.refusal 2>/dev/null | head -1)"
if [ -n "$RR" ]; then
  ok "  and a durable refusal record was written under the shared lease root"
else
  bad "  and a durable refusal record was written under the shared lease root" \
      "nothing matching $REFUSALS/*.refusal: $(ls -a "$REFUSALS" 2>&1 | tr '\n' ' ')"
fi
# Named against the Git common directory rather than against "not $d": a record
# under $d/.git would satisfy the negative and still be the wrong place, because
# the point is that every linked worktree of this repository can read it.
case "${RR:-<none>}" in
  "$(lock_root_for "$d")"/refusals/*)
    ok "    and it lives in the Git common directory, outside every worktree" ;;
  *)
    bad "    and it lives in the Git common directory, outside every worktree" \
        "got: ${RR:-<none>}" ;;
esac
if [ -n "$RR" ] && grep -q '^STOP \[17\]' "$RR"; then
  ok "    and it carries the human refusal, not only the terminal did"
else
  bad "    and it carries the human refusal, not only the terminal did" "record: ${RR:-none}"
fi
# The machine-readable half, field by field. A record that says "refused" without
# the code, the task or the holder is not something a later reader can act on.
TR="$(grep '^terminal-record ' "$RR" 2>/dev/null | tail -1)"
if [ -n "$TR" ]; then
  ok "    and a stable terminal record line is present"
else
  bad "    and a stable terminal record line is present" "record: ${RR:-none}"
fi
for field in 'outcome=refused' 'code=17' 'task=record-task' 'holder_program=dispatch' \
             'resource=task' 'refusal=held' 'actor_launched=no'; do
  case "$TR" in
    *"$field"*) ok "      the terminal record carries $field" ;;
    *)          bad "      the terminal record carries $field" "got: ${TR:-<no record>}" ;;
  esac
done
# The holder's checkout is named, so an operator reading the losing transport's
# evidence alone can find the winning one.
case "$TR" in
  *"holder_checkout=$(cd "$d" && pwd -P)"*) ok "      and names the holder's checkout" ;;
  *) bad "      and names the holder's checkout" "got: ${TR:-<no record>}" ;;
esac
# EVIDENCE NOBODY CAN FIND IS NOT EVIDENCE. The record now lives somewhere the
# operator did not choose, so the refusal has to say where it went.
if [ -n "$RR" ]; then
  out_has "$RR" "$OUT" "  and the refusal prints the record's path on the terminal"
else
  bad "  and the refusal prints the record's path on the terminal" "no record to name"
fi

# NO ACTOR RAN. Three independent handles, because the record's whole value is
# that it describes a refusal: an exit code alone cannot separate "refused before
# launch" from "launched and then failed".
[ -s "$d.calls" ] && bad "  and no actor was launched" "actors ran: $(tr '\n' ';' <"$d.calls")" \
                  || ok "  and no actor was launched"
if [ -n "$RR" ] && grep -qE '^hop=[0-9]+ actor=' "$RR"; then
  bad "  and the record shows no hop" "$(grep -E '^hop=' "$RR")"
else
  ok "  and the record shows no hop"
fi
[ "$(git -C "$d" rev-parse HEAD)" = "$BEFORE" ] \
  && ok "  and committed nothing" || bad "  and committed nothing" "HEAD moved from $BEFORE"

# --status STAYS NO-WRITE, on all three surfaces it could now touch: the
# requested log directory, a log directory that does not exist, and the refusal
# store. It takes no lease, so it can never be refused, so it must never file a
# refusal — a record written by a read-only command would be a false one.
n_ref_before="$(ls -1 "$REFUSALS" 2>/dev/null | wc -l | tr -d ' ')"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task record-task \
        --log-dir "$LOSER_LOGS" --status 2>&1)"; RC=$?
expect_rc 0 "$RC" "  --status still exits 0 over a held lease" "$OUT"
[ ! -e "$LOSER_LOGS" ] \
  && ok "  --status created no log directory it was pointed at" \
  || bad "  --status created no log directory it was pointed at" "$(ls -a "$LOSER_LOGS" 2>&1 | tr '\n' ' ')"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task record-task \
        --log-dir "$d/status-only-runs" --status 2>&1)"; RC=$?
expect_rc 0 "$RC" "  --status exits 0 for a log directory that does not exist" "$OUT"
[ ! -d "$d/status-only-runs" ] \
  && ok "  --status created no log directory" \
  || bad "  --status created no log directory" "$d/status-only-runs exists"
[ "$n_ref_before" = "$(ls -1 "$REFUSALS" 2>/dev/null | wc -l | tr -d ' ')" ] \
  && ok "  --status filed no refusal record" \
  || bad "  --status filed no refusal record" "refusal count moved from $n_ref_before"

wait "$holder" 2>/dev/null
rm -rf "$(task_lock_for "$d" record-task)" "$(checkout_lock_for "$d")" 2>/dev/null

# ---------------------------------------------------------------- case 12h-ok
# THE POSITIVE CONTROL, and without it 12h passes against a dispatcher that never
# writes a run log at all. Everything above is an absence — no directory, no
# bytes, no actor — and a program that had simply lost the ability to open its
# run evidence would satisfy every one of those assertions. This is the run that
# WINS admission, and it must produce exactly what the losing one must not.
echo
echo "Case 12h-ok — an ADMITTED run still creates and uses the requested run log"
rm -f "$d.calls"
n_ref_before="$(ls -1 "$REFUSALS" 2>/dev/null | wc -l | tr -d ' ')"
run_dispatch "$d" record-task --max-hops 1 --actor-cmd "$FLIP"
AL="$(ls -t "$d"/runs/*.log 2>/dev/null | head -1)"
if [ -n "$AL" ]; then
  ok "the requested --log-dir received a run log once both leases were held"
else
  bad "the requested --log-dir received a run log once both leases were held" \
      "nothing under $d/runs: $(ls -a "$d/runs" 2>&1 | tr '\n' ' ')"
fi
# Created is not the same claim as used. The run header only exists because the
# log was open when the run reported itself.
if [ -n "$AL" ] && grep -q '^run=' "$AL"; then
  ok "  and the run wrote its own header into it"
else
  bad "  and the run wrote its own header into it" "run log: ${AL:-none}"
fi
[ "$(calls "$d")" = "1" ] \
  && ok "  and the actor really launched (this is an admitted run, not another refusal)" \
  || bad "  and the actor really launched" "calls: $(calls "$d")"
[ "$n_ref_before" = "$(ls -1 "$REFUSALS" 2>/dev/null | wc -l | tr -d ' ')" ] \
  && ok "  and an admitted run files no refusal record" \
  || bad "  and an admitted run files no refusal record" "refusal count moved from $n_ref_before"
rm -rf "$(task_lock_for "$d" record-task)" "$(checkout_lock_for "$d")" 2>/dev/null

# ================================================================= case 13
# Regression for the gap the 2026-08-05 live run exposed: a Claude hop killed
# between editing and committing left a partial state file, and nothing stopped.
echo
echo "Case 13 — a Claude hop that edits but does not commit"
d="$(new_sandbox)"; state_file "$d" "dirty-task" "claude"
NO_COMMIT="$FLIP_BODY"   # deliberately WITHOUT COMMIT_IF_CLAUDE
run_dispatch "$d" dirty-task --actor-cmd "$NO_COMMIT"
expect_rc 25 "$RC" "exits 25 when Claude hands back without committing" "$OUT"

echo
echo "Case 13b — restart over a partial edit vs. the expected Codex handoff"
d="$(new_sandbox)"; state_file "$d" "restart-task" "codex"
# Claude's side of the seam: turn says codex, but the file is uncommitted, so a
# previous Claude died mid-hop. Must stop for inspection.
perl -pi -e 's/^turn: codex$/turn: codex/' "$d/logs/work-loop/restart-task.md"
printf '\nleftover partial edit\n' >>"$d/logs/work-loop/restart-task.md"
run_dispatch "$d" restart-task --actor-cmd "$FLIP"
expect_rc 25 "$RC" "exits 25 restarting over an uncommitted turn: codex file" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "no actor launched over a partial edit" || bad "no actor launched over a partial edit"

# Codex's side of the same seam: uncommitted with turn: claude is the expected
# handoff, because Codex writes the file and never runs git. Must proceed.
d="$(new_sandbox)"; state_file "$d" "handoff-task" "claude"
printf '\nCodex just wrote this and cannot commit it.\n' >>"$d/logs/work-loop/handoff-task.md"
run_dispatch "$d" handoff-task --max-hops 1 --actor-cmd "$FLIP"
if [ "$RC" -eq 23 ] && [ "$(calls "$d")" = "1" ]; then
  ok "an uncommitted turn: claude file is accepted as the Codex handoff and runs"
else
  bad "an uncommitted turn: claude file is accepted as the Codex handoff and runs" "rc=$RC calls=$(calls "$d")"
fi

# ================================================================= case 14
# Cluster 1 (controller side). An unattended actor that blocks on an approval
# nobody will ever give must be killed on the clock, not waited on forever, and
# the dispatcher must not touch any permission surface to get past it.
echo
echo "Case 14 — an actor blocked on an approval prompt is killed, not waited on"
d="$(new_sandbox)"; state_file "$d" "approval-task" "claude"
mkdir -p "$d/.claude"
printf '{\n  "permissions": { "defaultMode": "default" }\n}\n' >"$d/.claude/settings.json"
git -C "$d" add .claude/settings.json >/dev/null 2>&1
git -C "$d" commit -qm "fixture: sandbox settings" >/dev/null 2>&1
set_before="$(shasum -a 256 "$d/.claude/settings.json" | cut -d' ' -f1)"
BLOCKED_ON_APPROVAL='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls";
      echo "Claude needs your permission to use Bash. Allow? (y/n)";
      sleep 120'
t0="$(date '+%s')"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task approval-task --log-dir "$d/runs" \
       --timeout 4 --actor-cmd "$BLOCKED_ON_APPROVAL" 2>&1)"; RC=$?
took=$(( $(date '+%s') - t0 ))
expect_rc 21 "$RC" "exits 21 when the actor blocks on an approval it never gets" "$OUT"
if [ "$took" -lt 25 ]; then
  ok "the blocked actor was killed on the clock (${took}s for a 4s deadline)"
else
  bad "the blocked actor was killed on the clock" "took ${took}s for a 4s deadline"
fi
grep -q "Allow? (y/n)" "$d/runs/"*.hop1.claude.out 2>/dev/null \
  && ok "the captured output shows it stopped ON the approval prompt, not on work" \
  || bad "the captured output shows it stopped ON the approval prompt, not on work"
set_after="$(shasum -a 256 "$d/.claude/settings.json" | cut -d' ' -f1)"
[ "$set_before" = "$set_after" ] && ok "no permission surface was touched to get past it" \
                                || bad "no permission surface was touched to get past it"
grep -q '^turn: claude$' "$d/logs/work-loop/approval-task.md" \
  && ok "the state file did not move" || bad "the state file did not move"

# ================================================================= case 15
# Cluster 2. A crash BEFORE the actor changed anything is retried once from
# repository truth. A crash AFTER it changed something is not.
echo
echo "Case 15 — a pre-edit crash is retried exactly once"
d="$(new_sandbox)"; state_file "$d" "retry-task" "claude"
RETRY_ONCE='if [ ! -f "$WL_CHECKOUT.attempt" ]; then touch "$WL_CHECKOUT.attempt"; exit 7; fi;
      '"$FLIP_TO_OPERATOR"
run_dispatch "$d" retry-task --actor-cmd "$RETRY_ONCE"
expect_rc 0 "$RC" "the retried hop completes and reaches turn: operator" "$OUT"
printf '%s' "$OUT" | grep -q "retrying this hop once" \
  && ok "the run log says it retried, and why" || bad "the run log says it retried, and why"
if [ "$(ls "$d/runs/" 2>/dev/null | grep -c '\.hop1r\.claude\.out$')" = "1" ]; then
  ok "the first attempt's output was kept as separate evidence"
else
  bad "the first attempt's output was kept as separate evidence" "no hop1r capture in $d/runs/"
fi
[ "$(calls "$d")" = "1" ] && ok "exactly one successful actor call was recorded" \
                          || bad "exactly one successful actor call was recorded" "calls=$(calls "$d")"

echo
echo "Case 15b — a crash AFTER a repository change is not retried"
d="$(new_sandbox)"; state_file "$d" "partial-task" "codex"
CRASH_AFTER_EDIT="$FLIP_BODY"'; exit 9'
run_dispatch "$d" partial-task --actor-cmd "$CRASH_AFTER_EDIT"
expect_rc 20 "$RC" "exits 20 without retrying over a partial effect" "$OUT"
printf '%s' "$OUT" | grep -q "not retried" \
  && ok "the stop names the partial effect as the reason" || bad "the stop names the partial effect as the reason"
[ "$(calls "$d")" = "1" ] && ok "the failed actor was launched once, not twice" \
                          || bad "the failed actor was launched once, not twice" "calls=$(calls "$d")"

# ================================================================= case 16
# Cluster 3. Foreign work that was ALREADY in the working tree. The before/after
# delta cannot see this — both snapshots contain it — so it used to pass through.
echo
echo "Case 16 — foreign UNSTAGED work stops the run before any launch"
d="$(new_sandbox)"; state_file "$d" "unstaged-task" "codex"
printf 'foreign unstaged edit\n' >>"$d/other.txt"
run_dispatch "$d" unstaged-task --actor-cmd "$FLIP"
expect_rc 18 "$RC" "exits 18 on a modified tracked file outside the allowlist" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "no actor launched over foreign unstaged work" \
                          || bad "no actor launched over foreign unstaged work" "calls=$(calls "$d")"
printf '%s' "$OUT" | grep -q "Recoverable next action" \
  && ok "the stop names a recoverable next action" || bad "the stop names a recoverable next action"

d="$(new_sandbox)"; state_file "$d" "untracked-task" "codex"
printf 'stray\n' >"$d/somebody-elses-file.txt"
run_dispatch "$d" untracked-task --actor-cmd "$FLIP"
expect_rc 18 "$RC" "exits 18 on an untracked file outside the allowlist" "$OUT"

# The expected uncommitted Codex handoff must still run: the state file is inside
# the allowlist, so it is never foreign work.
d="$(new_sandbox)"; state_file "$d" "still-runs-task" "claude"
printf '\nCodex wrote this and cannot commit it.\n' >>"$d/logs/work-loop/still-runs-task.md"
run_dispatch "$d" still-runs-task --max-hops 1 --actor-cmd "$FLIP"
if [ "$RC" -eq 23 ] && [ "$(calls "$d")" = "1" ]; then
  ok "the uncommitted Codex handoff still launches under the new gate"
else
  bad "the uncommitted Codex handoff still launches under the new gate" "rc=$RC calls=$(calls "$d")"
fi

# ================================================================= case 17
echo
echo "Case 17 — Git lock contention stops the run before any launch"
d="$(new_sandbox)"; state_file "$d" "lockfile-task" "codex"
touch "$d/.git/index.lock"
run_dispatch "$d" lockfile-task --actor-cmd "$FLIP"
expect_rc 19 "$RC" "exits 19 while a Git index.lock is held" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "no actor launched while another Git process is writing" \
                          || bad "no actor launched while another Git process is writing"
rm -f "$d/.git/index.lock"

# ================================================================= case 18
echo
echo "Case 18 — an in-progress merge, rebase or cherry-pick stops the run"
for marker in MERGE_HEAD CHERRY_PICK_HEAD REVERT_HEAD; do
  d="$(new_sandbox)"; state_file "$d" "midop-task" "codex"
  printf '0000000000000000000000000000000000000000\n' >"$d/.git/$marker"
  run_dispatch "$d" midop-task --actor-cmd "$FLIP"
  expect_rc 19 "$RC" "exits 19 with $marker present" "$OUT"
  [ "$(calls "$d")" = "0" ] && ok "no actor launched with $marker present" \
                           || bad "no actor launched with $marker present" "calls=$(calls "$d")"
done
for dir in rebase-merge rebase-apply; do
  d="$(new_sandbox)"; state_file "$d" "midop-task" "codex"
  mkdir -p "$d/.git/$dir"
  run_dispatch "$d" midop-task --actor-cmd "$FLIP"
  expect_rc 19 "$RC" "exits 19 with $dir/ present" "$OUT"
done

# ================================================================= case 19
echo
echo "Case 19 — a duplicate completion event relaunches nothing"
d="$(new_sandbox)"; state_file "$d" "dup-task" "claude"
run_dispatch "$d" dup-task --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 0 "$RC" "the first run reaches turn: operator" "$OUT"
first_calls="$(calls "$d")"
run_dispatch "$d" dup-task --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 0 "$RC" "the duplicate run also exits 0" "$OUT"
[ "$(calls "$d")" = "$first_calls" ] \
  && ok "the duplicate run launched nothing (calls stayed at $first_calls)" \
  || bad "the duplicate run launched nothing" "was $first_calls, now $(calls "$d")"

# ================================================================= case 20
# Cluster 4. turn: operator reached by a genuine core § 7 question, not by a
# normal close — and the question survives, visibly unanswered.
echo
echo "Case 20 — a core § 7 operator question is preserved and left unanswered"
d="$(new_sandbox)"; state_file "$d" "opq-task" "claude"
ASK_OPERATOR='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls";
      { printf -- "---\ntask: %s\nstatus: blocked\nturn: operator\n---\n\n" "$WL_TASK";
        printf "## Objective and scope\nSandbox fixture.\n\n";
        printf "## Lane and unit\nStandard. Implementation mode. Unit 1 — harness fixture.\n\n";
        printf "## Latest result\nStopped to ask.\n\n";
        printf "## Blocker\nOPERATOR-Q7: this change is hard to reverse. Authorise it?\n\n";
        printf "## Next action\nOperator decides. Neither model may answer this.\n"; } > "$WL_STATE_FILE.tmp";
      mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"'"$COMMIT_IF_CLAUDE"
run_dispatch "$d" opq-task --actor-cmd "$ASK_OPERATOR"
expect_rc 0 "$RC" "stops at turn: operator on a genuine question" "$OUT"
[ "$(calls "$d")" = "1" ] && ok "zero further launches after the question was raised" \
                          || bad "zero further launches after the question was raised" "calls=$(calls "$d")"
grep -q 'OPERATOR-Q7' "$d/logs/work-loop/opq-task.md" \
  && ok "the question is preserved in the state file" || bad "the question is preserved in the state file"
printf '%s' "$OUT" | grep -q 'OPERATOR-Q7' \
  && ok "the dispatcher surfaces the question rather than swallowing it" \
  || bad "the dispatcher surfaces the question rather than swallowing it"
printf '%s' "$OUT" | grep -q 'UNANSWERED' \
  && ok "the output states that nobody answered it" || bad "the output states that nobody answered it"

# ================================================================= case 21
# Cluster 4, the other cause. turn: operator reached by a core § 4 CLOSE, which
# deletes ## Blocker and ## Next action. The stop is still correct; the message
# must not claim an unanswered question that the closing record does not contain.
# Exposed live on 2026-08-05 by the two-worktree parallel proof: both tasks
# closed, and both printed "The question below is UNANSWERED" above nothing.
echo
echo "Case 21 — turn: operator reached by a close is announced as a close, not as a question"
d="$(new_sandbox)"; state_file "$d" "closed-task" "claude"
CLOSE_TASK='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls";
      { printf -- "---\ntask: %s\nstatus: closed\nturn: operator\n---\n\n" "$WL_TASK";
        printf "## Outcome\nUnit 1 done.\n\n";
        printf "## Decisions that matter\nNone.\n\n";
        printf "## Evidence\nCommit deadbeef.\n\n";
        printf "## Accepted limitations\nNone.\n"; } > "$WL_STATE_FILE.tmp";
      mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"'"$COMMIT_IF_CLAUDE"
run_dispatch "$d" closed-task --actor-cmd "$CLOSE_TASK"
expect_rc 0 "$RC" "stops at turn: operator on a close" "$OUT"
[ "$(calls "$d")" = "1" ] && ok "zero further launches after the close" \
                          || bad "zero further launches after the close" "calls=$(calls "$d")"
printf '%s' "$OUT" | grep -q 'UNANSWERED' \
  && bad "the output does not claim an unanswered question" "it printed UNANSWERED for a closed task" \
  || ok "the output does not claim an unanswered question"
printf '%s' "$OUT" | grep -q 'CLOSED' \
  && ok "the output names the close" || bad "the output names the close" "$OUT"

# ================================================================= case 22
# The classification seam case 21 opened. Absence of ## Blocker and ## Next action
# is NECESSARY for a core § 4 closing record and not SUFFICIENT: a Claude hop that
# died after deleting the active fields and before writing the record leaves a file
# with neither section and no closing record either. Calling that "closed" is a
# guess dressed as a verdict, so it must stop for inspection instead.
echo
echo "Case 22 — a malformed turn: operator record is NOT labelled closed"
d="$(new_sandbox)"
cat >"$d/logs/work-loop/partial-task.md" <<'EOF'
---
task: partial-task
status: closed
turn: operator
---

## Objective and scope
A half-written file: the active fields are gone and the closing record was never
finished. Neither a core § 7 question nor a core § 4 closing record.

## Outcome
Unit 1 pro
EOF
git -C "$d" add logs/work-loop/partial-task.md >/dev/null 2>&1
git -C "$d" commit -qm "fixture: partial-task" >/dev/null 2>&1
run_dispatch "$d" partial-task
expect_rc 26 "$RC" "stops 26 on a turn: operator file that is neither shape" "$OUT"
printf '%s' "$OUT" | grep -q 'CLOSED' \
  && bad "a malformed record is not announced as closed" "it printed CLOSED for a partial file" \
  || ok "a malformed record is not announced as closed"
printf '%s' "$OUT" | grep -q 'Recoverable next action' \
  && ok "the stop names a recoverable next action" || bad "the stop names a recoverable next action" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "no actor was launched on the malformed terminal record" \
                          || bad "no actor was launched on the malformed terminal record" "calls=$(calls "$d")"

# A closing record whose four headings are present but joined by a FIFTH surviving
# section is also not a closing record — core § 4 says nothing else survives.
d="$(new_sandbox)"
cat >"$d/logs/work-loop/extra-task.md" <<'EOF'
---
task: extra-task
status: closed
turn: operator
---

## Outcome
Done.

## Decisions that matter
None.

## Evidence
Commit deadbeef.

## Accepted limitations
None.

## Objective and scope
This active field should not have survived the reduction.
EOF
git -C "$d" add logs/work-loop/extra-task.md >/dev/null 2>&1
git -C "$d" commit -qm "fixture: extra-task" >/dev/null 2>&1
run_dispatch "$d" extra-task
expect_rc 26 "$RC" "stops 26 when an active field survived the reduction" "$OUT"

# The four headings present with nothing else, but SHUFFLED. Core § 4 names the
# closing record as an exact shape; "the right sections in some order" is a
# different, weaker claim. A classifier that sorts before comparing cannot see this.
d="$(new_sandbox)"
cat >"$d/logs/work-loop/shuffled-task.md" <<'EOF'
---
task: shuffled-task
status: closed
turn: operator
---

## Evidence
Commit deadbeef.

## Outcome
Done.

## Accepted limitations
None.

## Decisions that matter
None.
EOF
git -C "$d" add logs/work-loop/shuffled-task.md >/dev/null 2>&1
git -C "$d" commit -qm "fixture: shuffled-task" >/dev/null 2>&1
run_dispatch "$d" shuffled-task
expect_rc 26 "$RC" "stops 26 when the four headings are out of core § 4 order" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "no actor was launched on the out-of-order record" \
                          || bad "no actor was launched on the out-of-order record" "calls=$(calls "$d")"

# The four headings in the right order, but one written TWICE. Deduplicating
# before comparing hides this the same way sorting hides the case above.
d="$(new_sandbox)"
cat >"$d/logs/work-loop/dup-task.md" <<'EOF'
---
task: dup-task
status: closed
turn: operator
---

## Outcome
Done.

## Decisions that matter
None.

## Evidence
Commit deadbeef.

## Evidence
Commit cafebabe.

## Accepted limitations
None.
EOF
git -C "$d" add logs/work-loop/dup-task.md >/dev/null 2>&1
git -C "$d" commit -qm "fixture: dup-task" >/dev/null 2>&1
run_dispatch "$d" dup-task
expect_rc 26 "$RC" "stops 26 when a closing section appears twice" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "no actor was launched on the duplicated-section record" \
                          || bad "no actor was launched on the duplicated-section record" "calls=$(calls "$d")"

# ================================================================= case 23
echo
echo "Case 23 — --carry-one carries exactly one hop and exits 0"
# The defect this mode exists for: without --carry-one, a one-hop carry ends at the
# hop limit, which is exit 23 — a failure code for the expected outcome. Both halves
# are asserted here, so the mode cannot silently regress into the old behaviour.
d="$(new_sandbox)"; state_file "$d" "carry-task" "claude"
run_dispatch "$d" carry-task --carry-one --actor-cmd "$FLIP"
expect_rc 0 "$RC" "exits 0 after one carried hop" "$OUT"
[ "$(calls "$d")" = "1" ] && ok "exactly one actor call" || bad "exactly one actor call" "calls=$(calls "$d")"
grep -qx "turn: codex" "$d/logs/work-loop/carry-task.md" \
  && ok "the turn moved claude -> codex" \
  || bad "the turn moved claude -> codex" "$(sed -n '3p' "$d/logs/work-loop/carry-task.md")"
printf '%s' "$OUT" | grep -q "carry-one: the turn moved claude -> codex" \
  && ok "the carry is announced with both turns named" \
  || bad "the carry is announced with both turns named" "$OUT"

# The same fixture WITHOUT --carry-one, to prove the exit code actually differs.
# A green case 23 above means nothing if the default path already returned 0.
d="$(new_sandbox)"; state_file "$d" "carry-task" "claude"
run_dispatch "$d" carry-task --max-hops 1 --actor-cmd "$FLIP"
expect_rc 23 "$RC" "the same single hop WITHOUT --carry-one exits 23 HOP_LIMIT" "$OUT"

# ================================================================= case 24
echo
echo "Case 24 — --carry-one keeps every post-hop guard"
# The mode must be a shorter run, not a weaker one. Each guard below would stop a
# full loop; each must still stop a carry.
d="$(new_sandbox)"
run_dispatch "$d" decoy-mismatch --carry-one --actor-cmd "$FLIP"
expect_rc 14 "$RC" "identity mismatch still stops the carry (14)" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "no actor launched on the mismatched file" \
                          || bad "no actor launched on the mismatched file" "calls=$(calls "$d")"

d="$(new_sandbox)"; state_file "$d" "carry-noop" "claude"
run_dispatch "$d" carry-noop --carry-one --actor-cmd "$NOOP"
expect_rc 22 "$RC" "a no-op actor still stops the carry (22)" "$OUT"

# An actor that edits a path the allowlist does not cover. The carry must fail 24
# rather than reporting a clean one-hop success.
d="$(new_sandbox)"; state_file "$d" "carry-stray" "claude"
STRAY="$FLIP_BODY"'; printf "stray\n" >> "$WL_CHECKOUT/other.txt"'"$COMMIT_IF_CLAUDE"
run_dispatch "$d" carry-stray --carry-one --actor-cmd "$STRAY"
expect_rc 24 "$RC" "an out-of-allowlist change still stops the carry (24)" "$OUT"

# Claude edits the state file and does not commit it — the measured live shape of
# a refused git permission. It must stop the carry, not pass as a moved turn.
d="$(new_sandbox)"; state_file "$d" "carry-uncommitted" "claude"
run_dispatch "$d" carry-uncommitted --carry-one --actor-cmd "$FLIP_BODY"
expect_rc 25 "$RC" "an uncommitted Claude handback still stops the carry (25)" "$OUT"

# ================================================================= case 25
echo
echo "Case 25 — --carry-one on a turn that is already operator"
# Exit 0 here means "nothing to carry", not "a turn was carried". The two are told
# apart by reading turn: from the file, which is why the run says so explicitly.
d="$(new_sandbox)"
cat >"$d/logs/work-loop/closed-task.md" <<'EOF'
---
task: closed-task
status: closed
turn: operator
---

## Outcome
Done.

## Decisions that matter
None.

## Evidence
Commit deadbeef.

## Accepted limitations
None.
EOF
git -C "$d" add logs/work-loop/closed-task.md >/dev/null 2>&1
git -C "$d" commit -qm "fixture: closed-task" >/dev/null 2>&1
run_dispatch "$d" closed-task --carry-one --actor-cmd "$FLIP"
expect_rc 0 "$RC" "exits 0 on turn: operator" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "no actor was launched" || bad "no actor was launched" "calls=$(calls "$d")"
printf '%s' "$OUT" | grep -q "carry-one: the turn moved" \
  && bad "does NOT claim a turn was carried" "$OUT" \
  || ok "does NOT claim a turn was carried"

# ================================================================= case 26
echo
echo "Case 26 — --carry-one --dry-run launches nothing"
d="$(new_sandbox)"; state_file "$d" "carry-dry" "claude"
before="$(shasum -a 256 "$d/logs/work-loop/carry-dry.md" | cut -d' ' -f1)"
run_dispatch "$d" carry-dry --carry-one --dry-run --actor-cmd "$FLIP"
expect_rc 0 "$RC" "exits 0" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "no actor was launched" || bad "no actor was launched" "calls=$(calls "$d")"
[ "$before" = "$(shasum -a 256 "$d/logs/work-loop/carry-dry.md" | cut -d' ' -f1)" ] \
  && ok "the state file is byte-identical afterwards" \
  || bad "the state file is byte-identical afterwards"
printf '%s' "$OUT" | grep -q "carry-one would launch actor 'claude'" \
  && ok "names the actor it would carry" || bad "names the actor it would carry" "$OUT"

# ================================================================= case 27
# Phase 1a. The defect these cases pin down was OBSERVED before it was fixed —
# runs/probe-interruption-2026-08-07.md. The old handler released the lock and let
# the run continue, so a stop attempt UNLOCKED the task instead of ending it.
echo
echo "Case 27 — SIGTERM stops the run, the actor, and the actor's descendants"
d="$(new_sandbox)"; state_file "$d" "sig-task" "claude"
SIGROOT="$SANDBOX_ROOT/sig27"; mkdir -p "$SIGROOT"
# An actor that spawns a grandchild, then hangs. The grandchild is the point:
# `pkill -P` reaches one generation, and a live Claude hop runs deeper than that.
SLOW_ACTOR='( sleep 300 ) & echo "$!" > "'"$SIGROOT"'/gc.pid"; echo $$ > "'"$SIGROOT"'/actor.pid"; sleep 300'
bash "$DISPATCH_BIN" --checkout "$d" --task sig-task --log-dir "$d/runs" \
  --timeout 300 --actor-cmd "$SLOW_ACTOR" >"$SIGROOT/out" 2>&1 &
DPID=$!
for _ in $(seq 1 40); do [ -f "$SIGROOT/gc.pid" ] && break; sleep 0.5; done
sleep 1
APID="$(cat "$SIGROOT/actor.pid" 2>/dev/null)"; GPID="$(cat "$SIGROOT/gc.pid" 2>/dev/null)"
LK="$(task_lock_for "$d" sig-task)"

if [ -z "$APID" ]; then
  bad "the simulated actor started" "no actor pid file; case 27 is inconclusive"
else
  ok "the simulated actor started (pid $APID, grandchild $GPID)"
  kill -TERM "$DPID" 2>/dev/null
  sleep 6
  kill -0 "$DPID" 2>/dev/null && bad "the dispatcher exits on SIGTERM" "still alive 6s later" \
                              || ok "the dispatcher exits on SIGTERM"
  kill -0 "$APID" 2>/dev/null && bad "the actor is terminated" "actor $APID survived" \
                              || ok "the actor is terminated"
  kill -0 "$GPID" 2>/dev/null && bad "the actor's DESCENDANTS are terminated" "grandchild $GPID survived" \
                              || ok "the actor's DESCENDANTS are terminated"
  wait "$DPID" 2>/dev/null; SRC=$?
  expect_rc 28 "$SRC" "exits 28 INTERRUPTED (not 0 — an interrupted run is not a finished one)" "$(cat "$SIGROOT/out")"
  [ -d "$LK" ] && bad "the lock is released" "$LK still held" || ok "the lock is released"
  grep -q "STOP \[28\]" "$SIGROOT/out" && ok "the run log records the interruption" \
                                       || bad "the run log records the interruption" "$(cat "$SIGROOT/out")"
  grep -q "Nothing is retried" "$SIGROOT/out" && ok "states that nothing is retried" \
                                              || bad "states that nothing is retried"
  # The whole point of the old defect: it let a SECOND dispatcher onto the same
  # state file while the first was still running. Now the first is gone, so a
  # second is legitimate — this asserts the lock is not merely leaked.
  kill -KILL "$APID" "$GPID" 2>/dev/null
fi
rm -rf "$LK" 2>/dev/null

# ====================================================== cases 27b .. 27h
# Phase 1a, the escaped-descendant half.
#
# WHAT CHANGED, AND WHY THE OLD EXPECTATION WAS THE DEFECT. Case 27b used to
# assert that a `setsid` descendant SURVIVES the stop, and it was right to: the
# teardown killed a process GROUP, so that was the measured boundary and pinning
# it was better than pretending otherwise. That boundary is now gone. dispatch.sh
# terminates the union of the process group, the recursive ancestry walk and the
# holders of the hop's inherited output descriptor, and VERIFIES the result before
# releasing the lock. So 27b now asserts the opposite outcome — not because the
# old coverage was inconvenient, but because the behaviour it described was the
# thing 1a called a blocker: a stop that leaves a process running is not a stop.
# The surviving limitation is pinned by 27h, which is the honest replacement for
# what 27b used to guard.
#
# Every case below asserts the escapee was REAL before the stop — alive, and
# genuinely outside the actor's process group. Without that, a case could go green
# because the escapee never started, or never escaped.

escapee_is_real() { # actor-pid escapee-pid label -> 0 when the control holds
  local ap="$1" ep="$2" lab="$3" apg epg
  if [ -z "$ep" ] || ! kill -0 "$ep" 2>/dev/null; then
    bad "$lab — control: the escapee is running before the stop" "pid '${ep:-<none>}' is not alive; the case proves nothing"
    return 1
  fi
  apg="$(ps -o pgid= -p "$ap" 2>/dev/null | tr -d ' ')"
  epg="$(ps -o pgid= -p "$ep" 2>/dev/null | tr -d ' ')"
  if [ -z "$apg" ] || [ -z "$epg" ] || [ "$apg" = "$epg" ]; then
    bad "$lab — control: the escapee really left the actor's process group" \
        "actor pgid='$apg' escapee pgid='$epg'; an in-group child would pass this case trivially"
    return 1
  fi
  ok "$lab — control: escapee alive and OUTSIDE the actor's group (actor pgid=$apg, escapee pgid=$epg)"
  return 0
}

must_be_dead() { # pid label
  if [ -n "$1" ] && kill -0 "$1" 2>/dev/null; then bad "$2" "pid $1 survived the stop"; else ok "$2"; fi
}

reap() { local p; for p in "$@"; do [ -n "$p" ] && kill -KILL "$p" 2>/dev/null; done; }

drop_lock() { # sandbox task
  rm -rf "$(task_lock_for "$1" "$2")" "$(checkout_lock_for "$1")" 2>/dev/null
}

# Defined out here, not beside its first user: the degraded-sweep cases that use
# it sit inside the python3 guard below, but case 30d does not, and a host
# without python3 would otherwise reach 30d with this function undefined.
lock_path_for() { # checkout task -> task lock dir (alias kept for its callers)
  task_lock_for "$1" "$2"
}

if ! command -v python3 >/dev/null 2>&1; then
  echo
  echo "Cases 27b-27h — SKIP: python3 unavailable; cannot create a detached session portably"
else

# A descendant in its own session AND process group that also IGNORES SIGTERM.
# The TERM-resistance is what stops the KILL half of the escalation being prose:
# this process can only be removed by SIGKILL.
mk_stubborn() { # pidfile -> actor fragment
  printf '%s' 'python3 -c "
import os, sys, signal, time
os.setsid()
signal.signal(signal.SIGTERM, signal.SIG_IGN)
with open(\"'"$1"'\",\"w\") as f: f.write(str(os.getpid()))
time.sleep(300)
" &'
}

# A double-forked grandchild: re-parented to pid 1 the instant the intermediate
# exits, so no ancestry walk can find it, then exec'd into /bin/sleep so it is
# also a SIP-protected platform binary whose environment cannot be read. This is
# the hardest shape — only the inherited descriptor reaches it.
mk_orphan() { # pidfile -> actor fragment
  printf '%s' 'python3 -c "
import os, sys
if os.fork() > 0: os._exit(0)
os.setsid()
if os.fork() > 0: os._exit(0)
with open(\"'"$1"'\",\"w\") as f: f.write(str(os.getpid()))
os.execv(\"/bin/sleep\", [\"sleep\", \"300\"])
" &'
}

wait_for() { # file [file...] -> waits up to 20s
  local f _
  for _ in $(seq 1 40); do
    local all=1
    for f in "$@"; do [ -s "$f" ] || all=0; done
    [ "$all" -eq 1 ] && return 0
    sleep 0.5
  done
  return 1
}

# ================================================================ case 27b
echo
echo "Case 27b — SIGTERM reaches a TERM-RESISTANT descendant that left the group"
d="$(new_sandbox)"; state_file "$d" "setsid-task" "claude"
SR="$SANDBOX_ROOT/sig27b"; mkdir -p "$SR"
ACT="$(mk_stubborn "$SR/escapee.pid")
    echo \$\$ > \"$SR/actor.pid\"; sleep 300"
bash "$DISPATCH_BIN" --checkout "$d" --task setsid-task --log-dir "$d/runs" \
  --timeout 300 --actor-cmd "$ACT" >"$SR/out" 2>&1 &
DPID=$!
wait_for "$SR/escapee.pid" "$SR/actor.pid"
sleep 1
EPID="$(cat "$SR/escapee.pid" 2>/dev/null)"; APID="$(cat "$SR/actor.pid" 2>/dev/null)"
if escapee_is_real "$APID" "$EPID" "27b"; then
  kill -TERM "$DPID" 2>/dev/null
  sleep 11
  must_be_dead "$APID" "the in-group actor dies"
  must_be_dead "$EPID" "the OUT-OF-GROUP, TERM-RESISTANT descendant is GONE (SIGKILL half proven)"
  wait "$DPID" 2>/dev/null; SRC=$?
  expect_rc 28 "$SRC" "still exits 28 INTERRUPTED" "$(cat "$SR/out")"
  grep -q "teardown verified" "$SR/out" \
    && ok "the run log records a VERIFIED teardown" || bad "the run log records a VERIFIED teardown" "$(cat "$SR/out")"
fi
reap "$EPID" "$APID" "$DPID"
drop_lock "$d" setsid-task

# ================================================================ case 27c
echo
echo "Case 27c — SIGTERM reaches a DOUBLE-FORKED orphan re-parented to pid 1"
d="$(new_sandbox)"; state_file "$d" "orphan-task" "claude"
SR="$SANDBOX_ROOT/sig27c"; mkdir -p "$SR"
ACT="$(mk_orphan "$SR/escapee.pid")
    echo \$\$ > \"$SR/actor.pid\"; sleep 300"
bash "$DISPATCH_BIN" --checkout "$d" --task orphan-task --log-dir "$d/runs" \
  --timeout 300 --actor-cmd "$ACT" >"$SR/out" 2>&1 &
DPID=$!
wait_for "$SR/escapee.pid" "$SR/actor.pid"
sleep 1
EPID="$(cat "$SR/escapee.pid" 2>/dev/null)"; APID="$(cat "$SR/actor.pid" 2>/dev/null)"
# The extra control this case needs: the orphan must really be re-parented, or it
# would be reachable by the ancestry walk and prove nothing about the fd handle.
OPPID="$(ps -o ppid= -p "$EPID" 2>/dev/null | tr -d ' ')"
if [ "$OPPID" = "1" ]; then
  ok "27c — control: the orphan is re-parented to pid 1 (no ancestry link survives)"
else
  bad "27c — control: the orphan is re-parented to pid 1" "ppid is '$OPPID'; the double fork did not take"
fi
if escapee_is_real "$APID" "$EPID" "27c"; then
  kill -TERM "$DPID" 2>/dev/null
  sleep 11
  must_be_dead "$APID" "the in-group actor dies"
  must_be_dead "$EPID" "the ORPHANED, re-parented, SIP-binary descendant is GONE"
  wait "$DPID" 2>/dev/null; SRC=$?
  expect_rc 28 "$SRC" "still exits 28 INTERRUPTED" "$(cat "$SR/out")"
fi
reap "$EPID" "$APID" "$DPID"
drop_lock "$d" orphan-task

# ================================================================ case 27d
echo
echo "Case 27d — SIGINT (the other trap) reaches an escaped descendant too"
d="$(new_sandbox)"; state_file "$d" "sigint-task" "claude"
SR="$SANDBOX_ROOT/sig27d"; mkdir -p "$SR"
ACT="$(mk_stubborn "$SR/escapee.pid")
    echo \$\$ > \"$SR/actor.pid\"; sleep 300"
# `set -m` is load-bearing here, and it took a failing run to find out. A command
# backgrounded from a NON-interactive shell has SIGINT set to IGNORED by POSIX
# rule, and bash cannot trap a signal that was ignored on entry — so without job
# control the dispatcher never saw this signal, ran its actor to completion, and
# the case "failed" for a reason that has nothing to do with the dispatcher. Job
# control gives the child its own process group and default dispositions, which is
# the shape an operator's Ctrl-C actually reaches.
set -m
bash "$DISPATCH_BIN" --checkout "$d" --task sigint-task --log-dir "$d/runs" \
  --timeout 300 --actor-cmd "$ACT" >"$SR/out" 2>&1 &
DPID=$!
set +m
wait_for "$SR/escapee.pid" "$SR/actor.pid"
sleep 1
EPID="$(cat "$SR/escapee.pid" 2>/dev/null)"; APID="$(cat "$SR/actor.pid" 2>/dev/null)"
if escapee_is_real "$APID" "$EPID" "27d"; then
  kill -INT "$DPID" 2>/dev/null
  sleep 11
  must_be_dead "$EPID" "SIGINT clears the escaped descendant (both traps asserted, not assumed shared)"
  wait "$DPID" 2>/dev/null; SRC=$?
  expect_rc 28 "$SRC" "SIGINT also exits 28" "$(cat "$SR/out")"
  grep -q "SIGINT" "$SR/out" && ok "the stop names SIGINT" || bad "the stop names SIGINT" "$(cat "$SR/out")"
fi
reap "$EPID" "$APID" "$DPID"
drop_lock "$d" sigint-task

# ================================================================ case 27e
echo
echo "Case 27e — the PER-ACTOR TIMEOUT path (exit 21) clears escaped descendants"
d="$(new_sandbox)"; state_file "$d" "timeout-esc" "claude"
SR="$SANDBOX_ROOT/sig27e"; mkdir -p "$SR"
ACT="$(mk_stubborn "$SR/escapee.pid")
    $(mk_orphan "$SR/orphan.pid")
    echo \$\$ > \"$SR/actor.pid\"; sleep 300"
( bash "$DISPATCH_BIN" --checkout "$d" --task timeout-esc --log-dir "$d/runs" \
    --timeout 6 --actor-cmd "$ACT" >"$SR/out" 2>&1; echo $? >"$SR/rc" ) &
DPID=$!
wait_for "$SR/escapee.pid" "$SR/orphan.pid" "$SR/actor.pid"
EPID="$(cat "$SR/escapee.pid" 2>/dev/null)"; OPID="$(cat "$SR/orphan.pid" 2>/dev/null)"
APID="$(cat "$SR/actor.pid" 2>/dev/null)"
escapee_is_real "$APID" "$EPID" "27e"
wait "$DPID" 2>/dev/null
sleep 1
expect_rc 21 "$(cat "$SR/rc" 2>/dev/null || echo 99)" "exits 21 ACTOR_TIMEOUT" "$(cat "$SR/out")"
must_be_dead "$EPID" "the timeout path clears the TERM-resistant escapee"
must_be_dead "$OPID" "the timeout path clears the double-forked orphan"
reap "$EPID" "$OPID" "$APID"
drop_lock "$d" timeout-esc

# ================================================================ case 27f
echo
echo "Case 27f — the GLOBAL DEADLINE path (exit 29) clears escaped descendants"
d="$(new_sandbox)"; state_file "$d" "deadline-esc" "claude"
SR="$SANDBOX_ROOT/sig27f"; mkdir -p "$SR"
ACT="$(mk_stubborn "$SR/escapee.pid")
    echo \$\$ > \"$SR/actor.pid\"; sleep 300"
( bash "$DISPATCH_BIN" --checkout "$d" --task deadline-esc --log-dir "$d/runs" \
    --timeout 300 --deadline 6 --actor-cmd "$ACT" >"$SR/out" 2>&1; echo $? >"$SR/rc" ) &
DPID=$!
wait_for "$SR/escapee.pid" "$SR/actor.pid"
EPID="$(cat "$SR/escapee.pid" 2>/dev/null)"; APID="$(cat "$SR/actor.pid" 2>/dev/null)"
escapee_is_real "$APID" "$EPID" "27f"
wait "$DPID" 2>/dev/null
sleep 1
expect_rc 29 "$(cat "$SR/rc" 2>/dev/null || echo 99)" "exits 29 BUDGET_EXHAUSTED" "$(cat "$SR/out")"
must_be_dead "$EPID" "the deadline path clears the escaped descendant"
reap "$EPID" "$APID"
drop_lock "$d" deadline-esc

# ================================================================ case 27g
# The evidence guard. Every case above would go green if the teardown were simply
# killing everything in sight, so this proves the OLD mechanism could not have
# passed them: a group-only TERM, applied to the same escapee, leaves it running.
# It also proves the harness can tell an in-group child from an escaped one.
echo
echo "Case 27g — positive control: a GROUP-ONLY kill does NOT reach these escapees"
SR="$SANDBOX_ROOT/sig27g"; mkdir -p "$SR"
set -m
bash -c "$(mk_stubborn "$SR/escapee.pid")
  ( sleep 300 ) & echo \$! > \"$SR/ingroup.pid\"
  echo \$\$ > \"$SR/actor.pid\"; sleep 300" >"$SR/out" 2>&1 &
CTRL=$!
set +m
wait_for "$SR/escapee.pid" "$SR/ingroup.pid"
sleep 1
EPID="$(cat "$SR/escapee.pid" 2>/dev/null)"; IPID="$(cat "$SR/ingroup.pid" 2>/dev/null)"
CPG="$(ps -o pgid= -p "$CTRL" 2>/dev/null | tr -d ' ')"
kill -TERM -- "-$CPG" 2>/dev/null
sleep 3
if [ -n "$IPID" ] && kill -0 "$IPID" 2>/dev/null; then
  bad "the group-only kill DOES reach an in-group child" "in-group child $IPID survived; the control is broken"
else
  ok "the group-only kill DOES reach an in-group child"
fi
if [ -n "$EPID" ] && kill -0 "$EPID" 2>/dev/null; then
  ok "the group-only kill does NOT reach the escapee — so cases 27b-27f are not passing trivially"
else
  bad "the group-only kill does NOT reach the escapee" \
      "the escapee died from a group kill alone; the escape shape is wrong and 27b-27f prove nothing"
fi
reap "$EPID" "$IPID" "$CTRL"

# ================================================================ case 27h
# THE RESIDUAL, pinned. This is the honest successor to what old-27b guarded.
#
# NOTE THE SHAPE CHANGE (2026-08-07 correction). This case used to close only
# fds 0/1/2, because the fd handle then read the hop's `.out` log. The handle now
# reads a PRIVATE marker descriptor, which such a process still holds — so that
# shape is now CAUGHT, and using it here would have quietly turned the residual
# test into a pass that proves nothing. The residual shape is now what a real
# daemon does: `closerange` over every inherited descriptor.
echo
echo "Case 27h — a descendant that closes EVERY inherited descriptor survives, and the claim stays scoped"
d="$(new_sandbox)"; state_file "$d" "residual-task" "claude"
SR="$SANDBOX_ROOT/sig27h"; mkdir -p "$SR"
INVISIBLE='python3 -c "
import os, sys
if os.fork() > 0: os._exit(0)
os.setsid()
if os.fork() > 0: os._exit(0)
with open(\"'"$SR"'/escapee.pid\",\"w\") as f: f.write(str(os.getpid()))
os.closerange(0, 64)
os.execv(\"/bin/sleep\", [\"sleep\", \"300\"])
" &'
ACT="$INVISIBLE
    echo \$\$ > \"$SR/actor.pid\"; sleep 300"
bash "$DISPATCH_BIN" --checkout "$d" --task residual-task --log-dir "$d/runs" \
  --timeout 300 --actor-cmd "$ACT" >"$SR/out" 2>&1 &
DPID=$!
wait_for "$SR/escapee.pid" "$SR/actor.pid"
sleep 1
EPID="$(cat "$SR/escapee.pid" 2>/dev/null)"; APID="$(cat "$SR/actor.pid" 2>/dev/null)"
if escapee_is_real "$APID" "$EPID" "27h"; then
  kill -TERM "$DPID" 2>/dev/null
  sleep 11
  must_be_dead "$APID" "the in-group actor still dies"
  if kill -0 "$EPID" 2>/dev/null; then
    ok "the fd-closing orphan SURVIVES — the residual is real and measured, not assumed"
  else
    bad "the fd-closing orphan SURVIVES — the residual is real and measured" \
        "it died; the teardown reaches further than dispatch.sh claims, so widen that comment and this case"
  fi
  # The claim must be scoped to what the handles can see. An unqualified success
  # line here would be the 1a defect wearing a verification badge.
  if grep -q "no descendant reachable by group, ancestry or inherited descriptor" "$SR/out"; then
    ok "the success line is SCOPED to the handles that were actually checked"
  else
    bad "the success line is SCOPED to the handles that were actually checked" \
        "teardown reported something else: $(grep -i teardown "$SR/out" | head -2)"
  fi
fi
# This case deliberately creates the very escapee 1a exists to prevent. It does
# not leave with one running.
reap "$EPID" "$APID" "$DPID"
sleep 1
if [ -n "$EPID" ] && kill -0 "$EPID" 2>/dev/null; then
  bad "case 27h cleaned up its own escapee" "pid $EPID is STILL running after the case"
else
  ok "case 27h cleaned up its own escapee"
fi
drop_lock "$d" residual-task

# ================================================================ case 27i
# THE NEGATIVE CONTROL for the fd handle, and the regression test for a defect
# this work introduced and had to be told about.
#
# The first version censused holders of the hop's `.out` log. That reached the
# escapees, and it also reached anything ELSE holding the file — an operator's
# `tail -f` was sent TERM and then KILL. Reproduced before the fix: a `tail`
# started outside the run went from ALIVE to GONE across one teardown.
#
# The handle now reads a private per-hop marker descriptor that only descendants
# inherit. This case pins that: an unrelated reader of the hop log must be
# untouched, while the escapee in the same run must still die. Both halves matter
# — asserting only the survival of `tail` would pass on a teardown that had
# stopped working altogether.
echo
echo "Case 27i — an UNRELATED holder of the hop log is never signalled by teardown"
d="$(new_sandbox)"; state_file "$d" "bystander-task" "claude"
SR="$SANDBOX_ROOT/sig27i"; mkdir -p "$SR"
ACT="$(mk_stubborn "$SR/escapee.pid")
    echo \$\$ > \"$SR/actor.pid\"; sleep 300"
bash "$DISPATCH_BIN" --checkout "$d" --task bystander-task --log-dir "$d/runs" \
  --timeout 300 --actor-cmd "$ACT" >"$SR/out" 2>&1 &
DPID=$!
wait_for "$SR/escapee.pid" "$SR/actor.pid"
sleep 1
EPID="$(cat "$SR/escapee.pid" 2>/dev/null)"; APID="$(cat "$SR/actor.pid" 2>/dev/null)"
HOPLOG="$(ls "$d"/runs/*.hop1.claude.out 2>/dev/null | head -1)"
if [ -z "$HOPLOG" ]; then
  bad "27i — control: the hop log exists to be watched" "no hop .out file found"
else
  tail -f "$HOPLOG" >/dev/null 2>&1 &
  BYSTANDER=$!
  sleep 1
  if kill -0 "$BYSTANDER" 2>/dev/null; then
    ok "27i — control: an unrelated reader is holding the hop log ($BYSTANDER)"
  else
    bad "27i — control: an unrelated reader is holding the hop log" "the tail did not start"
  fi
  if escapee_is_real "$APID" "$EPID" "27i"; then
    kill -TERM "$DPID" 2>/dev/null
    sleep 11
    must_be_dead "$EPID" "the escapee still dies (the handle did not stop working)"
    if kill -0 "$BYSTANDER" 2>/dev/null; then
      ok "the UNRELATED reader of the hop log SURVIVES teardown"
    else
      bad "the UNRELATED reader of the hop log SURVIVES teardown" \
          "pid $BYSTANDER was killed — teardown is signalling processes it does not own"
    fi
  fi
  reap "$BYSTANDER"
fi
reap "$EPID" "$APID" "$DPID"
drop_lock "$d" bystander-task

# ================================================================ case 27j
# DISCOVERY FAILURE MUST NOT READ AS SUCCESS.
#
# When `lsof` cannot be found, the fd handle — the only one that reaches an
# escapee at all — is simply absent. The first version printed `teardown verified`
# in that state whenever the two remaining handles happened to come back empty:
# the script's strongest claim, on no evidence. It must now say UNVERIFIED and
# pin the lock.
#
# `lsof` is hidden by giving the dispatcher a PATH without it, while keeping the
# directories its other tools live in.
echo
echo "Case 27j — with lsof absent, teardown reports UNVERIFIED and does not claim success"
d="$(new_sandbox)"; state_file "$d" "degraded-task" "claude"
SR="$SANDBOX_ROOT/sig27j"; mkdir -p "$SR"
# Hide lsof by dropping ONLY the directory it lives in, rather than building a
# PATH of hand-picked symlinks. The hand-built version was tried first and was
# wrong: it silently starved the dispatcher of tools it needs, so the actor never
# started and the case "passed its way" into proving nothing. Removing one
# directory changes exactly one thing.
NOLSOF_PATH="$(printf '%s' "$PATH" | tr ':' '\n' | grep -v "^$(dirname "$(command -v lsof 2>/dev/null || echo /usr/sbin/lsof)")$" | paste -sd: -)"
if PATH="$NOLSOF_PATH" command -v lsof >/dev/null 2>&1; then
  bad "27j — control: lsof is absent from the constructed PATH" "it is still resolvable; the case would prove nothing"
else
  ok "27j — control: lsof is absent from the constructed PATH"
fi
ACT="$(mk_stubborn "$SR/escapee.pid")
    echo \$\$ > \"$SR/actor.pid\"; sleep 300"
PATH="$NOLSOF_PATH" bash "$DISPATCH_BIN" --checkout "$d" --task degraded-task --log-dir "$d/runs" \
  --timeout 300 --actor-cmd "$ACT" >"$SR/out" 2>&1 &
DPID=$!
wait_for "$SR/escapee.pid" "$SR/actor.pid"
sleep 1
EPID="$(cat "$SR/escapee.pid" 2>/dev/null)"; APID="$(cat "$SR/actor.pid" 2>/dev/null)"
if escapee_is_real "$APID" "$EPID" "27j"; then
  kill -TERM "$DPID" 2>/dev/null
  sleep 11
  if grep -q "teardown UNVERIFIED" "$SR/out"; then
    ok "teardown reports UNVERIFIED when a load-bearing handle is unavailable"
  else
    bad "teardown reports UNVERIFIED when a load-bearing handle is unavailable" \
        "output said: $(grep -i teardown "$SR/out" | head -2)"
  fi
  if grep -q "teardown verified" "$SR/out"; then
    bad "a degraded sweep must NOT print the success line" "it printed 'teardown verified' with lsof missing"
  else
    ok "a degraded sweep does NOT print the success line"
  fi
  grep -q "lsof is not installed" "$SR/out" \
    && ok "the reason names the missing handle" || bad "the reason names the missing handle" "$(grep -i unverified -A2 "$SR/out" | head -4)"
  LK="$(task_lock_for "$d" degraded-task)"
  if [ -f "$LK/survivors" ]; then
    ok "the lock is PINNED after an unverified teardown"
  else
    bad "the lock is PINNED after an unverified teardown" "no survivors file at $LK"
  fi
fi
reap "$EPID" "$APID" "$DPID"
drop_lock "$d" degraded-task

# ================================================================ case 27k
# THE LOCK INVARIANT. The plan requires that no second dispatcher is admitted
# while a descendant of the stopped actor may still be alive. Teardown knew about
# survivors and released the lock anyway, because both call sites discarded its
# return value — so the invariant existed only in prose.
#
# A survivor is manufactured here rather than waited for: the escapee that
# teardown cannot see (case 27h's shape) is the one that leaves the lock pinned
# via the UNKNOWN path, so this case uses the lsof-less PATH to make an
# unverifiable teardown deterministic, then asserts what the operator actually
# experiences — a second dispatcher refused, and `--status` saying why.
echo
echo "Case 27k — an unverified teardown REFUSES a second dispatcher (exit 17) and --status explains"
d="$(new_sandbox)"; state_file "$d" "pinned-task" "claude"
SR="$SANDBOX_ROOT/sig27k"; mkdir -p "$SR"
ACT="$(mk_stubborn "$SR/escapee.pid")
    echo \$\$ > \"$SR/actor.pid\"; sleep 300"
PATH="$NOLSOF_PATH" bash "$DISPATCH_BIN" --checkout "$d" --task pinned-task --log-dir "$d/runs" \
  --timeout 300 --actor-cmd "$ACT" >"$SR/out" 2>&1 &
DPID=$!
wait_for "$SR/escapee.pid" "$SR/actor.pid"
sleep 1
EPID="$(cat "$SR/escapee.pid" 2>/dev/null)"; APID="$(cat "$SR/actor.pid" 2>/dev/null)"
kill -TERM "$DPID" 2>/dev/null
sleep 11
wait "$DPID" 2>/dev/null; SRC=$?
expect_rc 28 "$SRC" "the interrupted run still exits 28 (the pin does not change the exit code)" "$(cat "$SR/out")"
# THE rc=0 CONTROL for cases 27ka and 27kb below. Those two only ever assert the
# durable-pin line is ABSENT, so a dispatcher that had stopped printing it at all
# would satisfy both of them and still be wrong. Here it must be PRESENT, on both
# operator channels, and the record it announces must genuinely be on disk —
# otherwise this is rc=2 wearing rc=0's message.
KTL="$(task_lock_for "$d" pinned-task)"
[ -f "$KTL/survivors" ] \
  && ok "27k control: the pin record really WAS written (this is rc=0, not rc=2)" \
  || bad "27k control: the pin record really WAS written (this is rc=0, not rc=2)" "no survivors file at $KTL"
grep -q "the task lock is PINNED at" "$SR/out" \
  && ok "a DURABLE pin announces itself on the terminal" \
  || bad "a DURABLE pin announces itself on the terminal" "$(cat "$SR/out")"
RL="$(ls -t "$d"/runs/*.log 2>/dev/null | head -1)"
if [ -n "$RL" ] && grep -q "the task lock is PINNED at" "$RL"; then
  ok "and the same line reaches the run log"
else
  bad "and the same line reaches the run log" "run log: ${RL:-none found}"
fi
# The invariant, as the next dispatcher experiences it.
run_dispatch "$d" pinned-task --actor-cmd "$NOOP"
expect_rc 17 "$RC" "a SECOND dispatcher is REFUSED while the tree is unaccounted for" "$OUT"
printf '%s' "$OUT" | grep -q "PINNED" \
  && ok "the refusal says the lock is pinned, not merely held" || bad "the refusal says the lock is pinned" "$OUT"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task pinned-task --log-dir "$d/runs" --status 2>&1)"; RC=$?
expect_rc 0 "$RC" "--status stays read-only and exits 0 over a pinned lock" "$OUT"
printf '%s' "$OUT" | grep -q "PINNED LOCK" \
  && ok "--status reports a PINNED LOCK" || bad "--status reports a PINNED LOCK" "$OUT"
if printf '%s' "$OUT" | grep -q "STALE LOCK"; then
  bad "--status must NOT call a pinned lock stale" "it told the operator to remove the one thing holding the invariant"
else
  ok "--status does NOT call a pinned lock stale"
fi
reap "$EPID" "$APID" "$DPID"
drop_lock "$d" pinned-task

# ================================================================ case 27ka
# EVERY PIN RESULT REPORTED AS ITSELF.
#
# The lease library answers a pin with three distinct outcomes — 0 durably
# pinned, 1 nothing owned, 2 owned and pinned but with NO durable record. This
# dispatcher wrote `wl_lease_pin ... || return 0`, which merged 1, 2 and any
# future code into the silent no-owned path. Case 27k above is the rc=0 control.
#
# rc=2 is the outcome that matters. The lock DIRECTORIES are retained and still
# refuse a second dispatcher, but the written reason inside them is gone — so the
# operator meets an unexplained held lock, and the obvious reading (a stale lock,
# safe to delete) is the unsafe one.
#
# FORCED FROM INSIDE THE RUN, not by a seam. The actor command runs after the
# locks are acquired and before teardown pins them, so it puts a DIRECTORY where
# each `survivors` FILE has to go. `>` then cannot create the file for any user,
# root included — no privilege, nothing destructive — and `[ -f ]`, the same test
# acquire and --status recognise a pin by, is false afterwards. Same device the
# library's own suite uses.
echo
echo "Case 27ka — a pin whose RECORD did not persist is reported, not silently swallowed"
d="$(new_sandbox)"; state_file "$d" "norecord-task" "claude"
SR="$SANDBOX_ROOT/sig27ka"; mkdir -p "$SR"
KTL="$(task_lock_for "$d" norecord-task)"; KCL="$(checkout_lock_for "$d")"
ACT="$(mk_stubborn "$SR/escapee.pid")
    mkdir -p \"$KTL/survivors\" \"$KCL/survivors\"
    echo \$\$ > \"$SR/actor.pid\"; sleep 300"
PATH="$NOLSOF_PATH" bash "$DISPATCH_BIN" --checkout "$d" --task norecord-task --log-dir "$d/runs" \
  --timeout 300 --actor-cmd "$ACT" >"$SR/out" 2>&1 &
DPID=$!
wait_for "$SR/escapee.pid" "$SR/actor.pid"
sleep 1
EPID="$(cat "$SR/escapee.pid" 2>/dev/null)"; APID="$(cat "$SR/actor.pid" 2>/dev/null)"
kill -TERM "$DPID" 2>/dev/null
sleep 11
wait "$DPID" 2>/dev/null; SRC=$?
OUT="$(cat "$SR/out")"
# The forcing control. If the blocking directories were not in place the pin
# would have persisted normally and every assertion below would be about nothing.
if [ -d "$KTL/survivors" ] && [ ! -f "$KTL/survivors" ]; then
  ok "27ka control: the pin record really could not be written"
else
  bad "27ka control: the pin record really could not be written" "at $KTL"
fi
expect_rc 28 "$SRC" "the interrupted run still exits 28 (an unpersisted record does not change it)" "$OUT"
printf '%s' "$OUT" | grep -q "teardown UNVERIFIED" \
  && ok "the teardown warning still stands" || bad "the teardown warning still stands" "$OUT"
printf '%s' "$OUT" | grep -q "pin RECORD could not be persisted" \
  && ok "the dispatcher says the pin RECORD could not be persisted" \
  || bad "the dispatcher says the pin RECORD could not be persisted" "$OUT"
printf '%s' "$OUT" | grep -q "task checkout" \
  && ok "and NAMES the resources whose evidence is missing" \
  || bad "and NAMES the resources whose evidence is missing" "$OUT"
printf '%s' "$OUT" | grep -q "deliberately RETAINED" \
  && ok "and says the lock directories were RETAINED, not released" \
  || bad "and says the lock directories were RETAINED, not released" "$OUT"
printf '%s' "$OUT" | grep -q "second dispatcher is still refused (exit 17)" \
  && ok "and says a second dispatcher is still refused" \
  || bad "and says a second dispatcher is still refused" "$OUT"
printf '%s' "$OUT" | grep -q "removable stale lock" \
  && ok "and warns against reading them as a removable stale lock" \
  || bad "and warns against reading them as a removable stale lock" "$OUT"
# The false success line is the whole failure this case exists to prevent.
if printf '%s' "$OUT" | grep -q "the task lock is PINNED at"; then
  bad "a pin that recorded nothing must NOT print the durable-pin line" "$OUT"
else
  ok "a pin that recorded nothing does NOT print the durable-pin line"
fi
# The run log is this transport's second operator channel, and a warning that
# reaches only the terminal is lost the moment the walk-away run is unattended.
RL="$(ls -t "$d"/runs/*.log 2>/dev/null | head -1)"
if [ -n "$RL" ] && grep -q "pin RECORD could not be persisted" "$RL"; then
  ok "the same warning reaches the run log"
else
  bad "the same warning reaches the run log" "run log: ${RL:-none found}"
fi
[ -d "$KTL" ] && [ -d "$KCL" ] \
  && ok "both lock directories are retained" \
  || bad "both lock directories are retained" "$KTL / $KCL"
# What the operator meets next. The refusal is the reason the directories are
# kept, so it has to survive the missing record.
run_dispatch "$d" norecord-task --actor-cmd "$NOOP"
expect_rc 17 "$RC" "a SECOND dispatcher is still REFUSED with the record missing" "$OUT"
reap "$EPID" "$APID" "$DPID"
rm -rf "$KTL/survivors" "$KCL/survivors"
drop_lock "$d" norecord-task

# ================================================================ case 27kb
# rc=1 stays SILENT, and an unrecognised code is reported as unrecognised.
#
# Neither has a route through the real library from a run that owns its locks, so
# the library's pin is overridden in the SANDBOX copy — the real file everywhere
# else. Committed, because a modified tracked helper is an out-of-allowlist
# working-tree change and the dispatcher would correctly stop on that instead.
stub_pin_rc() { # sandbox, rc, pinned-flag
  printf '\nwl_lease_pin() { WL_LEASE_PINNED=%s; return %s; }\n' "$3" "$2" \
    >>"$1/logs/scripts/work-loop-lease.sh"
  git -C "$1" add -- logs/scripts/work-loop-lease.sh >/dev/null 2>&1
  git -C "$1" commit -qm "stub the pin result" >/dev/null 2>&1
}

pin_result_run() { # sandbox, task, sig-dir -> sets SRC and OUT
  local sd="$1" tk="$2" sr="$3" act dp
  mkdir -p "$sr"
  act="$(mk_stubborn "$sr/escapee.pid")
    echo \$\$ > \"$sr/actor.pid\"; sleep 300"
  PATH="$NOLSOF_PATH" bash "$DISPATCH_BIN" --checkout "$sd" --task "$tk" --log-dir "$sd/runs" \
    --timeout 300 --actor-cmd "$act" >"$sr/out" 2>&1 &
  dp=$!
  wait_for "$sr/escapee.pid" "$sr/actor.pid"
  sleep 1
  kill -TERM "$dp" 2>/dev/null
  sleep 11
  wait "$dp" 2>/dev/null; SRC=$?
  OUT="$(cat "$sr/out")"
  reap "$(cat "$sr/escapee.pid" 2>/dev/null)" "$(cat "$sr/actor.pid" 2>/dev/null)" "$dp"
}

echo
echo "Case 27kb — rc=1 says nothing; an unrecognised pin result says it is unrecognised"
d="$(new_sandbox)"; state_file "$d" "nolock-task" "claude"
stub_pin_rc "$d" 1 0
pin_result_run "$d" nolock-task "$SANDBOX_ROOT/sig27kb1"
expect_rc 28 "$SRC" "rc=1 still exits 28" "$OUT"
if printf '%s' "$OUT" | grep -qE "PINNED|could not be persisted|UNRECOGNISED"; then
  bad "rc=1 says nothing about a lock at all" "$OUT"
else
  ok "rc=1 says nothing about a lock at all"
fi
drop_lock "$d" nolock-task

d="$(new_sandbox)"; state_file "$d" "oddrc-task" "claude"
stub_pin_rc "$d" 3 1
pin_result_run "$d" oddrc-task "$SANDBOX_ROOT/sig27kb2"
expect_rc 28 "$SRC" "an unrecognised pin result still exits 28" "$OUT"
printf '%s' "$OUT" | grep -q "UNRECOGNISED pin result (3)" \
  && ok "the unrecognised code is reported, with the code" \
  || bad "the unrecognised code is reported, with the code" "$OUT"
printf '%s' "$OUT" | grep -q "second dispatcher is still refused (exit 17)" \
  && ok "and says a second dispatcher is still refused" \
  || bad "and says a second dispatcher is still refused" "$OUT"
if printf '%s' "$OUT" | grep -q "the task lock is PINNED at"; then
  bad "an unrecognised result must NOT print the durable-pin line" "$OUT"
else
  ok "an unrecognised result does NOT print the durable-pin line"
fi
drop_lock "$d" oddrc-task

# ==================================================== cases 27L .. 27q
# DISCOVERY FAILURE, ROUTE BY ROUTE.
#
# Case 27j covers ONE route into "cannot establish": lsof missing from PATH.
# The dispatcher has several others, and an untested route is where the first
# correction's bug lived — every call site read the census through a command
# substitution, so the unknown-reason was assigned in a subshell and thrown away,
# and a degraded sweep still printed `teardown verified`. Only 27j caught it.
# So each materially distinct route gets its own fail-capable case, and each
# asserts the same three things: no success line, a reason naming the route, and
# a PINNED lock.
#
# The stubs shadow ONE tool each by prepending a directory to PATH, and every
# stub passes everything it is not simulating through to the real tool. A stub
# that starved the dispatcher of unrelated tools would make a case pass without
# testing anything — that failure mode was hit while building 27j and is the
# reason this helper exists.
mk_stubdir() { # name body -> prints a PATH with the stub first
  local dir real
  dir="$(mktemp -d "$SANDBOX_ROOT/stub-$1.XXXXXX")"
  real="$(command -v "$1" 2>/dev/null)"
  {
    printf '#!/bin/bash\n'
    printf 'REAL=%q\n' "$real"
    printf '%s\n' "$2"
  } >"$dir/$1"
  chmod +x "$dir/$1"
  printf '%s:%s' "$dir" "$PATH"
}

# Asserts the shared shape of every degraded-sweep case, so the six cases below
# differ only in HOW discovery was broken.
assert_unverified() { # label outfile sandbox task reason-pattern
  local lab="$1" out="$2" d="$3" task="$4" pat="$5" LK
  grep -q "teardown UNVERIFIED" "$out" \
    && ok "$lab — reports UNVERIFIED" \
    || bad "$lab — reports UNVERIFIED" "$(grep -i 'teardown' "$out" | head -2)"
  grep -q "teardown verified" "$out" \
    && bad "$lab — must NOT print the success line" "it claimed verified teardown on a sweep that could not look" \
    || ok "$lab — does NOT print the success line"
  grep -q "$pat" "$out" \
    && ok "$lab — the reason names the broken route" \
    || bad "$lab — the reason names the broken route" "$(grep -i -A2 'UNVERIFIED' "$out" | head -4)"
  LK="$(lock_path_for "$d" "$task")"
  [ -f "$LK/survivors" ] \
    && ok "$lab — the lock is PINNED" \
    || bad "$lab — the lock is PINNED" "no survivors file at $LK"
}

# Runs one degraded-sweep case end to end: launch under a stubbed PATH, let the
# actor and its escapee start, SIGTERM the dispatcher, wait out the escalation.
run_degraded() { # sandbox task stubpath extra-setup-fn -> $SR/out
  local d="$1" task="$2" spath="$3" setup="${4:-}"
  ACT="$(mk_stubborn "$SR/escapee.pid")
    echo \$\$ > \"$SR/actor.pid\"; sleep 300"
  PATH="$spath" bash "$DISPATCH_BIN" --checkout "$d" --task "$task" --log-dir "$d/runs" \
    --timeout 300 --actor-cmd "$ACT" >"$SR/out" 2>&1 &
  DPID=$!
  wait_for "$SR/escapee.pid" "$SR/actor.pid"
  sleep 1
  EPID="$(cat "$SR/escapee.pid" 2>/dev/null)"; APID="$(cat "$SR/actor.pid" 2>/dev/null)"
  [ -n "$setup" ] && "$setup" "$d"
  kill -TERM "$DPID" 2>/dev/null
  sleep 11
  wait "$DPID" 2>/dev/null; SRC=$?
}

# ================================================================ case 27L
# THE SURVIVOR BRANCH, which case 27k does not reach. 27k pins the lock because
# the sweep could not LOOK; this one pins it because the sweep looked, FOUND a
# live descendant, and could not clear it. Those are different code paths —
# TEARDOWN_SURVIVORS versus TEARDOWN_UNKNOWN — and the frozen finding names the
# survivor one.
#
# Forcing "alive and unkillable" without mocking the kill: a root-owned process
# is alive, `ps` confirms it, and `kill` from a non-root uid returns EPERM. Same
# device case 30d already uses for an uninspectable pid. It is injected into the
# census through a stubbed `lsof`, which is the handle that reports marker
# holders — so the dispatcher genuinely believes it is a descendant.
#
# TWO guards, not one, because this case makes the dispatcher signal a pid it
# did not create: the case refuses to run as root, AND it re-checks that the pid
# really is unsignallable before proceeding. Under both guards the TERM and KILL
# are guaranteed no-ops.
echo
echo "Case 27L — a survivor the sweep CAN see but cannot clear pins the lock"
ROOTPID=""
if [ "$(id -u)" -eq 0 ]; then
  bad "case 27L can run (needs a non-root uid so the survivor is unkillable)" \
      "running as root: every pid is killable, so 'sees it but cannot clear it' cannot be forced"
else
  # Lowest root-owned pid above 1 that is not in this test's own ancestry.
  ROOTPID="$(ps -axo pid=,uid= 2>/dev/null | awk '$2==0 && $1>1 {print $1}' | sort -n | head -1)"
  # Alive is established with `ps` and NOT with `kill -0`, because for this pid
  # `kill -0` is expected to fail — that is the whole point of choosing it.
  if [ -z "$ROOTPID" ] || ! ps -p "$ROOTPID" -o pid= >/dev/null 2>&1; then
    bad "case 27L — control: a live root-owned pid is available" \
        "pid '${ROOTPID:-<none>}' is not visible to ps; the case would prove nothing"
    ROOTPID=""
  elif kill -0 "$ROOTPID" 2>/dev/null; then
    bad "case 27L — control: that pid is NOT signallable by this uid" \
        "pid $ROOTPID accepted kill -0, so teardown could really kill it and the case is unsafe"
    ROOTPID=""
  else
    ok "27L — control: pid $ROOTPID is alive (ps) and this uid may NOT signal it (kill -0 refused)"
  fi
fi
if [ -n "$ROOTPID" ]; then
  d="$(new_sandbox)"; state_file "$d" "survivor-task" "claude"
  SR="$SANDBOX_ROOT/sig27L"; mkdir -p "$SR"
  # Real holders, plus one that will never die.
  SP27L="$(mk_stubdir lsof "
out=\"\$(\"\$REAL\" \"\$@\" 2>/dev/null)\"
printf '%s\n' \"\$out\" | grep -v '^\$'
printf '%s\n' $ROOTPID
exit 0")"
  run_degraded "$d" survivor-task "$SP27L"
  expect_rc 28 "$SRC" "the interrupted run still exits 28 (an unclearable survivor does not change it)" "$(cat "$SR/out")"
  grep -q "teardown could NOT confirm" "$SR/out" \
    && ok "teardown reports the survivor rather than claiming success" \
    || bad "teardown reports the survivor rather than claiming success" "$(grep -i teardown "$SR/out" | head -3)"
  grep -q "teardown verified" "$SR/out" \
    && bad "a sweep with a known survivor must NOT print the success line" "it did" \
    || ok "a sweep with a known survivor does NOT print the success line"
  grep -q "Still running:.*$ROOTPID" "$SR/out" \
    && ok "the surviving pid is named in the warning" \
    || bad "the surviving pid is named in the warning" "$(grep -i 'still running' "$SR/out" | head -2)"
  LK="$(lock_path_for "$d" survivor-task)"
  if [ -f "$LK/survivors" ]; then
    ok "the lock is PINNED after a survivor is left behind"
    grep -q "descendants still running:.*$ROOTPID" "$LK/survivors" \
      && ok "the survivors file records the pid, so the operator can find it" \
      || bad "the survivors file records the pid" "$(cat "$LK/survivors")"
  else
    bad "the lock is PINNED after a survivor is left behind" "no survivors file at $LK"
  fi
  # The invariant, as the next dispatcher experiences it.
  run_dispatch "$d" survivor-task --actor-cmd "$NOOP"
  expect_rc 17 "$RC" "a SECOND dispatcher is REFUSED while a known survivor is alive" "$OUT"
  printf '%s' "$OUT" | grep -q "PINNED" \
    && ok "the refusal says the lock is pinned" || bad "the refusal says the lock is pinned" "$OUT"
  OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task survivor-task --log-dir "$d/runs" --status 2>&1)"; RC=$?
  expect_rc 0 "$RC" "--status stays read-only and exits 0 over the pinned lock" "$OUT"
  printf '%s' "$OUT" | grep -q "PINNED LOCK" \
    && ok "--status explains the pin" || bad "--status explains the pin" "$OUT"
  printf '%s' "$OUT" | grep -q "STILL ALIVE NOW" \
    && ok "--status re-checks the recorded pid and says it is still alive" \
    || bad "--status re-checks the recorded pid" "$OUT"
  # The root process must be untouched — the whole case rests on TERM/KILL being
  # refused, so if it died something far worse than a test failure happened.
  # `ps`, not `kill -0`: this pid refuses kill -0 by design, so kill -0 would
  # report "untouched" even if teardown had actually killed it.
  ps -p "$ROOTPID" -o pid= >/dev/null 2>&1 \
    && ok "the unrelated root process is untouched (TERM and KILL were refused, as designed)" \
    || bad "the unrelated root process was killed" "pid $ROOTPID is gone — teardown removed a process it does not own"
  reap "$EPID" "$APID" "$DPID"
  drop_lock "$d" survivor-task
fi

# ================================================================ case 27m
# `ps -ax` FAILING. The group-membership handle is the one that reaches ordinary
# in-group children, so losing it is not cosmetic. The stub fails only the `-ax`
# form; every other ps query the dispatcher makes still works, so this case
# isolates one handle instead of breaking the script.
echo
echo "Case 27m — a FAILING \`ps -ax\` is unknown, not an empty tree"
d="$(new_sandbox)"; state_file "$d" "psfail-task" "claude"
SR="$SANDBOX_ROOT/sig27m"; mkdir -p "$SR"
SP27M="$(mk_stubdir ps '
for a in "$@"; do case "$a" in -ax|-axo|*ax*) exit 1 ;; esac; done
exec "$REAL" "$@"')"
if PATH="$SP27M" ps -ax -o pid= >/dev/null 2>&1; then
  bad "27m — control: \`ps -ax\` really fails under the stub" "it still succeeded; the case would prove nothing"
else
  ok "27m — control: \`ps -ax\` fails under the stub, and other ps forms still work"
  run_degraded "$d" psfail-task "$SP27M"
  expect_rc 28 "$SRC" "the interrupted run still exits 28" "$(cat "$SR/out")"
  assert_unverified "27m" "$SR/out" "$d" psfail-task "ps -ax"
  reap "$EPID" "$APID" "$DPID"
  drop_lock "$d" psfail-task
fi

# ================================================================ case 27n
# `pgrep` FAILING AT RUNTIME, as opposed to being absent. pgrep exits 1 for "no
# matches" and >=2 for its own failure; the first version discarded the exit code
# entirely, so a broken ancestry walk was indistinguishable from an actor with no
# children.
echo
echo "Case 27n — a RUNTIME-FAILING \`pgrep\` is unknown, not a childless actor"
d="$(new_sandbox)"; state_file "$d" "pgrepfail-task" "claude"
SR="$SANDBOX_ROOT/sig27n"; mkdir -p "$SR"
SP27N="$(mk_stubdir pgrep 'echo "pgrep: fatal" >&2; exit 3')"
if PATH="$SP27N" pgrep -P 1 >/dev/null 2>&1; then
  bad "27n — control: pgrep really fails under the stub" "it succeeded; the case would prove nothing"
else
  ok "27n — control: pgrep exits 3 under the stub, and is still ON PATH (so this is failure, not absence)"
  run_degraded "$d" pgrepfail-task "$SP27N"
  expect_rc 28 "$SRC" "the interrupted run still exits 28" "$(cat "$SR/out")"
  assert_unverified "27n" "$SR/out" "$d" pgrepfail-task "pgrep -P"
  reap "$EPID" "$APID" "$DPID"
  drop_lock "$d" pgrepfail-task
fi

# ================================================================ case 27o
# `lsof` FAILING AT RUNTIME. Distinct from 27j (absent) because `lsof -t` exits 1
# both for "nobody holds it" and for its own errors, so the exit code cannot
# separate them and the dispatcher has to read stderr. Sending stderr to
# /dev/null — which the first version did — makes a broken handle look like an
# empty one.
echo
echo "Case 27o — a RUNTIME-FAILING \`lsof\` is unknown, not an unheld marker"
d="$(new_sandbox)"; state_file "$d" "lsoffail-task" "claude"
SR="$SANDBOX_ROOT/sig27o"; mkdir -p "$SR"
SP27O="$(mk_stubdir lsof 'echo "lsof: status error on marker: Permission denied" >&2; exit 1')"
if PATH="$SP27O" lsof -t -- /etc/hosts 2>/dev/null | grep -q .; then
  bad "27o — control: lsof really fails under the stub" "it returned holders; the case would prove nothing"
else
  ok "27o — control: lsof exits 1 with a diagnostic on stderr, and is still ON PATH"
  run_degraded "$d" lsoffail-task "$SP27O"
  expect_rc 28 "$SRC" "the interrupted run still exits 28" "$(cat "$SR/out")"
  assert_unverified "27o" "$SR/out" "$d" lsoffail-task "lsof\` failed on the tree marker"
  reap "$EPID" "$APID" "$DPID"
  drop_lock "$d" lsoffail-task
fi

# ================================================================ case 27p
# THE MARKER GONE. The fd handle is the only one that reaches an escaped
# descendant at all, so if its file has vanished the census has lost the reach
# this whole work exists to provide. Deleted mid-run, which is also the realistic
# shape: a tmp-cleaner, or an operator tidying the runs directory.
echo
echo "Case 27p — a MISSING tree marker is unknown, not an empty census"
d="$(new_sandbox)"; state_file "$d" "nomarker-task" "claude"
SR="$SANDBOX_ROOT/sig27p"; mkdir -p "$SR"
eat_marker() { rm -f "$1"/runs/*.tree 2>/dev/null; }
run_degraded "$d" nomarker-task "$PATH" eat_marker
if ls "$d"/runs/*.tree >/dev/null 2>&1; then
  bad "27p — control: the marker really was removed before the stop" "a .tree file is still present"
else
  ok "27p — control: the marker was removed before the stop"
  expect_rc 28 "$SRC" "the interrupted run still exits 28" "$(cat "$SR/out")"
  assert_unverified "27p" "$SR/out" "$d" nomarker-task "tree marker file is missing"
fi
reap "$EPID" "$APID" "$DPID"
drop_lock "$d" nomarker-task

# ================================================================ case 27q
# ACTOR / DISPATCHER PROCESS-GROUP COLLISION. If `set -m` ever stops isolating the
# actor, the sweep would enumerate the operator's own jobs, so the dispatcher
# refuses to census its own group — and that refusal must read as "cannot
# establish", never as an empty tree.
#
# This case also pins a REAL BUG in the first version of the guard, which compared
# the caller's argument — the actor's *pid* — against the dispatcher's *pgid*.
# Those are different kinds of number and can only match by coincidence, so the
# guard could not fire in the one situation it existed for. The guard now asks
# what group the actor is actually in, which is what this stub manipulates.
echo
echo "Case 27q — an actor sharing the dispatcher's process group is unknown, not empty"
d="$(new_sandbox)"; state_file "$d" "samegroup-task" "claude"
SR="$SANDBOX_ROOT/sig27q"; mkdir -p "$SR"
# Every `-o pgid=` answer becomes the same number, so the actor's group and the
# dispatcher's group are identical however the processes really sit.
SP27Q="$(mk_stubdir ps '
want_pgid=0
for a in "$@"; do case "$a" in pgid=|*pgid=*) want_pgid=1 ;; esac; done
case "$*" in *-ax*) exec "$REAL" "$@" ;; esac
if [ "$want_pgid" -eq 1 ]; then echo "  424242"; exit 0; fi
exec "$REAL" "$@"')"
if [ "$(PATH="$SP27Q" ps -o pgid= -p $$ 2>/dev/null | tr -d ' ')" != "424242" ]; then
  bad "27q — control: the stub really forces one shared pgid" "it did not; the case would prove nothing"
else
  ok "27q — control: every -o pgid= query returns the same group, forcing the collision"
  run_degraded "$d" samegroup-task "$SP27Q"
  expect_rc 28 "$SRC" "the interrupted run still exits 28" "$(cat "$SR/out")"
  assert_unverified "27q" "$SR/out" "$d" samegroup-task "shares this dispatcher's process group"
  reap "$EPID" "$APID" "$DPID"
  drop_lock "$d" samegroup-task
fi

fi   # python3 available

# ================================================================= case 28
echo
echo "Case 28 — --deadline is a deadline, not a start gate"
d="$(new_sandbox)"; state_file "$d" "budget-task" "claude"
# The actor outlives the deadline by a wide margin. If --deadline only gated the
# START of a hop, this would run the full 60s; the clamp must kill it near 3s.
HANG='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls"; sleep 60'
t0="$(date '+%s')"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task budget-task --log-dir "$d/runs" \
      --timeout 60 --deadline 3 --actor-cmd "$HANG" 2>&1)"; RC=$?
elapsed=$(( $(date '+%s') - t0 ))
expect_rc 29 "$RC" "exits 29 BUDGET_EXHAUSTED" "$OUT"
# The bound is asserted from the arithmetic, not from a round number.
#   deadline 3 + 1s poll + TERM_GRACE_SECS 5 + KILL_SETTLE_SECS 2
#             + census/reaping slack 3 = 14
# The previous version of this case accepted anything under 20s, which a 60s
# timeout could have slipped through on a slow machine — too loose to prove a hard
# clock (caught in review, 2026-08-07). If TERM_GRACE_SECS or KILL_SETTLE_SECS
# changes in dispatch.sh, this number changes with it.
#
# RAISED 11 -> 14 on 2026-08-07 by the whole-tree teardown, which adds a SIGKILL
# settle window and a verification census the group-only sweep never ran. That is
# a real, disclosed widening of the worst case, not a loosened test: the plan
# forbids relaxing the hard clock silently, so the arithmetic above and the
# comment in dispatch.sh's effective_timeout state the same new bound.
DEADLINE_CEILING=14
if [ "$elapsed" -le "$DEADLINE_CEILING" ]; then
  ok "terminated within the stated worst case (${elapsed}s <= ${DEADLINE_CEILING}s; the timeout was 60s)"
else
  bad "terminated within the stated worst case" \
      "took ${elapsed}s, bound is ${DEADLINE_CEILING}s (deadline 3 + poll 1 + grace 5 + slack 2)"
fi
printf '%s' "$OUT" | grep -q "THIS IS NOT COMPLETION" \
  && ok "refuses to be read as completion" || bad "refuses to be read as completion" "$OUT"
printf '%s' "$OUT" | grep -qi "resumable\|re-run this dispatcher" \
  && ok "says the work is resumable" || bad "says the work is resumable" "$OUT"

echo
echo "Case 28b — an expired clock REFUSES the next hop rather than starting it"
d="$(new_sandbox)"; state_file "$d" "budget-none" "claude"
# The other half of 1b: a DIFFERENT code path from case 28. Case 28 kills a
# running actor at the clock; this asserts the check at the TOP of the loop, which
# declines to launch at all.
#
# --deadline 1 is what makes the branch deterministic. Whichever way the timing
# falls, the refuse branch is the one that fires: either the clock is already gone
# at the first check (no hop runs), or hop 1's instant actor completes and the
# check before hop 2 finds it gone. What is NOT asserted is the hop count — that
# genuinely is timing-dependent, and asserting it was what made an earlier version
# of this case fail intermittently by landing on the mid-hop kill instead.
#
# The branch is identified by its message: "with turn still" is unique to the
# refuse path; the kill path says "expired during hop".
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task budget-none --log-dir "$d/runs" \
      --timeout 30 --deadline 1 --max-hops 200 --actor-cmd "$FLIP" 2>&1)"; RC=$?
expect_rc 29 "$RC" "exits 29 once the clock is gone" "$OUT"
if printf '%s' "$OUT" | grep -q "with turn still"; then
  ok "the stop is the refuse-to-launch branch (no actor was launched into an expired clock)"
elif printf '%s' "$OUT" | grep -q "expired during hop"; then
  bad "the stop is the refuse-to-launch branch" "took the mid-hop kill path instead — case 28 already covers that"
else
  bad "the stop is the refuse-to-launch branch" "neither 29 message matched: $OUT"
fi
printf '%s' "$OUT" | grep -q "THIS IS NOT COMPLETION" \
  && ok "the refuse branch also refuses to be read as completion" \
  || bad "the refuse branch also refuses to be read as completion" "$OUT"

echo
echo "Case 28c — no --deadline keeps the old unbounded-by-clock behaviour"
d="$(new_sandbox)"; state_file "$d" "nodeadline" "claude"
run_dispatch "$d" nodeadline --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 0 "$RC" "reaches turn: operator and exits 0 with no deadline set" "$OUT"
printf '%s' "$OUT" | grep -q "deadline=none" \
  && ok "states the real upper bound when no deadline is set" || bad "states the real upper bound" "$OUT"

echo
echo "Case 28d — --deadline must be a positive integer"
d="$(new_sandbox)"; state_file "$d" "badbudget" "claude"
run_dispatch "$d" badbudget --deadline abc --actor-cmd "$FLIP"
expect_rc 10 "$RC" "rejects a non-numeric --deadline" "$OUT"
run_dispatch "$d" badbudget --deadline 0 --actor-cmd "$FLIP"
expect_rc 10 "$RC" "rejects --deadline 0" "$OUT"

# ================================================================= case 29
# Phase 1c. Established fact 5 of the plan: foreign_worktree() reads
# `git status --porcelain`, so anything an actor COMMITS leaves a clean tree and
# passes the guard. These cases pin the gap shut.
echo
echo "Case 29 — an actor that COMMITS outside the allowlist is stopped"
d="$(new_sandbox)"; state_file "$d" "commit-task" "claude"
COMMIT_FOREIGN='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls";
  awk "/^turn: /&&!d{print \"turn: codex\"; d=1; next}{print}" "$WL_STATE_FILE" > "$WL_STATE_FILE.tmp";
  mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE";
  printf "actor wrote this\n" > "$WL_CHECKOUT/outside.txt";
  git -C "$WL_CHECKOUT" add -A >/dev/null 2>&1;
  git -C "$WL_CHECKOUT" commit -qm "actor commit outside the allowlist" >/dev/null 2>&1'
run_dispatch "$d" commit-task --actor-cmd "$COMMIT_FOREIGN"
expect_rc 30 "$RC" "exits 30 UNEXPECTED_COMMIT" "$OUT"
printf '%s' "$OUT" | grep -q "outside.txt" \
  && ok "names the committed path" || bad "names the committed path" "$OUT"
printf '%s' "$OUT" | grep -qi "already exists\|detection" \
  && ok "is honest that the commit already happened" || bad "is honest that the commit already happened" "$OUT"
[ "$(calls "$d")" = "1" ] && ok "stopped after the offending hop; no further launch" \
                          || bad "stopped after the offending hop" "calls=$(calls "$d")"

echo
echo "Case 29b — committing INSIDE the allowlist is normal work and passes"
d="$(new_sandbox)"; state_file "$d" "commit-ok" "claude"
run_dispatch "$d" commit-ok --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 0 "$RC" "a Claude hop that commits only the state file reaches operator" "$OUT"

echo
echo "Case 29c — a widened --allow-path admits the same commit"
d="$(new_sandbox)"; state_file "$d" "commit-allowed" "claude"
# --carry-one bounds this to the single hop under test. Without it the turn moves
# to codex and the NEXT hop trips the Codex-moved-HEAD guard instead, which would
# make the assertion pass for the wrong reason.
run_dispatch "$d" commit-allowed --carry-one \
  --allow-path '^logs/work-loop/' --allow-path '^outside\.txt' \
  --actor-cmd "$COMMIT_FOREIGN"
expect_rc 0 "$RC" "the same commit is admitted once its path is allowlisted" "$OUT"
printf '%s' "$OUT" | grep -q "within the allowlist" \
  && ok "reports the commit as allowlisted rather than silently ignoring it" \
  || bad "reports the commit as allowlisted" "$OUT"

# ================================================================= case 30
echo
echo "Case 30 — --status is read-only and takes no lock"
d="$(new_sandbox)"; state_file "$d" "status-task" "claude"
before="$(shasum -a 256 "$d/logs/work-loop/status-task.md" | cut -d' ' -f1)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task status-task --status 2>&1)"; RC=$?
expect_rc 0 "$RC" "exits 0" "$OUT"
[ "$before" = "$(shasum -a 256 "$d/logs/work-loop/status-task.md" | cut -d' ' -f1)" ] \
  && ok "the state file is byte-identical afterwards" || bad "the state file is byte-identical afterwards"
printf '%s' "$OUT" | grep -q "turn=claude" && ok "reports the current turn" || bad "reports the current turn" "$OUT"
printf '%s' "$OUT" | grep -q "none in flight" && ok "reports no run in flight" || bad "reports no run in flight" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "no actor was launched" || bad "no actor was launched" "calls=$(calls "$d")"
# The contract that makes it usable mid-run: it must create nothing.
[ ! -d "$d/runs" ] && ok "created no run-log directory" || bad "created no run-log directory" "$d/runs exists"
LK="$(task_lock_for "$d" status-task)"
[ ! -d "$LK" ] && ok "acquired no lock" || { bad "acquired no lock" "$LK exists"; rm -rf "$LK"; }

echo
echo "Case 30b — --status detects a run in flight and does not disturb it"
d="$(new_sandbox)"; state_file "$d" "inflight" "claude"
SIGROOT="$SANDBOX_ROOT/sig30"; mkdir -p "$SIGROOT"
SLOW='echo $$ > "'"$SIGROOT"'/actor.pid"; sleep 300'
bash "$DISPATCH_BIN" --checkout "$d" --task inflight --log-dir "$d/runs" \
  --timeout 300 --actor-cmd "$SLOW" >"$SIGROOT/out" 2>&1 &
DPID=$!
for _ in $(seq 1 40); do [ -f "$SIGROOT/actor.pid" ] && break; sleep 0.5; done
sleep 1
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task inflight --log-dir "$d/runs" --status 2>&1)"; RC=$?
expect_rc 0 "$RC" "exits 0 while another dispatcher holds the lock (17 would be wrong here)" "$OUT"
printf '%s' "$OUT" | grep -q "IN FLIGHT" && ok "reports the run as in flight" || bad "reports the run as in flight" "$OUT"
printf '%s' "$OUT" | grep -q "kill -TERM" && ok "tells the operator how to stop it" || bad "tells the operator how to stop it" "$OUT"
kill -0 "$DPID" 2>/dev/null && ok "the in-flight run is undisturbed by --status" \
                            || bad "the in-flight run is undisturbed by --status" "dispatcher died"
kill -TERM "$DPID" 2>/dev/null; sleep 4
kill -KILL "$DPID" "$(cat "$SIGROOT/actor.pid" 2>/dev/null)" 2>/dev/null
rm -rf "$(task_lock_for "$d" inflight)" "$(checkout_lock_for "$d")" 2>/dev/null

echo
echo "Case 30c — --status and --dry-run are not interchangeable"
d="$(new_sandbox)"; state_file "$d" "bothmodes" "claude"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task bothmodes --status --dry-run 2>&1)"; RC=$?
expect_rc 10 "$RC" "refuses --status --dry-run together rather than silently picking one" "$OUT"

# ================================================================ case 30d/e
# The Phase 0 § 0b item 3 defect: `--status` reported a genuinely live dispatcher
# (pid 79266) as STALE LOCK because sandbox policy refused `kill -0`, and then
# told the operator to `rm -rf` the live lock.
#
# Cases 30–30c did not catch it, because they all run where PID inspection is
# permitted. These two cases are a MATCHED PAIR and only mean something together:
#
#   30d  a pid that cannot be inspected  -> must be UNKNOWN, must not say rm -rf
#   30e  a pid that is positively absent -> must STILL be STALE LOCK
#
# 30e is the positive control. Without it, a "fix" that answered UNKNOWN to every
# failed check would pass 30d while destroying the stale-lock report entirely.
#
# Forcing a real permission denial, with no mocking: pid 1 is launchd. It always
# exists, it is owned by root, and `kill -0 1` as a non-root user returns EPERM
# — the same errno the Codex sandbox produced. That is a genuine uninspectable
# live process, not a simulation of one. It only works as non-root, so the case
# refuses to score itself rather than passing vacuously under root.
#
# `lock_path_for` is defined once, with the 27L-27q degraded-sweep cases above,
# which are the first users of it.

echo
echo "Case 30d — a pid that CANNOT be inspected reports UNKNOWN, never STALE LOCK"
if [ "$(id -u)" -eq 0 ]; then
  bad "case 30d can run (needs a non-root uid so kill -0 1 is refused)" \
      "running as root: pid 1 is inspectable, so the permission-denied state cannot be forced"
else
  d="$(new_sandbox)"; state_file "$d" "denied" "claude"
  LK="$(lock_path_for "$d" denied)"
  mkdir -p "$LK"; printf '1\n' >"$LK/pid"     # pid 1 = alive, uninspectable
  before="$(shasum -a 256 "$d/logs/work-loop/denied.md" | cut -d' ' -f1)"
  OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task denied --status 2>&1)"; RC=$?

  expect_rc 0 "$RC" "exits 0 — the exit-code contract is unchanged by the new state" "$OUT"
  printf '%s' "$OUT" | grep -q "CANNOT INSPECT" \
    && ok "reports UNKNOWN — CANNOT INSPECT" || bad "reports UNKNOWN — CANNOT INSPECT" "$OUT"
  # The regression itself. This is the assertion that fails against the pre-fix
  # dispatcher, which printed STALE LOCK here.
  printf '%s' "$OUT" | grep -q "STALE LOCK" \
    && bad "does NOT claim STALE LOCK about a pid it could not inspect" "$OUT" \
    || ok "does NOT claim STALE LOCK about a pid it could not inspect"
  # The dangerous half of the old output: acting on it corrupts a live run.
  printf '%s' "$OUT" | grep -q "rm -rf" \
    && bad "never recommends removing the lock when it cannot inspect the pid" "$OUT" \
    || ok "never recommends removing the lock when it cannot inspect the pid"
  # The caution this case exists for, now stated about the HOLDER rather than
  # about a dispatcher: this lock is planted with no `program` file, so naming a
  # dispatcher here would be the same guess correction-plan step 5 removed. The
  # caution itself is unchanged and still asserted; 30h(4) covers the holder line.
  printf '%s' "$OUT" | grep -qi "THE HOLDER MAY STILL BE LIVE" \
    && ok "says the holder may still be live" \
    || bad "says the holder may still be live" "$OUT"
  printf '%s' "$OUT" | grep -qi "LIVE DISPATCHER" \
    && bad "does not guess a dispatcher for a lease that records no program" "$OUT" \
    || ok "does not guess a dispatcher for a lease that records no program"
  # UNKNOWN must show its evidence. The first cut of this fix printed an empty
  # reason line: pid_state() set a global, but the caller read it through $( ),
  # which is a subshell, so the assignment was discarded. A blank "why:" would
  # have satisfied every other assertion here.
  printf '%s' "$OUT" | grep -qE '^ *why: *[^ ]' \
    && ok "shows the evidence for the UNKNOWN verdict, not a blank reason" \
    || bad "shows the evidence for the UNKNOWN verdict" "$OUT"
  printf '%s' "$OUT" | grep -qi "why:.*not permitted" \
    && ok "names the permission denial as the reason it cannot inspect" \
    || bad "names the permission denial as the reason" "$OUT"
  # UNKNOWN is still a report, not a shrug: the operator needs the identifiers.
  printf '%s' "$OUT" | grep -q "pid 1" && ok "still identifies the pid" || bad "still identifies the pid" "$OUT"
  printf '%s' "$OUT" | grep -qF "$LK" && ok "still identifies the lock path" || bad "still identifies the lock path" "$OUT"
  printf '%s' "$OUT" | grep -q "turn=claude" \
    && ok "still reports the state file and its turn" || bad "still reports the state file and its turn" "$OUT"
  # Read-only holds in the new branch too — it is the branch most likely to be
  # run against a live dispatcher, so this matters more here than anywhere.
  [ "$before" = "$(shasum -a 256 "$d/logs/work-loop/denied.md" | cut -d' ' -f1)" ] \
    && ok "the state file is byte-identical after an UNKNOWN report" \
    || bad "the state file is byte-identical after an UNKNOWN report"
  [ ! -d "$d/runs" ] && ok "created no run-log directory while reporting UNKNOWN" \
                     || bad "created no run-log directory while reporting UNKNOWN" "$d/runs exists"
  [ "$(calls "$d")" = "0" ] && ok "launched no actor while reporting UNKNOWN" \
                            || bad "launched no actor while reporting UNKNOWN" "calls=$(calls "$d")"
  # --status must not have touched the lock it could not inspect.
  [ -d "$LK" ] && [ "$(cat "$LK/pid")" = "1" ] \
    && ok "left the lock exactly as it found it" || bad "left the lock exactly as it found it"
  rm -rf "$LK"
fi

echo
echo "Case 30e — POSITIVE CONTROL: a pid that IS gone still reports STALE LOCK"
# Guards against a fix that simply answers UNKNOWN to everything. A reaped pid
# yields a real ESRCH, which is the only evidence that proves absence.
d="$(new_sandbox)"; state_file "$d" "reaped" "claude"
LK="$(lock_path_for "$d" reaped)"
mkdir -p "$LK"
DEADPID="$(bash -c 'exec 2>/dev/null; sleep 0 & echo $!')"
wait 2>/dev/null; sleep 1
printf '%s\n' "$DEADPID" >"$LK/pid"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task reaped --status 2>&1)"; RC=$?
expect_rc 0 "$RC" "exits 0" "$OUT"
printf '%s' "$OUT" | grep -q "STALE LOCK" \
  && ok "still reports STALE LOCK for a positively-absent pid" \
  || bad "still reports STALE LOCK for a positively-absent pid" "$OUT"
printf '%s' "$OUT" | grep -q "CANNOT INSPECT" \
  && bad "does not blur a proven-absent pid into UNKNOWN" "$OUT" \
  || ok "does not blur a proven-absent pid into UNKNOWN"
printf '%s' "$OUT" | grep -q "rm -rf" \
  && ok "still tells the operator how to clear a genuinely stale lock" \
  || bad "still tells the operator how to clear a genuinely stale lock" "$OUT"
rm -rf "$LK"

echo
echo "Case 30f — an unreadable or malformed lock pid is UNKNOWN, not STALE LOCK"
# The old code read an empty pid file as "not running" and recommended rm -rf.
# An empty or garbled pid is a failure to inspect, not evidence of death.
d="$(new_sandbox)"; state_file "$d" "nopid" "claude"
LK="$(lock_path_for "$d" nopid)"
mkdir -p "$LK"                                   # lock dir with no pid file at all
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task nopid --status 2>&1)"; RC=$?
expect_rc 0 "$RC" "exits 0" "$OUT"
printf '%s' "$OUT" | grep -q "CANNOT INSPECT" \
  && ok "an absent pid file reports UNKNOWN" || bad "an absent pid file reports UNKNOWN" "$OUT"
printf '%s' "$OUT" | grep -q "rm -rf" \
  && bad "does not recommend removing a lock whose pid it never read" "$OUT" \
  || ok "does not recommend removing a lock whose pid it never read"
printf 'not-a-pid\n' >"$LK/pid"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task nopid --status 2>&1)"; RC=$?
printf '%s' "$OUT" | grep -q "CANNOT INSPECT" \
  && ok "a non-numeric pid reports UNKNOWN" || bad "a non-numeric pid reports UNKNOWN" "$OUT"

# "numeric" is not the same test as "a valid pid". These three were accepted by
# the first cut of the three-state fix, and each produced a confident answer:
#
#   0    kill -0 0 SUCCEEDS — pid 0 means the CALLER'S OWN process group — so
#        --status said "IN FLIGHT — dispatcher pid 0" and instructed
#        "kill -TERM 0", which would signal the operator's own shell.
#   00   same, via the same route.
#   007  reaches kill(2) as pid 7: a true verdict about an unrelated process,
#        printed as a verdict about this lock (observed: STALE LOCK + rm -rf).
#
# A valid pid matches [1-9][0-9]*. Anything else is a corrupt lock, which is a
# thing that cannot be inspected — never a conclusion about the dispatcher.
for BADPID in 0 00 007 0000000; do
  printf '%s\n' "$BADPID" >"$LK/pid"
  OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task nopid --status 2>&1)"; RC=$?
  expect_rc 0 "$RC" "pid '$BADPID': exits 0 (the exit-code contract is unchanged)" "$OUT"
  printf '%s' "$OUT" | grep -q "CANNOT INSPECT" \
    && ok "pid '$BADPID' reports UNKNOWN — CANNOT INSPECT" \
    || bad "pid '$BADPID' reports UNKNOWN — CANNOT INSPECT" "$OUT"
  # No conclusion, and above all no instruction: `kill -TERM 0` and `rm -rf` are
  # the two ways this output can destroy something.
  for FORBIDDEN in "IN FLIGHT" "STALE LOCK" "kill -TERM" "rm -rf"; do
    printf '%s' "$OUT" | grep -qF "$FORBIDDEN" \
      && bad "pid '$BADPID' output contains no '$FORBIDDEN'" "$OUT" \
      || ok "pid '$BADPID' output contains no '$FORBIDDEN'"
  done
done

# The boundary the rule turns on: 1 is the smallest valid pid and must NOT be
# swept up by the zero rule. Without this, "reject 0*" could quietly become
# "reject anything starting with a digit ≤ some bound" and nobody would notice.
printf '1\n' >"$LK/pid"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task nopid --status 2>&1)"; RC=$?
printf '%s' "$OUT" | grep -q "pid 1 " \
  && ok "pid 1 is still treated as a valid pid and inspected" \
  || bad "pid 1 is still treated as a valid pid and inspected" "$OUT"
printf '%s' "$OUT" | grep -qi "not a usable process id" \
  && bad "pid 1 is not rejected by the zero rule" "$OUT" \
  || ok "pid 1 is not rejected by the zero rule"
# 10 exercises the other side: a valid pid that merely CONTAINS a zero.
printf '10\n' >"$LK/pid"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task nopid --status 2>&1)"; RC=$?
printf '%s' "$OUT" | grep -qi "not a usable process id" \
  && bad "a pid containing a zero (10) is not rejected" "$OUT" \
  || ok "a pid containing a zero (10) is not rejected"
rm -rf "$LK"

# ============================================================ case 30g/30h
# THE PROPOSAL'S CASE 22, and the controls that keep it honest.
#
# NUMBERED 30g/30h ON PURPOSE. "Case 22" is already taken in this file by the
# malformed-close case, and the number in the correction plan is the PROPOSAL's
# acceptance-matrix number, not this suite's. Renumbering the local case would
# break every reference to it; naming the proposal's case in the header is the
# cheaper half of the same fix.
#
# WHAT WAS WRONG. `--status` described whoever held a lease as a dispatcher,
# because a dispatcher is the program doing the looking. The lease has recorded
# `program` since it became shared, and the acquisition refusals already read it
# (holder_label, dispatch.sh) — status did not. Against a carrier-held lease it
# therefore printed "IN FLIGHT — dispatcher pid N", which sends an operator
# looking for a process that does not exist, and the checkout-lease line named a
# task while naming no holder at all.
#
# ONE FORMATTER, both surfaces. The correction plan's step 5 fixes the drift at
# its source: refusals and status render the holder through the same function,
# so the two vocabularies cannot separate again. That is why the acquisition
# assertions in cases 12, 12e and 12g moved to the plan's exact wording in the
# same change — they are reading the same formatter these cases read.
#
# 30g uses a REAL carrier holding both leases, because what is under test is
# whether status reads a lease another program actually took. 30h plants its
# leases: it asks what the message SAYS about each recorded-program class, and
# two of those classes (absent, unrecognised) cannot be produced by any program
# that is working correctly.
echo
echo "Case 30g — proposal case 22: --status over a CARRIER-HELD lease names the attended holder"
d="$(new_sandbox)"; state_file "$d" "st-carried" "claude"
CCOUNT="$SANDBOX_ROOT/st22.count"; : >"$CCOUNT"
CSTUB="$SANDBOX_ROOT/st22.stub"
# A long hold: the stub commits to the state file when it finishes, and the
# no-write assertions below must run inside the window where the carrier is
# holding and not yet writing.
make_carry_stub "$CSTUB" "$CCOUNT" "$d/logs/work-loop/st-carried.md" 14
( bash "$CARRY_BIN" --checkout "$d" --task st-carried --claude-bin "$CSTUB" \
    --timeout 60 "${CARRY_ALLOW[@]}" --log-dir "$SANDBOX_ROOT/st22-carry-runs" \
    >/dev/null 2>&1 ) &
carrier=$!
sleep 3
CK22="$(checkout_lock_for "$d")"; TK22="$(task_lock_for "$d" st-carried)"
# Without this the case could pass against a carrier that never took a lease,
# which would make every assertion below a statement about an empty directory.
{ [ -d "$CK22" ] && [ -d "$TK22" ]; } \
  && ok "30g setup — the carrier holds BOTH the task and the checkout lease" \
  || bad "30g setup — the carrier holds BOTH the task and the checkout lease" \
         "checkout=$([ -d "$CK22" ] && echo held || echo absent) task=$([ -d "$TK22" ] && echo held || echo absent)"
REF22="$(lock_root_for "$d")/refusals"
n_ref22="$(ls -1 "$REF22" 2>/dev/null | wc -l | tr -d ' ')"
TREE_BEFORE="$(tree_manifest "$d")"
STATUS_BEFORE="$(git -C "$d" status --porcelain)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task st-carried \
        --log-dir "$d/st22-runs" --status 2>&1)"; RC=$?
TREE_AFTER="$(tree_manifest "$d")"
STATUS_AFTER="$(git -C "$d" status --porcelain)"
expect_rc 0 "$RC" "--status over a carrier-held lease exits 0" "$OUT"
out_has 'checkout-lock: HELD by an attended carry' "$OUT" \
  "  and the CHECKOUT-lease line names the attended carrier"
out_has 'IN FLIGHT — an attended carry' "$OUT" \
  "  and the TASK-lease LIVE line names the attended carrier"
out_lacks 'a dispatcher' "$OUT" \
  "  and calls the carrier a dispatcher nowhere in the report"
# The exact string the old code printed. "a dispatcher" alone would have passed
# against it — it said "dispatcher pid N" — so the negative half needs the
# wording that was actually wrong, or it asserts nothing about this defect.
out_lacks 'dispatcher pid' "$OUT" \
  "  and does not fall back to the old unconditional \"dispatcher pid\" wording"
# READ-ONLY, on every surface it could have touched.
[ ! -e "$d/st22-runs" ] \
  && ok "  and created no run-log directory in the checkout" \
  || bad "  and created no run-log directory in the checkout" "$(ls -a "$d/st22-runs" 2>&1 | tr '\n' ' ')"
[ "$n_ref22" = "$(ls -1 "$REF22" 2>/dev/null | wc -l | tr -d ' ')" ] \
  && ok "  and filed no refusal record" \
  || bad "  and filed no refusal record" "refusal count moved from $n_ref22"
if [ "$TREE_BEFORE" = "$TREE_AFTER" ]; then
  ok "  and every byte of the checkout's working tree is unchanged"
else
  bad "  and every byte of the checkout's working tree is unchanged" \
      "$(diff <(printf '%s\n' "$TREE_BEFORE") <(printf '%s\n' "$TREE_AFTER") | head -10 | tr '\n' ' ')"
fi
[ "$STATUS_BEFORE" = "$STATUS_AFTER" ] \
  && ok "  and git status is unchanged" \
  || bad "  and git status is unchanged" "before [$STATUS_BEFORE] after [$STATUS_AFTER]"
# "Took no lease" is not the same as "created no directory": both lease
# directories already existed. What must hold is that they are still the
# CARRIER'S — a status run that had acquired anything would have rewritten them.
{ [ "$(cat "$CK22/program" 2>/dev/null)" = carry ] && [ "$(cat "$TK22/program" 2>/dev/null)" = carry ]; } \
  && ok "  and both leases still record the carrier as holder, so status took neither" \
  || bad "  and both leases still record the carrier as holder, so status took neither" \
         "checkout=$(cat "$CK22/program" 2>/dev/null) task=$(cat "$TK22/program" 2>/dev/null)"
kill -0 "$carrier" 2>/dev/null \
  && ok "  and the carrier is undisturbed by the status run" \
  || bad "  and the carrier is undisturbed by the status run" "the carrier is gone"
wait "$carrier" 2>/dev/null
# The control. Without it every assertion above would pass just as well against
# a carrier that took its leases and never ran anything.
[ "$(carry_calls "$CCOUNT")" = "1" ] \
  && ok "  control — the carrier that HELD both leases did launch its own actor" \
  || bad "  control — the carrier that HELD both leases did launch its own actor" \
         "launches: $(carry_calls "$CCOUNT")"

echo
echo "Case 30h — --status reports the RECORDED program: a dispatcher, an absent one, an unknown one"
d="$(new_sandbox)"; state_file "$d" "prog-task" "claude"
CKp="$(checkout_lock_for "$d")"; TKp="$(task_lock_for "$d" prog-task)"
# plant_lease records the TEST'S OWN pid, which is alive, so these all reach the
# LIVE branch. The pid states themselves are 30b/30d/30e/30f's subject; what is
# under test here is only which program the LIVE line names.

# (1) THE POSITIVE CONTROL, and it is the load-bearing one. A "fix" that printed
# "an attended carry" unconditionally would satisfy 30g completely and be just
# as wrong as the hard-coded dispatcher it replaced.
plant_lease "$TKp" prog-task "$d" dispatch
plant_lease "$CKp" prog-task "$d" dispatch
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task prog-task --status 2>&1)"; RC=$?
expect_rc 0 "$RC" "a dispatcher-held lease: --status exits 0" "$OUT"
out_has 'checkout-lock: HELD by a dispatcher' "$OUT" \
  "  and the checkout-lease line still names a dispatcher when a dispatcher holds it"
out_has 'IN FLIGHT — a dispatcher' "$OUT" \
  "  and the LIVE line still names a dispatcher when a dispatcher holds it"
out_lacks 'an attended carry' "$OUT" \
  "  control — it does not call a dispatcher an attended carry"
rm -rf "$CKp" "$TKp"

# (2) NO `program` FILE — an older lease, or one caught part-written. Held, and
# reported as unrecorded rather than guessed in either direction.
plant_lease "$TKp" prog-task "$d"
plant_lease "$CKp" prog-task "$d"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task prog-task --status 2>&1)"; RC=$?
expect_rc 0 "$RC" "a lease with no recorded program: --status exits 0" "$OUT"
out_has 'checkout-lock: HELD by a Work Loop run (program unrecorded)' "$OUT" \
  "  and the checkout-lease line says the program is unrecorded"
out_has 'IN FLIGHT — a Work Loop run (program unrecorded)' "$OUT" \
  "  and the LIVE line says the program is unrecorded"
out_lacks 'a dispatcher' "$OUT" "  and does not guess a dispatcher"
out_lacks 'an attended carry' "$OUT" "  and does not guess a carrier either"
rm -rf "$CKp" "$TKp"

# (3) A PROGRAM THIS DISPATCHER DOES NOT KNOW is reported verbatim: a name the
# operator can search for is worth more than "some other run".
plant_lease "$TKp" prog-task "$d" some-future-runner
plant_lease "$CKp" prog-task "$d" some-future-runner
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task prog-task --status 2>&1)"; RC=$?
expect_rc 0 "$RC" "a lease held by an UNKNOWN program: --status exits 0" "$OUT"
out_has 'checkout-lock: HELD by a Work Loop run (some-future-runner)' "$OUT" \
  "  and the checkout-lease line reports the unknown program verbatim"
out_has 'IN FLIGHT — a Work Loop run (some-future-runner)' "$OUT" \
  "  and the LIVE line reports the unknown program verbatim"
rm -rf "$CKp" "$TKp"

# (4) THE UNKNOWN PID PATH, the other half of the plan's "LIVE/UNKNOWN" pair.
# The verdict there is that nothing could be inspected — which is exactly when
# an operator most needs to be told who the lease SAYS holds it. Same real
# permission denial 30d uses: pid 1 is root-owned, so `kill -0 1` returns EPERM
# for any non-root caller.
if [ "$(id -u)" -eq 0 ]; then
  bad "case 30h(4) can run (needs a non-root uid so kill -0 1 is refused)" \
      "running as root: pid 1 is inspectable, so the UNKNOWN state cannot be forced"
else
  plant_lease "$TKp" prog-task "$d" carry
  printf '1\n' >"$TKp/pid"
  OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task prog-task --status 2>&1)"; RC=$?
  expect_rc 0 "$RC" "an UNINSPECTABLE carrier-held lease: --status exits 0" "$OUT"
  printf '%s' "$OUT" | grep -q "CANNOT INSPECT" \
    && ok "  and the verdict is still UNKNOWN — CANNOT INSPECT" \
    || bad "  and the verdict is still UNKNOWN — CANNOT INSPECT" "$OUT"
  out_has 'the lease records its holder as an attended carry' "$OUT" \
    "  and the UNKNOWN branch names the recorded holder rather than assuming a dispatcher"
  out_lacks 'LIVE DISPATCHER' "$OUT" \
    "  and no longer calls an uninspectable carrier a live dispatcher"
  printf '%s' "$OUT" | grep -q "rm -rf" \
    && bad "  and still never recommends removing a lock it could not inspect" "$OUT" \
    || ok "  and still never recommends removing a lock it could not inspect"
  rm -rf "$TKp"
fi

# ================================================================ case 30i
# THE PROPOSAL'S CASE 16 — a pin claims only what the run actually acquired, and
# --status reports exactly that state.
#
# NUMBERED 30i for case 30g's reason: "case 16" is already taken in this file by
# the foreign-unstaged-work case, and the number in the correction plan is the
# PROPOSAL's acceptance-matrix number, not this suite's.
#
# WHAT WAS MISSING, and it is a seam rather than a behaviour. The library's own
# suite proves the pin GUARD (work-loop-lease.test.sh case 6), driving the
# library directly. Nothing proved what the DISPATCHER shows an operator
# standing in front of the resulting half-pinned repository, and that is the
# surface the operator actually reads. A guard nobody can observe is a guard
# whose regression is silent.
#
# WHY THE LIBRARY IS DRIVEN DIRECTLY HERE TOO. wl_lease_acquire rolls the task
# lease back when the checkout lease is refused (work-loop-lease.sh 470-473), so
# "owns the task lease and not the checkout lease" is unreachable through
# acquire alone. The state is real — a run reaches it whenever a resource is
# lost between acquisition and teardown — but the route into it is not, and what
# is under test is the guard and the report, not the route. The library that is
# driven is the SANDBOX's own copy, the same file the dispatcher sources.
#
# THE DISCRIMINATOR IS THE CHECKOUT LEASE, and it is behavioural rather than a
# string. An unowned lease that was wrongly pinned would refuse every later run
# in that checkout permanently; an unowned lease that was correctly left alone
# is an ordinary dead lease the next run reclaims. Part A runs an unrelated task
# and requires it to be ADMITTED; part B pins a genuinely owned checkout lease
# and requires the same run to be REFUSED. Neither half means anything without
# the other: A alone passes against a pin that never writes the checkout lease
# at all, and B alone passes against a pin that writes it unconditionally.
PARTIAL_DRV="$SANDBOX_ROOT/partial-pin.sh"
cat >"$PARTIAL_DRV" <<'DRV'
#!/bin/bash
# Drives the shared lease library to the state proposal case 16 names, then pins.
# A separate process because a lease is held by a PROCESS: this one exits without
# releasing, which is what a stopped run leaves behind.
set -uo pipefail
LIB="$1"; CO="$2"; TK="$3"; MODE="${4:-partial}"; SURV="$5"
# CANONICALIZE FIRST, exactly as the real callers do (dispatch.sh, carry-turn.sh)
# before they reach wl_lease_init. The library hashes the checkout string it is
# GIVEN (work-loop-lease.sh 167) rather than a resolved path, so a driver that
# passed the raw sandbox path would take its checkout lease under a second key —
# on macOS ${TMPDIR} is /var/... and its resolved form is /private/var/... — and
# every assertion here would then be about a directory the dispatcher never
# looks at. The task lease would still line up, because its key is the task id,
# which is what makes this failure quiet.
CO="$(cd "$CO" && pwd -P)" || { printf 'CHECKOUT-UNRESOLVABLE\n'; exit 72; }
. "$LIB" || { printf 'LIB-SOURCE-FAILED\n'; exit 70; }
wl_lease_init "$CO" "$TK" || { printf 'INIT-FAILED\n'; exit 71; }
wl_lease_acquire dispatch "$$" || { printf 'ACQUIRE-REFUSED\n'; exit 17; }
# The disowning IS the case: the run no longer holds the checkout lease when it
# comes to pin. In `both` mode nothing is disowned, which is the control.
[ "$MODE" = partial ] && WL_LEASE_CHECKOUT_OWNED=0
wl_lease_pin "$SURV" "" "$TK"; prc=$?
printf 'PIN rc=%s pinned=%s task_survivors=%s checkout_survivors=%s\n' \
  "$prc" "$WL_LEASE_PINNED" \
  "$([ -f "$WL_LEASE_TASK_DIR/survivors" ] && printf yes || printf no)" \
  "$([ -f "$WL_LEASE_CHECKOUT_DIR/survivors" ] && printf yes || printf no)"
exit 0
DRV

echo
echo "Case 30i — proposal case 16: a PARTIAL acquisition pins only the lease it held, and --status says so"
d="$(new_sandbox)"
state_file "$d" "pin-partial" "claude"
state_file "$d" "pin-other"   "claude"
CKi="$(checkout_lock_for "$d")"; TKi="$(task_lock_for "$d" pin-partial)"
DRVOUT="$(bash "$PARTIAL_DRV" "$d/logs/scripts/work-loop-lease.sh" "$d" pin-partial partial 4242 2>&1)"; RC=$?
expect_rc 0 "$RC" "30i setup — the run acquired both leases, disowned the checkout, then pinned" "$DRVOUT"
out_has 'PIN rc=0 pinned=1' "$DRVOUT" "30i setup — and the pin reports success"
# THE MIRROR CHECK, and it is the one this case was first written without. Both
# lease directories must be where THIS suite derives them, or every assertion
# below is a statement about a path nothing wrote. The task lease alone would
# not catch it: its key is the task id, so it lines up under any checkout
# string, while the checkout lease's key is the checkout path itself.
{ [ -d "$TKi" ] && [ -d "$CKi" ]; } \
  && ok "30i setup — both leases are where this suite derives them, so the case observes the run's own state" \
  || bad "30i setup — both leases are where this suite derives them" \
         "task=$([ -d "$TKi" ] && echo present || echo absent) checkout=$([ -d "$CKi" ] && echo present || echo absent)"
# THE GUARD, on disk. `survivors` is the exact file wl_lease_acquire and
# wl_lease_status recognise a pin by, so this is the state a later process sees.
[ -f "$TKi/survivors" ] \
  && ok "  the OWNED task lease carries the pin evidence" \
  || bad "  the OWNED task lease carries the pin evidence" "no survivors file at $TKi"
[ -f "$CKi/survivors" ] \
  && bad "  and the UNOWNED checkout lease was NOT pinned" "the pin claimed a lease this run did not hold" \
  || ok "  and the UNOWNED checkout lease was NOT pinned"
# --status, read-only, over exactly that half-pinned state.
TREE_BEFORE="$(tree_manifest "$d")"
STATUS_BEFORE="$(git -C "$d" status --porcelain)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task pin-partial \
        --log-dir "$d/pin-runs" --status 2>&1)"; RC=$?
TREE_AFTER="$(tree_manifest "$d")"
STATUS_AFTER="$(git -C "$d" status --porcelain)"
expect_rc 0 "$RC" "--status over a partially pinned repository exits 0" "$OUT"
out_has 'run: PINNED LOCK' "$OUT" \
  "  and --status reports the TASK lease as PINNED"
out_has 'descendants still running: 4242' "$OUT" \
  "  and reads back the pin evidence the operator has to act on"
# The checkout lease is HELD and not pinned, and --status must describe it as
# what it is. A report that promoted it to pinned would tell the operator to go
# and clear two things by hand where one is the answer.
out_has 'checkout-lock: HELD by a dispatcher running task pin-partial' "$OUT" \
  "  and describes the checkout lease as HELD, not as a second pin"
[ ! -e "$d/pin-runs" ] \
  && ok "  and created no run-log directory in the checkout" \
  || bad "  and created no run-log directory in the checkout" "$(ls -a "$d/pin-runs" 2>&1 | tr '\n' ' ')"
[ "$TREE_BEFORE" = "$TREE_AFTER" ] && [ "$STATUS_BEFORE" = "$STATUS_AFTER" ] \
  && ok "  and the working tree and git status are unchanged" \
  || bad "  and the working tree and git status are unchanged" \
         "$(diff <(printf '%s\n' "$TREE_BEFORE") <(printf '%s\n' "$TREE_AFTER") | head -5 | tr '\n' ' ')"
# THE BEHAVIOURAL HALF. An unrelated task in this checkout meets the task lease
# it does not want and the checkout lease that was left unpinned — a dead,
# unpinned lease, which is the one state a later run may reclaim. It must be
# ADMITTED, or the pin silently took the whole checkout with it.
rm -f "$d.calls"
run_dispatch "$d" pin-other --actor-cmd "$FLIP_TO_OPERATOR"
[ "$RC" != "17" ] \
  && ok "  and an UNRELATED task in this checkout is still admitted" \
  || bad "  and an UNRELATED task in this checkout is still admitted" "refused: $OUT"
out_lacks 'its checkout lock is PINNED' "$OUT" \
  "  and is not turned away by a pin on a lease the stopped run never held"
[ "$(calls "$d")" = "1" ] \
  && ok "  control — that unrelated run really launched its actor" \
  || bad "  control — that unrelated run really launched its actor" "launches: $(calls "$d")"
[ -f "$TKi/survivors" ] \
  && ok "  and the genuine pin on the task lease survived all of it" \
  || bad "  and the genuine pin on the task lease survived all of it" "the pin is gone"

echo
echo "Case 30i-b — POSITIVE CONTROL: a FULL acquisition does pin the checkout lease, and it does refuse"
# Without this, every assertion in 30i above is satisfied by a pin that never
# writes a checkout lease under any circumstances.
d="$(new_sandbox)"
state_file "$d" "pin-both"  "claude"
state_file "$d" "pin-other" "claude"
CKb="$(checkout_lock_for "$d")"; TKb="$(task_lock_for "$d" pin-both)"
DRVOUT="$(bash "$PARTIAL_DRV" "$d/logs/scripts/work-loop-lease.sh" "$d" pin-both both 5353 2>&1)"; RC=$?
expect_rc 0 "$RC" "30i-b setup — the run acquired both leases and pinned while holding both" "$DRVOUT"
out_has 'task_survivors=yes checkout_survivors=yes' "$DRVOUT" \
  "  a run that OWNED both leases pins BOTH of them"
[ -f "$CKb/survivors" ] \
  && ok "  and the checkout lease carries pin evidence when the run held it" \
  || bad "  and the checkout lease carries pin evidence when the run held it" "no survivors file at $CKb"
rm -f "$d.calls"
run_dispatch "$d" pin-other --actor-cmd "$FLIP_TO_OPERATOR"
expect_rc 17 "$RC" "  and an unrelated task in this checkout IS refused by that checkout pin" "$OUT"
out_has 'its checkout lock is PINNED' "$OUT" \
  "  and the refusal names the CHECKOUT lock as the pinned resource"
[ "$(calls "$d")" = "0" ] \
  && ok "  and it launched no actor" \
  || bad "  and it launched no actor" "actors ran: $(tr '\n' ';' <"$d.calls" 2>/dev/null)"
rm -rf "$CKb" "$TKb"

# ================================================================= case 31
# --claude-deny had NO dispatcher-level coverage when it was added (caught in
# review, 2026-08-07). --actor-cmd cannot exercise it, because the flag only
# affects the live `claude` branch of launch_actor.
#
# A FAKE claude binary closes that gap without a live model call: it records the
# exact argv the dispatcher built, then behaves like a well-behaved Claude hop
# (flip the turn, commit the state file). What is under test is the dispatcher's
# argument construction — which is the whole of what --claude-deny does.
echo
echo "Case 31 — --claude-deny reaches the Claude child as --disallowedTools"
d="$(new_sandbox)"; state_file "$d" "deny-task" "claude"
FAKE="$SANDBOX_ROOT/fake-claude.sh"
cat >"$FAKE" <<'FAKEEOF'
#!/bin/bash
# Stands in for the claude binary. Records argv, then acts like a good hop.
if [ "${1:-}" = "--version" ]; then echo "0.0.0-fake (test double)"; exit 0; fi
printf '%s\n' "$@" > "$WL_ARGV_FILE"
sf="$WL_SF"
awk '/^turn: /&&!d{print "turn: codex"; d=1; next}{print}' "$sf" > "$sf.tmp" && mv "$sf.tmp" "$sf"
git -C "$WL_CO" add "$sf" >/dev/null 2>&1
git -C "$WL_CO" commit -qm "fake claude hop" >/dev/null 2>&1
exit 0
FAKEEOF
chmod +x "$FAKE"

export WL_ARGV_FILE="$SANDBOX_ROOT/argv-with-deny.txt"
export WL_SF="$d/logs/work-loop/deny-task.md"
export WL_CO="$d"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task deny-task --log-dir "$d/runs" \
      --carry-one --claude-bin "$FAKE" \
      --claude-deny 'Bash(git push:*)' --claude-deny 'WebFetch' 2>&1)"; RC=$?
expect_rc 0 "$RC" "the hop completes with --claude-deny set" "$OUT"
if [ -f "$WL_ARGV_FILE" ]; then
  grep -qx -- "--disallowedTools" "$WL_ARGV_FILE" \
    && ok "--disallowedTools was passed to the child" \
    || bad "--disallowedTools was passed to the child" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  # -F matters: the rule contains ( and *, which grep would otherwise read as a
  # pattern. Without it this assertion fails on an argv that is in fact correct.
  grep -Fqx -- "Bash(git push:*)" "$WL_ARGV_FILE" \
    && ok "the push rule reached the child verbatim, metacharacters intact" \
    || bad "the push rule reached the child verbatim" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  grep -qx -- "WebFetch" "$WL_ARGV_FILE" \
    && ok "a second --claude-deny is passed too (the flag is repeatable)" \
    || bad "a second --claude-deny is passed too" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  grep -qx -- "-p" "$WL_ARGV_FILE" && grep -q "work-loop-v2 deny-task" "$WL_ARGV_FILE" \
    && ok "the normal prompt arguments are unchanged" \
    || bad "the normal prompt arguments are unchanged" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  # P0-F. The attended child must not inherit this checkout's bypassPermissions:
  # the discovery run read `permissionMode: bypassPermissions` off the runtime's
  # own system/init event and the v0.2 plan forbids it for an actor launch.
  # The fix is a launch-time request, so the argv is where it is provable —
  # and it must hold on the --claude-deny branch too, not only the plain one.
  argv_pair "$WL_ARGV_FILE" "--permission-mode" "default" \
    && ok "the attended child is launched with --permission-mode default, even with denies set" \
    || bad "the attended child is launched with --permission-mode default, even with denies set" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
else
  bad "the fake claude binary was invoked" "no argv file at $WL_ARGV_FILE"
fi
printf '%s' "$OUT" | grep -q "claude_deny=Bash(git push:\*) WebFetch" \
  && ok "the run log records the deny rules the run was launched under" \
  || bad "the run log records the deny rules" "$OUT"
printf '%s' "$OUT" | grep -q -- "--permission-mode default" \
  && ok "the logged command states the explicit permission mode (deny branch)" \
  || bad "the logged command states the explicit permission mode (deny branch)" "$OUT"

echo
echo "Case 31b — WITHOUT --claude-deny the child's arguments are unchanged"
d="$(new_sandbox)"; state_file "$d" "nodeny-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-no-deny.txt"
export WL_SF="$d/logs/work-loop/nodeny-task.md"
export WL_CO="$d"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task nodeny-task --log-dir "$d/runs" \
      --carry-one --claude-bin "$FAKE" 2>&1)"; RC=$?
expect_rc 0 "$RC" "the hop completes with no --claude-deny" "$OUT"
if [ -f "$WL_ARGV_FILE" ]; then
  # CHANGED BY O1, deliberately. This assertion used to read "no
  # --disallowedTools is passed when none was asked for" and it was correct
  # until the nested-actor deny set became a default. It is now inverted: the
  # attended path ALWAYS passes --disallowedTools, because NESTED_ACTOR_DENY is
  # never empty. The old assertion is not being relaxed — it is being replaced
  # by the opposite claim, which is the one the dispatcher now makes.
  grep -qx -- "--disallowedTools" "$WL_ARGV_FILE" \
    && ok "--disallowedTools IS passed even with no --claude-deny (the nested-actor default)" \
    || bad "--disallowedTools IS passed even with no --claude-deny" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  # P0-F, the plain attended shape. Separate from case 31's assertion because
  # these are two distinct branches of launch_actor: a fix applied to one of
  # them leaves the other silently inheriting bypassPermissions.
  argv_pair "$WL_ARGV_FILE" "--permission-mode" "default" \
    && ok "the attended child is launched with --permission-mode default with no denies set" \
    || bad "the attended child is launched with --permission-mode default with no denies set" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  # The correction is a permission POLICY, not a bypass. The opposite flag must
  # never appear on any path this suite drives.
  grep -q -- "dangerously-skip-permissions" "$WL_ARGV_FILE" \
    && bad "no --dangerously-skip-permissions is ever passed" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")" \
    || ok "no --dangerously-skip-permissions is ever passed"
else
  bad "the fake claude binary was invoked" "no argv file"
fi
printf '%s' "$OUT" | grep -q "claude_deny=none" \
  && ok "the run log says plainly that no extra tool denial was applied" \
  || bad "the run log says plainly that no extra tool denial was applied" "$OUT"
printf '%s' "$OUT" | grep -q -- "--permission-mode default" \
  && ok "the logged command states the explicit permission mode (plain branch)" \
  || bad "the logged command states the explicit permission mode (plain branch)" "$OUT"
unset WL_ARGV_FILE WL_SF WL_CO

# ================================================================= case 32
# --unattended: the contained 1d profile, wired into the dispatcher.
#
# The same fake-binary technique as case 31, extended in two ways it needed:
# the double now ANSWERS --version (the profile is gated on it) and records the
# environment it was launched with (one layer of the profile is env-only).
#
# What these cases can and cannot prove, stated once so no reader has to infer
# it: they prove the dispatcher REQUESTS the profile — correct argv, correct
# JSON, correct delivery scope, and a gate that fails closed. They cannot prove
# the EFFECTIVE policy inside a real child, because there is no real child here.
# That is runs/probes/unattended-effective-policy.sh, and it is a live check.

FAKE2="$SANDBOX_ROOT/fake-claude-versioned.sh"
cat >"$FAKE2" <<'FAKE2EOF'
#!/bin/bash
# Stands in for the claude binary, with a settable version and an env record.
if [ "${1:-}" = "--version" ]; then echo "${WL_FAKE_VERSION:-2.1.220 (Claude Code)}"; exit 0; fi
printf '%s\n' "$@" > "$WL_ARGV_FILE"
printf 'SCRUB=%s\n' "${CLAUDE_CODE_SUBPROCESS_ENV_SCRUB:-<unset>}" > "$WL_ENV_FILE"
sf="$WL_SF"
awk '/^turn: /&&!d{print "turn: codex"; d=1; next}{print}' "$sf" > "$sf.tmp" && mv "$sf.tmp" "$sf"
git -C "$WL_CO" add "$sf" >/dev/null 2>&1
git -C "$WL_CO" commit -qm "fake claude hop" >/dev/null 2>&1
exit 0
FAKE2EOF
chmod +x "$FAKE2"

# Argv assertions run often enough below to be worth a helper. -F throughout:
# the profile's rules contain (, ) and *, which grep would otherwise interpret.
argv_has()  { grep -Fqx -- "$2" "$1"; }

echo
echo "Case 32 — --unattended builds the contained child argv"
d="$(new_sandbox)"; state_file "$d" "unatt-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-unatt.txt"
export WL_ENV_FILE="$SANDBOX_ROOT/env-unatt.txt"
export WL_SF="$d/logs/work-loop/unatt-task.md"
export WL_CO="$d"
export WL_FAKE_VERSION="2.1.220 (Claude Code)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task unatt-task --log-dir "$d/runs" \
      --carry-one --claude-bin "$FAKE2" --unattended 2>&1)"; RC=$?
expect_rc 0 "$RC" "the hop completes under --unattended" "$OUT"
if [ -f "$WL_ARGV_FILE" ]; then
  argv_has "$WL_ARGV_FILE" "--settings" \
    && ok "the profile is delivered by --settings (CLI scope)" \
    || bad "the profile is delivered by --settings" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  argv_has "$WL_ARGV_FILE" "Bash,Skill" \
    && ok "--tools restricts the child to Bash,Skill (no built-in Read/Edit/Write)" \
    || bad "--tools restricts the child to Bash,Skill" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  argv_has "$WL_ARGV_FILE" "--strict-mcp-config" \
    && ok "--strict-mcp-config loads no MCP tools" \
    || bad "--strict-mcp-config loads no MCP tools" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  argv_has "$WL_ARGV_FILE" "--no-session-persistence" \
    && ok "--no-session-persistence is passed" \
    || bad "--no-session-persistence is passed" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  # Each base deny individually. A single "some deny reached the child" assertion
  # would stay green if the push rule were the one that got dropped.
  for r in 'Bash(git push:*)' 'Bash(git push *)' 'WebFetch' 'WebSearch' 'mcp__*'; do
    argv_has "$WL_ARGV_FILE" "$r" \
      && ok "base deny reached the child verbatim: $r" \
      || bad "base deny reached the child: $r" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  done
  grep -qx -- "-p" "$WL_ARGV_FILE" && grep -q "work-loop-v2 unatt-task" "$WL_ARGV_FILE" \
    && ok "the normal prompt arguments are unchanged under --unattended" \
    || bad "the normal prompt arguments are unchanged" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  # stream-json is what makes the EFFECTIVE tool roster and MCP list auditable:
  # its first event is the product's own system/init. Asserted per-token, because
  # the failure that matters is a silent drop back to --output-format json, which
  # would leave the live probe with nothing but the child's prose to read.
  argv_has "$WL_ARGV_FILE" "stream-json" \
    && ok "--output-format stream-json under --unattended (the hop capture carries system/init)" \
    || bad "--output-format stream-json under --unattended" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  argv_has "$WL_ARGV_FILE" "--verbose" \
    && ok "--verbose accompanies stream-json (required under --print)" \
    || bad "--verbose accompanies stream-json" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  argv_has "$WL_ARGV_FILE" "json" \
    && bad "the plain json output format is NOT used under --unattended" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")" \
    || ok "the plain json output format is NOT used under --unattended"
  # The P0-F attended correction must not leak the other way either. The
  # contained profile is unchanged by that unit, and its authority question is
  # answered by the OS sandbox and the deny set, not by a permission mode.
  argv_has "$WL_ARGV_FILE" "--permission-mode" \
    && bad "no --permission-mode under --unattended (the contained profile is unchanged)" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")" \
    || ok "no --permission-mode under --unattended (the contained profile is unchanged)"
else
  bad "the fake claude binary was invoked" "no argv file at $WL_ARGV_FILE"
fi

echo
echo "Case 32b — the credential-scrub env var actually reaches the child"
# Not a formality. The scrub is the one profile layer that travels by environment
# rather than by flag or settings file, so it is the one layer a shell-scoping
# mistake could drop while every other assertion here stayed green.
if [ -f "$WL_ENV_FILE" ]; then
  grep -qx "SCRUB=1" "$WL_ENV_FILE" \
    && ok "CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1 was set in the child's environment" \
    || bad "CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1 reaches the child" "got: $(cat "$WL_ENV_FILE")"
else
  bad "the child recorded its environment" "no env file at $WL_ENV_FILE"
fi

echo
echo "Case 32c — the generated profile carries every settings-side layer"
PROF="$(ls -t "$d"/runs/*.unattended-settings.json 2>/dev/null | head -1)"
if [ -n "$PROF" ] && [ -s "$PROF" ]; then
  ok "a per-run profile file was written to the evidence directory"
  # Whitespace-tolerant: the assertions are about policy, not about formatting.
  prof_has() { # regex label
    grep -Eq "$1" "$PROF" && ok "$2" || bad "$2" "profile: $PROF"
  }
  prof_has '"enabled"[[:space:]]*:[[:space:]]*true'                  "sandbox.enabled: true"
  prof_has '"failIfUnavailable"[[:space:]]*:[[:space:]]*true'        "sandbox.failIfUnavailable: true — the child fails closed if the sandbox is missing"
  prof_has '"allowUnsandboxedCommands"[[:space:]]*:[[:space:]]*false' "sandbox.allowUnsandboxedCommands: false — no dangerouslyDisableSandbox escape"
  prof_has '"allowedDomains"[[:space:]]*:[[:space:]]*\[\]'           "network.allowedDomains: [] — empty allowlist"
  prof_has '"strictAllowlist"[[:space:]]*:[[:space:]]*true'          "network.strictAllowlist: true — no approval prompt to widen it"
  prof_has '"denyRead"[[:space:]]*:[[:space:]]*\["~/"\]'             "filesystem.denyRead: [\"~/\"] — home is closed to sandboxed Bash"
  prof_has '"disableAllHooks"[[:space:]]*:[[:space:]]*true'          "disableAllHooks: true"
  prof_has '"disableClaudeAiConnectors"[[:space:]]*:[[:space:]]*true' "disableClaudeAiConnectors: true"
  prof_has '"disableRemoteControl"[[:space:]]*:[[:space:]]*true'     "disableRemoteControl: true"
  prof_has '"disableAgentView"[[:space:]]*:[[:space:]]*true'         "disableAgentView: true"
  prof_has '"disableArtifact"[[:space:]]*:[[:space:]]*true'          "disableArtifact: true"
  prof_has '"autoMemoryEnabled"[[:space:]]*:[[:space:]]*false'       "autoMemoryEnabled: false"
  # The child works through sandboxed Bash, so the checkout MUST be readable or
  # the run cannot read the repository it was launched against.
  #
  # Asserted against the CANONICAL path, and that is the point rather than a
  # detail: on macOS the temp path handed to --checkout here is /var/..., which
  # is a symlink to /private/var/.... An allowRead entry naming the symlinked
  # form would not describe the path Seatbelt actually evaluates. The dispatcher
  # canonicalizes --checkout before anything else, so the profile gets the real
  # one — this case would have caught the opposite. (It caught the reverse
  # mistake in this case's own first draft, which compared the raw path.)
  d_canon="$(cd "$d" && pwd -P)"
  grep -Fq "$d_canon" "$PROF" \
    && ok "filesystem.allowRead re-opens the checkout, by its canonical path" \
    || bad "filesystem.allowRead re-opens the checkout by canonical path" "wanted $d_canon in $PROF"

  # The one named exception inside the denied home tree (operator decision A,
  # 2026-08-07). Without it Git exits 128 before touching the repository.
  grep -Fq '"~/.gitconfig"' "$PROF" \
    && ok "filesystem.allowRead re-opens ~/.gitconfig, so Git works inside the child" \
    || bad "filesystem.allowRead re-opens ~/.gitconfig" "profile: $PROF"

  # ...and the guard that the exception STAYED an exception. The operator's
  # decision was "the minimum Git configuration paths, do not broaden home
  # access", so widening is the regression to catch — and it is the kind that
  # would otherwise pass every other assertion in this file. Each pattern below
  # is a way the single file could quietly become a tree.
  prof_allow="$(sed -n '/"allowRead"/,/\]/p' "$PROF")"
  for widened in '"~/"' '"~"' '"~/.config"' '"~/.config/"' '"~/*"' '"~/.*"' '"$HOME"'; do
    if printf '%s' "$prof_allow" | grep -Fq "$widened"; then
      bad "allowRead does not broaden home access" "found $widened in allowRead"
    else
      ok "allowRead does not broaden home access with $widened"
    fi
  done
  # denyRead must still be there. An allowRead exception is only narrow if the
  # broad deny it sits inside is still in force.
  grep -Eq '"denyRead"[[:space:]]*:[[:space:]]*\["~/"\]' "$PROF" \
    && ok "the broad home denyRead is still in force around that exception" \
    || bad "the broad home denyRead is still in force" "profile: $PROF"
  # Exactly three allowRead entries: checkout, git common dir, ~/.gitconfig.
  # A count assertion catches a fourth entry that none of the named patterns above
  # would have anticipated.
  # Count the quoted entries BETWEEN the brackets, so the "allowRead" key itself
  # is not counted as one of its own values.
  n_allow="$(printf '%s' "$prof_allow" | sed -n 's/.*\[\(.*\)\].*/\1/p' | grep -o '"[^"]*"' | wc -l | tr -d ' ')"
  [ "$n_allow" -eq 3 ] \
    && ok "allowRead holds exactly three entries (checkout, git dir, ~/.gitconfig)" \
    || bad "allowRead holds exactly three entries" "counted $n_allow in: $prof_allow"
  # The argv --settings path must be the file that was actually written.
  argv_has "$WL_ARGV_FILE" "$PROF" \
    && ok "the --settings argument points at exactly the profile that was written" \
    || bad "the --settings argument points at the written profile" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
else
  bad "a per-run profile file was written" "nothing matching $d/runs/*.unattended-settings.json"
fi

echo
echo "Case 32d — the profile is NOT delivered through a repository settings file"
# The silent-failure path this whole design is shaped around: strictAllowlist has
# no effect from .claude/settings.json, and on a machine whose USER settings
# already carry the key the mistake is invisible. So assert the negative
# directly — the dispatcher must not have created either repo settings file, and
# the delivered path must not be inside the checkout's .claude/ directory.
if [ -e "$d/.claude/settings.json" ] || [ -e "$d/.claude/settings.local.json" ]; then
  bad "the dispatcher wrote no repository settings file" "found one under $d/.claude/"
else
  ok "the dispatcher wrote no repository settings file"
fi
case "$PROF" in
  "$d"/.claude/*) bad "the profile does not live in the checkout's .claude/ directory" "$PROF" ;;
  *)              ok "the profile does not live in the checkout's .claude/ directory" ;;
esac

echo
echo "Case 32e — the run log records the restrictions and the delivery scope"
printf '%s' "$OUT" | grep -q "unattended=ON" \
  && ok "the log says the run is contained" \
  || bad "the log says the run is contained" "$OUT"
printf '%s' "$OUT" | grep -q "scope: CLI --settings" \
  && ok "the log records the SCOPE the profile arrived through, not just that one was sent" \
  || bad "the log records the delivery scope" "$OUT"
printf '%s' "$OUT" | grep -q "gate: claude 2.1.220 >= 2.1.219" \
  && ok "the log records the version the gate actually read" \
  || bad "the log records the version the gate read" "$OUT"
printf '%s' "$OUT" | grep -q "strictAllowlist=true" \
  && ok "the log names the network policy in force" \
  || bad "the log names the network policy in force" "$OUT"
printf '%s' "$OUT" | grep -q "LIMIT: this records the REQUESTED policy" \
  && ok "the log states plainly that this is the requested, not the effective, policy" \
  || bad "the log states requested-vs-effective" "$OUT"
printf '%s' "$OUT" | grep -q "codex hops are NOT covered" \
  && ok "the log does not let the reader assume Codex hops are contained by this profile" \
  || bad "the log scopes the profile to Claude hops" "$OUT"

echo
echo "Case 32z — CONTROL: the --unattended argv is byte-unchanged"
# O1's own stated control, and the assertion that was missing when a commit on
# 2026-08-11 prepended the nested-actor denies to this path anyway. O1's surface
# is the attended launch only; the contained profile is a separately settled
# artifact that O1 excludes by name.
#
# A FROZEN WHOLE-ARGV COMPARISON, not another set of per-token greps. Every
# assertion in case 32 is "this token is present", and no number of those can
# catch an ADDED argument — which is precisely the regression that landed and
# sat green. This form fails on an addition, a removal, or a reorder.
#
# The expected list is written out literally rather than derived from the
# dispatcher's own deny arrays. Deriving it would make the test agree with
# whatever the source happens to say, which is not evidence.
dz="$(new_sandbox)"; state_file "$dz" "argvfreeze-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-freeze.txt"; rm -f "$WL_ARGV_FILE"
export WL_ENV_FILE="$SANDBOX_ROOT/env-freeze.txt"
export WL_SF="$dz/logs/work-loop/argvfreeze-task.md"
export WL_CO="$dz"
export WL_FAKE_VERSION="2.1.220 (Claude Code)"
OUTZ="$(bash "$DISPATCH_BIN" --checkout "$dz" --task argvfreeze-task --log-dir "$dz/runs" \
       --carry-one --claude-bin "$FAKE2" --unattended 2>&1)"; RCZ=$?
expect_rc 0 "$RCZ" "the contained hop completes" "$OUTZ"
if [ -f "$WL_ARGV_FILE" ]; then
  # The generated per-run profile path is the only volatile token.
  sed 's|^.*/runs/.*\.unattended-settings\.json$|<PROFILE>|' "$WL_ARGV_FILE" \
    >"$SANDBOX_ROOT/argv-freeze.norm"
  cat >"$SANDBOX_ROOT/argv-freeze.want" <<'WANTEOF'
-p
/work-loop-v2 argvfreeze-task
--output-format
stream-json
--verbose
--settings
<PROFILE>
--tools
Bash,Skill
--strict-mcp-config
--no-session-persistence
--disallowedTools
Bash(git push:*)
Bash(git push *)
WebFetch
WebSearch
mcp__*
WANTEOF
  if diff -u "$SANDBOX_ROOT/argv-freeze.want" "$SANDBOX_ROOT/argv-freeze.norm" \
       >"$SANDBOX_ROOT/argv-freeze.diff" 2>&1; then
    ok "the --unattended argv is byte-for-byte the settled contained profile"
  else
    bad "the --unattended argv is byte-for-byte the settled contained profile" \
        "$(cat "$SANDBOX_ROOT/argv-freeze.diff")"
  fi
  # Called out separately from the frozen list because this is the specific
  # widening that landed, and it should read as its own line in the output.
  grep -Fq 'Bash(claude' "$WL_ARGV_FILE" \
    && bad "no nested-actor deny reaches the contained profile" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")" \
    || ok "no nested-actor deny reaches the contained profile"
  # The run log must not describe a policy this argv does not carry.
  printf '%s' "$OUTZ" | grep -q "nested_actor_deny=n/a" \
    && ok "the run log scopes the nested-actor set to attended runs" \
    || bad "the run log scopes the nested-actor set to attended runs" "$OUTZ"
else
  bad "the fake claude binary was invoked" "no argv file at $WL_ARGV_FILE"
fi

echo
echo "Case 32z2 — the --claude-deny append path adds no nested rule either"
# Case 32i already proves the append is additive. This one covers the other place
# a widening could hide: the composed array, when the operator set is non-empty.
dz="$(new_sandbox)"; state_file "$dz" "argvfreeze2-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-freeze2.txt"; rm -f "$WL_ARGV_FILE"
export WL_ENV_FILE="$SANDBOX_ROOT/env-freeze2.txt"
export WL_SF="$dz/logs/work-loop/argvfreeze2-task.md"
export WL_CO="$dz"
export WL_FAKE_VERSION="2.1.220 (Claude Code)"
OUTZ="$(bash "$DISPATCH_BIN" --checkout "$dz" --task argvfreeze2-task --log-dir "$dz/runs" \
       --carry-one --claude-bin "$FAKE2" --unattended --claude-deny 'Bash(rm:*)' 2>&1)"; RCZ=$?
expect_rc 0 "$RCZ" "the contained hop completes with an operator deny" "$OUTZ"
if [ -f "$WL_ARGV_FILE" ]; then
  # The control for the negative below: without it, the negative would pass on a
  # run that never exercised the append path at all.
  argv_has "$WL_ARGV_FILE" 'Bash(rm:*)' \
    && ok "control: the operator rule really did reach the composed array" \
    || bad "control: the operator rule reached the composed array" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  grep -Eq 'Bash\((claude|codex)' "$WL_ARGV_FILE" \
    && bad "the composed array carries no nested-actor rule" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")" \
    || ok "the composed array carries no nested-actor rule"
else
  bad "the fake claude binary was invoked" "no argv file at $WL_ARGV_FILE"
fi

echo
echo "Case 32f — the version gate FAILS CLOSED below 2.1.219"
d="$(new_sandbox)"; state_file "$d" "oldver-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-oldver.txt"; rm -f "$WL_ARGV_FILE"
export WL_ENV_FILE="$SANDBOX_ROOT/env-oldver.txt"
export WL_SF="$d/logs/work-loop/oldver-task.md"
export WL_CO="$d"
export WL_FAKE_VERSION="2.1.218 (Claude Code)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task oldver-task --log-dir "$d/runs" \
      --carry-one --claude-bin "$FAKE2" --unattended 2>&1)"; RC=$?
expect_rc 31 "$RC" "2.1.218 is refused with UNATTENDED_UNAVAILABLE" "$OUT"
[ -f "$WL_ARGV_FILE" ] \
  && bad "nothing launched when the gate refused" "the child ran anyway: $(tr '\n' ' ' <"$WL_ARGV_FILE")" \
  || ok "nothing launched when the gate refused"
printf '%s' "$OUT" | grep -q "strictAllowlist" \
  && ok "the refusal names WHY the version matters, not just that it is old" \
  || bad "the refusal names why the version matters" "$OUT"

echo
echo "Case 32g — the gate passes at exactly 2.1.219, and reads past a build suffix"
d="$(new_sandbox)"; state_file "$d" "minver-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-minver.txt"; rm -f "$WL_ARGV_FILE"
export WL_ENV_FILE="$SANDBOX_ROOT/env-minver.txt"
export WL_SF="$d/logs/work-loop/minver-task.md"
export WL_CO="$d"
export WL_FAKE_VERSION="2.1.219-beta.4 (Claude Code)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task minver-task --log-dir "$d/runs" \
      --carry-one --claude-bin "$FAKE2" --unattended 2>&1)"; RC=$?
expect_rc 0 "$RC" "the boundary version 2.1.219 is accepted, suffix and all" "$OUT"
# A major bump must not be read as "lower" by string comparison.
d="$(new_sandbox)"; state_file "$d" "newver-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-newver.txt"; rm -f "$WL_ARGV_FILE"
export WL_ENV_FILE="$SANDBOX_ROOT/env-newver.txt"
export WL_SF="$d/logs/work-loop/newver-task.md"
export WL_CO="$d"
export WL_FAKE_VERSION="10.0.1 (Claude Code)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task newver-task --log-dir "$d/runs" \
      --carry-one --claude-bin "$FAKE2" --unattended 2>&1)"; RC=$?
expect_rc 0 "$RC" "10.0.1 is accepted — the comparison is numeric, not lexical" "$OUT"

echo
echo "Case 32h — an unreadable version FAILS CLOSED rather than being assumed fine"
d="$(new_sandbox)"; state_file "$d" "noverr-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-noverr.txt"; rm -f "$WL_ARGV_FILE"
export WL_ENV_FILE="$SANDBOX_ROOT/env-noverr.txt"
export WL_SF="$d/logs/work-loop/noverr-task.md"
export WL_CO="$d"
export WL_FAKE_VERSION="claude code, build unknown"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task noverr-task --log-dir "$d/runs" \
      --carry-one --claude-bin "$FAKE2" --unattended 2>&1)"; RC=$?
expect_rc 31 "$RC" "a version string with no dotted number is refused" "$OUT"
[ -f "$WL_ARGV_FILE" ] \
  && bad "nothing launched on an unreadable version" "the child ran anyway" \
  || ok "nothing launched on an unreadable version"
printf '%s' "$OUT" | grep -q "refusing to assume" \
  && ok "the refusal distinguishes 'cannot tell' from 'too old'" \
  || bad "the refusal distinguishes cannot-tell from too-old" "$OUT"

echo
echo "Case 32i — --claude-deny under --unattended is ADDITIVE, never a replacement"
d="$(new_sandbox)"; state_file "$d" "adddeny-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-adddeny.txt"; rm -f "$WL_ARGV_FILE"
export WL_ENV_FILE="$SANDBOX_ROOT/env-adddeny.txt"
export WL_SF="$d/logs/work-loop/adddeny-task.md"
export WL_CO="$d"
export WL_FAKE_VERSION="2.1.220 (Claude Code)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task adddeny-task --log-dir "$d/runs" \
      --carry-one --claude-bin "$FAKE2" --unattended \
      --claude-deny 'Bash(rm:*)' 2>&1)"; RC=$?
expect_rc 0 "$RC" "the hop completes with --unattended plus an extra deny" "$OUT"
if [ -f "$WL_ARGV_FILE" ]; then
  argv_has "$WL_ARGV_FILE" 'Bash(rm:*)' \
    && ok "the operator's extra deny reached the child" \
    || bad "the operator's extra deny reached the child" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  argv_has "$WL_ARGV_FILE" 'Bash(git push:*)' && argv_has "$WL_ARGV_FILE" 'WebFetch' \
    && ok "the base profile denies SURVIVE the extra deny — narrowing only, never widening" \
    || bad "the base profile denies survive" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
else
  bad "the fake claude binary was invoked" "no argv file"
fi

echo
echo "Case 32j — WITHOUT --unattended the child is unchanged (attended and courier)"
d="$(new_sandbox)"; state_file "$d" "attended-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-attended.txt"; rm -f "$WL_ARGV_FILE"
export WL_ENV_FILE="$SANDBOX_ROOT/env-attended.txt"
export WL_SF="$d/logs/work-loop/attended-task.md"
export WL_CO="$d"
export WL_FAKE_VERSION="2.1.220 (Claude Code)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task attended-task --log-dir "$d/runs" \
      --carry-one --claude-bin "$FAKE2" 2>&1)"; RC=$?
expect_rc 0 "$RC" "an ordinary courier hop still completes" "$OUT"
if [ -f "$WL_ARGV_FILE" ]; then
  for f in "--settings" "--tools" "--strict-mcp-config" "--no-session-persistence"; do
    argv_has "$WL_ARGV_FILE" "$f" \
      && bad "no $f without --unattended" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")" \
      || ok "no $f without --unattended"
  done
  # The stream-json switch is scoped to the contained path and nowhere else.
  # Attended and courier hops keep the compact single-object capture they have
  # always had, so required outcome 3 stays true after this change.
  argv_has "$WL_ARGV_FILE" "json" \
    && ok "an attended hop still uses --output-format json" \
    || bad "an attended hop still uses --output-format json" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  for f in "stream-json" "--verbose"; do
    argv_has "$WL_ARGV_FILE" "$f" \
      && bad "no $f without --unattended" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")" \
      || ok "no $f without --unattended"
  done
  # "Unchanged" now means unchanged EXCEPT the explicit permission mode (P0-F).
  # The attended correction is a Claude permission policy; --unattended is OS
  # containment. This case is where the two are kept distinct, so the attended
  # requirement is asserted here as well as in case 31b — a courier hop is the
  # shape the harness actually runs in normal operation.
  argv_pair "$WL_ARGV_FILE" "--permission-mode" "default" \
    && ok "an attended/courier hop asks for --permission-mode default" \
    || bad "an attended/courier hop asks for --permission-mode default" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
else
  bad "the fake claude binary was invoked" "no argv file"
fi
[ -f "$WL_ENV_FILE" ] && grep -qx "SCRUB=<unset>" "$WL_ENV_FILE" \
  && ok "the credential scrub is not set on an attended hop either" \
  || bad "the credential scrub is not set on an attended hop" "got: $(cat "$WL_ENV_FILE" 2>/dev/null)"
ls "$d"/runs/*.unattended-settings.json >/dev/null 2>&1 \
  && bad "no profile file is written without --unattended" "one exists under $d/runs" \
  || ok "no profile file is written without --unattended"
printf '%s' "$OUT" | grep -q "unattended=off" \
  && ok "the log says out loud that a live run is NOT contained" \
  || bad "the log says a live run is not contained" "$OUT"

echo
echo "Case 32k — --unattended refuses to combine with --actor-cmd"
# A simulated actor cannot be contained. Allowing the pair would produce a run
# log reading "unattended" for a run in which no profile reached anything.
d="$(new_sandbox)"; state_file "$d" "simunatt-task" "claude"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task simunatt-task --log-dir "$d/runs" \
      --carry-one --unattended --actor-cmd "$NOOP" 2>&1)"; RC=$?
expect_rc 10 "$RC" "--unattended with --actor-cmd is a usage error" "$OUT"
[ "$(calls "$d")" = "0" ] \
  && ok "the simulated actor was never invoked" \
  || bad "the simulated actor was never invoked" "calls=$(calls "$d")"

echo
echo "Case 32l — --dry-run --unattended is a real preflight"
d="$(new_sandbox)"; state_file "$d" "dryunatt-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-dryunatt.txt"; rm -f "$WL_ARGV_FILE"
export WL_FAKE_VERSION="2.1.220 (Claude Code)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task dryunatt-task --log-dir "$d/runs" \
      --dry-run --claude-bin "$FAKE2" --unattended 2>&1)"; RC=$?
expect_rc 0 "$RC" "a dry run under --unattended passes the gate" "$OUT"
[ -f "$WL_ARGV_FILE" ] \
  && bad "a dry run launches nothing" "the child ran" \
  || ok "a dry run launches nothing"
ls "$d"/runs/*.unattended-settings.json >/dev/null 2>&1 \
  && ok "the profile was written, so the operator can inspect what a live run would use" \
  || bad "the profile was written during the dry run" "nothing under $d/runs"
# And the same dry run must FAIL on a host that could not deliver the profile —
# otherwise it is a preflight that only ever says yes.
export WL_FAKE_VERSION="2.1.218 (Claude Code)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task dryunatt-task --log-dir "$d/runs" \
      --dry-run --claude-bin "$FAKE2" --unattended 2>&1)"; RC=$?
expect_rc 31 "$RC" "the dry-run preflight refuses an under-version host too" "$OUT"
echo
echo "Case 32m — the allowRead minimality guards can actually fail"
# Why this case exists. The red-to-green pair does NOT cover the guards added for
# the operator's 2026-08-07 decision ("allow the minimum Git configuration paths,
# do not broaden home access"). Those assertions live inside a "a profile was
# written" branch, so against the pre-change dispatcher — which writes no profile
# — they do not run at all: the red count stayed 22 while the green pass count
# rose. Assertions that never execute in the red half are not proven capable of
# failing by it, and core § 6 rule 5 wants that shown, not assumed.
#
# So this case builds a real profile from the dispatcher, widens it the ways a
# future edit plausibly would, and asserts the guards go red on each. It is the
# guard on the guard.
d="$(new_sandbox)"; state_file "$d" "widen-task" "claude"
export WL_FAKE_VERSION="2.1.220 (Claude Code)"
bash "$DISPATCH_BIN" --checkout "$d" --task widen-task --log-dir "$d/runs" \
      --dry-run --claude-bin "$FAKE2" --unattended >/dev/null 2>&1
BASEPROF="$(ls -t "$d"/runs/*.unattended-settings.json 2>/dev/null | head -1)"

# The same predicates the real assertions use, applied to an arbitrary file.
# Returns 0 when at least one guard fires — i.e. the file would be rejected.
guards_fire() { # profile-path
  local f="$1" a w n
  a="$(sed -n '/"allowRead"/,/\]/p' "$f")"
  for w in '"~/"' '"~"' '"~/.config"' '"~/.config/"' '"~/*"' '"~/.*"' '"$HOME"'; do
    printf '%s' "$a" | grep -Fq "$w" && return 0
  done
  n="$(printf '%s' "$a" | sed -n 's/.*\[\(.*\)\].*/\1/p' | grep -o '"[^"]*"' | wc -l | tr -d ' ')"
  [ "$n" -ne 3 ] && return 0
  grep -Eq '"denyRead"[[:space:]]*:[[:space:]]*\["~/"\]' "$f" || return 0
  return 1
}

if [ -n "$BASEPROF" ] && [ -s "$BASEPROF" ]; then
  # Positive control first. If the guards fired on the profile that actually
  # ships, they would be catching everything and proving nothing.
  guards_fire "$BASEPROF" \
    && bad "the guards stay silent on the shipping profile" "they fired on $BASEPROF" \
    || ok "the guards stay silent on the shipping profile (positive control)"

  # Each mutation is a way the one-file exception could plausibly become a tree.
  sed 's|"~/.gitconfig"|"~/"|'                        "$BASEPROF" >"$SANDBOX_ROOT/w-home.json"
  sed 's|"~/.gitconfig"|"~/.config"|'                 "$BASEPROF" >"$SANDBOX_ROOT/w-cfgdir.json"
  sed 's|"~/.gitconfig"|"~/.gitconfig", "~/.ssh/id"|' "$BASEPROF" >"$SANDBOX_ROOT/w-extra.json"
  sed 's|"denyRead": \["~/"\]|"denyRead": []|'        "$BASEPROF" >"$SANDBOX_ROOT/w-nodeny.json"

  guards_fire "$SANDBOX_ROOT/w-home.json" \
    && ok "widening the exception to the whole home tree is caught" \
    || bad "widening to the whole home tree is caught" "guards stayed silent"
  guards_fire "$SANDBOX_ROOT/w-cfgdir.json" \
    && ok "widening the exception to a config DIRECTORY is caught" \
    || bad "widening to a config directory is caught" "guards stayed silent"
  # The one a named-pattern list would miss on its own — which is why the entry
  # count assertion exists alongside the patterns.
  guards_fire "$SANDBOX_ROOT/w-extra.json" \
    && ok "an extra fourth allowRead entry is caught, even though it matches no named pattern" \
    || bad "an extra fourth allowRead entry is caught" "guards stayed silent"
  guards_fire "$SANDBOX_ROOT/w-nodeny.json" \
    && ok "removing the broad home denyRead is caught" \
    || bad "removing the broad home denyRead is caught" "guards stayed silent"
else
  bad "a profile was generated for the widening check" "nothing under $d/runs"
fi
echo
echo "Case 32n — the stream-json assertions can actually fail"
# Same reasoning as 32m, applied to the assertions case 32 gained on 2026-08-07.
# The pre-1d dispatcher has no --unattended at all, so case 32 never reaches its
# argv assertions in the red half — the matched pair cannot show them capable of
# failing, and "obviously it would fail" is the phrase that hid the last defect.
#
# So this builds a dispatcher that has --unattended and has REGRESSED the output
# format back to --output-format json, and asserts case 32's three checks flip.
# That regression matters more than it looks: without stream-json the hop capture
# carries no system/init event, and the live probe loses the only surface on
# which the effective tool roster and MCP absence can be measured rather than
# taken from the child's own prose.
d="$(new_sandbox)"; state_file "$d" "regress-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-regress.txt"; rm -f "$WL_ARGV_FILE"
export WL_ENV_FILE="$SANDBOX_ROOT/env-regress.txt"
export WL_SF="$d/logs/work-loop/regress-task.md"
export WL_CO="$d"
export WL_FAKE_VERSION="2.1.220 (Claude Code)"

REGRESSED="$SANDBOX_ROOT/dispatch-regressed.sh"
sed 's|--output-format stream-json --verbose \\|--output-format json \\|' \
    "$DISPATCH_BIN" >"$REGRESSED"
chmod +x "$REGRESSED"

if ! grep -q -- '--output-format json \\' "$REGRESSED"; then
  bad "the regression mutant was actually built" "the sed found nothing to change in $DISPATCH_BIN"
else
  ok "the regression mutant was actually built (stream-json reverted to json)"
  bash "$REGRESSED" --checkout "$d" --task regress-task --log-dir "$d/runs" \
        --carry-one --claude-bin "$FAKE2" --unattended >/dev/null 2>&1
  if [ -f "$WL_ARGV_FILE" ]; then
    argv_has "$WL_ARGV_FILE" "stream-json" \
      && bad "the stream-json assertion goes red on the regressed dispatcher" "it still found stream-json" \
      || ok "the stream-json assertion goes red on the regressed dispatcher"
    argv_has "$WL_ARGV_FILE" "--verbose" \
      && bad "the --verbose assertion goes red on the regressed dispatcher" "it still found --verbose" \
      || ok "the --verbose assertion goes red on the regressed dispatcher"
    # And the inverse assertion — "plain json is NOT used" — must go red too,
    # otherwise it is a check that only ever agrees with itself.
    argv_has "$WL_ARGV_FILE" "json" \
      && ok "the no-plain-json assertion goes red on the regressed dispatcher" \
      || bad "the no-plain-json assertion goes red on the regressed dispatcher" "no plain json in the mutant's argv"
    # The rest of the profile must be untouched by the mutation, or this case
    # would be measuring a broken dispatcher rather than one regressed change.
    argv_has "$WL_ARGV_FILE" "--settings" && argv_has "$WL_ARGV_FILE" "Bash,Skill" \
      && ok "the mutation changed only the output format (the profile still ships)" \
      || bad "the mutation changed only the output format" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  else
    bad "the regressed dispatcher invoked the fake claude binary" "no argv file at $WL_ARGV_FILE"
  fi
fi

unset WL_ARGV_FILE WL_ENV_FILE WL_SF WL_CO WL_FAKE_VERSION

# ============================================ cases 40-45: bounded execution
#
# The O1-O5 outcomes of plans/work-loop-v2-v0.2/bounded-execution-fix-plan-v0.2.md.
# Every case here is SIMULATED like the rest of this suite: no live model, no
# nested AI, no pilot. The two incidents these cover cost 25 minutes and 900
# seconds of real model time respectively; both shapes are reproduced below in
# seconds by a scripted actor, which is the entire argument for doing it this way.
#
# RED/GREEN. Each case below fails against the pre-change dispatcher. Run the
# suite with DISPATCH_BIN pointed at a checkout of the previous dispatch.sh to
# see the red half — that is what makes these assertions evidence rather than
# decoration.

# An allowed implementation file, tracked, so a later modification shows up as
# ' M ' rather than '??'. Both are partial effects; the tracked shape is the one
# incident 2 actually produced.
seed_impl() { # sandbox -> path (repo-relative) on stdout
  local d="$1" p="plans/work-loop-v2-v0.2/handoff-automation-spike/impl.txt"
  printf 'baseline\n' >"$d/$p"
  git -C "$d" add "$p" >/dev/null 2>&1
  git -C "$d" commit -qm "seed impl" >/dev/null 2>&1
  printf '%s' "$p"
}

# Only the PARTIAL FILE EFFECTS block, not the whole run output.
#
# THIS EXISTS BECAUSE THE OBVIOUS ASSERTION IS NOT EVIDENCE. Grepping the full
# output for the modified path passes against the PRE-CHANGE dispatcher too: the
# run log echoes the --actor-cmd verbatim (`launch: mode=simulated … cmd=…`), and
# that command string contains the very path the test is looking for. Measured,
# not theorised — the first cut of cases 41/44/45 stayed green in the red half
# for exactly this reason, which is the "a red half that passes is not evidence"
# trap the plan's verification budget names.
partial_section() { # full-output -> the block from the header to the end
  printf '%s' "$1" | sed -n '/PARTIAL FILE EFFECTS/,$p'
}

echo
echo "Case 40 — O1: the nested-actor denies reach the child, on both attended shapes"
d="$(new_sandbox)"; state_file "$d" "nest-task" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-nested.txt"
export WL_SF="$d/logs/work-loop/nest-task.md"
export WL_CO="$d"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task nest-task --log-dir "$d/runs" \
      --carry-one --claude-bin "$FAKE" 2>&1)"; RC=$?
expect_rc 0 "$RC" "the hop completes with the nested-actor denies in place" "$OUT"
if [ -f "$WL_ARGV_FILE" ]; then
  # -F throughout: these rules carry ( and *, which grep would read as a pattern.
  for rule in 'Bash(claude:*)' 'Bash(claude *)' 'Bash(codex:*)' 'Bash(codex *)'; do
    grep -Fqx -- "$rule" "$WL_ARGV_FILE" \
      && ok "the child is denied $rule" \
      || bad "the child is denied $rule" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  done
  argv_pair "$WL_ARGV_FILE" "--permission-mode" "default" \
    && ok "P0-F still holds — the nested denies did not displace --permission-mode default" \
    || bad "P0-F still holds alongside the nested denies" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
else
  bad "the fake claude binary was invoked" "no argv file"
fi
printf '%s' "$OUT" | grep -Fq "nested_actor_deny=Bash(claude:*)" \
  && ok "the run log records the nested-actor deny set" \
  || bad "the run log records the nested-actor deny set" "$OUT"
# The honesty clause. A deny at the child's permission layer is NOT containment,
# and the plan's § 3.4 makes overclaiming it a defect in its own right. Asserted
# here so a future edit cannot quietly upgrade the wording.
printf '%s' "$OUT" | grep -q "not containment" \
  && ok "the run log states plainly that this is NOT containment" \
  || bad "the run log states plainly that this is NOT containment" "$OUT"

echo
echo "Case 40b — --claude-deny APPENDS to the nested set, it does not replace it"
d="$(new_sandbox)"; state_file "$d" "nest-append" "claude"
export WL_ARGV_FILE="$SANDBOX_ROOT/argv-nested-append.txt"
export WL_SF="$d/logs/work-loop/nest-append.md"
export WL_CO="$d"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task nest-append --log-dir "$d/runs" \
      --carry-one --claude-bin "$FAKE" --claude-deny 'WebFetch' 2>&1)"; RC=$?
expect_rc 0 "$RC" "the hop completes with an operator deny added" "$OUT"
if [ -f "$WL_ARGV_FILE" ]; then
  grep -Fqx -- 'Bash(claude:*)' "$WL_ARGV_FILE" \
    && ok "an operator --claude-deny does not displace the nested-actor rules" \
    || bad "an operator --claude-deny does not displace the nested-actor rules" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
  grep -Fqx -- 'WebFetch' "$WL_ARGV_FILE" \
    && ok "the operator's own rule is passed alongside them" \
    || bad "the operator's own rule is passed alongside them" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")"
else
  bad "the fake claude binary was invoked" "no argv file"
fi
unset WL_ARGV_FILE WL_SF WL_CO

echo
echo "Case 41 — O2: a TIMEOUT names the partial edits it left behind (incident 2)"
# The exact shape of 2026-08-11: the actor edits an allowed implementation file,
# never touches the state file, never commits, and is killed on the deadline.
# Before this change the stop said "exceeded 3s and was killed" and stopped
# there — the state file had not moved and the branch ref had not advanced, so
# every check that could have reported the edit was scoped to violations and
# found none. Three true facts, one misleading picture.
d="$(new_sandbox)"; state_file "$d" "timeout-task" "claude"
IMPL="$(seed_impl "$d")"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task timeout-task --log-dir "$d/runs" \
      --carry-one --timeout 3 \
      --actor-cmd 'printf "half-written work\n" >> "$WL_CHECKOUT/'"$IMPL"'"; sleep 30' 2>&1)"; RC=$?
expect_rc 21 "$RC" "the oversized hop is stopped by the actor timeout" "$OUT"
printf '%s' "$OUT" | grep -q "PARTIAL FILE EFFECTS" \
  && ok "the timeout stop carries a partial-effects section" \
  || bad "the timeout stop carries a partial-effects section" "$OUT"
partial_section "$OUT" | grep -Fq "$IMPL" \
  && ok "the modified allowed file is named INSIDE the partial-effects section" \
  || bad "the modified allowed file is named INSIDE the partial-effects section" "$OUT"
printf '%s' "$OUT" | grep -q "NOT a violation" \
  && ok "the stop says the listed paths are work, not a violation" \
  || bad "the stop says the listed paths are work, not a violation" "$OUT"
# The state file genuinely did not move. That must still be true, or this case
# is proving something other than the blind spot it was written for.
[ -z "$(git -C "$d" status --porcelain -- "logs/work-loop/timeout-task.md")" ] \
  && ok "control: the state file itself is untouched, as in the real incident" \
  || bad "control: the state file itself is untouched" "$(git -C "$d" status --porcelain)"

echo
echo "Case 41b — O2 attribution: only what the hop changed SINCE LAUNCH is reported"
# The mechanism under test is the pre-launch snapshot, not the post-stop scan.
#
# Two allowed files are dirty BEFORE the actor launches — an ordinary uncommitted
# Codex handoff sitting on disk. The hop appends to one and never opens the other.
# A post-stop scan alone cannot tell them apart, because both are dirty when the
# stop is written; reporting the untouched one as "work the hop did" is the same
# false attribution O2 exists to remove, one file over.
#
# BOTH assertions are load-bearing and they fail against DIFFERENT wrong answers.
# The negative one fails a plain post-stop scan. The positive one fails a
# subtract-by-path-name implementation: this file was already dirty, so its
# porcelain status line is byte-identical before and after, and only pairing that
# line with the worktree blob hash makes the hop's additional edit observable.
d="$(new_sandbox)"; state_file "$d" "attrib-task" "claude"
IMPL="$(seed_impl "$d")"
UNTOUCHED="plans/work-loop-v2-v0.2/handoff-automation-spike/untouched.txt"
printf 'baseline\n' >"$d/$UNTOUCHED"
git -C "$d" add "$UNTOUCHED" >/dev/null 2>&1
git -C "$d" commit -qm "seed untouched" >/dev/null 2>&1
printf 'pre-existing Codex work\n' >>"$d/$IMPL"
printf 'pre-existing Codex work\n' >>"$d/$UNTOUCHED"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task attrib-task --log-dir "$d/runs" \
      --carry-one --timeout 3 \
      --actor-cmd 'printf "the hop added this\n" >> "$WL_CHECKOUT/'"$IMPL"'"; sleep 30' 2>&1)"; RC=$?
expect_rc 21 "$RC" "the hop is stopped by the actor timeout" "$OUT"
partial_section "$OUT" | grep -Fq "$IMPL" \
  && ok "a FURTHER edit to an already-dirty file IS attributed to the hop" \
  || bad "a FURTHER edit to an already-dirty file IS attributed to the hop" "$(partial_section "$OUT")"
partial_section "$OUT" | grep -Fq "$UNTOUCHED" \
  && bad "pre-existing dirt the hop never opened is NOT attributed to it" "$(partial_section "$OUT")" \
  || ok "pre-existing dirt the hop never opened is NOT attributed to it"

echo
echo "Case 42 — the FALSE exit 25: an already-dirty state file Claude never touched"
# Incident 1's claim 2a. turn: claude with an uncommitted state file is the
# EXPECTED Codex handoff and is accepted at startup. If the hop then changes
# nothing, the old code read bare dirtiness as proof and reported "Claude edited
# logs/work-loop/<task>.md" about a file byte-identical before and after.
d="$(new_sandbox)"; state_file "$d" "falsedirty-task" "claude"
printf '\nuncommitted Codex handoff text\n' >> "$d/logs/work-loop/falsedirty-task.md"
BEFORE_SUM="$(shasum -a 256 "$d/logs/work-loop/falsedirty-task.md" | cut -d' ' -f1)"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task falsedirty-task --log-dir "$d/runs" \
      --carry-one --actor-cmd 'exit 0' 2>&1)"; RC=$?
expect_rc 36 "$RC" "the no-op hop over a pre-dirty state file exits 36, not 25" "$OUT"
printf '%s' "$OUT" | grep -q "CLAUDE DID NOT TOUCH IT" \
  && ok "the stop says plainly that Claude did not touch the file" \
  || bad "the stop says plainly that Claude did not touch the file" "$OUT"
printf '%s' "$OUT" | grep -q "Claude edited logs/work-loop/falsedirty-task.md" \
  && bad "the stop no longer claims Claude edited the file" "$OUT" \
  || ok "the stop no longer claims Claude edited the file"
printf '%s' "$OUT" | grep -q "Addressed to the OPERATOR" \
  && ok "the stop names its addressee, so Codex cannot read it as its own instruction" \
  || bad "the stop names its addressee" "$OUT"
printf '%s' "$OUT" | grep -q "PARTIAL FILE EFFECTS — since launch" \
  && bad "an untouched pre-existing Codex handoff is not attributed to Claude" "$OUT" \
  || ok "an untouched pre-existing Codex handoff is not attributed to Claude"
AFTER_SUM="$(shasum -a 256 "$d/logs/work-loop/falsedirty-task.md" | cut -d' ' -f1)"
[ "$BEFORE_SUM" = "$AFTER_SUM" ] \
  && ok "control: the state file really is byte-identical across the hop" \
  || bad "control: the state file really is byte-identical across the hop" "$BEFORE_SUM -> $AFTER_SUM"

echo
echo "Case 42b — a REAL uncommitted Claude edit still exits 25"
# The control that keeps case 42 honest. If 36 swallowed this shape too, the
# split would have replaced one wrong classification with another.
d="$(new_sandbox)"; state_file "$d" "realedit-task" "claude"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task realedit-task --log-dir "$d/runs" \
      --carry-one --actor-cmd 'awk "/^turn: /&&!d{print \"turn: codex\"; d=1; next}{print}" "$WL_STATE_FILE" > "$WL_STATE_FILE.tmp"; mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"' 2>&1)"; RC=$?
expect_rc 25 "$RC" "an actual uncommitted Claude edit is still 25" "$OUT"
printf '%s' "$OUT" | grep -q "CLAUDE DID NOT TOUCH IT" \
  && bad "25 does not borrow 36's wording" "$OUT" \
  || ok "25 does not borrow 36's wording"

echo
echo "Case 42c — exit 36 reports other allowed work without claiming the hop did nothing"
d="$(new_sandbox)"; state_file "$d" "state-noop-work-task" "claude"
printf '\nuncommitted Codex handoff text\n' >> "$d/logs/work-loop/state-noop-work-task.md"
IMPL="$(seed_impl "$d")"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task state-noop-work-task --log-dir "$d/runs" \
      --carry-one --actor-cmd 'printf "other allowed work\n" >> "$WL_CHECKOUT/'"$IMPL"'"' 2>&1)"; RC=$?
expect_rc 36 "$RC" "an untouched pre-dirty state file still exits 36" "$OUT"
partial_section "$OUT" | grep -Fq "$IMPL" \
  && ok "exit 36 names other allowed work changed by the hop" \
  || bad "exit 36 names other allowed work changed by the hop" "$OUT"
printf '%s' "$OUT" | grep -q "hop therefore accomplished no observable transition" \
  && bad "exit 36 no longer claims the whole hop did nothing" "$OUT" \
  || ok "exit 36 no longer claims the whole hop did nothing"

echo
echo "Case 43 — O3: a permission denial becomes its own stop, naming tool and target"
# The capture body is modelled on the recorded live shape in
# runs/live-permission-denial-2026-08-05.md (run C): the child is refused
# `git add`/`git commit` through Bash, edits the state file, cannot commit it,
# and STILL EXITS 0. That last part is why this used to arrive as a bare 25 with
# no cause named — and why the operator on 2026-08-10 went looking outside the
# dispatcher for an answer it had in a file it never read.
d="$(new_sandbox)"; state_file "$d" "denial-task" "claude"
DENIAL_JSON='{"type":"result","subtype":"success","is_error":false,"permission_denials":[{"tool_name":"Bash","tool_use_id":"toolu_fixture01","tool_input":{"command":"git add logs/work-loop/denial-task.md && git commit -m wip"}},{"tool_name":"Edit","tool_use_id":"toolu_fixture02","tool_input":{"file_path":"/sandbox/logs/work-loop/denial-task.md"}}],"result":"I was denied permission to commit."}'
printf '%s' "$DENIAL_JSON" > "$SANDBOX_ROOT/denial.json"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task denial-task --log-dir "$d/runs" \
      --carry-one \
      --actor-cmd 'awk "/^turn: /&&!d{print \"turn: codex\"; d=1; next}{print}" "$WL_STATE_FILE" > "$WL_STATE_FILE.tmp"; mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"; cat "'"$SANDBOX_ROOT"'/denial.json"' 2>&1)"; RC=$?
expect_rc 37 "$RC" "a hop whose capture reports denials exits 37, not 25" "$OUT"
printf '%s' "$OUT" | grep -q "DENIED PERMISSION" \
  && ok "the stop names permission denial as the cause" \
  || bad "the stop names permission denial as the cause" "$OUT"
printf '%s' "$OUT" | grep -Fq "git add logs/work-loop/denial-task.md" \
  && ok "the exact denied command is carried into the stop" \
  || bad "the exact denied command is carried into the stop" "$OUT"
printf '%s' "$OUT" | grep -q "Edit :: " \
  && ok "a second denial of a different tool is reported too" \
  || bad "a second denial of a different tool is reported too" "$OUT"
printf '%s' "$OUT" | grep -q "capability question" \
  && ok "the stop frames it as an operator capability decision, not a transport failure" \
  || bad "the stop frames it as an operator capability decision" "$OUT"

echo
echo "Case 43c — O3: a target LONGER THAN 200 CHARACTERS is carried whole"
# The exit table and the README both promise the EXACT denied target. The parser
# used to cut every target at 200 characters, so the promise held only for short
# ones — and a long `git commit -m …`, a deep path or a long URL is exactly the
# shape that got cut. A truncated command is not something the operator can act
# on, which puts them back at the unnamed dead end exit 37 exists to remove.
#
# 256 characters, built rather than typed so the boundary is unambiguous, and
# ENDING IN A SENTINEL rather than in more padding. A padded tail cannot detect
# truncation: the first 200 characters end in the same repeated character, so an
# assertion on the last N characters matches inside the truncated string and
# passes against the very dispatcher it is meant to catch. Measured, not
# theorised — the first cut of this case did exactly that.
LONGARG="$(printf 'a%.0s' $(seq 1 226))"
LONGTGT="git commit -m ${LONGARG}TAIL-SENTINEL-Z9"
d="$(new_sandbox)"; state_file "$d" "longdenial-task" "claude"
printf '{"type":"result","subtype":"success","is_error":false,"permission_denials":[{"tool_name":"Bash","tool_use_id":"toolu_long01","tool_input":{"command":"%s"}}],"result":"denied"}' \
  "$LONGTGT" > "$SANDBOX_ROOT/denial-long.json"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task longdenial-task --log-dir "$d/runs" \
      --carry-one \
      --actor-cmd 'awk "/^turn: /&&!d{print \"turn: codex\"; d=1; next}{print}" "$WL_STATE_FILE" > "$WL_STATE_FILE.tmp"; mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"; cat "'"$SANDBOX_ROOT"'/denial-long.json"' 2>&1)"; RC=$?
expect_rc 37 "$RC" "the long denial still reaches a permission stop" "$OUT"
printf '%s' "$OUT" | grep -Fq "Bash :: $LONGTGT" \
  && ok "the >200-character target is carried WHOLE into the stop" \
  || bad "the >200-character target is carried whole" "$(printf '%s' "$OUT" | grep -o 'Bash :: .*' | head -1)"
# Named separately so a truncation regression reads as truncation rather than as
# a general parse failure. The sentinel sits at character 241, past the old
# .[0:200] cut, so it can only appear if nothing was cut.
printf '%s' "$OUT" | grep -Fq "TAIL-SENTINEL-Z9" \
  && ok "the tail past character 200 survives (nothing was cut)" \
  || bad "the tail past character 200 survives" "$OUT"

echo
echo "Case 43d — O3: the exact target survives when jq is UNUSABLE"
# The other half of the same promise. Without jq the parser used to emit
# "? :: (detail unavailable …)", carrying neither the tool nor the target, while
# the stop still described itself as satisfying O3.
#
# jq is shimmed rather than removed from PATH, because on this platform it lives
# in /usr/bin beside git, awk and sed — a PATH that excludes it excludes the
# dispatcher's own toolchain. The shim exits 127, the shell's own
# command-not-found status, so this covers BOTH an absent jq and a broken one.
# The broken case is the stronger of the two and the one a `command -v` guard
# cannot see on its own.
if command -v python3 >/dev/null 2>&1; then
  NOJQ="$SANDBOX_ROOT/nojq"; mkdir -p "$NOJQ"
  printf '#!/bin/bash\nexit 127\n' > "$NOJQ/jq"; chmod +x "$NOJQ/jq"
  d="$(new_sandbox)"; state_file "$d" "nojq-task" "claude"
  OUT="$(PATH="$NOJQ:$PATH" bash "$DISPATCH_BIN" --checkout "$d" --task nojq-task --log-dir "$d/runs" \
        --carry-one \
        --actor-cmd 'awk "/^turn: /&&!d{print \"turn: codex\"; d=1; next}{print}" "$WL_STATE_FILE" > "$WL_STATE_FILE.tmp"; mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"; cat "'"$SANDBOX_ROOT"'/denial-long.json"' 2>&1)"; RC=$?
  expect_rc 37 "$RC" "an unusable jq still reaches a permission stop" "$OUT"
  printf '%s' "$OUT" | grep -Fq "Bash :: $LONGTGT" \
    && ok "the exact >200-character target survives without jq" \
    || bad "the exact target survives without jq" "$(printf '%s' "$OUT" | grep -o '[?A-Za-z]* :: .*' | head -1)"
  # A "no placeholder appears" assertion was tried here and REMOVED. Against the
  # pre-fix dispatcher the shimmed jq produced no denials at all, so no stop
  # fired, so no placeholder appeared and the assertion passed — vacuously, on
  # the run it existed to catch. The exact-target assertion above already
  # excludes the placeholder, since the two are mutually exclusive outputs.
  #
  # The control: proves the shim actually took effect. Without it this case would
  # pass identically on a run that quietly used the real jq all along.
  printf '%s' "$OUT" | grep -q "denial_parser=python3" \
    && ok "control: the run really did fall through to the python3 parser" \
    || bad "control: the run fell through to the python3 parser" "$OUT"
else
  ok "SKIPPED — no python3 on this host, so the no-jq tier cannot be exercised"
fi

echo
echo "Case 43b — a clean capture produces NO permission stop"
# The control. Without it, case 43 would pass equally well against a dispatcher
# that exits 37 on every Claude hop.
d="$(new_sandbox)"; state_file "$d" "nodenial-task" "claude"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task nodenial-task --log-dir "$d/runs" \
      --carry-one --actor-cmd 'printf "{\"type\":\"result\",\"permission_denials\":[],\"result\":\"fine\"}"; '"$FLIP" 2>&1)"; RC=$?
printf '%s' "$OUT" | grep -q "DENIED PERMISSION" \
  && bad "an empty permission_denials array does not trigger a permission stop" "$OUT" \
  || ok "an empty permission_denials array does not trigger a permission stop"
[ "$RC" -ne 37 ] \
  && ok "the run does not exit 37 when nothing was denied (got $RC)" \
  || bad "the run does not exit 37 when nothing was denied" "$OUT"

echo
echo "Case 44 — O2: an OUT-OF-SCOPE edit reports the in-scope work alongside it"
# 24 already named the violation. It did not name what the hop had legitimately
# done, so the operator deciding whether to keep or discard was reading half the
# picture.
d="$(new_sandbox)"; state_file "$d" "scope-edit-task" "claude"
IMPL="$(seed_impl "$d")"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task scope-edit-task --log-dir "$d/runs" \
      --carry-one \
      --actor-cmd 'printf "in-scope work\n" >> "$WL_CHECKOUT/'"$IMPL"'"; printf "out-of-scope\n" >> "$WL_CHECKOUT/other.txt"' 2>&1)"; RC=$?
expect_rc 24 "$RC" "an out-of-allowlist working-tree edit still stops the run" "$OUT"
printf '%s' "$OUT" | grep -Fq "other.txt" \
  && ok "the out-of-scope path is reported (unchanged behaviour)" \
  || bad "the out-of-scope path is reported" "$OUT"
printf '%s' "$OUT" | grep -q "PARTIAL FILE EFFECTS" \
  && ok "the out-of-scope stop ALSO carries a partial-effects section" \
  || bad "the out-of-scope stop ALSO carries a partial-effects section" "$OUT"
partial_section "$OUT" | grep -Fq "$IMPL" \
  && ok "the in-scope work the hop did is named INSIDE that section" \
  || bad "the in-scope work the hop did is named INSIDE that section" "$OUT"

echo
echo "Case 45 — O2: an OUT-OF-SCOPE COMMIT reports uncommitted in-scope work too"
d="$(new_sandbox)"; state_file "$d" "scope-commit-task" "claude"
IMPL="$(seed_impl "$d")"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task scope-commit-task --log-dir "$d/runs" \
      --carry-one \
      --actor-cmd 'printf "in-scope, left uncommitted\n" >> "$WL_CHECKOUT/'"$IMPL"'"; printf "out-of-scope\n" >> "$WL_CHECKOUT/other.txt"; git -C "$WL_CHECKOUT" add other.txt; git -C "$WL_CHECKOUT" commit -qm "actor commits out of scope"' 2>&1)"; RC=$?
expect_rc 30 "$RC" "an out-of-allowlist COMMIT still stops the run" "$OUT"
printf '%s' "$OUT" | grep -Fq "other.txt" \
  && ok "the committed out-of-scope path is reported (unchanged behaviour)" \
  || bad "the committed out-of-scope path is reported" "$OUT"
printf '%s' "$OUT" | grep -q "PARTIAL FILE EFFECTS" \
  && ok "the out-of-scope-commit stop ALSO carries a partial-effects section" \
  || bad "the out-of-scope-commit stop ALSO carries a partial-effects section" "$OUT"
partial_section "$OUT" | grep -Fq "$IMPL" \
  && ok "the uncommitted in-scope work is named INSIDE that section" \
  || bad "the uncommitted in-scope work is named INSIDE that section" "$OUT"

echo
echo "Case 46 — a clean hop is NOT decorated with a partial-effects section"
# The other half of the O2 control. partial_effect_block() must be silent when
# the tree is clean, or every stop in this suite grows a confusing empty header.
d="$(new_sandbox)"; state_file "$d" "clean-hop-task" "claude"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task clean-hop-task --log-dir "$d/runs" \
      --carry-one --actor-cmd "$FLIP" 2>&1)"; RC=$?
expect_rc 0 "$RC" "the well-behaved hop still completes" "$OUT"
printf '%s' "$OUT" | grep -q "PARTIAL FILE EFFECTS" \
  && bad "a clean hop prints no partial-effects section" "$OUT" \
  || ok "a clean hop prints no partial-effects section"

echo
echo "Case 47 — malformed post-hop state still reports partial effects"
d="$(new_sandbox)"; state_file "$d" "malformed-after-task" "claude"
IMPL="$(seed_impl "$d")"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task malformed-after-task --log-dir "$d/runs" \
      --carry-one \
      --actor-cmd 'printf "partial implementation\n" >> "$WL_CHECKOUT/'"$IMPL"'"; awk "/^turn: /&&!d{print \"turn: broken\"; d=1; next}{print}" "$WL_STATE_FILE" > "$WL_STATE_FILE.tmp"; mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"' 2>&1)"; RC=$?
expect_rc 15 "$RC" "malformed post-hop state exits 15" "$OUT"
partial_section "$OUT" | grep -Fq "$IMPL" \
  && ok "post-hop validate_state failure reports the allowed implementation edit" \
  || bad "post-hop validate_state failure reports the allowed implementation edit" "$OUT"

# ============================================ Tracer 4 — legacy isolation
#
# These two cases are the ONLY thing standing behind "the dispatcher no longer
# touches legacy session state". They are written to fail against the PRE-Tracer-4
# dispatcher, which is what makes them evidence rather than description:
#
#   Case 48  pre-change, init_session_identity() ran prime-session-entry.sh and
#            appended a `- Files in scope:` bullet to logs/session-notes.md
#            before hop 1, so every one of its four assertions failed.
#   Case 49  pre-change, allowlisted_dirty() carried a hardcoded
#            `[ "$p" = "logs/session-notes.md" ] && continue`, so the path was
#            filtered out of partial-effect accounting and the assertion failed.
#
# Both were confirmed failing against the pre-change dispatcher before the change
# landed; see this task's record for the exact counts.

echo
echo "Case 48 — Tracer 4: a run in a checkout that CARRIES the legacy session infrastructure writes no legacy session state"
d="$(new_sandbox)"; state_file "$d" "legacy-isolation-task" "claude"
# The sandbox is deliberately the DANGEROUS shape: it carries an executable
# allocator, exactly like a real checkout. The pre-change dispatcher skipped its
# init only when the allocator was ABSENT, so a sandbox without one would have
# passed this case for the wrong reason and proved nothing.
ENTRY_CALLS="$d/entry-calls.txt"
cat >"$d/logs/scripts/prime-session-entry.sh" <<EOF
#!/bin/bash
# Stub allocator. Records that it was called AT ALL, then behaves like the real
# one so that a dispatcher which calls it succeeds rather than failing closed —
# a stub that errored would let this case pass on the allocator's failure
# instead of on the dispatcher's silence.
#
# It writes logs/.session-marker because the REAL allocator does
# (logs/scripts/prime-session-entry.sh, writer invariant at its line 194). A
# stub that skipped that write would make the ".session-marker was not created"
# assertion below pass against the pre-change dispatcher too — i.e. not evidence.
printf 'called\n' >>"$ENTRY_CALLS"
printf '%s 1\n' "\$(date '+%Y-%m-%d')" | tee logs/.session-marker
EOF
chmod +x "$d/logs/scripts/prime-session-entry.sh"
printf '# Session Notes\n\n## 2026-01-01 — Session 1\n**Work:** a stranger session.\n' >"$d/logs/session-notes.md"
git -C "$d" add logs/scripts/prime-session-entry.sh logs/session-notes.md >/dev/null 2>&1
git -C "$d" commit -qm "legacy session infrastructure" >/dev/null 2>&1
NOTES_BEFORE="$(cat "$d/logs/session-notes.md")"
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task legacy-isolation-task --log-dir "$d/runs" \
      --carry-one --actor-cmd "$FLIP" 2>&1)"; RC=$?
expect_rc 0 "$RC" "48 — the hop completes" "$OUT"
[ ! -f "$ENTRY_CALLS" ] \
  && ok "48 — prime-session-entry.sh was never invoked" \
  || bad "48 — prime-session-entry.sh was never invoked" "called $(wc -l <"$ENTRY_CALLS" 2>/dev/null) time(s)"
[ "$(cat "$d/logs/session-notes.md")" = "$NOTES_BEFORE" ] \
  && ok "48 — logs/session-notes.md is byte-identical after the run" \
  || bad "48 — logs/session-notes.md is byte-identical after the run" "$(git -C "$d" diff -- logs/session-notes.md)"
[ ! -e "$d/logs/.session-marker" ] \
  && ok "48 — no logs/.session-marker was created" \
  || bad "48 — no logs/.session-marker was created" "$(cat "$d/logs/.session-marker")"
printf '%s' "$OUT" | grep -q 'identity:' \
  && bad "48 — the run log carries no session-identity line" "$(printf '%s' "$OUT" | grep 'identity:')" \
  || ok "48 — the run log carries no session-identity line"

echo
echo "Case 49 — Tracer 4: an uncommitted logs/session-notes.md inside the allowlist is REPORTED, not hidden"
# The complement of case 48. Once the dispatcher stops writing session-notes.md,
# any uncommitted edit to it is somebody else's work, and hiding it from
# partial-effect accounting would be the false statement O2 exists to remove.
# The path reaches the allowlist here only because this case passes it
# explicitly — which is the whole point: the operator asked for it to be in scope.
d="$(new_sandbox)"; state_file "$d" "notes-partial-task" "claude"
printf '# Session Notes\n' >"$d/logs/session-notes.md"
git -C "$d" add logs/session-notes.md >/dev/null 2>&1
git -C "$d" commit -qm "seed session notes" >/dev/null 2>&1
OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task notes-partial-task --log-dir "$d/runs" \
      --carry-one \
      --allow-path '^logs/work-loop/' --allow-path '^logs/session-notes\.md$' \
      --actor-cmd 'printf "an uncommitted edit\n" >> "$WL_CHECKOUT/logs/session-notes.md"; awk "/^turn: /&&!d{print \"turn: broken\"; d=1; next}{print}" "$WL_STATE_FILE" > "$WL_STATE_FILE.tmp"; mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"' 2>&1)"; RC=$?
expect_rc 15 "$RC" "49 — malformed post-hop state exits 15" "$OUT"
partial_section "$OUT" | grep -Fq "logs/session-notes.md" \
  && ok "49 — the uncommitted session-notes.md edit is reported as a partial effect" \
  || bad "49 — the uncommitted session-notes.md edit is reported as a partial effect" "$(partial_section "$OUT")"

# ==================================================================== case 50
#
# Change set A, items 3 and 4: the die() funnel finalizes exactly ONE versioned,
# run-bound, complete terminal result before it releases the lease.
#
# SCOPE OF THIS CASE, stated so a later reader does not over-read it. It covers
# the terminal families that already converge on die()/die_hop() — the nine
# post-admission nonzero families D–L. It deliberately does NOT cover the
# families that reach their exit by another route: usage/argument refusal and
# checkout/lease-infrastructure failure exit directly before a run id exists,
# lease refusal has its own producer (refuse_17), the signal handler exits on its
# own path, and the five zero-exit sites are not terminals this producer owns.
# Those are separate integrations and asserting them here would claim coverage
# the dispatcher does not yet have.
#
# There is no reader in this case either. Every assertion below reads the
# artifact with `sed`/`grep` from the harness, which is exactly the point: the
# record has to be consumable without a parser shipped alongside it.

# One field out of a result file. `head -1` because a duplicate singleton field is
# a defect the grammar assertion below catches separately — this helper must not
# quietly paper over it by concatenating.
res_field() { # file key -> value
  sed -n "s/^$2=//p" "$1" 2>/dev/null | head -1
}
# The run-bound result path, derived from the run log line the dispatcher printed
# rather than from anything this harness composes. If the two ever disagree, the
# record is not run-bound and every assertion below should fail — which is why the
# id is READ, not reconstructed.
run_id_of() { # dispatcher output -> run id
  printf '%s\n' "$1" | sed -n 's/^run=\([^ ]*\) .*/\1/p' | head -1
}
res_count() { # runs dir -> number of finalized results
  ls "$1"/*.result 2>/dev/null | wc -l | tr -d ' '
}
part_count() { # runs dir -> number of UNfinalized temporary artifacts
  ls "$1"/*.result.partial 2>/dev/null | wc -l | tr -d ' '
}

echo
echo "Case 50a — a post-hop nonzero terminal (22) finalizes exactly one complete run-bound result"
# Modelled on case 6 — the narrowest existing post-hop terminal in this suite. The
# actor ALSO plants two lookalike results: one at a name it invented, and one at
# the exact run-bound path it derived by globbing the run log. Both are the
# "actor-created lookalike" the trusted-field-ownership contract forbids from
# supplying the result framing.
NOOP_PLANT='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls";
      for f in "$WL_CHECKOUT"/runs/*.log; do
        [ -e "$f" ] || continue
        printf "terminal_result_version=1\noutcome=SUCCESS\ncode=0\nactor_launched=no\nresult_complete=yes\n" > "${f%.log}.result";
      done;
      printf "terminal_result_version=1\noutcome=SUCCESS\ncode=0\nresult_complete=yes\n" > "$WL_CHECKOUT/runs/actor-planted.result";
      exit 0'
d="$(new_sandbox)"; state_file "$d" "result-post-task" "codex"
run_dispatch "$d" result-post-task --actor-cmd "$NOOP_PLANT"
expect_rc 22 "$RC" "50a — exits 22 on no observable transition" "$OUT"
RID="$(run_id_of "$OUT")"
[ -n "$RID" ] && ok "50a — the run announced a run id" \
              || bad "50a — the run announced a run id" "$OUT"
R50="$d/runs/$RID.result"
if [ -f "$R50" ]; then
  ok "50a — a terminal result exists at the run-bound path"
else
  bad "50a — a terminal result exists at the run-bound path" \
      "missing $R50; runs/ holds: $(ls "$d/runs" 2>&1 | tr '\n' ' ')"
fi
# NO PARTIAL ARTIFACT SURVIVES. The producer writes to a temporary and renames, so
# a leftover .partial means the finalization did not complete atomically.
[ "$(part_count "$d/runs")" = "0" ] \
  && ok "50a — no unfinalized temporary artifact was left behind" \
  || bad "50a — no unfinalized temporary artifact was left behind" "$(ls "$d/runs"/*.result.partial 2>&1)"
# EXACTLY ONE finalization, not two. Counted as version lines inside the artifact:
# a producer that appended instead of replacing would carry two.
NV="$(grep -c '^terminal_result_version=' "$R50" 2>/dev/null || printf '0')"
[ "$NV" = "1" ] && ok "50a — the artifact carries exactly one version line" \
                || bad "50a — the artifact carries exactly one version line" "found $NV"
[ "$(head -1 "$R50" 2>/dev/null)" = "terminal_result_version=1" ] \
  && ok "50a — the first line is the recognized schema version" \
  || bad "50a — the first line is the recognized schema version" "$(head -1 "$R50" 2>/dev/null)"
# THE COMPLETENESS SENTINEL, last line. Together with the atomic rename this is
# what separates "a complete result" from "a result that was being written".
[ "$(tail -1 "$R50" 2>/dev/null)" = "result_complete=yes" ] \
  && ok "50a — the last line is the completeness sentinel" \
  || bad "50a — the last line is the completeness sentinel" "$(tail -1 "$R50" 2>/dev/null)"
# BOUNDED GRAMMAR. Every line is one key=value pair, so a value carrying a newline
# — a path, a git status line, an operator-supplied argument — cannot inject a
# field. The check is the complement: no line that fails the shape.
if [ -z "$(grep -vE '^[a-z][a-z0-9_]*=' "$R50" 2>/dev/null)" ]; then
  ok "50a — every line matches the bounded key=value grammar"
else
  bad "50a — every line matches the bounded key=value grammar" "$(grep -vnE '^[a-z][a-z0-9_]*=' "$R50" | head -3 | tr '\n' ';')"
fi
# THE TRUTHFUL REQUIRED FIELDS, checked against what the dispatcher observed
# rather than against what the actor claimed.
for pair in "outcome:NO_TRANSITION" "code:22" "task:result-post-task" \
            "stage:post-hop" "actor:codex" "actor_launched:yes" \
            "model_request_started:no" "mode:simulated" "hop:1" \
            "owner_check:proceed" "owner_declared:none" \
            "lease_task_at_finalization:held-by-this-run" \
            "lease_checkout_at_finalization:held-by-this-run"; do
  k="${pair%%:*}"; want="${pair#*:}"
  got="$(res_field "$R50" "$k")"
  [ "$got" = "$want" ] && ok "50a — $k=$want" || bad "50a — $k=$want" "got: ${got:-<absent>}"
done
[ "$(res_field "$R50" run)" = "$RID" ] \
  && ok "50a — the result names its own run id" \
  || bad "50a — the result names its own run id" "got: $(res_field "$R50" run)"
[ "$(res_field "$R50" checkout)" = "$(cd "$d" && pwd -P)" ] \
  && ok "50a — the result names the canonical checkout" \
  || bad "50a — the result names the canonical checkout" "got: $(res_field "$R50" checkout)"
# Exit 22 is precisely "the bytes did not move", so before and after must be equal
# AND present. Equal-and-absent would satisfy a naive comparison, which is why the
# non-emptiness is asserted separately.
SB="$(res_field "$R50" state_sha256_before)"; SA="$(res_field "$R50" state_sha256_after)"
if [ -n "$SB" ] && [ "$SB" != "unavailable" ] && [ "$SB" = "$SA" ]; then
  ok "50a — state hashes are recorded and equal, matching the 22 it reported"
else
  bad "50a — state hashes are recorded and equal, matching the 22 it reported" "before=$SB after=$SA"
fi
HB="$(res_field "$R50" head_before)"
[ -n "$HB" ] && [ "$HB" = "$(git -C "$d" rev-parse HEAD)" ] \
  && ok "50a — head_before is the real commit, read from Git" \
  || bad "50a — head_before is the real commit, read from Git" "got: $HB"
[ -f "$(res_field "$R50" run_log)" ] \
  && ok "50a — the named run log exists on disk" \
  || bad "50a — the named run log exists on disk" "got: $(res_field "$R50" run_log)"
[ -n "$(res_field "$R50" next_action)" ] \
  && ok "50a — a next required action is recorded" \
  || bad "50a — a next required action is recorded"
# THE UNAVAILABLE FACTS ARE STATED, NOT OMITTED AND NOT GUESSED. These three are
# not established anywhere in this dispatcher today. Recording the requested
# permission mode while leaving the effective one unavailable is the distinction
# the plan draws between evidence and authorization.
for k in recorded_usage actor_session_id permission_mode_effective; do
  [ "$(res_field "$R50" "$k")" = "unavailable" ] \
    && ok "50a — $k is explicitly unavailable" \
    || bad "50a — $k is explicitly unavailable" "got: $(res_field "$R50" "$k")"
done
# THE ACTOR CANNOT SUPPLY THE FRAMING. It wrote SUCCESS/0 over the exact run-bound
# path before exiting; the dispatcher's finalization replaced it with what the
# dispatcher observed. Asserted on the field values, not on file count, because a
# lookalike that survived would still be exactly one file.
case "$(res_field "$R50" outcome):$(res_field "$R50" code)" in
  NO_TRANSITION:22) ok "50a — the actor's planted SUCCESS result did not become the trusted result" ;;
  *) bad "50a — the actor's planted SUCCESS result did not become the trusted result" \
         "got outcome=$(res_field "$R50" outcome) code=$(res_field "$R50" code)" ;;
esac
[ -f "$d/runs/actor-planted.result" ] \
  && ok "50a — the actor's invented lookalike is still on disk and is simply not run-bound" \
  || bad "50a — the actor's invented lookalike is still on disk and is simply not run-bound"

echo
echo "Case 50b — a PRE-HOP die() family (18) finalizes once, with the unavailable fields explicit"
# The control for the half of the funnel where no actor ran. Nothing observed
# after a launch exists here, and the producer must say so rather than abort under
# `set -u` or invent a post-hop fact. Exit 18 is chosen because it is a pre-hop
# die() reached AFTER the run id exists and BEFORE before_hash/before_head are
# assigned — the narrowest place where unset state is reachable.
d="$(new_sandbox)"; state_file "$d" "result-pre-task" "codex"
printf 'out of allowlist\n' >>"$d/other.txt"
run_dispatch "$d" result-pre-task --actor-cmd "$NOOP"
expect_rc 18 "$RC" "50b — exits 18 on pre-existing out-of-allowlist changes" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "50b — no actor was launched" || bad "50b — no actor was launched" "calls=$(calls "$d")"
RIDB="$(run_id_of "$OUT")"
R50B="$d/runs/$RIDB.result"
[ -f "$R50B" ] && ok "50b — a terminal result exists for the pre-hop stop" \
              || bad "50b — a terminal result exists for the pre-hop stop" "missing $R50B; runs/ holds: $(ls "$d/runs" 2>&1 | tr '\n' ' ')"
[ "$(res_count "$d/runs")" = "1" ] \
  && ok "50b — exactly one result was finalized" \
  || bad "50b — exactly one result was finalized" "found $(res_count "$d/runs")"
[ "$(part_count "$d/runs")" = "0" ] \
  && ok "50b — no unfinalized temporary artifact was left behind" \
  || bad "50b — no unfinalized temporary artifact was left behind" "$(ls "$d/runs"/*.result.partial 2>&1)"
[ "$(tail -1 "$R50B" 2>/dev/null)" = "result_complete=yes" ] \
  && ok "50b — the pre-hop result is complete" \
  || bad "50b — the pre-hop result is complete" "$(tail -1 "$R50B" 2>/dev/null)"
for pair in "outcome:FOREIGN_UNSTAGED" "code:18" "stage:pre-hop" "actor:none" \
            "actor_launched:no" "model_request_started:no" "hop:0"; do
  k="${pair%%:*}"; want="${pair#*:}"
  got="$(res_field "$R50B" "$k")"
  [ "$got" = "$want" ] && ok "50b — $k=$want" || bad "50b — $k=$want" "got: ${got:-<absent>}"
done
# THE UNSET-STATE FIELDS. Each is a fact that only a launched hop establishes, and
# each must carry the explicit bounded token rather than an empty value, an
# omitted key, or a value carried over from somewhere else.
for k in state_sha256_before state_sha256_after head_after capture; do
  got="$(res_field "$R50B" "$k")"
  case "$got" in
    unavailable|none) ok "50b — $k is explicitly '$got', not omitted or guessed" ;;
    *) bad "50b — $k is explicitly unavailable/none" "got: ${got:-<absent>}" ;;
  esac
done
# The one fact this terminal DID establish, so the case cannot pass by marking
# everything unavailable. 18 fires precisely because a foreign path was seen.
[ "$(res_field "$R50B" worktree_foreign_paths)" = "1" ] \
  && ok "50b — the foreign path it stopped on is counted, not blanked" \
  || bad "50b — the foreign path it stopped on is counted, not blanked" "got: $(res_field "$R50B" worktree_foreign_paths)"
[ "$(res_field "$R50B" state_class)" = "ACTIVE_CODEX" ] \
  && ok "50b — the validator's classification is carried, not re-derived" \
  || bad "50b — the validator's classification is carried, not re-derived" "got: $(res_field "$R50B" state_class)"

echo
echo "Case 50c — mutation controls: the assertions above go red when the producer is broken"
# Three mutants of the real dispatcher, each breaking one property case 50a
# asserts. A green suite against a mutant means the assertion proves nothing.
MUT_DIR="$SANDBOX_ROOT/mutants"; mkdir -p "$MUT_DIR"

# M1 — finalization SKIPPED.
sed 's|^  finalize_terminal_result "\$code"$|  :|' "$DISPATCH_BIN" >"$MUT_DIR/m1.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT_DIR/m1.sh"; then
  ok "50c — M1 mutant differs from the dispatcher (the call site was found)"
  d="$(new_sandbox)"; state_file "$d" "m1-task" "codex"
  OUT="$(bash "$MUT_DIR/m1.sh" --checkout "$d" --task m1-task --log-dir "$d/runs" \
        --timeout 20 --actor-cmd "$NOOP" 2>&1)"; RC=$?
  [ "$RC" -eq 22 ] && [ "$(res_count "$d/runs")" = "0" ] \
    && ok "50c — M1: with finalization skipped, no result is produced (assertion is fail-capable)" \
    || bad "50c — M1: with finalization skipped, no result is produced" "rc=$RC results=$(res_count "$d/runs")"
else
  bad "50c — M1 mutant differs from the dispatcher (the call site was found)" \
      "the sed matched nothing — the control cannot run"
fi

# M2 — the atomic publish removed, so the temporary is never renamed.
sed 's|^  mv -f "\$tmp" "\$final" .*$|  true|' "$DISPATCH_BIN" >"$MUT_DIR/m2.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT_DIR/m2.sh"; then
  ok "50c — M2 mutant differs from the dispatcher (the rename was found)"
  d="$(new_sandbox)"; state_file "$d" "m2-task" "codex"
  OUT="$(bash "$MUT_DIR/m2.sh" --checkout "$d" --task m2-task --log-dir "$d/runs" \
        --timeout 20 --actor-cmd "$NOOP" 2>&1)"; RC=$?
  if [ "$(res_count "$d/runs")" = "0" ] && [ "$(part_count "$d/runs")" = "1" ]; then
    ok "50c — M2: without the rename, a partial artifact is exposed and no final one exists"
  else
    bad "50c — M2: without the rename, a partial artifact is exposed and no final one exists" \
        "rc=$RC final=$(res_count "$d/runs") partial=$(part_count "$d/runs")"
  fi
else
  bad "50c — M2 mutant differs from the dispatcher (the rename was found)" \
      "the sed matched nothing — the control cannot run"
fi

# M3 — the result path stops being run-bound, so two runs in one evidence
# directory finalize over each other and the second overwrites the first.
sed 's|^  local final="\$LOG_DIR/\$RUN_ID.result"$|  local final="$LOG_DIR/terminal.result"|' \
    "$DISPATCH_BIN" >"$MUT_DIR/m3.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT_DIR/m3.sh"; then
  ok "50c — M3 mutant differs from the dispatcher (the run-bound path was found)"
  d="$(new_sandbox)"; state_file "$d" "m3-task" "codex"
  bash "$MUT_DIR/m3.sh" --checkout "$d" --task m3-task --log-dir "$d/runs" \
       --timeout 20 --actor-cmd "$NOOP" >/dev/null 2>&1
  bash "$MUT_DIR/m3.sh" --checkout "$d" --task m3-task --log-dir "$d/runs" \
       --timeout 20 --actor-cmd "$NOOP" >/dev/null 2>&1
  [ "$(res_count "$d/runs")" = "1" ] \
    && ok "50c — M3: two runs collapse onto one result (run-binding is what prevents it)" \
    || bad "50c — M3: two runs collapse onto one result" "found $(res_count "$d/runs")"
  # The unmutated control, same shape: two runs, two results.
  d="$(new_sandbox)"; state_file "$d" "m3-control-task" "codex"
  run_dispatch "$d" m3-control-task --actor-cmd "$NOOP"
  run_dispatch "$d" m3-control-task --actor-cmd "$NOOP"
  [ "$(res_count "$d/runs")" = "2" ] \
    && ok "50c — and the real dispatcher keeps both runs' results apart" \
    || bad "50c — and the real dispatcher keeps both runs' results apart" "found $(res_count "$d/runs")"
else
  bad "50c — M3 mutant differs from the dispatcher (the run-bound path was found)" \
      "the sed matched nothing — the control cannot run"
fi

echo
echo "Case 50d — a die() BEFORE any child is forked reports no launch and no model request"
# The correction control for the launch fields. launch_actor() dies four ways
# before run_bounded() forks anything — a non-executable codex binary, an
# unresolvable claude binary, a checkout it cannot enter, an unknown actor name —
# and every one of them is reached AFTER HOP_BASELINE_READY is raised. While that
# flag was the source of actor_launched, all four reported a launch, and in live
# mode a model request, that never happened.
#
# STILL NO LIVE PRODUCT TRANSPORT. The run is in live mode because no --actor-cmd
# is given, and it stops on a binary path that does not exist: nothing is
# executed, no model is contacted, and the case is controller evidence like every
# other one here.
d="$(new_sandbox)"; state_file "$d" "pre-fork-task" "codex"
run_dispatch "$d" pre-fork-task --codex-bin "$d/no-such-codex-binary"
expect_rc 20 "$RC" "50d — exits 20 when the actor binary is not executable" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "50d — no actor process ran" || bad "50d — no actor process ran" "calls=$(calls "$d")"
RIDD="$(run_id_of "$OUT")"
R50D="$d/runs/$RIDD.result"
[ -f "$R50D" ] && ok "50d — the pre-fork stop still finalizes one result" \
              || bad "50d — the pre-fork stop still finalizes one result" "missing $R50D; runs/ holds: $(ls "$d/runs" 2>&1 | tr '\n' ' ')"
[ "$(res_count "$d/runs")" = "1" ] \
  && ok "50d — exactly one result was finalized" \
  || bad "50d — exactly one result was finalized" "found $(res_count "$d/runs")"
[ "$(tail -1 "$R50D" 2>/dev/null)" = "result_complete=yes" ] \
  && ok "50d — the pre-fork result is complete" \
  || bad "50d — the pre-fork result is complete" "$(tail -1 "$R50D" 2>/dev/null)"
# THE LOAD-BEARING ASSERTIONS. `no` here is established-and-absent, not
# unavailable: nothing forked, so nothing could have requested a model. `launch`
# is the third stage value — the baseline was live and the fork never happened,
# which is neither pre-hop nor post-hop.
for pair in "outcome:ACTOR_FAILED" "code:20" "mode:live" "actor:codex" \
            "actor_launched:no" "model_request_started:no" "stage:launch" \
            "hop:1" "permission_mode_requested:none"; do
  k="${pair%%:*}"; want="${pair#*:}"
  got="$(res_field "$R50D" "$k")"
  [ "$got" = "$want" ] && ok "50d — $k=$want" || bad "50d — $k=$want" "got: ${got:-<absent>}"
done

# The same stop on the CLAUDE path, which is the one that names a permission
# mode. A mode is only requested by an argv handed to a child, so a run that
# never forked one requested nothing — reporting the launch path's constant here
# would be the same false-launch claim wearing a different field name.
d="$(new_sandbox)"; state_file "$d" "pre-fork-claude-task" "claude"
run_dispatch "$d" pre-fork-claude-task --claude-bin "$d/no-such-claude-binary"
expect_rc 20 "$RC" "50d — exits 20 when the claude binary is not resolvable" "$OUT"
RIDD2="$(run_id_of "$OUT")"
R50D2="$d/runs/$RIDD2.result"
for pair in "actor:claude" "actor_launched:no" "stage:launch" \
            "permission_mode_requested:none" "permission_mode_effective:unavailable"; do
  k="${pair%%:*}"; want="${pair#*:}"
  got="$(res_field "$R50D2" "$k")"
  [ "$got" = "$want" ] && ok "50d — claude path: $k=$want" || bad "50d — claude path: $k=$want" "got: ${got:-<absent>}"
done

echo
echo "Case 50e — owner and lease status are OBSERVED, and an ownership refusal says so"
# The correction control for finding 2. Case 50a already pins the clean values
# (owner_check=proceed, owner_declared=none, both leases held-by-this-run); this
# case is the other observation, so neither field can be a constant that happens
# to look right. A checkout that declares a DIFFERENT open task is refused at
# admission (33), which is inside the covered funnel, so the record exists and
# has to carry what the check actually returned.
d="$(new_sandbox)"; state_file "$d" "owner-refused-task" "codex"
printf 'decoy-alpha\n' >"$d/logs/work-loop/.owner"
run_dispatch "$d" owner-refused-task --actor-cmd "$NOOP"
expect_rc 33 "$RC" "50e — exits 33 when the checkout declares another task" "$OUT"
[ "$(calls "$d")" = "0" ] && ok "50e — nothing was launched" || bad "50e — nothing was launched" "calls=$(calls "$d")"
RIDE="$(run_id_of "$OUT")"
R50E="$d/runs/$RIDE.result"
[ -f "$R50E" ] && ok "50e — the ownership refusal finalizes a result" \
              || bad "50e — the ownership refusal finalizes a result" "missing $R50E; runs/ holds: $(ls "$d/runs" 2>&1 | tr '\n' ' ')"
for pair in "outcome:OWNERSHIP_REFUSED" "code:33" \
            "owner_check:refused" "owner_declared:decoy-alpha" \
            "actor_launched:no" "stage:pre-hop"; do
  k="${pair%%:*}"; want="${pair#*:}"
  got="$(res_field "$R50E" "$k")"
  [ "$got" = "$want" ] && ok "50e — $k=$want" || bad "50e — $k=$want" "got: ${got:-<absent>}"
done
# The lease is taken before admission runs, so a refusal is finalized holding
# both — read from the lease directories, not asserted from that ordering.
for k in lease_task_at_finalization lease_checkout_at_finalization; do
  [ "$(res_field "$R50E" "$k")" = "held-by-this-run" ] \
    && ok "50e — $k=held-by-this-run" \
    || bad "50e — $k=held-by-this-run" "got: $(res_field "$R50E" "$k")"
done
# The recorded pid is what separates "held by this run" from "held": the value is
# only reachable by reading the holder file the library wrote.
LTD="$(res_field "$R50E" lease_task_dir)"
[ -n "$LTD" ] && [ ! -d "$LTD" ] \
  && ok "50e — and the lease it reported holding was released on the way out" \
  || bad "50e — and the lease it reported holding was released on the way out" "still present: $LTD"

echo
echo "Case 50f — mutation controls for the corrected launch and lease observations"
# M4 and M5 are to case 50d and 50e what M1–M3 were to 50a: without them, an
# assertion that the fields are OBSERVED proves nothing, because a constant of
# the right shape would satisfy it.

# M4 — the launch fields go back to being derived from the intent flag, which is
# the defect this correction removed. The 50d scenario must then claim a launch.
sed 's|^  if \[ "\$ACTOR_PROCESS_STARTED" -eq 1 \]; then$|  if [ "${HOP_BASELINE_READY:-0}" -eq 1 ]; then|' \
    "$DISPATCH_BIN" >"$MUT_DIR/m4.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT_DIR/m4.sh"; then
  ok "50f — M4 mutant differs from the dispatcher (the observed-fork branch was found)"
  d="$(new_sandbox)"; state_file "$d" "m4-task" "codex"
  OUT="$(bash "$MUT_DIR/m4.sh" --checkout "$d" --task m4-task --log-dir "$d/runs" \
        --timeout 20 --codex-bin "$d/no-such-codex-binary" 2>&1)"; RC=$?
  RIDM4="$(run_id_of "$OUT")"
  [ "$(res_field "$d/runs/$RIDM4.result" actor_launched)" = "yes" ] \
    && ok "50f — M4: with the intent flag restored, a pre-fork stop claims a launch (50d is fail-capable)" \
    || bad "50f — M4: with the intent flag restored, a pre-fork stop claims a launch" \
           "rc=$RC actor_launched=$(res_field "$d/runs/$RIDM4.result" actor_launched)"
else
  bad "50f — M4 mutant differs from the dispatcher (the observed-fork branch was found)" \
      "the sed matched nothing — the control cannot run"
fi

# M5 — the reported task lease points somewhere the lease is not. A status READ
# from the filesystem changes; a hard-coded one cannot. Only the reporting path
# is redirected: the library acquires and releases through its own variables.
sed 's|^LOCK_DIR="\$WL_LEASE_TASK_DIR"$|LOCK_DIR="$WL_LEASE_TASK_DIR.absent"|' \
    "$DISPATCH_BIN" >"$MUT_DIR/m5.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT_DIR/m5.sh"; then
  ok "50f — M5 mutant differs from the dispatcher (the reported lease path was found)"
  d="$(new_sandbox)"; state_file "$d" "m5-task" "codex"
  OUT="$(bash "$MUT_DIR/m5.sh" --checkout "$d" --task m5-task --log-dir "$d/runs" \
        --timeout 20 --actor-cmd "$NOOP" 2>&1)"; RC=$?
  RIDM5="$(run_id_of "$OUT")"
  [ "$(res_field "$d/runs/$RIDM5.result" lease_task_at_finalization)" = "missing" ] \
    && ok "50f — M5: with the lease directory absent, the status tracks the filesystem" \
    || bad "50f — M5: with the lease directory absent, the status tracks the filesystem" \
           "rc=$RC lease_task_at_finalization=$(res_field "$d/runs/$RIDM5.result" lease_task_at_finalization)"

  # M6 — the same absent lease, plus the observation replaced by the constant the
  # field used to be. It reports a held lease that is not there, which is exactly
  # what M5 catches and what a hard-coded field would have gone on doing.
  sed 's|^  lease_task="\$(result_lease_status .*$|  lease_task=held-by-this-run|' \
      "$MUT_DIR/m5.sh" >"$MUT_DIR/m6.sh"
  if ! cmp -s "$MUT_DIR/m5.sh" "$MUT_DIR/m6.sh"; then
    ok "50f — M6 mutant differs from M5 (the lease observation was found)"
    d="$(new_sandbox)"; state_file "$d" "m6-task" "codex"
    OUT="$(bash "$MUT_DIR/m6.sh" --checkout "$d" --task m6-task --log-dir "$d/runs" \
          --timeout 20 --actor-cmd "$NOOP" 2>&1)"; RC=$?
    RIDM6="$(run_id_of "$OUT")"
    [ "$(res_field "$d/runs/$RIDM6.result" lease_task_at_finalization)" = "held-by-this-run" ] \
      && ok "50f — M6: hard-coded, it claims a lease that is not on disk (M5's assertion is fail-capable)" \
      || bad "50f — M6: hard-coded, it claims a lease that is not on disk" \
             "rc=$RC lease_task_at_finalization=$(res_field "$d/runs/$RIDM6.result" lease_task_at_finalization)"
  else
    bad "50f — M6 mutant differs from M5 (the lease observation was found)" \
        "the sed matched nothing — the control cannot run"
  fi
else
  bad "50f — M5 mutant differs from the dispatcher (the reported lease path was found)" \
      "the sed matched nothing — the control cannot run"
fi

echo
echo "Case 50g — a lease whose HOLDER cannot be established is not reported as another holder"
# The residual half of the observed-lease contract. wl_lease__read_holder() `cat`s
# the holder files and returns empty for any it cannot read, so an absent or
# unreadable pid record reaches the classifier looking exactly like a pid that is
# not ours. Falling through to `held-by-other` would assert a second holder that
# nothing observed — the same class of unobserved claim as the `held` constant
# this whole field replaced, one branch further in.
#
# The condition is staged the way M5 stages its own: only the REPORTED task-lease
# path is redirected, at a directory this case creates with no holder metadata in
# it. Acquisition and release still run through the library's own variables, so
# the run is otherwise an ordinary one.
sed 's|^LOCK_DIR="\$WL_LEASE_TASK_DIR"$|LOCK_DIR="$WL_LEASE_TASK_DIR.holderless"|' \
    "$DISPATCH_BIN" >"$MUT_DIR/m7.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT_DIR/m7.sh"; then
  ok "50g — M7 mutant differs from the dispatcher (the reported lease path was found)"
  d="$(new_sandbox)"; state_file "$d" "m7-task" "codex"
  # An existing lease directory with NO pid file — the observable shape of holder
  # metadata that cannot be established. `-p` because the lease root is created by
  # the library on acquire and does not exist yet.
  HOLDERLESS="$(task_lock_for "$d" m7-task).holderless"
  mkdir -p "$HOLDERLESS"
  [ -d "$HOLDERLESS" ] && [ ! -e "$HOLDERLESS/pid" ] \
    && ok "50g — the staged lease directory exists and carries no holder record" \
    || bad "50g — the staged lease directory exists and carries no holder record" "$HOLDERLESS"
  OUT="$(bash "$MUT_DIR/m7.sh" --checkout "$d" --task m7-task --log-dir "$d/runs" \
        --timeout 20 --actor-cmd "$NOOP" 2>&1)"; RC=$?
  RIDM7="$(run_id_of "$OUT")"
  G7="$(res_field "$d/runs/$RIDM7.result" lease_task_at_finalization)"
  [ "$G7" = "held-holder-unavailable" ] \
    && ok "50g — an unreadable holder is reported as explicitly unavailable" \
    || bad "50g — an unreadable holder is reported as explicitly unavailable" "rc=$RC got: ${G7:-<absent>}"
  # Stated as its own assertion rather than left implied by the one above: the two
  # values this must never take are the two that would each assert a fact — that
  # someone else holds it, or that this run does.
  case "$G7" in
    held-by-other|held-by-this-run)
      bad "50g — it is neither 'held-by-other' nor 'held-by-this-run'" "got: $G7" ;;
    *)
      ok "50g — it is neither 'held-by-other' nor 'held-by-this-run'" ;;
  esac

  # M8 — the same staged directory with the unavailable branch removed, which is
  # the classification as it stood before this fix. It reports another holder for
  # a lease whose holder was never read, so 50g's assertions are fail-capable.
  sed "s|^  if \[ -z \"\$pid\" \]; then printf 'held-holder-unavailable'; return 0; fi\$|  :|" \
      "$MUT_DIR/m7.sh" >"$MUT_DIR/m8.sh"
  if ! cmp -s "$MUT_DIR/m7.sh" "$MUT_DIR/m8.sh"; then
    ok "50g — M8 mutant differs from M7 (the unavailable branch was found)"
    d="$(new_sandbox)"; state_file "$d" "m8-task" "codex"
    HOLDERLESS8="$(task_lock_for "$d" m8-task).holderless"
    mkdir -p "$HOLDERLESS8"
    OUT="$(bash "$MUT_DIR/m8.sh" --checkout "$d" --task m8-task --log-dir "$d/runs" \
          --timeout 20 --actor-cmd "$NOOP" 2>&1)"; RC=$?
    RIDM8="$(run_id_of "$OUT")"
    [ "$(res_field "$d/runs/$RIDM8.result" lease_task_at_finalization)" = "held-by-other" ] \
      && ok "50g — M8: without the branch it claims another holder it never read (50g is fail-capable)" \
      || bad "50g — M8: without the branch it claims another holder it never read" \
             "rc=$RC got: $(res_field "$d/runs/$RIDM8.result" lease_task_at_finalization)"
  else
    bad "50g — M8 mutant differs from M7 (the unavailable branch was found)" \
        "the sed matched nothing — the control cannot run"
  fi
else
  bad "50g — M7 mutant differs from the dispatcher (the reported lease path was found)" \
      "the sed matched nothing — the control cannot run"
fi

# ==================================================================== case 51
# THE STANDALONE STRUCTURAL VALIDATOR for the v1 terminal result case 50 proves
# the dispatcher produces. Case 50 read that artifact with harness `sed`/`grep`
# on purpose — to show it is consumable without a parser shipped alongside it.
# This case adds the parser the DISPATCHER itself owns, and the two claims are
# different: "a careful reader can extract a field" is not "this program refuses
# a record it must not trust".
#
# THERE IS NO CONSUMER HERE, and that is this unit's boundary. Nothing below
# makes a valid result advance a loop, choose a path, wait for a record, or infer
# a semantic fact from a structure that validated. The validator answers exactly
# one question — is this artifact structurally the v1 record this dispatcher
# writes — and returns one bounded token saying why not. Meaning, run/task/path
# identity and first-consumer integration are separate units.
#
# HOW IT IS EXERCISED, and why that route. dispatch.sh parses its arguments and
# exits at load, so it cannot be sourced; and this unit may not add a CLI, status
# or transition route to reach the function, because that route would be the
# consumer the boundary above excludes. So the harness lifts the
# marker-delimited validator region out of the dispatcher UNDER TEST and sources
# that. It is not a second implementation: the text executed below is
# dispatch.sh's own production text, and 51c proves it by mutating dispatch.sh
# and watching these assertions go red.

VAL_BEGIN='# --- wl2:terminal-result-validator:begin ---'
VAL_END='# --- wl2:terminal-result-validator:end ---'

extract_validator() { # dispatcher-path outfile -> 0 when a non-empty region came out
  awk -v b="$VAL_BEGIN" -v e="$VAL_END" '
    $0 == b { f=1; next } $0 == e { f=0; next } f' "$1" >"$2" 2>/dev/null
  [ -s "$2" ]
}

# One validation, in its own subshell. The isolation is the point twice over:
# nothing the extracted text defines leaks into the harness, and nothing the
# harness already holds can stand in for a definition the dispatcher failed to
# ship — an undefined function exits 127 here rather than silently resolving.
val_run() { # lib artifact -> "<rc> <token>"
  ( . "$1" >/dev/null 2>&1 || { printf '99 lib-unsourceable\n'; exit 0; }
    tok="$(validate_terminal_result "$2" 2>/dev/null)"; rc=$?
    printf '%s %s\n' "$rc" "$tok" )
}

# want-rc want-token label
val_expect() { # lib artifact want-rc want-token label
  local got; got="$(val_run "$1" "$2")"
  if [ "$got" = "$3 $4" ]; then ok "$5"; else bad "$5" "expected '$3 $4', got '$got'"; fi
}

echo
echo "Case 51a — the dispatcher's own validator accepts the artifact its producer really writes"
VAL_LIB="$SANDBOX_ROOT/wl2-validator-lib.sh"
if extract_validator "$DISPATCH_BIN" "$VAL_LIB"; then
  ok "51a — a marker-delimited validator region exists in the dispatcher"
else
  bad "51a — a marker-delimited validator region exists in the dispatcher" \
      "no region between the markers in $DISPATCH_BIN — there is no production validator to exercise"
  : >"$VAL_LIB"
fi

# THE VALID CONTROL IS A REAL RUN'S OUTPUT, not a hand-built happy-path sample.
# A validator agreeing with a fixture the same author wrote proves only that the
# two agree; agreeing with what finalize_terminal_result() actually emitted is
# what makes it compatible with the artifact in the field.
V51D="$(new_sandbox)"; state_file "$V51D" "validator-task" "codex"
run_dispatch "$V51D" validator-task --actor-cmd "$NOOP"
expect_rc 22 "$RC" "51a — the producing run reaches a nonzero terminal (22)" "$OUT"
RID51="$(run_id_of "$OUT")"
REAL51="$V51D/runs/$RID51.result"
if [ -f "$REAL51" ]; then
  ok "51a — the producing run left a terminal result to validate"
else
  bad "51a — the producing run left a terminal result to validate" \
      "missing $REAL51; runs/ holds: $(ls "$V51D/runs" 2>&1 | tr '\n' ' ')"
fi
val_expect "$VAL_LIB" "$REAL51" 0 ok "51a — the unchanged real producer result is accepted"

# THE DECLARED SET IS THE PRODUCED SET. Two key lists in one file is how a
# reader drifts from its writer without either side looking wrong, so the
# validator's required set is compared against the keys the producer actually
# emitted rather than against a list this harness restates.
PRODUCED_KEYS="$(sed -n 's/^\([a-z][a-z0-9_]*\)=.*/\1/p' "$REAL51" 2>/dev/null | LC_ALL=C sort | tr '\n' ' ')"
DECLARED_KEYS="$( ( . "$VAL_LIB" >/dev/null 2>&1 &&
                    printf '%s\n' $TERMINAL_RESULT_REQUIRED ) 2>/dev/null | LC_ALL=C sort | tr '\n' ' ')"
if [ -n "$PRODUCED_KEYS" ] && [ "$PRODUCED_KEYS" = "$DECLARED_KEYS" ]; then
  ok "51a — the validator's required set is exactly the set the producer writes"
else
  bad "51a — the validator's required set is exactly the set the producer writes" \
      "produced: ${PRODUCED_KEYS:-<none>} / declared: ${DECLARED_KEYS:-<none>}"
fi

echo
echo "Case 51b — every structural defect is REJECTED with one bounded reason token"
V51="$SANDBOX_ROOT/v51"; mkdir -p "$V51"

# A duplicate singleton. The brief's named case: two `outcome=` lines, everything
# else intact and the sentinel still last, so nothing but the duplication can
# explain a rejection.
awk '/^outcome=/{print} {print}' "$REAL51" >"$V51/dup" 2>/dev/null
val_expect "$VAL_LIB" "$V51/dup" 1 duplicate-field "51b — a duplicated singleton is rejected"

# An unrecognized version. The record is otherwise this producer's own bytes,
# which is the case a later v2 would present.
sed '1s/^terminal_result_version=1$/terminal_result_version=2/' "$REAL51" >"$V51/ver2" 2>/dev/null
val_expect "$VAL_LIB" "$V51/ver2" 1 unknown-version "51b — an unrecognized version is rejected"

# The version line PRESENT BUT NOT FIRST. A validator that merely grepped for the
# expected version string would accept this; the structural claim is that the
# record announces its version before anything else can be read.
{ sed -n '2p' "$REAL51"; sed -n '1p' "$REAL51"; sed -n '3,$p' "$REAL51"; } >"$V51/vermoved" 2>/dev/null
val_expect "$VAL_LIB" "$V51/vermoved" 1 bad-version-line "51b — a version line that is not the first line is rejected"

sed 's|^schema=.*|schema=work-loop-v2-something-else|' "$REAL51" >"$V51/schema" 2>/dev/null
val_expect "$VAL_LIB" "$V51/schema" 1 unknown-schema "51b — an unrecognized schema name is rejected"

sed '/^owner_check=/d' "$REAL51" >"$V51/missing" 2>/dev/null
val_expect "$VAL_LIB" "$V51/missing" 1 missing-field "51b — a missing required singleton is rejected"

awk 'NR==5{print "NOT_A_PAIR"} {print}' "$REAL51" >"$V51/nopair" 2>/dev/null
val_expect "$VAL_LIB" "$V51/nopair" 1 malformed-line "51b — a line outside the key=value grammar is rejected"

awk 'NR==5{print "bad-key=x"} {print}' "$REAL51" >"$V51/badkey" 2>/dev/null
val_expect "$VAL_LIB" "$V51/badkey" 1 malformed-line "51b — a key outside the bounded key charset is rejected"

awk 'NR==5{print "surprise_field=x"} {print}' "$REAL51" >"$V51/extra" 2>/dev/null
val_expect "$VAL_LIB" "$V51/extra" 1 unknown-field "51b — a field this version does not define is rejected"

# TRUNCATED, the crash-boundary shape: a record that was being written when the
# writer stopped. It has no sentinel and it is missing most of its fields, and
# the token names the more specific of the two.
head -20 "$REAL51" >"$V51/trunc" 2>/dev/null
val_expect "$VAL_LIB" "$V51/trunc" 1 incomplete "51b — a truncated record with no sentinel is rejected"

# THE SENTINEL PRESENT BUT NOT LAST — the second half of the not-merely-grepping
# claim. Every required field is here exactly once and the grammar is clean; the
# only defect is that `result_complete=yes` is not the final line, which is
# precisely what separates a finished record from one still being written.
{ sed -n '1p' "$REAL51"; grep '^result_complete=' "$REAL51"
  sed '1d;/^result_complete=/d' "$REAL51"; } >"$V51/midsentinel" 2>/dev/null
val_expect "$VAL_LIB" "$V51/midsentinel" 1 incomplete "51b — a sentinel that is not the last line is rejected"

sed 's|^result_complete=yes$|result_complete=no|' "$REAL51" >"$V51/notyes" 2>/dev/null
val_expect "$VAL_LIB" "$V51/notyes" 1 incomplete "51b — a negated completion sentinel is rejected"

# THE FINITE ARTIFACT BOUND. A reader with no size bound is a reader an actor can
# make run for as long as it likes by planting a large file at the path.
PAD70K="$(head -c 70000 /dev/zero 2>/dev/null | tr '\0' 'x')"
{ cat "$REAL51"; printf 'next_action=%s\n' "$PAD70K"; } >"$V51/big" 2>/dev/null
val_expect "$VAL_LIB" "$V51/big" 1 too-large "51b — an artifact past the declared byte bound is rejected"

PAD600="$(head -c 600 /dev/zero 2>/dev/null | tr '\0' 'y')"
sed "s|^next_action=.*|next_action=$PAD600|" "$REAL51" >"$V51/longval" 2>/dev/null
val_expect "$VAL_LIB" "$V51/longval" 1 value-too-long "51b — a value past the declared value bound is rejected"

: >"$V51/empty"
val_expect "$VAL_LIB" "$V51/empty" 1 empty "51b — an empty artifact is rejected"
val_expect "$VAL_LIB" "$V51/does-not-exist" 1 unreadable "51b — an absent artifact is rejected"

# READ-ONLY, PROVED AGAINST THE WHOLE CHECKOUT rather than against the artifact
# alone. The claim is not just "it did not rewrite the record" but "it touched no
# state file, no lease, no ownership declaration, no log and no capture", and a
# tree manifest is the only assertion that covers all of them at once.
BEFORE51="$(tree_manifest "$V51D")"
val_run "$VAL_LIB" "$REAL51" >/dev/null 2>&1
val_run "$VAL_LIB" "$V51/dup" >/dev/null 2>&1
AFTER51="$(tree_manifest "$V51D")"
if [ "$BEFORE51" = "$AFTER51" ]; then
  ok "51b — validating changes nothing in the checkout (artifact, state, leases, logs)"
else
  bad "51b — validating changes nothing in the checkout (artifact, state, leases, logs)" \
      "$(printf '%s\n' "$BEFORE51" >"$V51/before"; printf '%s\n' "$AFTER51" >"$V51/after"
         diff "$V51/before" "$V51/after" | head -4 | tr '\n' ';')"
fi

# IT NEITHER SOURCES NOR EVALUATES WHAT IT READS, asserted twice. The static half
# is what the production text may not contain; the live half plants a value that
# WOULD have an effect if any of those constructs were reached.
#
# WHOLE-LINE COMMENTS ARE STRIPPED FIRST, and that sharpens the claim rather than
# softening it: a comment cannot execute, so a prose line mentioning `eval` would
# be a false positive about the one thing this control exists to catch.
VAL_CODE="$SANDBOX_ROOT/wl2-validator-code.sh"
NOEXEC_RE='(^|[^[:alnum:]_])(eval|source)[[:space:]]|^[[:space:]]*\.[[:space:]]|`|\$\(<'
sed 's/^[[:space:]]*#.*$//' "$VAL_LIB" >"$VAL_CODE" 2>/dev/null
if [ -s "$VAL_LIB" ] && ! grep -nE "$NOEXEC_RE" "$VAL_CODE" >/dev/null 2>&1; then
  ok "51b — the validator's executable text contains no eval, source, dot-source or backtick"
else
  bad "51b — the validator's executable text contains no eval, source, dot-source or backtick" \
      "$(grep -nE "$NOEXEC_RE" "$VAL_CODE" 2>/dev/null | head -3 | tr '\n' ';')"
fi
CANARY51="$V51D/CANARY"
sed "s|^next_action=.*|next_action=\$(touch $CANARY51)|" "$REAL51" >"$V51/inject" 2>/dev/null
val_run "$VAL_LIB" "$V51/inject" >/dev/null 2>&1
if [ ! -e "$CANARY51" ]; then
  ok "51b — a command substitution inside a value is data, not code"
else
  bad "51b — a command substitution inside a value is data, not code" "the canary at $CANARY51 was created"
fi

echo
echo "Case 51c — mutation controls: the rejections above go green when the validator is broken"
MUT51="$SANDBOX_ROOT/mutants51"; mkdir -p "$MUT51"

# M9 — remove the duplicate-detection line from the DISPATCHER, then extract the
# validator from the mutant. If 51b's duplicate rejection were satisfied by
# anything other than that line, this control would still reject and the
# assertion above would not be evidence.
sed "/printf 'duplicate-field/d" "$DISPATCH_BIN" >"$MUT51/m9.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT51/m9.sh"; then
  ok "51c — M9 mutant differs from the dispatcher (the duplicate check was found)"
  if extract_validator "$MUT51/m9.sh" "$MUT51/m9.lib"; then
    val_expect "$MUT51/m9.lib" "$V51/dup" 0 ok \
      "51c — M9: without the duplicate check the duplicate is accepted (51b is fail-capable)"
  else
    bad "51c — M9: without the duplicate check the duplicate is accepted (51b is fail-capable)" \
        "no validator region in the mutant"
  fi
else
  bad "51c — M9 mutant differs from the dispatcher (the duplicate check was found)" \
      "the sed matched nothing — the control cannot run"
fi

# M10 — remove the sentinel-is-last line. Without it the validator still finds
# every required field exactly once in the reordered record, so it accepts a
# record that was never finalized. That is exactly the failure a grep for
# `result_complete=yes` would have shipped.
sed "/printf 'incomplete/d" "$DISPATCH_BIN" >"$MUT51/m10.sh"
if ! cmp -s "$DISPATCH_BIN" "$MUT51/m10.sh"; then
  ok "51c — M10 mutant differs from the dispatcher (the sentinel check was found)"
  if extract_validator "$MUT51/m10.sh" "$MUT51/m10.lib"; then
    val_expect "$MUT51/m10.lib" "$V51/midsentinel" 0 ok \
      "51c — M10: without the sentinel check a non-final record is accepted (51b is fail-capable)"
  else
    bad "51c — M10: without the sentinel check a non-final record is accepted (51b is fail-capable)" \
        "no validator region in the mutant"
  fi
else
  bad "51c — M10 mutant differs from the dispatcher (the sentinel check was found)" \
      "the sed matched nothing — the control cannot run"
fi

# ==================================================================== done
echo
echo "-----------------------------------------------"
printf 'pass=%d fail=%d  (all cases SIMULATED — no live product transport)\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] || exit 1
