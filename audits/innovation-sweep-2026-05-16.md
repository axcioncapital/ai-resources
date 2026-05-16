# Innovation Sweep — 2026-05-16

**Scope:** 6 projects — axcion-ai-system-owner (0 resources, skipped), global-macro-analysis, interpersonal-communication, nordic-pe-macro-landscape-H1-2026, obsidian-pe-kb, repo-documentation
**Resource types:** Commands, agents, hooks, skills
**Verdict bar:** Anything that looks generalizable
**Registry cross-check:** Yes — `ai-resources/logs/innovation-registry.md` (last entry 2026-05-08)
**Working notes:** `ai-resources/audits/working/innovation-sweep-2026-05-16/{project}/notes.md`

---

## Verdict Summary

| Project | Graduate | Backport | Accept-fork | Keep-local | Already-grad | Loose-end | Total |
|---|---|---|---|---|---|---|---|
| global-macro-analysis | 0 | 0 | 0 | 21 | 4 | 0 | 25 |
| interpersonal-communication | 2 | 0 | 0 | 4 | 5 | 1 | 12 |
| nordic-pe-macro-landscape-H1-2026 | 4 | 0 | 0 | 9 | 23 | 2 | 38 |
| obsidian-pe-kb | 0 | 0 | 0 | 4 | 4 | 2 | 10 |
| repo-documentation | 1 | 0 | 0 | 8 | 4 | 3 | 16 |
| **TOTAL** | **7** | **0** | **0** | **46** | **40** | **8** | **101** |

Key correction: nordic-pe's 17 commands + 2 agents + 1 hook all turned out to be byte-identical research-workflow deploys — classified `Already graduated` once the sweep checked `ai-resources/workflows/research-workflow/` (the upstream inventory missed this path).

---

## Graduate Candidates

Ranked by generalizability signal (strongest first).

### G1 — SessionStart upward-walk pattern *(HIGH — 2-project confirmation)*

**Type:** Settings pattern (hooks.SessionStart)
**Found in:** nordic-pe-macro-landscape-H1-2026 + repo-documentation (independently)
**Proposed target:** `ai-resources/docs/permission-template.md` (hook wiring reference section)

Portable bash one-liner that walks parent directories to locate `ai-resources/.claude/hooks/auto-sync-shared.sh` regardless of project nesting depth. Two separate projects evolved the same idiom without coordination — strong candidate for the canonical project template.

```bash
d="$CLAUDE_PROJECT_DIR"; while [ "$d" != '/' ]; do d=$(dirname "$d"); [ -f "$d/ai-resources/.claude/hooks/auto-sync-shared.sh" ] && { source ...; exit; }; done
```

**Action:** Add to `permission-template.md` as the canonical SessionStart hook wiring form; replace hardcoded paths in existing projects.

---

### G2 — Read-deny pattern for archive/deprecated content

**Type:** Settings pattern (permissions.deny)
**Found in:** interpersonal-communication (and partially in nordic-pe)
**Proposed target:** `ai-resources/docs/permission-template.md`

```json
"deny": [
  "Read(archive/**)", "Read(**/*.archive.*)",
  "Read(**/deprecated/**)", "Read(**/old/**)"
]
```

Suppresses permission prompts on stale content directories. Generalizable to any project with an archive structure. Not currently in the canonical project template.

---

### G3 — UserPromptSubmit decision-logging hook

**Type:** Settings pattern (hooks.UserPromptSubmit)
**Found in:** nordic-pe-macro-landscape-H1-2026
**Proposed target:** `ai-resources/.claude/` (workflow-level) or `ai-resources/workflows/research-workflow/`

Logs operator decisions to `logs/decisions.md` whenever the transcript contains GATE / bright-line / PAUSE keywords. Uses generic keywords with no project-specific terms — reusable across any gated workflow project.

---

### G4 — Stop hook: checkpoint-not-written nag

**Type:** Settings pattern (hooks.Stop)
**Found in:** nordic-pe-macro-landscape-H1-2026
**Proposed target:** `ai-resources/.claude/` (workflow-level)

Nag that fires at session stop if no checkpoint has been written in the last 120 minutes. No hardcoded project paths — the check is against timestamps only. Generalizable to any stage-gated workflow.

---

### G5 — Five-hook PostToolUse[Write] wiring taxonomy

**Type:** Settings pattern (hooks.PostToolUse)
**Found in:** nordic-pe-macro-landscape-H1-2026
**Proposed target:** `ai-resources/docs/permission-template.md` (as reference wiring)

