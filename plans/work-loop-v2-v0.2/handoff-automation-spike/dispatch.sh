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
#   --unattended        CONTAINED MODE. Apply the operator-settled 1d profile to
#                       every Claude hop: OS-backed Bash sandbox, strict empty
#                       network allowlist, shell + Skill tools only, no MCP, web,
#                       hooks, connectors, remote control, subagents, built-in
#                       file tools or push, credentials scrubbed from
#                       subprocesses, and no unsandboxed-command escape.
#                       Policy and mechanism: runs/probe-contained-authority-2026-08-07.md.
#
#                       Delivered by CLI `--settings` on EVERY hop, never by a
#                       repository settings file. That is not a style choice:
#                       `sandbox.network.strictAllowlist` has NO EFFECT from
#                       `.claude/settings.json`, so writing the profile there
#                       would silently lose the network containment — and would
#                       still look contained on a machine whose USER settings
#                       already carry the key. See the same record, § 1 of the
#                       verification addendum.
#
#                       FAILS CLOSED, exit 31, before anything launches: the
#                       installed claude must be >= 2.1.219 (the release that
#                       added strictAllowlist), the version string must be
#                       readable, and the platform must be one this profile was
#                       proven on. `sandbox.failIfUnavailable` makes the child
#                       fail closed too, if the sandbox is missing at its end.
#
#                       Refuses to combine with --actor-cmd: a simulated actor
#                       cannot be contained, and a run labelled unattended that
#                       was never contained is exactly the evidence this spike
#                       exists to not produce.
#
#                       --claude-deny still works and is ADDITIVE — it can only
#                       narrow this profile further, never widen it.
#
#                       What this flag proves and does not: it applies and logs
#                       the REQUESTED policy. Array-valued settings keys such as
#                       `allowRead` merge across every settings scope, so another
#                       scope on this machine can widen what the child may read.
#                       Only a live check from INSIDE the child establishes the
#                       EFFECTIVE policy — runs/probes/unattended-effective-policy.sh.
#   --log-dir DIR       run evidence directory (default <spike>/runs)
#   --dry-run           validate and route; launch nothing
#   --status            READ-ONLY. Report whether a run is in flight for this
#                       checkout+task, and what the state file says. Acquires no
#                       lock, creates no log, writes nothing at all. Safe to run
#                       against a live run — that is the point of it.
#                       Answers in THREE states, never two: IN FLIGHT (the pid is
#                       visibly alive), STALE LOCK (the pid is positively absent),
#                       and UNKNOWN — CANNOT INSPECT (the pid could not be
#                       inspected, so the lock may still belong to a live run).
#                       Only IN FLIGHT and STALE LOCK are conclusions; UNKNOWN
#                       never recommends removing the lock. See pid_state().
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
#   28  INTERRUPTED            SIGINT/SIGTERM. The actor's whole descendant tree
#                              was terminated, VERIFIED gone, and the run stopped.
#                              If any descendant could not be confirmed dead it is
#                              named in a WARNING before the lock is released —
#                              read that line before treating the halt as clean.
#                              NEVER retried — the signal may have landed after a
#                              partial effect.
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
#   31  UNATTENDED_UNAVAILABLE --unattended was asked for and the contained
#                              profile cannot be delivered: claude older than
#                              2.1.219, an unreadable version string, an
#                              unproven platform, or a profile file that could
#                              not be written. NOTHING launches. Failing closed
#                              is the whole point — a run that quietly proceeds
#                              uncontained is worse than one that stops.
#                              (27 is a deliberate gap in this table, left as
#                              found rather than filled by this addition.)
#
# The five meanings of 0 — do NOT read one as another:
#   --help          printed the header. Nothing was validated, nothing launched.
#   --status        reported what it could read. Nothing was validated beyond
#                   readability, nothing launched, nothing written. 0 does NOT
#                   mean the report was conclusive — an UNKNOWN — CANNOT INSPECT
#                   lock verdict also exits 0. Read the run: line, not the code.
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
UNATTENDED=0

# The contained profile's own deny rules (1d). These are the dispatcher's, not
# the operator's: --claude-deny appends to them and can only narrow further.
#
# Both `git push:*` and `git push *` are listed on purpose. The permission
# reference documents the colon form; the probe that settled 1d recorded the
# space form as the rule it observed denying `git push --help`. Which one the
# installed build honours is not something this dispatcher should be guessing at
# when the cost of listing both is one array entry.
UNATTENDED_BASE_DENY=(
  'Bash(git push:*)'
  'Bash(git push *)'
  'WebFetch'
  'WebSearch'
  'mcp__*'
)
# The minimum claude version that honours sandbox.network.strictAllowlist.
UNATTENDED_MIN_VERSION="2.1.219"
UNATTENDED_SETTINGS=""   # path to the generated per-run profile; set at preflight
UNATTENDED_VERSION=""    # the version string the gate actually read
UNATTENDED_BIN=""        # the claude binary the gate actually inspected

