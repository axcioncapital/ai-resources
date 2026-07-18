#!/bin/bash
# SessionStart hook: proactively warn when another Claude Code session is live in
# THIS checkout (sharp nudge) or elsewhere on the machine (soft notice), because
# concurrent sessions race on this project's shared session state
# (logs/.session-marker*, logs/session-notes.md) and on the shared git index.
# This is the DR-8 "concurrent-session detection hook" (improvement-log TOCTOU race
# class; shipped 2026-06-01, process-grounded rewrite 2026-07-18).
#
# DESIGN — read the OS, not a registry (principles AP-10). The hook keeps no
#   registry of its own. Liveness is derived from two independent signals:
#     1. The process table: Claude Code CLI processes and their KERNEL CWD (lsof).
#        A session's CLI process sits with cwd = the folder the session was opened
#        on (verified against the live process table 2026-07-18: every native-binary
#        process cwd matched its session's project folder exactly).
#     2. The per-id marker set (logs/.session-marker-*): which sessions PRIMED here
#        and have not torn down (SessionEnd hook, wrap Step 13, handoff C3 — or,
#        for hard-killed sessions, THIS hook's liveness prune below).
#   A foreign marker alone proves a session STARTED here — not that it is still
#   alive (crashed/killed sessions leave markers; the SessionEnd hook cannot fire
#   on SIGKILL). A foreign process-with-cwd-here alone proves a CLI process is
#   open on this folder (typically an idle VS Code window) — not that a session
#   primed here (VS Code keeps idle CLI processes alive long after their sessions
#   ended, and there is no process→session-id mapping). The hook requires BOTH:
#     marker present AND >=1 foreign CLI process with cwd in this checkout → SHARP.
#     marker present AND zero foreign CLI processes here → the marker's session
#       CANNOT be running (its host process would have cwd here) → provably stale
#       → AUTO-PRUNE the marker file(s). This is the automatic cleanup that keeps
#       ghost markers from arming false warnings and false commit-blocks.
#   Markers are matched at ANY DATE, not just today: a marker's date records when
#   the session STARTED, never whether it has ENDED (the same category error was
#   fixed in check-foreign-staging.sh on 2026-07-14; this hook kept a today-only
#   filter until 2026-07-18, which made a live overnight session invisible).
#
# ENUMERATION — ps, NOT pgrep (fixed 2026-07-18). macOS pgrep excludes the
#   calling process's OWN ANCESTORS by default (see pgrep(1), -a flag). This hook
#   runs as a child of its session's CLI process, so `pgrep -f` never counted the
#   current session — the old `count >= 2 means >= 1 other` arithmetic therefore
#   undercounted by one, and with exactly ONE other live session the hook exited
#   silently before any marker check. (The 2026-06-01 "1:1 baseline" was measured
#   from a context where the ancestor exclusion did not bite; verified wrong by
#   execution 2026-07-18: pgrep -f matched every CLI process EXCEPT this session's
#   own ancestor; pgrep -a -f matched all.) `ps -axo pid=,command=` has no such
#   exclusion. The current session's process is identified by walking up the
#   ancestor chain and is excluded from the foreign count explicitly.
#
# WHY ONLY A NUDGE — NOT A BLOCK (verified 2026-06-10 against the Claude Code hooks
#   docs): a SessionStart hook CANNOT block a session; its strongest action is a
#   message. The blocking of the one dangerous move — a cross-session COMMIT — is
#   enforced by check-foreign-staging.sh (PreToolUse), which reads the same two
#   signals. This hook is the best-effort early heads-up that PAIRS WITH it.
#
# DEGRADES —
#   * ps unavailable → loud one-line skip notice (OP-3, no silent rot).
#   * lsof unavailable or returning nothing for live foreign pids → liveness cannot
#     be grounded; fall back to the legacy today-dated-marker heuristic and prune
#     NOTHING (never delete state the hook cannot ground).
#   * CLAUDE_CODE_SESSION_ID unset (old CLI) → legacy shared-marker heuristic,
#     unchanged (same fallback boundary as docs/session-marker.md resolution).
#   * A session working in a directory its CLI process does not have as cwd (e.g.
#     an agent-side EnterWorktree) is invisible to the cwd signal — accepted; this
#     workspace isolates via per-window VS Code worktree sessions.
#
# CONTRACT — non-blocking. Every path ends in `exit 0`. The ONLY write this hook
#   performs is `rm -f` of provably-dead foreign marker files in $PROJECT_DIR/logs
#   (cleanup of detection state, never content). Two-end contract registered in
#   docs/session-marker.md § Concurrent-session detection.

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
TODAY=$(date +%Y-%m-%d)

