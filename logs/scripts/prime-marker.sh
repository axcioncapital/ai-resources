#!/usr/bin/env bash
# prime-marker.sh — allocate this session's marker. THE executing owner of marker allocation.
#
# Qualified by /develop-ai-resource on 2026-07-29 (capability: prime-runtime-delegation,
# projects/axcion-ai-system-owner/development/prime-runtime-delegation.md). Protocol authority is
# docs/session-marker.md; this file is the implementation, not the protocol.
#
# WHY THIS IS A SCRIPT AND NOT PROSE IN prime.md
#   The logic below is pure deterministic shell, yet it lived inside an executable prompt — so it was
#   validated by READING rather than by RUNNING, and its one executing consumer
#   (logs/scripts/prime-allocator.test.sh) had to SCRAPE it out of markdown by awk, anchored on a
#   fence position, the literal string "Allocate N = 1", and an exact indent width. That scrape has
#   already failed once in a way that mattered: on 2026-07-14 the suite reported "12 passed, 0 failed"
#   while testing a stale copy containing NONE of that session's fix (see that file's header, L8-16).
#   A green run proved nothing about what shipped. Code that something must execute belongs where it
#   can be executed directly.
#
# CONTRACT
#   Run with cwd = the repository root (the checkout whose logs/ dir owns the marker sequence).
#   stdout: exactly one line, "${TODAY} ${MARKER}" — same grammar as logs/.session-marker.
#   Writes: logs/.session-marker, and logs/.session-marker-${CLAUDE_CODE_SESSION_ID} when that is set.
#   Exit 0 on success; exit 1 with a message on a broken precondition.
#
#   Marker grammar, allocation semantics and the "## {date} — Session {MARKER}" header are UNCHANGED
#   from the prose block this replaces. Callers own the header write and the mtime stamp; this script
#   deliberately does not touch logs/session-notes.md.

set -u

[ -d logs ] || {
  printf 'prime-marker.sh: no ./logs directory — run from the repository root (cwd is %s).\n' "$(pwd)" >&2
  exit 1
}

TODAY=$(date '+%Y-%m-%d')

# Allocate N = 1 + the highest S{N} seen across FOUR sources, then CLAIM it atomically.
# Take the MAX of all four; never trust one alone (each sees a different slice of the
# same S{N} namespace):
#   (a) logs/.session-marker        — this checkout's last allocation.
#   (b) session-notes.md, worktree  — headers this checkout has written.
#   (c) session-notes.md, ALL refs  — headers a WORKTREE session allocated and COMMITTED.
#   (d) the shared claim dir        — allocations IN FLIGHT in any checkout, committed or not.
#
# (d) is the fix for the defect (a)-(c) cannot see. A git worktree is a separate checkout with its
# own (a) and its own (b), and (c) only sees what has been COMMITTED — so an UNCOMMITTED, in-flight
# allocation in another checkout is invisible to all three, and two checkouts hand out the SAME S{N}.
# The duplicate "## <today> — Session S{N}" header then lands the moment the branch merges, breaking
# the `grep -Fxq` "does my header exist" check that /prime, /session-start and /session-plan rely on.
# Real incidents: 2026-07-13 S6 (committed-header collision → fixed by (c)) and 2026-07-13 S11
# (uncommitted in-flight collision → (c) did not cover it; S12 yielded by hand).
#
# CLAIMING IS ATOMIC, NOT ADVISORY. `mkdir` is atomic on POSIX: exactly one caller can create a given
# directory, and every other caller gets EEXIST. The claim loop below is a genuine mutex across
# checkouts — not merely a narrower race window. Two allocations firing at the same instant CANNOT
# both win the same S{N}; the loser sees EEXIST and takes the next number.
#
# Do NOT "fix" this by making worktrees reserve markers up front — that reintroduces the shared
# allocator worktrees exist to remove. A claim is made at allocation time, by whoever allocates.
#
# FAIL-SAFE INVARIANT — LOAD-BEARING, DO NOT INVERT:
# HIGH is seeded from the marker file BEFORE any scan, and every scan below only ever RAISES it. So a
# git failure, a missing common dir, or running outside a git repo degrades to marker-file-only
# behaviour — it can NEVER reset HIGH to 0 and allocate S1 over an existing S5. Any future edit that
# scans first and consults the marker file second reintroduces exactly that destructive regression.
# (logs/friction-log.md, 2026-07-13.)
HIGH=0

if [ -f logs/.session-marker ]; then                         # (a) — seeds HIGH. Must stay first.
  PREV=$(cat logs/.session-marker)
  case "$PREV" in
    # SUFFIX-TOLERANT, AND THIS IS THE MOST DANGEROUS LINE IN THE ALLOCATOR.
    # Markers read "2026-07-14 S7-a4f", not just "2026-07-14 S7". A naive "${PREV##*S}" yields
    # "7-a4f", which the *[!0-9]* guard REJECTS — leaving HIGH=0, so the next allocation is S1 ON TOP
    # OF AN EXISTING S7: precisely the destructive regression the invariant above forbids, and it
    # would ship silently. Strip the date, strip the leading S, then strip the suffix — never
    # "##*S", which would also cut at an "S" inside the id suffix.
    "${TODAY} S"*) tok="${PREV#* }"; n="${tok#S}"; n="${n%%-*}"
                   case "$n" in ''|*[!0-9]*) ;; *) [ "$n" -gt "$HIGH" ] && HIGH="$n";; esac;;
  esac
fi

