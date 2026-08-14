#!/bin/bash
# work-loop-state.sh — the one read-only Work Loop v2 state validator.
#
# Capability A of the durable-state plan
# (plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md),
# implementing the accepted architecture's § 1 state contract and § 2 validator
# check list.
#
# ONE JOB. Given an exact checkout and task id, either emit exactly one
# classification word on stdout and exit 0, or exit nonzero with a diagnostic on
# stderr that names the violated invariant. It NEVER writes, never repairs, and
# never becomes a second state store. Guessing a repair is the failure mode this
# tool exists to remove: a consumer that cannot classify state must stop, not
# pick a representation and proceed.
#
# INACTIVE SEAM. At the commit that introduces this file, no runtime consumer
# calls it. Claude's command, the Codex skill, Reorient, work-loop-owner.sh, the
# attended carrier and the unattended dispatcher each still parse state their own
# way. That is deliberate: the validator must be proven against adversarial
# fixtures before anything stops understanding the old shape (plan § 2,
# dependency 2).
#
# THE CONTRACT IT ENFORCES, and nothing beyond it:
#
#   frontmatter   exactly the three keys task, status, turn — each once, no
#                 others. status in {active, blocked, closed}. turn in
#                 {claude, codex, operator}.
#   combination   only active/claude, active/codex, blocked/operator and
#                 closed/operator are legal. Lifecycle is explicit; it is never
#                 inferred from turn or from body shape.
#   identity      filename, supplied --task, and frontmatter task: must agree.
#   active|blocked body   exactly these five top-level headings, in this order:
#                 Objective and scope, Lane and unit, Latest result, Blocker,
#                 Next action — plus an OPTIONAL `## Brief`, which is the
#                 Codex-to-Claude handoff payload and is not a sixth state field.
#   closed body   exactly these four, in this order: Outcome, Decisions that
#                 matter, Evidence, Accepted limitations. No `## Brief`, and no
#                 active heading surviving.
#   content       Latest result and Next action must be non-empty. A blocked
#                 record's Blocker must name something real, not `None.`.
#
# DELIBERATELY NOT CHECKED, so a later reader does not mistake silence for
# coverage: emptiness of any section other than Latest result, Next action and a
# blocked Blocker. The accepted architecture's numbered check list stops there,
# and this unit implements that list rather than extending it.
#
# TOLERATED: a trailing `# comment` after a frontmatter value, matching the
# repository's existing fm_value() convention. It cannot widen what is accepted —
# every frontmatter value here is drawn from a closed set that contains no `#`.
#
# Usage:
#   work-loop-state.sh validate --checkout PATH --task ID
#
# Stdout on success — exactly one of:
#   ACTIVE_CLAUDE      active/claude   — Claude owes execution, correction or the closing write
#   ACTIVE_CODEX       active/codex    — Codex owes assessment or progression
#   BLOCKED_OPERATOR   blocked/operator— work waits on the decision named in Blocker
#   CLOSED             closed/operator — terminal
#
# Exit codes:
#   0   valid; the classification is on stdout
#   10  BAD_USAGE
#   11  BAD_CHECKOUT      the checkout is missing or cannot be canonicalized
#   12  BAD_TASK_ID       separator, traversal or illegal character in the id
#   13  BAD_STATE_PATH    missing, unreadable, symlinked, or outside the checkout
#   14  BAD_IDENTITY      frontmatter task: disagrees with the supplied id
#   15  BAD_FRONTMATTER   block, keys, values, or the status/turn combination
#   16  BAD_BODY          headings, their order, an unsupported heading, or
#                         required content that is empty
#
# Regression coverage: logs/scripts/work-loop-state.test.sh

set -uo pipefail

STATE_REL_DIR='logs/work-loop'

die() { printf 'STOP [%s] %s\n' "$1" "$2" >&2; exit "$1"; }

# ------------------------------------------------------------------ arguments

[ "$#" -ge 1 ] || die 10 "usage: work-loop-state.sh validate --checkout PATH --task ID"
CMD="$1"; shift
case "$CMD" in
  validate) ;;
  -h|--help) sed -n '2,70p' "$0"; exit 0 ;;
  *) die 10 "unknown command '$CMD' — expected validate" ;;
