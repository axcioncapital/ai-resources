#!/usr/bin/env bash
# cc-worktree — fast isolated-worktree Claude Code session launcher.
#
# WHAT IT DOES
#   Creates a git worktree on a fresh branch off `main`, cd's into it, and
#   launches `claude` there — so a SECOND concurrent session lands in its OWN
#   working directory and physically cannot collide with another session that
#   shares the same checkout (the recurring same-checkout collision class,
#   docs/parallel-sessions-playbook.md § 4). This is the FAST PATH (one shell
#   command, before any session is open). The always-available in-session path
#   is the `/new-worktree-session` slash command. Use whichever is at hand:
#     - `cc-worktree <unit>`      → fast path, from your shell, opens the session for you
#     - `/new-worktree-session`   → always-available, from inside a running session
#
# WORKTREE CONTRACT — mirrors .claude/commands/new-worktree-session.md Step 1.
#   KEEP IN SYNC. (Logged patch, 2026-06-10: the structural single-source ideal
#   is one shared helper both call; parked as follow-up since shipped Fixes 1+2
#   already backstop the collision danger. See the fix-plan's Fix 3 note.)
#     BRANCH        = session/<YYYY-MM-DD>-<unit>
#     WORKTREE_PATH = <repo>/../<repo-name>-<unit>   (sibling dir of the repo)
#     base          = main  (a known-good base, not whatever is checked out)
#   DELTA from the command (deliberate, for an unattended launcher): on a name
#   collision this script auto-suffixes BOTH path and branch (-2, -3, …) so a
#   same-unit re-run never fails; new-worktree-session.md suffixes the path only
#   and stops-and-asks on a branch collision.
#
# INSTALL (one-time, operator) — add to ~/.zshrc, then `source ~/.zshrc`:
#   cc-worktree() { "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/scripts/cc-worktree.sh" "$@"; }
# UNINSTALL — delete that one line from ~/.zshrc, then `source ~/.zshrc`.
# RE-SYNC — this in-repo script is the ONLY governed copy (it goes through repo
#   QC / risk-check). The .zshrc function calls it by path, so a canonical edit
#   here takes effect with no re-install. (Only re-copy if you pasted the script
#   BODY into .zshrc instead of calling the path — not the recommended install.)
#
# USAGE:  cc-worktree <unit-name>      e.g.  cc-worktree fix3
#   <unit-name> is optional; if omitted you are prompted for a one-word name.
#
# SAFETY: fails loud on a worktree-add error; never clobbers an existing
#   worktree; does not touch your current session. The new session writes its
#   own marker / .prime-mtime when you run /prime there — this launcher is
#   ADDITIVE to that contract, never a bypass.
#   Teardown when the unit lands:
#     git worktree remove <path> && git branch -d <branch>   (or /cleanup-worktree)

set -euo pipefail

REPO_ROOT=$(git -C "$(pwd)" rev-parse --show-toplevel 2>/dev/null) || {
  echo "[cc-worktree] Not inside a git repo — cd into the target repo first." >&2
  exit 1
}
REPO_NAME=$(basename "$REPO_ROOT")
TODAY=$(date '+%Y-%m-%d')

UNIT="${1:-}"
if [ -z "$UNIT" ]; then
  printf '[cc-worktree] One-word unit name for this session: ' >&2
  read -r UNIT
fi
# Sanitize: lowercase, runs of non-alphanumerics → single '-', strip leading/trailing '-'.
UNIT=$(printf '%s' "$UNIT" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')
[ -z "$UNIT" ] && { echo "[cc-worktree] Empty unit name after sanitizing — aborting." >&2; exit 1; }

BRANCH="session/${TODAY}-${UNIT}"
WORKTREE_PATH="${REPO_ROOT}/../${REPO_NAME}-${UNIT}"
# Uniqueness: if the sibling dir already exists, suffix BOTH path and branch
# together (-2, -3, …) so the two never disagree (see DELTA note in the header).
if [ -e "$WORKTREE_PATH" ]; then
  n=2
  while [ -e "${REPO_ROOT}/../${REPO_NAME}-${UNIT}-${n}" ]; do n=$((n + 1)); done
  WORKTREE_PATH="${REPO_ROOT}/../${REPO_NAME}-${UNIT}-${n}"
  BRANCH="session/${TODAY}-${UNIT}-${n}"
fi

echo "[cc-worktree] Creating worktree: ${WORKTREE_PATH}" >&2
echo "[cc-worktree]   branch ${BRANCH}, base main" >&2
git -C "$REPO_ROOT" worktree add "$WORKTREE_PATH" -b "$BRANCH" main

cd "$WORKTREE_PATH"
echo "[cc-worktree] Launching claude in ${WORKTREE_PATH}." >&2
echo "[cc-worktree]   Run /prime there to start this unit's work in its own lane." >&2
echo "[cc-worktree]   Teardown when done: git worktree remove '${WORKTREE_PATH}' && git branch -d '${BRANCH}'  (or /cleanup-worktree)." >&2
exec claude
