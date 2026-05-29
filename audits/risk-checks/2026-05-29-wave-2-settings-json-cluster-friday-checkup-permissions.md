# Risk Check — 2026-05-29

## Change

Bundle of four settings.json edits across three settings files (one cluster /risk-check per Wave 2 of session-plan-S6.md):

(1) Add `Bash(rm *)` to allow list in `projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json` (Rule 6 — delete/remove operations currently prompt) — Friday-checkup permissions-settings plan item #2 [high].

(2) Remove stale `/Users/danielniklander/...` absolute path from `projects/interpersonal-communication/.claude/settings.json` `additionalDirectories` (Rule 9 — user not present on this machine) — Friday-checkup permissions-settings plan item #3 [high].

(3) Remove `"model": "sonnet"` from `~/.claude/settings.json` (user-level) — violates Model Tier rule (contests `/model` overrides in live sessions); operator memory `feedback_no_model_in_settings_json` is explicit on this — Friday-checkup permissions-settings plan item #4 [high].

(4) Address 1 MEDIUM permission-sweep finding from `audits/permission-sweep-2026-05-29.md` (specifics to be identified at execution time; likely settings.json) — Friday-checkup permissions-settings plan item #7 [med].

Each change is one settings.json edit. Blast radius per item: bounded to the file's owning project/user scope. Reversibility: high (single-line revert). All four fall in the same change class (settings.json) with similar risk profiles; bundling them in one /risk-check is the cluster pattern from session-plan-S6.md.

Source plan: ai-resources/logs/session-plan-S6.md Wave 2 (items 7-10).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/interpersonal-communication/.claude/settings.json — exists
- /Users/patrik.lindeberg/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/permission-sweep-2026-05-29.md — exists

## Verdict

RECONSIDER

**Summary:** Three of the four bundled items (1, 2, 3) have stated premises that do not match the current file state on disk — Item 1's `Bash(rm *)` is already present, Item 2's stale `danielniklander` path is not present, and Item 3's `"model": "sonnet"` field is not present. Bundling and executing these as if they were live edits would produce no-op or corruptive diffs against an out-of-date audit; the cluster requires re-grounding before execution.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- None of the four items adds content to always-loaded files (CLAUDE.md, system-prompt) — all four edit `.claude/settings.json` files which are loaded structurally by Claude Code but not as conversation tokens. Evidence: items target `permissions.allow`, `permissions.additionalDirectories`, and a (claimed) top-level `model` field; no `hooks` or `additionalContext` additions.
- Item 1 (if executed) adds one allow-list entry (~13 chars) — negligible.
- Item 2 (if executed) removes a stale path — net token reduction.
- Item 3 (if executed) removes the (claimed) `"model"` field — net token reduction, and removes a default that contests `/model` overrides (operational cost, not token cost).
- Item 4 specifics unknown — but `permission-sweep-2026-05-29.md` § MEDIUM Findings (lines 38-43) shows M1 is a Layer A vs B divergence on `deny` rules and `Edit(**)`/`Write(**)` breadth, explicitly tagged "Operator review. Layer A is intentionally more permissive (personal machine); divergence is by design. No mechanical fix unless operator wants uniform git guards at user level." — meaning even item 4 has no token-cost impact.

### Dimension 2: Permissions Surface
**Risk:** Medium

