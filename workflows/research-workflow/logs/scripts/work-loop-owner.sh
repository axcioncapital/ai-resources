#!/bin/bash
# work-loop-owner.sh — the one shared ownership check for Work Loop v2.
#
# R2, "the checkout declares its writer". One gitignored file per checkout at
# logs/work-loop/.owner holds ONE task id, in exactly one shape — `{task-id}` on
# a single line, and nothing else. A declaration in any other shape — including
# the pre-Tracer-3 `{task-id} {YYYY-MM-DD}` form — is unreadable: it refuses, it
# is never guessed at, and it is never deleted by this tool. The claim date was
# dropped at the Tracer 3 cutover: nothing ever read it, and a second field is
# one more way for two readers to disagree about the same declaration. There is
# no file anywhere that maps tasks to checkouts: nothing is keyed by task id,
# nothing is stored centrally, nothing is migrated. The declaration is only ever
# used to REFUSE — a second task entering a claimed checkout, or a task whose id
# is claimed by a different checkout. Refusal needs no authoritative-copy
# selection, which is what keeps this from being a second binding. The physical
# location of logs/work-loop/{task-id}.md remains the single semantic binding.
#
# TWO DEPTHS, because the two actors can reach different things.
#
#   --depth local  Reads THIS checkout's declaration and nothing else. Runs NO
#                  git, ever. This is interactive Codex's whole enforcement, and
#                  it answers exactly one question: is this checkout claimed by a
#                  different task? That is the half matching Codex's own failure
#                  mode — the only thing Codex writes is a brief into the
#                  checkout it is standing in.
#   --depth repo   Everything local does, plus enumeration of the registered
#                  worktrees, which answers the other half: is my task claimed
#                  somewhere else, and is its state file replicated? Requires
#                  git, so it is for interactive Claude (Step 1) and for
#                  dispatch.sh (admission) only.
#
# THE NARROWING IS DELIBERATE AND IS A LIMIT, NOT COVERAGE. Codex cannot
# establish the cross-checkout half. What keeps that sound rather than a gap is
# that Claude makes every commit (core § 4), so every unit crosses a Claude entry
# before anything is committed; the exposure is one uncommitted brief in a
# checkout the local read had already cleared.
#
# NOT PREVENTED BY ANYTHING HERE, and stated rather than covered by claim:
# two interactive sessions on one checkout for the SAME task, and an operator who
# proceeds past a refusal. Interactive enforcement is instruction-borne; only the
# dispatcher's is exit-code-borne.
#
# Usage:
#   work-loop-owner.sh check --checkout PATH --task ID [--depth local|repo]
#   work-loop-owner.sh claim --checkout PATH --task ID [--depth local|repo]
#   work-loop-owner.sh clear --checkout PATH --task ID
#
# Exit codes:
#   0   PROCEED
#   3   REFUSE      — the conflicting task and/or checkout is named in the output
#   4   AMBIGUOUS   — refuses everywhere; the operator names the owner
#   10  BAD_USAGE
#   11  BAD_CHECKOUT      — also: the mutation lock could not be taken
#   12  BAD_TASK_ID
#
# `claim` and `clear` mutate, so they run inside a mkdir-based lock in the
# checkout (no git). `check` is a pure read and takes no lock.
#
# Regression coverage: logs/scripts/work-loop-owner.test.sh (T1..T13, F1..F3).

set -uo pipefail

OWNER_REL='logs/work-loop/.owner'

CMD=""; CHECKOUT=""; TASK=""; DEPTH="local"

verdict() { # VERDICT reason... — prints, then exits with the matching code
  local v="$1"; shift
  printf 'verdict: %s\n' "$v"
  [ "$#" -gt 0 ] && printf 'reason: %s\n' "$*"
  case "$v" in
    PROCEED)   exit 0 ;;
    REFUSE)    exit 3 ;;
    AMBIGUOUS) exit 4 ;;
    *)         exit 10 ;;
  esac
}

die() { printf 'STOP [%s] %s\n' "$1" "$2" >&2; exit "$1"; }

# ------------------------------------------------------------------ arguments
[ "$#" -ge 1 ] || die 10 "usage: work-loop-owner.sh {check|claim|clear} --checkout PATH --task ID [--depth local|repo]"
CMD="$1"; shift
case "$CMD" in
  check|claim|clear) ;;
  -h|--help) sed -n '2,50p' "$0"; exit 0 ;;
  *) die 10 "unknown command '$CMD' — expected check, claim or clear" ;;
esac

