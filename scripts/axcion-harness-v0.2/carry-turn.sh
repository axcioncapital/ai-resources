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
#   --claude-deny RULE repeatable. APPENDED to the mandatory nested-actor rules
#                      below and passed to the Claude child as one
#                      --disallowedTools list, e.g. 'Bash(git push:*)'. Default:
#                      none extra. It can only narrow the child's authority
#                      further — it cannot displace or replace a mandatory rule.
#   --claude-permission-mode MODE
#                      The Claude hop's permission mode for THIS invocation only.
#                      Exactly two values, case-sensitive: `default` (what you
#                      get when the option is absent) and `acceptEdits`. Every
#                      other value, including `bypassPermissions` and an absent
#                      one, is BAD_USAGE before anything launches. Claude only —
#                      the Codex path never reads it. No settings file changes.
#   --log-dir DIR      run evidence directory.
#                      Default <checkout>/logs/harness-runs
#   --dry-run          validate and route; launch nothing
#   -h, --help         print this block
#
# ATTENDED PERMISSION POLICY. Every Claude hop is launched with an EXPLICIT
# --permission-mode, on every path, with or without --claude-deny. There is no
# flag that omits it. Without it the child INHERITS the checkout's own
# defaultMode — which in this repository is `bypassPermissions` — so an actor
# would receive bypass authority nobody asked for. Stating the mode at launch
# fixes that without editing any settings.json. It is a permission policy and
# not containment: it makes the child ask, it does not sandbox it.
# `--dangerously-skip-permissions` is never passed, on any path.
#
# The mode is `default` unless the operator asks for the ONE authorised widening
# on that one invocation.
#
# ONE OPERATOR-APPROVED WIDENING, PER INVOCATION.
# `--claude-permission-mode acceptEdits` is the only widening this surface
# offers. It is opt-in and it lasts exactly this invocation.
# It is stored nowhere and remembered nowhere, so the next invocation starts at
# `default` again with nothing to inherit. It reaches the Claude hop only, and it
# lets the child apply file edits without being asked each time.
# It is NOT bypass: the child still asks about everything else, and
# --dangerously-skip-permissions is still never passed.
#
# THE ALLOW-PATH SET IS DETECTION, NOT PREVENTION. The launch line prints the
# effective --allow-path set beside the widening. Read what that set is: this
# script compares the working tree AFTER the hop against it. It does not stop a
# write, the child never reads it, and an accepted edit outside it happens first
# and is reported afterwards (exit 24, or exit 30 once committed). Under
# `acceptEdits` nobody is asked first, so after-the-fact detection is the only
# boundary left — which is why the widening is attended, per-invocation, and
# printed rather than assumed.
#
# EVERYTHING ELSE FAILS CLOSED, before the lock, the run log and any actor:
# `bypassPermissions`, `auto`, `manual`, `dontAsk`, `plan`, differently-cased
# spellings of the two allowed values, and an absent value are all BAD_USAGE
# (exit 10). The check is an allowlist of exactly two strings, so a mode this
# surface has not authorised cannot arrive merely by being new.
#
# NESTED ACTORS. Every Claude hop is ALSO launched with a mandatory
# --disallowedTools set that asks the child to refuse the ordinary direct Bash
# routes for starting another `claude` or another `codex`:
#
#     Bash(claude:*)   Bash(claude *)   Bash(codex:*)   Bash(codex *)
#
# Both the colon form and the space form are listed for each actor, because
# which one an installed build honours is not established and listing only one
# would rest the policy on that guess.
#
# It is passed with or without --claude-deny, there is no flag to turn it off,
# and operator --claude-deny rules are APPENDED to it rather than replacing it.
# `--claude-permission-mode acceptEdits` does not touch it either: the widening
# changes the permission mode and nothing else, so a widened hop carries exactly
# the same mandatory rules as a default one.
# One attended hop should stay one attended hop; without this, a hop can expand
# into nested Claude or Codex processes that nobody launched and nobody watches.
#
# READ THIS HONESTLY. These are REQUESTED PERMISSION RULES, evaluated by the
# Claude child itself. They block the DEFAULT DIRECT ROUTE. They are not OS
# containment, not a sandbox, not a process limit, and NOT proof that nesting is
# impossible — a determined or differently-worded invocation is not covered, and
# this surface makes no claim that it is. What is verifiable here is the argv:
# the rules are requested on every Claude launch. Enforcement belongs to the
# child, and only attended operation makes that trustworthy.
#
# The Codex actor path REQUESTS direct-route refusal by a different mechanism,
# because `codex exec` (0.147.0-alpha.6.5) offers sandbox modes and config
# overrides, not a per-command deny list. A dedicated machine-wide execpolicy
# rules file marks a direct `claude` or `codex` command `prompt`, and this
# launcher requests approval_policy=never.
# Execpolicy parses only `allow` and `prompt` — there is no `deny` — so that
# pairing is the only shape this mechanism offers.
#
# READ IT AS REQUESTED, exactly like the Claude rules above: not OS containment,
# not a sandbox, not a process limit, and NOT proof that nesting is impossible.
# Three things are UNVERIFIED here, and this script claims none of them:
#   1. that the rules file is loaded on any given run
#      (`--ignore-rules` is the documented opt-out);
#   2. that the requested policy is effective;
#   3. what a matched command's runtime disposition then is.
# Wrapper and absolute-path routes (`bash -lc 'claude -p x'`, `env claude -p x`)
# are UNMATCHED — an accepted limitation this surface records rather than solves.
#
# Exit codes. 0 is the only success, and the RESULT line says which success it is
# — read that line, not the code alone.
#   0   see RESULT outcome=CARRIED or outcome=OPERATOR_TERMINAL
#   10  BAD_USAGE              includes every attended-boundary refusal
#   11  BAD_CHECKOUT           also the LEASE-INFRASTRUCTURE outcome: an
#                              unresolvable or unreadable Git common directory,
#                              an uncreatable lease root, and a checkout whose
#                              shared lease library (logs/scripts/work-loop-lease.sh)
#                              is missing or unreadable. That last one FAILS
#                              CLOSED and launches nothing — an absent lease is
#                              not a taken lease.
#   12  BAD_TASK_ID            traversal or illegal characters
#   13  STATE_MISSING
#   14  IDENTITY_MISMATCH      filename stem != frontmatter task:
#   15  BAD_TURN               turn: not in {codex, claude, operator}
#   16  FOREIGN_STAGED         something already staged; refuse to sweep it in
#   17  LOCK_HELD              a live lease is held, and the message says WHICH
#                              of the two resources refused, because the remedy
#                              differs. CHECKOUT: another run owns this working
#                              tree — any task, not just this one; run a
#                              concurrent task in its own linked worktree and
#                              pass that with --checkout. TASK: the same logical
#                              task is already live somewhere in this repository,
#                              including in another linked worktree, and a second
#                              checkout does not make it a second task. The
#                              holder may be an attended carry or an unattended
#                              dispatched run: both take the same shared lease.
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
#   33  OWNERSHIP_REFUSED      repository-depth ownership says this task belongs
#                              to a different checkout. Continue it there, or
#                              close it there first. Nothing was launched.
#   34  OWNERSHIP_AMBIGUOUS    ownership cannot be established — usually a state
#                              file replicated across checkouts with none of them
#                              declaring it. Not a condition to work around: the
#                              operator names the owner. Nothing was launched.
#   35  OWNERSHIP_UNAVAILABLE  the ownership check could not run at all — the
#                              helper (logs/scripts/work-loop-owner.sh) is
#                              missing, unreadable, or failed. FAILS CLOSED: an
#                              absent check is not a passed check.
#                              33, 34 and 35 are the Work Loop's ownership codes
#                              and are shared with the unattended dispatcher, so
#                              one condition reads the same on both transports.
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
# NESTED-ACTOR OBSERVATION. Separately from the requested deny rules above, and
# never as a substitute for them, every LIVE hop is watched: the actor's own
# process group is sampled while the actor runs, and processes in it named
# `claude` or `codex` — excluding the top-level actor itself — are counted. The
# largest count any one sample saw is reported, on the RESULT line and in the
# run log.
#
# READ THE ZERO HONESTLY. `nested=0` means no such process was OBSERVED, in that
# group, during that window, by that rule. It is not proof that none existed and
# it is not containment. A requested deny rule, a successful hop, or the absence
# of a denial is never evidence of an observed zero — only a sample that ran is,
# which is why `nested=unobserved` exists and is not the same value. The full
# mechanism, the recognition rule and the blind spots it does not cover are
# documented at the observe_nested function below.
#
# EVERY terminal path prints one RESULT line as its last line:
#   RESULT outcome=<CARRIED|OPERATOR_TERMINAL|STOPPED|VALIDATED> code=<n> ...
#          ... denials=<n|unavailable|n/a> partial=<n> ...
#          ... actors=<n> nested=<n|unobserved|n/a>
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

