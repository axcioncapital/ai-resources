---
model: opus
---

Take an open list of operator-decision questions that Claude just surfaced (after `/qc-pass`, `/scope`, `/clarify`, or any mid-stream Claude turn) and, before escalating to the operator, attempt evidence-grounded resolution from project files for each one. Output a three-bucket structured result so the operator can scan, approve, or override quickly.

Operator-invoked only. Do NOT auto-fire.

## Steps

1. **Acquire the decision list.** Pick the source in this order:

   a. **Explicit operator argument.** If `$ARGUMENTS` is non-empty, treat it as a reference to the target list — either a literal list pasted by the operator, or a phrase pointing at a recent block ("the questions from the QC pass two turns ago"). Skip auto-detection.

   b. **Auto-detect from recent context** (used when `$ARGUMENTS` is empty). Scan the conversation tail for one of the following, in priority order:

      - **`## QC Review` block** (produced by `/qc-pass`) with a `### Findings` subsection — typically followed by a `/resolve` invocation producing a `Real / Low-signal / Skip` table where some items are marked `Needs operator judgment: {what to decide}`. Treat each `Real` item flagged for operator judgment as one question.
      - **`5. **Decisions you are making**` section** (produced by `/scope` — verified against `scope.md:11`). Each bullet under this heading is one question.
      - **`**Clarifying questions**` numbered list** (produced by `/clarify` — verified against `clarify.md:11`). Each item is one question. Note: `/clarify` emits prose, not a block delimiter — the heading is the marker.
      - **Numbered list in the last Claude turn** that semantically reads as a list of pending operator decisions (e.g., "Q1 ... Q2 ... Q3 ..." or "1. ... 2. ... 3. ..." where each item ends in a question or asks for a choice). Use this fallback only if none of the structured markers above match.

   c. **Ambiguity guard.** If two or more candidate lists are present in recent context and the operator's invocation did not name which one, STOP and ask: *"Multiple candidate lists in context — {brief description of each}. Which one?"* Do NOT silently pick the most recent. Picking is silent narrowing.

   d. **No list found.** If neither `$ARGUMENTS` nor auto-detection yields a list, STOP and tell the operator: *"No decision list found in recent context. Paste the questions, or invoke after `/qc-pass` / `/scope` / `/clarify`."*

2. **Prior-decision check.** Before treating any item as open, verify that the question hasn't already been decided. Read (tail only, not whole file):

   - `logs/session-notes.md` — last today-dated `## YYYY-MM-DD` entry (tail-read pattern, same idiom as `/prime`).
   - `logs/session-plan.md` (and `logs/session-plan-pass2.md` / `session-plan-pass{N}.md` siblings if present — these are written by `/session-plan` Step 0 on concurrent-session collision; per `docs/repo-architecture.md` § Q6).
   - Recent conversation history within this session.

   For any item that matches a prior decision (same wording, same scope, or close paraphrase), mark it `Already decided — see {source}` and do not re-research it. The item still appears in the output, with the prior decision quoted, so the operator can see what was filtered and override if the prior decision was wrong.

3. **Per-question evidence gathering.** For each remaining open question:

   - Identify what kind of evidence would resolve it (file content, prior decision, command behavior, etc.).
   - Read project files relevant to the question. **Soft guidance:** stay within a sensible per-question budget — typically a handful of targeted reads, not exhaustive scans. If a question would require many reads or whole-file scans across multiple files, that is itself a signal: escalate it to the `Operator-only` bucket with a note explaining what couldn't be confirmed within the budget. Do NOT recurse into broader and broader searches.
   - Capture the operator's verbatim original framing of the question (from the source list — find the exact wording in context). This is load-bearing for Step 4's anti-narrowing check.

