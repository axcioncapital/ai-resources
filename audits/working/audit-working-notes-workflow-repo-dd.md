# Section 4 — Workflow Token Efficiency Audit: /repo-dd

**Audit root:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
**Workflow:** `/repo-dd` (`.claude/commands/repo-dd.md`)
**Date:** 2026-05-18
**Estimation caveat:** all token figures use word × 1.3 proxy; ±30% drift possible per protocol header.

---

## Workflow files surveyed

| File | Lines | Words | Est. tokens |
|------|-------|-------|-------------|
| `.claude/commands/repo-dd.md` | 318 | 2,714 | ~3,528 |
| `.claude/agents/repo-dd-auditor.md` | 76 | 519 | ~675 |
| `.claude/agents/dd-extract-agent.md` | 68 | 367 | ~477 |
| `.claude/agents/dd-log-sweep-agent.md` | 110 | 410 | ~533 |
| `audits/questionnaire.md` (read by repo-dd-auditor) | 146 | 1,580 | ~2,054 |

The command file itself is 318 lines — at the HIGH-threshold boundary (≥300 lines) per Section 3 thresholds, though Section 4 doesn't classify command size; noted for cross-reference.

---

## Context loading chain

### Workflow start (any tier)

1. CLAUDE.md (workspace) loads — constant across workflows; not measured here.
2. CLAUDE.md (ai-resources) loads — constant; not measured here.
3. `/repo-dd` slash command body loads → `.claude/commands/repo-dd.md` → **~3,528 tokens**.
   - The full 318-line command body enters main-session context at invocation.
4. No skills are auto-triggered by `/repo-dd` itself. Skill loading is implicit only via the questionnaire-driven audit done by the subagent (which runs in fresh context, not main).

**Estimated start-of-workflow context cost beyond CLAUDE.md:** ~3,528 tokens.

### Per tier — additional main-session loads

**Standard (Steps 1–7):**
- Step 10: REPORT_PATH is verified by existence check only — NOT read into main. Correct.
- Step 14: EXTRACT_PATH is read into main (`dd-extract.md`). Size depends on findings count; structured restatement, typically 100-200 lines. Necessary for triage.
- Step 23: After each fix, modified file is read back to verify (one Read per fix). Bounded by AUTO-FIX count (one-file changes only).

**Deep (Steps 8–12 added):**
- Step 33: Re-reads EXTRACT_PATH for deep-tier sections (1.2, 2, 3.4, 5.1, 5.2). Pattern is correct (no full DD_REPORT re-read), but the extract is read a SECOND time in main session.
- Step 48: Reads SWEEP_PATH (log-sweep.md) into main.
- Step 56: Writes DEEP_REPORT_PATH (write, not load).

**Full (Step 13 added):**
- Step 62: Reads EXTRACT_PATH §1.7 again (THIRD read of the extract).
- Step 63: For each canonical/deployed file pair, reads both files in main session to compare content. Number of pairs depends on the workspace — could be 10s of skill/workflow templates. NO subagent delegation. Each read is in main session. Files are typically <100 lines (SKILL.md, command bodies), so individually they do not breach the 100-line single-file threshold from Section 4; cumulatively this is meaningful.
- Step 67: Reads DEEP_REPORT_PATH (the file the workflow just wrote) to splice in Section 4 results. Self-read for edit — acceptable pattern.

---

## Subagent calls per tier

| Tier | Subagent | Return content | Return size (est.) | Severity |
|------|----------|----------------|--------------------|----------|
| All | `repo-dd-auditor` | Total findings count, breakdown by type, REPORT_PATH | <10 lines (per contract) | LOW |
| All | `dd-extract-agent` | EXTRACT_PATH, total findings count, severity breakdown | <10 lines | LOW |
| Deep/Full | `dd-log-sweep-agent` | SWEEP_PATH, 4 counts | <10 lines | LOW |

**Total subagents per tier:**
- Standard: 2
- Deep: 3
- Full: 3 (same as deep; pipeline tests are inline)

**Subagent return volume assessment:** All three subagents follow the disk-write + summary-return contract documented in ai-resources/CLAUDE.md § Subagent Contracts. None return >200 lines. Per protocol Section 4 severity rule, all three PASS the "Subagent returning >200 lines to main session → HIGH" check.

---

## File-read map across all tiers

