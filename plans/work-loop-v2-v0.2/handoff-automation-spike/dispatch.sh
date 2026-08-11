#!/bin/bash
# Work Loop v2 — throwaway task-scoped handoff dispatcher (SPIKE, not production).
#
# Carries ONE exact Work Loop task through routine Codex <-> Claude turns in ONE
# checkout, without operator transport. It launches at most one actor at a time,
# re-reads the authoritative state file after every process exit, and stops
# visibly rather than guessing.
#
# It creates no queue and no shadow state: logs/work-loop/{task-id}.md stays the
# only semantic interface. All controller memory is the exact task id supplied at
# launch, held in this process only.
#
# Scope: single task, single checkout, serial PER INSTANCE. Multi-loop operation
# is one instance per task, each in its own linked worktree — proven once at
# fan-out 2 (logs/work-loop/work-loop-v2-parallel-worktree-proof.md). See
# docs/parallel-sessions-playbook.md § 4 — same-checkout concurrency is unsafe.
#
# Usage:
#   dispatch.sh --checkout <abs-path> --task <task-id> [options]
#
# Options:
#   --max-hops N        absolute hop limit (default 4)
#   --timeout S         per-actor wall-clock seconds (default 900)
#   --deadline S        WHOLE-RUN wall-clock budget in seconds, measured from
#                       startup. Unset by default. This is a real deadline, not a
#                       start gate: before every launch the actor's effective
#                       timeout is clamped to min(--timeout, time remaining), and
#                       a run still going when the clock expires has its actor
#                       terminated through the same path as an interruption.
#                       Exits 29 BUDGET_EXHAUSTED, which is NOT completion.
#   --codex-bin PATH    default /Applications/ChatGPT.app/Contents/Resources/codex
#   --claude-bin PATH   default: `claude` resolved from PATH
#   --allow-path RE     repeatable regex of repo-relative paths actors may change
#   --claude-deny RULE  repeatable. Passed to the Claude child as
#                       --disallowedTools RULE, e.g. 'Bash(git push:*)'.
#                       DEFAULT: none — no tool is denied beyond what the child's
#                       own policy already denies. This is plumbing, not a
#                       policy: it exists so an unattended run CAN be given a
#                       narrower authority than the operator's interactive
#                       sessions without editing any settings.json. A deny passed
#                       this way beats bypassPermissions and is scoped to this
#                       child alone — OBSERVED,
#                       runs/probe-unattended-authority-2026-08-07.md.
#                       It does NOT buy network isolation: denying WebFetch just
#                       sends the child to curl. See the same record.
#
# ATTENDED PERMISSION POLICY (P0-F, 2026-08-09). Every attended Claude hop is
# launched with `--permission-mode default`, with or without --claude-deny. It is
# not an option and there is no flag to turn it off. Before this, the child
# INHERITED this checkout's `defaultMode: bypassPermissions` — measured off the
# runtime's own system/init event — so the dispatcher was handing an actor bypass
# authority nobody had asked for. Stating the mode at launch fixes that without
# touching any settings.json, and leaves the operator's own interactive sessions
# alone. It is a permission policy only: it makes the child ask, it does not
# contain it. For OS-level containment see --unattended, which is separate and
# carries no permission mode of its own.
#   --unattended        CONTAINED MODE. Apply the operator-settled 1d profile to
#                       every Claude hop: OS-backed Bash sandbox, strict empty
#                       network allowlist, shell + Skill tools only, no MCP, web,
#                       hooks, connectors, remote control, subagents, built-in
#                       file tools or push, credentials scrubbed from
#                       subprocesses, and no unsandboxed-command escape.
#                       Policy and mechanism: runs/probe-contained-authority-2026-08-07.md.
#
#                       Delivered by CLI `--settings` on EVERY hop, never by a
#                       repository settings file. That is not a style choice:
#                       `sandbox.network.strictAllowlist` has NO EFFECT from
#                       `.claude/settings.json`, so writing the profile there
#                       would silently lose the network containment — and would
#                       still look contained on a machine whose USER settings
#                       already carry the key. See the same record, § 1 of the
#                       verification addendum.
#
#                       FAILS CLOSED, exit 31, before anything launches: the
#                       installed claude must be >= 2.1.219 (the release that
#                       added strictAllowlist), the version string must be
#                       readable, and the platform must be one this profile was
#                       proven on. `sandbox.failIfUnavailable` makes the child
#                       fail closed too, if the sandbox is missing at its end.
#
#                       Refuses to combine with --actor-cmd: a simulated actor
#                       cannot be contained, and a run labelled unattended that
#                       was never contained is exactly the evidence this spike
#                       exists to not produce.
#
#                       --claude-deny still works and is ADDITIVE — it can only
#                       narrow this profile further, never widen it.
#
#                       What this flag proves and does not: it applies and logs
#                       the REQUESTED policy. Array-valued settings keys such as
#                       `allowRead` merge across every settings scope, so another
#                       scope on this machine can widen what the child may read.
#                       Only a live check from INSIDE the child establishes the
#                       EFFECTIVE policy — runs/probes/unattended-effective-policy.sh.
#   --log-dir DIR       run evidence directory. Default: the spike's runs/
#                       directory INSIDE THE CHECKOUT BEING DRIVEN, not inside
#                       whichever checkout this script happens to live in.
#   --dry-run           validate and route; launch nothing
#   --status            READ-ONLY. Report whether a run is in flight for this
#                       checkout+task, and what the state file says. Acquires no
#                       lock, creates no log, writes nothing at all. Safe to run
#                       against a live run — that is the point of it.
#                       Answers in THREE states, never two: IN FLIGHT (the pid is
#                       visibly alive), STALE LOCK (the pid is positively absent),
#                       and UNKNOWN — CANNOT INSPECT (the pid could not be
#                       inspected, so the lock may still belong to a live run).
#                       Only IN FLIGHT and STALE LOCK are conclusions; UNKNOWN
#                       never recommends removing the lock. See pid_state().
#   --carry-one         COURIER MODE. Launch exactly the actor named by the
#                       current turn:, then stop once the turn has moved in an
#                       allowed direction — exit 0 rather than continuing to the
#                       next actor. Every validation and post-hop check is
#                       unchanged; this is a terminal condition, not a weaker
#                       one. Implies a single hop, so --max-hops is moot.
#   --actor-cmd CMD     TEST SEAM. Replaces the live product launch with CMD.
#                       Marks the run mode=simulated in all evidence so a
#                       simulated pass can never be read as live transport.
#
# Exit codes — 0 is the only success. WHAT it means depends on how you invoked
# this script; the four meanings are spelled out under the table.
#   0   SUCCESS                see the four meanings below — it is not one thing
#   10  BAD_USAGE
#   11  BAD_CHECKOUT
#   12  BAD_TASK_ID            traversal or illegal characters
#   13  STATE_MISSING
#   14  IDENTITY_MISMATCH      filename stem != frontmatter task:
#   15  BAD_TURN               turn: not in {codex, claude, operator}
#   16  FOREIGN_STAGED         something already staged; refuse to sweep it in
#   17  LOCK_HELD              another dispatcher owns this checkout/task
#   18  FOREIGN_UNSTAGED       out-of-allowlist working-tree changes already present
#   19  GIT_HAZARD             index.lock held, or a merge/rebase/cherry-pick in progress
#   20  ACTOR_FAILED           non-zero exit (retried once when nothing changed)
#   21  ACTOR_TIMEOUT
#   22  NO_TRANSITION          state did not move in an allowed direction
#   23  HOP_LIMIT
#   24  UNEXPECTED_EFFECT      out-of-allowlist change, or Codex moved HEAD
#   25  UNCOMMITTED_HANDBACK   Claude handed back without committing the state file
#   26  MALFORMED_TERMINAL     turn: operator, but the file is neither a core § 7
#                              question nor a core § 4 closing record
#   28  INTERRUPTED            SIGINT/SIGTERM. The actor's whole descendant tree
#                              was terminated, VERIFIED gone, and the run stopped.
#                              If any descendant could not be confirmed dead it is
#                              named in a WARNING before the lock is released —
#                              read that line before treating the halt as clean.
#                              NEVER retried — the signal may have landed after a
#                              partial effect.
#   29  BUDGET_EXHAUSTED       --deadline expired. NOT completion. The state file
#                              and Git are untouched by the stop, so the next run
#                              resumes from them; inspect before re-running,
#                              because a killed actor leaves the same
#                              partial-effect risk as an interruption.
#   30  UNEXPECTED_COMMIT      an actor COMMITTED paths outside the allowlist.
#                              Detection, not prevention — the commit already
#                              happened; the value is stopping rather than
#                              compounding. Distinct from 24, which is the
#                              working-tree case, because the recovery differs.
#   31  UNATTENDED_UNAVAILABLE --unattended was asked for and the contained
#                              profile cannot be delivered: claude older than
#                              2.1.219, an unreadable version string, an
#                              unproven platform, or a profile file that could
#                              not be written. NOTHING launches. Failing closed
#                              is the whole point — a run that quietly proceeds
#                              uncontained is worse than one that stops.
#                              (27 is a deliberate gap in this table, left as
#                              found rather than filled by this addition.)
#   32  IDENTITY_INIT_FAILED   the headless session-identity init (marker
#                              allocation via logs/scripts/prime-session-entry.sh
#                              plus the `- Files in scope:` footprint bullet)
#                              started and could not complete in a checkout that
#                              CARRIES the allocator. NOTHING launches: a run
#                              whose children would make the staging tripwire
#                              read a STRANGER'S footprint via the shared-marker
#                              fallback is the false-positive/false-pass shape
#                              this init exists to remove. A checkout WITHOUT
#                              the allocator skips init with a visible line
#                              instead — no /prime infrastructure, nothing to arm.
#
#   (33 and 34 are deliberately RESERVED and unused here. The concurrent branch
#    session/2026-08-11-work-loop-ceremony claims them for OWNERSHIP_REFUSED and
#    OWNERSHIP_AMBIGUOUS. This bounded-execution work was implemented alongside
#    that branch and skipped the pair rather than colliding with it. If that
#    branch is abandoned, 33/34 become free again — but renumbering 35/36 down
#    into them buys nothing and would invalidate recorded run evidence.)
#
#   35  PERMISSION_DENIED      the Claude hop's own JSON capture reports one or
#                              more `permission_denials` — the child asked to do
#                              something it was not authorised to do, and the
#                              denial happened at the CHILD's permission layer,
#                              not here. Before this code the denial was
#                              invisible: the child exits 0, so the run surfaced
#                              as 25 (edited but could not commit) or 22 (nothing
#                              moved), neither of which NAMES the cause. Measured
#                              live on 2026-08-05 — see
#                              runs/live-permission-denial-2026-08-05.md, run C.
#                              The stop carries the denied tool, its target, and
#                              the operator decision required. NOT retried: the
#                              same denial would recur.
#   36  STATE_UNCHANGED_HANDBACK
#                              the state file was ALREADY uncommitted before this
#                              hop launched AND is byte-identical afterwards — so
#                              Claude did not touch it. Split out of 25, which
#                              used to fire on bare dirtiness and therefore told
#                              the operator "Claude edited it" about a file
#                              Claude had never written to. Distinct recovery: 25
#                              means inspect a partial edit, 36 means the hop
#                              accomplished nothing and the pre-existing dirty
#                              file is someone else's uncommitted work.
#
# The five meanings of 0 — do NOT read one as another:
#   --help          printed the header. Nothing was validated, nothing launched.
#   --status        reported what it could read. Nothing was validated beyond
#                   readability, nothing launched, nothing written. 0 does NOT
#                   mean the report was conclusive — an UNKNOWN — CANNOT INSPECT
#                   lock verdict also exits 0. Read the run: line, not the code.
#   --dry-run       validation passed and the actor was named. NO turn was taken.
#   --carry-one     EITHER the turn moved exactly once in an allowed direction,
#                   OR turn: was already operator and nothing was carried. Read
#                   turn: from the state file to tell them apart — a courier does
#                   that anyway, because no screen or exit code is authoritative
#                   over the file (core § 4).
#   loop mode       the state file reached turn: operator. This is the only
#                   invocation for which 0 carries the whole-loop meaning.
#
# (The line above this block used to read "0 is the ONLY success, and it means the
# loop reached turn: operator" — true of loop mode alone, and recorded as a standing
# contradiction in README.md. Corrected 2026-08-06 when --carry-one added a fourth
# meaning and left the old wording actively wrong rather than merely incomplete.)

set -uo pipefail

# The whole-run clock starts HERE — the first statement of the script, before
# argument parsing, checkout canonicalization, lock acquisition or log setup.
#
# It used to start after log setup, which made "measured from startup" false by
# however long those steps took. The skew was small, but a deadline that quietly
# means "startup plus some setup" is the kind of claim this plan exists to stop
# making. Now the budget the operator sets is the budget from the moment they
# launch. (Caught in review, 2026-08-07.)
RUN_START="$(date '+%s')"

SPIKE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CHECKOUT=""
TASK=""
MAX_HOPS=4
ACTOR_TIMEOUT=900
DEADLINE=""
CODEX_BIN="/Applications/ChatGPT.app/Contents/Resources/codex"
CLAUDE_BIN=""
LOG_DIR=""
DRY_RUN=0
STATUS_MODE=0
CARRY_ONE=0
ACTOR_CMD=""
ALLOW_PATHS=()
CLAUDE_DENY=()
UNATTENDED=0

# The contained profile's own deny rules (1d). These are the dispatcher's, not
# the operator's: --claude-deny appends to them and can only narrow further.
#
# Both `git push:*` and `git push *` are listed on purpose. The permission
# reference documents the colon form; the probe that settled 1d recorded the
# space form as the rule it observed denying `git push --help`. Which one the
# installed build honours is not something this dispatcher should be guessing at
# when the cost of listing both is one array entry.
UNATTENDED_BASE_DENY=(
  'Bash(git push:*)'
  'Bash(git push *)'
  'WebFetch'
  'WebSearch'
  'mcp__*'
)

# The default nested-actor deny set (O1). Applied to every ATTENDED Claude launch
# this dispatcher makes, and it is the dispatcher's, not the operator's:
# --claude-deny appends to it and cannot remove an entry.
#
# NOT applied to the --unattended contained profile, which is a separately
# settled artifact that O1 excludes by name; the reasoning is at the u_deny
# construction in launch_actor().
# There is no flag to switch it off, and that absence is deliberate (plan § 3.3:
# the only demonstrated use of nested AI invocation in the whole evidence set is
# the 2026-08-10 failure this exists to prevent).
#
# READ THIS BEFORE QUOTING IT AS A SAFETY PROPERTY.
#
# This is NOT containment, and nothing here should be described as containment.
# What it does: the DEFAULT DIRECT ROUTE — a child running `claude …` or
# `codex …` through Bash — is refused by the child's own permission layer, and
# the refusal is visible in the launch argv and in the run log. What it does NOT
# do: remove the capability. A child with shell access can construct paths these
# rules do not name — a wrapper script, an absolute path, an env-var
# indirection, a shell function. A tool-name deny cannot enumerate its way out
# of that, and pretending otherwise is the overclaim the plan's § 3.4 exists to
# block.
#
# Materially reduced, not contained. The ONLY measured containment in this
# repository is the --unattended sandbox's network refusal.
#
# Both the colon and the space form are listed, for the same reason
# UNATTENDED_BASE_DENY lists both push forms: which one the installed build
# honours is not worth guessing at when listing both costs one array entry.
NESTED_ACTOR_DENY=(
  'Bash(claude:*)'
  'Bash(claude *)'
  'Bash(codex:*)'
  'Bash(codex *)'
)
# The minimum claude version that honours sandbox.network.strictAllowlist.
UNATTENDED_MIN_VERSION="2.1.219"
UNATTENDED_SETTINGS=""   # path to the generated per-run profile; set at preflight
UNATTENDED_VERSION=""    # the version string the gate actually read
UNATTENDED_BIN=""        # the claude binary the gate actually inspected

# Interruption state. ACTOR_PGID is the process group of the actor currently in
# flight, or empty between hops — the signal handler needs it to reach the whole
# tree, and "empty" is what tells it there is nothing to terminate.
#
# ACTOR_MARKER is that actor's private per-hop tree-marker file, published for the
# same reason. It is not logging: it is the THIRD identification handle (see
# actor_tree_census below), and the only one that survives a double fork. A signal
# handler that knows the pgid but not the marker can only reach the group.
#
# Deliberately NOT the hop's `.out` log, which it briefly was: an operator running
# `tail -f` on that log became a census hit and was killed by teardown. Measured,
# not theorised.
SHUTDOWN=0
ACTOR_PGID=""
ACTOR_MARKER=""
CUR_HOP=0
CUR_ACTOR=""
# The capture file the most recent launch_actor() actually wrote (O3).
LAST_CAPTURE=""