4. **Three-bucket classification with anti-narrowing.** Each question lands in exactly one bucket:

   **(a) Self-resolved.** High-confidence answer derivable from project state alone. Output:
   - The resolution.
   - One- or two-sentence reasoning.
   - File references (path + relevant excerpt) the operator can audit.

   **(b) Recommendable.** Partial evidence supports a recommendation, but operator should confirm. Output:
   - The recommendation.
   - Supporting evidence (file paths + excerpts).
   - The specific gap that prevents full confidence — i.e., what would have to be true for this to move to Self-resolved.
   - **The operator's verbatim original framing of the question.** This is a HARD requirement — emit either the operator's exact phrasing OR an explicit `[narrowing-check] {what was reworded}` note where the recommendation may have constrained or reframed the original question. No skip path. If both are unavailable, the item belongs in `Operator-only`, not here.

   **(c) Operator-only.** Genuinely requires operator taste, strategic direction, or knowledge not in any file. Output:
   - The question (verbatim from the source).
   - Relevant project context (one or two short lines).
   - A brief note on why this cannot be evidence-grounded — e.g., "preference call," "strategic choice with no prior precedent in repo," "would require operator-only knowledge."

5. **Output format.** Present buckets in this order: Self-resolved → Recommendable → Operator-only → Already decided. Within each bucket, preserve the original question order from the source list.

   For each item, use this shape:

   ```
   ### [N]. {question — first ~80 chars}
   **Bucket:** {Self-resolved | Recommendable | Operator-only | Already decided}

   {bucket-specific body — see Step 4}
   ```

   After all items, append a one-line summary:

   ```
   **Totals:** {n} self-resolved / {n} recommendable / {n} operator-only / {n} already decided.
   ```

## Composition

- **After `/qc-pass`** → run `/resolve` to triage findings → `/decide` picks up `Real` items marked `Needs operator judgment`.
- **After `/scope`** → `/decide` grounds the "5. Decisions you are making" items in evidence.
- **After `/clarify`** → `/decide` pre-researches each clarifying question.
- **Mid-stream Claude turn that surfaced a decision list** → `/decide` operates on that list directly.

`/decide` is the inverse-posture alternative to `/recommend`: `/recommend` says "use your own judgment on all questions and proceed"; `/decide` says "for each question, show evidence and let the operator pick."

## Exclusions

- Does NOT auto-fire. Operator-invoked only.
- Does NOT auto-apply decisions silently — every resolved item must show reasoning and file references the operator can audit. Self-resolved items appear in the output for operator scan, not skipped.
- Does NOT replace `/recommend`, `/resolve`, or `/clarify`. These compose; they do not substitute.
- Does NOT re-escalate items already decided earlier in the session — Step 2's prior-decision check filters those into the `Already decided` bucket.
- Does NOT sweep the whole session for open decisions unprompted. The command operates only on the named or detected target list.
- Does NOT recurse into broader file scans when the per-question soft budget is exceeded — escalate to `Operator-only` instead.

## Failure behavior

- **No list found and no `$ARGUMENTS`:** stop and prompt operator (Step 1d).
- **Multiple candidate lists, no operator disambiguation:** stop and ask which one (Step 1c). Never silently pick.
- **Operator's verbatim framing cannot be located in context** (e.g., context was compacted): demote the item from `Recommendable` to `Operator-only`. Recommendable requires either verbatim framing or an explicit `[narrowing-check]` note — never silently rephrase.
- **Project files referenced in a question don't resolve:** mark the gap in the bucket's `evidence` field; do not invent path content.
- **Per-question budget exceeded:** move item to `Operator-only` with a note on what couldn't be confirmed within budget.
- **Source command body has changed and a marker string no longer matches:** Step 1b's auto-detection will return no matches. Surface the absence and ask the operator to paste the list rather than guessing.

If the provided information is insufficient to answer a question confidently, say so — Operator-only is the right bucket, not a low-confidence guess. It is acceptable, and expected, to leave gaps rather than invent plausible-sounding evidence. If the question's premise contains an error or questionable assumption, flag it constructively in the bucket body. Accuracy over comprehensiveness.
