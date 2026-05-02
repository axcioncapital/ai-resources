# Section 4 — Workflow Token Efficiency Audit: research-workflow

**Audit date:** 2026-05-02 (overwrite of 2026-05-01 prior content)
**Workflow:** research-workflow
**Scope:** `ai-resources/workflows/research-workflow/`
**Protocol:** token-audit-protocol.md v1.3, Section 4
**Token-estimation method:** word count × 1.3 (±30% drift caveat applies; findings within ±15% of a threshold tagged `(boundary)`)

---

## Workflow Identification

The research-workflow is the canonical five-stage analytical research pipeline (Preparation → Execution → Analysis & Gap Resolution → Report Production → Final Production). It is referenced extensively in the workflow's own CLAUDE.md template, with 28 commands under `.claude/commands/`, 4 agents under `.claude/agents/`, and reference docs (`stage-instructions.md`, `file-conventions.md`, `quality-standards.md`, `style-guide.md`, two embedded skills, three SOPs). Execution chains call out to ~30+ skills under `ai-resources/skills/`.

The workflow is template-based — files contain `{{PROJECT_TITLE}}`-style placeholders and are deployed into project workspaces via `auto-sync-shared.sh`. Token-flow analysis below applies to a deployed instance, not the template itself.

---

## 4.1 — Workflow Inventory and Sizes

### Top-level template files (lines / words / approx tokens at ×1.3)

| File | Lines | Words | Approx tokens |
|------|-------|-------|---------------|
| `CLAUDE.md` | 128 | 1,140 | ~1,482 |
| `SETUP.md` | 177 | 879 | ~1,143 |
| `reference/stage-instructions.md` | 155 | 2,651 | ~3,446 |
| `reference/file-conventions.md` | 142 | 950 | ~1,235 |
| `reference/quality-standards.md` | 72 | 727 | ~945 |
| `reference/style-guide.md` | 35 | 439 | ~571 |
| `reference/sops/research-executor-gpt.md` | 153 | 1,144 | ~1,487 |
| `reference/sops/evidence-pack-compressor-gpt.md` | 146 | 1,207 | ~1,569 |
| `reference/sops/fact-verification-prompt.md` | 24 | 125 | ~163 |
| `reference/skills/knowledge-file-producer/SKILL.md` | 135 | 1,113 | ~1,447 |
| `reference/skills/report-compliance-qc/SKILL.md` | 113 | 1,090 | ~1,417 |

### Commands (top 10 by size — lines / words / approx tokens)

| Command | Lines | Words | Approx tokens |
|---------|-------|-------|---------------|
| `produce-prose-draft.md` | 212 | 3,695 | ~4,804 |
| `run-execution.md` | 187 | 2,103 | ~2,734 |
| `run-analysis.md` | 182 | 1,419 | ~1,845 |
| `session-plan.md` | 163 | 933 | ~1,213 |
| `audit-structure.md` | 148 | 1,018 | ~1,323 |
| `produce-formatting.md` | 130 | 2,327 | ~3,025 |
| `produce-architecture.md` | 101 | 1,345 | ~1,749 |
| `run-report.md` | 85 | 818 | ~1,063 |
| `review-chapter.md` | 79 | 539 | ~701 |
| `produce-knowledge-file.md` | 76 | 456 | ~593 |

### Agents

| Agent | Lines | Words | Model |
|-------|-------|-------|-------|
| `improvement-analyst.md` | 88 | 715 | opus |
| `qc-gate.md` | 52 | 313 | sonnet |
| `verification-agent.md` | 40 | 212 | sonnet |
| `execution-agent.md` | 29 | 171 | sonnet |

---

## 4.2 — Token Flow Mapping

### Step 1: What gets loaded at workflow start (per-turn fixed cost)

**Always-loaded on every turn (CLAUDE.md + @-imports):**

`CLAUDE.md` (128 lines, ~1,482 tokens) contains four `@reference/...` imports:
- `@reference/stage-instructions.md` (155 lines, ~3,446 tokens)
- `@reference/file-conventions.md` (referenced via `IMPORTANT` paragraph at line 36)
- `@reference/quality-standards.md` (72 lines, ~945 tokens)
- `@reference/style-guide.md` (35 lines, ~571 tokens)

CLAUDE.md line 36 reads: "For detailed stage instructions, read @reference/stage-instructions.md. For file naming rules, read @reference/file-conventions.md. For QC standards and evidence handling, read @reference/quality-standards.md. For writing voice and style, read @reference/style-guide.md. Only load these when actively working on the relevant stage or task."

