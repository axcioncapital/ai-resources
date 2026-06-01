# Build Brief: Universal Playbook for Parallel Multi-Session Work

## What This Is

A workspace-level best-practice document — a **playbook for running multiple Claude Code sessions in parallel** — to live in `ai-resources/docs/` and be created via the canonical resource process (not improvised). It governs *any* project, so it belongs at workspace level, not in a single project.

**Goal it serves:** plan and execute a project's work as efficiently as possible, using parallel sessions *selectively* where they genuinely accelerate completion — not as a default reflex.

## Origin

Came out of the 2026-06-01 three-parallel-session run on the `interpersonal-communication` project: three git worktrees (A = `wt/feedback-protocol`, B = `wt/exemplar-diversity`, C = `wt/permission-cleanup`), each running its own `/prime → /session-start → /session-plan → work → /qc-pass → /wrap-session`. Session A's wrap surfaced the merge-coordination questions that prompted this brief. The operator's framing question: *is there a universal best-practices playbook for parallel sessions that avoids the pitfalls — and is the multi-session approach even the right path?*

This brief is **preliminary and contested**. The framing and the draft playbook below come from a single session's reasoning over an n=1 run. **Stress-test it; do not accept it as settled.** The "Known weaknesses" section is the intended attack surface.

## Framing To Stress-Test (the source session's claim)

Parallelism is a **selective optimization on top of good decomposition** — not the organizing principle for a project. The right organizing principle is: decompose well, sequence what depends on something else, and *then* run the genuinely-independent chunks in parallel if each is large enough to be worth it.

Supporting arguments offered (each needs testing):
- **Speedup is capped by the serial fraction** — planning + operator approval gates + merge resolution + final integration QC. Amdahl-style ceiling.
- **The operator is a single serial resource.** Approval gates serialize on the human; realistic supervision ceiling is low (claimed 2–3 concurrent decision-streams).
- **The merge cost is deferred, not avoided** — parallel feels fast because the conflict work is all at the end.

## Pitfalls Observed (n=1, KB-authoring run, 3 worktrees)

- **All merge conflicts were in shared bookkeeping, none in the work.** The content files (`feedback-protocol.md`, exemplar files, permission files) partitioned perfectly and never collided. Every conflict was in `logs/session-notes.md`, `logs/coaching-data.md`, `logs/usage-log.md`, `knowledge-base/_master-index.md`, `logs/decisions.md`, `logs/next-up.md`.
- **State-file leakage.** `.session-marker`, `.prime-mtime`, and scratchpads were committed inconsistently across the three branches.
- **Harness assumes a single log-writer.** The marker system, the `/session-start` mtime guard, the `/wrap-session` foreign-write guard, and the `detect-concurrent-session` hook are retrofits that *detect* collisions and stop clobbering, but do **not** prevent the merge pain. There is a structural mismatch: per-branch isolation for the work + a single shared file for the bookkeeping.
- **"[IN FLIGHT] / do not start" backlog markers predictably create *content* conflicts at merge.** During the origin run, `main` was updated to mark the three in-flight items in `logs/next-up.md` as `[~] [IN FLIGHT]` (coordination scaffolding so no session double-starts them). Each worktree, meanwhile, edited the *same* backlog items to their resolved/enriched state. At merge this is a genuine **content** conflict (not a log union): the same item appears once as "in flight — do not start" and once as "resolved." The default "keep both" rule is **wrong** here — it produces contradictory entries. **Resolution rule:** the executing worktree's resolved state wins (it's the authoritative, more-recent truth; the in-flight marker was temporary), then **sweep the whole file for any leftover `[~] [IN FLIGHT]` markers** once all branches land — every in-flight marker is stale post-merge, and resolving only the current branch's items leaves the backlog half-resolved/half-"do not start." The playbook should treat in-flight markers as a recognized parallel-session coordination device *with* this defined merge-resolution rule, OR recommend a marker-free coordination method (e.g., the file-ownership map already covers "who owns what" without mutating the shared backlog).

## Preliminary Playbook (draft — to be hardened)

**Part 1 — Go/no-go test (before spawning any worktree).** Parallelize only if all pass:
1. **Independence** — each task gets a non-overlapping file set, including not fighting over shared indexes/logs.
2. **Granularity** — each task is at least a full session's worth of work (amortizes the per-session overhead).
3. **No dependency** — no task needs another's output.
4. **Attention** — operator can hold N concurrent decision-streams without quality loss.

