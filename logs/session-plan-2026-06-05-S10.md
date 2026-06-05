# Session Plan — 2026-06-05 S10

## Intent
Ship a pre-spec consumer-inventory checklist gate into `skills/ai-resource-builder/SKILL.md` via the canonical `/improve-skill` pipeline, folding three pending improvement-log entries (id-40, the S7 strengthening, the 2026-05-29 SO-advisory precursor) into one gate that fires before any rename/remove structural-change spec is written. Closing goal: stop the recurring consumer-inventory under-count class (the rename-rework class) that has now recurred 3+ times.

## Model
opus — match. Active session is `claude-opus-4-8[1m]`. The work is analytical (fold three overlapping entries into one coherent, non-redundant gate; decide placement inside the skill's improvement sequence), which the three-tier heuristic routes to Opus.

## Source Material
- `logs/improvement-log.md` L258 — **id-40** "Pre-spec consumer-inventory grep checklist" (logged/pending). Base rule: before any rename/remove spec, `grep -rn '<old-path>' .claude/ docs/ skills/ workflows/ templates/ CLAUDE.md` and enumerate every consumer.
- `logs/improvement-log.md` L301 — **"Strengthen id-40"** (S7, logged/pending). Two added mandates: (1) grep the INVARIANT filename stem, never the templated/placeholder form; (2) reconcile the grep result against the relevant contract registry before the spec is written.
- `logs/improvement-log.md` L172 — **2026-05-29 precursor** (SO advisory, logged/pending). Same rule, earliest instance; placement decision (SKILL.md vs new `docs/spec-authoring-checklist.md`) was deferred.
- `skills/ai-resource-builder/SKILL.md` — target. The canonical resource-creation/improvement skill that hosts `/create-skill`, `/improve-skill`, `/migrate-skill`.
- `skills/ai-resource-builder/SKILL.md` frontmatter + improvement-sequence section — to locate the correct gate insertion point (spec/plan phase).

## Findings / Items to Address
- The three entries are the **same rule at increasing strength** — they must collapse into ONE gate, not three stacked subsections. id-40 is the base grep; the S7 entry adds invariant-stem + registry-reconciliation; the 2026-05-29 entry is the original and only adds the placement question (resolved here: fold into SKILL.md, not a new doc).
- The gate must bind to the **rename/remove structural-change** path specifically — it is not a general every-edit checklist (avoid over-firing; AP-10 no-error-handling-for-normal-cases discipline).
- The two mechanical root causes the gate must close: (a) grepping the templated form (`session-plan-${MARKER}`) misses files spelling the placeholder differently — so the rule must say grep the invariant STEM (`session-plan`); (b) the source-of-truth contract registry was itself stale — so the rule must say reconcile grep ↔ registry, both directions, and re-classify runtime parsers misfiled as "narrative."
- `/improve-skill` is the canonical pipeline; it reads the SKILL.md, proposes the edit, and runs its own QC framework. Run it rather than hand-editing.

## Execution Sequence
1. Read `skills/ai-resource-builder/SKILL.md` in full to locate the improvement/creation sequence and the natural home for a spec-authoring gate.
2. Invoke `/improve-skill` on `ai-resource-builder` with the folded requirement (one gate, three mandates, rename/remove-scoped) as the improvement brief.
3. Let the pipeline draft the gate; verify it (a) fires only on rename/remove structural-change specs, (b) greps the invariant stem, (c) reconciles against the contract registry, (d) cross-refs the three source entries at disposition.
4. Run `/qc-pass` on the SKILL.md edit. Resolve any material findings (QC → Triage auto-loop if needed).
5. Flip the three source improvement-log entries (id-40, Strengthen id-40, 2026-05-29 precursor) to `applied` with this session's commit reference; cross-ref them to each other at disposition.
6. Commit (`update: ai-resource-builder — pre-spec consumer-inventory checklist gate`). Push deferred to wrap.

## Scope Alternatives
- **Leaner:** ship only id-40's base grep, defer the S7 invariant-stem + registry-reconciliation strengthening. Rejected — the S7 entry exists precisely because the base grep already failed to prevent the `wrap-session.md` miss; shipping the base alone re-opens the exact gap that recurred. The two strengthenings are the load-bearing part.
- **Heavier:** also build a standalone `docs/spec-authoring-checklist.md` referenced from `audit-discipline.md`. Rejected — the 2026-05-29 entry left placement open; folding into SKILL.md (where the spec-authoring actually happens) is the lower-surface choice and the S7 entry already resolved it to "folds into id-40's target rather than a new surface."

## Autonomy Posture
Full autonomy. Content edit to an existing skill via the canonical `/improve-skill` pipeline. No hook, permission, symlink, always-loaded-content, or shared-state surface is touched, so no `/risk-check` gate fires (Autonomy Rule #9 not triggered). `/qc-pass` is the quality gate.

## Risk
Low. Single-file methodology edit to a skill plus three log-status flips. Reversible (git). Blast radius: future structural-change spec sessions gain one mandatory gate — additive, not a change to existing behavior. The one watch-item is over-firing (a gate that fires on non-rename edits would add friction); mitigated by binding the gate explicitly to the rename/remove spec path. Concurrent-session note: `logs/improvement-log.md` is shared and was modified in the working tree at session start (S9 leftovers) — use a fresh read immediately before the status flips and explicit-path staging.
