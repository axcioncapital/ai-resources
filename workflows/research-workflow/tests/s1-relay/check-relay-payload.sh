#!/usr/bin/env bash
# S1 relay-payload target check — the executable red baseline for the W4-H1..H4 refactor.
#
# WHAT IT MEASURES. For every (seam, payload) row in the manifest it opens the LIVE command or agent
# body, locates the one relay directive line, and DERIVES whether that payload currently crosses the
# main session as content or as a path. Fixture bytes are then attributed to the derived shape. The
# manifest never states the answer, so the check cannot pass or fail on a marker, an expected string,
# or on anything the S1 brief asserts — only on what the workflow body actually says. Convert a seam
# to path-passing and its violation disappears on the next run; break a compliant one and a new
# violation appears.
#
# TARGETS (plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md
# § 5 S1, approved at commit 7fec2ef6): 100% of the named seams pass a path, or a path plus a summary
# capped at 20 lines and 4 KB, and aggregate relayed payload bytes across the fixture fall by at
# least 80%.
#
# Usage:
#   bash check-relay-payload.sh [options]
#     --workflow DIR      workflow root holding .claude/ (default: two levels above this script)
#     --manifest FILE     seam manifest TSV (default: ./seam-manifest.tsv)
#     --fixture DIR       fixed fixture root (default: ./fixture)
#     --target-reduction N   required aggregate byte reduction, percent (default 80)
#     --cap-lines N       capped-summary line ceiling (default 20)
#     --cap-bytes N       capped-summary byte ceiling (default 4096)
#     --format text|tsv   per-seam report format (default text)
#
# Exit: 0 target met, 1 target not met, 2 usage or input error.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
WORKFLOW="$(cd "$HERE/../.." && pwd -P)"
MANIFEST="$HERE/seam-manifest.tsv"
FIXTURE="$HERE/fixture"
TARGET_REDUCTION=80
CAP_LINES=20
CAP_BYTES=4096
FORMAT=text

die() { printf 'check-relay-payload.sh: %s\n' "$1" >&2; exit 2; }

while [ "$#" -gt 0 ]; do
  case "$1" in
    --workflow) WORKFLOW="$2"; shift 2 ;;
    --manifest) MANIFEST="$2"; shift 2 ;;
    --fixture) FIXTURE="$2"; shift 2 ;;
    --target-reduction) TARGET_REDUCTION="$2"; shift 2 ;;
    --cap-lines) CAP_LINES="$2"; shift 2 ;;
    --cap-bytes) CAP_BYTES="$2"; shift 2 ;;
    --format) FORMAT="$2"; shift 2 ;;
    -h|--help) sed -n '1,30p' "${BASH_SOURCE[0]}"; exit 0 ;;
    *) die "unknown argument $1" ;;
  esac
done

[ -f "$MANIFEST" ] || die "manifest not found: $MANIFEST"
[ -d "$FIXTURE" ]  || die "fixture not found: $FIXTURE (run make-fixture.sh)"
[ -d "$WORKFLOW" ] || die "workflow root not found: $WORKFLOW"
case "$FORMAT" in text|tsv) ;; *) die "--format must be text or tsv" ;; esac

# ---------------------------------------------------------------------------
# Shape derivation
# ---------------------------------------------------------------------------
# Precedence, applied to the matched directive line and the payload token inside it:
#   1. main-session read directive (a numbered `Read ...` line with no delegation on it) —
#      a Read loads content into main unless the line says it takes paths only
#   2. the 32 characters AFTER the token: nearer of a path word / a content word wins
#   3. the 60 characters BEFORE the token: same rule
#   4. the list-introducer line's declared convention, for bullet payloads
#   5. a delegation introducer earlier on the same line (`Pass it:` / `as content`) — content
#   6. a `... paths only` directive — path
#   7. UNDETERMINED — reported as unresolved, never guessed
#
# The AFTER window is consulted before the BEFORE window because a payload's own qualifier follows it
# ("the big draft path", "all chapter draft content"), whereas the text in front of it is usually the
# start of a relay list — and every such list opens with "Pass it: the skill content", whose `content`
# would otherwise be attributed to each item in turn, scoring path-passed payloads as content relays.
#
# `path`/`paths`/`PATH(S)` are the only path evidence. A backticked filename is NOT evidence: the
# workflow writes parenthesised provenance paths beside payloads it passes as content, and treating
# a backtick as a path marker would silently score those compliant.

lc() { printf '%s' "$1" | tr '[:upper:]' '[:lower:]'; }

# offset of the first literal occurrence of $2 in $1, or -1
offset_of() {
  case "$1" in
    *"$2"*) local pre="${1%%"$2"*}"; printf '%s' "${#pre}" ;;
    *)      printf '%s' '-1' ;;
  esac
}

