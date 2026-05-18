# Section 4 Working Notes — Research Workflow

**Audit root:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
**Workflow path:** `workflows/research-workflow/`
**Date executed:** 2026-05-18
**Protocol version:** 1.3
**Estimation method:** word count × 1.3; ±30% drift caveat applies. Threshold-boundary findings tagged `(boundary)`.

---

## Workflow inventory

The Research Workflow is a five-stage pipeline (Preparation → Execution → Analysis → Synthesis → Report) with 29 command files in `.claude/commands/` and 4 reference files in `reference/`.

**Command file line counts (top of audit relevance):**
- CLAUDE.md: 128 lines (template, includes `{{PROJECT_TITLE}}` placeholders — operator-customized per project)
- run-preparation.md: 70 lines, 13 delegate sentences, 4 compact mentions
- run-execution.md: 187 lines, 21 delegate sentences, 7 compact mentions
- run-cluster.md: 44 lines, 6 delegate sentences, 0 compact mentions
- run-analysis.md: 182 lines, 17 delegate sentences, 8 compact mentions
- run-synthesis.md: 33 lines, 3 delegate sentences, 2 compact mentions
- run-report.md: 85 lines, 13 delegate sentences, 3 compact mentions
- produce-architecture.md: 101 lines
- produce-prose-draft.md: 212 lines (the largest command in the workflow)
- create-context-pack.md: 33 lines
- prime.md: 33 lines

**Reference files:**
- stage-instructions.md: 155 lines
- file-conventions.md: 142 lines
- quality-standards.md: 72 lines
- style-guide.md: 35 lines
- Total: 404 lines

---

## Stage-by-stage context loading chain

### Stage entry — `/prime`
- Reads last entry from `/logs/session-notes.md` + most recent checkpoint (lightweight)
- Does NOT load reference docs by default. CLAUDE.md instructs that stage-instructions / file-conventions / quality-standards / style-guide are loaded ONLY when actively working on the relevant stage.
- **Risk:** No mechanism enforces "load only on relevant stage." When commands run, they do not gate on whether refs were read; refs are not auto-loaded — but if operator/Claude reads them defensively, that's ~404 lines of structural reference text.

### Stage 1 — `/run-preparation` (70 lines)
**Loaded at start:** CLAUDE.md (~128 lines) + task plan draft (passed via @ reference, operator-supplied).
**Subagent invocations in main session:** 5 delegate launches (Steps 1, 1b, 3, 4, 5).
**Skill files read in MAIN session before delegating (handoff to subagent):**
1. `task-plan-creator/SKILL.md` (Step 1)
2. `research-plan-creator/SKILL.md` (Step 3)
3. `answer-spec-generator/SKILL.md` (Step 4)
4. `answer-spec-qc/SKILL.md` (Step 5)

Each Step's instruction is: "Read skill, then launch sub-agent and pass it the skill content." Skill content enters main context only briefly per Step; each Step has a `▸ /compact` instruction at its end. 4 compact breakpoints documented.

**Subagent return shape:** Each step returns "output file path, key summary points." Returns are described as summary-shaped (file paths + decisions). No explicit ≤20-line cap in command text but pattern is summary-only.

### Stage 2 — `/run-execution` (187 lines, the longest stage command)
**Loaded at start:** All Answer Specs (`/preparation/answer-specs/{section}/`) + answer-spec-qc skill.

**Subagent invocations in main session:** 21 delegate sentences (includes both Main pipeline and Subworkflow 2.S supplementary). Compacts: 7.

**Per-step main-session reads (significant):**
- Step 2.0: Research Plan + all Answer Specs + `execution-manifest-creator` skill
- Step 2.1: Execution Manifest + Research Plan + all Answer Specs + `research-prompt-creator` skill
- Step 2.1b QC: All prompt files + all Answer Specs + Research Plan + `research-prompt-qc` skill
- Step 2.3: ALL raw reports from `/execution/raw-reports/` + checkpoint + Answer Specs + skill
- Step 2.4: checkpoint + `research-extract-verifier` skill

