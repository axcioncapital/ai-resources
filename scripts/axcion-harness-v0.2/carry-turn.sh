#!/bin/bash
# Axcíon Harness v0.2 — attended one-hop Work Loop v2 turn carrier.
#
# Carries exactly ONE already-explicit Work Loop turn for ONE exact task in ONE
# exact checkout, then stops. It is a courier in the sense of the executable core
# § 4: it moves a turn the state file already states. It never decides what the
# task means, never writes a brief, never assesses a result, never chooses the
# next actor, and never continues past `turn: operator`.
#
# ATTENDED ONLY. One hop per invocation. There is no loop mode, no unattended
# mode, no worktree automation, no hook and no daemon — and no flag to ask for
# one. Requests for those fail closed before anything launches (exit 10).
#
# The only semantic interface is logs/work-loop/{task-id}.md. This script creates
# no queue and no shadow state; all of its memory is the task id it was given,
# held in this process only. It reads the state file and never writes it — the
# actors do that (core § 4: Codex writes the brief, Claude commits).
#
# Usage:
#   carry-turn.sh --checkout <abs-path> --task <task-id> [options]
#
# Options:
#   --timeout S        actor wall-clock seconds (default 900)
#   --claude-bin PATH  default: `claude` resolved from PATH
#   --codex-bin PATH   default /Applications/ChatGPT.app/Contents/Resources/codex
#   --allow-path RE    repeatable regex of repo-relative paths the actor may
#                      change. Default: ^logs/work-loop/ and ^logs/harness-runs/
#                      This has to describe what the UNIT may touch, so it is a
#                      per-task input. Too narrow gives a false stop; too wide
#                      makes the check mean nothing.
#   --claude-deny RULE repeatable. Passed to the Claude child as
#                      --disallowedTools RULE, e.g. 'Bash(git push:*)'. Default:
#                      none. It can only narrow the child's authority further.
#   --log-dir DIR      run evidence directory.
#                      Default <checkout>/logs/harness-runs
#   --dry-run          validate and route; launch nothing
#   -h, --help         print this block
#
# ATTENDED PERMISSION POLICY. Every Claude hop is launched with
# `--permission-mode default`, with or without --claude-deny. It is not an option
# and there is no flag to turn it off. Without it the child INHERITS the
# checkout's own defaultMode — which in this repository is `bypassPermissions` —
# so an actor would receive bypass authority nobody asked for. Stating the mode
# at launch fixes that without editing any settings.json. It is a permission
# policy, not containment: it makes the child ask, it does not sandbox it.
# `--dangerously-skip-permissions` is never passed, on any path.
#
# Exit codes. 0 is the only success, and the RESULT line says which success it is
# — read that line, not the code alone.
#   0   see RESULT outcome=CARRIED or outcome=OPERATOR_TERMINAL
#   10  BAD_USAGE              includes every attended-boundary refusal
#   11  BAD_CHECKOUT
#   12  BAD_TASK_ID            traversal or illegal characters
#   13  STATE_MISSING
#   14  IDENTITY_MISMATCH      filename stem != frontmatter task:
#   15  BAD_TURN               turn: not in {codex, claude, operator}
#   16  FOREIGN_STAGED         something already staged; refuse to sweep it in
#   17  LOCK_HELD              another carry owns this CHECKOUT — any task, not
#                              just this one. Run a concurrent task in its own
#                              linked worktree and pass that with --checkout.
#   18  FOREIGN_UNSTAGED       out-of-allowlist working-tree changes already there
#   19  GIT_HAZARD             index.lock, or merge/rebase/cherry-pick in progress
#   20  ACTOR_FAILED           actor exited non-zero (never retried — see below)
#   21  ACTOR_TIMEOUT
#   22  NO_TRANSITION          state did not move in an allowed direction
#   24  UNEXPECTED_EFFECT      out-of-allowlist working-tree change, or Codex
#                              moved HEAD
#   25  UNCOMMITTED_HANDBACK   Claude handed back without committing the state file
#   26  MALFORMED_TERMINAL     turn: operator, but the file is neither a core § 7
#                              question nor a core § 4 closing record
#   28  INTERRUPTED            SIGINT/SIGTERM; the actor's process group was
#                              terminated and the run stopped. Never retried.
#   30  UNEXPECTED_COMMIT      the actor COMMITTED paths outside the allowlist.
#                              Detection, not prevention.
#   37  PERMISSION_DENIED      Claude recorded permission denials and the hop
#                              produced no valid handback. The denied tool and
#                              target are named, and the report says whether any
#                              allowed change is attributable to the hop.
#                              The number is NOT this script's to choose: the
#                              Work Loop exit taxonomy assigns 37 to a permission
#                              dead end (.agents/skills/work-loop-v2/SKILL.md).
#                              A permission dead end is a capability question —
#                              re-running or raising the timeout will not change
#                              it, so it must not share a code with a transport
#                              failure.
#
# NO RETRY. A failed actor is reported, not relaunched. One hop means one launch,
# so the operator sees the failure and decides. (The spike retried once when the
# repository was provably unchanged; that belongs to unattended running, where
# nobody is watching.)
#
# EVERY terminal path prints one RESULT line as its last line:
#   RESULT outcome=<CARRIED|OPERATOR_TERMINAL|STOPPED|VALIDATED> code=<n> ...
#          ... denials=<n|unavailable|n/a> partial=<n>
# Neither that line nor this exit code is authoritative over the state file
# (core § 4). A courier reads the file.
#
# ONE CLASSIFICATION, ONE ORDER. Everything after the actor returns is decided in
# classify_hop, from one evidence set gathered once. `denials=unavailable` is not
# `denials=0`: the first means no permission evidence could be read, the second
# means Claude reported none. `partial=<n>` counts working-tree changes INSIDE
# the allowlist that this hop introduced — changes already present at launch are
# never counted, because they are not the actor's.

set -uo pipefail

RUN_START="$(date '+%s')"

CHECKOUT=""
TASK=""
ACTOR_TIMEOUT=900
CODEX_BIN="/Applications/ChatGPT.app/Contents/Resources/codex"
CLAUDE_BIN=""
LOG_DIR=""
DRY_RUN=0
ALLOW_PATHS=()
CLAUDE_DENY=()

TERM_GRACE_SECS=5
KILL_SETTLE_SECS=2

