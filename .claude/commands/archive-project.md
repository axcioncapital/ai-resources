---
model: sonnet
---

# /archive-project — Project Archiving Capstone

Close out ONE finished project: run a blocking pre-archive checklist, remove its skill symlinks, move the whole project folder (with its own `.git`) outside the active workspace, and write a permanent archive index + a per-project restore manifest. Operator-invoked, one project per run.

**Scope:** a single completed project under `projects/{name}`. This is NOT a portfolio tracker and NOT a log-tier archiver (see `/log-sweep` for logs, `/wrap-session` for sessions). There is no `/unarchive-project` — the manifest IS the restore recipe (Step 9).

Input: `$ARGUMENTS` — the project directory name under `projects/` (e.g. `nordic-pe-macro-landscape-H1-2026`). Required.

Flags:
- `--dry-run` — run the checklist + build the plan, print it, but make NO changes (no symlink removal, no move, no index write).

Examples:
- `/archive-project nordic-pe-macro-landscape-H1-2026 --dry-run` — preview the plan and gate results, change nothing.
- `/archive-project nordic-pe-macro-landscape-H1-2026` — full archive flow with the destructive confirmation gate.

---

### Step 1: Path setup and target validation

```bash
d="$(pwd)"
WORKSPACE=""
while [ "$d" != "/" ]; do
  if [ -d "$d/ai-resources/.claude" ]; then WORKSPACE="$d"; break; fi
  d=$(dirname "$d")
done
[ -n "$WORKSPACE" ] || { echo "ERROR: ai-resources/ not found in any ancestor of $(pwd)"; exit 1; }

AI_RESOURCES="${WORKSPACE}/ai-resources"
NAME="$1"   # first token of $ARGUMENTS, excluding flags
[ -n "$NAME" ] || { echo "ERROR: no project name given. Usage: /archive-project <project-name> [--dry-run]"; exit 1; }

PROJ="${WORKSPACE}/projects/${NAME}"
ARCHIVE_ROOT="$(dirname "$WORKSPACE")/Axcion AI Archive"
DEST="${ARCHIVE_ROOT}/${NAME}"
INDEX="${AI_RESOURCES}/logs/archived-projects.md"
WORKING_DIR="${AI_RESOURCES}/audits/working"
DATE="$(date +%Y-%m-%d)"
MANIFEST="${WORKING_DIR}/archive-${NAME}-${DATE}.md"
mkdir -p "$WORKING_DIR"

# Target must exist and be an independent git repo
if [ ! -d "$PROJ" ]; then
  echo "Project not found: $PROJ"
  echo "It may already be archived — check ${INDEX}."
  exit 1
fi
[ -d "$PROJ/.git" ] || { echo "ERROR: $PROJ has no .git/ — not an independent repo. Aborting (this command only archives self-contained project repos)."; exit 1; }
```

**Self-contained-repo guard (QC hardening):** confirm the parent workspace repo does NOT track files inside the project — otherwise `mv` would silently orphan tracked paths from parent history.

```bash
if git -C "$WORKSPACE" ls-files --error-unmatch "projects/${NAME}" >/dev/null 2>&1; then
  echo "ERROR: projects/${NAME} is tracked by the parent workspace repo."
  echo "Archiving would orphan it from parent git history. Resolve tracking before archiving."
  exit 1
fi
```

Parse `--dry-run` from `$ARGUMENTS` into `DRY_RUN` (true/false).

---

### Step 2: Pre-archive checklist (BLOCKING)

Fetch first so ahead/behind is current, then run the hard mechanical gates.

```bash
git -C "$PROJ" fetch --quiet 2>/dev/null

BLOCKS=()

# (a) Working tree clean
[ -z "$(git -C "$PROJ" status --porcelain)" ] || BLOCKS+=("Working tree is dirty — commit or discard changes first.")

# (b) No unpushed commits — requires an upstream (no-remote = BLOCK, push-first; see Notes)
UPSTREAM="$(git -C "$PROJ" rev-parse --abbrev-ref '@{u}' 2>/dev/null)"
if [ -z "$UPSTREAM" ]; then
  BLOCKS+=("No upstream/remote tracking branch — push to a remote first (the move leaves no in-workspace copy).")
else
  AHEAD="$(git -C "$PROJ" rev-list --count '@{u}..HEAD' 2>/dev/null)"
  [ "$AHEAD" = "0" ] || BLOCKS+=("$AHEAD unpushed commit(s) — push first.")
fi

# (f) Graduate-flagged innovations not yet graduated
REG="$PROJ/logs/innovation-registry.md"
if [ -f "$REG" ]; then
  PENDING="$(grep -c 'triaged:graduate' "$REG" 2>/dev/null || echo 0)"
  GRADUATED="$(grep -c 'graduated' "$REG" 2>/dev/null || echo 0)"
  if [ "$PENDING" -gt 0 ] && [ "$PENDING" -gt "$GRADUATED" ]; then
    BLOCKS+=("innovation-registry.md has graduate-flagged rows not yet graduated — run /graduate-resource or explicitly waive.")
  fi
fi

if [ "${#BLOCKS[@]}" -gt 0 ]; then
  echo "/archive-project — BLOCKED. Fix these before archiving ${NAME}:"
  printf '  ✗ %s\n' "${BLOCKS[@]}"
  exit 1
fi
echo "Hard gates passed (clean tree, pushed, no pending graduations)."
```