# The Claude hop's permission mode. `default` unless this invocation explicitly
# asks for the one authorised widening. Held in this process only — nothing here
# is written to a settings file, a ledger or any other durable surface, so the
# next invocation starts at `default` again with no way to inherit a widening.
CLAUDE_PERMISSION_MODE="default"

# Requested of EVERY Claude hop, whatever else is passed. Not an option, not
# overridable, and deliberately not derived from anything the caller supplies:
# an operator rule can only be added after these, never in place of one.
# `--disallowedTools` takes a space- or comma-separated list on Claude Code
# 2.1.220 (`--disallowedTools, --disallowed-tools <tools...>`), so the mandatory
# rules and the operator's are one list, mandatory first.
#
# BOTH the colon form and the space form, per actor. Which one an installed
# build honours has not been established here: the CLI's own help writes its
# example in the space form (`Bash(git *) Edit`), while the colon form is the
# shape used elsewhere in this workspace. Listing only one would make the whole
# policy rest on a guess about matching behaviour, and the argv evidence would
# then prove that a string was passed rather than that the route is denied.
# Listing both costs one array entry each and removes the guess. Same reason the
# spike dispatcher's NESTED_ACTOR_DENY carries all four.
CLAUDE_DENY_MANDATORY=(
  'Bash(claude:*)'
  'Bash(claude *)'
  'Bash(codex:*)'
  'Bash(codex *)'
)

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
# Actor observation. `actors` counts the top-level actors THIS invocation
# launched — observed at the launch itself, not asserted from the one-hop rule.
# `nested` carries the same three-state honesty as `denials`: `n/a` when nothing
# launched, `unobserved` when the census could not run, and a number only when it
# did. See NESTED-ACTOR OBSERVATION above.
R_ACTORS="0"
R_NESTED="n/a"

ACTORS_LAUNCHED=0
NESTED_MAX=0
NESTED_SAMPLES=0
NESTED_SEEN=""

ACTOR_CAPTURE=""

