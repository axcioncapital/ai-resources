---
task: context-engineering-implementation
turn: codex
---

## Objective and approved scope
Implement and prove the governing Context Engineering specification according to the approved implementation
plan, one evidence-gated session at a time. The task may progress through S1–S12 only by the plan's exit and
stop conditions; this unit authorises S1 only. Excluded from this unit: S2 or later work, candidate carriage,
live Work Loop edits, specification or plan edits, new governance machinery, and changes outside the S1 trial
artifacts plus this state file.

Governing specification: `plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md`, approved against
`148689d42ee7817239219417a1b884b961660f86`. Plan of record:
`plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md`, approved
against `cc635d4`.

## Current lane and unit
Standard. Unit 1 — S1, build the CE-9 fresh-session-recovery measurement instrument.

Named reason for the loop: the implementation spans multiple sessions, its scope must remain bounded across
S1–S12, and each result needs assessment by someone other than its builder before progression.

## Brief
Why: CE-9's fresh-session recovery claim cannot be proved unless durable sources contain a material fact
that the request itself does not carry. S1 builds that falsifiable instrument before any behaviour or
carriage is implemented.

Check against the live repository before acting:

1. Verify both authority bindings above against Git and confirm neither approved document has received a
   material semantic change since its bound content. If either binding or currency claim fails, stop.
2. Re-derive F-1–F-11 from plan §4.1 using the named live files and the methods stated there. Treat them as
   premises, not inherited facts. Record what was inspected and any difference. If a difference is
   load-bearing for S1, stop; do not silently adapt the plan.
3. Re-check the observed absence of
   `plans/work-loop-v2-v0.2/context-engineering/trials/` at unit open. The searched surface was that exact
   path. If it now exists, inspect it and stop if any existing purpose or artifact would conflict with S1.

Implement only plan §7 Phase 1, Session S1:

- Create `plans/work-loop-v2-v0.2/context-engineering/trials/ce-9-recovery-scenario.md` and only the seeded
  durable-source fixtures the scenario needs, under that same `trials/` tree.
- Seed at least one material fact that a short, natural operator continuation request does not contain.
  State exactly which fact is the discriminator, why it is material to the next justified unit, and how a
  memory-only control is kept blind to it.
- Keep the request text as an explicitly delimited surface so its absence can be tested without searching
  the scenario's explanatory prose. Mark every fixture as non-authoritative using plan §4.4's required
  first-line `FIXTURE —` notice, and place no fixture where live project discovery could reach it.
- Do not build or edit `trials/candidate/SKILL.md`; that belongs to S2.

Evidence required, recorded in this state file with the result:

1. Give the exact two reproducible grep commands and their outputs/exit statuses: one must find the complete
   discriminator in the seeded durable source; the other must search only the delimited request text and
   return no match. The second command must turn into a hit if the discriminator is inserted into the
   request, so the check can fail.
2. Show that the control receives only the delimited request and no seeded durable source or preloaded
   summary, and name what the later source-opened run will additionally receive.
3. List every file created or changed for S1 and confirm the live core, Claude command, Codex skill,
   specification, and implementation plan are unchanged.

Stop if no naturally omitted material fact can be constructed, if the control cannot be kept blind, if a
load-bearing premise is false, or if S1 would require work outside the scope above. On stop, write the
finding here, set `turn: codex`, commit, and do not work around it. Otherwise write the material result and
evidence here, set `turn: codex`, commit all S1 work including this state file, and stop.

## Latest result

Inspected (2026-08-02):

- **Claim (1) — both authority bindings hold, neither document materially changed: HOLDS.** Ran
  `git cat-file -t` and `git merge-base --is-ancestor` on both commits: `148689d42ee7…` and `cc635d4`
  both exist and are ancestors of HEAD `a718a17`. Searched the specification for `148689d` — found at
  line 7, inside the approval block; searched the plan for `Approved commit` — found at line 25, citing
  `cc635d4`. Both files are clean against HEAD (`git diff --quiet HEAD -- <path>`, exit 0), so the
  working tree is what was approved. Diff since each bound commit: spec `148689d..HEAD` = +18/−3, plan
  `cc635d4..HEAD` = +14/−5. Read both diffs in full. Every hunk is the Phase 0 approval record itself —
  the stage header, the approval block, one tense correction in the spec's provenance paragraph, and the
  plan's filled approval slot with its two qualifying paragraphs. None touches objective, scope,
  exclusions, settled decisions, intended sequence or acceptance conditions, which is spec §5.7's
  materiality test. These are the recordings Phase 0 items 1 and 2 prescribe, so treating them as
  material would make the prescribed act self-invalidating. Phase 0's Exit condition — both approvals
  recorded, neither document materially edited since — is therefore satisfied and S1 is authorised.
