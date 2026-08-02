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

**The bounded correction ran. Both frozen findings reproduced, and both are resolved.** Nothing outside
findings 1–2 was changed.

**Reproduced first, by inspection:**

- **Finding 1 reproduces.** Searched both fixtures for their scoping lines. `project-plan.md:5` read
  *"Fictional project. Nothing in this file describes Axcíon work, and no statement in it governs
  anything."* — an unscoped denial, and the discriminator is material only if that file's SD-3 governs
  Harbourview. `task-state.md:5` read *"Fictional project. This file is seeded trial material, not a live
  task-state file."* — the same tension against its role as the simulated authoritative current state. The
  source-opened thread gets the three fixture paths and not the scenario file, so it could read either
  denial correctly and refuse the authority relationship the measurement depends on.
- **Finding 2 reproduces, and is worse than a weak check — it is a check that cannot speak.**
  `git diff --quiet HEAD -- <path>` compares the working tree to HEAD, so after any commit it reports a
  clean tree and nothing else. Demonstrated against real history: the specification **was** changed by
  commit `a718a17`, and the S1-style check still passes when run at that commit, because the change is
  committed. A run that had modified and committed all five protected files would have produced the
  identical "UNCHANGED" line for each.

### Finding 1 — corrected

Both role-playing fixtures now state the two levels separately, and the scenario says the same thing in
§2 so the operator's reference and the fixtures cannot drift apart.

**Evidence.**

1. **The required first line is preserved in all five files**, unchanged and still first:
   `FIXTURE — not a project artifact; seeded for CE-9. Carries no authority.` — verified by `head -1` over
   `git ls-files` on the `trials/` tree; five files, five identical first lines.
2. **The old unscoped denials are absent.** `grep -rn "no statement in it governs anything" trials/` →
   exit **1**. `grep -rnF "*Fictional project. This file is seeded trial material, not a live
   task-state file.*" trials/` → exit **1**.
3. **The two trial-internal role statements, quoted for the closure check** — each a single bolded
   sentence, `project-plan.md:9` and `task-state.md:9`:
   - *"**Inside the CE-9 scenario, this file is Harbourview's governing plan: its phases and settled
     decisions govern that fictional project, and a thread preparing a brief for it should treat them as
     governing.**"*
   - *"**Inside the CE-9 scenario, this file is Harbourview's authoritative current state: its phase,
     latest material result and blocker are authoritative for that fictional project, and a thread
     preparing a brief for it should treat them as such.**"*
   Each sits directly beneath a restated real-world denial — no authority over any real Axcíon work,
   nothing to act on in the repository — and each is followed by one sentence saying why a blanket denial
   would break the measurement.
4. **The correction did not break the instrument.** Both discriminator greps re-run: presence exit **0**,
   absence exit **1**.

`operator-source-note.md` and `operator-request.md` were deliberately left alone. Finding 1 names the two
role-playing files, and the source note's *"nothing here is a decision or a requirement"* is correct at
both levels — spec §5.7 category 1 material carries no authority inside a real project either, so scoping
it would have been a change the finding did not ask for.

### Finding 2 — corrected

**Baseline:** `a718a1733fd6ccc325c8453a9f50748add15d476` — HEAD at unit open, the Phase 0 commit.
**Endpoint:** the working tree that becomes this correction commit. The S1 range at the time of writing is
`a718a17..HEAD`, containing one commit, `26b6bfe`, plus this uncommitted correction.

**Every changed path, baseline → endpoint.** Six paths, all S1's:

```
logs/work-loop/context-engineering-implementation.md     (this state file)
plans/…/context-engineering/trials/ce-9-recovery-scenario.md
plans/…/context-engineering/trials/fixtures/ce-9/operator-request.md
plans/…/context-engineering/trials/fixtures/ce-9/operator-source-note.md
plans/…/context-engineering/trials/fixtures/ce-9/project-plan.md
plans/…/context-engineering/trials/fixtures/ce-9/task-state.md
```

Separately, and **not S1's**: `logs/friction-log.md` is modified and
`logs/runs/2026-08-02-S5-8ee.json`, `logs/runs/2026-08-02-S6-6d7.json`,
`logs/session-plan-2026-08-02-S6-6d7.md` are untracked. All four pre-date this unit, none is staged, and
none appears in `a718a17..HEAD`.

**The scope check, and it is now range-based rather than tree-based:**

```
git diff --name-only a718a17 -- \
  plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md \
  .claude/commands/work-loop-v2.md \
  .agents/skills/work-loop-v2/SKILL.md \
  plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md \
  plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md
```

Returns **nothing**. Because the left side is a commit and the right side is the working tree, it covers
committed and uncommitted change together — a committed edit to any of the five would appear.

**The fail-capable comparison.** The identical command over `3845e54..a718a17`, a range where Phase 0 did
edit a protected file, returns `plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md`. So the empty
result above is a finding, not a command that cannot produce output.

**One more hole closed, because the first attempt at this evidence was itself invalid.** The scope check
and its fail-capable twin were first run with the five paths held in a shell variable and passed unquoted.
Under zsh an unquoted parameter is not word-split, so git received one nonsense pathspec matching nothing —
and *both* commands returned empty. The scope check looked like a pass. The fail-capable comparison is
what exposed it: it must return a path and did not. The commands above list the paths literally, and
`git ls-files --error-unmatch` over the same five confirms git recognises every one as a tracked path, so
"empty" can no longer mean "matched nothing".

**No candidate file, in the tree or in history.**
`ls -d trials/candidate` → *No such file or directory*.
`git log --all --diff-filter=A -- 'plans/…/trials/candidate/*'` → no output; it was never added on any
branch.

Result: **findings 1 and 2 are resolved; S1's instrument is unchanged in what it measures.** The
discriminator, the blind-control design, the delimited request surface and both discriminator greps are
exactly as assessed — the correction changed how the fixtures declare their authority, and replaced a
scope check that could not detect committed drift with one that can and that has been shown failing.

Evidence: the four numbered items under finding 1 and the six under finding 2, all reproducible from the
repository root. The two operator-observer greps are unaffected and still return exit 0 and exit 1; they
remain written out with full paths in `trials/ce-9-recovery-scenario.md` §5.

**Newly noticed during the correction, recorded as a deferral and not implemented** (core §3): the
scope-check command belongs in the scenario file beside the two discriminator greps, so a later session
re-verifies scope the same way instead of re-deriving it. It is not in the frozen scope, so it was not
added.

## Next action

Codex: run the closure check on the frozen findings only — are findings 1 and 2 resolved, and did the
correction break anything? Everything needed is above; the two role statements are quoted verbatim for
finding 1, and finding 2's commands are reproducible from the repository root.

Carried forward, none of them actioned and none of them in the correction scope:

1. **Deferral — the implementation plan's header contradicts the repository.** It asserts O-1 is
   outstanding and that S1 cannot open; `a718a17` answered O-1 and the condition is met. A plan edit, so
   outside S1.
2. **Deferral — F-10's stated line count is stale**, 913 against a live 928. Not load-bearing: the
   17-behaviour half of F-10 was re-derived and holds.
3. **Deferral — the scope-check command is not yet recorded in the scenario file.** Noticed during this
   correction, described above.
