#!/bin/bash
# Focused failing-case harness for the Work Loop v2 handoff dispatcher spike.
#
# Every case here is SIMULATED: actors are replaced by --actor-cmd, so this
# harness proves controller logic only. It deliberately cannot prove live
# product transport — that is a separate, explicitly-labelled live run.
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

PASS=0; FAIL=0
SANDBOX_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/wl2-dispatch-test.XXXXXX")"
trap 'rm -rf "$SANDBOX_ROOT"' EXIT

ok()   { PASS=$((PASS+1)); printf '  PASS  %s\n' "$1"; }
bad()  { FAIL=$((FAIL+1)); printf '  FAIL  %s\n' "$1"; [ -n "${2:-}" ] && printf '        %s\n' "$2"; }

# ---------------------------------------------------------------- fixtures

state_file() { # dir task turn [declared-task]
  local dir="$1" task="$2" turn="$3" declared="${4:-$2}"
  cat >"$dir/logs/work-loop/$task.md" <<EOF
---
task: $declared
turn: $turn
---

## Objective and scope
Sandbox fixture for the dispatcher harness. No real work.

## Lane and unit
Standard. Unit 1 — harness fixture.

## Latest result
Not started.

## Blocker
None.

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
  mkdir -p "$d/logs/work-loop" "$d/plans/work-loop-v2-v0.2/handoff-automation-spike"
  git -C "$d" init -q
  git -C "$d" config user.email harness@example.invalid
  git -C "$d" config user.name  harness
  printf 'sandbox\n' >"$d/README.md"
  printf 'unrelated tracked file\n' >"$d/other.txt"
  git -C "$d" add README.md other.txt
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
FLIP_BODY='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls";
      t=$(awk "NR==3" "$WL_STATE_FILE");
      case "$t" in
        "turn: codex")  n="turn: claude" ;;
        "turn: claude") n="turn: codex"  ;;
        *) n="$t" ;;
      esac;
      awk -v n="$n" "NR==3{print n; next}{print}" "$WL_STATE_FILE" > "$WL_STATE_FILE.tmp";
      mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"'

FLIP="$FLIP_BODY$COMMIT_IF_CLAUDE"

FLIP_TO_OPERATOR='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls";
      awk "NR==3{print \"turn: operator\"; next}{print}" "$WL_STATE_FILE" > "$WL_STATE_FILE.tmp";
      mv "$WL_STATE_FILE.tmp" "$WL_STATE_FILE"'"$COMMIT_IF_CLAUDE"

NOOP='printf "%s\n" "$WL_TASK" >> "$WL_CHECKOUT.calls"; exit 0'

run_dispatch() { # sandbox task [extra args...] -> writes $OUT, sets $RC
  local d="$1" t="$2"; shift 2
  OUT="$(bash "$DISPATCH_BIN" --checkout "$d" --task "$t" \
        --log-dir "$d/runs" --timeout 20 "$@" 2>&1)"
  RC=$?
}

calls() { # sandbox -> number of actor invocations
  [ -f "$1.calls" ] && wc -l <"$1.calls" | tr -d ' ' || printf '0'
}