**Operator-attested checks (soft — surfaced, not mechanically faked).** Gather hints to show at the gate (Step 4):

```bash
USAGE_LOG="$PROJ/logs/usage-log.md"
USAGE_HINT=$([ -f "$USAGE_LOG" ] && echo "present ($(date -r "$USAGE_LOG" +%Y-%m-%d))" || echo "MISSING")
SWEEP_HINT=$(ls "$PROJ"/audits/innovation-sweep-*.md >/dev/null 2>&1 && echo "report found" || echo "none found")
```

These three are confirmed by the operator at the Step 4 gate, never auto-passed:
- (c) Final `/usage-analysis` run — hint: `$USAGE_HINT`
- (d) `/innovation-sweep` run — hint: `$SWEEP_HINT`
- (e) Deliverables confirmed in Notion — no filesystem signal; operator attests.

---

### Step 3: Capture state and write pre-move manifest (BEFORE any destruction)

```bash
SHA="$(git -C "$PROJ" rev-parse HEAD)"
REMOTE="$(git -C "$PROJ" remote get-url origin 2>/dev/null || echo '(none)')"
BRANCH="$(git -C "$PROJ" rev-parse --abbrev-ref HEAD)"

# Symlink target table (scope: reference/skills/)
SYMLINK_DIR="$PROJ/reference/skills"
LINK_COUNT=0
SYMLINK_ROWS=""
if [ -d "$SYMLINK_DIR" ]; then
  while IFS= read -r link; do
    tgt="$(readlink "$link")"
    rel="${link#$PROJ/}"
    SYMLINK_ROWS="${SYMLINK_ROWS}| ${rel} | ${tgt} |
"
    LINK_COUNT=$((LINK_COUNT+1))
  done < <(find "$SYMLINK_DIR" -maxdepth 1 -type l 2>/dev/null)
fi

# Stray-link audit (count only — NOT auto-deleted)
STRAY_COUNT="$(find "$PROJ" -type l 2>/dev/null | wc -l | tr -d ' ')"
STRAY_OUTSIDE=$((STRAY_COUNT - LINK_COUNT))
```

Write `$MANIFEST` (recovery map — exists before anything is removed or moved):

```markdown
# Archive Manifest — {NAME} — {DATE}

- Source: {PROJ}
- Destination: {DEST}
- Final commit: {SHA} (branch {BRANCH})
- Remote: {REMOTE}
- Symlinks removed: {LINK_COUNT} (under reference/skills/)
- Stray symlinks elsewhere (NOT removed): {STRAY_OUTSIDE}

## Removed symlink targets (restore table)

| Link (relative to project root) | Target |
|---|---|
{SYMLINK_ROWS}

## Un-archive recipe
1. `mv "{DEST}" "{PROJ}"`
2. Recreate each symlink from the table above: `ln -s "<target>" "{PROJ}/<link>"`
3. Validate: `/fix-symlinks --dry-run`
```

---

### Step 4: Confirmation gate (operator — mandatory)

Emit `[HEAVY]` note: "about to remove {LINK_COUNT} symlinks and move {NAME} outside the workspace."

Print the full plan, then gate:

```
/archive-project — ready to archive {NAME}

  Source      : {PROJ}
  Destination : {DEST}
  Commit      : {SHA} ({BRANCH})  remote: {REMOTE}
  Symlinks    : {LINK_COUNT} to remove under reference/skills/  ({STRAY_OUTSIDE} stray links elsewhere left untouched)

  Hard gates  : PASSED (clean / pushed / no pending graduations)
  Attest (c)  : final /usage-analysis run?      [usage-log: {USAGE_HINT}]
  Attest (d)  : /innovation-sweep run?          [{SWEEP_HINT}]
  Attest (e)  : deliverables confirmed in Notion?

  Manifest    : {MANIFEST}
```

- If `DRY_RUN` is true: print `Dry run — no changes made.` and stop here.
- Otherwise ask: `Confirm (c)/(d)/(e) are satisfied and proceed with symlink removal + move? [y/n]`. Continue only on `y`. On `n`, print `Aborted — nothing changed. Manifest retained at {MANIFEST}.` and stop.

This gate satisfies autonomy rule #3 (deletion + move outside session output scope). It is mandatory even though the command is operator-invoked.

---

### Step 5: Remove symlinks

```bash
if [ -d "$SYMLINK_DIR" ]; then
  find "$SYMLINK_DIR" -maxdepth 1 -type l -delete
fi
REMAINING="$(find "$SYMLINK_DIR" -maxdepth 1 -type l 2>/dev/null | wc -l | tr -d ' ')"
[ "$REMAINING" = "0" ] || { echo "ERROR: $REMAINING symlink(s) still present under reference/skills/. Aborting before move."; exit 1; }
echo "Removed $LINK_COUNT symlink(s)."
```

