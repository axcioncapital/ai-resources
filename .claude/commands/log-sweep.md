---
model: sonnet
---

# /log-sweep — Cross-Project Log Archival

Archive over-threshold log files across `ai-resources/` and active projects. Wraps existing infra (`check-archive.sh`, `split-log.sh`) and extends it to gap files and per-project scopes. The only operator gate is folder selection — after that, the command applies archives automatically.

**Idempotency note:** `/log-sweep` and `/wrap-session` are safe to run on the same day in any order. Double-archival is prevented by `split-log.sh`'s "already at threshold" guard and the date-guard pattern in `log-archiver.sh` (skips files whose most recent dated header is today). Running both commands same-day produces the same result as running either once.

Input: `$ARGUMENTS` (optional).

Flags (anywhere in `$ARGUMENTS`):
- `--dry-run` — run auditor discovery only; write per-scope working notes; do NOT apply any archive operations. Used by `/friday-checkup` weekly rotation.

---

### Step 1: Path setup

1. Resolve `WORKSPACE` (ancestor containing `ai-resources/.claude`):
   ```bash
   d="$(pwd)"
   WORKSPACE=""
   while [ "$d" != "/" ]; do
     if [ -d "$d/ai-resources/.claude" ]; then WORKSPACE="$d"; break; fi
     d=$(dirname "$d")
   done
   [ -n "$WORKSPACE" ] || { echo "ERROR: ai-resources/ not found in any ancestor of $(pwd)"; exit 1; }
   ```
2. Set `AI_RESOURCES` = `{WORKSPACE}/ai-resources`.
3. Set `SCRIPTS_DIR` = `{AI_RESOURCES}/logs/scripts`.
4. Set `AUDIT_DIR` = `{AI_RESOURCES}/audits`.
5. Set `WORKING_DIR` = `{AUDIT_DIR}/working`. Create with `mkdir -p` if missing.
6. Set `DATE` = today: `date +%Y-%m-%d`.
7. Set `FINAL_REPORT_PATH` = `{AUDIT_DIR}/log-sweep-{DATE}.md`.
8. Set `MANIFEST_PATH` = `{WORKING_DIR}/log-sweep-manifest-{DATE}.md`.
9. Verify `{SCRIPTS_DIR}/check-archive.sh` exists. Abort if missing.
10. Verify `{SCRIPTS_DIR}/split-log.sh` exists. Abort if missing.
11. Verify `{SCRIPTS_DIR}/log-archiver.sh` exists. Abort if missing.
12. Verify `{AI_RESOURCES}/.claude/agents/log-sweep-auditor.md` exists. Abort if missing — subagent is required.
13. Verify `python3` is available (`command -v python3`). Abort if missing — symlink-escape checks require it.

---

### Step 2: Parse flags

14. Set `DRY_RUN` = true if `--dry-run` is in `$ARGUMENTS`, else false.

---

### Step 3: Discover candidate scopes

15. Build a candidate list of scopes to scan:
    - Always include: `{AI_RESOURCES}` (label: `ai-resources`)
    - Include each directory under `{WORKSPACE}/projects/` that exists and contains a `logs/` or `audits/working/` subdirectory. Label each as `project:{dirname}`.
    - **Exclude `workflows/*/`** — not in operator's confirmed scope.
    - **Exclude `.claude/worktrees/`** — not a project scope.

16. For each candidate scope, run a quick file count via Bash:
    ```bash
    find "{scope_path}" \
      \( -path "*/.git" -o -path "*/node_modules" -o -path "*/.claude/worktrees" \
         -o -name "*-archive-*.md" -o -name "log-sweep-*.md" -o -name "log-sweep-manifest-*.md" \) \
      -prune -o \
      -name "*.md" -type f -print | wc -l
    ```
    Capture line count as a rough inventory indicator.

17. Present candidates to the operator. Each line: `{label} — {N} markdown files under scope`. If no candidates are found (no `logs/` or `audits/working/` in any scope), print `"No candidate log scopes found."` and exit.

---

### Step 4: Folder selection (operator gate)

18. Emit `[HEAVY]` one-line note: "asking operator to select log-sweep scopes before dispatching auditors."

19. Use `AskUserQuestion` with `multiSelect: true`:
    - Question: "Which scopes should `/log-sweep` scan?"
    - Options: one per candidate from Step 17. Include an "All scopes" option as the first item.
    - If operator selects "All scopes", set `SELECTED_SCOPES` = full candidate list.
    - Otherwise set `SELECTED_SCOPES` = operator-selected subset.

20. If `SELECTED_SCOPES` is empty, print `"No scopes selected. Exiting."` and stop.

---

### Step 5: Dispatch auditors

21. Emit `[HEAVY]` note: "dispatching log-sweep-auditor per selected scope ({N} scope(s))."

