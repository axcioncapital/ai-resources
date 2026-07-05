# Risk Check — 2026-07-05

## Change

Lean the two most-used advisory gates. Executed change set (end-time risk-check): (1) Retiered risk-check-reviewer (ai-resources/.claude/agents/risk-check-reviewer.md), the /risk-check orchestrator (ai-resources/.claude/commands/risk-check.md), and /blindspot-scan (ai-resources/.claude/commands/blindspot-scan.md) from model: opus to model: sonnet. (2) Changed /risk-check Step 4a so the System-Owner /consult second opinion is no longer auto-fired on non-GO verdicts — it is now an operator-invoked offer line surfaced in the Step 5 summary; no ## Architectural Commentary is auto-appended. (3) Updated the /risk-check project-session fallback (item 12a) to re-assert model: sonnet instead of opus. (4) Tightened the Blind-Spot Scan Gate trigger in workspace CLAUDE.md so /blindspot-scan fires only on /risk-check change classes, dropping the "or ≥3 files" branch. (5) Updated ai-resources/docs/agent-tier-table.md risk-check-reviewer row to sonnet with a dated OP-11 exception note. Rationale: these two gates were ~20% of weekly usage; Sonnet is the dominant cost lever, the auto-consult added a third Opus pass on non-GO cases, and the ≥3-files branch over-fired blindspot on ordinary edits. Operator authorized trading some safety for cost; Opus depth preserved via the operator-invoked /consult offer.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/risk-check-reviewer.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/risk-check.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/blindspot-scan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/agent-tier-table.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A genuinely cost-reducing lean-and-simplify change that is backward-compatible on every technical dimension, but the OP-11 "loud, recorded" loop is left open — the tier-table cites a `logs/decisions.md 2026-07-05` exception entry that does not exist on disk.

## Consumer Inventory

Search terms: `risk-check-reviewer`, `risk-check.md`/`/risk-check`, `blindspot-scan.md`/`/blindspot-scan`, `agent-tier-table.md`, and the contract markers the change touches — `## Architectural Commentary` (the auto-appended section that edit 2 removes), the auto-fired Step 4a `/consult` second opinion, and the Blind-Spot Scan Gate `≥3 files` trigger (edit 4). Greps run across `ai-resources/` and the workspace root.

Historical records only (NOT live consumers): dozens of past reports under `audits/risk-checks/`, `logs/session-notes-archive-*.md`, `logs/scratchpads/*.md`, `friday-journal-2026-05-22.md`, and `friday-plans/2026-05-22-journal-commands.md` reference the `## Architectural Commentary` section of *past* risk-check reports. These document prior report state; none is a live parser that consumes the section from future reports. Removing the auto-append breaks no downstream reader.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/docs/agent-tier-table.md | co-edits (tier record for risk-check-reviewer) | yes — done (edit 5) |
| ai-resources/logs/decisions.md | co-edits (OP-11 exception record cited by the tier-table note) | yes — **NOT satisfied (entry absent)** |
| ~22 project symlink copies of risk-check-reviewer.md; ~23 of risk-check.md; ~9 of blindspot-scan.md | imports / invokes (symlinks resolve to canonical) | no — inherit automatically |
| ai-resources/.claude/commands/wrap-session.md (+ workspace-root mirror) | invokes / documents (parallel `≥3 files` wrap-time blind-spot nudge, line 201) | no — separate mechanism, deliberately retained |
| ai-resources/.claude/commands/leverage-idea.md | invokes (/blindspot-scan Step 6) | no |
| ai-resources/.claude/commands/scope-project.md | invokes (/blindspot-scan) | no |
| ai-resources/docs/protected-zones.md | documents (`/risk-check` mandatory; `/consult` if structural, line 13) | no — already framed `/consult` as operator judgment |
| ai-resources/docs/audit-discipline.md | documents (`/risk-check` change classes + verdict semantics) | no — does not mandate the auto-fired SO second opinion |
| ai-resources/.claude/commands/resolve-incident.md | documents (its own independent high-risk `/consult`, lines 113–119) | no — separate from risk-check Step 4a; unaffected |
| ai-resources/.claude/settings.local.json | documents (`Bash(ls .claude/agents/risk-check-reviewer.md)` allow path, line 5) | no |
| ai-resources/audits/backbone-manifest.md | documents (backbone reference row) | no |