The `@` syntax in CLAUDE.md hydrates the referenced file at session start, regardless of stage. The "only load these when actively working" instruction is **inconsistent with the `@` mechanism** — see Finding F3.

**Observed start-of-session base load (CLAUDE.md + the @-imported references):** ~7,679 tokens before any command runs (~1,482 CLAUDE.md + ~3,446 stage-instructions + ~1,235 file-conventions + ~945 quality-standards + ~571 style-guide).

**Plus parent CLAUDE.md hierarchy** (workspace + ai-resources CLAUDE.md, both load via parent-traversal): adds substantial upstream context. Not specific to this workflow but compounds the base load.

### Step 2: Subagent calls per typical workflow run

A typical end-to-end run involves the following subagent invocations:

**Stage 1 — Preparation** (`/run-preparation`): 5 subagents
- task-plan-creator [delegate]
- task-plan QC [delegate-qc]
- research-plan-creator [delegate]
- answer-spec-generator [delegate]
- answer-spec-qc [delegate-qc] (runs once per spec file — typically 3–5 files = 3–5 sub-subagents)

**Stage 2 — Execution** (`/run-execution`): 4–8+ subagents
- answer-spec-qc gate [delegate-qc]
- execution-manifest-creator [delegate]
- research-prompt-creator [delegate]
- research-prompt-qc [delegate-qc]
- research-extract-creator [delegate, parallel per session — ~3–5 sessions]
- research-extract-verifier [delegate-qc, parallel per session]
- Optional 2.S supplementary: ~3 more (drafter, qc, merger) × up to 2 passes

**Stage 3 — Analysis** (`/run-cluster` × N + `/run-analysis` + `/run-synthesis`): 6 + 3N subagents minimum
- Per cluster (run-cluster): cluster-analysis-pass + cluster-memo-refiner = 2 × N clusters
  - Note: per stage-instructions.md updated Step 3.2, clusters are intended to run in parallel with path-passing to subagents. The `run-cluster.md` command file still implements content-passing and a sequential-with-compact pattern (lines 17–25). See Finding F15.
- run-analysis: gap-assessment-gate, section-directive-drafter (× N clusters), analysis-pass-memo-review, editorial-recommendations-generator, editorial-recommendations-qc, editorial-decisions-approver = 5 + N
- run-synthesis: cluster-synthesis-drafter × N clusters
- Optional 3.S gap-supplementary: 2–6 more invocations × up to 2 passes

**Stage 4 — Report Production** (`/run-report`): per-chapter subagents × M chapters
- Per chapter: evidence-to-report-writer + chapter-prose-reviewer + report-compliance-qc + citation-converter = 4 × M
- Plus architecture (research-structure-creator) + architecture-qc = 2

**Stage 5 — Final Production**: integration-qc, formatting fixes, citation reconciliation = ~5+

**Plus the prose-pipeline commands** (Part 2/3 path): `/produce-architecture` (2 subagents), `/produce-prose-draft` (4–5 subagents per section: decision-to-prose-writer, merged review, optional integration-check, decontamination, fix-agent), `/produce-formatting` (2 subagents).

**Conservative end-to-end count for a 3-cluster, 2-chapter section:** ~40 subagent invocations. For full document with all 5 stages: ~70–100+ subagent invocations.

### Step 3: Estimated subagent return-volume

**Compliance with output-to-disk pattern is mixed.** Strong implementations (✓):
- `produce-prose-draft.md` Phase 3 enforces `Output-to-disk pattern (required — subagent-contract compliance)` with explicit ≤20-line return cap and `working_file` field (lines 106–112).
- `produce-prose-draft.md` Phase 5 enforces same pattern.
- `produce-formatting.md` Phase 2 (lines 51–66) and Phase 3 (lines 96–103) enforce ≤20-line returns with `working_file` field.

