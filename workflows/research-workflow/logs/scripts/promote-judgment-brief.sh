#!/usr/bin/env bash
# promote-judgment-brief.sh — re-issue a REVIEWED proposal as the approved brief.
#
# WHAT THIS IS FOR. Approval is the one transition where a model could quietly
# change what a human signed off. The operator reads the proposal; the approved
# file is what governs every downstream artifact. If the re-issue is done by hand
# — or by an agent asked to "write the approved version" — nothing stops the
# theses drifting between the two, and nothing afterwards can detect it, because
# the approved file looks complete either way.
#
# So the promotion is mechanical and this script is the only thing that performs
# it. It changes STATUS AND THE BANNER AND NOTHING ELSE:
#
#   status: proposed  ->  status: approved
#   (adds)                approved_by: <the approving operator>
#   the PROPOSED banner -> the APPROVED banner
#
# Everything from `## Theses` down — theses, claim IDs, context, countercase,
# verdict and change conditions — is carried byte for byte, and the script
# refuses to write if it is not. That refusal is the point: the guarantee is
# enforced here rather than promised in an instruction a later editor can weaken.
#
# WHAT IT REFUSES, all of which are the whole reason it exists:
#
#   - a reply that is not an approval. Silence, a revision request, "not
#     approved", "rejected" — none of them can create the approved path.
#   - a proposal the operator has already REJECTED. A rejection is a decision,
#     and promoting over it would overturn the operator's own call.
#   - an approver that is absent or a placeholder. An approval with no real
#     approver is not an approval.
#   - overwriting an existing approved brief. A present-but-invalid authority is
#     a halt for the operator, not something to regenerate over.
#   - a proposal that has not been independently challenged with every
#     required-change finding disposed of. Delegated to
#     check-judgment-challenge.sh, so the refusal lands at the single transition
#     that creates downstream authority.
#
# VERDICTS, each with its own exit code:
#
#   3  NO-PROPOSAL          — no readable proposal at that path
#   4  NOT-AN-APPROVAL      — the operator's reply carries no approval
#   5  NO-APPROVER          — --approved-by is absent, empty or a placeholder
#   6  ALREADY-APPROVED     — an approved brief already exists at the paired path
#   7  INVALID-PROPOSAL     — the proposal fails its own shape check
#   8  PROMOTION-INVALID    — the promoted brief fails the authority validator
#   9  CONTENT-DRIFT        — the analytical content did not survive the re-issue
#  11  CHALLENGE-UNCLEARED  — the independent challenge is missing, stale, or
#                             carries a finding nobody has disposed of
#  13  REJECTED-PROPOSAL    — the operator rejected this brief
#   0  PROMOTED             — written, and validated as downstream authority
#
# Exit 10 is bad usage. ON EVERY NONZERO EXIT, NOTHING IS WRITTEN — the approved
# file is assembled in a temporary location and only moved into place once every
# check above has passed.
#
# Usage:
#   promote-judgment-brief.sh <path-to-proposed-brief> \
#       --approval "<the operator's verbatim reply>" \
#       --approved-by "<the approving operator's identity>"
#
# The approved path is DERIVED, never passed: `-proposed.md` -> `-approved.md`.
# The pairing is part of the contract and is not a caller's choice.
#
# Regression coverage: logs/scripts/promote-judgment-brief.test.sh

set -uo pipefail

PROPOSED=""; APPROVAL=""; APPROVED_BY=""
HERE="$(cd "$(dirname "$0")" && pwd -P)"
VALIDATOR="$HERE/check-judgment-contract.sh"
CHALLENGE="$HERE/check-judgment-challenge.sh"

die() { printf 'STOP [%s] %s\n' "$1" "$2" >&2; exit "$1"; }

verdict() { # VERDICT code reason...
  local v="$1" code="$2"; shift 2
  printf 'verdict: %s\n' "$v"
  [ "$#" -gt 0 ] && printf 'reason: %s\n' "$*"
  exit "$code"
}

