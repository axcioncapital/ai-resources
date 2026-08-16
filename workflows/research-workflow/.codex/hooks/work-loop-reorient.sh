#!/bin/bash
# work-loop-reorient.sh — SessionStart hook, matcher: compact
#
# After Codex compacts a root session, emit the one fact this hook actually holds
# (the checkout it was handed) plus one instruction: re-read the active Work Loop
# pointers preserved under AGENTS.md § Compaction from disk before moving.
#
# Deliberately NOT done here (accepted plan § 4.9):
#   - it never identifies a task: no scan of logs/work-loop, no `turn:` search,
#     no most-recently-modified heuristic, no registry, no cache;
#   - it never quotes repository content and never emits a summary — a paraphrase
#     would be a second, lossy copy of the truth;
#   - it never writes and never decides; it does not set `turn:`.
#
# Fail open, always. Missing stdin, malformed JSON, no cwd, no jq, no git — exit 0
# with no additionalContext. A reorientation hook that blocks a session is worse
# than one that is silent.

# No stdin attached (run by hand from a terminal) — nothing to reorient from.
[ -t 0 ] && exit 0

INPUT=$(cat 2>/dev/null) || exit 0
[ -n "$INPUT" ] || exit 0

command -v jq >/dev/null 2>&1 || exit 0

CWD=$(jq -r '.cwd // empty' <<<"$INPUT" 2>/dev/null) || exit 0
[ -n "$CWD" ] || exit 0
[ -d "$CWD" ] || exit 0

# Checkout identity: the received cwd plus the git common dir, so a worktree is
# distinguishable from the local checkout it was created from. Not a file read.
COMMON_DIR=$(git -C "$CWD" rev-parse --git-common-dir 2>/dev/null)
if [ -n "$COMMON_DIR" ]; then
  case "$COMMON_DIR" in
    /*) : ;;
    *) COMMON_DIR="$CWD/$COMMON_DIR" ;;
  esac
else
  COMMON_DIR="(not a git checkout)"
fi

jq -cn --arg cwd "$CWD" --arg common "$COMMON_DIR" '{
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    additionalContext: (
      "WORK LOOP REORIENT — this session was compacted. Checkout: " + $cwd +
      " (git common dir: " + $common + "). If a Work Loop v2 task is active, invoke $reorient now, before your next move. It re-reads from disk the active Work Loop pointers preserved under AGENTS.md § Compaction: the exact active logs/work-loop/{task-id}.md path, the bound checkout, the governing plan path with its workflow and phase, and the current ## Next action. Reorient owns the recovery procedure and this hook does not restate it. If reorientation cannot establish the authoritative task, stop and say so — do not go looking for the task. Do not continue from the compacted summary."
    )
  }
}' 2>/dev/null || exit 0

exit 0
