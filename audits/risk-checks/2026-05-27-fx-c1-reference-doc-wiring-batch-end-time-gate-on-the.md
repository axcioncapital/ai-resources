# Risk Check — 2026-05-27

## Change

FX-C1 reference-doc wiring batch — END-TIME gate on the EXECUTED change set.

Scope landed: 7 wiring pairs across 3 command files × 2 repos = 6 file edits total. Pairs:
(1) `run-execution.md` Step 2.1 adds reading of `reference/source-class-hierarchy.md` and `reference/quality-standards.md` passed by content to `research-prompt-creator` subagent.
(2) `run-execution.md` Step 2.3 adds reading of `reference/quality-standards.md` and `reference/known-limits.md` passed by content to `research-extract-creator` subagent.
(3) `run-cluster.md` Step 2 adds reading of three reference docs (`source-class-hierarchy`, `quality-standards`, `known-limits`) passed by content to combined `cluster-analysis-pass` + `cluster-memo-refiner` subagent (one per cluster, parallel).
(4) `run-report.md` Step 4.2a adds PATH (not content) for `reference/quality-standards.md` to `evidence-to-report-writer` subagent.
(5) `run-report.md` Step 4.2b adds PATHS for `reference/style-guide.md` and `reference/quality-standards.md` to `chapter-prose-reviewer` subagent.
(6) `run-report.md` Step 4.2c adds PATH for `reference/quality-standards.md` to `report-compliance-qc` subagent.

Path-passing in Stage 4 per system-owner advisory mitigation #3 (per-chapter loop token economy). Content-passing in Stage 2 + Stage 3 (one-shot per session). Project-first sequencing applied (system-owner advisory). Diff-and-patch shape applied (frontmatter untouched in all 6 files). Scope dropped from planned 9 pairs to 7: `analysis-pass-memo-review` (was Pair 5) and `chapter-review` (was Pair 9) have ZERO reference-doc dependencies per skill grep — dropped pre-edit. No skill files modified. Closes Pass 4 named blockers B-02, B-17, B-18; targets ~12 of 28 Hardcoded → Configurable shift. Pre-commit gate per two-gate firing model.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/run-execution.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/run-cluster.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/run-report.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/run-execution.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/run-cluster.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/run-report.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-05-27-fx-c1-reference-doc-wiring-batch-recommended-scope.md` — exists (plan-time risk-check)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/plans/fix-phase-plan-v1.md` — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Executed change set faithfully implements the plan-time mitigations (path-passing in Stage 4, content-passing in Stages 2–3, project-first sequencing, frontmatter untouched, project ↔ canonical mirror), closing the High blast-radius from plan-time down to Medium. Two new risks surfaced during verification: (a) `report-compliance-qc/SKILL.md` line 23 declares "Content is passed directly (not file paths)" yet Step 4.2c now passes a reference-doc PATH — undocumented contract divergence; (b) Step 4.0 line 22 carries a categorical "Sub-agents receive content, not file paths" rule that is silently violated by the new 4.2a/b/c path-passing without an in-step carve-out reference. Both are documentation-level mitigations, not blocking. Commit-pairing with shared FX-C1 token (plan-time Mitigation 4) is still pending — apply at commit time.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- Stage 2 + Stage 3 use content-passing (one-shot per session): `run-execution.md` line 39 lists 2 reference docs (`source-class-hierarchy.md` ~151 lines + `quality-standards.md` ~302 lines), line 105 lists 2 reference docs (`quality-standards.md` ~302 lines + `known-limits.md` ~103 lines), and `run-cluster.md` line 25 lists 3 reference docs passed as content to each cluster subagent (~556 lines total per cluster × N clusters in parallel). Per-cluster duplication is the dominant Stage 3 cost.
- Stage 4 uses path-passing (per-chapter loop) — verified at `run-report.md` lines 56, 59, 62 with explicit bold markers: "**Project reference doc PATH (subagent reads directly — path-passing per per-chapter token economy):**". Subagent invokes its own `Read` tool, so the per-chapter token payload does not include the reference-doc content. This implements plan-time Mitigation 3 cleanly.
- Skill input contract supports path-passing in Stage 4: `evidence-to-report-writer/SKILL.md` line 287 already names project reference paths; `chapter-prose-reviewer/SKILL.md` line 36 explicitly says "**Passed as an absolute file path.** Read the file at the provided path before evaluating; do not expect inlined content." — the skill is built for path-passing.
- No CLAUDE.md content touched. No hook coupling. No always-loaded surface. The cost is pay-as-used (per pipeline-stage invocation), not always-loaded. Net assessment: Stage 4 cost stays in Low band per design (mitigation worked); Stage 3 per-cluster duplication keeps overall rating at Medium (cluster count is small — typically 12 — but the duplication is real).