# Interruption state. ACTOR_PGID is the process group of the actor currently in
# flight, or empty between hops — the signal handler needs it to reach the whole
# tree, and "empty" is what tells it there is nothing to terminate.
#
# ACTOR_OUT is the same actor's hop output file, published for the same reason.
# It is not logging bookkeeping: it is the THIRD identification handle (see
# actor_tree_census below), and the only one that survives a double fork. A
# signal handler that knows the pgid but not the file can only reach the group.
SHUTDOWN=0
ACTOR_PGID=""
ACTOR_OUT=""
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
    --unattended)  UNATTENDED=1; shift ;;
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

# --unattended cannot be honoured for a simulated actor. --actor-cmd replaces the
# live product launch entirely, so no settings file, no tool restriction and no
# sandbox reaches anything: the containment would be requested and silently not
# applied, while every line of evidence the run produced said "unattended". That
# is the precise failure this spike is built to refuse, so it is usage, not a
# warning.
if [ "$UNATTENDED" -eq 1 ] && [ -n "$ACTOR_CMD" ]; then
  printf 'STOP [10] --unattended and --actor-cmd are incompatible: a simulated actor cannot be contained, and labelling an uncontained run "unattended" would falsify its evidence\n' >&2; exit 10
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

# ------------------------------------------------- PID inspection (3 states)
# `kill -0` failing is NOT proof that a process is gone. It fails for two very
# different reasons, and telling them apart is the whole of this function:
#
#   ESRCH  "no such process"          -> the PID really is absent
#   EPERM  "operation not permitted"  -> the PID may well be ALIVE; this caller
#                                        is simply not allowed to look at it
#
# Phase 0 § 0b item 3 measured the cost of conflating the two. `--status` run
# from inside the ordinary Codex command sandbox reported a genuinely live
# dispatcher (pid 79266) as STALE LOCK, and told the operator to `rm -rf` a lock
# that was doing its job. Sandbox policy refused the signal; the old check read
# that refusal as a death certificate.
#
# So only a message that positively says "no such process" may conclude ABSENT.
# Everything else — a refusal, an empty pid file, a non-numeric pid, an error
# text not recognised here — is UNKNOWN. The asymmetry is deliberate and points
# one way on purpose: a false UNKNOWN costs the operator one more look, a false
# ABSENT costs them a hand-edited state file in the middle of a live hop.
#
# LC_ALL=C so the matched text is the C-locale wording rather than whatever the
# ambient locale renders. Matched case-insensitively because the two shells that
# run this differ: bash says "No such process", zsh "no such process".
#
# Emits ONE line, "STATE|reason", rather than setting a global alongside its
# return value: callers read it through $( ), which is a subshell, so a global
# assigned in here would be discarded on the way out. Caught in demonstration
# — the reason line printed empty.
pid_state() { # pid -> "LIVE|reason" / "ABSENT|reason" / "UNKNOWN|reason"
  local pid="${1:-}" err rc
  # A valid pid matches [1-9][0-9]* — and "numeric" is NOT the same test.
  # `0` and `00` are numeric and were accepted here until 2026-08-07; both are
  # catastrophic to pass to kill(2), because pid 0 means "every process in the
  # CALLER'S OWN process group". `kill -0 0` therefore SUCCEEDS, so a lock
  # holding `0` reported `IN FLIGHT — dispatcher pid 0` and told the operator to
  # run `kill -TERM 0` — which would signal their own shell and everything in it.
  # A zero-PREFIXED value is a quieter version of the same bug: `007` reaches
  # kill(2) as pid 7, so the verdict is a true statement about an unrelated
  # process presented as a statement about this lock.
  #
  # None of these is evidence about the dispatcher. They are a corrupt lock, and
  # a corrupt lock is something this function cannot inspect — UNKNOWN.
  case "$pid" in
    '')       printf 'UNKNOWN|the lock directory holds no readable pid file\n'; return 0 ;;
    *[!0-9]*) printf "UNKNOWN|the lock's pid is not a number: '%s'\\n" "$pid"; return 0 ;;
    0*)       printf "UNKNOWN|the lock's pid is not a usable process id: '%s' — a real pid matches [1-9][0-9]*, and 0 would mean this caller's own process group\\n" "$pid"; return 0 ;;
  esac

  err="$(LC_ALL=C kill -0 "$pid" 2>&1)"; rc=$?
  if [ "$rc" -eq 0 ]; then
    printf 'LIVE|kill -0 succeeded — the process is visible and signallable\n'; return 0
  fi

  if printf '%s' "$err" | grep -qi 'no such process'; then
    printf 'ABSENT|kill -0 reported: no such process\n'; return 0
  fi

  printf 'UNKNOWN|kill -0 failed WITHOUT proving absence: %s\n' \
    "$(printf '%s' "${err:-<no error text>}" | tr '|\n' '  ')"
  return 0
}

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

