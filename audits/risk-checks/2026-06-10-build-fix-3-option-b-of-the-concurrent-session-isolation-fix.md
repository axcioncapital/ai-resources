# Risk Check — 2026-06-10

## Change

Build Fix 3 (option b) of the concurrent-session isolation fix-plan: (1) a NEW thin shell launcher `cc-worktree <unit>` (zsh function/script, placement TBD via /placement) that resolves the repo root, derives BRANCH/WORKTREE_PATH identically to .claude/commands/new-worktree-session.md Step 1, runs `git worktree add <path> -b session/<date>-<unit> main`, cds into the new worktree, and execs `claude` there — shipped as an in-repo artifact plus a one-line .zshrc install snippet (no auto-install); (2) a wording-only tightening of the sharp same-checkout nudge in .claude/hooks/detect-concurrent-session.sh to name the launcher as the one-command recovery path (no logic change — SessionStart hooks cannot block); (3) mark Fix 3 addressed in audits/2026-06-09-concurrent-session-isolation-fix-plan.md. Goal: make worktree-isolated launch the default path for a second concurrent session, removing the "remember to run /new-worktree-session in a fresh session" surface for a non-developer operator who prefers automation over discipline. Fixes 1 and 2 are already shipped and backstop the danger; Fix 3 is the positive path (build-order #4).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-worktree-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/detect-concurrent-session.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/2026-06-09-concurrent-session-isolation-fix-plan.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A low-risk, OP-12-aligned positive-path launcher whose only elevated dimension is blast radius — the hook edit, however cosmetic, must re-sync two un-auto-synced byte-identical project hook copies (one WIRED), the same lockstep-sync coupling every prior edit of this hook hit.

## Consumer Inventory

The change has two targets: a NEW artifact (`cc-worktree` launcher — zero current consumers) and an EDIT to `detect-concurrent-session.sh`. Search terms: `cc-worktree`, `new-worktree-session`, `detect-concurrent-session`, `.zshrc`. Greps run across `ai-resources/` and the workspace root.

| Consumer path | Reference type | Must change? |
|---|---|---|
| projects/positioning-research/.claude/hooks/detect-concurrent-session.sh | co-edits (byte-identical real-file copy, `diff` IDENTICAL; WIRED in that project's settings.json L164) | yes — runs stale nudge text until re-copied; not covered by auto-sync (hooks excluded) |
| projects/research-pe-regime-shift-advisory-gap/.claude/hooks/detect-concurrent-session.sh | co-edits (byte-identical real-file copy, `diff` IDENTICAL; NOT wired in its settings.json — no grep hit) | no-but-divergent — inert until wired, but a stale copy nonetheless |
| ai-resources/.claude/settings.json (L144) | invokes (wires the canonical hook at SessionStart) | no — wiring unchanged; only hook body text edited |
| ai-resources/.claude/settings.local.json (L7) | invokes (pre-authorized `cp` of the canonical hook to the research-pe project copy) | no — the lockstep-sync mechanism; pre-exists this change |
| ai-resources/.claude/commands/new-worktree-session.md | documents (Step 1 name-derivation logic the launcher replicates) | no — launcher copies the logic; command is unchanged |
| ai-resources/docs/parallel-sessions-playbook.md (L110, L114, L117) | documents (names `/new-worktree-session` as the §4 isolation path) | no — playbook stays valid; launcher is an additional path, not a replacement |
| ai-resources/.claude/commands/concurrent-session-check.md (L12, L62, L129, L151, L171) | documents (nudges to `/new-worktree-session`) | no — unaffected by a new sibling launcher |
| audits/2026-06-09-concurrent-session-isolation-fix-plan.md (L84) | documents (Fix 3 spec; the change marks it addressed) | yes — change explicitly edits this file (part 3) |

**Total: 8 consumers, 3 must-change** (positioning-research hook copy; the fix-plan audit; and — see note — the research-pe copy is a soft must-change for hygiene). `cc-worktree` itself has **zero current consumers** — only `logs/session-plan-2026-06-10-S3.md` and `logs/session-notes.md` name it, and those are the descriptions of *this very change*, not independent consumers. The launcher introduces a new contract (the `cc-worktree <unit>` shell token) that nothing in the repo yet honors; its only future "caller" is the operator's shell habit + the hook's recovery-path prose.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The launcher is an operator-shell artifact, NOT auto-loaded by any session. It ships as an in-repo file plus a one-line `.zshrc` snippet the operator installs by hand ("no auto-install" — CHANGE_DESCRIPTION; session-plan L20: "adoption is the operator's"). Zero per-session or per-turn token cost — it never enters Claude's context.
- The hook edit adds no new auto-load: `detect-concurrent-session.sh` is already wired at SessionStart (settings.json L144) and already runs once per session. The change is wording-only inside an existing `emit()` string (hook L153) — no new branch, no new file read. The 2026-06-05 token audit classifies all SessionStart hooks as "lightweight nudge/log hooks … their stdout is small" (token-audit-2026-06-05-ai-resources.md L219).
- The fix-plan audit edit (mark Fix 3 addressed) is a one-file status flip with no load path.

### Dimension 2: Permissions Surface
**Risk:** Low

- No new `allow`/`ask` entry required for the launcher: it runs in the operator's own shell (zsh), outside Claude Code's permission model entirely. Claude is not invoking `cc-worktree`; the operator is.
- The lockstep `cp` of the canonical hook to a project copy is already pre-authorized: `Bash(cp .claude/hooks/detect-concurrent-session.sh "../projects/research-pe-regime-shift-advisory-gap/.claude/hooks/detect-concurrent-session.sh" *)` (settings.local.json L7). No new permission, no deny-rule removal, no scope escalation. (Note: that pre-auth names only the research-pe copy, not positioning-research — see Mitigations.)
- No settings.json model field touched; no permission moved between layers.

### Dimension 3: Blast Radius
**Risk:** Medium

Grounded directly in the Consumer Inventory above (8 consumers, 3 must-change):

- **The hook has three byte-identical real-file copies, and auto-sync does NOT cover hooks.** `find` across the workspace confirms canonical + `positioning-research` + `research-pe` copies, all `diff` IDENTICAL. `auto-sync-shared.sh` walks only `.claude/{commands,agents}/` (auto-sync-shared.sh L4: "Walks ai-resources/.claude/{commands,agents}/"); `repo-architecture.md` L101 confirms hooks are "Not auto-distributed." So editing the canonical hook leaves the two project copies stale unless re-copied by hand.
- **One stale copy is WIRED and will silently run the old text.** `positioning-research/.claude/settings.json` L164 wires the hook — that project keeps emitting the OLD nudge text (no launcher named) until manually re-copied. This is a must-change consumer NOT in CHANGE_DESCRIPTION's stated scope — a surfaced blast-radius gap (same gap the Fix 1 risk-check flagged, 2026-06-10-upgrade-detect-concurrent-session-sh L62/L92).
- **No contract change.** The hook's output contract (single `systemMessage` JSON via `emit()`, every path `exit 0`) is preserved verbatim — this is a wording-only edit (CHANGE_DESCRIPTION: "no logic change"). No `parses` consumer is affected: nothing parses the nudge *text*, only its JSON envelope, which is untouched.
- The launcher itself is isolated: a single new file with zero callers; its only "consumer" is the operator's shell. The nudge-text edit naming the launcher is a documents-style reference that stays valid whether or not the operator has installed `cc-worktree`.

Net: not a contract break and not >5 must-change callers, but it touches shared infra (a hook with un-auto-synced copies, one wired) in a way that affects a second project's runtime behavior. That puts it at Medium, driven entirely by the lockstep-sync coupling — mitigable.

### Dimension 4: Reversibility
**Risk:** Low

- The launcher is a single new in-repo file plus a doc/snippet — `git revert` removes it cleanly. The operator's `.zshrc` line is operator-installed and operator-removed (outside git), but it is inert if the launcher file is gone (sourcing a missing path just fails the function definition harmlessly); no repo state depends on it.
- The hook edit is a wording change to one `emit()` string — `git revert` restores the prior text fully. The two project copies revert via the same lockstep `cp` used to sync them.
- The fix-plan status flip is a one-line edit, cleanly revertible.
- No state propagates beyond git: no push (gated), no external write, no log mutation, no automation fires between landing and a potential revert (the launcher only runs when the operator types `cc-worktree`).
- Mild, non-blocking operator-memory note: once the operator adopts `cc-worktree` as a habit, reverting the launcher leaves muscle memory pointing at a gone command — but that is a recoverable annoyance, not a state-cleanup cost.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **One genuine implicit dependency: name-derivation parity with `new-worktree-session.md` Step 1.** The launcher "derives BRANCH/WORKTREE_PATH identically to new-worktree-session.md Step 1" (CHANGE_DESCRIPTION) by *copying* that logic, not calling it. If `new-worktree-session.md` Step 1 later changes its `BRANCH`/`WORKTREE_PATH` formula (e.g., the `-2`/`-3` uniqueness suffix at L43–44, or the sibling-dir convention at L41), the launcher silently diverges — two implementations of one convention with no shared source. This is a duplicated-contract coupling that is NOT documented at either site unless the launcher carries an explicit "mirrors new-worktree-session.md Step 1 — keep in sync" note.
- **The hook→launcher prose reference is a soft, self-documenting coupling, not a hard one.** The nudge will name `cc-worktree` as the recovery path; if the operator has not installed the `.zshrc` snippet, the named command does not exist. This degrades safe (the nudge also keeps naming `/new-worktree-session`, which always exists as a command) — but the hook text now asserts a recovery path whose existence depends on operator-side install state the hook cannot verify. Document the launcher as the *fast* path and `/new-worktree-session` as the *always-available* path so the nudge is not misleading on an un-installed machine.
- The pre-existing byte-identical-hook-copy coupling (Dimension 3) is also a hidden-coupling instance — standing maintenance debt logged at improvement-log.md, not introduced by this change.
- No functional overlap that creates a two-systems-fighting concern: the launcher does what `/new-worktree-session` could never do (move the shell's cwd / exec a fresh `claude` in the worktree — the exact hard limit at new-worktree-session.md L17–23). It complements rather than duplicates.

### Dimension 6: Principle Alignment
**Risk:** Low

Principles read from `projects/strategic-os/ai-strategy/principles-base.md` (the frozen-ID index) — available and used.

- **OP-12 (closure before detection) — aligned, serves the principle.** This adds NO new detection. It strengthens the *closure* arm of an existing detector: the same-checkout nudge already fires (hook L153); the launcher gives that nudge a one-command recovery path. OP-12 (principles-base L50) counts strengthening closure *for* a candidate. This is the textbook-compliant shape — the same pattern the prior new-worktree-session risk-check scored as OP-12-compliant (2026-06-05 report L83).
- **OP-9 / AP-7 / DR-7 (no speculative abstraction) — not triggered, despite zero current consumers.** The launcher has zero existing consumers (grep: only this change's own session-plan names `cc-worktree`), which is normally a speculative-abstraction signal. But the *confirmed consumer is the operator's own launch habit*, named explicitly in the fix-plan (Fix 3, plan L49–55) and the load-bearing operator preference "automation over manual discipline" (plan L6). This is not generalizing for an absent future consumer; it is building the specific positive path for a present, named operator need. The launcher is also maximally thin (a wrapper around `git worktree add` + `exec claude`), not pre-emptive infrastructure. No DR-7 violation.
- **OP-10 (system boundary is Claude Code only) — not crossed.** The launcher execs `claude` in a new worktree — it stays inside the Claude Code boundary; it does not coordinate GPT/Perplexity/Notion/NotebookLM behavior. A shell wrapper that launches `claude` is operator-environment tooling, not cross-tool system expansion.
- **OP-5 (advisory vs enforcement) — preserved.** CHANGE_DESCRIPTION states the hook stays wording-only and "SessionStart hooks cannot block," consistent with the hook's own header (L56–65). No advisory→enforcement upgrade — the launcher is an opt-in path the operator chooses to run, not an auto-fired enforcement of isolation.
- **DR-1 / DR-3 (placement) — deferred-but-bounded.** The launcher is "placement TBD via /placement" (CHANGE_DESCRIPTION), which is the correct discipline per the workspace placement rule. `ai-resources/scripts/` already exists as a plausible canonical home (confirmed on disk). No misplacement is committed by this change; placement is gated by the named `/placement` run before file creation.

## Mitigations

- **Dimension 3 (Blast Radius) — re-sync the wired project hook copy in the same commit.** After editing the canonical `detect-concurrent-session.sh`, re-copy it to `projects/positioning-research/.claude/hooks/detect-concurrent-session.sh` (WIRED at its settings.json L164 — runs stale nudge text otherwise) and `projects/research-pe-regime-shift-advisory-gap/.claude/hooks/detect-concurrent-session.sh`. Confirm `diff` IDENTICAL post-edit. Add both to the change's "Files in scope." Note: the pre-authorized `cp` (settings.local.json L7) covers only the research-pe path — the positioning-research copy needs an explicit `cp` (or a one-time permission allow) so the WIRED copy does not silently diverge.
- **Dimension 5 (Hidden Coupling) — carry an explicit sync-note in the launcher.** Add a top-of-file comment in `cc-worktree` stating it mirrors `new-worktree-session.md` Step 1's `BRANCH`/`WORKTREE_PATH` derivation and must be kept in sync if that formula changes (including the `-2`/`-3` uniqueness suffix). And in the hook nudge, name `/new-worktree-session` as the always-available path and `cc-worktree` as the fast path, so the nudge is not misleading on a machine where the operator has not installed the `.zshrc` snippet.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references to `new-worktree-session.md`, `detect-concurrent-session.sh`, `auto-sync-shared.sh`, `repo-architecture.md`, `settings.json`/`settings.local.json`, the fix-plan audit, and `principles-base.md`; `find`/`diff -q` confirmation of three byte-identical hook copies; grep counts for `cc-worktree` (0 independent consumers — only this change's own session-plan/notes), `new-worktree-session`, and `detect-concurrent-session`; verbatim CHANGE_DESCRIPTION quotes. No training-data fallback was used on any read.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Full advisory on disk:** projects/axcion-ai-system-owner/output/consultations/consult-2026-06-10-fix3-worktree-launcher-second-opinion.md

**Concurrence:** Concur with PROCEED-WITH-CAUTION. Fix 3 converts a non-developer discipline into an automated path — exactly the trade the system is built to make (OP-1, OP-9). "Principle alignment: Low" is right: this advances alignment, it does not threaten it. Two real structural facts hold it at CAUTION not GO: the hook edit silently leaves stale WIRED copies (hooks are not auto-distributed — repo-architecture.md § Symlink topology), and the launcher duplicates /new-worktree-session Step 1 logic.

**Mitigation 1 (re-sync WIRED copies same commit):** Correct and required — stale copies = silent drift of a user-facing recovery instruction (OP-3, AP-1); same-commit re-sync keeps the two-end nudge-text contract atomic (risk-topology.md § 3). Strengthen: derive the WIRED-copy set at commit time (grep for detect-concurrent-session.sh copies), don't hand-list the two — a hand-listed pair is itself a future staleness source.

**Mitigation 2 (sync note + two-path framing):** Right direction, weakest form. The default style is structural/self-maintaining, not a comment a human must read first (CLAUDE.md § Working Principles; AP-7). Structural form = factor Step 1 derivation into one helper under ai-resources/scripts/ that both call. If that refactor is out of scope (reasonable — Fixes 1/2 backstop the danger), ship the note as an explicitly-logged patch, not as if it were the structural fix, and park the single-source refactor as follow-up. The two-path framing (/new-worktree-session always-available, cc-worktree fast) is the right operator-facing contract.

**Risks the dimension review missed:**
- R1 — Script home (DR-3): brief says "in-repo artifact" without a path. Confirm it lands in ai-resources/scripts/, not .claude/ or a project dir.
- R2 — Governance reach: the .zshrc-installed copy is outside repo QC/risk-check after install. No-auto-install is correct, but the in-repo artifact is the only governed copy — name "re-install after canonical change" as an operator step.
- R3 — Reversibility: ship a one-line uninstall note; back-out is an operator shell edit, not a repo revert. Belongs in the repo-state.md § 2 operator-step register.
- R4 — DR-10 interaction: worktree isolation makes DR-10 less load-bearing (good) — confirm the launcher is additive to the .prime-mtime two-end contract Fix 1 depends on (risk-topology.md § 1), not a bypass.

**Position:** Ship under PROCEED-WITH-CAUTION with both mitigations plus three adjustments — (a) derive the WIRED set at commit time; (b) sync note as logged patch, single-source helper as parked follow-up; (c) confirm ai-resources/scripts/ home + add install/uninstall/re-sync note to the operator-step register. OP-12-clean: positive path ships behind Fixes 1/2, not ahead of them.
