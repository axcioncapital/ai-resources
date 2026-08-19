#!/usr/bin/env bash
# check-judgment-contract.sh — the structural gate on a Unit Judgment Brief.
#
# WHAT THIS IS FOR. The Unit Judgment Brief is the single analytical authority
# between gap resolution and downstream writing (docs/judgment-authority-contract.md).
# Downstream steps must be able to fail closed on a brief that is absent, still a
# proposal, rejected, or unsupported by evidence. This is the machine-checkable
# half of that contract: it decides SHAPE, STATUS and the three SEPARATIONS,
# never analytical quality. Whether the theses are any good is the independent
# reviewer's judgment, not this script's.
#
# THE VERDICTS THIS EXISTS TO DISTINGUISH, each with its own exit code, so a
# caller can branch on which failure it hit rather than on prose:
#
#   3  MISSING        — no readable brief at that path
#   4  NOT-APPROVED   — a brief exists, but its status is not `approved`.
#                       Covers both a still-proposed brief and a REJECTED one:
#                       neither may govern downstream work, and a caller that
#                       only needs "may I proceed?" gets one answer.
#   5  NO-CLAIM-IDS   — approved, but no evidence basis at all
#   0  VALID          — accepted as downstream authority
#
# Exit 6 is every other structural failure — a missing required heading, a thesis
# count out of band, no countercase anywhere, and each of the three separation
# breaches below. Exit 10 is bad usage.
#
# THE THREE SEPARATIONS, and why they are mechanical here rather than left to the
# reviewer. The contract's whole purpose is keeping evidence, interpretation and
# Axcíon context apart; a separation that only exists in prose guidance is one a
# tired producer merges and nobody catches. Each rule is positional — it reads
# where a statement sits and what lead-in it carries — because a new identifier
# family would be one more thing to maintain and one more thing to get wrong:
#
#   THESIS-WITHOUT-EVIDENCE  — a thesis citing no claim ID is an interpretation
#                              with no evidence basis.
#   CONTEXT-AS-EVIDENCE      — a `Context:` line citing a claim ID is evidence
#                              wearing a context label. This is the precise move
#                              the separation exists to catch.
#   VERDICT-WITHOUT-EVIDENCE — a verdict citing no claim ID is context deciding
#                              the outcome.
#
# WHAT IS DELIBERATELY A WARNING AND NOT A REJECTION. The approved plan calls
# 500-800 words a TARGET length. A target enforced as a hard gate is a different
# rule from the one that was approved, so length is reported and never rejected.
# The regression suite pins that (V9) so a later edit cannot quietly promote it.
#
# Usage:
#   check-judgment-contract.sh <path-to-brief> [--allow-proposed]
#
#   --allow-proposed   check shape only, and do not require `status: approved`.
#                      For checking a proposed brief before review. A proposed
#                      brief still has a shape; it just is not authority yet.
#                      It does NOT accept a rejected brief — a rejection is a
#                      decision, not a stage on the way to one.
#
# Regression coverage: logs/scripts/check-judgment-contract.test.sh

set -uo pipefail

BRIEF=""; ALLOW_PROPOSED=0

# The canonical claim-ID families, per reference/quality-standards.md § Claim ID
# Invariant: the primary Q[n]-C[##] sequence and the GF[cluster]-C[##] gap-fill
# sequence. Letters are generalised because live artifacts also use forms like
# [Q2-A03]. This checks that an evidence basis is CITED, not that it resolves —
# resolution is the compliance-QC step's job, against the extracts.
CLAIM_ID_RE='\[(Q|GF)[0-9]+-[A-Z]+[0-9]+\]'
# The same pattern for awk's dynamic-regex form. awk -v processes escape
# sequences in the value, so `\[` would arrive as a bare `[` and open a bracket
# expression instead of matching a literal bracket. Doubling survives that pass.
AWK_CLAIM_RE='\\[(Q|GF)[0-9]+-[A-Z]+[0-9]+\\]'

die() { printf 'STOP [%s] %s\n' "$1" "$2" >&2; exit "$1"; }

verdict() { # VERDICT code reason...
  local v="$1" code="$2"; shift 2
  printf 'verdict: %s\n' "$v"
  [ "$#" -gt 0 ] && printf 'reason: %s\n' "$*"
  exit "$code"
}