# ------------------------------------------------- descendant identification
#
# Terminate the actor's WHOLE DESCENDANT TREE, then verify it is gone.
#
# This replaces a group-only sweep (`kill -- -PGID`) that was honest about its own
# reach and insufficient anyway: a descendant which leaves the actor's process
# group outlived every stop, so the dispatcher reported a clean halt while a
# process it started kept running unsupervised. That is Phase 1a, and the reason
# it blocked the walk-away pilot.
#
# THE MECHANISM IS MEASURED, NOT ASSUMED. Four candidate handles were probed on
# this host; the table is the measurement, not a design intention:
# runs/probe-escaped-descendants-2026-08-07.md.
#
#   handle                       in-group  setsid,   double-fork  SIP system
#                                 child    parented    orphan      binary
#   ---------------------------------------------------------------------------
#   process group (kill -- -PGID)  reaches   MISSES     MISSES      n/a
#   recursive PPID census          reaches   reaches    MISSES      n/a
#   environment tag (ps -E)        MISSES    reaches    reaches     MISSES
#   inherited fd on the hop log    reaches   reaches    reaches     reaches
#
# What each row means, since the reasons are the whole argument:
#   - setsid(2) gives a new session AND a new process group, so the group kill
#     cannot see it. It does NOT change PPID, so an ancestry walk still can.
#   - a double fork leaves the grandchild re-parented to pid 1 the moment the
#     intermediate exits. The ancestry link is destroyed by the kernel, before any
#     stop happens, so no walk taken at stop time can recover it.
#   - `ps -E` cannot read the environment of a SIP-protected platform binary
#     (/bin/sh, /bin/sleep, /usr/bin/git all refuse; a user-installed python3
#     does not). An env tag is therefore blind to exactly the binaries an escaped
#     shell job is most likely to be. It is rejected on that measurement, and
#     because matching it means matching argv text too, which invents a
#     false-positive class the other handles do not have.
#   - kqueue NOTE_TRACK, the BSD fork-following filter, would have been the clean
#     answer. It returns ENOTSUP on this host (Darwin 26.5) — measured, same
#     record. It is not available to be chosen.
#
# So the union of handles 1, 2 and 4 is used. Handle 4 is the load-bearing one and
# it is free: launch_actor already runs every actor as `"$@" >>"$out" 2>&1`, so
# each descendant inherits fd 1 and 2 pointing at that hop's output file, and
# `lsof -t` lists holders regardless of session, process group, ancestry or code
# signing. Nothing new is spawned, and nothing has to be tracked during the hop.
#
# THE RESIDUAL, stated rather than papered over: a descendant that closes or
# redirects BOTH inherited descriptors, AND has left the process group, AND has
# been re-parented away, is invisible to all three handles. A conventional daemon
# does exactly this. That is why teardown VERIFIES and reports survivors instead
# of asserting success — see terminate_actor_tree. dispatch.test.sh case 27h
# pins the residual so it stays a measured boundary rather than a belief.

# Pids this dispatcher must never signal, whatever a census says: itself and its
# own ancestors, plus 0 and 1. This is the same lesson pid_state() carries — pid 0
# means "the caller's own process group", and signalling our own ancestry would
# reach the operator's shell. A census is untrusted input; this is its filter.
SELF_PIDS=" 0 1 "
_p="$$"
while :; do
  case "$_p" in ''|*[!0-9]*|0*) break ;; esac
  [ "$_p" -le 1 ] && break
  SELF_PIDS="$SELF_PIDS$_p "
  _p="$(ps -o ppid= -p "$_p" 2>/dev/null | tr -d ' ')"
done
unset _p

SELF_PGID="$(ps -o pgid= -p "$$" 2>/dev/null | tr -d ' ')"

# Handle 4 needs lsof. It ships with macOS, but its absence must be loud rather
# than a silent downgrade to the group-only reach this unit exists to remove.
FD_HANDLE=1
command -v lsof >/dev/null 2>&1 || FD_HANDLE=0

signallable_pid() { # pid -> 0 if this dispatcher may signal it
  local pid="${1:-}"
  case "$pid" in ''|*[!0-9]*|0*) return 1 ;; esac
  case "$SELF_PIDS" in *" $pid "*) return 1 ;; esac
  ps -p "$pid" -o pid= >/dev/null 2>&1 || return 1   # liveness WITHOUT needing
  return 0                                          # signal permission
}

