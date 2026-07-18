#!/usr/bin/env bash
# Level 1 + Level 2 verification suite for run-manifest.sh (spine-schemas.md §4 floor
# for executable surfaces: mechanical + functional are BOTH mandatory).
cd "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources" || exit 9
S="logs/scripts/run-manifest.sh"
T=$(mktemp -d)
PASS=0; FAIL=0

ck() { # want_exit got_exit label
  if [ "$1" = "$2" ]; then echo "  PASS  $3"; PASS=$((PASS+1))
  else echo "  FAIL  $3  (want exit $1, got $2)"; FAIL=$((FAIL+1)); fi
}
ckv() { # want got label
  if [ "$1" = "$2" ]; then echo "  PASS  $3"; PASS=$((PASS+1))
  else echo "  FAIL  $3  (want '$1', got '$2')"; FAIL=$((FAIL+1)); fi
}
J="$T/2099-01-01-T1.json"

echo "=== LEVEL 1 — mechanical ==="
bash -n "$S"; ck 0 $? "bash -n parses clean"

echo
echo "=== LEVEL 2 — functional: happy path ==="
bash "$S" start  --date 2099-01-01 --marker T1 --runs-dir "$T" --model opus --mission testmission >/dev/null 2>&1
ck 0 $? "start writes the start-stub"
bash "$S" start  --date 2099-01-01 --marker T1 --runs-dir "$T" --model haiku >/dev/null 2>&1
ck 0 $? "start is idempotent (re-invocation safe)"
ckv "opus" "$(python3 -c "import json;print(json.load(open('$J'))['model'])")" "idempotent start did NOT clobber existing state"

bash "$S" update --date 2099-01-01 --marker T1 --runs-dir "$T" --file a.md --file b.md --file a.md >/dev/null 2>&1
ck 0 $? "update appends files_changed"
bash "$S" update --date 2099-01-01 --marker T1 --runs-dir "$T" --file c.md --validation "run-manifest.sh|functional" >/dev/null 2>&1
ck 0 $? "update again (files_changed is RUNNING, not wrap-only)"
ckv "3" "$(python3 -c "import json;print(len(json.load(open('$J'))['files_changed']))")" "files_changed deduped: a,b,a,c -> 3"

bash "$S" close  --date 2099-01-01 --marker T1 --runs-dir "$T" --outcome DELIVERED >/dev/null 2>&1
ck 0 $? "close finalizes + validates"
ckv "DELIVERED" "$(python3 -c "import json;print(json.load(open('$J'))['outcome'])")" "close recorded outcome"

echo
echo "=== THE ADVISORY RULE — an ABSENT manifest must NEVER block a wrap ==="
bash "$S" validate --date 2099-12-31 --marker ZZ --runs-dir "$T" >/dev/null 2>&1
ck 0 $? "validate on ABSENT manifest -> exit 0 (advisory, not a failure)"
bash "$S" close    --date 2099-12-31 --marker ZZ --runs-dir "$T" >/dev/null 2>&1
ck 0 $? "close on ABSENT manifest -> wrap-time stub, no block"
[ -f "$T/2099-12-31-ZZ.json" ]
ck 0 $? "  ...and the wrap-time stub was actually written"

echo
echo "=== NEGATIVE TESTS — present + malformed MUST abort loudly (never a silent pass) ==="
printf '{ not json' > "$T/2099-02-02-B1.json"
bash "$S" validate --date 2099-02-02 --marker B1 --runs-dir "$T" >/dev/null 2>&1
ck 1 $? "unparseable JSON -> loud abort"

printf '{"run_id":"x","date":"d","marker":"m"}' > "$T/2099-02-02-B2.json"
bash "$S" validate --date 2099-02-02 --marker B2 --runs-dir "$T" >/dev/null 2>&1
ck 1 $? "missing required fields -> loud abort"

python3 -c "
import json
m = json.load(open('$J')); m['failure_class'] = 'not-a-real-class'
json.dump(m, open('$T/2099-03-03-B3.json','w'))"
bash "$S" validate --date 2099-03-03 --marker B3 --runs-dir "$T" >/dev/null 2>&1
ck 1 $? "failure_class outside the closed 11-value set -> loud abort"

