# Risk Check — 2026-07-15

## Change

Four-part urgent hook/wiring/log fix set (premises verified by execution pre-gate):

(1) HOOK QUOTING — In ai-resources/.claude/settings.json ONLY, quote 10 hook command strings that expand $CLAUDE_PROJECT_DIR unquoted (lines 45,56,69,75,86,98,108,114,124,136), changing `bash $CLAUDE_PROJECT_DIR/.claude/hooks/X.sh` → `bash "$CLAUDE_PROJECT_DIR/.claude/hooks/X.sh"`. Cause PROVEN by sentinel probe today (2026-07-15 SessionStart): the CPD_UNQUOTED probe variant never fired while CPD_QUOTED and ABS fired, and CLAUDE_PROJECT_DIR is set — so the unquoted expansion word-splits on the spaced workspace path (…/Claude Code/Axcion AI Repo/…), and 9 repo-level hooks (check-heavy-tool, friction-log-auto wired to 2 events, log-write-activity, auto-qc-nudge, check-stop-reminders, coach-reminder, improve-reminder, auto-resolve-nudge, friday-checkup-reminder) never fired. Then REMOVE the sentinel: delete .claude/hooks/sentinel-hook-probe.sh, delete logs/sentinel-hook-probe.log, remove the 3 sentinel wiring blocks (ABS/CPD_QUOTED/CPD_UNQUOTED) from settings.json SessionStart. settings.json is git-versioned → propagates to ~24 checkouts (prime.md etc. are symlinked). User-level (~/.claude/settings.json) and workspace-root (.claude/settings.json) already use quoted absolute paths (verified this session) so they are NOT touched by item 1.

(2b) RISK-CHECK REPORT PATH — In .claude/commands/risk-check.md:50, REPORT_DIR is hard-coded to {AI_RESOURCES}/audits/risk-checks/, so a worktree/other-checkout session writes its report into the main repo (and check-foreign-staging.sh exempts that dir, so a bare commit in the main checkout folds it in silently). Fix: resolve REPORT_DIR against the current checkout (git rev-parse --show-toplevel), not a hard-coded canonical AI_RESOURCES.

(2c) USAGE-LOG ORDERING — logs/usage-log.md had one entry PREPENDED (L9, under a `<!-- entries below -->` marker) while every other entry is appended at the tail, and the reader (/prime Step 1 uses `tail -n 30`) reads the tail, so the prepended entry is invisible to its own consumer. Fix: (i) move the prepended entry to the tail; (ii) add a new format-assertion script under logs/scripts/ that checks the newest usage-log entry matches the reader's expected shape, called from /wrap-session.

(3) SESSIONEND TEARDOWN — SessionEnd marker teardown (~/.claude/hooks/cleanup-session-marker.sh) does not fire on a clean /wrap-session. Hypothesis to confirm by execution: /wrap-session is a slash command, not an actual session-termination event, so the SessionEnd hook never fires on wrap and the marker persists until the next real session end — causing check-destructive-liveness.sh and /close-worktree-session Step 3 to false-fire on already-finished sessions. Fix: /wrap-session deletes its own session markers (logs/.session-marker*, and the shared claim dir entry) as its LAST step (belt-and-braces, model-side) in both wrap-session.md copies; correct the false trustworthiness claim in close-worktree-session.md L127-131 which asserts the SessionEnd hook removes the marker.

(4) VERSIONED HOOK-WIRING INSTALLER — hook WIRING lives only in unversioned ~/.claude/settings.json (PreToolUse: check-foreign-staging.sh + check-destructive-liveness.sh; SessionEnd: cleanup-session-marker.sh). The hook SCRIPTS are git-tracked in ai-resources/.claude/hooks/ but the WIRING is not, so a fresh clone / second machine gets the scripts but not the wiring and the guards are silently absent. Build logs/scripts/install-hooks.sh (idempotently MERGES the required wiring into ~/.claude/settings.json using the quoted form; append/merge into existing JSON, NEVER overwrite the file wholesale) + .claude/hooks/check-hook-wiring.sh (detects unwired state and reports at SessionStart or on demand). Rebuild from logs/session-plan-2026-07-14-S8.md Phase 1 spec (the S8 version was built+tested but never landed and is now gone).