while [ "$#" -gt 0 ]; do
  case "$1" in
    --checkout) CHECKOUT="${2:-}"; shift 2 ;;
    --task)     TASK="${2:-}";     shift 2 ;;
    --depth)    DEPTH="${2:-}";    shift 2 ;;
    *) die 10 "unknown argument '$1'" ;;
  esac
done

[ -n "$CHECKOUT" ] || die 10 "--checkout is required"
[ -n "$TASK" ]     || die 10 "--task is required"
case "$DEPTH" in local|repo) ;; *) die 10 "--depth must be 'local' or 'repo', got '$DEPTH'" ;; esac

# Same id rules as dispatch.sh, applied before any path is built from the id.
case "$TASK" in
  */*|*'\'*|..|.|*..*|"") die 12 "task id rejected (path traversal or separator): $TASK" ;;
esac
printf '%s' "$TASK" | grep -qE '^[A-Za-z0-9][A-Za-z0-9._-]*$' \
  || die 12 "task id rejected (illegal characters): $TASK"

[ -d "$CHECKOUT" ] || die 11 "checkout is not a directory: $CHECKOUT"
CHECKOUT="$(cd "$CHECKOUT" && pwd -P)" || die 11 "cannot canonicalize checkout"

MARKER="$CHECKOUT/$OWNER_REL"

# --------------------------------------------------------------- marker reads
# Every function below is a pure reader. Nothing here writes, and nothing here
# runs git — that is what makes the whole of --depth local git-free.

# THE DECLARATION HAS EXACTLY ONE LEGAL SHAPE: one non-empty line holding
# `{task-id}` and nothing else. Anything else reads as "?" — unreadable — and "?"
# is a verdict, not a repair instruction. It never resolves to a task id, is never
# guessed at, and is never deleted. That is R2's unreadable/multi-id row: a damaged
# declaration must refuse visibly and survive for the operator to look at, because
# the tool that found it cannot know whether it was half-written by a live claim or
# corrupted long ago.
#
# One field exactly, not "at least one". A second token is either a second task id,
# the retired claim date, or trailing junk, and all three are the shape this check
# exists to reject — reading only $1 would silently accept `alpha beta` as "alpha",
# which is precisely how a legacy declaration would slip through unnoticed.
marker_holder() { # marker-path -> task id | "" absent | "?" unreadable/ambiguous
  local m="$1" lines fields holder
  [ -e "$m" ] || { printf ''; return 0; }
  [ -f "$m" ] && [ -r "$m" ] || { printf '?'; return 0; }
  lines="$(grep -c '[^[:space:]]' "$m" 2>/dev/null || printf '0')"
  # More than one non-empty line is exactly the "holding more than one id" row.
  [ "$lines" = "1" ] || { printf '?'; return 0; }
  fields="$(awk 'NF {print NF; exit}' "$m" 2>/dev/null)"
  [ "$fields" = "1" ] || { printf '?'; return 0; }
  holder="$(awk 'NF {print $1; exit}' "$m" 2>/dev/null)"
  case "$holder" in
    ''|*/*|*'\'*) printf '?'; return 0 ;;
  esac
  printf '%s' "$holder" | grep -qE '^[A-Za-z0-9][A-Za-z0-9._-]*$' || { printf '?'; return 0; }
  printf '%s' "$holder"
}

# LIFECYCLE COMES FROM THE VALIDATOR, AND FROM NOWHERE ELSE (Tracer 3). This
# helper used to decide closure itself, by looking for `turn: operator` in the
# frontmatter. That was an inference — `turn` says whose move it is, not whether
# the task is over — and it is exactly the private parser the cutover removes.
#
# A validator that is missing, unreadable or non-zero is NOT permission to fall
# back to the old reading. It means the lifecycle is unestablished, and an
# unestablished lifecycle stops the caller rather than resolving to "open" or
# "closed" by default. There is no second parser here to fall back to.
VALIDATOR_REL='logs/scripts/work-loop-state.sh'

task_class() { # checkout task -> prints ACTIVE_CLAUDE|ACTIVE_CODEX|BLOCKED_OPERATOR|CLOSED, or returns 1
  local v="$1/$VALIDATOR_REL" out
  [ -f "$v" ] && [ -r "$v" ] || return 1
  out="$(bash "$v" validate --checkout "$1" --task "$2" 2>/dev/null)" || return 1
  case "$out" in
    ACTIVE_CLAUDE|ACTIVE_CODEX|BLOCKED_OPERATOR|CLOSED) printf '%s' "$out" ;;
    *) return 1 ;;
  esac
}

