# Consolidated Build Plan — `/work-loop` + `capability-development` (rev. 3, final)

**Status:** FINAL BUILD AUTHORITY on operator approval. No repository change made.
**Date:** 2026-07-28 · **Author:** Claude (Opus 5)
**Supersedes:** `ai-resources/plans/2026-07-28-develop-capability-build-plan.md` and the `/work-loop` investigation memo of 2026-07-28.
**Retained as drafting source only:** the superseded plan's §§7–10, 12, 14, 16 and Appendix A supply the text for file C4. Its counts are stale — see §13.

**Changed from rev. 2:** artifact retention moved from unit close to stream close (§5.1, §6.3, §7.1, A-GIT-1, A-STREAM-1) · two gated build sessions with exact grouping (§10.2, §10.3) · `global-macro-analysis` gains one relative symlink and its date is corrected (§2, §9.3, A-DIST-3) · orphan repoint now conditional on incomplete evidence (§7.0) · stream-ID collision handling (§5.1). Nothing else redesigned.

---

## 1. Recommendation

Build one operator-facing command, `/work-loop`, backed by two skills and one contract. `/develop-capability` is not built; its command-owned responsibilities are `/work-loop`'s, and its methodology becomes a consumed skill.

`/work-loop` **implements** — ordinary in-scope repository changes and capability slices — and routes out only for specialist authoring (`/develop-ai-resource`) and project creation (`/scope-project` → `/new-project`).

**Main rejected alternative:** two commands sharing a vocabulary. The overlap is not vocabulary but nine duplicated authorities plus two direct conflicts.

---

## 2. Verified state

**Verified in the operator's Codex session:** Codex reads the `ai-resources` repository directly including git state, reads sibling repositories from that root, and discovers the `.agents/skills/` catalog when rooted there. It writes and runs git within `ai-resources`; sibling write access is not assured and this design never requires it.

**Verified by filesystem inspection 2026-07-28:** 91 commands, 42 agents, 81 skills · workspace root has 61 symlinks + 6 real files and **no** `shared-manifest.json` · **25 of 27** projects carry a manifest and auto-sync · `global-macro-analysis` has no manifest but does have `.claude/commands/` holding **39 relative symlinks (+13 real project-local `kb-*.md` files)**; its latest git activity is `55b6eae`, **2026-06-12** · `personal/` is an empty directory, not a project · **zero** direct-route projects exist · `logs/` exists in 26 of 27 projects, in `ai-resources` and at the root · `.claude/commands/session-start.md:330` hard-fails without a `/prime` marker and `:379`/`:397` branch the plan chain on execution route — which is why `/work-loop` invokes neither · `.claude/commands/mission.md:71` never guesses a thread · risk classes at `docs/audit-discipline.md:60-65`, two-gate model at `:73-81`.

**Unverified:** whether Codex selects the new skill from a plain request without being named. Test **A-CX-1**, §11.

### 2.1 What this system actually adds

| Claim | Correct statement |
|---|---|
| Components | **6 files created, of which 5 are load-bearing components** (C1–C5). C6 is the plan document. |
| State authority | **One new durable state authority** — `projects/{p}/development/{slug}.md`, a new per-project file class with its own schema and a new sole writer. Plus one new temporary artifact class, `logs/loop/*`. |
| Process gates | **Three new operator gates on the challenged route** (G1, G2, G3), one conditional on reviewed, zero on solo. No new automated gate, no hook, no blocking check; `/risk-check` is neither absorbed nor changed. |
| Reversibility | Commits revert **in strict reverse order only** — see §10.4. |

What remains true and is the basis for proceeding: no always-loaded content, no `/prime` edit, no permission or hook change, no automated gate, and a footprint that reverts completely.

---

## 3. Authority boundary

**`/work-loop` owns the process. Skills own the method. Neighbouring commands own their own lifecycles and are reached as handoffs.**

| Resource | Owns | Never |
|---|---|---|
| **`/work-loop`** | Brief ingestion · premise verification · route classification · stream and unit lifecycle · phase orchestration · operator gates · Codex handoff transport · finding adjudication · evidence return · resume and reconciliation · closure · artifact mechanics · **implementation of ordinary in-scope repository changes and capability slices** | Hold methodology · author a new durable AI resource · create a project · write mission files |
| **`capability-development`** (skill) | Definition of *operating capability* · five phases · intervention ladder · trial design and stop condition · ownership and seam procedure · slice standards · evidence-to-claim table · lifecycle-decision standards · data handling · **capability-specific route triggers** · worked examples | Be invoked directly · orchestrate · read or write records · handle Codex · own resume · restate universal triggers |
| **`/develop-ai-resource`** | Authoring a **new** durable AI artifact or materially expanding one | Reopen a settled operating need · make a capability's adoption decision |
| **`/scope-project`** | Whether a *project* should exist; its control pack | Implement · adopt · close |
| **`/new-project`** | Project scaffolding, downstream of `/scope-project` | Develop a capability inside an existing project |
| **`/mission`** | The frozen multi-session *goal contract* and its threads | Hold development state · be written by anything but itself |

### 3.1 The execution boundary

