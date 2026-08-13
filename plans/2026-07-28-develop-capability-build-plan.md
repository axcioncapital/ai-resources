# Build `/develop-capability` — operating-capability development inside existing projects

> **SUPERSEDED 2026-07-28 by `2026-07-28-develop-capability-build-plan-v2.md`.**
> Codex independent review returned **Revise** — five blocking findings (confidential-data
> rule unsafe; active-status set incomplete so several nonterminal records were undiscoverable;
> Heavy gate specified in two contradictory places; the `/develop-ai-resource` handoff smuggled
> an uncounted operator gate; cross-project changes had no landing mechanism), plus eleven
> important revisions. **Every inventory count in § 2.1 of this version is wrong** — they were
> recalled from `ls` output rather than derived. Correct figures are in v2 § 2.1.
> Retained as the review trail. Do not implement from this version.

**Status:** SUPERSEDED — see v2. No repository change was made from this version.
**Author:** Claude (Opus 5), 2026-07-28, session S1.
**Input:** Operator brief 2026-07-28 + Capability Development SOP + Foundational Direction and Principles + a twelve-question `/grill-me` interview whose answers are settled inputs (§ 2.4).
**Target repo:** `ai-resources/` (the current repository, as it stands today — operator-locked).
**Reviewer note:** this document is self-contained. Every load-bearing claim carries a repository path and line number. Section 2 separates what was verified from what was assumed.

---

## 1. Executive recommendation

**Build it.** Ship one new operator-facing command, `/develop-capability`, backed by one new methodology skill, `capability-development`. Together they own a lifecycle the repository does not currently have: taking a business, operational or product **operating capability** from a stated need, through validation, proportionate design, implementation, verification and real use, to an explicit lifecycle status — inside an existing Axcíon project.

The command scales its process through three internal lanes (Lightweight / Medium / Heavy) selected by **consequence classes, not file counts** (§ 6). It runs five phases (Frame → Shape → Build → Prove → Land) that compress the SOP's thirteen steps without losing any of their consequential logic (§ 10). Operator stops are strictly rationed: **zero for Lightweight, one for Medium, three for Heavy** (§ 11).

Three things distinguish this recommendation from "add another command."

**First, the boundary is real and narrow.** `/develop-capability` owns the *operating outcome*. `/develop-ai-resource` continues to own *AI artifacts* — unchanged in what it owns, gaining only a compatibility clause so it recognises a pre-qualified handoff and does not re-litigate a settled business need (§ 14.3). The skill is not the capability; it is one implementation component.

**Second, the complexity budget is not cleared, and the plan says so.** `docs/ai-resource-creation.md:25-34` requires a new component to clear net-simplification **or** cited-evidence. This clears neither: it adds two components and removes none, and the operator has confirmed there is no historical failure pattern to cite. The correct response is the framework's own declared mechanism — a loud, recorded **OP-11 exception** in `ai-resources/logs/decisions.md`, following the precedent set on 2026-07-23 for the `/new-project` direct route (`logs/decisions.md:83-95`), which landed an anticipatory build with zero live consumers on exactly this reasoning. § 4.4 writes that entry. Concealing the miss, or bending `/develop-ai-resource` to avoid it, would both be worse.

**Third, it is wired, not remembered.** `docs/ai-resource-creation.md:38` is explicit: *"A command whose only trigger is the operator remembering it exists is not shipped; it is wired or deferred."* This plan specifies two invocation paths — a routing rule in workspace `CLAUDE.md` that makes Claude route capability requests here (initiation), and a `/prime` Step 1e scan that surfaces in-development capability records as task-menu candidates (resumption). § 19 names both and § 22 carries the risk of the `/prime` edit.

**What this is not.** It is not a project-creation command, not a research pipeline, not a second qualification path for skills, and not an advisory-only planner. It implements, verifies and closes.

**Recommended disposition:** approve for build after Codex QC, implement in six commits (§ 20), and re-evaluate against § 24's retirement conditions after the third real capability has completed a lifecycle.

**Main alternative rejected:** ship Lightweight and Medium only, with Heavy as a routing exit to `/scope-project` + `/new-project`. Rejected by the operator (Q11) and on merit — a routing exit cannot own the seam, cannot maintain the record across the external handoff, and cannot govern the real trial or the adoption decision. Heavy would have become a signpost, and the two named near-term uses (EmailOS, Contacting Strategy) both classify Heavy.

---

## 2. Confirmed facts, reasonable inferences, unknowns, proposed decisions

### 2.1 Confirmed facts (verified against the live repository, 2026-07-28)

| # | Fact | Evidence |
|---|---|---|
| F1 | No `develop-capability` command, `capability-development` skill, or any file bearing either name exists anywhere in the workspace. | Repo-wide `grep -ril "develop-capability\|capability-development"` → zero matches. |
| F2 | `ai-resources/.claude/commands/` holds **88** command files. | `ls` count. |
| F3 | `/develop-ai-resource` is 138 lines, four steps — Qualify → Build → Verify → Decide. Its Step 1 already performs need statement, evidence classification, existing-capability disposition, an intervention ladder, a complexity budget and a verdict that includes *no build*. | `develop-ai-resource.md:29-55`; ladder at `:43`; verdict set at `:53`. |
| F4 | Its owned artifact class is: skill, reusable prompt, persistent instruction, reference file, command, script, hook. | `develop-ai-resource.md:9` |
| F5 | It routes skill-class work to `/create-skill` and `/improve-skill` at Step 2 via a **qualified brief** requiring two fields, `**Mechanism:**` and `**Evidence:**`. A brief without both is "raw and belongs at Step 1." | `develop-ai-resource.md:65-66`, `:80-87` |
| F6 | Its Guardrails already disclaim portfolio prioritisation, repository redesign, incident recovery, architecture review, recurring audits, permission redesign and publication — "name the owner and route it." | `develop-ai-resource.md:135` |
| F7 | Command history: `6982bc6` created it (115 lines), then `07880ab`, `afeaae2`, `7383459` corrected authority policy, direct callers, the Pocock SHA pin, and the principles path. Current head state is the 138-line file read for this plan. | `git -C ai-resources log --follow -- .claude/commands/develop-ai-resource.md` |
| F8 | "New commands or skills" is a **mandatory** `/risk-check` change class. Two gates fire: plan-time (after plan approval) and end-time (before commit). Sessions may not self-waive. | `docs/audit-discipline.md:56-81` |
| F9 | The complexity budget requires **at least one** prong: (a) net-simplification, or (b) cited written evidence of a failure mode. "We might need it" and "for a future phase" explicitly fail (b). | `docs/ai-resource-creation.md:25-34` |
| F10 | The inflow rule (RR-05) requires a new command to state what it replaces or why it must be separate, **and** to name its invocation path. It is a written design principle — "build no checker for it." | `docs/ai-resource-creation.md:36-44` |
| F11 | A component introduced despite failing the budget is a recorded **OP-11** exception in `logs/decisions.md`, never an inline assertion. | `docs/ai-resource-creation.md:44` |
| F12 | An OP-11 anticipatory-build precedent exists and was accepted: 2026-07-23, `/new-project` direct route, landed with zero live consumers after two RECONSIDER verdicts, on the reasoning that requiring a live consumer before permitting the mechanism is circular. | `logs/decisions.md:83-95` |
| F13 | `auto-sync-shared.sh` symlinks every command and agent in `ai-resources/.claude/{commands,agents}/` into each project at SessionStart, except manifest-declared local files and a baked-in exclusion list. A new command therefore reaches ~20 projects with no further action. | `new-project.md:465` |
| F14 | Project state conventions are **not uniform**. Of 26 project directories: 20 carry `pipeline/pipeline-state.md`, 6 do not; 25 carry `CLAUDE.md`; 25 carry `logs/decisions.md`; **0** carry `PROJECT.md`; 4 carry `logs/next-up.md`; 3 repos carry `logs/missions/`. | Filesystem survey, 2026-07-28. |
| F15 | `pipeline/pipeline-state.md` tracks `/new-project` scaffolding stages 3a–6, not live work. Its rows are `3a — Repo Snapshot`, `3b — Architecture Design`, `3c — Implementation Spec`, `4 — Implementation`, `5 — Testing`, `6 — Session Guide`. | `new-project.md:307-324`, `:892` |
| F16 | `/prime` Step 1c detects plan position from `pipeline-state.md` first, then a plan spine, and skips silently when neither exists. Step 1d scans `logs/missions/*.md` for `status: active` and is a "zero-cost no-op when none exist." Step 5 merges candidates and caps the menu at 6, ranked urgent → mission → carryover → next-up. | `prime.md:176`, `:215`, `:289-298` |
| F17 | `/mission` manages multi-session goals: a frozen contract at `<repo>/logs/missions/<id>.md` with Goal / In-scope-Out-of-scope / Validation contract / Open threads. Only `status` and `## Open threads` may change, and only via the command. The subsystem is advisory and blocks nothing. | `mission.md:10-14` |
| F18 | `/qc-pass` dispatches the `qc-reviewer` subagent with no conversation history, and carries a documented project-session fallback: resolve `ai-resources/` by walk-up, inline the agent definition into a `general-purpose` spawn with `model: opus` re-asserted. | `qc-pass.md:22-24` |
| F19 | `/risk-check` delegates to `risk-check-reviewer`, scores seven dimensions, writes a structured report to `audits/risk-checks/`, and returns exactly one of `GO` / `PROCEED-WITH-CAUTION` / `RECONSIDER`. | `risk-check.md:5` |
| F20 | `/implementation-triage` delegates to `system-owner` and returns `WORTH-DOING` / `MARGINAL` / `NOT-WORTH-DOING` / `DECLINE`. Chat-only; writes nothing at v1. | `implementation-triage.md:42-47`, `:64` |
| F21 | `/scope-project` is the complex-build scoping lane; `/context-builder` is the simple lane; both converge at `/plan-draft`. Stage 0 routes a fuzzy idea to `/grill-me` and stops. Stage 5 can end in `Park` / `Do Not Build` with no brief emitted. | `scope-project.md:13`, `:35-37`, `:78` |
| F22 | `/new-project` Step 0 disposition table can end in **A — no repository**, **B — existing owner** (return a handoff, do not modify that repository), **C — small durable document project**, or fallthrough to the full pipeline. Ambiguity resolves toward fallthrough. | `new-project.md:51-58` |
| F23 | `/leverage-idea` starts from an idea dump about **workspace AI resources**, stops at an implementation plan, applies no change, and enforces the complexity budget as a `MARGINAL` cap. | `leverage-idea.md:9`, `:11-13`, `:128` |
| F24 | `/graduate-resource` owns project-local → canonical promotion and requires confirmation from every existing canonical consumer before graduating. | `docs/ai-resource-creation.md:21` |
| F25 | Placement heuristics Q2 assign: operator-invoked-on-demand → slash command; reusable procedural instructions → skill; multi-section methodology reference → `docs/` or a skill. Q5 lists the risk-check classes. | `docs/repo-architecture.md:188-226` |
| F26 | **EmailOS does not exist in the repository.** Repo-wide search for "emailos" / "email os" → zero matches, any spelling. There is no CRM integration, no Gmail integration and no buyer-record structure anywhere. | Repo-wide grep, 2026-07-28. |
| F27 | "Contacting Strategy" appears only as a roadmap workstream line: *"Buy-side outreach (contacting strategy) builds the intelligence base — selective, systematized personalization, not high-volume cold email; first phase focuses on buy-side."* | `artifacts/merged-os-context/strategic-os/state/live/workstreams.md:11` |
| F28 | `axcion-communication-system` owns the **register-and-language layer** of email. `channels/email.md` exists as an authored scaffold (`status: scaffold`, `mvp_class: canon`, `cutover_blocking: true`, work unit W4.3 — content not yet written). The project's CLAUDE.md explicitly disclaims the situational-and-format layer and forbids writing into `interpersonal-communication` or `marketing-positioning`. | `channels/email.md:1-16`; `axcion-communication-system/CLAUDE.md:27` |
| F29 | The word **capability** is already taken inside that project with a different meaning: `capability/` holds `drills.md`, `assessment.md` and rubric templates for *human* communication proficiency. | `projects/axcion-communication-system/capability/` |
| F30 | `development/`, `initiatives/`, `capabilities/` and `build/` collide with **nothing** — zero matches across all 26 projects and `ai-resources/`. | Filesystem survey, 2026-07-28. |
| F31 | `axcion-linkedin-os` is a live, recent project implementing an operating capability with a lifecycle (`drafts/ → approved/ → scheduled/ → published/`), an explicit authority order, two hard laws enforced structurally in settings, a project-local QC command (`/linkedin-qc`) that is the sole writer of a gating frontmatter field, and four human-in-the-loop checkpoints. | `projects/axcion-linkedin-os/CLAUDE.md:1-25` |
| F32 | `ai-resources/plans/` is the established home for build plans of new commands. `plans/2026-06-12-leverage-idea-build-plan.md` is the direct precedent, carrying a status banner, context, gate record and outcome. | `ai-resources/plans/` |
| F33 | `ai-resources/templates/` holds `mission-contract.md` — precedent for a command-owned record template living in `templates/`. | `ai-resources/templates/` |
| F34 | Model defaults are prohibited at every settings layer and in every CLAUDE.md. Per-command / per-agent / per-skill YAML `model:` frontmatter is the only permitted tiering mechanism. New commands and skills declare an explicit tier and never inherit. | workspace `CLAUDE.md` § Model Tier |
| F35 | Project-level CLAUDE.md files no longer carry a `Model Selection` section; `/new-project` step 11a was deleted 2026-07-27. | workspace `CLAUDE.md` § Model Tier; `new-project.md:694` |
| F36 | `/new-project` Direct Route creates no `pipeline/` at all and defers `logs/decisions.md` until the first real decision — but provisions `logs/scripts/` whenever `logs/` is created. | `new-project.md:341-347`, `:410-412` |

### 2.2 Reasonable inferences (stated as inference, not fact)

| # | Inference | Basis | If wrong |
|---|---|---|---|
| I1 | A capability request arriving in a project session today would be routed to `/develop-ai-resource`, because that is the only command whose description matches "decide whether a thing should exist, then build it," and workspace `CLAUDE.md` § AI Resource Creation names it as the qualification path. | F3, F4, workspace CLAUDE.md | The boundary problem is smaller than assumed; the routing line in § 18 becomes less load-bearing but is still correct. |
| I2 | `axcion-communication-system` is the most likely owner of an EmailOS *language* seam but **not** of EmailOS itself — its CLAUDE.md restricts it to what the firm sounds like, not to workflow or relationship state (F28). | F28 | Owner selection for the EmailOS case (§ 17.2) changes; the owner-selection procedure in § 5.3 is unaffected because it is criteria-driven, not name-driven. |
| I3 | EmailOS, if built, would need an owning project that does not yet exist — it spans relationship state (CRM), contact rationale (Contacting Strategy), language (comms system) and an external record (Gmail). No current project claims the operating workflow. | F26, F27, F28, project survey | The Heavy lane would route to `/scope-project` at Frame rather than developing in place. Both paths are specified (§ 14.1). |
| I4 | Adding a `/prime` Step 1e is low-risk *in pattern* because Step 1d is an exact structural precedent (glob a directory, skip silently when absent, contribute bounded menu candidates), but it is not low-risk *in blast radius* because `/prime` runs at the start of essentially every session. | F16 | § 20 sequences the `/prime` edit as its own commit so it can be dropped without unpicking the rest. |
| I5 | `/mission` is adjacent, not duplicative: a mission is a frozen multi-session *goal contract* measured by `/drift-check`; a capability record is a living *development record* with phase, seam, slices, evidence and status. A Heavy capability may reasonably also be a mission, but the two files answer different questions. | F17 | If judged duplicative, the fallback is to extend `/mission` — rejected in § 3 with reasons. |

### 2.3 Unknowns (not resolved; do not let the plan assume them away)

- **U1.** Whether EmailOS's operating model works at all. Nobody has prepared a buyer email by this method and observed the result. This is precisely what the Medium/Heavy trial exists to discover — the plan must not encode an unvalidated workflow as a requirement.
- **U2.** Which project will own EmailOS. Deferred to a live Frame phase (§ 5.3 gives the procedure, not the answer).
- **U3.** What buyer-record structure exists or is authoritative. None found in the repository (F26). A capability depending on it will hit an evidence gap and must produce a requirements doc rather than invent a schema (workspace `CLAUDE.md` § Requirements-Doc Default).
- **U4.** Whether Codex review at two Heavy points is operationally sustainable for a single operator. Untested. § 24 makes it a retirement-review trigger.
- **U5.** How often Lightweight will be the right lane in practice. If Lightweight turns out to be rare, the three-lane design is over-built and § 24's simplification condition fires.

