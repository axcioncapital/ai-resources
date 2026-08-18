#!/usr/bin/env bash
# Deterministic scorer for the S1 representative chapter regression.
#
# Scores one specimen — the artifact set a single /verify-chapter run leaves behind — against
# the schema and identity criteria in rubric.md Part A. Part B (preserved analytical meaning)
# is a fresh evaluator's judgment and is deliberately NOT implemented here.
#
# Usage:
#   bash score-specimen.sh                      # score ./specimen (the reference valid specimen)
#   bash score-specimen.sh --specimen DIR       # score a run's output directory
#   bash score-specimen.sh --check-baseline     # validate expected/baseline-revision.txt only
#   bash score-specimen.sh --expected DIR       # read the expected/ set from elsewhere
#
# --expected exists so score-specimen.test.sh can mutate the recorded expectations themselves
# and prove the checks that read them can fail. Real runs leave it at the default.
#
# Exit: 0 when every check passes, 1 when any check fails, 2 on a usage error.
#
# Every check is written so that a specimen can fail it. score-specimen.test.sh proves that by
# mutating the reference specimen once per check and asserting the matching failure.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
SPECIMEN="$HERE/specimen"
EXPECTED_DIR="$HERE/expected"
MODE=all

while [ "$#" -gt 0 ]; do
  case "$1" in
    --specimen) [ "$#" -ge 2 ] || { printf 'score-specimen.sh: --specimen needs a directory\n' >&2; exit 2; }
                SPECIMEN="$2"; shift 2 ;;
    --expected) [ "$#" -ge 2 ] || { printf 'score-specimen.sh: --expected needs a directory\n' >&2; exit 2; }
                EXPECTED_DIR="$2"; shift 2 ;;
    --check-baseline) MODE=baseline; shift ;;
    -h|--help) sed -n '2,21p' "${BASH_SOURCE[0]}"; exit 0 ;;
    *) printf 'score-specimen.sh: unknown argument %s\n' "$1" >&2; exit 2 ;;
  esac
done

CORPUS_DIR="$HERE/corpus"
FROZEN_RESPONSE="$CORPUS_DIR/frozen-verification-response.md"
MANIFEST="$EXPECTED_DIR/required-artifacts.txt"
CLAIM_IDS="$EXPECTED_DIR/claim-ids.txt"
BASELINE="$EXPECTED_DIR/baseline-revision.txt"

CLAIM_ID_RE='(Q[0-9]+|GF[0-9]+)-C[0-9][0-9]'
ISSUE_TYPES='Unsupported Contradicted Overstated Category-leakage Undated'
SUMMARY_MAX_LINES=20
SUMMARY_MAX_BYTES=4096

FAILURES=0

TMP="$(mktemp -d "${TMPDIR:-/tmp}/s1-representative.XXXXXX")" || exit 2
trap 'rm -rf "$TMP"' EXIT

pass() { printf 'check %s: PASS — %s\n' "$1" "$2"; }
fail() { printf 'check %s: FAIL — %s\n' "$1" "$2"; FAILURES=$((FAILURES + 1)); }

# Value of a `Field:` line, tolerating a leading list marker and surrounding blanks.
# Reads its file from $1 and its field label from $2. Prints every match, one per line.
field_values() {
  awk -v label="$2" '
    {
      line = $0
      sub(/^[[:space:]]*[-*][[:space:]]*/, "", line)
      idx = index(line, label ":")
      if (idx != 1) next
      v = substr(line, length(label) + 2)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", v)
      print v
    }' "$1"
}

count_lines() { awk 'END { print NR }' "$1"; }

