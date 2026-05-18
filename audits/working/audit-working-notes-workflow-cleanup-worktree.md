# Section 4 — Workflow Token Efficiency Audit: /cleanup-worktree

**Audit date:** 2026-05-18 (re-audit)
**Audit root:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
**Workflow audited:** `/cleanup-worktree` (single-workflow Section 4 invocation)
**Protocol:** `ai-resources/audits/token-audit-protocol.md` v1.3, Section 4
**Telemetry:** No session-usage-analyzer data referenced. All "typical" estimates are STRUCTURAL INFERENCES derived from workflow instructions and file-loading patterns, not observed data.
**Token estimation:** word count × 1.3 proxy (±30% drift per protocol header caveat). Findings within ±15% of a severity threshold tagged `(boundary)`.

---

## Step 4.2 — Token Flow Mapping

### 1. What gets loaded at workflow start?

**Phase A — Mandatory command + skill load (Steps 1–3):**

| File | Lines | Words | Est. tokens (×1.3) |
|---|---|---|---|
| `.claude/commands/cleanup-worktree.md` | 165 | 2,814 | ~3,658 |
| `skills/worktree-cleanup-investigator/SKILL.md` | 247 | 3,618 | ~4,703 |
| **Subtotal (every run, mandatory floor)** | **412** | **6,432** | **~8,361** |

Workspace/project CLAUDE.md loaded ambiently (not workflow-specific; not measured here).

**Phase B — On-demand reference files (Steps 4, 5, 6, 7, 9, 11):**

| File | Lines | Words | Est. tokens | When loaded |
|---|---|---|---|---|
| `references/decision-taxonomy.md` | 230 | 2,027 | ~2,635 | Step 4 — first path classification |
| `references/execution-protocol.md` | 337 | 4,548 | ~5,912 | Step 5 (§1 + plan schema); Step 6 (§3); Step 7 (§4); Step 9 (§6); Step 11 (§7+§8 per destructive op, §11 for commit split) |
| `scripts/find-template.sh` | 129 | 498 | ~647 | NEVER read into context — executed only (SKILL.md line 100: "EXECUTE, do not read") |

Skill design says "load sections on demand, not whole file." But `execution-protocol.md` has 7+ distinct trigger points spanning Steps 5/6/7/9/11. In a typical 45–90 min run covering 10–14 paths with multiple destructive operations, cumulative section reads likely approach the full ~5,912 tokens.

**Cumulative reference load (typical run):** ~8,547 tokens combined (2,635 + 5,912).

**Phase C — Agent definitions (loaded when each subagent fires; live in subagent context, not main):**

| Agent | Lines | Words | Est. tokens | Spawned per typical run |
|---|---|---|---|---|
| `qc-reviewer.md` | 138 | 1,192 | ~1,550 | 1–2× (1st QC + optional 2nd QC) |
| `triage-reviewer.md` | 88 | 707 | ~919 | 1× |

These do NOT enter main-session context but each spawn incurs their definition load in subagent context.

**Total estimated start-of-workflow context (main session):**
- Mandatory floor (cmd + skill): **~8,361 tokens**
- Realistic ceiling with on-demand references resolved across full run: **~16,908 tokens**
- Plus per-path file reads (10–14 dirty paths × variable size; rough estimate ~4,000–7,000 tokens for medium-sized files).

### 2. Subagent call count per run

| Subagent | Step | Fires when? |
|---|---|---|
| 1st QC (`qc-reviewer`) | Step 6 | ALWAYS |
| Triage (`triage-reviewer`) | Step 7 | ALWAYS |
| 2nd QC (`qc-reviewer`) | Step 9 | UNLESS quick-tier skip applies (zero hard gates AND zero new file-content claims in revision) |
| Additional QC/revision loop | Step 9 → loop to Step 8 | Up to 2 extra full revision cycles before forced stop on cycle 3 |

