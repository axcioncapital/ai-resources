# Axcíon AI Resource Development Resources

## Knowledge

- [AI Resource Creation Rules](../ai-resource-creation.md)
  Governing routing rules for new and modified AI resources. Use for: deciding between `/develop-ai-resource`, `/create-skill`, `/improve-skill`, and project-local placement.
- [`/leverage-idea`](../../.claude/commands/leverage-idea.md)
  Current rough-notes router. Use for: turning an idea dump into evidence-backed options, an implementation plan, and a self-contained handoff.
- [`/develop-ai-resource`](../../.claude/commands/develop-ai-resource.md)
  Qualification and artifact lifecycle. Use for: deciding whether a durable AI artifact should exist, selecting the smallest mechanism, building, verifying and obtaining a disposition.
- [`/work-loop` contract](../work-loop.md)
  Governing cross-model lifecycle for operating capabilities and settled corrections. Use for: Frame → Shape → Build → Prove → Land, route depth, evidence and operator gates.
- [`/work-loop` command](../../.claude/commands/work-loop.md)
  Claude-side orchestrator for the contract. Use for: executing and resuming units. Where it conflicts with the contract, the contract wins.
- [Independent Review Rule](../qc-independence.md)
  Current policy for proportional independent review. Use for: deciding whether a change needs no review, one result review, or a risk-aware pre-implementation review.
- [`/create-skill`](../../.claude/commands/create-skill.md)
  Build engine for a new skill after qualification. Use for: structure approval, implementation, skill evaluation, verification and operator approval.
- [`/improve-skill`](../../.claude/commands/improve-skill.md)
  Direct path for a settled change to an existing skill. Use for: baseline, feedback triage, implementation, skill evaluation and final approval.
- [Matt Pocock's `teach` skill](https://github.com/mattpocock/skills/blob/main/skills/productivity/teach/SKILL.md)
  Teaching method used for this workspace. Use for: mission-grounded lessons, trusted sources, retrieval practice and quick-reference material.

## Wisdom (Communities)

- The operator's own completed `/work-loop` and `/develop-ai-resource` runs.
  Use for: comparing the written process with what actually creates friction, good decisions and useful evidence.
- `logs/friction-log.md`, `logs/decisions.md`, and `logs/improvement-log.md`
  Use for: learning from observed failures and adopted process changes rather than from idealized procedure alone.

## Gaps

- The review-layer consolidation adopted on 2026-07-29 has not yet been propagated into every caller. The playbook therefore names the governing source and the temporary manual bridge where the live commands lag policy.
