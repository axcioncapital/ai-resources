#!/bin/bash
# Falsification harness for the /prime SESSION ENTRY — allocator + header append + mtime stamp.
#
# 2026-07-30 (stream 2026-07-30-prime-session-entry-ownership, slice S1): the object under test was
# renamed and extended from `prime-marker.sh` to `prime-session-entry.sh`, which now owns the whole
# marker → header → mtime sequence. TESTS 0–8 (the 19 allocation assertions) are RETAINED unchanged
# in intent; TESTS 9–13 cover the two writes that moved in. Each new test carries its own control —
# a green run is load-bearing only when the same check has been shown able to go red.
# CRITICAL: every allocator run below executes under ZSH (`zsh "$T/new.sh"`), because the
# Bash tool's real shell is zsh. The first version of this harness ran bash and PASSED a
# block that zsh crashes on (NOMATCH). Caught by the end-time /risk-check. Never test the
# allocator under bash alone again.
#
# ⚠ SOURCE OF TRUTH — FIXED 2026-07-14 (S8), REPOINTED 2026-07-29. READ BEFORE TOUCHING THE HARNESS.
#   This test used to read the allocator from `$SP/newblock.txt` — a file in a PREVIOUS session's
#   scratchpad, hardcoded by session id. That made the suite a snapshot test of dead code: on
#   2026-07-14 it reported "12 passed, 0 failed" while testing an allocator that contained the OLD
#   broken seed and NONE of that session's fix. A green run proved nothing about what ships.
#
#   The 2026-07-14 fix made it EXTRACT the allocator out of `.claude/commands/prime.md` by awk,
#   anchored on a fence position, the literal string "Allocate N = 1", and an exact indent width.
#   That was the right fix for logic living inside a markdown prompt, but the anchor was fragile by
#   construction — a reformatted fence or a reworded comment would have silently broken extraction.
#
#   2026-07-29 (capability prime-runtime-delegation, Slice 2): the allocator MOVED OUT of prime.md
#   into `logs/scripts/prime-marker.sh`, so there is nothing left to scrape. This suite now runs the
#   SCRIPT DIRECTLY — no awk, no anchors, no extraction step that can drift. The thing under test is
#   the file that ships. Do not reintroduce a copy, and do not reintroduce an extractor.
#
#   2026-07-30 (stream 2026-07-30-prime-session-entry-ownership, S1): the script was renamed
#   `prime-session-entry.sh` and took over the header append and the mtime stamp.
ALLOC_SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/logs/scripts/prime-session-entry.sh"
[ -f "$ALLOC_SRC" ] || { echo "FATAL: cannot find prime-session-entry.sh at $ALLOC_SRC"; exit 2; }

SP="${TMPDIR:-/tmp}/prime-allocator-test.$$"
T="$SP/mk"
rm -rf "$T"
mkdir -p "$T/main" "$SP"

# The allocator is a script now — copy it verbatim. No extraction step, so no anchor to drift.
cp "$ALLOC_SRC" "$SP/alloc.sh"

if ! grep -q 'MARKER=' "$SP/alloc.sh"; then
  echo "FATAL: $ALLOC_SRC carries no MARKER= assignment — it is not the session-entry owner."
  echo "       Fix the script or the path; do NOT fall back to an inline copy, which is the"
  echo "       defect the 2026-07-14 fix replaced."
  exit 2
fi
cd "$T/main" || exit 1
git init -q .
git config user.email t@t
git config user.name t
mkdir -p logs
printf '# notes\n' > logs/session-notes.md
git add -A
git commit -qm init
git worktree add -q "$T/wt" -b wtbranch
TODAY=$(date '+%Y-%m-%d')

cp "$SP/alloc.sh" "$T/new.sh"
printf 'echo "MARKER=$MARKER"\n' >> "$T/new.sh"

cat > "$T/old.sh" <<'OLD'
TODAY=$(date '+%Y-%m-%d')
HIGH=0
if [ -f logs/.session-marker ]; then
  PREV=$(cat logs/.session-marker)
  case "$PREV" in
    "${TODAY} S"*) n="${PREV##*S}"
                   case "$n" in ''|*[!0-9]*) ;; *) [ "$n" -gt "$HIGH" ] && HIGH="$n";; esac;;
  esac
