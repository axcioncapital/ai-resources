---
friction-log: true
model: sonnet
---
Execute the Stage 3 cluster synthesis pipeline (Pass 4 — chapter drafting constrained by Pass 3 permission verdicts).

Prerequisite check: Verify that `/run-analysis` has completed — refined cluster memos and section directives exist, and the QC log shows operator approval of memos and directives. The gate-clearance pre-flight (Step 0 below) is the load-bearing pre-condition.

Skill loading: For each skill step below, read the skill file from `/ai-resources/skills/[skill-name]/SKILL.md` and follow its instructions.

---

### Step 0: Pre-flight — Gate-Clearance Check (FAIL-SAFE)

This command is Pass 4 of the four-pass research model. It requires the gate-clearance file produced by `/run-sufficiency` (Pass 3 Phase F). Without that file, this command will NOT proceed — fail-safe behavior is the locked default; there is no warn-and-proceed mode.

1. Read `/analysis/gate-clearance/{section}/{section}-gate-clearance.md`.
2. **If the file is absent:** exit. Emit:
   > `/run-synthesis` requires `/analysis/gate-clearance/{section}/{section}-gate-clearance.md`, produced by `/run-sufficiency` (Pass 3 Phase F). The file is absent. Run `/run-sufficiency {section}` first (after `/run-cluster {section}` and before `/run-analysis {section}`), then re-invoke `/run-synthesis {section}`.
3. **If the verdict is `BLOCKED`:** exit. Emit:
   > Gate-clearance verdict is BLOCKED for section {section}. The per-cluster or section-level NOT-SUPPORTED ratio exceeds project thresholds (see `per_cluster_ratios` in the gate-clearance file). Address the failing clusters, re-run `/run-sufficiency {section}`, then re-invoke. Operator override possible via `verdict: OPERATOR-OVERRIDE` with signed `override_rationale:` — see `/run-sufficiency` § Operator-override on `BLOCKED` verdict.
4. **If the verdict is `CLEARED-WITH-CAVEATS`:** proceed. Capture the `caveats:` list and attach it to the synthesis brief passed to `cluster-synthesis-drafter` so caveats appear in the Evidence Limitations back-matter of the chapter draft.
5. **If the verdict is `OPERATOR-OVERRIDE`:** treat as `CLEARED-WITH-CAVEATS`. Capture the `override_rationale:` field, attach to the synthesis brief, AND auto-append a one-line entry to `/logs/decisions.md` recording the override and rationale.
6. **If the verdict is `CLEARED`:** proceed without caveats.

The gate-clearance verdict is the load-bearing contract between Pass 3 and Pass 4. Do not skip this step; do not attempt to bypass with a sentinel file or environment variable.

Additionally: read the per-cluster permission tables from `/analysis/claim-permission/{section}/`. These constrain what `cluster-synthesis-drafter` may state — a chapter may not state a NOT-SUPPORTED claim; PROXY-SUPPORTED and ILLUSTRATIVE-ONLY claims must carry their permission-class signal into prose. Pass the relevant per-cluster permission table to each cluster's synthesis sub-agent in Step 2.

---

### Step 1: Load Inputs

1. Read all refined cluster memos from `/analysis/cluster-memos/{section}/`.
2. Read all section directives from `/analysis/section-directives/{section}/`.
3. Read the scarcity register from `/execution/scarcity-register/{section}/{section}-scarcity-register.md` (if it exists).

---

### Step 2: Cluster Synthesis [delegate]

1. Read `/ai-resources/skills/cluster-synthesis-drafter/SKILL.md`.
2. For each cluster, launch a general-purpose sub-agent. Pass it: the skill content, the cluster's refined memo, the cluster's section directive, and any relevant scarcity register entries. Task: execute the skill logic. Write to `/analysis/chapters/{section}/{section}-cluster-NN-draft.md`. Return: output file path, chapter structure summary, evidence coverage notes.
   - Launch sub-agents in parallel for independent clusters. Run ▸ /compact between clusters if there are more than 3 clusters and running sequentially.
3. Write checkpoint to `/analysis/checkpoints/{section}/{section}-step-3.7-synthesis-checkpoint.md`. Include: chapter draft file inventory (cluster → file path), completion status.
4. ▸ /compact — skill content and directive content no longer needed.

---

### Step 3: Log Completion

1. Log to `/logs/qc-log.md`.
