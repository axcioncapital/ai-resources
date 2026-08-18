#!/usr/bin/env bash
# Acceptance harness — canonical-rw-lightweight-l3, Unit 1: shared entry Light vertical slice.
#
# What this proves, and how it can fail:
#
#   A1        the entry surface LOADS through a real non-RW project invocation path
#             (a fixture project whose .claude/commands/ symlink has the same shape the
#             SessionStart sweep produces), and carries a parseable route-decision block.
#   A2 – A8   BEHAVIOUR. The classifier resolves representative signal sets to routes,
#             reading its rules out of the real entry file through the fixture symlink.
#             These fail if the entry's decision table is wrong, missing or edited.
#   A9 – A13  STRUCTURE. The three dispatch sections carry the elements that make each
#             route real work rather than a printed label.
#
# A2–A8 are behavioural assertions over an executable surface. A9–A13 are structural
# conformance assertions over instruction prose — the entry is a Claude Code command, so
# no automated check can execute its Light note production. That split is stated rather
# than blurred: see the unit's Latest result.
#
# Run it BEFORE the entry exists (must fail) and AFTER (must pass). An assertion that
# cannot fail is not evidence (executable core § 6 rule 5).

REPO="$(git -C "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)" rev-parse --show-toplevel)" || {
  printf 'ERROR: not inside a git checkout\n' >&2; exit 1; }

ENTRY_REAL="$REPO/.claude/commands/research-route.md"
CLASSIFY="$REPO/logs/scripts/research-route-classify.sh"
DEEP_TARGET="$REPO/workflows/research-workflow/.claude/commands/run-preparation.md"

pass=0; fail=0
ok() { printf 'PASS  %s\n' "$1"; pass=$((pass + 1)); }
no() { printf 'FAIL  %s — %s\n' "$1" "$2"; fail=$((fail + 1)); }

# ---------------------------------------------------------------------------
# Fixture: a non-RW project that reaches the entry the way a deployed project
# does — a symlink in its own .claude/commands/ pointing at the shared file.
# ---------------------------------------------------------------------------
FIXTURE="$(mktemp -d)"
trap 'rm -rf "$FIXTURE"' EXIT
mkdir -p "$FIXTURE/.claude/commands" "$FIXTURE/output"
printf '# Fixture Project\n\nA non-research project that consumes shared commands.\n' \
  > "$FIXTURE/CLAUDE.md"
ln -s "$ENTRY_REAL" "$FIXTURE/.claude/commands/research-route.md" 2>/dev/null

ENTRY="$FIXTURE/.claude/commands/research-route.md"

