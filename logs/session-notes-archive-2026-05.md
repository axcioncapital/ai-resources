# Session Notes — Archive 2026-05

## 2026-05-01 — /friday-act monthly — tactical + policy review

### Summary
Executed /friday-act (monthly tier) against the 2026-05-01 friday-checkup report. 3 of 14 tactical items resolved: H1 session reminder scheduled as a remote routine (fires 2026-05-08), permission-sweep CRITICAL logged as a confirmed false positive vs bypass-mode design, research-extract-verifier frontmatter confirmed pre-existing and correct. Session discovered 4 auditor false positives across the tactical list — none of those items required file changes. Two policy proposals captured in maintenance-observations.md. Pre-migration usage/usage-log.md deleted per explicit operator approval.

### Files Created
- `audits/risk-checks/2026-05-01-resolve-the-workspace-root-placeholder-in-workflows-research.md` — RECONSIDER verdict report for {{WORKSPACE_ROOT}} placeholder; confirms file is intentional deploy-time template

### Files Modified
- `logs/maintenance-observations.md` — first /friday-act session block appended (monthly tier; 3 fix-now, 7 defer, 4 skip; 2 rule-change proposals)

### Files Deleted
- `usage/usage-log.md` — 227-line pre-migration artifact; canonical usage log is at `logs/usage-log.md`