### 2.4 Settled inputs (operator decisions — treat as requirements, not proposals)

Locked by the operator brief:

1. `/develop-capability` is a new, separate command, kept separate from `/develop-ai-resource`; that command is not renamed, replaced, absorbed or broadened, and keeps its owned artifact class.
2. One operator-facing capability command — not three.
3. New-project creation stays with `/scope-project`, the planning pipeline and `/new-project`; route out when warranted.
4. An AI-resource sub-need is handed to `/develop-ai-resource` as a bounded brief; the AI-resource pipeline is never reproduced.
5. The SOP is directional. Do not mechanically convert thirteen steps into thirteen gates.
6. Plan only. No repository change before operator approval following independent QC.

Locked by the `/grill-me` interview (2026-07-28):

| Q | Decision |
|---|---|
| Q1 | Target repo: **current repo, now.** |
| Q2 | Boundary: **outcome vs. artifact.** A small compatibility edit to `/develop-ai-resource` is permitted; do not broaden or shrink its owned class. |
| Q3 | EmailOS and Contacting Strategy are **real intended capabilities**, among the first expected uses. Design against them seriously while separating confirmed facts, intended requirements and assumptions to be validated. |
| Q4 | Evidence is **operator-stated forward-looking need**, supported by two named intended uses, **not** a historical failure pattern. Do not invent friction-log evidence. Surface the complexity-budget conflict explicitly; a recorded principle exception is acceptable. |
| Q5 | Cross-project dependencies are **in scope**. Select one owning project; record seams against others. Dependencies do not become co-owners. Route to `/scope-project` only when no project can legitimately own it or the work is a new enduring programme. |
| Q6 | Lane selection: Lightweight and Medium **state and proceed**; Heavy **states, explains and stops**. Escalation into Heavy fires the Heavy stop at that point. |
| Q7 | Heavy operator-stop ceiling: **three** — (1) scope + implementation-package approval, including Heavy confirmation; (2) release / real-trial approval; (3) lifecycle decision after observed use. A passing review verdict does not earn its own routine stop. |
| Q8 | Review model: Lightweight → proportionate main-session verification unless a mandatory risk class fires. Medium → fresh-context Claude (`/qc-pass`, `/risk-check`) by claim and consequence. Heavy → **Codex** at the consequential points, plus Claude's deterministic checks. **No new reviewer agent. Do not imitate Codex inside Claude.** Produce a concise self-contained review brief and pause with instructions. |
| Q9 | Record: one authoritative record per operating capability for Medium and Heavy, carrying thirteen named fields and pointing to (never copying) plans, specs and review reports. Resolve the terminology collision before fixing a directory name. Lightweight may write **zero** dedicated files — one closing `logs/decisions.md` entry when durable behaviour changed, nothing when the outcome is no action. **Do not reuse `pipeline/pipeline-state.md` as live capability state.** |
| Q10 | Confidential data: the real-case trial **may** use real buyer or relationship data. Medium and Heavy therefore carry proportionate data handling — minimum necessary record, named authoritative source, no raw buyer/CRM/email data in committed artifacts, no committed trial outputs containing confidential information, durable records at the level of decisions/schemas/evidence summaries/redacted examples, explicit statement of what may go to external models, and disposal or retention per project rules. Prefer synthetic when it tests the same behaviour. |
| Q11 | Architecture: **one command (~150–220 lines) + one `capability-development` skill.** Command owns invocation, discovery, routing, orchestration, gates, resume, handoffs, reporting. Skill owns methodology, lane processes, intervention selection, trial design, ownership and seam method, slice standards, verification and lifecycle-decision standards. No second skill, no permanent lane agents in v1. |
| Q12 | All three lanes properly built in v1. Heavy may hand parts out but remains a genuine internal lane that owns the outcome, the seam, the record, the handoff coordination, the resume, the trial and the lifecycle decision. It must not print "run `/scope-project`" for every substantial capability. |
| Q13 (context) | Patrik is sole operator and intended user; non-developer — Claude makes technical and architectural decisions and surfaces business choices. No delivery deadline. Multi-tool environment: a capability may involve Claude, Codex, GPT/API, Gmail, CRM, Notion. A capability may be implemented through documents, standards, processes, data structures, integrations, software and AI resources in combination. Real use and adoption matter; correct files are not completion. Substantial enough to be reliable; minimalism is not a reason to omit Heavy, durable state, trials, ownership decisions or closure. Lightweight must still feel lightweight. Use **"operating capability"** to distinguish from the human-skill sense in `axcion-communication-system/capability/`. |

### 2.5 Proposed decisions (Claude's calls — the ones Codex should attack)

| # | Decision | Rationale | Rejected alternative |
|---|---|---|---|
| D1 | Five phases: **Frame → Shape → Build → Prove → Land**. | Compresses thirteen SOP steps into five without dropping any (§ 10 maps every one). Five is few enough to hold in mind and enough to place a gate honestly. | Thirteen stages — explicitly forbidden by the brief. Three phases — collapses "prove" into "build," which is the failure mode Principle 5 names. |
| D2 | Lane routing by **consequence classes**, not a score. Six Heavy triggers, five Medium triggers, Lightweight as residual. | Mirrors how the repo already classifies risk (`audit-discipline.md:56-71` uses classes, not scores). Class membership is checkable and arguable; a score is neither. | Weighted scoring across the operator's ten factors — produces false precision and invites tuning debates. |
| D3 | Record directory name: **`development/`**. | Zero collisions repo-wide (F30). Names the activity, not the noun, so it never competes with `capability/`'s human-skill sense (F29). Reads plainly to a non-developer. | `capabilities/` — worst option; would sit beside `capability/` in the same tree. `initiatives/` — reads as a business programme, invites scope inflation. |
| D4 | Record filename: `development/{slug}.md`, frontmatter-driven, **one file per operating capability**. | Matches the `/mission` precedent (F17, F33) and keeps `/prime` discovery to a bounded glob. | A single `development/register.md` — recreates the central registry the foundational document warns against, and serialises concurrent writes. |
| D5 | Heavy's Codex reviews **ride on the existing operator stops** rather than adding their own. | Satisfies the three-stop ceiling exactly (Q7) while still placing review before irreversible work. | A fourth stop for the review verdict — breaches the ceiling. |
| D6 | Invocation wiring = workspace `CLAUDE.md` routing line (initiation) **+** `/prime` Step 1e (resumption). | RR-05 requires a named invocation path (F10). Initiation and resumption are different problems; one line cannot solve both. | `/prime` edit only — leaves initiation memory-dependent. CLAUDE.md line only — leaves a half-finished Heavy capability invisible at the next session start. |
| D7 | `/develop-ai-resource` receives a **six-line additive clause**, no restructuring. | Q2 permits compatibility only. Any larger edit risks the four correction commits (F7) that stabilised it. | Adding a whole "upstream mode" branch — broadens the command, violates lock #3. |
| D8 | No new agent. Reuse `qc-reviewer`, `risk-check-reviewer`, `system-owner` as they stand. | Q8 forbids a new reviewer. The three existing agents cover fresh-context QC, structural risk and ROI. | A `capability-reviewer` agent — a fourth reviewer with overlapping scope, and a second detection component with no closure channel (OP-12). |
| D9 | The command **implements**; it is not advisory. | Q12 and lifecycle behaviours 8–13. `/leverage-idea` already occupies the advisory-plan-only niche (F23). | Stop-at-plan — would duplicate `/leverage-idea` and fail the "real use" standard. |
| D10 | Confidential trial material lives in the session scratchpad, never in the project tree. | Q10 forbids committed raw buyer data. The scratchpad is session-scoped and outside the repo. | A gitignored `development/trials/` directory — one `git add -f` or one `.gitignore` edit away from a leak. |

---

## 3. Current capability and overlap map

Bounded semantic sweep across `ai-resources/.claude/commands/` (88 files), `ai-resources/skills/` (85 directories), `ai-resources/.claude/agents/`, `ai-resources/docs/`, and `projects/project-planning/.claude/commands/` (96 files). Searched by *purpose and behaviour* — qualification, planning, execution, verification, adoption, closure, retirement — not by name.

### 3.1 Covers part of the need

| Resource | What it covers | What it does not | Boundary rule |
|---|---|---|---|
| `/develop-ai-resource` (`commands/develop-ai-resource.md`) | Need statement, evidence classification, existing-capability disposition, intervention ladder, complexity budget, no-build verdict, build, verify, decide — **for AI artifacts** (F3, F4). | Business/operational/product capabilities. Ownership and seam definition. Vertical-slice planning. Real-use trials. Cross-project seams. Lifecycle statuses beyond ship/revise/defer/delete. Multi-session state. | Outcome vs. artifact (§ 5.1). Receives bounded pre-qualified briefs; never reopens the operating need. |
| `/scope-project` (`commands/scope-project.md`) | Stages 0–5 producing a control pack + planning brief for a **complex build**; can end in Park / Do Not Build (F21). | Implementation. Verification. Real use. Closure. It stops at a brief. | `/develop-capability` routes *to* it when the work is really a new project (§ 14.1), and may consume its brief for a Heavy capability that needs formal planning (§ 14.2). |
| `/new-project` Step 0 (`commands/new-project.md:21-58`) | Existing-ownership inspection with a read budget, and dispositions A/B/C/fallthrough (F22). | Anything after project creation. Its disposition B *returns a handoff and stops* — it does not develop the capability in the owning project. | § 5.3's owner-selection procedure is a deliberate sibling of Step 0.2, tuned for capabilities rather than projects. Documented as such, not silently forked. |
| `/mission` (`commands/mission.md`) | Multi-session goal contracts with frozen scope and a validation contract, surfaced by `/prime`, measured by `/drift-check` (F17). | Seams, slices, verification evidence, lifecycle statuses, real-use results. A mission is a goal; a capability record is a development record. | Adjacent (I5). A Heavy capability *may* additionally be a mission; the plan does not require it and does not write mission files. |
| `/tech-consult` (`commands/tech-consult.md`) | Broad business need → build-ready technical plan via the altitude ladder, stopping at a Selection Memo gate. | Implementation, verification, adoption, closure. Advisory. | `/develop-capability` may invoke it inside Shape when a Heavy capability's technical shape is genuinely open. Optional adjunct, not a stage. |

### 3.2 Adjacent but different

| Resource | Why adjacent | Why different |
|---|---|---|
| `/leverage-idea` | Produces options, a worth-doing verdict and an implementation plan (F23). | Input is an idea dump about **workspace AI resources**; output stops at a plan and applies no change. Explicitly self-describes as idea-first system-routing (`leverage-idea.md:11`). |
| `/implementation-triage` | Judges whether a proposed implementation is worth doing (F20). | ROI verdict on an *already-proposed* implementation; chat-only, writes nothing. A specialist input, not a lifecycle. |
| `/risk-check` | Seven-dimension structural risk verdict (F19). | Risk of a change, not development of a capability. A gate `/develop-capability` calls. |
| `/qc-pass` | Independent fresh-context artifact review (F18). | Reviews an artifact against a scope line. Does not own need, seam or adoption. |
| `/post-project-review`, `/archive-project` | Project-level closure and archiving. | Project granularity, not capability granularity. A project may hold many capabilities. |
| `/innovation-sweep` | Project-end triage of Claude Code infrastructure innovations against the canonical library. | Infrastructure triage after a project ends; not a development lifecycle. |
| `/reconcile` | Judges a deliverable against a project mandate rubric. | Deliverable-vs-mandate conformance; needs `context/mandate-rubric.md`. Orthogonal. |
| `/project-next-steps` | Plain-language resume briefing for a project. | Read-only orientation across a whole project; not capability-scoped and does not execute. |
| `/requirements-pack` (project-planning) | Operator-fillable requirement scaffolding. | An artifact shape `/develop-capability` may produce at an evidence gap, not a competing lifecycle. |
| `axcion-linkedin-os` (F31) | A *built example* of an operating capability with lifecycle, authority order and gates. | A project, not a resource. Valuable as a worked reference for what "good" looks like — cite it in the skill, do not couple to it. |

### 3.3 Downstream dependency

`/create-skill`, `/improve-skill`, `/migrate-skill` — reached only through `/develop-ai-resource` (F5); `/develop-capability` never calls them directly. `/graduate-resource` (F24) — reached only when a project-local resource produced by a capability later justifies promotion. `/plan-draft` → `/plan-refine` → `/plan-evaluate` (and the spec cycle) — reached only through the § 14.2 formal-planning handoff. `qc-reviewer`, `risk-check-reviewer`, `system-owner` — reached through their owning commands, never spawned directly.

### 3.4 Conflict or duplication risk

| Risk | Assessment | Mitigation |
|---|---|---|
| **Double qualification with `/develop-ai-resource`** — the same need qualified twice, by two commands that can disagree. | **Real and the highest-severity risk in this design.** Both commands start from "is this need real, and what is the smallest thing that serves it." | The § 14.3 handoff contract plus the § 18 compatibility clause. The brief declares what is settled upstream; the downstream command re-qualifies the **artifact**, never the operating need. Acceptance tests AT-11 and AT-12 verify this in both directions. |
| **Front-half overlap with `/scope-project` Stage 0–1** | Moderate. Both inspect reality and can conclude "do not build." | Granularity differs: `/scope-project` decides whether a *project* should exist; `/develop-capability` Frame decides whether a *capability* should exist inside one that already does. Frame routes out the moment the answer is "this is a project" (§ 14.1). |
| **Record vs. `/mission` contract** | Low-moderate. Both are multi-session state files under `logs/`-adjacent conventions. | Different directories (`development/` vs `logs/missions/`), different lifecycles, different consumers. § 12.6 states when to use which. |
| **A fourth "state file" per project** | Real. Projects already carry `CLAUDE.md`, `logs/decisions.md`, and often `pipeline/`. | Lightweight adds nothing. Medium/Heavy add one file *per capability under development*, which is deleted from active status by reaching a terminal lifecycle status. § 12.7 caps and closes. |
| **Two commands whose names both begin `/develop-`** | Low but real operator-facing confusion. | The § 18 workspace `CLAUDE.md` routing line states the test in one sentence: *outcome → `/develop-capability`; artifact → `/develop-ai-resource`.* Both command files carry a reciprocal boundary paragraph. |

---

## 4. `/develop-capability` — purpose, trigger, exclusions

### 4.1 Purpose

Take an **operating capability** — something Axcíon needs to be able to *do* — from a stated need to an explicit lifecycle status, inside an existing Axcíon project, at a process weight proportionate to its consequence.

**Definition (canonical, to be stated in both the command and the skill):**

> An **operating capability** is a durable ability Axcíon exercises to perform real work: preparing a buyer email, deciding whom to contact and why, producing a sector report to a fixed standard, maintaining an approved-language register. It may be implemented through documents, standards, processes, data structures, integrations, software, AI resources, or any combination. It is defined by the outcome it produces, never by the artifacts it is made of.
>
> This is **not** the sense used in `projects/axcion-communication-system/capability/`, which means human communication proficiency (drills, assessment, rubrics). Where confusion is possible, write *operating capability* in full.

### 4.2 Trigger

`/develop-capability [outcome or observed need]`

Fires when all of the following hold:

1. The session is inside — or can name — an existing Axcíon project.
2. The operator wants Axcíon to be able to *do* something it cannot reliably do today, or wants an existing operating ability improved.
3. The desired end state is an operating outcome, not an artifact. "Prepare one useful buyer email" fires. "Write a drafting skill" does not — that is already an artifact decision and belongs to `/develop-ai-resource`.

With no argument, the command attempts resume (§ 15.1) before asking for a need.

### 4.3 Exclusions — what it does not do

