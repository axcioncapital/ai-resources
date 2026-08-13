---
model: sonnet
---

Usage: /sync-workflow [project-path]

Compare a deployed project's `.claude/` tooling against its canonical workflow template and report what's drifted, what's new, and what can be updated.

Arguments: `$ARGUMENTS` — optional path to the project directory. If omitted, assumes the current working directory is the project.

Default behavior is dry-run (report only). After presenting the report, ask the operator which updates to apply.

---

## Step 1: Locate the project and identify its template

Set `PROJECT_DIR` to the argument path or the current working directory.

Verify `{PROJECT_DIR}/CLAUDE.md` exists. If not, stop — this isn't a project directory.

Determine the source workflow template:
1. Check `{PROJECT_DIR}/CLAUDE.md` for a line containing `workflow:` or `template:` in the frontmatter or header section.
2. If not found, check for `{PROJECT_DIR}/.claude/settings.json` — look for template metadata.
3. If still not found, default to `research-workflow` and tell the operator which template you're assuming.

Set `TEMPLATE_DIR` to the canonical template path: `ai-resources/workflows/{workflow-name}/`.

Verify `{TEMPLATE_DIR}/.claude/` exists. If not, stop — canonical template not found.

## Step 2: Build file inventories

List all files in these subdirectories for both locations:

**Canonical template:**
```
{TEMPLATE_DIR}/.claude/commands/*.md
{TEMPLATE_DIR}/.claude/agents/*.md
{TEMPLATE_DIR}/.claude/hooks/*
{TEMPLATE_DIR}/logs/scripts/*
```

**Deployed project:**
```
{PROJECT_DIR}/.claude/commands/*.md
{PROJECT_DIR}/.claude/agents/*.md
{PROJECT_DIR}/.claude/hooks/*
{PROJECT_DIR}/logs/scripts/*
```

Exclude `settings.json` and `settings.local.json` from comparison — these are always project-specific.

`logs/scripts/` is in scope because a command can depend on a helper the `.claude/` inventory cannot see. `/work-loop-v2` Step 1.5 is the case that put it here: the command is symlinked into every project by `auto-sync-shared.sh`, but its ownership helper is a template-deployed file, so a project could hold the command and fail closed on every invocation while a `.claude/`-only inventory reported the project fully in sync.

Build two maps: `canonical_files` and `project_files`, keyed by relative path (e.g., `commands/run-analysis.md`, `logs/scripts/work-loop-owner.sh`).

## Step 3: Classify every file

For each file, determine its category by comparing content:

### Category A: Up to date
File exists in both locations and content is identical.
- **Action:** None needed.

### Category B: Update available
File exists in both locations, content differs, AND the project copy matches an older version of the canonical file (i.e., canonical was updated after deployment).
- **Detection:** The file exists in both but content differs. Since we can't track deployment timestamps, treat all diffs as potential updates.
- **Action:** Candidate for sync. Show diff to operator.

### Category C: Conflict (both sides changed)
File exists in both locations and content differs. This is the same detection as Category B — distinguish them by asking: does the project copy contain project-specific modifications (domain terms, project-specific paths, customized logic)?
- **Heuristic:** If the project copy contains strings not in the canonical version that look project-specific (project name, domain terms from CLAUDE.md), classify as conflict rather than update.
- **Action:** Flag for manual review. Show side-by-side diff.

### Category D: Project-specific
File exists only in the project, not in the canonical template.
- **Action:** Skip. These are intentional project additions.

### Category E: New in canonical
File exists only in the canonical template, not in the project.
- **Action:** Candidate for addition. May have been intentionally omitted at deploy time — present to operator for decision.

## Step 4: Validate skill symlinks

If `{PROJECT_DIR}/reference/skills/` exists:

1. List all symlinks in the directory.
2. For each symlink, verify the target exists (`test -e` on the resolved path).
3. Classify each symlink:
   - **Valid:** target exists and contains a `SKILL.md` file
   - **Broken:** target does not exist (skill may have been renamed or moved in ai-resources)
   - **Stale:** target directory exists but `SKILL.md` is missing
4. Include the results in the sync report (Step 5) as a "Skill Symlinks" section:
   ```markdown
   ### Skill symlinks ({count})
   | Symlink | Target | Status |
   |---------|--------|--------|
   | research-prompt-creator | ai-resources/skills/research-prompt-creator | Valid |
   | old-skill-name | ai-resources/skills/old-skill-name | Broken |
   ```
