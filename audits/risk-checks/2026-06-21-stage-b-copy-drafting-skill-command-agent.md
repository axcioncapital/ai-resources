# Risk Check — 2026-06-21

## Change

Stage B copy-drafting capability for axcion-website: a new project-local skill (website-copy), a new command (/draft-page-content), and a new agent (website-copy-reviewer), plus a design-note contract. The command consumes an approved Stage A source pack and drafts page copy into source-of-truth/website/<page>/ as draft files (public_release:false / status:draft); it never publishes, never sets approved/true, never adds manifest entries, never writes apps/website/src/. All three resources are project-local under projects/axcion-website/.claude/. Files: .claude/skills/website-copy/SKILL.md, .claude/commands/draft-page-content.md, .claude/agents/website-copy-reviewer.md, output/build-specs/2026-06-21-stage-b-copy-drafting-design.md.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/.claude/skills/website-copy/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/.claude/commands/draft-page-content.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/.claude/agents/website-copy-reviewer.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/output/build-specs/2026-06-21-stage-b-copy-drafting-design.md — exists

## Verdict

GO

**Summary:** A well-bounded, pay-as-used project-local capability that composes cleanly with the already-built Stage A seam, changes no permissions, adds no always-loaded cost, honors the project's Tier-C two-key publish boundary by design, and is cleanly revertible — no dimension rises above Low.

## Consumer Inventory

Search terms: `website-copy`, `draft-page-content`, `website-copy-reviewer`, `stage-b-copy-drafting`, plus the Stage A composers `website-content-source` / `website-source-pack`, and the output-contract markers `source-of-truth/website/<page>/`, `public_release:false`, `status:draft`. Grepped across `projects/axcion-website` and `ai-resources`. Self-references (the four resources under review) excluded.

| Consumer path | Reference type | Must change? |
|---|---|---|
| projects/axcion-website/.claude/skills/website-content-source/SKILL.md | documents (cross-refs `/draft-page-content` as "Build 2" at lines 11, 22, 189; SKIP-when handoff) | no |
| projects/axcion-website/content-source/README.md | documents (line 61: "Build 2 `/draft-page-content` drafts copy only from an approved pack") | no |
| projects/axcion-website/content-source/page-source-packs/homepage.md | invokes (the input contract — the pack the command consumes; verdict `READY_WITH_CANDIDATES`) | no |
| projects/axcion-website/source-of-truth/schemas/website-*.schema.yaml (11 files) | parses (the command writes draft files conforming to per-page section schemas) | no |
| projects/axcion-website/source-of-truth/website/homepage/{hero,cta,process,audience-split}.md | co-edits (existing `status: draft` files the overwrite-discipline must not silently alter) | no |
| projects/axcion-website/.claude/hooks/boundary-leakage-check.sh | (backstop — does NOT reference the new resources by name; scans `apps/website/src/*` at commit) | no |
| projects/axcion-website/source-of-truth/manifest.yaml | (two-key control — the command deliberately never touches it) | no |
| projects/axcion-website/output/build-specs/2026-06-19-page-content-drafting-command-spec.md | documents (superseded prior spec, retained as history) | no |
| projects/axcion-website/output/process-overview/2026-06-20-content-to-design-process-report.md | documents (line 83 names the planned command) | no |
| projects/axcion-website/audits/working/evaluation-website-copy.md | documents (the build-time evaluation of the skill) | no |
| projects/axcion-website/logs/{decisions,session-notes,friction-log,innovation-registry}.md + scratchpads | documents (session history naming Stage B) | no |

Total: ~11 distinct consumer surfaces, 0 must-change. All references are either documentation that already anticipated this capability, the input contract (the pack, which is unchanged), the schema/co-edit targets the command conforms to and explicitly refuses to overwrite, or backstops the command deliberately stays clear of. The Stage A SKILL pre-declared `/draft-page-content` as its downstream "Build 2" consumer — the seam is bidirectional and already documented, not newly imposed.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No content added to any always-loaded file. Workspace CLAUDE.md, ai-resources CLAUDE.md, and project CLAUDE.md are untouched by the change (the four referenced writes are SKILL.md, command.md, agent.md, design-note.md — none is an always-loaded file).
- No hook registered. The change adds no SessionStart/Stop/PreToolUse/UserPromptSubmit entry; grep of `boundary-leakage-check.sh` shows no reference to the new resources (existing hook untouched).
- Skill is pay-as-used. `website-copy` SKILL.md TRIGGER is narrow: "running /draft-page-content, or drafting any axcion-website page copy from a source pack" (SKILL.md:9) — it does not pattern-match broadly across general sessions.
- Command and agent are on-demand only. `/draft-page-content` runs when invoked; `website-copy-reviewer` is spawned only at the Stage 4 copy-QC gate (command.md:109). No frequently-spawned subagent in a daily loop.

### Dimension 2: Permissions Surface
**Risk:** Low

- No permission changes. The change writes four resource files; it adds no `allow`/`ask`/`deny` entry and modifies no settings file. Project `settings.json` already runs `defaultMode: bypassPermissions` with `Bash(*)` and `Write(**/.claude/**)` (settings.json:3–21) — the new resources operate inside the existing, already-established toolset.
- No new tool family or external capability. The skill and command use Read (pack/voice/schema) and Write/Edit (draft files under `source-of-truth/website/` and `output/content-strategy/`) — both already authorized. The agent declares `tools: Read, Grep, Glob, Write` (agent.md:5–9), all within established patterns.
- No scope escalation. Everything is project-local under `projects/axcion-website/.claude/`; nothing moves a permission from project → user scope or opens a cross-repo write path.

