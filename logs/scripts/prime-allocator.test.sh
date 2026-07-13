#!/bin/bash
# Falsification harness for the /prime marker allocator (S13).
# CRITICAL: every allocator run below executes under ZSH (`zsh "$T/new.sh"`), because the
# Bash tool's real shell is zsh. The first version of this harness ran bash and PASSED a
# block that zsh crashes on (NOMATCH). Caught by the end-time /risk-check. Never test the
# allocator under bash alone again.
SP="/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources/9028157c-878f-4639-92f6-e048914dd21b/scratchpad"
T="$SP/mk"
rm -rf "$T"
mkdir -p "$T/main"
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
run () { ( cd "$1" && zsh "$T/new.sh" 2>&1 | grep '^MARKER=' | sed 's/MARKER=//' ); }

echo "===== TEST 0 — ZSH FIRST-RUN-OF-DAY (the bug the end-time gate caught) ====="
echo "Claims dir exists but holds NO today-dated entry. A glob NOMATCHes here under zsh."
OUT=$( cd "$T/main" && zsh "$T/new.sh" 2>&1 )
if printf '%s' "$OUT" | grep -qi "no matches found"; then
  printf '  FAIL  %-54s zsh NOMATCH crash still present\n' "first /prime of the day under zsh"; FAIL=$((FAIL+1))
else
  M=$(printf '%s' "$OUT" | grep '^MARKER=' | sed 's/MARKER=//')
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
echo "-------------------------------------------------------------"
printf 'RESULT: %d passed, %d failed   (all allocator runs executed under ZSH)\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] && echo "ALL PASS" || echo "*** DO NOT SHIP ***"
git -C "$T/main" worktree remove --force "$T/wt" 2>/dev/null