**Non-compliant patterns (✗) — subagents instructed to "Return: ..." with no cap:**
- `run-preparation.md` Step 1 (line 16): "Return: output file path, key scope decisions." No cap.
- `run-preparation.md` Step 1b (line 25, qc-gate): "Return: verdict (APPROVED / REVISE) with findings." Findings list can be unbounded.
- `run-preparation.md` Step 4 (line 50, answer-spec-generator): "Return: list of spec files produced (file paths, question coverage per file)."
- `run-execution.md` Step 2.0 (line 27): "Return: routing table (question ID → tool → rationale), session groupings, execution wave plan." Full routing tables for ~10 questions could exceed 100 lines.
- `run-execution.md` Step 2.1 (line 43): "Return: the session plan table (session letters, question assignments, tool assignment, rationale)."
- `run-execution.md` Step 2.3 (line 105): "Return: list of extracts produced (question ID, file path, brief quality note)."
- `run-execution.md` Step 2.4 (line 121): "Return: per-extract verdict (APPROVED / FLAG), flagged extract details and re-extraction instructions." Re-extraction instructions can be substantial paragraphs.
- `run-cluster.md` Step 2 (line 25): "Return: output file path, key analytical themes, evidence gaps noted." Themes-and-gaps can run >50 lines.
- `run-cluster.md` Step 3 (line 35): "Return: output file path, per-check outcomes, changes made." Six-check refinement × changes-made can run long.
- `run-analysis.md` Step 2 (line 22): "Return: output file path, gap inventory (gap ID, cluster, path classification, severity)."
- `run-analysis.md` Step 4 (line 42): "Return: output file path, scarcity items referenced, key editorial decisions." Per cluster, in parallel.
- `run-analysis.md` Step 5 (line 52): "Return: output file path, editorial decisions surfaced, flags for operator attention." All editorial decisions surfaced — could be 30+ items.
- `run-analysis.md` Step 5b (line 61): "Return: output file path, recommendation count, any confidence flags."
- `run-analysis.md` Step 5c (line 70, qc-gate): "Return: output file path, verdict distribution (AGREE/DISAGREE/NUANCE counts), flagged disagreements."
- `run-analysis.md` Step 5d (lines 95–115, auto-delegate): writes structured output format directly into return — multi-section format with `## Approved Decisions`, `## Nuance Adjustments Applied`, `## Noted Alternatives`, `## Dependency Consistency Check`.
- `run-synthesis.md` Step 2 (line 24): "Return: output file path, chapter structure summary, evidence coverage notes."
- `run-report.md` Step 4.1 (line 30): "Return: architecture summary (section count, chapter-to-section mapping, structural decisions)."
- `run-report.md` Step 4.2a (line 56): "Return: chapter draft content, scarcity items addressed, evidence coverage notes." **"Chapter draft content" returned to main session — this is potentially 1,500–3,000 words returned per chapter.** (HIGH)
- `run-report.md` Step 4.2b (line 59, chapter-prose-reviewer): "Return: review verdict, findings list, recommended changes." Full findings list returned. (HIGH)
- `run-report.md` Step 4.2c (line 62, report-compliance-qc qc-gate): "Return: QC verdict (PASS/FAIL), per-item findings." Full findings list. (HIGH)
- `run-report.md` Step 4.2i (line 77, citation-converter): "Return: citation count, CTL summary."
- `review-chapter.md` Step 2 (line 49): qc-gate produces full review report in return — "Produce the findings report, verdict, priority fixes, and scarcity compliance summary" — no working-file pattern, full report returned to main session.
- `verify-chapter.md` Step 3a (line 49, evidence-prose-fixer): "Return: correction list with per-item bright-line metadata."
- `produce-architecture.md` Phase 2 (line 58): "Return: section count, processing order, flagged overlaps/conflicts/gaps, word count allocations per section." Full per-section allocations.

**Pattern summary:** Out of ~50 subagent-launch sites across the workflow's commands, only **6 sites** (in produce-prose-draft and produce-formatting) explicitly enforce the output-to-disk + ≤20-line return contract. The remaining ~44 sites use unbounded "Return: ..." instructions. Per protocol Section 4 severity, subagent returning >200 lines triggers HIGH.

### Step 4: QC/refinement cycles per workflow run

Refinement-multiplier sites:

- **Stage 2 extract verifier:** "After 2 re-extraction passes, remaining failures → confirmed evidence scarcity." Up to 2 retries per extract.
- **Stage 2 supplementary research:** "Two-pass maximum (hard constraint)" — explicit cap, but each pass is ~5 subagents.
- **Stage 3 gap supplementary:** "Loop ceiling: Max 2 passes."
- **Stage 3 editorial-recommendations:** Generator + QC + auto-approver with operator pause on DISAGREE — typical first-pass converges; DISAGREE triggers manual operator resolution.
- **`/produce-prose-draft`:** Phase 3 routing: Score 4–5 + LOW = no fix; Score 4–5 + MEDIUM+ = fix-agent; Score 3 = fix-agent + bright-line surfacing; Score 1–2 = re-run Phase 2.
- **`/produce-formatting`:** Phase 3 stage-1 fixes auto-apply, stage-1 bright-line and stage-2 SUBSTANTIVE go to operator. No automated retry loop.
- **`/run-report` Step 4.2:** Per chapter: write → review → compliance QC → operator pause → optional revisions.
- **`/verify-chapter` Step 3:** Optional correction subagent; bright-line check on each correction.

