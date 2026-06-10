# Session Plan — 2026-06-10 S2

## Intent
Build **Fix 4(a)** of the concurrent-session isolation fix-plan: establish a "wrap-owns" discipline for the **in-place mutations** of the shared logs (`improvement-log.md`, `friction-log.md`, `decisions.md`) in `docs/commit-discipline.md`, so two sessions serialize on those logs instead of colliding at pull (Failure B). First reconcile the append-vs-in-place classification conflict that runs through three docs (and inside `commit-discipline.md` itself), then write the rule and carve out the legitimate mid-session appenders.

## Model
opus — match. This is a *deciding* task: it resolves a load-bearing classification conflict and designs a cross-session discipline rule, not a mechanical edit.

## Source Material
- `audits/2026-06-09-concurrent-session-isolation-fix-plan.md` — §3 Fix 4 (route (a) = wrap-owns + sequencing; route (b) = per-session namespacing, out of scope), §4 build-order item 3, §5 "does NOT rewrite the playbook."
- `docs/commit-discipline.md` — L25 (tripwire exempt-list: calls these logs "append-only ... benign"), L29–45 (shared-log write-path integrity: calls `improvement-log.md`/`friction-log.md` "non-append ... lost-update hazard"). **The fix lands here.**
- `docs/parallel-sessions-playbook.md` — L65 (append-only/log-shaped row), §2/§3 design rule "bias toward new files."
- `/prime` Step 1a — already classifies `improvement-log.md`, `improvement-log-archive.md`, `decisions.md` as non-append (in-place status flips / archiving) = lost-update surface.
- Mid-session writers to vet: `.claude/commands/improve.md`, `.claude/commands/resolve-improvement-log.md`, `.claude/commands/resolve-incident.md`, `.claude/commands/resolve-repo-problem.md`, `.claude/commands/log-defect.md`, `.claude/agents/session-feedback-collector.md`, `.claude/commands/wrap-session.md`.
- Context pack: `output/context-packs/documentation-20260610-f3a9c/pack.md` (sufficient_to_plan, NOT sufficient_to_implement — 1 conflict + 3 missing-context items, all about this classification).

## Findings / Items to Address

### The classification conflict is real and partly internal
- `commit-discipline.md` L25 lists `improvement-log.md`, `decisions.md`, `coaching-data.md` as **"append-only shared logs ... cross-session overlap is benign (no lost update)."**
- `commit-discipline.md` L29–31 lists `improvement-log.md`, `friction-log.md` as **"non-append shared logs ... a downstream Write persists the truncation as a mass deletion"** (lost-update hazard).
- Same file, same file named, opposite classification. This must be reconciled, not papered over (workspace "conflicts must be surfaced" rule).

### The reconciliation (the load-bearing design decision)
Both labels are right about **different operations**. These logs carry two operation classes:
1. **Atomic appends** — a new entry added at EOF (`/improve`, `/resolve-incident`, `/log-defect`, `session-feedback-collector`). Benign across sessions: git unions them (worst case a keep-both append conflict, data-safe). This is what L25 means by "append-only / benign."
2. **In-place mutations** — status flips (marking an item `resolved`/`applied`/`verified`) and archiving (`/resolve-improvement-log` moving entries to `*-archive.md`). These rewrite existing lines → genuine lost-update surface across sessions, and "keep both" is semantically wrong. This is what L29 and `/prime` Step 1a mean by "non-append."

**Wrap-owns rule = the in-place mutations are owned by a single serialized actor (wrap / maintenance time); mid-session writers append only, never flip-in-place.** This removes most of Failure B's surface (per fix-plan §3 Fix 4(a)) without forbidding the legitimate mid-session appends — which answers the engine's missing-context item #3.

### Scope guards
- `session-notes.md`, `usage-log.md`, `coaching-data.md` are append-only in *both* operation senses (marker-disambiguated / pure logs) — **not** in scope for wrap-owns; leave them classified append-only.
- `/resolve-improvement-log` is the *legitimate* archiving writer — the rule names it as the owner of the archiving mutation, it is not prohibited.
- Do NOT rewrite `parallel-sessions-playbook.md` (fix-plan §5) — at most one cross-reference line.
- Fix 4(b) (per-session namespacing) stays out of scope — it is the escalation if 4(a) proves insufficient.

## Execution Sequence

### Stage 0 — Investigate (read-only)
Grep the mid-session writers for whether any performs an in-place **status flip** mid-session (the operation the rule would move to wrap). Confirm `/improve`, `/resolve-incident`, `/log-defect` are append-only; confirm `/resolve-improvement-log` is the archiving owner; check `wrap-session.md` already does the wrap-time status work. Output: a concrete list of which (if any) commands violate the proposed rule and need a one-line conform edit.

### Stage 1 — /risk-check
Run `/risk-check` on the concrete proposal (commit-discipline.md rule + reconciliation + any conform edits). Mandate Stop-if: NO-GO / RECONSIDER pauses. Light class expected (doc rule), but the fix-plan mandates a build-time risk-check for every fix.

### Stage 2 — Implement
- Reconcile `commit-discipline.md` L25 vs L29 (name the two operation classes; make L25's exempt-list rationale explicit that it covers the *append* operation, cross-ref the in-place-mutation rule).
- Add the wrap-owns rule as a section in `commit-discipline.md` (the canonical home per fix-plan §5).
- Apply any one-line conform edits Stage 0 surfaced (append-only-mid-session note) — only if a real violation exists.
- One cross-reference line in `parallel-sessions-playbook.md` if warranted (no rewrite).

### Stage 3 — QC + commit
`/qc-pass` on the changed doc(s). On APPROVE, commit (`update: commit-discipline — Fix 4(a) wrap-owns shared-log discipline`). Push deferred to wrap.

## Scope Alternatives
- **Minimal:** reconcile the L25/L29 contradiction + add the wrap-owns rule in `commit-discipline.md` only. No command edits, no playbook touch. Ships the discipline; relies on existing writers already conforming.
- **Recommended (planned):** minimal + Stage 0 conform edits *only where a real violation exists* + one playbook cross-ref line. Same risk class, closes the loop on any non-conforming writer.
- **Over-scoped (rejected):** rewrite the playbook's classification table + touch every log-writer "for consistency." Rejected — fix-plan §5 forbids the playbook rewrite; touching non-violating writers is churn with no consequence.

## Autonomy Posture
Gated — structural change class (shared-state discipline rule + cross-cutting doc). `/risk-check` at Stage 1 is the plan-time gate (mandate Stop-if). Otherwise full autonomy through implement → QC → commit. Push batched to wrap.

## Risk
- **Premise risk (mitigated):** the fix-plan's "only edited at wrap, never mid-session" premise is too strong — it would forbid legitimate mid-session appends. Mitigated by scoping wrap-owns to the *in-place mutations* only, not all edits.
- **Internal-contradiction risk:** if the L25/L29 reconciliation is done carelessly it could weaken the foreign-staging tripwire's exempt-list rationale (L25). Mitigation: keep L25's exempt-list behavior intact (those logs stay exempt *for staging-overlap purposes*); only clarify *why*, and cross-ref the mutation rule.
- **Cross-session completeness:** wrap-owns removes most of Failure B but not all (two clones can both wrap). Documented as a known residual; Fix 4(b) is the escalation. Not a defect of 4(a).
