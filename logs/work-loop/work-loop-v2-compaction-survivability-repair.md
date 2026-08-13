---
task: work-loop-v2-compaction-survivability-repair
turn: codex
---

## Objective and scope

Make Work Loop v2 reliably recover its authoritative task after Codex compaction in every intended Work-Loop-enabled project, without adding parallel state, weakening actor boundaries, or duplicating recovery authority. The task exits only when the instruction layer is review-clean, the approved deployment scope is installed, and one representative project-repository compaction proves recovery or a safe stop.

In scope across the task: the instruction-layer correction following commit `df35ddd`; deployment only to verified Work-Loop-enabled projects and future eligible scaffolds; the operator-approved user-level compact-hook carrier; proportionate operational proof. Excluded: distributing these skills to every project, a five-compaction endurance exercise, broad Work Loop redesign, a second recovery artifact, and approving or rewriting the executable core without a later explicit operator decision.

## Lane and unit

Standard. Discovery mode. Unit 2 — determine whether the planned compaction-survivability deployment has sufficient approved authority without treating the draft executable core as governing in full.

Named reason for the loop: the repair crosses sessions and repositories, needs bounding before deployment, and requires independent assessment of Claude's evidence before changes propagate to project environments.

Why this unit, why now: the operator approved the user-level hook carrier and chose `approved clauses only` for executable-core authority. Before deployment, this unit must establish whether each load-bearing deployment behavior is grounded in the approved Proposal, an individually approved core clause, or an explicit operator decision, so the implementation does not silently promote draft text into policy.

Governing authority: the operator's 2026-08-13 decisions to use a user-level hook carrier and keep executable-core authority to individually approved clauses; the operator's earlier instruction to use Work Loop v2 for this task; `plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md`, whose header says `Approved direction`. Individually approved core amendments may govern only the content their approval notes identify. The rest of `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` is a non-governing draft for this unit, although it may be inspected as a claim source.

Codex framing decision: this unit is authority discovery only. The separate `work-loop-v2` skill-size standards finding, deployment edits, user-level settings write, project changes, operational proof, and the deferred hook-pointer duplication concern are held outside because each has a different deliverable.

## Brief

Required outcome: return a bounded authority determination for the planned deployment—either it can proceed under already approved sources, or name the exact behavior that still lacks approval. Do not implement, edit instructions, or create an approval ledger or second authority artifact.

Check against the repository:

1. Verify the deployment surfaces and behaviors actually proposed by the report and its triage, using `/Users/patrik.lindeberg/.codex/attachments/1cce4518-9dfb-47ba-b494-5f9b0479bf23/pasted-text.txt`, `audits/working/2026-08-13-resolve-verify-and-qualify-the-work-loop-v2-compaction.md`, the current instruction files, and any directly cited deployment records. These are verify-first evidence or non-governing background, not authority. Bound the result to compaction survivability; do not expand into all Work Loop behavior.
2. For each load-bearing behavior needed by that deployment—at minimum preservation of the exact task pointers, invoking Reorient after compaction, exact-path then validated local `.owner` recovery with safe stop, actor boundaries, the single task-state interface, and the user-level hook carrier—identify the exact approved source that permits it. An approval counts only if its record identifies the content it approved; filename, age, or draft wording alone does not count.
3. Search only the directly relevant approval surface: the Proposal, the executable core's explicit approval notes and their cited decision records, the current task's operator decisions, and directly cited Work Loop plan records needed to validate those notes. For any claimed absence, report the searched paths and approval pattern. Do not audit or reconcile the whole executable core.
4. Distinguish authority from repository reality. A deployed or currently used behavior is not approved merely because it exists. Conversely, a behavior grounded in the approved Proposal need not be promoted from the draft core.

Required evidence capable of failure:

- A compact behavior-by-behavior result in this state file: `approved source found` with an exact section/decision citation, or `approval gap` with the bounded search surface that failed to establish it.
- Quote or precisely paraphrase the approval language and identify the content it binds; do not cite only filenames.
- State one clear conclusion: `deployment may proceed without full-core approval`, or `deployment is blocked`, naming the exact unresolved behavior and operator decision required.
- Confirm no repository file changed except this state file, `logs/friction-log.md` remained untouched and excluded, and no user-level or project setting was written.
- Set `turn: codex` and commit the discovery handback. Do not push.

Completion condition: Claude returns enough cited evidence for Codex to decide whether the deployment unit can open under approved authority, without implementing anything or manufacturing a new approval record.

Stop and hand back if the proposed deployment scope cannot be established from the bounded sources, an approval note lacks identifiable content, or the evidence conflicts. Stop for the operator only if resolving the gap requires a new approval rather than further repository inspection. A false premise is a valid result; report it instead of widening the search.

## Latest result

Discovery unit. No claims were pre-stated for checking; the findings below are the inspection record (core § 3 step 4, § 6 rules 3 and 5).

Inspected (2026-08-13):