### Dimension 2: Permissions Surface
**Risk:** Low

- No `permissions.allow` / `permissions.deny` / `permissions.ask` entries touched. Change body is command-file body edits + subagent input plumbing only.
- No new Bash patterns, no new Write paths, no MCP server additions, no cross-repo writes. The `Read` tool already governs all path reads under the project tree and the connected `ai-resources/` directory.
- No frontmatter mutations in any of the 6 edited files — verified by `diff` output: no diff hunks touch lines 1–4 of any file. Frontmatter contract (`friction-log: true`, `model: sonnet`) preserved per plan-time Mitigation (diff-and-patch shape).

### Dimension 3: Blast Radius
**Risk:** Medium

- **6 file edits across 2 repos** (3 commands × 2 repos): project `.claude/commands/` and canonical `ai-resources/workflows/research-workflow/.claude/commands/`. Scope drop from 9 planned pairs to 7 narrows the blast radius further.
- **Project ↔ canonical mirror verified.** For all three command files, the FX-C1 wiring hunks at Steps 2.1, 2.3, Step 2 (run-cluster), and Steps 4.2 a/b/c are character-identical between project and canonical copies. Diffs returned `differ` on all three pairs, but inspection shows the divergence is entirely PRE-EXISTING drift unrelated to FX-C1: canonical includes the four-pass-model anchor (`run-execution.md` line 9), the Pass 3 sufficiency-gate reference (`run-cluster.md` lines 7–8), and the chapter-revision-applier two-end string-literal contract (`run-report.md` lines 64–105). The FX-C1 wiring lines themselves match between repos verbatim — plan-time Mitigation 1 (project-first sync) satisfied.
- **Scope dropped pairs (system-owner observation):** plan-time scope was 9 pairs; end-time landed 7. Dropped: `analysis-pass-memo-review` and `chapter-review`. Skill grep evidence: `analysis-pass-memo-review` is named in `evidence-to-report-writer/SKILL.md` and does not appear in any wired Step 4 subagent; `chapter-review` skill exists at `ai-resources/skills/chapter-review/SKILL.md` but no command in the edited set invokes it. Scope reduction is conservative — narrows blast radius without losing the named-blocker closure (B-02, B-17, B-18).
- **Subagent invocation contract changed at 7 sites.** Skills already accept these inputs per plan-time evidence; `report-compliance-qc/SKILL.md` is the one exception worth naming under Dim 5 (input declaration says "Content is passed directly (not file paths)" — see Dim 5 finding).
- **No CLAUDE.md content touched, no shared hooks touched, no Stage 5 polish commands touched.**
- Net assessment: down from plan-time High to Medium. Project-first sequencing + diff-and-patch + frontmatter-untouched + mirror-verified all check out.

### Dimension 4: Reversibility
**Risk:** Medium

