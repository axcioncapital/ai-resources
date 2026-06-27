# Risk Check — 2026-06-27

## Change

Change to ai-resources/.claude/commands/deploy-workflow.md "Grant ai-resources filesystem visibility" sub-step (Step 4 enrichment, lines ~205–234) — redirect the unconditional additionalDirectories workspace-root grant from the deployed project's TRACKED {PROJECT_DIR}/.claude/settings.json to its gitignored {PROJECT_DIR}/.claude/settings.local.json, mirroring the already-landed /new-project Step 3 fix (2026-06-26) and canonical Rule 8 / Layer D′ in permission-template.md. Edits: (1) Scope note line 207 — change the touched file from settings.json to settings.local.json. (2) The bash block lines 213–232 — point SETTINGS at {PROJECT_DIR}/.claude/settings.local.json (seed {} if absent), and set the mandatory .permissions.defaultMode = (.permissions.defaultMode // "bypassPermissions") alongside the additionalDirectories merge (Layer D′ requires defaultMode whenever the local file declares a permissions block — root cause #1). (3) Surrounding prose (lines 209, 211, 234) — reframe "tracked settings.json" references to settings.local.json and note the path is machine-specific so it must not be committed. Rationale: deploy-workflow is the second of two residual generators that re-introduce the machine-specific-path defect this mission is closing; /permission-sweep (first) already fixed and risk-check GO this session. Reversible (command-doc edit, git-tracked). Blast radius: /deploy-workflow deploy behavior + /sync-workflow (which re-runs the same enrichment on older projects). No permission grants widened — the grant moves from tracked to gitignored local config; the deployed project still receives the same workspace-root read access at runtime.

## Referenced files

- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/.claude/commands/deploy-workflow.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-project.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A low-risk, portability-correcting command-doc edit that mirrors an already-landed precedent — but the change description's blast-radius model is wrong on one point (`/sync-workflow` does **not** re-run this grant) and silently leaves a parallel tracked-path defect in the research-workflow template settings, so it needs two mitigations before landing.

## Consumer Inventory

Search terms: `deploy-workflow`, `additionalDirectories`, `settings.local.json`, the Step 4 "Grant ai-resources filesystem visibility" sub-step contract. Grepped across `{AI_RESOURCES}` and the workspace root, excluding `audits/` (historical noise — every repo-dd/token-audit run names these commands; none consumes the runtime contract being changed).

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/workflows/research-workflow/.claude/settings.json | co-edits | no (but see Dim 5/6 — carries the *same* tracked-path defect: `additionalDirectories: ["{{WORKSPACE_ROOT}}"]`, line 32) |
| ai-resources/workflows/research-workflow/SETUP.md | co-edits | no (lines 20–23 instruct manual replacement of `{{WORKSPACE_ROOT}}` into the **tracked** settings.json — parallel residual defect) |
| ai-resources/.claude/commands/new-project.md | documents | no (already fixed 2026-06-26 — Step 3, lines 375–402, writes the grant to `settings.local.json`; precedent for this change) |
| ai-resources/.claude/commands/sync-workflow.md | documents | no (does **not** perform the grant — line 48 excludes both `settings.json` and `settings.local.json` from comparison; line 124 forbids auto-modifying settings) |
| ai-resources/docs/permission-template.md | documents | no (Layer D line 185, Layer D′ lines 190–220, Detection Rule 8 line 396 — this change resolves the "Known pending-alignment item (2026-06-03)" only for `/new-project`; deploy-workflow not yet named there) |
| ai-resources/.claude/agents/permission-sweep-auditor.md | parses | no (consumes Detection Rule 8 / Layer D′ contract — change keeps deploy-workflow output compliant; no parse-shape change) |
| ai-resources/templates/project-settings.json.template | imports | no (single source of truth for the `permissions` block; correctly carries **no** `additionalDirectories` — change keeps deploy-workflow aligned to it) |

Total: 7 consumers, 0 must-change. No live caller invokes the deploy-workflow Step 4 grant contract such that it breaks — the grant is self-contained inline bash. The two `co-edits` rows are not strictly required for *this* change to work, but they carry the identical defect and are a blast-radius finding (Dim 5/6).

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The edited file is an on-demand slash command, not an always-loaded file — `deploy-workflow.md` carries `model: sonnet` frontmatter (line 2) and is invoked only at project-deploy time, never per-session or per-turn. No `@import`, no hook registration, no CLAUDE.md addition.
- Net token delta is roughly flat: the edit re-points a path string and adds one jq clause (`.permissions.defaultMode = (.permissions.defaultMode // "bypassPermissions")`) plus a short prose note — single-digit line change against a 337-line command (per `audits/token-audit-2026-06-05-ai-resources.md:88`).
- `deploy-workflow` is excluded from the auto-sync fan-out (`auto-sync-shared.sh` baked-in exclusion — confirmed in `audits/repo-dd-deep-2026-05-27-project-nordic-pe-screening-project.md:600`), so the edit does not propagate into every project's loaded command set.

