# Risk Check — 2026-07-13

## Change

BATCHED plan-time gate for the lean-repo Tier-1 execution set (session S8, plan: logs/session-plan-2026-07-13-S8.md). Six changes, evaluated as one batch per repo-architecture.md § Q5 two-gate model — do NOT re-fire per item.

CHANGE 1 — Remove 6 zero-use commands (class: removed command). Operator answered the I-1…I-7 questions: REMOVE promote-workflow (286 L), list-critical-resources (187 L), explore-section (156 L), project-next-steps (123 L), post-project-review (86 L), project-consultant (86 L). KEEP /tech-consult (operator intends to use it). Each canonical file lives at ai-resources/.claude/commands/<name>.md. BLAST RADIUS THE PLAN UNDERSTATED: each has 13–22 symlinks fanned out across projects (promote-workflow 13, list-critical-resources 15, explore-section 7, project-next-steps 15, post-project-review 15, project-consultant 22 — ~97 symlinks total). Deleting the canonical leaves every one of them broken. Also note /project-consultant has a workspace-root copy at ./.claude/commands/project-consultant.md.

CHANGE 2 (R-1) — Delete .claude/hooks/backup-session-plan.sh (class: hook edit). Operator chose delete over wire. It is registered in ZERO settings layers workspace-wide despite its own header claiming it is wired via a PreToolUse Write matcher. Copies exist in several projects' .claude/hooks/ and in the new untracked .codex/hooks/.

CHANGE 3 (R-2) — Delete the canonical ai-resources/.claude/agents/execution-agent.md + its agent-tier-table.md row (42 → 41). CORRECTION TO THE PLAN, VERIFIED THIS SESSION: the plan says "no command or hook spawns it." That is true of the CANONICAL file only. A SEPARATE real file — ai-resources/workflows/research-workflow/.claude/agents/execution-agent.md — IS spawned by workflows/research-workflow/.claude/commands/verify-chapter.md:40 ("Delegate to execution-agent"). The tier table has THREE execution-agent rows: line 23 (canonical, the one to remove), line 68 (workflow copy — STAYS, it is live), line 89 (archived project — stays as historical record). Also ~26 symlinks across projects point at the canonical and will break. The plan flags agent-removal as a DOCTRINE GAP: agents are absent from the six enumerated /risk-check change classes.

CHANGE 4 (M-1) — Fold /lean-repo's three questions (Q1 control-proportionality, Q2 retroactive rule-#7 scoring, Q3 orphan/adoption grep) into /architecture-review, AND wire /architecture-review into /friday-checkup's quarterly tier (class: edit to existing command ×2). Load-bearing: /architecture-review has NEVER RUN and has no invocation path — merging without wiring yields a bigger orphan.

CHANGE 5 (R-3) — Delete .claude/commands/lean-repo.md + .claude/agents/lean-repo-auditor.md (class: removed command). STRICTLY AFTER M-1 verifies, or the lens dies with the component. Requires reconciling agent-tier-table.md (41 → 40) and the EXCLUDE_COMMANDS entry at auto-sync-shared.sh:46. CONSTRAINT: both EXCLUDE_* lists must remain static, single-line, start-of-line literal assignments — /fix-symlinks re-reads them with sed; a reflowed value parses to empty and silently disables its drift scan. lean-repo-auditor is NOT in EXCLUDE_AGENT_GLOBS, so it HAS fanned out (~10 project symlinks).

CHANGE 6 — Update audits/lean-repo-2026-07-13.md item statuses (class: none; doc edit).

EXPLICITLY NOT IN THIS BATCH: MC-1 (risk-tiering the six change classes) is DEFERRED this session per the SO advisory at projects/axcion-ai-system-owner/output/consultations/consult-2026-07-13-lean-repo-gaps.md — unresolved conflict with the No-self-waivers clause + wrong venue. D-1 and S-1 (workspace CLAUDE.md edits) are QC-reachability-gated and deferred to a later step; judge them only if trivially in scope.

CONTEXT: a concurrent live session holds the git worktree ai-resources-research-workflow (branch session/2026-07-13-research-workflow), which carries its own real-file copies of all six commands. Deleting on main does not touch that branch; the merge resolves it.

## Referenced files