# ------------------------------------------------------------------ arguments
[ "$#" -ge 1 ] || die 10 "usage: promote-judgment-brief.sh <proposed-brief> --approval \"<reply>\" --approved-by \"<identity>\""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --approval)    [ "$#" -ge 2 ] || die 10 "--approval needs a value"; APPROVAL="$2"; shift 2 ;;
    --approved-by) [ "$#" -ge 2 ] || die 10 "--approved-by needs a value"; APPROVED_BY="$2"; shift 2 ;;
    -h|--help) sed -n '2,70p' "$0"; exit 0 ;;
    -*) die 10 "unknown argument '$1'" ;;
    *) [ -z "$PROPOSED" ] || die 10 "only one proposal path is accepted; got a second: $1"
       PROPOSED="$1"; shift ;;
  esac
done
[ -n "$PROPOSED" ] || die 10 "a path to the proposed brief is required"
case "$PROPOSED" in
  *-proposed.md) ;;
  *) die 10 "the approved path is derived from a proposal ending '-proposed.md'; got: $PROPOSED" ;;
esac
[ -x "$VALIDATOR" ] || [ -f "$VALIDATOR" ] || die 10 "the authority validator is missing at $VALIDATOR — promotion cannot verify its own output"
[ -f "$CHALLENGE" ] || die 10 "the challenge gate is missing at $CHALLENGE — promotion cannot verify the brief was challenged"

APPROVED="${PROPOSED%-proposed.md}-approved.md"

# --------------------------------------------------------------- 3. NO-PROPOSAL
if [ ! -f "$PROPOSED" ] || [ ! -r "$PROPOSED" ]; then
  verdict NO-PROPOSAL 3 "no readable proposal at $PROPOSED"
fi

fm_value() { # key -> value | ""
  awk -v key="$1" '
    NR==1 { if ($0 != "---") exit; inb=1; next }
    inb && $0 == "---" { exit }
    inb {
      if ($0 ~ "^" key ":[[:space:]]*") {
        sub("^" key ":[[:space:]]*", "")
        sub(/[[:space:]]+$/, "")
        print
        exit
      }
    }
  ' "$PROPOSED"
}

# ---------------------------------------------------------- 13. REJECTED-PROPOSAL
# Checked before the approval reply, because a rejected brief must produce the
# same answer whatever reply is waved at it.
if [ "$(fm_value status)" = "rejected" ]; then
  verdict REJECTED-PROPOSAL 13 "this brief was rejected by $(fm_value rejected_by) — a rejection is the operator's decision and promotion would overturn it"
fi

# --------------------------------------------------------- 4. NOT-AN-APPROVAL
# A reply must actually approve. A negation anywhere in it disqualifies the whole
# reply: "not approved", "do not approve" and "approved once you fix X" are all
# replies a keyword search would happily read as consent.
if [ -z "$APPROVAL" ]; then
  verdict NOT-AN-APPROVAL 4 "no --approval reply was supplied — promotion requires the operator's verbatim approval, and silence is not approval"
fi
approval_lc="$(printf '%s' "$APPROVAL" | tr '[:upper:]' '[:lower:]')"
if printf '%s' "$approval_lc" | grep -qE '\b(not approved|not approve|do not approve|don.t approve|reject|rejected|revise|revision|changes required|once you|after you)\b'; then
  verdict NOT-AN-APPROVAL 4 "the reply carries a rejection, a conditional or a revision request — only an unconditional approval may promote a brief: $APPROVAL"
fi
if ! printf '%s' "$approval_lc" | grep -qE '\b(approve|approved|approval)\b'; then
  verdict NOT-AN-APPROVAL 4 "the reply contains no approval: $APPROVAL"
fi

# --------------------------------------------------------------- 5. NO-APPROVER
if [ -z "$APPROVED_BY" ]; then
  verdict NO-APPROVER 5 "--approved-by is required — an approval with no named approver is not an approval"
fi
approver_lc="$(printf '%s' "$APPROVED_BY" | tr '[:upper:]' '[:lower:]' | sed -E 's/^[[:space:]]+|[[:space:]]+$//g')"
case "$approver_lc" in
  ''|tbd|n/a|na|unknown|placeholder|operator|'the operator'|founder|'the founder'|name|'your name'|xxx|todo|'<name>'|'{name}')
    verdict NO-APPROVER 5 "--approved-by is a placeholder ('$APPROVED_BY') — the approved brief must record who actually approved it" ;;
esac
case "$APPROVED_BY" in
  \<*\>|\{*\}) verdict NO-APPROVER 5 "--approved-by is a placeholder ('$APPROVED_BY') — the approved brief must record who actually approved it" ;;
