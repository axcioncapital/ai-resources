# Risk Check — 2026-07-17

## Change

Proposed structural change (Option A — SO-endorsed 2026-07-17): de-duplicate the session-marker allocator in `ai-resources/.claude/commands/prime.md`.

WHY: `/prime` loads a 1,009-line command file on every invocation before it can draw the orientation menu; the ~120-line session-marker allocator bash block is inlined THREE times (Step 8a.3.a ~L312–449, Step 8b.3.a ~L486–620, Step 8c.3 ~L672–826). This is a measured model-side load cost (~39k tokens loaded every `/prime`; menu-display path is only ~300 of 1,009 lines) and a maintenance tax the maintainers already pay ("hash-verify all three lockstep copies" per improvement-log 2026-07-13 S6).

CHANGE: Extract the allocator ONCE into a new shared sub-step "8k. Marker allocation (shared sub-step — referenced by 8a/8b/8c)", mirroring the existing "8m. Mission binding (shared sub-step referenced by 8a/8b/8c)" pattern already in this same file. The three branches replace their inline allocator with a one-line reference: "Run the Step 8k marker-allocation sub-step to obtain ${TODAY} and ${MARKER}." Net ~-240 lines.

SCOPE BOUNDARIES (what STAYS per-branch, unchanged — verified against the file this session):
- The shared block covers the pure allocator ONLY: MARKER production (4-source HIGH scan + mkdir atomic-claim mutex + session-id suffix), and the writes of `logs/.session-marker` and `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`.
- STAYS inline in each branch: the `grep -Fxq "## ${TODAY} — Session ${MARKER}"` header-existence check, the header append (branch-specific work-description text), and the `logs/.prime-mtime` write. (SO: header/mtime stay per-branch because their append content differs.)
- 8a's sub-step-a0 cross-repo mission guard and 8c's sub-step-2.5 cross-repo mission guard STAY before the shared call.
- Marker → header → mtime ordering contract preserved in every branch: the shared block ends at MARKER production; header-check/append and mtime run after it returns, exactly as today.
- Control flow unchanged: 8a still pauses for `go`; 8b begins execution immediately; 8c uses its single approval gate. All three allocate exactly once, at the same logical point they do today (no branch re-allocates).

COMPANION EDIT (same commit): update `docs/session-marker.md`'s "Lockstep triplet" registry note (currently instructs editors to "edit all three copies") to point to the single shared 8k block — a stale "edit all three" is the exact failure the doc warns of.

VALIDATION BEFORE COMMIT (intended BLOCKING, per SO): re-run the zsh falsification-harness against the collapsed allocator text — the three shipped-and-caught regressions it must still fail to reproduce: (1) unmatched-glob NOMATCH crash on first-prime-of-day (must use `find`, not a glob); (2) suffix truncation of `S7-a4f` markers leaving HIGH=0; (3) the FAIL-SAFE HIGH-seeding invariant (marker-file seed before any scan; scans only raise HIGH).

DISTRIBUTION/BLAST RADIUS NOTE: prime.md is the canonical command, symlink-distributed to ~23 project repos via the SessionStart auto-sync hook — projects read this one file, so there is a single source of truth (no per-project copies to sync). The allocator is branch-agnostic (references no TASK_TEXT/pick/mission variable), which is why one shared block is claimed strictly safer than three.

PRIOR CONSULT: SO pre-change advisory at `projects/axcion-ai-system-owner/output/consultations/consult-2026-07-17-trim-prime.md` — GO on Option A; declined Option B (move allocator to a doc — new cross-repo hot-path read) and Option C (move comments to decisions.md — A captures it for free); flagged script-extraction as a larger separate `/risk-check`-gated follow-on.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/decisions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/output/consultations/consult-2026-07-17-trim-prime.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The defect (triplicated ~134-line allocator, real load cost, real maintenance tax) is directly observed and its consequence directly traced — this is a genuine, well-scoped, behavior-preserving consolidation with three already-confirmed consumers — but the canonical file's breadth (24 live symlinks + 2 currently-live git worktrees holding independent physical copies + ~10 downstream parsers of its output) and one under-scoped companion-doc edit keep it from a clean GO.

