---
task: develop-ai-resource-retirement-verdict
turn: codex
---

## Objective and scope

Give an existing durable AI artifact a real retirement path inside `/develop-ai-resource`, so
retirement cannot be declared while references or machinery remain and the removal is not recorded.

Scope: `.claude/commands/develop-ai-resource.md`; one minimal corresponding change in
`docs/ai-resource-creation.md` only if the command would otherwise remain undiscoverable or conflict
with that policy; and this state file. Excluded: retiring any actual resource, adding a command,
register, lifecycle store, gate or artifact; operating-capability retirement; non-AI repository
feature retirement; the v1 capability method and template; and any Unit 4 disposition.

## Lane and unit

Standard. Implementation mode. Unit 3 — give `retire` an owner for durable AI artifacts only.

Named reason for the loop: this changes a shared governing command and introduces a destructive
lifecycle verdict. A wording-only patch could appear complete while still allowing the exact
dangling-route failure that triggered the unit, so the result needs bounded implementation,
fail-capable replay evidence and independent Codex assessment.

Plan justification: the operator approved the corrected plan content committed at `6af280e` and has
explicitly started Unit 3. Unit 1, the only prerequisite named by the plan, is formally closed at
`logs/work-loop/develop-ai-resource-v2-capability-seam.md`; Unit 2's implementation has been accepted
but its closing-record write remains procedural debt and is not a Unit 3 prerequisite. Governing
unit: `plans/work-loop-v2-v0.2/resource-capability-development-plan-v0.1.md` § 7, Unit 3.

## Brief

Why this unit, why now: the approved plan identifies one narrow lifecycle gap—durable AI artifacts
can be created and improved through `/develop-ai-resource`, but an artifact already in service has no
owner for retirement. The 2026-08-06 `/work-loop` v1 removal is the concrete failure: the command was
deleted while live routes remained. This unit adds only the missing ownership and evidence standard;
it does not retire anything or generalize the answer to other object classes.

### Governing and applicable sources

- Current operator instruction to start Unit 3 — governing authorization for this unit.
- `logs/work-loop/work-loop-v2-resource-capability-plan.md` — content-bound approval record for plan
  commit `6af280e`; its earlier statement that Units 1–4 were not yet authorized is superseded for
  Unit 3 by the current operator instruction, and for nothing else.
- `plans/work-loop-v2-v0.2/resource-capability-development-plan-v0.1.md` § 7, Unit 3 — governing
  outcome, boundary, exclusions and evidence standard.
- `logs/work-loop/develop-ai-resource-v2-capability-seam.md` — authoritative closed prerequisite.
- `.claude/commands/develop-ai-resource.md` — implementation target and current authority for durable
  AI-resource qualification, building, verification and disposition.
- `docs/ai-resource-creation.md` — current policy for AI-resource creation and improvement; edit only
  if needed for truthful retirement discoverability or authority.
- `skills/capability-development/SKILL.md` and `templates/capability-record.md` — read-only adjacent
  sources for the existing operating-capability retirement standard. Borrow the useful principle;
  do not claim this command owns operating capabilities or edit those sources.
- `logs/improvement-log.md` entry beginning at current line 2823 and the repository evidence for
  commit `0516bf6` — the real failure case to replay, not authority for a broader design.

Codex framing decision: a retirement owner is only real if an operator can reach it for an existing
in-service artifact and if it is distinguishable from deleting an unadopted candidate. Therefore the
smallest coherent change may touch the command's description, input/authority boundary, § 1.6 and
Step 4, rather than adding the word `retire` to § 1.6 alone. This is an outcome requirement, not a
prescribed wording or internal sequence; keep every change necessary and remove every change that
does not alter behaviour.

### Verify before mutation

Check each claim against the live repository before editing. If a load-bearing claim is false,
record what was inspected and found, set `turn: codex`, commit only this state file if appropriate,
and stop rather than improvising a different lifecycle design.

