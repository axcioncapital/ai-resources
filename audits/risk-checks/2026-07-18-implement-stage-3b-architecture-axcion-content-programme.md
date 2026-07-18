# Risk Check — 2026-07-18

## Change

Implement the Stage 3b architecture for the new axcion-content-programme project, per /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/pipeline/architecture.md. The change creates 3 new project-local slash commands (/build-inventory, /build-roadmap, /select-articles), 1 new project-local agent (knowledge-inventory-agent, opus), 2 project-local reference documents, a .claude/shared-manifest.json opting the project into auto-sync symlinking of canonical commands and agents from ai-resources, a project settings.json (canonical permissions block + two SessionStart hooks invoked from ai-resources) and a gitignored settings.local.json additionalDirectories grant, appends to the project CLAUDE.md, a root .gitignore line, and git init with remote axcion-content-engine. All four new resources are project-local to a brand-new project with no existing sessions; no canonical ai-resources command or agent is added or modified. Keep the assessment proportionate to that blast radius.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/pipeline/architecture.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/pipeline/project-plan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/auto-sync-shared.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/project-settings.json.template — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/.claude/shared-manifest.json — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/.claude/settings.json — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.gitignore — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A well-designed, correctly-scoped new-project scaffold with four Medium findings (standard scaffold token cost, nested-repo reversibility, a well-documented-but-real silent-failure coupling, and a complexity-budget evidentiary gap) — none rising to High, and the change is not defect-justified so Dimension 7 does not gate the verdict.

## Consumer Inventory

Search terms derived from CHANGE_DESCRIPTION and architecture.md: `build-inventory`, `build-roadmap`, `select-articles`, `knowledge-inventory-agent` (new component names); `shared-manifest.json`, `project-settings.json.template` (contract/template markers this change opts into); `axcion-content-programme`, `axcion-content-engine` (project/repo identifiers). Grepped across `ai-resources/` and the workspace root, excluding `.git` and the project's own new/not-yet-present files.