python3 -c "
import json
m = json.load(open('$J')); m['outcome'] = 'SORTA'
json.dump(m, open('$T/2099-05-05-B5.json','w'))"
bash "$S" validate --date 2099-05-05 --marker B5 --runs-dir "$T" >/dev/null 2>&1
ck 1 $? "outcome outside its enum -> loud abort"

python3 -c "
import json
m = json.load(open('$J')); m['validation'] = [{'output':'x','level_reached':'vibes'}]
json.dump(m, open('$T/2099-06-06-B6.json','w'))"
bash "$S" validate --date 2099-06-06 --marker B6 --runs-dir "$T" >/dev/null 2>&1
ck 1 $? "validation level outside the 5 levels -> loud abort"

# spine-schemas.md §2: failure_class != null forces a defect entry OR an explicit waiver.
python3 -c "
import json
m = json.load(open('$J')); m['failure_class'] = 'tool-misuse'; m['incidents_refs'] = []
json.dump(m, open('$T/2099-04-04-B4.json','w'))"
bash "$S" validate --date 2099-04-04 --marker B4 --runs-dir "$T" >/dev/null 2>&1
ck 1 $? "failure_class set with no defect entry and no waiver -> loud abort (spine §2 trigger)"

# ...and the waiver escape hatch must actually work.
python3 -c "
import json
m = json.load(open('$J')); m['failure_class'] = 'tool-misuse'; m['incident_waived'] = 'known flake'
json.dump(m, open('$T/2099-04-05-B7.json','w'))"
bash "$S" validate --date 2099-04-05 --marker B7 --runs-dir "$T" >/dev/null 2>&1
ck 0 $? "failure_class WITH an explicit waiver -> passes (escape hatch works)"

echo
echo "--- sample loud-abort output (this is what a real mismatch looks like) ---"
bash "$S" validate --date 2099-04-04 --marker B4 --runs-dir "$T" 2>&1 | sed 's/^/  /'

echo
echo "=== SELF-RESOLVING MARKER (QC fix #2 — callers cannot pass shell vars) ==="
# The slash-commands run each Bash call in a FRESH shell, so "${MARKER}" would expand EMPTY.
# The script must therefore resolve date+marker itself from the marker oracle.
L="$T/logs"; mkdir -p "$L/runs"
# CLAUDE_CODE_SESSION_ID must be explicitly unset here. Resolving a marker from the SHARED file is
# legitimate ONLY when there is no session id to attribute against (an older CLI) — with an id
# present, the identity guard below refuses it, because a session that wrote no per-id marker
# cannot claim the shared one. Until 2026-07-18 this test left the variable at whatever the
# ambient environment held, so it exercised the old-CLI path or the new one depending on WHERE it
# was run, and passed either way only because the pre-guard code waved suffix-less markers through.
# Pinning it makes the path under test explicit rather than ambient.
_SAVED_SID="${CLAUDE_CODE_SESSION_ID:-}"; unset CLAUDE_CODE_SESSION_ID
printf '%s S9\n' "$(date '+%Y-%m-%d')" > "$L/.session-marker"
bash "$S" start --runs-dir "$L/runs" --model testmodel >/dev/null 2>&1
ck 0 $? "start with NO --date/--marker resolves from the shared marker file (no session id)"
[ -f "$L/runs/$(date '+%Y-%m-%d')-S9.json" ]
ck 0 $? "  ...and wrote the manifest at the self-resolved {today}-S9 path"
[ -n "$_SAVED_SID" ] && export CLAUDE_CODE_SESSION_ID="$_SAVED_SID"

# A STALE (prior-day) marker must NOT be trusted — it would write into another session's manifest.
printf '2020-01-01 S3\n' > "$L/.session-marker"
rm -f "$L/runs/$(date '+%Y-%m-%d')-S3.json"
bash "$S" start --runs-dir "$L/runs" --model testmodel >/dev/null 2>&1
ck 2 $? "stale prior-day marker is REFUSED (exit 2), not silently trusted"

