---
friction-log: true
model: sonnet
---
Execute the cross-cluster Stage 3 pipeline (Pass 4 — Synthesis).

Prerequisite check: Verify refined cluster memos exist in `/analysis/cluster-memos/` for all clusters. Verify all have been reviewed (check QC log).

Skill loading: For each skill step below, read the skill file from `/ai-resources/skills/[skill-name]/SKILL.md` and follow its instructions.

---

### Step 0: Pre-flight — Gate-Clearance Check (FAIL-SAFE)

This command is Pass 4 of the four-pass research model. It requires the gate-clearance file produced by `/run-sufficiency` (Pass 3 Phase F). Without that file, this command will NOT proceed — fail-safe behavior is the locked default; there is no warn-and-proceed mode.

1. Read `/analysis/gate-clearance/{section}/{section}-gate-clearance.md`.
2. **If the file is absent:** exit. Emit:
   > `/run-analysis` requires `/analysis/gate-clearance/{section}/{section}-gate-clearance.md`, produced by `/run-sufficiency` (Pass 3 Phase F). The file is absent. Run `/run-sufficiency {section}` first, then re-invoke `/run-analysis {section}`.
3. **If the verdict is `BLOCKED`:** exit. Emit:
   > Gate-clearance verdict is BLOCKED for section {section}. The per-cluster or section-level NOT-SUPPORTED ratio exceeds project thresholds (see `per_cluster_ratios` in the gate-clearance file). Address the failing clusters, re-run `/run-sufficiency {section}`, then re-invoke. Operator override possible via `verdict: OPERATOR-OVERRIDE` with signed `override_rationale:` — see `/run-sufficiency` § Operator-override on `BLOCKED` verdict.
4. **If the verdict is `CLEARED-WITH-CAVEATS`:** proceed. Capture the `caveats:` list and attach it to the synthesis brief passed to downstream skills (Step 3.5 directive drafter, Step 3.7 cluster synthesis drafter).
5. **If the verdict is `OPERATOR-OVERRIDE`:** treat as `CLEARED-WITH-CAVEATS`. Capture the `override_rationale:` field, attach to the synthesis brief, AND auto-append a one-line entry to `/logs/decisions.md` recording the override and rationale.
6. **If the verdict is `CLEARED`:** proceed without caveats.

The gate-clearance verdict is the load-bearing contract between Pass 3 and Pass 4. Do not skip this step; do not attempt to bypass with a sentinel file or environment variable.

---

### Step 1: Load Inputs

1. Read all refined cluster memos from `/analysis/cluster-memos/{section}/`.

---

### Step 2: Gap Assessment [delegate]

1. Read `/ai-resources/skills/gap-assessment-gate/SKILL.md`.
2. Launch a general-purpose sub-agent. Pass it: the skill content, all refined cluster memo content, and the scarcity register from `/execution/scarcity-register/{section}/{section}-scarcity-register.md` (if it exists). Task: execute the gap assessment across all memos, accounting for items already classified as scarcity. Write to `/analysis/gap-assessment/{section}/{section}-gap-assessment.md`. Return: output file path, gap inventory (gap ID, cluster, path classification, severity).
3. Write checkpoint to `/analysis/checkpoints/{section}/{section}-step-2-gap-assessment-checkpoint.md` from the sub-agent's returned summary. Include: gap count, per-gap path classification (A/B), affected clusters.
4. ▸ /compact — skill content and memo content no longer needed; checkpoint carries forward.
5. PAUSE — Present gap assessment to the operator. **The halt is unconditional — no timeout, no auto-approve.** For each gap:
   - Path B (non-blocking): propose lightweight Perplexity queries
   - Path A (blocking): flag for full Stage 2 re-execution on affected questions
   - The operator approves routing.

---

### Step 3: Supplementary Research (if needed)

1. If Path B gaps approved, execute Subworkflow 3.S (see below).
2. After Subworkflow 3.S completes, re-run gap assessment on affected clusters only: repeat Step 2 scoped to the clusters that received supplementary research. If all gaps are now resolved or classified as scarcity, proceed. If new Path A gaps surface, PAUSE for operator routing.

---

### Step 3.5: Unit Judgment Brief — produce, challenge, decide

Gaps are resolved and no report-bound analytical writing has started. This is the one point where combined research becomes a stated Axcíon view, and that view is the single analytical authority for everything downstream.

The authority rules — artifact shape, lifecycle, challenge record, promotion, consumption — are `docs/judgment-authority-contract.md`. The shape and authoring guidance are `reference/unit-judgment-brief.template.md`. This step **wires** them into the route; it does not restate them, and it does not add a second approval path or a second judgment artifact.