# Read-only views of the two lease paths the shared library resolves, kept under
# this script's own names for its refusal wording. Assigned in the lease block
# below; nothing here derives a lease path a second time.
LOCK_DIR=""
TASK_LOCK_DIR=""
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
  printf 'RESULT outcome=%s code=%s task=%s mode=%s actor=%s turn_before=%s turn_after=%s denials=%s partial=%s actors=%s nested=%s\n' \
    "$1" "$2" "${TASK:-none}" "$R_MODE" "$R_ACTOR" "${R_BEFORE:-none}" "${R_AFTER:-none}" \
    "$R_DENIALS" "$R_PARTIAL" "$R_ACTORS" "$R_NESTED"
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
      usage_die "'$1' is refused: this surface does not forward a raw permission mode to the child, and it never passes a bypass. The Claude hop runs --permission-mode default unless you ask for the one authorised widening, --claude-permission-mode acceptEdits, which applies to this invocation only. Narrow the child further with --claude-deny if you need to." ;;
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
    # The value is required explicitly rather than defaulted from "${2:-}". A
    # permission widening must never be reachable by writing the flag and
    # nothing else, and `shift 2` with one argument left shifts nothing — so
    # without this guard the missing-value case would spin instead of refusing.
    --claude-permission-mode)
      [ $# -ge 2 ] || usage_die "--claude-permission-mode requires a value: default or acceptEdits"
      CLAUDE_PERMISSION_MODE="$2"; shift 2 ;;
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

# An ALLOWLIST of exactly two strings, checked here — before the lock, before the
# run log, before any actor. A mode this surface has not authorised must not
# arrive by being new, so the last branch refuses rather than passing the value
# through to the CLI's own choices list. Case-sensitive on purpose: the installed
# CLI is too, and quietly repairing `AcceptEdits` would mean this script decided
# a widening the operator did not type.
case "$CLAUDE_PERMISSION_MODE" in
  default|acceptEdits) : ;;
  *[Bb]ypass*|*BYPASS*|*dangerously*)
    usage_die "--claude-permission-mode '$CLAUDE_PERMISSION_MODE' is refused: this surface never launches an actor with bypass authority, on any path and for any reason. The two authorised values are default and acceptEdits. If a hop genuinely needs more than acceptEdits, that is an operator decision outside this script." ;;
  *)
    usage_die "--claude-permission-mode '$CLAUDE_PERMISSION_MODE' is not authorised on this surface. Exactly two values are, and they are case-sensitive: default (the default) and acceptEdits (an explicit one-invocation widening). Nothing was launched." ;;
esac

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

# ------------------------------------------------------------------- lease
# One live actor-launching run per TASK, and one per CHECKOUT. Both leases are
# taken before anything launches, and the mechanism is a shared library rather
# than a second implementation of it.
#
# WHY IT MOVED. This surface used to key ONE lock, on the canonical checkout path,
# under $TMPDIR. The unattended dispatcher keyed TWO, rooted in the repository's
# Git common directory. Neither program read the other's path, so an attended
# carry and a dispatched run could enter the same working tree each believing it
# was the only writer, and both would report a clean single-writer run. Two
# implementations of one invariant is also the shape that made the original
# composite key wrong in two programs at once. There is now one implementation,
# in logs/scripts/work-loop-lease.sh, and both transports source it.
#
# THE TWO RESOURCES, and what each means here:
#
#   task lease      one live run per logical task, ANYWHERE in this repository,
#                   including in another linked worktree. This is NEW on this
#                   surface. A separate worktree used to be independently
#                   admissible for the same task; it is not, because one task is
#                   one line of work and a second checkout does not make it two.
#   checkout lease  one live run per physical checkout, whatever task it names.
#                   This is the rule this surface already had, unchanged: a
#                   checkout is a single working tree with a single index and a
#                   single HEAD, so two actors in it are two writers to one
#                   surface no matter which tasks they carry.
#
# So two DIFFERENT tasks in two different worktrees stay admissible side by side.
# That is still the intended unit of isolation, and the change must not be read as
# refusing every worktree — only the same task twice.
#
# THE LIBRARY IS SOURCED, NOT RUN, and it has to be: the lease must be held by
# THIS process for the whole of its life, because the pid it records is what a
# refusal names and the release runs from this script's own exit paths.
#
# Exact task/state identity remains a separate invariant (validate_state); a lease
# is about write authority over a working tree and over a task, not about which
# file is correct.
#
# NOT the durable checkout declaration in logs/scripts/work-loop-owner.sh. That
# one is a committed-repository record of which task owns a checkout across
# sessions; a lease is an ephemeral live-process fact that dies with its process.
# The two are deliberately separate and neither is a registry of the other.
#
# Three pid states, not two, and the library keeps them: a lease whose holder
# cannot be inspected is treated as held and nothing is deleted. The failure mode
# of guessing "stale" is two live actors in one checkout, which is the thing this
# exists to prevent.
#
# RESOLVED FROM THE CHECKOUT BEING DRIVEN, like the state file itself. A checkout
# that cannot produce the library is a checkout whose lease cannot be established,
# so it FAILS CLOSED here — before any lease path is computed and long before an
# actor launches. The code is 11, the BAD_CHECKOUT outcome this script already
# uses; an absent lease is not a taken lease.
LEASE_LIB="$CHECKOUT/logs/scripts/work-loop-lease.sh"
if [ ! -f "$LEASE_LIB" ] || [ ! -r "$LEASE_LIB" ]; then
  printf 'STOP [11] the shared lease library is missing or unreadable: %s\n' "$LEASE_LIB" >&2
  printf '  The live lease cannot be taken without it, so nothing was launched and nothing\n' >&2
  printf '  was committed. Recoverable next action: restore logs/scripts/work-loop-lease.sh\n' >&2
  printf '  in that checkout, or run the task in a checkout that carries it, then re-run.\n' >&2
  result_line STOPPED 11
  exit 11
fi
# shellcheck source=../../logs/scripts/work-loop-lease.sh
# shellcheck disable=SC1090,SC1091
. "$LEASE_LIB" || {
  printf 'STOP [11] the shared lease library could not be sourced: %s\n' "$LEASE_LIB" >&2
  result_line STOPPED 11
  exit 11
}

wl_lease_init "$CHECKOUT" "$TASK"
case "$?" in
  0) ;;
  1) printf 'STOP [11] cannot resolve the Git common directory for %s\n' "$CHECKOUT" >&2
     result_line STOPPED 11; exit 11 ;;
  *) printf 'STOP [11] the Git common directory for %s is not readable\n' "$CHECKOUT" >&2
     result_line STOPPED 11; exit 11 ;;
esac

LOCK_DIR="$WL_LEASE_CHECKOUT_DIR"
TASK_LOCK_DIR="$WL_LEASE_TASK_DIR"

