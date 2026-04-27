# Repo Deep Review — 2026-04-27
Workspace: Axcion AI
Scope: ai-resources/workflows/research-workflow
Based on: repo-dd factual audit 2026-04-27 (same scope)

---

## Section 1: Feature Criticality

### 1.1 Load-Bearing Features

| Feature | Reference Count | Blast Radius | Risk Notes |
|---------|----------------|--------------|-----------|
| `CLAUDE.md` | 27 commands + 14 hooks | CRITICAL — every command and hook load it | Unfilled {{PLACEHOLDERS}} or wrong content would corrupt every command's context at session start |
| `reference/stage-instructions.md` | ~8 commands | HIGH — all stage-transition commands | Missing or corrupted file breaks /run-preparation, /run-analysis, /run-cluster, /run-synthesis, /run-report, /run-execution; also referenced by /workflow-status |
| `logs/qc-log.md` | 6 commands | HIGH — QC tracking chain | /audit-repo, /review-chapter, /verify-chapter, /run-cluster all write verdicts here; absence creates invisible QC history |
| `logs/friction-log.md` | 5 references | MEDIUM — hooks + /improve | Absence breaks /improve analysis; friction-log-auto.sh hook silently fails; data gap only |
| `execution/scarcity-register/{section}/` | 5 commands | HIGH at runtime | All Stage 3 commands require it as input; /run-cluster, /run-analysis abort without it after Stage 2 |
| `analysis/cluster-memos/{section}/` | 4 commands | HIGH at Stage 3 | Missing breaks /run-analysis, /run-synthesis, /review-chapter |
| `reference/skills/` symlinks | All skill-calling commands | CRITICAL — entire skill layer | If ai-resources path changes, every skill read fails. No fallback. |

### 1.2 Operational Dependency Chains

**Research Pipeline (main execution path):**
```
/run-preparation → /run-execution → /run-analysis → /run-cluster → /run-synthesis → /run-report → /produce-formatting → /produce-knowledge-file
```
- Single point of failure: `CLAUDE.md` (required by every stage command) and `reference/stage-instructions.md` (read by every stage-transition command)
- `/run-cluster` is also a single point of failure for Stage 3 — its cluster-memo output feeds /run-analysis, /run-synthesis, and /review-chapter

**Project Setup Pipeline:**
```
SETUP.md → skill symlinks → fill CLAUDE.md placeholders → /prime
```
- Single point of failure: Missing `research-question-batcher` skill (listed in SETUP.md required skills; does not exist in ai-resources). Operators who follow SETUP.md literally will encounter a broken symlink at step 6.

**Session Lifecycle:**
```
/prime → [pipeline commands] → /wrap-session
```
- Single point of failure: `/prime` (reads project state; if CLAUDE.md has unfilled placeholders, session starts without context)
- `/wrap-session` is a soft failure point — if skipped, no session note, but execution is not blocked

**Fact Verification Chain:**
```
/verify-chapter → CLAUDE.md §Confidentiality Boundaries → reference/sops/fact-verification-prompt.md → execution-agent → GPT-5 API
```
- Single point of failure: Both `## Confidentiality Boundaries` (now a placeholder stub — must be filled at setup) and `reference/sops/fact-verification-prompt.md` (now a stub — must be populated). Prior to today's fixes, both were missing entirely, silently breaking /verify-chapter at Step 1 and Step 2.

### 1.3 Untracked Dependencies

| Dependency | Type | Why It Matters |
|-----------|------|---------------|
| `research-question-batcher` skill | Required skill not in library | SETUP.md lists it as required; doesn't exist in ai-resources/skills/. Symlink creation fails silently at setup step 6. Low-frequency failure (only at project init) but invisible. |
| `{{PLACEHOLDER}}` values in CLAUDE.md | Operator-filled template values | All 7 placeholders must be filled before any command works correctly. No hook validates their presence. A session started before placeholders are filled will run with broken context. |
| `additionalDirectories` hard-coded path | Machine-specific workspace path | `.claude/settings.json` has `additionalDirectories: ["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]`. Any deployment on a different machine breaks all ai-resources references. No documentation on how to update this at setup time. |
| `ai-resources` relative path in symlink setup | Machine-relative path in SETUP.md | SETUP.md uses `../../ai-resources/skills` as the symlink source. If the project is not placed two levels below ai-resources, symlinks break. Only documented assumption is "project is in projects/". |

---

## Section 2: Context Management

