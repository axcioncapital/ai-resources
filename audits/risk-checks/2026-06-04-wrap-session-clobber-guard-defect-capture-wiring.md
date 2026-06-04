# Risk Check — 2026-06-04

## Change

Two structural command-set edits landing this session.

(Item 1) Fix the /wrap-session Step 3.5 clobber false-negative. Add a NO_OWN_MARKER guard: when CLAUDE_CODE_SESSION_ID is SET but the per-id file logs/.session-marker-${CLAUDE_CODE_SESSION_ID} does NOT exist, this session ran neither /prime task-selection nor /session-start, so it authored zero tracked headers/mandates — force OWN_HEADERS_SUBTRACT=0 and OWN_MANDATES_SUBTRACT=0 and SKIP both the shared-marker loud fallback (reading logs/.session-marker) AND the PRIME_RAN/.prime-mtime path (both are shared mutable state, clobber-vulnerable, and here foreign-owned). Restrict the existing loud fallback-to-shared-marker to the genuine old-CLI case (CLAUDE_CODE_SESSION_ID unset). Net effect: a no-own-marker session correctly claims no ownership, so all added today-content is flagged foreign and the guard STOPs as designed. Fold with the same-block id-14 date-rollover edit. Edit BOTH the canonical ai-resources/.claude/commands/wrap-session.md Step 3.5 MARKER-resolution block AND the workspace-root paired sibling /.claude/commands/wrap-session.md in lockstep (PAIRED CONTRACT), plus a one-line note in ai-resources/docs/session-marker.md documenting the no-own-marker → own-subtract=0 rule.

(Item 2) Build defect-capture wiring (session 2 of the §5.8 defect-capture scaffolding). A new command ai-resources/.claude/commands/log-defect.md (model: sonnet) that prepends one entry to ai-resources/logs/defect-log.md per its HTML-commented schema (most-recent-at-top, em-dash header, classify into one of 7 defect classes, scan for prior same-class entries to set Occurrence 1st/Nth, set Action captured|routed). Plus a gated recurrence-scan step added to ai-resources/.claude/commands/friday-checkup.md that flags any defect class with a 2nd+ occurrence still tagged `captured` — mirrors the existing gate-calibration suppression-check shape that fires monthly+ inside /friday-checkup.

Blast radius note for Item 1: Step 3.5 is consumed by every /wrap-session invocation, plus ~16 project symlinks that consume the canonical ai-resources copy, plus the non-symlink workspace-root copy. The fix is a behavior-narrowing change (it makes a previously-false-negative case correctly STOP) — it does not relax any existing STOP.

Item 4 (.claude/ git-hygiene tracking-model decision) is decision-only this session and is NOT part of this risk-check; its implementation, if structural, re-gates separately.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/log-defect.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-checkup.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/defect-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/defect-to-fix-loop.md — exists

## Verdict

GO

**Summary:** A behavior-narrowing guard fix (Item 1) that only makes a previously-missed STOP fire correctly, plus a well-precedented closure-channel command + gated scan (Item 2) that serves OP-12 rather than adding orphan detection — all six dimensions Low, with the only elevated item the PAIRED-CONTRACT lockstep edit, which is a known, documented two-copy discipline.

## Consumer Inventory

Item 1 touches the canonical `wrap-session.md` Step 3.5 block (consumed by ~17 project symlinks + every `/wrap-session` invocation) and its non-symlink workspace-root paired sibling, plus a doc note in `session-marker.md`. Item 2 adds a brand-new command (`log-defect.md`, zero current consumers) and edits the canonical `friday-checkup.md` (consumed by ~17 project symlinks). The new `NO_OWN_MARKER` contract has no current consumers — it is internal to the Step 3.5 block.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/commands/wrap-session.md (canonical) | co-edits (Step 3.5 block — Item 1 target) | yes |
| /.claude/commands/wrap-session.md (workspace-root, non-symlink sibling) | co-edits (PAIRED CONTRACT lockstep — Item 1 target) | yes |
| ai-resources/docs/session-marker.md | documents (Step 3.5 marker-resolution contract; gets the new one-line rule) | yes |
| ~16 project + harness/kb `wrap-session.md` symlinks → canonical | imports (symlink to canonical; auto-inherit) | no |
| ai-resources/.claude/commands/friday-checkup.md (canonical) | co-edits (Item 2 scan-step target) | yes |
| /.claude/commands/friday-checkup.md (workspace-root) | imports (symlink to canonical — auto-inherits Item 2 edit) | no |
| ~16 project + harness/kb `friday-checkup.md` symlinks → canonical | imports (symlink; auto-inherit Item 2 edit) | no |
| ai-resources/logs/defect-log.md | parses (log-defect prepends per its HTML-commented schema; friday scan reads it) | no |
| ai-resources/docs/defect-to-fix-loop.md | documents (loop doc lines 42–48 name `/log-defect` + the scan step as the deferred wiring this session ships) | no |
| ai-resources/CLAUDE.md (line 10) | documents (names defect-log.md + loop doc; discoverability pointer shipped S7) | no |
| ai-resources/.claude/commands/log-defect.md (new) | (the new target itself — no pre-existing consumers) | n/a (creates) |

