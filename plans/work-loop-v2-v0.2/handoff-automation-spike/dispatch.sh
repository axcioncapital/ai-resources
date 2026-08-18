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
#                       DEFAULT: none. That is the OPERATOR's set being empty —
#                       it does NOT mean nothing is denied. Every attended launch
#                       already denies the four NESTED_ACTOR_DENY rules, and
#                       --unattended already carries UNATTENDED_BASE_DENY; this
#                       flag appends to whichever applies and can remove neither.
#                       Beyond those, the child's own policy applies.
#                       This is plumbing, not a
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
#   11  BAD_CHECKOUT           also the LEASE-INFRASTRUCTURE outcome: an
#                              unresolvable or unreadable Git common directory,
#                              an uncreatable lease root, and a checkout whose
#                              shared lease library (logs/scripts/work-loop-lease.sh)
#                              is missing or unreadable. That last one FAILS
#                              CLOSED and launches nothing — an absent lease is
#                              not a taken lease. It is 11 and not 33/34/35
#                              because those three are the OWNERSHIP taxonomy and
#                              a lease is not an ownership fact; the two are kept
#                              apart deliberately.
#   12  BAD_TASK_ID            traversal or illegal characters
#   13  STATE_MISSING
#   14  IDENTITY_MISMATCH      filename stem != frontmatter task:
#   15  BAD_TURN               turn: not in {codex, claude, operator}
#   16  FOREIGN_STAGED         something already staged; refuse to sweep it in
#   17  LOCK_HELD              another Work Loop run holds this task, or is
#                              already running in this checkout. TWO locks are
#                              checked, both under the repository's Git common
#                              directory: one keyed by task, one keyed by
#                              checkout. Either one being held refuses the run,
#                              and the message names the conflicting task or
#                              checkout AND which program holds it — the lease is
#                              shared with the attended carrier, so the holder is
#                              not necessarily another dispatcher.
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
#                              (32 is also a gap, retired at Tracer bullet 4
#                              with the legacy session-identity init. See the
#                              RETIRED block below. Do not reuse either number.)
#   38  TERMINAL_UNPROVABLE    the run reached a real operator terminal — CLOSED or
#                              BLOCKED_OPERATOR — but its terminal result could not
#                              be finalized, so there is no durable evidence of the
#                              outcome. Deliberately NOT 26: that one says the state
#                              file is malformed and sends the operator to repair
#                              it, which is the wrong instrument here — the state
#                              file is fine and the WRITE is what failed. A run that
#                              cannot prove how it ended must not exit 0 saying it
#                              ended well, which is the whole reason this code
#                              exists rather than a silent success. Both run leases
#                              are RETAINED on this exit — pinned with the cause
#                              recorded inside them — so a second dispatcher is
#                              refused (exit 17) until the operator clears them.
#   33  OWNERSHIP_REFUSED      logs/scripts/work-loop-owner.sh refused this task
#                              in this checkout: either the checkout is claimed
#                              by a different open task, or this task is claimed
#                              by a different checkout. Distinct from 17 because
#                              the remedy differs — 17 means "wait", 33 means
#                              "you are in the wrong checkout". NOTHING launches,
#                              so nothing is committed. A checkout without the
#                              helper is 35, not this — the two are separated
#                              because "a conflict was found" and "no check ran"
#                              are different facts with different remedies.
#   34  OWNERSHIP_AMBIGUOUS    ownership cannot be established: the task's state
#                              file is replicated across checkouts with no
#                              declaration, or a declaration is unreadable or
#                              holds more than one id. Deliberately NOT resolved
#                              by guessing — the checkout contacted first must
#                              never claim a replicated open task. The operator
#                              names the owner. NOTHING launches.
#   35  OWNERSHIP_UNAVAILABLE  the ownership check could not be run at all:
#                              logs/scripts/work-loop-owner.sh is missing,
#                              unreadable, or exited with something other than
#                              0/3/4. NOTHING launches. This FAILS CLOSED on
#                              purpose — an absent check is not a passed check,
#                              and the checkouts most likely to lack the helper
#                              (older siblings, partial copies) are the ones
#                              most likely to hold a conflicting writer.
#                              Distinct from 33/34, which mean a check DID run:
#                              the remedy here is to install or repair the
#                              helper, not to move checkout.
#
#   (33, 34 and 35 are RESERVED and unused here. The concurrent branch
#    session/2026-08-11-work-loop-ceremony claims them for OWNERSHIP_REFUSED,
#    OWNERSHIP_AMBIGUOUS and OWNERSHIP_UNAVAILABLE. This bounded-execution work
#    was implemented alongside that branch and stepped over the block rather than
#    colliding with it. It originally skipped only 33/34 and took 35 for
#    PERMISSION_DENIED; that branch then also claimed 35, and the collision was
#    caught at merge on 2026-08-11 — PERMISSION_DENIED moved 35 -> 37 here,
#    because the ownership codes landed on main first. Run evidence recorded
#    before that date names 35 for a permission stop; read it as 37.)
#
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
#   37  PERMISSION_DENIED      the Claude hop's own JSON capture reports one or
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

# DECLARED HERE, NOT ONLY WHERE IT IS COMPOSED (Unit 25). The run-evidence block
# assigns RUN_ID and RUN_LOG on two ADJACENT lines, and from Unit 25 the signal
# handler publishes as soon as RUN_ID exists — so a signal landing in the one
# statement between them would reach finalize_terminal_result(), which reads
# `$RUN_LOG` unguarded, with the name never assigned. Under `set -u` that is not
# an empty field but an immediate shell exit carrying neither 28 nor a record.
# The window is one assignment wide and it is real; an empty default closes it
# without adding a guard anyone downstream has to remember.
RUN_LOG=""

# The allowlisted working-tree snapshot taken immediately before the most recent
# actor launch. Once set, it remains the comparison point until the next launch,
# so a post-hop guard (including a malformed state file or hop limit) can still
# report only effects attributable to that launched hop.
HOP_BASELINE_READY=0
HOP_ALLOWED_SNAPSHOT=""

# Was a child process for an actor ever actually FORKED in this run? Set in
# run_bounded(), the one place a process is started, and never inferred from an
# intent flag.
#
# HOP_BASELINE_READY was doing this job and cannot: it is raised immediately
# BEFORE launch_actor(), and launch_actor() carries four die() paths of its own
# that run before any fork — a non-executable codex binary, an unresolvable
# claude binary, a checkout it cannot enter, an unrecognised actor name. Every
# one of those reported a launch, and in live mode a model request, that never
# happened. A terminal result that says a model ran when none did is the exact
# false statement the trusted-field contract exists to remove.
#
# MONOTONIC, deliberately. It answers "did an actor process run at some point in
# this run", which is what a reader of a terminal record needs: a hop-2 pre-fork
# stop after a completed hop 1 really did launch an actor, and resetting per
# attempt would deny it — the mirror-image falsehood.
ACTOR_PROCESS_STARTED=0

# WHICH actor the most recent fork was for. The companion to the flag above, and
# deliberately NOT monotonic with it: the flag answers "did any actor ever run in
# this run", this answers "which actor is the launch THIS terminal relates to".
#
# WHY IT EXISTS AT ALL. `permission_mode_requested` used to read CUR_ACTOR, which
# names the actor IN FLIGHT and is cleared the moment a hop is over. Every failure
# terminal finalizes above that clear and reported the requested mode correctly;
# the successful carry-one terminal finalizes below it and reported `none` — "no
# mode was requested" about a launch whose argv carried --permission-mode default.
# The in-flight reading is right for `actor` and for the signal handler, which may
# only name a process that is actually terminable; it is wrong for a durable fact
# about the launch. Two questions, so two variables.
#
# CLEARED ON ENTRY TO launch_actor(), SET AT THE FORK. Both halves are
# load-bearing and neither is redundant. Setting it at the fork is what keeps a
# launch that died on its binary from claiming a mode no child ever received;
# clearing it on entry is what keeps the PREVIOUS hop's fork from answering for
# this one. ACTOR_PROCESS_STARTED alone cannot do either job — it is 1 for the
# rest of the run after the first fork, so from hop 2 onward it stops
# distinguishing a launch that happened from one that did not.
LAUNCHED_ACTOR=""

# The ownership admission verdict, recorded where that check actually runs so a
# terminal reports what was OBSERVED rather than what the code's ordering
# implies. `unchecked` is the honest value for a terminal reached before the
# check — validate_state() dies above it — and it is NOT a synonym for
# `unavailable`, which is reserved for the check being unrunnable.
OWNER_STATUS=unchecked

# The log directory's path relative to the checkout, when it sits inside one.
# Set where the allowlist is extended to cover it, and read by allowlisted_dirty()
# so the dispatcher's own evidence is not reported back as the actor's work (O2).
LOG_REL=""

# --------------------------------------------------- terminal result (set A)
#
# ONE bounded, versioned, run-bound, machine-readable record per terminal stop,
# finalized atomically before the lease is released. Plan § 5 Change set A,
# required behaviour items 2, 3 and 4, and the durable-ordering rule that a lease
# is released only after the terminal result exists.
#
# WHAT THIS COVERS TODAY, and the boundary is the point. This producer hangs off
# die(), which is the shared funnel for the nine post-admission nonzero families
# (missing runtime/auth, invalid state/identity/turn, ownership, the pre-hop
# repository guards, shutdown/hop-limit, actor failure/timeout/budget, unexpected
# effect/commit, permission denial, and missing-handback/no-transition). It does
# NOT cover the families that exit by another route: usage and argument refusal
# and checkout/lease-infrastructure failure exit directly before a run id exists;
# on_signal() exits on its own
# path; and the five zero-exit sites are not this producer's terminals. Wiring
# those is separate work with its own evidence — quietly extending the funnel here
# would claim coverage that has not been proven.
#
# THE FIELDS ARE THE DISPATCHER'S, NOT THE ACTOR'S. Every value below comes from
# a variable this script assigned from its own observation of the process, the
# repository or the lease, or from a constant defined here. No actor prose, no raw
# capture content, and no line of the STOP message is copied into the record: the
# human wording lives in the run log, which the record names. An actor that writes
# a lookalike file cannot supply the framing, because finalization happens after
# the actor is gone and replaces whatever is at the run-bound path.
#
# A FACT THAT IS NOT ESTABLISHED IS STATED, NEVER OMITTED AND NEVER GUESSED. Two
# bounded tokens carry that, and they are not synonyms:
#   unavailable — this dispatcher cannot establish the fact at this terminal
#   none        — the fact is established, and it is absent
# So a pre-hop stop reports state_sha256_after=unavailable (no hop ran to observe
# it) while a run with no --deadline reports deadline_seconds=none (the operator
# asked for none). Reading one as the other would turn "we did not look" into "we
# looked and there was nothing", which is the false statement this whole change
# set exists to remove.
TERMINAL_RESULT_VERSION=1
RESULT_FILE=""
RESULT_FINALIZED=0
# THE FUNNEL'S CONSUMPTION IS ONE-SHOT, and this flag is what makes it so. It is
# a separate fact from RESULT_FINALIZED, which answers "was a record written";
# this answers "has the funnel already checked one". The four terminal seams that
# consume do not set it, and must not: they exit directly and never re-enter
# die(), so nothing they do can be undone by a flag they never read.
RESULT_CONSUMED=0

# Bound one value to a single line. Newlines, carriage returns and tabs become
# spaces and the value is truncated. This is what makes the grammar safe: a path,
# a git status line or an operator-supplied argument cannot inject a second
# key=value pair into the record. Pure parameter expansion, so it is UTF-8 safe —
# a `tr` character-class filter would mangle the non-ASCII that appears in real
# checkout paths.
tr_val() { # value -> one bounded single-line value
  local v="${1-}"
  v="${v//$'\n'/ }"; v="${v//$'\r'/ }"; v="${v//$'\t'/ }"
  printf '%s' "${v:0:512}"
}

tr_kv() { # key value -> one record line
  printf '%s=%s\n' "$1" "$(tr_val "${2-}")"
}

# A value, or the bounded token that says why there is none. Written as a helper
# rather than inline `${x:-unavailable}` so that an empty string can never reach
# the record as an empty value — an absent value and an unavailable fact look
# identical to a reader, and only one of them is honest.
tr_kv_or() { # key value fallback-token
  local v="${2-}"
  [ -n "$v" ] || v="$3"
  tr_kv "$1" "$v"
}

# Exit code -> the symbolic outcome an operator and a later reader both key on.
# A CONSTANT TABLE, mirroring the header's exit-code list. Deliberately not derived
# from the STOP message: the message is prose that interpolates git and child
# output, and reading an outcome out of it would be the prose-authority contract
# plan § 5 forbids.
result_outcome() { # code -> symbol
  case "$1" in
    # CODE 0 IS TWO DIFFERENT ENDS, and the exit code cannot tell them apart
    # because neither is a failure. A task that CLOSED is finished; one that is
    # BLOCKED_OPERATOR has stopped and is waiting for a person. Collapsing them
    # would be the single most misleading thing this table could do — the operator
    # reading two identical records would have no way to know which run still
    # needs them.
    #
    # ST_CLASS, NOT A FRESH READING. validate_state() already asked the canonical
    # validator and set it before the loop began; this reads that decision and
    # never re-derives one from the body, the turn, or anything an actor wrote.
    # Anything else at code 0 falls through to UNCLASSIFIED rather than guessing.
    # WHAT THIS RUN DID, BEFORE WHAT THE TASK IS. A dry-run inspects and launches
    # nothing, so its ending is its own class — and reading the task's lifecycle
    # first made it wear the loop terminals' symbols: a preflight over a closed
    # task reported COMPLETED, one over a blocked task reported OPERATOR_TAKEOVER,
    # and one over an active task fell through to UNCLASSIFIED. Three symbols for
    # one terminal class, two of them belonging to runs that actually finished or
    # were actually handed over.
    #
    # MODE IS DISPATCHER-OWNED and settled at argument parse, so this reads no
    # state, re-derives no lifecycle, and adds no second owner — it is one branch
    # ahead of the existing one. `live` falls through unchanged, which is what
    # keeps the two real loop terminals exactly as accepted.
    #
    # AND A CARRIED HOP IS ITS OWN CLASS TOO, for the same reason one branch on.
    # --carry-one stops after one validated hop BY DESIGN, so reading the task's
    # lifecycle here made it wear three symbols as well: UNCLASSIFIED when it
    # handed on to an active actor, and COMPLETED or OPERATOR_TAKEOVER when it
    # handed on to the operator — the full loop's words for a run that drove the
    # task to its end. Nothing is lost by naming the run instead: `state_class`
    # and `turn_at_terminal` are required fields and carry the lifecycle exactly.
    #
    # BOTH HALVES ARE LOAD-BEARING. `CARRY_ONE` alone is true of a --carry-one
    # invocation over a task that is ALREADY operator-terminal, which carries no
    # hop at all — it stops at the pre-hop operator terminal before any actor
    # starts. `ACTOR_PROCESS_STARTED` is the fork this run really performed, the
    # same fact the record's `stage` is derived from, so the pair says "carrying
    # mode, and a hop actually happened". Ordered AFTER the dry-run branch: a
    # --carry-one --dry-run launches nothing and stays a preflight.
    0)  case "${MODE:-}" in
          dry-run) printf 'DRY_RUN_COMPLETE'; return 0 ;;
        esac
        [ "${CARRY_ONE:-0}" -eq 1 ] && [ "${ACTOR_PROCESS_STARTED:-0}" -eq 1 ] && { printf 'CARRY_ONE_COMPLETE'; return 0; } # carry-one code-zero outcome
        case "${ST_CLASS:-}" in
          CLOSED)           printf 'COMPLETED' ;;
          BLOCKED_OPERATOR) printf 'OPERATOR_TAKEOVER' ;;
          *)                printf 'UNCLASSIFIED' ;;
        esac ;;
    38) printf 'TERMINAL_UNPROVABLE' ;;
    10) printf 'BAD_USAGE' ;;              11) printf 'BAD_CHECKOUT' ;;
    12) printf 'BAD_TASK_ID' ;;            13) printf 'STATE_MISSING' ;;
    14) printf 'IDENTITY_MISMATCH' ;;      15) printf 'BAD_TURN' ;;
    16) printf 'FOREIGN_STAGED' ;;         17) printf 'LOCK_HELD' ;;
    18) printf 'FOREIGN_UNSTAGED' ;;       19) printf 'GIT_HAZARD' ;;
    20) printf 'ACTOR_FAILED' ;;           21) printf 'ACTOR_TIMEOUT' ;;
    22) printf 'NO_TRANSITION' ;;          23) printf 'HOP_LIMIT' ;;
    24) printf 'UNEXPECTED_EFFECT' ;;      25) printf 'UNCOMMITTED_HANDBACK' ;;
    26) printf 'MALFORMED_TERMINAL' ;;     28) printf 'INTERRUPTED' ;;
    29) printf 'BUDGET_EXHAUSTED' ;;       30) printf 'UNEXPECTED_COMMIT' ;;
    31) printf 'UNATTENDED_UNAVAILABLE' ;; 33) printf 'OWNERSHIP_REFUSED' ;;
    34) printf 'OWNERSHIP_AMBIGUOUS' ;;    35) printf 'OWNERSHIP_UNAVAILABLE' ;;
    36) printf 'STATE_UNCHANGED_HANDBACK' ;; 37) printf 'PERMISSION_DENIED' ;;
    *)  printf 'UNCLASSIFIED' ;;
  esac
}

