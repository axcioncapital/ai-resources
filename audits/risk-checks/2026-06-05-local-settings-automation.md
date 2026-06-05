# Risk Check — 2026-06-05

## Change

Proposed structural change: introduce a self-provisioning machine-settings system across the Axcíon AI workspace so machine-specific paths never live in tracked .claude/settings.json. Two new shared hooks (drafts verified and staged, NOT yet wired) at ai-resources/audits/working/local-settings-automation-draft/: (1) auto-provision-local-settings.sh — a SessionStart hook that derives the workspace root by walking up from $CLAUDE_PROJECT_DIR to the folder containing ai-resources/ (same logic as auto-sync-shared.sh), then creates .claude/settings.local.json with permissions.additionalDirectories=[derived root] if missing, and ensures .gitignore ignores it; never overwrites an existing local file, never writes the tracked settings.json, no-ops outside the workspace, idempotent, pure bash. (2) pre-commit-guard.sh — a pre-commit hook (opt-in via git config core.hooksPath .githooks) that blocks any commit putting a /Users/ path or a "model" field into a tracked settings.json. Also a one-time manual Layer 1 cleanup: strip /Users/ paths and any "model" field from every tracked settings.json across ~10 repos, commit and push (needs Patrik coordination). Wiring options for Layer 2 in README: (a) per-project settings.json SessionStart entry calling the shared hook, or (b) appending into auto-sync-shared.sh (documented as NOT recommended). Full plan, caveats (settings load-timing one-session lag, gitignore-append diff, Layer 1-before-Layer 3 ordering, additionalDirectories union semantics), and wiring in the draft README.md. Evaluate the risk of wiring Layers 2 and 3 live and doing the Layer 1 cleanup.

## Referenced files

- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/audits/working/local-settings-automation-draft/auto-provision-local-settings.sh — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/audits/working/local-settings-automation-draft/pre-commit-guard.sh — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/audits/working/local-settings-automation-draft/README.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/auto-sync-shared.sh — exists (reference)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The design is sound and serves real principles (machine paths out of tracked files, no "model" drift), but landing it touches a 9-file blast radius, mutates always-loaded SessionStart and pre-commit infra on two machines, and one step (Layer 1 cleanup) pushes to a shared remote that git revert cannot cleanly undo — so it requires sequenced, paired mitigations before going live.

## Consumer Inventory

The change targets three contracts: (a) the SessionStart hook chain, (b) the per-repo `.claude/settings.json` shared file, and (c) the `.gitignore` convention for `settings.local.json`. Search terms: `settings.local.json`, `auto-provision-local-settings`, `pre-commit-guard`, `core.hooksPath`, `additionalDirectories`, `.githooks`, `auto-sync-shared`, `SessionStart`. The two new hook files themselves have **zero current consumers** (the `auto-provision-local-settings` and `pre-commit-guard` greps returned no hits outside the draft dir) — they are `not yet present` in any live chain. The inventory below covers the consumers of the *contracts they touch*.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `.claude/settings.json` (workspace root) | co-edits (Layer 1: strip `/Users/` path) | yes |
| `ai-resources/.claude/settings.json` | co-edits (Layer 1 strip) | yes |
| `projects/nordic-pe-screening-project/.claude/settings.json` | co-edits (Layer 1 strip) + invokes (SessionStart wiring host) | yes |
| `projects/project-planning/.claude/settings.json` | co-edits (Layer 1 strip) | yes |
| `projects/brand-book/.claude/settings.json` | co-edits (Layer 1 strip) | yes |
| `projects/repo-documentation/.claude/settings.json` | co-edits (Layer 1 strip) | yes |
| `projects/repo-documentation/vault/.claude/settings.json` | co-edits (Layer 1 strip) | yes |
| `projects/interpersonal-communication/knowledge-base/.claude/settings.json` | co-edits (Layer 1 strip) | yes |
| `projects/interpersonal-communication-copy/knowledge-base/.claude/settings.json` | co-edits (Layer 1 strip) | yes |
| `ai-resources/.claude/hooks/auto-sync-shared.sh` | co-edits (wiring option (b), if chosen — README marks NOT recommended) | no (option (a) chosen) |
| `projects/nordic-pe-macro-landscape-h1-2026/.claude/settings.json` | invokes (existing SessionStart walk-up; sibling pattern Layer 2 (a) mirrors) | no |
| `.gitignore` (per repo) + `ai-resources/.gitignore` | parses (hook appends `.claude/settings.local.json` ignore line) | no (append is additive/idempotent) |
| `ai-resources/docs/permission-template.md` | documents (canonical settings shapes; should record the local-vs-tracked split) | no (doc currency) |
| `ai-resources/CLAUDE.md` § Model Selection / workspace CLAUDE.md § Model Tier | documents (prohibits `"model"` field — the guard enforces this) | no |