expect_rc() { # want got label [detail]
  if [ "$2" -eq "$1" ]; then ok "$3"; else bad "$3" "expected exit $1, got $2 — ${4:-}"; fi
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
      if [ "$WL_HOP" -ge 3 ]; then n="turn: operator";
      elif [ "$WL_ACTOR" = "codex" ]; then n="turn: claude"; else n="turn: codex"; fi;
      awk -v n="$n" "NR==3{print n; next}{print}" "$WL_STATE_FILE" > "$WL_STATE_FILE.tmp";
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
wait "$outer" 2>/dev/null

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
      { printf -- "---\ntask: %s\nturn: operator\n---\n\n" "$WL_TASK";
        printf "## Objective and scope\nSandbox fixture.\n\n";
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
      { printf -- "---\ntask: %s\nturn: operator\n---\n\n" "$WL_TASK";
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
LK="${TMPDIR:-/tmp}/work-loop-dispatch-$(printf '%s|%s' "$(cd "$d" && pwd -P)" "sig-task" | shasum -a 256 | cut -c1-16).lock"

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
  rm -rf "${TMPDIR:-/tmp}/work-loop-dispatch-$(printf '%s|%s' "$(cd "$1" && pwd -P)" "$2" | shasum -a 256 | cut -c1-16).lock" 2>/dev/null
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
# A descendant that escapes the group, is re-parented away, AND closes both
# inherited descriptors is invisible to all three handles: no group, no ancestry,
# no fd. It survives, and — this is the part that matters — the dispatcher must
# not claim otherwise. Its success line is deliberately scoped to what it can see.
# If someone later widens that wording to an unqualified "the tree is gone", this
# case fails, which is the point of testing a limitation.
echo
echo "Case 27h — a descendant that also CLOSES its inherited descriptors survives, and the claim stays scoped"
d="$(new_sandbox)"; state_file "$d" "residual-task" "claude"
SR="$SANDBOX_ROOT/sig27h"; mkdir -p "$SR"
INVISIBLE='python3 -c "
import os, sys
if os.fork() > 0: os._exit(0)
os.setsid()
if os.fork() > 0: os._exit(0)
with open(\"'"$SR"'/escapee.pid\",\"w\") as f: f.write(str(os.getpid()))
n = os.open(os.devnull, os.O_RDWR)
os.dup2(n,0); os.dup2(n,1); os.dup2(n,2)
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
  awk "NR==3{print \"turn: codex\"; next}{print}" "$WL_STATE_FILE" > "$WL_STATE_FILE.tmp";
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
LK="${TMPDIR:-/tmp}/work-loop-dispatch-$(printf '%s|%s' "$(cd "$d" && pwd -P)" "status-task" | shasum -a 256 | cut -c1-16).lock"
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
rm -rf "${TMPDIR:-/tmp}/work-loop-dispatch-$(printf '%s|%s' "$(cd "$d" && pwd -P)" "inflight" | shasum -a 256 | cut -c1-16).lock" 2>/dev/null

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
lock_path_for() { # checkout task -> lock dir
  printf '%s/work-loop-dispatch-%s.lock' "${TMPDIR:-/tmp}" \
    "$(printf '%s|%s' "$(cd "$1" && pwd -P)" "$2" | shasum -a 256 | cut -c1-16)"
}

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
  printf '%s' "$OUT" | grep -qi "MAY BELONG TO A LIVE DISPATCHER" \
    && ok "says the lock may belong to a live dispatcher" \
    || bad "says the lock may belong to a live dispatcher" "$OUT"
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
awk 'NR==3{print "turn: codex"; next}{print}' "$sf" > "$sf.tmp" && mv "$sf.tmp" "$sf"
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
else
  bad "the fake claude binary was invoked" "no argv file at $WL_ARGV_FILE"
fi
printf '%s' "$OUT" | grep -q "claude_deny=Bash(git push:\*) WebFetch" \
  && ok "the run log records the deny rules the run was launched under" \
  || bad "the run log records the deny rules" "$OUT"

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
  grep -qx -- "--disallowedTools" "$WL_ARGV_FILE" \
    && bad "no --disallowedTools is passed when none was asked for" "argv: $(tr '\n' ' ' <"$WL_ARGV_FILE")" \
    || ok "no --disallowedTools is passed when none was asked for"
else
  bad "the fake claude binary was invoked" "no argv file"
fi
printf '%s' "$OUT" | grep -q "claude_deny=none" \
  && ok "the run log says plainly that the child holds normal authority" \
  || bad "the run log says plainly that the child holds normal authority" "$OUT"
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
awk 'NR==3{print "turn: codex"; next}{print}' "$sf" > "$sf.tmp" && mv "$sf.tmp" "$sf"
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

# ==================================================================== done
echo
echo "-----------------------------------------------"
printf 'pass=%d fail=%d  (all cases SIMULATED — no live product transport)\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] || exit 1
