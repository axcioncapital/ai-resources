# Session Plan — 2026-07-13

## Intent
Fix the session-marker lifecycle defects as one bundle — the cross-checkout allocator collision (HIGH), the leftover per-id markers that make both concurrency guards lie, and two bookkeeping closes — with a stretch fold of the corrected orphan lens into `/architecture-review`.

## Model
opus — match (deciding work: designing a marker-lifecycle contract, judging a live hook's behaviour against its claimed behaviour, and adjudicating two false records).

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md` — the allocation block, ×3 (Steps 8a.3.a, 8b.3.a, 8c.3)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md` — the marker contract + two-end registry
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/detect-concurrent-session.sh` — liveness oracle (SessionStart nudge)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh` — liveness oracle (PreToolUse commit guard)
- `/Users/patrik.lindeberg/.claude/hooks/cleanup-session-marker.sh` — the SessionEnd teardown hook (USER-level, not in this repo)
- `/Users/patrik.lindeberg/.claude/hooks/cleanup-session-marker.log` — the hook's self-probe log; **the ground-truth evidence for Item 2**
- `/Users/patrik.lindeberg/.claude/settings.json` — the SessionEnd registration (user layer)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` — entries at L682, L697, L711, L721; id-46 (L469); id-53 (L613)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — structural change classes (hook edits are one)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/architecture-review.md` — stretch (M-1) only

## Findings / Items to Address

1. **Allocator is blind to in-flight allocations in other checkouts (HIGH).** `improvement-log.md` L697. The oracle takes a MAX across (a) the local marker file, (b) worktree-local `session-notes.md` headers, (c) `git grep` over all refs for *committed* headers. An **uncommitted** allocation live in another checkout is invisible to all three. Two checkouts, one `S{N}` namespace, no mutual exclusion. Real collision on 2026-07-13: this checkout and the `ai-resources-research-workflow` worktree both took S11; S12 yielded by hand. **No gate caught it.** Candidate fix (from the entry, not yet gated): fold `git worktree list --porcelain` checkouts into the same MAX, reading each checkout's `logs/.session-marker*` and its working-tree headers. Explicitly rejected in the source entry: making worktrees reserve markers up front — that reintroduces the shared allocator worktrees exist to remove.

2. **The SessionEnd teardown hook is registered and working — but the event never fires for the sessions that leave corpses.** `improvement-log.md` L682 + L721 (same defect, filed twice). Verified at plan time, by opening the artifact rather than trusting commit `b3046f2`:
   - The hook **is** registered — at the **user layer** (`~/.claude/settings.json` → `$HOME/.claude/hooks/cleanup-session-marker.sh`). It is invisible to any repo-level grep, which is why it read as unregistered. `b3046f2`'s claim is **true**; the repo commit only carried the docs/logs half.
   - The hook **is** firing, with the **correct payload schema** (`cwd`, `session_id`, `hook_event_name`, `reason`, `transcript_path`) — 18 log lines prove it.
   - **But: not one of the four surviving marker corpses' session IDs appears anywhere in that log.** `4c67559e…`, `7f025123…`, `b3c1860f…`, `cb84f42f…` have zero log lines. SessionEnd was **never delivered** for those sessions. The hook is not the defect — the event is.
   - **Therefore the fix is NOT in the hook script.** Root cause must be established first (leading hypothesis: SessionEnd does not fire when a VS Code extension window is closed or abandoned, versus a clean `/clear` or `/exit` — the operator launches via VS Code, so this is the dominant path). A hook that only fires on clean exits cannot be the liveness oracle's sole teardown.
   - Also visible in the log: several NOOPs resolve `cwd` to the **workspace root** while `/prime` writes markers into the **cwd's git root** — a second, independent path-resolution mismatch to confirm or dismiss.

3. **Duplicate entry.** L682 and L721 are the same defect from two angles (staging guard blocks commits / detector cries wolf). Merge into one, preserving both consequences.

4. **id-46 is void.** `improvement-log.md` L469 claims axcion-design-studio's 89 commands are COPIES that "will drift silently from canonical". False: `.claude/commands` there is a **directory symlink**, inode-identical to canonical — the commands cannot drift. The false premise came from `[ -L "$file" ]` returning false for a real file reached *through* a symlinked parent. Close as void.

5. **id-53 lacks a `Verified:` line.** L613, `**Status:** applied 2026-07-13 (S12)` with no `Verified:` field, though S12 tested it both directions. Bookkeeping only.

6. **Stretch — M-1.** Fold the corrected `/lean-repo` Q3 orphan lens (no-evidence-in-scanned-scope → CONFIRM BEFORE DELETE, barred from `Remove`, must state scanned scope, must pass the planted known-positive check) into `/architecture-review`. Unblocked now that id-55 has landed. Context-gated.

## Plan-time /risk-check — RECONSIDER (2026-07-13)

Report: `audits/risk-checks/2026-07-13-marker-lifecycle-bundle-common-dir-allocator-plus-mtime-liveness.md`
Consumers: 12 found, 9 must-change. Blast radius **High**, Reversibility **High**, Hidden coupling **High**.

**The verdict trips this plan's own stop-if. Structural work is HALTED pending operator decision.** Findings, all confirmed:

- **R-1 — the mtime threshold is undefined, and an under-tuned value creates a FALSE NEGATIVE.** That is the data-loss mode the guard exists to prevent — strictly worse than the noise it replaces. A live session idle longer than the threshold (operator think-time, a long subagent, lunch) would read as dead, and a second session could then silently overwrite its uncommitted edits. The plan's only test was "planted stale marker reads dead" — it never tested "genuinely live long-idle session still reads live."
- **R-2 — two of four liveness consumers were left out.** The change named `detect-concurrent-session.sh` and `check-foreign-staging.sh`; it missed `concurrent-session-check.md` and `/prime` Step 1a's own liveness read, plus the registry text in `cleanup-session-marker.sh`'s header. Migrating two of four forks the liveness contract mid-rollout.
- **R-3 — `git rev-parse --git-common-dir` returns a RELATIVE path (`.git`) from the main checkout and an ABSOLUTE path from the worktree.** Independently re-verified. My planning probe used `--path-format=absolute`, which masked it. Any implementation using the bare command is a footgun.
- **R-4 — cross-repo fragmentation is unanswered.** `prime.md` is symlinked into 24 checkouts, each a *different git repo with its own common dir*. Relocating the claim there fragments the marker namespace per-repo. Correct or a bug? The plan raised the question and did not answer it.
- **R-5 — `~/.claude/hooks/cleanup-session-marker.sh` and `~/.claude/settings.json` are UNVERSIONED.** No git safety net. The prior risk-check on this same subsystem already established timestamped backups as a required step; this plan omitted it.

**Recommended redesign (adopted): SPLIT THE BUNDLE.**
1. Bookkeeping closes (Items 3–5) — no structural class, zero blast radius. **Proceed now.**
2. Allocator relocation — land alone, only after normalizing the path shape (R-3) and answering cross-repo fragmentation (R-4) by execution in a non-`ai-resources` repo.
3. mtime-liveness heartbeat — **do not ship** until a threshold is derived and defended, a live-long-idle test exists alongside the stale-marker test, and all four consumers migrate in one edit with backups taken first.

## Blind-spot scan — findings folded in (2026-07-13, PAUSE-AND-FIX)

The scan invalidated the central fix as first drafted. Recorded here so closure does not depend on memory.

- **B-1 (design-invalidating).** The worktree's `prime.md` is a **real file on a branch 10 commits behind main** — not a symlink. Any allocator fix landed on main leaves the worktree running the OLD allocator, so it keeps allocating blind over main's uncommitted claim. Mutual exclusion honoured by one party is not mutual exclusion. **The live worktree branch is part of the change set: rebase it onto main (or close it) before relying on the fix.**
- **B-2 (better mechanism, empirically verified).** `git rev-parse --git-common-dir` resolves to the SAME `ai-resources/.git` from both checkouts, and a probe file written there from main was read back from the worktree. This is a shared, branch-independent, never-committed channel — exactly what the branch-tracked marker sources lack. **Put the allocation claim there** instead of folding `git worktree list` into the MAX.
- **B-3 (capability invalid).** The SessionEnd payload carries **no PID** (observed keys: `cwd, hook_event_name, prompt_id, reason, session_id, transcript_path`). The "stamp with PID" idea is unbuildable. **`Stop` is an every-turn registered event** — use marker **mtime freshness**, refreshed on `Stop`, as the liveness signal.
- **B-4 (proportionality).** Under a heartbeat design, *which* end-paths deliver SessionEnd is moot — the marker expires on its own. Demote the root-cause hunt from a blocking gate to a one-line diagnostic.
- **B-5 (blast radius).** Both guard hooks are registered at USER level by **absolute path into `ai-resources/`**, so they run for every project and the worktree regardless of open folder — a hook edit is live everywhere the instant it is saved, with no staging. Land hook changes after the allocator is proven; preserve the existing `exit 0`-on-unexpected-state guards.

## Execution Sequence

1. **Refresh the stale worktree (B-1) — prerequisite, not cleanup.** Rebase `session/2026-07-13-research-workflow` onto `main`, or close the worktree if its work is done. **Verification:** the worktree's `prime.md` is byte-identical to canonical. *No allocator fix is trustworthy while a stale checkout can allocate from the same namespace — this step is what makes the rest true.*

2. **Relocate the allocation claim to the shared git common dir (B-2).** Write each session's claim to `$(git rev-parse --git-common-dir)/axcion-session-markers/<session-id>` — shared across all worktrees, branch-independent, never committed. The MAX reads that directory **in addition to** the existing three sources. Preserve the **load-bearing fail-safe invariant** (`friction-log.md` L400): `HIGH` is seeded from the marker file *before* the scan loop and the loop only ever *raises* it, so a `git` failure degrades to marker-file-only behaviour and can never reset `HIGH` to 0 and allocate `S1` over an existing `S5`. Any edit that scans first and consults the marker file second reintroduces a destructive regression.
   **Verification (falsification test — the stop-if condition):** plant an uncommitted `S99` claim from the worktree side; the oracle in this checkout must then hand out `S100`, and the *old* logic must be shown to hand out something lower. Ship nothing that fails either half.

3. **Make liveness derivable, not teardown-dependent (B-3, B-4).** Liveness = marker **mtime freshness**; refresh it on the `Stop` event (already registered, fires every turn); read a marker older than the threshold as dead. This survives a crash, a `/clear`, and a closed VS Code window identically — it fixes the class, not the instance. Keep the SessionEnd hook as opportunistic fast cleanup, and keep `/prime`'s next-day orphan prune as the documented backstop. Add `reason` to the SessionEnd log line as a one-line diagnostic (not a gate).
   **Verification:** a planted stale marker reads as dead by BOTH consumers, AND a genuinely live session's marker still reads as live. Both directions — a fix that blinds the detector is worse than the noise it removes.

4. **Lockstep-propagate `prime.md`.** The allocation block appears **3×** (8a.3.a / 8b.3.a / 8c.3). Per S12's proven protocol: 27 workspace copies exist — 24 symlinks (inherit for free), 3 real files, **2 of which are 33-line stubs with no marker block** (check before editing). **Verification:** hash-compare the real copies; re-grep each of the 3 blocks in canonical to confirm all three carry the identical new logic.

5. **Update the contract docs.** `docs/session-marker.md` — the allocation contract (§ Marker resolution), the concurrent-detection contract, and the two-end registry entry for "Per-id marker teardown". **Verification:** the doc states the new invariant and no longer describes a teardown model the harness does not implement.

6. **Bookkeeping closes (Items 3–5).** Merge L682/L721; close id-46 as void with the reason; add id-53's `Verified:` line. **Verification:** re-grep `improvement-log.md` — one merged entry, id-46 shows void, id-53 shows `Verified:`.

7. **`/risk-check`** (plan-time gate already implied; run before commit as the end-time gate). Hook edits + a core command edit + shared-state automation = three structural classes.

8. **Commit.** Then **Stretch (Item 6 / M-1)** only if context remains.

## Scope Alternatives

- **Min (must ship):** Items 1–5 diagnosis + the allocator fix (Step 3) + lockstep propagation (Step 4) + the three bookkeeping closes (Step 6). This closes the one HIGH and stops the false records propagating.
- **Recommended:** Min + the teardown fix (Steps 1–2) + contract docs (Step 5). This is the whole marker-lifecycle subsystem in one pass, which is the point of bundling — the three defects share the same files and the same gate.
- **Max:** Recommended + M-1 (fold the corrected orphan lens into `/architecture-review`). Context-gated; drop it without ceremony if the session is long.

**Deliberate ordering note:** Step 1 (diagnose) precedes Step 2 (fix) and is not optional. The single most-repeated lesson in this repo's last two days — four false records in 48 hours, every one caught by *opening the artifact* and none by a gate — is that a claim about the world is not the world. `b3046f2`'s commit message says this is fixed. It is registered and it is firing. It is still not working. Do not design against the log entry; design against the hook's log.

## Autonomy Posture
Gated.

**Stop points:**
- Before Step 1 rebases or closes the live worktree branch — that is another session's checkout, and refreshing it is not mine to do unilaterally.
- If the Step 2 falsification test fails — do NOT ship an unproven marker allocator. This is the third defect in this subsystem today; an unverified fourth edit is how the count reaches four.
- If `/risk-check` returns RECONSIDER or NO-GO.

## Risk
Run `/risk-check` after this plan is approved (plan-time gate), and again before commit (end-time gate).

Structural change classes touched — three, not one:
- **Hook edits** — `detect-concurrent-session.sh`, `check-foreign-staging.sh`, and the user-level `cleanup-session-marker.sh`.
- **Core command edit** — `prime.md`, which is symlinked into 24 checkouts. Every project inherits this change.
- **Automation with shared-state effects** — the marker namespace is shared across concurrent sessions and worktrees; this is precisely a reordering of operations against shared state, which the tripwire in `/session-plan` Step 6 names explicitly.

**Blast radius:** `prime.md` fires at the start of every session in every project. A regression here does not fail loudly — it hands out a wrong session number, and the damage lands later, at merge. The fail-safe invariant in Execution Step 3 is the guardrail; it is not optional.

**Environment-fit:** not applicable — no executable/launcher artifact is planned. The user-level hook already exists and already fires; this session changes its logic, not its trigger surface.

**Known coverage gap to preserve:** SessionEnd cannot fire on SIGKILL/hard crash. `/prime`'s next-day orphan prune is the documented backstop and MUST survive whatever replaces the teardown. Degrading to "a crashed session leaves a stale marker until tomorrow" is acceptable; degrading to "a live collision goes undetected" is not.