# nearer_marker <text>  ->  path | content | none
nearer_marker() {
  local t p c
  t="$(lc "$1")"
  p="$(offset_of "$t" 'path')"
  c="$(offset_of "$t" 'content')"
  if [ "$c" = '-1' ]; then c="$(offset_of "$t" 'verbatim')"; fi
  if [ "$p" != '-1' ] && { [ "$c" = '-1' ] || [ "$p" -lt "$c" ]; }; then printf 'path'; return; fi
  if [ "$c" != '-1' ] && { [ "$p" = '-1' ] || [ "$c" -lt "$p" ]; }; then printf 'content'; return; fi
  printf 'none'
}

# derive_shape <directive-line> <payload-token> <list-intro-line>  ->  path | content | undetermined
derive_shape() {
  local line="$1" token="$2" intro="$3"
  local tpos prefix before after lcline

  tpos="$(offset_of "$line" "$token")"
  [ "$tpos" = '-1' ] && { printf 'token-miss'; return; }

  lcline="$(lc "$line")"

  # 1. main-session read directive: no delegation verb anywhere on the line
  case "$lcline" in
    *'launch a'*|*'pass it:'*|*'pass each'*|*'delegate to'*) ;;
    *)
      case "$line" in
        *[0-9]'. Read '*|'Read '*|*'. Read all '*)
          case "$lcline" in
            *'paths only'*) printf 'path' ;;
            *)              printf 'content' ;;
          esac
          return ;;
      esac ;;
  esac

  # 2. the 32 chars after the token — the payload's own qualifier
  after="${line:$((tpos + ${#token})):32}"
  case "$(nearer_marker "$after")" in
    path)    printf 'path'; return ;;
    content) printf 'content'; return ;;
  esac

  # 3. the 60 chars before the token — catches the "reference doc PATH:" `file` shape
  prefix="${line:0:$tpos}"
  before="$prefix"
  if [ "${#before}" -gt 60 ]; then before="${before: -60}"; fi
  case "$(nearer_marker "$before")" in
    path)    printf 'path'; return ;;
    content) printf 'content'; return ;;
  esac

  # 4. the list introducer's declared convention
  if [ -n "$intro" ]; then
    local lcintro; lcintro="$(lc "$intro")"
    case "$lcintro" in
      *'as paths'*|*'by path'*|*'paths only'*) printf 'path'; return ;;
      *'as content'*|*'pass it:'*|*'passing as content'*) printf 'content'; return ;;
    esac
  fi

  # 5. a delegation introducer anywhere earlier on this line. This scans the WHOLE prefix, not the
  #    60-char window of rule 2: `Pass it: the skill content, A, B, C, D` declares the convention for
  #    every item in the list, and the later items sit well past any fixed window.
  case "$(lc "$prefix")" in
    *'pass it:'*|*'as content'*|*'passing as content'*) printf 'content'; return ;;
  esac

  # 6. an explicit paths-only list directive
  case "$lcline" in
    *'paths only'*) printf 'path'; return ;;
  esac

  printf 'undetermined'
}

# ---------------------------------------------------------------------------
# Pass over the manifest
# ---------------------------------------------------------------------------
rows=0; compliant=0; violations=0; cap_violations=0; unresolved=0; ambiguous=0; exempt=0
# base_total is the PRE-REFACTOR content relay: every in-scope seam's full fixture payload, computed
# from manifest + fixture alone and independent of what the command bodies currently say. cur_total is
# what actually crosses main now, derived per seam. Reduction is measured against the fixed baseline,
# never against a projection — a projection-based reduction reads ~98% while nothing has been fixed
# yet, and would then collapse to 0% once the refactor lands, failing exactly backwards.
base_total=0; cur_total=0; proj_total=0; exempt_bytes=0
report=""; problems=""

emit_row() { report="${report}$1
"; }

# row <seam> <class> <surface> <step> <shape> <state> <base-bytes> <base-lines> <now> <proj>
#     <isolation> <target>
# Every exit path from the per-seam loop goes through this, so an unresolved seam is still a
# machine-readable row under --format tsv. An early `continue` that printed a text-shaped line while
# tsv was requested made broken seams invisible to any caller parsing column 6.
row() {
  if [ "$FORMAT" = tsv ]; then
    emit_row "$(printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s' \
      "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "${10}" "${11}" "${12}")"
  else
    emit_row "$(printf '%-7s %-6s %-12s %-15s %-9s %9s %6s %9s %9s  %s' \
      "$1" "$2" "$5" "$6" "$4" "$7" "$8" "$9" "${10}" "${11}")"
  fi
}

