---
task: work-loop-v2-proportionality-continuity-implementation
turn: codex
---

## Objective and scope

Implement the accepted Work Loop v2 proportionality-and-continuity plan as separately assessed,
independently committable slices. The task exit condition is that the accepted plan's S1–S7 changes
are implemented in their governed dependency order with their proof cases, or a verified blocker is
handed back rather than worked around.

The current unit is **S2 only**: make the accepted proportionality standard enforceable in core § 3.
Excluded from this unit are S3–S7, every file other than
`plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` and this state file, changes to S1,
installation or propagation, worktrees, branches, pushes, and adjacent cleanup.

## Lane and unit

Standard. Implementation mode. Unit 2 — accepted plan slice S2: the core § 3 proportionality clause.

Named reason for the loop: the accepted task spans several independently assessed slices and
sessions, and this unit changes the semantic contract that both actors use to decide when work is
good enough; its placement and non-duplication evidence must be assessed independently before S3.

## Brief

S1 is accepted, so S2 is now the smallest justified unit in the accepted sequence. It gives later
assessment and verification changes one authoritative proportionality standard to cite without
copying the rule across runtimes. Implement only S2 and return its fail-capable evidence to Codex.

### Governing sources and current-state dispositions

- The operator's current instruction, “continue into S2,” governs the next-unit choice.
- `logs/work-loop/work-loop-v2-proportionality-continuity-plan.md` is the content-bound acceptance
  record. It is closed at `turn: operator`, identifies the accepted implementation plan and its
  correction commits, and establishes approval without becoming an implementation target.
- `plans/work-loop-v2-v0.2/work-loop-v2-proportionality-continuity-implementation-plan-v0.1.md`
  governs this unit: § 4.3, § 5 S2, § 6 P-2a, § 7 and § 9.
- `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` is both the higher Work Loop contract
  and S2's sole implementation target. Its whole-document header remains “draft for operator
  approval”; only the proportionality clause was separately approved through the closed plan.
- `.agents/skills/work-loop-v2/SKILL.md` and `.claude/commands/work-loop-v2.md` are read-only controls.
  They may point to core § 3, but must not restate S2's four statements.
- Current in-flight state was re-read before this Continue. The two other tasks at `turn: claude`
  (`project-progression-candidate-review-correction` and
  `work-loop-v2-escaped-descendant-termination`) explicitly exclude the executable core from their
  writes; the older `work-loop-v2-intake-router` and `work-loop-v2-production-readiness-policy`
  tasks are at `turn: codex`. These are time-sensitive verify-first claims: re-read their current
  scope and turn immediately before editing, and stop if a writer now owns the core.

### Required outcome

Extend core § 3, under **The “good enough, proceed” judgment**, with exactly the four approved
statements from plan § 4.3:

1. The target is a useful **85–90% result**. Absolute completeness is not the bar and is not a reason
   to continue a unit.
2. A unit does the **minimum necessary work** its completion condition requires. An improvement not
   needed for that condition is a deferral under core § 5, not part of the unit.
3. **Evidence is scaled to consequence.** It must be able to fail under core § 6 rule 5, but need not
   be exhaustive; a larger check than the consequence warrants is ceremony.
4. **There is no perfection pass.** The one correction round is frozen to the assessment's named
   findings, and nothing else reopens the unit.

Follow the core's courier-clause precedent: add a dated note stating that this proportionality
clause was approved on its own and that the document's draft header is deliberately unchanged. Do
not promote the whole core. Keep these four statements owned by core § 3; do not restate them in the
Codex skill or Claude command.

### Check against the repository before acting

1. Verify `pwd -P` is exactly
   `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`. A mismatch stops; never copy
   this state file between checkouts.
2. Validate this state file read-only against core § 4: filename/task identity, `turn: claude`, exact
   active headings and one-task/one-file location.
3. Open the current core. Verify its header still says “draft for operator approval”; § 3's current
   “good enough” paragraph still stops at pilot quality with limitations; and it contains no
   85–90% target or equivalent four-part proportionality clause.
4. Open core § 4's courier amendment note and verify it is still the applicable shape for a
   separately approved clause whose whole document remains draft.
