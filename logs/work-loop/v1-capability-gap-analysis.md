---
task: v1-capability-gap-analysis
turn: codex
---

## Objective and scope

Produce the evidence package the operator needs to decide whether the surviving Work Loop v1
capability layer is kept, folded into v2 or retired. Compare its method section by section, establish
what durable state and live consumers still depend on it, and disposition the one live capability
record as a decision question—not as an action.

Scope is read-only inspection of the current repository, the workspace and the one named sibling
project record; only this state file may change. Excluded: recommending or choosing a disposition,
editing or deleting any v1/v2 artifact, changing the capability record, cleaning stale references,
building a replacement method or record, reopening Units 1–3, or executing any keep/fold/retire
option.

## Lane and unit

Standard. Discovery mode. Unit 4 — the v1 capability gap analysis and operator decision package.

Named reason for the loop: the result controls a later structural decision affecting five
interdependent resources and one live project record. The method cannot be responsibly kept, folded
or retired from resemblance or line counts; the comparison, inbound-reference inventory and record
disposition must survive sessions and be assessed before the operator decides.

Plan justification: the operator approved the corrected plan content at `6af280e`, explicitly
started Unit 4, and Units 1–3 are closed. Governing unit:
`plans/work-loop-v2-v0.2/resource-capability-development-plan-v0.1.md` § 7, Unit 4; the whole-build
stopping condition is § 11. This unit produces evidence only and ends in an operator decision—it
does not implement that decision.

## Brief

Why this unit, why now: Units 1–3 repaired the live routes and gave durable AI artifacts a retirement
owner, leaving one unresolved question—whether the unreachable v1 operating-capability method still
contains work v2 does not perform. The plan expressly rejects deciding that question from
“Adoption mode has four choices” or from the fact that the old executor is gone. Unit 4 must compare
actual behavior and current consumers, then put a neutral decision package in front of the operator.

### Governing sources and authority history

- Current operator instruction to start Unit 4 — authorizes this discovery only.
- `logs/work-loop/work-loop-v2-resource-capability-plan.md` and plan content `6af280e` — the
  content-bound approval and governing minimum: inspect before any keep/fold/retire choice.
- `plans/work-loop-v2-v0.2/resource-capability-development-plan-v0.1.md` §§ 3, 5, 7 Unit 4, 8 and 11
  — governing comparison, object boundary, v1 seam map, no-build rules and stopping condition.
- `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`,
  `.agents/skills/work-loop-v2/SKILL.md` and `.claude/commands/work-loop-v2.md` — current v2 process,
  routing and execution comparators.
- `.claude/commands/develop-ai-resource.md`, `.claude/commands/leverage-idea.md` and
  `docs/qc-independence.md` — current adjacent owners produced or relied on by Units 1–3; use only
  where they genuinely cover part of the v1 method.
- The five surviving v1 files:
  `.agents/skills/work-loop/SKILL.md`, `docs/work-loop.md`, `docs/work-loop-spec.md`,
  `skills/capability-development/SKILL.md`, and `templates/capability-record.md`.
- The current record:
  `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/development/prime-runtime-delegation.md`.

**Authority conflict to preserve, not silently resolve.**
`plans/work-loop-v2-mvp/step-7-v1-retirement-decision.md` records an operator decision on 2026-08-01
to archive v1 immediately. The later corrected plan content at `6af280e` states that no v1
disposition is recommended before this gap analysis and reserves the consequential choice to the
operator; the operator has now authorized the analysis. Verify both records and carry the earlier
decision into the final package as decision history. Do not declare it superseded, reaffirmed or
still executable on your own—the operator will reconcile it against the current evidence after this
unit.

Codex framing decision: an **inbound reference** is a current dependency that would break, become
unreachable or materially mislead if its target changed. Historical mentions in plans, logs,
archives and audits are not inbound dependencies, but the search must still count and classify them
so they cannot be silently discarded. This distinction keeps the decision about live blast radius,
not the number of times an old filename appears in repository history.

### Verify before the discovery

Check each claim against the live repository and record the bounded search. If a claim is false, that
is discovery evidence: report the actual state and continue only where the brief remains coherent;
hand back to Codex if it changes the object, authority or feasible completion condition.

1. The closed records for Units 1–3 are at `turn: operator`, and their outcomes leave Unit 4 as the
   next unresolved plan item.
2. The five v1 files named above exist, while `.claude/commands/work-loop.md` is absent. Establish
   each file's current role from its body, not its filename.