- The 6 file edits are clean body-only edits; `git revert` on the two repos' respective commits restores prior state cleanly.
- Two repos × paired commits: plan-time Mitigation 4 (shared FX-C1 token + partner commit hash in both messages) is PENDING — `grep -r "FX-C1"` across `ai-resources/` outside `audits/` returns no hits. The pre-commit gate runs BEFORE commit per design, so this is the expected state. The mitigation must be applied at commit time, not before.
- No external state propagation (no push, no Notion write, no API POST).
- No append-only log mutation by the wiring change itself (logs may receive entries during the session, but they are separate from FX-C1's structural edits).
- No hook automation fires between edit and hypothetical revert. Operator muscle memory unaffected — `/run-execution`, `/run-cluster`, `/run-report` are invoked the same way.
- Net assessment: Medium pending commit-pairing mitigation. Drops to Low once paired commits with shared FX-C1 token land.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **NEW RISK — Step 4.0 categorical rule silently violated.** `run-report.md` line 22 carries the categorical statement: "These inputs are referenced throughout the pipeline. Sub-agents receive content, not file paths (per context isolation rules)." Step 4.2 a/b/c now pass reference-doc PATHS to subagents (lines 56, 59, 62). The in-step carve-outs are bold-marked with rationale ("path-passing per per-chapter token economy"), but Step 4.0 is NOT amended to acknowledge the exception. A reader of Step 4.0 alone gets a categorical rule that is then silently broken downstream. This is a documentation drift between Step 4.0 and Step 4.2, not a runtime defect — but it is exactly the type of hidden coupling the dimension exists to catch.
- **NEW RISK — `report-compliance-qc` skill input contract divergence.** `report-compliance-qc/SKILL.md` line 23 declares: "All required unless noted. **Content is passed directly (not file paths).**" The FX-C1 edit at `run-report.md` line 62 passes `reference/quality-standards.md` as a PATH to this skill. The skill's input list (items 1–6) does not enumerate the new reference doc, and the path-passing convention contradicts the skill's own stated input-passing rule. Runtime behavior may still work if the subagent's general-purpose Read tool is granted — but the skill's documented contract no longer matches what the command sends. Skill file was NOT modified per scope ("No skill files modified") so this divergence is unresolved.
- **Template-vs-project two-end contract documented in plan-time Architectural Commentary (Missed Risk #1) — STILL UNDOCUMENTED at the workflow-template surface.** The 6 file edits do not add a template-level contract doc; per CHANGE_DESCRIPTION, "the new two-end string contract (workflow template → project reference filenames) is implicit, not documented" — system-owner advisory deferred this per Option B. The implicit contract is: every research-workflow project must have `reference/source-class-hierarchy.md`, `reference/quality-standards.md`, `reference/known-limits.md`, `reference/style-guide.md` at exactly those paths. The next project deployed from this template will halt at `/run-execution` Step 2.1 (`research-prompt-creator` halt-if-absent semantics per its Input Requirements #4) if `reference/source-class-hierarchy.md` is missing. This is a known deferred risk, not a new finding — but it is the dominant Dim 5 concern for the canonical template.
- **`run-cluster.md` Step 2 combined subagent.** Step 2 (project line 23) launches a single subagent that runs BOTH `cluster-analysis-pass` AND `cluster-memo-refiner` sequentially in the same context. This is pre-existing structure, not introduced by FX-C1 — but the FX-C1 reference-doc payload (three reference docs) flows to this single combined subagent regardless of whether cluster-memo-refiner actually consumes all three. This is benign for now (subagent simply has more context than the refiner needs), but it creates a coupling where any future split of the two skills would need to re-allocate reference docs between them.
- No functional overlap with existing mechanisms — the wiring is additive.
- No silent auto-firing — the change only takes effect during operator-invoked pipeline commands.

## Mitigations

- **Dimension 5 (Hidden Coupling) — Step 4.0 categorical rule:** Either amend `run-report.md` line 22 to say "Sub-agents receive content, not file paths, EXCEPT where Step 4.2 explicitly carves out path-passing for project reference docs per per-chapter token economy" — OR add a one-line forward reference at line 22 ("Note: Step 4.2 path-passes select project reference docs — see in-step carve-outs"). Either form removes the silent contradiction. Apply to both project and canonical copies in the same FX-C1 commit pair.
- **Dimension 5 (Hidden Coupling) — `report-compliance-qc` skill input contract:** Either (a) edit `report-compliance-qc/SKILL.md` line 23 to acknowledge the exception ("Content is passed directly except for project reference docs, which are passed as absolute file paths per the command-level path-passing convention"); OR (b) defer to a follow-on patch and log the divergence in `logs/decisions.md` as a known skill-contract drift item. Option (a) closes the contract cleanly; option (b) accepts the drift but makes it visible. Note: the original CHANGE_DESCRIPTION says "No skill files modified" — so applying (a) widens scope. If scope-widening is unacceptable, apply (b) and schedule the skill edit as a separate small fix.
- **Dimension 4 (Reversibility) — paired-commit token:** At commit time, stage and commit the project files first with message containing the shared `FX-C1` token and the body line `Partner commit: <hash-to-be-filled>` (placeholder). Stage and commit the canonical files next with the same `FX-C1` token and `Partner commit: <project-commit-hash>` in the body. Then amend the project commit's body to fill the canonical hash via `git commit --amend` (allowed for an unpushed local commit — not the pushed-amend anti-pattern). Both repos' `git log --grep=FX-C1` then surface the pair.
- **Dimension 5 (Hidden Coupling) — template-level contract doc:** This is a KNOWN DEFERRED item per Option B at plan-time. Re-confirm the operator decision to defer at commit time; if deferring, log `FX-C1-followon: template-level contract doc for required reference filenames` in `logs/decisions.md` or the equivalent so the follow-on is not forgotten.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: full reads of all 6 edited command files (project + canonical for `run-execution.md`, `run-cluster.md`, `run-report.md`), three skill files (`evidence-to-report-writer/SKILL.md` lines 1–50 + 287, `chapter-prose-reviewer/SKILL.md` lines 1–60, `report-compliance-qc/SKILL.md` lines 1–50), the plan-time risk-check audit file, the WU2 plan section, `diff` output for all three project↔canonical pairs (showing pre-existing drift but FX-C1 hunks identical), `wc -l` line counts for the four reference docs (302 + 151 + 103 + 114 = 670 total lines), and `grep` for FX-C1 token presence across `ai-resources/` (none outside audit dir, confirming commit-pairing pending). No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked because the verdict is PROCEED-WITH-CAUTION._

**Status: exited at Step 0 (read-first gate).** The plan-time `/consult` already covered the architectural surface for FX-C1 (deployment-model mismatch, two-end contract, frontmatter conflict, `/sync-workflow` mechanism). The end-time findings are documentation-reconciliation level, not architectural. Read-first verification confirmed:

- `report-compliance-qc/SKILL.md` line 23 carries a clear categorical "Content is passed directly (not file paths)" statement — the contradiction with new path-passing is unambiguous and scoped.
- `evidence-to-report-writer/SKILL.md` and `chapter-prose-reviewer/SKILL.md` do NOT carry the same categorical rule, so the contradiction is scoped to one skill file.
- The choice between Mitigation 2 alternatives (skill-edit vs drift-log) is a judgment call, not an ambiguity — Decision-Point Posture applies.

**Decision applied:** Mitigation 2 option A (skill edit). Reasoning: smaller documentation debt over time; skill prose becomes honest; 1-line change with a single new input row added. Trade-off accepted: marginal scope expansion beyond plan-time "no skill files modified" boundary, but the boundary was a default assumption not a hard constraint, and the path-passing decision (which created the contradiction) was itself a system-owner reshape from plan-time advisory.

The plan-time `/consult` output already on disk at `2026-05-27-fx-c1-reference-doc-wiring-batch-recommended-scope.md` § Architectural Commentary remains authoritative for the architectural surface. This end-time gate does not re-litigate that ground.
