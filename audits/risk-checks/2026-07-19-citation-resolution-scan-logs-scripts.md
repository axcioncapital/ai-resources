# Risk Check — 2026-07-19

## Change

PROPOSED CHANGE: Add a new command-invoked scan at `logs/scripts/check-citation-resolution.sh` in ai-resources. It walks every `path:NNN` citation in `logs/improvement-log.md` (75 present today) and reports any that does not resolve — cited file missing, or file shorter than the cited line number. Output names each unresolved citation with its source line. Reporting scan only: no writes, no gate, NOT registered as a hook, invoked manually or by a future /friday-act step. This proposal does NOT wire it into any command.

WHY THIS SHAPE, AND WHAT WAS REJECTED. The session mandate originally specified a PRESENCE-check (flag prescriptive `Proposal:` / `Target files:` lines carrying no file:line evidence). I tested that design against all five recorded instances of the defect it targets: it would have caught ZERO of five, because every instance carried a plausible-looking citation that was simply WRONG — presence is trivially satisfiable. It would also emit 26-172 findings against a 178-line prescriptive-field population (measured: `Proposal:` 70 total / 26 with no backticked path at all; `Target files:` 108 total / 104 with a path). I rejected it as a candidate 9th instance of this repo's inert-safeguard class (the log records an explicit "8th instance of the inert-safeguard" ordinal at improvement-log.md:179). Two further designs were rejected earlier with evidence by axcion-content-programme S6-623: (1) a CLAUDE.md rule — rule-shaped fixes have five recorded failures and zero catches, see session-start.md:274 and :286 (both verified present this session) and prime.md:747 (verified: the five-for-five note); (2) a new log schema field — fails at the write side, wrap-session.md:302 routes the QUEUE writer to session-feedback-collector.md format (verified present).

EVIDENCE THE RESOLUTION CHECK IS NON-INERT: executed against the live log BEFORE proposing it — 75 citations scanned, 1 unresolved found: `logs/missions/repo-health-backlog-2026-07.md:158` cited while that file has 123 lines (stale after the 2026-07-19 truth-pass cut it from 11 threads to 5). The repo has a documented history of stale line citations. Two MORE were found while preparing this very dispatch brief: `prime.md:699` was cited for content actually at `:747`, and a hook citation resolved against the wrong one of three copies of `check-foreign-staging.sh` (the `or "(inferred)" in low` predicate is at `:410` in the `ai-resources/.claude/hooks/` copy specifically; the sector-intelligence and .codex copies have different line numbers).

KNOWN LIMITS — SCORE THESE HONESTLY, DO NOT LET ME OVERSELL:
(a) It verifies that a citation RESOLVES, not that the cited content SAYS what the citing entry claims. It would still not have caught instances 3, 4 or 5. This is the honest ceiling of any mechanical check here.
(b) Any scan in this repo risks producing confident FALSE ABSENCES via the .gitignore-honouring harness grep (docs/audit-discipline.md:37; logs/scripts/search-canary.sh). This session already tripped that trap once — a context pack asserted "no file in the workspace mentions S6-623" when 12 files do, because .gitignore:56 ignores projects/axcion-content-programme/. So the script must state its own scope limits in its output or it becomes a NEW source of confident false absences.
(c) `improvement-log.md` is read by four commands (/prime Step 3, /open-items, /wrap-session, session-feedback-collector), and /prime Step 3 carries an explicit do-not-regress token-cost warning (a ~50-60k/session regression fixed 2026-07-13). Any FUTURE proposal to wire this into orientation must be scored against that. This proposal does not wire it anywhere — score whether that restraint actually holds, or whether an unwired script is itself an orphan (the repo has a live finding about built-but-unwired guards: "F-11 — two dead guards", and deleted warn-settings-change.sh on 2026-07-19 as "an unwired guard that failed open").

