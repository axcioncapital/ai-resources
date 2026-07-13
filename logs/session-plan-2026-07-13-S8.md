# Session Plan — 2026-07-13

## Intent
Execute the `/lean-repo` plan (`audits/lean-repo-2026-07-13.md`): triage its 22 items by urgency and value, then execute the most important fixes.

## Model
opus — match (active: `claude-opus-4-8[1m]`). Triage across seven dispositions under a doctrine conflict is judgment work, not spec-following.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/lean-repo-2026-07-13.md` — the 22-item plan (read in full)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/output/consultations/consult-2026-07-13-lean-repo-gaps.md` — SO advisory on the 4 engine-flagged gaps (pre-plan, load-bearing on scope)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/output/context-packs/architecture-20260713-e9d3b/pack.md` — context pack (20 files in scope; `sufficient_to_implement: false`, 4 missing-context items)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — `/risk-check` change classes; the No-self-waivers clause (MC-1's blocker)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md` — § Q5 two-gate firing model; § Symlink topology (`EXCLUDE_COMMANDS` literal-assignment constraint)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/gate-calibration.md` — the calibration log MC-1 must route through
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/agent-tier-table.md` — registry row to reconcile on R-2/R-3
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/auto-sync-shared.sh` — `EXCLUDE_COMMANDS` line 46 (R-3 touches it)

## Findings / Items to Address

**Triage output — all 22 items ranked by urgency × value. Source anchors are to `audits/lean-repo-2026-07-13.md`.**

**Tier 1 — execute this session (bounded, high value, low blast radius):**
1. **I-1…I-7** (§ INVESTIGATE, L121-139) — seven commands with zero refs and zero logged invocations (`promote-workflow` 286 L, `list-critical-resources` 187 L, `explore-section` 156 L, `project-next-steps` 123 L, `post-project-review` 86 L, `project-consultant` 86 L, `tech-consult`). One operator yes/no each. **Cheapest pass, largest likely cut (~924 L).** Blocked on operator answers — cannot be auto-resolved (reference-grep structurally cannot model operator invocation; `usage-log` is opt-in since 2026-07-04).
2. **R-1** (§ REMOVE, L41-45) — `backup-session-plan.sh` has **zero registrations in any settings layer**, while its own header claims it is wired. False assurance on a backup control. Binary operator decision: wire it or delete it.
3. **R-2** (§ REMOVE, L47-50) — `execution-agent` has no spawner; flagged by `/repo-dd` 2026-05-08, still present 66 days later. Remove + reconcile the `agent-tier-table.md` row (42 → 41).
4. **M-1 → R-3, strict order** (§ MERGE L60-68; § REMOVE L52-56) — fold `/lean-repo`'s three questions into `/architecture-review` AND wire `/architecture-review` into `/friday-checkup`'s quarterly tier, THEN retire the `/lean-repo` command + `lean-repo-auditor` agent. **The wiring is the load-bearing half** — merging alone yields a bigger orphan (O-2: `/architecture-review` has never run either). R-3 must not execute before M-1 lands or the lens dies with the component.

**Tier 2 — QC-reachability-gated; execute only if independent QC is reachable (per workspace QC-independence rule; SO advisory § Gap 1):**
5. **D-1** (§ DEFER-LOADING, L95-99) — move the model-tier compliance roster (state, not a rule) out of always-loaded workspace `CLAUDE.md`; keep the prohibition, the frontmatter rule, the carve-out, and one pointer line. Zero behavioural risk.
6. **S-1** (§ SIMPLIFY, L87-91) — complete the pointer-migration on workspace `CLAUDE.md` (242 → ~180 L); six sections carry both a `Full rules:` pointer and a ~58-line inline body. One section per commit; verify each pointed-to doc actually contains the behaviour before removing it. **Remove no rule.**

**Tier 3 — DEFERRED this session, deliberately (SO advisory § Gaps 3 + 4):**
7. **MC-1** (§ MAKE-CONDITIONAL, L72-83) — risk-tier the six `/risk-check` change classes. The plan's own executive summary ranks this #1 by drag (336 runs, 93% proceed, never calibrated). **It is nonetheless NOT landing this session.** Two reasons, both from the SO advisory: (a) the proposed "lightweight inline check … escalating on any non-trivial answer" is a *self-graded materiality call* — the exact shape the **No-self-waivers** clause in `docs/audit-discipline.md` was written to forbid after the 2026-07-03 incident; the plan's guardrail #1 asserts non-conflict without reconciling it. Resolvable only if the check is made bright-line/mechanical (fixed auto-escalation conditions), which needs operator arbitration. (b) `audit-discipline.md` is High load-bearing (`risk-topology.md § 1`); MC-1 re-tiers the repo's highest-volume gate and is self-referentially gated — an execution session is the wrong venue, and it cannot monitor the plan's own 30-day falsification trigger. **Log the deferral; route to the Friday cadence or a dedicated gated session.**
   - *Note:* the plan's stated blocker for MC-1's calibration routing is **false** — `gate-calibration.md` is hand-editable and its 2026-05-22 entry was recorded outside the `/friday-checkup` auto-trigger. The deferral rests on (a) and (b), not on the routing mechanics.

**Tier 4 — no action (correctly dispositioned):**
8. **RT-1…RT-8** (§ RETAIN, L105-119) — eight justified controls. Do not touch. RT-1 in particular: MC-1 tiers `/risk-check`; it is not a case for weakening it.
9. **The inflow design rule** (L143-149) — **already landed** (commit `fb8d72c`, "adopt the inflow design rule (rule #7) — closes RR-05"). Verify in `docs/ai-resource-creation.md`, then mark closed in the plan. No new work.

## Execution Sequence

1. **Ask the operator the eight decision questions** (I-1…I-7 + R-1) in a single batched block — one yes/no per command plus the wire-or-delete call on `backup-session-plan.sh`.
   *Verify:* eight explicit answers received; no auto-resolution of any.
2. **Run `/risk-check` — plan-time gate, ONCE, batched across the whole Tier-1 set** (not per item — per-change firing is the failure mode the two-gate model exists to prevent, `repo-architecture.md § Q5`). Classes touched: removed commands (I-removals, R-3), hook edit (R-1), agent removal (R-2 — a doctrine gap: agents are absent from the six enumerated classes; flag, don't assume coverage), edit to an existing command (M-1).
   *Verify:* one verdict for the batch. On RECONSIDER/NO-GO, pause and revise before any edit.
3. **Execute the confirmed I-removals** — delete each `No`-answered command; each removal also drops its symlink fan-out across projects.
   *Verify:* per removed command, `grep -r` returns no live reference; the auto-sync symlinks resolve or are pruned.
4. **Execute R-1** per the operator's wire-or-delete answer.
   *Verify:* if wired → the hook appears in a settings layer and its header claim is now true; if deleted → no settings layer references it.
5. **Execute R-2** — remove `execution-agent.md`; reconcile `docs/agent-tier-table.md` (42 → 41).
   *Verify:* no command/hook spawns it; the tier-table count matches ground truth.
6. **Execute M-1** — fold Q1/Q2/Q3 into `/architecture-review`; wire `/architecture-review` into `/friday-checkup`'s quarterly tier.
   *Verify:* `/friday-checkup`'s quarterly tier names `/architecture-review`; the three questions are present in `architecture-review.md`. **This is the gate on step 7.**
7. **Execute R-3 — only after step 6 verifies** — remove `lean-repo.md` + `lean-repo-auditor.md`; reconcile `agent-tier-table.md` (41 → 40) and the `auto-sync-shared.sh:46` `EXCLUDE_COMMANDS` entry. **The `EXCLUDE_*` lists must stay static, single-line, start-of-line literal assignments** — `/fix-symlinks` re-reads them with `sed`; a reflowed value parses to empty and silently disables its drift scan (`repo-architecture.md § Symlink topology`).
   *Verify:* the `EXCLUDE_COMMANDS` line is still a single-line literal; `/fix-symlinks`' sed extraction still returns a non-empty list.
8. **Assess QC-reachability for Tier 2** (D-1, S-1). If a `/qc-pass` subagent is reachable → execute D-1, then S-1 one section per commit. If unreachable → defer via `/handoff` (QC-PENDING), do not self-QC-and-commit.
   *Verify:* either both land with an independent QC pass, or a QC-PENDING scratchpad exists naming them.
9. **Log the MC-1 deferral** — `logs/decisions.md` (the deferral + its two reasons) and the plan file's MC-1 status.
   *Verify:* the deferral is on disk with its rationale, not merely stated in chat.
10. **Update `audits/lean-repo-2026-07-13.md`** — per-item status for all 22.
    *Verify:* every item carries a status; none is silently left ambiguous.
11. **Run `/risk-check` — end-time gate, ONCE, before commit.**

## Scope Alternatives

- **Min** — steps 1–2 plus the I-removals only (the cheapest, largest cut). Everything structural defers.
- **Recommended** — Tier 1 complete (steps 1–7), Tier 2 QC-gated (step 8), MC-1 deferred and logged (step 9). This is the plan.
- **Max** — Recommended plus MC-1. **Rejected**: the No-self-waivers conflict is unresolved and needs operator arbitration; landing it here would be the self-graded materiality call the clause forbids.

## Autonomy Posture
Gated.

**Stop points:**
- Before any edit — the eight operator decision answers (I-1…I-7, R-1). These cannot be self-resolved.
- The plan-time `/risk-check` verdict (step 2) — on RECONSIDER/NO-GO, pause.
- Between M-1 and R-3 (step 6 → 7) — R-3 is blocked until M-1 verifies.
- Before Tier 2 — the QC-reachability assessment. If QC is unreachable, the commit is blocked and the work defers via `/handoff`.

## Risk
Run `/risk-check` after the plan is approved (plan-time gate). Run it again before commit (end-time gate). **Once each, batched across the Tier-1 set — not per item.**

Structural classes touched: removed commands (I-1…I-7 removals, R-3), hook edit (R-1), edit to an existing command (M-1), cross-cutting CLAUDE.md (D-1, S-1 — Tier 2 only), and agent removal (R-2 — **not** among the six enumerated classes; the plan flags this as a doctrine gap rather than assuming coverage; treat as low-risk but confirm no project symlink resolves to it before deleting).

Tripwire noted: none of the Tier-1 items reorders operations against shared state. The `auto-sync-shared.sh` touch in step 7 is a single-token edit to a literal list, not a control-flow change — but the literal-assignment constraint above is load-bearing and is the specific thing to verify.

Environment-fit check: not applicable — no executable or launcher is produced this session.
