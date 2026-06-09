# Risk Check — 2026-06-09

## Change

Proposed structural change: add a new PreToolUse(Bash) hook `check-foreign-staging.sh` (Fix 2 of the concurrent-session isolation fix-plan, audits/2026-06-09-concurrent-session-isolation-fix-plan.md, build-order step 1). It is the repo's FIRST blocking PreToolUse hook — all existing PreToolUse hooks (check-heavy-tool.sh, friction-log-auto.sh) exit 0 non-blocking.

WHAT IT DOES:
- Fires on Bash tool calls. Exits 0 immediately unless the command contains a gated git verb: `git commit`, `git commit --amend`, `git add -A|--all|.|-u`. Pathspec `git add <path>` is NOT gated.
- Resolves the current session footprint: session marker via per-id oracle (logs/.session-marker-${CLAUDE_CODE_SESSION_ID}) → shared logs/.session-marker fallback; reads the `- Files in scope:` bullet under this session's `## DATE — Session S{N}` header in logs/session-notes.md (same read concurrent-session-check.md Step 3 uses).
- Q3 fail-open: if footprint is absent / `(inferred)` / `(none stated)` / has no concrete paths → emit a soft NON-blocking warn (additionalContext) and exit 0.
- Exempt-list: append-only shared logs (session-notes.md, decisions.md, usage-log.md, improvement-log.md, coaching-data.md) + this session's own marker/plan/scratchpad files are NEVER counted as foreign (otherwise every wrap commit, which stages these, would block).
- Foreign detection: candidate staged set (`git diff --cached --name-only` for commit/amend; working-tree-wide changed+untracked set for add -A) MINUS footprint MINUS exempt-list = foreign files.
- Q2 BLOCK MECHANISM (the load-bearing decision): when concrete footprint exists AND foreign files remain → block via exit code 2 with the foreign-file list on stderr (model-facing), NOT a permissionDecision "ask"/"deny" permission prompt. Rationale: feeds the contamination back to the agent to re-stage and surface in chat, respecting the operator's documented zero-permission-prompt preference and the bypassPermissions defaultMode floor. python3 for JSON parse like check-heavy-tool.sh.

