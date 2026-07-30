#!/bin/bash
# Falsification harness for logs/scripts/prime-collect.sh.
#
# Built 2026-07-30 alongside the script (stream 2026-07-30-prime-session-entry-ownership, S5).
# Every case runs the REAL script against a REAL fixture repo built with REAL git. Nothing is mocked:
# the behaviours under test are "did the bounded read land on the right bytes" and "did the merged
# scan actually see the sibling repo", and a mock of the filesystem or of git would only test the mock.
#
# ⚠ EVERY CASE PASSES AN EXPLICIT AI_RESOURCES ARGUMENT. NEVER LET THE SUITE FALL BACK TO THE DEFAULT.
#   prime-collect.sh merges the cwd repo, ai-resources AND every sibling repo under
#   <workspace>/projects/ into its commit and mission scans. Left to default, the suite would scan the
#   operator's live checkout and ~20 live project repos — so its results would depend on production
#   state (a real mission going active would flip a case), and one case's assertions would be a
#   function of what the operator committed that morning. `$NOREPO` below is a path that does not
#   exist, so the shared-repo and sibling branches skip; TEST 7 passes a real fixture to exercise them
#   deliberately. This is the same trap prime-sync.test.sh documents, and it was found the same way.

set -u
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/logs/scripts/prime-collect.sh"
[ -f "$SRC" ] || { echo "FATAL: cannot find prime-collect.sh at $SRC"; exit 2; }

T="${TMPDIR:-/tmp}/prime-collect-test.$$"
rm -rf "$T"; mkdir -p "$T"
NOREPO="$T/__no_shared_repo__"

PASS=0; FAIL=0
check () {
  if [ "$2" = "$3" ]; then printf '  PASS  %-56s got [%s]\n' "$1" "$3"; PASS=$((PASS+1))
  else printf '  FAIL  %-56s got [%s], wanted [%s]\n' "$1" "$3" "$2"; FAIL=$((FAIL+1)); fi
}
ok  () { printf '  PASS  %s\n' "$1"; PASS=$((PASS+1)); }
bad () { printf '  FAIL  %s\n' "$1"; FAIL=$((FAIL+1)); }

# Build a repo with a logs/ dir and one commit. Callers add whatever the case needs on top.
# THE SEED COMMIT IS BACKDATED TO 2001, and both date variables are set rather than `commit --date`:
# `--since` filters on the COMMITTER date, which `--date` does not touch. The first version of this
# helper left the seed at "now" — and since the fixture entry dates are the same day the suite was
# written, TEST 3's "did the --since window bite" assertion passed a commit it should have excluded
# and reported a script defect that did not exist.
make_repo () {
  R="$T/$1"; mkdir -p "$R/logs"
  ( cd "$R" && git init -q . && git config user.email t@t && git config user.name t \
    && echo seed > seed.txt && git add seed.txt \
    && GIT_AUTHOR_DATE="2001-01-01T00:00:00" GIT_COMMITTER_DATE="2001-01-01T00:00:00" \
       git commit -qm "seed commit" ) >/dev/null 2>&1
  printf '%s' "$R"
}
# Commit with BOTH dates pinned, for the same reason.
commit_at () { ( cd "$1" && git add -A \
  && GIT_AUTHOR_DATE="$2" GIT_COMMITTER_DATE="$2" git commit -qm "$3" ) >/dev/null 2>&1; }
run       () { ( cd "$1" && bash "$SRC" "${2:-$NOREPO}" ); }
# Body of one fenced block, fence lines excluded. An absent block yields empty output, which is
# exactly how the contract says absence is reported — so the same helper tests presence and absence.
block     () { run "$1" "${3:-$NOREPO}" | awk -v b="$2" '$0=="===BEGIN "b"===" {f=1;next} $0=="===END "b"===" {f=0} f'; }
has_block () { run "$1" "${3:-$NOREPO}" | grep -qc "^===BEGIN $2===$" && echo yes || echo no; }
scalar    () { run "$1" "${3:-$NOREPO}" | grep "^$2: " | head -n 1 | sed "s/^$2: //"; }