**Total: 14 consumers, 9 must-change** (all 9 must-change rows are the tracked `settings.json` files carrying a `/Users/` path per `grep -rliI "/Users/" ... .claude/settings.json` → 9 hits; `find` reports 14 tracked `settings.json` total). The 9 must-change figure is the Layer 1 cleanup surface. The two new hook files have no consumers yet — they are inert until wired.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- Layer 2 registers a **new SessionStart hook that runs once per session, per project** (README line 19: "SessionStart hook: derive workspace root, create settings.local.json if missing"). SessionStart-per-session is the Medium calibration point.
- The hook is near-zero-cost after first run: it is idempotent and short-circuits — `[ -f "$LOCAL" ]` true → no write (auto-provision-local-settings.sh lines 63, 20 "Idempotent: second run does nothing"). Its `additionalContext` output fires only when something changed (lines 79–84), so steady-state sessions pay ~one cheap bash exec and emit nothing.
- It adds no content to an always-loaded CLAUDE.md and no `@import`. The token cost is the SessionStart exec itself, not loaded context.
- Wiring option (b) would fold the body into `auto-sync-shared.sh` (always-run on every project SessionStart) — same per-session frequency, but the README itself marks it **NOT recommended** (line 44). Option (a) keeps cost isolated. Risk stays Medium on the assumption option (a) is chosen.

### Dimension 2: Permissions Surface
**Risk:** Medium

- The auto-provision hook **writes a `permissions.additionalDirectories` grant** into `settings.local.json` (lines 66–74) — it grants the current machine read/write access to the entire derived workspace root. This is the same grant the tracked files carry today (grep shows every project already lists the workspace root in `additionalDirectories`), so it is **not a new capability** — it relocates an existing grant from tracked to gitignored scope. That is a scope *narrowing* of where the secret-ish machine path lives, which is the point of the change.
- The pre-commit guard *removes no deny rule and adds no allow* — it is purely subtractive at commit time (blocks `/Users/` and `"model"` in tracked `settings.json`, pre-commit-guard.sh lines 30–34). It narrows what can enter the shared file.
- New surface introduced: the hook writes to `.gitignore` and to `.claude/` (lines 54, 66) on SessionStart, and Layer 3 runs `git config core.hooksPath .githooks` (README line 51) — a git-config mutation. These are file/config writes within each repo, not new tool families, but the SessionStart hook now performs **unprompted writes to two files per repo** where the existing sync hook only creates symlinks. Medium: narrow new write behavior in an established hook surface, no broadening of tool grants.

### Dimension 3: Blast Radius
**Risk:** High

