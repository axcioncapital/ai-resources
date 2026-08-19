#!/usr/bin/env bash
# research-route-memo-check.sh — structural floor for a Standard-route research memo.
#
# What it is for: a Standard memo can look finished while quietly asserting something no
# source supports. Each rule below closes one of those routes. It checks STRUCTURE — that
# claims carry sources, that sources carry dates, that evidence and inference stay apart,
# and that a memo cannot mark itself complete over an unresolved claim or a live Deep
# trigger. It does NOT judge whether the analysis is any good; nothing automated can.
#
# Usage:  research-route-memo-check.sh --memo <path> [--authority-root <dir>]
#
#   --authority-root  the deployed project root that carries the judgment artifacts and
#                     L2's validator. Only consulted when the memo binds to governing
#                     judgment. Defaults to the memo's own git top level, else its directory.
#
# Prints `verdict: PASS` (exit 0) or `verdict: REJECT` (exit 1) followed by one
# `reason:` line per failure. Exits 2 on a usage error.

set -u

die() { printf 'ERROR: %s\n' "$1" >&2; exit 2; }

memo=""
authority_root=""
while [ $# -gt 0 ]; do
  case "$1" in
    --memo) [ $# -ge 2 ] || die "--memo needs a path"; memo="$2"; shift 2 ;;
    --authority-root)
      [ $# -ge 2 ] || die "--authority-root needs a directory"; authority_root="$2"; shift 2 ;;
    *) die "unknown argument: $1" ;;
  esac
done
[ -n "$memo" ] || die "--memo is required"
[ -r "$memo" ] || die "memo is not readable: $memo"

if [ -z "$authority_root" ]; then
  authority_root="$(git -C "$(dirname "$memo")" rev-parse --show-toplevel 2>/dev/null)" \
    || authority_root=""
  [ -n "$authority_root" ] || authority_root="$(cd "$(dirname "$memo")" && pwd -P)"
fi

reasons=()
add() { reasons+=("$1"); }

# --- required memo sections -------------------------------------------------
for section in Claims Answer Inference Unknowns Completion; do
  count="$(grep -cE "^## ${section} *$" "$memo" || true)"
  if [ "$count" -ne 1 ]; then
    add "required section '## $section' must appear exactly once (found $count)"
  fi
done

# --- the claim blocks -------------------------------------------------------
# A claim block runs from its `### C<n> — ` heading to the next `###`/`##` heading.
claim_ids="$(grep -oE '^### C[0-9]+ ' "$memo" | tr -d '#' | tr -d ' ')"

if [ -z "$claim_ids" ]; then
  add "the memo declares no claims — a Standard memo states its claims under '## Claims' as '### C1 — ...'"
fi

duplicate_ids="$(printf '%s\n' $claim_ids | sort | uniq -d)"
[ -z "$duplicate_ids" ] || add "claim IDs must be unique (duplicated: $(printf '%s' "$duplicate_ids" | tr '\n' ' '))"

claim_class() {
  awk -v id="$1" '
    /^#{2,3} / { inside = (index($0, "### " id " ") == 1) }
    inside { print }
  ' "$memo" | sed -n 's/^Class: *//p' | head -1
}

