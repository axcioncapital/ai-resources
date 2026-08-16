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
# The shared live-lease library. carry-turn.sh sources it out of the CHECKOUT it
# drives — the same resolution the ownership helper uses — so every fixture has to
# carry it or the fixture is not modelling a real checkout. Section 12c removes it
# deliberately, and that must stay the only case without it.
LEASE_BIN="${LEASE_BIN:-$(cd "$HERE/../.." && pwd -P)/logs/scripts/work-loop-lease.sh}"
# The durable ownership helper. It answers a different question from the lease —
# "does this task belong to this checkout?" rather than "is another run live?" —
# and the launcher resolves it out of the CHECKOUT too. Only section 12e carries
# it, because only 12e is about ownership; every other fixture is deliberately
# untouched by this unit.
OWNER_BIN="${OWNER_BIN:-$(cd "$HERE/../.." && pwd -P)/logs/scripts/work-loop-owner.sh}"
# The canonical state validator. Since the Tracer 3 cutover the launcher asks it
# for the state's classification instead of reading `turn:` itself, and stops at
# exit 13 when it is absent. A fixture without it would put every case in this
# suite on the fail-closed path rather than the behaviour it names.
STATE_BIN="${STATE_BIN:-$(cd "$HERE/../.." && pwd -P)/logs/scripts/work-loop-state.sh}"

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

# Processes literally NAMED `claude` and `codex`, so a fixture can produce a
# genuinely observable nested actor without launching a model. They are symlinks
# to /bin/sleep, and macOS reports `ps -o comm=` as the path the process was
# INVOKED by rather than the symlink's target — checked on this host on
# 2026-08-13 against a symlink named `claude` pointing at /bin/sleep, which
# reported the symlink path. That is the same shape the real CLIs take: the
# PATH install resolves to a version-numbered file through a `claude` symlink,
# and the VS Code build is `.../native-binary/claude`.
NESTDIR="$TMPROOT/nested-bin"
mkdir -p "$NESTDIR"
ln -sf /bin/sleep "$NESTDIR/claude"
ln -sf /bin/sleep "$NESTDIR/codex"

# A `ps` that always fails, first on PATH. Not a seam in the launcher — the
# launcher has none and must not grow one — but a real host condition: a census
# that cannot run must read as UNOBSERVED and never as an observed zero.
NOPSDIR="$TMPROOT/no-ps"
mkdir -p "$NOPSDIR"
printf '#!/bin/bash\nexit 1\n' >"$NOPSDIR/ps"
chmod +x "$NOPSDIR/ps"

# A `ps` that answers normally AND reports one extra member of whatever process
# group it is asked about. Same device as the stubbed `lsof` the dispatcher's
# suite uses to inject a survivor into its census, and for the same reason: a
# process that genuinely outlives SIGKILL cannot be manufactured — a same-uid
# process group is always cleared — so the survivor is injected at the point the
# launcher LOOKS rather than by defeating the kernel.
#
# The injected pid is this suite's own shell, so "still running" is a claim about
# something that really is running. It is never signalled: the launcher signals
# the process GROUP and never an individual pid, which is what makes the
# injection safe as well as deterministic.
#
# Only the `-g` form is touched. The launcher's readability control (`ps -p $$`)
# passes straight through, so a stub that broke it could not masquerade as an
# empty group.
SURVPSDIR="$TMPROOT/survivor-ps"
mkdir -p "$SURVPSDIR"
cat >"$SURVPSDIR/ps" <<PSSTUB
#!/bin/bash
out="\$(/bin/ps "\$@" 2>/dev/null)"; rc=\$?
[ -n "\$out" ] && printf '%s\n' "\$out"
prev=""; g=""
for a in "\$@"; do [ "\$prev" = "-g" ] && g="\$a"; prev="\$a"; done
if [ -n "\$g" ]; then printf '%s %s\n' "$$" "\$g"; rc=0; fi
exit "\$rc"
PSSTUB
chmod +x "$SURVPSDIR/ps"
SURVPID="$$"

# A `ps` whose `-p` form works and whose `-g` form CANNOT RUN. This is the host
# condition the whole-`ps` stub above cannot express, and it is the one that
# matters: the launcher asks about a process group with `-g`, so a readability
# control that only exercises `-p` proves the wrong thing. Under this stub a
# broken group query returns no rows and a genuinely empty group returns no rows,
# and only a control on the SAME form can tell them apart.
#
# On this platform `ps -g` exits non-zero for an empty group as well as for a
# failure (checked 2026-08-15: an unused in-range pgid gives rc=1 with no
# output), so propagating that exit status directly would make every clean
# shutdown read as unknown. The exit status is not the discriminator; the
# positive control is.
NOGPSDIR="$TMPROOT/no-ps-g"
mkdir -p "$NOGPSDIR"
cat >"$NOGPSDIR/ps" <<'PSGSTUB'
#!/bin/bash
for a in "$@"; do [ "$a" = "-g" ] && exit 1; done
exec /bin/ps "$@"
PSGSTUB
chmod +x "$NOGPSDIR/ps"

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
#   ignore-term:<secs> IGNORE SIGTERM and sleep, so the launcher's TERM grace
#                      expires and it reaches the SIGKILL-and-verify branch
#
# The actions below emit a Claude-shaped result object on STDOUT, which is where
# the launcher's capture file gets it from. The permission_denials element shape
# — {tool_name, tool_use_id, tool_input} — was read off Claude Code 2.1.220 on
# 2026-08-13 by forcing a PreToolUse deny hook, not guessed:
#   denied             one denial, no repository effect at all
#   denied-partial     one denial, plus an ALLOWED file this hop created
#   denied-carried     one denial, but the hop still transitions and commits
#   denied-foreign     one denial, plus an out-of-allowlist file
#   allowed-partial    an allowed file, no denial evidence, then exit 3
#   dirty-noop         emit clean JSON with no denials, change nothing
#   nested-actor       start ONE process named `claude` and ONE named `codex`
#                      inside this actor's own process group, live long enough
#                      to be sampled, then transition and commit
#   nested-nocommit    the same, but transition WITHOUT committing — the shape a
#                      Codex hop has to take, since Codex never runs git
#   become-claude      transition, commit, then exec into a process named
#                      `claude` — the actor ITSELF matches the census rule
make_fake_actor() { # path, argv-log, count-file, action-file, state-file
  cat >"$1" <<'FAKE'
#!/bin/bash
ARGV_LOG="__ARGV__"; COUNT="__COUNT__"; ACTION_FILE="__ACTION__"; STATE="__STATE__"
NESTDIR="__NESTDIR__"
for a in "$@"; do [ "$a" = "--version" ] && { echo "fake-actor 0.0.1"; exit 0; }; done
printf '%s\n' "$*" >>"$ARGV_LOG"
# The same argv again, ONE ARGUMENT PER LINE and bracketed, because "$*" joins
# with spaces and so cannot tell `--disallowedTools 'A B'` (one argument) from
# `--disallowedTools A B` (two). Truncated per launch, so it always describes
# the launch just made rather than an accumulation.
: >"$ARGV_LOG.args"
for a in "$@"; do printf '[%s]\n' "$a" >>"$ARGV_LOG.args"; done
printf 'x' >>"$COUNT"
REPO="$(dirname "$(dirname "$(dirname "$STATE")")")"
STATE_REL="logs/work-loop/$(basename "$STATE")"
act="$(cat "$ACTION_FILE" 2>/dev/null)"
stamp="$(date '+%s')-$RANDOM"
# A Claude result object on stdout, which is exactly where the launcher's
# capture file gets it. Everything but permission_denials is filler.
emit_json() { printf '{"type":"result","subtype":"success","is_error":false,"result":"done","permission_denials":%s}\n' "$1"; }
# Handing a record to the operator is a LIFECYCLE change, not just a turn change:
# the canonical contract has no active/operator pair, so an actor that rewrote
# only `turn:` would leave a record no consumer may act on. A real Claude closing
# write reduces the file to the closing record, and so does this one.
set_turn() { # target-turn
  local t
  if [ "$1" = operator ]; then
    t="$(awk -F': ' '/^task: /{print $2; exit}' "$STATE")"
    printf -- '---\ntask: %s\nstatus: closed\nturn: operator\n---\n\n## Outcome\nHanded to the operator by the fixture actor.\n\n## Decisions that matter\nNothing real depends on this file.\n\n## Evidence\nFixture — no commit.\n\n## Accepted limitations\nNone.\n' "$t" >"$STATE"
  else
    sed -i '' "s/^turn: .*/turn: $1/" "$STATE"
  fi
}
case "$act" in
  transition:*)
    set_turn "${act#transition:}"
    printf '\nactor ran %s\n' "$stamp" >>"$STATE"
    git -C "$REPO" add -- "$STATE_REL" >/dev/null 2>&1
    git -C "$REPO" commit -q -m "actor: handed on" >/dev/null 2>&1 ;;
  nocommit:*)
    set_turn "${act#nocommit:}"
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
  ignore-term:*)
    # SIGTERM is IGNORED here, and an ignored disposition is inherited across
    # fork and exec, so the sleep below ignores it too. That is what carries the
    # launcher past its TERM grace and into the SIGKILL-and-verify branch — the
    # only path that can pin a lease. Nothing here survives SIGKILL and nothing
    # is meant to: the survivor is injected at the census, not at the kernel.
    trap '' TERM
    sleep "${act#ignore-term:}"
    exit 0 ;;
  denied)
    emit_json '[{"tool_name":"Bash","tool_use_id":"toolu_probe1","tool_input":{"command":"git commit -m handback","description":"commit"}}]' ;;
  denied-partial)
    printf 'partial\n' >"$REPO/logs/work-loop/partial-note.md"
    emit_json '[{"tool_name":"Write","tool_use_id":"toolu_probe2","tool_input":{"file_path":"logs/work-loop/partial-note.md"}}]' ;;
  denied-carried)
    sed -i '' "s/^turn: .*/turn: codex/" "$STATE"
    printf '\nactor ran with a denial %s\n' "$stamp" >>"$STATE"
    git -C "$REPO" add -- "$STATE_REL" >/dev/null 2>&1
    git -C "$REPO" commit -q -m "actor: handed on" >/dev/null 2>&1
    emit_json '[{"tool_name":"WebFetch","tool_use_id":"toolu_probe3","tool_input":{"url":"https://example.invalid/x"}}]' ;;
  denied-foreign)
    printf 'stray\n' >"$REPO/src-stray.txt"
    emit_json '[{"tool_name":"Bash","tool_use_id":"toolu_probe4","tool_input":{"command":"git push"}}]' ;;
  allowed-partial)
    printf 'partial\n' >"$REPO/logs/work-loop/partial-note.md"
    emit_json '[]'
    exit 3 ;;
  dirty-noop)
    emit_json '[]' ;;
  nested-actor)
    # Non-interactive bash has job control off, so these inherit THIS actor's
    # process group — which is the launcher's observation boundary. They outlive
    # the actor deliberately: the census samples during the hop, not after it.
    "$NESTDIR/claude" 6 &
    "$NESTDIR/codex" 6 &
    sleep 3
    sed -i '' "s/^turn: .*/turn: codex/" "$STATE"
    printf '\nactor ran beside nested processes %s\n' "$stamp" >>"$STATE"
    git -C "$REPO" add -- "$STATE_REL" >/dev/null 2>&1
    git -C "$REPO" commit -q -m "actor: handed on" >/dev/null 2>&1
    emit_json '[]' ;;
  become-claude)
    # Transition first, then REPLACE this process with one whose executable is
    # named `claude`. exec keeps the pid and the process group, so the top-level
    # actor itself now matches the census's recognition rule — which is the only
    # way to exercise the self-exclusion. Naming the fake actor script `claude`
    # does NOT do it: a `#!/bin/bash` script reports its interpreter as comm, so
    # such a fixture passes whether the exclusion exists or not.
    sed -i '' "s/^turn: .*/turn: codex/" "$STATE"
    printf '\nactor became claude %s\n' "$stamp" >>"$STATE"
    git -C "$REPO" add -- "$STATE_REL" >/dev/null 2>&1
    git -C "$REPO" commit -q -m "actor: handed on" >/dev/null 2>&1
    emit_json '[]'
    exec "$NESTDIR/claude" 3 ;;
  nested-nocommit)
    # The same observation, on a hop that must not run git. Codex never commits
    # (core § 4), so the committing variant above would be classified as the
    # protocol violation it is and never reach the observation assertions.
    "$NESTDIR/claude" 6 &
    "$NESTDIR/codex" 6 &
    sleep 3
    sed -i '' "s/^turn: .*/turn: claude/" "$STATE"
    printf '\ncodex ran beside nested processes %s\n' "$stamp" >>"$STATE" ;;
esac
exit 0
FAKE
  sed -i '' -e "s|__ARGV__|$2|" -e "s|__COUNT__|$3|" -e "s|__ACTION__|$4|" -e "s|__STATE__|$5|" \
            -e "s|__NESTDIR__|$NESTDIR|" "$1"
  chmod +x "$1"
}

# Write one well-formed state file into an existing checkout. Split out of mkfix
# so a fixture can carry a SECOND task in the SAME checkout — which is what the
# checkout-wide lock has to be tested against.
# Writes a record that satisfies the contract work-loop-state.sh enforces:
# explicit `status`, one of the four legal status/turn pairs, and that pair's body
# shape. Before the Tracer 3 cutover this wrote a status-free record with the OPEN
# body for every turn — including `operator`, which is now either a closed record
# (four closing headings) or a blocked one (five headings and a real blocker).
# Status is derived from the turn unless the caller states it.
mkstate_in() { # checkout, task-id, turn, [status]
  local co="$1" task="$2" turn="$3" status="${4:-}" blocker
  mkdir -p "$co/logs/work-loop"
  if [ -z "$status" ]; then
    case "$turn" in
      codex|claude) status=active ;;
      operator)     status=closed ;;
    esac
  fi

  if [ "$status" = closed ]; then
    {
      printf -- '---\ntask: %s\nstatus: closed\nturn: operator\n---\n\n' "$task"
      printf '## Outcome\nA fixture, closed.\n\n## Decisions that matter\nNothing real.\n\n## Evidence\nA fixture — no commit.\n\n## Accepted limitations\nNone.\n'
    } >"$co/logs/work-loop/$task.md"
    return 0
  fi

  blocker='None.'
  [ "$status" = blocked ] && blocker='Waiting on the operator to decide the fixture question.'
  {
    printf -- '---\ntask: %s\nstatus: %s\nturn: %s\n---\n\n' "$task" "$status" "$turn"
    printf '## Objective and scope\nA fixture.\n\n## Lane and unit\nStandard. Implementation mode. Unit 1 — fixture.\n\n## Latest result\nNothing yet.\n\n## Blocker\n%s\n\n## Next action\nDo the thing.\n' "$blocker"
  } >"$co/logs/work-loop/$task.md"
}

# The LEGACY lock path for a checkout: the CANONICAL checkout path under
# ${TMPDIR}, and nothing else. This is where the launcher kept its single lock
# before the shared lease, and it still READS it for one release so that a carry
# already in flight when the change landed is not invisible to the new code. If
# this and the launcher ever disagree, every lock assertion silently passes
# against a directory the launcher never looks at — which is exactly what
# happened once before, when this hashed the raw fixture path while the launcher
# hashed the /private/var canonicalization of it.
lock_path_for() { # checkout -> legacy lock dir path
  local rp key
  rp="$(cd "$1" && pwd -P)"
  key="$(printf '%s' "$rp" | shasum -a 256 | cut -c1-16)"
  printf '%s\n' "${TMPDIR:-/tmp}/axcion-harness-v0.2.$key.lock"
}

plant_lock() { # legacy lock-dir, pid, task-id
  rm -rf "$1"; mkdir -p "$1"
  printf '%s\n' "$2" >"$1/pid"
  printf '%s\n' "$3" >"$1/task"
}

