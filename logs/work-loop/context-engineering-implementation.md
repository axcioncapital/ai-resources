---
task: context-engineering-implementation
turn: codex
---

## Objective and approved scope
Implement and prove the governing Context Engineering specification according to the implementation plan,
one evidence-gated session at a time. Phase 1 is complete and S2 is accepted.

Governing specification: `plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md`, approved against
`148689d42ee7817239219417a1b884b961660f86`. Plan of record:
`plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md`, reapproved
by the operator on 2026-08-02 against `e1ce895b3da1387bae7ce50623afc3875cb050ba`; Codex accepts Claude's
bounded approval-metadata record.

## Current lane and unit
Standard. S3 Slice A — the candidate-only revision is independently validated and the isolated green
evaluator is built and ready. The green run, `trials/slice-a-evidence.md`, S3b, and S4 are not yet open.

Named reason for the loop: the implementation spans multiple sessions, its scope must remain bounded across
S1–S12, and each result needs assessment by someone other than its builder before progression.

## Brief
**Why:** the candidate now carries the Slice A contract, but that authoring result is not accepted until
Claude independently validates the one-file revision and makes the later green evaluation ready without
changing the seeded variable or consuming the run.

**Claims to check:**

1. `plans/work-loop-v2-v0.2/context-engineering/trials/candidate/SKILL.md` is still the only entry in its
   folder and has SHA-256 `5b3f591b9525bc2046494184e9968bf6f46735ad78f0c01c2c78cb4cb6896679`.
2. Against approved plan §7 S3 and specification §2, §4.1, Family 1, and CE-15, the added text contains
   exactly CE-17 clauses 1–2, CE-1, CE-2, CE-3, and CE-15; preserves the existing Work Loop v2 behavior
   and terminology; and adds neither CE-17 clause 3 nor a later Context Engineering family.
3. The live `.agents/skills/work-loop-v2/SKILL.md` retains SHA-256
   `956c76f37230fb2a6b4d1605afecdcb4edd64a5828803464c29a0c9689720868`; the preserved primary red output
   retains SHA-256 `688baf120ad75068fbdb74cc267e496930cef91822f6a8af8eef4484779c2b0f`; and
   `plans/work-loop-v2-v0.2/context-engineering/trials/slice-a-evidence.md` remains absent.

**Scope:** validate the candidate-only revision, then prepare—but do not execute—the isolated green
evaluator using the unchanged seeded input from the preserved pre-revision run. Keep the candidate as the
sole behavioural variable and make the evaluator ready to measure all five Slice A behaviours and the four
approved counts without overclaiming causality for the four baseline-green behaviours.

**Excluded:** no green run; no `slice-a-evidence.md`; no seed change; no change to either disposable root,
the preserved primary red output, the live skill, executable core, plan, specification, fixtures, scenario,
or runtime; no second candidate artifact; no later CE family; no S3b or S4.

**Evidence capable of failing:** return the candidate validation verdict with the clause-by-clause mapping
and hashes above; identify the prepared evaluator and show it uses the unchanged seeded input while the
candidate is its sole behavioural variable; and show that no green output was generated and
`slice-a-evidence.md` remains absent. Stop and hand back if validation fails or preparation would require
crossing an exclusion.

## Latest material result
**Validation verdict: the candidate-only revision PASSES all three claims.** The green evaluator is built
and ready; it has not been run.

**Claim 1 — candidate identity.** `trials/candidate/` holds `SKILL.md` alone (`find -mindepth 1` returns
that one path), SHA-256 `5b3f591b9525bc2046494184e9968bf6f46735ad78f0c01c2c78cb4cb6896679`. Matches.

**Claim 3 — the three fixed points.** Live `.agents/skills/work-loop-v2/SKILL.md` =
`956c76f37230fb2a6b4d1605afecdcb4edd64a5828803464c29a0c9689720868`; preserved primary red output =
`688baf120ad75068fbdb74cc267e496930cef91822f6a8af8eef4484779c2b0f`; `trials/slice-a-evidence.md` absent.
All three match.

**Claim 2 — clause-by-clause mapping.** The revision is isolable exactly, because the pre-revision
candidate was byte-identical to the live skill: `diff` live-skill → candidate returns **one hunk, 8 lines
inserted, zero deleted, zero modified** — a pure insertion of `### Prepare once; write one brief for two
audiences` under `## Opening a unit and writing the brief`, the section that owns brief-writing. Existing
Work Loop v2 behaviour and terminology are preserved by construction: nothing was removed or reworded.

| Added text | Authorised behaviour |
|---|---|
| "Prepare the unit in **one pass**" | CE-17 clause 1 (spec §6 Family 1; §2 target 1) |
| "Do not open an iterative context interview, a separate QC pass or a preparation loop for information the pass can derive" | CE-17 clause 1 failing case, spec wording |
| "End the pass with exactly one execution brief, one discovery brief or one genuine escalation" | CE-17 clause 1 succeeds-if |
| "evidence or a result after Claude begins work is normal subsequent Work Loop work, not another preparation pass" | CE-17 clause 1's explicit carve-out |
| "The operator supplies the objective and any optional raw material once" | CE-17 clause 2 |
| "do not ask the operator to assemble, reconcile or restate context carried by durable sources" | CE-17 clause 2 failing case |
| "locate, derive and reconcile repository-resolvable context yourself" | CE-1 |
| "Only a genuine operator-owned decision about intent, priority, authority or risk returns to the operator" | CE-2, with §5.4's four categories |
| Whole second paragraph — discovery unit; "state what must be established, what Claude must inspect, what evidence must return, and that Claude must then reframe or stop" | CE-3, reproducing its succeeds-if four-part shape |
| "one brief, for two audiences"; "Do not create a separate operator-orientation document or any second artifact describing the unit" | CE-15 headline and failing case |
| "one paragraph of at most three sentences answering only why this unit, why now and how it aligns with the approved plan" | CE-15 + §4.1 orientation, all three questions, sentence ceiling |
| The 11-item execution-context list | §4.1's required contents, same items in the same order; "minimum-sufficient" is §4.1's own qualifier |
| "remains durable context rather than a second handoff artifact only when it does not restate the brief; the test is duplication, not mention" | CE-15's second paragraph and §4.1 |

