---
model: opus
---

Project-end innovation triage. Scans a completed project for Claude Code infrastructure innovations not yet graduated to `ai-resources/`, produces a triaged candidate list, reads the project's existing `logs/innovation-registry.md` for context (read-only), and outputs a one-shot dated report under `audits/`. The operator runs `/graduate-resource` per item where the existing pipeline supports the type (commands, agents, hooks); the report produces manual placement instructions for the other categories.

**What this complements:**
- `detect-innovation.sh` (PostToolUse hook) — captures new commands, agents, and hooks during work.
- `/wrap-session` Step 7 — triages detected entries at session end.
- `/graduate-resource` — moves an individual item from project to canonical location.

**The gap this fills:** a project-end audit that finds innovations the per-write hook cannot detect (CLAUDE.md sections, settings hook taxonomies, prompts and spec docs under `context/` or `reference/`, scripts, style references) and divergent shared artifacts where the project has improvements worth backporting. Read-only against the registry; the operator may add registry rows manually after reviewing the report.

**Scope:** one project per run (no cross-project sweep). v1 produces a triage list only — no auto-graduation, no auto-backport.

Input: `$ARGUMENTS` — the target project path (relative or absolute). If omitted, the command presents an `AskUserQuestion` picker listing directories under `../projects/` (relative to `ai-resources/`).

---

### Step 1: Path setup

1. Resolve `{TARGET_PROJECT}`:
   - If `$ARGUMENTS` is non-empty, treat it as the project path. Convert to absolute. Verify the directory exists and contains `.claude/`. Abort if either check fails.
   - If `$ARGUMENTS` is empty, list directories under `../projects/` (relative to `ai-resources/`) and present them via `AskUserQuestion` as a single-select. Capture the selection as `{TARGET_PROJECT}`.

2. Locate the workspace and `ai-resources`:
   ```bash
   d="{TARGET_PROJECT}"
   WORKSPACE=""
   while [ "$d" != "/" ]; do
     if [ -d "$d/ai-resources/.claude" ]; then WORKSPACE="$d"; break; fi
     d=$(dirname "$d")
   done
   [ -n "$WORKSPACE" ] || { echo "ERROR: ai-resources/ not found in any ancestor of $TARGET_PROJECT"; exit 1; }
   ```
3. Set `AI_RESOURCES` = `{WORKSPACE}/ai-resources`.
4. Set `AUDIT_DIR` = `{AI_RESOURCES}/audits`.
5. Set `WORKING_DIR` = `{AUDIT_DIR}/working`. Create if missing (`mkdir -p`).
6. Set `DATE` = today in `YYYY-MM-DD` (`date +%Y-%m-%d`).
7. Set `PROJECT_SLUG` = basename of `{TARGET_PROJECT}` (e.g., `buy-side-service-plan`).
8. Set `WORKING_NOTES_PATH` = `{WORKING_DIR}/innovation-sweep-{PROJECT_SLUG}-{DATE}.md`.
9. Set `REPORT_PATH` = `{AUDIT_DIR}/innovation-sweep-{PROJECT_SLUG}-{DATE}.md`.
10. Set `REGISTRY_PATH` = `{TARGET_PROJECT}/logs/innovation-registry.md`.

---

### Step 2: Preconditions

11. Verify the auditor agent exists: `{AI_RESOURCES}/.claude/agents/innovation-triage-auditor.md`. Abort if missing.
12. Verify `{AI_RESOURCES}/.claude/commands/graduate-resource.md` exists (referenced in the action checklist). Abort if missing — without it, the report's primary action lines are dead links.
13. Verify `cmp` and `diff` are on PATH. Abort if missing.

---

### Step 3: Read project's existing registry (read-only)

14. If `{REGISTRY_PATH}` does not exist, set `REGISTRY_STATUS` = `missing` and skip to Step 4. Note in `REPORT_PATH` (Registry context section) that the registry is missing and the sweep did not create one.

15. If it exists, parse the markdown table — schema is `| Date | Type | File | Status | Graduated To |`. Build a status map keyed by `File` path, value = exact `Status` token (do not normalize). The Status column may carry any token: `detected`, `triaged:graduate`, `triaged:project-specific`, `graduated`, or any future token. Group items by exact status string.

16. The sweep does not write to `{REGISTRY_PATH}`. Treat it as read-only throughout.

---

### Step 4: Inventory project artifacts

17. Walk the nine categories below and build an inventory list of `(category, item_path, item_size_bytes)` tuples. For each item record the relative path from `{TARGET_PROJECT}`.

