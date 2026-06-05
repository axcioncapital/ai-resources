# Risk Check — 2026-06-05

## Change

Execute the /fix-repo-issues 2026-06-05 4-item fix plan. Three of four items edit shared harness command/skill files: (2) wrap-session.md Step 3.5 — anchor the FOREIGN-count to this session's own resolved MARKER so auto-mode chained tasks and same-session work are not misflagged as foreign concurrent writes, while preserving genuine different-marker concurrent-session detection; (3) prime.md Step 7 — add a classifier branch so `N auto` (e.g. `2 auto`) is treated identically to `auto N` instead of silently parsed as a bare-number selection that skips auto-mode; (4) clarify.md preamble — add a marker-trio init step so a /clarify session started without prior /prime does not write markerless entries to session-notes.md. Item 1 is log-hygiene only (add **Verified:** fields to 3 applied improvement-log entries) — zero structural risk. Plan: logs/session-plan-2026-06-05-S15.md. Each command/skill edit is QC'd per item.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/clarify.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-plan-2026-06-05-S15.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Three localized, additive harness edits on the hot session-start/end path — each individually low-to-medium risk — but item 2 (wrap Step 3.5) touches a contract-bearing, multi-branch concurrent-session detector with a paired sibling, and item 4 (clarify marker-init) introduces a new writer onto a BLOCKING shared-marker invariant, so the bundle clears GO only with the paired mitigations below.

## Consumer Inventory

The three edits touch two distinct contracts: (A) the **session-marker / `.prime-mtime` writer-reader contract** (items 2 and 4) and (B) the **prime auto-mode input classifier** (item 3, an internal handoff to Step 8c — no external parsers). Rows below are the contract consumers, not the ~99 prose mentions of "wrap-session" (most are doc/runbook references that name the command but do not parse its Step 3.5 internals).

| Consumer path | Reference type | Must change? |
|---|---|---|
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md | co-edits | no (see finding) |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md | parses | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/detect-concurrent-session.sh | parses | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md | documents | yes (item 4) |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md | co-edits | yes (item 3 self) |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/contract-check.md | parses | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/drift-check.md | parses | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/backup-session-plan.sh | parses | no |

Total: 8 consumers, 2 must-change (prime.md is the item-3 edit target itself; session-marker.md should be co-updated for item 4 — see Hidden Coupling). Notes:

- **wrap-session.md (workspace-root, item-2 sibling).** The fix plan (item 2, plan line 49 and source-plan line 49) says the workspace-root mirror was confirmed **MISSING** and treats item 2 as a single-file edit. Direct read of `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md` line 19–98 shows it **DOES exist and DOES carry a Step 1.5 "Foreign-session pre-write guard"** with the same marker-aware attribution logic and an explicit `PAIRED CONTRACT` block naming the canonical Step 3.5 as its sibling. This is a blast-radius gap not anticipated by CHANGE_DESCRIPTION — see Blast Radius and Hidden Coupling.
- **prime classifier (item 3).** Grep for `auto N` / `N auto` consumers (`prime.md` lines 160, 171–175, 274–275) confirms the only consumer of the classifier outcome is prime's own Step 8c. No external command parses the `auto N` shape. The classifier is an internal routing decision; an isolated change.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded content added. The three targets are slash-command files loaded only on `/wrap-session`, `/prime`, `/clarify` invocation — pay-as-used, not per-turn. Workspace and repo `CLAUDE.md` are unchanged by this plan (plan §Source Material lists only command files + logs).
- No new hook registered. The edits modify existing command bodies; no SessionStart/Stop/PreToolUse/UserPromptSubmit hook is added (plan §Findings items 2–4 are command-body edits only).
- Item 3 adds one classifier branch + an inline comment (~2–4 lines) to `prime.md` (already ~480 lines, loaded only at `/prime`). Item 4 adds a preamble marker-init block to `clarify.md` (17 lines today, line 1–17) — a one-time read at `/clarify`. Negligible per-invocation delta on already-on-demand files.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings change. The plan touches no `.claude/settings.json` / `settings.local.json`; no `allow`/`ask`/`deny` entry is added or narrowed (plan §Source Material and §Findings name only command + log files).
- Item 4's new clarify writes (`logs/.session-marker`, `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`, a `session-notes.md` header append, `logs/.prime-mtime`) target the same `logs/` paths `/prime` already writes (prime.md lines 196–198, 214–216) — within established write patterns; no new tool family or path category authorized.
- No shell/external/cross-repo capability introduced. All three edits stay inside the ai-resources working tree.

### Dimension 3: Blast Radius
**Risk:** Medium