`/work-loop` implements **ordinary, in-scope edits to things that already exist, and capability slices**: defect fixes, documentation, standards, decision rules, processes, data structures, configuration, project-local artifacts, and settled corrections to existing commands, skills, scripts and hooks.

It routes to `/develop-ai-resource` when a **new** durable AI artifact must be authored or an existing one materially expanded — matching that command's own authority text at `.claude/commands/develop-ai-resource.md:13-17`.

It routes to `/scope-project` when owner selection finds no legitimate owner or the work is a new enduring programme. Terminal exit: the stream closes, any record closes `status: rejected` with the routing note, and nothing is held open pending a project.

### 3.2 Three boundary sentences

Verbatim in C1, C4 and the E1 bullet.

> **Outcome versus artifact.** `/work-loop` with `capability-development` owns the operating outcome. `/develop-ai-resource` owns the artifact. The skill is not the capability; it is one implementation component.

> **Capability versus project.** A capability lives inside a project that already exists. A project is a new domain with its own deliverables.

> **Goal versus development record.** `logs/missions/{id}.md` answers *what multi-session goal is this serving, and is it drifting?* `development/{slug}.md` answers *what is this capability, where does it stand, what happens next?*

---

## 4. Routing — single authority, split by scope

**No table is copied. Three files each own one list and reference the others.**

| Owner | Owns | References |
|---|---|---|
| `docs/audit-discipline.md:60-65` | The `/risk-check` structural change classes | — (pre-existing, untouched) |
| `docs/work-loop.md` § Route triggers | **Universal triggers** — every unit of any type | Cites `docs/audit-discipline.md:60-65` by path and line. Does not restate. |
| `skills/capability-development/SKILL.md` § Route triggers | **Capability triggers** — additionally, for capability units | Cites `docs/work-loop.md` § Route triggers. Does not restate. |

**Universal triggers (C1 owns).** Any one fires; ambiguity resolves upward.

- **Challenged** — touches a `/risk-check` change class (per the cited lines); or deletes/retires an active resource; or changes git, branch or worktree behaviour; or touches three or more repositories; or has already failed to converge twice.
- **Reviewed** — changes a shared `ai-resources` resource symlinked into projects; or produces an artifact that leaves the repository; or changes five or more files; or produces analytical output the operator cannot judge unaided.
- **Solo** — residual: one repository, revert-reversible, ≤4 files, no shared blast radius, no external delivery.

**Capability triggers (C4 owns).** Lifted verbatim from the superseded plan §§6.2–6.4: H1–H6 → challenged; M1–M5 → reviewed; residual → solo.

### 4.1 Route → depth → stops

| Route | Independent review | Operator stops |
|---|---|---|
| **solo** | None. A mandatory risk class escalates the route rather than bolting a gate on. | 0 |
| **reviewed** | One Codex review of the result. `/qc-pass` only as fallback when Codex cannot reach the object. | 1 — lifecycle decision, only when the stream has a genuine adoption question. A defect fix closes as `close` with no stop. |
| **challenged** | Codex before implementation and after, **in separate units**. `/risk-check` at its own two gates, unchanged. | 3 — G1 scope+package · G2 release · G3 lifecycle |

Escalation is additive; nothing produced is discarded; escalation into challenged arms G1 immediately. De-escalation requires every trigger disproven with cited evidence, only at a phase boundary, never after a stop approved the heavier route.

---

## 5. Streams and unit cardinality

**A stream spans many units. A unit is one bounded piece of work with one brief, one evidence package and at most one review round.**

| Route | Units |
|---|---|
| **solo** | Exactly **one** unit. The stream is that unit. No record, no `active_unit`. |
| **reviewed / challenged** | **One unit per phase**, except Build, which is **one unit per slice**. |

### 5.1 Stream identity, allocation and collision

A **stream** is allocated once, at its first unit, and carried forward unchanged:

```
STREAM = {date-of-first-unit}-{slug}[-{n}]
UNIT   = {STREAM}-{phase}
```

Example: `2026-07-29-fix-hook-invocation` → `…-shape`, `…-prove`. The Prove unit keeps the stream's original date even when run days later. Every block header carries **both** `STREAM:` and `UNIT:`.

**Collision handling.** Before allocating, check **both** surfaces for the candidate stream id: any `logs/loop/{candidate}-*` artifact, and any `development/*.md` carrying `stream: {candidate}`. On a hit, append `-2`; if that also hits, `-3`; continue until clear. Unit ids derive from the resolved stream and therefore cannot collide independently. Allocation runs in a single-writer context, so an existence check is sufficient — no allocator, no shared counter. This matters more under rev. 3's retention rule than it did before: artifacts of an open stream stay on disk, so a same-day same-slug collision is a live possibility rather than a theoretical one.

**Correlation for all work, capability or not.** `/work-loop` finds a stream's siblings by globbing `logs/loop/{STREAM}-*`. Challenged **non-capability** work has no capability record and correlates purely by stream — no new file required. Capability units use the same stream key and *additionally* get the `## Units` view in their record.

### 5.2 Capability correlation

`development/{slug}.md` frontmatter gains `stream:` and `active_unit:` (or `none`), plus an append-only `## Units` table: unit · phase/slice · route · commits · outcome.

