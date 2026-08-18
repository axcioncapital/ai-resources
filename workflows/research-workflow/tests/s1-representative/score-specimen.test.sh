#!/usr/bin/env bash
# Negative controls for score-specimen.sh.
#
# The scorer's value is entirely in its ability to fail. This harness mutates a throwaway copy of
# the reference specimen — one defect at a time — and asserts that the matching check reports FAIL
# and the run exits non-zero. A scorer that passed these mutations would pass a broken relay too.
#
# Usage: bash score-specimen.test.sh
# Exit: 0 when every case behaves as asserted, 1 otherwise.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
SCORER="$HERE/score-specimen.sh"
REF_SPECIMEN="$HERE/specimen"
REF_EXPECTED="$HERE/expected"

CHAPTER=1.1-chapter-01.md
REPORT=1.1-chapter-01-verification.md
SUMMARY=1.1-chapter-01-verification-summary.md
CHECKPOINT=1.1-chapter-01-verification-checkpoint.md

WORK="$(mktemp -d "${TMPDIR:-/tmp}/s1-rep-test.XXXXXX")" || exit 1
trap 'rm -rf "$WORK"' EXIT

RUN=0
BAD=0

# Fresh copy of the reference specimen and expectations. Prints the case directory.
scratch() {
  local d="$WORK/case-$1"
  mkdir -p "$d"
  cp -R "$REF_SPECIMEN" "$d/specimen"
  cp -R "$REF_EXPECTED" "$d/expected"
  printf '%s\n' "$d"
}

# expect_fail <name> <check-id> <case-dir>
expect_fail() {
  local name="$1" want="$2" dir="$3" out rc
  RUN=$((RUN + 1))
  out="$("$BASH" "$SCORER" --specimen "$dir/specimen" --expected "$dir/expected" 2>&1)"; rc=$?
  if [ "$rc" -eq 0 ]; then
    printf 'FAIL  %-44s scorer exited 0; expected a %s failure\n' "$name" "$want"
    printf '%s\n' "$out" | sed 's/^/        /'
    BAD=$((BAD + 1)); return
  fi
  if ! printf '%s\n' "$out" | grep -q "^check $want: FAIL"; then
    printf 'FAIL  %-44s exited %d but did not report "check %s: FAIL"\n' "$name" "$rc" "$want"
    printf '%s\n' "$out" | sed 's/^/        /'
    BAD=$((BAD + 1)); return
  fi
  printf 'ok    %-44s %s\n' "$name" "$(printf '%s\n' "$out" | grep "^check $want: FAIL" | head -n 1 | cut -c1-96)"
}

expect_pass() {
  local name="$1" dir="$2" out rc
  RUN=$((RUN + 1))
  out="$("$BASH" "$SCORER" --specimen "$dir/specimen" --expected "$dir/expected" 2>&1)"; rc=$?
  if [ "$rc" -ne 0 ]; then
    printf 'FAIL  %-44s expected a clean pass, exited %d\n' "$name" "$rc"
    printf '%s\n' "$out" | sed 's/^/        /'
    BAD=$((BAD + 1)); return
  fi
  printf 'ok    %-44s %s\n' "$name" "$(printf '%s\n' "$out" | tail -n 1)"
}

# In-place edit that works the same on BSD and GNU sed.
edit() { local f="$1"; shift; sed "$@" "$f" > "$f.tmp" && mv "$f.tmp" "$f"; }

printf 'score-specimen.test.sh — negative controls\n\n'

# ---- the valid specimen must pass, or nothing below means anything -------------------
d="$(scratch 01)"
expect_pass 'T1  valid reference specimen passes' "$d"

# ---- A1 required artifacts ----------------------------------------------------------
d="$(scratch 02)"; rm -f "$d/specimen/$CHECKPOINT"
expect_fail 'T2  missing required artifact' A1 "$d"

d="$(scratch 03)"; : > "$d/specimen/$SUMMARY"
expect_fail 'T3  required artifact present but empty' A1 "$d"

d="$(scratch 04)"; printf 'evidence-pack\t1.1-evidence-pack.md\n' >> "$d/expected/required-artifacts.txt"
expect_fail 'T4  manifest names a role the scorer lacks' A1 "$d"

# ---- A2 verbatim report fidelity ----------------------------------------------------
d="$(scratch 05)"
edit "$d/specimen/$REPORT" -e 's/^- Recommended correction: The evidence table supports.*/- Recommended correction: See file./'
expect_fail 'T5  report body paraphrased, not verbatim' A2 "$d"

d="$(scratch 06)"; head -n 20 "$REF_SPECIMEN/$REPORT" > "$d/specimen/$REPORT"
expect_fail 'T6  report truncated on the way to disk' A2 "$d"

# ---- A3 path passing ----------------------------------------------------------------
d="$(scratch 07)"; edit "$d/specimen/$CHECKPOINT" -e 's|^- Output file path: .*|- Output file path:|'
expect_fail 'T7  checkpoint records no report path' A3 "$d"

d="$(scratch 08)"; edit "$d/specimen/$CHECKPOINT" -e 's|1.1-chapter-01-verification.md|1.1-chapter-02-verification.md|'
expect_fail 'T8  summary and checkpoint name different files' A3 "$d"

d="$(scratch 09)"
edit "$d/specimen/$CHECKPOINT" -e 's|^- Output file path: .*|- Output file path: /report/checkpoints/1.1/1.1-chapter-01-verification-checkpoint.md|'
edit "$d/specimen/$SUMMARY" -e 's|^Output file path: .*|Output file path: /report/checkpoints/1.1/1.1-chapter-01-verification-checkpoint.md|'
expect_fail 'T9  relayed path names the wrong artifact' A3 "$d"