# Reads the recorded text of one top-level section. This is NOT lifecycle
# parsing — the lifecycle already came from task_class above — it exists only so
# a BLOCKED_OPERATOR refusal can quote the condition the record actually names
# instead of telling the operator to go and look.
section_text() { # state-file heading -> the section body, blank-trimmed, one line
  awk -v want="$2" '
    NR == 1 { inb = 1; next }
    inb && $0 == "---" { inb = 0; body = 1; next }
    inb { next }
    body {
      if ($0 ~ /^[[:space:]]*```/) { fence = !fence; if (grab) print; next }
      if (!fence && $0 ~ /^## /) {
        h = $0; sub(/^## /, "", h); sub(/[[:space:]]+$/, "", h)
        grab = (h == want); next
      }
      if (grab) print
    }
  ' "$1" 2>/dev/null | tr '\n' ' ' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//'
}

state_here() { [ -f "$1/logs/work-loop/$2.md" ]; }

# ------------------------------------------------------- the local half (no git)
# Answers only: is THIS checkout claimed by a different task?
# Sets LOCAL_VERDICT and LOCAL_REASON rather than exiting, so the repo depth can
# run it first and then continue.
LOCAL_VERDICT=""; LOCAL_REASON=""; LOCAL_STALE=0
check_local() {
  local holder; holder="$(marker_holder "$MARKER")"

  if [ -z "$holder" ]; then
    LOCAL_VERDICT="PROCEED"; LOCAL_REASON="this checkout declares no writer"; return 0
  fi
  if [ "$holder" = "?" ]; then
    LOCAL_VERDICT="AMBIGUOUS"
    LOCAL_REASON="the declaration at $MARKER is unreadable or holds more than one task id — no checkout may claim on this evidence; the operator names the owner"
    return 0
  fi

  # Contradiction row of the safe state table, checked BEFORE the holder is
  # compared to the incoming task: a declaration whose task has no state file in
  # this checkout describes a binding that is not there, and re-entering on it
  # would build on a claim nothing supports.
  if ! state_here "$CHECKOUT" "$holder"; then
    LOCAL_VERDICT="REFUSE"
    LOCAL_REASON="this checkout declares task '$holder', but $CHECKOUT/logs/work-loop/$holder.md does not exist — a declaration with no state file is a contradiction, not a claim"
    return 0
  fi

  if [ "$holder" = "$TASK" ]; then
    LOCAL_VERDICT="PROCEED"; LOCAL_REASON="this checkout already declares task '$TASK'"; return 0
  fi

  # The declaring task's lifecycle decides what happens next, and the validator
  # is what establishes it. An unclassifiable declaration stops here: it is
  # neither open enough to refuse on nor closed enough to clear, and guessing
  # either way is the failure this whole seam exists to remove.
  local holder_class holder_blocker
  holder_class="$(task_class "$CHECKOUT" "$holder")" || {
    LOCAL_VERDICT="AMBIGUOUS"
    LOCAL_REASON="this checkout declares task '$holder', but $CHECKOUT/logs/work-loop/$holder.md could not be classified by $VALIDATOR_REL — lifecycle is never inferred here, so nothing is claimed and nothing is cleared; the operator names the owner"
    return 0
  }

  case "$holder_class" in
    # Stale row: a CLOSED local task's declaration may be cleared by the next task
    # start IN THIS SAME CHECKOUT — never by another checkout, which is why this
    # test reads the local state file and nothing else.
    CLOSED)
      LOCAL_STALE=1
      LOCAL_VERDICT="PROCEED"
      LOCAL_REASON="this checkout declares task '$holder', which the validator classifies CLOSED — a stale declaration, clearable by the next task start in this checkout"
      return 0 ;;
    # A blocked task still owns its checkout. It is waiting on the operator, not
    # finished, so its lease holds — and the refusal quotes the condition the
    # record names, because "go and read the file" is the answer that made the
    # operator do the tool's work.
    BLOCKED_OPERATOR)
      holder_blocker="$(section_text "$CHECKOUT/logs/work-loop/$holder.md" 'Blocker')"
      LOCAL_VERDICT="REFUSE"
      LOCAL_REASON="this checkout is claimed by task '$holder', which the validator classifies BLOCKED_OPERATOR — it waits on the operator and keeps its checkout until that decision is made. Its recorded blocker: $holder_blocker"
      return 0 ;;
  esac

  LOCAL_VERDICT="REFUSE"
  LOCAL_REASON="this checkout is claimed by open task '$holder' ($holder_class) — close it, or use another checkout. An open task leases its checkout until closure."
  return 0
}

# ------------------------------------------------------- the repo half (git)
# Answers: is MY task claimed somewhere else, and is its state file replicated?
REPO_VERDICT=""; REPO_REASON=""
check_repo() {
  local list
  list="$(git -C "$CHECKOUT" worktree list --porcelain 2>/dev/null)" || {
    REPO_VERDICT="AMBIGUOUS"
    REPO_REASON="the registered worktrees could not be enumerated from $CHECKOUT — cross-checkout ownership cannot be established, so nothing is claimed"
    return 0
  }

  local claimants="" copies="" n_claim=0 n_copy=0 wt real holder
  while IFS= read -r line; do
    case "$line" in worktree\ *) ;; *) continue ;; esac
    wt="${line#worktree }"
    # A prunable or moved worktree is still listed. It is not evidence.
    [ -d "$wt" ] || continue
    real="$(cd "$wt" 2>/dev/null && pwd -P)" || continue

    # The SAME reader as the local half. This was a second, looser inline copy;
    # a format rule enforced in one of two readers is not enforced at all,
    # because the copy decides every cross-checkout verdict on its own.
    holder="$(marker_holder "$real/$OWNER_REL")"

    # A "?" here is a malformed declaration in ANOTHER checkout. It is not
    # counted as a claimant, because it names nobody. Deliberate and narrow: it
    # is the local half's job to refuse a malformed declaration in the checkout
    # standing on it, and treating one corrupt sibling marker as ambiguity for
    # every task would refuse work across the whole repository for a file the
    # operator can see and fix in one place.
    if [ "$holder" = "$TASK" ]; then
      claimants="$claimants$real"$'\n'; n_claim=$((n_claim+1))
    fi
    if state_here "$real" "$TASK"; then
      copies="$copies$real"$'\n'; n_copy=$((n_copy+1))
    fi
  done <<EOF
$list
EOF

  if [ "$n_claim" -gt 1 ]; then
    REPO_VERDICT="AMBIGUOUS"
    REPO_REASON="task '$TASK' is declared by more than one checkout: $(printf '%s' "$claimants" | tr '\n' ' ')— the operator names the owner"
    return 0
  fi

  if [ "$n_claim" -eq 1 ]; then
    local c; c="$(printf '%s' "$claimants" | head -1)"
    if [ "$c" = "$CHECKOUT" ]; then
      REPO_VERDICT="PROCEED"
      REPO_REASON="task '$TASK' is declared by this checkout; the later handoff reuses it"
    else
      REPO_VERDICT="REFUSE"
      REPO_REASON="task '$TASK' is already claimed by checkout $c — continue the task there, or close it first"
    fi
    return 0
  fi

  # No declaration anywhere. The state file's physical location is the binding,
  # so it decides — but only where it is unique. A replicated copy is not
  # evidence of ownership (D1: committed state files replicate across worktrees),
  # and the checkout contacted first must never claim on it.
  if [ "$n_copy" -gt 1 ]; then
    REPO_VERDICT="AMBIGUOUS"
    REPO_REASON="task '$TASK' has a state file in more than one checkout and no checkout declares it: $(printf '%s' "$copies" | tr '\n' ' ')— replicated copies authorise nobody; the operator names the owner"
    return 0
  fi
  if [ "$n_copy" -eq 1 ]; then
    local c; c="$(printf '%s' "$copies" | head -1)"
    if [ "$c" = "$CHECKOUT" ]; then
      REPO_VERDICT="PROCEED"
      REPO_REASON="task '$TASK' has exactly one state file and it is in this checkout — this checkout may re-declare it"
    else
      REPO_VERDICT="REFUSE"
      REPO_REASON="task '$TASK' lives in checkout $c — its state file is there, not here"
    fi
    return 0
  fi

  REPO_VERDICT="PROCEED"
  REPO_REASON="task '$TASK' is declared and stored nowhere — free to claim"
}

# The one shared check. The checkout half runs first in both depths: a checkout
# already held by another task is refused whatever the task half would say.
run_check() {
  check_local
  case "$LOCAL_VERDICT" in
    REFUSE|AMBIGUOUS) VERDICT="$LOCAL_VERDICT"; REASON="$LOCAL_REASON"; return 0 ;;
  esac
  if [ "$DEPTH" = "local" ]; then
    VERDICT="$LOCAL_VERDICT"; REASON="$LOCAL_REASON"
    return 0
  fi
  check_repo
  case "$REPO_VERDICT" in
    PROCEED) VERDICT="PROCEED"; REASON="$LOCAL_REASON; $REPO_REASON" ;;
    *)       VERDICT="$REPO_VERDICT"; REASON="$REPO_REASON" ;;
  esac
}

VERDICT=""; REASON=""

# ------------------------------------------------------- the mutation lock
# WHY THIS EXISTS. `check` decides from a read; `claim` and `clear` then write.
# Between the read and the write another process can claim the same free
# checkout, and check-then-write let TWO different tasks both observe an
# unclaimed checkout, both return PROCEED, and the later rename silently win.
# Measured before the fix: 10 contested pairs, 10 double claims, 0 refusals.
#
# `mkdir` is the primitive, because it is the one create-or-fail operation
# available with NO git — and --depth local must never run git. The kernel makes
# the test-and-create indivisible, so exactly one caller can be inside the
# section at a time, and the loser reads the winner's declaration and refuses.
#
# THE LOCK DIRECTORY IS ALWAYS EMPTY, and that is load-bearing rather than
# incidental: git does not track directories, so an empty one can never appear
# in `git status` or in a commit. It therefore needs no .gitignore rule — which
# matters, because the approved scope for .gitignore is the .owner rule alone.
# Putting a pid or a timestamp file inside it would make it committable and
# would need the rule this design avoids.
LOCK="$CHECKOUT/logs/work-loop/.owner.lock"
LOCK_HELD=0

lock_release() { [ "$LOCK_HELD" -eq 1 ] && rmdir "$LOCK" 2>/dev/null; LOCK_HELD=0; }

lock_acquire() {
  local i=0
  while [ "$i" -lt 100 ]; do
    if mkdir "$LOCK" 2>/dev/null; then
      LOCK_HELD=1
      # Released on every exit path, including verdict's, die's and a signal.
      trap 'lock_release' EXIT HUP INT TERM
      return 0
    fi
    # The section is a few milliseconds of file I/O, so a lock still held after
    # a minute is abandoned, not busy. rmdir only succeeds on an empty
    # directory, so this can never delete a lock someone put contents in.
    if [ "$i" -eq 0 ] && [ -n "$(find "$LOCK" -maxdepth 0 -mmin +1 2>/dev/null)" ]; then
      rmdir "$LOCK" 2>/dev/null
    fi
    i=$((i+1))
    sleep 0.05
  done
  die 11 "another process is claiming or clearing this checkout and did not finish: $LOCK
Recoverable next action: if no ownership command is running, remove that empty directory and retry."
}

case "$CMD" in
  check)
    # A pure read. It takes no lock: writers install the declaration whole with
    # a rename, so a reader sees either the old file or the new one, never half.
    run_check
    verdict "$VERDICT" "$REASON"
    ;;

  claim)
    mkdir -p "$CHECKOUT/logs/work-loop" 2>/dev/null \
      || die 11 "cannot create $CHECKOUT/logs/work-loop"
    lock_acquire
    # Decide and write INSIDE the section, so the verdict cannot go stale
    # between the two. This is the whole correction: run_check used to happen
    # outside any section, and its answer could stop being true before the write.
    run_check
    [ "$VERDICT" = "PROCEED" ] || verdict "$VERDICT" "$REASON — nothing was written"
    # Written whole, then moved into place, so a reader never sees half a
    # declaration. Same directory, so the move is a rename on one filesystem.
    tmp="$MARKER.tmp.$$"
    printf '%s\n' "$TASK" >"$tmp" \
      || die 11 "cannot write $MARKER"
    mv -f "$tmp" "$MARKER" || { rm -f "$tmp"; die 11 "cannot install $MARKER"; }
    if [ "$LOCAL_STALE" -eq 1 ]; then
      verdict PROCEED "claimed $CHECKOUT for task '$TASK', clearing a stale declaration; $REASON"
    fi
    verdict PROCEED "claimed $CHECKOUT for task '$TASK'"
    ;;

  clear)
    lock_acquire
    holder="$(marker_holder "$MARKER")"
    if [ -z "$holder" ]; then
      verdict PROCEED "this checkout declares no writer — nothing to clear"
    fi
    # An unreadable or multi-id declaration is AMBIGUOUS and SURVIVES. It used
    # to be deleted here, which is the one outcome R2 forbids: the evidence the
    # operator needs to name the owner was destroyed by the command that found
    # it, and a closure could silently tidy away a declaration belonging to
    # another task.
    if [ "$holder" = "?" ]; then
      verdict AMBIGUOUS "the declaration at $MARKER is unreadable or holds more than one task id — it is left exactly as it is, and nothing was removed; the operator names the owner"
    fi
    if [ "$holder" = "$TASK" ]; then
      rm -f "$MARKER" || die 11 "cannot remove $MARKER"
      verdict PROCEED "cleared the declaration at $MARKER"
    fi
    verdict REFUSE "this checkout declares task '$holder', not '$TASK' — refusing to clear another task's declaration"
    ;;
esac