### 2.1 Context Load Summary

| Context Source | Lines | Notes |
|---------------|-------|-------|
| Workspace CLAUDE.md | ~175 | Always loaded |
| ai-resources CLAUDE.md | ~120 | Always loaded |
| research-workflow CLAUDE.md | ~111 | Always loaded (post-F10 cleanup) |
| SessionStart — checkpoint loader (conditional) | 0–3 | Only fires if checkpoint files exist |
| SessionStart — check-template-drift.sh (conditional) | 0–5 | Fires if template has drifted |
| SessionStart — auto-sync-shared.sh (conditional) | 0–5 | Fires if shared commands are out of sync |
| SessionStart — check-archive.sh (conditional) | 0–2 | Fires if log files exceed 1.5x threshold |
| **Estimated total** | **~406–421** | Down ~9 lines after F10 section consolidation |

**Efficiency assessment:** The research-workflow CLAUDE.md has 18 sections after today's fixes. 16 are operationally referenced by at least one command or hook. 2 sections (## Operator Profile: 3 lines; ## Session Boundaries: 2 lines) are purely framing or operator-behavior guidance — together only 5 lines. Efficiency ratio: ~96% of CLAUDE.md content is operationally referenced. No migration candidates above the 5-line threshold.

### 2.2 Migration Candidates