for id in $claim_ids; do
  block="$(awk -v id="$id" '
    /^#{2,3} / { inside = (index($0, "### " id " ") == 1) }
    inside { print }
  ' "$memo")"

  class_lines="$(printf '%s\n' "$block" | grep -c '^Class: ' || true)"
  class="$(printf '%s\n' "$block" | sed -n 's/^Class: *//p' | head -1)"

  [ "$class_lines" -eq 1 ] || add "$id must carry exactly one Class: line (found $class_lines)"

  case "$class" in
    SUPPORTED|PROXY-SUPPORTED|ILLUSTRATIVE-ONLY|NOT-SUPPORTED) ;;
    "") add "$id has no Class: line — every claim carries one of the four permission classes" ;;
    *)  add "$id has an unknown Class '$class' — use SUPPORTED, PROXY-SUPPORTED, ILLUSTRATIVE-ONLY or NOT-SUPPORTED" ;;
  esac

  roles_lines="$(printf '%s\n' "$block" | grep -c '^Roles: ' || true)"
  roles_line="$(printf '%s\n' "$block" | sed -n 's/^Roles: *//p' | head -1)"
  declared_roles="$(printf '%s\n' "$roles_line" | sed -E -n 's/^([0-9]+)([[:space:]].*)?$/\1/p')"
  [ "$roles_lines" -eq 1 ] || add "$id must carry exactly one Roles: line (found $roles_lines)"
  [ -n "$declared_roles" ] || add "$id has a malformed Roles: line — begin it with the numeric independent-role count"

  rationale_lines="$(printf '%s\n' "$block" | grep -c '^Rationale: ' || true)"
  [ "$rationale_lines" -eq 1 ] || add "$id must carry exactly one Rationale: line (found $rationale_lines)"

  # Claim blocks use a closed line schema. Free prose here would let an inference sit inside
  # the evidence record without declaring itself under the Inference section.
  while IFS= read -r claim_line; do
    case "$claim_line" in
      ""|"### $id —"*|"### $id --"*|Class:\ *|Roles:\ *|Source:\ *|Rationale:\ *) ;;
      *) add "$id contains undeclared claim-block content — move inference to '## Inference' and bind analysis under '## Answer'" ;;
    esac
  done <<< "$block"

  sources="$(printf '%s\n' "$block" | grep -c '^Source: ' || true)"
  source_roles=""
  proxy_fits=0
  invalid_source_fields=0

  # A claim that is not NOT-SUPPORTED asserts something, so it must map to evidence.
  if [ "$class" != "NOT-SUPPORTED" ] && [ "$sources" -eq 0 ]; then
    add "$id is classed '$class' but maps to no Source line — a load-bearing claim without a mapped source cannot be graded"
  fi

  # Every source line must carry a date or an explicit undated marker.
  while IFS= read -r line; do
    [ -n "$line" ] || continue
    if ! printf '%s' "$line" | grep -qE '(—|--) *Date: *[^ ]'; then
      add "$id has a Source with no Date: field — give the source's date or the explicit marker 'undated'"
    fi
    if ! printf '%s' "$line" | grep -qE '— *Role: *[^—]+ *— *Fit: *(direct|proxy) *$'; then
      add "$id has a malformed Source line — every source needs 'Role: ... — Fit: direct|proxy'"
      invalid_source_fields=1
      continue
    fi
    source_role="$(printf '%s\n' "$line" | sed -E 's/.*— *Role: *([^—]+) *— *Fit:.*/\1/' | sed -E 's/[[:space:]]+$//')"
    source_fit="$(printf '%s\n' "$line" | sed -E 's/.*— *Fit: *(direct|proxy) *$/\1/')"
    source_roles="${source_roles}${source_roles:+$'\n'}$source_role"
    [ "$source_fit" != "proxy" ] || proxy_fits=$((proxy_fits + 1))
  done < <(printf '%s\n' "$block" | grep '^Source: ' || true)

  distinct_roles="$(printf '%s\n' "$source_roles" | awk 'NF && !seen[$0]++ { n++ } END { print n + 0 }')"
  if [ -n "$declared_roles" ] && [ "$invalid_source_fields" -eq 0 ] && [ "$declared_roles" -ne "$distinct_roles" ]; then
    add "$id declares $declared_roles role(s) but its mapped Source lines contain $distinct_roles distinct role(s)"
  fi

  if [ -n "$declared_roles" ]; then
    case "$class" in
      SUPPORTED)
        if [ "$declared_roles" -lt 2 ] || [ "$sources" -lt 2 ] || [ "$distinct_roles" -lt 2 ]; then
          add "$id is SUPPORTED but requires at least 2 declared and mapped independent roles"
        fi
        [ "$proxy_fits" -eq 0 ] || add "$id is SUPPORTED but carries proxy-fit evidence — cap it at PROXY-SUPPORTED or lower"
        ;;
      PROXY-SUPPORTED)
        if [ "$declared_roles" -lt 2 ] || [ "$sources" -lt 2 ] || [ "$distinct_roles" -lt 2 ]; then
          add "$id is PROXY-SUPPORTED but requires at least 2 declared and mapped independent roles"
        fi
        [ "$proxy_fits" -ge 1 ] || add "$id is PROXY-SUPPORTED but no mapped source is marked Fit: proxy"
        ;;
      ILLUSTRATIVE-ONLY)
        if [ "$declared_roles" -ne 1 ] || [ "$sources" -lt 1 ] || [ "$distinct_roles" -ne 1 ]; then
          add "$id is ILLUSTRATIVE-ONLY and requires exactly 1 declared and mapped independent role"
        fi
        ;;
      NOT-SUPPORTED)
        [ "$declared_roles" -eq 0 ] || add "$id is NOT-SUPPORTED and must declare Roles: 0"
        [ "$sources" -eq 0 ] || add "$id is NOT-SUPPORTED but maps supporting Source lines — grade the evidence or record searched surfaces in Rationale"
        ;;
    esac
  fi

  # Evidence and inference must not be collapsed into the claim block.
  if printf '%s\n' "$block" | grep -qF '[INFERENCE]'; then
    add "$id carries an [INFERENCE] marker inside the claim block — inference belongs under '## Inference', separate from the evidence it rests on"
  fi