emit() {
  # $1 = systemMessage text. Prefer python3 for safe JSON escaping; fall back to
  # a hand-built JSON line if python3 is absent (still non-blocking, still exits).
  if command -v python3 >/dev/null 2>&1; then
    python3 -c "import json,sys; print(json.dumps({'systemMessage': sys.argv[1]}))" "$1" 2>/dev/null
  else
    printf '{"systemMessage": "%s"}\n' "$1"
  fi
  exit 0
}

# --- Signal availability guard (OP-3: loud skip, never silent rot) ---
if ! command -v ps >/dev/null 2>&1; then
  emit "CONCURRENCY CHECK SKIPPED — ps unavailable; cannot detect concurrent Claude Code sessions on this machine."
fi

# --- Enumerate Claude Code CLI processes (ps, not pgrep — see header) ---
# CC_PROCESS_PATTERN may be overridden in the environment for testing.
CC_PROCESS_PATTERN="${CC_PROCESS_PATTERN:-native-binary/claude}"
PS_OUT=$(ps -axo pid=,command= 2>/dev/null)
if [ -z "$PS_OUT" ]; then
  # ps exists but answered nothing — a real system always lists processes, so this is
  # a failure, not an empty result. Never prune or conclude "no sessions" on it.
  emit "CONCURRENCY CHECK SKIPPED — ps returned nothing; cannot detect concurrent Claude Code sessions on this machine."
fi
ALL_PIDS=$(printf '%s\n' "$PS_OUT" | grep -F "$CC_PROCESS_PATTERN" | grep -v grep | awk '{print $1}')

# --- Identify THIS session's own CLI process (ancestor walk from this hook) ---
SELF_PID=""
P=$$
for _ in 1 2 3 4 5 6 7 8 9 10; do
  case "$(ps -o command= -p "$P" 2>/dev/null)" in
    *"$CC_PROCESS_PATTERN"*) SELF_PID="$P"; break ;;
  esac
  P=$(ps -o ppid= -p "$P" 2>/dev/null | tr -d ' ')
  case "$P" in ''|0|1) break ;; esac
done

# --- Foreign process set (everything matching the pattern except our own) ---
OTHERS=0
FOREIGN_PIDS=""
for pid in $ALL_PIDS; do
  case "$pid" in ''|*[!0-9]*) continue ;; esac
  [ -n "$SELF_PID" ] && [ "$pid" = "$SELF_PID" ] && continue
  OTHERS=$((OTHERS + 1))
  FOREIGN_PIDS="${FOREIGN_PIDS},${pid}"
done
FOREIGN_PIDS="${FOREIGN_PIDS#,}"

# --- Ground liveness: how many foreign CLI processes have cwd = THIS checkout? ---
# GROUNDED=1 means the process-table signal is usable (lsof answered, or there are
# no foreign processes at all — in which case nothing can be live here).
GROUNDED=0
FOREIGN_HERE=0
if [ "$OTHERS" -eq 0 ]; then
  GROUNDED=1
elif command -v lsof >/dev/null 2>&1; then
  HERE=$(cd "$PROJECT_DIR" 2>/dev/null && pwd -P)
  if [ -n "$HERE" ]; then
    CWDS=$(lsof -a -p "$FOREIGN_PIDS" -d cwd -Fn 2>/dev/null | sed -n 's/^n//p')
    if [ -n "$CWDS" ]; then
      GROUNDED=1
      FOREIGN_HERE=$(printf '%s\n' "$CWDS" | grep -Fxc "$HERE")
    fi
  fi
fi

PRUNED=0
if [ -z "${CLAUDE_CODE_SESSION_ID}" ]; then
  # OLD-CLI FALLBACK — no session id, so /prime could not have written per-id markers
  # and the marker oracle is unavailable. Preserve the legacy shared-marker heuristic
  # (same fallback boundary as docs/session-marker.md marker resolution). HEURISTIC:
  # a prior WRAPPED session also leaves a today-dated shared marker, so this path can
  # over-fire; degrades safe (nudge only — SessionStart cannot block; see header).
  if [ "$OTHERS" -ge 1 ]; then
    MARKER_CONTENT=""
    MARKER_FILE="$PROJECT_DIR/logs/.session-marker"
    if [ -f "$MARKER_FILE" ]; then
      MARKER_CONTENT=$(cat "$MARKER_FILE" 2>/dev/null)
      if [ "${MARKER_CONTENT%% *}" = "$TODAY" ]; then
        emit "CONCURRENT SESSIONS — another session may be active in THIS checkout (${OTHERS} other session(s) running; this project primed today: ${MARKER_CONTENT}). Two sessions in one checkout silently overwrite each other's uncommitted edits. DO NOT start parallel work here: run /new-worktree-session for an isolated copy (it opens the worktree in a new VS Code window), or finish/'/clear' the other session first. (Terminal users: cc-worktree <unit>.) (Heuristic: if the other session already wrapped, this checkout is safe — verify before parallel work.) See docs/parallel-sessions-playbook.md § 4."
      fi
    fi
  fi