# Terminal-result state. Populated as the run learns them so that die() can
# report a truthful RESULT line from anywhere.
R_ACTOR="none"
R_BEFORE=""
R_AFTER=""
R_MODE="live"
# Classification evidence on the RESULT line. `denials` is deliberately not a
# number when nothing could be read: `unavailable` and `0` mean different things.
R_DENIALS="n/a"
R_PARTIAL="0"

ACTOR_CAPTURE=""

LOCK_DIR=""
RUN_LOG=""
ACTOR_PGID=""
SHUTDOWN=0

# ------------------------------------------------------------------ reporting

say() {
  printf '%s\n' "$*"
  [ -n "$RUN_LOG" ] && printf '%s\n' "$*" >>"$RUN_LOG"
  return 0
}

result_line() { # outcome, code
  printf 'RESULT outcome=%s code=%s task=%s mode=%s actor=%s turn_before=%s turn_after=%s denials=%s partial=%s\n' \
    "$1" "$2" "${TASK:-none}" "$R_MODE" "$R_ACTOR" "${R_BEFORE:-none}" "${R_AFTER:-none}" \
    "$R_DENIALS" "$R_PARTIAL"
}

die() { # code, message
  local code="$1"; shift
  printf 'STOP [%s] %s\n' "$code" "$*" >&2
  [ -n "$RUN_LOG" ] && printf 'STOP [%s] %s\n' "$code" "$*" >>"$RUN_LOG"
  local line; line="$(result_line STOPPED "$code")"
  printf '%s\n' "$line"
  [ -n "$RUN_LOG" ] && printf '%s\n' "$line" >>"$RUN_LOG"
  release_lock
  exit "$code"
}

# Usage failures happen before the lock and the log exist, so they take the short
# path. Every one of them still prints a RESULT line.
usage_die() { # message
  printf 'STOP [10] %s\n' "$*" >&2
  result_line STOPPED 10
  exit 10
}

# ------------------------------------------------- attended-boundary refusals
#
# These are not unknown arguments. They name capabilities this surface
# deliberately does not have, so each one gets its own actionable refusal rather
# than a generic parse error. Failing closed here is the point: a request for
# unattended or multi-hop behaviour must never be silently downgraded into an
# attended one-hop run that then reports success.
refuse_flag() { # flag
  case "$1" in
    --unattended|--contained|--sandbox)
      usage_die "'$1' is refused: this is the attended surface and it has no unattended mode. An attended hop runs --permission-mode default and asks; it is not contained. Run the hop attended, or stop." ;;
    --loop|--max-hops|--carry-all|--continue|--hops|--until-operator)
      usage_die "'$1' is refused: this surface carries exactly ONE hop per invocation. To carry the next turn, read logs/work-loop/<task>.md, confirm the turn moved, and invoke this script again." ;;
    --worktree|--create-worktree|--isolate)
      usage_die "'$1' is refused: this surface creates no worktree. Create the checkout yourself and pass it with --checkout." ;;
    --hook|--daemon|--watch|--install|--service)
      usage_die "'$1' is refused: this surface installs nothing and watches nothing. It runs once, in the foreground, and exits." ;;
    --dangerously-skip-permissions|--bypass-permissions|--permission-mode)
      usage_die "'$1' is refused: attended Claude hops are always launched with --permission-mode default and that is not adjustable. Narrow the child further with --claude-deny if you need to." ;;
    --actor-cmd|--simulate|--fake-actor)
      usage_die "'$1' is refused: there is no simulated-actor seam on this surface, so no run of it can report simulated transport as live. Point --claude-bin or --codex-bin at the binary you want launched." ;;
    --status)
      usage_die "'$1' is refused: this surface reports no out-of-band status. The state file is the status — read logs/work-loop/<task>.md. If a carry is already in flight in this checkout this script exits 17 and names the holding pid and task." ;;
  esac
  return 1
}

# ---------------------------------------------------------------- arguments

while [ $# -gt 0 ]; do
  refuse_flag "$1"
  case "$1" in
    --checkout)    CHECKOUT="${2:-}"; shift 2 ;;
    --task)        TASK="${2:-}"; shift 2 ;;
    --timeout)     ACTOR_TIMEOUT="${2:-}"; shift 2 ;;
    --codex-bin)   CODEX_BIN="${2:-}"; shift 2 ;;
    --claude-bin)  CLAUDE_BIN="${2:-}"; shift 2 ;;
    --allow-path)  ALLOW_PATHS+=("${2:-}"); shift 2 ;;
    --claude-deny) CLAUDE_DENY+=("${2:-}"); shift 2 ;;
    --log-dir)     LOG_DIR="${2:-}"; shift 2 ;;
    --dry-run)     DRY_RUN=1; shift ;;
    # Print the whole leading comment block, whatever length it grows to, so the
    # exit-code table cannot drift out of the help output.
    -h|--help)     awk 'NR==1{next} /^#/{print; next} {exit}' "${BASH_SOURCE[0]}"; exit 0 ;;
    *)             usage_die "unknown argument: $1" ;;
  esac
done

[ -n "$CHECKOUT" ] || usage_die "--checkout is required"
[ -n "$TASK" ]     || usage_die "--task is required"
case "$ACTOR_TIMEOUT" in ''|*[!0-9]*) usage_die "--timeout must be a positive integer" ;; esac
[ "$ACTOR_TIMEOUT" -ge 1 ] || usage_die "--timeout must be >= 1"

if [ "${#ALLOW_PATHS[@]}" -eq 0 ]; then
  ALLOW_PATHS=('^logs/work-loop/' '^logs/harness-runs/')
fi

[ "$DRY_RUN" -eq 1 ] && R_MODE="dry-run"