- **Claim (2) — F-1…F-11 re-derived from plan §4.1 against the live files: HOLDS**, with one difference
  recorded below. F-1 core 300 lines · F-2 command 113 · F-3 skill 116 · F-4 harness 673 — all by
  `wc -l`. F-5: searched those three files with `grep -rniE 'context.?engineering'` and with
  `grep -rniE 'governing|canonical project plan|durable|approved plan'` — no match, exit 1 both times.
  F-6 read at core lines 67–68; F-7 counted — core §3 step 3 lists 7 items, spec §4.1's semantic
  interface lists 11; F-8 read at `SKILL.md:18`; F-9 read at core §4 *What the ceiling covers*; F-10:
  `grep -o 'CE-[0-9]*' | sort -u` returns exactly CE-1…CE-17, 17 unique, no gaps; F-11 confirmed by
  reading `SKILL.md:19,33,46` and `work-loop-v2.md:32,36,38`.
- **Claim (3) — `trials/` absent at unit open: HOLDS.** Searched the exact path
  `plans/work-loop-v2-v0.2/context-engineering/trials/` for existence: `ls -d` returned *No such file or
  directory*, and `git ls-files` on that path returned nothing. Nothing existed there to conflict with
  S1.

**Two differences found, neither load-bearing for S1:**

1. **The plan's own header is now stale, and says the opposite of the repository.** Lines 3–4 read
   *"Status: not authorisation to implement — the specification's approval (O-1) is still outstanding"*;
   lines 7–9 call the specification *"still a draft specification awaiting operator approval"*; line 30
   states *"O-1 … is still unanswered"*. Commit `a718a17` answered O-1. The one operative sentence,
   line 32 — *"S1 cannot open until O-1 is recorded in the specification, bound to a commit"* — is a
   condition, and it is now met, verified under claim (1). So the gate is satisfied and only the
   surrounding wording is false. Phase 0 requires O-1 be recorded **in the specification**, which it is;
   nothing requires the plan's header to be updated too, which is why nobody did. Editing the plan is
   outside this unit's scope, so it was not touched. Carried below as a deferral.
2. **F-10's line count has moved: the specification is 928 lines, not 913.** The 15-line difference is
   exactly the Phase 0 approval block. The behavioural content is unchanged — still 17 unique `CE-n`,
   CE-1…CE-17 with no gaps, which is the half of F-10 that S1 depends on.

