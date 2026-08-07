# Work Loop v2 — proportionality and continuity implementation plan

**Version:** v0.1. **Status:** implementation-ready; not yet executed.
**Produced by:** Work Loop task `work-loop-v2-proportionality-continuity-plan`, unit 1 (Implementation mode).
**Executes:** nothing. This document is a blueprint. No target file is edited by the unit that wrote it.

**Authority.** `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` is the contract and wins over
this plan wherever the two disagree. The operator decisions of 2026-08-07, recorded in § 1, govern the
choices this plan makes between otherwise-valid options.

---

## 0. How to read this plan

The plan is ordered so that a fresh Claude session can execute it top to bottom:

| Section | What it settles |
|---|---|
| § 1 | The governing operator decisions, and where each one is discharged |
| § 2 | Verified root causes — executable defect vs. already-lean intent |
| § 3 | Requirement → owner map: one owner per behaviour, no duplicated rule |
| § 4 | Exact amendment targets, file by file, with the current text and the change |
| § 5 | Ordered slices, with dependencies on in-flight work |
| § 6 | Proof cases that can actually fail |
| § 7 | Non-adoptions — what this plan refuses to build |
| § 8 | Risks, rollout, migration, hook-trust implications |
| § 9 | Implementation handoff |

Everything in § 2 was established by inspection during the unit that produced this plan; the inspection
record is in `logs/work-loop/work-loop-v2-proportionality-continuity-plan.md`. Line numbers are as of
2026-08-07 and are orientation, not identifiers — match on the quoted text.

---

## 1. Governing operator decisions, and where each is discharged

These are the settled decisions this plan is built to satisfy. Each is discharged in exactly one place.

| # | Operator decision (2026-08-07) | Discharged in |
|---|---|---|
| OD-1 | Do only the tasks needed to make the current thing work; aim for an 85–90% useful result; absolute perfection is not required | § 4.3 (core § 3 quality bar), § 4.4 (Codex assessment) |
| OD-2 | Skip unnecessary ceremony and duplicated testing across Codex and Claude | § 4.4 (verification assigned once), § 4.5 (prose evidence) |
| OD-3 | Separate worktrees are normally justified only for a big implementation; concurrent work in different projects must not force worktrees; same-repository collision risk, unattended work and genuinely large work may still justify isolation | § 4.7 (isolation policy), § 4.8 (dispatcher concurrency) |
| OD-4 | Work Loop v2 must not load automatically for unrelated ordinary work | § 4.1 (activation narrowing), § 4.2 (core-read sequencing) |
| OD-5 | After compaction, Codex must recover from durable authoritative context rather than drift from a lossy summary | § 4.9 (compaction hook) |
| OD-6 | Each Codex-side handoff that starts a new Codex task must prepare a clean handoff reading the plan and other named durable sources; routine Claude ↔ Codex turns already carried by the state file must not multiply visible tasks | § 4.7 (fresh-task handoff) |
| OD-7 | Project orientation must determine owning project, approved outcome and current priority, authoritative current-state source, governing specialist workflow, active phase, completed phases and accepted decisions, blockers and operator gates, work ready now, and work that is premature — and the operator-facing result is one short line | § 4.6 (orientation) |

The operator-facing orientation line, quoted verbatim from OD-7 and used as the required output shape in
§ 4.6:

```
Current position → governing workflow and phase → what is ready → what is blocked →
recommended next unit → why it matters.
```

---

## 2. Verified root causes

Each root cause below is separated into **defect in executable behaviour** (something a deployed file
actually does) and **already-lean intent in the core** (something the contract already says, which does
not need changing). Confusing the two is how this class of work grows: the core is mostly already
proportionate, and the ceremony is downstream of it.

### RC-1 — The Codex skill activates on almost any request *(executable defect)*

`.agents/skills/work-loop-v2/SKILL.md` frontmatter `description` ends:

> "Use whenever work is described without naming the capability to use, including 'continue this project'."

Codex selects skills by **implicit matching against the description** — the description is the trigger
condition, and only names and descriptions are loaded at startup, with the body loading when a skill
fires. A description whose stated trigger is "work described without naming a capability" matches nearly
every ordinary request, so the routing-and-framing skill fires on work it does not own.

**Not a core defect.** The core says nothing about activation; activation is entirely the skill file's.

### RC-2 — The executable core is loaded before ownership is established *(executable defect)*

`.agents/skills/work-loop-v2/SKILL.md` line 10:

> "**Read `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` before your first move in any task.**"

The skill's own first move is **routing** (§ Routing a request, step 1–3), and most routing outcomes are
*not* the Work Loop: the index lists 16 Axcíon command owners, 9 narrow specialists, 13 Matt skills and
6 phases, plus "the operator" and "Direct Work". The 457-line core is therefore read in full to reach a
conclusion that usually does not need it. Combined with RC-1, an unrelated request costs the skill body
plus the whole contract.

**Not a core defect.** The core does not say when to load itself; the sequencing instruction is the
skill's.

### RC-3 — Verification is not assigned to one actor *(executable defect)*

`.agents/skills/work-loop-v2/SKILL.md` § Assessing the result tells Codex to "read the result and the
evidence" and, in § Unattended runs, to separate repository facts from model claims. Nothing states that
Codex **normally does not reproduce** checks Claude already ran, and nothing names the narrow conditions
under which reproduction is justified. The absence, not a positive instruction, is what lets the same
check run twice.

**Not a core defect.** Core § 3 *The "good enough, proceed" judgment* already says Codex's job is the
executive call, "not finding more things to improve".

### RC-4 — Regression ceremony has relief but no named standard case *(executable defect)*

Both surfaces already carry the relief clause:

- Core § 3, third bullet under the mode table: "**Implementation does not demand ceremonial tests.**
  Where a change has no meaningful regression check, say so and say why, rather than inventing one that
  cannot fail (§ 6 rule 5)."
- `.claude/commands/work-loop-v2.md` line 89: "Where no meaningful regression check exists, say so and
  say why, rather than inventing one that cannot fail."

What is missing is that **prose and documentation are the standard instance of that case**, not an
exception to argue for. The result in practice is an invented check — most often a grep for a word the
brief itself contains, which the skill already names as "the commonest way a unit looks done and is not"
(SKILL.md line 283). The two statements exist and do not point at each other.

**A second instance of the same defect, on the checking side.** `.claude/commands/work-loop-v2.md` Step 2
requires an inspection record on **every** run, for **every** claim — "The record appears even when nothing
is wrong". For a unit with load-bearing premises that is exactly right. For Direct Work, or a prose change
whose only premise is text visible in the diff, it produces a block of claims invented to satisfy the
format. The relief clause covers *evidence of a change* but no clause covers *evidence of a check*, so the
one ceremony the plan's own OD-1 targets survives in the place it is least likely to be questioned.

**Not a core defect** in either instance. The core's intent is already lean — core § 6 rules 1 and 3 require
checking a claim and saying what was searched, and neither says a record must exist where there is no claim.
Only the executable phrasing needs the named cases.

### RC-5 — Nothing binds the execution checkout before the task file is created *(executable defect + product hazard)*

Repository side: the dispatcher is already checkout-safe. `dispatch.sh` canonicalises `--checkout` and
verifies it is a git checkout (lines 317–320), resolves the state file only under
`$CHECKOUT/logs/work-loop` and rejects anything that resolves elsewhere (lines 322–329), and launches
each actor inside that checkout — Claude with `cd "$CHECKOUT"` (line 1072), Codex with
`-C "$CHECKOUT"` (line 1050).