# Reduce a relayed `Output file path:` value to the path itself, reading it on stdin.
#
# `execution-agent.md` requires the field ("The output file path") and fixes no value grammar,
# so a Markdown code span or a trailing explanatory parenthetical is contract-permitted
# decoration, not a defect. This strips **representation only**. It never supplies a path that
# is absent: an empty value, or decoration with nothing inside it, normalizes to the empty
# string, which A3 still reports as a missing path.
normalize_path() {
  awk '
    {
      v = $0
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", v)
      if (substr(v, 1, 1) == "`") {
        # Markdown code span: the path is what the first backtick pair encloses.
        rest = substr(v, 2)
        i = index(rest, "`")
        v = (i > 0) ? substr(rest, 1, i - 1) : rest
      } else {
        # Bare value: drop a trailing explanatory parenthetical.
        sub(/[[:space:]]+\(.*\)[[:space:]]*$/, "", v)
      }
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", v)
      print v
    }'
}

# Extract the summary's per-discrepancy `(Claim ID, Issue type)` pairs, reading the summary
# path from $1 and printing `id<TAB>issue` per accepted line.
#
# `execution-agent.md` requires "one line per discrepancy giving its Claim ID and Issue type
# exactly as written" and fixes no line grammar. Two forms have been observed in real runs and
# both are accepted here: the compact `- Q1-C02 — Overstated`, and the numbered, labelled
# `1. Claim ID Q1-C02 — Issue type: Overstated`. Only the list marker and the two field labels
# are optional decoration — the claim ID, the em-dash separator and a non-empty issue type must
# all be literally present, so a line missing any of them is not counted rather than repaired.
summary_pairs() {
  awk -v idre='^(Q[0-9]+|GF[0-9]+)-C[0-9][0-9]' -v dash='—' '
    function trim(s) { gsub(/^[[:space:]]+|[[:space:]]+$/, "", s); return s }
    {
      line = $0
      sub(/^[[:space:]]+/, "", line)
      sub(/^([-*]|[0-9]+[.)])[[:space:]]*/, "", line)   # one list marker, bullet or ordered
      sub(/^[Cc]laim ID:?[[:space:]]*/, "", line)       # optional label before the ID
      if (match(line, idre) != 1) next
      id = substr(line, 1, RLENGTH)
      rest = substr(line, RLENGTH + 1)
      n = index(rest, dash)
      if (n == 0) next                                  # no separator: not a discrepancy line
      if (trim(substr(rest, 1, n - 1)) != "") next       # the dash must be the next thing
      rest = substr(rest, n + length(dash))
      m = index(rest, dash)
      if (m > 0) rest = substr(rest, 1, m - 1)           # trailing detail is not the issue type
      sub(/^[[:space:]]*[Ii]ssue type:?[[:space:]]*/, "", rest)
      rest = trim(rest)
      if (rest == "") next                               # no issue type stated: not counted
      print id "\t" rest
    }' "$1"
}

# ---------------------------------------------------------------- A0 baseline revision

check_baseline() {
  if [ ! -f "$BASELINE" ] || [ ! -s "$BASELINE" ]; then
    fail A0 "expected/baseline-revision.txt is missing or empty — the pre-S1 boundary is not recorded"
    return
  fi

  field_values "$BASELINE" revision > "$TMP/rev" 2>/dev/null
  field_values "$BASELINE" derivation > "$TMP/deriv" 2>/dev/null
  local nrev ndrv rev
  nrev="$(awk 'END { print NR }' "$TMP/rev")"
  ndrv="$(awk 'END { print NR }' "$TMP/deriv")"

  if [ "$nrev" -ne 1 ]; then
    fail A0 "expected exactly one 'revision:' line in baseline-revision.txt, found $nrev"
    return
  fi
  rev="$(cat "$TMP/rev")"
  if ! printf '%s' "$rev" | grep -qE '^[0-9a-f]{40}$'; then
    fail A0 "baseline revision '$rev' is not a full 40-hex commit SHA"
    return
  fi
  if [ "$ndrv" -lt 1 ]; then
    fail A0 "baseline revision $rev is recorded without any 'derivation:' line saying how it was established"
    return
  fi

  if command -v git >/dev/null 2>&1 && git -C "$HERE" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    if [ "$(git -C "$HERE" cat-file -t "$rev" 2>/dev/null)" = commit ]; then
      pass A0 "pre-S1 baseline $rev recorded with $ndrv derivation line(s); resolves to a commit in this repository"
    else
      fail A0 "baseline revision $rev does not resolve to a commit in this repository"
    fi
  else
    pass A0 "pre-S1 baseline $rev recorded with $ndrv derivation line(s); git unavailable, resolution not checked"
  fi
}