| File | Tier | Read in main/subagent | Necessary / Delegable? | Notes |
|------|------|-----------------------|------------------------|-------|
| `audits/questionnaire.md` (146 lines) | All | subagent (repo-dd-auditor) | necessary | Subagent-internal; never enters main. PASS. |
| `REPORT_PATH` (DD report, ~935 lines for recent ai-resources scope) | All | NOT in main (delegated to dd-extract-agent) | necessary, delegated | Correctly delegated. PASS. |
| `PREVIOUS_AUDIT` (prior DD report, similar size) | All | subagent (repo-dd-auditor) for DELTA notes | necessary | Read in subagent context only. PASS. |
| `EXTRACT_PATH` (dd-extract.md) | All | main | necessary | Step 14. Required for triage. PASS. |
| `EXTRACT_PATH` (re-read) | Deep | main | necessary but redundant | Step 33 re-reads for deep-tier sections. Compaction at Step 7 (between tiers) justifies re-read. PASS with note. |
| `EXTRACT_PATH` (third read) | Full | main | necessary but redundant | Step 62 reads §1.7 for symlinks. Same compaction justification (compact between deep and full at Step 60). PASS with note. |
| `SWEEP_PATH` (log-sweep.md) | Deep/Full | main | necessary | Step 48. Bounded structured summary. PASS. |
| Logs (`friction-log.md`, `improvement-log.md`, `session-notes.md`, `coaching-log.md`, `workflow-observations.md`, `decisions.md`, `innovation-registry.md`) | Deep/Full | subagent (dd-log-sweep-agent) | necessary, delegated | Correctly delegated. session-notes.md is typically large — this delegation is the key token-saving mechanism in deep tier. PASS. |
| Modified files (fix verification) | All | main | necessary | Step 23 — one Read per fix. Bounded by AUTO-FIX count. PASS. |
| Canonical/deployed file pairs | Full | main (Step 63) | partially delegable | Template-sync test iterates every canonical/deployed pair and reads both in main. Could be delegated to a pipeline-test-agent that returns identical/diverged verdicts only. As-is, full-tier main context accumulates pair contents. |
| `DEEP_REPORT_PATH` (self-read for edit) | Full | main | necessary | Step 67 — required to splice pipeline results. PASS. |

---

## Compaction breakpoints

The workflow defines two explicit compaction checkpoints in command text:

1. **After Step 30** (between standard and deep tiers): `▸ Context checkpoint: The factual audit has accumulated context. Before proceeding to the deep tier, run /compact to clear it.`
2. **After Step 60** (between deep and pipeline-testing tiers): `▸ Context checkpoint: Before pipeline testing, run /compact to clear the deep assessment context.`

Both are marker-only — not enforced. Per protocol Section 4 ("missing /compact opportunities"), these breakpoints exist, so the workflow PASSES on this dimension. They are advisory (no mechanism in the command halts execution or auto-compacts).

Severity: **LOW** — breakpoints are defined; enforcement gap is a Claude Code platform limitation, not a workflow flaw.

---

## QC / refinement multiplier

Standard tier: 0 QC subagents designed in. The factual audit relies on `repo-dd-auditor`'s independence as the QC mechanism (fresh-context isolation). Triage is operator-gated.

Deep tier: no QC subagent. Operator review at Step 56 / final summary is implicit QC.

Full tier: no QC subagent.

**Total sessions per run:**
- Standard: 1 main + 2 subagents = 3 contexts
- Deep: 1 main + 3 subagents = 4 contexts
- Full: 1 main + 3 subagents = 4 contexts (pipeline tests inline)

No tier exceeds 3-cycle refinement threshold. PASS on refinement-multiplier dimension.

---

## EXTRACT_PATH pattern assessment

**Pattern:** subagent (`dd-extract-agent`) reads full DD_REPORT once, writes structured extract to disk. Main session reads ONLY the extract, never the full report.

**Token savings (illustrative):** A typical ai-resources DD report is ~935 lines (2026-05-08 example, 23,786 bytes). Extract is ~100-200 lines (verbatim findings + 6 small sections). Savings: ~700-800 lines (~7,000+ tokens estimated) per deep-tier execution. Pattern is well-designed.

**Note:** EXTRACT_PATH is read up to 3 times in deep+full tier (Steps 14, 33, 62). Compaction between tiers justifies re-reads — without compaction the workflow could read it once and retain. With compaction, re-read is correct. PASS.

---

## Deep-tier chain assessment

Chain: `repo-dd-auditor` → DD_REPORT (disk) → `dd-extract-agent` → EXTRACT_PATH (disk) → main (Step 14, 33, 62) and `dd-log-sweep-agent` → SWEEP_PATH (disk) → main (Step 48).

All three subagents write to disk and return path + bounded summary. Chain is correctly designed — no full payload returns to main. PASS on subagent return volume.

---

## Polluted-context risk from prior audits (Read(audits/**) gap)

**Finding (HIGH):** Prior /repo-dd outputs and adjacent audit artifacts in `audits/` are NOT protected by Read() deny rules.

