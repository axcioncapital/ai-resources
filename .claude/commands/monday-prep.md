---
model: sonnet
---

# /monday-prep — Monday Infrastructure Cadence

Orient the week. Check working-tree state, audit infrastructure for active projects, and write the week mandate. Produces no report file — findings are logged directly to `logs/session-notes.md` and the week mandate.

Reference doc: `ai-resources/docs/weekly-cadence.md`.

---

### Step 0: Day check

1. Run: `date +%u` (1=Monday … 7=Sunday).
2. If result ≠ 1, print:
   ```
   Today is not Monday (weekday {N}). Running /monday-prep off-schedule.
   Proceed? (y/n)
   ```
   Wait for reply. On `n`, print `"Deferred. Run /monday-prep on Monday."` and stop.

---

### Step 1: Active projects

3. List all projects:
   ```bash
   ls -1d "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/"*/ 2>/dev/null | xargs -I{} basename {}
   ```
4. Display numbered list:
   ```
   Projects:
     1. {project-name-1}
     2. {project-name-2}
     ...

   Which projects are active this week? (comma-separated numbers, or "none")
   ```
5. Wait for reply. Parse into `ACTIVE_PROJECTS` list of project names. An empty reply or "none" means only ai-resources and workspace root are checked.

---

### Step 2: Phase A — Status reset

Set constants:
- `WORKSPACE=/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`
- `AI_RESOURCES=/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- `HARNESS=/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness`
- `TODAY=$(date +%Y-%m-%d)`
- `WEEK=$(date +%G-W%V)`

Run all Phase A steps in sequence. Collect all findings into a running `FLAGS` list.

**A1 — git pull**

```bash
cd "$WORKSPACE" && git pull
```

Report result. If pull fails or shows conflicts, add to `FLAGS`: `"git pull failed or has conflicts"`.

**A2 — Working tree scan**

```bash
cd "$WORKSPACE" && git status --short
cd "$AI_RESOURCES" && git status --short
```

For each modified or untracked file: add to `FLAGS`. Do not auto-commit. Report the list to the operator.

**A3 — Worktree scan**

```bash
git -C "$WORKSPACE" worktree list
```

For each worktree that does not have a corresponding directory on disk, add to `FLAGS`: `"dead worktree: {path}"`.

**A4 — Last session threads**

```bash
tail -30 "$AI_RESOURCES/logs/session-notes.md"
```

Summarize open threads and next steps. Add any unresolved "Next Steps" items to `FLAGS` if they appear to be blocking (contain "before" or "must").

**A5 — Last week's autonomy targets**

```bash
tail -30 "$AI_RESOURCES/logs/maintenance-observations.md" 2>/dev/null || echo "FILE_NOT_FOUND"
```

If file missing, note `"maintenance-observations.md not found — no autonomy targets to read"`. Otherwise extract the most recent autonomy-axis targets and print them for the operator.

---

### Step 3: Phase B — Infrastructure check

**B6 — Symlink audit**

For each active project in `ACTIVE_PROJECTS`:
```bash
PROJECT_PATH="/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/{name}"
find "$PROJECT_PATH/.claude/commands/" "$PROJECT_PATH/.claude/agents/" -maxdepth 1 -type l 2>/dev/null | while read link; do
  [ -e "$link" ] || echo "BROKEN: $link"
