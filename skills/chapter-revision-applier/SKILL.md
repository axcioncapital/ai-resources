---
name: chapter-revision-applier
description: >
  Apply operator inline-edit markers to a chapter draft and produce the revised
  file consumed by citation-converter. Reads a chapter draft at
  `report/chapters/{section}/{section}-chapter-NN-draft.md` carrying inline
  `<!-- improve: [idea] -->` and `<!-- KEEP -->` HTML-comment markers from the
  operator's review pass, applies each improve idea to its surrounding
  paragraph, leaves KEEP-marked paragraphs untouched, strips all markers + the
  reviewer-findings footer, and writes the result to
  `{section}-chapter-NN-revised.md`. Sub-agent invocation, one per chapter,
  between Step 4.1b (operator-approval marker written) and Step 4.2 (citation
  conversion begins). Trigger when `/run-report` invokes the skill after the
  operator-approval marker is written, or on requests like "apply chapter
  revisions for {section}-NN." Do NOT use for chapter drafting
  (evidence-to-report-writer), independent prose review (chapter-prose-reviewer),
  citation conversion (citation-converter), or any content generation — this
  skill is one-pass apply, not generate.
model: sonnet
effort: medium
---

# Chapter Revision Applier

## Purpose

The operator's chapter-review pass between Step 4.1a (chapter-prose-reviewer) and Step 4.2 (citation-converter) is the project's single human-in-the-loop gate before citation work commits. To make that pass actionable, operators edit the draft directly using inline HTML-comment markers. This skill is the mechanical apply step that converts the operator's annotated draft into the file `citation-converter` consumes. One-pass apply, no content generation.

The skill is project-agnostic — the marker conventions and the draft/revised file paths are inherited from canonical stage-instructions and the project's `reference/file-conventions.md`.

## When to Use

- Invoked by `/run-report` immediately after the operator-approval marker is written (Step 4.1b complete), before `citation-converter` is invoked (Step 4.2).
- Positional argument: chapter draft file path (e.g., `report/chapters/1.1/1.1-chapter-04-draft.md`).
- Re-entry: idempotent. If a `{section}-chapter-NN-revised.md` file already exists AND is newer than the corresponding draft, the skill is a no-op (revisions already applied on a prior run). To force re-run, the operator deletes the revised file first.

## When Not to Use