# THE LEGACY PATH, READ ONLY, FOR ONE RELEASE.
#
# The lease root moved out of $TMPDIR and into the repository. A carry that was
# already in flight when that change landed holds a lock the new code does not
# look at, so for one release this surface still READS the old location and
# refuses a holder it finds there. Without this, the changeover itself would be
# the one window in which two writers are both admitted — one holding the old
# lock, one holding the new leases — which is precisely the failure the change
# exists to close.
#
# Nothing is migrated. An old lock is never turned into a new lease: a lease
# belongs to a live process, and that process is not this one. The only write on
# this path is the one this surface could already justify — removing a lock whose
# pid is PROVABLY not running, which is the existing stale-lock policy, unchanged
# and still announced. A LIVE holder and an UNINSPECTABLE one are refused and
# nothing is deleted.
#
# THREE STATES, NOT TWO — AND THE VERDICT IS NOT THIS FILE'S TO MAKE. This used
# to ask `kill -0` and treat every failure as death. `kill -0` fails for two
# unrelated reasons:
#
#   ESRCH  "no such process"          -> the pid really is absent
#   EPERM  "operation not permitted"  -> the pid may well be ALIVE; this caller
#                                        is simply not allowed to look at it
#
# Conflated, an uninspectable holder read as stale — so this path DELETED a lock
# that was doing its job and admitted a second writer into the working tree,
# inside the one changeover window the legacy read exists to protect. The
# asymmetry only points one way: a false UNKNOWN costs one more look, a false
# ABSENT costs two live runs in one checkout.
#
# So the classification is DELEGATED to wl_lease__pid_state, the shared probe
# that already admits every live lease. Deliberately the library's function and
# not a copy: a second classifier behind lease admission is the exact defect this
# correction closes, and a copy here would be that defect wearing a legacy label.
# The library is sourced, and wl_lease_init has already run, well before
# acquire_lock reaches this function — so the probe is in scope, called read-only,
# and the library's public contract is untouched.
legacy_lock_check() {
  local key holder holder_task lock_path verdict state reason claimed
  key="$(printf '%s' "$CHECKOUT" | shasum -a 256 | cut -c1-16)"
  lock_path="${TMPDIR:-/tmp}/axcion-harness-v0.2.$key.lock"
  [ -d "$lock_path" ] || return 0

  holder="$(cat "$lock_path/pid" 2>/dev/null)"
  holder_task="$(cat "$lock_path/task" 2>/dev/null)"

  verdict="$(wl_lease__pid_state "$holder")"
  state="${verdict%%|*}"
  reason="${verdict#*|}"

  if [ "$state" = LIVE ]; then
    die 17 "another carry is in flight for this CHECKOUT (pid $holder, task '${holder_task:-unrecorded}', holds $lock_path). One checkout is one working tree, so it carries one task at a time — this is refused whether or not it is the same task. Wait for it, or stop it, then re-run. To run '$TASK' concurrently, give it its own linked worktree and pass that with --checkout."
  fi

  # UNKNOWN IS HELD. Everything that is not positively absent lands here: an
  # uninspectable pid, a pid file that is missing, empty, non-numeric, or zero /
  # zero-prefixed. The reason comes from the probe rather than being re-derived,
  # so the operator is told which of those it was — the remedy differs, and a
  # generic "cannot be shown stale" sent them to delete it either way.
  if [ "$state" != ABSENT ]; then
    die 17 "a lock directory exists for this checkout and its holder CANNOT BE SHOWN GONE, so it is treated as held ($lock_path, pid '${holder:-unrecorded}', task '${holder_task:-unrecorded}'): $reason. Not being able to inspect a process is not evidence that it stopped. Nothing was deleted. Confirm no carry is running in this checkout, then remove that directory by hand, and re-run."
  fi

  # POSITIVE ABSENCE IS THE ONLY STATE THAT WRITES — and the write is a RENAME
  # first, not an `rm -rf` in place. Two runs can both probe ABSENT on the same
  # lock; only one can win the rename, and the loser then finds the directory
  # gone rather than deleting a path a third run has since recreated. The target
  # is a sibling in the same directory, so the rename is atomic on one
  # filesystem, and the removal afterwards operates on a name nothing else holds.
  claimed="$lock_path.stale.$$"
  rm -rf "$claimed"
  if ! mv "$lock_path" "$claimed" 2>/dev/null; then
    # Lost the race, or could not write here at all. Those need different
    # answers, and the directory itself says which: gone means another run
    # cleared it and the resource is free — the new leases arbitrate what
    # happens next. Still there means this run cannot clean it, and guessing is
    # the failure mode this whole function exists to remove.
    [ -d "$lock_path" ] || return 0
    die 17 "a stale lock for this checkout could not be cleared ($lock_path, pid '${holder:-unrecorded}', task '${holder_task:-unrecorded}'). Its holder is not running, but the directory could not be renamed away, so nothing was deleted and nothing was launched. Check the permissions on ${TMPDIR:-/tmp}, or remove that directory by hand, then re-run."
  fi
  say "note: removing a stale lock — pid $holder (task '${holder_task:-unrecorded}') is not running."
  rm -rf "$claimed"
  return 0
}