# The allowlisted working-tree snapshot taken immediately before the most recent
# actor launch. Once set, it remains the comparison point until the next launch,
# so a post-hop guard (including a malformed state file or hop limit) can still
# report only effects attributable to that launched hop.
HOP_BASELINE_READY=0
HOP_ALLOWED_SNAPSHOT=""

# The log directory's path relative to the checkout, when it sits inside one.
# Set where the allowlist is extended to cover it, and read by allowlisted_dirty()
# so the dispatcher's own evidence is not reported back as the actor's work (O2).
LOG_REL=""

die() { # code, message
  local code="$1"; shift
  local msg="$*"
  # Structural O2 guarantee: after any actor launch, every nonzero exit carries
  # the partial-effect delta. Early validation failures remain short because no
  # launch baseline exists yet.
  [ "${HOP_BASELINE_READY:-0}" -eq 1 ] && msg="$msg$(partial_effect_block)"
  printf 'STOP [%s] %s\n' "$code" "$msg" >&2
  [ -n "${RUN_LOG:-}" ] && printf 'STOP [%s] %s\n' "$code" "$msg" >>"$RUN_LOG"
  release_lock
  exit "$code"
}

say() {
  printf '%s\n' "$*"
  [ -n "${RUN_LOG:-}" ] && printf '%s\n' "$*" >>"$RUN_LOG"
}

# ---------------------------------------------------------------- arguments

while [ $# -gt 0 ]; do
  case "$1" in
    --checkout)    CHECKOUT="${2:-}"; shift 2 ;;
    --task)        TASK="${2:-}"; shift 2 ;;
    --max-hops)    MAX_HOPS="${2:-}"; shift 2 ;;
    --timeout)     ACTOR_TIMEOUT="${2:-}"; shift 2 ;;
    --deadline)    DEADLINE="${2:-}"; shift 2 ;;
    --codex-bin)   CODEX_BIN="${2:-}"; shift 2 ;;
    --claude-bin)  CLAUDE_BIN="${2:-}"; shift 2 ;;
    --allow-path)  ALLOW_PATHS+=("${2:-}"); shift 2 ;;
    --claude-deny) CLAUDE_DENY+=("${2:-}"); shift 2 ;;
    --log-dir)     LOG_DIR="${2:-}"; shift 2 ;;
    --actor-cmd)   ACTOR_CMD="${2:-}"; shift 2 ;;
    --dry-run)     DRY_RUN=1; shift ;;
    --status)      STATUS_MODE=1; shift ;;
    --carry-one)   CARRY_ONE=1; shift ;;
    --unattended)  UNATTENDED=1; shift ;;
    # Print the whole leading comment block, whatever length it grows to. A fixed
    # line window silently truncated the exit-code list as codes were added.
    -h|--help)     awk 'NR==1{next} /^#/{print; next} {exit}' "${BASH_SOURCE[0]}"; exit 0 ;;
    *)             printf 'STOP [10] unknown argument: %s\n' "$1" >&2; exit 10 ;;
  esac
done

[ -n "$CHECKOUT" ] || { printf 'STOP [10] --checkout is required\n' >&2; exit 10; }
[ -n "$TASK" ]     || { printf 'STOP [10] --task is required\n' >&2; exit 10; }
case "$MAX_HOPS" in ''|*[!0-9]*) printf 'STOP [10] --max-hops must be a positive integer\n' >&2; exit 10 ;; esac
[ "$MAX_HOPS" -ge 1 ] || { printf 'STOP [10] --max-hops must be >= 1\n' >&2; exit 10; }
case "$ACTOR_TIMEOUT" in ''|*[!0-9]*) printf 'STOP [10] --timeout must be a positive integer\n' >&2; exit 10 ;; esac
if [ -n "$DEADLINE" ]; then
  case "$DEADLINE" in ''|*[!0-9]*) printf 'STOP [10] --deadline must be a positive integer (seconds)\n' >&2; exit 10 ;; esac
  [ "$DEADLINE" -ge 1 ] || { printf 'STOP [10] --deadline must be >= 1\n' >&2; exit 10; }
fi

if [ "${#ALLOW_PATHS[@]}" -eq 0 ]; then
  ALLOW_PATHS=('^logs/work-loop/' '^plans/work-loop-v2-v0\.2/handoff-automation-spike/')
fi

# The session-identity init below appends this run's header and footprint bullet
# to logs/session-notes.md — a TRACKED shared log. Without this entry the
# dispatcher's own init would trip its own foreign-worktree stop (exit 18) on
# hop 1. The marker dotfiles (.session-marker, .prime-mtime) are gitignored and
# invisible to `git status`, so they need no entry. Appended for every run mode,
# so a resumed run whose init wrote on a PREVIOUS invocation stays allowed too.
ALLOW_PATHS+=('^logs/session-notes\.md$')

# A carry is one hop by definition. Pinning MAX_HOPS makes that true of the loop
# guard as well as of the terminal condition below, so the two cannot disagree if
# one of them is later edited. Set AFTER --max-hops validation, so an explicitly
# malformed --max-hops still fails as usage rather than being silently overwritten.
[ "$CARRY_ONE" -eq 1 ] && MAX_HOPS=1

# --status and --dry-run are both read-only, but they are not the same question
# ("is a run in flight?" versus "what would this launch?") and --dry-run still
# acquires the lock. Silently letting one win would misreport which check ran.
if [ "$STATUS_MODE" -eq 1 ] && [ "$DRY_RUN" -eq 1 ]; then
  printf 'STOP [10] --status and --dry-run are separate read-only modes; pass one\n' >&2; exit 10
fi

# --unattended cannot be honoured for a simulated actor. --actor-cmd replaces the
# live product launch entirely, so no settings file, no tool restriction and no
# sandbox reaches anything: the containment would be requested and silently not
# applied, while every line of evidence the run produced said "unattended". That
# is the precise failure this spike is built to refuse, so it is usage, not a
# warning.
if [ "$UNATTENDED" -eq 1 ] && [ -n "$ACTOR_CMD" ]; then
  printf 'STOP [10] --unattended and --actor-cmd are incompatible: a simulated actor cannot be contained, and labelling an uncontained run "unattended" would falsify its evidence\n' >&2; exit 10
fi

MODE="live"
[ -n "$ACTOR_CMD" ] && MODE="simulated"
[ "$DRY_RUN" -eq 1 ] && MODE="dry-run"
[ "$STATUS_MODE" -eq 1 ] && MODE="status"