**Part 2 — Operating procedure (once you decide to parallelize):**
1. One upfront **planning session** (serial, highest-leverage): decompose into independent units + write an explicit **file-ownership map** (no two units share a path).
2. **Quarantine shared bookkeeping** — per-session logs OR a serialized closing pass. Principle: if no two sessions write the same file (logs included), there are zero conflicts.
3. One **worktree + branch per unit**, off a known-good base.
4. **Stay in lane** — a session that needs another unit's file stops and flags, never crosses.
5. **Deliberate landing pass** — merge the cleanest branch first, union-merge shared logs (keep-both, never pick-one), then a **final integration QC** (each session's own QC never saw the others).

## Known Weaknesses To Resolve (source session's self-critique — keep all of this open)

1. **Built on n=1, and a *clean-partition* case.** The headline insight ("conflicts were 100% in bookkeeping") may be an artifact of work whose content files partitioned naturally. For work that does NOT partition cleanly — refactoring a shared codebase, editing one large document from multiple angles, ripple-across-many-files changes — conflicts would land **in the work itself**, and the "quarantine the logs" fix would not help. **The playbook needs a second branch for non-cleanly-partitionable work.** This is the biggest risk.
2. **Autonomy may be the dominant lever, not worktree hygiene.** Parallelism's payoff is capped by how much each session runs without the operator. Low-autonomy + parallel = thrash; high-autonomy + parallel = real speedup. Test whether "raise per-session autonomy / reduce gate frequency" outranks the coordination mechanics.
3. **Invented numbers.** The "40% serial → 2.5× ceiling" and "attention ceiling 2–3" are illustrative, not measured. Build a real estimation method or remove the false precision. (Note: the source run's own merge was not even complete when the framing was written — no measured serial fraction exists yet.)
4. **"Per-session logs" fix has a hidden cost.** It trades merge-conflicts for **history fragmentation** + a reconciliation step. Present as a tradeoff, not a free win.
5. **Go/no-go test may be too rigid.** "All four must pass" could rule out beneficial parallelism. Smarter dependency rule: **extract the shared prerequisite into a serial pre-step, then fork the independent remainder** — rather than refusing to parallelize.
6. **Worktrees assumed as the only model.** Compare against alternatives: sequential-with-good-batching, one-session-with-checkpoints, branches-without-worktrees, separate clones. Say when parallel *loses*.
7. **Cost axis ignored.** N sessions ≈ N× tokens/compute + the merge session. Parallelism trades **money for wall-clock**. And "efficiency" is ambiguous — wall-clock speed vs total effort vs cost are three different targets implying three different playbooks. Force the operator to pick which they optimize.

## Deliverable

A scope-agnostic doc providing:
- (a) a go/no-go **decision test**;
- (b) a **decomposition + file-ownership discipline**;
- (c) a **shared-state coordination protocol**;
- (d) a **landing/merge procedure**;
- (e) an explicit **"when NOT to parallelize"** section;
- (f) the **cost/efficiency-target** disambiguation.

Invariant framework, not a recipe tied to the one origin run.

## System-Owner Ownership (steady-state)

The workspace has an **Axcíon AI System Owner** (the `system-owner` agent / `projects/axcion-ai-system-owner/`) whose remit is to know the full inventory of `ai-resources` artifacts and resources — and, for this playbook specifically, to know **what** the universal multi-session playbook is and **when, how, and why** to apply it.

Implications for this build:
- **Loop the system-owner in during creation** as a reviewer/consultant — it should validate the framing against the rest of the `ai-resources` inventory (e.g., does this overlap or conflict with existing session/harness docs, the marker contract, `docs/session-marker.md`, autonomy rules?).
- **The finished playbook becomes a system-owner-owned artifact.** The "when/how/why to implement parallel sessions" decision is a system-owner advisory call, not a per-session improvisation. The doc should be written so the system-owner can cite it when advising on whether a given project's work should be parallelized.
- Consider whether the playbook needs a short **system-owner-facing decision hook** (a one-paragraph "how the System Owner decides to recommend parallel vs sequential for a project") distinct from the operator-facing procedure.

## Concrete Follow-Up Surfaced During the Origin Run (workspace-wide gitignore fix)

A specific, do-able item that came out of landing the origin run's branches — distinct from authoring the playbook, but the playbook should reference it as a worked example of the "state-file leakage" pitfall:

- **Problem:** `logs/.prime-mtime` and `logs/.session-marker` are per-session transient state (written fresh each session by `/prime`; read within-session by the foreign-write / mtime guards). They are **not** meant to be shared through git, but in `interpersonal-communication` they were **tracked** (`.prime-mtime`) or got committed (`.session-marker`) — neither was gitignored. Result: every session that stages them re-commits them, they cause a dirty-tree block before merges, and the "how do I keep these out of main" question recurs on every parallel merge.
- **Local fix applied (or to apply) during the origin merge:** `git rm --cached logs/.prime-mtime logs/.session-marker` + add both to that project's `.gitignore` + one cleanup commit. `--cached` keeps the local files so the harness still works; gitignore does not affect local creation/reads.
- **Workspace-wide follow-up:** the session harness writes these markers in **every** project, so the same `.gitignore` lines almost certainly belong in **every project's `.gitignore`**, not just `interpersonal-communication`. Sweep all project repos: untrack `logs/.prime-mtime` / `logs/.session-marker` where tracked, and add the ignore lines everywhere. Low-risk, reversible repo hygiene — but verify no consumer depends on these markers being *committed* (none known; they are per-machine session-local by design). Consider whether this belongs as a one-time `/permission-sweep`-style hygiene pass or folded into the harness/marker contract (`docs/session-marker.md`) as a standing rule that these files are gitignored by default in new projects.

## Process Notes

- Run through the canonical doc/resource-creation path; do not improvise a doc into place.
- QC it independently before landing.
- Evaluate whether any **harness change** is warranted (e.g., per-session log namespacing to remove the bookkeeping-conflict surface) — if so, that is a structural change and gets its own `/risk-check`.
- Source artifacts to read for grounding: the origin run's session notes in `projects/interpersonal-communication/logs/session-notes.md` (2026-06-01 worktree wraps), `docs/session-marker.md`, the `/wrap-session` foreign-write guard, the `detect-concurrent-session` hook, and workspace autonomy rules.