### 5.3 Why one unit per phase

It makes distinct pre/post reviews structural rather than procedural — the pre-implementation review belongs to the Shape unit and the post-implementation review to the Prove unit, so they are different files by construction and neither is ever mutated. It bounds each brief to what a 15–25 line block can honestly describe, and caps crash cost at one phase.

---

## 6. State model

### 6.1 Durable

| Artifact | Writer | Lifetime |
|---|---|---|
| `projects/{p}/development/{slug}.md` | `/work-loop` | Opened at Frame for reviewed/challenged capability units. Kept at terminal status. Never deleted — a rejected capability keeps its record. |
| `logs/decisions.md` | any session | Append-only |
| `logs/missions/{id}.md` | `/mission` only | Optional; goal contract |
| Committed work + git history | — | — |

Schema: superseded plan §12.4, **plus** `stream:`, `active_unit:` and `## Units`.

### 6.2 Temporary — all in `logs/loop/`, all single-writer

| Artifact | Authored by | Written by | Mutability |
|---|---|---|---|
| `{unit}.brief.md` | Codex | Claude transcribes once — or Codex directly when rooted in the target repo | **Immutable** |
| `{unit}.plan.md` | Claude | Claude | **Immutable** — a revision is `-v2` |
| `{unit}.evidence.md` | Claude | Claude | **Append-only, not immutable** |
| `{unit}.review-{n}.md` | Codex | Claude transcribes | **Immutable** |

Briefs, plans and reviews show exactly one add each in git history. Evidence shows several commits, which is correct and expected. A-CHAL-2 tests each against the right expectation.

The `-{n}` ordinal starts at 1. A closure review after corrections, justified only on the Independent Review SOP's five triggers, is `-2`. Pre- and post-implementation reviews are never both in one unit.

### 6.3 Commit boundary and retention

Every temporary artifact is committed by explicit pathspec **at write time**, before the next phase begins.

**Artifacts are retained for the life of the stream, not the unit.** A Prove unit must be able to read its stream's Shape review **on disk**, and reconciliation must be able to see completed units. **The stream-closing commit deletes every `logs/loop/{STREAM}-*` file together.**

The final unit of a stream closes the stream: for a capability, that is Land with a lifecycle status; for non-capability work, the last unit's close; for solo, the single unit's close. **No stream sits in an "awaiting closure" state** — closing the last unit closes the stream in the same commit.

The record's `## Pointers` carries the commit SHAs, so every artifact stays recoverable from git after deletion, with no permanent handoff archive.

**Never in the repository:** trial material containing real buyer, CRM, email or relationship data. Session scratchpad only.

### 6.4 Crash atomicity

Git commits are atomic; **the write sequence leading to one is not.** A crash between writing `active_unit` and writing the brief, or between either and the commit, leaves the working tree inconsistent.

**Ordering rule (reduces the window, does not close it).** Within a unit-open operation: write `logs/loop/{unit}.brief.md` first, then set `active_unit` in the record, then commit both by pathspec. The brief is the fact; `active_unit` is the pointer. A dangling pointer and an orphan brief are both detectable and repairable; a pointer written first with no brief is the harder case, so it is written second.

Detection and recovery run at every `/work-loop` invocation, before resume — §7.0.

---

## 7. Deterministic resume

### 7.0 Reconciliation, before any tier is consulted

Deterministic rules, no guessing; every reconciliation reported in one line.

| Observed | Action |
|---|---|
| Record has `active_unit: X`; no `X.brief.md` on disk **and** none in git | The unit never opened. Reset `active_unit: none`, report, offer to open fresh. |
| Record has `active_unit: X`; `X.brief.md` absent from the tree but **present in git history** | Uncommitted deletion or lost working tree. Restore from git, report the SHA, continue. |
| `X.brief.md` carries `CAPABILITY: {slug}`; that record's `active_unit` is `none` or absent; **and `X.evidence.md` is absent or lacks `Status: complete`** | The record write was lost. Show both paths, re-point `active_unit` to X, report. |
| `X.brief.md` carries `CAPABILITY: {slug}`; `active_unit: none`; **and `X.evidence.md` carries `Status: complete`** | **Normal — no action, no report, no repoint.** A completed unit whose artifacts are retained until stream closure. Never reopen a completed unit awaiting cleanup. |
| Record says `active_unit: Y` while an **incomplete** `X.brief.md` for the same stream is also open | **Stop. Report both paths. The operator decides.** Never merge, never guess. |
| Uncommitted changes in `logs/loop/` at invocation | Report before resuming. Do not commit silently. |

Git is the tiebreak: the last commit is the last known-consistent state; `git status` names what is uncommitted.

### 7.1 Tiers

**Tier 1 — capability-referenced active unit.** Records with `status: in-development` and `active_unit != none`.

**Tier 2 — streams with an incomplete unit.** Glob `logs/loop/*.brief.md`; a unit is **incomplete** when its evidence is absent or lacks `Status: complete`. Group by `STREAM`. Exclude any stream whose incomplete unit is named by a Tier-1 record. **Completed units are ignored here** — they are retained artifacts of an open stream, not outstanding work.

