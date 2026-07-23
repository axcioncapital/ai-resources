# Risk Check — 2026-07-23

## Change

REVISED design (re-gate) — Commit 2 of 2, /new-project direct-route lean session-harness. Supersedes the RECONSIDER'd design at audits/risk-checks/2026-07-23-commit-2-of-2-new-project-direct-route-lean-session-harness.md. Full revised spec: audits/working/2026-07-23-commit2-revised-design.md (READ THIS FIRST — it is the authoritative design).

The REVISED design differs from the RECONSIDER'd one in exactly one way that matters: it KEEPS the full mandate block (including `- Files in scope:` and `- Required outputs:`), KEEPS the run-manifest (start-stub + close), and KEEPS the marker + marker-bearing header. So the safety/crash-recovery/collision spine is preserved and unchanged from today. For a project whose root CLAUDE.md carries the exact literal `**Execution route:** direct`, the ONLY things removed are: (1) the auto-chain from session-start Step 4 to /session-plan; (2) the committed logs/session-plan-*.md file (never written for direct); (3) prime 8a.3.d's pause message that referenced that now-nonexistent plan file, replaced with a message pointing at the mandate in session-notes; (4) wrap-session 12e findings-disposition ceremony ONLY when the finding set is empty (N=0). /session-plan stays available on explicit opt-in and writes normally then.

Route predicate (all four commands, identical, fail-safe): read project root CLAUDE.md; `grep -m1 -oE '^\*\*Execution route:\*\* *direct[[:space:]]*$'`. Case-sensitive + end-anchored → engineered / absent / malformed / `Direct` / `direct-x` all fall through to today's full behaviour. Every branch is `if DIRECT=1`; DIRECT=0 is byte-for-byte unchanged.

Files edited: .claude/commands/prime.md (8a/8b/8c), session-start.md (Step 4), session-plan.md (Step 0 doc note only, no functional branch), wrap-session.md (12e), docs/session-marker.md (registry update recording the direct-route exception).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/2026-07-23-commit2-revised-design.md — exists (AUTHORITATIVE revised spec — read first)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-07-23-commit-2-of-2-new-project-direct-route-lean-session-harness.md — exists (the superseded RECONSIDER report)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/concurrent-session-check.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md — exists

## Verdict

RECONSIDER

**Summary:** The revised design is a genuine, verified improvement over the superseded one — both concrete defects that drove the prior RECONSIDER (the permanent concurrent-session-check blind spot and the dangling pause-message reference) are fixed as claimed — but the re-gate surfaces two independent, unmitigated Highs the revision does not touch: the "Problem-reality evidence" section cites five sources that, opened and read at their exact lines, are each about a different, unrelated problem (not the ceremony this change removes), and the anticipatory build still has zero live consumers with no loud OP-11 record accepting that tradeoff. Either High alone forces RECONSIDER; Problem Reality does so unconditionally per its own gating rule.

## Consumer Inventory

Search terms: `prime.md`, `session-start.md`, `session-plan.md`, `wrap-session.md`, `Execution route`, `session-plan-*.md` glob, `- Files in scope:`, `concurrent-session-check`, `session-marker.md`. Grepped `ai-resources/.claude/`, `ai-resources/docs/`, `ai-resources/logs/`, and `projects/*/` (workspace root one level up) per Step 1.5. Re-derived independently (not taken from the change description or the superseded report) via `find`/`grep`, including symlink type checks.

