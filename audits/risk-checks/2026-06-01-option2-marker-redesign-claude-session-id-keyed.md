# Risk Check — 2026-06-01

## Change

Structural change: redesign of the session-marker identity mechanism ("Option 2′"). Replace the shared-mutable logs/.session-marker file-as-identity-oracle with a per-session marker file keyed by the harness-injected CLAUDE_CODE_SESSION_ID env var: logs/.session-marker-${CLAUDE_CODE_SESSION_ID} containing "{DATE} S{N}". Full design spec: ai-resources/audits/option2-marker-redesign-2026-06-01.md. Closes the marker-clobber TOCTOU bug class (improvement-log 2026-05-29 entry; Option 1 was VALIDATED-REJECTED on 2026-06-01). Blast radius: the 9 marker-contract consumers in docs/session-marker.md — primarily the 3 writers (prime.md Steps 8a/8b/8c, session-start.md Step 3, session-plan.md Step 0/7), the wrap-session.md Step 3.5 foreign-write guard, session-start.md Step 0.5 mtime guard, and the canonical contract doc docs/session-marker.md; the 5 read-only auxiliary consumers mostly use the session-plan-* glob and need no resolution change. Key design properties: (a) per-session-id file is immune to foreign /prime clobber; (b) LOUD FALLBACK to current shared-file behavior if CLAUDE_CODE_SESSION_ID is absent (older CLI), per OP-3; (c) new .gitignore entry logs/.session-marker-*; (d) orphan-file cleanup needed; (e) harness-version dependency on CLAUDE_CODE_SESSION_ID (verified present in CLI v2.1.156). Note: the originally-specced "env var set at /prime" mechanism was proven infeasible this session (exported env vars do not persist across Bash tool calls). This is a plan-time gate before implementation across the consumer surface.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/option2-marker-redesign-2026-06-01.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A well-scoped, root-cause structural fix that closes the marker-clobber TOCTOU class, but it edits the always-loaded session-init surface across 5+ runtime sites with two High dimensions (blast radius across the 9-consumer contract; hidden coupling on an undocumented harness env-var contract and a workspace-root sibling guard), both of which have viable paired mitigations.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No content added to always-loaded CLAUDE.md. The change edits command bodies (`/prime`, `/session-start`, `/session-plan`, `/wrap-session`) and one doc — none of which is auto-loaded per turn; they load only when the command is invoked — spec § "Marker read (canonical resolution)" and the 9-consumer registry in `docs/session-marker.md` lines 87-99.
- No new hook is registered. The change does not add a SessionStart/PreToolUse/Stop hook; the existing `detect-concurrent-session.sh` (SessionStart, shipped 2026-06-01) is unaffected by the marker-key change (it reads the marker only as read-only enrichment — `docs/session-marker.md` line 131).
- The marker-resolution block grows modestly (an `if [ -n "$CLAUDE_CODE_SESSION_ID" ]` branch + loud-fallback echo, ~8 lines per consumer — spec lines 35-47), but it executes only inside already-invoked commands; no per-turn or per-tool-call cost is added.
- The `S{N}` increment changes from a single-file read to a `logs/.session-marker-*` glob max-scan (spec line 52-53) — a one-time read at `/prime`, negligible.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` settings entries are added or removed. The change is confined to command bodies, a doc, and a `.gitignore` line.
- The new file-write target `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}` is within the already-authorized `logs/` write surface — the existing `logs/.session-marker` write at `prime.md` lines 171/214/256 already operates here under bypass-permissions posture.
- No new tool family, external API, or cross-repo capability is introduced. Reading `$CLAUDE_CODE_SESSION_ID` is an env-var read inside an existing Bash invocation, not a new permission.

### Dimension 3: Blast Radius
**Risk:** High

- The change touches a shared contract consumed by 9 registered consumers plus its canonical doc. Enumeration from `grep -rln '\.session-marker'` across `ai-resources` and the registry in `docs/session-marker.md` lines 87-99:
  - **3 writers, all require code edits:** `prime.md` (3 marker-write blocks — lines 164-171, 207-214, 249-256, plus 9 total `.session-marker` occurrences); `session-start.md` Step 3 (marker resolution, line 285); `session-plan.md` Step 0/7 (lines 13, 159-160).
  - **`wrap-session.md` Step 3.5 foreign-write guard requires a code edit** — the marker-aware attribution path at lines 80-116 reads `logs/.session-marker` directly (`cat logs/.session-marker`, line 82) and must switch to the per-session-id file to gain the clobber-immunity payoff (spec § "/wrap-session Step 3.5 guard — the payoff", line 49-50). This is the dimension where a caller *requires* modification to keep working correctly — the High trigger.
  - **`session-start.md` Step 0.5 guard** uses a *separate* marker (`logs/.prime-mtime`, lines 51-56), NOT `.session-marker`. The spec lists it in blast radius but the grep shows Step 0.5 does not read `.session-marker` — so it likely needs no resolution change. Flag this as a spec over-scoping to verify at implementation.
  - **5 read-only auxiliary consumers** (`contract-check`, `drift-check`, `open-items`, `fix-repo-issues-scanner` agent, `decide`) — the registry (lines 95-99) confirms 3 of these use the `session-plan-*` glob with **no marker resolution**, so they are compatible without change. `contract-check`/`drift-check` resolve the marker; if they re-derive `MARKER`, they inherit the new resolution block.
  - **`detect-concurrent-session.sh`** reads `.session-marker` as enrichment (`docs/session-marker.md` line 131); behavior is read-only and tolerant of the key change, but should be sanity-checked.
- **Contract change is backwards-compatible by design** (loud fallback to shared-file behavior preserves the old contract when the var is absent — spec lines 42-47), which is the one mitigating factor, but the sheer count of writers requiring edits plus a guard whose correctness depends on the edit lands this at High.
- **Same-day `S{N}` increment semantics change** from authoritative single-file to max-across-glob, with an accepted benign race (two sessions both labeled S2 — spec line 53). This is a contract-behavior change every writer must honor consistently.

### Dimension 4: Reversibility
**Risk:** Medium

- The command/doc/`.gitignore` edits are a clean `git revert` — single working tree, no external state (the writers, guard, and doc are all tracked files).
- **Two extra cleanup steps push this above Low:** (a) per-session marker files `logs/.session-marker-*` created at runtime by the new `/prime` path are NOT removed by reverting the command edits — they persist on disk as orphans (spec edge case 4, line 59). (b) The spec's planned orphan-cleanup logic (prune `.session-marker-*` older than today, spec line 59) is itself new automation that fires inside `/prime`; if the redesign is reverted but a `/prime` ran under it, stale per-id files remain.
- No state propagates beyond the local repo (the marker files are gitignored per design property (c) and spec line 61) — no push/external write to roll back. Revert stays within git + a one-line `rm logs/.session-marker-*` cleanup.
- `.gitignore` addition `logs/.session-marker-*` reverts cleanly, but any already-created per-id files would become git-visible again on revert if they had been force-added (they should not be — gitignored from the start).

### Dimension 5: Hidden Coupling
**Risk:** High

- **Undocumented harness env-var contract.** The entire mechanism depends on `CLAUDE_CODE_SESSION_ID` being injected into every Bash tool environment. The spec edge case 1 (line 56) flags this as "**Must verify the var is contractual, not incidental**" and the change is NOT yet documented anywhere in `docs/session-marker.md` as a harness dependency. This is a new implicit contract on harness behavior that callers silently rely on — the High trigger.
- **Spec's CLI-version claim is wrong and unverified-as-contractual.** The CHANGE_DESCRIPTION and spec edge case 1 state the var is "verified present in CLI v2.1.156." This machine runs **v2.1.114** (`claude --version` → `2.1.114 (Claude Code)`), yet the live probe (`printenv CLAUDE_CODE_SESSION_ID`) returned a valid UUID `ff905513-...`. The dependency therefore holds on the actual running CLI — which *de-risks feasibility* — but the spec cites a version this machine is not running, so the "verified in v2.1.156" provenance is inaccurate and the contractual-vs-incidental question (is the var documented by Anthropic, or an undocumented internal that could vanish?) remains open. The loud fallback (spec lines 42-47) bounds the downside to graceful degradation, which is the mitigating factor.
- **Workspace-root sibling guard not enumerated as an edit target.** `wrap-session.md` Step 3.5 carries an explicit PAIRED CONTRACT block (`wrap-session.md` lines 40-47) naming a workspace-root `/.claude/commands/wrap-session.md` Phase 3 copy ("NOT a symlink — operates on workspace-level logs/session-notes.md"). The CHANGE_DESCRIPTION names only the ai-resources guard; the workspace-root sibling reads the same `.session-marker` convention and would silently diverge if only the ai-resources copy is updated — a second implicit dependency.
- **`/compact` / session-resume re-keys the identity.** A resumed session may receive a new `CLAUDE_CODE_SESSION_ID`, orphaning its earlier per-id file and silently falling to the clobber-vulnerable fallback (spec edge case 3, line 58). This is a context-dependent silent behavior shift the operator will not see except via the loud-fallback line.
- Mitigating factor: the loud-fallback design (OP-3) means every degraded path emits a visible notice rather than failing silently — but multiple implicit dependencies (harness var contractuality + workspace-root sibling + resume re-keying) and an undocumented new contract keep this at High.

## Mitigations

- **Dimension 3 (Blast Radius):** Land the change as a single atomic commit across all writers + the `wrap-session.md` Step 3.5 guard + `docs/session-marker.md` (mirroring the 2026-05-29 atomic Phase 2+3 precedent cited in `docs/session-marker.md` line 5), and before implementation produce a one-line-per-consumer edit manifest confirming, for each of the 9 registry entries, whether it needs a resolution-block edit or is glob-only (no change). Explicitly resolve the `session-start.md` Step 0.5 question: grep confirms Step 0.5 reads `logs/.prime-mtime`, not `.session-marker` (lines 51-56) — if that holds, drop it from the edit set and correct the spec's blast-radius list.
- **Dimension 5 (Hidden Coupling) — harness contract:** Before landing, verify `CLAUDE_CODE_SESSION_ID` is a documented/contractual Claude Code env var (not incidental), and record the finding plus the loud-fallback behavior as a new "Harness dependency" section in `docs/session-marker.md`. Correct the inaccurate "v2.1.156" provenance — the var is live on the running v2.1.114, so cite the actual verified version. The loud fallback (spec lines 42-47) is the safety net if the var is later confirmed non-contractual.
- **Dimension 5 (Hidden Coupling) — sibling guard + resume:** Include the workspace-root `/.claude/commands/wrap-session.md` Phase 3 copy in the same atomic edit set (its PAIRED CONTRACT block, lines 40-47, requires lockstep updates), and document the `/compact`/resume re-keying behavior (spec edge case 3) in `docs/session-marker.md` so the loud-fallback line is a known, expected signal rather than a surprise.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts across `ai-resources`, the live `claude --version` and `printenv CLAUDE_CODE_SESSION_ID` probes, and verbatim quotes from the design spec, `docs/session-marker.md`, and `wrap-session.md`). The CLI-version discrepancy was caught by direct probe rather than accepting the spec's stated value. No training-data fallback was used on fetch/read failures.

## Architectural Commentary

_System-owner second opinion, invoked automatically because the verdict is PROCEED-WITH-CAUTION. `/consult` is blocked from model-invocation (disable-model-invocation), so the equivalent Function-B advisory was obtained via the `system-owner` agent directly. Full advisory on disk: `projects/axcion-ai-system-owner/output/consultations/consult-2026-06-01-option2-marker-redesign-risk-check-second-opinion.md`._

- **Concurs with PROCEED-WITH-CAUTION; mitigations are right.** The risk-checker's live probe caught the wrong CLI-version provenance, de-risking feasibility while sharpening the open question. M1 (atomic commit + per-consumer manifest) is the mechanical antidote to the repeat consumer-undercount defect.
- **Core design sound and the right shape.** Removing the oracle from the clobber surface beats stacking another reactive guard on a poisoned oracle. Loud fallback = correct OP-3 posture. Refinement: keep the shared file "in addition to," not "instead of," at v1 (DR-7/AP-7).
- **Correction:** DROP session-start Step 0.5 from the edit set — it reads `.prime-mtime`, not `.session-marker`.
- **Risks under-weighted by the 5-dim review:** the harness-var-as-foundation bet crosses the `OP-10` harness boundary (governed separately); the loud fallback bounds *absence*, not *changed meaning* (e.g., `/compact` resume re-keying) — M2's doc section must record the two assumed properties (stable-within-session, distinct-across-sessions) and flag CLI upgrade as a re-verify event (OP-11). No AP-10/AP-7 violation — the fallback is real boundary-validation.
- **Sequencing (Q4): land as a GO-eligible spec; do NOT implement now.** The operator's "do everything now" was chosen against the superseded env-var design, before infeasibility reframed the work into a materially more delicate 9-consumer atomic edit on an undocumented harness dependency. Three convergent signals: context state (3 waves + 11 subagents → Context-constraint-deferral, OP-4/AP-8); the S2 "validate before invest" lesson the spec itself cites; and atomicity (a half-landed contract is the `risk-topology § 5` drift failure). If implementing now anyway, the floor is: full M1 manifest before the first edit, one atomic commit incl. the workspace-root sibling, any mid-edit context pressure = hard stop + revert.