Evidence from `ai-resources/.claude/settings.json`:
```
"deny": [
  "Read(archive/**)",
  "Read(logs/*-archive-*.md)",
  "Read(inbox/archive/**)",
  "Read(**/deprecated/**)",
  "Read(**/old/**)"
]
```

`audits/` is missing. Per Section 0.3 expected-coverage list, `audits/` is an explicit expected directory.

**Existing audit artifacts in `ai-resources/audits/` that could pollute future /repo-dd sessions via Glob/Grep/Read:**

- 18 prior `repo-due-diligence-*.md` reports (workspace + scoped)
- 3 prior `repo-dd-deep-*.md` reports (`repo-dd-deep-2026-04-06.md` = 245 lines / 18,838 bytes)
- Recent scoped DD report: `repo-due-diligence-2026-05-08-ai-resources.md` = 935 lines / 23,786 bytes
- Plus 30+ adjacent audit artifacts (`claude-md-audit-*`, `friday-checkup-*`, `friday-journal-*`, `log-sweep-*`, `permission-sweep-*`, `innovation-sweep-*`, etc.) — all unrestricted.

**Pollution mechanisms:**
- The `repo-dd-auditor` subagent does NOT directly read these (its scope is AUDIT_ROOT minus audit reports; Step 8 of /repo-dd locates PREVIOUS_AUDIT by exact-path regex, not Glob).
- However, the main session at Steps 14, 33, 48, 62, 67 operates in a context where Glob/Grep against `audits/**` is unrestricted. Any incidental search (e.g., operator follow-up after Step 21 gate, or workflow expansion) can pull large stale reports.
- Generic agent skills/commands invoked downstream from /repo-dd outputs (e.g., post-audit follow-ups, "what did the last audit say") could Grep into `audits/` and load historical content unexpectedly.

**Severity:** HIGH per protocol Section 0.3 (some Read() denies exist but `audits/` is a missing expected-coverage directory). Cross-references Sections 6 and 7 of the full token audit.

Note: Section 4 itself flags this only as it relates to workflow execution; the canonical finding lives in Sections 0.3 / 6 / 7.

---

## Findings table

| # | Finding | Severity | Waste mechanism |
|---|---------|----------|----------------|
| 1 | `audits/` directory not covered by Read() deny rule despite holding 30+ historical audit reports including /repo-dd outputs of up to 935 lines / ~23 KB each | HIGH | Future /repo-dd sessions, or unrelated main-session work, can Glob/Grep into `audits/` and pull large stale reports into main context. Section 0.3 expected-coverage gap, scoped to its impact on this workflow. |
| 2 | Step 63 (full-tier template-sync test) reads canonical/deployed file pairs in main session with no subagent delegation; pair count scales with deployed surface | MEDIUM | Cumulative main-session reads for diff comparison. Each individual file <100 lines so no single read breaches the protocol per-file threshold; aggregate cost grows with deployment surface. Delegable to a pipeline-test-agent returning verdicts only. |
| 3 | EXTRACT_PATH read up to 3 times across deep+full tier (Steps 14, 33, 62) | LOW (boundary) | Re-reads are justified by intervening /compact checkpoints. Tagged boundary because the line between "necessary" and "redundant" depends on whether compaction is run. |
| 4 | Compaction checkpoints at Step 30 and Step 60 are advisory markers, not enforced | LOW | Operator-dependent. Workflow defines breakpoints; lack of enforcement is platform limitation. PASSES Section 4 "missing /compact opportunities" check. |
| 5 | `/repo-dd` command file itself is 318 lines — boundary on Section 3 HIGH threshold (≥300 lines) | LOW (boundary) | Cross-reference Section 3, not Section 4. Noted for visibility. |
| 6 | Main session reads EXTRACT_PATH (Step 14) which is typically 100-200 lines depending on finding count; could grow on workspace-wide scope | LOW | Necessary for triage. No delegable alternative for the triage decision step. PASS. |

**Severity totals:** HIGH=1, MEDIUM=1, LOW=4 (2 tagged boundary).

---

## Protocol gaps

- Section 4's "Where do files get written?" measurement step is partially addressed; report-writes (REPORT_PATH, EXTRACT_PATH, SWEEP_PATH, DEEP_REPORT_PATH) are all to disk, not context. No waste mechanism identified.
- Protocol Section 4 does not define a severity for "subagent reads many small files in fresh context" — that pattern is correctly out of scope (the main-session token budget is the audit target). Noted for awareness.
- Read(audits/**) gap is technically a Section 0.3 / Section 6 / Section 7 finding. Reported here under Section 4 only because it materially affects /repo-dd execution risk; main-session synthesis should de-duplicate.
