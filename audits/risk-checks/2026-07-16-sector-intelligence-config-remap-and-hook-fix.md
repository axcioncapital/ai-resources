# Risk Check — 2026-07-16

## Change

Two structural changes landing in one approved restructure of projects/axcion-sector-intelligence (the multi-unit restructure).

CHANGE CLASS 1 (CLAUDE.md edit): re-map the `## Project Config` block so `{section}` = one research unit (a subsector/tight-cluster slug) instead of the seven mandatory-core sections. Concretely: `Section IDs:` → active unit slug(s) not the seven chapters; `Report set:` → current unit slug; `Current Section:` (Project Context) → current unit slug; add a one-line note that {section}=research unit and the seven mandatory-core sections are report chapters; `Document model: "report"` unchanged. Downstream consumers that read the Project Config block: the 3 Stage-5 commands (produce-prose-draft, produce-formatting, produce-jargon-gloss), three Stage-2 skills, country-parity-checker, Bundle-2 reference docs (mostly forward-contract per docs/project-config-schema.md).

CHANGE CLASS 2 (.claude/settings.json hook edit): the SessionStart hook extracts section IDs via regex `[0-9]+\.[0-9]+`, which never matched this project's named sections and won't match unit slugs either; fix the extraction to match slug-style {section} values (display-banner only, no shared-state effect). Both are project-local; no canonical ai-resources shared skills are edited.

**Additional design context (from the approved restructure plan):**
- The project pipeline already produces multiple clusters → multiple chapters within one `{section}` run; Stage 4 (`research-structure-creator`) builds the report architecture. So `{section}` = the research unit and the seven mandatory-core sections = the chapters of that unit's report is the coherent mapping.
- The rejected alternative was keeping `Section IDs` = the seven sections and running the pipeline once per section (7 runs/unit) — too heavy, and "conclusion" is synthesis not a research topic.
- Sequential-mode operation: one unit at a time in existing stage folders; no `{unit}/` path-prefix restructure; finished unit archived to a durable knowledge-base/ store; working folders reset between units.
- `docs/project-config-schema.md` documents the config block; per that doc most consumers are "forward-contract" (intended future readers) except the 3 Stage-5 commands which are wired as the first live consumers.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/docs/project-config-schema.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/.claude/commands/produce-prose-draft.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/.claude/commands/produce-formatting.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/.claude/commands/produce-jargon-gloss.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/reference/stage-instructions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/reference/file-conventions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/reference/source-class-hierarchy.md — **resolved: does NOT exist** (confirmed via `ls`; the project's own CLAUDE.md line 26 and `docs/project-config-schema.md` § Single source of truth cite it as the "derived mirror" for `Country set`, but it has never been created — a pre-existing gap, not introduced by this change since `Country set` is untouched here. Noted for completeness, not scored into this change's risk.)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Both change classes fix real, independently-verified defects with traced (not merely asserted) consequences and are correctly gated per DR-8, but the CLAUDE.md remap leaves one companion file (`reference/stage-instructions.md` § Sequence Constraints) internally contradicting the new mapping unless it is rewritten in the same landing.

## Consumer Inventory

Search terms used: `Section IDs`, `Report set`, `Current Section`, `Document model`, literal `{section}`, the three Stage-5 command basenames, the settings.json hook regex `[0-9]+\.[0-9]+`. Grepped across `projects/axcion-sector-intelligence/` and `ai-resources/` (canonical skills these consumers resolve to via symlink).