# Extract one `## `-delimited section from the entry, by heading prefix.
# Fenced code blocks are skipped when looking for the next heading: the Light section
# embeds a note template whose own `## Answer` / `## Evidence` lines would otherwise
# terminate the section one line into it.
section() {
  awk -v want="$1" '
    /^```/ { fence = !fence }
    !fence && /^## / { inside = (index($0, "## " want) == 1) }
    inside { print }
  ' "$ENTRY" 2>/dev/null
}

# ---------------------------------------------------------------------------
# A1 — the surface loads through the fixture path
# ---------------------------------------------------------------------------
if [ ! -L "$FIXTURE/.claude/commands/research-route.md" ]; then
  no "A1 surface loads" "fixture symlink was not created (entry file absent)"
elif [ ! -r "$ENTRY" ]; then
  no "A1 surface loads" "symlink does not resolve to a readable file: $ENTRY_REAL"
elif ! head -1 "$ENTRY" | grep -q '^---$'; then
  no "A1 surface loads" "entry has no frontmatter block"
elif ! grep -q '<!-- route-rules:start -->' "$ENTRY" ||
     ! grep -q '<!-- route-rules:end -->' "$ENTRY"; then
  no "A1 surface loads" "entry carries no delimited route-rules block"
else
  ok "A1 surface loads through a non-RW fixture project symlink, with a route-rules block"
fi

# ---------------------------------------------------------------------------
# A2 – A8 — behaviour: signals resolve to routes, one way only
# ---------------------------------------------------------------------------
# route <label> <expected-route> <expected-overridden> <preference> <signal>...
route() {
  local label="$1" want_route="$2" want_over="$3" pref="$4"; shift 4
  local args=() s out got_route got_over
  for s in "$@"; do args+=(--signal "$s"); done

  if [ ! -r "$CLASSIFY" ]; then
    no "$label" "classifier absent: $CLASSIFY"; return
  fi
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

LIGHT_SIGNALS=(output=note consequence=internal scope=bounded
               load_bearing_claim=no thesis_judgment=no)

route "A2 a compact internal read-out classifies Light" \
  light no none "${LIGHT_SIGNALS[@]}"

route "A3 an internal analysis classifies Standard" \
  standard no none output=analysis consequence=internal scope=bounded \
  load_bearing_claim=no thesis_judgment=no

route "A4 a broad report classifies Deep" \
  deep no none output=report consequence=internal scope=broad \
  load_bearing_claim=no thesis_judgment=no

route "A5 an unclear signal defaults to Standard, never Light" \
  standard no none output=unclear consequence=internal scope=bounded \
  load_bearing_claim=no thesis_judgment=no

route "A6 a load-bearing claim escalates a requested Light to Standard" \
  standard yes light output=note consequence=internal scope=bounded \
  load_bearing_claim=yes thesis_judgment=no

route "A7 external consequence escalates a requested Light to Standard" \
  standard yes light output=note consequence=external scope=bounded \
  load_bearing_claim=no thesis_judgment=no

route "A8 thesis-grade judgment escalates a requested Light to Standard" \
  standard yes light output=note consequence=internal scope=bounded \
  load_bearing_claim=no thesis_judgment=yes

route "A9 a requested Light cannot lower a Deep floor" \
  deep yes light output=report consequence=internal scope=broad \
  load_bearing_claim=no thesis_judgment=no

route "A10 a preference may raise the route above the floor" \
  deep no deep "${LIGHT_SIGNALS[@]}"

# ---------------------------------------------------------------------------
# A11 — Light dispatches real work, not a label
# ---------------------------------------------------------------------------
light_sec="$(section 'Light')"
if [ -z "$light_sec" ]; then
  no "A11 Light dispatches real work" "no '## Light' section in the entry"
else
  missing=""
  for tok in '[EVIDENCE]' '[INFERENCE]' 'Source:' 'Date:' 'Gaps:'; do
    printf '%s' "$light_sec" | grep -qF -- "$tok" || missing="$missing $tok"
  done
  if [ -n "$missing" ]; then
    no "A11 Light dispatches real work" "Light section is missing required note elements:$missing"
  else
    ok "A11 Light section requires evidence/source/date, marked inference and explicit gaps"
  fi
fi

# ---------------------------------------------------------------------------
# A12 — Standard stops honestly at its next-unit seam
# ---------------------------------------------------------------------------
std_sec="$(section 'Standard')"
if [ -z "$std_sec" ]; then
  no "A12 Standard stops honestly" "no '## Standard' section in the entry"
elif ! printf '%s' "$std_sec" | grep -qi 'not.*implemented'; then
  no "A12 Standard stops honestly" "Standard section states no not-yet-implemented boundary"
elif ! printf '%s' "$std_sec" | grep -qi 'do not produce\|produce no\|does not produce'; then
  no "A12 Standard stops honestly" "Standard section does not forbid fabricated Standard output"
else
  ok "A12 Standard section stops at an explicit not-yet-implemented boundary"
fi

# ---------------------------------------------------------------------------
# A13 — Deep resolves to the deployed workflow entry, and that entry exists
# ---------------------------------------------------------------------------
deep_sec="$(section 'Deep')"
if [ -z "$deep_sec" ]; then
  no "A13 Deep resolves to the deployed workflow" "no '## Deep' section in the entry"
else
  missing=""
  for tok in '/run-preparation' 'task-plan-draft' 'SETUP.md'; do
    printf '%s' "$deep_sec" | grep -qF -- "$tok" || missing="$missing $tok"
  done
  if [ -n "$missing" ]; then
    no "A13 Deep resolves to the deployed workflow" "Deep section is missing:$missing"
  elif [ ! -r "$DEEP_TARGET" ]; then
    no "A13 Deep resolves to the deployed workflow" \
       "named handoff target does not exist: $DEEP_TARGET"
  else
    ok "A13 Deep section names /run-preparation, its prerequisite and SETUP.md, and the target exists"
  fi
fi

# ---------------------------------------------------------------------------
# A14 — no House View mechanism was introduced (absence claim)
#
# Searched surfaces: the entry file and the classifier — the only two new non-test
# surfaces this unit adds. Searched pattern: /house[ -]?view/i.
#
# The entry is ALLOWED to name House View in order to forbid it; forbidding it is
# part of the unit. What must be absent is a House View being DEFINED — a trigger,
# adapter, approval step or judgment contract. So every matching line must also
# carry a negation. A line like "Trigger the House View when the claim is
# load-bearing" carries none, and fails here.
# ---------------------------------------------------------------------------
if [ ! -r "$ENTRY_REAL" ]; then
  no "A14 no House View mechanism" "entry absent, so the absence claim is untested"
else
  hv_defining=""
  for f in "$ENTRY_REAL" "$CLASSIFY"; do
    [ -r "$f" ] || continue
    while IFS= read -r line; do
      printf '%s' "$line" | grep -qiE 'no house|not settled|do not|does not|never|neither' \
        || hv_defining="$hv_defining
  $f: $line"
    done < <(grep -iE 'house[ -]?view' "$f")
  done
  if [ -n "$hv_defining" ]; then
    no "A14 no House View mechanism" "House View named without a negation:$hv_defining"
  else
    ok "A14 House View is named only to forbid it; no trigger, adapter or judgment contract defined"
  fi
fi

printf '\n%s passed, %s failed\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
