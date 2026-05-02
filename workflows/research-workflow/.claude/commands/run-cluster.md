---
friction-log: true
model: sonnet
---
Analyze all clusters for the current section in parallel. Runs cluster analysis and memo refinement for every cluster simultaneously, then presents all refined memos for a single operator review gate.

Prerequisite check: Read the step-2.4-checkpoint. Verify that research extracts for this section exist in `/execution/research-extracts/{section}/` with APPROVED verdicts. If any are missing or flagged, abort and report.

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
2. For each cluster, launch one general-purpose sub-agent. **Launch all cluster sub-agents in parallel.** Pass each sub-agent as content:
   - The `cluster-analysis-pass` skill content
   - The `cluster-memo-refiner` skill content
   - The extract file **paths** for this cluster (not the file content — the sub-agent reads its own extracts)
   - Scarcity register entries relevant to this cluster (pass as content)
   - Output paths: analysis memo at `/analysis/cluster-memos/{section}/{section}-cluster-{NN}-memo.md`, refined memo at `/analysis/cluster-memos/{section}/{section}-cluster-{NN}-memo-refined.md`
   - Task: (1) read the extracts at the provided paths; (2) execute `cluster-analysis-pass` logic and write the analysis memo; (3) execute `cluster-memo-refiner` six-check refinement and write the refined memo. Return: output file paths, key analytical themes, refinement check outcomes, evidence gaps flagged.
3. After all sub-agents complete, collect their summaries.
4. Write one checkpoint per cluster to `/analysis/checkpoints/{section}/{section}-cluster-{NN}-step-2-checkpoint.md` from each sub-agent's returned summary.
5. Log cluster completion to `/logs/qc-log.md`.

---

### Step 3: Operator Review

Present a structured summary of all completed clusters:
- Per cluster: refined memo file path, key analytical themes returned by sub-agent, evidence gaps flagged
- List all refined memo file paths so the operator can open them for review

PAUSE — Operator reviews all refined cluster memos before proceeding to `/run-analysis`.