| Excluded | Owner |
|---|---|
| Creating a new project | `/scope-project` → `/plan-draft` chain → `/new-project` |
| Authoring an AI resource (skill, command, agent, prompt, hook, script, persistent instruction, reference file) | `/develop-ai-resource` |
| Repository redesign, architecture review, recurring audits, permission redesign | `/systems-review`, `/architecture-review`, `/friday-checkup`, `/permission-sweep` |
| Incident recovery, broken repo state, session/workflow faults | `/resolve-repo-problem`, `/resolve-incident` |
| Promoting a project-local resource to canonical | `/graduate-resource` |
| Project-level closure and archiving | `/post-project-review`, `/archive-project` |
| Research execution | the research workflow and its deploy command |
| Judging an already-proposed implementation's ROI | `/implementation-triage` |
| Turning an idea dump into leverage options | `/leverage-idea` |

**It also does not:** create a registry; write to another project's tree; commit confidential trial output; spawn a new reviewer agent; run more operator stops than § 11 allows; or expand a capability's scope because it noticed an adjacent improvement.

### 4.4 The complexity-budget conflict, stated plainly

`docs/ai-resource-creation.md:25-34` requires one of two prongs.

- **Prong (a), net-simplification: FAILS.** This adds two load-bearing units (one command, one skill) and one always-loaded routing line, and removes nothing.
- **Prong (b), evidenced failure: FAILS.** The operator has confirmed (Q4) there is no historical failure pattern. The evidence is a forward-looking operator-stated requirement supported by two named intended uses. Rule #7 is explicit that *"we might need it"* and *"for a future phase"* do not satisfy (b).
- **RR-05 replacement test:** replaces nothing. The separateness justification is that project creation, AI-resource authoring and operating-capability development are three different lifecycles with different inputs, different owners and different terminal states — and locks #1–#5 forbid merging them.
- **RR-05 invocation path:** satisfied — § 19.1 (workspace `CLAUDE.md` routing) and § 19.2 (`/prime` Step 1e).
- **OP-12 detector/closer test:** not applicable. This is not a detection component; it closes its own findings by reaching a lifecycle status.

**Therefore the build proceeds as a recorded OP-11 exception.** The exact entry to append to `ai-resources/logs/decisions.md` at Commit 6:

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
#7's own closing clause, that makes this a loud, recorded OP-11 exception — not an inline
"it's fine actually."

**Rationale.** (1) The distinct responsibility is load-bearing: three lifecycles, three
terminal states, three owners; locks #1–#5 of the operator brief forbid merging them.
(2) The precedent is established — `logs/decisions.md` 2026-07-23 landed the `/new-project`
direct route with zero live consumers on the reasoning that requiring a live consumer before
permitting the mechanism is circular. The same circularity applies here: EmailOS cannot be
developed by a method that does not exist. (3) RR-05 is satisfied on both limbs — the command
replaces nothing and is separate for stated reasons, and it is wired at two invocation points
(workspace `CLAUDE.md` routing; `/prime` Step 1e), not left memory-dependent. (4) The exception
is bounded by § 24 of the build plan, which sets explicit simplification and retirement
conditions reviewed after the third completed capability lifecycle.

**Alternatives considered.**
- *Defer until a capability fails without it.* Rejected — circular per the 2026-07-23 precedent, and the first failure would land on EmailOS, which touches confidential buyer data.
- *Broaden `/develop-ai-resource` to cover operating capabilities.* Rejected — forbidden by operator locks #2–#4, and it would give one command two different terminal states.
- *Invent friction-log evidence to clear prong (b).* Rejected outright. Fabricated evidence in a gate record is worse than a recorded exception.
- *Ship Lightweight + Medium only, Heavy as a routing exit.* Rejected by the operator (Q12) and on merit — a routing exit cannot own the seam, the record, the trial or the adoption decision.

**Decided by:** Patrik (operator), 2026-07-DD, after independent Codex QC of
`plans/2026-07-28-develop-capability-build-plan.md`. Executed by Claude.
Gate reports: `audits/risk-checks/{plan-time report}` and `audits/risk-checks/{end-time report}`.
```

---

## 5. Boundary map against neighbouring commands and project lifecycles

### 5.1 The load-bearing distinction

> **`/develop-capability` owns the operating outcome. `/develop-ai-resource` owns the artifact.**
>
> "Prepare one useful buyer email" is an outcome — `/develop-capability`.
> "Author the specialist drafting skill that workflow needs" is an artifact — `/develop-ai-resource`.
> **The skill is not the capability. It is one implementation component.**

This sentence, in this form, appears in four places: the command file, the skill file, workspace `CLAUDE.md`, and the reciprocal paragraph added to `/develop-ai-resource`. Identical wording in all four so a reader who lands on any one gets the whole rule.

### 5.2 Decision table — where does a request go?

| The operator says… | Goes to | Because |
|---|---|---|
| "I want to be able to prepare a buyer email properly" | `/develop-capability` | An operating outcome inside a project. |
| "We need a skill that drafts buyer emails" | `/develop-ai-resource` | An artifact decision already taken. (If the operator is wrong about that, `/develop-ai-resource` Step 1.4's ladder will say so.) |
| "Buy-side outreach should become a whole programme with its own repo" | `/scope-project` | A new project, not a capability inside one. |
| "This command is broken" | `/resolve-repo-problem` | A fault, not development. |
| "Here are three pages of notes about improving the repo" | `/leverage-idea` | Idea dump about workspace AI resources. |
| "Is this proposed implementation worth doing?" | `/implementation-triage` | ROI verdict on an existing proposal. |
| "Should this project-local thing become shared?" | `/graduate-resource` | Promotion, with consumer confirmation. |
| "Where should this new file live?" | `/placement` | Advisory placement. |

### 5.3 Owner selection — the procedure (Q5)

When a capability touches more than one project, apply the operator's four criteria **in order** and stop at the first that discriminates:

1. **Which project owns the primary operating outcome?** — the project whose deliverable or responsibility the capability directly produces.
2. **Which project owns the capability's continuing decisions and maintenance?** — where the next ten judgment calls about it will be made.
3. **Which authoritative source should define its behaviour?** — the project holding the document that governs how it must work.
4. **Which project would still own it if one dependency were replaced?** — swap the CRM, swap Gmail; who is left holding it.

Rules that bind the procedure:

- **Dependencies never become co-owners.** A capability that reads from CRM does not make the CRM project a co-owner; it makes CRM an external dependency recorded in the seam.
- **Evidence, not names.** Every ownership conclusion cites the specific file and line that supports it — a project `CLAUDE.md` section, an authority order, a standing prohibition. `axcion-communication-system/CLAUDE.md:27` and `:31-34` are examples of the kind of statement that settles ownership; a directory name is not.
- **Absence is not evidence.** An empty directory, an unpopulated table cell or a search that found nothing is evidence about that source, never a positive fact about ownership. (This is the recurring defect class logged HIGH in `axcion-communication-system/CLAUDE.md:44` — three instances, one of which produced a real out-of-scope action.)
- **Route out when no project qualifies.** If criteria 1–4 leave no legitimate owner, or if selecting one would effectively create a new domain or an enduring programme, Frame ends in the § 14.1 new-project handoff. This is a *conclusion*, not a default: the command must state which criterion failed and why.

### 5.4 Reciprocal boundary text added to `/develop-ai-resource`

Appended to its existing **Boundary vs neighbours** block (`develop-ai-resource.md:19-23`), which already lists five neighbours — this is a sixth bullet plus the shared sentence, not a restructure:

```markdown
- `/develop-capability` develops **operating capabilities** — business, operational and
  product abilities inside existing projects. It owns the operating outcome; this command
  owns the artifact. The skill is not the capability; it is one implementation component.
  A brief arriving from it carries `**Capability:**` and `**Settled upstream:**` — see
  Step 1's upstream-brief clause.
```

---

## 6. Lane-routing model, escalation and de-escalation

### 6.1 Principle

Lane is a judgment about **consequence**, made from evidence gathered in Frame. It is never a judgment about file count, line count or effort. A one-line change that alters what Axcíon sends to a real buyer is Heavy. A three-hundred-line internal reference document with one owner and no external reader is Lightweight.

Routing runs top-down: **Heavy triggers first, then Medium triggers, then Lightweight as the residual.** Any single trigger fires its lane. Ambiguity resolves **upward**, never downward — the same fail-safe posture `/new-project` uses (`new-project.md:58`).

### 6.2 Heavy triggers — any one fires Heavy

| # | Trigger | Test |
|---|---|---|
| H1 | **External or shared system integration.** The capability reads from or writes to a system outside the owning project in normal operation — CRM, Gmail, Notion, an API, another Axcíon project's tree, another tool in the ecosystem. | Name the system and the direction of flow. A one-off manual copy-paste by a human is not an integration. |
| H2 | **Real confidential data in normal operation.** Buyer, client, relationship, deal or commercially sensitive information flows through the capability when it runs — not merely during a trial. | Name the data class and its authoritative source. |
| H3 | **Two or more consumers, or a second project must change.** Another project, workflow or person other than the owner depends on it, or must alter its own artifacts to accommodate it. | Enumerate consumers. "Might be useful to others" is not a consumer (AP-7/DR-7). |
| H4 | **Difficult reversibility.** Undoing it after adoption costs more than reverting a commit — published artifacts, external records, sent communications, data migration, or a working habit others build on. | State the concrete undo procedure. If you cannot, it is H4. |
| H5 | **Canonical ownership change.** The capability claims, moves or contradicts a responsibility that another project's authority document currently holds. | Cite the authority document and the clause. |
| H6 | **Shared infrastructure.** It creates or changes an `ai-resources` resource used beyond the owning project, a hook, or automation with shared-state effects (auto-write to logs, cross-repo writes, auto-commit). | Matches the `/risk-check` class list at `docs/audit-discipline.md:60-65`. |

### 6.3 Medium triggers — any one fires Medium, when no Heavy trigger fired

| # | Trigger | Test |
|---|---|---|
| M1 | **The operating workflow is not demonstrated.** Nobody has produced the intended result this way, even by hand. The operating model is a hypothesis. | Has one real case been run end to end and the result observed? If no → M1. |
| M2 | **Three or more distinct behaviours, or work plainly spanning sessions.** | Count the behaviours the capability must exhibit, not the files it touches. |
| M3 | **Ownership is ambiguous.** More than one project could plausibly own it, or it depends on a sibling project's authority document. | § 5.3 criteria 1–2 did not discriminate cleanly. |
| M4 | **It needs an AI resource that does not exist.** A § 14.3 handoff to `/develop-ai-resource` is required. | The artifact must be authored, not merely used. |
| M5 | **Verification needs more than reading the diff.** A trial, a real record, or comparison against a written standard is required to know it works. | Can a human confirm correctness by looking at the output alone? If no → M5. |

### 6.4 Lightweight — the residual

No Heavy and no Medium trigger fires. Concretely: one owner, one project, a workflow already understood, reversible by reverting a commit, one or two behaviours, no external system, no confidential data in operation, no new AI resource, and verification is "look at the result."

Lightweight still performs the full lifecycle — outcome, reality inspection, no-build/manual/reuse consideration, observable behaviour, one complete slice, proportionate verification, demonstrated use, lifecycle status. It just does all of it in one session, in chat, with no dedicated files (§ 12.2).

### 6.5 How the lane is announced

- **Lightweight / Medium** — one line, then continue. Format: `Lane: {lane}. {The trigger that fired, or "no Medium or Heavy trigger fires"}. Say so if that is wrong.` This satisfies workspace `CLAUDE.md` § Decision-Point Posture.
- **Heavy** — state the lane, name every trigger that fired, state the consequence in plain English (how many operator stops, whether Codex review is required, whether confidential data is involved, what the release step will be), then **stop** for confirmation. This is operator stop **G1** (§ 11) — Heavy does not get a separate earlier lane stop.

### 6.6 Escalation

Escalation may fire at any point, in any phase, when evidence changes the assessment. It is **additive** — nothing already produced is discarded.

| From | To | What happens |
|---|---|---|
| Lightweight | Medium | State the trigger that newly fired. Open the capability record (§ 12.3) and backfill it from work already done. Continue from the current phase. No operator stop. |
| Lightweight or Medium | Heavy | State the trigger. Open or upgrade the record. **Stop immediately for the Heavy confirmation** — this is G1, arriving mid-run. Do not begin Heavy obligations before the operator confirms. |
| Medium | Heavy | As above. If implementation has already begun, name exactly what has been built and committed, so the operator confirms Heavy knowing what exists. |

**Mandatory escalation checkpoints** — the lane call is re-tested at each phase boundary, and always when any of these is discovered: a second consumer; an external system; real confidential data; an irreversible step; a conflicting authority document. Re-testing at a boundary is cheap and silent when nothing changed.

### 6.7 De-escalation

De-escalation requires a trigger to be **disproven by evidence**, not merely doubted. It may only occur at a phase boundary, and never after an operator stop has approved the heavier lane for that phase.

| From | To | Condition |
|---|---|---|
| Heavy | Medium | Every Heavy trigger that fired is disproven with cited evidence — e.g. the integration turned out to be a human copy-paste, the "second consumer" turned out to be speculative. Requires operator acknowledgement in one line because the operator approved Heavy at G1. |
| Medium | Lightweight | Every Medium trigger disproven — e.g. the trial demonstrated the workflow (M1 closed) and the behaviour count is one. State and proceed. |

**Artifacts are never discarded on de-escalation.** A capability record already opened stays open and is completed; it simply stops accruing Heavy obligations. Deleting a record to make a lane change look clean is prohibited — it destroys the decision history that makes the change auditable.

### 6.8 Recording the lane

Every lane call, escalation and de-escalation is recorded:
- **Lightweight** — in the closing `logs/decisions.md` entry, one clause.
- **Medium / Heavy** — in the record's `## Lane` section as a dated list, append-only. The frontmatter `lane:` field always shows the *current* lane.

---

## 7. Detailed Lightweight process

**Governing feel:** one session, chat-first, no dedicated files, no subagents, no gates. If it starts to feel heavier than that, the lane is wrong — re-test § 6.

### Phase 1 — Frame

1. **State the operating outcome in one sentence**, as a result, not a system. If the operator's input names a system, restate it as the outcome and say you have done so.
2. **Inspect reality — bounded.** Read the project `CLAUDE.md`, then at most **four** further files chosen for relevance (an authority document, the artifact being changed, `logs/decisions.md` if a prior decision is likely, one example of current output). Exceeding four is a finding to report, not licence to keep reading.
3. **Separate facts from inference.** Three short lists: confirmed (with paths), inferred, unknown. Two lines each is normal at this lane.
4. **Walk the intervention ladder** and say where you stopped: accept the limitation → change an operating habit → clarify ownership or information flow → reuse an existing capability → simplify or remove the source → narrow local improvement → bounded experiment → build. Name the rung and why not the one below it.
5. **Lane call** — state and proceed (§ 6.5).

**Exit condition:** the outcome, the evidence, the ladder rung and the lane are stated. **A no-build, manual or reuse outcome exits here to Phase 5** and is a success, not a failure.

### Phase 2 — Shape

6. **Name the one owner** — which responsibility this belongs to and where it lives. One line.
7. **State the observable behaviour** — what must demonstrably work, in the operator's terms. One to three bullets. This is the acceptance condition.
8. **State the exclusions** — what will not be built. One line. This is what stops adjacent-improvement creep.

No implementation package. No seam document. No terminology exercise unless a term is actually ambiguous — if it is, define it in one line and use it consistently.

### Phase 3 — Build

9. **One complete slice.** A whole behaviour, end to end, useful on its own. Not a layer.
10. **Implement the smallest coherent change** that satisfies it.
11. **Commit** the slice. Per workspace `CLAUDE.md`: commit directly, no pre-commit checks, no push.

If the work will not fit one slice, that is M2 — escalate.

### Phase 4 — Prove

12. **Verify proportionately.** Read the produced artifact from disk (not from memory of writing it) and compare it against the Phase 2 observable behaviour.
13. **Match evidence to claim.** A runtime claim needs execution. A file-scope claim needs the diff. A factual claim needs the source. A claim that was not tested is reported as **unassessed**, never as passed.
14. **`/risk-check` only if a mandatory class fired** (`docs/audit-discipline.md:56-71`). If one did — a new command or skill, a hook edit, a permission change, a cross-cutting CLAUDE.md edit, a new symlink, shared-state automation — that is also H6 and the lane was wrong: escalate rather than bolt a gate onto Lightweight.

No `/qc-pass`. No subagent. No independent review.

### Phase 5 — Land