if [ "$MODE" = baseline ]; then
  check_baseline
  if [ "$FAILURES" -eq 0 ]; then printf 'verdict: PASS\n'; exit 0; fi
  printf 'verdict: FAIL (%d check(s))\n' "$FAILURES"; exit 1
fi

printf 'specimen: %s\n' "$SPECIMEN"

check_baseline

# ---------------------------------------------------------------- A1 required artifacts

for f in "$MANIFEST" "$CLAIM_IDS" "$FROZEN_RESPONSE"; do
  if [ ! -f "$f" ] || [ ! -s "$f" ]; then
    printf 'check A1: FAIL — substrate file missing or empty: %s\n' "$f"
    printf 'verdict: FAIL (1 check(s))\n'
    exit 1
  fi
done

CHAPTER=''; REPORT=''; SUMMARY=''; CHECKPOINT=''
a1_detail=''
a1_ok=1

while IFS=$'\t' read -r role rel; do
  case "$role" in ''|\#*) continue ;; esac
  [ -n "${rel:-}" ] || { a1_ok=0; a1_detail="${a1_detail}${a1_detail:+; }role '$role' has no path"; continue; }
  abs="$SPECIMEN/$rel"
  case "$role" in
    chapter) CHAPTER="$abs" ;;
    verification-report) REPORT="$abs" ;;
    verification-summary) SUMMARY="$abs" ;;
    verification-checkpoint) CHECKPOINT="$abs" ;;
    *) a1_ok=0; a1_detail="${a1_detail}${a1_detail:+; }unknown role '$role' in required-artifacts.txt"; continue ;;
  esac
  if [ ! -f "$abs" ]; then
    a1_ok=0; a1_detail="${a1_detail}${a1_detail:+; }missing required artifact ($role): $rel"
  elif [ ! -s "$abs" ]; then
    a1_ok=0; a1_detail="${a1_detail}${a1_detail:+; }required artifact is empty ($role): $rel"
  fi
done < <(sed 's/#.*//' "$MANIFEST")

for role in chapter verification-report verification-summary verification-checkpoint; do
  case "$role" in
    chapter) v="$CHAPTER" ;;
    verification-report) v="$REPORT" ;;
    verification-summary) v="$SUMMARY" ;;
    verification-checkpoint) v="$CHECKPOINT" ;;
  esac
  [ -n "$v" ] || { a1_ok=0; a1_detail="${a1_detail}${a1_detail:+; }required-artifacts.txt declares no path for role '$role'"; }
done

if [ "$a1_ok" -eq 1 ]; then
  pass A1 "all four required artifacts present and non-empty"
else
  fail A1 "$a1_detail"
  printf 'verdict: FAIL (%d check(s))\n' "$FAILURES"
  printf 'note: A2-A8 not run — they read artifacts A1 could not establish.\n'
  exit 1
fi

# ---------------------------------------------------------------- A2 verbatim report fidelity

if cmp -s "$REPORT" "$FROZEN_RESPONSE"; then
  pass A2 "verification report is byte-identical to the frozen response"
else
  fail A2 "verification report differs from corpus/frozen-verification-response.md — execution-agent.md requires the complete response written verbatim"
fi

# ---------------------------------------------------------------- A3 path passing

