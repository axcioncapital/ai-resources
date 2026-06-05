# Risk Check — 2026-06-05

## Change

Create a new standalone advisory command /concurrent-session-check (ai-resources/.claude/commands/concurrent-session-check.md). Read-only, never-blocks pre-flight checker that helps the operator decide whether it is safe to START a new session/task while another session is already live in the same repo. Mode 1 (task named as $ARGUMENTS): predict the candidate task's file footprint via the context-discovery agent (same invocation as /build-context), compare against live sessions' declared footprints, report SAFE/COLLIDES. Mode 2 (no arg): gather candidates via the existing /open-items scan, predict each footprint by lightweight name-extraction, return the safe subset + colliding subset. Live footprints are READ from disk: each live session's mandate "- Files in scope:" bullet under its "## DATE — Session SN" header in logs/session-notes.md, plus its logs/session-plan-DATE-MARKER.md file, plus today-dated per-id markers logs/.session-marker-*. Overlap is classified shape-aware per parallel-sessions-playbook.md §2 table: no shared path = SAFE; shared append-only log (session-notes.md, decisions.md, usage-log.md, improvement-log.md, coaching-data.md) = expected-shared/not-blocking; shared content-shaped file (command/doc/skill .md, next-up.md, indexes) = real conflict flagged. The command WRITES NOTHING (no markers, no logs, no commits) — purely read-only and advisory, never blocks, never chains into other commands. On SAFE it nudges toward /new-worktree-session for checkout isolation. Frontmatter: description, model: sonnet, disable-model-invocation: true, argument-hint. Optional secondary edits: one-line pointer added to docs/parallel-sessions-playbook.md §4, and a reader entry in docs/session-marker.md two-end registry.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/concurrent-session-check.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/build-context.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-worktree-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/open-items.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/detect-concurrent-session.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/parallel-sessions-playbook.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/context-discovery.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/plans/eventual-brewing-sifakis.md — tagged `exists`, but ABSENT on disk (the `.claude/plans/` directory does not exist; `ls` returned "No such file or directory"). The "full spec" could not be read. All findings below rest on CHANGE_DESCRIPTION alone, not on the detailed spec.

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A read-only, never-blocks advisory command is low-cost and reversible, but it carries one elevated risk — it builds a new parse-dependency on the `- Files in scope:` mandate marker and the session-plan/marker file conventions, which is a Hidden-Coupling concern that must be registered in the two-end contract registry it already plans to touch; the principle posture (OP-12 closure-before-detection, OP-5 advisory) is sound but rests on an unread spec.

## Consumer Inventory

The new command file (`concurrent-session-check.md`) is `not yet present`, so it has **no consumers yet** — a grep for `concurrent-session-check` and `/concurrent-session-check` across `ai-resources/` and the workspace root returned **zero hits** (excluding this report). The inventory below therefore covers the **upstream contracts the command will consume** (the markers/files it reads) and the **two files the change will edit**, since those are the surfaces where the change creates or honors a dependency.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/agents/context-discovery.md` | invokes (Mode 1 calls this agent, same as `/build-context`) | no |
| `ai-resources/.claude/commands/build-context.md` | documents (cited as the reference invocation pattern) | no |
| `ai-resources/.claude/commands/open-items.md` | invokes (Mode 2 reuses its scan) | no |
| `ai-resources/.claude/commands/session-start.md` | parses (new command READS the `- Files in scope:` bullet that `session-start.md` Step 3 WRITES under `## DATE — Session SN`) | no (but creates a one-directional parse coupling) |
| `ai-resources/docs/session-marker.md` | parses + documents (reads per-id markers `logs/.session-marker-*` and `session-plan-DATE-MARKER.md`; change ADDS a reader entry to its two-end registry) | yes (registry edit) |
| `ai-resources/docs/parallel-sessions-playbook.md` | documents (change ADDS a one-line §4 pointer; command cites §2 shape table as classification authority) | yes (one-line pointer edit) |
| `ai-resources/.claude/commands/new-worktree-session.md` | documents (SAFE-path nudge points operators here) | no |
| `ai-resources/.claude/hooks/detect-concurrent-session.sh` | (peer mechanism — same problem domain; not a caller) | no |

