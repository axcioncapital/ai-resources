#!/bin/bash
# Work Loop v2 — the shared LIVE LEASE.
#
# ONE authority for the two-resource live lease that both Work Loop transports
# take before they launch an actor. Extracted from the unattended dispatcher's
# proven inline implementation (dispatch.sh, the "locks" block) so that the
# attended carrier consumes the same mechanism rather than a second one. Two
# implementations of one invariant is exactly the shape that made the original
# composite key wrong in two programs at once.
#
# TWO RESOURCES, not one composite key:
#
#   task lease      one live actor-launching run per logical task, anywhere in
#                   the repository, including in another linked worktree.
#   checkout lease  one live actor-launching run per physical checkout, whatever
#                   task it carries.
#
# A run is admitted only if it takes BOTH. Refused either, it holds neither.
#
# WHAT THIS IS NOT. This governs LIVE PROCESS exclusivity only. Open-task
# exclusivity is the declaration's job (logs/work-loop/.owner, and its helper
# work-loop-owner.sh): a lease cannot outlive its process, and continuity
# between handoffs must. Nothing here reads, writes or reasons about ownership,
# and the two must not be merged — a lease that outlived its process would be a
# stale declaration, and a declaration that died with a process would strand an
# open task.
#
# THIS FILE IS SOURCED, NOT RUN. It is a shell library: the lease must be held
# by the CALLING process for the whole of that process's life, because the pid
# it records is the evidence `--status` inspects and the release runs from the
# caller's own EXIT trap. A subprocess helper would have to round-trip the
# caller's pid and its two ownership flags on every call, which is a second
# place for the invariant to drift — the thing this extraction exists to remove.
# Executed directly it refuses (64) rather than succeeding silently.
#
#   . /path/to/work-loop-lease.sh   # or: source
#
# THE CALLER OWNS ITS MESSAGES AND ITS EXIT CODES. This library returns a
# verdict and the holder metadata behind it; it prints nothing. The dispatcher's
# refusal wording and its exit 17, and the carrier's, are each that program's
# own contract, and neither is this library's to standardise.
#
# ------------------------------------------------------------------ contract
#
# wl_lease_init <checkout> <task>
#   Resolves the lease paths. Creates nothing — a read-only status caller must
#   be able to call this and still touch nothing.
#     0  ok
#     1  the Git common directory could not be resolved
#     2  the Git common directory is not readable
#   Sets: WL_LEASE_ROOT, WL_LEASE_TASK_DIR, WL_LEASE_CHECKOUT_DIR
#
# wl_lease_acquire <program> <pid>
#     0  both leases acquired
#     1  the lease root could not be created  (infrastructure, not contention)
#     2  refused — see WL_LEASE_RESOURCE / WL_LEASE_REFUSAL
#   On 2, sets: WL_LEASE_RESOURCE   task | checkout
#               WL_LEASE_REFUSAL    held | pinned
#               WL_LEASE_SURVIVORS  path to the pin evidence, when pinned
#               WL_LEASE_HOLDER_PID / _TASK / _CHECKOUT / _PROGRAM
#                 — empty when the holder's metadata is unreadable. Empty is a
#                   value the caller renders in its own words; it is never a
#                   reason to treat the lease as free.
#
# wl_lease_pin <survivors> <unknown> [task-label]
#     0  pinned
#     1  nothing was owned, so nothing was pinned
#
# wl_lease_release
#     0  always. Pinned beats owned, checked HERE so no call site can skip it.
#
# wl_lease_status
#     Read-only report on stdout. Takes no lease and creates nothing.
#
# State the caller may read (all maintained here):
#   WL_LEASE_TASK_OWNED, WL_LEASE_CHECKOUT_OWNED, WL_LEASE_PINNED  (0 | 1)

# Refuse direct execution. A caller that invoked this as a command and got exit
# 0 would believe it holds a lease it never took, which is the one failure this
# whole file exists to prevent.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  printf 'work-loop-lease.sh is a shell library and must be SOURCED, not run:\n' >&2
  printf '  . %s\n' "${BASH_SOURCE[0]}" >&2
  printf 'It holds a lease on behalf of the calling process, so a subprocess cannot hold one.\n' >&2
  exit 64
fi

# The fixed subdirectory name under the Git common directory. Unchanged from the
# dispatcher's inline implementation, so a lease taken by an in-flight or pinned
# dispatcher stays visible across this extraction.
WL_LEASE_DIRNAME='work-loop-dispatch-locks'

WL_LEASE_ROOT=''
WL_LEASE_TASK_DIR=''
WL_LEASE_CHECKOUT_DIR=''
WL_LEASE_TASK_OWNED=0
WL_LEASE_CHECKOUT_OWNED=0
WL_LEASE_PINNED=0
WL_LEASE_RESOURCE=''
WL_LEASE_REFUSAL=''
WL_LEASE_SURVIVORS=''
WL_LEASE_HOLDER_PID=''
WL_LEASE_HOLDER_TASK=''
WL_LEASE_HOLDER_CHECKOUT=''
WL_LEASE_HOLDER_PROGRAM=''
WL_LEASE_CHECKOUT=''
WL_LEASE_TASK=''

