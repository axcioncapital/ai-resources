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
# SAME-CHECKOUT NUDGE (2026-06-05; liveness-tightened 2026-06-10) — when the machine-wide
#   signal (count >= 2) is combined with an un-wrapped foreign session in THIS checkout, the
#   hook emits a SHARP, actionable nudge pointing at /new-worktree-session (the structural
#   remedy). When only the machine-wide signal holds (no foreign session here), it keeps the
#   SOFTER warning.
#
#   LIVENESS DISCRIMINATOR (2026-06-10, Fix 1) — the original same-checkout signal was "a
#   today-dated shared logs/.session-marker is present." That over-fired: the shared marker is
#   DATE-pruned (by /prime's orphan cleanup), not LIVENESS-pruned, so it stayed set after this
#   operator's OWN earlier session wrapped — firing the sharp nudge on every solo same-day
#   re-open. The fix makes the per-session marker set a liveness signal: /prime writes
#   logs/.session-marker-${CLAUDE_CODE_SESSION_ID}; /wrap-session REMOVES it at teardown
#   (wrap-session.md Step 13). So a today-dated per-id marker (excluding this session's own) =
#   an un-wrapped ≈ live foreign session in THIS checkout, and ABSENT per-id markers means every
#   session that primed here today has wrapped → no live foreign session → soft path (this is the
#   false-fire fix). The shared logs/.session-marker is NOT consulted on the oracle path — reading
#   it (date-pruned, not liveness-pruned) is exactly what caused the old false-fire. The legacy
#   shared-marker heuristic survives ONLY as the genuine old-CLI fallback (CLAUDE_CODE_SESSION_ID
#   unset), the same fallback boundary as the marker-resolution loud fallback in session-marker.md.
#   STILL A HEURISTIC, degrades safe: a CRASHED session leaves a stale per-id marker until
#   /prime's next-day prune (occasional unnecessary nudge), and the precise lsof/cwd detector
#   remains deliberately deferred as brittle. Never a block, never a missed real collision.
#
# WHY ONLY A NUDGE — NOT A BLOCK (verified 2026-06-10 against the Claude Code hooks docs):
#   a SessionStart hook CANNOT block a session. On exit code 2 stderr is shown to the user but
#   execution continues; SessionStart is an advisory/context-injection event, not in the set of
#   hook events that can block (PreToolUse, UserPromptSubmit, PermissionRequest, ...). The
#   session's cwd is also already fixed before any hook runs (so it cannot redirect into a
#   worktree). Therefore the STRONGEST this hook can do is a forceful message, which the operator
#   can still proceed past. The actual blocking of the one dangerous move — a cross-session
#   COMMIT that ships another session's staged files — is enforced by check-foreign-staging.sh,
#   a PreToolUse hook (Fix 2, commit f5e013c). This hook is the best-effort early heads-up that
#   PAIRS WITH that commit-time block; it does not and cannot replace it.
#
# CONTRACT — non-blocking. Every path ends in `exit 0`. If the process signal is
#   unavailable (pgrep absent), emit a loud one-line skip notice (principles
#   OP-3, no silent rot) rather than failing closed. Two-end contract (the /wrap-session
#   Step 13 per-id teardown this hook depends on): registered in docs/session-marker.md.

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

