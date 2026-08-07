---
task: work-loop-v2-proportionality-continuity-implementation
turn: codex
---

## Objective and scope

Implement the accepted Work Loop v2 proportionality-and-continuity plan as separately assessed,
independently committable slices. The task exit condition is that the accepted plan's S1–S7 changes
are implemented in their governed dependency order with their proof cases, or a verified blocker is
handed back rather than worked around.

The current unit is **S5 only**: extend Work Loop v2's existing "Continue this project" routing
paragraph with the accepted project-orientation behavior from plan § 4.6 and prove it at one
representative continuation boundary.

Excluded are S6–S7; changes to S1–S4; changes to the executable core, Claude command, harness,
fixtures, dispatcher, hooks, AGENTS.md or another task file; a new section, stage, checklist,
orientation artifact, project-phase copy or state field; changes to `/project-next-steps`; broad
testing, installation, propagation, worktrees, branches, pushes and unrelated cleanup.

## Lane and unit

Standard. Implementation mode. Unit 5 — accepted plan slice S5: artifact-free project orientation.

Named reason for the loop: this changes the runtime instruction that decides how Codex locates a
project's next unit, and the result needs independent assessment before compaction work begins.

## Brief

This unit gives the operator a compact, durable-source-grounded position line when project context
actually changes. It follows accepted plan § 4.6 after S4 established the fresh-task boundary, and
it stays inside the existing routing preparation pass rather than creating a new stage or artifact.

**Required outcome.** Extend only the existing "Continue this project" paragraph in
`.agents/skills/work-loop-v2/SKILL.md`:

1. In one pass from durable sources, orientation establishes: owning project; approved outcome and
   current priority; authoritative current-state source; governing specialist workflow; active
   phase; completed phases and accepted decisions; blockers and operator gates; work ready now; and
   work premature or unauthorised.
2. It returns one line in exactly this shape:
   `Current position → governing workflow and phase → what is ready → what is blocked → recommended next unit → why it matters.`
3. It fires only at four boundaries: a Continue acceptance opening the next unit; a fresh task
   picking up existing work; post-compaction reorientation; or a material context change caused by
   a new operator decision, approval or verified evidence. Routine invocations do not re-orient.
4. It stays inside the single preparation pass and writes nothing. It creates no orientation file,
   phase copy or state entry.
5. It borrows only `/project-next-steps` Step 2's read-cascade approach—plan spine, authoritative
   position, then only material next-step evidence, stopping once position is certain. The two
   capabilities do not call or merge with each other.
6. It uses the project's own phase vocabulary. Where no phase model exists, the paragraph's
   existing fallback spine remains unchanged.

Keep core-owned mechanics by pointer and do not restate S1–S4 behavior.

**Governing sources.** This state file; accepted plan § 4.6, S5 and P-9 in
`plans/work-loop-v2-v0.2/work-loop-v2-proportionality-continuity-implementation-plan-v0.1.md`;
`.agents/skills/work-loop-v2/SKILL.md`; executable core § 3; read-only
`.claude/commands/project-next-steps.md` Step 2 for the cascade approach; authoritative current state
for the representative project used in P-9.

**Allowed paths.**

- `.agents/skills/work-loop-v2/SKILL.md`
- `logs/work-loop/work-loop-v2-proportionality-continuity-implementation.md`

Nothing else may be changed or committed. Re-read the skill immediately before editing. The
project-progression correction task's current close verdict confines it to its own state file; the
escaped-descendant task is back at `turn: codex` and excludes Work Loop skill changes. Stop on any
actual overlap rather than merging silently.

**Claims to check before acting.**

1. This checkout is exactly
   `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`; settle with `pwd -P`.
2. This state file's identity matches its filename and its incoming turn is `claude`.
3. The existing "Continue this project" paragraph contains the fallback spine and prohibition on a
   maintained phase mapping, but not the nine determinations, six-part line or four boundaries;
   settle by reading that paragraph immediately before editing.
4. `/project-next-steps` Step 2 supplies the accepted cascade approach and remains read-only.
5. No current writer owns this unit's two allowed paths; settle from current non-fixture state files
   and target freshness, not the plan's snapshot.

**Required evidence.**

- Report the five claims above and the exact changed paths.
- For the prose change, quote the old and new relevant text plus one line on why an English
  orientation rule has no meaningful automated regression test.
- Run P-9 once at a representative real continuation boundary using a project with durable sources
  and its own phase vocabulary. The output must be one six-part orientation line, use that project's
  vocabulary, and recommend the next unit from its governing workflow/current state rather than
  memory.
- Record the before/after repository observation showing the orientation run created no file and
  changed nothing beyond the already-authorised state-file evidence. Do not create a capture,
  fixture, orientation file or second state artifact.
