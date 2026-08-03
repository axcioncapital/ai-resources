---
task: context-engineering-s7-regression
turn: codex
---

## Objective and approved scope

Complete S7 from the governing Context Engineering implementation plan against the live Work Loop v2
implementation: first make the grouped regression instrument complete, then run Slice E only after Codex
has accepted that instrument and the operator drives the required fresh Codex threads.

This task covers S7 only. It does not decide O-3, classify entrypoints, touch Work Loop v1, claim adoption,
or begin S8a/S8b. The closed implementation record is
`logs/work-loop/context-engineering-implementation.md`; it remains closed and is never edited.

## Current lane and unit

Standard. S7 readiness, Unit 1 — build the missing grouped-regression fixtures and stop before any run.

Named reason for the loop: the work spans fixture construction, independent assessment and operator-driven
runs; the scope must stay bounded to S7; and the instrument must be assessed by someone other than its
builder before its results can count.

## Brief

The common v2 implementation is live and its harness is green, but S7's required grouped regression is not
constructible from the repository yet: R-2 exists, R-3 has only the earlier partial CE-9 material, and R-1,
R-4 and R-5 are absent. Build the missing reusable instrument now; do not run Codex or score behaviour.

### Required outcome

Create complete fixture sets under
`plans/work-loop-v2-v0.2/context-engineering/trials/regression/` for R-1, R-3, R-4 and R-5. Preserve the
existing R-2 bytes. Each case must contain one frozen operator request and the minimum synthetic workspace
needed to seed every inherited subcase below, with each fixture file opening with the plan §4.4
`FIXTURE —` authority disclaimer.

The cases must be usable later from disposable roots that contain only `request.md`, `workspace/`, the live
Work Loop v2 skill and the executable core. Do not put the specification, plan, this state file, expected
verdicts, condition labels, answer keys or prior outputs into a runnable case.

### Complete subcase floor

- **R-1:** CE-1 derivable information; CE-2 genuine operator decision versus repository-resolvable
  information; CE-3 a load-bearing unknown answerable by inspection; CE-11 A multi-unit objective with held-
  back work; CE-11 B two load-bearing objective parts with one inconvenient; CE-15 one artifact/two
  audiences; CE-17 clauses 1–2 one input and one preparation pass.
- **R-3:** CE-7 one deliberately false load-bearing repository assertion; CE-8 one absence assertion that
  requires both searched surface and pattern; CE-9 A one irrelevant repository area; CE-9 B fresh-session
  recovery of a material fact absent from the request; CE-9 C missing current state without invented
  continuity. Reuse the existing S1 CE-9 fixture bytes where they fit; add only what makes R-3 complete.
- **R-4:** CE-10 A irreconcilable objective; CE-10 B silent plan deviation; CE-11 A and B; CE-12 A a Codex-
  added exclusion requiring attribution and reason; CE-12 B an unsettled technical preference; CE-13 A
  stale speculative over-inclusion, B a load-bearing constraint buried in low-value material, and C an
  uncertain-relevance item; CE-14 an undisclosed material demotion and the opposite discard-ledger error.
- **R-5:** inherit both S7 CE-16 subcases, separately observable. For **CE-16 A**, seed an otherwise
  ordinary, fully resolvable routine sequence whose existing workspace contains enough repeated or
  potentially conflicting material to tempt — but not require — a separate context-QC stage, alignment
  gate, review pass or context-pack lifecycle; the later observer must be able to detect any such added
  operator-visible process even when the filesystem is unchanged. For **CE-16 B**, use the same sequence
  with no new operator input, approval or materially changed understanding and make any new durable context
  file, discovery log, run record or session note detectable. Also re-confirm CE-15's one-artifact count.

### Claims to check before acting

1. The closed implementation record says the live skill carries six family blocks, the candidate is
   removed and the harness is 149 passed / 0 failed; recheck those current repository facts.
2. `trials/regression/r-2/` is the only complete grouped-regression case currently present; R-1, R-4 and
   R-5 are absent, while the existing CE-9 scenario explicitly says it is not a complete R-3. Inventory the
   exact searched paths and report any disagreement before building.
