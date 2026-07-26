# Domain Review Principles

Structured review principles organized by resource type. QC subagents load this file alongside the evaluation framework to catch domain-specific issues the generic eight-layer framework misses.

## How This File Works

Each principle states **what to check** and **why it matters**. Evaluators apply these as additional checks after completing the standard evaluation framework.

**Growth mechanism:** The improvement-analyst's recurrence escalation protocol drafts new principles when evaluation gaps recur 3+ times. Draft principles are added to the Candidates section below. The operator approves, edits, or removes them.

---

## All Reviews

- **Name the bright-line before reviewing it.** When reviewing a draft or artifact, first state the explicit pass/fail criterion in one sentence ("A passing version of this artifact does X / does NOT do Y"). Review against the stated bright-line. Without a named bright-line, reviews drift into subjective preference. (Coaching One Thing 2026-05-16, 2026-05-20, 2026-05-22 — carried 3 cycles before codification 2026-05-28.)

## Skills

- **Trigger front-loading:** Description must include trigger conditions in the first 250 characters — truncation in tool listings makes later triggers invisible to the model selecting skills.
- **Promise-procedure alignment:** Every claim about what the skill does must correspond to an actual instruction in the body — promises without procedures create silent failures where the model improvises instead of following a defined process.
- **Exclusion reciprocity:** If a skill excludes a domain ("do NOT use for X"), check that at least one other skill covers X — orphaned exclusions create gaps where no skill handles a valid use case.

## Workflows

- **Hand-off contracts:** Each stage's output contract must specify exactly what the next stage needs as input — underspecified hand-offs cause downstream rework or force the next stage to guess.
- **Gate specificity:** Gate criteria must be binary (pass/fail) or threshold-based — subjective gates ("is it good enough?") produce inconsistent gating decisions across sessions.

## Pipeline Output

- **Actionable recommendations:** Recommendations must include who, what, and by when — abstract advice ("consider improving X") gets logged but never acted on.
- **Evidence grounding:** Every factual claim in pipeline output must either cite a source or be explicitly labeled as assumption — unlabeled assumptions propagate as facts through downstream stages.

## Project Instructions

- **Rule testability:** Every rule in CLAUDE.md must be testable — if you can't determine whether Claude followed it by reading the output, the rule is too vague to enforce.

---

## Candidates

Draft principles from recurrence escalation appear here for operator review. Move approved principles to the appropriate section above; delete rejected ones.

(none yet)
