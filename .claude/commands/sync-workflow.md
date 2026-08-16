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

`logs/scripts/` is in scope because a command can depend on a helper the `.claude/` inventory cannot see. `/work-loop-v2` is the case that put it here: the command is symlinked into every project by `auto-sync-shared.sh`, but its state validator and ownership helper are template-deployed files, so a project could hold the command and fail closed on every invocation while a `.claude/`-only inventory reported the project fully in sync. Two of that command's five prerequisites live outside both inventories entirely — under `.agents/skills/` and `.codex/` — which is why Step 4b checks the capability as a whole rather than relying on this comparison.

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

## Step 4b: Validate the Work Loop capability

Work Loop v2 is not one file. Five things must all hold before `/work-loop-v2` can run in a deployed project, and they arrive by four different routes — two template-deployed helper copies, one manifest opt-in skill, one Codex hook plus its registration, and one ignore rule. Step 3's A–E classification covers none of them completely: it cannot see `.codex/`, it cannot tell a registered hook from an unregistered one, and it cannot check the ignore rule, because a project `.gitignore` legitimately carries project-specific rules and a whole-file diff against the template's would be a permanent Category C conflict with the one rule that matters lost inside it. Check the **rule**, not the file — and check all five together, because a project holding four of them is not four-fifths working, it is broken at whichever seam it reaches first.

Do not re-derive the five checks here. One canonical helper owns them, and both this command and `/work-loop-v2`'s own entry preflight ask it, so the two cannot drift apart:

```bash
bash "{AI_RESOURCES}/logs/scripts/work-loop-capability.sh" check \
  --checkout "{PROJECT_DIR}" \
  --canonical "{TEMPLATE_DIR}"
```

`--canonical` is what makes the check compare the copied components byte-for-byte as well as looking for them; omit it and drift goes unseen. It prints one of three verdicts:

| Verdict | Exit | What it means |
|---|---|---|
| `READY` | 0 | All five present, and every copied component byte-identical to the template. |
| `INCOMPLETE` | 3 | One `missing:` or `drifted:` line per component, each naming it. |
| `NOT_APPLICABLE` | 2 | `{PROJECT_DIR}/.claude/commands/work-loop-v2.md` is absent — the project does not carry the command, so the bundle is not applicable. Report N/A and take no action. |

Report the verdict and every named component in the Step 5 report. Each component is remediable in Step 7, and each has exactly one remedy:

| Component | Remedy |
|---|---|
| `state-validator` | Copy `{TEMPLATE_DIR}/logs/scripts/work-loop-state.sh` to `{PROJECT_DIR}/logs/scripts/`, verbatim — it is not parameterized. |
| `owner-helper` | Copy `{TEMPLATE_DIR}/logs/scripts/work-loop-owner.sh` the same way. |
| `reorient-skill` | Add `reorient` to `skills.shared` in `{PROJECT_DIR}/.claude/shared-manifest.json`. The SessionStart sweep creates the symlink on the next session start; create it by hand only if the operator wants it now. |
| `compact-recovery-hook` | Copy `{TEMPLATE_DIR}/.codex/hooks/work-loop-reorient.sh` to `{PROJECT_DIR}/.codex/hooks/`, then register it in `{PROJECT_DIR}/.codex/hooks.json` as a `SessionStart` entry with matcher `compact` whose command runs that path. Both halves are required: an unregistered hook never fires. |
| `owner-ignore-rule` | Append `logs/work-loop/.owner`, with the template `.gitignore`'s explanatory comment, to `{PROJECT_DIR}/.gitignore`. |

**Append and add — never replace.** Every remedy above either drops in a new file or adds one entry to an existing one. `.gitignore`, `shared-manifest.json` and `.codex/hooks.json` all legitimately carry project-specific content, and overwriting any of them to fix a Work Loop gap would trade one failure for a worse one. Re-run the check after applying; it is read-only and repeats cheaply.

**Why each of these is not cosmetic.** A missing **validator** leaves lifecycle unestablished, and there is no fallback reading — every invocation stops. A missing **owner helper** makes `/work-loop-v2` Step 1.5 refuse a check it cannot run, so the project fails closed on every invocation. A missing **Reorient skill** means a compacted Codex session cannot re-establish the task from disk and continues from its summary instead. An unregistered **compact hook** never fires, so a checkout that holds the script is exactly as unrecovered as one without it. And a missing **ignore rule** is the worst of the five: the declaration is checkout-local by construction, so a committed copy replicates across worktrees on merge and then declares *every* checkout the owner — the exact failure the declaration exists to refuse. A project with the helper but no rule is worse than one with neither, because the check runs and its answer is wrong.

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

### Work Loop capability — {READY / INCOMPLETE / NOT-APPLICABLE}
| Component | Status |
|-----------|--------|
| state-validator | PRESENT / MISSING / DRIFTED / N-A |
| owner-helper | PRESENT / MISSING / DRIFTED / N-A |
| reorient-skill | PRESENT / MISSING / N-A |
| compact-recovery-hook | PRESENT / MISSING / DRIFTED / UNREGISTERED / N-A |
| owner-ignore-rule | PRESENT / MISSING / N-A |
```

The five report as one capability, not as five independent items. A project at four of five is INCOMPLETE, and the verdict line says so above the table — a reader who skims the rows must not come away with "mostly fine".

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