done

# --- bound judgment authority ----------------------------------------------
# The one way a Standard memo may represent a governing view. The rules the authority itself
# must satisfy are NOT restated here: they belong to the published contract
# (workflows/research-workflow/docs/judgment-authority-contract.md), and the adapter asks
# that contract's own validator. What this section checks is the BINDING — that the memo
# names one unit and one approved artifact, and that the adapter returns valid authority for
# them. An adapter that cannot run is a rejection, never a pass: an unestablished binding and
# a valid one must not read the same.
authority_adapter="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/research-route-judgment-authority.sh"
authority_heads="$(grep -cE '^## Judgment authority *$' "$memo" || true)"
authority_bound=0
authority_theses=0

if [ "$authority_heads" -gt 1 ]; then
  add "the memo carries $authority_heads '## Judgment authority' sections — a memo binds to exactly one approved judgment"
elif [ "$authority_heads" -eq 1 ]; then
  authority_block="$(awk '
    /^```/ { fence = !fence }
    !fence && /^## / { inside = (index($0, "## Judgment authority") == 1); next }
    inside { print }
  ' "$memo")"

  unit_lines="$(printf '%s\n' "$authority_block" | grep -c '^Unit: ' || true)"
  brief_lines="$(printf '%s\n' "$authority_block" | grep -c '^Approved brief: ' || true)"
  authority_unit="$(printf '%s\n' "$authority_block" | sed -n 's/^Unit: *//p' | head -1)"
  authority_brief="$(printf '%s\n' "$authority_block" | sed -n 's/^Approved brief: *//p' | head -1)"

  # A closed line schema. Free prose here is how a memo comes to assert its own verification
  # — "Verified: yes, I checked it" reads exactly like a result and is not one.
  schema_ok=1
  while IFS= read -r authority_line; do
    case "$authority_line" in
      ""|Unit:\ *|Approved\ brief:\ *) ;;
      *) schema_ok=0 ;;
    esac
  done <<< "$authority_block"
  [ "$schema_ok" -eq 1 ] || add "the '## Judgment authority' block carries content outside its closed schema — it holds exactly one 'Unit:' line and one 'Approved brief:' line, and nothing that could be mistaken for a verification the memo performed on itself"

  [ "$unit_lines" -eq 1 ] || add "the '## Judgment authority' block must carry exactly one 'Unit:' line (found $unit_lines)"
  [ "$brief_lines" -eq 1 ] || add "the '## Judgment authority' block must carry exactly one 'Approved brief:' line (found $brief_lines)"

  case "$authority_brief" in
    *-approved.md) ;;
    "") add "the '## Judgment authority' block names no approved brief" ;;
    *) add "judgment authority binds only to a '{base}-approved.md' artifact — '$authority_brief' is not one, and a proposed or rejected brief never becomes authority" ;;
  esac

  if [ "$schema_ok" -eq 1 ] && [ "$unit_lines" -eq 1 ] && [ "$brief_lines" -eq 1 ] \
     && [ -n "$authority_unit" ]; then
    case "$authority_brief" in
      *-approved.md)
        case "$authority_brief" in
          /*) authority_path="$authority_brief" ;;
          *)  authority_path="$authority_root/$authority_brief" ;;
        esac
        if [ ! -r "$authority_adapter" ]; then
          add "the judgment-authority adapter is unavailable at $authority_adapter — the binding cannot be established (contract-exit: none)"
        else
          adapter_out="$(bash "$authority_adapter" \
            --root "$authority_root" --unit "$authority_unit" \
            --base "${authority_path%-approved.md}" 2>&1)"
          adapter_rc=$?
          if [ "$adapter_rc" -eq 0 ]; then
            authority_bound=1
            authority_theses="$(printf '%s\n' "$adapter_out" | sed -n 's/^theses: //p' | head -1)"
            [ -n "$authority_theses" ] || authority_theses=0
          else
            add "the bound judgment authority is not contract-valid: $(printf '%s\n' "$adapter_out" | sed -n 's/^reason: //p' | head -1) ($(printf '%s\n' "$adapter_out" | grep '^contract-exit: ' | head -1))"
          fi
        fi
        ;;
    esac
  fi
fi

# --- completion -------------------------------------------------------------
status_lines="$(grep -c '^Status: ' "$memo" || true)"
trigger_lines="$(grep -c '^Deep triggers: ' "$memo" || true)"
status="$(sed -n 's/^Status: *//p' "$memo" | head -1)"
triggers="$(sed -n 's/^Deep triggers: *//p' "$memo" | head -1)"

[ "$status_lines" -eq 1 ] || add "the memo must carry exactly one Status: line (found $status_lines)"
[ "$trigger_lines" -eq 1 ] || add "the memo must carry exactly one Deep triggers: line (found $trigger_lines)"

case "$status" in
  COMPLETE|ESCALATED-TO-DEEP) ;;
  "") add "the memo has no Status: line — a Standard memo declares COMPLETE or ESCALATED-TO-DEEP" ;;
  *)  add "unknown Status '$status' — use COMPLETE or ESCALATED-TO-DEEP" ;;
esac

if [ -z "$triggers" ]; then
  add "the memo has no 'Deep triggers:' line — state the trigger that fired, or 'none'"
elif [ "$status" = "COMPLETE" ] && [ "$triggers" != "none" ]; then
  add "Status is COMPLETE while a Deep trigger is live ('$triggers') — escalation is one way; set ESCALATED-TO-DEEP"
elif [ "$status" = "ESCALATED-TO-DEEP" ] && [ "$triggers" = "none" ]; then
  add "Status is ESCALATED-TO-DEEP but Deep triggers is none — name the live trigger that owns the handoff"
fi

if [ "$status" = "COMPLETE" ] && printf '%s' "$claim_ids" | grep -q .; then
  for id in $claim_ids; do
    c="$(awk -v id="$id" '
      /^#{2,3} / { inside = (index($0, "### " id " ") == 1) }
      inside { print }
    ' "$memo" | sed -n 's/^Class: *//p' | head -1)"
    if [ "$c" = "NOT-SUPPORTED" ]; then
      add "Status is COMPLETE while $id is NOT-SUPPORTED — an unresolved load-bearing claim cannot be completed as Standard work"
    fi
  done
fi

# --- answer-to-claim binding and verb permission ---------------------------
# Every material Answer line cites the claim IDs that license it. This makes the verb
# check claim-local: a SUPPORTED claim elsewhere cannot launder a stronger verb over C2.
#
# A line may also cite thesis IDs (T1, T2 ...) when the memo binds to approved judgment.
# The two reference families do different jobs and neither substitutes for the other: a C
# reference is an evidence permission, a T reference is the authorized thesis the assertion
# serves. So an assertion still needs a C reference to say anything factual, and under bound
# authority it also needs a T reference to say what governs it.
answer_lines="$(awk '
  /^```/ { fence = !fence }
  !fence && /^## / { inside = (index($0, "## Answer") == 1); next }
  inside { print }