Total: 8 distinct surfaces, 2 must-change (both are the change's own planned secondary edits — the playbook §4 pointer and the session-marker registry reader entry). No external/unanticipated consumer requires modification. The new file itself has no inbound callers (greenfield command, operator-invoked only via `disable-model-invocation: true`).

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Pay-as-used command, not always-loaded. It is a slash command under `.claude/commands/`, invoked on demand — it adds no content to any always-loaded `CLAUDE.md` and registers no hook. Evidence: CHANGE_DESCRIPTION "Create a new standalone advisory command"; no SessionStart/PreToolUse/Stop registration is described.
- `disable-model-invocation: true` is specified in the frontmatter — the model cannot auto-fire it, so it never loads except on explicit operator invocation. Evidence: CHANGE_DESCRIPTION frontmatter list; pattern matches `new-worktree-session.md:4` which uses the same flag (4 commands repo-wide already use it).
- Mode 1 spawns the `context-discovery` subagent (an Opus agent, `context-discovery.md:4 model: opus`), which can take 30–90s and reads up to 30 files (`context-discovery.md:30`). This is per-invocation cost on an on-demand command, not per-session — and the agent already bounds itself (≤30 lines summary, notes-to-disk contract). No ongoing token cost added to future sessions.
- The two optional secondary edits add ~1 line each to two `docs/` files that are NOT always-loaded — negligible.

### Dimension 2: Permissions Surface
**Risk:** Low

- The command is read-only by design and "WRITES NOTHING (no markers, no logs, no commits)" (CHANGE_DESCRIPTION). It needs only Read/Glob/Grep plus the existing Agent-spawn capability already exercised by `/build-context` (`build-context.md:37` launches `context-discovery`).
- No new `allow`/`ask` entry, no `deny` removal, no scope escalation, no external/cross-repo write capability is described. The subagent it spawns is already authorized (`context-discovery.md` tools: Read, Glob, Grep, Write — and its Write is confined to the pack it produces, `context-discovery.md:12`).
- No Bash command family beyond what marker-reading needs (`cat`/`stat`/`date` on `logs/.session-marker-*`), all read-only and within established patterns (same shapes used in `session-start.md:35,44` and `detect-concurrent-session.sh:75,93`).

### Dimension 3: Blast Radius
**Risk:** Low

- Grounded in the Step 1.5 inventory: 8 surfaces, **2 must-change**, and both must-change surfaces are the change's *own* declared secondary edits (playbook §4 pointer, session-marker registry reader entry) — not external callers forced to adapt. No third-party consumer breaks.
- The new file has **zero inbound callers** (grep for `concurrent-session-check` returned nothing) — it is a leaf command, operator-invoked only. Adding it cannot break any existing chain.
- It does not change any contract that existing callers depend on: it is a pure *reader* of the `- Files in scope:` marker, the `## DATE — Session SN` header, the `session-plan-*.md` glob, and `logs/.session-marker-*`. It does not alter the shape of any of these — `session-start.md` Step 3 keeps writing them unchanged, and the existing readers (`/wrap-session`, `/drift-check`, `/open-items`, `fix-repo-issues-scanner`) are untouched.
- The one inventory item worth naming: the `parses` dependency on `session-start.md`'s `- Files in scope:` bullet is **one-directional** — `session-start.md:80-84` documents its contract with three named consumers and does NOT name this new reader. That is a coupling/registry concern (carried to Dimension 5), not a blast-radius break, because the new command only reads and degrades gracefully if the marker is absent.

### Dimension 4: Reversibility
**Risk:** Low

- The command writes nothing — no markers, no logs, no commits (CHANGE_DESCRIPTION, emphatic). So a `git revert` of the command file leaves **no runtime residue**: no stale log entries, no orphaned markers, no append-only-log mutation to reconcile. This is the cleanest reversibility profile (contrast `session-start.md:14`, which carries an explicit revert-residue note precisely because it *does* write).
- The two optional secondary edits are single-line additions to two tracked `docs/` files; `git revert` removes them cleanly.
- No state propagates beyond git: no push, no external API, no Notion write. The command is advisory and terminal (it "never chains into other commands"), so nothing fires between landing and a potential revert.
- One minor note (keeps it Low, not zero): because the command reads several disk conventions, a revert must also revert the `session-marker.md` registry entry to avoid a dangling reader reference — but that is part of the same atomic change set, not a separate manual step.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The command takes a **new parse-dependency on three disk conventions it does not own**: (a) the `- Files in scope:` mandate bullet written by `session-start.md` Step 3; (b) the `## DATE — Session SN` header format; (c) the `session-plan-DATE-MARKER.md` filename scheme and `logs/.session-marker-*` per-id markers governed by `session-marker.md`. If any of these formats change, the new command silently mis-reads live footprints and could report SAFE when sessions actually collide — a silent false-negative on a safety check. This is the same class of coupling the repo already manages via the two-end registry.
- **Mitigant already in the plan:** the change explicitly adds "a reader entry in docs/session-marker.md two-end registry" (CHANGE_DESCRIPTION). `session-marker.md:108-116` and `:145-153` already enumerate read-only auxiliary consumers (`/contract-check`, `/drift-check`, `/open-items`, `/decide`, `fix-repo-issues-scanner`) that "tolerate marker absent/stale by falling through" — the new command fits that established pattern exactly and its registry entry closes the contract at both ends. This is why the risk is Medium, not High: the new contract is documented at the change site rather than left implicit. The `- Files in scope:` half of the coupling, however, lives in `session-start.md`'s parse-contract block (`session-start.md:80-84`), which names its consumers in one direction only and does NOT currently name this new reader — that half should also be registered (see Mitigations).
- **Functional-overlap check (no overlap found):** the command supplements, does not duplicate, the existing concurrency mechanisms. `detect-concurrent-session.sh` detects *that* another session is live via an OS process signal (`detect-concurrent-session.sh:16,75`); this command predicts *whether the footprints collide*. Different question, different mechanism — the playbook's own §3 boundary ("detect collisions; they do not prevent merge pain", `parallel-sessions-playbook.md:80`) leaves exactly this predictive gap open. No competing gate taxonomy is introduced (the command classifies via the playbook §2 table rather than inventing its own).
- **Spec-unread caveat:** the detailed footprint-prediction logic (Mode 2 "lightweight name-extraction") lives in the absent spec file. Name-extraction heuristics are a known soft spot — if the heuristic under-predicts a footprint, the SAFE verdict is wrong. This cannot be evaluated against the spec because the spec is not on disk; it is flagged as a residual coupling-to-heuristic-quality risk, not scored as High on assumption.

### Dimension 6: Principle Alignment
**Risk:** Low

- **OP-12 (closure before detection) — PASSES, notably well.** OP-12 says "new detection that does not close findings counts *against* a candidate." This command is detection (footprint-collision prediction), but it ships *behind a working closure channel*: on a collision/SAFE it nudges to `/new-worktree-session` (`new-worktree-session.md` exists and is the structural cure, `new-worktree-session.md:8-23`), which is the closure action. Detection is wired to an existing remedy, not floated ahead of one. This is the OP-12-compliant shape.
- **OP-5 (advisory ≠ enforcement) — PASSES.** The command "never blocks, never chains into other commands" and "WRITES NOTHING" (CHANGE_DESCRIPTION) — it advises and stops, the current-phase posture (`principles-base.md` OP-5). It does not auto-correct, auto-isolate, or auto-create a worktree (it cannot — a session's cwd is fixed before any command runs, per `new-worktree-session.md:18-23`). No silent advisory→enforcement upgrade.
- **DR-7 / AP-7 / OP-9 (speculative abstraction) — PASSES.** The Consumer Inventory shows the command consumes *existing* contracts (`/open-items`, `context-discovery`, the marker/playbook conventions) rather than building hooks for an absent consumer. The consumer it serves — the operator deciding whether to start a parallel task — is a *current, confirmed* pain (the playbook §4 anti-pattern note and `audits/2026-06-05-concurrent-session-collision-diagnostics-fix.md` document a real S6 collision). It generalizes nothing speculatively; it adds one specific advisory.
- **DR-1 / DR-3 (placement) — PASSES.** A shared slash command belongs at `ai-resources/.claude/commands/` (`principles-base.md` DR-1/DR-3; CLAUDE.md "Shared AI resources … belong in ai-resources/"). The chosen path is canonical and correct. The work is also routed through `/risk-check` as DR-8 requires for a new command.
- **DR-8 — SATISFIED by this very review** (new command = gated structural-change class; `principles-base.md` DR-8).
- No principle is violated; OP-12 and OP-5 are actively *served*. The only reason this is not a glowing Low-with-no-caveats is the unread spec — but nothing in CHANGE_DESCRIPTION signals a principle conflict, so the dimension is Low, not INCOMPLETE.

## Mitigations

- **Dimension 5 (Hidden Coupling, Medium):** Before/at landing, register the new command in BOTH contract two-end registries it depends on — not only `session-marker.md` (already planned) but also add it to the `session-start.md` parse-contract block (`session-start.md:80-84`) as a downstream reader of the `- Files in scope:` bullet, so a future edit to that marker format surfaces this reader. Concretely: add one reader line in `session-marker.md`'s "Read-only auxiliary consumers" list (`session-marker.md:145-153`) and one consumer reference in `session-start.md`'s contract block. This closes the one-directional gap noted in Dimension 3 and converts the implicit parse-dependency into a registered, two-end-visible one.
- **Dimension 5 (residual heuristic risk):** Because the Mode-2 "lightweight name-extraction" footprint logic is in the absent spec, require that the command's SAFE verdict be stated as *advisory and best-effort* in its own output text (e.g., "predicted footprints — verify before parallel work"), mirroring the hook's own heuristic-honesty line (`detect-concurrent-session.sh:99` "Heuristic: … verify before doing parallel work"). This prevents a name-extraction under-prediction from reading as an authoritative all-clear.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to `session-start.md`, `new-worktree-session.md`, `context-discovery.md`, `detect-concurrent-session.sh`, `parallel-sessions-playbook.md`, `session-marker.md`, `open-items.md`, `build-context.md`, `principles-base.md`; grep counts for the new command name [0 hits] and `disable-model-invocation` [4 existing uses]; verbatim CHANGE_DESCRIPTION quotes). One referenced file tagged `exists` (`.claude/plans/eventual-brewing-sifakis.md`) was ABSENT on disk and could not be read — every finding rests on CHANGE_DESCRIPTION, and the spec-unread limitation is flagged explicitly under Dimensions 5 and 6. No training-data fallback was used on the read failure.

## Architectural Commentary

_System-owner second opinion (Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION. Full advisory: `projects/axcion-ai-system-owner/output/consultations/consult-2026-06-05-concurrent-session-check-second-opinion.md`._

**Concurs with PROCEED-WITH-CAUTION — but re-centers the caution.**

- **Routing:** correct home and shape (new canonical command at `.claude/commands/`, advisory main-session shape). No objection.

- **Q1 — verdict reason corrected.** The reviewer's stated concern (the `session-start.md` half of the `- Files in scope:` contract is "one-directional / not a tracked two-end contract") is **false on disk**: `session-start.md` lines 280–289 already carry an explicit **Parse contract** block naming five readers with a rename guard. The contract exists. GO is wrong only because of the Q3 blind spot below; RECONSIDER over-calls a read-only/never-blocks/writes-nothing command. PROCEED-WITH-CAUTION stands, with new content.

- **Q2 — mitigation 1 reframed, mitigation 2 strengthened.**
  - `session-marker.md` reader-registry entry: required and correct.
  - `session-start.md`: do NOT make a reader "force the contract into existence" (that is the `DR-7`/`AP-7` over-build). It already is a contract — correct action is a **one-line append of the command as the sixth Parse-contract reader** (both copies, lockstep).
  - Mitigation 2 (SAFE = advisory/best-effort): keep, non-optional under `OP-3`/`AP-2`, and elevate into the Q3 gate.

- **Q3 — the missed risk (outranks the parse-dependency).** SAFE depends on the *other* session having declared its footprint, but `/prime` writes the marker while `/session-start` writes `- Files in scope:` as a **separate, later** step (`session-marker.md § Asymmetric contract`). A **primed-but-not-planned live session has a marker + plan file but no declared scope** → reads to the checker as no-overlap → SAFE. The session most likely to collide is the one the checker is blindest to — the workspace's own `parallel-sessions-playbook.md § 4` documented #1 failure (the 2026-06-05 S6 collision). This fails **silently and confidently**, unlike a tracked-contract label drift which fails loudly.

  **Required gate (the real mitigation):** marker present + no resolvable `- Files in scope:` → **UNKNOWN-SCOPE, never SAFE.** SAFE only when every live footprint is positively readable AND positively non-overlapping. Absence of evidence is surfaced, never collapsed into all-clear. Secondary inline cautions: Mode-2 name-extraction under-prediction; machine-wide (not project-scoped) liveness if it borrows the `pgrep` signal.

**Position:** PROCEED, caution re-centered. (1) Replace mitigation-1 wording with two one-line registry appends; (2) promote mitigation-2 into the UNKNOWN-SCOPE-never-SAFE gate; (3) name Mode-2 and liveness limits inline rather than engineering them away.
