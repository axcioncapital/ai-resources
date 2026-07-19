# Risk Check — 2026-07-18

## Change

Plan-time gate. Edit `ai-resources/.claude/commands/mission.md` (existing command, 86 lines) in two ways:

(1) MODIFY the `check` verb (Step 5, items 17–21) so that before flipping a thread's checkbox it (a) prints the mission's `## Validation contract` acceptance assertions, and (b) requires a cited `--evidence` argument — a command that was run, or a `file:line` — which it records alongside the tick. Without evidence it declines to write. The subsystem is advisory ("Nothing here blocks a session", mission.md:14), so the decline is a refusal-to-write plus a message, not a session block.

(2) ADD an `update <id>` verb that revises the `## Open threads` section under a guard: read the frozen sections (`## Goal`, `## In scope / Out of scope`, `## Validation contract`) before and after, and refuse the write unless they are byte-identical. This replaces the unsanctioned hand-edit that the design contract at `mission.md:12` forbids and which has now been done twice (repo-health-backlog-2026-07 S10-163 repopulation; research-workflow-deploy-fitness S10 revision).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/mission.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/repo-health-backlog-2026-07.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/research-workflow-deploy-fitness.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/promote-rw-canonical.md — exists (closed-mission stub, no `status:` line — see Consumer Inventory correction)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/drift-check.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/mission-contract.md — exists (verified by `ls`; the referenced-file list marked its existence "not verified by caller" — re-derived here: it is present, 2235 bytes)

## Verdict

RECONSIDER