echo
echo "=== TEST 1 — a bare repo with no logs at all emits the two scalars and nothing else ==="
# The empty-project case. Every optional block must be ABSENT, not present-and-empty: /prime treats an
# absent block as "this source does not exist here" and spends no menu slot on it.
R1=$(make_repo bare)
# CANONICALISE BOTH SIDES BEFORE COMPARING. `rev-parse --show-toplevel` returns the PHYSICAL path, and
# every macOS $TMPDIR is reached through a symlink (/var -> /private/var), so a plain string test on
# the fixture path fails on a correct result. Same trap as prime-sync.test.sh TEST 9.
R1_PHYS=$( cd "$R1" && git rev-parse --show-toplevel )
check "CWD_REPO resolves to the repo root"        "$R1_PHYS" "$(scalar "$R1" CWD_REPO)"
check "TELEMETRY_GAP defaults to no"              "no"  "$(scalar "$R1" TELEMETRY_GAP)"
for b in LAST_ENTRY NEXT_STEPS COMMITS SCRATCHPAD POSITION MISSIONS NEXT_UP FOREIGN_SHARED; do
  check "block $b absent"                         "no"  "$(has_block "$R1" "$b")"
done
check "exit code is 0"                            "0"   "$( ( cd "$R1" && bash "$SRC" "$NOREPO" >/dev/null 2>&1; echo $? ) )"

echo
echo "=== TEST 2 — the last entry is located by the ^## [0-9] anchor, not by a line window ==="
# THE REGRESSION THIS CASE EXISTS FOR. Two same-day entries plus a body line that itself starts with
# "## " — any fixed last-N-lines window straddles both entries and any unanchored grep picks the body
# line. Both failure modes surface as a plausible-looking entry, which is why this is asserted on
# content rather than on line count.
R2=$(make_repo anchored)
cat > "$R2/logs/session-notes.md" <<'EOF'
# Session Notes

## 2026-07-29 — first session of the day

### Summary
Older work. This line mentions ## 2026-07-31 inside prose, which is not a header.

### Next Steps
- old step that must not be collected

## 2026-07-30 — second session of the day

### Summary
Newer work.

### Next Steps
- ship the collector
- update the citations
EOF
E2=$(block "$R2" LAST_ENTRY)
check "entry header is the LAST one"              "## 2026-07-30 — second session of the day" "$(printf '%s\n' "$E2" | head -n 1)"
if printf '%s\n' "$E2" | grep -q "first session of the day"; then bad "LAST_ENTRY leaked the previous entry"; else ok "LAST_ENTRY stops at the last header"; fi
N2=$(block "$R2" NEXT_STEPS)
check "NEXT_STEPS bullet count"                   "2"   "$(printf '%s\n' "$N2" | grep -c '^- ')"
if printf '%s\n' "$N2" | grep -q "old step"; then bad "NEXT_STEPS leaked the previous entry's bullets"; else ok "NEXT_STEPS is scoped to the last entry"; fi

echo
echo "=== TEST 3 — the commit scan is anchored to the entry date and merges the shared repo ==="
# A cwd-only scan reports work done in ai-resources as still-open. This case proves the merge happens
# and that the --since window is the entry date, not an arbitrary default.
R3=$(make_repo cwdrepo)
S3=$(make_repo sharedrepo)
cat > "$R3/logs/session-notes.md" <<'EOF'
## 2026-07-30 — anchored

### Next Steps
- something
EOF
echo a > "$R3/a.txt"; commit_at "$R3" "2026-07-30T09:00:00" "cwd-side commit"
echo b > "$S3/b.txt"; commit_at "$S3" "2026-07-30T09:00:00" "shared-side commit"
C3=$(block "$R3" COMMITS "$S3")
if printf '%s\n' "$C3" | grep -q "cwd-side commit";    then ok "COMMITS includes the cwd repo";    else bad "COMMITS missed the cwd repo"; fi
if printf '%s\n' "$C3" | grep -q "shared-side commit"; then ok "COMMITS includes the shared repo"; else bad "COMMITS missed the shared repo — the merge is broken"; fi
if printf '%s\n' "$C3" | grep -q "seed commit";        then bad "COMMITS ignored the --since window"; else ok "COMMITS respects the entry-date window"; fi
C3B=$(block "$R3" COMMITS)
if printf '%s\n' "$C3B" | grep -q "shared-side commit"; then bad "shared repo scanned even when the argument points nowhere"; else ok "absent shared repo skips cleanly"; fi