3. `skills/capability-development/SKILL.md` still has `disable-model-invocation: true`, says it is
   never invoked directly, and names the deleted `/work-loop` as its executor.
4. The current v2 core still reduces an active task state file to four closing sections and carries
   no durable operating-capability record of its own. Search the core, both v2 sides and their state
   templates/interfaces; any equivalent durable address found makes the plan premise false.
5. `templates/capability-record.md` still contains an implementation-package retirement condition,
   `## Real-use result`, `## Lifecycle status`, ownership/seam information and long-lived decisions;
   establish which of those fields the actual `prime-runtime-delegation.md` record uses.
6. Exactly one current operating-capability record exists across
   `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/*/development/`, and its frontmatter
   identity/status plus body agree—or identify every mismatch and every additional record found.
   The search must match capability-record structure, not every Markdown file in `development/`.
7. The August 1 retirement decision and the later `6af280e` plan carry the authority history stated
   above. Cite the clauses; do not infer resolution from dates alone.

### Required discovery

Return one evidence package in `## Latest result`, with these five parts.

#### 1. Method coverage matrix

For every top-level `##` section of `skills/capability-development/SKILL.md`, give:

- its concrete job and observable result;
- the exact live v2 or adjacent clause that performs the same job, if one exists;
- one verdict: **covered · partly covered · not covered**;
- the residual behavior, state or decision that remains after any overlap;
- whether that residual is used by the live capability record or only defined in the method.

The matrix must explicitly and substantively cover the intervention ladder, ownership and seams, the
five phases, trial design and its stop condition, slice standards, evidence-to-claim, and lifecycle
decisions. Similar vocabulary is not coverage. In particular, Adoption mode's decision choices do
not cover trial design, retirement conditions or durable lifecycle state unless the cited v2 text
actually performs those jobs.

Treat v1 process machinery separately from capability method. A v2 clause that replaces
`docs/work-loop.md` admission, unit, review or state-file process does not automatically replace a
method section that the deleted command once consumed.

#### 2. Durable-state comparison

Compare the v2 task-state contract with both `templates/capability-record.md` and the actual live
record. At minimum decide, with citations, where these survive after a task closes:

- retirement condition;
- real-use result;
- lifecycle status;
- operating owner and seams;
- decisions and the next capability-level action across multiple tasks.

For each, say **equivalent durable home exists · partly represented · no durable v2 home found**.
Do not conclude that a record is required merely because v1 had one. State the demonstrated value
from the live record, the maintenance/duplication cost, and the plan's reopening test: a new v2
durable address stays deferred unless this unit shows loss at closure **and** a second live
capability record appears.

#### 3. Five-file inbound-reference inventory

For each of the five v1 files, search the current workspace root, `ai-resources/` and all projects by
exact path, basename, resource/skill name, invocation text and symlink target. Exclude `.git` internals
and temporary tool caches; include deployed/symlink consumers and current state records.

Classify every hit as:

- **live operational/executable dependency**;
- **live normative documentation, template or current-state dependency**;
- **self/internal v1 dependency**;
- **historical/archive/log mention**.

List every hit in the first two classes by path and line or resolved symlink target. For the latter
two, report the complete bounded search and counts, plus any example needed to prove classification;
do not dump hundreds of historical lines into the state file. Supply a positive control for each
search family so a zero is meaningful. A live inbound reference invokes the plan's no-build rule:
the target cannot be retired unchanged; record the dependency and the migration/repair prerequisite,
but do not perform it.

Include the two Unit 3 deferrals explicitly:
`docs/ai-resource-creation.md:17` and
`docs/ai-resource-development-playbook/RESOURCES.md:13`. Determine their current exact line and
class rather than assuming the recorded line numbers still hold.

#### 4. One-live-record disposition question

Read the entire `prime-runtime-delegation.md` record. Report its actual frontmatter status, phase,
active unit and update date; the real-use result and retirement condition it preserves; the work it
claims remains; any internal mismatch or stale pointer material to disposition; and every live
component that currently consumes its status vocabulary or identity.

Then give the operator the feasible **keep · fold/migrate · terminally close/retire** choices for
this record, stating the evidence, preconditions, information loss and operational risk of each.
Do not select one and do not edit the record. If the record is not the only one, repeat this analysis
for each record rather than preserving the false premise.

#### 5. Neutral operator decision package

End with:

- the uncovered/partly-covered method capabilities that would be lost by immediate retirement;
- the v1 process content demonstrably superseded by v2;
- the files that cannot move while live inbound references remain;
- the implications of **keep the capability layer · fold only named gaps into a live owner · retire
  the layer after named prerequisites**, without recommending one;
- the August 1 decision beside the facts materially changed by Units 1–3 and the facts still
  unchanged;
- the smallest set of explicit operator choices needed next.

Every file gets a disposition **option set with constraints**, not an implemented disposition. Keep
the evidence and the decision separate so the operator can choose differently without invalidating
the inspection.

### Fail-capable completion evidence

The discovery is complete only if:

1. Every top-level capability-method section has exactly one coverage verdict backed by a current
   citation, and the seven load-bearing sections above are compared by behavior rather than words.
2. The state comparison demonstrates whether each named long-lived field survives task closure and
   uses the actual record as evidence rather than the template alone.
3. Every v1 file has a bounded, positive-controlled inbound-reference search and every live
   dependency is listed; a raw grep count or historical mention is not treated as a consumer.
4. The record search can disprove “exactly one,” and the disposition choices preserve any negative
   or contradictory finding instead of smoothing it away.
5. The final package offers neutral constrained choices, carries the earlier operator decision, and
   makes no recommendation or repository change.
6. Only this state file changed. No v1/v2 artifact, project record, stale reference, symlink,
   worktree, branch or capability status was altered.

Completion: write the evidence package into `## Latest result`, set `turn: codex`, commit only this
state file by explicit pathspec, and stop. This is the ordinary Work Loop assessment hand-back; the
plan's “Review: none” means no additional independent review layer for a read-only discovery, not
that evidence bypasses Codex progression assessment.

Stop and hand back to Codex if the five-file object is wrong, the authority history cannot be
verified, or a required search surface is inaccessible. Stop for the operator only if evidence
collection itself would require changing or abandoning a settled decision. Do not act on any
disposition under any circumstance in this unit.

## Latest result

Discovery unit — read-only. Nothing outside this state file changed.

### Claim verification

- Claim (1): HOLDS — `develop-ai-resource-v2-capability-seam`, `leverage-idea-v2-routing-seam` and
  `develop-ai-resource-retirement-verdict` are each `turn: operator` with exactly 4 `##` headings.
