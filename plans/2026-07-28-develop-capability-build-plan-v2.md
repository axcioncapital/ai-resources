# Build `/develop-capability` — operating-capability development inside existing projects (v2)

> **⚠ PREMISE VOID — DO NOT IMPLEMENT. Halted 2026-07-28 mid-revision.**
> `/qc-pass` returned REVISE. While fixing its finding that this plan's absence claims used a
> search instrument blind to most of the workspace, the corrected search overturned the plan's
> justifying premise:
> - **`projects/axcion-systems-builder/` already runs a 13-phase system-development lifecycle**
>   (V1 → Needs → V2 → MVP → V3 → Implementation Brief → `/new-project`), with Codex red team at
>   four points, operator approval authority, a case model, and an explicit anti-overbuild mandate.
> - **Both named near-term uses are already active cases in it.** `email-system` is at Phase 6
>   (Codex Review 1 pending; operator Needs Document received 2026-07-24). `contacting-operations`
>   is at Phase 4 (V1 received 2026-07-24).
> - **23 of 27 project directories are gitignored at the workspace root** and were therefore
>   invisible to this plan's entire existing-capability sweep.
>
> F26, I3, U2, § 3's overlap map, § 14.1's handoff target, § 17.2 and § 17.5's walkthroughs, and
> § 4.4's OP-11 rationale are all false or unsupported as written. Awaiting operator direction on
> whether a residual gap justifies this command at all.

**Status:** HALTED — premise void. No repository change has been made.
**Supersedes:** `2026-07-28-develop-capability-build-plan.md` (v1), retained as the review trail.
**Author:** Claude (Opus 5), 2026-07-28.
**Input:** Operator brief + Capability Development SOP + Foundational Direction and Principles + a twelve-question `/grill-me` interview (settled inputs, § 2.4) + Codex review verdict **Revise** (dispositions, § 0).
**Target repo:** `ai-resources/` as it stands today — operator-locked.
**Reviewer note:** self-contained. Every load-bearing claim carries a path and line number. Every count in § 2.1 was derived mechanically on 2026-07-28 and states the command used.

---

## 0. Disposition of Codex review findings

Codex returned **Revise**: architecture sound, execution contracts defective. All five blocking findings and all eleven important revisions are accepted. Two are accepted with a narrowing, stated below.

### 0.1 Blocking findings

| # | Finding | Disposition | Where fixed |
|---|---|---|---|
| B1 | Confidential-data rule unsafe — v1 claimed the "session scratchpad" is outside the repository. It is not: `wrap-session.md:25` writes `logs/scratchpads/` **inside** the repo, gitignored at `ai-resources/.gitignore:28`. | **Accepted, verified.** Confidential material now never touches the repository at all. It stays in the source system or goes to an explicitly created OS temp directory via `mktemp -d`. | § 12.8, § 14.7, § 16.4, D10, AT-19 |
| B2 | Lifecycle state machine cannot resume several active capabilities — `continue-trial`, `revise` and `paused` are nonterminal but discovery searched only `in-development`. | **Accepted.** One canonical **active-status set** defined once and referenced everywhere. `paused` additionally requires a concrete reopening trigger so it cannot become a silent grave. | § 12.5, § 15.1 |
| B3 | The Heavy stop is specified in two contradictory places — § 6.5 and AT-15 stopped in Frame; § 9 armed G1 and stopped after Shape. | **Accepted, with Codex's recommendation.** Classify Heavy in Frame and *say so*; complete a bounded evidence-backed Shape; stop at G1 with a package worth approving. This also resolves a tension inside the operator's own answers — Q6 said "stop at classification," Q7 said "do not create a separate earlier lane-confirmation stop." Q7 is the more specific instruction and wins. | § 6.5, § 6.6, § 9, § 11.2, AT-15 |
| B4 | The `/develop-ai-resource` handoff smuggled an uncounted operator gate — its Step 4 requires a Ship/Revise/Defer/Delete disposition, which v1's clause neither suppressed nor reassigned. | **Accepted.** An explicit **upstream mode** now returns the *artifact* disposition to `/develop-capability` for Claude to adjudicate, and reserves *business adoption* exclusively for the capability lifecycle at G3. | § 14.3, § 18.3 |
| B5 | Cross-project capability changes had no landing mechanism — H3 covers "a second project must change," but § 14.4 forbade writing there and offered no path. | **Accepted.** New **sibling-project change request** handoff: a bounded self-contained request, executed in the owning project's own session, evidence returned, one capability owner preserved. | § 14.9 |

### 0.2 Important revisions

| # | Revision | Disposition |
|---|---|---|
| I1 | Operator authority missing in Lightweight — Claude declared adoption. | Accepted. Lightweight gains no mid-run stop, but the status is **recommended** until the operator accepts the demonstrated outcome. § 7 step 16, § 11.1, § 11.5, case 17.1. |
| I2 | Defer the `/prime` edit in v1. | Accepted (OQ-1 answered No). Removed from the change set entirely and moved to MVP exclusions with a concrete justifying trigger. Codex also caught a real bug in the v1 pseudocode — `[ -d … ] \|\| :` is a no-op that does not skip the loop — which is further reason not to ship it under time pressure. § 19.2, § 23. |
| I3 | Fix commit ordering — Lightweight committed before proof; Medium updated its record after committing. | Accepted. Verification and record state are now captured **before or within** the commit, never after. § 7, § 8. |
| I4 | Keep lane selection consequence-based — a mandatory `/risk-check` does not imply Heavy. | Accepted. H6 narrowed to genuinely shared, cross-project, hook or shared-state infrastructure. M4 explicitly covers project-local AI-resource work. § 6.2, § 6.3, § 7 step 14. |
| I5 | Correct the examples. | Accepted. EmailOS is Heavy on H1+H2, not on an "irreversible draft." Contacting Strategy may not claim a speculative EmailOS consumer under H3. A project-local command does not satisfy a trigger labelled shared infrastructure. § 17.2, § 17.5, § 17.9. |
| I6 | Run `/placement` before implementation. | Accepted. Added as a named pre-implementation gate; OQ-2 is provisional on its outcome. § 20.1. |
| I7 | Move Heavy review briefs out of the authoritative-record directory. | Accepted, and taken further: briefs are **generated, not durable**. They go to the OS temp directory; the record holds the round, the findings and every disposition, from which a brief is regenerable. One rule now serves both this and B1. § 14.6, § 16.4. |
| I8 | Refresh repository facts — counts stale. | Accepted. **All counts re-derived mechanically**, each stating its command. Every figure Codex cited was correct and every figure v1 stated was wrong. § 2.1, § 2.5 D11. |
| I9 | Rewrite the OP-11 rationale — the `/new-project` precedent is only analogous. | Accepted. The precedent is now cited for *form* only. The honest rationale replaces it: the operator knowingly funds two load-bearing components for two named near-term uses, with reconsideration gates if usage does not materialise. § 4.4. |
| I10 | Keep two Heavy independent reviews, but only when a real Heavy trigger applies. | Accepted (OQ-6). Made explicit — a capability that reaches Heavy by escalation still gets both rounds; nothing gets a Codex round because of lane label alone. § 16.2. |
| I11 | `development/` is a new top-level artifact category. | Accepted — see I6. Name is provisional pending `/placement`. |

### 0.3 Accepted with a narrowing

- **B3.** Codex's recommendation is adopted, but "bounded Shape before G1" needs a stop-loss or it becomes unbounded work before any approval. § 9 caps pre-G1 Shape: no implementation, no external handoff, no confidential-data trial. A trial that requires real data waits until after G1.
- **B5.** The sibling-project change request is specified as a **handoff, not an execution path**. `/develop-capability` never opens the sibling session itself. This keeps the "never write into another project's tree" rule intact rather than carving an exception into it.

### 0.4 Answers recorded

OQ-1 `/prime` — **No for v1.** OQ-2 `development/` — **provisional, subject to `/placement`.** OQ-3 `/mission` — **excluded from v1.** OQ-4 first live use — **a deliberate Lightweight case.** OQ-5 OP-11 — **accepted after the rationale correction and a `/risk-check` on the revised design.** OQ-6 Heavy reviews — **two, but only on a real Heavy trigger.**

---

## 1. Executive recommendation

**Build it.** One new operator-facing command, `/develop-capability`, backed by one new methodology skill, `capability-development`. Together they own a lifecycle the repository does not have: taking an **operating capability** from a stated need, through validation, proportionate design, implementation, verification and real use, to an explicit lifecycle status — inside an existing Axcíon project.

Three lanes selected by **consequence classes, not file counts** (§ 6). Five phases — Frame → Shape → Build → Prove → Land — carrying all thirteen SOP steps without becoming thirteen gates (Appendix A). Operator stops rationed at **0 / 1 / 3**, with Lightweight's zero stops qualified by an acceptance requirement rather than by Claude self-declaring adoption (§ 11.5).

**The boundary is narrow and mechanically enforced.** `/develop-capability` owns the *operating outcome*. `/develop-ai-resource` keeps its owned artifact class untouched and gains one **upstream mode** so a pre-qualified brief is neither re-litigated nor allowed to make a business-adoption decision that belongs to the capability lifecycle (§ 14.3).

**The complexity budget fails, and the plan says so without dressing it up.** `docs/ai-resource-creation.md:25-34` requires net-simplification or cited evidence. This clears neither: two components added, none removed, and the operator has confirmed there is no historical failure pattern. § 4.4 records an **OP-11 exception** whose rationale is now the honest one — a funded decision for named near-term uses with reconsideration gates — rather than a borrowed precedent that does not actually fit.

**It is wired at one point, not two.** v1 proposed both a workspace routing rule and a `/prime` scanner. Codex is right that the scanner adds high-blast-radius behaviour before any continuity failure exists. v1 ships **workspace `CLAUDE.md` routing only**, which satisfies RR-05 for initiation; resumption relies on the mechanisms `/prime` and `/wrap-session` already provide — continuity scratchpad detection (`prime.md:164`), Next Steps, and the record itself, which the operator names when resuming. § 23 states the exact trigger that would justify the scanner later.

**Recommended disposition:** approve after `/qc-pass`, `/placement` and a plan-time `/risk-check`. Implement in five commits (§ 20). Re-evaluate against § 24 after the third completed capability lifecycle.

**Main alternative rejected:** Lightweight + Medium only, Heavy as a routing exit. Rejected by the operator (Q12) and on merit — a routing exit cannot own the seam, maintain the record across an external handoff, govern the trial, or hold the adoption decision.

---

## 2. Confirmed facts, reasonable inferences, unknowns, proposed decisions

### 2.1 Confirmed facts

**Counts are derived, not recalled.** Every figure below states the command that produced it, run 2026-07-28. v1 stated seven counts from eyeballed `ls` output and **every one was wrong**; Codex caught it. The correction is recorded as D11.

| # | Fact | Evidence |
|---|---|---|
| F1 | No `develop-capability` command, `capability-development` skill, or file bearing either name exists anywhere in the workspace. | `grep -ril "develop-capability\|capability-development" .` → 0 |
| F2 | `ai-resources/.claude/commands/` holds **91** command files. | `ls ai-resources/.claude/commands/*.md \| wc -l` → 91 |
| F2b | `ai-resources/skills/` holds **80** skill directories. | `ls -d ai-resources/skills/*/ \| wc -l` → 80 |
| F3 | `/develop-ai-resource` is 138 lines, four steps — Qualify → Build → Verify → Decide. Step 1 already performs need statement, evidence classification, existing-capability disposition, an intervention ladder, a complexity budget, and a verdict including *no build*. | `develop-ai-resource.md:29-55`; ladder `:43`; verdicts `:53` |
| F4 | Its owned artifact class: skill, reusable prompt, persistent instruction, reference file, command, script, hook. | `develop-ai-resource.md:9` |
| F5 | It routes skill-class work to `/create-skill` and `/improve-skill` at Step 2 via a qualified brief requiring `**Mechanism:**` and `**Evidence:**`. A brief without both "is raw and belongs at Step 1." | `develop-ai-resource.md:65-66`, `:80-87` |
| F5b | **Its Step 4 requires an operator disposition** — Ship / Revise / Defer / Delete candidate — and states "Adoption and integration wait for that choice." | `develop-ai-resource.md:119` |
| F6 | Its Guardrails already disclaim portfolio prioritisation, repository redesign, incident recovery, architecture review, recurring audits, permission redesign and publication. | `develop-ai-resource.md:135` |
| F7 | History: `6982bc6` created it (115 lines); `07880ab`, `afeaae2`, `7383459` corrected authority policy, direct callers, the Pocock SHA pin and the principles path. | `git -C ai-resources log --follow -- .claude/commands/develop-ai-resource.md` |
| F8 | "New commands or skills" is a **mandatory** `/risk-check` change class, at two gates (plan-time, end-time). Sessions may not self-waive. **The class does not distinguish shared from project-local.** | `docs/audit-discipline.md:56-81` |
| F9 | The complexity budget requires **at least one** prong: (a) net-simplification, or (b) cited written evidence. "We might need it" and "for a future phase" explicitly fail (b). | `docs/ai-resource-creation.md:25-34` |
| F10 | RR-05 requires a new command to state what it replaces or why it must be separate, **and** to name its invocation path. A written design principle — "build no checker for it." | `docs/ai-resource-creation.md:36-44` |
| F11 | A component introduced despite failing the budget is a recorded **OP-11** exception in `logs/decisions.md`, never an inline assertion. | `docs/ai-resource-creation.md:44` |
| F12 | An OP-11 anticipatory-build precedent exists: 2026-07-23, `/new-project` direct route, landed with zero live consumers. **It cited measured operating cost** (~5,600 tokens/session across two commands made optional). | `logs/decisions.md:83-95` |
| F13 | `auto-sync-shared.sh` symlinks every command and agent from `ai-resources/.claude/{commands,agents}/` into each project at SessionStart, except manifest-declared local files and a baked-in exclusion list. | `new-project.md:465` |
| F14 | Project state conventions are **not uniform**. Derived counts: **27** project directories (`ls -d projects/*/`); **21** carry `pipeline/pipeline-state.md`; **26** carry `CLAUDE.md`; **26** carry `logs/decisions.md`; **4** carry `logs/next-up.md`; **0** carry `PROJECT.md`; **3** repos carry `logs/missions/`. | per-item `ls … \| wc -l`, 2026-07-28 |
| F15 | `pipeline/pipeline-state.md` tracks `/new-project` scaffolding stages 3a–6, not live work. | `new-project.md:307-324`, `:892` |
| F16 | `/prime` Step 1b detects continuity scratchpads written by `/handoff` and `/wrap-session` and offers them as resume points. Step 1c detects plan position. Step 1d scans `logs/missions/` and is a "zero-cost no-op when none exist." Step 5 merges candidates, caps the menu at 6. | `prime.md:164`, `:176`, `:215`, `:289-298` |
| F17 | `/mission` manages multi-session goals: a frozen contract at `<repo>/logs/missions/<id>.md`. Only `status` and `## Open threads` change, only via the command. Advisory; blocks nothing. | `mission.md:10-14` |
| F18 | `/qc-pass` dispatches `qc-reviewer` with no conversation history, and carries a project-session fallback: walk up to `ai-resources/`, inline the definition into a `general-purpose` spawn with `model: opus` re-asserted. | `qc-pass.md:22-24` |
| F19 | `/risk-check` delegates to `risk-check-reviewer`, scores seven dimensions, writes to `audits/risk-checks/`, returns `GO` / `PROCEED-WITH-CAUTION` / `RECONSIDER`. | `risk-check.md:5` |
| F20 | `/implementation-triage` delegates to `system-owner`, returns `WORTH-DOING` / `MARGINAL` / `NOT-WORTH-DOING` / `DECLINE`, chat-only. | `implementation-triage.md:42-47`, `:64` |
| F21 | `/scope-project` is the complex-build lane, `/context-builder` the simple lane, both converging at `/plan-draft`. Stage 0 routes a fuzzy idea to `/grill-me`. Stage 5 can end `Park` / `Do Not Build`. | `scope-project.md:13`, `:35-37`, `:78` |
| F22 | `/new-project` Step 0 dispositions: **A** no repository, **B** existing owner (return a handoff, do **not** modify that repository), **C** small durable document project, or fallthrough. Ambiguity resolves toward fallthrough. | `new-project.md:51-58` |
| F23 | `/leverage-idea` starts from an idea dump about workspace AI resources, stops at a plan, applies no change, and caps a budget-failing option at `MARGINAL`. | `leverage-idea.md:9`, `:11-13`, `:128` |
| F24 | `/graduate-resource` owns project-local → canonical promotion and requires confirmation from every existing canonical consumer. | `docs/ai-resource-creation.md:21` |
| F25 | Placement heuristics Q1–Q8: reusable → `ai-resources/`; operator-invoked-on-demand → command; reusable procedural instructions → skill; structural change class → `/risk-check`. | `docs/repo-architecture.md:181-226` |
| F26 | **EmailOS does not exist.** Repo-wide search, any spelling → 0. No CRM integration, no Gmail integration, no buyer-record structure anywhere. | `grep -ril "emailos\|email os" .` → 0 |
| F27 | "Contacting Strategy" appears only as a roadmap workstream line. | `artifacts/merged-os-context/strategic-os/state/live/workstreams.md:11` |
| F28 | `axcion-communication-system` owns the register-and-language layer of email. `channels/email.md` is an authored scaffold (`status: scaffold`, `cutover_blocking: true`, work unit W4.3 — content not written). Its CLAUDE.md disclaims the situational layer and forbids writing into `interpersonal-communication` or `marketing-positioning`. | `channels/email.md:1-16`; `axcion-communication-system/CLAUDE.md:27` |
| F29 | **`capability` is already taken** in that project with a different meaning: `capability/` holds drills, assessment and rubric templates for *human* communication proficiency. | `projects/axcion-communication-system/capability/` |
| F30 | `development/`, `initiatives/`, `capabilities/` and `build/` collide with nothing across all 27 projects and `ai-resources/`. | per-name `ls -d` sweep → 0 each |
| F31 | `axcion-linkedin-os` implements an operating capability with a lifecycle (`drafts/ → approved/ → scheduled/ → published/`), an authority order (`:14-16`), two hard laws enforced structurally in settings (`:5-12`), and four human-in-the-loop checkpoints (`:23-25`). | `projects/axcion-linkedin-os/CLAUDE.md:1-25` |
| F32 | `ai-resources/plans/` is the established home for new-command build plans; `plans/2026-06-12-leverage-idea-build-plan.md` is the direct precedent. | `ai-resources/plans/` |
| F33 | `ai-resources/templates/` holds `mission-contract.md` — precedent for a command-owned record template. | `ai-resources/templates/` |
| F34 | Model defaults are prohibited at every settings layer and in every CLAUDE.md. Per-command/agent/skill `model:` frontmatter is the only permitted mechanism; new resources declare a tier and never inherit. | workspace `CLAUDE.md` § Model Tier |
| F35 | Project `CLAUDE.md` files no longer carry a `Model Selection` section. | workspace `CLAUDE.md` § Model Tier; `new-project.md:694` |
| F36 | `/new-project` Direct Route creates no `pipeline/`, defers `logs/decisions.md`, but provisions `logs/scripts/` whenever `logs/` is created. | `new-project.md:341-347`, `:410-412` |
| **F37** | **`/wrap-session` writes a continuity scratchpad to `logs/scratchpads/{date}-{time}-scratchpad.md` — inside the repository.** It is gitignored, not external. | `wrap-session.md:25`; `ai-resources/.gitignore:28` |
| **F38** | `/wrap-session` carries a **QC-PENDING commit guard**: a `/risk-check`-class artifact without a passing independent `/qc-pass` this session is not staged or committed; a continuity scratchpad is written instead and the commit is blocked. | `wrap-session.md:227` |