# ------------------------------------------------------------------ arguments
[ "$#" -ge 1 ] || die 10 "usage: check-judgment-contract.sh <path-to-brief> [--allow-proposed]"
while [ "$#" -gt 0 ]; do
  case "$1" in
    --allow-proposed) ALLOW_PROPOSED=1; shift ;;
    -h|--help) sed -n '2,60p' "$0"; exit 0 ;;
    -*) die 10 "unknown argument '$1'" ;;
    *) [ -z "$BRIEF" ] || die 10 "only one brief path is accepted; got a second: $1"
       BRIEF="$1"; shift ;;
  esac
done
[ -n "$BRIEF" ] || die 10 "a path to the brief is required"

# ------------------------------------------------------------------ 3. MISSING
# Checked first and on its own, because "there is no authority" and "the authority
# is wrong" are different answers for the caller. An unreadable file counts as
# missing: a gate that cannot read its input has not established anything.
if [ ! -f "$BRIEF" ] || [ ! -r "$BRIEF" ]; then
  verdict MISSING 3 "no readable Unit Judgment Brief at $BRIEF — downstream steps that require an approved brief must not proceed"
fi

# --------------------------------------------------------------- frontmatter
# Read only the block between the first two `---` lines. A body line that happens
# to look like `status: approved` must never be able to approve a brief.
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
  ' "$BRIEF"
}

head -1 "$BRIEF" | grep -q '^---$' \
  || verdict STRUCTURE 6 "the brief has no frontmatter block — the first line must be '---'"

UNIT="$(fm_value unit)"
ARTIFACT="$(fm_value artifact)"
STATUS="$(fm_value status)"
AS_OF="$(fm_value as_of)"

[ -n "$UNIT" ]  || verdict STRUCTURE 6 "frontmatter has no 'unit:' — a brief that names no unit cannot be routed to one"
[ -n "$AS_OF" ] || verdict STRUCTURE 6 "frontmatter has no 'as_of:' — a judgment with no date cannot be checked for staleness"
[ "$ARTIFACT" = "unit-judgment-brief" ] \
  || verdict STRUCTURE 6 "frontmatter 'artifact:' is '${ARTIFACT:-<absent>}', expected 'unit-judgment-brief'"

# ------------------------------------------------------- 4. status and decision
# The point of the lifecycle contract: neither a proposal nor a rejection may
# govern downstream writing just because a file exists on disk.
case "$STATUS" in
  approved|proposed|rejected) ;;
  *) verdict STRUCTURE 6 "frontmatter 'status:' is '${STATUS:-<absent>}' — the only legal values are 'proposed', 'approved' and 'rejected'" ;;
esac

# An approval with no approver is not an approval; a rejection with no rejecter
# is not a rejection. Both are checked before the authority branch, so a
# malformed decision is reported as malformed rather than as a plain refusal.
if [ "$STATUS" = "approved" ] && [ -z "$(fm_value approved_by)" ]; then
  verdict STRUCTURE 6 "status is 'approved' but frontmatter has no 'approved_by:' — an approval with no approver is not an approval"
fi
if [ "$STATUS" = "rejected" ] && [ -z "$(fm_value rejected_by)" ]; then
  verdict STRUCTURE 6 "status is 'rejected' but frontmatter has no 'rejected_by:' — a rejection with no rejecter is not a rejection"
fi

# A rejection is terminal. --allow-proposed exists to shape-check work still on
# its way to a decision, and a rejected brief is past that point, so the flag
# does not reach it.
if [ "$STATUS" = "rejected" ]; then
  verdict NOT-APPROVED 4 "this brief was rejected by $(fm_value rejected_by) and is not downstream authority — a rejected judgment creates no approved form and nothing may proceed on it"
fi

if [ "$ALLOW_PROPOSED" -eq 0 ] && [ "$STATUS" != "approved" ]; then
  verdict NOT-APPROVED 4 "this brief has status '$STATUS' and is not downstream authority — it must clear the independent challenge and be re-issued as 'approved' before downstream work may rely on it"
fi

# ------------------------------------------------------- 6. required headings
BODY="$(awk 'NR==1 && $0=="---" {inb=1; next} inb && $0=="---" {inb=0; body=1; next} body' "$BRIEF")"

for h in '## Theses' '## Provisional verdict' '## What would change the view'; do
  printf '%s\n' "$BODY" | grep -qF -- "$h" \
    || verdict STRUCTURE 6 "required heading '${h#\#\# }' is missing — the brief must carry Theses, Provisional verdict and What would change the view"
done

# ----------------------------------------------------------- 6. thesis count
THESES="$(printf '%s\n' "$BODY" | grep -cE '^### Thesis ')"
if [ "$THESES" -lt 3 ] || [ "$THESES" -gt 5 ]; then
  verdict STRUCTURE 6 "the brief carries $THESES theses — the contract is three to five integrated theses, each written as '### Thesis N — ...'"