Total: 11 distinct consumer classes, 2 must-change. Of the two must-change consumers, one (the tier-table) is satisfied; one (`logs/decisions.md` — the canonical OP-11 ledger the tier-table cites for 2026-07-05) is **absent** on disk and is the load-bearing finding below.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The change is net cost-*reducing*, not cost-adding — it is the opposite of the usual usage-cost risk. Three components retier `opus → sonnet` (`risk-check-reviewer.md:4`, `risk-check.md:2`, `blindspot-scan.md:3`), the auto-fired Opus `/consult` pass on non-GO verdicts is dropped (`risk-check.md:117` "do **NOT** auto-invoke `/consult` … multiplied Opus cost"), and the blindspot gate fires on fewer plans (`CLAUDE.md:78`).
- No new always-loaded content, hook, `@import`, or new frequently-spawned subagent is added. The one always-loaded edit (`CLAUDE.md` Blind-Spot Scan Gate) swaps "`/risk-check` change class or ≥3 files" for "`/risk-check` change class" and adds "non-structural multi-file edit" to the skip list (`CLAUDE.md:78`) — roughly token-neutral, marginally leaner.

### Dimension 2: Permissions Surface
**Risk:** Low

- No permission change. Greps found no `allow`/`ask`/`deny` edits, no new Bash/Write/API pattern, no settings-scope move. `settings.local.json:5` still holds the pre-existing `Bash(ls .claude/agents/risk-check-reviewer.md)` entry unchanged.
- The five edits are YAML `model:` frontmatter values plus prose edits to two commands, one always-loaded CLAUDE.md section, and one doc table. None touches the permission layer.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct files touched: 5 (the two referenced commands, one agent, workspace CLAUDE.md, tier-table).
- Reach is wide but backward-compatible: `find` counts ~22 project copies of `risk-check-reviewer.md`, ~23 of `risk-check.md`, ~9 of `blindspot-scan.md`. All are symlinks that resolve to canonical, so the tier change and behavior change propagate automatically — **zero of them must-change** (Consumer Inventory row 3).
- One backward-compatible contract change: edit 2 removes the auto-appended `## Architectural Commentary` section from non-GO reports. No live consumer *parses* that section — every `## Architectural Commentary` hit outside the edited file is a historical record of a past report, not a forward parser (Consumer Inventory, "Historical records only"). So the contract change breaks no reader.
- Shared always-loaded infra (`CLAUDE.md` Blind-Spot Scan Gate) is edited, which affects every future session's gate-firing behavior — this plus the ~50 symlink consumers is what lifts the dimension above Low. It stays Medium (not High) because the change is a narrowing/simplification, nothing requires modification to keep working, and the one must-change co-edit that *is* required (tier-table) was applied.
- Unanticipated-consumer note: the `≥3 files` trigger also lives in the wrap-session blind-spot nudge (`.claude/commands/wrap-session.md:201`, "multi-file change (≥3 files modified)"), which the change did **not** touch. This is intentional (CLAUDE.md:78 states "Wrap-time coverage is separate") but means the ≥3-files coverage now exists only at wrap-time — see Dimension 5.

### Dimension 4: Reversibility
**Risk:** Low

- All five edits are text edits to git-tracked files; a `git revert` of the canonical files fully restores prior behavior, and the ~50 symlink copies inherit the revert automatically (they point at canonical). No sibling files or directories are created.
- No state propagates beyond git: no push, no external write, no log-append mutation, and no new automation, hook, cron, or symlink is added (edit 2 *removes* an auto-fire, which only makes revert cleaner).
- Minor caveat, not scored up: the change alters operator-facing behavior (non-GO no longer auto-consults; blindspot fires on fewer plans), so a revert also has to un-learn operator muscle memory — but that is advisory-gate behavior, not hard state. As landed today, `decisions.md` was NOT modified (git status shows only `improvement-log.md` touched, for an unrelated entry), so no stale log entry blocks a clean revert.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- Dangling forward-citation: the tier-table OP-11 note (`agent-tier-table.md:41`) cites "(`logs/decisions.md` 2026-07-05)" as the record of the exception, but `grep` finds **no 2026-07-05 entry** in `decisions.md` (latest entry is 2026-07-04; the file was last modified Jul 4 22:23). A reader following the audit trail to verify the exception hits a dead reference. This is an undischarged cross-reference introduced by the change.
- Split trigger for one command: after edit 4, the "≥3 files" threshold for `/blindspot-scan` survives only in the wrap-session nudge (`wrap-session.md:201`), while the plan-time CLAUDE.md gate now fires on `/risk-check` classes only (`CLAUDE.md:78`). This is *documented* ("Wrap-time coverage is separate"), so it is a coupling a reader can see, not a silent one — hence Medium, not High. Worth an explicit one-line note so a future maintainer does not "fix" the apparent inconsistency.
- No hidden dependency from edit 2: the removed auto-`/consult` lived only inside `risk-check.md` Step 4a; `audit-discipline.md` and `protected-zones.md` frame `/consult` as operator judgment, and `resolve-incident.md` runs its own independent second opinion — none silently depends on risk-check auto-firing it.

