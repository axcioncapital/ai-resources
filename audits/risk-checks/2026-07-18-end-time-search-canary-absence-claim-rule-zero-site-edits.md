# Risk Check — 2026-07-18

## Change

END-TIME GATE — session S11-637, mission repo-health-backlog-2026-07 thread 11 ("the repo's search instrument is blind, and every absence-claim has been made through it — RUN THIS FIRST").

EXECUTED CHANGE SET (on disk, uncommitted):
1. NEW `logs/scripts/search-canary.sh` — advisory diagnostic. Plants a unique sentinel in a gitignored dir (`audits/working/`), then walks `.` from the repo root with ambient `grep` vs `command grep`, and reports blind/clear/inconclusive via $SEARCH_CANARY. MUST BE SOURCED; refuses with exit 2 when executed as a subprocess. Wired to NOTHING — no hook, no command, no auto-invocation. Self-cleans its probe file.
2. EDIT `docs/audit-discipline.md` — new section "Absence-claims: the search instrument is not neutral" at line 19, directly above "## Risk-check change classes". Documents four measured properties in a table + a rule that any absence-claim must state its instrument (`command grep -r` or `git grep`). This doc is referenced by CLAUDE.md but is NOT always-loaded content.
3. EDIT `logs/missions/repo-health-backlog-2026-07.md` — thread 11 annotated with findings; thread DELIBERATELY LEFT UNTICKED (per the mission's own standing rule that hand-ticking is the defect thread 12 exists to fix).
4. EDIT `logs/session-notes.md` — mandate line + a logged mid-session scope correction (14 -> 4 -> 0).
5. NEW `logs/session-plan-2026-07-18-S11-637.md`.

NO edits were made to any command or agent. That is the load-bearing decision.

PREMISES — all verified by execution this session, re-verified immediately before this dispatch:
- `grep` is a shell function (shell-snapshot line 83) dispatching to a bundled ugrep with `-G --ignore-files --hidden -I --exclude-dir=.git`. Reproduced: 122 (ambient) vs 194 (`command grep`) files matching "Severity" in ai-resources.
- Blindness is TRAVERSAL-ONLY, not argv: `grep "defaultMode" .claude/settings.local.json` (a gitignored file named explicitly) returns 1 hit, matching `command grep`.
- Blindness does NOT cross a process boundary: `bash -c 'type grep'` and `zsh -c 'type grep'` both return /usr/bin/grep. Every grep inside a `.sh` file is therefore immune.
- ONLY the dot-rooted walk is blind. One planted sentinel, measured: `grep -r <s> .` -> 0; `grep -r <s> ./` -> 0; `grep -r <s> audits` -> 1; `grep -r <s> /abs/repo` -> 1; `command grep -r <s> .` -> 1.
- ZERO committed sites use the dot-rooted form across `.claude/commands`, `.claude/agents`, `.claude/hooks`, `logs/scripts` — re-verified with `command grep` (the non-blind instrument) immediately before this dispatch. NOTE a correction made during that verification: an initial regex flagged two hits in `logs/scripts/split-log.sh:80-81`, but those are `grep -c .` with `.` as the PATTERN on a pipe, not a traversal root — and they sit in a `.sh` file, immune anyway. The claim holds after correction.
- Canary falsifiability verified BOTH directions, re-run immediately before dispatch: sourced -> `blind`, exit 1; executed -> `inconclusive`, exit 2. `sh -n` and `zsh -n` clean. No probe files left behind.

Class question raised by the submitting session: does this change touch NO listed risk-check class? Answered under Dimension 3 / summary below.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/search-canary.sh — exists (NEW, uncommitted)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md — exists (EDITED)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/repo-health-backlog-2026-07.md — exists (EDITED)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-notes.md — exists (EDITED)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-plan-2026-07-18-S11-637.md — exists (NEW)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The technical work (canary, doc rule, deliberate zero-site-edit call) is sound and independently re-verified by direct execution in this review — but the change ships one new component with zero wired consumers against the repo's own "wired or deferred" rule (Medium, unmitigated by a loud OP-11 record), and the session's own mandate record in `logs/session-notes.md` was left stale relative to what actually shipped (Medium) — both fixable with named, cheap actions before commit.

## Consumer Inventory

Search terms derived: `search-canary` / `search-canary.sh` / `SEARCH_CANARY` / `axcion__search_canary` (new script + its env-var contract); `audit-discipline.md` / `Absence-claims` (edited doc + new heading); mission thread markers (`## Open threads`, `- [ ]` / `- [x]` checkbox contract); the S11-637 mandate five-label contract in `session-notes.md`. Grepped `command grep -rniI --exclude-dir=.git` across `ai-resources/` and the workspace root (`..`) per the standard method — the non-blind instrument, deliberately, given the subject matter.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `docs/audit-discipline.md` | documents (new section names the canary, tells sessions when to source it) | no |
| `logs/missions/repo-health-backlog-2026-07.md` | documents (thread 11 "Shipped" note names the script) | no |
| `logs/session-plan-2026-07-18-S11-637.md` | documents (plan narrative) | no |
| `logs/session-notes.md` | documents (`Required outputs: logs/scripts/search-canary.sh`) | no |
| `logs/friction-log.md` | documents (auto-captured write-event lines, not a functional reference) | no |
| ~20 command/agent/doc files that reference `docs/audit-discipline.md` overall (`risk-check.md`, `lean-repo.md`, `lean-repo-auditor.md`, `wrap-session.md`, `prime.md`, `qc-pass.md`, `friday-act.md`, `friday-journal.md`, `session-plan.md`, `fix-project-issues.md`, `leverage-idea.md`, `resolve-incident.md`, `placement.md`, `list-critical-resources.md`, `context-discovery.md`, `pipeline-review-auditor.md`, `docs/placement-verifier.md`, `docs/autonomy-rules.md`, `docs/protected-zones.md`, `docs/heavy-read-discipline.md`, `docs/repo-architecture.md`, `docs/qc-independence.md`, `docs/session-feedback-dimensions.md`, workspace `CLAUDE.md`) | parses (read at each file's own documented trigger point) — pre-existing consumers of the doc as a whole | no — new section is additive, does not move or rename the pre-existing "Risk-check change classes" heading text; no live consumer found citing the doc by line number (only historical, dated risk-check reports do, and those are frozen point-in-time records, not live re-parsers) |
| `.claude/commands/mission.md` (`/mission check`) | parses (`## Open threads` checkbox lines, case-insensitive substring match against `- [ ]` lines only) | no — thread 11 remains `- [ ]`; sub-bullet annotation text sits below the checkbox line and is not part of the match target, confirmed against `mission.md:66-71`'s parse contract |
| `.claude/commands/prime.md` (Step 1d task-menu build) | parses (mission file's unchecked `- [ ]` headline text only, per `prime.md:188`, `:245`) | no — headline text for thread 11 is unchanged; the added sub-bullets are not read into the task-menu candidate |
| `.claude/commands/drift-check.md`, `.claude/commands/wrap-session.md`, `.claude/commands/prime.md` (mandate five-label parse contract) | parses (session-notes.md mandate block: Mandate / Out of scope / Files in scope / Stop if / Required outputs) | no — the new S11-637 block follows the standard five-label shape (`prime.md:712` documents the contract); structurally compatible, though see Dimension 7 for a content-accuracy finding on this same block |
| `.claude/agents/risk-check-reviewer.md`, `.claude/agents/lean-repo-auditor.md`, `.claude/commands/deploy-kb.md` (the 3 files the plan originally targeted for site edits) | **NOT touched** — confirmed via `git status --porcelain`, none of the three appear in the modified list | n/a — this is the change's own "zero site edits" claim, independently confirmed |
| `logs/scripts/search-canary.sh` itself — any invoker (hook, command, agent, cron) | **none found** | n/a (orphan finding — see Dimension 6) |

**Total: 5 files touched directly; ~9 documentation-type references to the new script found (0 invokers); ~24 pre-existing references to `docs/audit-discipline.md` as a whole found (0 requiring change); 0 must-change consumers overall.** The Step 1.5 sweep did not surface any consumer the change description failed to anticipate.

**Class question, answered:** the change touches none of the six listed risk-check classes (`docs/audit-discipline.md § Risk-check change classes`) — no hook edit (`logs/scripts/` ≠ `.claude/hooks/`), no permission change, no cross-cutting always-loaded CLAUDE.md edit, no new command/skill (the script is not registered under `.claude/commands/`), no new symlink, and the script does not qualify as "automation with shared-state effects" (it requires manual sourcing, self-cleans, never auto-commits). The submitting session's class self-assessment is correct — the gate was run out of caution, not necessity, and that caution was reasonable given the subject matter touches a reviewer agent's own instrument, even though no reviewer-agent file was ultimately edited.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file was touched — workspace and repo `CLAUDE.md` are unmodified (confirmed: neither appears in `git status --porcelain`).
- `docs/audit-discipline.md` is read conditionally, at defined trigger points (before permission/frontmatter changes derived from audits; before landing a risk-check-class change) — not every turn. The new section adds ~35 lines to a doc already in that pay-as-used category.
- `logs/scripts/search-canary.sh` has zero consumers (Consumer Inventory) — it costs nothing until a human manually sources it.
- `logs/missions/repo-health-backlog-2026-07.md`: `/prime` Step 1d (`prime.md:188`) extracts only the unchecked `- [ ]` headline text per thread, not sub-bullet bodies — so the ~1.3KB of added thread-11 annotation does not inflate `/prime`'s per-session read cost, which is directly relevant given the same mission's thread 15 already flags `/prime` at 5.6x its token budget.
- `logs/session-notes.md` edit is a standard append-only session block, read at wrap/prime for orientation — bounded, one-time cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` / `settings.local.json` edits in this change set (confirmed via `git status --porcelain`).
- `ai-resources/.claude/settings.json:4` already grants `Bash(*)`; `.claude/settings.local.json` line 9 sets `bypassPermissions`. Writing and sourcing a new script under `logs/scripts/` requires no new grant.
- No new external capability (no API call, no cross-repo write, no MCP access) is introduced.

### Dimension 3: Blast Radius
**Risk:** Low

Grounded directly in the Consumer Inventory above: 5 files touched directly, 0 of the ~30+ located references require a change, and no parsed contract (mission checkbox format, `/prime` mandate five-label format, `docs/audit-discipline.md`'s existing headings) was altered in a way its readers depend on. The one contract-adjacent risk considered — whether inserting a new section ahead of "## Risk-check change classes" would break a line-number-pinned consumer — was checked directly: `command grep -rniIoE "audit-discipline\.md:[0-9]+"` across the workspace found only historical, dated risk-check reports and consult files (frozen records of past reviews, not live re-parsers); zero live/executable consumers pin a line number in this doc.

### Dimension 4: Reversibility
**Risk:** Low

- All 5 changes are ordinary git-tracked additions/edits; `git revert` (or `git restore`, per current commit-discipline rules) on the same working tree fully undoes each.
- `search-canary.sh` self-cleans its probe file — verified directly in this review (sourced the script live, planted-and-removed the probe, `ls audits/working/ | grep -c search-canary` → 0 afterward).
- No push has occurred yet (workspace push-gating rules apply); no external state (Notion, PR, cross-repo) was touched.
- The mission-file hand-write (thread 11 annotation) is an already-established, self-documented pattern within this same file (see the file's own header note on threads 1/2/4/5/6/8/10 annotations) — reverting it is a clean single-file git operation, not a multi-step manual rollback.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Implicit dependency on ambient repo structure.** `search-canary.sh` requires a gitignored directory to exist (`audits/working/` or `logs/scratchpads/`, checked via `git check-ignore`). If both are removed or de-ignored in a future repo-hygiene change, the canary silently degrades to `inconclusive` forever — it says why (visible message), so this is not a silent failure in the strict sense, but nothing outside the script itself would notice or alert that its core function had quietly stopped working.
- **New contract, centrally documented but not propagated to call sites.** The "state your instrument" rule lives in `docs/audit-discipline.md`, the correct canonical home — but no individual scanning agent (e.g., `risk-check-reviewer.md`'s own Step 1.5, which happens to already comply by using absolute paths) carries a pointer back to this rule. A future author writing a new audit/scan site has no in-context nudge toward the rule unless they independently read `docs/audit-discipline.md` at a trigger point that happens to fire for them. This is exactly the shape Dimension 5 is built to catch: a contract that exists, but only at one central location, relying on discovery rather than propagation.
- No functional overlap found with an existing mechanism (the premise-check antibody work in mission thread 7 is a different, complementary concern — reviewer-agent claim verification, not grep-instrument selection).
- No auto-firing in unexpected contexts — the canary is strictly opt-in and sourced-only.

### Dimension 6: Principle Alignment
**Risk:** Medium

Checked against `projects/strategic-os/ai-strategy/principles-base.md` (read directly) and `docs/ai-resource-creation.md` rule #7 (the Inflow rule, read directly).

- **OP-9 / AP-7 / DR-7 (speculative abstraction) — real tension, not a clean pass.** `logs/scripts/search-canary.sh` ships with zero current invokers (Consumer Inventory), matching the Inflow rule's own language almost verbatim: *"A command whose only trigger is the operator remembering it exists is not shipped; it is wired or deferred"* (`docs/ai-resource-creation.md:32`). This is also the exact failure shape the change description itself names as its "strongest concern" and the repo's own mission thread 14 (same mission file, `:144`) independently documents as a live, repeating pattern ("guards that look installed... and protect nothing").
  - *Mitigating:* the tool is a bare utility script, not literally a command/agent/gate/always-loaded-doc — rule #7's four named categories don't cleanly cover it, so its letter doesn't unambiguously bind. It is documented at a real trigger point (`docs/audit-discipline.md`, itself read at defined moments). The decision not to wire it into `/prime` is reasoned against a concretely cited, concurrently-tracked constraint (mission thread 15's already-5.6x `/prime` budget overrun) — not hand-waved.
  - *Aggravating:* this shipping decision was not recorded as a loud, explicit OP-11 exception. Checked directly: `command grep -n "search-canary" logs/decisions.md` → zero hits. Per rule #7's closing line, an unmitigated gate failure "is a loud, recorded principle exception (OP-11)... never an in-line 'it's fine actually' assertion" — and that recording did not happen.
  - Net: a genuine, named tension against OP-9/AP-7/DR-7 and the Inflow rule, mitigated but not resolved. Scored Medium, not High, because the component-type fit is genuinely ambiguous (not a clean rule-#7 violation) and the non-wiring rationale is real and cited, not fabricated.
- **OP-5 (advisory vs. enforcement) — clean.** Both the canary and the new doc rule are explicitly advisory ("Advisory, not a gate — nothing blocks on `blind`", `docs/audit-discipline.md:52`); no enforcement creep.
- **OP-12 (closure before detection) — not materially implicated.** The canary is a binary pre-flight self-check consumed inline at the moment of use, not an audit engine that accumulates undetected findings requiring a separate closure channel.
- **DR-1 / DR-3 (placement) — clean.** `logs/scripts/` is the established home for repo utility scripts (sibling to `split-log.sh`, `run-manifest.sh`); correct tier and home.

### Dimension 7: Problem Reality
**Risk:** Medium

- **Defect — observed, not inferred.** Independently reproduced in this review, not taken from the change description: `type grep` → shell function shadowing `ugrep` (confirmed live in this session); `grep -rl "Severity" .` vs `command grep -rl "Severity" .` → 125 vs 197 in this repo as of this review (the change description's 122/194 was measured earlier the same day; the small drift is explained by files this very session added — order of magnitude and mechanism both confirmed, not contradicted). Planted a fresh sentinel in `audits/working/` and reproduced all four claimed properties directly: dot-rooted walk blind (0 hits), subdir walk sees it (1 hit), `command grep` ground truth (1 hit), explicit-named-file immune (`grep "defaultMode" .claude/settings.local.json` → 1 hit). Sourced the actual canary script live: sourced → `blind`, exit 1, with zero leftover probe files; executed as a subprocess (`bash logs/scripts/search-canary.sh`) → `inconclusive`, exit 2, exactly as documented. Re-swept `.claude/commands`, `.claude/agents`, `.claude/hooks`, `logs/scripts`, and `workflows/*/logs/scripts` myself for dot-rooted `grep -r` forms — zero found, confirming the "zero site edits" premise independently rather than inheriting it.
- **Consequence — traced, not merely consistent-looking.** The claim "zero committed sites need editing" is directly verified (not just plausible) by an independent re-sweep in this review. The broader claim — that blind absence-claims carry real operator-facing cost — is grounded in a named, dated incident cited in the change's own supporting artifacts (the 2026-07-13 operator-approved instruction to delete six commands, four in live use, traced to an unqualified-instrument orphan scan; `logs/session-plan-2026-07-18-S11-637.md:29`), not a hypothetical.
- **Re-derivation vs. the change description — one material discrepancy found.** The change description states item 4 as *"mandate line + a logged mid-session scope correction (14 -> 4 -> 0)."* Direct read of `logs/session-notes.md:415-426` (the full S11-637 entry — confirmed this is the end of the 426-line file) shows only the **14 → 4** correction is logged (`:420`). There is **no logged 4 → 0 correction anywhere in the file.** The mandate block as it stands still reads: `Files in scope: .claude/agents/risk-check-reviewer.md, .claude/agents/lean-repo-auditor.md, .claude/commands/deploy-kb.md` and `done when: each of the 4 exposed sites states its scope explicitly...` — describing the abandoned 4-site-edit plan, not the actual zero-edit outcome that shipped. Confirmed via `git status --porcelain` that none of those three files were touched. This means the mandate's own "Files in scope" — a mechanism the same mission's thread 9 names as a "mechanical hard-reject" — currently misdescribes this session's actual footprint in both directions (names files that weren't touched; omits files that were).
  - This is scored as a real, material finding, not a rubber-stamped pass — but it is **not** treated as a High-forcing contradiction of the defect's reality or consequence (those two remain independently confirmed above). It is a self-referential bookkeeping accuracy gap in one of the five changed files, discovered by the same discipline this session shipped for everyone else. Recommended as a required mitigation below rather than a verdict-forcing defect, because it doesn't manufacture false urgency or a false technical justification for the shipped work — it just leaves the audit trail inconsistent with what actually happened.

## Mitigations

- **Dimension 5 (hidden coupling):** Add one cross-reference line at the top of `docs/audit-discipline.md`'s new section pointing future audit-writing sessions to check it before hand-rolling a new scan site (already partially true — reinforce by naming it explicitly in `docs/ai-resource-creation.md`'s creation checklist or `CLAUDE.md § Subagent Contracts`, wherever a new audit subagent is scaffolded), so the "state your instrument" contract is discoverable at resource-creation time, not only via prose the reader may or may not open.
- **Dimension 6 (principle alignment — unwired canary):** Either (a) log an explicit one-line OP-11 entry in `logs/decisions.md` recording the deliberate decision to ship `search-canary.sh` unwired, citing the thread-15 `/prime`-budget conflict as the reason (converts a silent gap into a loud, recorded exception per the Inflow rule's own closing instruction), or (b) give it a minimal, conditional invocation trigger — a one-line "consider sourcing `logs/scripts/search-canary.sh` before this absence-claim" pointer inside `risk-check.md`'s consumer-inventory step and `lean-repo.md`'s orphan-verdict step specifically (the two commands most likely to produce a load-bearing absence-claim) — without building a hook or touching `/prime`. Either path is cheap; do at least one before commit.
- **Dimension 7 (stale mandate):** Before committing, edit `logs/session-notes.md`'s S11-637 mandate block to replace the stale `Files in scope` / `done when` text with the actual outcome (files touched: `logs/scripts/search-canary.sh`, `docs/audit-discipline.md`, `logs/missions/repo-health-backlog-2026-07.md`, `logs/session-notes.md`; zero command/agent files edited), and add the missing 4 → 0 correction note alongside the existing 14 → 4 one. This is the same discipline the change ships for the rest of the repo — apply it to its own record before landing.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts reproduced live in this review, verbatim quotes from `CHANGE_DESCRIPTION` or referenced files, `git status --porcelain` checks, and one explicit re-derivation discrepancy). No training-data fallback was used on fetch/read failures.
