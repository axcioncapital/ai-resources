#!/usr/bin/env bash
# Regenerate the S1 fixed relay fixture.
#
# The fixture is a FIXED, byte-stable stand-in for one section's worth of research-workflow
# artifacts. It exists so that per-seam relay payloads are measurable without a live project:
# `check-relay-payload.sh` sums fixture bytes for whatever artifact classes a seam relays as
# content. Nothing here is real research output and nothing reads it as content at runtime.
#
# Byte stability is load-bearing. Payload-reduction percentages computed against a fixture that
# drifts are not comparable across runs, so `check-relay-payload.test.sh` T7 asserts that
# rerunning this script leaves `fixture/` byte-identical. Change a size here only with a
# deliberate re-baseline.
#
# Multiplicities model one section: 4 chapters / 4 clusters / 8 questions / 3 execution sessions
# / 3 Part-2 section drafts. Line counts follow the shapes observed in the live workflow and in
# `audits/token-audit-2026-07-03-ai-resources.md` § 4 (chapter drafts and raw reports >200L), with
# the four reference docs sized from the live canonical files as inspected 2026-08-17
# (quality-standards 460L, source-class-hierarchy 108L, known-limits 105L, style-guide 35L).
#
# Usage: bash make-fixture.sh [--out DIR]

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
OUT="$HERE/fixture"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --out) OUT="$2"; shift 2 ;;
    -h|--help) sed -n '1,22p' "${BASH_SOURCE[0]}"; exit 0 ;;
    *) printf 'make-fixture.sh: unknown argument %s\n' "$1" >&2; exit 2 ;;
  esac
done

# One artifact file of exactly $2 lines, deterministic content seeded by $3.
# Every line is a fixed width so byte totals are a pure function of the line count.
emit() {
  local dest="$1" lines="$2" seed="$3" i
  mkdir -p "$(dirname "$dest")"
  {
    printf '# %s\n' "$seed"
    printf '\n'
    i=3
    while [ "$i" -le "$lines" ]; do
      printf 'L%04d %s filler body line for deterministic byte accounting.\n' "$i" "$seed"
      i=$((i + 1))
    done
  } > "$dest"
}

rm -rf "$OUT"
mkdir -p "$OUT"

for n in 01 02 03 04; do
  emit "$OUT/chapters/chapter-$n-draft.md"                220 "chapter-$n-draft"
  emit "$OUT/cluster-memos/cluster-$n-memo-refined.md"    160 "cluster-$n-memo-refined"
  emit "$OUT/section-directives/cluster-$n-directive.md"   60 "cluster-$n-directive"
done

for n in 1 2 3 4 5 6 7 8; do
  emit "$OUT/research-extracts/Q$n-extract.md"             90 "Q$n-extract"
  emit "$OUT/answer-specs/Q$n-answer-spec.md"              70 "Q$n-answer-spec"
done

for s in A B C; do
  emit "$OUT/raw-reports/session-$s-raw-report.md"        240 "session-$s-raw-report"
  emit "$OUT/research-prompts/session-$s.md"               85 "session-$s-prompt"
done
emit "$OUT/research-prompts/session-plan.md"               50 "session-plan"

for n in 01 02 03; do
  emit "$OUT/section-drafts/section-$n-draft.md"          260 "section-$n-draft"
done

emit "$OUT/scarcity-register.md"                           45 "scarcity-register"
emit "$OUT/editorial-recommendations.md"                   55 "editorial-recommendations"
emit "$OUT/memo-review.md"                                 70 "memo-review"
emit "$OUT/qc-editorial-decisions.md"                      60 "qc-editorial-decisions"
emit "$OUT/architecture.md"                               120 "architecture"
emit "$OUT/style-reference.md"                             40 "style-reference"
emit "$OUT/research-plan.md"                              130 "research-plan"
emit "$OUT/execution-manifest.md"                          80 "execution-manifest"
emit "$OUT/gpt5-verification-response.md"                 210 "gpt5-verification-response"

emit "$OUT/reference/quality-standards.md"                460 "quality-standards"
emit "$OUT/reference/source-class-hierarchy.md"           108 "source-class-hierarchy"
emit "$OUT/reference/known-limits.md"                     105 "known-limits"
emit "$OUT/reference/style-guide.md"                       35 "style-guide"

printf 'fixture written: %s (%s files, %s bytes)\n' \
  "$OUT" \
  "$(find "$OUT" -type f | wc -l | tr -d ' ')" \
  "$(find "$OUT" -type f -exec cat {} + | wc -c | tr -d ' ')"