### Dimension 2: Permissions Surface
**Risk:** Low

- No widening. The change moves *where* the `additionalDirectories` grant is written (tracked `settings.json` → gitignored `settings.local.json`); the runtime read-access the deployed project receives is unchanged — same absolute workspace-root path, same `additionalDirectories` key.
- It adds `defaultMode: "bypassPermissions"` to the **local** file only when that file declares a `permissions` block — this is *required* by Layer D′ (permission-template.md line 210: "mandatory whenever this file declares a `permissions` block"), and it does not grant any new tool capability; it prevents the local file from *shadowing* the parent's bypass (root cause #1, permission-template.md line 13). This is a correctness fix, not a surface expansion.
- Net effect is a *narrowing* of the committed surface: a machine-specific absolute path stops being committed to git, satisfying Detection Rule 8 (permission-template.md line 396) and Layer D's "No `additionalDirectories` in the tracked `settings.json`" assertion (line 185).

### Dimension 3: Blast Radius
**Risk:** Low

- Step 1.5 inventory: **7 consumers, 0 must-change.** Single file directly edited (`deploy-workflow.md`). The grant is self-contained inline bash with no caller that parses its output shape.
- **Contract-parse cross-check:** `permission-sweep-auditor.md` parses the Detection-Rule-8 / Layer-D′ contract. This change makes deploy-workflow output *more* compliant with that contract (tracked file no longer carries the path), so the `parses` consumer is satisfied, not broken.
- **Inventory surfaced a gap the change description did not anticipate:** the description states the blast radius includes "`/sync-workflow` (which re-runs the same enrichment on older projects)." Grep of `sync-workflow.md` shows this is **false** — line 48 explicitly excludes `settings.json` and `settings.local.json` from comparison, and lines 120–124 forbid auto-modifying settings. `/sync-workflow` never writes `additionalDirectories`. The change is therefore *more* isolated than described (good for risk), but the description's mental model of the blast radius is inaccurate and should be corrected before landing so the operator does not expect older deployed projects to be retro-fixed by a later `/sync-workflow` run (they will not be — they keep their tracked grant until manually cleaned per the Layer D′ migration note).

### Dimension 4: Reversibility
**Risk:** Low

- Single-file, git-tracked command-doc edit. `git revert` of the deploy-workflow.md change fully restores the prior generator behavior within the working tree — no sibling files created, no log/registry mutation, no external write, no push.
- The change alters only *future* deploy behavior; it does not retroactively rewrite any deployed project's settings. Reverting the command leaves no orphaned state in any consumer. Already-deployed projects (deployed before or after this change) are unaffected by the revert.
- One nuance, not a risk escalator: a project deployed *after* this change lands will have its grant in `settings.local.json` (gitignored, never committed), so reverting the command does not need to "clean up" anything in any project repo — the gitignored file is per-machine and outside revert scope by design.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Parallel undocumented defect in the template the command deploys.** The research-workflow template's own tracked `settings.json` carries `additionalDirectories: ["{{WORKSPACE_ROOT}}"]` (verified: `workflows/research-workflow/.claude/settings.json:32`), and `SETUP.md` lines 20–23 instruct the operator to manually replace `{{WORKSPACE_ROOT}}` with a literal absolute path **in that tracked file**. So even after deploy-workflow stops writing the grant to the project's tracked settings.json, a freshly deployed project still inherits a tracked `additionalDirectories` *from the copied template* (Step 3 `cp -r`, deploy-workflow.md:38), which the operator is then told by SETUP.md to fill with a machine-specific path and (implicitly) commit. This change does not touch that path, so the machine-specific-path defect is **not fully closed** by editing deploy-workflow alone — an implicit dependency on the template's settings shape that is invisible from the Step 4 edit site.
- **Sequencing assumption with the existing Step 4 sub-step.** The earlier "Ensure permissions baseline" sub-step (deploy-workflow.md:154–166) merges the canonical `permissions` block into the **tracked** `settings.json`; the changed sub-step now writes a *separate* `permissions.defaultMode` into `settings.local.json`. Two files now both carry a `permissions` block for the same project. That is the intended Layer D / Layer D′ split and is documented in permission-template.md, so it is an established convention (Medium, not High) — but the change must keep the `defaultMode` value identical in both (`bypassPermissions`) or the local file's value silently wins for any key it declares. The `(.permissions.defaultMode // "bypassPermissions")` idiom in the described edit handles this correctly.
- Mitigating factor keeping this at Medium not High: the new contract (local-file grant + mandatory defaultMode) is explicitly documented at Layer D′ (permission-template.md:190–220) and already proven by the `/new-project` precedent, so it is not an *undocumented* new contract.

### Dimension 6: Principle Alignment
**Risk:** Low

