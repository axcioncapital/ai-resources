#!/bin/bash
# work-loop-session-preflight.sh — the one read-only gate the LEGACY session
# commands take before their first state write.
#
# THE PROBLEM THIS CLOSES. /prime, /session-start, /session-plan and
# /wrap-session each build and write legacy session state — a marker, a
# session-notes header, a plan file, a scratchpad. Work Loop v2 keeps its own
# durable state in logs/work-loop/{task-id}.md. In a checkout that a valid open
# Work Loop task owns, running one of those commands starts a SECOND state
# system over the top of the first: two records of "where the work is", written
# by different mechanisms, with nothing reconciling them. Durable-state plan,
# fixed decision 12 — Work Loop v2 neither reads nor writes the legacy
# session-state system to determine execution state. This script is the other
# half of that sentence: the legacy system does not get to write over Work Loop
# state either.
#
# WHAT IT IS NOT. It is not a lifecycle parser, not a second state mechanism,
# and not an owner of anything. It asks the two canonical helpers and reports
# their answer:
#
#   logs/scripts/work-loop-owner.sh   which task, if any, this checkout declares
#   logs/scripts/work-loop-state.sh   what that task's lifecycle classification is
#
# Adding a third reader of either question is the failure this delegation
# exists to prevent, so nothing here reads `task:`, `status:` or `turn:`.
#
# READ-ONLY, ABSOLUTELY. It creates, edits and deletes nothing — no claim, no
# clear, no repair, not even of a declaration it can see is stale. A gate that
# mutated on the way past would be taking the turn rather than checking it, and
# a legacy command is the last thing that should be repairing Work Loop
# ownership. `--depth local` is deliberate: this runs no git, so it works in a
# checkout the caller has not proved anything about.
#
# Usage:
#   work-loop-session-preflight.sh [--checkout PATH] [--command NAME]
#
#   --checkout  defaults to the Git top level of the current directory
#   --command   the caller's own name, used only in the printed message
#
# Exit codes:
#   0   PROCEED   no valid open Work Loop task owns this checkout. The caller
#                 continues with its existing behaviour, unchanged.
#   3   STOP      a valid open task owns it. `route:` names where to go instead.
#   4   STOP      ownership or lifecycle is UNESTABLISHED — malformed, absent
#                 where it must be present, or contradictory. The caller stops
#                 without falling into either system.
#   10  BAD_USAGE
#
# WHY 4 STOPS RATHER THAN PROCEEDING. A checkout that declares a writer but
# cannot establish what that writer's state is, is the one shape where guessing
# is worst: proceeding writes legacy state over a task that may well be open,
# and the evidence that it was open is exactly what went missing. Absent
# evidence is not evidence of absence, so it stops and says which check failed.
# The reverse case — no declaration at all — is the ordinary non-Work-Loop
# checkout and proceeds silently, because that is every other session.
#
# Regression coverage: logs/scripts/work-loop-session-preflight.test.sh

set -uo pipefail

OWNER_REL='logs/work-loop/.owner'

CHECKOUT=""; COMMAND_NAME="this command"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --checkout) CHECKOUT="${2:-}"; shift 2 ;;
    --command)  COMMAND_NAME="${2:-}"; shift 2 ;;
    -h|--help)  awk 'NR==1{next} /^#/{print; next} {exit}' "${BASH_SOURCE[0]}"; exit 0 ;;
    *)          printf 'STOP [10] unknown argument: %s\n' "$1" >&2; exit 10 ;;
  esac
done

if [ -z "$CHECKOUT" ]; then
  CHECKOUT="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    # Not a Git repository at all. There is no checkout to own and no Work Loop
    # record to collide with, so the legacy command's own behaviour stands.
    printf 'verdict: PROCEED\n'
    printf 'reason: not a Git repository — no Work Loop checkout binding is possible here.\n'
    exit 0
  }
fi

[ -d "$CHECKOUT" ] || { printf 'STOP [10] --checkout is not a directory: %s\n' "$CHECKOUT" >&2; exit 10; }

OWNER_FILE="$CHECKOUT/$OWNER_REL"

proceed() { printf 'verdict: PROCEED\n'; printf 'reason: %s\n' "$*"; exit 0; }
stop_route() { # route reason...
  local route="$1"; shift
  printf 'verdict: STOP\n'
  printf 'route: %s\n' "$route"
  printf 'reason: %s\n' "$*"
  exit 3
}
stop_unestablished() {
  printf 'verdict: STOP\n'
  printf 'route: establish Work Loop ownership and state before running %s in this checkout.\n' "$COMMAND_NAME"
  printf 'reason: %s\n' "$*"
  exit 4
}

# ---------------------------------------------------------------- no declaration
# The overwhelmingly common case: an ordinary checkout with no Work Loop task.
# Nothing is checked beyond this point and the caller proceeds exactly as before.
if [ ! -e "$OWNER_FILE" ]; then
  proceed "this checkout declares no Work Loop task — $COMMAND_NAME proceeds unchanged."
fi

[ -f "$OWNER_FILE" ] && [ -r "$OWNER_FILE" ] ||
  stop_unestablished "$OWNER_REL exists but is not a readable regular file. Ownership cannot be established, so $COMMAND_NAME stopped rather than writing session state over a task that may be open."

