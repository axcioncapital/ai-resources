#!/usr/bin/env bash
# Acceptance harness — canonical-rw-lightweight-l3-adapter, Unit 1:
# bind Standard to approved judgment authority.
#
# WHAT THIS PROVES, and how each part can fail:
#
#   D1 – D14  ADAPTER. `research-route-judgment-authority.sh` is the only path by which
#             Standard may reach governing judgment. It must return VALID authority ONLY
#             when L2's own `check-judgment-contract.sh` returns exit 0 over
#             `{base}-approved.md`, must hand back the approved CONTENT rather than a path,
#             and must fail closed — to a Deep escalation — on every other outcome:
#             missing helper, missing brief, proposed or rejected state, no claim IDs,
#             structural failure, unit mismatch and bad usage.
#   E1 – E13  MEMO CONTROL. The Standard checker's blanket rejection of the reserved term
#             is replaced by a binding, not removed. An unbound assertion of governing
#             authority is still rejected; a bound one must trace every consequential
#             assertion to the thesis it serves, and must not raise any claim's evidence
#             class.
#   F1 – F4   STRUCTURE. The entry's Standard section specifies the bound consumption and
#             its one-way escalation, and defines no second approval or promotion path.
#
# WHERE THE L2 VALIDATOR COMES FROM, and why that is not an import. This branch is
# deliberately isolated from L2 and does not carry its surfaces. The fixtures below
# materialise L2's accepted `check-judgment-contract.sh` from commit e16cf206 into a
# TEMPORARY fixture root at run time. Nothing is added to this branch's working tree or to
# any commit — the fixture root is deleted on exit. That is what makes D1–D6 evidence about
# the REAL contract rather than about a mock of it. Where the object is unreachable (a
# shallow clone), the harness says so and falls back to exit-code stubs, which prove the
# adapter branches on the contract's exit codes but not that it interoperates with the real
# validator. That degradation is reported, never silently absorbed.
#
# WHAT THIS CANNOT PROVE, stated rather than implied: no automated check executes a
# model-produced Standard memo, and nothing here exercises a genuine end-to-end run in a
# deployed research project against a real operator-approved brief. That integrated
# operating evidence is L4's, not this unit's.
#
# Run BEFORE the adapter exists (must fail) and AFTER (must pass).

REPO="$(git -C "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)" rev-parse --show-toplevel)" || {
  printf 'ERROR: not inside a git checkout\n' >&2; exit 1; }

ENTRY_REAL="$REPO/.claude/commands/research-route.md"
MEMOCHECK="$REPO/logs/scripts/research-route-memo-check.sh"
ADAPTER="$REPO/logs/scripts/research-route-judgment-authority.sh"

L2_COMMIT="e16cf206"
L2_CHECKER="workflows/research-workflow/logs/scripts/check-judgment-contract.sh"

pass=0; fail=0
ok() { printf 'PASS  %s\n' "$1"; pass=$((pass + 1)); }
no() { printf 'FAIL  %s — %s\n' "$1" "$2"; fail=$((fail + 1)); }

WORK="$(mktemp -d "${TMPDIR:-/tmp}/rr-adapter.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT

# ---------------------------------------------------------------------------
# Fixture roots
# ---------------------------------------------------------------------------
L2_REAL=1
if ! git -C "$REPO" cat-file -e "$L2_COMMIT:$L2_CHECKER" 2>/dev/null; then
  L2_REAL=0
  printf 'NOTE  L2 validator object %s:%s is unreachable — D1–D6 fall back to exit-code stubs\n' \
    "$L2_COMMIT" "$L2_CHECKER"
fi