# Exit code -> the next required action, as a bounded token. Same argument as
# above: the operator's recoverable-next-action sentences stay in the STOP message
# and the run log, and this is the machine-readable summary of them. A reader that
# needs the wording reads the run log the record names.
result_next_action() { # code -> token
  case "$1" in
    # Split for the same reason the outcome above is: "you have nothing to do" and
    # "this is waiting on you" are opposite instructions, and code 0 alone cannot
    # carry the difference.
    # Mode first, for the same reason and in the same shape as the outcome above.
    # The misdirection here was the sharper half: a dry-run over a closed task
    # told the operator "none — task closed" about a run whose entire point was
    # to preview a launch, and one over an active task sent them to read a log
    # that says the preflight passed. Neither is the action a completed preflight
    # actually calls for, which is none.
    # A carried hop, same condition and same position as the outcome above — but
    # NOT one collapsed token, and that asymmetry is deliberate. The outcome names
    # one terminal class; the next action is an instruction, and the instruction
    # genuinely differs. Handing on to an actor needs that actor NAMED, which is
    # what the courier does next. Handing on to the operator keeps the two
    # accepted tokens verbatim, because "the task is closed" and "a person owes an
    # answer" are exactly what a full loop would say and are the distinction code
    # 0 was split to protect — a single completion token would re-hide the
    # unanswered question. So only the two active classes branch here; CLOSED and
    # BLOCKED_OPERATOR fall through to the lifecycle case below, unchanged.
    0)  case "${MODE:-}" in
          dry-run) printf 'none-dry-run-preflight-complete'; return 0 ;;
        esac
        [ "${CARRY_ONE:-0}" -eq 1 ] && [ "${ACTOR_PROCESS_STARTED:-0}" -eq 1 ] && case "${ST_CLASS:-}" in ACTIVE_CLAUDE) printf 'operator-carry-turn-to-claude'; return 0 ;; ACTIVE_CODEX) printf 'operator-carry-turn-to-codex'; return 0 ;; esac # carry-one code-zero next action
        case "${ST_CLASS:-}" in
          CLOSED)           printf 'none-task-closed' ;;
          BLOCKED_OPERATOR) printf 'operator-answer-the-blocking-question' ;;
          *)                printf 'operator-read-run-log' ;;
        esac ;;
    38)          printf 'operator-inspect-run-log-terminal-not-finalized' ;;
    10|11|12)    printf 'operator-correct-invocation' ;;
    13|14|15|26) printf 'operator-repair-state-file-then-rerun' ;;
    16|18|19)    printf 'operator-clean-checkout-then-rerun' ;;
    17)          printf 'wait-for-lease-holder' ;;
    20|21)       printf 'operator-inspect-hop-capture-then-decide-rerun' ;;
    22)          printf 'operator-inspect-state-file-no-transition' ;;
    23)          printf 'operator-decide-whether-to-continue-with-more-hops' ;;
    24|30)       printf 'operator-inspect-out-of-allowlist-effects' ;;
    25|36)       printf 'operator-resolve-uncommitted-state-file' ;;
    28)          printf 'operator-inspect-after-interruption' ;;
    29)          printf 'operator-rerun-with-larger-budget' ;;
    31)          printf 'operator-restore-contained-profile-prerequisites' ;;
    33|34|35)    printf 'operator-resolve-ownership' ;;
    37)          printf 'operator-decide-capability-grant' ;;
    *)           printf 'operator-read-run-log' ;;
  esac
}

# The permission mode this dispatcher REQUESTED for the launch this terminal
# relates to. It is a constant of the launch path, read back here rather than
# stored at launch, because no variable holds it — the attended Claude branch
# passes the literal `--permission-mode default`.
#
# THE EFFECTIVE MODE IS NEVER DERIVED FROM THIS. Only the child's own system/init
# event establishes what it actually ran under, and nothing in this dispatcher
# reads it, so permission_mode_effective is unconditionally `unavailable` below.
# Promoting a requested property to an effective one is the single most tempting
# false statement available here, and recording the request is evidence reporting
# — not authorization, and not Change set B's transport work.
# GATED ON THE OBSERVED FORK, not on the baseline flag. A mode is only requested
# by an argv that was actually handed to a child; a run that stopped on an
# unresolvable binary requested nothing, and reporting `default` there would be
# the same false-launch claim actor_launched carried.
#
# THE ACTOR GUARD READS LAUNCHED_ACTOR, NOT CUR_ACTOR, and the difference is the
# whole of Unit 19. CUR_ACTOR names the actor IN FLIGHT, so it is empty at every
# terminal that finalizes after the hop-over clear — which is exactly the
# successful carry-one terminal, the one outcome a courier exists to produce. It
# reported `none` there: no mode requested, about a launch whose argv carried
# --permission-mode default. LAUNCHED_ACTOR is the durable fact about the launch
# instead of the liveness fact about the process, so the answer no longer depends
# on whether the child happens to still be running when the record is written.
# `actor` still reports CUR_ACTOR and the signal handler still reads it: the
# in-flight reading is correct for both, and neither is touched here.
result_permission_mode_requested() {
  [ "$ACTOR_PROCESS_STARTED" -eq 1 ] || { printf 'none'; return 0; }
  [ "$MODE" = "live" ] || { printf 'none'; return 0; }
  [ "${LAUNCHED_ACTOR:-}" = "claude" ] || { printf 'none'; return 0; }
  # The contained profile deliberately carries no permission mode of its own.
  [ "$UNATTENDED" -eq 1 ] && { printf 'none'; return 0; }
  printf 'default'
}

# Count lines without letting an empty string count as one. `grep -c .` rather
# than `wc -l`, which reports 1 for a single empty line.
count_lines() { printf '%s\n' "${1-}" | grep -c . || true; }

# The checkout's open-task declaration, as one bounded token. Read-only.
#
# ONE READER FOR TWO CONSUMERS — the --status branch and the terminal record —
# because the same awk written out twice is exactly the drift plan § 8 forbids,
# and the record must report the same declaration an operator is shown.
#
# The three answers are distinct facts, not shades of one: a task id is a
# declaration that exists, `none` is a checkout that declares nobody (established
# and absent), `unavailable` is a declaration this dispatcher could not read.
owner_declaration() { # -> declared task id | none | unavailable
  local f line
  [ -n "${CHECKOUT:-}" ] || { printf 'unavailable'; return 0; }
  f="$CHECKOUT/logs/work-loop/.owner"
  [ -e "$f" ] || { printf 'none'; return 0; }
  [ -f "$f" ] && [ -r "$f" ] || { printf 'unavailable'; return 0; }
  line="$(awk 'NF {print; exit}' "$f" 2>/dev/null)"
  if [ -n "$line" ]; then printf '%s' "$line"; else printf 'unavailable'; fi
}

# The lease this run stands on, as OBSERVED at finalization.
#
# die() finalizes before release_lock, so `held-by-this-run` is the answer this
# ordering predicts — and a predicted answer written as a constant is not
# evidence. The field said `held` unconditionally, which would have kept saying
# `held` for a lease that had been pinned by a teardown, reclaimed by another
# run, or never taken at all. The point of the field is to record which of those
# is true at the moment the record is written.
#
# The holder globals are saved and restored around the library's own reader,
# which is the single reader of a lease directory's metadata (plan § 8).
# Finalization runs after the refusal and pin wording is already composed, so
# nothing downstream reads them today; a reporting function that silently
# rewrote shared state would still be a trap set for the next edit.
result_lease_status() { # lease-dir owned-flag -> one bounded token
  local dir="${1:-}" owned="${2:-0}" pid s_pid s_task s_co s_prog
  [ -n "$dir" ] && [ -n "${WL_LEASE_ROOT:-}" ] || { printf 'unavailable'; return 0; }
  if [ ! -d "$dir" ]; then
    # `missing` and `free` are different findings: the first is a lease this run
    # believes it holds and the filesystem does not have, which is a fault worth
    # seeing; the second is an honest absence.
    if [ "$owned" -eq 1 ]; then printf 'missing'; else printf 'free'; fi
    return 0
  fi
  [ -f "$dir/survivors" ] && { printf 'pinned'; return 0; }
  s_pid="${WL_LEASE_HOLDER_PID:-}";      s_task="${WL_LEASE_HOLDER_TASK:-}"
  s_co="${WL_LEASE_HOLDER_CHECKOUT:-}";  s_prog="${WL_LEASE_HOLDER_PROGRAM:-}"
  wl_lease__read_holder "$dir"
  pid="${WL_LEASE_HOLDER_PID:-}"
  WL_LEASE_HOLDER_PID="$s_pid";          WL_LEASE_HOLDER_TASK="$s_task"
  WL_LEASE_HOLDER_CHECKOUT="$s_co";      WL_LEASE_HOLDER_PROGRAM="$s_prog"
  # AN UNESTABLISHED HOLDER IS NOT ANOTHER HOLDER. wl_lease__read_holder() `cat`s
  # the four metadata files and returns empty for any it cannot read, so an
  # absent, unreadable or empty pid file arrives here indistinguishable from a
  # pid that simply is not ours — and falling through would report `held-by-other`,
  # which asserts a second holder nothing observed. The lease directory's
  # existence IS established, so this is not `free` either: what is unavailable is
  # who holds it. Checked before the ownership comparison, unconditionally: a run
  # that believes it owns the lease still cannot read a holder record that is gone.
  if [ -z "$pid" ]; then printf 'held-holder-unavailable'; return 0; fi
  if [ "$owned" -eq 1 ] && [ "$pid" = "$$" ]; then printf 'held-by-this-run'; return 0; fi
  printf 'held-by-other'
}

finalize_terminal_result() { # code -> 0 when a complete record exists
  [ "$RESULT_FINALIZED" -eq 1 ] && return 0
  # No run identity means this terminal is outside the covered funnel — an
  # argument refusal or a lease-infrastructure failure. Those exit directly and
  # never reach here; the guard is what keeps that true if a later edit moves a
  # die() above the run-evidence block.
  [ -n "${RUN_ID:-}" ] && [ -n "${LOG_DIR:-}" ] || return 1

  local code="$1"
  local final="$LOG_DIR/$RUN_ID.result"
  local tmp="$final.partial"
  RESULT_FILE="$final"

  # OBSERVED, NOT IMPLIED. `launched` is the fork run_bounded() actually
  # performed, and `stage` names which of three places this terminal sits in:
  #   pre-hop   no hop baseline yet — nothing was ever about to launch
  #   launch    the baseline is live but no child was forked; launch_actor()
  #             stopped on the binary, the checkout or the actor name
  #   post-hop  an actor process really ran in this run
  # The middle value is what this correction added: it used to be reported as
  # post-hop with actor_launched=yes, which is a launch that did not happen.
  local launched=no started=no stage=pre-hop
  if [ "$ACTOR_PROCESS_STARTED" -eq 1 ]; then
    launched=yes; stage=post-hop
    # A simulated actor is not a model request, and saying it was would falsify
    # exactly the field a supervised-use claim rests on.
    #
    # A LIVE FORK IS NOT ONE EITHER, and this is the second half of the same
    # correction. Forking the product's CLI is not evidence that the CLI went on
    # to issue a model request: whether it did is in the child's own stream
    # events, and nothing in this dispatcher reads them (the reader is deferred,
    # and reading the capture for framing is forbidden here anyway). So the live
    # answer is the bounded unavailable token. `yes` would be the same guess this
    # correction just removed from actor_launched, one field over.
    [ "$MODE" = "live" ] && started=unavailable
  elif [ "${HOP_BASELINE_READY:-0}" -eq 1 ]; then
    stage=launch
  fi

  local foreign_n dirty_n delta_n
  foreign_n="$(count_lines "$(foreign_worktree)")"
  dirty_n="$(count_lines "$(allowlisted_dirty)")"
  if [ "${HOP_BASELINE_READY:-0}" -eq 1 ]; then
    delta_n="$(count_lines "$(partial_effect_paths)")"
  else
    delta_n=unavailable
  fi

  local remaining=none
  [ -n "${DEADLINE_AT:-}" ] && remaining="$(remaining_seconds)"

  # Read once, on their own lines, before the record block. Two reasons, and the
  # second is the load-bearing one: the ownership and lease observations are what
  # a mutation control has to be able to replace with a constant to prove they
  # are not one already, and a control cannot address half of a wrapped line.
  local owner_decl lease_task lease_checkout
  owner_decl="$(owner_declaration)"
  lease_task="$(result_lease_status "${LOCK_DIR:-}" "${WL_LEASE_TASK_OWNED:-0}")"
  lease_checkout="$(result_lease_status "${CHECKOUT_LOCK_DIR:-}" "${WL_LEASE_CHECKOUT_OWNED:-0}")"

  # Written to a temporary in the SAME directory and renamed. rename(2) within one
  # filesystem is atomic, so a reader sees the complete record or no record at all
  # — never the half-written one a direct `>` would expose. The sentinel last line
  # is the second, independent handle on that: a record whose final line is
  # missing was not finalized by this function.
  {
    tr_kv terminal_result_version "$TERMINAL_RESULT_VERSION"
    tr_kv schema                  work-loop-v2-dispatcher-terminal-result
    tr_kv outcome                 "$(result_outcome "$code")"
    tr_kv code                    "$code"
    tr_kv task                    "$TASK"
    tr_kv checkout                "$CHECKOUT"
    tr_kv run                     "$RUN_ID"
    tr_kv mode                    "$MODE"
    tr_kv stage                   "$stage"
    tr_kv_or actor                "${CUR_ACTOR:-}" none
    tr_kv actor_launched          "$launched"
    tr_kv model_request_started   "$started"
    tr_kv hop                     "${CUR_HOP:-0}"
    tr_kv max_hops                "$MAX_HOPS"
    tr_kv state_file              "$STATE_FILE"
    tr_kv_or turn_at_terminal     "${ST_TURN:-}"    unavailable
    tr_kv_or state_class          "${ST_CLASS:-}"   unavailable
    tr_kv_or state_sha256_before  "${before_hash:-}" unavailable
    tr_kv_or state_sha256_after   "${after_hash:-}"  unavailable
    tr_kv_or head_before          "${before_head:-}" unavailable
    tr_kv_or head_after           "${after_head:-}"  unavailable
    tr_kv worktree_foreign_paths          "$foreign_n"
    tr_kv worktree_allowlisted_dirty_paths "$dirty_n"
    tr_kv changed_paths_since_launch      "$delta_n"
    tr_kv permission_mode_requested "$(result_permission_mode_requested)"
    # Never derived from the requested mode above. See that function's note.
    tr_kv permission_mode_effective unavailable
    tr_kv_or deadline_seconds     "${DEADLINE:-}"   none
    tr_kv deadline_remaining_seconds "$remaining"
    tr_kv actor_timeout_seconds   "$ACTOR_TIMEOUT"
    # Never extracted from any capture by this dispatcher — permission_denials_in()
    # reads only `.permission_denials`. Change set B territory, stated as absent.
    tr_kv recorded_usage          unavailable
    # The legacy session identity was retired at Tracer bullet 4 and nothing
    # replaced it, so there is no identifier to record.
    tr_kv actor_session_id        unavailable
    tr_kv run_log                 "$RUN_LOG"
    tr_kv_or capture              "${LAST_CAPTURE:-}" none
    # WHO OWNS THE TASK and WHO HOLDS THE LEASE are two questions, and both are
    # read from what this dispatcher observed rather than from what the ordering
    # implies. The admission verdict is recorded at the check; the declaration and
    # both lease directories are inspected here, at the moment of writing.
    tr_kv owner_check             "$OWNER_STATUS"
    tr_kv owner_declared          "$owner_decl"
    tr_kv lease_task_dir          "${LOCK_DIR:-}"
    tr_kv lease_checkout_dir      "${CHECKOUT_LOCK_DIR:-}"
    tr_kv lease_task_at_finalization     "$lease_task"
    tr_kv lease_checkout_at_finalization "$lease_checkout"
    tr_kv next_action             "$(result_next_action "$code")"
    tr_kv result_complete         yes
  } >"$tmp" 2>/dev/null || { rm -f "$tmp" 2>/dev/null; RESULT_FILE=""; return 1; }

  mv -f "$tmp" "$final" 2>/dev/null || { rm -f "$tmp" 2>/dev/null; RESULT_FILE=""; return 1; }
  RESULT_FINALIZED=1
  return 0
}

# ------------------------------------- the terminal result's structural reader
#
# ONE PRODUCTION OWNER for reading what finalize_terminal_result() writes, placed
# next to the producer so the pair is edited together. Before this there was no
# reader at all: the harness picked fields out with `sed`, which proved the record
# is consumable but is not the same claim as "this program refuses a record it
# must not trust".
#
# WHAT IT ANSWERS, and only this: is the artifact at this path structurally the
# version 1 record this dispatcher writes? It returns 0 and the token `ok`, or 1
# and exactly one bounded token naming the first structural reason it refused.
#
# WHAT IT DELIBERATELY DOES NOT ANSWER. It says nothing about whether the values
# are TRUE — that the run id is this run's, that the checkout is this checkout,
# that the outcome matches the exit code, that the path was not a symlink planted
# somewhere else. Structure and meaning are separate questions and they are
# separate units; a caller that read a passing verdict as "these facts are mine"
# would have invented exactly the trust the trusted-field-ownership contract
# forbids. Nothing in this dispatcher calls it yet, and that is deliberate: the
# first consumer — which must also settle identity — is its own unit.
#
# REJECT, NEVER NORMALIZE. There is no repair path, no "close enough", no partial
# acceptance. A record this function does not fully recognize is refused whole,
# because a half-accepted terminal result is how a reader ends up reporting a
# field that was never written.
#
# IT NEITHER EXECUTES NOR SOURCES THE ARTIFACT. The content is read as data by
# `read`, never evaluated: an actor that plants a lookalike gets its bytes
# compared, not run. That is why the bounds below exist as well — a reader with
# no size bound is a reader anyone who can write the path can make run for as
# long as they like.
# --- wl2:terminal-result-validator:begin ---
TERMINAL_RESULT_SCHEMA='work-loop-v2-dispatcher-terminal-result'
# Finite, and generous against the real artifact rather than tight against it:
# the producer emits 41 lines whose values `tr_val` already truncates at 512, so
# a record anywhere near these bounds is not one this dispatcher wrote.
TERMINAL_RESULT_MAX_BYTES=65536
TERMINAL_RESULT_MAX_LINES=200
TERMINAL_RESULT_MAX_VALUE=512
# THE COMPLETE v1 SINGLETON SET, in the producer's own order. Two key lists in
# one file is how a reader silently drifts from its writer, so the harness
# compares this set against the keys a real run actually emitted rather than
# against a list it restates — a field added to the producer and not to this line
# fails that assertion rather than passing unnoticed.
TERMINAL_RESULT_REQUIRED='terminal_result_version schema outcome code task checkout run mode stage actor actor_launched model_request_started hop max_hops state_file turn_at_terminal state_class state_sha256_before state_sha256_after head_before head_after worktree_foreign_paths worktree_allowlisted_dirty_paths changed_paths_since_launch permission_mode_requested permission_mode_effective deadline_seconds deadline_remaining_seconds actor_timeout_seconds recorded_usage actor_session_id run_log capture owner_check owner_declared lease_task_dir lease_checkout_dir lease_task_at_finalization lease_checkout_at_finalization next_action result_complete'

