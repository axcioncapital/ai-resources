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
   - **Decision needed from operator.** One short line explaining plainly what the operator is being asked to decide, followed by the explicit options (typically: accept the recommendation as-is, or take the named alternative shape). Phrase it as a choice the operator can pick from, not a prompt to think harder. "Confirm project → canonical, OR pick selective merge (keep project format, port canonical's structural fixes)" — not "what direction do you want?" with no options given.

   **(c) Operator-only.** Genuinely requires operator taste, strategic direction, or knowledge not in any file. Output:
   - The question (verbatim from the source).
   - Relevant project context (one or two short lines).
   - A brief note on why this cannot be evidence-grounded — e.g., "preference call," "strategic choice with no prior precedent in repo," "would require operator-only knowledge."
   - **Decision needed from operator.** One short line explaining plainly what the operator is being asked to decide, followed by the explicit options. If the question has no natural option set (open-ended preference), say so and give 2–3 illustrative shapes the operator can pick from or override. Never present a bare question with no options.

5. **Compose draft output.** Build the bucketed output described below. This is an internal draft — do not emit it to chat yet. Step 6 either QCs it (when the scope gate fires) or passes it through directly. Present buckets in this order: Self-resolved → Recommendable → Operator-only → Already decided. Within each bucket, preserve the original question order from the source list.

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

   If any items landed in Recommendable or Operator-only, follow the Totals line with a short **Open items for operator** recap — one line per item, restating only the decision needed + options (not the evidence). This is the operator's pick-list. Format:

   ```
   **Open items for operator:**
   - [N]: {one-line decision + options}. Recommendation: {pick}.
   - [M]: {one-line decision + options}. {No default — operator-only.}
   ```

   If all items are Self-resolved or Already decided, omit the Open items block entirely.

