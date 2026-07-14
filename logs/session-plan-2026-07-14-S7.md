# Session Plan — 2026-07-14 S7

## Intent

Implement the approved repo-repair pilot V1 (`~/.claude/plans/investigate-why-our-recurring-humble-curry.md`) in its stated execution order: two agent edits that grade the *premise* of a change rather than its safety, two one-line contract footers, two subtractive doctrine edits, and one new `PreToolUse` hook that blocks edits to protected files until a file-bound gate receipt exists — with the hook **proven to block** before anything is committed.

## Model

**Recommended: opus.** Deciding work, not doing work — the change set installs a blocking guard on every Edit/Write to commands, agents, skills, hooks and settings. A false-block or a fail-open here degrades every future session in every project. Active model: `claude-opus-4-8[1m]` — **match.**

## Source Material

- `~/.claude/plans/investigate-why-our-recurring-humble-curry.md` — the approved plan (V1, post-consult, with the 2026-07-14 addendum folded in). **Authority for this session.**
- `~/.claude/plans/investigate-the-current-state-radiant-cat.md` — same-day repo investigation; source of the addendum's four corrections.
- `ai-resources/audits/research-workflow-deployment-fitness-2026-07-13.md` — **the regression-test input with a known answer.** 8 findings, 7 declared "fix before deployment", 0 of the 3 that reached implementation survived contact with the code. The old `qc-reviewer` passed it with a **GO**.
- `ai-resources/.claude/hooks/warn-settings-change.sh` (workspace root copy) — the `exit 2` pattern being modelled; itself an unwired orphan, to be retired.
- `ai-resources/docs/protected-zones.md`, `docs/audit-discipline.md` — the doctrine source table the hook enforces.

## Findings / Items to Address

**The root cause the plan targets.** Every gate in this repo grades an **artifact**; not one grades a **claim**. `/risk-check`'s six dimensions all ask *"is this change safe?"* — none asks *"is this change necessary?"*, and the reviewer is instructed verbatim to *"treat the passed inputs as the entire world."* So a diagnosis that invents a consequence propagates through every downstream gate, each of which validates everything except the assertion. That is how an audit that was 7-of-8 wrong sailed through QC with a GO, and how `/consult` once reasoned impeccably about a bug that did not exist.

1. **`risk-check-reviewer.md` — no Problem-Reality dimension.** Grep confirms no gate anywhere asks whether the defect being fixed was *observed* or merely *inferred*.
2. **`qc-reviewer.md` — no premise check.** Contains zero matches for `consequence`, `premise`, or `falsif*`. It re-verifies that quoted lines *exist* — and in the F-1 failure, every citation was accurate; the invented part was the *consequence*.
3. **No hook fires the gates.** `docs/audit-discipline.md:53` states it verbatim: *"There is no auto-firing hook."* The trigger is self-judged (`wrap-session.md:219`: *"Derive from conversation context"*), and the anti-ceremony doctrine gets used as a waiver. A no-self-waiver rule **already exists** at `audit-discipline.md:30` and **has already failed six times** — which is why V1 adds a hook, not a fifth restatement.
4. **Receipts must bind to the file, not the day.** "Any report dated today" would let one unrelated risk-check unlock every protected file for the rest of the day. This repo has been burned twice by guards that failed open.
5. **`protected-zones.md` self-waivers** (*"cosmetic/doc edits may skip"*, *"`/risk-check` if behavior-changing"*) are the exact words both operator-caught skips were rationalised in. Subtractive fix.
6. **`audit-discipline.md` gates "new" commands/skills, not "edited"** ones — so editing a shipped command is ungated by construction, and agents are absent from the class list entirely.
7. **Addendum corrections (do not re-derive):** the §4b liveness rule is **STALE** (already shipped as `check-destructive-liveness.sh`, `0667cc6` — do not re-implement); the new settings.json hook entry must **quote** `$CLAUDE_PROJECT_DIR` (all 9 existing entries are unquoted and survive only via zsh); `/risk-check`'s wrong-checkout report bug is a **false-block risk** for the new hook (test 8); `warn-settings-change.sh` is superseded and gets deleted in the same change.

## Execution Sequence

Dependencies are real. The plan's resume block forbids reordering.