# ------------------------------------------------- task id and path safety
# Rejected before any path is built, so a hostile id never reaches the filesystem.
case "$TASK" in
  */*|*'\'*|..|.|*..*|"")
    printf 'STOP [12] task id rejected (path traversal or separator): %s\n' "$TASK" >&2; exit 12 ;;
esac
if ! printf '%s' "$TASK" | grep -qE '^[A-Za-z0-9][A-Za-z0-9._-]*$'; then
  printf 'STOP [12] task id rejected (illegal characters): %s\n' "$TASK" >&2; exit 12
fi

[ -d "$CHECKOUT" ] || { printf 'STOP [11] checkout is not a directory: %s\n' "$CHECKOUT" >&2; exit 11; }
CHECKOUT="$(cd "$CHECKOUT" && pwd -P)" || { printf 'STOP [11] cannot canonicalize checkout\n' >&2; exit 11; }
git -C "$CHECKOUT" rev-parse --git-dir >/dev/null 2>&1 \
  || { printf 'STOP [11] not a git checkout: %s\n' "$CHECKOUT" >&2; exit 11; }

# ------------------------------------------------ default run-evidence directory
# Run evidence belongs to the checkout being driven, not to wherever this script
# happens to sit. The default used to be "$SPIKE_DIR/runs", so a dispatcher run
# from one checkout against a second checkout filed the second checkout's
# evidence in the first — the run's own log did not live with the work it
# described. The path below is deliberately the same relative location the spike
# occupies, so driving this repository's own checkout still resolves to exactly
# the directory the existing logs are already in: nothing is moved, and --status
# keeps finding them.
#
# Resolved ONCE, here, and read by both the --status branch and the run branch.
# Those two are required to agree — a --status that names a different directory
# from the one a real run writes to is a status report about nothing — and the
# only durable way to keep them in step is to give them a single source.
DEFAULT_LOG_DIR="$CHECKOUT/plans/work-loop-v2-v0.2/handoff-automation-spike/runs"

STATE_DIR="$CHECKOUT/logs/work-loop"
STATE_FILE="$STATE_DIR/$TASK.md"

# Belt and braces: even after the id checks, the resolved file must sit directly
# inside the state directory. A symlink pointing out of the tree fails here.
if [ -e "$STATE_FILE" ]; then
  RESOLVED_DIR="$(cd "$(dirname "$STATE_FILE")" && pwd -P)"
  [ "$RESOLVED_DIR" = "$(cd "$STATE_DIR" && pwd -P)" ] \
    || { printf 'STOP [12] resolved state file escapes logs/work-loop/\n' >&2; exit 12; }
fi

# ------------------------------------------- state file reading (read-only)
# Defined here rather than below the lock because --status uses them and --status
# runs before any lock is taken. Pure readers; they mutate nothing.

fm_value() { # file key -> value on stdout, empty if absent
  awk -v k="$2" '
    NR==1 { if ($0 != "---") exit; inb=1; next }
    inb && $0 == "---" { exit }
    inb {
      pfx = k ":"
      if (substr($0, 1, length(pfx)) == pfx) {
        v = substr($0, length(pfx) + 1)
        sub(/^[ \t]+/, "", v)
        sub(/[ \t]*#.*$/, "", v)
        sub(/[ \t]+$/, "", v)
        print v
        exit
      }
    }' "$1"
}

file_hash() { shasum -a 256 "$1" 2>/dev/null | cut -d' ' -f1; }

# ------------------------------------------------- PID inspection (3 states)
# `kill -0` failing is NOT proof that a process is gone. It fails for two very
# different reasons, and telling them apart is the whole of this function:
#
#   ESRCH  "no such process"          -> the PID really is absent
#   EPERM  "operation not permitted"  -> the PID may well be ALIVE; this caller
#                                        is simply not allowed to look at it
#
# Phase 0 § 0b item 3 measured the cost of conflating the two. `--status` run
# from inside the ordinary Codex command sandbox reported a genuinely live
# dispatcher (pid 79266) as STALE LOCK, and told the operator to `rm -rf` a lock
# that was doing its job. Sandbox policy refused the signal; the old check read
# that refusal as a death certificate.
#
# So only a message that positively says "no such process" may conclude ABSENT.
# Everything else — a refusal, an empty pid file, a non-numeric pid, an error
# text not recognised here — is UNKNOWN. The asymmetry is deliberate and points
# one way on purpose: a false UNKNOWN costs the operator one more look, a false
# ABSENT costs them a hand-edited state file in the middle of a live hop.
#
# LC_ALL=C so the matched text is the C-locale wording rather than whatever the
# ambient locale renders. Matched case-insensitively because the two shells that
# run this differ: bash says "No such process", zsh "no such process".
#
# Emits ONE line, "STATE|reason", rather than setting a global alongside its
# return value: callers read it through $( ), which is a subshell, so a global
# assigned in here would be discarded on the way out. Caught in demonstration
# — the reason line printed empty.
pid_state() { # pid -> "LIVE|reason" / "ABSENT|reason" / "UNKNOWN|reason"
  local pid="${1:-}" err rc
  # A valid pid matches [1-9][0-9]* — and "numeric" is NOT the same test.
  # `0` and `00` are numeric and were accepted here until 2026-08-07; both are
  # catastrophic to pass to kill(2), because pid 0 means "every process in the
  # CALLER'S OWN process group". `kill -0 0` therefore SUCCEEDS, so a lock
  # holding `0` reported `IN FLIGHT — dispatcher pid 0` and told the operator to
  # run `kill -TERM 0` — which would signal their own shell and everything in it.
  # A zero-PREFIXED value is a quieter version of the same bug: `007` reaches
  # kill(2) as pid 7, so the verdict is a true statement about an unrelated
  # process presented as a statement about this lock.
  #
  # None of these is evidence about the dispatcher. They are a corrupt lock, and
  # a corrupt lock is something this function cannot inspect — UNKNOWN.
  case "$pid" in
    '')       printf 'UNKNOWN|the lock directory holds no readable pid file\n'; return 0 ;;
    *[!0-9]*) printf "UNKNOWN|the lock's pid is not a number: '%s'\\n" "$pid"; return 0 ;;
    0*)       printf "UNKNOWN|the lock's pid is not a usable process id: '%s' — a real pid matches [1-9][0-9]*, and 0 would mean this caller's own process group\\n" "$pid"; return 0 ;;
  esac

  err="$(LC_ALL=C kill -0 "$pid" 2>&1)"; rc=$?
  if [ "$rc" -eq 0 ]; then
    printf 'LIVE|kill -0 succeeded — the process is visible and signallable\n'; return 0
  fi

  if printf '%s' "$err" | grep -qi 'no such process'; then
    printf 'ABSENT|kill -0 reported: no such process\n'; return 0
  fi

  printf 'UNKNOWN|kill -0 failed WITHOUT proving absence: %s\n' \
    "$(printf '%s' "${err:-<no error text>}" | tr '|\n' '  ')"
  return 0
}

# ------------------------------------------------------------------- lock
LOCK_KEY="$(printf '%s|%s' "$CHECKOUT" "$TASK" | shasum -a 256 | cut -c1-16)"
LOCK_DIR="${TMPDIR:-/tmp}/work-loop-dispatch-$LOCK_KEY.lock"
LOCK_OWNED=0

acquire_lock() {
  if mkdir "$LOCK_DIR" 2>/dev/null; then
    LOCK_OWNED=1
    printf '%s\n' "$$" >"$LOCK_DIR/pid"
  else
    if [ -f "$LOCK_DIR/survivors" ]; then
      printf 'STOP [17] the previous run of %s could not confirm its actor tree was stopped, so this lock is PINNED (%s)\n' "$TASK" "$LOCK_DIR" >&2
      sed 's/^/  /' "$LOCK_DIR/survivors" >&2
      exit 17
    fi
    printf 'STOP [17] another dispatcher holds %s (%s)\n' "$TASK" "$LOCK_DIR" >&2
    exit 17
  fi
}

# A pinned lock is NOT released, by anything, including the EXIT trap. It is the
# mechanism behind the plan's requirement that no second dispatcher is admitted
# while a descendant of the stopped actor may still be alive: the process that
# knows about the survivors is about to exit, so the only thing that can carry
# that knowledge forward is the lock it leaves behind.
LOCK_PINNED=0
pin_lock() { # survivor-pids, unknown-reason
  local survivors="${1:-}" unknown="${2:-}"
  [ "$LOCK_OWNED" -eq 1 ] || return 0
  LOCK_PINNED=1
  {
    printf 'PINNED by dispatcher pid %s at %s\n' "$$" "$(date '+%Y-%m-%dT%H:%M:%S')"
    printf 'task: %s\n' "$TASK"
    [ -n "$survivors" ] && printf 'descendants still running: %s\n' "$survivors"
    [ -n "$unknown" ]   && printf 'sweep incomplete: %s\n' "$unknown"
    printf '\n'
    printf 'This lock is deliberately NOT released. A second dispatcher must not run on this\n'
    printf 'task while a descendant of the stopped actor may still be alive.\n'
    printf 'To clear it: confirm the pids above are gone (`ps -o pid,ppid,pgid,command -p <pid>`),\n'
    printf 'kill any that remain, then `rm -rf %s`.\n' "$LOCK_DIR"
  } >"$LOCK_DIR/survivors" 2>/dev/null
  local msg="  the task lock is PINNED at $LOCK_DIR — a second dispatcher is refused (exit 17) until you clear it by hand."
  printf '%s\n' "$msg" >&2
  [ -n "${RUN_LOG:-}" ] && printf '%s\n' "$msg" >>"$RUN_LOG"
}

release_lock() {
  # Pinned beats owned. Every exit path calls this — die(), the EXIT trap, the
  # signal handler — so the check belongs here rather than at each call site,
  # where one missed caller would silently undo the invariant.
  [ "$LOCK_PINNED" -eq 1 ] && return 0
  [ "$LOCK_OWNED" -eq 1 ] && rm -rf "$LOCK_DIR" 2>/dev/null
  LOCK_OWNED=0
}

# ------------------------------------------------- descendant identification
#
# Terminate the actor's WHOLE DESCENDANT TREE, then verify it is gone.
#
# This replaces a group-only sweep (`kill -- -PGID`) that was honest about its own
# reach and insufficient anyway: a descendant which leaves the actor's process
# group outlived every stop, so the dispatcher reported a clean halt while a
# process it started kept running unsupervised. That is Phase 1a, and the reason
# it blocked the walk-away pilot.
#
# THE MECHANISM IS MEASURED, NOT ASSUMED. Four candidate handles were probed on
# this host; the table is the measurement, not a design intention:
# runs/probe-escaped-descendants-2026-08-07.md.
#
#   handle                       in-group  setsid,   double-fork  SIP system
#                                 child    parented    orphan      binary
#   ---------------------------------------------------------------------------
#   process group (kill -- -PGID)  reaches   MISSES     MISSES      n/a
#   recursive PPID census          reaches   reaches    MISSES      n/a
#   environment tag (ps -E)        MISSES    reaches    reaches     MISSES
#   inherited fd (private marker)  reaches   reaches    reaches     reaches
#
# What each row means, since the reasons are the whole argument:
#   - setsid(2) gives a new session AND a new process group, so the group kill
#     cannot see it. It does NOT change PPID, so an ancestry walk still can.
#   - a double fork leaves the grandchild re-parented to pid 1 the moment the
#     intermediate exits. The ancestry link is destroyed by the kernel, before any
#     stop happens, so no walk taken at stop time can recover it.
#   - `ps -E` cannot read the environment of a SIP-protected platform binary
#     (/bin/sh, /bin/sleep, /usr/bin/git all refuse; a user-installed python3
#     does not). An env tag is therefore blind to exactly the binaries an escaped
#     shell job is most likely to be. It is rejected on that measurement, and
#     because matching it means matching argv text too, which invents a
#     false-positive class the other handles do not have.
#   - kqueue NOTE_TRACK, the BSD fork-following filter, would have been the clean
#     answer. It returns ENOTSUP on this host (Darwin 26.5) — measured, same
#     record. It is not available to be chosen.
#
# So the union of handles 1, 2 and 4 is used, with handle 4 reading a PRIVATE
# per-hop marker descriptor rather than the hop log (see TREE_MARKER_FD below for
# why that distinction is a safety property and not a detail).
#
# THE RESIDUAL, stated rather than papered over, and it is NOT closed:
# a descendant that closes EVERY inherited descriptor — `closefrom`/`closerange`,
# which is what a conventional daemon does — AND has left the process group AND
# has been re-parented away is invisible to all three handles. Measured, not
# assumed: such a process was built and it survived.
#
# There is no fourth handle available. The only remaining property such a process
# still shares with the run is its working directory, and `lsof -d cwd` reaches it
# — together with every unrelated process sitting in the same directory, which is
# precisely the defect that forced the private marker in the first place. A handle
# broad enough to catch a fully-detached daemon is broad enough to kill the
# operator's shell. That is why this is reported as a platform limit rather than
# solved: see runs/probe-escaped-descendants-2026-08-07.md § The residual.
#
# Because the guarantee is therefore partial, teardown VERIFIES and reports —
# survivors by name, and an incomplete sweep as UNKNOWN rather than as success —
# and pins the task lock in both cases. dispatch.test.sh cases 27h and 27i pin the
# residual and the unrelated-holder guarantee so both stay measured boundaries
# rather than beliefs.

# Pids this dispatcher must never signal, whatever a census says: itself and its
# own ancestors, plus 0 and 1. This is the same lesson pid_state() carries — pid 0
# means "the caller's own process group", and signalling our own ancestry would
# reach the operator's shell. A census is untrusted input; this is its filter.
SELF_PIDS=" 0 1 "
_p="$$"
while :; do
  case "$_p" in ''|*[!0-9]*|0*) break ;; esac
  [ "$_p" -le 1 ] && break
  SELF_PIDS="$SELF_PIDS$_p "
  _p="$(ps -o ppid= -p "$_p" 2>/dev/null | tr -d ' ')"
done
unset _p

SELF_PGID="$(ps -o pgid= -p "$$" 2>/dev/null | tr -d ' ')"

# Handle 3 needs lsof. It ships with macOS, but its absence must be treated as
# "cannot establish", not as a quiet downgrade to the group-only reach this work
# exists to remove.
FD_HANDLE=1
command -v lsof >/dev/null 2>&1 || FD_HANDLE=0
PGREP_OK=1
command -v pgrep >/dev/null 2>&1 || PGREP_OK=0

# WHY A PRIVATE MARKER FILE AND NOT THE HOP LOG.
#
# The first version of this censused holders of the hop's `.out` file, because
# every descendant inherits stdout/stderr. It worked, and it was unsafe: `lsof`
# returns EVERY holder, so an operator running `tail -f` on the hop log was swept
# into the census and sent TERM then KILL. That is not a hypothetical — it was
# reproduced (an unrelated `tail` went from ALIVE to GONE across one teardown) and
# it is the reason this indirection exists.
#
# The marker is a per-hop file with the run id in its name that nothing else has
# any reason to open. The dispatcher opens it on fd 9, launches the actor so every
# descendant inherits that descriptor, then closes its OWN copy so it is never a
# holder itself. A holder of this file is therefore something the actor started —
# ownership by construction, rather than ownership assumed from a shared log.
#
# Measured bonus: it also reaches a descendant that closes 0/1/2, which the hop
# log could not. It does NOT reach one that closes every descriptor.
TREE_MARKER_FD=9

# Set by actor_tree_census when a load-bearing handle could not be consulted.
# Empty means every handle answered. Non-empty means the census is INCOMPLETE, and
# an empty result from an incomplete census means "cannot establish", never "gone".
CENSUS_UNKNOWN=""

# Set by census_pid when it could not decide whether a pid is alive.
CENSUS_PID_UNKNOWN=""

# Should this pid be counted as a live member of the actor's tree?
#
# THE OLD VERSION COLLAPSED THREE ANSWERS INTO TWO. It ran `ps -p <pid>` and
# treated ANY failure as "not live" — so a pid this dispatcher merely could not
# INSPECT counted exactly like a pid that had genuinely exited, and the census
# then reported an empty tree. That is the same class of defect as a silent
# `teardown verified`: an inability to look, recorded as a look that found
# nothing. Three answers are needed and all three are returned:
#
#   0                        alive, count it  (INCLUDING alive-but-unsignallable:
#                                             a descendant we may not signal is
#                                             still a descendant that is running,
#                                             and must be reported as a survivor
#                                             rather than quietly dropped)
#   1, CENSUS_PID_UNKNOWN=""  genuinely gone, or deliberately excluded
#   1, CENSUS_PID_UNKNOWN set could not tell — the caller must treat the whole
#                            census as incomplete
census_pid() { # pid -> 0 if it belongs in the census
  local pid="${1:-}" out rc kerr
  CENSUS_PID_UNKNOWN=""
  case "$pid" in ''|*[!0-9]*|0*) return 1 ;; esac
  # Never our own ancestry: pid 0 means "the caller's process group", and
  # signalling an ancestor reaches the operator's shell. A census is untrusted
  # input and this is its filter.
  case "$SELF_PIDS" in *" $pid "*) return 1 ;; esac

  out="$(ps -p "$pid" -o pid= 2>/dev/null)"; rc=$?
  if [ "$rc" -eq 0 ] && [ -n "$out" ]; then return 0; fi

  # `ps` did not confirm it. That means "gone" only if `ps` is working at all —
  # so ask `ps` something whose answer is known before believing its silence.
  if ! ps -p "$$" -o pid= >/dev/null 2>&1; then
    CENSUS_PID_UNKNOWN="\`ps -p\` cannot inspect processes here, so pid $pid could not be confirmed gone"
    return 1
  fi

  # `ps` works and says nothing. Second opinion, because the two errnos differ:
  # ESRCH is really gone, EPERM is alive and not ours to signal.
  kerr="$( { kill -0 "$pid"; } 2>&1 )"
  [ -z "$kerr" ] && return 0
  case "$kerr" in
    *[Pp]ermission*|*"not permitted"*)
      # Alive. Counted, so teardown reports it as a survivor and pins the lock,
      # instead of the operator being told the tree is clear.
      return 0 ;;
  esac
  return 1
}

# The union of the three usable handles, filtered and deduplicated. Live pids
# only, space-separated.
#
# RESULTS COME BACK IN GLOBALS, NOT ON STDOUT, and that is load-bearing rather
# than a style choice. This function reports TWO things — the pids it found and
# whether it could see at all — and a caller writing `census="$(actor_tree_census
# ...)"` runs it in a SUBSHELL, so the second one is silently discarded on the way
# out. That is exactly how the first version of this fix failed: every call site
# used command substitution, CENSUS_UNKNOWN was assigned in a child that then
# exited, and the parent read the empty string it had cleared a moment earlier.
# The degraded sweep then printed `teardown verified` — the strongest claim in the
# script, on no evidence, which is the defect finding 4 names. Returning through
# globals removes the subshell, so the two results cannot be separated again.
# Callers must read BOTH: an empty CENSUS_PIDS means "no descendant these handles
# can see is running", and that only means "nothing is running" when
# CENSUS_UNKNOWN is empty too.
CENSUS_PIDS=""
actor_tree_census() { # pgid, markerfile -> sets CENSUS_PIDS and CENSUS_UNKNOWN
  local pgid="${1:-}" marker="${2:-}" acc="" seen="" p pid pgrp frontier next kid c
  local ps_out rc out="" kids
  CENSUS_UNKNOWN=""
  CENSUS_PIDS=""

  [ -n "$pgid" ] || return 0
  # Refuse to census our OWN group. If `set -m` ever failed, the actor would share
  # the dispatcher's group and this sweep would enumerate the operator's other
  # jobs. Refusing is right, but it is NOT an empty tree — say so, or the refusal
  # would read as proof that nothing is running.
  #
  # COMPARE THE ACTOR'S REAL GROUP, NOT ITS PID. The first version compared the
  # caller's argument — which is the actor's *pid* — against this dispatcher's
  # *pgid*. Those are different kinds of number, and they can only be equal by
  # coincidence, so the guard could not fire in the situation it was written for:
  # when `set -m` fails the actor keeps its own pid and joins OUR group, which is
  # exactly the case that slipped through. Ask what group the actor is actually in.
  local actor_pgid
  actor_pgid="$(ps -o pgid= -p "$pgid" 2>/dev/null | tr -d ' ')"
  if [ -n "$SELF_PGID" ] && { [ "$pgid" = "$SELF_PGID" ] || [ "$actor_pgid" = "$SELF_PGID" ]; }; then
    CENSUS_UNKNOWN="the actor shares this dispatcher's process group (pgid $SELF_PGID), so no sweep can distinguish its descendants from the operator's own jobs"
    return 0
  fi

  # (1) process group members. A failing `ps` is unknown, not empty.
  ps_out="$(ps -ax -o pid=,pgid= 2>/dev/null)"; rc=$?
  if [ "$rc" -ne 0 ] || [ -z "$ps_out" ]; then
    CENSUS_UNKNOWN="${CENSUS_UNKNOWN:+$CENSUS_UNKNOWN; }\`ps -ax\` returned nothing usable (exit $rc), so process-group membership could not be read"
  else
    while read -r pid pgrp; do
      [ "$pgrp" = "$pgid" ] && acc="$acc $pid"
    done <<EOF
$ps_out
EOF
  fi

  # (2) recursive ancestry walk from the actor. Bounded by a visited set, so a
  #     pid-reuse cycle cannot spin here.
  if [ "$PGREP_OK" -eq 0 ]; then
    CENSUS_UNKNOWN="${CENSUS_UNKNOWN:+$CENSUS_UNKNOWN; }pgrep is not installed, so the ancestry walk could not run"
  else
    frontier="$pgid"; seen=" $pgid "
    while [ -n "$frontier" ]; do
      next=""
      for kid in $frontier; do
        # `pgrep` exit codes are three-valued and the difference matters:
        # 0 = matches, 1 = no matches (a real answer), >=2 = pgrep itself failed.
        # Discarding the third is how "the walk broke" became "the walk found no
        # children".
        kids="$(pgrep -P "$kid" 2>/dev/null)"; rc=$?
        if [ "$rc" -ge 2 ]; then
          CENSUS_UNKNOWN="${CENSUS_UNKNOWN:+$CENSUS_UNKNOWN; }\`pgrep -P $kid\` failed (exit $rc), so the ancestry walk is incomplete"
          continue
        fi
        for c in $kids; do
          case "$seen" in *" $c "*) continue ;; esac
          seen="$seen$c "; next="$next $c"; acc="$acc $c"
        done
      done
      frontier="$next"
    done
  fi

  # (3) holders of the hop's private inherited descriptor
  if [ "$FD_HANDLE" -eq 0 ]; then
    CENSUS_UNKNOWN="${CENSUS_UNKNOWN:+$CENSUS_UNKNOWN; }lsof is not installed, so descendants that left the process group and the ancestry chain could not be looked for at all"
  elif [ -z "$marker" ] || [ ! -e "$marker" ]; then
    CENSUS_UNKNOWN="${CENSUS_UNKNOWN:+$CENSUS_UNKNOWN; }the hop's tree marker file is missing (${marker:-<unset>}), so the inherited-descriptor handle had nothing to consult"
  else
    # `lsof -t` exits 1 BOTH when nobody holds the file and when lsof could not
    # look, so the exit code alone cannot separate the two. Its diagnostics go to
    # stderr and an ordinary "no holders" answer is silent, so stderr is what
    # distinguishes them. Captured separately rather than sent to /dev/null,
    # which is where the first version lost this.
    local lsof_err lsof_out
    lsof_err="$(mktemp "${TMPDIR:-/tmp}/wl2-lsof-err.XXXXXX" 2>/dev/null)"
    if [ -n "$lsof_err" ]; then
      lsof_out="$(lsof -t -- "$marker" 2>"$lsof_err")"; rc=$?
      if [ -s "$lsof_err" ]; then
        CENSUS_UNKNOWN="${CENSUS_UNKNOWN:+$CENSUS_UNKNOWN; }\`lsof\` failed on the tree marker (exit $rc: $(tr '\n' ' ' <"$lsof_err" | cut -c1-160)), so descendants outside the group and the ancestry chain could not be looked for"
      else
        acc="$acc $(printf '%s' "$lsof_out" | tr '\n' ' ')"
      fi
      rm -f "$lsof_err" 2>/dev/null
    else
      CENSUS_UNKNOWN="${CENSUS_UNKNOWN:+$CENSUS_UNKNOWN; }no temporary file could be created to capture lsof's diagnostics, so its result could not be trusted"
    fi
  fi

  seen=" "
  for p in $acc; do
    case "$seen" in *" $p "*) continue ;; esac
    if ! census_pid "$p"; then
      [ -n "$CENSUS_PID_UNKNOWN" ] &&
        CENSUS_UNKNOWN="${CENSUS_UNKNOWN:+$CENSUS_UNKNOWN; }$CENSUS_PID_UNKNOWN"
      continue
    fi
    seen="$seen$p "
    out="$out $p"
  done
  CENSUS_PIDS="${out# }"
}

# TERM first, then KILL after a grace period, because an actor that can exit
# cleanly should be allowed to. Callers: the per-actor timeout, the deadline, and
# the signal handler — one sweep, three callers, so they cannot drift apart.
#
# Both constants are load-bearing for the deadline's accuracy: together they are
# the upper bound on how far past its budget a terminated run can extend. Named so
# the arithmetic can be quoted rather than rediscovered — see effective_timeout.
TERM_GRACE_SECS=5
KILL_SETTLE_SECS=2

# Set by terminate_actor_tree: the pids it could NOT confirm dead, and the reason
# the sweep was incomplete if it was. Empty BOTH is the only state that permits a
# "teardown verified" claim.
TEARDOWN_SURVIVORS=""
TEARDOWN_UNKNOWN=""

terminate_actor_tree() { # pgid, markerfile -> 0 when the tree is verified gone
  local pgid="${1:-}" marker="${2:-}" census p waited
  TEARDOWN_SURVIVORS=""
  TEARDOWN_UNKNOWN=""
  [ -n "$pgid" ] || return 0

  # Re-censused on every pass, not computed once: a descendant can be spawned
  # DURING teardown, and one that appears after the first sweep would otherwise
  # never be signalled at all. Every call reads CENSUS_PIDS rather than capturing
  # stdout, so CENSUS_UNKNOWN survives to the verification below — see the census.
  actor_tree_census "$pgid" "$marker"; census="$CENSUS_PIDS"
  kill -TERM -- "-$pgid" 2>/dev/null
  for p in $census; do kill -TERM "$p" 2>/dev/null; done

  waited=0
  while [ "$waited" -lt "$TERM_GRACE_SECS" ]; do
    actor_tree_census "$pgid" "$marker"; census="$CENSUS_PIDS"
    [ -z "$census" ] && break
    for p in $census; do kill -TERM "$p" 2>/dev/null; done
    sleep 1
    waited=$((waited + 1))
  done

  actor_tree_census "$pgid" "$marker"; census="$CENSUS_PIDS"
  if [ -n "$census" ]; then
    kill -KILL -- "-$pgid" 2>/dev/null
    for p in $census; do kill -KILL "$p" 2>/dev/null; done
    waited=0
    while [ "$waited" -lt "$KILL_SETTLE_SECS" ]; do
      sleep 1
      waited=$((waited + 1))
      actor_tree_census "$pgid" "$marker"; census="$CENSUS_PIDS"
      [ -z "$census" ] && break
      for p in $census; do kill -KILL "$p" 2>/dev/null; done
    done
  fi

  # The verification the objective rests on. Two ways it can fail, and they are
  # NOT the same: something is still running, or the sweep could not see.
  actor_tree_census "$pgid" "$marker"
  TEARDOWN_SURVIVORS="$CENSUS_PIDS"
  TEARDOWN_UNKNOWN="$CENSUS_UNKNOWN"
  [ -z "$TEARDOWN_SURVIVORS" ] && [ -z "$TEARDOWN_UNKNOWN" ]
}

# The disclosure half. A stop that could not clear the tree must say so BEFORE the
# lock is released and the process exits, because after that there is nobody left
# to notice. Silence here would restore exactly the defect 1a describes.
report_teardown() { # -> 0 when the tree was verified gone
  local msg
  if [ -z "$TEARDOWN_SURVIVORS" ] && [ -z "$TEARDOWN_UNKNOWN" ]; then
    # SCOPED ON PURPOSE. "The tree is gone" would be a stronger claim than three
    # handles can support — see the residual above, and dispatch.test.sh case 27h,
    # which fails if this sentence is ever widened.
    msg="  teardown verified: no descendant reachable by group, ancestry or inherited descriptor is still running"
    printf '%s\n' "$msg" >&2
    [ -n "${RUN_LOG:-}" ] && printf '%s\n' "$msg" >>"$RUN_LOG"
    return 0
  fi

  # An INCOMPLETE sweep that found nothing is not a clean teardown. It used to
  # print "teardown verified" here, which is the strongest claim in the script made
  # on the weakest evidence there is — no evidence. It is now its own state.
  if [ -z "$TEARDOWN_SURVIVORS" ]; then
    msg="  WARNING: teardown UNVERIFIED — the sweep could not establish whether descendants are still running.
  Reason: $TEARDOWN_UNKNOWN
  Nothing was found, but a sweep that cannot look is not a sweep that found nothing. Treat this run as
  possibly leaving processes behind: check with \`ps -ax\` before re-running."
  else
    msg="  WARNING: teardown could NOT confirm the actor's tree is gone. Still running: $TEARDOWN_SURVIVORS
  These processes were signalled and did not go. They are NOT stopped, and this run is not a clean halt.
  Inspect with \`ps -o pid,ppid,pgid,command -p <pid>\` and terminate them by hand before re-running."
    [ -n "$TEARDOWN_UNKNOWN" ] && msg="$msg
  The sweep was ALSO incomplete: $TEARDOWN_UNKNOWN"
  fi
  printf '%s\n' "$msg" >&2
  [ -n "${RUN_LOG:-}" ] && printf '%s\n' "$msg" >>"$RUN_LOG"

  # THE LOCK INVARIANT. The plan requires that no second dispatcher is admitted
  # while any descendant of the stopped actor may still be alive. Releasing the
  # lock here — which is what every exit path does by default, via die() and the
  # EXIT trap — would admit one. So the lock is PINNED: left in place, with the
  # reason written inside it, and `--status` reads that rather than reporting a
  # removable stale lock.
  pin_lock "$TEARDOWN_SURVIVORS" "$TEARDOWN_UNKNOWN"
  return 1
}

# SIGINT / SIGTERM.
#
# The handler this replaces was `trap 'release_lock' EXIT INT TERM` — a handler
# that never calls exit. Bash returns control to the interrupted point, so its
# only lasting effect was to DELETE the lock while the run carried on: the signal
# did not stop the run, it unlocked it, admitting a second dispatcher onto the
# same state file. All of that is OBSERVED, not reasoned —
# runs/probe-interruption-2026-08-07.md.
#
# The shutdown flag is belt and braces. This handler exits, so the loop should
# never see it; if a future edit ever returns from here instead, the flag still
# stops another actor being launched.
on_signal() { # signal name
  local sig="$1"
  SHUTDOWN=1
  trap '' INT TERM   # a second signal must not re-enter mid-teardown

  local where="between hops"
  [ -n "$CUR_ACTOR" ] && where="during hop $CUR_HOP (actor '$CUR_ACTOR')"

  printf 'STOP [28] interrupted by SIG%s %s — task %s\n' "$sig" "$where" "$TASK" >&2
  [ -n "${RUN_LOG:-}" ] && printf 'STOP [28] interrupted by SIG%s %s — task %s\n' "$sig" "$where" "$TASK" >>"$RUN_LOG"

  if [ -n "$ACTOR_PGID" ]; then
    printf '  terminating actor descendant tree (pgid %s)\n' "$ACTOR_PGID" >&2
    [ -n "${RUN_LOG:-}" ] && printf '  terminating actor descendant tree (pgid %s)\n' "$ACTOR_PGID" >>"$RUN_LOG"
    terminate_actor_tree "$ACTOR_PGID" "$ACTOR_MARKER"
    # Reported here, before release_lock and exit below: the lock must not be
    # handed on, and this process must not go, while the operator still believes
    # everything halted.
    report_teardown
  fi

  # An interrupted actor is NEVER retried and this run never resumes: the signal
  # may have landed after an effect nobody observed. The state file and Git are
  # the truth, and they are where the operator has to look.
  local msg="  the actor was killed mid-hop; it may have left a partial effect. Nothing is retried.
  Recoverable next action: read $STATE_FILE and \`git -C $CHECKOUT status\`, decide what the
  hop actually completed, then re-run this dispatcher. Run evidence: ${RUN_LOG:-<none>}"

  # O2 reaches the signal path too. This handler already SAID "it may have left
  # a partial effect" and then made the operator go and find out for themselves
  # — which is the same reporting gap the timeout had, one control over. Guarded
  # on CHECKOUT because a signal can in principle land before argument parsing
  # has resolved one, and a teardown path must not itself fail under `set -u`.
  [ -n "${CHECKOUT:-}" ] && msg="$msg$(partial_effect_block)"

  printf '%s\n' "$msg" >&2
  [ -n "${RUN_LOG:-}" ] && printf '%s\n' "$msg" >>"$RUN_LOG"

  release_lock
  exit 28
}

trap 'release_lock' EXIT
trap 'on_signal INT'  INT
trap 'on_signal TERM' TERM

# --status is read-only by contract: it must not take the lock, because its whole
# purpose is to be safe to run while another dispatcher holds it.
[ "$STATUS_MODE" -eq 1 ] || acquire_lock

# ----------------------------------------------------------------- --status
# Answers "is it still going?" without touching anything: no lock, no log dir, no
# run log, no state-file write. Every command below reads.
#
# It also gives the skill rule — once you have launched a run, the state file is
# not yours until it exits — something to CHECK rather than something to
# remember. The lock stops a second dispatcher (exit 17); it does not stop the
# parent Codex task editing the file by hand, and this is how that gets noticed.
if [ "$STATUS_MODE" -eq 1 ]; then
  printf 'status: task=%s\n' "$TASK"
  printf 'checkout=%s\n' "$CHECKOUT"

  if [ -d "$LOCK_DIR" ] && [ -f "$LOCK_DIR/survivors" ]; then
    # A PINNED lock, checked before the three pid states below. Its dispatcher is
    # gone by definition, so pid_state() would answer ABSENT and this command would
    # tell the operator to `rm -rf` the one thing standing between a second
    # dispatcher and a still-live descendant. The pin is the answer, not the pid.
    printf 'run: PINNED LOCK — the previous run could not confirm it stopped everything it started.\n'
    printf '     %s\n' "$LOCK_DIR"
    sed 's/^/     /' "$LOCK_DIR/survivors" 2>/dev/null
    printf '     a new dispatcher is REFUSED (exit 17) until this is cleared by hand.\n'
    # Re-check the recorded pids through pid_state(), NOT through a bare
    # `kill -0`. A bare `kill -0` fails for two unrelated reasons — the process
    # is gone, or it is alive and not ours to signal — and a survivor left by a
    # stopped actor is quite likely to be the second. Reading that as "gone" is
    # how this command would end up saying the lock is safe to remove while the
    # process it exists to protect against is still running. Same three-valued
    # rule as the census and as the lock's own pid check.
    st_left=""; st_maybe=""
    while read -r st_p; do
      case "$st_p" in ''|*[!0-9]*) continue ;; esac
      case "$(pid_state "$st_p")" in
        LIVE*)    st_left="$st_left $st_p" ;;
        UNKNOWN*) st_maybe="$st_maybe $st_p" ;;
      esac
    done <<EOF
$(sed -n 's/^descendants still running: //p' "$LOCK_DIR/survivors" 2>/dev/null | tr ' ' '\n')
EOF
    if [ -n "$st_left" ]; then
      printf '     STILL ALIVE NOW:%s — kill these before removing the lock.\n' "$st_left"
    fi
    if [ -n "$st_maybe" ]; then
      printf '     STILL ALIVE NOW (cannot inspect, so treat as running):%s — this uid may not\n' "$st_maybe"
      printf '     inspect or signal them. Check from an account that can before removing the lock.\n'
    fi
    if [ -z "$st_left" ] && [ -z "$st_maybe" ]; then
      printf '     none of the recorded pids is alive now; the lock is safe to remove once you have checked.\n'
    fi
  elif [ -d "$LOCK_DIR" ]; then
    st_pid="$(cat "$LOCK_DIR/pid" 2>/dev/null)"
    # Three states, not two. See pid_state() above for why "kill -0 failed" is
    # not the same question as "the process is gone".
    st_probe="$(pid_state "$st_pid")"
    st_pid_state="${st_probe%%|*}"    # LIVE | ABSENT | UNKNOWN
    st_pid_why="${st_probe#*|}"       # the evidence behind that verdict
    case "$st_pid_state" in
      LIVE)
        printf 'run: IN FLIGHT — dispatcher pid %s holds %s\n' "$st_pid" "$LOCK_DIR"
        printf '     do not edit the state file by hand until it exits.\n'
        printf '     to stop it: kill -TERM %s   (it terminates the actor and exits 28)\n' "$st_pid"
        ;;
      ABSENT)
        printf 'run: STALE LOCK — %s exists but pid %s is not running.\n' "$LOCK_DIR" "$st_pid"
        printf '     a dispatcher died without releasing it. Remove the directory to unblock: rm -rf %s\n' "$LOCK_DIR"
        ;;
      *)
        # Deliberately NOT actionable. This branch knows one thing — that it does
        # not know — and the only honest instruction is to go and look properly.
        printf 'run: UNKNOWN — CANNOT INSPECT pid %s holding %s\n' "${st_pid:-<unreadable>}" "$LOCK_DIR"
        printf '     why: %s\n' "$st_pid_why"
        printf '     THIS LOCK MAY BELONG TO A LIVE DISPATCHER. Treat the run as possibly in flight:\n'
        printf '     do not remove the lock, and do not edit the state file by hand on this answer.\n'
        printf '     The usual cause is that this caller cannot see the PID (sandbox policy or a\n'
        printf '     different owner), not that the run has ended. Re-run --status from somewhere\n'
        printf '     permitted to inspect processes — outside the tool sandbox — before concluding\n'
        printf '     anything. Everything below is what could still be read.\n'
        ;;
    esac
  else
    printf 'run: none in flight (no lock at %s)\n' "$LOCK_DIR"
  fi

  if [ -f "$STATE_FILE" ] && [ -r "$STATE_FILE" ]; then
    printf 'state: %s\n' "$STATE_FILE"
    printf '  turn=%s  task=%s  sha256=%s\n' \
      "$(fm_value "$STATE_FILE" turn)" "$(fm_value "$STATE_FILE" task)" "$(file_hash "$STATE_FILE")"
    if [ -n "$(git -C "$CHECKOUT" status --porcelain -- "logs/work-loop/$TASK.md" 2>/dev/null)" ]; then
      printf '  uncommitted: yes (expected mid-run when turn: claude — Codex writes, Claude commits)\n'
    else
      printf '  uncommitted: no\n'
    fi
  else
    printf 'state: MISSING or unreadable at %s\n' "$STATE_FILE"
  fi

  printf 'head=%s branch=%s\n' \
    "$(git -C "$CHECKOUT" rev-parse HEAD 2>/dev/null)" \
    "$(git -C "$CHECKOUT" rev-parse --abbrev-ref HEAD 2>/dev/null)"

  st_logdir="$LOG_DIR"; [ -n "$st_logdir" ] || st_logdir="$DEFAULT_LOG_DIR"
  st_last="$(ls -t "$st_logdir"/*-"$TASK".log 2>/dev/null | head -1)"
  if [ -n "$st_last" ]; then
    printf 'logs: %s\n' "$st_last"
    st_hop="$(grep -E '^hop=[0-9]+ actor=' "$st_last" 2>/dev/null | tail -1)"
    [ -n "$st_hop" ] && printf '  last hop line: %s\n' "$st_hop"
    st_stop="$(grep -E '^STOP \[' "$st_last" 2>/dev/null | tail -1)"
    [ -n "$st_stop" ] && printf '  last stop line: %s\n' "$st_stop"
  else
    printf 'logs: no run log for this task under %s\n' "$st_logdir"
  fi

  printf 'status is read-only. It launched nothing and wrote nothing. Read %s for the truth (core § 4).\n' "$STATE_FILE"
  exit 0
fi

# ------------------------------------------------------------ run evidence
[ -n "$LOG_DIR" ] || LOG_DIR="$DEFAULT_LOG_DIR"
mkdir -p "$LOG_DIR" || { printf 'STOP [10] cannot create log dir\n' >&2; exit 10; }
# The dispatcher's own evidence directory is not "foreign work". When --log-dir
# points inside the checkout, the run log this process is about to write would
# otherwise register as an out-of-allowlist change made by the dispatcher itself,
# and the pre-hop gate below would stop on it.
LOG_DIR_ABS="$(cd "$LOG_DIR" && pwd -P)" || { printf 'STOP [10] cannot canonicalize log dir\n' >&2; exit 10; }
if [ "$LOG_DIR_ABS" != "$CHECKOUT" ] && [ "${LOG_DIR_ABS#"$CHECKOUT"/}" != "$LOG_DIR_ABS" ]; then
  # Assigns the global declared near LAST_CAPTURE — allowlisted_dirty() reads it
  # to keep this directory out of the partial-effect report (O2).
  LOG_REL="${LOG_DIR_ABS#"$CHECKOUT"/}"
  ALLOW_PATHS+=("^$(printf '%s' "$LOG_REL" | sed 's|[][\.*^$]|\\&|g')/")
fi

# The run id has to survive two runs of the SAME task, started in the SAME
# second, from DIFFERENT checkouts, writing into ONE shared --log-dir. A
# second-resolution timestamp plus the task id does not: both runs computed the
# same id and silently overwrote each other's run log, hop captures and
# unattended profile. The same-checkout case is not the concern — the lock
# refuses that at exit 17, and this change does not touch the lock.
#
# The discriminator is the one already computed: LOCK_KEY is sha256(checkout|task),
# so within a single task it varies exactly when the checkout does. The pid
# separates two runs that somehow share both. No new concept is introduced.
#
# Field order is load-bearing, both ends:
#   timestamp FIRST — the directory still sorts chronologically by name;
#   task id LAST    — --status globs "*-$TASK.log", which stays an exact match
#                     and keeps matching run logs written before this change.
RUN_ID="$(date '+%Y%m%dT%H%M%S')-${LOCK_KEY:0:8}-$$-$TASK"
RUN_LOG="$LOG_DIR/$RUN_ID.log"
: >"$RUN_LOG"

# RUN_START is captured at the top of the script (see there). DEADLINE_AT empty
# means no deadline was asked for.
DEADLINE_AT=""
[ -n "$DEADLINE" ] && DEADLINE_AT=$(( RUN_START + DEADLINE ))

say "run=$RUN_ID mode=$MODE task=$TASK"
say "checkout=$CHECKOUT"
say "state=$STATE_FILE"
say "max_hops=$MAX_HOPS timeout=${ACTOR_TIMEOUT}s carry_one=$CARRY_ONE"
if [ -n "$DEADLINE_AT" ]; then
  say "deadline=${DEADLINE}s (expires $(date -r "$DEADLINE_AT" '+%Y-%m-%dT%H:%M:%S' 2>/dev/null || printf 'epoch %s' "$DEADLINE_AT"))"
else
  # Worth saying out loud. Without a deadline the real upper bound is
  # max_hops * timeout, which is where the plan's three-hour surprise came from.
  say "deadline=none — upper bound is max_hops * timeout = $(( MAX_HOPS * ACTOR_TIMEOUT ))s"
fi
say "allow_paths=${ALLOW_PATHS[*]}"
if [ "${#CLAUDE_DENY[@]}" -gt 0 ]; then
  say "claude_deny=${CLAUDE_DENY[*]}"
else
  # Said out loud because it is the risk the operator walks away on. No tool is
  # denied beyond what the child's own policy denies. That policy is no longer
  # this checkout's bypassPermissions on an attended hop — P0-F states
  # --permission-mode default at launch — but a permission mode only makes the
  # child ASK, and network is not coverable this way in any case:
  # runs/probe-unattended-authority-2026-08-07.md.
  say "claude_deny=none — no tool denied beyond the child's own policy (attended hops run --permission-mode default)"
fi
# Recorded separately from claude_deny, and always. claude_deny is the
# OPERATOR's set and may legitimately be empty; this one is the dispatcher's own.
# Folding them into one line would let "claude_deny=none" read as "nothing is
# denied", which stopped being true on the attended path (O1).
#
# Branched on the run shape because O1 reaches attended launches only. Printing
# the attended set on an unattended run would state a policy that this run's
# argv does not carry — the same class of false run evidence the honest-stop
# work exists to remove, one log line over.
if [ "$UNATTENDED" -eq 1 ]; then
  say "nested_actor_deny=n/a — this run is --unattended, and the contained profile carries no nested-actor rule; it is a separately settled artifact (see u_deny in launch_actor)"
  say "  nesting is blocked on this path only INCIDENTALLY, by the sandbox's network refusal — that is a side effect of another control, not a stated policy"
else
  say "nested_actor_deny=${NESTED_ACTOR_DENY[*]}"
  say "  nested_actor_deny is REQUESTED POLICY, not containment — it denies the default direct route at the child's permission layer and does not remove the capability"
fi

# Recorded at preflight, not at the stop. Whether exit 35 can name the denied
# tool and its exact target depends on this host having a JSON parser, and the
# operator of a long unattended run should learn that before walking away rather
# than when the stop arrives unable to say what was refused.
#
# EACH PARSER IS PROBED BY RUNNING IT, not by `command -v`. A jq that is on PATH
# but broken passes an existence check and then fails at the stop, which would
# make this line disagree with what permission_denials_in() actually does — the
# log would name a parser the run never used. The parse itself re-tries in the
# same order at call time, so a parser that breaks mid-run still degrades to the
# next tier rather than to a wrong answer.
if printf '{}' | jq -r . >/dev/null 2>&1; then
  say "denial_parser=jq — a permission stop (35) carries the denied tool and its EXACT target, untruncated"
elif python3 -c 'import json' >/dev/null 2>&1; then
  say "denial_parser=python3 — jq is unusable here; a permission stop (35) still carries the denied tool and its EXACT target, untruncated"
else
  say "denial_parser=none — neither jq nor python3 is usable here, so a permission stop (35) CANNOT name the denied tool and target; it will say so rather than guess"
fi

# ------------------------------------------------- unattended contained profile
#
# Item 1d. The operator settled the policy and a probe proved the mechanism; this
# section is the part that applies it. Everything here runs BEFORE the first hop,
# so a profile that cannot be delivered stops the run instead of degrading it.

# Compare two dotted versions. Returns 0 when $1 >= $2, 1 when lower, 2 when $1
# is not a readable dotted version at all. The third case is deliberately NOT
# folded into "lower": an unreadable version and an old version want the same
# refusal but different words, and guessing which one happened is how a gate
# starts lying.
version_at_least() { # have, want
  local have="$1" want="$2" i
  case "$have" in ''|*[!0-9.]*) return 2 ;; esac
  local -a h w
  IFS='.' read -r -a h <<<"$have"
  IFS='.' read -r -a w <<<"$want"
  [ "${#h[@]}" -ge 1 ] || return 2
  for i in 0 1 2; do
    local hv="${h[$i]:-0}" wv="${w[$i]:-0}"
    case "$hv" in ''|*[!0-9]*) return 2 ;; esac
    if [ "$hv" -gt "$wv" ]; then return 0; fi
    if [ "$hv" -lt "$wv" ]; then return 1; fi
  done
  return 0
}

# Pull the first dotted numeric version out of a `claude --version` line.
# The real output is `2.1.220 (Claude Code)`; this must not be fooled by a build
# suffix, and must come back empty rather than approximate when there is none.
version_number() { # raw version line
  printf '%s' "$1" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1
}

# The whole profile, as one JSON document delivered by CLI --settings.
#
# Every key here traces to a numbered layer of the proven profile in
# runs/probe-contained-authority-2026-08-07.md § Safe profile tested. The layers
# that are CLI-only (--tools, --strict-mcp-config, --disallowedTools,
# --no-session-persistence) and the env-only one (subprocess credential scrub)
# are applied in launch_actor, not here, and are logged alongside these.
write_unattended_profile() { # path -> 0 on success
  local path="$1" gitdir esc_checkout esc_gitdir
  # The child's Bash is sandboxed and home reads are denied, so the checkout has
  # to be re-allowed or the actor cannot read the repository it is working in.
  # Linked worktrees keep their objects in the common dir, which is elsewhere —
  # deny it and Git stops working inside the sandbox, silently and confusingly.
  gitdir="$(git -C "$CHECKOUT" rev-parse --path-format=absolute --git-common-dir 2>/dev/null)"
  [ -n "$gitdir" ] || gitdir="$CHECKOUT/.git"

  # `~/.gitconfig` is the ONE named exception inside the denied home tree, and it
  # is there because the profile without it does not merely inconvenience the
  # child — it stops Git working at all. Git reads that file on every invocation
  # and exits 128 before touching the repository when the read is refused:
  #   fatal: unable to access '/Users/…/.gitconfig': Operation not permitted
  # Measured, not reasoned: runs/probe-unattended-integration-2026-08-07.md.
  #
  # Why not neutralise Git's config discovery instead, which would grant no read
  # at all: the identity lives only in the global config in this repository
  # (`git config --local --get user.email` is empty), and core § 4 has Claude
  # commit every hop. A child without an identity fails every hop.
  #
  # Operator decision, 2026-08-07: allow the minimum Git configuration paths and
  # broaden home access no further. So this is a single FILE, not `~/.config/`,
  # not `~/.git*`, and not a directory. `~/.config/git/config` is deliberately
  # absent — it does not exist on the settled host, and the live probe confirms
  # Git works without it. Add it only if a run proves it necessary.
  #
  # KNOWN AND MEASURED: this file also carries credential-helper commands. The
  # child can therefore read that `gh auth git-credential` is configured. It
  # cannot get a token from it — `gh` reads its own credentials from
  # `~/.config/gh/`, which stays denied — and the probe asserts that rather than
  # assuming it. If a real secret is ever put in `~/.gitconfig`, this exception
  # stops being safe and must be revisited.

  # Minimal JSON string escaping. Paths can legitimately contain spaces (this
  # workspace's own do) and backslashes; unescaped they would produce a settings
  # file the child rejects, which reads as "sandbox unavailable" rather than as
  # "the dispatcher wrote bad JSON".
  esc_checkout="$(printf '%s' "$CHECKOUT" | sed 's/\\/\\\\/g; s/"/\\"/g')"
  esc_gitdir="$(printf '%s' "$gitdir"    | sed 's/\\/\\\\/g; s/"/\\"/g')"

  cat >"$path" <<PROFILE_EOF || return 1
{
  "sandbox": {
    "enabled": true,
    "failIfUnavailable": true,
    "allowUnsandboxedCommands": false,
    "network": {
      "allowedDomains": [],
      "strictAllowlist": true
    },
    "filesystem": {
      "denyRead": ["~/"],
      "allowRead": ["$esc_checkout", "$esc_gitdir", "~/.gitconfig"]
    }
  },
  "disableAllHooks": true,
  "disableClaudeAiConnectors": true,
  "disableRemoteControl": true,
  "disableAgentView": true,
  "disableArtifact": true,
  "autoMemoryEnabled": false
}
PROFILE_EOF
  [ -s "$path" ] || return 1
  return 0
}

if [ "$UNATTENDED" -eq 1 ]; then
  # 1. Platform. The proven profile is macOS Seatbelt. Claude Code sandboxes
  #    Linux too, but nobody has run this profile there, and "probably fine" is
  #    not what fail-closed means.
  u_os="$(uname -s 2>/dev/null)"
  [ "$u_os" = "Darwin" ] || die 31 "--unattended is proven on Darwin (macOS Seatbelt) only; this host reports '$u_os'."$'\n'"Recoverable next action: run without --unattended and accept the open authority, or prove the profile on this platform first."

  # 2. The binary, resolved the same way launch_actor resolves it. Gating a
  #    different binary from the one that will run is a gate in name only.
  UNATTENDED_BIN="$CLAUDE_BIN"
  [ -n "$UNATTENDED_BIN" ] || UNATTENDED_BIN="$(command -v claude 2>/dev/null)"
  [ -n "$UNATTENDED_BIN" ] && [ -x "$UNATTENDED_BIN" ] \
    || die 31 "--unattended cannot check the claude version: binary not resolvable"

  # 3. Version. strictAllowlist landed in 2.1.219; below that the network half
  #    of the profile is accepted and ignored, which is the silent failure.
  u_raw="$("$UNATTENDED_BIN" --version 2>&1 | head -1)"
  UNATTENDED_VERSION="$(version_number "$u_raw")"
  if [ -z "$UNATTENDED_VERSION" ]; then
    die 31 "--unattended cannot read a version from '$UNATTENDED_BIN' (got: ${u_raw:-<empty>}); refusing to assume it supports sandbox.network.strictAllowlist"
  fi
  version_at_least "$UNATTENDED_VERSION" "$UNATTENDED_MIN_VERSION"
  case $? in
    0) : ;;
    1) die 31 "--unattended needs claude >= $UNATTENDED_MIN_VERSION for sandbox.network.strictAllowlist; '$UNATTENDED_BIN' is $UNATTENDED_VERSION."$'\n'"Recoverable next action: upgrade claude, or run without --unattended and accept an open network." ;;
    *) die 31 "--unattended read an unusable version '$UNATTENDED_VERSION' from '$UNATTENDED_BIN'" ;;
  esac

  # 4. The profile itself, written per run so the evidence directory holds the
  #    exact bytes the child was launched under.
  UNATTENDED_SETTINGS="$LOG_DIR/$RUN_ID.unattended-settings.json"
  write_unattended_profile "$UNATTENDED_SETTINGS" \
    || die 31 "--unattended could not write its profile to $UNATTENDED_SETTINGS"

  # 5. Say what was applied, and through which scope. The scope is load-bearing,
  #    not decoration: the same JSON in a repository settings file would drop the
  #    network containment without a word, so "we sent a profile" is not the
  #    claim worth logging — "we sent it by CLI --settings" is.
  say "unattended=ON — contained profile applied to every Claude hop (item 1d)"
  say "  scope: CLI --settings (NOT a repository settings file — strictAllowlist has no effect from one)"
  say "  profile: $UNATTENDED_SETTINGS"
  say "  gate: claude $UNATTENDED_VERSION >= $UNATTENDED_MIN_VERSION at $UNATTENDED_BIN, platform $u_os"
  say "  sandbox: enabled, failIfUnavailable, allowUnsandboxedCommands=false"
  say "  network: allowedDomains=[] strictAllowlist=true (no Bash network, no approval prompt)"
  say "  filesystem: denyRead ~/ ; allowRead <checkout>, its git common dir, and ~/.gitconfig"
  say "    ~/.gitconfig is the ONE named file re-opened inside the denied home tree — without it Git"
  say "    exits 128 before touching the repository. No directory under ~/ is re-opened."
  say "  tools: Bash,Skill only — no built-in Read/Edit/Write, so file access goes through the sandbox"
  say "  mcp: --strict-mcp-config with no config — no MCP tools"
  say "  deny: ${UNATTENDED_BASE_DENY[*]}"
  say "  also: hooks, connectors, remote control, agent view, artifacts and auto-memory disabled; no session persistence"
  say "  env: CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1 — credentials stripped from subprocesses"
  say "  codex hops are NOT covered by this profile; their containment is codex's own --sandbox workspace-write"
  # The two known ways this can be true on the log and false in the child. Both
  # are stated at every run rather than in a document nobody opens mid-incident.
  say "  LIMIT: this records the REQUESTED policy. Array keys such as allowRead MERGE across settings scopes,"
  say "         so another scope on this host can widen what the child may read. Closing that needs managed"
  say "         settings (allowManagedReadPathsOnly / allowManagedDomainsOnly), which this dispatcher cannot set."
  say "  LIMIT: only a check from INSIDE a live child establishes the EFFECTIVE policy —"
  say "         runs/probes/unattended-effective-policy.sh"
elif [ "$MODE" = "live" ]; then
  say "unattended=off — Claude hops are NOT contained: open network, open filesystem, full tool set"
  # Said in the same breath, because the two are easy to confuse and the whole
  # point of P0-F is that they are not the same guarantee. The permission mode
  # makes the child ask; only --unattended contains what it can reach.
  say "  permission mode: default — asked for explicitly, so the child does NOT inherit this checkout's bypassPermissions"
  say "  that is a permission policy, not containment"
fi

# ------------------------------------------------------- state file reading
# Read-only throughout. This dispatcher never writes the state file; only the
# actors do (core § 4 — Claude commits, Codex writes the brief).
# fm_value() and file_hash() are defined above the lock section, because --status
# needs them before a lock exists.

validate_state() { # sets ST_TURN; dies on any failure. Never mutates.
  [ -f "$STATE_FILE" ] || die 13 "state file missing: $STATE_FILE"
  [ -r "$STATE_FILE" ] || die 13 "state file unreadable: $STATE_FILE"

  local declared
  declared="$(fm_value "$STATE_FILE" task)"
  [ -n "$declared" ] || die 14 "no readable 'task:' frontmatter in $STATE_FILE"
  if [ "$declared" != "$TASK" ]; then
    die 14 "identity mismatch — filename says '$TASK', frontmatter task: says '$declared'"
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

# Working-tree lines NOT covered by the allowlist. Any change here during an
# actor run is an unexpected repository effect.
foreign_worktree() {
  local line p
  git -C "$CHECKOUT" status --porcelain 2>/dev/null | while IFS= read -r line; do
    p="${line:3}"
    p="${p%\"}"; p="${p#\"}"
    local allowed=0 re
    for re in "${ALLOW_PATHS[@]}"; do
      if printf '%s' "$p" | grep -qE "$re"; then allowed=1; break; fi
    done
    [ "$allowed" -eq 0 ] && printf '%s\n' "$line"
  done | sort
}

staged_paths() { git -C "$CHECKOUT" diff --cached --name-only 2>/dev/null | sort; }

# Working-tree lines that ARE covered by the allowlist — the exact complement of
# foreign_worktree(), and the blind spot that made incident 2 unreadable (O2).
#
# foreign_worktree() answers "did the actor touch something it was not allowed
# to?". Nothing answered "did the actor touch something it WAS allowed to, and
# leave it uncommitted?" — so a hop that edited three permitted files and was
# then killed reported nothing at all, because every check that could have seen
# those edits was scoped to violations. The three facts a timeout reports today
# are individually true and collectively misleading: the state file did not
# change, the branch did not move, no foreign path was touched. All true. Work
# was still left on the floor, and the operator was not told.
#
# THIS IS EXPECTED OUTPUT, NOT A VIOLATION. In-allowlist edits are what the
# actor was sent to make. Listing them is reporting, never a stop condition —
# nothing in this dispatcher exits nonzero BECAUSE this function returned
# something. It only ever adds detail to a stop that had already been decided.
#
# TWO PATHS ARE EXCLUDED, and both are the dispatcher's own bookkeeping rather
# than the actor's work. Both were ADDED to the allowlist by this script — the
# run directory at the LOG_REL block, session-notes.md by the identity init — so
# without these exclusions every stop would report the dispatcher's own evidence
# files back to the operator as "work the hop did and did not commit". That is
# not merely noisy: it is the same class of false statement O2 exists to remove.
allowlisted_dirty() {
  local line p
  git -C "$CHECKOUT" status --porcelain --untracked-files=all 2>/dev/null | while IFS= read -r line; do
    p="${line:3}"
    p="${p%\"}"; p="${p#\"}"
    [ "$p" = "logs/session-notes.md" ] && continue
    if [ -n "$LOG_REL" ]; then
      case "$p" in "$LOG_REL"/*|"$LOG_REL") continue ;; esac
    fi
    local allowed=0 re
    for re in "${ALLOW_PATHS[@]}"; do
      if printf '%s' "$p" | grep -qE "$re"; then allowed=1; break; fi
    done
    [ "$allowed" -eq 1 ] && printf '%s\n' "$line"
  done | sort
}

# Fingerprint every currently dirty allowed path. The porcelain status alone is
# not enough: if a file was already dirty before launch and the actor edits it
# again, its status line can remain byte-for-byte identical. Pairing that line
# with the worktree blob hash makes the actor's additional edit observable while
# leaving untouched pre-existing handoffs out of the report.
allowlisted_dirty_snapshot() {
  local line p oid
  allowlisted_dirty | while IFS= read -r line; do
    [ -n "$line" ] || continue
    p="${line:3}"
    p="${p%\"}"; p="${p#\"}"
    if [ -e "$CHECKOUT/$p" ] || [ -L "$CHECKOUT/$p" ]; then
      oid="$(git -C "$CHECKOUT" hash-object -- "$p" 2>/dev/null || true)"
      [ -n "$oid" ] || oid="UNHASHABLE"
    else
      oid="ABSENT"
    fi
    printf '%s\t%s\n' "$oid" "$line"
  done | sort
}

# The partial-effect block appended to every post-launch stop (O2).
#
# Prints nothing when the working tree is clean, so a stop with no partial
# effects stays as short as it is now. When it does print, it says explicitly
# that the paths are NOT a violation — otherwise a reader meeting a file list
# inside a STOP message reasonably assumes the files are the problem.
partial_effect_block() {
  [ "${HOP_BASELINE_READY:-0}" -eq 1 ] || return 0

  local after dirty
  after="$(allowlisted_dirty_snapshot)"
  if [ -n "$HOP_ALLOWED_SNAPSHOT" ]; then
    dirty="$(comm -13 \
      <(printf '%s\n' "$HOP_ALLOWED_SNAPSHOT") \
      <(printf '%s\n' "$after") | cut -f2-)"
  else
    dirty="$(printf '%s\n' "$after" | cut -f2-)"
  fi
  [ -n "$dirty" ] || return 0
  printf '%s' $'\n'"PARTIAL FILE EFFECTS — since launch, the hop changed these ALLOWED paths and left them modified and uncommitted:"$'\n'"$dirty"$'\n'"These are inside --allow-path and are NOT a violation: they are work the hop changed and did not commit. They are still on disk. READ THEM BEFORE DECIDING ANYTHING — do not discard them and do not assume they are absent. \`git -C $CHECKOUT diff\` shows tracked content."
}

# Compatibility name for call sites that explicitly mean a post-launch stop.
#
# die() itself owns the structural guarantee now, so plain-die paths reached
# after launch (notably validate_state and the hop-limit guard) cannot bypass it.
die_hop() { # code, message
  die "$@"
}

# ------------------------------------------------ permission denials (O3)
#
# The hop capture has been written since the first version of this dispatcher
# and never once read. That is the whole defect: Claude reports every refused
# tool call in its own result JSON, under `permission_denials`, and the child
# still exits 0 — so a denial reached the operator as 25 (edited, could not
# commit) or 22 (nothing moved), and neither code NAMES the cause. On 2026-08-10
# that unnamed dead end is what the interactive bypass was reaching around.
#
# Reads BOTH capture shapes without the caller knowing which one it is on:
#   --output-format json         one object                  (attended, courier)
#   --output-format stream-json  one event per line          (--unattended)
# `jq -s` slurps either into an array, so one filter covers both.
#
# Fails SAFE, in the reporting direction: a truncated or unparseable capture
# yields no denials and the run classifies exactly as it does today. This
# function can only ever ADD a named cause; it can never invent a stop.
# NO TRUNCATION, on any path. An earlier version cut every target to 200
# characters, which silently broke the one promise this stop makes — the exit
# table and the README both say it carries the EXACT target — and a long
# `git commit -m …`, a deep path or a long URL is precisely the shape that got
# cut. A target the operator cannot act on is the unnamed dead end O3 removes,
# arriving one layer later.
denials_via_jq() { # capture -> lines on stdout; NONZERO if jq itself is unusable
  command -v jq >/dev/null 2>&1 || return 1
  jq -r -s '
    [ .[] | select(type == "object") | .permission_denials // empty | .[]? ]
    | map(
        (.tool_name // "?") + " :: " + (
          ( .tool_input.command
          // .tool_input.file_path
          // .tool_input.url
          // .tool_input.pattern
          // (.tool_input | tostring)
          ) | tostring
        )
      )
    | unique
    | .[]
  ' "$1" 2>/dev/null
}

# The same extraction without jq, so a host that lacks it still gets the exact
# tool and target instead of a placeholder. Deliberately a real JSON parse rather
# than a regex over the capture: the fields carry commit messages and shell
# commands, which contain quotes, braces and escapes, and a pattern-matched
# "exact" value would be a worse lie than the placeholder it replaced.
#
# Kept behaviourally identical to the jq filter, including its `unique` (which
# sorts) and its treatment of a null tool_name as "?", so the two tiers cannot
# report the same capture differently.
denials_via_python() { # capture -> lines on stdout; NONZERO if python3 is unusable
  command -v python3 >/dev/null 2>&1 || return 1
  python3 - "$1" <<'PYEOF' 2>/dev/null
import json, sys

def compact(v):
    return json.dumps(v, separators=(",", ":"), ensure_ascii=False)

def target(ti):
    if not isinstance(ti, dict):
        return compact(ti)
    for k in ("command", "file_path", "url", "pattern"):
        v = ti.get(k)
        if v is not None and v is not False:      # jq's // skips null and false
            return v if isinstance(v, str) else compact(v)
    return compact(ti)

raw = open(sys.argv[1], encoding="utf-8", errors="replace").read()

docs = []
try:
    docs.append(json.loads(raw))                  # --output-format json
except ValueError:
    for line in raw.splitlines():                 # --output-format stream-json
        line = line.strip()
        if not line:
            continue
        try:
            docs.append(json.loads(line))
        except ValueError:
            pass                                  # fails safe, as the jq filter does

seen = set()
for d in docs:
    if not isinstance(d, dict):
        continue
    for den in d.get("permission_denials") or []:
        if not isinstance(den, dict):
            continue
        tn = den.get("tool_name")
        if tn is None or tn is False:
            tn = "?"
        seen.add("%s :: %s" % (tn, target(den.get("tool_input"))))

for line in sorted(seen):
    print(line)
PYEOF
}

permission_denials_in() { # capture-path -> one "tool :: target" line per denial
  local cap="$1" out
  [ -s "$cap" ] || return 0

  # Tried in order, and a parser that FAILS falls through to the next rather than
  # being trusted for its empty output. That distinction is the whole point: jq
  # exits 0 with no output when a capture genuinely holds no denials, and
  # non-zero when it is missing or broken. Reading the second as the first is how
  # a real denial would go back to surfacing as a bare 25 or 22 — the exact
  # defect this function exists to remove. A `command -v` check alone cannot see
  # it, because a broken jq is on PATH.
  if out="$(denials_via_jq "$cap")"; then
    [ -n "$out" ] && printf '%s\n' "$out"
    return 0
  fi
  if out="$(denials_via_python "$cap")"; then
    [ -n "$out" ] && printf '%s\n' "$out"
    return 0
  fi

  # Neither parser is usable. Say so plainly rather than guessing at the JSON or
  # staying silent: "a denial happened and I cannot name it" is still worth far
  # more than the 25 this would otherwise have been reported as. This is the one
  # case in which the exit table's "exact target" promise is not met, and the
  # line says so instead of pretending otherwise.
  if grep -q '"permission_denials"[[:space:]]*:[[:space:]]*\[[[:space:]]*{' "$cap" 2>/dev/null; then
    printf '%s\n' "? :: (detail unavailable — neither jq nor python3 is usable here; read the capture directly)"
  fi
}

# Paths an actor COMMITTED between two HEADs that the allowlist does not cover.
#
# This closes the gap the investigation found and then accepted: foreign_worktree()
# reads `git status --porcelain`, and Claude commits its work each hop, so a clean
# tree passes the guard no matter what went into the commit. Only stray
# *uncommitted* files ever tripped it.
#
# DETECTION, NOT PREVENTION. The commit has already happened by the time this
# runs; the value is stopping rather than compounding it over the next six hops of
# a run nobody is watching.
#
# The honest cost: this is only as good as --allow-path. The allowlist has to
# describe what the UNIT may legitimately touch, which makes it a per-task input
# Codex derives when it writes the brief. Too narrow and correct work gets a false
# stop; too wide and this check means nothing.
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

# Is the state file itself uncommitted right now?
#
# This is deliberately asymmetric, because the two sides differ (core § 4):
# Codex writes the file and never runs git, so an uncommitted file with
# turn: claude is the *expected* handoff. Claude commits, so an uncommitted file
# after a Claude hop means the hop died between editing and committing — the
# partial-side-effect case the investigation says must stop for inspection
# rather than be retried blind.
state_dirty() {
  [ -n "$(git -C "$CHECKOUT" status --porcelain -- "logs/work-loop/$TASK.md" 2>/dev/null)" ]
}

# Repository conditions an actor must never be launched on top of, because a
# second writer compounds them into something no automated step can unpick.
# Emitted one per line, empty when the checkout is safe to work in.
#
# index.lock is included deliberately: it means another Git process is mid-write
# in this checkout right now. Launching an actor that will itself run Git turns a
# transient lock into two racing writers.
git_hazards() {
  local gd
  gd="$(git -C "$CHECKOUT" rev-parse --absolute-git-dir 2>/dev/null)" || return 0
  [ -e "$gd/index.lock" ]        && printf 'a Git index.lock is held (%s)\n' "$gd/index.lock"
  [ -e "$gd/MERGE_HEAD" ]        && printf 'a merge is in progress (MERGE_HEAD)\n'
  [ -d "$gd/rebase-merge" ]      && printf 'a rebase is in progress (rebase-merge)\n'
  [ -d "$gd/rebase-apply" ]      && printf 'a rebase or am is in progress (rebase-apply)\n'
  [ -e "$gd/CHERRY_PICK_HEAD" ]  && printf 'a cherry-pick is in progress (CHERRY_PICK_HEAD)\n'
  [ -e "$gd/REVERT_HEAD" ]       && printf 'a revert is in progress (REVERT_HEAD)\n'
  return 0
}

# Is this file a core § 4 closing record? Read-only.
#
# The absence of ## Blocker and ## Next action is NECESSARY for a closing record
# and nowhere near SUFFICIENT: a Claude hop that died after deleting the active
# fields and before writing the record leaves a file with neither section and no
# closing record either. Classifying that as "closed" is the seam this checks.
#
# What is enforced: the heading sequence is EXACTLY core § 4's four, once each, in
# that order, with nothing else surviving. The comparison is against the literal
# sequence, so it settles presence, order, duplication and extras in one test —
# an earlier version piped through `sort -u`, which silently accepted a record
# with the four sections shuffled or one of them written twice.
#
# What is deliberately NOT enforced: section contents. Those are the actors'
# business, not the dispatcher's, and validating prose is the general state
# validation this must not become. Anything unrecognised stops for inspection
# rather than being labelled either way.
closing_record_ok() {
  local heads
  heads="$(grep -E '^## ' "$STATE_FILE" 2>/dev/null | sed 's/[[:space:]]*$//')"
  [ "$heads" = "$(printf '## Outcome\n## Decisions that matter\n## Evidence\n## Accepted limitations')" ]
}

# The state file's operator-facing content, for the stop message. Read-only.
# Bounded so a long brief cannot flood the run log.
operator_question() {
  awk '
    /^## (Blocker|Next action)$/ { keep=1; print; next }
    /^## / { keep=0 }
    keep && n < 24 { print; n++ }
  ' "$STATE_FILE" 2>/dev/null
}

# -------------------------------------------------------------- actor launch

# Wall-clock timeout without timeout(1) — not installed on this machine.
# Runs the command in the background, polls, escalates TERM then KILL, and also
# sweeps direct children so a wrapper does not strand the real process.
#
# The deadline is wall-clock, not a count of poll iterations. Counting
# iterations drifts badly: each pass costs `sleep 1` PLUS the polling work, so
# the counter runs slower than real time and the timeout silently becomes a
# lower bound. The 2026-08-05 live run showed the size of that drift — a hop
# logged duration=420s against a --timeout of 420 and still exited 0.
# `set -m` before backgrounding is what makes the actor a process-group leader
# (pgid == its own pid, distinct from this script's). Without it the actor shares
# the dispatcher's group, and neither the timeout below nor the signal handler can
# reach its descendants — OBSERVED, runs/probe-interruption-2026-08-07.md, where a
# grandchild outlived a sweep that only reached direct children.
#
# ACTOR_PGID is published to the global so on_signal() can reach the tree from
# outside this function, and cleared on the way out so a signal arriving between
# hops does not try to kill a group that has already gone.
run_bounded() { # timeout, logfile, cmd...
  local limit="$1"; shift
  local out="$1"; shift
  local pid start rc marker

  # The per-hop tree marker. Opened here, inherited by the actor and everything
  # below it, and closed in THIS process immediately afterwards so the dispatcher
  # never appears in its own census. Nothing else has a reason to open this file —
  # which is exactly why holding it is evidence of descent from the actor, and why
  # the public hop log (which an operator may `tail -f`) must not be used instead.
  marker="${out%.out}.tree"
  : >"$marker" 2>/dev/null

  set -m
  eval "exec ${TREE_MARKER_FD}>\"\$marker\""
  "$@" >>"$out" 2>&1 &
  pid=$!
  eval "exec ${TREE_MARKER_FD}>&-"
  set +m

  ACTOR_PGID="$pid"
  ACTOR_MARKER="$marker"
  start="$(date '+%s')"

  while kill -0 "$pid" 2>/dev/null; do
    if [ "$(( $(date '+%s') - start ))" -ge "$limit" ]; then
      terminate_actor_tree "$pid" "$marker"
      # Reported at the teardown, not at the die() below, because both the
      # per-actor timeout (21) and the deadline (29) come through here and the
      # disclosure must not depend on which of them the caller picks.
      report_teardown
      wait "$pid" 2>/dev/null
      ACTOR_PGID=""
      ACTOR_MARKER=""
      return 124
    fi
    # 1s poll. This is also the worst-case latency between an operator's
    # `kill -TERM` and the handler running, because a trap fires between
    # commands and `sleep` is the command it interrupts.
    sleep 1
  done

  wait "$pid"; rc=$?
  ACTOR_PGID=""
  ACTOR_MARKER=""
  return "$rc"
}

codex_prompt() {
  cat <<EOF
Use the \$work-loop-v2 skill.

The task is exactly: $TASK
Its state file is exactly: logs/work-loop/$TASK.md

Do not scan logs/work-loop/ for a candidate task and do not act on any other
file in that directory — several unrelated fixtures live there. Read that one
file, take your turn on it, and set turn: for whoever moves next.

You do not run git. Claude commits.
EOF
}

# Seconds left on the whole-run clock. Prints a very large number when no
# deadline was set, so callers can use min() unconditionally without branching.
remaining_seconds() {
  if [ -z "$DEADLINE_AT" ]; then printf '%s' 2147483647; return 0; fi
  local left=$(( DEADLINE_AT - $(date '+%s') ))
  [ "$left" -lt 0 ] && left=0
  printf '%s' "$left"
}

# The clamp that makes --deadline a deadline rather than a start gate.
#
# v0.1 only refused to START an actor past the deadline, which is not a bound: an
# actor launched at minute 39 with a 900s timeout runs to minute 54. Clamping the
# per-actor timeout to whatever is left bounds the overrun.
#
# THE HONEST BOUND, since a deadline is only worth what its worst case is:
#
#   overrun <= 1s (poll interval)
#            + TERM_GRACE_SECS      (TERM -> KILL)
#            + KILL_SETTLE_SECS     (KILL -> verified gone)
#            + census cost          (~0.3s per pass, several passes)
#            + reaping
#
# — about 9 seconds with the current grace of 5 and settle of 2. A run given
# --deadline 2400 can therefore end at roughly 2409s, never at 2400s exactly, and
# never at 2400 + --timeout. Case 28 asserts the arithmetic rather than a round
# number, so tightening either constant tightens the test with it.
#
# THIS BOUND GREW ON 2026-08-07, from ~6s, and the growth is deliberate. Truthful
# whole-tree teardown costs a verification pass the group-only sweep never did:
# it re-censuses after SIGKILL instead of assuming the signal worked. The plan
# forbids relaxing the hard clock silently, so the new worst case is stated here
# and asserted in the suite rather than left to be discovered by a run that
# overshot. It is NOT "about 6 seconds" — that was true of the weaker teardown.
effective_timeout() {
  local left; left="$(remaining_seconds)"
  if [ "$left" -lt "$ACTOR_TIMEOUT" ]; then printf '%s' "$left"; else printf '%s' "$ACTOR_TIMEOUT"; fi
}

launch_actor() { # actor, hop, effective-timeout -> exit status of the launch
  local actor="$1" hop="$2" limit="$3"
  local out="$LOG_DIR/$RUN_ID.hop$hop.$actor.out"
  : >"$out"
  # Published so the post-hop checks read the capture that was ACTUALLY written.
  # Recomputing the path at the call site was the available alternative and it is
  # wrong on the retry branch, where the hop suffix is "${hop}r" — the denial
  # check would have silently read the first attempt's capture.
  LAST_CAPTURE="$out"

  if [ -n "$ACTOR_CMD" ]; then
    say "  launch: mode=simulated timeout=${limit}s cmd=$ACTOR_CMD"
    WL_ACTOR="$actor" WL_TASK="$TASK" WL_CHECKOUT="$CHECKOUT" \
    WL_STATE_FILE="$STATE_FILE" WL_HOP="$hop" \
      run_bounded "$limit" "$out" bash -c "$ACTOR_CMD"
    return $?
  fi

  case "$actor" in
    codex)
      [ -x "$CODEX_BIN" ] || die 20 "codex binary not executable: $CODEX_BIN"
      local cv; cv="$("$CODEX_BIN" --version 2>&1 | head -1)"
      say "  launch: mode=live actor=codex timeout=${limit}s bin=$CODEX_BIN version=$cv"
      say "  cmd: codex exec --sandbox workspace-write -C <checkout> --json <prompt>"
      run_bounded "$limit" "$out" \
        "$CODEX_BIN" exec --sandbox workspace-write -C "$CHECKOUT" --json "$(codex_prompt)"
      return $?
      ;;
    claude)
      local cb="$CLAUDE_BIN"
      [ -n "$cb" ] || cb="$(command -v claude 2>/dev/null)"
      [ -n "$cb" ] && [ -x "$cb" ] || die 20 "claude binary not resolvable"
      local vv; vv="$("$cb" --version 2>&1 | head -1)"
      say "  launch: mode=live actor=claude timeout=${limit}s bin=$cb version=$vv"
      # No --dangerously-skip-permissions, on any path. The attended child asks
      # for --permission-mode default instead — the opposite flag.
      #
      # Why the request is explicit (P0-F, 2026-08-09). This checkout's own
      # settings.json declares defaultMode: bypassPermissions, and an attended
      # child INHERITED it: the discovery run read `permissionMode:
      # bypassPermissions` off the runtime's own system/init event. A dispatcher
      # that launches an actor with bypass authority nobody asked for is what
      # the v0.2 plan forbids, so the mode is now stated at launch time rather
      # than left to whatever the checkout happens to declare. The same
      # discovery's green control proved this reaches the child — system/init
      # reported `default` — and that no settings file in any layer had to
      # change for it. Full record: ../../../logs/work-loop/…-phase0-p0-f.md in
      # the root repository, commit 7bb3abf.
      #
      # This is a PERMISSION POLICY, not containment. It makes the child ask
      # before an action its policy gates; it does not sandbox anything. OS-level
      # containment is --unattended, which is a separate branch below and is
      # deliberately left carrying no permission mode of its own.
      #
      # --claude-deny NARROWS it further, for this child only, and only when
      # asked for. It composes with the mode rather than replacing it, so both
      # attended shapes below carry the same pair.
      # Deliberately NOT `( cd ... && run_bounded ... )`. A subshell would confine
      # run_bounded's assignment to ACTOR_PGID, leaving the signal handler with
      # nothing to terminate on exactly the hops that matter most — the live
      # Claude ones. cd and restore instead.
      local prev_pwd="$PWD" rc_claude
      cd "$CHECKOUT" || die 11 "cannot enter checkout: $CHECKOUT"
      if [ "$UNATTENDED" -eq 1 ]; then
        # The contained profile (1d). Built as an array so the operator's own
        # --claude-deny rules append to the base set rather than replacing it:
        # this flag may narrow the profile further, never widen it.
        # NESTED_ACTOR_DENY IS DELIBERATELY ABSENT HERE. Do not add it back
        # without reopening the profile as its own unit.
        #
        # O1's surface is the ATTENDED launch path only. The contained profile is
        # a separately settled artifact (item 1d), and the O1 plan excludes it by
        # name and requires this argv to stay byte-unchanged as O1's own control.
        # A commit on 2026-08-11 prepended the nested set here anyway, which made
        # that control impossible to pass; case 32z now freezes this argv so the
        # same widening cannot land silently again.
        #
        # The argument for adding it is real and is NOT settled by this comment:
        # the profile's --tools roster still exposes Bash, so nesting is blocked
        # here only INCIDENTALLY, by the sandbox's network refusal, and incidental
        # protection cannot be reasoned about. That is a case for reopening the
        # profile deliberately, with its own evidence — not for widening it as a
        # side effect of an attended-path fix.
        local -a u_deny=("${UNATTENDED_BASE_DENY[@]}")
        [ "${#CLAUDE_DENY[@]}" -gt 0 ] && u_deny+=("${CLAUDE_DENY[@]}")
        # stream-json rather than json, and ONLY on this path.
        #
        # The stream's first event is the product's own `system/init`, which
        # states the tool roster and the MCP servers the runtime ACTUALLY
        # resolved. That is the one surface on which "only Bash and Skill are
        # exposed" and "no MCP is loaded" can be checked as effective behaviour
        # rather than taken from the argv we asked for or from the child's own
        # prose — and both of those were scored as passes here until Codex's
        # 2026-08-07 assessment caught it.
        #
        # Nothing is lost: the stream's final `result` event is byte-identical
        # to what --output-format json produced, so this is a superset of the
        # previous capture, not a different one. --verbose is required for
        # stream-json under --print.
        #
        # Attended and courier hops keep --output-format json. The extra volume
        # is the price of an auditable roster, and it is only worth paying where
        # nobody is watching.
        say "  cmd: claude -p '/work-loop-v2 $TASK' --output-format stream-json --verbose --settings <profile> --tools Bash,Skill --strict-mcp-config --no-session-persistence --disallowedTools ${u_deny[*]} (cwd=<checkout>, CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1)"
        say "  note: the hop capture's system/init event records the EFFECTIVE tool roster and MCP servers; this log records only what was REQUESTED"
        CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1 \
        run_bounded "$limit" "$out" "$cb" -p "/work-loop-v2 $TASK" \
          --output-format stream-json --verbose \
          --settings "$UNATTENDED_SETTINGS" \
          --tools 'Bash,Skill' \
          --strict-mcp-config \
          --no-session-persistence \
          --disallowedTools "${u_deny[@]}"
      else
        # The attended path now ALWAYS passes --disallowedTools, because
        # NESTED_ACTOR_DENY (O1) is never empty. The two attended branches that
        # used to exist — "with denies" and "plain" — collapsed into this one,
        # which also removes the failure mode where a fix applied to one branch
        # left the other silently unprotected.
        #
        # --claude-deny APPENDS. It cannot remove a nested-actor rule; the
        # operator flag may narrow the profile further, never widen it. Same
        # composition rule the unattended path already used.
        local -a a_deny=("${NESTED_ACTOR_DENY[@]}")
        [ "${#CLAUDE_DENY[@]}" -gt 0 ] && a_deny+=("${CLAUDE_DENY[@]}")
        say "  cmd: claude -p '/work-loop-v2 $TASK' --output-format json --permission-mode default --disallowedTools ${a_deny[*]} (cwd=<checkout>)"
        say "  note: the nested-actor denies are requested policy, NOT containment — a child with shell access can construct paths these rules do not name (see NESTED_ACTOR_DENY)"
        run_bounded "$limit" "$out" "$cb" -p "/work-loop-v2 $TASK" --output-format json \
          --permission-mode default \
          --disallowedTools "${a_deny[@]}"
      fi
      rc_claude=$?
      cd "$prev_pwd" || true
      return "$rc_claude"
      ;;
    *) die 15 "cannot launch actor '$actor'" ;;
  esac
}

# ------------------------------------------- headless session identity (U1)
# A dispatcher-launched Claude runs no /prime, so this checkout has no per-id
# marker and no `- Files in scope:` bullet. .claude/hooks/check-foreign-staging.sh
# then falls back to the checkout-level shared marker (logs/.session-marker) and
# reads WHATEVER SESSION LAST ALLOCATED IT as this session's footprint — a stale
# stranger's footprint that can false-block legitimate work or false-pass a
# foreign file. (Mechanism verified 2026-08-06 against the hook's own code;
# recorded in logs/work-loop/work-loop-v2-production-readiness-policy.md.)
#
# The smallest sufficient fix is TWO WRITES, not a session lifecycle:
#   1. allocate a fresh marker via logs/scripts/prime-session-entry.sh — the
#      standalone allocator /prime itself delegates to, invoked by absolute path
#      with cwd = this checkout so it writes into THIS worktree's logs/;
#   2. append one concrete `- Files in scope:` bullet under the allocated
#      header, derived from this run's own --allow-path set — the same authority
#      boundary the dispatcher already enforces.
# After those, the shared marker names THIS run's header and the guard is armed
# with THIS run's footprint. In --unattended mode the child's hooks are disabled
# so the tripwire never fires there; the init still runs, because the marker
# sequence and the header keep this run visible to every OTHER session's guards
# and to the operator's logs.
init_session_identity() {
  local entry="$CHECKOUT/logs/scripts/prime-session-entry.sh"
  local notes="$CHECKOUT/logs/session-notes.md"
  local marker_file="$CHECKOUT/logs/.session-marker"
  local line today marker scope re p

  # A checkout that does not carry the allocator does not carry the /prime
  # session-guard infrastructure this init exists to arm — fixture repos and
  # sandbox clones are the normal case. Skip with a visible line rather than
  # failing: exit 32 is reserved for a checkout that HAS the allocator and
  # could not complete the init, which is the dangerous half-state.
  if [ ! -x "$entry" ]; then
    say "identity: $entry absent — skipping session-identity init (no /prime infrastructure in this checkout)."
    return 0
  fi

  # The footprint is the run's own allowlist, rendered from regex to prose paths
  # (strip the ^/$ anchors, unescape dots). The guard's concreteness test needs a
  # path-shaped entry, and directory entries (`logs/work-loop/`) are the form
  # live sessions already use.
  scope=""
  for re in "${ALLOW_PATHS[@]}"; do
    p="${re#^}"; p="${p%\$}"; p="${p//\\./.}"
    [ -n "$p" ] || continue
    scope="${scope:+$scope, }$p"
  done
  [ -n "$scope" ] && scope="$scope, " ; scope="${scope}logs/work-loop/$TASK.md"

  # Idempotence: a resumed run re-enters here. If the shared marker already names
  # a header carrying a concrete footprint bullet from a previous invocation of
  # THIS init, reuse it rather than allocating a second marker per restart.
  if [ -f "$marker_file" ]; then
    line="$(cat "$marker_file" 2>/dev/null || true)"
    today="${line%% *}"; marker="${line#* }"
    if [ "$today" = "$(date '+%Y-%m-%d')" ] && [ -n "$marker" ] && [ "$marker" != "$line" ] &&
       awk -v hdr="## ${today} — Session ${marker}" '
         $0 == hdr {inb=1; next}
         /^## /    {inb=0}
         inb && /^[[:space:]]*- Files in scope:/ {found=1}
         END {exit !found}' "$notes" 2>/dev/null; then
      say "identity: reusing marker '$line' — its header already carries a concrete footprint."
      return 0
    fi
  fi

  line="$(cd "$CHECKOUT" && "$entry" "Work Loop v2 dispatcher run — task $TASK (headless)")" ||
    die 32 "session-identity init failed: prime-session-entry.sh could not allocate a marker in $CHECKOUT (see its stderr above). Nothing was launched."
  today="${line%% *}"; marker="${line#* }"

  # The allocator appended this run's header (plus its **Work:** line) at the end
  # of session-notes.md, so an append lands inside that header's block — exactly
  # where the guard's block-scoped scan reads the bullet from.
  printf -- '- Files in scope: %s\n' "$scope" >>"$notes" ||
    die 32 "session-identity init failed: marker '$line' was allocated but the footprint bullet could not be written to $notes. Stopping rather than launching with a header the guard would read as footprint-less."

  say "identity: allocated marker '$line'; footprint: $scope"
}

# ------------------------------------------------------------------ the loop

validate_state
say "initial: turn=$ST_TURN sha256=$(file_hash "$STATE_FILE") head=$(git_head)"

# Restart safety. Truth comes from the file and Git, never from an old in-memory
# turn — this process has no memory beyond the task id it was given.
if state_dirty; then
  case "$ST_TURN" in
    claude)
      say "note: the state file is uncommitted with turn: claude — the expected Codex handoff (Codex never runs git)." ;;
    codex|operator)
      die 25 "the state file is uncommitted with turn: $ST_TURN — Claude commits, so a previous run died between editing and committing, or its commit was refused."$'\n'"Recoverable next action: read \`git diff -- logs/work-loop/$TASK.md\`. If the edit is complete, commit it and re-run this dispatcher; if it is partial, discard it and re-run." ;;
  esac
fi

if [ "$DRY_RUN" -eq 1 ]; then
  if [ "$CARRY_ONE" -eq 1 ]; then
    say "dry-run: --carry-one would launch actor '$ST_TURN' for task '$TASK' and stop after that one hop; launching nothing."
  else
    say "dry-run: would launch actor '$ST_TURN' for task '$TASK'; launching nothing."
  fi
  # Dry-run inspects; it never launches, so it reports hazards instead of failing
  # on them. Loop mode stops on the same conditions before every hop.
  dr_haz="$(git_hazards)"
  [ -n "$dr_haz" ] && say "dry-run: repository hazards present — loop mode would stop:"$'\n'"$dr_haz"
  dr_foreign="$(foreign_worktree)"
  [ -n "$dr_foreign" ] && say "dry-run: out-of-allowlist working-tree changes present — loop mode would stop:"$'\n'"$dr_foreign"
  [ "$ST_TURN" = "operator" ] && say "dry-run: turn is operator — automation is terminal here."
  # --dry-run --unattended is a real preflight, not a formality: the version gate,
  # the platform check and the profile write have all already run above, so
  # reaching this line means the contained profile is deliverable on this host.
  [ "$UNATTENDED" -eq 1 ] && say "dry-run: the contained profile passed its gate and was written; a live run would launch under it."
  say "dry-run: a live run would first initialize headless session identity (marker + footprint bullet) in this checkout; writing nothing."
  release_lock
  exit 0
fi

# Identity before actors. Runs once per invocation, before hop 1, so every child
# this run launches inherits an armed-and-correct guard rather than the
# shared-marker fallback. --dry-run exited above: a validate-and-route call
# writes nothing, so it must not allocate markers either.
init_session_identity

hop=0
while :; do
  validate_state

  if [ "$ST_TURN" = "operator" ]; then
    say "hop=$hop turn=operator — stopping for the operator (core § 7). No further launches."
    # turn: operator has two causes and they are not the same message. A core § 7
    # question leaves `## Blocker` / `## Next action` in place; a core § 4 close
    # deletes them, so operator_question() comes back empty. Announcing an
    # UNANSWERED question above an empty block asserts a question that does not
    # exist — measured on the 2026-08-05 parallel proof, where both tasks reached
    # turn: operator by closing.
    op_q="$(operator_question)"
    if [ -n "$op_q" ]; then
      say "The question below is UNANSWERED. Neither model nor this dispatcher answered it,"
      say "and nothing here is a decision — the operator owns it (core § 7)."
      say "--- state file, as the actors left it ---"
      say "$op_q"
      say "--- end ---"
    elif closing_record_ok; then
      say "The task is CLOSED: the state file carries the core § 4 closing record and"
      say "nothing else — ## Outcome, ## Decisions that matter, ## Evidence and"
      say "## Accepted limitations. There is no unanswered question here."
      say "The closing record is at $STATE_FILE."
    else
      # Neither shape. Saying "closed" here would be a guess dressed as a verdict,
      # so the run stops visibly instead — still with no further actor launch,
      # because turn: operator is terminal for automation whatever the file says.
      die 26 "turn: operator, but $STATE_FILE is neither a core § 7 question (no ## Blocker, no ## Next action) nor a core § 4 closing record (its headings are: $(grep -E '^## ' "$STATE_FILE" 2>/dev/null | tr '\n' ' ' | sed 's/ *$//'))."$'\n'"Recoverable next action: read the file. If a hop died mid-write, restore or complete it, then re-run this dispatcher. No actor was launched."
    fi
    release_lock
    exit 0
  fi

  # Belt and braces. on_signal() exits, so this should be unreachable; it is here
  # so that if a later edit ever makes the handler return instead, the run still
  # cannot launch another actor after the operator asked it to stop.
  if [ "$SHUTDOWN" -eq 1 ]; then
    die 28 "shutdown requested — refusing to launch another actor (task '$TASK', after $hop hop(s))"
  fi

  if [ "$hop" -ge "$MAX_HOPS" ]; then
    die 23 "hop limit reached ($MAX_HOPS) with turn still '$ST_TURN' — stopping rather than continuing"
  fi

  # Hazards are checked before every hop, not once at startup, because a restart
  # re-enters here and because the checkout can change between hops.
  hazards="$(git_hazards)"
  if [ -n "$hazards" ]; then
    die 19 "the checkout is in a hazardous Git state before launching $ST_TURN — task '$TASK':"$'\n'"$hazards"$'\n'"Recoverable next action: finish or abort the operation above, then re-run this dispatcher."
  fi

  # Foreign staged state stops the spike rather than being swept into a commit.
  staged="$(staged_paths)"
  if [ -n "$staged" ]; then
    die 16 "paths already staged before launching $ST_TURN:"$'\n'"$staged"
  fi

  before_foreign="$(foreign_worktree)"

  # Out-of-allowlist working-tree changes that were ALREADY there. The before/after
  # delta below cannot see these: it compares two snapshots that both contain them,
  # so pre-existing foreign work used to pass straight through. The allowlist keeps
  # the expected uncommitted Codex state-file handoff out of this set.
  if [ -n "$before_foreign" ]; then
    die 18 "out-of-allowlist working-tree changes are already present before launching $ST_TURN — task '$TASK':"$'\n'"$before_foreign"$'\n'"Recoverable next action: commit, stash or revert the paths above, then re-run this dispatcher."
  fi
  before_hash="$(file_hash "$STATE_FILE")"
  before_turn="$ST_TURN"
  before_head="$(git_head)"

  # The whole-run clock, checked before the launch rather than only at startup.
  # An expired budget stops here with its own code: a run that ran out of time is
  # resumable and unfinished, and reporting it as 0 would be the single most
  # misleading thing this dispatcher could do to someone who has just walked back
  # in expecting either finished work or a question.
  if [ -n "$DEADLINE_AT" ] && [ "$(remaining_seconds)" -le 0 ]; then
    die_hop 29 "budget exhausted — the ${DEADLINE}s deadline expired with turn still '$before_turn' after $hop hop(s). THIS IS NOT COMPLETION."$'\n'"The state file and Git are untouched by this stop, so the work is resumable: re-run this dispatcher to continue from $STATE_FILE."
  fi
  eff_timeout="$(effective_timeout)"

  hop=$((hop + 1))
  CUR_HOP="$hop"; CUR_ACTOR="$before_turn"
  say ""
  say "hop=$hop actor=$before_turn"
  say "  before: sha256=$before_hash turn=$before_turn head=$before_head"
  if [ -n "$DEADLINE_AT" ]; then
    say "  budget: $(remaining_seconds)s left of ${DEADLINE}s; actor timeout clamped to ${eff_timeout}s"
  fi

  before_dirty=0; state_dirty && before_dirty=1

  # Take the attribution baseline as late as possible before launch. It remains
  # live after the actor returns so every later stop compares against the same
  # repository reality the actor received.
  HOP_ALLOWED_SNAPSHOT="$(allowlisted_dirty_snapshot)"
  HOP_BASELINE_READY=1

  started="$(date '+%s')"
  launch_actor "$before_turn" "$hop" "$eff_timeout"
  rc=$?
  duration=$(( $(date '+%s') - started ))

  # A 124 means run_bounded hit the limit it was given. WHICH limit that was
  # decides the exit code, and they are not the same event: 21 is "this actor is
  # stuck", 29 is "the run is out of time". Conflating them would tell the
  # operator to inspect one hop when the real news is that the budget is gone.
  if [ "$rc" -eq 124 ]; then
    if [ -n "$DEADLINE_AT" ] && [ "$(remaining_seconds)" -le 0 ]; then
      die_hop 29 "budget exhausted — the ${DEADLINE}s deadline expired during hop $hop and actor '$before_turn' was terminated. THIS IS NOT COMPLETION."$'\n'"A killed actor carries the same partial-effect risk as an interruption: it is NOT retried."$'\n'"Recoverable next action: read $STATE_FILE and \`git -C $CHECKOUT status\` to see what the hop completed, then re-run this dispatcher."
    fi
    die_hop 21 "actor '$before_turn' exceeded ${eff_timeout}s and was killed (hop $hop)"
  fi

  # A crash BEFORE the actor changed anything is retried exactly once, from what
  # the repository says rather than from anything this process remembers. "Before
  # edits" is proven, not assumed: the state file, HEAD, the foreign working tree
  # and the state file's committed-ness must all be byte-for-byte where they were.
  # Any doubt and this is a partial side effect, which stops (rc 20 / 25) instead.
  # One retry only — a second failure is a real failure, not a transient one.
  if [ "$rc" -ne 0 ]; then
    now_dirty=0; state_dirty && now_dirty=1
    if [ "$(file_hash "$STATE_FILE")" = "$before_hash" ] \
       && [ "$(git_head)" = "$before_head" ] \
       && [ "$(foreign_worktree)" = "$before_foreign" ] \
       && [ "$now_dirty" -eq "$before_dirty" ]; then
      # The retry is a launch like any other, so it obeys the same clock. Without
      # re-clamping, a hop that failed at minute 39 would get a fresh full-length
      # timeout and walk straight through the deadline.
      if [ -n "$DEADLINE_AT" ] && [ "$(remaining_seconds)" -le 0 ]; then
        die_hop 29 "budget exhausted — the ${DEADLINE}s deadline expired before hop $hop could be retried. THIS IS NOT COMPLETION."$'\n'"The repository was unchanged by the failed attempt, so re-running this dispatcher resumes cleanly from $STATE_FILE."
      fi
      eff_timeout="$(effective_timeout)"
      say "  exit=$rc after ${duration}s, and the repository is unchanged (state sha256, HEAD, working tree, committed-ness all identical) — retrying this hop once."
      started="$(date '+%s')"
      launch_actor "$before_turn" "${hop}r" "$eff_timeout"   # separate .out — the first attempt's output is evidence
      rc=$?
      duration=$(( $(date '+%s') - started ))
      if [ "$rc" -eq 124 ]; then
        if [ -n "$DEADLINE_AT" ] && [ "$(remaining_seconds)" -le 0 ]; then
          die_hop 29 "budget exhausted — the ${DEADLINE}s deadline expired during the retry of hop $hop and actor '$before_turn' was terminated. THIS IS NOT COMPLETION."$'\n'"Not retried again. Recoverable next action: read $STATE_FILE and \`git -C $CHECKOUT status\`, then re-run this dispatcher."
        fi
        die_hop 21 "actor '$before_turn' exceeded ${eff_timeout}s and was killed on the retry (hop $hop)"
      fi
      [ "$rc" -eq 0 ] && say "  retry succeeded"
    else
      die_hop 20 "actor '$before_turn' exited $rc after ${duration}s (hop $hop) AFTER changing the repository — not retried, because a retry would run over a partial effect; see $LOG_DIR/$RUN_ID.hop$hop.$before_turn.out"
    fi
  fi

  if [ "$rc" -ne 0 ]; then
    die_hop 20 "actor '$before_turn' exited $rc after ${duration}s (hop $hop), and the retry failed too; see $LOG_DIR/$RUN_ID.hop$hop.$before_turn.out"
  fi
  say "  exit=0 duration=${duration}s"

  # Re-read the same file from disk. In-memory turn is never trusted.
  validate_state
  after_hash="$(file_hash "$STATE_FILE")"
  after_turn="$ST_TURN"
  after_head="$(git_head)"
  after_foreign="$(foreign_worktree)"
  say "  after:  sha256=$after_hash turn=$after_turn head=$after_head"

  if [ "$before_foreign" != "$after_foreign" ]; then
    say "  foreign worktree delta:"
    diff <(printf '%s\n' "$before_foreign") <(printf '%s\n' "$after_foreign") | sed 's/^/    /' | tee -a "$RUN_LOG"
    die_hop 24 "actor '$before_turn' changed paths outside the allowlist (hop $hop)"
  fi

  if [ "$before_turn" = "codex" ] && [ "$before_head" != "$after_head" ]; then
    die_hop 24 "Codex moved HEAD ($before_head -> $after_head) — Codex never runs git (core § 4)"
  fi

  # What the actor COMMITTED, checked against the same allowlist as the working
  # tree. Ordered after the Codex-HEAD guard so a Codex hop that moved HEAD is
  # reported as the protocol violation it is, rather than as a path problem.
  if [ "$before_head" != "$after_head" ]; then
    committed_bad="$(committed_foreign "$before_head" "$after_head")"
    if [ -n "$committed_bad" ]; then
      say "  committed paths outside the allowlist:"
      printf '%s\n' "$committed_bad" | sed 's/^/    /' | tee -a "$RUN_LOG"
      die_hop 30 "actor '$before_turn' COMMITTED paths outside the allowlist (hop $hop, $before_head -> $after_head)."$'\n'"The commit already exists — this stops the run rather than letting it compound over later hops."$'\n'"Recoverable next action: inspect with \`git -C $CHECKOUT diff $before_head $after_head\`. If the work is wanted, widen --allow-path and re-run; if it is not, revert or reset those commits first."
    fi
    say "  committed: $(git -C "$CHECKOUT" rev-list --count "$before_head".."$after_head" 2>/dev/null) commit(s), all within the allowlist"
  fi

  # O3 — a permission dead end becomes a named stop.
  #
  # ORDER MATTERS, and this is why it sits here. It comes AFTER the
  # out-of-allowlist guards (24, 30): those are repository-integrity violations
  # and they win, because a run that both escaped its allowlist and hit a denial
  # has the escape as the more serious fact. It comes BEFORE 25/36/22: those are
  # the codes a denial was being MISREPORTED as, so reaching them first would
  # reproduce the defect this outcome exists to remove.
  #
  # Claude only: `permission_denials` is a Claude Code result field. Codex's
  # --json stream has no equivalent, and probing it for one would be inventing a
  # contract rather than reading one.
  if [ "$before_turn" = "claude" ] && [ -n "$LAST_CAPTURE" ]; then
    denials="$(permission_denials_in "$LAST_CAPTURE")"
    if [ -n "$denials" ]; then
      say "  permission denials reported by the child:"
      printf '%s\n' "$denials" | sed 's/^/    /' | tee -a "$RUN_LOG"
      die_hop 35 "Claude was DENIED PERMISSION during hop $hop and could not complete the turn."$'\n'"Denied (tool :: target):"$'\n'"$denials"$'\n'"The denial happened at the CHILD's permission layer, not here — this dispatcher requested nothing that would have refused these. The child exits 0 when this happens, which is why it used to surface as exit 25 or 22 with no cause named."$'\n'"NOT retried: the same denial would recur."$'\n'"Operator decision required — this is a capability question, not a transport failure. Either grant the capability deliberately and re-run, or narrow the unit so it does not need it. Full capture: $LAST_CAPTURE"
    fi
  fi

  if [ "$before_turn" = "claude" ] && state_dirty; then
    # THE SPLIT (U2 item 2). "The state file is dirty" was the whole test, and
    # it does not distinguish the two situations underneath it:
    #
    #   Claude edited it and could not commit    -> 25, a partial edit to inspect
    #   it was ALREADY dirty and never changed   -> 36, no state transition
    #
    # On 2026-08-10 the dispatcher reported the second as the first: it said
    # "Claude edited the state file" about a file that was byte-identical before
    # and after, and had been dirty before the hop even launched. before_dirty
    # was already being computed here — it was just never consulted outside the
    # crash-retry guard, so the evidence that would have settled it was in a
    # variable the classification did not read.
    #
    # 36 requires BOTH halves: dirty before launch AND byte-identical after. If
    # the bytes moved at all, Claude wrote to it and 25 is the honest answer even
    # if it was also dirty beforehand.
    if [ "$before_dirty" -eq 1 ] && [ "$after_hash" = "$before_hash" ]; then
      die_hop 36 "the state file logs/work-loop/$TASK.md is uncommitted, and CLAUDE DID NOT TOUCH IT this hop (hop $hop)."$'\n'"Evidence: it was already uncommitted before the actor launched, and its sha256 is byte-identical after ($before_hash). This is NOT a partial edit by Claude — earlier versions of this dispatcher reported exactly this case as 'Claude edited it', which was false."$'\n'"The hop made no state transition. That does not prove it made no other allowed-file edits; any such work is listed below under PARTIAL FILE EFFECTS."$'\n'"Addressed to the OPERATOR, not to Codex: Codex never runs git (core § 4), so 'commit it' is not an instruction Codex can act on."$'\n'"Recoverable next action: read \`git -C $CHECKOUT diff -- logs/work-loop/$TASK.md\` and decide whose work it is. If it is a finished handoff, commit it and re-run this dispatcher. If it is debris, discard it and re-run. Also read the hop capture at ${LAST_CAPTURE:-<none>} to find out why the state transition did not happen."
    fi
    # One live cause, measured 2026-08-05: the child was refused permission to run
    # git, so it edited the file and could not commit it. The stop is correct; the
    # message has to be actionable, because "inspect" alone is not a next action.
    # (If that denial is in the capture, exit 35 above named it before reaching
    # here. 25 is now the case where the commit failed for some OTHER reason.)
    die_hop 25 "Claude edited logs/work-loop/$TASK.md but left it uncommitted (hop $hop) — stopping rather than relaunching over a partial edit. A refused git permission looks exactly like this."$'\n'"Addressed to the OPERATOR, not to Codex: Codex never runs git (core § 4), so committing is not something Codex can do on reading this."$'\n'"Recoverable next action: read \`git diff -- logs/work-loop/$TASK.md\` and check the hop capture at ${LAST_CAPTURE:-<none>} for a permission denial. If the edit is complete, commit it and re-run this dispatcher; if it is partial, discard it and re-run."
  fi

  if [ "$after_hash" = "$before_hash" ]; then
    die_hop 22 "actor '$before_turn' exited cleanly but left the state file byte-identical (hop $hop) — no observable transition"
  fi
  if [ "$after_turn" = "$before_turn" ]; then
    die_hop 22 "actor '$before_turn' edited the file but left turn: '$after_turn' unchanged (hop $hop) — not an allowed transition"
  fi

  case "$before_turn:$after_turn" in
    codex:claude|codex:operator|claude:codex|claude:operator)
      say "  transition: $before_turn -> $after_turn (allowed)" ;;
    *)
      die_hop 22 "transition $before_turn -> $after_turn is not allowed" ;;
  esac

  # The hop is over and no actor is in flight. A signal arriving from here until
  # the next launch reports "between hops" and has no process group to terminate.
  CUR_ACTOR=""

  # Courier mode's terminal condition. It sits AFTER every post-hop check above —
  # the allowlist delta, the Codex-HEAD guard, the uncommitted-handback guard, the
  # byte-identical and unchanged-turn guards, and the transition table — so a carry
  # succeeds on exactly the evidence a full loop would have required to continue.
  # Stopping earlier would make --carry-one a weaker check rather than a shorter run,
  # which is the one thing it must not be.
  #
  # Why exit here rather than let the hop limit end it: MAX_HOPS is pinned to 1 in
  # carry-one mode, so the next pass would die 23 HOP_LIMIT — a failure code for the
  # expected outcome, unusable as a courier's success signal. That defect is the
  # reason this mode exists.
  if [ "$CARRY_ONE" -eq 1 ]; then
    say ""
    say "carry-one: the turn moved $before_turn -> $after_turn. One hop carried; not continuing to '$after_turn'."
    if [ "$after_turn" = "operator" ]; then
      say "carry-one: turn is now operator — automation is terminal there (core § 7)."
    fi
    say "carry-one: read turn: from $STATE_FILE. Neither this exit code nor any screen is authoritative over the file (core § 4)."
    release_lock
    exit 0
  fi
done
