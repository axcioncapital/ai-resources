#!/usr/bin/env bash
# research-route-judgment-authority.sh — the Standard route's adapter to approved judgment.
#
# WHAT THIS IS FOR. The Standard route may compare readings of the evidence on its own. It
# may not promote one of them to a governing view. Where an assignment genuinely needs an
# authorized thesis, the authority is the canonical Unit Judgment Brief, and the interface to
# it is `workflows/research-workflow/docs/judgment-authority-contract.md` § 6. This script is
# the whole of that binding for the lightweight lane: it resolves one unit's approved brief,
# asks L2's own validator whether it is authority, and either hands the APPROVED CONTENT back
# to the author or fails closed to a Deep escalation.
#
# WHAT IT DELIBERATELY IS NOT. It is not a second copy of the contract's rules. It re-checks
# nothing the contract checks; it branches on that checker's EXIT CODE and reports it. It
# writes nothing, approves nothing, promotes nothing and creates no artifact — the only
# helper it ever runs is `check-judgment-contract.sh`, and it reads two files.
#
# Usage:
#   research-route-judgment-authority.sh --unit <unit-id> --base <base-path> [--root <dir>]
#
#   --unit   the unit the judgment must cover. Compared against the approved brief's own
#            `unit:` frontmatter — a brief for another unit is not this unit's authority.
#   --base   the artifact base path, WITHOUT a suffix. The contract owns the three suffixes
#            (§ 1); this script only ever reads `{base}-approved.md`. A base already carrying
#            `-approved.md`, `-proposed.md` or `-review.md` is a usage error, so a caller
#            cannot aim the adapter at a proposal by writing the path out in full.
#   --root   the deployed project root that carries both the judgment artifacts and L2's
#            helpers. Defaults to the git top level of the working directory.
#
# Output on success (exit 0):
#   authority: VALID
#   unit: <unit>
#   approved: <path>
#   contract-exit: 0
#   theses: <n>
#   thesis: T<n> — <the thesis line>
#   --- approved content (begin) ---
#   <the approved brief, verbatim>
#   --- approved content (end) ---
#
# Output on every other outcome (exit 1 no authority, exit 2 bad usage):
#   authority: UNAVAILABLE
#   unit: <unit or (unresolved)>
#   contract-exit: <code|none>
#   reason: <one line>
#   escalate: deep
#
# There is no third outcome and no partial one. `authority: VALID` is printed at exactly one
# place in this file, after the checker returned 0 and the unit matched.
#
# Regression coverage: logs/scripts/research-route-l3-adapter-unit-1.test.sh

set -u

unit=""
base=""
root=""

fail_closed() { # <exit> <contract-exit> <reason>
  printf 'authority: UNAVAILABLE\n'
  printf 'unit: %s\n' "${unit:-(unresolved)}"
  printf 'contract-exit: %s\n' "$2"
  printf 'reason: %s\n' "$3"
  printf 'escalate: deep\n'
  exit "$1"
}

usage_error() { fail_closed 2 none "$1"; }

while [ $# -gt 0 ]; do
  case "$1" in
    --unit) [ $# -ge 2 ] || usage_error "--unit needs a value"; unit="$2"; shift 2 ;;
    --base) [ $# -ge 2 ] || usage_error "--base needs a path"; base="$2"; shift 2 ;;
    --root) [ $# -ge 2 ] || usage_error "--root needs a directory"; root="$2"; shift 2 ;;
    *) usage_error "unknown argument: $1" ;;
  esac
done

[ -n "$unit" ] || usage_error "--unit is required — authority is resolved for one named unit"
[ -n "$base" ] || usage_error "--base is required — the artifact base path, without a suffix"

case "$base" in
  *-approved.md|*-proposed.md|*-review.md|*-review-round-*.md)
    usage_error "--base must be the artifact base path without a suffix; the contract owns the suffixes and this adapter reads only '{base}-approved.md'" ;;
esac

if [ -z "$root" ]; then
  root="$(git rev-parse --show-toplevel 2>/dev/null)" \
    || usage_error "--root was not given and the working directory is not inside a git checkout"
fi
[ -d "$root" ] || usage_error "root is not a directory: $root"

case "$base" in
  /*) approved="$base-approved.md" ;;
  *)  approved="$root/$base-approved.md" ;;
esac

# The contract's own validator, at the path the contract publishes (§ 6, § 7). It is copied
# into a deployed project by /sync-workflow; an absent one means the binding cannot be
# established, which is a fail-closed condition and never a reason to proceed unvalidated.
checker="$root/logs/scripts/check-judgment-contract.sh"
[ -f "$checker" ] && [ -r "$checker" ] \
  || fail_closed 1 none "the published judgment-authority validator is unavailable at $checker — authority cannot be established, so none is claimed"

# No flags are ever passed. --allow-proposed exists to shape-check work on its way to a
# decision, and a consumer that used it would be accepting a proposal as authority.
checker_out="$(bash "$checker" "$approved" 2>&1)"
checker_rc=$?

if [ "$checker_rc" -ne 0 ]; then
  reason="$(printf '%s\n' "$checker_out" | sed -n 's/^reason: //p' | head -1)"
  [ -n "$reason" ] || reason="$(printf '%s' "$checker_out" | tr '\n' ' ' | sed 's/  */ /g')"
  [ -n "$reason" ] || reason="the validator refused the approved brief at $approved"
  fail_closed 1 "$checker_rc" "$reason"
fi

# Exit 0 settles shape, status and evidence basis. It does not settle whether this brief is
# THIS unit's judgment, because the caller names the unit and the artifact carries its own.
brief_unit="$(awk '
  NR==1 { if ($0 != "---") exit; inb=1; next }
  inb && $0 == "---" { exit }
  inb && $0 ~ /^unit:[[:space:]]*/ { sub(/^unit:[[:space:]]*/, ""); sub(/[[:space:]]+$/, ""); print; exit }
' "$approved")"

if [ "$brief_unit" != "$unit" ]; then
  fail_closed 1 "$checker_rc" "the approved brief at $approved covers unit '${brief_unit:-<absent>}', not the requested unit '$unit' — a judgment authorized for another unit does not govern this one"
fi

thesis_lines="$(grep -E '^### Thesis ' "$approved")"
thesis_count="$(printf '%s\n' "$thesis_lines" | grep -c '^### Thesis ' || true)"
[ "$thesis_count" -ge 1 ] \
  || fail_closed 1 "$checker_rc" "the approved brief at $approved enumerates no theses to trace downstream assertions to"

printf 'authority: VALID\n'
printf 'unit: %s\n' "$unit"
printf 'approved: %s\n' "$approved"
printf 'contract-exit: %s\n' "$checker_rc"
printf 'theses: %s\n' "$thesis_count"

n=0
while IFS= read -r line; do
  [ -n "$line" ] || continue
  n=$((n + 1))
  printf 'thesis: T%s — %s\n' "$n" "$(printf '%s' "$line" | sed -E 's/^### Thesis [0-9]+ [—-] *//')"
done <<< "$thesis_lines"

# The contract is explicit that a consumer which checks a brief EXISTS and then drafts from
# something else has proved nothing (§ 6). What the author receives is the approved text.
printf -- '--- approved content (begin) ---\n'
cat "$approved"
printf -- '--- approved content (end) ---\n'
exit 0