fi
for n in $( { grep -hoE "^## ${TODAY} — Session S[0-9]+" logs/session-notes.md 2>/dev/null
              git grep -hoE "^## ${TODAY} — Session S[0-9]+" \
                  $(git for-each-ref --format='%(refname)' refs/heads 2>/dev/null) \
                  -- logs/session-notes.md 2>/dev/null
            } | grep -oE '[0-9]+$' ); do
  case "$n" in ''|*[!0-9]*) continue;; esac
  [ "$n" -gt "$HIGH" ] && HIGH="$n"
done
MARKER="S$((HIGH + 1))"
echo "MARKER=$MARKER"
OLD

PASS=0; FAIL=0
check () {
  if [ "$2" = "$3" ]; then printf '  PASS  %-54s got %s\n' "$1" "$3"; PASS=$((PASS+1))
  else printf '  FAIL  %-54s got %s, wanted %s\n' "$1" "$3" "$2"; FAIL=$((FAIL+1)); fi
}
# every allocator run goes through ZSH
#
# `run` returns the marker with the id-suffix STRIPPED, because TESTS 0–7 are assertions about the
# NUMBER the allocator chose (S1 / S8 / S9 …) — the property the mutex, the fail-safe and the
# namespace scoping all exist to protect. The suffix is a separate property with a separate job
# (global uniqueness) and it is asserted on its own in TEST 8. Keeping them apart means a failure
# tells you WHICH property broke instead of just "the string differs".
#
# WORK_DESC is now a REQUIRED argument (the script refuses to write a header-less entry), so every
# run passes one. $2 overrides it where a test asserts on the recorded text.
run ()      { ( cd "$1" && zsh "$T/new.sh" "${2:-harness probe}" 2>&1 | grep '^MARKER=' | sed 's/MARKER=//' | sed 's/-[A-Za-z0-9]*$//' ); }
run_full () { ( cd "$1" && zsh "$T/new.sh" "${2:-harness probe}" 2>&1 | grep '^MARKER=' | sed 's/MARKER=//' ); }

echo "===== TEST 0 — ZSH FIRST-RUN-OF-DAY (the bug the end-time gate caught) ====="
echo "Claims dir exists but holds NO today-dated entry. A glob NOMATCHes here under zsh."
OUT=$( cd "$T/main" && zsh "$T/new.sh" "harness probe" 2>&1 )
if printf '%s' "$OUT" | grep -qi "no matches found"; then
  printf '  FAIL  %-54s zsh NOMATCH crash still present\n' "first /prime of the day under zsh"; FAIL=$((FAIL+1))
else
  # Suffix stripped: this test asserts the NUMBER (that the zsh NOMATCH crash does not reset it).
  # The suffix is asserted in TEST 8.
  M=$(printf '%s' "$OUT" | grep '^MARKER=' | sed 's/MARKER=//' | sed 's/-[A-Za-z0-9]*$//')
  check "first /prime of the day under zsh (no NOMATCH)" "S1" "$M"
fi

echo
echo "===== TEST 1 — THE DEFECT: uncommitted in-flight allocation in another checkout ====="
rm -rf "$T/main/.git/axcion-session-markers"
printf '## %s — Session S7\n' "$TODAY" >> "$T/wt/logs/session-notes.md"
mkdir -p "$T/main/.git/axcion-session-markers/_root/${TODAY}-S7"
rm -f "$T/main/logs/.session-marker"
# The script now WRITES a header of its own, so TEST 0's run left one in main's notes. Reset the
# notes alongside the marker file, or source (b) carries TEST 0's S1 into this scenario and the
# OLD-allocator assertion below stops reproducing the bug it exists to reproduce.
printf '# notes\n' > "$T/main/logs/session-notes.md"
O=$( cd "$T/main" && bash "$T/old.sh" | sed 's/MARKER=//' )
N=$( run "$T/main" )
check "OLD allocator COLLIDES (reproduces the bug)" "S1" "$O"
check "NEW allocator steps over the live claim"     "S8" "$N"

echo
echo "===== TEST 2 — the claim is visible FROM the worktree too (both directions) ====="
N2=$( run "$T/wt" )
check "NEW, run from the WORKTREE, sees main's claims" "S9" "$N2"

echo
echo "===== TEST 3 — FAIL-SAFE: git broken => must NOT reset to S1 ====="
mkdir -p "$T/nogit/logs"
printf '%s S5\n' "$TODAY" > "$T/nogit/logs/.session-marker"
N3=$( run "$T/nogit" )
check "no git repo + marker says S5 => S6, never S1" "S6" "$N3"