- Principles-base read successfully at `projects/strategic-os/ai-strategy/principles-base.md`.
- **DR-1 / DR-3 (placement) — actively served.** The change moves a machine-specific absolute path out of git-tracked config into the gitignored per-machine local file — the correct home per Layer D′. This is a placement correction, not a violation.
- **DR-7 / OP-9 / AP-7 (speculative abstraction) — not triggered.** The change adds no new contract for an absent consumer; it removes a defect from an existing generator. The Step 1.5 inventory shows the `settings.local.json` grant target already has a confirmed second consumer (`/new-project` landed it 2026-06-26), so even the *pattern* is past the "second confirmed consumer" bar (DR-7).
- **OP-11 / OP-3 (loud revision, no silent drift) — satisfied, with one caveat.** This is not a principle revision; it brings deploy-workflow into line with the *already-recorded* 2026-06-03 Layer D / Detection-Rule-8 decision (permission-template.md:185, 220 "Known pending-alignment item"). The caveat: that pending-alignment note (line 220) names only `/new-project`. Closing deploy-workflow without also updating that note would leave the canonical doc silently stale — a mild drift-risk, addressed in Mitigations.
- **OP-12 (closure before detection) — served.** This is pure closure of an existing detection (`/permission-sweep` Detection Rule 8). No new detection capability is added.
- No tension with OP-2, OP-5, OP-10.

## Mitigations

- **Dimension 5 (parallel defect — the load-bearing one):** Before or alongside landing this edit, decide and record how the **research-workflow template's tracked `additionalDirectories`** (`workflows/research-workflow/.claude/settings.json:32` + `SETUP.md:20–23`) is handled. Either (a) remove `additionalDirectories` from the template's tracked settings.json and move the SETUP.md instruction to target `settings.local.json` (closing the defect at the template source too), or (b) explicitly scope this risk-check and the mission to "generators only, template handled separately" and open a tracked follow-up. Landing the deploy-workflow edit alone leaves a freshly deployed project still carrying a tracked machine-path from the copied template — the defect the mission claims to close is only partially closed.
- **Dimension 3 (inaccurate blast-radius model):** Correct the change description's claim that `/sync-workflow` re-runs this enrichment. It does not (`sync-workflow.md:48` excludes both settings files; lines 120–124 forbid auto-modifying settings). Note in the landing commit that older already-deployed projects are **not** retro-fixed by `/sync-workflow` and retain their tracked grant until manually cleaned per the Layer D′ migration note (permission-template.md:214–218).
- **Dimension 6 caveat (doc currency):** Update permission-template.md's "Known pending-alignment item (2026-06-03)" note (line 220) to mark `/deploy-workflow` resolved once this lands, so the canonical doc does not silently drift from the generators' actual behavior (OP-11).

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references and verbatim reads from deploy-workflow.md, new-project.md, sync-workflow.md, permission-template.md, the research-workflow template settings.json/SETUP.md, and `.gitignore` line 18 confirming settings.local.json is gitignored; principle IDs cited from principles-base.md). The `/sync-workflow` and template-defect findings were confirmed by grep, not assumed. No training-data fallback was used on any read.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**1. Concur with PROCEED-WITH-CAUTION — qualified.** Verdict correctly calibrated; both corrections right (command edit correct/low-risk in isolation; the `/sync-workflow` blast-radius catch is load-bearing — older projects are NOT retro-fixed).

**2. Conflict named:** the command edit alone does NOT close the mission's root cause. Confirmed by direct read: the template's own `settings.json:31–34` ships a tracked `additionalDirectories: ["{{WORKSPACE_ROOT}}"]`; Step 3's `cp -r` copies it into every fresh deploy before the grant sub-step runs. `SETUP.md:18–30` is a third emitter (manual deploy path). Three emitters, not one.

**3. Fix the template source THIS session** — it IS the root cause for fresh deploys (`repo-architecture.md` line 115 — edit the fragment, not the command), it is one of the two in-scope generators, and cost/coupling are low. Fold under the SAME `/risk-check` verdict + end-time gate (DR-8). Defer to a follow-up thread ONLY the Patrik-blocked retrofit of already-deployed projects — not the template/SETUP edits.

**4. Risks the dimension review missed:**
- Verify the `defaultMode` + `additionalDirectories` layer-split preserves the effective read grant after moving to `settings.local.json` (merge precedence — check `permission-template.md` Rule 8 / Layer D′).
- SETUP.md is a live third emitter for the manual deploy path — fix in the same edit, do not open a separate thread.

**Position:** Do not mark the mission root-cause "closed" until all three emitters are remediated — closing on the command edit alone is the OP-3/OP-11 silent-divergence failure mode.

**Separate flag (out of scope):** the canonical vault (`projects/repo-documentation/vault/`) is recorded migration-complete but is absent on this machine — a grounding-integrity drift worth its own look.
