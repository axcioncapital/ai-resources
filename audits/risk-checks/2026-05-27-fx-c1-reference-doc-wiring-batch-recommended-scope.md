# Risk Check — 2026-05-27

## Change

FX-C1 reference-doc wiring batch — Recommended scope. Edit 5 ai-resources workflow command files to read project reference docs and pass content or path to subagent invocations:
(1) `run-execution.md` adds reading of `source-class-hierarchy.md` and `quality-standards.md` and passes content/path to `research-prompt-creator` and `research-extract-creator` subagents;
(2) `run-cluster.md` adds reading of `source-class-hierarchy.md` and `quality-standards.md` and passes to `cluster-analysis-pass` and `cluster-memo-refiner` subagents;
(3) `run-analysis.md` adds reading of `quality-standards.md` and passes to `analysis-pass-memo-review`;
(4) `run-report.md` adds reading of `style-guide.md` and `quality-standards.md` and passes to `evidence-to-report-writer`, `chapter-prose-reviewer`, `report-compliance-qc`;
(5) `review-chapter.md` adds reading of `quality-standards.md` and `style-guide.md` and passes to `chapter-review`.
Total: 9 wiring pairs in 5 ai-resources canonical workflow command files. Closes Pass 4 blockers B-02, B-17, B-18 and ~14 of 28 Hardcoded items shift to Configurable. No skill files modified in this batch (skill prompt-templates already expect reference-doc input per H-02 Option A pattern). Project file scope is read-only on the audit files + plan file.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/run-execution.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/run-cluster.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/run-analysis.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/run-report.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/review-chapter.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/source-class-hierarchy.md` — exists (project-side)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/quality-standards.md` — exists (project-side)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/style-guide.md` — exists (project-side)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-prompt-creator/SKILL.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-extract-creator/SKILL.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/cluster-analysis-pass/SKILL.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/cluster-memo-refiner/SKILL.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/analysis-pass-memo-review/SKILL.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/evidence-to-report-writer/SKILL.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/chapter-prose-reviewer/SKILL.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/report-compliance-qc/SKILL.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/chapter-review/SKILL.md` — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Wiring fixes are low-cost and skill-aligned per H-02 Option A, but the canonical workflow's project deployments are copies — not symlinks — so the Nordic-PE project will not inherit the edits without a sync step, creating a coupling/reversibility risk that requires a paired mitigation.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- Each of the 5 commands runs on demand inside a pipeline session — none auto-fires per turn or via hooks. Frontmatter on all 5 files shows `friction-log: true` and `model: sonnet`/`opus`, but no SessionStart/PreToolUse/Stop hook coupling (verified by reading the YAML headers of all 5 files).
- The reference docs being read are project-side and substantial — quoting `run-report.md` Step 4.2c: command will pass "the style reference from `/report/style-reference/{section}/{section}-style-reference.md`" alongside scarcity register and section directive. Adding 2-3 additional reference-doc reads per delegate call (subagent context payload) increases per-invocation token cost meaningfully, even though it does not add always-loaded content.
- The pattern is pay-as-used (per pipeline-stage invocation), not always-loaded — consistent with Low. But subagent payload bloat per stage call lifts to Medium because Stage 4 alone fires `evidence-to-report-writer` + `chapter-prose-reviewer` + `report-compliance-qc` per chapter (3 subagents × N chapters × ~2 added reference files each).
- No `@import` chain added to any always-loaded CLAUDE.md surface. Workspace `CLAUDE.md` and project `CLAUDE.md` untouched by the described change.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `permissions.allow` / `permissions.deny` / `permissions.ask` entries are touched by the described change. Change body names only command-file edits and subagent input plumbing — no settings.json mutations.
- Reading project-side reference files requires no new permission — the `Read` tool already governs all path reads under the project working tree and the connected `ai-resources/` directory (via `--add-dir`).
- No new Bash patterns, no Write paths outside established subagent output directories, no MCP server additions, no cross-repo writes.

### Dimension 3: Blast Radius
**Risk:** High

