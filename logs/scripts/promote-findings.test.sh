#!/bin/bash
# Falsification harness for logs/scripts/promote-findings.sh.
#
# Built 2026-07-30 alongside the script (stream 2026-07-30-prime-session-entry-ownership, S3).
# The script replaces /prime Step 3, so what it promotes IS the task menu's only severity-fed
# channel. Every assertion below runs against the file that ships — no copy, no extractor.
#
# The suite covers the four S3 criteria from the plan:
#   F-BACKLOG        — what the retired Step 3 would have surfaced reaches next-up.md
#   F-LOOP           — a new finding promotes; a second run adds no duplicate
#   F-PROMOTE-RACE   — concurrent sweeps leave exactly one entry and no source write
#   F-NO-SOURCE-WRITE— statically and behaviourally, the source logs are never written
#
# ⚠ ONE CRITERION IS DELIBERATELY SUBSTITUTED, AND THIS IS THE PLACE THAT SAYS SO.
#   The plan's F-PROMOTE-RACE control reads "remove the lock and observe the duplicate appear,
#   confirming the test can detect the race it is written for." That control is UNSATISFIABLE
#   against this implementation, and not because the test is weak. It was written against the
#   superseded stamp-the-source design, where promotion was an append guarded by a check-then-act
#   read — a genuine duplicate class. This implementation keeps identity in the destination and
#   rewrites next-up.md whole through an atomic os.replace, so two lock-less concurrent sweeps
#   compute the SAME set and the second write is idempotent: the duplicate class does not exist to
#   be observed. The lock's remaining job is lost-update protection (an operator ticking an item
#   while a sweep is mid-flight). TEST 8 therefore proves the mutex by the honour/release pair —
#   a held lock makes a run that WOULD have written write nothing, and releasing it makes the same
#   run promote — which is a deterministic control rather than a probabilistic one.

set -u
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/logs/scripts/promote-findings.sh"
[ -f "$SRC" ] || { echo "FATAL: cannot find promote-findings.sh at $SRC"; exit 2; }

T="${TMPDIR:-/tmp}/promote-findings-test.$$"
rm -rf "$T"; mkdir -p "$T"

PASS=0; FAIL=0
check () {
  if [ "$2" = "$3" ]; then printf '  PASS  %-56s got %s\n' "$1" "$3"; PASS=$((PASS+1))
  else printf '  FAIL  %-56s got %s, wanted %s\n' "$1" "$3" "$2"; FAIL=$((FAIL+1)); fi
}
ok ()  { printf '  PASS  %-56s\n' "$1"; PASS=$((PASS+1)); }
bad () { printf '  FAIL  %s\n' "$1"; FAIL=$((FAIL+1)); }

# A fixture repo carrying one entry per severity tier plus the two exclusion cases.
fixture () {
  R="$1"; rm -rf "$R"; mkdir -p "$R/logs"
  cat > "$R/logs/improvement-log.md" <<'LOG'
# Improvement Log

## Schema

Prose that must never be parsed as an entry.

### 2026-07-01 — Entry A, high

- **Status:** logged (pending)
- **Severity:** high — should promote.

### 2026-07-02 — Entry B, medium-high

- **Status:** logged (pending)
- **Severity:** medium-high — the tier that is deliberate menu-reach, not a borderline case.

### 2026-07-03 — Entry C, critical

- **Status:** logged (pending)
- **Severity:** critical — should promote.

### 2026-07-04 — Entry D, medium

- **Status:** logged (pending)
- **Severity:** medium — must NOT promote.

### 2026-07-05 — Entry E, low

- **Status:** logged (pending)
- **Severity:** low — must NOT promote.

### 2026-07-06 — Entry F, high but already applied

- **Status:** applied 2026-07-07 (S2-abc)
- **Severity:** high — must NOT promote, the status excludes it.

### 2026-07-08 — Entry G, high but resolved

- **Status:** resolved 2026-07-09
- **Severity:** high — must NOT promote.
LOG
  # A friction log in the REAL shape: substantive entries, no severity field anywhere, plus the
  # keyword prose that /prime Step 3's grep used to match on.
  cat > "$R/logs/friction-log.md" <<'LOG'
# Friction Log

## Schema

Failure mode / Root cause / Prevention / Owner artifact. No severity field exists here.

### 2026-07-10 — A real friction entry

- **Failure mode:** Workflow
- **Root cause:** the word HIGH appears in this prose and must not promote anything.
- **Prevention:** require a severity field before promoting.
- **Owner artifact:** (none identified)

### 2026-07-11 — Another, mentioning urgent and do-now in passing

- **Failure mode:** Context
- **Root cause:** an urgent-sounding narrative is not a severity tag.
- **Prevention:** none needed.
- **Owner artifact:** (none identified)
LOG
}

