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

**High-consequence or destructive** — the change falls in a structural change class (`audit-discipline.md` § Risk-check change classes: hook edits, permission changes, cross-cutting CLAUDE.md edits, new commands or skills, new symlinks, shared-state automation), or it deletes, overwrites or moves something `git revert` cannot recover.

Sizing is a judgment about *consequence*, not about effort or line count. When a change sits between two rows, take the heavier one.

## Codex is the reviewer

For `/work-loop`-routed work, Codex is the independent review (`docs/work-loop.md` § Route → depth → stops). No Claude QC pass runs in addition to it — that is the duplication this rule exists to prevent.

Outside `/work-loop`, consequential work still gets one review. Route it through `/work-loop`, or run `/qc-pass` once as the deliberate substitute. What is not permitted is running both, or running either twice for reassurance.

**No general review fires automatically.** `/qc-pass`, `/refinement-pass`, `/refinement-deep`, `/triage`, `/resolve` and `/risk-check` are operator-invoked. No command, hook or policy spawns them on its own.

> **In transition (2026-07-29).** The line above states the policy, which is authoritative from now. It is not yet a description of every file: callers that still spawn a review automatically are being removed slice by slice, and `/prime` and `/session-plan` are excluded from that work entirely, so they keep firing until their own follow-up lands. Where a caller and this rule disagree, **this rule wins and the caller is stale** — do not restore an automatic review because a command still asks for one.

## Risk-aware review

For the third row, the review brief carries these seven dimensions in addition to the ordinary review: **usage cost, permissions surface, blast radius on other components, reversibility, hidden coupling, principle alignment, and problem reality** (was the defect observed, or only inferred?).

**Premise-verification precondition.** Before the review is briefed, the requester runs a bounded pre-dispatch premise check on the payload: run every script it cites, open every line it cites, and re-derive every count, recording the primitive used. Correct any false claim *before* the reviewer sees it. A review that reasons from an unverified premise produces confident, expensive, wrong output — the ~360k-token miss of 2026-07-14 (`logs/improvement-log.md`). This applies Problem Reality to the review's **input**, symmetric with the dimension applied to its **output**.

An explicit consumer inventory belongs in the payload, not in the reviewer: enumerating consumers is a grep, and `skills/ai-resource-builder/SKILL.md` § Consumer-Inventory Gate already owns it at the cheaper point.

## Context isolation

Reviewers receive only the artifact, the criteria, and the artifact's declared purpose. Never pass conversation history, creation rationale, or operator feedback.

## When the reviewer cannot be reached

Codex unreachable, or subagent dispatch impossible (most often a 1M-context session whose credits are exhausted, failing with "Usage credits required for 1M context"):

1. Use the **explicitly chosen fallback** — `/qc-pass` for a Codex-unreachable review, or inline self-review against the same criteria when no subagent can spawn at all.
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

*Retired 2026-07-29 (stream `2026-07-29-review-layer-consolidation`): the mandatory post-edit QC pass, the plan-QC requirement, the QC → Triage auto-loop with its two-pass cap, and the QC-PENDING commit-block and deferred-session architecture. Rationale and consumer inventory: `logs/decisions.md`. Callers still referencing them are listed as sequenced follow-up in that entry — they are known, not missed.*