| Consumer path | Reference type | Must change? |
|---|---|---|
| docs/project-config-schema.md | documents | no |
| .claude/commands/produce-prose-draft.md | parses (forward-contract; hard-blocked — `reference/stage-5-paths.md` absent) | no |
| .claude/commands/produce-formatting.md | parses (forward-contract; hard-blocked) | no |
| .claude/commands/produce-jargon-gloss.md | parses (forward-contract; hard-blocked) | no |
| reference/stage-5-paths.template.md | documents (`{section}` ← `Section IDs` mapping; not yet instantiated) | no |
| **reference/stage-instructions.md** | parses `{section}` pervasively + **documents a now-contradictory "Sequence Constraints" paragraph** (lines 5–7) | **yes** |
| reference/file-conventions.md | documents (generic `{section}` naming patterns) | no |
| reference/quality-standards.md | parses (generic `{section}` usage) | no |
| reference/skills/report-compliance-qc/SKILL.md (canonical, symlinked) | parses (generic) | no |
| .claude/commands/run-preparation.md | parses (generic; `{section}` derived per-invocation from task-plan-draft filename) | no |
| .claude/commands/run-execution.md | parses (generic) | no |
| .claude/commands/run-analysis.md | parses (generic) | no |
| .claude/commands/run-report.md | parses (generic) | no |
| .claude/commands/run-sufficiency.md | parses (generic) | no |
| .claude/commands/run-synthesis.md | parses (generic) | no |
| .claude/commands/run-cluster.md | parses (generic) | no |
| .claude/commands/review-chapter.md | parses (generic) | no |
| .claude/commands/verify-chapter.md | parses (generic) | no |
| .claude/commands/intake-reports.md | parses (generic) | no |
| .claude/commands/inject-dependency.md | parses (generic) | no |
| .claude/commands/create-context-pack.md | parses (generic) | no |
| .claude/commands/produce-knowledge-file.md | parses (generic) | no |
| .claude/commands/audit-structure.md | parses (generic naming-convention checker; doesn't care which slug) | no |
| execution-manifest-creator (canonical skill, symlinked) | parses "current section" generically | no |
| transaction-table-builder (canonical skill, symlinked) | parses `{section}` generically | no |
| logs/decisions.md | documents (already records the intended remap) | no |
| logs/session-notes.md | documents (already records the intended remap) | no |
| .claude/settings.json | change site (CLASS 2) — not counted as a consumer | n/a |

**Total: 26 consumers found, 1 must-change** (`reference/stage-instructions.md`). For CLASS 2 (the hook regex), a separate targeted grep for the literal pattern `[0-9]+\.[0-9]+` across `projects/axcion-sector-intelligence/.claude/hooks` and `ai-resources/.claude/hooks` returned **zero** other hits — the regex is not duplicated or relied on elsewhere; CLASS 2 is a self-contained, isolated fix.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- CLAUDE.md is always-loaded, but the net token delta is roughly neutral-to-negative. Current line: `**Section IDs:** [definition-boundaries, why-now, finland-nordic-relevance, buyer-relevance, company-characteristics, risks-counterarguments, conclusion]  # parameterizes per-section paths` (CLAUDE.md:25, 7 slugs, ~230 chars) shrinks to a 1–2 unit-slug list under sequential-mode operation; the added "one-line note" (~20–30 words) roughly offsets the reduction.
- `Report set:` (CLAUDE.md:24) and `Current Section:` (CLAUDE.md:9) are value swaps of comparable length — no material delta.
- No new hook registered; CLASS 2 edits an existing SessionStart hook's regex in place — no new per-session or per-tool-call cost added (still one hook, same trigger).

### Dimension 2: Permissions Surface
**Risk:** Low

- `.claude/settings.json` `permissions` block (lines 2–32) is untouched by this change — confirmed by direct read; the edit is scoped to the `hooks.SessionStart` command string only (line 105).
- No new `allow`/`deny` entry, no scope change, no new tool-invocation pattern — the hook already runs via the existing SessionStart hook infrastructure the project already uses.

### Dimension 3: Blast Radius
**Risk:** High (mitigated — see Mitigations)

- Consumer Inventory (above): **26 distinct consumers** of the `{section}`/`Section IDs`/`Report set` contract, exceeding the rubric's >5-caller High threshold on count alone.
- Of these, **1 requires modification to keep the doc set internally consistent**: `reference/stage-instructions.md` lines 5–7 (§ Sequence Constraints) currently reads "Sections are produced in mandatory-core order and none may be skipped: (1) Definition and boundaries → … (7) Axcíon's conclusion… A report missing any of the seven sections is incomplete and cannot be closed." This directly describes the **old** per-chapter-as-pipeline-run interpretation of `{section}` that CLASS 1 is designed to retire. It is not machine-parsed (no command reads this specific prose programmatically), so nothing halts — but it is exactly the sentence a future Claude Code session reads when interpreting Stage 1, and following it as written would recreate the "7 runs/unit" defect the restructure exists to fix.
- Corroborating evidence this gap is real, not hypothetical: `logs/decisions.md` (2026-07-15) itself lists "added `stage-instructions.md § Sequence Constraints` rewrite to the edit list" as a QC fix to the build plan — i.e., the operator's own plan already identifies this companion edit as required, and it is **not** part of the CHANGE_DESCRIPTION handed to this review.
- The remaining 25 consumers are compatible generic pass-throughs: the 3 Stage-5 commands are currently hard-blocked regardless (`reference/stage-5-paths.md` does not exist — confirmed via `ls`; Phase 0 Step 3 of all three commands halts on this before ever reading `Section IDs`), and the other ~20 pipeline commands/skills/docs consume `{section}` as a runtime-resolved generic placeholder (verified in `run-preparation.md`: "{section}" is derived from the task-plan-draft filename per invocation, not auto-iterated from `Section IDs`), so they pick up the new mapping without edits.
- No shared canonical `ai-resources/` skill requires edits — the two canonical skills found (`execution-manifest-creator`, `transaction-table-builder`) use the placeholder generically.

### Dimension 4: Reversibility
**Risk:** Low

- Both classes are single-file edits (`CLAUDE.md`, `.claude/settings.json`) — clean `git revert` restores prior state exactly.
- No propagated state: `preparation/task-plans/`, `preparation/research-plans/`, and `analysis/chapters/` contain only `.gitkeep` (confirmed via `ls`) — no artifacts have been produced under the old mapping yet, so there is nothing for a revert to leave stale.
- No git push, no external API writes, no Notion writes triggered by this change. `logs/session-notes.md` confirms "2 commits (v1, v2 reports) are local and unpushed" — this change would land the same way, under the existing push-gating rule.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The semantic meaning of `{section}` is jointly defined across three files — `CLAUDE.md` (`Section IDs`/`Report set` values), `reference/stage-instructions.md` (§ Sequence Constraints prose), and `reference/file-conventions.md` (naming patterns) — but CHANGE CLASS 1 as described only edits the first. This is the same fact scored under Dimension 3 (blast radius) but is also, independently, an **implicit cross-file dependency**: nothing enforces that `stage-instructions.md`'s prose stays synchronized with `CLAUDE.md`'s config semantics; the coupling is real but undocumented as a contract at either change site.
- The SessionStart hook's section-extraction regex (CLASS 2) implicitly depends on the checkpoint filename convention documented in `reference/file-conventions.md` (`{section}-step-{id}-checkpoint.md`, file-conventions.md:65) — but `.claude/settings.json` carries no comment naming this dependency. Pre-existing pattern (not newly introduced by the fix), but the fix doesn't add the missing cross-reference either.
- No functional overlap found: the regex pattern `[0-9]+\.[0-9]+` is not duplicated in any other hook or script (confirmed by grep — zero hits elsewhere), so CLASS 2 does not collide with another mechanism.

### Dimension 6: Principle Alignment
**Risk:** Low

- Checked against `{AI_RESOURCES}/../projects/strategic-os/ai-strategy/principles-base.md` (read; present) and workspace/repo CLAUDE.md (read in Step 1).
- **OP-9/AP-7/DR-7 (speculative abstraction):** Not triggered — this is a re-mapping of an *existing* config field to match its *already-real* usage pattern (22+ files already generically consume `{section}`; the Stage-5 commands and two canonical skills are documented, confirmed second-plus consumers), not new infrastructure built for an absent consumer.
- **OP-2 (automate execution, gate judgment):** Correctly gated — `logs/decisions.md` shows this was a Claude-proposed, operator-accepted judgment call with five logged decisions and rationale, not a silent automated change.
- **DR-8 (structural changes in gated classes require `/risk-check`):** Both change classes (cross-cutting CLAUDE.md edit; hook edit) squarely match DR-8's gated list — this risk-check invocation is the correct, expected process, not a bypass. `logs/session-notes.md` independently confirms the plan itself names "`/risk-check` ×2 (CLAUDE.md config edit; `.claude/settings.json` hook edit)" as a required gate.
- **OP-10, OP-12, OP-5, OP-11:** Not implicated — no cross-tool boundary change, no new detection mechanism, no advisory→enforcement shift, no principle being revised.
- **DR-1/DR-3 (placement):** Not implicated — both edits are to already-correctly-placed, already-existing project-local files.

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect (CLASS 1) — observed, not asserted.** Directly read `CLAUDE.md:25` (`Section IDs` = the 7 chapter slugs), `reference/stage-instructions.md:5-7` (§ Sequence Constraints prose describing those 7 slugs as sequential, individually-gated pipeline stages), and `.claude/commands/run-preparation.md:5` ("Use its file name to derive the section identifier" — i.e., `{section}` is set per-invocation from the task-plan-draft filename). Also directly read Stage 4's existing design (`reference/stage-instructions.md:139`: `analysis/chapters/{section}/` — chapters plural, *within* one section) which already assumes `{section}`=unit, contradicting Stage 1's prose. The "conclusion is synthesis not a research topic" claim is independently confirmed: CLAUDE.md:11 lists "(7) Axcíon's conclusion and recommended use" verbatim as one of the seven chapters.
- **Consequence — traced, not merely inferred.** Mechanically traced (not just "looks plausible"): `file-conventions.md` names the literal per-section path pattern (`{stage-dir}/checkpoints/{section}-step-{id}-checkpoint.md` etc.), and `Section IDs` under the old mapping lists 7 distinct slugs — so following the documented mechanism as written would require one task-plan/research-plan/checkpoint set per chapter (the "7 runs/unit" consequence), including a wasted full research pass for the "conclusion" chapter, which has no independent research content. This has not yet been *executed* (no artifacts exist under `preparation/task-plans/` — confirmed via `ls`, only `.gitkeep`), so the cost is not yet incurred in practice, but the mechanism producing it is directly traced through the actual file-naming/invocation logic, not assumed.
- **Defect (CLASS 2) — observed.** Directly read `.claude/settings.json:105`: `section=$(echo "$latest" | grep -oE '[0-9]+\.[0-9]+' | head -1)`. Cross-checked against `CLAUDE.md`'s actual `Section IDs` values (named slugs, no numeric `N.M` substrings) — the regex cannot match. **Consequence traced**, not assumed: the extracted `$section` feeds only into a `hookSpecificOutput.additionalContext` banner string (settings.json:105) — no shared-state write, no gate, no downstream branch depends on it. Also confirmed empirically that `find . -path '*/checkpoints/*' -type f` returns only `.gitkeep` files project-wide, so the buggy branch is currently dormant (the `if [ -n "$latest" ]` guard skips it entirely) — the bug is real but its current runtime impact is exactly zero, escalating to a cosmetic blank-field banner once checkpoints exist. This matches the change description's own "display-banner only, no shared-state effect" characterization.
- **Re-derivation vs. the change description:** None — all claims re-derived and confirmed, including the exact regex string, the "three Stage-2 skills" consumer count (cross-referenced against `docs/project-config-schema.md`'s per-field fan-out: `research-prompt-creator`, `execution-manifest-creator`, `transaction-table-builder`), and "Document model unchanged" (confirmed `"report"` in CLAUDE.md:36, unaffected by either change class).

## Mitigations

- **Dimension 3 (High).** Rewrite `reference/stage-instructions.md` § Sequence Constraints (lines 5–7) in the same landing as the CLAUDE.md remap — before the next Stage 1 invocation for any research unit. Replace "Sections are produced in mandatory-core order… via separate pipeline passes… A report missing any of the seven sections is incomplete" with language stating the seven mandatory-core sections are **report chapters** produced within one `{section}`=research-unit run, assembled by `research-structure-creator` at Stage 4 (consistent with Stage 4's own existing `analysis/chapters/{section}/` design at stage-instructions.md:139). This closes the exact gap `logs/decisions.md` (2026-07-15) already flagged as required but which is outside this CHANGE_DESCRIPTION's scope.
- **Dimension 5 (Medium).** When editing the SessionStart hook (CLASS 2), add a short inline comment in `.claude/settings.json` (or a one-line cross-reference in `reference/file-conventions.md`) naming the dependency: the section-extraction regex assumes the checkpoint filename convention documented in `file-conventions.md`. This makes the coupling explicit so a future naming-convention change doesn't silently re-break the banner.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
