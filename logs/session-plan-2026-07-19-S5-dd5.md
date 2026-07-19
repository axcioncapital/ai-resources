# Session Plan — 2026-07-19 S5-dd5

## Intent

Fix two globally-registered hooks: `check-foreign-staging.sh`'s wrong-repo resolution (returning from a `/risk-check` RECONSIDER with the redesign that gate prescribed) and `check-destructive-liveness.sh`'s two override defects (an override flag accepted without binding to the destructive verb; an audit line claiming success at PreToolUse, before the command runs).

## Model

opus — item 1 is a redesign of the single hook that gates every `git add`/`git commit` in every checkout, returning from a RECONSIDER on an unresolved design question. Active session model is Opus 4.8: match, no switch needed.

## Verified facts (established by execution this session — each states its instrument AND that instrument's scope)

Per the 2026-07-19 (S4-2b2) usage-log recommendation: every fact below names the instrument that produced it *and* asserts the instrument's scope covers the claim's scope.

1. **Item 1's defect is live.** `Read` of `.claude/hooks/check-foreign-staging.sh:223-224` — file-scoped instrument, file-scoped claim. `project_dir = os.environ.get("CLAUDE_PROJECT_DIR", "") or os.getcwd()`, then `git -C project_dir rev-parse --show-toplevel`.
2. **Item 3's defect (a) is live.** `grep -n` of the same file — file-scoped both sides. `:207` reads `re.search(r'\bAXCION_LIVENESS_OVERRIDE=1\b', cmd)` with no binding check.
3. **Item 3's defect (b) is live.** `sed -n '205,230p'` — the audit line is written and `sys.exit(0)` taken inside the `if override:` block at PreToolUse. No `outcome` / `exit_code` field in the record.
4. **Mission thread 11 is SHIPPED, not open.** `git log -1 -- logs/scripts/search-canary.sh` → `028c15a`; `grep -n` of `docs/audit-discipline.md:19` → the § *Absence-claims* section exists. Repo-scoped instrument, repo-scoped claim (both artifacts are in this repo). Item 4 dropped from the bundle on this evidence.
5. **All six `Files in scope` entries exist.** `test -e` per path — path-scoped instrument, path-scoped claim. No entry is a to-be-created file.
6. **The PreToolUse `cwd` field question is SETTLED, not open.** Established by the prior gate via live docs fetch of `code.claude.com/docs/en/hooks.md` (external-scoped instrument for an external-API claim) and independently via `claude-code-guide`. `cwd` is a documented top-level PreToolUse field. This is *not* re-derived here — it is inherited as already-verified, and the instrument that settled it was scope-appropriate.

## Source Material

- `audits/risk-checks/2026-07-19-bundled-staging-hook-repo-resolution-thread-14-orphan-hooks.md` — the RECONSIDER that item 1 is returning from; § *Recommended redesign* (`:149-156`) is the binding spec for item 1's shape.
- `logs/missions/repo-health-backlog-2026-07.md` thread 16 — item 3's source, with both defects stated and an explicit ordering instruction ((a) before (b)).
- `logs/improvement-log.md` 2026-07-19 entry — item 1's source; records that the false BLOCK is unclearable by the remedy the hook itself prescribes.
- `.claude/hooks/check-foreign-staging.sh` — item 1's target; note `:262-267`, a prior load-bearing regex lesson on this same file (an optional group that silently truncates rather than failing).
- `.claude/hooks/check-destructive-liveness.sh` — item 3's target.

## Findings / Items to Address

### Item 3 — `check-destructive-liveness.sh` (sequenced FIRST, deliberately)

- **(a) The override binds to nothing.** `:207` matches `AXCION_LIVENESS_OVERRIDE=1` anywhere in the command string. Confirmed by the mission thread's own execution evidence: `NOTE=AXCION_LIVENESS_OVERRIDE=1 git reset --hard` was accepted and logged as a genuine operator override. The flag was bound to `NOTE`, not to the destructive verb. Fix: require the assignment to sit in the environment-prefix position of the destructive command itself, not merely to appear in the text.
- **(b) The audit trail records outcomes that never happened.** The record is written and exit 0 taken at PreToolUse — *before* execution — so the log line says "proceeded" for commands that may have failed or never run. The schema carries no `outcome` / `exit_code`. This is the messier half; the mission thread says fix (a) first because it removes the live hazard cheaply.
- **Why item 3 goes first:** it is small, independently testable, touches a different file from item 1, and its (a) fix has a clean negative test. Landing it first means item 1's larger design work is not gating a fix that is ready.

### Item 1 — `check-foreign-staging.sh` (sequenced SECOND, with its own fixture suite and its own commit)

