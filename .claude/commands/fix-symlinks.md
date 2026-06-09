---
model: sonnet
---

Diagnose and repair broken symlinks in project directories. Scans `projects/` for symlinks whose targets no longer resolve, searches `ai-resources/` by basename to find the correct target, presents a fix plan, and re-points with `ln -sf` after operator confirmation. Also flags two non-broken modes (report-only, never auto-fixed): managed shared files present as regular-file copies instead of symlinks (drift), and canonical commands/agents that should be symlinked into a project but are absent entirely (missing).

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

---

### Step 2b: Diagnose — drift and missing managed symlinks

This pass detects two non-broken failure modes for the files the auto-sync hook manages. Neither raises a runtime error, so neither is visible without an explicit scan:

- **Drift** — a managed shared file present as a regular-file copy instead of the expected relative symlink. It is readable, but it has silently diverged from the canonical.
- **Missing** — a canonical command/agent that *should* be symlinked into the project (per the hook's rules) but is absent entirely.

The "should be present" set is defined exactly as the auto-sync hook defines it (`ai-resources/.claude/hooks/auto-sync-shared.sh`): every canonical file under `ai-resources/.claude/{commands,agents}/`, **minus** the hook's baked-in `EXCLUDE_COMMANDS` / `EXCLUDE_AGENT_GLOBS`, **minus** each project's `shared-manifest.json` `commands.local` / `agents.local` opt-outs. The two exclude lists are read straight from the hook file (not hardcoded here) so this command cannot drift from the hook's contract. Projects without a manifest are skipped — they opt out of managed symlinks entirely, mirroring the hook's bail. A broken symlink (`islink` true) is **not** reported here — Step 2 owns that case — so the three modes never double-count.

```bash
REGULAR_FILE_LIST="/tmp/fix-symlinks-regular-files.txt"
MISSING_LIST="/tmp/fix-symlinks-missing.txt"
> "$REGULAR_FILE_LIST"
> "$MISSING_LIST"

HOOK="$AI_RESOURCES/.claude/hooks/auto-sync-shared.sh"
if [ ! -f "$HOOK" ]; then
  echo "WARNING: auto-sync hook not found at $HOOK — cannot determine canonical exclusions; skipping drift+missing scan."
  REGULAR_FILE_COUNT=0
  MISSING_COUNT=0
else
  # Read the exclude lists straight from the hook (single source of truth).
  EXCLUDE_COMMANDS=$(sed -n 's/^EXCLUDE_COMMANDS="\(.*\)"$/\1/p' "$HOOK")
  EXCLUDE_AGENT_GLOBS=$(sed -n 's/^EXCLUDE_AGENT_GLOBS="\(.*\)"$/\1/p' "$HOOK")
fi

# Guard: a present-but-unparseable hook would yield empty exclude lists, which
# would mis-flag the hook's own meta-excludes (new-project, pipeline-*, etc.) as
# "missing". Skip the scan rather than emit false positives.
if [ -f "$HOOK" ] && [ -z "$EXCLUDE_COMMANDS" ] && [ -z "$EXCLUDE_AGENT_GLOBS" ]; then
  echo "WARNING: could not parse EXCLUDE_COMMANDS/EXCLUDE_AGENT_GLOBS from $HOOK (format may have changed) — skipping drift+missing scan to avoid false positives."
  REGULAR_FILE_COUNT=0
  MISSING_COUNT=0
elif [ -f "$HOOK" ]; then
  python3 - "$AI_RESOURCES" "$PROJECTS_DIR" "$EXCLUDE_COMMANDS" "$EXCLUDE_AGENT_GLOBS" "$REGULAR_FILE_LIST" "$MISSING_LIST" <<'PYEOF'
import json, os, sys, fnmatch

ai_resources, projects_dir = sys.argv[1], sys.argv[2]
exclude_commands   = set(sys.argv[3].split())
exclude_agent_globs = sys.argv[4].split()
drift_output, missing_output = sys.argv[5], sys.argv[6]

def canon(subdir):
    d = os.path.join(ai_resources, ".claude", subdir)
    if not os.path.isdir(d):
        return []
    return sorted(n[:-3] for n in os.listdir(d) if n.endswith(".md"))

cmd_names, agt_names = canon("commands"), canon("agents")

def is_excluded(name, kind, local):
    if name in local:
        return True
    if kind == "command":
        return name in exclude_commands
    return any(fnmatch.fnmatch(name, g) for g in exclude_agent_globs)

drift, missing = [], []
for entry in sorted(os.listdir(projects_dir)):
    proj = os.path.join(projects_dir, entry)
    manifest_path = os.path.join(proj, ".claude", "shared-manifest.json")
    if not os.path.isfile(manifest_path):
        continue  # no manifest -> opts out of managed symlinks (mirrors hook bail)
    try:
        with open(manifest_path) as f:
            manifest = json.load(f)
    except (ValueError, OSError):
        continue
    local_cmd = set(manifest.get("commands", {}).get("local", []))
    local_agt = set(manifest.get("agents", {}).get("local", []))

    for kind, names, subdir, local in (
        ("command", cmd_names, "commands", local_cmd),
        ("agent",   agt_names, "agents",   local_agt),
    ):
        for name in names:
            if is_excluded(name, kind, local):
                continue
            target = os.path.join(proj, ".claude", subdir, f"{name}.md")
            is_link = os.path.islink(target)
            exists  = os.path.exists(target)  # follows links; False for a broken link
            if is_link:
                continue                       # good or broken symlink -> not this pass
            if exists:
                drift.append(f"{kind}\t{target}")          # regular file where symlink expected
            else:
                src = os.path.join(ai_resources, ".claude", subdir, f"{name}.md")
                rel = os.path.relpath(src, os.path.dirname(target))
                missing.append(f"{kind}\t{target}\t{rel}")  # absent entirely

with open(drift_output, "w") as f:
    if drift:
        f.write("\n".join(drift) + "\n")
with open(missing_output, "w") as f:
    if missing:
        f.write("\n".join(missing) + "\n")
PYEOF

  REGULAR_FILE_COUNT=$(wc -l < "$REGULAR_FILE_LIST" | tr -d ' ')
  MISSING_COUNT=$(wc -l < "$MISSING_LIST" | tr -d ' ')
fi

echo "Found $REGULAR_FILE_COUNT regular-file-where-symlink-expected drift entries."
echo "Found $MISSING_COUNT missing-symlink entries (canonical, not excluded, absent from project)."
```

If `BROKEN_COUNT` is 0 and `REGULAR_FILE_COUNT` is 0 and `MISSING_COUNT` is 0: print `No issues found under projects/. Nothing to do.` and stop.

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
echo "REGULAR FILE WHERE SYMLINK EXPECTED — managed shared file present as a regular-file copy:"
N=0
while IFS=$'\t' read -r kind path; do
  [ -z "$path" ] && continue
  (( N++ ))
  echo "  $N. [$kind] $path"
  echo "     Status: regular file (should be a relative symlink to ai-resources canonical)"
  echo "     Remedy: diff the file against the canonical, then replace with: ln -sf <rel-target> \"$path\""
done < "$REGULAR_FILE_LIST"
[ $N -eq 0 ] && echo "  (none)"

echo ""
echo "MISSING SYMLINKS — canonical in ai-resources, not excluded, but absent from the project:"
N=0
while IFS=$'\t' read -r kind path rel; do
  [ -z "$path" ] && continue
  (( N++ ))
  echo "  $N. [$kind] $path"
  echo "     Expected: relative symlink -> $rel"
  echo "     Remedy: re-open a session (the auto-sync hook recreates it) or run /sync-workflow."
done < "$MISSING_LIST"
[ $N -eq 0 ] && echo "  (none)"

echo ""
echo "Summary: $FIXABLE_COUNT fixable / $(( ZERO_COUNT + MULTI_COUNT )) manual / $BROKEN_COUNT total broken | $REGULAR_FILE_COUNT drift | $MISSING_COUNT missing (drift + missing always manual)"
```

- If `FIXABLE_COUNT` is 0: print `No auto-fixable symlinks found. Review manual-resolution list above.` and stop.
- If `$ARGUMENTS` contains `--dry-run`: print `Dry run — no changes made.` and stop.
- Otherwise: ask `Proceed with $FIXABLE_COUNT automatic fix(es)? [y/n]` and wait for operator input. Continue only on an explicit `y`; treat empty input, EOF, or a non-interactive invocation as `n` and stop — never fix without an explicit `y`.

**Note:** Regular-file drift entries are always MANUAL — never auto-fixed. A regular file may have diverged from the canonical; overwriting with a symlink would destroy local changes. Always diff before replacing.

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
echo "  Fixed (broken symlinks):      $FIXED"
echo "  Failed (broken symlinks):     $FAILED"
echo "  Manual (broken, no match):    $MANUAL_COUNT"
echo "  Regular-file drift (manual):  $REGULAR_FILE_COUNT"
echo "  Missing symlinks (manual):    $MISSING_COUNT"

if [ "$MANUAL_COUNT" -gt 0 ]; then
  echo ""
  echo "  Review manual-resolution symlinks above. To remove:"
  echo "    rm \"path/to/link\""
  echo "  To re-point:"
  echo "    ln -sf \"new-target\" \"path/to/link\""
fi

if [ "$MISSING_COUNT" -gt 0 ]; then
  echo ""
  echo "  Missing symlinks self-heal on next session start (auto-sync hook), or run /sync-workflow now."
fi
```

Clean up temp files:

```bash
rm -f /tmp/fix-symlinks-links.txt /tmp/fix-symlinks-analyze.py /tmp/fix-symlinks-plan.tsv /tmp/fix-symlinks-regular-files.txt /tmp/fix-symlinks-missing.txt
```