echo
echo "===== TEST 4 — ATOMIC MUTEX: two simultaneous allocations cannot both win ====="
rm -rf "$T/main/.git/axcion-session-markers"
rm -f "$T/main/logs/.session-marker" "$T/wt/logs/.session-marker"
run "$T/main" > "$T/r1" &
run "$T/wt"   > "$T/r2" &
wait
R1=$(cat "$T/r1"); R2=$(cat "$T/r2")
printf '  two concurrent /prime runs got: %s and %s\n' "$R1" "$R2"
if [ -n "$R1" ] && [ "$R1" != "$R2" ]; then printf '  PASS  %-54s\n' "distinct markers (mutex holds)"; PASS=$((PASS+1))
else printf '  FAIL  both got %s\n' "$R1"; FAIL=$((FAIL+1)); fi

echo
echo "===== TEST 5 — stale prior-day claims pruned, and cannot raise today's N ====="
mkdir -p "$T/main/.git/axcion-session-markers/_root/2020-01-01-S99"
LAST=$( run "$T/main" )
if [ -d "$T/main/.git/axcion-session-markers/_root/2020-01-01-S99" ]; then
  printf '  FAIL  stale 2020 claim survived\n'; FAIL=$((FAIL+1))
else printf '  PASS  %-54s\n' "stale 2020-01-01 claim pruned"; PASS=$((PASS+1)); fi
case "$LAST" in S1[0-9][0-9]) printf '  FAIL  stale claim raised HIGH: %s\n' "$LAST"; FAIL=$((FAIL+1));;
                *) printf '  PASS  %-54s got %s\n' "stale claim did not inflate today's N" "$LAST"; PASS=$((PASS+1));; esac