**Subagent return shape:** Returns specified as summary fields — session-plan tables, extract inventories, verdict counts. No explicit ≤200-line cap. Step 2.3 returns "list of extracts produced (question ID, file path, brief quality note)" — likely summary-shaped, but extract content itself stays in main session because Step 2.3 instruction has main session "Read all raw reports from `/execution/raw-reports/`" (instructional load).

**HIGH severity flag:** Step 2.3 instructs main session to read ALL raw reports before delegating. Raw Research Execution GPT reports are typically multi-thousand-word documents per session. Main-session reads ALL raw reports is a large delegable load.

**HIGH severity flag:** Step 2.1b QC reads ALL prompt files + ALL Answer Specs + Research Plan in main session before passing to qc-gate sub-agent. The sub-agent re-receives this content as passed input — main-session read is structurally redundant since the sub-agent could read by path.

### Stage 3a — `/run-cluster` (44 lines, parallel cluster analysis)
**Loaded at start:** Research Plan + scarcity register; LISTS extract file paths only (does not read content).
**Subagent invocations:** 6 delegate references → one general-purpose sub-agent per cluster, parallel. Skill files (`cluster-analysis-pass` + `cluster-memo-refiner`) read in main session and passed.
**Compacts:** 0. **MEDIUM severity flag:** No `▸ /compact` instruction after parallel cluster fan-out, even though skill content + extract paths + scarcity register entries remain in context for the entire fan-out. The next command (`/run-analysis`) is a separate invocation but the operator may continue in the same Claude Code session without compaction.

### Stage 3b — `/run-analysis` (182 lines)
**Loaded at start:** "Read all refined cluster memos from `/analysis/cluster-memos/{section}/`" — Step 1. Then 6 separate skill reads across steps.
**Subagent invocations:** 17 delegate sentences across Steps 2, 4, 5, 5b, 5c, 5d + Subworkflow 3.S. Compacts: 8.
**HIGH severity flag:** Step 1 ("Load Inputs") instructs main session to read ALL refined cluster memos at the start of Stage 3. Cluster memos for a multi-cluster section can total 1,500+ lines. The downstream Steps 4 and 5 then pass cluster memo content to sub-agents — so main session is holding memo content while spawning multiple agents. The next compact is not until end of Step 2. This is a sustained large-context read.
**Step 5b** passes to subagent: memo-review + all refined cluster memos + scarcity register + all section directives — large bundled inputs.

### Stage 4 (drafting) — `/run-synthesis` (33 lines)
**Loaded at start:** Step 1 reads all refined cluster memos + all section directives + scarcity register.
**Subagent invocations:** 3 delegate sentences (one per cluster + main launch). Compacts: 2.
**MEDIUM severity flag (boundary):** Step 1 main-session load of all memos + all directives + scarcity register is sizable; only one compact in the entire 33-line command. Marked boundary because total volume depends on cluster count.

### Stage 4 (report) — `/run-report` (85 lines)
**Loaded at start (Step 4.0):** Main session reads:
1. All chapter drafts
2. Scarcity register
3. All section directives
4. All refined cluster memos
5. All research extracts
6. Approved editorial recommendations

The command says explicitly: "These inputs are referenced throughout the pipeline. Sub-agents receive content, not file paths (per context isolation rules)."

**HIGH severity flag:** Step 4.0 deliberately loads SIX large input categories into main session at the start, all of which are then passed *as content* to multiple downstream subagents. For a research project with multiple clusters and chapters, this load can easily exceed several thousand lines (cluster memos + chapter drafts + research extracts + section directives). The instruction "Sub-agents receive content, not file paths (per context isolation rules)" forces the main session to be the content-relay rather than letting subagents read by path. This is a structural waste pattern — the rationale ("context isolation rules") may be valid for fresh-context QC independence but the cost is the entire Stage 4 input bundle resident in main session.

**Step 4.1b QC** re-reads architecture + scarcity register + all section directives + editorial recommendations + all chapter drafts and passes all content again. **HIGH (boundary):** Largely the same content as Step 4.0, but the instruction is to re-read explicitly.

**Step 4.2 per chapter (sequential):** 4 subagent launches per chapter (a writer, b reviewer, c compliance QC, i citation converter). For a 5-chapter section: ~20 subagent calls in Stage 4 alone.

