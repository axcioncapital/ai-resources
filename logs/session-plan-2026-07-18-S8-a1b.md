# Session Plan — 2026-07-18

## Intent
Replace the blanket `Bash(git checkout *)` deny in `~/.claude/settings.json` and workspace-root `.claude/settings.json` with rules that block only the destructive forms, so ordinary branch and merge work runs unblocked.

## Model
opus — match (deciding: the deny-glob grammar may be too weak to express the destructive/safe split, and a prior RECONSIDER must be answered on its merits)

## Source Material
- `/Users/patrik.lindeberg/.claude/settings.json` (deny entry at `:47`)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.json` (deny entry at `:27`)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/repo-health-backlog-2026-07.md` (thread 4)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-07-14-batched-repo-repair-marker-grammar-hook-wiring-deny-rules.md` (the RECONSIDER, Dimension 2)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-destructive-liveness.sh` (already-wired PreToolUse Bash hook — the fallback design surface)

## Findings / Items to Address

1. **The rule blocks by verb, not by effect — proven this session.** `git checkout --help`, which cannot modify a byte, is denied. (Executed this session; permission denial returned.)
2. **Both rules confirmed live at the lines the mission names.** `~/.claude/settings.json:47` and workspace-root `.claude/settings.json:27`, both `"Bash(git checkout *)"`, both sitting beside `rm -rf`, `sudo`, `git reset --hard`. `ai-resources/.claude/settings.json` has a deny array but no checkout entry. (Grepped this session.)
3. **`bypassPermissions` cannot waive a deny entry** — both files set `defaultMode: bypassPermissions` and the block still fires. Deny outranks mode and allow.
4. **⚠ THE LOAD-BEARING FINDING — the obvious narrowing is refuted, with receipts.** `audits/risk-checks/2026-07-14-…-deny-rules.md` Dimension 2 verified by `fnmatch` that replacing the blanket rule with `git checkout -- *` + `git checkout .` + `git checkout -f *` leaves **`git checkout HEAD -- f.txt`, `git checkout main -- f.txt`, and `git checkout HEAD .` allowed** — all three discard uncommitted work, all three are denied today. The tree-ish-pathspec form `git checkout <tree-ish> -- <path>` is covered by none of the three patterns. **That design is a net widening of destructive capability, not a narrowing.** It must not be re-proposed.
5. **The RECONSIDER was on a seven-item BUNDLE, not on this change alone.** Its High scores on Blast Radius (26 consumers / 19 must-change) and Reversibility (state propagating outside git) were driven by the *other* items — `install-hooks.sh` writing `~/.claude/settings.json`, the marker-grammar change across 24 symlinked commands. Dimension 2's High, however, was earned by the deny set **itself** and survives unbundling. **Unbundling is a real mitigation for 3 and 4; it is not one for 2.**
6. **Open design question the plan must answer, not assume:** whether the deny-glob grammar can express "a checkout carrying a pathspec" at all. If `Bash(git checkout * -- *)` matches `git checkout HEAD -- f.txt` while leaving `git checkout -b new` alone, a settings-only fix works. If it cannot, the distinction has to move to `check-destructive-liveness.sh`, which parses the command properly.
7. **Do not touch `"model": "opus[1m]"`** at `~/.claude/settings.json` while editing that file — operator-DECLINED 2026-07-13.
8. **Mission thread 4 also asserts the queued `/friday-act` fix targets the wrong rule.** Already verified false-routed on 2026-07-18 (S6-ac5). No action here beyond not relying on that plan.

## Execution Sequence

1. **Enumerate the true destructive-form set.** Every `git checkout` shape that can discard uncommitted work, including the tree-ish-pathspec form finding 4 names. *Verification:* each form carries a one-line reason it is or is not destructive; the list is a superset of the three the prior review caught.
2. **Establish the matcher semantics empirically.** Determine how Claude Code deny globs match, and confirm the model reproduces observed reality — the blanket rule must predict the `--help` block seen this session. *Verification:* the model retro-predicts the known-true case; if it cannot, the model is wrong and step 3 is invalid.
3. **Build the candidate deny set and test it as a table — this is the falsifiable gate.** Score every command in the table against (a) today's blanket rule, (b) the refuted 2026-07-14 set, (c) the candidate set. *Verification:* the table must be **red for (b)** — reproducing the three re-opened destructive forms — and **green for (c)**: zero destructive forms allowed, and `<branch>` / `-b` / `--ours` / `--theirs` / `--help` all allowed. A candidate set that cannot make (b) fail is not being tested properly.
4. **If step 3 cannot produce a clean set, stop and switch designs** to the `check-destructive-liveness.sh` route rather than shipping a leaky glob. *Verification:* explicit recorded decision, not a drift into the fallback.
5. **Run `/risk-check`** (plan-time gate, Autonomy Rule #9 — permission change). Hand the reviewer the step-3 table as given state rather than making it rebuild it (per the 2026-07-18 telemetry recommendation), and instruct it to spot-check and extend. *Verification:* verdict written to `audits/risk-checks/`; NO-GO or a second RECONSIDER halts per the mandate's stop condition.
6. **Apply the two settings edits.** *Verification:* read both files back from disk.
7. **Live execution test.** Run the safe forms and confirm they execute; attempt the destructive forms and confirm they still block. *Verification:* actual command output pasted, not asserted — the mission's standing non-negotiable.
8. **Close the loop.** Tick mission thread 4 via `/mission check`; flip the improvement-log entry citing what shipped. *Verification:* grep both files for the changed state.

## Scope Alternatives

- **Min** — the two settings files only, with the step-3 table as evidence. Leaves `permission-template.md` describing a shape the repo no longer runs.
- **Recommended** — Min + `permission-template.md` updated to the canonical narrowed shape + thread 4 ticked + improvement-log flipped. Keeps the docs and the live config in agreement, which is the drift class this repo logs most often.
- **Max** — Recommended + move the destructive-form decision into `check-destructive-liveness.sh` so it is parsed rather than glob-matched. **Deferred unless step 4 forces it** — it is a hook-behaviour change with its own risk profile, and thread 3 has already established that hook *wiring* is unversioned, so a hook-dependent fix inherits that weakness.

## Autonomy Posture
Gated

**Stop points:**
- After step 3's table — the design is confirmed against evidence before any settings file is touched.
- After step 5's `/risk-check` verdict — NO-GO, or a second RECONSIDER on the narrowed design, halts the session per the mandate.
- If step 4 fires and the design must switch to the hook route.

## Risk
Run `/risk-check` after the plan is approved (plan-time gate). Run it again before commit (end-time gate).

Structural classes touched: **permission changes** across two settings layers, one of them (`~/.claude/settings.json`) outside any git repo — so that half is not revertible by `git revert` and rollback is a manual restore. This is the same class that returned **RECONSIDER** on 2026-07-14 with Permissions scored **High**; per `docs/audit-discipline.md` a RECONSIDER is not downgraded to push a change through. Two things are materially different this time and both must be stated to the reviewer rather than assumed in its favour: the change is **unbundled** from the six other items that drove the High Blast-Radius and Reversibility scores, and the **specific refuted deny set is now known and excluded by construction**. Dimension 2's High was earned by the deny set itself and unbundling does not answer it — only the step-3 table can.

No environment-fit concern: the work product is configuration, not a launcher.
