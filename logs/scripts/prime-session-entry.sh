#!/usr/bin/env bash
# prime-session-entry.sh — THE executing owner of the /prime SESSION ENTRY.
#
# One owner performs the COMPLETE sequence: allocate the marker → append this session's
# marker-bearing header → stamp logs/.prime-mtime. In that order, which is load-bearing.
#
# Renamed and extended from `prime-marker.sh` on 2026-07-30 (stream
# 2026-07-30-prime-session-entry-ownership, slice S1). The predecessor allocated the marker and
# stopped there, leaving the header append and the mtime stamp to prose inside prime.md — so the
# "single owner" was only two thirds of one, and the two remaining writes were validated by reading
# rather than by running. Capability: prime-runtime-delegation
# (projects/axcion-ai-system-owner/development/prime-runtime-delegation.md). Protocol authority is
# docs/session-marker.md; this file is the implementation, not the protocol.
#
# WHY THIS IS A SCRIPT AND NOT PROSE IN prime.md
#   The logic below is pure deterministic shell, yet it lived inside an executable prompt — so it was
#   validated by READING rather than by RUNNING, and its one executing consumer
#   (logs/scripts/prime-allocator.test.sh) had to SCRAPE it out of markdown by awk, anchored on a
#   fence position, the literal string "Allocate N = 1", and an exact indent width. That scrape has
#   already failed once in a way that mattered: on 2026-07-14 the suite reported "12 passed, 0 failed"
#   while testing a stale copy containing NONE of that session's fix. A green run proved nothing about
#   what shipped. Code that something must execute belongs where it can be executed directly.
#
# CONTRACT
#   Usage:  prime-session-entry.sh "<WORK_DESC>"
#           WORK_DESC is REQUIRED — it is the work-description line recorded under the header. A
#           session entry with no work description is not a valid entry, so an empty or missing
#           argument is a hard error, never a silently skipped write.
#
#   cwd:    the repository root whose logs/ owns the marker sequence AND session-notes.md. The
#           CALLER locates this script by ABSOLUTE path and leaves cwd alone — that is what lets one
#           copy in ai-resources serve every consumer checkout while still writing into the CALLING
#           repository. (Before 2026-07-30 prime.md invoked it on a repository-relative path, which
#           resolved in 1 of the 32 roots carrying the call — logs/improvement-log.md:2211.)
#
#   stdout: exactly one line, "${TODAY} ${MARKER}" — same grammar as logs/.session-marker.
#
#   writes, in this order:
#           1. the atomic claim dir + owner breadcrumb (under the git common dir)
#           2. logs/.session-marker
#           3. logs/.session-marker-${CLAUDE_CODE_SESSION_ID}   (when that variable is set)
#           4. logs/session-notes.md  — "## ${TODAY} — Session ${MARKER}" plus the work line
#           5. logs/.prime-mtime      — session-notes.md's mtime, WHOLE SECONDS
#
#   exit:   0 on success; 1 with a message on a broken precondition.
#
#   .prime-mtime IS WHOLE SECONDS AND MUST STAY SO. Its consumers do integer arithmetic on the value
#   (session-start.md Step 0.5 computes DELTA against `stat -f %m`) and
#   logs/scripts/foreign-session-guard.sh:194 reads it through `tr -dc '0-9'`, which would silently
#   turn a fractional "1753….123456789" into a 19-digit integer. Do not "improve" the precision here.
#
#   Marker grammar, allocation semantics and the "## {date} — Session {MARKER}" header are UNCHANGED
#   from the prose blocks this replaces.
#
# TESTING SEAM
#   PRIME_SESSION_ENTRY_SOURCE_ONLY=1 loads the functions WITHOUT running main, so
#   logs/scripts/prime-allocator.test.sh can drive allocate_marker / append_work_entry /
#   stamp_prime_mtime individually — that is how the same-marker branch, the wrong-order control and
#   the injected-failure control are exercised. It is a test seam and nothing else: /prime never
#   sets it.

set -u

die () {
  printf 'prime-session-entry.sh: %s\n' "$1" >&2
  exit 1
}

