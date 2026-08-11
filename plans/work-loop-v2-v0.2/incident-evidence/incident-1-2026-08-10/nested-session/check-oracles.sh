#!/bin/bash
# Check each case's oracle against the fixture filesystem after the runs.
S="/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources-diagnostics-workflow/053f3b80-6b6e-4b84-9252-0ac7b4b71d12/scratchpad"
FX="$S/fx"
MAIN="/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-diagnostics-workflow"

report() {
  D="$1"; L="$2"
  echo "### $L  ($D)"
  echo "-- incident records:"
  find "$D/audits/incidents" -name '*.md' 2>/dev/null | sed "s|$D/||" || true
  echo "-- record status line:"
  grep -h '^status:' "$D"/audits/incidents/*.md 2>/dev/null || echo "(none)"
  echo "-- incident-log Status entries appended:"
  git -C "$D" diff -- logs/incident-log.md 2>/dev/null | grep '^+.*\*\*Status:\*\*' || echo "(none)"
  echo "-- improvement-log appended?"
  if git -C "$D" diff --quiet -- logs/improvement-log.md 2>/dev/null; then echo "NO (clean)"; else echo "YES"; git -C "$D" diff --stat -- logs/improvement-log.md; fi
  echo "-- files changed:"
  git -C "$D" status --porcelain 2>/dev/null | grep -v '^?? audits/incidents/' || true
  echo
}

echo "=========== C1: checkout selection (ai-resources-shaped copy) ==========="
report "$FX/C1" "C1"
echo "-- ORACLE: did the buggy script get fixed and does it now print 4?"
bash "$FX/C1/logs/scripts/entry-count.sh" 2>&1

echo
echo "=========== C1n: negative control — invoked from projects/proj ==========="
echo "-- records under the PROJECT root (oracle: none):"
find "$FX/Bn/projects/proj/audits/incidents" -name '*.md' 2>/dev/null | wc -l
echo "-- records under the workspace ai-resources (oracle: 1):"
find "$FX/Bn/ai-resources/audits/incidents" -name '*.md' 2>/dev/null | wc -l
echo "-- incident-log appended in ai-resources?"
git -C "$FX/Bn/ai-resources" diff -- logs/incident-log.md | grep '^+.*\*\*Status:\*\*' || echo "(none)"
echo "-- incident-log appended in proj? (oracle: none)"
git -C "$FX/Bn/projects/proj" diff -- logs/incident-log.md | grep '^+.*\*\*Status:\*\*' || echo "(none)"

echo
echo "=========== CROSS-CUTTING: did ANY run write into the real main checkout? ==========="
git -C "$MAIN" status --porcelain
echo "-- untracked incident records in the real checkout (oracle: none):"
find "$MAIN/audits/incidents" -name '2026-08-10-*' 2>/dev/null | wc -l

echo
echo "=========== C2: triage bridge ==========="
report "$FX/C2" "C2"
echo "-- ORACLE: does the record cite the notes path or its token?"
grep -rl 'ORACLE-TOKEN-BRIDGE-7Q4X\|2026-08-10-resolve-entry-count-miscounts' "$FX/C2/audits/incidents/" 2>/dev/null || echo "NOT CITED in record"
grep -c 'ORACLE-TOKEN-BRIDGE-7Q4X\|resolve-entry-count-miscounts' "$S/runs/C2.out"

echo
echo "=========== C3: false premise ==========="
report "$FX/C3" "C3"
echo "-- ORACLE: healthy-doc.md untouched?"
git -C "$FX/C3" diff --stat -- docs/healthy-doc.md; echo "(empty = untouched)"

echo
echo "=========== C4a: no action justified ==========="
report "$FX/C4a" "C4a"
echo
echo "=========== C4b: transferred ==========="
report "$FX/C4b" "C4b"
echo "-- ORACLE: is the symlink still broken (no fix applied here)?"
test -e "$FX/C4b/docs/vault-link" && echo "RESOLVES (fix was applied - oracle FAILED)" || echo "still broken (correct)"

echo
echo "=========== C5: verification floor ==========="
report "$FX/C5" "C5"

echo
echo "=========== C6n: /resolve-repo-problem on a non-small fault ==========="
echo "-- notes file written (oracle: 1):"
ls -1 "$FX/C6n/audits/working/" | grep -v 'entry-count-miscounts\|fixture-guide' | wc -l
echo "-- improvement-log appended? (oracle: YES - confirmed + actionable)"
git -C "$FX/C6n" diff --stat -- logs/improvement-log.md; echo "(empty = not appended)"
echo "-- any fix applied? (oracle: none - triage only)"
git -C "$FX/C6n" status --porcelain | grep -v '^?? audits/' || echo "(no source change)"