Files in scope are the REFERENCED_FILE_PATHS above.

Note for Dimension 7 (Problem Reality): item 1's cause is OBSERVED (sentinel log logs/sentinel-hook-probe.log, today's SessionStart lines); items 2b, 2c, 4 are OBSERVED (grep/read of the cited files this session); item 3's cause is a HYPOTHESIS not yet confirmed by execution — the fix is gated on confirming it. Item 2(a) (wrap-session findings→task queue) was found already-fixed pre-gate and is DROPPED from this change set to a status flip.

Pay special attention to: the installer (item 4) mutating unversioned user-level settings (reversibility, idempotency, non-destructive merge); the settings.json quoting change propagating to ~24 checkouts (blast radius); and whether resolving risk-check.md's REPORT_DIR against the current checkout (2b) has any hidden coupling with downstream consumers of the report path.

## Referenced files

- ai-resources/.claude/settings.json — exists
- ai-resources/.claude/hooks/sentinel-hook-probe.sh — exists (to be DELETED)
- ai-resources/logs/sentinel-hook-probe.log — exists (to be DELETED)
- ai-resources/.claude/commands/risk-check.md — exists
- ai-resources/logs/usage-log.md — exists
- ai-resources/.claude/commands/wrap-session.md — exists
- .claude/commands/wrap-session.md (workspace-root copy) — exists
- ai-resources/.claude/commands/close-worktree-session.md — exists
- ai-resources/logs/scripts/install-hooks.sh — not yet present
- ai-resources/.claude/hooks/check-hook-wiring.sh — not yet present
- ~/.claude/settings.json (user-level; installer target) — exists
- ~/.claude/hooks/cleanup-session-marker.sh — exists

## Verdict

**RECONSIDER**

**Summary:** Three of the four sub-changes (1, 2c, and mostly 2b) are well-grounded and low-risk, but item 3 rests on a premise that the repo's own history directly falsifies — both of its proposed fixes are already shipped — and item 4's installer independently carries a High-High (Permissions/Reversibility) profile that two prior risk-checks on this same subsystem already flagged RECONSIDER for; the bundle as described should not land as one change.