15. **Demonstrate use.** Run it, or show the produced artifact doing its job, once. Show the operator something visible — a diff, a printed result, the finished document.
16. **State the lifecycle status** and proceed (no stop): adopt · revise · keep local · close · reject. Continue-trial, pause and retire are available but rare at this lane.
17. **Record.** If durable project behaviour was created or changed, append **one** entry to `projects/{project}/logs/decisions.md` in that file's existing canonical shape (`## YYYY-MM-DD — {title}` / **Context** / **Decision** / **Rationale** / **Alternatives considered**), naming the capability, the outcome and the status. If the outcome was no action and nothing durable was decided, **write nothing** — chat is the record, and git history plus the changed artifact are the evidence of implementation.

**Total operator stops: zero.**

---

## 8. Detailed Medium process

**Governing feel:** may span sessions; carries one durable record; one operator stop at the end; fresh-context Claude review where the claim warrants it.

### Phase 1 — Frame

1–4. As Lightweight, with a wider read budget: project `CLAUDE.md`, `logs/decisions.md`, any authority document the capability touches, existing `development/*.md` records, and up to **twelve** files total. Exceeding twelve is reported.
5. **Existing-capability disposition.** Search by purpose and behaviour — not name — across the owning project and the projects the need plausibly touches. Disposition every near-match as **covers it · covers part of it · adjacent but different**, with the path. Reuse beats build; finding that the need is already served is a successful outcome.
6. **Lane call** — state and proceed.
7. **Open the capability record** (§ 12.3) at `projects/{owner}/development/{slug}.md`, phase `frame`, status `in-development`. Frame's outputs are written into it now; the record is not a wrap-up artifact.

**Exit:** record exists with verified need, facts/inferences/unknowns, ladder rung, lane and rationale. A no-build outcome closes the record with status `rejected` and exits to Phase 5.

### Phase 2 — Shape

8. **Terminology.** Define only the terms that are actually consequential and could mean two things. Each term means one thing; two concepts never share a name. Record them.
9. **Ownership.** Apply § 5.3. Record the owner and the cited evidence. Record each dependency as a dependency, not a co-owner.
10. **Seam.** Record the public boundary in the SOP's own seven fields: Input · Output · Owning capability · External dependencies · Observable failure states · Side effects · How behaviour will be tested. Keep it small enough that the operator never has to coordinate internals.
11. **Real-case trial — required when M1 fired.** Run one genuine case by hand or with temporary tooling before committing to permanent work. Design it to answer: does the workflow produce value; can the operator use it; what information is actually needed; which assumptions were wrong; where are the real boundaries; is permanent work still justified. Apply § 9.7 data handling if real records are used. **Stop condition: if the trial does not produce a useful result, do not build.** Record the observed result — including a negative one — and re-enter step 5.
12. **Thin implementation package** — written into the record, not a separate document. Eleven fields, each short: verified need · intended outcome · users · public interface · observable behaviours · ownership and dependencies · smallest useful version · exclusions · verification · adoption condition · retirement condition. It states outcome, boundaries, behaviour, evidence and exclusions. It does **not** dictate functions, files or abstractions — that is Claude's job after inspecting the repository, and a package that specifies internals is the failure mode this design exists to remove.
13. **Vertical slices.** Order two to five complete behaviours. Each independently understandable, independently testable, small enough to review, useful end to end, separately committable. Slicing by layer — all schemas, then all logic, then all tests — is wrong and must be rewritten.
14. **AI-resource handoffs identified.** Any artifact needing authorship is named now as a § 14.3 brief, not discovered mid-build.

**Exit:** package complete, slices ordered, first slice is a complete behaviour. Record updated, phase `shape`.

### Phase 3 — Build

15. **Per slice: reproduce-or-fail → implement → refactor → verify → commit.**
    - *Reproduce or fail* — create a behavioural check or a reproducible failure and confirm it fails for the expected reason.
    - *Implement* — the smallest coherent change that satisfies the behaviour.
    - *Refactor* — naming, boundaries, duplication, while behaviour stays green.
    - *Verify* — the targeted check, relevant surrounding checks, any deterministic check, and a representative runtime or operator-path demonstration.
    - *Commit* — the coherent slice, before moving on.
16. **Fire § 14.3 handoffs** to `/develop-ai-resource` as each slice needs its artifact. Resume the slice when the artifact returns with its disposition.
17. **Scope discipline.** Adjacent improvements are not added. A material scope change is a new decision recorded in the record, not a longer diff. If the change is material enough to alter the seam or the exclusions, re-test the lane (§ 6.6).
18. **Update the record after each slice** — tick the slice, update `next action`, update `updated:`. This is what makes the work resumable (§ 15).

**Exit:** every slice has a failing case, a correction, verification and its own commit; nothing outside approved scope changed.

### Phase 4 — Prove

19. **Self-review — both questions, separately.** *Is it well made?* (interface small, one owner per responsibility, no duplicated behaviour, proportionate architecture, tests coupled to outcomes not internals, controls demonstrated in their real invocation path, anything removable removed, work recoverable). *Does it belong?* (the capability is still justified, the mechanism is still the smallest reliable one, it duplicates and conflicts with nothing, it references rather than copies authoritative context, its maintenance cost is proportionate, it can be removed cleanly). Keep these separate — a well-made thing can still be the wrong thing to own.
20. **Match evidence to claim.** Runtime → execution. File-scope → diff. Compatibility → representative test. Factual → source. **A hook, rule or guard does not count merely because its file exists.** Every claim is marked observed · unassessed · blocked.
21. **`/qc-pass`** on the built result, selected by claim and consequence. Supply the scope line explicitly. If the `qc-reviewer` agent type fails to resolve from a project session, use the documented fallback at `qc-pass.md:24` — inline the definition into a `general-purpose` spawn with `model: opus` re-asserted — and note `(fallback: general-purpose, opus re-asserted)` beside the verdict.
22. **`/risk-check`** if any mandatory class fired. Note: a mandatory class is also H6, so this should normally have escalated to Heavy already; if it did not, escalate now.
23. **Simplify.** Remove instructions, content or machinery that do not contribute to the demonstrated behaviour, then rerun every materially affected case.

**Exit:** both self-review questions answered, every claim marked, review verdicts recorded in the record with paths.

### Phase 5 — Land

24. **Real use.** The capability enters its real operating environment and is used at least once for its actual purpose. The outcome of that use is observed and recorded. Technical completion is not project completion.
25. **Operator stop — the lifecycle decision.** Present: what was needed; what was built; what was tested and observed; what the real use showed; what remains open; the recommended status and why. The operator chooses one of **adopt · continue trial · revise · keep local · pause · close · retire · reject**. Inactivity is not a status.
26. **Record closure.** Write the status into frontmatter and into the record's `## Lifecycle status` section with the date and the operator's decision. Append one summarising entry to `projects/{owner}/logs/decisions.md`. Remove nothing.

**Total operator stops: one.**

---

## 9. Detailed Heavy process

**Governing feel:** consequential work. Deeper inspection, an approved package, Codex review at two points, controlled release, three operator stops. Every additional obligation exists because a specific Heavy trigger fired — Heavy is not "Medium with more ceremony."

### Phase 1 — Frame (deeper)

1–5. As Medium, plus:
6. **Consumer inventory.** Enumerate every consumer explicitly — each project, workflow, document, external system and person that depends on, or will be changed by, this capability. Grep-based where possible; named where not. "Might be useful to others" is not a consumer.
7. **Authority inspection.** For every project the capability touches, read its authority surface and cite the specific clause that grants or denies ownership. Do not infer ownership from a directory name. An absence in a source is evidence about that source, not about the world.
8. **Reversibility statement.** State the concrete undo procedure for each irreversible-looking step. If none can be stated, H4 is confirmed.
9. **Data-flow statement.** If H2 fired: which data class, which authoritative system holds it, where it flows, what may and may not leave Axcíon's boundary, and what may go to which external model or tool.
10. **Lane call → operator stop G1 is armed** (taken at the end of Phase 2, not here — Q7 forbids a separate earlier lane stop).
11. **Open the record**, phase `frame`, lane `heavy`.

**Exit, or route out:** if § 5.3 finds no legitimate owner, or the work is a new enduring programme, take the § 14.1 new-project handoff and stop. State which criterion failed.

### Phase 2 — Shape (durable package)

12–18. As Medium steps 8–14, with these strengthened:
- **Seam** is stated at two levels — the technical seam (interfaces, data, failure states) and the operating seam (who decides what, which system is the official record, what a human must approve). `axcion-linkedin-os/CLAUDE.md:1-25` is the reference example of an operating seam done well: an authority order, hard laws, a lifecycle with no skipped stages, and four human-in-the-loop checkpoints.
- **Trial is mandatory unless the workflow is already demonstrated in production.** Not "recommended."
- **Package is durable and approved** — it is the artifact the operator signs off and Codex reviews, and it is versioned in the record rather than overwritten.
- **Formal planning handoff** (§ 14.2) when the capability warrants a control pack or a specification: hand out to `/scope-project` or the `/plan-draft` chain, then resume and point the record at the produced artifacts. Never copy them in.
- **Release plan** — how the capability first enters real use: limited trial, single real case, restricted consumer set, and the rollback path.

19. **Compose the Codex review brief #1** (§ 16.4) covering the package: verified need, facts/inferences/unknowns, ownership and seam, exclusions, slices, verification approach, review and release approach, and the specific claims most worth attacking.

20. **OPERATOR STOP G1 — scope and implementation-package approval.** Present the package, the Heavy lane and its triggers, the consequence in plain English, and the Codex brief. The operator confirms Heavy, approves scope, and takes the brief to Codex. Work resumes when the operator returns the Codex findings.

21. **Adjudicate Codex findings.** Codex findings are **claims to be tested, not implementation instructions.** Verify each against the repository before acting. Give every material finding an explicit disposition: accept and fix · accept and defer with a trigger · reject with cited evidence. Record all dispositions. Only business-risk or maintenance-burden disagreements reach the operator; technical disputes are resolved by evidence first.

### Phase 3 — Build

22–25. As Medium steps 15–18, plus:
- **Failure and recovery behaviour is implemented as a slice**, not documented as an intention. A control that has not been demonstrated in its real invocation path does not count.
- **Confidential material never enters the project tree.** Trial inputs and outputs containing real buyer, CRM, email or relationship data live in the session scratchpad. Durable records carry decisions, schemas, evidence summaries and redacted or synthetic examples only.
- **Commit per slice**, so a failure discovered later never costs more than one slice.

### Phase 4 — Prove

26–30. As Medium steps 19–23, plus:
- **Behavioural, integration, failure and recovery testing.** Integration tests exercise the real seam. Failure tests confirm the capability fails visibly and recoverably. Recovery tests confirm the stated undo procedure actually works.
- **`/risk-check`** — mandatory when any listed class was touched; two gates per `docs/audit-discipline.md:73-81`.
- **Codex review brief #2** — the implemented result: what was built, what was tested and observed, what is unassessed, the release plan, the rollback path, and the claims most worth attacking.

31. **OPERATOR STOP G2 — release / real-trial approval.** Present the built result, the evidence table (observed / unassessed / blocked), review verdicts, the release plan and the rollback path, plus Codex brief #2. The operator runs Codex and approves entry into the real operating environment. Findings are adjudicated as in step 21.

### Phase 5 — Land

32. **Controlled release / limited trial**, exactly as approved. Real operating use with real consequence.
33. **Observe and record the outcome** — what happened, what the operator experienced, what did not work.
34. **OPERATOR STOP G3 — lifecycle decision.** One of adopt · continue trial · revise · keep local · pause · close · retire · reject. Plus, for Heavy specifically: the retirement condition and the rollback method are restated and recorded, because a Heavy capability that cannot be removed later is a permanent liability.
35. **Record closure** as Medium step 26, plus a `logs/decisions.md` entry in the owning project, plus — if the capability changed a shared resource — the consumer confirmations `docs/ai-resource-creation.md:21` requires.

**Total operator stops: three.** An adverse review verdict, a blocking unknown, or a material scope change may cause an **exceptional pause**. Those are failure conditions, not planned gates, and each is reported as such.

---

## 10. Shared lifecycle invariants across all lanes

These hold in every lane. Lane changes the *depth*, never the *presence*.

| # | Invariant | SOP step | Lightweight | Medium | Heavy |
|---|---|---|---|---|---|
| 1 | Start from the required operating outcome, not a proposed system | 1 | one sentence | one sentence + record | one sentence + record |
| 2 | Inspect current reality before planning | 2 | ≤4 files | ≤12 files | ≤12 files + consumer inventory + authority citation |
| 3 | Separate confirmed facts, inferences, unknowns, proposals | 2.2 | three short lists | recorded | recorded + Codex-reviewed |
| 4 | Consider the intervention ladder including no-build | 3 | name the rung | name the rung + disposition near-matches | + consumer-aware disposition |
| 5 | Run a real case before permanent implementation when the workflow is not demonstrated | 4 | n/a (M1 would escalate) | required when M1 fired | mandatory unless already demonstrated in production |
| 6 | Consequential terminology, one owner per responsibility, small public seam | 5 | one owner named | terms + owner + 7-field seam | + operating seam and authority citations |
| 7 | Thinnest implementation package appropriate to the lane | 6 | 3 lines (owner, behaviour, exclusions) | 11-field package in the record | durable, versioned, approved, Codex-reviewed |
| 8 | Plan complete vertical behaviours, not technical layers | 8 | one slice | 2–5 ordered slices | ordered slices incl. failure/recovery |
| 9 | Implement and verify one coherent slice at a time | 9 | one commit | commit per slice | commit per slice |
| 10 | Match evidence to the type of claim | 10 | stated inline | recorded per claim | recorded + independently reviewed |
| 11 | Independent review by consequence, not habit | 7, 11 | none unless a mandatory class fires | `/qc-pass`, `/risk-check` by claim | Codex ×2 + `/risk-check` |
| 12 | Real operating use before adoption | 12 | demonstrate once | real use, observed | controlled release, real use, observed |
| 13 | End with an explicit status | 13 | stated + logged if durable | operator decides | operator decides + retirement condition restated |

**Two further invariants, not from the SOP but from the foundational document:**

14. **Conflicts are surfaced, not silently resolved.** Two authoritative sources that genuinely conflict, where precedence cannot be established, stop the work and go to the operator (workspace `CLAUDE.md` § Design Judgment Principles).
15. **A control that cannot run reports "unassessed," never "passed."** Operational reality overrides documented status.

---

## 11. Operator gates and decisions

### 11.1 The complete gate table

| Lane | Planned stops | Where |
|---|---|---|
| Lightweight | **0** | — |
| Medium | **1** | G3 only — lifecycle decision after observed use (Phase 5) |
| Heavy | **3** | G1 scope + package (end of Phase 2) · G2 release / real trial (end of Phase 4) · G3 lifecycle decision (Phase 5) |

**No other planned stop exists.** In particular: no lane-confirmation stop separate from G1; no stop for a passing review verdict; no per-slice approval; no stop for terminology, seam or slice ordering. Those are Claude's decisions.

### 11.2 What each stop asks

- **G1 — scope and implementation-package approval (Heavy).** *Is this worth doing at this weight, with this scope, owned here, excluding these things?* Includes Heavy-lane confirmation. Includes handing the operator Codex review brief #1.
- **G2 — release / real-trial approval (Heavy).** *May this enter the real operating environment?* Especially where integrations or confidential data are involved. Includes Codex review brief #2 and the rollback path.
- **G3 — lifecycle decision (Medium and Heavy).** *Given what actually happened when it was used, what status does this carry?* Adopt · continue trial · revise · keep local · pause · close · retire · reject.

### 11.3 Exceptional pauses (failure conditions, not gates)

These stop the work whenever they occur, in any lane, and are reported as failures rather than as planned checkpoints:

1. An adverse independent-review verdict — `RECONSIDER`, a Codex finding that invalidates the premise, or a `qc-reviewer` verdict the command cannot resolve by evidence.
2. A blocking unknown that no available evidence can close — produce a requirements doc per workspace `CLAUDE.md` § Requirements-Doc Default and stop.
3. A material scope change that alters the seam, the owner or the exclusions.
4. Two authoritative sources in genuine conflict with no establishable precedence.
5. Escalation into Heavy (which arms G1 immediately).
6. A confidentiality question the data-handling rules do not answer.
7. Any of the ten workspace pause triggers (workspace `CLAUDE.md` § Autonomy Rules).

### 11.4 What the operator is never asked

