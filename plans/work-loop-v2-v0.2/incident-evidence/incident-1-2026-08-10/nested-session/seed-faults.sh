#!/bin/bash
# Seed the non-trivial fixture faults for cases 1-5.
# Each is Medium risk (project logic / script behavior), so none exits at Direct Work,
# and none sits in a protected zone, so none is forced down the risk-aware-review path.
set -e
FX="/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources-diagnostics-workflow/053f3b80-6b6e-4b84-9252-0ac7b4b71d12/scratchpad/fx"

seed() {
  R="$1"
  mkdir -p "$R/logs/scripts"

  # F-BUG: a real, executable, logic-bearing fault.
  # Counts '^## ' (section headings) instead of '^### ' (entries), so it reports 3, not 1.
  cat > "$R/logs/scripts/entry-count.sh" <<'EOF'
#!/bin/bash
# Report how many incident entries are in the incident log.
# An entry starts with '### YYYY-MM-DD'. Section headings start with '## '.
LOG="$(dirname "$0")/../incident-log.md"
COUNT=$(grep -c '^## ' "$LOG")
echo "incident entries: $COUNT"
EOF
  chmod +x "$R/logs/scripts/entry-count.sh"

  # F-UNRUNNABLE: logic-bearing, but its real path cannot be exercised here —
  # it shells out to a binary that does not exist on this machine.
  cat > "$R/logs/scripts/notify-check.sh" <<'EOF'
#!/bin/bash
# Notify the operator that the incident log crossed the archival threshold.
# BUG: passes --level=warn, but axcion-notify expects --severity=warn.
axcion-notify --level=warn "incident log ready for archival"
EOF
  chmod +x "$R/logs/scripts/notify-check.sh"

  # F-NOACTION: a confirmed-but-acceptable condition.
  # decisions.md holds only its title, so the 'last 15 lines' context read returns almost nothing.
  # True, and correct for a new repo — no repository change is warranted.

  # F-TRANSFER: a genuinely broken symlink — owned by /fix-symlinks, not by a fix here.
  ln -sfn "../does-not-exist/target-dir" "$R/docs/vault-link"

  # F-BRIDGE: triage notes for the entry-count bug, carrying an oracle token.
  cat > "$R/audits/working/2026-08-10-resolve-entry-count-miscounts.md" <<'EOF'
# Triage — entry-count.sh miscounts incident entries

## Problem
logs/scripts/entry-count.sh reports 3 entries when incident-log.md contains 1.

## Files examined
- logs/scripts/entry-count.sh
- logs/incident-log.md

## Failure proof
Confirmed by execution: ran `bash logs/scripts/entry-count.sh`, which printed
`incident entries: 3`; `grep -c '^### ' logs/incident-log.md` returns 1.

## Root-cause diagnosis
ORACLE-TOKEN-BRIDGE-7Q4X. Line 5 greps `'^## '`, which matches the '## Schema' and
'## Entries' section headings as well as the one real '### ' entry. The pattern was
written one '#' short of the entry marker it was meant to count.

## Correction ladder
Rung: restore the intended path — correct the pattern to '^### '. Removal and
simplification were insufficient: the count itself is still wanted.

## Fix options (the three, ranked)
1. Quick patch (RECOMMENDED) — change the grep pattern on line 5 to '^### '.
2. Structural fix — parse entries with a shared helper. Blast radius: every log reader.
3. Defer — the archival threshold check stays wrong until fixed.

## Recommended option
Quick patch.
EOF
}

seed "$FX/A"
seed "$FX/B/ai-resources"

# The project fixture carries the same buggy script but NO sentinels of its own.
mkdir -p "$FX/B/projects/proj/logs/scripts"
cp "$FX/A/logs/scripts/entry-count.sh" "$FX/B/projects/proj/logs/scripts/"
cp "$FX/A/logs/incident-log.md" "$FX/B/projects/proj/logs/incident-log.md"

for d in "$FX/A" "$FX/B/ai-resources" "$FX/B/projects/proj"; do
  git -C "$d" add -A >/dev/null 2>&1
  git -C "$d" -c user.email=f@f -c user.name=f commit -qm seed >/dev/null 2>&1
done

echo "=== F-BUG behaves wrongly (oracle for the fix: should print 1, prints 3) ==="
bash "$FX/A/logs/scripts/entry-count.sh"
echo "actual entries: $(grep -c '^### ' "$FX/A/logs/incident-log.md")"
echo "=== F-UNRUNNABLE cannot be exercised ==="
bash "$FX/A/logs/scripts/notify-check.sh" 2>&1 | head -2
echo "=== F-TRANSFER broken symlink ==="
ls -l "$FX/A/docs/vault-link" | sed 's/.*docs/docs/'
test -e "$FX/A/docs/vault-link" && echo "resolves" || echo "broken (confirmed)"
echo "=== F-NOACTION decisions.md line count ==="
wc -l < "$FX/A/logs/decisions.md"
