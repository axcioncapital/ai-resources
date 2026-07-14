#!/bin/bash
# sentinel-hook-probe.sh — TEMPORARY DIAGNOSTIC. Delete once the question below is answered.
#
# THE QUESTION
#   The ten repo-level hooks in ai-resources/.claude/settings.json do not fire. Nothing says so.
#   There are THREE candidate causes, and they demand three DIFFERENT fixes:
#
#     (1) WORD-SPLITTING. The wiring is `bash $CLAUDE_PROJECT_DIR/...` unquoted, and the project
#         path contains two spaces. Under sh/bash that splits and exits 127.
#         -> Fix: quote the paths.
#         BUT: zsh does NOT word-split unquoted parameter expansions (verified 2026-07-14:
#         same command, exit 127 under sh/bash, exit 0 under zsh). So this cause only holds if
#         the harness runs hook commands under sh/bash.
#
#     (2) CLAUDE_PROJECT_DIR IS UNSET when hooks run. Then the path collapses to
#         `/.claude/hooks/x.sh` and fails in EVERY shell — and QUOTING FIXES NOTHING.
#         -> Fix: absolute paths (what the working user-level hooks already use).
#         (The variable is definitely unset in the Bash-tool environment; that does not prove it
#         is unset in the HOOK environment, which is a different execution context.)
#
#     (3) REPO-LEVEL HOOKS ARE NOT LOADED AT ALL in this configuration.
#         -> Fix: neither of the above; the wiring has to move to a layer that is loaded.
#
#   Guessing wrong ships a no-op that LOOKS like a fix — and a "fixed" guard that does not fire is
#   strictly worse than a guard known to be off, because it manufactures false confidence. This
#   repo's most-repeated failure is the inert safeguard; this probe exists so we do not add another.
#
# HOW TO READ THE RESULT (after ONE session restart)
#   cat ai-resources/logs/sentinel-hook-probe.log
#
#     no lines at all              -> cause (3): repo-level hooks never run. Quoting is irrelevant.
#     only ABS                     -> cause (2): CLAUDE_PROJECT_DIR unset for hooks. Use absolute
#                                     paths / the installer. Quoting is irrelevant.
#     ABS + CPD_QUOTED, no UNQUOTED-> cause (1): word-splitting. Quoting IS the fix.
#     all three lines              -> the hooks are NOT dead for any of these reasons; the premise
#                                     is wrong and the whole Phase-1 diagnosis must be redone.
#
# CONTRACT: always exit 0. A diagnostic must never block a session start.

LABEL="${1:-NO_LABEL}"

# Resolve a log path that does not itself depend on the variable under test.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd 2>/dev/null)" || exit 0
LOG="$(cd "$SCRIPT_DIR/../.." && pwd 2>/dev/null)/logs/sentinel-hook-probe.log" || exit 0

printf '%s  FIRED=%-14s CLAUDE_PROJECT_DIR=[%s]  SHELL=[%s]  cwd=[%s]\n' \
  "$(date '+%Y-%m-%dT%H:%M:%S')" \
  "$LABEL" \
  "${CLAUDE_PROJECT_DIR:-<UNSET>}" \
  "${SHELL:-<unknown>}" \
  "$(pwd)" \
  >> "$LOG" 2>/dev/null

exit 0