**Tier 3 — capabilities needing a new unit.** `status: in-development` with `active_unit: none`; the record's `## Current phase and next action` states what opens next.

Resolution: exactly one candidate in the highest non-empty tier → resume it, announcing in one line. More than one in that tier → list them once and ask. All tiers empty → treat any argument as a new need; with no argument, ask once. A lower tier is consulted only when every higher tier is empty. **No path sorts by timestamp.**

### 7.2 `/prime` visibility without a second entry point

**`/prime` is not modified.** Visibility comes from bare `/work-loop`; from `/prime` Step 1d, which already globs `logs/missions/*.md` and builds candidates from unchecked threads, so a challenged capability that `/work-loop` offers to bind to a mission appears automatically; and from `logs/decisions.md`, which `/prime` already reads.

**Named residual:** a reviewed capability with no mission binding is invisible at session start unless the operator runs `/work-loop`. Accepted. If it bites twice in real use, that is the trigger to reconsider a `/prime` step as its own separable change.

---

## 8. Codex surface

**`ai-resources` is the required Codex control room**, declared in C1 rather than inferred. Codex is opened rooted there, reads siblings from there, writes only within `ai-resources`, and the design never depends on that write access. Briefs and reviews are printed in chat and transcribed by Claude into the target repository, where Claude is the single writer.

Rejected: `~/.codex/skills/` (outside every git repository — unversioned, undistributed, unauditable) and symlinking `.agents/skills/` into projects (needs a distribution mechanism that does not exist).

**Correction — premise failure found in implementation, 2026-07-28 S3.** This section's reasoning did not survive inspection. **`.agents/` was gitignored** (`.gitignore`, committed; operator call 2026-07-13 S12, which also ignores `.codex/` and `AGENTS.md` as an unmaintained experiment). Zero files under `.agents/` were tracked — including the four existing `source-command-*` skills. Two consequences the plan missed: **commit 2 was unexecutable**, since its entire file list is C2 and nothing under `.agents/` could be staged; and the stated ground for rejecting `~/.codex/skills/` — *unversioned, undistributed, unauditable* — applied equally to a gitignored `.agents/`, so it did not distinguish the two options at all.

**Resolved by operator decision, 2026-07-28:** track **only** `.agents/skills/work-loop/`, via a narrowed `.gitignore` rule. `.codex/`, `AGENTS.md` and the four `source-command-*` skills stay ignored — this is the "deliberate decision to track" the 2026-07-13 note reserved, scoped to one subtree rather than an adoption of the mirror. Verified: exactly one file (`C2`) becomes visible; all four legacy skills, `.codex/` and `AGENTS.md` re-checked as still ignored. **Commit 2 therefore carries `.gitignore` alongside C2** (§10.3, corrected).

---

## 9. Files

### 9.1 Create — 6 files, of which 5 are components

| # | Path | Purpose | Size |
|---|---|---|---|
| **C1** | `ai-resources/docs/work-loop.md` | The contract: eight loop steps · universal route triggers (citing, not copying) · route→depth→stops · stream allocation, collision handling and unit cardinality · six block formats with the `UNIT`/`STREAM`/`PHASE`/`REPO`/`BASE`/`NEXT` header · phase table · artifact ownership, mutability and **stream retention** · commit boundary · reconciliation and resume order · Codex control-room declaration · the three boundary sentences | ≤220 lines *(amended from ≤180, 2026-07-28 — see §11 A-CORE-3)* |
| **C2** | `ai-resources/.agents/skills/work-loop/SKILL.md` | Codex controller: activation description · brief preparation · evidence review, premise dimension first · no-access fallback · redesign prohibition | ~150 lines |
| **C3** | `ai-resources/.claude/commands/work-loop.md` | Claude executor. Orchestration and implementation; reads C1 always, C4 for capability units. `model: opus`, `effort: high` | Target ≤300 lines — see §13 |
| **C4** | `ai-resources/skills/capability-development/SKILL.md` | The methodology. `disable-model-invocation: true`, `model: opus`, `effort: high`. Text lifted from the superseded plan §§7–10, 12, 14, 16, Appendix A, re-read against the live repository | 350–500 lines |
| **C5** | `ai-resources/templates/capability-record.md` | Record template — §12.4 schema plus `stream:`, `active_unit:`, `## Units` | ~75 lines |
| **C6** | `ai-resources/plans/2026-07-28-work-loop-consolidated-build-plan.md` | This document (**not a component**) | — |

### 9.2 Modify — 6

| # | Path | Change | Risk |
|---|---|---|---|
| **E1** | `develop-ai-resource.md` | Boundary bullet + Step 1.0 upstream-brief clause, retargeted to `/work-loop`. ~10 lines added | Low — additive |
| **E2** | `templates/README.md` | Register `capability-record.md` | None |
| **E3** | `new-project.md` | Add `work-loop` to the direct-route core symlink set (line 398) | Low — forward-looking |
| **E4** | `inbox/codex-second-opinion-brief.md` | `git mv` to `inbox/archive/` + disposition line | None |
| **E5** | `docs/ai-resource-creation.md` | One sentence in rule #4 naming `/work-loop` as the operating-outcome sibling | Low |
| **E6** | `plans/2026-07-28-develop-capability-build-plan.md` | Superseded banner; retained as C4 drafting source only | None |