- Grounded in the Consumer Inventory: **14 consumers, 9 must-change.** The 9 must-change rows are tracked `settings.json` files across the workspace, the ai-resources repo, and 7 project locations — confirmed by `grep -rliI "/Users/" --include=settings.json` → 9 hits ending in `.claude/settings.json`. Each must be hand-edited (Layer 1) to strip the machine path; `find` reports 14 tracked `settings.json` total.
- Any caller requiring modification to keep working is the High trigger. Here all 9 require modification, and one (`nordic-pe-screening-project`) is *also* the host for the Layer 2 SessionStart wiring (its settings.json already carries the `auto-sync-shared.sh` walk-up entry at line 41).
- **Contract change touching the SessionStart parse surface:** Layer 2 option (a) adds a second SessionStart entry mirroring the existing walk-up command. The existing entries (nordic-pe-screening-project line 41; nordic-pe-macro-landscape-h1-2026 lines 145, 157) are the `parses`/`invokes` consumers of the SessionStart shape — adding a sibling entry is backwards-compatible but multiplies the per-repo wiring surface.
- **Cross-machine blast radius the description anticipates but cannot fully contain:** Layer 1 commits + pushes the stripped files to remotes both Daniel and Patrik pull (README line 18 "Both machines — needs Patrik coordination + a push"). The stripped path is *Patrik's* on the shared remote; once stripped and pushed, Patrik's next pull removes his working path until his own auto-provision hook regenerates it on the *next* session (the one-session lag, README lines 56–58). That ordering gap is a real cross-consumer effect on Patrik's machine.
- Shared infra touched: SessionStart chain (multi-workflow) and, if option (b) were chosen, `auto-sync-shared.sh` — the single most-depended-on hook in the workspace (architecture.md calls it required infrastructure). Option (a) avoids that; this finding assumes (a).

### Dimension 4: Reversibility
**Risk:** High

- Layer 1 ends in a **`git push` to ~9 repos' shared remotes** (README line 18). Push is operator-gated (workspace CLAUDE.md Autonomy Rule #2), but once pushed, `git revert` on the local clone cannot recall the change from the remote or from Patrik's clone — state has propagated beyond the local working tree. That is the explicit High calibration ("state has propagated beyond git (push, external writes)").
- Layer 3 runs `git config core.hooksPath .githooks` per machine (README line 51). This is **not tracked by git** — a `git revert` of the hook files leaves `core.hooksPath` still pointed at `.githooks`, so a stale or removed guard path could block or mis-handle future commits until the operator manually runs `git config --unset core.hooksPath`. Multi-step manual rollback.
- The SessionStart hook **appends to `.gitignore`** (lines 52–60) and **creates `settings.local.json`** (lines 63–76). A revert of the hook does not remove the files it already generated across repos; the operator must delete generated locals and revert gitignore appends per repo. Extra cleanup step beyond git.
- Auto-firing between landing and revert: the hook is SessionStart, so it can regenerate `settings.local.json` and re-append `.gitignore` on the very next session even after a partial revert — the change can "heal" itself back into place mid-rollback (README line 22 "self-healing"). This is the "automation that could fire between change and revert" High signal.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Documented contract, established convention:** the workspace-root derivation "Mirrors auto-sync-shared.sh detection exactly" (auto-provision-local-settings.sh lines 31–33). It silently depends on the invariant that `ai-resources/.claude/commands` marks the workspace root (line 37). If that marker directory ever moves, *both* hooks break in lockstep — but the coupling is named in the comment and to an established convention, so it is the Medium calibration ("one implicit dependency on an established repo convention").
- **Settings load-timing coupling** is real but documented (README lines 56–58): a `settings.local.json` created during SessionStart takes effect from the *next* session. The hook relies on this being acceptable degradation; it is named, not silent.
- **`additionalDirectories` union semantics** (README lines 65–67): until Layer 1 lands, effective config is the union of the tracked (Patrik's) path + the local (current machine's) path. The README correctly notes Patrik's path is inert on Daniel's machine — the coupling is documented and benign in the interim.
- **Layer-ordering coupling:** Layer 3 enabled before Layer 1 cleanup would let the guard block a future re-stage of a still-dirty `settings.json` (README lines 62–64). This is an undocumented-at-the-hook ordering dependency between two of the three layers — it lives only in the README caveat, not in either script. Borderline, but because it is written down and the affected actor is the operator (not a silent runtime path), it stays Medium.
- No functional overlap with `check-permission-sanity.sh` (that *nudges* on drift; this *prevents* it) — distinct concerns, no double-handling.