' "$memo")"
answer_assertions=0
while IFS= read -r line; do
  [ -n "$line" ] || continue
  answer_assertions=$((answer_assertions + 1))
  if [[ ! "$line" =~ ^-\ \[[CT][0-9]+(,[[:space:]]*[CT][0-9]+)*\][[:space:]]+.+ ]]; then
    add "the Answer must put each material assertion on one line as '- [C1]' or '- [C1,C2]' so its evidence permission is checkable"
    continue
  fi
  refs="$(printf '%s\n' "$line" | sed -E 's/^- \[([^]]+)\].*/\1/' | grep -oE '[CT][0-9]+')"
  claim_refs=0
  thesis_refs=0
  for ref in $refs; do
    case "$ref" in
      T*)
        thesis_refs=$((thesis_refs + 1))
        if [ "$authority_bound" -ne 1 ]; then
          add "the Answer cites thesis $ref without contract-valid bound judgment authority — a thesis reference means nothing except against an approved Unit Judgment Brief"
        elif [ "${ref#T}" -lt 1 ] || [ "${ref#T}" -gt "$authority_theses" ]; then
          add "the Answer cites thesis $ref, which the approved brief does not carry (it holds $authority_theses)"
        fi
        continue
        ;;
    esac
    claim_refs=$((claim_refs + 1))
    if ! printf '%s\n' $claim_ids | grep -qx "$ref"; then
      add "the Answer cites undeclared claim $ref"
      continue
    fi
    if printf '%s' "$line" | grep -qiE '\b(establishes|confirms|demonstrates)\b'; then
      ref_class="$(claim_class "$ref")"
      [ "$ref_class" = "SUPPORTED" ] \
        || add "the Answer uses a SUPPORTED-only verb for $ref, which is $ref_class"
    fi
  done
  # Authority frames a conclusion; it never supplies the evidence for one. An assertion
  # resting on a thesis alone has no evidence permission at all, and bound authority must not
  # become the way a memo says something no source supports.
  [ "$claim_refs" -ge 1 ] \
    || add "an Answer assertion citing only judgment authority carries no evidence permission — a thesis frames a conclusion, it never licenses a factual assertion"
  if [ "$authority_bound" -eq 1 ] && [ "$thesis_refs" -lt 1 ]; then
    add "the Answer assertion cites no thesis — under bound judgment authority every consequential assertion names the thesis it serves"
  fi