### 2.2 Reasonable inferences

| # | Inference | Basis | If wrong |
|---|---|---|---|
| I1 | A capability request in a project session today routes to `/develop-ai-resource`, the only command whose description matches "decide whether a thing should exist, then build it," and the one workspace `CLAUDE.md` names. | F3, F4, workspace CLAUDE.md | The boundary problem is smaller than assumed; § 18.5's routing line is less load-bearing but still correct. |
| I2 | `axcion-communication-system` owns an EmailOS *language* seam but not EmailOS — its CLAUDE.md restricts it to what the firm sounds like (F28). | F28 | Owner selection in § 17.2 changes; § 5.3's procedure is criteria-driven, so unaffected. |
| I3 | EmailOS needs an owning project that does not exist — it spans relationship state, contact rationale, language and an external record, and no project claims the operating workflow. | F26–F28, project survey | Heavy would develop in place rather than route out. Both branches specified (§ 14.1, § 17.2). |
| I4 | Existing continuity mechanisms are sufficient for v1 resumption: `/prime` Step 1b surfaces the scratchpad `/wrap-session` writes at every substantive session end (F16, F37), and the operator can name the capability directly. | F16, F37 | If a Medium/Heavy capability is genuinely lost between sessions, § 23's trigger fires and the `/prime` scanner is built then — with correct pseudocode. |

### 2.3 Unknowns

- **U1.** Whether EmailOS's operating model works. Nobody has prepared a buyer email this way and observed the result. The trial exists to find out; the plan must not encode an unvalidated workflow as a requirement.
- **U2.** Which project will own EmailOS. Deferred to a live Frame (§ 5.3 gives the procedure, not the answer).
- **U3.** What buyer-record structure is authoritative. None found (F26). A capability depending on it hits an evidence gap and produces a requirements doc rather than inventing a schema.
- **U4.** Whether two Codex rounds per Heavy capability is sustainable for one operator. Untested; § 24.2 makes it the first thing to cut.
- **U5.** How often Lightweight is the right lane. If rare, the three-lane design is over-built and § 24.2 fires.
- **U6.** Whether resumption without a `/prime` scanner actually works across a real multi-session Heavy capability. This is the specific risk accepted by deferring the scanner; § 23 names the trigger that reverses it.

### 2.4 Settled inputs

Operator brief locks: separate command; `/develop-ai-resource` unchanged in scope and name; one capability command; new-project creation stays with `/scope-project` + `/new-project`; AI-resource sub-needs handed out, never reproduced; the SOP is directional; plan only.

`/grill-me` answers Q1–Q13 as recorded in v1 § 2.4, unchanged, with one resolution added: **Q6 and Q7 conflict on where the Heavy stop falls.** Q6 says stop at classification; Q7 says "do not create a separate earlier lane-confirmation stop." Q7 is the more specific instruction and governs (§ 6.5). Codex independently reached the same conclusion.

Codex answers OQ-1 to OQ-6 as recorded in § 0.4.

### 2.5 Proposed decisions

| # | Decision | Rationale | Rejected alternative |
|---|---|---|---|
| D1 | Five phases: Frame → Shape → Build → Prove → Land. | Carries all thirteen SOP steps (Appendix A); few enough to hold in mind, enough to place a gate honestly. | Thirteen stages — forbidden by the brief. Three — collapses proof into build. |
| D2 | Lane routing by consequence classes, not a score. | Mirrors how the repo already classifies risk (`audit-discipline.md:56-71`). Class membership is arguable; a score is false precision. | Weighted scoring across ten factors. |
| D3 | Record directory: **`development/`**, provisional pending `/placement`. | Zero collisions (F30); names the activity, so it never competes with `capability/`'s human-skill sense (F29). | `capabilities/` — would sit beside `capability/` in one tree. `initiatives/` — reads as a programme, invites scope inflation. |
| D4 | One record file per capability, frontmatter-driven. | Matches `/mission` (F17, F33); keeps discovery to a bounded glob. | A single `register.md` — recreates the central registry the foundational document warns against. |
| D5 | Heavy's Codex reviews ride on existing operator stops. | Satisfies the three-stop ceiling exactly while placing review before irreversible work. | A fourth stop for the verdict. |
| D6 | **Invocation wiring = workspace `CLAUDE.md` routing only in v1.** | RR-05 needs a named path for *initiation*; existing continuity covers resumption (I4). Codex is right that a `/prime` scanner is high blast radius before any observed failure. | Both, as in v1 — rejected on Codex's finding and OQ-1. |
| D7 | `/develop-ai-resource` receives an **upstream-mode clause**, additive, ~14 lines. | Q2 permits compatibility. B4 requires the Step 4 gate to be explicitly reassigned, which a shorter clause could not do. | v1's six-line clause — left the uncounted gate in place. |
| D8 | No new agent. | Q8 forbids a reviewer agent; three reviewers already cover it; a fourth would be a detector needing its own closer (OP-12). | A `capability-reviewer`. |
| D9 | The command implements; it is not advisory. | Q12 and lifecycle behaviours 8–13. `/leverage-idea` already owns the advisory-plan-only niche. | Stop-at-plan. |
| D10 | **Confidential trial material and generated review briefs live in an OS temp directory created by `mktemp -d`, never in the repository.** | F37 disproves v1's premise. One rule now covers both B1 and I7. | v1's "session scratchpad" — inside the repo (F37). A gitignored in-repo directory — one `git add -f` from a leak. |
| **D11** | **Counts are derived at write time and state their command; never recalled.** | Every count in v1 was wrong. This is the repo's logged recurring defect class (`axcion-communication-system/CLAUDE.md:40`) — *"a count feels like a description of text already written, which is exactly why it gets produced by recall."* | Restating v1's figures. |
| **D12** | **`paused` requires a concrete reopening trigger** — a date, a quarter or a named event. | Mirrors the `Review-cycle:` discipline that stops `improvement-log.md` parks from becoming permanent (`leverage-idea.md:165`). Without it, `paused` is how a capability dies quietly while still counting as active. | Allowing a bare `paused`. |

---

## 3. Current capability and overlap map

Bounded semantic sweep across 91 commands, 80 skills, the agent library, `ai-resources/docs/`, and `projects/project-planning/.claude/commands/`. Searched by purpose and behaviour, not name.

### 3.1 Covers part of the need

| Resource | Covers | Does not cover | Boundary rule |
|---|---|---|---|
| `/develop-ai-resource` | Need statement, evidence classification, capability disposition, intervention ladder, complexity budget, no-build verdict, build, verify, decide — **for AI artifacts** (F3, F4). | Business/operational/product capabilities. Ownership and seams. Slice planning. Real-use trials. Cross-project seams. Lifecycle statuses beyond ship/revise/defer/delete. Multi-session state. | Outcome vs. artifact (§ 5.1). Receives pre-qualified briefs in upstream mode; never reopens the operating need; never makes the business-adoption call (§ 14.3). |
| `/scope-project` | Stages 0–5 producing a control pack and planning brief; can end Park / Do Not Build (F21). | Implementation, verification, real use, closure. Stops at a brief. | Routed *to* when the work is a project (§ 14.1); consumed by Heavy when formal planning is warranted (§ 14.2). |
| `/new-project` Step 0 | Existing-ownership inspection with a read budget; dispositions A/B/C/fallthrough (F22). | Anything after project creation. Disposition B returns a handoff and stops — it does not develop in the owning project. | § 5.3 is a deliberate sibling of Step 0.2, tuned for capabilities. Documented, not silently forked. |
| `/mission` | Multi-session goal contracts with frozen scope and a validation contract (F17). | Seams, slices, verification evidence, lifecycle statuses, real-use results. | Adjacent (§ 12.6). Excluded from v1 integration (OQ-3). |
| `/tech-consult` | Broad need → build-ready technical plan, stopping at a Selection Memo. | Implementation, verification, adoption, closure. | Optional Shape adjunct at Heavy when technical shape is genuinely open. Not a stage. |

### 3.2 Adjacent but different

`/leverage-idea` (idea dumps about workspace AI resources; stops at a plan) · `/implementation-triage` (ROI verdict on an existing proposal; chat-only) · `/risk-check` (structural risk of a change) · `/qc-pass` (artifact review against a scope line) · `/post-project-review`, `/archive-project` (project granularity, not capability) · `/innovation-sweep` (infrastructure triage at project end) · `/reconcile` (deliverable vs. mandate rubric) · `/project-next-steps` (read-only project orientation) · `/requirements-pack` (an artifact shape, not a lifecycle) · `axcion-linkedin-os` (a built example, not a resource — cite, do not couple).

### 3.3 Downstream dependency

`/create-skill`, `/improve-skill`, `/migrate-skill` — reached only through `/develop-ai-resource` (F5). `/graduate-resource` (F24) — reached only for a later promotion. The `/plan-draft` chain — only through § 14.2. `qc-reviewer`, `risk-check-reviewer`, `system-owner` — through their owning commands, never spawned directly.

### 3.4 Conflict or duplication risk

| Risk | Assessment | Mitigation |
|---|---|---|
| **Double qualification with `/develop-ai-resource`** | **Highest-severity risk in this design.** Both commands begin from "is this need real, and what is the smallest thing that serves it." Codex additionally found that v1's clause left `/develop-ai-resource`'s Step 4 operator gate in place, adding an uncounted stop (B4). | § 14.3's upstream mode: the brief declares what is settled; § 18.3's clause reads rather than re-derives, keeps artifact-scoped qualification intact, and **explicitly reassigns the Step 4 disposition** — artifact quality to Claude, business adoption to G3. AT-11, AT-12, AT-13 test all three failure directions. |
| **Front-half overlap with `/scope-project` Stage 0–1** | Moderate. Both inspect reality and can conclude "do not build." | Granularity differs: `/scope-project` decides whether a *project* exists; Frame decides whether a *capability* exists inside one that already does. Frame routes out the moment the answer is "project" (§ 14.1). |
| **Record vs. `/mission` contract** | Low-moderate. | Different directories, lifecycles and consumers. § 12.6 states which to use. v1 integration excluded (OQ-3). |
| **A fourth state file per project** | Real. Projects already carry `CLAUDE.md`, `logs/decisions.md`, often `pipeline/`. | Lightweight adds nothing. Records are per-capability and leave the active set at a terminal status. No registry (§ 12.7). |
| **Two commands both named `/develop-`** | Low but real. | § 18.5's routing line states the test in one sentence; both command files carry the identical reciprocal paragraph. |
| **Cross-project change with no landing path** | **Was unmitigated in v1** (B5). | § 14.9's sibling-project change request. |

---

## 4. `/develop-capability` — purpose, trigger, exclusions

### 4.1 Purpose and definition

> An **operating capability** is a durable ability Axcíon exercises to perform real work: preparing a buyer email, deciding whom to contact and why, producing a sector report to a fixed standard, maintaining an approved-language register. It may be implemented through documents, standards, processes, data structures, integrations, software, AI resources, or any combination. It is defined by the outcome it produces, never by the artifacts it is made of.
>
> This is **not** the sense used in `projects/axcion-communication-system/capability/`, which means human communication proficiency. Where confusion is possible, write *operating capability* in full.

### 4.2 Trigger

`/develop-capability [outcome or observed need]`

Fires when: the session is inside — or can name — an existing Axcíon project; the operator wants Axcíon to be able to *do* something it cannot reliably do today, or wants an existing ability improved; and the desired end state is an outcome, not an artifact.

With no argument, the command attempts resume (§ 15.1) before asking for a need.

### 4.3 Exclusions

