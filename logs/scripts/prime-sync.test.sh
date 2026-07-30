#!/bin/bash
# Falsification harness for logs/scripts/prime-sync.sh.
#
# Built 2026-07-30 alongside the script (stream 2026-07-30-prime-session-entry-ownership, S4).
# Every case uses REAL git against a local bare remote — no mocking of git itself, because the
# behaviours under test (the behind-check, autostash pop, a conflicted rebase) are git's, and a
# mocked git would only test the mock.
#
# ⚠ EVERY CASE PASSES AN EXPLICIT SECOND REPO. NEVER LET THE SUITE FALL BACK TO THE DEFAULT.
#   prime-sync.sh syncs the cwd repo and then a second, shared repo — defaulting to the operator's
#   live ai-resources checkout. The first version of this suite did not pass the argument, and the
#   failure was observed rather than theorised: TEST 2's call-recorder caught TWO fetches, the second
#   one real, against the live repo. A suite that fetches (and, on a behind repo, REBASES) production
#   as a side effect of running is worse than no suite. `$NOREPO` below is a path that does not exist,
#   so the second-repo branch skips; TEST 9 passes a real fixture to exercise it deliberately.

set -u
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/logs/scripts/prime-sync.sh"
[ -f "$SRC" ] || { echo "FATAL: cannot find prime-sync.sh at $SRC"; exit 2; }

T="${TMPDIR:-/tmp}/prime-sync-test.$$"
rm -rf "$T"; mkdir -p "$T"
export GIT_TERMINAL_PROMPT=0

PASS=0; FAIL=0
check () {
  if [ "$2" = "$3" ]; then printf '  PASS  %-52s got %s\n' "$1" "$3"; PASS=$((PASS+1))
  else printf '  FAIL  %-52s got [%s], wanted [%s]\n' "$1" "$3" "$2"; FAIL=$((FAIL+1)); fi
}
ok ()  { printf '  PASS  %-52s\n' "$1"; PASS=$((PASS+1)); }
bad () { printf '  FAIL  %s\n' "$1"; FAIL=$((FAIL+1)); }

# One bare "origin" plus a clone of it. The clone's branch tracks origin, so @{u} resolves.
make_pair () {
  N="$1"
  git init -q --bare "$T/$N.git"
  git clone -q "$T/$N.git" "$T/$N" 2>/dev/null
  ( cd "$T/$N" && git config user.email t@t && git config user.name t \
    && echo one > f.txt && git add f.txt && git commit -qm one && git push -q -u origin HEAD:main 2>/dev/null )
  # Re-point the local branch at main so @{u} is origin/main on every git version.
  ( cd "$T/$N" && git branch -M main 2>/dev/null; git branch --set-upstream-to=origin/main main 2>/dev/null ) >/dev/null 2>&1
}
# Advance the remote by one commit, via a throwaway second clone.
advance_remote () {
  N="$1"; rm -rf "$T/$N-push"
  git clone -q "$T/$N.git" "$T/$N-push" 2>/dev/null
  ( cd "$T/$N-push" && git config user.email t@t && git config user.name t \
    && echo "$2" > "$3" && git add -A && git commit -qm "remote-$2" && git push -q origin HEAD:main ) >/dev/null 2>&1
}
# A path that cannot exist, so the second-repo branch skips. NEVER omit this argument — see the header.
NOREPO="$T/__no_second_repo__"

sync_line () { ( cd "$1" && bash "$SRC" "$NOREPO" ) | grep '^SYNC:' | head -n 1; }
result_of  () { sync_line "$1" | sed 's/^SYNC: [^ ]* — //'; }
cwd_line   () { ( cd "$1" && bash "$SRC" "$NOREPO" ) | grep '^CWD_REPO:' | sed 's/^CWD_REPO: //'; }

