# Risk Check — 2026-06-21

## Change

Stage C build for the axcion-website project: new project-local command /website-design-brief, new skill website-design-planning, new agent website-design-brief-reviewer, plus an in-place v2.2 amendment to the design-planning spec (output/build-specs/2026-06-20-page-visual-direction-command-spec-v2.md). The change folds claim-sensitive visual marking (claim_status: approved|candidate|needs-evidence|gated + visual_rule: can_lead|support_only|de_emphasize|omit) and early component-candidate surfacing into the existing /website-design-brief command, which becomes the canonical Stage C page-design-planning command (operator decision 2026-06-21: fold into existing command, do NOT build a parallel /design-page or output/design-plans/). Build-only — the command is not run to produce any real brief. No hooks, permissions, settings.json, or CLAUDE.md touched. All new resources are project-local and inert until invoked. This mirrors the established Stage A (website-content-source skill + /website-source-scan + /website-source-pack + website-context-curator agent) and Stage B (website-copy skill + /draft-page-content + website-copy-reviewer agent) resource trios.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/.claude/commands/website-design-brief.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/.claude/skills/website-design-planning/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/.claude/agents/website-design-brief-reviewer.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/output/build-specs/2026-06-20-page-visual-direction-command-spec-v2.md — exists (amended in place to v2.2)

## Verdict

GO

**Summary:** A pay-as-used, project-local resource trio plus an append-style spec amendment, fully isolated from always-loaded context, permissions, hooks, and publish state; every dimension scores Low and the change matches its stated "build-only, inert until invoked" intent.

## Consumer Inventory

All grep hits across `projects/axcion-website` and the workspace root resolve to one of three categories: (a) the four changed files cross-referencing each other (internal, expected, not external consumers); (b) decision/session/registry log entries that *document* the build; (c) plan/process-report prose that *names* the command. No hook, `settings*.json`, or `generate.sh` references any of the new resource names or the `claim_status` / `visual_rule` markers (verified empty). No file *invokes* the command at runtime or *parses* the brief's output — the command "is not run to produce any real brief" (CHANGE_DESCRIPTION), so it has no live callers yet.