- **Stage 0 — `risk-check-reviewer.md`: Dimension 7 (Problem Reality).** Grade the *defect* and its *consequence* separately; an asserted-but-unobserved defect scores INCOMPLETE, pushing the verdict toward RECONSIDER.
- **Stage 1 — `qc-reviewer.md`: the premise check.** Verify the consequence, not the citation. Plus search-space validation (*a failed search in one directory does not establish absence*) and an independent-verification clause (*restating the author's reasoning does not count*).
- **Stage 2 — REGRESSION TEST A, immediately.** Re-run the edited `qc-reviewer` against the research-workflow audit it already passed with a GO. **Known answer: 7 of 8 findings are wrong.** Pass condition: it must now catch **F-1** (accurate citation, invented "unconditional runtime deadlock" consequence) and ideally that **F-9 and F-13(b) contradict each other inside the same document**. **If it still returns GO → STOP.** The premise check is words and the plan rests on sand. Report honestly.
- **Stage 3 — `Files-checked:` footers** in `risk-check.md` and `consult.md`. One line each. **Must precede the hook — the hook reads this field.**
- **Stage 4 — doctrine docs.** `protected-zones.md` (subtractive: delete self-waivers; new-**or-edited**; replace judgment-conditioned `/consult` triggers with path triggers) and `audit-discipline.md` (one line: new-**or-edited**, add agents). **Must precede the hook — they are its source table.**
- **Stage 5 — `require-gate.sh` + wire it** in `ai-resources/.claude/settings.json` (path **quoted**). Retire `warn-settings-change.sh`.
- **Stage 6 — run the 8 hook tests (§5).** Especially **test 2** (a receipt for file A must NOT release file B — the fail-open bug), **test 6** (break `python3`; it must still block), and **test 8** (the wrong-checkout receipt case). A guard that has not been *seen to block* is not installed; it is decoration.
- **Stage 7 — commit.** Only after Stage 6 passes. **Do not push** (gated to `/wrap-session`).

## Scope Alternatives

- **Full plan (chosen).** All seven files + the hook, gates run, tests run.
- **Halve it — the agent edits only (Stages 0–2), defer the hook.** Genuinely viable: the plan itself calls `qc-reviewer` *"the root-cause fix"* and *"highest leverage"*, and Regression Test A has a known answer, so the premise check can be *proven* to work on its own. The hook is enforcement, not diagnosis. **Fallback if the hook proves noisy or the gates return RECONSIDER on it.**
- **Hook only.** Rejected — it would enforce gates whose reviewers still cannot tell a real defect from an invented one. Enforcement without the premise check buys *more authoritative propagation of bad premises*, which is precisely the documented failure.

## Autonomy Posture

**Gated.** Structural + architectural change classes: new hook, hook wiring in `settings.json`, agent edits, command edits, and two doctrine docs that define when the gates fire. Autonomy Rule #9 applies. Execution itself proceeds under full autonomy once the gates return; commits are direct; **no push**.

Hard rules carried from the plan's resume block, non-negotiable:
- **Never `git add -A` / `git add .`** — stage only the named paths. `check-foreign-staging.sh` has already failed open once.
- **No `worktree remove`, `branch -D`, `reset --hard`, `clean -f`.** An approved plan came one step from destroying 173 lines of live uncommitted work.
- **Expect the concurrent-session detector to cry wolf** (stale per-id markers). Note it; do not "fix" a marker mid-run.
- **Do not commit until §5 passes. Do not push at all.**

## Risk

**`/risk-check` is mandatory and runs before implementation** — architectural class, and the plan gates its own construction: *"If the plan cannot pass the gate it installs, the gate does not work."* `/consult` runs alongside it, because this change edits `protected-zones.md` and `audit-discipline.md` — **architectural tier under the very rules being installed**, and a gate cannot review its own redefinition.

`/blindspot-scan` is **skipped, with reason.** Its distinctive check — *will this actually run and get used in the real environment?* — is performed **empirically** by the §5 test suite, which is a strictly stronger form of the same test. Precedent: 2026-07-14 S1, same reasoning, logged.

**Named residual risks:**
- **False blocks.** The wrong-checkout `/risk-check` report bug (open, 2026-07-14) can leave a receipt where the hook cannot see it → a legitimately-gated edit is blocked. *A phantom block in this repo gets bypassed* — that is the documented failure pattern, and it would kill the hook. Test 8 exists for this.
- **Fail-open.** A receipt that releases the wrong file makes the guard worthless. Test 2.
- **The guard that cannot run.** If `python3`/`git` is missing or the script errors → it must **block**, never pass. Test 6.
- **Honest scope limit (from the plan, not hidden):** a false problem whose fix touches only *unprotected* files still bypasses everything. V1 **reduces** this class; it does not close it. That is V2.
