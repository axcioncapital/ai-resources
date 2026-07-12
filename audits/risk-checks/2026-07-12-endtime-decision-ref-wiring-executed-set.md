# Risk Check — 2026-07-12

## Change

END-TIME GATE — the executed change set (2026-07-12 S5). Wire the run-manifest's `decisions_refs` field so it is actually populated at wrap. PLAN-TIME GATE SAW: a `--decision-ref` flag call added to both paired wrap-session.md copies, a `{date}-{marker}` ref format, and explicitly NO change to run-manifest.sh (verdict: PROCEED-WITH-CAUTION). WHAT ACTUALLY SHIPPED: (1) NEW `logs/scripts/decision_ref_slug.py` — the single definition of the anchor-slug algorithm, 14-assertion self-test incl. a collision proof and a negative control. (2) `logs/scripts/run-manifest.sh` MODIFIED (plan-time said no change) — new `--decision-ref-from-header` flag takes a decisions.md header line verbatim, shells to decision_ref_slug.py, appends `logs/decisions.md#{slug}`; on an underivable slug it emits an advisory note and DROPS that one ref, exit 0. (3) NEW `logs/scripts/check-decision-refs.sh` — validates a manifest's decisions_refs resolve to real headers across decisions.md + all monthly archives; imports slug() from the module (no second implementation); exits 0 on absent manifest / no marker / unreadable manifest / empty decisions_refs / MISSING MODULE; exits 1 only on an orphan ref. (4) BOTH paired wrap-session.md copies (canonical Step 12d + workspace-root Step 4.7) now call `--decision-ref-from-header` with the header pasted verbatim instead of a hand-derived slug, AND newly call check-decision-refs.sh at every wrap wrapped in `|| true`, report-only. (5) `docs/spine-schemas.md` § 1 ref-format subsection now documents the code rather than defining a prose recipe; the `-2`/`-3` de-dup step was DELETED (it generated refs resolving to nothing). (6) Ref format CHANGED from the gated `{date}-{marker}` to a slug of the decision's header text, because the plan-time gate itself proved `{date}-{marker}` collides on two real `## 2026-07-12 (S4)` headers in decisions.md. (7) Records updated: decisions.md (2 new S5 entries), improvement-log.md, missions/w32-migration-execution.md, redesign repo's remediation-register.md + packets/R3-run-manifest.md. NOT IN SCOPE: R3 Pass 2 itself (the wrap-note cut); changing wrap Step 5's skip-if-routine rule.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/decision_ref_slug.py — exists (NEW)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/check-decision-refs.sh — exists (NEW)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/run-manifest.sh — exists (MODIFIED)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/run-manifest.test.sh — exists (pre-existing regression suite; still 24/24 after the change)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists (MODIFIED, Step 12d)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md — exists (MODIFIED, Step 4.7 — PAIRED CONTRACT mirror)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/spine-schemas.md — exists (MODIFIED, § 1)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/decisions.md — exists (2 new S5 entries at end)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/runs/2026-07-12-S5.json — exists (live manifest, decisions_refs populated)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-07-12-wire-decision-ref-into-wrap-session-manifest-close.md — exists (plan-time report)

## Verdict

RECONSIDER

**Summary:** The specific defect the session set out to fix (the ref-collision and the false-closure framing) is genuinely fixed and independently re-verified here, but the executed set grew past the plan-time boundary in exactly the two ways that raise this gate's mechanical dimensions to High — a wider, cross-repo consumer set including a regression suite that was never extended to cover the new surface, and two confirmed (not hypothetical) silent-failure coupling paths in the new script-to-script wiring — and two High dimensions force RECONSIDER regardless of how clean the individual pieces look in isolation.