- **The defect.** `:223` resolves the repo from `CLAUDE_PROJECT_DIR` (or the CLI's own cwd), not from the Bash call's target. Running `git add` inside a nested project repo judges the footprint against the *wrong* tree, producing a false BLOCK that widening the footprint cannot clear — so the only escape is bypassing the guard, which trains the bypass.
- **The design gap that earned the RECONSIDER, unchanged and still the hard part.** `cwd` in the PreToolUse payload is a snapshot taken *before* the gated command runs, so `cd nested && git add .` in one Bash call reports the pre-`cd` directory. Handling this wrong reopens the fail-open that `979ed01` closed on this same hook two days ago.
- **The gate's binding requirements** (`:152-155`): decide and test compound-`cd` handling *before* writing the fix, not as a "candidate"; build the fixture suite first; name an explicit rollback plan in the landing commit message; make an explicit fix/delete/park call on the `.codex/hooks/` sibling fork.
- **Deviation from the gate, stated rather than hidden.** The gate said "split Item 1 into its own dedicated session — do not bundle it with Items 4/6 for landing." This session bundles it with item 3 instead. That is a different shape (separate file, separate commit, no shared code path) but it is still a bundle, and the new `/risk-check` should score it as such rather than take this paragraph's word for it.

## Execution Sequence

### Stage 0 — Plan-time gate
- Run `/risk-check` on the combined change set. Both items are hook edits (structural class); item 1 carries a prior RECONSIDER. Pass the verified-facts block above into the brief so the reviewer scores it rather than rebuilding it — and, per the 2026-07-19 recommendation, state each fact's instrument scope so a repo-scoped tool is never standing in for a workspace-scoped claim.
- On RECONSIDER/NO-GO for an item: record it, build nothing on that item, do not argue the gate down. The stop condition is the mandate's, and it fired on this same item last session — honoring it is why the item came back with a real design instead of a candidate.

### Stage 1 — Item 3(a): bind the override
- Write the negative fixture FIRST: `NOTE=AXCION_LIVENESS_OVERRIDE=1 git reset --hard` must be REJECTED. Confirm it currently PASSES (reproducing the defect) before changing any code — a test that cannot fail against the broken version proves nothing.
- Fix the match so the assignment must occupy the environment-prefix position of the destructive command.
- Verify both directions: the negative case now blocks; a genuine `AXCION_LIVENESS_OVERRIDE=1 git reset --hard` is still accepted.

### Stage 2 — Item 3(b): make the audit record honest
- Decide between two shapes and state the choice: add `outcome`/`exit_code` and move the write to where outcome is known, or keep the PreToolUse write but relabel the field to what it actually asserts (an override was *requested and accepted*, not that the command *succeeded*). The second is smaller and may be the honest fix; the first is what the thread implies. Decide on evidence, not on which is more work.

### Stage 3 — Item 1: fixtures before code
- Build the three-fixture suite first, each verified to FAIL against the current hook: (i) nested-repo false BLOCK reproduction; (ii) genuine foreign-staging still BLOCKS; (iii) `cd nested && git add .` compound case.
- Only then decide compound-`cd` handling, and only then write the fix.

### Stage 4 — Item 1: `.codex/` sibling fork
- Explicit fix / delete / park call on `.codex/hooks/check-foreign-staging.sh`, recorded with a date. It is currently unregistered, inert, and behind the canonical copy. Not left to diverge silently.

### Stage 5 — Land
- Two commits, one per hook. Item 1's commit message names the rollback plan explicitly — this hook is registered once, globally, and gates every commit in every checkout.

## Scope Alternatives

- **Both items (planned).** Highest value; item 1 is the one with a real operator-facing cost today.
- **Item 3 alone.** The de-risked subset, offered at the approval gate and not taken. Still the correct fallback if `/risk-check` RECONSIDERs item 1 a second time — Stage 1/2 stand alone with no dependency on Stage 3.
- **Item 3(a) alone.** The minimum that removes a live hazard: ~one regex plus two fixtures. Correct if context runs short.
- **Neither.** Only if the gate returns NO-GO on both, which the evidence does not suggest.

## Autonomy Posture

Gated. Both items are hook edits (structural change class per `docs/audit-discipline.md`), so `/risk-check` runs before execution. Within the gate's verdict, full autonomy — no per-stage operator prompts; the Step 8c.6 approval covered execution for both items. Between-stage summaries emitted per the workspace `Between-gate summaries` rule.

## Risk

- **Highest risk is item 1's compound-`cd` path reopening a fail-open closed two days ago.** Mitigation: fixture (iii) exists specifically to prove it did not, and is written before the fix.
- **Blast radius is maximal for both hooks** — one gates every commit, the other every destructive command, both registered globally. Mitigation: separate commits, named rollback plan, fixtures that must fail first.
- **A second RECONSIDER on item 1 is a live possibility.** That is an acceptable outcome, not a failure: the stop condition holds and Stage 1/2 still land.
- **Known trap this session must not repeat.** Five of the last six sessions logged a plausible number substituting for a measurement. Every count or absence-claim here is derived by execution with a scope-matched instrument, or it is not stated. `grep -r <term> .` is blind in this shell (thread 11, verified) — use `command grep`, `git grep`, or an explicit subdirectory.
