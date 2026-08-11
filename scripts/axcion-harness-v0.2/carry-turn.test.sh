#!/bin/bash
# Deterministic suite for carry-turn.sh — Axcíon Harness v0.2.
#
# Hermetic. Every case builds a throwaway Git checkout under $TMPDIR, drives it
# with a FAKE actor binary, and deletes it afterwards. No case reads or writes
# the repository this file lives in, and no case launches a real model.
#
# The fake actor is passed with --claude-bin / --codex-bin, which are ordinary
# operator options. There is no simulated-actor seam in carry-turn.sh, so the
# launcher under test builds and executes its REAL argv on every case here —
# what the fake binary records is what a live claude would have received.
#
# Usage:
#   carry-turn.test.sh                 run the suite (green)
#   carry-turn.test.sh --prove-failure run the fail-capability proof (red)
#
# The proof mutates a COPY of the launcher — one invariant removed per mutant —
# and requires the matching assertions to FAIL. A suite that stays green against
# a launcher with its permission mode stripped out is not evidence, and this is
# how that is demonstrated rather than asserted.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
SUT="$HERE/carry-turn.sh"

PASS=0
FAIL=0
FAILED_NAMES=()

# In --prove-failure runs, assertions are expected to fail: a failing assertion
# scores as a proof-hit and a passing one is the problem.
EXPECT_FAIL=0

RC=0
o=""

ok()  { PASS=$((PASS+1)); printf '  ok   %s\n' "$1"; }
bad() { FAIL=$((FAIL+1)); FAILED_NAMES+=("$1"); printf '  FAIL %s\n       %s\n' "$1" "${2:-}"; }

assert_eq() { # name, expected, actual
  if [ "$2" = "$3" ]; then
    if [ "$EXPECT_FAIL" -eq 1 ]; then bad "$1 (should have failed under mutation)" "got '$3'"; else ok "$1"; fi
  else
    if [ "$EXPECT_FAIL" -eq 1 ]; then ok "$1 — correctly failed under mutation (wanted '$2', got '$3')"
    else bad "$1" "expected '$2', got '$3'"; fi
  fi
}

assert_contains() { # name, needle, haystack
  if printf '%s' "$3" | grep -qF -- "$2"; then
    if [ "$EXPECT_FAIL" -eq 1 ]; then bad "$1 (should have failed under mutation)" "found '$2'"; else ok "$1"; fi
  else
    if [ "$EXPECT_FAIL" -eq 1 ]; then ok "$1 — correctly failed under mutation (missing '$2')"
    else bad "$1" "missing '$2' in: $(printf '%s' "$3" | head -c 300)"; fi
  fi
}

assert_absent() { # name, needle, haystack  (never inverted by EXPECT_FAIL)
  if printf '%s' "$3" | grep -qF -- "$2"; then bad "$1" "found forbidden '$2'"; else ok "$1"; fi
}

# ---------------------------------------------------------------- fixtures

TMPROOT="$(mktemp -d "${TMPDIR:-/tmp}/axh-test.XXXXXX")"
cleanup() { rm -rf "$TMPROOT"; }
trap cleanup EXIT