sums () { ( cd "$1" && shasum logs/friction-log.md logs/improvement-log.md | awk '{print $1}' | tr '\n' ' ' ); }
run  () { ( cd "$1" && bash "$SRC" ); }
ids  () { grep -o 'promote:[0-9a-f]*' "$1/logs/next-up.md" 2>/dev/null | sort; }
nq   () { grep -c '^- \[ \]' "$1/logs/next-up.md" 2>/dev/null | tr -d ' '; }

echo "===== TEST 1 — F-BACKLOG: exactly the qualifying entries reach next-up.md ====="
A="$T/a"; fixture "$A"
BEFORE=$(sums "$A")
OUT=$(run "$A"); echo "  $OUT"
[ -f "$A/logs/next-up.md" ] && ok "next-up.md created (the script owns creation, /prime never does)" \
                            || bad "next-up.md was not created"
check "three qualifying entries queued" "3" "$(nq "$A")"
for want in "Entry A, high" "Entry B, medium-high" "Entry C, critical"; do
  grep -Fq "$want" "$A/logs/next-up.md" && ok "promoted: $want" || bad "MISSING: $want"
done
echo "===== TEST 2 — the tiers that must NOT promote ====="
for no in "Entry D, medium" "Entry E, low" "Entry F, high but already applied" "Entry G, high but resolved"; do
  grep -Fq "$no" "$A/logs/next-up.md" && bad "WRONGLY promoted: $no" || ok "excluded: $no"
done
grep -q "Prose that must never be parsed" "$A/logs/next-up.md" && bad "schema prose was parsed as an entry" \
                                                              || ok "schema prose not parsed as an entry"

echo
echo "===== TEST 3 — F-NO-SOURCE-WRITE ====="
check "source logs byte-identical after the sweep" "$BEFORE" "$(sums "$A")"
# Static half: the constraint is docs/commit-discipline.md, not just the observed behaviour, so a
# write that happens not to fire today still falsifies.
if grep -nE '(>|>>|os\.replace|open\([^)]*["'"'"']w)' "$SRC" | grep -E 'friction-log|improvement-log' >/dev/null; then
  bad "the script contains a write path aimed at a source log"
else ok "no write path in the script targets either source log"; fi

echo
echo "===== TEST 4 — F-LOOP: rerun adds nothing; a NEW finding promotes ====="
OUT2=$(run "$A"); echo "  $OUT2"
check "rerun leaves the same three items" "3" "$(nq "$A")"
printf '\n### 2026-07-12 — Entry H, freshly written high\n\n- **Status:** logged (pending)\n- **Severity:** high — written after the first sweep.\n' >> "$A/logs/improvement-log.md"
OUT3=$(run "$A"); echo "  $OUT3"
check "the new finding is picked up" "4" "$(nq "$A")"
grep -Fq "Entry H, freshly written high" "$A/logs/next-up.md" && ok "promoted the post-sweep finding" || bad "new finding not promoted"
run "$A" >/dev/null
check "and a further rerun still adds no duplicate" "4" "$(nq "$A")"
check "…with four distinct promotion ids" "4" "$(ids "$A" | uniq | wc -l | tr -d ' ')"

echo
echo "===== TEST 5 — a ticked item never comes back ====="
sed -i '' 's|^- \[ \] Entry A, high|- [x] Entry A, high|' "$A/logs/next-up.md" 2>/dev/null \
  || sed -i 's|^- \[ \] Entry A, high|- [x] Entry A, high|' "$A/logs/next-up.md"
