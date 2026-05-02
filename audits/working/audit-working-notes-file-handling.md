# Section 6 Working Notes — File Handling Patterns

**Execution date:** 2026-05-02  
**Scope:** ai-resources (full repo audit)  
**Protocol version:** 1.3

---

## Step 6.1 — Large files scan

**Method:** Find all .md, .json, .txt, .csv, .yaml, .yml files; sort by word count and line count; merge deduplicates.

**Files over 200 lines identified (n=43 unique files):**

| File | Words | Lines | File type |
|------|-------|-------|-----------|
| ./logs/session-notes-archive-2026-04.md | 37432 | 2978 | active archive |
| ./audits/token-audit-2026-04-18-ai-resources.md | 10381 | 647 | generated report |
| ./audits/token-audit-2026-04-18-project-buy-side-service-plan.md | 7324 | 511 | generated report |
| ./logs/decisions-archive-2026-04.md | 7075 | 381 | active archive |
| ./audits/repo-due-diligence-2026-04-12.md | 6883 | 824 | generated report |
| ./audits/repo-due-diligence-2026-04-11.md | 6326 | 857 | generated report |
| ./logs/decisions.md | 6583 | 400 | active session log |
| ./logs/session-notes.md | 6116 | 513 | active session log |
| ./audits/token-audit-protocol.md | 6053 | 640 | canonical reference |
| ./audits/repo-due-diligence-2026-04-18-ai-resources.md | 5889 | 739 | generated report |
| ./logs/usage-log.md | 5648 | 376 | active telemetry |
| ./audits/repo-due-diligence-2026-04-21-project-obsidian-pe-kb.md | 5596 | 710 | generated report |
| ./audits/repo-due-diligence-2026-04-27-project-repo-documentation.md | 5514 | 614 | generated report |
| ./audits/repo-due-diligence-2026-04-27-workflow-research-workflow.md | 5412 | 669 | generated report |
| ./.claude/commands/new-project.md | 5279 | 527 | active command |
| ./audits/claude-md-audit-2026-04-20-project-buy-side-service-plan.md | 4726 | 340 | generated report |
| ./audits/repo-due-diligence-2026-04-06.md | 4699 | 691 | generated report |
| ./skills/worktree-cleanup-investigator/references/execution-protocol.md | 4548 | 337 | skill reference |
| ./audits/working/setup-scan-bssp-archives-b-2026-04-21.md | 4361 | 602 | working notes |
| ./skills/ai-prose-decontamination/SKILL.md | 4352 | 243 | skill |
| ./audits/working/audit-working-notes-workflow-research-pipeline-five-stage-buy-side.md | 4137 | 342 | working notes |
| ./skills/answer-spec-generator/SKILL.md | 3907 | 487 | skill |
| ./workflows/research-workflow/.claude/commands/produce-prose-draft.md | 3695 | 222 | workflow command |
| ./skills/research-plan-creator/SKILL.md | 3508 | 466 | skill |
| ./audits/token-audit-2026-04-24-ai-resources.md | 3641 | 351 | generated report |
| ./skills/worktree-cleanup-investigator/SKILL.md | 3618 | 326 | skill |
| ./audits/working/setup-scan-ai-resources-2026-04-21.md | 4123 | 396 | working notes |
| ./audits/working/innovation-sweep-buy-side-service-plan-2026-04-27.md | 3907 | 290 | working notes |
| ./logs/coaching-data.md | 3749 | 155 | data file |
| ./docs/audit-discipline.md | 2836 | 184 | process doc |
| ./.claude/commands/friday-checkup.md | 3560 | 391 | active command |
| ./.claude/commands/deploy-workflow.md | 2996 | 353 | active command |
| ./audits/workflow-analysis-research-workflow-2026-04-07.md | 4283 | 360 | generated report |
| ./.claude/commands/clarify.md | 2614 | 195 | active command |
| ./audits/working/permission-sweep-2026-04-24.md | 2491 | 429 | working notes |

---

## Step 6.2 — Re-use Step 0.3 finding

