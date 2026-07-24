#!/usr/bin/env bash
# Regression suite for logs/scripts/check-append-order.sh.
#
# Ties directly to the recorded thread-4 failure (mission repo-integrity-repairs-2026-07):
# commit c3d5fe7 PREPENDED a new dated entry to the TOP of decisions.md and shipped it in a
# mid-session commit. A wrap-time check runs too late; this guard runs at the commit boundary.
#
# The suite tests the SHIPPED script (not a copy) against a throwaway git repo in $TMPDIR,
# staging fixtures and reading git's staged state exactly as the pre-commit hook does.
#
# Cases (the last three are the ones a naive "is the newest date at the tail?" check misses):
#   (a) clean append at the end            -> exit 0
#   (b) cross-day prepend at the top        -> exit 1
#   (c) same-date prepend (== newest)       -> exit 1   [max-at-tail check cannot catch this]
#   (d) two added, the EARLIER one misplaced-> exit 1   [checking only the last header misses it]
#   (e) in-place body edit, no new header   -> exit 0   [must not false-positive]
#
# Run: bash logs/scripts/check-append-order.test.sh

set -u
SCRATCH="$(mktemp -d "${TMPDIR:-/tmp}/check-append-order-test.XXXXXX")"
trap 'rm -rf "$SCRATCH"' EXIT

AIR="$(cd "$(dirname "$0")/../.." && pwd)"
SCRIPT="$AIR/logs/scripts/check-append-order.sh"
HDR='^## [0-9]{4}-[0-9]{2}-[0-9]{2}'

fail() { echo ">>> FAIL: $1"; exit 1; }
[ -x "$SCRIPT" ] || fail "shipped script not found/executable: $SCRIPT"

cd "$SCRATCH" || exit 1
git init -q .
git config user.email t@t.t
git config user.name t
mkdir -p logs

# Baseline committed state — two entries, newest-last. Newest retained date = 2026-07-20.
cat > logs/decisions.md <<'EOF'
# Decisions

## 2026-07-10 — Old A
first body line

## 2026-07-20 — Old B
second body line
EOF
git add logs/decisions.md
git commit -q -m base --no-verify

# run_check: stage the current working file, run the SHIPPED guard, return its exit code.
run_check() { git add logs/decisions.md; bash "$SCRIPT" logs/decisions.md "$HDR"; }
reset_fixture() { git checkout -q HEAD -- logs/decisions.md; }

# --- (a) clean append at the end -> exit 0 ---
cat >> logs/decisions.md <<'EOF'

## 2026-07-25 — Third (appended at end)
body
EOF
if run_check >/dev/null 2>&1; then echo ">>> pass (a): clean append -> exit 0"; else fail "(a) clean append was BLOCKED (should pass)"; fi
reset_fixture

# --- (b) cross-day prepend at the top -> exit 1 ---
python3 - <<'PY'
p='logs/decisions.md'; s=open(p).read()
new="## 2026-07-25 — Prepended newest\nbody\n\n"
open(p,'w').write(s.replace("# Decisions\n\n","# Decisions\n\n"+new,1))
PY
if run_check >/dev/null 2>&1; then fail "(b) cross-day prepend was ALLOWED (should block)"; else echo ">>> pass (b): cross-day prepend -> exit 1"; fi
reset_fixture

# --- (c) same-date prepend (equal to the newest retained date) -> exit 1 ---
# A bare "newest date is at the tail" check PASSES here (2026-07-20 is still at the tail),
# so this case proves the guard uses position, not just the max date.
python3 - <<'PY'
p='logs/decisions.md'; s=open(p).read()
new="## 2026-07-20 — Prepended same-day\nbody\n\n"
open(p,'w').write(s.replace("# Decisions\n\n","# Decisions\n\n"+new,1))
PY
if run_check >/dev/null 2>&1; then fail "(c) same-date prepend was ALLOWED (should block)"; else echo ">>> pass (c): same-date prepend -> exit 1"; fi
reset_fixture

# --- (d) two entries added, the EARLIER one prepended, the last correctly appended -> exit 1 ---
# Checking only the final header would pass; the guard must flag the misplaced earlier one.
python3 - <<'PY'
p='logs/decisions.md'; s=open(p).read()
s=s.replace("# Decisions\n\n","# Decisions\n\n## 2026-07-25 — Prepended (earlier add)\nbody\n\n",1)
s=s+"\n## 2026-07-26 — Appended (later add)\nbody\n"
open(p,'w').write(s)
PY
out_d="$(run_check 2>&1)"; rc_d=$?
[ "$rc_d" -eq 0 ] && fail "(d) earlier-misplaced add was ALLOWED (should block)"
echo "$out_d" | grep -q "Prepended (earlier add)" || fail "(d) blocked but did not name the misplaced earlier entry"
echo ">>> pass (d): earlier-of-two misplaced -> exit 1, named"
reset_fixture

# --- (e) in-place BODY edit of an old entry, no new dated header -> exit 0 ---
python3 - <<'PY'
p='logs/decisions.md'; s=open(p).read()
open(p,'w').write(s.replace("first body line","first body line (edited)"))
PY
if run_check >/dev/null 2>&1; then echo ">>> pass (e): in-place body edit -> exit 0"; else fail "(e) body edit was BLOCKED (false positive)"; fi
reset_fixture

echo ""
echo "ALL CASES PASS (a: append ok · b: cross-day prepend blocked · c: same-day prepend blocked · d: earlier-misplaced blocked · e: body edit ok)"
exit 0
