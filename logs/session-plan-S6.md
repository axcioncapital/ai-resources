# Session Plan — 2026-06-01

## Intent
Author `ai-resources/docs/parallel-sessions-playbook.md` from the inbox brief via the canonical doc-creation path — stress-testing the contested n=1 framing, resolving the brief's "Known Weaknesses," looping the system-owner in as reviewer, and delivering the six required sections.

## Model
opus — match (active session is opus; this is synthesis + design + judgment over a contested framing → deciding-tier work).

## Source Material
- `/Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/inbox/parallel-sessions-playbook-brief.md` — the build brief (primary input)
- `/Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md` — marker contract (check for conflict/overlap)
- `/Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md` — foreign-write guard (the retrofit the brief critiques)
- `/Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/detect-concurrent-session.sh` — concurrency-detection hook
- `/Users/danielniklander/Axcion Claude Code/Axcion AI Repo/CLAUDE.md` — workspace autonomy rules + design-judgment principles
- `/Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/docs/ai-resource-creation.md` — canonical doc-creation discipline
- `/Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md` — placement (confirm docs/ is correct home)
- `/Users/danielniklander/Axcion Claude Code/Axcion AI Repo/projects/interpersonal-communication/logs/session-notes.md` — the origin 3-worktree run (2026-06-01 wraps)
- system-owner agent (`projects/axcion-ai-system-owner/`) — reviewer/consultant, per brief § System-Owner Ownership

## Findings / Items to Address
The brief specifies the deliverable contents and an explicit attack surface. Items to resolve in the doc:

**Required sections (brief § Deliverable):**
1. Go/no-go decision test — brief Part 1 four-gate test (Independence/Granularity/No-dependency/Attention).
2. Decomposition + file-ownership discipline — brief Part 2.1 file-ownership map; "no two units share a path."
3. Shared-state coordination protocol — brief Part 2.2 bookkeeping quarantine; the log-shaped vs content-shaped file split (Landing Lesson 4).
4. Landing/merge procedure — brief Landing-Phase Lessons 1–8 (clean target, serialize merges, clean branch first, forecast by shape, gate content conflicts only, both-sides-present QC, git-status hygiene, teardown ordering) + Shared-Remote Lessons 1–3.
5. When NOT to parallelize — brief Known Weakness 1 (non-cleanly-partitionable work — the biggest risk) + Weakness 6 (worktrees not the only model).
6. Cost / efficiency-target disambiguation — brief Weakness 7 (wall-clock vs total effort vs cost = three targets, three playbooks).

**Known Weaknesses to resolve explicitly (brief § Known Weaknesses — keep all open, do not paper over):**
7. Built on n=1 clean-partition case → add a second branch for non-partitionable work (refactors, single-doc multi-angle edits). Biggest risk.
8. Autonomy may be the dominant lever, not worktree hygiene → test/state whether raising per-session autonomy outranks coordination mechanics.
9. Invented numbers ("2.5× ceiling", "attention 2–3") → remove false precision or give a real estimation method; the origin run produced no measured serial fraction.
10. Per-session-logs fix has a hidden cost (history fragmentation + reconciliation) → present as a tradeoff, not a free win.
11. Go/no-go may be too rigid ("all four must pass") → smarter rule: extract shared prerequisite into a serial pre-step, then fork the remainder.
12. Worktrees assumed as only model → compare sequential-with-batching, single-session-checkpoints, branches-without-worktrees, separate clones; say when parallel LOSES.
13. Cost axis ignored → N sessions ≈ N× tokens + merge session; parallelism trades money for wall-clock.

**Framing claims to stress-test (brief § Framing To Stress-Test) — do not accept as settled:**
14. "Parallelism is a selective optimization on top of good decomposition, not the organizing principle" — Amdahl ceiling, operator-as-serial-resource, deferred-not-avoided merge cost. Test each; present as reasoned position with its limits, not dogma.

**System-owner-specific (brief § System-Owner Ownership):**
15. Validate framing against existing ai-resources inventory (session-marker contract, autonomy rules, harness retrofits) — surface any conflict per workspace Design-Judgment "surface, don't silently resolve."
16. Add a short system-owner-facing decision hook (one paragraph: how the System Owner decides parallel vs sequential for a project) distinct from operator-facing procedure.

**Cross-reference (not in scope to fix, but the doc references as worked example):**
17. The workspace-wide `.gitignore` sweep for `logs/.prime-mtime` / `logs/.session-marker` — cited as the worked example of the "state-file leakage" pitfall (brief § Concrete Follow-Up). Doc references it; the sweep itself is out of scope.

## Execution Sequence
1. **Deep-read grounding inputs.** Brief (done), `session-marker.md`, autonomy rules, wrap foreign-write guard, `detect-concurrent-session.sh`, and the origin-run session notes. Verify the harness-retrofit claims the brief makes against the actual files. ✓ when each claimed retrofit is confirmed or corrected against source.
2. **System-owner consult (pre-draft).** Invoke the `system-owner` agent with the brief framing + the inventory question (conflict with marker contract / autonomy rules / existing session docs?). ✓ when the agent returns a framing validation + any conflicts + a recommendation on the decision-hook.
3. **Draft the doc.** All six required sections + the second branch for non-partitionable work + the when-parallel-loses comparison + cost-target disambiguation + the system-owner decision hook. Stress-test claim 14 in-text (state position + limits). Strip invented numbers (item 9). ✓ when a complete draft exists at `docs/parallel-sessions-playbook.md` covering items 1–16.
4. **Self-review against the Known-Weaknesses checklist.** Confirm each of items 7–13 is explicitly addressed (not silently dropped). ✓ when every weakness maps to a doc passage.
5. **Independent `/qc-pass`.** Fresh-context QC of the draft against the brief's six deliverables + attack surface. ✓ when verdict is GO or fixes applied.
6. **Land.** Apply QC fixes; move brief to `inbox/archive/`; commit (`new: parallel-sessions-playbook — ...`). ✓ when doc + archived brief committed; push deferred to wrap.

## Scope Alternatives
- **Min:** the six required sections, weaknesses noted as open caveats rather than resolved. Faster, but the brief explicitly says "resolve" the weaknesses — under-delivers.
- **Recommended:** six sections + all seven weaknesses resolved in-text + system-owner review + decision hook. Matches the brief's Deliverable + Ownership requirements.
- **Max:** recommended + a worked-example appendix walking the origin 3-worktree run end-to-end as an illustration. Deferred unless the draft reads thin without it.

## Autonomy Posture
Gated — additive new-file work, but the framing is contested and the operator may want to weigh in on how the stress-test resolves.

**Stop points:**
- After the system-owner consult + first complete draft: surface the framing resolution (esp. the stress-test verdict on claim 14 and the second branch for non-partitionable work) and any system-owner-flagged conflict, before running QC and archiving the brief.

## Risk
No structural change classes apparent — a doc in `docs/` is not always-loaded content, a new command/skill, a hook, a permission, or a symlink. The brief's harness-change idea (per-session log namespacing) and the `.gitignore` sweep ARE structural and are explicitly out of scope, each gated by its own `/risk-check`. Run `/risk-check` only if scope expands to touch those.
