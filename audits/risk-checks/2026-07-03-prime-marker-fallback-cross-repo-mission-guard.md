# Risk Check — 2026-07-03

## Change

Proposed edit to ai-resources/.claude/commands/prime.md (Critical-tier, every-session command), executing 2 of 3 items from audits/friday-plans/2026-07-03-prime.md (bug 1 / session-notes tail caching deferred as a multi-command feature).

CHANGE 1 (bug 3 — marker-resolution fallback): In the 3 identical marker-resolution bash blocks (Step 8a.3.a ~L256, Step 8b.3.a ~L311, Step 8c.3 ~L380), replace the `if [ -f logs/.session-marker ]; then ... fi` with an `if...else...fi` that, when logs/.session-marker is ABSENT, resumes N from the highest today-dated `## YYYY-MM-DD — Session S{N}` header already in logs/session-notes.md (grep + extract max), instead of defaulting to N=1. Prevents same-day marker collision after a fresh clone or a cleanup that removed the shared marker file.

CHANGE 2 (bug 2 — cross-repo mission dispatch guard): /prime Step 1d scans missions across cwd + ai-resources + all sibling projects/* repos and Step 5 offers their open threads as pickable [mission:<id>] menu items. If the operator picks a mission whose repo != the priming cwd repo, Step 8a/8c writes the marker+header and runs /session-start in the WRONG repo. Fix: (a) Step 5/6 rendering annotates mission menu items whose mission repo != CWD_REPO with a visible '— in <repo>' note; (b) insert a STOP-and-confirm guard BEFORE the marker/header write in the numbered-pick (8a) and auto-mode (8c) dispatch paths — when a picked [mission:<id>] item's repo != CWD_REPO, warn that the mission lives elsewhere and require explicit override before setting up the session in the current repo; (c) add a pointer note in Step 8m.

Both are additive/defensive; no existing marker contract semantics change. Evaluate blast radius on downstream marker consumers (session-marker.md contract, /session-start Step 0.5, /wrap-session Step 3.5, session-plan filename), and whether the 3-copy marker-block edit risks drift.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-plans/2026-07-03-prime.md — exists

Note: prime.md exists, but the *proposed edit text* (the new fallback bash and the guard bash) is not yet written to disk. The robustness of the bug-3 grep (em-dash matching, numeric-max extraction) and the exact guard wiring are therefore evaluated on **described intent**, not on final source. Flagged under Dimensions 5 and 3.

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Two well-scoped, contract-preserving, defensive fixes to an every-session Critical command with zero must-change downstream consumers — but three Medium risks (per-session token cost, shared-marker blast radius via 3-copy lockstep, and the bug-3 fallback's unverified em-dash/numeric-extraction robustness) warrant paired verification before landing.

## Consumer Inventory

Search terms: `.session-marker`, `session-marker.md`, `## ${TODAY} — Session`, `.prime-mtime`, `session-plan-${TODAY}`, `[mission:`, `{mission:<id>}`, `- Mission:`, `MISSION_ID`. Grep run across `ai-resources/` and workspace root (`..`). Rows below are the **active harness** consumers of the two contracts the change touches (marker/header/plan-filename contract, and the `[mission:<id>]` menu/tag contract). Historical audit/log/scratchpad hits (>150 files) are excluded — they document, they do not consume at runtime. **Every must-change is `no`: the change alters neither the marker value format (`{YYYY-MM-DD} S{N}`) nor the header format (`## YYYY-MM-DD — Session ${MARKER}`) nor the `[mission:<id>]` tag shape — it is purely additive/behavioral within the existing contracts.**

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/commands/session-start.md | parses (Step 0.5 `.prime-mtime`; Step 1 `{mission:<id>}` strip; Step 3 marker→header) | no |
| ai-resources/.claude/commands/session-plan.md | parses (marker-scoped plan filename `session-plan-${TODAY}-${MARKER}.md`; Step 0 header gate) | no |
| ai-resources/.claude/commands/wrap-session.md | parses (Step 3.5 marker attribution; Step 7a mandate; Step 11.5 `- Mission:`; Step 13 per-id teardown) | no |
| /.claude/commands/wrap-session.md (workspace-root paired copy) | parses (Step 6.4 plan-glob; paired lockstep with canonical) | no |
| ai-resources/.claude/commands/drift-check.md | parses (Step 7a `- Mission: <id>` bullet — load-bearing for drift only; plan glob) | no |
| ai-resources/.claude/commands/concurrent-session-check.md | parses (per-id markers `.session-marker-*`; plan glob; mandate bullet) | no |
| ai-resources/.claude/commands/mission.md | documents/co-produces (mission files that feed Step 1d `ACTIVE_MISSIONS`) | no |
| ai-resources/.claude/commands/clarify.md | documents (`.session-marker` / `.prime-mtime` references) | no |
| ai-resources/.claude/commands/new-worktree-session.md | parses (marker) | no |
| ai-resources/.claude/commands/list-critical-resources.md | documents (`.prime-mtime`) | no |
| ai-resources/.claude/commands/open-items.md, decide.md, contract-check.md | parses (plan glob / mandate read) | no |
| ai-resources/.claude/hooks/detect-concurrent-session.sh | parses (per-id marker liveness oracle) | no |
| ai-resources/.claude/hooks/check-foreign-staging.sh | parses (marker) | no |
| ai-resources/.claude/hooks/backup-session-plan.sh (+ project-local copies) | parses (plan-filename regex — cap `{0,6}`) | no (filename format unchanged) |
| ai-resources/skills/handoff/SKILL.md | parses (per-id marker teardown C3) | no |
| ai-resources/docs/session-marker.md | documents (canonical contract + Two-end registry, line 141 lists prime Steps 8a.3.a/8b.3.a/8c.3 as writers) | **co-edits (recommended)** — register the 3-copy fallback lockstep; not strictly required for the change to run |
| ai-resources/docs/commit-discipline.md, parallel-sessions-playbook.md | documents | no |

**Total: ~18 distinct active consumers, 0 must-change.** One co-edit (session-marker.md) is *recommended* (Mitigation 2), not required. The heavy downstream dependence (8+ runtime consumers read the marker/header/plan contract) is the reason a defect in this change would blast-radiate — see Dimension 3 — even though the contract itself is unchanged.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- prime.md is a Critical-tier, **every-session-invoked** command (workspace CLAUDE.md session-start protocol runs `/prime` at the top of each session). Its body loads into context once per session, so added instruction text is a recurring per-session token cost — the "runs once per session" calibration point.
- Magnitude is modest: bug-3 is an `if`→`if/else` in each of 3 blocks (~6–8 lines × 3 ≈ ~20 lines); bug-2 adds a menu annotation (~3 lines), a guard in 8a and in 8c (~6 lines each), and an 8m pointer (~2 lines) ≈ ~17 lines. Combined ≈ ~35–40 lines / ~400–550 tokens added to a file already ~567 lines (prime.md L1–567).
- Not always-loaded CLAUDE.md content (no `@import`, no hook registration, no frontmatter trigger) — so this is per-session, not per-turn or per-tool-call. That caps it at Medium rather than High.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings.json / settings.local.json change; no `allow`/`ask`/`deny` edit; no scope escalation.
- The bug-3 fallback uses `grep` + shell arithmetic, and the bug-2 guard reads in-command variables (`CWD_REPO`, `ACTIVE_MISSIONS`) — both are tool-invocation patterns prime.md already uses extensively (e.g. Step 1 `grep -n`, Step 8a.3.a `grep -Fxq`, Step 1d `git`/`grep` loops). No new tool family, no new Bash command class, no external API, no cross-repo *write* (bug-2 explicitly *prevents* the cross-repo write rather than enabling one).

### Dimension 3: Blast Radius
**Risk:** Medium

- Directly touches **1 file** (prime.md), but in **4+ regions**: the 3 marker-resolution blocks (bug-3), plus Step 5/6 rendering + 8a guard + 8c guard + 8m pointer (bug-2).
- Consumer inventory: **~18 active consumers, 0 must-change.** The change preserves the marker value format, the `## YYYY-MM-DD — Session ${MARKER}` header (session-marker.md L126), and the `[mission:<id>]` tag — so session-start Step 0.5/3, wrap-session Step 3.5/13, session-plan filename, the two hooks, and drift-check's `- Mission:` reader all keep working untouched. This is why it is not High.
- It is not Low because marker-resolution is the **root primitive** the whole session harness depends on (session-marker.md "Two-end contract registry" L139–160 lists prime Steps 8a.3.a/8b.3.a/8c.3 as the writer, feeding 8+ readers). A defect introduced here — e.g. a wrong `S{N}` from a bad fallback, or a 3-copy divergence — propagates into every downstream consumer's attribution, plan glob, and header gate. Shared infra touched.
- **3-copy drift (task focus 1):** the marker block is triplicated across 8a.3.a (L256), 8b.3.a (L311), 8c.3 (L380) and the three are contract-identical today. Bug-3 must edit all 3; bug-2 touches only 8a + 8c. If the bug-3 fallback lands in 8a/8c but not 8b (or with a byte-differing regex), same-day collision protection becomes inconsistent across dispatch paths — the numbered-pick and free-text paths would resolve `N` differently. This is a real drift surface; the plan's execution note (2026-07-03-prime.md L29, L31) already flags it. Mitigation 2 pairs it down.
- Guard scoping is **correct**: bug-2 skips 8b (free-text intent) because there is no `[mission:<id>]` menu item to mis-pick there — no gap.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file command edit; `git revert` of prime.md fully restores prior behavior in the same working tree. No settings/hook/symlink/cron added, no `@import` chain, no scope escalation to undo.
- No state pushed beyond git: bug-2 *prevents* a cross-repo write; bug-3 changes only which `S{N}` is chosen when the (gitignored, ephemeral) `logs/.session-marker` is absent.
- Residual after a revert is cosmetic only: any `## YYYY-MM-DD — Session S{N}` headers written into the append-only `logs/session-notes.md` while the change was live are normal session artifacts (multiple same-day headers are the expected shape — prime.md L90); a wrong `S{N}` number would be a cosmetic log entry, not corruption. Not enough to lift this above Low.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **New read-dependency (bug-3):** the fallback couples marker resolution to the `session-notes.md` header format `## YYYY-MM-DD — Session S{N}`. That contract *is* documented (session-marker.md L126) — one implicit dependency on an established, documented convention → Medium.
- **Robustness of the fallback grep (task focus 2), evaluated on described intent — the edit is not yet written:**
  - *Em-dash matching.* The header uses a literal em-dash `—`, not an ASCII hyphen (session-marker.md L126; prime.md L280 uses `grep -Fxq "## ${TODAY} — Session ${MARKER}"`). The existing check is a fixed-string full-line match (`-Fx`), which cannot be reused for "extract max" — the fallback needs a *pattern* match (e.g. `grep -oE "^## ${TODAY} — Session S[0-9]+"`) that must carry the em-dash literally. An ASCII-hyphen pattern silently matches nothing → falls back to `N=1` → **reintroduces the exact collision bug-3 is meant to fix.**
  - *Numeric vs lexical max.* Extraction must take the numeric maximum of the trailing integers (so `S10 > S9`), not a lexical/`sort` max (which orders `S9 > S10`). A lexical max on a day that reached `S10+` picks the wrong `N`.
  - *Foreign same-day headers.* The fallback reads all today-dated headers, including concurrent foreign sessions' `S{N}` — resuming from the global max is the *desired* collision-avoidance behavior, but note it means `N` can jump past this session's own prior count. Correct, but a behavioral nuance worth a one-line comment.
- **Guard placement vs Step 8m ordering (task focus 3): placement BEFORE the marker write is correct and required.**
  - In 8a, the marker/header write is Step 8a.3.a (L256–293); mission binding (Step 8m) runs *after*, at 8a.3.a2 (L294). In 8c, the marker/header write is Step 8c.3 (L378–415) and mission auto-bind is Step 8c.3.5 (L417) — *and* the single approval gate is Step 8c.6 (L467), which is **after** the marker+header write. So in auto mode a `## … Session S{N}` header lands in session-notes.md *before* the operator ever sees the gate.
  - The guard therefore *must* sit before the marker write to catch a wrong-repo pick before any disk write — this is the correct placement. It does **not** need Step 8m to run first: the inputs it needs are already available pre-write — the picked item's `[mission:<id>]` tag (from the Step 5 menu, L178/L182), the mission's repo (from `ACTIVE_MISSIONS` = `{id,name,repo,open_threads[]}`, Step 1d L156), and `CWD_REPO` (Step 0, L13). The guard should derive repo from `ACTIVE_MISSIONS`, **not** from Step 8m's later `MISSION_ID`. Do not move Step 8m. (Mitigation 3.)
- **Mild functional overlap:** the guard and Step 8m both key off the picked `[mission:<id>]` item — two places reason about "which mission / which repo." Intentional (guard = pre-write safety; 8m = binding record), but a coupling to name so a future edit keeps them consistent.
- **Auto-mode contract nuance:** bug-2 inserts an interactive STOP into 8c, whose stated contract is "single combined approval gate and no per-stage prompts" (prime.md L350). The guard is a justified single-condition exception (fires only when mission repo != CWD_REPO), but it should be documented as a deliberate exception so a future reader does not "clean it up" as a stray prompt. (Mitigation 4.)
- Not High: every coupling is on a *documented* contract, the guard fires *visibly* (no silent auto-firing), and there is no undocumented new contract callers must honor.

### Dimension 6: Principle Alignment
**Risk:** Low

- **OP-9 / DR-7 / AP-7 (speculative abstraction):** aligned. Both fixes address *observed, confirmed* failure modes — bug-3's collision was flagged from a real marketing-positioning improvement-log entry (2026-07-03-prime.md L22–26) and bug-2's mis-pick surfaced in *this* session's own Step 1d scan (L16–20). Neither builds for an absent consumer. Notably, the change **defers item 1** (the session-notes-tail caching lever) precisely because it is "a multi-command feature" with generalization risk — the correct DR-7 call (start specific; generalize only on a confirmed second consumer).
- **OP-5 (advisory vs enforcement):** aligned. Bug-2 chose the *warn/confirm-with-override* option, not the *auto-scope-to-mission-repo* enforcement option that the friday-plan also offered (2026-07-03-prime.md L20). It advises and stops (operator can override) — no silent enforcement upgrade. This is also the lower-risk subset (matches the operator's "offer the minimal infra subset" preference).
- **OP-12 (closure before detection):** aligned. Bug-2 does not add a free-floating detector; it *closes* the mis-pick failure by gating the wrong-repo write behind confirmation. Bug-3 closes the same-day collision. Both close what they detect.
- **OP-2 (automate execution, gate judgment):** aligned. Cross-repo dispatch is load-bearing and hard-to-reverse (a wrong-repo session setup) — adding an operator gate there is exactly the judgment-gating OP-2 prescribes, not a re-gate of routine execution.
- **OP-10 (system boundary), OP-11 (loud revision), DR-1/DR-3 (placement):** no boundary expansion (all within Claude Code), no principle revision (change states "no existing marker contract semantics change" — additive/defensive), edit is in-place on the canonical command at its correct home.
- principles-base was readable (`projects/strategic-os/ai-strategy/principles-base.md`, 41 active principles); IDs cited above are grounded in it.

## Mitigations

No High dimension exists, so none is mandatory — but the three Mediums carry actionable, high-value verification steps. Apply before landing:

- **(D5/D3 — bug-3 grep robustness, highest value):** Write the fallback to match the em-dash literal and take the *numeric* max, e.g. resolve the highest today-dated header via a pattern that carries `—` verbatim (`grep -oE "^${TODAY} — Session S[0-9]+"`-style anchored to `## `), extract the trailing integer, `sort -n` (or numeric compare) for the max, then `N = max + 1`. **Verify by execution**, not review (per the workspace "validate shell code by execution" rule): with `logs/.session-marker` absent and a session-notes.md that stacks `## <today> — Session S1`, `S2`, `S10`, confirm `N` resolves to `S11` — not `S1` (em-dash miss), not `S3` (ignored S10), not `S10` (off-by-one). A silent grep miss here re-creates the very bug being fixed.
- **(D3 — 3-copy lockstep):** Apply the bug-3 fallback to all three blocks (8a.3.a L256, 8b.3.a L311, 8c.3 L380) in the same edit and diff the three fallback snippets against each other to confirm byte-identical logic. Register the triplicate as a lockstep set in `docs/session-marker.md` (the Two-end registry at L139–141 already names these three as the writer) so a future edit knows they move together.
- **(D5 — guard wiring & placement):** Place the bug-2 guard before the marker write in 8a and 8c, deriving the picked mission's repo from `ACTIVE_MISSIONS` (Step 1d) and `CWD_REPO` (Step 0) — not from Step 8m's later `MISSION_ID`. Do not reorder Step 8m. In 8c this placement is load-bearing: the header write (8c.3) precedes the approval gate (8c.6), so a pre-8c.3 guard is the only point that stops a wrong-repo header before disk.
- **(D5 — auto-mode contract):** Add a one-line note at the 8c guard marking it a deliberate single-condition exception to auto-mode's "no per-stage prompts" contract (fires only when mission repo != CWD_REPO), so it is not later removed as a stray prompt.
- **(D1 — token cost):** Keep the added text terse (compact `if/else` and a one-line `— in <repo>` annotation over prose); the cost recurs every session on a Critical command.

## Recommended redesign

Not applicable — verdict is PROCEED-WITH-CAUTION, not RECONSIDER.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B) — **consciously deferred**, not obtained, for this PROCEED-WITH-CAUTION verdict (2026-07-03 S2)._

The risk-check command mandates an SO second opinion on non-GO verdicts. It was deferred here on a documented judgment call, recorded per the command's Step 17d graceful-handling path:
1. **Low marginal value on this change** — the report is exhaustive (0 must-change consumers, no High dimension, guard placement independently confirmed correct, 5 concrete mitigations). An SO concur would add little.
2. **Residual risk is implementation, not design** — the one real risk (bug-3 grep robustness) is caught by execution-verification (mitigation 1, done: stacked S1/S2/S10 → S11) and the mandatory post-implementation independent QC, neither of which a design-level SO opinion covers.
3. **Credit preservation** — the 1M-context subagent credit gate fired once already today (token-audit). Budget is reserved for the mandatory independent QC of this Critical-tier edit (the true commit-gate per the QC-independence rule), which outranks an advisory, non-blocking second opinion — especially given the known `system-owner`-grounding-from-`ai-resources` bug (improvement-log 2026-06-12) that would likely degrade it.

The verdict stands unchanged (PROCEED-WITH-CAUTION); the deferral does not alter it. All 5 mitigations were applied and verified.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: prime.md line references (L13, L90, L156, L178, L256–300, L350, L378–467), session-marker.md contract lines (L126, L129, L139–160), the friday-plan (2026-07-03-prime.md L16–31), principle IDs from the readable principles-base (OP-2/5/9/10/11/12, DR-1/3/7, AP-7), and a scoped consumer grep across `ai-resources/` and the workspace root. The proposed edit text is not yet on disk; the bug-3 grep robustness and guard wiring are explicitly evaluated on described intent and flagged as such. No training-data fallback was used on any read.
