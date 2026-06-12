---
friction-log: true
model: sonnet
---
Execute the Stage 1 preparation pipeline.

The task plan draft is already in context (loaded via @ reference). Use its file name to derive the section identifier and name all outputs consistently (e.g., if the input is `task-plan-draft-1.1.md`, outputs use `1.1` as the section identifier).

Skill loading: For each skill step below, read the skill file from `/ai-resources/skills/[skill-name]/SKILL.md` and follow its instructions.

---

### Step 1: Create Task Plan [delegate]

1. Read `/ai-resources/skills/task-plan-creator/SKILL.md`.
2. Launch a general-purpose sub-agent. Pass it: the skill content and the task plan draft content. Task: execute the skill logic against the draft. Write output to `/preparation/task-plans/{section}-task-plan-v1.md`. Return: output file path, key scope decisions.
3. Write checkpoint to `/preparation/checkpoints/{section}-step-1-checkpoint.md` from the sub-agent's returned summary.
4. ▸ /compact — skill content and draft no longer needed; checkpoint carries forward.

---

### Step 1b: QC Task Plan [delegate-qc]

1. Read the task plan from the path in `/preparation/checkpoints/{section}-step-1-checkpoint.md`.
2. Launch a qc-gate sub-agent. Pass it: the task plan content and the original task plan draft content. Task: evaluate the task plan for structural completeness (all 8 sections present and substantive), internal consistency (scope-objective-deliverable alignment), downstream enablement (can research-plan-creator and answer-spec-generator operate from this?), and draft fidelity (no substantive content dropped). Return: verdict (APPROVED / REVISE) with findings.
3. If REVISE: note findings for operator.
4. PAUSE — Present the Task Plan and QC verdict to the operator for review. Wait for approval or revision instructions.

---

### Step 2: Update Project Context

1. Update the Project Context section of CLAUDE.md with the approved Task Plan's objective, scope, constraints, and audience.

---

### Step 3: Create Research Plan [delegate]

1. Read `/ai-resources/skills/research-plan-creator/SKILL.md`.
2. Launch a general-purpose sub-agent. Pass it: the skill content and the approved Task Plan content. Task: execute the skill logic against the Task Plan. Write to `/preparation/research-plans/{section}-research-plan-v1.md`. Return: output file path, research question inventory (question IDs and summaries).
3. Write checkpoint to `/preparation/checkpoints/{section}-step-3-checkpoint.md` from the sub-agent's returned summary. Include: output file path, question count, question-to-cluster mapping.
4. ▸ /compact — skill content no longer needed; checkpoint carries forward.
---

### Step 3b: QC Research Plan [delegate-qc]

1. Read the research plan from the path in `/preparation/checkpoints/{section}-step-3-checkpoint.md`.
2. Launch a qc-gate sub-agent. Pass it: the research plan content. Task: evaluate the research plan on six dimensions — (A) question-set completeness: all scoped RQs from the task plan are represented; (B) question-to-cluster mapping correctness; (C) researchability: each question is answerable within the project's source-availability posture (Project Config `Source-availability:` field); (D) anti-overlap: questions do not duplicate each other or known internal pre-answers without explicit routing; (E) answer-spec readiness: each question carries enough specificity for `answer-spec-generator` to operate from; (F) contract conformance: question set does not exceed or contradict the task plan's scope. Return: verdict (APPROVED / REVISE) with per-dimension findings.
3. If REVISE: note findings for operator.
4. Write verdict to `/preparation/checkpoints/{section}-step-3b-checkpoint.md`.
5. PAUSE — Present the Research Plan and QC verdict to the operator for review and approval. Do NOT proceed to Step 4 until the operator explicitly approves. If the operator requests changes, revise the Research Plan, re-QC, and re-present.

---

### Step 3c: Researchability Triage [inline]

> **Relationship to Step 3b.** Step 3b QC-gates the research plan's quality — including whether questions are framed appropriately for their evidential feasibility (dimension C). Step 3c consumes Step 3b's APPROVED verdict as a precondition and applies the `reference/known-limits.md` register and `reference/source-map.md` pre-answers to make the routing explicit. The two steps are complementary: 3b catches mis-framed questions (QC gate); 3c routes correctly-framed questions to their channels (routing gate). They do not contradict — 3b approves the plan's framing, 3c formalises the downstream routing.