### Dimension 6: Principle Alignment
**Risk:** Medium

- **principles-base not readable:** `projects/strategic-os/ai-strategy/principles-base.md` returned NOT PRESENT. Evaluated against the inline checks and the always-loaded workspace `CLAUDE.md` (Autonomy Rules, Model Tier) and `ai-resources/CLAUDE.md` § Model Selection. The OP/DR/AP IDs below are cited from the inline-check anchors in this reviewer's brief, not from a readable frozen-ID index.
- **Serves a principle (strong positive):** the pre-commit guard enforces the workspace prohibition on a `"model"` field in any settings file (ai-resources/CLAUDE.md line 31; workspace CLAUDE.md § Model Tier "New commands: declare an explicit tier ... never inherit"). It also serves the placement principle (DR-1/DR-3): machine-specific config belongs in gitignored per-machine scope, not the tracked shared tier.
- **Advisory → enforcement tension (OP-5):** the pre-commit guard is an *enforcement* mechanism — it `exit 1` blocks commits (pre-commit-guard.sh line 46), a step beyond the workspace's existing *advisory* `check-permission-sanity.sh` nudge. Introducing commit-blocking enforcement is a per-component authority decision, not a silent upgrade. It is opt-in per machine (`core.hooksPath`, README line 51) and has a documented `--no-verify` escape (line 45), which softens it — but landing it live is a deliberate move toward enforcement that should be a recorded operator decision, not drift. Name the principle and decide explicitly.
- **Speculative-abstraction check (OP-9/AP-7/DR-7):** the two hooks have **zero current consumers** (grep confirmed). Normally a zero-consumer contract is a speculative-abstraction signal — but here the consumer is concrete and present (9 tracked files carrying machine paths today, confirmed by grep), and the change is built to serve *that existing* problem, not a hypothetical Phase 2. So this is **not** speculative abstraction; the abstraction is licensed by a confirmed, enumerated consumer set. No violation.
- **Boundary (OP-10):** the change stays entirely inside Claude Code / git config — it does not reach into GPT/Perplexity/Notion/NotebookLM. No boundary expansion.
- **Closure before detection (OP-12):** the guard is *detection that closes* — it blocks the bad commit at the point of detection rather than emitting a finding for later. It does not add orphan detection. Aligned.
- Net: aligned on placement, model-prohibition, boundary, and closure; one genuine tension (advisory→enforcement, OP-5) that needs an explicit recorded call. Medium.

## Mitigations

- **Reversibility (D4) — sequence and pre-stage the rollback before any push.** Land Layers 2 and 3 *first* (local-only, no push) and confirm `settings.local.json` regenerates correctly on Daniel's machine across all repos. Only then do Layer 1, and present the push as a single batched operator-gated confirmation per the workspace Push Rules. Before pushing, record the exact rollback recipe in the draft README: per-repo `git config --unset core.hooksPath`, delete generated `settings.local.json`, and `git revert` of the Layer 1 commit. This converts the "state propagated to remote / config untracked / self-healing hook" failure modes into a known, written, multi-step procedure.
- **Reversibility / Blast radius (D4, D3) — coordinate Layer 1 timing with Patrik to cover the one-session lag.** Because the stripped path is Patrik's and his working path vanishes on pull until his next-session hook regenerates it (README lines 56–58, 62–64), schedule the Layer 1 push when Patrik can open one throwaway session per repo immediately after pulling. Do **not** enable Layer 3 (the guard) on Patrik's machine until after his Layer 1 pull + regenerate completes, or his next re-stage could be blocked (README lines 62–64).
- **Blast radius (D3) — apply Layer 1 as one reviewed batch, not 9 ad-hoc edits.** Strip all 9 must-change `settings.json` files in a single pass, diff each (confirm only the `/Users/` line and any `"model"` line are removed, nothing else), and commit as one `batch:` commit per repo. Use wiring option (a), not (b) — do not fold the body into `auto-sync-shared.sh` (README line 44), keeping the workspace's most-depended-on hook untouched.
- **Principle alignment (D6, OP-5) — record the advisory→enforcement decision explicitly.** Before enabling Layer 3, make the move from nudge to commit-block a recorded operator call (one line in the draft README or a decisions log entry): the guard is opt-in, machine-local, and `--no-verify`-escapable by design. This keeps the enforcement upgrade loud, not silent.
- **Permissions / Usage (D2, D1) — note the new write behavior at the hook site.** Add a one-line note in `ai-resources/docs/permission-template.md` recording the tracked-vs-local split and that the SessionStart hook now writes `.gitignore` and `.claude/settings.local.json` on first run, so a future audit does not flag the writes as drift.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION. Full advisory: `projects/axcion-ai-system-owner/output/consultations/consult-2026-06-05-risk-check-second-opinion-self-provisioning-machine-set.md`._