Product side: the Codex app distinguishes a **Local checkout**, a **Worktree** created from it, and a
**Handoff** that moves a chat between them; a new chat picks Local or Worktree explicitly under the
composer. The documented gap is that the docs do not describe pointing a *new, non-forked* chat at an
already-existing worktree directory. The observed hazard is `openai/codex` issue #21432 (closed): "Fork
into new worktree" and "Handoff to Worktree" created the worktree directory while the thread's terminal
kept running in the original checkout — expected `$HOME/.codex/worktrees/<id>/<repo>`, actual the local
repo. Edits intended for the isolated worktree land in the main repository.

**The consequence for the loop** is that Codex can write `logs/work-loop/{task-id}.md` into whichever
checkout it is actually in, which may not be the one the work belongs to. No rule currently forbids
resolving that by copying the file to the other checkout, which would create two files claiming to be one
task's truth.

**Not a core defect.** Core § 4 fixes the path; it does not — and should not — name a checkout.

### RC-6 — Run evidence can collide or become invisible across checkouts *(executable defect)*

Inspected in `dispatch.sh`:

| Runtime state | Construction | Scoped by |
|---|---|---|
| Lock | `LOCK_KEY="$(printf '%s\|%s' "$CHECKOUT" "$TASK" \| shasum -a 256 \| cut -c1-16)"`, `LOCK_DIR="${TMPDIR:-/tmp}/work-loop-dispatch-$LOCK_KEY.lock"` (lines 419–420) | checkout **and** task — correct |
| State file | `STATE_DIR="$CHECKOUT/logs/work-loop"` with a realpath containment check (lines 322–329) | checkout — correct |
| Actor cwd | `cd "$CHECKOUT"` / `-C "$CHECKOUT"` (lines 1050, 1072) | checkout — correct |
| **Log directory** | `SPIKE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"` (line 179); `[ -n "$LOG_DIR" ] \|\| LOG_DIR="$SPIKE_DIR/runs"` (line 607) | **the script's own location, not the checkout** |
| **Run ID** | `RUN_ID="$(date '+%Y%m%dT%H%M%S')-$TASK"` (line 619) | **timestamp to one second, plus task** |

Two consequences follow, and only these two:

- **Invisibility.** Driving checkout B with checkout A's copy of `dispatch.sh` writes B's run evidence
  into A's `runs/` directory. The evidence exists but is not where the checkout it describes would be
  searched.
- **Collision.** Two checkouts running the same task-id into a shared log directory produce the same
  `RUN_ID`, so the second run's log, hop captures and unattended-settings file overwrite the first's. The
  lock does not prevent this: the lock is per checkout+task, so two different checkouts running the same
  task-id are both legitimately unlocked.

Same-checkout, same-task concurrency is already correctly refused (exit 17, line 428).

### RC-7 — There is no compaction hook at all *(executable gap)*

`.codex/hooks.json` registers `PreToolUse`, `PostToolUse`, `SessionStart` and `Stop`. Searching it and
`.codex/config.toml` for `PreCompact|PostCompact|compact|SessionStart` matches `SessionStart` only, on
one hook (`friday-checkup-reminder.sh`) with no matcher. `.codex/config.toml` registers no hooks at all —
it carries only `[shell_environment_policy]`.

Current official Codex documentation confirms the mechanism this plan needs is supported:

- Hook events include **`PreCompact`** and **`PostCompact`** ("chat compaction"), alongside
  `SessionStart`, `SessionEnd`, `SubagentStart`, `SubagentStop`, `PreToolUse`, `PostToolUse`,
  `PermissionRequest`, `UserPromptSubmit`, `Stop`.
- Hooks are discovered from `<repo>/.codex/hooks.json` or `<repo>/.codex/config.toml` (and the
  `~/.codex/` equivalents) — the sidecar file this repo already uses is a supported location.
- `matcher` is a regex filtering different properties per event: `PreCompact`/`PostCompact` filter the
  **trigger** (`manual` or `auto`); `SessionStart` filters the **source** (`startup`, `resume`, `clear`,
  `compact`).
- Hooks receive JSON on stdin with `session_id`, `transcript_path`, `cwd`, `hook_event_name`, `model`,
  `permission_mode`; turn-scoped hooks add `turn_id`.
- Context injection back to the model is supported through `hookSpecificOutput.additionalContext`
  (developer context) and `systemMessage`, with `additionalContextLimit` defaulting to about 2,500 tokens
  before the full text is spilled to disk. These fields are available on `SessionStart`, `PreCompact`,
  `PostCompact`, `UserPromptSubmit`, `SubagentStart` and `PostToolUse`.

**No stop condition fires.** The brief's stop condition "a required mechanism is unsupported by current
official Codex behaviour" does not apply: the compaction mechanism is supported as documented.

### RC-8 — Fresh-task continuity is required but its shape is unspecified *(partial coverage)*

Already present, and **not** to be rebuilt:

- `context-engineering-spec-v0.1.md` **CE-9** (line 663) with its *fresh-session recovery* clause
  (lines 671–681): recovery happens inside the single preparation pass, is not a stage, and recovers seven
  things — current operator request, canonical governing plan, applicable approved workflows,
  authoritative current state, material settled decisions, unresolved blockers, next justified unit.
  Conversational memory may locate a source; it cannot establish authority or current state. CE-9 also
  fixes the evidence design: a **memory-only control**, with a material fact present in the durable
  sources and absent from the conversation.
- **CE-15** (line 811): one execution handoff artifact per unit, two audiences; the test is duplication,
  not mention.
- `SKILL.md` line 307 carries CE-9's recovery into the skill; line 291 carries CE-15.

Missing: which Codex-side transitions **start a new task at all**, whether a fresh task or a
transcript-preserving fork is used, how Local-versus-worktree is selected at that moment, and the
requirement that the new task's *first action* is to read the named durable sources. Also missing: the
explicit statement that ordinary Claude ↔ Codex turns carried by the state file do **not** open a new
visible task.

### RC-9 — Project orientation exists as a routing rule, not as an output *(partial coverage)*

`SKILL.md` line 135 already requires "Continue this project" to read the project's governing workflow and
authoritative current state, to map position in the project's own phase model and vocabulary, to rename
nothing, and to "never create a document, list or state entry to hold the mapping".

Missing: OD-7's determinations as a checklist of what must be established, the short operator-facing
output line, and the boundaries at which orientation fires.

`/project-next-steps` is a **different capability and stays separate.** It is Claude-side, operator-facing,
takes a project argument, runs a token-lean read cascade (Step 2, lines 46–86: plan spine → current
position → supporting context → git ground-truth check), prints a four-part A–D report inline, and writes
nothing anywhere (Step 4, lines 129–132). Its Step-2 cascade is already reused by `/prime` Step 1c with one
deliberate documented inversion (lines 64–68). The reuse this plan authorises is of that **cascade
approach** — the same discipline `/prime` already borrows — and nothing else. The two capabilities do not
merge, and orientation produces no report file.

---

## 3. Requirement → owner map

One owner per behaviour. Where a second file mentions the behaviour it does so by pointer only, and no
rule is stated twice.