| Consumer path | Reference type | Must change? |
|---|---|---|
| 24 × `projects/*/.claude/commands/prime.md` (24 of 25 matches are symlinks; 1 real file — the known stale worktree copy per `docs/session-marker.md`) | invokes | no — byte-for-byte unchanged for `DIRECT=0`, verified by construction (every new branch is `if DIRECT=1`) |
| 23 × `projects/*/.claude/commands/wrap-session.md` (23 of 25 matches are symlinks) | invokes | no |
| 25 × `projects/*/.claude/commands/session-plan.md` | invokes | no |
| 24 × `projects/*/.claude/commands/session-start.md` | invokes | no |
| `.claude/commands/drift-check.md` (Step 1: glob `logs/session-plan-*${MARKER}.md`) | parses | no — confirmed by direct read: "Either may be absent — `/drift-check` is advisory and tolerates absence of the plan" (drift-check.md:18) |
| `.claude/commands/contract-check.md` (Step 2.5b: plan glob → 2.5c: mandate-block fallback) | parses | no — confirmed by direct read: "skip this candidate... Do NOT hard-fail" (contract-check.md:52), falls to the mandate block, which direct route retains |
| `.claude/commands/concurrent-session-check.md` (Step 3: `- Files in scope:` bullet + plan-file scope, union) | parses | no, but **partially degraded — see Dimension 5.** The mandate-block retention closes the prior design's unconditional blind spot; a narrower, conditional gap remains when `files_in_scope` is left `(inferred)` |
| `.claude/commands/wrap-session.md` itself (Step 6.4 mandate-resolution priority chain) | parses | no — chain already falls through frozen-contract → plan-file → mandate-block → Summary fallback; mandate-block retention keeps this at its best non-plan tier, not its worst |
| `.claude/commands/open-items.md`, `reconcile-backlog.md`, `decide.md`, `blindspot-scan.md`, `.claude/agents/fix-repo-issues-scanner.md` (all: `logs/session-plan-*.md` glob scan) | parses | no — confirmed by direct read of each: glob-scan consumers, an empty match set is a normal "nothing found" outcome, not an error path (blindspot-scan.md:31 states this explicitly: "tolerate marker absence — read-only auxiliary consumer") |
| `.claude/hooks/check-foreign-staging.sh` (recognizes `session-plan-YYYY-MM-DD-S\d+...\.md` as an exempt filename shape) | parses | no — confirmed by direct read (check-foreign-staging.sh:565); the exemption clause simply never fires for a direct-route session (nothing to exempt), it is inert, not broken |
| `docs/session-marker.md` (canonical registry of every reader above) | documents | **yes** — and the revised design's own item #7 correctly plans this update (unlike the superseded design, which left the registry silently stale) |
| `.claude/commands/new-project.md`, `docs/repo-architecture.md`, `docs/compaction-protocol.md`, `docs/heavy-read-discipline.md`, `docs/weekly-cadence.md` | documents (narrative references to the plan filename) | no |

**Total: ~96 symlink-propagated project consumers across the four canonical files (one shared underlying set of ~25-28 project directories), plus 10 distinct non-symlink command/agent/hook consumers, 1 must-change (docs/session-marker.md, correctly planned in the revised design).** Zero of the 10 non-symlink consumers require code modification to keep working — each either gracefully falls through to an alternate source or degrades to an inert no-op, verified by direct read rather than accepted from the change description or the superseded report's characterization.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- `prime.md` is 812 lines and triggered the repo's own `[HEAVY]` Read-hook warning when this review read it in full — directly observed in this session's tool output ("[HEAVY] Read on prime.md (812 lines, no limit). Consider narrowing the call."), not merely asserted.
- The change adds conditional `DIRECT=1` branches to four already-heavy, universally-symlinked command files (`prime.md`, `session-start.md`, `session-plan.md`, `wrap-session.md`) that are read in full at every session start/plan/wrap across ~25 project checkouts, regardless of route. The structural read-cost of the files increases for every session, even though the *executed* branch is unchanged for the 25/25 projects currently at `DIRECT=0`.
- Not an always-loaded CLAUDE.md addition and not a PreToolUse hook, so it does not clear the High bar; the breadth (universal symlink propagation) and the fact that the host files are already at the repo's own heaviness threshold keep this above a trivial Low.

### Dimension 2: Permissions Surface
**Risk:** Low

- Pure command-logic branching in four existing `.claude/commands/*.md` files plus a doc registry update. No `settings.json`/`settings.local.json` edit, no new allow/deny entry, no new tool-invocation pattern anywhere in the reviewed spec.

