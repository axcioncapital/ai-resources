# EmailOS-to-MVP Resources

> ## ⚠️ Historical record — Work Loop v1 is retired. Do not follow the `/work-loop` routing below.
>
> **`/work-loop` no longer exists.** The command was deleted on 2026-08-06 (`0516bf6`) and its Codex
> controller skill was retired on 2026-08-11 under Axcíon Harness v0.2 Phase 0, which required Work
> Loop v2 to be the only plausible semantic router.
>
> **The live Work Loop is v2:** `/work-loop-v2` (Claude side), `.agents/skills/work-loop-v2/SKILL.md`
> (Codex side), and `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` (the executable
> core). **v2 is not a renamed v1** — it has a different admission rule (Direct Work is the default),
> a different unit cycle and a different artifact set, and it does **not** carry the
> Frame–Shape–Build–Prove–Land lifecycle or write capability records. Do not map the entries below
> onto it.
>
> `skills/capability-development/SKILL.md` is likewise an inert v1 method document — it has no live
> executor and cannot be invoked by a model.
>
> This collection is **preserved as historical evidence** of how routing worked when it was written.
> Read it as a record, not as an instruction.

## Knowledge

- [Systems Builder workflow](../../../projects/axcion-systems-builder/workflow.md)
  Primary authority for Phases 4–14. Use for: the purpose, required output, and approval test of each phase.
- [Systems Builder operating guide](../../../projects/axcion-systems-builder/engine.md)
  Repository-level translation of the workflow. Use for: tool ownership, artifact names, standing rules, and the handoff boundary.
- [Systems Builder Claude instructions](../../../projects/axcion-systems-builder/CLAUDE.md)
  Authority for how Claude authors the case and when `/reconcile` is required. Use for: session roles and major-output quality gates.
- [Systems Builder Codex instructions](../../../projects/axcion-systems-builder/AGENTS.md)
  Authority for Codex's narrow red-team role and the four review questions. Use for: review handoffs and decision rights.
- [EmailOS Detailed Needs Document](../../../projects/axcion-systems-builder/cases/email-system/02-detailed-needs-document.md)
  Current case state and substantive requirements. Use for: A2/A3, current open questions, CRM authority, and Phase 5 completion.
- [EmailOS shared questions](../../../projects/axcion-systems-builder/cases/shared-questions.md)
  Cross-case decisions that may inform but do not automatically settle EmailOS. Use for: separating EmailOS ownership from nearby precedents.
- [Review-packet builder](../../../projects/axcion-systems-builder/cases/scripts/build-review-packet.sh)
  Executable authority for building and verifying packets at Phases 6, 8, 9, and 12. Use for: exact terminal syntax and stale-packet protection.
- [`/leverage-idea`](../../.claude/commands/leverage-idea.md)
  Authority for routing a rough, owner-uncertain idea to its next lifecycle. Use for: recognising why EmailOS is already past idea intake and should not be sent through it again.
- [`/work-loop` contract](../../docs/work-loop.md)
  Process authority for developing an operating capability inside an existing project. Use for: streams, route depth, review placement, evidence, and the Frame–Shape–Build–Prove–Land lifecycle.
- [Capability-development method](../../skills/capability-development/SKILL.md)
  Method consumed by `/work-loop` for operating-capability units. Use for: the intervention ladder, owner and seam selection, trials, vertical slices, proof, and lifecycle decisions.
- [`/develop-ai-resource`](../../.claude/commands/develop-ai-resource.md)
  Authority for qualifying and building a new or materially expanded durable AI artifact. Use for: a bounded artifact handoff from `/work-loop`, never for owning EmailOS as a whole.
- [Project Planning operating guide](../../../projects/project-planning/CLAUDE.md)
  Authority for context-pack, plan, and spec creation before `/new-project`. Use for: the post-Systems-Builder adapter sequence.
- [`/new-project` command](../../.claude/commands/new-project.md)
  Authority for implementation orchestration. Use for: qualification, architecture, implementation, and Stage 5 verification.

## Wisdom (Practice Feedback)

- Axcíon's operator–Claude–Codex review loop
  Claude authors, Codex independently challenges, and Patrik decides. Use for: testing judgment against a real case without surrendering authority to either model.
- The controlled EmailOS pilot
  A real 10–15-contact wave, preceded by dry runs and founder approval, is the practitioner feedback loop. Use for: discovering whether the operational design works outside documents.

## Gaps

- The repository documents no single explicit adapter command from Systems Builder's `01`–`06` package to the planning artifacts `/new-project` currently discovers. The lesson therefore labels the Project Planning bridge as a derived, conservative handoff rather than pretending it is a documented one-command transition.
- `/new-project` currently includes implementation and Stage 5 verification, while `/work-loop` owns capability slices and operating proof once a project exists. No authority document gives one canonical overlap rule. The lesson therefore uses the conservative seam: `/new-project` establishes the project and initial verified implementation; `/work-loop` inspects that as current reality, reuses evidence that already proves a behaviour, and builds only missing capability slices.
- EmailOS's final technical approach is intentionally unknown until Phase 10. Any earlier architecture shown in a lesson would be speculation.
