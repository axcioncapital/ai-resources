---
task: context-engineering-implementation
turn: operator
---

## Objective and approved scope
Implement and prove the governing Context Engineering specification according to the approved implementation
plan, one evidence-gated session at a time. Phase 1 is complete: S1 established a measurable CE-9 recovery
instrument, and S2 established explicit-file carriage. S3 is authorised as the first Phase 2 slice.

Governing specification: `plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md`, approved against
`148689d42ee7817239219417a1b884b961660f86`. Plan of record:
`plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md`, approved
against `cc635d4`.

## Current lane and unit
Standard. S3, Slice A — prove the smallest one-touch kernel red then green against the isolated candidate.

Named reason for the loop: the implementation spans multiple sessions, its scope must remain bounded across
S1–S12, and each result needs assessment by someone other than its builder before progression.

## Brief
**Why this unit:** S3 is the first isolated behavioural proof licensed by S2. It must show that the absence
of Slice A is detectable before adding only the first coherent family: CE-17 clauses 1–2, CE-1, CE-2,
CE-3, and CE-15.

**Premises to re-check before accepting evidence:**

1. `trials/candidate/` contains only `SKILL.md`; at preparation it is 116 lines and byte-identical to
   `.agents/skills/work-loop-v2/SKILL.md` (SHA-256
   `956c76f37230fb2a6b4d1605afecdcb4edd64a5828803464c29a0c9689720868`). It contains none of the named
   Slice A wording. The red run, not this construction claim, determines whether each case is
   behaviourally absent. If any case starts green, stop before candidate revision and return it to Codex
   as a non-discriminating case; call it contamination only if evidence shows the candidate or seed was
   contaminated.
2. S2 licenses carriage only when a fresh Codex task is explicitly pointed at the candidate. Ordinary
   installed-skill discovery remains unproved until S8b.
3. S1's Harbourview scenario and four fixtures exist under `trials/`; each fixture opens with the required
   `FIXTURE —` notice, and no Harbourview state exists in the live `logs/work-loop/` directory.
4. `trials/slice-a-evidence.md` does not exist before S3. It is an output of the completed trial, not an
   input or a preparation artifact.

**Fixed seeded input for both evaluation runs:** use the unchanged S1 Harbourview fixture set already in
the repository, but give each fresh task only the following operator request. Apart from explicitly naming
the candidate file as its instruction source, do not add hints, expected outcomes, plan/spec excerpts, or
summaries. Paste the request verbatim for red and green:

> Prepare the next Harbourview Work Loop unit. It must correct the wrong arrival hour and identify every
> confirmation affected since 2026-06-14, even though identifying all of them is the inconvenient half of
> the objective. I do not remember where the Harbourview material lives in this repository. I also do not
> know which repository surface parses the availability timestamp; establish that by inspection rather
> than guessing. Once the affected set is known, whether guests should be contacted in this unit or later
> remains my decision.

**Constructed failing cases — record one red and one green line for each:**

1. **CE-1 · Discoverable location:** asking the operator where the load-bearing Harbourview file is fails;
   locating and citing it passes.
2. **CE-2 / CE-17 clause 2 · Mixed unknowns:** returning both the repository question and the genuine
   guest-contact decision fails; only the genuine decision may return, while the repository question is
   carried as a claim or discovery target.
3. **CE-3 · Inspectable unknown:** refusing or guessing which implementation surface parses the timestamp
   fails; a discovery unit of the form “establish X, inspect Y, return evidence, then reframe or stop,” with
   a checkable completion condition, passes.
4. **CE-15 · Second orientation artifact:** producing a separate operator-orientation document fails; one
   brief opening with the §4.1 orientation and continuing into Claude's execution context passes.
5. **CE-17 clause 1 · Derivable preparation loop:** a context interview, separate QC pass, or repeated
   preparation pass for derivable information fails; one preparation pass passes.

**Red–green protocol and actor handoff:**

1. The operator drives a fresh Codex **red evaluator** in a disposable root outside the shared checkout.
   It uses the current behaviourally empty candidate and the fixed seeded input, prepares but does not
   execute the unit, and must not revise the candidate. Its trial-generated state must resolve only inside
   that disposable root.
2. Preserve the red task reference and its produced state/brief before anything else changes. A red run
   that does not fail every named case is not proof: stop before candidate revision and return the result
   to Codex to distinguish pre-existing adjacency from actual contamination. Do not tune the seed after
   seeing the output.
3. Only after a genuine red is preserved, the operator drives a separate Codex authoring task to revise
   only `trials/candidate/SKILL.md`. Add the single-pass rule, §4.1 output contract, three-sentence
   orientation, CE-1, CE-2, CE-3, and CE-15; add no later family.
4. The operator then drives a fresh Codex **green evaluator** in a second disposable root made from the
   same baseline. Copy in only the revised candidate; every other visible file and the seeded input must be
   identical to red. The installed `.agents/skills/work-loop-v2/SKILL.md` must be absent from both roots,
   leaving the explicitly named candidate as the only Work Loop skill available to either evaluator.
   Preserve the green task reference and produced state/brief separately.
