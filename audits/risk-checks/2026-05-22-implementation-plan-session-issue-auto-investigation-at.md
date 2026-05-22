# Risk Check — 2026-05-22

## Change

Implementation plan "Session-Issue Auto-Investigation" at /Users/patrik.lindeberg/.claude/plans/let-s-develop-a-diagnostics-floating-diffie.md — six file changes: (1) extend the /resolve-repo-problem command with an inline AUTO mode; (2) CREATE a new blocking Stop-hook check-issue-investigated.sh; (3) register that hook in ai-resources/.claude/settings.json; (4) add a new [ISSUE] trigger flag + rule to the workspace CLAUDE.md; (5) add an [ISSUE] section to docs/session-guardrails.md; (6) two edits to friday-checkup.md Step 6. This is the plan-time gate. Note especially: the new hook is the FIRST blocking Stop hook in the repo (decision: block), and CLAUDE.md is always-loaded context.

## Referenced files

- /Users/patrik.lindeberg/.claude/plans/let-s-develop-a-diagnostics-floating-diffie.md — exists (the plan — primary artifact)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-repo-problem.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-issue-investigated.sh — not yet present (to be created)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-heavy-tool.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists (workspace, always-loaded)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-guardrails.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-checkup.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A well-specified, QC-hardened plan whose two High dimensions — per-turn always-loaded token cost and a first-of-its-kind blocking Stop hook — both have viable paired mitigations the plan already half-articulates, so the change is sound to execute provided those mitigations are bound into the execution session.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** High

- File 4 adds a new `### Active trigger flag` subsection to the workspace `CLAUDE.md` `## Session Guardrails` section (`CLAUDE.md:101`), which is always-loaded context on every turn of every session in the workspace and every project. The block quoted in the plan (lines 246–256) is roughly 150–190 words — a verbatim `[ISSUE]` definition, the `[AMBIGUOUS]`-vs-`[ISSUE]` boundary paragraph, and a chat-format line. At ~1.3 tokens/word this is ~200–250 tokens added to always-loaded context. This exceeds the >150-token always-loaded threshold for High.
- The plan does not state a token budget for the File 4 insertion, nor does it commit to keeping the verbatim block minimal with the detail pushed to `session-guardrails.md` (the workspace `CLAUDE.md` CLAUDE.md-Scoping rule says "Short pointer is acceptable; verbatim duplication is not" — and the existing four-flag list in `CLAUDE.md` is already one-line-per-flag with detail deferred to `session-guardrails.md`). File 4 as quoted partially duplicates the File 5 `session-guardrails.md` `[ISSUE]` section.
- File 2 registers a `Stop` hook that runs at the end of every turn (not per-tool-call). A `Stop` hook fires far more often than a `SessionStart` hook — on every turn boundary. The hook walks the entire transcript `.jsonl` each time; cost is harness-side wall-time (10s timeout budget) rather than model tokens, but it is recurring per-turn overhead.
- Files 1 (`resolve-repo-problem.md`), 5 (`session-guardrails.md`), 6 (`friday-checkup.md`) are pay-as-used — loaded only when their command runs. No ongoing cost from those three.
- Mitigating factor pulling against High: the File 4 block is content the operator explicitly wants always-resident (a trigger rule must be loaded every turn to fire), so some always-loaded cost is irreducible by design. The High rating is about the *size* of the verbatim block, not its presence.

### Dimension 2: Permissions Surface
**Risk:** Low

- File 3 adds a `Stop` hook group to `ai-resources/.claude/settings.json` `hooks.Stop` (settings.json:83–120). It adds no entry to `permissions.allow`, `permissions.ask`, or `permissions.deny`, and removes no `deny` rule.
- The hook command is `bash $CLAUDE_PROJECT_DIR/.claude/hooks/check-issue-investigated.sh` — the identical invocation shape already used by three existing `Stop` hooks and the `PreToolUse`/`PostToolUse` hooks (settings.json:46, 57, 70, 76, 88, 97, 104, 113, 126). `Bash(*)` is already in `allow` (settings.json:5). No new capability, no scope escalation, no cross-repo or external surface.
- The hook itself reads a transcript file and the scope's logs and writes to `improvement-log.md` — all within already-authorized `Read`/`Write` (settings.json:6, 8). The AUTO routine writes to `{scope}/logs/improvement-log.md`; `Write(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)` already authorizes that path (settings.json:21).