for n in $( { grep -hoE "^## ${TODAY} — Session S[0-9]+" logs/session-notes.md 2>/dev/null   # (b)
              git grep -hoE "^## ${TODAY} — Session S[0-9]+" \
                  $(git for-each-ref --format='%(refname)' refs/heads 2>/dev/null) \
                  -- logs/session-notes.md 2>/dev/null                                       # (c)
            } | grep -oE '[0-9]+$' ); do
  case "$n" in ''|*[!0-9]*) continue;; esac
  [ "$n" -gt "$HIGH" ] && HIGH="$n"
done

# (d) Shared claim dir. Empty CLAIMS => degrade to (a)-(c) silently and safely (fail-safe).
CLAIMS=""
GIT_COMMON=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
if [ -n "$GIT_COMMON" ] && [ -d "$GIT_COMMON" ]; then
  # `--path-format=absolute` is REQUIRED: the bare command returns a RELATIVE `.git` from a main
  # checkout but an ABSOLUTE path from a worktree. Without it this resolves against the wrong cwd.
  # (Verified 2026-07-13.)
  #
  # SCOPE the namespace by the cwd's path INSIDE the repo. Worktrees of one repo share a common dir
  # AND sit at the repo root (empty prefix) → they SHARE a claim namespace, which is exactly what the
  # mutex needs. But a project that is a plain SUBDIRECTORY of a repo — e.g. projects/axcion-website/,
  # which is NOT its own repo yet keeps its own logs/session-notes.md and therefore its own S{N}
  # sequence — would otherwise share a claim namespace with unrelated siblings under the same .git,
  # inflating its S{N}. Scoping keeps namespace == session-notes.
  SCOPE=$(git rev-parse --show-prefix 2>/dev/null | tr -d '\n' | tr -c 'A-Za-z0-9._-' '-')
  [ -z "$SCOPE" ] && SCOPE="_root"
  CLAIMS="$GIT_COMMON/axcion-session-markers/$SCOPE"
  mkdir -p "$CLAIMS" 2>/dev/null || CLAIMS=""
fi

if [ -n "$CLAIMS" ]; then
  # `find`, NOT a glob. Under ZSH an UNMATCHED glob triggers NOMATCH: the command errors and the loop
  # body never runs — which is exactly the state on the FIRST run of every day, in every repo. Under
  # bash the literal survives and `[ -d ]` skips it, so a bash-only test PASSES while zsh CRASHES.
  # Verified both ways, 2026-07-13. Do NOT "simplify" this back to a glob.
  for n in $(find "$CLAIMS" -mindepth 1 -maxdepth 1 -type d -name "${TODAY}-S*" 2>/dev/null \
             | sed 's|.*-S||'); do
    case "$n" in ''|*[!0-9]*) continue;; esac
    [ "$n" -gt "$HIGH" ] && HIGH="$n"
  done
  # Prune claims not dated today (bounded growth). -type d never follows symlinks here, and
  # -mindepth 1 plus the non-empty CLAIMS guard above make the rm -rf reach nothing outside this dir.
  find "$CLAIMS" -mindepth 1 -maxdepth 1 -type d ! -name "${TODAY}-*" -exec rm -rf {} + 2>/dev/null
fi

# SESSION-ID SUFFIX — this is what actually makes collisions IMPOSSIBLE rather than merely unlikely.
# The claim-dir mutex narrows the race but cannot close it: a checkout running an older copy of the
# allocator neither writes claims nor reads them, so it allocates blind (that gap produced FOUR real
# collisions in two days). A marker carrying 3 characters of this session's own id cannot collide with
# another session's marker no matter what N either picks, because no two sessions share an id. The
# uniqueness lives in the NAME, not in a lock every participant must honour. The mutex is retained as
# belt-and-braces — it still yields tidy sequential numbers — but is no longer load-bearing.
#
# Degrades safe: no CLAUDE_CODE_SESSION_ID (older CLI) → empty suffix → legacy bare S{N}. Readers
# accept both grammars.
ID3=$(printf '%s' "${CLAUDE_CODE_SESSION_ID:-}" | tr -cd 'A-Za-z0-9' | cut -c1-3)
if [ -n "$ID3" ]; then SFX="-${ID3}"; else SFX=""; fi

# Atomic claim loop. mkdir succeeds for exactly one caller; the loser bumps and retries.
N=$((HIGH + 1))
while : ; do
  if [ -z "$CLAIMS" ]; then MARKER="S${N}${SFX}"; break; fi   # no common dir → no mutex, old behaviour
  if mkdir "$CLAIMS/${TODAY}-S${N}" 2>/dev/null; then         # ← the atomic step
    MARKER="S${N}${SFX}"
    printf '%s\n' "${CLAUDE_CODE_SESSION_ID:-unknown} $(date '+%H:%M:%S')" \
      > "$CLAIMS/${TODAY}-S${N}/owner" 2>/dev/null            # debug breadcrumb; never read for logic
    break
  fi
  N=$((N + 1))
  if [ "$N" -gt 999 ]; then MARKER="S${N}${SFX}"; break; fi   # runaway guard — cannot spin forever
done

echo "${TODAY} ${MARKER}" > logs/.session-marker
# Identity oracle (Option 2'): a per-session-id marker file no concurrent allocation can clobber.
[ -n "${CLAUDE_CODE_SESSION_ID:-}" ] && echo "${TODAY} ${MARKER}" > "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}"

# Orphan cleanup is deliberately NOT here — it is owned by detect-concurrent-session.sh.
# A date-based prune was a category error: a marker's date records when its session STARTED, never
# whether it ENDED, so it deleted a live overnight session's marker (making that session invisible to
# every guard) while leaving same-day ghosts armed. The SessionStart hook prunes on LIVENESS instead.
# Do not re-add a date-based prune.

printf '%s %s\n' "$TODAY" "$MARKER"
