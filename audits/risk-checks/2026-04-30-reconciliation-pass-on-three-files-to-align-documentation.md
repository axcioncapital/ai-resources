# Risk Check — 2026-04-30

## Change

Reconciliation pass on three files to align documentation with on-disk reality and the locked taxonomy:

1. `knowledge-bases/pe-kb-vault/CLAUDE.md`
   - `Folder structure` section: substitute two stale `raw/` folder paths (`raw/pe-research/` → `raw/pe-kb-1-research/`; `raw/buyside-service-plan/` → `raw/buyside-service-plan-research/`) to match on-disk subfolder names.
   - `Tag taxonomy` section: relabel `Starting vocabulary:` to `Locked vocabulary (10 tags):`; append two bullets (`fund-governance`, `deal-mechanics`) so the always-loaded list matches the live wiki tag set; add a one-line prose pointer to the locked `taxonomy-proposal.md` (workspace-relative path, not a wiki-link, not a relative path crossing the vault boundary).

2. `knowledge-bases/pe-kb-vault/templates/wiki-article-template.md`
   - Fix line 3 stale `raw/pe-research/` reference to `raw/pe-kb-1-research/`.
   - Add a commented-out second `sources` example for the buyside subfolder so authors see both raw subfolders illustrated.

3. `ai-resources/.claude/commands/kb-ingest.md`
   - Step 1 DP1 ambiguity-check (line 29): substitute the two stale folder paths inside the parenthetical to match the as-built names. Same drift class as items 1+2; bundled per operator decision.

