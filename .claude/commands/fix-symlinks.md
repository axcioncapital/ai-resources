---
model: sonnet
---

Diagnose and repair broken symlinks in project directories. Scans `projects/` for symlinks whose targets no longer resolve, searches `ai-resources/` by basename to find the correct target, presents a fix plan, and re-points with `ln -sf` after operator confirmation.

**Scope:** all symlinks under `projects/*/` (recursive). Does not scan `workflows/` or `ai-resources/` itself.

Input: `$ARGUMENTS` (optional).

Flags:
- `--dry-run` — diagnose and show the fix plan, but skip the fix step.

Examples:
- `/fix-symlinks` — full diagnose → plan → fix flow.
- `/fix-symlinks --dry-run` — preview what would be fixed, no changes made.

---

### Step 1: Path setup

```bash
d="$(pwd)"
WORKSPACE=""
while [ "$d" != "/" ]; do
  if [ -d "$d/ai-resources/.claude" ]; then WORKSPACE="$d"; break; fi
  d=$(dirname "$d")
done
[ -n "$WORKSPACE" ] || { echo "ERROR: ai-resources/ not found in any ancestor of $(pwd)"; exit 1; }

AI_RESOURCES="${WORKSPACE}/ai-resources"
PROJECTS_DIR="${WORKSPACE}/projects"

echo "WORKSPACE: $WORKSPACE"
echo "PROJECTS_DIR: $PROJECTS_DIR"
```

---

### Step 2: Diagnose — find broken symlinks

```bash
LINKS_TXT="/tmp/fix-symlinks-links.txt"
> "$LINKS_TXT"

while IFS= read -r link; do
  [ ! -e "$link" ] && echo "$link" >> "$LINKS_TXT"
done < <(find "$PROJECTS_DIR" -type l 2>/dev/null)

TOTAL_LINKS=$(find "$PROJECTS_DIR" -type l 2>/dev/null | wc -l | tr -d ' ')
BROKEN_COUNT=$(wc -l < "$LINKS_TXT" | tr -d ' ')

echo "Scanned $TOTAL_LINKS symlinks under projects/."
echo "Found $BROKEN_COUNT broken."
```

If `BROKEN_COUNT` is 0: print `No broken symlinks found under projects/. Nothing to do.` and stop.

---

### Step 3: Plan — single Python pass over all broken symlinks

Write this Python script to `/tmp/fix-symlinks-analyze.py`:

```python
import os, sys

links_file  = sys.argv[1]   # newline-delimited list of broken symlink paths
ai_resources = sys.argv[2]  # absolute path to ai-resources/
plan_file   = sys.argv[3]   # output: TSV of FIX/ZERO/MULTI rows

with open(links_file) as f:
    broken_links = [line.rstrip('\n') for line in f if line.strip()]

# Walk ai-resources ONCE — build basename index
PRUNE = {'.git', 'audits', 'reports', 'logs', 'working', 'archive'}
file_index = {}  # basename -> [abs_path, ...]
dir_index  = {}
for root, dirs, files in os.walk(ai_resources):
    dirs[:] = [d for d in dirs if d not in PRUNE]
    for name in files:
        file_index.setdefault(name, []).append(os.path.join(root, name))
    for name in dirs:
        dir_index.setdefault(name, []).append(os.path.join(root, name))

rows = []
for link_path in broken_links:
    link_basename = os.path.basename(link_path)
    link_dir      = os.path.dirname(link_path)
    is_file       = '.' in link_basename
    index         = file_index if is_file else dir_index
    matches       = list(index.get(link_basename, []))

    existing_target = os.readlink(link_path)

    # Subtree hint from broken target path — helps disambiguate multiple matches
    hint = None
    for marker, tag in [('workflows/', 'workflows'), ('.claude/commands', 'commands'),
                        ('.claude/agents', 'agents'),  ('/skills/', 'skills')]:
        if marker in existing_target:
            hint = tag
            break
    if len(matches) > 1 and hint:
        filtered = [m for m in matches if hint in m]
        if len(filtered) == 1:
            matches = filtered

    # Sanitize tabs in paths so TSV stays parseable
    lp = link_path.replace('\t', ' ')
    et = existing_target.replace('\t', ' ')

    if len(matches) == 0:
        rows.append(f"ZERO\t{lp}\t{et}\t")
    elif len(matches) == 1:
        rel = os.path.relpath(matches[0], link_dir)
        rows.append(f"FIX\t{lp}\t{et}\t{rel}\t{matches[0]}")
    else:
        candidates = "|".join(matches)
        rows.append(f"MULTI\t{lp}\t{et}\t{candidates}")

with open(plan_file, 'w') as f:
    f.write('\n'.join(rows))
    if rows:
        f.write('\n')
```