- ai-resources/logs/session-plan-2026-07-13-S8.md — exists
- ai-resources/audits/lean-repo-2026-07-13.md — exists
- ai-resources/.claude/commands/promote-workflow.md — exists
- ai-resources/.claude/commands/list-critical-resources.md — exists
- ai-resources/.claude/commands/explore-section.md — exists
- ai-resources/.claude/commands/project-next-steps.md — exists
- ai-resources/.claude/commands/post-project-review.md — exists
- ai-resources/.claude/commands/project-consultant.md — exists
- ai-resources/.claude/hooks/backup-session-plan.sh — exists
- ai-resources/.claude/agents/execution-agent.md — exists
- ai-resources/workflows/research-workflow/.claude/agents/execution-agent.md — exists
- ai-resources/workflows/research-workflow/.claude/commands/verify-chapter.md — exists
- ai-resources/.claude/commands/architecture-review.md — exists
- ai-resources/.claude/commands/friday-checkup.md — exists
- ai-resources/.claude/commands/lean-repo.md — exists
- ai-resources/.claude/agents/lean-repo-auditor.md — exists
- ai-resources/.claude/hooks/auto-sync-shared.sh — exists
- ai-resources/docs/agent-tier-table.md — exists
- ai-resources/.claude/commands/fix-symlinks.md — exists
- ai-resources/docs/audit-discipline.md — exists
- ai-resources/docs/repo-architecture.md — exists

## Verdict

**RECONSIDER**

**Summary:** Three of six dimensions are High on direct evidence — a ~114-consumer blast radius spread across ~20 separate project repos, a reversibility gap in the auto-sync hook's own logic (broken symlinks are never self-healed, even after a `git revert` of the canonical deletion), and a hidden-coupling finding that invalidates the stated basis for one of the six removal decisions (`explore-section` is not zero-use — it is the primary, heavily-used command in the live `axcion-design-studio` project via an independent, undiscovered project-local copy) — so per the two-or-more-High rule this batch is not clearable by pairing mitigations; it needs rescoping.

## Consumer Inventory

Grepped from `ai-resources/` and the workspace root (`grep -rniI --exclude-dir=.git`) plus `find`-based symlink enumeration under `projects/`. Given the scale (~114 consumers), rows below are grouped by consumer class with counts; the full per-project symlink lists were captured during the scan and are reproducible from the same commands.

