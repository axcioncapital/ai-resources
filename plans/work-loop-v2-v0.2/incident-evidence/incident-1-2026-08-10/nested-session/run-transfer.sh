#!/bin/bash
# Case 4 remainder: exercise `transferred` where another owner GENUINELY applies.
# The fault is a pending improvement-log entry awaiting the Friday cadence.
# /friday-act owns pending entries; /resolve-incident must not execute one itself.
S="/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources-diagnostics-workflow/053f3b80-6b6e-4b84-9252-0ac7b4b71d12/scratchpad"
FX="$S/fx"; RUNS="$S/runs"
SRC="/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-diagnostics-workflow"

rm -rf "$FX/C4t"; cp -R "$FX/A" "$FX/C4t"
R="$FX/C4t"

# Make the owning lifecycle REAL and inspectable inside the fixture.
cp "$SRC/.claude/commands/friday-act.md" "$R/.claude/commands/" 2>/dev/null
cp "$SRC/.claude/commands/friday-checkup.md" "$R/.claude/commands/" 2>/dev/null

# A pending entry that the Friday cadence owns and has not yet actioned.
cat >> "$R/logs/improvement-log.md" <<'EOF'

### 2026-08-01 — entry-count.sh should read its threshold from the log header

- **Status:** logged (pending)
- **Category:** session-issue
- **Severity:** medium
- **Source:** /resolve-repo-problem 2026-08-01
- **Friction source:** The archival threshold (30) is hardcoded in the checker while the log header states it in prose; the two can drift apart silently.
- **Proposal:** Parse the threshold from the `Archive at the quarterly /friday-checkup tier once >=30 entries exist` line in logs/incident-log.md instead of hardcoding it in logs/scripts/entry-count.sh.
- **Target files:** logs/scripts/entry-count.sh, logs/incident-log.md
- **Notes:** audits/working/2026-08-01-resolve-threshold-drift.md
EOF

git -C "$R" add -A >/dev/null 2>&1
git -C "$R" -c user.email=f@f -c user.name=f commit -qm seed-pending >/dev/null 2>&1

echo "-- fixture owner present:"; ls -1 "$R/.claude/commands/" | grep friday || echo "(friday commands NOT copied)"
echo "-- pending entry present:"; grep -c 'logged (pending)' "$R/logs/improvement-log.md"

cd "$R" && claude -p '/resolve-incident "the improvement-log entry from 2026-08-01 about the hardcoded archival threshold in entry-count.sh is still sitting unactioned as logged (pending) — the proposed fix was never applied"' \
  --permission-mode bypassPermissions > "$RUNS/C4t.out" 2> "$RUNS/C4t.err"
echo "exit=$?"