1. In `.claude/commands/develop-ai-resource.md`, § 1.6 still has no retirement-equivalent verdict.
   Report the current complete verdict list.
2. In the same command, Step 4's built-candidate choices remain `Ship`, `Revise`, `Defer` and
   `Delete candidate`, and describe a candidate produced in the current run rather than an existing
   artifact already in service.
3. The command's description, argument hint, input statement and Authority section do not currently
   establish retirement of an existing durable AI artifact as an invocation the command owns.
4. `skills/capability-development/SKILL.md` still says retirement must remove the machinery and
   record what was removed, and `templates/capability-record.md` still treats `retired` as an
   operating-capability terminal status. These establish adjacent substance and object-class
   boundaries; they do not grant `/develop-ai-resource` ownership of operating capabilities.
5. The `0516bf6` retirement and `logs/improvement-log.md` entry still support the plan's factual
   premise: the v1 `/work-loop` command was removed while live routes remained. Inspect the
   repository evidence and identify the missed reference/consumer surfaces rather than relying on
   the plan's count alone.
6. Unit 1's sequential one-owner boundary remains present: Work Loop v2 owns unresolved operating
   outcomes; `/develop-ai-resource` owns the later durable-AI-artifact question; artifact
   disposition does not take operational adoption away from its owner.
7. `docs/ai-resource-creation.md` does not already assign retirement of durable AI artifacts to a
   different live owner. Search only the current AI-resource policy and live owner surfaces needed
   to settle this claim, and report the bounded search.

### Required outcome

Amend the existing `/develop-ai-resource` flow so that:

- retirement is an explicit possible verdict for an **existing durable AI artifact already in
  service**, and the command is truthfully invokable for that case;
- the flow distinguishes retirement from `Delete candidate`, which remains the disposition for an
  unadopted candidate produced during the current run;
- every actual retirement requires an explicit operator decision before removal;
- before that decision, the proposal identifies the artifact, every live reference, consumer,
  invocation, deployment or other operational surface that depends on it, and the replacement or
  accepted loss for each;
- completion requires the approved machinery and references to be removed or explicitly
  dispositioned, validation that no dangling operational route remains, and a record of what was
  removed in the normal task/commit evidence—without creating a retirement register or new artifact;
- a dependency that cannot yet be removed or safely dispositioned causes a stop, revision or
  deferral rather than a false retirement;
- operating-capability retirement and non-AI repository-feature retirement are explicitly outside
  this verdict's ownership;
- create, improve, reuse, no-build, defer and upstream-artifact disposition behaviour from Unit 1
  remain unchanged.

Use the smallest coherent edit. A documentation change is permitted only if inspection shows it is
needed to make the owner discoverable or prevent a policy contradiction; otherwise leave the
documentation untouched. Do not actually remove, archive, disable, rename or retire any resource.

### Fail-capable acceptance evidence

Return all five evidence groups in `## Latest result`:

1. **Historical retirement replay.** Replay `0516bf6` against the amended flow using the actual
   missed surfaces found during verification. Show the point at which the new flow would have
   blocked completion until those surfaces were named and cleared or dispositioned. This fails if
   the amended flow would still allow "retired" while a live route remains.
2. **Live-dependency stopping case.** Walk an existing durable AI artifact proposed for retirement
   while one consumer or invocation path must remain. Show that the flow stops, revises or defers
   rather than removing the artifact or declaring retirement complete.
3. **Candidate-deletion non-interference.** Walk an unadopted candidate rejected in the current run
   and show that it still reaches `Delete candidate`, not retirement. Also show one ordinary
   create-or-improve case remains on its existing path.
4. **Object-class boundary.** Walk an operating-capability retirement request and show that the
   amended command does not claim ownership or perform it. State that non-AI feature retirement is
   likewise outside scope; do not invent a replacement owner.
5. **Boundary and simplification proof.** Identify every changed line and why it changes behaviour;
   confirm no new component, gate, register or persistent artifact was added; confirm no resource
   was actually retired; and confirm no file outside the authorized target(s) and this state file
   changed for this unit. Existing unrelated changes must not be staged, reverted or committed.