From `audit-working-notes-preflight.md`:

**Verdict: MEDIUM** — Read(...) deny rules exist but coverage is incomplete.

**Currently covered by Read() denies:**
- `archive/**` → fully covered
- `**/deprecated/**` → fully covered
- `**/old/**` → fully covered
- `inbox/archive/**` → covered (but not active inbox)
- `logs/*-archive-*.md` → archive logs only (not active logs)

**Expected coverage (per protocol):** `audits/`, `logs/`, `reports/`, `inbox/`, `archive/`, `output/`, `drafts/`, `deprecated/`, `old/`

**Missing coverage (with intent qualifiers):**
- `audits/` — INTENTIONAL CARVE-OUT (per 2026-05-01 decisions: would break /friday-act, /risk-check, /token-audit)
- `audits/working/` — **NOT INTENTIONAL** (working notes from prior audits should be ignored)
- `reports/` — INTENTIONAL CARVE-OUT (same reason as audits/)
- `output/` — not present in ai-resources scope
- `drafts/` — not present
- `logs/` — partially covered (archive variant only; active logs intentionally readable)
- `inbox/` — partially covered (archive variant only; active inbox intentionally readable)

---

## Step 6.3 — Assessment: What should Claude read?

**Classification by file category:**

### A. SHOULD READ — Critical operational files

- `./audits/token-audit-protocol.md` (640 lines) — canonical audit protocol reference; essential for audit sessions
- `./logs/decisions.md` (400 lines) — active session decisions log; supports continuity across sessions
- `./logs/session-notes.md` (513 lines) — active session notes; supports session planning and state tracking
- `./logs/usage-log.md` (376 lines) — active telemetry; needed for `/usage-analysis` and workflow optimization
- `./.claude/commands/new-project.md` (527 lines) — active command; invoked regularly
- `./.claude/commands/friday-checkup.md` (391 lines) — active command; invoked weekly
- `./.claude/commands/deploy-workflow.md` (353 lines) — active command
- `./.claude/commands/clarify.md` (195 lines) — active command
- All `skills/*.md` files — active skill library; invoked on demand
- `./workflows/research-workflow/.claude/commands/produce-prose-draft.md` (222 lines) — workflow command; active
- `./skills/*/references/*.md` — skill reference materials; support skill execution

### B. SHOULD NOT READ — Generated outputs and archives

- `./audits/token-audit-*.md` (all variants, 351–647 lines each) — prior audit reports; generated outputs from prior sessions
- `./audits/repo-due-diligence-*.md` (all variants, 691–857 lines each) — prior audit reports; generated outputs
- `./audits/claude-md-audit-*.md` (340 lines) — prior audit output
- `./audits/working/*.md` (all variants, 290–602 lines each) — intermediate working notes from prior audits; should NOT be read in future audit sessions
- `./logs/session-notes-archive-*.md` (2978 lines) — archived session notes; large and stale
- `./logs/decisions-archive-*.md` (381 lines) — archived decisions
- `./logs/improvement-log-archive.md` — archived improvement log
- `./logs/coaching-data.md` (155 lines) — bulk reference data

### C. NEUTRAL / METADATA — Non-load-bearing

- `./.claude/settings.json`, `settings.local.json` — config files; not normally read in sessions
- Workflow template files in `./workflows/research-workflow/.claude/` — template configs; not normally read in active sessions

---

## Finding 1: Unignored working notes from prior audits

**Issue:** The `audits/working/` directory contains intermediate artifacts from prior audit sessions (e.g., `setup-scan-*.md`, `audit-working-notes-*.md` from 2026-04-21, `permission-sweep-*.md`, etc.). These are NOT covered by any `Read(...)` deny rule and could be accidentally read during future audit runs.

**Evidence:**
- `audits/working/setup-scan-bssp-archives-b-2026-04-21.md` (602 lines)
- `audits/working/setup-scan-ai-resources-2026-04-21.md` (396 lines)
- `audits/working/audit-working-notes-workflow-research-pipeline-five-stage-buy-side.md` (342 lines)
- `audits/working/innovation-sweep-buy-side-service-plan-2026-04-27.md` (290 lines)
- `audits/working/permission-sweep-2026-04-24.md` (429 lines)
- Plus 15+ more dated working notes from April (various dates)