# A fake actor binary. It answers --version, records its argv and its invocation
# count, and then performs one scripted action on the state file.
#
# ACTIONS (read from $ACTION_FILE at run time, so a fixture can be re-aimed):
#   transition:<turn>  rewrite turn:, add a line, commit
#   nocommit:<turn>    rewrite turn:, add a line, do NOT commit
#   noop               change nothing at all
#   touch-only         change the body, leave turn: alone, commit
#   foreign            create an out-of-allowlist working-tree file
#   commit-foreign     create AND commit an out-of-allowlist file, plus transition
#   fail:<code>        exit <code>, touching nothing
#   sleep:<secs>       sleep, then exit 0
make_fake_actor() { # path, argv-log, count-file, action-file, state-file
  cat >"$1" <<'FAKE'
#!/bin/bash
ARGV_LOG="__ARGV__"; COUNT="__COUNT__"; ACTION_FILE="__ACTION__"; STATE="__STATE__"
for a in "$@"; do [ "$a" = "--version" ] && { echo "fake-actor 0.0.1"; exit 0; }; done
printf '%s\n' "$*" >>"$ARGV_LOG"
printf 'x' >>"$COUNT"
REPO="$(dirname "$(dirname "$(dirname "$STATE")")")"
STATE_REL="logs/work-loop/$(basename "$STATE")"
act="$(cat "$ACTION_FILE" 2>/dev/null)"
stamp="$(date '+%s')-$RANDOM"
case "$act" in
  transition:*)
    sed -i '' "s/^turn: .*/turn: ${act#transition:}/" "$STATE"
    printf '\nactor ran %s\n' "$stamp" >>"$STATE"
    git -C "$REPO" add -- "$STATE_REL" >/dev/null 2>&1
    git -C "$REPO" commit -q -m "actor: handed on" >/dev/null 2>&1 ;;
  nocommit:*)
    sed -i '' "s/^turn: .*/turn: ${act#nocommit:}/" "$STATE"
    printf '\nactor edited, did not commit %s\n' "$stamp" >>"$STATE" ;;
  noop) : ;;
  touch-only)
    printf '\nbody moved, turn did not %s\n' "$stamp" >>"$STATE"
    git -C "$REPO" add -- "$STATE_REL" >/dev/null 2>&1
    git -C "$REPO" commit -q -m "actor: body only" >/dev/null 2>&1 ;;
  foreign)
    printf 'stray\n' >"$REPO/src-stray.txt" ;;
  commit-foreign)
    printf 'stray\n' >"$REPO/src-stray.txt"
    sed -i '' "s/^turn: .*/turn: codex/" "$STATE"
    printf '\nforeign commit %s\n' "$stamp" >>"$STATE"
    git -C "$REPO" add -A >/dev/null 2>&1
    git -C "$REPO" commit -q -m "actor: foreign commit" >/dev/null 2>&1 ;;
  fail:*) exit "${act#fail:}" ;;
  sleep:*) sleep "${act#sleep:}"; exit 0 ;;
esac
exit 0
FAKE
  sed -i '' -e "s|__ARGV__|$2|" -e "s|__COUNT__|$3|" -e "s|__ACTION__|$4|" -e "s|__STATE__|$5|" "$1"
  chmod +x "$1"
}

# Build a fixture. Sets: REPO STATE ACTION ARGVLOG COUNTF FAKEBIN LOGD
mkfix() { # name, task-id, turn
  local name="$1" task="$2" turn="$3"
  REPO="$TMPROOT/$name"
  mkdir -p "$REPO/logs/work-loop"
  git -C "$REPO" init -q 2>/dev/null
  git -C "$REPO" config user.email t@example.com
  git -C "$REPO" config user.name Test
  git -C "$REPO" config commit.gpgsign false
  STATE="$REPO/logs/work-loop/$task.md"
  {
    printf -- '---\ntask: %s\nturn: %s\n---\n\n' "$task" "$turn"
    printf '## Objective and scope\nA fixture.\n\n## Lane and unit\nStandard. Implementation mode. Unit 1 — fixture.\n\n## Latest result\nNothing yet.\n\n## Blocker\nNone.\n\n## Next action\nDo the thing.\n'
  } >"$STATE"
  printf 'seed\n' >"$REPO/seed.txt"
  git -C "$REPO" add -A >/dev/null 2>&1
  git -C "$REPO" commit -q -m init >/dev/null 2>&1

  ACTION="$TMPROOT/$name.action"; printf 'noop' >"$ACTION"
  ARGVLOG="$TMPROOT/$name.argv"; : >"$ARGVLOG"
  COUNTF="$TMPROOT/$name.count"; : >"$COUNTF"
  FAKEBIN="$TMPROOT/$name.actor"; make_fake_actor "$FAKEBIN" "$ARGVLOG" "$COUNTF" "$ACTION" "$STATE"
  LOGD="$TMPROOT/$name.runs"
}

# Sets the globals RC and o. Deliberately NOT called inside $( ), which would
# put the assignment in a subshell and throw the exit code away.
run_sut() {
  o="$("$SUT" "$@" 2>&1)"
  RC=$?
}

run_bin() { # binary, args...  — same, for a mutant
  local b="$1"; shift
  o="$("$b" "$@" 2>&1)"
  RC=$?
}

