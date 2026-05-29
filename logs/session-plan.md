# Session Plan — 2026-05-29

## Intent
Execute the six 2026-05-29 /friday-act fix plans in order — permissions-settings first (item 1, then items 2-7 each gated by /risk-check), middle plans by risk/dependency, general last (its last item being /cleanup-worktree).

## Class
execution

## Model
sonnet — → /model sonnet (active is opus-4-7)

## Source Material
- `audits/friday-plans/2026-05-29-permissions-settings.md` (7 items)
- `audits/friday-plans/2026-05-29-log-sweep.md` (3 items)
- `audits/friday-plans/2026-05-29-project-triages.md` (3 items)
- `audits/friday-plans/2026-05-29-repo-documentation.md` (6 items)
- `audits/friday-plans/2026-05-29-session-qc-pipeline.md` (4 items)
- `audits/friday-plans/2026-05-29-general.md` (10 items, last = /cleanup-worktree)
- `docs/audit-discipline.md` (risk-check change classes — referenced at each /risk-check gate)
- `docs/permission-template.md` (canonical settings layers — referenced by permissions-settings items)

## Findings / Items to Address

**Plan 1 — permissions-settings (7 items, 6 require /risk-check):**
1. [high] Reconcile `projects/nordic-pe-macro-landscape-H1-2026/.claude/shared-manifest.json` — 1 phantom entry + 14 drift instances · no /risk-check · permissions-settings.md §1
2. [high] Add `Bash(rm *)` to allow list in nordic-pe-macro `settings.json` · /risk-check required (settings.json class) · §2
3. [high] Remove stale `/Users/danielniklander/...` path from `projects/interpersonal-communication/.claude/settings.json` · /risk-check required · §3
4. [high] Remove `"model": "sonnet"` from `~/.claude/settings.json` (violates Model Tier rule; explicit operator memory `feedback_no_model_in_settings_json`) · /risk-check required · §4
5. [med] Retire 3 stale April-2026 deny entries in `ai-resources/.claude/settings.json` · /risk-check required · §5
6. [med] Remove `Bash(git push *)` deny from `obsidian-kb-builder` scaffold template · /risk-check required · §6
7. [med] Address 1 MEDIUM finding from `audits/permission-sweep-2026-05-29.md` · /risk-check required · §7

**Plan 2 — log-sweep (3 items, 0 require /risk-check):**
8. [med] `/log-sweep` ai-resources logs/session-notes.md + logs/usage-log.md · §1
9. [med] `/log-sweep` workspace logs/session-notes.md + archive gap-file · §2
10. [med] `/log-sweep` nordic-pe-macro — 2 Cat A2 + 1 Cat B · §3

**Plan 3 — project-triages (3 items, sub-fixes may trigger /risk-check):**
11. [med] Triage + dispatch 5 ai-development-lab improvement-log entries · §1
12. [med] Triage + dispatch 3 axcion-brand-book improvement-log entries · §2
13. [med] Triage + dispatch 6 nordic-pe-macro improvement-log entries (incl. 2 RECURRING — fix first) · §3

**Plan 4 — repo-documentation (6 items, 0 require /risk-check; items 2,4,5 before item 6):**
14. [med] Fix 3 W2.1 doc-scanner coverage gaps · §1
15. [med] Re-author `vault/components/projects.md` against §4.4 schema · §2
16. [low] Paste 7 net-new entries since 2026-05-22 into vault components · §3
17. [low] Decide handling for 212-entry carry-forward set · §4
18. [low] Decide deprecation-row policy · §5
19. [low] Re-run `/kb-integrity` after items 2/4/5 land · §6

**Plan 5 — session-qc-pipeline (4 items, 3 require /risk-check; items 1+2 [high]):**
20. [high] Complete TOCTOU mitigation Phases 2-4 (4 unpatched commands consume `.session-marker`) · /risk-check (shared-state automation) · §1
21. [high] Auto-apply /qc-pass fixes when REVISE + wording-level + no DISAGREE · /risk-check (workspace CLAUDE.md cross-cutting) · §2
22. [med] Add Step 2.5 self-check QC to `/session-start` · no /risk-check · §3
23. [med] Strengthen `/graduate-resource` Step 4+5 (verify gap is real first against 2-3 graduated resources) · /risk-check (workspace CLAUDE.md cross-cutting) · §4

**Plan 6 — general (10 items, item 1 needs explicit operator GO; item 9 = /cleanup-worktree, run last):**
24. [high] Concurrent-session detection hook (improvement-log #3) — DR-8 gate waiting for explicit operator GO · /risk-check (hook file) · §1
25. [high] Fix `log-sweep-auditor` Cat A2 heuristic misclassification · no /risk-check · §2
26. [med] Extract change-shape classifier to shared reference doc (consumed by `/consult` + `/pm`) · no /risk-check · §3
27. [med] Extract Q1-Q8 placement logic into `skills/placement-classification/SKILL.md` · /risk-check (new skill path) · §4
28. [med] Investigate sub-subagent dispatch limitation in `/pm` (mark `pending`, not `applied`) · no /risk-check · §5
29. [med] Create `logs/improvement-log.md` in obsidian-pe-kb + project-planning · no /risk-check · §6
30. [med] Schedule one dedicated session for /wrap-session refactor + permission-sweep-auditor follow-ups (do NOT execute the work here — schedule only) · no /risk-check · §7
31. [med] Build new `/clean-folder` workspace-level command (plan-only output) · /risk-check (new command path) · §8
32. [low] `/cleanup-worktree` ai-resources — last item per plan ordering · no /risk-check · §9
33. [med] `/improve-skill friday-act` — auto-triage Step 3 + 3.5 disposition loops · no /risk-check (improve-skill runs its own internal risk-check) · §10

## Execution Sequence

Per-plan loop: read plan → enumerate items → for each item: pre-flight /risk-check if required → apply → commit → move to next item. Commit each fix separately (workspace commit-behavior rule). Run /wrap-session at the end of each plan's items (per each plan's execution-notes).