| Req. (from the brief) | Behaviour | Single owner | Pointer-only elsewhere |
|---|---|---|---|
| 3 | When the Codex skill activates | `.agents/skills/work-loop-v2/SKILL.md` — frontmatter `description` | — |
| 3 | When the executable core is read | `SKILL.md` — the opening instruction, relocated into Routing | — |
| 4 | The 85–90% quality target and "minimum necessary work" | core § 3 *The "good enough, proceed" judgment* | `SKILL.md` § Assessing (pointer); `.claude/commands/work-loop-v2.md` (pointer) |
| 4 | No adjacent improvements mid-unit | core § 5 *Deferral* + command Step 4 — **already exists, unchanged** | — |
| 5 | Verification runs once; when Codex may reproduce | `SKILL.md` § Assessing the result | — |
| 6 | Prose/documentation is the standard no-regression-check case | `.claude/commands/work-loop-v2.md` § The unit's mode → Implementation | core § 3 relief clause (unchanged, cited) |
| 6 | When an inspection record is required, and when it may be absent | `.claude/commands/work-loop-v2.md` **Step 2** | `logs/scripts/work-loop-v2-slice-1.test.sh` follows it — it does not define it |
| 7 | Project-pipeline orientation and its output line | `SKILL.md` § Routing → "Continue this project" | — |
| 8 | The checkout is bound before the task file exists; a mismatch stops; never copy | `SKILL.md` § The seam | `dispatch.sh` containment check (already enforced, unchanged) |
| 9 | Runtime state is checkout-scoped and cannot collide | `dispatch.sh` — `LOG_DIR` default and `RUN_ID` | — |
| 10 | *Which* pointers survive a compaction | `AGENTS.md` § *Compaction* — the existing preservation list, extended | — |
| 10 | Re-reading them afterwards, and the checkout identity | `.codex/hooks.json` (one `SessionStart`/`compact` entry) + new `.codex/hooks/work-loop-reorient.sh` | — |
| 11 | Clean new-Codex-task handoff, local vs. worktree, cwd verification | `SKILL.md` § The seam → *Starting a new Codex task* | — |

**Nothing in this map changes the state file's five-field ceiling, adds a frontmatter key, or adds a
lane, unit kind or mode.**

---

## 4. Exact amendment targets

Each subsection gives the file, the anchor text to match, and the change. Where wording is prescribed it
is because the wording *is* the behaviour (a frontmatter description, a hook field name); elsewhere the
implementer chooses the phrasing.

### 4.1 — Narrow the Codex skill's activation *(OD-4, req. 3)*

**File:** `ai-resources/.agents/skills/work-loop-v2/SKILL.md` — frontmatter `description` only.

**Replace** the trigger sentence:

> "Use whenever work is described without naming the capability to use, including 'continue this project'."

**With** a description that carries positive triggers and explicit non-triggers. Required properties, in
order of importance:

1. **Positive triggers, named — and this is a closed list, not an illustrative one:**
   - an explicit request for the Work Loop by name;
   - an existing `logs/work-loop/{task-id}.md` task, hand-off or assessment to act on;
   - the explicit continuation and orientation shapes — "continue this project", "what is next on this
     project";
   - a request that specifically asks Codex to frame a bounded unit for another actor to execute.
2. **Explicit non-triggers, named:**
   - **an ordinary repository or project change described in natural language without naming a
     capability** — this is Direct Work and must not load the Work Loop;
   - a request that names a command, skill or agent to run;
   - a question answered by reading or explaining, with no repository change;
   - a small reversible fix;
   - work already inside another skill's flow.
3. **Front-loaded**, because a host may shorten the description, and length-capped — Codex loads all skill
   descriptions at startup under a shared budget of roughly 2% of the context window.

The `description` remains the *only* activation control. Do not add a second gate, a router file, or an
activation allowlist.

**What this deliberately gives up, and why that is the point.** The v0.1 draft of this section kept
"bounded repository or project work that no specific capability was named for" as a positive trigger. That
is the catch-all: it makes the Work Loop load whenever the operator speaks in ordinary language, which is
almost always, and it is the direct cause of RC-1. It is removed. Ordinary implementation work described
without naming a capability is **Direct Work** and must not activate the skill; the operator reaches the
loop by naming it, by pointing at an existing task, or through the two continuation shapes.

**Failure mode this must not create:** the four positive triggers must keep firing — in particular
"continue this project" and existing-task pickup — and the non-triggers must describe request *shapes*,
never subject matter. Under-activation now means one of those four stopped working, not that an unnamed
ordinary request was let through.

### 4.2 — Sequence the core read after ownership *(OD-4, req. 3)*

**File:** same `SKILL.md`. **Anchor:** line 10, "Read `…executable-core-v0.1.md` before your first move in
any task."

**Change:** move the obligation from *before the first move* to *before the first Work-Loop-owned move* —
that is, after § Routing step 3 has selected the Work Loop as the owner. Routing itself, admission, and
sending the operator to another owner do not require the core.

Two constraints the implementer must respect:

- **Routing steps 1–3 must remain executable without the core.** Check this by reading the Routing section
  in isolation: if a step's rule can only be applied by consulting the core, the split is in the wrong
  place and the read must stay in front of it.
- **Admission (core § 2) is reached only after step 3 selects the Work Loop** — the skill already says so
  ("Where any other capability owns it, admission does not arise"). So the core read sits between step 3
  and step 4, and mode classification (step 4) is already downstream of it.

Where the harness cannot express deferred loading, the plan's requirement is satisfied by the instruction
alone — this is an instruction change, not a harness feature request.

### 4.3 — Make proportionality enforceable in the contract *(OD-1, req. 4)*

**File:** `ai-resources/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`, § 3 *The "good
enough, proceed" judgment*.

**Current text (unchanged in substance, extended):**

> "At assessment, Codex's job is the executive call — *is this good enough to move on?* — not finding
> more things to improve. The quality bar is pilot quality with limitations written down, not
> completeness."

**Add**, in the same section, four statements — the smallest set that makes OD-1 checkable:

1. **The target is a useful 85–90% result.** Absolute completeness is not the bar and is not a reason to
   continue a unit.
2. **Minimum necessary work.** A unit does only what its completion condition requires. Work that would
   improve the result without being needed to satisfy the completion condition is a deferral (§ 5), not
   part of the unit.
3. **Evidence is scaled to consequence.** The evidence must be able to fail (§ 6 rule 5); it is not
   required to be exhaustive. A larger check than the consequence warrants is ceremony.
4. **There is no perfection pass.** A correction round exists (§ 3 *Correcting once*) and is frozen to the
   assessment's named findings. Nothing else re-opens a unit.

**Amendment discipline.** The core's header still reads *draft for operator approval*. Follow the
precedent already set by the courier clause (core § 4): append a dated note saying the clause was approved
on its own and that the header is deliberately unchanged. Do not silently promote the whole document.

**No pointer duplication.** `SKILL.md` and `.claude/commands/work-loop-v2.md` cite this section; neither
restates the four statements.

### 4.4 — Assign verification once *(OD-2, req. 5)*

**File:** `ai-resources/.agents/skills/work-loop-v2/SKILL.md`, § *Assessing the result*.

**Add** one short block stating the division and its exceptions:

- **Claude runs the checks and reports the evidence. Codex assesses the evidence.** Re-running a check
  Claude has already run and reported is the duplicated testing OD-2 excludes, and it is not diligence.