**Subagent return — Step 4.2a:** "Return: chapter draft content, scarcity items addressed, evidence coverage notes." **HIGH severity flag:** "Return chapter draft content" implies the full chapter prose returns into main session. Chapter prose is typically 500–2,000+ lines. This is a subagent returning >200 lines (HIGH per protocol).

**Step 4.2b reviewer:** "Return: review verdict, findings list, recommended changes." Findings list size unbounded — could exceed 200 lines depending on chapter quality.

### Cross-stage: `/produce-architecture` (101 lines, 2 subagent launches per part)
- Phase 2 reads all section drafts + project-brief.md + content-architecture.md + skill — main session does the heavy read
- Phase 3 QC also reads all section drafts again — main session re-reads
- 2 compact breakpoints (one per phase)
- **MEDIUM severity flag:** Phase 2 and Phase 3 both have main session read "all section drafts" — drafts re-loaded for QC pass; delegable if QC subagent could read by path.

### Cross-stage: `/produce-prose-draft` (212 lines, 4–5 subagent launches per section)
- Phase 1 reads only source-doc lookups (lightweight)
- Phase 2 reads source document + skill in main session; subagent reads style-reference + prose-quality-standards by absolute path (this is the *good* pattern — main session does NOT inline these files)
- Phase 3 uses output-to-disk pattern: subagent writes full findings to `phase-3-qc-{section}.md` and returns ≤20-line summary (correct subagent contract)
- Phase 4 (integration check): reads adjacent sections + non-adjacent sections (with explicit guidance to read only opening/closing paragraphs of non-adjacent sections for 6+ sections — this is an explicit token-saving instruction)
- Phase 5: main reads prose + source doc + skill, passes by path for style + standards
- 4 compact breakpoints (Phases 2, 3, 4, 5)

**This command is the best-engineered of the suite re token discipline:** uses absolute paths for subagent reads where possible, explicit subagent-contract output-to-disk pattern for Phase 3, ≤20-line return cap, partial reads on non-adjacent sections.

---

## File-read map summary

| Where loaded | Stage | Volume risk |
|---|---|---|
| CLAUDE.md (template) | All stages | ~128 lines, fixed |
| All Answer Specs | Stage 2 (4 separate steps) | Multi-file, repeat reads |
| All raw reports | Stage 2 Step 2.3 | Large — multi-thousand-line external research output |
| All refined cluster memos | Stage 3 Step 1 + Stage 3 Step 4 + Stage 3 Step 5 + Stage 3 Step 5b + Stage 3 Step 5c + run-synthesis Step 1 + run-report Step 4.0 + run-report Step 4.1b | Read repeatedly in multiple stages |
| All section directives | run-analysis Step 5b + Step 5c + run-synthesis Step 1 + run-report Step 4.0 + 4.1b + 4.2c (per chapter) | Repeated load |
| All research extracts | run-analysis 5b (partial) + run-report Step 4.0 + 4.2a (per chapter) | Repeated load |
| All chapter drafts | run-report Step 4.0 + Step 4.1 + Step 4.1b | Three separate main-session reads in one stage |
| Approved editorial recommendations | run-report Step 4.0 + 4.1b + 4.2 (per chapter) | Repeated |
| Scarcity register | Stages 3, 4 (each step) | Small file, but read repeatedly |

---

## Subagent pattern summary

| Stage | Subagent count (per section) | Return shape |
|---|---|---|
| Stage 1 prep | 5 | File paths + summary fields |
| Stage 2 execution | 4 + 2.S (4 more if supp runs) | File paths + tables |
| Stage 3a cluster | N (one per cluster, parallel) | File paths + themes |
| Stage 3b analysis | 7 + 3.S optional | File paths + tables |
| Stage 4 synthesis | N (one per cluster) | Chapter structure summary |
| Stage 4 report | 1 + 1 + 4×chapters (≈21 for 5 chapters) | **chapter prose content returned (HIGH)** + verdicts |
| produce-prose-draft (per section) | 4–5 | Summary + disk-file pointer (good pattern) |
| produce-architecture (per part) | 2 | Summary + flags |