### 9.3 Append — 1 · Symlinks — 2

- **L1** `ai-resources/logs/decisions.md` — the OP-11 exception, written against §2.1's corrected claims.
- **S1** `.claude/commands/work-loop.md` at the **workspace root** — one hand-made symlink; the root has no manifest.
- **S2** `projects/global-macro-analysis/.claude/commands/work-loop.md` — **one relative symlink, no manifest.**

  ```bash
  ln -s ../../../../ai-resources/.claude/commands/work-loop.md \
        projects/global-macro-analysis/.claude/commands/work-loop.md
  ```

  This matches the **39 relative symlinks** already in that directory exactly. The directory is a *mix*, not a symlink farm: 52 entries = 39 symlinks + **13 real project-local `kb-*.md` command files**. That strengthens the decision below rather than weakening it — **A manifest is deliberately not installed** because it would pull roughly 90 commands into the project at next SessionStart *and* put those 13 local `kb-*` commands at risk, a far larger change than this MVP is authorised to make. The project is low-activity but not dead: latest git activity `55b6eae`, **2026-06-12**.

**Reach:** `/work-loop` is available in **26 of 27 projects** — 25 automatically by `auto-sync-shared.sh`, plus `global-macro-analysis` by S2 — and at the workspace root by S1. `personal/` is an empty directory, not a project.

### 9.4 Not created

No agent. No hook. No permission or settings change. No manifest anywhere. No registry or index. No `/prime` edit. **No workspace `CLAUDE.md` edit.** No project `CLAUDE.md` edits. No `development/` directory until the first reviewed or challenged capability needs one.

---

## 10. Implementation sequence

### 10.1 Preconditions before Session A

1. **Plan-time `/risk-check`** — once, payload describing the whole design across both build sessions.
2. **`/blindspot-scan`** — once, post-plan, pre-implementation. Resolve any PAUSE-AND-FIX first. Does not re-fire.
3. **A named, separately approved pilot defect.** A-CORE-1 exercises the loop on a real repository defect, so a **real change lands as part of a test**. That change is not a test artifact and must not ride through unauthorized. Before Session A's verification, the implementing session proposes one candidate meeting all of: genuinely broken today, single repository, ≤4 files, revert-reversible, in **no** `/risk-check` change class, and unrelated to this MVP's own files. The operator approves it as its own scope line. **A-CORE-2 is exempt** — it asserts a false premise and its pass condition is zero edits.

### 10.2 Session grouping and gate placement

Three implementation sessions. Grouping is fixed so each end-time gate sees a complete, coherent change set.

| Session | Commits | In class? | End-time `/risk-check` |
|---|---|---|---|
| **A** | 1, 2, 3 | Yes — new command, new Codex skill, new symlinks, shared-state automation | **Once, before commit 1**, payload = the complete executed change set for commits 1–3 (C1, C2, C3 incl. challenged branch, S1, S2) |
| **B** | 4, 5, 6 | Yes — new skill, shared-state automation changes, command edits | **Once, before commit 4**, payload = the complete executed change set for commits 4–6 (C4, C5, E2, C3 capability branch, E1, E3, E5) |
| **C** | 7 | No — append, moves, banners | None |

**How each session runs.** Do all of the session's work in the tree, run the end-time gate against the actual executed change set, then land that session's commits in order. This follows `docs/audit-discipline.md:76` — the gate fires **before commit**, batched across what the session actually made — and corrects rev. 2, which scheduled it after commits 1–6 had already landed.

**Plan-time gate is not repeated for Session B**, because one approved plan covers both sessions. If Session B's executed set materially differs from what the plan-time gate saw, that is a material scope change requiring a new decision and a fresh plan-time gate — not a silent extra commit.

**Session A stop rule.** Commits 1 and 2 land, then **A-CX-1 runs in a fresh Codex task**. Commit 3 proceeds only on a pass. On failure, Session A ends after commit 2 and the amended footprint is approved before work resumes. Landing fewer commits than the gate covered is not scope growth and needs no re-gate.

### 10.3 The seven commits

| # | Session | Commit | Files | Verification | Complete when |
|---|---|---|---|---|---|
| **1** | A | `new: /work-loop — cross-model work loop (solo + reviewed, non-capability)` | C1, C3 (challenged and capability branches stubbed), S1, S2 | A-CORE-1..7, A-DIST-1..3, A-GIT-1, A-REC-1 | Approved pilot defect closed end to end; one resume after `/clear` |
| **2** | A | `new: work-loop Codex controller skill` | C2, **`.gitignore`** (narrowed `.agents/` rule — see §8 Correction; without it C2 cannot be staged at all) | **A-CX-1 first**, then A-CX-2 | Codex activates from plain language in a fresh task; one reviewed round trip closed |
| **3** | A | `update: /work-loop — challenged route, stream correlation, distinct pre/post reviews` | C3, C1 | A-CHAL-1..3, A-STREAM-1..2 | One challenged non-capability stream closed with two reviews in two units |
| **4** | B | `new: capability-development skill + capability-record template` | C4, C5, E2 | `/qc-pass` on C4; A-CAP-0; A-CORE-7 | Skill inert; template renders with no `{{` left |
| **5** | B | `update: /work-loop — capability units, record correlation, cardinality` | C3 | A-CAP-1..7, A-RES-1..2, A-REC-2 | One solo capability unit and one reviewed capability across ≥2 correlated units |
| **6** | B | `update: handoff contracts` | E1, E3, E5 | A-HAND-1..2 | Upstream brief not re-qualified; plain invocation unchanged |
| **7** | C | `decision: OP-11 exception + supersede prior plans` | L1, C6, E4, E6 | none | The record states what shipped |