6. **Self-QC and final emit.** Before showing Step 5's draft to the operator, run a `/decide`-tailored QC pass via a fresh-context subagent. Only the post-QC version is emitted to chat.

   **Scope gate.** Skip QC entirely when the draft contains zero `Self-resolved` and zero `Recommendable` items (output is entirely `Operator-only` and/or `Already decided`). In that case, emit Step 5's draft directly — `/decide` made no evidence-grounded claims worth auditing. Otherwise proceed.

   **Subagent invocation.** Spawn a `general-purpose` subagent (`Agent` tool) with no prior context. The prompt is self-contained: pass the full Step 5 draft, the operator's original source list (verbatim framing for each question), and the four tailored checks below. The subagent reads cited files directly to verify claims — it does not rely on the main agent's prior reads.

   **Tailored checks (the subagent's mandate):**
   - **(a) Anti-narrowing.** Every `Recommendable` item carries the operator's verbatim original framing OR an explicit `[narrowing-check] {what was reworded}` note. No silent rephrasing.
   - **(b) Bucket-assignment correctness.** `Self-resolved` items are genuinely derivable from the cited files (no budget-overflow items mislabeled as resolved). Nothing in `Recommendable` is a preference call masquerading as evidence-grounded. Nothing in `Operator-only` was actually evidence-resolvable within budget.
   - **(c) Evidence accuracy.** Quoted excerpts and paths exist at the cited locations. The subagent spot-reads the cited file for each item to confirm — no hallucinated content.
   - **(d) Decision-needed completeness.** Every `Recommendable` and `Operator-only` item has an explicit `Decision needed from operator` line with options — not a bare "what direction?" prompt.

   The subagent returns a structured list of corrections — per item, which check failed and the fix needed. If all checks pass, returns "no corrections required." Subagent summary cap: 30 lines per the Subagent Contracts rule in `ai-resources/CLAUDE.md`.

   **Apply corrections in place.** Main agent re-renders affected items with the corrections applied, then emits the corrected output as if it were the primary output. Do NOT quote the subagent's correction list verbatim. Do NOT emit Step 5's draft alongside the corrected version. Do NOT append a "QC adjustments" footer. The operator sees only the final post-QC output.

   **Correction-failure path.** If a correction cannot be applied within the original per-question budget (e.g., evidence accuracy check shows a cited path doesn't exist and re-grounding would require broader scans), demote the affected item to `Operator-only` with a one-line gap note explaining what couldn't be verified. Do not silently re-fabricate evidence.

## Verbosity discipline

`/decide` output is for operator scan, not for reproducing the agent's reasoning trail. Apply these caps:

- **No step narration in the chat output.** Do not write "Step 1 — acquiring the decision list...", "Step 2 — prior-decision check...", "Step 3 — gathering evidence via per-file diffs." Do the work silently; report only the results (the bucketed items + Totals + Open items). The CLI already shows tool calls — narrating them in prose duplicates the rendering.
- **Don't restate tool output verbatim in chat prose.** The CLI renders bash/diff/read calls inline; the operator can see them. Chat prose summarizes what the output proved in one line ("project copy is ~16 days newer; header levels incompatible") — it does not re-quote the diff.
- **Bucket body ≤6 short lines or bullets per item** as a target. Reasoning is one or two sentences, not a paragraph. Evidence is the minimum a curious operator would need to audit — typically a file path + one short excerpt, not an exhaustive proof.
- **Cross-reference, don't restate.** When two items share evidence (e.g., paired files, same diff), the second item says "Evidence: paired with Decision [N] — same mtime relationship, same coupling" rather than repeating the bullets.
- **Decision-needed line is one line.** Don't expand it into a sub-section. The Open items recap at the end is the secondary surface — that one is even tighter (one line per item, no evidence).

## Clarity discipline

`/decide` output overrides the workspace CLAUDE.md "structured skill outputs are exempted from CEFR B2" carve-out. The operator-facing surfaces — bucket bodies, decision-needed lines, and the Open items recap — must read like `/explain`: short sentences, common words, no idioms, and **gloss every piece of technical jargon on first use in the response** with one short clause.

Examples of first-use glosses:
- "mtime (the file's last-modified time)"
- "skip-guard (a check that makes the hook do nothing when the input doesn't match)"
- "frontmatter (the YAML block at the top of a markdown file)"
- "stdin (text piped into the script's input)"
- "backport (copy a fix from the newer version into the older one)"
- "selective merge (keep one side's overall shape, copy specific pieces from the other side)"

Structured tags stay verbatim — `[narrowing-check]`, `[AMBIGUOUS]`, `[SCOPE]`, etc.

File paths, command names, and field names stay as-is. The gloss rule applies to the *concept* words around them, not the identifier itself.

This applies only to chat-surface prose. Embedded file excerpts quoted as evidence (a code line, a diff fragment) are not rewritten.

## Composition

- **After `/qc-pass`** → run `/resolve` to triage findings → `/decide` picks up `Real` items marked `Needs operator judgment`.
- **After `/scope`** → `/decide` grounds the "5. Decisions you are making" items in evidence.
- **After `/clarify`** → `/decide` pre-researches each clarifying question.
- **Mid-stream Claude turn that surfaced a decision list** → `/decide` operates on that list directly.

`/decide` is the inverse-posture alternative to `/recommend`: `/recommend` says "use your own judgment on all questions and proceed"; `/decide` says "for each question, show evidence and let the operator pick."

**Built-in QC.** `/decide` runs a tailored self-QC pass (Step 6) before emitting output, fired by an independent fresh-context subagent. Operators do not need to manually chain `/decide` → `/qc-pass` — the QC is mandatory when at least one item is `Self-resolved` or `Recommendable`.

## Exclusions

- Does NOT auto-fire. Operator-invoked only.
- Does NOT auto-apply decisions silently — every resolved item must show reasoning and file references the operator can audit. Self-resolved items appear in the output for operator scan, not skipped.
- Does NOT replace `/recommend`, `/resolve`, or `/clarify`. These compose; they do not substitute.
- Does NOT re-escalate items already decided earlier in the session — Step 2's prior-decision check filters those into the `Already decided` bucket.
- Does NOT sweep the whole session for open decisions unprompted. The command operates only on the named or detected target list.
- Does NOT recurse into broader file scans when the per-question soft budget is exceeded — escalate to `Operator-only` instead.
- Does NOT emit Step 5's pre-QC draft to chat — Step 6's QC pass is mandatory when at least one item is `Self-resolved` or `Recommendable`. The scope gate only skips QC; it never skips emission.

## Failure behavior

- **No list found and no `$ARGUMENTS`:** stop and prompt operator (Step 1d).
- **Multiple candidate lists, no operator disambiguation:** stop and ask which one (Step 1c). Never silently pick.
- **Operator's verbatim framing cannot be located in context** (e.g., context was compacted): demote the item from `Recommendable` to `Operator-only`. Recommendable requires either verbatim framing or an explicit `[narrowing-check]` note — never silently rephrase.
- **Project files referenced in a question don't resolve:** mark the gap in the bucket's `evidence` field; do not invent path content.
- **Per-question budget exceeded:** move item to `Operator-only` with a note on what couldn't be confirmed within budget.
- **Source command body has changed and a marker string no longer matches:** Step 1b's auto-detection will return no matches. Surface the absence and ask the operator to paste the list rather than guessing.
- **QC subagent flags an item that cannot be fixed within budget:** demote to `Operator-only` per Step 6's correction-failure path. Do not silently re-fabricate evidence or expand the per-question budget to chase the fix.

If the provided information is insufficient to answer a question confidently, say so — Operator-only is the right bucket, not a low-confidence guess. It is acceptable, and expected, to leave gaps rather than invent plausible-sounding evidence. If the question's premise contains an error or questionable assumption, flag it constructively in the bucket body. Accuracy over comprehensiveness.