- `build-inventory`, `build-roadmap`, `select-articles`, `knowledge-inventory-agent`: **0 hits** anywhere outside `projects/axcion-content-programme/pipeline/architecture.md` and `project-plan.md` themselves. No naming collision against the 90 canonical commands or 42 canonical agents (counts independently re-derived, see Dimension 3). These four new components have no existing consumers — they are net-new, and nothing outside the new project references them yet.
- `shared-manifest.json`: an **established, pre-existing contract** with 15+ current project consumers on disk (`nordic-pe-macro-landscape-H1-2026`, `ai-development-lab`, `repo-documentation`, `research-pe-regime-shift-advisory-gap`, `project-planning`, `obsidian-pe-kb`, `personal`, and others per grep). The new project's manifest is a new *instance* of an existing schema, not a new contract.
- `project-settings.json.template`: read in full — byte-identical to `projects/marketing-positioning/.claude/settings.json` (independently diffed). Confirms the change applies the established canonical template verbatim, not a novel permission shape.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/hooks/auto-sync-shared.sh` | invokes / parses (reads the new `shared-manifest.json` at SessionStart; symlinks canonical commands/agents into the new project) | no |
| `ai-resources/.claude/hooks/check-permission-sanity.sh` | invokes (checks the new project's `settings.json` for drift against the canonical template at SessionStart) | no |
| `ai-resources/templates/project-settings.json.template` | co-edits (the new project's `settings.json` is a verbatim copy of this file) | no — template itself is unmodified |
| `.gitignore` (workspace root) | co-edits (M2: receives one new line, `projects/axcion-content-programme/`) | yes — this is the one direct, in-scope edit outside the new project's own directory |

**Total: 4 consumers found, 1 must-change** (the root `.gitignore` line, which is itself part of the described change, not a ripple effect). The four new project-local resources (`/build-inventory`, `/build-roadmap`, `/select-articles`, `knowledge-inventory-agent`) have zero external consumers — expected for brand-new, not-yet-present, single-project-scoped files; the inventory covers the pre-existing shared mechanisms the project opts into rather than a caller list for files that don't exist yet.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- M1 appends the five canonical template sections plus a standing-rules section to `projects/axcion-content-programme/CLAUDE.md`, taking it from 12 lines (independently re-measured — file read in full, confirmed 12 lines) to an estimated ~90–110 lines. This is an always-loaded file for every future session of this project — real, ongoing per-session token cost.
- Two SessionStart hooks (`auto-sync-shared.sh`, `check-permission-sanity.sh`) fire once per session start — Medium per the calibration heuristic, though both are the same pre-existing, already-deployed hooks used by essentially every other project (verified: `projects/marketing-positioning/.claude/settings.json` carries the identical hook block).
- Mitigating context: this cost is confined entirely to sessions inside the new project — zero marginal cost to any other project or to workspace/ai-resources CLAUDE.md (neither was touched; verified no edits outside `projects/axcion-content-programme/` and one `.gitignore` line). It is the standard, expected cost of scaffolding any new project via the canonical template, not a bespoke addition.

### Dimension 2: Permissions Surface
**Risk:** Low

- `settings.json`'s permissions block (`defaultMode: bypassPermissions`, broad `allow` list including `Bash(*)`, narrow `deny` list) is verified byte-identical to `ai-resources/templates/project-settings.json.template` and to `projects/marketing-positioning/.claude/settings.json` (direct diff performed). No new capability is introduced beyond the already-established, widely-deployed pattern.
- `settings.local.json` additionalDirectories grant: verified against `ai-resources/docs/permission-template.md:181–213`, which documents this exact shape (gitignored, machine-specific, workspace-root grant) as the canonical, post-2026-06-26 target state — this is the *correct* pattern, not a new one. `.gitignore` already excludes `.claude/settings.local.json` workspace-wide (line 10).
- No `model` field anywhere in settings (verified by reading the template and architecture.md's own compliance check, §5 "Model tier compliance").

### Dimension 3: Blast Radius
**Risk:** Low

- Consumer Inventory (above): 4 consumers found, 1 must-change — and that one (`.gitignore`) is a single-line, purely additive edit against a directory independently confirmed to have **0 tracked files** in the workspace-root repo (`git status --short projects/axcion-content-programme/` → `?? projects/axcion-content-programme/`) and **0 existing `.gitignore` references** (`grep -c "axcion-content-programme" .gitignore` → `0`). Both match the change description's premises exactly.
- Direct file/action footprint: ~13 touch points (3 commands, 1 agent, 2 reference docs, `shared-manifest.json`, `settings.json`, `settings.local.json`, CLAUDE.md append, `pipeline-state.md` bookkeeping, root `.gitignore` line, `git init` + remote) — all but one confined inside `projects/axcion-content-programme/`, a directory with zero prior consumers.
- Naming-collision check: 0 hits for all four new component names against 90 canonical commands / 42 canonical agents (both counts independently re-derived: `find ai-resources/.claude/commands -maxdepth 1 -name '*.md' -type f | wc -l` → 90; same for `agents` → 42 — both match the stated premise exactly).
- No canonical `ai-resources/` file is touched (verified: nothing outside `projects/axcion-content-programme/` and the one `.gitignore` line appears in the component/modification lists, and grep confirms no existing file elsewhere requires edits to accommodate the new project).

### Dimension 4: Reversibility
**Risk:** Medium

- The new project is its own nested git repo (`git init` + remote `axcion-content-engine`), gitignored from the workspace-root repo's perspective once M2 lands. A workspace-root `git revert` of the one `.gitignore` line does **not** remove the nested repo or its contents — that requires an extra manual step (delete the project directory / its `.git`), matching the "revert works but requires one extra cleanup step" calibration point.
- Push to `origin/axcion-content-engine` is separately gated per workspace CLAUDE.md (`Push behavior`: batched, confirmed at `/wrap-session`, never mid-session) — so as long as that gate is honored, no external GitHub state exists until an explicit operator confirmation, which keeps the *pre-push* reversibility clean. If push does occur, rollback then requires GitHub-side cleanup beyond `git revert` (matches the "state has propagated beyond git" High-leaning criterion) — but that is a distinct, separately-gated future action, not an automatic consequence of this change.
- No append-only log or shared-state file is mutated by this change (pipeline-state.md is local bookkeeping inside the new project's own directory).

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The single highest-consequence coupling: `auto-sync-shared.sh:29–30` — independently re-read and confirmed verbatim: `[ -f "$MANIFEST" ] || exit 0`, preceded by `# Bail if no manifest — project opts out of managed symlinks entirely.`, with `MANIFEST` defined at line 27 as `"$PROJECT_DIR/.claude/shared-manifest.json"`. An absent or malformed `shared-manifest.json` silently opts the new project out of all 90 canonical commands and 42 canonical agents, with exit code 0 and no error.
- This is a real, load-bearing implicit dependency on an established repo convention (Medium per the calibration heuristic) — but it is unusually well-flagged: architecture.md's own Conflict Analysis (§5, "Auto-sync opt-out — High if missed") names this exact failure mode and mandates a Stage 5 verification step ("Stage 5 verification should confirm: shared-manifest.json exists and canonical symlinks actually appeared in .claude/commands/ — the auto-sync opt-out failure is silent," §8). The mitigation is procedural (a verification step that must actually run), not structural (the hook itself still exits silently) — which is why this stays Medium rather than dropping to Low.
- No other implicit dependency or functional overlap found: the new commands don't collide with the hook's baked-in `EXCLUDE_COMMANDS`/`EXCLUDE_AGENT_GLOBS` lists (verified by reading `auto-sync-shared.sh` in full), and the one flagged naming adjacency (`/build-inventory` near canonical `/build-context`) is explicitly distinguished in architecture.md §5 with a stated mitigation (explicit `description:` line) rather than left silent.

### Dimension 6: Principle Alignment
**Risk:** Medium