- Searched surface, as bounded by the brief: `plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md` (read in full, 170 lines); `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` (read in full, 475 lines); the core's three approval notes and the one decision record they cite (`step-2-transport-seam-conclusions.md` § 2); `plans/work-loop-v2-v0.2/work-loop-v2-proportionality-continuity-implementation-plan-v0.1.md` § 1 (OD table), § 4.9, § 5 slice table, § 7 non-adoptions; the closing records of `work-loop-v2-proportionality-continuity-implementation` and `work-loop-v2-concurrent-task-isolation`; `logs/decisions.md` (181 lines, grepped); this state file's recorded 2026-08-13 operator decisions. Verify-first background: the source report and `audits/working/2026-08-13-resolve-verify-and-qualify-the-work-loop-v2-compaction.md`.
- The core carries exactly three approval notes — searched `work-loop-v2-executable-core-v0.1.md` for `approved on its own|Operator decision|Status:`; found L163–165 (the *good enough, proceed* clause), L283–285 (the courier clause), L401–410 (`Who commits: Claude`, 2026-08-01, citing `step-2-transport-seam-conclusions.md` § 2). Each names the content it binds. No other section of the core carries an approval.

### Behavior-by-behavior authority result

1. **Preservation of the exact task pointers — APPROVED SOURCE FOUND, but bounded to `ai-resources`.** Accepted plan § 4.9 *Who preserves what* approves exactly the four pointers ("the **exact active** `logs/work-loop/{task-id}.md` path; the **bound checkout**…; the **governing plan** path, and the **workflow and phase**; the current **`## Next action`**"), discharging OD-5 ("After compaction, Codex must recover from durable authoritative context rather than drift from a lossy summary"), landed as slice S6 and accepted in that task's closing record ("four preservation pointers in `AGENTS.md` § *Compaction*"). **The approval's surface is explicit and narrow:** § 4.9's `**Files:**` line names `ai-resources/AGENTS.md`, `ai-resources/.codex/hooks.json`, `ai-resources/.codex/hooks/work-loop-reorient.sh` — and nothing else.

2. **Invoking Reorient after compaction — APPROVED AS BEHAVIOR, NOT AS THE NAMED SKILL.** OD-5 approves post-compaction recovery from durable authoritative context. The `reorient` skill is named in no approved source: § 4.9's design is the `AGENTS.md` list plus a hook that instructs re-reading pointers by hand. `git log -- .agents/skills/reorient` returns `f74bd5d` (2026-08-11, "batch: add Codex reorient skill"), with no plan record, no core clause and no `logs/decisions.md` entry. Its gate inside `ai-resources` was landed by this task's Unit 1 and accepted by Codex.

3. **Exact-path then validated local `.owner` recovery with safe stop — APPROVED SOURCE FOUND.** The `.owner` mechanism is operator-landed: the `work-loop-v2-concurrent-task-isolation` closing record states it is live on canonical `main` at `0d9e335`, the operator "declined a synthetic fan-out trial and chose immediate controlled landing". The safe stop is approved twice over — Proposal Phase 1 § 74 enumerates the safety rules ("validate untrusted input read-only before mutating anything") and core § 6 rules 1–2 and § 7 carry them. The recovery *order* itself has no separate approval record; it was designed in the 2026-08-13 triage and landed by this task's Unit 1.

4. **Actor boundaries — APPROVED SOURCE FOUND for the boundary; APPROVAL GAP on the sub-rule the deployment leans on.** Proposal § 2 and core § 1 approve the three-party split ("Codex manages progression; it is not sovereign over the project or over repository reality"; "**Claude** owns repository reality"). But the narrower sub-rule *Codex runs no git* — the ground on which the triage dropped report §2 validation 7 and confined the `.owner` fallback to local depth — appears **nowhere in the approval surface**: searched the Proposal, the core and the accepted plan for `runs no git|run no git|no git|worktree list`; no match. It exists only in the deployed instruction layer (`work-loop-v2/SKILL.md` L193, L195; `reorient/SKILL.md` L70). The one cited approval record establishes a **narrower** fence than that text claims — `step-2-transport-seam-conclusions.md` § 2: "**The fence is on `.git` writes specifically — not on Git as a whole.** … `git status --short` succeeded, `git log --oneline` succeeded, `git add` failed. Read commands pass; the write is refused." `git worktree list` is a read. This over-restricts rather than over-reaches, so it does not endanger the deployment — but the boundary argument rests on unapproved text, not on the record it cites.

5. **The single task-state interface — APPROVED SOURCE FOUND.** Proposal Decision 6 ("Task-state interface: one authoritative interface, probably one file, not dogma") and § 6 *One interface, not one dogma* ("Its physical shape may evolve if real use justifies it; its authority as the single interface does not"). Accepted plan § 7 refuses "A task registry, or a 'current task' state field" and "A session diary, context pack, or handoff document". The planned deployment adds no second state system.

6. **The user-level hook carrier — APPROVED SOURCE FOUND.** This task's recorded operator decision of 2026-08-13: use `~/.codex/hooks.json`, "accepting that it is machine-specific and unversioned". It identifies its content — it is the answer to the single item the triage escalated ("One item to put to the operator rather than decide here: item 7's carrier choice"). One qualification, not a block: Proposal § 7 lists **hooks** under post-MVP work, "Each requires a real operational trigger before it is built" — already discharged for the compact hook, which was built and accepted under S6.

