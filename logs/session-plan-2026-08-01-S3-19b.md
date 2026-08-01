# Session Plan — 2026-08-01

## Intent
Write the Work Loop v2 executable core — the single short document that both the Claude command and the Codex resource will link to instead of restating rules — containing the seven sections Playbook Step 3 names, synthesized from the Proposal's settled decisions plus the Step 1 and Step 2 notes, with no decision reopened.

## Model
opus — match (session is running Opus 5). The hard part is synthesis and one genuine design call (where hand-off state lives), not mechanical assembly.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/README.md` — authority order; read first
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md` — AUTHORITATIVE; Section 3 settled decisions, Section 6 standing rules
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/pocock-lifecycle-work-loop-mvp-v0.4.md` — Step 3 section names the core's seven required sections (lines 83–101)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/skill-writing-standard-work-loop-v0.2.md` — BINDING on how the core is written; Section 10 is the pre-commit checklist
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/step-1-codex-packaging-findings.md` — Codex packaging facts
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/step-2-transport-seam-conclusions.md` — proven schema, § 7 "What Step 3 inherits"
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/work-loop.md` — v1 contract, READ-ONLY, form conventions only
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/work-loop-spec.md` — v1 spec, READ-ONLY, form conventions only
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/work-loop.md` — v1 command, READ-ONLY
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.agents/skills/work-loop/SKILL.md` — v1 Codex side, READ-ONLY
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/work-loop-v2-mvp.md` — mission threads

**Deliberately NOT loaded:** `the-work-loop-explained-complete-system-v0.2.md`. Per the folder README, it is destination reference only and must never justify building anything. If a section of the core can only be sourced from it, that is a stop condition.

## Findings / Items to Address
1. **Seven required sections, in order** — Playbook Step 3 (`pocock-lifecycle-work-loop-mvp-v0.4.md:89–98`): role statement; admission test; unit cycle; task-state interface; terminology; universal safety rules; escalation triggers.
2. **Where hand-off state lives — the one open design call this session must make.** `step-2-transport-seam-conclusions.md:157–166`: the `turn` field is the only field the prototype demonstrably exercised, and it is a *protocol* field absent from the Proposal § 3 Decision 10 *content* ceiling. Step 2 flagged it and explicitly left the decision to Step 3. This is a local decision (Proposal § 6 "Local decisions stay local"), so decide it in the core and record the reasoning — do not escalate it and do not silently drop it.
3. **Schema evidence to carry into section 4.** `step-2-transport-seam-conclusions.md:144–151`: `turn`, `## Brief`, `## Result` each earned their place with evidence; `unit` was not exercised and is retained provisionally, not proven. The core must not claim `unit` is proven.
4. **The transport is the shared working tree, not Git.** `step-2-transport-seam-conclusions.md:25–39`: the state file's whole history is one commit. The core describes the interface; changing the Proposal's *stated* transport is Proposal-level and out of scope. Write the interface so it is true under the observed behaviour without asserting a redesign.
5. **Codex cannot write `.git` under the current sandbox profile.** `step-2-transport-seam-conclusions.md:43–88`, two independent sessions, positive control run. A design constraint to work around, not to fight. Whether to formalise it in the role statement is Proposal-level — flag rather than decide.
6. **Content ceiling for the task-state file.** Proposal § 3 Decision 10 (`work-loop-v2-mvp-proposal-v0.4.md:44`): active state holds at most objective and approved scope, current lane and unit, latest material result, unresolved blocker, next action; on closure only outcome, decisions, final commit or evidence pointer, accepted limitations. It is a maximum, not a minimum.
7. **The five universal safety rules are already enumerated** — Proposal § 5 Phase 1 (`:74`) and Playbook Step 3 item 6 (`:96`): verify premises against the live repository before acting; validate untrusted input read-only before mutating; absence claims state what was searched; scope and success criteria do not silently change; evidence must be capable of exposing failure. Transcribe, do not invent a sixth.
8. **Writing standard is binding on form.** `skill-writing-standard-work-loop-v0.2.md` § 7: plain words, 15–25-word sentences, jargon defined at first use, machine syntax commented. § 10 is the pre-commit checklist and § 1 is the prime rule — attention is the budget, so shorter wins.
9. **Terminology is pinned.** Nine terms, one definition each: task, unit, brief, state file, lane, correction, evidence, deferral, close. The writing standard § 6 forbids synonyms anywhere downstream, so these definitions become load-bearing for Steps 4 and 5.

