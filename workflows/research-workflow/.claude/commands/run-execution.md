---
friction-log: true
model: sonnet
---
Execute the Stage 2 research pipeline for the current section (Pass 1 — Source Discovery + Pass 2 — Evidence Extraction).

Research execution happens in the project-configured evidence executor. An optional supplementary lead provider may surface candidate URLs but never produces evidence of record. Both remain operator-run; this command does not dispatch external tools. It handles manifest creation (Step 2.0), source-class mapping (Step 2.0b — invocable when the project provides `reference/source-class-hierarchy.md`), prompt creation (Step 2.1), extract creation (Step 2.3), transaction-table build (Step 2.3b — conditionally invocable when the project has named-transaction content in scope), and extract verification (Step 2.4). Step 2.2 (research execution itself) is manual.

**Four-pass model anchor.** This command produces facts-only extracts. No synthesis or claim-permission verdicts in Stages 2; those happen in Pass 3 (`/run-cluster` + `/run-sufficiency`) and Pass 4 (`/run-analysis` + `/run-synthesis`). See `reference/stage-instructions.md` § Stage 2 + § Stage 3 for the principle and pass sequence.

Prerequisite check: Answer spec QC must run in a fresh sub-agent window for QC independence.

1. Read all Answer Specs from `/preparation/answer-specs/{section}/`.
2. Read the `answer-spec-qc` skill (`/ai-resources/skills/answer-spec-qc/SKILL.md`).
3. Launch a qc-gate sub-agent. Pass it: the skill content and all Answer Spec content. Task: apply the QC checks and return per-spec verdicts.
4. Write verdict to `/preparation/answer-specs/{section}/answer-specs-qc.md`.
5. Verify that ALL answer specs show APPROVED. If ANY spec shows REVISE or ESCALATE, abort and report which specs failed.

Skill loading: For each skill step below, read the skill file from the ai-resources repo at `/ai-resources/skills/[skill-name]/SKILL.md` and follow its instructions.

---

### Step 2.0: Create Execution Manifest [delegate]

1. Read the `## Project Config` executor-routing fields from `CLAUDE.md`: `Evidence executor`, `Evidence executor capabilities`, and `Supplementary lead provider`. Preserve the values verbatim. Halt if either required field is missing, blank, malformed, or still a placeholder; halt if the supplementary field is unresolved rather than a product name or `none`.
2. Read the Research Plan from `/preparation/research-plans/`.
3. Read all approved Answer Specs from `/preparation/answer-specs/{section}/`.
4. Read the `execution-manifest-creator` skill (`/ai-resources/skills/execution-manifest-creator/SKILL.md`).
5. Launch a general-purpose sub-agent. Pass it: the skill content, the three Project Config executor-routing values, the Research Plan content, and all Answer Spec content. Task: execute the skill logic to classify execution role and search mode, test the configured evidence executor against required capabilities, keep supplementary leads separate, design session groupings, and plan execution waves. Write output to `/execution/manifest/{section}/{section}-execution-manifest.md`.
   Return: routing table (question ID → role → executor → supplementary leads → rationale), capability verdicts, session groupings, execution wave plan.
6. If the skill returns `No qualifying evidence executor`, halt before writing an executable checkpoint or prompts. Present the failed capabilities and affected questions to the operator; do not substitute another tool.
7. Write checkpoint to `/execution/checkpoints/{section}/{section}-step-2.0-checkpoint.md`. Include: the three executor-routing values, routing decisions, capability verdicts, session count, and wave plan.
8. ▸ /compact — skill content no longer needed; checkpoint carries forward.
9. PAUSE — Present the routing table and budget summary to the operator for approval. He may override question roles or supplementary-pass decisions. An executor or capability change requires an explicit operator decision applied to Project Config before the manifest is regenerated; the manifest does not become a second authority.

---

### Step 2.1: Create Execution Prompts [delegate]