Result: **S1 is complete. The CE-9 fresh-session-recovery instrument exists and its blind-control
property is demonstrated.** Five files were created, all under
`plans/work-loop-v2-v0.2/context-engineering/trials/`: the scenario `ce-9-recovery-scenario.md`, and four
seeded fixtures in `fixtures/ce-9/` — `project-plan.md` (spec §5.7 category 2), `task-state.md`
(category 3), `operator-source-note.md` (category 1), and `operator-request.md`, which holds the
operator's continuation request between the markers `<<<REQUEST-BEGIN>>>` and `<<<REQUEST-END>>>`. The
seeded project is fictional (*Harbourview*, a marina booking system) so no thread can recover any of it
from general knowledge. Every one of the five opens with plan §4.4's required first line, `FIXTURE — not
a project artifact; seeded for CE-9. Carries no authority.`, and all five sit under `trials/`, which is
not `plans/` root, not any `logs/work-loop/` directory, and not anywhere spec §5.7's three durable
categories are looked for. `trials/candidate/` was not created — it is S2's.

**The discriminator**, seeded verbatim in `fixtures/ce-9/task-state.md` and nowhere else in the seeded
sources, is the sentence: *"the berth-availability API returns local time with no UTC offset, so every
confirmation sent since 2026-06-14 states the wrong arrival hour"*. It is material to **the next
justified unit**, not merely informative: the plan's Phase 2 names the booking-confirmation email
template as the next build item, and settled decision SD-3 says a defect that has already produced
incorrect operator-visible output takes priority over the next build item and must also identify the
records already affected. The discriminator is the fact that turns SD-3 from dormant into decisive.
Recover it and the next unit is the corrective one; miss it and the next unit is the email template. The
fixture's `Next action` is left undecided on purpose, so the answer exists only when the blocker is read
against the plan. A real operator omits the fact naturally — *"What's the next unit"* is how a
continuation request is actually written, and it is short precisely because the sources are expected to
carry the rest.

Evidence:

1. **The two greps, run from `ai-resources/`, with `D` bound to the discriminator sentence.**
   - *Presence* — `grep -rnF "$D" plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9/`
     → one hit, `task-state.md:25`, exit **0**.
   - *Absence* —
     `awk '/^<<<REQUEST-BEGIN>>>$/{f=1;next} /^<<<REQUEST-END>>>$/{f=0} f' plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9/operator-request.md | grep -F "$D"`
     → no output, exit **1**. The `awk` pipes only the lines between the markers into `grep`, so the
     check searches the request and nothing else — not the file's explanatory prose, not the fixture
     notice, not the marker lines.
2. **The absence check is capable of failing, shown rather than asserted.** The discriminator was
   inserted between the markers in a scratchpad copy of `operator-request.md` and the identical command
   re-run against it: it returned the line and exited **0**. The live fixture was not modified and
   re-verified clean at exit **1** afterwards.
3. **The evidence already failed once, for real, and that is the strongest thing on this list.** On its
   first run the presence grep returned exit **1** — no match. The discriminator had been written into
   `task-state.md` wrapped across a line break between "UTC" and "offset", and `grep` is line-based, so
   the complete sentence was not findable. Had the check been written to pass, this instrument would have
   shipped measuring nothing. The seed was corrected to hold the sentence on one unbroken line, with a
   note in the fixture saying why the line must not be re-wrapped, and both greps then returned the
   required results.
4. **The control is blind, and what each run receives is stated in the scenario file §4.** The
   memory-only control receives **only** the text between the two markers, pasted — no fixture path, no
   fixture file, no summary, and not the scenario file itself, which states the discriminator in §3 and
   would function as an answer key. It must be a fresh thread with no prior-session note loaded; this is
   the FP-11 control the pilot showed was missing. The source-opened run receives the same request
   **plus exactly three additional things**: the paths `fixtures/ce-9/project-plan.md`,
   `fixtures/ce-9/task-state.md` and `fixtures/ce-9/operator-source-note.md`. Nothing else — no summary
   of them and no hint about the blocker.
5. **Nothing live was touched.** `git diff --quiet HEAD` returns clean for all five of: the executable
   core, `.claude/commands/work-loop-v2.md`, `.agents/skills/work-loop-v2/SKILL.md`, the specification,
   and the implementation plan.

**Recorded honestly, not worked around:** a control given only the request may simply ask for context
rather than draft, which discriminates but weakly — it shows the sources were needed, not that they were
used well. The stronger control, one holding a plausible but discriminator-free summary, is not
constructible under S1's own blindness requirement, which forbids handing the control any preloaded
summary. The limitation is written into the scenario file §6 and is inherited by S5.

## Next action

Codex: assess S1 against Phase 1's U-2 half — whether fresh-session recovery is measurable at all — and
decide close, correct once, or stop. Note that plan §7.0 additionally names **the operator** as S1's
observer: they re-run the two greps above, which are reproduced with full paths in
`trials/ce-9-recovery-scenario.md` §5, before S2 is authorised. That check is mechanical and is not
Claude checking its own output.

Two things carried forward for Codex to decide on, neither actioned:

1. **Deferral — the implementation plan's header contradicts the repository.** Detailed under difference
   (1) above. It now asserts O-1 is outstanding and that S1 cannot open, when `a718a17` answered O-1 and
   the condition is met. Left unedited because plan edits are outside this unit's scope. It should be
   reconciled before it misleads a later session into stopping, and the reconciliation is the same shape
   Phase 0 already applied to the specification's stage header. Whether that is a Phase 0 completion or a
   separate unit is Codex's call.
2. **Deferral — F-10's stated line count is stale**, 913 against a live 928. One number in plan §4.1.
   Not load-bearing: the 17-behaviour half of F-10 was re-derived and holds.