Principles-base read in full (`projects/strategic-os/ai-strategy/principles-base.md`, 2026-06-01 index of the 42-principle canonical doc).

- **OP-9 / AP-7 / DR-7 (speculative abstraction) — compliant, actively so.** The architecture explicitly defers Tier 2 (workflow doc + 2–3 article-production skills) and the `research-workflow` deployment, citing the plan's own "decided at W1.7/W2.3 against observed workflow problems from real articles — never in advance" (architecture.md Decision 2, §2.3). This is a textbook correct application of DR-7's "generalize only on a second confirmed consumer" — the opposite of a violation.
- **DR-1 / DR-3 (placement) — compliant.** The 4 new components are correctly project-local (not pushed to canonical `ai-resources/`), licensed explicitly by `ai-resource-creation.md` Rule 1's carve-out for "project-specific pipeline commands... tightly coupled to that project's pipeline and not intended for reuse." Canonical resources are reused via the existing symlink mechanism rather than duplicated.
- **Complexity-budget gate (`ai-resource-creation.md` rule #7) — genuine tension, not a clear violation.** The 4 new components (3 commands + 1 agent) are net-additive (fails prong a — no existing component is removed or consolidated). Prong (b) requires "cited written evidence... a `logs/friction-log.md`/`defect-log.md`/`coaching-log.md`/`incident-log.md` entry, or a pattern seen ≥2 times." Architecture.md's rationale cites the *approved plan's* own content specification (e.g., C3's rationale: "the discipline this command enforces... is exactly the kind that gets silently skipped without a procedure") rather than a literal log citation — and, because this is a brand-new project with zero prior sessions (per CHANGE_DESCRIPTION), no project-specific friction log *could* exist yet to cite. This is a real evidentiary gap against the rule's literal text, though substantively mitigated: the components serve an immediate, already-operator-approved, concretely-scoped need (not "for a future phase"), and no OP-11 loud-exception entry was found logged for this specific gate in the project's `pipeline/decisions.md` (which does record 3 other decisions, none addressing rule 7). Named for the operator's awareness; does not, on balance, rise to a clear violation given the absence of any speculative element.
- **OP-2 (automate execution, gate judgment) — compliant.** Checkpoint A (roadmap approval) and W1.4 (article selection) remain Tier C / operator-gated in the architecture; no unit containing an operator decision is tiered autonomous.
- **OP-10, OP-12, OP-5 — not implicated.** No cross-tool coordination logic is built in this Stage 4 change (external-tool integration is explicitly Phase 2/W2.1, out of scope here); no new detection/audit component is added; the two SessionStart hooks are pre-existing advisory mechanisms redeployed unchanged, not a new enforcement upgrade.

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed or inferred?** Not applicable. CHANGE_DESCRIPTION does not assert that anything is currently broken, missing, unwired, stale, failing, or inconsistent. It describes implementing an operator-approved architecture spec for a brand-new project — a capability build, not a defect fix.
- **Consequence — traced or assumed?** Not applicable, for the same reason.
- **Re-derivation vs. the change description:** None — all claims independently re-derived and confirmed: 90 commands / 42 agents (exact `find` count match); `projects/axcion-content-programme/` has 0 tracked files and 0 `.gitignore` references (verified via `git status` and `grep -c`); `CLAUDE.md` is exactly 12 lines (verified via direct read); `auto-sync-shared.sh:29–30` matches the quoted text and line numbers exactly; 8 new components + 3 modifications independently counted from architecture.md's own component/modification tables and confirmed to match the "8 new components, 3 modifications" self-description; no canonical `ai-resources/` file is touched by the change. No discrepancy found between the change description and independent re-derivation.
- **Not defect-justified — no premise to verify.** Risk: Low.

## Mitigations

- **Dimension 1 (Usage Cost):** At Stage 5 verification, confirm the final `CLAUDE.md` line count lands in the estimated ~90–110 range before the first working session begins — if it materially exceeds that, trim before it becomes the permanent per-session baseline for this project.
- **Dimension 4 (Reversibility):** Withhold the `/wrap-session` push confirmation for the new `axcion-content-engine` remote until Stage 5 verification has passed — keep the existing gated-push rule as the operative safeguard rather than treating `git init` + remote-add as equivalent to a completed, externally-visible deployment.
- **Dimension 5 (Hidden Coupling):** At first session start, explicitly count symlinks that appear in `.claude/commands/` and `.claude/agents/` and confirm the count matches the expected canonical set (90 minus baked-in exclusions and the 3 local commands; 42 minus exclusions and the 1 local agent) — do not treat the absence of an error message as confirmation, since `auto-sync-shared.sh`'s failure mode on a missing/malformed manifest is a silent `exit 0`.
- **Dimension 6 (Principle Alignment):** Add one line to `projects/axcion-content-programme/pipeline/decisions.md` recording the rule-7 complexity-budget basis for the 4 new project-local components — citing architecture.md §2.2's component-rationale table as the justification — so the clearance is an explicit, loud record rather than an implicit pass on a brand-new project with no friction-log history to cite.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