echo
echo "===== TEST 6 — NAMESPACE SCOPING: a subdir project must not share a sibling's claims ====="
echo "(projects/axcion-website/ is NOT its own repo but has its own session-notes.md)"
mkdir -p "$T/main/sub/logs"; printf '# notes\n' > "$T/main/sub/logs/session-notes.md"
rm -rf "$T/main/.git/axcion-session-markers"
ROOTM=$( run "$T/main" )       # allocates in the _root namespace
SUBM=$( run "$T/main/sub" )    # must get its OWN namespace, not inherit _root's number
printf '  repo root got %s ; subdir project got %s\n' "$ROOTM" "$SUBM"
check "subdir project gets its own namespace (starts at S1)" "S1" "$SUBM"
NS=$(find "$T/main/.git/axcion-session-markers" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
check "two distinct claim namespaces exist" "2" "$NS"

echo
echo "===== TEST 7 — the rm -rf can never escape the claims dir ====="
touch "$T/main/.git/SENTINEL-DO-NOT-DELETE"
mkdir -p "$T/main/.git/refs/SENTINEL-DIR"
run "$T/main" > /dev/null
[ -f "$T/main/.git/SENTINEL-DO-NOT-DELETE" ] && { printf '  PASS  %-54s\n' ".git sentinel file untouched"; PASS=$((PASS+1)); } || { printf '  FAIL  sentinel DELETED\n'; FAIL=$((FAIL+1)); }
[ -d "$T/main/.git/refs/SENTINEL-DIR" ] && { printf '  PASS  %-54s\n' ".git/refs sentinel dir untouched"; PASS=$((PASS+1)); } || { printf '  FAIL  refs sentinel DELETED\n'; FAIL=$((FAIL+1)); }

echo
echo "===== TEST 8 — THE SUFFIX: collisions must be IMPOSSIBLE, not merely unlikely ====="
echo "The mutex narrows the race; it cannot close it (a checkout on an older prime.md"
echo "allocates blind — that gap produced FOUR real collisions in two days). The id suffix"
echo "is what makes two sessions unable to share a marker AT ALL. Assert that directly."
mkdir -p "$T/coll/logs"; ( cd "$T/coll" && git init -q . && git config user.email t@t && git config user.name t \
  && printf '# notes\n' > logs/session-notes.md && git add -A && git commit -qm i ) >/dev/null 2>&1

# Force BOTH sessions to compute the SAME N by resetting the marker between runs, and give them
# different session ids. Under the old grammar both would produce "S6" — the exact collision.
printf '%s S5\n' "$TODAY" > "$T/coll/logs/.session-marker"
rm -rf "$T/coll/.git/axcion-session-markers"
printf '# notes\n' > "$T/coll/logs/session-notes.md"   # reset source (b) too — the script writes headers now
MA=$( cd "$T/coll" && CLAUDE_CODE_SESSION_ID="aaa11111-1111-1111-1111-111111111111" zsh "$T/new.sh" "harness probe" 2>&1 | grep '^MARKER=' | sed 's/MARKER=//' )
printf '%s S5\n' "$TODAY" > "$T/coll/logs/.session-marker"
rm -rf "$T/coll/.git/axcion-session-markers"
printf '# notes\n' > "$T/coll/logs/session-notes.md"   # reset source (b) too — the script writes headers now
MB=$( cd "$T/coll" && CLAUDE_CODE_SESSION_ID="bbb22222-2222-2222-2222-222222222222" zsh "$T/new.sh" "harness probe" 2>&1 | grep '^MARKER=' | sed 's/MARKER=//' )
printf '  same N forced; session A -> %s ; session B -> %s\n' "$MA" "$MB"
check "A and B both allocate number 6"                     "S6" "$(printf '%s' "$MA" | sed 's/-[A-Za-z0-9]*$//')"
check "…and B likewise"                                    "S6" "$(printf '%s' "$MB" | sed 's/-[A-Za-z0-9]*$//')"
if [ "$MA" != "$MB" ]; then printf '  PASS  %-54s %s != %s\n' "IDENTICAL N, DISTINCT MARKERS — collision impossible" "$MA" "$MB"; PASS=$((PASS+1))
else printf '  FAIL  COLLIDED: both sessions got %s\n' "$MA"; FAIL=$((FAIL+1)); fi
check "A's marker carries its own id3"                     "S6-aaa" "$MA"
check "B's marker carries its own id3"                     "S6-bbb" "$MB"

# Degrade-safe: no session id (older CLI) must fall back to the legacy bare S{N}, not to "S6-".
printf '%s S5\n' "$TODAY" > "$T/coll/logs/.session-marker"
rm -rf "$T/coll/.git/axcion-session-markers"
printf '# notes\n' > "$T/coll/logs/session-notes.md"   # reset source (b) too — the script writes headers now
MC=$( cd "$T/coll" && CLAUDE_CODE_SESSION_ID="" zsh "$T/new.sh" "harness probe" 2>&1 | grep '^MARKER=' | sed 's/MARKER=//' )
check "no CLAUDE_CODE_SESSION_ID => legacy bare S{N}"      "S6" "$MC"

# THE FAIL-SAFE, under the NEW grammar. This is the line that would allocate S1 over an existing
# S7 if the seed could not parse a suffixed marker — the "destructive regression" prime.md warns
# about. Assert it against a SUFFIXED marker, which is what the file will actually contain now.
mkdir -p "$T/nogit2/logs"                      # deliberately NOT a git repo → every scan fails
printf '%s S7-a4f\n' "$TODAY" > "$T/nogit2/logs/.session-marker"
MD=$( cd "$T/nogit2" && zsh "$T/new.sh" "harness probe" 2>&1 | grep '^MARKER=' | sed 's/MARKER=//' | sed 's/-[A-Za-z0-9]*$//' )
check "FAIL-SAFE reads a SUFFIXED marker: S7-a4f => S8"    "S8" "$MD"


# =============================================================================================
# TESTS 9–13 — THE SESSION ENTRY (added 2026-07-30, slice S1)
# The allocator was only two thirds of the owner. These cover the header append and the mtime
# stamp, which moved in from prose in prime.md — the two writes that had never been executed by
# a test at all.
# =============================================================================================

# Shared fixture: a fresh repo per test, so nothing above leaks into these assertions.
fresh_repo () {
  rm -rf "$1"; mkdir -p "$1/logs"
  ( cd "$1" && git init -q . && git config user.email t@t && git config user.name t \
    && printf '# notes\n' > logs/session-notes.md && git add -A && git commit -qm i ) >/dev/null 2>&1
}
# Sub-second mtime, BSD first then GNU. Used only for ORDERING assertions, never for the stored value.
fmtime () { stat -f %Fm "$1" 2>/dev/null || stat -c %.9Y "$1" 2>/dev/null; }

echo
echo "===== TEST 9 — F-ENTRY: ONE call must leave ALL FOUR artifacts ====="
echo "Marker file, per-id oracle, marker-bearing header with its work line, and .prime-mtime."
E="$T/entry"; fresh_repo "$E"
EID="eee33333-3333-3333-3333-333333333333"
EDESC="Continue building the prime command — S1 session entry"
EM=$( cd "$E" && CLAUDE_CODE_SESSION_ID="$EID" zsh "$T/new.sh" "$EDESC" 2>&1 | grep '^MARKER=' | sed 's/MARKER=//' )
printf '  one call, marker %s\n' "$EM"
[ -f "$E/logs/.session-marker" ] && { printf '  PASS  %-54s\n' "1/4 logs/.session-marker written"; PASS=$((PASS+1)); } \
                                 || { printf '  FAIL  logs/.session-marker MISSING\n'; FAIL=$((FAIL+1)); }
[ -f "$E/logs/.session-marker-$EID" ] && { printf '  PASS  %-54s\n' "2/4 per-id identity oracle written"; PASS=$((PASS+1)); } \
                                      || { printf '  FAIL  per-id marker MISSING (both-or-neither invariant)\n'; FAIL=$((FAIL+1)); }
if grep -Fxq "## ${TODAY} — Session ${EM}" "$E/logs/session-notes.md"; then
  printf '  PASS  %-54s\n' "3/4 marker-bearing header appended"; PASS=$((PASS+1))
else printf '  FAIL  header "## %s — Session %s" MISSING\n' "$TODAY" "$EM"; FAIL=$((FAIL+1)); fi
if grep -Fq "$EDESC" "$E/logs/session-notes.md"; then
  printf '  PASS  %-54s\n' "3b/4 WORK_DESC recorded verbatim beneath it"; PASS=$((PASS+1))
else printf '  FAIL  WORK_DESC not found in session-notes.md\n'; FAIL=$((FAIL+1)); fi
EMT=$(cat "$E/logs/.prime-mtime" 2>/dev/null | tr -d '\n')
case "$EMT" in ''|*[!0-9]*) printf '  FAIL  .prime-mtime absent or not whole seconds: "%s"\n' "$EMT"; FAIL=$((FAIL+1));;
               *) printf '  PASS  %-54s got %s\n' "4/4 .prime-mtime written, whole seconds" "$EMT"; PASS=$((PASS+1));; esac