### Dimension 3: Blast Radius
**Risk:** High

- Consumer inventory (above), independently re-derived: 24/23/25/24 symlinked project consumers of `prime.md`/`wrap-session.md`/`session-plan.md`/`session-start.md` — an order of magnitude past the framework's own ">5 dependent callers" High threshold, on count alone.
- **Materially different from the superseded design's Blast Radius finding, however: zero of those consumers require modification, and none is broken.** The fail-safe construction (`if DIRECT=1`, every existing project at `DIRECT=0`) is verified by reading the actual branch logic, not merely asserted — every new instruction in prime.md/session-start.md/session-plan.md/wrap-session.md examined this session is conditioned on the route predicate, with the pre-existing instruction unconditionally intact beneath it.
- This is a High **by scale of shared-infrastructure reach**, not by functional breakage — the four files are the universal session-lifecycle entry point read by every session in every project, so any change to them, however well-fenced, touches all of them structurally. The correct read is "high blast radius, well-mitigated by construction," not "high blast radius, things will break" (contrast the superseded design, where a genuine consumer — `concurrent-session-check.md` — was actually degraded for every direct session).

### Dimension 4: Reversibility
**Risk:** Low

- Additive branch logic inside four already-git-tracked files plus a doc registry addition; a `git revert` of the commit-2 landing cleanly restores prior behavior in one step.
- Confirmed via `git log`: HEAD is `194a8bd` (commit 1 of 2, "feat: /new-project direct-route lane"), 1 commit ahead of `@{u}`, unpushed. Commit 2 has not yet landed.
- Confirmed via `grep -rl "Execution route" projects/*/CLAUDE.md`: zero matches — no existing project carries the route line, so no live state exists yet under any new branch to complicate a future revert.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **The two concrete defects that drove the superseded design's High are verifiably fixed here.** (1) `concurrent-session-check.md`'s Step 3 reads `- Files in scope:` from the mandate block; the revised design retains the full mandate block for direct route (confirmed: session-start.md Step 3 / prime.md 8c.7 write it unconditionally, with no `DIRECT`-gated skip in the reviewed spec), so the bullet exists on disk for every direct session, unlike the superseded design where it never existed at all. (2) `prime.md` 8a.3.d's pause message (confirmed live today at prime.md:546: `"Plan ready — review logs/session-plan-${TODAY}-${MARKER}.md..."`) is explicitly slated for a `DIRECT=1` rewrite per the revised spec item #2, closing the dangling-reference defect.
- **A narrower, genuine residual gap remains, not disclosed in the revised spec's own "PRESERVED" claim.** `concurrent-session-check.md`'s HARD GATE (confirmed at concurrent-session-check.md:84-97) treats a session whose declared-scope bullet reads `(inferred)` **with no concrete paths and no plan-file scope** as UNKNOWN-SCOPE — "cannot certify safety against it." Independently tracing the mandate-write contract: `session-start.md` Step 3 writes the bullet as the literal string `(inferred)` (not the actual inferred paths) whenever `files_inferred = true` — i.e., whenever the operator did not explicitly state or correct `files_in_scope` at the Step 2 confirmation prompt (the common, low-friction path, and the one this route is explicitly designed to encourage). **Today (engineered route), this is masked by the auto-written plan file's own `## Source Material` list, which concurrent-session-check.md also reads as a supplementary footprint source.** Direct route removes that supplementary source entirely (no plan file, ever, unless the operator opts in). So: a direct-route session whose mandate is left `(inferred)` — plausible, since minimizing friction is the whole point of this route — reproduces the exact UNKNOWN-SCOPE outcome the revised design claims to have fixed, just conditionally rather than unconditionally.
- **This does not rise to the superseded design's High** for two reasons the framework's heuristic distinguishes: it is conditional (only fires when `files_in_scope` stays uncorrected) rather than universal, and it fails *safe* — `concurrent-session-check.md` explicitly refuses to certify SAFE in this state and says so loudly ("Absence of a declared footprint is not an all-clear") rather than silently reporting SAFE. It is a real, one-implicit-dependency gap on an established convention (the `(inferred)` marker semantics) that the revised design's own text does not surface — which is exactly the Medium band ("one implicit dependency on an established repo convention... not addressed in the plan").
- **Documentation-contract drift is explicitly addressed this time** — the revised design's item #7 plans a `docs/session-marker.md` registry update recording the direct-route exception, closing the gap the superseded design's Dimension 5 also flagged. Recommend the registry update additionally name the residual `(inferred)`-plus-no-plan-file gap above, so it is a recorded, known limitation rather than a second silent one.

