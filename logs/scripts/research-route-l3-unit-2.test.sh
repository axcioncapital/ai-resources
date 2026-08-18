#!/usr/bin/env bash
# Acceptance harness — canonical-rw-lightweight-l3, Unit 2: Standard evidence-controlled slice.
#
#   ROUTING. The real entry and classifier are exercised for bounded Standard analysis,
#            safety-driven escalation, and malformed signal vectors that must fail closed.
#   MEMO CONTROL. The Standard checker must reject every structurally under-controlled
#            memo represented here and accept both a minimal valid memo and an honest
#            escalation. Rejections assert verdict text, reason and exit status.
#   STRUCTURE. The entry's Standard section specifies the memo, completion refusal and
#            closed House View seam.
#
# What this CANNOT prove is stated rather than implied: no automated check executes a
# model-produced Standard memo or judges its analytical quality. The memo fixtures prove
# the checker rejects represented malformations; they say nothing about whether a real memo
# is any good. That
# evidence is owed by the plan's later operator-run assignment.
#
# Run BEFORE the Standard route exists (must fail) and AFTER (must pass).

REPO="$(git -C "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)" rev-parse --show-toplevel)" || {
  printf 'ERROR: not inside a git checkout\n' >&2; exit 1; }

ENTRY_REAL="$REPO/.claude/commands/research-route.md"
CLASSIFY="$REPO/logs/scripts/research-route-classify.sh"
MEMOCHECK="$REPO/logs/scripts/research-route-memo-check.sh"

pass=0; fail=0
ok() { printf 'PASS  %s\n' "$1"; pass=$((pass + 1)); }
no() { printf 'FAIL  %s — %s\n' "$1" "$2"; fail=$((fail + 1)); }

WORK="$(mktemp -d "${TMPDIR:-/tmp}/rr-unit2.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT

# Fixture project: the entry is reached the way a deployed project reaches it.
mkdir -p "$WORK/proj/.claude/commands"
ln -s "$ENTRY_REAL" "$WORK/proj/.claude/commands/research-route.md" 2>/dev/null
ENTRY="$WORK/proj/.claude/commands/research-route.md"