**Total typical-run cycle count:** Per chapter, expect ~3 QC subagent invocations (reviewer, compliance, optionally verify) plus optional fix-agent. Workflow design averages **~3–4 QC/refinement subagents per chapter unit** — at the MEDIUM threshold (>3 = MEDIUM per protocol).

### Step 5: File-read sites in main session

**Main-session reads of large files (instances where the main session reads files >100 lines and the read is delegable):**

1. **`run-report.md` Step 4.0** (lines 14–22): Main session reads ALL chapter drafts, scarcity register, ALL section directives, ALL refined cluster memos, ALL research extracts, AND approved editorial recommendations. Reason given (line 22): "These inputs are referenced throughout the pipeline. Sub-agents receive content, not file paths (per context isolation rules)."
   - For a typical 3-cluster section: chapter drafts (~5,000 words), 3 cluster memos (~6,000 words), ~10 research extracts (~15,000+ words), 3 directives (~3,000 words). **Estimated main-session load at Step 4.0: ~30,000+ tokens** before any subagent runs.
   - Severity: HIGH — large file reads in main session that could be delegated. The "context isolation rules" justification is structural — if subagents need content rather than paths, the *main session* doesn't need the content.

2. **`produce-prose-draft.md` Phase 4** (lines 133–138): Main session globs prose dir, reads current prose, architecture, adjacent prose sections, "Read all other completed prose sections (non-adjacent)." For 6+ completed sections this is opt-in to "opening and closing paragraphs only" but for early sections (3–5 done) reads the full set.
   - For a 5-section part: ~5 × ~1,500 words = ~7,500 words = ~9,750 tokens read into main session before delegating to subagent.
   - Severity: HIGH — delegable to a "cross-section integration subagent" that reads files itself.

3. **`run-execution.md` Steps 2.1 + 2.3** (lines 36–39, 101–105): Main session reads Execution Manifest, Research Plan, all Answer Specs, then for 2.3 reads all raw reports + Answer Specs again. Raw reports are typically large (several thousand words each).
   - Severity: HIGH — subagent receives content; main session doesn't need to retain it after dispatch.

4. **`run-analysis.md` Step 5/5b/5c** (lines 49–73): Main session reads memo-review.md, recommendations.md, QC report, all refined cluster memos, scarcity register, all section directives — multiple times across Steps 5b, 5c, 5d.
   - Severity: HIGH — same content re-loaded for each subagent dispatch instead of loaded once and passed.

5. **`run-cluster.md` Step 1** (lines 17–18): Main session reads all research extracts + scarcity register. Per cluster, in main session, before delegating Step 2.
   - Severity: HIGH — extracts are passed through to the subagent anyway; reading them in main session doubles the cost.
   - **Spec divergence:** `stage-instructions.md` Step 3.2 (line 58) explicitly states "Main agent passes extract paths (not content) to one sub-agent per cluster; each sub-agent reads its own extracts" — but `run-cluster.md` does not implement this spec. See F15.

6. **`run-preparation.md` Step 5** (lines 56–60): Main session reads checkpoint, then "for each answer spec file, delegate to a qc-gate sub-agent, passing: the skill's evaluation criteria and the answer spec content." Per-spec qc-gate subagents return into main session — sums up to all-spec output volume.
   - Severity: MEDIUM — content-passing through main session is unavoidable per context-isolation rules but the *return* aggregation is unbounded.

7. **`review-chapter.md` Step 1** (lines 20–27): Main session reads chapter prose + architecture + style reference + section directive + scarcity register + cluster memo + synthesis brief. Then content-passes all to qc-gate subagent in Step 2.
   - Severity: HIGH — at least 6 large files read into main session. Total ~8,000–12,000 tokens loaded into main session for a single QC pass that then dispatches to a subagent that re-receives all of it.

8. **`run-report.md` Step 4.2a** (line 56): Subagent receives chapter's research extracts + cluster memo + section directive + scarcity register + editorial recommendations + style reference (read by main session, content-passed). Per chapter × M chapters.

9. **`verify-chapter.md` Step 1**: Main session reads chapter + research extracts. Then constructs API call (no actual subagent compute, but content-passed to execution-agent).
   - Severity: MEDIUM — research extracts can be ~15,000+ words for a chapter's scope.