22. For each scope in `SELECTED_SCOPES`, spawn one `log-sweep-auditor` subagent. Pass:
    - `SCOPE_PATH` = absolute path to the scope root
    - `SCOPE_LABEL` = the label string (e.g., `ai-resources` or `project:global-macro-analysis`)
    - `WORKING_DIR` = `{WORKING_DIR}`
    - `DATE` = `{DATE}`
    - `AI_RESOURCES_PATH` = `{AI_RESOURCES}` (needed so auditor knows the `ai-resources/` scope boundary for Cat A1 routing)
    - `DRY_RUN` = `"true"` or `"false"` (auditor always writes working notes; `DRY_RUN` is informational context only — the auditor is read-only regardless)

23. Run auditors for independent scopes in parallel (single `Agent` call with multiple subagents). Wait for all returns.

24. Each auditor returns a ≤20-line summary with:
    ```
    Scope: {label}
    Files inventoried: {N}
    Cat A1: {N} (covered by check-archive.sh — {M} over threshold)
    Cat A2: {N} ({M} over threshold)
    Cat B: {N} ({M} over threshold)
    Cat C: {N} inventory-only
    Cat D: {N} ({M} meet age threshold)
    Cat E: {N} skipped (already archived)
    Cat F: {N} inventory-only (format-specific)
    Working notes: {absolute path}
    ```

25. Collect all per-scope summaries into `AUDIT_RESULTS`. If any subagent's return is malformed (missing `Working notes:` line), re-invoke that subagent once. If it still fails, record the scope as `FAILED` and continue.

---

### Step 6: Write pre-apply manifest (BEFORE any rotation)

26. Before any archive operation, write `{MANIFEST_PATH}`. This is the operator's recovery map if apply aborts mid-run.

    For each file the auditor flagged as over-threshold (Cat A1, A2, B, D), add a row:

    ```markdown
    # Log Sweep Pre-Apply Manifest — {DATE}

    | Scope | File | Lines Before | Intended Action | Target Archive Path |
    |-------|------|-------------|-----------------|---------------------|
    | {label} | {file path} | {wc -l count} | {action} | {target path} |
    ```

    Action strings: `header-rotate (check-archive.sh)` / `header-rotate (split-log.sh)` / `header-rotate (log-archiver.sh --mode header3)` / `whole-file-move (log-archiver.sh --mode whole-file-by-mtime)`.

27. After apply completes (Step 9), append a second section to the same manifest with `Lines After` and `Status: ok | FAILED`.

---

### Step 7: Build pre-apply report (informational, no approval pause)

28. From `AUDIT_RESULTS`, compose a plain-language grouped-by-file report:

    ```
    /log-sweep — pre-apply summary

    Scopes: {list of selected scope labels}
    Total files inventoried: {sum}
    Dry-run mode: {yes | no}

    Auto-archive actions (Cat A1/A2/B/D):
    {For each over-threshold file:}
      {scope label} / {relative file path}
        Cat {X} — {action}: {lines before} lines → keep {N} entries, archive {M} entries
        Archive target: {target archive path}

    Inventory-only (Cat C/F — no action):
    {For each Cat C/F file with line-count ≥ 200:}
      {scope label} / {relative file path} — {N} lines, last modified {date}

    {If DRY_RUN:}
    Dry-run complete. No files will be modified.
    Per-scope working notes written to: {list of WORKING_DIR paths}

    {If not DRY_RUN:}
    Applying archives now...
    ```

29. Print this report to chat. Then immediately proceed to Step 8 (no operator pause).

---

### Step 8: Dry-run exit

30. If `DRY_RUN` is true:
    - Write `{FINAL_REPORT_PATH}` with the pre-apply report content (so `/friday-checkup` can read it).
    - Append to the report: "Dry-run complete. Run `/log-sweep` without `--dry-run` to apply archive operations."
    - Append the staging note (Step 10, item 38) even in dry-run mode — working notes files were written and should be staged.
    - Print: `"Dry-run complete. Final report: {FINAL_REPORT_PATH}"`.
    - Exit. Do not proceed to Step 9.

---

### Step 9: Apply archives

Process each over-threshold file. For each file, apply the action that matches its category. Log pass/fail to `APPLIED_LIST`.

**Cat A1 — `check-archive.sh` (ai-resources scope only)**

31. For the `ai-resources` scope Cat A1 files (`session-notes.md`, `decisions.md`):
    ```bash
    cd "{AI_RESOURCES}" && bash logs/scripts/check-archive.sh
    ```
    `check-archive.sh` handles both files in one run. Capture output. If it prints `Auto-archived`, extract the archive filenames and add to `APPLIED_LIST`. If it exits non-zero, record `FAILED: check-archive.sh` and continue.

**Cat A2 — `split-log.sh` direct with absolute path**

32. For each Cat A2 file (gap project files with dated `## ` headers):
    ```bash
    bash "{SCRIPTS_DIR}/split-log.sh" "{ABS_FILE_PATH}" {KEEP} bottom
    ```
    KEEP values: 10 for session-notes / friction-log / qc-log / maintenance-observations / workflow-observations / tweak-log; 3 for decisions. Capture output. Record archive filename in `APPLIED_LIST` or `FAILED`.