Total: 11 distinct consumer rows; 4 must-change (both wrap-session copies, session-marker.md, canonical friday-checkup.md). The ~33 symlinks across the two commands all auto-inherit via the canonical copy and require no edit. `log-defect.md` is `not yet present` — confirmed absent everywhere (grep `find -name log-defect.md` returned nothing); the inventory above covers the contract it introduces (the `defect-log.md` schema it must honor) and its named-but-not-yet-built referents in `defect-to-fix-loop.md`.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Item 1 edits an existing Bash block inside `/wrap-session` Step 3.5 — the block already runs once per wrap; the guard adds a few conditional branches, no new per-session or per-tool-call cost. `/wrap-session` is on-demand, not auto-loaded.
- Item 2's `log-defect.md` is a new optional command — pay-as-used, invoked only when a defect is captured (`docs/defect-to-fix-loop.md` line 11: "Capture (per session) … one line"). No always-load, no hook registration.
- Item 2's friday-checkup scan step adds work only inside `/friday-checkup` (already a heavy on-demand cadence command), and is **gated** to fire monthly+ (mirrors the gate-calibration suppression-check at `friday-checkup.md` line 312, which is `monthly + quarterly only`). No per-session cost.
- Neither item adds content to an always-loaded CLAUDE.md, registers a SessionStart/Stop/PreToolUse hook, or adds an `@import`. The S7 always-loaded pointer (`ai-resources/CLAUDE.md` line 10) already shipped and is out of this change's scope.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` entries are added, removed, or narrowed. The change set is command-body edits + one new command file + one doc note.
- New command `log-defect.md` performs a file prepend to `logs/defect-log.md` — a Write to repo-local shared state already within established patterns (every log-append command, e.g. `/wrap-session`, writes to `logs/`). No new tool family, no shell escalation, no cross-repo or external-API capability.
- No settings-file scope change (project → user) and no `"model"` field touched (Item 2 declares `model: sonnet` in the new command's *frontmatter* — the only permitted tier mechanism per workspace CLAUDE.md § Model Tier; not a settings.json default).

### Dimension 3: Blast Radius
**Risk:** Low

Grounded in the Step 1.5 inventory: 11 consumer rows, 4 must-change.

- **Item 1 contract change is backwards-compatible and STOP-narrowing.** The new `NO_OWN_MARKER` logic only changes behavior in one previously-mishandled case (var SET + per-id file absent), converting a false `FOREIGN=0` (silent clobber) into a correct STOP. CHANGE_DESCRIPTION states it "does not relax any existing STOP" — confirmed against the read: the marker-aware path (canonical lines 108–138) and PRIME_RAN path (lines 139–156) are unchanged for sessions that *do* own a marker; only the no-own-marker branch is rerouted to claim-zero.
- **PAIRED CONTRACT is the one real blast-radius item.** The canonical Step 3.5 block (`wrap-session.md` line 43: "PAIRED CONTRACT — keep in sync") and the workspace-root sibling (Step 1.5, confirmed a non-symlink regular file, 29190 bytes) must be edited in lockstep. CHANGE_DESCRIPTION names both explicitly as in-scope — the contract is honored, not missed.
- **~33 symlinks auto-inherit, zero require edits.** Both `wrap-session.md` (16 project + harness/kb symlinks → canonical) and `friday-checkup.md` (16 symlinks incl. workspace-root → canonical) propagate via the canonical copy. The workspace-root `friday-checkup.md` is a symlink (verified `ls -la`), so the Item 2 scan-step edit auto-propagates with no lockstep needed — unlike `wrap-session.md`, whose workspace-root copy is independent.
- **Item 2 detection signals depend on documented conventions.** The friday scan reads `defect-log.md` per its schema (em-dash header, `Action: captured`, class tags — `defect-log.md` lines 21–41); the scan-step contract mirrors an existing, working pattern (gate-calibration suppression check, `friday-checkup.md` line 312). No new cross-cutting infra.
- No inventory consumer was surfaced that CHANGE_DESCRIPTION failed to anticipate.

### Dimension 4: Reversibility
**Risk:** Low

- Item 1 is a multi-file *edit* across two tracked command files + one doc — clean `git revert` fully restores prior state within the working tree. No data/log mutation, no external push, no automation that fires between landing and revert.
- Item 2's `log-defect.md` is a new tracked file — `git revert` removes it cleanly. The friday-checkup scan step is an in-file edit, cleanly reverted.
- One nuance, still Low: once `log-defect` is *used*, it prepends entries to `logs/defect-log.md` (append-only-style log). Reverting the *command* does not retroactively remove entries already written by it. But (a) those entries are real captured defects worth keeping regardless of the command's existence, and (b) the command landing itself writes nothing to the log — only operator invocation does. The change-as-landed is fully revertible; only downstream *use* leaves log entries, which is expected and benign.

### Dimension 5: Hidden Coupling
**Risk:** Low

- Item 1's only coupling is the **explicitly documented** PAIRED CONTRACT (canonical `wrap-session.md` lines 42–49; sibling lines 21–28) plus the `session-marker.md` § Marker resolution contract (lines 41–61), which CHANGE_DESCRIPTION updates with the new no-own-marker rule. The contract is named at the change site and in the doc — not silent.
- The `NO_OWN_MARKER` logic relies on the `CLAUDE_CODE_SESSION_ID` harness var, an existing dependency already governed in `session-marker.md` §"Harness-var dependency" (lines 65–78) with a re-verify trigger. No new implicit dependency is introduced — the guard reuses the same var the per-id oracle already consumes (canonical line 91).
- Item 2's friday scan does **not** auto-fire in an unexpected context: it is gated (monthly+) and lands inside an existing on-demand command, mirroring a working precedent. No two-mechanism overlap — there is no other system already scanning `defect-log.md` for recurrence (grep confirms `defect-log` is referenced only by the loop doc, CLAUDE.md pointer, and planning/notes files).
- `log-defect.md` must honor the `defect-log.md` schema (a parse contract), which is documented in the log file's own HTML comment (lines 21–41) — the contract is documented at the data site the command writes to.

### Dimension 6: Principle Alignment
**Risk:** Low

Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md` (frozen-ID index, 41 active).

- **OP-12 (closure before detection) — actively served.** Item 2 is the rare change that *advances* OP-12 rather than straining it. `defect-to-fix-loop.md` (lines 7, 42–48) builds the closure channel first; the friday scan surfaces 2nd-occurrence classes specifically to *route them to closure* (rule/eval/example), and the recurrence rule (`defect-log.md` line 38) forces `captured → routed` on recurrence. The scan does not add free-floating detection ahead of a closure path — the closure path (the three routes) already exists in the loop doc. Aligned.
- **OP-9 / AP-7 / DR-7 (no speculative abstraction) — satisfied.** `/log-defect` and the scan step are NOT "hooks for an absent consumer": `defect-to-fix-loop.md` lines 42–48 name *exactly these two artifacts* as the deferred, risk-checked wiring, and `defect-log.md` already exists as the confirmed consumer of the command's writes. The 2nd-confirmed-consumer test is moot — this is the planned build of a designed system, not pre-emptive generalization.
- **OP-5 (advisory vs enforcement) — held.** The friday scan *flags* recurring-captured classes (advises and stops); it routes nothing automatically. `defect-to-fix-loop.md` line 36: "Routing is judgment work — it stays gated, not hooked." No advisory→enforcement upgrade.
- **OP-2 / AP-4 (automate execution, gate judgment) — held.** Capture (`/log-defect`) is mechanical execution (auto); routing the recurrence is judgment and stays operator-gated at the friday cadence. Correct split.
- **OP-3 (loud failure) — Item 1 preserves the loud fallback** for the genuine old-CLI case (var unset) and only suppresses it for the no-own-marker case where the shared marker is foreign-owned — the suppression is the *correct* loud behavior (STOP on foreign content) rather than silent trust of a clobbered marker. Net improvement to OP-3 posture.
- **DR-1 / DR-3 (placement) — correct tiers.** New command in `ai-resources/.claude/commands/` (canonical, DR-1 multi-project — `decisions.md` line 229 records the canonical-home decision); doc note in `ai-resources/docs/`; both consumed via symlink fan-out. Right homes.
- **DR-8 — this very risk-check satisfies the gated-class requirement** (new command + cross-cutting command edits + shared-state automation step). Verdict is being produced as required.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to both `wrap-session.md` copies, `friday-checkup.md` line 312 gate-calibration precedent, `defect-log.md` lines 21–41 schema, `defect-to-fix-loop.md` lines 7/36/42–48, `session-marker.md` lines 41–78; `ls -la` file-type confirmation that workspace-root `wrap-session.md` is a non-symlink and workspace-root `friday-checkup.md` is a symlink; `find` confirming `log-defect.md` is absent everywhere; grep inventory across `ai-resources` and workspace root for `log-defect`, `defect-log`, `NO_OWN_MARKER`, `wrap-session.md`, `friday-checkup.md`; principles-base.md OP-2/OP-3/OP-5/OP-9/OP-12/DR-1/DR-3/DR-7/DR-8/AP-4/AP-7 verbatim). No training-data fallback was used; all referenced files tagged `exists` were read, and the `not yet present` file was evaluated only via CHANGE_DESCRIPTION + the loop doc's stated intent.
