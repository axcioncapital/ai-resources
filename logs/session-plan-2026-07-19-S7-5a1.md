# Session Plan — 2026-07-19

## Intent
Merge the S6-623 queued-instruction evidence from `axcion-content-programme` into the existing 2026-07-14 entry at `logs/improvement-log.md:1082`, escalate it to `high` on that entry's own stated trigger, then design and `/risk-check` a mechanical detector for backlog `Proposal:` / `Target files:` lines that prescribe a route while carrying no `file:line` evidence.

## Model
opus — match (deciding, not doing: the work is design under two conflicting repo records plus a gate judgment)

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` — target entry at `:1082`; the schema anchors being detected
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md` — Step 3, the precedent count-scan shape and its do-not-regress cost warning
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md` — routes the QUEUE writer (`:302`)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/session-feedback-collector.md` — owns the write format for queued entries
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/open-items.md` — reader of the log
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/check-decision-refs.sh` — reference implementation of a command-invoked scan
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/check-usage-log-format.sh` — second reference implementation
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/search-canary.sh` — the absence-claim canary; this session already tripped the trap it guards
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — `§ Absence-claims`; risk-check change classes
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/output/context-packs/hook-20260719-b4e7c/pack.md` — this session's context pack (two conflicts, one false positive)

## Findings / Items to Address

1. **A near-duplicate entry already exists here** — `improvement-log.md:1082` (2026-07-14), *"Backlog entries prescribe their own fix, and the executing session builds it without re-deriving it."* Status pending, severity medium. Do not raise a second entry; merge into this one.
2. **That entry's escalation trigger is already met** — it states *"Score: 1 for 1 on entries tested. A second instance should be enough to stop recording and start labelling the fields"* (`:1092`). The 2026-07-18 confirming instance is recorded inline; S6-623 supplies further instances. Escalation to `high` is the entry's own rule, not a fresh judgment.
3. **The routed instruction's target anchor is wrong for this repo** — measured: `Proposal:` 70, `Target files:` 108, `Fix:` 1, `Fix candidate:` 0. In `axcion-content-programme` the counts invert (`Fix:` 3, `Fix candidate:` 1, `Proposal:` 0). A detector built to the handoff's literal wording would scan an anchor appearing once and report a near-empty result while appearing to work. This is itself an instance of the defect, committed inside the handoff describing it.
4. **The context pack asserted a false absence** — *"no file in the workspace mentions S6-623"*; actual 12 files. Cause: harness `grep` honours `.gitignore` and `.gitignore:56` ignores `projects/axcion-content-programme/`; dot-rooted `grep -r X .` → 0, `command grep -r X .` → 12. Already documented at `docs/audit-discipline.md:37` with `logs/scripts/search-canary.sh` as its guard. Relevant to the detector: any scan shipped must state its own scope limits.
5. **One pack conflict is a false positive** — `improvement-log.md:180`'s *"the declared schema field is the more honest fix"* concerns `/mission check`'s assertion field, a different artifact. Not a contradiction of S6-623's rejection. It is, however, live precedent for the same shape: declare the field when the entry is filed, read it when the entry is executed.
6. **Placement is decided** — `logs/scripts/`, not `.claude/hooks/`. It is a command-invoked scan (matching items 6–7 of Source Material), and hook wiring in this workspace is unversioned, a separate open HIGH; a new hook would inherit that defect.

## Execution Sequence

1. **Read the target entry in full** (`improvement-log.md:1082` to its next `###` boundary). *Verify:* the 2026-07-14 entry's `Proposal:` and `Target files:` fields are quoted accurately in what follows; the escalation trigger sentence is confirmed present at `:1092`, not recalled.
2. **Merge and escalate the entry.** Add S6-623's instances, both rejected designs with their evidence, and this session's three corrections. Flip `Severity: medium` → `high` citing the entry's own trigger. *Verify:* re-run `/prime` Step 3's severity scan and confirm the entry now matches, and that no duplicate entry was created.
3. **Design the detector.** Scan `Proposal:` / `Target files:` lines for route-prescribing language carrying no `file:line` and no explicit unverified marker. Define the marker grammar and the `file:line` shape — both currently undefined anywhere (pack, missing-context item 5). *Verify:* the design states its own scope limits and false-negative modes in writing.
4. **Run `/risk-check` on the design (plan-time gate, Autonomy Rules #9).** *Verify:* a verdict is returned and a report lands under `audits/risk-checks/`.
5. **On GO only — build `logs/scripts/check-fix-route-evidence.sh`.** Declare expected output before first run (falsifiability discipline: the S12-3cd BSD-`sed` false-PASS lesson). *Verify:* the script executes against the live `improvement-log.md` and returns a real, hand-checkable count; at least one true positive and one true negative are confirmed by reading the cited entries.
6. **On RECONSIDER / NO-GO — stop.** Record the design in the merged entry. Build nothing.

## Scope Alternatives

- **Min:** steps 1–2 only — merge and escalate the entry, record the detector design as a proposal, build nothing. Leaves the defect tracked and correctly rated with no new runnable code.
- **Recommended:** steps 1–5 — merge, escalate, design, gate, and build on GO.
- **Max:** recommended plus a second scan pass over the sibling `friction-log.md` and `decisions.md` for the same route-without-evidence shape. Deferred unless steps 1–5 finish with clear context headroom; `decisions.md` is a third surface the content-programme record explicitly names as uncovered.

## Autonomy Posture
Gated

**Stop points:**
- After step 3, before step 4 — `/blindspot-scan` fires here (the plan creates new runnable infrastructure: a new script under `logs/scripts/`). Surface the verdict inline; resolve findings on PAUSE-AND-FIX.
- After step 4 — `/risk-check` verdict. RECONSIDER or NO-GO halts the build per the mandate's stop condition.
- Before any edit to `prime.md`, `wrap-session.md`, or `session-feedback-collector.md` — these are read-only in this mandate. If the design turns out to require editing one, that is a scope change: surface it rather than absorbing it.

## Risk
Run `/risk-check` after the plan is approved (plan-time gate) — the work creates new automation reading a shared log consumed by at least four commands. Run it again before commit (end-time gate) unless the standing skip rule applies.

Environment-fit: the artifact is a command-invoked shell scan, not a launcher — the VS Code-launch baseline does not bite here. It must be invocable from within a session, not from a terminal alias.

Known blast-radius note for the gate: `improvement-log.md` is read by `/prime` Step 3, `/open-items`, `/wrap-session`, and `session-feedback-collector`. The detector adds a reader, not a writer, which bounds the risk — but `/prime` Step 3 carries an explicit do-not-regress cost warning, so any proposal to wire this into orientation must be scored against it rather than assumed cheap.
