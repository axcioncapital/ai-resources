# Risk Check — 2026-07-13

## Change

Batched plan-time gate for the 3-item fix plan at ai-resources/audits/fix-plans/fix-repo-issues-2026-07-13-2134.md. Two structural changes are in scope for this gate (item 3 is log/reference hygiene with no runtime surface and is explicitly excluded per the plan's gate discipline):

CHANGE 1 (id-55) — command/agent control-flow edit to `/lean-repo`, a tool that issues deletion recommendations. Two parts, both required:
  Part A: In `.claude/commands/lean-repo.md` (the Q3 "orphan/adoption grep" definition) and `.claude/agents/lean-repo-auditor.md`, widen any orphan/adoption check over commands to scan `projects/*/logs/` and `projects/*/CLAUDE.md` in addition to `ai-resources/`. Rationale: commands are invoked from PROJECT sessions which log to their own logs/, so the ai-resources-only grep returns "zero use" for heavily-used commands by construction.
  Part B: Downgrade the emitted verdict language from an actionable "orphan → remove" to "no evidence of use in scanned scope → CONFIRM BEFORE DELETE", and require the report to state its scanned scope explicitly. Rationale (System-Owner-directed): widening the grep makes the lens less wrong, not right — "zero hits" still does not mean "unused" (usage also lives in scratchpads, operator habit, and un-logged invocations; usage-log.md has been opt-in since 2026-07-04). The report must never again hand the operator a delete instruction it has no standing to make.
  Live consequence being fixed: on 2026-07-13 this lens produced a confident, operator-approved instruction to delete SIX commands, FOUR of which are in live use — including /explore-section, the primary command of the live axcion-design-studio project. Only a batched /risk-check plus direct verification stopped it.
  Planned validation: plant a known-positive (/explore-section, 89 invocation mentions in axcion-design-studio) and confirm the corrected lens FINDS it. A fix that cannot be falsified has not been tested.
  Blocking relationship: this must land BEFORE M-1 (a pending /lean-repo plan item that folds this same Q3 lens into /architecture-review). If M-1 lands first, the defect propagates into a command whose verdicts the operator is MORE likely to act on and LESS likely to re-verify.

CHANGE 2 (id-53) — hook edit. Add `logs/runs/*.json` to the shared-artifact allowlist in `.claude/hooks/check-foreign-staging.sh`. One line, matched to the existing literal pattern syntax (the hook matches literally; brace-expansion shorthand does NOT work — a contract break already logged twice this week). No change to wrap-session.md — its Step 12d is correct as written.
  Problem being fixed: wrap-session.md Step 12d explicitly instructs staging logs/runs/{date}-{marker}.json, but the hook's allowlist covers session-notes.md, decisions.md, usage-log.md and friends — NOT logs/runs/*.json. One command instructs the stage; another guard blocks it. It fires on every wrap whose mandate did not enumerate logs/runs/ — i.e. every session whose mandate was written at /prime time, which is the normal case. The blocked file is marker-scoped and therefore structurally incapable of being foreign.
  Why it matters beyond the annoyance: the dangerous failure mode is not the block, it is the WORKAROUND. An agent that hits this reaches for a bypass and learns to route around the exact tripwire that stops concurrent-session contamination. This guard is a High-classified hard-block (risk-topology.md § 1).
  Rejected alternative: have /prime pre-declare logs/runs/ in every mandate's Files in scope — papers over the guard's model with boilerplate in every mandate, and still breaks for any session that skips /prime.
  Planned validation: BOTH directions — confirm the guard still BLOCKS a planted genuinely-foreign path, AND now PASSES logs/runs/2026-07-13-S11.json. A one-line allowlist edit that accidentally widens the pattern would silently disable the tripwire (fails open, and quiet).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/lean-repo.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/lean-repo-auditor.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/architecture-review.md — exists (cross-reference only; not edited by this change)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists (not edited; its Step 12d is the instruction the hook currently blocks)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/lean-repo-2026-07-13.md — exists (report carrying the FALSE annotation on § INVESTIGATE)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/fix-repo-issues-2026-07-13-2134.md — exists (plan of record)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/risk-topology.md — **does not exist at this path** (verified: `Read` returned "File does not exist"). The intended file is `projects/repo-documentation/vault/architecture/risk-topology.md` (confirmed present, read for this report). The `.prime-mtime` "High" row in that file describes `check-foreign-staging.sh`'s hard-block behavior in its consequence text, but there is no dedicated "High" row for the hook itself — the CHANGE_DESCRIPTION's citation is approximately, not literally, grounded. Flagged; does not change the verdict.

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Both edits are small, additive-only, and evidence-grounded, but the consumer inventory surfaced one unnamed must-edit consumer (a Codex-agent mirror carrying the exact defect text) and one high-exposure runtime fact — `check-foreign-staging.sh` is registered exactly once, at user level, for every Claude Code session on this machine, and a live concurrent git worktree session is using it right now.

## Consumer Inventory

| Consumer path | Reference type | Must change? |
|---|---|---|
| `.claude/commands/lean-repo.md` | edit target (Part A + B) | yes |
| `.claude/agents/lean-repo-auditor.md` | edit target (Part A + B) | yes |
| `.codex/agents/lean-repo-auditor.toml` | co-edits (byte-identical Q3 text mirror; **not named in the fix plan's target-file list**) | yes — **gap found, not anticipated by CHANGE_DESCRIPTION** |
| `.claude/commands/architecture-review.md` | documents (M-1's future target; correctly cross-referenced, correctly not edited now) | no |
| `audits/lean-repo-2026-07-13.md` § INVESTIGATE | co-edits (plan's own "post-fix log update" instructs a separate annotation pass) | no (separate action, same item) |
| `logs/improvement-log.md:646` | co-edits (status flip owed after the fix, per plan) | no (separate action) |
| `ai-resources-research-workflow/.claude/commands/lean-repo.md`, `.../agents/lean-repo-auditor.md` | co-edits (live concurrent git **worktree**, branch `session/2026-07-13-research-workflow`, 1 commit ahead of `main`, currently byte-identical) | no (different branch; future-merge risk only) |
| downstream project copies of `/lean-repo` | none | n/a — `lean-repo` is explicitly in `auto-sync-shared.sh`'s `EXCLUDE_COMMANDS`; zero symlinked project copies exist |
| `.claude/hooks/check-foreign-staging.sh` | edit target (Change 2) | yes |
| `~/.claude/settings.json` (user level) | invokes — the **sole** live PreToolUse(Bash) registration for this hook, hardcoded to this file's absolute path | no (registration itself unchanged; but this is why the edit's runtime reach is global, not per-repo) |
| `.codex/hooks/check-foreign-staging.sh` | co-edits (byte-identical mirror; confirmed **not currently wired** into `.codex/hooks.json` PreToolUse — an inert copy today) | recommended, not runtime-required |
| `ai-resources-research-workflow/.claude/hooks/check-foreign-staging.sh` | co-edits (same worktree fact as above; currently byte-identical, not separately registered) | no |
| `.claude/commands/wrap-session.md` Step 12d | parses (its staging instruction is exactly what the new allowlist entry must satisfy) | no — plan explicitly and correctly excludes it |
| `logs/scripts/run-manifest.sh` | implicit dependency (the fix's safety claim — "marker-scoped, cannot be foreign" — rests on this script's naming convention continuing to hold) | no |
| `docs/commit-discipline.md`, `docs/session-marker.md` | documents (the hook's two-end contract) | no |
| ~150 historical mentions across `logs/session-notes*.md`, `logs/decisions*.md`, `audits/risk-checks/*.md`, scratchpads | documents (past work, not live consumers) | no |

**Total: 16 distinct load-bearing consumer rows, 4 must-change** (2 direct edit targets each for Change 1 and Change 2, plus 1 unanticipated must-change gap for Change 1's Codex mirror). The live concurrent-worktree session is not a file consumer but is carried into Dimension 5 as a runtime-coupling finding.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Change 1 edits existing on-demand command/agent prompt text; `/lean-repo` is invoked manually and, per its own report, this is its **first-ever run** in the repo's history (`audits/lean-repo-2026-07-13.md:18`) — negligible frequency.
- Change 2 adds one tuple entry to an already-registered hook; the hook's own gated-verb early-exit (`check-foreign-staging.sh:79-141`) means the added check only runs full logic on `git commit`/`git add -A` style invocations, not on every tool call — no new PreToolUse-per-call surface is created.
- No new always-loaded CLAUDE.md content, no new hook registration, no new subagent, no new skill-trigger pattern.

### Dimension 2: Permissions Surface
**Risk:** Low

- Neither change touches `settings.json`, `allow`/`ask`/`deny`, or grants a new tool capability. Change 2 edits an internal allowlist inside an existing advisory tripwire (`EXEMPT_DIR_PREFIXES`, `check-foreign-staging.sh:369`) — this changes what the tripwire treats as benign, not what Claude Code is permitted to invoke.
- Note (not scored as risk): the edit is structurally *analogous* to loosening a deny-style rule, even though it lives in hook code rather than `settings.json` — worth the operator's attention for that reason, but it does not meet the "grants a new capability" bar this dimension scores against.

### Dimension 3: Blast Radius
**Risk:** Medium

- Grounded directly in the Step 1.5 inventory: 16 load-bearing rows, 4 must-change, **one of which (`.codex/agents/lean-repo-auditor.toml`) was not named in the fix plan's target-file list** (`fix-repo-issues-2026-07-13-2134.md:40` lists only `.claude/commands/lean-repo.md`, `.claude/agents/lean-repo-auditor.md`, and a cross-ref to `architecture-review.md` — the Codex mirror is absent). If this gap ships unfixed, the Codex harness silently keeps running the discredited narrow-scope Q3 test and the un-softened "orphan → remove" verdict language — the exact defect this change exists to close, on one harness only.
- Change 2's single edit target (`.claude/hooks/check-foreign-staging.sh`) is registered exactly once, at **user level** (`~/.claude/settings.json:61`, absolute path), which means its runtime reach is **every Claude Code session on this machine across every repo**, not scoped to `ai-resources`. The content delta itself is tiny and purely additive (one directory-prefix exemption), which keeps this from being High.
- Contained by: zero downstream project copies of `/lean-repo` (explicitly excluded from `auto-sync-shared.sh` propagation — confirmed via `EXCLUDE_COMMANDS="new-project deploy-workflow pipeline-review scope-project lean-repo"`); no other command programmatically globs `audits/lean-repo-*.md` (confirmed against `architecture-review.md`'s Step 2 input table, which lists audit-repo/token-audit/repo-dd/analyze-workflow only); the `.codex/hooks/check-foreign-staging.sh` mirror is currently unregistered/inert, so its own drift has no runtime effect today.

### Dimension 4: Reversibility
**Risk:** Low

- Both changes are plain-text edits to git-tracked files; `git revert` on either fully restores prior behavior with no sibling files, no data/log mutation, and no external write as part of the structural edit itself.
- The plan's companion actions (flipping `logs/improvement-log.md:646` and annotating `audits/lean-repo-2026-07-13.md` § INVESTIGATE) are append/correct log writes, not part of the structural edit under review — recommend landing them as a **separate commit** from the command/agent/hook edit so a revert of the structural change stays clean and does not also revert the log correction (or vice versa).
- No `git push`, no cross-repo write, no external API call in either change.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Live concurrent-session exposure on a concurrency-safety hook.** `git worktree list` confirms a second, active worktree — `ai-resources-research-workflow`, branch `session/2026-07-13-research-workflow`, 1 commit ahead of `main` (`e08137e` vs `9e8988d`), unwrapped. Because `check-foreign-staging.sh` is registered exactly once at user level (Dimension 3), that concurrent session's own `git commit`/`git add -A` calls invoke the **same physical script file** this change edits — not an independent copy. The script's own documented contract degrades OPEN on any parse/exception failure (`check-foreign-staging.sh:61,69-72`, "degrade open, never blocks a commit because the guard itself broke") — so a malformed intermediate edit state would silently disable the exact tripwire built to stop concurrent-session contamination, for both sessions, at the one moment concurrency is real rather than hypothetical. This is the named concern behind DR-10 ("no directory wildcards for `git add` during disclosed concurrent sessions... `/permission-sweep` must not run while a concurrent session is active") applied to a closer case: editing the guard itself while a concurrent session is live.
- **Undocumented dependency on `run-manifest.sh`'s naming convention.** The fix's safety claim — "the blocked file is marker-scoped and therefore structurally incapable of being foreign" — is not self-contained; it silently assumes `logs/scripts/run-manifest.sh` continues writing `{date}-{marker}.json` filenames. This dependency is real and currently true, but is not named at the change site (only in the CHANGE_DESCRIPTION's prose, not in the code or a comment).
- **Two distinct matching engines in one file, easy to conflate.** `EXEMPT_DIR_PREFIXES` (what Change 2 edits) is a plain `str.startswith()` literal-prefix test; `in_footprint()` elsewhere in the same file (`check-foreign-staging.sh:395-410`) uses `fnmatch` glob matching for footprint tokens. The CHANGE_DESCRIPTION's own target string, `logs/runs/*.json`, is valid syntax for the *second* engine but not the first — see Dimension-3/(b) answer below for the concrete failure mode.
- **Codex-mirror drift** (also counted in Blast Radius) is itself a hidden-coupling instance: two files carry the same contract with no shared source of truth beyond operator discipline.

### Dimension 6: Principle Alignment
**Risk:** Low

- **OP-5 (advisory vs. enforcement).** Part B of Change 1 moves verdict language explicitly *away* from an enforcement-flavored instruction ("orphan → remove") and *toward* advisory framing ("no evidence of use in scanned scope → CONFIRM BEFORE DELETE") — this is the direction OP-5 endorses, not a silent enforcement upgrade.
- **OP-12 (closure before detection).** Both items close a proven, live-incident-evidenced defect in existing detection machinery; neither adds new detection without a closer. Change 1 repairs a false-positive generator; Change 2 repairs a contract mismatch between an existing instruction and an existing guard.
- **OP-9 / AP-7 / DR-7 (speculative abstraction).** Neither change builds new infrastructure for an absent consumer — both are repairs to existing, already-shipped components, grounded in a named, dated incident (the six-command near-miss) and a two-week-old contract break (wrap-session Step 12d vs. the hook), which clears rule #7 prong (b) cleanly. No new component is created.
- **DR-1 / DR-3 (placement).** `.codex/agents/*.toml` is the established, 42-of-42 mirror location for agent definitions — the missing consumer flagged in Blast Radius is an execution-scope gap, not a placement violation.
- One minor, non-scored observation carried to question (d) below: the CHANGE_DESCRIPTION frames the id-55-before-M-1 ordering as urgent/load-bearing; M-1 is in fact `HELD`/`RECONSIDER`-blocked and parked pending operator arbitration (see below), which somewhat overstates the immediacy — but this is a framing precision issue, not a principle violation (no enforcement upgrade, no scope expansion, no undocumented drift).

## Answers to the operator's four questions

**(a) Soften vs. remove `/lean-repo`'s Q3 lens — straight answer.** Soften now, as scoped; do not fold retirement into this fix. `/lean-repo` has run exactly once ever, and its own output (`audits/lean-repo-2026-07-13.md`) already carries an open, parked question — "retire `/lean-repo`?" — logged in the fix plan as `id-12/13/14`, tagged `decision-needed, operator arbitration required`, explicitly routed to `/friday-act` or a dedicated gated session, **not** to this fix. Retirement is a bigger, separate design decision (it also entangles with M-1's HELD merge-into-`/architecture-review` proposal). Part B's downgrade to "confirm before delete" is the correct-sized fix for *this* item: it removes the tool's false deletion authority without pre-empting the separate, larger retirement call. This is an operator decision, not this risk-check's to make — the report states the straight technical answer (soften is right-sized) but does not resolve the parked retirement question.

**(b) Can the allowlist edit over-match and silently disable the guard — empirically verified.** `EXEMPT_DIR_PREFIXES` (`check-foreign-staging.sh:368-370`, `is_exempt()` loop at 375-377) is matched with plain Python `path.startswith(pref)` — a literal-prefix substring test. It is **not** a glob and **not** a regex (contrast with `in_footprint()` a few dozen lines later, which *does* use `fnmatch` for `*`/`**` tokens — two different matching engines coexist in this one file). Case-sensitive, anchored at string start only.
  - **The exact literal string to add is `"logs/runs/"`** (trailing slash, same shape as the two existing entries `"audits/risk-checks/"` and `"audits/working/"`).
  - **The CHANGE_DESCRIPTION's own target string, `logs/runs/*.json`, is the wrong literal for this engine.** If pasted verbatim (with the literal `*`) into `EXEMPT_DIR_PREFIXES`, no real path will ever `startswith` a string containing a literal asterisk in that position — the edit would silently do **nothing**: the guard keeps blocking exactly as before, and the wrap-time friction this fix is meant to close would persist, undetected, until the next wrap fails again. That is a **fail-closed / fail-to-fix** risk, not a fail-open one.
  - **A genuine fail-open/over-match risk exists only from a different mistake:** choosing too broad a prefix. `"logs/"` alone would newly exempt `logs/scripts/`, `logs/missions/`, `logs/contracts/`, and any other subtree not already covered by the basename/pattern rules in the same function — a real widening of the tripwire's blind spot. Omitting the trailing slash (`"logs/runs"`) would also match a hypothetical `logs/runs-old/` or `logs/runs2/` directory. Both are avoidable by using the exact `"logs/runs/"` string and are named as mitigations below.

**(c) Consumer/blast-radius surface of `/lean-repo` command + agent — empirically grepped.** No other command invokes `/lean-repo` as a slash command (zero hits searching `.claude/commands/*.md` outside `lean-repo.md` itself). `lean-repo` is explicitly excluded from `auto-sync-shared.sh`'s project-propagation list, so it exists **only** at the canonical `ai-resources/.claude/commands/lean-repo.md` — no downstream project has a copy. `lean-repo-auditor` is spawned solely by `/lean-repo` Step 3 (no other Task-tool caller found). It **does** have a Codex-harness mirror, `.codex/agents/lean-repo-auditor.toml`, byte-identical in its Q3 text — this is the one real, unnamed must-change consumer (see Blast Radius). No other command programmatically reads `audits/lean-repo-*.md` (confirmed `architecture-review.md`'s Step 2 input table does not include it); the report's only consumers today are the operator directly and the advisory `/friday-act` closure-channel narrative. Net: narrow, contained blast radius, with one real gap.

**(d) Is landing id-55 before M-1 genuinely load-bearing, or sequencing hygiene?** Empirically, M-1 is **not imminent** — `audits/lean-repo-2026-07-13.md:10` records it as `HELD — /risk-check RECONSIDER; deferred with R-2 to a focused second pass`, and the fix plan's own parked-items list (`id-12/13/14`) tags the underlying "retire/merge `/lean-repo`" question `decision-needed, operator arbitration required`, routed to `/friday-act` or a dedicated session — not scheduled. So the ordering constraint is **not** load-bearing in the sense of blocking an imminent event; nothing forces M-1 to land soon. It **is** correct, cheap, precautionary sequencing: *whenever* M-1 is eventually unparked, it must not fold in the still-broken Q3 lens, and stating that constraint now costs nothing. The CHANGE_DESCRIPTION's "must land BEFORE M-1" framing is accurate as a precondition but overstates urgency — it would be more precise as "must land before M-1 IF/WHEN M-1 is unparked."

## Mitigations

- **(Dimension 5 — concurrent-session exposure, required)** Before editing `.claude/hooks/check-foreign-staging.sh`, check whether the `ai-resources-research-workflow` worktree session (branch `session/2026-07-13-research-workflow`) is still live (e.g., `ls logs/.session-marker-*` for a per-id marker other than this session's own, or ask the operator directly). If it is live, either wait for it to run `/wrap-session` first, or apply the edit as a single atomic `Edit` call and immediately verify the file still parses (`python3 -c "compile(open('.claude/hooks/check-foreign-staging.sh').read().split(\"PYEOF\")[0].split(\"<< 'PYEOF'\")[1], '<hook>', 'exec')"`-style check, or simply re-run the hook manually against a benign test payload) to minimize the window where a malformed intermediate state fails the tripwire open for both sessions.
- **(Dimension 5 — implicit coupling, required)** Add a one-line comment next to the new `"logs/runs/"` entry in `EXEMPT_DIR_PREFIXES` naming the dependency: this exemption is safe only because `logs/scripts/run-manifest.sh` always writes marker-scoped `{date}-{marker}.json` filenames — so the assumption is visible at the change site, not only in this risk-check report.
- **(Dimension 3 — missed consumer, required)** Add `.codex/agents/lean-repo-auditor.toml` to id-55's target-file list and apply the identical Part A (widened scan scope) + Part B (softened verdict language) edit there. Without this, the Codex-harness mirror silently keeps the disproven Q3 test and the enforcement-flavored verdict.
- **(Dimension 3 — mirror hygiene, recommended, non-blocking)** Mirror the exact `"logs/runs/"` allowlist addition into `.codex/hooks/check-foreign-staging.sh` for content parity, even though it is currently unregistered/inert in `.codex/hooks.json` — prevents silent divergence for whenever it is wired.
- **(Dimension 3/answer to (b) — required)** Use the literal string `"logs/runs/"` (trailing slash, directory-prefix form) in `EXEMPT_DIR_PREFIXES` — not `"logs/runs/*.json"` as worded in the change description. Confirm post-edit with both directions of the plan's own validation test (blocks a planted foreign path; passes `logs/runs/<today>-<marker>.json`).
- **(Companion, non-blocking)** Land the log-hygiene follow-ups (flip `logs/improvement-log.md:646`, annotate `audits/lean-repo-2026-07-13.md` § INVESTIGATE) as a separate commit from the structural command/agent/hook edit, so a revert of one does not also revert the other.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, `git worktree list`/`git log` output, empirical reads of `~/.claude/settings.json` and `.codex/hooks.json`, or explicit not-found flags). No training-data fallback was used on fetch/read failures — the `docs/risk-topology.md` path miss was surfaced explicitly rather than silently substituted.
