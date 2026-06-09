# Session Plan — 2026-06-09

## Intent
Implement Fix 2 of the concurrent-session isolation fix-plan — a `PreToolUse(Bash)` guard (`check-foreign-staging.sh`) that, before `git commit` / `git commit --amend` / `git add -A`, inspects the staging index for files outside the session's declared footprint and pauses showing the foreign files rather than committing blind.

## Model
opus — match (active: `claude-opus-4-8[1m]`). Design decisions (block-vs-warn semantics, footprint resolution, fallback) are judgment-under-ambiguity → opus is correct.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/2026-06-09-concurrent-session-isolation-fix-plan.md` — source plan (Fix 2, §3 + build-order §4)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-heavy-tool.sh` — reference PreToolUse hook (payload parse, exemption check, exit-0 convention)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/detect-concurrent-session.sh` — sibling concurrency hook (Fix 1 target; footprint-marker patterns)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/concurrent-session-check.md` — already reads `- Files in scope:` from session-notes mandate blocks (footprint-source precedent)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json` — PreToolUse hook wiring target
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/commit-discipline.md` — home for the guard's documented contract
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md` — marker/mandate contract (footprint source = `- Files in scope:` bullet)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — structural change classes (risk-check trigger)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/output/context-packs/hook-20260609-7c2a1/pack.md` — context pack (untracked)

## Findings / Items to Address
1. **Fix 2 spec** (fix-plan §3, Fix 2) — `PreToolUse(Bash)` guard on `git commit` / `git commit --amend` / `git add -A`; if staged/added files fall outside the session footprint, pause and show them. Highest-value fix: the only one of the four with *zero* existing guard. The damage it prevents is real and logged (S3 `--amend` swept a foreign staged file).
2. **Q1 — sanction confirmed, scopes must stay distinct** (`decisions.md:155`, 2026-06-08). The parked PreToolUse hook was a *commit-block for the QC-PENDING architectural gate* ("graduates only on logged recurrence"). Fix 2 is a *different* hook (foreign-footprint contamination guard), sanctioned by the S3 fix-plan with QC GO, and the S3 contamination is the logged recurrence. **Action:** build Fix 2 as the foreign-footprint guard only; do NOT fold in the QC-PENDING commit-block scope (that remains parked). Note the distinction in `commit-discipline.md`.
3. **Q2 — block-vs-warn decision** (`check-heavy-tool.sh:13` "Always exits 0 — never blocks"). Every existing PreToolUse hook is a non-blocking nudge. Fix-plan §2 + §3 want Fix 2 to **pause/block** the dangerous verb. **Decision:** Fix 2 returns a PreToolUse *blocking* decision (`permissionDecision: "ask"` via `hookSpecificOutput`, or exit 2) when foreign files are detected — the repo's first blocking PreToolUse hook. This deliberate departure is the core reason `/risk-check` is mandatory.
4. **Q3 — no-footprint fallback** (pack missing-context #3). For a session with no `- Files in scope:` bullet, or a footprint marked `(inferred)`: **fail-open with a soft warn** (allow the commit, emit a one-line note). Rationale: blocking a solo/unplanned session with no mandate is the opposite foot-gun; the guard's value is only when a concrete footprint exists and a staged file falls outside it. An `(inferred)` footprint is too weak to block on.
5. **Footprint source** — read the *current* session's `- Files in scope:` bullet from its marker-bearing block in `logs/session-notes.md` (same source `concurrent-session-check.md` already uses). Resolving "current session" needs the session marker; if the marker or bullet is unresolvable → fail-open (Q3 path).
6. **Verb/path parsing** — the hook must parse the `git` subcommand and the candidate file set: `commit` (staged index via `git diff --cached --name-only`), `commit --amend` (same), `add -A` / `add .` / `add -u` (working-tree-wide → resolve what *would* be staged). Pathspec-scoped `git add <path>` is lower-risk; gate the wide forms first.

## Execution Sequence
1. **Re-read the three reference files in full** (`check-heavy-tool.sh`, `detect-concurrent-session.sh`, `concurrent-session-check.md` footprint-read block) to match payload-parse and footprint-read idioms exactly. *Verify:* can state the exact JSON payload shape and the footprint-read grep used by `concurrent-session-check.md`.
2. **Design the guard contract on paper** (in-plan/chat): verb detection table, footprint resolution + fallback, block decision shape, output message. *Verify:* contract covers all of `commit` / `--amend` / `add -A|.|−u` and the no-footprint fallback.
3. **`/risk-check` (plan-time gate)** on the designed contract — PreToolUse hook + commit-path change + first blocking hook. *Verify:* verdict captured. **GO → step 4; RECONSIDER/NO-GO → STOP per mandate.**
4. **Write `.claude/hooks/check-foreign-staging.sh`** following the design. *Verify:* `bash -n` clean; dry-run against a synthetic payload with (a) foreign file staged + footprint present → blocks, (b) in-footprint file → allows, (c) no footprint → allows-with-warn.
5. **Wire into `.claude/settings.json`** PreToolUse(Bash) matcher. *Verify:* JSON valid (`python3 -m json.tool`); no `"model"` field touched; matcher targets Bash only.
6. **Document the contract in `docs/commit-discipline.md`** (and a one-line back-link from the fix-plan §3 Fix 2 status). *Verify:* doc names the guard, its three gated verbs, the block-vs-warn departure, and the fail-open fallback; explicitly distinguishes it from the parked QC-PENDING commit-block hook.
7. **`/qc-pass`** on the hook + wiring + doc. *Verify:* GO (or resolve findings).
8. **`/risk-check` (end-time gate)** + commit. *Verify:* both gates GO, then commit directly per workspace commit rule.

## Scope Alternatives
- **Min:** gate only `git commit --amend` and `git add -A` (the two verbs that did real damage in S3); fail-open everywhere else. Smallest blast radius; closes the proven hole.
- **Recommended:** gate `commit` / `commit --amend` / `add -A|.|-u`; block when a concrete footprint exists and a foreign file is staged; fail-open-with-warn on absent/`(inferred)` footprint; document in `commit-discipline.md`. *(this plan)*
- **Max:** + also read the session-plan's owned-files as a secondary footprint source when the mandate bullet is `(inferred)`; + a unified commit-guard that also enforces the parked QC-PENDING block. **Rejected for this session** — the QC-PENDING merge re-opens deliberately-parked scope (Finding 2) and exceeds the mandate.

## Autonomy Posture
Gated — structural change class (PreToolUse hook + `settings.json` wiring + commit-path behavior; first *blocking* hook in the repo).

**Stop points:**
- Plan-time `/risk-check` verdict (step 3): RECONSIDER or NO-GO halts the session per the mandate's Stop-if.
- Sanction check (Finding 2): if deeper reading shows Fix 2 *is* the parked speculative hook rather than a distinct sanctioned graduation, halt and surface.
- End-time `/risk-check` + `/qc-pass` before commit.

## Risk
Run `/risk-check` after this plan is approved (plan-time gate) and again before commit (end-time gate). Structural classes touched: hook edit, `settings.json` change, and automation-with-shared-state-effects (the guard reorders/blocks a git commit against shared repo state). The block-vs-warn departure (first blocking PreToolUse hook) is the highest-attention item for the risk-check.