esac

CHECKOUT=""; TASK=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    # A dangling option — one whose value is missing because it is the last
    # argument — must fail closed here. Without the $# guard, `shift 2` on the
    # last argument silently shifts only what remains (Bash's shift with a
    # count greater than $# is a no-op past what is available, not an error),
    # so $1 never changes and the loop spins forever instead of reaching the
    # "is required" check below.
    --checkout) [ "$#" -ge 2 ] || die 10 "--checkout requires a value"; CHECKOUT="$2"; shift 2 ;;
    --task)     [ "$#" -ge 2 ] || die 10 "--task requires a value";     TASK="$2";     shift 2 ;;
    *) die 10 "unknown argument '$1'" ;;
  esac
done

[ -n "$CHECKOUT" ] || die 10 "--checkout is required"
[ -n "$TASK" ]     || die 10 "--task is required"

# The id is validated BEFORE any path is built from it, with the same rules
# work-loop-owner.sh and dispatch.sh apply. A validator that path-joined first
# would be a traversal primitive with a strict-looking check bolted on after.
case "$TASK" in
  */*|*'\'*|..|.|*..*|"") die 12 "task id rejected (path traversal or separator): $TASK" ;;
esac
printf '%s' "$TASK" | grep -qE '^[A-Za-z0-9][A-Za-z0-9._-]*$' \
  || die 12 "task id rejected (illegal characters): $TASK"

[ -d "$CHECKOUT" ] || die 11 "checkout is not a directory: $CHECKOUT"
CHECKOUT="$(cd "$CHECKOUT" && pwd -P)" || die 11 "cannot canonicalize checkout: $CHECKOUT"

STATE_DIR="$CHECKOUT/$STATE_REL_DIR"
STATE="$STATE_DIR/$TASK.md"

# --------------------------------------------------------------- path bounds
#
# Symlink first, and on the file itself rather than on what it resolves to:
# `-f` follows the link, so a symlinked state file would otherwise sail through
# every later check while the bytes read came from outside the checkout. The
# authoritative record is the file at the bound path, never a pointer to one.
[ ! -L "$STATE" ] || die 13 "state path is a symlink, which is never the authoritative record: $STATE"
[ -e "$STATE" ] || die 13 "state file does not exist: $STATE"
[ -f "$STATE" ] || die 13 "state path is not a regular file: $STATE"
[ -r "$STATE" ] || die 13 "state file is not readable: $STATE"

# The directory is canonicalized separately, which catches a symlinked
# logs/work-loop that the per-file test above cannot see.
STATE_DIR_REAL="$(cd "$STATE_DIR" && pwd -P)" || die 13 "cannot canonicalize state directory: $STATE_DIR"
[ "$STATE_DIR_REAL" = "$STATE_DIR" ] \
  || die 13 "state directory resolves outside the checkout: $STATE_DIR -> $STATE_DIR_REAL"

# ---------------------------------------------------------------- frontmatter
#
# Emits `key<TAB>value` per frontmatter line, or `!MALFORMED<TAB>line`.
# The verdict is carried in `st` and applied once in END: an `exit` inside a rule
# jumps to END, whose own exit status would otherwise overwrite it — the bug
# already documented in work-loop-owner.sh's task_is_closed().
fm_dump() {
  awk '
    BEGIN { st = 3 }
    NR == 1 { if ($0 != "---") { st = 2; exit } ; inb = 1; next }
    inb && $0 == "---" { st = 0; exit }
    inb {
      line = $0
      if (line ~ /^[[:space:]]*$/) { print "!MALFORMED\t(blank line)"; next }
      if (line !~ /^[A-Za-z_][A-Za-z0-9_-]*:/) { print "!MALFORMED\t" line; next }
      k = line; sub(/:.*$/, "", k)
      v = line; sub(/^[^:]*:/, "", v)
      sub(/[ \t]*#.*$/, "", v)
      sub(/^[ \t]+/, "", v); sub(/[ \t]+$/, "", v)
      print k "\t" v
    }
    END { exit st }
  ' "$1"
}

FM="$(fm_dump "$STATE")"; FM_RC=$?
case "$FM_RC" in
  0) ;;
  2) die 15 "no frontmatter: line 1 of $STATE is not '---'" ;;
  3) die 15 "unterminated frontmatter: no closing '---' in $STATE" ;;
  *) die 15 "frontmatter could not be read from $STATE" ;;
esac

fm_get() { printf '%s\n' "$FM" | awk -F'\t' -v k="$1" '$1 == k { print $2; found=1 } END { exit !found }'; }
fm_count() { printf '%s\n' "$FM" | awk -F'\t' -v k="$1" '$1 == k { n++ } END { print n + 0 }'; }

MALFORMED="$(printf '%s\n' "$FM" | awk -F'\t' '$1 == "!MALFORMED" { print $2; exit }')"
[ -z "$MALFORMED" ] || die 15 "frontmatter line is not a 'key: value' pair: $MALFORMED"

# Exactly the three approved keys. Both halves are load-bearing — an unknown key
# is a contract the consumers do not share, and a duplicated key means two
# readers can legitimately disagree about the same file.
UNKNOWN="$(printf '%s\n' "$FM" | awk -F'\t' '$1 != "task" && $1 != "status" && $1 != "turn" { print $1; exit }')"
[ -z "$UNKNOWN" ] || die 15 "unsupported frontmatter key '$UNKNOWN' — only task, status and turn are approved"

for k in task status turn; do
  n="$(fm_count "$k")"
  [ "$n" -ge 1 ] || die 15 "required frontmatter key '$k' is missing from $STATE"
  [ "$n" -le 1 ] || die 15 "frontmatter key '$k' appears $n times — it must appear exactly once"
done

FM_TASK="$(fm_get task)"
FM_STATUS="$(fm_get status)"
FM_TURN="$(fm_get turn)"

# ------------------------------------------------------------------ identity
#
# The filename already carries $TASK by construction, so comparing the
# frontmatter to the supplied id compares all three at once.
[ "$FM_TASK" = "$TASK" ] \
  || die 14 "identity mismatch — path and --task say '$TASK', frontmatter task: says '$FM_TASK'"

# ----------------------------------------------------- status, turn, and pair

case "$FM_STATUS" in
  active|blocked|closed) ;;
  "") die 15 "status: is empty — it must be one of active | blocked | closed" ;;
  *)  die 15 "status: '$FM_STATUS' is not one of active | blocked | closed" ;;
esac

case "$FM_TURN" in
  claude|codex|operator) ;;
  "") die 15 "turn: is empty — it must be one of claude | codex | operator" ;;
  *)  die 15 "turn: '$FM_TURN' is not one of claude | codex | operator" ;;
esac

# Four legal pairs, enumerated rather than derived. Every other combination is a
# file whose lifecycle and whose actor disagree, and no consumer may pick one.
case "$FM_STATUS/$FM_TURN" in
  active/claude)    CLASS="ACTIVE_CLAUDE";    SHAPE="open" ;;
  active/codex)     CLASS="ACTIVE_CODEX";     SHAPE="open" ;;
  blocked/operator) CLASS="BLOCKED_OPERATOR"; SHAPE="open" ;;
  closed/operator)  CLASS="CLOSED";           SHAPE="closed" ;;
  *) die 15 "illegal combination status: $FM_STATUS with turn: $FM_TURN — the only legal pairs are active/claude, active/codex, blocked/operator and closed/operator" ;;
esac

# --------------------------------------------------------------- body headings
#
# Fenced blocks are skipped. A state file's Brief routinely quotes Markdown, and
# a heading inside a fence is quoted text, not a state field — counting it would
# reject valid files for their own documentation.
headings() {
  awk '
    BEGIN { st = 3 }
    NR == 1 { if ($0 != "---") { st = 2; exit } ; inb = 1; next }
    inb && $0 == "---" { inb = 0; body = 1; st = 0; next }
    inb { next }
    body {
      if ($0 ~ /^[[:space:]]*```/) { fence = !fence; next }
      if (fence) next
      if ($0 ~ /^## /) { h = $0; sub(/^## /, "", h); sub(/[[:space:]]+$/, "", h); print h }
    }
    END { exit st }
  ' "$1"
}

HEADINGS="$(headings "$STATE")" || die 15 "frontmatter could not be re-read from $STATE"

case "$SHAPE" in
  open)   WANT='Objective and scope
Lane and unit
Latest result
Blocker
Next action' ;;
  closed) WANT='Outcome
Decisions that matter
Evidence
Accepted limitations' ;;
esac

# `## Brief` is dropped before the comparison rather than woven into it. That is
# exactly what "not a sixth state field" means: it may be present or absent and
# may sit anywhere among the state headings, and neither changes the contract the
# five must satisfy. It is not permitted in a closed record — a closing record
# carries no outstanding handoff.
BRIEF_N="$(printf '%s\n' "$HEADINGS" | awk '$0 == "Brief" { n++ } END { print n + 0 }')"
if [ "$SHAPE" = "closed" ] && [ "$BRIEF_N" -gt 0 ]; then
  die 16 "a closed record carries '## Brief' — the closing record is exactly the four closing headings"
fi
[ "$BRIEF_N" -le 1 ] || die 16 "'## Brief' appears $BRIEF_N times — at most one Brief is permitted"

GOT="$(printf '%s\n' "$HEADINGS" | grep -v '^Brief$' | grep -v '^[[:space:]]*$')"

# The two set differences are computed with `grep -vxF`, whose pattern argument
# is newline-separated fixed whole-line patterns. An earlier version passed the
# list through `awk -v`, which cannot carry an embedded newline — it failed at
# parse time and turned every heading diagnostic into an awk error.
not_in() { # candidates-on-stdin, set-as-$1 -> first candidate absent from the set
  if [ -z "$1" ]; then grep -v '^[[:space:]]*$' | head -1
  else grep -v '^[[:space:]]*$' | grep -vxF "$1" | head -1; fi
}

# Unsupported headings are named one at a time and before the order check, so the
# diagnostic points at the real fault instead of reporting a bewildering
# order mismatch caused by an extra heading.
UNSUPPORTED="$(printf '%s\n' "$GOT" | not_in "$WANT")"
[ -z "$UNSUPPORTED" ] \
  || die 16 "unsupported top-level heading '## $UNSUPPORTED' in a $FM_STATUS record"

if [ "$GOT" != "$WANT" ]; then
  MISSING="$(printf '%s\n' "$WANT" | not_in "$GOT")"
  if [ -n "$MISSING" ]; then
    die 16 "required heading '## $MISSING' is missing from this $FM_STATUS record"
  fi
  die 16 "state headings are out of order or repeated in this $FM_STATUS record — expected, in order: $(printf '%s' "$WANT" | tr '\n' '/' | sed 's:/:, :g'); got: $(printf '%s' "$GOT" | tr '\n' '/' | sed 's:/:, :g')"
fi

# --------------------------------------------------------- required content
#
# Reads one section's body: the lines under its heading up to the next top-level
# heading, fences respected so a fenced `## ` cannot end a section early.
section_body() {
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
  ' "$1"
}

nonblank() { printf '%s\n' "$1" | grep -q '[^[:space:]]'; }

if [ "$SHAPE" = "open" ]; then
  nonblank "$(section_body "$STATE" 'Latest result')" \
    || die 16 "'## Latest result' is empty — an open record states its last material result, or 'Not started.'"
  nonblank "$(section_body "$STATE" 'Next action')" \
    || die 16 "'## Next action' is empty — an open record always states exactly one next move"

  if [ "$FM_STATUS" = "blocked" ]; then
    BLOCKER="$(section_body "$STATE" 'Blocker')"
    nonblank "$BLOCKER" \
      || die 16 "status: blocked but '## Blocker' is empty — a blocked record must name the decision or condition that resolves it"
    # `None.` is precisely the contradiction: blocked means something is in the
    # way, so a blocker of "nothing" is a lifecycle that disagrees with itself.
    printf '%s' "$BLOCKER" | grep -q '^[[:space:]]*None\.[[:space:]]*$' \
      && die 16 "status: blocked but '## Blocker' says 'None.' — a blocked record must name a real decision or condition"
  fi
fi

printf '%s\n' "$CLASS"
exit 0