# new_root <name> <checker-kind>
#   real            L2's accepted validator, materialised from history into the fixture
#   stub:<code>     a checker that always exits <code>
#   none            no checker at all
#   flagprobe       exits 0 only if it was handed --allow-proposed, otherwise 4
new_root() {
  local name="$1" kind="$2"
  # Assigned on its own line, not in the `local` above: bash creates every name in one
  # `local` statement before running its assignments, so `root="$WORK/$name"` there would
  # read an empty $name and collapse every fixture root onto $WORK.
  local root="$WORK/$name"
  mkdir -p "$root/logs/scripts" "$root/judgment"
  case "$kind" in
    real)
      if [ "$L2_REAL" -eq 1 ]; then
        git -C "$REPO" show "$L2_COMMIT:$L2_CHECKER" > "$root/logs/scripts/check-judgment-contract.sh" || return 1
      else
        printf '#!/usr/bin/env bash\nprintf "verdict: STUB\\n"\nexit 0\n' \
          > "$root/logs/scripts/check-judgment-contract.sh"
      fi
      ;;
    stub:*)
      printf '#!/usr/bin/env bash\nprintf "verdict: STUB\\n"\nexit %s\n' "${kind#stub:}" \
        > "$root/logs/scripts/check-judgment-contract.sh"
      ;;
    flagprobe)
      cat > "$root/logs/scripts/check-judgment-contract.sh" <<'PROBE'
#!/usr/bin/env bash
for a in "$@"; do [ "$a" = "--allow-proposed" ] && { printf 'verdict: STUB-PROPOSED\n'; exit 0; }; done
printf 'verdict: STUB-NOT-APPROVED\n'
exit 4
PROBE
      ;;
    none) ;;
    *) return 1 ;;
  esac
  [ "$kind" = "none" ] || chmod +x "$root/logs/scripts/check-judgment-contract.sh"
  printf '%s\n' "$root"
}

# write_brief <path> <status> <variant>
#   good        three evidence-cited theses, cited verdict, a countercase
#   noids       same shape, no claim IDs anywhere
#   malformed   no frontmatter block at all
write_brief() {
  local path="$1" status="$2" variant="${3:-good}" decided_by=""
  mkdir -p "$(dirname "$path")"
  case "$status" in
    approved) decided_by="approved_by: Patrik Lindeberg" ;;
    rejected) decided_by="rejected_by: Patrik Lindeberg" ;;
    *)        decided_by="" ;;
  esac

  if [ "$variant" = "malformed" ]; then
    printf '# Not a brief\n\nNo frontmatter, no theses.\n' > "$path"
    return
  fi

  {
    printf -- '---\n'
    printf 'unit: lane-comparison\n'
    printf 'artifact: unit-judgment-brief\n'
    printf 'status: %s\n' "$status"
    printf 'as_of: 2026-08-19\n'
    [ -z "$decided_by" ] || printf '%s\n' "$decided_by"
    printf -- '---\n\n'
    printf '## Theses\n\n'
    if [ "$variant" = "noids" ]; then
      printf '### Thesis 1 — The lightweight lane under-serves load-bearing claims.\n'
      printf 'The intake sample shows repeated under-service with no cited evidence basis.\n\n'
      printf '### Thesis 2 — Escalation is the cheaper failure than a wrong answer.\n'
      printf 'Rework cost dominates the cost of a route that escalated too readily.\n\n'
      printf '### Thesis 3 — The seam belongs at the memo, not at intake.\n'
      printf 'Countercase: intake-side gating would catch some cases earlier.\n\n'
    else
      printf '### Thesis 1 — The lightweight lane under-serves load-bearing claims.\n'
      printf 'The intake sample [Q1-C05] records repeated under-service of load-bearing asks.\n'
      printf 'Context: this matters because the lane now carries client-facing preparation.\n\n'
      printf '### Thesis 2 — Escalation is the cheaper failure than a wrong answer.\n'
      printf 'Rework cost [Q1-C06] exceeds the cost of a route that escalated too readily.\n\n'
      printf '### Thesis 3 — The seam belongs at the memo, not at intake.\n'
      printf 'Late-surfacing signals [Q2-A03] are invisible to an intake-time gate.\n'
      printf 'Countercase: intake-side gating would catch a minority of cases earlier.\n\n'
    fi
    printf '## Provisional verdict\n'
    if [ "$variant" = "noids" ]; then
      printf 'The lane should bind to approved judgment before it may assert a governing view.\n\n'
    else
      printf 'On [Q1-C05] and [Q2-A03], the lane must bind to approved judgment before it may\n'
      printf 'assert a governing view. THESIS-CONTENT-MARKER-7F3A carries this sentence.\n\n'
    fi
    printf '## What would change the view\n'
    printf 'A quarter in which no escalated memo is reworked would move the view downward.\n'
  } > "$path"
}