# --- Same-checkout liveness discriminator (per-id marker oracle) ---
# /prime writes logs/.session-marker-${CLAUDE_CODE_SESSION_ID} per session; /wrap-session
# REMOVES it at teardown (Step 13). So a today-dated per-id marker is a session that primed in
# THIS checkout today and has NOT wrapped ≈ a live (or crashed) session here. THIS session's own
# marker is excluded — and at a normal SessionStart it does not exist yet, because /prime runs
# AFTER this hook. This is the precise same-checkout signal the legacy shared-marker heuristic
# could not give: the shared logs/.session-marker is date-pruned, not liveness-pruned, so it
# stayed set after this operator's OWN earlier session wrapped, false-firing the sharp nudge on
# every solo same-day re-open. The per-id-marker + wrap-teardown pair removes that false-fire.
if [ -z "${CLAUDE_CODE_SESSION_ID}" ]; then
  # OLD-CLI FALLBACK — the harness does not inject CLAUDE_CODE_SESSION_ID, so /prime could not have
  # written per-id markers and the liveness oracle is genuinely unavailable. Preserve the legacy
  # shared-marker heuristic so the safety net is not lost on an old CLI. This is the SAME fallback
  # boundary as the marker-resolution loud fallback (docs/session-marker.md: legacy path only when
  # the var is unset, never when it is set-but-file-absent). HEURISTIC: a prior WRAPPED session also
  # leaves a today shared-marker, so this path can over-fire; degrades safe (soft nudge, never a
  # block — SessionStart cannot block; see header).
  TODAY_MARKER_HERE=0
  MARKER_CONTENT=""
  MARKER_FILE="$PROJECT_DIR/logs/.session-marker"
  if [ -f "$MARKER_FILE" ]; then
    MARKER_CONTENT=$(cat "$MARKER_FILE" 2>/dev/null)
    [ "${MARKER_CONTENT%% *}" = "$TODAY" ] && TODAY_MARKER_HERE=1
  fi
  if [ "$TODAY_MARKER_HERE" -eq 1 ]; then
    emit "CONCURRENT SESSIONS — another session may be active in THIS checkout (${OTHERS} other session(s) running; this project primed today: ${MARKER_CONTENT}). Two sessions in one checkout silently overwrite each other's uncommitted edits. DO NOT start parallel work here: from your shell run cc-worktree <unit> (the one-command launcher) or /new-worktree-session for an isolated copy, or finish/'/clear' the other session first. (Heuristic: if the other session already wrapped, this checkout is safe — verify before parallel work.) See docs/parallel-sessions-playbook.md § 4."
  fi
else
  # ORACLE PATH — decide purely on the un-wrapped foreign per-id liveness set. A today-dated per-id
  # marker OTHER than this session's own = a session that primed in THIS checkout today and has NOT
  # wrapped ≈ a live foreign session here. THIS session's own marker is excluded (and at a normal
  # SessionStart it does not exist yet — /prime runs after this hook). Crucially, ABSENT per-id
  # markers => every session that primed here today has wrapped (Step 13 teardown removed its marker)
  # => no live foreign session here => fall through to SOFT. This is the false-fire fix: the
  # operator's OWN already-wrapped session no longer triggers the sharp nudge on a solo same-day
  # re-open. (The shared logs/.session-marker is deliberately NOT consulted here — it is date-pruned,
  # not liveness-pruned, and reading it is exactly what caused the old false-fire.)
  SELF_MARKER="$PROJECT_DIR/logs/.session-marker-${CLAUDE_CODE_SESSION_ID}"
  LIVE_FOREIGN_HERE=0
  for f in "$PROJECT_DIR"/logs/.session-marker-*; do
    [ -f "$f" ] || continue                          # glob matched nothing → no per-id markers
    [ "$f" = "$SELF_MARKER" ] && continue            # exclude this session's own
    c=$(cat "$f" 2>/dev/null)
    [ "${c%% *}" = "$TODAY" ] && LIVE_FOREIGN_HERE=$((LIVE_FOREIGN_HERE + 1))
  done
  if [ "$LIVE_FOREIGN_HERE" -ge 1 ]; then
    # SHARP nudge — an un-wrapped foreign session primed in THIS checkout today (genuine same-checkout concurrency).
    emit "CONCURRENT SESSIONS — another session is ACTIVE in THIS checkout (${LIVE_FOREIGN_HERE} un-wrapped session(s) primed here today; ${OTHERS} live session(s) on this machine). Two sessions in one checkout silently overwrite each other's uncommitted edits — this is the recurring collision. Before you start anything here, run /concurrent-session-check <task> (or with no argument to scan the backlog) to see whether your next task even collides with the live session's declared files. DO NOT start parallel work here: from your shell run cc-worktree <unit> (the one-command launcher that opens an isolated session for you), or /new-worktree-session from inside a session, to get an isolated copy and work in THAT — or finish/'/clear' the other session before running /prime or /wrap-session. The commit-time guard (check-foreign-staging.sh) blocks a cross-session COMMIT, but it cannot stop live-edit races — isolate now. See docs/parallel-sessions-playbook.md § 4."
  fi
  # No un-wrapped foreign session in THIS checkout → fall through to the soft machine-wide notice.
fi

# SOFT warning — a live session exists machine-wide, but none is un-wrapped in THIS checkout.
emit "CONCURRENT SESSIONS — ${OTHERS} other Claude Code session(s) running on this machine (${SESSION_COUNT} total). None is un-wrapped in THIS checkout, so this folder is probably clear — but if you start parallel work in this project, isolate it: run cc-worktree <unit> (the one-command launcher) or /new-worktree-session for a separate worktree rather than a second session in this checkout. Two sessions in one checkout silently overwrite each other's uncommitted edits. See docs/parallel-sessions-playbook.md § 4."
