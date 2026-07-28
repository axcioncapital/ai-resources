# Build `/develop-capability` — the execution-and-proof loop for approved Axcíon capabilities (v3.1)

> # ⛔ SUPERSEDED — DO NOT IMPLEMENT FROM THIS VERSION
>
> **Superseded by:** [`plans/2026-07-28-work-loop-consolidated-build-plan.md`](2026-07-28-work-loop-consolidated-build-plan.md) (rev. 3) — **the sole build authority.**
>
> **`/develop-capability` was never built, and is not going to be.** The consolidated plan resolved this design differently: the command-owned responsibilities became **`/work-loop`**, and this document's methodology became the consumed skill `skills/capability-development/SKILL.md`. Anything here that reads as a specification for a `/develop-capability` command describes a command that does not exist.
>
> **The `/qc-pass` and `/contract-check` this document says it awaits never ran, and are not owed.** The design was consolidated instead. This is the last of the four `develop-capability` drafts (v1 → v2 → v3 → v3.1); all four are review trail only.
>
> **Retained as review trail and drafting source only.** Where this file and the consolidated plan disagree, the consolidated plan wins without exception.
>
> Banner added 2026-07-28 (S6-ceb), remediating a finding from `audits/risk-checks/2026-07-28-retrospective-work-loop-session-a-b-landed-set.md`: this file was left dangling with a status line claiming it awaited review and approval, which was no longer true.

**Status:** ~~DRAFT v3.1 — targeted correction pass on v3. Awaiting `/qc-pass` and `/contract-check`, then operator approval~~ → **SUPERSEDED 2026-07-28.** Never approved, never implemented; the awaited reviews never ran and are not owed. See the banner above. No repository change was ever made from this document directly.
**Supersedes:** v3 (Systems-Builder-as-host contradiction), v2 (premise void), v1. All retained as the review trail.
**Author:** Claude (Opus 5), 2026-07-28.
**Review history:** v1 → Codex independent review, verdict **Revise** (5 blocking, 11 important). v2 → `/qc-pass`, verdict **REVISE** (14 fixes). Fixing QC finding 3 overturned v2's premise; v3 rebuilds on the corrected one at operator direction.
**Target repo:** `ai-resources/`, as it stands today.
**First host and pilot environment:** `projects/axcion-systems-builder/`.

> **Reviewer note on evidence.** Every count in this plan was derived mechanically on 2026-07-28 and states its command **and its search space**. v1 and v2 both stated absence claims produced by the harness's shadowed `grep`, which honours `.gitignore` and therefore could not see 23 of 27 project directories or `ai-resources/` itself. Every absence claim here was re-derived with `command grep`. This is the single most important correction in the document.

---

## 0A. Resolution of the 14 `/qc-pass` findings