5. Return both task references, both primary outputs, and the candidate revision to Codex. Codex will then
   change `turn:` to `claude`; only after that handoff does Claude observe the red/green record, re-derive
   the four counts, and create `trials/slice-a-evidence.md`. Do not send the task to Claude while this file
   still says `turn: operator`.

The two disposable evaluation roots must remain outside the shared checkout and separate from each other.
No fictional state may be written to the live `logs/work-loop/` directory, and neither run may overwrite
the other's output. Keep both primary outputs independently inspectable until Claude has embedded them or
immutable task references to them in the evidence record; summaries alone are not primary evidence.

**Evidence capable of failing:** the evidence record must show the same input, the red result before the
candidate revision, the candidate-only behavioural change, and the green result. It must report four
re-derivable counts: preparation passes (target **1**); operator context actions beyond stating the
objective (target **0**, excluding genuine decisions); artifacts describing the unit (target **1**); and
orientation sentences (target **≤3**). A missing red record, a missing per-case line, an uninspectable
primary output, or a green run with any other behavioural variable fails S3.

**Scope and stop conditions:** only `trials/candidate/SKILL.md` and, after both runs, the single
`trials/slice-a-evidence.md` may become repository outputs. Do not touch the live
`.agents/skills/work-loop-v2/SKILL.md`, the executable core, commands, hooks, or other runtime files. Do not
add CE-17 clause 3, authority, verification, alignment, selection, non-accretion, or later-slice behaviour;
do not begin S3b. If carriage causes more than one artifact, return to Phase 1 rather than adding a
reconciliation step. Exit only when all five behaviours are demonstrated red then green and all four
counts meet their targets.

## Latest material result
S2's accepted isolated rerun established explicit-file carriage without live-state contamination and left
the candidate behaviorally empty. Its rejected live-directory run proved why S3 must isolate trial state
and preserve red and green outputs separately.

**Result (Claude, S8-ff8): the evaluation boundary is hardened and preflighted. The root was rebuilt from
scratch, because the previous one's scrub was cosmetic.**

*Premises re-checked by inspection this unit; all four hold.* P1 — `trials/candidate/` holds `SKILL.md`
alone, 116 lines, SHA-256 `956c76f3…`, `diff` against the live skill empty, and zero hits for Slice A
wording on a bounded `CE-(1|2|3|15|17)`/orientation/discovery-unit/preparation-pass pattern (control
matched). The bounded form is required: the naive case-insensitive `ce-[0-9]+` false-positives on `slice-1`
at candidate line 77. P2 — `carriage-trial-record.md` §1 licenses carriage for "a fresh thread pointed at
that file" and explicitly withholds it for "ordinary skill discovery once installed". P3 — four
`FIXTURE —` fixtures under `trials/fixtures/ce-9/`; no file in the live `logs/work-loop/` carries a `task:`
id naming Harbourview. P4 — `trials/slice-a-evidence.md` absent.

**Why the root was rebuilt rather than amended.** The previous root was a detached git worktree, which was
Claude's construction choice at preparation and not required by the brief. Inside it, every scrubbed file
remained fully recoverable — `git show HEAD:…/context-engineering-spec-v0.1.md` returned the governing
spec, and the implementation plan likewise — while `git status` listed 268 deletions, simultaneously
announcing that material had been hidden and mapping exactly what to recover. **The scrub was cosmetic; the
answer key was one command away.** The replacement carries no `.git` at all, so there is no history to read
and no status to interrogate. Built by `git archive 32d3c26 | tar -x`, which is reproducible for the green
root.

**The root.**
`/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources/ff847f81-f482-4d29-ac4f-caeb88dfadea/scratchpad/wl-root-4c8d`,
baseline `32d3c26b43348b656bc7ecfabf3e9411b7066ece`, git-less, outside the shared checkout. Its name is
deliberately opaque and the green root's must be too: the first root was named `s3-red-root`, which put the
arm and the stage into the first line the thread reads. `trials/candidate/SKILL.md` still reads "trials"
and "candidate", but that path is fixed by the brief and identical across both arms, so it carries no
differential signal; a root name has no such defence.

**Preflight — six properties, every absence check paired with a control that matched.**

1. Candidate present and unmodified: SHA-256 `956c76f37230fb2a6b4d1605afecdcb4edd64a5828803464c29a0c9689720868`.
2. Executable core present — the candidate mandates reading it, and it carries no CE content.
3. **The candidate is the only Work Loop skill in the root**, and `.agents/` now holds zero files. Both
   installed skills were removed, not only `work-loop-v2`: `work-loop` (v1) is also a Codex Work Loop skill,
   and its description — "when someone brings a concrete piece of repository work … wants it done properly
   rather than improvised" — matches the seeded request directly, so it would have been discovered. Codex's
   requirement is *the only* Work Loop skill; meeting it as stated required removing both. Stated here
   rather than done quietly (core § 6 rule 4).