- Do NOT use to draft chapter content (`evidence-to-report-writer`'s job at Step 4.1).
- Do NOT use to review chapter quality (`chapter-prose-reviewer`'s job at Step 4.1a).
- Do NOT use to convert claim IDs to citations (`citation-converter`'s job at Step 4.2).
- Do NOT use to generate new prose — the skill only APPLIES operator-supplied ideas; it does not produce content beyond what the markers direct.
- Do NOT skip the operator-approval marker check — the skill assumes Step 4.1b has completed (the marker file exists), but does NOT itself enforce that. `/run-report` is responsible for the marker check + ordering.

## Inputs

| Input | Path | Required |
|---|---|---|
| Chapter draft with inline markers | `report/chapters/{section}/{section}-chapter-NN-draft.md` | yes |

That's the only input. The skill does NOT read the chapter-prose-reviewer's review report — operator's inline markers carry whatever the operator chose to act on from that review.

## Output

Single file: `report/chapters/{section}/{section}-chapter-NN-revised.md`.

The original draft (`-draft.md`) is preserved untouched for audit. The revised file is what `citation-converter` consumes downstream.

## Marker Conventions

Two HTML-comment markers, both operator-side conventions surfaced at the Step 4.1b operator gate:

### `<!-- improve: [idea] -->`

The operator inserts this marker inside (or immediately before) the paragraph they want changed. The skill applies the `[idea]` to the surrounding paragraph and strips the marker.

**Scope rule.** Scope is the same paragraph the marker sits in, never broader. If the marker is on its own line (no surrounding paragraph), the scope is the immediately-following paragraph. The skill does NOT cascade an improve idea across multiple paragraphs unless the operator placed separate markers.

**Example input:**
```markdown
Nordic add-on activity rose meaningfully in 2025, with platforms in Sweden and Finland accounting for most of the increase. <!-- improve: cite Adelis add-on Q3 — the specific deal matters more than the aggregate trend here -->
```

**Example output (after apply):**
```markdown
Nordic add-on activity rose meaningfully in 2025, with platforms in Sweden and Finland accounting for most of the increase — exemplified by Adelis's Q3 add-on of Nordic Components AB [1.1-cluster-04-claim-12], which substantiates the platform-driven pattern more directly than aggregate Argentum tallies do.
```

(Citation IDs in the apply output are preserved verbatim from the draft / inserted by the operator's improve idea where the operator names them. The skill does NOT mint new citation IDs.)

### `<!-- KEEP -->`

The operator inserts this marker inside (or immediately before) a paragraph they want preserved exactly as written. The skill leaves the paragraph untouched and strips the marker.

**Scope rule.** Same scope rule as improve: the paragraph the marker sits in (or the next paragraph if the marker is on its own line).

**Conflict resolution.** If a paragraph carries BOTH `<!-- KEEP -->` and `<!-- improve: ... -->`, `KEEP` wins — the paragraph is preserved exactly, the improve marker is left in place (not stripped) so the operator sees the unresolved instruction on the next pass, and a one-line warning is appended to `logs/decisions.md` naming the paragraph and the unapplied marker. This is loud-failure behavior: the operator must explicitly resolve the conflict.

## Process

1. Read the draft file at the input path in full.
2. Identify all `<!-- KEEP -->` markers; for each, mark the paragraph in scope as protected.
3. Identify all `<!-- improve: [idea] -->` markers. For each:
   - If the surrounding paragraph is also marked `<!-- KEEP -->`: skip apply, leave the improve marker in place, append a one-line warning to `logs/decisions.md`.
   - Otherwise: apply the idea to the surrounding paragraph (or the next paragraph if the marker is on its own line). Scope is one paragraph max.
4. Strip all `<!-- KEEP -->` markers from the output (the paragraphs they protected are kept verbatim — only the markers are removed).
5. Strip all `<!-- improve: [idea] -->` markers from paragraphs that were successfully applied. Markers on KEEP-protected paragraphs (per step 3) are NOT stripped.
6. Strip the `§ Reviewer Findings Summary` footer block (added by `evidence-to-report-writer` for the operator's review benefit; it does not belong in the citation-converted artifact). The footer is identified by the literal `## § Reviewer Findings Summary` heading; strip from that heading through end-of-file.
7. Write the revised draft to `report/chapters/{section}/{section}-chapter-NN-revised.md`.
8. Verify: the draft file at the input path is unchanged (idempotency requires original preserved).

## Failure Behavior

- **Input draft file absent:** halt; emit a one-line message naming the missing path. Do not proceed.
- **Operator-approval marker absent at invocation:** This is `/run-report`'s pre-flight check, not this skill's. If somehow the skill is invoked without the marker, emit a one-line warning and proceed (the skill itself is not the gate — `citation-converter`'s Step 0 will catch a missing marker downstream).
- **Ambiguous `<!-- improve: ... -->` scope** (e.g., the idea references content not adjacent to the marker — "fix the table in the next section"): skip that marker, emit a warning to `logs/decisions.md` naming the marker text and the ambiguity, continue with other markers. The unapplied marker stays in the revised file (visible to operator on next pass).
- **Conflicting `<!-- KEEP -->` and `<!-- improve: ... -->` on the same paragraph:** `<!-- KEEP -->` wins; the improve marker is left in place; warning logged (see Marker Conventions above).
- **No markers in the draft:** the skill is still invoked (idempotent); it strips the footer block and writes the revised file verbatim of the draft body. Operator approval without inline edits is a valid path.
- **Revised file already exists and is newer than the draft:** no-op. Skill exits successfully without rewriting. To force re-run, operator deletes the revised file.

If any failure is irrecoverable (input absent), the skill does NOT write a revised file. Partial application is never produced.

## Self-Check

Before writing the output file, verify:

- Every `<!-- KEEP -->` marker has been stripped from the output (no markers remain except those left in place by the conflict resolution rule above).
- Every `<!-- improve: ... -->` marker has either been applied (idea integrated into surrounding paragraph) or recorded in `logs/decisions.md` with reason (ambiguous scope or KEEP conflict).
- The `§ Reviewer Findings Summary` footer is absent from the output (or the original draft had no such footer).
- The original draft at the input path is byte-identical to its pre-invocation state.
- The revised file is at `report/chapters/{section}/{section}-chapter-NN-revised.md` exactly — same `{section}` and same `NN` as the input draft.

If any check fails: do not write the file. Emit a one-line message naming the failing check, then halt for operator review.

## Runtime Recommendations

- **Model:** `sonnet`. Pattern-based mechanical work with light judgment (scope resolution when the marker is on its own line; paragraph-boundary detection in mixed markdown). Not synthesis; Sonnet is sufficient.
- **Effort:** `medium`. Per-marker work is small but the count can vary widely (a heavily-edited draft may have 20+ markers); `medium` covers both light and dense annotation patterns.
- **Throughput posture:** direct apply — no plan-first ceremony. Chapter revision is a mechanical apply, not a design decision.
- **Escalation:** rare. If a draft contains complex markdown (nested tables, custom HTML, fenced code) where paragraph-boundary detection becomes ambiguous, the scope-resolution becomes Opus-grade. Operator escalates via `/model opus` if observed.

## Inert-Fields Ledger Note

The marker conventions land in this skill in Bundle 2a but are inert until operators are told the convention exists. Two surfaces close the operator-discoverability gap:
- The Step 4.1b operator-gate prompt (in canonical `stage-instructions.md`) names the markers explicitly when prompting for `approved` / inline edits.
- The chapter-draft file itself carries the `§ Reviewer Findings Summary` footer (from `evidence-to-report-writer`), which is the operator's first reading-surface and an organic place to learn the convention.

Once Bundle 2b lands (or operators have used the convention through at least one chapter pass per project), this ledger note can be removed.

## Related Skills and References

- `evidence-to-report-writer` — produces the chapter draft this skill consumes; also produces the `§ Reviewer Findings Summary` footer this skill strips.
- `chapter-prose-reviewer` — produces the review report whose findings the footer summarizes; this skill does NOT read the review report directly.
- `citation-converter` — downstream consumer; reads the revised file this skill produces.
- `/run-report` — the orchestrator that invokes this skill after the operator-approval marker is written.
- `reference/file-conventions.md` (project) — chapter file lifecycle (`-draft.md` → `-OPERATOR-APPROVED.md` marker → `-revised.md` → canonical `{section}-chapter-NN.md`).
- Canonical `reference/stage-instructions.md` — Step 4.1b (operator-approval gate) and Step 4.1c (this skill's invocation step).