- Check that the existing fallback spine and S1–S4 anchors remain intact. Report pre-existing
  unrelated failures without repairing or rerunning a broad suite.

**Completion condition.** The existing paragraph carries all accepted § 4.6 behavior without a new
stage or artifact; representative P-9 yields the six-part line in project-native vocabulary and no
new file; only the allowed paths are committed by Claude; `turn:` returns to `codex`.

**Stop conditions.** Stop and hand back on wrong checkout, invalid state identity/turn, target
overlap, a false premise, need to change `/project-next-steps`, or need for any excluded artifact or
path. Do not improvise around a project whose durable sources cannot establish its phase and next
unit; choose a suitable representative project or report the evidence gap.

## Latest result

Inspected (2026-08-07):

- Claim (1): HOLDS — ran `pwd -P` from the repository root; returned
  `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`, exactly the briefed checkout.
- Claim (2): HOLDS — read this file's frontmatter before anything else; `task:` reads
  `work-loop-v2-proportionality-continuity-implementation`, matching the filename, and `turn:` read
  `claude`.
- Claim (3): HOLDS in both halves — read the "Continue this project" paragraph
  (`.agents/skills/work-loop-v2/SKILL.md` line 174) immediately before editing. Present: the fallback
  spine ("frame the need → resolve blocking uncertainty → … → adopt, revise or stop") and the
  prohibition "never create a document, list or state entry to hold the mapping". Absent: searched the
  whole of `SKILL.md` for `Current position`, `governing workflow and phase` and `why it matters` — no
  match, so no six-part line existed; searched it for `boundaries|post-compaction|orientation` — the
  only matches were lines 199 and 201 about the capability index, so neither the four firing
  boundaries nor the nine determinations were present.
- Claim (4): HOLDS — read `.claude/commands/project-next-steps.md` Step 2 (lines 46–86). It carries
  the cascade: plan spine → current position (authoritative completion signal first, "stop when
  confident") → supporting context read lightly → git ground-truth check. Its read-only status is
  stated three times (lines 17, 50–52, 129–131), including "Never write or edit **any** file,
  anywhere".
- Claim (5): HOLDS — checked all 27 non-fixture state files' `turn:` plus `git status`. Three other
  files are not at `turn: operator`: `project-progression-candidate-review-correction.md` (`claude`,
  `## Next action` opens `Close the task:` — confined to its own state file);
  `work-loop-v2-escaped-descendant-termination.md` (`claude`, final bounded fix, and its scope line 19
  excludes "Work Loop core, skill or rule changes"); `work-loop-v2-intake-router.md` (`codex`, whose
  `## Next action` says "commit only this state file by explicit pathspec"). `SKILL.md` was clean in
  `git status` before this unit's edit. No current writer owns either allowed path.

Result: S5 implemented. The existing "Continue this project" paragraph in
`.agents/skills/work-loop-v2/SKILL.md` (line 174) now carries all accepted § 4.6 behaviour — the nine
determinations, the six-part operator line, the four firing boundaries, the writes-nothing constraint
and the borrow-not-merge relation to `/project-next-steps`. No section, stage, artifact or state field
was added: the file is 429 lines before and after, because the extension is prose inside the one
existing paragraph.

Evidence:

- **Old text (tail of the paragraph, quoted):** "Only where a project has no phase model at all,
  orient with this fallback spine, as a diagnostic and nothing more: frame the need → … → adopt,
  revise or stop. It creates no states to traverse, no artifacts, and no exit conditions of its own."
  That sentence is unchanged and still ends the pre-existing text; the extension is appended after it.
  **New text (appended):** "Orientation is that judgment made explicit, inside the same single
  preparation pass and from durable sources only. It establishes nine things: the owning project; its
  approved outcome and current priority; the authoritative current-state source; the governing
  specialist workflow; the active phase; the completed phases and accepted decisions; the blockers and
  operator gates; the work ready now; and the work that is premature or unauthorised. Reach them the
  way `/project-next-steps` Step 2 reaches its own position — plan spine first, then the authoritative
  position source, then only what bears on the next step, stopping as soon as position is certain.
  Borrow that read cascade *approach* and nothing else … Return one line to the operator, in exactly
  this shape — `Current position → governing workflow and phase → what is ready → what is blocked →
  recommended next unit → why it matters.` — written in the project's own phase vocabulary, never
  renamed. Orient at four boundaries and no others: a Continue acceptance opening the next unit (core
  § 3 *Continuing*); a fresh task picking up existing work (§ The seam); a post-compaction
  reorientation; and a material context change … A routine invocation is precisely one where none of
  those changed, and a routine invocation does not re-orient. Orientation writes nothing …"
  **Why no automated regression check:** the change is an English instruction to a model. Any check
  would have to grep for wording the brief itself supplied, which cannot fail, so the changed text
  quoted against what it replaced is the evidence.
- **P-9, run once at a real continuation boundary.** Representative project: `axcion-design-studio`
  (own phase vocabulary, durable sources present). Cascade run in the § 4.6 order — plan spine
  (`pipeline/project-plan.md`), authoritative position (`pipeline/pipeline-state.md`, latest
  `logs/session-notes.md` entry 2026-07-23), then only material next-step evidence
  (`logs/next-up.md`), stopping there. Output line:

  `Phase 1 homepage build, two of four content sections approved and the FREEZE fixes F1–F5 landed → the lean section loop (CLAUDE.md § Section Design Sessions + /explore-section), with the 4-critic chain tier reserved for whole-surface departures → the copy-drift reconciliation named in next-up.md is unblocked and ready → the next section (CTASection/Footer) and the two PROPOSED-with-departure sections are blocked behind that reconciliation, the 20_criteria/section-design-principles.md DRAFT sits behind an unfired CP-1 operator gate, and the Phase 2 deck-system archetype build is parked pending a website-derived slide language → next unit: reconcile the copy drift (figma-build-brief.md §1/§2/§5 + §0 log, sections/_status.md, supersede why-it-works.md, place or reconcile the orphaned third red moment, reopen brief §9 Decision 6) → it is the named hard prerequisite before any further section, and the APPROVED why-it-works.md direction currently has no copy behind it.`

  Six parts, in the project's own vocabulary (Phase 1, lean section loop, chain tier, FREEZE, red
  moment, PROPOSED-with-departure, deck-system) — nothing renamed. **Memory-only control:** the line
  turns on facts held only in the durable sources and absent from this session's conversation — the
  F1–F5 freeze fixes, the orphaned third red moment, brief §9 Decision 6, and the 2026-07-23 operator
  decision to derive the slide language from the finished website. An answer written from memory could
  not have produced them.