- Inventory: 8 contract consumers, 2 must-change. The two must-change are the prime.md edit target itself (item 3, self-contained) and `docs/session-marker.md` (item 4 should append `/clarify` to the writer roster — see Hidden Coupling).
- **Item 2 (wrap Step 3.5) is the blast-radius driver.** The FOREIGN detector is a ~240-line multi-branch contract (wrap-session.md lines 40–343) with marker-aware / NO_OWN_MARKER / clobber-safe-recovery / PRIME_RAN-fallback paths feeding `OWN_HEADERS_SUBTRACT` / `OWN_MANDATES_SUBTRACT` and a CONCURRENT/REMNANT/MIXED/UNKNOWN classifier. CHANGE_DESCRIPTION frames item 2 as "anchor the FOREIGN-count to this session's own resolved MARKER" — but the canonical Step 3.5 **already does marker-aware own-subtraction** (lines 168–197: it resolves MARKER from the per-id oracle and counts own marker-bearing headers/mandates, explicitly "handles auto-mode N-task chains where /prime Step 8c.3 fires N times"). A re-anchoring edit risks colliding with the existing marker-aware path; the executing session must confirm the precise gap before editing, or it may re-solve a solved sub-problem and regress the existing branches.
- **Sibling-mirror gap (unanticipated consumer).** CHANGE_DESCRIPTION and the fix plan assert the workspace-root mirror is MISSING; the file exists with the paired guard (workspace `wrap-session.md` lines 19–98, `PAIRED CONTRACT` at line 23). If item 2 edits only the canonical copy on that stale premise, the two paired copies drift — the exact failure the `PAIRED CONTRACT` block warns against.
- Item 3 contract change is backwards-compatible: the new `^[1-6]\s+auto$` branch is added *before* the bare-number check (plan line 30), reclassifying input that currently silently mis-routes; no existing valid input shape is reinterpreted (QC scope explicitly: "confirm the new branch does not shadow existing valid classifier paths").
- Item 4 touches shared infra (`session-notes.md` header convention + the marker trio) read by `session-start.md` Step 0.5, `detect-concurrent-session.sh`, and wrap Step 3.5 — but additively (a new caller of an existing writer pattern), and only fires when no marker exists.

### Dimension 4: Reversibility
**Risk:** Low

- All three edits are localized command-file changes; `git revert` of each per-item commit fully restores prior command behavior (plan §Risk line 54: "all edits are localized command-file changes, revertable per commit"; commit-per-item batching at plan line 40).
- No data/log mutation that revert leaves stale **for the command edits**. Item 1 (improvement-log `**Verified:**` fields) is an append/edit to a log, but it is log-hygiene the plan explicitly intends to keep; reverting it is clean text removal, not propagated state.
- No push beyond local repo at edit time (workspace push is gated/batched at wrap). No external write, no automation that fires between landing and revert — the edited commands only run when explicitly invoked.
- Minor: item 4, once live, will cause `/clarify` to write marker files on first post-fix invocation; reverting the command stops future writes but a one-time `.session-marker`/header already written persists. This is the same benign residue any marker writer leaves and is not a rollback blocker — kept at Low.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Item 4 onto the BLOCKING both-or-neither invariant.** `docs/session-marker.md` line 39–41 declares: "Any marker-setup path MUST write the shared file AND the per-id identity oracle together — never one alone … BLOCKING." Adding `/clarify` as a fourth marker-writer creates an implicit dependency: clarify's new init must write BOTH `logs/.session-marker` and `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}` atomically, else it manufactures exactly the partial-setup state wrap Step 3.5's clobber-safe-recovery block (lines 122–166) was built to paper over. The fix-plan spec (source-plan lines 70–72) does list both files plus the header plus `.prime-mtime`, so the intent is invariant-compliant — but the coupling is silent unless `session-marker.md`'s consumer roster is updated to name `/clarify`.
- **Item 4 marker-counter coupling.** Clarify's init must reuse prime's exact `S{N}` increment idiom (prime.md lines 188–203) or a `/clarify`-then-`/prime` sequence could double-increment or collide the counter. QC scope (plan line 33) names "no double-create when /clarify runs after /prime" — the coupling is recognized but lives entirely in correct reuse of an undocumented-at-clarify convention.
- **Item 2 PAIRED CONTRACT coupling.** The canonical and workspace-root Step 3.5 copies are a hand-synced pair (not a symlink), each with a `PAIRED CONTRACT` block instructing "keep in sync." Editing one silently obligates the other; the stale "mirror MISSING" premise means this coupling is currently unhonored in the plan.
- Item 3 is self-contained: the classifier branch couples only to prime's own Step 8c, which already accepts `auto N` (prime.md line 274). No hidden contract.

### Dimension 6: Principle Alignment
**Risk:** Low

