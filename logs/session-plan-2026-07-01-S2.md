# Session Plan — 2026-07-01

## Intent
Build the `/scope-project` complex-build scoping workflow from the approved plan — risk-check + blind-spot scan first, then create the skill, command, 3 stage agents, reference doc, and the two-lanes pointer note.

## Model
opus — match (deciding-heavy: architecture design of a new multi-artifact workflow)

## Source Material
- `~/.claude/plans/i-want-to-develop-cached-blum.md` — the approved build spec (read in full)
- `ai-resources/skills/context-pack-builder/SKILL.md` — epistemic-labeling discipline to reuse in the new skill
- `ai-resources/.claude/commands/new-project.md` — orchestrator + stage-agent + operator-gate pattern to mirror
- `projects/project-planning/pipeline/ref-context-pack.md` — 11-element brief shape the planning brief must conform to
- `projects/project-planning/.claude/agents/context-evaluator.md` — verdict/contract structure to copy for `scope-qc-evaluator`
- `ai-resources/docs/context-pack-schema.md` — parallel structure for the new `control-pack-schema.md`
- `ai-resources/docs/audit-discipline.md` — risk-check change classes (new command + agents + skill + CLAUDE.md edit)
- `ai-resources/skills/ai-resource-builder/SKILL.md` — `/create-skill` pipeline entry for the skill build