# The library takes both leases in the task-then-checkout order, records who holds
# each in plain text, and rolls the task lease back if the checkout lease is
# refused. What stays here is the REFUSAL WORDING and the exit code — the library
# prints nothing and standardises neither, because this surface's refusals and the
# dispatcher's are each their own program's contract.
#
# A refusal must NAME the conflict rather than print a hash, and it must say which
# of the two resources refused, because the operator's remedy differs: a checkout
# refusal is answered by another worktree, a task refusal is not answered by
# anything except waiting. Holder fields come back empty when the metadata is
# unreadable, and empty renders as "unrecorded" — never as a free lease.
acquire_lock() {
  legacy_lock_check

  wl_lease_acquire carry "$$"
  case "$?" in
    0) return 0 ;;
    1) die 11 "cannot create the lease root $WL_LEASE_ROOT — the live lease cannot be taken, so nothing was launched."$'\n'"Recoverable next action: check that the repository's Git common directory is writable, then re-run." ;;
  esac

  local who
  case "${WL_LEASE_HOLDER_PROGRAM:-}" in
    carry)    who="an attended carry" ;;
    dispatch) who="an unattended dispatched run" ;;
    "")       who="another Work Loop run (program unrecorded)" ;;
    *)        who="another Work Loop run (${WL_LEASE_HOLDER_PROGRAM})" ;;
  esac

  if [ "$WL_LEASE_RESOURCE" = task ]; then
    if [ "$WL_LEASE_REFUSAL" = pinned ]; then
      die 17 "the TASK lease for '$TASK' is PINNED ($TASK_LOCK_DIR) — a previous run could not confirm the actor tree it started had stopped:"$'\n'"$(sed 's/^/  /' "$WL_LEASE_SURVIVORS" 2>/dev/null)"$'\n'"Recoverable next action: confirm the pids above are gone, then remove that directory by hand. Nothing was deleted here."
    fi
    die 17 "$who already holds the TASK lease for '$TASK' (pid ${WL_LEASE_HOLDER_PID:-unrecorded}, in checkout ${WL_LEASE_HOLDER_CHECKOUT:-unrecorded}, holds $TASK_LOCK_DIR). One task is one live run anywhere in this repository, including in another linked worktree — a second checkout does not make it a second task. Wait for it, or stop it, then re-run."
  fi

  if [ "$WL_LEASE_REFUSAL" = pinned ]; then
    die 17 "this CHECKOUT's lease is PINNED ($LOCK_DIR) — a previous run in it could not confirm the actor tree it started had stopped:"$'\n'"$(sed 's/^/  /' "$WL_LEASE_SURVIVORS" 2>/dev/null)"$'\n'"Recoverable next action: confirm the pids above are gone, then remove that directory by hand. Nothing was deleted here."
  fi
  die 17 "$who is in flight for this CHECKOUT (pid ${WL_LEASE_HOLDER_PID:-unrecorded}, task '${WL_LEASE_HOLDER_TASK:-unrecorded}', holds $LOCK_DIR). One checkout is one working tree, so it carries one task at a time — this is refused whether or not it is the same task. Wait for it, or stop it, then re-run. To run '$TASK' concurrently, give it its own linked worktree and pass that with --checkout."
}

# Pinned beats owned, and that check lives inside the library rather than at each
# call site — one missed caller would silently undo the invariant. Every exit path
# of this script reaches here: die(), the terminal branches, and the signal
# handler by way of die().
release_lock() { wl_lease_release; }

# THE PIN. When a run cannot prove the actor tree it started has stopped, the
# process that knows about the survivors is about to exit, so the only thing that
# can carry that knowledge forward is the lease it leaves behind. BOTH leases are
# pinned, because a survivor holds both resources: it belongs to this task, and it
# is still running inside this checkout's working tree.
#
# The pin FILE — its line formats, the both-leases rule, and the guards that stop
# a pin claiming a lease this run never acquired — is the library's. What stays
# here is the OPERATOR-FACING line, which is this surface's wording and names this
# surface's exit 17.
#
# THE LIBRARY ANSWERS WITH THREE OUTCOMES AND THEY NEED THREE ANSWERS. This used
# to read `wl_lease_pin ... || return 0`, which merged every one of them into
# silence:
#
#   0  pinned, and every owned lease carries durable evidence a later run reads.
#   1  nothing was owned, so nothing was pinned — the ordinary state of a run that
#      was refused, or never reached acquire_lock. Not a failure, nothing to say.
#   2  owned and pinned, but at least one lease has NO durable record. The
#      DIRECTORIES are still there and still refuse the next run; what is missing
#      is the written reason inside them.
#
# rc=2 is why the merge mattered. Silence there leaves the operator in front of a
# held lease with nothing inside explaining it, and the obvious reading — a stale
# lock, safe to delete — is the unsafe one. So it is said out loud, and the rc=0
# success line is withheld, because announcing a pin that recorded nothing is the
# same false claim in the opposite direction.
#
# An unrecognised code is reported as unrecognised rather than assumed benign: the
# library may grow a fourth outcome, and inheriting silence by default is exactly
# how this defect arrived the first time.
#
# The pin FILE — its line formats, the both-leases rule, and the guards that stop
# a pin claiming a lease this run never acquired — is the library's. What stays
# here is the OPERATOR-FACING wording, which is this surface's and names this
# surface's exit 17.
pin_leases() { # survivor-pids, unknown-reason
  local rc=0
  # Split from any `local` declaration on purpose: `local x="$(cmd)"` reports
  # `local`'s status, not the command's, and the same trap applies to capturing a
  # return code that this whole function now turns on.
  wl_lease_pin "${1:-}" "${2:-}" "$TASK"; rc=$?
  case "$rc" in
    0)
      say "  BOTH leases are now PINNED and deliberately NOT released — the TASK lease for '$TASK' ($TASK_LOCK_DIR) and this CHECKOUT's lease ($LOCK_DIR)."
      say "  The next Work Loop run on this task, or in this checkout, is refused with exit 17 until you confirm the pids above are gone and remove those two directories by hand."
      ;;
    1)
      : # nothing was owned, so nothing was pinned. There is no lease to describe.
      ;;
    2)
      say "  WARNING: the pin RECORD could not be persisted for: ${WL_LEASE_PIN_FAILED:-an unnamed lease}."
      say "  Those lease directories are deliberately RETAINED and were NOT released, so the next Work Loop run on this task, or in this checkout, is still refused with exit 17."
      say "  What is missing is the written reason inside them, so a later run and --status cannot say why they are held. Do NOT read them as a removable stale lease: confirm the pids above are gone before removing anything by hand."
      ;;
    *)
      say "  WARNING: the lease library returned an UNRECOGNISED pin result ($rc), so this launcher cannot tell what was recorded."
      say "  Treat the lease directories as retained: they were NOT released, and the next Work Loop run on this task, or in this checkout, is still refused with exit 17. Confirm the pids above are gone before removing anything by hand."
      ;;
  esac
  return 0
}

# ------------------------------------------------------- interruption