# The stored value must remain integer seconds: foreign-session-guard.sh reads it through
# `tr -dc '0-9'`, which would turn a fractional stamp into a 19-digit integer.
check "…and equals stat -f %m of session-notes.md" "$(stat -f %m "$E/logs/session-notes.md" 2>/dev/null || stat -c %Y "$E/logs/session-notes.md")" "$EMT"

echo
echo "===== TEST 10 — F-ORDER: marker BEFORE the header, mtime AFTER it ====="
echo "stat truncates to whole seconds, so 'mtime after append' is not an oracle on its own."
echo "Two checks that do not depend on clock resolution, each with a control."
# (i) The header CONTAINS the marker — possible only if allocation preceded the append.
if grep -Fxq "## ${TODAY} — Session ${EM}" "$E/logs/session-notes.md"; then
  printf '  PASS  %-54s\n' "(i) header embeds \${MARKER} => marker came first"; PASS=$((PASS+1))
else printf '  FAIL  (i) header does not embed the allocated marker\n'; FAIL=$((FAIL+1)); fi
# (ii) .prime-mtime's OWN mtime is not earlier than session-notes.md's, at sub-second resolution.
#      This asserts write ORDER without touching the stored value's precision.
A_NOTES=$(fmtime "$E/logs/session-notes.md"); A_STAMP=$(fmtime "$E/logs/.prime-mtime")
if awk -v a="$A_STAMP" -v b="$A_NOTES" 'BEGIN{exit !(a>=b)}'; then
  printf '  PASS  %-54s\n' "(ii) .prime-mtime written AFTER the append"; PASS=$((PASS+1))