invocations() { wc -c <"$COUNTF" | tr -d ' '; }
turn_on_disk() { awk '/^turn: /{print $2; exit}' "$STATE"; }

section() { printf '\n%s\n' "$1"; }

# ------------------------------------------------------------------- suite

run_suite() {

section "1. Static checks"
  bash -n "$SUT" 2>/dev/null; assert_eq "launcher parses (bash -n)" "0" "$?"
  bash -n "$HERE/carry-turn.test.sh" 2>/dev/null; assert_eq "suite parses (bash -n)" "0" "$?"
  bypass_on_launch="$(grep 'dangerously-skip-permissions' "$SUT" | grep -c 'run_bounded' | tr -d ' ')"
  assert_eq "no --dangerously-skip-permissions on any launch line" "0" "$bypass_on_launch"
  assert_absent "no unattended-mode variable" "UNATTENDED=1" "$(cat "$SUT")"
  assert_absent "no unbounded hop loop" "while :; do" "$(cat "$SUT")"

section "2. Exact task and checkout binding"
  mkfix bind task-a claude
  run_sut --checkout "$REPO" --task '../escape' --log-dir "$LOGD"
  assert_eq "traversal task id rejected" "12" "$RC"
  assert_contains "  reports BAD_TASK_ID" "RESULT outcome=STOPPED code=12" "$o"
  run_sut --checkout "$REPO" --task 'bad id!' --log-dir "$LOGD"
  assert_eq "illegal-character task id rejected" "12" "$RC"
  run_sut --checkout "$TMPROOT/no-such-dir" --task task-a --log-dir "$LOGD"
  assert_eq "non-existent checkout rejected" "11" "$RC"
  mkdir -p "$TMPROOT/plain-dir"
  run_sut --checkout "$TMPROOT/plain-dir" --task task-a --log-dir "$LOGD"
  assert_eq "non-git checkout rejected" "11" "$RC"
  assert_eq "  nothing was launched" "0" "$(invocations)"

section "3. Malformed and mismatched state"
  mkfix mism task-b claude
  run_sut --checkout "$REPO" --task nosuchtask --log-dir "$LOGD"
  assert_eq "missing state file rejected" "13" "$RC"
  cp "$STATE" "$REPO/logs/work-loop/task-c.md"   # frontmatter still says task-b
  run_sut --checkout "$REPO" --task task-c --log-dir "$LOGD"
  assert_eq "identity mismatch rejected" "14" "$RC"
  assert_contains "  names both sides" "frontmatter says task: 'task-b'" "$o"
  printf 'no frontmatter here\n' >"$REPO/logs/work-loop/task-d.md"
  run_sut --checkout "$REPO" --task task-d --log-dir "$LOGD"
  assert_eq "absent frontmatter rejected" "14" "$RC"
  assert_eq "  nothing was launched" "0" "$(invocations)"

section "4. Wrong or absent turn"
  mkfix badturn task-e claude
  sed -i '' 's/^turn: .*/turn: nobody/' "$STATE"
  run_sut --checkout "$REPO" --task task-e --log-dir "$LOGD"
  assert_eq "unknown turn value rejected" "15" "$RC"
  sed -i '' '/^turn: /d' "$STATE"
  run_sut --checkout "$REPO" --task task-e --log-dir "$LOGD"
  assert_eq "absent turn rejected" "15" "$RC"
  assert_eq "  nothing was launched" "0" "$(invocations)"

section "5. Attended permission-mode argv (real argv, fake binary)"
  mkfix argv task-f claude
  printf 'transition:codex' >"$ACTION"
  run_sut --checkout "$REPO" --task task-f --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "ordinary attended launch carries the turn" "0" "$RC"
  argv="$(cat "$ARGVLOG")"
  assert_contains "argv carries --permission-mode default" "--permission-mode default" "$argv"
  assert_contains "argv carries the task-scoped command" "-p /work-loop-v2 task-f" "$argv"
  assert_contains "argv carries --output-format json" "--output-format json" "$argv"
  assert_absent "argv has no permission bypass" "--dangerously-skip-permissions" "$argv"

  mkfix argvdeny task-g claude
  printf 'transition:codex' >"$ACTION"
  run_sut --checkout "$REPO" --task task-g --claude-bin "$FAKEBIN" \
          --claude-deny 'Bash(git push:*)' --log-dir "$LOGD"
  assert_eq "deny-narrowed launch carries the turn" "0" "$RC"
  argv="$(cat "$ARGVLOG")"
  assert_contains "deny path ALSO carries --permission-mode default" "--permission-mode default" "$argv"
  assert_contains "deny path passes the deny rule through" "--disallowedTools Bash(git push:*)" "$argv"
  assert_absent "deny path has no permission bypass" "--dangerously-skip-permissions" "$argv"

section "6. One hop per invocation"
  mkfix onehop task-h claude
  printf 'transition:codex' >"$ACTION"
  run_sut --checkout "$REPO" --task task-h --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "carry succeeds" "0" "$RC"
  assert_eq "exactly one actor invocation" "1" "$(invocations)"
  assert_contains "reports CARRIED" "RESULT outcome=CARRIED code=0" "$o"
  assert_contains "  names the transition" "turn_before=claude turn_after=codex" "$o"
  assert_contains "  does not continue to the next actor" "Not continuing to 'codex'" "$o"
  assert_eq "turn on disk is now codex" "codex" "$(turn_on_disk)"

section "7. Attended-boundary refusals fail closed"
  mkfix refuse task-i claude
  for f in --unattended --loop --max-hops --carry-all --worktree --hook --daemon \
           --dangerously-skip-permissions --permission-mode --bypass-permissions \
           --actor-cmd --status --isolate --continue --sandbox --watch; do
    run_sut --checkout "$REPO" --task task-i --claude-bin "$FAKEBIN" --log-dir "$LOGD" "$f" x
    if [ "$RC" -eq 10 ] && printf '%s' "$o" | grep -q 'is refused:'; then
      ok "refused $f (exit 10, actionable)"
    else
      bad "refused $f" "exit=$RC out=$(printf '%s' "$o" | head -c 160)"
    fi
  done
  assert_eq "no refusal launched anything" "0" "$(invocations)"
  run_sut --checkout "$REPO" --task task-i --nonsense --log-dir "$LOGD"
  assert_eq "unknown flag is ordinary BAD_USAGE" "10" "$RC"
  assert_contains "  and still prints a RESULT line" "RESULT outcome=STOPPED code=10" "$o"

section "8. Operator-terminal stop"
  mkfix opq task-j operator
  run_sut --checkout "$REPO" --task task-j --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "operator turn stops at 0" "0" "$RC"
  assert_contains "  reports OPERATOR_TERMINAL, not CARRIED" "RESULT outcome=OPERATOR_TERMINAL code=0" "$o"
  assert_contains "  surfaces the unanswered question" "UNANSWERED" "$o"
  assert_eq "  nothing was launched" "0" "$(invocations)"

  mkfix opclosed task-k operator
  { printf -- '---\ntask: task-k\nturn: operator\n---\n\n'
    printf '## Outcome\nDone.\n\n## Decisions that matter\nOne.\n\n## Evidence\nabc123\n\n## Accepted limitations\nNone.\n'
  } >"$STATE"
  # Committed, because Claude commits its own closing record. Left uncommitted
  # this is exit 25, not a closed task — which is what the launcher said when
  # this fixture first forgot to commit.
  git -C "$REPO" commit -qam "closing record" >/dev/null 2>&1
  run_sut --checkout "$REPO" --task task-k --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "a closing record stops at 0" "0" "$RC"
  assert_contains "  reports the task CLOSED" "The task is CLOSED" "$o"
  assert_absent "  asserts no question that does not exist" "UNANSWERED" "$o"

  mkfix opbad task-l operator
  printf -- '---\ntask: task-l\nturn: operator\n---\n\n## Something Else\nhalf-written.\n' >"$STATE"
  git -C "$REPO" commit -qam "half-written" >/dev/null 2>&1
  run_sut --checkout "$REPO" --task task-l --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "neither shape is MALFORMED_TERMINAL" "26" "$RC"
  assert_eq "  and still launched nothing" "0" "$(invocations)"

section "9. Transition validation"
  mkfix noopc task-m claude
  printf 'noop' >"$ACTION"
  run_sut --checkout "$REPO" --task task-m --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "byte-identical state is NO_TRANSITION" "22" "$RC"
  assert_contains "  and says why" "byte-identical" "$o"

  mkfix samet task-n claude
  printf 'touch-only' >"$ACTION"
  run_sut --checkout "$REPO" --task task-n --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "edited body with unchanged turn is NO_TRANSITION" "22" "$RC"

  mkfix selft task-o claude
  printf 'transition:claude' >"$ACTION"
  run_sut --checkout "$REPO" --task task-o --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "claude -> claude is NO_TRANSITION" "22" "$RC"

  mkfix toop task-p claude
  printf 'transition:operator' >"$ACTION"
  run_sut --checkout "$REPO" --task task-p --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "claude -> operator is allowed" "0" "$RC"
  assert_contains "  and says automation is terminal there" "automation is terminal" "$o"

section "10. Actor failure and timeout"
  mkfix afail task-q claude
  printf 'fail:20' >"$ACTION"
  run_sut --checkout "$REPO" --task task-q --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "non-zero actor exit is ACTOR_FAILED" "20" "$RC"
  assert_eq "  and is NOT retried" "1" "$(invocations)"
  assert_contains "  reports STOPPED 20" "RESULT outcome=STOPPED code=20" "$o"

  mkfix atime task-r claude
  printf 'sleep:30' >"$ACTION"
  run_sut --checkout "$REPO" --task task-r --claude-bin "$FAKEBIN" --timeout 1 --log-dir "$LOGD"
  assert_eq "overrunning actor is ACTOR_TIMEOUT" "21" "$RC"
  assert_contains "  reports STOPPED 21" "RESULT outcome=STOPPED code=21" "$o"

section "11. Repository ambiguity stops"
  mkfix fdirty task-s claude
  printf 'unrelated\n' >"$REPO/unrelated.txt"
  run_sut --checkout "$REPO" --task task-s --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "pre-existing foreign change stops (18)" "18" "$RC"
  assert_eq "  before launching anything" "0" "$(invocations)"

  mkfix fstaged task-t claude
  printf 'staged\n' >"$REPO/staged.txt"
  git -C "$REPO" add staged.txt >/dev/null 2>&1
  run_sut --checkout "$REPO" --task task-t --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "pre-staged path stops (16)" "16" "$RC"

  mkfix haz task-u claude
  : >"$REPO/.git/index.lock"
  run_sut --checkout "$REPO" --task task-u --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "git hazard stops (19)" "19" "$RC"
  rm -f "$REPO/.git/index.lock"

  mkfix fout task-v claude
  printf 'foreign' >"$ACTION"
  run_sut --checkout "$REPO" --task task-v --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "actor writing outside the allowlist stops (24)" "24" "$RC"

  mkfix fcommit task-w claude
  printf 'commit-foreign' >"$ACTION"
  run_sut --checkout "$REPO" --task task-w --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "actor COMMITTING outside the allowlist stops (30)" "30" "$RC"
  assert_contains "  named as a commit, not a worktree problem" "COMMITTED paths outside" "$o"

  mkfix uncom task-x claude
  printf 'nocommit:codex' >"$ACTION"
  run_sut --checkout "$REPO" --task task-x --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "Claude handing back uncommitted stops (25)" "25" "$RC"
  assert_contains "  and names the permission cause" "refused git permission" "$o"

section "12. Lock — one actor at a time"
  mkfix lock task-y claude
  # The key must be built from the CANONICAL checkout path, because that is what
  # the launcher canonicalizes to before hashing. On macOS $TMPDIR resolves
  # /var -> /private/var, so hashing the raw fixture path produced a different
  # lock and every case in this section silently passed against nothing.
  rp="$(cd "$REPO" && pwd -P)"
  key="$(printf '%s|%s' "$rp" task-y | shasum -a 256 | cut -c1-16)"
  ld="${TMPDIR:-/tmp}/axcion-harness-v0.2.$key.lock"
  rm -rf "$ld"; mkdir -p "$ld"; printf '%s\n' "$$" >"$ld/pid"   # this shell is alive
  run_sut --checkout "$REPO" --task task-y --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "a live lock holder blocks the carry (17)" "17" "$RC"
  assert_eq "  and nothing launched" "0" "$(invocations)"
  assert_eq "  and the lock survives" "1" "$([ -d "$ld" ] && echo 1 || echo 0)"

  ( exit 0 ) & deadpid=$!; wait "$deadpid" 2>/dev/null   # a pid that is now gone
  rm -rf "$ld"; mkdir -p "$ld"; printf '%s\n' "$deadpid" >"$ld/pid"
  printf 'transition:codex' >"$ACTION"
  run_sut --checkout "$REPO" --task task-y --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "a provably stale lock is cleared and the carry runs" "0" "$RC"
  assert_contains "  and says so" "removing a stale lock" "$o"

  rm -rf "$ld"; mkdir -p "$ld"; : >"$ld/pid"            # unreadable holder
  run_sut --checkout "$REPO" --task task-y --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "an uninspectable lock is treated as held (17)" "17" "$RC"
  rm -rf "$ld"

section "13. Dry run and the Codex direction"
  mkfix dry task-z claude
  run_sut --checkout "$REPO" --task task-z --claude-bin "$FAKEBIN" --dry-run --log-dir "$LOGD"
  assert_eq "dry run exits 0" "0" "$RC"
  assert_contains "  reports VALIDATED, not CARRIED" "RESULT outcome=VALIDATED code=0" "$o"
  assert_eq "  and launched nothing" "0" "$(invocations)"

  mkfix cdx task-aa codex
  # nocommit, not transition: Codex writes the file and never runs git (core § 4).
  # A committing Codex hop is exit 24, which is what the launcher said when this
  # fixture first used the committing action.
  printf 'nocommit:claude' >"$ACTION"
  run_sut --checkout "$REPO" --task task-aa --codex-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "codex -> claude is carried" "0" "$RC"
  argv="$(cat "$ARGVLOG")"
  assert_contains "codex argv is exec --sandbox workspace-write" "exec --sandbox workspace-write" "$argv"
  assert_contains "codex prompt names the exact task" "The task is exactly: task-aa" "$argv"

  mkfix cdxhead task-ab codex
  printf 'commit-foreign' >"$ACTION"
  run_sut --checkout "$REPO" --task task-ab --codex-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "Codex moving HEAD stops (24)" "24" "$RC"
  assert_contains "  as the protocol violation it is" "Codex never runs git" "$o"

section "14. The state file is never written by the launcher"
  mkfix ro task-ac claude
  before="$(shasum -a 256 "$STATE" | cut -d' ' -f1)"
  run_sut --checkout "$REPO" --task task-ac --claude-bin "$FAKEBIN" --dry-run --log-dir "$LOGD"
  assert_eq "dry run left the state file byte-identical" "$before" "$(shasum -a 256 "$STATE" | cut -d' ' -f1)"
  printf 'fail:7' >"$ACTION"
  run_sut --checkout "$REPO" --task task-ac --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "a failed hop left the state file byte-identical" "$before" "$(shasum -a 256 "$STATE" | cut -d' ' -f1)"

}