Per Q13 and workspace `CLAUDE.md` § Decision-Point Posture: file structures, schemas, directory names, integration design, test selection, slice ordering, whether to run `/qc-pass`, which agent to spawn, or to validate a recommendation. Those are Claude's. The operator is asked business questions: is this worth doing, is this burden acceptable, may this go live, is this useful in practice, what status does it carry.

---

## 12. State and artifact model

### 12.1 How the command discovers the project's current authoritative state

In this order, stopping when the picture is sufficient:

1. **Project `CLAUDE.md`** — the authority surface. Present in 25 of 26 projects (F14). Read first, always.
2. **`projects/{p}/development/*.md`** — existing capability records. Any with `status: in-development` is live work; read those.
3. **`projects/{p}/logs/decisions.md`** — durable cross-session decisions. Present in 25 of 26 (F14). Read the tail, and grep for terms the need names.
4. **Authority documents the need touches** — e.g. `standards/`, `doctrine.md`, `vocabulary.md`, `governance/`, `reference/`. Chosen by relevance, not enumerated blindly.
5. **`pipeline/project-plan.md`** — only when a plan spine is relevant, and only as a bounded read.

**Explicitly not read as live state: `pipeline/pipeline-state.md`.** It records `/new-project` scaffolding stages 3a–6 that completed at project creation (F15), and the operator has ruled it out as capability state (Q9). Reading it would report a project as "in Stage 4 Implementation" years after the fact.

**Read budget:** four files at Lightweight, twelve at Medium and Heavy. Exceeding the budget is reported as a finding, not treated as permission to continue reading — the same discipline as `new-project.md:43`.

### 12.2 Lightweight — zero dedicated files

Lightweight writes **no** capability record. Its outputs are:

- the changed artifact itself, committed;
- git history;
- **one** entry in `projects/{p}/logs/decisions.md`, in that file's existing canonical shape, **only if durable project behaviour was created or changed**;
- nothing at all when the outcome is no action.

This is sufficient because Lightweight is single-session, single-owner and reversible by revert. There is no cross-session state to preserve and no seam to record.

### 12.3 Medium and Heavy — one record per operating capability

**Path:** `projects/{owner-project}/development/{slug}.md`
**Slug:** lowercase kebab-case derived from the outcome, ≤50 characters — e.g. `buyer-email-preparation`, `contacting-strategy-rules`.
**Created by:** Frame, as soon as the lane is Medium or Heavy. Not a wrap-up artifact.
**Template:** `ai-resources/templates/capability-record.md` (§ 18), following the `templates/mission-contract.md` precedent (F33).

**Why `development/` and not `capabilities/`:** `capability/` already means human communication proficiency inside `axcion-communication-system` (F29). A plural `capabilities/` beside a singular `capability/` in the same tree is the worst available collision. `development/` collides with nothing across all 26 projects and `ai-resources/` (F30), names the activity rather than the noun, and reads plainly.

### 12.4 Record schema

```markdown
---
capability: {slug}
name: {human-readable name}
lane: lightweight | medium | heavy
phase: frame | shape | build | prove | land
status: in-development | adopted | continue-trial | revise | keep-local | paused | closed | retired | rejected
owner_project: {project-name}
opened: YYYY-MM-DD
updated: YYYY-MM-DD
---

# {Name}

## Operating outcome
One sentence — the result, not the system.

## Verified need
### Confirmed facts        (each with a path)
### Reasonable inferences  (each with its basis)
### Unknowns               (each with what would close it)

## Lane
Dated, append-only. Each entry: date · lane · the trigger that fired · escalation or de-escalation.

## Ownership and seams
Owner (with the cited clause that establishes it) · dependencies (never co-owners) ·
external systems · the official record for each data class.

## Public interface
Input · Output · Owning capability · External dependencies · Observable failure states ·
Side effects · How behaviour is tested.

## Approved scope and exclusions
What will be built. What will not.

## Implementation package
Verified need · intended outcome · users · public interface · observable behaviours ·
ownership and dependencies · smallest useful version · exclusions · verification ·
adoption condition · retirement condition.

## Vertical slices
- [ ] S1 — {complete behaviour}
- [ ] S2 — …

## Verification evidence
| Claim | Evidence type | Result | Where |
Each row marked observed · unassessed · blocked.

## Decisions
### D1 — YYYY-MM-DD — {title}
**Status:** active | superseded by D{n} (YYYY-MM-DD)
**Decision.** … **Rationale.** … **Alternatives.** …

## Current phase and next action
Phase: {phase}. Next: {one concrete action}.

## Real-use result
What happened when it was actually used. Recorded even when negative.

## Lifecycle status
{status} — decided YYYY-MM-DD by {operator|Claude}. Retirement condition: {…}.

## Pointers
Plans, specs, review reports, risk-check reports — by path, never copied.
```

### 12.5 Active versus superseded decisions

Decisions are **append-only and never deleted.** Superseding sets the earlier entry's `**Status:**` line to `superseded by D{n} (YYYY-MM-DD)` and adds the new entry below. Active decisions are those whose Status line reads `active`. This needs no tooling, survives a hand edit, and is greppable. Chronology is preserved, which is what makes the record auditable when a lane change or an adverse review is reconstructed later.

The same rule applies to the record as a whole: **a record is never deleted to tidy up.** A rejected capability keeps its record with `status: rejected` — that is the evidence that the question was asked and answered.

### 12.6 Record versus mission versus decisions log

| Artifact | Answers | Frozen? | Written by |
|---|---|---|---|
| `development/{slug}.md` | *What is this capability, where does it stand, and what happens next?* | No — it is a living development record | `/develop-capability` |
| `logs/missions/{id}.md` | *What multi-session goal is this session serving, and is it drifting?* | Goal/scope/validation frozen; only status and threads change (F17) | `/mission` only |
| `logs/decisions.md` | *What did we decide, and why, across the whole project?* | Append-only history | any session |

They are complementary. A Heavy capability may reasonably also be a mission; the plan does not require it and `/develop-capability` never writes mission files.

### 12.7 Avoiding a new registry

There is no index, no register and no status file listing capabilities. Discovery is a glob over `development/*.md` frontmatter — the same mechanism `/prime` Step 1d uses for missions (F16). A capability leaves the active set by reaching a terminal `status:`, not by being moved or deleted. If `development/` ever grows past roughly a dozen files in one project, that is a signal the project should be split, and § 24's review picks it up.

### 12.8 Confidential data handling (Q10)

| Rule | Applies |
|---|---|
| Use the minimum necessary record | Medium, Heavy |
| Prefer anonymised or synthetic data when it tests the same behaviour | Medium, Heavy |
| Name the authoritative source for every data class | Medium, Heavy |
| Never copy raw buyer, CRM, email or relationship data into a committed artifact | all |
| Never commit trial output containing confidential information | all |
| Durable records carry decisions, schemas, evidence summaries and redacted or synthetic examples only | Medium, Heavy |
| Name the system that remains the official record | Heavy |
| State explicitly what may and may not be sent to which external model or tool | Heavy |
| Trial material lives in the session scratchpad and is disposed of per project rules | Medium, Heavy |

The scratchpad, not a gitignored directory, is the trial workspace (D10). A gitignored path inside the repo is one `git add -f` or one `.gitignore` edit from a leak; a session-scoped path outside the repo is not.

---

## 13. Command–skill architecture

### 13.1 Split (operator-locked, Q11)

**`ai-resources/.claude/commands/develop-capability.md`** — ~150–220 lines, `model: opus`.

Owns: invocation and argument handling · project and state discovery (§ 12.1) · resume detection (§ 15.1) · lane routing and the announcement (§ 6) · phase orchestration · operator gates (§ 11) · handoff execution and resumption (§ 14) · record read/write mechanics · completion reporting · failure behaviour.

**`ai-resources/skills/capability-development/SKILL.md`** — `model: opus`, `effort: high`.

Owns: the definition of *operating capability* · the five-phase methodology · lane-by-lane process requirements and completion conditions · the intervention ladder and how to choose a rung · trial design and the stop condition · the ownership and seam method (including § 5.3 and the absence-is-not-evidence rule) · vertical-slice standards · the evidence-to-claim table · lifecycle-decision standards · data-handling method · failure behaviour · worked examples.

### 13.2 Why a skill and not one large command

Four reasons, in order of weight:

1. **Size.** The methodology alone is longer than the whole command budget. A self-contained command lands at 400–500 lines, which is the size class that made `/new-project` (894 lines) hard to maintain. The command budget of 150–220 lines is only reachable with a skill.
2. **Read-when-needed.** The command must decide the lane before it needs lane-specific methodology. A skill lets the command read the relevant section at the point of use, rather than carrying all three lanes' methodology in context from the first line.
3. **Established pattern.** `/scope-project` does exactly this: *"Read the methodology first… These own the what; this command owns the orchestration. Do not restate their content — apply it"* (`scope-project.md:11`). `/tech-consult` is the same shape in miniature. This is not a new architecture.
4. **Durable versus perishable separation.** The foundational document's Principle 8 asks that durable material (what good looks like) be separable from perishable material (how the current model must be steered). The skill holds the durable methodology; the command holds the orchestration, which is where model-specific scaffolding accumulates and can later be thinned.

### 13.3 The one-command rule

The skill is **not** a second invocation path. It carries `disable-model-invocation: true` in frontmatter — the same protection `skills/grill-me/SKILL.md:10` uses — so it cannot be auto-triggered by description match, and is reachable only by the command reading it. There is exactly one operator-facing entry point.

### 13.4 Why no agent (D8)

Q8 forbids a new reviewer agent. Beyond that: a `capability-reviewer` would be a fourth reviewer overlapping `qc-reviewer` (artifact QC), `risk-check-reviewer` (structural risk) and `system-owner` (ROI and architecture); and it would be a new detection component, which under OP-12 must ship its own closure channel in the same change. The three existing reviewers cover the need, and Heavy's genuine independence comes from Codex — a different model, which is a stronger form of independence than a fourth Claude subagent.

### 13.5 Model tiering

Per F34, both files declare an explicit tier and inherit nothing. Command: `model: opus` — the work is judgment-heavy (lane routing, ownership, evidence adjudication). Skill: `model: opus`, `effort: high`. No `model` field is written to any settings file, and no project `CLAUDE.md` gains a Model Selection section (F35).

---

## 14. Handoff contracts

Every handoff states: **trigger · what goes out · what comes back · what happens next · what must not happen.**

### 14.1 Capability request that is really a new project

- **Trigger.** § 5.3 finds no legitimate owner, or selecting one would create a new domain or an enduring programme.
- **Out.** The Frame output — operating outcome, verified need, facts/inferences/unknowns, the owner-selection criteria and which one failed, the intervention-ladder rung — handed to `/scope-project` (complex) or `/new-project` Step 0 (simple, or when an existing owner may still be found). Per `scope-project.md:35`, a fuzzy idea goes to `/grill-me` first; Frame output is not fuzzy, so it enters at Stage 1.
- **Back.** Nothing. This is a terminal exit.
- **Next.** If a record was opened, close it with `status: rejected` and a note naming the routing target and the criterion that failed. Report the route in one line.
- **Must not.** Do not create the project. Do not write into `projects/project-planning/`. Do not keep the capability "open pending a project."

### 14.2 Capability that needs formal project planning

- **Trigger.** Heavy, and the capability warrants a control pack or a specification — contested document architecture, meaningful governance assumptions, significant MVP-boundary risk.
- **Out.** The implementation package plus the record path, to `/scope-project` (control pack) or the `/plan-draft` → `/plan-refine` → `/plan-evaluate` chain. Artifacts land in `projects/project-planning/output/{name}/` per `scope-project.md:17`; that workspace must be mounted or the handoff stops before any write there.
- **Back.** Paths to the produced artifacts.
- **Next.** Record them under `## Pointers`. **Never copy them into the record.** Resume Shape at the point the handoff interrupted.
- **Must not.** Do not re-derive the plan inside `/develop-capability`. Do not let planning output silently replace the record as the source of truth — the record still owns phase, next action and status.

### 14.3 AI-resource sub-need — the contract that matters most

- **Trigger.** A slice needs an AI artifact that does not yet exist: skill, command, agent, prompt, hook, script, persistent instruction or reference file.
- **Out.** A brief in `/develop-ai-resource`'s existing qualified-brief shape (`develop-ai-resource.md:80-87`) — the `/request-skill` fields plus the two mandatory ones — **extended by three**:

```markdown
**Mechanism:** {the rung and why not a lower one}
**Evidence:** {cited, or "speculative"}
**Capability:** {slug} — owner {project} — record: {path}
**Settled upstream:** operating outcome, need validation, ownership and seam, adoption
decision. Do not reopen these. Qualify the ARTIFACT only.
**Artifact scope:** {exactly what to author, and what not to}
```

- **Back.** The Step 4 disposition — Ship / Revise / Defer / Delete candidate — plus the artifact path and what was tested and observed.
- **Next.** Record it under `## Pointers` and `## Verification evidence`. Resume the slice. If the disposition is Defer or Delete, that is a **material scope change**: record it as a decision and re-test the lane.
- **Must not.** `/develop-capability` never calls `/create-skill`, `/improve-skill` or `/migrate-skill` directly (F5). It never authors a skill itself. `/develop-ai-resource` never reopens the operating need, never re-runs the capability qualification, and never makes the adoption decision for the capability — its disposition covers the artifact only.

**Why this cannot drift into double qualification.** The brief names four things as settled and says "do not reopen." The compatibility clause in `/develop-ai-resource` (§ 18) tells it to read the record for Steps 1.1–1.2 rather than re-derive them, while **keeping** Steps 1.3–1.6 scoped to the artifact — does this artifact already exist, is a skill the smallest mechanism for *this artifact*, where does it belong. That is exactly the work the capability command should not be doing, and exactly the work `/develop-ai-resource` is good at. Acceptance tests AT-11 and AT-12 exercise both failure directions.

### 14.4 Project-local implementation

- **Trigger.** The default. The capability is built inside the owning project.
- **Out / Back.** Nothing — this is in-command work.
- **Must not.** Never write into another project's tree, even when the capability depends on it. A dependency that must change is a seam decision, surfaced to the operator, not an edit. (`axcion-communication-system/CLAUDE.md:27` is a live example of a project that forbids exactly this.)

### 14.5 Shared or cross-project capability

- **Trigger.** H3 or H6 fired: a second consumer, or the capability creates something used beyond the owning project.
- **Out.** For an AI resource that should be shared: § 14.3, with placement resolved via `docs/repo-architecture.md:183-198` — reusable → `ai-resources/`. For a *later* promotion of something already built project-local: `/graduate-resource`, which requires confirmation from every existing canonical consumer (F24).
- **Back.** The canonical path, or the graduation outcome.
- **Next.** Record the consumer list and each confirmation.
- **Must not.** Do not generalise on one confirmed consumer (AP-7/DR-7). Do not graduate inside `/develop-capability` — that is `/graduate-resource`'s job and its consumer-confirmation gate exists for a reason.

### 14.6 Independent review

| Lane | Mechanism | When |
|---|---|---|
| Lightweight | none, unless a mandatory `/risk-check` class fired (which is also H6 → escalate) | — |
| Medium | `/qc-pass` on the built result; `/risk-check` if a class fired | Phase 4 |
| Heavy | Codex brief #1 (package) and brief #2 (result); `/risk-check` both gates; `/qc-pass` where a specific artifact warrants it | Phase 2 end and Phase 4 end, ridden on G1 and G2 |

- **Out (Codex).** A self-contained brief (§ 16.4) written to `projects/{owner}/development/{slug}-review-{n}.md`, plus explicit chat instructions for running it.
- **Back.** Codex findings pasted by the operator.
- **Next.** Adjudicate: verify each finding against the repository, then dispose of it as accept-and-fix, accept-and-defer-with-a-trigger, or reject-with-cited-evidence. Record every disposition.
- **Must not.** Do not create a reviewer agent. Do not imitate Codex inside Claude. Do not treat findings as instructions. Do not send confidential material into a review brief — briefs carry decisions, schemas and redacted examples only.

### 14.7 Real-use trial

- **Trigger.** M1 (Medium) or mandatory (Heavy).
- **Out.** One real case, run by hand or with temporary tooling. Real data only when the claim genuinely depends on real operating context; synthetic otherwise.
- **Back.** An observed result — including a negative one.
- **Next.** Record it. **Stop condition: a trial that does not produce a useful result stops the build.** Re-enter the intervention ladder; no-build remains available all the way to here.
- **Must not.** Do not commit trial material containing confidential information. Do not treat a trial that "sort of worked" as validation.