# ------------------------------------------------- task id and path safety
# Rejected before any path is built, so a hostile id never reaches the filesystem.
case "$TASK" in
  */*|*'\'*|..|.|*..*|"")
    printf 'STOP [12] task id rejected (path traversal or separator): %s\n' "$TASK" >&2
    result_line STOPPED 12; exit 12 ;;
esac
if ! printf '%s' "$TASK" | grep -qE '^[A-Za-z0-9][A-Za-z0-9._-]*$'; then
  printf 'STOP [12] task id rejected (illegal characters): %s\n' "$TASK" >&2
  result_line STOPPED 12; exit 12
fi

[ -d "$CHECKOUT" ] || { printf 'STOP [11] checkout is not a directory: %s\n' "$CHECKOUT" >&2; result_line STOPPED 11; exit 11; }
CHECKOUT="$(cd "$CHECKOUT" && pwd -P)" || { printf 'STOP [11] cannot canonicalize checkout\n' >&2; result_line STOPPED 11; exit 11; }
git -C "$CHECKOUT" rev-parse --git-dir >/dev/null 2>&1 \
  || { printf 'STOP [11] not a git checkout: %s\n' "$CHECKOUT" >&2; result_line STOPPED 11; exit 11; }

STATE_DIR="$CHECKOUT/logs/work-loop"
STATE_FILE="$STATE_DIR/$TASK.md"

# Belt and braces: even after the id checks, the resolved file must sit directly
# inside the state directory. A symlink pointing out of the tree fails here.
if [ -e "$STATE_FILE" ]; then
  RESOLVED_DIR="$(cd "$(dirname "$STATE_FILE")" && pwd -P)"
  [ "$RESOLVED_DIR" = "$(cd "$STATE_DIR" && pwd -P)" ] \
    || { printf 'STOP [12] resolved state file escapes logs/work-loop/\n' >&2; result_line STOPPED 12; exit 12; }
fi

[ -n "$LOG_DIR" ] || LOG_DIR="$CHECKOUT/logs/harness-runs"

# --------------------------------------------------------- state file reading
# Read-only throughout. This script never writes the state file.

fm_value() { # file key -> value on stdout, empty if absent
  awk -v k="$2" '
    NR==1 { if ($0 != "---") exit; inb=1; next }
    inb && $0 == "---" { exit }
    inb {
      pfx = k ":"
      if (substr($0, 1, length(pfx)) == pfx) {
        v = substr($0, length(pfx) + 1)
        sub(/^[ \t]+/, "", v); sub(/[ \t]*#.*$/, "", v); sub(/[ \t]+$/, "", v)
        print v; exit
      }
    }' "$1"
}

file_hash() { shasum -a 256 "$1" 2>/dev/null | cut -d' ' -f1; }

validate_state() { # sets ST_TURN; dies on any failure. Never mutates.
  [ -f "$STATE_FILE" ] || die 13 "state file missing: $STATE_FILE"
  [ -r "$STATE_FILE" ] || die 13 "state file unreadable: $STATE_FILE"

  local declared
  declared="$(fm_value "$STATE_FILE" task)"
  [ -n "$declared" ] || die 14 "no readable 'task:' frontmatter in $STATE_FILE"
  if [ "$declared" != "$TASK" ]; then
    die 14 "identity mismatch — you asked for task '$TASK', the file's frontmatter says task: '$declared'. Nothing was launched and nothing was changed."
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

# Working-tree lines, split by the allowlist. Both halves are needed, and for
# different reasons: the foreign half decides whether to stop, the allowed half
# is the partial work an operator has to be told about when a hop does not
# finish. Reporting only the foreign half made allowed partial effects invisible.
worktree_lines() { # allowed | foreign
  local want="$1" line p allowed re
  git -C "$CHECKOUT" status --porcelain 2>/dev/null | while IFS= read -r line; do
    p="${line:3}"; p="${p%\"}"; p="${p#\"}"
    allowed=0
    for re in "${ALLOW_PATHS[@]}"; do
      if printf '%s' "$p" | grep -qE "$re"; then allowed=1; break; fi
    done
    if [ "$want" = "allowed" ]; then
      [ "$allowed" -eq 1 ] && printf '%s\n' "$line"
    else
      [ "$allowed" -eq 0 ] && printf '%s\n' "$line"
    fi
  done | sort
}

foreign_worktree() { worktree_lines foreign; }
allowed_worktree() { worktree_lines allowed; }

# Lines present after the hop that were not present before it.
#
# This is the ONLY honest basis for saying a change belongs to THIS hop. Anything
# already in the working tree at launch belongs to whoever left it there, and
# attributing it to the actor is how a launcher ends up asserting that Claude
# edited a file Claude never touched. Both inputs come from worktree_lines, which
# sorts, so comm's precondition holds.
new_lines() { # before-block, after-block
  comm -13 <(printf '%s\n' "$1" | sed '/^$/d') <(printf '%s\n' "$2" | sed '/^$/d')
}

count_lines() { # block -> number of non-empty lines
  [ -n "$1" ] || { printf '0'; return 0; }
  printf '%s\n' "$1" | sed '/^$/d' | wc -l | tr -d ' '
}

staged_paths() { git -C "$CHECKOUT" diff --cached --name-only 2>/dev/null | sort; }

# ------------------------------------------------------ permission evidence
#
# A Claude hop launched with --output-format json ends by printing one result
# object carrying `permission_denials`: an array of
#   {tool_name, tool_use_id, tool_input}
# Verified against Claude Code 2.1.220 on 2026-08-13 by forcing a PreToolUse deny
# hook and reading the captured object. That capture file already exists — this
# reads it, and nothing new is stored.
#
# THREE states, not two, and the third is the whole point:
#   present     denials were recorded, and they are listed
#   empty       the field was read and is empty — a positive "no denials"
#   unavailable no capture, not JSON, no jq, or no such field
# Collapsing `unavailable` into `empty` would turn missing evidence into a clean
# bill of health, which is exactly the dishonest stop this unit exists to remove.
DENIAL_STATE="n/a"     # n/a | present | empty | unavailable
DENIALS_JSON=""

read_denials() { # capture-file
  DENIAL_STATE="unavailable"; DENIALS_JSON=""
  local f="$1" out
  command -v jq >/dev/null 2>&1 || return 0
  [ -s "$f" ] || return 0

  # The capture holds the actor's stdout AND stderr, so it is not guaranteed to
  # be pure JSON. Take the last value that parses as an object carrying the
  # field, first over the file as a whole, then line by line if that fails.
  out="$(jq -c 'select(type=="object" and has("permission_denials")) | .permission_denials' "$f" 2>/dev/null | tail -1)"
  if [ -z "$out" ]; then
    out="$(grep -o '^{.*}$' "$f" 2>/dev/null | while IFS= read -r l; do
             printf '%s' "$l" | jq -c 'select(type=="object" and has("permission_denials")) | .permission_denials' 2>/dev/null
           done | tail -1)"
  fi
  [ -n "$out" ] || return 0

  DENIALS_JSON="$out"
  if [ "$(printf '%s' "$out" | jq -r 'length' 2>/dev/null)" = "0" ]; then
    DENIAL_STATE="empty"
  else
    DENIAL_STATE="present"
  fi
  return 0
}

denial_count() {
  [ "$DENIAL_STATE" = "present" ] || { printf '0'; return 0; }
  printf '%s' "$DENIALS_JSON" | jq -r 'length' 2>/dev/null || printf '0'
}

# One line per denial: the tool, and the most target-like field of its input.
denial_lines() {
  [ "$DENIAL_STATE" = "present" ] || return 0
  printf '%s' "$DENIALS_JSON" | jq -r '
    .[] | "    - " + (.tool_name // "unknown tool") + " — "
        + (( .tool_input.file_path // .tool_input.path // .tool_input.command
           // .tool_input.url // .tool_input.pattern // (.tool_input | tojson) )
           | tostring | .[0:160])' 2>/dev/null
}

# Paths the actor COMMITTED that the allowlist does not cover. Detection, not
# prevention: the commit already happened by the time this runs. The value is
# stopping visibly instead of reporting a clean carry over it.
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

# Deliberately asymmetric, because the two sides differ (core § 4). Codex writes
# the file and never runs git, so an uncommitted file with turn: claude is the
# EXPECTED handoff. Claude commits, so an uncommitted file after a Claude hop
# means the hop died between editing and committing.
state_dirty() {
  [ -n "$(git -C "$CHECKOUT" status --porcelain -- "logs/work-loop/$TASK.md" 2>/dev/null)" ]
}

# Repository conditions an actor must never be launched on top of, because a
# second writer compounds them into something no automated step can unpick.
git_hazards() {
  local gd
  gd="$(git -C "$CHECKOUT" rev-parse --absolute-git-dir 2>/dev/null)" || return 0
  [ -e "$gd/index.lock" ]       && printf 'a Git index.lock is held (%s)\n' "$gd/index.lock"
  [ -e "$gd/MERGE_HEAD" ]       && printf 'a merge is in progress (MERGE_HEAD)\n'
  [ -d "$gd/rebase-merge" ]     && printf 'a rebase is in progress (rebase-merge)\n'
  [ -d "$gd/rebase-apply" ]     && printf 'a rebase or am is in progress (rebase-apply)\n'
  [ -e "$gd/CHERRY_PICK_HEAD" ] && printf 'a cherry-pick is in progress (CHERRY_PICK_HEAD)\n'
  [ -e "$gd/REVERT_HEAD" ]      && printf 'a revert is in progress (REVERT_HEAD)\n'
  return 0
}

# Is this file a core § 4 closing record? The heading sequence must be EXACTLY
# the four, once each, in order, with nothing else surviving. Section contents
# are deliberately not validated — those are the actors' business.
closing_record_ok() {
  local heads
  heads="$(grep -E '^## ' "$STATE_FILE" 2>/dev/null | sed 's/[[:space:]]*$//')"
  [ "$heads" = "$(printf '## Outcome\n## Decisions that matter\n## Evidence\n## Accepted limitations')" ]
}

# The state file's operator-facing content, for the stop message. Bounded so a
# long brief cannot flood the run log.
operator_question() {
  awk '
    /^## (Blocker|Next action)$/ { keep=1; print; next }
    /^## / { keep=0 }
    keep && n < 24 { print; n++ }
  ' "$STATE_FILE" 2>/dev/null
}

# ------------------------------------------------------------------- lock
# One actor at a time, PER CHECKOUT. mkdir is the atomic primitive.
#
# The key is the canonical checkout path and nothing else. A checkout is a single
# working tree with a single index and a single HEAD, so two actors in it are two
# writers to one surface no matter which tasks they carry — keying the lock by
# checkout+task made the id the isolation boundary, and two different task ids
# were therefore admitted side by side in one checkout.
#
# The task is still recorded, in the lock directory rather than in the key, so a
# refusal names WHICH task holds the checkout. That keeps task identity in
# validation and in the evidence while taking it out of the ownership decision.
# Exact task/state identity remains a separate invariant (validate_state); this
# is about write authority over a working tree, not about which file is correct.
#
# A separate linked worktree canonicalizes to a different path, so it takes a
# different lock and stays independently admissible. That is the intended unit of
# isolation: give a concurrent task its own checkout.
#
# NOT the durable checkout declaration in logs/scripts/work-loop-owner.sh. That
# one is a committed-repository record of which task owns a checkout across
# sessions; this one is an ephemeral live-process lock under $TMPDIR that exists
# only while an actor runs. The two are deliberately separate and neither is a
# registry of the other.
#
# Three pid states, not two. A lock whose holder cannot be inspected is treated
# as held: the failure mode of guessing "stale" is two live actors in one
# checkout, which is the thing this exists to prevent.

acquire_lock() {
  local key holder holder_task lock_path
  key="$(printf '%s' "$CHECKOUT" | shasum -a 256 | cut -c1-16)"
  LOCK_DIR="${TMPDIR:-/tmp}/axcion-harness-v0.2.$key.lock"
  lock_path="$LOCK_DIR"

  if ! mkdir "$LOCK_DIR" 2>/dev/null; then
    holder="$(cat "$LOCK_DIR/pid" 2>/dev/null)"
    holder_task="$(cat "$LOCK_DIR/task" 2>/dev/null)"
    if [ -n "$holder" ] && kill -0 "$holder" 2>/dev/null; then
      LOCK_DIR=""   # not ours; must not be released on the way out
      die 17 "another carry is in flight for this CHECKOUT (pid $holder, task '${holder_task:-unrecorded}', holds $lock_path). One checkout is one working tree, so it carries one task at a time — this is refused whether or not it is the same task. Wait for it, or stop it, then re-run. To run '$TASK' concurrently, give it its own linked worktree and pass that with --checkout."
    fi
    if [ -z "$holder" ]; then
      LOCK_DIR=""
      die 17 "a lock directory exists for this checkout but carries no readable pid, so it cannot be shown stale ($lock_path, task '${holder_task:-unrecorded}'). Nothing was deleted. Inspect it and remove it by hand if no carry is running."
    fi
    say "note: removing a stale lock — pid $holder (task '${holder_task:-unrecorded}') is not running."
    rm -rf "$LOCK_DIR"
    mkdir "$LOCK_DIR" 2>/dev/null || { LOCK_DIR=""; die 17 "could not take the lock after clearing a stale one"; }
  fi
  printf '%s\n' "$$" >"$LOCK_DIR/pid"
  printf '%s\n' "$TASK" >"$LOCK_DIR/task"
}

release_lock() {
  [ -n "$LOCK_DIR" ] && [ -d "$LOCK_DIR" ] && rm -rf "$LOCK_DIR"
  LOCK_DIR=""
  return 0
}

# ------------------------------------------------------- interruption

terminate_actor_group() { # pgid
  local pgid="$1" waited=0
  [ -n "$pgid" ] || return 0
  kill -TERM "-$pgid" 2>/dev/null
  while [ "$waited" -lt "$TERM_GRACE_SECS" ]; do
    kill -0 "-$pgid" 2>/dev/null || return 0
    sleep 1; waited=$((waited + 1))
  done
  kill -KILL "-$pgid" 2>/dev/null
  sleep "$KILL_SETTLE_SECS"
  if kill -0 "-$pgid" 2>/dev/null; then
    say "WARNING: process group $pgid could not be confirmed gone after SIGKILL — inspect before re-running."
    return 1
  fi
  return 0
}

on_signal() { # signal name
  SHUTDOWN=1
  say ""
  say "$1 received — terminating the actor and stopping."
  terminate_actor_group "$ACTOR_PGID"
  ACTOR_PGID=""
  die 28 "interrupted by $1 (task '$TASK'). The actor's process group was terminated. NOT retried — the signal may have landed after a partial effect. Read $STATE_FILE and \`git -C $CHECKOUT status\` before re-running."
}
trap 'on_signal SIGINT' INT
trap 'on_signal SIGTERM' TERM

# ------------------------------------------------------------- actor launch

# Wall-clock bound without timeout(1), which is not installed on this platform.
# `set -m` before backgrounding makes the actor a process-group leader (pgid ==
# its own pid, distinct from this script's). Without it the actor shares this
# script's group and neither the timeout nor the signal handler can reach its
# descendants.
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
file in that directory — unrelated files live there. Read that one file, take
your turn on it, and set turn: for whoever moves next.

You do not run git. Claude commits.
EOF
}

launch_actor() { # actor, timeout -> exit status of the launch
  local actor="$1" limit="$2"
  local out="$LOG_DIR/$RUN_ID.$actor.out"
  : >"$out"
  # Published so the classifier can read the actor's own account of the hop —
  # for Claude, that is where permission_denials lands.
  ACTOR_CAPTURE="$out"

  case "$actor" in
    codex)
      [ -x "$CODEX_BIN" ] || die 20 "codex binary not executable: $CODEX_BIN"
      local cv; cv="$("$CODEX_BIN" --version 2>&1 | head -1)"
      say "  launch: actor=codex timeout=${limit}s bin=$CODEX_BIN version=$cv"
      say "  cmd: codex exec --sandbox workspace-write -C <checkout> --json <prompt>"
      run_bounded "$limit" "$out" \
        "$CODEX_BIN" exec --sandbox workspace-write -C "$CHECKOUT" --json "$(codex_prompt)"
      return $?
      ;;
    claude)
      local cb="$CLAUDE_BIN"
      [ -n "$cb" ] || cb="$(command -v claude 2>/dev/null)"
      [ -n "$cb" ] && [ -x "$cb" ] || die 20 "claude binary not resolvable (looked at --claude-bin, then PATH)"
      local vv; vv="$("$cb" --version 2>&1 | head -1)"
      say "  launch: actor=claude timeout=${limit}s bin=$cb version=$vv"
      # Deliberately NOT a subshell. A subshell would confine run_bounded's
      # assignment to ACTOR_PGID, leaving the signal handler with nothing to
      # terminate on exactly the hop that matters most. cd and restore instead.
      local prev_pwd="$PWD" rc_claude
      cd "$CHECKOUT" || die 11 "cannot enter checkout: $CHECKOUT"
      if [ "${#CLAUDE_DENY[@]}" -gt 0 ]; then
        say "  cmd: claude -p '/work-loop-v2 $TASK' --output-format json --permission-mode default --disallowedTools ${CLAUDE_DENY[*]} (cwd=<checkout>)"
        run_bounded "$limit" "$out" "$cb" -p "/work-loop-v2 $TASK" --output-format json \
          --permission-mode default \
          --disallowedTools "${CLAUDE_DENY[@]}"
      else
        say "  cmd: claude -p '/work-loop-v2 $TASK' --output-format json --permission-mode default (cwd=<checkout>)"
        run_bounded "$limit" "$out" "$cb" -p "/work-loop-v2 $TASK" --output-format json \
          --permission-mode default
      fi
      rc_claude=$?
      cd "$prev_pwd" || true
      return "$rc_claude"
      ;;
    *) die 15 "cannot launch actor '$actor'" ;;
  esac
}

# ------------------------------------------------- post-hop classification
#
# ONE evidence set, gathered once for every outcome, and ONE ordered verdict over
# it.
#
# The launcher used to decide from independent branches sitting in the order they
# were written. Three things went wrong with that. Evidence was gathered only on
# the paths that happened to need it, so a hop that failed or timed out reported
# nothing about what it had already changed. Precedence was an accident of layout
# rather than a decision. And one branch asserted more than the evidence
# supported: an uncommitted state file was reported as "Claude edited it" even
# when the file was already uncommitted at launch and this hop left it
# byte-identical — the launcher blamed an actor for another writer's dirt.
#
# So: gather_evidence sets every fact, classify_hop is the single place
# precedence lives, and report_hop prints the same evidence block whatever the
# verdict. Adding a new outcome means adding one rule in one ordered list.

V_CODE=0
V_OUTCOME="CARRIED"
V_MSG=""
V_FIX=""

# V_OUTCOME names the classification on screen. It is deliberately NOT the
# RESULT line's outcome field: that stays the four transport words the contract
# already documents (CARRIED, OPERATOR_TERMINAL, STOPPED, VALIDATED), so a
# classification added here can never silently change the machine-readable
# vocabulary a reader parses.
verdict() { V_CODE="$1"; V_OUTCOME="$2"; V_MSG="$3"; V_FIX="${4:-}"; }

gather_evidence() {
  after_hash="$(file_hash "$STATE_FILE")"
  after_head="$(git_head)"
  after_foreign="$(foreign_worktree)"
  after_allowed="$(allowed_worktree)"
  new_foreign="$(new_lines "$before_foreign" "$after_foreign")"
  new_allowed="$(new_lines "$before_allowed" "$after_allowed")"
  after_dirty=0; state_dirty && after_dirty=1

  committed_bad=""
  if [ "$before_head" != "$after_head" ]; then
    committed_bad="$(committed_foreign "$before_head" "$after_head")"
  fi

  # Read permissively. validate_state would die here, and a hop that corrupted
  # the file still has evidence worth printing before anything is reported.
  after_task="$(fm_value "$STATE_FILE" task 2>/dev/null)"
  after_turn="$(fm_value "$STATE_FILE" turn 2>/dev/null)"
  R_AFTER="${after_turn:-none}"

  # Only a Claude hop reports permission evidence, so only a Claude hop can be
  # missing it. Running the reader on a Codex hop would print "NO EVIDENCE" for a
  # surface that never emits any, which is noise dressed as a finding.
  if [ "$before_turn" = "claude" ]; then
    read_denials "$ACTOR_CAPTURE"
  else
    DENIAL_STATE="n/a"; DENIALS_JSON=""
  fi
  case "$DENIAL_STATE" in
    present)     R_DENIALS="$(denial_count)" ;;
    empty)       R_DENIALS="0" ;;
    unavailable) R_DENIALS="unavailable" ;;
    *)           R_DENIALS="n/a" ;;
  esac
  R_PARTIAL="$(count_lines "$new_allowed")"
}

classify_hop() {
  local pre eff fault

  # 1. An effect outside the allowlist outranks everything, including a failed or
  #    timed-out actor. A hop that escaped its boundary is the more urgent fact,
  #    and reporting it as a plain actor failure would bury it.
  if [ "$before_foreign" != "$after_foreign" ]; then
    verdict 24 UNEXPECTED_EFFECT \
      "actor '$before_turn' changed paths outside the allowlist." \
      "Inspect the out-of-allowlist paths listed above. Widen --allow-path if the unit legitimately touches them, or revert them; then re-run."
    return
  fi

  # 2. Codex never runs git (core § 4). Ordered ahead of the commit check so a
  #    Codex hop that moved HEAD reads as the protocol violation it is.
  if [ "$before_turn" = "codex" ] && [ "$before_head" != "$after_head" ]; then
    verdict 24 UNEXPECTED_EFFECT \
      "Codex moved HEAD ($before_head -> $after_head) — Codex never runs git (core § 4)." \
      "Inspect \`git -C $CHECKOUT log $before_head..$after_head\` and decide whether to keep or revert those commits. Claude owns every commit for this task."
    return
  fi

  # 3. Committed outside the allowlist. Detection, not prevention.
  if [ -n "$committed_bad" ]; then
    verdict 30 UNEXPECTED_COMMIT \
      "actor '$before_turn' COMMITTED paths outside the allowlist ($before_head -> $after_head). The commit already exists — this stops rather than reporting a clean carry over it." \
      "Inspect \`git -C $CHECKOUT diff $before_head $after_head\`. If the work is wanted, widen --allow-path; if it is not, revert those commits."
    return
  fi

  # 4-5. The actor did not finish. Any partial effect it left is in the evidence
  #      block above, which is the change: these used to report nothing at all.
  if [ "$rc" -eq 124 ]; then
    verdict 21 ACTOR_TIMEOUT \
      "actor '$before_turn' exceeded ${ACTOR_TIMEOUT}s and was terminated." \
      "Read $STATE_FILE and any attributable changes listed above before re-running — a killed actor can leave a partial effect. Never retried."
    return
  fi
  if [ "$rc" -ne 0 ]; then
    verdict 20 ACTOR_FAILED \
      "actor '$before_turn' exited $rc after ${duration}s — not retried, because one invocation is one hop and you are watching this one." \
      "Read the capture at $ACTOR_CAPTURE together with any attributable changes listed above, then decide. This script never relaunches an actor."
    return
  fi

  # 6. The file must still be this task's, and readable, before any verdict over
  #    its contents means anything. Same invariants validate_state enforces at
  #    entry; applied here so they participate in the ordering instead of
  #    exiting around it.
  if [ ! -f "$STATE_FILE" ] || [ ! -r "$STATE_FILE" ]; then
    verdict 13 STATE_MISSING "the state file is gone or unreadable after the hop: $STATE_FILE" \
      "Restore it with \`git -C $CHECKOUT show HEAD:logs/work-loop/$TASK.md\`, then re-run."
    return
  fi
  if [ "$after_task" != "$TASK" ]; then
    verdict 14 IDENTITY_MISMATCH \
      "identity mismatch after the hop — you asked for task '$TASK', the file's frontmatter now says task: '${after_task:-<absent>}'." \
      "Read the file. The actor rewrote its identity; restore the correct task: line before re-running."
    return
  fi
  case "$after_turn" in
    codex|claude|operator) : ;;
    "") verdict 15 BAD_TURN "no readable 'turn:' frontmatter in $STATE_FILE after the hop" \
          "Read the file and restore a turn: of codex, claude or operator."
        return ;;
    *)  verdict 15 BAD_TURN "turn: '$after_turn' is not one of codex | claude | operator" \
          "Read the file and restore a valid turn:."
        return ;;
  esac

  # 7. Claude left its own handback uncommitted — but ONLY if this hop actually
  #    changed the file. A file already uncommitted at launch and byte-identical
  #    now was not edited by this actor, and saying otherwise is the dishonest
  #    stop this unit removes. The hash comparison is what makes the claim true.
  if [ "$before_turn" = "claude" ] && [ "$after_dirty" -eq 1 ] && [ "$after_hash" != "$before_hash" ]; then
    pre=""
    [ "$before_dirty" -eq 1 ] && pre=" NOTE: the file was ALREADY uncommitted before this hop, so part of that diff is not attributable to this actor."
    verdict 25 UNCOMMITTED_HANDBACK \
      "Claude changed logs/work-loop/$TASK.md during this hop and left it uncommitted — stopping rather than reporting a carry over a partial edit. A refused git permission looks exactly like this.$pre" \
      "Read \`git -C $CHECKOUT diff -- logs/work-loop/$TASK.md\` with the permission evidence above. Claude commits its own handback: re-run the Claude hop. Do not commit it on Claude's behalf, and do not ask Codex to — core § 4 assigns every commit to Claude."
    return
  fi

  # 8. Whether the hop handed back, worked out BEFORE it is judged.
  #
  # This has to be a computed fact rather than a verdict, because the next rule
  # needs it: a permission denial explains a hop that did NOT hand back, but a
  # denial on a hop that DID hand back is advisory — the turn moved anyway, and
  # report_hop states it on the success path. Judging denials before this was
  # wrong in exactly that case, and turned a completed carry into a failure.
  fault=""
  if [ "$after_hash" = "$before_hash" ]; then
    fault="actor '$before_turn' exited cleanly but left the state file byte-identical — no observable transition."
    [ "$before_dirty" -eq 1 ] && fault="$fault The file was already uncommitted before this hop, and it is unchanged now, so that dirt is NOT attributable to this actor."
  elif [ "$after_turn" = "$before_turn" ]; then
    fault="actor '$before_turn' edited the file but left turn: '$after_turn' unchanged — not an allowed transition."
  else
    # DEFENCE IN DEPTH, and deliberately so. Given rule 6 constrains turn: to the
    # three known values and the branch above rejects after == before, every pair
    # that can still reach this table is one the table allows — its reject branch
    # is unreachable today. It is kept because it is the only place the ALLOWED
    # set is written down: if a fourth turn value or a self-transition is ever
    # permitted upstream, this is what stops it silently becoming a valid carry.
    # The suite's fail-capability proof has to disable both guards at once to move
    # a bad transition through, which is the evidence that they are redundant
    # rather than that either is idle.
    case "$before_turn:$after_turn" in
      codex:claude|codex:operator|claude:codex|claude:operator) : ;;
      *) fault="transition $before_turn -> $after_turn is not allowed." ;;
    esac
  fi

  if [ -z "$fault" ]; then
    verdict 0 CARRIED "" ""
    return
  fi

  # 9. The hop did not hand back. If Claude was denied permission, that is the
  #    cause and it is named; otherwise the non-event is reported as itself.
  if [ "$DENIAL_STATE" = "present" ]; then
    if [ -n "$new_allowed" ]; then
      eff="Allowed changes attributable to this hop are listed above, so the repository is NOT unchanged."
    else
      eff="No working-tree change is attributable to this hop: the repository is unchanged."
    fi
    verdict 37 PERMISSION_DENIED \
      "Claude was denied permission $(denial_count) time(s) and the hop produced no valid handback: $fault The denied calls are listed above. $eff" \
      "Grant the denied tools above — narrow --claude-deny, or widen the checkout's own permissions — then re-run the hop. Nothing was retried and nothing was repaired."
    return
  fi

  verdict 22 NO_TRANSITION "$fault" \
    "Read $ACTOR_CAPTURE for what the actor actually did, together with any attributable changes listed above."
}

# The same block prints whatever the verdict, so an operator reads one shape and
# never has to work out which branch produced this particular screen.
report_hop() {
  local line
  say ""
  say "  evidence:"
  if [ "$after_hash" = "$before_hash" ]; then
    say "    state file:      byte-identical (sha256 $before_hash)"
  else
    say "    state file:      changed ($before_hash -> $after_hash)"
  fi
  say "    uncommitted:     before=$([ "$before_dirty" -eq 1 ] && echo yes || echo no) after=$([ "$after_dirty" -eq 1 ] && echo yes || echo no)"
  say "    turn:            $before_turn -> ${after_turn:-<unreadable>}"
  say "    HEAD:            $before_head -> $after_head"
  if [ "$before_head" != "$after_head" ]; then
    say "    commits:         $(git -C "$CHECKOUT" rev-list --count "$before_head".."$after_head" 2>/dev/null)"
  fi
  say "    actor:           $before_turn exit=$rc duration=${duration}s capture=$ACTOR_CAPTURE"

  case "$DENIAL_STATE" in
    present)
      say "    permission:      $(denial_count) DENIAL(S) recorded by Claude:"
      say "$(denial_lines)" ;;
    empty)
      say "    permission:      none recorded (Claude reported an empty permission_denials list)" ;;
    unavailable)
      say "    permission:      NO EVIDENCE — the capture carries no readable permission_denials." ;;
    *)
      say "    permission:      n/a (only a Claude hop reports permission evidence)" ;;
  esac
  [ "$DENIAL_STATE" = "unavailable" ] && \
    say "                     That is not the same as 'no denials'; treat it as unknown."

  # Attribution, always both halves. Pre-existing dirt is named separately so it
  # can never be read as something this hop did.
  if [ -n "$new_allowed" ]; then
    say "    allowed changes attributable to THIS hop ($(count_lines "$new_allowed")):"
    printf '%s\n' "$new_allowed" | sed 's/^/      /' | while IFS= read -r l; do say "$l"; done
  else
    say "    allowed changes attributable to THIS hop: none"
  fi
  if [ -n "$before_allowed" ]; then
    say "    (already present before launch, NOT this hop's: $(count_lines "$before_allowed") allowed path(s))"
  fi
  if [ "$before_foreign" != "$after_foreign" ]; then
    say "    outside the allowlist — delta introduced by this hop:"
    diff <(printf '%s\n' "$before_foreign") <(printf '%s\n' "$after_foreign") | sed 's/^/      /'
  fi
  if [ -n "$committed_bad" ]; then
    say "    committed outside the allowlist:"
    printf '%s\n' "$committed_bad" | sed 's/^/      /' | while IFS= read -r l; do say "$l"; done
  fi

  if [ "$V_CODE" -eq 0 ]; then
    say ""
    say "carried: the turn moved $before_turn -> $after_turn. One hop. Not continuing to '$after_turn'."
    if [ "$DENIAL_STATE" = "present" ]; then
      say "WARNING: the turn moved, but Claude was denied permission $(denial_count) time(s) — listed above."
      say "The handback may be narrower than the brief asked for. Read the state file before accepting it."
    fi
    if [ "$after_turn" = "operator" ]; then
      say "turn is now operator — automation is terminal there (core § 7)."
    fi
    say "read turn: from $STATE_FILE. Neither this exit code nor this screen is authoritative over the file (core § 4)."
    line="$(result_line CARRIED 0)"
    say "$line"
    release_lock
    exit 0
  fi

  say ""
  say "  classified: $V_OUTCOME (exit $V_CODE)"
  die "$V_CODE" "$V_MSG"$'\n'"Recoverable next action: $V_FIX"
}

# ------------------------------------------------------------------ the carry

acquire_lock

mkdir -p "$LOG_DIR" 2>/dev/null || die 11 "cannot create log directory: $LOG_DIR"
RUN_ID="$(date '+%Y%m%dT%H%M%S')-$$-$TASK"
RUN_LOG="$LOG_DIR/$RUN_ID.log"
: >"$RUN_LOG" 2>/dev/null || die 11 "cannot write run log: $RUN_LOG"

say "axcion-harness v0.2 — attended, one hop"
say "task=$TASK checkout=$CHECKOUT"
say "allow-path: ${ALLOW_PATHS[*]}"

validate_state
R_BEFORE="$ST_TURN"
say "initial: turn=$ST_TURN sha256=$(file_hash "$STATE_FILE") head=$(git_head)"

# Restart safety. Truth comes from the file and Git, never from an in-memory turn.
if state_dirty; then
  case "$ST_TURN" in
    claude)
      say "note: the state file is uncommitted with turn: claude — the expected Codex handoff (Codex never runs git)." ;;
    codex|operator)
      # No instruction to commit here. Core § 4 assigns every commit to Claude,
      # and this branch is read by whoever ran the script — so telling "you" to
      # commit it quietly reassigns Claude's commit to the reader, and reads as
      # an instruction to Codex when Codex is the one being launched.
      die 25 "the state file is uncommitted with turn: $ST_TURN — Claude commits, so a previous run died between editing and committing, or its commit was refused."$'\n'"This script will not commit it, and Codex must not: core § 4 assigns every commit to Claude."$'\n'"Recoverable next action: read \`git -C $CHECKOUT diff -- logs/work-loop/$TASK.md\` and decide. If it is Claude's complete handback, have Claude commit it; if it is partial, discard it and re-run the Claude hop." ;;
  esac
fi

# turn: operator is terminal for automation (core § 7). Checked before the
# hazard and allowlist gates, because nothing is going to be launched either way
# and a terminal task should report as terminal rather than as a dirty checkout.
if [ "$ST_TURN" = "operator" ]; then
  R_AFTER="operator"
  say "turn=operator — stopping for the operator (core § 7). Nothing launched."
  op_q="$(operator_question)"
  if [ -n "$op_q" ]; then
    say "The question below is UNANSWERED. Neither model nor this script answered it,"
    say "and nothing here is a decision — the operator owns it (core § 7)."
    say "--- state file, as the actors left it ---"
    say "$op_q"
    say "--- end ---"
  elif closing_record_ok; then
    say "The task is CLOSED: the state file carries the core § 4 closing record and"
    say "nothing else. There is no unanswered question here."
    say "The closing record is at $STATE_FILE."
  else
    die 26 "turn: operator, but $STATE_FILE is neither a core § 7 question (no ## Blocker, no ## Next action) nor a core § 4 closing record (its headings are: $(grep -E '^## ' "$STATE_FILE" 2>/dev/null | tr '\n' ' ' | sed 's/ *$//'))."$'\n'"Recoverable next action: read the file. If a hop died mid-write, restore or complete it, then re-run. Nothing was launched."
  fi
  line="$(result_line OPERATOR_TERMINAL 0)"
  say "$line"
  release_lock
  exit 0
fi

if [ "$DRY_RUN" -eq 1 ]; then
  say "dry-run: would launch actor '$ST_TURN' for task '$TASK' and stop after that one hop; launching nothing."
  dr_haz="$(git_hazards)"
  [ -n "$dr_haz" ] && say "dry-run: repository hazards present — a live carry would stop:"$'\n'"$dr_haz"
  dr_foreign="$(foreign_worktree)"
  [ -n "$dr_foreign" ] && say "dry-run: out-of-allowlist working-tree changes present — a live carry would stop:"$'\n'"$dr_foreign"
  R_ACTOR="$ST_TURN"
  line="$(result_line VALIDATED 0)"
  say "$line"
  release_lock
  exit 0
fi

hazards="$(git_hazards)"
if [ -n "$hazards" ]; then
  die 19 "the checkout is in a hazardous Git state before launching $ST_TURN — task '$TASK':"$'\n'"$hazards"$'\n'"Recoverable next action: finish or abort the operation above, then re-run."
fi

staged="$(staged_paths)"
if [ -n "$staged" ]; then
  die 16 "paths are already staged before launching $ST_TURN:"$'\n'"$staged"$'\n'"Recoverable next action: commit or unstage them, then re-run. This script will not sweep another writer's work into an actor's commit."
fi

before_foreign="$(foreign_worktree)"
if [ -n "$before_foreign" ]; then
  die 18 "out-of-allowlist working-tree changes are already present before launching $ST_TURN — task '$TASK':"$'\n'"$before_foreign"$'\n'"Recoverable next action: commit, stash or revert the paths above, or widen --allow-path if the unit legitimately touches them, then re-run."
fi

before_hash="$(file_hash "$STATE_FILE")"
before_turn="$ST_TURN"
before_head="$(git_head)"
before_dirty=0; state_dirty && before_dirty=1
before_allowed="$(allowed_worktree)"

R_ACTOR="$before_turn"
say ""
say "hop: actor=$before_turn"
say "  before: sha256=$before_hash turn=$before_turn head=$before_head"

started="$(date '+%s')"
launch_actor "$before_turn" "$ACTOR_TIMEOUT"
rc=$?
duration=$(( $(date '+%s') - started ))

# Evidence first, verdict second, report third — for EVERY outcome, including a
# timed-out or failed actor. A hop that did not finish can still have changed the
# repository, and the operator has to be told what it left behind.
gather_evidence
classify_hop
report_hop