report_base="$(basename "$REPORT")"
field_values "$SUMMARY" 'Output file path' > "$TMP/sum-path"
field_values "$CHECKPOINT" 'Output file path' > "$TMP/ckp-path"
sum_path_raw="$(head -n 1 "$TMP/sum-path")"
ckp_path_raw="$(head -n 1 "$TMP/ckp-path")"
sum_path="$(printf '%s\n' "$sum_path_raw" | normalize_path)"
ckp_path="$(printf '%s\n' "$ckp_path_raw" | normalize_path)"

if [ -z "$sum_path" ] || [ -z "$ckp_path" ]; then
  fail A3 "output path missing — summary: '${sum_path_raw:-<none>}', checkpoint: '${ckp_path_raw:-<none>}'"
elif [ "$sum_path" != "$ckp_path" ]; then
  fail A3 "summary and checkpoint name different report paths — '$sum_path' vs '$ckp_path' (as stated: '$sum_path_raw' vs '$ckp_path_raw')"
elif [ "$(basename "$sum_path")" != "$report_base" ]; then
  fail A3 "relayed path '$sum_path' does not name the report artifact '$report_base'"
else
  pass A3 "report path relayed intact: $sum_path"
fi

# ---------------------------------------------------------------- A4 claim-ID set identity

grep -oE "$CLAIM_ID_RE" "$CHAPTER" 2>/dev/null | sort -u > "$TMP/chapter-ids"
sed 's/#.*//' "$CLAIM_IDS" | tr -d ' \t' | grep -E "^$CLAIM_ID_RE$" | sort -u > "$TMP/expected-ids"

comm -23 "$TMP/expected-ids" "$TMP/chapter-ids" > "$TMP/dropped"
comm -13 "$TMP/expected-ids" "$TMP/chapter-ids" > "$TMP/invented"
n_drop="$(awk 'END { print NR }' "$TMP/dropped")"
n_inv="$(awk 'END { print NR }' "$TMP/invented")"

if [ "$n_drop" -eq 0 ] && [ "$n_inv" -eq 0 ]; then
  pass A4 "chapter carries exactly the $(awk 'END { print NR }' "$TMP/expected-ids") expected claim IDs"
else
  detail=''
  [ "$n_drop" -gt 0 ] && detail="dropped: $(tr '\n' ' ' < "$TMP/dropped" | sed 's/ $//')"
  [ "$n_inv" -gt 0 ] && detail="${detail}${detail:+; }invented: $(tr '\n' ' ' < "$TMP/invented" | sed 's/ $//')"
  fail A4 "$detail"
fi

# ---------------------------------------------------------------- A5 verdict structure

field_values "$REPORT" Verdict > "$TMP/rep-verdict"
field_values "$SUMMARY" Verdict > "$TMP/sum-verdict"
field_values "$CHECKPOINT" Verdict > "$TMP/ckp-verdict"
n_rep_v="$(awk 'END { print NR }' "$TMP/rep-verdict")"
n_sum_v="$(awk 'END { print NR }' "$TMP/sum-verdict")"
n_ckp_v="$(awk 'END { print NR }' "$TMP/ckp-verdict")"
blocks="$(grep -cE '^## Discrepancy ' "$REPORT" 2>/dev/null | tr -d ' ')"
[ -n "$blocks" ] || blocks=0

a5_detail=''
if [ "$n_rep_v" -ne 1 ]; then
  a5_detail="report states $n_rep_v 'Verdict:' line(s), expected exactly 1"
elif [ "$n_sum_v" -ne 1 ] || [ "$n_ckp_v" -ne 1 ]; then
  a5_detail="summary states $n_sum_v and checkpoint states $n_ckp_v 'Verdict:' line(s), expected exactly 1 each"
