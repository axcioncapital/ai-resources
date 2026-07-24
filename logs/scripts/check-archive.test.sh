#!/usr/bin/env bash
# Regression suite for logs/scripts/check-archive.sh.
#
# Ties to the recorded wrong-repo defect (mission repo-integrity-repairs-2026-07, thread 1):
# the script resolved its ARCHIVE TARGET from $0 (its own location), so a copy loaded from
# ai-resources archived ai-resources' logs instead of the caller's project. The fix makes the
# target the CALLER's CLAUDE_PROJECT_DIR and refuses (exit 1) when none is passed.
#
# The suite invokes the SHIPPED script (not a copy) but points CLAUDE_PROJECT_DIR at a
# throwaway project in $TMPDIR, and asserts the real ai-resources logs are NEVER touched.
# This is the falsification test: the pre-fix script would archive ai-resources here.
#
# Run: bash logs/scripts/check-archive.test.sh

set -u
SCRATCH="$(mktemp -d "${TMPDIR:-/tmp}/check-archive-test.XXXXXX")"
trap 'rm -rf "$SCRATCH"' EXIT

AIR="$(cd "$(dirname "$0")/../.." && pwd)"
SCRIPT="$AIR/logs/scripts/check-archive.sh"
TODAY="$(date +%Y-%m-%d)"

fail() { echo ">>> FAIL: $1"; exit 1; }
[ -x "$SCRIPT" ] || fail "shipped script not found/executable: $SCRIPT"

# Guard: the real ai-resources session-notes.md/decisions.md must be byte-identical afterward.
sum_air() { for f in session-notes.md decisions.md; do [ -f "$AIR/logs/$f" ] && md5 -q "$AIR/logs/$f" 2>/dev/null || cksum "$AIR/logs/$f" 2>/dev/null; done; }
AIR_BEFORE="$(sum_air)"

# Build a throwaway "project" with logs/session-notes.md of $1 dated entries (old dates,
# NOT today unless $2=today), ~45 body lines each so it clears the 500-line threshold.
make_project() {
    local dir="$1" nentries="$2" firstdate="${3:-}"
    mkdir -p "$dir/logs"
    python3 - "$dir/logs/session-notes.md" "$nentries" "$firstdate" <<'PY'
import sys
path, n, firstdate = sys.argv[1], int(sys.argv[2]), sys.argv[3]
lines = ["# Session Notes", ""]
for i in range(n):
    if i == 0 and firstdate:
        d = firstdate
    else:
        d = "2026-01-%02d" % (i + 1)
    lines.append("## %s — Session S%d" % (d, i + 1))
    lines += ["body line %d.%d" % (i, j) for j in range(45)]
    lines.append("")
open(path, "w").write("\n".join(lines) + "\n")
PY
}

# ---------------------------------------------------------------------------
echo "########## TEST 1 — target isolation: archives the CALLER, not ai-resources ##########"
P1="$SCRATCH/proj1"; make_project "$P1" 14
BEFORE_LINES=$(wc -l < "$P1/logs/session-notes.md" | tr -d ' ')
OUT1="$(CLAUDE_PROJECT_DIR="$P1" bash "$SCRIPT" 2>&1)"; RC1=$?
echo "$OUT1"
[ "$RC1" -eq 0 ] || fail "TEST 1: exit $RC1 (expected 0)"
echo "$OUT1" | grep -q "Auto-archived" || fail "TEST 1: nothing archived (expected Auto-archived)"
[ -f "$P1/logs/session-notes-archive-2026-01.md" ] || fail "TEST 1: archive file not created in the caller's project"
AFTER_LINES=$(wc -l < "$P1/logs/session-notes.md" | tr -d ' ')
[ "$AFTER_LINES" -lt "$BEFORE_LINES" ] || fail "TEST 1: caller's log did not shrink ($BEFORE_LINES -> $AFTER_LINES)"
# TEST 7 (split-log resolves from SCRIPT_DIR even though the caller has NO logs/scripts/):
[ ! -d "$P1/logs/scripts" ] || fail "TEST 1/7: fixture unexpectedly has logs/scripts/"
echo ">>> TEST 1 pass: caller archived (via ai-resources' split-log.sh), caller has no logs/scripts/ (covers thread-2 dissolution)."