# THE THREE IDENTITY FIELDS, captured by the structural pass that already reads
# every line, and consumed by the identity boundary below. Two readers over one
# artifact is how a program comes to disagree with itself about what it read, so
# the record is parsed ONCE and these carry what that parse saw.
#
# `TR_SOURCE` is which artifact they came from, and it is what makes them safe to
# consume: the identity boundary refuses to answer about any other path, so a
# caller cannot validate one record and then ask about a second one.
#
# THEY ARE SET ONLY ON ACCEPTANCE. A rejected record leaves all four empty rather
# than leaving whichever fields were read before the refusal — half a parse is not
# a fact, and an identity check reading one would be comparing against a record
# this dispatcher just refused.
TR_SOURCE=''
TR_TASK=''
TR_CHECKOUT=''
TR_RUN=''
# THE TWO SEMANTIC FIELDS, captured by that SAME single pass and consumed by the
# semantic boundary below. They are held here for one reason: the record is parsed
# once, and a boundary that needed them later would otherwise have to open the
# artifact a second time — two readers over one artifact being the exact failure
# the identity note above records.
#
# CAPTURED IS NOT COMPARED. Holding what the record SAYS its outcome and code are
# settles nothing about whether either is true; that is the semantic boundary's
# question, and it answers it against values the caller established elsewhere.
# Nothing in this file derives an expectation from these two.
TR_OUTCOME=''
TR_CODE=''
# THE SNAPSHOT THE ACCEPTED FIELDS CAME FROM, not merely the pathname they were
# read through. A pathname is not an artifact: a structurally valid record can be
# parsed and then REPLACED at that same path by another structurally valid one,
# and a check that only remembered the name would go on reporting the first
# record's task, checkout and run for the second record's bytes. This is what
# lets identity acceptance be tied to the exact bytes that were validated.
TR_SHA=''
# The device and inode the accepted bytes were read from. `TR_SHA` alone cannot
# separate "still the same file" from "a different file holding identical
# content", and the frozen requirement is content OR file identity — so both are
# pinned, and a byte-identical stand-in is still a replacement.
TR_FID=''
# Which path the pre-read safety gate cleared. The identity boundary refuses to
# compare anything the gate did not pass first — see that function's note on why
# the order is a correctness property and not a convention.
TR_PATH_CLEARED=''
# WHAT THE GATE HAD CLEARED AT THE MOMENT THE PARSE BEGAN, which is a different
# fact from what it has cleared by now, and the difference is the whole point.
# Two globals that merely both ended up naming this artifact would be satisfied by
# parsing first and gating afterwards — bytes read through a path nothing had
# vetted, then retroactively blessed. This one is captured at the top of the parse,
# so it can only name the artifact if the gate genuinely ran first.
TR_PARSE_GATED=''

# Self-contained on purpose: `file_hash()` exists further down this file, but the
# marker-delimited region is lifted out and sourced on its own by the focused
# harness, so a call to anything defined outside these markers would be undefined
# exactly where the region is under test.
wl2_tr_sha() { # path -> the artifact's sha256, or empty when it cannot be taken
  shasum -a 256 "$1" 2>/dev/null | cut -d' ' -f1
}

# WHICH FILE, as distinct from WHICH BYTES. A digest cannot tell one file from a
# different file holding identical content, and "the record was replaced" is true
# in both cases: the promised path is supposed to hold the artifact this run
# wrote, not an indistinguishable stand-in something else put there.
#
# GNU FORM FIRST, DELIBERATELY. BSD `stat -f` takes a format string while GNU
# `stat -f` reports the FILESYSTEM instead, so probing BSD-first would make GNU
# emit confident nonsense rather than fail. GNU `-c` simply errors on BSD, which
# is the unambiguous direction to fall through.
#
# NEITHER FORM DEREFERENCES. Both stat the name itself unless given `-L`, so a
# symlink reports its own identity rather than its target's — which is what lets
# a regular file swapped for a link be seen as the change it is.
wl2_tr_fid() { # path -> "<device>:<inode>", or empty when it cannot be taken
  stat -c '%d:%i' "$1" 2>/dev/null || stat -f '%d:%i' "$1" 2>/dev/null
}

# ------------------------------- the terminal result's PRE-READ path safety gate
#
# THIS RUNS BEFORE A SINGLE BYTE IS OPENED, and that ordering is the whole reason
# it is a separate function. The path checks used to live at the identity boundary,
# which runs after the structural parse — so a planted symlink or a symlinked
# evidence root was opened, sized and read to its end, and only then refused. The
# refusal token was right and the behaviour was wrong: a reader that has already
# followed a hostile path has already done the thing the refusal was for.
#
# IT OPENS NOTHING. `-L` is an lstat on the name and `cd`+`pwd -P` resolves
# directories; neither reads the artifact. That is the property the correction's
# control asserts, and it is why no size bound is needed here.
#
# REFUSE, NEVER NORMALIZE. A traversal segment, a leading dash, or a control
# character is refused outright rather than cleaned up. Deciding what a hostile
# path "really meant" is how a resolved path becomes a trusted one.
validate_terminal_result_path() { # artifact task checkout run evidence-root -> 0 and ok, or 1 and one bounded token
  local f="${1-}" x_task="${2-}" x_checkout="${3-}" x_run="${4-}" x_root="${5-}"
  local v promised real_root real_dir
  TR_PATH_CLEARED=''

  [ -n "$f" ] || { printf 'no-path\n'; return 1; }
  # AN UNSUPPLIED EXPECTATION IS NOT A WILDCARD. A caller that has not established
  # one of the four is refused, never silently matched against whatever the
  # artifact happens to say — which is the one way this gate could be made to
  # clear every path ever presented.
  [ -n "$x_task" ] && [ -n "$x_checkout" ] && [ -n "$x_run" ] && [ -n "$x_root" ] \
    || { printf 'no-expectation\n'; return 1; }

  # Applied to the caller's values as well as the path: a dispatcher variable that
  # has been corrupted is not a safer source than an artifact. The `..` test is
  # deliberately blunt — refusing every occurrence is a rule with no parser in it,
  # and a run id or a checkout path that legitimately contains one does not exist.
  for v in "$f" "$x_task" "$x_checkout" "$x_run" "$x_root"; do
    case "$v" in
      -*)            printf 'unsafe-path\n'; return 1 ;;
      *..*)          printf 'unsafe-path\n'; return 1 ;;
      *[[:cntrl:]]*) printf 'unsafe-path\n'; return 1 ;;
    esac
  done

  # THE PROMISED PATH IS DERIVED, NEVER ACCEPTED. It is built from the admitted
  # evidence root and the expected run id — the same two values the producer used
  # — and the artifact's path must equal it literally. This is also what bounds
  # the artifact to the evidence root: any path outside the root is not equal to
  # a path inside it, so no separate containment test is needed for the literal
  # case. The resolved test below covers the case a link makes it non-literal.
  promised="$x_root/$x_run.result"
  [ "$f" = "$promised" ] || { printf 'path-not-promised\n'; return 1; }

  # A LINK IS NOT THE FILE IT NAMES. The name matches and the target may be a real,
  # structurally valid, field-matching result — which is exactly why this is
  # refused on the name, before anything opens it.
  if [ -L "$f" ]; then printf 'symlinked-path\n'; return 1; fi

  # The literal check above cannot see a root that is itself a link, or an ancestor
  # that is: the strings match while the bytes come from somewhere else entirely.
  real_root="$(cd "$x_root" 2>/dev/null && pwd -P)" || { printf 'outside-evidence-root\n'; return 1; }
  real_dir="$(cd "$(dirname "$f")" 2>/dev/null && pwd -P)" || { printf 'outside-evidence-root\n'; return 1; }
  [ "$real_root" = "$x_root" ] || { printf 'outside-evidence-root\n'; return 1; }
  [ "$real_dir" = "$real_root" ] || { printf 'outside-evidence-root\n'; return 1; }

  TR_PATH_CLEARED="$f"
  printf 'ok\n'
  return 0
}

validate_terminal_result() { # path -> 0 and the ok token, or 1 and one bounded reason token
  local f="${1-}" bytes line key val n=0 seen=' ' last='' k
  local got_task='' got_checkout='' got_run='' sha_before='' sha_after=''
  local got_outcome='' got_code=''
  local fid_before='' fid_after=''
  TR_SOURCE=''; TR_TASK=''; TR_CHECKOUT=''; TR_RUN=''; TR_SHA=''; TR_FID=''
  TR_OUTCOME=''; TR_CODE=''
  # Read, never written, at the first instruction of the parse. TR_PATH_CLEARED
  # belongs to the gate and is deliberately not reset here: clearing it would make
  # this function able to invalidate a gate decision it does not own.
  TR_PARSE_GATED="${TR_PATH_CLEARED:-}"
  [ -n "$f" ]                || { printf 'no-path\n';    return 1; }

  # THE READER DEFENDS ITS OWN READ, and this is the correction's point. Recording
  # what the gate had decided is not the same as acting on it: this function used
  # to copy that decision and then open the artifact anyway, leaving the refusal to
  # an identity check that runs after every byte is already read. A caller that
  # invokes the parser directly — which nothing stops, and which the standalone
  # structural contract positively allows — got the old late-refusal behaviour back
  # in full.
  #
  # `-L` IS AN LSTAT ON THE NAME. It reads nothing, so it can sit ahead of `-f`,
  # which follows links and is therefore already a decision to trust one. This is
  # deliberately NOT delegated to the gate: the gate answers a different question
  # (is this the promised path for an expected identity) and a reader that cannot
  # be called safely on its own is a reader whose safety depends on its callers.
  if [ ! -L "$f" ]; then :; else printf 'symlinked-path\n'; return 1; fi # reader pre-open path refusal
  # A GATE DECISION ABOUT SOME OTHER ARTIFACT IS A STALE CLEARANCE, not a
  # clearance. No gate at all stays allowed — Unit 6's structural validator is
  # callable on its own and case 51 exercises exactly that — but a gate that
  # cleared a different path must not be read as covering this one.
  #
  # ONE LINE, like every other refusal here, and that is a testability property
  # rather than a formatting choice: the mutation controls delete a refusal by its
  # token and watch the assertion go green. A multi-line `if` loses its body to
  # that deletion and leaves `then fi` — a syntax error, which is a mutant that
  # proves nothing because it cannot run at all.
  if [ -n "${TR_PATH_CLEARED:-}" ] && [ "${TR_PATH_CLEARED}" != "$f" ]; then printf 'path-unchecked\n'; return 1; fi

  [ -f "$f" ] && [ -r "$f" ] || { printf 'unreadable\n'; return 1; }
  # The size bound is taken BEFORE a single line is read, so an oversized artifact
  # costs one stat rather than a walk through however much was planted.
  bytes="$(wc -c <"$f" 2>/dev/null)" || { printf 'unreadable\n'; return 1; }
  bytes="${bytes// /}"
  case "$bytes" in ''|*[!0-9]*) printf 'unreadable\n'; return 1 ;; esac
  [ "$bytes" -le "$TERMINAL_RESULT_MAX_BYTES" ] || { printf 'too-large\n'; return 1; }

  # TAKEN BEFORE THE PARSE AND AGAIN AFTER IT, and both are required to match. The
  # obvious version of this takes one snapshot when the parse finishes, which
  # leaves the parse itself unguarded: a record rewritten between the first line
  # and the last would have been read as a mixture of two artifacts and reported
  # as one. Bracketing the read is what makes TR_* the fields of a single,
  # identifiable set of bytes rather than of whatever happened to be there.
  #
  # NO HASH MEANS NO ACCEPTANCE. If the digest cannot be taken the record is
  # refused, never accepted unbound — an artifact this function cannot pin is
  # exactly the one a later identity check could not detect a swap of.
  sha_before="$(wl2_tr_sha "$f")"
  [ -n "$sha_before" ] || { printf 'unhashable\n'; return 1; }
  fid_before="$(wl2_tr_fid "$f")"
  [ -n "$fid_before" ] || { printf 'unidentifiable\n'; return 1; }

  # `|| [ -n "$line" ]` so a final line with no trailing newline is still read and
  # judged. Dropping it would make a truncated record look like a complete one.
  while IFS= read -r line || [ -n "$line" ]; do
    n=$((n+1))
    [ "$n" -le "$TERMINAL_RESULT_MAX_LINES" ] || { printf 'too-many-lines\n'; return 1; }
    case "$line" in [a-z]*=*) ;; *) printf 'malformed-line\n'; return 1 ;; esac
    key="${line%%=*}"
    val="${line#*=}"
    case "$key" in *[!a-z0-9_]*) printf 'malformed-line\n'; return 1 ;; esac
    [ "${#val}" -le "$TERMINAL_RESULT_MAX_VALUE" ] || { printf 'value-too-long\n'; return 1; }
    # The producer's `tr_val` turns tabs and carriage returns into spaces, so a
    # value carrying one did not come from it.
    case "$val" in *$'\t'*|*$'\r'*) printf 'malformed-line\n'; return 1 ;; esac
    # THE VERSION ANNOUNCES ITSELF FIRST, before anything else is interpreted. A
    # reader that merely searched for the expected version string would accept a
    # record that declared something else at the top and buried the match below.
    if [ "$n" -eq 1 ]; then
      [ "$key" = terminal_result_version ] || { printf 'bad-version-line\n'; return 1; }
      [ "$val" = 1 ]                       || { printf 'unknown-version\n';  return 1; }
    fi
    if [ "$key" = schema ] && [ "$val" != "$TERMINAL_RESULT_SCHEMA" ]; then
      printf 'unknown-schema\n'; return 1
    fi
    # A field this version does not define is a partial acceptance, not a
    # harmless extra: the version is exact, so an unrecognized key means the
    # writer and this reader do not agree about what the record is.
    case " $TERMINAL_RESULT_REQUIRED " in *" $key "*) ;; *) printf 'unknown-field\n'; return 1 ;; esac
    case "$seen" in *" $key "*) printf 'duplicate-field\n'; return 1 ;; esac
    seen="$seen$key "
    # Held in locals, not published yet. The duplicate check above has already
    # run, so each of these is captured exactly once per record.
    case "$key" in
      task)     got_task="$val" ;;
      checkout) got_checkout="$val" ;;
      run)      got_run="$val" ;;
      outcome)  got_outcome="$val" ;;
      code)     got_code="$val" ;;
    esac
    last="$line"
  done <"$f"

  [ "$n" -gt 0 ] || { printf 'empty\n'; return 1; }
  # THE SENTINEL IS CHECKED BEFORE THE MISSING-FIELD SWEEP, so a record cut short
  # mid-write is named for what it is — unfinished — rather than for whichever
  # field the truncation happened to remove first.
  [ "$last" = 'result_complete=yes' ] || { printf 'incomplete\n'; return 1; }
  for k in $TERMINAL_RESULT_REQUIRED; do
    case "$seen" in *" $k "*) ;; *) printf 'missing-field\n'; return 1 ;; esac
  done
  sha_after="$(wl2_tr_sha "$f")"
  [ -n "$sha_after" ] || { printf 'unhashable\n'; return 1; }
  [ "$sha_before" = "$sha_after" ] || { printf 'artifact-changed\n'; return 1; }
  fid_after="$(wl2_tr_fid "$f")"
  [ -n "$fid_after" ] || { printf 'unidentifiable\n'; return 1; }
  [ "$fid_before" = "$fid_after" ] || { printf 'artifact-replaced\n'; return 1; }

  # Published last, after every structural refusal above has had its chance. The
  # sweep just proved all three keys are present, so none of these is empty, and
  # the bracketing digests and file identities just proved they all came from one
  # set of bytes in one file.
  TR_SOURCE="$f"; TR_TASK="$got_task"; TR_CHECKOUT="$got_checkout"; TR_RUN="$got_run"
  TR_SHA="$sha_after"; TR_FID="$fid_after"
  TR_OUTCOME="$got_outcome"; TR_CODE="$got_code"
  printf 'ok\n'
  return 0
}