**Verdict: concur with PROCEED-WITH-CAUTION.** The design serves DR-1/DR-3 placement (machine path out of tracked tier) and enforces the workspace model-default ban. Blast radius and Reversibility are correctly High — Layer 1 pushes to a shared remote `git revert` can't recall (`risk-topology.md § 3.1`), and it mutates the always-loaded SessionStart chain (`risk-topology.md § 1.1`). Not speculative abstraction — 9 real consumers exist today (DR-7/AP-7 don't fire).

**Mitigation path: right, with two reinforcements.**
- M1 understates the OP-3 loud-failure duty for the one-session lag — the regenerating session should emit a visible "regenerated local settings" line so Patrik sees the heal, not a silent permission-denial.
- M5 is necessary but not sufficient: the hook does unprompted writes to `.gitignore` and `settings.local.json` that `/permission-sweep` and `check-permission-sanity.sh` also touch — confirm no two-hook race (`risk-topology.md § 1.2` shows this contract class is already fragile).

**Risks the dimension review missed / under-weighted:**
1. **OP-5 advisory→enforcement should escalate to the Assumptions Gate**, not sit in a README line. A commit-blocking `exit 1` guard is a recorded operator decision per `principles.md § 1 — OP-5` — strengthen M4 to a decisions-log entry.
2. **DR-10 concurrent-session collision unaddressed.** Layer 1 hand-edits 9 tracked `settings.json`; a concurrent `/permission-sweep` or `/cleanup-worktree` clobbers the batch. Add: explicit `git add` paths, no wildcards, confirm no concurrent sweep before starting.
3. **The shared workspace-root derivation is the binding coupling, not Medium-on-blast.** If the `ai-resources/` marker moves, both `auto-sync-shared.sh` (Critical) and the new hook break in lockstep and write a wrong root into gitignored locals no revert touches. Highest-leverage cheap fix: a test asserting both hooks derive the same root — `[CITATION NEEDED]` on whether one exists.
4. **Per-project option-(a) SessionStart wiring** is itself a gated hook-edit class (`risk-topology.md § 3.1`) — ride it in the same reviewed batch, don't sprinkle ad hoc.

**Position:** Proceed on the cautioned path, but before going live — elevate the OP-5 call via the Assumptions Gate, and fold DR-10 discipline into Layer 1. `/risk-check` has fired and its verdict is binding (`principles.md § 2 — DR-8`); don't downgrade it to land Layer 1 faster.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references to the three draft scripts and `auto-sync-shared.sh`, verbatim README caveat quotes, and grep/find counts (14 tracked `settings.json`; 9 carrying `/Users/` machine paths; zero consumers of the two new hook basenames; SessionStart walk-up entries in nordic-pe-screening-project and nordic-pe-macro-landscape-h1-2026 settings.json). principles-base.md was confirmed NOT PRESENT and Dimension 6 was evaluated against inline checks with that noted. No training-data fallback was used.