Change classes: cross-cutting CLAUDE.md edit (vault scope only — does not touch workspace-level CLAUDE.md or any other project's CLAUDE.md); shared-command-file edit (`kb-ingest.md` is shared infrastructure under `ai-resources/.claude/commands/`).

All four edits are mechanical substitutions: no behavior change, no new automation, no permission change, no schema change. Outcome: future `/kb-ingest` runs and any vault session will read folder paths and tag vocabulary that match disk and `taxonomy-proposal.md`. Two commits will result (one per repo: vault repo, ai-resources repo). Plan file: /Users/patrik.lindeberg/.claude/plans/items-1-2-prancy-rossum.md.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/knowledge-bases/pe-kb-vault/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/knowledge-bases/pe-kb-vault/templates/wiki-article-template.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/kb-ingest.md — **NOT FOUND at this path** (path mismatch; see Hidden Coupling). On-disk command lives at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/knowledge-bases/pe-kb-vault/.claude/commands/kb-ingest.md`.
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/output/pe-knowledge-base/taxonomy-proposal.md — exists (read-only target of the new prose pointer)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** All four edits are genuinely mechanical and low-risk on their own, but the change description points at a non-existent path (`ai-resources/.claude/commands/kb-ingest.md`) and omits two further stale references on disk that will leave the file half-reconciled if not addressed before landing.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- CLAUDE.md additions are bounded: relabel one line, append two tag bullets (~30 tokens), add one prose pointer (~20 tokens). Net delta well under the ~50–150 token Medium threshold. Evidence: current `Tag taxonomy` section is `CLAUDE.md` lines 150–164, eight existing bullets averaging ~12 tokens each; two added bullets follow the same pattern.
- Template edit substitutes one path (no growth) and adds a single commented `sources` line (~15 tokens). Templates are read in ingestion mode only, not always-loaded.
- `kb-ingest.md` edit is in-place substitution, no token growth. Command file loads only when `/kb-ingest` is invoked.
- No new hooks, imports, skills, or auto-loaded subagents introduced. Pay-as-used surface unchanged.

### Dimension 2: Permissions Surface
**Risk:** Low

- CHANGE_DESCRIPTION explicit: "no permission change". Verified by inspection — no `.claude/settings.json` touched, no allow/deny rule altered, no new tool invocation pattern introduced.
- All three target files are markdown content; no Bash/Write/Read pattern change.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct files touched: 3 (vault CLAUDE.md, vault template, vault kb-ingest command).
- Grep enumeration of dependent callers and stale-name references across the repo:
  - **Inside vault:** `templates/wiki-article-template.md:3` (in scope), `.claude/commands/kb-ingest.md:29` (in scope), `.claude/commands/kb-ingest.md:75` (**NOT in scope of described change** — second stale `raw/pe-research/report-filename.md` reference inside the `sources` frontmatter example), `CLAUDE.md:144` (**NOT in scope** — second stale `raw/pe-research/report-filename.md` in the `Link syntax inside wiki articles` section), `_setup-notes.md` (historical drift log, do not edit), `logs/session-notes.md` (historical, do not edit).
  - **Outside vault:** `projects/project-planning/output/pe-knowledge-base/project-plan-v1/v2/v3.md`, `tech-spec-v1/v2/v3.md`, `context-pack.md`, and `projects/obsidian-pe-kb/pipeline/context-pack.md` all carry `raw/pe-research/`-style references. These are historical planning artifacts and do not need to update — but they confirm the drift pattern is wide.
  - 45 wiki articles (per `taxonomy-proposal.md`) already use the new `raw/buyside-service-plan-research/` name in their `sources` frontmatter (verified: 6 buyside articles grep'd). They are unaffected.
- Contract change assessment: filename slug pattern in `sources` frontmatter is the only contract; existing wiki articles already conform to the new name, so the template edit aligns the template with the existing corpus. Backwards-compatible.
- Sibling file `projects/global-macro-analysis/.claude/commands/kb-ingest.md` is a different command (handles `macro-kb/_inbox/`, not the vault) — not affected.
- Two within-scope files have a SECOND stale reference each (CLAUDE.md:144, kb-ingest.md:75) that the change description does not enumerate. If left, the reconciliation is incomplete and a future query/ingestion may surface the same drift the change is meant to retire. This is the source of the Medium rating.

### Dimension 4: Reversibility
**Risk:** Low

- Two commits, both content-only on tracked markdown files. `git revert` per commit fully restores prior state.
- No log mutation, no archive append, no external state push, no automation registered.
- The new prose pointer in CLAUDE.md to `taxonomy-proposal.md` adds a referent dependency, but reverting the pointer does not break the target file (the target exists independently).

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Path mismatch in CHANGE_DESCRIPTION.** Item 3 names `ai-resources/.claude/commands/kb-ingest.md`, but `find` confirms no such file at that path. The actual file is `knowledge-bases/pe-kb-vault/.claude/commands/kb-ingest.md`. Verbatim from change description: "shared-command-file edit (`kb-ingest.md` is shared infrastructure under `ai-resources/.claude/commands/`)". This is also factually incorrect — the file is vault-local, not shared across projects via `ai-resources/`. The unrelated sibling at `projects/global-macro-analysis/.claude/commands/kb-ingest.md` handles a different KB (`macro-kb/_inbox/`) and shares only the slash-command name. The change author appears to have conflated the two. Operator must resolve which file is being edited before landing.
- **Two further stale references not enumerated.** In addition to the lines listed in CHANGE_DESCRIPTION:
  - `CLAUDE.md:144` — `Link syntax inside wiki articles` section example: `Frontmatter \`sources\`: \`- "[[raw/pe-research/report-filename.md]]"\``.
  - `.claude/commands/kb-ingest.md:75` — Step 5 frontmatter writing instruction: `\`- "[[raw/pe-research/report-filename.md]]"\``.
  Both are the same drift class. If only the lines named in the change description are edited, the files remain internally inconsistent — one section uses the new name, another uses the old. Future readers / future ingestion runs will hit the stale reference.
- **Implicit dependency on `taxonomy-proposal.md` survival.** The new prose pointer in CLAUDE.md creates a soft dependency: if `taxonomy-proposal.md` is moved or deleted, the pointer rots. Mitigatable via Patrik's existing project-planning discipline; flagging here as a noted coupling, not a blocker.
- **Commit-boundary sequencing risk.** Plan calls for two commits (vault repo, ai-resources repo). If item 3 is actually targeting the vault-local kb-ingest.md (which is what `find` indicates), then BOTH commits land in the same repo — the two-repo split in the plan does not match disk reality. Operator must reconcile.

## Mitigations

- **Hidden coupling — Path mismatch:** Before editing, the operator must confirm which `kb-ingest.md` is actually targeted. Run `find . -name "kb-ingest.md" -type f` from the workspace root and reconcile with CHANGE_DESCRIPTION. If the target is `knowledge-bases/pe-kb-vault/.claude/commands/kb-ingest.md`, update the change description and the two-commit split (it becomes one commit in the vault repo, not two across vault + ai-resources).
- **Hidden coupling — Two further stale references:** Expand the substitution scope to also cover `CLAUDE.md:144` and `kb-ingest.md:75` (the second `[[raw/pe-research/report-filename.md]]` instances in each file). Both are the same drift class and the same mechanical-substitution shape; leaving them turns a "reconciliation pass" into a partial half-fix. If the operator chooses NOT to expand scope, document the deferral explicitly in the commit message and in `_setup-notes.md` so the residual drift is tracked.
- **Blast radius — Verify before commit:** After applying, `grep -rn "raw/pe-research\|raw/buyside-service-plan" knowledge-bases/pe-kb-vault/` (excluding `_setup-notes.md` and `logs/`) should return zero hits. If it returns hits, the reconciliation is incomplete.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (CLAUDE.md:17–18, 144, 154–164; wiki-article-template.md:3; kb-ingest.md:29, 75; taxonomy-proposal.md:30–39), `find` results confirming the path mismatch, and `grep -rn` enumerations of stale-name references across the repo. No training-data fallback was used.