All are dated April 2026 or earlier; none appear to be from ongoing work.

**Should Claude read?** NO. These are working artifacts from prior audit sessions and should not clutter the context of future audits.

**Parent directory covered by Read() deny?** NO. `audits/working/` is not covered by any rule.

**Severity:** MEDIUM — These files are dated and accumulating (each audit cycle adds new ones). While individual files might not be read in every session, the absence of a deny rule means they are discoverable during Glob/Grep operations and could be read if an operator runs a broad file search or if an audit rerun accidentally loads prior working notes.

**Recommendation:** Add `Read(audits/working/**)` to the deny list in `.claude/settings.json`. Per operator constraint: this is narrower than blanket `Read(audits/**)` and aligns with the intent to keep active audit reports readable for `/friday-act`, `/risk-check`, `/token-audit` while protecting working intermediate artifacts.

---

## Finding 2: Large generated prior-audit reports in audits/

**Issue:** The `audits/` directory contains 10+ generated reports from prior audit sessions (token-audit-*, repo-due-diligence-*, claude-md-audit-*). These are outputs that accumulated from 2026-04-06 through 2026-04-27. While they are intentionally NOT covered by a deny rule (per the carve-out to support /friday-act, /risk-check, /token-audit), they represent a notable accumulation of non-essential context that grows with each audit cycle.

**Evidence:**
- `audits/token-audit-2026-04-18-ai-resources.md` (647 lines, 10381 words) — ~13,496 tokens
- `audits/token-audit-2026-04-18-project-buy-side-service-plan.md` (511 lines, 7324 words) — ~9,521 tokens
- `audits/token-audit-2026-04-24-ai-resources.md` (351 lines, 3641 words) — ~4,733 tokens
- `audits/repo-due-diligence-2026-04-11.md` (857 lines, 6326 words) — ~8,224 tokens
- `audits/repo-due-diligence-2026-04-12.md` (824 lines, 6883 words) — ~8,948 tokens
- `audits/repo-due-diligence-2026-04-18-ai-resources.md` (739 lines, 5889 words) — ~7,656 tokens
- `audits/repo-due-diligence-2026-04-21-project-obsidian-pe-kb.md` (710 lines, 5596 words) — ~7,275 tokens
- `audits/repo-due-diligence-2026-04-27-project-repo-documentation.md` (614 lines, 5514 words) — ~7,168 tokens
- `audits/repo-due-diligence-2026-04-27-workflow-research-workflow.md` (669 lines, 5412 words) — ~7,036 tokens
- `audits/claude-md-audit-2026-04-20-project-buy-side-service-plan.md` (340 lines, 4726 words) — ~6,144 tokens
- Plus 1 additional repo-due-diligence report (2026-04-06, 691 lines)

**Total estimated tokens in these 11 reports:** ~92,001 tokens

**Should Claude read?** NO, for routine sessions. Intentionally readable only for tools like /friday-act, /risk-check, /token-audit that need to review prior audit state.

**Parent directory covered by Read() deny?** NO, per intentional carve-out.

**Severity:** MEDIUM — This is a **trade-off finding**, not a defect. The carve-out is intentional and justified (audits need to read prior reports). However, it means this large body of content (~92k tokens) is discoverable to Claude Code on every session and could be accidentally read during broad exploratory operations. The operator has accepted this trade-off to support audit workflows.

**Note on boundary condition:** The word-count estimate (word × 1.3) for these files carries ±30% drift per the token-estimation caveat. Actual token costs may be 10–20% lower or higher. Several of these files fall near the MEDIUM/HIGH severity boundary (400–800 lines). This is noted for the main session's Section 10 confidence rating.

**Recommendation:** No immediate action (carve-out is intentional). Document the trade-off in procedure docs for future reference.

---

## Finding 3: Large active session logs growing without bounds