# --------------------------------- the terminal result's expected-identity reader
#
# THE SECOND HALF OF A QUESTION THE VALIDATOR ABOVE DELIBERATELY LEAVES OPEN. That
# one answers "is this the shape this dispatcher writes". This one answers "is this
# the result promised for THIS task, THIS checkout and THIS run" — and the gap
# between them is the whole point: a copied, replayed or planted record is
# structurally flawless, because it is a real record that belongs to something
# else.
#
# EVERY EXPECTATION COMES FROM THE CALLER, and that constraint is what gives the
# comparison any value. The four expected values are dispatcher-owned variables
# passed in as arguments. Nothing here reads an expectation out of the artifact,
# out of a state file, or out of anything an actor wrote: a check that sourced both
# sides of its own comparison from the thing under test would confirm the record
# agrees with itself, which is exactly what a forgery does too.
#
# IT DOES NOT GO LOOKING. No directory is scanned, no candidate is chosen, no
# newest-file is picked. The caller states the path it promised and this function
# says whether the artifact there is that promise kept. Choosing a path is a
# consumer's job and consumers are a later unit.
#
# REFUSE, NEVER NORMALIZE — the same rule the structural reader states, applied to
# paths, where it matters more. A traversal segment, a leading dash, a control
# character or a symlink is refused outright. Resolving any of them would mean
# deciding what the caller "really meant" about which file to trust, and the
# answer to a hostile path is never a cleaned-up version of it.
#
# STRUCTURE FIRST, ALWAYS. This reads what validate_terminal_result() captured and
# refuses when that did not run on this exact artifact. It never re-parses the
# record: one artifact, one parse, one owner.
validate_terminal_result_identity() { # artifact task checkout run evidence-root -> 0 and ok, or 1 and one bounded token
  local f="${1-}" x_task="${2-}" x_checkout="${3-}" x_run="${4-}" x_root="${5-}"
  local sha_now fid_now

  [ -n "$f" ] || { printf 'no-path\n'; return 1; }
  [ -n "$x_task" ] && [ -n "$x_checkout" ] && [ -n "$x_run" ] && [ -n "$x_root" ] \
    || { printf 'no-expectation\n'; return 1; }

  # THE TWO PRECONDITIONS, IN THE ORDER THEY MUST HAVE HAPPENED. `TR_PARSE_GATED`
  # is the load-bearing one, and it is not the same check as "the gate has cleared
  # this path": it is "the gate had already cleared this path when the parse
  # opened it". A caller that parsed first and gated afterwards satisfies the
  # weaker reading while having done exactly the thing the gate exists to prevent.
  # Checking it before `unvalidated` matters too — if only the parse ran, the bytes
  # were read through a path nothing vetted, and "unvalidated" would name the
  # wrong failure.
  [ "${TR_PARSE_GATED:-}" = "$f" ] || { printf 'path-unchecked\n'; return 1; }
  [ "${TR_SOURCE:-}" = "$f" ]      || { printf 'unvalidated\n';    return 1; }

  # THE ARTIFACT IS PINNED TO THE BYTES THAT WERE VALIDATED, not to the name they
  # were read through. Without this, a structurally valid record can be parsed and
  # then replaced at the same promised path by ANOTHER structurally valid record,
  # and every comparison below would still be answered from the first record's
  # fields — a result accepted for bytes nothing ever checked. Fails closed: an
  # artifact that can no longer be hashed is refused, not waved through.
  # PATH TOPOLOGY IS RE-ESTABLISHED, NOT REMEMBERED. The gate cleared this name
  # while it was a regular file; nothing prevents it becoming a link afterwards,
  # and both hashes would then happily follow that link to byte-identical valid
  # content. Checked before the digests for exactly that reason — a link is a
  # changed path, and naming it as a content change would describe the wrong event.
  if [ ! -L "$f" ]; then :; else printf 'symlinked-path\n'; return 1; fi

  # WHICH FILE, then WHICH BYTES. A byte-identical replacement at the same name has
  # the same digest by construction, so the digest cannot see it; file identity
  # can. Both are required, and each names its own event.
  fid_now="$(wl2_tr_fid "$f")"
  [ -n "$fid_now" ] || { printf 'unidentifiable\n'; return 1; }
  [ "$fid_now" = "${TR_FID:-}" ] || { printf 'artifact-replaced\n'; return 1; }

  sha_now="$(wl2_tr_sha "$f")"
  [ -n "$sha_now" ] || { printf 'unhashable\n'; return 1; }
  [ "$sha_now" = "${TR_SHA:-}" ] || { printf 'artifact-changed\n'; return 1; }

  # Artifact against caller, one field at a time, each on its own line so a
  # mutation control can remove exactly one comparison and prove the others are
  # not standing in for it.
  [ "$TR_TASK" = "$x_task" ]         || { printf 'task-mismatch\n';     return 1; }
  [ "$TR_CHECKOUT" = "$x_checkout" ] || { printf 'checkout-mismatch\n'; return 1; }
  [ "$TR_RUN" = "$x_run" ]           || { printf 'run-mismatch\n';      return 1; }

  printf 'ok\n'
  return 0
}

# ------------------------------- the terminal result's expected-MEANING reader
#
# THE THIRD QUESTION, and the one the two boundaries above deliberately leave
# open. The parser asks "is this the shape this dispatcher writes". Identity asks
# "is this the result promised for THIS task, THIS checkout and THIS run". Both
# can pass on a record whose `outcome` and `code` say something other than the
# terminal the caller was expecting — a genuine record of a DIFFERENT ending,
# structurally perfect and correctly addressed, is the case that gap admits.
#
# EVERY EXPECTATION COMES FROM THE CALLER, on the same argument the identity
# boundary makes and for a sharper reason here. The caller knows which terminal it
# is finalizing; the artifact merely asserts one. Deriving either expected value
# from the record under test would compare it with itself, which is a check a
# forged record passes by construction.
#
# NO SECOND CODE-TO-OUTCOME TABLE. `result_outcome()` is the sole owner of that
# mapping and stays the sole owner: this function compares two values it is given
# and knows no symbols of its own. A table here would be a second authority on
# what an exit code means, and the two would drift the first time one changed.
#
# IT REOPENS NOTHING. The comparison is against what the single structural pass
# captured, re-pinned to that pass's exact artifact snapshot — so a caller cannot
# parse one record and ask about another, and a record replaced or rewritten after
# the parse is refused rather than answered from stale captured fields.
#
# THE EXPECTED VALUES ARE COMPARED, NEVER USED AS PATHS, which is why they carry
# no traversal or control-character refusal of their own. Identity screens its
# arguments because they build a promised path; nothing here opens, resolves or
# executes anything, so a hostile expectation can only fail to match.
validate_terminal_result_semantics() { # artifact expected-outcome expected-code -> 0 and ok, or 1 and one bounded token
  local f="${1-}" x_outcome="${2-}" x_code="${3-}"
  local sha_now fid_now

  [ -n "$f" ] || { printf 'no-path\n'; return 1; }
  # AN UNSUPPLIED EXPECTATION IS NOT A WILDCARD, exactly as at the two boundaries
  # above. A caller that has not established what ending it expects is refused,
  # never matched against whatever the record happens to claim.
  [ -n "$x_outcome" ] && [ -n "$x_code" ] || { printf 'no-expectation\n'; return 1; }

  # THE SAME TWO PRECONDITIONS, IN THE SAME ORDER, and for the same reason the
  # identity boundary states: the gate must have cleared this path BEFORE the
  # parse opened it, and the parse that ran must have read THIS artifact.
  [ "${TR_PARSE_GATED:-}" = "$f" ] || { printf 'path-unchecked\n'; return 1; }
  [ "${TR_SOURCE:-}" = "$f" ]      || { printf 'unvalidated\n';    return 1; }

  # A regular file that has become a link since the gate cleared it is a changed
  # path, and checked first so it is named as one.
  if [ ! -L "$f" ]; then :; else printf 'symlinked-path\n'; return 1; fi

  # WHICH FILE, then WHICH BYTES — the snapshot binding, re-established here
  # rather than inherited from whether identity happened to run. This boundary is
  # callable on its own, so it defends its own answer: without this, a record
  # could be validated and then replaced at the same name, and the comparison
  # below would report the first record's outcome for the second record's bytes.
  fid_now="$(wl2_tr_fid "$f")"
  [ -n "$fid_now" ] || { printf 'unidentifiable\n'; return 1; }
  [ "$fid_now" = "${TR_FID:-}" ] || { printf 'artifact-replaced\n'; return 1; }

  sha_now="$(wl2_tr_sha "$f")"
  [ -n "$sha_now" ] || { printf 'unhashable\n'; return 1; }
  [ "$sha_now" = "${TR_SHA:-}" ] || { printf 'artifact-changed\n'; return 1; }

  # Artifact against caller, one field per line and one token each, so a mutation
  # control can remove exactly one comparison and prove the other is not standing
  # in for it. The two are distinct on purpose: a record carrying the right symbol
  # for the wrong code and one carrying the wrong symbol for the right code are
  # different failures, and a shared token would hide which one happened.
  [ "$TR_OUTCOME" = "$x_outcome" ] || { printf 'outcome-mismatch\n'; return 1; }
  [ "$TR_CODE" = "$x_code" ]       || { printf 'code-mismatch\n';    return 1; }

  printf 'ok\n'
  return 0
}
# --- wl2:terminal-result-validator:end ---

die() { # code, message
  local code="$1"; shift
  local msg="$*"
  # Structural O2 guarantee: after any actor launch, every nonzero exit carries
  # the partial-effect delta. Early validation failures remain short because no
  # launch baseline exists yet.
  [ "${HOP_BASELINE_READY:-0}" -eq 1 ] && msg="$msg$(partial_effect_block)"
  printf 'STOP [%s] %s\n' "$code" "$msg" >&2
  [ -n "${RUN_LOG:-}" ] && printf 'STOP [%s] %s\n' "$code" "$msg" >>"$RUN_LOG"
  # Ordered deliberately: after the human message is on both channels, so the run
  # log the record points at already carries the wording; and BEFORE release_lock,
  # because a lease may only be released once the terminal result exists.
  # THE PATH IS PRINTED — evidence nobody can find is not evidence. That lesson
  # was learned by the lease refusal, which now leaves through this funnel too.
  #
  # THE RETURN IS HONORED. A failed publication transfers to the funnel's own
  # unprovability exit — pin, 38, no release — instead of continuing to the
  # original code below as though the evidence existed. One line, its own
  # marker, so the mutation control can remove exactly the transfer and prove
  # the unsafe fall-through comes back without it.
  finalize_terminal_result "$code" || die_funnel_unprovable "$code" # die funnel failure transfer
  # THE FIFTH AND LAST CONSUMER, and the one that covers the most terminals. Every
  # ordinary nonzero ending leaves through here, and until now this funnel
  # published a record and then advertised and released against it without ever
  # asking whether the artifact still said what this run did. The gap was real and
  # measured: a record altered after finalization in `outcome` alone, or in `code`
  # alone, still returned the original 22 or 18, was advertised as this run's
  # terminal result and released both leases. Path, structure and identity have
  # nothing to object to; only meaning does.
  #
  # THE EXPECTED PAIR IS THE FUNNEL'S OWN, not the artifact's. `$code` is the
  # parameter this call was made with and the value `exit "$code"` below returns —
  # one value, so a reader can see the record is being checked against the ending
  # actually being reported — and the symbol is `result_outcome()`'s answer for
  # that same code, the sole code-to-outcome owner. One call therefore covers every
  # nonzero terminal in the funnel without a per-code call site or a second table.
  #
  # RESULT_FILE IS THE COVERAGE GUARD, and it is the right one. It is set only
  # inside finalize_terminal_result, after that function's own run-evidence check,
  # and cleared again if the write fails — so a non-empty value means precisely
  # "this run finalized a record just now". Terminals outside the coverage guard
  # (argument refusals, lease-infrastructure failures) reach die() with it empty
  # and are skipped, exactly as they are skipped by the advertisement below.
  #
  # AND THE REFUSAL RE-ENTERS THIS FUNNEL, which is why the one-shot flag is not
  # decoration. die_terminal_untrusted exits through `die 38`, so control arrives
  # back here with the record already finalized; a consumer that ran again would
  # compare the same artifact against TERMINAL_UNPROVABLE/38, refuse again, and
  # never terminate. The flag is set BEFORE the call, not after, because the call
  # does not return on a refusal. Case 50k counts the STOP [38] lines to prove the
  # bound holds rather than assuming it.
  if [ "$RESULT_CONSUMED" -eq 0 ] && [ -n "$RESULT_FILE" ]; then
    RESULT_CONSUMED=1
    consume_terminal_result "the shared nonzero terminal for code $code" "$(result_outcome "$code")" "$code" # die-funnel terminal consumption
  fi
  if [ -n "$RESULT_FILE" ]; then
    printf '  terminal result: %s\n' "$RESULT_FILE" >&2
    printf '  terminal result: %s\n' "$RESULT_FILE" >>"$RUN_LOG"
  fi
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
# LENGTH IS A SEPARATE GRAMMAR FROM CHARACTERS, and only the second one was here.
# The task id is the LAST field of the run id (see RUN_ID below) and every piece of
# run evidence is that run id plus a suffix — so an id of legal characters but
# unbounded length was not refused, it was ADMITTED, and the run then could not
# name its own artifacts. A clear refusal here replaces an admitted run that cannot
# publish. This is the task-id half of the approved plan's hostile-input boundary,
# which asks for "strict length and character grammars to task IDs".
#
# WHERE 128 COMES FROM, derived from the naming formats this script already uses
# and from nothing else:
#   run id            <timestamp 15> "-" <lock key <=8> "-" <pid> "-" <task>
#   longest filename  <run id> ".unattended-settings.json"        (25 bytes)
#   NAME_MAX          255
# The fixed prefix is 15+1+8+1+7+1 = 33 bytes, taking the widest pid Linux allots
# and the full lock-key field, so the hard ceiling is 255-33-25 = 197. The maximum
# enforced below is 128, which keeps 69 bytes in hand deliberately: the hop-capture
# suffixes ".hop<N>.<actor>.out" and ".tree" grow with the caller's --max-hops
# digits, and bounds for the other token classes (run ids, outcomes, reason codes,
# protocol versions, control tokens) are not in place yet. The longest task id this
# repository has ever used is 54 characters, so nothing legal is relabelled.
#
# AFTER THE CHARACTER CHECK, NOT BEFORE IT, and that order is load-bearing:
# ${#TASK} counts characters, not bytes. The grammar above admits only single-byte
# ASCII, so once it has passed, characters and bytes are the same number and the
# arithmetic against NAME_MAX is sound. Reversed, a multi-byte id could pass a
# character count it would exceed in bytes.
TASK_ID_MAX=128
if [ "${#TASK}" -gt "$TASK_ID_MAX" ]; then
  printf 'STOP [12] task id rejected (too long: %s characters, maximum %s): %s\n' "${#TASK}" "$TASK_ID_MAX" "$TASK" >&2; exit 12
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

# --------------------------------- run-evidence location, BEFORE admission
#
# ADMISSION, NOT SETUP. The approved plan admits a run only once task, checkout
# AND the evidence location have been supplied and established as trusted;
# before that point an invalid invocation must launch no actor, take no owner or
# lease, mutate nothing and write no evidence. Task and checkout already cleared
# that bar, immediately above. The evidence location did not: its directory is
# created and canonicalized far below, AFTER acquire_lock, so an invocation
# naming a location it could never write to still took both leases first — and,
# where another run already held one, filed a refusal record — for a run that
# was never admissible. Those are effects taken by something that is not a run.
#
# CHECKED HERE, CREATED THERE. This block does not move the creation, and must
# not: a dispatcher that has not won both leases is not entitled to a byte
# inside the checkout, which is the whole finding case 12h pins. So the question
# asked here is only whether the location COULD be used, answered from paths
# that already exist. mkdir -p would build every missing level below the nearest
# existing ancestor, so that ancestor is the honest thing to test — and testing
# it costs nothing and leaves nothing behind.
#
# --status IS EXCLUDED, for the same reason it skips acquire_lock below: it is a
# read-only query rather than a run, it never writes evidence, and refusing it
# over a directory it would never touch would be answering a question nobody
# asked. --dry-run is NOT excluded — it takes both leases, so it is an admitted
# run and it is held to the admitted run's boundary.
check_evidence_location() { # requested-or-default path -> 0, or exits 10
  local want="$1" probe parent
  # A symlink that does not resolve to a directory is refused before anything
  # else. `-e` is false for a broken one, so the ancestor walk below would climb
  # straight past it to a perfectly good parent and call the location usable,
  # while mkdir -p would still fail on the dangling name.
  if [ -L "$want" ] && [ ! -d "$want" ]; then
    printf 'STOP [10] run evidence location is a symlink that does not resolve to a directory: %s\n' "$want" >&2
    exit 10
  fi
  if [ -e "$want" ]; then
    [ -d "$want" ] || {
      printf 'STOP [10] run evidence location exists and is not a directory: %s\n' "$want" >&2; exit 10; }
    [ -w "$want" ] || {
      printf 'STOP [10] run evidence directory is not writable: %s\n' "$want" >&2; exit 10; }
    return 0
  fi
  probe="$want"
  while [ ! -e "$probe" ]; do
    parent="$(dirname "$probe")"
    [ "$parent" = "$probe" ] && break
    probe="$parent"
  done
  [ -d "$probe" ] || {
    printf 'STOP [10] run evidence location cannot be created — %s is not a directory: %s\n' "$probe" "$want" >&2
    exit 10; }
  [ -w "$probe" ] || {
    printf 'STOP [10] run evidence location cannot be created — %s is not writable: %s\n' "$probe" "$want" >&2
    exit 10; }
  return 0
}
if [ "$STATUS_MODE" -ne 1 ]; then
  # The same resolution line 3112 makes below, and deliberately the same one: a
  # boundary that validated the request while the run used the default would be
  # checking a path nothing writes to.
  LOG_DIR_WANTED="$LOG_DIR"
  [ -n "$LOG_DIR_WANTED" ] || LOG_DIR_WANTED="$DEFAULT_LOG_DIR"
  check_evidence_location "$LOG_DIR_WANTED"
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

# ------------------------------------------------------------------- locks
# TWO locks, not one composite key, and located through the repository rather
# than through the caller's environment.
#
# WHAT WAS WRONG. The key used to be sha256("$CHECKOUT|$TASK") under
# "${TMPDIR:-/tmp}". Both halves of that failed:
#
#   1. ${TMPDIR} is caller-controlled. Two dispatchers launched with different
#      TMPDIR roots computed the same key under different parents, so they never
#      contended at all — the lock enforced nothing between them. On macOS this
#      is not exotic: per-session TMPDIR values are the norm.
#   2. A composite checkout|task key enforces neither resource on its own. Two
#      DIFFERENT tasks in ONE checkout hash to two different keys and both
#      proceed, and once they share a working tree and index, either can sweep
#      the other's paths into a commit.
#
# So the lock root moves to the Git COMMON directory — one location every linked
# worktree of the repository already shares, discovered from the repository
# itself and not from the environment — and the one composite lock becomes two
# independent ones. A second dispatcher is refused if EITHER is held.
#
#   task lock      one logical task may have one live dispatcher, anywhere in
#                  the repository, including in another worktree.
#   checkout lock  one physical checkout may have one live dispatcher, whatever
#                  task it is running.
#
# These govern LIVE PROCESS exclusivity only. Open-task exclusivity is the
# declaration's job (logs/work-loop/.owner, logs/scripts/work-loop-owner.sh):
# a lock cannot outlive its process, and continuity between handoffs must.
#
# THE MECHANISM NOW LIVES IN ONE PLACE, NOT TWO. Everything above was
# implemented here and, separately, in the attended carrier — two programs
# holding one invariant, which is exactly the shape that let the original
# composite key be wrong in both at once. The implementation moved to
# logs/scripts/work-loop-lease.sh and BOTH transports source it, so a lease this
# dispatcher takes is a lease the carrier observes and vice versa. What is left
# below is this program's own half: its wording, its exit codes, its call sites.
#
# THE LIBRARY IS SOURCED, NOT RUN, and it has to be. The lease must be held by
# THIS process for the whole of its life — the pid it records is what --status
# inspects, and the release runs from this script's own EXIT trap. A subprocess
# could not hold either.
#
# RESOLVED FROM THE CHECKOUT BEING DRIVEN, like the ownership helper below and
# for the same reason: the lease is a fact about that checkout's repository, and
# a checkout that cannot produce the library is a checkout whose lease cannot be
# established. Migration constraint 2 of the accepted proposal says such a
# checkout fails closed rather than skipping with a visible line, so that is what
# happens here — before any lease path is computed and long before an actor is
# launched. The code is 11, the outcome this dispatcher already uses for every
# other lease-infrastructure failure; 33/34/35 are the ownership taxonomy and a
# lease is not an ownership fact.
LEASE_LIB="$CHECKOUT/logs/scripts/work-loop-lease.sh"
if [ ! -f "$LEASE_LIB" ] || [ ! -r "$LEASE_LIB" ]; then
  printf 'STOP [11] the shared lease library is missing or unreadable: %s\n' "$LEASE_LIB" >&2
  printf '  Recoverable next action: the live lease cannot be taken without it, so nothing was\n' >&2
  printf '  launched and nothing was committed. Copy the library into this checkout — or run the\n' >&2
  printf '  task in a checkout that carries it — then re-run.\n' >&2
  exit 11
fi
# shellcheck source=../../../logs/scripts/work-loop-lease.sh
. "$LEASE_LIB" || {
  printf 'STOP [11] the shared lease library could not be sourced: %s\n' "$LEASE_LIB" >&2
  exit 11
}

wl_lease_init "$CHECKOUT" "$TASK"
case "$?" in
  0) ;;
  1) printf 'STOP [11] cannot resolve the Git common directory for %s\n' "$CHECKOUT" >&2; exit 11 ;;
  *) printf 'STOP [11] the Git common directory for %s is not readable\n' "$CHECKOUT" >&2; exit 11 ;;