echo
echo "=== TEST 4 — the scratchpad is selected by mtime and suppressed when superseded ==="
# Filename timestamps are typed by the writing session and skew by hours, so the NEWER file here is
# deliberately given the LEXICALLY EARLIER name. A filename sort picks the wrong one.
R4=$(make_repo scratch)
mkdir -p "$R4/logs/scratchpads"
cat > "$R4/logs/session-notes.md" <<'EOF'
## 2026-07-29 — last wrap
EOF
printf '## Resume With\n\nresume the OLD one\n' > "$R4/logs/scratchpads/2026-07-30-23-00-zzz-scratchpad.md"
printf '## Resume With\n\nresume the NEW one\n' > "$R4/logs/scratchpads/2026-07-30-01-00-aaa-scratchpad.md"
touch -t 203007300100 "$R4/logs/scratchpads/2026-07-30-23-00-zzz-scratchpad.md"   # lexically later, older mtime
touch -t 203007302300 "$R4/logs/scratchpads/2026-07-30-01-00-aaa-scratchpad.md"   # lexically earlier, newer mtime
S4B=$(block "$R4" SCRATCHPAD)
check "resume line comes from the newest MTIME"   "resume_with: resume the NEW one" "$(printf '%s\n' "$S4B" | grep '^resume_with: ')"
# Now make the last wrap newer than the scratchpad → superseded, must vanish entirely.
printf '## 2030-08-01 — a later wrap\n' > "$R4/logs/session-notes.md"
check "superseded scratchpad is suppressed"       "no"  "$(has_block "$R4" SCRATCHPAD)"

echo
echo "=== TEST 5 — plan position: state file wins, and the plan read stays bounded ==="
R5=$(make_repo position)
mkdir -p "$R5/pipeline"
printf '# Pipeline State\n\n| Stage | Status |\n|---|---|\n| 3 | in progress |\n' > "$R5/pipeline/pipeline-state.md"
printf '# Plan\n\n- [x] done thing\n- [ ] the first incomplete thing\n' > "$R5/pipeline/project-plan.md"
P5=$(block "$R5" POSITION)
check "state file is preferred over the spine"    "kind: state-file" "$(printf '%s\n' "$P5" | grep '^kind: ')"
# Remove the state file → falls through to the plan spine and must anchor on the first incomplete marker.
rm "$R5/pipeline/pipeline-state.md"
P5B=$(block "$R5" POSITION)
check "spine fallback reports plan-marker"        "kind: plan-marker" "$(printf '%s\n' "$P5B" | grep '^kind: ')"
check "anchor is the first incomplete marker"     "anchor: first-incomplete-marker" "$(printf '%s\n' "$P5B" | grep '^anchor: ')"
if printf '%s\n' "$P5B" | grep -q "the first incomplete thing"; then ok "slice contains the anchored marker"; else bad "slice missed the anchor"; fi
# A long plan with NO completion markers: must fall back to the last header and SAY it inferred.
R5C=$(make_repo position-nomarkers)
mkdir -p "$R5C/pipeline"
{ echo "# Plan"; for i in $(seq 1 400); do echo "filler line $i"; done; echo "## Stage 9 — the furthest along"; for i in $(seq 1 400); do echo "tail line $i"; done; } > "$R5C/pipeline/project-plan.md"
P5C=$(block "$R5C" POSITION)
check "no-marker plan says the position is inferred" "yes" "$(printf '%s\n' "$P5C" | grep -q 'inferred-from-plan-structure' && echo yes || echo no)"
BODY=$(printf '%s\n' "$P5C" | awk '/^---$/{f=1;next} f')
if [ "$(printf '%s\n' "$BODY" | wc -l | tr -d ' ')" -le 45 ]; then ok "plan slice is bounded (<=45 lines of an 800-line file)"
else bad "plan slice is NOT bounded — got $(printf '%s\n' "$BODY" | wc -l | tr -d ' ') lines"; fi

echo
echo "=== TEST 6 — missions: active only, archive never, threads carried ==="
R6=$(make_repo missions)
mkdir -p "$R6/logs/missions/archive"
printf 'mission_id: live-one\nmission_name: A live mission\nstatus: active\n---\n\n## Open threads\n\n- [ ] open thread one\n- [x] closed thread\n' > "$R6/logs/missions/live.md"
printf 'mission_id: paused-one\nmission_name: Not active\nstatus: paused\n' > "$R6/logs/missions/paused.md"
printf 'mission_id: archived-one\nmission_name: Closed long ago\nstatus: active\n' > "$R6/logs/missions/archive/old.md"
M6=$(block "$R6" MISSIONS)
if printf '%s\n' "$M6" | grep -q "live-one";     then ok "active mission collected";              else bad "active mission missed"; fi
if printf '%s\n' "$M6" | grep -q "paused-one";   then bad "paused mission leaked into the scan";  else ok "non-active mission excluded"; fi
if printf '%s\n' "$M6" | grep -q "archived-one"; then bad "ARCHIVE was scanned — closed missions can reappear"; else ok "archive/ never scanned"; fi
check "open threads carried, checked ones dropped" "1" "$(printf '%s\n' "$M6" | grep -c '^  - \[ \]')"