run "$A" >/dev/null
check "ticked item stays ticked, is not re-queued" "3" "$(nq "$A")"
check "…and its line still exists exactly once" "1" "$(grep -c 'Entry A, high' "$A/logs/next-up.md" | tr -d ' ')"

echo
echo "===== TEST 6 — self-healing de-duplication (a git union of two checkouts) ====="
grep 'Entry B, medium-high' "$A/logs/next-up.md" >> "$A/logs/next-up.md"
check "duplicate line present before the sweep" "2" "$(grep -c 'Entry B, medium-high' "$A/logs/next-up.md" | tr -d ' ')"
OUT6=$(run "$A"); echo "  $OUT6"
check "duplicate removed by the next sweep" "1" "$(grep -c 'Entry B, medium-high' "$A/logs/next-up.md" | tr -d ' ')"

echo
echo "===== TEST 7 — friction-log.md: no severity field means no promotion, and the path is LIVE ====="
grep -Fq "A real friction entry" "$A/logs/next-up.md" && bad "a keyword-only friction entry was promoted" \
                                                     || ok "keyword-only friction prose promotes nothing"
# Not stubbed: give a friction entry a real severity field and it must promote with no code change.
printf '\n### 2026-07-13 — Friction entry with a real severity field\n\n- **Status:** logged (pending)\n- **Severity:** high — a genuine tagged finding.\n' >> "$A/logs/friction-log.md"
run "$A" >/dev/null
grep -Fq "Friction entry with a real severity field" "$A/logs/next-up.md" \
  && ok "a severity-TAGGED friction entry does promote (path is live, not stubbed)" \
  || bad "the friction-log code path is dead — a tagged entry did not promote"

echo
echo "===== TEST 8 — F-PROMOTE-RACE ====="
B="$T/b"; fixture "$B"
BSUM=$(sums "$B")
( cd "$B" && bash "$SRC" >/dev/null ) & ( cd "$B" && bash "$SRC" >/dev/null ) & wait
check "two concurrent sweeps leave three items, not six" "3" "$(nq "$B")"
check "…and three distinct ids"                          "3" "$(ids "$B" | uniq | wc -l | tr -d ' ')"
check "…with the source logs untouched"     "$BSUM" "$(sums "$B")"
[ -d "$B/logs/.promote.lock" ] && bad "the lock directory survived the run (would block every future sweep)" \
                               || ok "lock released after both runs"
echo "  -- the substituted control (see the header block): honour, then release --"
C="$T/c"; fixture "$C"
mkdir -p "$C/logs/.promote.lock"
OUTC=$(run "$C")
check "held lock: run writes nothing"        ""  "$OUTC"
[ -f "$C/logs/next-up.md" ] && bad "a run under a held lock still wrote the queue" \
                            || ok "held lock: no next-up.md written"
rmdir "$C/logs/.promote.lock"
run "$C" >/dev/null
check "released lock: the SAME run now promotes" "3" "$(nq "$C")"

echo
echo "===== TEST 9 — degrade-safe: a missing source log is skipped, not fatal ====="
D="$T/d"; fixture "$D"; rm -f "$D/logs/friction-log.md"
OUTD=$(run "$D"); RCD=$?
check "exit 0 with one source log absent" "0" "$RCD"
check "…and the other log still promotes"  "3" "$(nq "$D")"
E="$T/e"; mkdir -p "$E/logs"
OUTE=$(run "$E"); RCE=$?
check "exit 0 with NO source logs at all"  "0" "$RCE"
[ -f "$E/logs/next-up.md" ] && bad "created an empty queue file with nothing to promote" \
                            || ok "no queue file created when there is nothing to promote"
F="$T/f"; mkdir -p "$F"
( cd "$F" && bash "$SRC" >/dev/null 2>&1 ); RCF=$?
check "exit 1 when cwd has no logs/ directory" "1" "$RCF"

echo
echo "-------------------------------------------------------------"
printf 'RESULT: %d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] && echo "ALL PASS" || echo "*** DO NOT SHIP ***"
rm -rf "$T"
[ "$FAIL" -eq 0 ]