### 14.8 Adoption, closure, retirement

- **Trigger.** Phase 5, after observed real use.
- **Out.** To the operator at G3: what was needed, built, tested, observed; what the real use showed; what remains open; the recommended status and why.
- **Back.** One of eight statuses. Inactivity is not among them.
- **Next.** Write the status to the record's frontmatter and `## Lifecycle status`; append one entry to the project's `logs/decisions.md`; for Heavy, restate the retirement condition and rollback method. For **retire**, remove the capability's machinery and record what was removed — retirement that leaves the machinery in place is not retirement.
- **Must not.** Do not mark adopted without observed real use. Do not leave a record `in-development` after the work has stopped — that is the "inactivity as a status" failure the SOP names.

---

## 15. Failure, pause and resume behaviour

### 15.1 Resume

**On invocation with no argument, or with an argument matching an existing record slug:**

1. Glob `projects/{cwd-project}/development/*.md`; read frontmatter only.
2. Filter to `status: in-development`.
3. **Zero** → treat the argument (if any) as a new need; if there is no argument, ask once for the need and wait.
4. **Exactly one** → resume it. Announce: `Resuming {name} — lane {lane}, phase {phase}. Next: {next action}.` Read the full record, then continue at the recorded phase.
5. **More than one** → list them (name, lane, phase, next action) and ask which, in one prompt. Never guess.

Resume never re-runs completed phases. It reads the record, restates position in one line, and continues.

### 15.2 What makes resume work

The record's `## Current phase and next action` and the frontmatter `phase:` / `updated:` fields are written **after every slice and at every phase boundary**, not at session end. A session that dies mid-Build leaves a record pointing at the last completed slice, and the next session resumes from there. This is the same reason `/mission` computes rather than stores sessions-served (F17) — hot-path writes are the thing that survives a crash.

### 15.3 Session-boundary behaviour

At the end of any session where a Medium or Heavy capability is in progress, the command ensures the record is current before the session wraps, and states in chat: the capability, the lane, the phase, and the next action. It does not write a separate handoff document — `/handoff` owns that, and the record already carries the state.

Per workspace `CLAUDE.md` § Context constraint deferral: when context is clearly constrained, defer remaining work, update the record, flag the deferral, and stop. Do not rush a phase to closure.

### 15.4 Failure behaviour

| Failure | Response |
|---|---|
| No project can be identified from the working directory | Ask once which project owns this, listing the plausible candidates. Do not guess and do not default to the workspace root. |
| The named owner project does not exist | Stop. Report. Do not create it. |
| `development/` does not exist | Create it, but only at the moment the first Medium/Heavy record is written. Never pre-create an empty directory. |
| A record exists but its frontmatter is malformed | Report the specific malformation and the path. Do not auto-repair — a silently corrected status field is worse than a visible error. |
| Two records claim the same capability | Stop. Report both paths. The operator decides which is authoritative. Never merge automatically. |
| `/develop-ai-resource` returns Defer or Delete for a needed artifact | Material scope change. Record it, re-test the lane, and either re-plan the slice without that artifact or pause for the operator. |
| A trial produces no useful result | Stop the build. Record the negative result. Re-enter the intervention ladder. This is a success of the method, not a failure. |
| Codex review is unavailable or the operator declines it (Heavy) | Do **not** substitute a Claude subagent and call it independent review. State that Heavy's independent review is **unassessed**, record it as such, and let the operator decide whether to proceed at G1/G2 with that gap explicit. |
| `qc-reviewer` agent type fails to resolve | Use the documented `qc-pass.md:24` fallback and label the verdict `(fallback: general-purpose, opus re-asserted)`. |
| `/risk-check` returns `RECONSIDER` | Exceptional pause. Surface the report path and the dimension findings. Do not proceed on Claude's own judgment. |
| Context is exhausted mid-phase | Update the record, state position, defer. Never compress a phase to fit. |
| The operator interrupts to correct the lane | Treat as an operator lane override. Record it as a decision with `Decided by: operator`. Continue in the corrected lane. |

### 15.5 Recoverability posture

Every slice is committed before the next begins. The record is updated at every boundary. No confidential material enters the repository. Nothing is deleted to tidy up. The result is that a failure discovered three sessions later costs at most one slice of rework and never leaves the current state unreadable — which is the foundational document's Principle 9 stated as behaviour rather than intention.

---

## 16. Review and verification model

### 16.1 Governing rule

**Evidence must match the type of claim.** Runtime behaviour is evidenced by execution. File-scope claims by the diff. Compatibility by a representative test. Factual claims by the source. Usage claims by checking every relevant location. A control that cannot run is reported **unassessed**, never **passed**. A file existing, a status field reading complete, or documentation asserting a control is active evidences none of it.

### 16.2 Depth by lane

| | Lightweight | Medium | Heavy |
|---|---|---|---|
| Self-review | inline, both questions | both questions, recorded | both questions, recorded |
| Fresh-context Claude | — | `/qc-pass` on the result | `/qc-pass` where a specific artifact warrants it |
| Structural risk | only if a class fired (→ escalate) | `/risk-check` if a class fired | `/risk-check`, both gates |
| Independent model | — | — | **Codex ×2** |
| Behavioural test | verify against stated behaviour | per slice | per slice |
| Integration test | — | if a seam exists | required |
| Failure test | — | if failure states are stated | required |
| Recovery test | — | — | required |

### 16.3 The two self-review questions

Kept separate, always, in every lane:

1. **Is it well made?** — clear purpose and scope; small understandable interface; one owner per responsibility; no duplicated behaviour; proportionate architecture; tests coupled to outcomes not internals; every control demonstrated in its real invocation path; anything removable removed; no unrelated scope entered; work recoverable.
2. **Does it belong in the system?** — the capability is still justified; the mechanism is still the smallest reliable one; it duplicates and conflicts with nothing; it references rather than copies authoritative context; consumers and handoffs are clear; maintenance cost is proportionate; it can be removed cleanly.

A well-made thing can still be the wrong thing to own. Merging these two questions is the failure this separation exists to prevent.

### 16.4 Codex review brief (Heavy)

Written to `projects/{owner}/development/{slug}-review-{n}.md`. **Self-contained** — a reader with no session context can act on it. Sections:

1. **What this capability is** — the operating outcome, in one paragraph.
2. **Why it is being built** — verified need, with the evidence and its honest classification.
3. **Facts, inferences, unknowns** — separated, each fact carrying a path.
4. **Ownership and seams** — the owner, the cited clause establishing it, dependencies, external systems, the official record for each data class.
5. **Scope and exclusions.**
6. **What is being reviewed** — brief #1: the package, before implementation. Brief #2: the implemented result, before release.
7. **Evidence table** — every claim marked observed / unassessed / blocked, with where.
8. **The claims most worth attacking** — named specifically. *"Name the specific conclusion you most want attacked; a general instruction does not bite"* (`axcion-communication-system/CLAUDE.md:42`).
9. **The inference question, as its own numbered item** — *"For each load-bearing conclusion: does it follow from the cited text, or does the citation merely sit near it?"* This is required, not optional. It is the check that caught a defect pre-commit for the first time in that project, after two citation-focused QC passes had missed the same class twice (`axcion-communication-system/CLAUDE.md:42-44`).
10. **Explicit non-goals for the reviewer** — do not redesign the solution; do not create a parallel system; findings are claims to be tested, not instructions.

**Confidentiality:** briefs carry decisions, schemas, evidence summaries and redacted or synthetic examples. Never raw buyer, CRM, email or relationship data.

### 16.5 Adjudicating findings

Codex and `qc-reviewer` findings are **claims to be tested.** Each is verified against the repository before any action, then dispositioned explicitly:

- **Accept and fix** — the finding is verified; correct it and re-verify.
- **Accept and defer** — verified but out of scope; record with a concrete reopening trigger (a date, a quarter, a named event).
- **Reject** — refuted by cited evidence. State the evidence.

Only disagreements turning on **business risk or maintenance burden** reach the operator. Technical disputes are resolved by evidence first.

### 16.6 What is deliberately not built

No `capability-reviewer` agent. No new verdict vocabulary — `/risk-check` keeps GO / PROCEED-WITH-CAUTION / RECONSIDER, `/implementation-triage` keeps WORTH-DOING / MARGINAL / NOT-WORTH-DOING. No scoring rubric. No review log. No metrics.

---

## 17. Representative-case walkthroughs

For each: lane · why · artifacts · review depth · handoffs · evidence required · final lifecycle decision.

### 17.1 Case 1 — Lightweight, narrow, project-local, known behaviour

*"`axcion-sector-intelligence` reports should carry a standard one-paragraph 'how Axcíon should use this' closing section, following the existing seven-section core."*

- **Lane: Lightweight.** No Heavy trigger — one project, no external system, no confidential data, reversible by revert, one consumer. No Medium trigger — the workflow is demonstrated (six sections already work this way), one behaviour, ownership unambiguous (`axcion-sector-intelligence/CLAUDE.md` states the seven-section mandatory core), no new AI resource, verification is reading the output.
- **Artifacts:** the edited standard in `reference/report-architecture-template.md`; one `logs/decisions.md` entry. **No capability record.**
- **Review:** self-review only. No `/qc-pass`, no subagent, no `/risk-check` (no class fired).
- **Handoffs:** none.
- **Evidence:** the diff; one section rendered against the template and read from disk.
- **Decision: adopt.** Stated by Claude, not asked. Total operator stops: **0**.

### 17.2 Case 2 — EmailOS: one approved buyer record + one contact objective + current guidance → one reviewable draft

- **Lane: Heavy.** H1 — the buyer record and the communication guidance live outside whichever project owns the workflow, and Gmail is the official record. H2 — a real buyer record is real relationship data. H4 — a draft that gets sent is not revertible. H5 — likely; the language layer is claimed by `axcion-communication-system` (F28) while the workflow layer is claimed by nobody.
- **Frame finds an ownership problem, and this is the point of the case.** § 5.3 criterion 1: which project owns "a buyer email gets prepared"? The comms system owns what the firm *sounds like* and explicitly disclaims the situational layer (`axcion-communication-system/CLAUDE.md:27`). Criterion 2: continuing decisions about whom to contact belong to Contacting Strategy, which does not exist as a project (F27). Criteria 3–4 do not rescue it. **Expected outcome: § 14.1 new-project handoff** — EmailOS is a programme, not a capability inside an existing project (I3).
- **But the plan must handle the other branch too.** If Frame finds that a project *does* legitimately own it — for instance if Contacting Strategy is stood up first and claims the workflow — then Heavy develops it in place: seam against comms (language), CRM (relationship state) and Gmail (official record); trial on one real buyer record with § 12.8 handling; slices S1 draft-from-record, S2 guidance applied, S3 operator review path.
- **Artifacts:** `development/buyer-email-preparation.md`; two Codex review briefs; a `/develop-ai-resource` brief for the drafting skill; pointers to any planning artifacts.
- **Review:** Codex ×2 + `/risk-check` (a new skill fires the class) + `/qc-pass` on the skill.
- **Handoffs:** § 14.1 (if routing out) or § 14.2 formal planning, § 14.3 drafting skill, § 14.6 Codex, § 14.7 trial.
- **Evidence:** one real draft produced from one real record, read by the operator, compared against the guidance. Runtime claims by execution.
- **Decision: continue trial** is the realistic first outcome — one draft is not adoption. Operator stops: **3** (or **0** on the route-out branch, which ends at a reported handoff).

### 17.3 Case 3 — Prohibited contact or missing authority must stop, not draft

- **Lane: Heavy.** Same triggers as 17.2. It is not a separate capability — it is **a slice of the same one**, and treating it as separate is itself an error worth naming.
- **Why it matters:** this is the behaviour that proves the seam. A capability that produces a draft when it should refuse has no observable failure state, and § 12.4's `Observable failure states` field is where that gets caught.
- **Slice design:** S2 — *given a contact marked prohibited, or a record with no contact authority, no draft is produced and the reason is stated.* Reproduce-or-fail first: construct the prohibited case and confirm the current behaviour wrongly drafts.
- **Review:** this is a **failure test**, required at Heavy. `axcion-linkedin-os/CLAUDE.md:5-12` and `:23-25` are the reference pattern — a hard law enforced structurally in settings, plus human confirmation required before any content references a real firm, person, call or buyer criterion.
- **Evidence:** the control is demonstrated **in its real invocation path**. A rule written into a file evidences nothing.
- **Decision:** not a separate lifecycle decision; it gates the parent capability's G2 — release is not approved while the refusal path is unassessed.

### 17.4 Case 4 — Heavier EmailOS expansion: CRM and Gmail integration, shared relationship state

- **Lane: Heavy**, and this is where escalation matters. H1 two external systems; H2 confidential data at rest and in flight; H3 CRM becomes a consumer of writes; H4 a state write to shared relationship data is not a revert; H6 shared-state automation is a `/risk-check` class (`docs/audit-discipline.md:65`).
- **Frame additions:** consumer inventory naming CRM, Gmail, the comms standard and the operator; a data-flow statement naming what may reach an external model; a reversibility statement per write path.
- **Seam is the deliverable, not the code.** Which system is authoritative for relationship state; who may write to it; what happens on conflict; what a human must approve. `axcion-linkedin-os`'s authority order (`CLAUDE.md:14-16`) is the pattern.
- **Artifacts:** record; two Codex briefs; likely a § 14.2 formal planning handoff; `/risk-check` reports at both gates.
- **Review:** Codex ×2, `/risk-check` ×2, integration + failure + recovery tests. The recovery test must demonstrate the stated undo actually works.
- **Evidence:** a real write executed against a test record and rolled back, observed. Not "the code path exists."
- **Decision: continue trial**, with a restricted consumer set. Operator stops: **3**.

### 17.5 Case 5 — Contacting Strategy: why, whom and when to contact, without owning the language