### Dimension 6: Principle Alignment
**Risk:** Medium

Principles-base read from `projects/strategic-os/ai-strategy/principles-base.md` (present and readable).

- **QS-5 / the tier-table's own "Opus — judgment work" convention (`agent-tier-table.md:9`, `principles-base.md:71`).** risk-check-reviewer performs six-dimension risk *judgment*, which the convention routes to Opus; retiering it to Sonnet revises that convention. This is a genuine tension — but the change **acknowledges it loudly**: `agent-tier-table.md:41` labels it a "deliberate cost-reduction exception to the judgment→opus convention" with an OP-11 tag and a compensating control (operator-invoked `/consult` offer preserving Opus depth on non-GO). Per the OP-11 escape hatch (`principles-base.md:33,49`) a recorded, deliberate revision is legitimate, so this is Medium (acknowledged tension), **not** High (silent drift).
- **OP-11 loud-recording is only partially discharged.** The revision is recorded *in the tier-table*, but the tier-table explicitly points to a `decisions.md 2026-07-05` ledger entry that does not exist (Dimension 5). OP-11/OP-3 require the revision be recorded and loud; the canonical ledger the note cites is empty for this date. The precedent for what "loud and recorded" looks like is the 2026-07-04 `/lean-repo` OP-11 block already in `decisions.md`. This is the residual tension keeping the dimension at Medium rather than Low.
- **OP-5 / OP-2 (advisory vs enforcement) — aligned.** The change moves in the safe direction: auto-fire → operator offer *reduces* automation and keeps the gate advisory; it does not upgrade advisory to enforcement.
- **OP-9 / DR-7 / AP-7 (speculative abstraction) — aligned.** The change removes an auto-fired pass and narrows a trigger; it is net-simplification (complexity-budget prong (a)), the opposite of building for an absent consumer.
- **OP-12 (closure before detection) — aligned.** Edit 4 *narrows* blindspot detection; it adds no unclosed detection channel.

## Mitigations

- **Dimension 5 / 6 (load-bearing): close the OP-11 loud-recording loop.** Create the `ai-resources/logs/decisions.md` 2026-07-05 entry that `agent-tier-table.md:41` already cites — recording the three retiers, the Step 4a auto-`/consult` removal, the blindspot ≥3-files drop, the operator-authorized safety-for-cost tradeoff, and the compensating operator-invoked `/consult` offer. Use the 2026-07-04 `/lean-repo` OP-11 block as the template. (Alternative, if the record is meant to live elsewhere: fix the tier-table citation to point to the actual location — but a canonical `decisions.md` entry is the convention.)
- **Dimension 5 (blindspot trigger split): make the deliberate split explicit.** Add a one-line note where the ≥3-files threshold now uniquely lives (`wrap-session.md:201`, or the CLAUDE.md gate) stating that plan-time fires on `/risk-check` classes only and the ≥3-files multi-file coverage is intentionally wrap-time-only — so a future maintainer does not read it as an inconsistency and "restore" the dropped branch.
- **Dimension 3 (reach): confirm propagation is via symlink, not stale copies.** Spot-check one or two downstream project copies of `risk-check-reviewer.md` / `risk-check.md` resolve to the canonical file (regular-file copies would silently keep `model: opus`). The tier-table lists no project-local *regular-file* copy of risk-check-reviewer, so this is expected to pass, but a one-command check closes it.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, `find` counts, and verbatim quotes from the referenced files and principles-base). The load-bearing finding — the absent `decisions.md 2026-07-05` OP-11 entry — is grounded in a negative grep (no `2026-07-05` token in `decisions.md`, latest entry 2026-07-04) plus the file's Jul 4 mtime and git status showing `decisions.md` untouched this session. No training-data fallback was used on any read.