## Consumer Inventory

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/docs/session-marker.md` (§ Marker allocation intro, L67; § Two-end contract registry "Lockstep triplet", L229–231) | documents | yes |
| `ai-resources/.claude/commands/session-start.md` (L51, narrative step-label reference) | documents | no |
| `ai-resources/.claude/commands/session-plan.md` (Step 0 header gate, Step 7 plan write) | parses | no |
| `ai-resources/.claude/commands/contract-check.md` (Step 2b, plan-glob resolution) | parses | no |
| `ai-resources/.claude/commands/drift-check.md` (Steps 3/6/7/8) | parses | no |
| `ai-resources/.claude/commands/wrap-session.md` (canonical, Steps 3.5/6.4/13) | parses + co-edits (marker teardown) | no |
| workspace-root `.claude/commands/wrap-session.md` (paired copy) | parses | no |
| `ai-resources/.claude/commands/open-items.md` (plan-glob scan) | parses | no |
| `ai-resources/.claude/agents/fix-repo-issues-scanner.md` (plan-glob scan) | parses | no |
| `ai-resources/.claude/commands/decide.md` (Step 2, prior-decision read) | parses | no |
| `ai-resources/.claude/commands/concurrent-session-check.md` (Steps 2–3) | parses | no |
| `ai-resources/.claude/hooks/detect-concurrent-session.sh` (SessionStart, liveness signal) | parses | no |
| `ai-resources/.codex/hooks/backup-session-plan.sh` (plan-filename regex) | parses | no |
| `ai-resources/skills/handoff/SKILL.md` (Step C3, marker teardown) | co-edits | no |
| `~/.claude/hooks/cleanup-session-marker.sh` (user-level, unversioned) | parses | no |
| 24 symlinked `prime.md` copies (verified by `find . -name prime.md -type l`: 20 under `projects/*`, plus workspace-root `.claude/commands/`, `harness/`, `knowledge-bases/pe-kb-vault/`, and one archived project — all resolve live to the canonical file) | invokes | no |
| `ai-resources-2` — live git worktree, branch `session/2026-07-17-2`, real (non-symlink) copy of `prime.md`, currently in sync with canonical (1009 lines, has session-id-suffix logic) | co-edits (independent physical copy) | no (will not auto-inherit; needs eventual rebase/merge — not a new burden, but unmentioned in the change's own blast-radius note) |
| `ai-resources-parallel` — live git worktree, branch `session/2026-07-17-parallel`, same state as above | co-edits (independent physical copy) | no (same caveat) |
| 3 stub `prime.md` copies, zero allocator content, 33 lines each (`ai-resources/output/deploy-test-scratch-2026-06-12/`, `ai-resources/workflows/research-workflow/`, `projects/axcion-sector-intelligence/`, its own repo) | documents (inert) | no |
| `ai-resources/docs/{new-project.md, repo-architecture.md, compaction-protocol.md, heavy-read-discipline.md, weekly-cadence.md}` (narrative plan-filename mentions) | documents | no |
| Historical audit/fix-plan files (e.g. `audits/fix-plans/fix-repo-issues-2026-05-28-1902-wave2-commands.md`, referencing "Step 8a.3.a") | documents (append-only historical) | no |

**Total: 21 distinct consumer rows, 1 must-change** (`docs/session-marker.md`). The companion edit named in `CHANGE_DESCRIPTION` covers only the "Lockstep triplet" bullet (L229–231); my own grep of the doc found a **second** stale "three copies... must stay in lockstep" passage at L67 that the description does not name — see Dimension 3.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The change is net token-**negative** on an always-loaded-per-invocation file: `prime.md` is read in full on every `/prime` call (confirmed — my own unbounded `Read` on it truncated at the tool's 25,000-token cap after only 544 of 1009 lines, reporting 39,433 tokens for that first half alone). Removing two of three ~134-line allocator copies is a pure reduction, not an addition.
- No new hook registered (SessionStart/Stop/PreToolUse/UserPromptSubmit), no new `@import`, no new/expanded skill trigger, no subagent brief expansion. The bash commands invoked (`mkdir`, `find`, `grep`, `cat`, `stat`, `echo`) are unchanged — same commands, one call site instead of three.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` entries touched. No new tool-invocation pattern — every Bash primitive used in the shared 8k block already appears verbatim in the three existing inline copies today. No new Write path, no external API, no MCP surface.

### Dimension 3: Blast Radius
**Risk:** High

- Grounded in the Step 1.5 inventory: **21 distinct consumer rows, 1 must-change.** By count alone this exceeds the ">5 dependent callers" High threshold, and `prime.md` is unambiguously "shared infrastructure... that multiple commands or workflows read/write" (`session-start.md`, `session-plan.md`, `wrap-session.md` ×2, `drift-check.md`, `contract-check.md`, `open-items.md`, `fix-repo-issues-scanner.md`, `decide.md`, `concurrent-session-check.md`, `detect-concurrent-session.sh` all key off state `/prime` produces).
- **Calibration precedent, same repo, same day:** `logs/decisions.md` 2026-07-17 (S1-596) records an almost identically-shaped situation — a canonical, widely-referenced change scored "Blast-radius High on breadth alone... 85 consumers, 0 must-change" and still shipped as `PROCEED-WITH-CAUTION`. This risk-check follows that same calibration: breadth drives the level even though the change is behavior-preserving and the must-change count is 1.
- **Gap the CHANGE_DESCRIPTION did not anticipate, found by this inventory:** two git worktrees, `ai-resources-2` (branch `session/2026-07-17-2`) and `ai-resources-parallel` (branch `session/2026-07-17-parallel`), are **live right now**, each holding an independent, non-symlinked, real copy of `prime.md` (verified: `file ai-resources-2/.git` → "ASCII text", i.e. a worktree gitlink, not a directory; both currently 1009 lines and already carrying the session-id-suffix logic, so currently in sync — but they will **not** auto-inherit this commit the way the 24 symlinks do). The change's own "DISTRIBUTION/BLAST RADIUS NOTE" discusses only the symlink topology and does not mention worktrees at all — this is exactly the scenario `docs/session-marker.md` § Known gap already documents and accepts ("refresh (rebase/merge) a long-lived worktree branch before trusting the mutex across it"), so it is not a new risk class, but it is an omission in this change's own blast-radius accounting.
- **Companion-edit under-scope:** the CHANGE_DESCRIPTION names only the "Lockstep triplet" registry bullet in `session-marker.md` (L229–231) as needing an update. Direct grep of the doc found a second passage making the identical stale claim at L67 ("Steps 8a.3.a / 8b.3.a / 8c.3 — three copies of one block... the three `/prime` copies and this section must stay in lockstep") that is not named in the companion-edit scope. If only the named bullet is fixed, the doc still contains one stale "three copies" assertion post-commit.
- Everything else in the inventory (24 symlinks, all read-only auxiliary consumers, the 3 inert stubs) is confirmed **compatible with zero changes needed** — they depend only on the marker files' content/format and the plan-filename glob, none of which this refactor touches.

### Dimension 4: Reversibility
**Risk:** Low

- Pure text edit to two git-tracked files (`prime.md`, `docs/session-marker.md`) in one commit; `git revert` fully restores prior state.
- No sibling files/directories created. No data/log file mutated (`session-notes.md`, `decisions.md`, etc. untouched by this change itself).
- Marker files (`logs/.session-marker`, `logs/.session-marker-*`) are gitignored and not part of the commit; since the refactor is algorithm-preserving, any marker/header written under the new code is indistinguishable in content from what the old code would have produced — no stale-log-entry cleanup is created by landing this change.
- No push, no external-system write, no new automation that could fire unexpectedly between landing and a hypothetical revert.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The marker → header → mtime ordering contract that `/session-start` Step 3 and `/session-plan` Step 0 depend on is **not enforced by the 8k block itself** — it is enforced only by each of the three call sites correctly sequencing "call 8k, then header-check/append, then mtime-write" in that order, exactly as today. This is a real, correctly-identified implicit dependency on discipline-at-three-call-sites rather than a single enforced contract point — the SO consult itself names this as "your critical subtlety" and confirms it is preserved by design, but confirms it is preserved by *convention*, not by structure.
- This does not reach High: the contract is explicitly named and documented at the change site (the SCOPE BOUNDARIES section states the ordering requirement in so many words), and the mandated BLOCKING falsification-harness re-run (per `session-marker.md` § Verification standard) is designed to catch a broken ordering by execution, not merely by review.
- No functional overlap with another mechanism, no unexpected auto-firing — the call trigger conditions for 8k are identical to today's inline invocation conditions.

### Dimension 6: Principle Alignment
**Risk:** Low

- Grounded against `projects/strategic-os/ai-strategy/principles-base.md` (present, read).
- **DR-7 / AP-7 / OP-9 (generalize only on a second confirmed consumer; no speculative abstraction):** squarely satisfied, and in the direction the principle favors, not against it. This is not new speculative infrastructure — it is a consolidation of a block with **three already-existing, already-live consumers** (8a, 8b, 8c each currently inline the identical logic today). DR-7's bar ("a second confirmed consumer") is not merely met but exceeded (3, not 2), and the change collapses duplication rather than adding an unconsumed generalization.
- **DR-1 / DR-3 (placement):** correct tier and home — stays inside the existing canonical command file (`ai-resources/.claude/commands/prime.md`), mirrors an established in-file pattern ("8m. Mission binding (shared sub-step...)") rather than inventing a new artifact type. No new file, directory, command, or agent is created, so the `docs/ai-resource-creation.md` rule #7 complexity-budget gate (a test for *new components*) does not apply here.
- **OP-12 (closure before detection):** not implicated — no new detection/scan/audit is added.
- **OP-5 (advisory vs enforcement):** not implicated — no automation crosses from advisory to enforcing.
- **OP-2 / OP-10 / OP-11:** not implicated — no judgment automated that should stay gated, no cross-tool boundary crossed, no principle being revised.

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed, not merely asserted.** I independently located all three allocator copies by grepping the fence markers in `prime.md` myself: bash block 1 = lines 314–449, block 2 = lines 486–621, block 3 = lines 674–809 — each exactly 134 content lines (fence-to-fence), differing only in surrounding markdown indentation (confirmed by direct inspection, matching the SO consult's own Trap #1 note). The triplication is real and I read it directly, not on the strength of the description's citation.
- **Consequence — traced/reproduced, not merely plausible-looking.** The claimed load cost is not just asserted: my own unbounded `Read` of `prime.md` (before any deduplication) was truncated by the tool's own 25,000-token cap after only 544 of 1009 lines, with the tool reporting **39,433 tokens for that first half alone** — i.e., the file's real full-load cost is *higher* than the description's own "~39k tokens" figure (extrapolating the same byte-to-token ratio across the remaining 465 lines yields roughly 65,000–70,000 tokens total). This is the consequence directly reproducing itself in the course of this very risk-check, not an inference from a quoted line. The maintenance-tax claim ("hash-verify all three lockstep copies") is separately confirmed verbatim in `logs/improvement-log.md` (2026-07-13 S6 entry: "...hash-verified all three lockstep copies").
- **Re-derivation vs. the change description:** several minor figures do not match my own re-derivation exactly, and all cut in the direction of *understating* rather than fabricating the problem — none contradict the core claim: (1) allocator block is 134 content lines per copy, not "~120"; (2) the 8c line range cited (`~672–826`) extends past the pure allocator's actual close (line 809) into the header-check/mtime code, an internal inconsistency versus the 8a/8b citations which stop at the pure-allocator fence — cosmetic, does not change the SCOPE BOUNDARIES text, which is separately explicit and correct; (3) total token cost is closer to ~65–70k than the stated "~39k"; (4) symlink count is 24, not "~23" (in-tolerance). None of these discrepancies weakens the case for the change — if anything the real cost is higher than claimed.
- The three validation-harness regressions named in "VALIDATION BEFORE COMMIT" (glob NOMATCH crash, suffix-truncation destructive regression, FAIL-SAFE HIGH-seeding invariant) are each independently confirmed present, verbatim, in `prime.md`'s own inline comments and in `docs/session-marker.md`'s corresponding sections — these are not invented citations.

## Mitigations

- **Dimension 3 (Blast Radius, High):** Before committing, grep `docs/session-marker.md` for every occurrence of "three cop*" / "lockstep" / "triplicat*" (not just the named "Lockstep triplet" bullet) and update all of them — specifically the § Marker allocation intro passage at L67 in addition to the § Two-end contract registry bullet at L229–231 — so the doc contains zero stale "edit all three" claims post-commit.
- **Dimension 3 (Blast Radius, High):** Note explicitly in the commit message or session-notes wrap that `ai-resources-2` (branch `session/2026-07-17-2`) and `ai-resources-parallel` (branch `session/2026-07-17-parallel`) are live worktrees holding independent physical copies of `prime.md` that will not auto-inherit this change until rebased/merged — expected per the documented "Known gap" protocol, but should be stated so it is not mistaken for an oversight if either worktree's `/prime` still shows the triplicated block after this commit lands.
- **Dimension 5 (Hidden Coupling, Medium):** Add a one-line contract statement inside the new 8k sub-step body itself (mirroring how 8m documents its own "Wiring" contract inline) — e.g. "8k produces `MARKER` only; the caller must run header-check/append and the `.prime-mtime` write itself, immediately after, in that order" — so the ordering requirement is visible to a future editor reading 8k in isolation, not only to someone who read this change's design rationale.
- **Precondition already in the plan, restated as a hard gate:** land the change only after the BLOCKING zsh falsification-harness re-run against the collapsed allocator text passes all points in `docs/session-marker.md` § Verification standard (12/12), executed against the text as it exists in `prime.md` after the edit — never against a draft.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