| Consumer path (class) | Reference type | Count | Must change? |
|---|---|---|---|
| `projects/*/.claude/commands/promote-workflow.md` (symlinks) | invokes (via symlink) | 13 | Yes — breaks, needs manual `rm` |
| `projects/*/.claude/commands/list-critical-resources.md` (symlinks) | invokes (via symlink) | 14 | Yes |
| `projects/*/.claude/commands/explore-section.md` (symlinks) | invokes (via symlink) | 7 | Yes |
| `projects/*/.claude/commands/project-next-steps.md` (symlinks) | invokes (via symlink) | 14 | Yes |
| `projects/*/.claude/commands/post-project-review.md` (symlinks) | invokes (via symlink) | 14 | Yes |
| `projects/*/.claude/commands/project-consultant.md` (symlinks, incl. workspace-root copy) | invokes (via symlink) | 20 | Yes |
| `projects/*/.claude/agents/execution-agent.md` (symlinks to canonical) | invokes (via symlink) | 17 | Yes — breaks, needs manual `rm` |
| `.../research-workflow/.claude/commands/verify-chapter.md` (canonical + 2 deployed project copies) | invokes (`Delegate to execution-agent`, resolves to the **workflow's own copy**, unaffected by R-2) | 3 | No |
| `projects/{buy-side-service-plan,research-pe-regime-shift-advisory-gap,positioning-research}/.claude/agents/execution-agent.md` (regular-file, workflow-deployed) | co-edits-independent (not the canonical file; untouched by R-2) | 3 | No |
| `projects/*/.claude/agents/lean-repo-auditor.md` (symlinks) | invokes (via symlink) | 8 | Yes — breaks, needs manual `rm` |
| `projects/*/.claude/commands/lean-repo.md` | n/a | 0 | — (already excluded from auto-sync via `EXCLUDE_COMMANDS`; never fanned out) |
| `ai-resources/.claude/hooks/auto-sync-shared.sh` (EXCLUDE_COMMANDS line) | co-edits | 1 | Yes (R-3) — **format-contract risk, see D5** |
| `ai-resources/.claude/commands/fix-symlinks.md` | parses (`sed`-extracts `EXCLUDE_COMMANDS`/`EXCLUDE_AGENT_GLOBS` from the hook) | 1 | No — but silently degrades if R-3's edit reflows the line |
| `ai-resources/docs/agent-tier-table.md` (3 execution-agent rows, 1 lean-repo-auditor row) | co-edits | 1 | Yes (R-2 removes 1 row, R-3 removes 1 row) |
| `ai-resources/.claude/commands/friday-checkup.md` | co-edits (M-1 wiring target) | 1 | Yes |
| `ai-resources/.claude/commands/architecture-review.md` | co-edits (M-1 merge target) | 1 | Yes |
| `ai-resources/audits/lean-repo-2026-07-13.md` | co-edits (CHANGE 6 target) | 1 | Yes |
| `projects/axcion-design-studio/.claude/commands/explore-section.md` (independent regular-file copy, byte-identical to canonical) | **undisclosed shadow consumer** — see D5/D3 finding below | 1 | No (independent file, unaffected by canonical deletion) — **but the removal decision's stated rationale is false; flagged for correction** |
| `archive/nordic-pe-macro-landscape-H1-2026/.claude/settings.json` (gitignored, retired project) | documents (stale `PreToolUse Write` registration of `backup-session-plan.sh`) | 1 | No — archived, not live; corrects the plan's "zero registrations workspace-wide" claim to "zero **live** registrations" |

**Total: ~114 consumers found, ~111 must-change** (the six commands' 82 symlinks + execution-agent's 17 symlinks + lean-repo-auditor's 8 symlinks + auto-sync-shared.sh + agent-tier-table.md + friday-checkup.md + architecture-review.md + lean-repo-2026-07-13.md). This is not an isolated change — it is a wide, multi-repo distribution event.

**Gap the audit's own grep missed:** `explore-section` was investigated (I-3) as "zero references AND zero logged invocations… already unreferenced and unused" (`audits/lean-repo-2026-07-13.md:129,137`). Direct evidence contradicts this: `projects/axcion-design-studio/.claude/commands/explore-section.md` is a **byte-identical, independent regular-file copy** (confirmed via `diff` — zero differences) that is referenced **43 times** in that project's own `logs/session-notes.md`, named repeatedly in its `CLAUDE.md` as the canonical escalation command ("`explore` = escalate to `/explore-section`"), and has its own dedicated 2026-07-05 risk-check report (`ai-resources-research-workflow/audits/risk-checks/2026-07-05-new-project-local-slash-command-for-the-axcion-design-studio.md`) that explicitly scoped it as **project-local, not a shared resource** ("a design-studio-specific workflow command correctly lives in the project's `.claude/commands/`, not the shared ai-resources library — it is not a cross-project resource"). The canonical `ai-resources/.claude/commands/explore-section.md` copy this batch proposes deleting is an **erroneous duplicate** that leaked a project-local command into 7 unrelated projects via auto-sync (buy-side-service-plan, project-planning, management-os, strategic-os, axcion-systems-builder, axcion-copy-factory, axcion-ai-system-redesign) — none of which have any Design Studio use for it. The lean-repo audit's reference-grep evidently scanned `ai-resources/` (where the command genuinely is unused) and never checked the project's own logs, so it reported a false "zero use" signal for a command that is, in its real home, the single most load-bearing command in an active project.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- CHANGE 1, 2, 3, 5 are all removals — they reduce standing cost, not add it.
- CHANGE 4 (M-1) adds content to `architecture-review.md`, a pay-as-used opus command invoked on demand, not standing/always-loaded — no per-turn cost.
- Wiring `/architecture-review` into `/friday-checkup`'s **quarterly** tier (`friday-checkup.md` Step 2/5) adds one additional sub-invocation, but only once per quarter — bounded, infrequent, consistent with the existing quarterly-tier pattern (`/repo-dd deep`, `/analyze-workflow` already listed as quarterly follow-ups).
- No always-loaded CLAUDE.md edits are in this batch (D-1/S-1 are explicitly deferred per the change description).
- CHANGE 6 is a doc-status edit with zero runtime cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` entries are added, widened, or removed anywhere in this batch.
- The `auto-sync-shared.sh:EXCLUDE_COMMANDS` edit (R-3) removes "lean-repo" from a **distribution exclusion list**, not a permission grant — and since `lean-repo.md` is deleted in the same change, there is nothing left to sync even if the exclusion were absent.
- Hook deletion (R-1) and agent deletion (R-2) remove capability, they do not grant it.

### Dimension 3: Blast Radius
**Risk:** High

- Per the Consumer Inventory: **~114 consumers, ~111 must-change** — far above the `>5 dependent callers` High threshold.
- ~82 symlinks across the six command removals, ~17 symlinks on the `execution-agent` canonical removal, ~8 symlinks on `lean-repo-auditor` — all become **broken symlinks the moment the canonical files are deleted**, spread across ~20 separate project git repos (`projects/buy-side-service-plan`, `management-os`, `marketing-positioning`, `project-planning`, `axcion-website`, `nordic-pe-screening-project`, `axcion-brand-book`, `axcion-copy-factory`, `axcion-systems-builder`, `axcion-ai-system-redesign`, `repo-documentation`, `strategic-os`, `research-pe-regime-shift-advisory-gap`, `positioning-research`, `axcion-design-studio`, `corporate-identity`, `interpersonal-communication`, `obsidian-pe-kb`, `axcion-ai-system-owner`, `global-macro-analysis`, plus a `strategic-os/.backup-untracked/` copy). This confirms and slightly exceeds the plan's own "the plan understated" flag (plan cited ~97 + ~26 + ~10 ≈ 133; verified counts here total ~107 symlinks + 4 shared-infra co-edits).
- Shared infrastructure is directly touched: `auto-sync-shared.sh` (the workspace's Tier-1 SessionStart distribution hook, per `docs/agent-tier-table.md`/`risk-topology.md` framing) and `docs/agent-tier-table.md` (a cross-cutting registry) both need coordinated edits in the same session as the deletions they reconcile.
- `/fix-symlinks` cannot auto-repair any of the ~107 broken symlinks once the canonical source is deleted — its own logic (`fix-symlinks.md` Step 3) only auto-fixes when exactly one basename match exists elsewhere in `ai-resources/`; with zero matches (source deleted) every one of these lands in the "MANUAL RESOLUTION NEEDED — zero matches" bucket, requiring a hand `rm` per symlink, per project.
- The `explore-section` shadow-consumer finding above is itself a blast-radius gap: the plan's own audit undercounted the real consumer set for one of the six items.

### Dimension 4: Reversibility
**Risk:** High

- A `git revert` in `ai-resources/` restores the six commands, the two agents, and the two edited docs/commands — but **does not touch the ~107 broken symlinks that will exist in ~20 separate project repos** by that point, because those are separate git repositories.
- Critically, `auto-sync-shared.sh`'s own sync loop **does not self-heal a broken symlink**: `[ -e "$target" ] || [ -L "$target" ] && continue` (lines 109, 126) treats an existing **broken** symlink (`-L` true) exactly like a healthy one and skips it — the hook will never recreate it, even after the canonical file is restored by a revert, unless the broken symlink is first manually `rm`'d.
- This means full rollback requires: (1) `git revert` in `ai-resources/`, (2) a hand `rm` of each of the ~107 broken symlinks across ~20 project repos (since they will not have been auto-removed either — they were never removed by this change, they were left broken and orphaned), (3) a subsequent session start per project to let `auto-sync-shared.sh` recreate them. That is a genuine multi-step, multi-repo manual rollback — the High bar ("multi-step manual rollback required") is met directly from the hook's own documented behavior, not speculation.
- `docs/agent-tier-table.md` and `auto-sync-shared.sh` edits revert cleanly in isolation (single-file, git-tracked), but they are meaningless to revert without also addressing the orphaned symlinks above.

### Dimension 5: Hidden Coupling
**Risk:** High

- **`explore-section` shadow consumer (primary driver).** As detailed in the Consumer Inventory, the canonical copy proposed for deletion is a duplicate of a command whose real, load-bearing home is `projects/axcion-design-studio/.claude/commands/explore-section.md` — a fact invisible to a canonical-scope reference-grep and not surfaced anywhere in `audits/lean-repo-2026-07-13.md` or `logs/session-plan-2026-07-13-S8.md`. The operator's REMOVE decision for this item was made on the stated basis "already unreferenced and unused," which is false for the command's real, independent copy. The mechanical deletion is very likely still safe (the design-studio project does not consume the canonical copy), but the decision record needs correcting before this specific sub-item lands.
- **`auto-sync-shared.sh`'s format contract.** `EXCLUDE_COMMANDS`/`EXCLUDE_AGENT_GLOBS` must stay static, single-line, start-of-line literal assignments (documented in the hook's own header and in `repo-architecture.md § Symlink topology`) because `/fix-symlinks` re-reads them with a `sed` capture group that silently returns empty on any reflow — which **silently disables `/fix-symlinks`' entire drift-detection scan**, with no error surfaced. R-3 requires editing this exact line under this exact constraint in the same session as several other file deletions — an easy place for an incidental reformat to introduce a silent regression.
- **Stale line-number citation.** Both `logs/session-plan-2026-07-13-S8.md` (Source Material list, and Execution Sequence step 7) and this change description cite "`auto-sync-shared.sh:46`" for the `EXCLUDE_COMMANDS` line; the file as read this session has it at **line 67** (`EXCLUDE_AGENT_GLOBS` at line 68). Minor on its own, but combined with the format-contract fragility above, it means the exact edit location must be re-verified at execution time rather than trusted from the plan.

### Dimension 6: Principle Alignment
**Risk:** Low

Principles-base read from `projects/strategic-os/ai-strategy/principles-base.md` (present; used directly — no inline-check fallback needed).

- **OP-12 (closure before detection) — served, not violated.** R-2 closes an orphan `/repo-dd` flagged 66 days ago (2026-05-08) and never closed — a direct instance of the repo closing a detection rather than letting it rot. M-1 closes the O-2 finding ("`/architecture-review` has never run") by giving it an actual invocation path. Both are closure work, the behavior OP-12 asks for.
- **DR-7 / OP-9 / AP-7 (speculative abstraction / complexity budget) — clears.** No net-new components are created. M-1 nets **−1 command, −1 agent** while preserving and increasing the leanness lens's reach (`lean-repo.md`'s own text: "Clears prong (a) — net −1 command, −1 agent, capability preserved and increased"). `/lean-repo` itself shipped under a loudly-recorded OP-11 exception that named its own retirement condition ("if a future review finds the lens is used rarely, the lean move is to fold it into `/architecture-review` and retire this command") — M-1+R-3 is that condition firing as designed, not a new violation.
- **DR-1 / DR-3 (placement) — this batch incidentally *fixes* a live violation.** The `explore-section` canonical duplicate (see D5) is itself a DR-1/DR-3 leak — a project-local, non-reusable command sitting in the shared canonical library and auto-syncing to unrelated projects. Deleting the canonical copy removes that leak. This does not offset the D5/D3 findings above (the decision basis is still wrong and needs correction), but the *action*, once correctly understood, aligns with placement doctrine rather than against it.
- **Doctrine gap on R-2 (agent removal not in the six `/risk-check` classes) — loudly named, not silently assumed.** The plan explicitly flags this as a gap rather than assuming coverage ("Flagging this as a doctrine gap rather than assuming coverage"). That is the OP-11/OP-3 "loud, not silent" posture working correctly — a process debt item, not a principle violation.
- No enforcement-upgrade (OP-5), no system-boundary expansion (OP-10), and no automated judgment-gating regression (OP-2) are present anywhere in this batch.

## Recommended redesign

This is a **technical-High** pattern (D3/D4/D5), not a principle-violation High — the fix is rescoping and adding an explicit cleanup step, not a loud-revision note.

- **Split the batch.** Land the confirmed-clean items first: CHANGE 2 (`backup-session-plan.sh` delete — zero live registrations confirmed across every non-archived `settings*.json` in the workspace), the five command removals with no shadow-consumer finding (`promote-workflow`, `list-critical-resources`, `project-next-steps`, `post-project-review`, `project-consultant` — verified: none has a regular-file project-local copy anywhere under `projects/`), and CHANGE 6 (doc-status edit). Hold `explore-section`, CHANGE 3 (`execution-agent`), and CHANGE 5 (`lean-repo`/`lean-repo-auditor`, already gated behind M-1) for a second, smaller pass once the two items below are resolved.
- **Add an explicit symlink-cleanup sub-step to the execution sequence**, not an implied side effect: after each canonical deletion, run `/fix-symlinks` (dry-run first) to enumerate the resulting broken links, then `rm` each one per project — do not rely on `auto-sync-shared.sh`'s SessionStart hook, which does not remove or heal broken symlinks (confirmed from its own guard logic). This closes the D3/D4 findings.
- **Re-verify the `explore-section` decision with the operator on corrected information** before deleting the canonical copy: it is not zero-use; it is the primary command in the live `axcion-design-studio` project via an independent copy the audit's grep never saw. The likely-correct action (delete only the canonical duplicate, leave the project's own copy untouched) is probably unchanged — but it should be re-confirmed as "delete the erroneous canonical duplicate" rather than executed on the audit's stated ("unreferenced and unused") rationale, and `audits/lean-repo-2026-07-13.md`'s I-3 entry should be corrected in the same pass CHANGE 6 already touches that file.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file reads of every referenced command/agent/hook/doc, `find`/`grep` symlink and reference counts across `ai-resources/` and `projects/`, a byte-level `diff` confirming the `explore-section` duplicate, direct reads of `auto-sync-shared.sh`'s sync-loop guard logic, and `projects/strategic-os/ai-strategy/principles-base.md` for Dimension 6. No training-data fallback was used on any read or grep.
