---
task: context-engineering-implementation
turn: codex
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
**Result: the frozen disclosure finding is resolved.** The red root `wl-root-4c8d` no longer contains any
file naming the live checkout, `audits/` is gone, and every file the trial requires is present and
byte-unchanged. No new escape, answer-key leak, or red/green asymmetry was introduced. The finding was
reproduced by inspection before being corrected, and the deletion rule was checked against the
required-kept files first — none of the candidate, the executable core or the four fixtures contains the
live-checkout prefix, so the rule could be applied literally without a carve-out.

**Evidence.** Before the correction, `grep -rlF '/Users/…/Axcion AI Repo/ai-resources'` over the root
returned **389 files** (372 under `audits/`, plus 17 across `.claude/commands/`, `logs/scripts/`, `docs/`,
`inbox/`, `scripts/` and `plans/`). After it, the same search returns **0**, with a positive control on the
same pattern returning 1 — so the zero is a true negative and not an unreadable-input artifact. The six
required files hash identically before and after: candidate `956c76f3…`, core `bf657ebb…`, and fixtures
`f65910cc…`, `c8d29350…`, `9d31c4ef…`, `1a4145c3…`. Re-checked after the deletions and all still true: no
`.git`; `logs/work-loop/` absent; exactly one Work Loop `SKILL.md` in the root, the candidate; Harbourview
in exactly four files, all fixtures; zero hits for `CE-(1|2|3|15|17)`, `slice-a-evidence`, `Slice A` and the
count-target phrasings, each with a matching control; three symlinks remaining, all relative and all
resolving — none dangling after the `.claude/commands/` deletions; and `logs/scripts/work-loop-v2-slice-1.test.sh`,
which the candidate cites at line 77, still present.

**The complete build rule — the green root must reproduce all six steps, differing only in the revised
candidate.**

1. `git archive 32d3c26 | tar -x` into an opaquely-named directory outside the shared checkout. **Not a git
   worktree and not a clone:** the root must carry no `.git`. A worktree was the original construction and
   it left every scrubbed file recoverable by `git show HEAD:…` while `git status` mapped the deletions.
   An opaque name matters too — the first root was named `s3-red-root`, which put the arm and the stage
   into the first line the thread reads.
2. Delete everything under `logs/` except `logs/scripts/`.
3. Delete four answer-key files: the implementation plan `-v0.1.md`, the spec `-v0.1.md`,
   `trials/carriage-trial-record.md`, and `trials/ce-9-recovery-scenario.md` (its §6 scores what a passing
   brief must name).
4. Delete both installed Work Loop skills — `.agents/skills/work-loop/` and `.agents/skills/work-loop-v2/`.
   Both, not only v2: v1 is also a Codex Work Loop skill and its description matches the seeded request
   directly, so it would have been discovered.
5. Delete `workflows/research-workflow/.claude/commands/session-plan.md` — an absolute symlink resolving
   into the live checkout.
6. Delete `audits/`, then delete every remaining file containing the literal string
   `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`. Re-run the search until it returns
   zero.

Must remain present and unchanged after all six: the candidate, the executable core, and the four
`FIXTURE —` fixtures under `trials/fixtures/ce-9/`.

*Premises, re-checked by inspection and all holding.* P1 — `trials/candidate/` holds `SKILL.md` alone, 116
lines, SHA-256 `956c76f3…`, `diff` against the live skill empty, zero hits for Slice A wording on a bounded
pattern with a matching control. The bounded form is required: the naive case-insensitive `ce-[0-9]+`
false-positives on `slice-1` at candidate line 77. P2 — `carriage-trial-record.md` §1 licenses carriage for
"a fresh thread pointed at that file" and withholds it for "ordinary skill discovery once installed". P3 —
four `FIXTURE —` fixtures present; no file in the live `logs/work-loop/` carries a `task:` id naming
Harbourview. P4 — `trials/slice-a-evidence.md` absent.

**Carried, not resolved — the obsolete root.** `…/scratchpad/wl-root-7f3a` still exists, is still registered
as a worktree, and still carries the answer key recoverable through git. Removal was excluded from this
correction by the brief and remains deferred until the operator confirms it is idle; the liveness guard
blocked `git worktree remove` and was not bypassed. Until it is gone, `wl-root-4c8d` is the only valid red
root.

Carry to task closure as deferrals: candidate-marker wording in plan §7; the plan header's stale O-1
status; F-10's stale specification line count; and S1's range-based scope check not being duplicated into
its scenario file.

## Next action
Codex: run the closure check on frozen finding 1 only — is the disclosure resolved, and did the correction
break a required trial input or introduce any new escape, answer-key leak, or red/green asymmetry? The
evidence is above. On close, hand to the operator with the prompt below.

**Ready-to-paste red prompt.** Paste verbatim into **one fresh Codex task**. Add nothing to it — every line
it does not contain is deliberate, and the request's three stated unknowns are what cases 1–3 measure. Use
`wl-root-4c8d`; `wl-root-7f3a` is defunct and must not be used.

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
