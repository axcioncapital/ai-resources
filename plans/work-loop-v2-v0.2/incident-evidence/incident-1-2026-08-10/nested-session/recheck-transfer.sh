#!/bin/bash
# Re-run the transfer case after restoring the two valid example owners.
S="/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources-diagnostics-workflow/053f3b80-6b6e-4b84-9252-0ac7b4b71d12/scratchpad"
FX="$S/fx"; RUNS="$S/runs"
SRC="/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-diagnostics-workflow"

cp "$SRC/.claude/commands/resolve-incident.md" "$FX/A/.claude/commands/"
cp "$SRC/.claude/commands/resolve-repo-problem.md" "$FX/A/.claude/commands/"
git -C "$FX/A" add -A >/dev/null 2>&1
git -C "$FX/A" -c user.email=f@f -c user.name=f commit -qm recorrected >/dev/null 2>&1

rm -rf "$FX/X4t2"; cp -R "$FX/A" "$FX/X4t2"
cd "$FX/X4t2" && claude -p '/resolve-incident "the improvement-log entry from 2026-08-01 about the hardcoded archival threshold in entry-count.sh is still sitting unactioned as logged (pending) — the proposed fix was never applied"' \
  --permission-mode bypassPermissions > "$RUNS/X4t2.out" 2> "$RUNS/X4t2.err"
echo "exit=$?"
echo "-- status --"; grep -h '^status:' "$FX/X4t2"/audits/incidents/*.md 2>/dev/null || echo "NO RECORD"
echo "-- improvement-log untouched? --"; git -C "$FX/X4t2" diff --stat -- logs/improvement-log.md; echo "(empty=untouched)"
echo "-- files changed --"; git -C "$FX/X4t2" status --porcelain | grep -v '^?? audits/'
echo "-- report --"; head -8 "$RUNS/X4t2.out"