| Excluded | Owner |
|---|---|
| Creating a new project | `/scope-project` → `/plan-draft` chain → `/new-project` |
| Authoring an AI resource | `/develop-ai-resource` |
| Repository redesign, architecture review, recurring audits, permission redesign | `/systems-review`, `/architecture-review`, `/friday-checkup`, `/permission-sweep` |
| Incident recovery, broken repo state, workflow faults | `/resolve-repo-problem`, `/resolve-incident` |
| Promoting a project-local resource to canonical | `/graduate-resource` |
| Project-level closure and archiving | `/post-project-review`, `/archive-project` |
| Research execution | the research workflow and its deploy command |
| ROI judgment on an existing proposal | `/implementation-triage` |
| Idea dump → leverage options | `/leverage-idea` |

**It also does not:** create a registry; write into another project's tree (§ 14.9 gives the compliant path); commit confidential material; spawn a new reviewer agent; exceed § 11's stop counts; or expand scope because it noticed an adjacent improvement.

### 4.4 The complexity-budget conflict, and the corrected OP-11 rationale

- **Prong (a), net-simplification: FAILS.** Two load-bearing units added, none removed, plus one always-loaded routing line.
- **Prong (b), evidenced failure: FAILS.** No historical failure pattern (Q4). Rule #7 is explicit that forward-looking justification does not satisfy (b).
- **RR-05 replacement test:** replaces nothing. Separateness rests on three different lifecycles with different inputs, owners and terminal states, which locks #1–#5 forbid merging.
- **RR-05 invocation path:** satisfied by § 18.5's workspace routing rule for initiation. Resumption relies on existing continuity mechanisms (I4) — a deliberate v1 limitation with a named reversal trigger (§ 23).
- **OP-12:** not applicable; this is not a detection component.

**Why the `/new-project` precedent is cited for form only.** Codex is right that it is merely analogous. That decision carried **measured** operating cost — approximately 5,600 tokens per session across two commands made optional (`logs/decisions.md:87`). This capability pipeline has no measured cost to point at, because nothing has run. Borrowing the precedent's *reasoning* would be dishonest. What it legitimately supplies is the **form**: OP-11 is the repository's declared mechanism for a deliberate, recorded budget exception, and it has been used before at operator direction.

Entry to append to `ai-resources/logs/decisions.md` at Commit 5:

```markdown
## 2026-07-DD (S{n}-{marker}) — Land `/develop-capability` + `capability-development` skill as a deliberate OP-11 complexity-budget exception

**Context.** Axcíon has no method for developing an operating capability — a business,
operational or product ability — inside an existing project. Project creation is owned by
`/scope-project` + `/new-project`; AI-artifact authoring by `/develop-ai-resource`. Neither
covers need-to-adoption development of an operating outcome. Two capabilities are intended
near-term (EmailOS, Contacting Strategy) and neither has a development path.

**Decision — build it, and record the budget miss rather than conceal it.** The complexity
budget (`docs/ai-resource-creation.md:25-34`) requires net-simplification or cited written
evidence. This change clears neither: it adds two load-bearing units and removes none, and
the need is a forward-looking operator requirement, not a logged failure pattern. Per rule
#7's closing clause, that makes this a loud, recorded OP-11 exception.

**Rationale — stated honestly, not by borrowed precedent.** The operator is knowingly funding
two new load-bearing components for two named near-term uses, accepting that the evidence is
prospective rather than historical. That is a legitimate call for an operator to make about
their own operating model; it is not a demonstration that the budget was satisfied, and this
entry does not claim otherwise.

The exception is bounded by reconsideration gates rather than by argument. Build-plan § 24
sets them: `/develop-capability` carries its own status of **continue trial** from day one and
is not adopted until three capabilities have completed a full lifecycle across at least one
lane each, at least one has ended in a non-build outcome, and at least one has been resumed
across sessions. If fewer than three capabilities are developed in twelve months, the need was
not real and the component is removed — explicitly, not left in place because removing it
requires a decision. First formal review after the third completed lifecycle or 2027-01-31,
whichever is sooner.

The 2026-07-23 `/new-project` direct-route exception is cited **for form only** — it is the
precedent that OP-11 is the mechanism for a deliberate recorded exception at operator
direction. Its own reasoning does not transfer: that decision cited measured operating cost
(~5,600 tokens/session, `logs/decisions.md:87`); this one has no measured cost because nothing
has run yet.

**Alternatives considered.**
- *Defer until a capability fails without it.* Rejected by the operator — the first failure would land on EmailOS, which touches confidential buyer data.
- *Broaden `/develop-ai-resource` to cover operating capabilities.* Rejected — forbidden by operator locks #2–#4, and it would give one command two different terminal states.
- *Invent friction-log evidence to clear prong (b).* Rejected outright. Fabricated evidence in a gate record is worse than a recorded exception.
- *Ship Lightweight + Medium only, Heavy as a routing exit.* Rejected by the operator and on merit — a routing exit cannot own the seam, the record, the trial or the adoption decision.

**Decided by:** Patrik (operator), 2026-07-DD, after independent Codex review (verdict: Revise;
all findings dispositioned in build-plan v2 § 0) and `/qc-pass`. Executed by Claude.
Gate reports: `audits/risk-checks/{plan-time}` and `audits/risk-checks/{end-time}`.
Plan: `plans/2026-07-28-develop-capability-build-plan-v2.md`.
```

---

## 5. Boundary map against neighbouring commands and project lifecycles

### 5.1 The load-bearing distinction

> **`/develop-capability` owns the operating outcome. `/develop-ai-resource` owns the artifact.**
> "Prepare one useful buyer email" is an outcome. "Author the drafting skill that workflow needs" is an artifact.
> **The skill is not the capability. It is one implementation component.**

Identical wording in four places: the command, the skill, workspace `CLAUDE.md`, and the reciprocal paragraph in `/develop-ai-resource`.

### 5.2 Routing table

| The operator says… | Goes to |
|---|---|
| "I want to be able to prepare a buyer email properly" | `/develop-capability` |
| "We need a skill that drafts buyer emails" | `/develop-ai-resource` |
| "Buy-side outreach should become a whole programme with its own repo" | `/scope-project` |
| "This command is broken" | `/resolve-repo-problem` |
| "Here are three pages of notes about improving the repo" | `/leverage-idea` |
| "Is this proposed implementation worth doing?" | `/implementation-triage` |
| "Should this project-local thing become shared?" | `/graduate-resource` |
| "Where should this new file live?" | `/placement` |

### 5.3 Owner selection

Apply in order; stop at the first criterion that discriminates:

1. Which project owns the primary operating outcome?
2. Which project owns the capability's continuing decisions and maintenance?
3. Which authoritative source should define its behaviour?
4. Which project would still own it if one dependency were replaced?

Binding rules:

- **Dependencies never become co-owners.** Reading from CRM does not make the CRM project a co-owner; it makes CRM an external dependency in the seam.
- **Evidence, not names.** Every ownership conclusion cites the file and line supporting it. A directory name is not evidence.
- **Absence is not evidence.** An empty directory, an unpopulated cell, or a search finding nothing is evidence about that source, never a positive fact about ownership. (Recurring defect class logged HIGH at `axcion-communication-system/CLAUDE.md:44` — three instances, one producing a real out-of-scope action.)
- **A dependency is not a consumer.** A project the capability *reads from* does not thereby become a consumer under H3. A consumer is a party that depends on the capability's output or must change its own artifacts because of it.
- **Route out when no project qualifies** — a conclusion with a named failing criterion, never a default.

### 5.4 Reciprocal text added to `/develop-ai-resource`

Appended to its **Boundary vs neighbours** block (`develop-ai-resource.md:19-23`) as a sixth bullet:

```markdown
- `/develop-capability` develops **operating capabilities** — business, operational and
  product abilities inside existing projects. It owns the operating outcome; this command
  owns the artifact. The skill is not the capability; it is one implementation component.
  A brief arriving from it carries `**Capability:**` and `**Settled upstream:**` and runs
  in upstream mode — see Step 1.0 and Step 4's upstream-mode clause.
```

---

## 6. Lane-routing model, escalation and de-escalation

### 6.1 Principle

Lane is a judgment about **consequence**. Never about file count, line count or effort. A one-line change altering what Axcíon sends a real buyer is Heavy. A three-hundred-line internal reference with one owner and no external reader is Lightweight.