## Consumer Inventory

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/wrap-session.md` Step 12d | invokes (edit target — `close` + new checker call) | yes |
| `.claude/commands/wrap-session.md` (workspace-root) Step 4.7 | co-edits (PAIRED CONTRACT — verbatim port) | yes |
| `ai-resources/logs/scripts/run-manifest.sh` | invokes `decision_ref_slug.py` via `python3 "$(dirname "$0")/..."` (L96); this file itself was modified | yes |
| `ai-resources/logs/scripts/decision_ref_slug.py` | new — THE definition, consumed by run-manifest.sh and check-decision-refs.sh | n/a (new artifact) |
| `ai-resources/logs/scripts/check-decision-refs.sh` | new — imports `slug()` from decision_ref_slug.py (L59); invoked by wrap-session.md L263/239 | n/a (new artifact) |
| `ai-resources/logs/scripts/run-manifest.test.sh` | parses/tests `run-manifest.sh`'s behavioral contract (pre-existing 24-case regression suite) | **yes — gap: not extended.** Zero test cases mention `decision-ref` (grep confirms); the new flag and the new checker script have no dedicated regression coverage at all |
| `ai-resources/docs/spine-schemas.md` § 1 | documents (defines the `decisions_refs` ref-format contract) | yes |
| `ai-resources/logs/decisions.md` | parses (ground-truth headers the slug is derived from) + documents (2 new S5 entries) | yes |
| `ai-resources/logs/improvement-log.md` | documents (backlog item marked applied, framed as 1-of-2) | yes |
| `ai-resources/logs/missions/w32-migration-execution.md` | documents (reopen criteria now two conditions) | yes |
| `projects/axcion-ai-system-redesign/output/implementation-prep/remediation-register.md` | documents (R3 row, cross-repo) | yes |
| `projects/axcion-ai-system-redesign/output/implementation-prep/packets/R3-run-manifest.md` | documents (Pass 2 reopen criteria, cross-repo) | yes |
| `ai-resources/logs/session-notes.md` | documents (session note) | yes |
| `ai-resources/logs/session-plan-2026-07-12-S5.md` | documents (new session plan) | yes (new, consistent) |

Total: 14 consumers, 12 must-change (2 rows are freshly-created artifacts, not modification targets). This is wider than the plan-time inventory (9 consumers, 6 must-change) on two axes the plan-time gate explicitly did not anticipate: (a) `run-manifest.sh` itself is now a touched, must-change file — plan-time's scope line said explicitly "no change to run-manifest.sh"; (b) the change now spans **three separate git repositories** — confirmed independently: `git status` in `ai-resources` shows 6 modified + 5 new/untracked files; in the workspace root, `.claude/commands/wrap-session.md` modified; in `projects/axcion-ai-system-redesign`, `remediation-register.md` and `packets/R3-run-manifest.md` modified — none of the three yet committed.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file (CLAUDE.md) touched.
- The additions to `wrap-session.md` live inside the existing once-per-session Step 12d/4.7 (not a new hook, not per-tool-call). Two new Bash invocations are added to that step (the `close` call with more flags, plus the checker call at L263/239) — a small, bounded, once-per-wrap addition, not a growth in per-turn or always-loaded cost.
- The checker's stdout is surfaced in chat per the instruction ("Surface its output in chat") — verified output is short and proportional to decision count (2 lines + a summary line for this session's 2 refs, empirically confirmed by running the checker directly).
- No new `@import`, no new subagent spawn, no new skill trigger.

### Dimension 2: Permissions Surface
**Risk:** Low

- `git status --short` in `ai-resources` and the workspace root confirms neither `.claude/settings.json` nor `.claude/settings.local.json` appears in the changed-file list in either repo — no permission-surface edit of any kind.
- The two new scripts use only already-authorized patterns: `bash <script>` and `python3 <script>` invocations, already exercised extensively by the pre-existing `run-manifest.sh` (17 python3 heredoc/`-c` calls in the unmodified portions of the file).
- No new Write path, no external API, no cross-tool capability introduced.

### Dimension 3: Blast Radius
**Risk:** High

- Per the Consumer Inventory above: **14 consumers, 12 must-change** — over the ">5 dependent callers" High threshold by a clear margin, and wider than plan-time's own 9/6 count.
- `run-manifest.sh` is now a **must-change** consumer that plan-time explicitly scoped out ("explicitly NO change to run-manifest.sh" per the change description's own framing of what plan-time saw) — the executed set crossed a boundary plan-time's gate never evaluated.
- **Regression-suite gap, confirmed by direct execution:** `grep -n "decision-ref" logs/scripts/run-manifest.test.sh` returns zero matches. The pre-existing 24-case Level 1+2 suite (spine-schemas.md § 4's mandatory floor for "hooks, settings, scripts") was not extended to cover the new `--decision-ref-from-header` flag or either new script. The 24/24-pass claim is real (re-ran it: `RESULT: 24 passed, 0 failed`) but it is 24/24 on the *old* surface — it says nothing about the new one.
- Cross-repo footprint confirmed empirically: uncommitted changes sit in three separate git roots simultaneously (`ai-resources`, workspace root, `axcion-ai-system-redesign`) — verified via `git status --short` in each. A change whose bookkeeping claims ("P1 CLOSED") live in a third repo that could be committed out of sync with the code repo is a wider footprint than a single-repo change.
- Positive finding, not a mitigant for the score but relevant to net risk: every must-change consumer that *was* touched is internally consistent (verified below, Dimension 6 / false-closure check) — the breadth is real, but nothing found is currently broken.

### Dimension 4: Reversibility
**Risk:** Medium

- Nothing is committed yet (per the task framing and confirmed by `git status` showing modified/untracked, not staged-and-committed, in all three repos) — today, "reversal" is simply discarding uncommitted changes, which is clean in all three trees.
- Once committed, the code-side files (`decision_ref_slug.py`, `check-decision-refs.sh`, the `run-manifest.sh`/`wrap-session.md`/`spine-schemas.md` diffs) are cleanly `git revert`-able.
- `logs/runs/2026-07-12-S5.json` is a new durable data artifact carrying the new ref format; every wrap from this point forward writes new `decisions_refs` values under the new algorithm. A revert of the code does not retroactively rewrite already-closed manifests — this is the same append-only-artifact shape plan-time already flagged (Medium, not High: one extra cleanup pass, not a multi-step external rollback). Confirmed still live: `logs/runs/2026-07-12-S1.json`'s hand-authored ref remains an orphan today (`check-decision-refs.sh` run against it returns exit 1, 0/1 resolve) — it was correctly left alone (out of scope), but it is a standing example of the exact "revert doesn't clean this up" residue this dimension flags.
- New consideration versus plan-time: the change is uncommitted across **three git repos** right now. A full, coordinated revert (or a partial commit that leaves one repo behind) is an extra sequencing step beyond a single-repo change — not an external push/API-write shape (nothing has been pushed), so this stays Medium rather than High.

### Dimension 5: Hidden Coupling
**Risk:** High

Two implicit dependencies were tested directly (not assumed) and both fail silently rather than loudly:

- **Path-resolution coupling is symlink-fragile — confirmed by direct test.** `run-manifest.sh` L96 does `python3 "$(dirname "$0")/decision_ref_slug.py"`. I invoked `run-manifest.sh` through a symlink pointing at the real file, from a directory that does **not** contain `decision_ref_slug.py`: `dirname "$0"` resolved to the **symlink's** directory (bash does not follow the link when populating `$0`), the module lookup failed, and the ref silently dropped with only an advisory line — `decisions_refs` came back `[]` for a header that resolves cleanly in the real location. Today this is **dormant**, not live: `wrap-session.md`'s ancestor-walk-up (L241-246 canonical / L217-222 root) always resolves an absolute, non-symlinked path, and `find` across the repo confirms `run-manifest.sh` is not currently symlinked anywhere outside `ai-resources/logs/scripts/`. But it is an untested, undocumented assumption (the script's own comments address the *execute-bit* symlink case explicitly — L337-341 — but never the *path-resolution* case), on a repo that already has a live precedent for symlinking shared scripts across projects (`auto-sync-shared.sh`, currently scoped to commands/agents only — but the pattern exists).
- **Unguarded read path in the validator — confirmed by code inspection, not yet exercised.** `check-decision-refs.sh`'s header-indexing loop (`for path in ['logs/decisions.md'] + glob(...)`) opens each file with `encoding='utf-8'` inside a bare `with open(...)` — no try/except. The script's own design intent, stated in its comment (L54-56), is "if the module is gone, DEGRADE — do not traceback... a stack trace there is noise in the highest-traffic command in the repo" — but that hardening was applied only to the `ImportError` path, not to this read loop. A non-UTF-8 byte in `decisions.md` or any `decisions-archive-*.md` would raise an uncaught exception here. This would **not** block the wrap (the outer `[ -n "$RM" ] && bash ... || true` at L263/239 catches any non-zero exit unconditionally — verified: `A && B || true` is 0 regardless of B's exit code), but it would print a raw Python traceback into wrap chat output instead of the clean advisory line the script's own design principle calls for elsewhere.
- Both are genuinely new couplings introduced by the fix itself, on an executable-surface change explicitly subject to spine-schemas.md § 4's mandatory Level-1+2 floor — and neither is covered by any test (Dimension 3's regression-suite gap and this finding are the same underlying gap, viewed from two dimensions).
- Credit where earned: the coupling this change was built to *remove* — three independent implementations of the slug algorithm — is genuinely gone. `grep` confirms `slug()` is defined once (`decision_ref_slug.py`) and imported, never re-implemented, by `check-decision-refs.sh`; `spine-schemas.md` § 1 explicitly defers to the module rather than restating the algorithm. That is real, and it is the opposite of a coupling problem — it is why the collision defect and the header-format inconsistency plan-time flagged are both empirically resolved (14/14 self-test incl. the collision proof; 265 headers indexed across 4 files; 2/2 resolve on the live manifest).

### Dimension 6: Principle Alignment
**Risk:** Medium

- **OP-12 (closure before detection) — real tension, loudly acknowledged, not a clean violation.** `check-decision-refs.sh` is new detection with no automated closure channel — an orphan ref is surfaced in chat and must be fixed by a human, there is no auto-repair. Against that: it is explicitly, permanently advisory by design (its own header cites this directly: "ADVISORY, NEVER A GATE (principles.md § OP-5)... Do not 'harden' this"), and it exists specifically to supply the *payload* evidence the S4 decision already identified as missing ("measured by payload, not by whether it closed") — i.e., it is evidence-gathering for an already-recorded gate, not a freestanding new scan. Score Medium: real OP-12 tension, but named and bounded rather than silent.
- **OP-9/AP-7/DR-7 (speculative abstraction) / complexity-budget gate — cleanly passed, worth crediting.** Two new files were added. Applying `docs/ai-resource-creation.md` rule #7: prong (a), net simplification — YES, three separate implementations of one algorithm (prose recipe, model hand-derivation, a planned second Python copy) collapse into one canonical function consumed by both writer and validator; prong (b), cited written evidence — YES, "three of three hand-authored refs were orphans" is concrete, on-disk evidence (the module's own docstring, `spine-schemas.md`, and `decisions.md` S5 entries all cite it). Passes both prongs — this is not speculative infrastructure.
- **DR-7 zero-consumer tension — unchanged from plan-time, not escalated.** `decisions_refs` still has no real downstream reader (R4/M-D2/PJ unbuilt); the only named consumer, R3 Pass 2, remains on HOLD pending a second, unrelated prerequisite. This is the same already-adjudicated Medium tension plan-time scored, carried forward, not worsened.
- **OP-3 / false-closure — verified honored, no violation found.** Checked every touched record (`decisions.md` ×2 new entries, `improvement-log.md`, `missions/w32-migration-execution.md`, `remediation-register.md`, `packets/R3-run-manifest.md`, `session-plan-2026-07-12-S5.md`) for the specific failure mode the operator flagged: all consistently frame this as closing **one of two** Pass-2 prerequisites, never "prerequisite met" or "Pass 2 unblocked." No instance of false closure found anywhere in the executed set.
- **OP-5 (advisory/enforcement) — preserved, verified.** `run-manifest.sh`'s pre-existing advisory rule (absent=routine, malformed=loud-but-non-blocking) is untouched; the new checker call is bulletproofed against blocking (`|| true`, verified as unconditionally exit-0 regardless of the checker's own exit code).
- **Placement (DR-1/DR-3)** — clean; both new scripts land beside the file they extend (`logs/scripts/`), consistent with existing convention.

Net: no clean High-severity principle violation. The one real tension (OP-12) is loudly named at the change site rather than silently drifting — scored Medium, not High.

## Recommended redesign

Two dimensions score High on technical grounds (Blast Radius, Hidden Coupling) — not on a principle violation — so per the synthesis rule, this is RECONSIDER regardless of how clean the individual pieces are. The path here is **narrow the commit boundary and close the two confirmed test gaps before landing**, not a rearchitecture — the design itself (single-source slug, header-text ref format, advisory-preserving wiring) is sound and should be kept:

- **Split the commit.** Land the wiring that plan-time actually reviewed and approved (the `--decision-ref-from-header` flag + collision fix + both `wrap-session.md` copies + `spine-schemas.md`) as one commit. Hold `check-decision-refs.sh` and its wrap-time invocation as a **separate, immediately-following commit** with its own targeted regression test — this keeps the two confirmed Hidden-Coupling gaps (symlink path resolution, unguarded encoding read) scoped to the smaller, newer surface rather than folded into the same commit as the already-approved fix, and gives each its own clean revert boundary.
- **Close the two confirmed test gaps before either commit lands.** Add to `run-manifest.test.sh` (or a new `check-decision-refs.test.sh`): (a) a case invoking `run-manifest.sh` through a symlink from a directory without `decision_ref_slug.py` co-located, asserting the ref drops with an advisory note rather than assuming the ancestor-walk-up always prevents this; (b) a case feeding `check-decision-refs.sh` a non-UTF-8 byte in a decisions-archive file, either wrapping the read loop in the same try/except pattern already used for the `ImportError` case, or asserting the current traceback-on-bad-encoding behavior is an accepted, documented residual (rather than leaving it untested and unmentioned). This directly closes the spine-schemas.md § 4 Level-1+2 floor gap for the executable surface actually shipped, and is exactly the "measure by payload, not by whether it closed" discipline this session already applied to `decisions_refs` itself — applied one level down, to the checker's own test coverage.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references, verbatim quotes, grep counts, and hands-on execution (self-tests re-run, `check-decision-refs.sh` re-run against both the live S5 manifest and the still-orphaned S1 manifest, a symlink-invocation test, a broken-module test, an absent-module test, a minimal-PATH test, and a `git status` check across all three touched repos — all performed independently in this review, not taken on the session's report alone). No training-data fallback was used on fetch/read failures.