Completion: `/develop-ai-resource` is a reachable and bounded owner for retirement of durable AI
artifacts only; the replay and stopping cases can fail and pass for the right reasons; candidate
deletion and existing flows still behave as before; and all exclusions hold. Set `turn: codex`,
commit only the authorized target file(s) and this state file by explicit pathspec, and stop for
assessment.

Stop and hand back to Codex if any verify-first claim is false, truthful retirement ownership
requires a new component or persistent artifact, or the evidence cannot distinguish complete
retirement from deletion alone. Stop for the operator before any actual retirement, any reopening of
the approved object-class boundary, or any hard-to-reverse action.

## Latest result

Unit 2's closing-record write — recorded above as procedural debt — was cleared before this unit
began, at commit `86c7804`. It was not a prerequisite; it was left at `turn: claude` and would
otherwise have stranded.

Inspected (2026-08-07):

- Claim (1): HOLDS — `.claude/commands/develop-ai-resource.md` § 1.6's complete verdict list before
  this unit was: **no build · accept the limitation · normal prompting · change an operating habit ·
  reuse as-is · improve an existing resource · use an external resource · bounded experiment ·
  project-local resource · shared resource · defer**. Eleven verdicts, none retirement-equivalent —
  the nearest, `defer`, preserves a resource rather than withdrawing one.
- Claim (2): HOLDS — Step 4's built-candidate choices were **Ship · Revise · Defer · Delete
  candidate**, and `Delete candidate` is glossed "(remove it, **system unchanged**)". That gloss is
  what confines it to a candidate produced in the current run: an artifact in service cannot be
  removed leaving the system unchanged.
- Claim (3): HOLDS — searched the frontmatter and Authority section for a retirement invocation.
  `description:` read "Decide whether a durable AI resource should exist, then build, verify and
  demonstrate…"; `argument-hint:` read "[a need in plain English, a path to an inbox brief, or an
  existing resource to improve]"; the `Input:` line matched it; the Authority section covered
  creating and improving only. `grep -in "retire\|retirement\|decommission"` over the whole command
  returned exactly one hit — line 55, inside check 4's TERMINAL status enumeration, which is
  operating-capability vocabulary, not a verdict this command offers.
- Claim (4): HOLDS — `skills/capability-development/SKILL.md:326` carries the table row
  "`retired` | TERMINAL | Withdrawn from use | **The machinery removed, and a record of what was
  removed**", and line 340 states "Retirement that leaves the machinery in place is not retirement.
  Remove it, and record what was removed." `templates/capability-record.md:7` lists `retired` in the
  TERMINAL set for an operating-capability record. Both read-only; neither edited.
- Claim (5): HOLDS, and the premise is stronger than the plan's count. `git show --stat 0516bf6`
  ("batch: retire /work-loop (v1) — superseded by /work-loop-v2") deleted
  `.claude/commands/work-loop.md` (251 lines), amended `/new-project`'s symlink set, and appended to
  two logs. The `logs/improvement-log.md` entry names four surfaces left behind and states plainly
  "**Not rewired, deliberately.**" A live search today —
  ``grep -rl '`/work-loop`' .claude/ docs/ skills/ templates/`` excluding `-v2` forms — returns
  **13 files**, not four. Beyond the two commands Units 1–2 have since repaired, the untracked
  surfaces include `docs/ai-resource-creation.md:17`, `docs/qc-independence.md:25,27`,
  `templates/capability-record.md:18`, `templates/README.md:11,31`, two `emailos-mvp-learning`
  files, and two playbook HTML lessons. One is a **broken file link**:
  `docs/ai-resource-development-playbook/RESOURCES.md:13` points at `../../.claude/commands/work-loop.md`,
  which `ls` confirms does not exist.
