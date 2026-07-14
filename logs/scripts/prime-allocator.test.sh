#!/bin/bash
# Falsification harness for the /prime marker allocator (S13).
# CRITICAL: every allocator run below executes under ZSH (`zsh "$T/new.sh"`), because the
# Bash tool's real shell is zsh. The first version of this harness ran bash and PASSED a
# block that zsh crashes on (NOMATCH). Caught by the end-time /risk-check. Never test the
# allocator under bash alone again.
#
# ⚠ SOURCE OF TRUTH — FIXED 2026-07-14 (S8). READ THIS BEFORE TOUCHING THE HARNESS.
#   This test used to read the allocator from `$SP/newblock.txt` — a file in a PREVIOUS session's
#   scratchpad, hardcoded by session id. That made the suite a snapshot test of dead code: on
#   2026-07-14 it reported "12 passed, 0 failed" while testing an allocator that contained the OLD
#   broken seed and NONE of that session's fix. A green run proved nothing about what ships.
#
#   It now EXTRACTS the allocator block directly out of `.claude/commands/prime.md`, so the thing
#   under test is the thing that runs. If prime.md's allocator changes, this suite sees it — which
#   is the only property that makes a regression test worth keeping. Do not reintroduce a copy.
ALLOC_SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/.claude/commands/prime.md"
[ -f "$ALLOC_SRC" ] || { echo "FATAL: cannot find prime.md at $ALLOC_SRC"; exit 2; }

SP="${TMPDIR:-/tmp}/prime-allocator-test.$$"
T="$SP/mk"
rm -rf "$T"
mkdir -p "$T/main" "$SP"

# Pull the first fenced bash block that contains the allocator, and dedent it.
awk '
  /^[[:space:]]*```bash[[:space:]]*$/ { inblk=1; buf=""; next }
  inblk && /^[[:space:]]*```[[:space:]]*$/ {
      if (buf ~ /Allocate N = 1/) { printf "%s", buf; exit }
      inblk=0; buf=""; next
  }
  inblk { buf = buf $0 "\n" }
' "$ALLOC_SRC" | sed -e 's/^         //' > "$SP/newblock.txt"

if ! grep -q 'MARKER=' "$SP/newblock.txt"; then
  echo "FATAL: allocator extraction from prime.md failed (no MARKER= assignment found)."
  echo "       The fence markers or the 'Allocate N = 1' anchor changed. Fix the extractor —"
  echo "       do NOT fall back to a copy, which is the defect this replaced."
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

cp "$SP/newblock.txt" "$T/new.sh"
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
run ()      { ( cd "$1" && zsh "$T/new.sh" 2>&1 | grep '^MARKER=' | sed 's/MARKER=//' | sed 's/-[A-Za-z0-9]*$//' ); }
run_full () { ( cd "$1" && zsh "$T/new.sh" 2>&1 | grep '^MARKER=' | sed 's/MARKER=//' ); }

echo "===== TEST 0 — ZSH FIRST-RUN-OF-DAY (the bug the end-time gate caught) ====="
echo "Claims dir exists but holds NO today-dated entry. A glob NOMATCHes here under zsh."
OUT=$( cd "$T/main" && zsh "$T/new.sh" 2>&1 )
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
MA=$( cd "$T/coll" && CLAUDE_CODE_SESSION_ID="aaa11111-1111-1111-1111-111111111111" zsh "$T/new.sh" 2>&1 | grep '^MARKER=' | sed 's/MARKER=//' )
printf '%s S5\n' "$TODAY" > "$T/coll/logs/.session-marker"
rm -rf "$T/coll/.git/axcion-session-markers"
MB=$( cd "$T/coll" && CLAUDE_CODE_SESSION_ID="bbb22222-2222-2222-2222-222222222222" zsh "$T/new.sh" 2>&1 | grep '^MARKER=' | sed 's/MARKER=//' )
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
MC=$( cd "$T/coll" && CLAUDE_CODE_SESSION_ID="" zsh "$T/new.sh" 2>&1 | grep '^MARKER=' | sed 's/MARKER=//' )
check "no CLAUDE_CODE_SESSION_ID => legacy bare S{N}"      "S6" "$MC"

# THE FAIL-SAFE, under the NEW grammar. This is the line that would allocate S1 over an existing
# S7 if the seed could not parse a suffixed marker — the "destructive regression" prime.md warns
# about. Assert it against a SUFFIXED marker, which is what the file will actually contain now.
mkdir -p "$T/nogit2/logs"                      # deliberately NOT a git repo → every scan fails
printf '%s S7-a4f\n' "$TODAY" > "$T/nogit2/logs/.session-marker"
MD=$( cd "$T/nogit2" && zsh "$T/new.sh" 2>&1 | grep '^MARKER=' | sed 's/MARKER=//' | sed 's/-[A-Za-z0-9]*$//' )
check "FAIL-SAFE reads a SUFFIXED marker: S7-a4f => S8"    "S8" "$MD"

echo
echo "-------------------------------------------------------------"
printf 'RESULT: %d passed, %d failed   (all allocator runs executed under ZSH)\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] && echo "ALL PASS" || echo "*** DO NOT SHIP ***"
git -C "$T/main" worktree remove --force "$T/wt" 2>/dev/null
