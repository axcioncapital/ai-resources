---
friction-log: true
model: sonnet
---
Execute the Stage 4 report production pipeline.

Prerequisite check: Verify chapter drafts exist in `/analysis/chapters/{section}/`, memos/directives are approved in the QC log, and editorial recommendations (Step 3.6b/3.6c) are approved. This command expects a fresh session after `/run-synthesis` completes.

Skill loading: For each skill step below, read the skill file from `/ai-resources/skills/[skill-name]/SKILL.md` and follow its instructions.

---

### Step 4.0: Load Inputs

1. Read all chapter drafts from `/analysis/chapters/{section}/`.
2. Read the scarcity register from `/execution/scarcity-register/{section}/{section}-scarcity-register.md` (if it exists).
3. Read all section directives from `/analysis/section-directives/{section}/`.
4. Read all refined cluster memos from `/analysis/cluster-memos/{section}/`.
5. Read all research extracts from `/execution/research-extracts/{section}/`.
6. Read approved editorial recommendations from `/analysis/editorial-review/{section}/{section}-memo-review-recommendations.md`.

These inputs are referenced throughout the pipeline. Sub-agents receive content, not file paths (per context isolation rules).

---

### Step 4.1: Create Report Architecture [delegate]

1. Read chapter drafts (loaded in Step 4.0).
2. Read `/ai-resources/skills/research-structure-creator/SKILL.md`.
3. Launch a general-purpose sub-agent. Pass it: the skill content and all chapter draft content. Task: execute the skill logic to produce the report architecture. Write to `/report/architecture/{section}/{section}-architecture.md`. Return: architecture summary (section count, chapter-to-section mapping, structural decisions).
4. Write checkpoint to `/report/checkpoints/{section}/{section}-step-4.1-checkpoint.md` from the sub-agent's returned summary. Include: output file path, section count, chapter-to-section mapping with chapter processing order.
5. ▸ /compact — skill content and raw chapter drafts no longer needed; checkpoint carries forward.
6. PAUSE — Present architecture to the operator for review.

---

### Step 4.1b: Architecture QC [delegate-qc]

1. Read `/ai-resources/skills/architecture-qc/SKILL.md`.
2. Read all inputs needed for the QC: the architecture (`/report/architecture/{section}/{section}-architecture.md`), scarcity register (`/execution/scarcity-register/{section}/{section}-scarcity-register.md`), all section directives from `/analysis/section-directives/{section}/`, approved editorial recommendations (`/analysis/editorial-review/{section}/{section}-memo-review-recommendations.md`), and all chapter drafts from `/analysis/chapters/{section}/`.
3. Launch a qc-gate sub-agent. Pass it: the skill content, the architecture content, scarcity register content, section directives content, editorial recommendations content, and chapter draft content. Task: evaluate the architecture against all 14 criteria and produce the QC report.
4. Write QC report to `/report/checkpoints/{section}/{section}-step-4.1b-architecture-qc.md`.
5. If Overall Verdict is FAIL with critical findings: PAUSE — present failures to the operator. Architecture must be fixed before proceeding.
6. If Overall Verdict is PASS: note result and proceed to Step 4.2.
7. ▸ /compact — QC skill content no longer needed.

---

### Step 4.2: Produce Chapter Prose (per chapter, sequentially in architecture order)

Process chapters in the order defined by the architecture from Step 4.1.

For each chapter:

**a. Draft chapter prose [delegate]**
   Read `/ai-resources/skills/evidence-to-report-writer/SKILL.md`. Launch a general-purpose sub-agent. Pass it: the skill content, architecture (`/report/architecture/{section}/{section}-architecture.md`), the chapter's research extracts (from `/execution/research-extracts/{section}/`), the chapter's cluster memo, the chapter's section directive, the scarcity register (`/execution/scarcity-register/{section}/{section}-scarcity-register.md`), approved editorial recommendations, AND the style reference from `/report/style-reference/{section}/{section}-style-reference.md` (all chapters — the style spec is operator-provided and applies from chapter 1 onward). The writer MUST implement the editorial instruction (HEDGE / SCOPE CAVEAT / PROXY FRAMING) specified in the scarcity register for any scarcity items in this chapter's scope. Task: produce chapter prose. Return: chapter draft content, scarcity items addressed, evidence coverage notes.

**b. Review chapter prose [delegate]**
   Read `/ai-resources/skills/chapter-prose-reviewer/SKILL.md`. Launch a general-purpose sub-agent. Pass it: the skill content, the chapter draft from step (a), AND the scarcity register. The reviewer must verify that scarcity editorial instructions were implemented correctly. Task: apply the reviewer checks. Return: review verdict, findings list, recommended changes.

**c. Compliance QC [delegate-qc]**
   Read `/ai-resources/skills/report-compliance-qc/SKILL.md`. Launch a qc-gate sub-agent. Pass it: the skill content, the chapter draft, review findings from step (b), the architecture (`/report/architecture/{section}/{section}-architecture.md`), the style reference from `/report/style-reference/{section}/{section}-style-reference.md`, the scarcity register (`/execution/scarcity-register/{section}/{section}-scarcity-register.md`), and the chapter's section directive from `/analysis/section-directives/{section}/`. Task: run all four compliance check categories per the skill criteria. Return: QC verdict (PASS/FAIL), per-item findings.