# Per-session-id marker takes precedence over the shared file.
printf '%s S9\n' "$(date '+%Y-%m-%d')" > "$L/.session-marker"
export CLAUDE_CODE_SESSION_ID="qc-test-id"
printf '%s S7\n' "$(date '+%Y-%m-%d')" > "$L/.session-marker-qc-test-id"
bash "$S" start --runs-dir "$L/runs" --model testmodel >/dev/null 2>&1
[ -f "$L/runs/$(date '+%Y-%m-%d')-S7.json" ]
ck 0 $? "per-session-id marker wins over the shared marker file"
unset CLAUDE_CODE_SESSION_ID

echo
echo "=== SESSION-IDENTITY CROSS-CHECK (2026-07-18): the shared marker can name ANOTHER session ==="
# THE INCIDENT (logs/improvement-log.md 2026-07-18, session S4-8c3): /prime allocates the marker at
# its Step 8, which a /clarify-first session never reaches. The shared marker then still holds the
# PREVIOUS session's value — same date, so the today-check above does NOT catch it — and `close`
# would OVERWRITE that session's manifest silently.
#
# THE PROPERTY UNDER TEST IS "NOTHING WAS WRITTEN", NOT AN EXIT CODE. The guard warns and skips,
# exiting 0: declining the write achieves the entire safety goal, and an absent manifest is a
# routine supported state per THE ADVISORY RULE in run-manifest.sh, whereas a non-zero exit would
# invite a caller to treat a legitimate state as a fault. So every case below asserts exit 0 AND
# asserts the absence (or byte-identity) of the manifest — the exit code alone would prove nothing.
TD="$(date '+%Y-%m-%d')"
export CLAUDE_CODE_SESSION_ID="abc99999-0000-1111-2222-333344445555"   # id starts 'abc'

# 1. The incident itself: shared marker belongs to session "919", we are "abc".
printf '%s S3-919\n' "$TD" > "$L/.session-marker"
rm -f "$L/.session-marker-$CLAUDE_CODE_SESSION_ID"
bash "$S" start --runs-dir "$L/runs" --model testmodel >/dev/null 2>&1
ck 0 $? "unattributable marker exits 0 (advisory — never blocks a wrap)"
[ ! -f "$L/runs/$TD-S3-919.json" ]
ck 0 $? "  ...but NO manifest was written under the other session's name"

# 2. The data-loss path proper: close must not overwrite an EXISTING foreign manifest.
printf '{"run_id":"victim","outcome":null}\n' > "$L/runs/$TD-S3-919.json"
cp "$L/runs/$TD-S3-919.json" "$L/victim.orig"
bash "$S" close --runs-dir "$L/runs" --outcome DELIVERED --stop-reason completed >/dev/null 2>&1
ck 0 $? "close against a foreign manifest exits 0 (advisory)"
cmp -s "$L/runs/$TD-S3-919.json" "$L/victim.orig"
ck 0 $? "  ...and the foreign manifest is byte-identical (the overwrite did NOT happen)"
rm -f "$L/runs/$TD-S3-919.json" "$L/victim.orig"

# 3. THE COLLISION REGRESSION — the case the FIRST version of the guard got wrong.
# That version compared the marker's 3-char id suffix to this session's first 3 alphanumerics. Two
# different sessions sharing a 3-char id prefix produce the SAME suffix, so the guard accepted a
# foreign marker and wrote its manifest — the silent-overwrite path survived the fix meant to close
# it. The guard now tests PRESENCE of this session's own per-id marker, never string equality, so a
# same-prefix collision is declined like any other unattributable marker.
printf '%s S3-abc\n' "$TD" > "$L/.session-marker"     # same 'abc' prefix, DIFFERENT session
rm -f "$L/.session-marker-$CLAUDE_CODE_SESSION_ID"
bash "$S" start --runs-dir "$L/runs" --model testmodel >/dev/null 2>&1
ck 0 $? "SAME 3-char id prefix from a DIFFERENT session — exits 0 (collision regression)"
[ ! -f "$L/runs/$TD-S3-abc.json" ]
ck 0 $? "  ...and NO manifest was written under the colliding marker"

