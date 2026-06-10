# Parallel Multi-Session Playbook

> **When to read this file:** Before deciding to run more than one Claude Code session in parallel on the same project (typically via git worktrees), and again before landing those parallel branches. Also read it when advising whether a project's upcoming work *should* be parallelized at all — that recommendation is a System Owner call, not a per-session improvisation (see § System Owner Decision Hook).

This is a scope-agnostic framework: it tells you **when** parallel sessions help, **how** to decompose and coordinate them, **how** to land them, and — just as important — **when not to bother**. Its *reasoning* is deductive and generalizes (the Amdahl ceiling, the single-serial-operator constraint, deferred merge cost); the *framework as a whole* is validated against one origin run and is the current best working model, not a measured law — see § 0.

---

## 0. Framing — what parallelism is, and is not

**Parallelism is a selective optimization layered on two prerequisites: good decomposition *and* high per-session autonomy. It is not the organizing principle for a project.**

The organizing principle is: decompose the work well, sequence whatever depends on something else, and *then* run the genuinely-independent chunks in parallel — but only when each chunk is large enough to be worth its own session, and only when each session can run to its own QC without frequent operator gates.

Two levers are **co-dominant**, and both must be present for parallelism to pay off:

- **Decomposition** — can the work split into non-overlapping units? If not, parallel sessions collide *in the work itself* and the playbook's coordination machinery does not help (see § 6, Branch B).
- **Autonomy** — can each session run a long way on its own? The operator is a single serial resource. Every approval gate (merge, push, structural change, ambiguity) reconverges on the human. Low-autonomy + parallel = the operator thrashing between N decision streams = no real speedup, just higher cost. High-autonomy + parallel = each session reaches its own QC independently and the operator only serializes at the merge.

Treating decomposition as the *only* lever is the most common framing error. You can partition perfectly and still lose the benefit if every session stops every few minutes for an approval.

### The three supporting claims — and their limits

These are reasoned positions, not measured laws. State them; do not dress them up as arithmetic.

1. **Speedup is capped by the serial fraction** (planning + operator approval gates + merge resolution + final integration QC). This is an Amdahl-style ceiling: the parts that *cannot* run in parallel set the floor on total time. **Limit:** no measured serial fraction exists for our work — the origin run's own merge was not even complete when this claim was first written. Do not quote a specific speedup multiple ("2.5×") as if it were observed. It was not.

2. **The operator is a single serial resource.** Approval gates serialize on the human; there is a realistic ceiling on how many concurrent decision-streams an operator can hold without quality loss. **Limit:** that ceiling has not been measured. Treat "how many sessions can I actually supervise well?" as a self-assessment the operator makes per run, not a fixed number this doc hands you. Raising per-session autonomy *raises* the ceiling — fewer gates means more sessions are supervisable.

3. **Merge cost is deferred, not avoided.** Parallel work *feels* fast because the conflict and integration work is all pushed to the end. It has not gone away; you pay it during the landing phase (§ 5). **Implication:** a run that splits cleanly but produces a brutal merge has not saved anything — it has moved the cost, and possibly grown it.

---

## 1. Go / No-Go decision test

Run this **before spawning any worktree.** Parallelize only when the work clears these gates. The gates are ordered — fail early and you can stop testing.

> **Evidence basis:** one origin run; the gates below are reasoned, not measured — see § 0.

1. **Partitionability (the hard gate).** Can you draw a **file-ownership map** in which no two units share a path — *including* shared indexes, backlogs, and logs? Write the map first (§ 2). **If you cannot draw a non-overlapping map, that is itself the answer: this work is not cleanly partitionable → go to § 6, Branch B.** You do not need to predict conflicts; the inability to assign every file to exactly one owner *is* the conflict prediction.

2. **Granularity.** Is each unit at least a full session's worth of work? Parallel sessions carry real per-session overhead (planning, marker setup, QC, the merge slot). Sub-session-sized units do not amortize it — you spend more on coordination than you save.