# The union of the three usable handles, filtered and deduplicated. Live pids
# only, one per line. Empty output means "nothing of this actor is still running",
# and that is the claim the whole unit rests on, so it is computed from three
# independent sources rather than one.
actor_tree_census() { # pgid, outfile -> live descendant pids
  local pgid="${1:-}" out="${2:-}" acc="" seen="" p pid pgrp frontier next kid c

  [ -n "$pgid" ] || return 0
  # Refuse to census our OWN group. If `set -m` ever failed, the actor would share
  # the dispatcher's group and this sweep would enumerate the operator's other
  # jobs. Returning nothing is wrong-but-safe; the alternative is unbounded.
  [ -n "$SELF_PGID" ] && [ "$pgid" = "$SELF_PGID" ] && return 0

  # (1) process group members
  while read -r pid pgrp; do
    [ "$pgrp" = "$pgid" ] && acc="$acc $pid"
  done < <(ps -ax -o pid=,pgid= 2>/dev/null)

  # (2) recursive ancestry walk from the actor. Bounded by a visited set, so a
  #     pid-reuse cycle cannot spin here.
  frontier="$pgid"; seen=" $pgid "
  while [ -n "$frontier" ]; do
    next=""
    for kid in $frontier; do
      for c in $(pgrep -P "$kid" 2>/dev/null); do
        case "$seen" in *" $c "*) continue ;; esac
        seen="$seen$c "; next="$next $c"; acc="$acc $c"
      done
    done
    frontier="$next"
  done

  # (3) holders of the hop's inherited output descriptor
  if [ "$FD_HANDLE" -eq 1 ] && [ -n "$out" ] && [ -e "$out" ]; then
    acc="$acc $(lsof -t -- "$out" 2>/dev/null | tr '\n' ' ')"
  fi

  seen=" "
  for p in $acc; do
    case "$seen" in *" $p "*) continue ;; esac
    signallable_pid "$p" || continue
    seen="$seen$p "
    printf '%s\n' "$p"
  done
}

# TERM first, then KILL after a grace period, because an actor that can exit
# cleanly should be allowed to. Callers: the per-actor timeout, the deadline, and
# the signal handler — one sweep, three callers, so they cannot drift apart.
#
# Both constants are load-bearing for the deadline's accuracy: together they are
# the upper bound on how far past its budget a terminated run can extend. Named so
# the arithmetic can be quoted rather than rediscovered — see effective_timeout.
TERM_GRACE_SECS=5
KILL_SETTLE_SECS=2

# Set by terminate_actor_tree: the pids it could NOT confirm dead. Empty is the
# normal case and the only one that permits a "teardown completed" claim.
TEARDOWN_SURVIVORS=""

terminate_actor_tree() { # pgid, outfile -> 0 when the tree is verified gone
  local pgid="${1:-}" out="${2:-}" census p waited
  TEARDOWN_SURVIVORS=""
  [ -n "$pgid" ] || return 0

  # Re-censused on every pass, not computed once: a descendant can be spawned
  # DURING teardown, and one that appears after the first sweep would otherwise
  # never be signalled at all.
  census="$(actor_tree_census "$pgid" "$out")"
  kill -TERM -- "-$pgid" 2>/dev/null
  for p in $census; do kill -TERM "$p" 2>/dev/null; done

  waited=0
  while [ "$waited" -lt "$TERM_GRACE_SECS" ]; do
    census="$(actor_tree_census "$pgid" "$out")"
    [ -z "$census" ] && break
    for p in $census; do kill -TERM "$p" 2>/dev/null; done
    sleep 1
    waited=$((waited + 1))
  done

  census="$(actor_tree_census "$pgid" "$out")"
  if [ -n "$census" ]; then
    kill -KILL -- "-$pgid" 2>/dev/null
    for p in $census; do kill -KILL "$p" 2>/dev/null; done
    waited=0
    while [ "$waited" -lt "$KILL_SETTLE_SECS" ]; do
      sleep 1
      waited=$((waited + 1))
      census="$(actor_tree_census "$pgid" "$out")"
      [ -z "$census" ] && break
      for p in $census; do kill -KILL "$p" 2>/dev/null; done
    done
  fi

  # The verification the objective actually rests on. Whatever is still here is
  # reported, never rounded down to success.
  TEARDOWN_SURVIVORS="$(actor_tree_census "$pgid" "$out" | tr '\n' ' ')"
  TEARDOWN_SURVIVORS="${TEARDOWN_SURVIVORS%% }"
  [ -z "$TEARDOWN_SURVIVORS" ]
}