Fan-out of five hooks on every Write event: auto-commit + log-write-activity + detect-innovation + auto-qc-nudge + check-claim-ids. The hook scripts already exist in ai-resources; the *wiring pattern* (chained PostToolUse[Write] hooks) is what's novel and worth documenting as a reference.

Note: the auto-commit hook in this fan-out is a Loose End (see LE3) — document the taxonomy minus that hook, or flag the policy tension inline.

---

### G6 — CLAUDE.md §Compaction "trust the summary" cost-test rule

**Type:** CLAUDE.md section content
**Found in:** interpersonal-communication CLAUDE.md §Compaction (lines 26–35)
**Proposed target:** `ai-resources/docs/compaction-protocol.md`

Adds a post-compact resumption rule: "trust the summary — run a cost-test before any verification call." This specific formulation is not in `compaction-protocol.md` today and is generalizable Claude Code discipline.

---

### G7 — ic-consult.md / CLAUDE.md §Compaction deny-archive (Interpersonal)

*(Combined entry: the two Graduate verdicts from interpersonal-communication are G2 + G6 above. No additional item.)*

---

## Loose Ends (Operator Triage Needed)

### LE1 — today-drill.md rotation mechanic (interpersonal-communication)

Spaced-repetition rotation with cooldown state file. Mechanic is generalizable; drill content (`drill-set.md`, tier-tags, behavioral categories) is project-specific. **Operator decides:** extract the rotation pattern as a reusable skill, or keep local.

---

### LE2 — CLAUDE.md §Autonomy Rules (nordic-pe)

Defines workflow-execution autonomy semantics (Operator / Operator+CC action tags, gate-fail pause behavior). Looks generalizable to any multi-stage research workflow but currently only present in nordic-pe. **Operator decides:** graduate to workspace CLAUDE.md or `ai-resources/docs/autonomy-rules.md`, or keep project-local.

---

### LE3 — Auto-commit-on-Write hook policy tension (nordic-pe)

nordic-pe wires an auto-commit hook that automatically commits after every Write event. This conflicts with the workspace `Commit Rules` (operator-approved commits). The hook itself is innovative but the policy conflict is unresolved. **Operator decides:** accept as a workflow-level exception and graduate the hook with a caveat note, or keep local.

---

### LE4 — resolve-improvements.md broken symlink (obsidian-pe-kb) ⚠️

`.claude/commands/resolve-improvements.md` is a **broken symlink** pointing to a non-existent ai-resources target. Likely stale after the canonical command was renamed from `resolve-improvements` → `resolve-improvement-log`. **Action required:** delete the symlink or repoint to `ai-resources/.claude/commands/resolve-improvement-log.md`.

---

### LE5 — model field in settings.json (obsidian-pe-kb) ⚠️

`.claude/settings.json` contains a top-level `"model"` field. Workspace memory rule `feedback_no_model_in_settings_json.md` prohibits this. **Operator decides:** confirm intentional override, or remove the field.

---

### LE6 — friction-log-trigger.sh hook (repo-documentation)

Generic friction-log nudge hook. Per its own comment it mirrors `detect-innovation.sh` structure. Not yet triaged; pattern looks reusable. **Operator decides:** graduate to `ai-resources/.claude/hooks/` or keep local.

---

### LE7 — CLAUDE.md §Compaction scratchpad pattern (repo-documentation)

Adds a "write scratchpad then /clear + restart" pattern before compaction fires. May be generalizable workspace discipline but currently scoped to repo-documentation. Simpler than LE2. **Operator decides:** add to `compaction-protocol.md` or keep local.

---

### LE8 — PostToolUse friction-log wiring (repo-documentation)

Tied to LE6: if `friction-log-trigger.sh` graduates, its settings wiring graduates with it. Not a separate decision — resolve together with LE6.

---

## Already-triaged / Keep-local (No Action)

| Project | Block | Verdict |
|---|---|---|
| global-macro-analysis | All 13 kb-* commands | Keep local — tightly coupled to macro-kb/ layout, Hard Rules, staging pipeline |
| global-macro-analysis | 3 skills (ai-resource-builder, intake-processor, repo-health-analyzer) | Already graduated — byte-identical to canonical |
| interpersonal-communication | ic-consult.md, meeting-prep.md | Keep local — hardcoded KB paths, archetype list, Swedish calibration |
| nordic-pe | 17 commands + 2 agents + 1 hook | Already graduated — byte-identical research-workflow deploys |
| nordic-pe | project-status.md | Keep local — scans project-specific dir structure |
| obsidian-pe-kb | resolve-improvements.md | Broken symlink — see LE4 |
| repo-documentation | archaeology.md | Keep local (registry-aligned: triaged:project-specific 2026-05-08) |
| repo-documentation | doc-scanner-agent, principles-checker-agent, system-developer-agent | Keep local — hardcoded output/ paths, decision IDs, pipeline phase writes |
| repo-documentation | resolve-improvements.md | Already graduated — byte-identical to canonical resolve-improvement-log.md (just renamed) |

