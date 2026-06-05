#!/bin/bash
# SessionStart hook: proactively warn when more than one Claude Code session is
# running, because concurrent sessions race on this project's shared session
# state (logs/.session-marker, logs/.prime-mtime, logs/session-notes.md). This
# is the DR-8 "concurrent-session detection hook" (improvement-log TOCTOU race
# class; 3-4 recurrences in 5 days before this hook shipped 2026-06-01).
#
# DESIGN — read-only detector (NO new shared-mutable state).
#   This hook deliberately keeps no registry of its own. A registry built to
#   detect races would itself be a shared-mutable file that races (principles
#   AP-10) — the exact failure mode it is meant to catch, one layer up. Instead
#   it READS an existing OS signal: the count of running Claude Code CLI
#   processes. It reads the marker file only as read-only context, never as the
#   detection signal (the marker is the file that suffers the clobber bug).
#
# SIGNAL — `pgrep -f 'native-binary/claude'` counts Claude Code CLI sessions.
#   Verified 2026-06-01 against the live process table: matches the VS Code
#   extension native binary (resources/native-binary/claude ...), excludes the
#   Claude.app desktop helper. The current session is always in the count, so a
#   count >= 2 means >= 1 OTHER session is live.
#   1:1 BASELINE — verified 2026-06-01 that one session yields exactly one match
#   (no double-count): 3 live sessions matched 3 processes, all top-level (none a
#   child of another matched claude), AND subagents spawned in-session did NOT
#   add matches (subagents run inside the parent session process). So the
#   `>= 2 means >= 1 other` threshold has no off-by-N. If a future Claude Code
#   build spawns a matching child/worker per session, re-verify this baseline.
#
# SCOPE — machine-wide, not project-scoped. Process args do not carry the
#   session cwd, so a session in an UNRELATED project also counts. Accepted
#   best-effort limitation for a non-blocking warning (see docs/session-marker.md
#   § Concurrent-session detection). Future enhancement: scope by cwd via lsof.
#
# SAME-CHECKOUT NUDGE (2026-06-05) — when the machine-wide signal (count >= 2) is
#   combined with a today-dated marker already present in THIS checkout, that is a
#   strong "another session already primed in this same folder today" signal — the
#   exact Mode-A condition behind every recurrence in the collision report. In that
#   case the hook emits a SHARP, actionable nudge pointing at /new-worktree-session
#   (the structural remedy). When only the machine-wide signal holds (no today
#   marker here), it keeps the SOFTER warning. HEURISTIC, not a precise detector:
#   a prior WRAPPED session also leaves a today marker, so the sharp nudge can fire
#   when this is in fact the only live session here. Degrades safe — an occasional
#   unnecessary nudge, never a block, never a missed real collision. The precise
#   same-checkout detector (lsof/cwd) is deliberately deferred as brittle.
#   Forcing-function rationale: the operator must not have to REMEMBER to isolate;
#   this auto-fires the remedy at the moment of risk. It cannot CREATE+enter the
#   worktree for them (a session's cwd is fixed before any hook runs) — it prompts.
#
# CONTRACT — non-blocking. Every path ends in `exit 0`. If the process signal is
#   unavailable (pgrep absent), emit a loud one-line skip notice (principles
#   OP-3, no silent rot) rather than failing closed. Two-end contract: registered
#   in docs/session-marker.md.

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
if ! command -v pgrep >/dev/null 2>&1; then
  emit "CONCURRENCY CHECK SKIPPED — pgrep unavailable; cannot detect concurrent Claude Code sessions on this machine."
fi

# --- Count running Claude Code CLI sessions ---
# CC_PROCESS_PATTERN may be overridden in the environment for testing.
CC_PROCESS_PATTERN="${CC_PROCESS_PATTERN:-native-binary/claude}"
SESSION_COUNT=$(pgrep -f "$CC_PROCESS_PATTERN" 2>/dev/null | wc -l | tr -d ' ')

# Non-numeric (defensive) → proceed silently.
case "$SESSION_COUNT" in
  ''|*[!0-9]*) exit 0 ;;
esac

# <= 1 session (just this one) → no concurrency to warn about.
[ "$SESSION_COUNT" -le 1 ] && exit 0

OTHERS=$((SESSION_COUNT - 1))

# --- Project marker context (read-only): is there a today-dated marker in THIS checkout? ---
# A today marker here + another live session = strong same-checkout signal → sharp nudge.
TODAY_MARKER_HERE=0
MARKER_CONTENT=""
MARKER_FILE="$PROJECT_DIR/logs/.session-marker"
if [ -f "$MARKER_FILE" ]; then
  MARKER_CONTENT=$(cat "$MARKER_FILE" 2>/dev/null)
  [ "${MARKER_CONTENT%% *}" = "$TODAY" ] && TODAY_MARKER_HERE=1
fi

if [ "$TODAY_MARKER_HERE" -eq 1 ]; then
  # SHARP nudge — same-checkout concurrency is likely (the recurring Mode-A condition).
  emit "CONCURRENT SESSIONS — another session is likely active in THIS checkout (${OTHERS} other session(s) running; this project already primed today: ${MARKER_CONTENT}). Two sessions in one checkout silently overwrite each other's uncommitted edits — this is the recurring collision. DO NOT start parallel work here: run /new-worktree-session to get an isolated copy and work in THAT, or coordinate (finish or /clear one of the sessions) before running /prime or /wrap-session. See docs/parallel-sessions-playbook.md § 4. (Heuristic: if the other session already wrapped, this checkout is safe — but verify before doing parallel work.)"
fi

# SOFT warning — another session exists machine-wide, but none primed in THIS checkout today.
emit "CONCURRENT SESSIONS — ${OTHERS} other Claude Code session(s) running on this machine (${SESSION_COUNT} total). None has primed in THIS checkout today, so this folder is probably clear — but if you start parallel work in this project, isolate it: run /new-worktree-session for a separate worktree rather than a second session in this checkout. Two sessions in one checkout silently overwrite each other's uncommitted edits. See docs/parallel-sessions-playbook.md § 4."