# WHAT IS STILL IN THE ACTOR'S PROCESS GROUP, BY NAME. `kill -0` on a group
# answers one bit, and it answers it wrong in the one direction that matters: a
# survivor this uid may not signal returns EPERM, which is indistinguishable from
# an empty group. A census names the pids instead — which is what the operator
# needs, and what the pin file has to record for `--status` and the next run to be
# about anything.
#
# THE CONTROL IS WHAT MAKES AN EMPTY ANSWER MEAN SOMETHING. `ps` over an empty
# group and a `ps` that cannot run both print nothing, so an empty answer has to
# be corroborated by a question whose answer is known in advance. Without that,
# a broken `ps` would read as a confirmed-clean shutdown, and missing evidence
# would have become a clean bill of health. Same rule the nested-actor census
# already follows.
#
# THE CONTROL MUST EXERCISE THE QUERY FORM THIS FUNCTION ACTUALLY USES. It used
# to ask `ps -p $$`, which proves that a DIFFERENT form works: a `ps` whose `-p`
# answers and whose `-g` cannot run passed that control and then returned no
# rows, which the caller read as a confirmed-empty group. Nor can the exit status
# stand in — on this platform `ps -g` exits non-zero for an empty group as well
# as for a failure (checked 2026-08-15: an unused in-range pgid gives rc=1 with
# no output), so propagating it would make every clean shutdown read as unknown.
# So the control asks the `-g` form about a group that cannot be empty: this
# shell's own, which must contain this shell.
#
# Prints the surviving pids on stdout. Returns 1 when the census could not run.
actor_group_census() { # pgid
  local pgid="$1" own out
  own="$(ps -o pgid= -p $$ 2>/dev/null | tr -d ' ')"
  [ -n "$own" ] || return 1
  ps -o pid=,pgid= -g "$own" 2>/dev/null \
    | awk -v g="$own" -v me="$$" '$1 == me && $2 == g { found = 1 } END { exit !found }' \
    || return 1
  out="$(ps -o pid=,pgid= -g "$pgid" 2>/dev/null)"
  printf '%s\n' "$out" \
    | awk -v g="$pgid" '$1 != "" && $2 == g { printf "%s%s", sep, $1; sep = " " }'
  return 0
}

# Returns 0 only when the actor's tree is PROVEN stopped. Anything else — a named
# survivor, a census that could not run, or a group that still answers — is
# unproven, and unproven pins both leases (proposal § 4.1 property 4). Ordinary
# cleanup must not release them, and it cannot: the library checks PINNED before
# OWNED inside wl_lease_release.
terminate_actor_group() { # pgid
  local pgid="$1" waited=0 survivors='' unknown='' census_rc=0
  [ -n "$pgid" ] || return 0
  kill -TERM "-$pgid" 2>/dev/null

  # THE GRACE PERIOD IS A PROOF STEP, NOT A SIGNAL PROBE. This loop used to end
  # the whole function on `kill -0` failing, which answers one bit and answers it
  # wrong in the direction that matters: a survivor this uid may not signal
  # returns EPERM, and EPERM is indistinguishable from an empty group. A tree
  # whose top-level actor exits on SIGTERM stops answering as a group while a
  # descendant is still there, so that shortcut released both leases at exactly
  # the moment a second writer could start beside the survivor.
  #
  # So the same census that decides after SIGKILL decides here, and only a census
  # that RAN and named nobody ends the wait early. A census that could not run
  # neither shortens the grace period nor releases anything: it proves nothing,
  # and the SIGKILL branch below is then the one that has to answer.
  while [ "$waited" -lt "$TERM_GRACE_SECS" ]; do
    survivors="$(actor_group_census "$pgid")"; census_rc=$?
    if [ "$census_rc" -eq 0 ] && [ -z "$survivors" ]; then
      return 0
    fi
    sleep 1; waited=$((waited + 1))
  done
  survivors=''; census_rc=0
  kill -KILL "-$pgid" 2>/dev/null
  sleep "$KILL_SETTLE_SECS"

  # Split from the declaration on purpose: `local x="$(cmd)"` reports `local`'s
  # status, not the command's, so the census failure would be invisible.
  survivors="$(actor_group_census "$pgid")"; census_rc=$?
  if [ "$census_rc" -ne 0 ]; then
    survivors=''
    unknown="the process-group census could not run on this host, so no survivor was ruled out"
  fi

  # RELEASE IS LICENSED BY THE CENSUS AND BY NOTHING ELSE. A census that ran and
  # named nobody is the only clean answer here. A named survivor is unproven, and
  # so is a census that could not run — both pin.
  #
  # There is ONE corroboration and it can only WITHHOLD. If the group still
  # answers signals after all of that, the two inspections disagree, and a
  # disagreement is not proof of death, so it is recorded as unknown. It never
  # runs the other way: a failed signal probe cannot turn an absent or unusable
  # census into a clean shutdown. That direction — `kill -0` deciding the
  # question on its own — is the shortcut this branch used to take.
  #
  # The reason has to be SAID in that case, or the pin file would carry neither a
  # survivor line nor a sweep line and the operator would be told to inspect
  # nothing.
  if [ -z "$survivors" ] && [ -z "$unknown" ]; then
    if kill -0 "-$pgid" 2>/dev/null; then
      unknown="process group $pgid still answers to signals, but the census named no member of it"
    else
      return 0
    fi
  fi

  say "WARNING: process group $pgid could not be confirmed gone after SIGKILL — inspect before re-running."
  [ -n "$survivors" ] && say "  still running in the actor's process group: $survivors"
  [ -n "$unknown" ] && say "  sweep incomplete: $unknown"
  pin_leases "$survivors" "$unknown"
  return 1
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

# -------------------------------------------------- nested-actor observation
#
# WHAT THIS IS. A census of the actor's own process group, repeated while the
# actor runs, counting processes whose executable name is `claude` or `codex`
# and which are not the top-level actor itself. The largest count any single
# sample saw is what gets reported.
#
# WHAT IT IS NOT. It is not prevention, not containment, and not a process
# limit. Nothing here stops a nested actor; the mandatory --disallowedTools set
# asks the child not to start one, and this says what was actually seen. The two
# are separate claims and neither substitutes for the other. In particular, a
# requested deny rule, a successful hop and the absence of a denial are NOT
# evidence of an observed zero — only a sample that ran is.
#
# THE BOUNDARY IS THE ACTOR'S PROCESS GROUP. `set -m` in run_bounded makes the
# actor a process-group leader, and a non-interactive child inherits that group,
# so a nested actor started the ordinary way lands inside it. The census is
# scoped to that group and never to the machine: a developer's unrelated editor
# sessions are not this hop's nested actors, and counting them would make the
# field meaningless.
#
# A SAMPLE ONLY COUNTS IF IT SAW THE TOP-LEVEL ACTOR. That is the census
# proving to itself that the group was actually readable. Without it, a `ps`
# that returned nothing would be indistinguishable from a group with nothing in
# it, and an empty answer would quietly become an observed zero.
#
# HOW A PROCESS IS RECOGNISED. By the basename of `ps -o comm=`, which on this
# platform reports the path the process was INVOKED by rather than the resolved
# symlink target — checked on 2026-08-13 against a symlink named `claude`
# pointing elsewhere, which reported the symlink path. Both real installs are
# caught by that rule: the PATH install runs through a `claude` symlink, and the
# VS Code build is `.../native-binary/claude`. The default --codex-bin
# (/Applications/ChatGPT.app/Contents/Resources/codex) likewise ends in `codex`.
#
# BLIND SPOTS, STATED RATHER THAN GLOSSED. A zero means no such process was
# observed here, during this window, by this rule. It does not mean none
# existed. Not covered:
#   - a nested actor started through a wrapper or interpreter, where the
#     executable is `bash` or `node` and the actor's name is only an argument;
#   - a renamed or copied binary;
#   - a process that both started and exited between two samples (~1s apart);
#   - a process that left the group, e.g. via setsid or a daemonising launcher;
#   - anything at all once the hop has ended — the window is the hop.
# Checked on this host on 2026-08-13: no running `claude` or `codex` process had
# a `claude` or `codex` parent, so a same-named worker fork is not a known
# source of false positives here. That is an observation of one host on one day,
# not a property of every build.

# One sample. Returns 0 when the sample was valid, 1 when it was not.
observe_nested() { # pgid, top-level-pid
  local pgid="$1" top="$2" out saw_top=0 n=0 pid gid comm base
  out="$(ps -o pid=,pgid=,comm= -g "$pgid" 2>/dev/null)" || return 1
  [ -n "$out" ] || return 1

  # A here-doc, not a pipe: a pipe would run the loop in a subshell and every
  # count would be discarded at the end of it.
  while read -r pid gid comm; do
    [ -n "$pid" ] && [ -n "$comm" ] || continue
    [ "$gid" = "$pgid" ] || continue
    [ "$pid" = "$top" ] && { saw_top=1; continue; }
    base="${comm##*/}"
    case "$base" in
      claude|codex)
        n=$((n + 1))
        case "$NESTED_SEEN" in
          *"(pid $pid)"*) : ;;
          *) NESTED_SEEN="${NESTED_SEEN}    - (pid $pid) $comm"$'\n' ;;
        esac
        ;;
    esac
  done <<EOF
