# Session Plan — 2026-07-13

## Intent
Establish by execution what `/deploy-workflow` actually does with the research-workflow template's placeholders, then fix Steps 5–7 and Step 11's leftover-placeholder assertion so it fills only the immediate deploy-time placeholders (including `{{CONFIDENTIAL_IDENTIFIER_N}}`), leaves template-internal placeholders and unused optional components byte-identical, and validates only what deployment must resolve — without widening the discovery regex.

## Model
opus — match. (Deciding, not doing: the session must adjudicate a *contested* blocker claim against real behaviour, then design the replacement contract. The mechanical part — running the code — is the cheap half.)

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow/.claude/commands/deploy-workflow.md` (349 L — Steps 5, 6, 7, 11 are the edit surface)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow/workflows/research-workflow/SETUP.md` (de-facto placeholder reference; incomplete)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow/workflows/research-workflow/` (the template — 6 `reference/*.template.md` files)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow/logs/missions/research-workflow-deploy-fitness.md` (**governing plan** — supersedes the audit where they disagree)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow/audits/research-workflow-deployment-fitness-2026-07-13.md` (diagnosis only; §4 D-3 is REVERSED by §7 — do not implement §4)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow/output/context-packs/command-20260713-d3b6a/pack.md` (this session's context pack)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` (structural change classes — a command edit is one)

## Findings / Items to Address

Items 1–4 come from a **direct read of the command's code** this session, not from the audit. Items 5–8 come from the context engine. Item 9 is the mission's standing constraint.

1. **Step 5's discovery regex is `{{[A-Z_]*}}` — no digits** (`deploy-workflow.md:253`). `{{CONFIDENTIAL_IDENTIFIER_1}}` and `{{CONFIDENTIAL_IDENTIFIER_2}}` contain digits and therefore **cannot** be discovered. Confirms the mission's claim (`missions/…:128`) at the file level. *Still to be confirmed by execution.*
2. **Step 5 scans the whole project tree**, including the six `reference/*.template.md` files, so template-internal placeholders are discovered and prompted for at deploy time. This is the "65 of 128 demanded prematurely" problem (mission `:128`).
3. **Step 7's `sed` runs across every `*.md`** (`:277`), including the six `*.template.md` files — so a correct fill still **corrupts the template shapes**. This is why the audit's "widen the regex" remedy is actively dangerous.
4. **NEW — Step 7's shell is broken independent of placeholders** (`:277`): `find {DIR} -type f -name "*.md" -o -name "*.json" | xargs sed -i ''`. Two defects: (a) the `-o` breaks `-type f`'s grouping, so the second branch is untyped; (b) bare `xargs` word-splits on whitespace — and **every real deploy path contains a space** (`…/Claude Code/Axcion AI Repo/…`). Found by reading, not in the audit or the pack. *Must be confirmed by execution — it may mean Step 7 has never worked as written.*
5. **Step 7's verify (`:285`) and Step 11 item 1 (`:332`) both assert zero remaining `{{`.** With template files correctly preserved, both assertions **must** fail. Fixing 5–7 without Step 11 leaves the deploy red on a correct run. (Engine; scope widened to Step 11 at mandate confirmation.)
6. **`SETUP.md` (:44, :173) carries a literal `{{PLACEHOLDER}}` documentation token** that today's regex **does** match — so the deploy currently prompts the operator for the value of a doc example. (Engine.)
7. **No canonical deploy-time placeholder list exists.** `SETUP.md:182–196` is the closest and omits `{{CONFIDENTIAL_IDENTIFIER_1/2}}` and all 13 Project Config fields. **Producing that list is part of the fix**, not a precondition. (Engine.)
8. **No dry-run/scratch mode.** Step 2 hardcodes the target under `projects/`; Step 9 runs `git init` + commit. The acceptance test needs a purpose-built scratch harness — it cannot be a bare `/deploy-workflow` invocation. (Engine.)
9. **The audit contradicts itself and nothing marks it** — §4 D-3 (:103) still says "widen the pattern"; §7 (:151) and the mission (:128) reverse it. The mission governs. Do NOT widen the regex.

## Execution Sequence

**Wave 1 — Verify by execution (the load-bearing wave; S11's standing rule).**

1. **Build the scratch fixture.** Copy `workflows/research-workflow/` to a scratch dir under the session scratchpad (NOT under `projects/`, which the real command hardcodes — the fixture must not create a project or a git repo). Record the byte-level baseline: `find … -type f -exec shasum {} \;` over the six `*.template.md` files.
   *Verify:* fixture exists; the six template files are present with recorded hashes; nothing was written under `projects/`.
2. **Execute Step 5's literal grep** against the fixture. Record: how many placeholders it discovers; whether `{{CONFIDENTIAL_IDENTIFIER_1/2}}` are missing; whether `{{PLACEHOLDER}}` (the doc token) appears; how many of the discovered set live only inside `*.template.md`.
   *Verify:* an explicit discovered-vs-actual table, with the actual set derived from a separate `{{[A-Za-z0-9_]+}}` scan of the fixture.
3. **Execute Step 7's literal `find | xargs sed`** against the fixture with a sample value, on a path **containing a space** (mirroring the real deploy path).
   *Verify:* does it run at all, or break on the space? Re-hash the six `*.template.md` files — corrupted or intact?
4. **Execute Step 7's verify grep and Step 11 item 1** against the post-fill fixture.
   *Verify:* do they report leftover placeholders on an otherwise-correct deploy?
5. **Write the PRE-FIX verdict.** State plainly, with the recorded outputs as evidence, whether thread 2 is a **real deployment blocker**, a **latent contract defect** (thread 1's shape), or something else. **This verdict — not the audit's label — governs the rest of the session.**

**→ STOP POINT 1: report the verdict before designing any fix.**

**Wave 2 — Design and apply the fix (shape depends on Wave 1's verdict).**

6. **Produce the canonical deploy-time placeholder list** (Finding 7) — the explicit set that deployment must resolve, incl. `{{CONFIDENTIAL_IDENTIFIER_1/2}}` and the 13 Project Config fields. Source it from the template's real contents, not from `SETUP.md`'s incomplete table.
7. **Rewrite Step 5** to select from that explicit list rather than discover by regex — the regex is **not widened**; it is demoted from *authority* to *cross-check* (it may still report anything found outside the list, as a warning, so a new placeholder can't be added silently).
8. **Rewrite Step 7** to (a) exclude `*.template.md` and unused optional components from the `sed` pass, and (b) fix the `find`/`xargs` shell defects (Finding 4) — `-type f \( -name … -o -name … \)` and `-print0 | xargs -0`.
9. **Rewrite Step 7's verify and Step 11 item 1** to assert zero remaining **deploy-time** placeholders, explicitly tolerating template-internal ones in the preserved files.
10. **Fix `SETUP.md`'s `{{PLACEHOLDER}}` doc token** (Finding 6) so it is not mistakable for a real placeholder, and reconcile its placeholder table with the canonical list from step 6.

**Wave 3 — Prove the fix, gate it, land it.**

11. **Re-run the full Wave-1 harness against a clean fixture** using the fixed logic. *Verify (the acceptance test, verbatim from the mission):* every deploy-time placeholder filled incl. `{{CONFIDENTIAL_IDENTIFIER_N}}`; every `*.template.md` and every unused optional component **byte-identical** (hash comparison against the Wave-1 baseline); validation passes and never prompts for a template-internal value. **Pre-fix must FAIL this test and post-fix must PASS it** — a test that is green both ways proves nothing (thread 1's lesson).
12. **`/risk-check`** on the command edit (structural class: existing-command edit with real blast radius — it writes new project trees). Plan-time gate.

**→ STOP POINT 2: `/risk-check` verdict. RECONSIDER or NO-GO halts the session per the mandate's stop-if.**

13. **Tick thread 2 in the mission file citing the acceptance-test result** — or **reclassify it with evidence** if Wave 1 showed it is not a blocker. Commit (no push).

## Scope Alternatives

- **Min** — Wave 1 only: execute, produce the blocker verdict, record it in the mission file, stop. Correct if Wave 1 shows thread 2 is *not* a blocker AND the fix turns out larger than one session. Leaves the deploy broken but the record honest.
- **Recommended** — Waves 1–3 as sequenced. The fix is bounded (one command, ~4 steps, plus a `SETUP.md` table) and the blast radius is one command (`/sync-workflow` carries no placeholder logic).
- **Max** — additionally fold in thread 3 (deploy hygiene bundle), which touches the same command. **Rejected:** the mandate puts threads 3–8 out of scope, and this mission's stated primary failure mode is scope creep.

## Autonomy Posture
Gated

**Stop points:**
- **After Wave 1** — report the PRE-FIX blocker verdict before designing a fix. If thread 2 is *not* a blocker, the mission has **zero** demonstrated blockers and the deployment gate itself needs re-examination — an operator decision, not mine.
- **At `/risk-check`** — RECONSIDER or NO-GO halts execution (mandate stop-if).

## Risk
Run `/risk-check` after the plan is approved (plan-time gate). Skip the end-time gate only if the plan-time check covered the exact diff with mitigations applied and drift stayed bounded (workspace end-time skip rule).

**Structural class:** existing-command edit whose output is a *new project tree on disk* — `/deploy-workflow` `sed`s across files and `git init`s a repo. Blast radius verified as **one command**: `/sync-workflow` carries no placeholder logic (context engine), so there is no mirrored copy to drift.

**Named hazards for this specific work:**
- The scratch harness must **never** write under `projects/` or run `git init` in the real workspace — the command's Steps 2 and 9 do exactly that, and I am executing its code blocks by hand. Fixture goes to the session scratchpad.
- The `sed -i ''` in Step 7 is destructive and in-place. It runs only against the fixture, never against `workflows/research-workflow/` itself. Confirm the target path on every invocation.
- **Environment-fit:** not applicable — the work product is a command file, not a launcher.
