# Risk Check — 2026-07-14

## Change

Plan: logs/session-plan-2026-07-14-S1.md. Three-item bundle.

(1) Merge the unpushed branch `session/2026-07-13-research-workflow` (8 commits, 13 behind / 8 ahead of main, clean tree) into `main`, resolving conflicts in three append-only logs (`session-notes.md`, `decisions.md`, `improvement-log.md`) where main has ARCHIVED July entries the branch still carries — then remove its git worktree and delete the branch. The branch carries canonical work: `.claude/commands/deploy-workflow.md` (+176 L), `skills/claim-permission-gate/SKILL.md`, `skills/country-parity-checker/SKILL.md`, `workflows/research-workflow/SETUP.md`, and `logs/missions/research-workflow-deploy-fitness.md` which is `status: active` and currently invisible from main. Its worktree runs the ONLY divergent non-symlink copy of `prime.md` in the workspace (stale allocator, sha a0a24de11d16 vs canonical 31fe5952510d) — removing it is what closes the accepted one-sided marker-mutex gap documented in `docs/session-marker.md` § Known gap. Both sides carry a duplicate `## 2026-07-13 — Session S13` header.

(2) M-1: fold `/lean-repo`'s Q3 orphan/adoption lens into `.claude/commands/architecture-review.md` (which today has NO orphan lens) and wire `/architecture-review` into `/friday-checkup`'s quarterly tier. The lens was DEFECTIVE and was repaired in S12 (improvement-log 682-683, applied+verified) — the fold must carry the corrected version (CONFIRM-BEFORE-DELETE verdict, Investigate-only disposition, scanned-scope declaration, `projects/*/` grep widening, `/explore-section` known-positive instrument check). The original lens produced an operator-approved instruction to delete six commands, four in live use. `decisions.md` Decision 4 (2026-07-13) HELD M-1 solely because the lens was defective; that precondition is now discharged.

(3) Correct the stale RR-04/RT-2 row in `audits/lean-repo-2026-07-13.md` (says "retain until the worktree pilot validates a replacement"; the pilot closed in S4, commit 5fce38c).

Out of scope: R-3 (retiring `/lean-repo` — open operator decision); the session-liveness heartbeat.

## Referenced files

- `logs/session-plan-2026-07-14-S1.md` — exists
- `.claude/commands/architecture-review.md` — exists
- `.claude/commands/friday-checkup.md` — exists
- `.claude/commands/lean-repo.md` — exists
- `.claude/agents/lean-repo-auditor.md` — exists
- `.claude/commands/deploy-workflow.md` — exists
- `audits/lean-repo-2026-07-13.md` — exists
- `docs/session-marker.md` — exists
- `logs/improvement-log.md` — exists
- `logs/decisions.md` — exists
- `logs/missions/research-workflow-deploy-fitness.md` — not yet present on main (verified: exists on branch, blob `964eb601c339`)

## Verdict

RECONSIDER

**Summary:** Stage 1's merge is sound in substance but its falsification test is provably incapable of catching the failure it targets (main and branch both have exactly 11 session-notes headers, so the planned count check passes on a resolution that silently drops three main-side sessions), and Stage 2 (M-1) is net-additive complexity aimed at two un-inventoried consumers — a permanent project-local **fork** of `/architecture-review` and the six-command `system-owner` agent — neither of which the change names.

## Consumer Inventory

Grep run across `ai-resources/` and the workspace root (`projects/*/` included per the method requirement; the `ai-resources-research-workflow/` worktree excluded to avoid double-counting its own content).

