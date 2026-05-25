# Risk Check — 2026-05-25

## Change

Extract canonical project settings + canonical project CLAUDE.md sections from inline /new-project (step 2 + step 4) into new shared templates under ai-resources/templates/. Templates already drafted: templates/project-settings.json.template (canonical permissions + 2 SessionStart hooks), templates/project-claude-md/{header,input-file-handling,commit-rules,compaction,session-boundaries}.md, templates/README.md (consumer contract + 2026-04-13 verdict). Pending changes: (a) rewire /new-project step 2 to read settings template + jq-merge in place of the inline CANONICAL_PERMS literal — preserving the predicate that gates the merge when .permissions.allow is already non-empty; (b) rewire /new-project step 4 to read CLAUDE.md fragments + append in place of the inline printf heredocs — preserving the grep-q '^## <heading>' per-section idempotency; (c) align workflows/research-workflow/.claude/settings.json and workflows/research-workflow/CLAUDE.md against the canonical templates while preserving intentional {{...}} deploy-time placeholders (the 2026-04-28 permission-sweep-auditor entry exists precisely to defend that placeholder convention); (d) add a one-line pointer in ai-resources/CLAUDE.md to the new templates/ directory. Plan-time gate per session-plan.md. Originated from improvement-log.md Sequencing Session 2 (templates).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/project-settings.json.template — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/project-claude-md/header.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/project-claude-md/input-file-handling.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/project-claude-md/commit-rules.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/project-claude-md/compaction.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/project-claude-md/session-boundaries.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/README.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-project.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Low-risk refactor in spirit (extraction with byte-equivalent intent and idempotency preserved), but two concrete couplings need explicit handling — the existing `docs/permission-template.md:349` update protocol still names the obsolete `CANONICAL_PERMS` literal, and the rewired bash must resolve template paths via a walk-up to `ai-resources/` (not a relative path) so consuming projects outside `ai-resources/` can locate the templates.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The four CLAUDE.md fragments and the settings template are read at scaffold time only (one invocation per `/new-project` run) — not on every session start, not on every tool call. Evidence: `templates/README.md:18` — "primary consumer" is `/new-project` step 2 + step 4; no auto-load hook.
- The one-line pointer added to `ai-resources/CLAUDE.md` is on an always-loaded file but additive footprint is ~1 line. Evidence: change description (d) — "add a one-line pointer in ai-resources/CLAUDE.md to the new templates/ directory."
- `/new-project` body is sonnet-tier (frontmatter `model: sonnet` at `new-project.md:2`) and reading 6 small files (~125 lines combined per `session-plan.md:25`) replaces ~225 lines of inline heredoc and JSON literal — net per-invocation token cost is near-zero or slightly negative.
- No new hooks registered. The two SessionStart hooks inside the settings template (`auto-sync-shared.sh`, `check-permission-sanity.sh`) are byte-identical to the inline versions already present in `.claude/commands/new-project.md:298–311` — they ship to deployed projects, not into ai-resources sessions.

### Dimension 2: Permissions Surface
**Risk:** Low

- The settings template (`templates/project-settings.json.template`) is byte-identical in shape to the inline `CANONICAL_PERMS` block at `new-project.md:328`. Confirmed by diff-reading both: same allow list (16 entries), same deny list (7 entries), same `defaultMode: "bypassPermissions"`, same two SessionStart hooks.
- The change is an extraction — same permission surface emitted to new projects as before.
- Alignment of `workflows/research-workflow/.claude/settings.json` preserves the intentional `{{WORKSPACE_ROOT}}` placeholder per change description (c) and `workflows/research-workflow/SETUP.md:20`. The 2026-04-28 permission-sweep-auditor entry (now applied 2026-05-25 per `improvement-log.md:62`) silences placeholder findings, so alignment will not regress on this.
- No `deny` rules are removed; no scope-escalation (project → user); no new tool families granted.

### Dimension 3: Blast Radius
**Risk:** Medium