10. **`produce-architecture.md` Phase 2 step 1**: Main session reads "all section drafts identified in Phase 1" — for a 9-section part, this is ~9 × ~2,000 words = ~18,000 words read into main session.
    - Severity: HIGH — the subagent could read files itself given paths.

### Step 6: File-write sites and disk-vs-context discipline

**Writes to disk (correct disk-as-source-of-truth pattern):**
- All artifacts go to disk: task plans, research plans, answer specs, manifests, prompts, raw reports, extracts, memos, directives, chapter drafts, cited chapters, knowledge files. Pattern is consistent across every command.
- Checkpoints written to disk after each major step (`{stage}/checkpoints/{section}-step-N-checkpoint.md`).
- Phase 2/3 working files in produce-prose-draft and produce-formatting. (✓ Compliant)

**Writes to context (problematic):**
- Subagent return-volume (cataloged in Step 3 above) is the primary "write to context not disk" issue. The structured output schemas embedded in command bodies (e.g., `run-analysis.md` Step 5d lines 95–115; `run-report.md` Step 4.2a "chapter draft content" returned) materialize content in the return rather than referencing disk paths.

---

## Findings

### F1 — Subagent return contracts not enforced across most launch sites — HIGH

**Evidence:** Of ~50 subagent-launch sites in the workflow's commands, only 6 sites (produce-prose-draft Phases 3 and 5; produce-formatting Phases 2 and 3) enforce the `Output-to-disk pattern (required — subagent-contract compliance)` with ≤20-line return cap and `working_file` field. The remaining ~44 sites use bare "Return: ..." instructions without caps.

**Specific violations of the >200-line subagent return threshold (HIGH per protocol):**
- `run-report.md` Step 4.2a (line 56): "Return: chapter draft content" — chapter prose returned in full to main session; typical chapter is 1,500–3,000 words = potentially ~3,900 tokens just for the prose body. (HIGH)
- `run-report.md` Step 4.2b (line 59): "Return: review verdict, findings list, recommended changes" — full findings list including recommended changes. (HIGH)
- `run-report.md` Step 4.2c (line 62): "Return: QC verdict (PASS/FAIL), per-item findings" — full per-item compliance findings. (HIGH)
- `run-analysis.md` Step 5d (lines 95–115): structured output format embedded in command body containing `## Approved Decisions`, `## Nuance Adjustments Applied`, `## Noted Alternatives`, `## Dependency Consistency Check`. (HIGH)
- `review-chapter.md` Step 2 (line 49): "Produce the findings report, verdict, priority fixes, and scarcity compliance summary" — full report returned to main session. (HIGH)
- `verify-chapter.md` Step 3a (line 49): full correction list returned with per-item bright-line metadata.

**Waste mechanism:** Each non-compliant return places full subagent output into main-session context. Across a typical run of 40+ subagent invocations, even a conservative 100-line average return = ~5,000 tokens × 40 = ~200,000 tokens of subagent output content materialized in the main session per workflow run.

### F2 — Stage 4 main-session pre-load is large and partly delegable — HIGH

**Evidence:** `run-report.md` Step 4.0 (lines 13–22): main session reads all chapter drafts, scarcity register, all section directives, all refined cluster memos, all research extracts, all editorial recommendations. Estimated ~30,000+ tokens loaded into main-session context before any subagent dispatch. Justification on line 22: "These inputs are referenced throughout the pipeline. Sub-agents receive content, not file paths (per context isolation rules)."

**Waste mechanism:** Main session retains content for the duration of Stage 4. If Stage 4 processes 5 chapters × 4 subagents per chapter = 20 dispatches, the same content is content-passed 20 times. Disk-to-subagent direct read (per the existing exception in stage-instructions.md "Context Isolation Rules" allowing "large read-only reference files... may be passed by absolute path") would eliminate the main-session load entirely. The current rule treats memos/extracts/directives as content-pass-only, multiplying the cost.

### F3 — `@-imports` in CLAUDE.md auto-load four reference files contradicting the "only load when working" instruction — HIGH

**Evidence:** `CLAUDE.md` line 11 (`@reference/stage-instructions.md`), line 36 (4-file reference list framed as `IMPORTANT`), lines 73, 85, 89 (`See @reference/stage-instructions.md § ...`). The `@`-prefix triggers auto-load at session start. Line 36 instructs "Only load these when actively working on the relevant stage or task" — but the `@` mechanism cannot honor that conditional.