**Base path for this section.** `{base}` = `/analysis/judgment/{section}/{section}-unit-judgment-brief`. The three suffixes — `-proposed.md`, `-review.md`, `-approved.md` — are fixed by the contract and are not a caller's choice. Create `/analysis/judgment/{section}/` if it does not exist.

#### Step 3.5a: Produce the proposal [delegate]

1. Read `reference/unit-judgment-brief.template.md`.
2. Launch a general-purpose sub-agent. Pass it the template content, the output path `{base}-proposed.md`, and the two input bundles **as two separately labelled lists**. Keeping them apart is the thing the challenge checks, so the separation is carried in the dispatch itself and the lists never merge:

   **Evidence bundle:** — determines what can be concluded. Passed as paths; the sub-agent reads each itself.
   - `/analysis/cluster-memos/{section}/` — every refined cluster memo
   - `/analysis/claim-permission/{section}/` — the per-cluster permission tables from Pass 3 Phase A
   - `/analysis/gate-clearance/{section}/{section}-gate-clearance.md` — verdict and any caveats
   - `/analysis/gap-assessment/{section}/{section}-gap-assessment.md` — the resolved gap inventory
   - `/execution/scarcity-register/{section}/{section}-scarcity-register.md` — confirmed scarcity

   **Axcíon context bundle:** — determines why a conclusion matters and how it is framed. Passed as paths; the sub-agent reads each itself.
   - `/reference/judgment-context-card.md` — where the project keeps one; skip if absent
   - `/preparation/task-plans/` — the approved unit task plan
   - `/preparation/research-plans/` — the approved research plan
   - `/logs/decisions.md` — unit-specific operator decisions made after those plans

   Standing constraints on the sub-agent: every thesis cites at least one existing claim ID; context may never strengthen an evidence grade, close a gap, turn a hypothesis into a market fact, or convert a failed search into proof of absence; write `status: proposed` and no other status. Do NOT run git / do not commit / do not push.

   **Return (withheld from the reviewer):** the output path, the thesis count, and the claim IDs cited. Nothing else — no reasoning, no defence of the theses.

3. Shape-check the proposal before any reviewer is dispatched against it:
   ```bash
   bash "$CLAUDE_PROJECT_DIR/logs/scripts/check-judgment-contract.sh" "{base}-proposed.md" --allow-proposed
   ```
   Exit 0 → continue to 3.5b. Any other exit → the proposal is malformed (`5` no claim IDs, `6` structural or separation failure); return it to this step with the reported failure. Do not dispatch a reviewer against a proposal that fails its own shape check.

#### Step 3.5b: Independent challenge [delegate-qc]

The reviewer must not be the agent that wrote the brief, and must not inherit what that agent said about it.

1. Launch a qc-gate sub-agent. Pass it: the proposal by PATH `{base}-proposed.md` — the sub-agent reads the complete file itself — the same evidence-bundle and context-bundle paths passed at 3.5a, and the five challenge questions from `reference/unit-judgment-brief.template.md` § What the challenge asks.
2. **Withheld from the reviewer:** everything 3.5a returned — the thesis count, the cited claim IDs and any producer summary, reasoning or transcript. The reviewer reads the file and forms its own view; a reviewer briefed on the producer's account is reviewing that account, not the brief.
3. Return: an overall verdict, and for each required-change finding one line stating the finding plus its tag where one applies — `permission-breach` (an evidence-permission overreach) or `decision-conflict: {id}` (a conflict with an operator decision). A reviewer that raised nothing returns exactly that; silence and omission read identically and only one of them is a review.

#### Step 3.5c: Record the challenge

The main session writes this record. It did not author the brief, and writing the binding here rather than in the reviewer is what makes the binding mechanical.

1. If `{base}-review.md` already exists, archive it first to `{base}-review-round-{N}.md`, where `{N}` is its own `review_round:`. Rounds are kept, never overwritten.
2. Compute the binding from the proposal file itself:
   ```bash
   shasum -a 256 "{base}-proposed.md" | cut -d' ' -f1
   ```
   Write that value as `reviews_sha256:`. **Never copy a digest from a sub-agent's return** — a digest a model reports is a claim about the file; this one is the file.