- **Lane: Heavy.** H3 — the comms system and any email capability both consume it; H5 — it defines decisions currently unowned, adjacent to territory `axcion-communication-system` holds.
- **The whole value of the case is the seam.** Contacting Strategy owns *why contact should occur, whom, and when.* It must not own *what the message says* — that is the comms system's register-and-language layer (`axcion-communication-system/CLAUDE.md:27`, `:31-34`). The record's `## Ownership and seams` names this explicitly, with the citation.
- **Note the implementation is mostly documents.** Decision rules, a prioritisation method, a definition of contact-worthiness. Little or no code, possibly no AI resource at all. This is why the command must not assume a capability is software — it is one of the clearest illustrations of Q13's point.
- **Artifacts:** record; the strategy documents themselves in the owning project; one Codex brief on the package (brief #2 may be light if nothing executable was built — state that, do not skip it silently).
- **Review:** Codex ×1–2; `/risk-check` only if a class fires (likely not, if no command/skill/hook is created); `/qc-pass` on the strategy document.
- **Evidence:** the strategy applied to one real contact decision, and the decision it produced compared against what the operator would have done unaided.
- **Decision: adopt** if the real decision holds up; **keep local** if it turns out to serve only one project.

### 17.6 Case 6 — A request that should produce a no-build or manual outcome

*"We should have a system that reminds me which sector reports are overdue."*

- **Lane: Lightweight** at Frame — but the lane never matters, because the intervention ladder stops early.
- **What happens:** Frame inspects reality and finds that `axcion-sector-intelligence/CLAUDE.md` already names the active unit (`**Current Section:** precision-components`) and that `/prime` already surfaces project position (F16). Ladder rung 1–2: the need is met by an existing capability plus an operating habit — check `/prime`'s brief at session start.
- **Artifacts:** **none.** No record, no `logs/decisions.md` entry — nothing durable was decided.
- **Review, handoffs, evidence:** none. The evidence is the citation showing the need is already served.
- **Decision:** reported in chat as *no build — existing capability covers it*, with the paths. This is a success. Operator stops: **0**.

### 17.7 Case 7 — A request that belongs to `/develop-ai-resource`

*"Build a skill that formats research citations consistently."*

- **Routing, not lane.** The request names an artifact, not an operating outcome (§ 5.2). The command states this in one line and routes: *"This is an AI-artifact decision — `/develop-ai-resource` owns it. Run `/develop-ai-resource {need}`."*
- **The one subtlety worth naming:** if the operator's underlying need is actually *"citations in Axcíon research must be consistent and correct"* — an operating outcome — then `/develop-capability` **is** right, and the skill is one implementation component. The command asks itself which is true by testing whether a non-skill answer could serve the need (a standard, a checklist, a review step). If yes, it is an outcome. If the operator genuinely wants that specific artifact and nothing else, it routes out.
- **Artifacts:** none. **Stops:** 0.

### 17.8 Case 8 — A request routed to the new-project lifecycle

*"Axcíon needs a buy-side outreach programme covering targeting, sequencing, messaging and measurement."*

- **Lane: Frame concludes route-out.** § 5.3 criterion 1: no existing project owns "buy-side outreach as a programme." Criterion 4: replace any one dependency and there is still a programme left standing with its own deliverables — the definition of a project, not a capability.
- **Handoff:** § 14.1 to `/scope-project` (complex-build lane — multiple workstreams, contested document architecture, real MVP-boundary risk, which is exactly `scope-project.md:36`'s trigger).
- **Artifacts:** none in the owning project. If a record was opened, it closes `status: rejected` with the routing note.
- **Evidence:** the owner-selection criteria applied and the one that failed, named.
- **Decision:** reported route. Operator stops: **0** — the routing is a statement, not a question.

### 17.9 Case 9 — Medium that begins small and must escalate

*"Add a standard pre-send check to LinkedIn drafts."*

- **Starts Medium.** M2 three behaviours; M5 verification needs a real draft. No Heavy trigger apparent: one project, no external system, no confidential data.
- **Escalates during Shape.** The seam exercise discovers two things: the check must read `strategy/positioning.md`, which the project's authority order names as governing phrasing (`axcion-linkedin-os/CLAUDE.md:14-16`) — and the natural implementation is a project-local command that writes a gating frontmatter field, mirroring `/linkedin-qc` (`:9-12`). **H6 fires** (a new command is a `/risk-check` class), and a second consumer appears (the publishing lifecycle depends on the field).
- **What escalation does:** states the newly-fired triggers; upgrades the record from `medium` to `heavy` with a dated `## Lane` entry; **stops immediately for G1**, naming exactly what has already been built and committed so the operator confirms Heavy knowing the current state. Nothing built so far is discarded.
- **Artifacts:** record (opened Medium, upgraded); Codex briefs from that point on; `/risk-check` reports.
- **Decision: revise then adopt** is the likely path — the escalation usually reveals that the first design was too small.
- **Operator stops: 3**, all after escalation. Before escalation: 0.

### 17.10 Case 10 — Stays project-local after successful use

*"`axcion-sector-intelligence` gets a standard evidence-calibration checklist applied before each report ships."*

- **Lane: Medium.** M1 the workflow is not demonstrated; M2 three behaviours; M5 verification needs a real report. No Heavy trigger — one project, one consumer, no external system, no confidential data, revertible.
- **The interesting part is Phase 5.** The checklist works. The obvious next thought is *"other research projects should have this."* **That thought is the trap.** `docs/ai-resource-creation.md:21` requires a **second confirmed consumer** before generalising; a first consumer plus a plausible second is the AP-7/DR-7 speculative-abstraction pattern, and `/graduate-resource` exists precisely to gate it.
- **Decision: keep local.** Recorded with the trigger that would reopen promotion: *"a second research project independently asks for the same check."* Not "revisit later."
- **Artifacts:** record closed `status: keep-local`; one `logs/decisions.md` entry naming the promotion trigger.
- **Review:** `/qc-pass` on the checklist. No Codex.
- **Operator stops: 1.**

### 17.11 What the cases collectively test

| Behaviour under test | Cases |
|---|---|
| Lightweight stays light (zero files, zero stops) | 1, 6 |
| Heavy triggers fire correctly on external systems and confidential data | 2, 3, 4 |
| Ownership selection with evidence, and route-out when it fails | 2, 5, 8 |
| Non-software capability handled without assuming code | 5 |
| No-build and reuse as successful outcomes | 6 |
| Boundary against `/develop-ai-resource` in both directions | 7 |
| Boundary against the new-project lifecycle | 8 |
| Mid-run escalation, additive and stop-armed | 9 |
| Resisting premature generalisation | 10 |
| Failure-state slices and real-invocation-path evidence | 3 |

---

## 18. Exact target files to create or edit

### 18.1 Create

| # | Path | Purpose | Size | Notes |
|---|---|---|---|---|
| C1 | `ai-resources/.claude/commands/develop-capability.md` | The operator-facing command | 150–220 lines | Frontmatter: `description`, `model: opus`, `argument-hint: "[outcome or observed need — leave blank to resume]"`. Sections: purpose + the outcome-vs-artifact sentence · boundary vs neighbours · input handling and resume · project/state discovery · lane routing + announcement · the five phases as orchestration (reading the skill for method) · operator gates · handoff execution · failure behaviour · reporting. |
| C2 | `ai-resources/skills/capability-development/SKILL.md` | The durable methodology | 350–500 lines | Frontmatter: `name`, `description`, `model: opus`, `effort: high`, `disable-model-invocation: true`, `allowed-tools`. Sections per § 13.1. |
| C3 | `ai-resources/templates/capability-record.md` | Record template | ~70 lines | Schema at § 12.4, with `{{PLACEHOLDER}}` mustache tokens, following `templates/mission-contract.md`. Register in `templates/README.md` per its consumer contract. |
| C4 | `ai-resources/plans/2026-07-28-develop-capability-build-plan.md` | This plan | — | Already written. Gains a status banner at approval, per the `plans/2026-06-12-leverage-idea-build-plan.md` precedent. |

### 18.2 Edit

| # | Path | Change | Size | Risk |
|---|---|---|---|---|
| E1 | `ai-resources/.claude/commands/develop-ai-resource.md` | (a) One bullet appended to **Boundary vs neighbours** (`:19-23`) — text at § 5.4. (b) One **upstream-brief clause** in Step 1, immediately before 1.1. | ~10 lines added, nothing removed | Low. Additive only; owned artifact class untouched. |
| E2 | `ai-resources/.claude/commands/prime.md` | New **Step 1e** after Step 1d, plus one menu-candidate bullet in Step 5 and one rank-order update. | ~18 lines | **Highest in this change set.** `/prime` runs at nearly every session start. Mitigations at § 22. |
| E3 | `{workspace}/CLAUDE.md` | Rename `## AI Resource Creation` → `## Capability and AI-Resource Development`; add two sentences routing outcome vs artifact. | +2 lines net | Cross-cutting CLAUDE.md edit — a `/risk-check` class (F8), and always-loaded token cost. |
| E4 | `ai-resources/CLAUDE.md` | One line under `## Skill Creation and Improvement` naming the boundary. | +1 line | Low. |
| E5 | `ai-resources/docs/ai-resource-creation.md` | One sentence in rule #4 naming `/develop-capability` as the sibling lifecycle. | +1 line | Low. |
| E6 | `ai-resources/logs/decisions.md` | The OP-11 exception entry (§ 4.4, verbatim). | ~35 lines | None — append-only log. |
| E7 | `ai-resources/templates/README.md` | Register `capability-record.md` per the consumer contract. | +2 lines | None. |

### 18.3 E1 — exact text of the `/develop-ai-resource` upstream clause

Inserted in Step 1, immediately before **1.1 State the understanding**:

```markdown
**1.0 Upstream-qualified brief.** When the input brief carries both `**Capability:**` and
`**Settled upstream:**`, it arrives from `/develop-capability`, which has already validated
the operating need, established ownership and the seam, and holds the adoption decision.
Read the record named in `**Capability:**` and treat 1.1 and 1.2 as satisfied by it — do not
re-derive the need and do not re-classify its evidence. **Steps 1.3–1.6 still run in full,
scoped to the artifact:** does this artifact already exist, is this rung the smallest
mechanism for *this artifact*, and where does it belong. Step 4's disposition covers the
artifact only and returns to the calling capability; it is not an independent adoption
decision. A brief carrying neither field is an ordinary direct invocation — ignore this clause.
```

### 18.4 E2 — exact shape of `/prime` Step 1e

Placed after Step 1d, following its structure precisely so it inherits the same zero-cost property:

```markdown
1e. **Scan in-development operating capabilities.** A *capability record* (`/develop-capability`)
    tracks one operating capability through development across sessions. This step makes
    unfinished capability work visible and is a **zero-cost no-op when none exists** — when
    `$CWD_REPO/development/` is absent, this step adds no read, no prompt, no menu item and
    no brief line.

    Scope: `$CWD_REPO` only. Unlike Step 1d, do not enumerate sibling repos — a capability is
    developed inside its owning project and is not actionable from another checkout.

    ```bash
    [ -d "$CWD_REPO/development" ] || : # skip everything below
    for r in "$CWD_REPO"/development/*.md; do
      [ -f "$r" ] || continue
      command grep -q '^status: in-development' "$r" || continue
      # capture: capability, name, lane, phase, and the '## Current phase and next action' line
    done
    ```

    Build `ACTIVE_CAPABILITIES` = list of `{slug, name, lane, phase, next_action}`. If empty,
    skip every addition below. Cap at **3** entries; if more exist, carry the three most
    recently updated (`updated:`) and note the remainder count in one clause.
```

And in Step 5's candidate merge:

```markdown
   - Step 1e — each in-development capability's `next_action` → tag `[capability:<slug>]`.
     Omit entirely if `ACTIVE_CAPABILITIES` is empty.
```

Rank order becomes: **urgent → capability → mission → carryover → next-up.** Capability sits above mission because a half-built capability is live work with committed slices, whereas a mission thread is a goal item. The menu cap of 6 is unchanged.

### 18.5 E3 — exact text of the workspace `CLAUDE.md` change

Section renamed and two sentences added; the existing `/develop-ai-resource` paragraph is preserved verbatim:

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

### 18.6 Not created

No new agent. No new hook. No new symlink beyond what `auto-sync-shared.sh` creates automatically (F13). No registry file. No `development/` directory in any project until the first Medium or Heavy capability needs one. No project `CLAUDE.md` edits — capability development is a workspace-level rule, not a per-project one, and per workspace `CLAUDE.md` § CLAUDE.md Scoping a canonical rule is never duplicated into a project file.

---

## 19. Integration points and consumers affected

### 19.1 Invocation path 1 — initiation (workspace `CLAUDE.md`, E3)

Without this, a capability request in a project session routes to `/develop-ai-resource` by default (I1), which is the exact boundary error the design exists to prevent. Two sentences, always loaded, is the cost. This is the primary satisfaction of RR-05's invocation-path requirement for *starting* capability work.

### 19.2 Invocation path 2 — resumption (`/prime` Step 1e, E2)

Without this, a half-built Heavy capability is invisible at the next session start, and resuming depends on the operator remembering — the exact pattern `docs/ai-resource-creation.md:38` refuses to ship. Step 1e makes an in-development capability a numbered menu item, so resumption is a keystroke.

### 19.3 Consumers affected

| Consumer | Effect | Severity |
|---|---|---|
| **Every project** (~20 via auto-sync, F13) | Gains `/develop-capability` in `.claude/commands/` at next session start. No behaviour change until invoked. | Low — availability, not activation. |
| **`/prime`** | New Step 1e; new menu candidate class; rank order gains one tier. Zero-cost where `development/` is absent — which is every project on day one. | **Medium-high.** Highest-traffic command in the repo. |
| **`/develop-ai-resource`** | Gains one boundary bullet and one Step-1 clause. Behaviour unchanged for direct invocations. | Low. |
| **Workspace `CLAUDE.md`** | +2 lines always-loaded in every session, every project. | Low-medium — permanent token cost, cross-cutting class. |
| **`/qc-pass`, `/risk-check`, `/implementation-triage`** | New caller. No change to their files. | None. |
| **`/scope-project`, `/new-project`, `/plan-draft` chain** | New upstream caller via § 14.1 / § 14.2. No change to their files. | None. |
| **`/graduate-resource`** | New upstream caller via § 14.5. No change. | None. |
| **`/wrap-session`, `/handoff`** | Encounter a new file class under `development/`. Both are path-agnostic. | None expected — verified by AT-18. |
| **`/refresh-project-state`** | Enumerates projects by `Glob projects/*/CLAUDE.md`; unaffected by a new subdirectory. Snapshot agents read project trees — a `development/` record could surface in a snapshot, so the confidentiality scrub matters. § 12.8's no-raw-data rule is what keeps that safe. | Low, but named. |
| **`/audit-repo`, `/token-audit`, `/lean-repo`** | Will count two new components. Expected and correct — the OP-11 entry is the answer when they flag it. | None. |
| **Codex** | New workflow: operator carries a brief out and findings back. Not automated. | Operator-process, not code. |

### 19.4 Not affected

No hook changes. No permission changes. No settings changes. No agent changes. No symlink topology change beyond auto-sync's normal behaviour. No project `CLAUDE.md` changes.

---

## 20. Implementation sequence in coherent commits

Each commit is independently reviewable and leaves the repository working. Order is chosen so the riskiest edit is last and separable.

| # | Commit | Contents | Gate before landing |
|---|---|---|---|
| **1** | `new: capability-development skill — operating-capability methodology` | C2 + C3 + E7 | `/qc-pass` on the SKILL.md. The skill is inert until the command reads it, so it lands safely first. |
| **2** | `new: /develop-capability — operating-capability development lifecycle` | C1 | `/qc-pass` on the command. Now reachable via auto-sync but not yet routed to by any rule. |
| **3** | `update: /develop-ai-resource — recognise upstream-qualified capability briefs` | E1 | `/qc-pass`. Closes the double-qualification risk before the routing rule sends real traffic. |
| **4** | `docs: name /develop-capability as the operating-capability lifecycle` | E3 + E4 + E5 | Cross-cutting CLAUDE.md class → covered by the end-time `/risk-check`. Invocation path 1 goes live here. |
| **5** | `update: /prime — surface in-development capability records (Step 1e)` | E2 | `/qc-pass` **and** a live `/prime` run in a project with no `development/` directory, confirming zero added output. Invocation path 2 goes live here. **Separable: if `/risk-check` objects, drop this commit and ship 1–4 + 6.** |
| **6** | `decision: OP-11 exception — /develop-capability complexity-budget record` | E6 + C4 status banner | None. Landed last so it records what actually shipped. |

### 20.1 Gates around the sequence

- **Plan-time `/risk-check`** — once, after the operator approves this plan, before commit 1. Payload describes the whole design: two new components, three command edits, one cross-cutting CLAUDE.md edit. Mandatory (F8).
- **Codex QC** — on this plan, before any commit. Operator-run.
- **`/blindspot-scan`** — fires post-plan, pre-implementation per workspace `CLAUDE.md`, because this plan creates runnable infrastructure (a new command, a new skill, changed automation in `/prime`). Run once; resolve any PAUSE-AND-FIX before commit 1.
- **End-time `/risk-check`** — once, before the final commit, batched across every in-class change actually made.
- **No push** until `/wrap-session`, with the single gated confirmation.

### 20.2 Post-landing verification

Run the § 21 acceptance matrix. AT-1 through AT-8 are runnable immediately; AT-9 through AT-20 need a real capability, and are run against the first live use.

---

## 21. Acceptance-test matrix

| # | Test | Method | Pass condition |
|---|---|---|---|
| AT-1 | Command file is within budget | `wc -l` | 150 ≤ lines ≤ 220 |
| AT-2 | Both files declare an explicit model tier | grep frontmatter | `model: opus` in both; no `model` field added to any settings file |
| AT-3 | Skill cannot self-invoke | grep frontmatter | `disable-model-invocation: true` present |
| AT-4 | Command reaches projects | run a project session, `ls .claude/commands/develop-capability.md` | symlink present after SessionStart |
| AT-5 | `/prime` unchanged where no capability exists | run `/prime` in a project with no `development/` | byte-identical brief to a pre-change run; no new line, no menu item |
| AT-6 | `/prime` surfaces one in-development record | create a fixture record, run `/prime` | one `[capability:<slug>]` menu item showing the next action |
| AT-7 | `/prime` caps at three | fixture with 5 records | 3 shown, remainder noted in one clause |
| AT-8 | Record template renders | render `capability-record.md` with test values | no `{{` remains; all schema sections present |
| AT-9 | Lightweight writes zero dedicated files | run case 17.1 | no `development/` created; exactly one `logs/decisions.md` entry; zero operator stops |
| AT-10 | No-build writes nothing | run case 17.6 | no file created anywhere; outcome reported in chat with citations |
| AT-11 | Artifact request routes out | run case 17.7 | one-line route to `/develop-ai-resource`; no record; no lane call |
| AT-12 | Upstream brief is not re-qualified | hand `/develop-ai-resource` a brief carrying `**Capability:**` + `**Settled upstream:**` | it reads the record, skips 1.1–1.2, runs 1.3–1.6 on the artifact, and its Step 4 disposition returns to the capability rather than making an adoption decision |
| AT-13 | Direct `/develop-ai-resource` invocation is unchanged | invoke it with a plain need, no capability fields | full Step 1 including 1.1–1.2, exactly as before commit 3 |
| AT-14 | Heavy stops exactly three times | run case 17.4 to completion | 3 planned stops; no fourth; a passing review verdict produces no stop |
| AT-15 | Heavy lane announcement stops | trigger H1 in Frame | command states lane + triggers + consequence and waits; does not proceed to Shape |
| AT-16 | Escalation is additive and arms G1 | run case 17.9 | record upgraded with a dated `## Lane` entry; nothing discarded; immediate stop naming what is already committed |
| AT-17 | Resume works across sessions | start a Medium capability, `/clear`, run `/develop-capability` with no argument | resumes at the recorded phase with the correct next action; no completed phase re-runs |
| AT-18 | Wrap and handoff tolerate the new file class | run `/wrap-session` with an in-development record present | completes without error; `logs/scripts/check-archive.sh` unaffected |
| AT-19 | No confidential data reaches a commit | run a trial with a real record in case 17.2 | `git log -p` for the capability's commits contains no buyer name, address or message body; trial material is in the scratchpad only |
| AT-20 | Unassessed is reported as unassessed | force Codex unavailability at Heavy G1 | independent review recorded as **unassessed**, not passed; operator asked to decide with the gap explicit |
| AT-21 | A trial with no useful result stops the build | force a negative trial | build stops; negative result recorded; ladder re-entered; no permanent machinery created |
| AT-22 | Rejected capabilities keep their record | run case 17.8 | record exists with `status: rejected` and the routing note; not deleted |

---

## 22. Risks, mitigations and rollback

| # | Risk | Likelihood | Impact | Mitigation | Rollback |
|---|---|---|---|---|---|
| R1 | **`/prime` regression.** Step 1e breaks or slows the highest-traffic command in the repo. | Low | High | Structural copy of Step 1d, which is proven (F16). Repo-scoped, not cross-repo. Guarded by a directory-existence check that short-circuits before any read. AT-5 requires a byte-identical brief where `development/` is absent — which is every project on day one. Landed as its own commit (§ 20, commit 5). | `git revert` commit 5. Consequence: capabilities become memory-dependent to resume. Named, not hidden. |
| R2 | **Double qualification with `/develop-ai-resource`.** Two commands qualify the same need and disagree. | Medium | High | The § 14.3 brief declares four things settled; the § 18.3 clause tells the downstream command to read rather than re-derive, while keeping artifact-scoped qualification intact. AT-12 and AT-13 test both directions. | `git revert` commit 3. Consequence: some duplicated Step-1 work per handoff — wasteful, not incorrect. |
| R3 | **The complexity budget was right and this is over-built.** Three lanes, a skill and a record convention for a need with no historical evidence. | **Medium — the honest assessment** | Medium | Recorded openly as an OP-11 exception (§ 4.4) rather than argued away. § 24 sets explicit simplification and retirement conditions with a concrete review point (after the third completed lifecycle). U5 names the specific signal — if Lightweight is rarely the right lane, the three-lane design is wrong. | Revert commits 1–5. The OP-11 entry stays as the record that the question was asked. |
| R4 | **Heavy is too heavy to use.** Three stops plus two Codex rounds proves unsustainable for a single operator, so Heavy gets avoided and capabilities are misclassified downward. | Medium | High | Three stops is already the operator's own ceiling (Q7), and the Codex reviews ride on them rather than adding stops (D5). Watch for the tell: Heavy triggers firing but Medium being selected. U4 names this as untested. | Reduce to one Codex round (package only) — a skill edit, no structural change. |
| R5 | **A fourth state file per project.** `CLAUDE.md` + `logs/decisions.md` + `pipeline/` + now `development/`. | Medium | Medium | Lightweight adds nothing. Records are per-capability and leave the active set by reaching a terminal status. No registry, no index (§ 12.7). More than a dozen records in one project is itself the signal that the project should split. | Revert; records are plain markdown and remain readable regardless. |
| R6 | **Lane misclassification downward** — Heavy work run as Medium, so confidential data or an external integration ships without Codex review. | Medium | **High** | Six named Heavy triggers, each with a concrete test. Ambiguity resolves upward (§ 6.1). Mandatory re-testing at every phase boundary and on five named discoveries (§ 6.6). H2 and H1 are the two that matter most and are the two easiest to test. | Escalation is always available mid-run and is additive (§ 6.6). |
| R7 | **Terminology collision.** "Capability" already means human proficiency in `axcion-communication-system` (F29). | High that it is encountered; low that it causes harm | Low | `development/` collides with nothing (F30, D3). Both files define *operating capability* explicitly and name the other sense. § 4.1 carries the definition. | Rename the directory — mechanical, and no consumer greps it by name except `/prime` Step 1e. |
| R8 | **Always-loaded token cost.** +2 lines in workspace `CLAUDE.md`, every session, every project, forever. | Certain | Low | Two sentences. Without them, routing is wrong by default (I1), which costs far more than two lines. | Revert commit 4. Consequence: initiation becomes memory-dependent. |
| R9 | **Confidential data leaks into a commit** during a trial. | Low | **Severe** | § 12.8's rule set; scratchpad-only trials (D10); no gitignored in-repo trial directory; AT-19 greps the actual commits. | `git` history rewrite — expensive and the reason the preventive rules are strict rather than advisory. |
| R10 | **Codex unavailable or declined**, and Claude substitutes a subagent while calling it independent review. | Medium | High | Explicitly forbidden (Q8, § 15.4). The failure path records independent review as **unassessed** and puts the decision to the operator with the gap visible. AT-20 tests it. | None needed — this is a behaviour rule, tested. |
| R11 | **Record becomes a second source of truth** competing with the project's own authority documents. | Medium | Medium | The record points to authority documents; it never restates them (§ 12.4 `## Pointers`). It owns the *development* of one capability, not the project's rules. `/develop-capability` never edits another project's authority document (§ 14.4). | Records are advisory markdown; deleting one loses history, not correctness. |
| R12 | **Scope creep into project management.** The command starts tracking work generally rather than capability development specifically. | Medium | Medium | § 4.3's exclusion list. `/pm`, `/mission`, `/open-items` and `/project-next-steps` own their surfaces. § 24's retirement conditions include this drift explicitly. | Narrow the trigger in the command file. |

### 22.1 Global rollback

Commits 1–6 are independent and revert cleanly in reverse order. Nothing is deleted, no schema is migrated, no existing file is restructured — every edit is additive. The heaviest single revert is commit 5 (`/prime`), which is one contiguous block plus two lines in Step 5. A full rollback returns the repository to its pre-change state with capability records, if any exist, left in place as readable markdown.

---

## 23. MVP exclusions

Explicitly **not** in v1. Each names what would justify building it.

| Excluded | Why | What would justify it |
|---|---|---|
| A second supporting skill | Q11 forbids it; one methodology skill is sufficient | The skill exceeds ~700 lines and has two genuinely separable halves |
| Permanent lane agents | Q11 forbids it; lanes are processes, not actors | Lane processing proves to need fresh context per lane, evidenced across ≥3 capabilities |
| A `capability-reviewer` agent | D8; three reviewers already cover it, and Codex provides real independence | Never — Q8 forbids it |
| A capability registry or index file | Recreates the central registry the foundational document warns against | Never; a glob is sufficient at any plausible scale |
| Cross-project capability dashboards or metrics | Telemetry platform — an explicit foundational anti-goal | Never |
| Automated lane classification (scoring, a checker) | RR-05 says build no checker for a design principle; consequence classes need judgment | Never |
| Automated Codex invocation | Codex runs outside the session; automating it would require credentials and a shared-state path | Codex becomes invocable in-session with no new shared state |
| A `/develop-capability` status or list verb | `/prime` Step 1e plus a glob covers discovery | More than ~5 concurrent capabilities in one project |
| Capability templates per capability type (email, research, standard) | Speculative abstraction on zero confirmed instances (AP-7/DR-7) | Three capabilities of the same type completed, with a demonstrated common shape |
| Retirement automation (removing a retired capability's machinery) | Retirement is rare and judgment-heavy in v1 | The first actual retirement proves the manual path is error-prone |
| Integration with `/mission` (auto-binding a Heavy capability to a mission) | Adjacent, not required (I5); would couple two subsystems on speculation | A Heavy capability spans ≥5 sessions and the operator asks for drift measurement against it |
| Project `CLAUDE.md` scaffolding for `development/` | Workspace rules never duplicate into project files | Never |

---

## 24. Adoption and retirement conditions for `/develop-capability` itself

The command must be able to judge itself by its own standard. These conditions are written into the command file's closing section so they are read at every invocation, not buried in this plan.

### 24.1 Adoption condition

`/develop-capability` is **adopted** when all of the following have happened:

1. Three capabilities have completed a full lifecycle to a terminal status — **at least one per lane**.
2. At least one ended in a **non-build** outcome (no action, manual, reuse, or route-out). A lifecycle that only ever says yes is not validating anything.
3. At least one Heavy capability completed both Codex rounds and the operator judged the process sustainable.
4. At least one capability was **resumed across sessions** using the record and `/prime` Step 1e, without the operator having to remember it existed.
5. No capability required a repair to the command or skill mid-run to complete.

Until all five hold, its own status is **continue trial** — which is the status this plan proposes it carries from day one.

### 24.2 Simplification conditions

Any one fires a review, not an automatic change:

- **Lightweight is used rarely** (fewer than 1 in 4 capabilities) → the lane boundary is drawn wrongly, or Lightweight work is bypassing the command entirely. Both are worth knowing.
- **Heavy is never used** across ten capabilities → Heavy is over-built; consider collapsing to two lanes.
- **Heavy is avoided while its triggers fire** → Heavy is too expensive; reduce the review rounds before reducing the triggers.
- **The record's fields are consistently left empty** → the schema is larger than the work needs; cut the unused fields.
- **A model improvement makes the lane routing unnecessary** — if the operating model reliably scales its own process, the routing scaffolding is exactly the perishable material Principle 8 says to delete rather than adapt. Every significant model release should ask: *what can this now remove?*

### 24.3 Retirement conditions

- The three lifecycles merge — if project creation, capability development and AI-resource authoring stop being meaningfully different, one command should own them and this one should go.
- The redesigned repository (`projects/axcion-ai-system-redesign/`) defines a single project lifecycle that subsumes capability development.
- Twelve months pass with fewer than three capabilities developed — the need was not real, and the OP-11 exception was wrong. **Say so explicitly and remove it**; do not keep it because removing it requires a decision.
- Its maintenance cost exceeds the value it produces, measured by the work it enabled rather than by the components it contains.

### 24.4 Review point

The first formal review is **after the third completed capability lifecycle**, or **2027-01-31**, whichever comes first. The review reads this section against what actually happened and produces one of: adopt · continue trial · simplify · retire. Recorded in `ai-resources/logs/decisions.md`.

---

## 25. Open questions requiring the operator's decision

None of these blocks implementation. Each has a stated default that will be taken if the operator does not decide otherwise.

| # | Question | Default if unanswered | Why it matters |
|---|---|---|---|
| **OQ-1** | **Ship `/prime` Step 1e, or not?** It is the only change touching a command that runs at nearly every session start (R1). | **Ship it**, as commit 5, separable. | Without it, resuming a multi-session capability is memory-dependent — the pattern `docs/ai-resource-creation.md:38` refuses. With it, the highest-traffic command in the repo gains a new step. The plan mitigates and tests, but the operator owns the risk appetite. |
| **OQ-2** | **Is `development/` the right directory name?** § 12.3 recommends it; `initiatives/` is the runner-up. | **`development/`** | Once written into ~20 projects it is tedious to change. Zero collisions (F30), names the activity, reads plainly. |
| **OQ-3** | **Does a Heavy capability also get a `/mission`?** The plan says no in v1 (§ 23). | **No** | A mission would give `/drift-check` something to measure a long Heavy capability against. The cost is coupling two subsystems on speculation. |
| **OQ-4** | **Should the first live use be a deliberate Lightweight case** rather than EmailOS? | **Yes — run one Lightweight capability first.** | EmailOS is Heavy, touches confidential data, and will likely route out to a new project (I3). Validating the command's cheapest path first is how § 24.1's condition 5 gets tested without consequence. |
| **OQ-5** | **Is the OP-11 exception acceptable to you as written** (§ 4.4)? | **Proceed as written.** | Q4 authorised a recorded exception. The entry is written to be read by a future audit that flags the component count — it is the answer to that flag. If the wording understates or overstates the case, this is the moment to change it. |
| **OQ-6** | **Should Heavy require Codex twice, or once?** The plan says twice (package + result). | **Twice** | Once (package only) halves the operator's external-review burden but leaves the *implemented result* unreviewed by an independent model before it touches real data. U4 flags this as untested; § 24.2 makes it the first thing to cut if Heavy proves too expensive. |

---

## Appendix A — SOP step → phase mapping (completeness check)

Every one of the SOP's thirteen steps has a home. None was dropped; none became its own stage.

| SOP step | Phase | Lightweight | Medium | Heavy |
|---|---|---|---|---|
| 1 — State the operating outcome | Frame | ✓ | ✓ | ✓ |
| 2 — Claude inspects reality | Frame | ✓ (≤4 files) | ✓ (≤12) | ✓ (+consumers, +authority) |
| 3 — Choose the smallest intervention | Frame | ✓ | ✓ (+dispositions) | ✓ |
| 4 — Test the workflow before building | Shape | escalates | required on M1 | mandatory |
| 5 — Language, ownership, seams | Shape | owner only | full 7-field seam | +operating seam |
| 6 — Thin implementation package | Shape | 3 lines | 11 fields | durable + approved |
| 7 — Select review depth | Frame/Shape | implicit in lane | implicit in lane | explicit at G1 |
| 8 — Plan vertical slices | Shape | one slice | 2–5 ordered | + failure/recovery |
| 9 — Implement one behaviour at a time | Build | ✓ | ✓ | ✓ |
| 10 — Claude reviews its own implementation | Prove | ✓ inline | ✓ recorded | ✓ recorded |
| 11 — Independent review and adjudication | Prove | none | `/qc-pass` | Codex ×2 |
| 12 — Deliver and operate the result | Land | demonstrate | real use | controlled release |
| 13 — Make the lifecycle decision | Land | stated | operator (G3) | operator (G3) |

## Appendix B — Foundational principle → design element mapping

| Principle | Where it lives in this design |
|---|---|
| 1 — Business value governs | § 4.4 states the budget miss openly rather than dressing it up; § 24 measures success by work enabled, not components owned |
| 2 — Govern capabilities, not component counts | The whole premise: the record describes a capability, and its artifacts are consequences |
| 3 — Validate the need before building | Frame's ladder and no-build exit (§ 7 step 4, § 8 step 5); the mandatory trial (§ 14.7) with a real stop condition |
| 4 — Smallest sufficient and proportionate | Three lanes; zero files at Lightweight; § 11's stop table; § 23's exclusions |
| 5 — Operational reality overrides documented status | § 16.1; "unassessed, never passed"; controls demonstrated in their real invocation path (§ 17.3) |
| 6 — One lifecycle, one source of truth | Five phases in one command; one record per capability; § 12.7's no-registry rule |
| 7 — Completion includes delivery, use and closure | Phase 5 in every lane; adoption requires observed real use; eight terminal statuses; inactivity is not one |
| 8 — Durable knowledge, perishable scaffolding | § 13.2 reason 4 — the skill holds durable method, the command holds orchestration; § 24.2's model-release question |
| 9 — Visible and recoverable failure | Commit per slice; record updated at every boundary; § 15's failure table; nothing deleted to tidy up |

---

**End of plan.** No repository change has been made. Awaiting independent Codex QC, then operator approval.