- **Codex may reproduce a check only under these conditions**, and says which one applies when it does:
  1. The reported evidence is **internally inconsistent** — the stated result and the quoted output
     disagree.
  2. The evidence **cannot fail as written** (core § 6 rule 5) — for example it greps for a word the brief
     itself supplied. Codex's move here is to name the defect, not to substitute a better check.
  3. The claim is **hard to reverse or consequential** (core § 7) and a wrong acceptance would be
     expensive to undo.
  4. The unattended path reported a **repository fact Codex can read directly** — `turn:`, the commit, the
     exit code — which is reading the file, not re-running Claude's check.
- The existing rule in § *Unattended runs* — "*the dispatcher observed exit 0*" is a repository fact,
  "*Claude reports the tests passed*" is a claim — is retained unchanged and is what makes this division
  legible.

### 4.5 — Remove prose regression ceremony *(OD-2, req. 6)*

**File:** `ai-resources/.claude/commands/work-loop-v2.md`, § *The unit's mode*, the **Implementation**
bullet (line 89).

**Current text:**

> "**Implementation** — build it, and return the failing case, the implemented result, and the regression
> protection relevant to the change. Where no meaningful regression check exists, say so and say why,
> rather than inventing one that cannot fail (core § 6 rule 5)."

**Change:** keep the sentence, and name the standard case so it stops reading as an exception to argue
for. Required content:

- **A prose, documentation or instruction-file change is the ordinary instance of "no meaningful
  regression check".** The expected evidence is the changed text quoted against what it replaced, plus a
  one-line statement of why no automated check would distinguish success from failure.
- **A check that greps for a word the brief already contains is not evidence.** This is already named on
  the Codex side (`SKILL.md` line 283); the command file cites it rather than restating it.
- **Where the artifact is executable** — a script, a hook, a test harness — the failing case is still
  required, unchanged.

#### Step 2's inspection record becomes proportional too

**The v0.1 draft ring-fenced this and was wrong to.** It argued the record must stay mandatory on every run
because `logs/scripts/work-loop-v2-slice-1.test.sh` binds to it. That reasoning is circular: the harness is
this project's own implementation, not operator authority, so "the test asserts it" cannot be the reason
the behaviour is right. The harness follows the contract; it does not set it.

**What survives, unchanged.** Premise checking itself. Where a load-bearing claim is uncertain and could
change the work, it is checked by inspection before acting, and what was inspected is written down —
core § 6 rules 1 and 3 are untouched, and § 4.3's proportionality clause never licenses skipping a check
that could change the outcome.

**What becomes proportional.** The *record*, scaled to the unit:

- **A unit with load-bearing claims** — every claim still gets its line, including the ones that hold. No
  change.
- **Direct Work** — no state file exists, so no record arises. Already true; stated so it cannot be read
  back the other way.
- **A simple prose or documentation change with no meaningful premise to test** — the record may be
  **absent**. In its place, one line saying there was no load-bearing premise to check. That line is
  cheaper than a fabricated claim and more honest than a record listing claims invented to fill it.

**The judgment, stated so it cannot slide.** The question is not "is this unit small?" but "would being
wrong about a premise here change the work?" A one-line prose fix that rests on a file existing where the
brief says it does still has a premise worth checking. A documentation rewrite whose only premise is the
current text — visible in the diff — does not.

**Amendments this requires, named:**

- `ai-resources/.claude/commands/work-loop-v2.md` **Step 2** — the rule currently reads "Every claim gets a
  line, including the ones that hold. The record appears even when nothing is wrong". Keep that sentence
  for units that have claims, and add the two cases above where the record is legitimately absent, with the
  one-line no-premise statement replacing it.
- `ai-resources/logs/scripts/work-loop-v2-slice-1.test.sh` — cases **1.2a** and **2.1** assert that a
  record was written. Both run against fixtures that *do* carry claims (`fixture-slice1-true.md`,
  `fixture-slice2-fresh.md`), so both stay valid and need no change. What the harness lacks is the opposite
  case, and adding it is the amendment: a no-premise prose fixture whose run legitimately produces no
  record. Without it the harness silently keeps asserting the old universal rule the moment anyone
  generalises those two cases.

**The trap this must not fall into.** Do not replace the removed record with a new mandatory artifact — a
"proportionality statement", a justification field, or a checklist asking which tier applies. That would
trade one ceremony for another and cost more than the record it replaced. The absence of a record *is* the
lighter path; if implementing it produces something to fill in on every run, the implementation has failed
and P-3a is what catches it.

### 4.6 — Add project-pipeline orientation *(OD-7, req. 7)*

**File:** `ai-resources/.agents/skills/work-loop-v2/SKILL.md`, § *Routing a request* → the
"Continue this project" paragraph (line 135). **Extend that paragraph; do not add a section, a stage or a
document.**

**What orientation must establish** (OD-7, in one pass, from durable sources only):

owning project · approved outcome and current priority · authoritative current-state source · governing
specialist workflow · active phase · completed phases and accepted decisions · blockers and operator gates ·
work ready now · work that is premature or unauthorised.

**What it returns to the operator** — one line, in the shape OD-7 fixed:

```
Current position → governing workflow and phase → what is ready → what is blocked →
recommended next unit → why it matters.
```

**When it fires** — four boundaries, and no others:

1. **Continuation** — an accepted unit opens the next one in the same task (core § 3 *Continuing*).
2. **Fresh task** — a new Codex task picks up existing work (§ 4.7).
3. **Post-compaction** — the reorientation of § 4.9 has fired.
4. **Material context change** — a new operator decision, an operator approval, or verified evidence has
   changed durable project understanding. This is CE-16's own "routine invocation" test read the other
   way round: a routine invocation is precisely one where none of those changed, and a routine invocation
   does not re-orient.

**Constraints, all binding:**

- Orientation happens **inside the single preparation pass** (CE-9), like fresh-session recovery. It is
  not a stage, a gate or a checklist the operator sees.
- **It writes nothing.** No orientation file, no phase copy, no state entry. The nine determinations are a
  judgment made fresh from durable sources each time — the existing prohibition at line 135 is unchanged
  and now covers the determinations too.
- **Reuse, do not merge.** Borrow `/project-next-steps` Step 2's read cascade *approach* — plan spine,
  then authoritative position, then only what bears on the next step, stopping as soon as position is
  certain. `/project-next-steps` remains the Claude-side operator-facing resume briefing with its own A–D
  report; orientation is a Codex-side line inside a reply or brief. Neither calls the other.
- **The project's own vocabulary is used.** Phases are never renamed. Where a project has no phase model,
  the existing fallback spine at line 135 applies, unchanged.

### 4.7 — Bind the checkout, and define the fresh-task handoff *(OD-3, OD-6, reqs. 8 and 11)*

**File:** `ai-resources/.agents/skills/work-loop-v2/SKILL.md`, § *The seam*.

#### 4.7a — Checkout binding *(req. 8)*

Three rules. They add no state field, because **the task file's location is the binding**: the checkout is
the one that holds `logs/work-loop/{task-id}.md`.

1. **Select and verify the checkout before the task file is created.** Before writing a new state file,
   Codex confirms the working directory it is actually in — not the one it intended — and that this is the
   checkout the work belongs to. This is the concrete guard against issue #21432, where a thread's terminal
   kept running in the original checkout after a worktree was created.