### Dimension 3: Blast Radius
**Risk:** Low

- Grounded in the Step 1.5 inventory: ~11 consumer surfaces, **0 must-change**. No caller requires modification to keep working.
- Contract direction is inbound and unchanged. The command *consumes* an existing contract (the Stage A pack's "Gate verdict" marker — confirmed `READY_WITH_CANDIDATES` at homepage.md:5) rather than changing one callers depend on. It introduces a *new* output contract (`source-of-truth/website/<page>/<section>.md` draft files), but that contract has no prior consumers to break.
- The Stage A SKILL already names `/draft-page-content` as "Build 2" (website-content-source SKILL.md:11, 22, 189) — the seam was pre-declared, so this is not an unanticipated consumer.
- Shared-infra touch is read-only/refusing. The boundary hook (scans `apps/website/src/*`) and the manifest (two-key control) are explicitly *not* written by the command (command.md:34, 137–138); the change stays on the safe side of both.
- Co-edit targets are protected, not modified. Existing homepage drafts `hero.md`/`cta.md`/`process.md`/`audience-split.md` are all `status: draft` (verified). The overwrite-discipline (command.md:93–97, SKILL.md:136–139) *stops or versions* on existing draft files and *never touches* `approved`/`in-review` — so the presence of these files is handled, not a hazard.

### Dimension 4: Reversibility
**Risk:** Low

- Clean `git revert`. The change is four new sibling files under `.claude/` and `output/`; removing them via revert (or `git rm`) fully restores prior state within the working tree — no data/log mutation, no settings cache.
- No state propagates beyond git. The capability is a tool, not an execution: nothing is pushed, no external API is called, no Notion write occurs. The session's planned use is `--validate` dry-run + a synthetic missing-pack case (design-note §11) — "no page copy is drafted this session."
- No automation fires between landing and revert. No hook, cron, or symlink is registered, so nothing auto-runs in the gap. Any draft files a *future* run produces are themselves `status: draft` / `public_release: false` and are separately revertible; they never reach the live site without the operator's Tier-C two-key step.

### Dimension 5: Hidden Coupling
**Risk:** Low

- Dependencies are explicit and documented at the change site. The command names every input it reads (the pack, the blueprint, the page schema, the two voice files — command.md:30–35) and the skill's "Cross-references" section (SKILL.md:206–211) names Stage A, the command, the reviewer agent, the project CLAUDE.md boundary rules, and the design note. No silent assumption.
- The one parse dependency is on a stable, existing marker. The command keys off the pack's "Gate verdict" line (command.md:42–48); that marker is produced by the already-built Stage A and confirmed present (homepage.md:3–5). No new undocumented contract is imposed on an upstream producer.
- No silent auto-firing. The skill is model-invocable but TRIGGER/SKIP-gated (SKILL.md:9–11); it does not auto-fire in unexpected contexts. No hook ordering, no cross-session side effect.
- No functional overlap. The capability composes with Stage A (source curation) and stops before publication (Tier-C); it does not duplicate the boundary hook, the manifest control, or `/qc-pass` (it *uses* `/qc-pass` for the blueprint gate and a dedicated reviewer for the copy gate, with a documented fallback — command.md:115–116).

### Dimension 6: Principle Alignment
**Risk:** Low

Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md`.

- **DR-7 / OP-9 / AP-7 (speculative abstraction) — not triggered.** The new-claim contract and output contract are not speculative: the Stage A producer already exists, the homepage pack is `READY_WITH_CANDIDATES`, and the downstream consumer (operator review → Tier-C activation) is a confirmed, live workflow. The capability is built for a present, second-stage consumer, not an absent Phase-2 one. Grounded second consumer: Stage A SKILL pre-declares `/draft-page-content` (website-content-source SKILL.md:189).
- **OP-5 (advisory vs enforcement) — aligned.** The capability *advises and stops*: it drafts to `draft`/`false`, flags ⚑NEW-CLAIM, and blocks "ready for design use" — but it never auto-corrects, never publishes, never sets `approved`/`true` (SKILL.md hard rule 6, command.md:137–138). It is squarely advisory; no silent enforcement upgrade.
- **OP-12 (closure before detection) — aligned.** The reviewer agent adds detection (PASS/FAIL + findings), but it ships *behind a working closure channel*: findings route to the build session to fix and re-run, and unresolved flags block readiness (agent.md:100–107). Detection is not ahead of closure.
- **OP-2 / AP-4 (automate execution, gate judgment) — aligned.** The genuine judgment call (publication of a public claim) stays operator-gated as the project's Tier-C two-key control; the routine drafting execution is automated. No judgment is silently automated and no routine step is needlessly re-gated.
- **DR-1 / DR-3 (placement) — aligned.** All three resources are project-local under `projects/axcion-website/.claude/` (skill/command/agent in their canonical homes). Placement is correct: these are axcion-website-specific, not cross-project, so canonical `ai-resources/` would be the wrong tier.
- **OP-10 (system boundary) — not touched.** No cross-tool coordination introduced; the capability is Claude-Code-only.
- **DR-2 (canonical pipelines) — followed.** The design note records the build path as `/create-skill` → new command → new agent → `/risk-check` → commit (design-note §intro, "Build path").

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from the referenced files and CHANGE_DESCRIPTION, principle IDs from the read principles-base). No training-data fallback was used; no fetch/read failures occurred.