### Decisions Made
- **{{WORKSPACE_ROOT}} placeholder is intentional:** Do NOT edit workflows/research-workflow/.claude/settings.json. RECONSIDER verdict from risk-check confirmed the file is a deploy-time template; prior 2026-04-27 risk-check approved introducing the placeholder. Fix is at the auditor rule level (template-class exception for `workflows/*/.claude/`).
- **Permission-sweep CRITICAL is a false positive:** "Missing allow entries" finding does not apply under `defaultMode: bypassPermissions`. No settings.json edit required. Fix is at the auditor rule level (Rule 4 exception for files with bypassPermissions).
- **Read(audits/**) + Read(reports/**) deferred:** Token-audit M1 recommendation would add these to the deny list, breaking /friday-act, /risk-check, /token-audit workflows that actively read those directories. Right fix is more nuanced (e.g., `Read(audits/working/**)` only). Not a quick win.
- **research-extract-verifier:** opus/high frontmatter already present at lines 22-23 (after multi-line description block). Audit-repo finding was a false positive — auditor parser misses fields after multi-line descriptions.
- **usage/usage-log.md deleted:** Pre-migration artifact; operator explicitly approved deletion.

### Next Steps
- Push commits
- Run /cleanup-worktree — working tree still has untracked prior-session risk-check reports and the modified clarify.md
- Approve orphan skill moves: `fund-triage-scanner` and `prose-refinement-writer` → `skills/deprecated/` (operator denied git mv during session; needs explicit re-approval)
- Schedule follow-up session for 2 policy proposals in maintenance-observations.md: (1) auditor template-class exception for `workflows/*/.claude/`, (2) decisions-log nudge hook

### Open Questions
- Permission-sweep CRITICAL: confirmed false positive (resolved from prior session open question)
- Friction-log dormant since 2026-04-18: still no new entries at this wrap — pattern continues; not yet actionable

## 2026-05-01 — friday-act: W2.1 + W2.3 registry fixes

### Summary
Session 2 of the Friday cadence (monthly tier). Started from the 2026-05-01 checkup report. Verified all open W2.1 doc-scan and W2.3 kb-integrity findings were still unresolved, then developed a fix plan and executed it. All tracked registry edits committed in one batch. W2.2 deferred (project on hold). Policy proposals captured in maintenance-observations.md will be run manually next week.

### Files Created
- None

### Files Modified
- `projects/repo-documentation/output/phase-1/components/agents.md` — 4 new agents added; pipeline-stage-2 and pipeline-stage-2-5 marked deprecated; repo-health-analyzer model corrected sonnet→opus
- `projects/repo-documentation/output/phase-1/components/commands.md` — innovation-sweep entry added
- `projects/repo-documentation/output/phase-1/components/claude-md-files.md` — vault CLAUDE.md entry added
- `projects/repo-documentation/vault/components/agents.md` — same fixes (gitignored, disk-only)
- `projects/repo-documentation/vault/components/commands.md` — innovation-sweep added (gitignored, disk-only)
- `projects/repo-documentation/vault/components/claude-md-files.md` — vault CLAUDE.md added (gitignored, disk-only)
- `projects/repo-documentation/vault/components/_index.md` — counts updated: hooks 14→16, agents 33→37, commands 47→48, claude-md files 13→14 (gitignored, disk-only)
- `projects/repo-documentation/vault/_master-index.md` — links added for architecture/repo-state.md and architecture/risk-topology.md (gitignored, disk-only)

### Decisions Made
- **W2.2 deferred:** H1 title bulk fix (33 commands) and nordic-pe shared-manifest.json deferred — project on hold per operator
- **Policy proposals manual:** Opted to run the 3 policy-proposal drafting + /risk-check passes in a local session next week rather than as a scheduled remote routine; proposals captured in maintenance-observations.md 2026-05-01 block
- **Vault gitignore:** vault/components/ and vault/_master-index.md are gitignored by design (Obsidian sync); vault edits are disk-only, no commit needed
- **session-guide.md no action:** Confirmed as symlink to canonical command — no new registry entry needed

### Next Steps
- Push commit `61afeda`
- Next week: open a local session to draft + /risk-check the 3 policy proposals in `ai-resources/logs/maintenance-observations.md` (2026-05-01 block)
- Remaining tactical defers still logged in maintenance-observations.md 2026-05-01 block

### Open Questions
- None

## 2026-05-02 — Claude Code improvement plan — evaluate suggestions + execute top 3

### Summary
Evaluated an external Claude Code suggestion document against the current stack and produced a prioritized implementation plan. Most suggestions were already in place; three actionable items were identified and executed: adding DISABLE_NON_ESSENTIAL_MODEL_CALLS=1 to global settings, culling MCP servers from 16 to 1 (github only), and aligning MAX_THINKING_TOKENS at workspace root. Session also included a /resolve-improvement-log pass confirming no resolved entries to archive.

### Files Created
- `audits/improvement-plan-claude-code-2026-05-01.md` — prioritized implementation plan (High/Medium/Skip tiers) for Claude Code improvements derived from external suggestion document

### Files Modified
- `~/.claude/settings.json` — added DISABLE_NON_ESSENTIAL_MODEL_CALLS=1 to env block (outside git repo)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.json` — added MAX_THINKING_TOKENS=10000 env block (outside git repo)
- 15 MCP plugin `.mcp.json` files renamed to `.mcp.json.disabled` under `~/.claude/plugins/marketplaces/claude-plugins-official/external_plugins/` — disabled all plugins except github (outside git repo)

### Decisions Made
- **MCP servers — keep only github:** of 16 installed plugins, operator confirmed only github is used in Axcion sessions. 15 others disabled via .mcp.json.disabled (reversible).
- **DISABLE_NON_ESSENTIAL_MODEL_CALLS:** applied as High ROI with [NEEDS VERIFICATION] flag — env var name unconfirmed; verify in next session by observing behavior.
- **MAX_THINKING_TOKENS workspace root:** aligned at 10,000 to match ai-resources default; operator confirmed intent by approving execution.
- **Improvement plan scope:** scoped to chat output initially, then upgraded to saved artifact at operator request.
- **QC/refinement fixes:** two full QC → triage → fix cycles plus one manual operator-approved fix pass on the plan artifact.

### Next Steps
- Restart Claude Code for env var and MCP changes to take effect
- Verify DISABLE_NON_ESSENTIAL_MODEL_CALLS took effect in first normal session (silent-fail mode — no error if var name unrecognized)
- Push commits
- Run /cleanup-worktree — untracked risk-check reports + modified clarify.md still pending from prior session
- Approve orphan skill moves: fund-triage-scanner and prose-refinement-writer → skills/deprecated/
- Dedicated session for H1: research-workflow prose-pipeline subagent return refactor (reminder scheduled 2026-05-08)
- 2 policy proposals pending in maintenance-observations.md: (1) auditor template-class exception, (2) decisions-log nudge hook

### Open Questions
- Does DISABLE_NON_ESSENTIAL_MODEL_CALLS actually suppress anything in this Claude Code version? Confirm in next session.

## 2026-05-02 — token-audit: extend Section 8 with context engineering principles

### Summary
Added 3 new best-practice items to token-audit Section 8 based on Anthropic's context engineering article. Items: inter-skill trigger disambiguation (13), structured agent/skill prompts using headers/XML (14), and few-shot examples where useful (15). Updated date label April → May 2026, extended report format exemplar table, bumped protocol to v1.3. Secondary edit: token-audit.md item count reference updated 12 → 15. No new commands, agents, or files created. friday-checkup automatically inherits the new checks via its monthly token-audit invocation.

### Files Modified
- `audits/token-audit-protocol.md` — v1.3: items 13–15 added to Section 8, date label updated, report format table extended, frontmatter versioned
- `.claude/commands/token-audit.md` — line 146: "12-item" → "15-item comparison"

### Decisions Made
- **Context engineering checks belong in token-audit Section 8, not friday-checkup:** token-audit already runs monthly via friday-checkup; extending Section 8 lets friday-checkup inherit the new checks automatically with no structural changes to either command
- **Item 13 narrowed to inter-skill overlap:** Section 2 already covers per-skill vagueness; new item adds the genuinely new inter-skill disambiguation dimension
- **Protocol versioned to v1.3:** content extension warrants version bump per protocol's self-versioning convention

### Next Steps
- Push commit `2082a0b`
- Run /cleanup-worktree — working tree still has untracked prior-session risk-check reports, clarify.md modified, and workflows/research-workflow/.claude/commands/session-plan.md

### Open Questions
- None

## 2026-05-02 — Research workflow improvements from Anthropic multi-agent article

### Summary
Read Anthropic's multi-agent research system engineering article and compared its design principles against the research workflow template. Identified three actionable gaps: no explicit broad-before-narrow query ordering, sequential cluster analysis (run-synthesis already had parallel), and no cross-project quality measurement. Planned, QC'd, and executed all three improvements.

### Files Created
- `workflows/research-workflow/logs/research-quality-log.md` — new cross-project extract quality log with header row and column definitions

### Files Modified
- `skills/supplementary-query-brief-drafter/SKILL.md` — added Pass 1 breadth principle (broad-before-narrow) and Pass 2 complementary narrowing rule
- `workflows/research-workflow/reference/stage-instructions.md` — breadth notes at Steps 2.S1 and 3.S1; quality log note at Step 2.4 gate; Steps 3.2–3.3 updated for parallel cluster analysis (removed per-cluster /compact, changed gate to per-section)
- `workflows/research-workflow/.claude/commands/run-cluster.md` — fully rewritten: processes all clusters in parallel via subagents, single operator gate replaces per-cluster gate
- `workflows/research-workflow/.claude/commands/run-execution.md` — Step 2.4 now appends a quality log row when all extracts are APPROVED

### Decisions Made
- **Gate granularity (Improvement 2):** Per-section gate chosen over per-cluster (operator confirmed). All refined cluster memos now reviewed together at the end of /run-cluster, matching run-synthesis behavior.
- **Quality log location (Improvement 3):** Local workflow log (`workflows/research-workflow/logs/`) chosen over ai-resources-level log. Avoids cross-repo write from project sessions; aggregation across projects is manual when needed.
- **QC → resolve cycle:** Plan went through full QC pass + resolve. Six findings addressed: current-state reframing (Improvement 1), cross-repo write policy (Improvement 3), gate granularity split-out, lightweight main-context delegation for parallel subagents, explicit /compact removal, and mutually-exclusive log schema.

### Next Steps
- `/sync-workflow` to propagate run-cluster.md and run-execution.md changes to any deployed research projects
- Push commit `d5f5e3c`
- Run `/cleanup-worktree` — untracked risk-check reports and modified clarify.md still in working tree from prior session

### Open Questions
- None

## 2026-05-02 — Token audit: ai-resources repo

### Summary
Ran full 11-section token-usage efficiency audit (`/token-audit ai-resources`) against the ai-resources repo. Audit is diagnostic-only; fixes happen in a separate session. Configuration baseline assessed as solid (MCP cull, bypassPermissions, Sonnet default, MAX_THINKING_TOKENS aligned). Main remaining waste is research-workflow execution discipline and cleanup-worktree/friday-cadence load patterns.

### Files Created
- `audits/token-audit-2026-05-02-ai-resources.md` — full audit report, Sections 0–10 (504 lines)
- `audits/working/audit-summary-workflow-friday-cadence.md` — gitignored working file (not committed)
- `audits/working/audit-working-notes-workflow-friday-cadence.md` — gitignored working file (not committed)

### Files Modified
- `audits/working/audit-working-notes-preflight.md`
- `audits/working/audit-summary-skills.md`
- `audits/working/audit-working-notes-skills.md`
- `audits/working/audit-summary-file-handling.md`
- `audits/working/audit-working-notes-file-handling.md`
- `audits/working/audit-summary-workflow-research-workflow.md`
- `audits/working/audit-working-notes-workflow-research-workflow.md`
- `audits/working/audit-summary-workflow-new-project.md`
- `audits/working/audit-working-notes-workflow-new-project.md`
- `audits/working/audit-summary-workflow-repo-dd.md`
- `audits/working/audit-working-notes-workflow-repo-dd.md`
- `audits/working/audit-summary-workflow-cleanup-worktree.md`
- `audits/working/audit-working-notes-workflow-cleanup-worktree.md`

### Decisions Made
- None (audit is diagnostic-only; findings drive a separate fix session)

### Next Steps
- Start a fix session for audit HIGH findings: H1 (research-workflow return caps), H2 (run-report.md 30k pre-load), H3 (CLAUDE.md @-imports), H4 (cleanup-worktree SKILL.md split), H5 (friday-cadence Step 7.16 load)
- Push commits d5f5e3c and c1de6a7
- Run `/cleanup-worktree` — untracked risk-check reports and modified clarify.md still in working tree

### Open Questions
- None

## 2026-05-02 — Token-audit fixes: M3, H3, H5, M2 (M1 reverted post-risk-check)

### Summary
Acted on five recommendations from the 2026-05-02 token-audit report. Initial commit 9992cf2 applied all five (M1, M3, H3, H5, M2). End-time `/risk-check` returned PROCEED-WITH-CAUTION and surfaced a load-bearing conflict in M1: the new `Read(audits/working/**)` deny rule would break `/innovation-sweep` Step 7.27 and `/audit-critical-resources` Step 26, both of which legitimately read working notes within the same session that produces them. M1 was reverted in a follow-up commit; the four other fixes stand. M3 adds ≤30-line return contracts to all five `/new-project` pipeline-stage agents. H3 removes unconditional `@`-imports from the research-workflow CLAUDE.md template, saving ~6,200 tokens per turn in deployed research projects. H5 creates a new `findings-extractor` haiku-tier subagent and delegates friday-checkup Step 7.16 bulk-read to it (~10,300 tokens per friday-checkup saved). M2 adds `/compact` breakpoints at natural tier boundaries in `/new-project`, `/repo-dd`, `/friday-checkup`, and `/friday-act`. Also diagnosed a transient permission prompt on `pipeline-stage-3c.md`; confirmed same isolated-transient pattern as 2026-04-28; no settings fix required.

### Files Created
- `.claude/agents/findings-extractor.md` — new haiku-tier subagent for /friday-checkup findings extraction; returns ≤30-line structured findings list (H5)
- `audits/risk-checks/2026-05-02-end-time-risk-check-on-token-audit-fix-set.md` — end-time risk-check report (PROCEED-WITH-CAUTION; M1 conflict surfaced)

### Files Modified
- `.claude/settings.json` — M1 attempted then reverted; net no change after risk-check feedback
- `.claude/agents/pipeline-stage-3a.md` — added return contract section (M3)
- `.claude/agents/pipeline-stage-3b.md` — added return contract section (M3)
- `.claude/agents/pipeline-stage-3c.md` — added return contract section (M3)
- `.claude/agents/pipeline-stage-4.md` — added return contract section (M3)
- `.claude/agents/pipeline-stage-5.md` — added return contract section (M3)
- `workflows/research-workflow/CLAUDE.md` — replaced 4 `@`-import directives with prose pointers (H3)
- `.claude/commands/friday-checkup.md` — delegated Step 7.16 to findings-extractor; added /compact breakpoint before /token-audit (H5 + M2)
- `.claude/commands/new-project.md` — added /compact suggestion at stage gate (M2)
- `.claude/commands/repo-dd.md` — added /compact at factual→deep and deep→full tier boundaries (M2)
- `.claude/commands/friday-act.md` — added /compact after tactical loop (M2)

### Decisions Made
- **M1 reverted (post-risk-check)** — the audit's premise that `audits/working/**` files were unconsumed intermediate artifacts was wrong; both `/innovation-sweep` and `/audit-critical-resources` consume them within the same session. Documented in decisions.md (2026-05-02). Right pattern if working/ ever needs exclusion in the future is H5-style subagent delegation, not a blanket deny rule.
- M3, H3, H5, M2 executed as specified by the token-audit report. No analytical decisions required — implementations followed directly from audit recommendations.

### Next Steps
- Push commits `9992cf2` (initial fixes) and the M1-revert wrap commit
- Consider deferred audit-discipline note: working notes consumed by their producing command should be flagged as load-bearing in token-audit Section 6 (not "stale intermediates")
- End-time risk-check run this session (new agent file created) — verdict in risk-check report
- Remaining token-audit HIGH findings deferred: H1 (research-workflow 44 launch-site return caps), H2 (run-report.md 30k pre-load refactor), H4 (cleanup-worktree SKILL.md split)
- Run `/sync-workflow` to propagate H3 changes to any deployed research projects (CLAUDE.md @-imports removed)
- Run `/cleanup-worktree` — untracked risk-check reports + modified clarify.md still in working tree from prior sessions
- Approve orphan skill moves: `fund-triage-scanner` and `prose-refinement-writer` → `skills/deprecated/`
- Dedicated session for H1: research-workflow prose-pipeline subagent return refactor (reminder scheduled 2026-05-08)

### Open Questions
- None