else printf '  FAIL  (ii) stamp %s precedes append %s\n' "$A_STAMP" "$A_NOTES"; FAIL=$((FAIL+1)); fi
# CONTROL — the same check must go RED on a deliberately reversed order. Without this, (ii) green
# proves nothing. The 1s gap makes the control deterministic rather than clock-race dependent.
cat > "$T/order-mutant.sh" <<MUT
PRIME_SESSION_ENTRY_SOURCE_ONLY=1
. "$SP/alloc.sh"
allocate_marker
stamp_prime_mtime          # WRONG ORDER — stamp first
sleep 1
append_work_entry "\$TODAY" "\$MARKER" "order mutant"
MUT
OM="$T/order"; fresh_repo "$OM"
( cd "$OM" && zsh "$T/order-mutant.sh" ) >/dev/null 2>&1
B_NOTES=$(fmtime "$OM/logs/session-notes.md"); B_STAMP=$(fmtime "$OM/logs/.prime-mtime")
if awk -v a="$B_STAMP" -v b="$B_NOTES" 'BEGIN{exit !(a>=b)}'; then
  printf '  FAIL  CONTROL: reversed order was NOT detected — check (ii) is inert\n'; FAIL=$((FAIL+1))
else printf '  PASS  %-54s\n' "CONTROL: reversed order detected (check can go red)"; PASS=$((PASS+1)); fi
# And the stored VALUE is stale under the mutant, which is the failure a real reversal produces:
# /session-start Step 0.5 would compute DELTA > 0 and report this session's own write as foreign.
B_STORED=$(cat "$OM/logs/.prime-mtime" | tr -d '\n')
B_ACTUAL=$(stat -f %m "$OM/logs/session-notes.md" 2>/dev/null || stat -c %Y "$OM/logs/session-notes.md")
if [ "$B_STORED" != "$B_ACTUAL" ]; then
  printf '  PASS  %-54s stored %s vs actual %s\n' "CONTROL: reversal leaves a STALE .prime-mtime" "$B_STORED" "$B_ACTUAL"; PASS=$((PASS+1))
else printf '  FAIL  CONTROL: reversed order left a matching stamp\n'; FAIL=$((FAIL+1)); fi

echo
echo "===== TEST 11 — same-marker re-invocation reuses the header, never duplicates it ====="
echo "Driven through the source-only seam, because the allocator can never hand out the same"
echo "number twice in one repo (source (b) sees the header it just wrote)."
R="$T/reuse"; fresh_repo "$R"
cat > "$T/reuse.sh" <<REU
PRIME_SESSION_ENTRY_SOURCE_ONLY=1
. "$SP/alloc.sh"
append_work_entry "$TODAY" "S42-zzz" "first work line"
append_work_entry "$TODAY" "S42-zzz" "second work line"
REU
( cd "$R" && zsh "$T/reuse.sh" ) >/dev/null 2>&1
HDRC=$(grep -Fxc "## ${TODAY} — Session S42-zzz" "$R/logs/session-notes.md" | tr -d ' ')
check "exactly ONE header after two same-marker calls" "1" "$HDRC"
grep -Fq "first work line"  "$R/logs/session-notes.md" && grep -Fq "second work line" "$R/logs/session-notes.md" \
  && { printf '  PASS  %-54s\n' "both work lines recorded under it"; PASS=$((PASS+1)); } \
  || { printf '  FAIL  a work line was lost on re-invocation\n'; FAIL=$((FAIL+1)); }

echo
echo "===== TEST 12 — F-RECOVER: failure after the per-id marker, before the header ====="
echo "The dangerous retry path: both marker files on disk, no header. One number is burned;"
echo "the next /prime must allocate N+1 and complete. (The other five partial states of the"
echo "six-state model are recorded UNASSESSED — see the S1 plan § 5 — not proven here.)"
cat > "$T/recover-mutant.sh" <<REC
PRIME_SESSION_ENTRY_SOURCE_ONLY=1
. "$SP/alloc.sh"
allocate_marker
exit 9                     # INJECTED FAILURE — after write 4, before the header append
REC
RC="$T/recover"; fresh_repo "$RC"
RID="fff44444-4444-4444-4444-444444444444"
( cd "$RC" && CLAUDE_CODE_SESSION_ID="$RID" zsh "$T/recover-mutant.sh" ) >/dev/null 2>&1
RRC=$?
check "injected failure exits non-zero" "9" "$RRC"
[ -f "$RC/logs/.session-marker" ] && [ -f "$RC/logs/.session-marker-$RID" ] \
  && { printf '  PASS  %-54s\n' "both marker files present after the failure"; PASS=$((PASS+1)); } \
  || { printf '  FAIL  marker files missing — this is not state 4\n'; FAIL=$((FAIL+1)); }