tree_sig() {
  { find "$1" | LC_ALL=C sort; find "$1" -type f -exec shasum {} \; | LC_ALL=C sort; } 2>/dev/null
}

# adapter <label> <want-exit> <want-substring...>  — remaining args are --root/--unit/--base etc.
ADAPTER_OUT=""
run_adapter() {
  ADAPTER_OUT="$(bash "$ADAPTER" "$@" 2>&1)"
  return $?
}

expect_adapter() {
  local label="$1" want_rc="$2" want_sub="$3"; shift 3
  local rc
  if [ ! -r "$ADAPTER" ]; then no "$label" "adapter absent: $ADAPTER"; return; fi
  run_adapter "$@"
  rc=$?
  if [ "$rc" -ne "$want_rc" ]; then
    no "$label" "exit=$rc, expected $want_rc ($(printf '%s' "$ADAPTER_OUT" | tr '\n' ';'))"
  elif [ -n "$want_sub" ] && ! printf '%s' "$ADAPTER_OUT" | grep -qF -- "$want_sub"; then
    no "$label" "output did not contain '$want_sub': $(printf '%s' "$ADAPTER_OUT" | tr '\n' ';')"
  else
    ok "$label"
  fi
}

# ---------------------------------------------------------------------------
# D1 – D14 — the adapter
# ---------------------------------------------------------------------------
BASE_REL="judgment/lane-comparison-unit-judgment-brief"

r_valid="$(new_root valid real)"
write_brief "$r_valid/$BASE_REL-approved.md" approved good

expect_adapter "D1 a contract-valid approved brief yields VALID authority" 0 "authority: VALID" \
  --root "$r_valid" --unit lane-comparison --base "$BASE_REL"

if [ -r "$ADAPTER" ]; then
  run_adapter --root "$r_valid" --unit lane-comparison --base "$BASE_REL"
  if printf '%s' "$ADAPTER_OUT" | grep -qF 'THESIS-CONTENT-MARKER-7F3A'; then
    ok "D2 valid authority hands back the approved CONTENT, not merely its path"
  else
    no "D2 valid authority hands back the approved CONTENT, not merely its path" \
      "the approved brief's own text is absent from the adapter's output"
  fi
  if printf '%s' "$ADAPTER_OUT" | grep -qE '^theses: 3$' &&
     printf '%s' "$ADAPTER_OUT" | grep -qE '^thesis: T2 '; then
    ok "D3 valid authority enumerates the theses a consumer must trace to"
  else
    no "D3 valid authority enumerates the theses a consumer must trace to" \
      "no 'theses: 3' / 'thesis: T2' enumeration: $(printf '%s' "$ADAPTER_OUT" | tr '\n' ';')"
  fi
else
  no "D2 valid authority hands back the approved CONTENT, not merely its path" "adapter absent"
  no "D3 valid authority enumerates the theses a consumer must trace to" "adapter absent"
fi

r_missing="$(new_root missingbrief real)"
write_brief "$r_missing/$BASE_REL-proposed.md" proposed good
expect_adapter "D4 a proposal on disk with no approved form fails closed" 1 "contract-exit: 3" \
  --root "$r_missing" --unit lane-comparison --base "$BASE_REL"
expect_adapter "D5 an unavailable approved form escalates one way to Deep" 1 "escalate: deep" \
  --root "$r_missing" --unit lane-comparison --base "$BASE_REL"

