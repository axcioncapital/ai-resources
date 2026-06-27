# Risk Check — 2026-06-26

## Change

Proposed structural change (plan-time gate). Retarget the additionalDirectories grant from tracked settings.json to per-machine settings.local.json across both scaffolding writers, add the gitignore wiring that makes it effective, and align the sweep that detects/remediates it. Change-set:
1. /new-project step 3 (new-project.md:381-399) — retarget the jq merge from .claude/settings.json to .claude/settings.local.json; ensure defaultMode lands in the local file without a conflicting duplicate in tracked settings.json.
2. /new-project step 5b (new-project.md:630-632) — write .claude/settings.local.json into the project's OWN repo .gitignore before the blanket git init/git add ., so the machine path is not re-tracked.
3. /deploy-workflow twin step (deploy-workflow.md:207-229) — mirror the step-3 retarget.
4. workflows/research-workflow/.gitignore — add .claude/settings.local.json (deploy-workflow consumer).
5. /permission-sweep (permission-sweep.md Rule 8/12 + remediation block ~line 211) — point detection + remediation at settings.local.json as the canonical home for additionalDirectories.
6. permission-sweep-auditor agent — align its detection scan to match.
7. docs/permission-template.md Layer D′ — clear the pending-alignment note now that the writers are fixed.
Root cause being fixed: cross-machine stale-path breakage — the deploying machine's absolute workspace path was written into tracked settings.json, breaking when a project repo is cloned/opened on another machine. Forward-only fix (no retroactive remediation of already-deployed projects). Operator approved scope (option 1 + gitignore wiring).

## Referenced files

- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-project.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/.claude/commands/deploy-workflow.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/.claude/commands/permission-sweep.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/.claude/agents/permission-sweep-auditor.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.gitignore — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A well-scoped, operator-approved fix to a real cross-machine bug whose canonical target state is already documented in the template doc; the elevated risk is confined to two coupled consumers the change-set does not name (SETUP.md's manual instructions and the research-workflow template's own tracked `additionalDirectories` placeholder), plus a defaultMode-shadowing trap that must be honored when writing the local file.

## Consumer Inventory