| # | Finding | Resolution | Where |
|---|---|---|---|
| 1 | **§ 18.3 closes only one of two operator gates.** `develop-ai-resource.md:121` carries a second gate on the *no candidate was built* branch, reachable in upstream mode by construction (1.6's verdict list includes *reuse as-is* and *defer*, and `:55` routes those to Step 4). `:125` and `:127` carry further residue. | **Fixed.** The Step-4 clause now covers **both** branches explicitly, plus `:125`'s external-resource decision and `:127`'s completion criterion. New test AT-15 exercises an upstream brief that ends in *no build*. | § 14.3, § 18.3, AT-15 |
| 2 | **§ 14.9 describes a handoff without enabling one** — the change request goes to a directory disposed at session end, has no home in the record schema, and amends no receiving command. | **Fixed.** A `## Change requests` section is added to the record schema, holding the request verbatim so it is durable and regenerable. The receiving mechanism is named: **the operator carries and authorises it; a Claude session opened in the sibling project executes it** — the operator does not hand-implement the change. That interaction is **counted** in § 11.1. | § 12.4, § 14.9, § 11.1, AT-24 |
| 3 | **F1/F26/F14/F30 absence claims were produced by a blind instrument**; the stated commands do not reproduce. | **Fixed, and it changed the plan.** All absence claims re-derived with `command grep` over a stated search space. F26 was **false** — Email OS material exists in two projects. That discovery is the premise correction in § 0B. F26 is split into its supported and unsupported clauses. | § 0B, § 2.1, § 2.1.1 |
| 4 | **§ 12.8 ignores `/wrap-session` Step 0.5**, an automatic conversation-derived writer into the repo; **AT-19's second half is not mechanically evaluable.** | **Fixed.** A wrap-time constraint is added for sessions handling confidential material, and the residual risk is named in R9. AT-19 now has a concrete, runnable pass condition with a named search space. | § 12.8, R9, AT-19 |
| 5 | **Commit 4 spans two git repositories** and cannot be made as specified; § 22.1's rollback claim inherits the defect. | **Fixed.** Split into 4a (workspace root repo) and 4b (`ai-resources`). Rollback restated per repo. | § 20, § 22.1 |
| 6 | **Two uncounted operator interactions** — § 6.7's de-escalation acknowledgement and § 15.1's multi-record disambiguation. | **Fixed.** Both are now counted and named in § 11.1 as *interactions* distinct from *stops*, with the distinction defined. The change-request handoff (finding 2) is counted the same way. | § 11.1, § 11.6 |
| 7 | **Closure writes are left uncommitted** in both Lightweight and Medium. | **Fixed.** A closing commit is named in both lanes, after the status is accepted. | § 7 step 18, § 8 step 26 |
| 8 | **§ 14.4 and § 14.5 do not meet § 14's declared five-field contract.** | **Fixed.** Both completed with Out / Back / Next. | § 14.4, § 14.5 |
| 9 | **Three cross-references point at § 18.5**, which is titled "Not created." | **Fixed.** All repointed to § 18.4 / § 19.1. | § 2.2, § 3.4, § 4.4 |
| 10 | **Lane routing omits adoption/maintenance burden**, one of the ten operator-named factors. | **Fixed.** Added as **M6**, with a test. Why it is a Medium rather than a Heavy trigger is stated. | § 6.3 |
| 11 | **Five case walkthroughs omit required elements.** | **Fixed.** All ten cases now carry all seven: lane · why · artifacts · review depth · handoffs · evidence · lifecycle decision. | § 17 |
| 12 | **§ 2.4 defers the interview answers to v1**, so the plan is not self-contained; "twelve-question" conflicts with Q1–Q13. | **Fixed.** All thirteen answers inlined. The count is thirteen — twelve were asked in one batch, plus the framing question answered before it. | § 2.4 |
| 13 | **RR-05's invocation path is satisfied by interpretation**, not by one of the three mechanisms `ai-resource-creation.md:38` names. | **Fixed and materially improved.** Under the corrected premise the command has a real pipeline position — workflow Phase 15. § 4.5 states plainly what is discharged, what is interpretation, and what is deliberately deferred. | § 4.5 |
| 14 | **The handoff invocation mechanism and record-path resolution are unstated.** | **Fixed.** Skill-tool invocation per `develop-ai-resource.md:65`; `{WORKSPACE}` ancestor walk-up per `develop-ai-resource.md:49`. | § 14.3, § 18.3 |

**Also fixed, from the reviewer's out-of-scope notes:** the "+2 lines" cost estimate (actually six lines, four sentences — a D11 self-violation) → § 18.2/§ 19.1/R8; "sixth bullet" → fifth (§ 5.4); Lightweight's read budget stated once as four files total (§ 7 step 2); § 17.5's `:31-34` citation narrowed to what it carries; § 14.1's `/scope-project` entry point corrected; commit prefixes changed to `new:` / `update:` / `batch:` per `ai-resources/CLAUDE.md` § Git Rules (§ 20); § 14.8's "nine statuses" → eight; § 6.6's immediate-stop path now says whether brief #1 is composed first; OQ-8 deleted — it asked the operator a question Decision-Point Posture says to decide.

---

## 0B. The premise correction

### What v2 claimed

That Axcíon had **no development path** for an operating capability, and that two named near-term uses — EmailOS and Contacting Strategy — had nowhere to go. That claim carried the entire justification for adding two components against the complexity budget.

### What is actually true

`projects/axcion-systems-builder/` runs a **15-phase Complex Project Development Workflow**. Phases 4–13 live in that repo: consolidated V1 → Needs Document → reconcile → clean system definition (V2) → MVP and roadmap → evaluate ≥2 technical approaches → approved solution (V3) → technical red team → Implementation Brief. Codex red-teams at four defined points. The operator holds approval authority at every definition. Phase 14 hands the package to `/new-project`.

Both named uses are live cases in it:

| Case | Phase | State |
|---|---|---|
| `email-system` ("Axcíon Email OS") | **6 — Needs QC, Codex Review 1 pending** | `01` 195 lines received; `02` **982 lines**, operator-authored, received 2026-07-24. `03`–`06` are stubs, status *not started*. |
| `contacting-operations` | **4 — V1 received** | `01` 142 lines received 2026-07-24. `02`–`06` are stubs. |

A third source exists outside that repo: `projects/buy-side-service-plan/analysis/` holds an operator-supplied `email-os-needs-definition-v1.md` (349 lines) and an `email-os-coverage-gap-report.md` (328 lines), both dated 2026-07-24.

### The real gap

Systems Builder's own `workflow.md` defines Phase 15 — *Begin Project Execution* — in **one paragraph** (`workflow.md:925-940`). It states that implementation "should proceed through controlled vertical slices," that each slice "should produce an observable end-to-end result" validated against MVP scope, V3, acceptance criteria and the Needs Document, and that material scope changes route back upstream.

That is a statement of intent. It is not a process. Nothing owns:

- the slice loop — reproduce-or-fail → implement → refactor → verify → commit;
- matching evidence to claim type, or reporting an untested claim as *unassessed*;
- verification depth chosen by consequence;
- **independent review of the built result** — all four Codex reviews sit at Phases 6, 8, 9 and 12, every one of them *before* implementation (`workflow.md:972-1000`);
- real operating use before adoption;
- an explicit terminal status;
- resumable execution state across sessions.

> **The corrected gap statement.** Systems Builder produces extensive **definition** material and hands it to `/new-project` for **implementation planning**. `/develop-capability` supplies the **execution-and-proof loop** that turns an approved package into demonstrated, verified, adopted working capability with an explicit terminal status.

### The boundary, stated once

> **Systems Builder defines and hosts sandbox development. `/develop-capability` executes and proves capabilities. `/new-project` graduates the proven system into its permanent project.**

### Operator constraints binding this version

1. Systems Builder is the **first host and sandbox**, not a prerequisite. `/develop-capability` works *inside* it during sandbox development. Nothing here waits on a Systems Builder redesign.
2. The command **consumes** existing case material and does not repeat completed work (§ 14.10, the *adopt-from-case* entry mode).
3. The command remains **standalone and reusable**, with all three lanes.
4. **Systems Builder's workflow and authority documents are not modified or redesigned** (D14). Capability records and implementation artifacts *are* created inside the sandbox — that is what hosting means.
5. Overlaps with existing Systems Builder phases are **documented as follow-up observations** (§ 26), not resolved now.
6. Pilot on EmailOS after implementation; observed friction scopes any later Systems Builder change.

---

## 0C. Review-gate record

Recorded in the plan itself, because a plan that cites a gate without carrying its verdict is asserting a check it has not shown (QC finding, v3.1).

| Gate | Version | Verdict | Outcome |
|---|---|---|---|
| Codex independent review | v1 | **Revise** — 5 blocking, 11 important | All dispositioned; v2 written |
| `/qc-pass` (`qc-reviewer`, fresh context) | v2 | **REVISE** — 14 fixes | All 14 resolved (§ 0A); fixing finding 3 overturned the premise |
| `/contract-check` (independent, fresh context) | v3 | **MINOR-DRIFT** — hard contract | 4 divergences, all absorbed; see below |
| Operator architectural review | v3 | **Targeted revision** | The Systems-Builder-as-host contradiction; this version |
| `/qc-pass` | v3.1 | *pending* | — |
| `/contract-check` | v3.1 | *pending* | — |

**v3 `/contract-check` verdict, verbatim in substance.** Contract type: **hard** — it enumerates 25 sections, 10 cases × 7 elements, 11 locks, 13 lifecycle behaviours, 9 state questions and 8 handoffs, so each is checked literally. Enumerations verified present and substantive: all 25 required sections; all 10 cases carrying all 7 elements; all 11 locks; all 13 lifecycle behaviours as **5 phases, not 13 stages**; all 9 state questions; all 8 handoffs; all 10 lane factors including M6; one command + one skill + one template, no second skill, no agent; the 14-finding resolution table complete. No implementation or commit performed.

Its four divergences and their absorption:

1. **Locked decision 7's route was never walked** — case 8 routed only to Systems Builder Phase 4. → § 17.8 now walks both branches with a condition table deciding which fires.
2. **§ 4.3 narrowed locked decision 5** by assigning all need-definition to Systems Builder with no carve-out. → Scoped to `adopt-from-case` entries; an explicit paragraph confirms capabilities without a case perform their own Frame and Shape.
3. **The pilot's owning project was never named.** → Named. In v3 the answer was "a future Phase-14 project," which exposed the deeper contradiction this version fixes; under v3.1 the answer is Systems Builder as sandbox steward, graduating later (§ 14.11).
4. **Two live `OQ-n` namespaces.** → Codex answers relabelled **CX-1…CX-6**; eight stale references repointed.

**Operator answers, settled 2026-07-28:** OQ-1 **accept prong (b)** — no OP-11 unless `/risk-check` disagrees. OQ-2 **follow `/placement`**. OQ-3 **accept the v1 resumption arrangement**. OQ-4 **Lightweight first, then exercise EmailOS inside Systems Builder** — a real pilot, not rehearsal-only, not blocked by the missing permanent project. § 27 carries these as answered rather than open.

---

## 1. Executive recommendation

**Build it.** One operator-facing command, `/develop-capability`, backed by one methodology skill, `capability-development`. Together they own the execution-and-proof loop that Axcíon's development workflow currently leaves to a single paragraph.

Three lanes selected by **consequence classes** (§ 6). Five phases — Frame → Shape → Build → Prove → Land — carrying all thirteen SOP steps without becoming thirteen gates (Appendix A). Operator stops rationed at **0 / 1 / 3**, with Lightweight's zero stops qualified by a required acceptance of the demonstrated outcome, and every non-stop operator *interaction* now counted openly (§ 11.6).

Four things distinguish this plan from its predecessors.

**The premise is now evidenced rather than prospective.** § 0B replaces "no development path" with a demonstrated structural gap: the workflow's own Phase 15 is one paragraph, and all four of its independent reviews happen before any code exists.

**The complexity budget is now cleared on prong (b), so no OP-11 exception is needed.** `axcion-systems-builder/CLAUDE.md:13` records, in writing, that *"A Management OS was built and never run; a Strategy OS was built and partly unused."* Two systems, built, not adopted, both now retired. That is a failure pattern seen ≥2 times with cited written evidence — exactly what `docs/ai-resource-creation.md:27` requires. § 4.4 reassesses this honestly, including what the evidence does **not** prove.

**It consumes rather than repeats.** The *adopt-from-case* entry mode (§ 14.10) reads an approved Systems Builder package as settled input — the Needs Document is the verified need, the MVP document supplies the slices, V3 and the Implementation Brief supply the seam — and enters at Build. It never re-derives an approved artifact, and it handles a case that is only partly complete.

**It changes nothing it does not own.** Systems Builder's workflow and authority documents are frozen (D14); the sandbox under `cases/{name}/development/` is the command's own to write. Where the two overlap, § 26 records the observation and leaves it for the post-pilot review.

**Recommended disposition:** approve after `/placement` and a plan-time `/risk-check`. Implement in six commits (§ 20). Pilot on `email-system` when that case reaches Phase 14/15 — noting the honest dependency in § 25, since `03`–`06` are stubs today. Review against § 24 after the third completed lifecycle.

**Main alternative rejected:** fold the execution loop into Systems Builder as an expanded Phase 15. Rejected on the operator's explicit instruction not to redesign Systems Builder in this implementation, and on merit — the loop is needed for capabilities that never pass through Systems Builder at all (cases 17.1, 17.6, 17.10), so it must be standalone and reusable rather than a phase of one workflow.

---

## 2. Confirmed facts, reasonable inferences, unknowns, proposed decisions

### 2.1 Confirmed facts

**Search space for every absence claim below:** the workspace root and all subtrees, `.git` excluded, using `command grep` — **not** the harness's shadowed `grep`, which honours `.gitignore`. This distinction is load-bearing and is why v1 and v2 were wrong (§ 2.1.1).

| # | Fact | Evidence (command / path) |
|---|---|---|
| F1 | **No `develop-capability` command or `capability-development` skill exists.** The literal string `develop-capability` appears only in this plan series. `capability-development` appears in **two** files as incidental English prose about a private-equity firm's plans, unrelated to this design. | `command grep -ril "develop-capability" . --exclude-dir=.git` → only `ai-resources/plans/*`. `command grep -ril "capability-development" . --exclude-dir=.git` → `projects/axcion-sector-intelligence/execution/raw-reports/precision-components/precision-components-session-f-raw-report.md:44` and `.../research-extracts/precision-components/precision-components-Q7-extract.md:140` |
| F2 | `ai-resources/.claude/commands/` holds **91** command files. | `ls ai-resources/.claude/commands/*.md \| wc -l` → 91 |
| F2b | `ai-resources/skills/` holds **80** skill directories. | `ls -d ai-resources/skills/*/ \| wc -l` → 80 |
| F3 | `/develop-ai-resource` is 138 lines, four steps. Step 1 performs need statement, evidence classification, existing-capability disposition, an intervention ladder, a complexity budget, and a verdict including *no build*. | `develop-ai-resource.md:29-55`; ladder `:43`; verdicts `:53`; no-build routing `:55` |
| F4 | Its owned artifact class: skill, reusable prompt, persistent instruction, reference file, command, script, hook. | `develop-ai-resource.md:9` |
| F5 | It routes skill-class work to `/create-skill` and `/improve-skill` **"via the Skill tool"** with a qualified brief requiring `**Mechanism:**` and `**Evidence:**`. | `develop-ai-resource.md:65-66`, `:80-87` |
| F5b | **Step 4 carries two operator gates, not one.** Candidate built → Ship / Revise / Defer / Delete (`:119`). **No candidate built → Accept / Reconsider (`:121`).** `:125` adds a separate decision for external resources; `:127`'s completion criterion requires a disposition either way. | `develop-ai-resource.md:119`, `:121`, `:125`, `:127` |
| F5c | It resolves the workspace root by **ancestor walk-up** — the nearest ancestor holding both `ai-resources/` and `projects/` — because a repo-relative path resolves from neither an ai-resources session nor a project session. | `develop-ai-resource.md:49` |
| F6 | Its Guardrails disclaim portfolio prioritisation, repository redesign, incident recovery, architecture review, recurring audits, permission redesign and publication. | `develop-ai-resource.md:135` |
| F7 | History: `6982bc6` created it; `07880ab`, `afeaae2`, `7383459` corrected authority policy, direct callers, the Pocock SHA pin and the principles path. | `git -C ai-resources log --follow -- .claude/commands/develop-ai-resource.md` |
| F8 | "New commands or skills" is a **mandatory** `/risk-check` class at two gates. Sessions may not self-waive. **The class does not distinguish shared from project-local.** | `docs/audit-discipline.md:56-81` |
| F9 | The complexity budget requires **at least one** prong: (a) net-simplification, or (b) **"a failure mode with cited written evidence… or a pattern seen ≥2 times."** | `docs/ai-resource-creation.md:25-34`, prong (b) at `:27` |
| F10 | RR-05 requires a new command to state what it replaces or why it must be separate, **and** name its invocation path — "the registered pipeline, cadence, or hook that will call it." A written principle; build no checker. | `docs/ai-resource-creation.md:36-44`, `:38` |
| F11 | A component introduced despite failing the budget is a recorded OP-11 exception. | `docs/ai-resource-creation.md:44` |
| F12 | `auto-sync-shared.sh` symlinks every ai-resources command and agent into each project at SessionStart. | `new-project.md:465` |
| F13 | Project state conventions are **not uniform**: **27** project directories; **21** with `pipeline/pipeline-state.md`; **26** with `CLAUDE.md`; **26** with `logs/decisions.md`; **4** with `logs/next-up.md`; **0** with `PROJECT.md`; **3** repos with `logs/missions/`. | `ls -d projects/*/ \| wc -l` → 27; per-item `ls projects/*/<path> \| wc -l` |
| F13b | **23 of the 27 project directories are gitignored at the workspace root**, because each project is its own repo. | `for d in projects/*/; do git check-ignore -q "$d" && …; done` → 23 of 27 |
| F14 | `pipeline/pipeline-state.md` tracks `/new-project` scaffolding stages 3a–6, not live work. | `new-project.md:307-324`, `:892` |
| F15 | `/prime` Step 1b detects continuity scratchpads and offers them as resume points; 1c detects plan position; 1d scans `logs/missions/`, a zero-cost no-op when absent; Step 5 caps the menu at 6. | `prime.md:164`, `:176`, `:215`, `:289-298` |
| F16 | `/mission` manages multi-session goals via a frozen contract; advisory, blocks nothing. | `mission.md:10-14` |
| F17 | `/qc-pass` dispatches `qc-reviewer` with no conversation history, and carries a project-session fallback: walk up to `ai-resources/`, inline the definition into `general-purpose` with `model: opus` re-asserted. | `qc-pass.md:22-24` |
| F18 | `/risk-check` returns `GO` / `PROCEED-WITH-CAUTION` / `RECONSIDER` and writes to `audits/risk-checks/`. | `risk-check.md:5` |
| F19 | `/implementation-triage` returns `WORTH-DOING` / `MARGINAL` / `NOT-WORTH-DOING` / `DECLINE`; chat-only. | `implementation-triage.md:42-47`, `:64` |
| F20 | `/scope-project` is the complex-build lane; **Stage 0 is a route check with its own gate**, so entry is at Stage 0, not mid-workflow. Stage 5 can end `Park` / `Do Not Build`. | `scope-project.md:31-39`, `:78` |
| F21 | `/new-project` Step 0 dispositions: A no repository · B existing owner (return a handoff, do not modify that repository) · C small document project · fallthrough. Ambiguity resolves toward fallthrough. | `new-project.md:51-58` |
| F22 | `/graduate-resource` requires confirmation from every existing canonical consumer before graduating. | `docs/ai-resource-creation.md:21` |
| F23 | Placement heuristics Q1–Q8 assign reusable → `ai-resources/`; operator-invoked → command; procedural instructions → skill; structural class → `/risk-check`. | `docs/repo-architecture.md:181-226` |
| F24 | **`/wrap-session` Step 0.5 writes a continuity scratchpad to `logs/scratchpads/` — inside the repository**, gitignored but present in the tree. It is automatic, derived from conversation, skippable only for trivial sessions, and explicitly "your judgment call… do not ask the operator." | `wrap-session.md:25`; `ai-resources/.gitignore:28` |
| F25 | `/wrap-session` Step 12c blocks the commit of any `/risk-check`-class artifact lacking a passing independent `/qc-pass` this session. | `wrap-session.md:227` |
| F26 | Model defaults are prohibited at every settings layer and in every CLAUDE.md; per-command/agent/skill frontmatter is the only permitted mechanism. New resources declare a tier and never inherit. | workspace `CLAUDE.md` § Model Tier |
| F27 | Project `CLAUDE.md` files no longer carry a `Model Selection` section. | workspace `CLAUDE.md` § Model Tier; `new-project.md:694` |
| F28 | `axcion-communication-system` owns the register-and-language layer of email; `channels/email.md` is a scaffold (`status: scaffold`, work unit W4.3, content not authored). Its CLAUDE.md disclaims the situational layer. | `channels/email.md:1-16`; `axcion-communication-system/CLAUDE.md:27` |
| F29 | **`capability` is already taken** in that project meaning *human communication proficiency* — `capability/` holds drills, assessment and rubric templates. | `projects/axcion-communication-system/capability/` |
| F30 | `development/`, `initiatives/` and `build/` collide with nothing; `capabilities/` collides with nothing but would sit beside `capability/` in one tree. | `ls -d projects/*/<name> ai-resources/<name>` per name → 0 matches each except `capability` → 1 |
| F31 | `axcion-linkedin-os` implements an operating capability with a lifecycle, an authority order (`:14-16`), two hard laws enforced in settings (`:5-12`), and four human checkpoints (`:23-25`). | `projects/axcion-linkedin-os/CLAUDE.md:1-25` |

#### Systems Builder facts — new in v3

| # | Fact | Evidence |
|---|---|---|
| **F32** | `projects/axcion-systems-builder/` runs **Phases 4–13** of a 15-phase Complex Project Development Workflow, producing artifacts `01`–`06` per case, and hands the package to `/new-project` at Phase 14. Its governing aim: *"nothing gets overbuilt, overengineered, or drifted from the original intent."* | `axcion-systems-builder/CLAUDE.md:3`, `:11`, `:37-49` |
| **F33** | The workflow is a **relay across tools**: Phases 1 and 3 GPT Chat; Phase 2 Claude Chat; Phases 4–13 this repo plus the operator; Codex red-team at four points; Phase 14 `/new-project`. | `axcion-systems-builder/CLAUDE.md:23-30` |
| **F34** | **All four Codex reviews are pre-implementation** — Needs quality, V2 product definition, MVP discipline, V3 technical solution. None reviews a built result or a real use. | `workflow.md:972-1000` |
| **F35** | **Phase 15, "Begin Project Execution," is one paragraph.** It states that implementation should proceed through controlled vertical slices producing an observable end-to-end result, validated against MVP scope, V3, acceptance criteria and the Needs Document, and that material scope changes route back upstream. It defines no loop, no verification method, no review, no adoption step and no terminal status. | `workflow.md:925-940` |
| **F36** | Core Operating Rule 4: *"Manual work is acceptable during the MVP. A controlled manual process is preferable to premature infrastructure when the operating model has not yet been proven."* | `workflow.md:1018-1020` |
| **F37** | **Two prior systems were built and not adopted**, in writing: *"A Management OS was built and never run; a Strategy OS was built and partly unused."* Both `management-os` and `strategic-os` are retired and must not be read, run, tested, repaired or built on. The carried lesson: *"building ahead of a real, felt need is what failed."* | `axcion-systems-builder/CLAUDE.md:13` |
| **F38** | Cases live at `cases/{name}/` holding artifacts `01`–`06`; `cases/TEMPLATE/` is the empty shape. Case material is captured **by hand** into that folder, which is "deliberately just files"; `/note` and `/friction-log` are explicitly excluded because they write to `ai-resources/logs/` where case work never reads them. | `axcion-systems-builder/CLAUDE.md:53-64`, `:95-99` |
| **F39** | **`email-system` is at Phase 6** — Needs QC, Codex Review 1 pending. `01` = 195 lines (received); `02` = **982 lines**, operator-authored, received 2026-07-24. `03`, `04`, `05`, `06` are stubs of 8–11 lines each, status *not started*. Two register items remain open and due (A2 who builds and operates it; A3 the compliance source). | `cases/README.md:34`; per-file `wc -l` and `**Status:**` lines |
| **F40** | **`contacting-operations` is at Phase 4** — V1 received 2026-07-24, 8-document set, 18 open questions. `02`–`06` are stubs. The register describes `email-system` as *"the technical email machine that implements `contacting-operations`"* — the seam between them is already stated. | `cases/README.md:34` |
| **F41** | A third Email OS source exists **outside** Systems Builder: `projects/buy-side-service-plan/analysis/email-os-needs-definition-v1.md` (349 lines, operator-supplied, saved verbatim) and `email-os-coverage-gap-report.md` (328 lines, 2026-07-24, diagnosis only). | `command grep -ril "email os" . --exclude-dir=.git`; per-file `wc -l` |
| **F42** | Claude's authority in Systems Builder is bounded: it may recommend and challenge but **may not approve, promote, reject or terminate a requirement**, and does not decide when refinement is finished. | `axcion-systems-builder/CLAUDE.md:82-93` |
| **F43** | `workflow.md` closes by anticipating future tooling: *"This can be converted next into a lean Systems Builder command specification without adding unnecessary governance."* | `workflow.md:1068` |

### 2.1.1 Why v1 and v2 were wrong about absence — and what it cost

The harness replaces `grep` with `ugrep -G --ignore-files --hidden -I --exclude-dir=.git`. `--ignore-files` honours `.gitignore`. Root `.gitignore:32` is `ai-resources/`, and 23 of 27 project directories carry their own ignore entries (F13b). Measured from the workspace root on 2026-07-28:

| Pattern | Shadowed `grep` | `command grep` |
|---|---|---|
| `develop-capability` | 0 | 2 (both plan files, under `ai-resources/`) |
| `emailos` | 0 | 2 (both plan files) |
| `email os` | not run from root in v1/v2 | **7** across `buy-side-service-plan` and `axcion-systems-builder` |

`docs/audit-discipline.md:19-25` documents this exact trap with a measured example, and § 5.3 of this plan carries an "absence is not evidence" rule. Both were read during the v1 investigation. The instrument failure was compounded by a second error: `axcion-systems-builder` appeared in the project listing and was never opened, which is precisely what the operator brief's *"do not infer ownership from project names alone"* forbids.

**Cost:** v2's F26 was false, its I3 inference was false, its § 3 overlap map omitted the single most important near-match, its § 14.1 handoff pointed at the wrong destination, and its OP-11 justification rested on a claim contradicted by two active cases.

**Standing rule adopted (D11).** Every absence claim in this repository states its instrument and its search space, or it is not made.

### 2.2 Reasonable inferences

| # | Inference | Basis | If wrong |
|---|---|---|---|
| I1 | A capability request arriving in a project session today routes to `/develop-ai-resource`, the only command whose description matches "decide whether a thing should exist, then build it." | F3, F4, workspace CLAUDE.md | § 18.4's routing line is less load-bearing but still correct. |
| I2 | `email-system` will reach Phase 14/15 before `contacting-operations`, since it is six phases ahead and its Needs Document is complete. | F39, F40 | The pilot target changes; § 25's dependency note covers either order. |
| I3 | The execution-and-proof gap is real rather than merely undocumented — Phase 15's brevity is a genuine absence, not a pointer to a process defined elsewhere. Nothing in `workflow.md`, `engine.md` or `cases/README.md` elaborates it. | F35, and a heading scan of all three files | If a process exists elsewhere, this command duplicates it and § 26's follow-up review would find that. The pilot is the test. |
| I4 | Existing continuity mechanisms suffice for v1 resumption: `/wrap-session` writes a scratchpad and `/prime` Step 1b offers it (F15, F24), plus the record itself. | F15, F24 | § 23's trigger fires and the deferred `/prime` scanner gets built. |
| I5 | The three Email OS sources (Systems Builder case, `buy-side-service-plan` needs definition, coverage gap report) are complementary rather than competing, since two are operator-supplied inputs and one is a diagnosis. | F39, F41 | The *adopt-from-case* mode must then reconcile them, which is a Frame finding it would surface rather than resolve silently. |

### 2.3 Unknowns

- **U1.** Whether EmailOS's operating model works. Systems Builder Phases 6–13 will test the *definition*; only real use tests the model. This is what the pilot exists for.
- **U2.** Who builds and operates EmailOS — Systems Builder register item **A2, still open** (F39). `/develop-capability` cannot answer it and must not infer it.
- **U3.** Whether the approved compliance/privacy source exists and who maintains it — register item **A3, still open** (F39). Load-bearing for H2 handling.
- **U4.** Whether two Codex rounds per Heavy capability is sustainable alongside Systems Builder's existing four. **Six Codex reviews across one system's full life** is the real number, and it is untested. § 26 O-4 and § 24.2 both key on it.
- **U5.** How often Lightweight is the right lane. If rare, three lanes are over-built.
- **U6.** Whether resumption without a `/prime` scanner works across a real multi-session Heavy capability.
- **U7.** Whether the CRM configuration project named in the `email-system` case's Challenge 1 — 11 fund fields, 11 contact fields, campaign records, a five-way permission model, "a substantial configuration project with no named owner" — lands inside or outside the EmailOS capability. It changes the pilot's scope materially.

### 2.4 Settled inputs — the full interview, inlined

**Operator brief locks (six):** `/develop-capability` is new and separate; `/develop-ai-resource` is not renamed, replaced, absorbed or broadened and keeps its artifact class; one capability command, not three; new-project creation stays with `/scope-project` + the planning pipeline + `/new-project`; an AI-resource sub-need is handed out as a bounded brief and the AI-resource pipeline is never reproduced; the SOP is directional; plan only.

**The interview — thirteen questions.** One framing question was answered first, then twelve in a batch. That is the reconciliation of "twelve-question interview" with Q1–Q13.

| Q | Question | Answer, as settled |
|---|---|---|
| Q1 | Which repository is this built for? | **Current repo, now.** `ai-resources/.claude/commands/`, may depend on existing commands as they stand. |
| Q2 | Where is the line against `/develop-ai-resource`? | **Outcome versus artifact.** `/develop-capability` owns the operating outcome end to end and hands a bounded, pre-qualified artifact brief downstream. A small compatibility edit to `/develop-ai-resource` is permitted; its owned artifact class is neither broadened nor shrunk. |
| Q3 | Is EmailOS real? | **Real intended capability**, among the first expected uses. Distinguish confirmed repository facts, intended near-term requirements, and assumptions still to validate. Contacting Strategy likewise. Do not pretend their operating models, schemas or integrations are validated. |
| Q4 | What evidence justifies the command? | Forward-looking operator-stated requirement with two named uses, **not** a historical failure pattern. Do not invent friction-log evidence. Surface any complexity-budget conflict explicitly. *(Superseded in part by § 0B — real evidence now exists, F37.)* |
| Q5 | Capabilities spanning projects? | **In scope.** Select one owning project by four criteria; record seams against others; dependencies never become co-owners. Route to `/scope-project` only when no project can legitimately own it or the work is a new enduring programme. |
| Q6 | Lane selection posture? | Lightweight and Medium **state and proceed**; Heavy states, explains the consequence, and stops. Escalation into Heavy fires the Heavy confirmation. |
| Q7 | Heavy operator-stop ceiling? | **Three.** (1) Scope and implementation-package approval, including Heavy-lane confirmation — **no separate earlier lane stop**. (2) Release or real-trial approval. (3) Lifecycle decision after observed use. A passing review verdict earns no routine stop. |
| Q8 | Independent review model? | Lightweight → proportionate main-session verification unless a mandatory risk class fires. Medium → fresh-context Claude (`/qc-pass`, `/risk-check`) by claim and consequence. Heavy → **Codex** at consequential points plus Claude's deterministic checks. **No new reviewer agent; do not imitate Codex inside Claude.** Produce a concise self-contained review brief and pause with instructions. |
| Q9 | Capability record? | One authoritative record per capability for Medium and Heavy, carrying thirteen named fields, pointing to rather than copying plans, specs and reports. Resolve the terminology collision before fixing a directory name. Lightweight may write **zero** dedicated files — one closing `logs/decisions.md` entry when durable behaviour changed, nothing when the outcome is no action. **Do not reuse `pipeline/pipeline-state.md` as live capability state.** |
| Q10 | Real client or buyer data? | The trial **may** use real data when realistic validation requires it. Medium and Heavy therefore carry proportionate handling: minimum necessary record; named authoritative source; no raw buyer/CRM/email data in committed artifacts; no committed trial outputs containing confidential information; durable records at the level of decisions, schemas, evidence summaries and redacted examples; name the official record; state what may go to external models; dispose of or retain trial material per project rules. Prefer synthetic when it tests the same behaviour. |
| Q11 | Command size and architecture? | **One command (~150–220 lines) plus one `capability-development` methodology skill.** Command owns invocation, discovery, routing, orchestration, gates, resume, handoffs, reporting. Skill owns methodology, lane processes, intervention selection, trial design, ownership and seam method, slice standards, verification and lifecycle standards. One operator-facing command; the skill is not a second invocation path. No second skill, no permanent lane agents in v1. |
| Q12 | Full Heavy lane in v1? | **Yes, all three lanes properly built.** Heavy may hand parts to existing machinery but remains a genuine internal lane that owns the outcome, seams, record, handoff coordination, resume, trial and lifecycle decision. It must not print "run `/scope-project`" for every substantial capability. |
| Q13 | What would surprise a cold reader? | Patrik is sole operator and intended user; a non-developer — Claude makes technical and architectural decisions and surfaces business choices. No fixed deadline. EmailOS and Contacting Strategy are intended near-term uses with unvalidated operating models. **Multi-tool environment** — a capability may involve Claude, Codex, GPT/API, Gmail, CRM, Notion; do not assume every component belongs in Claude Code. This is an operating-development lifecycle, not a code or resource generator: a capability may be implemented through documents, standards, processes, data structures, integrations, software and AI resources in combination. Real use and adoption matter; correct files are not completion. Substantial enough to be reliable — minimalism is not a reason to omit Heavy, durable state, trials, ownership decisions or closure. Lightweight must still feel lightweight. Use **"operating capability"** to distinguish from the human-skill sense in `axcion-communication-system/capability/`. |

**Codex review answers — labelled CX-1 to CX-6** to keep them out of § 27's open-question namespace, which renumbered between versions:

| Ref | Question | Answer |
|---|---|---|
| **CX-1** | Ship the `/prime` capability scanner? | **No for v1** |
| **CX-2** | Is `development/` the right directory name? | **Provisional, subject to `/placement`** |
| **CX-3** | Integrate with `/mission`? | **Excluded from v1** |
| **CX-4** | What should the first live use be? | **A deliberate Lightweight case** |
| **CX-5** | Accept the OP-11 exception? | Accepted only after rationale correction and `/risk-check` — *now superseded: § 4.4 clears prong (b), so no OP-11 is written* |
| **CX-6** | One Codex round per Heavy capability, or two? | **Two, but only on a real Heavy trigger** |

§ 27's `OQ-n` labels are a separate, later set. Nothing in this plan cites an `OQ-n` to mean a Codex answer.

**Operator direction after the premise correction (§ 0B):** six constraints, listed there.

### 2.5 Proposed decisions

| # | Decision | Rationale | Rejected alternative |
|---|---|---|---|
| D1 | Five phases: Frame → Shape → Build → Prove → Land. | Carries all thirteen SOP steps (Appendix A); few enough to hold in mind, enough to place a gate honestly. | Thirteen stages — forbidden by the brief. |
| D2 | Lane routing by consequence classes, not a score. | Mirrors `audit-discipline.md:56-71`. Class membership is arguable; a score is false precision. | Weighted scoring across the ten factors. |
| D3 | Record directory **`development/`**, provisional pending `/placement`. | Zero collisions (F30); names the activity, never competing with `capability/`'s human-skill sense (F29). | `capabilities/` — would sit beside `capability/` in one tree. |
| D4 | One record file per capability, frontmatter-driven. | Matches `/mission`; keeps discovery to a bounded glob. Also matches Systems Builder's own "deliberately just files" convention (F38). | A central register. |
| D5 | Heavy's Codex reviews ride on existing operator stops. | Satisfies the three-stop ceiling while placing review before irreversible work. | A fourth stop for the verdict. |
| D6 | Invocation wiring = workspace `CLAUDE.md` routing only in v1. | RR-05 needs a named path for initiation; existing continuity covers resumption (I4). Naming the command inside `workflow.md` would modify Systems Builder, which the operator forbids. | A `/prime` scanner (Codex I2, CX-1). |
| D7 | `/develop-ai-resource` receives an upstream-mode clause covering **both** Step 4 branches. | F5b: there are two gates, not one. A clause covering one leaves an uncounted operator stop. | v2's single-branch clause. |
| D8 | No new agent. | Q8 forbids a reviewer agent; three reviewers cover it; a fourth would be a detector needing its own closer (OP-12). | A `capability-reviewer`. |
| D9 | The command implements; it is not advisory. | Q12 and the corrected gap (§ 0B) — the gap *is* execution. | Stop-at-plan; that is `/leverage-idea`'s niche. |
| D10 | Confidential trial material and generated review briefs live in an OS temp directory from `mktemp -d`, never any repository path. | F24 disproves the "scratchpad is outside the repo" premise. One rule covers confidentiality and brief storage. | A gitignored in-repo directory — one `git add -f` from a leak. |
| D11 | **Every absence claim states its instrument and search space.** | § 2.1.1. Two plan versions were wrong for want of this. | Restating v2's claims. |
| D12 | `paused` requires a concrete reopening trigger. | Mirrors the `Review-cycle:` discipline (`leverage-idea.md:165`). | A bare `paused`. |
| **D13** | **`adopt-from-case` is an explicit entry mode**, not an inference the command makes case by case. | The operator requires consuming existing material without repeating completed work. An implicit rule would be re-derived differently each run. | Letting Frame decide ad hoc what to re-derive. |
| **D14** | **Do not redesign or edit Systems Builder's workflow or authority documents.** Frozen: `workflow.md`, `engine.md`, `CLAUDE.md`, `cases/README.md`, and every numbered case artifact `01`–`06`. **Normal `/develop-capability` use may create its capability record and implementation artifacts inside the sandbox** — under `cases/{name}/development/`. | Operator correction, 2026-07-28. v3 made Systems Builder simultaneously the "first host" and read-only, which made it an input source rather than a sandbox. A host you may not write into is not a host. | v3's total no-touch rule — rejected: it produced the contradiction this version fixes. Editing `workflow.md` to name Phase 15 — still deferred to § 26 O-1. |
| **D15** | **Prong (b) is cleared, so no OP-11 exception is written.** | F37 is cited written evidence of a ≥2-times failure pattern, which is literally what `ai-resource-creation.md:27` requires. | Reusing v2's OP-11 argument — the operator explicitly forbade it, and it is no longer true. |

---

## 3. Current capability and overlap map

Swept with `command grep` over all 27 projects and `ai-resources/`, by purpose and behaviour rather than name. This is the sweep v1 and v2 got wrong.

### 3.1 Covers part of the need

| Resource | Covers | Does not cover | Boundary |
|---|---|---|---|
| **`axcion-systems-builder`** (F32–F35) | **The definition half.** Needs Document, scope reconciliation, clean system definition, MVP boundary, technical-approach comparison, approved solution, Implementation Brief. Four Codex red teams. Operator approval at every definition. | **The execution half.** Phase 15 is one paragraph (F35). No slice loop, no evidence-to-claim rule, no review of a built result, no real-use step, no terminal status, no resumable execution state. | **The primary boundary of this plan.** SB defines *and hosts*; `/develop-capability` executes and proves; `/new-project` graduates. It **consumes** SB artifacts via *adopt-from-case* (§ 14.10), **works inside the sandbox**, and **never edits** the frozen surface (D14). Overlaps → § 26. |
| `/develop-ai-resource` | Need statement, evidence classification, capability disposition, intervention ladder, complexity budget, no-build verdict, build, verify, decide — **for AI artifacts** (F3, F4). | Business/operational/product capabilities; ownership and seams; slice planning; real-use trials; lifecycle statuses beyond ship/revise/defer/delete; multi-session state. | Outcome vs. artifact (§ 5.1). Receives pre-qualified briefs in upstream mode; never reopens the operating need; never makes the business-adoption call (§ 14.3). |
| `/new-project` | Project initialisation, objective, linking authoritative documents, workstreams, implementation plan, milestones, dependencies, tests and acceptance criteria (`workflow.md:906-921`). Step 0's ownership dispositions (F21). | Executing the plan. It prepares a project for execution and stops. | `/develop-capability` runs **after** it, consuming its implementation plan alongside the SB package. |
| `/scope-project` | Stages 0–5 → control pack and planning brief; can end Park / Do Not Build (F20). | Implementation, verification, real use, closure. | Routed *to* when the work is a project. Entry is **Stage 0**, which is a gated route check (F20) — not mid-workflow. |
| `/mission` | Multi-session goal contracts with a frozen validation contract (F16). | Seams, slices, verification evidence, lifecycle statuses, real-use results. | Adjacent. Integration excluded from v1. |

### 3.2 Adjacent but different

`/leverage-idea` (idea dumps about workspace AI resources; stops at a plan) · `/implementation-triage` (ROI verdict on an existing proposal; chat-only) · `/risk-check` (structural risk of a change) · `/qc-pass` (artifact review against a scope line) · `/post-project-review`, `/archive-project` (project granularity) · `/innovation-sweep` (infrastructure triage at project end) · `/reconcile` (deliverable vs. mandate rubric) · `/project-next-steps` (read-only orientation) · `/tech-consult` (need → technical plan, stops at a Selection Memo — note SB Phase 10 covers this inside a case) · `axcion-linkedin-os` (a built example of an operating capability, F31 — cite, do not couple).

### 3.3 Downstream dependency

`/create-skill`, `/improve-skill`, `/migrate-skill` — reached only through `/develop-ai-resource` (F5). `/graduate-resource` (F22) — later promotion only. The `/plan-draft` chain — only through § 14.2. `qc-reviewer`, `risk-check-reviewer`, `system-owner` — through their owning commands.

### 3.4 Conflict or duplication risk

| Risk | Assessment | Mitigation |
|---|---|---|
| **Overlap with Systems Builder Phases 4–13** | **Real and unresolved by choice.** Frame's need validation overlaps Phase 5; Shape's seam and package overlap Phases 8–11 and 13; the intervention ladder overlaps Phases 7 and 10; the trial overlaps Core Operating Rule 4 (F36). | *adopt-from-case* (§ 14.10) makes SB artifacts **settled input**, so the overlapping work is read rather than redone. The residual overlap is **documented, not resolved** (§ 26), per operator constraint 5. The pilot measures it. |
| **Double qualification with `/develop-ai-resource`** | High severity; two Step-4 gates, not one (F5b). | § 14.3's upstream mode + § 18.3's clauses covering both branches. AT-12, AT-13, AT-14, AT-15. |
| **Six Codex reviews across one system's life** | Real. SB runs four (F34); Heavy adds two. | § 16.2 makes Heavy's two conditional on a real trigger, and § 14.10 states that a capability entering via *adopt-from-case* has already had its **definition** independently reviewed — so Heavy's briefs focus on the built result and the release, not on re-reviewing the package. U4 and § 26 O-4 track it. |
| **A fourth state file per project** | Moderate. | Lightweight adds nothing. Records are per-capability and leave the active set at a terminal status. No registry (§ 12.7). |
| **Two commands named `/develop-`** | Low but real. | § 18.4's routing line states the test in one sentence; both files carry identical reciprocal text. |
| **Terminology: "Phase"** | **Real and already observed.** The `email-system` case records that "Phase" means two things — the operator's Build Phase 1/2 versus workflow Phase 4–13 — and adopted a convention. Adding *Frame/Shape/Build/Prove/Land* risks a third. | `/develop-capability` uses **named phases, never numbers**, precisely so it cannot collide. Stated in § 5.5. |

---

## 4. Purpose, trigger, exclusions, and the reassessed complexity budget

### 4.1 Purpose and definition

> An **operating capability** is a durable ability Axcíon exercises to perform real work. It may be implemented through documents, standards, processes, data structures, integrations, software, AI resources, or any combination. It is defined by the outcome it produces, never by the artifacts it is made of.
>
> Not the sense used in `projects/axcion-communication-system/capability/`, which means human communication proficiency. Where confusion is possible, write *operating capability* in full.

`/develop-capability` supplies the **execution-and-proof loop**: from an approved intention to a demonstrated, verified, adopted capability with an explicit terminal status.

### 4.2 Trigger

`/develop-capability [outcome or observed need]` · `/develop-capability adopt-from-case {path}` · `/develop-capability graduate {slug}` · bare, to resume.

**`graduate` is a named verb, not a remembered step.** § 14.11's trigger is a world-state — the permanent project now exists — and nothing polls a world-state. Two paths reach it: the operator invokes `graduate {slug}` directly, **and** resume (§ 15.1) checks every sandbox-stewarded record it finds for a `permanent_owner:` that has become resolvable, surfacing graduation as the next action when it has. Without both, graduation would be exactly the memory-dependent orphan `docs/ai-resource-creation.md:38` refuses to ship.

Fires when the session is inside — or can name — an existing Axcíon project, and the operator wants Axcíon to be able to *do* something it cannot reliably do today. The desired end state is an outcome, not an artifact.

### 4.3 Exclusions

| Excluded | Owner |
|---|---|
| Deciding **what system to build and why** — needs, scope reduction, MVP boundary, technical-approach selection — **for a capability that enters via `adopt-from-case`** | `axcion-systems-builder` Phases 4–13 |
| Creating a new project | `/scope-project` → `/plan-draft` chain → `/new-project` |
| Authoring an AI resource | `/develop-ai-resource` |
| Repository redesign, architecture review, recurring audits, permission redesign | `/systems-review`, `/architecture-review`, `/friday-checkup`, `/permission-sweep` |
| Incident recovery, repo faults | `/resolve-repo-problem`, `/resolve-incident` |
| Promoting project-local → canonical | `/graduate-resource` |
| Project-level closure and archiving | `/post-project-review`, `/archive-project` |
| ROI judgment on an existing proposal | `/implementation-triage` |
| Idea dump → leverage options | `/leverage-idea` |

**The carve-out matters, and the exclusion row above is scoped deliberately.** A capability that never enters Systems Builder — cases 17.1, 17.6, 17.9, 17.10, and any Lightweight or Medium work originating inside a project — performs its own need definition, scope reduction and behaviour selection in Frame and Shape (§ 7 steps 1–4, § 8 step 5). That is not an incursion into Phases 4–13; it is the ordinary front half of a capability that has no case. Locked decision 5 — this command owns business, operational and product capability development inside existing projects — is unnarrowed by the corrected premise. Systems Builder is the **first host and sandbox**, not the only entry point.

**It also does not:** edit Systems Builder's workflow or authority documents, or any numbered case artifact (D14); create a registry; write into another project's tree (§ 14.9 gives the compliant path); commit confidential material; spawn a new reviewer agent; exceed § 11's stop counts; or expand scope on noticing an adjacent improvement.

### 4.4 Complexity budget — reassessed against the corrected premise

The operator directed that the previous OP-11 argument not be reused. It is not, and it is no longer needed.

**Prong (a), net-simplification — FAILS.** Two load-bearing units added, none removed, plus one always-loaded routing line. Unchanged from v2.

**Prong (b), evidenced failure — PASSES on the second limb.** `docs/ai-resource-creation.md:27` offers two: cited written evidence *from one of four named logs* (friction, defect, coaching, incident), **or** a pattern seen ≥2 times. F37 is a project `CLAUDE.md` line, not one of those four logs, so the first limb does not apply. **The second does, and it is sufficient:**

1. **Cited written evidence, twice over.** `axcion-systems-builder/CLAUDE.md:13`: *"A Management OS was built and never run; a Strategy OS was built and partly unused."* Two systems reached built state and were not adopted. Both `management-os` and `strategic-os` are retired. The carried lesson is recorded in the same line: *"building ahead of a real, felt need is what failed."*
2. **The structural gap is documented in the workflow's own text** — Phase 15 is one paragraph (F35) and all four independent reviews sit before implementation (F34). **This is context, not a second limb:** it evidences an *absence*, which is not the same as evidencing a failure mode. Prong (b) rests on point 1 alone.

**What the evidence proves, and what it does not.** It proves the *failure mode* — built and not adopted — is real, recorded and repeated. It does **not** prove that `/develop-capability`'s particular shape prevents it; nothing can prove that before the pilot. Systems Builder is itself an institutional response to the same failure, aimed at its front half. This command addresses the back half. Whether it works is exactly what § 24.1's adoption conditions and the EmailOS pilot are for.

**Therefore no OP-11 exception is written.** The budget is cleared on prong (b). This is a materially stronger position than v1 and v2, and it rests on evidence that was in the repository the whole time.

**Honesty note for the reviewer.** Prong (b) is met by evidence about *systems built under a previous process*, not by an observed failure of this specific gap. A reviewer who judges that too indirect should say so; the fallback is the OP-11 route, and § 27 OQ-1 records the operator's answer — accept prong (b), with any dissent routed to `/risk-check`.

### 4.5 RR-05 — what is discharged, what is interpretation, what is deferred

`docs/ai-resource-creation.md:38` requires a new command to state what it replaces or why it must be separate, **and** to name "the registered pipeline, cadence, or hook that will call it."

- **Replacement test — discharged.** It replaces nothing. Separateness rests on three distinct lifecycles with different inputs, owners and terminal states, which operator locks #1–#5 forbid merging, and on the fact that the execution loop is needed for capabilities that never pass through Systems Builder at all (cases 17.1, 17.6, 17.10).
- **Invocation path — a real pipeline position, named by interpretation.** The command occupies **workflow Phase 15** (F35) — a documented stage of an existing, live workflow with two active cases heading toward it. That is a genuine pipeline position, not a hope. **But `workflow.md` does not name `/develop-capability` today**, and writing it in would modify Systems Builder, which operator constraint 4 forbids in this implementation. So what actually ships is the workspace `CLAUDE.md` routing rule (§ 18.4) plus the operator invoking the command at Phase 15.
- **Deferred deliberately.** Naming `/develop-capability` inside `workflow.md` Phase 15 is **§ 26 O-1**, for the post-pilot review. That is the step that would fully discharge RR-05's letter, and it is held back on purpose so the pilot tests the command before the workflow depends on it.

This is stated as interpretation, not as compliance, per QC finding 13.

---

## 5. Boundary map

### 5.1 The load-bearing distinctions

> **Systems Builder defines and hosts sandbox development. `/develop-capability` executes and proves capabilities. `/new-project` graduates the proven system into its permanent project.**

> **`/develop-capability` owns the operating outcome. `/develop-ai-resource` owns the artifact. The skill is not the capability; it is one implementation component.**

Both sentences appear identically in the command, the skill, workspace `CLAUDE.md`, and the reciprocal paragraph added to `/develop-ai-resource`.

### 5.2 Routing table

| The operator says… | Goes to |
|---|---|
| "I have a rough idea for a system" | GPT Chat → Claude Chat → Systems Builder Phase 4 |
| "The package is approved — build it" | `/new-project`, then `/develop-capability` |
| "I want to be able to prepare a buyer email properly" | Systems Builder if it is a system to define; `/develop-capability` if the definition is already approved |
| "Add a standard closing section to our reports" | `/develop-capability` (Lightweight) |
| "We need a skill that drafts buyer emails" | `/develop-ai-resource` |
| "Buy-side outreach should become a whole programme" | `/scope-project` (Stage 0) |
| "This command is broken" | `/resolve-repo-problem` |
| "Should this project-local thing become shared?" | `/graduate-resource` |

### 5.3 Owner selection

Apply in order; stop at the first criterion that discriminates: (1) which project owns the primary operating outcome; (2) which owns its continuing decisions and maintenance; (3) which authoritative source should define its behaviour; (4) which would still own it if one dependency were replaced.

Binding rules: **dependencies never become co-owners**; **evidence, not names** — every conclusion cites a file and line, and a directory name is not evidence; **absence is not evidence** — an empty directory or a search finding nothing is evidence about that source, never about the world (and per § 2.1.1, state the instrument too); **a dependency is not a consumer**; **a consumer that does not yet exist is not a consumer**; **route out when no project qualifies**, naming the failing criterion.

### 5.4 Reciprocal text in `/develop-ai-resource`

Appended as a **fifth** bullet to its Boundary block (`develop-ai-resource.md:20-23`, four bullets today):

```markdown
- `/develop-capability` develops **operating capabilities** — business, operational and
  product abilities inside existing projects. It owns the operating outcome; this command
  owns the artifact. The skill is not the capability; it is one implementation component.
  A brief arriving from it carries `**Capability:**` and `**Settled upstream:**` and runs
  in upstream mode — see Step 1.0 and Step 4's upstream-mode clause.
```

### 5.5 Terminology discipline

`/develop-capability` uses **named phases — Frame, Shape, Build, Prove, Land — and never phase numbers.** Systems Builder already carries a two-meaning collision on "Phase" (operator Build Phase 1/2 versus workflow Phase 4–13), recorded and resolved by convention in the `email-system` case. Introducing a third numbering would re-open a collision the host has already paid to close.

---

## 6. Lane-routing model, escalation and de-escalation

### 6.1 Principle

Lane is a judgment about **consequence**, never file count, line count or effort. Heavy triggers first, then Medium, then Lightweight as residual. Any single trigger fires its lane. Ambiguity resolves **upward**.

**A mandatory `/risk-check` class does not imply Heavy.** The class list (F8) does not distinguish shared from project-local, so a project-local command fires `/risk-check` while remaining Medium. Gate and lane are independent judgments.

### 6.2 Heavy triggers — any one fires

| # | Trigger | Test |
|---|---|---|
| H1 | **External or shared system integration** in normal operation — CRM, Gmail, Notion, an API, another project's tree, another ecosystem tool. | Name the system and direction of flow. A human copy-paste is not an integration. |
| H2 | **Real confidential data in normal operation** — buyer, client, relationship, deal or commercially sensitive. | Name the data class and its authoritative source. |
| H3 | **Two or more consumers, or a second project must change.** | Enumerate them. A dependency is not a consumer; a consumer that does not yet exist is not a consumer. |
| H4 | **Difficult reversibility** — published artifacts, external records, sent communications, data migration, or a habit others build on. | State the concrete undo. If you cannot, it is H4. **Producing a draft for human review is not irreversible; sending is.** |
| H5 | **Canonical ownership change** — claims, moves or contradicts a responsibility another project's authority document holds. | Cite the document and clause. |
| H6 | **Genuinely shared infrastructure** — an `ai-resources` resource consumed beyond the owning project, a hook, or automation with shared-state effects. **A project-local command, skill or agent does not fire H6**; it fires M4 and separately triggers `/risk-check`. | Name the consumers outside the owning project. |

### 6.3 Medium triggers — any one fires, when no Heavy trigger fired

| # | Trigger | Test |
|---|---|---|
| M1 | **The operating workflow is not demonstrated.** | Has one real case run end to end with the result observed? |
| M2 | **Three or more distinct behaviours, or work spanning sessions.** | Count behaviours, not files. |
| M3 | **Ownership is ambiguous.** | § 5.3 criteria 1–2 did not discriminate cleanly. |
| M4 | **It needs an AI resource that does not exist** — including a project-local one. `/risk-check` fires at Prove without changing the lane. | The artifact must be authored, not merely used. |
| M5 | **Verification needs more than reading the diff** — a trial, a real record, or comparison against a written standard. | Can a human confirm correctness from the output alone? |
| **M6** | **Material adoption or maintenance burden** (QC finding 10) — the capability is cheap to build and expensive to keep alive: it requires ongoing operator effort, periodic refresh, a standing review, or a dependency someone must maintain. | State who maintains it, how often, and what happens if nobody does. If that answer is "nobody, and it silently rots," M6 fires. |

**Why M6 is Medium, not Heavy.** Maintenance burden makes a capability *worth recording and reviewing*, which is what the Medium record and the G3 lifecycle decision provide. It does not by itself make a capability hard to reverse, confidential or externally coupled. Where burden falls on a *second party*, H3 fires instead and carries it to Heavy.

### 6.4 Lightweight — the residual

No Heavy and no Medium trigger: one owner, one project, a workflow already understood, revert-reversible, one or two behaviours, no external system, no confidential data, no new AI resource, no material maintenance burden, and verification is "look at the result."

### 6.5 Announcement, and where Heavy stops

**Exactly one Heavy *lane-confirmation* stop exists, and it is G1 at the end of Shape.** (Heavy's full count is three — § 11.1.)

- **Lightweight / Medium.** One line, then continue: `Lane: {lane}. {trigger, or "no Medium or Heavy trigger fires"}. Say so if that is wrong.`
- **Heavy.** State the lane, name every trigger, state the consequence in plain English — stops, Codex review, confidential data, release step. **Then continue into a bounded Shape.** The stop is G1, where the operator has an evidence-backed package rather than a bare classification.

Operator Q6 said "stop at classification"; Q7 said "do not create a separate earlier lane-confirmation stop." Q7 is more specific and governs.

**Bound on pre-G1 Shape** (§ 9.2): no implementation, no external handoff, no trial using real confidential data.

### 6.6 Escalation — additive; nothing discarded

| From | To | What happens |
|---|---|---|
| Lightweight | Medium | State the trigger. Open the record, backfill from work done. Continue. No stop. |
| Light/Medium | Heavy, **during Frame or Shape** | State triggers. Open or upgrade the record. Continue to the end of a bounded Shape, then take G1. |
| Light/Medium | Heavy, **during Build, Prove or Land** | State triggers. Upgrade the record. **Stop immediately for G1**, naming exactly what is already built and committed. **Codex brief #1 is composed before that stop** — otherwise the operator is asked to confirm Heavy without the artifact G1 exists to review. Compose it from the record and the work already done; it will be shorter than a Shape-time brief, and say so. |

**Mandatory re-test points:** every phase boundary, and on discovering a second consumer, an external system, real confidential data, an irreversible step, a conflicting authority document, or a maintenance owner who does not exist.

### 6.7 De-escalation

Requires a trigger **disproven by evidence**, only at a phase boundary, never after an operator stop approved the heavier lane for that phase.

| From | To | Condition |
|---|---|---|
| Heavy | Medium | Every Heavy trigger disproven with cited evidence. **Requires operator acknowledgement — counted as an interaction in § 11.6, not a stop.** Work continues while awaiting it; if the operator disagrees, the lane reverts and any Heavy obligation skipped in the interim is named. |
| Medium | Lightweight | Every Medium trigger disproven. State and proceed. |

**Artifacts are never discarded on de-escalation.** Deleting a record to make a lane change look clean destroys the decision history that makes it auditable.

---

## 7. Detailed Lightweight process

**Governing feel:** one session, chat-first, no dedicated files, no subagents, no mid-run stops.

### Frame

1. **State the operating outcome in one sentence**, as a result. If the input names a system, restate it and say so.
2. **Inspect reality — bounded to four files total**, project `CLAUDE.md` first. Exceeding four is a finding to report, not licence to keep reading.
3. **Separate facts, inferences, unknowns.** Three short lists; facts carry paths; absence claims state the instrument (D11).
4. **Walk the intervention ladder** and name the rung: accept the limitation → **do the work manually** → change an operating habit → clarify ownership or information flow → reuse an existing capability → simplify or remove the source → narrow local improvement → bounded experiment → build. Say why not the rung below.

    **The manual rung is load-bearing, not a courtesy.** Systems Builder's own Core Operating Rule 4 states it: *"Manual work is acceptable during the MVP. A controlled manual process is preferable to premature infrastructure when the operating model has not yet been proven"* (`workflow.md:1018-1020`, F36). A capability whose workflow is undemonstrated should often stop here and be done by hand until it is — which is also what M1 and the § 14.7 trial exist to establish.
5. **Lane call** — state and proceed.

**Exit:** outcome, evidence, rung and lane stated. **A no-build, manual or reuse outcome exits here to Land** and is a success.

### Shape

6. **Name the one owner.** 7. **State the observable behaviour** — one to three bullets; this is the acceptance condition. 8. **State the exclusions** — one line.

### Build

9. **One complete slice** — a whole behaviour, useful on its own. If it will not fit one slice, that is M2; escalate. 10. **Implement the smallest coherent change.**

### Prove — before the commit

11. **Verify.** Read the artifact from disk — not from memory of writing it — against the Shape behaviour.
12. **Match evidence to claim.** Runtime → execution; file-scope → the diff; factual → the source; counts → mechanical derivation stating the command. Untested → **unassessed**, never passed.
13. **`/risk-check` if a mandatory class fired** (F8). Lane unchanged (§ 6.1).
14. **Commit the verified slice.** Commit directly, no pre-commit checks, no push. Verification before commit means the first commit records a verified result, not a draft plus a fix-up (`new-project.md:137`'s discipline).

### Land

15. **Demonstrate use.** Run it, or show the artifact doing its job, once. Show something visible.
16. **State the recommended status and ask for acceptance.** No mid-run stop, but **Claude does not declare adoption.** Present what was needed, what was built, what the demonstration showed, and the recommended status — adopt · keep local · close · reject, all terminal. Acceptance may be one word; it is never inferred from silence.

    **If the operator's answer is `revise`** — an ACTIVE status (§ 12.5) that Lightweight has no record to hold — the capability **escalates to Medium at that moment**: open a record, backfill it from the work already done, record the revision as the next action, and continue (§ 6.6's Lightweight → Medium path, which is additive and needs no stop). A Lightweight capability cannot carry an active status with no state; it becomes a Medium one that can.
17. **Record — after acceptance.** If durable behaviour changed, append **one** entry to `projects/{project}/logs/decisions.md` in its canonical shape, naming the capability, outcome and accepted status. If the outcome was no action and nothing durable was decided, write nothing.
18. **Commit the closing entry** (QC finding 7). One commit, message `update: {project} — capability {slug} closed as {status}`. Where step 17 wrote nothing, there is nothing to commit — say so.

**Planned stops: zero. Acceptance: required.**

---

## 8. Detailed Medium process

### Frame

1–4. As Lightweight, with a **twelve-file** budget: project `CLAUDE.md`, `logs/decisions.md`, authority documents touched, existing `development/*.md` records.
5. **Existing-capability disposition.** Search by purpose and behaviour with a stated instrument and search space. Disposition every near-match as **covers it · covers part of it · adjacent but different**, with the path. Reuse beats build.
6. **Lane call** — state and proceed.
7. **Open the record** at `projects/{owner}/development/{slug}.md`, phase `frame`, status `in-development`.

**Exit:** record holds verified need, facts/inferences/unknowns, rung, lane, rationale. No-build closes it `status: rejected` and exits to Land.

### Shape

8. **Terminology** — only consequential terms that could mean two things. 9. **Ownership** per § 5.3, with cited evidence. 10. **Seam** — Input · Output · Owning capability · External dependencies · Observable failure states · Side effects · How tested.
11. **Real-case trial — required when M1 fired.** One genuine case, by hand or with temporary tooling, per § 12.8 data handling. **Stop condition: a trial that does not produce a useful result stops the build.** Record the result, including a negative one, and re-enter step 4.
12. **Thin implementation package** into the record — eleven short fields: verified need · intended outcome · users · public interface · observable behaviours · ownership and dependencies · smallest useful version · exclusions · verification · adoption condition · retirement condition. It does not dictate functions, files or abstractions.
13. **Vertical slices** — two to five complete behaviours, ordered, each independently testable and separately committable. Slicing by layer is wrong.
14. **AI-resource handoffs identified now** as § 14.3 briefs.

### Build

15. **Per slice: reproduce-or-fail → implement → refactor → verify → update the record → commit.** The record update is **inside** the cycle, before the commit — a commit whose record points at the previous slice is a resume hazard.
16. **Fire § 14.3 handoffs** as needed; resume the slice on return.
17. **Scope discipline.** A material scope change is a recorded decision, not a longer diff; if it alters the seam or exclusions, re-test the lane.

### Prove

18. **Self-review — both questions, separately** (§ 16.3). 19. **Match evidence to claim**; mark every claim observed · unassessed · blocked. 20. **`/qc-pass`** with an explicit scope line; on agent-type failure use the `qc-pass.md:24` fallback and label the verdict. 21. **`/risk-check`** if a class fired. 22. **Simplify**, then rerun affected cases.

### Land

23. **Real use** — used at least once for its actual purpose; outcome observed and recorded.
24. **Operator stop G3 — the lifecycle decision.** One of the eight Land-selectable statuses (§ 14.8) — five terminal, three active. An active choice requires a stated next action; `paused` additionally requires a reopening trigger.
25. **Record closure** — status into frontmatter and `## Lifecycle status`; one `logs/decisions.md` entry. Remove nothing.
26. **Commit the closure** (QC finding 7): `update: {project} — capability {slug} closed as {status}`, carrying the record update and the decisions entry in one commit.

**Planned stops: one.**

---

## 9. Detailed Heavy process

### 9.1 Frame (deeper)

1–5. As Medium, plus: **consumer inventory** (a dependency is not a consumer; a non-existent consumer is not a consumer); **authority inspection** citing the clause that grants or denies ownership for every project touched; **reversibility statement** per irreversible-looking step; **data-flow statement** if H2 fired — data class, authoritative system, flow, what may not leave Axcíon's boundary, what may go to which external model.
6. **Lane announced, not stopped** (§ 6.5). 7. **Open the record**, lane `heavy`.

**Exit, or route out:** if § 5.3 finds no legitimate owner, or the work is a new enduring programme, take § 14.1 and stop, naming the failing criterion.

### 9.2 Shape (bounded, then G1)

**Hard limits before G1:** no implementation; no external handoff (§ 14.2, § 14.3, § 14.9); no trial using real confidential data. A synthetic trial may run; a real-data trial waits.

8–14. As Medium, strengthened: **seam at two levels** — technical (interfaces, data, failure states) and operating (who decides what, which system is the official record, what a human must approve); **trial mandatory** unless already demonstrated in production; **package durable and versioned**; **release plan** — how it first enters real use, and the rollback path.

15. **Compose Codex brief #1** (§ 16.4) → `WORKDIR`, never the repository.

16. **OPERATOR STOP G1 — scope and package approval.** Present the package, the lane and triggers, the consequence, and brief #1's path. The operator confirms Heavy, approves scope, and takes the brief to Codex.

17. **Adjudicate findings.** Claims to be tested, not instructions. Verify each against the repository, then disposition: accept and fix · accept and defer with a concrete trigger · reject with cited evidence. Record all. Only business-risk or maintenance-burden disagreements reach the operator.

18. **Formal planning handoff** (§ 14.2) if warranted — after G1.

### 9.3 Build

19–22. As Medium, plus: **failure and recovery behaviour implemented as a slice**, not documented as intention; **confidential material never enters the repository** (§ 12.8); commit per slice with the record update inside.

### 9.4 Prove

23–27. As Medium, plus **behavioural, integration, failure and recovery testing** — integration exercises the real seam; failure confirms visible recoverable failure; recovery confirms the stated undo works. **`/risk-check` at both gates** when a class was touched. **Codex brief #2** on the implemented result.

28. **OPERATOR STOP G2 — release / real-trial approval.** Present the result, the evidence table, verdicts, the release plan, the rollback path, brief #2's path.

### 9.5 Land

29. **Controlled release / limited trial** as approved. 30. **Observe and record the outcome.**
31. **OPERATOR STOP G3 — lifecycle decision**, plus a restated retirement condition and rollback method.
32. **Record closure and closing commit** as Medium 25–26, plus consumer confirmations (F22) if a shared resource changed.

**Planned stops: three.**

---

## 10. Shared lifecycle invariants

| # | Invariant | SOP step | Lightweight | Medium | Heavy |
|---|---|---|---|---|---|
| 1 | Start from the operating outcome | 1 | one sentence | + record | + record |
| 2 | Inspect reality before planning | 2 | 4 files total | 12 files | + consumers + authority |
| 3 | Separate facts, inferences, unknowns — **absence claims state the instrument** | 2.2 | three lists | recorded | recorded + reviewed |
| 4 | Intervention ladder including no-build | 3 | name the rung | + disposition near-matches | + consumer-aware |
| 5 | Real case before permanent implementation when undemonstrated | 4 | escalates | required on M1 | mandatory; synthetic pre-G1 |
| 6 | Terminology, one owner, small seam | 5 | owner named | 7-field seam | + operating seam |
| 7 | Thinnest package for the lane | 6 | 3 lines | 11 fields | durable, approved, reviewed |
| 8 | Complete vertical behaviours, not layers | 8 | one slice | 2–5 ordered | + failure/recovery |
| 9 | One slice at a time, **verify → record → commit** | 9 | verify → commit | verify → record → commit | same |
| 10 | Match evidence to claim type | 10 | inline | per claim | + independently reviewed |
| 11 | Independent review by consequence | 7, 11 | none unless a class fires | `/qc-pass`, `/risk-check` | Codex ×2 + `/risk-check` |
| 12 | Real operating use before adoption | 12 | demonstrate once | real use, observed | controlled release |
| 13 | Explicit status, **accepted by the operator** | 13 | recommend → accept | operator (G3) | operator (G3) |

14. **Conflicts are surfaced, not silently resolved.** 15. **A control that cannot run reports "unassessed," never "passed."** 16. **Systems Builder's workflow and authority documents are never edited** (D14); sandbox records and artifacts under `cases/{name}/development/` are the command's own to write.

---

## 11. Operator gates, interactions and decisions

### 11.1 The complete table

| Lane | Planned **stops** | Where | Possible **interactions** (§ 11.6) |
|---|---|---|---|
| Lightweight | **0** | — | Acceptance of the demonstrated outcome (always) |
| Medium | **1** | G3 | Acceptance is the stop. Plus: multi-record disambiguation; de-escalation acknowledgement |
| Heavy | **3** | G1 · G2 · G3 | Plus: multi-record disambiguation; de-escalation acknowledgement; carrying a Codex brief; carrying a sibling change request (§ 14.9) |

**No other planned stop exists.** No separate lane-confirmation stop; no stop for a passing verdict; no per-slice approval; no stop for terminology, seams or slice ordering. **And no stop inside a handoff** — § 18.3's clauses reassign *both* of `/develop-ai-resource`'s Step 4 gates so neither reappears as an uncounted stop.

### 11.2 What each stop asks

- **G1 (Heavy, end of Shape).** *Is this worth doing at this weight, with this scope, owned here, excluding these things?* Includes Heavy confirmation and Codex brief #1.
- **G2 (Heavy, end of Prove).** *May this enter the real operating environment?* Includes brief #2 and the rollback path.
- **G3 (Medium and Heavy).** *Given what actually happened when it was used, what status does this carry?*

### 11.3 Exceptional pauses

Failure conditions, reported as such: an adverse review verdict · a blocking unknown no evidence can close (produce a requirements doc and stop) · a material scope change altering seam, owner or exclusions · two authoritative sources in genuine conflict · escalation into Heavy during Build or later · a confidentiality question the rules do not answer · *(not a whole-capability pause: an open Systems Builder register item pauses only the slices that depend on it — § 14.10, AT-32)* · any of the ten workspace pause triggers.

### 11.4 What the operator is never asked

File structures, schemas, directory names, integration design, test selection, slice ordering, whether to run `/qc-pass`, which agent to spawn, or to validate a recommendation.

### 11.5 Acceptance in Lightweight

A **stop** halts work until the operator responds. **Acceptance** is the operator agreeing a demonstrated outcome is useful — only they can give it. Lightweight ends by demonstrating and stating a **recommended** status; it becomes final on acceptance, never inferred from silence. Until accepted, no `logs/decisions.md` entry is written and nothing is recorded as adopted.

### 11.6 Interactions, counted honestly (QC finding 6)

An **interaction** asks the operator for something while work may continue or while no decision about the capability's fate is being made. It is not a stop, but it is not free either, and hiding it was a v2 defect.

| Interaction | When | Work continues? |
|---|---|---|
| Multi-record disambiguation | Resume finds >1 active record (§ 15.1) | No — but this is disambiguation, not a decision about the work |
| De-escalation acknowledgement | Heavy → Medium (§ 6.7) | **Yes** — the lane reverts if the operator disagrees |
| Carrying a Codex brief out and findings back | Heavy G1, G2 | No — but it rides on an existing stop |
| Authorising a sibling change request (§ 14.9) — the operator approves and opens the sibling session; a Claude session there executes it | H3 "a second project must change" | Yes, for slices that do not depend on it |
| Lightweight acceptance | Every Lightweight capability | No |

Expected worst case for a Heavy capability: **3 stops + up to 4 interactions.** Stated so the operator can price it before G1.

---

## 12. State and artifact model

### 12.1 Discovering authoritative state

1. **Project `CLAUDE.md`** (26 of 27). 2. **`development/*.md`** — and, in a sandbox host, **`cases/*/development/*.md`** — in the active-status set. 3. **`logs/decisions.md`** (26 of 27) — tail plus a grep for the need's terms. 4. **Authority documents the need touches.** 5. **`pipeline/project-plan.md`** only if a plan spine is relevant, bounded read. 6. **For an *adopt-from-case* entry: the Systems Builder case artifacts** (§ 14.10), read-only.

**Not read as live state: `pipeline/pipeline-state.md`** (F14, operator Q9).

**Read budget:** four files at Lightweight, twelve at Medium and Heavy, plus the case artifacts named by an *adopt-from-case* invocation. Exceeding it is reported.

### 12.2 Lightweight — zero dedicated files

The changed artifact, committed · git history · **one** `logs/decisions.md` entry, only if durable behaviour changed **and** the status was accepted · nothing when the outcome is no action.

### 12.3 Medium and Heavy — one record per capability

`projects/{owner-project}/development/{slug}.md`, name provisional pending `/placement`. Created in Frame. Template `ai-resources/templates/capability-record.md`.

**One exception — the Systems Builder sandbox.** A capability entered via `adopt-from-case` is stewarded inside its case: `projects/axcion-systems-builder/cases/{name}/development/{slug}.md`. Same schema, same lifecycle; only the location and the `stewardship: sandbox` marker differ. It relocates to the generic path at graduation (§ 14.11). Every other project uses the generic path.

### 12.4 Record schema

```markdown
---
capability: {slug}
name: {human-readable name}
lane: lightweight | medium | heavy
phase: frame | shape | build | prove | land
status: {one of nine — § 12.5}
reopen_trigger: {required when status is paused}
owner_project: {project-name — the steward while stewardship is sandbox}
stewardship: sandbox | permanent
permanent_owner: {set only while stewardship is sandbox; "pending — /new-project at Phase 14"}
transferred_from: {set only after graduation, § 14.11}
source_case: {path to a Systems Builder case, when entered via adopt-from-case; else omit}
opened: YYYY-MM-DD
updated: YYYY-MM-DD
---

# {Name}

## Operating outcome
## Verified need
### Confirmed facts (path + instrument for any absence claim)
### Reasonable inferences (with basis)
### Unknowns (with what would close them)
## Adopted case material          — omit unless entered via adopt-from-case
Which artifacts were consumed, their state at consumption, and what was NOT re-derived.
## Lane
Dated, append-only: date · lane · trigger · escalation or de-escalation.
## Ownership and seams
## Public interface
Input · Output · Owning capability · External dependencies · Observable failure states ·
Side effects · How tested.
## Approved scope and exclusions
## Implementation package
## Vertical slices
- [ ] S1 — {complete behaviour}
## Verification evidence
| Claim | Evidence type | Result | Where |   — observed · unassessed · blocked
## Independent review
Round · date · subject · findings · disposition of each. Briefs are not stored here.
## Change requests                — new in v3, QC finding 2
Round · sibling project · the request VERBATIM · disposition · returned evidence.
## Decisions
### D1 — YYYY-MM-DD — {title}
**Status:** active | superseded by D{n} (YYYY-MM-DD)
## Current phase and next action
## Real-use result
## Lifecycle status
## Pointers
Plans, specs, review reports, case artifacts — by path, never copied.
```

### 12.5 The canonical status set

**Defined once. Every consumer references this section.**

| Status | Class | Meaning |
|---|---|---|
| `in-development` | **ACTIVE** | Work under way |
| `continue-trial` | **ACTIVE** | More evidence required |
| `revise` | **ACTIVE** | Useful, needs a bounded correction |
| `paused` | **ACTIVE** | No immediate reason to continue. **Requires `reopen_trigger:`** |
| `adopted` | TERMINAL | Part of normal operations |
| `keep-local` | TERMINAL | Useful in one project only |
| `closed` | TERMINAL | Purpose achieved |
| `retired` | TERMINAL | No longer justifies its burden; machinery removed |
| `rejected` | TERMINAL | Should not exist, or routed elsewhere |

**ACTIVE-STATUS-SET** = `in-development` · `continue-trial` · `revise` · `paused`. Discovery, resume and listing match the **whole** set. `paused` without a `reopen_trigger:` is **malformed** — reported, not auto-repaired. Reaching a terminal status is the only way to leave the active set.

### 12.6 Record vs. mission vs. decisions log vs. case

| Artifact | Answers | Written by |
|---|---|---|
| `development/{slug}.md` | *What is this capability, where does it stand, what next?* | `/develop-capability` |
| `cases/{name}/01–06` | *What should be built, and why?* | Systems Builder + the operator. **Read-only to `/develop-capability`** (D14) |
| `cases/{name}/development/{slug}.md` | *Where does execution stand while the capability is hosted in the sandbox?* | `/develop-capability`. Its own file, in the sandbox, transferred out at graduation (§ 14.11) |
| `logs/missions/{id}.md` | *What multi-session goal does this session serve?* | `/mission` only |
| `logs/decisions.md` | *What did we decide, and why?* | any session |

### 12.7 No registry

Discovery is a glob over `development/*.md` **and** `cases/*/development/*.md` frontmatter, filtered by the active set. Both patterns, always — a sandbox record found by only one of them is a record that cannot be resumed. No index, no register. More than roughly a dozen records in one project signals the project should split.

### 12.8 Confidential data and generated artifacts

**Corrected premise.** v1 and v2 claimed "the session scratchpad is outside the repo." False: `/wrap-session` Step 0.5 writes continuity scratchpads to `logs/scratchpads/` **inside** the repository (F24), gitignored but present, and gitignored is one `git add -f` from exposure.

**The rule.** Confidential material never enters any repository path. It stays in the source system, an external tool, or an explicitly created OS temp directory:

```bash
WORKDIR=$(mktemp -d "${TMPDIR:-/tmp}/axcion-capability-XXXXXX")
```

The command states `WORKDIR` in chat.

| Rule | Applies |
|---|---|
| Confidential material stays in the source system, an external tool, or `WORKDIR` — never any repo path | all |
| Generated review briefs and change requests are composed in `WORKDIR`; only their **content** is recorded in the record | Medium, Heavy |
| Minimum necessary record; prefer synthetic when it tests the same behaviour | Medium, Heavy |
| Name the authoritative source for every data class | Medium, Heavy |
| Never copy raw buyer, CRM, email or relationship data into a committed artifact | all |
| Durable records carry decisions, schemas, evidence summaries, redacted or synthetic examples only | Medium, Heavy |
| Name the system that remains the official record | Heavy |
| State what may and may not be sent to which external model or tool | Heavy |
| **Wrap-time constraint (QC finding 4).** In any session that handled real confidential material, state before `/wrap-session` that the continuity scratchpad must carry **no** buyer, contact, message or relationship content — decisions and next actions only. `/wrap-session` Step 0.5 derives it from conversation automatically and does not ask (F24). | Medium, Heavy |
| Dispose of `WORKDIR` at session end, or state its path so the operator can | Medium, Heavy |

**Residual risk, named not solved.** `/wrap-session` Step 0.5 is outside this command's control. The constraint above is a session behaviour, not an enforced control, and it is carried in R9 as an accepted residual risk rather than claimed as a mitigation.

---

## 13. Command–skill architecture

### 13.1 Split

**`ai-resources/.claude/commands/develop-capability.md`** — 150–220 lines, `model: opus`. Owns invocation and arguments · project and state discovery · **`adopt-from-case` intake** (§ 14.10) · **graduation transfer** (§ 14.11) · resume detection · lane routing and announcement · phase orchestration · operator gates and interactions · handoff execution and resumption · record read/write · `WORKDIR` lifecycle · reporting · failure behaviour.

**`ai-resources/skills/capability-development/SKILL.md`** — `model: opus`, `effort: high`, `disable-model-invocation: true`. Owns the definition of *operating capability* · the five named phases · lane-by-lane requirements and completion conditions · the intervention ladder · trial design and its stop condition · ownership and seam method (§ 5.3, absence-is-not-evidence including the instrument rule, dependency-is-not-a-consumer) · slice standards · the evidence-to-claim table · lifecycle standards · data handling · failure behaviour · worked examples.

### 13.2 Why a skill

**Size** — a self-contained command lands at 400–500 lines, the class that made `/new-project` hard to maintain. **Read-when-needed** — the lane is decided before lane-specific methodology is required. **Established pattern** — `/scope-project` does exactly this (`scope-project.md:11`). **Durable vs. perishable** — Principle 8; the skill holds method, the command holds orchestration, which is where model-steering scaffolding accumulates and can later be thinned.

### 13.3 One command

`disable-model-invocation: true` (the protection `grill-me/SKILL.md:10` uses) means the skill cannot be auto-triggered and is reachable only by the command.

### 13.4 No agent

A fourth reviewer would overlap `qc-reviewer`, `risk-check-reviewer` and `system-owner`, and would be a detector needing its own closer (OP-12). Heavy's independence comes from Codex.

### 13.5 Model tiering

Both declare an explicit tier and inherit nothing (F26). No `model` field in any settings file; no project `CLAUDE.md` Model Selection section (F27).

---

## 14. Handoff contracts

Each states **trigger · out · back · next · must not**.

### 14.1 Really a new project or an undefined system

- **Trigger.** § 5.3 finds no legitimate owner; the work is a new enduring programme; or the *definition* is not yet approved and no case exists.
- **Out.** Frame output — outcome, verified need, facts/inferences/unknowns, the failing owner criterion, the ladder rung — to **Systems Builder Phase 4** when a system needs defining, or to `/scope-project` **Stage 0** (its gated route check, F20) when a project needs scoping.
- **Back.** Nothing; terminal exit.
- **Next.** Close any record `status: rejected` naming the routing target and the failing criterion. Report the route in one line.
- **Must not.** Create the project. Write into `projects/project-planning/`. **Create or populate a case in `projects/axcion-systems-builder/`** — the operator opens the case there (F38: case material is captured by hand). *(This is a route-out, so no case and no sandbox exist yet; it does not restate a blanket no-write rule — D14 permits sandbox writes under `cases/{name}/development/` once a case is being hosted.)* Leave the capability "open pending a project."

### 14.2 Formal project planning

- **Trigger.** Heavy, after G1, warranting a control pack or specification.
- **Out.** The approved package plus the record path, to `/scope-project` or the `/plan-draft` chain. `projects/project-planning/` must be mounted or the handoff stops before any write there.
- **Back.** Paths to produced artifacts.
- **Next.** Record under `## Pointers`. Never copy them in. Resume Shape where interrupted.
- **Must not.** Re-derive the plan in-command; let planning output replace the record as source of truth.

### 14.3 AI-resource sub-need — upstream mode

- **Trigger.** A slice needs an AI artifact that does not exist, including a project-local one (M4).
- **Out.** A brief in `/develop-ai-resource`'s qualified shape (`:80-87`) plus three fields, **invoked via the Skill tool** — the idiom that command itself uses to reach its engines (`:65`):

```markdown
**Mechanism:** {the rung and why not a lower one}
**Evidence:** {cited, or "speculative"}
**Capability:** {slug} — owner {project} — record: {absolute path, resolved by
  ancestor walk-up to the nearest ancestor holding both ai-resources/ and projects/,
  the idiom at develop-ai-resource.md:49}
**Settled upstream:** operating outcome, need validation, ownership and seam, and the
  business-adoption decision. Do not reopen. Qualify the ARTIFACT only, and return the
  artifact disposition to /develop-capability rather than taking any decision to the operator.
**Artifact scope:** {exactly what to author, and what not to}
```

- **Back.** The **artifact** judgement — is it well made, does it do what it claims, what was tested and observed — plus the path. **No operator decision, on either Step 4 branch.**
- **Next.** Claude adjudicates, records under `## Pointers` and `## Verification evidence`, resumes the slice. An artifact judged unfit is a **material scope change**: record it and re-test the lane.
- **Must not.** Call `/create-skill`, `/improve-skill` or `/migrate-skill` directly. Author a skill in-command. Let `/develop-ai-resource` reopen the operating need, re-run capability qualification, or take **any** disposition to the operator — including the *no candidate was built* Accept/Reconsider gate at `:121` and the external-resource decision at `:125`.

### 14.4 Project-local implementation (QC finding 8 — completed)

- **Trigger.** The default; built inside the owning project.
- **Out.** Nothing leaves the command.
- **Back.** Nothing.
- **Next.** Proceed through the slice cycle; the record and the commits are the whole record of it.
- **Must not.** Write into another project's tree, even when the capability depends on it — § 14.9 is the compliant path.

### 14.5 Shared capability (QC finding 8 — completed)

- **Trigger.** H6 fired.
- **Out.** For a shared AI resource: § 14.3, placement per `docs/repo-architecture.md:183-198`. For a later promotion of something built project-local: `/graduate-resource`.
- **Back.** The canonical path and, for a promotion, `/graduate-resource`'s outcome plus the consumer confirmations it required (F22).
- **Next.** Record the canonical path under `## Pointers`, the consumer list and each confirmation under `## Verification evidence`. Where a confirmation is refused, that is a material scope change — record it and re-test the lane.
- **Must not.** Generalise on one confirmed consumer. Graduate in-command.

### 14.6 Independent review

- **Trigger.** Prove is reached in any lane, or a Heavy capability arrives at G1 or G2. The lane and the claim decide the mechanism, per the table below.

| Lane | Mechanism | When |
|---|---|---|
| Lightweight | none unless a mandatory class fired | Prove |
| Medium | `/qc-pass`; `/risk-check` if a class fired | Prove |
| Heavy | Codex brief #1 (package) and #2 (result); `/risk-check` both gates; `/qc-pass` where an artifact warrants it | riding on G1 and G2 |

- **Out.** A self-contained brief composed in `WORKDIR`, plus chat instructions.
- **Back.** Findings, pasted by the operator.
- **Next.** Verify each against the repository, then disposition: accept and fix · accept and defer with a trigger · reject with cited evidence. Record every disposition under `## Independent review` — which is what makes a lost brief regenerable.
- **Must not.** Create a reviewer agent; imitate Codex inside Claude; treat findings as instructions; put confidential material in a brief.

### 14.7 Real-use trial

- **Trigger.** M1 (Medium) or mandatory (Heavy — synthetic before G1, real data after).
- **Out.** One real case, working in `WORKDIR`.
- **Back.** An observed result, including a negative one.
- **Next.** Record it. **A trial that does not produce a useful result stops the build.** Re-enter the ladder.
- **Must not.** Let trial material reach any repository path; treat a trial that "sort of worked" as validation.

### 14.8 Adoption, closure, retirement

- **Trigger.** Land, after observed real use.
- **Out.** To the operator at G3, or as a recommendation requiring acceptance at Lightweight.
- **Back.** One of the **eight statuses selectable at Land**: five **terminal** — `adopted`, `keep-local`, `closed`, `retired`, `rejected` — and three **active** — `continue-trial`, `revise`, `paused` — which keep the record in the ACTIVE-STATUS-SET and therefore require a stated next action. (`in-development` is not selectable here.) Calling all eight "terminal" was a v3 error.
- **Next.** Write the status; append one `logs/decisions.md` entry; commit both together; for Heavy restate the retirement condition and rollback method. For **retire**, remove the machinery and record what was removed.
- **Must not.** Mark adopted without observed real use and operator acceptance. Leave a record active after work stopped without converting it to `paused` **with** a reopening trigger.

### 14.9 Sibling-project change request

- **Trigger.** H3 in the form "a second project must change."
- **Out.** A bounded, self-contained change request, composed in `WORKDIR` **and written verbatim into the record's `## Change requests` section** (QC finding 2), so it survives the session and is regenerable:

```markdown
# Change Request — {sibling project} — for capability {slug}
**Requesting capability:** {slug}, owner {project}, record: {path}
**Why needed:** {the operating outcome that requires it}
**Authority:** {the clause in the sibling's own authority document permitting this — cited;
  or an explicit statement that none exists and the sibling's operator must decide}
**Exact change requested:** {files, and what changes in each}
**What must NOT change:** {the sibling's boundaries this does not touch}
**Evidence to return:** {a diff, a commit SHA, a test result}
**If declined:** {what the requesting capability does instead — must be answerable}
```

- **Back.** The named evidence — a diff, a commit SHA, a test result — produced by the sibling session and carried back by the operator.
- **Next.** Record it under `## Change requests` (disposition + returned evidence) and `## Verification evidence`. Resume the dependent slice.
- **Receiving mechanism, named (QC finding 2; executor corrected in v3.1).** **The operator carries and authorises it; a Claude session opened in the sibling project executes it.** Patrik does not hand-implement the change — he decides that it may happen and opens the session where it does. The requesting `/develop-capability` run never opens that session and never writes into the sibling tree. Counted as an **interaction** in § 11.6.
- **Must not.** Write into the sibling tree; treat the sibling as a co-owner. **One capability, one owner.** If the `If declined` branch is unanswerable, the capability is not viable and Frame's owner selection was wrong.

### 14.10 `adopt-from-case` — consuming Systems Builder material (new in v3)

- **Trigger.** The capability's definition already exists as a Systems Builder case, and the operator invokes `/develop-capability adopt-from-case projects/axcion-systems-builder/cases/{name}/`.
- **Out.** Nothing leaves. This is an **intake**, and it opens the capability **inside the sandbox** (D14).
- **Back.** The consumed artifacts as settled input, plus an explicit list of what was absent and what was therefore *not* re-derived — recorded under `## Adopted case material`. Nothing returns from an external party; the "back" of an intake is what the record now holds.
- **In — the mapping.** Case artifacts become settled input; the corresponding Frame and Shape work is **read, never re-derived**:

| Case artifact | Becomes | Not re-derived |
|---|---|---|
| `02-detailed-needs-document.md` | Verified need · intended outcome · users | Frame steps 1–4 for anything it settles |
| `03-clean-system-definition-v2.md` | Approved scope · exclusions | Shape's package fields it covers |
| `04-mvp-scope-and-product-roadmap.md` | **The vertical slices** and the first-slice boundary | Shape step 13's slice authoring |
| `05-approved-solution-definition-v3.md` | Technical seam · external dependencies | Shape step 10's technical seam |
| `06-implementation-brief.md` | The execution handoff; acceptance criteria | Shape step 12 |
| `01-consolidated-scoping-notes-v1.md` | Historical context only — **never a requirement source** | — |

- **Entry point.** With `04` and `06` approved, the capability enters at **Build**. Frame runs only to confirm the owner, the lane and the seam against *current* reality, and to record what was adopted.
- **Partial cases — the normal state today, and the lifecycle still runs.** `email-system` has `01` and `02`; `03`–`06` are stubs (F39). `contacting-operations` has `01` only (F40). The command **must not** treat a stub as an approved artifact — read each artifact's `**Status:**` line; anything reading *not started* is absent. With `02` approved but `04` absent, the capability enters at **Shape**, using `02` as the verified need and authoring its own slices, recording explicitly that the MVP boundary was unavailable and that its slices are provisional against a future `04`. **This is a real lifecycle run, not a dry run.** It advances as far as approved material permits and stops where a specific approval is genuinely missing — not at the first absence.
- **Where the record and artifacts live — the sandbox.** `projects/axcion-systems-builder/cases/{name}/development/{slug}.md`, with implementation artifacts under `cases/{name}/development/` at paths the record names. It sits inside the case because that keeps one system's material together and makes graduation a single directory move. **State the authority honestly: this is an operator override, not compliance with the host's convention.** `axcion-systems-builder/CLAUDE.md:97` says a case's documents are captured *"by hand"* and the folder is "deliberately just files", and `cases/README.md:26` says *"do not add files a case does not need"*. The operator authorised a command-written `development/` subdirectory on 2026-07-28. An implementer reading D14 and F38 must not conclude the host's own documents sanction it — they do not. **Systems Builder is the steward, not the permanent owner:** frontmatter carries `owner_project: axcion-systems-builder`, `stewardship: sandbox`, and `permanent_owner: pending — /new-project at Phase 14`.
- **What pauses, and what does not.** An **open register item the capability actually depends on** pauses the slices that depend on it — `email-system` A2 (who builds and operates it) and A3 (the compliance source) are open (F39), and neither may be resolved by inference. **The absence of the future permanent project pauses nothing.** Sandbox stewardship exists precisely so execution is not gated on a project that Phase 14 has not yet created.
- **Next.** Record everything consumed, its state at consumption, and **what was not re-derived**, under `## Adopted case material`. Set `source_case:`, `stewardship: sandbox` and `permanent_owner:`.
- **Must not.** Edit `workflow.md`, `engine.md`, `CLAUDE.md`, `cases/README.md` or any numbered case artifact `01`–`06` (D14). Re-run Phases 4–13. Reopen an operator-approved definition. Treat a stub as content. Resolve an open register item by inference. Leave a stewarded capability un-transferred once its permanent project exists (§ 14.11).
- **Review credit.** A case that has passed its Codex reviews has had its **definition** independently reviewed. Heavy's briefs therefore target the **built result and the release**, not the package — which is how six total Codex rounds stay proportionate (§ 3.4, U4).

### 14.11 Graduation transfer — sandbox steward → permanent owner (new in v3.1)

- **Trigger.** A capability stewarded in the sandbox has a permanent project — `/new-project` has created it from the case's Phase-14 package — **or** the operator names a different permanent owner. Graduation is a *relocation of ownership*, not a lifecycle status: a capability may graduate while still `continue-trial`.
- **Out.** The capability record and every implementation artifact it names, from `cases/{name}/development/`.
- **Back.** The permanent project's path.
- **Next — five steps, in order.**
  1. Move the record to `projects/{permanent}/development/{slug}.md`.
  2. Move the implementation artifacts the record names, preserving relative structure.
  3. Update frontmatter: `owner_project:` → the permanent project; `stewardship: permanent`; `transferred_from: projects/axcion-systems-builder/cases/{name}/`; drop `permanent_owner:`.
  4. Record the transfer as a dated decision in the record's `## Decisions` — what moved, from where, to where, and on whose authority.
  5. Leave **one** file behind at `cases/{name}/development/TRANSFERRED.md`: the date, the destination path, and one line of what moved. This is the command's own file, not a Systems Builder authority document, so D14 permits it — and without it the case silently loses the thread to work that started there.
- **Commit.** One commit per repo: the removal in `axcion-systems-builder`, the addition in the permanent project. Both message-prefixed `update:` and cross-referencing each other by slug.
- **Must not.** Copy rather than move — two records for one capability is the duplicate-state failure § 15.4 stops on. Edit any frozen Systems Builder surface (D14). Change the capability's lane, phase, status or evidence during transfer: **graduation moves a record, it does not re-judge one.** Transfer while a slice is mid-flight — finish or explicitly park the slice first, so the moved record is coherent.
- **If the permanent project never arrives.** A capability can legitimately live out its whole life in the sandbox and reach a terminal status there — a `rejected` or `closed` capability never graduates. Stewardship is not a promise of graduation.

---

## 15. Failure, pause and resume

### 15.1 Resume

1. Glob **both** `projects/{cwd-project}/development/*.md` **and** `projects/{cwd-project}/cases/*/development/*.md`; frontmatter only. The second pattern is what makes a sandbox-stewarded capability resumable (§ 12.3); without it the EmailOS pilot's record is invisible to resume and adoption condition 4 is unreachable.
2. Filter to the **ACTIVE-STATUS-SET** — never a single status.
3. **Zero** → treat any argument as a new need; with none, ask once and wait.
4. **Exactly one** → resume: `Resuming {name} — lane {lane}, phase {phase}, status {status}. Next: {next action}.` If `paused`, state the reopening trigger and confirm it is met.
5. **More than one** → list name, lane, phase, status, next action; ask which, one prompt. **Counted as an interaction** (§ 11.6). Never guess.
6. **Graduation check.** For every record resumed or listed that carries `stewardship: sandbox`, test whether its `permanent_owner:` now resolves to an existing project. If it does, surface **graduation (§ 14.11) as the next action** before any other work. This is the second of the two paths to `graduate` named in § 4.2.

### 15.2 What makes resume work

The record's phase, next action and `updated:` are written **inside each slice cycle, before its commit**, not at session end.

### 15.3 Session boundaries

At the end of any session with an active Medium or Heavy capability: the record is current before wrap, and chat states capability, lane, phase, next action. Plus the § 12.8 wrap-time confidentiality constraint where real data was handled. Per workspace `CLAUDE.md` § Context constraint deferral: update the record, flag the deferral, stop.

### 15.4 Failure behaviour

| Failure | Response |
|---|---|
| No project identifiable | Ask once, listing plausible candidates. Do not guess or default to the workspace root. |
| Owner project does not exist | Stop. Report. Do not create it. |
| `development/` absent | Create only when the first Medium/Heavy record is written. |
| Record frontmatter malformed | Report the specific malformation and path. Do not auto-repair. |
| `paused` with no `reopen_trigger:` | Malformed. Report; ask for the trigger. Do not invent one. |
| Two records claim the same capability | Stop; report both paths; the operator decides. Never merge. |
| **`adopt-from-case` path is not a case directory** | Stop. Report what was found. Do not guess a sibling path. |
| **A named case artifact is a stub** | Treat as absent per § 14.10; state which, and what the command will author instead. |
| **A case register item is open** | Pause **only the slices that depend on it**, naming the item; slices that do not depend on it proceed (§ 14.10, AT-32). Never infer an answer. A capability does not halt wholesale because one register item is open. |
| `/develop-ai-resource` returns an unfit artifact | Material scope change; record, re-test the lane, re-plan or pause. |
| A trial produces no useful result | Stop the build; record the negative result; re-enter the ladder. A success of the method. |
| A sibling declines a change request | Execute the `If declined` branch. If unanswerable, the capability is not viable — report and stop. |
| Codex unavailable or declined (Heavy) | Record independent review **unassessed**, not passed. Never substitute a Claude subagent and call it independent. |
| `qc-reviewer` type fails to resolve | Use the `qc-pass.md:24` fallback; label the verdict. |
| `/risk-check` returns `RECONSIDER` | Exceptional pause. Surface the report path and findings. |
| Context exhausted mid-phase | Update the record, state position, defer. |
| Operator corrects the lane | Record as a decision with `Decided by: operator`; continue in the corrected lane. |
| Defect found after a commit | Report as paused; no corrective commit in the same run (`new-project.md:139`). |

### 15.5 Recoverability posture

Every slice is verified, recorded and committed as one unit. No confidential material enters the repository. Nothing is deleted to tidy up. A failure found three sessions later costs at most one slice.

---

## 16. Review and verification model

### 16.1 Governing rule

**Evidence must match the claim type.** Runtime → execution. File-scope → the diff. Compatibility → a representative test. Factual → the source. Usage → every relevant location. **Counts → mechanical derivation stating the command.** **Absence → the instrument and the search space, stated** (D11, § 2.1.1). A control that cannot run is **unassessed**.

### 16.2 Depth by lane

| | Lightweight | Medium | Heavy |
|---|---|---|---|
| Self-review | inline, both questions | recorded | recorded |
| Fresh-context Claude | — | `/qc-pass` | where an artifact warrants it |
| Structural risk | if a class fired | if a class fired | both gates |
| Independent model | — | — | **Codex ×2** |
| Behavioural / integration / failure / recovery | behaviour only | + integration if a seam exists | all four required |

**Two Codex rounds, but only on a real Heavy trigger.** A capability reaching Heavy by escalation gets both. Nothing gets a round for a lane label alone. A capability entering via *adopt-from-case* has had its definition reviewed already (§ 14.10); its rounds target the built result and the release.

### 16.3 The two self-review questions

Kept separate in every lane. **(1) Is it well made?** — clear purpose and scope; small interface; one owner per responsibility; no duplicated behaviour; proportionate architecture; tests coupled to outcomes not internals; every control demonstrated in its real invocation path; anything removable removed; work recoverable. **(2) Does it belong?** — still justified; smallest reliable mechanism; duplicates and conflicts with nothing; references rather than copies authoritative context; consumers and handoffs clear; maintenance proportionate; removable cleanly.

### 16.4 Codex brief

Composed in `WORKDIR`. **Generated, not durable** — the record's `## Independent review` section holds round, date, subject, findings and dispositions, from which a brief is regenerable.

Sections: what the capability is · why it is being built, with evidence and its honest classification · facts, inferences, unknowns, each fact with a path and each absence claim with its instrument · ownership and seams with cited clauses · scope and exclusions · what is under review (#1 package, #2 result) · the evidence table · **the claims most worth attacking, named specifically** · **the inference question as its own numbered item** — *"For each load-bearing conclusion: does it follow from the cited text, or does the citation merely sit near it?"* · explicit non-goals for the reviewer.

For an *adopt-from-case* capability, the brief additionally states **which case artifacts were adopted and were therefore not re-reviewed**, so the reviewer knows the boundary of its own remit.

**Confidentiality:** decisions, schemas, evidence summaries, redacted or synthetic examples only.

### 16.5 Adjudication

Findings are claims to be tested. Verify, then disposition: accept and fix · accept and defer with a concrete trigger · reject with cited evidence. Only business-risk or maintenance-burden disagreements reach the operator.

---

## 17. Representative-case walkthroughs

All ten carry all seven required elements (QC finding 11).

### 17.1 Lightweight, narrow, project-local, known behaviour

*"`axcion-sector-intelligence` reports should carry a standard 'how Axcíon should use this' closing section."*

**Lane** Lightweight. **Why** No Heavy trigger — one project, no external system, no confidential data, revert-reversible, one consumer. No Medium trigger — workflow demonstrated across six existing sections, one behaviour, ownership unambiguous, no new AI resource, verification is reading the output, no maintenance burden beyond the template itself (M6 not fired). **Artifacts** the edited `reference/report-architecture-template.md`; one `logs/decisions.md` entry after acceptance; no record. **Review depth** self-review only. **Handoffs** none. **Evidence** the diff; one section rendered and read from disk **before** the commit. **Decision** recommended *adopt*; operator accepts; entry written and committed. Stops **0**, interactions **1** (acceptance).

### 17.2 EmailOS — one buyer record + one objective + guidance → one reviewable draft

**Lane** Heavy. **Why** H1 — the buyer record sits in an external CRM which the Needs Document establishes as authoritative and outside the Email OS, and Gmail is the official send record. H2 — a real buyer record is real relationship data. **H4 does not fire on the draft**: producing a draft for human review is reversible; sending is not, and sending is outside this capability. H5 likely — the language layer is claimed by `axcion-communication-system` (F28). **Owner — Systems Builder as sandbox steward.** The record lives at `projects/axcion-systems-builder/cases/email-system/development/buyer-email-preparation.md`, with `stewardship: sandbox` and `permanent_owner: pending — /new-project at Phase 14`. Systems Builder hosts the work; it does not own the capability permanently, and nothing in its frozen surface is edited (D14). At Phase 14 the record and artifacts graduate to the created project (§ 14.11). `buy-side-service-plan` is **not** the owner — it holds needs analysis and a coverage gap report (F41), not the operating outcome. **Artifacts** the record above; `## Adopted case material` recording that `02` was consumed and `03`–`06` were absent; provisional slices marked as such; implementation artifacts under `cases/email-system/development/`; two Codex briefs in `WORKDIR`; a § 14.3 brief for any drafting artifact. **Review depth** Codex ×2 targeting the built result and release (the definition was reviewed at Phases 6–12); `/risk-check` if a skill or command is authored; `/qc-pass` on that artifact. **Handoffs** § 14.10 *adopt-from-case*; § 14.3; § 14.6; § 14.7; § 14.9 if the CRM's owning project must change. **Evidence** one real draft from one real record, produced in `WORKDIR`, read by the operator, compared against the guidance; never committed. **Decision** *continue trial* — one draft is not adoption. Stops **3**.

**The honest sequencing note.** This walkthrough presumes an approved `04` and `06`. Today both are stubs (F39), and register items A2 and A3 are open. Entering now would use § 14.10's partial-case path: `02` as the verified need, entry at Shape, self-authored provisional slices — and A2/A3 would each be an exceptional pause. § 25 carries this as the pilot's real dependency.

### 17.3 Prohibited contact or missing authority must stop, not draft

**Lane** Heavy. **Why** Same triggers as 17.2 — it is **a slice of that capability, not a separate one**; treating it as separate is itself the error. **Artifacts** no new record — slice S2 in `buyer-email-preparation.md`, plus a `## Verification evidence` row for the failure test. **Review depth** a **failure test**, required at Heavy; `axcion-linkedin-os/CLAUDE.md:5-12` (hard laws enforced structurally in settings) and `:23-25` (human confirmation before any real firm, person, call or buyer criterion) are the reference pattern. **Handoffs** none of its own; it rides the parent's. **Evidence** the control demonstrated **in its real invocation path** — construct the prohibited case, confirm the current behaviour wrongly drafts, then confirm the refusal and its stated reason. A rule in a file evidences nothing. **Decision** no separate decision; it **gates the parent's G2** — release is not approved while the refusal path is unassessed.

### 17.4 CRM and Gmail integration, shared relationship state

**Lane** Heavy. **Why** H1 two external systems; H2 confidential data at rest and in flight; H3 the CRM's owning project becomes a consumer of writes; H4 a write to shared relationship state is not a revert; H6 shared-state automation. **Artifacts** the record (escalated, with a dated `## Lane` entry); two Codex briefs; a `## Change requests` entry if CRM-side artifacts must change; `/risk-check` reports at both gates; a data-flow statement and a reversibility statement in the record. **Review depth** Codex ×2; `/risk-check` ×2; integration, failure and recovery tests all required. **Handoffs** § 14.2 formal planning after G1 if a specification is warranted; § 14.9 for the CRM-side change; § 14.6; § 14.7. **Evidence** a real write executed against a test record and rolled back, observed — not "the code path exists." The recovery test must demonstrate the stated undo works. **Decision** *continue trial* with a restricted consumer set. Stops **3**, interactions up to **4**.

### 17.5 Contacting Operations — why, whom and when, without owning the language

**Lane** **Medium** — corrected in v3.1; v3 called this Heavy on H5 and was wrong.

**Why H5 does not fire.** H5 requires the capability to **claim, move or contradict** a responsibility another project's authority document holds. Contacting Operations does the opposite: it claims decisions that are **currently unowned** — why contact should occur, whom, and when — and it *respects* the language boundary rather than crossing it (`axcion-communication-system/CLAUDE.md:27` keeps register and language there). **Adjacency to a claimed territory is not a claim on it.** Treating "sits next to an authority surface" as H5 would make every capability in a well-documented workspace Heavy, which drains the trigger of meaning.

**Why the other Heavy triggers do not fire.** H1 — no external system in normal operation; the output is decision rules. H2 — the rules themselves carry no confidential data; applying them to a named buyer is a *use* of the capability, not the capability. H3 — no second existing consumer; `email-system` is a case, not a built capability, and § 6.2 excludes a consumer that does not yet exist. H4 — a decision rule is revert-reversible. H6 — nothing shared is created.

**Why Medium.** M1 the workflow is undemonstrated; M2 several behaviours (contact-worthiness, prioritisation, timing); M5 verification needs a real contact decision, not a diff; M6 the rules need periodic refresh as the buyer landscape moves.

**What would escalate it.** Any of: the rules begin writing to a CRM (H1); a second project starts consuming the prioritisation output (H3); or the rules absorb approved language, which would cross into the comms system's surface (H5, this time genuinely). **Artifacts** the record at `projects/axcion-systems-builder/cases/contacting-operations/development/{slug}.md` with `stewardship: sandbox` and `source_case:` set — it enters via `adopt-from-case`, so it is sandbox-stewarded like any other (§ 12.3); `## Adopted case material` noting that only `01` exists (F40), so the capability enters at Frame, not Build; the strategy documents themselves under `cases/contacting-operations/development/`. **Review depth** Medium, so **no Codex** (§ 16.2 reserves the independent model for Heavy): `/qc-pass` on the strategy document, and `/risk-check` only if a class fires — likely none, since nothing executable is authored. **Handoffs** § 14.10 (partial case); § 14.6; § 14.7. **Evidence** the strategy applied to one real contact decision, and that decision compared against what the operator would have done unaided. **Decision** *adopt* if the real decision holds up; *keep local* if it serves only one project. Stops **1** (G3).

**The seam.** Contacting Operations owns *why contact should occur, whom, and when*. It must not own *what the message says* — the register-and-language layer, which `axcion-communication-system/CLAUDE.md:27` carries directly. **The implementation is mostly documents** — decision rules, a prioritisation method, a definition of contact-worthiness — possibly no code and no AI resource at all. This is the clearest illustration that a capability is not software.

### 17.6 No-build or manual outcome

*"We should have a system that reminds me which sector reports are overdue."*

**Lane** Lightweight at Frame, but the lane never matters — the ladder stops at rung 2. **Why** Frame finds `axcion-sector-intelligence/CLAUDE.md` already names the active unit (`**Current Section:** precision-components`) and `/prime` already surfaces project position (F15). The need is served by an existing capability plus an operating habit. **Artifacts** none — no record, no decisions entry, nothing durable was decided. **Review depth** none. **Handoffs** none. **Evidence** the citations showing the need is already served, with the search instrument stated. **Decision** reported in chat as *no build — existing capability covers it*. A success. Stops **0**, interactions **0**.

### 17.7 Belongs to `/develop-ai-resource`

*"Build a skill that formats research citations consistently."*

**Lane** none — routing, not lane. **Why** The request names an artifact, not an outcome (§ 5.2). **The test:** could a non-skill answer serve the need — a standard, a checklist, a review step? If yes it is an outcome and this command is right, with the skill as one component. If the operator wants that specific artifact and nothing else, route out. **Artifacts** none. **Review depth** none. **Handoffs** one-line route to `/develop-ai-resource`. **Evidence** the routing test, stated. **Decision** routed. Stops **0**.

### 17.8 Routed to a definition lifecycle

*"Axcíon needs a buy-side outreach programme covering targeting, sequencing, messaging and measurement."*

**Lane** none — Frame concludes route-out. **Why** § 5.3 criterion 1: no project owns "buy-side outreach as a programme." Criterion 4: replace any dependency and a programme with its own deliverables still stands.

**Which route, and how the choice is made.** § 14.1 offers two destinations, and Frame must pick one rather than defaulting:

| Condition | Route | This case |
|---|---|---|
| The **system is undefined** — no agreed needs, scope or MVP | Systems Builder **Phase 4** (the operator opens the case) | Fires. "Targeting, sequencing, messaging and measurement" is four undefined workstreams. |
| The **need is understood but no project holds it** — the work is scoped enough to plan directly | `/scope-project` **Stage 0** → `/plan-draft` → `/plan-refine` → `/plan-evaluate` → **`/new-project`** (locked decision 7's chain) | Would fire instead if the operator arrived with an agreed scope and only needed a project built around it. |

**Both branches are live routes, not one real and one nominal.** Walking the second: Frame hands its output — outcome, verified need, facts/inferences/unknowns, the failing owner criterion, the ladder rung — to `/scope-project` at **Stage 0**, its gated route check (F20). Stage 0 may itself recommend the simple lane (`/context-builder`) or stop. If it proceeds, Stages 1–5 produce a control pack and a planning brief; `/plan-draft` through `/plan-evaluate` produce an approved plan; `/new-project` scaffolds the project. `/develop-capability` re-enters only afterwards, against the created project, to build what was planned.

**Artifacts** none in any project; any record closes `status: rejected` naming the routing target and the failing criterion. **Review depth** none — routing carries no review. **Handoffs** § 14.1, one destination chosen and named. This command never edits Systems Builder's workflow or authority documents (D14) and writes nothing into `projects/project-planning/`; the operator opens the case or invokes `/scope-project`. **Evidence** the owner criteria applied, the one that failed, and which of the two conditions above was met — stated, not assumed. **Decision** reported route. Stops **0**.

### 17.9 Medium that escalates

*"Add a standard pre-send check to LinkedIn drafts."*

**Lane** starts Medium, escalates to Heavy. **Why (start)** M2 three behaviours; M5 verification needs a real draft; M6 the check needs maintaining as positioning changes. **Why (escalation)** Shape's seam exercise finds the check must read `strategy/positioning.md`, which the project's authority order names as governing phrasing (`axcion-linkedin-os/CLAUDE.md:14-16`), and that the natural implementation is a project-local command writing a gating frontmatter field, mirroring `/linkedin-qc` (`:9-12`). That command fires **M4** and separately triggers `/risk-check` (F8) — it does **not** fire H6, which is narrowed to genuinely shared infrastructure.

**What escalates it — corrected twice, and the second correction matters.** v3 escalated on **H3**, citing the publishing lifecycle as a second consumer. **That was wrong:** H3 counts consumers *other than the owner*, and a lifecycle stage inside the owning project is one internal dependent. Escalating on it would make H3 fire for nearly any capability with a downstream step.

A first attempt at a replacement escalated on **H2** — that the check must read approved buyer criteria and named target firms. **That was also wrong, and for an instructive reason:** `projects/axcion-linkedin-os/network/target-list.md` reads *"Seeded empty"* and its segment tables hold no rows. There are no named firms. § 6.2's H2 test demands the data class **and its authoritative source**; there is no source, so H2 does not fire. Asserting it would have been the same defect this plan keeps catching — a premise stated rather than evidenced.

**The real escalation is H5, and it is evidenced verbatim.** Shape finds the natural implementation writes a gating frontmatter field that `approved/` entry depends on. But `axcion-linkedin-os/CLAUDE.md:9-12` states, as one of the project's two hard laws: *"A draft may enter `approved/` only when its frontmatter carries `qc_status ∈ {approved, approved-with-edits}`. **`/linkedin-qc` is the only writer of that field**, and it writes only after the isolated `linkedin-qc-evaluator` returns."*

A second writer to that field **contradicts a standing authority statement** — which is exactly H5's test. The resolution is a Heavy-consequence choice: route the check through `/linkedin-qc` and accept its evaluator's shape, or amend a hard law. Either is a decision about canonical ownership, not an implementation detail. **Artifacts** the record, opened Medium and upgraded with a dated `## Lane` entry; a § 14.3 brief for the command; two Codex briefs from escalation onward; `/risk-check` reports. **Review depth** post-escalation Heavy: Codex ×2, `/risk-check` ×2, failure test on the gate. **Handoffs** § 14.3; § 14.6. **Evidence** the gate demonstrated in its real invocation path — a draft failing the check does not reach `approved/`. **Decision** *revise*, then *adopt* — escalation usually reveals the first design was too small. Stops **3**, all after escalation; **0** before.

### 17.10 Stays project-local after successful use

*"`axcion-sector-intelligence` gets a standard evidence-calibration checklist before each report ships."*

**Lane** Medium. **Why** M1 undemonstrated; M2 three behaviours; M5 verification needs a real report; M6 the checklist needs periodic refresh as evidence standards change. No Heavy trigger. **Artifacts** the record, closed `status: keep-local`; one `logs/decisions.md` entry naming the promotion trigger; the checklist itself in the project. **Review depth** `/qc-pass` on the checklist. No Codex. **Handoffs** none — and specifically **not** `/graduate-resource`. **Evidence** the checklist applied to one real report, and what it caught. **Decision** *keep local*, with the reopening trigger recorded: *"a second research project independently asks for the same check."* Not "revisit later." **The trap this case tests:** the thought *"other research projects should have this"* is the AP-7/DR-7 speculative-abstraction pattern — `docs/ai-resource-creation.md:21` requires a **second confirmed consumer**. Stops **1**.

### 17.11 What the cases collectively test

*(Present in v2, dropped in error when v3 was written, restored and updated here.)*

| Behaviour under test | Cases |
|---|---|
| Lightweight stays light, and acceptance is still required | 1, 6 |
| Heavy triggers fire on the right grounds | 2, 4, 9 |
| **A Heavy trigger correctly declining to fire** — adjacency to an authority surface is not a claim on it | **5** |
| **An internal dependent is not a second consumer under H3** | **9** |
| Speculative consumers excluded from H3 | 5 |
| **Sandbox stewardship, provisional slices, and graduation** | **2** |
| **Open register items pause slices, not the whole capability** | **2** |
| Ownership selection with evidence, and route-out when it fails | 2, 8 |
| Both route-out destinations walked — Systems Builder Phase 4 and the `/scope-project` → `/new-project` chain | 8 |
| Non-software capability handled without assuming code | 5 |
| No-build and reuse as successful outcomes | 6 |
| Boundary against `/develop-ai-resource`, both directions | 7 |
| Escalation during Shape → bounded Shape → G1 | 9 |
| Project-local command fires M4, not H6 | 9 |
| Resisting premature generalisation | 10 |
| Failure-state slices, real-invocation-path evidence | 3 |

---

## 18. Exact target files

### 18.1 Create

| # | Path | Purpose | Size |
|---|---|---|---|
| C1 | `ai-resources/.claude/commands/develop-capability.md` | The command | 150–220 lines, `model: opus` |
| C2 | `ai-resources/skills/capability-development/SKILL.md` | The methodology | 350–500 lines, `model: opus`, `effort: high`, `disable-model-invocation: true` |
| C3 | `ai-resources/templates/capability-record.md` | Record template (§ 12.4) | ~90 lines; register in `templates/README.md` |
| C4 | `ai-resources/plans/2026-07-28-develop-capability-build-plan-v3.1.md` | This plan | — |

### 18.2 Edit

| # | Path | Change | Size | Risk |
|---|---|---|---|---|
| E1 | `ai-resources/.claude/commands/develop-ai-resource.md` | (a) fifth Boundary bullet (§ 5.4); (b) Step 1.0 upstream clause; (c) **Step 4 upstream clause covering both branches** (§ 18.3) | ~24 lines added, nothing removed | Low-medium; additive |
| E2 | `{workspace}/CLAUDE.md` | Rename `## AI Resource Creation` → `## Capability and AI-Resource Development`; add the routing paragraph — **six lines, four sentences** (§ 18.4), not the "+2 lines" v2 claimed | +6 lines | Cross-cutting CLAUDE.md — a `/risk-check` class; permanent always-loaded cost |
| E3 | `ai-resources/CLAUDE.md` | One line naming the boundary | +1 | Low |
| E4 | `ai-resources/docs/ai-resource-creation.md` | One sentence in rule #4 naming the sibling lifecycle | +1 | Low |
| E5 | `ai-resources/logs/decisions.md` | Decision entry recording the prong-(b) clearance (§ 18.5) | ~30 lines | None — append-only |
| E6 | `ai-resources/templates/README.md` | Register `capability-record.md` | +2 | None |

**Not edited:** `prime.md` (CX-1). **Systems Builder's frozen surface** (D14) — `workflow.md`, `engine.md`, `CLAUDE.md`, `cases/README.md` and every numbered case artifact are untouched by this implementation. The implementation creates no file in that repo at all; only a *hosted capability run* does, under `cases/{name}/development/`.

### 18.3 E1 — exact clause text

**Step 1, before 1.1:**

```markdown
**1.0 Upstream-qualified brief.** When the input brief carries both `**Capability:**` and
`**Settled upstream:**`, it arrives from `/develop-capability`, which has already validated
the operating need, established ownership and the seam, and holds the adoption decision.
Read the record named in `**Capability:**` — resolve its path by the same `{WORKSPACE}`
ancestor walk-up used at Step 1.5 — and treat 1.1 and 1.2 as satisfied by it. Do not
re-derive the need or re-classify its evidence. **Steps 1.3–1.6 still run in full, scoped
to the artifact:** does this artifact already exist, is this rung the smallest mechanism for
*this artifact*, and where does it belong. A brief carrying neither field is an ordinary
direct invocation — ignore this clause and the Step 4 clause below.
```

**Step 4, after its first paragraph — covering both branches (QC finding 1):**

```markdown
**Upstream mode — no disposition is taken to the operator, on either branch.** When Step 1.0
applied, return the judgement to the calling `/develop-capability` instead of putting a
choice to the operator:

- **Candidate built** — do not put Ship / Revise / Defer / Delete. Return an **artifact
  judgement**: is it well made, does it do what it claims, what was tested and what was
  observed.
- **No candidate built** (verdicts *no build*, *reuse as-is*, *defer* from 1.6) — do not put
  Accept / Reconsider. Return the recommendation, the evidence, and the existing capability
  or habit that serves the need, for the calling capability to adjudicate.
- **External-resource recommendation** — state which form is proposed, but do not take it as
  a separate operator decision; return it with the judgement.

The completion criterion is met, in upstream mode, by **returning** the judgement rather than
by obtaining a disposition. **The business-adoption decision belongs to the capability
lifecycle's own operator gate and is taken there, once, for the capability as a whole** —
putting any decision here would add an operator stop the capability's gate table does not
count. `inbox/` brief closure is unaffected: an upstream brief does not come from `inbox/`.
```

### 18.4 E2 — exact workspace `CLAUDE.md` text

```markdown
## Capability and AI-Resource Development

**Operating capabilities** — business, operational or product abilities inside an existing
project — are developed through `/develop-capability`, which owns the execution-and-proof
loop from an approved intention to real use and an explicit lifecycle status. **AI resources**
— skills, commands, agents, prompts, hooks, scripts, persistent instructions — are qualified
and built through `/develop-ai-resource`. The test is what you want at the end: an outcome,
or an artifact. The skill is not the capability; it is one implementation component.

{existing /develop-ai-resource paragraph, unchanged}
```

Six lines, four sentences. Corrected from v2's "+2 lines," which was a D11 self-violation.

### 18.5 E5 — the decisions entry (no OP-11)

```markdown
## 2026-07-DD (S{n}-{marker}) — Land `/develop-capability` + `capability-development` skill; complexity budget cleared on prong (b)

**Context.** Axcíon's development workflow defines its front half in detail and its execution
half in one paragraph. `projects/axcion-systems-builder/` runs Phases 4–13 — Needs Document,
scope reconciliation, system definition, MVP, technical solution, Implementation Brief — with
four Codex red teams, all of them before implementation (`workflow.md:972-1000`). Phase 15,
"Begin Project Execution", is fourteen lines (`workflow.md:925-940`). Nothing owns the slice
loop, evidence-to-claim matching, review of a built result, real use before adoption, or an
explicit terminal status.

**Decision — build it, and record that the budget is cleared rather than waived.**
`docs/ai-resource-creation.md:25-34` requires net-simplification or cited evidence.
Prong (a) fails: two components added, none removed. **Prong (b) passes** on
`docs/ai-resource-creation.md:27`'s own terms — cited written evidence of a pattern seen
≥2 times: `axcion-systems-builder/CLAUDE.md:13` records that "A Management OS was built and
never run; a Strategy OS was built and partly unused." Both are retired. Two systems reached
built state and were not adopted.

**No OP-11 exception is written**, and the earlier draft's OP-11 argument — which rested on a
claim that no development path existed — is withdrawn as factually wrong: two cases
(`email-system` at Phase 6, `contacting-operations` at Phase 4) are live in that path.

**What the evidence proves and does not.** It proves the failure mode — built and not adopted
— is real, recorded and repeated. It does not prove this command's shape prevents it. Systems
Builder addresses the front half of the same failure; this addresses the back half. Whether it
works is what the EmailOS pilot and build-plan § 24.1 test.

**Systems Builder's workflow and authority documents are not modified by this change.**
`workflow.md`, `engine.md`, `CLAUDE.md`, `cases/README.md` and every numbered case artifact
`01`–`06` are frozen. The *implementation* creates no file in that repo at all. A capability
hosted in the sandbox does create `cases/{name}/development/` and its artifacts — that is what
hosting means, and the operator authorised it explicitly on 2026-07-28, overriding
`cases/README.md`'s own "do not add files a case does not need". Overlaps between the new
command and existing phases are recorded as follow-up observations in build-plan § 26 and
left for the post-pilot review.

**Alternatives considered.**
- *Fold the execution loop into Systems Builder as an expanded Phase 15.* Rejected on operator instruction not to redesign Systems Builder here, and on merit — the loop is needed for capabilities that never pass through Systems Builder.
- *Defer until a capability fails at execution.* Rejected — the failure already happened twice, which is the evidence prong (b) rests on.
- *Reuse the earlier OP-11 argument.* Rejected — the operator forbade it and it was false.

**Decided by:** Patrik (operator), 2026-07-DD, after Codex review (verdict Revise), `/qc-pass`
(verdict REVISE), a premise correction, and `/contract-check`. Executed by Claude.
Plan: `plans/2026-07-28-develop-capability-build-plan-v3.1.md`.
```

### 18.6 Not created

No new agent, hook, `/prime` edit, registry, symlink beyond auto-sync, project `CLAUDE.md` edit, or `development/` directory until a Medium or Heavy capability needs one.

---

## 19. Integration points and consumers

### 19.1 Invocation

**Initiation** — the workspace `CLAUDE.md` routing paragraph (E2, six lines always loaded). Without it, capability requests route to `/develop-ai-resource` by default (I1). **Pipeline position** — workflow Phase 15 (§ 4.5), real but not yet named in `workflow.md` by deliberate choice. **Resumption** — `/wrap-session`'s scratchpad plus `/prime` Step 1b (F15, F24), the record, and the operator naming the capability. No `/prime` change.

### 19.2 Consumers affected

| Consumer | Effect | Severity |
|---|---|---|
| Every project (~21 engineered, via auto-sync F12) | Gains the command at next session start; no behaviour change until invoked | Low |
| `/develop-ai-resource` | One boundary bullet, one Step-1 clause, one Step-4 clause covering both branches. Direct invocations unchanged (AT-13) | Low-medium |
| Workspace `CLAUDE.md` | +6 lines always loaded everywhere | Low-medium |
| `/prime` | **Unchanged** | None |
| **`projects/axcion-systems-builder/`** | **Host relationship.** Its `workflow.md`, `engine.md`, `CLAUDE.md`, `cases/README.md` and numbered case artifacts are **never edited** (D14). `/develop-capability` **does** create `cases/{name}/development/` and the implementation artifacts a hosted capability produces. Those transfer out at graduation (§ 14.11) | **Low, and bounded by AT-27**, which now checks *which* paths changed rather than that none did |
| `/qc-pass`, `/risk-check`, `/implementation-triage`, `/scope-project`, `/new-project`, `/graduate-resource` | New caller; no file change | None |
| `/wrap-session` | Encounters a new file class under `development/`; path-agnostic. Its QC-PENDING guard (F25) correctly blocks an un-QC'd new command or skill. Its Step 0.5 scratchpad is a named residual confidentiality risk (§ 12.8, R9) | Low-medium |
| `/refresh-project-state` | Enumerates by `Glob projects/*/CLAUDE.md`; unaffected by a new subdirectory. § 12.8's no-confidential-data rule keeps snapshots safe | Low |
| `/audit-repo`, `/token-audit`, `/lean-repo` | Will count two new components; the § 18.5 entry is the answer | None |
| Codex | New workflow: brief carried out of `WORKDIR`, findings back. Adds two rounds on top of Systems Builder's four for a Heavy capability (U4) | Operator-process |

---

## 20. Implementation sequence

Commit prefixes per `ai-resources/CLAUDE.md` § Git Rules (`new:` / `update:` / `batch:`).

| # | Commit | Repo | Contents | Gate |
|---|---|---|---|---|
| **1** | `new: capability-development — operating-capability execution methodology` | ai-resources | C2 + C3 + E6 | `/qc-pass` on the SKILL.md. Inert until read |
| **2** | `new: develop-capability — execution-and-proof loop for approved capabilities` | ai-resources | C1 | `/qc-pass`. Reachable but not yet routed to |
| **3** | `update: develop-ai-resource — upstream mode for capability-qualified briefs` | ai-resources | E1 | `/qc-pass`. Closes double-qualification and **both** uncounted gates before routing sends traffic |
| **4a** | `update: CLAUDE.md — route operating capabilities to /develop-capability` | **workspace root** | E2 | Cross-cutting class → end-time `/risk-check`. Invocation goes live |
| **4b** | `batch: name /develop-capability as the operating-capability lifecycle` | ai-resources | E3 + E4 | — |
| **5** | `update: decisions — /develop-capability complexity budget cleared on prong (b)` | ai-resources | E5 + C4 status banner | None; last, records what shipped |

**Commit 4 is split across two repositories** (QC finding 5). `{workspace}/CLAUDE.md` is in the workspace root repo; `ai-resources/` is a separate repo (root `.gitignore:32`). A single commit spanning both is impossible.

### 20.1 Gates

- **`/placement`** — before commit 1. `development/` is a new artifact category in a new location. **OQ-2 is provisional on its outcome**; nothing is written against the name until it returns.
- **Plan-time `/risk-check`** — after approval, before commit 1. Payload: two new components, four file edits across two repos, one cross-cutting CLAUDE.md edit.
- **`/blindspot-scan`** — post-plan, pre-implementation; this creates runnable infrastructure.
- **End-time `/risk-check`** — before the final commit, batched.
- **No push** until `/wrap-session`, gated confirmation.

### 20.2 Post-landing

AT-1 to AT-9 and AT-27 run immediately. AT-10 onward need a real capability, run against the first live use — a deliberate Lightweight case (CX-4), then the EmailOS pilot (§ 25).

---

## 21. Acceptance-test matrix

| # | Test | Method | Pass condition |
|---|---|---|---|
| AT-1 | Command within budget | `wc -l` | 150 ≤ lines ≤ 220 |
| AT-2 | Explicit model tiers | grep frontmatter | `model: opus` in both; no `model` in any settings file |
| AT-3 | Skill cannot self-invoke | grep frontmatter | `disable-model-invocation: true` |
| AT-4 | Command reaches projects | project session `ls` | symlink present after SessionStart |
| AT-5 | `/prime` untouched | `git diff` over the change set | zero lines of `prime.md` changed |
| AT-6 | Record template renders | render with test values | no `{{` remains; every section present, including `## Change requests` |
| AT-7 | Active-status set complete | fixtures at all four active statuses; invoke bare | all four listed |
| AT-8 | `paused` without a trigger reported | fixture with no `reopen_trigger:` | reported malformed; not auto-repaired |
| AT-9 | Terminal statuses excluded | fixtures at all five | none listed as resumable |
| AT-10 | Lightweight writes zero dedicated files and does not self-adopt | case 17.1 | no `development/`; recommended status stated; **no decisions entry until acceptance**; closing commit exists after it |
| AT-11 | Artifact request routes out | case 17.7 | one-line route; no record; no lane call |
| AT-12 | Upstream brief not re-qualified | brief with both fields | reads the record via walk-up; skips 1.1–1.2; runs 1.3–1.6 on the artifact |
| AT-13 | Direct invocation unchanged | plain need, no capability fields | full Step 1 and full Step 4 as before commit 3 |
| AT-14 | No uncounted gate, candidate-built path | Medium capability with one artifact handoff | exactly one operator stop; `/develop-ai-resource` returns a judgement and takes no Ship/Revise/Defer/Delete |
| **AT-15** | **No uncounted gate, no-candidate path** (QC finding 1) | upstream brief whose 1.6 verdict is *reuse as-is* | `/develop-ai-resource` returns the recommendation to the caller and takes **no Accept/Reconsider** decision to the operator; total stops unchanged |
| AT-16 | Heavy announces in Frame, stops at G1 | trigger H1 in Frame | lane + triggers + consequence stated; work continues into Shape; first stop is G1 with a package; no implementation, external handoff or real-data trial before it |
| AT-17 | Heavy stops exactly three times | case 17.4 | 3 stops; a passing verdict produces none |
| AT-18 | Escalation behaves by phase | escalate in Shape, then separately in Build | Shape → bounded Shape completes, then G1. Build → immediate stop **with brief #1 composed first**, naming what is committed. Nothing discarded |
| AT-19 | **No confidential material in the repo** (QC finding 4) | run a real-record trial (case 17.2), then: `command grep -ril "<the trial buyer's surname>" . --exclude-dir=.git` and `git log -p` over the capability's commits | **both return zero hits**; the trial artifact is present under `$WORKDIR` and absent from every repo path. The surname is chosen at trial time and named in the test record, which makes this mechanically evaluable |
| AT-20 | Review briefs not in the repo | Heavy through G1 | brief in `WORKDIR`; no brief file anywhere in the tree; `## Independent review` holds round, findings, dispositions |
| AT-21 | Unassessed reported as unassessed | force Codex unavailability | recorded **unassessed**, not passed |
| AT-22 | Negative trial stops the build | force a negative trial | build stops; result recorded; ladder re-entered |
| AT-23 | Rejected capabilities keep their record | case 17.8 | record exists `status: rejected` with the routing note |
| AT-24 | **Change request is durable and enabled** (QC finding 2) | trigger H3 "a second project must change" | request appears **verbatim in `## Change requests`**, survives `WORKDIR` disposal, and records the returned evidence; **zero writes** to the sibling tree by the requesting run. **Executor check:** the record and the request name the operator as *authoriser* and a Claude session in the sibling project as *executor*. A request naming the operator as the one who implements it is a **failure**, not a pass |
| AT-25 | Verification precedes commit | case 17.1 and a Medium slice | artifact read from disk and compared before the commit; at Medium the record update is inside the committed change |
| AT-26 | Project-local command does not fire H6 | case 17.9's first classification | M4 fires; H6 does not; `/risk-check` scheduled at Prove without changing the lane |
| **AT-27** | **Systems Builder's frozen surface is untouched** (D14) | `git -C projects/axcion-systems-builder diff --name-only HEAD` plus `status --porcelain`, after any sandbox-hosted capability run | **Zero** changed paths matching `workflow.md`, `engine.md`, `CLAUDE.md`, `cases/README.md`, `cases/*/0[1-6]-*.md`, **`cases/*/01-v1-parts/**`, or `cases/*/working/**`** — the last two hold the verbatim V1 source documents and superseded scaffolds, which are case material, not sandbox. **Only** paths under `cases/*/development/` may change. Any other changed path is a hard failure |
| **AT-28** | **`adopt-from-case` does not re-derive** | run against `cases/email-system/` | `02` consumed as the verified need; Frame does not re-author it; `## Adopted case material` names what was consumed and what was not re-derived; `source_case:` set |
| **AT-29** | **Stubs are treated as absent** | run against `cases/email-system/` today (`03`–`06` are stubs), with an owning project present | the command names `03`–`06` as absent by their `**Status:** not started` line, enters at Shape not Build, and marks any self-authored slices provisional |
| **AT-30** | **The missing permanent project does not block execution** (§ 25) | run `adopt-from-case` against `cases/email-system/` with no Phase-14 project created | the capability **opens a real record** at `cases/email-system/development/`, carries `stewardship: sandbox` and `permanent_owner: pending`, enters at Shape, and runs. It does **not** refuse, and it does **not** degrade to a report-only mode |
| **AT-31** | **Graduation transfer** (§ 14.11) | steward a capability in the sandbox, create a permanent project, run the transfer | record and named artifacts are **moved, not copied** — exactly one record exists afterwards; frontmatter shows `stewardship: permanent` and `transferred_from:`; a dated transfer decision is recorded; `TRANSFERRED.md` remains in the case; lane, phase, status and evidence are **unchanged** by the move |
| **AT-32** | **Open register items pause slices, not the capability** (§ 14.10) | run the EmailOS pilot with A2 and A3 open | slices depending on A2/A3 pause and name the item; slices not depending on them **proceed**. The capability does not halt wholesale |

---

## 22. Risks, mitigations, rollback

| # | Risk | Likelihood | Impact | Mitigation | Rollback |
|---|---|---|---|---|---|
| R1 | **Resumption gap** — no `/prime` scanner | Medium | Medium | `/wrap-session` → `/prime` Step 1b, plus the record and the operator naming it. § 23 names the reversal trigger | Build the scanner then, with working pseudocode |
| R2 | **Double qualification or a resurfaced uncounted gate** | Medium | High | § 18.3's clauses cover both Step 4 branches, `:125` and `:127`. AT-12, AT-13, AT-14, AT-15 | Revert commit 3 |
| R15 | **Sandbox residue** — a capability abandoned mid-flight leaves a record and artifacts inside someone else's case folder | Medium | Low | The record carries a status; an abandoned one becomes `paused` with a reopening trigger or `rejected` (§ 12.5). `TRANSFERRED.md` marks graduated ones. Nothing is orphaned silently | Delete the `development/` directory; the case's numbered artifacts are untouched |
| R3 | **Overlap with Systems Builder Phases 4–13 turns out to be duplication, not complement** | **Medium — the honest assessment** | High | *adopt-from-case* makes SB output settled input rather than work to redo. The overlap is **documented not resolved** (§ 26) by operator direction, and the pilot measures it. § 24.2's simplification conditions key on it | Revert commits 1–4b. Systems Builder's frozen surface is untouched (D14); any sandbox record left behind is readable markdown and is removed with the case, not with the command |
| R4 | **Six Codex rounds per system is unsustainable** | Medium | High | Heavy's two are conditional on a real trigger and, for an adopted case, target only the built result and release (§ 14.10). U4 and § 26 O-4 track it | Cut to one Heavy round — a skill edit |
| R5 | **A fourth state file per project** | Medium | Medium | Lightweight adds nothing; records are per-capability and leave the active set at a terminal status; no registry | Revert; records are plain markdown |
| R6 | **Lane misclassification downward** — confidential data or an integration ships without Codex review | Medium | **High** | Six triggers with concrete tests; ambiguity resolves upward; mandatory re-test at every boundary and on six named discoveries | Escalation is always available and additive |
| R7 | **Terminology collision** | High encountered; low harm | Low | `development/` collides with nothing (F30); named phases never numbered (§ 5.5); `/placement` confirms before any code | Rename — mechanical |
| R8 | **Always-loaded token cost** — six lines, four sentences, forever | Certain | Low | Without them routing is wrong by default (I1). Cost stated accurately this time | Revert commit 4a |
| R9 | **Confidential data reaches the repository** | Low | **Severe** | § 12.8's rule set on the corrected premise; `WORKDIR` via `mktemp -d`; AT-19 checks working tree **and** git history with a named search term. **Residual, named not solved:** `/wrap-session` Step 0.5 writes a conversation-derived scratchpad into the repo automatically and does not ask (F24). The § 12.8 wrap-time constraint is a session behaviour, not an enforced control | History rewrite — expensive, which is why prevention is strict |
| R10 | **Codex unavailable and a Claude subagent substituted** | Medium | High | Forbidden; the failure path records **unassessed**. AT-21 | Behaviour rule, tested |
| R11 | **Record becomes a second source of truth** against project authority documents or case artifacts | Medium | Medium | The record points, never restates. Numbered case artifacts stay read-only (D14). `## Adopted case material` records what was consumed rather than copying it | Records are advisory markdown |
| R12 | **Scope creep into project management or into Systems Builder's remit** | Medium | Medium | § 4.3's exclusions name Phases 4–13 explicitly as excluded; D14's frozen list and AT-27's path check make the boundary mechanical | Narrow the trigger in the command file |
| R13 | **`WORKDIR` material lost mid-review** | Medium | Low | Briefs and change requests are regenerable — the record holds their content (§ 12.4, § 14.9). `WORKDIR` is stated in chat | Regenerate from the record |
| R14 | **The pilot advances only as far as approved material allows** — `email-system` is at Phase 6, `03`–`06` are stubs, A2/A3 open | **High** | **Medium** | Sandbox stewardship (§ 14.10) removes the *project-existence* block: the capability enters at Shape on `02`, opens a real record, builds and commits slices. **The A3 block is real and remains:** § 9.2 and § 14.7 confine Heavy to synthetic data before G2, and A3 is the approved compliance source, so until it closes every runnable slice is synthetic. The lifecycle runs for real; **real-buyer-data proof waits on A3** | No rollback needed — a partially advanced capability is a valid state carrying its own status |

### 22.1 Rollback, per repository (QC finding 5)

- **`ai-resources`** — commits 1, 2, 3, 4b, 5 revert cleanly in reverse order. Every edit is additive; no schema migrated, no existing file restructured.
- **Workspace root** — commit 4a is one file, one section. `git revert` restores the prior heading and paragraph.
- **`projects/axcion-systems-builder`** — the implementation commits touch nothing there. **Sandbox-hosted capability work is a separate matter**: a capability run inside the sandbox creates `cases/{name}/development/` and its artifacts, committed in that repo by the capability's own slice commits. Rolling back the *command* does not roll those back, and should not — they are work product, not infrastructure. They are removed, if ever, by the capability reaching `retired` (§ 14.8) or by the operator deleting the case. AT-27 guarantees only that the frozen surface was never touched.
- A full rollback returns both repos to their pre-change state, with any capability records left as readable markdown.

---

## 23. MVP exclusions

| Excluded | Why | What would justify it |
|---|---|---|
| **`/prime` capability scanner** | CX-1. High blast radius in the highest-traffic command before any observed continuity failure; v1's pseudocode was broken | **One real instance** of a Medium or Heavy capability lost between sessions |
| **Any change to Systems Builder's frozen surface** — `workflow.md`, `engine.md`, `CLAUDE.md`, `cases/README.md`, numbered case artifacts — including naming `/develop-capability` in `workflow.md` Phase 15 | D14. Sandbox writes under `cases/{name}/development/` are *not* excluded — they are the hosting mechanism | The post-pilot review (§ 26 O-1) |
| A second supporting skill | Q11 | The skill exceeds ~700 lines with two separable halves |
| Permanent lane agents | Q11 | Lane processing needs fresh context per lane, evidenced across ≥3 capabilities |
| A `capability-reviewer` agent | Q8, D8 | Never |
| A capability registry | Recreates the central registry the foundational document warns against | Never |
| Cross-project dashboards or metrics | An explicit foundational anti-goal | Never |
| Automated lane classification | RR-05: build no checker for a design principle | Never |
| Automated Codex invocation | Codex runs outside the session | Codex becomes invocable in-session with no new shared state |
| A list or status verb | Bare invocation lists active records | More than ~5 concurrent capabilities in one project |
| `/mission` integration | CX-3 | A Heavy capability spans ≥5 sessions and drift measurement is asked for |
| Per-capability-type templates | Speculative abstraction on zero instances | Three capabilities of one type with a demonstrated common shape |
| Retirement automation | Rare and judgment-heavy | The first actual retirement proves the manual path error-prone |
| Reconciling the three Email OS sources (F39, F41) | Not this command's job; it consumes, it does not arbitrate | Frame surfaces a genuine contradiction between them during the pilot |

---

## 24. Adoption and retirement conditions for `/develop-capability` itself

### 24.1 Adoption

**Adopted** only when all five hold:

1. Three capabilities completed a full lifecycle to a terminal status — **at least one per lane**.
2. At least one ended in a **non-build** outcome.
3. At least one Heavy capability completed both Codex rounds and the operator judged the process sustainable **alongside Systems Builder's four**.
4. At least one capability was **resumed across sessions** from its record.
5. No capability required a repair to the command or skill mid-run.

Until then its own status is **continue trial** — which is what it carries from day one.

### 24.2 Simplification conditions

- Lightweight used in fewer than 1 in 4 capabilities → the lane boundary is wrong, or Lightweight work bypasses the command.
- Heavy never used across ten capabilities → over-built; consider two lanes.
- Heavy avoided while its triggers fire → too expensive; reduce review rounds before reducing triggers.
- Record fields consistently empty → cut them.
- Adoption condition 4 repeatedly fails → the deferred `/prime` scanner is needed.
- **The pilot shows Frame and Shape are almost entirely skipped for adopted cases** → the command's front half is redundant with Systems Builder for that entry mode; consider an execution-only variant. This is the specific outcome § 26 exists to catch.
- A model improvement makes lane routing unnecessary → delete rather than adapt (Principle 8).

### 24.3 Retirement

- The lifecycles merge and one command should own them.
- Systems Builder absorbs the execution loop after the post-pilot review, making this redundant.
- Twelve months with fewer than three capabilities developed — the need was not real. **Say so and remove it.**
- Maintenance cost exceeds value produced, measured by work enabled.

### 24.4 Review point

After the **third completed lifecycle**, or **2027-01-31**, whichever comes first. Verdict: adopt · continue trial · simplify · retire. Recorded in `ai-resources/logs/decisions.md`. **The EmailOS pilot's friction log is a required input** (§ 25).

---

## 25. The pilot, and its honest dependency

Per operator direction: pilot `/develop-capability` on EmailOS after implementation, then use observed friction to scope any later Systems Builder change.

**The dependency.** `email-system` is at **Phase 6** (F39). `04-mvp-scope-and-product-roadmap.md` and `06-implementation-brief.md` — the two artifacts *adopt-from-case* maps to slices and acceptance criteria — are **stubs**, status *not started*. Register items **A2** (who builds and operates the system) and **A3** (the compliance source) are open, and both are operator questions the command must not infer. A full Heavy pilot with slices derived from an approved MVP therefore cannot run until the case reaches Phase 13/14.

**What can run now, and what should.**

| Stage | Pilot activity | Depends on |
|---|---|---|
| Immediately after implementation | **A Lightweight capability** end to end (CX-4). Validates the cheapest path, adoption condition 5, and acceptance behaviour | Nothing |
| Immediately after implementation | **The real EmailOS pilot, hosted in the sandbox.** `adopt-from-case` against `cases/email-system/`: consume `02` as the verified need, treat `03`–`06` as absent, open the record at `cases/email-system/development/`, enter at Shape, author provisional slices, and run them. AT-28, AT-29, AT-30 and AT-32 run against real material | Nothing — the case exists today |
| When `email-system` reaches Phase 9/11/13 | **Slices, seam and acceptance criteria re-anchored** on the approved `04`, `05`, `06` as each lands, superseding the provisional set | Systems Builder Phases 6–13 completing |
| When `/new-project` creates the permanent project | **Graduation transfer** (§ 14.11) — record and artifacts move out of the sandbox | Phase 14 |

**The permanent project does not exist yet, and that no longer blocks anything.** v3 treated the missing Phase-14 project as a reason the EmailOS pilot could only be rehearsed. That was the wrong conclusion, and it followed from the wrong premise — a Systems Builder that could not be written into. Under D14 as corrected, **Systems Builder stewards the capability** at `cases/email-system/development/` and the real lifecycle runs there. Graduation (§ 14.11) moves it out when Phase 14 delivers a permanent home.

**What genuinely gates the pilot, and what does not.**

| Gates | Does not gate |
|---|---|
| **A2** — who builds and operates the system. Any slice whose behaviour depends on the answer pauses (§ 11.3) | The absence of the Phase-14 project |
| **A3** — the approved compliance/privacy source. Any slice touching real buyer data pauses until it exists | The stub state of `03`–`06` — the capability enters at Shape and authors provisional slices |
| An **approved `04`** for a *final* slice set — provisional slices are re-anchored when it lands | Codex Review 1 on the Needs Document — that reviews the definition, not the execution |

**Rehearsal mode is deleted.** It existed only to work around the no-owner problem that sandbox stewardship now solves. Removing it takes one concept out of the design rather than adding one — the correct direction.

**Friction capture.** Every friction point observed during the pilot is recorded in the capability's own record under `## Decisions` and, at pilot end, summarised into one entry in `ai-resources/logs/decisions.md`. It is **not** routed through `/note` or `/friction-log` — `axcion-systems-builder/CLAUDE.md:95-99` records that those write to `ai-resources/logs/` where case work never reads them. That summary is the input that scopes any later Systems Builder change (§ 26).

---

## 26. Follow-up observations — documented, not resolved

Per operator constraint 5, overlaps with existing Systems Builder phases are recorded here and left for the post-pilot review. **None is acted on in this implementation.**

| # | Observation | Why it is deferred |
|---|---|---|
| **O-1** | **`workflow.md` Phase 15 does not name `/develop-capability`.** Naming it would fully discharge RR-05's letter (§ 4.5) and make the pipeline position explicit rather than interpreted. | D14 freezes `workflow.md`. Deferring also means the pilot tests the command before the workflow depends on it. |
| **O-2** | **Frame overlaps Phase 5 (Needs) and Phase 7 (reconcile).** For an adopted case, Frame runs only to confirm owner, lane and seam — most of it is skipped. If that holds across the pilot, the front half may be redundant for this entry mode. | § 24.2 makes it a simplification condition. Measure before cutting. |
| **O-3** | **Shape overlaps Phases 8–11 and 13** — package, seam, technical solution, brief. *adopt-from-case* maps around it, but the mapping is untested. | The pilot is the test. |
| **O-4** | **Six Codex rounds across one system's full life** — four in Systems Builder, two in Heavy. § 14.10 narrows Heavy's to the built result and release, but the total is untested (U4). | Adoption condition 3 and § 24.2 both key on it. |
| **O-5** | **The intervention ladder overlaps Phase 10** (evaluate ≥2 technical approaches) and **Core Operating Rule 4** (manual work is acceptable during the MVP, F36). These are aligned in principle, not conflicting — but two texts now state the same discipline. | Consolidation would touch Systems Builder. |
| **O-6** | **`workflow.md:1068` anticipates "a lean Systems Builder command specification."** If that is built, its boundary with `/develop-capability` must be settled deliberately rather than by whichever ships first. | Not this implementation's call. |
| **O-7** | **Three Email OS sources exist** — the Systems Builder case, `buy-side-service-plan/analysis/email-os-needs-definition-v1.md`, and the coverage gap report (F41). Which is authoritative for which question is unsettled. | § 23 excludes arbitrating it. Frame surfaces a contradiction if one appears. |
| **O-8** | **The `email-system` Challenge 1 finding** — a substantial CRM configuration project with no named owner, on which the acceptance boundary silently depends (U7). | An operator decision inside Systems Builder, not a capability-command matter. |

---

## 27. Open questions — all answered

No question remains open. All four were answered by the operator on 2026-07-28 and are recorded here as settled, not pending.

| # | Question | Answer | Consequence in this plan |
|---|---|---|---|
| **OQ-1** | Does prong (b) clear the complexity budget, or write an OP-11 exception anyway? | **Accept prong (b).** "Built but never adopted" is a repeated written failure, and this command directly adds real-use and operator-adoption requirements. **No OP-11 unless `/risk-check` disagrees.** | § 4.4 and § 18.5 stand as written. If the plan-time `/risk-check` dissents, § 18.5's entry converts to an OP-11 record — the only change would be that entry. |
| **OQ-2** | If `/placement` recommends a different location or name for `development/`? | **Follow `/placement`.** | § 20.1 keeps it as a pre-commit-1 gate; § 12.3's path is provisional until it returns. Nothing is built against the name first. |
| **OQ-3** | Accept the v1 resumption arrangement — no `/prime` scanner? | **Accepted.** | § 19.1, § 23 and R1 stand. § 23's trigger — one real instance of a capability lost between sessions — remains the reversal condition. |
| **OQ-4** | Pilot sequencing, given `email-system` is at Phase 6? | **Lightweight first, then exercise EmailOS inside Systems Builder** — a real pilot, advancing as far as current approvals allow. Not rehearsal-only. **Not blocked merely because the permanent project does not exist.** | This is the change that drove v3.1's architecture. § 25 replaces the rehearsal path; sandbox stewardship (§ 14.10) and graduation (§ 14.11) are its mechanism. |

**One item is not a question but a live dependency, and it is the operator's to close:** `email-system` register items **A2** (who builds and operates the system) and **A3** (the approved compliance/privacy source) are open (F39). They pause the slices that depend on them and no others (§ 25, AT-32). Neither may be answered by inference.

---

## Appendix A — SOP step → phase mapping

| SOP step | Phase | Lightweight | Medium | Heavy |
|---|---|---|---|---|
| 1 State the operating outcome | Frame | ✓ | ✓ | ✓ |
| 2 Inspect reality | Frame | 4 files | 12 | + consumers, authority |
| 3 Smallest intervention | Frame | name the rung | + dispositions | ✓ |
| 4 Test the workflow first | Shape | escalates | required on M1 | mandatory; synthetic pre-G1 |
| 5 Language, ownership, seams | Shape | owner only | 7-field seam | + operating seam |
| 6 Thin package | Shape | 3 lines | 11 fields | durable + approved |
| 7 Select review depth | Frame/Shape | implicit in lane | implicit | explicit at G1 |
| 8 Vertical slices | Shape | one slice | 2–5 ordered | + failure/recovery |
| 9 One behaviour at a time | Build | verify→commit | verify→record→commit | ✓ |
| 10 Review own implementation | Prove | inline | recorded | recorded |
| 11 Independent review | Prove | none | `/qc-pass` | Codex ×2 |
| 12 Deliver and operate | Land | demonstrate | real use | controlled release |
| 13 Lifecycle decision | Land | recommend → accept | operator (G3) | operator (G3) |

For an *adopt-from-case* capability, steps 1–8 are largely **consumed** from the case rather than performed (§ 14.10). Steps 9–13 — the execution-and-proof loop — are performed in every case, and are the reason this command exists.

## Appendix B — Foundational principle → design element

| Principle | Where |
|---|---|
| 1 Business value governs | § 4.4 clears the budget on real evidence rather than argument; § 24 measures by work enabled |
| 2 Govern capabilities, not component counts | The record describes a capability; artifacts are consequences |
| 3 Validate the need before building | Frame's ladder and no-build exit; the mandatory trial with a real stop condition; *adopt-from-case* consumes a validated need rather than re-deriving one |
| 4 Smallest sufficient and proportionate | Three lanes; zero files at Lightweight; § 11's stop and interaction tables; § 23's exclusions; the deferred `/prime` scanner; D14's frozen-surface rule |
| 5 Operational reality overrides documented status | § 16.1; "unassessed, never passed"; **D11's instrument rule and § 2.1.1**, which exist because two plan versions failed exactly here |
| 6 One lifecycle, one source of truth | Five named phases; one record per capability; § 12.5's single status set; § 12.6's four-artifact separation; no registry |
| 7 Completion includes delivery, use and closure | Land in every lane; adoption requires observed use **and** operator acceptance; eight Land-selectable statuses, five terminal and three active; **this principle is the gap the command fills** (§ 0B) |
| 8 Durable knowledge, perishable scaffolding | § 13.2; § 24.2's model-release question |
| 9 Visible and recoverable failure | verify → record → commit per slice; § 15's failure table; nothing deleted to tidy up; `WORKDIR` keeps confidential failure out of history |

---

**End of plan v3.1.** No repository change has been made. Systems Builder's frozen surface is untouched; the sandbox is where a hosted capability writes.
