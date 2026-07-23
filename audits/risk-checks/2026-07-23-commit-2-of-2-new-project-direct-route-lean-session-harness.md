# Risk Check — 2026-07-23

## Change

Commit 2 of 2 of the /new-project direct-route feature: add a "direct-route lean session-harness" branch to four shared session commands — .claude/commands/prime.md (branches 8a/8b/8c), session-start.md, session-plan.md, wrap-session.md.

Behavior: for a project whose root CLAUDE.md carries the exact literal line `**Execution route:** direct`, the harness skips (a) writing the committed logs/session-plan-*.md file, (b) the run-manifest start/close stubs (logs/runs/*.json), and (c) the full mandate schema block — while STILL allocating the gitignored session markers (Step 8k) and writing a minimal logs/session-notes.md entry. Any other route value (engineered / absent / malformed / wrong-case like `Direct`) falls through to today's full behavior. Fail-safe by construction: only the exact literal activates lean; absence = engineered.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-project.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/control-pack-schema.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scratchpads/2026-07-23-11-58-scratchpad.md — exists

## Verdict

RECONSIDER

**Summary:** The technical design is sound in isolation, but re-derivation surfaces three independent High-risk findings (blast radius, hidden coupling, and an unacknowledged speculative-abstraction principle tension) plus a Medium on problem reality — three Highs alone force RECONSIDER regardless of mitigations, and the concrete gaps found (a safety-net that silently and permanently degrades for every direct-route session, and an operator-facing message that will point at a file the new branch is designed never to create) are exactly the kind of thing a plan-time gate exists to catch before code is written.

## Consumer Inventory

Search terms derived from the change: `prime.md`, `session-start.md`, `session-plan.md`, `wrap-session.md`, `Execution route`, `session-plan-*.md`, `logs/runs`/`run-manifest`, and the mandate bullet labels (`Files in scope:`, `Mandate:`). Grepped across `ai-resources/.claude/`, `ai-resources/docs/`, and `projects/*/` per Step 1.5.

| Consumer path | Reference type | Must change? |
|---|---|---|
| 23 × `projects/*/.claude/commands/prime.md` (symlinks to canonical) | invokes | no (auto-propagates via symlink) |
| 23 × `projects/*/.claude/commands/session-start.md` (symlinks) | invokes | no |
| 23 × `projects/*/.claude/commands/session-plan.md` (symlinks) | invokes | no |
| 22 × `projects/*/.claude/commands/wrap-session.md` (symlinks) | invokes | no |
| `.claude/commands/drift-check.md` (Steps 1, 6, 7a — reads plan glob + mandate bullet) | parses | no (designed to tolerate absence — but see Dimension 5 finding) |
| `.claude/commands/contract-check.md` (Step 2.5c — plan glob, then mandate-block fallback) | parses | no (graceful fallback) |
| `.claude/commands/concurrent-session-check.md` (Step 3 — reads `- Files in scope:` bullet + plan-file scope for live-session collision safety) | parses | **effectively yes — see Dimension 5** (not modified by the change, but its guarantee silently degrades) |
| `.claude/commands/wrap-session.md` itself (Step 6.4 mandate-resolution chain, Step 7a coaching classification) | parses | no (falls through to low-confidence fallback) |
| `.claude/commands/open-items.md` (session-plan glob scan for checkboxes) | parses | no |
| `.claude/commands/reconcile-backlog.md` (session-plan glob scan) | parses | no |
| `.claude/commands/decide.md` (session-plan glob for prior-decision context) | parses | no |
| `.claude/commands/blindspot-scan.md` (session-plan glob for recent-change context) | parses | no |
| `.claude/agents/fix-repo-issues-scanner.md` (session-plan glob for checkbox scan) | parses | no |
| `.claude/hooks/check-foreign-staging.sh` (recognizes `session-plan-*.md` filename shape) | parses | no |
| `docs/session-marker.md` (canonical registry of all six mandate-bullet readers + plan-file consumers) | documents | yes (registry goes stale — does not record the new direct-route no-write exception) |
| `docs/repo-architecture.md`, `docs/commit-discipline.md`, `docs/backlog-reconciliation.md`, `docs/heavy-read-discipline.md`, `docs/weekly-cadence.md`, `docs/friday-cadence-runbook.md` | documents | no |
| `.claude/agents/session-feedback-collector.md`, `.claude/agents/collaboration-coach.md` (read run-manifest / mandate for coaching signals) | parses | no |
| `.claude/commands/monday-prep.md`, `.claude/commands/mission.md`, `.claude/commands/tweak.md`, `.claude/commands/reconcile-activate.md` | documents/parses (unaffected paths) | no |

**Total: ~20 distinct non-symlink consumers found (9+ of them `parses`-type against the artifacts the change removes), plus 23/22 live symlinked project consumers.** This is not an isolated change — it touches shared session-lifecycle infrastructure read by a large fraction of the repo's maintenance tooling.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- `prime.md` is already 813 lines and is flagged `[HEAVY]` by the repo's own Read-hook on a full read — confirmed by the tool-output warning received while grounding this review. `/prime` runs at the start of every session across all 23 symlinked projects, regardless of route.
- Adding conditional direct-route branches to 4 commands that are read in full on every invocation (prime at every session start; session-start/session-plan/wrap-session once per session) adds ongoing per-session read cost across ~23 projects — for a feature with zero current beneficiaries (0 projects carry `Execution route: direct` — grep-verified below).
- Not an always-loaded CLAUDE.md addition and not a PreToolUse hook, so it does not meet the High bar; but the breadth (23 projects × every session) and the fact that the host files are already at the repo's own heaviness threshold make this more than a trivial Low.

### Dimension 2: Permissions Surface
**Risk:** Low

- The change is pure command-logic branching in 4 existing `.claude/commands/*.md` files. No `settings.json` / `settings.local.json` edits, no new tool-invocation pattern, no new allow/deny entries anywhere in the described change.

### Dimension 3: Blast Radius
**Risk:** High

- Consumer inventory (above) counts **23 symlinked project consumers** of `prime.md`/`session-start.md`/`session-plan.md` and **22** of `wrap-session.md` (verified via `[ -L ]` test across `projects/*/.claude/commands/`, 26 project dirs total) — an order of magnitude past the ">5 dependent callers" High threshold on its own.
- Beyond the symlinks, **9+ additional commands/agents/hooks parse the artifacts this change removes for direct-route sessions** (`logs/session-plan-*.md`, `logs/runs/*.json`, the mandate-bullet block): `drift-check.md`, `contract-check.md`, `concurrent-session-check.md`, `wrap-session.md` itself, `open-items.md`, `reconcile-backlog.md`, `decide.md`, `blindspot-scan.md`, `fix-repo-issues-scanner.md`, `check-foreign-staging.sh`.
- Shared infra is touched directly: `logs/session-notes.md`'s mandate-bullet schema and `logs/session-plan-*.md` / `logs/runs/*.json` are load-bearing contracts for multiple independent workflows (session-value auditing, drift judgment, contract judgment, concurrent-session safety, backlog reconciliation).
- **A consumer the CHANGE_DESCRIPTION did not anticipate:** `concurrent-session-check.md` was not named in the plan's file list, yet it is a real, load-bearing consumer of exactly the field the plan removes (see Dimension 5). This is precisely the "Step 1.5 surfaced a consumer not anticipated by CHANGE_DESCRIPTION" case the framework calls out as its own blast-radius finding.

### Dimension 4: Reversibility
**Risk:** Low

- This is additive branch logic inside 4 already-git-tracked files; a `git revert` of the "commit 2 of 2" commit cleanly restores prior behavior in one step.
- No data/log mutation, no external push has happened yet (commit 1 — `194a8bd` — is HEAD, confirmed via `git log --oneline -3`, and is 1 commit ahead of `@{u}`, unpushed).
- Because zero existing projects carry the `Execution route: direct` line (grep-verified: `grep -rl "Execution route" projects/*/CLAUDE.md` returns nothing), no live state has yet been produced under the new branches to complicate a revert. If commit 2 lands and a real direct project runs sessions before a revert is needed, the revert would still restore command *behavior* cleanly; only that project's own already-produced minimal session-notes entries would remain (an acceptable, bounded residue matching the harness's existing tolerance for absent-manifest state).

### Dimension 5: Hidden Coupling
**Risk:** High

- **Concrete, previously-uncited safety-net degradation.** `concurrent-session-check.md` Step 3 reads a live session's `- Files in scope:` mandate bullet (and its plan file) to certify SAFE/COLLIDES verdicts; a session with no resolvable footprint is classified **UNKNOWN-SCOPE** and the command explicitly refuses to certify safety against it (`concurrent-session-check.md:92-97`: "Cannot certify safety against it — wait until it has a plan, or coordinate by hand. Absence of a declared footprint is not an all-clear."). The CHANGE_DESCRIPTION's "skip... the full mandate schema block" means a direct-route session would never write `- Files in scope:` at all — so **every** direct-route session becomes permanently UNKNOWN-SCOPE to this collision-safety mechanism, by design, forever. This mechanism exists specifically to close a documented collision failure mode (`docs/parallel-sessions-playbook.md § 4`, the 2026-06-05 S6 collision) — silently reintroducing its blind spot for an entire class of sessions is a real, unaddressed consequence, and `concurrent-session-check.md` is not in the CHANGE_DESCRIPTION's touched-file list.
- **Internal inconsistency between two of the four touched files.** `prime.md` Step 8a.3.d's operator-facing pause message reads "Plan ready — review `logs/session-plan-${TODAY}-${MARKER}.md`" — but per the Commit-2 spec, `session-plan.md` must not write that file for a direct-route session. As designed, a numbered-menu-selected (8a) direct-route session would show the operator a review prompt pointing at a file that was never created. This is exactly the "does a partial route-branch create an inconsistent state" question the review was asked to check, and it is confirmed by reading `prime.md` 8a.3.d against the Commit-2 spec together — not hypothetical.
- **Documentation-contract drift.** `docs/session-marker.md` is the canonical registry of every reader of the mandate-bullet parse contract (six readers, explicitly enumerated) and of the plan-file consumer list. The change does not update this registry to record the new "no mandate/no plan for direct route" exception, so the canonical doc becomes incomplete/stale the moment the change ships.
- Multiple implicit dependencies not addressed in the plan (not one) is what puts this at High rather than Medium per the stated heuristic.

### Dimension 6: Principle Alignment
**Risk:** High

Grounded against `{AI_RESOURCES}/../CLAUDE.md` § Design Judgment Principles (read in Step 1) and `docs/ai-resource-creation.md` rule #7 (the complexity-budget gate cited inline in this dimension's instructions); `projects/strategic-os/ai-strategy/principles-base.md` was not read (not listed as an input and not required to reach a judgment here) — noted as a gap, but the inline complexity-budget test is sufficient to ground this finding.

- **OP-9 / AP-7 / DR-7 (speculative abstraction) — the complexity-budget gate fails on both prongs.** This change adds a new mandatory-adjacent branch to four already-mandatory session-lifecycle commands. Zero projects currently carry `Execution route: direct` (grep-verified) — there is no first live consumer yet, let alone a *second* confirmed one. **Prong (a), net-simplification:** the change is purely additive branching; nothing is removed or consolidated elsewhere. **Prong (b), cited written evidence of the failure mode:** searched `logs/friction-log.md`, `logs/improvement-log.md`, and `logs/decisions.md` for any prior incident of "bounded document projects accumulating unwanted lifecycle records" — found none. `logs/decisions.md`'s most recent entry is 2026-07-19; there is no 2026-07-23 entry recording this build as a deliberate, loud exception. Both prongs fail, and no **OP-11** loudly-recorded exception exists to license it as a deliberate revision.
- This is the same signal the Step 1.5 inventory already surfaces structurally (a new contract — the direct-route lean posture — with zero current consumers), now expressed as the creation-gate test the framework specifies for exactly this situation.
- Per the framework's own special handling, a High here with no loud OP-11 acknowledgment forces `RECONSIDER` on its own, independent of the other dimensions.

### Dimension 7: Problem Reality
**Risk:** Medium

- **Defect — observed or inferred?** Observed, narrowly: I independently re-read `session-start.md`, `session-plan.md`, and `wrap-session.md` and confirmed today's harness unconditionally writes the full mandate schema, `logs/session-plan-*.md`, and `logs/runs/*.json` for every project regardless of size or route — there is no existing lean-path differentiation. That baseline fact is real and directly verified, not merely asserted.
- **Consequence — traced or assumed?** Assumed. The claimed harm — "bounded document work accumulates unwanted lifecycle records" — has no traceable instance: `grep -rl "Execution route" projects/*/CLAUDE.md` returns zero hits, so no direct-route project has ever run a session under today's undifferentiated behavior to actually experience the claimed overhead. Searches of `logs/friction-log.md`, `logs/improvement-log.md`, and `logs/decisions.md` for any language matching "lifecycle overhead," "lean session," "bounded document," or "session-harness" surfaced no prior incident report grounding the claimed harm. The urgency is inferred from design reasoning (three rounds of Codex review), not from an observed cost.
- **Re-derivation vs. the change description:** The scratchpad's premises 1–4 (Commit 1 is HEAD at `194a8bd` and unpushed; 23/22 symlink counts; zero existing projects carry the route line; `wrap-session.md`'s advisory tolerance for an absent manifest) were independently re-derived and **confirmed exactly** — no discrepancy found on any of those four. The one gap is not a false claim but an unstated one: the CHANGE_DESCRIPTION does not mention `concurrent-session-check.md` as an affected consumer, and my own re-derivation found that it is (Dimension 5).

## Recommended redesign

Dimension 6's High is a genuine, unacknowledged principle tension (OP-9), and it alone forces RECONSIDER per the framework's special handling — the fix is not technical. Two legitimate paths, either is sufficient:

- **Rescope to avoid the violation:** hold Commit 2 until a real `direct`-route project exists and has actually accumulated the described overhead — i.e., let the first live consumer confirm the need before generalizing the session harness for it. This also resolves Dimension 7's Medium (the consequence becomes traceable) and shrinks Dimension 3/5's blast radius, since the change would then be scoped against a real footprint instead of a hypothetical one.
- **Or, make the revision loud and recorded (OP-11):** if the operator judges the anticipatory build worth doing now regardless of a confirmed consumer, log that explicitly as a deliberate exception in `logs/decisions.md` (context, decision, rationale, alternatives considered) before landing Commit 2 — turning the silent generalization into a recorded, intentional one.

Independent of which path is taken, before this ships as designed: (1) fix the `prime.md` 8a.3.d pause message so it does not reference a plan file that direct-route sessions never create; (2) decide explicitly whether the minimal direct-route mandate still writes `- Files in scope:` (recommended: yes, even in lean mode) so `concurrent-session-check.md`'s collision-safety mechanism is not silently and permanently blinded for an entire session class; (3) update `docs/session-marker.md`'s reader registry to record the new no-write exception.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