1. Do NOT run Step 3c unless Step 3b returned APPROVED. Read the approved research plan from the path in `preparation/checkpoints/{section}-step-3b-checkpoint.md`.

2. For each RQ in the approved plan, score it against three inputs:
   - **`reference/known-limits.md` Known-Unavailable-Evidence Register** — register hit → `structurally-unavailable` or `proxy-only`
   - **`reference/source-map.md` internal pre-answers** — named internal source or concurrent-sibling duplicate → `internal-import`
   - **Project Config `Source-availability:` field** — governs whether web evidence is available at all

   Assign each RQ exactly one route:
   - `web-answerable` — public web evidence expected; proceed normally to answer-spec generation.
   - `proxy-only` — no primary public evidence; a best-available proxy exists; proceed to answer-spec generation with mandatory "best-available proxy + acknowledged gap" pre-tagging in the spec framing.
   - `structurally-unavailable` — a `known-limits.md` register hit confirms the evidence is structurally absent from public sources; **do NOT generate a web answer-spec**; route to the Evidence Boundary Register.
   - `internal-import` — question already answered by a named internal source (`source-map.md`) or is a concurrent-sibling-work duplicate; **do NOT generate a web answer-spec**; route to firm-held intake.

3. **Gate-reopener routing (execution-contract requirement, applies when the project's execution contract designates gate-reopener-eligible RQs).** If any gate-reopener-eligible RQ receives a `structurally-unavailable` or `proxy-only` classification, write a concrete proposed operator decision for that RQ into the triage table's Notes column and flag it for the Gate-Reopener register. Do NOT silently drop the RQ. Gate-reopener routing is a proposal for the operator, never a silent re-decision (execution contract: "gate-reopeners are proposals, never silent re-decisions").

4. **Advisory posture.** The triage table is a recommendation. The operator may re-route any RQ at the existing Stage-1 gate before answer specs are written. No RQ is dropped from answer-spec generation without that operator review passing.

5. **Forward-only scope.** This step applies to runs entering Stage 1 fresh. For a section already past Stage 1 (one that completed Stage 1 in an earlier session), this step is NOT retro-applied — do not generate a triage table for an in-flight section.

6. Write triage table to `preparation/checkpoints/{section}-step-3c-triage.md`. Columns: `RQ ID | Route | Known-Limits Hit | Source-Map Pre-answer | Notes`.

7. PAUSE — Present the triage table alongside the Research Plan at the existing Stage-1 gate. The operator reviews both together. Only `web-answerable` and `proxy-only` RQs proceed to Step 4 (answer-spec generation). `structurally-unavailable` RQs are routed to the Evidence Boundary Register; `internal-import` RQs are routed to firm-held intake.

---

### Step 4: Generate Answer Specs [delegate]

1. Read `/ai-resources/skills/answer-spec-generator/SKILL.md`.
2. Launch a general-purpose sub-agent. Pass it: the skill content and the approved Research Plan content. Task: execute the skill logic per chapter cluster. Write to `/preparation/answer-specs/{section}/chapter-NN-specs.md`. Return: list of spec files produced (file paths, question coverage per file).
3. Write checkpoint to `/preparation/checkpoints/{section}-step-4-checkpoint.md` from the sub-agent's returned summary. Include: spec file inventory (file path → questions covered).
4. ▸ /compact — skill content no longer needed; checkpoint carries forward.

---

### Step 5: QC Answer Specs [delegate-qc]

1. Read the checkpoint from `/preparation/checkpoints/{section}-step-4-checkpoint.md` for the spec file inventory.
2. Read the `answer-spec-qc` skill (`/ai-resources/skills/answer-spec-qc/SKILL.md`). Extract its evaluation criteria.
3. For each answer spec file, delegate to a qc-gate sub-agent, passing: the skill's evaluation criteria and the answer spec content. Write verdicts to `/preparation/answer-specs/{section}/answer-specs-qc.md`.
4. Write checkpoint to `/preparation/checkpoints/{section}-step-5-checkpoint.md`. Include: per-spec verdict (PASS / FAIL), any failure details.
5. ▸ /compact — QC skill and spec content no longer needed; checkpoint carries forward.
6. If any spec receives FAIL: present the failures and ask the operator whether to regenerate or manually revise.
7. PAUSE — Present approved answer specs for final review before Stage 2.

---

### Step 6: Log Completion

1. Log completion to `/logs/qc-log.md`.