echo
echo "=== TEST 7 — sibling project repos are merged into both multi-repo scans ==="
# The failure this guards: the mission enumeration was written as an instruction and skipped in
# practice. A sibling repo's active mission must appear without the caller doing anything.
mkdir -p "$T/ws/projects"
SHARED=$T/ws/ai-resources; mkdir -p "$SHARED/logs"
( cd "$SHARED" && git init -q . && git config user.email t@t && git config user.name t \
  && echo s > s.txt && git add s.txt && git commit -qm "shared seed" ) >/dev/null 2>&1
SIB=$T/ws/projects/sibling; mkdir -p "$SIB/logs/missions"
( cd "$SIB" && git init -q . && git config user.email t@t && git config user.name t ) >/dev/null 2>&1
echo x > "$SIB/x.txt"; commit_at "$SIB" "2026-07-30T10:00:00" "sibling-repo commit"
printf 'mission_id: sib-mission\nmission_name: Owned by a sibling repo\nstatus: active\n\n## Open threads\n\n- [ ] sibling thread\n' > "$SIB/logs/missions/m.md"
R7=$(make_repo consumer)
printf '## 2026-07-30 — anchored\n\n### Next Steps\n- x\n' > "$R7/logs/session-notes.md"
C7=$(block "$R7" COMMITS "$SHARED")
if printf '%s\n' "$C7" | grep -q "sibling-repo commit"; then ok "COMMITS reaches sibling project repos"; else bad "COMMITS missed the sibling repo"; fi
M7=$(block "$R7" MISSIONS "$SHARED")
if printf '%s\n' "$M7" | grep -q "sib-mission"; then ok "MISSIONS reaches sibling project repos"; else bad "MISSIONS missed the sibling repo"; fi
if printf '%s\n' "$M7" | grep -q "sibling thread"; then ok "sibling open thread carried"; else bad "sibling open thread dropped"; fi

echo
echo "=== TEST 8 — telemetry gap fires on a real gap and stays quiet otherwise ==="
R8=$(make_repo telemetry)
cat > "$R8/logs/session-notes.md" <<'EOF'
## 2026-07-30 — a substantive session

### Summary
Real work happened here, across enough lines that this is clearly not an aborted entry.
More body.
More body.

### Next Steps
- something
EOF
printf '## 2026-07-28 — an older telemetry entry\n\nsome numbers\n' > "$R8/logs/usage-log.md"
check "gap fires when the date is missing"        "yes" "$(scalar "$R8" TELEMETRY_GAP)"
printf '## 2026-07-30 — telemetry for that session\n\nsome numbers\n' >> "$R8/logs/usage-log.md"
check "gap clears once the date appears"          "no"  "$(scalar "$R8" TELEMETRY_GAP)"
# A trivial entry legitimately has no telemetry — warning on it trains the operator to ignore the line.
printf '## 2026-07-31 — quick fix\n' > "$R8/logs/session-notes.md"
check "trivial entry raises no gap"               "no"  "$(scalar "$R8" TELEMETRY_GAP)"

echo
echo "=== TEST 9 — FOREIGN_SHARED gates on sibling headers, and NEVER on session-notes itself ==="
R9=$(make_repo foreign)
mkdir -p "$R9/.claude/commands" "$R9/docs"
TODAY=$(date '+%Y-%m-%d')
printf '## %s — session one\n\n### Summary\nx\n' "$TODAY" > "$R9/logs/session-notes.md"
echo "dirty" > "$R9/.claude/commands/some-command.md"
check "single same-day header → no advisory"      "no"  "$(has_block "$R9" FOREIGN_SHARED)"
printf '## %s — session two\n\n### Summary\ny\n' "$TODAY" >> "$R9/logs/session-notes.md"
check "two same-day headers + dirty shared file → advisory" "yes" "$(has_block "$R9" FOREIGN_SHARED)"
F9=$(block "$R9" FOREIGN_SHARED)
if printf '%s\n' "$F9" | grep -q "some-command.md"; then ok "advisory names the dirty shared file"; else bad "advisory did not name the file"; fi
if printf '%s\n' "$F9" | grep -q "session-notes.md"; then bad "session-notes.md leaked into the pathspec — append-only, fires every session"; else ok "session-notes.md excluded from the pathspec"; fi

