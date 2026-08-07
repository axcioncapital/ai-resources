#!/bin/bash
# Work Loop v2 — throwaway task-scoped handoff dispatcher (SPIKE, not production).
#
# Carries ONE exact Work Loop task through routine Codex <-> Claude turns in ONE
# checkout, without operator transport. It launches at most one actor at a time,
# re-reads the authoritative state file after every process exit, and stops
# visibly rather than guessing.
#
# It creates no queue and no shadow state: logs/work-loop/{task-id}.md stays the
# only semantic interface. All controller memory is the exact task id supplied at
# launch, held in this process only.
#
# Scope: single task, single checkout, serial. NOT multi-loop. See
# docs/parallel-sessions-playbook.md § 4 — same-checkout concurrency is unsafe.
#
# Usage:
#   dispatch.sh --checkout <abs-path> --task <task-id> [options]
#
# Options:
#   --max-hops N        absolute hop limit (default 4)
#   --timeout S         per-actor wall-clock seconds (default 900)
#   --deadline S        WHOLE-RUN wall-clock budget in seconds, measured from
#                       startup. Unset by default. This is a real deadline, not a
#                       start gate: before every launch the actor's effective
#                       timeout is clamped to min(--timeout, time remaining), and
#                       a run still going when the clock expires has its actor
#                       terminated through the same path as an interruption.
#                       Exits 29 BUDGET_EXHAUSTED, which is NOT completion.
#   --codex-bin PATH    default /Applications/ChatGPT.app/Contents/Resources/codex
#   --claude-bin PATH   default: `claude` resolved from PATH
#   --allow-path RE     repeatable regex of repo-relative paths actors may change
#   --claude-deny RULE  repeatable. Passed to the Claude child as
#                       --disallowedTools RULE, e.g. 'Bash(git push:*)'.
#                       DEFAULT: none — the child's policy is unchanged from
#                       today. This is plumbing, not a policy: it exists so an
#                       unattended run CAN be given a narrower authority than the
#                       operator's interactive sessions without editing any
#                       settings.json. A deny passed this way beats
#                       bypassPermissions and is scoped to this child alone —
#                       OBSERVED, runs/probe-unattended-authority-2026-08-07.md.
#                       It does NOT buy network isolation: denying WebFetch just
#                       sends the child to curl. See the same record.
#   --log-dir DIR       run evidence directory (default <spike>/runs)
#   --dry-run           validate and route; launch nothing
#   --status            READ-ONLY. Report whether a run is in flight for this
#                       checkout+task, and what the state file says. Acquires no
#                       lock, creates no log, writes nothing at all. Safe to run
#                       against a live run — that is the point of it.
#   --carry-one         COURIER MODE. Launch exactly the actor named by the
#                       current turn:, then stop once the turn has moved in an
#                       allowed direction — exit 0 rather than continuing to the
#                       next actor. Every validation and post-hop check is
#                       unchanged; this is a terminal condition, not a weaker
#                       one. Implies a single hop, so --max-hops is moot.
#   --actor-cmd CMD     TEST SEAM. Replaces the live product launch with CMD.
#                       Marks the run mode=simulated in all evidence so a
#                       simulated pass can never be read as live transport.
#
# Exit codes — 0 is the only success. WHAT it means depends on how you invoked
# this script; the four meanings are spelled out under the table.
#   0   SUCCESS                see the four meanings below — it is not one thing
#   10  BAD_USAGE
#   11  BAD_CHECKOUT
#   12  BAD_TASK_ID            traversal or illegal characters
#   13  STATE_MISSING
#   14  IDENTITY_MISMATCH      filename stem != frontmatter task:
#   15  BAD_TURN               turn: not in {codex, claude, operator}
#   16  FOREIGN_STAGED         something already staged; refuse to sweep it in
#   17  LOCK_HELD              another dispatcher owns this checkout/task
#   18  FOREIGN_UNSTAGED       out-of-allowlist working-tree changes already present
#   19  GIT_HAZARD             index.lock held, or a merge/rebase/cherry-pick in progress
#   20  ACTOR_FAILED           non-zero exit (retried once when nothing changed)
#   21  ACTOR_TIMEOUT
#   22  NO_TRANSITION          state did not move in an allowed direction
#   23  HOP_LIMIT
#   24  UNEXPECTED_EFFECT      out-of-allowlist change, or Codex moved HEAD
#   25  UNCOMMITTED_HANDBACK   Claude handed back without committing the state file
#   26  MALFORMED_TERMINAL     turn: operator, but the file is neither a core § 7
#                              question nor a core § 4 closing record
#   28  INTERRUPTED            SIGINT/SIGTERM. The actor's process group was
#                              terminated and the run stopped. NEVER retried —
#                              the signal may have landed after a partial effect.
#   29  BUDGET_EXHAUSTED       --deadline expired. NOT completion. The state file
#                              and Git are untouched by the stop, so the next run
#                              resumes from them; inspect before re-running,
#                              because a killed actor leaves the same
#                              partial-effect risk as an interruption.
#   30  UNEXPECTED_COMMIT      an actor COMMITTED paths outside the allowlist.
#                              Detection, not prevention — the commit already
#                              happened; the value is stopping rather than
#                              compounding. Distinct from 24, which is the
#                              working-tree case, because the recovery differs.
#
# The five meanings of 0 — do NOT read one as another:
#   --help          printed the header. Nothing was validated, nothing launched.
#   --status        reported what it could read. Nothing was validated beyond
#                   readability, nothing launched, nothing written.
#   --dry-run       validation passed and the actor was named. NO turn was taken.
#   --carry-one     EITHER the turn moved exactly once in an allowed direction,
#                   OR turn: was already operator and nothing was carried. Read
#                   turn: from the state file to tell them apart — a courier does
#                   that anyway, because no screen or exit code is authoritative
#                   over the file (core § 4).
#   loop mode       the state file reached turn: operator. This is the only
#                   invocation for which 0 carries the whole-loop meaning.
#
# (The line above this block used to read "0 is the ONLY success, and it means the
# loop reached turn: operator" — true of loop mode alone, and recorded as a standing
# contradiction in README.md. Corrected 2026-08-06 when --carry-one added a fourth
# meaning and left the old wording actively wrong rather than merely incomplete.)

set -uo pipefail

# The whole-run clock starts HERE — the first statement of the script, before
# argument parsing, checkout canonicalization, lock acquisition or log setup.
#
# It used to start after log setup, which made "measured from startup" false by
# however long those steps took. The skew was small, but a deadline that quietly
# means "startup plus some setup" is the kind of claim this plan exists to stop
# making. Now the budget the operator sets is the budget from the moment they
# launch. (Caught in review, 2026-08-07.)
RUN_START="$(date '+%s')"

SPIKE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CHECKOUT=""
TASK=""
MAX_HOPS=4
ACTOR_TIMEOUT=900
DEADLINE=""
CODEX_BIN="/Applications/ChatGPT.app/Contents/Resources/codex"
CLAUDE_BIN=""
LOG_DIR=""
DRY_RUN=0
STATUS_MODE=0
CARRY_ONE=0
ACTOR_CMD=""
ALLOW_PATHS=()
CLAUDE_DENY=()