esac

# Read-only views of the paths the library resolved. They are NOT a second
# derivation — nothing here recomputes a root, a hash or a name — they are the
# library's own values under the names this script's --status branch and its pin
# reporting already use. LOCK_DIR is the TASK lease: the name is kept because the
# thing being pinned, an actor tree that belongs to a task, is the task's.
LOCK_ROOT="$WL_LEASE_ROOT"
LOCK_DIR="$WL_LEASE_TASK_DIR"
CHECKOUT_LOCK_DIR="$WL_LEASE_CHECKOUT_DIR"

# The library takes both leases in the task-then-checkout order, records who
# holds each in plain text, and rolls the task lease back if the checkout lease
# is refused. What stays here is the REFUSAL WORDING and the exit code — the
# library prints nothing and standardises neither, because this dispatcher's
# refusals and the carrier's are each their own program's contract.
#
# A refusal must NAME the conflict rather than print a hash: a refusal nobody can
# act on is the failure mode this whole change exists to remove. Holder fields
# come back empty when the metadata is unreadable, and empty renders as
# "unrecorded" — never as a free lease.
#
# IT MUST ALSO NAME THE RIGHT PROGRAM. The lease became shared, so the holder of
# a lease this dispatcher is refused is no longer necessarily a dispatcher: an
# attended carry takes the same two leases through the same library. These lines
# said "another dispatcher" unconditionally, and against a carrier-held lease
# that is a false statement pointing the operator at the wrong process to look
# for. The library already records which program holds each lease
# (WL_LEASE_HOLDER_PROGRAM); this reads it.
#
# The vocabulary is the CARRIER'S, deliberately (carry-turn.sh 778-783): the two
# transports refuse each other, so an operator reading one refusal has to
# recognise the program named in the other. What is NOT shared is the message
# structure — this dispatcher keeps its own STOP-code shape, its own detail
# lines and its own remedy sentence, and the library still prints nothing. The
# holder label is the only thing held in common.
#
# THE LABEL DROPPED "another". It read "another dispatcher" and "another Work
# Loop run", which is true from inside a refused dispatcher and false everywhere
# else: --status now renders through this same function, and a status report is
# not a second run competing with the holder — it is a reader asking who is
# there. "another" would have made every status line quietly claim a contention
# that is not happening. The correction plan's step 5 fixes the vocabulary at
# this one point for exactly that reason, and the four renderings below are its
# wording verbatim. The refusal sites lose nothing: "STOP [17] a dispatcher
# holds task X" already says a competing run was refused, in the STOP code.
holder_label() { # -> a phrase naming who holds the lease
  case "${WL_LEASE_HOLDER_PROGRAM:-}" in
    carry)    printf 'an attended carry' ;;
    dispatch) printf 'a dispatcher' ;;
    "")       printf 'a Work Loop run (program unrecorded)' ;;
    *)        printf 'a Work Loop run (%s)' "$WL_LEASE_HOLDER_PROGRAM" ;;
  esac
}

# EXIT 17 NO LONGER KEEPS A DURABLE RECORD OF ITS OWN, and the apparatus that
# wrote one is gone with it. What stood here — REFUSAL_DIR, open_refusal_record(),
# r17() and refuse_17() — existed for one reason: exit 17 was taken before this
# run owned a run identity or an evidence location, so finalize_terminal_result()
# could not write for it and the refusal would otherwise have reached stderr and
# nowhere else. That was a real gap, met live on 2026-08-14, and the standalone
# `.refusal` sibling of the lease directories was the only place a run entitled
# to nothing could put its evidence.
#
# THE REVISED PLAN REMOVES THE CONDITION, so it removes the workaround. A lease
# refusal is now a terminal of an ADMITTED run: task, checkout and evidence
# location were established and trusted long before the lease was asked for, and
# run identity and the run log are opened above the lease call. So the refusal
# writes the ordinary versioned terminal result, through the ordinary funnel,
# into the run's own evidence location — and Change set A's "exactly one" is met
# by there being exactly one producer, not two records that must agree.
#
# DO NOT REINSTATE A SECOND STORE. Two durable records for one ending is the
# failure this deletion closes: they can disagree, and a reader then has to
# decide which is authoritative, which is a judgment no consumer of this spike
# is allowed to make.
acquire_lock() {
  wl_lease_acquire dispatch "$$"
  case "$?" in
    0) return 0 ;;
    # STILL A DIRECT EXIT, and deliberately not a die(). An uncreatable lease root
    # is lease INFRASTRUCTURE failing, not a lease being refused: it is exit 11,
    # it is not one of Change set A's enumerated terminal classes, and routing it
    # through the funnel would invent a terminal result for a class the plan does
    # not list. The four refusals below are the class that moved.
    1) printf 'STOP [11] cannot create the lock root %s\n' "$LOCK_ROOT" >&2; exit 11 ;;
  esac

  # THE FOUR REFUSALS LEAVE THROUGH die 17, the one funnel every other nonzero
  # terminal already uses, so a lease-refused run finalizes exactly one run-bound
  # terminal result through the single producer/consumer contract and files no
  # second durable record of its own. die() prefixes `STOP [17] `, which is why
  # the wording below no longer carries it; every operator-facing sentence is
  # otherwise unchanged, and the continuation lines are joined into the one
  # message so they reach stderr, the run log and the record together.
  local who surv msg; who="$(holder_label)"

  if [ "$WL_LEASE_RESOURCE" = task ]; then
    # The PINNED lines are left program-agnostic on purpose. "the previous run"
    # is true whichever transport pinned it, so there is nothing false to fix
    # here, and the survivor pids inside the lease are what the operator acts on.
    if [ "$WL_LEASE_REFUSAL" = pinned ]; then
      msg="$(printf 'the previous run of %s could not confirm its actor tree was stopped, so this lock is PINNED (%s)' "$TASK" "$LOCK_DIR")"
      surv="$(sed 's/^/  /' "$WL_LEASE_SURVIVORS" 2>/dev/null)"
      [ -n "$surv" ] && msg="$msg"$'\n'"$surv"
      die 17 "$msg"
    fi
    msg="$(printf '%s holds task %s (%s)' "$who" "$TASK" "$LOCK_DIR")"
    msg="$msg"$'\n'"$(printf '  it is running in checkout: %s' "${WL_LEASE_HOLDER_CHECKOUT:-unrecorded}")"
    die 17 "$msg"
  fi

  if [ "$WL_LEASE_REFUSAL" = pinned ]; then
    msg="$(printf 'a previous run in this checkout could not confirm its actor tree was stopped, so its checkout lock is PINNED (%s)' "$CHECKOUT_LOCK_DIR")"
    surv="$(sed 's/^/  /' "$WL_LEASE_SURVIVORS" 2>/dev/null)"
    [ -n "$surv" ] && msg="$msg"$'\n'"$surv"
    die 17 "$msg"
  fi
  msg="$(printf '%s is already running in this checkout (%s)' "$who" "$CHECKOUT")"
  msg="$msg"$'\n'"$(printf '  it is running task: %s' "${WL_LEASE_HOLDER_TASK:-an unrecorded task}")"
  # "two Work Loop runs", not "two dispatchers": the hazard is one working tree
  # and one index with two live writers in it, and that is the same hazard
  # whichever transport the other writer arrived by.
  msg="$msg"$'\n''  two Work Loop runs in one checkout share a working tree and index, so either could'
  msg="$msg"$'\n''  sweep the other task'"'"'s paths into a commit. Wait for it, or use another checkout.'
  die 17 "$msg"
}

# A pinned lock is NOT released, by anything, including the EXIT trap. It is the
# mechanism behind the plan's requirement that no second dispatcher is admitted
# while a descendant of the stopped actor may still be alive: the process that
# knows about the survivors is about to exit, so the only thing that can carry
# that knowledge forward is the lock it leaves behind.
#
# The pin FILE — its two machine-read line formats, the both-leases rule, and the
# guards that stop a pin claiming a lease this run never acquired — is the
# library's. What stays here is the OPERATOR-FACING line, which is this
# dispatcher's wording and names this dispatcher's exit 17.
#
# THE LIBRARY ANSWERS WITH THREE OUTCOMES AND THEY NEED THREE ANSWERS. This used
# to read `wl_lease_pin ... || return 0`, which merged every one of them into
# silence:
#
#   0  pinned, and every owned lock carries durable evidence a later run reads.
#   1  nothing was owned, so nothing was pinned — the same condition the guard on
#      LOCK_OWNED used to express here, and the same answer: nothing to report.
#   2  owned and pinned, but at least one lock has NO durable record. The
#      DIRECTORIES are still there and still refuse a second dispatcher; what is
#      missing is the written reason inside them.
#
# rc=2 is why the merge mattered. This transport walks away unattended, so a
# silence here leaves the operator in front of a held lock with nothing inside
# explaining it, and the obvious reading — a stale lock, safe to delete — is the
# unsafe one. It is said out loud, on BOTH channels, and the rc=0 line is
# withheld: announcing a pin that recorded nothing is the same false claim in the
# opposite direction.
#
# An unrecognised code is reported as unrecognised rather than assumed benign:
# the library may grow a fourth outcome, and inheriting silence by default is
# exactly how this defect arrived the first time.
pin_lock() { # survivor-pids, unknown-reason
  local rc=0 msg
  # Split from any `local` declaration on purpose: `local x="$(cmd)"` reports
  # `local`'s status and not the command's, and the whole function now turns on
  # the code captured here.
  wl_lease_pin "${1:-}" "${2:-}" "$TASK"; rc=$?
  case "$rc" in
    0)
      msg="  the task lock is PINNED at $LOCK_DIR (and this checkout's lock at $CHECKOUT_LOCK_DIR) — a second dispatcher is refused (exit 17) until you clear them by hand." ;;
    1)
      return 0 ;;
    2)
      msg="  WARNING: the pin RECORD could not be persisted for: ${WL_LEASE_PIN_FAILED:-an unnamed lock}.
  Those lock directories are deliberately RETAINED and were NOT released ($LOCK_DIR, and this checkout's lock at $CHECKOUT_LOCK_DIR), so a second dispatcher is still refused (exit 17).
  What is missing is the written reason inside them, so a later run and --status cannot say why they are held. Do NOT read them as a removable stale lock: clear them by hand only after confirming the processes named above are gone." ;;
    *)
      msg="  WARNING: the lease library returned an UNRECOGNISED pin result ($rc), so this dispatcher cannot tell what was recorded.
  Treat the lock directories as retained ($LOCK_DIR, and this checkout's lock at $CHECKOUT_LOCK_DIR): they were NOT released, and a second dispatcher is still refused (exit 17). Clear them by hand only after confirming the processes named above are gone." ;;
  esac
  printf '%s\n' "$msg" >&2
  [ -n "${RUN_LOG:-}" ] && printf '%s\n' "$msg" >>"$RUN_LOG"
  return 0
}

# The NON-TEARDOWN retention. The run reached a real operator terminal but could
# not finalize its terminal result, so the leases must outlive this process for a
# reason that has nothing to do with surviving descendants — pin_lock's evidence
# would tell the teardown story, which is false here and sends the operator
# hunting pids that do not exist. The library owns the durable cause text
# (wl_lease_pin_terminal); what lives here is this dispatcher's wording and its
# exit 17, exactly as with pin_lock above. Same three library outcomes, same
# three answers, for the same reasons.
pin_lock_terminal() { # [cause] -> 0 always; pins every owned lease with the truthful cause
  local rc=0 msg cause
  # The default is the finalization-failure cause this function was born with;
  # the consumer gate below passes its own, because "could not finalize" would be
  # FALSE there — the record was finalized and then failed this run's own trust
  # boundary. One emitter, two truthful causes, still one lease writer.
  cause="${1:-the run could not finalize its terminal result under ${LOG_DIR:-<no log dir>}}"
  wl_lease_pin_terminal "$cause" "$TASK"; rc=$?
  case "$rc" in
    0)
      msg="  the task lock is PINNED at $LOCK_DIR (and this checkout's lock at $CHECKOUT_LOCK_DIR) — this run could not prove how it ended, so a second dispatcher is refused (exit 17) until the cause is fixed and you clear them by hand." ;;
    1)
      return 0 ;;
    2)
      msg="  WARNING: the pin RECORD could not be persisted for: ${WL_LEASE_PIN_FAILED:-an unnamed lock}.
  Those lock directories are deliberately RETAINED and were NOT released ($LOCK_DIR, and this checkout's lock at $CHECKOUT_LOCK_DIR), so a second dispatcher is still refused (exit 17).
  What is missing is the written reason inside them: this run reached a terminal it could not prove. Do NOT read them as a removable stale lock." ;;
    *)
      msg="  WARNING: the lease library returned an UNRECOGNISED pin result ($rc), so this dispatcher cannot tell what was recorded.
  Treat the lock directories as retained ($LOCK_DIR, and this checkout's lock at $CHECKOUT_LOCK_DIR): they were NOT released, and a second dispatcher is still refused (exit 17). Clear them by hand only after fixing what blocked the terminal result." ;;
  esac
  printf '%s\n' "$msg" >&2
  [ -n "${RUN_LOG:-}" ] && printf '%s\n' "$msg" >>"$RUN_LOG"
  return 0
}

# The operator terminal's fail-closed exit, in the order that fails safe: pin
# FIRST, so the leases are already retained before die() and the EXIT trap reach
# release_lock, then die(38), whose own finalize attempt records the code-38
# result where the filesystem still permits one. The retention line carries its
# own marker comment so a mutation control can delete exactly it and prove the
# EXIT path releases without it.
#
# WHICH TERMINAL IT WAS is a parameter, defaulted to the wording this function was
# born with. Three code-zero seams now share it, and the sentence names the one
# that was reached: telling an operator their run "reached a real operator
# terminal" about a hop carried between two actors is a false statement in the
# one message they read when nothing else can be trusted. A second copy of this
# function per seam would duplicate the pin-and-exit owner instead, which is the
# thing that must stay single.
die_terminal_unprovable() { # [terminal-label]
  pin_lock_terminal # operator terminal retention
  die 38 "the run reached ${1:-a real operator terminal} (state_class=${ST_CLASS:-unavailable}) but its terminal result could not be finalized under $LOG_DIR — refusing to exit 0, because a run that cannot prove how it ended must not report that it ended well."$'\n'"Recoverable next action: check that $LOG_DIR is writable and has space, then re-run this dispatcher. The state file is NOT the problem here and needs no repair. Both run leases are retained with that cause recorded, so a second dispatcher is refused (exit 17) until you clear them."
}

