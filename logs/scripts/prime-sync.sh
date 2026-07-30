#!/usr/bin/env bash
# prime-sync.sh — THE executing owner of /prime's orientation git synchronisation.
#
# Owns, for the cwd repository and for ai-resources: the fetch, the behind-check, the pull, the
# conflicted-rebase abort, the four result classifications, the autostash-pop detection and the
# unpushed count. Extracted from prime.md Step 0 on 2026-07-30 (stream
# 2026-07-30-prime-session-entry-ownership, slice S4). Rationale for every shape below —
# docs/commit-discipline.md § Orientation pull; that doc is the authority, this file the implementation.
#
# CONTRACT
#   Usage:  prime-sync.sh [SECOND_REPO]
#           SECOND_REPO is the shared repo to sync alongside the cwd one. Defaults to the ai-resources
#           path below, which is what /prime relies on; skipped when it equals the cwd repo or is not
#           a checkout. It is an ARGUMENT rather than a bare constant for one reason: with the path
#           hard-wired, logs/scripts/prime-sync.test.sh could not run a single case without fetching —
#           and potentially rebasing — the operator's live ai-resources checkout as a side effect of
#           running the suite. That was observed, not theorised: the first version of the suite issued
#           two fetches per case and the second one was real. A test that mutates production while
#           testing is worse than no test.
#   cwd:    the repository being oriented. The CALLER locates this script by ABSOLUTE path and leaves
#           cwd alone, so one copy serves every consumer checkout.
#   stdout: labelled lines, one label per line, in this order:
#             CWD_REPO: {absolute path, or "(none)" outside a git repo}
#             SYNC: {repo basename} — {result}          (one per repo synced; absent outside a repo)
#           Result is one of: `up to date` · `updated` · `skip (no upstream configured)` ·
#           `autostash-conflict` · `failed: {reason}`, each optionally suffixed ` — {N} unpushed`.
#   exit:   0 ALWAYS. Orientation must not stop because a network call failed; every failure is a
#           classified result string, never a non-zero exit.
#
#   CWD_REPO IS PART OF THIS INTERFACE, not a side effect. Steps 1a / 1c / 1d and the 8g cross-repo
#   mission guard all consume it, and this script has to resolve it anyway to know what to sync.
#   Emitting it here is what stops /prime from re-deriving the same path a second time.
#
# THE BEHIND-CHECK IS NOT AN OPTIMISATION — DO NOT REMOVE IT.
#   Running `pull --rebase --autostash` on a repo with nothing to pull still rewrites state and has
#   caused a real incident class (2026-07-14 S5 → fixed S8). The guard asks how far behind the repo is
#   and skips the pull entirely at zero. A future edit that "simplifies" this into an unconditional
#   pull re-opens that class.
#
# BOTH PULL FLAGS STAY EXPLICIT. `--rebase` and `--autostash` are never left to per-machine git config:
# a machine without them configured silently gets merge-commit-and-fail-on-dirty behaviour instead.

set -u

SECOND_REPO="${1:-/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources}"

CWD_REPO=$(git -C "$(pwd)" rev-parse --show-toplevel 2>/dev/null || true)

if [ -z "$CWD_REPO" ]; then
  printf 'CWD_REPO: (none)\n'
  # Same `SYNC: {name} — {result}` shape as every other line, so one parse rule covers all of them.
  printf 'SYNC: (none) — n/a (not a git repo)\n'
  exit 0
fi
printf 'CWD_REPO: %s\n' "$CWD_REPO"

# Count commits this checkout has that its upstream does not. Silent when there is no upstream —
# a detached HEAD must not produce a spurious "0 unpushed" clause.
unpushed_suffix () {
  _n=$(git -C "$1" log @{u}..HEAD --oneline 2>/dev/null | wc -l | tr -d ' ')
  case "${_n:-0}" in
    ''|0) printf '' ;;
    *)    printf -- ' — %s unpushed' "$_n" ;;
  esac
}