5. For broken symlinks, offer to re-link to the correct target (if a skill with a similar name exists in ai-resources/skills/) or remove the broken link.

If `{PROJECT_DIR}/reference/skills/` does not exist, skip this step silently.

## Step 4b: Validate the Work Loop ownership prerequisite

Two things must both hold before `/work-loop-v2` can run in a deployed project. Step 3's A–E classification covers the first but cannot cover the second: a project `.gitignore` legitimately carries project-specific rules, so a whole-file diff against the template's would be a permanent Category C conflict and the one rule that matters would be lost inside it. Check the **rule**, not the file.

```bash
# 1. The helper is present and executable.
test -x "{PROJECT_DIR}/logs/scripts/work-loop-owner.sh"

# 2. The ignore rule is live — check-ignore names the matching rule, and exits 1 when none matches.
git -C "{PROJECT_DIR}" check-ignore -v logs/work-loop/.owner
```

Report each as PRESENT or MISSING in the Step 5 report. Both are remediable in Step 7: copy the helper from `{TEMPLATE_DIR}/logs/scripts/work-loop-owner.sh` (verbatim — it is not parameterized), and append `logs/work-loop/.owner` with the template `.gitignore`'s explanatory comment.

**Why a missing rule is not cosmetic.** The declaration is checkout-local by construction. A committed copy replicates across worktrees on merge and then declares *every* checkout the owner — the exact failure the declaration exists to refuse. A project with the helper but no rule is worse than one with neither, because the check runs and its answer is wrong.

**Why a missing helper is not cosmetic either.** `/work-loop-v2` Step 1.5 stops when the check cannot run: an unestablished ownership check is refused, not waived. A project missing the helper fails closed on every Work Loop invocation.

If `{PROJECT_DIR}/.claude/commands/work-loop-v2.md` is absent (the project does not carry the command), report both as N/A and take no action.

## Step 5: Generate sync report

Present a structured report:

```markdown
## Sync Report: {project-name} ← {workflow-name}

**Scanned:** {N} canonical files, {M} project files

### Up to date ({count})
{list of files — collapsed if >5}

### Updates available ({count})
| File | Type | Lines changed |
|------|------|---------------|
| commands/run-analysis.md | command | +12 / -8 |

### Conflicts — manual review needed ({count})
| File | Type | Note |
|------|------|------|
| hooks/friction-log-auto.sh | hook | Project copy has local modifications |

### Project-specific — no action needed ({count})
| File | Type |
|------|------|
| commands/challenge.md | command |
| agents/strategic-critic.md | agent |

### New in canonical — not yet deployed ({count})
| File | Type | Description |
|------|------|-------------|
| commands/usage-analysis.md | command | Added to template after deployment |

### Work Loop ownership prerequisite
| Item | Status |
|------|--------|
| logs/scripts/work-loop-owner.sh | PRESENT / MISSING / N-A |
| .gitignore rule `logs/work-loop/.owner` | PRESENT / MISSING / N-A |
```

## Step 6: Operator decides [Operator]

After presenting the report, ask the operator:

1. **For updates available:** "Apply all non-conflicting updates?" (yes/no/select specific files)
2. **For conflicts:** Show the diff for each and ask: keep project version, take canonical version, or skip.
3. **For new canonical files:** "Add these to the project?" (yes/no/select specific files)

## Step 7: Apply approved changes

For each approved update or addition:
1. Copy the canonical file to the project location, overwriting if it exists.
2. Log what was synced.

After applying:
```
Sync complete:
- Updated: {list}
- Added: {list}
- Skipped: {list}
- Conflicts deferred: {list}
```

Do not commit. The operator reviews the changes and commits when ready.

## Edge cases

- **Template not found:** Stop and report. The operator may need to specify which template manually.
- **Project has no .claude/ directory:** Stop — nothing to sync.
- **No differences found:** Report "Project is fully in sync with canonical template" and exit.
- **Deleted files:** If a file was in the canonical template but was intentionally removed from the project, the sync will offer to re-add it. The operator can decline. This is by design — we can't distinguish "intentionally removed" from "not yet added" without tracking deployment state.