4. No `.git`: `git status` inside the root returns `fatal: not a git repository`.
5. Answer-key scrub passes: zero files for `CE-(1|2|3|15|17)`, `slice-a-evidence`, `Slice A`, and the
   count-target phrasings. Harbourview appears in exactly four files, all of them the fixtures. Scrub rule
   unchanged and reproducible — no `logs/` except `logs/scripts/`, plus four named deletions (the
   implementation plan, the spec, `carriage-trial-record.md`, and `ce-9-recovery-scenario.md`, whose §6
   scores what a passing brief must name).
6. Trial state can resolve only inside the root: `logs/work-loop/` is absent, so the candidate's own rule
   creates it in-root; and no symlink escapes — see the finding below.

**Two boundary findings. One fixed inside this unit, one handed to Codex.**

- **Fixed — an absolute symlink escaped the root.**
  `workflows/research-workflow/.claude/commands/session-plan.md` pointed at
  `/Users/…/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md`, so any read through it left the
  disposable root and landed in the live checkout. This directly broke the property Codex asked to be
  verified, so it was fixed rather than deferred. Removed; the three remaining symlinks are relative and
  resolve in-root. The same deletion must be applied to the green root.
- **Deferred to Codex — 403 files in the root name the live checkout by absolute path**, 382 of them under
  `audits/`. This is a disclosure route, not a resolution failure: nothing resolves out of the root by
  itself, but a thread that reads one of those files learns where a complete, unscrubbed copy of the answer
  key lives. Removing `audits/` would eliminate 382 of the 403 and costs the trial nothing, but it changes
  the root's shape and must be applied identically to red and green — a construction decision that is
  Codex's to ratify, not Claude's to take unilaterally. Not implemented.

**The green root must be built to match:** `git archive 32d3c26 | tar -x` into an opaquely-named directory
outside the shared checkout, no `.git`, the same scrub rule, both Work Loop skills absent, the escaping
symlink removed, and only the revised candidate copied in.

**Operator action outstanding — the previous root still exists.**
`…/scratchpad/wl-root-7f3a` is still registered as a worktree and still carries the recoverable answer key.
`git worktree remove --force` was attempted and the liveness guard blocked it, correctly: it reads the 268
scrub deletions as uncommitted work and cannot distinguish them from a live session's. The guard was not
bypassed. It needs the operator to confirm the root is idle, after which the documented
`AXCION_LIVENESS_OVERRIDE=1` prefix applies. **Until it is removed, do not use it** — `wl-root-4c8d` is the
only valid red root.

*Protocol note:* `## Next action` did not open with core § 3's hand-off token, so this invocation was
treated as a unit rather than the one bounded correction, despite carrying a closure check. And `turn:` is
set to `operator` per Codex's explicit instruction rather than the command's `codex` default, because the
next move genuinely is the operator's.

Carry to task closure as deferrals: candidate-marker wording in plan §7; the plan header's stale O-1
status; F-10's stale specification line count; and S1's range-based scope check not being duplicated into
its scenario file.

## Next action
Operator: run the red evaluator. Paste the block below verbatim into **one fresh Codex task**. Add nothing
to it — every line it does not contain is deliberate, and the request's three stated unknowns are what
cases 1–3 measure. Use `wl-root-4c8d`; the earlier `wl-root-7f3a` is defunct and must not be used.

> You are Codex working in the repository at:
>
> `/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources/ff847f81-f482-4d29-ac4f-caeb88dfadea/scratchpad/wl-root-4c8d`
>
> Work only inside that directory. Every path you read or write must resolve inside it.
>
> Your instructions for how to work are in this file. Read it first and follow it:
>
> `plans/work-loop-v2-v0.2/context-engineering/trials/candidate/SKILL.md`
>
> Do not modify that file.
>
> Prepare the unit only. Do not execute or implement it.
>
> The operator's request:
>
> Prepare the next Harbourview Work Loop unit. It must correct the wrong arrival hour and identify every
> confirmation affected since 2026-06-14, even though identifying all of them is the inconvenient half of
> the objective. I do not remember where the Harbourview material lives in this repository. I also do not
> know which repository surface parses the availability timestamp; establish that by inspection rather
> than guessing. Once the affected set is known, whether guests should be contacted in this unit or later
> remains my decision.

**Immediately after the run, before anything else changes:** preserve the task reference and copy the
produced state file out of the root. The candidate's `logs/work-loop/` rule resolves *inside* the root, so
the output lands at `<root>/logs/work-loop/<task-id>.md` — that is the primary evidence, and it is the file
S2's run 1 destroyed by letting a second run share a root. Do not start the green run in this root.

Two items for the operator alongside the run: confirm whether `wl-root-7f3a` is idle so it can be removed
(the liveness guard blocked removal and was not bypassed), and note that Codex owes a decision on whether
`audits/` is dropped from both roots — see the deferred finding above.