No issues identified. Checked: all 18 CLAUDE.md sections evaluated against the migration criteria (not referenced by any command or hook, AND not a behavioral modifier needed every session, AND >5 lines). The two unreferenced sections (## Operator Profile, ## Session Boundaries) are both under 5 lines — below the migration threshold. The three scoping-violating sections that previously met the criteria (Bright-Line Rule, Citation Conversion Rule, Context Isolation Rules) were moved to `reference/stage-instructions.md` as part of today's F10 fix.

### 2.3 Hook Density Assessment

| Entry Point | Trigger | Hook Count | Cumulative Timeout | Verdict |
|------------|---------|-----------|-------------------|---------|
| Research-workflow project session | PreToolUse — Skill | 1 | 5s | OK |
| | PreToolUse — Edit | 1 | 5s | OK |
| | PostToolUse — Write | 3 | 25s | FLAG — 3-hook threshold exceeded |
| | PostToolUse — Edit | 2 | 10s | OK |
| | SessionStart | 4 | 40s | OK (parallel possible) |
| | Stop | 2 | 10s | OK |
| | UserPromptSubmit | 1 | 5s | OK |

**Flag:** A single Write operation in preparation/, execution/, analysis/, or report/ triggers 3 hooks (auto-commit, log-write-activity, detect-innovation). Combined timeout: 25 seconds. For high-frequency writes (e.g., writing 10+ cluster memos), this creates cumulative 250-second overhead. The auto-commit hook is the heaviest (15s timeout) and fires git operations that may fail silently if the working tree is dirty. Priority: Medium.

### 2.4 Dead or Low-Value Context

| Item | Type | Evidence of Non-Use |
|-----|------|-------------------|
| SessionStart checkpoint loader | Hook | Produces no output for new projects; useful only after Stage 1 begins. Zero cost until first checkpoint written. Not dead — conditional activation is correct design. |
| `detect-innovation.sh` hook (template maintenance) | Hook | Prior to today's fix, fired for every Edit to `.claude/commands/` files during template maintenance in ai-resources, creating false-positive innovation entries. Fixed by user during this session — added skip rules for `ai-resources/.claude/**` and `workflows/*/.claude/**` paths. Now working correctly. |
| `## Operator Profile` section | CLAUDE.md section | 3 lines, not referenced by any command. Framing for Claude about the operator role. Below migration threshold but provides minimal per-turn value — every session restates the same role framing. Low priority to address. |

---

## Section 3: Friction and Improvement Synthesis

### 3.1 Recurring Friction Patterns

Log sweep found 0 recurring friction patterns from the research-workflow template itself (template has no deployed friction logs). The following patterns are inferred from factual-audit findings as proxy evidence of structural friction:

| Pattern | Frequency | Repos Affected | Root Cause | Recommendation |
|---------|-----------|---------------|-----------|---------------|
| Missing model frontmatter on commands (F4) | Workspace-wide (27 commands, 3 repos) | ai-resources, workflows/research-workflow | Workspace rule added post-template; no backfill mechanism | Add model-frontmatter check to /audit-repo and /repo-dd auditor questionnaire |
| Path inconsistencies between commands and file-conventions.md (F1, F2) | Template-local (2 commands) | workflows/research-workflow | file-conventions.md updated without cross-referencing command files | Add a path-convention cross-check to /audit-repo for research-workflow projects |
| detect-innovation.sh false-positive fires during template maintenance | Session-level | ai-resources, workflows/ | Hook didn't distinguish template source paths from deployed project paths | Fixed today (user added skip rules for `ai-resources/.claude/**` and `workflows/*/.claude/**`) |

### 3.2 Improvement Pipeline Health

| Metric | Value |
|--------|-------|
| Logged improvements (ai-resources logs, workflow-related) | 1 (2026-04-18) |
| Applied | 1 (Skill Dependency Chain section — partially applied 2026-04-25) |
| Verified | 0 (no verification entry found) |
| Stalled / pending | 1 (full template compaction/defaults refresh from 2026-04-18 decision) |
| Friction events without matching improvement | 0 |

**Pending work:** The 2026-04-18 decision to refresh the research-workflow template's defaults and compaction guidance was partially applied (Skill Dependency Chain added). Full refresh — review all CLAUDE.md placeholder defaults and compaction directives — has not been actioned. Age: 9 days. Not urgent but worth scheduling.

### 3.3 Specific Recommendations

1. **[HIGH, Quick fix]** Add `additionalDirectories` update to SETUP.md as a required step. The hard-coded path `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` in `.claude/settings.json` will break on any machine other than the current one. SETUP.md should instruct operators to update this value to their local workspace root.

2. **[HIGH, Quick fix]** Remove `research-question-batcher` from SETUP.md required skills list OR create the skill stub in ai-resources. The missing skill is listed as required but does not exist — operators following SETUP.md will encounter a silent broken symlink. Either create a stub or mark the skill as "coming soon."

3. **[MEDIUM, 1 session]** Add a placeholder-validation hook or step to /prime that checks CLAUDE.md for remaining `{{` patterns and alerts the operator before stage execution begins. Unfilled placeholders are the highest-risk silent failure mode in the template — a session started before CLAUDE.md is configured will run with broken context, and no current mechanism surfaces this.

4. **[MEDIUM, Quick fix]** Document the PostToolUse Write 3-hook density as a known performance characteristic in SETUP.md or a template note. The 25-second cumulative timeout per Write in stage directories is by design, but operators encountering slow write operations won't know the cause. A brief note prevents confusion.

5. **[MEDIUM, 1 session]** Add model-frontmatter requirement to /audit-repo check and repo-dd auditor questionnaire. Today's F4 finding (0/27 commands missing `model:`) should be a first-class audit check. The pattern is likely to recur as new commands are added. Adding it to the audit questionnaire prevents silent drift.

6. **[LOW, Quick fix]** Complete the pending 2026-04-18 template refresh (full compaction/defaults review). The Skill Dependency Chain section was added; the broader review of all CLAUDE.md placeholder defaults and compaction directives has not been done. Schedule for next template maintenance session.

---

## Section 4: Pipeline Testing

Not run. Use `/repo-dd full` to include pipeline testing.

---

## Summary

**Critical findings:** 1
- `additionalDirectories` hard-coded to a machine-specific path — breaks all ai-resources references on any other machine (§1.3)

**High findings:** 3
- Missing `research-question-batcher` skill listed as required in SETUP.md (§1.2 setup pipeline)
- `reference/sops/fact-verification-prompt.md` and `## Confidentiality Boundaries` were missing (both fixed in today's factual audit as F7/F8)
- PostToolUse Write triggers 3 hooks with 25-second cumulative timeout (§2.3)

**Medium findings:** 4
- No placeholder-validation at /prime or session start (§1.3)
- 3-hook Write density is undocumented for operators (§2.3)
- Model-frontmatter check missing from audit tooling (§3.1)
- Pending 2026-04-18 template refresh incomplete (§3.2)

**Low findings:** 2
- `## Operator Profile` (3 lines) loads every session without being operationally referenced (§2.4)
- `detect-innovation.sh` false-positive for template maintenance (fixed during this session by user — §2.4)

**Top 3 recommendations by impact:**
1. Add `additionalDirectories` update instruction to SETUP.md (Critical risk, 5-minute fix)
2. Resolve `research-question-batcher` — create stub or remove from required list (High risk, 30-minute fix)
3. Add placeholder-validation check to /prime (Medium risk, prevents highest-frequency silent failure mode)
