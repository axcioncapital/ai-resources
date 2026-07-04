# /reconcile Report Template

> **When to read this file:** Loaded by `reconcile-reviewer` when writing the full reconciliation report to disk, and by `/reconcile` when presenting the operator-facing summary. Not needed for every turn.

`/reconcile` produces a diagnostic report, not a rewrite. It answers one question first — *what failed: the output, the workflow, the mandate, the resources, or the instruction architecture* (`reconcile-failure-taxonomy.md`) — before recommending any repair. Do not open with a rewrite; the sequence below exists to stop that reflex.

## Structure

```markdown
# Reconciliation Report — {DATE} — {target output, one line}

## 1. Verdict

{One of: Pass | Conditional Pass | Fail | Misfire | Workflow Fault | Mandate Fault | Rerun Required — see reconcile-verdict-definitions.md}

**One-line reason:** {why this verdict, not a neighboring one — e.g. "Fail, not Misfire: the output answers the right question but underperforms the prioritization-discipline bar."}

## 2. Expected Outcome vs Actual Outcome

{What the mandate rubric + the task implied the workflow should produce. What it actually produced. Two or three sentences each — this is the gap the rest of the report explains.}

## 3. Mandate Compliance

{One row per dimension in mandate-rubric.md § Rubric dimensions. Score: Weak / Partial / Moderate / Strong. Every score cites the specific output passage or absence that earned it — "the output is structured" is not a citation.}

| Dimension | Assessment | Evidence |
|---|---|---|
| {dimension name} | {Weak/Partial/Moderate/Strong} | {quote, section reference, or "absent — no passage addresses this"} |

## 4. Resource Activation Audit

{From resource-activation-map.md: which resources this task type should have consulted, and whether there's evidence they shaped the output. "Evidence" means a traceable influence — a citation, a term, a framing that could only come from that source — not mere plausibility.}

| Resource | Should have been used? | Evidence of use | Verdict |
|---|---|---|---|
| {path} | {yes/no, per resource-activation-map.md} | {found / not found — cite or state absence} | {used / skipped / not applicable to this task} |

## 5. Genericness Check

{Apply reconcile-genericness-heuristics.md's substitution test to the 3-5 highest-weight claims. Score: Weak / Moderate / Strong (not generic). Name the specific claim tested and the result.}

## 6. Root Cause

{Name the failure level(s) from reconcile-failure-taxonomy.md — Output / Workflow / Resource / Mandate / Instruction-architecture — and the root cause from that doc's table. If more than one level is implicated, name the earliest as primary and the rest as downstream consequences.}

## 7. Recommended Fixes

{Every fix names its level AND its closure channel per reconcile-failure-taxonomy.md § Fix levels. A fix with no named channel is incomplete — do not list one.}

**Output-level fix** → routes to `/resolve`
{Specific, actionable change to the current artifact. Omit this subsection if no output-level fix applies.}

**Workflow-level fix** → routes to `/resolve-repo-problem` (repo-level pattern) or a direct project CLAUDE.md/skill edit (local to this project)
{Specific step to add/remove/reorder. Name which. Omit if no workflow-level fix applies.}

**Repo-level fix** → routes to `logs/improvement-log.md` (cross-session pattern) or a direct rubric/resource-map edit (single obvious gap)
{Specific edit to mandate-rubric.md, resource-activation-map.md, or upstream instructions. Omit if no repo-level fix applies.}

## 8. Disposition

{One line: Accept as-is / Revise in place / Rerun under a corrected workflow / Escalate — mandate needs operator input before this can be judged again.}
```

## Writing rules

- **Evidence over taste.** Every Weak/Partial score and every fix recommendation cites a passage, an absence, or a specific resource — never a bare adjective ("feels generic," "seems thin").
- **No rewrite drafts.** The report diagnoses and recommends; it does not include rewritten passages. That's the operator's or a follow-up session's job, via the channel named in § 7.
- **Silence is a finding.** "No passage addresses this dimension" is a valid, citable Weak score — don't strain to find a passage that doesn't exist.
- **One primary root cause.** Section 6 must commit to a primary failure level, even when several are implicated — a report that names five equally-weighted causes hasn't actually diagnosed anything.

## Ratification banner and gate signals

`/reconcile-activate` scaffolds `context/mandate-rubric.md` and `context/resource-activation-map.md` as *starter drafts*, not finished standards. Two plain-ASCII signals mark a scaffolded file as **un-ratified**; both are defined here as the single source, so the command that writes them and the `/reconcile` Step-2 gate that reads them cannot drift apart.

- **DRAFT banner** — line 1 of each scaffolded file, exactly:
  > **⚠ DRAFT — NOT RATIFIED.** Scaffolded by `/reconcile-activate` on {DATE}. `/reconcile` will not run against this project until every author placeholder below is replaced with this project's real standard and this banner line is deleted. Auto-drafted structure is scaffolding, not the project's judged quality bar.
- **Author placeholders** — every value the scaffolder could not derive is written as a `{{AUTHOR: … }}` token naming what the operator must supply.

**Gate rule (read by `/reconcile` Step 2).** A file is un-ratified if **either**:
- a `{{AUTHOR:` token appears anywhere in it (`grep -F '{{AUTHOR:' FILE`), or
- the plain-ASCII string `NOT RATIFIED` appears in its first 6 lines (`head -n 6 FILE | grep -F 'NOT RATIFIED'`).

The `{{AUTHOR:` check is load-bearing: a file cannot be ratified by deleting the banner alone — the placeholders must actually be replaced (this closes the "ratify-without-reading" path where a generated rubric would masquerade as operator-authored). Match the plain-ASCII substrings `{{AUTHOR:` and `NOT RATIFIED` only; never grep the `⚠` or `—` glyphs (encoding-fragile) or a bare `DRAFT` / `> **` (would false-positive on the `> **What this file is:**` blockquote that every hand-authored contract file opens with).

**To ratify:** replace every `{{AUTHOR: … }}` placeholder with the project's real content, then delete the banner line (and drop the `(DRAFT)` suffix from each file's H1 title). Files hand-authored without `/reconcile-activate` (e.g. the `buy-side-service-plan` pair) carry neither signal and run normally.