Search terms: `additionalDirectories`, `settings.local.json`, `Rule 8`, `Layer D′/D'`, plus the six change-set basenames. Grep run across `ai-resources/` and the workspace root. The grep returned 200+ files, but the overwhelming majority are **historical audit/log/report artifacts** (`audits/`, `logs/`, `reports/`, deployed-project `settings.json`) — these *record* the term, they do not *consume the contract* the change touches. The rows below are the live consumers (source-of-truth files that must keep working after the change).

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/new-project.md` (step 3, step 5b) | co-edits | yes |
| `ai-resources/.claude/commands/deploy-workflow.md` (twin step ~207-229; `git add -A` at 302) | co-edits | yes |
| `ai-resources/.claude/commands/permission-sweep.md` (Rule 8/12 phrasing line 111/115; remediation idiom line 211-216) | co-edits | yes |
| `ai-resources/.claude/agents/permission-sweep-auditor.md` (Step 4a; layer labels) | co-edits | yes |
| `ai-resources/docs/permission-template.md` (Layer D′ line 192-220; Rule 8 line 396) | co-edits | yes |
| `ai-resources/workflows/research-workflow/.gitignore` | co-edits | yes |
| `ai-resources/workflows/research-workflow/.claude/settings.json` (carries `additionalDirectories: ["{{WORKSPACE_ROOT}}"]` at lines 32-34, tracked) | co-edits | yes — NOT in change-set |
| `ai-resources/workflows/research-workflow/SETUP.md` (lines 18-30: tells operator to replace `{{WORKSPACE_ROOT}}` in tracked `settings.json`) | documents | yes — NOT in change-set |
| `ai-resources/.claude/hooks/check-permission-sanity.sh` (reads `settings.local.json` `.permissions.defaultMode`; nudges if perms block lacks bypass — lines 20,37,49) | parses | no (compatible if defaultMode is written) |
| `ai-resources/.claude/commands/sync-workflow.md` (line 48: excludes `settings.json`/`settings.local.json` from template-drift comparison) | documents | no |
| `ai-resources/templates/project-settings.json.template` | co-edits | no — grep confirms it does NOT carry `additionalDirectories` (writers compute it dynamically); no change needed |

Total: 11 live consumers, 8 must-change. Two must-change consumers (rows 7 and 8 — the research-workflow template `settings.json` and `SETUP.md`) are **not named in the change-set** — this is a blast-radius gap (see Dimension 3). The contract being moved is "where `additionalDirectories` lives" (tracked vs gitignored local). The 200+ audit/log hits are not consumers.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No content added to always-loaded files. The change edits two on-demand commands (`/new-project`, `/deploy-workflow`), one on-demand command (`/permission-sweep`), one subagent invoked only by that command, a doc read only at sweep/scaffold time, and a `.gitignore`. None are loaded per-turn or per-session.
- No new hook registered. The existing `check-permission-sanity.sh` SessionStart hook already reads `settings.local.json` (lines 20-49) — the change adds no new per-session cost.
- The jq merge in `/new-project` step 3 and `/deploy-workflow` retains the same single idempotent call; retargeting the `$SETTINGS` path does not add runtime cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- The change **relocates** an existing grant; it does not widen capability. `additionalDirectories` already grants workspace-root read; moving it from tracked `settings.json` to gitignored `settings.local.json` changes *where the grant is stored*, not *what it grants*.
- No `allow`/`deny`/`ask` entry is added or removed. No scope escalation (project→user). The grant stays project-scoped.
- Net effect on tracked config is *narrowing*: the machine-specific absolute path leaves git tracking (the documented intent — `permission-template.md:185`, `192-194`).

### Dimension 3: Blast Radius
**Risk:** Medium

- Consume Step 1.5 inventory: **11 live consumers, 8 must-change.** The change-set explicitly names 6 of the 8 must-change consumers (rows 1-6). Two must-change consumers are unnamed.
- **Unnamed consumer 1 — research-workflow template `settings.json` (lines 32-34).** It ships `"additionalDirectories": ["{{WORKSPACE_ROOT}}"]` in the **tracked** template settings.json. If `/deploy-workflow` is retargeted to write the grant into `settings.local.json` (item 3) but the template's tracked `settings.json` still carries the placeholder, a deployed project ends up with the grant in *both* places — and the tracked placeholder either stays as a literal `{{WORKSPACE_ROOT}}` (Claude resolves it to a non-existent dir) or gets filled with the machine path (re-introducing the very bug being fixed). The change-set's item 4 only touches the `.gitignore`, not the template `settings.json`.
- **Unnamed consumer 2 — `SETUP.md` lines 18-30.** It instructs the operator to "replace the `{{WORKSPACE_ROOT}}` placeholder in `additionalDirectories`" inside tracked `.claude/settings.json`. After the retarget this instruction is stale: it directs the operator to edit the tracked file that should no longer carry the grant. Stale onboarding instructions reproduce the bug by hand.
- Contract change ("where `additionalDirectories` lives") is **not backwards-compatible for the research-workflow template path** unless the template settings.json + SETUP.md are reconciled in the same change — hence Medium, not Low. It is forward-only by design (no retroactive remediation), which correctly bounds the deployed-project blast radius.
- Backwards-compatible consumers: `check-permission-sanity.sh` (already reads the local file), `sync-workflow.md` (already excludes both settings files from drift comparison), `project-settings.json.template` (no `additionalDirectories` present — confirmed by grep).

### Dimension 4: Reversibility
**Risk:** Low

- All seven change-set items are edits to tracked source files (`.md` commands/docs/agent, one `.gitignore`). A single `git revert` restores every one cleanly within the working tree.
- Forward-only scope means **no already-deployed project is mutated** by this change — there is no migrated data/log/state to leave stale on revert.
- No external write, no push, no automation that fires between landing and revert (the change is config-text only; the SessionStart hook it touches is unchanged in behavior).
- Minor: reverting after a project has been deployed via the new path would leave that one project's `settings.local.json`-based grant in place, but that file is gitignored and self-correcting — not a rollback blocker.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **defaultMode-shadowing trap (root cause #1).** `permission-template.md:106,210` and `check-permission-sanity.sh:43-49` establish a hard contract: any `settings.local.json` that declares a `permissions` block MUST include `defaultMode: "bypassPermissions"`, or it silently shadows the parent's bypass and prompts resume. Writing `additionalDirectories` into `settings.local.json` *creates* a permissions block where one may not have existed — so the writer must co-write `defaultMode`. The change-set is aware (item 1: "ensure defaultMode lands in the local file") but this coupling is load-bearing and easy to drop in the `/deploy-workflow` twin (item 3), which does not restate it.
- **`git add -A` re-tracking trap.** `/deploy-workflow` step 9 runs `git add -A` (deploy-workflow.md:302) with no separate gitignore-write step — it relies entirely on the template `.gitignore` (item 4) being copied into the project before `git add -A`. The coupling is correct *only if* the `.gitignore` entry is present and the copy precedes the add; if the order is wrong, `settings.local.json` is re-tracked, defeating the fix. `/new-project` handles this differently (explicit item-2 gitignore write before `git init`/`git add .`) — two writers, two different mechanisms for the same invariant.
- **Template placeholder lifecycle coupling.** The research-workflow template `settings.json` placeholder (`{{WORKSPACE_ROOT}}`) is protected by the auditor's intentional-template silencing (auditor Step 4a; template doc § Intentional-template). If the grant moves to `settings.local.json` but the placeholder remains in tracked `settings.json`, the auditor will keep silencing Rule 8 on a now-orphaned placeholder — a quiet inconsistency between "where the grant lives" and "where the placeholder still sits."
- Mitigated coupling (not a finding): `permission-template.md` Layer D′ + Rule 8 already describe the exact target state (line 192-220, 396), so the doc and the writers converge rather than diverge once item 7 lands.

### Dimension 6: Principle Alignment
**Risk:** Low

- principles-base.md was not readable at `{AI_RESOURCES}/../projects/strategic-os/ai-strategy/principles-base.md` (path not confirmed present); evaluated against the inline checks and the always-loaded workspace `CLAUDE.md` Design Judgment Principles + Autonomy Rules.
- **Not speculative abstraction.** The change has a confirmed, present consumer-set and fixes an observed bug (cross-machine stale path); it builds no infrastructure for an absent future consumer. The target state is already the documented canonical (`permission-template.md` Layer D′), and the doc explicitly flags this exact follow-up as pending (line 220) — this is closing a known gap, not generalizing speculatively.
- **Loud, recorded, not drift (OP-11 analog).** The change is operator-approved (CHANGE_DESCRIPTION: "Operator approved scope (option 1 + gitignore wiring)") and aligns the writers to a previously-recorded decision (`permission-template.md:185`, changed 2026-06-03). Item 7 clears the pending-alignment note loudly rather than letting writer/doc drift persist.
- **No advisory→enforcement upgrade, no boundary expansion.** `/permission-sweep` stays advisory + operator-gated (pause-trigger #8; permission-sweep.md:9). The change stays inside Claude Code config; it does not extend reach to GPT/Perplexity/Notion. Placement is correct (machine-specific grant → gitignored local file, the canonical home).
- Honors Autonomy Rules #8/#9 (harness-level + risk-check-gated change) — this very risk-check is the gate firing as intended.

## Mitigations

- **Dimension 3 (blast radius — unnamed consumer 1):** In the same change, reconcile the research-workflow template `settings.json` (lines 32-34). Decide and apply one of: (a) remove `additionalDirectories` from the tracked template settings.json entirely (so deploy-workflow writes it only into `settings.local.json`), or (b) keep the placeholder but ensure deploy-workflow strips/ignores it. Do not land item 3 (deploy-workflow retarget) without resolving where the template's tracked grant goes — otherwise deployed projects get a double-home or an unresolved `{{WORKSPACE_ROOT}}`.
- **Dimension 3 (blast radius — unnamed consumer 2):** Update `SETUP.md` lines 18-30 in the same change so its manual instruction points operators at `settings.local.json` (and notes the gitignore), not the tracked `settings.json`. Stale onboarding text reproduces the bug by hand for any operator following it.
- **Dimension 5 (hidden coupling — defaultMode):** In BOTH writers (item 1 and the item-3 twin), make the local-file jq merge co-write `"defaultMode": "bypassPermissions"` whenever it creates/touches the `permissions` block in `settings.local.json`. Verify against `check-permission-sanity.sh:43-49` — a local file with a permissions block but no bypass defaultMode triggers the nudge and re-enables prompts.
- **Dimension 5 (hidden coupling — `git add -A` ordering):** For `/deploy-workflow`, confirm the template `.gitignore` (with the new `settings.local.json` entry) is copied into the project *before* step 9's `git add -A` (deploy-workflow.md:302). Add an explicit ordering note in the command if the copy step is not already guaranteed to precede the add.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references and verbatim quotes from the referenced files, `check-permission-sanity.sh`, `SETUP.md`, the research-workflow template `settings.json`, and `permission-template.md`; grep counts and consumer enumeration from the Step 1.5 inventory). The principles-base index was not confirmed present at the expected path; Dimension 6 was evaluated against the inline checks plus the always-loaded workspace `CLAUDE.md` and noted as such. No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**SECOND OPINION UNAVAILABLE — grounding integrity halt.** The `system-owner` agent halted before producing an advisory: its REQUIRED grounding files are absent at their canonical path `projects/axcion-ai-system-owner/references/{persona,grounding,toolkit-relationship}.md`. The entire `projects/axcion-ai-system-owner/` tree is absent from disk; the only copies sit under a reconcile-staging path (`audits/working/repo-reconcile-2026-06-06/system-owner-agent-canonical/references/`), which the agent correctly refused to treat as canonical. Per `/risk-check` Step 17d, an unavailable second opinion does NOT change the verdict and does NOT block — the risk-check-reviewer's PROCEED-WITH-CAUTION verdict stands as the gate result.

**Separate structural fault surfaced (not part of this change):** the System Owner's grounding base is unreachable at its canonical location — `projects/axcion-ai-system-owner/` appears mid-migration (a `repo-reconcile-2026-06-06` working tree exists) and was never landed at its live home. This is an independent live fault worth a `/resolve-repo-problem` in its own right.