esac

# ------------------------------------------------------------ 6. ALREADY-APPROVED
if [ -e "$APPROVED" ]; then
  verdict ALREADY-APPROVED 6 "an approved brief already exists at $APPROVED — a present authority is a halt for the operator, not something to regenerate over"
fi

# ----------------------------------------------------------- 7. INVALID-PROPOSAL
if ! bash "$VALIDATOR" "$PROPOSED" --allow-proposed >/dev/null 2>&1; then
  verdict INVALID-PROPOSAL 7 "the proposal fails its own shape check — run '$VALIDATOR $PROPOSED --allow-proposed' to see why; a brief that is not structurally sound cannot become authority"
fi

# -------------------------------------------------------- 11. CHALLENGE-UNCLEARED
bash "$CHALLENGE" "$PROPOSED" >/dev/null 2>&1
ch=$?
if [ "$ch" -ne 0 ]; then
  verdict CHALLENGE-UNCLEARED 11 "the independent challenge did not clear (check-judgment-challenge.sh exit $ch) — run it directly for the specific reason; the brief cannot be promoted until it has been challenged against these exact bytes and every required-change finding is disposed of"
fi

# ------------------------------------------------------------------- assembly
# Split at `## Theses`. Everything from that heading down is copied verbatim and
# never regenerated, which is what makes the byte-for-byte guarantee checkable
# rather than merely asserted.
if ! grep -qF '## Theses' "$PROPOSED"; then
  verdict INVALID-PROPOSAL 7 "the proposal has no '## Theses' heading, so there is no analytical content boundary to carry across"
fi

TMPF="$(mktemp)"
trap 'rm -f "$TMPF"' EXIT

# One verbatim pass. Every line the edits do not name is reprinted unchanged,
# including blank lines — a command-substitution split would silently eat the
# blank line before `## Theses`, and "silently reformats the artifact" is a poor
# property for the script whose entire job is not altering it.
BANNER='**APPROVED — DOWNSTREAM AUTHORITY.** This brief was approved by the operator and re-issued mechanically. The analytical content below is byte-for-byte what was reviewed.'

awk -v approver="$APPROVED_BY" -v banner="$BANNER" '
  NR==1 && $0=="---" { print; inb=1; next }
  inb && $0=="---" {
    if (!seen_by) printf "approved_by: %s\n", approver
    print; inb=0; next
  }
  inb && /^status:[[:space:]]*proposed[[:space:]]*$/ { print "status: approved"; next }
  inb && /^approved_by:[[:space:]]*/ { printf "approved_by: %s\n", approver; seen_by=1; next }
  inb { print; next }

  # Body. Once `## Theses` is reached nothing is rewritten again, so the banner
  # rule can never reach the analytical content.
  /^## Theses/ { theses=1 }
  !theses && /^\*\*PROPOSED/ { print banner; next }
  { print }
' "$PROPOSED" > "$TMPF"

# ------------------------------------------------------------- 9. CONTENT-DRIFT
# The guarantee, verified rather than trusted: everything from `## Theses` down
# must hash identically in the source and the result.
src_tail="$(awk '/^## Theses/ {p=1} p' "$PROPOSED" | shasum -a 256 | cut -d' ' -f1)"
out_tail="$(awk '/^## Theses/ {p=1} p' "$TMPF" | shasum -a 256 | cut -d' ' -f1)"
if [ "$src_tail" != "$out_tail" ]; then
  verdict CONTENT-DRIFT 9 "the analytical content changed during re-issue (proposal $src_tail, promoted $out_tail) — nothing was written; what the operator read must be what governs downstream"
fi

# ---------------------------------------------------------- 8. PROMOTION-INVALID
if ! bash "$VALIDATOR" "$TMPF" >/dev/null 2>&1; then
  reason="$(bash "$VALIDATOR" "$TMPF" 2>&1 | tr '\n' ' ')"
  verdict PROMOTION-INVALID 8 "the promoted brief does not validate as downstream authority, so nothing was written: $reason"
fi

mv "$TMPF" "$APPROVED"
trap - EXIT

verdict PROMOTED 0 "wrote $APPROVED, approved by $APPROVED_BY — analytical content carried byte for byte (sha256 $src_tail) and validated as downstream authority"