**Cat B — `log-archiver.sh --mode header3`**

33. For each Cat B file (dated `### ` headers: `usage-log.md`, `coaching-data.md`, `coaching-log.md`):
    ```bash
    bash "{SCRIPTS_DIR}/log-archiver.sh" --mode header3 "{ABS_FILE_PATH}" {KEEP}
    ```
    KEEP = 10. Capture output. Record archive filename in `APPLIED_LIST` or `FAILED`.

**Cat D — `log-archiver.sh --mode whole-file-by-mtime`**

34. For each Cat D file (files under `*/audits/working/` meeting age threshold):
    ```bash
    bash "{SCRIPTS_DIR}/log-archiver.sh" --mode whole-file-by-mtime "{ABS_FILE_PATH}"
    ```
    The script computes the destination directory `audits/working/archive/YYYY-MM/` from the file's mtime. Capture output. Record moved path in `APPLIED_LIST` or `FAILED`.

**After all files applied — update manifest**

35. Append the `Lines After` and `Status` columns to `{MANIFEST_PATH}` (Step 6, item 27).

---

### Step 10: Write final report

36. Write `{FINAL_REPORT_PATH}`:

    ```markdown
    # Log Sweep Report — {DATE}

    ## Summary

    - Scopes scanned: {list}
    - Files inventoried: {total}
    - Archive operations: {applied count} applied, {failed count} failed
    - Inventory-only (Cat C/F): {count}

    ## Applied

    | Scope | File | Cat | Lines Before | Lines After | Archive Target | Status |
    |-------|------|-----|-------------|-------------|----------------|--------|
    | {label} | {file} | {X} | {N} | {M} | {target} | ok |

    ## Failed (review required)

    {List any FAILED entries with error detail. Empty section if none.}

    ## Inventory-only (Cat C — no dated headers)

    {File path} — {N} lines, last modified {date}. Operator manages manually.

    ## Inventory-only (Cat F — format-specific)

    {File path} — {size}, last modified {date}. Operator manages manually.

    ## Recovery commands

    **Cat A1/A2/B (header-rotated):** `cat {archive-file} >> {source-file}` to restore archived entries.
    **Cat D (whole-file moved):** `mv {archive-path} {original-path}` to restore.
    **Pre-apply manifest:** `{MANIFEST_PATH}`

    ## Per-scope working notes

    {List each WORKING_DIR/{scope}-{date}.md path with one-line scope summary}

    ## Operator acceptance check

    Run `/log-sweep --dry-run` again. It should report zero files over threshold in the auto-archive categories (A1/A2/B/D). Categories C and F are inventory-only and will keep appearing — that is expected. Open one archive file from each rotated category and verify content. If anything looks wrong, recovery commands are above.

    ---

    **Staging note:** Stage `{FINAL_REPORT_PATH}` and `{WORKING_DIR}/log-sweep-*-{DATE}.md` and `{MANIFEST_PATH}` explicitly — `/wrap-session`'s enumerated stage list does not cover these paths.
    ```

37. Print to chat:
    ```
    Applied:
    {For each file in APPLIED_LIST with status ok:}
      ✓ {relative path}  (Cat {X}: {lines-before} → {lines-after} lines)

    {If any FAILED:}
    Failed (review required):
      ✗ {relative path} — {error}

    Final report: {FINAL_REPORT_PATH}
    Pre-apply manifest: {MANIFEST_PATH}
    ```

38. Append staging note to chat output:

    > "Stage `{FINAL_REPORT_PATH}` and `{WORKING_DIR}/log-sweep-*-{DATE}.md` and `{MANIFEST_PATH}` explicitly — `/wrap-session`'s enumerated stage list does not cover these paths."

---

### Notes

- **No operator approval gate after folder pick.** Operator confirmed automated mode at plan time (2026-05-08). The `AskUserQuestion` in Step 4 is the only gate.
- **Subagent contract compliance:** each `log-sweep-auditor` invocation writes full notes to `audits/working/log-sweep-{scope}-{run-token}-{date}.md` (the per-invocation run token prevents same-scope same-date parallel dispatches from colliding on one path; token sits before the date so the `log-sweep-*-{date}.md` staging glob keeps matching) and returns a ≤20-line summary. Main session reads summaries only (Step 24) — the actual notes path always comes from the summary line, never from filename reconstruction.
- **Cat D self-exclusion:** `log-archiver.sh --mode whole-file-by-mtime` excludes `log-sweep-*.md` and `log-sweep-manifest-*.md` from whole-file moves by design (mitigation #2). The auditor also excludes them from Cat D classification.
- **Scope boundaries:** discovery covers `ai-resources/` and `projects/*/` only. `workflows/*/` is explicitly excluded.
- **Failure handling:** if any individual file operation fails, record it and continue. Do not abort the whole run.
- **Idempotency:** re-running `/log-sweep` immediately after an apply run reports zero over-threshold files in Cat A1/A2/B/D (date-guard + threshold-guard prevent double-archival). Cat C/F files always appear in the inventory — that is correct behavior.