- **Item 1 — already applied.** Evidence: `projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json` line 6 contains `"Bash(rm *)"`. The audit at `audits/permission-sweep-2026-05-29.md` § H1 lines 26-29 flagged the gap, but the gap is closed on disk. Re-applying is a no-op diff. If the change is naively executed (e.g., appending without dedup), it produces a duplicate-key JSON or a duplicated array element — at minimum cosmetic noise, at worst a parse warning.
- **Item 1 substance, if it were live.** Adding `Bash(rm *)` to allow widens the permission surface to general delete operations. However, this is paired with existing `Bash(rm -rf *)` deny (line 23) which constrains the dangerous form. The expansion is bounded and follows the established workspace pattern (workspace-root settings has the same pairing — confirmed by grep line 17-18, line 28 of workspace settings.json). Risk would be Low if the file did not already contain the rule.
- **Item 2 — premise contradicted.** Evidence: `projects/interpersonal-communication/.claude/settings.json` lines 31-33 `additionalDirectories` contains only `"/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"` — no `danielniklander` path present. The audit § H2 lines 31-34 claims this stale path exists. The audit is wrong, OR the path was already removed between scan and now. Either way, item 2 cannot be executed as described — there is nothing to remove.
- **Item 3 — premise contradicted.** Evidence: `~/.claude/settings.json` has no `model` field anywhere — `grep -n "model" "/Users/patrik.lindeberg/.claude/settings.json"` returned no matches. The file does contain other top-level keys (`effortLevel`, `autoCompactWindow`, `skipDangerousModePermissionPrompt`, `autoCompactEnabled`, `autoMode`, `agentPushNotifEnabled` — lines 100-112) but no `"model": "sonnet"` line. Item 3 has nothing to remove. Note: the plan-item premise aligns with operator memory `feedback_no_model_in_settings_json`, which is correct policy — but the policy is already in effect at the file level.
- **Item 4 — unspecified but premise constrained.** The audit § MEDIUM (lines 38-43) lists exactly one MEDIUM finding (M1 — Layer A vs B divergence) and explicitly tags it "Operator review … No mechanical fix unless operator wants uniform git guards at user level." Item 4 is therefore an operator-judgment item, not an automatic fix. Executing it requires either adding `Bash(git reset --hard *)` and `Bash(git checkout *)` to the user-level `deny` array (small permission tightening — Low) OR narrowing `Edit(**)`/`Write(**)` to specific globs (Medium — could break existing autonomous edits). Without the specific decision, the risk is Medium.

### Dimension 3: Blast Radius
**Risk:** Low

- Item 1 — single file (`projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json`). Project-scoped. No callers outside the project consume the project's allow list directly.
- Item 2 — single file (`projects/interpersonal-communication/.claude/settings.json`). Project-scoped. `additionalDirectories` affects session reachability of cross-paths from sessions opened in that project's directory only.
- Item 3 — user-level (`~/.claude/settings.json`). Affects all Claude Code sessions on this machine when the file is the active layer. However, since the file does NOT currently contain `"model": "sonnet"`, executing the planned edit is a no-op.
- Item 4 — scope depends on which side of the M1 divergence is touched. Layer A (user-level) edit = workstation-wide. Layer B (workspace root) edit = workspace-wide for any session opened in the workspace.
- Grep verification: `additionalDirectories` referenced across 8 project settings.json files (output of grep across `/projects/`), each independent. No cross-coupling between project settings.json files. Confirmed by reading audit § "Files with no findings" (line 86-88) — all other files conform.

### Dimension 4: Reversibility
**Risk:** Low

- Each of the four items, IF the premise matched, is a single-line edit to a `.claude/settings.json` file. `git revert` restores prior state cleanly for items 1, 2, 4 (workspace-tracked files).
- Item 3 edits `~/.claude/settings.json` which is OUTSIDE the workspace and not under git. Reversibility relies on the `.bak-2026-04-25` snapshot that exists alongside it (confirmed by `ls -la`), but that backup is from April and contains different config (deny rules absent, autoMode block in different shape per diff output). Manual revert would need the operator's own backup discipline.
- Since items 1, 2, 3 have premises that don't match the file state, no edit will actually be made for those — the "revert" is moot.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Stale-audit coupling.** The bundle is sourced from `audits/permission-sweep-2026-05-29.md`, which was a dry-run scan. The audit findings are point-in-time — between scan and execution, other work shipped that closed the gaps (Item 1's `Bash(rm *)` is on line 6 of the target file; the operator's commit log shows ~50+ commits today including `49bd826`, `c40256e`, `80e9ccf` tagged as already-shipped permissions-settings items per session-plan-S6.md lines 17). Executing audit recommendations without re-grounding produces duplicate edits or hits ghosts.
- **Operator-memory vs file-state divergence (item 3).** Operator memory `feedback_no_model_in_settings_json` explicitly forbids the `"model"` field, and the file already conforms — the policy is in effect. The plan-item phrasing ("Remove `"model": "sonnet"` from `~/.claude/settings.json`") suggests the planner did not Read the file before generating the item. This is a hidden coupling between the friday-checkup plan generator and the file scanner — if they're decoupled (one's reading the policy, the other isn't reading the file), every Friday-cycle re-emits these phantom items.
- **Audit M1 explicit "operator review" disclaimer (item 4).** Audit § M1 lines 41-43 explicitly says: "Operator review … No mechanical fix unless operator wants uniform git guards at user level." Item 4 in the plan treats this as an executable change to be applied at risk-check time. The hidden coupling is between the plan's auto-classification of audit findings as "executable" vs the audit's explicit framing of M1 as a judgment-call. Executing item 4 without an operator decision contradicts the audit's own guidance.
- **Cluster pattern itself.** Bundling four items as one /risk-check assumes all four have the same change class and similar risk profile (session-plan-S6.md lines 39-42). In practice: item 1 is permission expansion, item 2 is path hygiene, item 3 is policy enforcement, item 4 is operator judgment on divergence. These are four distinct risk shapes. The cluster framing hides the heterogeneity.