r_prop="$(new_root proposedstate real)"
write_brief "$r_prop/$BASE_REL-approved.md" proposed good
expect_adapter "D6 a proposed brief occupying the approved path is not authority" 1 "contract-exit: 4" \
  --root "$r_prop" --unit lane-comparison --base "$BASE_REL"

r_rej="$(new_root rejectedstate real)"
write_brief "$r_rej/$BASE_REL-approved.md" rejected good
expect_adapter "D7 a rejected brief never becomes authority" 1 "contract-exit: 4" \
  --root "$r_rej" --unit lane-comparison --base "$BASE_REL"

r_noids="$(new_root noclaimids real)"
write_brief "$r_noids/$BASE_REL-approved.md" approved noids
expect_adapter "D8 an approved brief citing no claim IDs fails closed" 1 "contract-exit: 5" \
  --root "$r_noids" --unit lane-comparison --base "$BASE_REL"

r_mal="$(new_root malformed real)"
write_brief "$r_mal/$BASE_REL-approved.md" approved malformed
expect_adapter "D9 a malformed approved brief fails closed" 1 "contract-exit: 6" \
  --root "$r_mal" --unit lane-comparison --base "$BASE_REL"

r_nohelper="$(new_root nohelper none)"
write_brief "$r_nohelper/$BASE_REL-approved.md" approved good
expect_adapter "D10 a missing L2 contract checker fails closed, never open" 1 "contract-exit: none" \
  --root "$r_nohelper" --unit lane-comparison --base "$BASE_REL"

expect_adapter "D11 bad usage fails closed rather than defaulting to authority" 2 "authority: UNAVAILABLE" \
  --root "$r_valid" --base "$BASE_REL"

expect_adapter "D12 a base pointing at a proposal is refused as bad usage" 2 "authority: UNAVAILABLE" \
  --root "$r_valid" --unit lane-comparison --base "$BASE_REL-proposed.md"

expect_adapter "D13 a base pointing at the approved file itself is refused" 2 "authority: UNAVAILABLE" \
  --root "$r_valid" --unit lane-comparison --base "$BASE_REL-approved.md"

expect_adapter "D14 an approved brief for another unit is not this unit's authority" 1 "authority: UNAVAILABLE" \
  --root "$r_valid" --unit some-other-unit --base "$BASE_REL"

r_probe="$(new_root flagprobe flagprobe)"
write_brief "$r_probe/$BASE_REL-approved.md" approved good
expect_adapter "D15 the adapter never asks the contract to accept a proposal" 1 "contract-exit: 4" \
  --root "$r_probe" --unit lane-comparison --base "$BASE_REL"

if [ -r "$ADAPTER" ]; then
  before_valid="$(tree_sig "$r_valid")"
  run_adapter --root "$r_valid" --unit lane-comparison --base "$BASE_REL"
  before_fail="$(tree_sig "$r_missing")"
  run_adapter --root "$r_missing" --unit lane-comparison --base "$BASE_REL"
  if [ "$(tree_sig "$r_valid")" = "$before_valid" ] && [ "$(tree_sig "$r_missing")" = "$before_fail" ]; then
    ok "D16 the adapter writes, approves and promotes nothing on either outcome"
  else
    no "D16 the adapter writes, approves and promotes nothing on either outcome" \
      "the fixture tree changed across an adapter run"
  fi
  if grep -qF 'promote-judgment-brief' "$ADAPTER"; then
    no "D17 the adapter opens no promotion path" "the adapter references the promotion helper"
  else
    ok "D17 the adapter opens no promotion path"
  fi
else
  no "D16 the adapter writes, approves and promotes nothing on either outcome" "adapter absent"
  no "D17 the adapter opens no promotion path" "adapter absent"
fi

