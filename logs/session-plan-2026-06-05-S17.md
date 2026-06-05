# Session Plan — 2026-06-05

## Intent
Land three triaged items in ai-resources: (#1) strengthen the id-40 rename-spec consumer-inventory rule (invariant-stem grep + `docs/session-marker.md` registry reconcile) in its consumed doc; (#7) run `/resolve-improvement-log` to archive newly-verified S15 entries while leaving logged/pending entries at correct status; (#2) document a doc-only fallback posture for when 1M-context credit exhaustion blocks subagent-dependent gates.

## Model
opus — match (active `claude-opus-4-8[1m]`). Work mixes log/doc edits (doing) with judgment calls (is #1's Gate already complete; where and how to phrase #2's fallback posture) — the judgment legs justify opus.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` — id-40 / pre-spec-consumer-inventory entry (#1); status reconciliation + archival source (#7)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/ai-resource-builder/SKILL.md` — Consumer-Inventory Gate § (lines 363–369), the consumed doc for #1
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md` — the registry that #1's reconcile-step points at
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-improvement-log.md` — the purpose-built archival command for #7 (resolved = `Status: applied` + `Verified:`; parked = `Review-cycle:` excluded)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/qc-independence.md` — candidate home for #2's fallback posture (QC-gate doc)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/autonomy-rules.md` — alternate home for #2 (gate-unreachable is an autonomy-posture question)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — structural change-class reference (for the /risk-check call)

## Findings / Items to Address
1. **#1 — id-40 rule may already be landed (verify-first, not re-author).** `skills/ai-resource-builder/SKILL.md` § Consumer-Inventory Gate already states both proposed requirements: line 367 "Grep the invariant stem, never the templated form" and line 369 "Reconcile against the contract registry, both directions" (with the `docs/session-marker.md` example). The friction-log S7 entry proposed this as a *strengthening of id-40*; the deployed rule appears to already implement it. **Action:** confirm the Gate covers both clauses with no gap; if complete, the residual work is to reconcile the improvement-log id-40/pre-spec entry to `Status: applied` + `Verified:` (anchored to SKILL.md L363–369), NOT a duplicate rule edit. If a genuine gap exists (e.g. the invariant-stem rule is not enforced at spec-write time, only described), close that specific gap.
2. **#7 — archival is command-driven, status-precise.** Run `/resolve-improvement-log`. Per its Step 1–3 contract: only entries with both `Status: applied` AND `Verified:` are archived; logged/pending entries stay; `Review-cycle:`-parked entries are excluded from archival (park-as-graveyard guard). The 20 logged/pending entries must NOT be force-resolved — let the command leave them in the active log at their real status. Newly-verified S15 entries (improvement-log L238/266/275/311 region, all carrying `Verified:`) are the archival candidates.
3. **#2 — doc-only fallback posture.** Document that when 1M-context credit exhaustion blocks subagent dispatch (qc-reviewer / outcome-check / feedback-collector all fail with "Usage credits required for 1M context"), inline self-QC is the sanctioned fallback, and the condition must be surfaced in chat rather than silently skipped. Land this as a short subsection in `docs/qc-independence.md` (recommended — it is a QC-gate degradation rule) cross-referenced from `docs/autonomy-rules.md` if needed. The novel credit-detection *hook* is out of scope (parked).

## Execution Sequence
1. **#1 verify-or-close.** Read `skills/ai-resource-builder/SKILL.md` L360–375 in full. Verdict: Gate complete vs gap. *Verify:* both clauses (invariant-stem grep; bidirectional registry reconcile) present and enforced at spec-write time. If complete → no SKILL.md edit; proceed to step 2. If gap → make the minimal edit closing it.
2. **#1 log reconcile.** Locate the id-40 / pre-spec-consumer-inventory entry in `improvement-log.md`. Update its `Status:` to `applied` + add `Verified:` anchored to SKILL.md L363–369 (and any step-1 edit commit). *Verify:* entry now carries both fields and reads as resolved.
3. **#2 author + land.** Write the doc-only fallback subsection to `docs/qc-independence.md`. *Verify:* subsection names the trigger (1M-credit exhaustion blocks subagent gates), the fallback (inline self-QC), and the surfacing requirement (flag, don't silently skip).
4. **/risk-check (plan-time gate).** Before committing the doc edits, run `/risk-check` on the #1-SKILL (if edited) + #2-qc-independence.md change set — both are canonical process docs referenced by CLAUDE.md (cross-cutting class). On RECONSIDER/NO-GO, pause and re-scope.
5. **#7 archival.** Run `/resolve-improvement-log`; answer its prompts to archive only the verified entries (which now include the step-2 reconciled #1 entry). *Verify:* logged/pending count unchanged at their real status; verified entries moved to archive.
6. **QC + commit.** Run `/qc-pass` on the doc edits. **1M-credit risk (live):** this session is on opus[1m]; if qc-reviewer dispatch is blocked by credit exhaustion — exactly item #2's failure mode — fall back to inline self-QC per the posture being authored in step 3, and flag it. Commit each repo's changes directly per workspace rules; push gated to wrap.

## Scope Alternatives
- **Min:** #7 only (run `/resolve-improvement-log`) + #1 reduced to a log-status reconcile (if step-1 confirms the Gate is already complete). Lowest risk, no process-doc edit.
- **Recommended:** all three items as sequenced; #1 verify-first (likely log-reconcile only), #2 doc-only subsection, #7 archival, with a single `/risk-check` covering the doc edits.
- **Max:** recommended + extend #2 to add a cross-reference from `docs/autonomy-rules.md` and a one-line pointer in the relevant gate command(s) so the fallback is discoverable at dispatch time (more surfaces touched → wider /risk-check).

## Autonomy Posture
Gated.

**Stop points:**
- After step 1 if a genuine Gate gap is found in SKILL.md (judgment call on the minimal fix) — surface before editing.
- At step 4 `/risk-check` — on RECONSIDER/NO-GO, pause and re-scope (mandate stop-if: #2 must stay doc-only; if it would require a hook, stop).
- Before #7 archival if `/resolve-improvement-log` offers any entry whose verified-status is uncertain.

## Risk
Run `/risk-check` after this plan is approved (plan-time gate) and again before commit (end-time gate). #1 (SKILL.md Consumer-Inventory Gate, if edited) and #2 (`docs/qc-independence.md`) are edits to canonical process docs referenced by CLAUDE.md — cross-cutting change class per `docs/audit-discipline.md`. #7 is command-driven and reversible (archival preserves entries). If step 1 confirms #1 needs no SKILL.md edit, the structural surface narrows to #2 alone.