### Dimension 6: Principle Alignment
**Risk:** High

Grounded against `{AI_RESOURCES}/../CLAUDE.md` § Design Judgment Principles and `docs/ai-resource-creation.md` rule #7 (the complexity-budget gate, cited inline in the framework). `projects/strategic-os/ai-strategy/principles-base.md` was not read (not among the referenced inputs); the inline complexity-budget test is sufficient to ground this finding, as it was for the superseded gate.

- **OP-9 / AP-7 / DR-7 (speculative abstraction) — unchanged from the superseded gate's finding, because the revision addresses *what* is skipped, not *whether it is justified to build now*.** Confirmed by direct grep: `grep -rl "Execution route" projects/*/CLAUDE.md` returns zero matches — no live consumer exists for this branch today, one full commit (commit 1) after the capability to create one shipped. **Prong (a), net-simplification: fails** — the change is purely additive branching across four files; nothing is removed or consolidated elsewhere (`session-plan.md`'s own edit is a doc-note only, explicitly "no functional branch"). **Prong (b), cited written evidence: fails on inspection** — see Dimension 7 below; the revised design's own evidentiary section, opened at each cited line, supports a different claim than the one advanced here.
- **No OP-11 loudly-recorded exception exists.** Confirmed via `tail -n 60 logs/decisions.md` and a targeted grep for `2026-07-23` in that file: the log's most recent entries are dated 2026-07-19; no entry records a deliberate decision to build this anticipatory branch ahead of a confirmed consumer. The live session-notes mandate for today's session (S1-0e1) states the build task but is not a decisions.md-format record with context/rationale/alternatives — it does not meet the bar the repo's own precedent (the six 2026-07-19 decisions.md entries read this session) sets for a loud, recorded exception.
- Per the framework's own special handling, a High here with no loud OP-11 acknowledgment forces `RECONSIDER` independent of the other dimensions; the remedy is rescope (hold until a live consumer exists) or record the revision loudly (OP-11) — not a technical patch.

### Dimension 7: Problem Reality
**Risk:** High

