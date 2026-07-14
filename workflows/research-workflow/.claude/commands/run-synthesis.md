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

7. **⚠ Chassis-provenance gate on the permission tables — check before passing ANY table to a synthesis sub-agent, and exit on failure.** For every permission table read above, check its frontmatter `chassis_version:` field. **`/run-synthesis` requires `chassis_version: 2026-07-14` or later.** If the field is **absent**, or its date is **earlier than `2026-07-14`**, exit. Emit:
   > Permission table `{path}` carries chassis version `{version or 'unversioned (pre-2026-07-14)'}`. Its class verdicts were graded by a rule set with a known gap and overlap and must not be used to constrain synthesis prose. Re-adjudication is required.
   >
   > **Do these in order — step 2 is NOT reversible by `git revert`:**
   > 1. **Back-port** `§ Claim-Permission Classes` from the canonical `reference/quality-standards.md` into this project's own copy.
   > 2. Delete `analysis/{section}/.claim-permission-gate.done`.
   > 3. Re-run `/run-sufficiency {section}`, then re-invoke `/run-synthesis {section}`.

   **The ordering is load-bearing.** `claim-permission-gate` carries its own chassis-version hard exit, so deleting the sentinel *before* the back-port lands the operator in a second hard exit with the sentinel already gone. Never print "delete the sentinel and re-run" without the back-port step first (found by `/risk-check`, 2026-07-14 — the first draft of this gate dead-ended exactly that way).

   **Also apply the re-stamp invariant — a version field alone is forgeable.** `chassis_version` is self-asserted frontmatter; a hand-pasted line defeats a bare presence-and-date check. So additionally require:

   > **`generated_at` MUST be greater than or equal to `chassis_version`.** A table cannot have been produced *before* the rules that produced it existed.

   If `generated_at` precedes `chassis_version`, the table was **re-stamped, not re-adjudicated**. Exit: *"Permission table `{path}` declares `chassis_version: {v}` but was generated `{generated_at}`, before that chassis existed. The stamp was added without re-adjudicating the claims. Delete `analysis/{section}/.claim-permission-gate.done` and re-run `/run-sufficiency {section}` — do not hand-edit the version field."* This matters here because § Operator-override already documents a path where the operator edits permission tables by hand.

   **Why this is an exit and not a caveat.** The permission class is what licenses a verb and a framing at Pass 4 — it is the last control between an evidence verdict and a sentence in the report. A stale table does not fail loudly; it hands Pass 4 a *wrong permission*. Demonstrated by execution 2026-07-14: re-adjudicating a real pre-2026-07-14 table under the current chassis moved **2 of 6 claims** from `PROXY-SUPPORTED` to `ILLUSTRATIVE-ONLY` — and `PROXY-SUPPORTED` licenses a hedged market-pattern generalization that `ILLUSTRATIVE-ONLY` forbids outright. Passing the stale table forward would have let synthesis assert two market-level claims the evidence does not carry, with no error anywhere in the pipeline. **This is the same gate `section-directive-drafter` and the Pass-3 skills carry; the three must stay in lockstep** (see `reference/quality-standards.md § Provenance is stamped on outputs, not only gated on inputs`).

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