3. Write `{base}-review.md`: `unit:`, `artifact: unit-judgment-brief-review`, `reviews:` (the proposal path), `reviews_sha256:` (from step 2), `review_round:` (1, or the previous round + 1), `status: findings-only`, `as_of:`.
4. Ledger: one `finding: F{n}` / `tags:` / `disposition: PENDING` / `reason:` entry per required-change finding, carrying forward every finding id any earlier round raised. Where the reviewer raised nothing, write the explicit empty ledger `findings: none`.
5. Verify the record's shape and binding:
   ```bash
   bash "$CLAUDE_PROJECT_DIR/logs/scripts/check-judgment-challenge.sh" "{base}-proposed.md" --shape-only
   ```
   Exit 0 → continue. Any other exit → fix the record; do not present a malformed challenge to the founder.

#### Step 3.5d: Founder decision

**PAUSE. The halt is unconditional — no timeout, no auto-approve, no inferred approval, and no continuation on silence.**

Present, in one message: the proposal path, the challenge record path, the finding ledger with each finding's current disposition, and the fact that the proposed brief is not authority. Then accept exactly one of:

- **approve** — every required-change finding must first carry a terminal disposition (`REVISED-AND-RE-REVIEWED`, or `OPERATOR-ACCEPTED` with its reasons). Then run the one mechanical transition, never authoring `{base}-approved.md` by hand:
    ```bash
    bash "$CLAUDE_PROJECT_DIR/logs/scripts/promote-judgment-brief.sh" "{base}-proposed.md" \
      --approval "<the founder's verbatim reply>" \
      --approved-by "<the founder's identity>"
    ```
    Exit 0 → continue to 3.5e. Any other exit → report the refusal and return to this pause; it refuses exactly the promotions that should not happen.
- **revise** — return to Step 3.5a in revision mode with the founder's instruction and the open findings. The revision changes the proposal's bytes, so the recorded challenge goes stale by construction; run Step 3.5b again as the next review round and rebuild the record at 3.5c, carrying every earlier finding id forward. Then return to this pause.
- **reject** — set `status: rejected` and `rejected_by: {founder identity}` on `{base}-proposed.md`. Nothing is promoted, no authority is created, and the rejection is the durable outcome. `/run-analysis` stops here; it does not continue to Step 4.
- **anything else** — silence, a question, a partial reply, an edit request or an ambiguous acknowledgement is **not a decision**. Re-present and wait. Nothing runs, nothing is written, and the route does not advance.

Log the decision and its one-line rationale to `/logs/decisions.md`.

#### Step 3.5e: Authority gate

Nothing past this seam runs on anything but a validated approved brief:

```bash
bash "$CLAUDE_PROJECT_DIR/logs/scripts/check-judgment-contract.sh" "{base}-approved.md"
```

Exit 0 → proceed to Step 4. Any other exit → halt and report the code: `3` no approved brief (the founder has not approved), `4` present but not approved (still proposed, or rejected), `5` approved with no evidence basis, `6` structural failure. Branch on the code, never on the prose, and never regenerate over a present-but-invalid authority.

Write checkpoint to `/analysis/checkpoints/{section}/{section}-step-3.5-judgment-checkpoint.md`. Include: the approved brief path, thesis count, review rounds run, and each finding's terminal disposition.

▸ /compact — the template and the bundle content are no longer needed; the approved brief and the checkpoint carry forward.

---

### Step 4: Section Directives [delegate]

1. Read `/ai-resources/skills/section-directive-drafter/SKILL.md`.
2. For each cluster, launch a general-purpose sub-agent. Pass it: the skill content, the cluster's refined memo, and the scarcity register (`/execution/scarcity-register/{section}/{section}-scarcity-register.md`) as a required input. Task: execute the skill logic for this cluster. Each directive must reference any scarcity items for its cluster and specify the editorial instruction (HEDGE / SCOPE CAVEAT / PROXY FRAMING). Write to `/analysis/section-directives/{section}/{section}-cluster-NN-directive.md`. Return: output file path, scarcity items referenced, key editorial decisions.
   - Launch sub-agents in parallel for independent clusters.
3. Write checkpoint to `/analysis/checkpoints/{section}/{section}-step-4-directives-checkpoint.md`. Include: directive file inventory (cluster → file path), scarcity items referenced per directive.
4. ▸ /compact — skill content no longer needed; checkpoint carries forward.

---

### Step 5: Memo Review [delegate]

1. Read `/ai-resources/skills/analysis-pass-memo-review/SKILL.md`.
2. Launch a general-purpose sub-agent. Pass it: the skill content, all refined cluster memos, and all section directives. Task: execute the editorial decision surfacing review. Write to `/analysis/editorial-review/{section}/{section}-memo-review.md`. Return: output file path, editorial decisions surfaced, flags for operator attention.
3. Write checkpoint to `/analysis/checkpoints/{section}/{section}-step-5-memo-review-checkpoint.md`. Include: output file path, count of editorial decisions surfaced, severity flags.
4. ▸ /compact — skill content no longer needed; checkpoint carries forward.

