# Risk Check — 2026-06-09

## Change

PLAN-TIME gate for the Mission Contracts subsystem build. Proposed change set:
(1) NEW command ai-resources/.claude/commands/mission.md (create/list/read/close lifecycle; sonnet; auto-symlinked into all projects).
(2) NEW template ai-resources/templates/mission-contract.md + register in templates/README.md.
(3) NEW per-repo state artifact logs/missions/<id>.md (frozen frontmatter: mission_id/mission_name/status/started + mutable sections "Sessions served" and "Open threads"); archive to logs/missions/archive/ on close.
(4) EDIT prime.md: extend the EXISTING Step 1a multi-repo enumeration to also scan each enumerated repo's logs/missions/*.md for status:active. ZERO-COST no-op when none exist (no prompt, no menu change). When ≥1 active mission exists: prepend [mission:<id>] menu items, emit a conditional one-line binding prompt, pass {mission:<id>} arg prefix to /session-start, plus a static one-line "/mission create" tip when a carryover task is bound to no mission.
(5) EDIT session-start.md: strip a leading {mission:<id>} arg prefix, add a "**Mission:**" echo line to the mandate confirmation, append "- Mission: <id>" bullet to the session-notes.md mandate block (same OPTIONAL slot as the existing "Allowed inputs" bullet), AND append a "Sessions served" line into the bound logs/missions/<id>.md file. The mission-file append is a NEW cross-file shared-state write in the session-start flow.
(6) EDIT drift-check.md: load the active mission (from the session's Mission bullet) as a SECOND reference standard alongside the session mandate; report mission-drift distinctly. Degrade silently + emit one loud line if the mission file is absent or malformed — never hard-fail.
(7) EDIT wrap-session.md: one advisory line reminding to update the bound mission's "Open threads".
(8) EDIT docs/session-marker.md: document the "- Mission:" mandate bullet, declared LOAD-BEARING for /drift-check ONLY and PASS-THROUGH (informational) for the other readers of the mandate line.
(9) EDIT docs/repo-architecture.md: add logs/missions/ to the Q6 log table as a new state-artifact category.

Enforcement is advisory-only throughout — no new hard gates, no blocking behavior. The whole subsystem is a no-op for any repo with no logs/missions/ dir.

Operator + System Owner consult already shaped this design (storage moved from project-root to logs/missions/ on SO advice; auto theme-detection nudge killed; binding made explicit at /prime).

Key risk areas to weigh explicitly:
- Blast radius of editing THREE load-bearing harness commands (prime, session-start, drift-check) plus wrap-session in one change set.
- The session-notes.md mandate line now has ~6 readers (session-start writes it; drift-check, contract-check, open-items, archive tooling, and others read it). New contract: the "- Mission:" bullet is load-bearing for /drift-check ONLY and pass-through for the other readers. Evaluate whether that split contract is safe given the existing parsers.
- NEW shared-state write in session-start (appending to the mission file) — restructuring/adding a shared-state op.
- The zero-cost-when-empty guarantee in /prime (must not add latency or prompts to the common no-mission case).
- Reversibility (advisory-only, additive, files removable).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/mission.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/mission-contract.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/README.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/drift-check.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** An advisory-only, reversible, mostly additive subsystem whose risk concentrates in two High dimensions — blast radius (three load-bearing harness commands + one of the most contract-dense files in the repo, the session-notes mandate block with six documented readers) and hidden coupling (a new cross-file shared-state write in the session-start hot path plus a split load-bearing/pass-through contract) — both of which have viable paired mitigations.

## Consumer Inventory

The change introduces three new contracts. The grep for each across the canonical repo and the workspace root (one level up) returned **zero pre-existing hits** for the literal `- Mission:` bullet and the `{mission:` arg prefix (both confirmed empty), and **zero** `logs/missions` references. The `mission` token returned only unrelated substrings ("mission statement"/"commission" in corporate-identity log-sweeps). So the new artifacts have **no current consumers** — the inventory below covers (a) the **existing readers of the session-notes mandate block** that the new `- Mission:` bullet must coexist with (these are the real blast-radius drivers), and (b) the **components the change edits directly**.

The mandate-block reader set is verified from `session-start.md` Step 3's own parse-contract note (lines 280–290): "Six readers ... depend on the exact bullet labels."

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/commands/session-start.md | co-edits (writes the mandate block; gains `{mission:}` strip + `- Mission:` write + mission-file append) | yes |
| ai-resources/.claude/commands/prime.md | co-edits (Step 1a scan + menu + `{mission:}` arg pass) | yes |
| ai-resources/.claude/commands/drift-check.md | parses (Step 5 mandate auto-detect; gains `- Mission:` as load-bearing second standard) | yes |
| ai-resources/.claude/commands/wrap-session.md | co-edits (advisory line) + parses (Step 6.4 / Step 7a mandate block) | yes |
| /Users/.../Axcion AI Repo/.claude/commands/wrap-session.md (workspace-root paired copy) | parses (Step 2b mandate block; paired-contract sibling of canonical wrap) | no (pass-through; must tolerate new bullet) |
| ai-resources/.claude/commands/contract-check.md | parses (Step 2.5c mandate-block contract body, line 54) | no (pass-through; must tolerate new bullet) |
| ai-resources/.claude/commands/concurrent-session-check.md | parses (Step 3 reads `- Files in scope:` bullet, lines 19/70/78) | no (reads a different bullet; tolerant) |
| ai-resources/.claude/commands/monday-prep.md | documents (writes a separate week-mandate, NOT this bullet schema — session-start.md line 285) | no |
| ai-resources/.claude/commands/open-items.md | parses (session-plan checkbox glob, not the mandate bullet schema) | no |
| ai-resources/docs/session-marker.md | documents (two-end contract registry; gains the `- Mission:` contract entry) | yes |
| ai-resources/docs/repo-architecture.md | documents (Q6 log table; gains logs/missions row) | yes |
| ai-resources/templates/README.md | documents (consumer contract list; gains mission-contract.md entry) | yes |
| logs/scripts/check-archive.sh + split-log.sh | imports/parses (archive tooling iterates append-only logs; named as a mandate-line reader in CHANGE_DESCRIPTION) | no (operates on session-notes.md/decisions.md by file, not by the mandate bullet — see Dimension 5) |
| ~16 project symlinks to mission.md / prime.md / session-start.md / drift-check.md / wrap-session.md | invokes (auto-symlinked via auto-sync-shared.sh) | no (inherit canonical edits automatically) |

**Total: 13 distinct consumer rows, 6 must-change.** The new files (`mission.md`, `mission-contract.md`, `logs/missions/<id>.md`) have **no consumers yet** — the inventory above covers the contracts they introduce. Note the CHANGE_DESCRIPTION's own count ("~6 readers") is accurate for the mandate block specifically and matches the frozen six-reader list in `session-start.md` lines 280–290.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- `/prime` runs at the start of **every** session and the change adds a new per-session scan: "scan each enumerated repo's logs/missions/*.md for status:active" (CHANGE_DESCRIPTION item 4). Step 1a already enumerates `cwd + ai-resources + every repo under projects/*/` (prime.md lines 54–66), so the mission scan rides an existing per-repo loop — but it adds one `ls`/`grep` per enumerated repo on every prime, the highest-frequency command in the system.
- The design explicitly targets zero marginal token cost when no mission exists ("ZERO-COST no-op when none exist (no prompt, no menu change)"). This is a *disk-read* cost, not a *context-token* cost, in the empty case — the scan output is discarded and nothing enters the menu or context. That keeps the always-loaded-token cost at zero for the common case, which is the right design.
- `mission.md` is a new auto-symlinked command (item 1) but is pay-as-used — it loads only when `/mission` is invoked, not every session. No always-loaded-file cost: nothing is added to any CLAUDE.md or `@import` chain (confirmed — no CLAUDE.md edit is in the change set).
- Net: no always-loaded token growth; one new per-session disk scan in the hottest command. That is Medium (a SessionStart-frequency add), not Low, and not High (no per-tool-call hook, no always-loaded token bloat).

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` allow/ask/deny change is described. The change set lists command/template/doc edits and a new log directory only.
- The new shared-state write (session-start appending to `logs/missions/<id>.md`) is a Write under `logs/`, a path family the repo already authorizes for session writes (session-notes.md, decisions.md, marker files are all written under `logs/` today). No new tool family, no glob widening, no scope escalation (project → user), no cross-repo or external capability.
- `/mission` create/close lifecycle writes only under the repo's own `logs/missions/` tree — same scope as existing log writers.

### Dimension 3: Blast Radius
**Risk:** High

Grounded in the Consumer Inventory above: **13 consumer rows, 6 must-change.**

- The change edits **three load-bearing harness commands in one change set** — `prime.md`, `session-start.md`, `drift-check.md` — plus `wrap-session.md`. These four are the session-lifecycle spine; an error in any one degrades every session in every repo. CHANGE_DESCRIPTION flags this itself as a key risk area.
- It touches the **single most contract-dense surface in the repo**: the session-notes mandate block. `session-start.md` lines 280–290 enumerate **six frozen readers** of that block ("Do not rename these labels ... without updating all readers"). The change adds a seventh bullet (`- Mission:`) into a schema whose existing note already had to be verified pre-flight twice (2026-05-29, 2026-06-05). Cross-referencing the `parses` rows: contract-check (line 54), the workspace-root wrap copy (Step 2b), and concurrent-session-check (Step 3) all read this block and must remain unbroken.
- The mitigating fact: the new bullet is **additive and optional**, slotted alongside the existing optional `Allowed inputs`/`Required outputs`/`Context pack` bullets. The five non-drift readers use **fixed-list extraction or labeled-bullet pass-through** (session-start.md line 290: "All five readers ... silently ignore `- Context pack:`") — the same mechanism that already absorbs the optional `Context pack` bullet without breaking. So the additive bullet is *structurally* the same kind of change that landed safely on 2026-05-29 for `Context pack`. That precedent is why this is a High with a viable mitigation rather than an unmitigable High.
- **No unanticipated consumer surfaced** — the inventory's reader set matches CHANGE_DESCRIPTION's stated "~6 readers." The ~16 project symlinks inherit the canonical edits automatically (auto-sync topology, repo-architecture.md lines 127–136), so they are not separate must-change sites.

### Dimension 4: Reversibility
**Risk:** Medium

- `mission.md`, `mission-contract.md`, and `logs/missions/` are **new sibling files/dirs** — `git revert` of the creating commit removes tracked ones cleanly. The command/template/doc edits are single-file reverts.
- BUT the subsystem **mutates two on-disk state surfaces that a revert cannot cleanly undo**: (a) `- Mission: <id>` bullets already appended into `logs/session-notes.md` mandate blocks (append-only log, same revert-leaves-stale-entries problem the existing `session-start.md` revert note calls out for `**Mandate:**` lines — line 14), and (b) "Sessions served" lines appended into `logs/missions/<id>.md` files. After a revert, stale `- Mission:` bullets remain in session-notes history and orphaned mission files remain on disk; the parsers would then see a `- Mission:` bullet with no command to interpret it.
- Because the bullet is pass-through for five of six readers and the sixth (drift-check) is designed to degrade silently when the mission file is absent (item 6), a stale post-revert bullet is **inert, not breaking** — which keeps this Medium rather than High. The one extra cleanup step is manual removal of any written `- Mission:` bullets and `logs/missions/` files, exactly the manual-cleanup shape the existing session-start revert note already documents.
- No state propagates beyond git (no push, no external write) at change-land time. Reversibility is Medium: clean for the code, one manual cleanup step for the state it has written by the time of revert.

### Dimension 5: Hidden Coupling
**Risk:** High

- **New cross-file shared-state write in the session-start hot path (item 5).** session-start.md today writes exactly one file (`logs/session-notes.md`, Step 3) under a heavily-engineered marker/mtime concurrency protocol (Step 0.5 mtime guard, the whole `docs/session-marker.md` both-or-neither invariant). The change adds a **second** shared-state write — appending "Sessions served" to `logs/missions/<id>.md` — that is **outside** that protocol. Two concurrent sessions bound to the same mission would both append to the same mission file with **no marker-disambiguation and no mtime guard**, reintroducing exactly the TOCTOU lost-update class that `docs/session-marker.md` (lines 175–179) was built to eliminate for session-notes. This is the highest-signal coupling finding: the new write silently relies on the *absence* of concurrent same-mission sessions, an assumption nothing enforces.
- **Split load-bearing/pass-through contract (item 8).** The `- Mission:` bullet is declared load-bearing for `/drift-check` ONLY and pass-through for the other five readers. This is a genuinely novel contract shape — every existing mandate bullet is either uniformly load-bearing (the four core bullets) or uniformly informational (`Context pack`). A split contract means a future edit to drift-check's parse can break mission-drift while every other reader stays green, and the breakage is invisible to the five pass-through readers. The contract IS documented at the change site (item 8 edits `session-marker.md`'s two-end registry), which is what keeps this from being worse — but the split itself is new coupling that did not exist before.
- **drift-check second-standard coupling (item 6).** drift-check.md currently resolves ONE mandate and judges against it (lines 24–28). The change makes it load a SECOND reference standard (the active mission) from a *different file* (`logs/missions/<id>.md`) located via the `- Mission:` bullet. drift-check now couples to: the bullet's presence, the mission file's existence, and the mission file's frontmatter schema. The design mitigates this ("Degrade silently + emit one loud line if the mission file is absent or malformed — never hard-fail," item 6) — this is the correct OP-3 loud-degradation posture and materially reduces the coupling risk, but the dependency still exists.
- **Archive-tooling non-coupling (verified).** CHANGE_DESCRIPTION lists "archive tooling" as a mandate-line reader. Inspected: `check-archive.sh`/`split-log.sh` operate on append-only logs **by filename** (session-notes.md, decisions.md), not by parsing the mandate bullet schema (wrap-session.md lines 31–38). So the new bullet does NOT couple to archive tooling — one fewer coupling than the description implies. Good.