3. **Independence — with an escape hatch.** Does any unit need another's output? If yes, do **not** simply refuse to parallelize. **Extract the shared prerequisite into a serial pre-step, then fork the independent remainder.** A single dependency is a reason to sequence one step, not to abandon parallelism for the whole job. Only genuinely circular or pervasive dependencies kill the parallel path outright.

4. **Autonomy headroom.** Can each session run to its own QC without frequent operator gates? If the work needs the operator at many decision points (low autonomy), N parallel sessions multiply the gate load onto one person. Low autonomy → prefer sequential-with-checkpoints (§ 6).

**All four in doubt → sequential.** But note gate 3's escape hatch and gate 1's redirect to Branch B: a "no" is often "restructure," not "stop."

---

## 2. Decomposition + file-ownership discipline

The single highest-leverage step happens **before** any worktree exists: one serial **planning session** that decomposes the work and writes an explicit file-ownership map.

### The file-ownership map

A table assigning **every file any session will touch** to exactly one owning unit. No two units share a path. This includes the non-obvious shared files — indexes, backlogs, and logs — which are exactly where the conflicts hide.

Classify each file by **shape**, because shape predicts merge behavior (this is the same log-shaped vs content-shaped distinction the marker contract uses — see § 3):

| Shape | Examples | Merge behavior |
|-------|----------|----------------|
| **New file** | a brand-new deliverable only this unit creates | Zero conflict — additive work parallelizes almost for free, even against a busy shared base (see § 5, remote lessons). |
| **Append-only / log-shaped** | `logs/session-notes.md`, `coaching-data.md`, `usage-log.md`, `decisions.md` | Genuine "keep both" unions — both sides' entries survive. |
| **Content-shaped / co-edited** | backlogs (`next-up.md`), indexes (`_master-index.md`), any file two units both edit | Can carry **semantic** conflicts where "keep both" is the *wrong* rule. These are the dangerous ones. |

**Design rule — bias toward new files.** Wherever a unit's output can be structured as a *new* file rather than an *edit* to a shared one, do that. The conflict surface is created by edits to shared files, not by additions. This is the corollary, seen from the file side, of why additive work survives a 15-commit divergence untouched (§ 5).