---

### Step 5b: Generate Editorial Recommendations [delegate]

1. Read `/ai-resources/skills/editorial-recommendations-generator/SKILL.md`.
2. Launch a general-purpose sub-agent. Pass it: the skill content, `/analysis/editorial-review/{section}/{section}-memo-review.md`, all refined cluster memos, the scarcity register from `/execution/scarcity-register/{section}/{section}-scarcity-register.md`, and all section directives. Task: generate recommended answers for all editorial decisions. Write to `/analysis/editorial-review/{section}/{section}-memo-review-recommendations.md`. Return: output file path, recommendation count, any confidence flags.
3. Write checkpoint to `/analysis/checkpoints/{section}/{section}-step-5b-recommendations-checkpoint.md`. Include: output file path, recommendation count, confidence flags, scarcity editorial instructions recommended.
4. ▸ /compact — skill content no longer needed; checkpoint carries forward.

---

### Step 5c: QC Editorial Recommendations [delegate-qc]

1. Read `/ai-resources/skills/editorial-recommendations-qc/SKILL.md`.
2. Launch a sub-agent (qc-gate type for independence). Pass it: the skill content, `/analysis/editorial-review/{section}/{section}-memo-review.md`, `/analysis/editorial-review/{section}/{section}-memo-review-recommendations.md`, all refined cluster memos, the scarcity register, and all section directives. Task: independently derive recommendations from the evidence, then compare against the originals and score each. Write to `/analysis/editorial-review/{section}/{section}-qc-editorial-decisions.md`. Return: output file path, verdict distribution (AGREE/DISAGREE/NUANCE counts), flagged disagreements.
3. Write checkpoint to `/analysis/checkpoints/{section}/{section}-step-5c-qc-checkpoint.md`. Include: output file path, verdict distribution, list of DISAGREE items.
4. ▸ /compact — skill content no longer needed; checkpoint carries forward.

---

### Step 5d: Approve Editorial Decisions [auto-delegate]

Launch a general-purpose sub-agent to make editorial calls based on the QC results. This step runs automatically — no operator pause.

1. Launch a general-purpose sub-agent. Pass it: the memo review (`{section}-memo-review.md`), recommendations (`{section}-memo-review-recommendations.md`), and QC report (`{section}-qc-editorial-decisions.md`). Task: apply the following decision logic and write approved decisions.

   **Decision logic:**
   - QC AGREE → Accept recommendation as-is
   - QC NUANCE → Accept recommendation with the QC's proposed adjustment applied
   - QC DISAGREE → **PAUSE for operator** — do not auto-approve. Present the disagreement with both positions and evidence for operator decision.

   **Confidence flag handling:**
   - LOW CONFIDENCE: Accept recommendation but preserve the alternative framing as a noted option for operator review at synthesis stage
   - ASSUMPTION-DEPENDENT: Accept, noting the assumption (PE fund audience)
   - DEPENDENCY flags: Verify consistency across all linked decisions before approving

   **Write to:** `/analysis/editorial-review/{section}/{section}-editorial-decisions-approved.md`

   **Output format:**
   ```
   # Approved Editorial Decisions — Section {section}
   **Date:** [date]
   **Approved by:** Editorial Decision Agent (operator-delegated)
   **Basis:** Recommendations + QC ([n] AGREE, [n] NUANCE adjusted, [n] DISAGREE)

   ## Scarcity Register Instructions (Approved)
   [Table: item, instruction, rationale]

   ## Approved Decisions
   [Per decision: ID, decision, rationale (1 line), QC status]

   ## Nuance Adjustments Applied
   [Items showing what was adjusted per QC]

   ## Noted Alternatives (LOW CONFIDENCE items)
   [Alternative framings preserved for operator review at synthesis]

   ## Dependency Consistency Check
   [Verification that linked decisions are aligned]
   ```

2. If any QC DISAGREE items exist, PAUSE and present them to the operator with both positions. Resume only after operator resolves each disagreement.
3. Append QC log entry to `/logs/qc-log.md`:
   ```
   ## [date] — Section {section}, Step 3.6 Gate
   - **Artifact:** Editorial decisions ([n] decisions + [n] scarcity items)
   - **Verdict:** APPROVED (agent-delegated) / APPROVED (operator-resolved [n] disagreements)
   - **Basis:** Recommendations QC: [n] AGREE, [n] NUANCE (adjusted), [n] DISAGREE
   - **Files:** `analysis/editorial-review/{section}/{section}-editorial-decisions-approved.md`
   ```