### Dimension 3: Blast Radius
**Risk:** Medium

- Files touched directly: 6 (one created, five modified) — per the plan's "Files to change (6)" table (plan lines 39–46).
- `resolve-repo-problem.md` callers: grep across `ai-resources` finds the command name in 7 files (`audits/friday-journal-2026-05-22.md`, `audits/risk-checks/2026-05-22-three-structural-additions...`, `audits/friday-plans/2026-05-22-journal-commands.md`, the command file itself, `logs/usage-log.md`, `logs/ai-journal.md`, `logs/session-notes.md`). None is a programmatic caller — all are audit/log/plan records. The command is operator- and rule-invoked, not invoked by another command. The plan preserves the existing MANUAL contract verbatim (Steps 2–4 unchanged, plan lines 71–75) and adds AUTO as a new branch — backwards-compatible. The one behavior change is removing the "abort if `$ARGUMENTS` empty" rule (plan line 68); any operator who today types `/resolve-repo-problem` with no argument gets AUTO mode instead of an abort message — a behavior change, but a strict capability gain, not a break.
- `friday-checkup.md` is shared maintenance infrastructure. Edit 6b is a *logic change to an existing rule* — the Stale-improvement bullet at `friday-checkup.md:298`, which has a precise data contract ("for each entry whose `Status:` line matches `logged (pending)`"). The plan narrows that contract to exclude `Category: session-issue`. `/friday-act` parses `friday-checkup.md` section headings verbatim (`friday-checkup.md:377`) but Step 6 produces *bullet text*, not headings — Edit 6a adds a new `[SESSION-ISSUE]` follow-up token alongside the existing `[STALE]`. `/friday-act` consumes the Tactical follow-ups section as a flat checklist; a new bullet token is additive and compatible.
- `improvement-log.md` is shared state read by `/friday-checkup` Step 6, `/improve`, `/resolve-improvement-log`, and the W2.4 `improvement-analyst` agent. The plan adds a new `Category: session-issue` value and uses `Source:`/`Friction source:` fields. The improvement-log `## Schema` block (improvement-log.md:5–17) defines `Category` as "broad classification" free-text — the new value is schema-valid. `Source:`/`Friction source:` are not enumerated in the schema block, but existing entries already use `Friction source:` freely (confirmed at improvement-log.md ~line 35). No schema-block edit needed; the new entries conform.
- `session-guardrails.md` callers: referenced in `docs/onboarding-daniel.md`, `docs/onboarding-daniel-cheatsheet.md`, `docs/repo-architecture.md` and prior audits — all documentation, no programmatic dependency. Reframing "four flags" → "five flags" is a doc-content change with no contract consumer.
- Net: 6 files, one backwards-compatible contract change (Edit 6b narrows an existing rule), one new additive token (`[SESSION-ISSUE]`), no caller requires modification to keep working. This is squarely Medium — a contract change that is backwards-compatible plus shared-infra touches, none breaking.

### Dimension 4: Reversibility
**Risk:** Medium