# ---- the git call-recorder -------------------------------------------------------------------
# "Did the pull actually run?" has no observable answer from the repo's own state: `pull --rebase`
# on an up-to-date repo touches neither HEAD nor the reflog, so a state-based assertion cannot tell
# a skipped pull from a pull that found nothing. The FIRST version of TEST 2 asserted on the reflog
# and TEST 10's control proved it inert — it passed against a mutant with the guard removed. The
# oracle has to observe the CALL, so this shim records every git argv and forwards to the real git.
REALGIT="$(command -v git)"
mkdir -p "$T/bin"
cat > "$T/bin/git" <<SHIM
#!/bin/bash
printf '%s\n' "\$*" >> "\$GITLOG"
exec "$REALGIT" "\$@"
SHIM
chmod +x "$T/bin/git"
# Runs the script with git calls recorded. $1 = repo, $2 = log path, $3 = second repo (default none).
run_traced () { ( cd "$1" && GITLOG="$2" PATH="$T/bin:$PATH" bash "$SRC" "${3:-$T/__no_second_repo__}" ); }

echo "===== TEST 1 — CWD_REPO is emitted as an absolute path (it is part of the interface) ====="
make_pair r1
GOT=$(cwd_line "$T/r1")
WANT=$(cd "$T/r1" && pwd -P)
check "CWD_REPO resolves to the repo root" "$WANT" "$(cd "$GOT" && pwd -P)"

echo
echo "===== TEST 2 — up to date: the behind-check must SKIP the pull, not run it ====="
BEFORE_REF=$(cd "$T/r1" && git rev-parse HEAD)
OUT1=$(run_traced "$T/r1" "$T/log1")
check "result" "up to date" "$(printf '%s' "$OUT1" | grep '^SYNC:' | head -1 | sed 's/^SYNC: [^ ]* — //')"
check "HEAD unmoved" "$BEFORE_REF" "$(cd "$T/r1" && git rev-parse HEAD)"
check "the fetch DID run"  "1" "$(grep -c '^fetch\| fetch ' "$T/log1" | tr -d ' ' | head -1)"
check "the pull did NOT run (the guard skipped it)" "0" "$(grep -c 'pull --rebase' "$T/log1" | tr -d ' ')"

echo
echo "===== TEST 3 — behind: pulls and reports updated ====="
make_pair r2
advance_remote r2 two g.txt
check "result" "updated" "$(result_of "$T/r2")"
[ -f "$T/r2/g.txt" ] && ok "the remote commit actually arrived" || bad "g.txt absent — no pull happened"

echo
echo "===== TEST 4 — unpushed commits are counted and suffixed ====="
make_pair r3
( cd "$T/r3" && echo local > h.txt && git add h.txt && git commit -qm local ) >/dev/null
check "result carries the unpushed clause" "up to date — 1 unpushed" "$(result_of "$T/r3")"

echo
echo "===== TEST 5 — no upstream configured ====="
make_pair r4
( cd "$T/r4" && git branch --unset-upstream 2>/dev/null ) >/dev/null 2>&1
check "result" "skip (no upstream configured)" "$(result_of "$T/r4")"
printf '  (and no spurious "0 unpushed" clause on a repo with no upstream)\n'
case "$(result_of "$T/r4")" in *unpushed*) bad "unpushed clause emitted with no upstream";; *) ok "no unpushed clause";; esac

echo
echo "===== TEST 6 — not a git repo at all ====="
mkdir -p "$T/plain"
check "CWD_REPO" "(none)"                  "$(cwd_line "$T/plain")"
check "result"   "n/a (not a git repo)"    "$(result_of "$T/plain")"
check "exit 0 regardless"  "0" "$( ( cd "$T/plain" && bash "$SRC" >/dev/null 2>&1 ); echo $? )"

echo
echo "===== TEST 7 — autostash: a dirty tree survives a pull that rebases over it ====="
make_pair r5
advance_remote r5 two g.txt
( cd "$T/r5" && echo "dirty work in progress" > dirty.txt && echo "edited" >> f.txt )
check "result" "updated" "$(result_of "$T/r5")"
[ -f "$T/r5/g.txt" ] && ok "remote commit arrived" || bad "no pull happened"
grep -q "edited" "$T/r5/f.txt" && ok "the dirty tracked edit survived the autostash round-trip" \
                              || bad "the operator's uncommitted edit was LOST"
[ -f "$T/r5/dirty.txt" ] && ok "the untracked file survived" || bad "untracked file lost"