$out
EOF

  [ "$saw_top" -eq 1 ] || return 1
  NESTED_SAMPLES=$((NESTED_SAMPLES + 1))
  [ "$n" -gt "$NESTED_MAX" ] && NESTED_MAX="$n"
  # Published on every valid sample rather than at the end of the hop, so an
  # interrupted or timed-out run still reports what had been observed by then.
  R_NESTED="$NESTED_MAX"
  return 0
}

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

  # Counted at the launch itself. The one-hop rule says there should be exactly
  # one; a field that restated the rule instead of observing it could never
  # disagree with it, and so could never be evidence.
  ACTORS_LAUNCHED=$((ACTORS_LAUNCHED + 1))
  R_ACTORS="$ACTORS_LAUNCHED"
  # An actor launched but no valid sample yet. If the census never runs, this is
  # what gets reported — never a 0.
  R_NESTED="unobserved"

  # One sample before the loop, so a hop that ends immediately still gets an
  # observation window rather than reporting `unobserved` on a race.
  observe_nested "$pid" "$pid" || true

  start="$(date '+%s')"

  while kill -0 "$pid" 2>/dev/null; do
    if [ "$(( $(date '+%s') - start ))" -ge "$limit" ]; then
      terminate_actor_group "$pid"
      wait "$pid" 2>/dev/null
      ACTOR_PGID=""
      return 124
    fi
    observe_nested "$pid" "$pid" || true
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
      say "  nested-actor policy: requesting approval_policy=never on every Codex hop, beside a dedicated machine-wide execpolicy rules file that marks a direct claude or codex command 'prompt'."
      say "  This is REQUESTED policy only. It is not containment and NOT proof that nesting is impossible, and this launcher does not observe whether it took effect."
      say "  Unverified, and not claimed: that the rules file was loaded on this run, that the requested policy is effective, and the runtime disposition of a matched command. Wrapper and absolute-path routes are unmatched — an accepted limitation."
      say "  cmd: codex exec --sandbox workspace-write -c approval_policy=never -C <checkout> --json <prompt>"
      run_bounded "$limit" "$out" \
        "$CODEX_BIN" exec --sandbox workspace-write -c approval_policy=never \
        -C "$CHECKOUT" --json "$(codex_prompt)"
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
      # ONE launch line, not two. The mandatory nested-actor rules are never
      # absent, so there is no --claude-deny branch left to diverge: the
      # operator's rules only ever extend a list that already exists. The
      # earlier two-branch shape is what allowed a plain hop to carry no
      # --disallowedTools at all.
      local deny_all
      deny_all=("${CLAUDE_DENY_MANDATORY[@]}")
      if [ "${#CLAUDE_DENY[@]}" -gt 0 ]; then
        deny_all+=("${CLAUDE_DENY[@]}")
      fi
      cd "$CHECKOUT" || die 11 "cannot enter checkout: $CHECKOUT"
      say "  nested-actor policy: requesting ${CLAUDE_DENY_MANDATORY[*]} on every Claude hop — mandatory, no override; --claude-deny appends after it."
      say "  This is requested permission policy the child evaluates. It blocks the default direct route; it is not containment and not proof that nesting is impossible."
      # The widening is stated at the launch it applies to, not in a summary
      # afterwards, so an operator reads it while it still matters.
      if [ "$CLAUDE_PERMISSION_MODE" = "acceptEdits" ]; then
        say "  permission mode: acceptEdits — an OPERATOR-APPROVED WIDENING requested for THIS invocation only. It is stored nowhere, so the next run starts at default again."
        say "  It lets the child apply file edits without asking each time. It is not bypass: --dangerously-skip-permissions is still never passed, and the child still asks about everything else."
        say "  effective allow-path set: ${ALLOW_PATHS[*]}"
        say "  That set is DETECTION, not prevention: it is compared against the working tree AFTER the hop. It stops no write, the child never reads it, and an edit accepted outside it happens first and is reported afterwards (exit 24, or 30 once committed)."
      else
        say "  permission mode: default — the child asks. No widening was requested on this invocation."
      fi
      say "  cmd: claude -p '/work-loop-v2 $TASK' --output-format json --permission-mode $CLAUDE_PERMISSION_MODE --disallowedTools ${deny_all[*]} (cwd=<checkout>)"
      run_bounded "$limit" "$out" "$cb" -p "/work-loop-v2 $TASK" --output-format json \
        --permission-mode "$CLAUDE_PERMISSION_MODE" \
        --disallowedTools "${deny_all[@]}"
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

  # Actor observation. Stated as what was SEEN, with the boundary and the window
  # named, so a zero can never be read back as a containment claim.
  say "    actors:          $R_ACTORS top-level actor(s) launched by this invocation"
  case "$R_NESTED" in
    n/a)
      say "    nested actors:   n/a — nothing was launched, so nothing was observed" ;;
    unobserved)
      say "    nested actors:   NO OBSERVATION — the process census could not run, so the nested count is unknown."
      say "                     That is not the same as 'none observed'; treat it as unknown." ;;
    0)
      say "    nested actors:   0 observed — no process named claude or codex was observed in the actor's process group across $NESTED_SAMPLES sample(s)."
      say "                     Observation only: it is not proof that none existed. A wrapper-launched, renamed, short-lived or regrouped process is outside what this can see." ;;
    *)
      say "    nested actors:   $R_NESTED OBSERVED in the actor's process group across $NESTED_SAMPLES sample(s):"
      printf '%s' "$NESTED_SEEN" | sed '/^$/d' | while IFS= read -r l; do say "$l"; done
      say "                     One attended hop should stay one attended hop. Read the capture before accepting this handback." ;;
  esac

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