- Files 1, 3, 4, 5, 6 are in-place edits to tracked files — `git revert` restores them cleanly. File 2 creates a new file; `git revert` of the commit that adds it also removes it (a tracked new file, not a sibling left behind). The settings.json hook registration and the hook file would be reverted together if committed together — the plan should ensure File 2 and File 3 land in the same commit so a revert does not leave a registered-but-deleted hook or an orphan hook.
- The non-clean part: the AUTO routine and the MANUAL Step 5 both append entries to `{scope}/logs/improvement-log.md`. `improvement-log.md` is an append-only log. Any `logged (pending)` entry written by the feature *before* a revert stays in the log after the revert — `git revert` of the feature commit does not touch log entries written in later sessions. Those stale entries would still be picked up by `/friday-checkup` Step 6 (which the revert also removed the detection bullet from — so post-revert they would fall through to the 21-day `[STALE]` path instead, since Edit 6b's category exclusion is also reverted). This is the classic append-only-log-mutation reversibility cost: not fatal, but a revert leaves data residue requiring manual log cleanup.
- The plan also notes the routine *creates* `logs/improvement-log.md` in a scope that lacks one (plan lines 95–97). If the feature runs in a project with no improvement-log and is later reverted, that newly created log file persists — a sibling artifact a revert of the ai-resources commit cannot remove (it lives in a different scope/repo).
- No state propagates beyond git automatically — the feature commits nothing and pushes nothing (plan line 124: "applies no fix, commits nothing"). No external write.
- One operator-memory cost: once the `[ISSUE]` flag is live in `CLAUDE.md`, the operator and Claude both learn the flag exists; a revert removes the rule but the muscle-memory lingers briefly. Minor.
- Net: revert works but requires one-to-two manual cleanup steps (purge stale `session-issue` log entries; remove any auto-created project-scope `improvement-log.md`). That is Medium, not Low.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The plan introduces a **new parse-marker contract**: `[ISSUE-INVESTIGATED] Logged to {path} — "{title}"` is emitted by `/resolve-repo-problem` AUTO mode (File 1, plan lines 90–91) and scanned by `check-issue-investigated.sh` (File 2, plan lines 189–190). Two components must agree on the exact token. The plan documents this contract at *both* change sites (the command doc's AUTO branch and the hook pseudocode), and the hook scans `type == "assistant"` entries only — so the contract is documented where the callers live. That is the Medium pattern (a new contract, documented at the change site), not High.
- The hook **auto-fires on every `Stop` event** and, when it blocks, injects `additionalContext` instructing Claude to run `/resolve-repo-problem` AUTO mode. This is a silent cross-turn side effect: a turn that raised `[ISSUE]` and ended without investigating gets force-extended by the hook. The plan's three false-positive mitigations (negative-lookahead regex `\[ISSUE\](?!-INVESTIGATED)`; `type == "assistant"` filter to exclude the always-loaded `CLAUDE.md`/`session-guardrails.md` `[ISSUE]` token and hook-injected text; bracket-free `additionalContext` wording) are exactly the controls needed and are well-reasoned. The residual coupling: the `[ISSUE]` token now lives in always-loaded `CLAUDE.md` and `session-guardrails.md` context — if a future edit causes that literal token to surface inside an `assistant` message (e.g., Claude quoting the guardrail rule back in chat), the hook could false-positive. The `type == "assistant"` filter does not exclude Claude *quoting* the rule; it only excludes the file content and operator messages. This is a real, if narrow, hidden-coupling tail the plan acknowledges only partially.
- **Functional-overlap check:** there are already three `Stop` hook groups (`check-stop-reminders.sh`, `coach-reminder.sh`+`improve-reminder.sh`, `auto-resolve-nudge.sh` — settings.json:83–119), all non-blocking nudges. The new hook is a fourth group placed last. It does not overlap their concern (session-end reminders vs. un-investigated-issue backstop). The plan explicitly places it last so a slow transcript walk does not delay the nudges (plan line 224). No two-hooks-one-event collision.
- **Loop-coupling:** the hook relies on Claude Code's built-in 2–3-consecutive-block force-through as the failsafe (plan lines 144–148, 159–167) — an implicit dependency on undocumented-here harness behavior. The plan verified the `Stop`-hook contract against `code.claude.com/docs/en/hooks.md` on 2026-05-22 and explicitly states there is no `stop_hook_active` field. The primary loop guard is the marker-scan (block only when an `[ISSUE]` has no following `[ISSUE-INVESTIGATED]`) — this is the designed control and is sound: once the marker is emitted, the next `Stop` exits 0. The harness force-through is a failsafe, not the primary mechanism. This is an acceptable single implicit dependency on an established platform behavior — Medium-grade, not High.
- The transcript-path derivation for rule-invoked AUTO mode (cwd → `~/.claude/projects/{cwd with / and space → -}/`, plan lines 79–81) silently relies on Claude Code's directory-encoding convention and on most-recently-modified `.jsonl` selection. The workspace path contains a space (`Axcion AI Repo`). The plan flags this (Risk 3, plan lines 332–333; Verification C) and provides a recoverable fallback (in-context conversation). Documented, mitigated.

## Mitigations

- **Dimension 1 (Usage Cost, High):** Bind a token budget into the execution session for the File 4 `CLAUDE.md` insertion. The verbatim always-loaded block must be the *minimal* trigger rule — flag name, one-line "what emitting it does", the chat format line, and a one-clause `[AMBIGUOUS]`-vs-`[ISSUE]` distinction — with the full trigger taxonomy, the backstop description, and the boundary examples pushed to `session-guardrails.md` (File 5) and reached by the existing `Full semantics:` pointer. Target: keep the File 4 net addition at or under ~120 tokens (in line with the existing one-line-per-flag treatment of the four advisory flags and the workspace `CLAUDE.md` "Short pointer is acceptable; verbatim duplication is not" rule). The plan's quoted File 4 block (plan lines 246–256) is currently larger than this — trim it during execution and confirm the trimmed token count in the end-time gate.
- **Dimension 2 (mitigation not required — Low):** none.

> Note on the first-blocking-hook concern (cross-cuts Dimensions 1 and 5): the plan's loop-safety design — marker-scan primary guard plus the harness 2–3-block force-through failsafe — is sound and verified against the live `Stop`-hook contract. No additional mitigation is required to reduce it below Medium, but the execution session must (a) land File 2 and File 3 in the *same commit* so a revert never leaves a registered-but-missing or orphaned hook, and (b) run Verification tests D, E, and F (backstop fires once; backstop quiet when already done; loop cannot wedge) before the end-time gate — these tests are the empirical proof that the marker-scan guard cannot wedge a session.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: the implementation plan read in full (line references throughout); `settings.json` hook structure (lines 83–120); `resolve-repo-problem.md` current contract (lines 12–19, 35–64); `check-heavy-tool.sh` transcript idiom (lines 44–75); `session-guardrails.md` current four-flag structure; `friday-checkup.md` Step 6 line 298 STALE-rule data contract and line 377 heading-parse note; `improvement-log.md` `## Schema` block (lines 5–17); `audit-discipline.md` risk-check change classes (lines 16–24); grep counts for callers of `resolve-repo-problem`, `improvement-log`, `friday-checkup`, and `session-guardrails` across `ai-resources`. The file tagged `not yet present` (`check-issue-investigated.sh`) was evaluated from the plan's detailed pseudocode (plan lines 128–219), noted as such under Dimensions 1, 4, and 5. No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

# Pre-Change Advisory — Session-Issue Auto-Investigation (risk-check second opinion)

## Routing position

Per the routing baseline, the plan's homes are all correct. The hook lands in `ai-resources/.claude/hooks/` and is registered explicitly in `ai-resources/.claude/settings.json` — that is the canonical hook home (`principles.md § DR-3`) and the routing context confirms hooks are not auto-distributed, so the ai-resources-only backstop scope is a real and accepted limitation, not a misroute. The `[ISSUE]` rule belongs in workspace `CLAUDE.md` because it is a cross-project always-loaded rule (`principles.md § DR-5`; routing Q4). The command is extended rather than newly created — correct under `principles.md § DR-7` (no new component when an existing one fits). No routing objection. The three `/risk-check` change classes (new hook, settings.json edit, cross-cutting CLAUDE.md edit) are correctly identified (`risk-topology.md § 3`).

## We concur with PROCEED-WITH-CAUTION

The verdict is sound and we concur. The two High-pressure points — always-loaded token cost and the first blocking Stop hook — are real, and both have the mitigations the report names. Three architectural points reinforce this:

1. **The File 4 trim is not optional polish — it is a hard-rule compliance fix.** The CLAUDE.md scoping rule states "Short pointer is acceptable; verbatim duplication is not" (`principles.md § DR-5`; `CLAUDE.md` CLAUDE.md Scoping). The plan's quoted File 4 block (plan lines 246–256) duplicates the File 5 `session-guardrails.md` `[ISSUE]` section in always-loaded context. That is a DR-5 violation as drafted, not merely a cost concern. The ~120-token target is the correct ceiling — it matches the one-line-per-flag treatment the four advisory flags already get (`principles.md § OP-7`). Trimming brings the change into compliance; shipping the block as quoted does not.

2. **Same-commit landing of File 2 + File 3 is required by the reversibility profile.** A registered-but-missing hook or an orphan hook is a broken `settings.json` state, and `settings.json` is a Critical load-bearing component (`risk-topology.md § 1` — workspace settings, same class for the ai-resources layer). The atomic-commit instruction is the right control and must be bound into the execution session, not left to discretion.

3. **Verification tests D/E/F are the empirical proof, not a formality.** The marker-scan loop guard is the *only* designed protection — `stop_hook_active` does not exist, and the harness 2–3-block force-through is a failsafe, not a guard. `friday-checkup.md` is Critical load-bearing infrastructure (`risk-topology.md § 1`), and a wedged Stop hook degrades every ai-resources session. D/E/F are what convert "the guard looks sound" into "the guard is proven." They are non-negotiable before the end-time gate.

The recommended path — trim File 4 to ~120 tokens, land hook + registration in one commit, run D/E/F — is the right one. We endorse it without modification.

## Two risks the dimension review under-weighted

The five-dimension review is thorough and well-grounded. Two items deserve more weight than the report gave them:

**Risk 1 — Advisory/enforcement authority boundary (under-named).** This change introduces the first piece of *enforcement automation* into a system whose automation is otherwise entirely *advisory* (`principles.md § OP-5`). The `[ISSUE]` rule plus the blocking hook do not surface a finding and stop — they force an action (`/resolve-repo-problem` AUTO mode runs, an `improvement-log.md` entry is written) inside the same turn, with `Do not wait for an operator response` stated explicitly in File 4. OP-5 requires that the authority boundary for each automated component be *explicit*, not assumed. The dimension review treated this as a blast-radius and coupling question; it is also an authority-class question. This does not change the verdict — the action it forces is bounded (write a `logged (pending)` entry; commit nothing; the actual fix stays gated to `/friday-act`), so it stays inside advisory bounds in effect. But the execution session should state plainly, in the File 5 `[ISSUE]` section, that this is the system's first enforcement-class flag and that its authority is bounded to *logging* — never to *fixing*. Naming the boundary is the OP-5 obligation; the plan currently leaves it implicit.

**Risk 2 — AUTO-mode diagnosis quality has no QC gate (under-weighted).** The plan's "Known limitations" notes AUTO-mode produces one fix from possibly-compacted context versus the subagent's fresh-context ranked plan, and frames this as an accepted speed/cost trade. But the AUTO routine *writes a `Proposal` into `improvement-log.md`* — a system-change proposal produced by automation, with no independent QC before it lands in the queue `/friday-checkup` reads. `principles.md § QS-9` is direct on this: automation-produced system changes pass the same quality gates as operator-produced ones, and automation does not self-certify. The diagnosis runs inline in the main session — the same context that observed the fault — which also brushes against `QS-1` (no self-evaluation; QC needs fresh context). The mitigating fact is that the entry is `Status: logged (pending)` and the operator reviews it at `/friday-act` before any fix is applied — so the human gate is downstream and QS-9 is met *at fix-time*, not at log-time. That is acceptable for a first rollout, but it should be a *named* accepted limitation citing QS-9, not left implicit. If `[ISSUE]` over-fires (Risk 6 in the plan — flag fatigue), the Friday queue fills with un-QC'd AUTO diagnoses, and the operator absorbs the QC burden that QS-9 says automation should not offload silently. Recommend the File 5 section state explicitly that the AUTO `Proposal` is un-QC'd by design and that the operator's `/friday-act` review *is* the QS-9 gate.

Neither risk overturns PROCEED-WITH-CAUTION. Both are "name it in File 5 during execution" items, not redesign triggers.

## Clear position

The right answer is to execute the plan on the recommended path — trim File 4 to ~120 tokens (a DR-5 compliance fix, not a preference), land File 2 + File 3 in one commit, run verification D/E/F before the end-time gate — and additionally add two sentences to the File 5 `session-guardrails.md` `[ISSUE]` section: one naming this as the system's first enforcement-class flag with authority bounded to logging (OP-5), one stating the AUTO `Proposal` is un-QC'd by design with `/friday-act` review as the QS-9 gate. With those two additions, the change is sound to land.

**Grounding:** `principles.md § OP-5, OP-7, DR-3, DR-5, DR-7, QS-1, QS-9`; `risk-topology.md § 1, § 3`.