- **Defect — observed or inferred?** Observed. Direct reads of `session-start.md`, `session-plan.md`, `prime.md`, and `wrap-session.md` this session confirm today's harness unconditionally writes the full mandate schema, the committed `logs/session-plan-*.md` file (via the Step-4 auto-chain), the run-manifest start-stub, and (per Step 12e) the findings-disposition ceremony, for every session regardless of project size or route. This baseline fact is real, independently re-derived, not merely asserted.
- **Consequence — traced or assumed? Assumed, and the "Problem-reality evidence" section offered to close this gap does not hold up on inspection.** The revised design cites five sources as "Ceremony overhead is repeatedly measured and named." Each was independently re-opened at its cited file and is about a **different, unrelated** problem:
  - `token-audit-2026-07-03` line 151/316: "~20–30k tokens/session saved by avoiding deterministic ceremony" — this measures savings from **Decision-Point Posture and `/risk-check` skips** (skipping `/consult` Step 4a, `/decide`'s QC-subagent, redundant `/qc-pass`), an already-shipped, unrelated ceremony-reduction pattern — not the session-plan/mandate/run-manifest chain this change touches.
  - `token-audit-2026-05-18` line 404: "reduce per-session token consumption by 20–40%" — this is scoped explicitly to **Friday cadence sessions** (`/friday-checkup`), a different command class entirely.
  - `friday-checkup-2026-07-03` line 153 / `lean-repo-2026-07-13` line 220: "heavy gate ceremony" — this refers to **290 accumulated risk-check report files with no archival cadence** (an artifact-pile-up complaint), not to per-session harness weight.
  - `repo-health-backlog-2026-07.md:78`: "12 sessions in 2 days... going in circles" — independently opened; this is about the **mission-thread hand-ticking / `/mission check` defect** (finished threads re-entering the task menu because they were never ticked), a wholly separate defect resolved by a 2026-07-19 decisions.md entry — not about session-start/session-plan ceremony cost.
  - None of the five citations measures the actual thing this change removes (the mandatory `/session-plan` auto-chain, the committed plan file, or the run-manifest) for a bounded/document-only project category — because zero such projects have ever run a session (confirmed: zero `Execution route: direct` lines exist in any project `CLAUDE.md`), so no such measurement could exist yet. Presenting these five as if they were that evidence is the same shape of error the framework specifically warns against: an accurate quote pressed into service for a consequence it does not establish.
  - **For fairness:** genuinely on-point evidence *does* exist in the repo and was not cited — `token-audit-2026-07-03` line 122 measures `session-start.md` at 3,905 tokens/invocation, and `token-audit-2026-05-18` line 122 measures `session-plan.md` at ~1,717 tokens/invocation (~5,600 tokens combined, before mandate-confirmation round-trips or the plan-write itself). This would have been the honest citation and plausibly supports a real, if still-unmeasured-for-this-specific-route, case. It is not what was submitted for this gate.
- **Re-derivation vs. the change description:** the specific claim "Ceremony overhead is repeatedly measured and named" is **contradicted** by opening each of the five sources it names — each measures a different, already-otherwise-addressed ceremony class. This is a Dimension-7 finding in its own right, independent of whether a better case could be built elsewhere. All other re-derived facts in the change description (commit-1 HEAD status, the 1-unpushed-commit count, the zero-live-consumer grep, the mandate-retention/pause-message/registry claims in Dimension 5 and 6) were independently confirmed and matched exactly — the discrepancy is confined to the evidentiary citations.

## Recommended redesign

Two independent Highs force this verdict (Dimension 6 and Dimension 7), and per the framework neither has a technical mitigation — Dimension 7 gates the other six on its own regardless of their scores.

- **Problem Reality (Dimension 7):** either (a) hold the change until a real `direct`-route project exists (commit 1 already ships the capability to create one) and measure its actual first-session ceremony cost against `today`'s baseline — turning an assumed consequence into a traced one — or (b) if proceeding without that measurement, replace the "Problem-reality evidence" section with the citations that are actually on point (`token-audit-2026-07-03:122` and `token-audit-2026-05-18:122`, the measured per-invocation costs of `session-start.md`/`session-plan.md`), rather than the five thematically-adjacent-but-substantively-unrelated citations currently offered, and re-run this gate against the corrected evidentiary section.
- **Principle Alignment (Dimension 6):** the same two paths apply as at the prior gate, and neither has yet been taken — rescope to wait for the first live direct-route consumer (which resolves Dimension 7 simultaneously), or record a loud, explicit OP-11 exception in `logs/decisions.md` (context, decision, rationale, alternatives considered, in the same format as this repo's own 2026-07-19 entries) accepting the anticipatory-build tradeoff before landing Commit 2.
- Independent of which path is taken: the revised design's two genuine fixes (mandate-block retention closing the unconditional concurrent-session-check blind spot; the 8a.3.d pause-message correction) are sound and should be preserved whenever the change does land. Before it lands, also record in `docs/session-marker.md`'s planned registry update (item #7) the narrower residual gap named in Dimension 5: a direct-route session whose `files_in_scope` is left `(inferred)` still reproduces UNKNOWN-SCOPE for `concurrent-session-check.md`, since there is no plan file to supplement it — a known, bounded, fail-safe limitation, not a second silent one.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