sync_repo () {
  REPO="$1"
  NAME=$(basename "$REPO")

  GIT_TERMINAL_PROMPT=0 git -C "$REPO" fetch --quiet 2>/dev/null
  BEHIND=$(git -C "$REPO" rev-list --count HEAD..@{u} 2>/dev/null || echo "")

  if [ -z "$BEHIND" ]; then
    # No upstream, or a detached HEAD. Nothing to pull and nothing to count.
    printf 'SYNC: %s — skip (no upstream configured)\n' "$NAME"
    return 0
  fi

  if [ "$BEHIND" = "0" ]; then
    # THE GUARD. Skip the pull entirely — see the header block.
    printf 'SYNC: %s — up to date%s\n' "$NAME" "$(unpushed_suffix "$REPO")"
    return 0
  fi

  OUT=$(GIT_TERMINAL_PROMPT=0 git -C "$REPO" pull --rebase --autostash 2>&1)
  RC=$?

  # 1. CONFLICTED REBASE — checked first, because it is the state that must not be left on disk.
  #    Do not attempt to resolve it and do not stop the session: restore the repo and keep orienting.
  #    A failed pull must never leave the operator half-rebased at the moment they start work.
  if git -C "$REPO" rev-parse --verify -q REBASE_HEAD >/dev/null 2>&1 \
     || git -C "$REPO" status 2>/dev/null | grep -q 'rebase in progress'; then
    git -C "$REPO" rebase --abort 2>/dev/null
    printf 'SYNC: %s — failed: rebase conflicted — aborted, repo restored; local history unchanged\n' "$NAME"
    return 0
  fi

  # 2. AUTOSTASH POP CONFLICT — MUST be classified BEFORE the exit-code cases below. With --autostash
  #    the history rebase can succeed (exit 0) while the POP of the stashed dirty tree conflicts, so
  #    an exit-code-first reading mislabels it `updated` and the operator starts work on a tree full of
  #    conflict markers. Three OR'd signals because git's wording is not a stable interface.
  if printf '%s' "$OUT" | grep -q 'Applying autostash resulted in conflicts' \
     || git -C "$REPO" stash list 2>/dev/null | grep -q 'autostash' \
     || git -C "$REPO" status --short 2>/dev/null | grep -q '^UU'; then
    printf 'SYNC: %s — autostash-conflict%s\n' "$NAME" "$(unpushed_suffix "$REPO")"
    return 0
  fi

  # 3. The exit-code cases.
  if [ "$RC" -eq 0 ]; then
    if printf '%s' "$OUT" | grep -q 'Already up to date'; then
      printf 'SYNC: %s — up to date%s\n' "$NAME" "$(unpushed_suffix "$REPO")"
    else
      printf 'SYNC: %s — updated%s\n' "$NAME" "$(unpushed_suffix "$REPO")"
    fi
    return 0
  fi

  if printf '%s' "$OUT" | grep -q 'no tracking information'; then
    printf 'SYNC: %s — skip (no upstream configured)\n' "$NAME"
    return 0
  fi

  # First non-empty line of the failure, trimmed — enough for the brief's exception line, never a dump.
  REASON=$(printf '%s' "$OUT" | grep -v '^[[:space:]]*$' | head -n 1 | cut -c1-120)
  printf 'SYNC: %s — failed: %s\n' "$NAME" "${REASON:-unknown error}"
}

sync_repo "$CWD_REPO"

# CANONICALISE BOTH SIDES THROUGH THE SAME PRIMITIVE BEFORE COMPARING. A plain string test on the
# two paths is wrong: `rev-parse --show-toplevel` returns the PHYSICAL path, so a caller reaching the
# same checkout through a symlinked parent (every macOS $TMPDIR does this — /var -> /private/var, and
# the workspace itself could) compares "different" and syncs the same repo twice — a second fetch and
# a second pull on a repo already handled. Observed in logs/scripts/prime-sync.test.sh TEST 9.
SECOND_TOP=$(git -C "$SECOND_REPO" rev-parse --show-toplevel 2>/dev/null || true)
if [ -n "$SECOND_TOP" ] && [ "$SECOND_TOP" != "$CWD_REPO" ]; then
  sync_repo "$SECOND_TOP"
fi

exit 0
