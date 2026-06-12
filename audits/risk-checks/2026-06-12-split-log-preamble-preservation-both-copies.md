# Risk Check — 2026-06-12

## Change

Extend split-log.sh (both copies: canonical logs/scripts/split-log.sh + research-workflow template copy) so the active-file rewrite preserves the full preamble (lines 1..first-real-header-1) instead of keeping only H1 — closing a demonstrated silent data-loss defect (preamble content between H1 and the first entry header is currently neither kept nor archived; 15 lines would be lost on axcion-brand-book/logs/decisions.md, and 2 lines were already lost today on marketing-positioning/logs/session-notes.md at S4's archival). The rewrite strips any existing `^> Archive: [` pointer lines from the preamble before appending the fresh pointer (idempotency — exactly one pointer after any number of runs). Change class: automation with shared-state effects — split-log.sh is invoked by /log-sweep archival across all 16 project scopes and mutates active log files. Already landed this session (same script, operator-approved mandate): fence-aware header scan (fenced `## ` lines no longer treated as entry headers). Verification plan: isolated-copy tests only — synthetic fence/preamble cases, real brand-book file copy, byte-stable preamble across runs 2 AND 3, pointer asserted against the real emitted format `> Archive: [basename](basename)`, zero-preamble and pointer-only-preamble edges, line-count reconciliation (no content loss). Consumers of archived logs read only the tail (/prime last-entry, check-archive.sh bottom-10), never the preamble. Independent /qc-pass gate before commit. SO advisory on disk: projects/axcion-ai-system-owner/output/consultations/consult-2026-06-12-split-log-preamble-loss.md (recommends this change; directed this risk-check).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/split-log.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/logs/scripts/split-log.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/logs/decisions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/marketing-positioning/logs/session-notes.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/output/consultations/consult-2026-06-12-split-log-preamble-loss.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A small, structural bug-fix that closes a demonstrated silent data-loss defect in shared-state log automation; risk is concentrated in the new pointer-strip regex and the two-copy lockstep, both fully mitigable with the operator's already-planned isolated-test fixture and a byte-identical-copy assertion.

## Consumer Inventory

The change edits two files. The other 14 per-project `logs/scripts/split-log.sh` copies found by grep are **dormant deployed siblings** — `/log-sweep` always invokes the canonical copy (`SCRIPTS_DIR = {AI_RESOURCES}/logs/scripts`, log-sweep.md:31, :199), never a project-local copy. They are not consumers of the two edited files; they are independent installs that would only diverge if separately re-synced (out of scope here). They appear in the table as `co-edits? no` for completeness.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/commands/log-sweep.md | invokes (`bash {SCRIPTS_DIR}/split-log.sh ... bottom`, :199) | no |
| ai-resources/.claude/agents/log-sweep-auditor.md | documents (threshold/entry-count contract, :77) | no |
| ai-resources/workflows/research-workflow/CLAUDE.md + blueprint | imports (template copy ships via `/deploy-workflow`) | no (it IS one of the two edited copies) |
| ai-resources/logs/scripts/check-archive.sh | co-edits (sibling rotator; reads active-log tail, not preamble) | no |
| ai-resources/.claude/commands/prime.md | parses (reads session-notes LAST entry / tail only) | no |
| ~14 project-local `logs/scripts/split-log.sh` | co-edits (dormant deployed siblings; not invoked by log-sweep) | no |
| Every active log file across 16 scopes (e.g. brand-book decisions.md, marketing-positioning session-notes.md) | parses (rewrite mutates their bytes on archival) | no (they are data, not code; change *restores* content they hold) |

Total: 7 distinct consumer classes, 0 must-change. No consumer reads the preamble region the change preserves (confirmed: check-archive.sh = bottom-N tail; /prime = last entry; pointer-format `^> Archive:` emitted only by split-log.sh itself, split-log.sh:84). The `> Archive:` pointer line is the one contract surface the new strip logic must not corrupt.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded content added; the change is ~5 lines inside an on-demand shell script invoked only by `/log-sweep` (log-sweep.md:199). No CLAUDE.md, no `@import`, no hook registration, no subagent brief touched.
- Script runs per archival candidate during a `/log-sweep` pass (a deliberate, infrequent maintenance command), not per session or per tool call — pay-as-used.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings.json change, no new `allow`/`ask`/`deny` entry, no new tool family. The script already executes under the existing `/log-sweep` Bash invocation (log-sweep.md:199) and already does `mktemp` + `mv` over the active file (split-log.sh:81-87). The change rewrites the *content* of the temp file, not the file-system operations or their permission scope.

### Dimension 3: Blast Radius
**Risk:** Medium

- Grounded in the Consumer Inventory above: 7 consumer classes, 0 must-change. No caller requires modification to keep working.
- Contract surfaces are unchanged in shape: the rewrite still emits exactly one `> Archive:` pointer (split-log.sh:84) and still preserves the kept-entry block that `check-archive.sh` / `/prime` read from the tail. The change *adds* preamble bytes ahead of those, which no tail-reading consumer parses.
- The Medium (not Low) is driven by the shared-state breadth, not by any broken caller: the canonical copy mutates active log files across all 16 project scopes via `/log-sweep` (log-sweep.md:7, "across `ai-resources/` and active projects"). A regression in the rewrite block would touch many files in one pass — wide reach, even though each consumer is individually compatible.
- Two edited files, confirmed byte-identical today (`diff` returned IDENTICAL). The research-workflow copy re-propagates to future deployed projects at `/deploy-workflow`; a divergence between the two copies is a latent drift defect (re-deploys the old defect), so the lockstep itself is part of the blast radius.
- Inventory gap surfaced vs. CHANGE_DESCRIPTION: the description says "invoked … across all 16 project scopes" implying 16 active script copies; in fact only the **single canonical copy** is ever invoked by `/log-sweep` (SCRIPTS_DIR is fixed, log-sweep.md:31). The 14 project-local copies are dormant. This *lowers* real blast radius relative to the description and means those copies do not need editing in this change.

### Dimension 4: Reversibility
**Risk:** Low

- Pure source-code edit to two tracked `.sh` files; `git revert` fully restores the prior script. No data/log mutation is performed *by landing the change* — the script only runs when `/log-sweep` is next invoked.
- Active log files already mutated this session (the S4 marketing-positioning loss) are git-recoverable per the SO advisory (consult-2026-06-12, line 5: "git-recoverable") and independent of this code change.
- No state propagates beyond git: no push (push is gated to wrap), no external write, no hook/cron that fires between landing and a potential revert. Reverting the script does not require touching any already-archived file.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The new strip regex couples to the script's own emitted pointer format. The script writes `> Archive: [basename](basename)` (split-log.sh:84). The strip must anchor to `^> Archive: \[` (line-start), not a loose `Archive:` substring — a loose match would silently delete a legitimate preamble line containing the word "Archive:" (the brand-book decisions.md preamble is exactly the kind of prose-and-fenced-template content where this is plausible; decisions.md:1-19 shows a multi-line fenced template preamble). The contract is self-contained (emitter and stripper are the same script), which keeps this at Medium rather than High, but it is a real new contract the change introduces.
- Preamble is NOT guaranteed plain prose: the fence-fix landed this session exists precisely because preambles contain `## `-bearing fenced templates (decisions.md:5-19 is a fenced `## YYYY-MM-DD` template). The fresh pointer must land *after* the full preamble block, never interleaved inside a fenced span — an ordering dependency on the same fence-awareness the script just gained.
- Edge shapes differ across log types (session-notes has a pointer-only preamble after first archival, decisions.md has a rich fenced preamble) — the idempotency logic must hold for both zero-preamble and pointer-only-preamble cases without emitting orphaned blank lines. These are implicit dependencies on real file-shape variety, not a single convention.
- No functional overlap introduced: `check-archive.sh` and `log-archiver.sh` operate on different rotation modes; this change does not make two mechanisms contend for the same concern.

### Dimension 6: Principle Alignment
**Risk:** Low

- Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md` (42-principle frozen-ID index; 41 active).
- **OP-3 / OP-11 (loud failure / surface-and-resolve) — actively served.** The change closes a *silent* data-loss path (the exact OP-3 failure mode) the moment it surfaced this session, rather than parking it. This is the OP-11 "correct the practice the moment divergence surfaces" obligation honored, not violated.
- **OP-12 (closure before detection) — served.** The defect was already detected this session; the change *closes* it. It adds no new detection/scan/flag — it is pure closure, which OP-12 counts *for* a change.
- **DR-7 / AP-7 / OP-9 (no speculative abstraction) — clear.** The change is the minimum fix for two demonstrated, current consumers (brand-book decisions.md would lose 15 lines; marketing-positioning already lost 2). No generalization, no "Phase-2 hook," no new abstraction for an absent consumer. The SO advisory explicitly holds scope to the two existing copies and declines opportunistic restructure (consult line 15).
- **OP-5 (advisory vs enforcement) — unchanged.** The script's authority is identical before and after: it already auto-rewrites active files on `/log-sweep`; the change alters *which bytes* it preserves, not whether it acts autonomously. No advisory→enforcement upgrade.
- **DR-1 / DR-3 (placement) — clean.** Edits stay in the existing canonical `logs/scripts/` home and its graduated template copy; no tier move.
- **DR-8 (shared-state automation → binding risk-check) — satisfied by this very pass.** The SO advisory correctly flags that the A-shaped change re-triggers the shared-state-automation class and the plan-time STRUCTURAL_RISK=false no longer holds (consult line 33); running this risk-check is the required response.

## Mitigations

- **Dimension 3 / 5 (pointer-strip + lockstep):** Anchor the strip regex to `^> Archive: \[` at line-start (matching the exact emitted format at split-log.sh:84), never a loose `Archive:` substring. Cover in the isolated-test fixture the five failure modes the SO advisory enumerates (consult lines 43-53): (1) a preamble containing a non-pointer "Archive" mention is preserved; (2) byte-stable preamble across runs 2 AND 3, exactly one pointer; (3) fresh pointer lands after the full preamble, never inside a fenced span; (4) zero-preamble and pointer-only-preamble edges produce no orphaned blank lines; (5) assert against the real emitted pointer string, not an assumed one. Add a line-count reconciliation assertion (no content loss) on the real brand-book decisions.md copy.
- **Dimension 3 (two-copy lockstep):** After editing, run `diff` on the two copies and assert IDENTICAL before commit (today they are identical — confirmed this pass). A divergence re-propagates the defect at the next `/deploy-workflow`.
- **Dimension 3 (shared-state breadth):** Keep the existing isolated-copy-only verification posture — never run the modified script against a live log until the fixture passes. Independent `/qc-pass` before commit per the workspace QC-independence rule (shared-state automation change; do not self-QC-and-commit if the gate is reachable).

## Evidence-Grounding Note

All risk levels grounded in direct evidence (split-log.sh line refs, log-sweep.md SCRIPTS_DIR resolution, `diff` IDENTICAL result, decisions.md preamble shape, principles-base IDs, SO advisory line citations). The 16-vs-1 invoked-copy finding was verified by reading log-sweep.md:31/:199, not assumed from the description. No training-data fallback was used on any read.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Architectural second opinion — concur with PROCEED-WITH-CAUTION.**

We concur with the verdict and the mitigation set. This is a structural bug-fix closing an OP-3 violation already firing in production (`principles.md § OP-3`, § OP-11) — the change *must* land, and PROCEED-WITH-CAUTION correctly routes it through the shared-state-automation gate (`risk-topology.md § 3`, `DR-8`) rather than waving it through. The verdict's risk read is right: the only real hazards are the new strip regex and the two-copy lockstep, both mitigable in the isolated fixture. The dimension scores are sound; I'd note Reversibility=Low is doing quiet work — the change writes bytes back to live logs, so a wrong regex is a *second* silent-loss path, which is exactly why the byte-stable assertion is non-negotiable, not nice-to-have.

The three mitigations are the right ones and map cleanly to the earlier advisory's failure modes (1 → strip-anchor + non-pointer "Archive" fixture; 2 → lockstep diff; 3 → isolated-only + independent QC). Confirmed correct that real blast radius is 2 files — the reviewer's SCRIPTS_DIR verification (`log-sweep.md:31`) closes the ~14-dormant-copy question; the dormant copies are now a *latent drift surface*, not live blast radius, and should be tracked separately, not in this change.

**Risks the dimension review should make explicit (none change the verdict):**

1. **The dormant copies are a deferred-drift liability, not a closed one.** Lockstep here fixes 2 files; ~14 project-local copies stay on the old logic. The day one is reactivated (a future `/deploy-workflow` or a project pointing `/log-sweep` at a local copy), the defect resurfaces. Mitigation 2 protects this session; it does not protect the corpus. Log a `maintenance-observations.md` note that the dormant copies carry the pre-fix logic — otherwise this becomes a silent regression vector six months out (`OP-11`).

2. **Idempotency mitigation must assert across runs 2 *and* 3, not just "byte-stable run 2→3."** The verdict references runs 2 and 3, which is correct — but the assertion that matters is *exactly one* pointer after N runs (never zero, never two). A regex that strips its own freshly-emitted pointer would read byte-stable run-to-run while silently dropping the pointer entirely. Assert pointer-count == 1, not just byte-equality between runs.

3. **Pointer-inside-fence is the one untested interaction between the two fixes in this same change.** The fence-fix establishes that preambles can contain `## `-bearing fenced templates (that is the brand-book case); the preamble-preservation rewrite must place the fresh pointer *after* the full preamble block, never interleaved into a fenced region. The two fixes are co-resident in this edit and interact precisely on the brand-book file — the fixture must cover a fenced-template preamble end-to-end, or the fix that motivated the change is the one case left unverified.

**Net:** PROCEED-WITH-CAUTION is the correct verdict; mitigations are the right ones; proceed on the operator's already-planned fixture path, adding the pointer-count==1 assertion, the fenced-preamble pointer-placement case, and a dormant-copy drift note. End-time `/risk-check` gate still applies before commit (`DR-8` — binding, no downgrade-to-push), and independent `/qc-pass` is required since this is shared-state automation (`QS-1`).
