#!/bin/bash
# Build isolated fixtures for the Unit 4 verification matrix.
# Writes only under the session scratchpad. Touches no repository.
set -e

SRC="/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-diagnostics-workflow"
FX="/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources-diagnostics-workflow/053f3b80-6b6e-4b84-9252-0ac7b4b71d12/scratchpad/fx"

rm -rf "$FX"
mkdir -p "$FX"

mk_airesources() {
  R="$1"
  mkdir -p "$R/.claude/commands" "$R/templates" "$R/logs" "$R/docs" \
           "$R/audits/incidents" "$R/audits/working" "$R/plans/work-loop-v2-mvp"
  cp "$SRC/.claude/commands/resolve-incident.md" "$R/.claude/commands/"
  cp "$SRC/.claude/commands/resolve-repo-problem.md" "$R/.claude/commands/"
  cp "$SRC/templates/incident-log-template.md" "$R/templates/"
  cp "$SRC/logs/incident-log.md" "$R/logs/"
  cp "$SRC/docs/protected-zones.md" "$R/docs/"
  cp "$SRC/docs/audit-discipline.md" "$R/docs/"
  cp "$SRC/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md" "$R/plans/work-loop-v2-mvp/"
  printf '# Friction Log\n' > "$R/logs/friction-log.md"
  printf '# Decisions\n' > "$R/logs/decisions.md"
  printf '# Improvement Log\n\n## Schema\n\nSee canonical ai-resources/logs/improvement-log.md.\n\n## Entries\n' > "$R/logs/improvement-log.md"
  printf '# Fixture repo\n\nIsolated test fixture. Not a real workspace.\n' > "$R/CLAUDE.md"
  printf '{ "permissions": { "defaultMode": "bypassPermissions" } }\n' > "$R/.claude/settings.json"
}

# --- Fixture A: an ai-resources-shaped checkout. Must select ITSELF. ---
mk_airesources "$FX/A"

# --- Fixture B: a workspace with ai-resources/ + projects/proj (proj has no sentinels). ---
mkdir -p "$FX/B/projects/proj/.claude/commands" "$FX/B/projects/proj/logs" "$FX/B/projects/proj/audits/working"
mk_airesources "$FX/B/ai-resources"
cp "$SRC/.claude/commands/resolve-incident.md" "$FX/B/projects/proj/.claude/commands/"
cp "$SRC/.claude/commands/resolve-repo-problem.md" "$FX/B/projects/proj/.claude/commands/"
printf '# Project fixture\n' > "$FX/B/projects/proj/CLAUDE.md"
printf '{ "permissions": { "defaultMode": "bypassPermissions" } }\n' > "$FX/B/projects/proj/.claude/settings.json"
printf '# Improvement Log\n\n## Entries\n' > "$FX/B/projects/proj/logs/improvement-log.md"

# --- Seeded faults ---

# F1: a REAL, safely provable fault — a dead file reference (used as the confirmed control).
mkdir -p "$FX/A/docs"
printf '# Fixture doc\n\nStep 4 — see `docs/does-not-exist-anywhere.md` for the routing table.\n' \
  > "$FX/A/docs/fixture-guide.md"
cp "$FX/A/docs/fixture-guide.md" "$FX/B/ai-resources/docs/fixture-guide.md"

# F2: a DISPROVABLE fault — the claim is false; the file is fine.
printf '# Healthy doc\n\nThis file has a correct heading and a valid link to `docs/fixture-guide.md`.\nNothing is malformed here.\n' \
  > "$FX/A/docs/healthy-doc.md"

# F3: a triage-notes file for the bridge case.
printf '%s\n' \
  '# Triage — fixture-guide dead reference' \
  '' \
  '## Problem' \
  'docs/fixture-guide.md cites docs/does-not-exist-anywhere.md, which does not exist.' \
  '' \
  '## Files examined' \
  '- docs/fixture-guide.md' \
  '- docs/ (listing — no does-not-exist-anywhere.md present)' \
  '' \
  '## Failure proof' \
  'Confirmed by direct safe confirmation: read docs/fixture-guide.md:3 and listed docs/ — the cited file is absent.' \
  '' \
  '## Root-cause diagnosis' \
  'ORACLE-TOKEN-BRIDGE-7Q4X. The reference was never repointed after the routing table moved; the citing line was left behind.' \
  '' \
  '## Correction ladder' \
  'Rung: restore the intended path — repoint the citation. Removal and simplification were insufficient because the guidance itself is still wanted.' \
  '' \
  '## Fix options (the three, ranked)' \
  '1. Quick patch (RECOMMENDED) — repoint the citation in docs/fixture-guide.md to docs/protected-zones.md.' \
  '2. Structural fix — add a link-checking hook. Blast radius: all sessions.' \
  '3. Defer — the dead link misroutes readers until fixed.' \
  '' \
  '## Recommended option' \
  'Quick patch.' \
  > "$FX/A/audits/working/2026-08-10-resolve-fixture-guide-dead-reference.md"

for d in "$FX/A" "$FX/B/ai-resources" "$FX/B/projects/proj"; do
  git -C "$d" init -q
  git -C "$d" add -A >/dev/null 2>&1
  git -C "$d" -c user.email=f@f -c user.name=f commit -qm init >/dev/null 2>&1
done

echo "FX=$FX"
echo "--- A sentinels present ---"
ls -1 "$FX/A/templates/incident-log-template.md" "$FX/A/logs/incident-log.md"
echo "--- proj has NO sentinels (expected: no such file) ---"
ls -1 "$FX/B/projects/proj/templates/incident-log-template.md" 2>&1 | head -1
echo "--- baseline: no incident records anywhere ---"
find "$FX" -path '*/audits/incidents/*' -name '*.md' | wc -l