7. **Deploying `reorient` and `handoff-thread` into project repositories (`skills.shared`) — APPROVAL GAP.** Searched the Proposal, the core and the accepted plan for `shared-manifest|skills.shared|project repositor|new-project|project AGENTS|every project|project-level deploy` — **no match in any of the three**. `handoff-thread`'s behavior has an approved source (OD-6, discharged § 4.7), but no approved source places either skill in a project repository. The only record naming this surface is Codex's own scope framing in this state file.

8. **The four preservation pointers in project `AGENTS.md` — APPROVAL GAP.** Same bounded search, same absence. § 4.9's `**Files:**` line affirmatively scopes the preservation contract to `ai-resources/AGENTS.md`.

9. **The `/new-project` scaffolding template — APPROVAL GAP.** Same bounded search, same absence. This surface also reaches beyond compaction survivability: it changes what every future project is born with.

### One repository-reality finding that resizes the deployment

The triage's remedy for item 5 states the fix is "**The only thing missing is two more strings in three files**". By inspection that holds for one project, not three. `projects/axcion-systems-builder/.claude/shared-manifest.json` carries `"skills": { "local": [], "shared": ["work-loop-v2"] }`. The manifests of `axcion-systems-builder-dashboard` and `axcion-systems-builder-methodology-r-d`, read in full, carry **no `skills` key at all** — only `commands` and `agents`. Yet all three projects do carry a `work-loop-v2` entry under `.agents/skills/`. So in two of the three, that entry is not produced by the declared `skills.shared` mechanism, and its provenance is unestablished. The deployment is larger than the triage sized it, and the two unexplained symlinks should be accounted for before more are added.

Result: the bounded authority determination is complete. Six of the nine load-bearing behaviors have an identified approved source; three do not, and they are the three that constitute the project-repository surface.

Evidence: the determination could have read the other way and did so in part — behaviors 3, 5 and 6 were checked against the same bounded surface and each returned a citation naming its content, while 7, 8 and 9 returned a grep with exit 1 across all three approval documents. The distinguishing fact is § 4.9's `**Files:**` line, which affirmatively scopes the approved compaction design to three `ai-resources/` paths rather than merely failing to mention others.

**Conclusion: deployment is blocked — but not on core approval.**

*Not on core approval.* No load-bearing deployment behavior requires promoting an unapproved section of `work-loop-v2-executable-core-v0.1.md`. Every one traces to the approved Proposal, the accepted proportionality-continuity plan, an individually approved core clause, an operator-landed mechanism, or the 2026-08-13 operator decisions. The `approved clauses only` setting is sufficient for this deployment.

*Blocked on one narrower decision.* The exact unresolved behavior is **extending the S6 compaction contract beyond `ai-resources`** — items 7, 8 and 9 above. The operator decision required: approval to install the compaction-survivability surface into the named project repositories (`skills.shared` entries plus the four preservation pointers in each project `AGENTS.md`), and a separate decision on whether the `/new-project` scaffolding template changes with it or is held back as its own item. The hook-carrier half of the deployment is already approved and is not part of this gap.

Repository state, reported precisely rather than as the brief predicted it. **This unit wrote exactly one file: this state file.** No user-level file, no project file, no instruction file and no setting was written; nothing outside this checkout was touched.

**`logs/friction-log.md` did change, and the brief's expected `remained untouched` cannot be confirmed as written.** No edit was made to it by this unit. A harness hook appends a `#### Write Activity` telemetry line for every Write/Edit in the session, so each of this unit's two writes to the state file produced one appended line (`11:12` and `11:13`, both naming this state file). Its `sha256` therefore moved from `ee9414ff…2591cee` to `c66ffbcd…d12f3ce6` across this unit without any deliberate edit. The file is **excluded from the commit** — only the state file is staged by explicit pathspec — so the change stays uncommitted, exactly as the 18-line block that already pre-dated this unit does. Verified by `git diff logs/friction-log.md`: every added line is write-activity telemetry, and no content line was altered. The exclusion held in substance; the mechanism makes literal untouchedness unachievable for any unit that writes at all, which is itself worth Codex knowing before the next brief repeats the condition.

Deferrals noticed during this unit, recorded and not done: (i) the *runs no git* over-restriction in finding 4 — the deployed text claims a wider fence than its cited record supports, which is a text-accuracy defect, not a safety one; (ii) the two unexplained `work-loop-v2` symlinks in finding 5; (iii) the previously held skill-size standards finding, still outside this unit.

## Blocker

The deployment's project-repository surface has no approved source. Items 7, 8 and 9 of the authority result are grounded only in Codex's scope framing in this state file, while the accepted plan § 4.9 affirmatively scopes the approved compaction design to three `ai-resources/` paths.

## Next action

Codex: decide whether to open the deployment unit narrowed to the already-approved surface, or to stop for the operator on the extension decision named in the conclusion. Note that the deployment is larger than the triage sized it — two of the three project manifests have no `skills` key at all.