# 4. A shared marker is unattributable even when it looks like ours — presence, not resemblance.
printf '%s S8-abc\n' "$TD" > "$L/.session-marker"
bash "$S" start --runs-dir "$L/runs" --model testmodel >/dev/null 2>&1
[ ! -f "$L/runs/$TD-S8-abc.json" ]
ck 0 $? "shared marker writes NOTHING even when its suffix matches (resemblance is not proof)"

# 5. The per-id marker is what makes a marker attributable — with it present, the same run writes.
printf '%s S8-abc\n' "$TD" > "$L/.session-marker-$CLAUDE_CODE_SESSION_ID"
bash "$S" start --runs-dir "$L/runs" --model testmodel >/dev/null 2>&1
[ -f "$L/runs/$TD-S8-abc.json" ]
ck 0 $? "  ...and the SAME marker DOES write once this session's per-id marker exists"
rm -f "$L/.session-marker-$CLAUDE_CODE_SESSION_ID"

printf '%s S9\n' "$TD" > "$L/.session-marker"
# Clear first: the old-CLI self-resolution test above legitimately wrote {today}-S9.json to this
# same path, so without the rm this assertion would find THAT file and report a failure the guard
# did not cause. An absence assertion is only meaningful against a known-clean path.
rm -f "$L/runs/$TD-S9.json"
bash "$S" start --runs-dir "$L/runs" --model testmodel >/dev/null 2>&1
[ ! -f "$L/runs/$TD-S9.json" ]
ck 0 $? "suffix-less LEGACY marker writes nothing either (no id encoded -> nothing to attribute)"

printf '%s S3-919\n' "$TD" > "$L/.session-marker"
bash "$S" start --runs-dir "$L/runs" --marker "S11-abc" --model testmodel >/dev/null 2>&1
ck 0 $? "an explicit --marker overrides a mismatched shared file"

unset CLAUDE_CODE_SESSION_ID
printf '%s S3-919\n' "$TD" > "$L/.session-marker"
bash "$S" start --runs-dir "$L/runs" --model testmodel >/dev/null 2>&1
ck 0 $? "no CLAUDE_CODE_SESSION_ID (old CLI) -> check skipped silently, not a hard fail"

echo
echo "--- sample unattributable-marker NOTICE (what the operator actually sees; exits 0) ---"
export CLAUDE_CODE_SESSION_ID="abc99999-0000-1111-2222-333344445555"
printf '%s S3-919\n' "$TD" > "$L/.session-marker"
bash "$S" start --runs-dir "$L/runs" --model testmodel 2>&1 | sed 's/^/  /'
unset CLAUDE_CODE_SESSION_ID

echo
echo "=== close does not depend on the execute bit (QC fix #3) ==="
chmod -x "$S" 2>/dev/null
bash "$S" close --date 2099-01-01 --marker T1 --runs-dir "$T" --outcome DELIVERED >/dev/null 2>&1
ck 0 $? "close works with the execute bit REMOVED (exec bash \"$0\", not exec \"$0\")"
chmod +x "$S" 2>/dev/null

echo
echo "=== --decision-ref-from-header (S5): slug derived in code, never by hand ==="

# The point of the flag: pass a header VERBATIM, get the right slug, no hand-derivation.
# Long header (>60 chars) exercises the truncate + trim-back-to-word-boundary path.
LONGHDR='## 2026-07-12 (S5) — R3 Pass 2 has a SECOND prerequisite, and it is still open'
bash "$S" start --date 2099-02-02 --marker D1 --runs-dir "$T" --model testmodel >/dev/null 2>&1
bash "$S" update --date 2099-02-02 --marker D1 --runs-dir "$T" \
  --decision-ref-from-header "$LONGHDR" >/dev/null 2>&1
ckv "logs/decisions.md#2026-07-12-s5-r3-pass-2-has-a-second-prerequisite-and-it-is" \
    "$(python3 -c "import json;print(''.join(json.load(open('$T/2099-02-02-D1.json'))['decisions_refs']))" 2>/dev/null)" \
    "--decision-ref-from-header derives the slug IN CODE (long header, trim-back path)"

# De-dup: the same decision passed twice must not double-write.
bash "$S" update --date 2099-02-02 --marker D1 --runs-dir "$T" \
  --decision-ref-from-header "$LONGHDR" >/dev/null 2>&1