if grep -q "^## ${TODAY} — Session S" "$RC/logs/session-notes.md"; then
  printf '  FAIL  a header was written despite the injected failure\n'; FAIL=$((FAIL+1))
else printf '  PASS  %-54s\n' "no header written (the partial state under test)"; PASS=$((PASS+1)); fi
[ -f "$RC/logs/.prime-mtime" ] && { printf '  FAIL  .prime-mtime written despite the injected failure\n'; FAIL=$((FAIL+1)); } \
                               || { printf '  PASS  %-54s\n' "no .prime-mtime stamped"; PASS=$((PASS+1)); }
# Recovery: the next run burns S1 and completes on S2.
RM=$( cd "$RC" && CLAUDE_CODE_SESSION_ID="$RID" zsh "$T/new.sh" "recovery run" 2>&1 | grep '^MARKER=' | sed 's/MARKER=//' | sed 's/-[A-Za-z0-9]*$//' )
check "next run allocates N+1 (one number burned)" "S2" "$RM"
grep -q "^## ${TODAY} — Session S2" "$RC/logs/session-notes.md" \
  && [ -s "$RC/logs/.prime-mtime" ] \
  && { printf '  PASS  %-54s\n' "…and completes the full sequence"; PASS=$((PASS+1)); } \
  || { printf '  FAIL  recovery run did not complete the sequence\n'; FAIL=$((FAIL+1)); }

echo
echo "===== TEST 12b — F-MARKER-WRITE: a FAILED marker write must stop the sequence ====="
echo "Both redirections used to be unchecked, so a marker write that failed still returned 0 and"
echo "let the run continue into the header and the mtime stamp — a partial state indistinguishable"
echo "from a complete one. Occupying the marker path with a DIRECTORY makes the redirection fail."

# (a) SHARED marker unwritable. The per-id write goes first and succeeds, so this also exercises the
#     both-or-neither ROLLBACK: shared-without-per-id is the forbidden half-state, and the run must
#     not end holding a per-id file it can no longer pair.
WA="$T/wfail-shared"; fresh_repo "$WA"
WAID="aaa55555-5555-5555-5555-555555555555"
mkdir "$WA/logs/.session-marker"
( cd "$WA" && CLAUDE_CODE_SESSION_ID="$WAID" zsh "$T/new.sh" "shared marker unwritable" ) >/dev/null 2>&1
WARC=$?
[ "$WARC" -ne 0 ] && { printf '  PASS  %-54s got %s\n' "(a) unwritable shared marker exits non-zero" "$WARC"; PASS=$((PASS+1)); } \
                  || { printf '  FAIL  (a) exited 0 despite a failed shared-marker write\n'; FAIL=$((FAIL+1)); }
[ -f "$WA/logs/.session-marker-$WAID" ] \
  && { printf '  FAIL  (a) per-id marker left behind — both-or-neither rollback did not run\n'; FAIL=$((FAIL+1)); } \
  || { printf '  PASS  %-54s\n' "(a) per-id marker rolled back (neither state)"; PASS=$((PASS+1)); }
if grep -q "^## ${TODAY} — Session S" "$WA/logs/session-notes.md"; then
  printf '  FAIL  (a) a header was appended after a failed marker write\n'; FAIL=$((FAIL+1))
else printf '  PASS  %-54s\n' "(a) no header appended"; PASS=$((PASS+1)); fi
[ -f "$WA/logs/.prime-mtime" ] && { printf '  FAIL  (a) .prime-mtime stamped after a failed marker write\n'; FAIL=$((FAIL+1)); } \
                              || { printf '  PASS  %-54s\n' "(a) no .prime-mtime stamped"; PASS=$((PASS+1)); }

# (b) PER-ID marker unwritable. It is written FIRST precisely so this aborts before the shared file is
#     touched — the forbidden shared-without-per-id state must be structurally unreachable.
WB="$T/wfail-perid"; fresh_repo "$WB"
WBID="bbb66666-6666-6666-6666-666666666666"
mkdir "$WB/logs/.session-marker-$WBID"
( cd "$WB" && CLAUDE_CODE_SESSION_ID="$WBID" zsh "$T/new.sh" "per-id marker unwritable" ) >/dev/null 2>&1
WBRC=$?
[ "$WBRC" -ne 0 ] && { printf '  PASS  %-54s got %s\n' "(b) unwritable per-id marker exits non-zero" "$WBRC"; PASS=$((PASS+1)); } \
                  || { printf '  FAIL  (b) exited 0 despite a failed per-id write\n'; FAIL=$((FAIL+1)); }