## Findings / Items to Address
Build spec is `~/.claude/plans/i-want-to-develop-cached-blum.md`; the six artifacts and one doc touch:
1. **Skill `project-scoping`** → `skills/project-scoping/SKILL.md` — 5-stage methodology, operating principles, doc-architecture decision rules, one-page-note collapse, consolidated-QC checklist, planning-brief spec. Build via `/create-skill`. (plan § What to build #1)
2. **Command `/scope-project`** → `.claude/commands/scope-project.md` — opus orchestrator, Stages 0–5 with operator gates, delegates to agents, emits control pack + brief. (plan § stage spec)
3. **Agent `scope-synthesis-agent`** → `.claude/agents/scope-synthesis-agent.md` — sonnet, Stage 2 notes consolidation, notes-to-disk + ≤30-line summary. (plan #3)
4. **Agent `scope-architecture-agent`** → `.claude/agents/scope-architecture-agent.md` — opus, Stage 3 document-architecture map, resists over-documentation. (plan #4)
5. **Agent `scope-qc-evaluator`** → `.claude/agents/scope-qc-evaluator.md` — opus, Stage 5 consolidated QC, four dimensions, five-way verdict, three-way ledger; mirror `context-evaluator`. (plan #5)
6. **Reference `control-pack-schema.md`** → `docs/control-pack-schema.md` — control-pack artifact definition, one-page-note schema, doc-architecture rules, per-doc elements, verdict/ledger, brief-derivation. (plan #6)
7. **Pointer note** → `projects/project-planning/CLAUDE.md` § How It Works — "Two intake lanes" (simple → `/context-builder`; complex → `/scope-project`); both emit `context-pack.md`. Pointer only, no methodology. (plan § Integration)
8. **`decisions.md` entry** — two-lane design + the 4-point canonical-placement override rationale (plan Decision 5). (plan § Integration)

## Execution Sequence
1. **Risk-check (plan-time gate).** Run `/risk-check` — new command + 3 agents + new skill + project-planning CLAUDE.md edit. Verify: GO/PROCEED-WITH-CAUTION verdict captured; STOP if RECONSIDER/NO-GO.
2. **Blind-spot scan.** Run `/blindspot-scan` on the plan (≥3 files + risk classes). Verify: verdict surfaced; resolve findings if PAUSE-AND-FIX before building.
3. **Confirm mounts.** Confirm both `ai-resources/` and `projects/project-planning/` are mounted (`--add-dir`) before any project-planning write. Verify: both paths writable.
4. **Reference doc.** Write `docs/control-pack-schema.md` first (agents + skill reference it). Verify: file exists, covers catalogue + schema + rules + verdict/ledger + brief-derivation.
5. **Skill.** Build `project-scoping` via `/create-skill`. Verify: SKILL.md passes the pipeline's QC gate.
6. **Three agents.** Write the 3 agent files with Subagent Contract (notes-to-disk, ≤30-line summary + path) and correct model tiers. Verify: each file has valid frontmatter + tier per plan table.
7. **Command.** Write `.claude/commands/scope-project.md` — opus orchestrator, Stages 0–5, gates, adjunct wiring. Verify: `/qc-pass` on command + skill.
8. **Pointer note + decisions entry.** Add the two-lanes note to project-planning CLAUDE.md; record the 4-point placement rationale + two-lane design in `decisions.md`.
9. **Verification dry-run.** Dry-run per plan § Verification (Stage-3 over-documentation refusal + split; Fresh Claude Test on the emitted brief). Verify: handoff is zero-touch.
10. **Commit** directly (no push — batched to `/wrap-session`).

## Scope Alternatives
- **Min:** reference doc + skill + command + 3 agents only; defer the dry-run verification to a follow-up session if context runs short.
- **Recommended:** all 6 artifacts + pointer note + decisions entry + the verification dry-run — full plan.
- **Max:** recommended + an actual dry-run on real `projects/strategic-os/` CRM material (heavier; context-gated).

## Autonomy Posture
Gated

**Stop points:**
- After `/risk-check` — if verdict is RECONSIDER/NO-GO, stop and revise
- After `/blindspot-scan` — if PAUSE-AND-FIX, resolve before building
- Before the `projects/project-planning/CLAUDE.md` edit — confirm the mount
- `/create-skill` runs its own internal gates for the skill build

## Risk
Run `/risk-check` after the plan is approved (plan-time gate) — this touches multiple structural change classes: new command, new agents, new skill, cross-project CLAUDE.md edit. Run it again before commit (end-time gate). `/blindspot-scan` fires post-approval, pre-implementation. `/placement` homes are pre-confirmed in the plan table against `repo-architecture.md § Canonical homes`.

### Risk-check result (2026-07-01) — PROCEED-WITH-CAUTION
Report: `audits/risk-checks/2026-07-01-build-scope-project-complex-build-scoping-workflow.md`. SO concurred. Four hard gates:
1. Pin ONE canonical handoff contract across schema/SKILL/command/agents; run the end-to-end `/plan-draft` discovery test before commit.
2. Land the 4-point canonical-placement rationale (DR-7 override) + revert path in `decisions.md` in the build commit.
3. Register all 3 agents in `agent-tier-table.md` (sonnet/opus/opus).
4. **Auto-sync exclusion (operator-confirmed):** add `scope-project` to `EXCLUDE_COMMANDS` and `scope-*` to `EXCLUDE_AGENT_GLOBS` in `auto-sync-shared.sh`.
Execution cautions: run `/create-skill` as its own fresh-context step (QS-1/DR-2); commit atomically (enumerate paths, no `git add -A`).

### Blind-spot scan result (2026-07-01) — PROCEED-WITH-CONSTRAINTS
Open findings to close during the build:
1. **Handoff is content-shape, not filename.** `plan-draft.md:7` takes a path arg and validates by content markers (Project Purpose / Scope / Constraints), not a fixed `context-pack.md` filename. Pin the CONTENT-SHAPE contract (ref-context-pack 11 elements + the section headers plan-draft validates) in `control-pack-schema.md`; run the discovery test with an explicit path `/plan-draft {brief-path}`. (This IS mitigation #1, sharpened.)
2. **EXCLUDE token forms.** `EXCLUDE_COMMANDS` exact-match, `EXCLUDE_AGENT_GLOBS` glob. Use bare `scope-project` (no `.md`) + `scope-*`.
3. **Two-repo mount.** Confirm `projects/project-planning/` mounted before the CLAUDE.md edit + dry-run (plan Step 3).