**Per-session cost:** stage-instructions.md (~3,446 tokens) + file-conventions.md (~1,235 tokens) + quality-standards.md (~945 tokens) + style-guide.md (~571 tokens) = **~6,197 tokens loaded every turn** regardless of stage. Combined with CLAUDE.md itself (~1,482 tokens) the per-turn fixed cost is ~7,679 tokens.

**Waste mechanism:** A user running `/status` (13 lines) still pays ~7,679 tokens of CLAUDE.md + reference imports. A 30-turn session on routine ops = ~230,000 tokens of always-loaded reference material that the conditional-load instruction was supposed to prevent. (boundary): per-session cost is at the boundary of the protocol's HIGH threshold (>10,000 tokens unnecessary loading) depending on session length.

### F4 — Compaction discipline is well-marked at command level but not enforced across orchestration boundaries — MEDIUM

**Evidence:** Compact markers `▸ /compact` are present in 12 of 28 commands. `run-execution.md` has 7 markers, `run-analysis.md` has 8, `run-cluster.md` has 3. Clear boundary discipline within these commands.

**Gaps:**
- `run-report.md` (85 lines): only 3 compact markers despite the longest pre-load and the per-chapter loop. Per-chapter `▸ /compact` between chapters appears only in step 4.2i (line 79), nowhere else in the chapter loop.
- `review-chapter.md`: 1 compact marker at end (line 52) — full upstream load + qc-gate dispatch happens in main session with no mid-step compact.
- `verify-chapter.md`: 2 compacts but no compact between Step 1 (chapter+extracts read) and Step 2 (API call construction).
- `produce-architecture.md`: 2 compacts; appropriate for its 4-phase structure.
- `produce-prose-draft.md` (212 lines): 6 compacts, well-distributed across 6 phases.
- No global "compact at section boundary" rule — between consecutive `/run-cluster cluster-NN` invocations operator is reminded ("After this cluster completes, run /compact before starting the next cluster"), but the instruction is operator-prompted, not auto-enforced.

**Waste mechanism:** Untracked context accumulation between commands. Compaction discipline is good *within* each command but does not survive multi-command sequences (e.g., `/run-cluster 01` → `/run-cluster 02` → `/run-analysis`).

### F5 — Refinement multiplier crosses MEDIUM threshold per chapter unit — MEDIUM

**Evidence:** Per-chapter Stage 4 sequence: evidence-to-report-writer (writer) + chapter-prose-reviewer (reviewer) + report-compliance-qc (compliance qc-gate) + optional fix-agent + citation-converter = 4–5 subagents per chapter. Plus optional `/review-chapter` (independent qc-gate) and `/verify-chapter` (execution-agent + optional evidence-prose-fixer). Per-chapter QC count: 3–5.

**Per protocol:** "Consistent need for >3 refinement cycles → MEDIUM (may indicate instruction quality issue rather than token waste per se, but the token cost is real)."

The per-section run also embeds `/produce-prose-draft` Phase 3 score routing (potential re-run of Phase 2 if score 1–2) and `/run-execution` Step 2.1b retry logic (one retry on REVISE-Moderate). Cumulative re-pass risk per section: low-bounded (caps at 2) but consistent. (boundary)

### F6 — Multiple commands re-load same large content across consecutive steps — MEDIUM

**Evidence:**
- `run-analysis.md` Step 5b (line 61): main session reads memo-review.md, all refined cluster memos, scarcity register, all section directives — content-passes to subagent.
- `run-analysis.md` Step 5c (line 70): main session re-reads memo-review.md, recommendations.md, all refined cluster memos, scarcity register, all section directives — content-passes to qc-gate subagent.
- `run-analysis.md` Step 5d (line 80): main session re-reads memo-review, recommendations, qc-report — content-passes to auto-delegate subagent.

The same memo set + directives + scarcity register passes through main session three times in run-analysis. With a 3-cluster section: 3 memos (~6,000 words) + 3 directives (~3,000 words) + scarcity register (~500 words) = ~9,500 words × 1.3 = ~12,350 tokens loaded into main session three times in succession. Single load + retain across the three dispatches would cut this by 2/3.

**Waste mechanism:** Re-load cost without functional benefit. Compaction between steps is supposed to clear it, but content is re-read fresh each time.

### F7 — `review-chapter.md` and `verify-chapter.md` both load all upstream artifacts in main session before delegating to qc-gate — HIGH

