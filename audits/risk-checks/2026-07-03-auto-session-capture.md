# Risk Check — 2026-07-03

## Change

New automatic minimal session-capture mechanism for the ai-resources workspace. Purpose: today every durable session record (session-notes, decisions, friction, telemetry) is written ONLY inside the manual, skippable `/wrap-session`; if the operator skips it nothing is captured. This adds a zero-operator-action safety net. Two parts:

(1) **New Stop hook `ai-resources/.claude/hooks/auto-session-stub.sh`** (registered as a new entry in the `Stop` array of `ai-resources/.claude/settings.json`, timeout 5, alongside the 3 existing Stop groups). On every Stop firing (Stop fires once per assistant turn, verified against code.claude.com/docs/en/hooks — many times per session, idempotent-safe): resolves the session key from `CLAUDE_CODE_SESSION_ID` ONLY (if unset → exit 0, capture nothing — no `$PPID` fallback, because promotion + teardown both key on the SESSION_ID per-id marker which prime.md writes only when SESSION_ID is set); refreshes-in-place (overwrite, never append) a per-session side file `logs/.session-stub-${SESSION_ID}` containing date, marker (read from `logs/.session-marker-${SESSION_ID}` if present, else `(none — /prime not run)`), session id, last-activity timestamp, and a best-effort task line (reuse the existing `.claude/hooks/check-heavy-tool.sh` JSONL-transcript-scan pattern to read the first user message from `transcript_path` on hook stdin; sanitize — strip/escape leading `#`/backtick sequences + length-cap — before writing, since transcript text is untrusted and this is a new markdown-injection surface); teardown-recognition: if the side file exists but the per-id marker has vanished (= `/wrap-session` Step 13 already tore it down = properly recorded), delete the stub instead of refreshing. This hook NEVER writes to `session-notes.md` — only to its own uniquely-keyed side file — so it cannot participate in the concurrent-session collision class.

