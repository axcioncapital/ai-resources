# Session Plan — 2026-07-25

## Intent
Complete five verified-premise repo-integrity fixes in one wave: stash handling in `/close-worktree-session`, a verify-first rewrite of five deploy-fitness mission threads, two friction-log subheader repairs, and two closures of threads already verified fixed.

## Model
opus — match (active session is Opus 5). Item 1 is a *deciding* task (design a guard against a data-integrity failure whose mechanism is still an open empirical question); items 2–5 are *doing*. Higher-cognitive-load item sets the tier.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/close-worktree-session.md` (249 lines; Step 2 clean-guard at `:80-94`, Step 4 merge at `:175-207`, refusal list at `:20-35`)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` (the 2026-07-17 incident entry at `:1239`, which carries the fix direction and the unresolved empirical question)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/repo-integrity-repairs-2026-07.md` (threads 8, 15, 16, 10)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/repo-health-backlog-2026-07.md` (the `git checkout` thread)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/research-workflow-deploy-fitness.md` (threads 3/4/6/7/8)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md` (the two 2026-07-13 session blocks)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` (change classes — consulted; gate waived, see Risk)

## Findings / Items to Address

1. **`/close-worktree-session` has zero stash handling** — `command grep -ci stash` → 0 (re-derived live this session). Source: mission `repo-integrity-repairs-2026-07` thread 8; incident record `logs/improvement-log.md:1239`. The command's own Step 2 checks only that the **worktree** is clean; nothing checks the **main checkout**, which is what `git merge` (Step 4, `:181`) actually refuses on. The sanctioned-looking workaround — stash main, merge, pop — is precisely what produced the 2026-07-17 incident: a pop conflicted in `friction-log.md` and `<<<<<<< Updated upstream` / `>>>>>>> Stashed changes` markers were committed to HEAD (cleaned by hand in `856d7b3`). The entry's guards at `:29` and `:200-207` are merge-only and do not cover the stash-pop path.
2. **The incident record carries an unresolved empirical question** — `logs/improvement-log.md:1239` asks whether `git stash pop` honors a `.gitattributes` `merge=union` driver (a merge does; a pop may not). This is testable by execution, and the mission's validation contract requires execution evidence rather than reading. Settling it determines whether the union driver is a partial mitigation or none at all.
3. **Deploy-fitness mission threads 3/4/6/7/8 still read as "build this"** — verified live at `logs/missions/research-workflow-deploy-fitness.md` (all five lines present and implementable-framed). That audit's premises have failed 3 for 3 (`logs/improvement-log.md`, 2026-07-14 entry). Source: mission `repo-integrity-repairs-2026-07` thread 16.
4. **Two friction-log session blocks are invisible to their four parsers** — re-derived live (the thread's own line citations had drifted): of 41 top-level blocks, 38 carry a `### Friction Events` subheader; `## Schema` correctly does not (it is the file's schema block, not a session); the two genuine misses are `## Session — 2026-07-13 (S3)` and `## Session — 2026-07-13 (S4)`. Thread 15 says "2 of 5" — the other three were fixed already. Consumers: `/open-items`, `/reconcile-backlog`, `fix-repo-issues-scanner`, `diagnostics-scanner`.
5. **Mission thread 10 is already satisfied** — the cited improvement-log entry now reads `~~OPEN — … no fix applied.~~ **CLOSED — FIXED**`. Verified live. Needs closure with citation, not a fix.
6. **The repo-health `git checkout` thread is already satisfied** — zero `checkout` / `restore` entries across all three `settings.json` deny lists (ai-resources, workspace root, user level; 6/6/3 deny entries respectively, none matching). The deny rule was retired 2026-07-18. Needs closure with citation, not a fix.

## Execution Sequence