# Interruption state. ACTOR_PGID is the process group of the actor currently in
# flight, or empty between hops — the signal handler needs it to reach the whole
# tree, and "empty" is what tells it there is nothing to terminate.
SHUTDOWN=0
ACTOR_PGID=""
CUR_HOP=0
CUR_ACTOR=""

die() { # code, message
  local code="$1"; shift
  printf 'STOP [%s] %s\n' "$code" "$*" >&2
  [ -n "${RUN_LOG:-}" ] && printf 'STOP [%s] %s\n' "$code" "$*" >>"$RUN_LOG"
  release_lock
  exit "$code"
}

say() {
  printf '%s\n' "$*"
  [ -n "${RUN_LOG:-}" ] && printf '%s\n' "$*" >>"$RUN_LOG"
}

# ---------------------------------------------------------------- arguments

while [ $# -gt 0 ]; do
  case "$1" in
    --checkout)    CHECKOUT="${2:-}"; shift 2 ;;
    --task)        TASK="${2:-}"; shift 2 ;;
    --max-hops)    MAX_HOPS="${2:-}"; shift 2 ;;
    --timeout)     ACTOR_TIMEOUT="${2:-}"; shift 2 ;;
    --deadline)    DEADLINE="${2:-}"; shift 2 ;;
    --codex-bin)   CODEX_BIN="${2:-}"; shift 2 ;;
    --claude-bin)  CLAUDE_BIN="${2:-}"; shift 2 ;;
    --allow-path)  ALLOW_PATHS+=("${2:-}"); shift 2 ;;
    --claude-deny) CLAUDE_DENY+=("${2:-}"); shift 2 ;;
    --log-dir)     LOG_DIR="${2:-}"; shift 2 ;;
    --actor-cmd)   ACTOR_CMD="${2:-}"; shift 2 ;;
    --dry-run)     DRY_RUN=1; shift ;;
    --status)      STATUS_MODE=1; shift ;;
    --carry-one)   CARRY_ONE=1; shift ;;
    # Print the whole leading comment block, whatever length it grows to. A fixed
    # line window silently truncated the exit-code list as codes were added.
    -h|--help)     awk 'NR==1{next} /^#/{print; next} {exit}' "${BASH_SOURCE[0]}"; exit 0 ;;
    *)             printf 'STOP [10] unknown argument: %s\n' "$1" >&2; exit 10 ;;
  esac
done

[ -n "$CHECKOUT" ] || { printf 'STOP [10] --checkout is required\n' >&2; exit 10; }
[ -n "$TASK" ]     || { printf 'STOP [10] --task is required\n' >&2; exit 10; }
case "$MAX_HOPS" in ''|*[!0-9]*) printf 'STOP [10] --max-hops must be a positive integer\n' >&2; exit 10 ;; esac
[ "$MAX_HOPS" -ge 1 ] || { printf 'STOP [10] --max-hops must be >= 1\n' >&2; exit 10; }
case "$ACTOR_TIMEOUT" in ''|*[!0-9]*) printf 'STOP [10] --timeout must be a positive integer\n' >&2; exit 10 ;; esac
if [ -n "$DEADLINE" ]; then
  case "$DEADLINE" in ''|*[!0-9]*) printf 'STOP [10] --deadline must be a positive integer (seconds)\n' >&2; exit 10 ;; esac
  [ "$DEADLINE" -ge 1 ] || { printf 'STOP [10] --deadline must be >= 1\n' >&2; exit 10; }
fi

if [ "${#ALLOW_PATHS[@]}" -eq 0 ]; then
  ALLOW_PATHS=('^logs/work-loop/' '^plans/work-loop-v2-v0\.2/handoff-automation-spike/')
fi

# A carry is one hop by definition. Pinning MAX_HOPS makes that true of the loop
# guard as well as of the terminal condition below, so the two cannot disagree if
# one of them is later edited. Set AFTER --max-hops validation, so an explicitly
# malformed --max-hops still fails as usage rather than being silently overwritten.
[ "$CARRY_ONE" -eq 1 ] && MAX_HOPS=1

# --status and --dry-run are both read-only, but they are not the same question
# ("is a run in flight?" versus "what would this launch?") and --dry-run still
# acquires the lock. Silently letting one win would misreport which check ran.
if [ "$STATUS_MODE" -eq 1 ] && [ "$DRY_RUN" -eq 1 ]; then
  printf 'STOP [10] --status and --dry-run are separate read-only modes; pass one\n' >&2; exit 10
fi

MODE="live"
[ -n "$ACTOR_CMD" ] && MODE="simulated"
[ "$DRY_RUN" -eq 1 ] && MODE="dry-run"
[ "$STATUS_MODE" -eq 1 ] && MODE="status"