# ------------------------------------------------------------- the declared shape
# One task id, on one line, and nothing else. The pre-Tracer-3 `{task-id} {date}`
# form is the retired shape and is NOT accepted here for the same reason the
# owner helper refuses it: a second field is one more thing two readers can
# disagree about. This is a SHAPE test, not a lifecycle read.
OWNER_LINES="$(wc -l <"$OWNER_FILE" | tr -d ' ')"
OWNER_RAW="$(cat "$OWNER_FILE" 2>/dev/null)"
DECLARED="$(printf '%s' "$OWNER_RAW" | head -1)"

[ -n "$DECLARED" ] ||
  stop_unestablished "$OWNER_REL is empty. A declaration that names no task cannot be acted on, and $COMMAND_NAME does not guess one."

case "$DECLARED" in
  *[[:space:]]*)
    stop_unestablished "$OWNER_REL holds more than one field ('$DECLARED'). That is the retired '{task-id} {date}' shape or a corrupted line; it is not a declaration. $COMMAND_NAME stopped and changed nothing — this is the operator's to correct." ;;
esac

[ "$OWNER_LINES" -le 1 ] ||
  stop_unestablished "$OWNER_REL holds more than one line. A checkout declares exactly one task; $COMMAND_NAME stopped rather than choosing between them."

# ------------------------------------------------------------------- the helpers
# A declaration exists, so lifecycle MUST be established before anything writes.
# Missing helpers therefore stop rather than skip — the opposite of the absent
# `.owner` case above, and deliberately so: there, nothing claimed the checkout.
OWNER_BIN="$CHECKOUT/logs/scripts/work-loop-owner.sh"
STATE_BIN="$CHECKOUT/logs/scripts/work-loop-state.sh"

[ -f "$OWNER_BIN" ] && [ -r "$OWNER_BIN" ] ||
  stop_unestablished "$OWNER_REL declares task '$DECLARED', but logs/scripts/work-loop-owner.sh is missing or unreadable in this checkout. Ownership is unestablished; $COMMAND_NAME stopped."
[ -f "$STATE_BIN" ] && [ -r "$STATE_BIN" ] ||
  stop_unestablished "$OWNER_REL declares task '$DECLARED', but logs/scripts/work-loop-state.sh is missing or unreadable in this checkout. Lifecycle is unestablished; $COMMAND_NAME stopped."

# The owner verdict is read ONLY as confirmation of the id already read above.
# The same command answers PROCEED for a checkout that declares no writer at
# all, so a bare PROCEED is not evidence that a task exists.
OWNER_OUT="$(bash "$OWNER_BIN" check --checkout "$CHECKOUT" --task "$DECLARED" --depth local 2>&1)"
OWNER_RC=$?
[ "$OWNER_RC" -eq 0 ] ||
  stop_unestablished "logs/scripts/work-loop-owner.sh did not confirm task '$DECLARED' in this checkout (exit $OWNER_RC). $OWNER_OUT"

[ -f "$CHECKOUT/logs/work-loop/$DECLARED.md" ] ||
  stop_unestablished "$OWNER_REL declares task '$DECLARED', but logs/work-loop/$DECLARED.md does not exist in this checkout. A declaration with no record is contradictory; $COMMAND_NAME stopped rather than repairing either side."

# ---------------------------------------------------------------- classification
CLASS="$(bash "$STATE_BIN" validate --checkout "$CHECKOUT" --task "$DECLARED" 2>&1)"
STATE_RC=$?
[ "$STATE_RC" -eq 0 ] ||
  stop_unestablished "logs/scripts/work-loop-state.sh could not classify task '$DECLARED' (exit $STATE_RC). Lifecycle is unestablished and there is no second reading to fall back on. $CLASS"

case "$CLASS" in
  ACTIVE_CLAUDE)
    stop_route "/work-loop-v2 $DECLARED" \
      "this checkout is held by open Work Loop task '$DECLARED', and it is Claude's move. Running $COMMAND_NAME here would start a second state system over it. Continue the task instead; if the conversation has been compacted, reorient first." ;;
  ACTIVE_CODEX)
    stop_route "hand the turn to Codex for task '$DECLARED' — its record is logs/work-loop/$DECLARED.md" \
      "this checkout is held by open Work Loop task '$DECLARED', and it is Codex's move. Running $COMMAND_NAME here would start a second state system over it." ;;
  BLOCKED_OPERATOR)
    stop_route "read '## Blocker' in logs/work-loop/$DECLARED.md and decide it" \
      "this checkout is held by Work Loop task '$DECLARED', which is BLOCKED and waiting on an operator decision. It is stopped, not finished — $COMMAND_NAME would write session state over a task that is still open." ;;
  CLOSED)
    # Canonical stale-owner semantics: a CLOSED record under a surviving
    # declaration is a stale declaration, not an open task. It is cleared by the
    # next task start in this checkout, NOT from here — this script mutates
    # nothing, and a legacy command is the wrong place to end a Work Loop lease.
    proceed "this checkout declares task '$DECLARED', which is CLOSED — a stale declaration, not an open task. $COMMAND_NAME proceeds unchanged; the declaration is left exactly as found for the next Work Loop task start to clear." ;;
  *)
    stop_unestablished "logs/scripts/work-loop-state.sh returned an unrecognised classification for task '$DECLARED': '$CLASS'. $COMMAND_NAME stopped rather than interpreting it." ;;
esac
