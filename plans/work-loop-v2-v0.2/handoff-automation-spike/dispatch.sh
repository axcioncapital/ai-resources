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
#   --codex-bin PATH    default /Applications/ChatGPT.app/Contents/Resources/codex
#   --claude-bin PATH   default: `claude` resolved from PATH
#   --allow-path RE     repeatable regex of repo-relative paths actors may change
#   --log-dir DIR       run evidence directory (default <spike>/runs)
#   --dry-run           validate and route; launch nothing
#   --actor-cmd CMD     TEST SEAM. Replaces the live product launch with CMD.
#                       Marks the run mode=simulated in all evidence so a
#                       simulated pass can never be read as live transport.
#
# Exit codes — 0 is the ONLY success, and it means the loop reached turn: operator.
#   0   STOP_OPERATOR          terminal for automation (core § 7)
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
#
# Note that 0 is returned by --help and by a completed --dry-run too. Only in
# loop mode does 0 additionally mean "reached turn: operator".

set -uo pipefail

SPIKE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CHECKOUT=""
TASK=""
MAX_HOPS=4
ACTOR_TIMEOUT=900
CODEX_BIN="/Applications/ChatGPT.app/Contents/Resources/codex"
CLAUDE_BIN=""
LOG_DIR=""
DRY_RUN=0
ACTOR_CMD=""
ALLOW_PATHS=()

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
    --codex-bin)   CODEX_BIN="${2:-}"; shift 2 ;;
    --claude-bin)  CLAUDE_BIN="${2:-}"; shift 2 ;;
    --allow-path)  ALLOW_PATHS+=("${2:-}"); shift 2 ;;
    --log-dir)     LOG_DIR="${2:-}"; shift 2 ;;
    --actor-cmd)   ACTOR_CMD="${2:-}"; shift 2 ;;
    --dry-run)     DRY_RUN=1; shift ;;
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

if [ "${#ALLOW_PATHS[@]}" -eq 0 ]; then
  ALLOW_PATHS=('^logs/work-loop/' '^plans/work-loop-v2-v0\.2/handoff-automation-spike/')
fi

MODE="live"
[ -n "$ACTOR_CMD" ] && MODE="simulated"
[ "$DRY_RUN" -eq 1 ] && MODE="dry-run"

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
trap 'release_lock' EXIT INT TERM

acquire_lock

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

say "run=$RUN_ID mode=$MODE task=$TASK"
say "checkout=$CHECKOUT"
say "state=$STATE_FILE"
say "max_hops=$MAX_HOPS timeout=${ACTOR_TIMEOUT}s"
say "allow_paths=${ALLOW_PATHS[*]}"

# ------------------------------------------------------- state file reading
# Read-only throughout. This dispatcher never writes the state file; only the
# actors do (core § 4 — Claude commits, Codex writes the brief).

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
run_bounded() { # timeout, logfile, cmd...
  local limit="$1"; shift
  local out="$1"; shift
  local pid start rc

  "$@" >>"$out" 2>&1 &
  pid=$!
  start="$(date '+%s')"

  while kill -0 "$pid" 2>/dev/null; do
    if [ "$(( $(date '+%s') - start ))" -ge "$limit" ]; then
      pkill -TERM -P "$pid" 2>/dev/null
      kill -TERM "$pid" 2>/dev/null
      sleep 2
      pkill -KILL -P "$pid" 2>/dev/null
      kill -KILL "$pid" 2>/dev/null
      wait "$pid" 2>/dev/null
      return 124
    fi
    sleep 1
  done

  wait "$pid"; rc=$?
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

launch_actor() { # actor -> exit status of the launch
  local actor="$1" hop="$2"
  local out="$LOG_DIR/$RUN_ID.hop$hop.$actor.out"
  : >"$out"

  if [ -n "$ACTOR_CMD" ]; then
    say "  launch: mode=simulated cmd=$ACTOR_CMD"
    WL_ACTOR="$actor" WL_TASK="$TASK" WL_CHECKOUT="$CHECKOUT" \
    WL_STATE_FILE="$STATE_FILE" WL_HOP="$hop" \
      run_bounded "$ACTOR_TIMEOUT" "$out" bash -c "$ACTOR_CMD"
    return $?
  fi

  case "$actor" in
    codex)
      [ -x "$CODEX_BIN" ] || die 20 "codex binary not executable: $CODEX_BIN"
      local cv; cv="$("$CODEX_BIN" --version 2>&1 | head -1)"
      say "  launch: mode=live actor=codex bin=$CODEX_BIN version=$cv"
      say "  cmd: codex exec --sandbox workspace-write -C <checkout> --json <prompt>"
      run_bounded "$ACTOR_TIMEOUT" "$out" \
        "$CODEX_BIN" exec --sandbox workspace-write -C "$CHECKOUT" --json "$(codex_prompt)"
      return $?
      ;;
    claude)
      local cb="$CLAUDE_BIN"
      [ -n "$cb" ] || cb="$(command -v claude 2>/dev/null)"
      [ -n "$cb" ] && [ -x "$cb" ] || die 20 "claude binary not resolvable"
      local vv; vv="$("$cb" --version 2>&1 | head -1)"
      say "  launch: mode=live actor=claude bin=$cb version=$vv"
      # No --dangerously-skip-permissions. The project's own settings.json
      # already declares defaultMode: bypassPermissions; the child inherits the
      # project's normal policy and this dispatcher widens nothing.
      say "  cmd: claude -p '/work-loop-v2 $TASK' --output-format json (cwd=<checkout>)"
      ( cd "$CHECKOUT" && run_bounded "$ACTOR_TIMEOUT" "$out" \
          "$cb" -p "/work-loop-v2 $TASK" --output-format json )
      return $?
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
  say "dry-run: would launch actor '$ST_TURN' for task '$TASK'; launching nothing."
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
    say "The question below is UNANSWERED. Neither model nor this dispatcher answered it,"
    say "and nothing here is a decision — the operator owns it (core § 7)."
    say "--- state file, as the actors left it ---"
    say "$(operator_question)"
    say "--- end ---"
    release_lock
    exit 0
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

  hop=$((hop + 1))
  say ""
  say "hop=$hop actor=$before_turn"
  say "  before: sha256=$before_hash turn=$before_turn head=$before_head"

  before_dirty=0; state_dirty && before_dirty=1

  started="$(date '+%s')"
  launch_actor "$before_turn" "$hop"
  rc=$?
  duration=$(( $(date '+%s') - started ))

  if [ "$rc" -eq 124 ]; then
    die 21 "actor '$before_turn' exceeded ${ACTOR_TIMEOUT}s and was killed (hop $hop)"
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
      say "  exit=$rc after ${duration}s, and the repository is unchanged (state sha256, HEAD, working tree, committed-ness all identical) — retrying this hop once."
      started="$(date '+%s')"
      launch_actor "$before_turn" "${hop}r"   # separate .out — the first attempt's output is evidence
      rc=$?
      duration=$(( $(date '+%s') - started ))
      [ "$rc" -eq 124 ] && die 21 "actor '$before_turn' exceeded ${ACTOR_TIMEOUT}s and was killed on the retry (hop $hop)"
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
done