Then run it:

```bash
PLAN_TSV="/tmp/fix-symlinks-plan.tsv"

python3 /tmp/fix-symlinks-analyze.py \
  "$LINKS_TXT" \
  "$AI_RESOURCES" \
  "$PLAN_TSV"

echo "Plan written to $PLAN_TSV"
```

---

### Step 4: Present plan and confirmation gate

Read the plan TSV and print a formatted report:

```bash
FIXABLE_COUNT=0
ZERO_COUNT=0
MULTI_COUNT=0

echo ""
echo "/fix-symlinks — diagnosis complete"
echo ""
echo "Scanned $TOTAL_LINKS symlinks across projects/."
echo "Found $BROKEN_COUNT broken symlinks."
echo ""
echo "FIXABLE — will be re-pointed automatically:"
N=0
while IFS=$'\t' read -r verdict link_path existing rel_target abs_target; do
  [ "$verdict" = "FIX" ] || continue
  (( N++ )); (( FIXABLE_COUNT++ ))
  echo "  $N. $link_path"
  echo "     Current : $existing"
  echo "     Proposed: $rel_target  [EXISTS: $([ -e "$abs_target" ] && echo YES || echo NO)]"
done < "$PLAN_TSV"
[ $N -eq 0 ] && echo "  (none)"

echo ""
echo "MANUAL RESOLUTION NEEDED — zero or multiple matches:"
N=0
while IFS=$'\t' read -r verdict link_path existing rest; do
  [ "$verdict" = "ZERO" ] || [ "$verdict" = "MULTI" ] || continue
  (( N++ ))
  [ "$verdict" = "ZERO"  ] && { (( ZERO_COUNT++ ));  REASON="0 matches for \"$(basename "$link_path")\" in ai-resources/"; }
  [ "$verdict" = "MULTI" ] && { (( MULTI_COUNT++ )); REASON="multiple matches — pick one manually"; }
  echo "  $N. $link_path"
  echo "     Current: $existing"
  echo "     Reason : $REASON"
done < "$PLAN_TSV"
[ $N -eq 0 ] && echo "  (none)"

echo ""
echo "Summary: $FIXABLE_COUNT fixable / $(( ZERO_COUNT + MULTI_COUNT )) manual / $BROKEN_COUNT total broken"
```

- If `FIXABLE_COUNT` is 0: print `No auto-fixable symlinks found. Review manual-resolution list above.` and stop.
- If `$ARGUMENTS` contains `--dry-run`: print `Dry run — no changes made.` and stop.
- Otherwise: ask `Proceed with $FIXABLE_COUNT automatic fix(es)? [y/n]` and wait for operator input. Only continue on `y`.

---

### Step 5: Fix

```bash
FIXED=0
FAILED=0

while IFS=$'\t' read -r verdict link_path _existing rel_target abs_target; do
  [ "$verdict" = "FIX" ] || continue

  # Race-condition guard: verify target still exists
  if [ ! -e "$abs_target" ]; then
    echo "SKIP (vanished): $link_path"
    (( FAILED++ ))
    continue
  fi

  # Re-point atomically — replaces the broken symlink in place
  ln -sf "$rel_target" "$link_path"

  # Post-fix verification
  if [ -e "$link_path" ]; then
    echo "FIXED: $link_path -> $rel_target"
    (( FIXED++ ))
  else
    echo "FAILED (still broken after ln): $link_path"
    (( FAILED++ ))
  fi
done < "$PLAN_TSV"
```

---

### Step 6: Final summary

```bash
MANUAL_COUNT=$(( ZERO_COUNT + MULTI_COUNT ))

echo ""
echo "/fix-symlinks — complete"
echo ""
echo "  Fixed:                    $FIXED"
echo "  Failed:                   $FAILED"
echo "  Manual resolution needed: $MANUAL_COUNT"

if [ "$MANUAL_COUNT" -gt 0 ]; then
  echo ""
  echo "  Review manual-resolution symlinks above. To remove:"
  echo "    rm \"path/to/link\""
  echo "  To re-point:"
  echo "    ln -sf \"new-target\" \"path/to/link\""
fi
```

Clean up temp files:

```bash
rm -f /tmp/fix-symlinks-links.txt /tmp/fix-symlinks-analyze.py /tmp/fix-symlinks-plan.tsv
```
