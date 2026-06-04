# Session Plan — 2026-06-04 S4

## Intent

Run two real, open menu items: a small grounding-verified function-letter fix in two System Owner commands (item 1), and a read-only grounded System Owner consult confirming the contested n=1 framing in the parallel-sessions playbook (item 6). Reduced from an original 5-item auto pick (1,2,3,4,6) after a gate-time conflict check found items 2 and 3 already executed earlier today and item 4 unscoped.

## Model

opus (`claude-opus-4-8[1m]`) — match. Item 1 is light editing but the fix is grounding-dependent (must confirm the correct function letters against the read-map, not blind-apply the scratchpad); item 6 is a judgment consult. Higher-cognitive-load item sets the tier → opus.

## Source Material

- [.claude/commands/friday-so.md](../.claude/commands/friday-so.md) — item 1 target (currently "Function E read map" near L52).
- [.claude/commands/so-monthly.md](../.claude/commands/so-monthly.md) — item 1 target (currently "Function F read map" near L59).
- [.claude/agents/system-owner.md](../.claude/agents/system-owner.md) — read-map cross-reference (read-only).
- [projects/axcion-ai-system-owner/references/grounding.md](../../projects/axcion-ai-system-owner/references/grounding.md) — canonical Function→read-map authority; the fix is verified against this, not the scratchpad.
- [docs/parallel-sessions-playbook.md](../docs/parallel-sessions-playbook.md) — item 6 consult subject.
- Scratchpad `logs/scratchpads/2026-06-04-10-15-scratchpad.md` — flagged item 1; three memos converged on it (signal, not authority).

## Findings / Items to Address

### Item 1 — Function-letter read-map fix
- `friday-so.md` near L52 reads "grounding.md Function **E** read map"; scratchpad says it should be **F**.
- `so-monthly.md` near L59 reads "grounding.md Function **F** read map"; scratchpad says it should be **G**.
- **Verification gate:** confirm against `grounding.md` which Function letter actually maps to each command (Friday Advisory; Monthly System Review). If grounding shows the current letters are already correct → no-op, report and stop (mandate Stop-if). If grounding confirms the shift, apply the minimal edit only.
- Cross-check `system-owner.md` agent def for any hardcoded Function-letter reference that would also need to move.

### Item 6 — n=1 framing consult
- `parallel-sessions-playbook.md` was authored 2026-06-01 (S6); its contested n=1 framing was stress-tested once via a system-owner consult pre-draft.
- This item re-runs a grounded SO consult to confirm the n=1 framing still holds — read-only advisory, verdict delivered in chat. No edit to the playbook unless the consult surfaces a concrete defect the operator then approves fixing (out of this mandate's scope — would be a follow-up).

## Execution Sequence

### Stage 1 — Item 1: function-letter fix
1. Read `grounding.md` Function read-map section; determine correct letters for Friday Advisory and Monthly System Review.
2. Read the actual lines in `friday-so.md` and `so-monthly.md` (and scan `system-owner.md` for related refs).
3. If a shift is confirmed: apply minimal edits (E→F in friday-so, F→G in so-monthly, plus any agent-def ref). If already correct: stop per mandate Stop-if.
4. `/qc-pass` on the edits.
5. Commit (ai-resources repo) directly per workspace commit rule. No push (batched to wrap).

### Stage 2 — Item 6: SO consult
6. Run a grounded System Owner consult on `parallel-sessions-playbook.md`'s n=1 framing (via `/consult` or system-owner agent, grounded in `grounding.md`).
7. Deliver the verdict in chat (confirm / concern + recommended reconciliation). No playbook edit under this mandate.

Between stages: one-line between-gate summary. No operator pause (single approval gate already passed).

## Scope Alternatives

- **As planned (1 + 6).** Recommended. Both real, both collision-free.
- **Add E1/E4 graduations (item 2 remainder).** Only after the concurrent S3 session wraps — the strategic-os tree is dirty now; editing risks a collision. Defer.
- **Re-scope item 4.** Needs the operator to name specific stale headers/files first; cannot resolve from inspection.

## Autonomy Posture

Full autonomy. No structural change classes triggered — command-content fix (not CLAUDE.md / hooks / permissions / new resources) + a read-only consult. No `/risk-check` gate required.

## Risk

- **Low.** Largest risk is blind-applying the scratchpad's letter shift without grounding-verifying it — mitigated by the Stage-1 verification gate against `grounding.md` (mandate Stop-if covers the already-correct case).
- **Concurrent-session awareness:** an active S3 session holds the strategic-os tree dirty. This mandate touches no strategic-os files, so no collision surface. Item 1 edits `ai-resources` command files only.