else
  rep_v="$(cat "$TMP/rep-verdict")"; sum_v="$(cat "$TMP/sum-verdict")"; ckp_v="$(cat "$TMP/ckp-verdict")"
  if [ -z "$rep_v" ]; then
    a5_detail="report 'Verdict:' line has no value"
  elif [ "$rep_v" = APPROVED ] && [ "$blocks" -ne 0 ]; then
    a5_detail="verdict APPROVED but the report carries $blocks discrepancy block(s)"
  elif [ "$rep_v" != APPROVED ] && [ "$blocks" -eq 0 ]; then
    a5_detail="verdict '$rep_v' is not APPROVED but the report carries no discrepancy block"
  elif [ "$sum_v" != "$rep_v" ]; then
    a5_detail="summary verdict '$sum_v' does not quote the report verdict '$rep_v'"
  elif [ "$ckp_v" != "$rep_v" ]; then
    a5_detail="checkpoint verdict '$ckp_v' does not quote the report verdict '$rep_v'"
  fi
fi

if [ -z "$a5_detail" ]; then
  pass A5 "verdict '$(cat "$TMP/rep-verdict")' stated once and quoted consistently; $blocks discrepancy block(s)"
else
  fail A5 "$a5_detail"
fi

# ---------------------------------------------------------------- A6 discrepancy structure

awk '
  /^## Discrepancy /      { blk++; claim[blk]=0; id[blk]=""; issue[blk]=""; corr[blk]=0; next }
  blk == 0                { next }
  /^[[:space:]]*[-*][[:space:]]*Claim:/ {
    v = $0; sub(/^[^:]*:/, "", v); gsub(/^[[:space:]]+|[[:space:]]+$/, "", v)
    if (v != "") claim[blk] = 1; next
  }
  /^[[:space:]]*[-*][[:space:]]*Claim ID:/ {
    v = $0; sub(/^[^:]*:/, "", v); gsub(/^[[:space:]]+|[[:space:]]+$/, "", v)
    id[blk] = v; next
  }
  /^[[:space:]]*[-*][[:space:]]*Issue type:/ {
    v = $0; sub(/^[^:]*:/, "", v); gsub(/^[[:space:]]+|[[:space:]]+$/, "", v)
    issue[blk] = v; next
  }
  /^[[:space:]]*[-*][[:space:]]*Recommended correction:/ {
    v = $0; sub(/^[^:]*:/, "", v); gsub(/^[[:space:]]+|[[:space:]]+$/, "", v)
    if (v != "") corr[blk] = 1; next
  }
  END {
    # US (0x1f), not tab: tab is IFS whitespace, so bash `read` would collapse a run of
    # them and silently shift every field after an empty one. That would make a blank
    # Claim ID report as some other field being absent.
    for (i = 1; i <= blk; i++)
      printf "%d\037%d\037%s\037%s\037%d\n", i, claim[i], id[i], issue[i], corr[i]
  }' "$REPORT" > "$TMP/blocks"

a6_detail=''
: > "$TMP/report-pairs"
while IFS=$'\037' read -r n has_claim did issue has_corr; do
  [ -n "${n:-}" ] || continue
  [ "$has_claim" -eq 1 ] || a6_detail="${a6_detail}${a6_detail:+; }discrepancy $n: 'Claim' missing or empty"
  [ -n "$did" ] || a6_detail="${a6_detail}${a6_detail:+; }discrepancy $n: 'Claim ID' missing or empty"
  [ -n "$issue" ] || a6_detail="${a6_detail}${a6_detail:+; }discrepancy $n: 'Issue type' missing or empty"
  [ "$has_corr" -eq 1 ] || a6_detail="${a6_detail}${a6_detail:+; }discrepancy $n: 'Recommended correction' missing or empty"
  if [ -n "$issue" ]; then
    known=0
    for t in $ISSUE_TYPES; do [ "$issue" = "$t" ] && known=1; done
    [ "$known" -eq 1 ] || a6_detail="${a6_detail}${a6_detail:+; }discrepancy $n: issue type '$issue' is outside the SOP's closed set"
  fi
  if [ -n "$did" ] && ! grep -qxF "$did" "$TMP/expected-ids"; then
    a6_detail="${a6_detail}${a6_detail:+; }discrepancy $n: claim ID '$did' is not in the expected set"
  fi
  printf '%s\t%s\n' "$did" "$issue" >> "$TMP/report-pairs"