# The CONSUMER's fail-closed exit — same shape, same pin-first order, same exit
# code as die_terminal_unprovable, for the same reason: a run that cannot prove
# its terminal result is its own must not buy a lease release with it. What
# differs is the truthful cause: here the record finalized successfully and then
# failed the consumer gate, so the pin carries the gate's bounded refusal token
# rather than a finalization story.
# The terminal label is the SECOND argument here, for the same reason and with the
# same default as the finalization exit above; the refusal token stays first
# because every existing caller passes it there.
#
# THE SENTENCE IS TERMINAL-NEUTRAL, and must stay that way. Four consumers share
# it and they do not share an intended exit code: three were ending at 0, the
# interruption at 28. Until Unit 31 it named the exit-0 ending as the one being
# withheld, which is simply false for the interruption — and the nonzero die()
# funnel that becomes the fifth consumer is nonzero by definition. It also called
# the gate this run's OWN, which reads as though passing it had established
# ownership; the gate is the check that FAILED, and offering it as provenance is
# the very claim this refusal exists to withhold. Neither phrasing may come back,
# and this sentence must not branch on the code: a per-code branch would make it
# one message owner per terminal, which is the duplication the single
# pin-and-exit owner exists to avoid. Case 58f's M38 is the control that holds
# this, and 58e/27w are the two consumers it is asserted over.
die_terminal_untrusted() { # bounded-refusal-token [terminal-label]
  # FIRST CAUSE WINS, because the lease record outlives the run and the operator
  # reads it long after both messages have scrolled away. This refusal is not
  # always the first thing that went wrong: where a terminal-specific
  # finalization already failed, die_terminal_unprovable pinned the real
  # initiating cause and re-entered die 38, that retry succeeded, and the funnel
  # consumer then refuses the record the retry wrote. Pinning again there
  # overwrote the finalization failure with a mismatch — and the two have
  # different recoveries, so the surviving record sent the operator to repair an
  # interfering artifact when a write had failed. `wl_lease_pin_terminal` writes
  # one durable cause per lease rather than a history, so precedence has to be
  # decided here; it is the same first-cause rule die_funnel_unprovable already
  # applies below, not a second pin store or a cause stack.
  #
  # THE LATER REFUSAL IS NOT LOST, and that is the other half. It still reaches
  # stderr and the run log in full, with its own bounded token — what changes is
  # only which cause survives on the leases, and the sentence stops claiming this
  # refusal's cause was written there when it was not.
  local held='are retained with that cause recorded'
  if [ "${WL_LEASE_PINNED:-0}" -eq 0 ]; then # consumer retention precedence
    pin_lock_terminal "the promised terminal result under ${LOG_DIR:-<no log dir>} was refused before release: ${1:-refused}" # operator consumer retention
  else
    held='remain retained under the cause recorded before this refusal — that earlier evidence is preserved unchanged, and this message and the run log are where this refusal is recorded'
  fi
  # RESULT_FILE is cleared so die() does not print "terminal result:" pointing at
  # the very artifact this run just refused to trust — advertising it as this
  # run's evidence would be the false claim the refusal exists to prevent. The
  # artifact itself is left in place, untouched, as evidence of what was found.
  RESULT_FILE=""
  die 38 "the run reached ${2:-a real operator terminal} (state_class=${ST_CLASS:-unavailable}) and finalized its terminal result, but the promised artifact at $LOG_DIR_ABS/$RUN_ID.result did not pass the consumer gate (${1:-refused}) — so it is refused as this run's reported ending, because a result this run cannot prove is its own must not be reported as how it ended."$'\n'"Recoverable next action: inspect that path against the run log $RUN_LOG, remove or repair the interfering artifact, then re-run this dispatcher. The state file is NOT the problem here and needs no repair. Both run leases $held, so a second dispatcher is refused (exit 17) until you clear them."
}

# The SHARED FUNNEL's own failure transfer. die() publishes the terminal result
# for every D–L terminal; until Unit 11 it invoked the finalizer and IGNORED its
# return, so a run whose publication failed still exited with its original code
# and released both leases — the same unproven-ending hole the operator seam
# closed at Unit 8, reachable from every other terminal.
#
# NOT die_terminal_unprovable, and it cannot be: that function calls die(),
# which is the funnel this transfer sits inside — entering it from here would
# re-invoke the finalizer that just failed and recurse. This transfer pins and
# exits DIRECTLY, publishing nothing twice: one finalization attempt, one pin,
# one exit.
#
# ONE RETURN IS DELIBERATE, and it names the only case where the transfer must
# not fire: a terminal with no run evidence yet (no RUN_ID/LOG_DIR) is outside
# the covered funnel — the same boundary finalize_terminal_result draws for
# itself — and keeps its original exit.
#
# ALREADY-PINNED STILL EXITS 38. An earlier revision returned here when the
# leases were already pinned, which kept the original exit code and recorded the
# publication failure nowhere — a non-38 terminal indistinguishable from one
# whose result exists (the Unit 11 correction's frozen finding). What survives
# from that revision is only the part that was right: the pin is NOT repeated,
# because the cause already on disk (a teardown's survivor pids, or the operator
# seam's own pin) is stronger evidence than a finalization story and one write
# would overwrite the other. The failed publication is recorded on both output
# channels instead, and the exit is 38 either way — an unprovable ending is
# named as one no matter what pinned the leases first.
die_funnel_unprovable() { # original-code -> returns 0 only where the transfer must not fire
  [ -n "${RUN_ID:-}" ] && [ -n "${LOG_DIR:-}" ] || return 0 # die funnel coverage guard
  local held='are retained with that cause recorded'
  if [ "${WL_LEASE_PINNED:-0}" -eq 0 ]; then
    pin_lock_terminal # die funnel retention
  else
    held='remain retained under the cause recorded before this failure — that earlier evidence is preserved unchanged, and this message is where the failed publication is recorded'
  fi
  local m="STOP [38] the run was ending with terminal code $1 but its terminal result could not be finalized under ${LOG_DIR:-<no log dir>} — exiting 38 instead, because a run that cannot prove how it ended must not report that it ended with $1 and hand its checkout on."$'\n'"Recoverable next action: check that $LOG_DIR is writable and has space, then re-run this dispatcher. The state file is NOT the problem here and needs no repair. Both run leases $held, so a second dispatcher is refused (exit 17) until you clear them."
  printf '%s\n' "$m" >&2
  [ -n "${RUN_LOG:-}" ] && printf '%s\n' "$m" >>"$RUN_LOG"
  release_lock
  exit 38
}

# --------------------------------------- the operator terminal's consumer gate
#
# THE FIRST PRODUCTION CONSUMER of the terminal result, at the one seam where
# release is the real advance decision (Unit 9's evidence map). The promised
# path is DERIVED from two values this dispatcher already owns — the canonical
# evidence root and this run's id — never accepted from an argument, a scan, or
# the artifact itself; and every expectation handed to the validators below is a
# live dispatcher variable. Nothing here reads an expectation out of the record,
# a state file, Git or a log, and nothing goes looking: no directory listing, no
# newest-file pick, no wait — the producer's atomic rename completed before this
# function is reached, so the read is zero-wait by construction.
#
# THE CHECKS IN THE ONE ORDER THAT IS CORRECT: gate the path while nothing is
# open, parse the bytes exactly once, compare identity against that pinned
# snapshot, and — where the caller has stated what ending it is finalizing —
# compare meaning against that same snapshot. These are the accepted validators,
# not a second reader — the composition adds no parser and no lifecycle read.
# They are called in the CURRENT shell because they hand each other their state
# through globals (TR_PATH_CLEARED, TR_SOURCE, TR_OUTCOME, TR_CODE) that a
# $(...) subshell would discard, so each refusal token travels through a scratch
# file beside the run log instead — the same mechanic, for the same reason, as
# the harness's own ident_run.
#
# ACCEPTANCE IS THE ONLY RETURN. Every refusal — missing, path-refused,
# structurally refused, identity-refused, meaning-refused — leaves through
# die_terminal_untrusted with the first bounded token the composed boundary
# produced.
#
# The optional terminal label is CARRIED, not re-derived: this function knows
# which of its refusals fired, and only its caller knows which terminal it was
# called from. Passing nothing keeps the accepted operator-terminal wording.
#
# THE EXPECTED PAIR IS THE CALLER'S, AND IT IS OPTIONAL HERE ON PURPOSE. A caller
# that states which outcome and which code it is finalizing gets the semantic
# boundary as well; a caller that states neither gets exactly the accepted
# three-boundary composition it had before. That is what lets the first consumer
# be migrated on its own without changing the release behaviour of any terminal
# seam still to come — the alternative, making the pair mandatory, would migrate
# every caller at once and silently change four terminals in a unit that agreed
# to change one.
#
# IT DERIVES NOTHING. The pair arrives as two arguments the caller established
# from dispatcher-owned facts. Nothing here reads an expectation out of the
# artifact, and nothing here knows a code-to-outcome mapping — `result_outcome()`
# remains the sole owner of that, on the argument the semantic boundary states.
#
# HALF AN EXPECTATION IS STILL AN EXPECTATION. The guard is "either was stated",
# not "both were", so a caller that supplies one and loses the other is refused
# by the boundary's own `no-expectation` rather than quietly skipping the check —
# which is what an "and" here would do, at exactly the seam where it matters.
consume_terminal_result() { # [terminal-label] [expected-outcome] [expected-code] -> 0 on acceptance; a refusal never returns
  local promised cap tok label="${1:-}" x_outcome="${2:-}" x_code="${3:-}"
  promised="$LOG_DIR_ABS/$RUN_ID.result"
  cap="$RUN_LOG.consume"
  validate_terminal_result_path "$promised" "$TASK" "$CHECKOUT" "$RUN_ID" "$LOG_DIR_ABS" >"$cap" 2>/dev/null \
    || { tok="$(head -1 "$cap" 2>/dev/null)"; rm -f "$cap"; die_terminal_untrusted "${tok:-path-refused}" "$label"; }
  validate_terminal_result "$promised" >"$cap" 2>/dev/null \
    || { tok="$(head -1 "$cap" 2>/dev/null)"; rm -f "$cap"; die_terminal_untrusted "${tok:-structure-refused}" "$label"; }
  validate_terminal_result_identity "$promised" "$TASK" "$CHECKOUT" "$RUN_ID" "$LOG_DIR_ABS" >"$cap" 2>/dev/null \
    || { tok="$(head -1 "$cap" 2>/dev/null)"; rm -f "$cap"; die_terminal_untrusted "${tok:-identity-refused}" "$label"; }
  [ -n "$x_outcome" ] || [ -n "$x_code" ] && { validate_terminal_result_semantics "$promised" "$x_outcome" "$x_code" >"$cap" 2>/dev/null \
    || { tok="$(head -1 "$cap" 2>/dev/null)"; rm -f "$cap"; die_terminal_untrusted "${tok:-semantics-refused}" "$label"; }; } # composed semantic boundary
  rm -f "$cap"
  return 0
}