| Consumer path | Reference type | Must change? |
|---|---|---|
| projects/axcion-website/.claude/agents/website-design-brief-reviewer.md | co-edits (part of the trio; gates the brief) | no |
| projects/axcion-website/.claude/skills/website-design-planning/SKILL.md | co-edits (the trio's discipline; both commands read it) | no |
| projects/axcion-website/.claude/commands/website-design-brief.md | co-edits (applies the skill; invokes the reviewer) | no |
| projects/axcion-website/output/build-specs/2026-06-20-page-visual-direction-command-spec-v2.md | documents (the contract; AC-B6/AC-B7) | no |
| projects/axcion-website/logs/decisions.md | documents (operator decision 2026-06-21, §422–426) | no |
| projects/axcion-website/logs/innovation-registry.md | documents (rows 10–11, `detected` status) | no |
| projects/axcion-website/logs/session-notes.md | documents (S3/S4 build notes) | no |
| projects/axcion-website/logs/session-plan-2026-06-20-S3.md | documents | no |
| projects/axcion-website/logs/scratchpads/2026-06-20-17-57-scratchpad.md | documents | no |
| projects/axcion-website/logs/scratchpads/2026-06-20-S4-scratchpad.md | documents | no |
| projects/axcion-website/output/process-overview/2026-06-20-content-to-design-process-report.md | documents (process map §102/§112) | no |
| projects/axcion-website/pipeline/project-plan.md | documents (Stage C / Build 3 sequencing, §428) | no |

Total: 12 consumers, 0 must-change. The future `/website-design-direction` command (a planned, not-yet-built sibling) will *consume the contract* this change establishes (the brief output path, the `claim_status`/`visual_rule` taxonomy, the component-candidate handoff) — but it does not exist on disk, so it is a forward dependency, not a current must-change consumer. No consumer outside the four changed files depends on the brief's output shape; the contract has no live downstream parser yet.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file touched. CHANGE_DESCRIPTION: "No hooks, permissions, settings.json, or CLAUDE.md touched." Verified: no `settings*.json` or `.claude/hooks/` reference to the new names or markers (grep returned empty).
- The command is pay-as-used: a project-local slash command loads only when the operator runs `/website-design-brief`. No SessionStart / Stop / PreToolUse / UserPromptSubmit hook is registered.
- The skill `website-design-planning` auto-loads only on its declared trigger ("running /website-design-brief … or any Stage C design-planning work", SKILL.md §3 description) — a narrow, project-stage trigger, not a broad keyword match that would fire in unrelated sessions.
- The agent `website-design-brief-reviewer` is spawned only at the brief's QC gate (command §6, "gate the brief with the … agent"), i.e. on demand during a Stage C run — not a frequently-spawned subagent.
- Build-only: "the command is not run to produce any real brief" — zero invocations land with this change, so ongoing token cost at landing is nil.

### Dimension 2: Permissions Surface
**Risk:** Low

- No permission change. CHANGE_DESCRIPTION: "No hooks, permissions, settings.json … touched." Verified: grep of `.claude/settings*.json` for the new names/markers returned empty — no `allow`/`ask` added, no `deny` removed.
- The agent declares `tools: Read, Grep, Glob, Write` (website-design-brief-reviewer.md §5–9). `Write` is scoped by its brief to `audits/working/design-brief-review-<page>.md` only (agent §31, "A write path for your report") — a working-notes path, not publish state or shared infra. This is within the established reviewer-agent pattern (matches the Stage A/B reviewer trios).
- No new Bash family, external API, MCP, or cross-repo write capability introduced. The command "Reads (by workspace path; cite, never copy)" upstream projects (command §28–37) — read-by-reference, already the project's established upstream-citation convention (project CLAUDE.md § Upstream-Citation Convention).

### Dimension 3: Blast Radius
**Risk:** Low

- Per the Step 1.5 inventory: **12 consumers, 0 must-change.** Nine of the twelve are log / registry / plan / process-report files that only *document* the build; the other three are the trio members that *co-edit* each other by design. None must change for the command to work.
- Direct files touched: 4 (3 new resources + 1 in-place spec amendment). The new resources are net-new files; the spec amendment is additive (v2.2 adds Stage 3.5, Stage 4.5, §8.13, AC-B6/AC-B7 — spec §8 "the brief portion of v2.1 is reissued under v2.2 with the two additions; the direction-command portion … is unchanged").
- No contract that a *live* caller depends on is changed: no `parses` consumer exists (no hook, no `generate.sh`, no downstream command reads the brief output — grep empty). The brief's output contract (`claim_status` + `visual_rule`, component-candidate fields) is *introduced*, not altered, and its only future consumer (`/website-design-direction`) is unbuilt.
- No shared infra touched: the boundary-leakage hook, `generate.sh`, `source-of-truth/`, and `apps/website/src/` are untouched (command Guardrails §86, "Nothing touches apps/website/src/ or source-of-truth/ publish state"). Confirmed: hooks grep empty.
- No inventory consumer was surfaced that CHANGE_DESCRIPTION did not anticipate — the description names the Stage A/B trios as the mirror, and the inventory confirms the pattern with no surprise callers.

### Dimension 4: Reversibility
**Risk:** Low

- Three of the four files are net-new (command, SKILL, agent) — `git revert` / file deletion fully restores prior state; no sibling directories are generated at build time (the command's output dir `output/design-planning/` is created only when the command *runs*, which this build does not do).
- The fourth file is an in-place edit to an existing spec (v2.2 amendment) — a single-file content change that `git revert` cleans up fully. The change is described as "in-place v2.2 amendment," and the spec retains v1/v2.1 history inline (spec §6–8), so revert leaves no orphaned cross-version state.
- No data/log mutation that revert cannot undo cleanly *as part of this build's contract*: the build itself writes only the four files. (The decisions.md / innovation-registry.md / session-notes entries are session-bookkeeping authored alongside, not artifacts this change forces — and they are append entries the operator manages, not auto-fired state.)
- No state pushed beyond git: no `git push`, no external write, no Notion/API POST in the change. No automation (hook/cron/symlink) added that could fire between landing and a revert (hooks grep empty).

### Dimension 5: Hidden Coupling
**Risk:** Low

- The new contract (`claim_status` / `visual_rule` taxonomy, the default mapping, the component-candidate fields) is **explicitly documented at every change site**: the SKILL (§89–131), the command (§57–69), the reviewer agent's checklist (§42–68), and the spec (§122–148, §259, AC-B6/AC-B7). A caller honoring the contract has a single, co-located source — no undocumented marker a future consumer must reverse-engineer.
- The brief *reads* `claim_status` from an upstream source it does not own — the Stage A pack (`content-source/page-source-packs/<page>.md`) and Stage B draft-copy `notes:` (SKILL §91–93, command §58). This is a genuine dependency on an established repo convention (the Stage A/B claim-flag format), but it is named explicitly and the hard rule forbids re-deriving or upgrading it ("Read the status from the pack / draft-copy `notes:` — never upgrade it", command §58). One named dependency on an established convention = Low/Medium boundary; it is documented, so Low.
- No silent auto-firing: nothing in the trio runs on a hook or session event. The reviewer agent fires only when the command invokes it, with a documented fallback (`/qc-pass`) when unreachable (command §77).
- No functional overlap with existing mechanisms: the spec resolves the naming collision explicitly (spec §58, "These replace v1's /design-page-direction and the review's … trio — naming collision resolved here") and the operator decision folds Stage C into this one command rather than spawning a parallel `/design-page` (CHANGE_DESCRIPTION; decisions.md §422–426). No second system contends for the same concern.

### Dimension 6: Principle Alignment
**Risk:** Low

- principles-base.md was readable (`projects/strategic-os/ai-strategy/principles-base.md`); checks below cite frozen IDs from it.
- **Speculative abstraction (OP-9 / AP-7 / DR-7):** Not violated. The trio is built for a *confirmed, current* consumer — the axcion-website Stage C page-design pipeline, with Stage A and Stage B trios already in place as the established pattern (CHANGE_DESCRIPTION). The component-candidate surfacing is scoped as "early signal, not the map" and explicitly *defers* the cross-page component map to the unbuilt direction command (SKILL §113–117) rather than building that infrastructure speculatively now. Building the brief command before its sibling direction command is sequencing a real pipeline, not a "hook for later." Low.
- **System boundary (OP-10):** Not touched. Stitch and Figma appear in the spec as *operator-driven manual tools the operator invokes* between commands (spec §156, §276, "Stitch = ideation sandbox … Figma = visual source of truth"), explicitly flagged as an operator adoption decision (spec §11.4) — the command does not govern or coordinate their behavior. The system stays Claude-Code-only. Low.
- **Closure before detection (OP-12):** Aligned, not violated. The reviewer agent is new *detection* (PASS/FAIL on claim-sensitivity et al.), but it ships *behind a working closure channel*: a blocking FAIL routes back to the build session to fix the brief and re-run (agent §117–123), and the command wires the gate inline with a `/qc-pass` fallback (command §77). Detection is paired with closure in the same change. Low.
- **Advisory vs enforcement (OP-5):** Not crossed. The command and reviewer *advise and stop* — the reviewer "Does not write or edit briefs," "Do not … change any `public_release` / `status` field" (agent §18, §131); the command "sets nothing live" and leaves Tier-C taste and publish as operator decisions (command Guardrails §86; SKILL §176). No advisory→enforcement upgrade. Low.
- **Automate execution, gate judgment (OP-2 / AP-4):** Respected. The judgment surfaces (visual taste, claim activation, publish) stay operator-gated and Tier-C; the command automates the *planning* execution and gates the *judgment* (SKILL §178–182, "the Tier-C judgment surface the project puts on Opus"). `model: opus` on the judgment-bound command and agent matches QS-5. Low.
- **Placement (DR-1 / DR-3):** Correct tier and home. These are project-specific resources (axcion-website page-design pipeline), placed project-local under `projects/axcion-website/.claude/{commands,skills,agents}/` — DR-1's "could this serve more than one project?" test is no (it is bound to this project's pages, gates, and source-of-truth), so project-local is the right tier; the spec flagged `/placement` as an open item (spec §11.2–11.3) and the trio matches the Stage A/B homes. Low.
- **Loud revision (OP-11 / OP-3):** The v2.2 spec amendment and the fold-into-existing-command call are *recorded loudly* — logged in decisions.md §422–426 with rationale, and the spec's revision header (§8) names exactly what v2.2 supersedes. No silent drift. Low.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, verbatim quotes from CHANGE_DESCRIPTION and the four referenced files, grep counts across `projects/axcion-website` and the workspace root, and frozen principle IDs from `principles-base.md`). No training-data fallback was used on fetch/read failures.