2. **Both actors verify at every handoff.** Codex verifies before writing; Claude's Step 1 already
   validates the file's identity read-only and resolves it under the checkout it is running in. The
   dispatcher already enforces the same containment (`dispatch.sh` lines 322–329) and needs no change.
3. **A mismatch stops. The task file is never copied to another checkout as a repair.** Copying produces
   two files claiming one task's truth, which is the failure the single-interface rule (core § 4) exists
   to prevent. Report the mismatch and hand the decision to the operator (core § 7).

#### 4.7b — Isolation policy *(OD-3)*

State the policy where the decision is actually made — at the point a new task or run starts:

| Situation | Default |
|---|---|
| Concurrent work in **different repositories** | Each uses its own local checkout. **No worktree.** |
| Ordinary work in one repository, one writer | Local checkout. |
| **Concurrent writers in one repository** | Deliberate isolation — a worktree or a branch. |
| **Unattended run** | Isolation, on a branch off a clean tree (already required by § *Unattended runs*). |
| **Genuinely large implementation** | Isolation. |

A worktree is a cost, not a default. This table is the whole policy; do not add a decision procedure.

#### 4.7c — Starting a new Codex task *(OD-6, req. 11)*

**When a new task is started at all.** Only where the *thread* has ended or must end: a fresh session, a
compaction that lost the thread, a deliberate hand-off to a new task. **Ordinary Claude ↔ Codex turns
carried by the state file do not open a new task** — the state file is the interface (core § 4), and
multiplying visible tasks for a routine turn is exactly the ceremony OD-6 excludes.

**Prefer a genuinely fresh task over a transcript-preserving fork.** A fork carries conversational memory,
and conversational memory cannot establish authority or current state (CE-9). A fresh task is forced to
read the durable sources, which is the property wanted.

**Select Local or Worktree explicitly**, per § 4.7b, at the moment the new chat is created — the Codex app
asks for this choice under the composer, so it is always an explicit act.

**Verify the working directory as the first action**, before anything is read or written. Do not infer it.

**First substantive action reads the named durable sources**, in this order: the state file
`logs/work-loop/{task-id}.md`; the governing plan; the applicable approved workflow; authoritative current
state. Then re-establish CE-9's seven recovery items inside the same preparation pass.

**The fallback, named because the mechanism has a documented gap.** Codex's documentation does not describe
pointing a *new, non-forked* chat at an already-existing worktree directory; it documents choosing Local or
Worktree when the chat is created, and creating a worktree from the local checkout. So where the work must
continue in an existing worktree:

> Open that worktree directory as a **Local** checkout for the new task — that is, treat the permanent,
> user-created worktree as its own local checkout — and verify the working directory as the first action.
> Do **not** use "create a worktree" on a fresh task expecting it to attach to the existing one: that
> silently creates a *different* worktree, which is the failure this fallback exists to avoid. Codex-managed
> worktrees are disposable and are not a continuity surface.

### 4.8 — Make dispatcher runtime state collision-proof *(OD-3, req. 9)*

**File:** `ai-resources/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`.
**Blocked on:** the still-open `work-loop-v2-contained-unattended-profile` task (§ 5, S0).

Two changes, and only these two. Everything else inspected in RC-6 is already correct and must not be
touched.

**(a) Default the log directory to the checkout, not the script's location.**

Current: `[ -n "$LOG_DIR" ] || LOG_DIR="$SPIKE_DIR/runs"` (line 607), with
`SPIKE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"` (line 179).

Required behaviour: with no `--log-dir`, run evidence lands under the **checkout being driven**. An explicit
`--log-dir` still wins. `--status` reports the same directory it would use (line 590 already mirrors the
default and must be kept in step with it).

Migration: existing logs under `handoff-automation-spike/runs/` stay where they are; nothing is moved. The
README's worked invocation is updated in the same slice if it depends on the old default.

**(b) Discriminate the run ID.**

Current: `RUN_ID="$(date '+%Y%m%dT%H%M%S')-$TASK"` (line 619).

Required behaviour: two runs of the same task-id, started in the same second, from **different checkouts**,
into a **shared** log directory, must not overwrite each other's `.log`, `.hopN.<actor>.out`, or
`.unattended-settings.json`. The natural discriminator is already computed — `LOCK_KEY` is
`sha256(checkout|task)` truncated to 16 characters (line 419) — so a short checkout discriminator plus the
dispatcher pid is sufficient and adds no new concept. Keep the timestamp first so the directory still sorts
chronologically.

Same-checkout, same-task concurrency stays refused by the lock (exit 17); this change does not weaken it.

### 4.9 — Post-compaction reorientation *(OD-5, req. 10)*

**Files:** `ai-resources/AGENTS.md` § *Compaction* (amend — the preservation owner),
`ai-resources/.codex/hooks.json` (amend — one registration) and
`ai-resources/.codex/hooks/work-loop-reorient.sh` (new, small, read-only).

**The v0.1 draft's design was wrong in two ways, and this section replaces it.** It registered *two*
events, so one compaction produced two reorientations; and it identified the active task by scanning
`logs/work-loop/*.md` for every open `turn:`.

Run that scan against this repository and it returns **18 files** — five real open tasks and **thirteen
test fixtures**, because the acceptance-harness fixtures under `logs/work-loop/` carry a `turn:` line by
construction. So the design could not name *the* active task, and worse, it would have injected fixture
task names and fixture next-actions into a live session as though they were work. A reorientation that
points at `fixture-slice2-foreign.md` is not a smaller version of the right answer; it is a wrong one, and
it arrives at precisely the moment the model has lost the context needed to notice.

The correction splits the job between an existing owner and a much smaller hook.

#### Who preserves what

**The session's own active pointers are preserved by the existing compaction authority, not discovered by
the hook.** `ai-resources/AGENTS.md` § *Compaction* (lines 70–77) already names what must survive a
compaction, in exactly this shape:

> "When `/compact` fires, preserve: … Auto-compact defaults drop these by priority; name them explicitly so
> they survive."

**Amend that list** — it is an existing owner, so this satisfies "prefer amendments to existing owners" and
adds no artifact. Add, as further bullets, the Work Loop pointers OD-5 names:

- the **exact active** `logs/work-loop/{task-id}.md` path;
- the **bound checkout** the task is running in;
- the **governing plan** path, and the **workflow and phase**;
- the current **`## Next action`**.

Preserving them is what makes them *the session's own* — the model already knows which task it is on, so
nothing has to be inferred from the filesystem.

#### The one registration

**One event, `SessionStart` with matcher `compact`.** Added to `.codex/hooks.json` in the shape the file
already uses (`type: command`, absolute `bash '<path>'`, `timeout`, `statusMessage`). The existing
unmatched `SessionStart` entry (`friday-checkup-reminder.sh`) is left exactly as it is.

Why this event and not `PostCompact`:

- It is the only one of the two whose documented output supports
  **`hookSpecificOutput.additionalContext`**, the field that adds developer context back to the model.
  `PostCompact` documents `continue`, `stopReason`, `systemMessage` and `suppressOutput` — no
  `additionalContext`. Choosing `PostCompact` would mean choosing the event that cannot do the job.
- The documentation states that after Codex compacts a root session, `SessionStart` hooks matching
  `source: "compact"` run **before the next model request** — which is the moment reorientation has to
  land.
- It does not distinguish manual from automatic compaction, so one registration covers both, which is what
  OD-5 asks for. `PostCompact`'s `manual`/`auto` matcher is what tempted the v0.1 draft into a second
  registration; it buys nothing here.