Removing a symlink never touches its target in `ai-resources/skills/`.

---

### Step 6: Move

```bash
mkdir -p "$ARCHIVE_ROOT"
[ ! -e "$DEST" ] || { echo "ERROR: destination already exists: $DEST. Aborting."; exit 1; }
mv "$PROJ" "$DEST" || { echo "ERROR: mv failed (cross-device?). Aborting — original left in place, no copy+delete fallback."; exit 1; }
```

Never fall back to `cp -r && rm -rf`.

---

### Step 7: Verify the move

```bash
FAIL=0
[ -d "$DEST/.git" ] || { echo "VERIFY FAIL: destination .git missing"; FAIL=1; }
[ "$(git -C "$DEST" rev-parse HEAD 2>/dev/null)" = "$SHA" ] || { echo "VERIFY FAIL: commit SHA mismatch"; FAIL=1; }
[ ! -e "$PROJ" ] || { echo "VERIFY FAIL: original still exists at $PROJ"; FAIL=1; }
[ -z "$(git -C "$DEST" status --porcelain 2>/dev/null)" ] || { echo "VERIFY FAIL: destination tree not clean"; FAIL=1; }
[ "$FAIL" = "0" ] || { echo "Move verification FAILED. Recover using manifest: $MANIFEST"; exit 1; }
echo "Move verified: $DEST @ $SHA, original gone, tree clean."
```

---

### Step 8: Write manifest copy and append the archive index

Copy the manifest into the moved project so it travels with it:

```bash
cp "$MANIFEST" "$DEST/.archive-manifest.md"
```

Append one row to `$INDEX` (create with header if absent). Append-to-END. The index is permanent — never rolled by `check-archive.sh`.

```bash
if [ ! -f "$INDEX" ]; then
  cat > "$INDEX" <<'EOF'
# Archived Projects

Permanent index of projects moved out of the active workspace via `/archive-project`. Append-to-end; never rolled.

| Date | Project | Destination | Final SHA | Remote | Symlinks Removed | Manifest |
|------|---------|-------------|-----------|--------|------------------|----------|
EOF
fi
printf '| %s | %s | %s | %s | %s | %s | %s |\n' \
  "$DATE" "$NAME" "$DEST" "$SHA" "$REMOTE" "$LINK_COUNT" "$DEST/.archive-manifest.md" >> "$INDEX"
```

---

### Step 9: Final report

Print to chat:

```
/archive-project — complete

  {NAME} archived to: {DEST}
  Commit {SHA} preserved; original removed from projects/.
  {LINK_COUNT} symlink(s) removed. Index row appended to {INDEX}.

Un-archive recipe (also in {DEST}/.archive-manifest.md):
  1. mv "{DEST}" "{PROJ}"
  2. Recreate symlinks from the manifest target table (ln -s per row)
  3. /fix-symlinks --dry-run  to validate
```

**Staging note (append to chat):**

> Stage `{INDEX}` explicitly — `/wrap-session`'s enumerated stage list does not cover it. The moved project's own git repo is now outside the workspace and is committed independently from `{DEST}` if needed. The working manifest at `{MANIFEST}` can be staged in ai-resources or left as a working note.
>
> **Stale-reference note:** live-enumerating commands (`/fix-symlinks`, `/log-sweep`, `/friday-checkup`) re-scan `projects/*/` and self-heal. But two canonical grounding docs hard-list active projects by name and will now be stale — they still assert `{NAME}` is active: `projects/repo-documentation/vault/risk-topology.md` (§ dependency chains / reverse map) and `projects/repo-documentation/vault/repo-state.md` (§ active projects). These refresh only at the monthly Friday cadence. If accuracy matters before then, update both by hand.

---

### Notes

- **No-remote = BLOCK (deliberate).** A project with no upstream cannot clear Step 2(b). Rationale: the move leaves no copy inside the active workspace, so a remote backup is the safety net. All current projects have a remote, so this never spuriously blocks; if a genuinely local-only project must be archived, push it to a remote (or create one) first.
- **Hard blocks vs. attestations.** (a) clean tree, (b) pushed, (f) no pending graduations are mechanical hard blocks — the command stops and the operator fixes them. (c) usage-analysis, (d) innovation-sweep, (e) Notion deliverables are operator-attested at the Step 4 gate; filesystem hints are shown but never substitute for confirmation.
- **Stray symlinks outside `reference/skills/`** are counted and reported, never auto-deleted — they move with the folder.
- **Destination collision** (`$DEST` already exists) aborts before the move — re-running after a successful archive gives a clean "not found / already archived" message at Step 1.
- **Design-time gates (not runtime):** landing this command is a new-command structural change — run `/risk-check` once when adding it (autonomy rule #9). `/placement` was resolved at design time (index → `ai-resources/logs/archived-projects.md`; archive tier → `~/Claude Code/Axcion AI Archive/`). The command calls neither at runtime.