### 10.4 Rollback boundaries

Commits are **not** independently reversible. Reverting is reverse-order only.

```
1 ──► 2   (C2 references the C1 contract)
1 ──► 3   (C3 edits)
1,3,4 ──► 5   (C3 edits + reads C4)
1 ──► 6   (E1 names /work-loop)
4 ──► 5   (capability branch reads the skill)
7 independent
```

Safe partial reverts: 7 alone · 6 alone (consequence: duplicated Step-1 work per handoff — wasteful, not incorrect) · 5 then 4 · 5 then 3 then 2 then 1. Reverting 1 requires 2, 3, 5 and 6 reverted first. **Session B reverts whole without touching Session A**, which is the practical rollback boundary. Every edit is additive; nothing is restructured, no schema migrated. A full reverse-order revert returns the repository to its pre-change state with any capability records left as readable markdown.

---

## 11. Acceptance tests

### Core loop

- **A-CORE-1 — Non-capability defect fix, solo.** Using the §10.1 approved pilot defect. **Pass:** brief written; route stated `solo` with the criterion; premise verified before any edit; evidence written with populated `LIMITATIONS`; pathspec commit; **artifacts deleted at stream close, which for solo is the single unit's close**; no Codex review, no `/qc-pass`, no `/risk-check`, no stop. Three operator actions.
- **A-CORE-2 — False premise stops.** Assert something disproved — e.g. *"`check-decision-refs.sh` still resolves its repo root from its own location"* (fixed in `df53459`). **Pass:** `PREMISE: rejected` with the commit cited; **zero edits**. Needs no pilot authorization.
- **A-CORE-3 — Sizes.** `wc -l`: C1 ≤220; C3 at or below its recorded ceiling (§13).

  **Ceiling amended 180 → 220 by operator decision, 2026-07-28.** The original 180 was an estimate made before three defects were found and fixed in the contract itself. The increase covers exactly: (a) **§ Closing without a change** — the shared lifecycle for `rejected-premise`, `route-unavailable` and `routed-out`, including the durable `logs/decisions.md` pointer without which a unit that stopped leaves no trace distinguishable from one never attempted; (b) the **open-before-verify rationale** at § The eight steps, which resolves a real ordering defect (premises were verified before any stream, unit id or brief existed, so a rejection could produce evidence unreachable by every resume tier and reconciliation row); and (c) **§ Artifact root**, the deterministic rule fixing an observed case where a unit declared `REPO: ai-resources` while its artifacts were committed at the workspace root, leaving the open stream invisible to the only root entitled to resume it.

  **Do not trim load-bearing behaviour to satisfy the old estimate.** Each of the three is a correction to an evidenced defect, two of them caught by independent review. §13's ordered responses were applied in order: no redundancy was found to remove, no material belonged elsewhere, so the ceiling was raised and the reason recorded here. A number that was a guess does not outrank behaviour that was verified.
- **A-CORE-4 — No trigger table copied.** Grep C1 for H1–H6/M1–M5 text and the risk-class list; grep C4 for the universal triggers. **Pass:** zero both ways; each cites the other by path.
- **A-CORE-5 — Evidence quality.** **Pass:** every claim names what was run and observed; `LIMITATIONS` populated; no bare assertion.
- **A-CORE-6 — Correction loop terminates.** Three findings, one demonstrably wrong. **Pass:** each carries one of six dispositions; the wrong one rejected with evidence; the unit closes after one correction pass; `/resolve` and `/triage` do not fire.
- **A-CORE-7 — No orchestration in the methodology skill.** Grep C4 for record read/write, `active_unit`, resume logic, tier resolution, Codex transport, commit mechanics, stream allocation. **Pass:** zero matches. Grep C3 for methodology prose (phase definitions, ladder rungs, trial design). **Pass:** zero — C3 cites C4.

### Routing, streams and reviews

