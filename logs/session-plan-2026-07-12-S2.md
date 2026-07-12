# Session Plan — 2026-07-12

## Intent
Advance the W3.2 Phase 0 defect batch (M-A1–M-A4, ai-resources-homed) — write the batch's gate packet with a currency check on every claim, then implement the confirmed-live defects and update the remediation register.

## Model
opus — match (`claude-opus-4-8[1m]`). The hard part is *deciding*: dispositioning stale claims, resolving doc contradictions against canonical authority, and authoring a gate packet. The edits themselves are mechanical, but the judgment ahead of each one is not.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-redesign/window-outputs/W3.2-migration-roadmap.md` (M-A1–M-A4 rows, L39–42)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-redesign/output/implementation-prep/remediation-register.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-redesign/output/implementation-prep/packets/R3-run-manifest.md` (packet-shape precedent; also the currency-correction precedent)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-redesign/output/implementation-prep/packets/R1-spine-schemas.md` (packet-shape precedent)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` (canonical authority for push, guardrails, model tier)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/autonomy-rules.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-rituals.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-guardrails.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/compaction-protocol.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/agent-tier-table.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/CATALOG.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` (structural change classes — this batch touches several)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/hooks/model-classifier.sh`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/pre-commit` (repo source) vs `ai-resources/.git/hooks/pre-commit` (installed)

## Findings / Items to Address

Pre-flight currency check already run this session. The R3 lesson (a packet's central premise had gone stale and `/risk-check` caught it) is applied up front here: **every claim below carries a verdict, not an assumption.**

1. **M-A1a — push contradiction. CONFIRMED LIVE.** `docs/autonomy-rules.md` item 2 reads "(`git push` proceeds autonomously after commit.)" and `docs/session-rituals.md` § Before Committing reads "Push happens automatically after commit." Both contradict canonical workspace `CLAUDE.md` § Push behavior (gated, batched to wrap, single confirmation prompt) and the standing operator rule (auto-memory `feedback_push_gated.md`, rule inverted 2026-05-29). **This is the highest-value item in the batch** — an agent reading either doc would push mid-session, the exact action the operator banned. Source: roadmap L39.
2. **M-A1b — guardrail wait-vs-continue fork. CONFIRMED LIVE.** `docs/session-guardrails.md:5` instructs "emit the named flag ... and **wait** for the operator's one-word response"; `docs/session-guardrails.md:65` renders `[COST]` as a question ("...or continue?"). Canonical workspace `CLAUDE.md` § Session Guardrails says the opposite for three of the four flags: "`[HEAVY]` — Emit and continue", "`[SCOPE]` — Emit and continue", "`[COST]` — Emit and continue". Only `[AMBIGUOUS]` is already reconciled in both. Source: roadmap L39.
3. **M-A1c — `/compact` posture contradiction. NEEDS DEEPER TRACE.** `docs/compaction-protocol.md:7` says prefer `/clear` + restart *over* `/compact`. `ai-resources/CLAUDE.md:70` § Compaction instead tells the session what to preserve *when* `/compact` fires. These are adjacent, not plainly contradictory — the claimed contradiction is not yet reproduced. Trace the roadmap's underlying finding before editing; if it does not reproduce, disposition as STALE in the packet rather than inventing a fix. Source: roadmap L39.
4. **M-A2a — missing model tiers. PARTLY STALE.** All 42 agent files under `ai-resources/.claude/agents/` already declare a `model:` tier (0 missing). The roadmap's named gaps are *command-side and inline-spawn* sites (`/plan-draft`, wrap Step 6.4 spawn, drift/contract subagents, skill-eval subagents, RRP investigator, WF10 gaps) — those remain unverified. Re-scope this item to commands + inline spawns; record the agent-side half as already-done. Source: roadmap L40.
5. **M-A2b — `model-classifier.sh` wire-or-delete. CONFIRMED LIVE (orphan).** `.claude/hooks/model-classifier.sh` exists at workspace root and is referenced by **nothing** — no settings.json hook registration, no command, no doc. A built-but-unwired orphan. Decision required: wire it or delete it. Note it recommends `sonnet[1m]` / "Sonnet 1M", which the standing `[1m]`-purge item (improvement-log 2026-06-18, item 3) also targets — so *delete* is the likely-correct disposition, and would close part of that entry too. Source: roadmap L40.
6. **M-A3a — duplicate startup-context injection. NOT REPRODUCED.** The `SessionStart` hooks in workspace-root and `ai-resources` settings.json run **different** commands (`check-archive.sh --warn-only` vs `friday-checkup-reminder.sh`) — no duplication visible at this layer. Trace the roadmap's underlying finding (likely a W1.x audit) before acting; disposition as STALE if it does not reproduce. Source: roadmap L41.
7. **M-A3b — stale installed pre-commit. CONFIRMED LIVE.** `ai-resources/.git/hooks/pre-commit` (installed, mtime 2026-02-20) diverges from the repo source `ai-resources/.claude/hooks/pre-commit`: the installed copy carries an old check-numbering and **omits the `check-skill-size.sh` call entirely**. The committed source is ahead; the hook actually running is behind. Source: roadmap L41.
8. **M-A3c — `/new-project` banned model-declaration line. LIKELY STALE.** A grep for `"model"` across `.claude/commands/new-project.md` and `templates/` returns nothing. Confirm with a wider search, then disposition as STALE (already fixed) if it holds. Source: roadmap L41.
9. **M-A4 — tier-table + CATALOG reconciliation. LIVE, SCOPE CONFIRMED.** Both targets exist: `docs/agent-tier-table.md` and `skills/CATALOG.md` (a *skills* catalog, not an agents catalog — the roadmap's phrasing is ambiguous and must be pinned in the packet). Ground truth: 42 agent files. Reconcile both documents against the live inventory; this is the baseline the registry rule depends on. Source: roadmap L42.

**Disposition discipline (mandate exit condition):** every STALE / NOT-REPRODUCED claim above must be explicitly written up in the packet with the evidence that killed it. Silently dropping a stale claim is the failure mode — it re-enters the backlog on the next scan.

## Execution Sequence

1. **Complete the currency trace** for the three unresolved claims (items 3, 6, 8). Read the W3.2 roadmap rows and, where needed, the upstream W1.x finding they cite. *Verification:* each of the 9 items carries a final verdict — CONFIRMED-LIVE / STALE / NOT-REPRODUCED — with cited evidence.
2. **Write the gate packet** `packets/M-A-phase0-defects.md`, following the R1/R3 packet shape (scope, gates, per-item change spec, rollback, §8 verification levels). Include a **Currency correction** section — the R3 packet's own precedent — recording every claim the check killed or re-scoped. *Verification:* packet covers all 4 M-A items, names a rollback (`git revert` per roadmap), and states a verification level per item.
3. **Run `/risk-check` on the packet (plan-time gate).** Required: the batch touches hook edits (`model-classifier.sh` delete/wire, `pre-commit` sync), and behaviour-governing doc edits (`autonomy-rules.md`, `session-guardrails.md`) that every session reads. Mandate `Stop if`: RECONSIDER or NO-GO halts execution and forces a redesign, per `DR-8`. *Verification:* a verdict is on disk under `audits/risk-checks/`.
4. **Run `/blindspot-scan`** (post-plan, pre-implementation — fires because the plan rewires runnable infrastructure: a hook deletion and a git-hook sync). *Verification:* verdict surfaced inline; PAUSE-AND-FIX findings resolved before step 5.
5. **Implement M-A1** — reconcile `autonomy-rules.md` + `session-rituals.md` to the canonical gated-push rule, and `session-guardrails.md` to the canonical emit-and-continue rule. Canonical `CLAUDE.md` wins in both cases; the docs are the stale copies. *Verification:* grep shows no surviving "push ... automatic/autonomous" claim and no surviving "wait for the operator's one-word response" for `[HEAVY]`/`[SCOPE]`/`[COST]`.
6. **Implement M-A2b** — wire-or-delete `model-classifier.sh` per the packet's decision. *Verification:* either a settings.json registration exists, or the file is gone and no reference dangles.
7. **Implement M-A3b** — sync the installed `ai-resources/.git/hooks/pre-commit` to the repo source. *Verification:* `diff` between installed and source is empty; a test commit still runs the skill checks.
8. **Implement M-A2a / M-A4** as context allows — the command-side tier scan and the tier-table/CATALOG reconciliation. *Verification:* every command/inline spawn declares a tier; tier-table + CATALOG match the 42-agent ground truth.
9. **Update the remediation register** — promote the M-A rows from the thin index to detail rows with status + verification, mirroring how R3 is recorded. *Verification:* each M-A row reads `verified` or carries an explicit deferral reason.
10. **QC + commit.** Independent `/qc-pass` on the packet and the applied diffs, then commit. Push stays batched to wrap.

## Scope Alternatives

- **Min (safe floor):** Steps 1–5 only — currency trace, packet, gates, and M-A1 (the two doc contradictions). This alone removes a live instruction that would make an agent push mid-session, which is the batch's real payload. Everything else defers with its verdict recorded.
- **Recommended:** Steps 1–7 + 9–10 — adds the `model-classifier.sh` disposition and the pre-commit sync (both confirmed-live, both small, both hook-class so they ride the same `/risk-check`), plus the register update and QC. Defers M-A2a/M-A4, the two largest and least urgent items.
- **Max:** all 10 steps including the full command-side tier scan and the tier-table/CATALOG reconciliation. Realistic only if the currency trace collapses several items to STALE and frees the budget. Do not force it — the `Context constraint deferral` rule applies, and M-A4 is a "baseline for the registry rule", not a defect that hurts today.

## Autonomy Posture
Gated.

**Stop points:**
- After step 3 (`/risk-check`) — a RECONSIDER or NO-GO verdict halts execution; this is an explicit mandate `Stop if`. Redesign, do not override.
- After step 4 (`/blindspot-scan`) — resolve any PAUSE-AND-FIX findings before touching a hook.
- Before deleting `model-classifier.sh` (step 6) — deletion is irreversible-ish and outside this session's created scope; confirm the packet's disposition holds and that nothing references it.
- Before the scope decision at step 8 — if context is constrained, defer M-A2a/M-A4 with their verdicts recorded rather than rushing them.

## Risk
Run `/risk-check` after the plan is approved (plan-time gate). Run it again before commit (end-time gate) unless the standing end-time skip rule applies (plan-time fired on this exact class, mitigations applied, scope shipped without drift).

Structural change classes touched (per `docs/audit-discipline.md`): **hook edits** (`model-classifier.sh` wire-or-delete; installed `pre-commit` sync — a git hook that gates every commit in this repo), and **cross-cutting doc edits to behaviour-governing rules** (`autonomy-rules.md`, `session-guardrails.md`, `session-rituals.md` are read as authority by sessions and agents).

Named risks:
- **The pre-commit sync is the sharpest edge.** A bad sync breaks committing in `ai-resources` for every future session. Verify by diff *and* by an actual test commit before trusting it.
- **`model-classifier.sh` deletion must confirm zero consumers** — the grep this session ran found none, but the Consumer-Inventory Gate (`skills/ai-resource-builder/SKILL.md`) requires grepping the **invariant stem** (`model-classifier`), not a templated form, and reconciling against any registry before removal.
- **Do not "fix" a stale finding.** Items 3, 6, and 8 are unreproduced. Editing a file to satisfy a finding that no longer holds is the failure mode the R3 session just caught. STALE is a legitimate, recordable outcome.

**Environment-fit check:** not applicable — no launcher or terminal-triggered artifact is planned. `model-classifier.sh` is a hook (harness-triggered), not an operator-launched script; if the disposition were "wire it", the trigger is a settings.json hook event, which fires identically under the operator's VS Code launch path.
