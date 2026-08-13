# QC process for the Work Loop v2 MVP build

**Version:** v0.1. **Source:** operator instruction, 2026-08-01, adopting a recommendation from Fable.

**What this is.** How a QC pass runs during this build. It binds *method*, never scope.

**Authority.** Subordinate to the Proposal and the Playbook, at the same level as the skill-writing
standard: it governs how the artifacts are checked, exactly as that standard governs how they are
written. Where it and the Proposal disagree, the Proposal wins.

**Scope.** The Work Loop v2 MVP build only. It does **not** change the workspace-wide Independent
Review Rule, under which Codex is the reviewer and no Claude QC pass runs in addition
(`docs/qc-independence.md`, workspace `CLAUDE.md` § Independent Review Rule). It is authorised
inside this build because the Proposal itself provides for targeted per-slice review
(`work-loop-v2-mvp-proposal-v0.4.md:87`) and for one candidate review (Decision 2, `:36`).

---

## The four standing rules

**1. Do not invent a new QC layer.** Three checkpoints already exist and no fourth is added: the
targeted review at the end of each slice (Step 5), the one serious candidate review (Step 6), and
the pilot (Step 7). QC discipline comes from *how* a pass runs, not from how many passes exist. That
is the v1 lesson, restated: v1 died of added machinery, not of missing machinery.

**2. The author does not grade its own work.** Every QC pass runs in a **subagent or a fresh
session**, never in the session that wrote the artifact.

**3. The reviewer checks the artifact against the original files received at the start of the
project — not against the latest version of the plan, and not against the conversation.** This is
the drift check. Cumulative drift across rounds is invisible to any single scoped review, so the
reference point must be the frozen originals. Name the original files by path in the brief.

**4. The reviewer finds; the builder fixes.** A QC session never fixes what it finds. If it does,
the review target moves under the reviewer and the result means nothing.

---

## The three dimensions

Every QC pass checks the same three, in this order.

**1. Behaviour conformance — does the artifact *do* what it must?**
Run the failing cases from the skill-writing standard's Section 8 table that apply: a state file
with a false premise, a foreign task identity, a two-file reversible fix request. The artifact
passes by **behaving**, not by containing the right words. This is the strongest check, and it is
the one that gets skipped, because reading feels like reviewing.

**2. Standards conformance — is it written to the standard?**
Walk `skill-writing-standard-work-loop-v0.2.md` Section 10 line by line: every sentence traces to an
observable behaviour; no core rule restated (linked instead); the trigger says when NOT to activate;
all stop conditions present, each with its on-stop behaviour; pinned vocabulary only; plain language.

**3. Authority conformance — has it drifted?**
Against the original files (rule 3): nothing contradicts the Proposal's settled decisions; nothing
builds beyond MVP scope — in particular no Consequential-lane machinery, worktrees, reviewer
machinery or automation leaking in from the complete-system explainer; nothing quietly changed a
rule while restating it.

---

## The per-slice pass (Step 5) — lightweight

Dispatch a subagent. Brief it with this, filling the brackets:

```
QC pass on [artifact path], per plans/work-loop-v2-mvp/qc-process-v0.1.md.

Load: the artifact; skill-writing-standard-work-loop-v0.2.md; the
executable core; the acceptance behaviours for this slice; and these
original project files, which are your reference point for drift:
  - plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md
  - plans/work-loop-v2-mvp/pocock-lifecycle-work-loop-mvp-v0.4.md
Use the ai-resource-evaluator skill for the mechanical checks.

Check three dimensions:
1. BEHAVIOUR: construct and run each failing case from the standard's
   Section 8 table that applies to this slice. Report pass/fail per
   case with what you actually observed.
2. STANDARDS: walk the Section 10 checklist line by line.
3. AUTHORITY: list any statement that contradicts the Proposal's
   settled decisions, exceeds MVP scope, or restates a core rule
   instead of linking to it.

Classify every finding as: blocking / bounded correction /
non-blocking (deferred). Do not fix anything. Report and stop.
```

Then: correction scope **freezes** at the blocking and bounded findings. One correction pass fixes
exactly those. The closure check verifies only those, plus any regression the correction caused.
Non-blocking findings become deferrals — never a second round.

**Weight test.** The whole pass should take one short session. If slice QC regularly takes longer
than the slice took to build, the QC has grown too heavy and gets cut back.

---

## The candidate review (Step 6)

The same three dimensions, upgraded:

- Genuinely fresh context.
- The candidate frozen by **exact Git commit** (Proposal Decision 9). Any later change makes the
  review stale and creates a new candidate.
- **All** failing cases run against the complete system, not only a slice's.
- The full frozen-findings protocol, with the five-exit menu (accept as a limitation / one final
  bounded fix / revert / reframe / stop) if one correction is not enough.

---

## The operator's own pass — not delegable

Read the artifact and explain back, in your own words, what it makes the models do. If you cannot,
it fails the skill-writing standard's Section 7, and the fix is **rewriting the artifact**, never
explaining it in chat.

This is also the best drift detector in practice. When a file has quietly absorbed scope from the
complete-system explainer, it *reads* more complicated than the MVP should feel — and that is
noticeable before any checklist catches it.

---

## Two things never to do

**Never re-run a broad QC on a file that already passed** because "one more look cannot hurt." That
is the assurance ratchet. A passed file is re-checked only when it actually changes.

**Never let a QC session fix what it finds.** Reviewer finds, builder fixes. Otherwise the review
target moves under the reviewer — v1 failure mode 18.