# ---------------------------------------------------------------------------
echo ""
echo "########## TEST 2 — no target: CLAUDE_PROJECT_DIR unset -> exit 1, no write ##########"
P2="$SCRATCH/proj2"; make_project "$P2" 14
B2=$(wc -l < "$P2/logs/session-notes.md" | tr -d ' ')
OUT2="$(env -u CLAUDE_PROJECT_DIR bash "$SCRIPT" 2>&1)"; RC2=$?
[ "$RC2" -eq 1 ] || fail "TEST 2: exit $RC2 (expected 1 on missing target)"
echo "$OUT2" | grep -qi "no archive target" || fail "TEST 2: missing expected diagnostic"
A2=$(wc -l < "$P2/logs/session-notes.md" | tr -d ' ')
[ "$A2" -eq "$B2" ] || fail "TEST 2: a file was modified despite no target"
echo ">>> TEST 2 pass: exit 1, diagnostic printed, nothing archived."

# ---------------------------------------------------------------------------
echo ""
echo "########## TEST 3 — target has no logs/: exit 1 ##########"
mkdir -p "$SCRATCH/nologs"
OUT3="$(CLAUDE_PROJECT_DIR="$SCRATCH/nologs" bash "$SCRIPT" 2>&1)"; RC3=$?
[ "$RC3" -eq 1 ] || fail "TEST 3: exit $RC3 (expected 1 when target has no logs/)"
echo ">>> TEST 3 pass: exit 1 when the target has no logs/."

# ---------------------------------------------------------------------------
echo ""
echo "########## TEST 4 — /log-sweep caller pattern archives the passed target ##########"
P4="$SCRATCH/proj4"; make_project "$P4" 14
# Exactly the pattern log-sweep.md now uses: cd into the target, pass CLAUDE_PROJECT_DIR=pwd.
OUT4="$(cd "$P4" && CLAUDE_PROJECT_DIR="$(pwd)" bash "$SCRIPT" 2>&1)"; RC4=$?
[ "$RC4" -eq 0 ] || fail "TEST 4: exit $RC4 (expected 0)"
echo "$OUT4" | grep -q "Auto-archived" || fail "TEST 4: log-sweep pattern did not archive the target"
echo ">>> TEST 4 pass: the fixed /log-sweep invocation archives the target."

# ---------------------------------------------------------------------------
echo ""
echo "########## TEST 5 — --warn-only reports without writing ##########"
P5="$SCRATCH/proj5"; make_project "$P5" 20   # ~20 entries > 1.5x (750-line) warn threshold
B5=$(md5 -q "$P5/logs/session-notes.md" 2>/dev/null || cksum "$P5/logs/session-notes.md")
OUT5="$(CLAUDE_PROJECT_DIR="$P5" bash "$SCRIPT" --warn-only 2>&1)"; RC5=$?
[ "$RC5" -eq 0 ] || fail "TEST 5: exit $RC5 (expected 0)"
echo "$OUT5" | grep -q '"systemMessage"' || fail "TEST 5: --warn-only did not emit a systemMessage JSON"
A5=$(md5 -q "$P5/logs/session-notes.md" 2>/dev/null || cksum "$P5/logs/session-notes.md")
[ "$B5" = "$A5" ] || fail "TEST 5: --warn-only modified the file (must be read-only)"
echo ">>> TEST 5 pass: JSON systemMessage emitted, file unchanged."

# ---------------------------------------------------------------------------
echo ""
echo "########## TEST 6 — today-date guard still refuses a fresh top entry ##########"
P6="$SCRATCH/proj6"; make_project "$P6" 14 "$TODAY"
OUT6="$(CLAUDE_PROJECT_DIR="$P6" bash "$SCRIPT" 2>&1)"; RC6=$?
echo "$OUT6" | grep -qi "Skipped archive" || fail "TEST 6: today-date guard did not fire"
[ ! -f "$P6/logs/session-notes-archive-2026-01.md" ] || fail "TEST 6: archived despite today's first entry"
echo ">>> TEST 6 pass: refused to archive a file whose first dated entry is today's."

# ---------------------------------------------------------------------------
echo ""
echo "########## FALSIFICATION GUARD — ai-resources logs untouched throughout ##########"
AIR_AFTER="$(sum_air)"
[ "$AIR_BEFORE" = "$AIR_AFTER" ] || fail "ai-resources/logs was MODIFIED — the wrong-repo defect is NOT fixed."
echo ">>> ai-resources/logs byte-identical before and after all tests."

echo ""
echo "ALL TESTS PASS (1 isolation+7 split-resolve · 2 no-target exit1 · 3 no-logs exit1 · 4 log-sweep pattern · 5 warn-only · 6 today-guard · falsification: ai-resources untouched)"
exit 0