(2) **Promotion — a new early orientation step (Step 1e) added to `ai-resources/.claude/commands/prime.md`**, factored into a new shared script `logs/scripts/promote-session-stub.sh` (alongside the existing `logs/scripts/check-archive.sh`) invoked ONCE from Step 1e. At orientation (before the Step 6 brief): scan `logs/.session-stub-*` for stubs whose recorded date is NOT today (an orphan from a prior session that ended without `/wrap-session`); for each, if no `## {stub-date} — Session {stub-marker}` header already exists in `session-notes.md` (idempotency guard), APPEND (heredoc `>>` or strictly end-anchored edit — never whole-file Write, per the 0ee6177 append-only hardening incident) a minimal block: a `## {date} — Session {marker}` header + `**Auto-captured stub**` note + last-activity + best-effort task line — DELIBERATELY NO `**Mandate:**` line (keeps it outside wrap-session.md Step 3.5's FOREIGN_MANDATES signal so it rides silently into the next commit); then delete the promoted stub + any matching stale per-id marker. Not-today-only is deliberate: avoids promoting a still-live concurrent same-day session's stub. A same-day orphan promotes at the next day's first `/prime`.

**Blind-spot finding to weigh (from the pre-implementation /blindspot-scan):** promotion is `/prime`-gated, but this operator routinely starts sessions with non-/prime commands (`/log-sweep`, `/clarify`, `/friday-act` — documented in friction-log). So a captured stub waits un-promoted (invisible to `/friday-checkup` roll-up + `/coach`, which read session-notes.md) until a `/prime` eventually runs — the stub is never LOST (safe on disk), only promotion is delayed. RECOMMENDED DECISION (weigh this): keep `/prime`-gated promotion for v1 (simplest; adds no per-session-start shared-write collision surface), document the latency as a known property, and add a SessionStart-hook promotion gate ONLY if stub accumulation is later observed — rather than pre-building the second mechanism (DR-7/AP-7). Please assess whether this is the right call or whether a SessionStart promotion gate should be built now.

**Supporting edits:** `ai-resources/.gitignore` gains `logs/.session-stub-*` (parallel to existing `logs/.session-marker-*`); `ai-resources/docs/session-marker.md` registers the new `logs/.session-stub-*` file + the promotion hook-in per its own "Two-end contract registry" / "When to update this doc" sections.

**Change classes hit (per audit-discipline.md):** Hook edits; Automation with shared-state effects (a script auto-writing to session-notes.md). prime.md is Critical-tier and the root copy is a symlink (no lockstep). settings.json is not a permission change (no allow/ask/deny edit — just a Stop-hook registration).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/auto-session-stub.sh — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/promote-session-stub.sh — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists (Step 1e to be added)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json — exists (Stop array)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.gitignore — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-heavy-tool.sh — exists (transcript-scan pattern to reuse)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists (Step 3.5 FOREIGN_MANDATES + Step 13 teardown — interaction surface)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A well-reasoned, mostly self-isolated safety net whose one High risk is Hidden Coupling — its "rides silently" safety rests on undocumented, exact dependencies on the wrap-session Step 3.5 detector shape and the per-id-marker teardown lifecycle (which the un-addressed `/handoff` Step C3 path also mutates); with those couplings documented and the teardown assumption corrected, the change is landable.

## Consumer Inventory

The two new files (`auto-session-stub.sh`, `promote-session-stub.sh`) are targets, not consumers. The `logs/.session-stub-*` contract they introduce has **zero pre-existing consumers** — grep for `session-stub` across the repo and workspace returned only this session's own mandate line in `logs/session-notes.md` (a files-in-scope listing, not a runtime reader). The inventory below covers consumers of the **contracts the change depends on or writes into**: the shared `logs/session-notes.md` header/mandate schema, the per-id marker two-end lifecycle, and the transcript-scan pattern.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/prime.md` | invokes (new Step 1e calls promote-session-stub.sh; also writes the per-id marker the hook reads) | yes |
| `ai-resources/.claude/settings.json` | invokes (registers the Stop hook) | yes |
| `ai-resources/.gitignore` | co-edits (ignores `logs/.session-stub-*`) | yes |
| `ai-resources/docs/session-marker.md` | documents (registers new stub file + promotion hook-in) | yes |
| `ai-resources/.claude/commands/wrap-session.md` | parses (Step 3.5 counts `^## ${TODAY}` headers + `^**Mandate:**` lines — the guard the promoted block evades) / co-edits (Step 13 per-id teardown the hook keys on) | yes |
| `ai-resources/skills/handoff/SKILL.md` | parses (Step C3 line 209 ALSO removes the per-id marker — breaks the hook's "marker vanished = wrap recorded it" assumption) | yes |
| `ai-resources/.claude/hooks/check-heavy-tool.sh` | imports (transcript-scan pattern donor — couples the new hook to the transcript JSONL schema) | no |
| `ai-resources/.claude/commands/friday-checkup.md` | parses (Step 3 line 147 `grep -c "^## "` counts ALL headers un-date-scoped → promoted header inflates it; Step 14.5 greps `### Session Value Audit` → promoted stubs invisible) | no |
| `ai-resources/.claude/hooks/detect-concurrent-session.sh` | parses (reads per-id marker set as liveness — shares the marker lifecycle the hook now also reads) | no |
| `ai-resources/logs/scripts/check-archive.sh` | parses (entry-count / threshold archival of session-notes — promoted blocks add entries) | no |
| `ai-resources/.claude/commands/coach.md` + agents (collaboration-coach, session-feedback-collector) | parses (read session-notes; promoted stubs lack their schemas → invisible, coverage gap not break) | no |
| `ai-resources/.claude/commands/session-start.md` / `session-plan.md` | parses (per-id marker writers/readers; unaffected by stub files, share the marker) | no |
| `logs/.session-stub-*` (NEW contract) | — (only the two new files touch it; no pre-existing consumers) | n/a |

**Total: ~12 distinct existing consumers considered, 6 must-change.** The must-change set = the 4 files the change already edits (prime.md, settings.json, .gitignore, session-marker.md) + **2 the change does NOT currently list as edited but should** (wrap-session.md, handoff/SKILL.md) — both drive the Hidden-Coupling High.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The Stop hook injects **no context tokens.** It writes only to its own side file (`logs/.session-stub-${SESSION_ID}`) and emits nothing to `hookSpecificOutput.additionalContext` — unlike `check-heavy-tool.sh` which prints a `[HEAVY]` context line (check-heavy-tool.sh lines 112–120). No always-loaded file (workspace/project CLAUDE.md) gains content; no `@import` chain; no broad-trigger skill. So there is zero ongoing per-turn *token* cost.
- Per-turn *compute* cost is real but modest: the hook runs `bash` + a transcript scan on every Stop (once per assistant turn). Reusing check-heavy-tool's `last_real_user_prompt` pattern, which iterates the whole JSONL (check-heavy-tool.sh lines 44–68), on a long transcript is O(transcript size) per turn — the stub only needs the *first* user message and should early-exit, but this is execution overhead, not token cost. It is a 4th Stop group added to the 3 existing (settings.json lines 93–129), so each Stop now spawns 4+ hook processes.
- Promoted blocks accrue a few lines each in `session-notes.md`, read once per session by `/prime` Step 1 (prime.md lines 36–49) — a minor per-prime read growth, not a per-turn cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow` / `ask` / `deny` edit. The change explicitly registers a Stop hook, not a permission (settings.json `permissions` block lines 2–33 untouched). Confirmed against the file: the Stop array (lines 93–129) is the only settings.json region touched.
- Every capability the hook and script use is already authorized: `Bash(*)` (settings.json line 4) covers the hook `bash` invocation and the heredoc append; `Bash(rm *)` (line 20) covers stub/marker `rm -f` (the deny `Bash(rm -rf *)` on line 23 is not approached). Writes land only in `logs/` (already writable). No cross-repo write, no external API, no MCP, no scope escalation (project → user).

### Dimension 3: Blast Radius
**Risk:** Medium

- **New shared-state write point into `logs/session-notes.md` at `/prime` orientation.** Before this change, `/prime` wrote to session-notes only at Step 8 (after task selection). Step 1e adds an *earlier, pre-brief* append. Given the operator's documented pattern of skipping `/wrap-session`, orphan stubs will be common, so most first-`/prime`-of-day sessions will write. `session-notes.md` is read by ~30+ components (grep count: 30 command/agent/hook files reference it under `.claude/`).
- **The write is engineered inert to the load-bearing readers** — this is what holds the risk at Medium, not High: the promoted block uses a *prior-day* header (evades wrap-session Step 3.5's `^## ${TODAY}` signal, wrap-session.md line 66) and omits `**Mandate:**` (evades the `^**Mandate:**` signal, line 71, and the `EXTRA_PRIOR_MANDATES` REMNANT classifier, lines 252–275). Step 7a coaching / Step 11.5 mission reminders scan only *today's* block, so are unaffected.
- **Inertness is NOT total — one consumer the change's claim misses:** `friday-checkup.md` Step 3 line 147 counts wrapped sessions with `grep -c "^## "` (un-date-scoped). A promoted prior-day header inflates this count, nudging the `/coach` volume gate (`< 5` → skip). Not a break, but a mis-count the "rides silently" framing does not acknowledge. Additionally the `### Session Value Audit` roll-up (Step 14.5) and `/coach` cannot see auto-stub blocks (no schema) — a coverage gap the blind-spot finding already flags.
- **Concurrent double-promote race (bounded).** Two next-day `/prime`s (e.g., two Monday-morning terminals) both scan `logs/.session-stub-*`, both see yesterday's orphan, both pass the header-exists idempotency guard before either append lands (TOCTOU), and both append the same block → a *duplicate* prior-day block. Bounded (same content, not a lost update; not-today-only excludes live same-day stubs), but real. The `/prime` marker-N computation is unaffected (it keys on today-dated headers only, prime.md lines 267–268).
- **Append-ordering side effect on `/prime` Step 1.** A promoted prior-day block appended at the physical *bottom* can become the "last entry" that `/prime` Step 1's `grep -n "^## [0-9]" | tail -1` (prime.md line 44) returns on the *next* session if no later block follows it — briefing on an auto-captured stub as the most recent session. Mild.

### Dimension 4: Reversibility
**Risk:** Medium

- **Code reverts cleanly.** The two new files (`auto-session-stub.sh`, `promote-session-stub.sh`), the settings.json Stop entry, the prime.md Step 1e, the .gitignore line, and the doc registration are all removed by a single `git revert` of the adding commit.
- **Data residue is NOT cleanly revertable — the reason this is not Low.** Promotion mutates `logs/session-notes.md`, a *committed, append-only* file mutated by many later commits. Once a promoted block has shipped in some session's wrap commit, reverting the *feature* commit does not excise it — this is the rubric's "append-only log mutation a revert cannot cleanly undo" signal. Mitigant that holds it at Medium rather than High: every promoted block is self-labeled `**Auto-captured stub**`, so excision is a tractable grep-and-delete, not a forensic reconstruction.
- **Gitignored stub files persist after revert.** `logs/.session-stub-*` files (gitignored) remain on disk post-revert; cleanup is one `rm -f logs/.session-stub-*`.
- **The hook can fire in the revert window.** As a registered Stop hook, it keeps writing stubs (and a `/prime` keeps promoting) between the decision to revert and the revert landing — one extra manual sweep step. Net: revert works but needs 1–2 extra cleanup steps (rm stubs; optionally excise promoted blocks) → Medium.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Undocumented coupling to wrap-session Step 3.5's exact detector shape.** The promotion's core safety property ("rides silently into the next commit") is *entirely* a function of Step 3.5 detecting foreign content via only two signals — `^## ${TODAY}` header count (wrap-session.md line 66) and `^**Mandate:**` count (line 71). The promoted block is shaped to be invisible to both. But Step 3.5 carries a `PAIRED CONTRACT` comment (lines 42–49) that enumerates its format dependencies and their writers — and the change does **not** add the promotion writer to it, nor does the change list wrap-session.md as an edited file (it is tagged "interaction surface" only). If Step 3.5 is ever hardened to count prior-day headers or to flag auto-stub blocks, every promoted block becomes a FOREIGN false-positive that STOPs the wrap — a silent, delayed break with no cross-reference to warn the editor.
- **Broken teardown-recognition assumption via the `/handoff` path (confirmed).** The hook's teardown branch treats "side file exists but per-id marker vanished" as "`/wrap-session` Step 13 recorded it → delete stub." But the per-id marker is *also* removed by `handoff/SKILL.md` Step C3 (`skills/handoff/SKILL.md` line 209: `rm -f "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}"`), per the two-end registry in `docs/session-marker.md` line 148. A session that ends via direct `/handoff` writes a continuity scratchpad, **not necessarily a session-notes record** — yet the hook would see the vanished marker, conclude "properly recorded," and delete the stub, *defeating the safety net for exactly the un-wrapped case it exists to catch.* The change addresses only Step 13, not Step C3.
- **New untrusted-input → committed-file injection surface (unverifiable at review time).** Transcript text (untrusted) flows: `transcript_path` → sanitized stub task line → promoted into `session-notes.md` → committed → read by many subagents (context-discovery, session-feedback-collector, coach). The change states it sanitizes (strip/escape leading `#`/backtick, length-cap), but `auto-session-stub.sh` is `not yet present`, so the sufficiency of that sanitization cannot be verified — this contribution is assessed from described intent only (per the not-yet-present rule).
- **Silent auto-mutation of a committed record.** The design *intends* the promoted block to be invisible to the guard and to ride into a commit the operator never framed as containing prior-session content. Multiple readers consume that file; none break, but the "silent by design" posture is itself the coupling — the block's inertness is a standing assumption about every current reader's date-scoping.
- Together: ≥3 implicit dependencies (Step 3.5 shape, the per-id marker two-end lifecycle incl. the un-handled Step C3, the transcript JSONL schema) + a new contract not registered at its coupled sites + silent auto-firing in the orientation path → High.

### Dimension 6: Principle Alignment
**Risk:** Medium

- **DR-7 / AP-7 / OP-9 — the deferral is the CORRECT call (affirmed).** The change's recommended decision — keep `/prime`-gated promotion for v1 and build a SessionStart promotion gate *only if* stub accumulation is later observed — is exactly what DR-7 ("generalize only on a second confirmed consumer") and AP-7 ("no hooks for later") require. There is no observed accumulation yet, so building mechanism #2 now would be speculative. **Do not build the SessionStart gate now.** (principles-base.md lines 30–31, 60, 85.)
- **OP-12 (closure before detection) — Medium tension.** The capture (detection of session state) ships *with* a closure channel (promotion into session-notes), which is OP-12-aligned in principle (principles-base.md line 50). But the blind-spot finding shows the closure is `/prime`-gated while the operator routinely starts with non-`/prime` commands — so for this operator's real usage, capture partially runs *ahead* of a *reliable* closure. The stub is never lost, only its closure is latent; this is a tension, not a clean violation, so Medium.
- **OP-3 / OP-5 — Medium tension (silent auto-commit).** The design deliberately makes the promoted block silent (no mandate, prior-day header) so it "rides silently into the next commit." Auto-writing operator-unreviewed content into a committed record edges against the system's loud-not-silent ethos (OP-3, principles-base.md line 41). The captured content is minimal/mechanical (date, marker, task line), so automating the *capture* is OP-2-aligned ("automate execution"); the *silent commit* of it is the tension.
- **DR-1 / DR-3 (placement) — aligned.** The hook lands in `.claude/hooks/`, the script in `logs/scripts/` alongside the confirmed-existing `check-archive.sh` / `log-archiver.sh` / `split-log.sh` (verified: `logs/scripts/` already hosts these three), the doc registration in `session-marker.md`. Correct homes (principles-base.md lines 54, 56).
- **DR-8 — aligned.** The change correctly self-identifies the gated classes (hook edits, shared-state automation) and is running this plan-time risk-check (principles-base.md line 61).
- Net: no clean principle *violation*; two Medium tensions (OP-12 closure latency, OP-3/OP-5 silent commit) and one strongly-affirmed correct call (DR-7 defer) → Medium.

## Mitigations

Required (one per High dimension; several also tighten the Mediums). Apply before or during landing:

- **Hidden Coupling (High → Medium) — document the Step 3.5 coupling in lockstep.** Add the promotion writer and the `**Auto-captured stub**` block shape (prior-day header, no `**Mandate:**`) to (a) wrap-session.md Step 3.5's `PAIRED CONTRACT` comment (lines 42–49) as a recognized non-foreign writer, and (b) the `docs/session-marker.md` "Two-end contract registry" / "When to update this doc" sections. This converts the silent cross-file dependency into a documented contract a future Step 3.5 editor cannot miss. Treat wrap-session.md as an *edited* file, not merely an "interaction surface."
- **Hidden Coupling (High → Medium) — fix the teardown-recognition assumption.** Do not equate "per-id marker vanished" with "properly recorded." Either (a) gate stub deletion on a positive check that a matching `## {stub-date} — Session {marker}` (or today's) record actually exists in `session-notes.md`, or (b) add the `/handoff` Step C3 marker-removal path (handoff/SKILL.md line 209) to the recognized-teardown set *and* ensure `/handoff` writes the minimal record before removing the marker. Without this, `/handoff`-ended sessions — a real un-wrapped case — silently lose the net.
- **Hidden Coupling / injection (High → Medium) — verify sanitization at build.** Since `auto-session-stub.sh` is not yet present, require the built hook to prove its transcript-text sanitization (leading `#`/backtick strip-or-escape, length cap, and neutralization of `**`/`|`/heredoc-terminator sequences that could corrupt the markdown table or the append heredoc) before the promoted block is ever committed. Run the built hook through a `/qc-pass` that feeds an adversarial transcript.
- **Blast Radius (Medium) — tighten the concurrent double-promote window.** Have `promote-session-stub.sh` re-check the header-exists idempotency guard *immediately before* the append (not only at scan time), and delete the stub as the first post-append action, so a second concurrent promoter finds either the header or no stub. Accept the bounded residual (identical-content duplicate) as documented, not silent.
- **Blast Radius (Medium) — acknowledge the friday-checkup count.** Note in the promotion doc that promoted prior-day headers count toward `friday-checkup.md` line 147's `grep -c "^## "` session-volume gate, so the "inert to all readers" claim is qualified; decide whether the auto-stub block should carry a marker that roll-up readers can exclude.

## Recommended redesign

(Verdict is PROCEED-WITH-CAUTION; this section is advisory context for the posed question, not a required redesign.)

- **On the posed question (build the SessionStart promotion gate now?): No — the defer is correct (DR-7 / AP-7).** Keep `/prime`-gated promotion for v1. Building a second SessionStart promotion mechanism before any stub accumulation is observed is speculative abstraction. Strengthen the defer with one non-speculative addition: make stub accumulation *observable* (e.g., `/friday-checkup` or a one-line `/prime` note counts un-promoted `logs/.session-stub-*` older than N days) so the trigger to build mechanism #2 is data-driven, not memory-dependent — this satisfies OP-12's "close the loop before adding detection" without pre-building the closure.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: settings.json lines 2–33/93–129, prime.md lines 36–49/267–268, wrap-session.md lines 42–49/66/71/252–275/482–488, session-marker.md lines 137–164/219–224, handoff/SKILL.md line 209, check-heavy-tool.sh lines 44–68/112–120, friday-checkup.md lines 146–147/334–338, principles-base.md lines 30–61/85, and grep counts (zero pre-existing `session-stub` consumers; `logs/scripts/` sibling contents). The two `not yet present` files (`auto-session-stub.sh`, `promote-session-stub.sh`) were assessed from described intent per the change description and are flagged as such under Dimension 5. No training-data fallback was used on any read.

---

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

Full advisory on disk: `projects/axcion-ai-system-owner/output/consultations/consult-2026-07-03-risk-check-second-opinion-auto-session-capture-stop-hook.md`

**Q1 — Concur.** PROCEED-WITH-CAUTION and Hidden Coupling = High are both right, and High is understated. The "rides silently" safety is achieved by *evading* wrap-session Step 3.5's exact detector shape — evasion-by-shape is a hidden dependency. The per-id marker it leans on is already `High load-bearing` with a live 2026-06-11 hard-block incident on this exact handoff/wrap asymmetry.

**Q2 — Mitigations b/c/d: yes. (a): the right call** — the "touches neither wrap-session.md nor its copies" win was partly illusory (the design bought leanness by *hiding* a coupling, not removing it). Leaner-and-safe shape: stop depending on Step 3.5 — make the promoted block *positively self-identifying* (a sentinel it already has), register it in `session-marker.md`, and add only a **one-line comment** to wrap-session.md's two copies (no logic → no lockstep-drift risk). (c) is highest-consequence: untrusted transcript → committed file → read by 3 subagents; require adversarial `/qc-pass`.

**Q3 — Record-exists gate is correct AND points to a deeper problem.** The per-id marker already carries 4 meanings; the hook adds a false 5th ("absent ⇒ recorded") — false for `/handoff` C3 and old-CLI. Adopt record-exists and **drop marker-vanished entirely**; do NOT add another marker-mutator dependency. Key on **marker, not date+marker** — else a past-midnight session promotes a duplicate.

**Q4 — Missed risk: efficacy / shifting-the-burden.** It captures a *stub* (date/marker/task line), not the decisions-friction-telemetry whose loss justifies it. A weak net quiets the alarm without restoring the signal, easing pressure to fix the real cause (wrap-skipping). Frame it as "proof a session occurred," keep wrap-skipping on the backlog.

**Q5 — Bottom line: DEFER B to a dedicated, no-concurrency session; build it whole, not reduced.** Reasons: (1) it edits shared settings.json/prime.md/session-marker.md + auto-writes session-notes.md while S9 is live on the same logs (2026-06-11 race surface); (2) the fixes are structural, not patches; (3) it needs a build + fresh-context adversarial QC. Do NOT split capture-now/promote-later (detection ahead of closure). Do NOT build the SessionStart gate; make stub-accumulation observable instead. A and C can proceed now under explicit-path commits.