1. **Permissions-settings (7 items).** Item 1 is the only no-/risk-check item; do it first (manifest reconciliation). For items 2-7: run `/risk-check` first, act on verdict, then apply edit + commit. Verification: each settings.json edit re-validated by reading the file back and confirming the change landed; /permission-sweep at end of plan for re-check.
2. **Log-sweep (3 items).** All mechanical `/log-sweep` invocations against named scopes. Verification: `wc -l` on rotated files shows reduction; new `*-archive-YYYY-MM.md` files exist.
3. **Project-triages (3 items).** Open each project's `logs/improvement-log.md`, confirm entries still active, dispatch fixes per /triage. Order: nordic-pe-macro RECURRING items first (per plan's execution-notes), then ai-development-lab, then axcion-brand-book. Per-sub-fix /risk-check if any sub-fix hits a structural class. Verification: triaged entries marked appropriately in source improvement-logs.
4. **Repo-documentation (6 items).** Items 2, 4, 5 must land before item 6 (kb-integrity re-run depends on schema decisions). Items 3, 4, 5 are operator-decision items (`Decide`) — surface and pick recommendation per decision-point posture. Verification: /kb-integrity verdict at item 6.
5. **Session-qc-pipeline (4 items).** Items 1 and 2 [high] first. Item 4 has a built-in "verify the gap is real first against 2-3 graduated resources" pre-step — do that before designing the fix. Items 1, 2, 4 each gate on /risk-check. Verification: each command/doc edit confirmed by re-reading the patched file.
6. **General (10 items).** Items 1 and 2 [high] first. **Item 1 hard-stops without explicit operator GO** (DR-8 gate). Item 5 is investigation-only (mark `pending` in decisions.md, do NOT mark `applied`). Item 7 is meta-scheduling — capture the schedule decision in decisions.md, do NOT execute that work here. Item 9 (`/cleanup-worktree`) runs absolutely last. Verification per item: file change reads back; commits land per-item.

Between-plan boundaries: emit a one-line summary at the end of each plan (count of items applied / deferred / escalated). Workspace CLAUDE.md "Between-gate summaries" rule applies.

## Scope Alternatives

- **Min** — Plan 1 (permissions-settings, 7 items) only. Highest-risk-density plan; finishing it alone is a meaningful Friday-act deliverable. Estimate: 60-90 min including /risk-checks.
- **Recommended** — Plans 1 through 4 (permissions-settings + log-sweep + project-triages + repo-documentation = 19 items). Skips the two cross-cutting CLAUDE.md edits in plan 5 (which warrant their own dedicated session) and the operator-GO-gated hook build in plan 6. Closes the mechanical and dispatch-style work in one session.
- **Max** — All 6 plans (33 items). Explicitly what the operator's mandate states. Context risk: plans 5 + 6 include 4 cross-cutting CLAUDE.md / workspace-level changes that each warrant deliberate framing. Apply the workspace `Context constraint deferral` rule if compaction threshold approaches mid-plan-5 — defer the remainder rather than rush.

Operator's stated mandate = max scope. If context constraint fires mid-execution, defer the unfinished plans and flag in the wrap. Item 24 (concurrent-session detection hook) requires explicit operator GO regardless of scope; will pause and ask.

## Autonomy Posture
Full autonomy

**Stop points:**
- Any `/risk-check` verdict of RECONSIDER or NO-GO on items 2-7, 20, 21, 23, 24, 27, 31 (any of the 11 risk-check-gated items)
- Item 24 (concurrent-session detection hook) — hard-stop for explicit operator GO before any build work begins (DR-8 gate)
- Items 17, 18 (repo-documentation Decide items) — pick the recommended option per decision-point posture but surface the choice in one line
- Inter-plan boundary if context budget is tight — surface the option to defer remaining plans
- Item 32 (`/cleanup-worktree`) — runs its own protocol with internal QC/triage prompts; let it gate naturally

## Risk

Run `/risk-check` before each of the 11 risk-check-gated items per the plans' explicit annotations. Items 21 and 23 cross workspace CLAUDE.md (high cross-cutting risk class); item 20 is shared-state automation; item 24 is a new hook file; items 27 and 31 are new skill / new command paths.

Run `/risk-check` again at end of session before commit per workspace audit-discipline (end-time gate), unless the end-time skip rule applies (plan-time covered with mitigations applied AND commits already shipped AND drift bounded — per operator memory `feedback_end_time_risk_check_skip`).

Tripwire reminder: items 26 and 30 are "extract to shared doc" / "scheduling" items that look harmless but item 26 introduces a two-end contract between `/consult` and `/pm` — verify cross-resource consistency in the extracted doc before commit.