**d. Write chapter draft and checkpoint**
   Write the chapter draft to `/report/chapters/{section}/{section}-chapter-NN-draft.md` (the `-draft.md` suffix is the canonical S-16 working path — the draft is operator-editable; the canonical citation-converted file is produced downstream at step (i)).
   Write the review report (from step b) to `/report/chapters/{section}/{section}-chapter-NN-review.md` so the operator can reference it during inline edit.
   Write checkpoint to `/report/checkpoints/{section}/{section}-chapter-NN-checkpoint.md`. Include: draft file path, review report path, QC verdict, reviewer findings summary, scarcity items addressed.

**e. PAUSE — Operator review of chapter draft (Step 4.1b, blocking).** Emit verbatim, then HALT:

> Chapter draft and review report ready. Files:
> - Draft: `/report/chapters/{section}/{section}-chapter-NN-draft.md`
> - Review report: `/report/chapters/{section}/{section}-chapter-NN-review.md`
>
> **Operator review required before citation conversion begins.** Edit the draft directly at the path above. Use these inline HTML-comment markers:
> - `<!-- improve: [idea] -->` — describes a change for `chapter-revision-applier` to apply to the surrounding paragraph
> - `<!-- KEEP -->` — protects the surrounding paragraph from any change
>
> Reply with:
> - `approved` — proceed to chapter-revision-applier and citation conversion as-is
> - Deletion list / improvement directions — applied inline, then awaits final `approved`

The halt is unconditional — no timeout, no auto-approve. When the operator's reply contains the literal token `approved` (case-insensitive whole-word match, or as the first word of the reply), `/run-report` writes the operator-approval marker file at `/report/chapters/{section}/{section}-chapter-NN-OPERATOR-APPROVED.md` with exactly one line of content:

```
APPROVED: YYYY-MM-DD-HH-MM | <optional operator note (extracted from the reply after the approved token, or empty if the reply is just "approved")>
```

**Two-end string-literal contract.** The literal token `approved` (this command's trigger) and the marker filename suffix `-OPERATOR-APPROVED.md` are both load-bearing strings shared with `citation-converter` (which reads them at Step 0a). Changing either string requires editing both files in the same commit — they are an atomic contract.

**f. Apply chapter revisions [delegate].** After the operator-approval marker is written (Step 4.1c per S-16), invoke `chapter-revision-applier` before citation conversion:
   Read `/ai-resources/skills/chapter-revision-applier/SKILL.md`. Launch a general-purpose sub-agent. Pass it: the skill content and the chapter draft path `/report/chapters/{section}/{section}-chapter-NN-draft.md`. Task: apply inline `<!-- improve: -->` markers to their surrounding paragraphs, preserve `<!-- KEEP -->`-marked paragraphs, strip all markers + the reviewer-findings footer, write revised draft. Return: revised file path, list of markers applied, list of markers skipped (ambiguous scope or KEEP conflict), any warnings logged.
   Verify the revised file exists at `/report/chapters/{section}/{section}-chapter-NN-revised.md` before proceeding.

**g. Bright-line check on any revisions:** Before applying revision feedback, check each proposed change against the three bright-line triggers (multi-paragraph scope, analytical claim alteration, sourced statement modification). Flag any that trigger. Apply only non-flagged changes automatically; flagged changes require explicit approval. Log flagged items to `/logs/decisions.md`.

**h. Style reference verification (first chapter only):** After first chapter is approved, verify that the prose conforms to the operator-provided style reference at `/report/style-reference/{section}/{section}-style-reference.md`. The style reference is pre-locked — do not overwrite it. All chapters receive it as input in steps (a), (b), and (c).

**i. H3 title generation.**

**j. Citation conversion [delegate]**
   Read `/ai-resources/skills/citation-converter/SKILL.md`. Launch a general-purpose sub-agent. Pass it: the skill content and the **revised** chapter prose at `/report/chapters/{section}/{section}-chapter-NN-revised.md` (NOT the original draft — the revised file is what citation-converter consumes, per S-16 Step 4.2). Task: execute citation conversion. The skill's Step 0a pre-flight check verifies the operator-approval marker exists; if absent, the skill refuses to run and `/run-report` halts. Write cited version to `/report/chapters/{section}/{section}-chapter-NN-cited.md` and Citation Traceability Layer to `/report/chapters/{section}/{section}-chapter-NN-ctl.md`. Return: citation count, CTL summary.
   Write checkpoint to `/report/checkpoints/{section}/{section}-chapter-NN-cited-checkpoint.md`. Include: cited file path, CTL file path, citation count.

**k. Archive operator-approval marker.** After citation conversion completes successfully, move the marker file from `/report/chapters/{section}/{section}-chapter-NN-OPERATOR-APPROVED.md` to `/report/chapters/{section}/.archive/{section}-chapter-NN-OPERATOR-APPROVED-{YYYY-MM-DD-HH-MM}.md`. This prevents a stale marker from triggering bypass on a re-run of the same chapter. If `.archive/` does not exist, create it. If the move fails for any reason, log the failure to `/logs/decisions.md` and continue — the move is bookkeeping, not load-bearing for the conversion itself.
   ▸ /compact — chapter-specific skill and input content no longer needed; moving to next chapter.

---

### Step 4.3: Log Results

1. Log to `/logs/qc-log.md`: record each chapter's QC verdict, citation count, and scarcity items addressed.