# The disclosure half. A stop that could not clear the tree must say so BEFORE the
# lock is released and the process exits, because after that there is nobody left
# to notice. Silence here would restore exactly the defect 1a describes.
report_teardown() { # -> 0 when the tree was verified gone
  local msg
  if [ -z "$TEARDOWN_SURVIVORS" ]; then
    # SCOPED ON PURPOSE. "The tree is gone" would be a stronger claim than three
    # handles can support — see the residual above, and dispatch.test.sh case 27h,
    # which fails if this sentence is ever widened.
    msg="  teardown verified: no descendant reachable by group, ancestry or inherited descriptor is still running"
    printf '%s\n' "$msg" >&2
    [ -n "${RUN_LOG:-}" ] && printf '%s\n' "$msg" >>"$RUN_LOG"
    return 0
  fi
  msg="  WARNING: teardown could NOT confirm the actor's tree is gone. Still running: $TEARDOWN_SURVIVORS
  These processes were signalled and did not go. They are NOT stopped, and this run is not a clean halt.
  Inspect with \`ps -o pid,ppid,pgid,command -p <pid>\` and terminate them by hand before re-running."
  printf '%s\n' "$msg" >&2
  [ -n "${RUN_LOG:-}" ] && printf '%s\n' "$msg" >>"$RUN_LOG"
  if [ "$FD_HANDLE" -eq 0 ]; then
    msg="  NOTE: lsof was not found, so the inherited-descriptor handle was unavailable for this teardown."
    printf '%s\n' "$msg" >&2
    [ -n "${RUN_LOG:-}" ] && printf '%s\n' "$msg" >>"$RUN_LOG"
  fi
  return 1
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
    printf '  terminating actor descendant tree (pgid %s)\n' "$ACTOR_PGID" >&2
    [ -n "${RUN_LOG:-}" ] && printf '  terminating actor descendant tree (pgid %s)\n' "$ACTOR_PGID" >>"$RUN_LOG"
    terminate_actor_tree "$ACTOR_PGID" "$ACTOR_OUT"
    # Reported here, before release_lock and exit below: the lock must not be
    # handed on, and this process must not go, while the operator still believes
    # everything halted.
    report_teardown
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
    # Three states, not two. See pid_state() above for why "kill -0 failed" is
    # not the same question as "the process is gone".
    st_probe="$(pid_state "$st_pid")"
    st_pid_state="${st_probe%%|*}"    # LIVE | ABSENT | UNKNOWN
    st_pid_why="${st_probe#*|}"       # the evidence behind that verdict
    case "$st_pid_state" in
      LIVE)
        printf 'run: IN FLIGHT — dispatcher pid %s holds %s\n' "$st_pid" "$LOCK_DIR"
        printf '     do not edit the state file by hand until it exits.\n'
        printf '     to stop it: kill -TERM %s   (it terminates the actor and exits 28)\n' "$st_pid"
        ;;
      ABSENT)
        printf 'run: STALE LOCK — %s exists but pid %s is not running.\n' "$LOCK_DIR" "$st_pid"
        printf '     a dispatcher died without releasing it. Remove the directory to unblock: rm -rf %s\n' "$LOCK_DIR"
        ;;
      *)
        # Deliberately NOT actionable. This branch knows one thing — that it does
        # not know — and the only honest instruction is to go and look properly.
        printf 'run: UNKNOWN — CANNOT INSPECT pid %s holding %s\n' "${st_pid:-<unreadable>}" "$LOCK_DIR"
        printf '     why: %s\n' "$st_pid_why"
        printf '     THIS LOCK MAY BELONG TO A LIVE DISPATCHER. Treat the run as possibly in flight:\n'
        printf '     do not remove the lock, and do not edit the state file by hand on this answer.\n'
        printf '     The usual cause is that this caller cannot see the PID (sandbox policy or a\n'
        printf '     different owner), not that the run has ended. Re-run --status from somewhere\n'
        printf '     permitted to inspect processes — outside the tool sandbox — before concluding\n'
        printf '     anything. Everything below is what could still be read.\n'
        ;;
    esac
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

# ------------------------------------------------- unattended contained profile
#
# Item 1d. The operator settled the policy and a probe proved the mechanism; this
# section is the part that applies it. Everything here runs BEFORE the first hop,
# so a profile that cannot be delivered stops the run instead of degrading it.

# Compare two dotted versions. Returns 0 when $1 >= $2, 1 when lower, 2 when $1
# is not a readable dotted version at all. The third case is deliberately NOT
# folded into "lower": an unreadable version and an old version want the same
# refusal but different words, and guessing which one happened is how a gate
# starts lying.
version_at_least() { # have, want
  local have="$1" want="$2" i
  case "$have" in ''|*[!0-9.]*) return 2 ;; esac
  local -a h w
  IFS='.' read -r -a h <<<"$have"
  IFS='.' read -r -a w <<<"$want"
  [ "${#h[@]}" -ge 1 ] || return 2
  for i in 0 1 2; do
    local hv="${h[$i]:-0}" wv="${w[$i]:-0}"
    case "$hv" in ''|*[!0-9]*) return 2 ;; esac
    if [ "$hv" -gt "$wv" ]; then return 0; fi
    if [ "$hv" -lt "$wv" ]; then return 1; fi
  done
  return 0
}

# Pull the first dotted numeric version out of a `claude --version` line.
# The real output is `2.1.220 (Claude Code)`; this must not be fooled by a build
# suffix, and must come back empty rather than approximate when there is none.
version_number() { # raw version line
  printf '%s' "$1" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1
}

# The whole profile, as one JSON document delivered by CLI --settings.
#
# Every key here traces to a numbered layer of the proven profile in
# runs/probe-contained-authority-2026-08-07.md § Safe profile tested. The layers
# that are CLI-only (--tools, --strict-mcp-config, --disallowedTools,
# --no-session-persistence) and the env-only one (subprocess credential scrub)
# are applied in launch_actor, not here, and are logged alongside these.
write_unattended_profile() { # path -> 0 on success
  local path="$1" gitdir esc_checkout esc_gitdir
  # The child's Bash is sandboxed and home reads are denied, so the checkout has
  # to be re-allowed or the actor cannot read the repository it is working in.
  # Linked worktrees keep their objects in the common dir, which is elsewhere —
  # deny it and Git stops working inside the sandbox, silently and confusingly.
  gitdir="$(git -C "$CHECKOUT" rev-parse --path-format=absolute --git-common-dir 2>/dev/null)"
  [ -n "$gitdir" ] || gitdir="$CHECKOUT/.git"

  # `~/.gitconfig` is the ONE named exception inside the denied home tree, and it
  # is there because the profile without it does not merely inconvenience the
  # child — it stops Git working at all. Git reads that file on every invocation
  # and exits 128 before touching the repository when the read is refused:
  #   fatal: unable to access '/Users/…/.gitconfig': Operation not permitted
  # Measured, not reasoned: runs/probe-unattended-integration-2026-08-07.md.
  #
  # Why not neutralise Git's config discovery instead, which would grant no read
  # at all: the identity lives only in the global config in this repository
  # (`git config --local --get user.email` is empty), and core § 4 has Claude
  # commit every hop. A child without an identity fails every hop.
  #
  # Operator decision, 2026-08-07: allow the minimum Git configuration paths and
  # broaden home access no further. So this is a single FILE, not `~/.config/`,
  # not `~/.git*`, and not a directory. `~/.config/git/config` is deliberately
  # absent — it does not exist on the settled host, and the live probe confirms
  # Git works without it. Add it only if a run proves it necessary.
  #
  # KNOWN AND MEASURED: this file also carries credential-helper commands. The
  # child can therefore read that `gh auth git-credential` is configured. It
  # cannot get a token from it — `gh` reads its own credentials from
  # `~/.config/gh/`, which stays denied — and the probe asserts that rather than
  # assuming it. If a real secret is ever put in `~/.gitconfig`, this exception
  # stops being safe and must be revisited.

  # Minimal JSON string escaping. Paths can legitimately contain spaces (this
  # workspace's own do) and backslashes; unescaped they would produce a settings
  # file the child rejects, which reads as "sandbox unavailable" rather than as
  # "the dispatcher wrote bad JSON".
  esc_checkout="$(printf '%s' "$CHECKOUT" | sed 's/\\/\\\\/g; s/"/\\"/g')"
  esc_gitdir="$(printf '%s' "$gitdir"    | sed 's/\\/\\\\/g; s/"/\\"/g')"

  cat >"$path" <<PROFILE_EOF || return 1
{
  "sandbox": {
    "enabled": true,
    "failIfUnavailable": true,
    "allowUnsandboxedCommands": false,
    "network": {
      "allowedDomains": [],
      "strictAllowlist": true
    },
    "filesystem": {
      "denyRead": ["~/"],
      "allowRead": ["$esc_checkout", "$esc_gitdir", "~/.gitconfig"]
    }
  },
  "disableAllHooks": true,
  "disableClaudeAiConnectors": true,
  "disableRemoteControl": true,
  "disableAgentView": true,
  "disableArtifact": true,
  "autoMemoryEnabled": false
}
PROFILE_EOF
  [ -s "$path" ] || return 1
  return 0
}

if [ "$UNATTENDED" -eq 1 ]; then
  # 1. Platform. The proven profile is macOS Seatbelt. Claude Code sandboxes
  #    Linux too, but nobody has run this profile there, and "probably fine" is
  #    not what fail-closed means.
  u_os="$(uname -s 2>/dev/null)"
  [ "$u_os" = "Darwin" ] || die 31 "--unattended is proven on Darwin (macOS Seatbelt) only; this host reports '$u_os'."$'\n'"Recoverable next action: run without --unattended and accept the open authority, or prove the profile on this platform first."

  # 2. The binary, resolved the same way launch_actor resolves it. Gating a
  #    different binary from the one that will run is a gate in name only.
  UNATTENDED_BIN="$CLAUDE_BIN"
  [ -n "$UNATTENDED_BIN" ] || UNATTENDED_BIN="$(command -v claude 2>/dev/null)"
  [ -n "$UNATTENDED_BIN" ] && [ -x "$UNATTENDED_BIN" ] \
    || die 31 "--unattended cannot check the claude version: binary not resolvable"

  # 3. Version. strictAllowlist landed in 2.1.219; below that the network half
  #    of the profile is accepted and ignored, which is the silent failure.
  u_raw="$("$UNATTENDED_BIN" --version 2>&1 | head -1)"
  UNATTENDED_VERSION="$(version_number "$u_raw")"
  if [ -z "$UNATTENDED_VERSION" ]; then
    die 31 "--unattended cannot read a version from '$UNATTENDED_BIN' (got: ${u_raw:-<empty>}); refusing to assume it supports sandbox.network.strictAllowlist"
  fi
  version_at_least "$UNATTENDED_VERSION" "$UNATTENDED_MIN_VERSION"
  case $? in
    0) : ;;
    1) die 31 "--unattended needs claude >= $UNATTENDED_MIN_VERSION for sandbox.network.strictAllowlist; '$UNATTENDED_BIN' is $UNATTENDED_VERSION."$'\n'"Recoverable next action: upgrade claude, or run without --unattended and accept an open network." ;;
    *) die 31 "--unattended read an unusable version '$UNATTENDED_VERSION' from '$UNATTENDED_BIN'" ;;
  esac

  # 4. The profile itself, written per run so the evidence directory holds the
  #    exact bytes the child was launched under.
  UNATTENDED_SETTINGS="$LOG_DIR/$RUN_ID.unattended-settings.json"
  write_unattended_profile "$UNATTENDED_SETTINGS" \
    || die 31 "--unattended could not write its profile to $UNATTENDED_SETTINGS"

  # 5. Say what was applied, and through which scope. The scope is load-bearing,
  #    not decoration: the same JSON in a repository settings file would drop the
  #    network containment without a word, so "we sent a profile" is not the
  #    claim worth logging — "we sent it by CLI --settings" is.
  say "unattended=ON — contained profile applied to every Claude hop (item 1d)"
  say "  scope: CLI --settings (NOT a repository settings file — strictAllowlist has no effect from one)"
  say "  profile: $UNATTENDED_SETTINGS"
  say "  gate: claude $UNATTENDED_VERSION >= $UNATTENDED_MIN_VERSION at $UNATTENDED_BIN, platform $u_os"
  say "  sandbox: enabled, failIfUnavailable, allowUnsandboxedCommands=false"
  say "  network: allowedDomains=[] strictAllowlist=true (no Bash network, no approval prompt)"
  say "  filesystem: denyRead ~/ ; allowRead <checkout>, its git common dir, and ~/.gitconfig"
  say "    ~/.gitconfig is the ONE named file re-opened inside the denied home tree — without it Git"
  say "    exits 128 before touching the repository. No directory under ~/ is re-opened."
  say "  tools: Bash,Skill only — no built-in Read/Edit/Write, so file access goes through the sandbox"
  say "  mcp: --strict-mcp-config with no config — no MCP tools"
  say "  deny: ${UNATTENDED_BASE_DENY[*]}"
  say "  also: hooks, connectors, remote control, agent view, artifacts and auto-memory disabled; no session persistence"
  say "  env: CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1 — credentials stripped from subprocesses"
  say "  codex hops are NOT covered by this profile; their containment is codex's own --sandbox workspace-write"
  # The two known ways this can be true on the log and false in the child. Both
  # are stated at every run rather than in a document nobody opens mid-incident.
  say "  LIMIT: this records the REQUESTED policy. Array keys such as allowRead MERGE across settings scopes,"
  say "         so another scope on this host can widen what the child may read. Closing that needs managed"
  say "         settings (allowManagedReadPathsOnly / allowManagedDomainsOnly), which this dispatcher cannot set."
  say "  LIMIT: only a check from INSIDE a live child establishes the EFFECTIVE policy —"
  say "         runs/probes/unattended-effective-policy.sh"
elif [ "$MODE" = "live" ]; then
  say "unattended=off — Claude hops run with this checkout's normal authority, including network"
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
  ACTOR_OUT="$out"
  start="$(date '+%s')"

  while kill -0 "$pid" 2>/dev/null; do
    if [ "$(( $(date '+%s') - start ))" -ge "$limit" ]; then
      terminate_actor_tree "$pid" "$out"
      # Reported at the teardown, not at the die() below, because both the
      # per-actor timeout (21) and the deadline (29) come through here and the
      # disclosure must not depend on which of them the caller picks.
      report_teardown
      wait "$pid" 2>/dev/null
      ACTOR_PGID=""
      ACTOR_OUT=""
      return 124
    fi
    # 1s poll. This is also the worst-case latency between an operator's
    # `kill -TERM` and the handler running, because a trap fires between
    # commands and `sleep` is the command it interrupts.
    sleep 1
  done

  wait "$pid"; rc=$?
  ACTOR_PGID=""
  ACTOR_OUT=""
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
#   overrun <= 1s (poll interval)
#            + TERM_GRACE_SECS      (TERM -> KILL)
#            + KILL_SETTLE_SECS     (KILL -> verified gone)
#            + census cost          (~0.3s per pass, several passes)
#            + reaping
#
# — about 9 seconds with the current grace of 5 and settle of 2. A run given
# --deadline 2400 can therefore end at roughly 2409s, never at 2400s exactly, and
# never at 2400 + --timeout. Case 28 asserts the arithmetic rather than a round
# number, so tightening either constant tightens the test with it.
#
# THIS BOUND GREW ON 2026-08-07, from ~6s, and the growth is deliberate. Truthful
# whole-tree teardown costs a verification pass the group-only sweep never did:
# it re-censuses after SIGKILL instead of assuming the signal worked. The plan
# forbids relaxing the hard clock silently, so the new worst case is stated here
# and asserted in the suite rather than left to be discovered by a run that
# overshot. It is NOT "about 6 seconds" — that was true of the weaker teardown.
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
      if [ "$UNATTENDED" -eq 1 ]; then
        # The contained profile (1d). Built as an array so the operator's own
        # --claude-deny rules append to the base set rather than replacing it:
        # this flag may narrow the profile further, never widen it.
        local -a u_deny=("${UNATTENDED_BASE_DENY[@]}")
        [ "${#CLAUDE_DENY[@]}" -gt 0 ] && u_deny+=("${CLAUDE_DENY[@]}")
        # stream-json rather than json, and ONLY on this path.
        #
        # The stream's first event is the product's own `system/init`, which
        # states the tool roster and the MCP servers the runtime ACTUALLY
        # resolved. That is the one surface on which "only Bash and Skill are
        # exposed" and "no MCP is loaded" can be checked as effective behaviour
        # rather than taken from the argv we asked for or from the child's own
        # prose — and both of those were scored as passes here until Codex's
        # 2026-08-07 assessment caught it.
        #
        # Nothing is lost: the stream's final `result` event is byte-identical
        # to what --output-format json produced, so this is a superset of the
        # previous capture, not a different one. --verbose is required for
        # stream-json under --print.
        #
        # Attended and courier hops keep --output-format json. The extra volume
        # is the price of an auditable roster, and it is only worth paying where
        # nobody is watching.
        say "  cmd: claude -p '/work-loop-v2 $TASK' --output-format stream-json --verbose --settings <profile> --tools Bash,Skill --strict-mcp-config --no-session-persistence --disallowedTools ${u_deny[*]} (cwd=<checkout>, CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1)"
        say "  note: the hop capture's system/init event records the EFFECTIVE tool roster and MCP servers; this log records only what was REQUESTED"
        CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1 \
        run_bounded "$limit" "$out" "$cb" -p "/work-loop-v2 $TASK" \
          --output-format stream-json --verbose \
          --settings "$UNATTENDED_SETTINGS" \
          --tools 'Bash,Skill' \
          --strict-mcp-config \
          --no-session-persistence \
          --disallowedTools "${u_deny[@]}"
      elif [ "${#CLAUDE_DENY[@]}" -gt 0 ]; then
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
  # --dry-run --unattended is a real preflight, not a formality: the version gate,
  # the platform check and the profile write have all already run above, so
  # reaching this line means the contained profile is deliverable on this host.
  [ "$UNATTENDED" -eq 1 ] && say "dry-run: the contained profile passed its gate and was written; a live run would launch under it."
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
