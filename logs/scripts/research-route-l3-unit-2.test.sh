#!/usr/bin/env bash
# Acceptance harness — canonical-rw-lightweight-l3, Unit 2: Standard evidence-controlled slice.
#
#   B1 – B6   ROUTING. The real entry and classifier, exercised for a bounded Standard
#             analysis and for every safety-driven escalation this unit adds or preserves.
#             B5/B6 cover the new consequential-thesis floor; B3/B4 prove a stated Light
#             preference cannot lower the floor.
#   B7 – B14  MEMO CONTROL. The Standard memo checker must REJECT each way a memo can
#             launder an unsupported claim, and ACCEPT one minimal valid memo. A checker
#             that only accepted would prove nothing, so every rejection is asserted by
#             its own fixture and by the reason it must give.
#   B15 – B17 STRUCTURE. The entry's Standard section actually specifies the memo, the
#             completion refusal and the closed House View seam.
#
# What this CANNOT prove is stated rather than implied: no automated check executes a
# model-produced Standard memo or judges its analytical quality. B7–B14 prove the checker
# rejects malformed memos; they say nothing about whether a real memo is any good. That
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

WORK="${TMPDIR:-/tmp}/rr-unit2-$$"
mkdir -p "$WORK"
trap 'rm -rf "$WORK"' EXIT

# Fixture project: the entry is reached the way a deployed project reaches it.
mkdir -p "$WORK/proj/.claude/commands"
ln -s "$ENTRY_REAL" "$WORK/proj/.claude/commands/research-route.md" 2>/dev/null
ENTRY="$WORK/proj/.claude/commands/research-route.md"

section() {
  awk -v want="$1" '
    /^```/ { fence = !fence }
    !fence && /^## / { inside = (index($0, "## " want) == 1) }
    inside { print }
  ' "$ENTRY" 2>/dev/null
}

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

# ---------------------------------------------------------------------------
# B7 – B14 — memo control
# ---------------------------------------------------------------------------
# memo <label> <expect PASS|REJECT> <reason-substring-or-empty> <<< body on stdin
memo() {
  local label="$1" want="$2" want_reason="$3"
  local f="$WORK/memo-$((pass + fail)).md" out verdict
  cat > "$f"
  if [ ! -r "$MEMOCHECK" ]; then no "$label" "memo checker absent: $MEMOCHECK"; return; fi
  out="$(bash "$MEMOCHECK" --memo "$f" 2>&1)"
  verdict="$(printf '%s\n' "$out" | sed -n 's/^verdict: //p')"
  if [ "$verdict" != "$want" ]; then
    no "$label" "verdict=$verdict, expected $want ($(printf '%s' "$out" | tr '\n' ';'))"
  elif [ -n "$want_reason" ] && ! printf '%s' "$out" | grep -qF -- "$want_reason"; then
    no "$label" "verdict correct but reason did not name '$want_reason': $(printf '%s' "$out" | tr '\n' ';')"
  else
    ok "$label"
  fi
}

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
The sweep resolves to the canonical directory, so this lane is not a sync source.

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
It is true.

## Inference
- [INFERENCE] none.

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
It is true.

## Inference
- [INFERENCE] none.

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
It is true.

## Inference
- [INFERENCE] none.

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
It is true.

## Inference
- [INFERENCE] none.

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
It is probably true anyway.

## Inference
- [INFERENCE] none.

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
Adopt interpretation B as the House View going forward.

## Inference
- [INFERENCE] none.

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
The evidence confirms that the practice occurs in this market.

## Inference
- [INFERENCE] none.

## Unknowns
- None material.

## Completion
Status: ESCALATED-TO-DEEP
Deep triggers: none
EOF

memo "B15 an honest escalation with an unsupported claim is accepted" PASS "" <<'EOF'
# Q

## Claims

### C1 — Something load-bearing is true.
Class: NOT-SUPPORTED
Roles: 0 —
Rationale: searched the register and the filings; found neither direct nor proxy evidence. This records a failed search, not an established negative.

## Answer
This cannot be settled at Standard control.

## Inference
- [INFERENCE] none.

## Unknowns
- Whether a non-public filing would settle C1.

## Completion
Status: ESCALATED-TO-DEEP
Deep triggers: C1 is load-bearing and NOT-SUPPORTED
EOF

# ---------------------------------------------------------------------------
# B16 – B18 — the entry's Standard section actually specifies this
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
