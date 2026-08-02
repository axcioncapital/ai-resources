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
   Slice A behaviour. If the red run is green, treat the bootstrap as contaminated and stop.
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
   that does not fail every named case is not proof: stop and return the result to Codex for a Phase 1/S2
   diagnosis. Do not tune the seed after seeing the output.
3. Only after a genuine red is preserved, the operator drives a separate Codex authoring task to revise
   only `trials/candidate/SKILL.md`. Add the single-pass rule, §4.1 output contract, three-sentence
   orientation, CE-1, CE-2, CE-3, and CE-15; add no later family.
4. The operator then drives a fresh Codex **green evaluator** in a second disposable root made from the
   same baseline. Copy in only the revised candidate; every other visible file and the seeded input must be
   identical to red. Preserve its task reference and produced state/brief separately.
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

**S3 preparation, Claude, session S8-ff8 — the four premises hold; the red root is built and scrubbed.**

Premise 1 — **holds.** `trials/candidate/` holds `SKILL.md` alone; 116 lines; SHA-256
`956c76f37230fb2a6b4d1605afecdcb4edd64a5828803464c29a0c9689720868`, matching the brief's literal hash and
the live skill's, with `diff` empty. Behavioural emptiness checked four ways — literal `CE-n` references,
orientation/§4.1/three-sentence language, discovery-unit language, and preparation-pass language — all
zero, each paired with a positive control that matched. The bounded pattern was necessary: the naive
case-insensitive `ce-[0-9]+` form false-positives on `slice-1` at candidate line 77, which is the S2 defect
reproduced exactly.

Premise 2 — **holds.** `trials/carriage-trial-record.md` §1 states the limit in its own words: carriage is
licensed for "a fresh thread pointed at that file", and "any claim that the same instruction is picked up
through **ordinary skill discovery once installed**" is explicitly not licensed, being "unproved until
S8b's pre/post invocation at the live entrypoint".

Premise 3 — **holds.** Four fixtures under `trials/fixtures/ce-9/` (`operator-request.md`,
`operator-source-note.md`, `project-plan.md`, `task-state.md`), each opening with the `FIXTURE —` notice.
The fixtures sit one directory deeper than the brief's "under `trials/`" wording implies. No Harbourview
*state* exists in the live `logs/work-loop/`: no file there carries a `task:` id naming Harbourview
(checked across all 17 files, control matched). A plain text search does return Harbourview hits in that
directory, but every one is this state file's own brief prose — not state, and not a contamination.

Premise 4 — **holds.** `trials/slice-a-evidence.md` does not exist.

**The red root.** Disposable detached worktree at
`/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources/ff847f81-f482-4d29-ac4f-caeb88dfadea/scratchpad/wl-root-7f3a`,
baseline `32d3c26b43348b656bc7ecfabf3e9411b7066ece`, outside the shared checkout and its own tree. The
candidate inside it is byte-identical to the hash above.

**The root's name is deliberately opaque, and the green root's must be too.** It was first built as
`s3-red-root`, which put the arm and the stage in a path the thread reads on its first line — a leak I
introduced and then caught by checking the prompt block against the same answer-key patterns as the root.
`trials/candidate/SKILL.md` still contains "trials" and "candidate", but that path is fixed by the brief,
exists in the repository permanently, and is identical across both arms, so it carries no differential
signal. A root name does not have that defence.

**The scrub, stated as a reproducible rule rather than a file list.** Enumerating answer-key files does not
survive rebuilding the root from a later commit — the S2 method found three files, whereas at this baseline
`logs/` alone holds eight-plus, and it grows with every session that writes about this task. The rule
applied instead: **the red root carries no `logs/` except `logs/scripts/`**, plus four named deletions —
the implementation plan `-v0.1.md`, the spec `-v0.1.md`, `trials/carriage-trial-record.md`, and
`trials/ce-9-recovery-scenario.md` (its §6 scores what a passing brief must name, which is the substance of
the answer). Kept deliberately: the executable core, which the candidate mandates reading and which carries
no CE content; the two Matt Pocock style documents, checked and carrying neither CE ids nor CE behavioural
language; and the MVP pilot record.

Verified after scrubbing, each check paired with a positive control that matched: zero hits for
`CE-1|CE-2|CE-3|CE-15|CE-17`, zero for `slice-a-evidence`, zero for `Slice A`, zero for the count-target
phrasings. Two non-zero results were inspected and judged not to be answer key: the English word
"orientation" in four unrelated documents, none describing an output contract; and "red run"/"green run" in
`plans/work-loop-v2-mvp/`, which are the MVP pilot's own test-harness runs and say nothing about Slice A.
Harbourview appears in exactly four files, all of them the fixtures.

**Three things the observer should carry into the red judgment.**

1. *An adjacency in the pre-existing skill, not a contamination.* Candidate line 51 ("Read the object. Open
   the file, run the grep, check the line the request cites") sits near CE-1, and line 50 ("one round, not
   an interrogation") near CE-17 clause 1. Neither is the Slice A behaviour: line 51 presumes the file is
   already identified and says nothing about locating one, and line 50 limits questioning without barring
   questions about derivable information. But a red run may partly pass case 1 or case 5 on them. If it
   does, diagnose the adjacency before concluding the bootstrap is contaminated — the hash proves the
   candidate is the unmodified live skill.
2. *A green-root question, raised not answered.* `.agents/skills/work-loop-v2/SKILL.md` is present in the
   root. It cannot affect red, being byte-identical to the candidate. At green the candidate diverges,
   and a thread reaching the installed skill by discovery would read behaviourally empty instructions.
   The brief requires the two roots to differ only in the candidate, so whichever way this is settled must
   be applied to both. Out of scope for this session.
3. *This brief was uncommitted when preparation began* — it existed only in the working tree. That is how
   run 1's control evidence was lost at S2. It is committed with this record.

Carry to task closure as deferrals: candidate-marker wording in plan §7; the plan header's stale O-1
status; F-10's stale specification line count; and S1's range-based scope check not being duplicated into
its scenario file.

## Next action
Operator: start the red evaluator now in a fresh disposable root outside the shared checkout. Point it
explicitly at the current `trials/candidate/SKILL.md`, paste only the fixed seeded request above, instruct it
to prepare but not execute the unit or revise the candidate, and preserve its task reference plus produced
state/brief; do not begin candidate revision or green unless this genuine red fails every named case.

---

**Red evaluator — prepared by Claude, session S8-ff8.** The root is built and scrubbed (see *Latest
material result*). Paste the block below verbatim into **one fresh Codex task**. Add nothing to it: every
line it does not contain is deliberate, and the request's three stated unknowns are what cases 1–3 measure.

> You are Codex working in the repository at:
>
> `/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources/ff847f81-f482-4d29-ac4f-caeb88dfadea/scratchpad/wl-root-7f3a`
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

**After the run, before anything else changes:** preserve the task reference and copy the produced state
file out of the root. The candidate's `logs/work-loop/` rule resolves *inside* the disposable root, so its
output lands at `<root>/logs/work-loop/<task-id>.md` — that is the primary evidence, and it is the file S2's
run 1 destroyed by letting a second run share a root. Do not start the green run in this root.