## Execution Sequence
1. **Read the governing set in authority order.** README → Proposal → Playbook Step 3 → writing standard → Step 1 note → Step 2 note. *Verify:* the seven section names and the five safety rules are quoted from source, not recalled.
2. **Decide item 2 (hand-off state) before drafting section 4.** Write the decision and its one-line reason down first, so section 4 is drafted from a settled position rather than drifting into one. *Verify:* the decision is stated in the core with its reason, and it is recognisably a decision, not a description.
3. **Draft the core, sections 1–7 in the Playbook's order.** Each sentence traces to an observable behaviour (writing standard § 2). *Verify:* no sentence explains *why* a rule exists — rationale belongs in the reference document, not the core.
4. **Add the one worked example** for the task-state interface (Playbook item 4 requires "contents and an example"). At most one or two examples total across the core (writing standard § 4). *Verify:* the example is a real state file shaped by Step 2's evidence, not an invented richer one.
5. **Run the writing standard § 10 checklist against the draft**, inline. *Verify:* each of the nine checklist lines is answered explicitly, and the ones that fail are fixed rather than noted.
6. **Read-back pass for operator comprehension** (writing standard § 7): every technical term defined at first use, sentences short, no repository-internal shorthand left unexplained. *Verify:* a reader who has not read the Proposal can still say what the core makes each side do.
7. **Write and commit** `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`. *Verify:* file exists on disk with all seven sections; commit landed.
8. **Present the core to the operator for read and approval.** [STOP POINT — the mandate's exit condition requires it.] *Verify:* operator has responded.
9. **After approval: tick the mission thread** in `logs/missions/work-loop-v2-mvp.md` with an evidence pointer to the core, and update `plans/work-loop-v2-mvp/README.md` only if the folder's authority table genuinely needs the core recorded. *Verify:* the tick cites the file, not the session.

## Scope Alternatives
- **Min** — sections 1–7 present and correct, no worked example beyond a bare skeleton. Rejected: Playbook item 4 explicitly requires contents *and* an example.
- **Recommended** — steps 1–9 above: the full core with one worked state-file example, the hand-off-state decision made and recorded, checked against the writing standard, committed, approved, mission thread ticked.
- **Max** — also draft Step 4's slice plan in the same session. **Excluded by the mandate.** Step 4 is a separate step; the Playbook allows it in the same session, but the mandate for this session does not.

## Autonomy Posture
Gated — one stop point, and it is the mandate's own exit condition rather than an added ceremony.

**Stop points:**
- After step 7 (core written and committed), present it for the operator's read and approval before ticking the mission thread. The mission thread must not be ticked by assertion.
- Immediately, if drafting a section would require reopening a settled Proposal decision or making a Proposal-level call — specifically: changing the stated transport from Git to the shared working tree, or formalising Codex's inability to write `.git` into the role statement. Surface; do not decide.
- Immediately, if the Complete System explainer turns out to be the only source for something a section would contain. That means the scope has been misread.

## Risk
No structural change classes apparent — the deliverable is a plan-folder document, not a command, skill, agent, hook, symlink, or automation. Nothing becomes runnable this session; the core is a specification that Steps 4 and 5 will later implement against. Re-size the review if scope changes.

Two notes that are not risk classes but bear on the work:

- **The core is load-bearing for everything downstream.** Steps 4 and 5 build against it and the writing standard forbids restating its rules elsewhere, so an error here propagates silently into both artifacts. That argues for the operator-approval stop point above, which the mandate already requires — not for extra gates.
- **Environment-fit check: not applicable.** The work product is a document, not an executable or launcher.

`/blindspot-scan` is skipped: this plan creates no runnable infrastructure, which is the narrow band the gate is scoped to.