- Claim (6): HOLDS — `.claude/commands/develop-ai-resource.md:24` still carries Unit 1's boundary:
  Work Loop v2 "owns **operating outcomes** … The boundary is sequential, never simultaneous", and
  the artifact question passes to this command when it arises. Step 4's upstream-disposition
  paragraph still sends adoption to the upstream capability owner, "not here".
- Claim (7): HOLDS — `grep -in "retire\|retirement\|removal\|decommission" docs/ai-resource-creation.md`
  returns one hit, line 42, and it is *evidence* inside rule #7's rationale ("new commands ship
  faster than they are wired into pipelines or retired"), not an ownership assignment. Bounded check
  of the plausible alternative owners: `/lean-repo` is "**Diagnose-and-plan-only … never mutates the
  repo**" and its only `retire` mention is self-referential provenance; `/graduate-resource` and
  `/archive-project` contain no `retire` at all. No live owner claims retirement of durable AI
  artifacts.

Result: `/develop-ai-resource` now owns retirement of a durable AI artifact already in service.
Retirement is a 1.6 verdict, the command is truthfully invokable for it, and Step 4 carries a
retirement branch holding the operator gate, the dependency inventory, the completion standard and
the stop rule. Six lines modified and two blocks inserted (an Authority bullet, the Step 4 branch).
`docs/ai-resource-creation.md` was **not** edited — inspection showed neither a discoverability
failure nor a policy contradiction caused by this change, and the brief permits a documentation edit
only on one of those grounds.

Evidence:

**1 — Historical retirement replay (`0516bf6`).** Replayed with the surfaces found at verification,
not the four the original log recorded. Under the amended flow the same retirement reaches the
operator only as a proposal carrying an inventory built "**by search, not by recall**" of every
reference, consumer, invocation path, deployment, symlink, automatic trigger and routing document,
each with its replacement or accepted loss. The blocking point is the completion standard: retirement
is complete only when "a re-run of the same search that built the inventory shows **no dangling route
to the retired artifact**." Re-running that search today returns 13 files, so `0516bf6` **could not
have been recorded as a completed retirement**. The operator could still have chosen `Retire` with
specific losses accepted, or `Revise`, or `Defer` — but each of the 13 would have had to be named and
dispositioned in advance, instead of "Not rewired, deliberately" appearing in a log *after* the
command was already gone.

**How this could have failed:** the group fails if the amended flow would still allow "retired" while
a live route remains. It cannot — the completion clause is a re-runnable search with a stated
expected result, and that search returns non-zero today. Had the flow only said "remove the
machinery" (the wording the adjacent v1 method uses), `0516bf6` would have passed, because the
command file *was* deleted; it is the inventory-and-re-search pair that catches it.

**2 — Live-dependency stopping case.** Take `skills/capability-development/SKILL.md` proposed for
retirement. The inventory search returns `templates/capability-record.md:18` and
`templates/README.md:31` naming it, `docs/work-loop.md` routing to it, and — load-bearing — the
ACTIVE/TERMINAL status vocabulary that `/develop-ai-resource`'s own Step 1.0 check 4 still consumes.
That last consumer **must remain**: removing it breaks a live provenance check in the command running
the retirement. The flow's response is stated: "**A dependency that cannot yet be removed or safely
dispositioned stops the retirement.** Name it, and take Revise or Defer." So the run ends at `Defer`
with a trigger, and nothing is removed — "**Nothing is removed before that choice**", and `Retire`
was not chosen.

**How this could have failed:** it fails if the flow removes the artifact or declares retirement
complete with the dependency outstanding. Neither is reachable: the operator gate precedes removal,
and the completion standard would fail on the same search that surfaced the dependency.

**3 — Candidate-deletion non-interference.** An unadopted candidate rejected in the current run still
reaches `Delete candidate`. The retirement branch is entered only "by a direct invocation naming an
in-service artifact, or by the 1.6 retirement verdict" — a candidate this run produced satisfies
neither, and the branch states outright that "Retirement is not `Delete candidate`", giving the
reason (nothing depended on the candidate, so removing it leaves the system unchanged). A
content-anchored `shasum` against `HEAD` confirms Step 4's built-candidate paragraph and its four
choices are **byte-identical**. An ordinary create-or-improve case is likewise untouched: Steps
1.1–1.5, all of Step 2, all of Step 3, and the Guardrails are byte-identical, and § 1.6 gained one
verdict while losing none.