| Consumer path | Reference type | Must change? |
|---|---|---|
| `projects/axcion-ai-system-owner/.claude/commands/architecture-review.md` | **fork** (real file, 114 L, NOT a symlink) | **yes** — un-anticipated |
| `ai-resources/.claude/agents/system-owner.md` | parses (Function C output shape) / invokes | **yes** — un-anticipated |
| `projects/axcion-ai-system-owner/.claude/shared-manifest.json` | documents (`commands.local: ["architecture-review", …]`) | **yes** if fork reconciled |
| `ai-resources/.claude/commands/lean-repo.md` | parses (Step 2 reads architecture-review output as INPUT) | no (but see D5 echo path) |
| `ai-resources/.claude/agents/lean-repo-auditor.md` | documents (boundary vs `/architecture-review`) | no |
| `ai-resources/.claude/commands/friday-so.md` | parses (consumes architecture-review output) | no |
| `ai-resources/.claude/commands/friday-checkup.md` | invokes (NEW — 0 mentions today; grep count 0) | **yes** — intended |
| `ai-resources/.claude/commands/implementation-triage.md` | documents | no |
| `ai-resources/.claude/commands/systems-review.md` | documents | no |
| `ai-resources/docs/ai-resource-creation.md` | documents (rule #7) | no |
| `ai-resources/docs/repo-architecture.md` | documents | no |
| `projects/axcion-ai-system-owner/CLAUDE.md` | documents | no |
| `projects/positioning-research/reference/skills/{claim-permission-gate,country-parity-checker}` | **imports** (symlink → canonical skills) | no — verified compatible |
| `projects/research-pe-regime-shift-advisory-gap/reference/skills/{claim-permission-gate,country-parity-checker}` | **imports** (symlink → canonical skills) | no — verified compatible |
| `ai-resources/.claude/commands/prime.md` Step 1d | parses (`logs/missions/*.md` for `^status: active`) | no — but behaviour changes |
| `ai-resources/.claude/commands/drift-check.md` Step 7a | parses (mission = second reference standard) | no — but behaviour changes |
| `ai-resources/.claude/hooks/auto-sync-shared.sh` | co-edits (symlinks commands into projects; `EXCLUDE_COMMANDS` includes `lean-repo`) | no |
| 24 × `prime.md` symlinks across projects/workspace | imports (→ canonical) | no |

**Total: 18 distinct consumer rows, 4 must-change** — of which **2 (`architecture-review` fork, `system-owner` agent) are not named anywhere in CHANGE_DESCRIPTION or the plan.** That gap is itself the headline blast-radius finding.

The `not yet present` target (`logs/missions/research-workflow-deploy-fitness.md`) has no consumers today by construction — it is invisible from main. The inventory above covers the *contract* it activates on merge: `/prime` Step 1d's `^status: active` scan and `/drift-check` Step 7a's mission-contract read.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- **Merging the active mission turns a per-session no-op into a per-session cost, permanently.** `prime.md:141` states Step 1d is "a **zero-cost no-op when none exist** — when no `logs/missions/` dir is present in any enumerated repo, this step adds no prompt, no menu item, and no brief line." Today `main` has zero active missions (verified: `logs/missions/` on main holds only `promote-rw-canonical.md`, a closed stub, plus `archive/` and a `settings-path-portability/` tree). Merging flips this on for **every future ai-resources session**.
- **The mission can consume the entire `/prime` menu.** `prime.md:201` builds one menu candidate per **unchecked `- [ ]` open thread** for missions whose repo == CWD_REPO; `prime.md:205` ranks **"urgent → mission → carryover → next-up"** with a **6-item cap**. The mission has 8 threads, of which 1 and 2 are `[x]` DONE (verified in the branch file) — leaving **6 unchecked threads** at rank-2 priority in a 6-item menu. Carryover and next-up items can be fully crowded out.
- Wiring `/architecture-review` into `/friday-checkup`'s quarterly tier adds one `system-owner` (Opus) subagent spawn ~4×/year — modest. But `/friday-checkup` is `model: sonnet` and already carries a >45-min runtime gate (`friday-checkup.md:112-113`); a full architecture-review is not costed into that estimate.
- No always-loaded file is touched; no new hook is registered. Commands are pay-as-used. That is what holds this at Medium rather than High.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` at any layer is modified by the described change; no `allow`/`ask`/`deny` entry is added, removed, or widened.
- `git worktree remove` and `git branch -D` are local operations on an **unpushed** branch — verified: `git branch -avv` shows `session/2026-07-13-research-workflow` with **no upstream and no remote ref**. No shared-state or force-push hazard.
- `system-owner`'s `Write` tool is already scoped to `projects/axcion-ai-system-owner/output/` (`system-owner.md:21`, ":23" — "You do NOT have `Edit`, `MultiEdit`, or `Bash`"). Wiring it into the quarterly cadence grants no new capability.
- Push remains batched to wrap per workspace CLAUDE.md. 11 commits currently unpushed (`main` is `[origin/main: ahead 11]`).

### Dimension 3: Blast Radius
**Risk:** High

Grounded in the Step 1.5 inventory: **18 consumers, 4 must-change, 2 of them un-anticipated.**

- **`/architecture-review` has a permanent project-local FORK that the change does not name.** `projects/axcion-ai-system-owner/.claude/commands/architecture-review.md` is a **real file** (114 lines, sha `4fd6353945ef`) — not a symlink — while 45+ sibling commands in that same directory ARE symlinks. `shared-manifest.json` declares it `commands.local`, and `auto-sync-shared.sh` skips local files by design. **Folding the lens into the canonical file leaves the fork lens-less, permanently and silently.** The fork is also *ahead* of canonical in two respects (an output-path counter suffix; a "do not read audit content into main session" optimisation), so the two are already diverging. `improvement-log.md` names only the canonical path as the M-1 target — the fork blindspot is systemic, not a one-off.
- **`/friday-checkup` resolves commands relative to cwd, and it `cd`s per scope.** `friday-checkup.md:118` — "Between scopes, `cd` to the scope's path first." If the quarterly wiring invokes `/architecture-review` while cd'd into `projects/axcion-ai-system-owner/`, it picks up the **fork** (lens-less). Invoked from the workspace root or `ai-resources/`, it picks up the canonical (lens-bearing). Same command, two behaviours, decided by cwd.
- **The Q3 output contract cannot be satisfied by editing the command alone.** `/architecture-review` is a thin orchestrator: Step 4 hands everything to `system-owner` with the instruction "**Apply the procedure in your agent definition**" (`architecture-review.md:74`). The agent's Function C output shape (`system-owner.md:117-127`) is **Header / Executive Summary / Findings by Severity (Blocking·Important·Note) / Recommended Actions** — it has no Q3 section, no disposition taxonomy, no scanned-scope line, and no known-positive-check line. To make the folded lens actually emit `no evidence of use in scanned scope → CONFIRM BEFORE DELETE`, an **Investigate**-only disposition, a scanned-scope declaration, and a `Q3 VOID` path, **`system-owner.md` must change too** — and that agent is shared by **six** commands (`/consult`, `/architecture-review`, `/implementation-triage`, `/systems-review`, `/friday-so`, `/so-monthly`; `system-owner.md:14`). Editing it is a six-command blast radius the change never mentions.
- **The merge is a live production change to two active research projects.** Verified by execution, not by reading the mission's claim: `projects/positioning-research/reference/skills/{claim-permission-gate,country-parity-checker}` and `projects/research-pe-regime-shift-advisory-gap/reference/skills/{…}` are **symlinks into `ai-resources/skills/`**, and both projects carry `.done` sentinels at `analysis/1.1/.claim-permission-gate.done` and `.country-parity-checker.done` — i.e. both have already **run** these skills. The branch changes their pre-flight input path.
- **That skill change is, however, verified SAFE** — the one place the plan's caution is fully vindicated by evidence. The old declared path `analysis/1.1/cluster-memos-refined/` is **ABSENT** in both projects; the new path `analysis/cluster-memos/1.1/` **EXISTS** in both, holding 5 and 4 files matching `*-memo-refined.md` respectively — exactly the pattern the fixed pre-flight globs for. The merge repairs a latent contract defect and breaks nothing. No must-change follows for these two consumers.

### Dimension 4: Reversibility
**Risk:** Medium

- The pre-merge tag (`git tag pre-merge-rw-2026-07-14`, plan Stage 1 step 1) is the right instinct and makes the *merge* trivially revertible.
- **`git worktree remove` + `git branch -D` are not covered by that tag and are not undone by `git revert`.** Content survives inside the merge commit, so the worktree is reconstructible (`git worktree add` from the merge commit), but it is a distinct manual step. One extra cleanup action → Medium, not Low.
- **Append-only log corruption is the reversibility tail-risk.** If a bad resolution drops main-side entries and is not caught before subsequent commits land on top, a revert cannot cleanly separate the loss from the good work layered above it. This is entirely contingent on the falsification test working — and as Dimension 5 shows, the planned test does not.
- Nothing is pushed (11 commits already unpushed; push batched to wrap). Rollback stays local until the operator confirms the push.

### Dimension 5: Hidden Coupling
**Risk:** High

- **The planned falsification test is provably incapable of catching the failure it exists to catch.** Measured directly:

  | file | main | branch | correct merged |
  |---|---|---|---|
  | `session-notes.md` (`^## `) | **11** | **11** | **15** |
  | `decisions.md` (`^## `) | 12 | 11 | 16 |
  | `improvement-log.md` (`^### `) | 60 | 57 | 62 |

  Plan Stage 1 step 2 captures `git show session/...:logs/session-notes.md | grep -c '^## '` — the **branch's** count — as the falsification target. That number is **11**. A wholesale `--theirs` resolution yields **11** and *passes*. A wholesale `--ours` resolution yields **11** and also matches main's pre-merge count. The correct union is **15**. **The check blesses the exact catastrophe it was written to prevent** — the same failure shape as the S13 lesson the plan itself quotes ("a green harness in the wrong environment is indistinguishable from no harness at all").

- **The plan's hazard model is inverted, and its protection rule is one-sided.** The stated hazard — "main archived July entries the branch still carries… a union-merge would RESURRECT them" — is **empirically false**. `logs/session-notes-archive-2026-07.md` is present at the **merge-base** (28 headers) and on **both** sides at **32 headers with identical header sets** (`diff` of sorted headers = empty; the two blobs differ by a single line). Both sides archived the same four sessions independently. Resurrection is not the risk.
  The **real** risk is the opposite: `main`'s live notes carry **S7, S9, S12**; the branch's carry **S10, S11, S13-thread2**. Each side has 3 unique entries; `decisions.md` has 5 main-only vs 4 branch-only; `improvement-log.md` has 5 main-only vs 2 branch-only. **Main has more unique content at risk than the branch does.** Yet the plan's resolution rule (Stage 1 step 4) reads: *"every **branch** entry survives somewhere"* — it protects only branch-side entries, and its ground-truth capture (step 2) reads only `git show session/...`. **Nothing in the plan protects main's S7/S9/S12, its 5 decisions, or its 5 improvement entries.**
- **Two live copies of a lens with a "body count," with no lockstep mechanism.** `lean-repo-auditor.md:113` — "This rule has a body count." After M-1 (with R-3 out of scope) the five Q3 guards exist in **two** command/agent pairs. Nothing keeps them in sync; a future repair to one will not propagate to the other. This is the precise failure mode Decision 4 held M-1 to avoid, reintroduced one layer up.
- **An echo path forms between the two copies.** `lean-repo.md:33-41` Step 2 reads `/architecture-review`'s output as an **input**. Once `/architecture-review` emits Q3 orphan findings, those findings are fed back into `lean-repo-auditor`, which independently runs Q3. Orphan findings can be restated as if independently corroborated.
- **The verification constants in the plan are stale and unreproducible.** Plan Stage 1 step 7 asserts "canonical `31fe5952510d`." I could not reproduce that hash by any method: canonical `ai-resources/.claude/commands/prime.md` is `shasum` **`454056cbd8c2`** / git blob **`ffe3bb131ca1`**. The stale value **`a0a24de11d16`** *does* match the worktree copy's full-file `shasum` exactly. The canonical constant appears to predate commit `54f09bb` (the allocator-mutex fix that changed canonical `prime.md`). An executor that literally checks "no divergent copy remains; canonical == `31fe5952510d`" will get a false FAIL — or, worse, will "correct" the real file toward a stale constant.
- **The `prime.md` census in the plan and in `docs/session-marker.md:97` is wrong.** Both claim "all 25 other copies are symlinks" and one divergent copy. Direct enumeration: **29 total = 24 symlinks + 5 real files.** The 5 real files are canonical (899 L, 105 allocator hits), the stale worktree copy (665 L, 78 hits), and **three unrelated 33-line files** with **zero** allocator content (`workflows/research-workflow/.claude/commands/prime.md`, its worktree twin, and a copy in `output/deploy-test-scratch-2026-06-12/`). **The plan's conclusion nevertheless HOLDS**: removing the worktree does eliminate the only divergent allocator-bearing copy. The reasoning is right; the census it rests on is not.

### Dimension 6: Principle Alignment
**Risk:** High

Principles-base (`projects/strategic-os/ai-strategy/principles-base.md`) was not read; grounding is taken from workspace `CLAUDE.md`, `docs/ai-resource-creation.md` rule #7 as cited in-repo, and the OP-IDs quoted verbatim inside `lean-repo.md` / `logs/decisions.md`.

- **Complexity-budget gate, rule #7 prong (a) — FAILS as scoped.** `lean-repo.md:128` — "A recommendation that introduces a new command/agent/gate must itself clear the `docs/ai-resource-creation.md` rule #7 complexity budget, or it is not a simplification." The audit's own net-simplification arithmetic depends on the **pair**: `audits/lean-repo-2026-07-13.md:242` — "retire the command, keep the lens, wire it (M-1 + R-3). Net: **−1 command, −1 agent, +1 invocation path**." **M-1 alone removes nothing and duplicates the lens: net +1 lens copy, 0 components retired.** R-3 is explicitly out of scope and is, per the change's own words, "an open operator decision (three sessions running)." The halfway state is where this will sit, and it is net-additive.
- **OP-12 (closure before detection) — direct tension, four days old.** `logs/decisions.md:195` (2026-07-13): *"detection has outrun closure (`principles.md § OP-12`), and **adding scans is the one remedy guaranteed not to work**."* Stage 2 wires an additional orphan **scan** into the quarterly cadence. Q3 findings are Investigate-only / CONFIRM-BEFORE-DELETE by construction — they generate operator questions, and their closer (`/friday-act`) is the same channel already named as congested.
- **OP-11 (loud revision, never silent drift) — the exception is left standing while the thing it justified is duplicated.** `lean-repo.md:15` ships `/lean-repo` under a *loudly-recorded* OP-11 exception and states its own exit: "If a future review finds the lens is used rarely, **the lean move is to fold it into `/architecture-review` and retire this command**." M-1 executes the first half of that sentence and drops the second. The change does not acknowledge that the OP-11 exception's justification evaporates in the intermediate state.
- **OP-5 (advisory vs enforcement) — clean.** The corrected Q3 stays advisory: `Investigate` disposition, never `Remove` (`lean-repo-auditor.md:71`, ":113"). The fold does not upgrade it to enforcement. No finding.
- **The lens itself is genuinely repaired — this half of the change's premise is verified.** All five guards are live on main: CONFIRM-BEFORE-DELETE verdict (`lean-repo.md:130`, `lean-repo-auditor.md:59`), Investigate-only disposition (`lean-repo-auditor.md:71`), scanned-scope declaration (`lean-repo-auditor.md:88-93`), `projects/*/` grep widening (`lean-repo-auditor.md:50-55`), and the `/explore-section` known-positive instrument check with a `Q3 VOID` path (`lean-repo-auditor.md:63`, ":95"). Decision 4's stated precondition is genuinely discharged. The problem with M-1 is not the lens — it is the shape of the fold.

The change does not loudly acknowledge any of the three tensions above, so this is drift rather than a recorded revision. Per the risk-check contract, an unacknowledged principle High has no technical mitigation and forces the verdict.

## Recommended redesign

- **Rescope: take the plan's own "Narrower" alternative — land Stage 1 and Stage 3, drop Stage 2 this session.** The plan already names this (`session-plan-2026-07-14-S1.md:83`, "This is the fallback if context gets constrained"). Promote it from fallback to primary. Stage 1 is independently valuable, closes the marker-mutex gap at its root, and surfaces an active mission that is currently invisible. Stage 3 is trivial bookkeeping. Neither depends on M-1.
- **Then take M-1 + R-3 together as one scoped decision session** — the pair is what clears rule #7 prong (a) ("−1 command, −1 agent, +1 invocation path"), and landing them together closes the duplicate-lens window inside a single session instead of leaving it open on an operator decision that has already slipped three sessions. That session's scope must explicitly include the two un-inventoried consumers: the **`projects/axcion-ai-system-owner/.claude/commands/architecture-review.md` fork** (reconcile it, or the lens never fires in the project that owns architecture reviews) and **`.claude/agents/system-owner.md` Function C** (the Q3 output contract — scanned-scope line, known-positive line, `Q3 VOID` path, Investigate-only disposition — cannot exist without editing it; it is shared by six commands).
- **Before Stage 1, replace the header-count check with a set-difference check.** The count check is not merely weak here, it is inverted: main and branch both have 11 `session-notes.md` headers, so it passes on a resolution that drops three main-side sessions. Capture header **sets** (not counts) from **both** sides before merging, then assert after:
  - `comm -23 main.hdrs merged.hdrs` → **must be empty** (nothing dropped from main — this is the check the plan is missing entirely)
  - `comm -23 branch.hdrs merged.hdrs` → **must be empty** (nothing dropped from branch)
  - `comm -12 merged-live.hdrs archive.hdrs` → **must be empty** (nothing resurrected out of the archive — the check the plan describes but never specifies)
  - assert **two distinct `## 2026-07-13 — Session S13` bodies** survive, disambiguated
  - expected merged totals, computed pre-merge: **session-notes 15, decisions 16, improvement-log 62.**
  Fix the plan's resolution rule symmetrically too — "every **branch** entry survives somewhere" protects only one side, and main is the side with more unique content at risk (3 notes / 5 decisions / 5 improvements vs the branch's 3 / 4 / 2).
- **Correct the stale verification constants before Stage 1 step 7 runs.** Canonical `prime.md` is `454056cbd8c2` (`shasum`) / `ffe3bb131ca1` (git blob), not `31fe5952510d`; the workspace holds 24 symlinks + 5 real `prime.md` files, not "25 symlinks + 1 divergent." Three of those real files are an unrelated 33-line workflow command with zero allocator content. The plan's conclusion survives — the worktree copy is the only divergent allocator-bearing file — but `docs/session-marker.md:97` carries the same wrong census and should be corrected in the same commit.

## Evidence-Grounding Note

All risk levels grounded in direct evidence — git object inspection (`git show`, `git ls-tree`, `git rev-parse`, `git merge-base`, `git worktree list`), filesystem enumeration (`find`, `shasum`, symlink resolution), and grep counts against the live repo and workspace, plus verbatim quotes with line numbers from the referenced files. Three claims in CHANGE_DESCRIPTION were tested and found false or unreproducible (the archive-resurrection hazard; the "25 of 29 symlinks / one divergent copy" census; the canonical `prime.md` sha `31fe5952510d`); one was tested and confirmed safe (the two skills' path change against the two live projects that symlink them). No training-data fallback was used.