done < "$TMP/blocks"

if [ -z "$a6_detail" ]; then
  pass A6 "$blocks discrepancy block(s) carry all four SOP fields with a known issue type and a known claim ID"
else
  fail A6 "$a6_detail"
fi

# ---------------------------------------------------------------- A7 discrepancy accounting

rep_count="$(field_values "$REPORT" 'Discrepancy count' | head -n 1)"
sum_count="$(field_values "$SUMMARY" 'Discrepancy count' | head -n 1)"
ckp_count="$(field_values "$CHECKPOINT" 'Discrepancy count' | head -n 1)"

summary_pairs "$SUMMARY" > "$TMP/summary-pairs"
sum_lines="$(awk 'END { print NR }' "$TMP/summary-pairs")"

a7_detail=''
for pair in "report:$rep_count" "summary:$sum_count" "checkpoint:$ckp_count"; do
  who="${pair%%:*}"; val="${pair#*:}"
  if ! printf '%s' "$val" | grep -qE '^[0-9]+$'; then
    a7_detail="${a7_detail}${a7_detail:+; }$who states no numeric 'Discrepancy count' (got '${val:-<none>}')"
  fi
done

if [ -z "$a7_detail" ]; then
  if [ "$rep_count" -ne "$blocks" ]; then
    a7_detail="report states $rep_count discrepancies but carries $blocks block(s)"
  elif [ "$sum_count" -ne "$blocks" ]; then
    a7_detail="summary states $sum_count discrepancies but the report carries $blocks"
  elif [ "$ckp_count" -ne "$blocks" ]; then
    a7_detail="checkpoint states $ckp_count discrepancies but the report carries $blocks"
  elif [ "$sum_lines" -ne "$blocks" ]; then
    a7_detail="summary lists $sum_lines per-discrepancy line(s) for $blocks block(s)"
  else
    sort "$TMP/report-pairs" > "$TMP/rp-sorted"
    sort "$TMP/summary-pairs" > "$TMP/sp-sorted"
    if ! cmp -s "$TMP/rp-sorted" "$TMP/sp-sorted"; then
      a7_detail="summary (Claim ID, Issue type) pairs do not match the report's: report [$(tr '\t' '/' < "$TMP/rp-sorted" | tr '\n' ' ' | sed 's/ $//')] vs summary [$(tr '\t' '/' < "$TMP/sp-sorted" | tr '\n' ' ' | sed 's/ $//')]"
    fi
  fi
fi

if [ -z "$a7_detail" ]; then
  pass A7 "count $blocks agrees across report, summary and checkpoint; claim-ID/issue-type pairs match"
else
  fail A7 "$a7_detail"
fi

# ---------------------------------------------------------------- A8 summary cap

sum_l="$(count_lines "$SUMMARY")"
sum_b="$(wc -c < "$SUMMARY" | tr -d ' ')"
if [ "$sum_l" -le "$SUMMARY_MAX_LINES" ] && [ "$sum_b" -le "$SUMMARY_MAX_BYTES" ]; then
  pass A8 "handoff summary within cap: ${sum_l}/${SUMMARY_MAX_LINES} lines, ${sum_b}/${SUMMARY_MAX_BYTES} bytes"
else
  fail A8 "handoff summary breaches the hard cap: ${sum_l}/${SUMMARY_MAX_LINES} lines, ${sum_b}/${SUMMARY_MAX_BYTES} bytes"
fi

# ---------------------------------------------------------------- verdict

if [ "$FAILURES" -eq 0 ]; then
  printf 'verdict: PASS\n'
  exit 0
fi
printf 'verdict: FAIL (%d check(s))\n' "$FAILURES"
exit 1