else
  # ORACLE PATH — per-id markers say who PRIMED here; the process table says whether
  # anyone is still HERE. Both signals must agree before the sharp nudge fires.
  SELF_MARKER="$PROJECT_DIR/logs/.session-marker-${CLAUDE_CODE_SESSION_ID}"
  FOREIGN_MARKERS=0
  FOREIGN_MARKER_FILES=""
  FOREIGN_MARKER_NAMES=""
  for f in "$PROJECT_DIR"/logs/.session-marker-*; do
    [ -f "$f" ] || continue                          # glob matched nothing → no per-id markers
    [ "$f" = "$SELF_MARKER" ] && continue            # exclude this session's own
    FOREIGN_MARKERS=$((FOREIGN_MARKERS + 1))
    FOREIGN_MARKER_FILES="$FOREIGN_MARKER_FILES$f
"
    FOREIGN_MARKER_NAMES="$FOREIGN_MARKER_NAMES $(cat "$f" 2>/dev/null | head -1)"
  done
  if [ "$FOREIGN_MARKERS" -ge 1 ]; then
    if [ "$GROUNDED" -eq 1 ]; then
      if [ "$FOREIGN_HERE" -ge 1 ]; then
        # SHARP nudge — a session primed in THIS checkout has not torn down AND a foreign
        # Claude CLI process still has its cwd here: genuine same-checkout concurrency
        # (or an open idle window that can wake and resume mutating this checkout).
        emit "CONCURRENT SESSIONS — another session is ACTIVE in THIS checkout (${FOREIGN_MARKERS} un-torn-down session marker(s):${FOREIGN_MARKER_NAMES}; ${FOREIGN_HERE} other Claude CLI process(es) in this folder, ${OTHERS} other machine-wide). Two sessions in one checkout silently overwrite each other's uncommitted edits — this is the recurring collision. Before you start anything here, run /concurrent-session-check <task> (or with no argument to scan the backlog) to see whether your next task even collides with the live session's declared files. DO NOT start parallel work here: run /new-worktree-session to get an isolated copy — it opens the worktree in a new VS Code window; start a session there and work in THAT — or finish/'/clear' the other session before running /prime or /wrap-session. (Terminal users: cc-worktree <unit>.) The commit-time guard (check-foreign-staging.sh) blocks a cross-session COMMIT, but it cannot stop live-edit races — isolate now. See docs/parallel-sessions-playbook.md § 4."
      else
        # PROVABLY STALE — a session that primed here has no CLI process left with cwd in
        # this checkout: it ended without teardown (SIGKILL/crash/closed window). Prune the
        # ghost marker(s) so they stop arming false sharp nudges and false commit-blocks.
        printf '%s' "$FOREIGN_MARKER_FILES" | while IFS= read -r f; do
          [ -n "$f" ] && [ -f "$f" ] && rm -f "$f" 2>/dev/null
        done
        PRUNED=$FOREIGN_MARKERS
      fi
    else
      # DEGRADE — lsof could not ground liveness. ANY-date foreign markers must warn
      # here (not just today's): an overnight live session's marker is yesterday-dated,
      # and with liveness unverifiable, staying silent — or worse, falling through to
      # the "probably clear" soft message below — would mislabel a possibly-live
      # session as absent (QC finding, 2026-07-18). Prune NOTHING in this mode.
      emit "CONCURRENT SESSIONS — another session may be ACTIVE in THIS checkout (${FOREIGN_MARKERS} un-torn-down session marker(s):${FOREIGN_MARKER_NAMES}; liveness could not be verified — lsof unavailable; ${OTHERS} other session process(es) machine-wide). Two sessions in one checkout silently overwrite each other's uncommitted edits. Run /concurrent-session-check <task> before starting, or /new-worktree-session for an isolated copy. See docs/parallel-sessions-playbook.md § 4."
    fi
  fi
fi

# --- No live foreign session in THIS checkout ---
[ "$OTHERS" -eq 0 ] && exit 0

PRUNE_NOTE=""
[ "$PRUNED" -gt 0 ] && PRUNE_NOTE=" (Cleaned ${PRUNED} stale session marker(s) left by ended/crashed sessions in this checkout.)"

# SOFT warning — other Claude sessions/windows exist machine-wide, but none is both
# marked and present in THIS checkout.
emit "CONCURRENT SESSIONS — ${OTHERS} other Claude Code CLI process(es) on this machine (${FOREIGN_HERE:-0} in this folder, none with an un-torn-down session marker here — this folder is probably clear).${PRUNE_NOTE} If you start parallel work in this project, isolate it: run /new-worktree-session for a separate worktree (it opens in a new VS Code window) rather than a second session in this checkout. (Terminal users: cc-worktree <unit>.) Two sessions in one checkout silently overwrite each other's uncommitted edits. See docs/parallel-sessions-playbook.md § 4."