5. Search only `.agents/skills/work-loop-v2/SKILL.md` and
   `.claude/commands/work-loop-v2.md` for the 85–90% target, minimum-necessary-work rule,
   consequence-scaled evidence rule and no-perfection-pass rule. Verify neither control already
   restates the four statements; a pointer or a general “good enough” phrase is not a restatement.
6. Re-read the current turns, scopes and next actions of the four in-flight tasks named above.
   Confirm no other actor is now authorized to edit the core and no live unattended dispatcher owns
   this task.
7. Check the core for overlapping uncommitted work before editing. Do not overwrite, absorb or
   reframe another task's change.
8. Confirm S2 can be completed by changing the core and this state file only. If another target is
   required, hand back the conflict.

### Required evidence

- One inspection line for every claim above, including those that hold.
- P-2a's red witness: before the amendment, core § 3 has no 85–90% target, so a demand for absolute
  completeness cannot be rejected by citing the contract. Show the observed pre-change text, not a
  grep of this brief.
- P-2a's green witness: quote the resulting § 3 clause and separately show all four approved
  statements are present under the existing “good enough” owner.
- The bidirectional no-duplication control: show that the Codex skill and Claude command do not
  restate the four statements after the change. A second copy is a failure, not extra diligence.
- Show that the document header remains draft and the dated separate-approval note is present,
  following rather than rewriting the courier-note precedent.
- Confirm the rest of the core is unchanged in substance and that no S3–S7 target or unrelated state
  file was changed.
- This is a contract-text change. Do not invent a broad suite or ceremonial test; the fail-capable
  proof is the before/after owner check plus the two read-only duplication controls.

Completion: implement only S2, record the inspections and evidence under `## Latest result`, set
`turn: codex`, and commit only
`plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` and this state file by explicit
pathspec. Do not begin S3 or assess your own result.

Stop and hand back if the checkout mismatches; this state file is malformed or stale; a governing
premise is false; another writer now owns or has modified the core; the four statements already
have another owner; an S2 requirement needs an excluded file; or an operator-owned decision about
scope, authority or risk is required.

## Latest result

Inspected (2026-08-07):

- **Claim (1): HOLDS** — `pwd -P` returned exactly
  `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`.
- **Claim (2): HOLDS** — frontmatter `task:` matches the filename, `turn:` was `claude`, the active
  headings are core § 4's exact five plus `## Brief`, and this is the only file for the task.
- **Claim (3): HOLDS, all three parts.** Header line 3 reads "**Version:** v0.1 (MVP). **Status:**
  draft for operator approval." § 3's "good enough" section stopped at exactly three lines, quoted
  below as the red witness. Searching the whole core for `85`, `90%`, `minimum necessary`,
  `scaled to consequence` and `perfection pass` returned **no match** — no target, no equivalent
  four-part clause.
- **Claim (4): HOLDS** — core § 4's courier note is at lines 264–266 and is exactly the shape S2
  needs: a dated blockquote saying the clause was approved on its own, the header still reads draft,
  and the amendment is not approval of the rest of the file.
- **Claim (5): HOLDS** — the same five-term search over `.agents/skills/work-loop-v2/SKILL.md` and
  `.claude/commands/work-loop-v2.md` returned no match in either. What the skill does carry, at line
  335, is a **pointer** — "apply core § 3: the 'good enough, proceed' judgment … are defined there" —
  which the brief expressly distinguishes from a restatement. The command file mentions the judgment
  at all.
- **Claim (6): HOLDS on the load-bearing part; the enumeration moved again, and is reported rather
  than adapted.** `work-loop-v2-escaped-descendant-termination` is no longer at `turn: claude` — it
  handed back and is now `turn: codex`, and its dispatcher work is committed. Current `turn: claude`
  tasks are this one and `project-progression-candidate-review-correction` (constrained by its close
  verdict to its own state file). `work-loop-v2-intake-router` and
  `work-loop-v2-production-readiness-policy` are at `turn: codex`. **None claims the executable
  core**, so no other actor is authorised to edit it. **A dispatcher process is running and it is not
  this task's:** pid 70615 is a `dispatch.test.sh` harness run bound to a temporary checkout under
  `/var/folders/…/wl2-dispatch-test.…` with `--task commit-ok` and `--actor-cmd`. It is a simulated
  test actor in a throwaway checkout, not a live unattended run over this repository or this task.
- **Claim (7): HOLDS** — `git status --porcelain` on the core was empty before the edit; it stood at
  commit `285714c`. No overlapping uncommitted work to absorb or overwrite.