- **A-CHAL-1 — Challenged stops before implementing.** **Pass:** `{unit}.plan.md` written, stop, no edit; `/risk-check` at its own gates unchanged.
- **A-CHAL-2 — Distinct immutable reviews; evidence append-only.** After a challenged stream through Prove: `git log --follow` on each `review-{n}.md` and each `brief.md` shows **exactly one add, no modification**, and one delete at stream close; `git log --follow` on each `evidence.md` may show **several** commits, which is correct. A closure review after corrections appears as `-2`, never as an edit.
- **A-CHAL-3 — Exactly three stops.** G1, G2, G3, no fourth. A passing verdict produces no stop.
- **A-STREAM-1 — Non-capability correlation without a record.** Run a challenged non-capability stream across two sessions with a day between. **Pass:** both units share the original `STREAM` including its original date; **the Shape unit's review is still readable on disk** when the Prove unit runs; `/work-loop` finds it by stream glob; **no capability record exists**.
- **A-STREAM-2 — Stream-ID collision.** Open two streams on the same date with the same slug. **Pass:** the second allocates `-2`; a third allocates `-3`; the check consults both `logs/loop/` and `development/*.md` `stream:` fields; no unit ids collide.
- **A-CAP-0 — Skill cannot self-invoke.** **Pass:** `disable-model-invocation: true`; `model: opus` in C3 and C4; no `model` field in any settings file.

### Capability units

- **A-CAP-1 — Solo capability writes no record.** **Pass:** no `development/` created; at most one decisions entry; zero stops.
- **A-CAP-2 — Reviewed capability across units.** **Pass:** two unit ids sharing one stream; record exists; `## Units` has two rows with real SHAs; `active_unit` points at the open unit and reads `none` between units, with **no reconciliation report fired** for the completed one.
- **A-CAP-3 — Ordering rule holds.** Inspect the unit-open commit. **Pass:** brief and `active_unit` land in the same commit, brief written first.
- **A-CAP-4 — Challenged capability, full lifecycle.** **Pass:** three stops; two distinct reviews; consumer inventory, reversibility and data-flow statements present; failure and recovery tests executed, not asserted.
- **A-CAP-5 — Negative trial stops the build.** **Pass:** build stops; result recorded; ladder re-entered; no permanent machinery.
- **A-CAP-6 — Unassessed is not passed.** Force Codex unavailability at a gate. **Pass:** recorded **unassessed**; no Claude subagent substituted and called independent; operator decides with the gap explicit.
- **A-CAP-7 — Confidentiality containment, synthetic canaries.** **No real buyer data.** Plant unique fake tokens in scratchpad trial material — `CANARY-BUYER-7f3a91`, `CANARY-CONTACT-b2c845`, `CANARY-BODY-e10d33` — run the trial, then `git log -p` across the stream's commits and `git grep` across the tree. **Pass:** zero canary hits anywhere in the repository; canaries present only in the scratchpad.

### Resume and recovery

- **A-RES-1 — `/clear` at every pause.** Clear at each of: after ingestion · after the Shape plan · awaiting pre-review · mid-Build between slices · awaiting post-review · before the lifecycle decision. **Pass:** bare `/work-loop` resumes at the right point each time, no re-explanation, no completed phase re-run.
- **A-RES-2 — Tiered resume, no timestamp selection.** Construct one Tier-1 capability, one Tier-2 stream with an incomplete unit, one Tier-3 capability — and make the **Tier-2** artifact newest by mtime. **Pass:** Tier 1 wins. With two Tier-1 candidates it lists both and asks once. No code path sorts by mtime.
- **A-REC-1 — Dangling pointer.** Set `active_unit: X` with no `X.brief.md` anywhere. **Pass:** reported, reset to `none`, fresh open offered; no guess.
- **A-REC-2 — Conflicting pointer, and the benign case.** (a) Record says `active_unit: Y` while an **incomplete** `X.brief.md` for the same stream is open → **stops**, reports both paths, asks; never merges. (b) Record says `active_unit: none` while a **completed** `X.brief.md` for an open stream sits on disk → **no action, no report, no repoint**; the completed unit is not reopened.

### Handoffs, distribution, git

- **A-HAND-1 — No double qualification.** Brief carrying `**Capability:**` + `**Settled upstream:**`. **Pass:** reads the record, treats 1.1–1.2 as satisfied, runs 1.3–1.6 on the artifact, returns its disposition to the calling unit rather than making an adoption decision.
- **A-HAND-2 — Direct invocation unchanged.** Plain need, no capability fields. **Pass:** full Step 1 including 1.1–1.2, identical to pre-commit-6.
- **A-DIST-1 — Workspace root.** `ls -la .claude/commands/work-loop.md` from the root. **Pass:** symlink resolves; command invocable there.
- **A-DIST-2 — Managed-project distribution.** Open a session in a manifest-carrying project. **Pass:** relative symlink appears after SessionStart, no manual step.
- **A-DIST-3 — `global-macro-analysis`.** `ls -la projects/global-macro-analysis/.claude/commands/work-loop.md`. **Pass:** relative symlink present in the same `../../../../` shape as its **39 symlinked siblings** (the directory also holds 13 real project-local `kb-*.md` files, which must be left untouched), resolving to the canonical file; **no `shared-manifest.json` was created**; no other command was added to that project.
- **A-GIT-1 — Recovery after stream cleanup.** After a **stream** closes: for **every** unit in the stream, `git show {stream-closing-commit}^:logs/loop/{unit}.brief.md`, and the same for its evidence and each `review-{n}.md`. **Pass:** every artifact returns full content; **no `{STREAM}-*` file remains in the working tree**; artifacts of any other open stream are untouched.

### Codex