ckv "1" "$(python3 -c "import json;print(len(json.load(open('$T/2099-02-02-D1.json'))['decisions_refs']))" 2>/dev/null)" \
    "the same decision ref is de-duplicated, not appended twice"

# ADVISORY RULE: an underivable header drops ONE ref and still exits 0 — never fails the wrap.
bash "$S" update --date 2099-02-02 --marker D1 --runs-dir "$T" --decision-ref-from-header "###" >/dev/null 2>&1
ck 0 $? "an underivable header DROPS the ref and exits 0 (advisory, never blocks a wrap)"

# A decision-free session must close with decisions_refs EMPTY — emptiness is the payload
# signal R3 Pass 2's reopen gate is measured on; a placeholder would silently satisfy it (S4).
bash "$S" start --date 2099-02-03 --marker D2 --runs-dir "$T" --model testmodel >/dev/null 2>&1
bash "$S" close --date 2099-02-03 --marker D2 --runs-dir "$T" --outcome DELIVERED >/dev/null 2>&1
ckv "0" "$(python3 -c "import json;print(len(json.load(open('$T/2099-02-03-D2.json'))['decisions_refs']))" 2>/dev/null)" \
    "a decision-free session closes with decisions_refs EMPTY (no placeholder ref)"

# SYMLINK INVOCATION — the end-time /risk-check REPRODUCED a silent ref-drop here:
# `dirname "$0"` yields the SYMLINK's dir, so the sibling decision_ref_slug.py was missed
# and the ref vanished with only an advisory line. Regression-guard the self-location fix.
SYMDIR="$T/symlink-probe"; mkdir -p "$SYMDIR"
ln -sf "$(cd -P "$(dirname "$S")" && pwd)/$(basename "$S")" "$SYMDIR/run-manifest.sh"
bash "$S" start --date 2099-02-04 --marker D3 --runs-dir "$T" --model testmodel >/dev/null 2>&1
bash "$SYMDIR/run-manifest.sh" update --date 2099-02-04 --marker D3 --runs-dir "$T" \
  --decision-ref-from-header "$LONGHDR" >/dev/null 2>&1
ckv "1" "$(python3 -c "import json;print(len(json.load(open('$T/2099-02-04-D3.json'))['decisions_refs']))" 2>/dev/null)" \
    "invoked THROUGH A SYMLINK, the slug module still resolves (ref not silently dropped)"

echo
echo "=== decision_ref_slug.py — the single slug definition ==="
python3 logs/scripts/decision_ref_slug.py --self-test >/dev/null 2>&1
ck 0 $? "decision_ref_slug.py self-test passes (collision proof + negative control)"

echo
echo "=== check-decision-refs.sh — validator degrades, never blocks ==="
bash -n logs/scripts/check-decision-refs.sh; ck 0 $? "check-decision-refs.sh parses clean"
bash logs/scripts/check-decision-refs.sh "$T/2099-02-03-D2.json" >/dev/null 2>&1
ck 0 $? "empty decisions_refs -> exit 0 (a decision-free session is not a failure)"
bash logs/scripts/check-decision-refs.sh "$T/does-not-exist.json" >/dev/null 2>&1
ck 0 $? "absent manifest -> exit 0 (advisory, never blocks)"
printf 'not json' > "$T/broken.json"
bash logs/scripts/check-decision-refs.sh "$T/broken.json" >/dev/null 2>&1
ck 0 $? "unreadable/corrupt manifest -> exit 0 (advisory, never blocks)"
python3 - "$T/orphan.json" <<'PYX'
import json,sys
json.dump({"decisions_refs":["logs/decisions.md#no-such-anchor-anywhere"]}, open(sys.argv[1],"w"))
PYX
bash logs/scripts/check-decision-refs.sh "$T/orphan.json" >/dev/null 2>&1
ck 1 $? "an ORPHAN ref exits 1 — the check is falsifiable, not decorative"

echo
echo "RESULT: $PASS passed, $FAIL failed"
rm -rf "$T"
[ "$FAIL" -eq 0 ]