---

## Registry Updates Needed

New entries to append to `ai-resources/logs/innovation-registry.md` for items not previously registered:

**Graduate candidates (newly triaged):**
- `2026-05-16 | settings-pattern | nordic-pe-macro-landscape-H1-2026/.claude/settings.json#SessionStart-upward-walk | triaged:graduate | → ai-resources/docs/permission-template.md`
- `2026-05-16 | settings-pattern | interpersonal-communication/.claude/settings.json#deny-archive | triaged:graduate | → ai-resources/docs/permission-template.md`
- `2026-05-16 | settings-pattern | nordic-pe-macro-landscape-H1-2026/.claude/settings.json#UserPromptSubmit-decision-log | triaged:graduate | → ai-resources/.claude workflow-level`
- `2026-05-16 | settings-pattern | nordic-pe-macro-landscape-H1-2026/.claude/settings.json#Stop-checkpoint-nag | triaged:graduate | → ai-resources/.claude workflow-level`
- `2026-05-16 | settings-pattern | nordic-pe-macro-landscape-H1-2026/.claude/settings.json#PostToolUse-5hook-taxonomy | triaged:graduate | → ai-resources/docs/permission-template.md wiring reference`
- `2026-05-16 | claude-md | interpersonal-communication/CLAUDE.md#Compaction | triaged:graduate | → ai-resources/docs/compaction-protocol.md`
- `2026-05-16 | settings-pattern | repo-documentation/.claude/settings.json#SessionStart-upward-walk | triaged:graduate | → same as nordic-pe G1 — confirmed duplicate`

**Loose ends (newly triaged):**
- `2026-05-16 | command | interpersonal-communication/.claude/commands/today-drill.md | triaged:loose-end | rotation mechanic generalizable, content project-specific — operator decides`
- `2026-05-16 | claude-md | nordic-pe-macro-landscape-H1-2026/CLAUDE.md#Autonomy-Rules | triaged:loose-end | generalizable workflow autonomy schema — operator decides`
- `2026-05-16 | hook | nordic-pe-macro-landscape-H1-2026/.claude/settings.json#auto-commit-hook | triaged:loose-end | conflicts with workspace Commit Rules — operator decides`
- `2026-05-16 | command | obsidian-pe-kb/.claude/commands/resolve-improvements.md | triaged:broken-symlink | target missing post-rename — delete or repoint to resolve-improvement-log.md`
- `2026-05-16 | settings | obsidian-pe-kb/.claude/settings.json#model-field | triaged:loose-end | violates feedback_no_model_in_settings_json — operator confirms or removes`
- `2026-05-16 | hook | repo-documentation/.claude/hooks/friction-log-trigger.sh | triaged:loose-end | generalizable pattern, not yet graduated — operator decides`
- `2026-05-16 | claude-md | repo-documentation/CLAUDE.md#Compaction | triased:loose-end | scratchpad-before-compact pattern may generalize — operator decides`

**Keep-local blocks (newly triaged — no further action):**
- `2026-05-16 | command | global-macro-analysis/.claude/commands/kb-*.md (13 files) | triaged:project-specific | coupled to macro-kb/ layout`
- `2026-05-16 | command | interpersonal-communication/.claude/commands/ic-consult.md | triaged:project-specific | KB paths + Swedish calibration`
- `2026-05-16 | command | interpersonal-communication/.claude/commands/meeting-prep.md | triaged:project-specific | KB paths + archetype list`
- `2026-05-16 | command | nordic-pe-macro-landscape-H1-2026/.claude/commands/project-status.md | triaged:project-specific | project-shaped dir scanner`
- `2026-05-16 | command | repo-documentation/.claude/commands/resolve-improvements.md | triaged:already-graduated | byte-identical to canonical resolve-improvement-log.md`
- `2026-05-16 | agent | repo-documentation/.claude/agents/doc-scanner-agent.md | triaged:project-specific | hardcoded output/ paths + decision IDs`
- `2026-05-16 | agent | repo-documentation/.claude/agents/principles-checker-agent.md | triaged:project-specific | project principle IDs + pipeline scope`
- `2026-05-16 | agent | repo-documentation/.claude/agents/system-developer-agent.md | triaged:project-specific | W2.4 pipeline-bound`
