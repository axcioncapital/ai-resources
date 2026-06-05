# Session Plan — 2026-06-05

## Intent
Run the System Owner ungrounded-escalation fix (#14): make advisory agents that depend on a reference corpus stop-and-flag when their grounding files are absent on disk, instead of self-resolving into a silent proceed-degraded path. Scope to `.claude/agents/` only (clean lane, disjoint from the live concurrent maintenance-pipeline session).

## Model
opus — match (judgment-class change: deciding *when an agent halts* + classifying which sibling agents qualify).

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/system-owner.md` — primary target (the agent the #14 incident actually involved)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/project-manager.md` — sibling candidate (already has Fallback 5a/5b/5c stop paths — audit, edit only if a silent-degrade gap exists)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/expert-check-reviewer.md` — sibling candidate (already has NO APPLICABLE REFERENCE outcome + forbids training-knowledge fallback — audit, likely no edit)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/2026-06-05-repo-maintenance-problem-sweep.md` — §3 + row #14: the source diagnosis
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — structural-class reference for the risk pointer
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/references/grounding.md` — read-only reference: the per-function read map whose file-absence path is the fix site

## Findings / Items to Address
1. **system-owner.md grounding-absence path proceeds degraded, not escalated** (sweep §3 / row #14; incident 2026-06-02). The agent has a `Decline-when-ungrounded` rule (line 67) and a concrete-shape section (line 142), but those fire when the *central recommendation* can't be grounded — NOT when the grounding *files themselves are absent on disk*. The file-read map (lines 32–57) treats absence as "ground in vault only" / proceed-degraded, which is the silent path the incident exposed. **Fix:** add an explicit grounding-files-absent → stop-and-flag branch (escalate, name the missing files, offer a bounded next step) for the case where the reference corpus is missing on disk, distinct from the existing recommendation-cannot-be-grounded decline.
2. **project-manager.md — confirm stop-and-flag vs silent degrade** (Fallback 5a "question cannot be grounded", 5b no-project, 5c no-constitution-docs). It already *stops*. Confirm during execution whether any path silently degrades when constitution docs are absent; edit only if a real gap exists.
3. **expert-check-reviewer.md — confirm only.** Already returns `NO APPLICABLE REFERENCE` and explicitly forbids falling back to training knowledge. Likely no edit; confirm and record the no-change decision with one line of evidence.
4. **DEFERRED (not this session):** the improvement-log #14 status flip — `logs/improvement-log.md` is owned by the live concurrent session. Hold the flip until they commit, then append it cleanly.

## Execution Sequence
1. **Read the three agent files in full** + the sweep §3 and grounding.md file-absence path. Verify which agents have a genuine silent-degrade-on-absent-files gap. → criterion: each of the three agents classified as EDIT or NO-EDIT with one line of evidence.
2. **Edit system-owner.md** — add the grounding-files-absent → stop-and-flag branch, worded to sit alongside (not replace) the existing decline-when-ungrounded rule. → criterion: the branch names the absent-files condition, halts, flags, and offers a bounded next step; existing rules intact.
3. **Edit sibling agents only if Step 1 found a real gap.** Stay inside `.claude/agents/`. → criterion: each sibling either edited with the same branch shape, or recorded NO-EDIT with evidence.
4. **`/qc-pass`** on the edited agent file(s). → criterion: GO (resolve any findings, re-QC).
5. **Commit** the agent-file changes (explicit paths only — never `git add -A`, given the concurrent session's uncommitted work in the tree). → criterion: commit contains only `.claude/agents/` files.
6. **Record the deferred #14 log-flip** as a Next Step in the wrap (do not touch `improvement-log.md` this session).

## Scope Alternatives
- **Min:** system-owner.md only (the one agent the incident involved) + QC + commit. Siblings deferred to a follow-up.
- **Recommended:** system-owner.md edit + audit-and-confirm project-manager.md and expert-check-reviewer.md, editing siblings only where a real gap exists. (This plan.)
- **Max:** sweep all 10 grounding-referencing agents from the candidate grep for the same silent-degrade pattern. Rejected as scope creep — the audit named only the three corpus-dependent advisory agents; the other seven are scanners/auditors whose "no input" paths are already mechanical.

## Autonomy Posture
Gated — judgment-class change (alters when an agent halts). Proceed autonomously through the read/classify/edit/QC/commit sequence, but pause at the named stop points below.

**Stop points:**
- Before editing any sibling agent beyond system-owner.md — confirm the Step 1 EDIT/NO-EDIT classification first (avoids editing agents that already stop-and-flag).
- Before any edit that would touch a file outside `.claude/agents/` — that crosses into the concurrent session's lane; stop and flag instead.

## Risk
Run `/risk-check` after this plan is approved (plan-time gate): the change alters advisory-agent halt behavior — a judgment-class change the sweep flagged as "focused session, not a quick tweak." Likely GO (existing-agent behavior edit; no hooks, permissions, symlinks, settings, or shared-state automation), but the halt-behavior change across potentially multiple agents warrants the explicit pass. Re-run before commit if scope expands beyond system-owner.md.