- Claim (2): HOLDS — all five v1 files exist (`.agents/skills/work-loop/SKILL.md` 119 lines,
  `docs/work-loop.md` 260, `docs/work-loop-spec.md` 360, `skills/capability-development/SKILL.md` 442,
  `templates/capability-record.md` 140); `.claude/commands/work-loop.md` is absent. Roles from bodies:
  the `.agents` file is the **Codex-side v1 controller** ("You are the independent half of a two-model
  work loop"); `docs/work-loop.md` is the **process contract**; `docs/work-loop-spec.md` is the
  **operational specification** of the deleted command, and its `Applies to:` line names
  `.claude/commands/work-loop.md` first; `capability-development/SKILL.md` is **method only**;
  `templates/capability-record.md` is the **record shape and status vocabulary**.
- Claim (3): HOLDS — `disable-model-invocation: true` at frontmatter, "**Never invoked directly.**"
  at line 24, and "A capability is developed through `/work-loop`" naming the deleted executor.
- Claim (4): HOLDS — core line 314 reduces a closed task to "exactly these four sections". A search of
  all three v2 surfaces for `capability record` / `capability-record` / `durable address` /
  `development/` returns **zero**, against a positive control of 3 hits for "capability record" in
  `docs/work-loop.md`. No durable operating-capability address exists on the v2 side.
- Claim (5): HOLDS — the template carries the retirement condition inside `## Implementation package`
  (`:83`), plus `## Real-use result` (`:130`), `## Lifecycle status` (`:134`), `## Ownership and
  seams` (`:65`) and `## Decisions` (`:115`). **The live record uses all sixteen template headings, in
  the template's order.** One structural divergence: the template locates the retirement condition in
  `## Implementation package`, but the live record's Implementation package says only "Held by
  `/develop-ai-resource`" and its retirement condition lives in `## Lifecycle status` (`:432–434`).
- Claim (6): HOLDS — exactly one record. Structure-matched search (frontmatter `^capability:` under
  `projects/*/development/`) returns 1 of 1 candidate files; only one `development/` directory exists
  workspace-wide. A wider `grep -rl "^capability:"` finds six more files, none of them records: the
  template itself, four `2026-07-28-develop-capability-build-plan*` plans, and
  `audits/working/…/C5-draft-capability-record.md` — a draft outside `projects/*/development/`.
- Claim (7): HOLDS — `plans/work-loop-v2-mvp/step-7-v1-retirement-decision.md:15` records "**Option A
  — archive v1 immediately.** Taken by the operator, 2026-08-01, at pilot start", with the table at
  `:25–27` marking A **CHOSEN**, B not taken, and C ("scoped retirement — retire only the half v2
  replaces") "Not taken (Claude's recommendation)". The later plan reserves the choice:
  `resource-capability-development-plan-v0.1.md:428–429` — "Whether the v1 capability layer is kept,
  folded into v2, or retired is reserved to the operator. Unit 4 produces the evidence; **neither it
  nor this plan decides.**" Both records verified; neither is declared superseded here.

**Evidence-integrity note.** The first pass of the v2 comparator search returned zero for every term.
It was a **broken search, not an absence**: the file list was held in a plain shell variable, which zsh
does not word-split, so `grep` received one non-existent path. The tell was a `No such file or
directory` warning beside a suspiciously perfect zero. Re-run with an array, the same terms return
non-zero. Every count below is from the array form with a v1 positive control beside it — the method's
own rule at `skills/capability-development/SKILL.md:281` ("A negative result is not evidence until a
positive control has shown the check can detect what it looks for") is what caught it.

### 1. Method coverage matrix

All seventeen top-level `##` sections. "Covered" means a live clause performs the same job, not that it
uses the same word.

| # | Section | Job / observable result | Live clause performing it | Verdict | Residual | In live record? |
|---|---|---|---|---|---|---|
| 1 | Boundary sentences | fix what the method is and is not | `develop-ai-resource.md:24` (Unit 1) + v2 skill index `:166–167` | **covered** | — | no |
| 2 | What an operating capability is | define the object under work | none — v2 uses "capability" in Adoption mode without defining it | **partly covered** | the object definition itself | yes (identity) |
| 3 | Route triggers | capability-specific triggers atop the universal set | v2 intake router `SKILL.md:117–176` + core § 2 admission | **covered** | — | no |
| 4 | The intervention ladder | 8 rungs, stop at the first that works; a required Frame output | `develop-ai-resource.md` § 1.4 — a 10-rung ladder, but for **artifact mechanism** only | **partly covered** | no live ladder for a non-artifact operating capability; v2 hits for "intervention ladder" = **0** (v1 = 4) | no |
| 5 | Ownership and seams | 4-criteria owner selection; the 7-field seam; technical **and operating** seam | none. v2's "owner" (20 hits) is *which command owns the request*; v2's "seam" (3 hits) is the **transport** seam — `step-2-transport-seam-conclusions.md` and the Codex skill's `## The seam` | **not covered** | owner-selection procedure, 7-field seam, the operating-seam concept, "dependencies never become co-owners" | **yes** — § Ownership and seams |
| 6 | The five phases | Frame·Shape·Build·Prove·Land, each with an exit | v2 unit cycle (core § 3) + three modes | **partly covered** | the capability-level arc and its G1/G2/G3 gates; v2's cycle is per-unit | **yes** — `phase: build`, § Units |
| 7 | Trial design and its stop condition | 6 questions; **a trial that produces no useful result stops the build** | none. v2 "trial" = 3 hits, all Adoption mode's *choice* "continue the trial" plus one clause saying the operating is separate work | **not covered** | the whole design and the stop condition | latent |
| 8 | Slice standards | a slice is a complete behaviour; 5 properties; anti-layer-slicing | none. v2 "slice" = 3 hits, all **v2's own build slices 1–3** | **not covered** | all of it | **yes** — § Vertical slices |
| 9 | Evidence to claim | claim-type→evidence table; positive control; observed·unassessed·blocked | core § 6 rules 3 and 5; `develop-ai-resource.md` § 3.4 | **partly covered** | the claim-type table and the three-way marking; "positive control" = **0** v2 hits (v1 = 2) | **yes** — § Verification evidence |
| 10 | The two self-review questions | pre-handback self-check | core § 3 step 5 + "good enough, proceed" | **covered** | — | no |
| 11 | Adjudicating findings | disposition review findings | core § 3 *Correcting once* + the menu | **covered** | — | yes |
| 12 | Lifecycle decisions | 9 statuses; ACTIVE set; terminal-only exit; never adopt without real use; retirement removes the machinery | Adoption mode's four choices (adopt·revise·continue trial·stop) | **partly covered** | 4 decisions map onto 4 of 9 statuses; **no recorded status, no ACTIVE set, no "a record is never deleted"** | **yes** — and see § 3, a live executable consumer |
| 13 | Data handling | what may go to which external model or tool | none in v2 | **not covered** | all of it | yes — "External systems: none" |
| 14 | Handoffs this method requires | to `/develop-ai-resource`, to `/scope-project`; never graduate from inside | `develop-ai-resource.md:24` (Unit 1); `/scope-project` in the v2 index | **partly covered** | "never let the artifact's disposition stand in for the capability's adoption decision"; "never generalise on a single confirmed consumer" | yes |
| 15 | Worked examples | six calibration cases | v2 skill's three mode cases `:141–147` | **partly covered** | four calibration boundaries | no |
| 16 | SOP step → phase mapping | map the method onto v1's eight loop steps | — its target is the deleted command's SOP | **not covered / obsolete** | none worth preserving | no |
| 17 | What this skill never does | never runs itself, never orchestrates, never authors an artifact | v2's do-not-wrap-a-specialist rule (core § 1) + Unit 1's boundary | **covered** | — | no |

**The seven load-bearing sections:** intervention ladder *partly*, ownership and seams **not**, five
phases *partly*, trial design and stop condition **not**, slice standards **not**, evidence to claim
*partly*, lifecycle decisions *partly*. **Zero of the seven are fully covered.**

Adoption mode was checked against the plan's explicit warning and does **not** cover trial design,
retirement conditions or durable lifecycle state: core `:126` gives it four decision choices and
`:133` states it "changes nothing beyond the state file", so it reads evidence a trial produced
without specifying how the trial is designed or where its result durably lives.

**Process versus method, kept separate.** `docs/work-loop.md` and `docs/work-loop-spec.md` are v1
*process* machinery — admission, units, artifacts, state, resume order. v2 demonstrably replaces that
layer. That replacement says nothing about rows 4–13 above, which are method the deleted command
*consumed* rather than performed.

### 2. Durable-state comparison

v2's task-state contract closes to exactly four sections (core `:314`) and the file is **reduced** at
close. The question is what survives a task closing.

| Long-lived field | v1 template | Live record | v2 home after close | Verdict |
|---|---|---|---|---|
| Retirement condition | `:83`, in § Implementation package | § Lifecycle status `:432–434` — "superseded by a harness-native facility … or `/prime` stops performing orientation" | none — 0 hits for "retirement condition" across all three v2 surfaces (v1 = 2) | **no durable v2 home found** |
| Real-use result | `## Real-use result` `:130` | `:415–428` — first production use, prediction registered **before** the run, and the explicit limit that Slice 4 has still never executed | § Evidence holds one task's evidence; nothing accumulates across tasks | **partly represented** |
| Lifecycle status | `## Lifecycle status` `:134` + frontmatter `status:` | `status: in-development` | `turn:` only — a protocol field, not a lifecycle state | **no durable v2 home found** |
| Operating owner and seams | `## Ownership and seams` `:65` | `:79–91` — owner, dependencies ("Never co-owners"), external systems, official record per data class | `## Objective and scope`, per task | **no durable v2 home found** |
| Decisions + next capability action across tasks | `## Decisions` `:115`, `## Current phase and next action` `:126` | D1–D4 with rationale and rejected alternatives; a next-action section | `## Decisions that matter` — per task, in a file that is reduced at close | **partly represented** |

**Demonstrated value from the live record**, stated rather than assumed: it is the only place holding
(a) D2's frozen ≤300 assertion with its "recorded unmet, not renegotiated" standard, (b) D4's
enumerated retirement list and the instruction that the multi-item-auto evidence "is not to be
re-raised", and (c) the § Verification evidence rows that carry **superseded and rejected** claims
side by side with live ones, including one row marked "this row was WRONG … kept rather than deleted
so the error is on the record". A v2 closing record would have carried the last accepted result only.

**Maintenance and duplication cost:** the record is 481 lines for one capability, spans two streams,
and contains at least three internally stale statements (§ 4). Its § Units table duplicates commit
history Git already holds.

**The plan's reopening test is NOT met.** It requires both loss at closure **and** a second live
capability record. Loss at closure is demonstrated for three of five fields — but there is exactly one
record (claim 6), so the second condition fails. On the plan's own rule, a new v2 durable address
stays deferred.

### 3. Five-file inbound-reference inventory

Searched: workspace root, `ai-resources/`, `projects/`, `knowledge-bases/`, `.claude/`, `CLAUDE.md`,
by exact path, basename, skill/resource name and invocation text, plus a `find -type l` symlink pass.
Excluded: `.git` internals and the two sibling worktrees (`ai-resources-active-unit-routing`,
`ai-resources-g1-reviewed-plan`), confirmed as separate branches by `git worktree list`.

**Positive control for each family:** every pattern returns non-zero somewhere (40 / 27 / 13 / 65 / 31
files), so a zero in the live-surface column is a real absence rather than a blind search.

**Class A — live operational/executable dependency.** One, and it is load-bearing:

- `.claude/commands/develop-ai-resource.md:57` → `templates/capability-record.md`. Step 1.0 check 4
  matches `status:` against the ACTIVE set "per the `STATUS IS A SET` block in
  `templates/capability-record.md`", and check 1 globs `projects/*/development/{slug}.md`. **The
  template cannot be retired unchanged**: the status vocabulary would have to move into the command or
  another live home first. Prerequisite recorded, not performed.

**Class B — live normative documentation, template or current-state dependency:**

| Path:line | Target | Note |
|---|---|---|
| `templates/capability-record.md:19–20` | method + `docs/work-loop.md` | the template routes readers to both |
| `templates/README.md:11`, `:31` | `capability-record.md`, `/work-loop` | `:31` names `/work-loop` as the consumer — dangling |
| `docs/qc-independence.md:25`, `:27` | `docs/work-loop.md`, `/work-loop` | **canonical review-policy doc**, cited from workspace `CLAUDE.md`; routes review through a deleted command |
| `docs/ai-resource-creation.md:17` | `/work-loop` + the method | **Unit 3 deferral 1 — line 17 confirmed current** |
| `docs/ai-resource-development-playbook/RESOURCES.md:13` | `../../.claude/commands/work-loop.md` | **Unit 3 deferral 2 — line 13 confirmed current; the target does not exist (broken link)** |
| `docs/emailos-mvp-learning/RESOURCES.md:21`, `:23`; `NOTES.md:12` | contract + method | learning material presented as current |
| `.claude/commands/develop-ai-resource.md:26`, `:66`, `:165` | method, template, contract | Unit 1 text naming the survivors as v1 documents; `:165` cites `docs/work-loop.md` § Execution boundary |
| `projects/axcion-ai-system-owner/development/prime-runtime-delegation.md:82`, `:135`, `:340` | `docs/work-loop.md` §§ Artifacts, Block formats, Resume order | **live current-state record depending on a deleted executor's contract** |
| `.gitignore:81` | `!.agents/skills/work-loop/` | explicit re-include; the v1 Codex skill **is tracked** (`git ls-files` confirms) |

**Class C — self/internal v1.** The five files citing each other: `.agents/skills/work-loop/SKILL.md:10`,
`:85`; `capability-development/SKILL.md` (12 citations of `docs/work-loop.md`, plus `:331` on the
template); `docs/work-loop-spec.md:4`, `:9`, `:150`, `:154`, `:157`, `:228`, `:243`;
`docs/work-loop.md:11`, `:63`, `:250`. These move or die together.

**Class D — historical/archive/log mention.** The bulk. By pattern, total files minus the live and
self classes: `capability-development` 40 → ~24 historical (plans, `audits/risk-checks/`, session
plans, scratchpads, archived notes); `capability-record` 27 → ~16; `work-loop-spec` 13 → ~11;
`docs/work-loop.md` 65 → ~45; `.agents/skills/work-loop/` 31 → ~24. Not listed line by line, per the
brief. Example proving the classification: `audits/risk-checks/2026-07-28-plan-time-gate-work-loop-
capability-development-build.md` is a dated gate record of a past decision — changing the target
cannot break it.

**Symlink pass:** `find -type l` finds **no symlink pointing at any of the five**. Every deployed
work-loop symlink resolves to `work-loop-v2` (`.claude/commands/work-loop-v2.md` in four projects,
`.agents/skills/work-loop-v2` in one, `plans/work-loop-v2-mvp` in one). Broken symlinks exist
elsewhere in the workspace (`projects/project-planning/`, `projects/strategic-os/.backup-untracked/`)
but none targets these files. **v1's six deployed symlinks are already gone** — consistent with the
`0516bf6` log.

**No-build rule engaged.** `templates/capability-record.md` (Class A) and the Class B set cannot be
retired unchanged. The migration/repair prerequisites are recorded above and **were not performed**.

### 4. The one live record — disposition question

`projects/axcion-ai-system-owner/development/prime-runtime-delegation.md`, 481 lines, read in full.

**Actual state:** `capability: prime-runtime-delegation` · `route: challenged` · `phase: build` ·
`status: in-development` · `owner_project: axcion-ai-system-owner` ·
`stream: 2026-07-30-prime-session-entry-ownership` · `active_unit: none` · opened 2026-07-29 ·
**updated 2026-07-31** (seven days stale).

**What it preserves:** a retirement condition (§ Lifecycle status); a real-use result with a
pre-registered falsifiable prediction and its own honest limit ("Slice 4's orientation text has still
never executed"); four decisions with rejected alternatives; a § Verification evidence table that
keeps superseded and rejected rows visible; and a recorded gate history including "**Gates:
operator-declined, not passed**" and "independent review of this artifact as **outstanding**".

**Work it claims remains:** stream 1 S2 "suspended at route-out, pending `/develop-ai-resource`";
S4+5 "held by operator direction until S2 returns"; `prime.md` at 264 lines against a frozen ≤300
target recorded **unmet**; mission `lean-prime-2026-07` "stays active, assertion unmet".

**Internal mismatches material to disposition — four, none smoothed away:**

1. **Frontmatter contradicts D4.** `status: in-development`, but D4 `:339` states "`status: revise`".
   Both are ACTIVE, so check 4 still passes — but the record disagrees with its own decision.
2. **The next action is stale.** § Current phase says "**S1 opens next session**" and `active_unit:
   none — deliberate", while § Vertical slices shows stream-2 S1–S6 all `[x]` landed plus a
   post-review defect closure (`d39572a`, 2026-07-31). The prescribed next action is already done.
3. **Its resume mechanism is dead.** `:340` says the ACTIVE status keeps it "in `docs/work-loop.md`
   § Resume order and a bare `/work-loop` keeps resuming it", and `:376` says "`/work-loop` picks the
   capability up from this section". That executor is deleted, so **nothing resumes this record** —
   it is reachable only by someone opening the file.
4. **A prescribed cleanup was left undone deliberately** (`:473–477`): `prime-marker.test.sh` "Still
   on disk — deleting it was prescribed by this record but was outside the session's instruction".

**Live consumers of its status vocabulary or identity:** exactly one — `/develop-ai-resource`
Step 1.0, checks 1–4 (the `projects/*/development/{slug}.md` glob, the `capability:` key,
`owner_project:` agreement, and ACTIVE-set membership). Nothing else reads it.

**Feasible choices, with evidence, preconditions, loss and risk — none selected:**

| Choice | Evidence for it | Preconditions | Information loss | Operational risk |
|---|---|---|---|---|
| **Keep** as-is | it is the only home for D2/D4 and the superseded-claim history; check 4 passes today | none | none | it is unresumable (mismatch 3) and drifting — 7 days stale with a next action already completed; keeping it preserves a record nothing maintains |
| **Fold / migrate** into a live owner | only 5 long-lived fields are actually used; a v2 closing record could hold outcome, decisions and evidence | a live destination must exist for lifecycle status, retirement condition and the seam — § 2 shows none does; the status vocabulary must stay readable by check 4 | the cross-task narrative and the superseded-claim rows; § Units duplicates Git and would not be missed | medium — check 4 breaks if the vocabulary moves without the command changing in the same step |
| **Terminally close / retire** the record | its stream's slices are landed; its resume path is dead | a TERMINAL status is required (`retired` demands "the machinery removed, and a record of what was removed"); the open S2/S4+5 claims and the unmet mission assertion must be dispositioned first | the open work items become invisible — mission `lean-prime-2026-07` is still `active` with its assertion unmet | high if done before those items are re-homed: the ≤300 target and the suspended slices lose their only address |

The record is not edited, and no choice is recommended.

### 5. Neutral operator decision package

**Capabilities lost by immediate retirement** (uncovered or partly covered, § 1): the operating-seam
concept and the 4-criteria owner-selection procedure (**not covered**); trial design and its
build-stopping condition (**not covered**); slice standards (**not covered**); data handling (**not
covered**); the 9-status lifecycle vocabulary with its ACTIVE set (**partly** — and consumed by a live
executable check); the claim-type→evidence table and observed·unassessed·blocked marking (**partly**);
the intervention ladder for non-artifact capabilities (**partly**); the five-phase arc and its gates
(**partly**).

**v1 process content demonstrably superseded by v2:** route triggers, the self-review questions,
finding adjudication, the boundary sentences and "what this skill never does" (rows 1, 3, 10, 11, 17)
— plus the whole of `docs/work-loop.md`'s admission/unit/state/resume machinery and
`docs/work-loop-spec.md`, whose `Applies to:` target is a deleted file. Row 16 is obsolete rather than
superseded.

**Files that cannot move while live inbound references remain:**

- `templates/capability-record.md` — blocked by `develop-ai-resource.md:57` (Class A, executable).
- `docs/work-loop.md` — blocked by `docs/qc-independence.md:25/:27`, `develop-ai-resource.md:165`,
  `templates/capability-record.md:20` and the live record's three citations.
- `skills/capability-development/SKILL.md` — blocked by the template `:19`, `templates/README.md:11`,
  `docs/ai-resource-creation.md:17`.
- `docs/work-loop-spec.md` — **no live inbound reference found** (live-surface column empty; only
  self/internal and historical). The least entangled of the five.
- `.agents/skills/work-loop/SKILL.md` — tracked, re-included at `.gitignore:81`; its only live tie is
  that ignore line.

**Implications of the three options, without a recommendation:**

- **Keep the capability layer.** Preserves eight partly/uncovered method capabilities and the record's
  durable fields at zero migration cost. Costs: five files and ~2,200 lines stay live while their
  executor does not exist, so `docs/qc-independence.md` keeps routing review through a deleted
  command and the record stays unresumable. Keeping does not fix mismatch 3.
- **Fold only named gaps into a live owner.** Targets the eight capabilities above rather than the
  whole layer, and matches option C from 2026-08-01 (recorded "Not taken (Claude's recommendation)").
  Costs: a destination must be chosen for each gap; § 2 shows v2 has no durable home for three of five
  long-lived fields, and the plan's own reopening test for creating one is **not met**.
- **Retire the layer after named prerequisites.** Prerequisites are enumerated above: relocate the
  status vocabulary check 4 depends on; repoint `qc-independence.md`, `ai-resource-creation.md:17`,
  `RESOURCES.md:13`, `templates/README.md:31`; disposition the live record's open S2/S4+5 claims and
  the active mission; remove `.gitignore:81`. `docs/work-loop-spec.md` could go first and alone.

**The August 1 decision beside what has changed.**

*Materially changed by Units 1–3:* both live command routes that named `/work-loop` are repaired
(`4088df9`, `346004e`); durable AI artifacts now have a retirement owner with an operator gate, a
search-built inventory and same-search completion proof (`3c84c70`, `32d29e7`) — the standard Option A
was executed without; and `0516bf6`'s pattern is now measured, not asserted, at 13 files.

*Unchanged since August 1:* the five files still exist with no executor; the capability method's seven
load-bearing sections remain zero-of-seven fully covered; exactly one capability record exists and it
is still ACTIVE; and `templates/capability-record.md` still carries a live executable dependency.
Option C — retire only the half v2 replaces — remains untaken and is the shape § 1's split (rows 1, 3,
10, 11, 17 superseded; rows 4–9, 12–14 not) most directly supports. **This unit does not declare the
August 1 decision superseded, reaffirmed or still executable.**

**Smallest set of explicit operator choices needed next:**

1. Keep, fold or retire the capability **method** (`capability-development/SKILL.md`) — the eight
   named gaps are the object of this choice.
2. Where the **status vocabulary** lives, given `develop-ai-resource.md:57` depends on it — this
   choice is a precondition for retiring `templates/capability-record.md` under any option.
3. What happens to the **live record**: keep, fold or terminally close — and, if closing, where its
   open S2/S4+5 claims and the active mission assertion go.
4. Whether the **v1 process files** (`docs/work-loop.md`, `docs/work-loop-spec.md`,
   `.agents/skills/work-loop/SKILL.md`) are retired now on the superseded-by-v2 finding, separately
   from choice 1.
5. How the **August 1 Option A decision** is reconciled with the current evidence — the one choice
   this unit is forbidden to make.

Every file above carries an option set with constraints. No disposition was selected, no repository
change was made, and the inspection stands whichever option the operator takes.

## Blocker

None.

## Next action

Codex: assess this discovery. The five-part package is above. Two things a reader should weigh
explicitly — the plan's reopening test for a new v2 durable address is **not met** (loss at closure is
shown for three of five fields, but only one live record exists), and `docs/work-loop-spec.md` is the
only one of the five files with **no live inbound reference**, so it is separable from the rest under
any option.