### Dimension 6: Principle Alignment
**Risk:** Medium

Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md` (frozen-ID set, as-of 2026-06-01).

- **OP-12 (closure before detection) — TENSION, not violation.** The change adds a new detection capability: `/drift-check` gains a SECOND drift dimension (mission-drift, item 6). OP-12 counts "new detection that does not close findings ... against a candidate." But mission-drift ships *behind an existing closure channel* — `/drift-check` is already an advisory surface the operator acts on, and `/wrap-session` gains the paired "update Open threads" closure reminder (item 7). So detection is not ahead of closure here; it rides a working channel. Tension noted, not a violation.
- **OP-9 / DR-7 / AP-7 (no speculative abstraction) — TENSION.** The Consumer Inventory found **zero current consumers** of the three new contracts (`- Mission:`, `{mission:}`, `logs/missions/`), which is the speculative-abstraction signal the rule names. Mitigating: this is a *subsystem being shipped whole with its own consumers in the same change set* (prime reads the scan, drift-check reads the bullet, mission.md is the lifecycle) — not a hook built for an absent Phase-2 consumer. The contracts have zero *pre-existing* consumers because the subsystem is new, not because it is built ahead of demand. The split load-bearing/pass-through contract (item 8) edges closer to the line — it provisions a pass-through slot in five readers for a capability only one reader uses — but a single confirmed consumer (drift-check) exists, so DR-7's "second confirmed consumer" bar is not the live constraint. Tension, not violation.
- **OP-5 (advisory vs enforcement) — ALIGNED.** "Enforcement is advisory-only throughout — no new hard gates, no blocking behavior." The change keeps every new surface advisory (drift-check stays advisory, wrap reminder is advisory, drift-check degrades silently on a missing mission file). No advisory→enforcement upgrade. Actively serves OP-5.
- **DR-1 / DR-3 (placement) — ALIGNED.** New command → `ai-resources/.claude/commands/` (canonical, DR-1); new template → `templates/` with README registration (the documented consumer-contract idiom); new per-repo state → project `logs/` tier; repo-architecture.md Q6 table updated in the same change set (item 9) per its own "update in the same commit" rule (repo-architecture.md lines 5, 241–249). Correct tier and home throughout.
- **OP-10 (system boundary) — ALIGNED.** The subsystem governs Claude Code session lifecycle only; no cross-tool (GPT/Perplexity/Notion) coordination. No boundary expansion.
- No principle is *violated*; two are in *tension* (OP-12, OP-9/DR-7) and both are within their licensed envelope. Medium, not Low (the zero-consumer contract split is a real tension worth naming), not High (no clear violation, and the SO consult already shaped the design).

## Mitigations

- **Dimension 3 (Blast Radius) — land the mandate-bullet add exactly as the `Context pack` precedent.** Before editing the parse-side readers, verify each of the six frozen readers (session-start.md lines 280–290 list) treats `- Mission:` via the same fixed-list / labeled-pass-through path that already absorbs `- Context pack:`. Add `- Mission:` to the documented optional-bullet set in `session-start.md` Step 3, `wrap-session.md` Step 7a, and the workspace-root wrap copy Step 2b *in the same commit*, and update the six-reader note to a seven-reader note. Do NOT rename any existing label. This makes the additive bullet behave identically to the change that landed safely on 2026-05-29.
- **Dimension 3 — stage the three harness-command edits behind one independent `/qc-pass` before commit.** Because prime/session-start/drift-check are the session spine and this is a `/risk-check` change class, the edit must clear independent QC (per workspace CLAUDE.md QC Independence Rule); if QC is unreachable in-session, defer via `/handoff` QC-PENDING rather than self-QC-and-commit.
- **Dimension 5 (Hidden Coupling) — bring the new mission-file write under the concurrency protocol, or make it append-only-safe.** The "Sessions served" append in session-start (item 5) must not reintroduce the TOCTOU lost-update class. Either (a) make it a strictly append-only write that is safe under concurrent appends (one line per session, never a read-modify-rewrite), and state that contract in `mission.md` + `session-marker.md`; or (b) if any read-modify-write is required, route it through the marker/mtime discipline already documented in `docs/session-marker.md`. Pick (a) — append-only — as the lower-risk subset; it sidesteps the guard machinery entirely.
- **Dimension 5 — register the split contract in the two-end registry and name drift-check as the sole load-bearing reader.** Item 8 already edits `session-marker.md`; ensure that edit explicitly lists `- Mission:` under a new registry entry stating "load-bearing for drift-check ONLY; pass-through for the other six mandate-block readers," so a future editor cannot silently break mission-drift while leaving the pass-through readers green.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION, mitigations above apply.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (session-start.md lines 14, 280–290; prime.md lines 54–66; drift-check.md lines 24–28; wrap-session.md lines 31–38; repo-architecture.md lines 5, 127–136, 241–249; session-marker.md lines 175–179; contract-check.md line 54; concurrent-session-check.md lines 19/70/78), grep counts (zero hits for `- Mission:`, `{mission:`, and `logs/missions` — confirming new contracts with no current consumers; `mission` token hits all unrelated substrings), verbatim CHANGE_DESCRIPTION quotes, and principle IDs from the read principles-base (OP-5, OP-9, OP-10, OP-12, DR-1, DR-3, DR-7, AP-7). No training-data fallback was used on any read.