# ---------------------------------------------------------------------------
# E1 – E13 — memo control
# ---------------------------------------------------------------------------
# memo <label> <PASS|REJECT> <reason-substring-or-empty> <authority-root-or-empty> <<< body
memo() {
  local label="$1" want="$2" want_reason="$3" root="$4"
  local f="$WORK/memo-$((pass + fail)).md" out verdict rc want_rc
  cat > "$f"
  if [ ! -r "$MEMOCHECK" ]; then no "$label" "memo checker absent: $MEMOCHECK"; return; fi
  if [ -n "$root" ]; then
    out="$(bash "$MEMOCHECK" --memo "$f" --authority-root "$root" 2>&1)"
  else
    out="$(bash "$MEMOCHECK" --memo "$f" 2>&1)"
  fi
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

memo "E1 an ordinary Standard memo is unchanged by the adapter" PASS "" "$r_valid" <<'EOF'
# Does the sweep reach this lane?

## Claims

### C1 — The sweep resolves its source by ancestor-walking for a directory named ai-resources.
Class: SUPPORTED
Roles: 2 — hook source; deployed project state
Source: .claude/hooks/auto-sync-shared.sh lines 46-52 — Date: 2026-08-18 — Role: hook source — Fit: direct
Source: projects/ai-development-lab/.claude/commands/ — Date: undated — Role: deployed project state — Fit: direct
Rationale: Two independent roles, both direct and in scope. No ceiling applies.

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

memo "E2 an unbound assertion of governing authority is still rejected" REJECT "House View" "$r_valid" <<'EOF'
# Q

## Claims

### C1 — Two sources support interpretation B.
Class: SUPPORTED
Roles: 2 — a; b
Source: One report — Date: 2026-08-18 — Role: a — Fit: direct
Source: Two report — Date: 2026-08-18 — Role: b — Fit: direct
Rationale: Two direct roles.

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

memo "E3 a contract-valid, thesis-traced House View assertion is accepted" PASS "" "$r_valid" <<'EOF'
# Which lane should carry load-bearing preparation?

## Judgment authority
Unit: lane-comparison
Approved brief: judgment/lane-comparison-unit-judgment-brief-approved.md

## Claims

### C1 — The intake sample records repeated under-service of load-bearing asks.
Class: SUPPORTED
Roles: 2 — intake sample; rework log
Source: Intake sample — Date: 2026-08-18 — Role: intake sample — Fit: direct
Source: Rework log — Date: 2026-08-18 — Role: rework log — Fit: direct
Rationale: Two direct roles, both in scope.

## Answer
- [C1,T1] The record establishes that load-bearing asks are under-served on the light lane.
- [C1,T3] The House View places the control seam at the memo rather than at intake.

## Inference
- [INFERENCE] A later intake-side gate would therefore be redundant (rests on C1).

## Unknowns
- Whether a quarter without reworked escalations would move the view.

## Completion
Status: COMPLETE
Deep triggers: none
EOF

memo "E4 a bound memo must trace every consequential assertion to a thesis" REJECT "thesis" "$r_valid" <<'EOF'
# Which lane should carry load-bearing preparation?

## Judgment authority
Unit: lane-comparison
Approved brief: judgment/lane-comparison-unit-judgment-brief-approved.md

## Claims

### C1 — The intake sample records repeated under-service of load-bearing asks.
Class: SUPPORTED
Roles: 2 — intake sample; rework log
Source: Intake sample — Date: 2026-08-18 — Role: intake sample — Fit: direct
Source: Rework log — Date: 2026-08-18 — Role: rework log — Fit: direct
Rationale: Two direct roles.

## Answer
- [C1] The House View is that the seam belongs at the memo.

## Inference
- None.

## Unknowns
- None material.

## Completion
Status: COMPLETE
Deep triggers: none
EOF

memo "E5 a memo cannot cite a thesis the approved brief does not carry" REJECT "T9" "$r_valid" <<'EOF'
# Which lane should carry load-bearing preparation?

## Judgment authority
Unit: lane-comparison
Approved brief: judgment/lane-comparison-unit-judgment-brief-approved.md

## Claims

### C1 — The intake sample records repeated under-service of load-bearing asks.
Class: SUPPORTED
Roles: 2 — intake sample; rework log
Source: Intake sample — Date: 2026-08-18 — Role: intake sample — Fit: direct
Source: Rework log — Date: 2026-08-18 — Role: rework log — Fit: direct
Rationale: Two direct roles.

## Answer
- [C1,T9] The House View is that the seam belongs at the memo.

## Inference
- None.

## Unknowns
- None material.

## Completion
Status: COMPLETE
Deep triggers: none
EOF

memo "E6 authority may not be bound to a proposal" REJECT "-approved.md" "$r_valid" <<'EOF'
# Which lane should carry load-bearing preparation?

## Judgment authority
Unit: lane-comparison
Approved brief: judgment/lane-comparison-unit-judgment-brief-proposed.md

## Claims

### C1 — The intake sample records repeated under-service of load-bearing asks.
Class: SUPPORTED
Roles: 2 — intake sample; rework log
Source: Intake sample — Date: 2026-08-18 — Role: intake sample — Fit: direct
Source: Rework log — Date: 2026-08-18 — Role: rework log — Fit: direct
Rationale: Two direct roles.

## Answer
- [C1,T1] The House View is that the seam belongs at the memo.

## Inference
- None.

## Unknowns
- None material.

## Completion
Status: COMPLETE
Deep triggers: none
EOF

memo "E7 a bound memo whose authority is not contract-valid is rejected" REJECT "contract-exit: 4" "$r_prop" <<'EOF'
# Which lane should carry load-bearing preparation?

## Judgment authority
Unit: lane-comparison
Approved brief: judgment/lane-comparison-unit-judgment-brief-approved.md

## Claims

### C1 — The intake sample records repeated under-service of load-bearing asks.
Class: SUPPORTED
Roles: 2 — intake sample; rework log
Source: Intake sample — Date: 2026-08-18 — Role: intake sample — Fit: direct
Source: Rework log — Date: 2026-08-18 — Role: rework log — Fit: direct
Rationale: Two direct roles.

## Answer
- [C1,T1] The House View is that the seam belongs at the memo.

## Inference
- None.

## Unknowns
- None material.

## Completion
Status: COMPLETE
Deep triggers: none
EOF

memo "E8 a thesis reference without bound authority is rejected" REJECT "T1" "$r_valid" <<'EOF'
# Q

## Claims

### C1 — Two sources support interpretation B.
Class: SUPPORTED
Roles: 2 — a; b
Source: One report — Date: 2026-08-18 — Role: a — Fit: direct
Source: Two report — Date: 2026-08-18 — Role: b — Fit: direct
Rationale: Two direct roles.

## Answer
- [C1,T1] The seam belongs at the memo.

## Inference
- None.

## Unknowns
- None material.

## Completion
Status: COMPLETE
Deep triggers: none
EOF

memo "E9 authority alone never licenses a factual assertion" REJECT "evidence" "$r_valid" <<'EOF'
# Which lane should carry load-bearing preparation?

## Judgment authority
Unit: lane-comparison
Approved brief: judgment/lane-comparison-unit-judgment-brief-approved.md

## Claims

### C1 — The intake sample records repeated under-service of load-bearing asks.
Class: SUPPORTED
Roles: 2 — intake sample; rework log
Source: Intake sample — Date: 2026-08-18 — Role: intake sample — Fit: direct
Source: Rework log — Date: 2026-08-18 — Role: rework log — Fit: direct
Rationale: Two direct roles.

## Answer
- [C1,T1] The record supports the under-service finding.
- [T2] Escalation is the cheaper failure in this market.

## Inference
- None.

## Unknowns
- None material.

## Completion
Status: COMPLETE
Deep triggers: none
EOF

memo "E10 authority does not raise a claim's evidence class" REJECT "verb" "$r_valid" <<'EOF'
# Which lane should carry load-bearing preparation?

## Judgment authority
Unit: lane-comparison
Approved brief: judgment/lane-comparison-unit-judgment-brief-approved.md

## Claims

### C1 — The adjacent-market pattern holds here.
Class: PROXY-SUPPORTED
Roles: 2 — adjacent report; expert comparison
Source: Adjacent report — Date: 2026-08-18 — Role: adjacent report — Fit: proxy
Source: Expert comparison — Date: 2026-08-18 — Role: expert comparison — Fit: proxy
Rationale: Two proxy roles.

## Answer
- [C1,T1] The evidence confirms that the pattern holds here, per the House View.

## Inference
- None.

## Unknowns
- None material.

## Completion
Status: COMPLETE
Deep triggers: none
EOF

memo "E11 a bound memo cannot complete over a live Deep trigger" REJECT "Deep trigger" "$r_valid" <<'EOF'
# Which lane should carry load-bearing preparation?

## Judgment authority
Unit: lane-comparison
Approved brief: judgment/lane-comparison-unit-judgment-brief-approved.md

## Claims

### C1 — The intake sample records repeated under-service of load-bearing asks.
Class: SUPPORTED
Roles: 2 — intake sample; rework log
Source: Intake sample — Date: 2026-08-18 — Role: intake sample — Fit: direct
Source: Rework log — Date: 2026-08-18 — Role: rework log — Fit: direct
Rationale: Two direct roles.

## Answer
- [C1,T1] The House View places the seam at the memo.

## Inference
- None.

## Unknowns
- None material.

## Completion
Status: COMPLETE
Deep triggers: the selection now leaves the firm
EOF

memo "E12 a bound memo with an unavailable contract checker fails closed" REJECT "contract-exit: none" "$r_nohelper" <<'EOF'
# Which lane should carry load-bearing preparation?

## Judgment authority
Unit: lane-comparison
Approved brief: judgment/lane-comparison-unit-judgment-brief-approved.md

## Claims

### C1 — The intake sample records repeated under-service of load-bearing asks.
Class: SUPPORTED
Roles: 2 — intake sample; rework log
Source: Intake sample — Date: 2026-08-18 — Role: intake sample — Fit: direct
Source: Rework log — Date: 2026-08-18 — Role: rework log — Fit: direct
Rationale: Two direct roles.

## Answer
- [C1,T1] The House View places the seam at the memo.

## Inference
- None.

## Unknowns
- None material.

## Completion
Status: COMPLETE
Deep triggers: none
EOF

memo "E13 an honest authority-failure escalation is accepted without the reserved term" PASS "" "$r_missing" <<'EOF'
# Which lane should carry load-bearing preparation?

## Claims

### C1 — The intake sample records repeated under-service of load-bearing asks.
Class: SUPPORTED
Roles: 2 — intake sample; rework log
Source: Intake sample — Date: 2026-08-18 — Role: intake sample — Fit: direct
Source: Rework log — Date: 2026-08-18 — Role: rework log — Fit: direct
Rationale: Two direct roles.

## Answer
- [C1] The record shows load-bearing asks are under-served on the light lane.

## Inference
- None.

## Unknowns
- Which governing thesis the firm would authorize here.

## Completion
Status: ESCALATED-TO-DEEP
Deep triggers: an authorized thesis is required and no contract-valid approved judgment is available (contract-exit 3)
EOF

memo "E14 an authority block outside the closed line schema is rejected" REJECT "Judgment authority" "$r_valid" <<'EOF'
# Which lane should carry load-bearing preparation?

## Judgment authority
Unit: lane-comparison
Approved brief: judgment/lane-comparison-unit-judgment-brief-approved.md
Verified: yes, I checked it myself.

## Claims

### C1 — The intake sample records repeated under-service of load-bearing asks.
Class: SUPPORTED
Roles: 2 — intake sample; rework log
Source: Intake sample — Date: 2026-08-18 — Role: intake sample — Fit: direct
Source: Rework log — Date: 2026-08-18 — Role: rework log — Fit: direct
Rationale: Two direct roles.

## Answer
- [C1,T1] The House View places the seam at the memo.

## Inference
- None.

## Unknowns
- None material.

## Completion
Status: COMPLETE
Deep triggers: none
EOF

# ---------------------------------------------------------------------------
# F1 – F4 — the entry actually specifies the bound consumption
# ---------------------------------------------------------------------------
section() {
  awk -v want="$1" '
    /^```/ { fence = !fence }
    !fence && /^## / { inside = (index($0, "## " want) == 1) }
    inside { print }
  ' "$ENTRY_REAL" 2>/dev/null
}

std="$(section 'Standard')"
if [ -z "$std" ]; then
  no "F1 Standard specifies the bound consumption" "no '## Standard' section in the entry"
else
  missing=""
  for tok in 'research-route-judgment-authority.sh' 'check-judgment-contract.sh' \
             '## Judgment authority' '-approved.md' 'judgment-authority-contract.md'; do
    printf '%s' "$std" | grep -qF -- "$tok" || missing="$missing $tok"
  done
  if [ -n "$missing" ]; then
    no "F1 Standard specifies the bound consumption" "Standard section is missing:$missing"
  else
    ok "F1 Standard names the adapter, L2's validator, the memo block and the published contract"
  fi
fi

if [ -z "$std" ]; then
  no "F2 Standard fails closed to Deep on an authority failure" "no '## Standard' section"
elif printf '%s' "$std" | grep -qF 'ESCALATED-TO-DEEP' &&
     printf '%s' "$std" | grep -qiE 'exit 0|exit code' &&
     printf '%s' "$std" | grep -qiE 'do not (create|author|approve|invent)|never (create|author|approve|invent)'; then
  ok "F2 Standard fails closed to Deep and forbids creating authority itself"
else
  no "F2 Standard fails closed to Deep on an authority failure" \
    "the Standard section does not both branch on the contract exit code and forbid authoring authority"
fi

# Absence claim, replacing the pre-L2 blanket one. Searched surfaces: the entry, the memo
# checker and the adapter. Searched pattern: /house[ -]?view/i. Every match must be either a
# negation or a line bound to the published contract; a line that DEFINES a second approval,
# promotion or judgment artifact carries neither and fails here.
unbound=""
for f in "$ENTRY_REAL" "$MEMOCHECK" "$ADAPTER"; do
  [ -r "$f" ] || continue
  while IFS= read -r line; do
    printf '%s' "$line" | grep -qiE 'no house|not settled|do not|does not|never|neither|reject|forbid|cannot|not authoriz|await' && continue
    printf '%s' "$line" | grep -qiE 'check-judgment-contract|judgment-authority-contract|-approved\.md|judgment authority|contract-valid|approved judgment' && continue
    unbound="$unbound
  $f: $line"
  done < <(grep -iE 'house[ -]?view' "$f")
done
if [ ! -r "$ADAPTER" ] || [ ! -r "$MEMOCHECK" ]; then
  no "F3 House View is only ever negated or contract-bound" "adapter or memo checker absent, so the absence claim is untested"
elif [ -n "$unbound" ]; then
  no "F3 House View is only ever negated or contract-bound" "House View named unbound:$unbound"
else
  ok "F3 House View is named only to forbid it or to bind it to the published contract"
fi

promo=""
for f in "$ENTRY_REAL" "$MEMOCHECK" "$ADAPTER"; do
  [ -r "$f" ] || continue
  grep -qE 'promote-judgment-brief|check-judgment-challenge' "$f" && promo="$promo $f"
done
if [ ! -r "$ADAPTER" ]; then
  no "F4 no second approval or promotion path is opened" "adapter absent, so the absence claim is untested"
elif [ -n "$promo" ]; then
  no "F4 no second approval or promotion path is opened" "promotion or challenge helper referenced in:$promo"
else
  ok "F4 the L3 surfaces open no second approval, challenge or promotion path"
fi

printf '\n%s passed, %s failed\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