resolve_consumer_helper() {
  helper_name="$1"
  cd "$WORK/proj" || exit 1
  research_entry=.claude/commands/research-route.md
  while [ -L "$research_entry" ]; do
    research_target="$(readlink "$research_entry")" || exit 1
    case "$research_target" in
      /*) research_entry="$research_target" ;;
      *)  research_entry="$(dirname "$research_entry")/$research_target" ;;
    esac
  done
  research_root="$(git -C "$(dirname "$research_entry")" rev-parse --show-toplevel 2>/dev/null)" || exit 1
  printf '%s/logs/scripts/%s\n' "$research_root" "$helper_name"
}

if resolved_checker="$(resolve_consumer_helper research-route-memo-check.sh)" && [ "$resolved_checker" = "$MEMOCHECK" ]; then
  ok "B-P1 the documented consumer path resolves the canonical memo checker"
else
  no "B-P1 the documented consumer path resolves the canonical memo checker" \
    "resolved '$resolved_checker', expected '$MEMOCHECK'"
fi

if resolved_classifier="$(resolve_consumer_helper research-route-classify.sh)" && [ "$resolved_classifier" = "$CLASSIFY" ]; then
  ok "B-P3 the documented consumer path resolves the canonical classifier"
else
  no "B-P3 the documented consumer path resolves the canonical classifier" \
    "resolved '$resolved_classifier', expected '$CLASSIFY'"
fi

section() {
  awk -v want="$1" '
    /^```/ { fence = !fence }
    !fence && /^## / { inside = (index($0, "## " want) == 1) }
    inside { print }
  ' "$ENTRY" 2>/dev/null
}

step3="$(section 'Step 3')"
if printf '%s' "$step3" | grep -qF 'must run the executable classifier' &&
   printf '%s' "$step3" | grep -qF 'cannot safely resolve a route' &&
   ! printf '%s' "$step3" | grep -qF 'it is not required'; then
  ok "B-P4 Step 3 requires executable classification and fails closed when unavailable"
else
  no "B-P4 Step 3 requires executable classification and fails closed when unavailable" \
    "mandatory fail-closed classifier instruction is missing or still optional"
fi

# ---------------------------------------------------------------------------
# B1 – B6 — routing
# ---------------------------------------------------------------------------
route() {
  local label="$1" want_route="$2" want_over="$3" pref="$4"; shift 4
  local args=() s out got_route got_over
  for s in "$@"; do args+=(--signal "$s"); done
  if [ ! -r "$CLASSIFY" ]; then no "$label" "classifier absent"; return; fi
  out="$(bash "$CLASSIFY" --entry "$ENTRY" --preference "$pref" "${args[@]}" 2>&1)" || {
    no "$label" "classifier exited non-zero: $out"; return; }
  got_route="$(printf '%s\n' "$out" | sed -n 's/^route: //p')"
  got_over="$(printf '%s\n' "$out" | sed -n 's/^preference-overridden: //p')"
  if [ "$got_route" != "$want_route" ]; then
    no "$label" "route=$got_route, expected $want_route"
  elif [ "$got_over" != "$want_over" ]; then
    no "$label" "preference-overridden=$got_over, expected $want_over"
  else
    ok "$label"
  fi
}

route "B1 a bounded internal analysis routes Standard" \
  standard no none output=analysis consequence=internal scope=bounded \
  load_bearing_claim=yes thesis_judgment=no

route "B2 a bounded internal analysis still routes Standard with no preference stated" \
  standard no none output=analysis consequence=internal scope=bounded \
  load_bearing_claim=no thesis_judgment=no

route "B3 a stated Light preference cannot lower an analysis to Light" \
  standard yes light output=analysis consequence=internal scope=bounded \
  load_bearing_claim=no thesis_judgment=no

route "B4 a stated Light preference cannot lower an unresolved load-bearing claim" \
  standard yes light output=note consequence=internal scope=bounded \
  load_bearing_claim=yes thesis_judgment=no

route "B5 an internal thesis judgment stays on the Standard seam" \
  standard no none output=analysis consequence=internal scope=bounded \
  load_bearing_claim=no thesis_judgment=yes

route "B6 a consequential thesis selection escalates one way to Deep" \
  deep yes standard output=analysis consequence=external scope=bounded \
  load_bearing_claim=no thesis_judgment=yes

route_reject() {
  local label="$1" want_reason="$2"; shift 2
  local args=() s out rc
  for s in "$@"; do args+=(--signal "$s"); done
  out="$(bash "$CLASSIFY" --entry "$ENTRY" --preference none "${args[@]}" 2>&1)"
  rc=$?
  if [ "$rc" -ne 2 ]; then
    no "$label" "exit=$rc, expected 2 ($(printf '%s' "$out" | tr '\n' ';'))"
  elif ! printf '%s' "$out" | grep -qF -- "$want_reason"; then
    no "$label" "error did not name '$want_reason': $(printf '%s' "$out" | tr '\n' ';')"
  else
    ok "$label"
  fi
}

route_reject "B-R1 a missing safety signal fails closed" "missing required signal" \
  output=note consequence=internal scope=bounded thesis_judgment=no

route_reject "B-R2 an invalid signal value fails closed" "invalid value" \
  output=note consequence=internal scope=bounded load_bearing_claim=maybe thesis_judgment=no

route_reject "B-R3 a duplicate signal fails closed" "duplicate signal" \
  output=note consequence=internal scope=bounded load_bearing_claim=no \
  load_bearing_claim=yes thesis_judgment=no

route_reject "B-R4 an unknown signal key fails closed" "unknown signal" \
  output=note consequence=internal scope=bounded load_bearing_claim=no \
  thesis_judgment=no audience=internal

# ---------------------------------------------------------------------------
# Memo control
# ---------------------------------------------------------------------------
# memo <label> <expect PASS|REJECT> <reason-substring-or-empty> <<< body on stdin
memo() {
  local label="$1" want="$2" want_reason="$3"
  local f="$WORK/memo-$((pass + fail)).md" out verdict rc want_rc
  cat > "$f"
  if [ ! -r "$MEMOCHECK" ]; then no "$label" "memo checker absent: $MEMOCHECK"; return; fi
  out="$(bash "$MEMOCHECK" --memo "$f" 2>&1)"
  rc=$?
  if [ "$want" = "PASS" ]; then want_rc=0; else want_rc=1; fi
  verdict="$(printf '%s\n' "$out" | sed -n 's/^verdict: //p')"
  if [ "$verdict" != "$want" ]; then
    no "$label" "verdict=$verdict, expected $want ($(printf '%s' "$out" | tr '\n' ';'))"
  elif [ "$rc" -ne "$want_rc" ]; then
    no "$label" "exit=$rc, expected $want_rc ($(printf '%s' "$out" | tr '\n' ';'))"
  elif [ -n "$want_reason" ] && ! printf '%s' "$out" | grep -qF -- "$want_reason"; then
    no "$label" "verdict correct but reason did not name '$want_reason': $(printf '%s' "$out" | tr '\n' ';')"
  else
    ok "$label"
  fi
}

usage_out="$(bash "$MEMOCHECK" 2>&1)"
usage_rc=$?
if [ "$usage_rc" -eq 2 ] && printf '%s' "$usage_out" | grep -qF -- '--memo is required'; then
  ok "B-P2 memo-checker usage errors exit 2"
else
  no "B-P2 memo-checker usage errors exit 2" "exit=$usage_rc output=$usage_out"
fi

memo "B7 a minimal valid Standard memo is accepted" PASS "" <<'EOF'
# Does the sweep reach this lane?

## Claims

### C1 — The sweep resolves its source by ancestor-walking for a directory named ai-resources.
Class: SUPPORTED
Roles: 2 — hook source; deployed project state
Source: .claude/hooks/auto-sync-shared.sh lines 46-52 — Date: 2026-08-18 — Role: hook source — Fit: direct
Source: projects/ai-development-lab/.claude/commands/ — Date: undated — Role: deployed project state — Fit: direct
Rationale: Two independent roles, both direct and in scope. No ceiling applies; the claim does not generalize.

## Answer
- [C1] The sweep resolves to the canonical directory, so this lane is not a sync source.

## Inference
- [INFERENCE] A command added here therefore takes no live effect in any consumer (rests on C1).

## Unknowns
- Whether a future deployment step would change the resolution order.

## Completion
Status: COMPLETE
Deep triggers: none
EOF

memo "B8 a load-bearing claim with no mapped source is rejected" REJECT "no Source" <<'EOF'
# Q

## Claims

### C1 — Something load-bearing is true.
Class: SUPPORTED
Roles: 2 — a; b
Rationale: asserted.

## Answer
- [C1] It is true.

## Inference
- None.

## Unknowns
- None material.

## Completion
Status: COMPLETE
Deep triggers: none
EOF

memo "B9 a mapped source with no date or undated marker is rejected" REJECT "Date" <<'EOF'
# Q

## Claims

### C1 — Something load-bearing is true.
Class: SUPPORTED
Roles: 2 — a; b
Source: Some report — Role: a — Fit: direct
Source: Other report — Date: 2025-01-02 — Role: b — Fit: direct
Rationale: two roles.

## Answer
- [C1] It is true.

## Inference
- None.

## Unknowns
- None material.

## Completion
Status: COMPLETE
Deep triggers: none
EOF

memo "B10 evidence and inference collapsed into one claim is rejected" REJECT "INFERENCE" <<'EOF'
# Q

## Claims

### C1 — Something load-bearing is true.
Class: SUPPORTED
Roles: 2 — a; b
Source: Some report — Date: 2025-01-02 — Role: a — Fit: direct
Source: Other report — Date: 2025-03-04 — Role: b — Fit: direct
[INFERENCE] and therefore the wider pattern holds.
Rationale: two roles.

## Answer
- [C1] It is true.

## Inference
- None.

## Unknowns
- None material.

## Completion
Status: COMPLETE
Deep triggers: none
EOF

memo "B11 completion claimed despite a Deep trigger is rejected" REJECT "Deep trigger" <<'EOF'
# Q

## Claims

### C1 — Something load-bearing is true.
Class: SUPPORTED
Roles: 2 — a; b
Source: Some report — Date: 2025-01-02 — Role: a — Fit: direct
Source: Other report — Date: 2025-03-04 — Role: b — Fit: direct
Rationale: two roles.

## Answer
- [C1] It is true.

## Inference
- None.

## Unknowns
- None material.

## Completion
Status: COMPLETE
Deep triggers: consequential thesis selection requested
EOF

memo "B12 an unresolved load-bearing claim cannot be completed as Standard" REJECT "NOT-SUPPORTED" <<'EOF'
# Q

## Claims

### C1 — Something load-bearing is true.
Class: NOT-SUPPORTED
Roles: 0 —
Rationale: searched the register and the filings; found neither direct nor proxy evidence.

## Answer
- [C1] It is probably true anyway.

## Inference
- None.

## Unknowns
- None material.

## Completion
Status: COMPLETE
Deep triggers: none
EOF

memo "B13 a House View promotion in the memo is rejected" REJECT "House View" <<'EOF'
# Q

## Claims

### C1 — Something load-bearing is true.
Class: SUPPORTED
Roles: 2 — a; b
Source: Some report — Date: 2025-01-02 — Role: a — Fit: direct
Source: Other report — Date: 2025-03-04 — Role: b — Fit: direct
Rationale: two roles.

## Answer
- [C1] Adopt interpretation B as the House View going forward.

## Inference
- None.

## Unknowns
- None material.

## Completion
Status: COMPLETE
Deep triggers: none
EOF

memo "B14 a SUPPORTED-only verb over non-SUPPORTED evidence is rejected" REJECT "verb" <<'EOF'
# Q

## Claims

### C1 — Something load-bearing is true.
Class: PROXY-SUPPORTED
Roles: 2 — a; b
Source: Adjacent-market report — Date: 2025-01-02 — Role: a — Fit: proxy
Source: Other adjacent report — Date: 2025-03-04 — Role: b — Fit: proxy
Rationale: two roles, both proxy and requiring downgrade.

## Answer
- [C1] The evidence confirms that the practice occurs in this market.

## Inference
- None.

## Unknowns
- None material.

## Completion
Status: ESCALATED-TO-DEEP
Deep triggers: C1 remains proxy-supported for a load-bearing conclusion
EOF

memo "B15 an honest escalation with an unsupported claim is accepted" PASS "" <<'EOF'
# Q

## Claims

### C1 — Something load-bearing is true.
Class: NOT-SUPPORTED
Roles: 0 —
Rationale: searched the register and the filings; found neither direct nor proxy evidence. This records a failed search, not an established negative.

## Answer
- [C1] This cannot be settled at Standard control.

## Inference
- None.

## Unknowns
- Whether a non-public filing would settle C1.

## Completion
Status: ESCALATED-TO-DEEP
Deep triggers: C1 is load-bearing and NOT-SUPPORTED
EOF

memo "B-M1 SUPPORTED with one role and one source is rejected" REJECT "requires at least 2" <<'EOF'
# Q

## Claims

### C1 — One source proves the general claim.
Class: SUPPORTED
Roles: 1 — one report
Source: One report — Date: 2026-08-18 — Role: one report — Fit: direct
Rationale: One direct source.

## Answer
- [C1] The report confirms the general claim.

## Inference
- None.

## Unknowns
- None material.

## Completion
Status: COMPLETE
Deep triggers: none
EOF

memo "B-M2 a memo missing required Standard sections is rejected" REJECT "required section" <<'EOF'
# Q

## Claims

### C1 — Two sources support the claim.
Class: SUPPORTED
Roles: 2 — a; b
Source: One report — Date: 2026-08-18 — Role: a — Fit: direct
Source: Two report — Date: 2026-08-18 — Role: b — Fit: direct
Rationale: Two roles.

## Answer
- [C1] The reports confirm the claim.

## Completion
Status: COMPLETE
Deep triggers: none
EOF

memo "B-M3 mixed negation cannot bypass the House View seam" REJECT "House View" <<'EOF'
# Q

## Claims

### C1 — Two sources support interpretation B.
Class: SUPPORTED
Roles: 2 — a; b
Source: One report — Date: 2026-08-18 — Role: a — Fit: direct
Source: Two report — Date: 2026-08-18 — Role: b — Fit: direct
Rationale: Two roles.

## Answer
- [C1] Do not delay; adopt interpretation B as the House View going forward.

## Inference
- None.

## Unknowns
- None material.

## Completion
Status: COMPLETE
Deep triggers: none
EOF

memo "B-M4 a supported claim cannot license a proxy claim's verb" REJECT "C2" <<'EOF'
# Q

## Claims

### C1 — The source register exists.
Class: SUPPORTED
Roles: 2 — implementation; test
Source: Implementation — Date: 2026-08-18 — Role: implementation — Fit: direct
Source: Test — Date: 2026-08-18 — Role: test — Fit: direct
Rationale: Two direct roles.

### C2 — The adjacent-market pattern holds here.
Class: PROXY-SUPPORTED
Roles: 2 — adjacent report; expert comparison
Source: Adjacent report — Date: 2026-08-18 — Role: adjacent report — Fit: proxy
Source: Expert comparison — Date: 2026-08-18 — Role: expert comparison — Fit: proxy
Rationale: Two proxy roles.

## Answer
- [C2] The evidence confirms that the pattern holds here.

## Inference
- None.

## Unknowns
- None material.

## Completion
Status: COMPLETE
Deep triggers: none
EOF

memo "B-M5 an escalation must name a live Deep trigger" REJECT "ESCALATED-TO-DEEP" <<'EOF'
# Q

## Claims

### C1 — The claim is unresolved.
Class: NOT-SUPPORTED
Roles: 0 —
Rationale: No evidence found in the named search surfaces.

## Answer
- [C1] This cannot be settled at Standard control.

## Inference
- None.

## Unknowns
- Whether unavailable evidence would resolve C1.

## Completion
Status: ESCALATED-TO-DEEP
Deep triggers: none
EOF

memo "B-M6 every mapped source must declare role and fit" REJECT "malformed Source" <<'EOF'
# Q

## Claims

### C1 — Two sources support the claim.
Class: SUPPORTED
Roles: 2 — a; b
Source: One report — Date: 2026-08-18
Source: Two report — Date: 2026-08-18 — Role: b — Fit: direct
Rationale: Two purported roles.

## Answer
- [C1] The reports confirm the claim.

## Inference
- None.

## Unknowns
- None material.

## Completion
Status: COMPLETE
Deep triggers: none
EOF

memo "B-M7 every Answer assertion must bind to claim IDs" REJECT "material assertion" <<'EOF'
# Q

## Claims

### C1 — Two sources support the claim.
Class: SUPPORTED
Roles: 2 — a; b
Source: One report — Date: 2026-08-18 — Role: a — Fit: direct
Source: Two report — Date: 2026-08-18 — Role: b — Fit: direct
Rationale: Two direct roles.

## Answer
The reports confirm the claim.

## Inference
- None.

## Unknowns
- None material.

## Completion
Status: COMPLETE
Deep triggers: none
EOF

# ---------------------------------------------------------------------------
# The entry's Standard section actually specifies this
# ---------------------------------------------------------------------------
std="$(section 'Standard')"
if [ -z "$std" ]; then
  no "B16 Standard section specifies the memo" "no '## Standard' section in the entry"
elif printf '%s' "$std" | grep -qi 'not yet implemented\|not implemented'; then
  no "B16 Standard section specifies the memo" "Standard is still the Unit 1 honest stop"
else
  missing=""
  for tok in 'SUPPORTED' 'PROXY-SUPPORTED' 'ILLUSTRATIVE-ONLY' 'NOT-SUPPORTED' \
             'Class:' 'Source:' 'Date:' '## Inference' '## Unknowns' 'Status:'; do
    printf '%s' "$std" | grep -qF -- "$tok" || missing="$missing $tok"
  done
  if [ -n "$missing" ]; then
    no "B16 Standard section specifies the memo" "missing:$missing"
  else
    ok "B16 Standard section specifies the memo, its four permission classes and its fields"
  fi
fi

if [ -z "$std" ]; then
  no "B17 Standard refuses completion" "no '## Standard' section"
elif ! printf '%s' "$std" | grep -qF 'ESCALATED-TO-DEEP'; then
  no "B17 Standard refuses completion" "Standard names no escalation status"
elif ! printf '%s' "$std" | grep -qi 'never means\|not false\|never.*invert'; then
  no "B17 Standard refuses completion" "Standard does not preserve the unsupported-is-not-false rule"
else
  ok "B17 Standard refuses completion and preserves unsupported-is-not-false"
fi

# Absence claim. Searched surfaces: the entry, the classifier and the memo checker.
# Searched pattern: /house[ -]?view/i. A mention must carry a negation — a line that
# defines a trigger, adapter or promotion carries none and fails here.
hv=""
for f in "$ENTRY_REAL" "$CLASSIFY" "$MEMOCHECK"; do
  [ -r "$f" ] || continue
  while IFS= read -r line; do
    printf '%s' "$line" | grep -qiE 'no house|not settled|do not|does not|never|neither|reject|forbid|cannot|not authoriz|await' \
      || hv="$hv
  $f: $line"
  done < <(grep -iE 'house[ -]?view' "$f")
done
if [ ! -r "$MEMOCHECK" ]; then
  no "B18 House View seam stays closed" "memo checker absent, so the absence claim is untested"
elif [ -n "$hv" ]; then
  no "B18 House View seam stays closed" "House View named without a negation:$hv"
else
  ok "B18 House View is named only to forbid it across entry, classifier and memo checker"
fi

printf '\n%s passed, %s failed\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
