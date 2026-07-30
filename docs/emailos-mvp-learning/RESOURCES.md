# EmailOS-to-MVP Resources

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
- EmailOS's final technical approach is intentionally unknown until Phase 10. Any earlier architecture shown in a lesson would be speculation.
