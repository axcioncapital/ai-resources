---
description: Adversarial blind-spot scan on the current work package — stale dependent artifacts, real-usage fit, prerequisite/capability validity. Verdict-led, advisory only; modifies no files.
model: opus
---

Run an adversarial blind-spot scan on the current work package before the operator proceeds, commits, or closes the session.

**Governing principle: the job is not to make the work perfect. The job is to prevent false completion** — work that looks finished, approved, and stable while a hidden mismatch remains unresolved.

`/blindspot-scan` owns exactly three blind-spot categories (Checks A–C below). It verifies **external facts** — un-updated consumers, environment fit, harness capabilities — not the quality of the work itself. Any finding outside the three categories is reported as **one routing line, never expanded**:

| If the finding is really about… | Route to |
|---|---|
| Intent-vs-artifact mismatch (work no longer matches the original brief/contract) | `/contract-check` |
| Trajectory drift (session wandering from its mandate) | `/drift-check` |
| Structural risk (coupling, blast radius, permissions, reversibility) | `/risk-check` |
| Whether the work is worth doing at all / proportionality of the work itself | `/implementation-triage` — this is also the boundary for Check B: usage-fit judges a built or planned artifact's *fit*, not whether to build it |
| General artifact quality (correctness, completeness vs spec) | `/qc-pass` |

Input: `$ARGUMENTS` — optional one-line description of the work package. If empty, auto-detect (Step 1).

Advisory only — modifies no files, executes nothing, commits nothing.

---

### Step 1 — Context discovery (self-contexting)

Infer the work package; do not interrogate the operator.

1. Set `DATE` = today, `YYYY-MM-DD`. Set `REPO_ROOT` = `git -C "$(pwd)" rev-parse --show-toplevel` (if not a git repo, use cwd and skip the git evidence).
2. Gather: `git -C {REPO_ROOT} status --short`; `git -C {REPO_ROOT} log --since="{DATE} 00:00:00" --name-only --pretty="%h %s"`; the bottom-most `## {DATE}` block of `{REPO_ROOT}/logs/session-notes.md` (if present); the session-plan file via marker glob `logs/session-plan-*${MARKER}.md` (marker resolution per `docs/session-marker.md`; tolerate marker absence — read-only auxiliary consumer); plus the current conversation.
3. Set `WORK_PACKAGE` = the changed/planned files plus a one-line statement of intent. If `$ARGUMENTS` is non-empty, it overrides the inferred intent line.
4. If no work package can be inferred at all (clean tree, no plan, no conversation signal), say so and stop — do not scan the whole repo speculatively.

### Step 2 — Phase inference (silent calibration)

Classify, never ask, never print as a question:

- Plan/diagnosis exists, no diff → **pre-implementation**: weight Check C.
- Diff exists → **post-implementation**: weight Checks A + B.
- Wrap/commit/close signals in conversation → **pre-close**: run all three checks.

### Step 3 — Check A: stale dependent artifacts

For each changed (or to-be-changed) file and each renamed/retired identifier in `WORK_PACKAGE`:

1. Grep the **invariant stem** of the identifier — never the templated form (`${MARKER}` misses `{MARKER}`/`{marker}` spellings; rule per `skills/ai-resource-builder/SKILL.md` § Consumer-Inventory Gate). Run the grep **once per checkout** — from the workspace root AND inside `ai-resources/` (a single recursive grep from the root can silently skip the sub-repo) — covering: the changed repo's own sibling `.claude/commands/` files, the workspace root's `.claude/commands/` mirror copies, `docs/` registries, `.claude/hooks/`, `templates/`, and project symlinks (enumerate via `find projects -type l` when relevant).
2. Flag every consumer the change set did **not** touch. A registry that claims to list all consumers is itself a consumer — verify it, don't trust it.

### Step 4 — Check B: real-usage fit

Judge the artifact against the operator's **actual environment** (the checklist in Step 6), not against its spec. The question is not "is it correct?" but "will it actually run, get used, and help in this operator's real workflow?" The incident class this exists for: tooling that passed every QC gate but shipped inert because it assumed a terminal launch.

### Step 5 — Check C: prerequisite / capability validity

1. Every harness capability the plan or artifact relies on (hook-event semantics, settings precedence, frontmatter fields, subagent limits) must be verified against repo docs (`docs/`; the workspace-root `.claude/references/harness-rules.md` when present) — or flagged `[CITATION NEEDED]`, never assumed. Incident class: a fix plan that required a "blocking" SessionStart hook, which cannot block.
2. Does any step depend on a prerequisite that has not landed yet?
3. Fresh-session test: would a fresh session understand and execute this correctly from repo state alone, with no chat context? If not, name what is missing.

### Step 6 — Recurring operator-risk checklist

Check `WORK_PACKAGE` against each item:

1. Operator launches via VS Code, not terminal — terminal-only tooling sits unused.
2. Operator is a non-developer — fixes must not assume manual shell disciplines.
3. Dependent copies / docs / hooks updated together with the main artifact?
4. Is every claimed capability actually possible in the harness?
5. Multi-tool ecosystem — does the work wrongly assume a Claude-only environment?
6. Manual-step assumptions — will the operator actually remember/run the manual step?
7. Operator burden — does the fix embed into a natural gate, or add another thing the operator must remember? Memory-dependent fixes are flagged as weak.

### Step 7 — Output contract

Return exactly this shape:

- **Line 1:** `VERDICT: PROCEED | PROCEED-WITH-CONSTRAINTS | PAUSE-AND-FIX`
- **Then at most 5 findings**, each exactly three parts: *evidence* (file:line, grep hit, or git ref from the current repo/session state) → *named consequence* (the workspace materiality bar — no finding without one) → *one action*.
- **Anti-genericity rule:** findings of the form "consider testing / documentation / edge cases / maintainability" are prohibited. A finding without concrete current-state evidence is not a finding.
- **Proportionality rule:** never recommend a new command, file, agent, log, or registry unless no existing mechanism (the routing table above — same mechanism, output side) can handle the blind spot; the action must be proportionate to actual failure frequency, severity, and reversibility. Prefer: update one instruction / add one acceptance criterion / sync one file / run one smoke test.
- **Clean run:** if nothing material is found, say so — do not manufacture concerns: `No material blind spots found. Checked: {A: N consumers grepped, B: checklist, C: capabilities verified}.`

### Step 8 — Finding closure

The scan itself modifies no files. But on `PAUSE-AND-FIX` or `PROCEED-WITH-CONSTRAINTS`, instruct the session to record each open finding durably — in this session's session-plan file if one exists, otherwise as a `logs/maintenance-observations.md` session block — so closure routes into the existing fix loops (`/resolve`, `/friday-act`) instead of depending on operator memory. A finding that lives only in chat is itself a blind spot.