**Issue:** The `logs/` directory contains three active session logs that grow on every session:
- `logs/decisions.md` (400 lines, 6583 words) — ~8,558 tokens
- `logs/session-notes.md` (513 lines, 6116 words) — ~7,951 tokens
- `logs/usage-log.md` (376 lines, 5648 words) — ~7,342 tokens

Combined: ~23,851 tokens of constantly-growing session context. These files are intentionally readable (they support continuity across sessions), but they are NOT rotated or archived automatically. As they grow, they increase the per-session context cost.

**Should Claude read?** YES, intentionally (they are active session records).

**Parent directory covered by Read() deny?** Partially — only `logs/*-archive-*.md` is covered; active logs are intentionally readable per operator guidance.

**Severity:** MEDIUM — Not a deny-rule issue (correct that they're readable), but a SIZE issue. As these logs accumulate over weeks/months, they become a constant context cost on every session. The protocol asks: "Are there large files (>200 lines) that Claude Code might read during exploration and shouldn't?" These logs are >200 lines each and WILL be read on every session (not just "might be"). They're intentionally readable, but they grow unbounded.

**Evidence of growth:** `logs/session-notes.md` is now 513 lines (2026-05-02), up from typical values of 400–500 lines. `logs/decisions.md` is 400 lines. Per the coaching logs (`logs/coaching-data.md`), these files have been accumulating for months.

**Recommendation:** Implement automated rotation. When `logs/session-notes.md` or `logs/decisions.md` exceed 600 lines, archive to `logs/session-notes-archive-YYYY-MM.md` and `logs/decisions-archive-YYYY-MM.md` (which are already covered by the `logs/*-archive-*.md` deny rule). This keeps active logs under ~200 lines each and preserves history in archived variants.

---

## Finding 4: Missing deny rule for audits/working/**

**Issue:** Per the operator's 2026-05-01 decision note (referenced in preflight), the correct fix for protecting audit working notes is narrower than blanket `Read(audits/**)`. The right rule is `Read(audits/working/**)` — protecting ONLY the intermediate working artifacts while keeping active audit reports readable for workflows.

Currently, `audits/working/**/` is NOT covered by any deny rule.

**Should Claude read?** NO. These are intermediate outputs from prior audits and should not clutter future audit runs.

**Severity:** MEDIUM — Unignored intermediate files from prior sessions can be accidentally discovered during Glob/Grep searches or broad file explorations, adding unnecessary context and potentially causing confusion (e.g., "which version of this audit is current?").

**Recommendation:** Add `Read(audits/working/**)` to the `.claude/settings.json` deny list. This is a surgical fix that does not interfere with the intentional carve-out for active audit reports (token-audit-*.md, repo-due-diligence-*.md, etc.).

**Implementation:**
```json
"deny": [
  "Bash(rm -rf *)",
  "Bash(sudo *)",
  "Bash(git push*)",
  "Read(archive/**)",
  "Read(audits/working/**)",  // ADD THIS LINE
  "Read(logs/*-archive-*.md)",
  "Read(inbox/archive/**)",
  "Read(**/deprecated/**)",
  "Read(**/old/**)"
]
```

---

## Finding 5: Deprecated and draft files in workflows/research-workflow/.claude/commands/

**Issue:** The file `./workflows/research-workflow/.claude/commands/produce-prose-draft.md` (222 lines) has `draft` in the name, suggesting it may be a template or draft command rather than a canonical one. If this is a deprecated or experimental variant, it should either be clearly documented or archived.

**Evidence:**
- Filename: `produce-prose-draft.md` (contains "draft")
- Size: 222 lines, 3695 words (~4,804 tokens)
- Location: `workflows/research-workflow/.claude/commands/` (workflow-specific, not canonical)

**Should Claude read?** Unclear without reviewing the file content. If it's an active workflow command, yes. If it's a deprecated variant, no.

**Severity:** LOW — Presence of "draft" in the name suggests it may not be production-ready. The file is workflow-specific (not in canonical `.claude/commands/`), which suggests it may be a template or variant.

**Recommendation:** Review the file to determine if it is:
1. An active workflow command (keep as-is, consider removing "draft" from name if production-ready)
2. A template or experimental variant (move to a `drafts/` subdirectory or mark as deprecated)
3. A superseded variant (archive or delete if a newer version exists)

---

## Finding 6: Large active command files lack explicit scoping

**Issue:** Several large command files are loaded whenever the command is invoked. While these are "should read" files (they're active commands), they lack explicit guidance on whether the command itself should read external files or delegate file-reading to subagents. This is not a deny-rule issue but a workflow-efficiency issue.

**Evidence:**
- `./.claude/commands/new-project.md` (527 lines, 5279 words) — large command that may pull in multiple files
- `./.claude/commands/friday-checkup.md` (391 lines, 3560 words) — large command, invoked weekly
- `./.claude/commands/deploy-workflow.md` (353 lines, 2996 words) — large command

These commands themselves are not >200 lines of unnecessary content, but the lack of explicit file-scoping guidance means that when invoked, they might load additional large files into the main session rather than delegating to subagents.

**Should Claude read?** YES, when the command is invoked. But the command should have internal guidance on when to delegate file reads to subagents vs. loading in the main session.

**Severity:** LOW — Not a denying rule issue. This is a workflow-efficiency pattern that would be addressed by better documentation in the command files themselves (e.g., "If >3 files need to be read, delegate to a subagent"). Not a file-handling pattern per se, but a consequence of large command files.

**Recommendation:** No immediate action required. Defer to command-documentation improvements (if any) planned in Section 8 or 9.

---

## Summary: Unignored large files (>200 lines) in directories NOT covered by Read() deny rules

**Files that SHOULD NOT be read but are currently unignored:**

| File | Lines | Status | Parent dir | Recommend deny? |
|------|-------|--------|-----------|-----------------|
| ./audits/working/setup-scan-bssp-archives-b-2026-04-21.md | 602 | intermediate | audits/working/ | YES — add Read(audits/working/**) |
| ./audits/working/setup-scan-ai-resources-2026-04-21.md | 396 | intermediate | audits/working/ | YES |
| ./audits/working/audit-working-notes-workflow-research-pipeline-five-stage-buy-side.md | 342 | intermediate | audits/working/ | YES |
| ./audits/working/permission-sweep-2026-04-24.md | 429 | intermediate | audits/working/ | YES |
| ./audits/working/innovation-sweep-buy-side-service-plan-2026-04-27.md | 290 | intermediate | audits/working/ | YES |

**Trade-off: Intentionally unignored (per carve-out, but noted as finding):**

| File | Lines | Status | Parent dir | Trade-off note |
|------|-------|--------|-----------|-----------------|
| ./audits/token-audit-2026-04-*.md (11 reports) | 351–647 ea. | generated output | audits/ | INTENTIONAL — needed by /friday-act, /risk-check, /token-audit. ~92k tokens total. |
| ./audits/repo-due-diligence-*.md (11 reports) | 691–857 ea. | generated output | audits/ | INTENTIONAL — same reason. |

**Intentionally readable (not a deny-rule issue, but growing):**

| File | Lines | Status | Parent dir | Recommendation |
|------|-------|--------|-----------|-----------------|
| ./logs/session-notes.md | 513 | active log | logs/ | INTENTIONAL, but implement rotation when >600 lines |
| ./logs/decisions.md | 400 | active log | logs/ | INTENTIONAL, but implement rotation when >600 lines |
| ./logs/usage-log.md | 376 | active telemetry | logs/ | INTENTIONAL, but implement rotation when >600 lines |

---

## Protocol gaps

None identified. Section 6 instructions were clear and executable.

## Audit cost note

This section (6) required two large file scans via Bash (`find ... wc -w` and `find ... wc -l`), plus reading the preflight notes file and `.claude/settings.json`. Total estimated cost: ~2–3k tokens (Bash output parsing + file reads). Subagent delegation was not necessary — all analysis completed inline.