# ------------------------------------------------------- ownership admission
# The two leases taken above answer "is another run live?". They cannot answer
# "does this task belong to this checkout?", because a lease dies with its
# process and a task outlives one. That second question is the durable
# declaration's, and this surface asks it at REPO depth — it may run git, so
# unlike interactive Codex it can see the other worktrees of this repository.
#
# Two things it catches that nothing else does: the same task already claimed in
# a DIFFERENT checkout, and a state file REPLICATED across checkouts with no
# declaration deciding which copy is authoritative. Both are refused here, before
# an actor is launched and therefore before anything is committed.
#
# THIS CHECK FAILS CLOSED. A checkout without the helper, or with one that cannot
# be read or cannot run, gets exit 35 and launches NOTHING — it does not skip
# with a visible line. The distinction that matters is between a check that ran
# and found nothing wrong and a check that never ran: only the first is evidence.
# The checkouts most likely to lack the helper — older siblings, partial copies —
# are exactly the ones most likely to hold a conflicting writer.
#
# The wording is dispatch.sh's own (its ownership block), not a second vocabulary
# invented here: one shared contract, one set of words, so an operator who has
# read one transport's refusal can read the other's. Every stop below goes
# through die(), which releases both leases on its way out — an ownership refusal
# must not leave behind a lease that would refuse the next run for a reason that
# never existed.
OWNER_HELPER="$CHECKOUT/logs/scripts/work-loop-owner.sh"
if [ -f "$OWNER_HELPER" ] && [ -r "$OWNER_HELPER" ]; then
  OWNER_OUT="$(bash "$OWNER_HELPER" check --checkout "$CHECKOUT" --task "$TASK" --depth repo 2>&1)"
  OWNER_RC=$?
  case "$OWNER_RC" in
    0) say "ownership: PROCEED — $(printf '%s' "$OWNER_OUT" | sed -n 's/^reason: //p')" ;;
    3) die 33 "ownership refused for task $TASK in $CHECKOUT"$'\n'"$OWNER_OUT"$'\n'"Recoverable next action: continue the task in the checkout named above, or close it there first. Nothing was launched." ;;
    4) die 34 "ownership is AMBIGUOUS for task $TASK in $CHECKOUT"$'\n'"$OWNER_OUT"$'\n'"Recoverable next action: this is not a failure to work around — decide which checkout owns the task, remove the copies that are not authoritative, and record the owner with \`work-loop-owner.sh claim\`. Nothing was launched." ;;
    *) die 35 "the ownership check ran and failed (exit $OWNER_RC) in $CHECKOUT"$'\n'"$OWNER_OUT"$'\n'"Recoverable next action: ownership is unestablished, so nothing was launched. Fix or replace $OWNER_HELPER, then re-run." ;;
  esac
else
  die 35 "the ownership check is unavailable: $OWNER_HELPER is missing or unreadable in $CHECKOUT"$'\n'"Recoverable next action: ownership cannot be established without it, so nothing was launched and nothing was committed. Copy the helper into this checkout — or run the task in a checkout that carries it — then re-run."
fi

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