# Plant a legacy lock whose pid file holds EXACTLY the given text, including text
# that is not a pid at all. plant_lock takes a real pid and is the right helper
# for the live and the provably-dead cases; this one is for the corruptions,
# because the whole question this section asks is what the launcher concludes
# from a pid it cannot turn into a verdict.
#
# The literal NONE means NO pid file at all, which is a DIFFERENT corruption from
# a pid file that exists and is empty: one is a lock written by something that
# never got as far as recording itself, the other is a lock whose record was
# truncated. They must reach the same refusal, and asserting that separately is
# the only way to know they do.
plant_lock_raw() { # legacy lock-dir, raw-pid-text | NONE, task-id
  rm -rf "$1"; mkdir -p "$1"
  [ "$2" = NONE ] || printf '%s\n' "$2" >"$1/pid"
  printf '%s\n' "$3" >"$1/task"
}

# The SHARED lease locations, mirrored from logs/scripts/work-loop-lease.sh. They
# are rooted in the repository's Git common directory rather than in ${TMPDIR},
# which is what makes them visible to every linked worktree of one repository and
# to the other transport. Two resources, not one composite key: a task lease and
# a checkout lease. Defined once here, above every user, for the same reason the
# dispatcher's suite defines its own once — a second copy is a place this change
# could be missed.
lease_root_for() { # checkout -> lease root dir
  local c g
  c="$(cd "$1" && pwd -P)"
  g="$(git -C "$c" rev-parse --git-common-dir 2>/dev/null)"
  case "$g" in /*) ;; *) g="$c/$g" ;; esac
  printf '%s/work-loop-dispatch-locks' "$(cd "$g" && pwd -P)"
}

task_lease_for() { # checkout, task -> task lease dir
  printf '%s/task-%s.lock' "$(lease_root_for "$1")" \
    "$(printf '%s' "$2" | shasum -a 256 | cut -c1-16)"
}

checkout_lease_for() { # checkout -> checkout lease dir
  local c; c="$(cd "$1" && pwd -P)"
  printf '%s/checkout-%s.lock' "$(lease_root_for "$1")" \
    "$(printf '%s' "$c" | shasum -a 256 | cut -c1-16)"
}

# A lease as a live holder leaves it: the four metadata files the library writes,
# including the program name a refusal renders.
plant_lease() { # lease-dir, pid, task-id, checkout, program
  rm -rf "$1"; mkdir -p "$1"
  printf '%s\n' "$2" >"$1/pid"
  printf '%s\n' "$3" >"$1/task"
  printf '%s\n' "$4" >"$1/checkout"
  printf '%s\n' "$5" >"$1/program"
}

# Package the ownership helper into an existing fixture, TRACKED and committed.
# Tracked for the same reason mkfix tracks the lease library: `logs/scripts/` is
# outside the launcher's default allow-path set, so an untracked helper is an
# out-of-allowlist working-tree change and the launcher would correctly stop at
# exit 18 before it ever reached ownership admission — the case would then pass
# or fail for a reason that has nothing to do with ownership.
add_owner_helper() { # checkout
  mkdir -p "$1/logs/scripts"
  cp "$OWNER_BIN" "$1/logs/scripts/work-loop-owner.sh" 2>/dev/null || return 1
  git -C "$1" add -- logs/scripts/work-loop-owner.sh >/dev/null 2>&1
  git -C "$1" commit -q -m "package the ownership helper" >/dev/null 2>&1
}

# Build a fixture. Sets: REPO STATE ACTION ARGVLOG COUNTF FAKEBIN LOGD
mkfix() { # name, task-id, turn, [status]
  local name="$1" task="$2" turn="$3" status="${4:-}"
  REPO="$TMPROOT/$name"
  mkdir -p "$REPO/logs/work-loop"
  git -C "$REPO" init -q 2>/dev/null
  git -C "$REPO" config user.email t@example.com
  git -C "$REPO" config user.name Test
  git -C "$REPO" config commit.gpgsign false
  STATE="$REPO/logs/work-loop/$task.md"
  mkstate_in "$REPO" "$task" "$turn" "$status"
  # Tracked, not dropped in loose: an untracked helper is an out-of-allowlist
  # working-tree change and the launcher would correctly stop on it (exit 18).
  #
  # BOTH helpers, because the launcher now runs BOTH checks on every carry: the
  # shared lease, then repository-depth ownership admission. A fixture carrying
  # only the lease library would reach ownership with no helper and stop at 35,
  # so every ordinary case in this suite would be testing the fail-closed path
  # instead of the behaviour it names. The cases that need one of them ABSENT
  # remove it explicitly (12c for the lease library, 12e for the owner helper),
  # which is also the only way an absence stays visible in the case that asserts
  # it rather than being an accident of what mkfix happens not to copy.
  mkdir -p "$REPO/logs/scripts"
  cp "$LEASE_BIN" "$REPO/logs/scripts/work-loop-lease.sh" 2>/dev/null || true
  cp "$OWNER_BIN" "$REPO/logs/scripts/work-loop-owner.sh" 2>/dev/null || true
  cp "$STATE_BIN" "$REPO/logs/scripts/work-loop-state.sh" 2>/dev/null || true
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

CODEX_DEFAULT_BIN="$(awk -F'"' '/^CODEX_BIN=/{print $2; exit}' "$SUT")"

# Normalized execpolicy probe. Whole-output equality against raw JSON is brittle:
# any warning line, or a probe that failed outright, changes the string without
# saying why — and an empty result must never read as a clean no-match.
#
# Prints exactly one of:
#   decision=<d> matches=<n>     a parsed result
#   PROBE-FAILED:<reason>        non-zero exit, or output that is not a result
# stderr is captured separately, never merged and never discarded.
xp() { # rules-file, command tokens...
  local rf="$1"; shift
  local out rc err="$TMPROOT/xp.err" n d
  : >"$err"
  out="$("$CODEX_DEFAULT_BIN" execpolicy check --rules "$rf" "$@" 2>"$err")"; rc=$?
  if [ "$rc" -ne 0 ]; then
    printf 'PROBE-FAILED:exit=%s:%s\n' "$rc" "$(tr '\n' ' ' <"$err" | cut -c1-100)"
    return
  fi
  case "$out" in
    *'"matchedRules"'*) ;;
    *) printf 'PROBE-FAILED:malformed:%s\n' "$(printf '%s' "$out" | tr '\n' ' ' | cut -c1-100)"
       return ;;
  esac
  n="$(printf '%s' "$out" | grep -o '"prefixRuleMatch"' | wc -l | tr -d ' ')"
  d="$(printf '%s' "$out" | grep -o '"decision":"[a-z]*"' | tail -1 | sed 's/.*:"//;s/"//')"
  [ -n "$d" ] || d=none
  printf 'decision=%s matches=%s\n' "$d" "$n"
}

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
  # The wording is the validator's now, but the invariant is unchanged: the
  # refusal must name BOTH the id asked for and the id the record carries, or the
  # operator cannot tell which of the two is wrong.
  assert_contains "  names both sides" "frontmatter task: says 'task-b'" "$o"
  assert_contains "  names the asked-for id too" "task-c" "$o"
  printf 'no frontmatter here\n' >"$REPO/logs/work-loop/task-d.md"
  run_sut --checkout "$REPO" --task task-d --log-dir "$LOGD"
  # DELIBERATE EXIT CHANGE AT THE CUTOVER, 14 -> 15. A file with no frontmatter
  # has no identity to mismatch, so calling it an identity fault said something
  # untrue about it. 15 is this surface's "the state file cannot be used", which
  # is exactly what it is. The behaviour that matters is unchanged: it stops, and
  # it launches nothing.
  assert_eq "absent frontmatter rejected" "15" "$RC"
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
  assert_contains "deny path passes the deny rule through" "Bash(git push:*)" "$argv"
  assert_absent "deny path has no permission bypass" "--dangerously-skip-permissions" "$argv"

section "5b. Mandatory nested-actor deny set (real argv, fake binary)"
  # One attended hop must stay one attended hop. The rules below are REQUESTED of
  # the Claude child on every launch; what this section proves is the argv, not
  # the child's enforcement of it — see the launcher's NESTED ACTORS block.
  #
  # Assertions read the per-argument log, not "$*". Bracketed one-per-line is the
  # only shape that can tell a rule passed as its own argument from two rules
  # accidentally collapsed into one string.

  # (a) No --claude-deny at all. This is the shape that used to carry no
  # --disallowedTools whatsoever, and it is the release blocker this unit closes.
  mkfix nested task-an claude
  printf 'transition:codex' >"$ACTION"
  run_sut --checkout "$REPO" --task task-an --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "plain attended launch still carries the turn" "0" "$RC"
  args="$(cat "$ARGVLOG.args")"
  assert_contains "plain launch requests --disallowedTools at all" "[--disallowedTools]" "$args"
  # BOTH forms per actor. Which one an installed build honours is not
  # established, so asserting only the colon form would prove a string reached
  # argv rather than that the direct route is denied.
  assert_contains "  denies direct Bash launch of claude (colon form)" "[Bash(claude:*)]" "$args"
  assert_contains "  denies direct Bash launch of claude (space form)" "[Bash(claude *)]" "$args"
  assert_contains "  denies direct Bash launch of codex (colon form)" "[Bash(codex:*)]" "$args"
  assert_contains "  denies direct Bash launch of codex (space form)" "[Bash(codex *)]" "$args"
  assert_contains "  and keeps --permission-mode default" "--permission-mode default" "$(cat "$ARGVLOG")"

  # (b) With operator rules. The mandatory set must survive verbatim and the
  # operator's rules must ADD to it — displacement is the failure mode.
  mkfix nesteddeny task-ao claude
  printf 'transition:codex' >"$ACTION"
  run_sut --checkout "$REPO" --task task-ao --claude-bin "$FAKEBIN" \
          --claude-deny 'Bash(git push:*)' --claude-deny 'WebFetch' --log-dir "$LOGD"
  assert_eq "operator-deny launch carries the turn" "0" "$RC"
  args="$(cat "$ARGVLOG.args")"
  assert_contains "operator rules do not displace the claude colon rule" "[Bash(claude:*)]" "$args"
  assert_contains "operator rules do not displace the claude space rule" "[Bash(claude *)]" "$args"
  assert_contains "operator rules do not displace the codex colon rule" "[Bash(codex:*)]" "$args"
  assert_contains "operator rules do not displace the codex space rule" "[Bash(codex *)]" "$args"
  assert_contains "  operator rule 1 appended verbatim" "[Bash(git push:*)]" "$args"
  assert_contains "  operator rule 2 appended verbatim" "[WebFetch]" "$args"
  assert_eq "  exactly one --disallowedTools flag, one list" "1" \
    "$(grep -cFx -- '[--disallowedTools]' "$ARGVLOG.args" | tr -d ' ')"
  # Mandatory first, operator after: the flag, then all four mandatory rules,
  # then the operator's. Order is what makes "appended" a checkable word, and
  # the exact string is what catches a mandatory rule quietly going missing.
  assert_eq "  mandatory rules precede the operator's" \
    "[--disallowedTools] [Bash(claude:*)] [Bash(claude *)] [Bash(codex:*)] [Bash(codex *)] [Bash(git push:*)] [WebFetch]" \
    "$(grep -A6 -Fx -- '[--disallowedTools]' "$ARGVLOG.args" | tr '\n' ' ' | sed 's/ *$//')"
  assert_absent "  and still no permission bypass" "--dangerously-skip-permissions" "$args"

  # (c) There must be no way to ask for the set to be dropped. A flag that turned
  # it off would make every assertion above conditional on operator goodwill.
  assert_absent "no flag disables the mandatory set" "--allow-nested" "$(cat "$SUT")"
  assert_absent "no flag replaces the mandatory set" "--claude-deny-replace" "$(cat "$SUT")"
  assert_absent "the mandatory set is not built from operator input" \
    'CLAUDE_DENY_MANDATORY=("${CLAUDE_DENY' "$(cat "$SUT")"

  # (d) Operator-visible honesty. The help block must describe requested policy,
  # and must not sell it as containment.
  run_sut --help
  assert_eq "--help exits 0" "0" "$RC"
  assert_contains "help states the mandatory claude rule (colon form)" "Bash(claude:*)" "$o"
  assert_contains "help states the mandatory claude rule (space form)" "Bash(claude *)" "$o"
  assert_contains "help states the mandatory codex rule (colon form)" "Bash(codex:*)" "$o"
  assert_contains "help states the mandatory codex rule (space form)" "Bash(codex *)" "$o"
  assert_contains "help says why both forms are listed" "which one an installed build honours" "$o"
  assert_contains "help says operator rules append" "APPENDED" "$o"
  # Needle deliberately includes --claude-deny: the help block already said "no
  # flag to turn it off" about --permission-mode, so the short phrase passed
  # against the pre-change launcher and proved nothing about this policy.
  assert_contains "help says there is no way to turn it off" \
    "with or without --claude-deny, there is no flag to turn it off" "$o"
  assert_contains "help calls it requested permission rules" "REQUESTED PERMISSION RULES" "$o"
  assert_contains "help refuses the containment claim" "not OS" "$o"
  assert_contains "help refuses the impossibility claim" "NOT proof that nesting is" "$o"
  assert_contains "help says the Codex path requests refusal by another mechanism" \
    "REQUESTS direct-route refusal by a different mechanism" "$o"
  assert_contains "help states the only decision pair execpolicy parses" \
    "parses only \`allow\` and \`prompt\`" "$o"
  assert_contains "help names the documented rules-loading opt-out" \
    "(\`--ignore-rules\` is the documented opt-out)" "$o"
  assert_contains "help keeps the wrapper routes unmatched" \
    "are UNMATCHED" "$o"
  # The Codex paragraph must claim no more than the Claude one. These three
  # needles are the exact overclaims the risk review froze.
  assert_absent "help claims no route-blocking for the Codex path" "no route to approval" "$o"
  assert_absent "help claims no prevention for the Codex path" "prevents nesting" "$o"
  assert_absent "help claims no observed loading" "rules file was loaded" "$o"

  # (e) The run output an operator actually reads must say the same thing.
  mkfix nestedsay task-ap claude
  printf 'transition:codex' >"$ACTION"
  run_sut --checkout "$REPO" --task task-ap --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_contains "run output names the policy" "nested-actor policy" "$o"
  assert_contains "  lists all four mandatory rules" \
    "requesting Bash(claude:*) Bash(claude *) Bash(codex:*) Bash(codex *) on every Claude hop" "$o"
  assert_contains "  says it is mandatory with no override" "mandatory, no override" "$o"
  assert_contains "  says operator rules append" "--claude-deny appends" "$o"
  assert_contains "  and does not sell it as containment" "not containment and not proof" "$o"

  # (f) A Codex hop requests refusal by its own mechanism. The deny-set absences
  # below STAY: T7 adds an approval policy, not a --disallowedTools list, so a
  # deny set on the Codex argv would still be a claim the launcher cannot
  # support. What is new is the positive leg, and the paired negative in (g) is
  # what makes it able to fail.
  mkfix nestedcdx task-aq codex
  printf 'nocommit:claude' >"$ACTION"
  run_sut --checkout "$REPO" --task task-aq --codex-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "codex hop still carries" "0" "$RC"
  assert_absent "codex argv carries no deny set" "--disallowedTools" "$(cat "$ARGVLOG")"
  assert_absent "codex argv carries no claude colon rule" "Bash(claude:*)" "$(cat "$ARGVLOG")"
  assert_absent "codex argv carries no claude space rule" "Bash(claude *)" "$(cat "$ARGVLOG")"
  cargs="$(cat "$ARGVLOG.args")"
  assert_contains "codex argv requests an approval policy at all" "[-c]" "$cargs"
  assert_eq "  exactly one -c flag" "1" \
    "$(grep -cFx -- '[-c]' "$ARGVLOG.args" | tr -d ' ')"
  # ADJACENCY, not mere presence. `-c` and its value must be consecutive
  # arguments; separated, codex reads them as unrelated tokens and the override
  # silently does nothing. Asserting each alone would pass on exactly that bug.
  assert_eq "  -c is immediately followed by approval_policy=never" \
    "[-c] [approval_policy=never]" \
    "$(grep -A1 -Fx -- '[-c]' "$ARGVLOG.args" | tr '\n' ' ' | sed 's/ *$//')"
  assert_contains "  the sandbox request is still made" "[--sandbox]" "$cargs"
  assert_contains "  with its existing value" "[workspace-write]" "$cargs"
  # The launcher must not opt out of the very rules file this policy needs.
  assert_absent "  and the hop does not opt out of rules loading" "--ignore-rules" "$cargs"
  assert_contains "run output refuses the containment claim on the Codex path" \
    "not containment and NOT proof" "$o"
  assert_contains "run output keeps the unverified premises visible" \
    "Unverified, and not claimed" "$o"

  # (g) PAIRED NEGATIVE, same launcher, other actor. If approval_policy leaked
  # onto the Claude hop this fails; if it were absent from BOTH paths, (f) fails.
  # The pair is what stops either assertion from being unfalsifiable.
  mkfix nestedcdxneg task-ar claude
  printf 'transition:codex' >"$ACTION"
  run_sut --checkout "$REPO" --task task-ar --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "claude hop still carries" "0" "$RC"
  assert_absent "claude argv carries no approval policy" \
    "approval_policy=never" "$(cat "$ARGVLOG.args")"
  assert_absent "claude argv carries no -c override" "[-c]" "$(cat "$ARGVLOG.args")"
  # The Claude branch is byte-identical under T7: its four mandatory rules must
  # still arrive exactly as section (a) proved them.
  nargs="$(cat "$ARGVLOG.args")"
  assert_contains "  claude mandatory rule 1 intact" "[Bash(claude:*)]" "$nargs"
  assert_contains "  claude mandatory rule 2 intact" "[Bash(claude *)]" "$nargs"
  assert_contains "  claude mandatory rule 3 intact" "[Bash(codex:*)]" "$nargs"
  assert_contains "  claude mandatory rule 4 intact" "[Bash(codex *)]" "$nargs"

  # (h) The external policy this request depends on, bound to the ACTUAL
  # machine-wide file T7 installs — NOT a scratch duplicate, which would only
  # prove that execpolicy works on some file somewhere.
  #
  # The leg is mandatory exactly when the launcher requests the policy. Before
  # T7 lands, the launcher carries no approval_policy flag and the file is not
  # installed, so this skips. After T7 it is required, and an absent, symlinked,
  # non-regular, hash-mismatched or malformed file FAILS here.
  T7_RULES="$HOME/.codex/rules/axcion-nested-actor.rules"
  T7_RULES_SHA="b0f8b79c3ef137ac5db07bd7f8195235c086ec2542b29a40092fa4a4a5b9f303"
  if ! grep -qF -- 'approval_policy=never' "$SUT"; then
    printf '  SKIP external-policy leg: launcher does not request approval_policy yet (pre-T7)\n'
  elif [ ! -x "$CODEX_DEFAULT_BIN" ]; then
    printf '  SKIP external-policy leg: %s is not present on this host\n' "$CODEX_DEFAULT_BIN"
  else
    # Identity of the installed file, checked before it is trusted as evidence.
    assert_eq "installed policy file exists" "yes" \
      "$([ -e "$T7_RULES" ] && echo yes || echo no)"
    assert_eq "  and is not a symlink" "no" \
      "$([ -L "$T7_RULES" ] && echo yes || echo no)"
    assert_eq "  and is a regular file" "yes" \
      "$([ -f "$T7_RULES" ] && [ ! -L "$T7_RULES" ] && echo yes || echo no)"
    assert_eq "  and carries the reviewed identity" "$T7_RULES_SHA" \
      "$(shasum -a 256 "$T7_RULES" 2>/dev/null | cut -d' ' -f1)"
    # Positives, against that same installed file.
    assert_eq "installed policy marks a direct claude command prompt" \
      "decision=prompt matches=1" "$(xp "$T7_RULES" claude -p x)"
    assert_eq "installed policy marks a direct codex command prompt" \
      "decision=prompt matches=1" "$(xp "$T7_RULES" codex exec x)"
    # Rule-absent control. An EMPTY policy, not a copy of the installed one —
    # it is the absence the positives above are measured against.
    : >"$TMPROOT/t7-absent.rules"
    assert_eq "  claude matches nothing with the rule absent" \
      "decision=none matches=0" "$(xp "$TMPROOT/t7-absent.rules" claude -p x)"
    assert_eq "  codex matches nothing with the rule absent" \
      "decision=none matches=0" "$(xp "$TMPROOT/t7-absent.rules" codex exec x)"
    # Accepted limitations, EVIDENCED against the installed file.
    assert_eq "  bash -lc wrapper unmatched (accepted limitation)" \
      "decision=none matches=0" "$(xp "$T7_RULES" bash -lc 'claude -p x')"
    assert_eq "  env wrapper unmatched (accepted limitation)" \
      "decision=none matches=0" "$(xp "$T7_RULES" env claude -p x)"
    assert_eq "  absolute path unmatched without --resolve-host-executables" \
      "decision=none matches=0" "$(xp "$T7_RULES" /usr/local/bin/claude -p x)"
    # `deny` is not a decision execpolicy has. If this ever parses, the whole
    # "prompt is the only available shape" rationale needs rewriting.
    printf 'prefix_rule(pattern=["zzz"], decision="deny")\n' >"$TMPROOT/t7-deny.rules"
    assert_contains "  execpolicy still refuses a deny decision" "PROBE-FAILED" \
      "$(xp "$TMPROOT/t7-deny.rules" zzz)"
  fi

section "5c. Per-run attended permission mode (real argv, fake binary)"
  # The ONE authorised widening, and the boundary around it. What is proved here
  # is the argv the launcher assembles and the words an operator reads — not that
  # the child honours acceptEdits, which no fake binary can show and which this
  # unit deliberately does not claim.

  # (a) Omitted input. The accepted Unit 1 behaviour, unchanged: the mode is
  # stated explicitly and it is `default`.
  mkfix pmdefault task-ar claude
  printf 'transition:codex' >"$ACTION"
  run_sut --checkout "$REPO" --task task-ar --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "omitted permission mode still carries the turn" "0" "$RC"
  args="$(cat "$ARGVLOG.args")"
  assert_eq "  omitted input launches with exactly one --permission-mode" "1" \
    "$(grep -cFx -- '[--permission-mode]' "$ARGVLOG.args" | tr -d ' ')"
  assert_eq "  and its value is default" "[--permission-mode] [default]" \
    "$(grep -A1 -Fx -- '[--permission-mode]' "$ARGVLOG.args" | tr '\n' ' ' | sed 's/ *$//')"
  assert_absent "  and no bypass reached argv" "--dangerously-skip-permissions" "$args"

  # (b) Explicit default. Same argv as omitting it — the option is a request, not
  # a second code path.
  mkfix pmexplicit task-as claude
  printf 'transition:codex' >"$ACTION"
  run_sut --checkout "$REPO" --task task-as --claude-bin "$FAKEBIN" \
          --claude-permission-mode default --log-dir "$LOGD"
  assert_eq "explicit default carries the turn" "0" "$RC"
  assert_eq "  and launches with exactly --permission-mode default" "[--permission-mode] [default]" \
    "$(grep -A1 -Fx -- '[--permission-mode]' "$ARGVLOG.args" | tr '\n' ' ' | sed 's/ *$//')"

  # (c) The widening itself, and what it must NOT disturb. A widened hop carries
  # the same mandatory nested-actor rules and the same operator rules as any
  # other; the mode is the only thing that changed.
  mkfix pmaccept task-at claude
  printf 'transition:codex' >"$ACTION"
  run_sut --checkout "$REPO" --task task-at --claude-bin "$FAKEBIN" \
          --claude-permission-mode acceptEdits --claude-deny 'Bash(git push:*)' --log-dir "$LOGD"
  assert_eq "acceptEdits carries the turn" "0" "$RC"
  args="$(cat "$ARGVLOG.args")"
  assert_eq "  launches with exactly --permission-mode acceptEdits" "[--permission-mode] [acceptEdits]" \
    "$(grep -A1 -Fx -- '[--permission-mode]' "$ARGVLOG.args" | tr '\n' ' ' | sed 's/ *$//')"
  assert_eq "  and only one --permission-mode reaches argv" "1" \
    "$(grep -cFx -- '[--permission-mode]' "$ARGVLOG.args" | tr -d ' ')"
  assert_absent "  and default is not also passed" "[default]" "$args"
  assert_absent "  and no bypass reached argv" "--dangerously-skip-permissions" "$args"
  assert_contains "  mandatory claude colon rule survives the widening" "[Bash(claude:*)]" "$args"
  assert_contains "  mandatory claude space rule survives the widening" "[Bash(claude *)]" "$args"
  assert_contains "  mandatory codex colon rule survives the widening" "[Bash(codex:*)]" "$args"
  assert_contains "  mandatory codex space rule survives the widening" "[Bash(codex *)]" "$args"
  assert_contains "  operator deny rule survives the widening" "[Bash(git push:*)]" "$args"

  # (d) Everything else fails closed, BEFORE the lock, the run log and the actor.
  # An unauthorised mode that merely failed later would already have taken the
  # checkout's lock and written a run log for a hop that must not exist.
  mkfix pmbad task-au claude
  printf 'transition:codex' >"$ACTION"
  for v in bypassPermissions BypassPermissions bypass auto manual dontAsk plan \
           Default DEFAULT AcceptEdits ACCEPTEDITS accept-edits '' ; do
    run_sut --checkout "$REPO" --task task-au --claude-bin "$FAKEBIN" --log-dir "$LOGD" \
            --claude-permission-mode "$v"
    if [ "$RC" -eq 10 ] && printf '%s' "$o" | grep -q 'RESULT outcome=STOPPED code=10'; then
      ok "unauthorised mode '${v:-<empty>}' is BAD_USAGE (10)"
    else
      bad "unauthorised mode '${v:-<empty>}'" "exit=$RC out=$(printf '%s' "$o" | head -c 160)"
    fi
  done
  assert_eq "  no unauthorised mode launched anything" "0" "$(invocations)"
  # The bypass family gets its own message, because it is the value an operator
  # is likeliest to reach for and a generic "not authorised" would not say why.
  run_sut --checkout "$REPO" --task task-au --claude-bin "$FAKEBIN" --log-dir "$LOGD" \
          --claude-permission-mode bypassPermissions
  assert_contains "bypass is refused in its own words" "never launches an actor with bypass authority" "$o"
  # A flag with no value at all must refuse, not spin. `shift 2` with one
  # argument left shifts nothing, so an unguarded option loops forever here.
  run_sut --checkout "$REPO" --task task-au --claude-bin "$FAKEBIN" --log-dir "$LOGD" \
          --claude-permission-mode
  assert_eq "a value-less flag is BAD_USAGE, not a spin" "10" "$RC"
  assert_contains "  and says what it needs" "requires a value" "$o"
  # The raw CLI flag stays refused. It is ambiguous about who it aims at, and the
  # authorised route is the named one.
  run_sut --checkout "$REPO" --task task-au --claude-bin "$FAKEBIN" --log-dir "$LOGD" \
          --permission-mode acceptEdits
  assert_eq "the raw --permission-mode flag is still refused" "10" "$RC"
  assert_contains "  and points at the authorised option" "--claude-permission-mode acceptEdits" "$o"

  # (e) Operator-visible help. It must describe a per-invocation widening and
  # must not sell the allow-path set as something that prevents a write.
  run_sut --help
  assert_eq "--help still exits 0" "0" "$RC"
  assert_contains "help names the option" "--claude-permission-mode" "$o"
  assert_contains "help names both authorised values" "default" "$o"
  assert_contains "help names the widening value" "acceptEdits" "$o"
  assert_contains "help says the widening is opt-in for one invocation" \
    "it lasts exactly this invocation" "$o"
  assert_contains "help says it is not remembered" "stored nowhere and remembered nowhere" "$o"
  assert_contains "help refuses the bypass reading" "It is NOT bypass" "$o"
  assert_contains "help says the allow-path set detects rather than prevents" \
    "DETECTION, NOT PREVENTION" "$o"
  assert_contains "help says the child never reads the allow-path set" \
    "the child never reads it" "$o"
  assert_contains "help still refuses the containment claim" "not containment" "$o"
  assert_contains "help says every other mode fails closed" "EVERYTHING ELSE FAILS CLOSED" "$o"
  assert_contains "help says the widening leaves the deny set alone" \
    "does not touch it either" "$o"

  # (f) The run output an operator actually reads, on the widened hop.
  mkfix pmsay task-av claude
  printf 'transition:codex' >"$ACTION"
  run_sut --checkout "$REPO" --task task-av --claude-bin "$FAKEBIN" \
          --claude-permission-mode acceptEdits --allow-path '^logs/work-loop/' --log-dir "$LOGD"
  assert_eq "the widened hop carries" "0" "$RC"
  assert_contains "run output names the widening as operator-approved" \
    "OPERATOR-APPROVED WIDENING requested for THIS invocation only" "$o"
  assert_contains "  says it is not stored" "stored nowhere" "$o"
  assert_contains "  refuses the bypass reading" "It is not bypass" "$o"
  assert_contains "  names the effective allow-path set" \
    "effective allow-path set: ^logs/work-loop/" "$o"
  assert_contains "  says that set detects rather than prevents" "DETECTION, not prevention" "$o"
  assert_contains "  says an outside edit happens first and is reported after" \
    "happens first and is reported afterwards" "$o"
  assert_contains "  and keeps the nested-actor honesty" "not containment and not proof" "$o"
  assert_contains "  and the launch line shows the mode it used" \
    "--permission-mode acceptEdits" "$o"

  # (g) The default hop says so too, so silence is never how an operator learns
  # which mode ran.
  mkfix pmsaydef task-aw claude
  printf 'transition:codex' >"$ACTION"
  run_sut --checkout "$REPO" --task task-aw --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_contains "the default hop states its mode" "permission mode: default — the child asks" "$o"
  assert_contains "  and says no widening was requested" "No widening was requested" "$o"
  assert_absent "  and claims no widening it did not get" "OPERATOR-APPROVED WIDENING" "$o"

  # (h) Claude only. A permission mode on the Codex argv would be a claim this
  # launcher cannot support — `codex exec` takes no such option here.
  mkfix pmcdx task-ax codex
  printf 'nocommit:claude' >"$ACTION"
  run_sut --checkout "$REPO" --task task-ax --codex-bin "$FAKEBIN" \
          --claude-permission-mode acceptEdits --log-dir "$LOGD"
  assert_eq "a Codex hop is unaffected by the widening" "0" "$RC"
  assert_absent "  codex argv carries no permission mode" "--permission-mode" "$(cat "$ARGVLOG")"
  assert_absent "  codex argv carries no acceptEdits" "acceptEdits" "$(cat "$ARGVLOG")"
  assert_absent "  and no widening was announced for it" "OPERATOR-APPROVED WIDENING" "$o"

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
  mkfix opq task-j operator blocked
  run_sut --checkout "$REPO" --task task-j --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "operator turn stops at 0" "0" "$RC"
  assert_contains "  reports OPERATOR_TERMINAL, not CARRIED" "RESULT outcome=OPERATOR_TERMINAL code=0" "$o"
  assert_contains "  surfaces the unanswered question" "UNANSWERED" "$o"
  assert_eq "  nothing was launched" "0" "$(invocations)"

  mkfix opclosed task-k operator
  { printf -- '---\ntask: task-k\nstatus: closed\nturn: operator\n---\n\n'
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
  printf -- '---\ntask: task-l\nstatus: closed\nturn: operator\n---\n\n## Something Else\nhalf-written.\n' >"$STATE"
  git -C "$REPO" commit -qam "half-written" >/dev/null 2>&1
  run_sut --checkout "$REPO" --task task-l --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  # Exit 26 survives the cutover. It used to mean "this surface looked at the body
  # and it was neither a question nor a closing record"; it now means "the
  # validator rejected the body", which is the same fact established by the one
  # authority instead of by a private heading comparison.
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
  ld="$(lock_path_for "$REPO")"
  plant_lock "$ld" "$$" task-y                          # this shell is alive
  run_sut --checkout "$REPO" --task task-y --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "a live lock holder blocks the carry (17)" "17" "$RC"
  assert_eq "  and nothing launched" "0" "$(invocations)"
  assert_eq "  and the lock survives" "1" "$([ -d "$ld" ] && echo 1 || echo 0)"
  assert_contains "  and names the holding task" "task 'task-y'" "$o"

  ( exit 0 ) & deadpid=$!; wait "$deadpid" 2>/dev/null   # a pid that is now gone
  plant_lock "$ld" "$deadpid" task-y
  printf 'transition:codex' >"$ACTION"
  run_sut --checkout "$REPO" --task task-y --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "a provably stale lock is cleared and the carry runs" "0" "$RC"
  assert_contains "  and says so" "removing a stale lock" "$o"

  # No pid at all: not inspectable, so not provably stale. It must be kept, and
  # the launcher must not advise deleting anything it cannot show is dead.
  rm -rf "$ld"; mkdir -p "$ld"; : >"$ld/pid"; printf 'task-y\n' >"$ld/task"
  # The count is cumulative and the stale-lock case above legitimately launched
  # once, so the claim here is "no FURTHER launch", not "never launched".
  n_before="$(invocations)"
  run_sut --checkout "$REPO" --task task-y --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "an uninspectable lock is treated as held (17)" "17" "$RC"
  assert_eq "  and is NOT deleted" "1" "$([ -d "$ld" ] && echo 1 || echo 0)"
  assert_contains "  and says nothing was deleted" "Nothing was deleted" "$o"
  assert_eq "  and launched nothing further" "$n_before" "$(invocations)"
  rm -rf "$ld"

section "12a. The legacy lock has THREE states, and only one of them is stale"
  # `kill -0` failing is not proof that a process is gone. It fails for two
  # different reasons — ESRCH, the pid really is absent, and EPERM, the pid may
  # well be ALIVE and this caller is simply not allowed to look at it — and the
  # one-release compatibility path used to conflate them. Conflated, an
  # uninspectable holder read as stale, so its lock was DELETED and this carry
  # was admitted alongside a live one, in the very changeover window the legacy
  # read exists to protect.
  #
  # So the five cases below are the whole state space of that pid file, and each
  # one names which of LIVE / UNKNOWN / ABSENT it is. The dead-pid case at the
  # end is the POSITIVE CONTROL: without it, a launcher that refused everything
  # unconditionally would pass every other assertion here.
  #
  # The verdict is the shared library's, not a second classifier: the launcher
  # sources logs/scripts/work-loop-lease.sh before this path runs, and the same
  # probe that admits a live lease is the one that reads this legacy pid.
  mkfix leg3 task-lg claude
  lgld="$(lock_path_for "$REPO")"

  # --- UNKNOWN (1): uninspectable. kill -0 fails with "operation not permitted"
  # rather than "no such process". pid 1 is init/launchd and root-owned, so an
  # ordinary user cannot signal it and cannot conclude anything about it either.
  # This is the case that costs two live writers in one working tree when it is
  # read as stale. Skipped when the suite runs as root, where pid 1 is genuinely
  # LIVE and the case would silently be testing a state it does not name.
  if kill -0 1 2>/dev/null; then
    printf '  SKIP an uninspectable (EPERM) holder — this shell can signal pid 1\n'
  else
    plant_lock_raw "$lgld" 1 task-lg-live
    n_before="$(invocations)"
    run_sut --checkout "$REPO" --task task-lg --claude-bin "$FAKEBIN" --log-dir "$LOGD"
    assert_eq "an UNINSPECTABLE holder (EPERM) is held, not cleared (17)" "17" "$RC"
    assert_eq "  and the lock survives" "1" "$([ -d "$lgld" ] && echo 1 || echo 0)"
    assert_eq "  and launched nothing" "$n_before" "$(invocations)"
    assert_contains "  and says nothing was deleted" "Nothing was deleted" "$o"
    assert_contains "  and says why inspection did not justify deletion" \
                    "WITHOUT proving absence" "$o"
    assert_absent "  and never calls an uninspectable holder stale" "removing a stale lock" "$o"
  fi

  # --- UNKNOWN (2): malformed, zero-prefixed. `007` reaches kill(2) as pid 7, so
  # a conflating launcher returns a true statement about an unrelated process
  # presented as a statement about this lock — and on this host pid 7 is
  # root-owned, so that statement is "not running", i.e. delete it.
  plant_lock_raw "$lgld" 007 task-lg-zero
  n_before="$(invocations)"
  run_sut --checkout "$REPO" --task task-lg --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "a ZERO-PREFIXED pid is held, not cleared (17)" "17" "$RC"
  assert_eq "  and the lock survives" "1" "$([ -d "$lgld" ] && echo 1 || echo 0)"
  assert_eq "  and launched nothing" "$n_before" "$(invocations)"
  assert_contains "  and says nothing was deleted" "Nothing was deleted" "$o"
  assert_contains "  and names it as not a usable process id" "not a usable process id" "$o"

  # --- UNKNOWN (3): malformed, `0`. The quiet catastrophe in the other
  # direction: `kill -0 0` SUCCEEDS, because pid 0 means the CALLER'S OWN process
  # group, so a conflating launcher reads a corrupt lock as a live holder. Both
  # readings are wrong for the same reason — a corrupt lock is not evidence — and
  # the refusal has to say so rather than name a holder that does not exist.
  plant_lock_raw "$lgld" 0 task-lg-zero0
  n_before="$(invocations)"
  run_sut --checkout "$REPO" --task task-lg --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "pid 0 is held as UNKNOWN, not read as a live holder (17)" "17" "$RC"
  assert_eq "  and the lock survives" "1" "$([ -d "$lgld" ] && echo 1 || echo 0)"
  assert_eq "  and launched nothing" "$n_before" "$(invocations)"
  assert_contains "  and says nothing was deleted" "Nothing was deleted" "$o"
  assert_absent "  and does NOT claim another carry is in flight" \
                "another carry is in flight" "$o"

  # --- UNKNOWN (4): malformed, not a number at all.
  plant_lock_raw "$lgld" not-a-pid task-lg-junk
  n_before="$(invocations)"
  run_sut --checkout "$REPO" --task task-lg --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "a NON-NUMERIC pid is held, not cleared (17)" "17" "$RC"
  assert_eq "  and the lock survives" "1" "$([ -d "$lgld" ] && echo 1 || echo 0)"
  assert_eq "  and launched nothing" "$n_before" "$(invocations)"
  assert_contains "  and says nothing was deleted" "Nothing was deleted" "$o"
  assert_contains "  and quotes the unusable value" "not-a-pid" "$o"

  # --- UNKNOWN (5): no pid file at all. Distinct from the present-but-empty file
  # section 12 already covers, and it must reach the same refusal.
  plant_lock_raw "$lgld" NONE task-lg-nopid
  n_before="$(invocations)"
  run_sut --checkout "$REPO" --task task-lg --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "a MISSING pid file is held, not cleared (17)" "17" "$RC"
  assert_eq "  and the lock survives" "1" "$([ -d "$lgld" ] && echo 1 || echo 0)"
  assert_eq "  and launched nothing" "$n_before" "$(invocations)"
  assert_contains "  and says nothing was deleted" "Nothing was deleted" "$o"

  # --- LIVE: the holder is visible and signallable. Refused, and preserved.
  plant_lock_raw "$lgld" "$$" task-lg-alive
  n_before="$(invocations)"
  run_sut --checkout "$REPO" --task task-lg --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "a LIVE holder is refused (17)" "17" "$RC"
  assert_eq "  and the lock survives" "1" "$([ -d "$lgld" ] && echo 1 || echo 0)"
  assert_eq "  and launched nothing" "$n_before" "$(invocations)"
  assert_contains "  and names it as a carry in flight" "another carry is in flight" "$o"

  # --- ABSENT: the POSITIVE CONTROL. `kill -0` reported "no such process", which
  # is the only evidence that permits a write on this path. The lock must be
  # cleared and the carry admitted — and cleared ATOMICALLY, so the rename target
  # must not be left behind either. Run last, because it is the only case here
  # that consumes the fixture's turn.
  ( exit 0 ) & lgdead=$!; wait "$lgdead" 2>/dev/null
  plant_lock_raw "$lgld" "$lgdead" task-lg-dead
  printf 'transition:codex' >"$ACTION"
  n_before="$(invocations)"
  run_sut --checkout "$REPO" --task task-lg --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "a POSITIVELY ABSENT holder is the one state that clears (0)" "0" "$RC"
  assert_contains "  and says so" "removing a stale lock" "$o"
  assert_eq "  and the stale lock is GONE" "0" "$([ -d "$lgld" ] && echo 1 || echo 0)"
  assert_eq "  and no rename target is left behind" "0" \
            "$(find "$(dirname "$lgld")" -maxdepth 1 -name "$(basename "$lgld").stale.*" 2>/dev/null | wc -l | tr -d ' ')"
  if [ "$(invocations)" != "$n_before" ]; then ok "  and the carry was admitted"
  else bad "  and the carry was admitted" "the actor never launched"; fi
  rm -rf "$lgld"

section "12b. The live lock is checkout-wide, not per task"
  # One checkout is one working tree with one index and one HEAD. Two carries in
  # it are two writers to one surface whatever tasks they name, so the ownership
  # key is the checkout alone. Keying it by checkout+task made the task id the
  # isolation boundary and admitted two different tasks side by side.
  mkfix xwide task-ba claude
  XREPO="$REPO"; XFAKE="$FAKEBIN"; XLOGD="$LOGD"
  # A SECOND task in the SAME checkout, committed so the fixture starts clean.
  mkstate_in "$XREPO" task-bb claude
  git -C "$XREPO" add -A >/dev/null 2>&1
  git -C "$XREPO" commit -q -m "second task" >/dev/null 2>&1
  BB_ARGV="$TMPROOT/xwide-bb.argv"; : >"$BB_ARGV"
  BB_COUNT="$TMPROOT/xwide-bb.count"; : >"$BB_COUNT"
  BB_ACTION="$TMPROOT/xwide-bb.action"; printf 'transition:codex' >"$BB_ACTION"
  BB_FAKE="$TMPROOT/xwide-bb.actor"
  make_fake_actor "$BB_FAKE" "$BB_ARGV" "$BB_COUNT" "$BB_ACTION" \
                  "$XREPO/logs/work-loop/task-bb.md"

  xld="$(lock_path_for "$XREPO")"
  plant_lock "$xld" "$$" task-ba                        # task-ba is live here
  run_sut --checkout "$XREPO" --task task-bb --claude-bin "$BB_FAKE" --log-dir "$XLOGD"
  assert_eq "a DIFFERENT task in the same checkout is refused (17)" "17" "$RC"
  assert_contains "  and names the task that holds the checkout" "task 'task-ba'" "$o"
  assert_contains "  and says the refusal is checkout-wide" "whether or not it is the same task" "$o"
  assert_eq "  and stopped BEFORE actor launch" "0" "$(wc -c <"$BB_COUNT" | tr -d ' ')"
  assert_eq "  and the holder's lock survives" "1" "$([ -d "$xld" ] && echo 1 || echo 0)"

  # A separate linked worktree canonicalizes to a different path, so it takes a
  # different CHECKOUT lease. It does NOT get a second run of the same task: one
  # task is one live run anywhere in the repository, and the task lease is what
  # says so. This block asserted the opposite before the shared lease landed — a
  # second worktree was independently admissible for the same task — and that
  # admission is the cross-transport hole the shared lease closes.
  WT="$TMPROOT/xwide-wt"
  git -C "$XREPO" worktree add -q -b wt-lane "$WT" >/dev/null 2>&1
  assert_eq "linked worktree was created" "1" "$([ -d "$WT/logs/work-loop" ] && echo 1 || echo 0)"
  assert_absent "  worktree takes a different legacy lock path" "$xld" "$(lock_path_for "$WT")"
  assert_absent "  and a different checkout lease" "$(checkout_lease_for "$XREPO")" "$(checkout_lease_for "$WT")"
  WT_ARGV="$TMPROOT/xwide-wt.argv"; : >"$WT_ARGV"
  WT_COUNT="$TMPROOT/xwide-wt.count"; : >"$WT_COUNT"
  WT_ACTION="$TMPROOT/xwide-wt.action"; printf 'transition:codex' >"$WT_ACTION"
  WT_FAKE="$TMPROOT/xwide-wt.actor"
  make_fake_actor "$WT_FAKE" "$WT_ARGV" "$WT_COUNT" "$WT_ACTION" \
                  "$WT/logs/work-loop/task-bb.md"
  # A live holder of the TASK lease, in checkout X, recorded the way the shared
  # library records one — pid, task, checkout and the program that holds it.
  xtl="$(task_lease_for "$XREPO" task-bb)"
  plant_lease "$xtl" "$$" task-bb "$XREPO" carry
  run_sut --checkout "$WT" --task task-bb --claude-bin "$WT_FAKE" --log-dir "$TMPROOT/xwide-wt.runs"
  assert_eq "the same task in a separate linked worktree is REFUSED (17)" "17" "$RC"
  assert_contains "  and names the TASK lease as the resource" "TASK lease for 'task-bb'" "$o"
  assert_contains "  and says another checkout does not make it another task" \
    "including in another linked worktree" "$o"
  assert_eq "  and stopped BEFORE actor launch" "0" "$(wc -c <"$WT_COUNT" | tr -d ' ')"
  assert_eq "  and the holder's task lease survives" "1" "$([ -d "$xtl" ] && echo 1 || echo 0)"

  # The over-refusal control. With the task lease free, the worktree carries —
  # a different checkout is still legitimate concurrency, and the change must not
  # have turned every worktree into a refusal.
  #
  # Ownership has to be SETTLED for that to be what this control measures. The
  # worktree add above replicated task-bb's state file into a second checkout with
  # neither one declaring it, and repository-depth ownership reads exactly that as
  # AMBIGUOUS — the approved refusal for replicated state, proved on its own in
  # 12e case 20b. Left unsettled, this control would stop at 34 and the lease
  # would never be reached, so it would no longer be testing the lease at all.
  #
  # The declaration is made with the helper's own LOCAL claim, not a hand-written
  # marker and not a repo-depth one. Local is the depth that can still write here:
  # at repo depth `claim` runs the same replicated-state read and refuses, writing
  # nothing — which is 12e case 20a's warning, and the reason claiming is never
  # the way out of an ambiguity.
  rm -rf "$xtl"
  bash "$WT/logs/scripts/work-loop-owner.sh" claim --checkout "$WT" \
       --task task-bb --depth local >/dev/null 2>&1
  run_sut --checkout "$WT" --task task-bb --claude-bin "$WT_FAKE" --log-dir "$TMPROOT/xwide-wt.runs"
  assert_eq "with the task lease free and ownership settled the worktree IS admitted" "0" "$RC"
  assert_contains "  and carried" "RESULT outcome=CARRIED code=0" "$o"
  assert_eq "  and its actor ran" "1" "$(wc -c <"$WT_COUNT" | tr -d ' ')"
  assert_eq "  while checkout X's legacy lock is still held" "1" "$([ -d "$xld" ] && echo 1 || echo 0)"

  # X is still refused after the worktree carry — the two checkouts are
  # independent, and the legacy in-flight lock in X is still read.
  run_sut --checkout "$XREPO" --task task-bb --claude-bin "$BB_FAKE" --log-dir "$XLOGD"
  assert_eq "checkout X is still refused after the worktree carry (17)" "17" "$RC"
  rm -rf "$xld"

  # The worktree goes NOW, before the last control, and the ordering is
  # load-bearing rather than tidy. While it exists it both declares task-bb and
  # holds a copy of its state file, so repository-depth ownership would refuse
  # checkout X (33) and the control below would never reach the lease it is about.
  # Removing it takes the declaration with it — the marker is untracked, so it
  # lives only in that working tree — and leaves X holding the task's one and only
  # state file, which is the unique-copy condition ownership admits.
  git -C "$XREPO" worktree remove --force "$WT" >/dev/null 2>&1

  # With the holder gone, the same checkout admits the second task normally —
  # the refusal is about concurrency, not a permanent binding to one task.
  run_sut --checkout "$XREPO" --task task-bb --claude-bin "$BB_FAKE" --log-dir "$XLOGD"
  assert_eq "with no live holder the second task carries normally" "0" "$RC"
  assert_eq "  and both of its leases were released" "0" \
    "$([ -d "$(task_lease_for "$XREPO" task-bb)" ] || [ -d "$(checkout_lease_for "$XREPO")" ] && echo 1 || echo 0)"

section "12c. The shared lease library must be present"
  # An absent lease library means the live lease cannot be taken, and an absent
  # check is not a passed check. The checkouts most likely to lack it — older
  # siblings, partial copies — are exactly the ones most likely to hold a
  # conflicting writer, so this fails closed and launches nothing.
  #
  # The code is 11, this launcher's existing BAD_CHECKOUT outcome. It is not a
  # new number: a checkout that cannot produce the library is a checkout whose
  # lease cannot be established.
  mkfix nolease task-bc claude
  printf 'transition:codex' >"$ACTION"
  git -C "$REPO" rm -q --cached logs/scripts/work-loop-lease.sh >/dev/null 2>&1
  rm -f "$REPO/logs/scripts/work-loop-lease.sh"
  git -C "$REPO" commit -q -m "remove the lease library" >/dev/null 2>&1
  before_head="$(git -C "$REPO" rev-parse HEAD)"
  run_sut --checkout "$REPO" --task task-bc --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "an absent lease library refuses (11)" "11" "$RC"
  assert_contains "  and names the missing library" "missing or unreadable" "$o"
  assert_eq "  and launched nothing" "0" "$(invocations)"
  assert_eq "  and committed nothing" "$before_head" "$(git -C "$REPO" rev-parse HEAD)"
  # A refusal must not leave a lease behind: it never took one, so both lease
  # directories must be absent. A half-acquiring refusal would refuse the NEXT
  # run for a reason that never existed.
  assert_eq "  and left no lease directory behind" "0" \
    "$([ -d "$(task_lease_for "$REPO" task-bc)" ] || [ -d "$(checkout_lease_for "$REPO")" ] && echo 1 || echo 0)"

  # The control. Same recipe, library present — the same run proceeds and does
  # launch. Without it, a launcher that refused everything would pass above.
  mkfix yeslease task-bd claude
  printf 'transition:codex' >"$ACTION"
  run_sut --checkout "$REPO" --task task-bd --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "control — with the library present the same run carries" "0" "$RC"
  assert_eq "  and its actor ran" "1" "$(invocations)"

section "12d. An unprovable shutdown pins both leases"
  # Property 4 of the shared live-lease contract: when a run cannot prove the
  # actor tree it started has stopped, BOTH leases are pinned and no ordinary
  # exit path releases them. The launcher used to warn and release, which left
  # the next run — attended or dispatched — free to start beside a survivor.
  #
  # Reaching the branch: the actor IGNORES SIGTERM, so the TERM grace expires and
  # the launcher goes on to SIGKILL and then verify. Verification is a census of
  # the actor's process group, and the survivor is injected there (see SURVPSDIR)
  # because a same-uid process group is always cleared by SIGKILL — the condition
  # is real in production (a process that has not finished dying, or one this uid
  # may not signal) and cannot be manufactured hermetically at the kernel.

  # The control first, with a real `ps`: the tree IS proven gone, so nothing is
  # pinned and both leases are released. Without it, a launcher that pinned on
  # every timeout would pass every assertion below.
  mkfix pinctl task-be claude
  printf 'ignore-term:30' >"$ACTION"
  run_sut --checkout "$REPO" --task task-be --claude-bin "$FAKEBIN" --timeout 1 --log-dir "$LOGD"
  assert_eq "control — a timed-out actor whose tree IS gone is ACTOR_TIMEOUT" "21" "$RC"
  assert_absent "  and nothing is pinned" "PINNED" "$o"
  assert_eq "  and both leases were released" "0" \
    "$([ -d "$(task_lease_for "$REPO" task-be)" ] || [ -d "$(checkout_lease_for "$REPO")" ] && echo 1 || echo 0)"

  # A survivor the census CAN see. The launcher must say so and pin.
  mkfix pinsurv task-bf claude
  printf 'ignore-term:30' >"$ACTION"
  o="$(PATH="$SURVPSDIR:$PATH" "$SUT" --checkout "$REPO" --task task-bf \
        --claude-bin "$FAKEBIN" --timeout 1 --log-dir "$LOGD" 2>&1)"; RC=$?
  stl="$(task_lease_for "$REPO" task-bf)"; scl="$(checkout_lease_for "$REPO")"
  assert_eq "an unprovable shutdown is still ACTOR_TIMEOUT (the pin does not change the code)" "21" "$RC"
  assert_contains "  and warns that the group could not be confirmed gone" \
    "could not be confirmed gone" "$o"
  assert_contains "  and NAMES the surviving pid" \
    "still running in the actor's process group: $SURVPID" "$o"
  assert_contains "  and says both leases are pinned" "BOTH leases are now PINNED" "$o"
  assert_eq "  the TASK lease is PINNED, not released" "1" "$([ -f "$stl/survivors" ] && echo 1 || echo 0)"
  assert_eq "  the CHECKOUT lease is PINNED, not released" "1" "$([ -f "$scl/survivors" ] && echo 1 || echo 0)"
  assert_contains "  and the pin file records the pid, so the operator can find it" \
    "descendants still running: $SURVPID" "$(cat "$stl/survivors" 2>/dev/null)"

  # The invariant as the NEXT run experiences it. This is the whole point of the
  # pin: a second carrier is refused rather than started beside the survivor.
  n_before="$(invocations)"
  run_sut --checkout "$REPO" --task task-bf --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "a SECOND carry is REFUSED while the lease is pinned (17)" "17" "$RC"
  assert_contains "  and says PINNED rather than merely held" "is PINNED" "$o"
  assert_contains "  and refuses to advise deleting anything it cannot show is dead" \
    "Nothing was deleted here" "$o"
  assert_eq "  and launched nothing further" "$n_before" "$(invocations)"
  rm -rf "$stl" "$scl"

  # The sweep that could not LOOK. A census that cannot run is UNKNOWN, not a
  # clean bill of health — the same rule the nested-actor observation follows,
  # and the same one the dispatcher applies to its own incomplete sweep.
  mkfix pinblind task-bg claude
  printf 'ignore-term:30' >"$ACTION"
  o="$(PATH="$NOPSDIR:$PATH" "$SUT" --checkout "$REPO" --task task-bg \
        --claude-bin "$FAKEBIN" --timeout 1 --log-dir "$LOGD" 2>&1)"; RC=$?
  btl="$(task_lease_for "$REPO" task-bg)"; bcl="$(checkout_lease_for "$REPO")"
  assert_eq "a census that cannot run is still ACTOR_TIMEOUT" "21" "$RC"
  assert_contains "  and is reported as an incomplete sweep, not as success" \
    "sweep incomplete" "$o"
  assert_eq "  and the TASK lease is PINNED" "1" "$([ -f "$btl/survivors" ] && echo 1 || echo 0)"
  assert_eq "  and the CHECKOUT lease is PINNED" "1" "$([ -f "$bcl/survivors" ] && echo 1 || echo 0)"
  rm -rf "$btl" "$bcl"

  # ---- The TERM grace period is a proof step too, not a signal probe ----
  #
  # The cases above all reach the SIGKILL-and-verify branch, because the actor
  # ignores SIGTERM. An actor that DIES on SIGTERM leaves through the grace loop
  # instead, and that loop used to decide the whole question with `kill -0` on
  # the group: one failed signal probe returned a clean shutdown and released
  # both leases without ever looking at what was in the group. `kill -0` answers
  # one bit and answers it wrong in the direction that matters — a survivor this
  # uid may not signal is indistinguishable from an empty group — so the grace
  # loop needs the same census the post-SIGKILL branch uses.
  #
  # The positive control first. Without it, a launcher that simply never left
  # the grace loop early would pass both assertions below.
  mkfix graceok task-bh claude
  printf 'sleep:30' >"$ACTION"
  run_sut --checkout "$REPO" --task task-bh --claude-bin "$FAKEBIN" --timeout 1 --log-dir "$LOGD"
  assert_eq "control — an actor that DIES on SIGTERM is ACTOR_TIMEOUT" "21" "$RC"
  assert_absent "  and a census that proved the group empty pins nothing" "PINNED" "$o"
  assert_eq "  and both leases were released" "0" \
    "$([ -d "$(task_lease_for "$REPO" task-bh)" ] || [ -d "$(checkout_lease_for "$REPO")" ] && echo 1 || echo 0)"

  # Inspection becomes unavailable DURING the grace period. The actor really did
  # die, but nothing here can show that, and an unprovable shutdown pins.
  mkfix graceblind task-bi claude
  printf 'sleep:30' >"$ACTION"
  o="$(PATH="$NOGPSDIR:$PATH" "$SUT" --checkout "$REPO" --task task-bi \
        --claude-bin "$FAKEBIN" --timeout 1 --log-dir "$LOGD" 2>&1)"; RC=$?
  gtl="$(task_lease_for "$REPO" task-bi)"; gcl="$(checkout_lease_for "$REPO")"
  assert_eq "a grace period that cannot inspect is still ACTOR_TIMEOUT" "21" "$RC"
  assert_contains "  and does NOT report a clean shutdown it could not see" \
    "could not be confirmed gone" "$o"
  assert_contains "  and names the inspection failure as the reason" "sweep incomplete" "$o"
  assert_eq "  and the TASK lease is PINNED" "1" "$([ -f "$gtl/survivors" ] && echo 1 || echo 0)"
  assert_eq "  and the CHECKOUT lease is PINNED" "1" "$([ -f "$gcl/survivors" ] && echo 1 || echo 0)"
  rm -rf "$gtl" "$gcl"

  # A survivor visible during the grace period. The top-level actor is gone, so
  # the group stops answering `kill -0` — which is exactly the shortcut that used
  # to release both leases beside a process the census can still see.
  mkfix gracesurv task-bj claude
  printf 'sleep:30' >"$ACTION"
  o="$(PATH="$SURVPSDIR:$PATH" "$SUT" --checkout "$REPO" --task task-bj \
        --claude-bin "$FAKEBIN" --timeout 1 --log-dir "$LOGD" 2>&1)"; RC=$?
  vtl="$(task_lease_for "$REPO" task-bj)"; vcl="$(checkout_lease_for "$REPO")"
  assert_eq "a survivor seen during the grace period is still ACTOR_TIMEOUT" "21" "$RC"
  assert_contains "  and the launcher NAMES it rather than releasing" \
    "still running in the actor's process group: $SURVPID" "$o"
  assert_eq "  the TASK lease is PINNED" "1" "$([ -f "$vtl/survivors" ] && echo 1 || echo 0)"
  assert_eq "  the CHECKOUT lease is PINNED" "1" "$([ -f "$vcl/survivors" ] && echo 1 || echo 0)"
  assert_contains "  and the pin file records the pid" \
    "descendants still running: $SURVPID" "$(cat "$vtl/survivors" 2>/dev/null)"
  rm -rf "$vtl" "$vcl"

  # ---- The census must prove ITS OWN query form, not a neighbouring one ----
  #
  # `ps` runs here; `ps -g` does not. The readability control used to ask `ps -p
  # $$`, which passes straight through this stub, so the group query's own
  # failure produced an empty answer that read as a confirmed-empty group — and
  # after SIGKILL the group really has stopped answering, so the signal probe
  # agreed and both leases were released. Missing evidence became a clean bill of
  # health. Distinct from the whole-`ps` case above, which the `-p` control
  # already catches.
  mkfix pinnogps task-bk claude
  printf 'ignore-term:30' >"$ACTION"
  o="$(PATH="$NOGPSDIR:$PATH" "$SUT" --checkout "$REPO" --task task-bk \
        --claude-bin "$FAKEBIN" --timeout 1 --log-dir "$LOGD" 2>&1)"; RC=$?
  ntl="$(task_lease_for "$REPO" task-bk)"; ncl="$(checkout_lease_for "$REPO")"
  assert_eq "a group query that cannot run is still ACTOR_TIMEOUT" "21" "$RC"
  assert_contains "  and is an incomplete sweep, not a confirmed-empty group" \
    "sweep incomplete" "$o"
  assert_eq "  and the TASK lease is PINNED" "1" "$([ -f "$ntl/survivors" ] && echo 1 || echo 0)"
  assert_eq "  and the CHECKOUT lease is PINNED" "1" "$([ -f "$ncl/survivors" ] && echo 1 || echo 0)"
  assert_contains "  and the pin file records WHY, so the operator is not told to inspect nothing" \
    "sweep incomplete" "$(cat "$ntl/survivors" 2>/dev/null)"
  rm -rf "$ntl" "$ncl"

section "12e. Repository-depth ownership admission before actor launch"
  # The leases above answer "is another run live?". They cannot answer "does this
  # task belong to this checkout?", because a lease dies with its process and a
  # task outlives one. That second question is the durable declaration's, and the
  # launcher must ask it at REPO depth — it may run git, so unlike interactive
  # Codex it can see the other worktrees of the repository.
  #
  # Proposal §4.4 binds the three stops to 33, 34 and 35, which are free in this
  # launcher's taxonomy and already mean ownership across the Work Loop. §5.5
  # cases 19 and 20 are the two rows these assertions come from. The admission
  # mirrors dispatch.sh 2336-2367, so the messages asserted here are that block's
  # own wording rather than a second vocabulary invented for the carrier.
  #
  # THE CHECK FAILS CLOSED. A checkout without the helper gets 35 and launches
  # NOTHING. An absent check is not a passed check, and the checkouts most likely
  # to lack the helper — older siblings, partial copies — are exactly the ones
  # most likely to hold a conflicting writer.
  #
  # Every case here asserts the exit code AND a launch count of zero. The count is
  # what makes it more than an exit-code assertion: a launcher that stopped after
  # starting an actor would satisfy the code and still have admitted the second
  # writer this admission exists to refuse.

  # --- Case 19: the helper is missing, so the check cannot run at all.
  mkfix noowner task-bh claude
  printf 'transition:codex' >"$ACTION"
  # mkfix packages the helper into every fixture, so this case has to REMOVE it —
  # from the index and from disk, the same way 12c removes the lease library. A
  # `rm` alone would leave a tracked deletion in the working tree, which is an
  # out-of-allowlist change and would stop the launcher at 18 before ownership was
  # ever reached: the case would then pass for a reason that has nothing to do
  # with an absent helper.
  git -C "$REPO" rm -q --cached logs/scripts/work-loop-owner.sh >/dev/null 2>&1
  rm -f "$REPO/logs/scripts/work-loop-owner.sh"
  git -C "$REPO" commit -q -m "remove the ownership helper" >/dev/null 2>&1
  # Asserted rather than assumed: if the removal above ever stopped working, this
  # case would silently stop testing an absent helper.
  assert_eq "12e setup — the fixture carries no ownership helper" "0" \
    "$([ -f "$REPO/logs/scripts/work-loop-owner.sh" ] && echo 1 || echo 0)"
  assert_eq "12e setup — but it does carry the lease library, so the lease is not the stop" "1" \
    "$([ -f "$REPO/logs/scripts/work-loop-lease.sh" ] && echo 1 || echo 0)"
  before_head="$(git -C "$REPO" rev-parse HEAD)"
  run_sut --checkout "$REPO" --task task-bh --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "an absent ownership helper refuses (35)" "35" "$RC"
  assert_contains "  and says the check could not run" "ownership check is unavailable" "$o"
  assert_eq "  and launched nothing" "0" "$(invocations)"
  assert_eq "  and committed nothing" "$before_head" "$(git -C "$REPO" rev-parse HEAD)"
  # The discriminators. Without these the case would be satisfied by a launcher
  # that refused for a lease reason, or that carried and reported success.
  assert_absent "  and it is not the lease refusal" "code=17" "$o"
  assert_absent "  and it did not carry" "outcome=CARRIED" "$o"
  # A refusal before any lease is taken must leave no lease behind, or it refuses
  # the NEXT run for a reason that never existed.
  assert_eq "  and left no lease directory behind" "0" \
    "$([ -d "$(task_lease_for "$REPO" task-bh)" ] || [ -d "$(checkout_lease_for "$REPO")" ] && echo 1 || echo 0)"

  # The control. Same recipe, helper PRESENT and ownership settled — the run must
  # proceed and must launch. Without it, every assertion above would be satisfied
  # by a launcher that refuses everything, which is not the behaviour claimed.
  mkfix yesowner task-bk claude
  add_owner_helper "$REPO"
  printf 'transition:codex' >"$ACTION"
  assert_eq "control setup — the helper is packaged and committed" "1" \
    "$([ -f "$REPO/logs/scripts/work-loop-owner.sh" ] && echo 1 || echo 0)"
  bash "$REPO/logs/scripts/work-loop-owner.sh" check --checkout "$REPO" \
       --task task-bk --depth repo >/dev/null 2>&1
  assert_eq "control setup — repo-depth ownership says PROCEED (0)" "0" "$?"
  run_sut --checkout "$REPO" --task task-bk --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "control — with the helper present and ownership clear the run carries" "0" "$RC"
  assert_eq "  and its actor ran" "1" "$(invocations)"

  # --- Case 20a: repo-depth ownership REFUSE.
  # The task is declared by the MAIN checkout; the launcher is pointed at a linked
  # worktree of the same repository. Repo depth sees one claimant and it is not
  # this checkout, so the verdict is REFUSE.
  #
  # The declaration is made BEFORE the worktree exists, and that ordering is
  # load-bearing rather than tidy: once the state file has replicated into a
  # second checkout with nothing declaring it, `claim` itself reads AMBIGUOUS and
  # writes nothing — so claiming afterwards would produce case 20b's condition
  # instead of this one, and the case would assert 33 against an ambiguity.
  mkfix ownref task-bi claude
  OREPO="$REPO"
  add_owner_helper "$OREPO"
  bash "$OREPO/logs/scripts/work-loop-owner.sh" claim --checkout "$OREPO" \
       --task task-bi --depth repo >/dev/null 2>&1
  assert_eq "12e-20a setup — the main checkout declares the task" "0" "$?"
  RWT="$TMPROOT/ownref-wt"
  git -C "$OREPO" worktree add -q -b ownref-lane "$RWT" >/dev/null 2>&1
  assert_eq "12e-20a setup — the state file replicates into the linked worktree" "1" \
    "$([ -f "$RWT/logs/work-loop/task-bi.md" ] && echo 1 || echo 0)"
  # The fixture's own condition, proven directly against the helper. This
  # separates "the fixture reaches the intended ownership verdict" from "the
  # launcher acts on it" — so a red assertion below cannot be blamed on a fixture
  # that never produced a REFUSE in the first place.
  bash "$RWT/logs/scripts/work-loop-owner.sh" check --checkout "$RWT" \
       --task task-bi --depth repo >/dev/null 2>&1
  assert_eq "12e-20a setup — repo-depth ownership says REFUSE (3) from the worktree" "3" "$?"
  RWT_ARGV="$TMPROOT/ownref-wt.argv"; : >"$RWT_ARGV"
  RWT_COUNT="$TMPROOT/ownref-wt.count"; : >"$RWT_COUNT"
  RWT_ACTION="$TMPROOT/ownref-wt.action"; printf 'transition:codex' >"$RWT_ACTION"
  RWT_FAKE="$TMPROOT/ownref-wt.actor"
  make_fake_actor "$RWT_FAKE" "$RWT_ARGV" "$RWT_COUNT" "$RWT_ACTION" \
                  "$RWT/logs/work-loop/task-bi.md"
  before_head="$(git -C "$RWT" rev-parse HEAD)"
  run_sut --checkout "$RWT" --task task-bi --claude-bin "$RWT_FAKE" \
          --log-dir "$TMPROOT/ownref-wt.runs"
  assert_eq "a REFUSE ownership verdict stops the carry (33)" "33" "$RC"
  assert_contains "  and names the stop as an ownership refusal" "ownership refused for task" "$o"
  assert_contains "  and carries the helper's own reason" "already claimed by checkout" "$o"
  assert_eq "  and launched nothing" "0" "$(wc -c <"$RWT_COUNT" | tr -d ' ')"
  assert_eq "  and committed nothing in the worktree" "$before_head" "$(git -C "$RWT" rev-parse HEAD)"
  assert_absent "  and it is not the lease refusal" "code=17" "$o"
  assert_absent "  and it did not carry" "outcome=CARRIED" "$o"
  git -C "$OREPO" worktree remove --force "$RWT" >/dev/null 2>&1

  # --- Case 20b: repo-depth ownership AMBIGUOUS.
  # No checkout declares the task and its state file exists in two of them.
  # Replicated copies authorise nobody, so neither checkout may proceed — and
  # this is the condition that must NOT be resolved by claiming.
  mkfix ownamb task-bj claude
  AREPO="$REPO"
  add_owner_helper "$AREPO"
  AWT="$TMPROOT/ownamb-wt"
  git -C "$AREPO" worktree add -q -b ownamb-lane "$AWT" >/dev/null 2>&1
  assert_eq "12e-20b setup — the state file replicates into the linked worktree" "1" \
    "$([ -f "$AWT/logs/work-loop/task-bj.md" ] && echo 1 || echo 0)"
  assert_eq "12e-20b setup — and no checkout declares the task" "0" \
    "$([ -f "$AREPO/logs/work-loop/.owner" ] || [ -f "$AWT/logs/work-loop/.owner" ] && echo 1 || echo 0)"
  bash "$AWT/logs/scripts/work-loop-owner.sh" check --checkout "$AWT" \
       --task task-bj --depth repo >/dev/null 2>&1
  assert_eq "12e-20b setup — repo-depth ownership says AMBIGUOUS (4)" "4" "$?"
  AWT_ARGV="$TMPROOT/ownamb-wt.argv"; : >"$AWT_ARGV"
  AWT_COUNT="$TMPROOT/ownamb-wt.count"; : >"$AWT_COUNT"
  AWT_ACTION="$TMPROOT/ownamb-wt.action"; printf 'transition:codex' >"$AWT_ACTION"
  AWT_FAKE="$TMPROOT/ownamb-wt.actor"
  make_fake_actor "$AWT_FAKE" "$AWT_ARGV" "$AWT_COUNT" "$AWT_ACTION" \
                  "$AWT/logs/work-loop/task-bj.md"
  before_head="$(git -C "$AWT" rev-parse HEAD)"
  run_sut --checkout "$AWT" --task task-bj --claude-bin "$AWT_FAKE" \
          --log-dir "$TMPROOT/ownamb-wt.runs"
  assert_eq "an AMBIGUOUS ownership verdict stops the carry (34)" "34" "$RC"
  assert_contains "  and names the stop as ownership ambiguity" "ownership is AMBIGUOUS for task" "$o"
  assert_contains "  and carries the helper's own reason" "replicated copies authorise nobody" "$o"
  assert_eq "  and launched nothing" "0" "$(wc -c <"$AWT_COUNT" | tr -d ' ')"
  assert_eq "  and committed nothing in the worktree" "$before_head" "$(git -C "$AWT" rev-parse HEAD)"
  assert_absent "  and it is not the lease refusal" "code=17" "$o"
  assert_absent "  and it did not carry" "outcome=CARRIED" "$o"
  # An ambiguity is the operator's to resolve, so the launcher must not have
  # written a declaration of its own on the way past.
  assert_eq "  and declared nothing on its own account" "0" \
    "$([ -f "$AREPO/logs/work-loop/.owner" ] || [ -f "$AWT/logs/work-loop/.owner" ] && echo 1 || echo 0)"
  git -C "$AREPO" worktree remove --force "$AWT" >/dev/null 2>&1

section "12f. Every pin result is reported as itself"
  # The lease library answers a pin with THREE distinct outcomes — 0 durably
  # pinned, 1 nothing owned, 2 owned and pinned but with no durable record. This
  # launcher used to write `wl_lease_pin ... || return 0`, which merged 1, 2 and
  # any future code into the silent no-owned path. rc=2 is the one that matters:
  # the lease DIRECTORIES are retained and still refuse the next run, but the
  # written reason inside them is missing, so the operator meets an unexplained
  # held lease and the obvious reading — a removable stale lock — is the unsafe
  # one. 12d's success case is the rc=0 control for this section.

  # A `ps` that injects a survivor exactly as SURVPSDIR does, and ALSO makes the
  # pin record unpersistable. The block is a DIRECTORY where the `survivors` file
  # has to go: `>` then cannot create the file for any user, root included, so
  # the forcing needs no privilege and nothing destructive, and `[ -f ]` — the
  # same test the library, acquire and `--status` recognise a pin by — is false
  # afterwards. Same device the library's own suite uses.
  #
  # It blocks at the point the launcher LOOKS, which is after the leases are
  # acquired and before the pin is written. Earlier invocations, before the lease
  # directories exist, simply fail to mkdir and leave nothing behind.
  PINBLOCKPSDIR="$TMPROOT/pinblock-ps"
  mkdir -p "$PINBLOCKPSDIR"
  cat >"$PINBLOCKPSDIR/ps" <<'PSBLOCK'
#!/bin/bash
for d in ${WL_TEST_PIN_BLOCK:-}; do mkdir -p "$d/survivors" 2>/dev/null; done
out="$(/bin/ps "$@" 2>/dev/null)"; rc=$?
[ -n "$out" ] && printf '%s\n' "$out"
prev=""; g=""
for a in "$@"; do [ "$prev" = "-g" ] && g="$a"; prev="$a"; done
if [ -n "$g" ]; then printf '%s %s\n' "$PPID" "$g"; rc=0; fi
exit "$rc"
PSBLOCK
  chmod +x "$PINBLOCKPSDIR/ps"

  # Replace the library's pin with one that returns a chosen code, and commit it
  # so the working tree stays clean — an untracked or modified helper is an
  # out-of-allowlist change and the launcher would stop on that instead. rc=1 and
  # an unrecognised code have no route through the real library from here, so the
  # override is the only way to reach them; rc=2 above is forced for real.
  stub_pin_rc() { # repo, rc, pinned-flag
    printf '\nwl_lease_pin() { WL_LEASE_PINNED=%s; return %s; }\n' "$3" "$2" \
      >>"$1/logs/scripts/work-loop-lease.sh"
    git -C "$1" add -- logs/scripts/work-loop-lease.sh >/dev/null 2>&1
    git -C "$1" commit -q -m "stub the pin result" >/dev/null 2>&1
  }

  # rc=2 — owned, pinned, and the record did NOT persist.
  mkfix pinnorec task-bk claude
  printf 'ignore-term:30' >"$ACTION"
  ktl="$(task_lease_for "$REPO" task-bk)"; kcl="$(checkout_lease_for "$REPO")"
  o="$(WL_TEST_PIN_BLOCK="$ktl $kcl" PATH="$PINBLOCKPSDIR:$PATH" "$SUT" \
        --checkout "$REPO" --task task-bk --claude-bin "$FAKEBIN" \
        --timeout 1 --log-dir "$LOGD" 2>&1)"; RC=$?
  assert_eq "an unpersisted pin record is still ACTOR_TIMEOUT (the outer outcome is unchanged)" "21" "$RC"
  assert_contains "  and the teardown warning still stands" "could not be confirmed gone" "$o"
  assert_contains "  and says the pin RECORD could not be persisted" \
    "pin RECORD could not be persisted" "$o"
  assert_contains "  and NAMES the resources whose evidence is missing" \
    "task checkout" "$o"
  assert_contains "  and says the lease directories were RETAINED, not released" \
    "deliberately RETAINED" "$o"
  assert_contains "  and says the next run is still refused" "still refused with exit 17" "$o"
  assert_contains "  and warns against reading them as a removable stale lease" \
    "removable stale lease" "$o"
  # The false success line is the whole failure this case exists to prevent: a
  # pin that recorded nothing must never be announced as one that did.
  assert_absent "  and does NOT claim the durable pin succeeded" \
    "BOTH leases are now PINNED" "$o"
  assert_eq "  the TASK lease directory is retained" "1" "$([ -d "$ktl" ] && echo 1 || echo 0)"
  assert_eq "  the CHECKOUT lease directory is retained" "1" "$([ -d "$kcl" ] && echo 1 || echo 0)"
  assert_eq "  and the evidence really is absent, not merely unmentioned" "0" \
    "$([ -f "$ktl/survivors" ] && echo 1 || echo 0)"
  # What the operator meets next. The refusal is the reason the directories are
  # kept, so it has to survive the missing record.
  n_before="$(invocations)"
  run_sut --checkout "$REPO" --task task-bk --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "a SECOND carry is still REFUSED (17) with the record missing" "17" "$RC"
  assert_eq "  and launched nothing further" "$n_before" "$(invocations)"
  rm -rf "$ktl/survivors" "$kcl/survivors" "$ktl" "$kcl"

  # rc=1 — nothing was owned, so nothing was pinned. The ordinary state of a run
  # that never acquired a lease, and it stays SILENT: reporting it would tell the
  # operator about a lease that does not exist.
  mkfix pinnone task-bl claude
  printf 'ignore-term:30' >"$ACTION"
  stub_pin_rc "$REPO" 1 0
  o="$(PATH="$SURVPSDIR:$PATH" "$SUT" --checkout "$REPO" --task task-bl \
        --claude-bin "$FAKEBIN" --timeout 1 --log-dir "$LOGD" 2>&1)"; RC=$?
  assert_eq "rc=1 is still ACTOR_TIMEOUT" "21" "$RC"
  assert_absent "  and says nothing about a pin at all" "PINNED" "$o"
  assert_absent "  and raises no persistence warning" "could not be persisted" "$o"
  assert_absent "  and reports no unrecognised result" "UNRECOGNISED" "$o"

  # An unrecognised code. The library has three today; a fourth added later must
  # not silently arrive as "nothing owned". Unknown is reported as unknown.
  mkfix pinodd task-bm claude
  printf 'ignore-term:30' >"$ACTION"
  stub_pin_rc "$REPO" 3 1
  mtl="$(task_lease_for "$REPO" task-bm)"; mcl="$(checkout_lease_for "$REPO")"
  o="$(PATH="$SURVPSDIR:$PATH" "$SUT" --checkout "$REPO" --task task-bm \
        --claude-bin "$FAKEBIN" --timeout 1 --log-dir "$LOGD" 2>&1)"; RC=$?
  assert_eq "an unrecognised pin result is still ACTOR_TIMEOUT" "21" "$RC"
  assert_contains "  and is reported as unrecognised, with the code" \
    "UNRECOGNISED pin result (3)" "$o"
  assert_contains "  and says the leases are retained and the next run refused" \
    "still refused with exit 17" "$o"
  assert_absent "  and does NOT claim the durable pin succeeded" \
    "BOTH leases are now PINNED" "$o"
  rm -rf "$mtl" "$mcl"

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

section "15. Post-hop classification — one evidence set, one ordered verdict"

  # 15.1 The incident this unit exists for. The state file is uncommitted BEFORE
  # launch and byte-identical afterwards, so nothing about it is the actor's. The
  # launcher used to report exit 25, "Claude edited ... but left it uncommitted",
  # which was simply untrue.
  mkfix dirtypre task-ad claude
  printf '\npre-existing uncommitted edit\n' >>"$STATE"     # dirty before launch
  printf 'dirty-noop' >"$ACTION"
  run_sut --checkout "$REPO" --task task-ad --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "dirty-before + byte-identical is NO_TRANSITION, not a Claude edit" "22" "$RC"
  assert_absent "  does NOT claim Claude changed the file" "Claude changed logs/work-loop" "$o"
  assert_contains "  says the pre-existing dirt is not the actor's" "NOT attributable to this actor" "$o"
  assert_contains "  and the evidence block shows both dirty states" "uncommitted:     before=yes after=yes" "$o"
  assert_contains "  and attributes no allowed change to the hop" "attributable to THIS hop: none" "$o"
  assert_contains "  and the RESULT line agrees" "partial=0" "$o"

  # 15.2 A denial with no repository effect at all.
  mkfix denyclean task-ae claude
  printf 'denied' >"$ACTION"
  run_sut --checkout "$REPO" --task task-ae --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "a denial with no effect is PERMISSION_DENIED (37)" "37" "$RC"
  assert_contains "  names the denied tool" "- Bash — " "$o"
  assert_contains "  names the denied target" "git commit -m handback" "$o"
  assert_contains "  says the repository is unchanged" "the repository is unchanged" "$o"
  assert_contains "  counts the denial on the RESULT line" "denials=1 partial=0" "$o"

  # 15.3 A denial AFTER allowed partial work. Same rule, different evidence: the
  # attributable path must be listed and the "unchanged" claim withdrawn.
  mkfix denypart task-af claude
  printf 'denied-partial' >"$ACTION"
  run_sut --checkout "$REPO" --task task-af --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "a denial after allowed partial work is also 37" "37" "$RC"
  assert_contains "  lists the attributable allowed path" "partial-note.md" "$o"
  assert_contains "  and says the repository is NOT unchanged" "repository is NOT unchanged" "$o"
  assert_contains "  and counts it" "denials=1 partial=1" "$o"
  assert_contains "  names the denied tool and its target" "- Write — logs/work-loop/partial-note.md" "$o"

  # 15.4 Allowed partial work with NO permission evidence is a different
  # classification, and it must still be listed rather than silently dropped —
  # a failing actor used to report nothing about what it had already written.
  mkfix allowpart task-ag claude
  printf 'allowed-partial' >"$ACTION"
  run_sut --checkout "$REPO" --task task-ag --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "allowed partial work + actor failure is ACTOR_FAILED (20)" "20" "$RC"
  assert_absent "  and is NOT classified as a permission denial" "PERMISSION_DENIED" "$o"
  assert_contains "  but still lists the partial path" "partial-note.md" "$o"
  assert_contains "  and separates zero denials from unknown" "denials=0 partial=1" "$o"

  # 15.5 Precedence. A disallowed effect outranks the denial that accompanied it.
  mkfix denyforeign task-ah claude
  printf 'denied-foreign' >"$ACTION"
  run_sut --checkout "$REPO" --task task-ah --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "a disallowed effect outranks a denial (24)" "24" "$RC"
  assert_contains "  classified as the unexpected effect" "UNEXPECTED_EFFECT" "$o"
  assert_contains "  and still shows the denial in the evidence" "DENIAL(S) recorded" "$o"

  # 15.6 A denial that did NOT stop the handback is advisory, not a failure. The
  # turn genuinely moved, so the hop carried — with the denial stated.
  mkfix denycarried task-ai claude
  printf 'denied-carried' >"$ACTION"
  run_sut --checkout "$REPO" --task task-ai --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "a denial that did not block the handback still carries" "0" "$RC"
  assert_contains "  reports CARRIED" "RESULT outcome=CARRIED code=0" "$o"
  assert_contains "  but warns about the denial" "WARNING: the turn moved, but Claude was denied" "$o"
  assert_contains "  and carries the count" "denials=1" "$o"

  # 15.7 Same evidence, same outcome. Pre-existing ALLOWED dirt must not change
  # the verdict and must not be counted as this hop's partial work.
  mkfix denydirt task-aj claude
  printf 'pre-existing\n' >"$REPO/logs/work-loop/preexisting-note.md"   # allowed, uncommitted
  printf 'denied' >"$ACTION"
  run_sut --checkout "$REPO" --task task-aj --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "identical denial evidence gives the identical outcome (37)" "37" "$RC"
  assert_contains "  pre-existing allowed dirt is named separately" "already present before launch" "$o"
  assert_contains "  and is NOT counted as this hop's work" "denials=1 partial=0" "$o"
  assert_contains "  and the repository-unchanged claim still holds for the hop" "the repository is unchanged" "$o"

  # 15.8 Three permission states, not two. A capture with no readable evidence
  # must read as UNKNOWN, never as a clean "no denials".
  mkfix noevid task-ak claude
  printf 'transition:codex' >"$ACTION"                # emits no JSON at all
  run_sut --checkout "$REPO" --task task-ak --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "a hop with no permission evidence still carries" "0" "$RC"
  assert_contains "  reports the evidence as UNAVAILABLE, not as zero" "denials=unavailable" "$o"
  assert_contains "  and says so in words" "NO EVIDENCE" "$o"
  assert_contains "  and warns it is not the same as none" "not the same as 'no denials'" "$o"

  mkfix codexevid task-al codex
  printf 'nocommit:claude' >"$ACTION"
  run_sut --checkout "$REPO" --task task-al --codex-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "a Codex hop carries" "0" "$RC"
  assert_contains "  and reports permission evidence as n/a, not unavailable" "denials=n/a" "$o"

  # 15.9 No recovery path reassigns Claude's commit to anyone else (core § 4).
  mkfix ownership task-am claude
  printf 'nocommit:codex' >"$ACTION"
  run_sut --checkout "$REPO" --task task-am --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "Claude's uncommitted handback still stops (25)" "25" "$RC"
  assert_contains "  and names the ownership rule" "Claude commits its own handback" "$o"
  assert_contains "  and forbids committing on Claude's behalf" "do not ask Codex to" "$o"
  assert_absent "no branch tells the reader to commit the handback" \
    "If the edit is complete, commit it and re-run" "$(cat "$SUT")"

section "16. Actor and nested-actor observation"

  # 16.1 The ordinary attended hop: exactly one top-level actor, and nothing
  # named claude or codex observed beside it. The zero is an OBSERVED zero, and
  # the run output has to say that rather than implying absence.
  mkfix nest0 task-an claude
  printf 'transition:codex' >"$ACTION"
  run_sut --checkout "$REPO" --task task-an --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "a plain hop carries" "0" "$RC"
  assert_contains "  RESULT counts one top-level actor and no observed nested one" \
    "actors=1 nested=0" "$o"
  assert_contains "  the evidence block names the observation, not an absence" \
    "no process named claude or codex was observed" "$o"
  assert_contains "  and says what the observation boundary was" \
    "actor's process group" "$o"
  assert_contains "  and refuses to read the zero as containment" \
    "not proof that none existed" "$o"
  # The run log is the trial's record, so the counts must survive there too.
  assert_contains "  the run log carries the same RESULT line" "actors=1 nested=0" \
    "$(cat "$LOGD"/*.log)"

  # 16.2 The case the field exists for. Two processes named claude and codex run
  # inside the actor's own process group; both must be counted and both named.
  mkfix nest2 task-ao claude
  printf 'nested-actor' >"$ACTION"
  run_sut --checkout "$REPO" --task task-ao --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "a hop with nested processes still carries" "0" "$RC"
  assert_contains "  RESULT reports the observed nested count" "actors=1 nested=2" "$o"
  assert_contains "  the evidence block names the observed claude process" \
    "nested-bin/claude" "$o"
  assert_contains "  and the observed codex process" "nested-bin/codex" "$o"
  assert_contains "  and the run log carries it" "actors=1 nested=2" "$(cat "$LOGD"/*.log)"

  # 16.3 A Codex hop is observed the same way. The boundary is the actor's
  # process group, not which actor happens to be in it.
  mkfix nestcodex task-ap codex
  printf 'nested-nocommit' >"$ACTION"
  run_sut --checkout "$REPO" --task task-ap --codex-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "a Codex hop with nested processes carries" "0" "$RC"
  assert_contains "  and is observed the same way" "actors=1 nested=2" "$o"

  # 16.4 The top-level actor is never its own nested actor. Without the
  # exclusion every Claude hop would report nesting that is only itself, and a
  # field that fires on the normal case tells an operator nothing. The actor
  # here execs into a process genuinely named `claude`, which is what makes the
  # exclusion the thing under test rather than the fixture's naming.
  mkfix nestself task-aq claude
  printf 'become-claude' >"$ACTION"
  run_sut --checkout "$REPO" --task task-aq --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "an actor whose own process is named claude still carries" "0" "$RC"
  assert_contains "  and does not count itself as nested" "actors=1 nested=0" "$o"

  # 16.5 Three states, not two — the same rule the permission evidence follows.
  # A census that cannot run is UNOBSERVED, and reporting it as 0 would turn
  # missing evidence into a clean bill of health.
  mkfix nestnops task-ar claude
  printf 'transition:codex' >"$ACTION"
  o="$(PATH="$NOPSDIR:$PATH" "$SUT" --checkout "$REPO" --task task-ar \
        --claude-bin "$FAKEBIN" --log-dir "$LOGD" 2>&1)"; RC=$?
  assert_eq "a hop whose census cannot run still carries" "0" "$RC"
  assert_contains "  reports the nested count as unobserved, not as zero" \
    "nested=unobserved" "$o"
  assert_contains "  and says so in words" "NO OBSERVATION" "$o"
  assert_contains "  and warns it is not the same as none" \
    "not the same as 'none observed'" "$o"

  # 16.6 Nothing was launched, so there is nothing to have observed. `n/a` is
  # the honest value; a 0 here would claim an observation that never happened.
  mkfix nestdry task-as claude
  run_sut --checkout "$REPO" --task task-as --claude-bin "$FAKEBIN" --dry-run --log-dir "$LOGD"
  assert_eq "dry run validates" "0" "$RC"
  assert_contains "  and reports no actor and no observation" "actors=0 nested=n/a" "$o"
  assert_eq "  and launched nothing" "0" "$(invocations)"

  # 16.7 A refusal before any launch reports the same way.
  mkfix nestrefuse task-at claude
  run_sut --checkout "$REPO" --task task-at --claude-permission-mode bypassPermissions \
          --claude-bin "$FAKEBIN" --log-dir "$LOGD"
  assert_eq "an unauthorised mode is still BAD_USAGE" "10" "$RC"
  assert_contains "  and reports no actor and no observation" "actors=0 nested=n/a" "$o"

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

  section "M1. Strip the explicit --permission-mode from the attended argv"
  mut="$TMPROOT/mutant-permmode.sh"
  sed -e 's/^\( *\)--permission-mode "\$CLAUDE_PERMISSION_MODE" \\$/\1\\/' "$SUT" >"$mut"
  chmod +x "$mut"
  if grep -qF -- '--permission-mode "$CLAUDE_PERMISSION_MODE" \' "$mut"; then
    bad "M1 mutant did not apply" "the launch line did not match"
  elif ! mutant_ok "$mut"; then bad "M1 mutant does not parse" "bad mutation"; else
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
  sed -e 's|^  elif \[ "\$after_turn" = "\$before_turn" \]; then$|  elif false; then|' \
      -e 's|^      \*) fault="transition .*|      *) : ;;|' "$SUT" >"$mut"
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
  sed 's|^  if \[ "\$before_turn" = "claude" \] && \[ "\$after_dirty" -eq 1 \] && \[ "\$after_hash" != "\$before_hash" \]; then$|  if false; then|' "$SUT" >"$mut"
  chmod +x "$mut"
  if ! mutant_ok "$mut"; then bad "M5 mutant does not parse" "bad mutation"; else
    mkfix m5 task-m5 claude
    printf 'nocommit:codex' >"$ACTION"
    run_bin "$mut" --checkout "$REPO" --task task-m5 --claude-bin "$FAKEBIN" --log-dir "$LOGD"
    EXPECT_FAIL=1
    assert_eq "Claude handing back uncommitted stops (25)" "25" "$RC"
    EXPECT_FAIL=0
  fi

  section "M6. Put the task back into the lock key"
  # This mutant restores the pre-fix key — checkout+task — and is therefore the
  # exact defect this unit corrected: the checkout's lock becomes invisible to a
  # carry naming a different task, and two writers enter one working tree.
  mut="$TMPROOT/mutant-lockkey.sh"
  sed -e 's@^\( *\)key=.*shasum -a 256 | cut -c1-16)"$@\1key="$(printf "%s|%s" "$CHECKOUT" "$TASK" | shasum -a 256 | cut -c1-16)"@' \
      "$SUT" >"$mut"
  chmod +x "$mut"
  if ! grep -q 'printf "%s|%s" "\$CHECKOUT" "\$TASK"' "$mut"; then
    bad "M6 mutant did not apply" "the lock-key line did not match"
  elif ! mutant_ok "$mut"; then bad "M6 mutant does not parse" "bad mutation"; else
    mkfix m6 task-m6a claude
    mkstate_in "$REPO" task-m6b claude
    git -C "$REPO" add -A >/dev/null 2>&1
    git -C "$REPO" commit -q -m "second task" >/dev/null 2>&1
    m6argv="$TMPROOT/m6b.argv"; : >"$m6argv"
    m6count="$TMPROOT/m6b.count"; : >"$m6count"
    m6action="$TMPROOT/m6b.action"; printf 'transition:codex' >"$m6action"
    m6fake="$TMPROOT/m6b.actor"
    make_fake_actor "$m6fake" "$m6argv" "$m6count" "$m6action" \
                    "$REPO/logs/work-loop/task-m6b.md"
    m6ld="$(lock_path_for "$REPO")"
    plant_lock "$m6ld" "$$" task-m6a
    run_bin "$mut" --checkout "$REPO" --task task-m6b --claude-bin "$m6fake" --log-dir "$LOGD"
    EXPECT_FAIL=1
    assert_eq "a DIFFERENT task in the same checkout is refused (17)" "17" "$RC"
    assert_eq "  and stopped BEFORE actor launch" "0" "$(wc -c <"$m6count" | tr -d ' ')"
    EXPECT_FAIL=0
    rm -rf "$m6ld"
  fi

  section "M7. Attribute an uncommitted state file without checking the hop changed it"
  # The pre-Unit-2 branch, restored: drop the hash comparison so ANY dirty state
  # file after a Claude hop is blamed on Claude. This is the exact defect — a file
  # already uncommitted at launch and byte-identical afterwards is reported as
  # "Claude changed it".
  mut="$TMPROOT/mutant-attribution.sh"
  sed 's|^  if \[ "\$before_turn" = "claude" \] && \[ "\$after_dirty" -eq 1 \] && \[ "\$after_hash" != "\$before_hash" \]; then$|  if [ "$before_turn" = "claude" ] \&\& [ "$after_dirty" -eq 1 ]; then|' \
      "$SUT" >"$mut"
  chmod +x "$mut"
  if ! mutant_ok "$mut"; then bad "M7 mutant does not parse" "bad mutation"; else
    mkfix m7 task-m7 claude
    printf '\npre-existing uncommitted edit\n' >>"$STATE"
    printf 'dirty-noop' >"$ACTION"
    run_bin "$mut" --checkout "$REPO" --task task-m7 --claude-bin "$FAKEBIN" --log-dir "$LOGD"
    EXPECT_FAIL=1
    assert_eq "dirty-before + byte-identical is NO_TRANSITION, not a Claude edit" "22" "$RC"
    EXPECT_FAIL=0
  fi

  section "M8. Report unreadable permission evidence as 'no denials'"
  # Collapses the three evidence states into two. A hop whose capture carries no
  # readable permission_denials would then read as a clean zero.
  mut="$TMPROOT/mutant-evidence.sh"
  sed 's|^  DENIAL_STATE="unavailable"; DENIALS_JSON=""$|  DENIAL_STATE="empty"; DENIALS_JSON=""|' "$SUT" >"$mut"
  chmod +x "$mut"
  if ! mutant_ok "$mut"; then bad "M8 mutant does not parse" "bad mutation"; else
    mkfix m8 task-m8 claude
    printf 'transition:codex' >"$ACTION"        # carries, but emits no JSON
    run_bin "$mut" --checkout "$REPO" --task task-m8 --claude-bin "$FAKEBIN" --log-dir "$LOGD"
    EXPECT_FAIL=1
    assert_contains "reports the evidence as UNAVAILABLE, not as zero" "denials=unavailable" "$o"
    EXPECT_FAIL=0
  fi

  section "M9. Never classify a recorded denial as a denial"
  mut="$TMPROOT/mutant-denial.sh"
  sed 's|^    DENIAL_STATE="present"$|    DENIAL_STATE="empty"|' "$SUT" >"$mut"
  chmod +x "$mut"
  if ! mutant_ok "$mut"; then bad "M9 mutant does not parse" "bad mutation"; else
    mkfix m9 task-m9 claude
    printf 'denied' >"$ACTION"
    run_bin "$mut" --checkout "$REPO" --task task-m9 --claude-bin "$FAKEBIN" --log-dir "$LOGD"
    EXPECT_FAIL=1
    assert_eq "a denial with no effect is PERMISSION_DENIED (37)" "37" "$RC"
    assert_contains "names the denied tool" "- Bash — " "$o"
    EXPECT_FAIL=0
  fi

  section "M10. Drop --disallowedTools from the Claude launch"
  # The pre-Unit-3 plain shape restored: the flag is simply not passed, so a hop
  # carries no nested-actor rules at all.
  #
  # NOT by emptying CLAUDE_DENY_MANDATORY, which was the first attempt: under
  # `set -u` on bash 3.2 an empty array expansion aborts the launcher, so the
  # assertions "failed" because nothing launched rather than because the rules
  # were missing. A mutant whose failure has the wrong cause proves nothing, and
  # the control assertion below is what keeps this one honest.
  mut="$TMPROOT/mutant-nested.sh"
  sed -e 's|^        --disallowedTools "${deny_all\[@\]}"$||' \
      -e 's|^        --permission-mode "\$CLAUDE_PERMISSION_MODE" \\$|        --permission-mode "$CLAUDE_PERMISSION_MODE"|' \
      "$SUT" >"$mut"
  chmod +x "$mut"
  if grep -qF -- '--disallowedTools "${deny_all[@]}"' "$mut"; then
    bad "M10 mutant did not apply" "the launch line did not match"
  elif ! mutant_ok "$mut"; then bad "M10 mutant does not parse" "bad mutation"; else
    mkfix m10 task-m10 claude
    printf 'transition:codex' >"$ACTION"
    run_bin "$mut" --checkout "$REPO" --task task-m10 --claude-bin "$FAKEBIN" --log-dir "$LOGD"
    EXPECT_FAIL=1
    assert_contains "plain launch requests --disallowedTools at all" "[--disallowedTools]" "$(cat "$ARGVLOG.args")"
    assert_contains "  denies direct Bash launch of claude (colon form)" "[Bash(claude:*)]" "$(cat "$ARGVLOG.args")"
    assert_contains "  denies direct Bash launch of claude (space form)" "[Bash(claude *)]" "$(cat "$ARGVLOG.args")"
    assert_contains "  denies direct Bash launch of codex (colon form)" "[Bash(codex:*)]" "$(cat "$ARGVLOG.args")"
    assert_contains "  denies direct Bash launch of codex (space form)" "[Bash(codex *)]" "$(cat "$ARGVLOG.args")"
    EXPECT_FAIL=0
    # The launch still HAPPENED. Without this, an aborted launcher would score as
    # three proof-hits and the mutant would be measuring the wrong thing.
    assert_contains "M10 control: the hop still launched" "[--permission-mode]" "$(cat "$ARGVLOG.args")"
  fi

  section "M11. Let operator rules replace the mandatory set"
  # The pre-Unit-3 behaviour restored where --claude-deny is supplied: the
  # operator's list becomes the whole list. The mandatory rules vanish while the
  # flag is still present, which is the bypass a plain absence check would miss.
  mut="$TMPROOT/mutant-nested-replace.sh"
  sed 's|^      deny_all=("${CLAUDE_DENY_MANDATORY\[@\]}")$|      deny_all=()|' "$SUT" >"$mut"
  chmod +x "$mut"
  if ! grep -qF '      deny_all=()' "$mut"; then
    bad "M11 mutant did not apply" "the deny_all seed line did not match"
  elif ! mutant_ok "$mut"; then bad "M11 mutant does not parse" "bad mutation"; else
    mkfix m11 task-m11 claude
    printf 'transition:codex' >"$ACTION"
    run_bin "$mut" --checkout "$REPO" --task task-m11 --claude-bin "$FAKEBIN" \
            --claude-deny 'Bash(git push:*)' --claude-deny 'WebFetch' --log-dir "$LOGD"
    EXPECT_FAIL=1
    assert_contains "operator rules do not displace the claude colon rule" "[Bash(claude:*)]" "$(cat "$ARGVLOG.args")"
    assert_contains "operator rules do not displace the claude space rule" "[Bash(claude *)]" "$(cat "$ARGVLOG.args")"
    assert_contains "operator rules do not displace the codex colon rule" "[Bash(codex:*)]" "$(cat "$ARGVLOG.args")"
    assert_contains "operator rules do not displace the codex space rule" "[Bash(codex *)]" "$(cat "$ARGVLOG.args")"
    EXPECT_FAIL=0
    # The operator's own rules DID still arrive — proof the mutant removed the
    # mandatory set specifically, rather than breaking the launch outright.
    assert_contains "M11 control: the operator's rules still arrived" "[WebFetch]" "$(cat "$ARGVLOG.args")"
  fi

  section "M12. Keep only the colon form of each mandatory rule"
  # The state Unit 3 was corrected from. The colon rules still arrive, so a
  # suite that only checked those stays green — which is exactly why the space
  # forms need their own assertions and their own mutant. If which form an
  # installed build honours is unknown, half a set is a guess, not a policy.
  mut="$TMPROOT/mutant-spaceform.sh"
  sed -e "/^  'Bash(claude \*)'$/d" -e "/^  'Bash(codex \*)'$/d" "$SUT" >"$mut"
  chmod +x "$mut"
  if grep -qF "'Bash(claude *)'" "$mut"; then
    bad "M12 mutant did not apply" "the space-form entries did not match"
  elif ! mutant_ok "$mut"; then bad "M12 mutant does not parse" "bad mutation"; else
    mkfix m12 task-m12 claude
    printf 'transition:codex' >"$ACTION"
    run_bin "$mut" --checkout "$REPO" --task task-m12 --claude-bin "$FAKEBIN" --log-dir "$LOGD"
    EXPECT_FAIL=1
    assert_contains "  denies direct Bash launch of claude (space form)" "[Bash(claude *)]" "$(cat "$ARGVLOG.args")"
    assert_contains "  denies direct Bash launch of codex (space form)" "[Bash(codex *)]" "$(cat "$ARGVLOG.args")"
    EXPECT_FAIL=0
    # Controls. The colon forms DID still arrive, so this mutant removed the
    # space forms specifically — and it demonstrates the gap the correction
    # closed: a colon-only launcher passes every colon-form assertion.
    assert_contains "M12 control: the claude colon rule still arrived" "[Bash(claude:*)]" "$(cat "$ARGVLOG.args")"
    assert_contains "M12 control: the codex colon rule still arrived" "[Bash(codex:*)]" "$(cat "$ARGVLOG.args")"
  fi

  # M13-M15 are the smallest set that separates the three ways this unit's
  # mechanism could look implemented and not be: the request never reaching argv,
  # an unauthorised value reaching it, and the widening reaching it unannounced.
  # A broader matrix would re-prove the parser rather than these distinctions.

  section "M13. Hardcode default back into the launch line"
  # The pre-change shape restored: the option parses, the operator sees no error,
  # and the request is silently dropped on the way to argv. This is the failure a
  # test that only checked the exit code would miss entirely.
  mut="$TMPROOT/mutant-pm-hardcoded.sh"
  sed 's|^        --permission-mode "\$CLAUDE_PERMISSION_MODE" \\$|        --permission-mode default \\|' \
      "$SUT" >"$mut"
  chmod +x "$mut"
  if ! grep -qF -- '--permission-mode default \' "$mut"; then
    bad "M13 mutant did not apply" "the launch line did not match"
  elif ! mutant_ok "$mut"; then bad "M13 mutant does not parse" "bad mutation"; else
    mkfix m13 task-m13 claude
    printf 'transition:codex' >"$ACTION"
    run_bin "$mut" --checkout "$REPO" --task task-m13 --claude-bin "$FAKEBIN" \
            --claude-permission-mode acceptEdits --log-dir "$LOGD"
    EXPECT_FAIL=1
    assert_eq "  launches with exactly --permission-mode acceptEdits" "[--permission-mode] [acceptEdits]" \
      "$(grep -A1 -Fx -- '[--permission-mode]' "$ARGVLOG.args" | tr '\n' ' ' | sed 's/ *$//')"
    EXPECT_FAIL=0
    # The hop still launched, so the assertion above failed for the right reason.
    assert_contains "M13 control: the hop still launched" "[--permission-mode]" "$(cat "$ARGVLOG.args")"
  fi

  section "M14. Admit an unauthorised permission mode"
  # The allowlist widened by one entry. bypassPermissions then reaches the child,
  # which is the single outcome the operator's 2026-08-13 decision excluded.
  mut="$TMPROOT/mutant-pm-allowlist.sh"
  sed 's@^  default|acceptEdits) : ;;$@  default|acceptEdits|bypassPermissions) : ;;@' "$SUT" >"$mut"
  chmod +x "$mut"
  if ! grep -qF -- '  default|acceptEdits|bypassPermissions) : ;;' "$mut"; then
    bad "M14 mutant did not apply" "the allowlist line did not match"
  elif ! mutant_ok "$mut"; then bad "M14 mutant does not parse" "bad mutation"; else
    mkfix m14 task-m14 claude
    printf 'transition:codex' >"$ACTION"
    run_bin "$mut" --checkout "$REPO" --task task-m14 --claude-bin "$FAKEBIN" \
            --claude-permission-mode bypassPermissions --log-dir "$LOGD"
    EXPECT_FAIL=1
    assert_eq "unauthorised mode 'bypassPermissions' is BAD_USAGE (10)" "10" "$RC"
    EXPECT_FAIL=0
    # A value outside the widened allowlist is still refused, so the mutant moved
    # exactly one entry rather than removing the check.
    run_bin "$mut" --checkout "$REPO" --task task-m14 --claude-bin "$FAKEBIN" \
            --claude-permission-mode plan --log-dir "$LOGD"
    assert_eq "M14 control: an unrelated mode is still refused" "10" "$RC"
  fi

  section "M15. Widen without announcing the effective allow-path set"
  # The widening happens and the operator is not told which boundary it sits
  # inside. The argv is identical, so only the run-output assertion can catch it.
  mut="$TMPROOT/mutant-pm-silent.sh"
  sed 's@^        say "  effective allow-path set: .*@        :@' "$SUT" >"$mut"
  chmod +x "$mut"
  if grep -qF 'say "  effective allow-path set:' "$mut"; then
    bad "M15 mutant did not apply" "the allow-path evidence line did not match"
  elif ! mutant_ok "$mut"; then bad "M15 mutant does not parse" "bad mutation"; else
    mkfix m15 task-m15 claude
    printf 'transition:codex' >"$ACTION"
    run_bin "$mut" --checkout "$REPO" --task task-m15 --claude-bin "$FAKEBIN" \
            --claude-permission-mode acceptEdits --allow-path '^logs/work-loop/' --log-dir "$LOGD"
    EXPECT_FAIL=1
    assert_contains "  names the effective allow-path set" \
      "effective allow-path set: ^logs/work-loop/" "$o"
    EXPECT_FAIL=0
    # The widening itself still ran and was still announced — the mutant removed
    # the path evidence specifically, not the whole block.
    assert_contains "M15 control: the widening was still announced" \
      "OPERATOR-APPROVED WIDENING" "$o"
  fi

  # M16-M18 separate the three ways the observation could look implemented and
  # not be: never sampling at all, counting the actor as its own nested actor,
  # and reporting a census that never ran as an observed zero.

  section "M16. Never sample the actor's process group"
  # The state before this unit: the launcher tracks a process-group identity and
  # censuses nothing inside it, so a nested actor passes unremarked.
  mut="$TMPROOT/mutant-nocensus.sh"
  sed '/observe_nested "$pid" "$pid" || true/d' "$SUT" >"$mut"
  chmod +x "$mut"
  if grep -qF 'observe_nested "$pid" "$pid" || true' "$mut"; then
    bad "M16 mutant did not apply" "the census call lines did not match"
  elif ! mutant_ok "$mut"; then bad "M16 mutant does not parse" "bad mutation"; else
    mkfix m16 task-m16 claude
    printf 'nested-actor' >"$ACTION"
    run_bin "$mut" --checkout "$REPO" --task task-m16 --claude-bin "$FAKEBIN" --log-dir "$LOGD"
    EXPECT_FAIL=1
    assert_contains "  RESULT reports the observed nested count" "actors=1 nested=2" "$o"
    assert_contains "  the evidence block names the observed claude process" "nested-bin/claude" "$o"
    EXPECT_FAIL=0
    # The hop still ran and still counted its top-level actor, so the assertions
    # above failed because nothing was sampled rather than because nothing ran.
    assert_contains "M16 control: the hop still launched one actor" "actors=1" "$o"
  fi

  section "M17. Count the top-level actor as its own nested actor"
  # Drop the exclusion and every Claude hop reports nesting that is only itself
  # — a field that fires on the normal case tells an operator nothing.
  mut="$TMPROOT/mutant-selfcount.sh"
  sed 's|^    \[ "\$pid" = "\$top" \] && { saw_top=1; continue; }$|    [ "$pid" = "$top" ] \&\& saw_top=1|' \
      "$SUT" >"$mut"
  chmod +x "$mut"
  if grep -qF 'saw_top=1; continue;' "$mut"; then
    bad "M17 mutant did not apply" "the exclusion line did not match"
  elif ! mutant_ok "$mut"; then bad "M17 mutant does not parse" "bad mutation"; else
    mkfix m17 task-m17 claude
    printf 'become-claude' >"$ACTION"
    run_bin "$mut" --checkout "$REPO" --task task-m17 --claude-bin "$FAKEBIN" --log-dir "$LOGD"
    EXPECT_FAIL=1
    assert_contains "  and does not count itself as nested" "actors=1 nested=0" "$o"
    EXPECT_FAIL=0
    assert_contains "M17 control: the hop still launched" "actors=1" "$o"
  fi

  section "M18. Report a census that never ran as an observed zero"
  # Collapses three states into two, the same defect the permission evidence
  # already guards against: unknown becomes a clean bill of health.
  mut="$TMPROOT/mutant-nestedzero.sh"
  sed 's|^  R_NESTED="unobserved"$|  R_NESTED="0"|' "$SUT" >"$mut"
  chmod +x "$mut"
  if grep -qF '  R_NESTED="unobserved"' "$mut"; then
    bad "M18 mutant did not apply" "the unobserved seed line did not match"
  elif ! mutant_ok "$mut"; then bad "M18 mutant does not parse" "bad mutation"; else
    mkfix m18 task-m18 claude
    printf 'transition:codex' >"$ACTION"
    o="$(PATH="$NOPSDIR:$PATH" "$mut" --checkout "$REPO" --task task-m18 \
          --claude-bin "$FAKEBIN" --log-dir "$LOGD" 2>&1)"; RC=$?
    EXPECT_FAIL=1
    assert_contains "  reports the nested count as unobserved, not as zero" "nested=unobserved" "$o"
    assert_contains "  and says so in words" "NO OBSERVATION" "$o"
    EXPECT_FAIL=0
    assert_contains "M18 control: the hop still launched" "actors=1" "$o"
  fi

  section "M19. Drop the approval policy from the Codex launch"
  # The T7 request lives in argv and nowhere else — no RESULT field reports it.
  # Without this mutant, section 5b(f) would only prove that a string appeared
  # in a log the suite itself produced.
  mut="$TMPROOT/mutant-codexapproval.sh"
  sed -e 's/^\( *\)"\$CODEX_BIN" exec --sandbox workspace-write -c approval_policy=never \\$/\1"$CODEX_BIN" exec --sandbox workspace-write \\/' "$SUT" >"$mut"
  chmod +x "$mut"
  if grep -qF -- '-c approval_policy=never \' "$mut"; then
    bad "M19 mutant did not apply" "the codex launch line did not match"
  elif ! mutant_ok "$mut"; then bad "M19 mutant does not parse" "bad mutation"; else
    mkfix m19 task-m19 codex
    printf 'nocommit:claude' >"$ACTION"
    run_bin "$mut" --checkout "$REPO" --task task-m19 --codex-bin "$FAKEBIN" --log-dir "$LOGD"
    EXPECT_FAIL=1
    assert_contains "codex argv requests an approval policy at all" "[-c]" \
      "$(cat "$ARGVLOG.args")"
    assert_eq "  -c is immediately followed by approval_policy=never" \
      "[-c] [approval_policy=never]" \
      "$(grep -A1 -Fx -- '[-c]' "$ARGVLOG.args" | tr '\n' ' ' | sed 's/ *$//')"
    EXPECT_FAIL=0
    assert_eq "M19 control: the hop still launched" "0" "$RC"
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