**"Produced no deliverable" does NOT imply "only unions."** A session that edits no content files can still hit a semantic conflict if it touched a shared *backlog* or *index*. Forecast by file *shape*, never by "did this session produce a deliverable." (Origin run: a session whose only edits were to `next-up.md` carried the run's one real content conflict.)

---

## 3. Shared-state coordination protocol

The structural problem parallel sessions hit: **per-branch isolation for the work + a single shared file for the bookkeeping.** The harness already isolates work per worktree, but the bookkeeping logs are shared files that every session writes — so every parallel run collides there.

### What the harness already does — and does NOT do

The workspace has a marker contract and three guards. **They detect collisions; they do not prevent merge pain.** Know the boundary so you do not expect more than they give:

- `docs/session-marker.md` — the per-session-id identity oracle + shared `S{N}` counter. Fixes *within-session* TOCTOU races (one session's marker can't be clobbered by a concurrent `/prime`). It does **nothing** about cross-branch *merge reconciliation* — that is one layer up, and that layer is this playbook.
- `session-start.md` Step 0.5 (mtime guard) and `wrap-session.md` Step 3.5 (foreign-write guard) — detect a foreign write *after* it lands.
- `.claude/hooks/detect-concurrent-session.sh` — proactively warns at session start that another session is running. As of 2026-06-10 (Fix 1) its same-checkout sharp nudge is liveness-tightened (it reads the un-wrapped per-id marker set, so it no longer false-fires on your own already-wrapped same-day session). It is still only a **nudge** — a SessionStart hook cannot block — so the *enforcement* of the one dangerous move lives in `.claude/hooks/check-foreign-staging.sh` (Fix 2), a PreToolUse hook that blocks a cross-session commit from shipping another session's staged files.

**Do not restate or re-implement these here, and do not author a competing gate taxonomy.** Point at them. For pause/gate behavior during parallel work, the authority is `docs/autonomy-rules.md` (#1 destructive git ops, #2 external writes incl. push, #9 structural-change `/risk-check`).

### Quarantine the bookkeeping

The principle: **if no two sessions write the same file (logs included), there are zero conflicts.** Two ways to get there:

- **Serialized closing pass (default, no harness change).** Sessions do their work in isolation; logs are reconciled at the landing phase as unions (§ 5). This is what the current harness supports today.
- **Per-session log namespacing (a harness change — gated).** Giving each session its own log files removes the bookkeeping-conflict surface entirely. **This is not a free win.** It trades merge-conflicts for **history fragmentation** plus a reconciliation step, and it would change the marker contract's file-naming and tracking policy. It is a structural change: route it through `/risk-check`, update the `docs/session-marker.md` two-end registry, and present it as a tradeoff — never silently adopt it as "obviously better."

### The "[IN FLIGHT]" coordination marker — and its merge rule

A recognized parallel-coordination device: mark in-progress backlog items in `next-up.md` as `[~] [IN FLIGHT]` so no session double-starts them. **But this predictably creates a *content* conflict at merge:** main says "in flight — do not start," the executing branch says "resolved." The default "keep both" rule is **wrong** here — it produces contradictory entries.

**Resolution rule:** the executing branch's resolved state wins (it is the authoritative, more-recent truth; the in-flight marker was temporary). **Then sweep the whole file for any leftover `[~] [IN FLIGHT]` markers once all branches land** — every in-flight marker is stale post-merge, and resolving only the current branch's items leaves the backlog half-resolved.

**Alternative — go marker-free.** The file-ownership map (§ 2) already records "who owns what" without mutating the shared backlog. If you have the map, you may not need in-flight markers at all. Prefer the map; use in-flight markers only when you need a coordination signal visible *inside* the shared file, and apply the resolution rule above when you do.

---

## 4. Operating procedure (once you have decided to parallelize)

> **⚠ Anti-pattern — ad-hoc same-checkout parallelism (the #1 failure mode).** Do **not** start a second session by opening a new terminal in the *same working checkout* another session is already using. Two sessions sharing one working tree edit the same uncommitted files directly: one silently overwrites the other (a lost update), and the concurrent-session guards — which watch only `logs/session-notes.md` — never see it. This is exactly how the 2026-06-05 (S6) collision happened: two sessions in one checkout, the foreign session's uncommitted edits to a shared command file (`prime.md`) showed up in the other's `git status` with no guard firing (see `audits/2026-06-05-concurrent-session-collision-diagnostics-fix.md`, Mode A). **Planned parallel work starts with the serial planning session below (file-ownership map → worktree per unit), never by opening a second ad-hoc terminal.** If you only need a quick second session, run it in a *different project repo*, not a second checkout of this one.
>
> **Pre-flight check before adding an ad-hoc session.** If a session is already live and you are about to start another, run **`/concurrent-session-check <task>`** first (or `/concurrent-session-check` with no argument to see which backlog items are safe). It reads the live session's declared footprint and tells you whether your task would collide — the planning-time checker upstream of this anti-pattern. Advisory and read-only; it never blocks. A SAFE verdict still means "now isolate via `/new-worktree-session`" (file-safe ≠ checkout-safe).

1. **One upfront planning session** (serial — the highest-leverage step): decompose into independent units and write the file-ownership map (§ 2).
2. **Quarantine shared bookkeeping** (§ 3): serialized closing pass by default.
3. **One worktree + branch per unit,** off a known-good base. The worktree is the path of least resistance — run **`/new-worktree-session <unit>`** to create an isolated checkout + branch (`session/<date>-<unit>`) so sessions physically cannot share a working tree. The command wraps the underlying git and surfaces the worktree gotchas:

   ```bash
   # what /new-worktree-session runs, if you prefer to do it by hand:
   git worktree add ../<repo>-<unit> -b session/$(date '+%Y-%m-%d')-<unit> main
   cd ../<repo>-<unit>
   ```

   Open a new session in the worktree directory before doing any work (a command cannot move your shell there for you). Tear down per the § 5 teardown checklist when the unit lands.
4. **Stay in lane.** A session that finds it needs another unit's file **stops and flags** — it never crosses into a file it does not own. Crossing lanes is how a clean partition becomes a dirty merge.
5. **Deliberate landing pass** (§ 5) — never an afterthought.

---

## 5. Landing / merge procedure

These lessons were validated by *actually landing* a 3-branch run, then pushing and tearing it down. They are stronger than the pre-merge theory.

### Before the merge

1. **Keep the integration target clean — do no interactive work in `main` during a parallel run.** Treat `main` (the integration worktree) as a **pure landing target**: all work happens in feature worktrees. A merge cannot even start against a dirty tree. Make **"stash or clean the target first"** a mandatory pre-merge step.
2. **`git status` hygiene.** The SessionStart auto-sync hook copies shared commands/agents into every worktree's `.claude/`, where they show up as **untracked noise**. When judging "is this branch clean?", distinguish auto-synced shared resources (ignorable — they regenerate, never commit them) from real deliverables. Misreading them inflates the apparent dirty state.

### Doing the merge

3. **Merge the zero-conflict branch first.** Total conflict count is order-independent, but landing the clean branch first validates the flow and isolates the trivial unions before you hit anything fiddly — a cheap confidence check.
4. **Serialize merges one at a time; never batch-paste them.** A merge halts mid-conflict for resolution. The strict sequence is: `git merge <branch>` → resolve → `git add -A` → `git merge --continue` → *then* the next branch. Queuing multiple `git merge` lines fires the next into a half-merged tree and errors.
5. **Gate only the genuine (content) conflicts; let the unions flow.** The merging session resolves pure log-unions (§ 2, append-only shape) autonomously, but for any **content-shaped conflict** (backlog, index) it **pauses and shows the final merged file** before committing. Don't gate everything; gate exactly the conflicts where "keep both" is the wrong rule.

### After the merge — integration QC

6. **Integration QC is a per-file "both sides present" check, not just "no conflict markers left."** Grepping for leftover `<<<<<<<` / `[~]` / `IN FLIGHT` proves *clean resolution* but not *nothing dropped*. Separately confirm each shared file retains **both** its pre-existing entries **and** the new ones (e.g., the index has all sessions' entries; each log keeps old + new), plus that all deliverable content files are present. Each session's own QC never saw the others — integration QC is the only pass that sees the whole.

### The shared remote is multi-writer state too

7. **Divergence on a shared remote is a standing condition, not a closeable bug.** A shared repo (e.g., `ai-resources`) that many sessions push to suffers the same multi-writer problem at the **repo/remote level**. A push can be rejected by a non-fast-forward because other sessions advanced the remote — even by 15 commits — the same day. Do not frame "remote diverged, blocked my push" as a one-time bug to "fix and verify"; it is a **standing operating discipline**: `pull --rebase` before every push, push early and often in small increments. (Evidence it is not closeable-by-fix: an improvement-log entry marked "applied" for this issue coexisted with a live recurrence the same day.)
8. **Additive work is divergence-tolerant.** That rejected push resolved via a guaranteed-clean rebase because every local commit touched only a **brand-new file** that none of the incoming commits went near — zero overlap regardless of how far the base had moved. This is the file-ownership principle seen from the remote side: structure each session's output as new files, and the remote conflict surface nearly vanishes.

### Teardown — a named final phase

9. **"Merged + pushed" is not "closed."** Every parallel run has a teardown tail that must be a tracked phase, or it accumulates as cruft (stale worktrees invite commits to dead branches; forgotten stashes hide real edits). The teardown checklist:
   - **Remove worktrees + branches** (`git worktree remove` + `git branch -d` — the latter's merged-check is a safety net).
   - **Ordering hazard — never remove a worktree a live session occupies.** A session may still be open inside one of the worktrees (in the origin run, the integration-driving session was itself live in one). Tear down only worktrees with no live session, and **remove the integration-driving session's own worktree last.**
   - **Resolve or drop any parked `git stash`** from the pre-merge clean-up.
   - **Confirm no orphan session-state remains** (stray `.session-marker`, scratchpads, `session-plan` edits).

### Worked example of state-file leakage (cross-reference)

`logs/.prime-mtime` and `logs/.session-marker` are per-session transient state — written fresh each session, read within-session by the guards, **never meant to be shared through git.** In the origin project they were tracked or got committed, so every session re-committed them and they caused dirty-tree blocks before merges. The local fix: `git rm --cached logs/.prime-mtime logs/.session-marker` + add both to `.gitignore` + one cleanup commit (`--cached` keeps the local files so the harness still works). Because the harness writes these markers in **every** project, the same `.gitignore` lines almost certainly belong in every project's `.gitignore` — that workspace-wide sweep is a separate, `/risk-check`-scoped hygiene item, not part of running a parallel session. This is the canonical example of the "quarantine shared state" principle applied to transient markers.

---

## 6. When NOT to parallelize

Parallelism is not always the right model, and worktrees are not the only way to run concurrent work. This section is the brief's biggest open risk made explicit.

### Branch B — work that does not partition cleanly (the dominant non-parallel case)

The headline insight of the origin run — "100% of conflicts were in bookkeeping, none in the work" — is an artifact of work whose **content files partitioned naturally** (three independent deliverables, three disjoint file sets). For work that does *not* partition cleanly, conflicts land **in the work itself**, and "quarantine the logs" does nothing:

- Refactoring a shared codebase (the change ripples across many files multiple units touch).
- Editing one large document from multiple angles (every angle edits the same file).
- Any ripple-across-many-files change.

**The pre-spawn partitionability test (decisive, cheap):** draw the file-ownership map (§ 2) *first*. If you cannot assign every deliverable file to exactly one owner without overlap — if any deliverable is co-edited by two units — **the work is not cleanly partitionable.** Inability to draw the map *is* the test result; you do not need to predict conflicts.

For non-partitionable work, default to **do not parallelize.** The only parallel-flavored options are:
- **Serialize the core, fork the periphery.** Do the shared-file changes in one serial session, then parallelize only the genuinely independent edges (the § 1 gate-3 escape hatch).
- **Single session with checkpoints** (below).

### Alternatives to worktree-parallelism — and when parallel loses

Worktrees are one model among several. Compare honestly:

| Model | Best when | Parallel loses to it when |
|-------|-----------|---------------------------|
| **Worktree-parallel** | Clean partition, large independent units, high autonomy | — |
| **Sequential with good batching** | Units are small, or share files, or need frequent operator input | The merge cost + N× token cost exceeds the wall-clock saved. |
| **Single session with checkpoints** | One coherent thread of work; you want a save/resume point, not concurrency | Coordination overhead buys nothing because there is nothing to coordinate. |
| **Branches without worktrees** | You want isolated history but only one working tree at a time (no true concurrency) | You were never going to run sessions *simultaneously*. |
| **Separate clones** | Heavy filesystem isolation needed; worktree `.claude/` auto-sync noise is a problem | The setup/teardown cost dwarfs a short job. |

**Parallel loses outright when:** units are sub-session-sized; the work is edit-heavy on shared files; autonomy is low (many operator gates); or you are optimizing **cost** rather than wall-clock (see § 7).

---

## 7. Cost / efficiency-target disambiguation

"Run the work as efficiently as possible" is ambiguous — and the ambiguity changes the recommendation. There are **three different targets**, and they imply **three different playbooks.** Force the choice before deciding:

- **Wall-clock time** (finish soonest in real time). Parallelism's home turf — *if* the partition is clean and autonomy is high. This is the only target that justifies paying extra to run sessions at once.
- **Total effort** (least operator attention / fewest decisions). Often *sequential* wins: one decision-stream, no merge reconciliation, no integration QC. Parallelism can *increase* total effort by adding the merge + teardown phases.
- **Cost** (least tokens / compute). Parallelism almost always **loses** here: N sessions ≈ N× tokens/compute **plus** the dedicated merge session. Parallelism trades **money for wall-clock.** If cost is the target, prefer sequential.

State which target the operator is optimizing. The *same facts* yield different recommendations depending on the answer: clean partition + high autonomy + "wall-clock" → parallelize; that identical work under "cost" → sequential.

---

## 8. System Owner Decision Hook

_Provisional — see currency note below._ The decision rule the System Owner applies when advising whether a project's work should be parallelized (distinct from the operator-facing go/no-go of § 1):

> **System Owner decision hook.** Recommend parallel sessions only when the work clears three gates in order, and default to sequential when any is in doubt. **First, partitionability:** units must split into non-overlapping file sets (including shared indexes, backlogs, logs) and be additive-heavy (new files), because additions parallelize almost for free while shared-file edits are the entire conflict surface. **Second, granularity and independence:** each unit ≥ a full session with no dependency on another's output; if units share a prerequisite, extract it into a serial pre-step and fork only the independent remainder rather than refusing to parallelize. **Third, autonomy headroom:** per-session autonomy must be high enough that each session reaches its own QC without frequent operator gates, because the operator is a single serial resource and approval gates (merge, push, structural change) reconverge on the human regardless of how cleanly the work was split. If the work is edit-heavy on shared files, units are sub-session-sized, or autonomy is low, recommend **sequential-with-checkpoints** — the merge cost is deferred, not avoided, and low-autonomy parallel pays N× tokens to buy wall-clock the serial reconvergence spends back. State which target the operator optimizes — wall-clock, total effort, or cost — because the three imply different recommendations from the same facts.

**Currency note.** This hook was drafted with the `system-owner` agent as consultant. At drafting time the agent's persona/principles grounding files were not present on disk, so the hook's authority is provisional `[CITATION NEEDED]` — its *content* is grounded in real artifacts (the marker contract, autonomy rules, the origin run), but its standing as a settled System-Owner principle should be confirmed when the System Owner grounding base is restored. Treat it as the working decision rule until then.

---

## 9. Quick reference

1. **Draw the file-ownership map first.** Can't draw it without overlap → don't parallelize (§ 6, Branch B).
2. **Two co-dominant levers:** clean decomposition *and* high autonomy. Missing either → sequential.
3. **Bias to new files.** Additions parallelize free; shared-file edits are the whole conflict surface.
4. **Quarantine bookkeeping;** per-session log namespacing is a `/risk-check`-gated harness change, not a free win.
5. **Land deliberately:** clean target first, merge one branch at a time, gate only content conflicts, integration-QC for "both sides present," then **tear down** (live-session-aware ordering).
6. **The remote is multi-writer too:** `pull --rebase`, push small and often; divergence is a standing condition.
7. **Name the target:** wall-clock vs total effort vs cost — they give different answers.

---

## Related

- `docs/session-marker.md` — the per-session marker contract (within-session race fix; this playbook is the cross-branch layer above it).
- `docs/autonomy-rules.md` — the pause/gate authority for destructive git ops, pushes, and structural-change `/risk-check`.
- `.claude/hooks/detect-concurrent-session.sh` — proactive concurrent-session warning.
- `docs/compaction-protocol.md` — named checkpoints, relevant to the single-session-with-checkpoints alternative (§ 6).