- **A-CX-1 — Natural-language activation, fresh task.** Run **after C2 exists** and **in a new Codex task with no prior design context** — the current session holds this whole design and would activate for reasons unrelated to the description. In that fresh task rooted in `ai-resources`, describe a real need in plain words **without naming the skill**. **Pass:** Codex selects `work-loop`, explains the choice in three to four plain sentences before emitting, and produces a 15–25 line brief.

  **On failure: stop.** Do not edit `ai-resources/AGENTS.md`. End Session A after commit 2, report the result, propose the amended footprint — an activation pointer is one candidate, a rewritten description another — and **obtain operator approval for the amended footprint before any further edit.** A fallback is not pre-authorized.
- **A-CX-2 — Full reviewed round trip.** Brief → evidence → review → adjudication → close on one real unit. **Pass:** every material finding carries a disposition; rejections cite evidence.

---

## 12. Exclusions

| Excluded | What would justify it |
|---|---|
| Any `/prime` edit | An unbound reviewed capability lost twice in real use |
| Any workspace `CLAUDE.md` routing rule | Routing wrong at ingestion across three or more streams |
| A `shared-manifest.json` for `global-macro-analysis` | The operator wants full library sync there — decided separately, not here |
| `codex exec` / any API bridge | Codex loses repository access **and** a current CLI binary returns cleanly |
| A second methodology skill | C4 exceeds ~700 lines with two separable halves |
| Any new agent | Never — Codex provides cross-model independence |
| Registry, index, dashboard, telemetry | Never — a glob suffices |
| Automated route classification or a checker | Never — rule #7 says build no checker for a design principle |
| Permanent handoff archive | Never — git history is the archive |
| A `/work-loop` list or status verb | More than five concurrent streams in one repository |

---

## 13. Risk and recommendation

| Risk | Mitigation | Residual |
|---|---|---|
| **C3 exceeds its size target** | The 300-line figure is a **design signal, not a relocation target.** Permitted responses in order: (1) remove redundancy inside C3; (2) move *durable reference material* — block formats, trigger lists, phase tables — into C1 where it belongs; (3) **raise the ceiling and record why in the commit message.** **Moving orchestration into C4 is prohibited** — it would put record mechanics, resume, stream allocation and Codex transport into the methodology skill and destroy the boundary this reconciliation exists to create. A-CORE-7 tests the boundary both ways and outranks A-CORE-3. | Real. A larger honest C3 beats a clean number bought with a broken boundary |
| **Crash between artifact and pointer writes** | Ordering rule (§6.4) plus deterministic reconciliation (§7.0); git as tiebreak; conflict stops rather than merges; completed units explicitly exempt from repointing | Bounded — one write apart, every outcome detectable |
| **Retained artifacts accumulate in a long stream** | Deleted together at stream close; a stream with many units is itself the signal that slices are too small | Low — bounded by one stream |
| **Unit-type misclassification** | One-sentence test; downward misclassification is cheap because solo capability writes nothing | Low |
| **Unbound reviewed capability invisible at session start** | Named in C1; mission binding offered at record open | Accepted, with a stated revisit trigger |
| **Complexity budget fails** | Recorded as an OP-11 exception in L1, written against §2.1 — **five components, one new durable state authority, three new operator gates on one route, none removed**, and neither half resting on a logged failure | Honest. A net simplification against the two-plan baseline, **not** against today's repository. L1 must say both |
| **Codex activation** | A-CX-1 in a fresh task after commit 2, before anything depends on it; failure ends Session A pending an approved footprint amendment | Bounded |
| **Over-review at reviewed** | Codex replaces `/qc-pass` rather than adding to it; `/resolve` and `/triage` do not auto-fire; solo has no review | Watch: solo work feeling heavier is the first retirement signal |

**Retirement conditions**, reviewed after the third completed stream or on 2027-01-31, whichever is first: fewer than three meaningful streams used · the operator still choosing and remembering the internal command chain · more model turns than operator effort saved · Codex unable to inspect review objects reliably · the same handoff information in competing locations · solo work noticeably heavier · handoff or state mismatches still common · existing resources able to do the same after a simple adjustment. Retirement removes C1–C5, S1, S2 and the E-edits and returns to the SOP templates and existing project authorities. The OP-11 entry stays as the record that the question was asked.

**Recommendation: proceed**, with §10.1's three preconditions met first — plan-time `/risk-check`, `/blindspot-scan`, and a separately approved pilot defect.

The premise remains operator-stated rather than evidenced, and §2.1 records what this actually adds rather than a flattering version of it. What keeps the bet proportionate is unchanged and verifiable: no always-loaded content, no `/prime` edit, no permission or hook change, no automated gate, and a footprint that reverts completely — with Session B reverting whole without touching Session A.

**Two things the implementing session must not inherit as settled.** C1's universal trigger prose should be written against the live `docs/audit-discipline.md`, not this plan's paraphrase. And C4's text should be lifted from the superseded plan and then **re-read against the live repository** — its F2 (88 commands) and F14 (26 projects, 20 with `pipeline-state`) are already stale against today's 91 and 27/21. Any technical premise here that inspection disproves should be challenged and corrected, not implemented.