For a typical multi-cluster, multi-chapter project section, total subagent launches across the pipeline easily exceed 40.

---

## /compact breakpoint coverage

| Command | Compact mentions | Adequacy |
|---|---|---|
| run-preparation | 4 | One per step — good |
| run-execution | 7 | One per step plus 2.S — good |
| run-cluster | **0** | **MEDIUM flag** — no compact after parallel fan-out |
| run-analysis | 8 | Good per-step coverage |
| run-synthesis | 2 | Adequate for 33-line command |
| run-report | 3 | **MEDIUM flag** — sparse coverage. Step 4.0 loads 6 input categories with no compact instruction until end of Step 4.1 |
| produce-architecture | 2 | One per phase — good |
| produce-prose-draft | 4 | One per phase — good |

CLAUDE.md (lines 117–124) includes a Compaction section with explicit instructions on what to preserve during compact, and recommends "write a short session-state scratchpad … and `/clear` + restart from the scratchpad over lossy auto-summarization." This is the right discipline at the workflow level; per-command instructions enforce it well in some commands (preparation, execution, analysis, produce-prose-draft) and poorly in others (run-cluster, run-synthesis early steps, run-report Step 4.0).

---

## Refinement multiplier

The workflow design includes built-in QC + refinement cycles at every stage:
- Stage 1: Step 1b QC, Step 5 QC (per spec)
- Stage 2: Step 2.1b QC, Step 2.4 QC, Subworkflow 2.S (optional 2 passes)
- Stage 3: Step 5 memo review, Step 5b recommendations, Step 5c QC of recommendations, Step 5d approval, Subworkflow 3.S (optional 2 passes)
- Stage 4 (report): Step 4.1b architecture QC, Step 4.2b reviewer, Step 4.2c compliance QC (per chapter), Step 4.2f bright-line check on revisions
- produce-prose-draft: Phase 3 merged review + compliance QC, Phase 4 integration check, Phase 5 decontamination

**Estimated total sessions per typical run:** Workflow design assumes 2 QC passes per major artifact at minimum, plus optional supplementary research passes (up to 2). For a typical 1-section, 3-cluster, 5-chapter project section: easily 8–12 QC/refinement subagent sessions. **MEDIUM severity per protocol's >3 threshold.** This appears intentional (research-quality driven) rather than waste, but the token cost is real per protocol guidance.

---

## Findings table

