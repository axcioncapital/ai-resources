# Risk Check — 2026-07-13

## Change

Change: /prime's session-marker ALLOCATION logic (3 identical bash blocks, Steps 8a.3.a / 8b.3.a / 8c.3 of .claude/commands/prime.md), plus a new "## Marker allocation" section in docs/session-marker.md documenting the contract those blocks implement.

WHAT CHANGED. Old rule: N = (shared marker file logs/.session-marker) + 1; a session-notes.md header-scan was used ONLY as an else-branch when the marker file was absent. New rule: N = 1 + MAX of three sources, always — (a) logs/.session-marker, (b) session-notes.md in the working tree, (c) session-notes.md across ALL refs via `git grep ... $(git for-each-ref --format='%(refname)' refs/heads) -- logs/session-notes.md`. Source (c) is new.

WHY. A git worktree is a separate checkout with its own gitignored logs/.session-marker and its own working-tree session-notes.md — both invisible from the main checkout. So worktree sessions allocate S{N} from the same namespace with no shared allocator (split-brain counter). Real incident today (2026-07-13 S6): the marker file said S4; the branch being merged already carried a committed "## 2026-07-13 — Session S5" header; the old rule would have allocated S5 — an exact duplicate header landing on merge. A duplicate S{N} breaks the `grep -Fxq "## {date} — Session {MARKER}"` "does my header exist" test used by /prime 8a, /session-start Step 3, and /session-plan Step 0 (each would match the WRONG entry, and a wrap could append its summary under a foreign session's header), and it collides the logs/session-plan-{date}-S{N}.md filename.

BLAST RADIUS (already enumerated by the main session): prime.md exists in 27 places workspace-wide — 24 are SYMLINKS to the canonical ai-resources/.claude/commands/prime.md (fix propagates automatically); 3 are real files: the canonical (the edit target), plus workflows/research-workflow/.claude/commands/prime.md and output/deploy-test-scratch-2026-06-12/.claude/commands/prime.md, which are 33-line stubs containing NO marker block at all (verified by grep) and are therefore claimed unaffected.

VERIFICATION ALREADY DONE (by execution, not review): (1) a test harness created a real branch carrying a colliding S{N} header via git commit-tree, and ran old vs new logic against it — old logic allocates the EXACT duplicate S7, new logic steps over to S8; baseline with no branch: both agree on S7 (no regression); the harness restored the index, deleted the sim branch, repo verified clean. (2) The edited block was extracted verbatim from prime.md, `bash -n` passed, and it executed against the live repo, correctly allocating S7. Session markers were restored to S6 afterward.

KNOWN GAP BEING ACCEPTED (scrutinise this): source (c) sees only COMMITTED headers. Two sessions that /prime in different checkouts where neither has committed its header yet can still collide — no ref exists to observe. The claim is that this is unclosable read-side without reintroducing a shared allocator (the exact coupling worktrees exist to remove), and is strictly narrower than the bug it replaces. Documented as a known gap in docs/session-marker.md.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md` — exists (MODIFIED, uncommitted)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md` — exists (MODIFIED, uncommitted)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md` — exists (consumer)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md` — exists (consumer)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md` — exists (consumer)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/close-worktree-session.md` — exists (consumer)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh` — exists (consumer)

## Verdict

**PROCEED-WITH-CAUTION**

**Summary:** The change is correct, degrades safe, and is confirmed by independent execution against a *real* `git worktree` — including a latent destructive bug it incidentally fixes — but it leaves a stale contract-registry entry inside the very doc it edits, which is a must-fix before commit.

**Headline:** every one of the five adversarial questions resolves in the change's favour. Independent testing found **no** word-splitting hazard, **no** path to a destructive S1-over-S5 reset, **no** contiguity assumption in any consumer, negligible cost, and confirmed the two non-symlink forks are genuinely unaffected. The single real finding is documentation drift (Mitigation 1).

## Consumer Inventory

Search terms: `session-marker`, `— Session S`, `session-marker.md`, `prime.md`, `.session-marker-`, `S{N}` arithmetic. Grepped across `ai-resources/` and the workspace root (`--exclude-dir=.git`, symlinks de-duplicated to their canonical target).

**Runtime consumers of the `S{N}` namespace / marker contract:**

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/prime.md` (canonical; 3 blocks @ L265/L342/L435) | co-edits (the change) | yes — done |
| `ai-resources/docs/session-marker.md` § Marker allocation (L53–75) | co-edits (the change) | yes — done |
| `ai-resources/docs/session-marker.md` § Two-end registry (**L169**) | documents | **yes — NOT DONE (stale)** |
| `ai-resources/.claude/commands/session-start.md` (Step 3) | parses (`^## {date} — Session ${MARKER}`) | no |
| `ai-resources/.claude/commands/session-plan.md` (Step 0, Step 7) | parses (header + `session-plan-{date}-{MARKER}.md`) | no |
| `ai-resources/.claude/commands/wrap-session.md` (Steps 3.5 / 6.4 / 13) | parses / invokes | no |
| `/.claude/commands/wrap-session.md` (workspace-root paired copy) | parses | no |
| `ai-resources/.claude/commands/close-worktree-session.md` (L99–118) | parses (`logs/.session-marker-*` liveness) | no |
| `ai-resources/.claude/commands/new-worktree-session.md` | documents / invokes | no |
| `ai-resources/.claude/commands/concurrent-session-check.md` (Steps 2–3) | parses (per-id markers + plan glob) | no |
| `ai-resources/.claude/commands/contract-check.md` (Step 2b) | parses (glob `session-plan-*${MARKER}.md`) | no |
| `ai-resources/.claude/commands/drift-check.md` (Steps 3/6/7/8) | parses (same glob) | no |
| `ai-resources/.claude/commands/open-items.md` | parses (glob `session-plan-*.md`) | no |
| `ai-resources/.claude/commands/decide.md` (Step 2) | parses (same glob) | no |
| `ai-resources/.claude/commands/mission.md` | parses (header) | no |
| `ai-resources/.claude/commands/clarify.md` | documents | no |
| `ai-resources/.claude/commands/blindspot-scan.md` | documents | no |
| `ai-resources/.claude/commands/new-project.md` | documents (scaffold) | no |
| `ai-resources/.claude/agents/fix-repo-issues-scanner.md` | parses (glob) | no |
| `ai-resources/.claude/hooks/check-foreign-staging.sh` (L239–248) | parses (`^##\s+{date}\s+—\s+Session\s+{sess}`) | no |
| `ai-resources/.claude/hooks/detect-concurrent-session.sh` | parses (`logs/.session-marker-*`) | no |
| `ai-resources/.claude/hooks/backup-session-plan.sh` (L20 regex) | parses (plan filename) | no |
| `ai-resources/logs/scripts/foreign-session-guard.sh` | parses (header + markers) | no |
| `ai-resources/logs/scripts/run-manifest.sh` | parses (marker) | no |
| `ai-resources/skills/handoff/SKILL.md` (Step C3) | invokes (`rm` per-id marker) | no |
| `~/.claude/hooks/cleanup-session-marker.sh` (SessionEnd) | invokes (`rm` per-id marker) | no |
| `ai-resources/.gitignore` | documents (`logs/.session-marker*`) | no |
| 24 × `prime.md` symlinks → canonical | imports | no (auto-propagate) |
| `ai-resources/workflows/research-workflow/.claude/commands/prime.md` | — (33-line stub, 0 marker refs) | no |
| `ai-resources/output/deploy-test-scratch-2026-06-12/.claude/commands/prime.md` | — (33-line stub, 0 marker refs) | no |

**Total: 30 distinct consumers (+24 symlink importers). 3 must-change; 2 done, 1 outstanding** (`docs/session-marker.md` L169 — see Mitigation 1).

The decisive inventory fact: **the allocation logic has exactly one consumer — `/prime` itself.** Every other consumer *resolves* a marker it was handed and does an exact-match lookup. None re-derives `N`. This is what makes the blast radius narrow despite the large consumer count.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- **No always-loaded file touched.** The diff modifies only `.claude/commands/prime.md` (a slash command, loaded on invocation) and `docs/session-marker.md` (a reference doc, loaded on demand). No workspace/repo `CLAUDE.md`, no `@import`, no new hook registration. `git diff --stat` shows 2 files.
- **No new hook, no per-tool-call cost.** The change registers nothing. It adds two read-only git calls *inside an existing bash block that already ran* at `/prime` time — once per session, not per turn.
- **Runtime cost is negligible — measured, not asserted.** On the live `ai-resources` repo (1 branch, 543-line `session-notes.md`): `real 0.02–0.03s`. On a synthetic stress repo (204 branches, 3,203-line `session-notes.md`): `real 0.04s`, stable across 3 runs. Answers adversarial Q3: it does **not** degrade with branch count or notes history at any plausible scale. Git's ref iteration and `git grep` are both O(matched blobs), and the date-anchored pattern (`^## ${TODAY} —`) means stale branches contribute nothing.
- **Token cost: ~42 added lines to `prime.md`** (a 14-line rationale comment × 3 copies). Modest, and `prime.md` is already 665 lines. **Leanness nit (not a risk):** the same rationale now exists in three places in `prime.md` *and* in `docs/session-marker.md` § Marker allocation. The in-code comment could be cut to ~3 lines plus a pointer to the doc, since the doc is explicitly declared "the authority on how `S{N}` is chosen" (session-marker.md L39). Optional; the triplication is a deliberate lockstep-visibility choice and defensible as-is.

### Dimension 2: Permissions Surface
**Risk:** Low

- **No permission change of any kind.** `git diff` touches zero `settings.json` / `settings.local.json` files. No `allow`/`ask`/`deny` entry added, removed, or widened.
- **No new capability class.** The two new commands (`git for-each-ref`, `git grep`) are **read-only** git plumbing. They write nothing, mutate no refs, and touch no network. The block already invoked `cat`, `grep`, `echo`, and `date` in the same shell context.
- **No scope escalation.** Nothing moves between settings layers; no cross-repo or external-API reach is introduced. `git grep` is confined to the current repo's own object store by construction.

### Dimension 3: Blast Radius
**Risk:** Medium

- **30 consumers found; 3 must-change; 2 done, 1 outstanding.** Per the Step 1.5 inventory.
- **The allocation contract has exactly ONE consumer: `/prime` itself.** No other file re-derives `N`. Every other consumer *resolves* an already-assigned marker and does exact-match lookup (`session-start.md` L306–313, `session-plan.md` L13–28) or an order-independent glob (`contract-check`, `drift-check`, `open-items`, `decide`, `fix-repo-issues-scanner`). This is the fact that keeps the radius narrow.
- **The externally-visible contract is UNCHANGED and backwards-compatible.** Marker format (`S{N}`), header format (`## {date} — Session S{N}`), and plan filename (`session-plan-{date}-S{N}.md`) are all byte-for-byte identical to before. The *only* behavioural delta is that `N` may now **skip** values. See the contiguity finding below.
- **Adversarial Q4 — contiguity — ANSWERED: no consumer assumes contiguity.** Grepped every consumer for decrement arithmetic, `seq`, and `for i in` loops over markers. Result: the **only** marker arithmetic in the entire repo is `MARKER="S$((HIGH + 1))"` at `prime.md` L295/L372/L465 — the allocator itself. The one other `- 1` hit (`detect-concurrent-session.sh:104`, `OTHERS=$((SESSION_COUNT - 1))`) is a **pgrep process count**, not a marker number. Markers are used as **identifiers**, never as indices. A gap in the sequence (S6 → S8) is therefore inert. **Verified, not assumed.**
- **Adversarial Q5 — the two forks — ANSWERED: the main session is CORRECT.** Independently verified: `find` returns 24 symlinks + 3 real files. The two non-canonical real files (`workflows/research-workflow/…/prime.md`, `output/deploy-test-scratch-2026-06-12/…/prime.md`) are both **33 lines** with **0 hits** for `session-marker` and **0 hits** for `Session S`. They contain no allocation block. Genuinely unaffected.
- **Lockstep triplet holds (this is BLOCKING per the registry).** Verified programmatically: the 3 allocation blocks at `prime.md` L265 / L342 / L435 are **byte-identical after indent normalisation**. The registry (session-marker.md L169) declares divergence here would make the numbered-pick (8a), free-text (8b), and auto-mode (8c) paths resolve `N` differently. No divergence.
- **Both-or-neither writer invariant INTACT.** Confirmed the edit did not disturb the lines below it: in all 3 blocks the shared `echo "${TODAY} ${MARKER}" > logs/.session-marker` is still immediately followed by `[ -n "${CLAUDE_CODE_SESSION_ID}" ] && echo "${TODAY} ${MARKER}" > "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}"`. The change is strictly *above* the write pair and only alters how `MARKER` is computed.
- **DRIVER OF THE MEDIUM — a must-change consumer was missed, inside the edited file itself.** `docs/session-marker.md` **L169** (§ Two-end contract registry) still describes the **removed** code: *"the `if [ -f logs/.session-marker ] … else … fi` block, including the 2026-07-03 absent-marker fallback that resumes `N` … via `grep -oE … | sort -n | tail -1`"*. There is no longer an `else` branch and no `sort -n | tail -1` pipeline. The doc now carries **two mutually inconsistent descriptions of the allocator** — the new § Marker allocation (correct) and this stale registry entry (describes deleted code). The registry is precisely the maintainer-facing authority on what must stay in lockstep, so its being stale is the highest-value defect in this change. No runtime break (hence Medium, not High). See Mitigation 1.
- **Amplification note (accepted, not a defect).** The 24 symlinks mean the change reaches every project's `/prime` the instant it is committed, with no per-project review. This is how every prior `prime.md` fix has shipped, and the change degrades safe everywhere (Dimension 5), so the amplification is priced in rather than adverse.

### Dimension 4: Reversibility
**Risk:** Low

- **Clean two-file `git revert`.** The change is confined to `.claude/commands/prime.md` and `docs/session-marker.md`. Both are tracked, edit-in-place text files. No sibling files or directories are created; no settings state is cached; nothing is pushed or written externally.
- **No automation can fire between landing and revert.** The change registers no hook, cron, or symlink. It only runs when `/prime` is explicitly invoked.
- **Burned marker numbers do not corrupt a revert — checked.** If the new logic allocates a *skipped* number (e.g. S8 while local state shows S6) and the change is then reverted, the old logic reads `logs/.session-marker` (now `S8`) and continues from `S9`. No collision, no corruption; the skipped `S7` simply never exists, which is inert (see the contiguity finding). The revert is genuinely clean, not clean-with-caveats.
- **`logs/.session-marker` is gitignored** (session-marker.md L33), so a revert does not need to reason about committed marker state at all.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Adversarial Q1 — unquoted `$(git for-each-ref …)` — ANSWERED: NO hazard. Verified by execution, not by reasoning.**
  - **The Bash tool runs `zsh` 5.9, not bash** (probed: `$0 = /bin/zsh`, `ZSH_VERSION=5.9`, `BASH_VERSION=none`). This is the right thing to have worried about — zsh does **not** word-split unquoted `$var`. But zsh **does** field-split unquoted *command substitutions*. Tested directly: with 4 branches present, the verbatim block allocated the correct `S6` under **both** `bash` and `zsh`. The concern is real in principle and does not bite here.
  - **The live repo has exactly 1 branch** (`refs/heads/main`), which is precisely the condition under which a word-splitting bug would hide. I therefore tested against a purpose-built **multi-branch** repo (4 branches, incl. `feature/wt`) rather than the live one. Correct under both shells.
  - **Refname hazards are impossible by git's own rules — confirmed against the live binary.** `git check-ref-format` **rejects** `refs/heads/has space` and `refs/heads/has*star`; `git branch -- '-weird'` is rejected. So spaces, glob metacharacters, and leading-dash (flag-injection) refnames cannot be constructed. Unquoted expansion is safe here *because git guarantees the tokens are shell-safe*, and refnames are `refs/heads/…`-prefixed so they can never parse as a flag.
  - **Hostile IFS tested:** running the block with `IFS=:` still allocated the correct `S6`.
  - **`git grep -h` correctly suppresses the `rev:file:` prefix** — verified by inspecting raw output. Without `-h` the output is `refs/heads/feature/wt:logs/session-notes.md:## … S5`; with `-h` it is `## … S5`. (Even unprefixed, `grep -oE '[0-9]+$'` would still extract correctly, so this is belt-and-braces.) `git grep -o` requires git ≥ 2.19; the live binary is **2.50.1**.
- **Adversarial Q2 — the highest-severity question — ANSWERED: a git failure CANNOT allocate S1 over an existing S5. Structurally impossible, and tested.**
  - The structural guarantee: `HIGH` is seeded from source **(a)** (`logs/.session-marker`) **before** the loop, and the loop body is `[ "$n" -gt "$HIGH" ] && HIGH="$n"` — it can only ever **raise** `HIGH`, never lower or reset it. A failing `git` contributes *zero values*, which is a no-op.
  - **Test T2 — not a git repo at all** (all git calls fail), marker `S5`, tree header `S5` → allocated **S6**. Not S1.
  - **Test T3b — `git` shadowed by a stub that exits 128**, marker `S5` → allocated **S6**. Not S1.
  - **Test T6 — marker ahead of branches** (marker `S9`, branch `S5`) → allocated **S10**. No regression.
  - **Test T4 — genuinely fresh repo** (no marker, no notes) → allocated **S1**. Correct.
  - The one theoretical path to a destructive `S1` is a failure of **`date`** (empty `TODAY` ⇒ no pattern matches). That is (i) not a git failure, (ii) implausible, and (iii) **pre-existing and identical in the old code** — the old block also collapses to `N=1` when `TODAY` is empty. Not a regression introduced here.
  - **BONUS — the change silently fixes a latent DESTRUCTIVE bug.** Test T5: with a **corrupt** `logs/.session-marker` (garbage content) and an existing `S5` header, the **OLD** logic allocates **`S1`** — an exact duplicate over live state — because the file *exists*, so the `if` branch is taken, the `case` fails to match, and the `else` (notes-scan) fallback is never reached. The **NEW** logic allocates **`S6`**. The union rule eliminates a real destructive path that the old if/else structure contained. This strengthens the case for the change beyond its stated rationale.
- **The load-bearing architectural assumption of source (c) — VERIFIED on a real `git worktree`, not a simulated branch.** The main session tested with `git commit-tree` against a synthetic branch. I built an actual `git worktree add` and confirmed the assumption it rests on: **a worktree shares `refs/heads` with the main checkout** (main's `for-each-ref` lists `refs/heads/wt-session`) while keeping its **own gitignored `logs/.session-marker`** (main `S3` / worktree `S1` — the split-brain counter, reproduced). I then reproduced the exact incident: main marker `S3`, worktree commits an `S4` header → **OLD logic allocates the duplicate `S4`; NEW logic allocates `S5`.** The bug is real and the fix works on the genuine mechanism, not just an analogue.
- **New implicit dependencies introduced (both documented at the change site — this is what holds the dimension at Medium rather than High):** (1) git's worktree ref-sharing semantics; (2) commit-timing — (c) observes only *committed* headers. Both are named explicitly in `docs/session-marker.md` § Marker allocation (L63–73), including the **Known gap** paragraph. The accepted gap is correctly characterised: it is strictly narrower than the bug it replaces (which fired on *every* merged worktree session regardless of commit state), and closing it read-side would require the shared allocator worktrees exist to eliminate. I concur with accepting it.
- **Mild OP-3 tension (advisory, not a blocker).** Source (c) suppresses stderr twice (`2>/dev/null`), so if git ever fails, the union silently degrades to (a)+(b) with **no operator-visible signal** — losing worktree protection quietly. This sits in tension with the repo's "loud failure over silent continuation" principle, and notably with this same doc's § Marker resolution, which *does* emit a loud fallback line (`[marker] Note: … falling back to shared logs/.session-marker (clobber-vulnerable)`). It is **not silent drift** — the § Marker allocation "Cost" paragraph (L75) explicitly states the fallback is intended — and the degrade is provably safe. Optional hardening in Mitigation 2.
- **Stale registry entry** (L169) is also a coupling defect — cross-referenced from Dimension 3; see Mitigation 1.

### Dimension 6: Principle Alignment
**Risk:** Low

Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md` (present, 41 active principles).

- **OP-9 / DR-7 / AP-7 (speculative abstraction) — NOT violated; the change is the opposite.** DR-7 licenses generalization only on a *second confirmed consumer*, and AP-7 names "hooks for Phase 2" as the anti-pattern. Source (c) is not speculative infrastructure: it closes a **confirmed, reproduced, dated** failure (2026-07-13 S6, re-reproduced by me on a real worktree above). Zero new components, zero new commands, zero new gates. This is a bug fix to an existing block.
- **Complexity-budget gate (`docs/ai-resource-creation.md` rule #7) — NOT APPLICABLE.** The change introduces **no** new command, agent, mandatory stage/gate, or always-loaded doc. It modifies an existing block and adds a section to an existing on-demand reference doc. The creation gate does not fire.
- **OP-12 (closure before detection) — SERVED, not violated.** The change adds no new scan, audit, flag, or finding-generator. It is a **structural correction** that prevents the failure rather than a detector that reports it. This is the direction OP-12 asks for.
- **OP-5 (advisory vs enforcement) — untouched.** No advisory mechanism is upgraded to enforcement. The allocator was already a write path; it gains no blocking authority and no auto-correction of anything outside its own variable.
- **OP-2 (automate execution, gate judgment) — aligned.** Choosing the next integer in a namespace is *routine execution*, not a judgment call. Automating it more correctly is exactly what OP-2 licenses; no operator gate is removed and none should be added.
- **OP-10 (system boundary is Claude Code only) — untouched.** Nothing reaches beyond Claude Code; `git` is local and already in-boundary.
- **DR-1 / DR-3 (placement) — correct.** The allocator logic stays in the command that owns it (`/prime`), and the *contract* documentation goes to the existing canonical doc (`docs/session-marker.md`) rather than a new file. Right tier, right home.
- **DR-8 (gated structural changes require plan-time and end-time `/risk-check`)** — this report is the end-time gate; DR-8 is being satisfied, not bypassed.
- **OP-3 (loud failure over silent continuation) — mild, documented tension, not a violation.** The `2>/dev/null` silent degrade of source (c) is the one place the change sits against a principle. It is documented as intentional at the change site (session-marker.md L75) and degrades provably safe, so it is a *stated design choice*, not silent drift — which is precisely the distinction OP-11 draws. Scored as a noted tension; hardening offered in Mitigation 2, not required.
- **Structural-fix-as-default-style (workspace CLAUDE.md § Working Principles) — honoured.** The change is a structural fix (the allocator now derives `N` from the true state of the namespace) rather than a patch (e.g. hand-bumping the marker file, or adding a duplicate-header warning). This is the default style the workspace mandates.

## Mitigations

- **[REQUIRED — Dimension 3, and the only must-fix in this change] Update the stale contract-registry entry at `docs/session-marker.md` L169.** It still describes the deleted code: the `if [ -f logs/.session-marker ] … else … fi` block and the `grep -oE … | sort -n | tail -1` absent-marker fallback. Neither exists any more. Replace that clause with a pointer to the new **§ Marker allocation** (already declared "the authority on how `S{N}` is chosen" at L39), and **carry forward the two warnings that currently live only in the stale entry**, because they are still true of the new code and are otherwise lost: (i) the pattern matches the em-dash `—` **literally** (an ASCII hyphen silently matches nothing and regresses toward `N=1`), and (ii) the max is **numeric, not lexical** (`S10 > S9`) — I verified the new block preserves both (test T8: branch carrying `S10` + marker `S2` → correctly allocates `S11`, not `S3`). Keep the "**triplicated byte-identical across these three steps** … verify by execution, not review" instruction — it is still exactly right, and the new blocks satisfy it.
- **[OPTIONAL — Dimension 5, OP-3 hardening] Consider one loud line when source (c) is unavailable.** E.g. emit `[marker] Note: cross-ref allocation check unavailable (not a git repo, or git failed) — falling back to local sources only.` when the `git` calls fail, mirroring the existing loud-fallback precedent in § Marker resolution. This converts a silent capability loss into a visible one. Low priority: the degrade is provably safe (T2/T3b), and in a non-git directory there are no worktrees to protect against, so (c) has nothing to contribute anyway. Declining this is defensible — the silence is already documented as intended.
- **[OPTIONAL — Dimension 1, leanness] Consider trimming the 14-line rationale comment** (triplicated = ~42 lines) to ~3 lines plus a pointer to `docs/session-marker.md` § Marker allocation, which now states the same rationale at greater length. The triplication is defensible as lockstep-visibility; this is a preference, not a defect.

## Evidence-Grounding Note

All risk levels grounded in direct evidence. Every adversarial question was answered **by execution against purpose-built test repositories** (including a real `git worktree`), not by reading the code — per the repo's own standing instruction to verify shell behaviour by execution rather than review. Specifically: shell identity probed (`zsh` 5.9); word-splitting tested under both `bash` and `zsh` with 4 branches and with hostile `IFS`; refname hazards tested against the live `git check-ref-format` (2.50.1); the S1-reset regression tested across 4 failure modes (no-git-repo, failing-git-stub, corrupt-marker, marker-ahead); cost measured with `/usr/bin/time` at 1 branch and at 204 branches; contiguity assumptions grepped across all consumers; the fork claim re-derived independently with `find` + `grep`; the lockstep triplet checked byte-for-byte programmatically; the writer invariant confirmed by inspecting the lines below the edit. No training-data fallback was used. The one finding that is *not* execution-derived (the stale registry entry at L169) is a verbatim quote from the file as it stands in the working tree.
