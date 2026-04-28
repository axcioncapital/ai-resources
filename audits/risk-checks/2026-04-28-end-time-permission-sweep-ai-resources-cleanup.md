# Risk Check — 2026-04-28

## Change

end-time gate for /permission-sweep session 2026-04-27/04-28 (scoped to ai-resources only). Executed change set:
1. ai-resources/.claude/settings.json — removed `Read(audits/working/**)` deny entry that was structurally blocking the /permission-sweep command's own Step 4 protocol (main session reading the auditor's *.summary.md file). The deny had no leak-prevention value because audits/working/ is gitignored, and the corresponding subagent-contract discipline ("main session reads summary only") already lives in ai-resources/CLAUDE.md § Subagent Contracts. Discipline rule remains; the redundant mechanical guard does not.
2. ai-resources/.claude/settings.json — removed 6 redundant narrow Bash allow entries (Bash(git add *), Bash(git commit *), Bash(git restore *), Bash(chmod *), Bash(mkdir *), Bash(cp *)). All are covered by Bash(*).
3. ai-resources/.claude/settings.json — removed 28 redundant path-scoped Edit/Write allow entries (e.g., Edit(logs/**), Write(audits/**), Edit(.claude/**), etc.). All are covered by the bare Edit/Write/MultiEdit entries.
4. ai-resources/.gitignore — appended `inbox/archive/` (matches existing Read(inbox/archive/**) deny rule and the corresponding directory).

Net change to ai-resources/.claude/settings.json: allow list 35→5, deny list 9→8, file 139→100 lines. defaultMode unchanged (still bypassPermissions). Other denies unchanged.

Held items (not part of this risk-check scope): Finding 1 (research-workflow template placeholder, held with operator agreement); auditor template-class classification fix (logged to improvement-log.md as backlog, will go through its own /risk-check when applied).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.gitignore — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/permission-sweep-2026-04-27.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/permission-sweep-2026-04-27.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The settings.json reduction itself is safe and self-consistent (allow noise removed, file shrinks 139→100 lines, defaultMode unchanged), but the change set leaves `docs/permission-template.md` declaring `Read(audits/working/**)` as part of the canonical Layer C deny shape — the next `/permission-sweep` run will re-detect this as drift unless the template is also updated.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file content is added — the changes only remove entries from `.claude/settings.json` (35→5 allow, 9→8 deny; 139→100 lines per CHANGE_DESCRIPTION) and append one line to `.gitignore`. Settings JSON is consulted by the harness, not loaded into the model context per turn.
- No new hook, subagent, command, skill, or `@import` is introduced — verified by reading `.claude/settings.json:25–98` (existing hook block: `check-heavy-tool.sh`, `friction-log-auto.sh`, `log-write-activity.sh`, `coach-reminder.sh`, `improve-reminder.sh`, `check-stop-reminders.sh`, `friday-checkup-reminder.sh`) which is unchanged by the described change set.
- Net effect on ongoing token cost is zero or marginally negative (smaller settings.json if anything is read for diagnostics, e.g., `check-permission-sanity.sh`).

### Dimension 2: Permissions Surface
**Risk:** Low

- Allow list contraction is non-widening: every removed allow entry (`Bash(git add *)`, `Bash(git commit *)`, `Bash(git restore *)`, `Bash(chmod *)`, `Bash(mkdir *)`, `Bash(cp *)`, plus 28 path-scoped Edit/Write entries) is provably a subset of the retained `Bash(*)`, `Edit`, `Write`, `MultiEdit` bare entries — verified at `.claude/settings.json:3–9`. No new capability granted.
- Deny removal — `Read(audits/working/**)` — does widen Read surface for one path family, but the operator-stated risk model is sound: `audits/working/` is gitignored at `.gitignore:22`, so leaks through git are blocked, and the corresponding "main session reads summary only" discipline lives in `CLAUDE.md` § Subagent Contracts:36–42. No external surface change.
- defaultMode remains `bypassPermissions` (`.claude/settings.json:20`) — no scope escalation, no migration between settings layers.
- Other denies retained: `Bash(rm -rf *)`, `Bash(sudo *)`, `Bash(git push*)`, `Read(archive/**)`, `Read(logs/*-archive-*.md)`, `Read(inbox/archive/**)`, `Read(**/deprecated/**)`, `Read(**/old/**)` (verified at `.claude/settings.json:11–18`).

### Dimension 3: Blast Radius
**Risk:** Medium

- Settings file directly modified: 1 (`ai-resources/.claude/settings.json`). `.gitignore` directly modified: 1 (one-line append).
- Reference enumeration for the removed `Read(audits/working/**)` deny (grep across `ai-resources/`, all *.md/*.sh/*.json):
  - `docs/permission-template.md:133` — listed in canonical Layer C deny shape (the operative template the auditor compares against).
  - `docs/permission-template.md:273` — listed as the canonical example for Detection Rule 14.
  - `audits/permission-sweep-2026-04-27.md:20` — this session's report (informational).
  - `audits/innovation-sweep-buy-side-service-plan-2026-04-27.md:220` — historical caveat note (informational).
  - `logs/usage-log.md:284`, `logs/session-notes.md:382/404`, `logs/decisions-archive-2026-04.md:247`, `logs/session-notes-archive-2026-04.md:2038`, `logs/decisions.md:186` — historical decision/log entries (informational).
- Two of these references are operative (consumed by tooling), not informational: `docs/permission-template.md:133` (Layer C deny shape used by `permission-sweep-auditor` for canonical comparison) and `docs/permission-template.md:273` (Rule 14 canonical example). The change set does not update either. The settings file now drifts from its own declared canonical shape.
- Reference enumeration for the removed narrow `Bash(git add *)` etc. allow entries: 0 operative consumers — `grep -rn "Bash(git add" --include="*.md" --include="*.sh" --include="*.json"` across `ai-resources/` returned no hits beyond informational mentions in docs.
- Reference enumeration for the path-scoped `Edit(audits/**)` etc. removals: 0 operative consumers — `grep -rn "Edit(audits/"` returned no hits.
- `inbox/archive/` gitignore append matches existing `Read(inbox/archive/**)` deny at `.claude/settings.json:16` and existing operative directory referenced from `CLAUDE.md` ("Fulfilled briefs are moved to `inbox/archive/`") — no contract change.
- The drift between settings.json and permission-template.md is the load-bearing risk: `/permission-sweep` will re-detect it as a canonical-shape mismatch on the next run unless the template is updated to match.

### Dimension 4: Reversibility
**Risk:** Low

- Both files are tracked, single-file edits — `git revert` on the commit cleanly restores the prior `.claude/settings.json` (139 lines, 35-entry allow list, 9-entry deny list) and removes the `inbox/archive/` line from `.gitignore`.
- No external state propagation: no push declared in the change set, no Notion write, no API call, no symlink or hook registered.
- No log mutation that revert leaves stranded — the improvement-log.md backlog entry at line 70 ("permission-sweep-auditor: classify template sources, skip Rule 8") is independent of the settings change and is not part of the revert path.
- One marginal cleanup if reverted: `inbox/archive/` directory contents would no longer be gitignored (one extra `git status` noise file appears) until `.gitignore` is restored — fully covered by `git revert`.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- `docs/permission-template.md:131–136` declares the canonical Layer C deny shape including `"Read(audits/working/**)"`. `.claude/settings.json` no longer matches that shape. The next `/permission-sweep` run (including weekly `/friday-checkup --dry-run`) compares the live file to the canonical template and will surface a Rule 13 ("entries missing from canonical shape" / drift) finding against ai-resources Layer C — verbatim quote from the auditor's working notes at `audits/working/permission-sweep-2026-04-27.md:111`: *"The following entries appear in the `allow` list but are not present in the canonical Layer C shape in TEMPLATE_PATH"* (the auditor's drift logic compares allow/deny entries against `docs/permission-template.md`).
- `docs/permission-template.md:273` uses `Read(audits/working/**)` as the canonical illustrative example for Detection Rule 14, paired with `audits/working/` in `.gitignore`. Removing the deny but leaving the example creates documentation that contradicts the live file — future readers (operator or future agents) inferring policy from the template will draw the wrong conclusion.
- Implicit dependency: the operator-stated rationale ("audits/working/ is gitignored, so the deny adds no leak-prevention value") relies on `.gitignore:22` containing `audits/working/`. Verified present, but if a future change ever removes that gitignore entry, the deny is no longer there to backstop. The coupling is implicit because the gitignore line and the (now-removed) deny are not cross-referenced inside the settings file or CLAUDE.md.
- The discipline ("main session reads summary only") at `CLAUDE.md:34–42` is a contract enforced by agent-body convention, not by the harness. The deny was the mechanical backstop for the convention. Removing the backstop is consistent with the operator-stated design (CHANGE_DESCRIPTION: "Discipline rule remains; the redundant mechanical guard does not"), but the only remaining enforcement is convention compliance — flag for awareness, not a blocker.

## Mitigations

- **Mitigation for Dimension 5 / Dimension 3 (template drift):** before committing the settings.json change — or as a follow-up commit before the next `/permission-sweep` or `/friday-checkup --dry-run` run — update `docs/permission-template.md` so the canonical Layer C deny shape (line 133) no longer lists `"Read(audits/working/**)"`, and update the Rule 14 illustrative example at line 273 to a different deny pair (e.g., `Read(inbox/archive/**)` paired with `inbox/archive/` in `.gitignore` — both now exist post-change). Without this, `/permission-sweep` will re-fire the drift finding on every run.
- **Mitigation for Dimension 5 (gitignore coupling visibility):** add a one-line comment in `.claude/settings.json` near the deny block, or in `CLAUDE.md` § Subagent Contracts, noting that `audits/working/` is governed by `.gitignore` discipline + main-session-reads-summary convention, with the deny rule deliberately omitted. Makes the implicit dependency explicit so future agents do not "restore" the deny on autopilot when they see the canonical template still lists it (this becomes redundant once the first mitigation lands; either is sufficient, both is robust).

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references in `.claude/settings.json`, `.gitignore`, `CLAUDE.md`, `docs/permission-template.md`, `audits/permission-sweep-2026-04-27.md`, `audits/working/permission-sweep-2026-04-27.md`, plus grep counts across `ai-resources/` for `Read(audits/working`, `Bash(git add`, `Edit(audits/`, `audits/working`, and `inbox/archive`. No training-data fallback was used.