- Files touched directly: 4 (new-project.md, research-workflow/settings.json, research-workflow/CLAUDE.md, ai-resources/CLAUDE.md) + 7 new template files already drafted.
- `/new-project` callers and references (grep `grep -rn "/new-project" docs/ .claude/commands/`): **13 hits** across `docs/repo-architecture.md` (3 hits), `docs/permission-template.md` (3 hits), `docs/session-guardrails.md` (1), `docs/session-rituals.md` (1), `.claude/commands/route-change.md` (2), `.claude/commands/repo-dd.md` (2), `.claude/commands/new-project.md` (self-refs). None of these call `/new-project` programmatically — they reference it as documentation. No caller depends on the inline `CANONICAL_PERMS` variable name or the inline heredoc shape.
- **Coupled contract — `docs/permission-template.md:157` and `:349`:** Both lines explicitly direct future editors to update `CANONICAL_PERMS` literal in `new-project.md`. If the rewire removes that literal without updating the protocol doc, the next permission-template edit will hit a stale instruction ("update `CANONICAL_PERMS` literal" — but the literal no longer exists). This is a contract change that **is** breaking, narrowly, for the human-procedural pathway documented in `permission-template.md` § Update protocol.
- `docs/repo-architecture.md:108` and `:143` describe `/new-project` as emitting the canonical permission shape inline — these would need to be re-read by a future editor but do not break behavior.
- Existing inline copy in `workflows/research-workflow/.claude/settings.json` and `CLAUDE.md` already drifted slightly (e.g., settings.json line 28 has an extra deny `Read(logs/*-archive-*.md)` not in the canonical template; CLAUDE.md has a `## File Verification and Git Commits` section absent from the canonical fragments). Alignment will either erase these or require a per-file judgement call.

### Dimension 4: Reversibility
**Risk:** Low

- The new `templates/` directory is a sibling tree of new files — `git revert` removes them cleanly.
- The `/new-project` rewire is a single-file edit to `.claude/commands/new-project.md` — `git revert` restores the inline `CANONICAL_PERMS` and inline heredocs to their prior shape in one operation.
- No state pushed beyond the repo (no `git push` in the change). No hook auto-fires between landing and revert — the templates are passive data; only `/new-project` reads them at invocation.
- Research-workflow file alignment is also a single-file edit per file — `git revert` restores prior content.
- The pointer line added to `ai-resources/CLAUDE.md` is a single line — `git revert` removes it.
- One mild caveat: if `/new-project` is invoked between landing and a hypothetical revert, the project it produced will have already received the (likely identical) settings + CLAUDE.md output — but since the template contents are byte-equivalent to the inline versions, no operator-visible difference results.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Path-resolution coupling (load-bearing, not yet visible in the change description):** The current inline `CANONICAL_PERMS` is a string literal in `new-project.md` and travels with the command regardless of CWD. After rewire, the bash logic must locate `templates/project-settings.json.template` and 5 CLAUDE.md fragments at some path. The command runs from project repos and from the workspace root — not from inside `ai-resources/` (the CWD guard at `new-project.md:13` blocks running from there). The rewired bash must walk upward to find `ai-resources/`, mirroring the idiom at `new-project.md:48–55` (planning workspace walk) and `new-project.md:366–371` (ai-resources walk in additionalDirectories grant). If the rewire instead uses a relative or hardcoded path, `/new-project` will break on first invocation from a project outside `ai-resources/`. The change description does not yet state how paths will be resolved.
- **Documented update-protocol contract drift:** `docs/permission-template.md:349` says "Update the `CANONICAL_PERMS` and `AUTO_SYNC_HOOK` / `SANITY_HOOK` literals in `ai-resources/.claude/commands/new-project.md`." After rewire, those literals are gone — the doc must instead direct editors to update `templates/project-settings.json.template`. The change description does not include this doc update; if missed, the next permission-template editor will hit a dead instruction.
- **Read-only template contract is documented at the change site** (`templates/README.md:23` — "Templates are read-only"), which is the right place for the new contract — that part is well-handled.
- **Placeholder defense is preserved:** the 2026-04-28 permission-sweep-auditor entry silences `{{WORKSPACE_ROOT}}` findings per `improvement-log.md:62` (applied 2026-05-25), so research-workflow alignment will not re-introduce the 2026-05-11 regression.
- **CLAUDE.md fragment drift in research-workflow alignment:** the existing `workflows/research-workflow/CLAUDE.md` contains a `## File Verification and Git Commits` section (lines 103–107) that is **not** in the canonical fragments. Alignment must explicitly decide whether to (i) preserve it as research-workflow-specific, (ii) promote it to a canonical fragment, or (iii) drop it. The change description names only the canonical-section alignment, not this divergent section.

## Mitigations

- **Dimension 3 (blast radius) — update `docs/permission-template.md` in the same change batch.** Edit lines 157 and 349 to redirect from "update the `CANONICAL_PERMS` literal in `new-project.md`" to "update `templates/project-settings.json.template`." This closes the human-procedural contract drift surfaced by the grep enumeration. Single-line edits, no logic change.
- **Dimension 5 (hidden coupling) — specify path resolution explicitly in the /new-project rewire.** Use the established walk-up idiom (`new-project.md:48–55` planning-workspace walk; `:366–371` ai-resources walk) to locate `ai-resources/templates/` from the CWD. Do not use a relative path. Verify on a hypothetical project at `projects/foo/` (1 directory deep) and at the workspace root (sibling to `ai-resources/`).
- **Dimension 5 (hidden coupling) — decide on `## File Verification and Git Commits` in research-workflow alignment.** Per session-plan.md decision-point posture: preserve the existing section as research-workflow-local (not promote to canonical, not drop) since it is workflow-specific guidance not load-bearing for fresh-project scaffolding. State the choice inline in the alignment commit message.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: line-anchored citations from `new-project.md`, `permission-template.md`, `improvement-log.md`, `session-plan.md`, the drafted template files, and the two research-workflow files; grep enumerations for `/new-project` references (13 hits across docs and commands) and `CANONICAL_PERMS` / template-class references. No training-data fallback was used.


## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

### Concurrence with PROCEED-WITH-CAUTION

The System Owner concurs with the verdict. This is a **safe-zone refactor with two contract-edge couplings**, and `PROCEED-WITH-CAUTION` is the right tier — but the verdict is incomplete on one architectural dimension the dimension review did not cover.

The change is byte-equivalent extraction with idempotency preserved (Dim 1, Dim 2, Dim 4 all Low — verified by the report's diff-reading). The Medium tags on Dim 3 and Dim 5 are appropriate because two human-procedural contracts (`permission-template.md:157/:349` and the unspecified path-resolution shape) cross the change boundary. None of those are runtime breakage; all are downstream-edit-time breakage. That matches what `risk-topology.md § 3` classifies as a structural change requiring `/risk-check` (`DR-8`), and what `principles.md § DR-9` requires top-3-callers analysis on — which the report performed (13 grep hits enumerated, none invoke `/new-project` programmatically).

### The three required mitigations are correct and sufficient — for what they cover

1. **`permission-template.md:157/:349` update in the same batch.** Correct. Two-end contract; failing to update would create the silent-drift failure mode `principles.md § OP-3` and `risk-topology.md § 5` exist to prevent.
2. **Walk-up-to-`ai-resources/` path resolution.** Correct. The CWD guard at `new-project.md:13` rules out running inside `ai-resources/`; a relative path would hard-fail on first invocation from any project outside `ai-resources/`. Reusing the existing walk-up idiom is the right call under `principles.md § AP-7`.
3. **Preserve `## File Verification and Git Commits` as workflow-local.** Concur. Workflow-specific guidance, not project-scaffolding boilerplate. Promoting it would over-generalize (`principles.md § DR-7` — generalize only when a second confirmed consumer exists).

### The risk the dimension review missed — **architecture-map update is required in the same commit**

`repo-architecture.md:227-237` requires the architecture map to be updated in the same commit when either (a) a new top-level directory lands under workspace root or `ai-resources/`, or (b) a new artifact type ships that doesn't fit an existing canonical home. **The `templates/` extraction triggers both clauses.** The dimension review caught the `permission-template.md` contract drift but did not catch the `repo-architecture.md` contract drift, which is the same failure class one level up.

- **New top-level directory.** `ai-resources/templates/` is not in the directory tree at `repo-architecture.md:32–70`.
- **New artifact type.** The "Canonical homes by artifact type" table at `repo-architecture.md:91–108` lists "Permission shape (canonical) → `docs/permission-template.md`" as a single-file canonical home. The new pattern — "deployable canonical fragment, consumed by `/new-project` via walk-up read" — has no row. Q8 (`:218-223`) does not address this category either.
- **Q4 placement heuristics gap.** `:175-184` does not address "deployable canonical fragment that ships into projects at scaffold time."

**Mitigation #4 (added by system-owner):** Bundle a `repo-architecture.md` update into the same commit. Three edits, minimum:

1. Add `templates/` to the `ai-resources/` tree at `repo-architecture.md:32–70`.
2. Add a new row to the canonical-homes table at `repo-architecture.md:91-108`: "Deployable canonical fragment (consumed at scaffold time by `/new-project`) → `ai-resources/templates/<name>` → Read by `/new-project` via walk-up to `ai-resources/`; never auto-distributed."
3. Add a Q8 sub-bullet at `repo-architecture.md:218-223` naming the new pattern.

`risk-topology.md § 5` ("safe change zones — signals that elevate to structural risk") names exactly this case: "new canonical doc that becomes a load-bearing source of truth" — the `templates/` directory and its `README.md` consumer contract are precisely that.

### Final position

Proceed with the change. Apply the three mitigations the report names. **Add `repo-architecture.md` update to the same batch as a fourth mitigation** — three line-anchored edits covering tree, canonical-homes table, and Q8 sub-bullet. Without it, the change creates the same two-end-contract drift one architectural layer up that mitigation #1 fixes one layer down.

**Follow-on watch item once landed:** the workflows/research-workflow alignment is the first test of whether the new `templates/` consumer contract is correctly self-defending. If alignment surfaces a third divergent section beyond `## File Verification and Git Commits`, the canonical fragment set is under-specified — surface as sequencing follow-up rather than expanding fragment scope in this change.