## Consumer Inventory

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/hooks/check-heavy-tool.sh, friction-log-auto.sh (×2 wiring), log-write-activity.sh, auto-qc-nudge.sh, check-stop-reminders.sh, coach-reminder.sh, improve-reminder.sh, auto-resolve-nudge.sh, friday-checkup-reminder.sh (9 hook scripts) | invokes (wired FROM settings.json; scripts themselves unaffected) | no |
| ai-resources/.claude/hooks/sentinel-hook-probe.sh + logs/sentinel-hook-probe.log | invokes / co-edits (deleted by item 1) | yes |
| ai-resources/.claude/agents/risk-check-reviewer.md | invokes (spawned by risk-check.md with REPORT_PATH built from REPORT_DIR) | no |
| Symlinked project copies of risk-check.md (e.g. `audits/repo-due-diligence-2026-05-08-project-global-macro-analysis.md:64` confirms `/risk-check` is a symlink to this file, one of ~20+ projects) | invokes | no (backward-compatible for the main-checkout case; scope risk noted in Dim. 5) |
| /friday-act (per risk-check.md's own text) | invokes | no |
| ai-resources/.claude/commands/prime.md (`prime.md:89` — `Bash(tail -n 30 logs/usage-log.md)`) | parses | no |
| ai-resources/.claude/commands/wrap-session.md (canonical, Step 13 already tears down the per-id marker) | co-edits (item 2c new script call; item 3 duplicate teardown edit) | yes |
| .claude/commands/wrap-session.md (workspace-root copy, Step 7 already tears down the per-id marker) | co-edits | yes |
| Other real (non-symlinked) wrap-session.md forks — e.g. the fork the harness's own docs describe as running "with no teardown step at all" | co-edits (NOT named in CHANGE_DESCRIPTION's "both wrap-session.md copies") | yes — gap: CHANGE_DESCRIPTION's own consumer list undercounts |
| ai-resources/.claude/commands/close-worktree-session.md (L127-131, already corrected in commit `8de46fd`, 2026-07-14 S8) | co-edits (item 3 "correction" is stale) | no — already done; re-editing risks reverting a deliberate fix |
| ~/.claude/settings.json (unversioned, user-level) | co-edits (item 4 installer target; also carries a pre-existing rule-violating `"model": "opus[1m]"` field the merge must not disturb) | yes |
| ~/.claude/hooks/cleanup-session-marker.sh | documents/context (discussed by item 3; not directly edited) | no |
| ai-resources/.claude/hooks/check-foreign-staging.sh (confirmed `EXEMPT_DIR_PREFIXES` includes `audits/risk-checks/`; git-tracked, confirmed via `git ls-files`) | documents (supports item 2b's and item 4's claims) | no |
| ai-resources/.claude/hooks/check-destructive-liveness.sh | documents (item 4 wiring target; git-tracked, confirmed) | no |
| logs/improvement-log.md (2026-07-14 "SessionEnd marker teardown does NOT fire…" entry, `Status: OPEN`) | documents (source of item 3's premise; itself stale — 3 of its 4 listed fixes are already shipped) | no |
| Two prior risk-check reports on the same subsystem: `audits/risk-checks/2026-07-14-batched-repo-repair-V2-post-reconsider.md`, `…-marker-grammar-hook-wiring-deny-rules.md` (both verdict **RECONSIDER**, both flag item-4-equivalent installer work High on Permissions + Reversibility) | documents (direct precedent) | no |

**Total: 16 distinct consumer rows, 5 must-change** (sentinel files, both wrap-session.md copies, ≥1 unnamed wrap-session fork, ~/.claude/settings.json). The unnamed-fork row is a genuine gap: the Step 1.5 sweep surfaced a consumer class CHANGE_DESCRIPTION's own item 3 text does not name ("in both wrap-session.md copies" — but at least one other real, non-canonical fork exists per the harness's own hook documentation).

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- Item 1 net-*reduces* SessionStart cost (removes 3 sentinel hooks: ABS/CPD_QUOTED/CPD_UNQUOTED) while making 9 already-intended hooks actually fire — not new cost, restored intended behavior.
- Item 2c adds one script invocation to `/wrap-session`'s core path (bounded, once per wrap, not per tool call) — proportionate given the command already runs 12+ steps.
- Item 4 adds `check-hook-wiring.sh` as a **new SessionStart hook**, wired via `ai-resources/.claude/settings.json` — matches the Medium heuristic exactly ("adds a hook that runs once per session"). `install-hooks.sh` itself is pay-as-used (operator-invoked), no ongoing cost.
- Net: driven to Medium by item 4's new SessionStart registration; nothing here is per-tool-call or always-loaded-context growth.

### Dimension 2: Permissions Surface
**Risk:** High

- Item 4's `install-hooks.sh` writes to `~/.claude/settings.json` — the **user-level** settings file, outside any git repo (confirmed: `test -d ~/.claude/.git` → not a git repo). This is a new automated-write capability against a security-relevant config file that today is only touched by hand.
- Matches the High heuristic directly: "scope-escalates a permission (project → user)… or introduces cross-repo / external capability not previously present."
- Corroborated by direct precedent already in this repo: both `audits/risk-checks/2026-07-14-batched-repo-repair-V2-post-reconsider.md` and `…-marker-grammar-hook-wiring-deny-rules.md` independently scored the same installer capability High on this dimension for a near-identical prior version of item 4.
- Items 1, 2b, 2c, 3 make no permission changes.

### Dimension 3: Blast Radius
**Risk:** High