while IFS=$'\t' read -r seam_id class surface step anchor payload_token list_intro \
                        payload_glob reps producer consumer on_disk isolation blast_radius target; do
  case "$seam_id" in ''|'#'*|'seam_id') continue ;; esac
  rows=$((rows + 1))

  src="$WORKFLOW/$surface"
  if [ ! -f "$src" ]; then
    unresolved=$((unresolved + 1))
    problems="${problems}UNRESOLVED $seam_id — surface missing: $surface
"
    row "$seam_id" "$class" "$surface" "$step" "-" 'SURFACE-MISSING' '-' '-' '-' '-' "$isolation" "$target"
    continue
  fi

  # locate the directive: exactly one line must match the anchor
  hits="$(grep -c -E -- "$anchor" "$src")"
  if [ "$hits" -ne 1 ]; then
    unresolved=$((unresolved + 1))
    if [ "$hits" -eq 0 ]; then
      problems="${problems}UNRESOLVED $seam_id — anchor matches no line in $surface (stale seam or the surface changed): /$anchor/
"
      state='ANCHOR-MISS'
    else
      problems="${problems}UNRESOLVED $seam_id — anchor matches $hits lines in $surface; it must identify one: /$anchor/
"
      state='ANCHOR-AMBIG'
    fi
    row "$seam_id" "$class" "$surface" "$step" '-' "$state" '-' '-' '-' '-' "$isolation" "$target"
    continue
  fi
  directive="$(grep -E -- "$anchor" "$src")"

  intro_line=''
  if [ "$list_intro" != '-' ] && [ -n "$list_intro" ]; then
    intro_line="$(grep -E -m1 -- "$list_intro" "$src" || true)"
  fi

  shape="$(derive_shape "$directive" "$payload_token" "$intro_line")"

  # fixture bytes and lines for one repetition, times the repetition count
  bytes=0; lines=0; missing=''
  OLD_IFS="$IFS"; IFS=','
  for rel in $payload_glob; do
    f="$FIXTURE/$rel"
    if [ ! -f "$f" ]; then missing="$missing $rel"; continue; fi
    bytes=$((bytes + $(wc -c < "$f" | tr -d ' ')))
    lines=$((lines + $(wc -l < "$f" | tr -d ' ')))
  done
  IFS="$OLD_IFS"
  if [ -n "$missing" ]; then
    unresolved=$((unresolved + 1))
    problems="${problems}UNRESOLVED $seam_id — fixture file(s) missing:$missing (run make-fixture.sh)
"
    row "$seam_id" "$class" "$surface" "$step" "$shape" 'FIXTURE-MISSING' '-' '-' '-' '-' "$isolation" "$target"
    continue
  fi
  bytes=$((bytes * reps)); lines=$((lines * reps))

  # compliant projection: the path string per repetition, plus the cap for a capped-summary target
  path_bytes=0
  OLD_IFS="$IFS"; IFS=','
  for rel in $payload_glob; do path_bytes=$((path_bytes + ${#rel} + 1)); done
  IFS="$OLD_IFS"
  path_bytes=$((path_bytes * reps))
  case "$target" in
    path+capped-summary) projected=$((path_bytes + CAP_BYTES * reps)) ;;
    *)                   projected=$path_bytes ;;
  esac
  [ "$projected" -gt "$bytes" ] && projected=$bytes

  case "$shape" in
    token-miss|undetermined)
      unresolved=$((unresolved + 1))
      problems="${problems}UNRESOLVED $seam_id — relay shape could not be derived ($shape) for payload token '$payload_token' in $surface $step; classify it by hand rather than assuming
"
      state="SHAPE-$shape" ;;

    path)
      # already path-passing: only the path string crosses main
      compliant=$((compliant + 1))
      state='COMPLIANT'
      if [ "$isolation" = 'ambiguous' ]; then
        ambiguous=$((ambiguous + 1))
        problems="${problems}AMBIGUOUS $seam_id — path-passing already, but the isolation contract does not settle this payload; confirm the consumer keeps equivalent isolated context before the refactor relies on it
"
      fi
      base_total=$((base_total + bytes))
      cur_total=$((cur_total + path_bytes)); proj_total=$((proj_total + path_bytes)) ;;

    content)
      case "$target" in
        content-required)
          # intentional context isolation: measured, but outside the reduction accounting entirely
          exempt=$((exempt + 1)); exempt_bytes=$((exempt_bytes + bytes))
          state='EXEMPT-CONTENT' ;;
        *)
          violations=$((violations + 1))
          state='VIOLATION'
          base_total=$((base_total + bytes))
          cur_total=$((cur_total + bytes)); proj_total=$((proj_total + projected))
          problems="${problems}VIOLATION $seam_id ($class) — $surface $step relays '$payload_token' as CONTENT; target is $target. Measured $bytes bytes / $lines lines across $reps repetition(s) of the fixed fixture. Derived from: ${directive:0:120}