# ---- A4 claim-ID set identity -------------------------------------------------------
d="$(scratch 10)"; edit "$d/specimen/$CHAPTER" -e 's/\[Q2-C03\]//g'
expect_fail 'T10 claim ID dropped from the chapter' A4 "$d"

d="$(scratch 11)"; edit "$d/specimen/$CHAPTER" -e 's/\[Q1-C01\]/[Q1-C01, Q9-C42]/'
expect_fail 'T11 claim ID invented in the chapter' A4 "$d"

# ---- A5 verdict structure -----------------------------------------------------------
d="$(scratch 12)"; edit "$d/specimen/$REPORT" -e '/^Verdict: /d'
expect_fail 'T12 report states no verdict' A5 "$d"

d="$(scratch 13)"
edit "$d/specimen/$REPORT" -e 's/^Verdict: .*/Verdict: APPROVED/'
edit "$d/specimen/$SUMMARY" -e 's/^Verdict: .*/Verdict: APPROVED/'
edit "$d/specimen/$CHECKPOINT" -e 's/^- Verdict: .*/- Verdict: APPROVED/'
expect_fail 'T13 verdict APPROVED alongside discrepancies' A5 "$d"

d="$(scratch 14)"; edit "$d/specimen/$SUMMARY" -e 's/^Verdict: .*/Verdict: APPROVED/'
expect_fail 'T14 summary verdict diverges from the report' A5 "$d"

d="$(scratch 15)"; edit "$d/specimen/$CHECKPOINT" -e '/^- Verdict: /d'
expect_fail 'T15 checkpoint states no verdict' A5 "$d"

# ---- A6 discrepancy structure -------------------------------------------------------
d="$(scratch 16)"; edit "$d/specimen/$REPORT" -e '/^- Issue type: Category-leakage$/d'
expect_fail 'T16 discrepancy missing Issue type' A6 "$d"

d="$(scratch 17)"; edit "$d/specimen/$REPORT" -e 's/^- Issue type: Undated$/- Issue type: Questionable/'
expect_fail 'T17 issue type outside the SOP set' A6 "$d"

d="$(scratch 18)"; edit "$d/specimen/$REPORT" -e 's/^- Claim ID: Q1-C02$/- Claim ID: Q7-C11/'
expect_fail 'T18 discrepancy cites an unknown claim ID' A6 "$d"

d="$(scratch 19)"; edit "$d/specimen/$REPORT" -e 's/^- Claim ID: Q1-C04$/- Claim ID:/'
expect_fail 'T19 discrepancy Claim ID blank' A6 "$d"

d="$(scratch 20)"; edit "$d/specimen/$REPORT" -e 's/^- Recommended correction: GF1-C01 carries no.*/- Recommended correction:/'
expect_fail 'T20 discrepancy missing Recommended correction' A6 "$d"

# ---- A7 discrepancy accounting ------------------------------------------------------
d="$(scratch 21)"; edit "$d/specimen/$SUMMARY" -e 's/^Discrepancy count: 3$/Discrepancy count: 2/'
expect_fail 'T21 summary discrepancy count understated' A7 "$d"

d="$(scratch 22)"; edit "$d/specimen/$CHECKPOINT" -e 's/^- Discrepancy count: 3$/- Discrepancy count: 4/'
expect_fail 'T22 checkpoint discrepancy count overstated' A7 "$d"

d="$(scratch 23)"; edit "$d/specimen/$SUMMARY" -e '/^- GF1-C01 — Undated$/d'
expect_fail 'T23 summary drops one discrepancy line' A7 "$d"

d="$(scratch 24)"; edit "$d/specimen/$SUMMARY" -e 's/^- Q1-C04 — Category-leakage$/- Q1-C04 — Unsupported/'
expect_fail 'T24 summary restates a discrepancy issue type' A7 "$d"

# ---- A8 summary cap -----------------------------------------------------------------
d="$(scratch 25)"
{ cat "$REF_SPECIMEN/$SUMMARY"; for i in $(seq 1 15); do printf 'Additional context line %s.\n' "$i"; done; } > "$d/specimen/$SUMMARY"
expect_fail 'T25 summary over the 20-line cap' A8 "$d"

d="$(scratch 26)"
{ head -n 8 "$REF_SPECIMEN/$SUMMARY"
  printf 'Full report text follows: '
  for i in $(seq 1 400); do printf 'the relayed verification body exceeds the four-kilobyte bound. '; done
  printf '\n'; } > "$d/specimen/$SUMMARY"
expect_fail 'T26 summary over the 4 KB cap' A8 "$d"

# ---- A0 recorded pre-S1 baseline ----------------------------------------------------
d="$(scratch 27)"; edit "$d/expected/baseline-revision.txt" -e 's/^revision: .*/revision: f18ed58/'
expect_fail 'T27 baseline revision is an abbreviated SHA' A0 "$d"

d="$(scratch 28)"; edit "$d/expected/baseline-revision.txt" -e 's/^revision: .*/revision: 0000000000000000000000000000000000000000/'
expect_fail 'T28 baseline revision resolves to no commit' A0 "$d"

d="$(scratch 29)"; edit "$d/expected/baseline-revision.txt" -e '/^derivation: /d'
expect_fail 'T29 baseline revision recorded without derivation' A0 "$d"

d="$(scratch 30)"; : > "$d/expected/baseline-revision.txt"
expect_fail 'T30 baseline revision file empty' A0 "$d"

# ---- result -------------------------------------------------------------------------
printf '\n'
if [ "$BAD" -eq 0 ]; then
  printf 'harness: %d/%d cases behaved as asserted\n' "$RUN" "$RUN"
  exit 0
fi
printf 'harness: %d of %d cases did NOT behave as asserted\n' "$BAD" "$RUN"
exit 1
