# Session Plan — 2026-08-02

## Intent
Make two minimal wording corrections in place to `plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md` — extend §1's capability definition and replace §4's standing statement — then review the diff and commit only those two changes.

## Model
sonnet — → /model sonnet (active session is opus; the work is verbatim-text placement plus invariant checking, not synthesis). Advisory only — not switching mid-session, and the mismatch costs correctness nothing here.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md` (909 lines) — the sole edit target and the sole allowed input.

Deliberately NOT loaded: `work-loop-v2-executable-core-v0.1.md` and `step-7-pilot-log.md`. Both were inputs to prior rounds; this round is two operator-supplied verbatim sentences with no derivation to ground, so reading them would be scope the mandate excludes.

## Findings / Items to Address

1. **§1 capability definition is silent on the durable-context responsibility.** The definition blockquote at `context-engineering-spec-v0.1.md:30-32` ends at "...without further operator context assembly or transport" — it describes the transformation only. §5.7 (`:405`) establishes the durable source model and §4 (`:251-257`) grants Codex authoring authority over it, so the capability definition under-covers what the spec elsewhere assigns. **Fix:** append the operator-supplied sentence to the definition, keeping context maintenance inside the one capability rather than promoting it to a separate product or stage.

2. **§4's standing statement is overbroad — it collapses two different kinds of standing.** The blockquote at `:283-285` closes: "**Imperative wording, file existence, filename and file location never create standing** — only operator approval, or a current operator decision, does." As written this denies *any* standing to authoritative state, verified repository reality, and settled implementation decisions — which the spec relies on elsewhere (§5.3's cited-evidence demotion at `:366`, §5.1's dispositions at `:330`). **Fix:** replace with the operator-supplied two-sentence text separating **directional governing authority** (operator-only) from **factual/evidentiary standing** (which verified reality may carry, but which cannot amend approved direction).

3. **Explicitly declined this round — six review observations the operator ruled out.** Not addressed, by instruction: materiality/sequence rules; trial metrics, watch items or registers; consolidation of the anti-governance provisions; behavioural-case changes or additions; implementation or trial plans. Recorded here so the next round can tell "declined" from "missed".

## Execution Sequence

1. **Edit §1's definition blockquote** (`:30-32`). Append the operator's sentence verbatim as a new line inside the blockquote. *Verify:* the sentence appears exactly as supplied, including "only when material project understanding changes" and the "§5.7" reference; the surrounding `*Sufficient*, not *safe*` line at `:34` is untouched.

2. **Edit §4's standing sentence** (`:283-285`). Replace the closing sentence of the blockquote with the operator's two-sentence text verbatim. *Verify:* the replacement covers exactly the old sentence — the preceding "The contradiction this replaces" narrative and the entry/standing distinction that precedes it stay intact.

3. **Invariant check.** *Verify by count, not by recall:* behaviour identifiers CE-1..CE-17 still number 17; the file's version string still reads v0.1; the stage/status line still reads draft; total heading structure unchanged (34 headings, per the Step-3 scan).

4. **Diff review.** `git diff` the one file. *Verify:* exactly two hunks, both sentence-level, no whitespace-only or reflow noise elsewhere. If a third hunk appears, stop and surface it rather than committing.

5. **Commit and report.** Stage the spec file only, commit, read back the hash. *Verify:* `git show --stat` names one file; report the hash to the operator.

## Scope Alternatives
Single scope — no alternatives. Both corrections are operator-supplied verbatim text with fixed insertion points; there is no depth to trade.

## Autonomy Posture
Full autonomy — the work is two bounded verbatim replacements with an explicit exit condition and an explicit exclusion list.

**Stop points:**
- If step 2's target sentence does not match the operator's description of it — show §4's actual wording instead of guessing which sentence was meant.
- If step 4's diff shows any hunk beyond the two corrections.

## Risk
No structural change classes apparent — the target is a draft specification document under `plans/`, with no hook, permission, CLAUDE.md, command, agent or symlink surface touched. Re-size the review if scope changes. Not an executable artifact, so the environment-fit check does not apply.