- principles-base read at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/ai-strategy/principles-base.md` (frozen-ID set, lines 27–60, 85).
- **OP-12 (closure before detection) — served, not violated.** All three items *close* logged friction findings (id-05, marketing id-02, research-pe id-09) rather than adding new detection. No new scan/audit/flag is introduced. This counts *for* the change (line 50: "new detection that does not close findings counts against a candidate").
- **OP-9 / AP-7 / DR-7 (speculative abstraction) — not triggered.** Each edit has a confirmed current consumer: item 2 fixes a real false-positive logged 2026-05-28; item 3 fixes a bug this very session hit (`2 auto`, plan line 30); item 4 fixes a markerless-write logged 2026-06-05. No "hooks for Phase 2," no absent-consumer generalization (lines 47, 60).
- **OP-5 (advisory vs enforcement) — unchanged.** Item 2 keeps wrap Step 3.5 an advisory STOP-and-ask guard (it already "will NOT proceed automatically," wrap-session.md lines 307/322/335); the edit narrows a false-positive, it does not upgrade the guard to auto-act. No advisory→enforcement drift.
- **DR-1 / DR-3 (placement) — correct.** All edits land in `ai-resources/.claude/commands/` (canonical command tier) — the right home for shared harness commands (lines 54, 56). No misplacement.
- No principle is revised, so OP-11/OP-3 loud-revision obligation does not arise.

## Mitigations

- **Item 2 (Blast Radius + Hidden Coupling):** Before editing wrap Step 3.5, re-read lines 168–197 of the canonical file and confirm the *precise* residual gap versus the already-present marker-aware own-subtraction — do not re-implement marker resolution that already exists; scope the edit to the specific mis-count. Run the per-item `/qc-pass` with the plan's stated scope ("confirm legitimate concurrent-session (different-marker) detection is preserved") AND add a check that the CONCURRENT/REMNANT/MIXED classifier branches are unaffected.
- **Item 2 sibling (Blast Radius):** Re-verify the workspace-root `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md` Step 1.5 by direct Read before concluding it is MISSING — it currently exists with the paired guard. If the same logical fix applies there, edit both copies in the same batch per their `PAIRED CONTRACT` blocks; if it genuinely does not apply, record why in the commit/plan so the next session does not re-discover the divergence.
- **Item 4 (Hidden Coupling):** Confirm the new `/clarify` marker-init writes the shared `.session-marker` AND the per-id `.session-marker-${CLAUDE_CODE_SESSION_ID}` together (both-or-neither BLOCKING invariant, session-marker.md line 39), reusing prime.md's `S{N}` increment idiom verbatim. Update `docs/session-marker.md`'s writer roster to name `/clarify` so the coupling is documented, not silent. QC per the plan's "no double-create when /clarify runs after /prime" scope.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to wrap-session.md, prime.md, clarify.md, session-marker.md, the fix plan, and the session plan; grep counts for the consumer inventory; principle IDs quoted from principles-base.md). No training-data fallback was used on fetch/read failures. The one factual correction surfaced (workspace-root wrap-session sibling exists despite the plan's "MISSING" premise) is grounded in a direct Read of that file.

## Architectural Commentary

_System-owner second opinion (Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION. `/consult` was blocked for model-invocation; the `system-owner` agent (which `/consult` wraps) was spawned directly. Full advisory on disk: projects/axcion-ai-system-owner/output/consultations/consult-2026-06-05-risk-check-second-opinion-fix-repo-issues-4-item.md_

**Concur — with one item split.** Concurs with PROCEED-WITH-CAUTION, and the reviewer's three mitigations are the right path (tighter than the plan they correct). But the verdict should not run flat across all four items — architectural weight is concentrated entirely in Item 2.

**Routing:** All four edit existing canonical commands + the workspace-root sibling — right homes, no new components. Change class is "canonical command edit" (all-projects blast radius).

**Mitigations:**
- (b) lockstep edit of both `wrap-session` copies is **load-bearing, not advisory** — the plan's wrong "MISSING" path would have drifted the pair; highest-probability regression, neutralized by the mitigation.
- (c) both-or-neither marker-trio invariant (Item 4) is the correct structural shape. Added check: confirm `/session-start` Step 0.5 reads a `/clarify`-written marker identically to a `/prime`-written one (does the reader branch on writer identity?).

**Missed risk — defer Item 2.** The detector already has marker-aware own-subtraction (lines 168–197), making the plan's false-positive premise suspect. Editing a High load-bearing two-end contract (the `.prime-mtime` marker) on a doubtful premise inverts ROI: low upside, real downside (silent degradation of foreign-session detection is worse than the false-positive it targets).

**Recommended disposition:**
1. Land Items 1, 3, 4 now under (b)/(c) + QC.
2. Run mitigation (a)'s QC **as a diagnosis first, not a gate**: does the existing marker-aware logic already prevent the chained-task false-positive? If yes → close Item 2, do not edit. If a genuine gap remains → write a one-paragraph re-diagnosis naming the exact uncovered case, then edit in lockstep per (b). Either way Item 2 does not land on the original suspect premise.