**Nothing outside the authorised set.** Zero content from Families 2–5 and no CE-16: bounded searches for
authority/disposition, verification-marking, alignment-gate, selection-rule and non-accretion language
return nothing in the added text.

**Two judgment calls, flagged rather than absorbed — Codex may overrule either.**
1. *"inside the one state file"* is the nearest approach to the excluded CE-17 clause 3. Judged **not**
   clause 3: clause 3 is delivery-without-ferrying, and the sentence asserts nothing about the operator
   not carrying the brief or about Claude receiving it without a transfer action. It names where the
   single artifact lives, which is CE-15 scoping, using the carriage S2 already proved.
2. The new `###` is the file's **first** third-level heading; every other heading is `##`. Formatting, not
   behaviour or terminology, so not a claim-2 failure. Recorded as an observation.

**The prepared green evaluator.** Root:
`/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources/d4a61e27-41af-4aae-a193-556a1500f3a3/scratchpad/wl-root-9e2b`
— outside the shared checkout, opaquely named, separate from `wl-root-4c8d`, and built by reproducing all
six steps of the recorded build rule from the same baseline `32d3c26`, then overwriting only the candidate.

*The candidate is the sole behavioural variable, shown by direct comparison rather than by assertion.*
`diff -rq` between the preserved red root and the green root returns exactly two lines: the candidate
differs, and `logs/work-loop` exists only in red. The second is the red run's own **output**, produced
after that root was built, not a build asymmetry — green has no `logs/work-loop` because no run has
occurred. File counts 541 (red) vs 540 (green); the difference is that one produced file. Every other
file in the two roots is byte-identical.

*Failing-capable checks on the green root.* No `.git`. Exactly one Work Loop `SKILL.md` in the whole root
— the candidate; both installed skills (`work-loop` and `work-loop-v2`) removed. The four answer-key files
absent. `audits/` gone; files containing the live-checkout literal went 17 → **0**, with a positive control
returning 1 on the same pattern, so the zero is a true negative. Bounded searches for `CE-(1|2|3|15|17)`,
`Slice A` and `slice-a-evidence` return **0 files root-wide**, each with a control returning 1 — including
**zero hits inside the revised candidate itself**, which states the behaviours as prose and names no CE id,
so the revision introduced no answer key. `Harbourview` appears in exactly four files, all
`FIXTURE —`-marked fixtures under `trials/fixtures/ce-9/`, hashing `f65910cc…`, `c8d29350…`, `9d31c4ef…`,
`1a4145c3…` — unchanged. Executable core `bf657ebb04ef…` — unchanged. Three symlinks remain, all relative,
all resolving, none dangling. `logs/scripts/work-loop-v2-slice-1.test.sh`, cited by the candidate, present.

*Nothing was run and nothing was consumed.* The green root has no `logs/work-loop/` and no produced output;
`trials/slice-a-evidence.md` remains absent; the seeded input is unchanged and is reproduced verbatim below
from the red prompt; and the red root is untouched — its output still hashes `688baf12…` and its
pre-revision candidate still `956c76f3…`.

Carried deferrals, outside this unit: candidate-marker wording in plan §7; the plan header's stale O-1
wording; F-10's stale specification line count; S1's range-based scope check not copied into its scenario
file; plan line 573's stale historical framing; the header's historical `Assessment status: unassessed`
wording; and removal of obsolete `wl-root-7f3a` after the operator confirms it is idle.

## Next action
Codex: run the closure check on this unit — does the clause-by-clause mapping hold, are the two flagged
judgment calls (the `inside the one state file` phrasing against excluded CE-17 clause 3; the first `###`
heading) decided the right way, and is the green root a valid symmetric counterpart to the preserved red
root with the candidate as its sole behavioural variable? On close, hand to the operator with the prompt
below.

**Ready-to-paste green prompt.** Paste verbatim into **one fresh Codex task**. It is the red prompt with
one substitution — the root path — so the seeded request is byte-identical to the one the red run received.
Add nothing to it: every line it does not contain is deliberate, and the request's three stated unknowns
are what cases 1–3 measure. Use `wl-root-9e2b`; do not reuse `wl-root-4c8d` (it holds the red output) and
never `wl-root-7f3a` (defunct).

> You are Codex working in the repository at:
>
> `/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources/d4a61e27-41af-4aae-a193-556a1500f3a3/scratchpad/wl-root-9e2b`
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
S2's run 1 destroyed by letting a second run share a root. Do not reuse this root for any further run.

Only after both primary outputs are preserved does the task return to Claude to observe the red/green
record, re-derive the four counts and create `trials/slice-a-evidence.md`. The four baseline-green
behaviours may not be reported as caused by the revision — that is the §4.4 overclaim, and CE-3 is the one
case this slice must show red-then-green.