# ---------------------------------------------------------------------------------------------
# 1. MARKER ALLOCATION
# ---------------------------------------------------------------------------------------------
# Sets the globals TODAY and MARKER and writes the two marker files. Deliberately NOT declared
# local — the caller and the test harness read them after the call returns.
allocate_marker () {
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

  if [ -f logs/.session-marker ]; then                       # (a) — seeds HIGH. Must stay first.
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
  # BOTH-OR-NEITHER WRITER INVARIANT (docs/session-marker.md § Both-or-neither writer invariant).
  # Identity oracle (Option 2'): a per-session-id marker file no concurrent allocation can clobber.
  # These two writes are ONE unit — never author a path that writes the shared file alone.
  [ -n "${CLAUDE_CODE_SESSION_ID:-}" ] && echo "${TODAY} ${MARKER}" > "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}"

  # Orphan cleanup is deliberately NOT here — it is owned by detect-concurrent-session.sh.
  # A date-based prune was a category error: a marker's date records when its session STARTED, never
  # whether it ENDED, so it deleted a live overnight session's marker (making that session invisible to
  # every guard) while leaving same-day ghosts armed. The SessionStart hook prunes on LIVENESS instead.
  # Do not re-add a date-based prune.

  return 0
}

# ---------------------------------------------------------------------------------------------
# 2. THE MARKER-BEARING HEADER
# ---------------------------------------------------------------------------------------------
# append_work_entry <TODAY> <MARKER> <WORK_DESC>
#
# Append-only. Nothing already in logs/session-notes.md is rewritten, and a foreign concurrent
# session's header is never touched.
append_work_entry () {
  _t="$1"; _m="$2"; _w="$3"
  _hdr="## ${_t} — Session ${_m}"

  # Literal whole-line grep (full-file, so immune to entry length; -Fx matches the em-dash and the
  # marker verbatim with no regex risk). Exit 1 means "not found → create", NEVER "command failed →
  # skip the write": suppressing this session's header breaks the /session-start Step 3 and
  # /session-plan Step 0 preconditions, both of which require it to exist.
  #
  # Foreign concurrent sessions write under their OWN marker-bearing headers (## YYYY-MM-DD — Session
  # S2); those do not count as this session's header. The marker is the disambiguator.
  if grep -Fxq "$_hdr" logs/session-notes.md 2>/dev/null; then
    # Same-marker re-invocation (rare). The header already exists, so add only the work line.
    printf '\n**Work:** %s\n' "$_w" >> logs/session-notes.md || return 1
  else
    # Trailing-newline safety FIRST: a file not ending in a newline would otherwise take the header
    # onto the end of its last line, and the `grep -Fxq` above could then never match it again.
    if [ -s logs/session-notes.md ] && [ -n "$(tail -c 1 logs/session-notes.md 2>/dev/null)" ]; then
      printf '\n' >> logs/session-notes.md || return 1
    fi
    # Then the blank separator line between the previous entry and this one.
    if [ -s logs/session-notes.md ]; then
      printf '\n' >> logs/session-notes.md || return 1
    fi
    printf '%s\n\n**Work:** %s\n' "$_hdr" "$_w" >> logs/session-notes.md || return 1
  fi
  return 0
}

# ---------------------------------------------------------------------------------------------
# 3. THE MTIME STAMP
# ---------------------------------------------------------------------------------------------
# Runs LAST, after the append has succeeded, so /session-start Step 0.5 sees THIS session's own
# write rather than a pre-write timestamp. Reversing steps 2 and 3 makes every session look like it
# was written by a foreign one. WHOLE SECONDS — see the CONTRACT note at the top of this file.
stamp_prime_mtime () {
  _mt=$(stat -f %m logs/session-notes.md 2>/dev/null || stat -c %Y logs/session-notes.md 2>/dev/null)
  case "$_mt" in
    ''|*[!0-9]*) return 1;;
  esac
  printf '%s\n' "$_mt" > logs/.prime-mtime || return 1
  return 0
}

# ---------------------------------------------------------------------------------------------
main () {
  [ "$#" -ge 1 ] || die 'usage: prime-session-entry.sh "<WORK_DESC>" — the work-description line to record under this session'"'"'s header.'
  WORK_DESC="$1"
  [ -n "$WORK_DESC" ] || die 'WORK_DESC is empty — a session entry without a work description is not a valid entry.'

  [ -d logs ] || die "no ./logs directory — run with cwd = the repository root (cwd is $(pwd))."

  # ORDER IS LOAD-BEARING: marker → header append → mtime stamp.
  # Marker first, so the header can embed ${MARKER}. mtime last, so the stamp reflects this session's
  # own append. Each step stops the sequence on failure rather than continuing into a partial state
  # the next /prime cannot distinguish from a complete one.
  allocate_marker                                   || die "marker allocation failed."
  append_work_entry "$TODAY" "$MARKER" "$WORK_DESC" || die "could not append this session's header to logs/session-notes.md."
  stamp_prime_mtime                                 || die "could not stamp logs/.prime-mtime."

  printf '%s %s\n' "$TODAY" "$MARKER"
}

# Test seam — see TESTING SEAM in the header block. /prime never sets this.
if [ "${PRIME_SESSION_ENTRY_SOURCE_ONLY:-0}" != "1" ]; then
  main "$@"
fi