# ------------------------------------------------- task id and path safety
# Rejected before any path is built, so a hostile id never reaches the filesystem.
case "$TASK" in
  */*|*'\'*|..|.|*..*|"")
    printf 'STOP [12] task id rejected (path traversal or separator): %s\n' "$TASK" >&2; exit 12 ;;
esac
if ! printf '%s' "$TASK" | grep -qE '^[A-Za-z0-9][A-Za-z0-9._-]*$'; then
  printf 'STOP [12] task id rejected (illegal characters): %s\n' "$TASK" >&2; exit 12
fi

[ -d "$CHECKOUT" ] || { printf 'STOP [11] checkout is not a directory: %s\n' "$CHECKOUT" >&2; exit 11; }
CHECKOUT="$(cd "$CHECKOUT" && pwd -P)" || { printf 'STOP [11] cannot canonicalize checkout\n' >&2; exit 11; }
git -C "$CHECKOUT" rev-parse --git-dir >/dev/null 2>&1 \
  || { printf 'STOP [11] not a git checkout: %s\n' "$CHECKOUT" >&2; exit 11; }

STATE_DIR="$CHECKOUT/logs/work-loop"
STATE_FILE="$STATE_DIR/$TASK.md"

# Belt and braces: even after the id checks, the resolved file must sit directly
# inside the state directory. A symlink pointing out of the tree fails here.
if [ -e "$STATE_FILE" ]; then
  RESOLVED_DIR="$(cd "$(dirname "$STATE_FILE")" && pwd -P)"
  [ "$RESOLVED_DIR" = "$(cd "$STATE_DIR" && pwd -P)" ] \
    || { printf 'STOP [12] resolved state file escapes logs/work-loop/\n' >&2; exit 12; }
fi

# ------------------------------------------- state file reading (read-only)
# Defined here rather than below the lock because --status uses them and --status
# runs before any lock is taken. Pure readers; they mutate nothing.

fm_value() { # file key -> value on stdout, empty if absent
  awk -v k="$2" '
    NR==1 { if ($0 != "---") exit; inb=1; next }
    inb && $0 == "---" { exit }
    inb {
      pfx = k ":"
      if (substr($0, 1, length(pfx)) == pfx) {
        v = substr($0, length(pfx) + 1)
        sub(/^[ \t]+/, "", v)
        sub(/[ \t]*#.*$/, "", v)
        sub(/[ \t]+$/, "", v)
        print v
        exit
      }
    }' "$1"
}

file_hash() { shasum -a 256 "$1" 2>/dev/null | cut -d' ' -f1; }

# ------------------------------------------------------------------- lock
LOCK_KEY="$(printf '%s|%s' "$CHECKOUT" "$TASK" | shasum -a 256 | cut -c1-16)"
LOCK_DIR="${TMPDIR:-/tmp}/work-loop-dispatch-$LOCK_KEY.lock"
LOCK_OWNED=0

acquire_lock() {
  if mkdir "$LOCK_DIR" 2>/dev/null; then
    LOCK_OWNED=1
    printf '%s\n' "$$" >"$LOCK_DIR/pid"
  else
    printf 'STOP [17] another dispatcher holds %s (%s)\n' "$TASK" "$LOCK_DIR" >&2
    exit 17
  fi
}
release_lock() {
  [ "$LOCK_OWNED" -eq 1 ] && rm -rf "$LOCK_DIR" 2>/dev/null
  LOCK_OWNED=0
}

# Terminate the actor's PROCESS GROUP, then reap it.
#
# Why the group and not the direct children: `pkill -P` gets one generation, and a
# live Claude hop runs tool subprocesses below that. The 2026-08-07 probe
# (runs/probe-interruption-2026-08-07.md) OBSERVED a grandchild surviving a
# children-only sweep. launch_actor runs each actor under `set -m`, so the actor
# is a process-group leader (pgid == its pid) and `kill -- -PGID` reaches every
# descendant that stayed in that group.
#
# WHAT THIS DOES NOT REACH — state it plainly rather than calling this a "tree
# kill", which it is not. A descendant that leaves the group survives:
#   - anything that calls setsid(2) or otherwise starts its own session;
#   - anything that creates its own process group (a job-control shell);
#   - a process re-parented after a double fork into a different group.
# dispatch.test.sh case 27b asserts this limit rather than papering over it, so it
# is a measured boundary and not an assumption. In practice the actors here
# (`claude -p`, `codex exec`) keep their children in-group, which is why the group
# kill is sufficient TODAY — not why it is sufficient in general.
#
# TERM first, then KILL after a grace period, because an actor that can exit
# cleanly should be allowed to. Callers: the per-actor timeout, the deadline, and
# the signal handler — one sweep, three callers, so they cannot drift apart.
#
# GRACE_SECS is load-bearing for the deadline's accuracy: it is the upper bound on
# how far past its budget a terminated run can extend. Named so the arithmetic can
# be quoted rather than rediscovered.
TERM_GRACE_SECS=5
terminate_actor_group() { # pgid
  local pgid="${1:-}"
  [ -n "$pgid" ] || return 0
  kill -TERM -- "-$pgid" 2>/dev/null
  local waited=0
  while kill -0 -- "-$pgid" 2>/dev/null && [ "$waited" -lt "$TERM_GRACE_SECS" ]; do
    sleep 1
    waited=$((waited + 1))
  done
  kill -KILL -- "-$pgid" 2>/dev/null
  return 0
}

# SIGINT / SIGTERM.
#
# The handler this replaces was `trap 'release_lock' EXIT INT TERM` — a handler
# that never calls exit. Bash returns control to the interrupted point, so its
# only lasting effect was to DELETE the lock while the run carried on: the signal
# did not stop the run, it unlocked it, admitting a second dispatcher onto the
# same state file. All of that is OBSERVED, not reasoned —
# runs/probe-interruption-2026-08-07.md.
#
# The shutdown flag is belt and braces. This handler exits, so the loop should
# never see it; if a future edit ever returns from here instead, the flag still
# stops another actor being launched.
on_signal() { # signal name
  local sig="$1"
  SHUTDOWN=1
  trap '' INT TERM   # a second signal must not re-enter mid-teardown

  local where="between hops"
  [ -n "$CUR_ACTOR" ] && where="during hop $CUR_HOP (actor '$CUR_ACTOR')"

  printf 'STOP [28] interrupted by SIG%s %s — task %s\n' "$sig" "$where" "$TASK" >&2
  [ -n "${RUN_LOG:-}" ] && printf 'STOP [28] interrupted by SIG%s %s — task %s\n' "$sig" "$where" "$TASK" >>"$RUN_LOG"

  if [ -n "$ACTOR_PGID" ]; then
    printf '  terminating actor process group %s\n' "$ACTOR_PGID" >&2
    [ -n "${RUN_LOG:-}" ] && printf '  terminating actor process group %s\n' "$ACTOR_PGID" >>"$RUN_LOG"
    terminate_actor_group "$ACTOR_PGID"
  fi

  # An interrupted actor is NEVER retried and this run never resumes: the signal
  # may have landed after an effect nobody observed. The state file and Git are
  # the truth, and they are where the operator has to look.
  local msg="  the actor was killed mid-hop; it may have left a partial effect. Nothing is retried.
  Recoverable next action: read $STATE_FILE and \`git -C $CHECKOUT status\`, decide what the
  hop actually completed, then re-run this dispatcher. Run evidence: ${RUN_LOG:-<none>}"
  printf '%s\n' "$msg" >&2
  [ -n "${RUN_LOG:-}" ] && printf '%s\n' "$msg" >>"$RUN_LOG"

  release_lock
  exit 28
}

trap 'release_lock' EXIT
trap 'on_signal INT'  INT
trap 'on_signal TERM' TERM

# --status is read-only by contract: it must not take the lock, because its whole
# purpose is to be safe to run while another dispatcher holds it.
[ "$STATUS_MODE" -eq 1 ] || acquire_lock

# ----------------------------------------------------------------- --status
# Answers "is it still going?" without touching anything: no lock, no log dir, no
# run log, no state-file write. Every command below reads.
#
# It also gives the skill rule — once you have launched a run, the state file is
# not yours until it exits — something to CHECK rather than something to
# remember. The lock stops a second dispatcher (exit 17); it does not stop the
# parent Codex task editing the file by hand, and this is how that gets noticed.
if [ "$STATUS_MODE" -eq 1 ]; then
  printf 'status: task=%s\n' "$TASK"
  printf 'checkout=%s\n' "$CHECKOUT"

  if [ -d "$LOCK_DIR" ]; then
    st_pid="$(cat "$LOCK_DIR/pid" 2>/dev/null)"
    if [ -n "$st_pid" ] && kill -0 "$st_pid" 2>/dev/null; then
      printf 'run: IN FLIGHT — dispatcher pid %s holds %s\n' "$st_pid" "$LOCK_DIR"
      printf '     do not edit the state file by hand until it exits.\n'
      printf '     to stop it: kill -TERM %s   (it terminates the actor and exits 28)\n' "$st_pid"
    else
      printf 'run: STALE LOCK — %s exists but pid %s is not running.\n' "$LOCK_DIR" "${st_pid:-<unreadable>}"
      printf '     a dispatcher died without releasing it. Remove the directory to unblock: rm -rf %s\n' "$LOCK_DIR"
    fi
  else
    printf 'run: none in flight (no lock at %s)\n' "$LOCK_DIR"
  fi

  if [ -f "$STATE_FILE" ] && [ -r "$STATE_FILE" ]; then
    printf 'state: %s\n' "$STATE_FILE"
    printf '  turn=%s  task=%s  sha256=%s\n' \
      "$(fm_value "$STATE_FILE" turn)" "$(fm_value "$STATE_FILE" task)" "$(file_hash "$STATE_FILE")"
    if [ -n "$(git -C "$CHECKOUT" status --porcelain -- "logs/work-loop/$TASK.md" 2>/dev/null)" ]; then
      printf '  uncommitted: yes (expected mid-run when turn: claude — Codex writes, Claude commits)\n'
    else
      printf '  uncommitted: no\n'
    fi
  else
    printf 'state: MISSING or unreadable at %s\n' "$STATE_FILE"
  fi

  printf 'head=%s branch=%s\n' \
    "$(git -C "$CHECKOUT" rev-parse HEAD 2>/dev/null)" \
    "$(git -C "$CHECKOUT" rev-parse --abbrev-ref HEAD 2>/dev/null)"

  st_logdir="$LOG_DIR"; [ -n "$st_logdir" ] || st_logdir="$SPIKE_DIR/runs"
  st_last="$(ls -t "$st_logdir"/*-"$TASK".log 2>/dev/null | head -1)"
  if [ -n "$st_last" ]; then
    printf 'logs: %s\n' "$st_last"
    st_hop="$(grep -E '^hop=[0-9]+ actor=' "$st_last" 2>/dev/null | tail -1)"
    [ -n "$st_hop" ] && printf '  last hop line: %s\n' "$st_hop"
    st_stop="$(grep -E '^STOP \[' "$st_last" 2>/dev/null | tail -1)"
    [ -n "$st_stop" ] && printf '  last stop line: %s\n' "$st_stop"
  else
    printf 'logs: no run log for this task under %s\n' "$st_logdir"
  fi

  printf 'status is read-only. It launched nothing and wrote nothing. Read %s for the truth (core § 4).\n' "$STATE_FILE"
  exit 0
fi

# ------------------------------------------------------------ run evidence
[ -n "$LOG_DIR" ] || LOG_DIR="$SPIKE_DIR/runs"
mkdir -p "$LOG_DIR" || { printf 'STOP [10] cannot create log dir\n' >&2; exit 10; }
# The dispatcher's own evidence directory is not "foreign work". When --log-dir
# points inside the checkout, the run log this process is about to write would
# otherwise register as an out-of-allowlist change made by the dispatcher itself,
# and the pre-hop gate below would stop on it.
LOG_DIR_ABS="$(cd "$LOG_DIR" && pwd -P)" || { printf 'STOP [10] cannot canonicalize log dir\n' >&2; exit 10; }
if [ "$LOG_DIR_ABS" != "$CHECKOUT" ] && [ "${LOG_DIR_ABS#"$CHECKOUT"/}" != "$LOG_DIR_ABS" ]; then
  LOG_REL="${LOG_DIR_ABS#"$CHECKOUT"/}"
  ALLOW_PATHS+=("^$(printf '%s' "$LOG_REL" | sed 's|[][\.*^$]|\\&|g')/")
fi

RUN_ID="$(date '+%Y%m%dT%H%M%S')-$TASK"
RUN_LOG="$LOG_DIR/$RUN_ID.log"
: >"$RUN_LOG"

# RUN_START is captured at the top of the script (see there). DEADLINE_AT empty
# means no deadline was asked for.
DEADLINE_AT=""
[ -n "$DEADLINE" ] && DEADLINE_AT=$(( RUN_START + DEADLINE ))

say "run=$RUN_ID mode=$MODE task=$TASK"
say "checkout=$CHECKOUT"
say "state=$STATE_FILE"
say "max_hops=$MAX_HOPS timeout=${ACTOR_TIMEOUT}s carry_one=$CARRY_ONE"
if [ -n "$DEADLINE_AT" ]; then
  say "deadline=${DEADLINE}s (expires $(date -r "$DEADLINE_AT" '+%Y-%m-%dT%H:%M:%S' 2>/dev/null || printf 'epoch %s' "$DEADLINE_AT"))"
else
  # Worth saying out loud. Without a deadline the real upper bound is
  # max_hops * timeout, which is where the plan's three-hour surprise came from.
  say "deadline=none — upper bound is max_hops * timeout = $(( MAX_HOPS * ACTOR_TIMEOUT ))s"
fi
say "allow_paths=${ALLOW_PATHS[*]}"
if [ "${#CLAUDE_DENY[@]}" -gt 0 ]; then
  say "claude_deny=${CLAUDE_DENY[*]}"
else
  # Said out loud because it is the risk the operator walks away on. A deny here
  # would beat bypassPermissions; none is set, so the child holds the checkout's
  # normal authority. Network is NOT coverable this way in any case —
  # runs/probe-unattended-authority-2026-08-07.md.
  say "claude_deny=none — the Claude child holds this checkout's normal authority"
fi

# ------------------------------------------------------- state file reading
# Read-only throughout. This dispatcher never writes the state file; only the
# actors do (core § 4 — Claude commits, Codex writes the brief).
# fm_value() and file_hash() are defined above the lock section, because --status
# needs them before a lock exists.

validate_state() { # sets ST_TURN; dies on any failure. Never mutates.
  [ -f "$STATE_FILE" ] || die 13 "state file missing: $STATE_FILE"
  [ -r "$STATE_FILE" ] || die 13 "state file unreadable: $STATE_FILE"

  local declared
  declared="$(fm_value "$STATE_FILE" task)"
  [ -n "$declared" ] || die 14 "no readable 'task:' frontmatter in $STATE_FILE"
  if [ "$declared" != "$TASK" ]; then
    die 14 "identity mismatch — filename says '$TASK', frontmatter task: says '$declared'"
  fi

  ST_TURN="$(fm_value "$STATE_FILE" turn)"
  case "$ST_TURN" in
    codex|claude|operator) : ;;
    "") die 15 "no readable 'turn:' frontmatter in $STATE_FILE" ;;
    *)  die 15 "turn: '$ST_TURN' is not one of codex | claude | operator" ;;
  esac
}

# --------------------------------------------------------- repository state

git_head() { git -C "$CHECKOUT" rev-parse HEAD 2>/dev/null; }

# Working-tree lines NOT covered by the allowlist. Any change here during an
# actor run is an unexpected repository effect.
foreign_worktree() {
  local line p
  git -C "$CHECKOUT" status --porcelain 2>/dev/null | while IFS= read -r line; do
    p="${line:3}"
    p="${p%\"}"; p="${p#\"}"
    local allowed=0 re
    for re in "${ALLOW_PATHS[@]}"; do
      if printf '%s' "$p" | grep -qE "$re"; then allowed=1; break; fi
    done
    [ "$allowed" -eq 0 ] && printf '%s\n' "$line"
  done | sort
}

staged_paths() { git -C "$CHECKOUT" diff --cached --name-only 2>/dev/null | sort; }

# Paths an actor COMMITTED between two HEADs that the allowlist does not cover.
#
# This closes the gap the investigation found and then accepted: foreign_worktree()
# reads `git status --porcelain`, and Claude commits its work each hop, so a clean
# tree passes the guard no matter what went into the commit. Only stray
# *uncommitted* files ever tripped it.
#
# DETECTION, NOT PREVENTION. The commit has already happened by the time this
# runs; the value is stopping rather than compounding it over the next six hops of
# a run nobody is watching.
#
# The honest cost: this is only as good as --allow-path. The allowlist has to
# describe what the UNIT may legitimately touch, which makes it a per-task input
# Codex derives when it writes the brief. Too narrow and correct work gets a false
# stop; too wide and this check means nothing.
committed_foreign() { # before-head after-head
  local before="$1" after="$2" p re allowed
  [ -n "$before" ] && [ -n "$after" ] || return 0
  [ "$before" = "$after" ] && return 0
  git -C "$CHECKOUT" diff --name-only "$before" "$after" 2>/dev/null | while IFS= read -r p; do
    [ -n "$p" ] || continue
    allowed=0
    for re in "${ALLOW_PATHS[@]}"; do
      if printf '%s' "$p" | grep -qE "$re"; then allowed=1; break; fi
    done
    [ "$allowed" -eq 0 ] && printf '%s\n' "$p"
  done | sort
}

# Is the state file itself uncommitted right now?
#
# This is deliberately asymmetric, because the two sides differ (core § 4):
# Codex writes the file and never runs git, so an uncommitted file with
# turn: claude is the *expected* handoff. Claude commits, so an uncommitted file
# after a Claude hop means the hop died between editing and committing — the
# partial-side-effect case the investigation says must stop for inspection
# rather than be retried blind.
state_dirty() {
  [ -n "$(git -C "$CHECKOUT" status --porcelain -- "logs/work-loop/$TASK.md" 2>/dev/null)" ]
}

# Repository conditions an actor must never be launched on top of, because a
# second writer compounds them into something no automated step can unpick.
# Emitted one per line, empty when the checkout is safe to work in.
#
# index.lock is included deliberately: it means another Git process is mid-write
# in this checkout right now. Launching an actor that will itself run Git turns a
# transient lock into two racing writers.
git_hazards() {
  local gd
  gd="$(git -C "$CHECKOUT" rev-parse --absolute-git-dir 2>/dev/null)" || return 0
  [ -e "$gd/index.lock" ]        && printf 'a Git index.lock is held (%s)\n' "$gd/index.lock"
  [ -e "$gd/MERGE_HEAD" ]        && printf 'a merge is in progress (MERGE_HEAD)\n'
  [ -d "$gd/rebase-merge" ]      && printf 'a rebase is in progress (rebase-merge)\n'
  [ -d "$gd/rebase-apply" ]      && printf 'a rebase or am is in progress (rebase-apply)\n'
  [ -e "$gd/CHERRY_PICK_HEAD" ]  && printf 'a cherry-pick is in progress (CHERRY_PICK_HEAD)\n'
  [ -e "$gd/REVERT_HEAD" ]       && printf 'a revert is in progress (REVERT_HEAD)\n'
  return 0
}

# Is this file a core § 4 closing record? Read-only.
#
# The absence of ## Blocker and ## Next action is NECESSARY for a closing record
# and nowhere near SUFFICIENT: a Claude hop that died after deleting the active
# fields and before writing the record leaves a file with neither section and no
# closing record either. Classifying that as "closed" is the seam this checks.
#
# What is enforced: the heading sequence is EXACTLY core § 4's four, once each, in
# that order, with nothing else surviving. The comparison is against the literal
# sequence, so it settles presence, order, duplication and extras in one test —
# an earlier version piped through `sort -u`, which silently accepted a record
# with the four sections shuffled or one of them written twice.
#
# What is deliberately NOT enforced: section contents. Those are the actors'
# business, not the dispatcher's, and validating prose is the general state
# validation this must not become. Anything unrecognised stops for inspection
# rather than being labelled either way.
closing_record_ok() {
  local heads
  heads="$(grep -E '^## ' "$STATE_FILE" 2>/dev/null | sed 's/[[:space:]]*$//')"
  [ "$heads" = "$(printf '## Outcome\n## Decisions that matter\n## Evidence\n## Accepted limitations')" ]
}

# The state file's operator-facing content, for the stop message. Read-only.
# Bounded so a long brief cannot flood the run log.
operator_question() {
  awk '
    /^## (Blocker|Next action)$/ { keep=1; print; next }
    /^## / { keep=0 }
    keep && n < 24 { print; n++ }
  ' "$STATE_FILE" 2>/dev/null
}

# -------------------------------------------------------------- actor launch

# Wall-clock timeout without timeout(1) — not installed on this machine.
# Runs the command in the background, polls, escalates TERM then KILL, and also
# sweeps direct children so a wrapper does not strand the real process.
#
# The deadline is wall-clock, not a count of poll iterations. Counting
# iterations drifts badly: each pass costs `sleep 1` PLUS the polling work, so
# the counter runs slower than real time and the timeout silently becomes a
# lower bound. The 2026-08-05 live run showed the size of that drift — a hop
# logged duration=420s against a --timeout of 420 and still exited 0.
# `set -m` before backgrounding is what makes the actor a process-group leader
# (pgid == its own pid, distinct from this script's). Without it the actor shares
# the dispatcher's group, and neither the timeout below nor the signal handler can
# reach its descendants — OBSERVED, runs/probe-interruption-2026-08-07.md, where a
# grandchild outlived a sweep that only reached direct children.
#
# ACTOR_PGID is published to the global so on_signal() can reach the tree from
# outside this function, and cleared on the way out so a signal arriving between
# hops does not try to kill a group that has already gone.
run_bounded() { # timeout, logfile, cmd...
  local limit="$1"; shift
  local out="$1"; shift
  local pid start rc

  set -m
  "$@" >>"$out" 2>&1 &
  pid=$!
  set +m

  ACTOR_PGID="$pid"
  start="$(date '+%s')"

  while kill -0 "$pid" 2>/dev/null; do
    if [ "$(( $(date '+%s') - start ))" -ge "$limit" ]; then
      terminate_actor_group "$pid"
      wait "$pid" 2>/dev/null
      ACTOR_PGID=""
      return 124
    fi
    # 1s poll. This is also the worst-case latency between an operator's
    # `kill -TERM` and the handler running, because a trap fires between
    # commands and `sleep` is the command it interrupts.
    sleep 1
  done

  wait "$pid"; rc=$?
  ACTOR_PGID=""
  return "$rc"
}

codex_prompt() {
  cat <<EOF
Use the \$work-loop-v2 skill.

The task is exactly: $TASK
Its state file is exactly: logs/work-loop/$TASK.md

Do not scan logs/work-loop/ for a candidate task and do not act on any other
file in that directory — several unrelated fixtures live there. Read that one
file, take your turn on it, and set turn: for whoever moves next.

You do not run git. Claude commits.
EOF
}

# Seconds left on the whole-run clock. Prints a very large number when no
# deadline was set, so callers can use min() unconditionally without branching.
remaining_seconds() {
  if [ -z "$DEADLINE_AT" ]; then printf '%s' 2147483647; return 0; fi
  local left=$(( DEADLINE_AT - $(date '+%s') ))
  [ "$left" -lt 0 ] && left=0
  printf '%s' "$left"
}

# The clamp that makes --deadline a deadline rather than a start gate.
#
# v0.1 only refused to START an actor past the deadline, which is not a bound: an
# actor launched at minute 39 with a 900s timeout runs to minute 54. Clamping the
# per-actor timeout to whatever is left bounds the overrun.
#
# THE HONEST BOUND, since a deadline is only worth what its worst case is:
#
#   overrun <= 1s (poll interval) + TERM_GRACE_SECS (TERM->KILL) + reaping
#
# — about 6 seconds with the current grace of 5. It is NOT "the poll interval",
# which is what this comment claimed before review on 2026-08-07. A run given
# --deadline 2400 can therefore end at roughly 2406s, never at 2400s exactly, and
# never at 2400 + --timeout. Case 28 asserts the arithmetic rather than a round
# number, so tightening the grace tightens the test with it.
effective_timeout() {
  local left; left="$(remaining_seconds)"
  if [ "$left" -lt "$ACTOR_TIMEOUT" ]; then printf '%s' "$left"; else printf '%s' "$ACTOR_TIMEOUT"; fi
}

launch_actor() { # actor, hop, effective-timeout -> exit status of the launch
  local actor="$1" hop="$2" limit="$3"
  local out="$LOG_DIR/$RUN_ID.hop$hop.$actor.out"
  : >"$out"

  if [ -n "$ACTOR_CMD" ]; then
    say "  launch: mode=simulated timeout=${limit}s cmd=$ACTOR_CMD"
    WL_ACTOR="$actor" WL_TASK="$TASK" WL_CHECKOUT="$CHECKOUT" \
    WL_STATE_FILE="$STATE_FILE" WL_HOP="$hop" \
      run_bounded "$limit" "$out" bash -c "$ACTOR_CMD"
    return $?
  fi

  case "$actor" in
    codex)
      [ -x "$CODEX_BIN" ] || die 20 "codex binary not executable: $CODEX_BIN"
      local cv; cv="$("$CODEX_BIN" --version 2>&1 | head -1)"
      say "  launch: mode=live actor=codex timeout=${limit}s bin=$CODEX_BIN version=$cv"
      say "  cmd: codex exec --sandbox workspace-write -C <checkout> --json <prompt>"
      run_bounded "$limit" "$out" \
        "$CODEX_BIN" exec --sandbox workspace-write -C "$CHECKOUT" --json "$(codex_prompt)"
      return $?
      ;;
    claude)
      local cb="$CLAUDE_BIN"
      [ -n "$cb" ] || cb="$(command -v claude 2>/dev/null)"
      [ -n "$cb" ] && [ -x "$cb" ] || die 20 "claude binary not resolvable"
      local vv; vv="$("$cb" --version 2>&1 | head -1)"
      say "  launch: mode=live actor=claude timeout=${limit}s bin=$cb version=$vv"
      # No --dangerously-skip-permissions. The project's own settings.json
      # already declares defaultMode: bypassPermissions; the child inherits the
      # project's normal policy and this dispatcher widens nothing.
      #
      # --claude-deny NARROWS it, for this child only, and only when asked for.
      # With no --claude-deny the command below is byte-for-byte what it always
      # was, so the unattended authority question stays the operator's to answer
      # rather than being answered by a default nobody chose.
      # Deliberately NOT `( cd ... && run_bounded ... )`. A subshell would confine
      # run_bounded's assignment to ACTOR_PGID, leaving the signal handler with
      # nothing to terminate on exactly the hops that matter most — the live
      # Claude ones. cd and restore instead.
      local prev_pwd="$PWD" rc_claude
      cd "$CHECKOUT" || die 11 "cannot enter checkout: $CHECKOUT"
      if [ "${#CLAUDE_DENY[@]}" -gt 0 ]; then
        say "  cmd: claude -p '/work-loop-v2 $TASK' --output-format json --disallowedTools ${CLAUDE_DENY[*]} (cwd=<checkout>)"
        run_bounded "$limit" "$out" "$cb" -p "/work-loop-v2 $TASK" --output-format json \
          --disallowedTools "${CLAUDE_DENY[@]}"
      else
        say "  cmd: claude -p '/work-loop-v2 $TASK' --output-format json (cwd=<checkout>)"
        run_bounded "$limit" "$out" "$cb" -p "/work-loop-v2 $TASK" --output-format json
      fi
      rc_claude=$?
      cd "$prev_pwd" || true
      return "$rc_claude"
      ;;
    *) die 15 "cannot launch actor '$actor'" ;;
  esac
}

# ------------------------------------------------------------------ the loop

validate_state
say "initial: turn=$ST_TURN sha256=$(file_hash "$STATE_FILE") head=$(git_head)"

# Restart safety. Truth comes from the file and Git, never from an old in-memory
# turn — this process has no memory beyond the task id it was given.
if state_dirty; then
  case "$ST_TURN" in
    claude)
      say "note: the state file is uncommitted with turn: claude — the expected Codex handoff (Codex never runs git)." ;;
    codex|operator)
      die 25 "the state file is uncommitted with turn: $ST_TURN — Claude commits, so a previous run died between editing and committing, or its commit was refused."$'\n'"Recoverable next action: read \`git diff -- logs/work-loop/$TASK.md\`. If the edit is complete, commit it and re-run this dispatcher; if it is partial, discard it and re-run." ;;
  esac
fi

if [ "$DRY_RUN" -eq 1 ]; then
  if [ "$CARRY_ONE" -eq 1 ]; then
    say "dry-run: --carry-one would launch actor '$ST_TURN' for task '$TASK' and stop after that one hop; launching nothing."
  else
    say "dry-run: would launch actor '$ST_TURN' for task '$TASK'; launching nothing."
  fi
  # Dry-run inspects; it never launches, so it reports hazards instead of failing
  # on them. Loop mode stops on the same conditions before every hop.
  dr_haz="$(git_hazards)"
  [ -n "$dr_haz" ] && say "dry-run: repository hazards present — loop mode would stop:"$'\n'"$dr_haz"
  dr_foreign="$(foreign_worktree)"
  [ -n "$dr_foreign" ] && say "dry-run: out-of-allowlist working-tree changes present — loop mode would stop:"$'\n'"$dr_foreign"
  [ "$ST_TURN" = "operator" ] && say "dry-run: turn is operator — automation is terminal here."
  release_lock
  exit 0
fi

hop=0
while :; do
  validate_state

  if [ "$ST_TURN" = "operator" ]; then
    say "hop=$hop turn=operator — stopping for the operator (core § 7). No further launches."
    # turn: operator has two causes and they are not the same message. A core § 7
    # question leaves `## Blocker` / `## Next action` in place; a core § 4 close
    # deletes them, so operator_question() comes back empty. Announcing an
    # UNANSWERED question above an empty block asserts a question that does not
    # exist — measured on the 2026-08-05 parallel proof, where both tasks reached
    # turn: operator by closing.
    op_q="$(operator_question)"
    if [ -n "$op_q" ]; then
      say "The question below is UNANSWERED. Neither model nor this dispatcher answered it,"
      say "and nothing here is a decision — the operator owns it (core § 7)."
      say "--- state file, as the actors left it ---"
      say "$op_q"
      say "--- end ---"
    elif closing_record_ok; then
      say "The task is CLOSED: the state file carries the core § 4 closing record and"
      say "nothing else — ## Outcome, ## Decisions that matter, ## Evidence and"
      say "## Accepted limitations. There is no unanswered question here."
      say "The closing record is at $STATE_FILE."
    else
      # Neither shape. Saying "closed" here would be a guess dressed as a verdict,
      # so the run stops visibly instead — still with no further actor launch,
      # because turn: operator is terminal for automation whatever the file says.
      die 26 "turn: operator, but $STATE_FILE is neither a core § 7 question (no ## Blocker, no ## Next action) nor a core § 4 closing record (its headings are: $(grep -E '^## ' "$STATE_FILE" 2>/dev/null | tr '\n' ' ' | sed 's/ *$//'))."$'\n'"Recoverable next action: read the file. If a hop died mid-write, restore or complete it, then re-run this dispatcher. No actor was launched."
    fi
    release_lock
    exit 0
  fi

  # Belt and braces. on_signal() exits, so this should be unreachable; it is here
  # so that if a later edit ever makes the handler return instead, the run still
  # cannot launch another actor after the operator asked it to stop.
  if [ "$SHUTDOWN" -eq 1 ]; then
    die 28 "shutdown requested — refusing to launch another actor (task '$TASK', after $hop hop(s))"
  fi

  if [ "$hop" -ge "$MAX_HOPS" ]; then
    die 23 "hop limit reached ($MAX_HOPS) with turn still '$ST_TURN' — stopping rather than continuing"
  fi

  # Hazards are checked before every hop, not once at startup, because a restart
  # re-enters here and because the checkout can change between hops.
  hazards="$(git_hazards)"
  if [ -n "$hazards" ]; then
    die 19 "the checkout is in a hazardous Git state before launching $ST_TURN — task '$TASK':"$'\n'"$hazards"$'\n'"Recoverable next action: finish or abort the operation above, then re-run this dispatcher."
  fi

  # Foreign staged state stops the spike rather than being swept into a commit.
  staged="$(staged_paths)"
  if [ -n "$staged" ]; then
    die 16 "paths already staged before launching $ST_TURN:"$'\n'"$staged"
  fi

  before_foreign="$(foreign_worktree)"

  # Out-of-allowlist working-tree changes that were ALREADY there. The before/after
  # delta below cannot see these: it compares two snapshots that both contain them,
  # so pre-existing foreign work used to pass straight through. The allowlist keeps
  # the expected uncommitted Codex state-file handoff out of this set.
  if [ -n "$before_foreign" ]; then
    die 18 "out-of-allowlist working-tree changes are already present before launching $ST_TURN — task '$TASK':"$'\n'"$before_foreign"$'\n'"Recoverable next action: commit, stash or revert the paths above, then re-run this dispatcher."
  fi
  before_hash="$(file_hash "$STATE_FILE")"
  before_turn="$ST_TURN"
  before_head="$(git_head)"

  # The whole-run clock, checked before the launch rather than only at startup.
  # An expired budget stops here with its own code: a run that ran out of time is
  # resumable and unfinished, and reporting it as 0 would be the single most
  # misleading thing this dispatcher could do to someone who has just walked back
  # in expecting either finished work or a question.
  if [ -n "$DEADLINE_AT" ] && [ "$(remaining_seconds)" -le 0 ]; then
    die 29 "budget exhausted — the ${DEADLINE}s deadline expired with turn still '$before_turn' after $hop hop(s). THIS IS NOT COMPLETION."$'\n'"The state file and Git are untouched by this stop, so the work is resumable: re-run this dispatcher to continue from $STATE_FILE."
  fi
  eff_timeout="$(effective_timeout)"

  hop=$((hop + 1))
  CUR_HOP="$hop"; CUR_ACTOR="$before_turn"
  say ""
  say "hop=$hop actor=$before_turn"
  say "  before: sha256=$before_hash turn=$before_turn head=$before_head"
  if [ -n "$DEADLINE_AT" ]; then
    say "  budget: $(remaining_seconds)s left of ${DEADLINE}s; actor timeout clamped to ${eff_timeout}s"
  fi

  before_dirty=0; state_dirty && before_dirty=1

  started="$(date '+%s')"
  launch_actor "$before_turn" "$hop" "$eff_timeout"
  rc=$?
  duration=$(( $(date '+%s') - started ))

  # A 124 means run_bounded hit the limit it was given. WHICH limit that was
  # decides the exit code, and they are not the same event: 21 is "this actor is
  # stuck", 29 is "the run is out of time". Conflating them would tell the
  # operator to inspect one hop when the real news is that the budget is gone.
  if [ "$rc" -eq 124 ]; then
    if [ -n "$DEADLINE_AT" ] && [ "$(remaining_seconds)" -le 0 ]; then
      die 29 "budget exhausted — the ${DEADLINE}s deadline expired during hop $hop and actor '$before_turn' was terminated. THIS IS NOT COMPLETION."$'\n'"A killed actor carries the same partial-effect risk as an interruption: it is NOT retried."$'\n'"Recoverable next action: read $STATE_FILE and \`git -C $CHECKOUT status\` to see what the hop completed, then re-run this dispatcher."
    fi
    die 21 "actor '$before_turn' exceeded ${eff_timeout}s and was killed (hop $hop)"
  fi

  # A crash BEFORE the actor changed anything is retried exactly once, from what
  # the repository says rather than from anything this process remembers. "Before
  # edits" is proven, not assumed: the state file, HEAD, the foreign working tree
  # and the state file's committed-ness must all be byte-for-byte where they were.
  # Any doubt and this is a partial side effect, which stops (rc 20 / 25) instead.
  # One retry only — a second failure is a real failure, not a transient one.
  if [ "$rc" -ne 0 ]; then
    now_dirty=0; state_dirty && now_dirty=1
    if [ "$(file_hash "$STATE_FILE")" = "$before_hash" ] \
       && [ "$(git_head)" = "$before_head" ] \
       && [ "$(foreign_worktree)" = "$before_foreign" ] \
       && [ "$now_dirty" -eq "$before_dirty" ]; then
      # The retry is a launch like any other, so it obeys the same clock. Without
      # re-clamping, a hop that failed at minute 39 would get a fresh full-length
      # timeout and walk straight through the deadline.
      if [ -n "$DEADLINE_AT" ] && [ "$(remaining_seconds)" -le 0 ]; then
        die 29 "budget exhausted — the ${DEADLINE}s deadline expired before hop $hop could be retried. THIS IS NOT COMPLETION."$'\n'"The repository was unchanged by the failed attempt, so re-running this dispatcher resumes cleanly from $STATE_FILE."
      fi
      eff_timeout="$(effective_timeout)"
      say "  exit=$rc after ${duration}s, and the repository is unchanged (state sha256, HEAD, working tree, committed-ness all identical) — retrying this hop once."
      started="$(date '+%s')"
      launch_actor "$before_turn" "${hop}r" "$eff_timeout"   # separate .out — the first attempt's output is evidence
      rc=$?
      duration=$(( $(date '+%s') - started ))
      if [ "$rc" -eq 124 ]; then
        if [ -n "$DEADLINE_AT" ] && [ "$(remaining_seconds)" -le 0 ]; then
          die 29 "budget exhausted — the ${DEADLINE}s deadline expired during the retry of hop $hop and actor '$before_turn' was terminated. THIS IS NOT COMPLETION."$'\n'"Not retried again. Recoverable next action: read $STATE_FILE and \`git -C $CHECKOUT status\`, then re-run this dispatcher."
        fi
        die 21 "actor '$before_turn' exceeded ${eff_timeout}s and was killed on the retry (hop $hop)"
      fi
      [ "$rc" -eq 0 ] && say "  retry succeeded"
    else
      die 20 "actor '$before_turn' exited $rc after ${duration}s (hop $hop) AFTER changing the repository — not retried, because a retry would run over a partial effect; see $LOG_DIR/$RUN_ID.hop$hop.$before_turn.out"
    fi
  fi

  if [ "$rc" -ne 0 ]; then
    die 20 "actor '$before_turn' exited $rc after ${duration}s (hop $hop), and the retry failed too; see $LOG_DIR/$RUN_ID.hop$hop.$before_turn.out"
  fi
  say "  exit=0 duration=${duration}s"

  # Re-read the same file from disk. In-memory turn is never trusted.
  validate_state
  after_hash="$(file_hash "$STATE_FILE")"
  after_turn="$ST_TURN"
  after_head="$(git_head)"
  after_foreign="$(foreign_worktree)"
  say "  after:  sha256=$after_hash turn=$after_turn head=$after_head"

  if [ "$before_foreign" != "$after_foreign" ]; then
    say "  foreign worktree delta:"
    diff <(printf '%s\n' "$before_foreign") <(printf '%s\n' "$after_foreign") | sed 's/^/    /' | tee -a "$RUN_LOG"
    die 24 "actor '$before_turn' changed paths outside the allowlist (hop $hop)"
  fi

  if [ "$before_turn" = "codex" ] && [ "$before_head" != "$after_head" ]; then
    die 24 "Codex moved HEAD ($before_head -> $after_head) — Codex never runs git (core § 4)"
  fi

  # What the actor COMMITTED, checked against the same allowlist as the working
  # tree. Ordered after the Codex-HEAD guard so a Codex hop that moved HEAD is
  # reported as the protocol violation it is, rather than as a path problem.
  if [ "$before_head" != "$after_head" ]; then
    committed_bad="$(committed_foreign "$before_head" "$after_head")"
    if [ -n "$committed_bad" ]; then
      say "  committed paths outside the allowlist:"
      printf '%s\n' "$committed_bad" | sed 's/^/    /' | tee -a "$RUN_LOG"
      die 30 "actor '$before_turn' COMMITTED paths outside the allowlist (hop $hop, $before_head -> $after_head)."$'\n'"The commit already exists — this stops the run rather than letting it compound over later hops."$'\n'"Recoverable next action: inspect with \`git -C $CHECKOUT diff $before_head $after_head\`. If the work is wanted, widen --allow-path and re-run; if it is not, revert or reset those commits first."
    fi
    say "  committed: $(git -C "$CHECKOUT" rev-list --count "$before_head".."$after_head" 2>/dev/null) commit(s), all within the allowlist"
  fi

  if [ "$before_turn" = "claude" ] && state_dirty; then
    # One live cause, measured 2026-08-05: the child was refused permission to run
    # git, so it edited the file and could not commit it. The stop is correct; the
    # message has to be actionable, because "inspect" alone is not a next action.
    die 25 "Claude edited logs/work-loop/$TASK.md but left it uncommitted (hop $hop) — stopping rather than relaunching over a partial edit. A refused git permission looks exactly like this."$'\n'"Recoverable next action: read \`git diff -- logs/work-loop/$TASK.md\` and check the hop capture at $LOG_DIR/$RUN_ID.hop$hop.$before_turn.out for a permission denial. If the edit is complete, commit it and re-run this dispatcher; if it is partial, discard it and re-run."
  fi

  if [ "$after_hash" = "$before_hash" ]; then
    die 22 "actor '$before_turn' exited cleanly but left the state file byte-identical (hop $hop) — no observable transition"
  fi
  if [ "$after_turn" = "$before_turn" ]; then
    die 22 "actor '$before_turn' edited the file but left turn: '$after_turn' unchanged (hop $hop) — not an allowed transition"
  fi

  case "$before_turn:$after_turn" in
    codex:claude|codex:operator|claude:codex|claude:operator)
      say "  transition: $before_turn -> $after_turn (allowed)" ;;
    *)
      die 22 "transition $before_turn -> $after_turn is not allowed" ;;
  esac

  # The hop is over and no actor is in flight. A signal arriving from here until
  # the next launch reports "between hops" and has no process group to terminate.
  CUR_ACTOR=""

  # Courier mode's terminal condition. It sits AFTER every post-hop check above —
  # the allowlist delta, the Codex-HEAD guard, the uncommitted-handback guard, the
  # byte-identical and unchanged-turn guards, and the transition table — so a carry
  # succeeds on exactly the evidence a full loop would have required to continue.
  # Stopping earlier would make --carry-one a weaker check rather than a shorter run,
  # which is the one thing it must not be.
  #
  # Why exit here rather than let the hop limit end it: MAX_HOPS is pinned to 1 in
  # carry-one mode, so the next pass would die 23 HOP_LIMIT — a failure code for the
  # expected outcome, unusable as a courier's success signal. That defect is the
  # reason this mode exists.
  if [ "$CARRY_ONE" -eq 1 ]; then
    say ""
    say "carry-one: the turn moved $before_turn -> $after_turn. One hop carried; not continuing to '$after_turn'."
    if [ "$after_turn" = "operator" ]; then
      say "carry-one: turn is now operator — automation is terminal there (core § 7)."
    fi
    say "carry-one: read turn: from $STATE_FILE. Neither this exit code nor any screen is authoritative over the file (core § 4)."
    release_lock
    exit 0
  fi
done
