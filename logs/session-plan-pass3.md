# Session Plan — 2026-05-25 (Pass 3 — concurrent with sessions 1 & 2)

> **Note:** Two prior session-plan files exist for today (`session-plan.md` = A/E/F session; `session-plan-pass2.md` = SF1 `/session-start` session). This is a third concurrent session. Each plan is independent; no shared workflow.

## Intent
Diagnostic backlog wave 1 — execute the 5 primary items (SF3/R3, R4, R6, R10, R9) plus R7 as stretch goal.

## Class
mixed (5 implementation items + 1 design item — R7)

## Model
opus — match (active = opus; design item R7 + risk-check judgment surfaces justify opus tier)

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/token-audit-2026-05-25-ai-resources.md` — source diagnostic; §9.2 has full R3/R4/R6/R7/R9/R10 specs
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/create-skill.md` — item 1 (R3) target
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md` — item 2 (R4) target
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md` — item 3 (R6) target
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json` — item 4 (R10) target
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/skills/knowledge-file-producer/` and `.../report-compliance-qc/` — item 5 (R9) targets (2 skill copies)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-checkup.md` + new file under `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/` — item 6 (R7) targets (stretch)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — `/risk-check` class lookups for R3/R6/R7/R9

## Findings / Items to Address

1. **R3 / SF3 — `/create-skill` Step 3 output-to-disk fix.** Audit §9.2 R3: (a) remove main-session read of `references/evaluation-framework.md` (307 lines); pass file path to evaluator subagent directly. (b) Update inline evaluator subagent brief at `create-skill.md` lines 33–46 to write findings to `audits/working/evaluation-{skill-name}.md` and return only file path + 1-line verdict. HIGH priority, 1,500–5,000 tokens saved per invocation. Single-file edit.
2. **R4 — `/prime` pre-fetch log-trio.** Audit §9.2 R4: extend `/prime` Step 1 to also tail-read `logs/decisions.md` (last 10 lines) and `logs/usage-log.md` (last 30 lines) — eliminates the recurring Edit-before-Read failure pattern on `session-notes.md` observed in 3 of last 4 sessions. MEDIUM priority, ~1,500 tokens per wrap session.
3. **R6 — `/wrap-session` `coaching-data.md` tail-read.** Audit §9.2 R6: in `wrap-session.md` Step 7b, replace full Read of `logs/coaching-data.md` (489 lines) with `Bash(tail -n 80 logs/coaching-data.md)`. Preserve a documented fall-back to full Read when structural lookup is needed (per audit caveat). MEDIUM priority, ~5,000–6,000 tokens per coaching-append session.
4. **R10 — `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=80` in env block.** Audit §9.2 R10: add single env-var to `ai-resources/.claude/settings.json` env block (existing block already contains `MAX_THINKING_TOKENS`). 3rd-deferral escalating carryover from prior audits (2026-04-18, 2026-04-24). LOW priority, 5-min edit.
5. **R9 — reference-skill symlinks.** Audit §9.2 R9: convert 2 directories `workflows/research-workflow/reference/skills/knowledge-file-producer/` and `.../report-compliance-qc/` from copies to symlinks pointing at canonical `skills/<name>/`. **Pre-flip verification required:** grep `/deploy-workflow.md`, `/new-project.md`, and `/sync-workflow.md` for `cp -L` or `cp -P` flags that would dereference symlinks (silent template-deploy breakage risk per QC note). LOW priority, eliminates drift risk.
6. **R7 — `/friday-checkup` fading-gate-scan subagent (stretch).** Audit §9.2 R7: create new subagent (e.g., `.claude/agents/fading-gate-scanner.md`) that reads up to 9 per-project `coaching-data.md` files, applies the `gate-calibration.md` suppression check, returns per-scope gate findings ≤30 lines. Wire into `friday-checkup.md` Step 6 (monthly tier). MEDIUM priority, 3,000–8,000 tokens saved on monthly Friday sessions.

## Execution Sequence

**Phase 1 — Trivial isolated edits (no `/risk-check` required)**

1. **R10** (settings.json env-var add). Verify by Reading the env block before and after. Stop condition: `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=80` appears in the env block; no other keys touched. Commit immediately.
2. **Between-item check:** `git fetch origin && git diff HEAD origin/main -- .claude/commands/wrap-session.md .claude/commands/prime.md .claude/commands/create-skill.md` — if any of the next-targets show incoming diff, pause and assess.

**Phase 2 — Quick-win symlink conversion (gated by pre-flip verify)**

3. **R9 pre-flip verify.** Grep `/deploy-workflow.md`, `/new-project.md`, `/sync-workflow.md` for `cp` invocations against `workflows/research-workflow/`. If any use `-L` / `-P` / `--dereference` — STOP, defer R9 to a separate session.
4. **R9 flip** (if verify clears). Replace each of the 2 directories with a symlink to canonical `skills/<name>/`. Verify by Reading SKILL.md via the symlink path. Commit.

**Phase 3 — Flow-command edits (single bundled `/risk-check` gate)**

5. **`/risk-check` plan-time gate** on the bundle: R4 (`prime.md`) + R6 (`wrap-session.md`) + R3 (`create-skill.md`). All three are canonical-command edits; bundling avoids 3 sequential gate calls.
6. **R4** (`/prime` Step 1 pre-fetch additions). Verify Step 1 still parses; tail-reads are bounded.
7. **R6** (`/wrap-session` Step 7b tail-read swap + documented fallback note).
8. **R3** (`/create-skill` Step 3: remove main read + update subagent brief).
9. Commit Phase 3 as a single batch (per audit-discipline.md § batching).

**Phase 4 — R7 stretch (only if context budget permits)**

10. **Context budget check.** If context usage > 50%, defer R7 to next session and write deferral note to session-notes.md.
11. **`/risk-check` plan-time gate** on R7 (new agent class — required per `audit-discipline.md`).
12. **R7 implementation.** Draft `fading-gate-scanner.md` agent, wire into `friday-checkup.md` Step 6, dry-read against current `gate-calibration.md` to validate.
13. **`/risk-check` end-time gate** on R7 before commit (per new-agent class rule).

## Scope Alternatives

- **Min:** R10 + R4 + R6 only — three trivial wins, ~30 min total, no `/risk-check` required (R4/R6 are minor additions to existing canonical commands, not structural changes; risk-check still recommended but not blocking).
- **Recommended:** Phases 1–3 (R10, R9, R4, R6, R3) — full mandate items 1–5, ~90 min, single bundled `/risk-check`. This is the planned default.
- **Max:** Phases 1–4 (adds R7) — ~2.5–3 hours; expect to hit context-budget gate around Phase 4 entry.

## Autonomy Posture

**Gated.**

**Stop points:**
- After Phase 1 commit (R10): brief pause to confirm phase boundary; no operator approval required, just visible summary.
- Before Phase 2 step 4 (R9 flip): if pre-flip verify shows `cp` dereference risk, STOP and defer R9.
- Before Phase 3 step 5: `/risk-check` plan-time bundled gate. If verdict is NO-GO or BLOCKED, stop the session per mandate.
- After Phase 3 commit: context-budget check before deciding on R7.
- Before Phase 4 step 12 (R7 implementation): `/risk-check` plan-time gate on the new agent. If NO-GO, defer R7.
- Before R7 commit: `/risk-check` end-time gate per new-agent class rule.

## Risk

Run `/risk-check` at the following points (per `docs/audit-discipline.md` § Risk-check change classes):

- **Phase 3 plan-time** — bundled gate on R3 + R4 + R6 (canonical-command edits, multi-file batch).
- **Phase 4 plan-time** — R7 only (new agent class).
- **Phase 4 end-time** — R7 only (new agent class explicitly requires end-time gate; memory `feedback_end_time_risk_check_skip.md` skip rule does NOT apply because R7 is a single-item plan, not a bundled commit with mitigations).

R10 (env-var single-key add) and R9 (symlink flip, after verify clears) are below the structural-change threshold. R4 and R6 are additive edits to existing canonical commands — recommended but not blocking risk-check coverage by bundling into the Phase 3 gate.

**Tripwire applies to R3:** updating the evaluator subagent brief reorders the subagent's output target (main → disk) — this is automation-with-shared-state-effects on `audits/working/`, which qualifies for `/risk-check` even though `create-skill.md` already exists. The Phase 3 bundled gate covers it.