- **Claim (8): HOLDS** — S2 was completed by changing the core and this state file only. No other
  target was required.

Result: the four-statement proportionality clause and its separate-approval note are in core § 3.
Nothing else changed.

**P-2a red witness — the observed pre-change text, not a grep of the brief.** Before the amendment,
`### The "good enough, proceed" judgment` was three lines in full:

> "At assessment, Codex's job is the executive call — *is this good enough to move on?* — not finding
> more things to improve. The quality bar is pilot quality with limitations written down, not
> completeness."

That is the whole section. "Pilot quality with limitations written down" is a direction, not a
threshold: an assessment demanding absolute completeness could not be refused by citing the contract,
because the contract named no number and no rule against re-opening a unit. The five-term search over
the whole core returning no match is the second half of the same witness — the clause was absent from
the document, not merely from this section.

**P-2a green witness — the resulting clause, and the four statements located under the existing
owner.** The section now continues:

> "Four statements make that bar checkable rather than a matter of taste:
> - **The target is a useful 85–90% result.** Absolute completeness is not the bar, and it is not a
>   reason to continue a unit.
> - **Minimum necessary work.** A unit does only what its completion condition requires. Work that
>   would improve the result without being needed to satisfy that condition is a deferral (§ 5), not
>   part of the unit.
> - **Evidence is scaled to consequence.** The evidence must be able to fail (§ 6 rule 5); it is not
>   required to be exhaustive. A larger check than the consequence warrants is ceremony.
> - **There is no perfection pass.** A correction round exists (*Correcting once* below) and is frozen
>   to the assessment's named findings. Nothing else re-opens a unit.
>
> These four are owned here. The Codex skill and the Claude command cite this section; neither
> restates them."

Located, not just present: the four statements are at core lines 150, 152, 155 and 157, and the
nearest preceding heading to all four is `### The "good enough, proceed" judgment` — the existing
owner § 4.3 names. No new section, no new field, no new heading was created.

**Bidirectional no-duplication control — run after the change, not before.** The same five-term
search over both read-only controls still returns **no match in either**. The skill's line-335
pointer is unchanged and remains a pointer. So the rule exists in exactly one place, which is what
P-2a fails in both directions: an absent statement fails it, and a second copy fails it equally.

**Header and precedent.** Line 3 still reads "**Status:** draft for operator approval" — unchanged.
The new note at line 163 follows the courier note at line 283 word for word, differing only in the
date: "*Added 2026-08-07. This clause was approved on its own; the document's header still reads
**draft for operator approval** and that is deliberately unchanged. Do not read this amendment as
approval of the rest of the file.*" The precedent was followed, not rewritten, and the document was
not promoted.

**The rest of the core is unchanged in substance, shown rather than asserted.** `git diff --stat` on
the core reports **19 insertions and 0 deletions**. A pure addition cannot have altered surrounding
text, so no other clause moved, weakened or lost meaning.

**No ceremonial test was invented.** This is a contract-text change; no automated check could
distinguish a correct clause from a wrong one. The fail-capable proof is the before/after owner check
plus the two read-only duplication controls, exactly as the brief scoped it.

**Files changed:** `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` and this state file.
No S3–S7 target and no unrelated state file was changed.

**Deferrals carried forward, neither implemented.**

1. From S1: the ordinary unnamed request still activates **Work Loop v1** (`.agents/skills/work-loop/`),
   even though Work Loop v2 correctly stays inactive. Outside this plan's targets; a separate decision.
2. Noticed in this unit: `.claude/commands/work-loop-v2.md` mentions the "good enough" judgment
   **nowhere at all**, so it has no pointer to cite the new clause from. § 4.3 says both controls
   "cite this section"; the skill does, the command does not. Adding that pointer is plausibly S3's
   business — S3 owns the command file — and it is not done here, because S2's scope is the core and
   this state file only.

## Blocker

None.

## Next action

Codex: assess S2. The clause is in the owner § 4.3 names, the header is untouched, the dated note
follows the courier precedent, and both controls remain free of any restatement. One judgment is
yours: whether the missing "good enough" pointer in `.claude/commands/work-loop-v2.md` belongs to S3
as recorded, or whether it should be reframed. Then close, continue to S3, or correct once.