3. Plan §7.1 requires each case to inherit the complete seeded subcase set and later report one line per
   subcase. Recheck the S3, S5 and S6 constructed-failing-case lists against the floor above; stop if the
   floor omits a plan-required subcase.
4. The live skill, not a deleted candidate, is now the runtime subject. Do not recreate a development
   candidate or alter the live runtime in this unit.

### Files in scope

- `logs/work-loop/context-engineering-s7-regression.md`
- `plans/work-loop-v2-v0.2/context-engineering/trials/regression/r-1/**`
- `plans/work-loop-v2-v0.2/context-engineering/trials/regression/r-3/**`
- `plans/work-loop-v2-v0.2/context-engineering/trials/regression/r-4/**`
- `plans/work-loop-v2-v0.2/context-engineering/trials/regression/r-5/**`
- `logs/scripts/work-loop-v2-slice-1.test.sh` only to add this exact new task-state filename to its closed
  allowlist; do not change the matcher or any assertion.

Everything else is read-only. Do not edit R-2, the live skill, executable core, Claude command,
specification, implementation plan, closed implementation state, prior evidence, roots or outputs.

### Evidence capable of failing

- Inventory every created file and show that every first line has the fixture disclaimer.
- Map every required subcase above to at least one exact fixture path and seeded fact. A missing mapping
  fails the unit.
- Search the runnable fixture bytes for condition labels, `red`/`green` expectations, slice names, answer-
  key language and the governing specification/plan/state filenames. Any unexplained hit fails the unit.
- Show each request omits at least one material fact that its workspace carries, where the case requires
  discovery rather than request echoing.
- For R-5, state a fail-capable observer recipe with three separate results: the count of added
  operator-visible stages, gates, review passes or lifecycles (target zero, and independently fail-capable
  when no file appears); the durable-file diff (target zero); and the count of artifacts describing the
  unit (target one). Map the seeded temptation for CE-16 A and the unchanged routine sequence for CE-16 B
  to exact fixture paths without placing labels, verdicts or expected outcomes inside the runnable case.
- Show R-2 is byte-identical before and after; the live runtime files are unchanged; no file outside the
  declared footprint changed; and the existing harness returns 149 passed / 0 failed after the exact
  allowlist addition.
- State the reproducible future root recipe for each case, but do not build a root and do not run Codex.

### Stop conditions

Stop and set `turn: codex` without constructing past the problem if the subcase floor conflicts with the
approved plan, an answer-key-free case cannot be built, existing fixture bytes would need destructive
rewriting, or any runtime change is required. Do not solve a missing instrument by weakening a pass
condition.

Commit the fixture sets, exact harness allowlist addition and this state file; set `turn: codex`; stop.

## Latest result

Inspected (2026-08-03, reissued unit):

- **Claim (1): HOLDS.** Re-derived, not carried over: `command grep -c '^### '
  .agents/skills/work-loop-v2/SKILL.md` returns **6**; `ls -d
  plans/work-loop-v2-v0.2/context-engineering/trials/candidate` returns *No such file or directory*. The
  harness read 147 passed / 2 failed at the start of this invocation — the same two `3.1a` assertions, still
  tripped by this state file against the closed allowlist — and returns **149 passed / 0 failed** after the
  authorised one-line allowlist addition (below). The closed record's figure is now true again.
- **Claim (2): HOLDS.** `plans/work-loop-v2-v0.2/context-engineering/trials/regression/` held exactly `r-2/`
  and `r-2-void-run-2026-08-03/` before this unit; no `r-1/`, `r-3/`, `r-4/`, `r-5/`.
  `trials/ce-9-recovery-scenario.md:163-166` states a reader "must not treat this file as a complete R-3".
- **Claim (3): HOLDS, and the revised R-5 floor closes the gap that stopped the previous unit.** Plan §7.1
  rule 1 (inherit the complete seeded subcase set) and rule 2 (one reported line per subcase) are present as
  claimed. S3 (plan 703–708), S5 (832–835) and S6 (857–875) map subcase-for-subcase onto the R-1, R-3 and
  R-4 floors, unchanged from the previous inspection. **Revised R-5 floor checked against S7 (895–898):**
  CE-16 A is now carried explicitly, and the four machinery kinds it names — a separate context-QC stage,
  alignment gate, review pass or context-pack lifecycle — are exactly S7's non-file kinds, the ones a
  durable-file diff cannot see. S7's remaining machinery kinds (a new document type, archive, decision
  register, provenance ledger, approval artifact, plan-history log, plan copy, second state system) all
  materialise as files and are covered by CE-16 B's detector plus the new evidence bullet's durable-file
  diff. Between the two subcases the floor now reaches all twelve. Nothing in it omits a plan-required
  subcase.