1. Read the approved Execution Manifest from `/execution/manifest/{section}/{section}-execution-manifest.md`. From the project root, run `bash scripts/check-executor-contract.sh CLAUDE.md execution/manifest/{section}/{section}-execution-manifest.md`. This compares `Evidence executor`, `Evidence executor capabilities`, and `Supplementary lead provider` from current Project Config with the manifest's `## Executor Contract`. Continue only on exit 0 (`EXECUTOR CONTRACT READY`). Exit 3 means `STALE MANIFEST — regenerate Step 2.0`; halt before creating any prompt artifact.
2. Read the Research Plan from `/preparation/research-plans/`.
3. Resolve all approved Answer Specs from `/preparation/answer-specs/{section}/` to project-root-relative paths only — verify the section's approved spec set is present and non-empty, and do not read their contents into the main session.
4. Verify the project reference docs the skill consumes: `reference/source-class-hierarchy.md` (required — `research-prompt-creator` halts if absent per its Input Requirements #4) and `reference/quality-standards.md` (Evidence-First preamble source, Country Coverage Table, No-Source-Substitution Rule, Research Stop Conditions) are present, then carry their paths only into step 6 — never load them into this session; the sub-agent reads each itself at runtime.
5. Read the `research-prompt-creator` skill (`/ai-resources/skills/research-prompt-creator/SKILL.md`).
6. Launch a general-purpose sub-agent. Pass it: the skill content, the Research Plan content, the approved Answer Specs as the project-root-relative paths resolved in step 3 — which the sub-agent reads itself, every approved spec for the section in full and component by component, before applying the skill — the approved Execution Manifest content, and the two project reference docs by PATH (sub-agent reads each directly): `reference/source-class-hierarchy.md` and `reference/quality-standards.md`. Task: execute the skill logic to create platform-neutral session prompts for the assigned evidence executor, following the manifest's session groupings and capability verdicts. Target 2 questions per session (1 or 3 acceptable with justification), with no hard session cap. Each prompt must include an inline context pack (compact summary of the Research Plan — project background, section objective, scope boundaries — NOT individual question listings). Write output to `/execution/research-prompts/{section}/` as individual files:
   - `session-plan.md` — How to Use, Session Plan table (including assigned evidence executor and supplementary lead-pass status per session), Dependency Map, Recommended Execution Order, Post-Execution Notes.
   - One `session-{letter}.md` per session — each self-contained with: session title, questions covered, assigned evidence executor, search mode, source boundaries, recency, Execution Prompt (code-fenced), and Steering Notes.
   Return: the session plan table (session letters, question assignments, executor, lead-pass status, rationale).
7. Write checkpoint to `/execution/checkpoints/{section}/{section}-step-2.1-checkpoint.md` from the sub-agent's returned summary. Include: session count by executor, question-to-session mapping, output folder path.
8. ▸ /compact — skill content and raw inputs no longer needed; checkpoint carries forward.

### Step 2.1b: QC Execution Prompts [delegate-qc]

1. Read all prompt files from `/execution/research-prompts/{section}/` (session-plan.md and all session-{letter}.md files).
2. Read all approved Answer Specs from `/preparation/answer-specs/{section}/`.
3. Read the Research Plan from `/preparation/research-plans/`.
4. Read the `research-prompt-qc` skill (`/ai-resources/skills/research-prompt-qc/SKILL.md`).
5. Launch a qc-gate sub-agent. Pass it: the skill content, the prompts content, the Answer Specs content, and the Research Plan content. Task: run the five check dimensions and return per-session verdicts and a batch verdict.
6. Write verdict to `/execution/checkpoints/{section}/{section}-step-2.1b-prompt-qc.md`.
7. If APPROVED: proceed to PAUSE below.
8. If REVISE with only Moderate findings: apply fixes to the prompt files, re-run QC (one retry). If second pass APPROVED, proceed. If still FLAG, pause for operator.
9. If REVISE with Critical findings, follow the skill's mechanical-vs-judgment classification (`research-prompt-qc` SKILL.md § Autonomy Rules; operator-facing mirror: `reference/quality-standards.md` § Critical Finding Classification): all-mechanical Criticals (one correct fix, no editorial judgment) → apply fixes and re-run QC once, pausing if still FLAG; any judgment Critical, any ambiguous classification, or any mechanical/judgment mix → pause for operator review before proceeding.
10. ▸ /compact — QC context no longer needed.
11. PAUSE — Present the session plan table to the operator, naming the configured evidence executor and any supplementary lead passes. **Explicitly flag any inter-session dependencies** (e.g., "Session D depends on Session A — do not run D until A completes"). The operator executes sessions manually (Step 2.2) and returns with raw reports.

---

### Step 2.2b: Intake Raw Reports [Claude Code]

**Trigger:** The operator returns with raw research output from the configured evidence executor, pasted directly into the chat or already written to the agreed project path. This may happen multiple times (once per wave or per session).

1. Read the session plan from `/execution/research-prompts/{section}/session-plan.md` to recover the session letters, question assignments, and dependency map.
2. For each pasted report, identify which session it belongs to by matching its content against the session plan's question assignments (look for the research questions addressed, topic alignment, and any session identifiers in the output).
3. Present the proposed mapping to the operator for confirmation: list each report with its assigned session letter and the questions it covers.
4. After confirmation, write each report to `/execution/raw-reports/{section}/{section}-session-[letter]-raw-report.md`. After writing each file, normalize UTF-8 encoding: `bash {AI_RESOURCES}/scripts/fix-mojibake.sh {written_file_path}` (requires python3 or iconv; safe to skip if unavailable — does not affect content, only encoding).
5. Report back: which files were written, which sessions are now complete, and — per the dependency map — which downstream sessions are now unblocked.

---

### Step 2.2a: Inject Dependency Outputs into Downstream Prompts [optional]

**Trigger:** The operator returns with raw report(s) from session(s) that have downstream dependents (per the session plan's dependency map). **Skip this step if no dependencies exist** for the completed sessions, or if the operator chooses to run downstream sessions without injection.

1. Read the session plan from `/execution/research-prompts/{section}/session-plan.md` to identify which completed sessions have dependents.
2. For each completed session that has dependents:
   a. Read the raw report.
   b. Extract the key structural output — the artifact that downstream sessions need as input (e.g., the chain structure from Q1, the framework from a foundational question). Focus on: the core model/framework/taxonomy produced, its key structural features, and any terminology or numbering that downstream sessions should anchor to.
   c. Draft a `PRIOR RESEARCH OUTPUT` block formatted as a dependency injection prompt. Structure:
      - Header identifying the source session and question
      - The extracted artifact (structured, numbered where applicable)
      - Key structural features that downstream sessions must respect
      - Instruction to map findings to this structure rather than inventing alternatives
   d. Present the drafted block to the operator for review before injection.
3. After operator approval, for each dependent session prompt file:
   a. Read the session prompt from `/execution/research-prompts/{section}/session-{letter}.md`.
   b. Insert the approved `PRIOR RESEARCH OUTPUT` block into the Execution Prompt, immediately after the opening of the code-fenced prompt (before the session's own instructions).
   c. Write the updated prompt file.
4. Confirm to the operator which session files were updated. The operator then runs the next wave.

**Note:** This step may run multiple times if execution happens in waves. Each time the operator returns with reports from sessions that have dependents, repeat this process.

---

### Step 2.3: Create Research Extracts [delegate]

1. Resolve all raw reports from `/execution/raw-reports/` to project-root-relative paths only — verify each session report file exists and is non-empty, label each by session letter, and do not read their contents into the main session.
2. Read the checkpoint from `/execution/checkpoints/{section}/{section}-step-2.1-checkpoint.md` to recover the question-to-session mapping.
3. Read the corresponding Answer Specs from `/preparation/answer-specs/{section}/`.
4. Verify the project reference docs the skill consumes: `reference/quality-standards.md` (No-Source-Substitution Rule for evidence-lens tags consumed by `research-extract-creator`) and `reference/known-limits.md` (current rolling-2-year window declaration) are present, then carry their paths only into step 6 — never load them into this session; the sub-agent reads each itself at runtime.
5. Read the `research-extract-creator` skill (`/ai-resources/skills/research-extract-creator/SKILL.md`).
6. For each session report, launch a general-purpose sub-agent. Pass it: the skill content, the raw report path for that one session — project-root-relative and labeled by session letter, which the sub-agent reads in full and component by component before applying the skill, and it receives no other session's report — the Answer Specs for the questions in that session, the question-to-session mapping, and the two project reference docs by PATH (sub-agent reads each directly): `reference/quality-standards.md` and `reference/known-limits.md`. Task: produce one Research Extract per question covered. Write each to `/execution/research-extracts/{section}/{section}-Q[N]-extract.md`. Return: list of extracts produced (question ID, file path, brief quality note).
   - If multiple session reports are independent, launch sub-agents in parallel.
7. Write checkpoint to `/execution/checkpoints/{section}/{section}-step-2.3-checkpoint.md`. Include: full extract inventory (question ID → file path → session letter), any quality flags from sub-agents.
8. ▸ /compact — skill content no longer needed; checkpoint and extract files carry forward.

---

### Step 2.4: Review Research Extracts [delegate-qc]

After all extracts are produced:

1. Read the checkpoint from `/execution/checkpoints/{section}/{section}-step-2.3-checkpoint.md` for the extract inventory.
2. Read the `research-extract-verifier` skill (`/ai-resources/skills/research-extract-verifier/SKILL.md`). Extract its verification checks and verdict logic.
3. For each session's extracts, delegate to qc-gate agent, passing as content: (a) the raw research report, (b) the Research Extracts produced from it, and (c) the corresponding Answer Specs. The qc-gate agent applies the skill's five verification checks.
   - Launch qc-gate agents in parallel for independent sessions.
4. Write verification report to `/execution/extract-verification/{section}/{section}-extract-verification-[session-letter].md`.
5. Write checkpoint to `/execution/checkpoints/{section}/{section}-step-2.4-checkpoint.md`. Include: per-extract verdict (APPROVED / FLAG), flagged extract details and re-extraction instructions.
6. ▸ /compact — verification context no longer needed.
7. If all APPROVED: Stage 2 complete for this section.
8. If FLAG — RE-EXTRACT on any extract: present the re-extraction instructions to the operator. Route flagged extracts back to Step 2.3 for re-extraction using the specific instructions from the verification report. Do NOT re-extract automatically — only when the operator requests it.
9. **Quality log (trigger: all APPROVED):** Append one summary row to `/logs/research-quality-log.md`. Count source: step-2.4-checkpoint.md verdicts.
   `| {YYYY-MM-DD} | {project name from CLAUDE.md} | {section} | {total questions} | {1st-pass approved} | {re-extracted then approved} | {scarcity} |`
   - **1st-pass approved** — approved at Step 2.4 first verification run, no re-extraction
   - **Re-extracted then approved** — required ≥1 re-extraction before reaching approval
   - **Scarcity** — hit re-extraction ceiling without approval
   Sum of three counts = total questions.

---

### Subworkflow 2.S — Supplementary Research (Optional)

**Trigger:** After all extracts are APPROVED (Step 2.4 gate passed), operator reviews coverage verdicts across extracts and judges that THIN or MISSING components warrant supplementary research before entering Stage 3. Skip this subworkflow if coverage is acceptable.

**Provider pre-flight:** Re-read `Supplementary lead provider` and `Evidence executor` from Project Config. If the lead provider is `none`, do not start 2.S; report that no supplementary lane is configured and let the operator accept scarcity or update Project Config. Provider output is leads only and cannot enter an extract directly.

Skill loading: For each skill step below, read the skill file from the ai-resources repo at `/ai-resources/skills/[skill-name]/SKILL.md` and follow its instructions.

**Step 2.S0 — Extract Failed Components [Claude Code]**
Parse all approved Research Extracts from `/execution/research-extracts/{section}/` and extract every component with THIN or MISSING coverage verdict. Output structured list grouped by Question ID to `/execution/supplementary/{section}/{section}-failed-components.md`. Extraction only — no query drafting.

**Register-hit target-selection gate (C2 — calibrate against `known-limits`).** Before any component proceeds to query drafting (Step 2.S1), score each extracted THIN/MISSING component against the Known-Unavailable-Evidence Register in `reference/known-limits.md`:
- **Register hit + no new source class** — the component matches a register row AND the first pass already tried (or the register names) every applicable source class per `reference/source-class-hierarchy.md`: route the component **straight to the scarcity register** with the existing pass-1 proxy recorded as the ceiling. It earns **zero** supplementary attempts. Do NOT draft a query for it. This is the structural-scarcity case — re-searching a known-empty gap wastes a pass.
- **Register hit + a new source class is available** — the component matches a register row BUT a source class exists (per the hierarchy) that the first pass did not try: it qualifies for **one** supplementary attempt, scoped to that new source class only.
- **No register hit (thin-but-closable)** — the component is not a register row: it proceeds to query drafting normally under the two-pass allowance.

Tag each component's route in the failed-components output (`register-hit-ceiling` / `register-hit-new-class` / `thin-but-closable`) so Step 2.S1 only drafts queries for the latter two, and the scarcity register receives the first immediately.

**Step 2.S1 — Draft Supplementary Query Brief [delegate]**
1. Read the failed components extraction from Step 2.S0.
2. Read all Research Extracts from `/execution/research-extracts/{section}/`.
3. Read all Answer Specs from `/preparation/answer-specs/{section}/`.
4. Read the `supplementary-query-brief-drafter` skill.
5. Launch a general-purpose sub-agent. Pass it: the skill content, the configured supplementary lead provider, failed components, Research Extracts, and Answer Specs. Task: execute the skill logic (pass 1 or pass 2 as appropriate). Write output to `/execution/supplementary/{section}/{section}-query-brief-pass-[1/2].md`.
   Return: number of groups, number of queries, any components routed out.
6. GATE: Operator reviews query brief before execution.

**Step 2.S2 — Gather and Verify Supplementary Leads [Operator]**
1. Present the query brief's Section B to the operator for execution in the configured supplementary lead provider. Save the provider output to `/execution/supplementary/{section}/{section}-perplexity-raw-pass-[1/2].md`; the historical filename is retained for compatibility and does not select the provider.
2. Treat every returned citation as a candidate URL, not evidence. Build one bounded verification prompt for the configured evidence executor containing the target components, provider-origin tags, and candidate URLs.
3. The evidence executor runs and logs its own sweep first, then opens the candidate URLs as a separate pass. Full-page/PDF access and the normal audit/output schema remain mandatory. Unsupported, inaccessible, or snippet-only leads are discarded.
4. Save only the evidence executor's verified report to `/execution/supplementary/{section}/{section}-executor-verified-pass-[1/2].md`. This is the sole supplementary evidence input to Step 2.S3.

**Step 2.S3 — QC Executor-Verified Supplementary Evidence [delegate-qc]**
1. Read the evidence executor's verified report from Step 2.S2. Do not pass raw lead-provider output into QC as evidence.
2. Read all Research Extracts from `/execution/research-extracts/{section}/`.
3. Read the Query Brief Section A from Step 2.S1.
4. Read the `supplementary-research-qc` skill.
5. Launch a qc-gate sub-agent. Pass it: the skill content, executor-verified supplementary report, Research Extracts, and Query Brief Section A. Task: run the three checks per query and return per-query verdicts.
6. If this pass produces confirmed-scarcity outcomes, run the skill's Check 4 (sampled scarcity-verdict independence check): a fresh-context sub-agent — given only the sampled component's topic and the project lens, NOT the query brief — drafts one from-scratch verification query per sampled component (1–2 max); the operator executes it through the lead-provider and evidence-executor verification path in Step 2.S2. In-lens verified evidence found → route that component back to re-extraction instead of the scarcity register.
7. Write QC report to `/execution/supplementary/{section}/{section}-supplementary-qc-pass-[1/2].md` (including the Scarcity Independence Check block when Check 4 ran).
8. GATE: Operator confirms merge summary before proceeding.

**Step 2.S4 — Merge Supplementary Evidence [delegate]**
1. Read all Research Extracts from `/execution/research-extracts/{section}/`.
2. Read the QC-approved executor-verified supplementary results (MERGE/PARTIAL items from Step 2.S3). Refuse any item that exists only in the raw lead-provider output or lacks the evidence executor's source-access log.
3. Read all Answer Specs from `/preparation/answer-specs/{section}/`.
4. Read the `supplementary-evidence-merger` skill.
5. Launch a general-purpose sub-agent. Pass it: the skill content, Research Extracts, QC-approved results, and Answer Specs. Task: execute the skill logic. Write updated extracts to `/execution/research-extracts/`, replacing originals.
   Return: per question, which components changed verdict, claim count before/after, remaining THIN/MISSING.
6. ▸ /compact — supplementary pass context no longer needed.

**Step 2.S5 — Re-verify and Close**
Re-run Step 2.4 verification on affected extracts only. If still insufficient after pass 1: repeat Steps 2.S0–2.S5 as pass 2.

**Attempt ceiling (calibrated against `known-limits` — C2):** The cap is no longer a flat two passes for every gap; it depends on the Step 2.S0 route:
- **`thin-but-closable` gaps** — two-pass maximum (the prior hard constraint). Before initiating a supplementary pass, check `/execution/supplementary/` for existing pass files for this section. If pass 2 files exist, do NOT initiate another pass.
- **`register-hit-ceiling` gaps** — **zero** supplementary attempts. The gap is structurally unavailable per `known-limits`; the pass-1 proxy stands as the recorded ceiling. Never re-searched within this run.
- **`register-hit-new-class` gaps** — exactly **one** attempt, scoped to the untried source class. If that attempt does not close the gap, it becomes confirmed scarcity (no second attempt — the register already establishes the structural limit).

A `Last-checked` date in the register older than the project's current period (Project Config `Current period:` value) re-licenses a register-hit gap for a fresh attempt (per `known-limits.md` Stop rule).

**Scarcity handling:** Once a gap exhausts its route's attempt allowance (2 passes for `thin-but-closable`, 1 for `register-hit-new-class`, 0 for `register-hit-ceiling`), it is classified as confirmed evidence scarcity. For each:
- Append an entry to `/execution/scarcity-register/{section}/{section}-scarcity-register.md` with: Question ID, missing component, research attempted (passes summarized; for register-hit-ceiling, note the register row + pass-1 proxy), and editorial instruction (HEDGE / SCOPE CAVEAT / PROXY FRAMING — operator selects).
- PAUSE for operator to select the editorial instruction for each scarcity item.

**Outputs:**
- `/execution/supplementary/{section}/{section}-*.md` (per-step supplementary artifacts)
- Updated Research Extracts in `/execution/research-extracts/{section}/`
- Updated `/execution/scarcity-register/{section}/{section}-scarcity-register.md` (if scarcity confirmed)

---