**Evidence:** `review-chapter.md` Step 1 (lines 20–27) loads 7 inputs in main session: chapter prose, architecture extract, style reference, section directive, scarcity register, cluster memo, synthesis brief. Step 2 (line 38) then content-passes all 7 to qc-gate subagent. Estimated main-session load: ~8,000–12,000 tokens for a single review.

Similarly `verify-chapter.md` Step 1: chapter + corresponding research extracts. Extracts can be ~15,000 words for a chapter's scope.

**Waste mechanism:** Standalone `/review-chapter NN` and `/verify-chapter NN` pay the full main-session load cost on every invocation. Operator running these commands across 5 chapters pays the load cost 5× without overlap-deduplication.

### F8 — `run-report.md` Step 4.2a returns chapter prose into main session — HIGH

**Evidence:** Line 56: "Task: produce chapter prose. Return: chapter draft content, scarcity items addressed, evidence coverage notes."

The chapter draft is then read again by Step 4.2b (review subagent), Step 4.2c (compliance qc-gate), and Step 4.2d (write to disk). The literal "chapter draft content" return places the prose in main-session context.

**Waste mechanism:** Per chapter ~3,000 words = ~3,900 tokens of prose materialized in main session. The subagent could write the file and return only the path; subsequent steps read from disk.

### F9 — `produce-prose-draft.md` Phase 4 reads non-adjacent prose sections in main session — MEDIUM

**Evidence:** Lines 133–138: globs prose directory, "Read all other completed prose sections (non-adjacent) — for redundancy/contradiction checking. For large document parts (6+ completed sections), read only the opening and closing paragraphs of non-adjacent sections to manage context size."

The opening-and-closing-only mitigation kicks in at 6 sections; for sections 2–5 of a part, all completed sections are read fully into main session.

**Waste mechanism:** Section 5 of a 9-section part reads sections 1–4 in full (~6,000 words) into main session before content-passing to the integration subagent. The subagent could perform the read itself.

### F10 — Improvement-analyst agent reads project state directly (correct pattern) but other agents content-pass — LOW (informational)

**Evidence:** `improvement-analyst.md` Phase 1: reads CLAUDE.md, settings.json, list .claude/commands/, list .claude/hooks/, /logs/workflow-observations.md directly — gets context independently from main session.

Other agents (`qc-gate`, `verification-agent`, `execution-agent`) per their definitions are content-pass-only with `tools: Read` (qc-gate, verification-agent) or `tools: Read, Bash` (execution-agent).

The qc-gate definition `## Criteria Routing Table` (lines 41–53) explicitly says: "The main agent reads the criteria source and passes the relevant criteria text to the QC agent. The QC agent never reads skill files itself." This is the intended isolation rule but it's the precise mechanism that forces main-session content-loading documented in F2, F6, F7.

**Note:** This is a structural design decision, not a defect — it exists for context isolation. The exception already noted in stage-instructions.md ("large read-only reference files ... may be passed by absolute path") could be expanded to operand artifacts when isolation is preserved by other means (fresh-context spawn).

### F11 — Stage 4 inputs declared as `Read` in main session for "referenced throughout" reasons but each subagent gets content-pass — MEDIUM

**Evidence:** `run-report.md` line 22: "These inputs are referenced throughout the pipeline. Sub-agents receive content, not file paths (per context isolation rules)."

The justification is partial: if subagents receive content (passed by main session), the main session retains all of that content for the full Stage 4 duration. The savings from "load once, reference many" is ~zero because every subagent gets the same content content-passed.

**Waste mechanism:** Content is held in main-session context for ~30+ subagent dispatches across Stage 4. If Stage 4 takes ~50 main-session turns at ~30,000 tokens of resident content = 1,500,000 token-turns just for the upfront load.

### F12 — `intake-reports.md` mandates Opus for filing operations — LOW

**Evidence:** `intake-reports.md` lines 10–11: "This command MUST run on Opus. Raw reports must be written verbatim — never summarized, truncated, or compressed. Lower-capability models (Haiku, Sonnet) have been observed to summarize instead of copying full content."

**Note:** This is a model-tier choice, not strictly a token-flow waste. From a pure token-flow lens, the operation itself is cheap; from cost-per-token, it's the most expensive option.

### F13 — Working-file pattern read at handoff phases is correctly structured — MEDIUM (boundary, informational)

**Evidence:**
- `produce-prose-draft.md` Phase 6 step 2: "Read `{prose_output_dir}/working/phase-3-qc-{section}.md` to retrieve the full Phase 3 findings list for operator surfacing."
- `produce-formatting.md` Phase 4 steps 2–3: reads `formatting-phase-2-{section}.md` and `formatting-phase-3-qc-{section}.md` working files.