`PreCompact` is still **not** registered — it runs before the loss and has nothing to re-inject.

#### What the script emits

JSON on stdout carrying `hookSpecificOutput.additionalContext`, containing only:

1. The **checkout identity** — the `cwd` the hook received on stdin, plus the git common dir, so a worktree
   is distinguishable from its local checkout. This is the one fact the hook genuinely holds and the
   session cannot restate for itself.
2. One **instruction**: re-read the active Work Loop pointers preserved under `AGENTS.md` § *Compaction* —
   the task file, the governing plan, the workflow and phase, and the next action — from disk, before the
   next move; do not continue from the compacted summary.

**Hard constraints on the script:**

- **It does not identify the task.** No scan of `logs/work-loop/`, no `turn:` search, no "most recently
  modified" heuristic, no registry, no state field, no cache. Where the preserved pointers are missing, the
  correct behaviour is to say the pointers are missing — not to go looking.
- **Pointers and an instruction, never a summary.** A paraphrase would be a second, lossy copy of the truth,
  which is the drift OD-5 exists to prevent.
- **It writes nothing** and reads no repository file. Read-only, and in practice it touches only its stdin.
- **It never decides.** It does not choose a task and it does not set `turn:`.
- **Budget.** `additionalContextLimit` defaults to roughly 2,500 tokens. This output is two short items, so
  the limit is not a live constraint — which is itself a benefit of not emitting quoted file content.
- **Fail open.** A missing field, an unreadable stdin or a `jq` absence exits 0 with no `additionalContext`.
  A reorientation hook that blocks a session is worse than one that is silent.

**What this gives up, stated plainly.** The hook no longer tells the model *which* task it was on. That job
moved to the preservation rule, where it belongs: the compacting session knows its own task, and a hook
firing afterwards can only guess. A guess that names the wrong task is worse than no name at all.

---

## 5. Ordered slices

Each slice is independently committable and independently provable. The order is by dependency, then by
value per unit of risk.

| Slice | Content | Depends on | Proof case |
|---|---|---|---|
| **S0** | *(precondition, not work)* the open `work-loop-v2-contained-unattended-profile` unit reaches its closing record | — | its own |
| **S1** | § 4.1 activation narrowing + § 4.2 core-read sequencing | — | P-1 |
| **S2** | § 4.3 core § 3 proportionality clause | — | P-2a |
| **S3** | § 4.4 verification assigned once + § 4.5 prose evidence **and the proportional inspection record** (command Step 2 + the acceptance harness) | S2 (cites it) | P-2, P-3, P-3a |
| **S4** | § 4.7 checkout binding, isolation policy, fresh-task handoff | — | P-4, P-8 |
| **S5** | § 4.6 orientation | S4 (fresh-task boundary) | P-9 |
| **S6** | § 4.9 `AGENTS.md` preservation list + **one** `SessionStart`/`compact` registration + script | — | P-7 |
| **S7** | § 4.8 dispatcher `LOG_DIR` + `RUN_ID` | **S0** | P-5, P-6 |

**S1 first, deliberately.** It is the only change that reduces cost on requests the loop does not own,
which is every request OD-4 is about. It is also the lowest-risk: one frontmatter field and one relocated
instruction, both reversible in a single commit.

**S7 last, deliberately.** `dispatch.sh` is owned by another Work Loop task that is still open, and that
task carries an unresolved operator decision which may itself change the same file. S7 does not start until
that task is reduced to its closing record.

**Dependencies on in-flight work, stated explicitly** — this list moved during the session that wrote this
plan, and the movement is why the implementer re-checks it rather than trusting it:

- `logs/work-loop/work-loop-v2-contained-unattended-profile.md` — **open**, `turn: operator`,
  Implementation mode. It owns `dispatch.sh`, `dispatch.test.sh`, the spike `README.md`, and the unattended
  guidance inside `SKILL.md`. Its 246-, 309- and 71-line working-tree changes to those files were
  **committed during this planning session** (`9c66f26`, `0259275`), so the paths are now clean — but the
  task is not closed: its active fields survive, and `## Next action` holds a three-option operator decision
  about the unattended sandbox's Git-config reads, two of whose options change `dispatch.sh` again.
  **S7 is blocked by that decision, not by a dirty tree.**
- **S1, S3, S4 and S5 all edit `SKILL.md`** — in different sections from each other and from the unattended
  guidance, but the implementer re-reads the file immediately before each edit rather than working from this
  plan's quoted line numbers.
- `logs/work-loop/project-progression-candidate-review-correction.md` — modified in the tree; touched by
  no slice here.
- `logs/friction-log.md` — modified by a `PostToolUse` hook during any session in this repository. Never
  staged by these slices, and already covered by the dispatcher's `--allow-path` guidance.

---

## 6. Proof cases

Each case names the failing witness first. A case that would pass whether or not the change happened is
not listed.