CONTEXT: ai-resources repo, main checkout. Placement `logs/scripts/` (command-invoked scan) deliberately chosen over `.claude/hooks/` because hook wiring in this workspace is unversioned — a separate open HIGH (mission thread 3) — and a new hook would inherit that defect. Reference implementations: `logs/scripts/check-decision-refs.sh`, `logs/scripts/check-usage-log-format.sh`. SESSION MANDATE STOP CONDITION: on RECONSIDER or NO-GO, record the design and build nothing.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/check-citation-resolution.sh — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/check-decision-refs.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/check-usage-log-format.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/search-canary.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/open-items.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/session-feedback-collector.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A well-evidenced, near-zero-blast-radius diagnostic script whose only real exposure is that it is a brand-new detection capability with no closure channel and (by the change's own design) no wired consumer — a tension the change already names honestly rather than hides.

## Consumer Inventory

Search terms: `check-citation-resolution.sh` / `check-citation-resolution` (the new script's own basename — no contract markers or frontmatter keys are introduced; it is a plain diagnostic script). Re-ran the absence-claim with `command grep` (not the ambient shell alias) after the search-canary reported `blind` on a dot-rooted walk (see below) — zero hits in both `ai-resources/` and the workspace root.

| Consumer path | Reference type | Must change? |
|---|---|---|
| (none found) | — | — |

**Total: 0 consumers, 0 must-change.** The target file is `not yet present`; this inventory covers the contract it would introduce (a plain-text stdout report of unresolved `path:NNN` citations) — nothing in `.claude/commands/`, `.claude/agents/`, `.claude/hooks/`, `skills/`, `workflows/`, or `docs/` names it, invokes it, or documents it. This is an isolated, unwired addition, exactly as the change description states. Instrument note: the canary (`. logs/scripts/search-canary.sh`) reported **blind** on this repo's dot-rooted walk (known-positive missed: `command grep` found 1, ambient `grep` found 0) — the zero-consumer finding above was re-derived with `command grep -r <term> .` from both repo roots, so it is not an artifact of the shadowed instrument.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Not registered as a hook (SessionStart/Stop/PreToolUse/UserPromptSubmit) — confirmed no hook-registration language anywhere in the change description, and the consumer inventory (above) found zero wiring into any settings.json or command.
- Not an `@import` target and does not touch any always-loaded CLAUDE.md — `ai-resources/CLAUDE.md` and workspace `CLAUDE.md` (read this session) carry no reference to it.
- Manual/on-demand invocation only (`bash logs/scripts/check-citation-resolution.sh`) — pay-as-used, the textbook Low case per the rubric's own calibration point.

### Dimension 2: Permissions Surface
**Risk:** Low

- `.claude/settings.json` already carries `"Bash(*)"` in `allow` with `"defaultMode": "bypassPermissions"` (read this session) — a new script invoked via `Bash` requires zero new permission grant; the capability already exists.
- No `Write`/`Edit` capability is needed or claimed — the change description states "no writes" explicitly, and the two reference implementations (`check-decision-refs.sh`, `check-usage-log-format.sh`, both read this session) are read-only in the same way.
- No new deny-rule removal, no scope escalation, no cross-repo or external capability introduced.

### Dimension 3: Blast Radius
**Risk:** Low

- Consumer inventory (Step 1.5, above): **0 consumers, 0 must-change.** Single new file, touches nothing else.
- No contract change to any existing file — the script only *reads* `logs/improvement-log.md`; it does not alter the log's schema (confirmed by reading the log's own `## Schema` block, `logs/improvement-log.md:1-16` — no citation-format field exists to be touched) and appends nothing.
- Does not touch shared infrastructure in a way that affects other commands — `logs/scripts/` is a shared directory in the sense that other commands' scripts live there, but this addition does not modify any sibling script or any caller of one.

### Dimension 4: Reversibility
**Risk:** Low

- A brand-new, standalone file with no siblings it creates and no log/data mutation (it performs no writes). `git revert` (or a plain `rm`) fully and cleanly removes it with no residue.
- No settings.json change to clean up, no external/pushed state, no automation that could fire between landing and a revert (it is not registered anywhere to fire from).

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **One implicit dependency on an undocumented convention.** The script's whole function depends on `path:NNN` (and, per the live data, `path:NNN-MMM` range form, e.g. `prime.md:206-224` seen at `logs/improvement-log.md:37`) being the citation shape used inside `Proposal:` / `Target files:` field values. This convention is **not** documented anywhere: `logs/improvement-log.md`'s own `## Schema` block (read in full, lines 1-16) defines `Proposal:` and `Target files:` only as free-text ("the proposed change" / "files to be edited when executed") with no citation-format spec, and neither `docs/spine-schemas.md` nor `docs/audit-discipline.md` (both checked, `command grep` for "path:line"/"path:NNN"/"file:line" — zero hits) formalizes it. The script therefore encodes a convention the log itself has never written down — a change to how citations are phrased (e.g., a future entry using `(see path, line NNN)` prose instead of `path:NNN`) would silently starve the scan without the scan or the log format visibly disagreeing.
- Not a *new* contract introduced by this change (Dimension 5's "undocumented new contract callers must honor" is not triggered — the script is a consumer of an existing convention, not a producer of a new one others must adopt), which keeps this at Medium rather than High.
- No functional overlap with `check-decision-refs.sh` (targets a different field/log, `decisions_refs` in run manifests) or `check-usage-log-format.sh` (targets append-position, not citation content) — distinct concerns, no double-handling of the same event.

### Dimension 6: Principle Alignment
**Risk:** Medium

Principles-base (`ai-resources/../projects/strategic-os/ai-strategy/principles-base.md`) was not read — not present per the `not yet present`/`exists` inventory convention and not listed as a referenced path; the inline checks from workspace `CLAUDE.md` § Design Judgment Principles and this file's Step 6.5 checklist were applied instead. Noting this per the fallback rule.

- **OP-12 (closure before detection) — genuine tension, not a clear violation.** This is new detection with no wired closure channel: the change explicitly states "NOT registered as a hook, invoked manually... This proposal does NOT wire it into any command." Unlike its own reference implementations — `check-decision-refs.sh` and `check-usage-log-format.sh` are both wired into `/wrap-session` (confirmed reading `wrap-session.md:270-276` and `:219-223`), giving them a running cadence and chat-surfaced output even though neither auto-fixes anything — this script has *no* firing mechanism at all. If run and a finding surfaces, nothing routes it anywhere durable (no auto-append to `improvement-log.md`, no `/open-items` surfacing); it is a chat/terminal-only output, the same "notification, not a queue" shape that `wrap-session.md` Step 12e was written specifically to end (read this session, lines 292-311: "Do not 'handle' a finding by mentioning it in the summary. A chat line is read once and gone."). This is the honest core of the tension the change description itself flags in known-limit (c).
- **OP-9/AP-7/DR-7 (speculative abstraction) — mitigated, not absent.** Zero current consumers per the Step 1.5 inventory is the textbook trigger signal, but the mitigating facts are concrete and verified: (1) it was executed against the live 75-citation population *before* being proposed and found 3 real unresolved citations (re-derived and confirmed this session — see Dimension 7), which is prong-(b)-shaped cited evidence rather than a "we'll need it later" abstraction; (2) `docs/ai-resource-creation.md` rule #7 (read this session, line 19) scopes the complexity-budget gate to "a new command, agent, mandatory stage/gate, or permanent always-loaded document" — a plain script under `logs/scripts/` invoked ad hoc does not literally fall in that enumerated set, so the gate's hard pass/fail test is not directly triggered.
- **The self-aware framing is the mitigating factor that keeps this Medium instead of High.** OP-11 asks whether a principle tension is surfaced loudly and on purpose versus drifting in silently. The change description explicitly poses the exact question a reviewer would ask ("score whether that restraint actually holds, or whether an unwired script is itself an orphan," citing the repo's own `F-11 — two dead guards` finding, `audits/research-workflow-deployment-fitness-2026-07-13.md:70`, confirmed present, and the `warn-settings-change.sh` deletion, confirmed via `git log`: commit `4feaead "chore: delete warn-settings-change.sh — an unwired guard that failed open"`). That is a recorded, loud acknowledgment of the exact risk this dimension exists to catch — not a silent version of the same shortfall. It does not fully clear the tension (no closure channel exists yet), which is why this is Medium, not Low.

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed, not asserted.** Re-derived the citation count independently rather than trusting the stated "75": `grep -noE '[A-Za-z0-9_./-]+\.[A-Za-z0-9]{1,5}:[0-9]+' logs/improvement-log.md | wc -l` → **75**, matching exactly (extensions used: md 52, sh 14, json 9). Re-opened the specific claimed-unresolved citation: `logs/improvement-log.md:37` reads `logs/missions/repo-health-backlog-2026-07.md:158` (confirmed by direct grep of that line); `wc -l logs/missions/repo-health-backlog-2026-07.md` → **123** — the citation genuinely exceeds the file's length, confirming the change description's live-execution claim as real, not asserted. Also independently re-opened and confirmed four more of the change description's supporting citations, all matching exactly: `session-start.md:274` and `:286` (both carry the "five times"/"five times over" language cited), `prime.md:747` (the "five-for-five recall-assertion pattern" note, verbatim), `wrap-session.md:302` (routes QUEUE writer to `session-feedback-collector.md` § Write formats, verbatim), `.gitignore:56` (`projects/axcion-content-programme/`, verbatim), and `check-foreign-staging.sh:410` (`"(inferred)" in low`, verbatim, in the `ai-resources/.claude/hooks/` copy specifically as claimed).
- **Consequence — traced, with an honestly-narrower scope than the full defect class.** The general cost of bad citations is traced to a real, documented incident, not inferred: `docs/audit-discipline.md:82` (read this session) states "the ~360k-token miss of 2026-07-14 (`logs/improvement-log.md`)" as the motivating precedent for the repo's premise-verification precondition — this is a real, cited cost, not a hypothetical one. The change description itself narrows the claim honestly: known-limit (a) states plainly that this specific script "would still not have caught instances 3, 4 or 5" of the five documented instances — i.e., it closes only the "citation does not resolve" slice of the defect class, not the (larger, costlier) "citation resolves but misrepresents" slice. This self-imposed narrowing is a mark in favor of the claim's honesty, not a gap.
- **Re-derivation vs. the change description:** None material — every checked count, path, and quoted line matched. One minor, non-material discrepancy: the change description's `Proposal:`/`Target files:` counts for the *rejected* presence-check design (70/26 and 108/104) come out as 73/108 under a looser regex match this session (`\*\*Proposal:\*\*` with no leading-dash anchor) — close enough to be the same measurement under minor pattern variance, and this figure supports a rejected alternative, not the primary defect claim being scored here.

## Mitigations

- **Dimension 5 (Hidden Coupling):** Before or as part of landing the script, add one line to `logs/improvement-log.md`'s `## Schema` block (or `docs/spine-schemas.md`) documenting the `path:NNN` / `path:NNN-MMM` citation convention the script depends on, so the convention the scan enforces is written down somewhere a future editor of the log's citation style would see. Also confirm the script itself handles the range form (`path:NNN-MMM`, live example: `prime.md:206-224`) rather than only single-line `path:NNN` — a script that silently mis-parses or skips range citations would under-report and look clean when it isn't.
- **Dimension 6 (Principle Alignment):** Make the OP-12/OP-9 tension the change already names into a recorded decision rather than leaving it implicit in a risk-check report. Add a one-line note (in `logs/decisions.md` or as a comment in the script's own header) stating: this is a deliberately-unwired diagnostic primitive, per OP-11 — an intentional, recorded restraint, not an oversight — with a concrete revisit trigger (e.g., "revisit wiring into `/friday-act` after 3 manual runs, or the first time a stale citation is found live in an actual session rather than during this evidence-gathering pass"). This converts "an unwired script is itself an orphan" from an open question this report flags into a bounded, loud exception the next session can check against.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line re-reads (`check-decision-refs.sh`, `check-usage-log-format.sh`, `search-canary.sh`, `docs/audit-discipline.md`, `logs/improvement-log.md` schema block and cited lines, `prime.md`, `session-start.md`, `wrap-session.md`, `session-feedback-collector.md`, `check-foreign-staging.sh`, `.gitignore`), live command execution (citation-count re-derivation, file-length checks, `search-canary.sh` sourced live and found `blind`, the absence-claim re-run with `command grep` after the canary result), grep counts across `ai-resources/` and the workspace root, and a `git log` check for the `warn-settings-change.sh` deletion commit. No training-data fallback was used on any read or command.
