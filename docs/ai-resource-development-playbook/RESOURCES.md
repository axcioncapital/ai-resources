# Axcíon AI Resource Development Resources

> ## ⚠️ Historical record — Work Loop v1 is retired. Do not follow the `/work-loop` routing below.
>
> **`/work-loop` no longer exists.** The command was deleted on 2026-08-06 (`0516bf6`) and its Codex
> controller skill was retired on 2026-08-11 under Axcíon Harness v0.2 Phase 0, which required Work
> Loop v2 to be the only plausible semantic router.
>
> **The live Work Loop is v2:** `/work-loop-v2` (Claude side), `.agents/skills/work-loop-v2/SKILL.md`
> (Codex side), and `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` (the executable
> core). **v2 is not a renamed v1** — it has a different admission rule (Direct Work is the default),
> a different unit cycle and a different artifact set. Do not map the entries below onto it.
>
> This collection is **preserved as historical evidence** of how routing worked when it was written.
> Read it as a record, not as an instruction.

## Knowledge

- [AI Resource Creation Rules](../ai-resource-creation.md)
  Governing routing rules for new and modified AI resources. Use for: deciding between `/develop-ai-resource`, `/create-skill`, `/improve-skill`, and project-local placement.
- [`/leverage-idea`](../../.claude/commands/leverage-idea.md)
  Current rough-notes router. Use for: turning an idea dump into evidence-backed options, an implementation plan, and a self-contained handoff.
- [`/develop-ai-resource`](../../.claude/commands/develop-ai-resource.md)
  Qualification and artifact lifecycle. Use for: deciding whether a durable AI artifact should exist, selecting the smallest mechanism, building, verifying and obtaining a disposition.
- **RETIRED** — `/work-loop` contract ([`../work-loop.md`](../work-loop.md), now an inert v1 method document with no live executor)
  Was the governing cross-model lifecycle for operating capabilities and settled corrections: Frame → Shape → Build → Prove → Land, route depth, evidence and operator gates. **Not a live authority.** Its v2 replacement is the executable core at `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`, which does not use these phases.
- **RETIRED** — `/work-loop` command (`.claude/commands/work-loop.md`, **deleted 2026-08-06**; link removed because the file no longer exists)
  Was the Claude-side orchestrator for the contract. Its v2 replacement is `/work-loop-v2`.
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