| # | Finding | Severity | Waste mechanism | Evidence |
|---|---|---|---|---|
| 1 | run-report Step 4.0 loads 6 large input categories (chapter drafts, scarcity register, section directives, cluster memos, research extracts, editorial recommendations) into main session before delegating | HIGH | Main-session content relay rather than subagent path-read; "context isolation" rationale stated but cost is full bundle resident in main | run-report.md lines 14–22 |
| 2 | run-report Step 4.2a subagent returns "chapter draft content" into main session per step | HIGH | Subagent returns large output (>200 lines plausible for chapter prose) instead of writing to disk and returning summary | run-report.md line 56 |
| 3 | run-execution Step 2.3 main session reads ALL raw reports before delegating per-session subagents | HIGH | Large delegable load (raw GPT/Perplexity reports are multi-thousand-word) in main session; subagents could read by path | run-execution.md line 101 |
| 4 | run-analysis Step 1 reads ALL refined cluster memos into main session at stage start | HIGH | Sustained large-context read across multiple subsequent steps | run-analysis.md line 15 |
| 5 | run-execution Step 2.1b QC re-reads all prompt files + all Answer Specs + Research Plan into main session then passes to QC subagent | HIGH | Main-session read structurally redundant — QC subagent could read by path | run-execution.md lines 49–53 |
| 6 | run-report Step 4.1b QC reads same six input categories as Step 4.0 again | HIGH (boundary) | Re-read of content already in main session from Step 4.0; or redundant explicit re-read | run-report.md line 40 |
| 7 | run-cluster has zero `▸ /compact` instructions despite reading skill content + spawning parallel cluster subagents | MEDIUM | Missing compaction breakpoint — context accumulates across parallel fan-out and into next command | run-cluster.md (0 compact mentions) |
| 8 | run-report has only 3 compact mentions across 85-line, 13-delegate-call command | MEDIUM | Sparse compaction coverage in highest-volume stage | run-report.md |
| 9 | run-synthesis Step 1 main-session load (all memos + all directives + scarcity) with only 2 compact mentions in 33-line command | MEDIUM (boundary) | Sustained large-context load before first compact | run-synthesis.md lines 13–17 |
| 10 | Cluster memos / section directives / research extracts are read repeatedly across multiple stages and steps in main session | MEDIUM | Repeated reads of stable content; could be passed by path to subagents | See file-read map above |
| 11 | produce-architecture Phase 2 + Phase 3 both read "all section drafts" in main session | MEDIUM | Same content loaded twice in the same command for delegable QC pass | produce-architecture.md lines 44, 70 |
| 12 | Stage 4 (`/run-report`) launches ~4 subagent calls per chapter sequentially (~20 calls for 5 chapters) with chapter content returning to main session at step (a) | MEDIUM | High subagent-return density at the most token-heavy stage; combines with finding #2 | run-report.md Step 4.2 |
| 13 | No explicit `/compact` instruction between Stage 3a (`/run-cluster`) and Stage 3b (`/run-analysis`); workflow assumes operator runs them in separate sessions but command text doesn't enforce | MEDIUM | Implicit-only stage breakpoint; no explicit "new session" gate in run-cluster handoff | run-cluster.md ends without compact or session-break directive |
| 14 | Total refinement-pass count for a typical section is 8–12 subagent sessions across all stages | MEDIUM | Per protocol >3 threshold; intentional quality multiplier but token cost is real | Synthesized from all 5 stage commands |
| 15 | Stage 1 to Stage 5 — most commands DO read skill content into main session (e.g., "Read `task-plan-creator/SKILL.md`") before passing skill content to subagent. produce-prose-draft is the only command using absolute-path subagent reads to bypass main-session loading of style-reference and prose-quality-standards | MEDIUM | Older commands inline skill content into main session; newer command (produce-prose-draft) demonstrates a token-saving alternative not yet adopted across the workflow | All "run-*" commands vs produce-prose-draft Phase 2 step 0 |
| 16 | CLAUDE.md Compaction section advocates "write scratchpad + `/clear` + restart" but per-command instructions only use `▸ /compact` (auto-summarization, lossy) | LOW | Workflow-level vs command-level mismatch; documented but not enforced | CLAUDE.md lines 117–124 vs all run-*.md compact mentions |
| 17 | Reference files (stage-instructions 155 + file-conventions 142 + quality-standards 72 + style-guide 35 = 404 lines) loaded on operator/Claude judgment of "actively working on relevant stage"; no enforcement against unnecessary loading | LOW | Reference creep risk if loaded defensively | CLAUDE.md line 36 |
| 18 | produce-prose-draft Phase 3 uses correct subagent-contract pattern (write full findings to disk, return ≤20-line summary). Other QC/review steps across run-* commands do NOT name this contract explicitly | LOW | Inconsistent application of the subagent-contract pattern; older commands let return shape be implicit | produce-prose-draft.md lines 106–112 vs run-report Step 4.2b/4.2c |

---

## Protocol gaps

- Protocol Section 4 asks for "estimated output volume" of subagent returns. Exact token counts cannot be measured without running the workflow; severity flags above are structural inferences from instruction text (per protocol's directive when no telemetry exists).
- Protocol Section 4 Severity rule "Subagent returning >200 lines to main session → HIGH" is applied based on the instruction *asking* for content return (e.g., "Return: chapter draft content"), not measured. Marked appropriately as inference.
- Boundary tags applied where main-session load size is project-variable (depends on cluster count, chapter count, extract count). Findings #6, #9 flagged as `(boundary)`.

---

## Counts

- HIGH findings: 6 (findings #1, #2, #3, #4, #5, #6)
- MEDIUM findings: 9 (findings #7, #8, #9, #10, #11, #12, #13, #14, #15)
- LOW findings: 3 (findings #16, #17, #18)
- Total: 18 findings
