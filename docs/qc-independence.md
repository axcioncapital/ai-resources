# Independent Review Rule

> **When to read this file:** When deciding whether a change needs an independent review and which kind; when a review returns findings; or when the reviewer you would normally use cannot be reached.

**One independent review per change, proportional to consequence. Not a chain.**

Review must run with fresh context to avoid self-evaluation bias: a reviewer that watched the work being made cannot judge it independently. That is why the reviewer is a different model or a subagent that receives only the artifact — never the conversation that produced it.

## The rule

| Change | Review |
|---|---|
| **Small or mechanical** | **None.** Deterministic verification only — run the thing, grep the result, read the file back. |
| **Normal, consequential** | **One Codex review** of the result, after deterministic evidence exists. Fix material findings, then finish. |
| **High-consequence or destructive** | **One risk-aware Codex review** (§ Risk-aware review) before implementation; operator decision where the review surfaces one; then implement behind the deterministic execution-time safeguards, which are never removed. |

**Small or mechanical** — a substitution-shaped edit to a repo-infrastructure file (settings, commands, agents, SKILL.md, CLAUDE.md, hooks, prompts, and analogous infra): string and typo fixes, value edits, permission entries, path or key renames, reference updates, small wording corrections. Also: ≤5 lines changed where intent is unambiguous *and* the correct form is already validated elsewhere in the repo. Formatting and whitespace changes are always in this row. It does **not** cover new files, new sections or capabilities, or structural reorganization — those are consequential.

**High-consequence or destructive** — the change falls in a structural change class (`audit-discipline.md` § Structural change classes: hook edits, permission changes, cross-cutting CLAUDE.md edits, new commands or skills, new symlinks, shared-state automation), or it deletes, overwrites or moves something `git revert` cannot recover.

Sizing is a judgment about *consequence*, not about effort or line count. When a change sits between two rows, take the heavier one.

## Codex is the reviewer

For `/work-loop`-routed work, Codex is the independent review (`docs/work-loop.md` § Route → depth → stops). No Claude QC pass runs in addition to it — that is the duplication this rule exists to prevent.

Outside `/work-loop`, consequential work still gets one review, and Codex is that review. Route it through `/work-loop`, or brief Codex directly. What is not permitted is stacking a second reviewer on the same artifact, or re-running a review for reassurance.

**No general review fires automatically.** `/refinement-pass`, `/triage`, `/contract-check`, `/drift-check` and `/blindspot-scan` are operator-invoked. No command, hook or policy spawns a review on its own.

**Retired 2026-07-30 — do not reinstate.** `/qc-pass`, `/risk-check`, `/resolve` and `/refinement-deep` are deleted, along with the `qc-reviewer` and `risk-check-reviewer` agents and their `.codex` twins. Codex is the second opinion; there is no Claude-side QC or risk command to fall back to, and none should be rebuilt under a new name. Where any file still instructs otherwise, **this rule wins and that file is stale.**

## Risk-aware review

For the third row, the review brief carries these seven dimensions in addition to the ordinary review: **usage cost, permissions surface, blast radius on other components, reversibility, hidden coupling, principle alignment, and problem reality** (was the defect observed, or only inferred?).

**Premise-verification precondition.** Before the review is briefed, the requester runs a bounded pre-dispatch premise check on the payload: run every script it cites, open every line it cites, and re-derive every count, recording the primitive used. Correct any false claim *before* the reviewer sees it. A review that reasons from an unverified premise produces confident, expensive, wrong output — the ~360k-token miss of 2026-07-14 (`logs/improvement-log.md`). This applies Problem Reality to the review's **input**, symmetric with the dimension applied to its **output**.

An explicit consumer inventory belongs in the payload, not in the reviewer: enumerating consumers is a grep, and `skills/ai-resource-builder/SKILL.md` § Consumer-Inventory Gate already owns it at the cheaper point.

## Context isolation

Reviewers receive only the artifact, the criteria, and the artifact's declared purpose. Never pass conversation history, creation rationale, or operator feedback.

## When the reviewer cannot be reached

Codex unreachable, or subagent dispatch impossible (most often a 1M-context session whose credits are exhausted, failing with "Usage credits required for 1M context"):

1. **Fall back to inline self-review** against the same criteria. There is no Claude-side review command to reach for — `/qc-pass` was retired on 2026-07-30 and is not the escape hatch any more.
2. **Surface the degradation** in chat: state that the intended review could not run, and why. The gate was reached and blocked, not silently skipped.
3. **Record the result as `unassessed`**, never as passed.

Inline self-review is a real check and has caught material gaps, but it is not a substitute for fresh context. **Prevention beats fallback:** when a subagent-heavy stretch is coming in a 1M-context session, switch to a standard-context model via `/model` *before* the review, not after it fails.

There is no commit-block and no deferred-session requirement. A change whose review is recorded `unassessed` is visible as such; the operator decides whether that is acceptable.

## Findings

Finding generation is bounded by the **materiality floor** (`docs/materiality-bar.md`): a reviewer lists an observation as a Finding only when it can name a concrete consequence of not fixing it. Cosmetic and preference observations stay out of Findings (Notes at most). The floor governs what counts as a finding, not whether to review.

Apply what the review found. **Fixing findings is not a new review cycle** — the fix is the work, and it does not earn another pass.

**A second review happens only when the first found a material issue that forced a redesign** — not on a pass counter, and never on a wish for more assurance. Reviewing the redesign is reviewing a different artifact; re-reviewing the same artifact for reassurance is the pattern this file removes.

**An unresolved material finding is a halt-and-surface, not a quiet stop.** When a material finding is left unresolved, say so in the turn summary — the finding, the consequence the review named for it, and the verdict stated as unresolved, never rounded up to passing. The artifact is not cleared by the review having happened. Treat it as blocked pending the operator's call, and say so explicitly.

---

*Retired 2026-07-29 (stream `2026-07-29-review-layer-consolidation`): the mandatory post-edit QC pass, the plan-QC requirement, the QC → Triage auto-loop with its two-pass cap, and the QC-PENDING commit-block and deferred-session architecture.*

*Retired 2026-07-30: the commands and agents themselves — `/qc-pass`, `/risk-check`, `/resolve`, `/refinement-deep`, `qc-reviewer`, `risk-check-reviewer`, their `.codex` twins, and every project symlink to them. This completed the cross-project migration the 2026-07-29 entry deferred. Rationale: `logs/decisions.md`. Recoverable from git history if ever needed.*