echo
echo "===== TEST 8 — conflicted rebase: abort, restore, classify, never leave mid-rebase ====="
make_pair r6
advance_remote r6 remote-side f.txt          # remote edits f.txt
( cd "$T/r6" && echo local-side > f.txt && git add f.txt && git commit -qm local-conflict ) >/dev/null
RES=$(result_of "$T/r6")
case "$RES" in
  failed:*rebase\ conflicted*) ok "classified: $RES"; PASS=$((PASS)) ;;
  *) bad "expected a rebase-conflict classification, got [$RES]" ;;
esac
if ( cd "$T/r6" && git rev-parse --verify -q REBASE_HEAD >/dev/null 2>&1 ) \
   || ( cd "$T/r6" && git status | grep -q 'rebase in progress' ); then
  bad "the repo was LEFT MID-REBASE — this is the state the abort exists to prevent"
else ok "repo restored, not left mid-rebase"; fi
check "local commit preserved" "local-conflict" "$(cd "$T/r6" && git log -1 --pretty=%s)"

echo
echo "===== TEST 9 — the second repo IS synced, and only when it differs from the cwd repo ====="
make_pair r8; make_pair r9
OUT9=$(run_traced "$T/r8" "$T/log9" "$T/r9")
check "two SYNC lines, one per repo" "2" "$(printf '%s\n' "$OUT9" | grep -c '^SYNC:' | tr -d ' ')"
printf '%s\n' "$OUT9" | grep -q "^SYNC: r9 — " && ok "the second repo appears by name" \
                                               || bad "the second repo was not synced"
# Same repo passed twice must not be synced twice.
OUT9b=$(run_traced "$T/r8" "$T/log9b" "$T/r8")
check "self-as-second-repo is not synced twice" "1" "$(printf '%s\n' "$OUT9b" | grep -c '^SYNC:' | tr -d ' ')"
# The default must be the real ai-resources path — the production behaviour the argument exists to
# make testable, not to change.
grep -q 'SECOND_REPO="${1:-/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources}"' "$SRC" \
  && ok "the default second repo is still ai-resources" \
  || bad "the ai-resources default was changed or removed — /prime relies on it"

echo
echo "===== TEST 9b — inspection: the load-bearing flags and guards ====="
grep -q 'pull --rebase --autostash' "$SRC" && ok "both pull flags stay explicit, never left to git config" \
                                           || bad "a pull flag was dropped"
grep -q 'rev-list --count HEAD..@{u}' "$SRC" && ok "the behind-check is present" \
                                             || bad "THE BEHIND-CHECK IS GONE — this reopens an incident class"
grep -q 'exit 0' "$SRC" && ok "terminates exit 0 (orientation never stops on a sync failure)" \
                        || bad "no unconditional exit 0"

echo
echo "===== TEST 10 — CONTROL: this suite can go RED ====="
# Remove the behind-check guard; TEST 2's assertion must flip from "no pull" to "pull ran". If it
# does not flip, TEST 2 proves nothing about the guard. (This control has already earned its keep:
# it caught the first version of TEST 2, which asserted on the reflog and passed against this same
# mutant — `pull --rebase` on an up-to-date repo leaves no reflog trace.)
sed 's|if \[ "\$BEHIND" = "0" \]; then|if false; then|' "$SRC" > "$T/mutant.sh"
if ! grep -q 'if false; then' "$T/mutant.sh"; then
  bad "CONTROL: could not mutate the behind-check — the anchor line has changed"
else
  make_pair r7
  ( cd "$T/r7" && GITLOG="$T/logm" PATH="$T/bin:$PATH" bash "$T/mutant.sh" "$NOREPO" ) >/dev/null 2>&1
  N=$(grep -c 'pull --rebase' "$T/logm" | tr -d ' ')
  if [ "$N" -ge 1 ]; then ok "unguarded run DOES issue the pull (TEST 2's oracle is live)"
  else bad "CONTROL: the mutant issued no pull — TEST 2's assertion is inert"; fi
fi

echo
echo "-------------------------------------------------------------"
printf 'RESULT: %d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] && echo "ALL PASS" || echo "*** DO NOT SHIP ***"
rm -rf "$T"
[ "$FAIL" -eq 0 ]
