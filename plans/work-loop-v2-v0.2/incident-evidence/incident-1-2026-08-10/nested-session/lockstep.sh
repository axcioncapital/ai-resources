#!/bin/bash
# Lockstep and preservation checks required by the Unit 4 verification contract.
cd "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-diagnostics-workflow" || exit 1

echo "=========== 1. LOCKSTEP: status enumeration across the five sites ==========="
echo "--- sites carrying the WIDE vocabulary (oracle: all five) ---"
for f in .claude/commands/resolve-incident.md .claude/commands/resolve-repo-problem.md \
         templates/incident-log-template.md logs/incident-log.md docs/repo-architecture.md; do
  n=$(grep -c 'not confirmed' "$f")
  printf '%-50s not-confirmed hits: %s\n' "$f" "$n"
done
echo
echo "--- reverse check: any site still carrying the NARROW set? (oracle: none) ---"
grep -rn 'resolved | escalated | deferred}\|resolved/escalated/deferred\b' \
  .claude/commands/resolve-incident.md templates/incident-log-template.md \
  logs/incident-log.md docs/repo-architecture.md || echo "none — no narrow enumeration left"
echo
echo "--- the three new statuses, per site ---"
for s in 'not confirmed' 'no action justified' 'transferred'; do
  echo "  [$s]"
  for f in .claude/commands/resolve-incident.md templates/incident-log-template.md \
           logs/incident-log.md docs/repo-architecture.md; do
    printf '    %-46s %s\n' "$f" "$(grep -c "$s" "$f")"
  done
done

echo
echo "=========== 2. SAME-SEARCH residue: both command names ==========="
echo "--- paths referencing either command (Unit 3 baseline: 21) ---"
grep -rl 'resolve-repo-problem\|resolve-incident' .claude/ .agents/ docs/ templates/ logs/scripts/ 2>/dev/null | sort | wc -l

echo
echo "=========== 3. PRESERVATION ==========="
echo "--- command names/files still at their paths ---"
ls -1 .claude/commands/resolve-incident.md .claude/commands/resolve-repo-problem.md
echo "--- frontmatter description lines unchanged vs HEAD? ---"
for f in .claude/commands/resolve-incident.md .claude/commands/resolve-repo-problem.md; do
  a=$(git show "HEAD:$f" | sed -n '2p')
  b=$(sed -n '2p' "$f")
  if [ "$a" = "$b" ]; then echo "UNCHANGED  $f"; else echo "CHANGED    $f"; fi
done
echo "--- model: frontmatter unchanged? ---"
for f in .claude/commands/resolve-incident.md .claude/commands/resolve-repo-problem.md; do
  printf '%s -> %s (HEAD: %s)\n' "$f" "$(sed -n '3p' "$f")" "$(git show "HEAD:$f" | sed -n '3p')"
done
echo "--- AX_PRIMARY frozen set ---"
sed -n '980,986p' logs/scripts/work-loop-v2-slice-1.test.sh
echo "--- harness + skill untouched ---"
git diff --stat -- logs/scripts/work-loop-v2-slice-1.test.sh .agents/skills/work-loop-v2/SKILL.md
echo "(empty = untouched)"
echo "--- improvement-log field names (two-end contract) ---"
git diff -- .claude/commands/resolve-repo-problem.md | grep -E '^[-+].*\*\*(Status|Category|Severity|Source|Friction source|Proposal|Target files|Notes):\*\*' || echo "no field-name lines changed"
echo
echo "=========== 4. b2950d6 files unchanged in this unit ==========="
git diff --stat HEAD -- templates/incident-log-template.md logs/incident-log.md docs/repo-architecture.md
echo "(empty = unchanged)"
echo
echo "=========== 5. Full working-tree state ==========="
git status --porcelain