wl_lease__key() { # string -> the 16-char name fragment
  printf '%s' "$1" | shasum -a 256 | cut -c1-16
}

# The root is derived from the REPOSITORY, never from the caller's environment.
# The key used to live under ${TMPDIR}, which is caller-controlled: two runs
# launched with different TMPDIR values computed the same key under different
# parents and never contended at all. The Git common directory is the one
# location every linked worktree of a repository already shares, and it is
# discovered from the repository itself.
wl_lease_init() { # checkout task
  local wl_c="${1:-}" wl_t="${2:-}" wl_g
  WL_LEASE_CHECKOUT="$wl_c"
  WL_LEASE_TASK="$wl_t"
  wl_g="$(git -C "$wl_c" rev-parse --git-common-dir 2>/dev/null)" || return 1
  [ -n "$wl_g" ] || return 1
  case "$wl_g" in /*) ;; *) wl_g="$wl_c/$wl_g" ;; esac
  wl_g="$(cd "$wl_g" 2>/dev/null && pwd -P)" || return 2
  WL_LEASE_ROOT="$wl_g/$WL_LEASE_DIRNAME"
  WL_LEASE_TASK_DIR="$WL_LEASE_ROOT/task-$(wl_lease__key "$wl_t").lock"
  WL_LEASE_CHECKOUT_DIR="$WL_LEASE_ROOT/checkout-$(wl_lease__key "$wl_c").lock"
  return 0
}

# Read a holder's metadata into the WL_LEASE_HOLDER_* variables. Unreadable
# fields come back EMPTY and the lease is still treated as held: a lease that
# cannot be shown free is held, and nothing here deletes anything.
wl_lease__read_holder() { # lease-dir
  WL_LEASE_HOLDER_PID="$(cat "$1/pid" 2>/dev/null)"
  WL_LEASE_HOLDER_TASK="$(cat "$1/task" 2>/dev/null)"
  WL_LEASE_HOLDER_CHECKOUT="$(cat "$1/checkout" 2>/dev/null)"
  WL_LEASE_HOLDER_PROGRAM="$(cat "$1/program" 2>/dev/null)"
  return 0
}

wl_lease__write_holder() { # lease-dir program pid
  printf '%s\n' "$3" >"$1/pid"
  printf '%s\n' "$WL_LEASE_TASK" >"$1/task"
  printf '%s\n' "$WL_LEASE_CHECKOUT" >"$1/checkout"
  # Which program holds it. New with the shared lease, and the reason a refusal
  # can say "an attended carry holds this checkout" rather than naming a pid the
  # operator cannot place. Additive: every reader of the three fields above is
  # unaffected.
  printf '%s\n' "$2" >"$1/program"
  return 0
}

# `mkdir` is the atomic primitive: it either creates the directory or fails, and
# it cannot half-succeed. Ordered — task lease first, checkout lease second —
# and a refused second lease releases the first before returning, because
# holding a lease this run is not going to use would refuse the NEXT run for a
# reason that no longer exists.
wl_lease_acquire() { # program pid
  local wl_prog="${1:-unknown}" wl_pid="${2:-$$}"

  mkdir -p "$WL_LEASE_ROOT" 2>/dev/null || return 1

  WL_LEASE_RESOURCE=''; WL_LEASE_REFUSAL=''; WL_LEASE_SURVIVORS=''
  WL_LEASE_HOLDER_PID=''; WL_LEASE_HOLDER_TASK=''
  WL_LEASE_HOLDER_CHECKOUT=''; WL_LEASE_HOLDER_PROGRAM=''

  if mkdir "$WL_LEASE_TASK_DIR" 2>/dev/null; then
    WL_LEASE_TASK_OWNED=1
    wl_lease__write_holder "$WL_LEASE_TASK_DIR" "$wl_prog" "$wl_pid"
  else
    WL_LEASE_RESOURCE='task'
    wl_lease__read_holder "$WL_LEASE_TASK_DIR"
    if [ -f "$WL_LEASE_TASK_DIR/survivors" ]; then
      WL_LEASE_REFUSAL='pinned'
      WL_LEASE_SURVIVORS="$WL_LEASE_TASK_DIR/survivors"
    else
      WL_LEASE_REFUSAL='held'
    fi
    return 2
  fi

  if mkdir "$WL_LEASE_CHECKOUT_DIR" 2>/dev/null; then
    WL_LEASE_CHECKOUT_OWNED=1
    wl_lease__write_holder "$WL_LEASE_CHECKOUT_DIR" "$wl_prog" "$wl_pid"
  else
    WL_LEASE_RESOURCE='checkout'
    wl_lease__read_holder "$WL_LEASE_CHECKOUT_DIR"
    # Roll back. Guarded on OWNED so this can only ever remove the lease this
    # run created a few lines above — never a concurrent holder's.
    if [ "$WL_LEASE_TASK_OWNED" -eq 1 ]; then
      rm -rf "$WL_LEASE_TASK_DIR" 2>/dev/null
      WL_LEASE_TASK_OWNED=0
    fi
    if [ -f "$WL_LEASE_CHECKOUT_DIR/survivors" ]; then
      WL_LEASE_REFUSAL='pinned'
      WL_LEASE_SURVIVORS="$WL_LEASE_CHECKOUT_DIR/survivors"
    else
      WL_LEASE_REFUSAL='held'
    fi
    return 2
  fi

  return 0
}

# A pinned lease is NOT released, by anything, including the caller's EXIT trap.
# When a run cannot prove the actor tree it started has stopped, the process
# that knows about the survivors is about to exit, so the only thing that can
# carry that knowledge forward is the lease it leaves behind.
#
# PARTIAL ACQUISITION IS THE CASE THAT MATTERS. The guards below are why a pin
# never claims a resource the run did not acquire: a run refused the checkout
# lease pins only its task lease, and `--status` then reports exactly that.
wl_lease_pin() { # survivor-pids unknown-reason [task-label]
  local wl_surv="${1:-}" wl_unk="${2:-}" wl_label="${3:-$WL_LEASE_TASK}"
  [ "$WL_LEASE_TASK_OWNED" -eq 1 ] || return 1
  WL_LEASE_PINNED=1
  {
    printf 'PINNED by pid %s at %s\n' "$$" "$(date '+%Y-%m-%dT%H:%M:%S')"
    printf 'task: %s\n' "$wl_label"
    # These two line formats are read back by --status and asserted by the
    # transports' suites. Change them here or nowhere.
    [ -n "$wl_surv" ] && printf 'descendants still running: %s\n' "$wl_surv"
    [ -n "$wl_unk" ]  && printf 'sweep incomplete: %s\n' "$wl_unk"
    printf '\n'
    printf 'This lease is deliberately NOT released. A second run must not start on this\n'
    printf 'task while a descendant of the stopped actor may still be alive.\n'
    printf 'To clear it: confirm the pids above are gone (`ps -o pid,ppid,pgid,command -p <pid>`),\n'
    printf 'kill any that remain, then `rm -rf %s`.\n' "$WL_LEASE_TASK_DIR"
  } >"$WL_LEASE_TASK_DIR/survivors" 2>/dev/null
  # BOTH leases are pinned when both are held, because a survivor holds both
  # resources: it belongs to this task, and it is still running inside this
  # checkout's working tree. Pinning only the task lease would leave the
  # checkout open to exactly the contamination the survivor makes possible.
  [ "$WL_LEASE_CHECKOUT_OWNED" -eq 1 ] \
    && cp "$WL_LEASE_TASK_DIR/survivors" "$WL_LEASE_CHECKOUT_DIR/survivors" 2>/dev/null
  return 0
}

wl_lease_release() {
  # Pinned beats owned. Every exit path of a caller reaches this — its die(),
  # its EXIT trap, its signal handler — so the check belongs here rather than at
  # each call site, where one missed caller would silently undo the invariant.
  [ "$WL_LEASE_PINNED" -eq 1 ] && return 0
  [ "$WL_LEASE_TASK_OWNED" -eq 1 ] && rm -rf "$WL_LEASE_TASK_DIR" 2>/dev/null
  [ "$WL_LEASE_CHECKOUT_OWNED" -eq 1 ] && rm -rf "$WL_LEASE_CHECKOUT_DIR" 2>/dev/null
  WL_LEASE_TASK_OWNED=0
  WL_LEASE_CHECKOUT_OWNED=0
  return 0
}

# Read-only by contract: takes no lease, creates no directory, writes nothing.
# Its whole purpose is to be safe to run while another run holds the lease.
wl_lease_status() {
  local wl_d wl_name
  printf 'lease-root: %s\n' "$WL_LEASE_ROOT"
  for wl_name in task checkout; do
    if [ "$wl_name" = task ]; then wl_d="$WL_LEASE_TASK_DIR"; else wl_d="$WL_LEASE_CHECKOUT_DIR"; fi
    if [ -d "$wl_d" ] && [ -f "$wl_d/survivors" ]; then
      printf '%s-lease: PINNED %s\n' "$wl_name" "$wl_d"
    elif [ -d "$wl_d" ]; then
      printf '%s-lease: HELD %s\n' "$wl_name" "$wl_d"
    else
      printf '%s-lease: FREE %s\n' "$wl_name" "$wl_d"
      continue
    fi
    wl_lease__read_holder "$wl_d"
    printf '%s-holder: pid=%s program=%s task=%s checkout=%s\n' "$wl_name" \
      "${WL_LEASE_HOLDER_PID:-unrecorded}" "${WL_LEASE_HOLDER_PROGRAM:-unrecorded}" \
      "${WL_LEASE_HOLDER_TASK:-unrecorded}" "${WL_LEASE_HOLDER_CHECKOUT:-unrecorded}"
  done
  return 0
}