## Recommended redesign

- **Re-ground before re-clustering.** Read each target file before re-issuing items 1–3 to the plan. Either drop them with a "premise-not-found, audit stale" note in the friday-checkup follow-up, or upgrade the audit-to-plan generator to read the file before emitting a fix-instruction (closes the stale-audit coupling identified in Dimension 5). Re-run `/permission-sweep` in non-dry-run mode against current file state to regenerate findings honestly.
- **Split item 4 from the cluster.** Item 4's source finding (M1) is explicitly an operator-review item per the audit (§ MEDIUM, lines 41-43), not a mechanical fix. Bring it to the operator as a single yes/no decision ("Do you want uniform git guards (`Bash(git reset --hard *)`, `Bash(git checkout *)`) added to the user-level `deny` array? y/n") rather than absorbing it into a cluster /risk-check that assumes a planned change. If the operator says yes, that single edit can run as its own change-class instance (still settings.json, but Layer A scope) with its own focused risk-check.

## Source-Doc Citations

- `audits/permission-sweep-2026-05-29.md` lines 26-34 (H1 Bash(rm *) and H2 stale path findings); lines 38-43 (M1 Layer A vs B divergence, explicit "Operator review" disclaimer); lines 86-88 (no-finding files); line 92 (working-notes link).
- `projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json` line 6 (`"Bash(rm *)"` already present in allow); line 23 (`"Bash(rm -rf *)"` in deny — pairing pattern).
- `projects/interpersonal-communication/.claude/settings.json` lines 31-33 (`additionalDirectories` contains only `/Users/patrik.lindeberg/...`; no `danielniklander` path).
- `~/.claude/settings.json` full file (lines 1-113) — no `"model"` field present at any line; verified by grep.
- `ai-resources/logs/session-plan-S6.md` lines 37-42 (Wave 2 item enumeration); lines 17-20 (already-shipped commit hashes); lines 83-84 (cluster /risk-check sanction).
- `ai-resources/docs/audit-discipline.md` lines 7-13 (top-3-commands-affected pre-application analysis required for permission changes); lines 19-26 (Risk-check change classes — settings.json edits qualify); line 3 (Model Tier rule reference — `"model"` additions prohibited, file already conforms).
- Workspace `CLAUDE.md` § Model Tier (full section in claudeMd context) — confirms `"model"` field is prohibited in any settings.json; operator memory `feedback_no_model_in_settings_json` (in MEMORY.md) reinforces.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references for premise-mismatch findings (items 1, 2, 3), verbatim quote from audit M1 disclaimer (item 4), grep output for `model` and `Bash(rm` patterns, and audit-discipline.md line ranges for change-class taxonomy. No training-data fallback used. The RECONSIDER verdict is driven primarily by Dimension 5 (Hidden Coupling) High rating — the stale-audit-to-plan pipeline is a structural issue that no per-item mitigation cures.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory) — **SKIPPED, with reason.**_

Step 4a of `/risk-check` invokes `/consult` automatically on non-GO verdicts. In this instance the recommended redesign is to **drop the cluster** (items 1, 2, 3 are no-ops per direct file evidence; item 4 is an operator-judgment item per the audit's own disclaimer). Function B is *pre-change advisory* — there is no proposed change left to advise on architecturally once the cluster is dropped. The verdict's grounding is factual (file state and audit text), not architectural.

The relevant process issue (audit-to-plan stale coupling, Dimension 5 High) is a **maintenance-cadence concern**, not a Function-B-shaped question. It belongs in `logs/maintenance-observations.md` or as a new Friday-checkup follow-up item, where the System Owner already reviews it on the quarterly cadence per `friday-checkup.md`.

Logged here so the deviation is loud rather than silent.