The working files contain full subagent output (the disk-write that prevents main-session load during execution). The handoff phase legitimately needs the content to brief the operator, but the read happens in main session at the end.

**Severity:** MEDIUM (boundary) — pattern is correctly designed. Flag is informational: any future change that pushes more content into the working files will increase the Phase 6 read cost.

### F14 — Workflow has 28 commands without per-command activation/discoverability discipline — LOW

**Evidence:** 28 command files. Pipeline-stage commands: `/run-preparation`, `/run-execution`, `/run-cluster`, `/run-analysis`, `/run-synthesis`, `/run-report`, `/produce-architecture`, `/produce-prose-draft`, `/produce-formatting`, `/produce-knowledge-file`, `/intake-reports`, `/inject-dependency`, `/review-chapter`, `/verify-chapter`, `/refinement-pass`, `/qc-pass`. Utility/operator: `/audit-repo`, `/audit-structure`, `/improve`, `/note`, `/prime`, `/session-plan`, `/wrap-session`, `/workflow-status`, `/status`, `/friction-log`, `/create-context-pack`, `/update-claude-md`.

No documented "trigger" or activation-condition section per command (frontmatter has only `friction-log`, `model`, sometimes `argument-hint`).

**Note:** This is a discoverability concern, not a token-cost concern directly. Listed for completeness — descriptions of `/refinement-pass` (23 lines) and `/qc-pass` (23 lines) would not necessarily disambiguate from `/review-chapter` based on description alone.

### F15 — `run-cluster.md` command implementation diverges from updated `stage-instructions.md` Step 3.2 spec — MEDIUM

**Evidence:** `stage-instructions.md` Step 3.2 (line 58) reads: "Apply `cluster-analysis-pass` logic for all clusters in parallel via `/run-cluster`. Main agent passes extract paths (not content) to one sub-agent per cluster; each sub-agent reads its own extracts and writes its analysis memo. Context isolation is handled within each sub-agent — no `/compact` between clusters needed in the main session."

`run-cluster.md` Step 1 (lines 17–18) reads: "1. Read the research extracts for this cluster from `/execution/research-extracts/{section}/`. 2. Read the scarcity register..." Step 2 line 25: "Pass it: the skill content, the cluster's research extracts, and any relevant scarcity register entries." Then line 27: "▸ /compact — skill content and extract content no longer needed." And line 46: "After this cluster completes, run /compact before starting the next cluster..."

The command implements the older sequential-with-content-pass pattern. The newer spec (path-pass + parallel + no inter-cluster compact) is not yet reflected in the command file.

**Waste mechanism:** Operators running `/run-cluster` per the command file pay double the load cost (main session + subagent) and serialize the cluster work — directly counter to the spec's parallelism intent. For a 3-cluster section, ~3× extracts × content-pass = ~3× the necessary main-session load.

---

## Protocol gaps

- The protocol's >200-line threshold for subagent returns is ambiguous about render format (line count of formatted text vs. word count). Interpreted here as effective content length — chapter-prose returns of 1,500+ words classify as HIGH regardless of render.
- "Delegable" classification (Section 4 Step 5) is structural inference without telemetry. Severity ratings reflect that.
- The `@-import` mechanism is not explicitly named in the protocol; interpreted as "loaded at workflow start" per Step 4.1 Question 1.
- The protocol does not provide a specific severity for "command file diverges from spec doc" (F15) — applied MEDIUM by analogy to "consistent inefficient pattern."

## Summary stats

- **Findings:** 15
- **HIGH:** 5 (F1, F2, F3, F7, F8)
- **MEDIUM:** 7 (F4, F5, F6, F9, F11, F13, F15)
- **LOW:** 3 (F10, F12, F14)
- **Subagent-return contract enforcement rate:** 6/50 ≈ 12%
- **Per-turn fixed cost estimate (CLAUDE.md + @-imports):** ~7,679 tokens
- **Largest single command file:** produce-prose-draft.md, 212 lines, ~4,804 tokens

## Boundary findings (within ±15% of severity threshold)

- F3: per-session cost ~7,679 tokens — at the boundary of the HIGH threshold (>10,000 tokens) depending on session length. (boundary)
- F5: refinement multiplier per-chapter is 3–5; the 3 boundary triggers MEDIUM. (boundary)
- F13: structural-correct, flagged informationally. (boundary)