# ------------------------------------------------------- fail-capability proof
#
# Each mutant removes exactly ONE invariant from a copy of the launcher and
# re-runs only the assertions that invariant protects. Those assertions MUST
# fail. A mutant that leaves the suite green means the suite was not testing
# what it claimed to test.

mutant_ok() { # path — parses and still runs
  bash -n "$1" 2>/dev/null
}

prove_failure() {
  local mut

  section "M1. Strip --permission-mode default from the attended argv"
  mut="$TMPROOT/mutant-permmode.sh"
  sed -e 's/^\( *\)--permission-mode default \\$/\1\\/' \
      -e 's/^\( *\)--permission-mode default$/\1/' "$SUT" >"$mut"
  chmod +x "$mut"
  if ! mutant_ok "$mut"; then bad "M1 mutant does not parse" "bad mutation"; else
    mkfix m1 task-m1 claude
    printf 'transition:codex' >"$ACTION"
    run_bin "$mut" --checkout "$REPO" --task task-m1 --claude-bin "$FAKEBIN" --log-dir "$LOGD"
    EXPECT_FAIL=1
    assert_contains "argv carries --permission-mode default" "--permission-mode default" "$(cat "$ARGVLOG")"
    EXPECT_FAIL=0
  fi

  # BOTH transition guards, because they are redundant by design: the
  # unchanged-turn check rejects claude -> claude before the table is reached,
  # and the table rejects it again if that check is removed. Disabling either
  # alone changes nothing — which is the point of keeping both, and the reason
  # this mutant has to take out the pair to prove the assertion is load-bearing.
  section "M2. Neutralise BOTH transition guards"
  mut="$TMPROOT/mutant-transition.sh"
  sed -e 's|^if \[ "\$after_turn" = "\$before_turn" \]; then$|if false; then|' \
      -e 's|^    die 22 "transition .*|    say "  transition: forced by mutant" ;;|' "$SUT" >"$mut"
  chmod +x "$mut"
  if ! mutant_ok "$mut"; then bad "M2 mutant does not parse" "bad mutation"; else
    mkfix m2 task-m2 claude
    printf 'transition:claude' >"$ACTION"
    run_bin "$mut" --checkout "$REPO" --task task-m2 --claude-bin "$FAKEBIN" --log-dir "$LOGD"
    EXPECT_FAIL=1
    assert_eq "claude -> claude is NO_TRANSITION" "22" "$RC"
    EXPECT_FAIL=0
  fi

  section "M3. Remove the attended-boundary refusals"
  mut="$TMPROOT/mutant-refuse.sh"
  sed 's|^  refuse_flag "\$1"$|  :|' "$SUT" >"$mut"
  chmod +x "$mut"
  if ! mutant_ok "$mut"; then bad "M3 mutant does not parse" "bad mutation"; else
    mkfix m3 task-m3 claude
    run_bin "$mut" --checkout "$REPO" --task task-m3 --claude-bin "$FAKEBIN" --log-dir "$LOGD" --unattended x
    if [ "$RC" -eq 10 ] && printf '%s' "$o" | grep -q 'is refused:'; then
      bad "refused --unattended (should have failed under mutation)" "still refused"
    else
      ok "refused --unattended — correctly failed under mutation (exit $RC, no refusal text)"
    fi
  fi

  section "M4. Remove the pre-launch foreign-worktree stop"
  mut="$TMPROOT/mutant-foreign.sh"
  sed 's|^if \[ -n "\$before_foreign" \]; then$|if false; then|' "$SUT" >"$mut"
  chmod +x "$mut"
  if ! mutant_ok "$mut"; then bad "M4 mutant does not parse" "bad mutation"; else
    mkfix m4 task-m4 claude
    printf 'transition:codex' >"$ACTION"
    printf 'unrelated\n' >"$REPO/unrelated.txt"
    run_bin "$mut" --checkout "$REPO" --task task-m4 --claude-bin "$FAKEBIN" --log-dir "$LOGD"
    EXPECT_FAIL=1
    assert_eq "pre-existing foreign change stops (18)" "18" "$RC"
    EXPECT_FAIL=0
  fi

  section "M5. Remove the uncommitted-handback guard"
  mut="$TMPROOT/mutant-uncommitted.sh"
  sed 's|^if \[ "\$before_turn" = "claude" \] && state_dirty; then$|if false; then|' "$SUT" >"$mut"
  chmod +x "$mut"
  if ! mutant_ok "$mut"; then bad "M5 mutant does not parse" "bad mutation"; else
    mkfix m5 task-m5 claude
    printf 'nocommit:codex' >"$ACTION"
    run_bin "$mut" --checkout "$REPO" --task task-m5 --claude-bin "$FAKEBIN" --log-dir "$LOGD"
    EXPECT_FAIL=1
    assert_eq "Claude handing back uncommitted stops (25)" "25" "$RC"
    EXPECT_FAIL=0
  fi
}

# --------------------------------------------------------------------- main

if [ "${1:-}" = "--prove-failure" ]; then
  printf 'carry-turn.sh — FAIL-CAPABILITY PROOF (each assertion below MUST fail)\n'
  prove_failure
else
  printf 'carry-turn.sh — deterministic suite\n'
  run_suite
fi

printf '\n----\npassed: %s   failed: %s\n' "$PASS" "$FAIL"
if [ "$FAIL" -ne 0 ]; then
  printf 'failing:\n'
  for n in "${FAILED_NAMES[@]}"; do printf '  - %s\n' "$n"; done
  exit 1
fi
exit 0