"
          if [ "$target" = 'path+capped-summary' ] && { [ "$lines" -gt $((CAP_LINES * reps)) ] || [ "$bytes" -gt $((CAP_BYTES * reps)) ]; }; then
            cap_violations=$((cap_violations + 1))
            problems="${problems}CAP $seam_id — the relayed payload exceeds the summary cap: $lines lines / $bytes bytes against $((CAP_LINES * reps)) lines / $((CAP_BYTES * reps)) bytes
"
          fi
          if [ "$isolation" = 'ambiguous' ]; then
            ambiguous=$((ambiguous + 1))
            problems="${problems}AMBIGUOUS $seam_id — the isolation contract does not settle whether this content relay is required; required-reference-files.md § Path-passing convention names reference docs as path-passable and per-chapter inputs as intentionally content-passed, and this payload is neither. Do not convert it without establishing how the consumer retains equivalent isolated context
"
          fi ;;
      esac ;;
  esac

  if [ "$shape" = path ]; then now="$path_bytes"; else now="$bytes"; fi
  row "$seam_id" "$class" "$surface" "$step" "$shape" "$state" "$bytes" "$lines" "$now" "$projected" "$isolation" "$target"
done < "$MANIFEST"

[ "$rows" -eq 0 ] && die "manifest contained no seam rows: $MANIFEST"

# ---------------------------------------------------------------------------
# Aggregate and verdict
# ---------------------------------------------------------------------------
if [ "$base_total" -gt 0 ]; then
  reduction=$(( (base_total - cur_total) * 100 / base_total ))
  projected_reduction=$(( (base_total - proj_total) * 100 / base_total ))
else
  reduction=100; projected_reduction=100
fi

printf 'S1 relay-payload check\n'
printf '  workflow : %s\n' "$WORKFLOW"
printf '  manifest : %s (%s seam-payload rows)\n' "$MANIFEST" "$rows"
printf '  fixture  : %s\n' "$FIXTURE"
printf '  targets  : 100%% named-seam compliance; >=%s%% aggregate byte reduction; summary cap %s lines / %s bytes\n\n' \
  "$TARGET_REDUCTION" "$CAP_LINES" "$CAP_BYTES"

if [ "$FORMAT" = tsv ]; then
  printf 'seam_id\tclass\tsurface\tstep\tderived_shape\tstate\tbaseline_bytes\tbaseline_lines\tcurrent_bytes\tprojected_bytes\tisolation\ttarget\n'
else
  printf '%-7s %-6s %-12s %-15s %-9s %9s %6s %9s %9s  %s\n' \
    SEAM CLASS DERIVED STATE STEP BASE-B BASE-L NOW-B PROJ-B ISOLATION
  printf -- '-------------------------------------------------------------------------------------------------------\n'
fi
printf '%s' "$report"

printf '\nPer-class coverage:\n'
for c in W4-H1 W4-H2 W4-H3 W4-H4; do
  n="$(awk -F'\t' -v c="$c" '$1 !~ /^#/ && $1 != "seam_id" && $2 == c { n++ } END { print n+0 }' "$MANIFEST")"
  printf '  %-6s %s row(s)\n' "$c" "$n"
done

printf '\nAggregate over the fixed fixture (contract-exempt content excluded from the accounting):\n'
printf '  pre-refactor baseline   : %s bytes\n' "$base_total"
printf '  current relayed bytes   : %s\n' "$cur_total"
printf '  ACHIEVED reduction      : %s%% (target >=%s%%)\n' "$reduction" "$TARGET_REDUCTION"
printf '  reduction still on offer : %s%% if every measured violation is converted (informational)\n' "$projected_reduction"
printf '  contract-exempt content : %s bytes across %s seam(s)\n' "$exempt_bytes" "$exempt"
printf '  compliant seams         : %s / %s\n' "$compliant" "$rows"
printf '  measured violations     : %s\n' "$violations"
printf '  cap violations          : %s\n' "$cap_violations"
printf '  ambiguous (unsettled)   : %s\n' "$ambiguous"
printf '  unresolved (uncovered)  : %s\n' "$unresolved"

if [ -n "$problems" ]; then
  printf '\nFindings:\n'
  printf '%s' "$problems" | sed 's/^/  /'
fi

fail=0
[ "$violations" -gt 0 ] && fail=1
[ "$cap_violations" -gt 0 ] && fail=1
[ "$unresolved" -gt 0 ] && fail=1
[ "$ambiguous" -gt 0 ] && fail=1
[ "$reduction" -lt "$TARGET_REDUCTION" ] && fail=1

if [ "$fail" -eq 0 ]; then
  printf '\nverdict: TARGET MET\n'
  exit 0
fi
printf '\nverdict: TARGET NOT MET\n'
exit 1