**Baseline (typical, with hard gates or factual-claim revisions):** 3 subagents per run.
**Quick-tier minimum:** 2 subagents (1st QC + triage; 2nd QC skipped).
**Worst case (no convergence):** up to 5 subagents (1st QC + triage + 2nd QC#1 + 2nd QC#2 + 2nd QC#3 forced stop).

**Note on "plan mode":** Plan mode is NOT a subagent — it is a mode the main session operates in. The agent operator brief identifies "plan-mode + qc-reviewer + triage-reviewer + optional 2nd QC = 3-4 subagents per run." Plan mode does not contribute to subagent count; it does mean the plan content lives in main-session context throughout Steps 5–11 (see F3 below).

### 3. Subagent return volume

Per command spec, each QC/triage subagent writes its full report to disk and returns ≤20-line summary + absolute path:

| Subagent | Spec reference | Output to disk | Return to main |
|---|---|---|---|
| 1st QC | Step 17 | `<PLAN_PATH>.qc-pass-1.md` | ≤20-line summary + path |
| Triage | Step 21 | `<PLAN_PATH>.triage.md` | ≤20-line summary + path |
| 2nd QC | Step 26 | `<PLAN_PATH>.qc-pass-2.md` | ≤20-line summary + path |

**Estimated return volume per subagent:** ~260 tokens (20 lines × ~10 words avg × 1.3).
**Total per-run subagent return:** ~520–780 tokens.

**Verdict:** Workflow correctly implements the output-to-disk pattern per `ai-resources/CLAUDE.md → Subagent Contracts`. No HIGH-severity "subagent returning >200 lines to main session" finding.

**Plan-mode caveat (operator brief item 5):** Plan-mode output IS main-session context. Plan files are large by schema design (8 mandatory sections, including per-path classification table for 10–14 paths, hard-gate inventory, commit split, execution-time re-verification checklist, bias-counter checklist, revision history). Cannot be delegated — the agent IS the plan author. Estimated plan file size for a 10–14 path session: 100–250 lines / ~1,000–2,500 tokens. This is structural to plan mode, not a workflow defect.

### 4. QC/refinement multiplier

Per Step 9 exit criteria:
- Clean → proceed.
- MINOR only → proceed (issues logged in Section 8).
- BLOCKING → loop back to Step 8 revise. Max 2 full revision cycles. Cycle 3 = forced stop.

**Typical run inference:** 0–1 revision cycles for most invocations. Total main + subagent sessions per typical run: 4 (main + 1st QC + triage + 2nd QC). Within the ≤3 threshold from Section 4 severity rules ("Consistent need for >3 refinement cycles → MEDIUM").

### 5. File-read mapping

| Read | Where | Necessary or delegable? |
|---|---|---|
| `git status --porcelain=v1` | Main, Step 4 | Necessary — drives classification loop |
| Each dirty file content (full) | Main, Step 4 | Necessary — Bias Counter 1 ("never fabricate file details") requires main-agent re-read before classification |
| `git show HEAD:<path>` for deleted paths | Main, Step 4 | Necessary — recover last-tracked content for deletion classification |
| `find-template.sh` per applicable path | Main, Step 4 | Necessary — script EXECUTION (not read into context); output is short verdict line |
| `.gitignore` | Main, Step 4 | Necessary — short, behavioral |
| `decision-taxonomy.md` (230 lines / ~2,635 tokens) | Main, Step 4 | Necessary — classification rules; cannot be delegated (classification IS the main agent's work) |
| `execution-protocol.md` sections (337 lines / ~5,912 tokens cumulative) | Main, Steps 5/6/7/9/11 | Necessary at trigger points; cumulative load approaches full file in a typical run |
| Plan file by QC + triage subagents | Subagent | DELEGATED correctly (PLAN_PATH passed; not inlined per Step 15) |
| QC report by triage subagent | Subagent, Step 7 | DELEGATED correctly (QC_REPORT_PATH passed) |
| Post-commit filesystem verification | Main, Step 11 (Step 31) | Necessary — Step 31 explicitly requires filesystem verification, not git status/diff |

**Assessment:** No flagged "large file (>100 lines) main-session read that could be delegated." Each main-session read is structurally necessary. The skill's bias counters explicitly require main-session content access — delegating per-path reads would break the safety contract.

### 6. File-write mapping

| Write | Where | To disk? |
|---|---|---|
| Plan file `~/.claude/plans/cleanup-worktree-<TS>.md` | Main, Step 5 | YES |
| QC report (1st) | Subagent, Step 6 | YES |
| Triage report | Subagent, Step 7 | YES |
| QC report (2nd) | Subagent, Step 9 | YES |
| Pre-plan scratchpad (conditional) | Main, post-Step 4 | YES (only if >50% context) |
| Post-triage scratchpad (conditional) | Main, post-Step 7 | YES (only if >50% context) |
| Plan revisions | Main, Step 8 (`Edit` on plan file) | YES |
| Commits | Main, Step 11 | git-tracked filesystem writes |

**Verdict:** No "large output written to context rather than disk" anti-pattern.

---

## Findings

| # | Finding | Severity | Evidence | Waste mechanism |
|---|---|---|---|---|
| F1 | Command (165 lines, ~3,658 tokens) + SKILL.md (247 lines, ~4,703 tokens) combined mandatory load is ~8,361 tokens per invocation. Loads every run before any work begins. | **MEDIUM** | `wc` measurements; SKILL.md at 247 lines is in the 150–300 MEDIUM band per Section 2 severity rules. Command at 165 lines is over 150-line guideline but well under 300-line HIGH cutoff. | Per-invocation startup cost; recurs every workflow execution. Substantial portions of SKILL.md (Workflow overview, Example, Validation Loop, Cross-References, Known Pitfalls, Runtime Recommendations) are arguably skill-discovery or post-execution content rather than per-turn-needed instructions. |
| F2 | `execution-protocol.md` reference file at 337 lines / ~5,912 tokens. Loaded on-demand per skill design, but trigger points span Steps 5/6/7/9/11 (7+ triggers in a typical run). Cumulative load approaches full file. | **HIGH (boundary)** | `wc`: 337 lines is 12.3% above the 300-line HIGH threshold from Section 2; within ±15% boundary band per protocol token-estimation caveat → confidence MEDIUM, classification may flip under real tokenizer. | "On-demand" loading degrades when triggers are dense across workflow life-cycle. |
| F3 | Plan-mode written content lives in main-session context across Steps 5–11. For a 10–14 path session: 8-section schema accumulates ~100–250 lines / ~1,000–2,500 tokens of main-session-resident plan content. Cannot be delegated — agent IS the plan author. | **MEDIUM (structural)** | Step 5 schema enumerates 8 mandatory sections; Step 13 verifies all 8 present; Step 8 (revision) accumulates Section 8 entries; plan stays in context until Step 10 ExitPlanMode and through Step 11 execution. | Plan mode = main-session output IS the context. Cannot be optimized without changing the plan-mode safety contract. |
| F4 | Subagent return volume (≤20-line summary + path × 3 subagents = ~520–780 tokens per run). Workflow correctly implements output-to-disk pattern. | **LOW (positive control)** | Steps 17, 21, 26 each specify `≤20-line structured summary` + write full report to `<PLAN_PATH>.qc-pass-{1,2}.md` / `.triage.md`. | No waste — desired pattern. Logged for completeness. |
| F5 | QC → triage auto-loop runs every invocation (1st QC always + triage always + 2nd QC unless quick-tier skip). 3 subagent spawns per typical run; worst case 5 (cycle-3 forced stop). | **LOW** | Steps 6–9 sequential; Step 25 quick-tier skip condition; Step 27 max 2 revision cycles. | Cumulative subagent cost is significant but bounded; structural safety property, not a waste pattern. |
| F6 | Compact breakpoints (2 conditional, at Step 4 pre-plan and Step 7 post-triage). Both fire only above ~50% context. | **PASS / not flagged** | Step 11 (Compact breakpoint pre-plan) and Step 21 (Compact breakpoint post-triage). | Adequate coverage. |
| F7 | `find-template.sh` bundled as EXECUTABLE only, NOT read into context. SKILL.md explicitly says "EXECUTE, do not read." | **PASS / positive control** | SKILL.md "Bundled Scripts" section. | No waste — correctly delegated to bash. |

---

## Severity tally

- HIGH: 1 (F2, boundary)
- MEDIUM: 2 (F1, F3)
- LOW: 2 (F4, F5)
- PASS (positive controls; not findings): 2 (F6, F7)

**Total flagged findings: 5** (1 HIGH-boundary + 2 MEDIUM + 2 LOW).

---

## Cumulative per-run token cost estimate (structural inference, no telemetry)

Per `/cleanup-worktree` invocation:

| Component | Tokens (est.) |
|---|---|
| Mandatory command + skill load | ~8,361 |
| Reference file loads (cumulative across triggers) | ~5,000–8,547 |
| Per-path file reads (10–14 paths, varied size) | ~4,000–7,000 |
| Plan file content (main-session-resident) | ~1,000–2,500 |
| Subagent returns (≤20-line summaries × 3) | ~520–780 |
| Subagent definitions (in subagent contexts, not main) | ~4,019 (cross-context) |
| **Main-session total (typical run)** | **~18,881–26,688 tokens** |

Plus workspace/project CLAUDE.md ambient load (not workflow-specific).

This is a heavy workflow per invocation. Most of the cost is structurally necessary (per-path content reads required by Bias Counter 1; plan-mode content non-delegable; reference rules non-delegable from classification logic). The optimizable surface is primarily F1 (SKILL.md size) and F2 (execution-protocol.md size).

---

## Boundary notes

- **F2 (boundary):** `execution-protocol.md` 337 lines vs. 300-line HIGH threshold = 12.3% above → within ±15% boundary. Confidence MEDIUM; may classify as MEDIUM under a real tokenizer.
- **F1:** SKILL.md 247 lines is 17.7% below the 300-line HIGH threshold → just outside the ±15% boundary band. Confidence higher in MEDIUM classification.

---

## Protocol gaps (Section 4 underspecified for this workflow shape)

1. Section 4 severity rules target "subagent returning >200 lines to main session" — this workflow has no such pattern (≤20-line summaries enforced). Protocol does not provide a severity rule for "command + skill mandatory load size per invocation." F1 classified by analogy to Section 2 skill-size thresholds.
2. Protocol does not enumerate severity for "reference files bundled with a skill exceeding the 300-line skill threshold." F2 classified by analogy and flagged (boundary).
3. Plan-mode context cost (F3) is not directly addressed by Section 4 severity rules. Classified MEDIUM (structural) as an inference flag for main-session Section 9 awareness.
4. Section 4 does not provide a severity rule for "QC auto-loop runs every invocation" — F5 classified LOW because the workflow correctly implements output-to-disk and the loop is the load-bearing safety contract.