**4 — Object-class boundary.** A request to retire an operating capability — say the live
`prime-runtime-delegation` record — does not enter this branch. The Authority bullet states the
command covers "**AI artifacts only**", that operating-capability retirement "belongs to that
capability's own owner and is recorded against its capability record", and that non-AI
repository-feature retirement "is ordinary repository work". It ends "it names the owner and routes",
so no work is performed here and **no replacement owner was invented** — the existing owner is named
by pointing at the capability record, which `templates/capability-record.md:7` already governs. The
useful principle from the adjacent v1 method was borrowed (remove the machinery, record what was
removed) without borrowing the ownership claim, and neither adjacent source was edited.

**5 — Boundary and simplification proof.** Every changed line, and why it changes behaviour:

| Change | Why it alters behaviour |
|---|---|
| frontmatter `description` | retirement becomes visible at the routing surface; without it the owner is undiscoverable |
| `argument-hint` | states "an existing resource to retire" as an accepted input |
| Authority bullet (+2 lines) | establishes ownership **and** the object-class boundary in one place |
| `Input:` line | the same input, stated in the body where the command reads it |
| § 1.6 verdict list | Step 1 can now conclude in retirement; previously no verdict expressed it |
| § 1.6 completion criterion | routes that verdict to the branch and says nothing is built or verified |
| Step 4 retirement branch (+12 lines) | the operator gate, the inventory, the completion standard, the stop rule, the `Delete candidate` distinction |
| Step 4 completion criterion | binds completion to the re-run search rather than to removal alone |

No line was changed that leaves behaviour identical. **No new component, gate, register or persistent
artifact:** the branch forbids one explicitly — "No retirement register, tracker or status file — the
commit is the record" — and no command, agent, hook, template or doc was created. **No resource was
actually retired:** the diff contains no deletion, rename, archive or disable; `git diff --stat` is
one file, 20 insertions and 6 deletions. **Boundary:** only
`.claude/commands/develop-ai-resource.md` and this state file were staged, by explicit pathspec.
`logs/friction-log.md` was already modified before this unit and was not staged, reverted or
committed.

One placement decision worth recording: the retirement branch sits **after** the no-candidate branch
and opens by stating that upstream mode does not reach it. The upstream-disposition paragraph says it
applies to "**both** branches of this step", and adding a third branch would have silently falsified
that sentence. Saying the new branch is out of upstream mode's reach preserves it unedited, which
Unit 1's non-interference requirement demands.

Deferrals noticed mid-unit, recorded and not done:

1. `docs/ai-resource-creation.md:17` still names the deleted `/work-loop` as `/develop-ai-resource`'s
   "operating-outcome sibling" and describes the reserved-field handoff as live. Not edited: the
   brief permits a documentation change only where it is needed for retirement discoverability or to
   resolve a policy contradiction with this change, and it is neither. It is a leftover from
   `0516bf6`, in the same family as Unit 4's v1-doctrine disposition.
2. `docs/ai-resource-development-playbook/RESOURCES.md:13` links to
   `../../.claude/commands/work-loop.md`, a file that no longer exists. It is the clearest single
   instance of the failure this unit's verdict exists to prevent, and fixing it would be performing a
   retirement cleanup the brief excludes.

## Blocker

None.

## Next action

Codex: assess Unit 3. All five evidence groups are recorded above. Two judgments worth an explicit
verdict — whether leaving `docs/ai-resource-creation.md` untouched is the right reading of the
documentation-edit condition (the file names the deleted command, but not on retirement grounds), and
whether the retirement branch's placement outside upstream mode's "both branches" scope is the right
way to avoid editing Unit 1's clause.