4. Write checkpoint to `/analysis/checkpoints/{section}/{section}-step-5d-approved-checkpoint.md`.
5. ▸ /compact

---

### Step 6: Hand Off to Synthesis

After editorial decisions are approved, log and hand off.

1. Present: "Memos, directives, and editorial decisions approved. Start a new session and run `/run-synthesis` for chapter drafting with fresh context."

---

### Subworkflow 3.S: Lightweight Supplementary Research

**Trigger:** Gap assessment identifies Path B (non-blocking) gaps, and operator approves routing.

**Prompt files:** All prompts live in `/ai-resources/prompts/supplementary-research/`. Claude Code reads each prompt file, substitutes project inputs into the placeholders, and executes. The operator's only manual step is S.2 (Perplexity queries).

**Inputs:**
- Path B gap items from `/analysis/gap-assessment/{section}/{section}-gap-assessment.md`
- Relevant cluster memos from `/analysis/cluster-memos/{section}/`
- Research extracts for context

**S.0 — Extract Failed Components [Claude Code]**
Read `/ai-resources/prompts/supplementary-research/S0-extract-failed-components.md`. Execute against the gap assessment report from `/analysis/gap-assessment/{section}/{section}-gap-assessment.md`, scoped to Path B items only. Write output to `/analysis/gap-supplementary/cluster-NN-failed-components.md`.

**S.1 — Draft Query Brief [Claude Code]**
Read `/ai-resources/prompts/supplementary-research/S1-query-brief-pass1.md` (or `S1-query-brief-pass2.md` for pass 2). Execute using: the failed components extraction, relevant Research Extracts from `/execution/research-extracts/{section}/`, and cluster memos. For pass 2, also include: the pass 1 Query Brief and pass 1 raw Perplexity output. Write output to `/analysis/gap-supplementary/cluster-NN-query-brief-pass-N.md`.

**PAUSE — S.2 — Execute in Perplexity [Operator]**
Present the query brief's Section B (Execution Sheet) to the operator. He runs queries manually in Perplexity Pro Search (no API). The operator pastes raw Perplexity output back into Claude Code. Write raw output to `/analysis/gap-supplementary/cluster-NN-perplexity-raw-pass-N.md`.

**S.3 — QC Results [Claude Code]**
Read `/ai-resources/prompts/supplementary-research/S3-qc-supplementary-results.md`. Execute against: the raw Perplexity output, Research Extracts, and Query Brief Section A. Write QC report to `/analysis/gap-supplementary/cluster-NN-qc-pass-N.md`. PAUSE for operator to confirm merge/skip verdicts.

**S.4 — Integrate into cluster memos [Claude Code]**
Read `/ai-resources/prompts/supplementary-research/S4-merge-instructions.md`. For each MERGE-approved finding:
   - Add to the relevant cluster memo's evidence base
   - Tag supplementary sources with `[SUPPLEMENTARY-PASS-N]`
   - Include **Route Out editorial instructions** where gaps could not be fully resolved: specify hedging language, scope caveats, or proxy framing that the cluster memo should carry forward to section directives and report prose.

**S.5 — Checkpoint and compact**
Write checkpoint to `/analysis/checkpoints/{section}/{section}-3S-pass-N-checkpoint.md`. Include: queries executed, findings per gap, memos updated, gaps resolved vs remaining, scarcity candidates. ▸ /compact — supplementary pass context no longer needed.

If still insufficient after pass 1: repeat S.0–S.5 as pass 2.

**Two-pass maximum (hard constraint):** Track pass count via file naming (`cluster-NN-query-brief-pass-1.md`, `cluster-NN-query-brief-pass-2.md`). Maximum 2 passes per question. After 2 passes, remaining gaps are classified as confirmed evidence scarcity.

**Scarcity handling:** Update `/execution/scarcity-register/{section}/{section}-scarcity-register.md` with any newly confirmed scarcity items from Stage 3. These follow the same format and operator-selected editorial instructions as Stage 2 scarcity items.

**After Subworkflow 3.S completes:** Re-run gap assessment on affected clusters only (handled by Step 3.2 above). If all gaps resolved or classified as scarcity, proceed to Step 4 (Section Directives).

**Outputs:**
- `/analysis/gap-supplementary/cluster-NN-*.md` (per-step supplementary artifacts)
- Updated cluster memos with integrated findings and Route Out instructions
- Updated `/execution/scarcity-register/{section}/{section}-scarcity-register.md` (if new scarcity items confirmed)
