# Session Plan — 2026-07-24

## Intent
Triage the 30 open HIGH-severity entries in `logs/improvement-log.md` — verify each entry's real status by execution, then close, park, or downgrade it.

## Model
opus — match (active: Opus 4.8). Triage is judgment under ambiguity: deciding whether a recorded defect is still real, not executing a defined process.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` (1,898 lines — the triage target)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log-archive.md` (545 lines — destination for closed entries; establishes the archive entry shape)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-improvement-log.md` (the canonical archive command — read before hand-rolling the move)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/repo-health-backlog-2026-07.md` (bound mission; threads 12 and 15 correspond to entries 1/3/4 below)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` (§ Absence-claims — the "search instrument is not neutral" rule governs every verification below)

## Findings / Items to Address

Measured 2026-07-24: the `/prime` Step 3 scan emits **399 lines / 81,008 chars** (~20k tokens) per orientation, from 50 severity hits. 20 belong to already-closed entries; the 30 below are genuinely open. Anchors are line numbers in `logs/improvement-log.md`.

**Class A — defect claims verifiable against a named file (14).** Each names a file and a broken behaviour; check whether the behaviour is still broken.
1. `:40` [high] Marker-teardown backstop prune unreachable under VS Code — `detect-concurrent-session.sh:170-185`
2. `:253` The staging guard never reads `Required outputs`, so schema-correct sessions get blocked
3. `:1109` `friction-log.md`'s five newest session blocks invisible to all four parsers (drifted header grammar)
4. `:1185` Destructive `rm` inside `for` over `$(find …)` word-splits spaced paths
5. `:1203` [high] `warn-settings-change.sh` fails open — reads a field the PreToolUse payload lacks
6. `:1247` `grep` shadowed by a gitignore-aware function; workspace-root audits see an empty ai-resources
7. `:1322` `/close-worktree-session` committed unresolved stash-pop conflict markers into a tracked log
8. `:1451` `check-destructive-liveness.sh` logs "proceeded" for a command that never ran
9. `:1586` `check-foreign-staging.sh` resolves a gated `git add` against the wrong repo when nested
10. `:1645` `axcion-communication-system` scaffolded with no `logs/scripts/` — every wrap fails
11. `:1675` Deleting `warn-settings-change.sh` invalidated System Owner v2 stage S2/B3's stated remedy
12. `:1699` `wrap-session.md` Step 5 lacks the prepend warning Step 4 carries
13. `:1725` [high] `check-archive.sh` walk-up fallback archives the WRONG repo's logs
14. `:1751` 33 canonical commands unreachable from a workspace-root session

**Class B — gate-held designs, nothing built (4).** These are not open *defects*; they are designs a `/risk-check` rejected. The recorded status is accurate — the question is whether "open HIGH" is the right shelf for a decision already made.
15. `:22` Thread 15 held at RECONSIDER; two stated sub-tasks proven false
16. `:79` Thread 16's override defect diagnosed and gate-scored; blocked on the harness entry above
17. `:106` Thread 15's emit-side redesign SCORED RECONSIDER (measured its output, never its own weight)
18. `:1341` Lease-based session identity (id→pid map) — approved follow-up, unbuilt

**Class C — behavioural / discipline findings (11).** No file carries the defect; these record how a session went wrong. Most likely mis-shelved: doctrine is not an urgent problem queue.
19. `:157` Repo-scoped instrument used for a workspace-wide claim, twice in one session
20. `:212` Heuristic regex trusted as a file census, setting a mandate's scope wrongly
21. `:1083` [high] Backlog entries prescribe their own fix; the executing session builds it without re-deriving
22. `:1267` [high] Operator opened with a proposed solution; the objective was never asked for
23. `:1461` A `/risk-check` RECONSIDER that changes the deliverable is drift nothing routes to `/contract-check`
24. `:1492` A gate names only the triggering decision, so the operator overrides more than they know
25. `:1502` Gate stack produced three consecutive operator questions on one task
26. `:1531` A "do not do X" warning sat in my own scan output and X was designed anyway
27. `:1576` Fourth count/measurement error in one session; static-cost claim understated 16.1×
28. `:1628` `/prime` cross-checks Next Steps against git but not mission threads
29. `:1887` `/risk-check` Step 2.6 verifies structural claims but not qualitative evidence citations

**Class D — premise-failed work source (1).**
30. `:1132` Deploy-fitness audit's premises have failed 3 for 3 — entry asks for a re-gate, not a fix

## Execution Sequence

1. **Read the archive command first.** `/resolve-improvement-log` exists; read it and use it if it fits. *Verify:* either the command drives the archive step, or one line in the wrap note states why it did not.
2. **Class A verification pass (14 entries).** For each, run the specific check the entry implies — grep the named file for the named defect, or execute the named script path. Never infer from the entry text; `audit-discipline.md` § Absence-claims governs the instrument choice, and a repo-scoped instrument may not answer a workspace-scoped claim (this is finding 19's own lesson, applied). *Verify:* every Class A entry carries a recorded instrument and its output before any disposition is written.
3. **Class B disposition (4 entries).** These need a judgment, not a check: a twice-rejected design sitting at HIGH re-offers rejected work at every orientation. Default disposition is **park** (`Review-cycle:` reset), not close — the underlying cost is real. *Verify:* each retains its gate record; none is archived.
4. **Class C disposition (11 entries).** Decide per entry whether it is an *open problem* or a *recorded lesson*. A lesson whose remedy is doctrine belongs at medium severity or in a doc, not in the urgent queue. Downgrade, do not delete — the record survives either way. *Verify:* no Class C entry loses its content; only its `Severity:` field or location changes.
5. **Present dispositions before writing.** One table: entry, class, instrument used, proposed disposition, one-line reason. **This is the session's single stop point.** *Verify:* operator sees all 30 rows before any edit lands.
6. **Apply approved dispositions.** Archive closed entries to `logs/improvement-log-archive.md` preserving their full block; flip statuses and severities in place for the rest. *Verify:* archive line count grows by the moved content; no entry is lost from both files.
7. **Re-measure the scan.** Re-run the live `/prime` Step 3 command and record the new line/char count against today's 399 / 81,008 baseline. *Verify:* the number is produced by executing the scan, not estimated.

## Scope Alternatives
- **Min** — Class A only (14 entries). Purely mechanical verification, highest confidence, leaves the two judgment classes untouched. Cuts perhaps a third of the scan.
- **Recommended** — all 30, as sequenced above. Class C is where the real over-classification is, so skipping it leaves the main problem in place.
- **Max** — all 30, plus propagating the `Severity:` schema block to the 13 project logs where the scan currently returns zero. **Rejected for this session:** that is a separate logged item (`:127`), spans 13 repos, and is routed to `/friday-act`. Naming it here so it is not silently forgotten.

## Autonomy Posture
Gated — one stop point, not thirty.

**Stop points:**
- After Step 5, before any file edit: operator reviews the full 30-row disposition table. Everything before that point is read-only verification; everything after is mechanical application of an approved decision.

## Risk
No structural change classes apparent — the edits touch two log files, not commands, hooks, skills, symlinks, or always-loaded content. `/risk-check` is not triggered by this scope, and the operator additionally directed skipping it for this task; the direction is moot here rather than an override.

Two live risks the gate would not have caught anyway:
- **Verification theatre.** The entries most likely to be wrongly closed are Class C, because there is no file to check and "this feels resolved" is indistinguishable from evidence. Class C dispositions must be argued from the entry's own stated remedy, not from impression.
- **Evidence destruction.** `:40` explicitly warns against hand-deleting the three stale markers it cites as evidence. Archiving an entry must never be paired with removing the artifact that entry documents.