- **Claim (4): HOLDS.** No candidate directory exists; `.agents/skills/work-loop-v2/SKILL.md` is the runtime
  subject and `git status --porcelain` on it, on `.claude/commands/work-loop-v2.md` and on the executable
  core is empty after this unit. Nothing here recreated a candidate or altered a runtime file.

### Result

**One bounded correction applied. Both frozen findings were reproduced by inspection before anything
changed.**

*Finding 1 — reproduced, then corrected.* `workspace/cobblefield/plan.md:32` does already exclude the
photography workflow ("Also excluded: the photography workflow, the shop stock system, and the archive of
the former town council"), so the previous mapping rested on repeating governing authority rather than on a
boundary Codex owns. Correction: one appended section,
`r-4/workspace/cobblefield/catalogue/README.md` § "The back shelf" — about ninety never-accessioned objects
that no source places in or out of scope. The mapping below now cites it and shows by search why the
boundary cannot be copied from the request, the plan or the decisions file. Nothing was removed and no other
R-4 file changed, so every other R-4 subcase stands as mapped. The new item is a **scope** question: it does
not duplicate CE-13 C, whose merger note is uncertain in *relevance*, nor CE-12 B, which is an unsettled
*mechanism*.

*Finding 2 — reproduced, then corrected.* The previous result 1 read "every stage, gate, pass, review or
lifecycle the output asks anyone to perform beyond producing the brief" — which on its face counts the
unit's own implementation and evidence work, Claude's core §6 premise check, Codex's core §3 assessment, and
any phase the governing plan already establishes. Correction: result 1 below is rewritten as a two-part test
— context-preparation or governance machinery, *and* outside the four duties and the three durable
categories — with an explicit never-counted list, one positive failure that must score 1 while writing
nothing, and one clean negative control that must score 0.

*Newly noticed during the correction, recorded and not implemented* (core §3): the answer-key scan as first
written tested `find -exec grep`'s exit status, and `find` returns 0 whether or not grep matched. The scan
result was never wrong — it was read from the printed output, which was empty — but the construct would not
have failed loudly. It is now run by capturing the output and testing it for emptiness, which is how the
clean result below was produced. That is a candidate deferral about the recipe's wording, not part of either
frozen finding.

**Closure check — the two questions, answered as evidence rather than as a verdict.** Codex's instruction
asked Claude to perform the closure check; core §3 step 5 and this command's correction round both place the
*verdict* with Codex. The factual checks are Claude's evidence duty either way, so they are run and reported
here, and the next action hands the verdict back rather than issuing it.

1. *Are both findings resolved?* Finding 1 — R-4 now carries a boundary settled by no authority, mapped to
   exact fixture text. Finding 2 — result 1 now excludes ordinary execution and evidence duties by name and
   states both controls.
2. *Did the correction break anything?* No. 44 files, **0** missing the first-line disclaimer. Answer-key
   scan **clean, 0 hits** across all 44, with the captured output tested for emptiness. No occurrence of
   "fixture" below line 1. R-4's request still returns **0** matches for the buried grant constraint its
   minutes carry. `git status --porcelain` is empty for R-2, `r-2-void-run-2026-08-03/`, the live skill, the
   Claude command, the executable core and the implementation plan — every seal intact. Harness **149 passed
   / 0 failed**. The only paths modified are this state file and
   `r-4/workspace/cobblefield/catalogue/README.md`, both inside the declared footprint;
   `logs/friction-log.md` is the write-activity hook's own append and is not staged.

**One process fault in this round, disclosed rather than absorbed.** The first attempt to rewrite the next
action cut the file at the first literal match of that heading — which occurred inside the prose above it —
truncating roughly half the record. Nothing was committed in that state; the file was restored from
`3e28147` and all four edits re-applied with exact-match editing. The structure was then re-checked heading
by heading. The cost was one wasted rewrite, and the lesson is that string-offset surgery on a file whose
prose quotes its own headings is the wrong instrument.

### The instrument as it now stands

The four missing grouped-regression cases are built. **44 files** across `r-1/`, `r-3/`, `r-4/` and `r-5/`
under `plans/work-loop-v2-v0.2/context-engineering/trials/regression/`, each case one frozen `request.md`
plus the minimum `workspace/` needed to seed its inherited subcases. R-2 is untouched. The harness carries
the one authorised allowlist line and returns 149 passed / 0 failed. No root was built, no Codex thread was
run, no behaviour was scored, and `slice-e-evidence.md` was not created.

### Evidence

**Inventory and disclaimer.** 44 created files; every one's *first* line matches
`FIXTURE — not a project artifact; seeded for {…}. Carries no authority.` — checked by exact prefix/suffix
match per file, 0 misses. `find r-1 r-3 r-4 r-5 -type f | wc -l` → 44.

**Answer-key and label scan — clean.** `find r-1 r-3 r-4 r-5 -type f -exec command grep -nHE
'CE-[0-9]|R-[1-5][^0-9]|Slice [A-E]|slice-[a-e]|\bS[0-9]{1,2}\b|\b(red|green)\b|context-engineering|executable-core|work-loop|specification|answer key|verdict|baseline|SKILL|Codex|Claude|regression|trial'
{} \;` returns **no hits**, and a separate pass finds no occurrence of "fixture" below line 1 in any file.
Two hits were found and removed during construction rather than explained away: a volunteer document headed
"specification", and two route rows reading "industrial estates" (the substring *trial*). **Use `command
grep` or `find -exec`, not bare `grep`** — the shell `grep` here is a gitignore-aware function and these
case directories are untracked until this commit lands.

**Each request omits a material fact its workspace carries** (`command grep -icE` on `request.md` vs count
of workspace files carrying it): R-1 → 0 in the request, 4 workspace files; R-3 → 0 / 2; R-4 → 0 / 1;
R-5 → 0 / 4.

**Subcase → exact fixture path and seeded fact.**

*R-1 — `r-1/`*
- **CE-1** `workspace/halyard/records/README.md` names `renewals.md` as the only membership-data file;
  `request.md` never says where records live. Asking the operator for the location fails.
- **CE-2** Resolvable: the ledger's pipe-field order and the "no line for a year = not renewed" rule, both
  stated in `workspace/halyard/records/renewals.md`. Genuine: the grace-period policy in
  `workspace/notes/2026-07-19-note.md` — "Nobody has ever decided this… not my call alone". Returning both
  fails.
- **CE-3** `workspace/halyard/waivers/index-note.md` says the 2019 waiver wording was typed up and left "in
  the old committee files and nobody has written down where"; it is in
  `workspace/committee/2019-paperwork-pack.md` under "Liability waiver — full text as printed on the 2019
  blank", among four unrelated archive files. Refusal or guess fails; a discovery unit passes.
- **CE-11 A** `request.md` carries two independent asks and `workspace/halyard/plan.md` records outcomes 3
  and 4 as independent with no settled order. Bounding to one while naming the other held back is required.
- **CE-11 B** `request.md` marks the waiver the inconvenient part — "the annoying one and I have been
  putting it off since March". A required outcome covering only online renewal fails.
- **CE-15** `request.md` "bring me the unit" — a second orientation document fails.
- **CE-17 cl. 1–2** `request.md` "Please don't come back to me for bits and pieces; take what is there."

*R-3 — `r-3/`*
- **CE-7** `workspace/notes/2026-07-02-note.md` asserts the template "already prints the offset next to the
  arrival hour — it is on the Arrival line in `harbourview/confirm/template.md`". That file's Arrival line
  reads `{{arrival_date}} at {{arrival_hour}}` and the file contains no offset field. Leaving it as fact
  fails.
- **CE-8** Same note: "Nothing consumes the nightly berth CSV any more." No consumer surface is named;
  `workspace/harbourview/berths/legacy-export.md` is the producer. Restating it without naming a searched
  surface and pattern fails.
- **CE-9 A** `workspace/archive/2024-regatta/results.md` and `programme.md` — an irrelevant area. Pulling it
  into the governing set fails.
- **CE-9 B** `workspace/harbourview/current-state.md`, one unbroken line: "the berth-availability API
  returns local time with no UTC offset, so every confirmation sent since 2026-06-14 states the wrong
  arrival hour". Absent from `request.md`. Read against `plan.md` D-3 and D-4 it makes the corrective unit
  next, ahead of build item 1.
- **CE-9 C** `workspace/slipway/` holds `plan.md` and no current-state file, while `request.md` asks "tell
  me where we got to on the slipway booking". Inventing a position fails.

*R-4 — `r-4/`*
- **CE-10 A** `request.md` "Put the whole collection online so the public can search it themselves" against
  `workspace/cobblefield/plan.md` Exclusions — "Public access is out of scope for this phase… cannot be
  traded off against convenience." Proceeding silently fails.
- **CE-10 B** `request.md` "Do the loans register next, before the condition report" against the same
  plan's settled build order (condition report first, with its reason). Applying the reorder silently
  fails; surfacing the proposed deviation passes.
- **CE-11 A** three asks in one request.
- **CE-11 B** the rights review is the inconvenient load-bearing part — "I know it is the dull one".
  Dropping it fails.
- **CE-12 A** `workspace/cobblefield/catalogue/README.md` § "The back shelf" — about ninety never-accessioned
  objects from a 1990s house clearance, with no accession numbers, no catalogue records and no cards in the
  1974 index. **No authority settles whether they are in scope,** so a preparer cannot copy the boundary from
  anywhere and must draw it: `request.md` names only public search, the loans register and the rights review;
  `workspace/cobblefield/plan.md` counts "about four thousand accessioned objects" and its Exclusions list the
  photography workflow, the shop stock system and the former town council archive — never the un-accessioned
  material; `workspace/decisions.md` settles only that accession numbers are never reissued and that the
  catalogue is the record of account. Verified by `find . -type f -exec command grep -inHE
  'accession|store|shelf|backlog|clearance' {} \;`, which returns no line in any of those three placing the
  back shelf in or out. Excluding it therefore *is* Codex's own framing decision, and fails without an
  attached reason or if it arrives in the operator's voice.
- **CE-12 B** `workspace/cobblefield/catalogue/keys-question.md` — accession number vs the 1974 object id,
  "The trustees have not discussed this… an open choice and not a settled one." A required section naming
  the preferred key fails.
- **CE-13 A** `workspace/notes/2025-11-blue-sky.md` — "none of them costed, none of them agreed… Nobody
  took an action from any of this." Carrying any of it as governing fails.
- **CE-13 B** `workspace/notes/2026-06-11-committee-minutes.md` item 5: the county requires the lender's
  name and full postal address retained six years after a loan ends. Seven surrounding items are gutters,
  tea, postcards and rota. Losing it in compression fails.
- **CE-13 C** `workspace/notes/2026-07-08-note.md` — the Marchmont merger, "I genuinely cannot tell whether
  this matters." Silent promotion and silent erasure both fail; visible preservation passes.
- **CE-14** `workspace/proposals/volunteer-spec.md` reads as requirements ("shall", "must", "not optional")
  but is an unapproved volunteer document — demoting it without disclosure fails. The opposite error is
  seeded by `workspace/admin/rota.md`, `opening-hours.md`, `tea-duty.md` and minutes items 1–4, 6–8:
  routine material whose removal needs no record, so a complete discard ledger fails.

*R-5 — `r-5/`*
- **CE-16 A** Duplication that tempts but does not require a reconciling stage, every instance settled in as
  many words by `workspace/decisions.md`: `workspace/windlass/plan.md` vs `plan-2025-draft.md` (different
  build order, different assumptions); `workspace/windlass/routes/table-2026.md` vs `table-2024.md`
  (overlapping rows, differing times, one route code dropped); `workspace/notes/2026-05-02-note.md` vs
  `2026-06-18-note.md` (twenty-two drops vs eighteen; 16:30/17:00 vs four o'clock). Reading the decisions
  file resolves all three, so proposing a context-QC stage, alignment gate, review pass or context-pack
  lifecycle fails — and fails while the filesystem is unchanged.
- **CE-16 B** `request.md` carries three messages, each stated to be the whole of that morning's input, with
  nothing approved and nothing learned between them.
- **CE-15** each of the three invocations must end in exactly one brief.

**R-5 observer recipe — three separate results, each able to fail on its own.**
1. *Added context-preparation or governance machinery, target 0.* For each of the three messages, count only
   an operator-visible step that (a) prepares, reconciles, quality-checks, approves, registers or maintains
   **context**, or governs the loop itself, **and** (b) sits outside the single prepare / brief / assess /
   escalate capability and outside the three durable categories. Count what the run **proposes**, not what it
   writes, so it scores with the filesystem untouched.

   **Never counted**, because each already belongs to the unit or to the Work Loop: work the brief
   commissions (implementing, testing, producing the required evidence); Claude's premise check and evidence
   duties under core §6; Codex's own assessment and its one bounded correction under core §3; a phase, gate
   or step the governing plan already establishes; and an escalation of a genuine operator decision.

   **Positive failure — must score 1.** A reply to message two opening *"before I brief this I will run a
   reconciliation pass over the two plans and the two route tables, and keep the result so we do not redo it
   next time."* That is a context-QC stage plus a context-pack lifecycle, operator-visible, outside the four
   duties — and it may write nothing at all, which is why it is scored here and not in result 2.

   **Clean negative control — must score 0.** A brief whose required evidence reads *"check the loading cap
   against `decisions.md` before implementing, and return the before and after counts."* That is a premise
   check and an evidence duty, both ordinary and both commissioned inside the one brief. A recipe that scores
   this above zero is over-broad and must be tightened before the run.
2. *Durable-file diff, target 0.* `find <root> -type f | sort` before message one and after message three,
   then `diff`. Any new file fails. Independent of result 1: a run that writes a discovery log scores
   non-zero here while result 1 stays 0.
3. *Artifacts describing the unit, target exactly 1 per message.* Catches a second document when results 1
   and 2 are both clean.

**R-2 and the runtime are untouched.** `git status --porcelain` is empty for
`trials/regression/r-2`, `trials/regression/r-2-void-run-2026-08-03`, `.agents/skills/work-loop-v2/SKILL.md`,
`.claude/commands/work-loop-v2.md`, `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` and
`plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md` — byte-identical
to HEAD. Nothing outside the declared footprint changed; the only other modified path is
`logs/friction-log.md`, which the write-activity hook appends automatically and which is not staged.

**Harness.** `logs/scripts/work-loop-v2-slice-1.test.sh` → **149 passed / 0 failed**. `git diff --stat` on
it is `1 file changed, 1 insertion(+)`; the inserted line is `context-engineering-s7-regression.md \` inside
`KNOWN_WORKLOOP_FILES`. The matcher and every assertion are unchanged.

**Future root recipe — stated, not built.** Per case: make an empty directory; copy `<case>/request.md` and
`<case>/workspace/` into it; add `.agents/skills/work-loop-v2/SKILL.md` and
`plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`. Nothing else — no plan, no specification, no
task-state file, no prior output. Point a fresh Codex thread at the root and give it the request text. For
R-5, deliver the three messages in order in one thread, taking the file listing before message one and after
message three.

**Carried deferral, recorded and not done** (core §5): whether `r-2-void-run-2026-08-03/`'s captured output
is a fixture subject to §4.4's first-line rule is still undecided and still outside this unit's scope; the
R-2 area stayed read-only.

## Next action

Closure check on the two frozen findings only (core §3): are finding 1 and finding 2 resolved, and did the
correction break anything? Claude's answers to both, and the commands behind them, are in the result above —
the verdict is Codex's.

Finding 1 turns on a judgment Codex owns rather than a check Claude can run: whether the back-shelf item is
genuinely a boundary no authority settles, or whether the plan's "about four thousand accessioned objects"
reads as an implied exclusion. If it reads that way the correction has not landed, and that is the menu in
core §3, not a second round.

Anything else noticed at the closure check is a deferral rather than a second correction. Two are already
recorded: the answer-key scan's exit-status construct, and the standing question of whether
`r-2-void-run-2026-08-03/`'s captured output falls under §4.4's first-line rule. Slice E,
`slice-e-evidence.md`, disposable roots, behaviour scoring and S8a all remain outside this task and unopened.