- Consumer inventory: 16 distinct rows, 5 must-change (see table). Grounded directly in that inventory, not re-derived here.
- `risk-check.md` (item 2b's target) is confirmed symlinked into ~20+ project checkouts (`audits/repo-due-diligence-2026-05-08-project-global-macro-analysis.md:64`), so item 2b's one-line change is live everywhere on save — mitigated by being framed as backwards-compatible for the common case (see Dim. 5 for the unproven part of that claim).
- `wrap-session.md` (item 3's target) has ~22 symlinks + up to 5 real copies (this repo's own commit history, `8de46fd`, states this figure for this exact file); CHANGE_DESCRIPTION names only 2 real copies ("both wrap-session.md copies"), leaving at least one other real fork undescribed — **a gap the Step 1.5 sweep surfaced that CHANGE_DESCRIPTION did not anticipate**, called out per instructions.
- Item 1's own blast-radius claim ("propagates to ~24 checkouts") does **not** hold for `settings.json` itself: direct search found **zero** symlinks to `ai-resources/.claude/settings.json`, and `git worktree list` shows exactly **one** checkout of the ai-resources repo right now. The "~24 checkouts" figure genuinely applies to `prime.md`/`wrap-session.md` (symlinked files), not to `settings.json` (a plain git-versioned file with no other checkout to propagate to today). This is a re-derivation correction, cross-referenced in Dimension 7.
- Item 4 wires a **new** SessionStart hook into the same `ai-resources/.claude/settings.json` item 1 already edits — two sub-changes touching the same shared-infra file in one change.

### Dimension 4: Reversibility
**Risk:** High

- Items 1, 2b, 2c(i), 2c(ii), 3: clean `git revert` (all are git-tracked files; deleting the sentinel script/log loses nothing not already in git history).
- Item 4 is the driver: `install-hooks.sh` writes to `~/.claude/settings.json`, confirmed unversioned (no `.git` at `~/.claude/`). A `git revert` of the installer script does **not** undo what it already wrote to that file — state has propagated beyond git, matching the High heuristic exactly.
- **Gap relative to the more careful precedent:** the prior, more detailed S8 Phase-1 spec for this same installer explicitly required "Backs up `~/.claude/settings.json`" before merging (`logs/session-plan-2026-07-14-S8.md:135`). The CURRENT CHANGE_DESCRIPTION's item 4 does **not** state a backup step — only "idempotently MERGES… NEVER overwrite the file wholesale." A merge bug without a pre-write backup has no rollback path except hand-reconstruction.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- Item 2b's fix ("resolve REPORT_DIR against the current checkout via `git rev-parse --show-toplevel`") has an **implicit, unstated distinction** between two contexts: (a) a genuine `ai-resources` git worktree (where `show-toplevel` correctly resolves to that worktree's own path — the case the change targets) and (b) an ordinary **project session** invoking the symlinked `/risk-check` (e.g. from `projects/strategic-os/`), where `show-toplevel` would resolve to the **project's own** git root, not `ai-resources/`. `risk-check.md`'s own Step 2 does not specify how `AI_RESOURCES` is currently derived beyond "absolute path to the ai-resources/ directory" (no visible walk-up/env-var mechanism in the read text), so the fix as literally described risks silently redirecting every ordinary project-invoked risk-check report away from the canonical `ai-resources/audits/risk-checks/` trail — which is where dozens of existing project-specific reports already live (confirmed by direct grep: `repo-due-diligence-2026-05-11-project-personal.md`, `-2026-05-19-project-ai-development-lab.md`, etc., all under `ai-resources/audits/`). This dependency on "which kind of checkout is calling" is not addressed at the change site.
- Item 4's JSON merge implicitly depends on the current, undocumented exact shape of `~/.claude/settings.json` (confirmed to include unrelated keys: `env`, `effortLevel`, `autoCompactWindow`, `skipDangerousModePermissionPrompt`, `autoMode`, and a rule-violating `"model": "opus[1m]"` at line 167) — mitigated by the explicit "merge, never overwrite wholesale" design intent, but the contract is not written down anywhere outside this change description.
- Not escalated to High: both are single, nameable implicit dependencies with a plausible mitigation path, not multiple compounding ones.

### Dimension 6: Principle Alignment
**Risk:** Medium

- Grounded against `projects/strategic-os/ai-strategy/principles-base.md` (present, read) and `ai-resources/docs/ai-resource-creation.md` rule #7 (present, read).
- **Item 4 — OP-12 (closure before detection): SATISFIED.** `check-hook-wiring.sh` (new detection) ships in the same change as `install-hooks.sh` (its closure channel) — detection behind closure, not ahead of it.
- **Item 4 — complexity-budget gate (`ai-resource-creation.md` rule #7), prong (b): SATISFIED.** Two new, net-additive components, but backed by cited written evidence: `logs/friction-log.md:524` and the `logs/improvement-log.md` 2026-07-14 HIGH entry, both directly naming "hook wiring is not versioned" as the failure mode. Both new components also state a clear invocation path (operator-invoked script; SessionStart registration) per the Inflow rule. Low on this specific sub-axis.
- **DR-1/DR-3 (placement): correct.** `logs/scripts/install-hooks.sh` and `.claude/hooks/check-hook-wiring.sh` both match established home conventions for their component type.
- **Item 3 — OP-11/OP-3 tension (loud revision, never silent drift).** As literally described, item 3 would re-edit `close-worktree-session.md` L127-131 based on a diagnosis (the "false-fire" framing) that the repo's own most recent commit on that exact file (`8de46fd`, 2026-07-14 S8) **explicitly reasoned through and rejected** ("That is not a false positive… this guard is RIGHT to block it"). Applying item 3 as written would silently overwrite a deliberate, already-loud correction without engaging it — the opposite of OP-11's "loud, recorded" revision standard. This is a tension, not a full violation, because the underlying Dimension 7 finding (below) means item 3 should not land as described at all — the redesign path is to drop it, not to loudly re-litigate it.
- Nothing here rises to a clear, unacknowledged violation on its own; Medium reflects the item-3 tension.

### Dimension 7: Problem Reality
**Risk:** High

- **Item 1 — Defect observed, consequence traced.** Direct read of `logs/sentinel-hook-probe.log` confirms exactly the pattern CHANGE_DESCRIPTION claims: two 2026-07-15 SessionStart firings show `CPD_QUOTED` and `ABS` present, `CPD_UNQUOTED` absent, `CLAUDE_PROJECT_DIR` set — matching the probe's own published decode table for cause (1), word-splitting. Line-count re-derived independently: `grep`-equivalent manual check of `settings.json` confirms exactly 10 unquoted `$CLAUDE_PROJECT_DIR` occurrences at exactly lines 45,56,69,75,86,98,108,114,124,136 — exact match to the claim. Low risk on this item.
- **Item 2b — Defect observed at the cited line; consequence plausible but not traced/reproduced.** `risk-check.md:50` reads exactly `Set REPORT_DIR = {AI_RESOURCES}/audits/risk-checks/` — confirmed verbatim. `check-foreign-staging.sh` confirmed to carry `EXEMPT_DIR_PREFIXES = ("audits/risk-checks/", "audits/working/")`. But no actual worktree-session risk-check run was reproduced this session to observe a report actually landing in the wrong checkout — the mechanism is sound but the specific failure has not been triggered and watched. Medium on this item alone; see also the Dimension 5 finding that the fix's own correctness for the (much more common) project-session case is unverified.
- **Item 2c — Defect observed, consequence mechanically traced.** Direct read confirms the S2 entry sits at lines 9-44 (right after the `<!-- entries below -->` marker) while the file's true tail (lines ~916-945 of 945 total) holds later, chronologically-correct entries (S6, S7). `prime.md:89` confirmed to run exactly `Bash(tail -n 30 logs/usage-log.md)`. `tail -n 30` of a 945-line file returns lines 916-945 — nowhere near line 9. The claimed consequence ("invisible to its own consumer") is not merely plausible, it is arithmetically certain given the confirmed line positions. Low risk on this item.
- **Item 3 — Defect claim directly CONTRADICTED by re-derivation. This is the driver of the dimension's High grade.** Two independent falsifications:
  1. The proposed "belt-and-braces, model-side" fix — "`/wrap-session` deletes its own session markers… as its LAST step… in both wrap-session.md copies" — **already exists**. Direct read of both files confirms: canonical `ai-resources/.claude/commands/wrap-session.md` Step 13 and the workspace-root copy's Step 7 both already run `rm -f "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}"` as their explicitly-labeled final action, and this mechanism is dated to "Fix 1, 2026-06-10" in the file's own text — over a month before this change was proposed.
  2. The proposed "correct the false trustworthiness claim in close-worktree-session.md L127-131" — **already done**. `git show 8de46fd -- .claude/commands/close-worktree-session.md` shows this exact passage was rewritten on 2026-07-14 21:44 (commit `8de46fd`, "fix: the guard had a door nobody built, and the test was reading a corpse"), replacing the old "this guard is trustworthy…" claim with corrected text that explicitly states SessionEnd fires on process-end (not on `/wrap-session` finishing) and that a wrapped-but-open session being flagged live **"is not a false positive… this guard is RIGHT to block it."** My direct read of the CURRENT file confirms this corrected text is in place today, annotated "Corrected 2026-07-14 S8."
  - Item 3's own hypothesis restates the pre-S8 "false-fire" framing that S8's own commit explicitly reasoned through and rejected. This is not an unconfirmed hypothesis awaiting execution — it is a claim about the *current state of two files* that direct reading falsifies. Per the rubric: "your own re-derivation contradicts the change description" → High, with no technical mitigation available.
- **Item 4 — Defect observed, consequence plausible but not empirically reproduced.** Direct read of `~/.claude/settings.json` confirms PreToolUse wiring for `check-foreign-staging.sh` + `check-destructive-liveness.sh` and SessionEnd wiring for `cleanup-session-marker.sh`, exactly as claimed; `~/.claude/` confirmed not a git repo; both hook scripts confirmed git-tracked in `ai-resources/.claude/hooks/` via `git ls-files`. The "silently absent on a fresh clone" consequence is architecturally sound (unversioned wiring cannot travel with a `git clone`) but was not reproduced against an actual second machine or fresh clone this session. Medium on this item alone.
- **Re-derivation vs. the change description:** Item 3's premise is directly contradicted (see above) — the two files item 3 targets already contain, in both cases, exactly the fix item 3 proposes to add. Item 1's "~24 checkouts" blast-radius framing does not hold for `settings.json` specifically (0 symlinks found, 1 worktree exists) — a secondary, smaller discrepancy, captured fully under Dimension 3. All other counts, line numbers, and quoted mechanisms in items 1, 2b, 2c, and 4 were re-derived and confirmed.
- **Score the worse, per item bundling.** Because CHANGE_DESCRIPTION presents all four items as one change set, and item 3 is not merely weakly-evidenced but actively falsified by direct evidence already in the repo, the dimension is graded on its worst constituent: **High**.

## Recommended redesign

- **Drop item 3 entirely.** Both of its proposed edits are already shipped: the model-side marker teardown has existed in both `wrap-session.md` copies since 2026-06-10 (Step 13 / Step 7), and the `close-worktree-session.md` L127-131 correction landed in commit `8de46fd` (2026-07-14 S8), which explicitly reasoned through and rejected the "false-fire" framing item 3 restates. Re-applying item 3 as written risks silently reverting a deliberate, already-loud correction — the opposite of OP-11. If a *new* marker-corpse incident is observed after today, open a fresh, execution-verified investigation against that specific incident rather than reusing this now-falsified hypothesis.
- **Split item 4 out of this bundle and re-gate it on its own.** It independently carries High/High (Permissions/Reversibility) and two prior risk-checks on this same subsystem (`2026-07-14-batched-repo-repair-V2-post-reconsider.md`, `…-marker-grammar-hook-wiring-deny-rules.md`) already returned RECONSIDER for materially the same capability. Before re-submitting: add an explicit timestamped-backup step for `~/.claude/settings.json` before the merge (the prior, more careful S8 spec had this; the current description dropped it), and land it as its own change with its own `/risk-check` pass rather than riding alongside three much lower-risk fixes.
- **For item 2b, before landing, state explicitly what happens in an ordinary project session** (not an `ai-resources` worktree) invoking `/risk-check` — confirm `git rev-parse --show-toplevel` there still routes reports to canonical `ai-resources/audits/risk-checks/`, or scope the fix (e.g., only override when the resolved toplevel's basename is `ai-resources`) so the common case is provably unaffected.
- **Items 1 and 2c can very likely proceed largely as-is** once rescoped away from items 3 and 4 — both were observed and traced cleanly in this review, with no contradicted claims and no dimension above Medium on their own.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, git history/diff, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