done <<< "$answer_lines"
[ "$answer_assertions" -ge 1 ] || add "the Answer contains no claim-bound assertion"

# Inference is either explicitly absent or marked and bound to the claims it extends.
inference_lines="$(awk '
  /^```/ { fence = !fence }
  !fence && /^## / { inside = (index($0, "## Inference") == 1); next }
  inside { print }
' "$memo")"
inference_items=0
while IFS= read -r line; do
  [ -n "$line" ] || continue
  inference_items=$((inference_items + 1))
  [ "$line" = "- None." ] && continue
  if [[ ! "$line" =~ ^-\ \[INFERENCE\].*C[0-9]+ ]]; then
    add "each Inference item must be '- None.' or carry [INFERENCE] and name the claim IDs it rests on"
    continue
  fi
  for ref in $(printf '%s\n' "$line" | grep -oE 'C[0-9]+'); do
    printf '%s\n' $claim_ids | grep -qx "$ref" || add "the Inference section cites undeclared claim $ref"
  done
done <<< "$inference_lines"
[ "$inference_items" -ge 1 ] || add "the Inference section must state '- None.' or declare at least one marked inference"

unknown_lines="$(awk '
  /^```/ { fence = !fence }
  !fence && /^## / { inside = (index($0, "## Unknowns") == 1); next }
  inside { print }
' "$memo")"
printf '%s\n' "$unknown_lines" | grep -qE '^- ' \
  || add "the Unknowns section must contain at least one bullet, including '- None material.' when appropriate"

# --- the reserved authority term -------------------------------------------
# This rule used to be a blanket rejection, because there was no published contract to
# validate against and a conservative refusal was the only safe mechanical rule. L2's
# contract is now published, so the refusal is replaced by a BINDING — and only that far.
# Unbound, the answer is unchanged: the term may not appear. What changed is that a memo
# now has a way to earn it, not that the seam opened.
names_reserved_term=0
grep -qiE 'house[ -]?view' "$memo" && names_reserved_term=1  # only '## Judgment authority' binds it
if [ "$names_reserved_term" -eq 1 ] && [ "$authority_bound" -ne 1 ]; then
  add "the memo names the reserved House View term without contract-valid bound judgment authority — Standard may compare readings, but it cannot represent a governing view except through an approved Unit Judgment Brief consumed under '## Judgment authority'"
fi

# --- verdict ----------------------------------------------------------------
if [ "${#reasons[@]}" -eq 0 ]; then
  printf 'verdict: PASS\n'
  exit 0
fi

printf 'verdict: REJECT\n'
for r in "${reasons[@]}"; do printf 'reason: %s\n' "$r"; done
exit 1