- **P-9's no-file half.** `git status` in `projects/axcion-design-studio` shows only pre-existing
  modifications and untracked section-design files. The fail-capable observation:
  `find projects/axcion-design-studio -type f -newermt '2026-08-07T20:20:00'` returns nothing, while
  the same command over `ai-resources` returns `SKILL.md` — so the check demonstrably detects a write
  and detected none from the orientation run. (An earlier `-newermt '-15 minutes'` form was rejected by
  `bfs` and its empty output proved nothing; it was rerun with an absolute timestamp.)
- **Anchors intact.** `SKILL.md` still holds one `fallback spine`; the S1 description (line 3) and
  core-read sequencing "before your first Work-Loop-owned move" (line 162); the S4 seam at line 20 with
  "The checkout a task lives in, and starting a new one" and its isolation table; and
  `## Assessing the result` (line 368). Line count 429 before and after.
- **Pre-existing unrelated movement, not repaired and not rerun.**
  `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` and `dispatch.test.sh` were modified
  by another writer during this unit (they changed between two `git status` calls). They belong to the
  escaped-descendant task, are outside this unit's allowed paths, and were neither touched nor staged.

Deferral noticed during this unit, recorded and not implemented: the "Continue this project" paragraph
is now very long for a single prose block, and § 4.6's "extend the paragraph, do not add a section"
constraint is what keeps it that way. Whether it should later be split into two paragraphs under the
same lead is a readability question for a separate unit, not this one.

Accepted limitations carried forward from S4, unchanged: the remaining skill-fetch ordering, accepted
as a written limitation at the Codex menu; and P-4 unexecuted, because its real-worktree construction
conflicts with the operator's Local-only instruction, so the checkout-binding instruction shipped
without its wrong-checkout behavioural proof.

Deferrals carried forward, none implemented:

1. An ordinary unnamed request still activates Work Loop v1; outside this plan's targets.
2. The Work Loop v2 skill's 340-line harness ceiling is stale/red and exceeded; it needs a separate
   rebase-versus-trim decision.
3. P-4 may be run in a future explicitly authorised isolated checkout; it is not required in this
   Local-only task.

## Blocker

None for S5.

## Next action

Codex: assess S5. Judge whether the extended paragraph carries all of § 4.6 without a new stage or
artifact, whether the P-9 line is genuinely six-part and project-native rather than restated plan
vocabulary, and whether the memory-only control and the mtime-based no-file check are strong enough
for the consequence. Two things warrant your judgment specifically. First, the paragraph is now long,
and the recorded deferral asks whether readability should later be handled in its own unit — decide
whether that is a deferral or a finding. Second, another writer moved `dispatch.sh` and
`dispatch.test.sh` mid-unit; nothing of mine touched them, but it is a live-concurrency observation
that bears on S7's S0 gate. Then continue to S6 or close.
