---
friction-log: true
model: sonnet
---
Analyze all clusters for the current section in parallel (entry into Pass 3 — Evidence Sufficiency Check). Runs cluster analysis and memo refinement for every cluster simultaneously, then presents all refined memos for a single operator review gate.

After operator approval of refined memos, the next command in the sequence is `/run-sufficiency` (Pass 3 sufficiency adjudication via claim-permission gate, country-parity check, stop-conditions, source-conflict resolution, gate-clearance emission). Only after `/run-sufficiency` emits a gate-clearance file may `/run-analysis` and `/run-synthesis` proceed — those commands fail-safe-exit if the gate-clearance file is absent. See `reference/stage-instructions.md` § Pass 3 for the contract.

Prerequisite check: Read the step-2.4-checkpoint. Verify that research extracts for this section exist in `/execution/research-extracts/{section}/` with APPROVED verdicts. If any are missing or flagged, abort and report.

Stage-entry reference-file completeness gate (per `reference/stage-instructions.md` § Stage-Entry Reference-File Completeness Gate): before launching the cluster sub-agents in Step 2, verify the three reference docs this command passes to them — `reference/source-class-hierarchy.md`, `reference/quality-standards.md`, `reference/known-limits.md` — are present **AND filled** (not shape-only template placeholders). All three are hard-class: if any is absent or unfilled, halt with a remediation prompt naming the file and its template; do not launch sub-agents against placeholder references.

Skill loading: For each skill step below, read the skill file from `/ai-resources/skills/[skill-name]/SKILL.md` and follow its instructions.

---

### Step 1: Build Cluster Map

1. Read the Research Plan from `/preparation/research-plans/` to identify the cluster groupings — which questions belong to which cluster. Note the cluster labels (e.g., Cluster 01, Cluster 02) and their question assignments.
2. List the extract files in `/execution/research-extracts/{section}/` — file paths only, not content.
3. Read the scarcity register from `/execution/scarcity-register/{section}/{section}-scarcity-register.md` (if it exists).
4. Build a cluster map: for each cluster, record the extract file paths for its questions and any relevant scarcity register entries.

---

### Step 2: Parallel Cluster Analysis and Refinement [delegate]

1. Read `/ai-resources/skills/cluster-analysis-pass/SKILL.md` and `/ai-resources/skills/cluster-memo-refiner/SKILL.md`.
2. Read the project reference docs the two skills consume: `reference/source-class-hierarchy.md` (Project Country Set, Hierarchy Table, Source-Exhaustion Ladders — drives B-02 country-status columns and ladder-depth thresholds), `reference/quality-standards.md` (Country Coverage Table, Minimum Evidence Thresholds, Source-Diversity Matrix, Claim-Permission Classes, Source-Conflict Resolution Procedure — drives B-18 same-pattern thresholds and Check 9 ladder-depth), `reference/known-limits.md` (Known-Unavailable-Evidence Register — drives the pan-region/superset-leakage check against any structurally-thin country in the project's country set).
3. For each cluster, launch one general-purpose sub-agent. **Launch all cluster sub-agents in parallel.** Pass each sub-agent as content:
   - The `cluster-analysis-pass` skill content
   - The `cluster-memo-refiner` skill content
   - The three project reference docs from Step 2 above (`reference/source-class-hierarchy.md`, `reference/quality-standards.md`, `reference/known-limits.md`)
   - The extract file **paths** for this cluster (not the file content — the sub-agent reads its own extracts)
   - Scarcity register entries relevant to this cluster (pass as content)
   - Output paths: analysis memo at `/analysis/cluster-memos/{section}/{section}-cluster-{NN}-memo.md`, refined memo at `/analysis/cluster-memos/{section}/{section}-cluster-{NN}-memo-refined.md`
   - Task: (1) read the extracts at the provided paths; (2) execute `cluster-analysis-pass` logic and write the analysis memo; (3) execute `cluster-memo-refiner` six-check refinement and write the refined memo. Return: output file paths, key analytical themes, refinement check outcomes, evidence gaps flagged.
4. After all sub-agents complete, collect their summaries.
5. Write one checkpoint per cluster to `/analysis/checkpoints/{section}/{section}-cluster-{NN}-step-2-checkpoint.md` from each sub-agent's returned summary.
6. Log cluster completion to `/logs/qc-log.md`.

---

### Step 3: Operator Review

Present a structured summary of all completed clusters:
- Per cluster: refined memo file path, key analytical themes returned by sub-agent, evidence gaps flagged
- List all refined memo file paths so the operator can open them for review

PAUSE — Operator reviews all refined cluster memos before proceeding to `/run-analysis`.