echo
echo "=== TEST 10 — no marker-file scan exists in this script (F-HOOK, mechanism half) ==="
# F-HOOK tests the MECHANISM, not the output: consumption of the hook's message and a rescan produce
# the same advisory, so only inspecting the source can tell them apart. A future edit that adds a
# marker glob here re-implements the hook's job with strictly worse information.
if grep -qE '\.session-marker' "$SRC"; then bad "prime-collect.sh reads session markers — F-HOOK falsified"
else ok "no session-marker read anywhere in the script"; fi
R10=$(make_repo markers)
touch "$R10/logs/.session-marker-aaaa" "$R10/logs/.session-marker-bbbb"
if run "$R10" | grep -q 'session-marker'; then bad "marker files appear in the output"; else ok "marker files ignored even when present"; fi

echo
echo "=== TEST 11 — a path containing spaces, and a non-repo directory ==="
mkdir -p "$T/with space/logs"
printf '## 2026-07-30 — spaced\n\n### Next Steps\n- a step\n' > "$T/with space/logs/session-notes.md"
( cd "$T/with space" && git init -q . && git config user.email t@t && git config user.name t ) >/dev/null 2>&1
check "space in path: CWD_REPO resolves"          "yes" "$( [ -n "$(scalar "$T/with space" CWD_REPO)" ] && echo yes || echo no )"
check "space in path: NEXT_STEPS still collected" "1"   "$(block "$T/with space" NEXT_STEPS | grep -c '^- ')"
mkdir -p "$T/notarepo/logs"
printf '## 2026-07-30 — outside git\n\n### Next Steps\n- a step\n' > "$T/notarepo/logs/session-notes.md"
check "non-repo reports CWD_REPO: (none)"         "(none)" "$(scalar "$T/notarepo" CWD_REPO)"
check "non-repo still collects file-based state"  "1"   "$(block "$T/notarepo" NEXT_STEPS | grep -c '^- ')"
check "non-repo exits 0"                          "0"   "$( ( cd "$T/notarepo" && bash "$SRC" "$NOREPO" >/dev/null 2>&1; echo $? ) )"

echo
echo "=== TEST 12 — next-up carries the promote id through verbatim ==="
# Without the id, /prime cannot tell a promoted severity-tagged finding from an ordinary queue item,
# and a promoted `high` finding ranks below plain carryover.
R12=$(make_repo nextup)
printf '# Next Up\n\n- [ ] an ordinary item\n- [ ] a promoted finding <!-- promote:abc123 -->\n- [x] a done item\n' > "$R12/logs/next-up.md"
N12=$(block "$R12" NEXT_UP)
check "unchecked items only"                      "2"   "$(printf '%s\n' "$N12" | grep -c '^- \[ \]')"
if printf '%s\n' "$N12" | grep -q 'promote:abc123'; then ok "promote id survives collection"; else bad "promote id stripped — the urgent tier is lost"; fi

echo
echo "=== TEST 13 — the commit scan is bounded, and says so ==="
# Regression guard for the 2,816-line orientation dump measured on 2026-07-30. Both bounds must be
# VISIBLE in the output: a silently truncated set reads as "nothing resolved this Next Step".
R13=$(make_repo bounded)
printf '## 2020-01-01 — a very old wrap\n\n### Next Steps\n- something\n' > "$R13/logs/session-notes.md"
for i in $(seq 1 450); do echo "$i" > "$R13/f.txt"; commit_at "$R13" "$(date '+%Y-%m-%d')T12:00:00" "commit number $i"; done
C13=$(block "$R13" COMMITS)
check "window line is present"                    "1"   "$(printf '%s\n' "$C13" | grep -c '^window: since ')"
if printf '%s\n' "$C13" | grep -q 'floored at 30 days'; then ok "an ancient entry date is floored, and the floor is disclosed"
else bad "no floor applied to a 2020 entry date"; fi
check "truncation is announced"                   "1"   "$(printf '%s\n' "$C13" | grep -c '^truncated: ')"
BODY13=$(printf '%s\n' "$C13" | grep -cE '^[0-9a-f]{7,} ')
if [ "$BODY13" -le 400 ]; then ok "commit lines capped at 400 (got $BODY13)"; else bad "cap not applied — got $BODY13 commit lines"; fi
# A recent entry date must NOT be floored: the floor is a ceiling on cost, never a narrowing of a
# window that was already tight.
printf '## %s — a recent wrap\n\n### Next Steps\n- something\n' "$(date '+%Y-%m-%d')" > "$R13/logs/session-notes.md"
if block "$R13" COMMITS | grep -q 'floored at 30 days'; then bad "a same-day entry date was floored"; else ok "a recent entry date is left alone"; fi

echo
printf '\n=== %d passed, %d failed ===\n' "$PASS" "$FAIL"
rm -rf "$T"
[ "$FAIL" -eq 0 ]