- **5 canonical workflow command files edited directly** — `run-execution.md`, `run-cluster.md`, `run-analysis.md`, `run-report.md`, `review-chapter.md` under `ai-resources/workflows/research-workflow/.claude/commands/`.
- **9 subagent invocation contracts modified** (per change description): research-prompt-creator, research-extract-creator, cluster-analysis-pass, cluster-memo-refiner, analysis-pass-memo-review, evidence-to-report-writer, chapter-prose-reviewer, report-compliance-qc, chapter-review.
- **Critical decoupling: project copies, not symlinks.** `ls -la projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/` shows `run-cluster.md`, `run-execution.md`, `run-analysis.md`, `run-report.md`, `review-chapter.md` are all regular files (mode `-rw-r--r--`), NOT symlinks — verified by file mode and confirmed by `diff -q` which reports the project copy of `run-cluster.md` and `run-execution.md` already DIFFER from the canonical workflow versions. The `deploy-workflow.md` command performs a copy at project init (per its Step 1+2 content). **Editing the canonical files will not propagate to the Nordic-PE project deployment.** Per change-context note, "The Nordic-PE project itself is the only current deployment of this workflow" — so the canonical edits will not be reflected in the only live runtime test bed unless the project copies are also synced.
- Skill files unchanged (per the description's stated scope), and the skills already expect these inputs — `research-prompt-creator/SKILL.md` line 30 names `reference/source-class-hierarchy.md` as required input #4 with halt-if-absent semantics, and lines 92-96 quote `reference/quality-standards.md` Evidence-First Principle. `chapter-review/SKILL.md` lines 38-66 mark Architecture spec, Style reference, and Section directive as "required — blocking" inputs. This evidence confirms the H-02 Option A claim that skills already expect reference-doc input.
- Contract changes are backwards-compatible at the skill level (skills already accept the inputs), but NOT backwards-compatible at the command-level for project deployments that have NOT been synced — running an unsynced project copy of `run-execution.md` after the skill expectations tighten upstream (if/when they do) could leave the project in a degraded state.
- No CLAUDE.md content touched, no shared hooks touched.

### Dimension 4: Reversibility
**Risk:** Medium

- The 5 ai-resources edits are clean single-file edits; `git revert` on the change commit restores the canonical workflow files cleanly within the `ai-resources/` repo working tree.
- However: if the Nordic-PE project copies are ALSO synced (as a required follow-on per the Blast Radius mitigation), reversal then requires TWO repos to be reverted in coordination — the `ai-resources/` repo and the project repo. Both repos are local but separate git working trees per the workspace structure described in `Axcion AI Repo/CLAUDE.md` § Projects (ai-resources/, workflows/, projects/).
- No external state propagation (no push, no Notion write, no API POST described).
- No append-only log mutation; no hook automation that would fire between the edit and a hypothetical revert.
- Operator muscle memory is not a factor — these are command files, not new slash commands. Existing `/run-execution`, `/run-cluster`, etc., continue to be invoked the same way.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Implicit dependency on canonical-to-project sync discipline.** The change assumes that editing `ai-resources/workflows/research-workflow/.claude/commands/*.md` improves runtime behavior in the only live deployment (Nordic PE project). The deployment model is copy-based (verified above), so this assumption is wrong unless the project copies are also touched. The change description states "Project file scope is read-only on the audit files + plan file" — meaning the change as scoped will not touch the project copies, leaving the canonical/project drift uncorrected.
- **Skill-to-command input contract is implicit.** Skills like `research-prompt-creator` declare reference-doc inputs as "Required" with halt-if-absent semantics (line 30 of `research-prompt-creator/SKILL.md`: "If the file is absent, halt — prompts cannot meet the source-class targeting requirement without it"). The command edit will satisfy this contract for new deployments and for the canonical workflow, but the project's existing run-execution.md (which differs from canonical) may or may not currently satisfy it — that depends on the existing project copy's state. This risk-check does not know the diff content, only that the files differ.
- **Two-end string-literal contract documented in `run-report.md` line 89** — "The literal token `approved` (this command's trigger) and the marker filename suffix `-OPERATOR-APPROVED.md` are both load-bearing strings shared with `citation-converter`." The wiring batch as described does not touch this contract, but the description does not enumerate which lines of `run-report.md` will be edited — if the reference-doc reads are inserted near Step 4.0 (Load Inputs) the contract is unaffected; if inserted inside Step 4.2 sub-steps the contract should still be safe, but the change description does not assert this. Treating as Medium because the contract is documented at the change site and visible to the editor.
- No functional overlap with existing mechanisms — the wiring is additive (reference-doc reads + subagent payload extensions), not a parallel system competing with an existing one.
- No silent auto-firing; the change only takes effect during operator-invoked pipeline commands.

## Mitigations

- **Dimension 3 (Blast Radius) — High:** Before declaring FX-C1 landed, sync the 5 edited canonical command files to the Nordic-PE project's `.claude/commands/` directory by overwriting the project copies with the updated canonical versions, OR diff each project copy against the new canonical and apply only the wiring edits as a minimal patch (preserves any project-side divergence). Verify with `diff -q` after sync that the project copies and canonical files agree on the 9 wiring pairs. Without this step, the canonical edits land but the only live deployment continues to run pre-edit logic and the fix has no runtime effect.
- **Dimension 3 (Blast Radius) — High:** Document the canonical-vs-project copy model explicitly in the FX-C1 commit message and in the project's session-notes so the next operator (or future audit) understands why both repos changed in the same fix-phase batch.
- **Dimension 1 (Usage Cost) — Medium:** When editing the per-chapter loop in `run-report.md` Step 4.2 (which fires 3 subagents per chapter), pass reference-doc PATHS instead of full content where the subagent can read the file itself, OR ensure the subagent payload uses content-not-path only once per chapter and reuses across the (a)/(b)/(c) sub-steps. This keeps the per-stage token budget within Low range. The change description explicitly says "passes content or path" — pick path-passing for the high-frequency loop and content-passing only for one-shot invocations.
- **Dimension 4 (Reversibility) — Medium:** Commit the 5 canonical edits and the project sync as ONE commit (or two paired commits with the same Co-Authored-By stamp and a shared `FX-C1` token in both messages) so a future `git revert` operator finds both halves of the change linked. If split across two repos, name the partner commit hash in each commit message body.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file reads of all 5 canonical command files (verified frontmatter, content, contract documentation including `run-report.md` line 89 string-literal contract), file reads of 3 skill files (`research-prompt-creator/SKILL.md` lines 24-34 and 92-104, `chapter-review/SKILL.md` lines 31-66, `cluster-analysis-pass/SKILL.md` lines 21-40, `evidence-to-report-writer/SKILL.md` lines 22-80), directory listing of project `.claude/commands/` showing regular files not symlinks, `diff -q` confirming project copies already differ from canonical, read of `deploy-workflow.md` confirming the copy-not-symlink deployment model, and read of `ai-resources/docs/audit-discipline.md` § Risk-check change classes for verdict gating. No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

### 1. Concur with PROCEED-WITH-CAUTION

We concur. The verdict is correct, but the underlying framing should sharpen: the High blast-radius is not "many files touched" — it is **a deployment-model mismatch** between the change as scoped and the change as needed. The canonical edit is necessary but not sufficient. Without the paired project-copy sync, FX-C1 has zero runtime effect on the only live deployment, which crosses from "cautious change" into "documented illusion of a fix" (`principles.md § OP-3 — loud failure over silent continuation`; `risk-topology.md § 5` — two-end string contracts).

### 2. Routing position

The 5 files at `ai-resources/workflows/research-workflow/.claude/commands/` are **workflow-template commands**, not canonical slash commands. They are NOT covered by `auto-sync-shared.sh` — the hook walks `ai-resources/.claude/commands/`, and these files are one directory level deeper inside a graduated workflow template. The deployment mechanism is `/deploy-workflow` (copy-based, one-shot at project init), per `repo-architecture.md § Canonical homes — Workflow template` row.

This means FX-C1 is a **two-target structural edit**, not a one-target edit with downstream amplification:
- Target A: `ai-resources/workflows/research-workflow/.claude/commands/` — the template's source of truth for any future deployment.
- Target B: `projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/` — the only live runtime instance.

The routing baseline matters here: the project copies are **older than canonical**. This inverts the usual canonical→project flow.

### 3. Tightenings to the recommended path

**a. Diff before sync, not overwrite.** `diff -q` already reports project copies and canonical diverge on `run-cluster.md` and `run-execution.md`. A blanket overwrite would destroy that divergence silently — `principles.md § AP-1 — silent conflict resolution` violation. Correct sub-step: for each of the 5 files, diff project vs. canonical, classify each diverging hunk (intentional project divergence / drift / pre-existing wiring), then apply only the FX-C1 wiring hunks to the project copy.

**b. The project is the source-of-truth, not the canonical.** Per the routing context, the workflow template was reverse-engineered from the project. Land the wiring in the project copy first (verify it works in the only live test bed), then promote the same wiring to canonical. Doing it canonical-first treats the template as primary, which it is not yet — there is only one consumer (`principles.md § DR-7 — generalize only when a second confirmed consumer exists`).

**c. Path-passing for the per-chapter loop, content-passing once.** Concur with the original mitigation. `system-doc.md § 2.5 Design Constraints — Token usage` is binding: Stage 4's per-chapter triplet × N chapters × 2 reference files would compound the Medium cost rating into the High band the risk-check did not flag.

### 4. Risks the dimension review missed

**Missed risk 1: Template-vs-deployment two-end contract is now load-bearing.** FX-C1 effectively encodes "every research-workflow project must have `reference/source-class-hierarchy.md`, `reference/quality-standards.md`, `reference/style-guide.md` at these exact paths" — a string-literal contract between the workflow template and every future deployed project. The next project deployed from this template will halt if these reference filenames are absent. **Recommended additional mitigation:** document the three required reference-file paths in `ai-resources/workflows/research-workflow/` (template-level README or reference doc) as part of FX-C1, so the contract is visible at the template surface, not implicit in 5 separate command files.

**Missed risk 2: `/sync-workflow` exists and is the documented mechanism.** Per `toolkit-relationship.md § 2`, `/sync-workflow` is the workflow-template-to-deployed-project sync command. The risk-check's manual diff-and-patch flow should at least be checked against the documented command first. `[CITATION NEEDED]` on `/sync-workflow`'s actual capabilities — verify before doing manual diff-and-patch.

**Missed risk 3: Auto-sync hook rule #4 is a red herring here but worth naming.** The hook walks `ai-resources/.claude/commands/`, not `ai-resources/workflows/{name}/.claude/commands/`. The protection rule #4 provides is irrelevant to this change. The deployment model here is `/deploy-workflow` + `/sync-workflow`, not the SessionStart auto-sync.

**Missed risk 4: Project CLAUDE.md frontmatter convention conflict.** Project `CLAUDE.md § Command Conventions` declares "Pipeline command files in `.claude/commands/` declare their tier and behavior flags via YAML frontmatter at the top of the file." If FX-C1's edits change frontmatter — even unintentionally during a diff-and-merge — the project will reject the sync as a frontmatter violation. Verify FX-C1's edits are body-only, not frontmatter-touching, before sync.

### 5. Clear position

**The right answer is: do FX-C1, but reshape it.**

1. **Land the wiring in the project copy first** (only live runtime test bed), verify Stage 2 + Stage 4 still execute, then promote the same diff to canonical. Two commits, paired with shared `FX-C1` token in both messages naming the partner commit hash.
2. **Diff-and-patch the project copies, do not overwrite.** Each of the 5 files: classify divergence, apply only FX-C1 wiring hunks. Frontmatter untouched.
3. **Use path-passing in the per-chapter loop** (`run-report.md` Step 4.2); content-passing only for one-shot invocations.
4. **Add a template-level contract doc** at `ai-resources/workflows/research-workflow/` naming the three required project-side reference filenames as a precondition for deployment.
5. **Check `/sync-workflow` capability before doing manual diff-and-patch.** If it handles bidirectional sync correctly, prefer it (`principles.md § DR-2`).
6. **DR-8 plan-time gate is satisfied by this risk-check.** The end-time `/risk-check` re-fire before commit is still required.

**On the verdict tier:** PROCEED-WITH-CAUTION holds, but with the reshape above the actual blast-radius profile drops from High to Medium. The change becomes a routine paired-commit structural edit rather than a canonical edit with an implicit cross-repo prayer.