**P-1 — False activation** *(S1)*
*Fails today if:* in a fresh Codex thread, **any** of these activates `work-loop-v2` and pulls in the
executable core — (a) an unnamed ordinary implementation request, phrased as the operator normally phrases
one ("add a follow-up date to the contact model"); (b) a request that names a capability ("run
/token-audit on this repo"); (c) an ordinary read-only question.
Case (a) is the one this correction adds, and it is the case the v0.1 draft would have *passed* while the
defect remained: the removed catch-all trigger made (a) a positive trigger by design.
*Passes when:* none of (a), (b) or (c) activates the skill, **and** all four positive triggers still do —
naming the Work Loop; pointing at an existing `logs/work-loop/{task-id}.md`; "continue this project" /
"what is next on this project"; and asking Codex to frame a bounded unit for another actor.
*Read differently how:* activation is observable — the skill either fired or it did not. Run all seven
shapes. Suppressing (a) while also suppressing any of the four positive triggers is an over-correction and
fails this case just as loudly as the original defect.

**P-2 — Duplicated verification** *(S3)*
*Fails today if:* Codex's assessment reply re-runs a grep or a script whose result Claude already reported
in `## Latest result`, without naming one of § 4.4's four conditions.
*Passes when:* the assessment reads the evidence and names a condition on the occasions it does reproduce.
*Control that makes it fail-capable:* include one hand-back whose evidence **is** internally inconsistent.
A rule that suppressed reproduction unconditionally would wrongly pass that one — it must still trigger
reproduction under condition 1.

**P-2a — Proportionality is stated where it can be cited** *(S2)*
*Fails today if:* core § 3 contains no 85–90% target, so an assessment demanding completeness has nothing
to be checked against.
*Passes when:* the four statements are in core § 3 and neither `SKILL.md` nor the command file restates
them. *Fail-capable in both directions:* a restatement in a second file fails the no-duplicate-rules test
just as an absent statement fails the first.

**P-3 — Prose test ceremony** *(S3)*
*Fails today if:* a documentation-only unit returns as evidence a grep for a term the brief itself
supplied.
*Passes when:* the evidence is the changed text quoted against what it replaced, plus one line on why no
automated check distinguishes success from failure.
*Guard against over-correction:* run a second unit that changes a shell script. It must still return a
failing case. A change that let the script unit skip its failing case has broken core § 6 rule 5.

**P-3a — The inspection record is proportional, and nothing replaced it** *(S3)*
*Fails today if:* a documentation-only unit with no load-bearing premise still has to write a full
`Inspected (YYYY-MM-DD):` block, listing claims that were invented to fill it.
*Passes when:* that unit's `## Latest result` carries one line stating there was no load-bearing premise to
check, and no `Inspected` block — **and** a unit that does carry claims still writes a line for every one
of them, including those that hold.
*The over-correction this exists to catch:* run a third unit and inspect what the change actually asks for
on every run. If the implementation introduced a proportionality statement, a tier label, a justification
field or any other thing to fill in each time, it has swapped one ceremony for another and **fails** —
even though the `Inspected` block is gone.
*Fail-capable how:* all three observations are binary and read off the committed state file — the block is
present or absent, the per-claim lines are complete or not, and the new mandatory field either exists or
does not.
*Harness half:* `logs/scripts/work-loop-v2-slice-1.test.sh` gains the no-premise fixture case described in
§ 4.5. It must fail before that slice ships and pass after.

**P-4 — Wrong-checkout handoff** *(S4)*
*Fails today if:* with `logs/work-loop/{task}.md` present in checkout A and Codex operating in checkout B,
the run proceeds — or the file is copied into B.
*Passes when:* the mismatch stops, and `B/logs/work-loop/{task}.md` does not exist afterwards.
*Fail-capable:* `ls` on the second path is a binary observation. Construct the case from a real worktree so
it reproduces issue #21432's shape rather than a simulated one.

**P-5 — Cross-project concurrency** *(S7)*
*Fails today if:* checkout A's `dispatch.sh` is used to drive checkout B and B's run evidence appears under
A's `runs/` directory.
*Passes when:* with no `--log-dir`, each checkout's evidence appears under that checkout, and the locks
(already `sha256(checkout|task)`) remain distinct.
*Fail-capable:* the observation is which directory the `.log` file is in.

**P-6 — Same-repository / same-task-id concurrency** *(S7)*
*Fails today if:* two checkouts run the same task-id into one shared `--log-dir` within the same second and
the second run's `.log`, hop captures and unattended-settings file overwrite the first's.
*Passes when:* all files from both runs survive with distinct names.
*Regression to keep:* two dispatchers on the **same** checkout and task must still exit 17. A change that
made run IDs unique by weakening the lock has failed this case, not passed it.

**P-7 — Post-compaction recovery** *(S6)*
*Fails today if:* after `/compact`, the model's next move proceeds from the compacted summary and does not
re-read the state file.
*Passes when:* the next move opens the **exact** active task file, the governing plan and the workflow/phase
source before acting, and its first action matches that file's `## Next action`.
*Control, without which this proves nothing:* CE-9's design applies here too. Construct the case so the
durable sources hold **one material fact the transcript does not carry**, then compact and observe whether
that fact reaches the next move. Also run the same compaction with the hook unregistered — if the two
outcomes are indistinguishable, the trial has measured nothing.
*Second witness — the one the correction adds, and it must fail on the v0.1 design.* Run the case in a
repository with **at least three open Work Loop tasks** (this repository qualifies today). The v0.1 design
scanned for every open `turn:` and reported them all, so it would have injected three task pointers where
one was active — and this witness is what exposes that. **Passes only when exactly one task is reoriented
to: the one the session was on.** A design that names several, or that names the wrong one, fails here even
though it would have looked healthy in a single-task repository.
*Third, cheapest witness:* the hook's own stdout. Run the script by hand with a synthetic stdin payload and
confirm it emits the checkout identity and the re-read instruction — and that it emits **no task path at
all**, because identifying the task is no longer its job. A script that names a task has regressed to the
v0.1 design.
*Fourth witness, on the preservation half:* compact a session and inspect the retained context for the four
`AGENTS.md` pointers. If they did not survive, the hook's instruction points at nothing and S6 is not done,
whatever the hook emits.

**P-8 — Fresh-task recovery** *(S4)*
*Fails today if:* a new Codex task given a one-line continuation request produces a brief drafted from the
request and conversational memory, omitting a material governing source.
*Passes when:* the brief carries a fact present only in the durable sources, and the working directory was
verified before anything was read.
*Control:* CE-9's memory-only control — the same request answered without opening the durable sources. If
the two briefs are indistinguishable, the case proved nothing.

**P-9 — Project orientation** *(S5)*
*Fails today if:* a continuation boundary produces no orientation line, or produces one in vocabulary the
project does not use, or a new file appears to hold the mapping.
*Passes when:* the six-part line is present in the project's own phase vocabulary, and `git status` shows
no file created beyond the state file.
*Fail-capable:* the file-creation half is a plain `git status` observation and can only pass by the change
having happened.

---

## 7. Non-adoptions

Refused deliberately. Each would be a plausible answer to something in § 2, and each is rejected on a
stated ground.

| Refused | Ground |
|---|---|
| A new command, or a new agent | Every behaviour has an existing owner (§ 3). "Prefer amendments to existing owners." |
| A new state field for the bound checkout | The task file's location **is** the binding (§ 4.7a). A field would be a second, driftable copy. |
| A new frontmatter key, lane, unit kind or mode | The mode contract is closed at three; core § 4's five-field ceiling is unchanged. |
| An `Activated failure modes` field | Failure modes enter existing constraints, evidence and stop conditions where material, and nowhere else. |
| A risk registry, alignment gate or QC stage | CE-16 forbids a context-QC pass, an alignment gate, a review stage and a decision register by name. |
| A session diary, context pack, or handoff document | CE-15: one execution handoff artifact per unit. CE-16 failing case B: no per-run persistence. |
| A maintained project-phase copy, or a workflow state machine | § 4.6: orientation is a judgment made fresh from durable sources; the existing prohibition is unchanged. |
| Merging orientation with `/project-next-steps` | Different capability, different side, different audience, different output. Reuse of the read cascade only (§ 4.6). |
| Promoting run evidence to task truth | Plan, state file and brief remain the semantic continuity system. Core § 4: a courier's output is never authoritative. |
| A broad test suite for these changes | § 6 specifies the smallest proof per change. A suite would be the ceremony OD-2 excludes. |
| A `PreCompact` hook | It fires before the loss and has nothing to re-inject (§ 4.9). |
| A `PostCompact` registration alongside `SessionStart` | Two events, one compaction, two reorientations — and `PostCompact` cannot emit `additionalContext` anyway (§ 4.9). |
| Identifying the active task by scanning open state files | Several tasks are open at once here; a scan cannot name *the* active one, and a wrong name is worse than none (§ 4.9). |
| A task registry, or a "current task" state field | The compacting session already knows its task; preserving that is `AGENTS.md`'s existing job, and a registry would be a second state system (§ 4.9). |
| A proportionality statement, tier label or justification field replacing the inspection record | It would trade one per-run ceremony for another. P-3a fails the implementation that adds one (§ 4.5). |
| A second activation gate beside the description | The description is Codex's only activation control; a second gate would be a rule with two owners. |

---

## 8. Risks, rollout and hook trust

**R-1 — Under-activation after narrowing (S1).** *Likelihood:* moderate, and higher after the correction
that removed the catch-all trigger. *Effect:* the operator has to name the loop for work it should have
taken. *Accepted deliberately:* this is the cost OD-4 chose. An ordinary request that no longer activates
the loop is Direct Work, which is the default the core already sets — so the failure is one extra sentence
from the operator, not lost work. *Mitigation:* keep the four positive triggers explicit, with "continue
this project" and existing-task pickup named verbatim; write non-triggers as request *shapes*, never
subject matter; P-1 runs all seven shapes, not just the three that should be suppressed. *Reversal:* one
frontmatter field, one commit.

**R-2 — Amending a document still marked draft (S2).** The core's header reads *draft for operator
approval*. *Mitigation:* follow the courier-clause precedent exactly — a dated note that this clause was
approved on its own and the header is deliberately unchanged. Do not promote the document.

**R-3 — Colliding with in-flight work (S7, and every `SKILL.md` slice).** `dispatch.sh`,
`dispatch.test.sh` and the spike `README.md` belong to a task that is still open at `turn: operator` with a
pending three-option decision, two of whose options change `dispatch.sh` again. *Mitigation:* S0 gates S7 on
that task's closing record, not on a clean tree — the tree went clean mid-session while the task stayed
open, which is exactly the signal that would mislead. Every `SKILL.md` edit re-reads the file immediately
before editing rather than trusting this plan's line numbers.

**R-4 — Hook trust (S6).** Three implications, stated because a hook runs shell on every compaction:

- **Blast radius.** The script runs on every compaction in this repository, for every session, whatever the
  work. It must be read-only and must exit 0 on every error path (§ 4.9, *fail open*). A hook that can
  block a session is a worse failure than the drift it prevents. The correction shrank this radius: the
  script no longer reads any repository file, so its only inputs are its own stdin.
- **Trust of injected content.** `additionalContext` is developer context the model will act on. The script
  emits the checkout it was handed and a fixed instruction — no repository content, no composed prose — so
  it adds no new trust surface. That property is what an implementer must preserve; the moment the script
  starts reading and quoting state files it has both regained the trust surface and returned to the
  task-identification design this correction removed.
- **No conflict with the Claude-side harness.** `.claude/references/harness-rules.md` hard rule 6 says
  "the governor owns post-compaction rehydration; `PreCompact`/`PostCompact` hooks log events but do not
  drive control." That rule governs the Claude-side Phase 3 session-governor harness. This hook is
  Codex-side, registered in `.codex/hooks.json`, and drives no control — it injects pointers and the model
  decides. Record the distinction in the commit message so a later audit does not read it as a breach.

**R-5 — Orientation growing into a stage (S5).** *Effect:* the artifact-free property is the whole point,
and it erodes quietly. *Mitigation:* P-9's `git status` half is the standing check; run it on the first
three real orientations, not just once.

**Rollout.** Slices ship as separate commits in the § 5 order. There is no migration: no file moves, no
schema changes, no existing state file is rewritten, and existing run logs stay where they are. Each slice
is reversible by reverting its commit, with one qualification — S6 also needs its single `hooks.json` entry
removed, since a revert of the script alone would leave a registration pointing at a missing file. The
`AGENTS.md` bullets are inert once the hook is gone and may be left or reverted independently.

---

## 9. Implementation handoff

A fresh Claude session can execute this plan with this section and the sections it points to. Nothing here
depends on the conversation that produced it.

**Before starting**

1. Read `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` — it is the contract and wins over
   this plan.
2. Read this plan's § 3 (owner map), § 5 (order and blockers) and § 7 (non-adoptions).
3. Check `logs/work-loop/work-loop-v2-contained-unattended-profile.md`. If it still holds the active fields
   (`## Objective and scope`, `## Lane and unit`, `## Brief`, …) rather than core § 4's four-heading closing
   record, the task is open and **S7 does not start** — `turn: operator` alone is not closure, and a clean
   working tree is not closure either.
4. Run `git status`. Confirm which paths are still in flight before touching any file this plan names.

**Per slice**

1. Re-read the target file immediately before editing. This plan's line numbers are orientation from
   2026-08-07; match on quoted text.
2. Make only that slice's change. An adjacent improvement noticed while editing is a deferral, recorded in
   the hand-back — not work (core § 5).
3. Run that slice's proof case from § 6, including its stated control. A case run without its control has
   not been run.
4. Commit that slice alone, by explicit pathspec.

**Files this plan authorises changes to, and no others**

- `ai-resources/.agents/skills/work-loop-v2/SKILL.md` — S1, S3, S4, S5
- `ai-resources/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` — S2
- `ai-resources/.claude/commands/work-loop-v2.md` — S3
- `ai-resources/AGENTS.md` — S6 (§ *Compaction* preservation list only)
- `ai-resources/.codex/hooks.json` — S6 (exactly one new entry)
- `ai-resources/.codex/hooks/work-loop-reorient.sh` — S6 (new)
- `ai-resources/logs/scripts/work-loop-v2-slice-1.test.sh` — S3 (see § 4.5)
- `ai-resources/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` — S7, after S0
- the spike `README.md` — S7, only if its worked invocation depends on the old `--log-dir` default

**Decisions already settled — do not re-open**

- The 85–90% target lives in core § 3 and nowhere else (§ 4.3).
- The checkout binding uses the task file's location; no state field is added (§ 4.7a).
- `PreCompact` is not registered, and neither is `PostCompact` — exactly one `SessionStart`/`compact`
  registration, because it is the only one whose output supports `additionalContext` (§ 4.9).
- The hook does not identify the active task. Preservation of the active pointers is `AGENTS.md`'s job
  (§ 4.9).
- Orientation reuses `/project-next-steps`' read cascade approach and does not merge with it (§ 4.6).
- The fresh-task fallback is a permanent, user-created worktree opened as a Local checkout (§ 4.7c).
- Step 2's inspection record is proportional: mandatory per-claim where load-bearing claims exist, and
  legitimately absent for Direct Work or a no-premise prose change (§ 4.5). Nothing new is mandatory in its
  place.

**Open questions carried forward** — none blocking. One is worth the implementer's attention: whether the
Codex harness can express "load this file later in the skill body" as anything stronger than an
instruction. § 4.2 is satisfied by the instruction alone if it cannot; if it can, take the stronger form.

---

## Limitations of this plan

- **The line numbers are a snapshot.** Taken 2026-08-07. Match on quoted text, not on the numbers.
- **The working tree moved while this plan was being written.** Another session committed the dispatcher
  work mid-session (`9c66f26`, `0259275`), so § 5's dependency list was corrected once before this plan was
  committed. Treat § 5 and § 8 R-3 as needing a fresh `git status` and a fresh read of the other task's
  state file before S7, not as settled facts.
- **Codex product behaviour was verified against current official documentation and one closed issue, not
  by running the app.** § 4.7c's fallback is derived from what the documentation does and does not describe;
  the first implementer to exercise it should confirm it behaves as stated and correct § 4.7c if not.
- **`SessionStart`/`compact` is documented for a *root* session.** The documentation states that after Codex
  compacts a **root** session, `SessionStart` hooks matching `source: "compact"` run before the next model
  request. It does not say what happens for a sub-session or a nested agent. § 4.9 is written for the root
  case, which is the case OD-5 describes; if compaction inside a sub-session turns out not to fire the
  event, S6 covers less than it appears to and the gap should be recorded rather than patched with a second
  registration — the event that could cover it, `PostCompact`, still cannot emit `additionalContext`.
- **No automated regression test exists for this plan itself**, and inventing one would be the ceremony
  OD-2 excludes. The fail-capable checks are § 6's proof cases, each of which is executed during the slice
  that earns it.