| # | Category | Source pattern |
|---|---|---|
| 1 | Commands | `{TARGET_PROJECT}/.claude/commands/*.md` |
| 2 | Agents | `{TARGET_PROJECT}/.claude/agents/*.md` |
| 3 | Hooks | `{TARGET_PROJECT}/.claude/hooks/*.sh` and `*.md` |
| 4 | Skills | `{TARGET_PROJECT}/skills/*/SKILL.md` (only if directory exists) |
| 5 | Prompts & spec docs | `{TARGET_PROJECT}/prompts/`, `{TARGET_PROJECT}/reference/`, `{TARGET_PROJECT}/context/` (markdown files only) |
| 6 | Scripts | `{TARGET_PROJECT}/scripts/*.sh` standalone (excluding hooks already counted in #3) |
| 7 | Style references | `{TARGET_PROJECT}/style-references/`, `{TARGET_PROJECT}/style/`, plus files in `context/` or `reference/` matching `*style*`, `*voice*`, `*tone*` |
| 8 | CLAUDE.md sections | section headers in `{TARGET_PROJECT}/CLAUDE.md` (extract `^## ` headers + line ranges) |
| 9 | Settings patterns | `{TARGET_PROJECT}/.claude/settings.json` (whole file — the auditor classifies hook taxonomies and permission shapes) |

18. For Category 8, do not parse section content here — pass the file path and the list of `(header, line_range)` tuples to the auditor; it does the classification.

19. For Category 9, read `settings.json` content into memory and pass it as a string to the auditor (parsing strategy parked to v2).

---

### Step 5: Name-match pass (deterministic, main session)

20. For each item from categories 1–7, perform a **category-scoped** match against `{AI_RESOURCES}`:
    - Commands → `{AI_RESOURCES}/.claude/commands/{basename}`
    - Agents → `{AI_RESOURCES}/.claude/agents/{basename}`
    - Hooks → `{AI_RESOURCES}/.claude/hooks/{basename}`
    - Skills → `{AI_RESOURCES}/skills/{folder-name}/SKILL.md`
    - Prompts → `{AI_RESOURCES}/prompts/{basename}`
    - Scripts → `{AI_RESOURCES}/scripts/{basename}`
    - Style references → `{AI_RESOURCES}/style-references/{basename}`
21. For each item compute `MATCH_STATUS` as one of:
    - `not in ai-resources` — destination path does not exist.
    - `in ai-resources identical` — destination exists and `cmp -s {project} {ai-resources}` returns 0.
    - `in ai-resources divergent` — destination exists and content differs. Compute `diff -u {project} {ai-resources} > {WORKING_DIR}/diff-{category}-{basename}.diff` and capture the diff path.
22. Categories 8 and 9 do not have a deterministic name-match — skip this step for them; the auditor classifies content directly.

---

### Step 6: Spawn `innovation-triage-auditor`

23. Emit `[HEAVY]` one-line note: "spawning innovation-triage-auditor to classify {N} items across {C} categories."

24. Spawn one `innovation-triage-auditor` subagent. Pass these inputs:
    - `TARGET_PROJECT` = `{TARGET_PROJECT}`
    - `AI_RESOURCES` = `{AI_RESOURCES}`
    - `WORKING_DIR` = `{WORKING_DIR}`
    - `WORKING_NOTES_PATH` = `{WORKING_NOTES_PATH}`
    - `INVENTORY` = serialized list of `(category, item_path, item_size_bytes, match_status, diff_path?)` tuples from Steps 4–5
    - `REGISTRY_PATH` = `{REGISTRY_PATH}` (or `missing`)
    - `REGISTRY_STATUS_MAP` = the parsed status map from Step 3 (file-path → status-token), or empty if missing
    - `CLAUDE_MD_SECTIONS` = `(header, line_range)` tuples from Category 8
    - `SETTINGS_JSON_CONTENT` = string content from Category 9
    - `DATE` = `{DATE}`

25. Wait for the subagent's return message. Expected shape:
    ```
    Innovation sweep complete. Classified {N} items.
    Verdicts: {GRAD} graduate, {BACK} backport, {LOOSE} loose-end, {LOCAL} keep-local, {ALREADY} already-graduated, {FORK} accept-fork.
    WORKING_NOTES: {absolute path}
    ```

26. If the return message does not contain `WORKING_NOTES:`, re-invoke the subagent once with the same inputs. If it still fails, abort with a loud error naming the malformed return.

---

### Step 7: Render the triage report

27. Read `{WORKING_NOTES_PATH}` once into main session. Per the subagent contract this file holds the full per-item findings; the return-message summary holds counts only.

28. Write `{REPORT_PATH}` with this structure (overwrites prior same-day same-project report on re-run):

```markdown
# Innovation Sweep — {PROJECT_SLUG} — {DATE}

## Summary
- Total items scanned: {N}
- Graduate (new resource): {GRAD}
- Backport (local has improvements): {BACK}
- Accept fork (project intentionally diverged): {FORK}
- Keep local (project-specific): {LOCAL}
- Already graduated (no action): {ALREADY}
- Loose ends needing operator triage: {LOOSE}
- Registry status: {found / missing — manual creation noted as future option}

## Action checklist

{For each item with a graduation/backport/loose-end verdict, one line:}
- [ ] {action line — see action paths below}

Action paths by category:
- Categories 1–3 (commands, agents, hooks) → `Run /graduate-resource {item_path}`
- Categories 4–7 (skills, prompts, scripts, style refs) → `Manually copy {item_path} → ai-resources/{target-dir}/`
- Category 8 (CLAUDE.md sections) → `Manually section-edit lines {range} of {TARGET_PROJECT}/CLAUDE.md into {workspace|ai-resources}/CLAUDE.md`
- Category 9 (settings patterns) → `Review pattern at {item_path} — manual placement, no /graduate-resource`
- Category M (divergent forks) → `Backport diff at {diff_path} → ai-resources/{path}`

## Findings by category

### Commands
| Item | Match status | Verdict | Rationale | Registry status |
|---|---|---|---|---|
| ... | ... | ... | ... | ... |

### Agents
{same shape}

### Hooks
{same shape}

### Skills
{same shape}

### Prompts & spec docs
{same shape}

### Scripts
{same shape}

### Style references
{same shape}

### CLAUDE.md sections
| Section header | Line range | Verdict | Rationale | Proposed target (workspace / ai-resources) |
|---|---|---|---|---|
| ... | ... | ... | ... | ... |

### Settings patterns
| Pattern | Verdict | Rationale | Proposed target |
|---|---|---|---|
| ... | ... | ... | ... |

### Divergent forks (Category M)
| Item | Local diff size | Verdict | Rationale | Diff path |
|---|---|---|---|---|
| ... | ... | ... | ... | ... |

## Registry context (read-only)

- Items already marked `graduated` in registry: {K} (excluded from action checklist)
- Items already marked `triaged:project-specific`: {M} (excluded from action checklist)
- Items marked `detected` not yet triaged: {L} (surfaced in checklist as loose ends)
- Other tokens encountered: {list, if any}
- The sweep did not modify the registry. Operator may add rows manually after review.

## Working notes

Full per-item classifier rationale at `{WORKING_NOTES_PATH}` (gitignored — local only).
```

29. Validate that the report file was written and parses as markdown (`grep -q '^# ' {REPORT_PATH}`). Abort with a loud error if missing.

---

### Step 8: Present triage to operator

30. Print to chat:
    ```
    /innovation-sweep — report

    Project: {PROJECT_SLUG}
    Scanned {N} items across 9 categories + divergent forks.

    Verdicts:
      Graduate (new resource):  {GRAD}
      Backport (local improvements): {BACK}
      Accept fork:              {FORK}
      Keep local:               {LOCAL}
      Already graduated:        {ALREADY}
      Loose ends:               {LOOSE}

    Top items needing action:
    {Up to 8 lines from the action checklist, prioritizing GRAD then BACK then LOOSE}

    Full report: {REPORT_PATH}
    Working notes: {WORKING_NOTES_PATH} (local only)

    Next step: review the report and run `/graduate-resource` on the items where it applies. Manual-placement items have copy-paste instructions in the report.
    ```

---

### Step 9: Commit the report

31. Stage explicit path only (per `ai-resources/CLAUDE.md` Concurrent-session staging discipline — no directory globs, no `git add .`):
    - `git add {REPORT_PATH}`

32. Commit with message:
    ```
    audit: innovation-sweep — {PROJECT_SLUG}, {GRAD} graduate / {BACK} backport / {LOCAL} keep-local
    ```

33. The working-notes file at `{WORKING_NOTES_PATH}` is intentionally ephemeral (`audits/working/` is gitignored at `ai-resources/.gitignore` — "Ephemeral audit working notes"). Not staged, not committed.

34. The sweep does not touch any project file. Specifically: `{REGISTRY_PATH}` is unchanged; `{TARGET_PROJECT}/.claude/` is unchanged.

35. Do NOT push. Remind the operator to push and to run `/wrap-session` when work is complete.

---

### Notes

- **Read-only against the registry.** The sweep never writes to `{TARGET_PROJECT}/logs/innovation-registry.md`. New findings live in the dated report only. The operator can manually add rows to the registry after review if they want a persistent record. This avoids the dedup race with `detect-innovation.sh` (the registry's only writer).
- **Filename collision.** Report filename includes `{PROJECT_SLUG}` so two same-day sweeps on different projects do not collide.
- **Subagent contract compliance.** The auditor writes full notes to disk and returns a ≤30-line summary (counts only). Main session reads the working-notes file once during Step 7 to render the report; not re-read elsewhere.
- **No registry creation.** If the project has no `logs/innovation-registry.md`, the sweep produces a report that flags this in the Registry context section but does not create one. The operator can run `detect-innovation.sh` against existing artifacts manually if they want to populate one.
- **v1 limitations (parked refinements):** symlinked skills are treated the same as real local skills (Category 4); `settings.json` is passed to the auditor as text rather than pre-extracted JSON entries (Category 9). Address only if first-run output shows the issue is real.