1. **Settle finding 2 by execution.** Build a throwaway repo under the scratchpad: a tracked log file, `.gitattributes` with `merge=union` on it, divergent content stashed and popped to force a conflict. Observe whether the union driver governs the pop. *Verification:* the test either produces conflict markers or does not — record the observed output verbatim, not a conclusion. Pre-register the expectation before running (per the falsifiability discipline this repo already applies).
2. **Fix item 1 in `close-worktree-session.md`.** Three edits, shaped by step 1's result: (a) extend the refusal list at `:20-35` with "never commit conflict markers"; (b) add a main-checkout cleanliness pre-flight before Step 4's merge, defining the sanctioned stash path explicitly (record the stash ref; pop is mandatory and its result must be checked) rather than leaving it to improvisation; (c) add a hard conflict-marker gate — `git grep -lE '^(<<<<<<<|>>>>>>>)'` — that must pass before any commit. *Verification:* `command grep -ci stash` > 0, and the marker-scan command executes correctly against a fixture containing markers (exit/paths as expected), not merely reads correctly.
3. **Item 2 — rewrite deploy-fitness threads 3/4/6/7/8** to lead with "verify the premise by execution first". *Verification:* all five lines re-read and each names verification before building; count of rewritten lines = 5.
4. **Item 3 — repair the two friction-log blocks.** Insert `### Friction Events` into the 2026-07-13 S3 and S4 blocks. *Verification:* re-run the derivation script from this session — every top-level `##` session block carries the subheader; `## Schema` remains correctly excluded; count goes 38 → 40 of 40 session blocks.
5. **Items 4 and 5 — close the two already-satisfied threads** via `/mission update` (the sanctioned revision path; `check` exists but its contract-blind defect is a known open thread, so evidence is cited explicitly here rather than relying on it). *Verification:* both threads read as closed, each carrying the citation that proves it.
6. **Tick the mission threads this wave actually closed** (8, 15, 16, 10 on `repo-integrity`; the `git checkout` thread on `repo-health`), each with its execution evidence. *Verification:* re-read both mission files; no thread closed by assertion alone.
7. **Commit.** One commit per coherent unit, per the repo's commit rules. No push (gated to wrap).

## Scope Alternatives

- **Min** — items 3, 4, 5 only (friction-log repair + the two closures). Pure bookkeeping; no command edits; no empirical test. Lands in well under half the effort and still removes recurring `/prime` noise.
- **Recommended** — all five items, including the empirical stash/union test in step 1. The test is what makes item 1 a real fix rather than a plausible-looking guard.
- **Max** — recommended, plus folding the step-1 test result back into the 2026-07-17 improvement-log entry (`:1239`) so its open question is answered on the record, and ticking that entry. Small marginal cost; closes the loop where the defect was first written down.

Recommended is the target. Max is taken if context allows after step 6.

## Autonomy Posture
Full autonomy.

**Stop points:**
- Any item whose premise fails re-verification at execution time — drop that item and report it, rather than building on a premise that did not hold. This is the wave's governing rule: every item here was admitted on verified evidence, and the same standard applies at execution.
- Step 1's empirical test producing an ambiguous result — report the raw output and shape item 1's guard to be correct under *both* readings rather than picking one.

## Risk
Item 1 falls in the `/risk-check` **"automation with shared-state effects"** change class (it restructures a merge/commit path that writes shared logs; the class explicitly covers reordering existing shared-state operations, and the "existing-command refactor" framing does not exempt it). **The plan-time and end-time gates are waived by explicit operator instruction** — "DO not run risk check. Run item 1 too" — recorded as an operator-authorized waiver in `logs/session-notes.md` under this session's header, per `docs/audit-discipline.md` § Risk-check change classes ("No self-waivers … a one-line operator confirmation is required first, always"). This is that confirmation, not a session-side materiality judgment. Not re-proposed; recorded so the waiver is auditable.

No subagents are dispatched this session (standing instruction). Verification is therefore inline and execution-based — which is what the mission's own validation contract demands regardless ("demonstrated by execution … never by reading the script").

Residual risk accepted by the waiver: item 1 edits a command that performs destructive git operations, and its guard is being designed without an independent reviewer. Mitigation carried in-plan — step 1 settles the mechanism empirically before the guard is written, and step 2's verification requires the marker gate to be *executed* against a fixture rather than read.

Items 2–5 touch no structural class: two mission-file text edits, one log data repair, two thread closures.