[ -f "$WB/logs/.session-marker" ] \
  && { printf '  FAIL  (b) SHARED marker written without a per-id pair — invariant violated\n'; FAIL=$((FAIL+1)); } \
  || { printf '  PASS  %-54s\n' "(b) shared marker never written (invariant held)"; PASS=$((PASS+1)); }
if grep -q "^## ${TODAY} — Session S" "$WB/logs/session-notes.md"; then
  printf '  FAIL  (b) a header was appended after a failed marker write\n'; FAIL=$((FAIL+1))
else printf '  PASS  %-54s\n' "(b) no header appended"; PASS=$((PASS+1)); fi

# CONTROL — the same probe must go RED against the unchecked writes this test was built to catch.
# Without it, (a) and (b) green prove only that the harness runs, not that the guard exists.
sed -e 's|echo "${TODAY} ${MARKER}" > "$PERID" \|\| return 1|echo "${TODAY} ${MARKER}" > "$PERID"|' \
    -e 's|if ! echo "${TODAY} ${MARKER}" > logs/.session-marker; then|if false; then|' \
    "$SP/alloc.sh" > "$T/wfail-mutant.sh"
if ! grep -q 'if false; then' "$T/wfail-mutant.sh"; then
  printf '  FAIL  CONTROL: could not mutate the marker writes — the anchor lines have changed\n'; FAIL=$((FAIL+1))
else
  WM="$T/wfail-mutant"; fresh_repo "$WM"
  WMID="ccc77777-7777-7777-7777-777777777777"
  mkdir "$WM/logs/.session-marker"
  ( cd "$WM" && CLAUDE_CODE_SESSION_ID="$WMID" zsh "$T/wfail-mutant.sh" "unchecked writes" ) >/dev/null 2>&1
  if grep -q "^## ${TODAY} — Session S" "$WM/logs/session-notes.md"; then
    printf '  PASS  %-54s\n' "CONTROL: unchecked writes DO append a header"; PASS=$((PASS+1))
  else printf '  FAIL  CONTROL: the mutant wrote no header — TEST 12b is inert\n'; FAIL=$((FAIL+1)); fi
fi

echo
echo "===== TEST 13 — CONTROL: this suite can go RED ====="
echo "Mutate the fail-safe seed (the single most destructive possible regression) and re-run"
echo "TEST 3's scenario. If the mutant still passes, every green above is worthless."
sed 's|if \[ -f logs/.session-marker \]; then|if false; then|' "$SP/alloc.sh" > "$T/seed-mutant.sh"
printf 'echo "MARKER=$MARKER"\n' >> "$T/seed-mutant.sh"
if ! grep -q 'if false; then' "$T/seed-mutant.sh"; then
  printf '  FAIL  CONTROL: could not mutate the seed — the anchor line has changed\n'; FAIL=$((FAIL+1))
else
  mkdir -p "$T/mutant/logs"
  printf '%s S5\n' "$TODAY" > "$T/mutant/logs/.session-marker"
  MM=$( cd "$T/mutant" && zsh "$T/seed-mutant.sh" "harness probe" 2>&1 | grep '^MARKER=' | sed 's/MARKER=//' | sed 's/-[A-Za-z0-9]*$//' )
  if [ "$MM" = "S1" ]; then
    printf '  PASS  %-54s got %s (TEST 3 wanted S6)\n' "unseeded fail-safe allocates S1 OVER S5" "$MM"; PASS=$((PASS+1))
  else printf '  FAIL  CONTROL: mutant still returned %s — TEST 3 is inert\n' "$MM"; FAIL=$((FAIL+1)); fi
fi

echo
echo "-------------------------------------------------------------"
printf 'RESULT: %d passed, %d failed   (all allocator runs executed under ZSH)\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] && echo "ALL PASS" || echo "*** DO NOT SHIP ***"
git -C "$T/main" worktree remove --force "$T/wt" 2>/dev/null