done
```
For each broken symlink found, add to `FLAGS`: `"broken symlink: {path}"`.

If any broken symlinks were found, attempt inline repair — scoped to `ACTIVE_PROJECTS` only (do not call `/fix-symlinks`, which scans all projects):

1. For each broken symlink, derive its basename and search `ai-resources/` for a file with that name:
   ```bash
   find "$AI_RESOURCES" -name "{basename}" -not -type l 2>/dev/null
   ```
2. If exactly one match is found, present the proposed fix:
   ```
   BROKEN: {link_path}
   → Re-point to: {found_target}
   Apply? (y/n)
   ```
   Wait for reply. On `y`, run `ln -sf "{found_target}" "{link_path}"`. On `n`, leave the FLAG as-is.
3. If zero or multiple matches are found, leave the FLAG as-is and note: `"symlink repair skipped for {link_path}: {0 | N} candidates found — run /fix-symlinks manually"`.
4. For each repaired symlink, remove its entry from `FLAGS` and record: `"symlink repaired: {link_path} → {target}"`.

**B7 — CLAUDE.md audit (active projects)**

For each project in `ACTIVE_PROJECTS`:

1. Get days since last edit:
   ```bash
   LAST=$(git -C "$WORKSPACE" log -1 --format="%ct" -- "projects/{name}/CLAUDE.md" 2>/dev/null)
   NOW=$(date +%s)
   DAYS=$(( (NOW - LAST) / 86400 ))
   ```
   If `git log` returns empty (file untracked or no commits), treat `DAYS=0`.

2. Get line count:
   ```bash
   wc -l < "projects/{name}/CLAUDE.md" 2>/dev/null || echo 0
   ```

3. **Skip if** DAYS ≥ 14 AND line count < 100 (both conditions must hold). Record: `"CLAUDE.md audit skipped for {name}: unmodified ({DAYS}d) and small ({N} lines)"`.

4. **Otherwise:** invoke `/audit-claude-md project {name}`. Record the produced audit report path in `FLAGS` as an advisory: `"CLAUDE.md audit completed for {name} — review findings"`.

**B8 — Log health check**

Check line counts. Flag any file over 200 lines.

Per-project (for each active project):
```bash
wc -l < "projects/{name}/logs/session-notes.md" 2>/dev/null
wc -l < "projects/{name}/logs/friction-log.md" 2>/dev/null
```

Workspace-level:
```bash
wc -l < "$AI_RESOURCES/logs/improvement-log.md" 2>/dev/null
wc -l < "$AI_RESOURCES/logs/maintenance-observations.md" 2>/dev/null
```

For each file over 200 lines:
- `improvement-log.md` → run `/resolve-improvement-log` if resolved+verified entries exist (look for entries with status `resolved` or `verified`). Add to `FLAGS`: `"improvement-log.md over threshold ({N} lines) — /resolve-improvement-log run"`.
- All others → add to `FLAGS`: `"{file} over threshold ({N} lines) — flag for manual archive"`. Do not auto-archive.

**B9 — Permission spot-check**

For each active project:
```bash
grep -r "defaultMode" "projects/{name}/.claude/settings.json" "projects/{name}/.claude/settings.local.json" 2>/dev/null
```

For ai-resources:
```bash
grep "defaultMode" "$AI_RESOURCES/.claude/settings.json" "$AI_RESOURCES/.claude/settings.local.json" 2>/dev/null
```

If `bypassPermissions` is not found in the relevant settings file(s) for any scope, add to `FLAGS`: `"permission check: bypassPermissions not found in {scope} settings"`.

**B10 — Inbox check**

```bash
ls "$AI_RESOURCES/inbox/" | grep -v "^\.gitkeep$" | grep -v "^archive$"
```

If any files exist, add to `FLAGS`: `"inbox: {N} pending brief(s) — {filenames}"`.

**B11 — Harness state**

```bash
tail -20 "$HARNESS/CHANGELOG.md" 2>/dev/null || echo "No CHANGELOG.md"
ls -1 "$HARNESS/session/" 2>/dev/null || echo "No session/ directory"
```

Summarize: active phase, last completed session report, any in-progress work.

---

### Step 4: Phase C — Week setup

**C12 — Review last Friday checkup**

```bash
ls -1 "$AI_RESOURCES/audits/friday-checkup-"*.md 2>/dev/null | sort | tail -1
```

If found, read the last 40 lines (the follow-up and findings summary section). Summarize which tactical items from that report remain open. Present to the operator.

If not found: print `"No friday-checkup report found — skip C12."`.

**C13 — Review improvement-log pending items**

```bash
grep -A3 "status: pending" "$AI_RESOURCES/logs/improvement-log.md" 2>/dev/null | head -60
```

Summarize pending items and ask: "Any of these fit this week? (list numbers or 'none')" Wait for reply and record the operator's selections. These will feed into the week mandate.

**C14 — Write week mandate**

Determine mandate filename: `week-mandate-{WEEK}.md` (e.g., `week-mandate-2026-W19.md`).
Full path: `$HARNESS/session/week-mandate-{WEEK}.md`.

If the file already exists for this week, ask: "A mandate already exists for {WEEK}. Overwrite? (y/n)". On `n`, skip writing and note `"mandate already exists at {path}"`.

Gather context from:
- Phase A flagged items
- Phase B flagged items
- C12 open follow-ups from last Friday
- C13 selected improvement-log items
- Operator-stated week goals (if any emerged from the conversation)

Present the proposed mandate to the operator before writing:
```
Proposed week mandate for {WEEK}:

**Work this week:**
{derived from flags and operator input}

**Out of scope:**
{anything not listed above}

**Done when:**
{specific completion criteria}

**Files in scope:**
{derived from active projects}

**Stop and check in when:**
- Bright-line autonomy triggers fire
- Any finding in Phase B requires a structural change

**Quality checks required:**
- /qc-pass after every creation or improvement
- /triage before approving any suggestion set

**Threshold overrides:**
{any overrides from the conversation; "none" if default}

Write this mandate? (y / edit / skip)
```

Wait for reply:
- `y` → write the file as shown.
- `edit` → ask what to change, apply, re-present, repeat until `y` or `skip`.
- `skip` → note `"mandate skipped for {WEEK}"`.

**C15 — Session plan scaffold (optional)**

Print: "Write a next-session planning scaffold to `logs/session-plan-next.md`? (y/n)".

- `y` → write `logs/session-plan-next.md` with the following content only:
  ```
  ## Intent
  {first work item from the week mandate}

  Run /session-plan in the next session to fill out this scaffold.
  ```
- `n` → continue.

Do NOT invoke `/session-plan` from inside `/monday-prep`. The week mandate is week-scope; the per-session plan is session-scope — they are written in separate sessions. See `ai-resources/docs/weekly-cadence.md` § Scope separation.

---

### Step 5: Phase D — Exit

**D16 — Log flagged issues**

Append a new entry to `$AI_RESOURCES/logs/session-notes.md`:

```markdown
## {TODAY} — Monday prep: {WEEK}

### Flags
{all FLAGS items, bulleted}

### Mandate
{mandate path, or "skipped"}

### Harness state
{summary from B11}

### Next Steps
{any items from flags or mandate that require follow-up this week}
```

**D17 — Commit cleanup**

If any cleanup was done during Phase B (e.g., broken symlinks resolved, /resolve-improvement-log run), commit those changes now. Stage only files that Monday's cadence produced or modified. Do not bundle pre-existing uncommitted changes.

If nothing was changed: print `"Nothing to commit from Monday prep."`.

---

### Final output

After all phases complete, print a summary block:

```
## Monday prep complete — {WEEK}

Flags:       {N} items
Mandate:     {path | skipped}
Audits run:  {list of /audit-claude-md invocations, or "none"}
Inbox:       {N} pending brief(s) | clear

Next: start first work session. Week mandate is at {path}.
```