FILES TOUCHED:
- NEW: .claude/hooks/check-foreign-staging.sh
- EDIT: .claude/settings.json (add a `"matcher": "Bash"` PreToolUse object wiring the new hook; no "model" field touched)
- EDIT: docs/commit-discipline.md (document the guard's contract; distinguish it from the parked QC-PENDING commit-block hook at decisions.md:155)

CONTEXT FOR RISK SCORING:
- Sanction: decisions.md:155 (2026-06-08) parked a DIFFERENT PreToolUse hook — a commit-block for the QC-PENDING architectural gate — "graduates only on logged recurrence." This Fix 2 is a distinct hook (foreign-footprint contamination guard), and S3 (2026-06-09) logged an actual shared-index contamination recurrence (a `git commit --amend` swept a foreign staged file). So Fix 2 is sanctioned by the S3 fix-plan (QC GO).
- The single biggest blast-radius concern: this hook fires on EVERY Bash call in EVERY session in this repo. A bug that blocks legitimate commits (e.g., exempt-list miss, footprint mis-parse) would halt normal wrap commits. Evaluate the false-positive surface and the exit-2 blocking choice specifically.
- Operator preference (memory, load-bearing): zero permission prompts; bypassPermissions is the floor; never add to deny list. The exit-2-to-model mechanism was chosen specifically to avoid the permission-prompt machinery.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/commit-discipline.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-heavy-tool.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/concurrent-session-check.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/2026-06-09-concurrent-session-isolation-fix-plan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/decisions.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A sanctioned, well-scoped fix for a recurred real incident, but it is the repo's first *blocking* PreToolUse hook firing on every Bash call — the exit-2 false-positive surface against legitimate wrap commits is the elevated risk and must be paired with mitigations before landing.

## Consumer Inventory

The change introduces a new contract (the hook becomes a *new reader* of the `- Files in scope:` footprint bullet) and depends on two existing contracts: the session-marker oracle and the footprint parse contract. The new hook file itself has no consumers yet (`not yet present`). Inventory rows cover the contracts the hook joins/depends on, plus the two edited files.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `.claude/settings.json` | co-edits (wires the hook into PreToolUse) | yes |
| `docs/commit-discipline.md` | documents (the guard's contract + distinction from parked hook) | yes |
| `.claude/commands/session-start.md` (§ Parse contract, line 288 "Six readers") | parses (the hook becomes a 7th reader of `- Files in scope:`; the documented reader count is stale once it lands) | yes |
| `docs/session-marker.md` (§ Marker resolution; § Mandate-line bullet contract) | parses (hook reuses the per-id-oracle → shared fallback contract and the footprint bullet) | no (reuse, compatible) |
| `.claude/commands/concurrent-session-check.md` (Step 3) | parses (sibling reader of the same `- Files in scope:` bullet; the hook copies its read) | no (shares contract, unaffected) |
| `.claude/hooks/check-heavy-tool.sh` | parses (existing PreToolUse(Bash) hook; co-fires on every Bash call alongside the new hook — ordering/independence) | no |
| `.claude/commands/wrap-session.md` (canonical + workspace-root) | invokes (runs the `git commit`/`git add` the hook gates; stages the exempt-list shared logs) | no (if exempt-list is correct) |
| `.claude/commands/tweak.md`, `improve.md` (+ 9 other command files run `git commit`/`git add`) | invokes (any command that commits passes through the gate) | no (if exempt-list + gating is correct) |

Total: 8 distinct consumer rows, 3 must-change (settings.json, commit-discipline.md, session-start.md parse-contract count). Note: the `not yet present` hook file has no consumers yet; the inventory above covers the contracts it joins and the files it touches. The `must-change` on `session-start.md` is a documentation-accuracy change (update "Six readers" → seven), not a behavioral one — but leaving it stale is itself a finding (Blast Radius).

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- The hook fires on **every Bash tool call in every session** — same matcher class as the existing `check-heavy-tool.sh` (`matcher: "Read|Grep|Bash"`, settings.json:43). This is per-tool-call execution, the High-cost calibration point for hooks. — evidence: settings.json:42-51; CHANGE_DESCRIPTION "this hook fires on EVERY Bash call in EVERY session."
- Mitigating factor that holds it at Medium not High: it adds **no tokens to always-loaded files** (no CLAUDE.md edit, no `@import`), and it **exits 0 immediately** unless the command matches a gated git verb (`git commit`/`commit --amend`/`add -A`). The expensive path (footprint resolution, `git diff --cached`, set subtraction via python3) runs only on the small fraction of Bash calls that are gated git verbs. — evidence: CHANGE_DESCRIPTION "Exits 0 immediately unless the command contains a gated git verb."
- The early-exit pattern mirrors `check-heavy-tool.sh`, which already does python3-per-Bash-call and is tolerated. The new hook adds a second python3 spawn per Bash call (both hooks fire), but the timeout is bounded (existing hooks use `timeout: 5`). — evidence: check-heavy-tool.sh:22 (`python3 - "$payload"`); settings.json:48.
- Net: small constant per-Bash-call overhead (a second cheap hook invocation), no per-turn token cost. Medium because per-tool-call frequency is inherently the higher band, not because the marginal cost is large.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` entry is added, removed, or narrowed. The edit to settings.json is confined to the `hooks.PreToolUse` array — a new `{"matcher": "Bash", ...}` object — not the `permissions` block. — evidence: CHANGE_DESCRIPTION FILES TOUCHED ("add a `"matcher": "Bash"` PreToolUse object … no model field touched"); settings.json:2-34 (permissions block) vs 40-64 (hooks block).
- The exit-2 block mechanism is deliberately chosen to **avoid** the permission-decision machinery (no `permissionDecision: "ask"/"deny"`), which keeps it consistent with the operator's `defaultMode: "bypassPermissions"` floor (settings.json:34) and the memory rule "never add to deny list." The change does not touch `defaultMode`. — evidence: CHANGE_DESCRIPTION Q2 ("NOT a permissionDecision … respecting the operator's documented zero-permission-prompt preference"); settings.json:34.
- No new tool family, no cross-repo write, no external capability, no scope escalation. The hook reads git state and session-notes (already-readable paths) and writes nothing.

### Dimension 3: Blast Radius
**Risk:** High

- Grounded in the Step 1.5 inventory: 8 consumer rows, 3 must-change. The decisive signal is the **invokes** rows — every command that runs `git commit`/`git add` passes through this gate. Grep counted **11 command files** containing `git commit`/`git add` in `.claude/commands/`. — evidence: `grep -rlI "git commit\|git add" .claude/commands | wc -l` = 11.
- This is shared infrastructure touched in a way that affects every commit path in the repo. A false-positive (exempt-list miss, footprint mis-parse, marker-resolution failure not caught by the Q3 fail-open) blocks a legitimate `git commit` — most damagingly the **wrap-session commit**, which stages the exempt-list shared logs. The exempt-list is the single point of failure: if any append-only shared log staged at wrap is not on it, every wrap commit blocks. — evidence: CHANGE_DESCRIPTION "A bug that blocks legitimate commits … would halt normal wrap commits"; exempt-list enumerated in CHANGE_DESCRIPTION.
- Contract change, partly **not documented at landing**: the hook becomes a **7th reader** of the `- Files in scope:` bullet. `session-start.md` line 288 hard-states "**Six readers** … depend on the exact bullet labels … Do not rename these labels … without updating all readers" (line 296). The new hook silently joins that reader set; the documented count and reader list go stale unless `session-start.md` is updated in the same change. This is a blast-radius gap the CHANGE_DESCRIPTION's FILES TOUCHED list does **not** mention (it lists settings.json + commit-discipline.md, not session-start.md). — evidence: session-start.md:288-296; CHANGE_DESCRIPTION FILES TOUCHED.
- Co-firing with the existing `check-heavy-tool.sh` on the same Bash matcher: two PreToolUse(Bash) hooks now run per Bash call. Independence is fine (both can emit additionalContext; only the new one can exit 2), but it is shared-event coupling worth noting. — evidence: settings.json:42-51 (existing Read|Grep|Bash hook).

### Dimension 4: Reversibility
**Risk:** Low

- Revert is a clean three-file git operation: delete `check-foreign-staging.sh`, revert the settings.json hook object, revert the commit-discipline.md edit. No data/log mutation, no archive append, no external write, no push-beyond-git state. — evidence: CHANGE_DESCRIPTION FILES TOUCHED (one new file + two edits).
- The hook writes nothing — it reads git state and session-notes and either exits 0 or exits 2. No state propagates that a revert would leave stale. — evidence: CHANGE_DESCRIPTION (block mechanism is exit-2 + stderr; no Write).
- Minor caveat (does not raise the level): because the hook is wired in settings.json, it is **live the instant the edit lands** and fires on the very next Bash call — including the commit that lands the change itself. If the hook has a bug, the commit that introduces it could be the first thing it blocks. This is an ordering quirk, not a reversibility cost (the file edit can still be reverted by editing settings.json directly, which does not pass through the Bash gate). Covered by the dry-run mitigation below.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The hook **silently depends on two existing contracts** that are not owned at the change site: (1) the session-marker per-id oracle → shared-file fallback (`docs/session-marker.md § Marker resolution`), and (2) the `- Files in scope:` bullet parse contract (`session-start.md` § Parse contract). If either contract's format changes, the hook's footprint resolution silently degrades — and its degraded mode is the Q3 fail-open (warn + allow), so a contract drift would **silently disable the guard** rather than fail loud. — evidence: CHANGE_DESCRIPTION (marker oracle + "same read concurrent-session-check.md Step 3 uses"); session-start.md:288, 306; concurrent-session-check.md Step 3 lines 65-75.
- The Q3 fail-open is the right safety choice (a guard that blocks on its own parse failure would be worse), but it means the guard is **only as strong as the footprint declaration** — a session with `(inferred)`/`(none stated)`/no plan gets no protection. This is the same blind spot `concurrent-session-check.md` documents as its "#1 failure" (the UNKNOWN-SCOPE hard gate, lines 76-89). The hook inherits that blind spot; the contamination that recurred at S3 could recur in any session that never declared a concrete footprint. — evidence: concurrent-session-check.md:76-89; CHANGE_DESCRIPTION Q3.
- **Functional-overlap check (clears):** this hook does *not* overlap with the parked QC-PENDING commit-block hook (decisions.md:155) — that one blocks commits of un-QC'd architectural changes; this one blocks commits containing foreign-footprint files. Distinct triggers, distinct purposes. The CHANGE_DESCRIPTION correctly requires commit-discipline.md to document the distinction, which removes the would-be coupling. — evidence: decisions.md:155 ("A PreToolUse commit-block hook was parked … Graduates only on logged recurrence"); CHANGE_DESCRIPTION FILES TOUCHED.
- The new contract (the hook's read of `- Files in scope:`) **is** documented at a change site (commit-discipline.md is edited), which holds this at Medium not High — but the seventh-reader registration in session-start.md is the documentation gap (see Dimension 3).

### Dimension 6: Principle Alignment
**Risk:** Low

- Principles-base read OK at `projects/strategic-os/ai-strategy/principles-base.md`. Checks applied: OP-5, OP-9/AP-7/DR-7, OP-12, OP-2, DR-10, DR-1/DR-3.
- **OP-9 / AP-7 / DR-7 (speculative abstraction) — clears.** This is the opposite of "hooks for later." It addresses a **logged, recurred** real incident: decisions.md:178 (S3, 2026-06-09) records "a concurrent S4 session in the same checkout swept staged files across commits," and the fix-plan documents the `git commit --amend` foreign-file sweep (fix-plan §1 Failure A, lines 14). The parked-hook sanction (decisions.md:155) said the QC-PENDING hook "graduates only on logged recurrence" — and a *distinct* contamination recurrence is now logged, sanctioning this distinct hook. The contract serves a present consumer, not an absent Phase-2 one. — evidence: decisions.md:178, 155; fix-plan:14, 43-47.
- **OP-5 (advisory vs enforcement) — touched, deliberately and consistent with the fix-plan, so not a violation.** The hook moves from advise-and-stop to **enforce** (block via exit 2). OP-5 says enforcement authority is an explicit per-component decision. Here it *is* explicit and recorded: fix-plan §2 (line 33) states the design intent — "make isolation the **default path** and to **block** (not just warn) the two genuinely-dangerous moves" — and §3 Fix 2 (lines 43-47) is the named enforcement decision, QC-GO'd. The enforcement is narrowly scoped to a move with "no legitimate use" (foreign-file contamination), mirroring the Fix-1 rationale (fix-plan:39). This is a loud, recorded enforcement upgrade (OP-11-compatible), not silent drift — so it scores Low with a note, per the Dimension-6 special-handling rule. — evidence: fix-plan:33, 43-47; principles-base OP-5, OP-11.
- **OP-12 (closure before detection) — clears / actively served.** This is not new detection that floats free of closure; the block *is* the closure channel — it feeds the foreign-file list back to the agent to re-stage. Detection and closure ship together. — evidence: CHANGE_DESCRIPTION Q2 ("feeds the contamination back to the agent to re-stage and surface in chat"); principles-base OP-12.
- **OP-2 (automate execution, gate judgment) — aligns.** The gated act (don't ship another session's file) is mechanical, not a judgment call; automating it fits "automate execution." It does not re-gate routine execution (AP-4) — clean commits pass through with a single immediate exit 0. — evidence: principles-base OP-2, AP-4.
- **DR-10 / DR-1 / DR-3 — clears.** The hook lives in the canonical `.claude/hooks/` home (DR-3), is wired in the canonical settings.json, and directly automates the DR-10 concurrent-session staging discipline. Correct tier, correct home. — evidence: principles-base DR-10, DR-3; settings.json hooks block.

## Mitigations

- **Dimension 3 (Blast Radius — High):** Before landing, dry-run the hook against three synthetic PreToolUse(Bash) payloads — (a) foreign file staged + concrete footprint present → must exit 2; (b) in-footprint file staged → must exit 0; (c) no/`(inferred)` footprint → must exit 0 with warn — exactly as session-plan-2026-06-09-S5.md step 4 already prescribes. Additionally, run one **wrap-commit simulation**: stage the full exempt-list (`session-notes.md`, `decisions.md`, `usage-log.md`, `improvement-log.md`, `coaching-data.md` + this session's marker/plan/scratchpad) plus one in-footprint file and confirm exit 0 — this is the specific false-positive that would halt every wrap. Do not wire the hook into settings.json until all four pass `bash -n` clean.
- **Dimension 3 (Blast Radius — High):** Update `session-start.md` § Parse contract (line 288) in the **same change**: bump "Six readers" → seven and add the hook as reader #7 of `- Files in scope:`. Add `session-start.md` to the FILES TOUCHED list (the CHANGE_DESCRIPTION omits it). Leaving the documented reader count stale violates the file's own instruction (line 296: "without updating all readers").
- **Dimension 5 (Hidden Coupling — Medium):** In commit-discipline.md, document that the guard's footprint resolution depends on the marker-oracle and the `- Files in scope:` bullet, and that on parse failure it **fails open** (warns, does not block) — so a future change to either contract silently weakens, not breaks, the guard. State the known blind spot explicitly: sessions with no concrete footprint (`(inferred)`/`(none stated)`/primed-but-not-planned) get no protection, mirroring concurrent-session-check.md's documented #1 failure.
- **Dimension 1 (Usage Cost — Medium):** Keep the gated-verb early-exit as the literal first check after JSON parse (before any footprint resolution or `git diff`), so the per-Bash-call cost on the common non-git path is a single regex test + exit 0 — matching check-heavy-tool.sh's bounded cost. Verify the `timeout: 5` is set on the new hook object in settings.json.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files). The `not yet present` hook file was evaluated from described intent in CHANGE_DESCRIPTION and the session-plan, noted where it bears on a dimension. Principles-base was readable and cited by ID. No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (`/consult` equivalent — `system-owner` agent, Function B pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION. Full advisory on disk: `projects/axcion-ai-system-owner/output/consultations/consult-2026-06-09-risk-check-second-opinion-check-foreign-staging-hook.md`._

**(a) Concurs with PROCEED-WITH-CAUTION.** Two gated classes at once — hook edit AND shared-state automation (`risk-topology.md § 3`; `principles.md § DR-8`); Critical blast radius (always-firing gate in `bypassPermissions`-mode `settings.json`, ships to all 7 projects). Mitigations #1/#3/#4 correct; **#2 mis-scoped (reject)**. Verify independent QC is reachable before commit — gated class, no self-QC (`CLAUDE.md § QC Independence`).

**(b) exit-2-to-model is the right mechanism — the dimension review missed its defining failure mode.** It is the only choice consistent with the zero-permission-prompt floor; precedent is in-repo (`check-heavy-tool.sh` feeds the same Bash matcher via `additionalContext`). But exit-2 feeds the **agent**, not the operator — so the agent can re-run the commit or route to a non-gated verb form. This is `OP-5`: a PreToolUse block is **advisory automation, not enforcement** — calling it a "contamination guard" overstates its authority. Two fixes:
- Reframe in docs as an honest-mistake **staging tripwire**, paired with the existing `git diff --cached` shared-file rule (which catches foreign *hunks* in owned files like `CLAUDE.md` — the hook cannot).
- Set the stderr message to instruct **stop-and-surface-to-operator** (an `OP-3` loud-failure path), converting it from a silently-defeated block into one the agent must escalate.

**(c) Mitigation #2 is mis-scoped — reject the `session-start.md` seven-readers edit.** The `session-start.md §§ 288–298` parse contract lists only readers that break on a *label rename*; it already separates `- Context pack:` as "informational, not part of the parse contract." The hook is that shape — it fails **open** on a renamed label (absent footprint → exit 0), so a rename cannot make it mis-block. Readers 1–6 mis-parse a *present* mandate on rename; the hook cannot. Promoting it to "seven" creates a false maintenance trap.
- Doc edit belongs in **`commit-discipline.md`** (already in FILES TOUCHED — mitigation #3 absorbs #2's intent): hook reads `- Files in scope:`, fail-open dependency, no-footprint blind spot.
- At most a **one-line informational-consumer note** to `session-start.md § 298` (the `- Context pack:` paragraph), NOT the numbered list.
- **`session-marker.md`** needs no edit — the hook only consumes the existing per-id oracle, it adds no new marker semantics.

**Risk the dimension review missed — two-hooks-live cost/ordering.** The new `matcher:"Bash"` object sits beside the existing `Read|Grep|Bash` hook; both fire on *every* Bash call with **no ordering guarantee** between the two objects. Confirm the gated-verb early-exit (mitigation #4) runs before any file read, else every non-git `ls`/`cat` pays two Python-spawning hooks (the lever behind the Medium usage flag). Add a **two-hooks-live non-git-Bash cost check** to the dry-run, beyond the four git-payload simulations.