**Summary:** The `update <id>` verb is well-justified (a real, twice-manifested defect, and DR-7's "second confirmed consumer" bar is cleanly met), but the `--evidence` requirement on `check` is a presence-only, unverified field that the change description itself argues is "not a gate" — an adversarial read shows it is functionally the same rubber-stamp checklist the mission's own non-negotiable (line 63) and thread 12 explicitly forbid, and the change does not loudly acknowledge this as a deliberate exception.

## Consumer Inventory

Search method: `command grep -rln "logs/missions"` across `.claude/commands`, `.claude/agents`, `docs`; `find -name mission.md -path "*/commands/*"` with per-hit `[ -L ]` symlink test (not `[ -f ]`, which cannot distinguish); direct reads of `prime.md`, `drift-check.md`, `session-marker.md`, `repo-architecture.md`, `mission-contract.md`. All caller-supplied inventory items were spot-checked and confirmed exact (see Dimension 7).

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/prime.md` (Step 1d) | parses (`status: active`, `## Open threads` unchecked lines) | no |
| `ai-resources/.claude/commands/drift-check.md` (Step 7a) | parses (`## Goal`, `## In scope / Out of scope`, `## Validation contract`) | no |
| `ai-resources/docs/session-marker.md` | documents (writer/reader contract for `logs/missions/`) | no |
| `ai-resources/docs/repo-architecture.md` | documents (mission-contract file description; already slightly stale — names only "create/close" as writers, omitting the already-shipped `check`) | no |
| `ai-resources/templates/mission-contract.md` | documents (section-name/shape source the `check`/`update` verbs read against) | no |
| 18 symlink consumers (`projects/*/.claude/commands/mission.md`, `knowledge-bases/pe-kb-vault/...`, incl. one `.backup-untracked` copy) | invokes | no (single real file; symlinks auto-resolve) |
| `ai-resources/logs/missions/repo-health-backlog-2026-07.md` (thread 12, its own filed remedy) | co-edits (direct beneficiary/trigger of the change) | no |
| `ai-resources/logs/missions/research-workflow-deploy-fitness.md` (S10 hand-edit precedent) | co-edits (second cited precedent for the `update` verb) | no |

Total: 25 consumers (18 symlinks + 7 named files), 0 must-change. No consumer requires modification to keep working — the file-format contract (frontmatter + `##` sections) is unchanged; only the `check` verb's *invocation* contract (a new required `--evidence` argument) changes, and no automated caller invokes `check` programmatically — only the operator does, by hand. That is a behavior-breaking change to today's usage pattern even though it breaks no dependent file.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- `/mission check` and `/mission update` are invoked on demand only — pay-as-used, not always-loaded. `mission.md` is a command file, not a CLAUDE.md or hook.
- No `@import`, no new SessionStart/PreToolUse hook, no skill trigger-keyword expansion.
- Printing the Validation contract's acceptance assertions (part 1a) adds output tokens only on invocation, not per session.

### Dimension 2: Permissions Surface
**Risk:** Low

- `mission.md:5` frontmatter already declares `allowed-tools: Bash, Read, Write, Edit` — the change stays within these; `update` reuses Read/Write/Edit against the same file class the command already targets. No new tool family, no widened glob, no external API.

### Dimension 3: Blast Radius
**Risk:** Medium

- Per the Consumer Inventory: 25 consumers found, 0 must-change — this alone would read Low.
- Scored Medium because the inventory surfaces a real (if narrow) contract change: `mission.md:71` currently states, as an explicit invariant of the `check` verb, "Change nothing else — not the thread's text, not its ordering, not any other line in the file." The proposed `--evidence` recording ("alongside the tick") requires revising this exact sentence — a documented invariant is being loosened, not merely extended.
- `repo-architecture.md:228` already undercounts the mission file's writers ("`/mission` (create/close) — never written from inside a session") — omitting the already-shipped `check` verb. Adding `update` widens this doc gap further; not a functional break, but a doc-drift finding this change should close in passing since it touches the same subsystem.

### Dimension 4: Reversibility
**Risk:** Medium

- `git revert` on `mission.md` alone cleanly restores the command's prior behavior.
- But once `check --evidence` / `update` are used operationally, they write into **data files** (`logs/missions/*.md`) — evidence citations recorded alongside ticks, and revised `## Open threads` sections. A revert of `mission.md` does not retroactively undo those data mutations; cleanup would require a second, manual pass over any mission files touched in the interim. This matches the "log/data-file mutation that a code revert doesn't reach" pattern.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Undocumented new contract.** The change description does not specify the exact format for "records it alongside the tick" — inline suffix on the checkbox line, a separate note beneath it, or a new field. `/prime` Step 5 (prime.md) truncates thread text to ~80 chars for menu display and Step 1d scans only unchecked `- [ ]` lines — ticked lines carrying appended evidence text are invisible to `/prime`'s current logic, so no functional break, but the format is genuinely undefined at the point this risk-check is run, which is exactly the "new contract not documented at the change site" pattern.
- **New invariant.** The `update` guard ("read the frozen sections before and after… refuse unless byte-identical") is a sound mechanism but introduces an implicit dependency on the Edit tool never perturbing bytes outside `## Open threads` (trailing whitespace, line endings) — not previously a constraint the command had to satisfy.
- **Functional-overlap risk, not confirmed but worth naming.** Part (1a) prints the Validation contract's acceptance assertions; this duplicates a read `/drift-check` Step 7a already performs against the same section (docs/session-marker.md:290 identifies `drift-check.md` Step 7a as the sole *load-bearing* reader of `## Validation contract`). The duplication is benign (both are pure reads) but is a second consumer of the same section with no shared helper — noted, not scored as a violation.

### Dimension 6: Principle Alignment
**Risk:** High

Grounded against `projects/strategic-os/ai-strategy/principles-base.md` (read; principles-base was available) and the mission's own stated non-negotiable (`repo-health-backlog-2026-07.md:63`): *"No new gate to solve a discipline problem… the countermeasure that has worked here is an adversary told to distrust the author, not another checklist."*

- **The `update <id>` verb is well-aligned (DR-7 satisfied).** Generalization here is licensed by an already-manifested need, not a speculative one: the hand-edit happened twice, both instances independently confirmed by direct read — `repo-health-backlog-2026-07.md:87-91` ("⚠ This repopulation was hand-written, which the contract at `mission.md:12` does not sanction… second time that gap has forced a direct write") and `research-workflow-deploy-fitness.md:11-18` ("REVISED in S10… `/mission` exposes create | list | read | close and NO update verb, so this revision was written directly. That gap is logged"). No speculative-abstraction concern (OP-9 / AP-7 / DR-7) here.
- **The `--evidence` requirement is a High violation, tested adversarially per the dispatch's Question 1.** The change description's own defense — "a required argument is argument validation, not a gate — same shape as the existing item 17" (citing `mission.md:61-64`, a citation independently confirmed accurate) — is the canonical failure pattern this framework warns about: a **true citation carrying an invalid consequence**. Item 17's `<thread-substring>` argument is load-bearing to the mechanism itself — its *value* determines which specific line gets mutated (case-insensitive substring match), and a wrong value produces a benign, informative abort. The proposed `--evidence` argument is not load-bearing in that sense: nothing in the change description re-runs the cited command or re-opens the cited `file:line` to confirm it says what is claimed — it is recorded verbatim. That is presence-only, format-only validation (does the string look like a command or a `file:line`), which is functionally indistinguishable from "a field an author fills in with whatever satisfies the parser" — the caller's own hypothesis, confirmed correct on inspection.
- **This maps to AP-4 (rubber-stamp approvals — gate genuine judgment only) and OP-5 (advisory automation ≠ enforcement automation — enforcement authority is an explicit per-component decision, not a silent upgrade).** An unverified `--evidence` field is a rubber-stamp confirmation dressed as a genuine gate.
- **Material, not hypothetical — grounded in repo history.** The "inert safeguard" class carries 6+ logged instances in this repo (`logs/improvement-log.md:43-47`, `:1001-1002`; `logs/decisions.md:76`, `:114`; `logs/session-notes.md:446`) — guards that look installed and verify nothing. An unverified evidence-citation field is a strong candidate for a 7th instance: an author under time pressure can type a plausible-looking `--evidence "grep -c foo bar # 3 hits"` without ever running it, and the gate accepts it exactly as designed.
- **Not loudly acknowledged (OP-11 test fails).** The change description does not present `--evidence` as a deliberate, recorded exception to the non-negotiable — it argues the opposite, that the requirement *complies* with the non-negotiable by analogy to item 17. Per the framework's own rule: a High here that does not loudly acknowledge the revision forces RECONSIDER, not a mitigated PROCEED-WITH-CAUTION.

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed, not asserted.** Both defects the change fixes are independently re-derived from primary sources, not taken on the caller's word:
  - `check` never reads `## Validation contract` — confirmed by direct read of `mission.md` Step 5 (items 17–21): only `## Open threads` is read (item 19, "from that heading up to the next `## ` heading or EOF"); no read of the Validation contract section appears anywhere in the verb.
  - No `update` verb exists today — confirmed by direct read of `mission.md:27` (`ACTION` = `create | list | read | check | close`) and `:28` (abort on anything else).
  - The "done twice" hand-edit claim is independently confirmed from both cited files' own text, not from the change description: `repo-health-backlog-2026-07.md:87-91` and `research-workflow-deploy-fitness.md:11-18`, both quoted above under Dimension 6.
- **Consequence — traced, not assumed.** The claimed consequence (a false tick already produced) is not hypothetical — it is documented and independently verifiable inside the same mission file: `repo-health-backlog-2026-07.md:140` states threads 1 and 2 are ticked while the acceptance assertion they exist to satisfy ("`/prime` Step 3 scan returns under 40 lines," line 54) is unmet; the same file's own thread 15 (still open) states "Measured live: 222 lines / 47,753 chars" — a directly re-checkable, already-realized failure, not an inferred one.
- **Re-derivation vs. the change description:** None — every load-bearing count and claim was independently re-derived and matched exactly:
  - `mission.md` real-file/symlink count: re-derived via `find … -path "*/commands/*"` + per-hit `[ -L ]` test → 19 total, 18 symlinks, 1 real. Matches.
  - `logs/missions` referencing files: re-derived via `command grep -rln` → `mission.md`, `drift-check.md`, `prime.md`, `session-marker.md`, `repo-architecture.md`. Matches exactly (5 files).
  - Five mission files, four `status: active`: re-derived via `find` + per-file `command grep -n "^status:"` → `promote-rw-canonical.md` (no status line, confirmed — it is a closed-mission stub explicitly marked `<!-- MOVED: this mission is closed -->`), `repo-health-backlog-2026-07.md` (active), `research-workflow-deploy-fitness.md` (active), `axcion-industry-focus.md` (active), `book-summary-system.md` (active). Matches exactly. (A sixth mission-adjacent file, `settings-path-portability/patrik-heads-up.md`, is nested one directory deeper and is not itself a mission contract — an already-closed heads-up note — and is correctly outside both `/prime`'s single-level glob and the caller's count.)
  - Assertion-mapping absence (Question 2a): re-derived via `command grep -nE "^- \[[ x]\].*[Aa]ssertion"` across all 5 mission files → only incidental hits inside the acceptance-assertion checkboxes' own prose (`repo-health-backlog-2026-07.md:55,59`) and thread 12's own descriptive text (`:140`) — no structured thread→assertion field exists in any file. **Confirmed, not refuted:** the mapping thread 12's filed remedy presupposes has never existed.
  - Checkbox-collision / read-scope separation: confirmed `## Validation contract` acceptance assertions are themselves `- [ ]` items (both live mission files and `templates/mission-contract.md:34-35`), and confirmed `check` item 19 scopes its read to `## Open threads` only — the separation the caller flagged as something the change must preserve is real and load-bearing.
- **On Question 2b/2c (substitution adequacy):** the substitution (evidence-citation in place of an assertion-mapping) is real and the mapping it presupposes is genuinely absent — this is a design-adequacy judgment, addressed under Dimension 6 rather than re-litigated here, since the underlying defect and consequence are both confirmed real regardless of which remedy is chosen.

## Recommended redesign

Dimension 6's High is the forcing dimension (unacknowledged, unmitigatable principle violation) — the `update <id>` verb needs no rework, but the `--evidence` requirement does. Two paths, per the framework's own Dimension-6 handling:

- **Rescope (preferred).** Make the `--evidence` argument load-bearing rather than presence-only: require it to name *which* printed acceptance assertion the evidence addresses (e.g. `--evidence "assertion 3: <command + output>"`), and have `check` echo that specific assertion's text back in the confirmation line so the operator visually connects citation to claim. This is materially cheaper than the rejected 5-file-plus-template schema change (Question 2c) — it needs no new frontmatter field, just a required sub-token in the existing argument — while it actually engages thread 12's filed remedy ("refuse-or-warn when the named assertion is unmet") instead of substituting a free-text field for it.
- **Or make the revision loud (OP-11).** If a free-text, unverified `--evidence` field is kept as-is, record it explicitly as a deliberate, bounded exception in `logs/decisions.md` — stating plainly that the field is presence-only and does not verify truth, why full verification was judged out of scope for this command, and that this is a conscious trade-off against the mission's own non-negotiable rather than an unexamined "argument validation" claim. That converts the finding from an unacknowledged violation (High, forces RECONSIDER) to an acknowledged, bounded exception (Medium at worst).

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