fi

# ------------------------------------------------------------ 5. NO-CLAIM-IDS
IDS="$(printf '%s\n' "$BODY" | grep -oE "$CLAIM_ID_RE" | sort -u | wc -l | tr -d ' ')"
if [ "$IDS" -eq 0 ]; then
  verdict NO-CLAIM-IDS 5 "the brief cites no claim IDs — an approved judgment must rest on existing research claim IDs (e.g. [Q1-C05], [GF3-C02]); no ID means no traceable evidence basis"
fi

# ------------------------------------------- 6. separation 1: thesis evidence
# Split the body at each '### Thesis ' heading and require a claim ID inside each
# block. Done per thesis rather than document-wide on purpose: a brief where one
# well-cited thesis carries two uncited ones passes any document-wide count while
# containing exactly the failure this rule exists to catch.
BARE_THESIS="$(printf '%s\n' "$BODY" | awk -v re="$AWK_CLAIM_RE" '
  function close_block() {
    if (n > 0 && !hit) bad = bad (bad ? "; " : "") label
  }
  /^### Thesis / {
    close_block()
    n++; hit = 0
    label = $0
    sub(/^### Thesis /, "", label)
    sub(/ [—-].*$/, "", label)
    next
  }
  n > 0 && $0 ~ re { hit = 1 }
  END { close_block(); print bad }
')"
if [ -n "$BARE_THESIS" ]; then
  verdict STRUCTURE 6 "thesis $BARE_THESIS cites no claim ID — every thesis must rest on cited evidence, or it is an interpretation with no evidence basis"
fi

# ------------------------------------------ 6. separation 2: context is not evidence
# A `Context:` lead-in carrying a claim ID is evidence wearing a context label.
CTX_EVIDENCE="$(printf '%s\n' "$BODY" | grep -nE "^[[:space:]]*Context:.*$CLAIM_ID_RE" | cut -d: -f1 | tr '\n' ' ')"
if [ -n "$CTX_EVIDENCE" ]; then
  verdict STRUCTURE 6 "a 'Context:' statement cites a claim ID (body line(s): ${CTX_EVIDENCE% }) — Axcíon context may shape relevance and framing, never serve as evidence; move the citation into the thesis it supports"
fi

# ---------------------------------------- 6. separation 3: the verdict rests on evidence
VERDICT_BLOCK="$(printf '%s\n' "$BODY" | awk '
  /^## Provisional verdict/ { inv = 1; next }
  /^## / { inv = 0 }
  inv
')"
printf '%s\n' "$VERDICT_BLOCK" | grep -qE "$CLAIM_ID_RE" \
  || verdict STRUCTURE 6 "the Provisional verdict cites no claim ID — a verdict supported only by context is context deciding the outcome; cite the evidence the verdict rests on"

# --------------------------------------------------------- 6. countercase
# At least one, document-wide. NOT per thesis: the standard requires the
# countercase where it changes how the thesis should be understood, so a
# per-thesis rule would enforce the artificial balance the standard prohibits.
printf '%s\n' "$BODY" | grep -qE '^[[:space:]]*(Countercase|Limitation|Alternative reading):' \
  || verdict STRUCTURE 6 "the brief records no countercase, limitation or alternative reading anywhere — mark at least one with a 'Countercase:' / 'Limitation:' / 'Alternative reading:' lead-in"

# ------------------------------------------------------------ length warning
WORDS="$(printf '%s\n' "$BODY" | grep -v '^#' | wc -w | tr -d ' ')"
if [ "$WORDS" -lt 500 ]; then
  printf 'warning: the brief runs %s words, under the 500-800 target band — short of target, accepted (the band is a target, not a gate)\n' "$WORDS"
elif [ "$WORDS" -gt 800 ]; then
  printf 'warning: the brief runs %s words, over the 500-800 target band — over target, accepted (the band is a target, not a gate)\n' "$WORDS"
fi

# The reason line reports the status it actually read. Under --allow-proposed a
# structurally sound PROPOSED brief is accepted, and calling it "approved" here
# would have the gate itself misreport the one distinction it exists to keep.
if [ "$STATUS" = "approved" ]; then
  verdict VALID 0 "approved Unit Judgment Brief for unit '$UNIT', $THESES theses, $IDS distinct claim IDs, $WORDS words — accepted as downstream authority"
fi
verdict VALID 0 "proposed Unit Judgment Brief for unit '$UNIT', $THESES theses, $IDS distinct claim IDs, $WORDS words — structurally sound, and NOT downstream authority until it is challenged, decided and re-issued as approved"