# Pinned beats owned, and that check lives inside the library rather than at each
# call site — one missed caller would silently undo the invariant. Every exit
# path of this script reaches here: die(), the EXIT trap, the signal handler.
release_lock() { wl_lease_release; }

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

  # THREE PLACES, NOT TWO (Unit 25). `between hops` is true of a run that has
  # finished at least one hop and false of one that has never launched anything —
  # and the second is the window this unit brought inside the evidence boundary,
  # so the wording it is reported under has to stop describing hops that did not
  # happen. Read from ACTOR_PROCESS_STARTED, the same fork fact the record's own
  # `stage` and `actor_launched` fields derive from, so the operator's screen and
  # the machine record cannot describe different runs.
  local where="between hops"
  [ "${ACTOR_PROCESS_STARTED:-0}" -eq 1 ] || where="before the first hop launched"
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
  #
  # THE PRE-LAUNCH VARIANT SAYS SOMETHING DIFFERENT BECAUSE SOMETHING DIFFERENT
  # HAPPENED (Unit 25). "the actor was killed mid-hop; it may have left a partial
  # effect" is a claim about a process this run never forked, and it was being
  # printed for every interruption that arrived before the first launch — sending
  # the operator to reconcile a hop against effects that cannot exist. The
  # no-retry promise and the recoverable-next-action shape are unchanged in both,
  # because both are true in both; only the sentence describing what was stopped
  # is chosen by the fork fact.
  local msg="  the actor was killed mid-hop; it may have left a partial effect. Nothing is retried.
  Recoverable next action: read $STATE_FILE and \`git -C $CHECKOUT status\`, decide what the
  hop actually completed, then re-run this dispatcher. Run evidence: ${RUN_LOG:-<none>}"
  [ "${ACTOR_PROCESS_STARTED:-0}" -eq 1 ] || msg="  no actor was ever launched by this run, so no hop was interrupted and nothing it could
  have left behind exists. Nothing is retried.
  Recoverable next action: read $STATE_FILE and \`git -C $CHECKOUT status\` to confirm the
  turn is where you left it, then re-run this dispatcher. Run evidence: ${RUN_LOG:-<none>}"

  # O2 reaches the signal path too. This handler already SAID "it may have left
  # a partial effect" and then made the operator go and find out for themselves
  # — which is the same reporting gap the timeout had, one control over. Guarded
  # on CHECKOUT because a signal can in principle land before argument parsing
  # has resolved one, and a teardown path must not itself fail under `set -u`.
  [ -n "${CHECKOUT:-}" ] && msg="$msg$(partial_effect_block)"

  printf '%s\n' "$msg" >&2
  [ -n "${RUN_LOG:-}" ] && printf '%s\n' "$msg" >>"$RUN_LOG"

  # TRUSTED EVIDENCE BEFORE RELEASE — the last post-launch terminal that had none
  # (Unit 23). Everything above this point reports on SCREEN and then released the
  # lease and exited 28, leaving nothing a later reader could point at: the same
  # unproven-ending hole closed at the operator seam (Unit 8), the shared die
  # funnel (Unit 11) and the dry-run and carry-one terminals (Unit 12 onward).
  # Same boundary, same order, same fail-closed behaviour as those: finalize, then
  # consume the exact promised artifact, and only then release.
  #
  # GUARDED ON RUN EVIDENCE, NOT ON THE FORK (Unit 25). Unit 23 guarded these two
  # lines on ACTOR_PROCESS_STARTED, which drew the boundary at the wrong fact: a
  # signal that arrives after this run has taken both leases, claimed its RUN_ID
  # and opened its run log has ALREADY changed the shared world, and it exited 28
  # having published nothing a later reader could point at — the same
  # unproven-ending hole one window earlier. Case 27r-deferred measured exactly
  # that: leases held, run log on disk, exit 28, zero results.
  #
  # THE CONDITION IS THE PRODUCER'S OWN. finalize_terminal_result() refuses to
  # write without RUN_ID and LOG_DIR; asking the same question here means the two
  # cannot disagree, and it is why publishing is added without adding an
  # eligibility flag, a readiness state or a second notion of "far enough along".
  #
  # WHAT MAKES IT SAFE IS THE HOIST, NOT THIS LINE. Every fact the record collects
  # — foreign_worktree(), allowlisted_dirty(), partial_effect_paths(),
  # remaining_seconds() — is defined ABOVE the block that raises RUN_ID (see that
  # section's note). Without that ordering this guard would publish records whose
  # working-tree counts were fabricated `0`s from producers that did not yet
  # exist, which is the Unit 21 and Unit 24 defect reintroduced one window over.
  #
  # THE WINDOW BEFORE RUN IDENTITY IS STILL DELIBERATELY ON THE OLD PATH, and it
  # is left there rather than approximated: the finalizer would refuse it at its
  # own guard, and routing that refusal through die_terminal_unprovable would turn
  # a clean interruption — of a run that had written nothing anywhere — into an
  # unprovable-ending 38. It is asserted as such rather than merely claimed.
  #
  # THE RECORD DISTINGUISHES THE TWO WINDOWS ITSELF. `stage`, `actor_launched` and
  # `model_request_started` all derive from ACTOR_PROCESS_STARTED, so a pre-launch
  # interruption publishes pre-hop/no/no and a post-launch one publishes
  # post-hop/yes/no. Widening the guard therefore adds a record; it does not blur
  # the distinction Unit 23 established, and the terminal label follows the same
  # fact so a refusal names the window it actually fired in.
  #
  # PINNED BEATS RELEASED, unchanged. report_teardown() above may already have
  # pinned the lease on an unverified teardown; release_lock() honours that inside
  # the lease library, so publishing here cannot buy a release the teardown refused.
  #
  # One line each with its own marker, so a mutation control can delete either half
  # without leaving an orphaned block behind (case 27t / M29), or rewrite either
  # guard back to the fork fact to isolate the widening alone (case 27v / M31).
  local term_label="the interruption terminal after a launched actor"
  [ "${ACTOR_PROCESS_STARTED:-0}" -eq 1 ] || term_label="the interruption terminal before any actor launched"
  [ -n "${RUN_ID:-}" ] && [ -n "${LOG_DIR:-}" ] && { finalize_terminal_result 28 || die_terminal_unprovable "$term_label"; } # interruption terminal finalization
  # THE EXPECTED PAIR COMES FROM THIS CALLER, the last of the four production
  # consumers to supply one and the simplest of them. The code is the literal 28
  # the finalization above published under and the `exit 28` below returns; the
  # symbol is `result_outcome()`'s answer for that code, the sole code-to-outcome
  # owner. Code 28 has no branch inside that owner — it is a constant-table entry
  # — so this expectation depends on no mode flag, no lifecycle class and no fork
  # fact, and it is identical in both windows this seam serves.
  #
  # WHICH IS WHY THE PAIR IS NOT SPLIT BY WINDOW, though the label is. What the
  # record must AGREE with is the ending; what a refusal must NAME is where it
  # fired. A pre-launch and a post-launch interruption are the same ending — the
  # record tells them apart through `stage`, `actor_launched` and
  # `model_request_started`, which are required fields and not this comparison's
  # business. Deriving a second expectation per window would invent a distinction
  # the vocabulary does not have.
  #
  # WITHOUT THIS, THE GAP WAS REAL AND MEASURED here too: a record altered after
  # finalization to `outcome=COMPLETED` — the word for a task driven to its end,
  # over a run a signal stopped mid-hop — still exited 28, was advertised as this
  # run's terminal result and released both leases after a clean teardown. So did
  # one altered to `code=22`. Path, structure and identity have nothing to object
  # to; only meaning does.
  #
  # THE GUARD AND THE LABEL ARE UNCHANGED. The same run-evidence eligibility
  # condition as the finalization line above it (Unit 25), and the same dynamic
  # `term_label`, which is simply followed positionally by the pair it now
  # precedes. Both mutation controls that address this seam still see what they
  # address: M29 matches the marker, M31 matches the guard.
  [ -n "${RUN_ID:-}" ] && [ -n "${LOG_DIR:-}" ] && consume_terminal_result "$term_label" "$(result_outcome 28)" 28 # interruption terminal consumption
  if [ -n "$RESULT_FILE" ]; then
    printf '  terminal result: %s\n' "$RESULT_FILE" >&2
    [ -n "${RUN_LOG:-}" ] && printf '  terminal result: %s\n' "$RESULT_FILE" >>"$RUN_LOG"
  fi

  release_lock
  exit 28
}

trap 'release_lock' EXIT
trap 'on_signal INT'  INT
trap 'on_signal TERM' TERM

# THE LEASE IS NO LONGER ASKED FOR HERE. It is asked for BELOW the run-evidence
# block, and the move is the whole of this unit — see the marked call site there
# for why. What stays true at this point is the --status contract: the read-only
# branch immediately below exits before any of it, so it still takes no lease,
# creates no log directory and writes nothing.

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

  # Ownership, reported alongside liveness because the two answer different
  # questions and an operator holding only one of them cannot act. Liveness says
  # "is a run going?"; ownership says "does this task belong here?". Read-only,
  # like everything else in this branch: the declaration is CAT'd, never written,
  # and no lock is taken.
  # Through owner_declaration(), the same reader the terminal record uses, so the
  # operator's screen and the machine-readable record cannot disagree about who
  # this checkout declares.
  OWNER_DECL="$(owner_declaration)"
  case "$OWNER_DECL" in
    none)        printf 'owner: this checkout declares no writer (no logs/work-loop/.owner)\n' ;;
    unavailable) printf 'owner: this checkout has a declaration it cannot read (logs/work-loop/.owner)\n' ;;
    *)           printf 'owner: this checkout declares %s\n' "$OWNER_DECL" ;;
  esac
  # WHO holds it, not only WHICH TASK. This line named a task and left the
  # holder to be assumed, and the assumption an operator makes from a dispatcher's
  # own output is "a dispatcher" — wrong whenever an attended carry holds the
  # lease, which is the case the shared lease exists to make possible.
  #
  # It renders through holder_label(), the same formatter the acquisition
  # refusals use, so the two surfaces cannot drift apart again. That function
  # reads WL_LEASE_HOLDER_*, so the lease's own metadata is loaded first —
  # wl_lease__read_holder only `cat`s the four files, which keeps this branch as
  # read-only as the rest of --status.
  if [ -d "$CHECKOUT_LOCK_DIR" ]; then
    wl_lease__read_holder "$CHECKOUT_LOCK_DIR"
    printf 'checkout-lock: HELD by %s running task %s (%s)\n' \
      "$(holder_label)" "${WL_LEASE_HOLDER_TASK:-an unrecorded task}" "$CHECKOUT_LOCK_DIR"
  else
    printf 'checkout-lock: free (%s)\n' "$CHECKOUT_LOCK_DIR"
  fi

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
    # The task lease's own holder metadata, for the two branches below that say
    # something about WHO is there. Read after the checkout branch above, which
    # loaded the OTHER lease into the same variables — each site re-reads the
    # lease it is about rather than inheriting the previous one.
    wl_lease__read_holder "$LOCK_DIR"
    st_who="$(holder_label)"
    # Three states, not two. See pid_state() above for why "kill -0 failed" is
    # not the same question as "the process is gone".
    st_probe="$(pid_state "$st_pid")"
    st_pid_state="${st_probe%%|*}"    # LIVE | ABSENT | UNKNOWN
    st_pid_why="${st_probe#*|}"       # the evidence behind that verdict
    case "$st_pid_state" in
      LIVE)
        printf 'run: IN FLIGHT — %s at pid %s holds %s\n' "$st_who" "$st_pid" "$LOCK_DIR"
        printf '     do not edit the state file by hand until it exits.\n'
        printf '     to stop it: kill -TERM %s\n' "$st_pid"
        # The exit code belongs to THIS program, so it is claimed only when this
        # program is the holder. Printed unconditionally it told the operator
        # what to expect from a carrier's SIGTERM handling, which this script
        # does not define and cannot promise.
        [ "${WL_LEASE_HOLDER_PROGRAM:-}" = dispatch ] &&
          printf '     (a dispatcher terminates its actor and exits 28.)\n'
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
        # WHAT THE LEASE SAYS, stated separately from what this branch could not
        # establish. The pid is uninspectable; the recorded holder is not, and it
        # is the one thing that tells the operator which process to go and look
        # for. The old line asserted a dispatcher here — the least safe place to
        # guess, because the whole verdict is that nothing could be confirmed.
        printf '     the lease records its holder as %s.\n' "$st_who"
        printf '     THE HOLDER MAY STILL BE LIVE. Treat the run as possibly in flight:\n'
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

# --------------------------------------------------------- repository state
#
# HOISTED ABOVE THE RUN-EVIDENCE BLOCK (Unit 25; first hoisted at Unit 21, and
# again at Unit 24 for remaining_seconds). Everything in this section is a pure
# function definition, so its position carries no ordering semantics of its own —
# with one exception, and that exception is why the section sits HERE, above the
# block that raises RUN_ID and LOG_DIR, rather than anywhere below it.
#
# finalize_terminal_result() collects four of its fields by calling
# foreign_worktree(), allowlisted_dirty(), partial_effect_paths() and
# remaining_seconds(). RUN_ID and LOG_DIR are what make that function willing to
# write at all — its own first guard — so the instant the block below raises them,
# every producer it calls must already exist. While this section came AFTER that
# block, two separate windows ran finalization against functions that did not yet
# exist: the --unattended gate's six exit-31 sites (Unit 21, and Unit 24 for the
# deadline field), and now the signal handler, which from Unit 25 publishes for
# any interruption arriving after run identity exists.
#
# THE SYMPTOM WAS NOT AN ABSENT FIELD. `0` is a positive, checkable claim that the
# working tree held no foreign paths and no uncommitted allowed paths — written by
# a check that never ran, and false whenever the tree was in fact dirty. An empty
# value would have been questioned; a plausible one was not.
#
# So the constraint this position encodes is stronger than the one Unit 21 wrote,
# and it is stated as the stronger rule because the weaker one no longer covers
# the handler: THIS SECTION MUST PRECEDE THE RUN-EVIDENCE BLOCK BELOW. Every
# terminal that can finalize — top-level die(), the unattended gate, the signal
# handler — becomes reachable at or after that block, so preceding it is what
# makes "the producers exist" true for all of them at once, without a readiness
# flag any of them could forget to consult. Moving this section back down, or
# adding a stopping preflight above it, reintroduces the same fabricated fact.

git_head() { git -C "$CHECKOUT" rev-parse HEAD 2>/dev/null; }

# Working-tree lines NOT covered by the allowlist. Any change here during an
# actor run is an unexpected repository effect.
#
# THE ALLOWLIST IS THE ONLY THING THAT EXCUSES A PATH, and that is the whole
# contract rather than a simplification of one. Between 2026-08-18 and this
# revision a second question was asked here: is this untracked path nothing but
# an EARLIER dispatcher run's own evidence, recognised by reading the run log
# header the artifacts were written under? It was built so that a run aimed at a
# new --log-dir would not stop over the previous run's evidence, and it was
# removed because nothing in the working tree can answer it safely.
#
# WHY IT CANNOT BE MADE SAFE. The receipt it read is a file in the checkout, and
# anything with write access to the checkout can write one. Freezing the answer
# before the first launch closes it against THIS run's actors, and that much
# worked; it cannot close it against content that was already there — a killed
# previous hop, another process, or anyone else — because there is nothing to
# tell a real receipt from a forged one BY. A secret the dispatcher holds and an
# actor cannot write would be one, and that is the persistent authority store the
# approved plan excludes.
#
# WHAT REPLACES IT IS AN OPERATING RULE, NOT A MECHANISM: one stable evidence
# location per checkout. Reuse the default, or one chosen --log-dir; that
# location is allowlisted for the run at the LOG_REL block, so sequential runs
# aimed at it are the ordinary supported path and never meet this function.
# Aiming a later run at a different directory while the old one is still
# untracked stops at 18 and names the old path, which is a safe, actionable
# refusal the operator resolves once — not an automatic migration. See the
# README's "One stable evidence location per checkout".
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
# ONE PATH IS EXCLUDED, and it is the dispatcher's own bookkeeping rather than
# the actor's work: the run directory, ADDED to the allowlist by this script at
# the LOG_REL block. Without that exclusion every stop would report the
# dispatcher's own evidence files back to the operator as "work the hop did and
# did not commit". That is not merely noisy: it is the same class of false
# statement O2 exists to remove.
#
# There used to be a SECOND exclusion, logs/session-notes.md, added for the
# legacy session-identity init this dispatcher no longer performs (Tracer 4).
# It went out with the init: the dispatcher writes no session note, so an
# uncommitted session-notes.md in this checkout is now somebody else's work and
# hiding it from partial-effect accounting would be the false statement rather
# than the fix. It is not in the allowlist either, so it reaches this function
# only when the operator passed it explicitly — in which case reporting it is
# exactly right.
allowlisted_dirty() {
  local line p
  git -C "$CHECKOUT" status --porcelain --untracked-files=all 2>/dev/null | while IFS= read -r line; do
    p="${line:3}"
    p="${p%\"}"; p="${p#\"}"
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
# The delta itself, as lines. Split out of partial_effect_block() so the terminal
# result can COUNT the same paths the operator is shown, without a second
# derivation of "what did this hop leave behind" (plan § 8 — one production owner
# per seam). The prose block below is the only other caller; if these two ever
# disagreed, the operator's message and the machine record would describe
# different runs, which is precisely the drift the plan forbids.
partial_effect_paths() {
  [ "${HOP_BASELINE_READY:-0}" -eq 1 ] || return 0
  local after
  after="$(allowlisted_dirty_snapshot)"
  if [ -n "$HOP_ALLOWED_SNAPSHOT" ]; then
    comm -13 \
      <(printf '%s\n' "$HOP_ALLOWED_SNAPSHOT") \
      <(printf '%s\n' "$after") | cut -f2-
  else
    printf '%s\n' "$after" | cut -f2-
  fi
}

partial_effect_block() {
  [ "${HOP_BASELINE_READY:-0}" -eq 1 ] || return 0

  local dirty
  dirty="$(partial_effect_paths)"
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

# Seconds left on the whole-run clock. Prints a very large number when no
# deadline was set, so callers can use min() unconditionally without branching.
#
# HOISTED HERE FOR THE SAME REASON THE SECTION ABOVE WAS (Unit 24). This is a
# pure fact producer, so its position carries no semantics of its own — except
# that finalize_terminal_result() calls it whenever DEADLINE_AT is set, and the
# --unattended gate exits 31 in six places. While this definition sat next to its
# first in-loop caller, every one of those six ran finalization against a function
# that did not yet exist: bash reported `command not found`, the command
# substitution produced an empty string, and `deadline_remaining_seconds` went out
# EMPTY beside `result_complete=yes` — a record certifying itself complete while
# missing a required field. The empty value is the tell, and it is the same defect
# class Unit 21 removed one section up; only that section was hoisted then, and
# this fact was not in it.
#
# It travels with that section, and the section's own note above states the
# constraint both now carry: THIS DEFINITION MUST PRECEDE THE RUN-EVIDENCE BLOCK.
# Moving it back down, or adding a stopping preflight above it, reintroduces the
# empty field.
remaining_seconds() {
  if [ -z "$DEADLINE_AT" ]; then printf '%s' 2147483647; return 0; fi
  local left=$(( DEADLINE_AT - $(date '+%s') ))
  [ "$left" -lt 0 ] && left=0
  printf '%s' "$left"
}

# ------------------------------------------------------------ run evidence
#
# OPENED BEFORE THE LEASE IS ASKED FOR, and the position is the whole point.
#
# IT USED TO SIT BELOW acquire_lock, and that was right under the old boundary
# and wrong under the approved one. The old reading was that winning the lease IS
# admission, so a run refused at 17 had "lost admission" and was entitled to
# nothing inside the checkout; its evidence went to a standalone `.refusal` record
# under the shared lease root instead. The revised plan moves the boundary: a run
# exists once task, checkout and evidence location are supplied and trusted, all
# of which happened far above this line. A lease refusal is therefore a terminal
# of an ADMITTED run, and Change set A requires exactly one run-bound terminal
# result for it — which cannot exist while run identity and the evidence location
# are created only after the lease is won. So the lease call moved down past this
# block rather than this block moving up past the lease: same ordering, expressed
# as one move, with the read-only --status branch still above both.
#
# WHAT IS DELIBERATELY NOT REOPENED. The old arrangement's second reason was
# real and remains respected: a run must not scribble in a working tree on
# somebody else's account. It does not apply to a refused run's own evidence
# location, because that location is this run's, was named by the operator, and
# is allowlisted below exactly as an admitted run's always was.
#
# `--status` NEEDS NO GUARD HERE, and its absence is still stronger than a flag.
# The branch above exits 0 on every path, so this block stays structurally
# unreachable in status mode rather than conditionally skipped — the read-only
# contract case 30 and case 12h assert is still a property of the control flow,
# and it is now the ONLY thing standing between --status and a log directory,
# since the lease call no longer sits above it.
# `--dry-run` is NOT excluded: it takes both leases, so it is an admitted run and
# its evidence belongs where every admitted run's does.
#
# WHETHER THIS LOCATION IS USABLE WAS SETTLED AT ADMISSION, above
# check_evidence_location, which refuses an unusable or untrusted one before any
# lease is asked for. The two lines below are the CREATION, which stays here
# because only an admitted run may write inside the checkout. The mkdir guard is
# kept even so: admission proved the location was usable then, and this is where
# it is actually used — a check that cannot fail is not a check (§ 6 rule 5), and
# the interval between the two is real.
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
  # Said out loud because it is the risk the operator walks away on. "none" is a
  # statement about the OPERATOR's set only: it means no extra rule was supplied,
  # NOT that nothing is denied. Since O1 the attended path always denies the four
  # nested-actor rules, and --unattended always carries the contained profile's
  # own base denies — so the old wording ("no tool denied beyond the child's own
  # policy") became false on both paths and is deliberately not restored.
  # Beyond those sets the child's own policy applies, which is no longer this
  # checkout's bypassPermissions on an attended hop — P0-F states
  # --permission-mode default at launch — but a permission mode only makes the
  # child ASK, and network is not coverable this way in any case:
  # runs/probe-unattended-authority-2026-08-07.md.
  say "claude_deny=none — no EXTRA deny rule was supplied by the operator; this does NOT mean nothing is denied (see the nested_actor_deny line below, and the contained profile's own denies under --unattended). Beyond those, the child's own policy applies (attended hops run --permission-mode default)"
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

# Recorded at preflight, not at the stop. Whether exit 37 can name the denied
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
  say "denial_parser=jq — a permission stop (37) carries the denied tool and its EXACT target, untruncated"
elif python3 -c 'import json' >/dev/null 2>&1; then
  say "denial_parser=python3 — jq is unusable here; a permission stop (37) still carries the denied tool and its EXACT target, untruncated"
else
  say "denial_parser=none — neither jq nor python3 is usable here, so a permission stop (37) CANNOT name the denied tool and target; it will say so rather than guess"
fi

# ------------------------------------------------------------- the two leases
#
# ASKED FOR HERE, once run identity and the evidence location exist, and that
# order is this seam's whole content. A lease refusal is a terminal of an
# admitted run under the approved plan, so it owes exactly one run-bound terminal
# result — and finalize_terminal_result() refuses to write one without RUN_ID and
# LOG_DIR (see its guard). Asking for the lease first made that guard fire on
# every refusal, which is why the refusal used to need a durable record of its
# own. It no longer does: acquire_lock's refusals leave through die 17, the same
# single funnel every other nonzero terminal uses.
#
# STILL ABOVE EVERY MUTATING ACTION. The unattended profile below writes into the
# run's evidence directory, launch_actor forks a child, and the state file is
# read and written after that — none of it is reached without both leases. What
# moved above this line is exactly the run's own identity and its own evidence
# location, and nothing else.
#
# `--status` never reaches here: its branch exits 0 far above.
[ "$STATUS_MODE" -eq 1 ] || acquire_lock

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

# THE VALIDATOR IS THE ONE LIFECYCLE AUTHORITY (Tracer 3). This dispatcher used
# to read `task:` and `turn:` itself and infer closure from the body's headings.
# It now asks logs/scripts/work-loop-state.sh and keeps only its own exit
# meanings. There is no second parser here and no fallback: a validator that
# cannot run means the state is unestablished, which stops the run before
# anything launches or mutates.
STATE_BIN_REL='logs/scripts/work-loop-state.sh'

validate_state() { # sets ST_TURN and ST_CLASS; dies on any failure. Never mutates.
  [ -f "$STATE_FILE" ] || die 13 "state file missing: $STATE_FILE"
  [ -r "$STATE_FILE" ] || die 13 "state file unreadable: $STATE_FILE"

  local bin="$CHECKOUT/$STATE_BIN_REL" out rc
  [ -f "$bin" ] && [ -r "$bin" ] \
    || die 13 "the state validator is missing from this checkout: $bin
Recoverable next action: this dispatcher no longer classifies state itself, so it cannot continue without it. Restore the file, then re-run. Nothing was launched."

  out="$(bash "$bin" validate --checkout "$CHECKOUT" --task "$TASK" 2>&1)"; rc=$?
  case "$rc" in
    0) ;;
    14) die 14 "identity mismatch — filename says '$TASK' and the record disagrees."$'\n'"$out" ;;
    # The validator's BAD_BODY lands on this dispatcher's existing "neither shape"
    # code, so the exit meaning an operator already knows survives the cutover
    # rather than collapsing into a generic 15.
    16) die 26 "$out"$'\n'"Recoverable next action: read the file. If a hop died mid-write, restore or complete it, then re-run this dispatcher. No actor was launched." ;;
    10|11|12|13) die 13 "the state file cannot be used: $out" ;;
    *)  die 15 "$out" ;;
  esac

  ST_CLASS="$out"
  case "$ST_CLASS" in
    ACTIVE_CLAUDE)    ST_TURN=claude ;;
    ACTIVE_CODEX)     ST_TURN=codex ;;
    BLOCKED_OPERATOR) ST_TURN=operator ;;
    CLOSED)           ST_TURN=operator ;;
    *) die 15 "the validator returned an unrecognised classification '$ST_CLASS' — this dispatcher does not guess at state" ;;
  esac
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
# Since the Tracer 3 cutover this is not a question the dispatcher answers for
# itself. The heading comparison it used to run was an inference from body shape;
# the validator now owns that check alongside the explicit `status:` the record
# carries, and ST_CLASS was set by validate_state() before anything reached here.
closing_record_ok() {
  [ "${ST_CLASS:-}" = CLOSED ]
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
  # THE ONE PLACE A CHILD IS FORKED, so the one place that may record it. Every
  # launch path in launch_actor() funnels through here, and its pre-fork die()s
  # do not — which is precisely the distinction the terminal record needs.
  ACTOR_PROCESS_STARTED=1
  # WHICH actor that fork was for, recorded on the same line for the same reason.
  # CUR_ACTOR is read rather than passed because at THIS instant it is the actor
  # being forked by definition: the hop loop sets it immediately before calling
  # launch_actor() and clears it only once the hop is over, and launch_actor() is
  # the sole caller of this function. Should a later edit break that, this reads
  # empty and the permission field falls back to `none` — the fail-closed
  # direction, never a mode claimed for a launch that did not happen.
  LAUNCHED_ACTOR="${CUR_ACTOR:-}"
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

# remaining_seconds() USED TO BE DEFINED HERE, immediately above its first
# in-loop caller. It now sits with the terminal-result dependencies further up —
# see the note at its new position. Nothing else moved, and the clamp below reads
# it exactly as it always did: a function is resolved when it is CALLED, and every
# caller in this region runs long after either position.

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
  # THIS ATTEMPT HAS NOT FORKED YET. Cleared here rather than left standing, so a
  # stop in the four pre-fork die() paths below cannot answer with the PREVIOUS
  # hop's fork. Re-set by run_bounded() at the moment a child actually exists.
  # Unlike LAST_CAPTURE above, which names a file this function has already
  # created, this names an event that has not happened.
  LAUNCHED_ACTOR=""

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

# ------------------------------------------- legacy session identity (RETIRED)
# This dispatcher used to allocate a legacy session marker and append a
# `- Files in scope:` bullet to logs/session-notes.md before hop 1, so that
# .claude/hooks/check-foreign-staging.sh would read THIS run's footprint rather
# than a stale stranger's via its shared-marker fallback.
#
# REMOVED at Tracer bullet 4. Two independent reasons, and either alone is
# sufficient:
#
#   1. That hook is not wired. It exists at .claude/hooks/check-foreign-staging.sh
#      and is registered in NO settings layer — not this repository's
#      .claude/settings.json, not the workspace's, not the user's. Arming a guard
#      that never fires bought no protection; the claim that it did was the false
#      safety statement this removal retires. Whether to wire or retire that hook
#      is a separate decision and is expressly not taken here.
#   2. Work Loop v2 neither reads nor writes the legacy session-state system to
#      determine execution state (durable-state plan, fixed decision 12). A
#      dispatcher that allocates a marker and appends a session note IS the Work
#      Loop writing legacy session state, and it is the largest such write.
#
# What replaced it: nothing. Work Loop execution state is the task record, the
# validator's classification, the checkout declaration, repository/Git evidence,
# and the shared live leases — all of which this dispatcher already consults.
# The legacy session system is untouched and keeps working for the ordinary
# non-Work-Loop sessions that own it.
#
# Exit 32 (IDENTITY_INIT_FAILED) went with this block and is now a gap in the
# exit table, left as such rather than reused: a code that once meant "the
# identity init half-completed" must not come to mean something else.

# ------------------------------------------------------------------ the loop

validate_state
say "initial: turn=$ST_TURN sha256=$(file_hash "$STATE_FILE") head=$(git_head)"

# ------------------------------------------------------- ownership admission
# The locks above answer "is another dispatcher running?". They cannot answer
# "does this task belong to this checkout?", because a lock dies with its
# process and a task outlives one. That second question is the declaration's,
# and the dispatcher asks it at REPO depth — it may run git, so unlike
# interactive Codex it can see the other worktrees.
#
# Two things it catches that nothing else does: the same task already claimed in
# a DIFFERENT checkout, and a state file REPLICATED across checkouts with no
# declaration deciding which copy is authoritative. Both are refused here,
# before an actor is launched and therefore before anything is committed.
#
# THIS CHECK FAILS CLOSED. A checkout without the helper, or with one that
# cannot be read or cannot run, gets exit 35 and launches NOTHING — it does not
# skip with a visible line. The distinction that matters is between a check that
# ran and found nothing wrong and a check that never ran: only the first is
# evidence. Skipping put exactly the checkouts most likely to be wrong — older
# siblings and incomplete copies — back on the unguarded path this admission
# exists to close, and it did so silently enough to look like a pass.
#
# This is deliberately UNLIKE the session-identity init above, which skips when
# its allocator is absent. That one arms a tripwire; this one is the only thing
# standing between two writers and one checkout, so absence cannot mean proceed.
OWNER_HELPER="$CHECKOUT/logs/scripts/work-loop-owner.sh"
if [ -f "$OWNER_HELPER" ] && [ -r "$OWNER_HELPER" ]; then
  OWNER_OUT="$(bash "$OWNER_HELPER" check --checkout "$CHECKOUT" --task "$TASK" --depth repo 2>&1)"
  OWNER_RC=$?
  # The verdict is recorded BEFORE it is acted on, so a terminal result reports
  # the observed admission outcome rather than the fact that the code got here.
  case "$OWNER_RC" in
    0) OWNER_STATUS=proceed; say "ownership: PROCEED — $(printf '%s' "$OWNER_OUT" | sed -n 's/^reason: //p')" ;;
    3) OWNER_STATUS=refused; die 33 "ownership refused for task $TASK in $CHECKOUT"$'\n'"$OWNER_OUT"$'\n'"Recoverable next action: continue the task in the checkout named above, or close it there first. Nothing was launched." ;;
    4) OWNER_STATUS=ambiguous; die 34 "ownership is AMBIGUOUS for task $TASK in $CHECKOUT"$'\n'"$OWNER_OUT"$'\n'"Recoverable next action: this is not a failure to work around — decide which checkout owns the task, remove the copies that are not authoritative, and record the owner with \`work-loop-owner.sh claim\`. Nothing was launched." ;;
    *) OWNER_STATUS=check-failed; die 35 "the ownership check ran and failed (exit $OWNER_RC) in $CHECKOUT"$'\n'"$OWNER_OUT"$'\n'"Recoverable next action: ownership is unestablished, so nothing was launched. Fix or replace $OWNER_HELPER, then re-run." ;;
  esac
else
  OWNER_STATUS=unavailable
  die 35 "the ownership check is unavailable: $OWNER_HELPER is missing or unreadable in $CHECKOUT"$'\n'"Recoverable next action: ownership cannot be established without it, so nothing was launched and nothing was committed. Copy the helper into this checkout — or run the task in a checkout that carries it — then re-run."
fi

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
  # PROVEN BEFORE RELEASED — the same producer/consumer boundary as the operator
  # terminal, at the other successful end of a run. A dry-run is an ADMITTED run:
  # it holds both leases and owns run evidence, and until Unit 12 it was the last
  # N-family success that released and exited 0 leaving nothing behind. The
  # record it publishes truthfully carries mode=dry-run, stage=pre-hop,
  # actor_launched=no and model_request_started=no from this dispatcher's own
  # facts — nothing launched, and the record says so. Failure takes the accepted
  # routes unchanged: unprovable publication pins and exits 38 via
  # die_terminal_unprovable, an untrusted promised artifact via the consumer's
  # own die_terminal_untrusted. Each line carries its own marker so a mutation
  # control can delete exactly one seam and prove the other is not covering it.
  finalize_terminal_result 0 || die_terminal_unprovable # dry-run terminal finalization
  # THE EXPECTED PAIR COMES FROM THIS CALLER, exactly as at the operator seam and
  # for the same reason: the caller knows which terminal it is finalizing, and the
  # artifact merely asserts one. The code is the literal 0 the finalization above
  # published under and the `exit 0` below returns; the symbol is
  # `result_outcome()`'s answer for that code, the sole code-to-outcome owner.
  #
  # WHAT MAKES THAT ANSWER DRY_RUN_COMPLETE HERE IS `MODE`, not the task. That
  # branch is settled at argument parse and read before any lifecycle class, which
  # is Unit 14's accepted design — so this seam supplies the right expectation over
  # an active, closed or blocked task alike, without naming a symbol or holding a
  # second table. A preflight is a preflight whatever the task underneath it is.
  #
  # WITHOUT THIS, THE GAP WAS REAL AND MEASURED, and sharper here than anywhere:
  # a record altered after finalization to say `outcome=COMPLETED` — over a run
  # that launched nothing and asked nothing of a model — still exited 0, released
  # both leases and was advertised as this preflight's terminal result. So did one
  # altered to `code=22`. Structure, path and identity have nothing to object to;
  # only meaning does.
  # THE LABEL IS THIS SEAM'S OWN, and it is a correctness fix rather than a
  # nicety. `die_terminal_untrusted`'s default sentence is the OPERATOR
  # terminal's — "the run reached a real operator terminal" — and the bare call
  # that used to sit here inherited it, so every refusal at this seam described a
  # preflight as a terminal it never reached. That was survivable while the only
  # refusals here were hostile-path or swapped-record cases; the semantic gate
  # above makes it the ordinary refusal, printed to an operator who launched
  # nothing and is being told a loop terminal was reached.
  #
  # CARRIED, NOT RE-DERIVED, exactly as consume_terminal_result's own note says:
  # only this call site knows which terminal it is. The shared exit's wording,
  # its default, and the accepted operator-terminal sentence are all untouched —
  # this supplies the argument that was always available and never passed.
  consume_terminal_result "the admitted dry-run preflight terminal" "$(result_outcome 0)" 0 # dry-run terminal consumption
  [ -n "$RESULT_FILE" ] && say "  terminal result: $RESULT_FILE"
  release_lock
  exit 0
fi

hop=0
while :; do
  validate_state

  if [ "$ST_TURN" = "operator" ]; then
    say "hop=$hop turn=operator — stopping for the operator (core § 7). No further launches."
    # turn: operator has two causes and they are not the same message. Before the
    # cutover the dispatcher told them apart by whether `## Blocker` / `## Next
    # action` had survived — an inference from what happened to still be in the
    # file, which is why announcing an UNANSWERED question above an empty block
    # was possible at all (measured on the 2026-08-05 parallel proof, where both
    # tasks reached turn: operator by closing). The two are now separate
    # classifications and the record states which it is, so there is no third
    # "neither shape" outcome left to guess at here: a record that is neither was
    # already refused by validate_state above, before this loop began.
    if closing_record_ok; then
      say "The task is CLOSED: the state file carries the closing record and nothing"
      say "else — ## Outcome, ## Decisions that matter, ## Evidence and"
      say "## Accepted limitations. There is no unanswered question here."
      say "The closing record is at $STATE_FILE."
    else
      op_q="$(operator_question)"
      say "The question below is UNANSWERED. Neither model nor this dispatcher answered it,"
      say "and nothing here is a decision — the operator owns it (core § 7)."
      say "--- state file, as the actors left it ---"
      say "$op_q"
      say "--- end ---"
    fi
    # THE TWO SUCCESSFUL ENDS OF A LOOP, and until now the only two with no durable
    # evidence. Every nonzero terminal funnels through die() and finalizes a
    # run-bound record; these said their piece on screen, released the lease and
    # exited 0 leaving nothing behind — for precisely the outcomes an operator most
    # needs to be able to point at afterwards.
    #
    # BEFORE release_lock, deliberately, and the same ordering die() uses: a lease
    # may only be given up once the evidence of what happened exists. Reversing
    # these two lines would leave a window where the run looks finished and nothing
    # says how it finished.
    #
    # code 0 BECAUSE NEITHER IS A FAILURE. Which of the two it was lives in the
    # record's outcome and next_action, keyed on the canonical ST_CLASS — see
    # result_outcome() for why the exit code cannot carry that distinction itself.
    #
    # FAILS CLOSED. A terminal whose result cannot be written is a run that cannot
    # say how it ended, and exiting 0 there would be a success claim with no
    # evidence — the exact false report this whole change set exists to remove. And
    # it fails closed HOLDING ITS LEASES: die_terminal_unprovable pins both before
    # any release path runs, with the truthful cause recorded, so the unproven run
    # cannot hand its checkout to the next dispatcher. One line, so the mutation
    # control can delete the seam whole rather than leave an orphaned `fi` that
    # proves nothing.
    finalize_terminal_result 0 || die_terminal_unprovable # operator terminal finalization
    # CONSUMED BEFORE RELEASED. Finalization proves a record was written;
    # consumption proves the record at the promised path is the one this run
    # wrote — path-gated, structurally valid, identity-bound to this task,
    # checkout and run, AND carrying the ending this run is actually finalizing —
    # before that record is allowed to buy the lease release.
    # One line, its own marker, same reason as the seam above.
    #
    # THE EXPECTED PAIR COMES FROM THIS CALLER, NOT FROM THE RECORD, and both
    # halves are facts this seam owns before anything is read back. The code is
    # the literal 0 the finalization above published under and the `exit 0` below
    # returns — one value, written once on each line, so a reader can see they
    # are the same ending. The symbol is `result_outcome()`'s answer for that
    # code, the sole code-to-outcome owner, evaluated here from ST_CLASS and the
    # dispatcher's own mode flags — which is what makes ONE call cover both
    # canonical endings this branch serves: CLOSED yields COMPLETED and
    # BLOCKED_OPERATOR yields OPERATOR_TAKEOVER, without this seam knowing either
    # symbol or holding a second table.
    #
    # WITHOUT THIS, THE GAP WAS REAL AND MEASURED: a record altered after
    # finalization in `outcome` alone, or in `code` alone, still passed the path,
    # structure and identity boundaries — it is a genuine, correctly addressed
    # record of a DIFFERENT ending — exited 0, released both leases and was
    # advertised as this run's terminal result.
    #
    # THE LABEL IS DELIBERATELY EMPTY, not a new wording. It is the same absent
    # label this call always passed; it is written out only because the expected
    # pair has to follow it positionally, and die_terminal_untrusted's own
    # default is what keeps the accepted operator-terminal sentence unchanged.
    consume_terminal_result "" "$(result_outcome 0)" 0 # operator terminal consumption
    [ -n "$RESULT_FILE" ] && say "  terminal result: $RESULT_FILE"
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
      die_hop 37 "Claude was DENIED PERMISSION during hop $hop and could not complete the turn."$'\n'"Denied (tool :: target):"$'\n'"$denials"$'\n'"The denial happened at the CHILD's permission layer, not here — this dispatcher requested nothing that would have refused these. The child exits 0 when this happens, which is why it used to surface as exit 25 or 22 with no cause named."$'\n'"NOT retried: the same denial would recur."$'\n'"Operator decision required — this is a capability question, not a transport failure. Either grant the capability deliberately and re-run, or narrow the unit so it does not need it. Full capture: $LAST_CAPTURE"
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
    # (If that denial is in the capture, exit 37 above named it before reaching
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
    # THE LAST SUCCESSFUL END WITH NO DURABLE EVIDENCE, and the only POST-hop one.
    # Every nonzero post-hop terminal funnels through die() and finalizes; the two
    # pre-hop code-zero ends were closed at units 8 and 12. This one — the outcome
    # a courier exists to produce — said its piece on screen, released the lease
    # and exited 0 leaving nothing a later reader could point at. Same boundary,
    # same order, same fail-closed behaviour as the operator seam above: finalize,
    # then consume the exact promised artifact, and only then release. One line
    # each with its own marker, so a mutation control can delete either half.
    finalize_terminal_result 0 || die_terminal_unprovable "the carry-one terminal after one carried hop" # carry-one terminal finalization
    # THE EXPECTED PAIR COMES FROM THIS CALLER, the third seam to supply one and
    # the same argument the operator and dry-run seams make: this call site knows
    # which terminal it is finalizing, and the artifact merely asserts one. The
    # code is the literal 0 the finalization above published under and the
    # `exit 0` below returns; the symbol is `result_outcome()`'s answer for that
    # code, the sole code-to-outcome owner.
    #
    # WHAT MAKES THAT ANSWER CARRY_ONE_COMPLETE HERE IS THIS RUN, NOT THE TASK,
    # and both facts it turns on are the dispatcher's own: `CARRY_ONE`, settled at
    # argument parse, and `ACTOR_PROCESS_STARTED`, the fork this run really
    # performed. Both are already true at this line — it is inside the
    # `CARRY_ONE -eq 1` block, after a hop that launched an actor — which is what
    # lets ONE call cover all four reachable carried transitions without naming a
    # symbol or holding a second table. The dry-run branch is ordered ahead of the
    # carry-one one inside that owner, and a --carry-one --dry-run never reaches
    # here at all, so the preflight's own expectation is not disturbed.
    #
    # WITHOUT THIS, THE GAP WAS REAL AND MEASURED at this seam too: a record
    # altered after finalization to `outcome=COMPLETED` — the full loop's word for
    # a run that drove the task to its end, over a run that carried exactly one
    # hop — still exited 0, was advertised as this run's terminal result and
    # released both leases. So did one altered to `code=22`, the code for a hop
    # that made no transition, over a run whose transition table had just passed.
    # Path, structure and identity have nothing to object to; only meaning does.
    #
    # THE LABEL IS THE ACCEPTED ONE, unchanged and simply moved ahead of the pair
    # it now has to precede positionally. It is this seam's own truthful sentence
    # (Unit 16, finding F1), and the shared exit's default and wording are
    # untouched.
    consume_terminal_result "the carry-one terminal after one carried hop" "$(result_outcome 0)" 0 # carry-one terminal consumption
    [ -n "$RESULT_FILE" ] && say "  terminal result: $RESULT_FILE"
    release_lock
    exit 0
  fi
done