Heavy triggers first, then Medium, then Lightweight as residual. Any single trigger fires its lane. Ambiguity resolves **upward** (`new-project.md:58`'s posture).

**A mandatory `/risk-check` class does not imply Heavy.** The class list (F8) does not distinguish shared from project-local, so a project-local command fires `/risk-check` while remaining a Medium capability. The gate and the lane are independent judgments — one asks "does this change need structural review," the other asks "how consequential is this capability." Conflating them was a v1 error (Codex I4).

### 6.2 Heavy triggers — any one fires

| # | Trigger | Test |
|---|---|---|
| H1 | **External or shared system integration.** The capability reads from or writes to a system outside the owning project in normal operation — CRM, Gmail, Notion, an API, another project's tree, another ecosystem tool. | Name the system and the direction of flow. A human copy-paste is not an integration. |
| H2 | **Real confidential data in normal operation.** Buyer, client, relationship, deal or commercially sensitive information flows through the capability when it runs — not merely during a trial. | Name the data class and its authoritative source. |
| H3 | **Two or more consumers, or a second project must change.** A party other than the owner depends on its output, or must alter its own artifacts to accommodate it. | Enumerate consumers. **A dependency is not a consumer** (§ 5.3). **A consumer that does not yet exist is not a consumer** — a speculative future capability cannot be counted (AP-7/DR-7). |
| H4 | **Difficult reversibility.** Undoing it after adoption costs more than reverting a commit — published artifacts, external records, sent communications, data migration, or a habit others build on. | State the concrete undo procedure. If you cannot, it is H4. **Note: a capability that *produces a draft for human review* is not irreversible; the *sending* is.** |
| H5 | **Canonical ownership change.** It claims, moves or contradicts a responsibility another project's authority document holds. | Cite the authority document and the clause. |
| H6 | **Genuinely shared infrastructure.** Narrowed per Codex I4 — it creates or changes: an `ai-resources` resource consumed beyond the owning project; a hook; or automation with shared-state effects (auto-write to logs, cross-repo writes, auto-commit). **A project-local command, skill or agent used only inside the owning project does not fire H6** — it fires M4, and separately triggers `/risk-check` per F8. |

### 6.3 Medium triggers — any one fires, when no Heavy trigger fired

| # | Trigger | Test |
|---|---|---|
| M1 | **The operating workflow is not demonstrated.** Nobody has produced the intended result this way, even by hand. | Has one real case run end to end with the result observed? If no → M1. |
| M2 | **Three or more distinct behaviours, or work plainly spanning sessions.** | Count behaviours, not files. |
| M3 | **Ownership is ambiguous.** More than one project could plausibly own it, or it depends on a sibling's authority document. | § 5.3 criteria 1–2 did not discriminate cleanly. |
| M4 | **It needs an AI resource that does not exist** — including a **project-local** command, skill, agent, hook-free script or persistent instruction used only inside the owning project. A § 14.3 handoff is required. Where that artifact is a command or skill, `/risk-check` fires at Prove (F8) **without** changing the lane. | The artifact must be authored, not merely used. |
| M5 | **Verification needs more than reading the diff** — a trial, a real record, or comparison against a written standard. | Can a human confirm correctness from the output alone? If no → M5. |

### 6.4 Lightweight — the residual

No Heavy and no Medium trigger. Concretely: one owner, one project, a workflow already understood, reversible by revert, one or two behaviours, no external system, no confidential data in operation, no new AI resource, and verification is "look at the result."

Lightweight still performs the full lifecycle. It does it in one session, in chat, with no dedicated files.

### 6.5 How the lane is announced — and where Heavy stops

**This is the contract Codex found contradictory in v1 (B3). There is exactly one Heavy stop location, and it is G1 at the end of Shape.**

- **Lightweight / Medium.** One line, then continue: `Lane: {lane}. {trigger, or "no Medium or Heavy trigger fires"}. Say so if that is wrong.`
- **Heavy.** State the lane, name every trigger that fired, and state the consequence in plain English — how many stops, that Codex review will be required, whether confidential data is involved, what the release step will be. **Then continue into a bounded Shape.** Do **not** stop here. The stop is G1, taken at the end of Shape, where the operator has an evidence-backed package worth approving rather than a bare classification.

**Why.** Operator Q6 said "stop at classification"; Q7 said "Includes confirmation of the Heavy lane. Do not create a separate earlier lane-confirmation stop." Q7 is more specific and governs. Codex reached the same conclusion independently: a stop at classification asks the operator to approve a label, not a plan.

**The bound on pre-G1 Shape** (§ 9.2) prevents this from becoming unbounded work before any approval: no implementation, no external handoff, and no trial using real confidential data. A trial requiring real data waits until after G1.

### 6.6 Escalation

Additive. Nothing produced is discarded.

| From | To | What happens |
|---|---|---|
| Lightweight | Medium | State the newly fired trigger. Open the record and backfill from work already done. Continue from the current phase. No stop. |
| Lightweight or Medium | Heavy, **during Frame or Shape** | State the triggers. Open or upgrade the record. Continue to the end of a bounded Shape, then take **G1**. Consistent with § 6.5. |
| Lightweight or Medium | Heavy, **during Build, Prove or Land** | State the triggers. Open or upgrade the record. **Stop immediately for G1**, naming exactly what has already been built and committed. |

**Why the split.** Escalating in Frame or Shape means nothing irreversible has happened, so completing Shape produces a better approval object. Escalating in Build or later means Heavy obligations — package approval, Codex review before implementation — were skipped while work accumulated. Continuing would deepen that gap. The operator confirms Heavy knowing exactly what already exists.

**Mandatory re-test points.** The lane call is re-tested at every phase boundary, and always on discovering: a second consumer; an external system; real confidential data; an irreversible step; a conflicting authority document. Silent when nothing changed.

### 6.7 De-escalation

Requires a trigger to be **disproven by evidence**, not doubted. Only at a phase boundary, and never after an operator stop approved the heavier lane for that phase.

| From | To | Condition |
|---|---|---|
| Heavy | Medium | Every Heavy trigger disproven with cited evidence. Requires operator acknowledgement in one line, because they approved Heavy at G1. |
| Medium | Lightweight | Every Medium trigger disproven. State and proceed. |

**Artifacts are never discarded on de-escalation.** A record already opened stays open and is completed. Deleting a record to make a lane change look clean is prohibited — it destroys the decision history that makes the change auditable.

### 6.8 Recording

Lightweight — one clause in the closing `logs/decisions.md` entry. Medium/Heavy — a dated, append-only list in the record's `## Lane` section; frontmatter `lane:` shows the current lane.

---

## 7. Detailed Lightweight process

**Governing feel:** one session, chat-first, no dedicated files, no subagents, no mid-run stops. If it feels heavier, the lane is wrong — re-test § 6.

### Phase 1 — Frame

1. **State the operating outcome in one sentence**, as a result, not a system. If the input names a system, restate it and say you have done so.
2. **Inspect reality — bounded.** Project `CLAUDE.md`, then at most **four** further files chosen for relevance. Exceeding four is a finding to report, not licence to keep reading.
3. **Separate facts from inference.** Three short lists: confirmed (with paths), inferred, unknown.
4. **Walk the intervention ladder** and name where you stopped: accept the limitation → change an operating habit → clarify ownership or information flow → reuse an existing capability → simplify or remove the source → narrow local improvement → bounded experiment → build. Say why not the rung below.
5. **Lane call** — state and proceed.

**Exit:** outcome, evidence, rung and lane stated. **A no-build, manual or reuse outcome exits here to Phase 5** and is a success.

### Phase 2 — Shape

6. **Name the one owner.** One line.
7. **State the observable behaviour** — what must demonstrably work, in the operator's terms. One to three bullets. This is the acceptance condition.
8. **State the exclusions.** One line. This is what stops adjacent-improvement creep.

### Phase 3 — Build

9. **One complete slice** — a whole behaviour, end to end, useful on its own. Not a layer. If it will not fit one slice, that is M2 — escalate.
10. **Implement the smallest coherent change** that satisfies it.

### Phase 4 — Prove — **before the commit, not after** (Codex I3)

11. **Verify.** Read the produced artifact from disk — not from memory of writing it — and compare it against the Phase 2 observable behaviour.
12. **Match evidence to claim.** Runtime → execution. File-scope → the diff. Factual → the source. A claim not tested is **unassessed**, never passed.
13. **`/risk-check` if a mandatory class fired** (F8) — for example a project-local command or skill. **This does not change the lane** (§ 6.1); run the gate and stay Lightweight unless a Heavy trigger separately fires.
14. **Commit** the verified slice. Per workspace `CLAUDE.md`: commit directly, no pre-commit checks, no push. Committing after verification means the first commit records a verified result rather than a draft plus a fix-up — the same discipline `new-project.md:137` enforces.

### Phase 5 — Land

15. **Demonstrate use.** Run it, or show the artifact doing its job, once. Show the operator something visible — a diff, a printed result, the finished document.
16. **State the recommended status and ask for acceptance** (Codex I1). Lightweight has no mid-run stop, but **Claude does not declare adoption.** State: what was needed, what was built, what the demonstration showed, and the recommended status — adopt · revise · keep local · close · reject. The operator accepts, or redirects. Acceptance may be as light as one word; it may not be assumed from silence within the same turn.
17. **Record — after acceptance.** If durable project behaviour was created or changed, append **one** entry to `projects/{project}/logs/decisions.md` in that file's canonical shape, naming the capability, the outcome and the **accepted** status. If the outcome was no action and nothing durable was decided, write nothing — chat is the record, and git history plus the changed artifact are the evidence.

**Planned operator stops: zero. Operator acceptance of the demonstrated outcome: required.**

---

## 8. Detailed Medium process

**Governing feel:** may span sessions; one durable record; one operator stop at the end; fresh-context Claude review where the claim warrants it.

### Phase 1 — Frame

1–4. As Lightweight, with a **twelve-file** read budget: project `CLAUDE.md`, `logs/decisions.md`, authority documents the capability touches, existing `development/*.md` records. Exceeding twelve is reported.
5. **Existing-capability disposition.** Search by purpose and behaviour — not name — across the owning project and the projects the need plausibly touches. Disposition every near-match as **covers it · covers part of it · adjacent but different**, with the path. Reuse beats build.
6. **Lane call** — state and proceed.
7. **Open the record** at `projects/{owner}/development/{slug}.md`, phase `frame`, status `in-development`. Frame's outputs go into it now; it is not a wrap-up artifact.

**Exit:** record holds verified need, facts/inferences/unknowns, ladder rung, lane and rationale. A no-build outcome closes it `status: rejected` and exits to Phase 5.

### Phase 2 — Shape

8. **Terminology.** Define only the consequential terms that could mean two things. Each means one thing; two concepts never share a name.
9. **Ownership.** Apply § 5.3. Record the owner with cited evidence; record each dependency as a dependency, not a co-owner.
10. **Seam** — the SOP's seven fields: Input · Output · Owning capability · External dependencies · Observable failure states · Side effects · How behaviour will be tested. Small enough that the operator never coordinates internals.
11. **Real-case trial — required when M1 fired.** One genuine case, by hand or with temporary tooling, before committing to permanent work. It answers: does the workflow produce value; can the operator use it; what information is actually needed; which assumptions were wrong; where are the real boundaries; is permanent work still justified. Apply § 12.8 data handling. **Stop condition: a trial that does not produce a useful result stops the build.** Record the observed result, including a negative one, and re-enter step 5.
12. **Thin implementation package** — into the record, not a separate document. Eleven short fields: verified need · intended outcome · users · public interface · observable behaviours · ownership and dependencies · smallest useful version · exclusions · verification · adoption condition · retirement condition. It states outcome, boundaries, behaviour, evidence and exclusions. It does **not** dictate functions, files or abstractions.
13. **Vertical slices** — two to five complete behaviours, ordered. Each independently understandable, independently testable, small enough to review, useful end to end, separately committable. Slicing by layer is wrong and must be rewritten.
14. **AI-resource handoffs identified now**, as § 14.3 briefs — not discovered mid-build.

**Exit:** package complete, slices ordered, first slice is a complete behaviour. Record at phase `shape`.

### Phase 3 — Build

15. **Per slice: reproduce-or-fail → implement → refactor → verify → update the record → commit.** The record update is **inside** the slice cycle, before the commit (Codex I3), so the commit captures both the code and the state that describes it. A commit whose record still points at the previous slice is a resume hazard.
    - *Reproduce or fail* — a behavioural check or reproducible failure, confirmed failing for the expected reason.
    - *Implement* — the smallest coherent change.
    - *Refactor* — naming, boundaries, duplication, behaviour staying green.
    - *Verify* — the targeted check, relevant surrounding checks, deterministic checks, and a representative runtime or operator-path demonstration.
    - *Update the record* — tick the slice, update `next action` and `updated:`.
    - *Commit* — the coherent slice plus its record update.
16. **Fire § 14.3 handoffs** as each slice needs its artifact. Resume the slice when the artifact returns with its disposition.
17. **Scope discipline.** Adjacent improvements are not added. A material scope change is a recorded decision, not a longer diff. If it alters the seam or the exclusions, re-test the lane.

**Exit:** every slice has a failing case, a correction, verification, a record update and its own commit; nothing outside approved scope changed.

### Phase 4 — Prove

18. **Self-review — both questions, separately** (§ 16.3).
19. **Match evidence to claim** (§ 16.1). Every claim marked observed · unassessed · blocked.
20. **`/qc-pass`** on the built result, with an explicit scope line. On agent-type resolution failure from a project session, use the `qc-pass.md:24` fallback and label the verdict `(fallback: general-purpose, opus re-asserted)`.
21. **`/risk-check`** if a mandatory class fired — for example a project-local command (M4). Lane unchanged (§ 6.1).
22. **Simplify.** Remove instructions, content or machinery not contributing to the demonstrated behaviour, then rerun every materially affected case.

**Exit:** both questions answered, every claim marked, verdicts recorded with paths.

### Phase 5 — Land

23. **Real use.** The capability enters its real operating environment and is used at least once for its actual purpose. The outcome is observed and recorded. Technical completion is not project completion.
24. **Operator stop G3 — the lifecycle decision.** Present: what was needed; what was built; what was tested and observed; what the real use showed; what remains open; the recommended status and why. The operator chooses **adopt · continue trial · revise · keep local · pause · close · retire · reject**. Inactivity is not a status. A `paused` choice requires a concrete reopening trigger (D12).
25. **Record closure — after the decision.** Write the status into frontmatter and `## Lifecycle status` with the date and who decided. Append one summarising entry to the project's `logs/decisions.md`. Remove nothing.

**Planned operator stops: one.**

---

## 9. Detailed Heavy process

**Governing feel:** consequential work. Deeper inspection, an approved package, Codex review at two points, controlled release, three operator stops. Every obligation exists because a specific trigger fired — Heavy is not "Medium with more ceremony."

### 9.1 Phase 1 — Frame (deeper)

1–5. As Medium, plus:
6. **Consumer inventory.** Every project, workflow, document, external system and person that depends on, or will be changed by, this capability. Grep-based where possible. **A dependency is not a consumer; a consumer that does not yet exist is not a consumer** (§ 6.2 H3).
7. **Authority inspection.** For every project touched, read its authority surface and cite the clause granting or denying ownership. Absence in a source is evidence about that source, not about the world.
8. **Reversibility statement** — the concrete undo procedure for each irreversible-looking step. If none can be stated, H4 is confirmed.
9. **Data-flow statement** (if H2 fired) — which data class, which system is authoritative, where it flows, what may not leave Axcíon's boundary, and what may go to which external model or tool.
10. **Lane announced, not stopped** (§ 6.5). State lane, triggers and consequence; continue into bounded Shape.
11. **Open the record**, phase `frame`, lane `heavy`.

**Exit, or route out:** if § 5.3 finds no legitimate owner, or the work is a new enduring programme, take the § 14.1 handoff and stop, naming the failing criterion.

### 9.2 Phase 2 — Shape (bounded, then G1)

**Bound on pre-G1 work — three hard limits.** Before G1 the command may **not**: begin implementation; fire any external handoff (§ 14.2, § 14.3, § 14.9); or run a trial using real confidential data. A trial requiring real data waits until after G1; a synthetic trial may run before it. This is what keeps "bounded Shape" from becoming unbounded work before approval.

12–18. As Medium steps 8–14, strengthened:
- **Seam at two levels** — technical (interfaces, data, failure states) and operating (who decides what, which system is the official record, what a human must approve). `axcion-linkedin-os/CLAUDE.md:14-16` (authority order) and `:23-25` (human checkpoints) are the reference.
- **Trial mandatory** unless the workflow is already demonstrated in production. Synthetic before G1; real-data trial after.
- **Package durable and versioned** in the record — this is what the operator signs and Codex reviews.
- **Release plan** — how it first enters real use (limited trial, single real case, restricted consumer set) and the rollback path.

19. **Compose Codex review brief #1** (§ 16.4) on the package. Written to the OS temp directory, never the repository (§ 12.8).

20. **OPERATOR STOP G1 — scope and implementation-package approval.** Present the package, the Heavy lane and its triggers, the consequence in plain English, and brief #1's path. The operator confirms Heavy, approves scope, and takes the brief to Codex. Work resumes when findings return.

21. **Adjudicate findings.** Codex findings are **claims to be tested, not instructions.** Verify each against the repository first. Disposition every material finding: accept and fix · accept and defer with a concrete trigger · reject with cited evidence. Record all dispositions in the record. Only business-risk or maintenance-burden disagreements reach the operator.

22. **Formal planning handoff** (§ 14.2), if warranted — after G1, since it is an external handoff.

### 9.3 Phase 3 — Build

23–26. As Medium steps 15–17, plus:
- **Failure and recovery behaviour implemented as a slice**, not documented as an intention. A control not demonstrated in its real invocation path does not count.
- **Confidential material never enters the repository** (§ 12.8). Durable records carry decisions, schemas, evidence summaries and redacted or synthetic examples only.
- **Commit per slice**, record updated inside the cycle.

### 9.4 Phase 4 — Prove

27–31. As Medium steps 18–22, plus:
- **Behavioural, integration, failure and recovery testing.** Integration tests exercise the real seam. Failure tests confirm visible, recoverable failure. Recovery tests confirm the stated undo actually works.
- **`/risk-check`** at both gates when any listed class was touched (`docs/audit-discipline.md:73-81`).
- **Codex review brief #2** — the implemented result: what was built, what was tested and observed, what is unassessed, the release plan, the rollback path, and the claims most worth attacking.

32. **OPERATOR STOP G2 — release / real-trial approval.** Present the built result, the evidence table, review verdicts, the release plan, the rollback path, and brief #2's path. The operator runs Codex and approves entry into the real operating environment. Findings adjudicated as in step 21.

### 9.5 Phase 5 — Land

33. **Controlled release / limited trial**, exactly as approved.
34. **Observe and record the outcome** — what happened, what the operator experienced, what did not work.
35. **OPERATOR STOP G3 — lifecycle decision.** One of eight statuses, plus a restated retirement condition and rollback method — a Heavy capability that cannot be removed later is a permanent liability.
36. **Record closure** as Medium step 25, plus a `logs/decisions.md` entry, plus — if a shared resource changed — the consumer confirmations `docs/ai-resource-creation.md:21` requires.

**Planned operator stops: three.** An adverse verdict, a blocking unknown or a material scope change may cause an **exceptional pause** — failure conditions, not planned gates.

---

## 10. Shared lifecycle invariants across all lanes

| # | Invariant | SOP step | Lightweight | Medium | Heavy |
|---|---|---|---|---|---|
| 1 | Start from the operating outcome, not a proposed system | 1 | one sentence | + record | + record |
| 2 | Inspect reality before planning | 2 | ≤4 files | ≤12 files | + consumer inventory + authority citation |
| 3 | Separate facts, inferences, unknowns, proposals | 2.2 | three short lists | recorded | recorded + Codex-reviewed |
| 4 | Intervention ladder including no-build | 3 | name the rung | + disposition near-matches | + consumer-aware disposition |
| 5 | Real case before permanent implementation when undemonstrated | 4 | n/a (M1 escalates) | required on M1 | mandatory; synthetic pre-G1, real post-G1 |
| 6 | Terminology, one owner, small seam | 5 | owner named | terms + owner + 7-field seam | + operating seam + authority citations |
| 7 | Thinnest package for the lane | 6 | 3 lines | 11 fields in the record | durable, versioned, approved, reviewed |
| 8 | Complete vertical behaviours, not layers | 8 | one slice | 2–5 ordered | + failure/recovery slices |
| 9 | Implement and verify one slice at a time, **verify before commit** | 9 | verify → commit | verify → record → commit | verify → record → commit |
| 10 | Match evidence to claim type | 10 | stated inline | recorded per claim | + independently reviewed |
| 11 | Independent review by consequence, not habit | 7, 11 | none unless a class fires | `/qc-pass`, `/risk-check` by claim | Codex ×2 + `/risk-check` |
| 12 | Real operating use before adoption | 12 | demonstrate once | real use, observed | controlled release, observed |
| 13 | End with an explicit status, **accepted by the operator** | 13 | recommended → accepted | operator decides (G3) | operator decides (G3) |

**Two further invariants from the foundational document:**

14. **Conflicts are surfaced, not silently resolved.** Two authoritative sources in genuine conflict, with no establishable precedence, stop the work.
15. **A control that cannot run reports "unassessed," never "passed."**

---

## 11. Operator gates and decisions

### 11.1 Gate table

| Lane | Planned stops | Where | Operator acceptance |
|---|---|---|---|
| Lightweight | **0** | — | Required at Phase 5 for the status (§ 11.5) |
| Medium | **1** | G3 — lifecycle decision after observed use | The stop is the acceptance |
| Heavy | **3** | G1 end of Shape · G2 end of Prove · G3 Phase 5 | The stops are the acceptance |

**No other planned stop exists.** No separate lane-confirmation stop. No stop for a passing review verdict. No per-slice approval. No stop for terminology, seams or slice ordering. **And no stop inside a handoff** — § 14.3's upstream mode explicitly reassigns `/develop-ai-resource`'s Step 4 gate so it cannot reappear as an uncounted fourth stop (B4).

### 11.2 What each stop asks

- **G1 (Heavy, end of Shape).** *Is this worth doing at this weight, with this scope, owned here, excluding these things?* Includes Heavy-lane confirmation and Codex brief #1. Placed after Shape so the operator approves an evidence-backed package, not a label.
- **G2 (Heavy, end of Prove).** *May this enter the real operating environment?* Includes Codex brief #2 and the rollback path.
- **G3 (Medium and Heavy).** *Given what actually happened when it was used, what status does this carry?*

### 11.3 Exceptional pauses

Failure conditions, reported as such, in any lane: an adverse review verdict (`RECONSIDER`, or a Codex finding invalidating the premise) · a blocking unknown no evidence can close (produce a requirements doc and stop) · a material scope change altering seam, owner or exclusions · two authoritative sources in genuine conflict · escalation into Heavy during Build or later (§ 6.6) · a confidentiality question the rules do not answer · any of the ten workspace pause triggers.

### 11.4 What the operator is never asked

File structures, schemas, directory names, integration design, test selection, slice ordering, whether to run `/qc-pass`, which agent to spawn, or to validate a recommendation. They are asked business questions: is this worth doing, is this burden acceptable, may this go live, is this useful in practice, what status does it carry.

### 11.5 Operator acceptance in Lightweight (Codex I1)

Lightweight has no mid-run stop, and that is deliberate. It does **not** follow that Claude may declare adoption. The distinction:

- **A stop** halts work until the operator responds, and Claude may not proceed.
- **Acceptance** is the operator agreeing that a demonstrated outcome is useful. Only they can give it.

So Lightweight ends by demonstrating the result and stating a **recommended** status. The status becomes final on acceptance — one word suffices. It is **not** inferred from silence within the same turn. Until accepted, the `logs/decisions.md` entry is not written; the work is committed and the artifact exists, but nothing is recorded as adopted. This matches the foundational standard: *"the operator accepts the demonstrated result."*

---

## 12. State and artifact model

### 12.1 Discovering the project's authoritative state

In order, stopping when sufficient:

1. **Project `CLAUDE.md`** — the authority surface. Present in 26 of 27 projects (F14). Always first.
2. **`projects/{p}/development/*.md`** — existing records. Any in the **active-status set** (§ 12.5) is live work.
3. **`projects/{p}/logs/decisions.md`** — durable decisions (26 of 27). Read the tail; grep for terms the need names.
4. **Authority documents the need touches** — `standards/`, `doctrine.md`, `vocabulary.md`, `governance/`, `reference/`. By relevance, not enumerated blindly.
5. **`pipeline/project-plan.md`** — only when a plan spine is relevant, bounded read.

**Explicitly not read as live state: `pipeline/pipeline-state.md`** (F15, operator Q9).

**Read budget:** four files at Lightweight, twelve at Medium and Heavy. Exceeding it is reported, not treated as permission to continue.

### 12.2 Lightweight — zero dedicated files

The changed artifact, committed · git history · **one** `logs/decisions.md` entry, only if durable behaviour changed **and** the operator accepted the status (§ 11.5) · nothing when the outcome is no action.

### 12.3 Medium and Heavy — one record per capability

**Path:** `projects/{owner-project}/development/{slug}.md` (name provisional pending `/placement` — § 20.1).
**Slug:** lowercase kebab-case from the outcome, ≤50 characters.
**Created by:** Frame, as soon as the lane is Medium or Heavy.
**Template:** `ai-resources/templates/capability-record.md`, following `templates/mission-contract.md` (F33).

### 12.4 Record schema

```markdown
---
capability: {slug}
name: {human-readable name}
lane: lightweight | medium | heavy
phase: frame | shape | build | prove | land
status: {one of the nine — see § 12.5}
reopen_trigger: {required when status is paused; a date, a quarter or a named event}
owner_project: {project-name}
opened: YYYY-MM-DD
updated: YYYY-MM-DD
---

# {Name}

## Operating outcome
## Verified need
### Confirmed facts (each with a path)
### Reasonable inferences (each with its basis)
### Unknowns (each with what would close it)
## Lane
Dated, append-only: date · lane · trigger · escalation or de-escalation.
## Ownership and seams
Owner (with the cited clause) · dependencies (never co-owners) · external systems ·
the official record for each data class.
## Public interface
Input · Output · Owning capability · External dependencies · Observable failure states ·
Side effects · How behaviour is tested.
## Approved scope and exclusions
## Implementation package
Eleven fields (§ 8 step 12).
## Vertical slices
- [ ] S1 — {complete behaviour}
## Verification evidence
| Claim | Evidence type | Result | Where |   — each observed · unassessed · blocked
## Independent review
Round · date · what was reviewed · findings · disposition of each. Briefs are not stored
here (§ 16.4); this section is what makes one regenerable.
## Decisions
### D1 — YYYY-MM-DD — {title}
**Status:** active | superseded by D{n} (YYYY-MM-DD)
**Decision.** … **Rationale.** … **Alternatives.** …
## Current phase and next action
## Real-use result
## Lifecycle status
{status} — decided YYYY-MM-DD by {operator|Claude}. Retirement condition: {…}.
## Pointers
Plans, specs, review reports, risk-check reports — by path, never copied.
```

### 12.5 The canonical status set (Codex B2)

**Defined once here. Every consumer references this section — resume, discovery, reporting, listing.** v1's defect was that the record permitted nine statuses while discovery searched for one, so `continue-trial`, `revise` and `paused` records became invisible.

| Status | Class | Meaning |
|---|---|---|
| `in-development` | **ACTIVE** | Work under way |
| `continue-trial` | **ACTIVE** | More evidence required before adoption |
| `revise` | **ACTIVE** | Useful, needs a bounded correction |
| `paused` | **ACTIVE** | No immediate reason to continue. **Requires `reopen_trigger:`** (D12) |
| `adopted` | TERMINAL | Part of normal operations |
| `keep-local` | TERMINAL | Useful in one project; not shared infrastructure |
| `closed` | TERMINAL | Purpose achieved |
| `retired` | TERMINAL | No longer justifies its burden; machinery removed |
| `rejected` | TERMINAL | Should not exist, or routed elsewhere |

**ACTIVE-STATUS-SET** = `in-development` · `continue-trial` · `revise` · `paused`.

Rules:
- Discovery, resume and listing match the **whole** set, never a single status.
- `paused` without a `reopen_trigger:` is **malformed** — reported, not auto-repaired (§ 15.4). A park with no real trigger never drains; this is the same discipline `/resolve-improvement-log` enforces on `Review-cycle:` (`leverage-idea.md:165`).
- Reaching a terminal status is the **only** way to leave the active set. Records are never moved or deleted to close them.

### 12.6 Record versus mission versus decisions log

| Artifact | Answers | Frozen? | Written by |
|---|---|---|---|
| `development/{slug}.md` | *What is this capability, where does it stand, what next?* | No — living | `/develop-capability` |
| `logs/missions/{id}.md` | *What multi-session goal does this session serve; is it drifting?* | Goal/scope/validation frozen (F17) | `/mission` only |
| `logs/decisions.md` | *What did we decide, and why, across the project?* | Append-only | any session |

Integration between the first two is excluded from v1 (OQ-3).

### 12.7 No registry

No index, no register, no status file. Discovery is a glob over `development/*.md` frontmatter filtered by the active-status set. A capability leaves the active set by reaching a terminal status. More than roughly a dozen records in one project is a signal the project should split — § 24 picks it up.

### 12.8 Confidential data and generated artifacts (Codex B1, I7)

**The correction.** v1 said trial material belongs in "the session scratchpad, outside the repo." That is false in this workspace: `/wrap-session` writes continuity scratchpads to `logs/scratchpads/` **inside** the repository (F37), gitignored but present in the tree, and a gitignored path is one `git add -f` or one `.gitignore` edit from exposure.

**The rule.** Confidential material never enters the repository, in any directory, gitignored or not. It stays in the source system, in an external tool, or in an **explicitly created OS temporary directory outside the repository**:

```bash
WORKDIR=$(mktemp -d "${TMPDIR:-/tmp}/axcion-capability-XXXXXX")
```

The command states `WORKDIR` in chat so the operator can find and clear it.

| Rule | Applies |
|---|---|
| Confidential material stays in the source system, an external tool, or `WORKDIR` — **never any path inside the repo** | all |
| Generated review briefs are written to `WORKDIR`, not to the repository (§ 16.4) | Heavy |
| Use the minimum necessary record | Medium, Heavy |
| Prefer anonymised or synthetic data when it tests the same behaviour | Medium, Heavy |
| Name the authoritative source for every data class | Medium, Heavy |
| Never copy raw buyer, CRM, email or relationship data into any committed artifact | all |
| Durable records carry decisions, schemas, evidence summaries and redacted or synthetic examples only | Medium, Heavy |
| Name the system that remains the official record | Heavy |
| State what may and may not be sent to which external model or tool | Heavy |
| Dispose of `WORKDIR` at session end, or tell the operator its path so they can | Medium, Heavy |

**One rule, two problems.** The same `WORKDIR` mechanism resolves both the confidentiality defect (B1) and Codex's finding that generated review briefs should not live in the authoritative-record directory (I7).

---

## 13. Command–skill architecture

### 13.1 Split (operator-locked, Q11)

**`ai-resources/.claude/commands/develop-capability.md`** — 150–220 lines, `model: opus`.
Owns: invocation and arguments · project and state discovery · resume detection · lane routing and announcement · phase orchestration · operator gates · handoff execution and resumption · record read/write mechanics · `WORKDIR` creation and disposal · completion reporting · failure behaviour.

**`ai-resources/skills/capability-development/SKILL.md`** — `model: opus`, `effort: high`.
Owns: the definition of *operating capability* · the five-phase methodology · lane-by-lane requirements and completion conditions · the intervention ladder · trial design and its stop condition · the ownership and seam method (§ 5.3, absence-is-not-evidence, dependency-is-not-a-consumer) · slice standards · the evidence-to-claim table · lifecycle-decision standards · data-handling method · failure behaviour · worked examples.

### 13.2 Why a skill

1. **Size.** A self-contained command lands at 400–500 lines — the class that made `/new-project` (894 lines) hard to maintain. The 150–220 budget is only reachable with a skill.
2. **Read-when-needed.** The lane is decided before lane-specific methodology is needed.
3. **Established pattern.** `/scope-project` does exactly this (`scope-project.md:11`): *"These own the what; this command owns the orchestration."*
4. **Durable vs. perishable.** Principle 8 asks that durable material be separable from model-steering scaffolding. The skill holds the method; the command holds the orchestration, which is where scaffolding accumulates and can later be thinned.

### 13.3 One command

The skill carries `disable-model-invocation: true` (the protection `skills/grill-me/SKILL.md:10` uses), so it cannot be auto-triggered and is reachable only by the command. Exactly one operator-facing entry point.

### 13.4 No agent

Q8 forbids a reviewer agent. Beyond that, a fourth reviewer would overlap `qc-reviewer`, `risk-check-reviewer` and `system-owner`, and would be a new detector needing its own closer under OP-12. Heavy's genuine independence comes from Codex — a different model.

### 13.5 Model tiering

Both files declare an explicit tier and inherit nothing (F34). Command `model: opus`; skill `model: opus`, `effort: high`. No `model` field in any settings file; no project `CLAUDE.md` Model Selection section (F35).

---

## 14. Handoff contracts

Each states: **trigger · out · back · next · must not.**

### 14.1 Really a new project

- **Trigger.** § 5.3 finds no legitimate owner, or the work is a new domain or enduring programme.
- **Out.** Frame output — outcome, verified need, facts/inferences/unknowns, the owner criteria and which failed, the ladder rung — to `/scope-project` (complex) or `/new-project` Step 0 (simple, or when an owner may yet be found). Frame output is not fuzzy, so it enters `/scope-project` at Stage 1.
- **Back.** Nothing; terminal exit.
- **Next.** Close any record `status: rejected`, naming the routing target and the failing criterion. Report the route in one line.
- **Must not.** Create the project. Write into `projects/project-planning/`. Leave the capability "open pending a project."

### 14.2 Formal project planning

- **Trigger.** Heavy, **after G1**, and the capability warrants a control pack or specification.
- **Out.** The approved package plus the record path, to `/scope-project` or the `/plan-draft` → `/plan-refine` → `/plan-evaluate` chain. Artifacts land in `projects/project-planning/output/{name}/` (`scope-project.md:17`); that workspace must be mounted or the handoff stops before any write there.
- **Back.** Paths to produced artifacts.
- **Next.** Record under `## Pointers`. **Never copy them in.** Resume Shape where interrupted.
- **Must not.** Re-derive the plan in-command. Let planning output replace the record as source of truth — the record still owns phase, next action and status.

### 14.3 AI-resource sub-need — upstream mode (Codex B4)

- **Trigger.** A slice needs an AI artifact that does not exist — including a project-local one (M4).
- **Out.** A brief in `/develop-ai-resource`'s existing qualified shape (`develop-ai-resource.md:80-87`) extended by three fields:

```markdown
**Mechanism:** {the rung and why not a lower one}
**Evidence:** {cited, or "speculative"}
**Capability:** {slug} — owner {project} — record: {path}
**Settled upstream:** operating outcome, need validation, ownership and seam, and the
business-adoption decision. Do not reopen these. Qualify the ARTIFACT only, and return
the artifact disposition to /develop-capability rather than taking it to the operator.
**Artifact scope:** {exactly what to author, and what not to}
```

- **Back.** The **artifact** disposition — is it well made, does it do what it claims, what was tested and observed — plus the artifact path. **Not** a Ship/Revise/Defer/Delete operator decision.
- **Next.** Claude adjudicates the artifact disposition and records it under `## Pointers` and `## Verification evidence`, then resumes the slice. If the artifact is judged not fit for purpose, that is a **material scope change**: record it as a decision and re-test the lane.
- **Must not.** Call `/create-skill`, `/improve-skill` or `/migrate-skill` directly (F5). Author a skill in-command. Let `/develop-ai-resource` reopen the operating need, re-run capability qualification, **or take an adoption decision to the operator** — that is G3's, and only G3's.

**Why the uncounted gate is now closed.** `/develop-ai-resource` Step 4 requires an operator disposition and states "Adoption and integration wait for that choice" (F5b). v1's clause left that intact, so every artifact handoff smuggled in an extra operator stop that § 11's table did not count. Upstream mode reassigns it explicitly: **artifact quality → Claude; business adoption → G3.** § 18.3 gives the exact wording, which amends both Step 1 and Step 4. AT-12 and AT-14 test it.

### 14.4 Project-local implementation

- **Trigger.** The default; built inside the owning project.
- **Must not.** Write into another project's tree, even when the capability depends on it. § 14.9 is the compliant path. (`axcion-communication-system/CLAUDE.md:27` is a live example of a project that forbids exactly this.)

### 14.5 Shared capability

- **Trigger.** H6 fired: something used beyond the owning project.
- **Out.** For a shared AI resource: § 14.3, placement per `docs/repo-architecture.md:183-198`. For a *later* promotion of something built project-local: `/graduate-resource`, which requires confirmation from every existing canonical consumer (F24).
- **Must not.** Generalise on one confirmed consumer (AP-7/DR-7). Graduate in-command.

### 14.6 Independent review

| Lane | Mechanism | When |
|---|---|---|
| Lightweight | none, unless a mandatory `/risk-check` class fired (lane unchanged) | Prove |
| Medium | `/qc-pass` on the result; `/risk-check` if a class fired | Prove |
| Heavy | Codex brief #1 (package) and #2 (result); `/risk-check` at both gates; `/qc-pass` where a specific artifact warrants it | riding on G1 and G2 |

- **Out.** A self-contained brief (§ 16.4) written to **`WORKDIR`** — never the repository (§ 12.8, Codex I7) — plus chat instructions for running it.
- **Back.** Findings, pasted by the operator.
- **Next.** Verify each against the repository, then disposition: accept and fix · accept and defer with a concrete trigger · reject with cited evidence. Record every disposition in the record's `## Independent review` section, which is what makes a lost brief regenerable.
- **Must not.** Create a reviewer agent. Imitate Codex inside Claude. Treat findings as instructions. Put confidential material in a brief.

### 14.7 Real-use trial

- **Trigger.** M1 (Medium) or mandatory (Heavy — synthetic before G1, real data only after).
- **Out.** One real case, by hand or with temporary tooling, working in `WORKDIR`. Real data only when the claim genuinely depends on real operating context.
- **Back.** An observed result, including a negative one.
- **Next.** Record it. **Stop condition: a trial that does not produce a useful result stops the build.** Re-enter the ladder; no-build remains available.
- **Must not.** Let trial material reach any path inside the repository. Treat a trial that "sort of worked" as validation.

### 14.8 Adoption, closure, retirement

- **Trigger.** Phase 5, after observed real use.
- **Out.** To the operator at G3 (or as a recommendation requiring acceptance, at Lightweight — § 11.5).
- **Back.** One of the nine statuses (§ 12.5). `paused` requires a reopening trigger.
- **Next.** Write the status; append one `logs/decisions.md` entry; for Heavy restate the retirement condition and rollback method. For **retire**, remove the machinery and record what was removed — retirement leaving machinery in place is not retirement.
- **Must not.** Mark adopted without observed real use and operator acceptance. Leave a record in an active status after work has stopped without converting it to `paused` **with** a reopening trigger.

### 14.9 Sibling-project change request (Codex B5 — new)

- **Trigger.** H3 fired in the form "a second project must change" — a sibling must alter its own artifacts for this capability to work.
- **The problem this closes.** § 14.4 forbids writing into another project's tree, and v1 offered no alternative, so an H3 capability could be classified Heavy and then have nowhere to land.
- **Out.** A **change request** — bounded, self-contained, executable by a session that has never seen this capability:

```markdown
# Change Request — {sibling project} — for capability {slug}

**Requesting capability:** {slug}, owned by {owner project}, record: {path}
**Why this change is needed:** {the operating outcome that requires it, one paragraph}
**Authority:** {the clause in the sibling's own authority document that permits this
change, cited — or an explicit statement that no such clause exists and the sibling's
operator must decide}
**Exact change requested:** {files, and what changes in each}
**What must NOT change:** {the sibling's boundaries this request does not touch}
**Evidence to return:** {what the executing session should send back — a diff, a commit
SHA, a test result}
**If declined:** {what the requesting capability does instead — this must be answerable,
or the capability is not viable}
```

Written to `WORKDIR` and surfaced in chat; recorded in the requesting record under `## Pointers`.

- **Back.** The evidence named in the request — a commit SHA, a diff, a test result — carried back by the operator.
- **Next.** Record it under `## Verification evidence`. Resume the slice that depended on it.
- **Must not.** Open the sibling session itself, write into the sibling tree, or treat the sibling as a co-owner. **One capability, one owner** — the sibling makes a change; it does not acquire the capability. If the sibling declines, the `If declined` branch executes; if that branch is unanswerable, the capability is not viable and Frame's owner selection was wrong.

---

## 15. Failure, pause and resume behaviour

### 15.1 Resume

**On invocation with no argument, or an argument matching an existing record slug:**

1. Glob `projects/{cwd-project}/development/*.md`; read frontmatter only.
2. Filter to the **ACTIVE-STATUS-SET** (§ 12.5) — `in-development`, `continue-trial`, `revise`, `paused`. **Never a single status** (Codex B2).
3. **Zero** → treat any argument as a new need; with no argument, ask once for the need and wait.
4. **Exactly one** → resume it: `Resuming {name} — lane {lane}, phase {phase}, status {status}. Next: {next action}.` Read the record, continue at the recorded phase. If the status is `paused`, state the reopening trigger and confirm it has been met before continuing.
5. **More than one** → list them (name, lane, phase, status, next action) and ask which, in one prompt. Never guess.

Resume never re-runs completed phases.

### 15.2 What makes resume work

`## Current phase and next action` and the frontmatter `phase:` / `updated:` are written **inside each slice cycle, before its commit** (§ 8 step 15), not at session end. A session dying mid-Build leaves a committed record pointing at the last completed slice.

### 15.3 Session boundaries

At the end of any session with an active Medium or Heavy capability, the record is current before wrap, and chat states capability, lane, phase and next action. No separate handoff document — `/handoff` owns that, and the record already carries the state. `/wrap-session`'s continuity scratchpad (F37) and `/prime` Step 1b's detection of it (F16) provide the cross-session bridge in v1, in place of the deferred `/prime` scanner.

Per workspace `CLAUDE.md` § Context constraint deferral: when context is constrained, update the record, flag the deferral, stop. Do not rush a phase to closure.

### 15.4 Failure behaviour

| Failure | Response |
|---|---|
| No project identifiable from the working directory | Ask once which project owns this, listing plausible candidates. Do not guess; do not default to the workspace root. |
| The named owner project does not exist | Stop. Report. Do not create it. |
| `development/` does not exist | Create it only when the first Medium/Heavy record is written. Never pre-create an empty directory. |
| Record frontmatter malformed | Report the specific malformation and path. Do **not** auto-repair — a silently corrected status is worse than a visible error. |
| `status: paused` with no `reopen_trigger:` | Malformed (§ 12.5). Report it; ask the operator for the trigger. Do not invent one. |
| Two records claim the same capability | Stop. Report both paths. The operator decides. Never merge automatically. |
| `/develop-ai-resource` returns an artifact judged unfit | Material scope change. Record it, re-test the lane, re-plan without that artifact or pause for the operator. |
| A trial produces no useful result | Stop the build. Record the negative result. Re-enter the ladder. This is a success of the method. |
| A sibling project declines a change request | Execute the `If declined` branch (§ 14.9). If unanswerable, the capability is not viable — report and stop. |
| Codex unavailable or declined (Heavy) | Do **not** substitute a Claude subagent and call it independent review. Record independent review as **unassessed**, and let the operator decide at G1/G2 with the gap explicit. |
| `qc-reviewer` agent type fails to resolve | Use the `qc-pass.md:24` fallback; label the verdict `(fallback: general-purpose, opus re-asserted)`. |
| `/risk-check` returns `RECONSIDER` | Exceptional pause. Surface the report path and dimension findings. Do not proceed on Claude's own judgment. |
| Context exhausted mid-phase | Update the record, state position, defer. Never compress a phase to fit. |
| Operator interrupts to correct the lane | Record as a decision with `Decided by: operator`. Continue in the corrected lane. |
| A commit was made and a defect found afterwards | Report as paused; do not create a corrective commit in the same run. The remedy is a more careful Prove phase (`new-project.md:139`'s discipline). |

### 15.5 Recoverability posture

Every slice is verified, recorded and committed as one unit. No confidential material enters the repository. Nothing is deleted to tidy up. A failure discovered three sessions later costs at most one slice of rework and never leaves the state unreadable — Principle 9 as behaviour, not intention.

---

## 16. Review and verification model

### 16.1 Governing rule

**Evidence must match the claim type.** Runtime → execution. File-scope → the diff. Compatibility → a representative test. Factual → the source. Usage → checking every relevant location. **Counts → mechanical derivation at write time, stating the command** (D11). A control that cannot run is **unassessed**, never passed. A file existing, a status field reading complete, or documentation asserting a control is active evidences none of it.

### 16.2 Depth by lane

| | Lightweight | Medium | Heavy |
|---|---|---|---|
| Self-review | inline, both questions | both, recorded | both, recorded |
| Fresh-context Claude | — | `/qc-pass` on the result | `/qc-pass` where an artifact warrants it |
| Structural risk | if a class fired (lane unchanged) | if a class fired | `/risk-check`, both gates |
| Independent model | — | — | **Codex ×2** |
| Behavioural test | against stated behaviour | per slice | per slice |
| Integration test | — | if a seam exists | required |
| Failure test | — | if failure states are stated | required |
| Recovery test | — | — | required |

**Two Codex rounds, but only on a real Heavy trigger** (OQ-6). A capability reaching Heavy by escalation gets both rounds — the triggers are real. Nothing gets a Codex round because of a lane label alone; if every Heavy trigger is disproven, § 6.7 de-escalates and the rounds fall away with it.

### 16.3 The two self-review questions

Kept separate in every lane:

1. **Is it well made?** — clear purpose and scope; small understandable interface; one owner per responsibility; no duplicated behaviour; proportionate architecture; tests coupled to outcomes not internals; every control demonstrated in its real invocation path; anything removable removed; no unrelated scope entered; work recoverable.
2. **Does it belong in the system?** — the capability is still justified; the mechanism is still the smallest reliable one; it duplicates and conflicts with nothing; it references rather than copies authoritative context; consumers and handoffs are clear; maintenance cost is proportionate; it can be removed cleanly.

Merging them is the failure this separation prevents.

### 16.4 Codex review brief (Heavy)

**Written to `WORKDIR`, never the repository** (§ 12.8; Codex B1 + I7). The brief is **generated, not durable** — the record's `## Independent review` section holds the round, date, subject, findings and dispositions, from which a brief is regenerable.

Self-contained. Sections:

1. What this capability is — the operating outcome.
2. Why it is being built — verified need, with evidence and its honest classification.
3. Facts, inferences, unknowns — separated; each fact carrying a path; **each count stating its derivation command**.
4. Ownership and seams — owner, the cited clause, dependencies, external systems, the official record per data class.
5. Scope and exclusions.
6. What is being reviewed — #1 the package before implementation; #2 the implemented result before release.
7. Evidence table — every claim observed / unassessed / blocked, with where.
8. **The claims most worth attacking**, named specifically. *"Name the specific conclusion you most want attacked; a general instruction does not bite"* (`axcion-communication-system/CLAUDE.md:42`).
9. **The inference question, as its own numbered item** — *"For each load-bearing conclusion: does it follow from the cited text, or does the citation merely sit near it?"* Required. It is the check that first caught a defect pre-commit in that project after two citation-focused QC passes missed the same class twice (`:42-44`).
10. Explicit non-goals — do not redesign; do not create a parallel system; findings are claims to be tested.

**Confidentiality:** decisions, schemas, evidence summaries, redacted or synthetic examples only.

### 16.5 Adjudicating findings

Findings are claims to be tested. Verify against the repository, then disposition explicitly: **accept and fix** (correct and re-verify) · **accept and defer** (record with a concrete reopening trigger) · **reject** (state the refuting evidence). Only business-risk or maintenance-burden disagreements reach the operator.

### 16.6 Deliberately not built

No `capability-reviewer` agent. No new verdict vocabulary. No scoring rubric. No review log. No metrics.

---

## 17. Representative-case walkthroughs

### 17.1 Case 1 — Lightweight, narrow, project-local, known behaviour

*"`axcion-sector-intelligence` reports should carry a standard 'how Axcíon should use this' closing section."*

- **Lane: Lightweight.** No Heavy trigger — one project, no external system, no confidential data, revert-reversible, one consumer. No Medium trigger — the workflow is demonstrated, one behaviour, ownership unambiguous, no new AI resource, verification is reading the output.
- **Artifacts:** the edited standard in `reference/report-architecture-template.md`; one `logs/decisions.md` entry **written after acceptance**. No capability record.
- **Review:** self-review only.
- **Handoffs:** none.
- **Evidence:** the diff; one section rendered and read from disk — **before the commit**.
- **Decision:** Claude demonstrates the result and **recommends adopt**; the operator accepts; only then is the decisions entry written (Codex I1). Planned stops: **0**. Acceptance: required.

### 17.2 Case 2 — EmailOS: one buyer record + one objective + current guidance → one reviewable draft

- **Lane: Heavy, on H1 and H2** (Codex I5). H1 — the buyer record and guidance live outside whichever project owns the workflow, and Gmail is the official record. H2 — a real buyer record is real relationship data. **H4 does not fire on the draft itself:** producing a draft for human review is reversible; *sending* is the irreversible act, and sending is not in this capability's scope. H5 likely fires — the language layer is claimed by `axcion-communication-system` (F28) while the workflow layer is claimed by nobody.
- **Frame finds an ownership problem, which is the point.** Criterion 1: who owns "a buyer email gets prepared"? The comms system owns what the firm sounds like and disclaims the situational layer (`axcion-communication-system/CLAUDE.md:27`). Criterion 2: decisions about whom to contact belong to Contacting Strategy, which is not a project (F27). Criteria 3–4 do not rescue it. **Expected outcome: § 14.1 new-project handoff** (I3).
- **The other branch is specified too.** If a project legitimately owns it — say Contacting Strategy is stood up first and claims the workflow — Heavy develops in place: seam against comms (language), CRM (relationship state) and Gmail (official record); synthetic trial before G1, real-record trial after; slices S1 draft-from-record, S2 guidance applied, S3 operator review path.
- **Artifacts:** `development/buyer-email-preparation.md`; two Codex briefs in `WORKDIR`; a § 14.3 upstream brief for the drafting skill.
- **Review:** Codex ×2 + `/risk-check` (a new skill fires the class) + `/qc-pass` on the skill.
- **Handoffs:** § 14.1 or § 14.2, § 14.3, § 14.6, § 14.7.
- **Evidence:** one real draft from one real record, read by the operator, compared against the guidance — produced in `WORKDIR`, never committed.
- **Decision: continue trial.** One draft is not adoption. Stops: **3** (or **0** on the route-out branch).

### 17.3 Case 3 — Prohibited contact or missing authority must stop, not draft

- **Lane: Heavy.** Same triggers as 17.2. **It is a slice of that capability, not a separate one** — treating it as separate is itself the error.
- **Why it matters:** it proves the seam. A capability that drafts when it should refuse has no observable failure state, and § 12.4's `Observable failure states` field is where that is caught.
- **Slice:** S2 — *given a contact marked prohibited, or a record with no contact authority, no draft is produced and the reason is stated.* Reproduce-or-fail first: construct the prohibited case and confirm current behaviour wrongly drafts.
- **Review:** a **failure test**, required at Heavy. `axcion-linkedin-os/CLAUDE.md:5-12` (hard laws enforced structurally in settings) and `:23-25` (human confirmation before any real firm, person, call or buyer criterion) are the reference.
- **Evidence:** the control demonstrated **in its real invocation path**. A rule in a file evidences nothing.
- **Decision:** gates the parent capability's G2 — release is not approved while the refusal path is unassessed.

### 17.4 Case 4 — CRM and Gmail integration, shared relationship state

- **Lane: Heavy.** H1 two external systems; H2 confidential data at rest and in flight; H3 CRM becomes a consumer of writes; H4 a write to shared relationship state is not a revert; H6 shared-state automation (`docs/audit-discipline.md:65`).
- **Frame additions:** consumer inventory (CRM, Gmail, the comms standard, the operator); a data-flow statement naming what may reach an external model; a reversibility statement per write path.
- **The seam is the deliverable, not the code.** Which system is authoritative for relationship state; who may write; what happens on conflict; what a human must approve. `axcion-linkedin-os/CLAUDE.md:14-16` is the pattern.
- **Handoffs:** likely § 14.2 formal planning after G1; § 14.9 if CRM-side artifacts must change.
- **Review:** Codex ×2, `/risk-check` ×2, integration + failure + recovery tests. The recovery test must demonstrate the stated undo actually works.
- **Evidence:** a real write executed against a test record and rolled back, observed. Not "the code path exists."
- **Decision: continue trial**, restricted consumer set. Stops: **3**.

### 17.5 Case 5 — Contacting Strategy: why, whom and when, without owning the language

- **Lane: Heavy, on H5** (Codex I5). It defines decisions currently unowned, adjacent to territory `axcion-communication-system` holds, and it will contradict or claim part of that authority surface. **H3 does not fire on a speculative EmailOS consumer** — EmailOS does not exist (F26), and § 6.2's H3 test excludes a consumer that does not yet exist. Counting it would be the AP-7/DR-7 speculative-abstraction pattern. If Contacting Strategy has no second *existing* consumer, H3 stays unfired and H5 alone carries the lane.
- **The value is the seam.** Contacting Strategy owns *why contact should occur, whom, and when.* It must not own *what the message says* — that is the comms system's register-and-language layer (`axcion-communication-system/CLAUDE.md:27`, `:31-34`). Recorded explicitly with the citation.
- **The implementation is mostly documents** — decision rules, a prioritisation method, a definition of contact-worthiness. Possibly no code and no AI resource at all. The clearest illustration of Q13's point that a capability is not software.
- **Review:** Codex on the package; brief #2 may be light if nothing executable was built — **say so explicitly rather than skipping it silently**. `/risk-check` only if a class fires (likely not). `/qc-pass` on the strategy document.
- **Evidence:** the strategy applied to one real contact decision, and the decision compared against what the operator would have done unaided.
- **Decision: adopt** if the real decision holds up; **keep local** if it serves only one project.

### 17.6 Case 6 — No-build or manual outcome

*"We should have a system that reminds me which sector reports are overdue."*

- **Lane: Lightweight** at Frame — but the lane never matters, because the ladder stops early.
- **What happens:** Frame finds `axcion-sector-intelligence/CLAUDE.md` already names the active unit (`**Current Section:** precision-components`) and `/prime` already surfaces project position (F16). Ladder rungs 1–2: served by an existing capability plus an operating habit.
- **Artifacts:** **none.** No record, no decisions entry — nothing durable was decided.
- **Decision:** reported in chat as *no build — existing capability covers it*, with paths. A success. Stops: **0**.

### 17.7 Case 7 — Belongs to `/develop-ai-resource`

*"Build a skill that formats research citations consistently."*

- **Routing, not lane.** The request names an artifact (§ 5.2). One line: *"This is an AI-artifact decision — `/develop-ai-resource` owns it."*
- **The subtlety:** if the underlying need is *"citations in Axcíon research must be consistent and correct"* — an outcome — then `/develop-capability` is right and the skill is one component. The test: could a non-skill answer serve the need (a standard, a checklist, a review step)? If yes, it is an outcome. If the operator wants that specific artifact and nothing else, route out.
- **Artifacts:** none. Stops: **0**.

### 17.8 Case 8 — Routed to the new-project lifecycle

*"Axcíon needs a buy-side outreach programme covering targeting, sequencing, messaging and measurement."*

- **Frame concludes route-out.** Criterion 1: no project owns "buy-side outreach as a programme." Criterion 4: replace any dependency and a programme with its own deliverables still stands — the definition of a project.
- **Handoff:** § 14.1 to `/scope-project` (multiple workstreams, contested document architecture, real MVP-boundary risk — `scope-project.md:36`'s trigger).
- **Artifacts:** none in the owning project; any record closes `status: rejected` with the routing note.
- **Decision:** reported route. Stops: **0** — routing is a statement, not a question.

### 17.9 Case 9 — Medium that escalates

*"Add a standard pre-send check to LinkedIn drafts."*

- **Starts Medium.** M2 three behaviours; M5 verification needs a real draft. No Heavy trigger apparent.
- **Escalates during Shape.** The seam exercise finds the check must read `strategy/positioning.md`, which the project's authority order names as governing phrasing (`axcion-linkedin-os/CLAUDE.md:14-16`), and that the natural implementation is a project-local command writing a gating frontmatter field, mirroring `/linkedin-qc` (`:9-12`).
- **What fires, and what does not** (Codex I5). The project-local command fires **M4**, and separately triggers `/risk-check` per F8 — but it does **not** fire H6, which is narrowed to genuinely shared infrastructure (§ 6.2). What actually escalates this to Heavy is **H3**: the publishing lifecycle becomes a consumer of the gating field, and `approved/` entry depends on it. That is a second, *existing* consumer — not a speculative one.
- **What escalation does:** states the trigger; upgrades the record with a dated `## Lane` entry; because escalation happens **during Shape**, it completes a bounded Shape and then takes **G1** (§ 6.6). Nothing built so far is discarded.
- **Decision: revise then adopt** is the likely path — escalation usually reveals the first design was too small.
- **Stops: 3**, all after escalation. Before it: 0.

### 17.10 Case 10 — Stays project-local after successful use

*"`axcion-sector-intelligence` gets a standard evidence-calibration checklist before each report ships."*

- **Lane: Medium.** M1 undemonstrated; M2 three behaviours; M5 verification needs a real report. No Heavy trigger.
- **The interesting part is Phase 5.** The checklist works. The obvious next thought — *"other research projects should have this"* — **is the trap.** `docs/ai-resource-creation.md:21` requires a **second confirmed consumer**; one consumer plus a plausible second is the AP-7/DR-7 pattern, and `/graduate-resource` exists to gate it.
- **Decision: keep local**, with the reopening trigger recorded: *"a second research project independently asks for the same check."* Not "revisit later."
- **Review:** `/qc-pass` on the checklist. No Codex.
- **Stops: 1.**

### 17.11 What the cases collectively test

| Behaviour | Cases |
|---|---|
| Lightweight stays light, and acceptance is still required | 1, 6 |
| Heavy triggers fire on the right grounds, not the wrong ones | 2, 4, 5, 9 |
| Ownership selection with evidence, and route-out when it fails | 2, 5, 8 |
| Non-software capability handled without assuming code | 5 |
| No-build and reuse as successful outcomes | 6 |
| Boundary against `/develop-ai-resource`, both directions | 7 |
| Boundary against the new-project lifecycle | 8 |
| Escalation during Shape → bounded Shape → G1 | 9 |
| Speculative consumers excluded from H3 | 5, 9 |
| Project-local command ≠ shared infrastructure | 9 |
| Resisting premature generalisation | 10 |
| Failure-state slices, real-invocation-path evidence | 3 |

---

## 18. Exact target files to create or edit

### 18.1 Create

| # | Path | Purpose | Size | Notes |
|---|---|---|---|---|
| C1 | `ai-resources/.claude/commands/develop-capability.md` | The command | 150–220 lines | Frontmatter: `description`, `model: opus`, `argument-hint: "[outcome or observed need — leave blank to resume]"`. Sections: purpose + the outcome-vs-artifact sentence · boundary vs neighbours · input handling and resume (§ 15.1, active-status set) · discovery · lane routing and announcement · five phases as orchestration · operator gates · handoff execution · `WORKDIR` creation and disposal · failure behaviour · reporting. |
| C2 | `ai-resources/skills/capability-development/SKILL.md` | The methodology | 350–500 lines | Frontmatter: `name`, `description`, `model: opus`, `effort: high`, `disable-model-invocation: true`, `allowed-tools`. Sections per § 13.1. |
| C3 | `ai-resources/templates/capability-record.md` | Record template | ~80 lines | Schema § 12.4 with mustache tokens, following `templates/mission-contract.md`. Register in `templates/README.md`. |
| C4 | `ai-resources/plans/2026-07-28-develop-capability-build-plan-v2.md` | This plan | — | Gains a status banner at approval. |

### 18.2 Edit

| # | Path | Change | Size | Risk |
|---|---|---|---|---|
| E1 | `ai-resources/.claude/commands/develop-ai-resource.md` | (a) one bullet in **Boundary vs neighbours** (§ 5.4); (b) **Step 1.0 upstream clause**; (c) **Step 4 upstream-mode clause** (§ 18.3). | ~18 lines added, nothing removed | Low-medium. Additive; owned artifact class untouched. (c) is new in v2 and closes B4. |
| E2 | `{workspace}/CLAUDE.md` | Rename `## AI Resource Creation` → `## Capability and AI-Resource Development`; add two sentences routing outcome vs artifact. | +2 lines net | Cross-cutting CLAUDE.md — a `/risk-check` class (F8); permanent always-loaded cost. |
| E3 | `ai-resources/CLAUDE.md` | One line under `## Skill Creation and Improvement` naming the boundary. | +1 line | Low. |
| E4 | `ai-resources/docs/ai-resource-creation.md` | One sentence in rule #4 naming `/develop-capability` as the sibling lifecycle. | +1 line | Low. |
| E5 | `ai-resources/logs/decisions.md` | The OP-11 entry (§ 4.4, verbatim). | ~45 lines | None — append-only. |
| E6 | `ai-resources/templates/README.md` | Register `capability-record.md`. | +2 lines | None. |

**Removed from v1's change set:** the `/prime` Step 1e edit (OQ-1, Codex I2). See § 23.

### 18.3 E1 — exact text of the upstream-mode clauses

**In Step 1, immediately before 1.1:**

```markdown
**1.0 Upstream-qualified brief.** When the input brief carries both `**Capability:**` and
`**Settled upstream:**`, it arrives from `/develop-capability`, which has already validated
the operating need, established ownership and the seam, and holds the adoption decision.
Read the record named in `**Capability:**` and treat 1.1 and 1.2 as satisfied by it — do not
re-derive the need and do not re-classify its evidence. **Steps 1.3–1.6 still run in full,
scoped to the artifact:** does this artifact already exist, is this rung the smallest
mechanism for *this artifact*, and where does it belong. A brief carrying neither field is an
ordinary direct invocation — ignore this clause and every other upstream-mode clause.
```

**In Step 4, immediately after its first paragraph:**

```markdown
**Upstream mode — the disposition is returned, not taken to the operator.** When Step 1.0
applied, this command does **not** put Ship / Revise / Defer / Delete to the operator. Return
to the calling `/develop-capability` a judgement on the **artifact only**: is it well made,
does it do what it claims, what was tested and what was observed. The calling capability
adjudicates that judgement and resumes its slice. **The business-adoption decision belongs
to the capability lifecycle's own operator gate and is taken there, once, for the capability
as a whole** — putting it here would add an operator stop the capability's gate table does
not count. Everything else in this step is unchanged.
```

### 18.4 E2 — exact workspace `CLAUDE.md` text

```markdown
## Capability and AI-Resource Development

**Operating capabilities** — business, operational or product abilities inside an existing
project — are developed through `/develop-capability`, which owns the operating outcome from
need to adoption or retirement. **AI resources** — skills, commands, agents, prompts, hooks,
scripts, persistent instructions — are qualified and built through `/develop-ai-resource`.
The test is what you want at the end: an outcome, or an artifact. The skill is not the
capability; it is one implementation component.

{existing /develop-ai-resource paragraph, unchanged}
```

### 18.5 Not created

No new agent. No new hook. No `/prime` edit. No new symlink beyond auto-sync's normal behaviour (F13). No registry file. No `development/` directory until a Medium or Heavy capability needs one. No project `CLAUDE.md` edits — this is a workspace-level rule, and a canonical rule is never duplicated into a project file.

---

## 19. Integration points and consumers affected

### 19.1 Invocation path — initiation (workspace `CLAUDE.md`, E2)

Without it, capability requests route to `/develop-ai-resource` by default (I1) — the boundary error the design exists to prevent. Two always-loaded sentences. This is v1's satisfaction of RR-05.

### 19.2 Resumption in v1 — existing mechanisms, scanner deferred

v1 ships **no** `/prime` change (Codex I2, OQ-1). Resumption rests on three mechanisms that already exist:

1. `/wrap-session` writes a continuity scratchpad at every substantive session end (F37), and `/prime` Step 1b detects and offers it (F16). A capability in progress is named there.
2. `/prime` Step 1c reports project position, and the session-notes Next Steps list carries forward.
3. The operator names the capability — `/develop-capability {slug}` — or invokes bare and § 15.1 lists the active records.

**What is genuinely lost:** a capability left mid-flight *without* a wrap does not surface automatically at the next session start. U6 names this as the accepted risk; § 23 names the trigger that reverses the decision. This is a smaller risk than shipping a scanner into the highest-traffic command in the repo before any continuity failure has been observed — and v1's proposed pseudocode was, as Codex found, actually broken (`[ -d … ] || :` does not skip the loop).

### 19.3 Consumers affected

| Consumer | Effect | Severity |
|---|---|---|
| **Every project** (~21 engineered via auto-sync, F13) | Gains `/develop-capability` at next session start. No behaviour change until invoked. | Low — availability, not activation. |
| **`/develop-ai-resource`** | One boundary bullet, one Step-1 clause, one Step-4 clause. Behaviour unchanged for direct invocations (AT-13). | Low-medium. |
| **Workspace `CLAUDE.md`** | +2 lines always-loaded everywhere. | Low-medium — permanent cost, cross-cutting class. |
| **`/prime`** | **Unchanged in v1.** | None. |
| **`/qc-pass`, `/risk-check`, `/implementation-triage`** | New caller; no file change. | None. |
| **`/scope-project`, `/new-project`, `/plan-draft` chain, `/graduate-resource`** | New upstream caller; no file change. | None. |
| **`/wrap-session`** | Encounters a new file class under `development/`; path-agnostic. Its QC-PENDING guard (F38) will correctly block an un-QC'd new command or skill produced by a capability — desirable, and tested by AT-18. | Low. |
| **`/refresh-project-state`** | Enumerates by `Glob projects/*/CLAUDE.md`; unaffected by a new subdirectory. Snapshot agents read project trees, so a record could surface in a snapshot — § 12.8's no-confidential-data-in-repo rule is what keeps that safe. | Low, named. |
| **`/audit-repo`, `/token-audit`, `/lean-repo`** | Will count two new components. Expected; the OP-11 entry is the answer. | None. |
| **Codex** | New workflow: operator carries a brief out of `WORKDIR` and findings back. | Operator-process, not code. |

### 19.4 Not affected

No hook, permission, settings, agent or symlink-topology changes. No project `CLAUDE.md` changes. No `/prime` change.

---

## 20. Implementation sequence in coherent commits

| # | Commit | Contents | Gate before landing |
|---|---|---|---|
| **1** | `new: capability-development skill — operating-capability methodology` | C2 + C3 + E6 | `/qc-pass` on the SKILL.md. Inert until the command reads it. |
| **2** | `new: /develop-capability — operating-capability development lifecycle` | C1 | `/qc-pass` on the command. Reachable via auto-sync but not yet routed to. |
| **3** | `update: /develop-ai-resource — upstream mode for capability-qualified briefs` | E1 | `/qc-pass`. Closes double-qualification **and** the uncounted-gate defect before routing sends real traffic. |
| **4** | `docs: name /develop-capability as the operating-capability lifecycle` | E2 + E3 + E4 | Cross-cutting CLAUDE.md class → covered by the end-time `/risk-check`. Invocation path goes live here. |
| **5** | `decision: OP-11 exception — /develop-capability complexity-budget record` | E5 + C4 status banner | None. Last, so it records what actually shipped. |

**Five commits, not v1's six** — the `/prime` commit is removed.

### 20.1 Gates around the sequence

- **`/qc-pass` on this plan** — before anything else. Codex review is genuinely independent but does not fulfil the workspace's named gate, and Codex itself said so.
- **`/placement`** (Codex I6) — before commit 1. `development/` is a new artifact category in a new location, which is an explicit Placement Discipline trigger. **OQ-2 is provisional on its outcome**; if `/placement` recommends a different location or name, this plan's § 12.3 and § 18 change accordingly and no code has yet been written against the old name.
- **Plan-time `/risk-check`** — once, after operator approval, before commit 1. Payload: two new components, three command/doc edits, one cross-cutting CLAUDE.md edit. Mandatory (F8). **OQ-5's acceptance of the OP-11 exception is conditional on this.**
- **`/blindspot-scan`** — fires post-plan, pre-implementation, because this creates runnable infrastructure. Once; resolve any PAUSE-AND-FIX before commit 1.
- **End-time `/risk-check`** — once, before the final commit, batched across every in-class change.
- **No push** until `/wrap-session`, with the gated confirmation.

### 20.2 Post-landing verification

Run § 21. AT-1 through AT-6 run immediately; AT-7 onward need a real capability and run against the first live use — which, per OQ-4, is a deliberate Lightweight case.

---

## 21. Acceptance-test matrix

| # | Test | Method | Pass condition |
|---|---|---|---|
| AT-1 | Command within budget | `wc -l` | 150 ≤ lines ≤ 220 |
| AT-2 | Explicit model tiers | grep frontmatter | `model: opus` in both; no `model` in any settings file |
| AT-3 | Skill cannot self-invoke | grep frontmatter | `disable-model-invocation: true` |
| AT-4 | Command reaches projects | project session, `ls .claude/commands/develop-capability.md` | symlink present after SessionStart |
| AT-5 | `/prime` untouched | `git diff` over the change set | zero lines of `prime.md` changed |
| AT-6 | Record template renders | render with test values | no `{{` remains; every schema section present |
| AT-7 | **Active-status set is complete** | fixture records at each of `in-development`, `continue-trial`, `revise`, `paused`; invoke bare | all four listed; none missing (Codex B2) |
| AT-8 | `paused` without a trigger is reported | fixture `status: paused`, no `reopen_trigger:` | reported as malformed; not auto-repaired; operator asked |
| AT-9 | Terminal statuses are excluded | fixtures at `adopted`, `keep-local`, `closed`, `retired`, `rejected` | none listed as resumable |
| AT-10 | Lightweight writes zero dedicated files and does not self-adopt | run case 17.1 | no `development/`; recommended status stated; **no decisions entry until acceptance**; zero planned stops |
| AT-11 | Artifact request routes out | run case 17.7 | one-line route; no record; no lane call |
| AT-12 | Upstream brief is not re-qualified | hand `/develop-ai-resource` a brief with both fields | reads the record, skips 1.1–1.2, runs 1.3–1.6 on the artifact |
| AT-13 | Direct invocation unchanged | invoke `/develop-ai-resource` with a plain need | full Step 1 and full Step 4, exactly as before commit 3 |
| AT-14 | **No uncounted gate in the handoff** | complete a Medium capability containing one artifact handoff | exactly **one** operator stop total; `/develop-ai-resource` returns an artifact judgement and takes no Ship/Revise/Defer/Delete decision to the operator (Codex B4) |
| AT-15 | **Heavy announces in Frame, stops at G1** | trigger H1 in Frame | lane + triggers + consequence stated; **work continues into Shape**; the first stop is G1 with a package; no implementation, external handoff or real-data trial happened before it (Codex B3, § 9.2) |
| AT-16 | Heavy stops exactly three times | run case 17.4 to completion | 3 stops; no fourth; a passing verdict produces no stop |
| AT-17 | Escalation behaves by phase | escalate during Shape (case 17.9), then separately during Build | Shape → bounded Shape completes, then G1. Build → immediate stop naming what is committed. Nothing discarded either way. |
| AT-18 | Wrap tolerates the new file class | `/wrap-session` with an active record present | completes; `logs/scripts/check-archive.sh` unaffected; QC-PENDING guard (F38) fires correctly if an un-QC'd command or skill was produced |
| AT-19 | **No confidential material anywhere in the repo** | run a trial with a real record (case 17.2) | `git log -p` over the capability's commits contains no buyer name, address or message body; **and** `find . -path ./.git -prune -o -type f -print` shows no trial artifact anywhere in the tree, gitignored paths included; material is in `WORKDIR` only (Codex B1) |
| AT-20 | Review briefs are not in the repo | complete Heavy through G1 | brief exists in `WORKDIR`; no brief file under `development/` or anywhere in the tree; the record's `## Independent review` section holds round, findings and dispositions (Codex I7) |
| AT-21 | Unassessed is reported as unassessed | force Codex unavailability at G1 | recorded **unassessed**, not passed; operator asked to decide with the gap explicit |
| AT-22 | A negative trial stops the build | force a negative trial | build stops; result recorded; ladder re-entered; no permanent machinery created |
| AT-23 | Rejected capabilities keep their record | run case 17.8 | record exists `status: rejected` with the routing note; not deleted |
| AT-24 | Sibling change request never writes cross-project | trigger H3 "a second project must change" | a change request is produced in `WORKDIR`; **zero writes** to the sibling tree; the `If declined` branch is populated (Codex B5) |
| AT-25 | Verification precedes commit | run case 17.1 and inspect ordering | the artifact was read from disk and compared to the stated behaviour **before** the commit; at Medium, the record update is inside the committed change (Codex I3) |
| AT-26 | A project-local command does not fire H6 | run case 17.9's first classification | M4 fires; H6 does not; `/risk-check` is scheduled at Prove without changing the lane (Codex I4) |

---

## 22. Risks, mitigations and rollback

| # | Risk | Likelihood | Impact | Mitigation | Rollback |
|---|---|---|---|---|---|
| R1 | **Resumption gap.** No `/prime` scanner, so a capability abandoned without a wrap does not surface at the next session start. | Medium | Medium | Three existing mechanisms cover the normal path (§ 19.2). U6 names the risk; § 23 names the reversal trigger. Deliberate, per OQ-1. | Build the scanner then — with working pseudocode, unlike v1's. |
| R2 | **Double qualification with `/develop-ai-resource`**, or a resurfaced uncounted gate. | Medium | High | § 14.3's upstream mode plus § 18.3's two clauses, one of which explicitly reassigns Step 4. AT-12, AT-13, AT-14. | `git revert` commit 3. Consequence: duplicated Step-1 work and one extra stop per handoff. |
| R3 | **The complexity budget was right and this is over-built.** | **Medium — the honest assessment** | Medium | Recorded openly as OP-11 with a rationale that does not overclaim (§ 4.4). § 24 sets reconsideration gates with a dated review point. U5 names the specific signal. | Revert commits 1–4. The OP-11 entry stays as the record that the question was asked. |
| R4 | **Heavy is too heavy to use**, so capabilities get misclassified downward. | Medium | High | Three stops is the operator's own ceiling; Codex rounds ride on them. G1 now lands after Shape, so the first stop buys something. Watch the tell: Heavy triggers firing while Medium is selected. U4 names it untested. | Cut to one Codex round — a skill edit, no structural change. |
| R5 | **A fourth state file per project.** | Medium | Medium | Lightweight adds nothing. Records are per-capability and leave the active set at a terminal status. No registry. | Revert; records are plain markdown. |
| R6 | **Lane misclassification downward** — Heavy work run as Medium, so confidential data or an integration ships without Codex review. | Medium | **High** | Six triggers with concrete tests; ambiguity resolves upward; mandatory re-test at every boundary and on five named discoveries. H1 and H2 are the two that matter most and are the easiest to test. | Escalation is always available and additive (§ 6.6). |
| R7 | **Terminology collision** with `capability/`. | High encountered; low harm | Low | `development/` collides with nothing (F30); both files define *operating capability* and name the other sense. `/placement` confirms before any code is written. | Rename — mechanical; no consumer greps it by name in v1. |
| R8 | **Always-loaded token cost** — 2 lines forever. | Certain | Low | Two sentences. Without them routing is wrong by default (I1). | Revert commit 4. |
| R9 | **Confidential data leaks into the repository.** | Low | **Severe** | § 12.8's rule set built on the corrected premise (F37): nothing confidential enters any repo path, gitignored or not; `WORKDIR` via `mktemp -d`; AT-19 checks both git history **and** the working tree. | History rewrite — expensive, which is why the preventive rules are strict. |
| R10 | **Codex unavailable and Claude substitutes a subagent**, calling it independent review. | Medium | High | Explicitly forbidden; the failure path records **unassessed** and surfaces the gap. AT-21. | None needed — a behaviour rule, tested. |
| R11 | **Record becomes a second source of truth** against project authority documents. | Medium | Medium | The record points to authority documents, never restates them. `/develop-capability` never edits another project's authority document (§ 14.4, § 14.9). | Records are advisory markdown. |
| R12 | **Scope creep into project management.** | Medium | Medium | § 4.3's exclusions; `/pm`, `/mission`, `/open-items`, `/project-next-steps` own their surfaces. § 24 names this drift explicitly. | Narrow the trigger in the command file. |
| R13 | **`WORKDIR` material is lost** when a session ends, taking an in-flight review brief with it. | Medium | Low | Briefs are **generated, not durable** — the record's `## Independent review` section holds round, subject, findings and dispositions, from which a brief is regenerable (§ 16.4). The command states `WORKDIR` in chat so the operator can copy anything they want to keep. | Regenerate the brief from the record. |

### 22.1 Global rollback

Commits 1–5 are independent and revert cleanly in reverse order. Nothing is deleted, no schema is migrated, no existing file is restructured — every edit is additive. A full rollback returns the repository to its pre-change state, with any capability records left in place as readable markdown.

---

## 23. MVP exclusions

| Excluded | Why | What would justify it |
|---|---|---|
| **`/prime` Step 1e capability scanner** | Codex I2 / OQ-1. High blast radius in the repo's highest-traffic command, before any observed continuity failure. v1's pseudocode was additionally broken. | **A Medium or Heavy capability is genuinely lost or forgotten between sessions, once.** That is the trigger — one real instance, not an anticipated one. Build it then, with a directory guard that actually short-circuits and with AT-5-style zero-output verification. |
| A second supporting skill | Q11 forbids it | The skill exceeds ~700 lines with two separable halves |
| Permanent lane agents | Q11 forbids it; lanes are processes | Lane processing needs fresh context per lane, evidenced across ≥3 capabilities |
| A `capability-reviewer` agent | D8; Q8 forbids it | Never |
| A capability registry or index | Recreates the central registry the foundational document warns against | Never; a glob suffices at any plausible scale |
| Cross-project dashboards or metrics | An explicit foundational anti-goal | Never |
| Automated lane classification | RR-05: build no checker for a design principle | Never |
| Automated Codex invocation | Codex runs outside the session | Codex becomes invocable in-session with no new shared state |
| A `/develop-capability` list or status verb | § 15.1's bare invocation lists active records | More than ~5 concurrent capabilities in one project |
| `/mission` integration | OQ-3; adjacent, and coupling two subsystems on speculation | A Heavy capability spans ≥5 sessions and the operator asks for drift measurement |
| Per-capability-type templates | Speculative abstraction on zero instances | Three capabilities of one type completed with a demonstrated common shape |
| Retirement automation | Rare and judgment-heavy in v1 | The first actual retirement proves the manual path error-prone |
| Project `CLAUDE.md` scaffolding for `development/` | Workspace rules never duplicate into project files | Never |

---

## 24. Adoption and retirement conditions for `/develop-capability` itself

Written into the command's closing section, so they are read at invocation rather than buried here.

### 24.1 Adoption condition

**Adopted** only when all five hold:

1. Three capabilities have completed a full lifecycle to a terminal status — **at least one per lane**.
2. At least one ended in a **non-build** outcome. A lifecycle that only ever says yes validates nothing.
3. At least one Heavy capability completed both Codex rounds and the operator judged the process sustainable.
4. At least one capability was **resumed across sessions** from its record, without the operator having to remember it existed unaided.
5. No capability required a repair to the command or skill mid-run.

Until all five hold, its own status is **continue trial** — which is what this plan proposes it carries from day one.

### 24.2 Simplification conditions

Each fires a review, not an automatic change:

- **Lightweight used rarely** (fewer than 1 in 4) → the lane boundary is wrong, or Lightweight work is bypassing the command entirely.
- **Heavy never used** across ten capabilities → over-built; consider two lanes.
- **Heavy avoided while its triggers fire** → too expensive; reduce review rounds before reducing triggers.
- **Record fields consistently empty** → the schema is larger than the work needs; cut them.
- **Condition 4 above repeatedly fails** → the deferred `/prime` scanner is needed; § 23's trigger has fired.
- **A model improvement makes lane routing unnecessary** → the routing scaffolding is exactly the perishable material Principle 8 says to delete rather than adapt. Every significant model release asks: *what can this now remove?*

### 24.3 Retirement conditions

- The three lifecycles merge and one command should own them.
- The redesigned repository defines a single project lifecycle that subsumes capability development.
- Twelve months pass with fewer than three capabilities developed — the need was not real and the OP-11 exception was wrong. **Say so and remove it**; do not keep it because removing it requires a decision.
- Maintenance cost exceeds the value produced, measured by work enabled rather than components owned.

### 24.4 Review point

First formal review **after the third completed capability lifecycle**, or **2027-01-31**, whichever comes first. Verdict: adopt · continue trial · simplify · retire. Recorded in `ai-resources/logs/decisions.md`.

---

## 25. Open questions requiring the operator's decision

Codex answered OQ-1 to OQ-6 (§ 0.4); those are now settled inputs. Three remain.

| # | Question | Default if unanswered | Why it matters |
|---|---|---|---|
| **OQ-7** | **Is the corrected OP-11 rationale (§ 4.4) acceptable as written?** Codex accepted the exception in principle, conditional on this rewrite and a `/risk-check` on the revised design. | **Proceed as written**, subject to the plan-time `/risk-check`. | The entry is what a future audit reads when it flags the component count. It now says plainly that the operator is funding two components on prospective evidence, and does not claim the budget was satisfied. If that understates or overstates your position, this is the moment to change it. |
| **OQ-8** | **If `/placement` recommends a location or name other than `projects/{p}/development/`, do you want to see the recommendation before it is applied, or should I apply it and report?** | **Apply it and report** — per Decision-Point Posture, placement is a technical call. | `/placement` is advisory and non-mutating. Its output could move the record convention; nothing is built against the old name yet, so applying it costs nothing. |
| **OQ-9** | **Accepted resumption gap (R1, U6).** v1 has no automatic surfacing of an abandoned capability. Are you comfortable relying on `/wrap-session` → `/prime` Step 1b, plus naming the capability yourself? | **Yes** — that is what OQ-1's "no scanner" answer implies. | If you expect to abandon Heavy capabilities mid-flight without wrapping, the trigger in § 23 will fire early and the scanner gets built sooner. Worth knowing your expectation now rather than discovering it. |

---

## Appendix A — SOP step → phase mapping

| SOP step | Phase | Lightweight | Medium | Heavy |
|---|---|---|---|---|
| 1 — State the operating outcome | Frame | ✓ | ✓ | ✓ |
| 2 — Claude inspects reality | Frame | ≤4 files | ≤12 | +consumers, +authority |
| 3 — Choose the smallest intervention | Frame | ✓ | +dispositions | ✓ |
| 4 — Test the workflow before building | Shape | escalates | required on M1 | mandatory; synthetic pre-G1 |
| 5 — Language, ownership, seams | Shape | owner only | 7-field seam | +operating seam |
| 6 — Thin implementation package | Shape | 3 lines | 11 fields | durable + approved |
| 7 — Select review depth | Frame/Shape | implicit in lane | implicit in lane | explicit at G1 |
| 8 — Plan vertical slices | Shape | one slice | 2–5 ordered | +failure/recovery |
| 9 — Implement one behaviour at a time | Build | ✓ verify→commit | ✓ verify→record→commit | ✓ |
| 10 — Claude reviews its own implementation | Prove | inline | recorded | recorded |
| 11 — Independent review and adjudication | Prove | none | `/qc-pass` | Codex ×2 |
| 12 — Deliver and operate the result | Land | demonstrate | real use | controlled release |
| 13 — Make the lifecycle decision | Land | recommend → accept | operator (G3) | operator (G3) |

## Appendix B — Foundational principle → design element

| Principle | Where it lives |
|---|---|
| 1 — Business value governs | § 4.4 states the budget miss without dressing it up; § 24 measures by work enabled |
| 2 — Govern capabilities, not component counts | The record describes a capability; artifacts are consequences |
| 3 — Validate the need before building | Frame's ladder and no-build exit; the mandatory trial with a real stop condition |
| 4 — Smallest sufficient and proportionate | Three lanes; zero files at Lightweight; § 11's stop table; § 23's exclusions; the deferred `/prime` scanner |
| 5 — Operational reality overrides documented status | § 16.1; "unassessed, never passed"; controls demonstrated in their real invocation path; **D11's derived counts** |
| 6 — One lifecycle, one source of truth | Five phases; one record per capability; § 12.5's single status set; § 12.7's no-registry rule |
| 7 — Completion includes delivery, use and closure | Phase 5 in every lane; adoption requires observed use **and** operator acceptance; nine statuses, inactivity not among them |
| 8 — Durable knowledge, perishable scaffolding | § 13.2 reason 4; § 24.2's model-release question |
| 9 — Visible and recoverable failure | Verify → record → commit per slice; § 15's failure table; nothing deleted to tidy up; `WORKDIR` keeps confidential failure out of history |

---

**End of plan v2.** No repository change has been made. Next: `/qc-pass` on this document.
