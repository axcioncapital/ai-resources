---
source: /Users/patrik.lindeberg/.claude/plans/1-all-of-these-valiant-blum.md
saved: 2026-04-27
status: approved — ready to execute next session
note: Archival copy of the approved plan. Original plan-mode file location is the source of truth; this copy exists so the next session can pick it up from inbox without depending on the auto-generated plans directory.
---

# Plan — `/innovation-sweep` (project-end innovation triage)

## Context

When a project (e.g., buy-side service plan) finishes, three categories of reusable Claude Code infrastructure can get **trapped locally**:

1. Things the existing `detect-innovation.sh` hook captured but that were never triaged (operator skipped `/wrap-session` Step 7, deferred the decision, or chose `triaged:project-specific` and the rule actually does generalize after the project's lessons).
2. Things the hook **cannot detect** by design — CLAUDE.md rule sections, settings.json hook taxonomies, prompts/specs under `context/` or `reference/`, style references, scripts.
3. **Divergent forks** — shared artifacts copied into the project that were locally improved (e.g., `audit-repo.md` differs from canonical, the project version may carry a fix worth merging back).

The existing infra covers acquisition (per-write hook) and per-session triage (`/wrap-session` Step 7). The gap is a **project-end audit** that produces a high-confidence "graduate this / merge-back this / keep local" triage list before the operator pivots to a new project.

This command produces that triage list; the operator runs `/graduate-resource` per item afterward. No automatic graduation, no automatic merge-back.

## Resolved clarifications

| Question | Resolution |
|---|---|
| Categories to scan | Operator confirmed all proposed + asked for more. Final list below. |
| Relationship to `/graduate-resource` | Triage only. Operator runs `/graduate-resource` per item. |
| Trigger | Manual standalone command. Not folded into `/wrap-session` (would slow the weekly ritual; project-end is a different cadence). |
| Detection rigor | **Hybrid.** Name/shape match against `ai-resources/` (cheap, deterministic) + content-aware subagent classification for content-shaped items (CLAUDE.md sections, prompts, settings hook patterns) where "generalizable" is a judgment call. |
| Tracking / log discipline | **Do not create a new log. Read-only against the project's existing `logs/innovation-registry.md`.** The sweep reads the registry for context (which items are already `graduated`, `triaged:project-specific`, etc.) but never writes to it. New findings live only in the dated triage report — `audits/innovation-sweep-{project}-YYYY-MM-DD.md` — which is one-shot, replaced on same-day re-run. The operator can manually add entries to the registry after reviewing the report; the sweep does not race with `detect-innovation.sh`. Keeps the registry short. |

## Categories scanned (final list)

Nine categories, plus a meta-category for divergent forks. Categories split by **action path**: `/graduate-resource` only handles types `command`, `agent`, `hook` (verified: `ai-resources/.claude/commands/graduate-resource.md` lines 11–14). The other six categories need manual placement and the report says so explicitly.

| # | Category | Where it lives | Detection signal | Action path |
|---|---|---|---|---|
| 1 | Commands | `.claude/commands/*.md` | Name match in `ai-resources/.claude/commands/` | `/graduate-resource {path}` |
| 2 | Agents | `.claude/agents/*.md` | Name match in `ai-resources/.claude/agents/` | `/graduate-resource {path}` |
| 3 | Hooks | `.claude/hooks/*.sh` and hook entries in `settings.json` | Name match + shape match | `/graduate-resource {path}` |
| 4 | Skills | `skills/*/SKILL.md` (if present in project) | Name match in `ai-resources/skills/` | Manual: copy folder to `ai-resources/skills/`; flag in report |
| 5 | Prompts & spec docs | `prompts/`, `reference/`, `context/` | Heuristic — markdown, not session output, not data | Manual: copy to `ai-resources/prompts/` or appropriate target; flag in report |
| 6 | Scripts | `scripts/`, `.claude/hooks/*.sh` standalone | Name match in `ai-resources/scripts/` | Manual: copy to `ai-resources/scripts/`; flag in report |
| 7 | Style references | `style-references/`, `style/`, files matching `*style*`, `*voice*`, `*tone*` | Path/name pattern | Manual: copy to `ai-resources/style-references/`; flag in report |
| 8 | CLAUDE.md sections | Project `CLAUDE.md` headers | Subagent classification (generalizable vs domain-specific) | Manual: section-edit into workspace or ai-resources CLAUDE.md; flag in report with proposed target |
| 9 | Settings patterns | `.claude/settings.json` hook taxonomy, permission shapes | Subagent classification on stringified JSON (parsing strategy parked to v2 — see below) | Flag-only in v1: report identifies the pattern; operator places manually. No `/graduate-resource` invocation |
| **M** | **Divergent forks** | Items present in both project and ai-resources but content differs | `diff` exit code + line-delta threshold; subagent reviews the diff | Manual: backport via direct edit of canonical `ai-resources/` file. Report includes diff path |

This is broader than the user's original list. New additions vs. their question 1:
- **Style references** (added) — `ai-resources/style-references/` is its own graduation destination.
- **Reference / context docs** (added) — `prose-quality-standards.md` v3 in the buy-side project is a real example: a generalizable spec doc that lives outside the canonical artifact directories.
- **Settings hook taxonomies** (added) — patterns like "PostToolUse[Write] → detect-innovation + log-activity + check-claim-ids" are themselves reusable, distinct from individual hook scripts.
- **Divergent forks** (added as a separate triage category) — graduation is for net-new items; backport is a different action and `/graduate-resource` doesn't handle it. The sweep flags these for the operator with a recommended action ("backport to canonical" or "accept divergence as project fork").

## Command design

**File:** `ai-resources/.claude/commands/innovation-sweep.md`

**Frontmatter:**
- `model: opus` — judgment work (classification, divergence review)
- `description`: "Project-end innovation triage. Scans a completed project for graduation candidates, reconciles against innovation-registry, produces triage report."

**Argument:** `[project-path]` (required). The command does not infer the target via `$CLAUDE_PROJECT_DIR` (in an `ai-resources/` session, that env var resolves to `ai-resources/`, not the swept project). If the argument is omitted, the command uses **`AskUserQuestion`** with a multi-select primitive — options are the directory names under `../projects/` (relative to `ai-resources/`), one option per project. Operator selects one. Once resolved, the path is captured as `{TARGET_PROJECT}` and used throughout.

**Preconditions (verified at design time):**
- `ai-resources/.claude/commands/graduate-resource.md` exists and accepts `$ARGUMENTS` as a path or resource name (verified by reading lines 1–16 of the file). Categories 1–3 invoke this command directly; categories 4–9 produce manual instructions in the report instead.
- The innovation registry schema is `| Date | Type | File | Status | Graduated To |` (verified from `detect-innovation.sh` lines 44–46). The hook writes only the `detected` token; other tokens (`triaged:graduate`, `triaged:project-specific`, `graduated`) are written by `/wrap-session` and `/graduate-resource` updating existing rows. The Step 2 logic must therefore be tolerant of any token in the Status column — it groups items by exact status string and reports each group, rather than expecting a fixed token vocabulary.

**Phases (matches `/permission-sweep` and `/audit-critical-resources` shape):**

1. **Path setup** — resolve `{TARGET_PROJECT}` from argument or picker. Verify directory exists and contains `.claude/`. Locate `ai-resources/` as a sibling of `projects/` (walk up from `{TARGET_PROJECT}` to find the workspace root, then descend into `ai-resources/`). Fail fast on either missing.
2. **Read project's existing registry (read-only)** — if `{TARGET_PROJECT}/logs/innovation-registry.md` exists, parse the markdown table (`| Date | Type | File | Status | Graduated To |`) and build a status map keyed by File path. The Status column may carry any token the downstream commands have written (`detected`, `triaged:graduate`, `triaged:project-specific`, `graduated`, plus any future tokens) — group items by exact status string rather than expecting a fixed vocabulary. If the registry file does not exist, skip this step and note "no registry — all findings are uncontextualized" in the report. Do not create a registry on the operator's behalf.
3. **Inventory project artifacts** — walk the 8 categories above; build a list of files and CLAUDE.md sections with size + path.
4. **Name-match pass (deterministic, main session)** — for each item, the comparison is **category-scoped**: a `qc-reviewer.md` in `.claude/commands/` is matched against `ai-resources/.claude/commands/qc-reviewer.md`, never against an agent of the same name. For each item compute one of: `not in ai-resources`, `in ai-resources identical` (cmp / hash equal), `in ai-resources divergent` (paths exist but content differs).
5. **Spawn `innovation-triage-auditor` subagent** with the inventory + diff data + the registry status map from Step 2. Subagent classifies each item per the contract below. Subagent writes full notes to `audits/working/innovation-sweep-{project}-{DATE}.md`, returns ≤30-line summary with last line `WORKING_NOTES: {path}`.
6. **Read summary, render triage report** to `audits/innovation-sweep-{project}-YYYY-MM-DD.md` — filename includes the project slug so two same-day sweeps on different projects do not collide. Overwrites prior same-day report for the same project on re-run.
7. **No registry mutation.** The sweep does not write to `{TARGET_PROJECT}/logs/innovation-registry.md`. New findings appear in the dated report only. The operator can manually add registry rows after review if they want a persistent record. This avoids the dedup race with the `detect-innovation.sh` hook (which is the registry's only writer).
8. **Present triage to operator** — verdict counts and the next-action checklist. Action lines vary by category:
   - Categories 1–3 (commands, agents, hooks): "Run `/graduate-resource {path}`"
   - Categories 4–7 (skills, prompts, scripts, style refs): "Manually copy to `ai-resources/{target-dir}/`"
   - Category 8 (CLAUDE.md sections): "Manually section-edit into `{target CLAUDE.md path}` — proposed target {workspace|ai-resources}"
   - Category 9 (settings patterns): "Review pattern at `{path}` — manual placement"
   - Category M (divergent forks): "Backport diff at `{diff-path}` to `ai-resources/{path}`"
9. **Commit the report file only** — `audit: innovation-sweep — {project}, N graduate / M backport / K project-specific`. The commit covers only `audits/innovation-sweep-{project}-{date}.md`. The working-notes file under `audits/working/` is intentionally ephemeral (gitignored at `ai-resources/.gitignore` line 22 — "Ephemeral audit working notes"); not committed by design. The sweep does not modify any other project state. (Matches `/audit-critical-resources` and `/audit-claude-md` pattern: dated audit reports are committed; working notes stay local; project state is not touched.)

**No automatic graduation. No registry mutation. Backport for divergent forks is operator-driven** — the report lists the diffs and recommends.

## Subagent — `innovation-triage-auditor`

**File:** `ai-resources/.claude/agents/innovation-triage-auditor.md`
**Model:** Opus (judgment classification)
**Tools:** `Read, Bash, Glob, Grep, Write` — explicit declaration in YAML frontmatter, mirroring `permission-sweep-auditor.md`. Read for inspecting source artifacts; Bash for `cmp`/`diff`/hash on divergent items; Glob/Grep for content-pattern checks (hardcoded paths, project-name references); Write for the working-notes file. No WebFetch/WebSearch (offline classification).
**Contract:** Standard subagent contract per `ai-resources/CLAUDE.md` (≤30-line summary, full notes to `audits/working/innovation-sweep-{project}-{DATE}.md`, summary's last line is `WORKING_NOTES: {path}`).

**Inputs:**
- Project path
- Inventory list (paths + sizes + name-match status)
- ai-resources path
- Project's existing `innovation-registry.md` content
- Diff data for divergent items

**Per-item classification:**
| Verdict | Meaning | Operator action |
|---|---|---|
| `Already graduated` | Identical to ai-resources, no action needed | None |
| `Graduate — new resource` | Not in ai-resources, looks generalizable | `/graduate-resource {path}` |
| `Backport — local has improvements` | Divergent fork; local edits look like upstream-worthy fixes | Manual merge-back to canonical, document in PR |
| `Accept fork — project intentionally diverged` | Divergent but project rationale clear | None |
| `Keep local — project-specific` | Not generalizable (domain terms, hardcoded paths) | None; mark `triaged:project-specific` in registry if not already |
| `Loose end — operator triage needed` | Already in registry as `detected`, classifier disagrees with current status, or content is genuinely ambiguous | Operator decides |

**Classification heuristics for content-shaped items:**
- CLAUDE.md sections — domain terms / operator name / specific framework references → project-specific. Generalizable Claude Code discipline (autonomy rules, QC patterns, model-selection rules) → graduate.
- Prompt / spec docs — references project name, dataset, or operator → project-specific. Self-contained methodology → graduate.
- Settings hook patterns — hook script names that exist as ai-resources scripts → graduate the *taxonomy* (the wiring) separately from the script.

**Out of scope:** the classifier does not propose merged text or write the graduation. It produces a verdict + one-line rationale per item.

## Output report shape

`audits/innovation-sweep-{project}-YYYY-MM-DD.md`:

```markdown
# Innovation Sweep — {Project Name} — {Date}

## Summary
- Total items scanned: N
- Graduate (new resource): X
- Backport (local improvements): Y
- Accept fork: Z
- Keep local: W
- Loose ends needing operator triage: V
- Registry status: {found / missing — manual creation noted as future option}

## Action checklist
[ ] Run `/graduate-resource projects/{p}/.claude/commands/foo.md`
[ ] Backport `audit-repo.md` (project version + 4 lines vs. canonical) — review diff at {path}
...

## Findings by category
### Commands
| Item | Status | Verdict | Rationale | Registry status (if any) |
| ... | ... | ... | ... | ... |

### Agents
...

### CLAUDE.md sections
...

## Registry context (read-only)
- Items already marked `graduated` in registry: K (excluded from action checklist)
- Items already marked `triaged:project-specific`: M (excluded from action checklist)
- Items marked `detected` not yet triaged: L (surfaced in checklist as loose ends)
- The sweep did not modify the registry. Operator may add rows manually after review.
```

## Files to create

| Path | Purpose |
|---|---|
| `ai-resources/.claude/commands/innovation-sweep.md` | Command definition |
| `ai-resources/.claude/agents/innovation-triage-auditor.md` | Classification subagent |

## Files to update

None. No CLAUDE.md edits, no docs cross-references. Strictly two new files.

## Files NOT created or modified (deliberate)

- **No new log file.** The dated `audits/innovation-sweep-{project}-*.md` report is one-shot — replaced on same-day re-run for the same project. Satisfies the operator's "avoid making log files too long" constraint.
- **No mutation of `logs/innovation-registry.md`.** Read-only access. Avoids dedup race with `detect-innovation.sh` and keeps the registry from being bloated by sweep findings the operator may not want to keep.
- **No `/wrap-session` integration.** Project-end is a different cadence than session-end; folding this in would slow every wrap.
- **No edits to `ai-resources/docs/ai-resource-creation.md` or other documentation.** Out of scope for v1; can be revisited if the command graduates from experimental use.

## Verification

1. **Dry-run on buy-side service plan project** (already finished, has 57-row registry):
   - Expected verdicts include: `Backport` for `audit-repo.md`, `improvement-analyst.md`, `qc-reviewer.md` (project version older than ai-resources — actually a reverse backport situation, classifier should flag); `Graduate` for the three local-only generalizable hooks (`coach-reminder.sh`, `friction-log-auto.sh`, `improve-reminder.sh`); `Graduate` for forward-portable `prose-quality-standards.md` v3; `Keep local` for the 25 research-pipeline commands.
   - Compare classifier output to `logs/innovation-registry.md` triage decisions — high agreement = classifier calibrated; large disagreement = re-tune heuristics.

2. **Edge cases to test:**
   - Project with no `innovation-registry.md` (older project) — should still produce a sweep; report's "Registry context" section notes the registry is missing; sweep does not create one.
   - Project where `detect-innovation.sh` was disabled — sweep finds many uncaptured items.
   - Re-run on same project, same day — report file overwritten cleanly; no stale state in `audits/working/`; registry untouched.
   - Verification predictions in step 1 are hypotheses at time of plan — actual classifier output may differ from these predictions without indicating classifier failure.

3. **Subagent contract compliance:**
   - Working notes file written to `audits/working/innovation-sweep-{project}-{date}.md`.
   - Summary ≤30 lines.
   - Last line of summary is `WORKING_NOTES: {path}`.

4. **Registry untouched check:** after a run, `git status` on `{TARGET_PROJECT}/logs/innovation-registry.md` shows no modification. If it does, the read-only contract was violated.

5. **Filename collision:** simulate two same-day runs on different projects; confirm two distinct files exist (`innovation-sweep-{project-A}-{date}.md` and `innovation-sweep-{project-B}-{date}.md`).

6. **Working-notes gitignore check:** confirmed at design time that `audits/working/` is gitignored (`ai-resources/.gitignore` line 22). The plan accounts for this — only the dated report is committed. Re-verify if `.gitignore` changes.

## Out of scope (explicit)

- Automatic graduation. The operator runs `/graduate-resource` per item.
- Automatic backport for divergent forks. Manual operator action.
- Cross-project sweep (sweep all projects at once). v1 takes one project at a time.
- Mutation of the canonical `ai-resources/logs/innovation-registry.md`. v1 only touches the *project's* local registry.

## Open decisions for operator

These can be answered before exit-plan or settled during implementation. Defaults are recommended.

1. **Command name.** Default: `/innovation-sweep` (matches `/permission-sweep` shape). Alternatives: `/triage-innovations`, `/scan-innovations`.
2. **Backport handling.** v1 default: report only, operator handles manually. Alternative for v2: optional `--backport` flag that opens an editor on the diff.

## Parked refinements (deferred to v2 if needed)

Surfaced during plan QC; not blocking for v1. Address only if the first run shows the issue is real.

- **Symlinked vs. real local skills (Category 4).** Some projects symlink shared skills from `ai-resources/skills/` rather than copying. The v1 detector treats both the same (name match against ai-resources). If the first run produces false-positive Graduate verdicts on symlinked skills, add a symlink check (`test -L`) to skip them. Until then, the subagent's classifier should naturally mark identical-content skills as `Already graduated` and avoid the false positive.
- **`settings.json` parsing strategy (Category 9).** v1 passes the file as text to the subagent and lets it classify hook taxonomies as prose patterns. If output quality is low (vague verdicts, missed patterns), v2 can pre-extract `hooks.PostToolUse[Write]`-style entries with `jq` before classification.
