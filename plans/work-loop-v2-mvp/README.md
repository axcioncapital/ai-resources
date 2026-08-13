# Work Loop v2 MVP — governing documents

This folder holds the four documents that govern the build of the Work Loop v2 MVP. Read this file before reading any of them.

Project mission: `ai-resources/logs/missions/work-loop-v2-mvp.md`.

---

## Authority order

Higher entries win. A lower entry never silently overrides a higher one.

| # | Document | Authority |
|---|---|---|
| 1 | [`work-loop-v2-mvp-proposal-v0.4.md`](work-loop-v2-mvp-proposal-v0.4.md) | **AUTHORITATIVE.** The plan. Its settled decisions (Section 3) and standing rules (Section 6) are **binding**. |
| 2 | [`pocock-lifecycle-work-loop-mvp-v0.4.md`](pocock-lifecycle-work-loop-mvp-v0.4.md) | **EXECUTION GUIDE, subordinate to the Proposal.** Says what to do, in order, in which kind of session. Where it and the Proposal disagree, the Proposal wins and the disagreement is a defect in the Playbook. |
| 3 | [`skill-writing-standard-work-loop-v0.2.md`](skill-writing-standard-work-loop-v0.2.md) | **BINDING ON HOW THE ARTIFACTS ARE WRITTEN, not on what gets built.** Applies to any session drafting or revising the Claude Code command, the Codex resource, or the executable core. It governs form and quality; it never expands scope. |
| 4 | [`the-work-loop-explained-complete-system-v0.2.md`](the-work-loop-explained-complete-system-v0.2.md) | **DESTINATION REFERENCE ONLY. NOT A REQUIREMENTS DOCUMENT.** |

---

## The rule that matters most

**Document 4 must never be used to justify building anything.**

It describes the full Work Loop as it is meant to work when complete — every role, lane, and capability, including the Consequential lane, worktree isolation, independent-reviewer machinery, and automation. **None of that is MVP scope.** MVP scope is defined by the Proposal, Section 3 (settled decisions), Section 4 (the destination), and Section 5 (the four phases). Everything else in Document 4 is post-MVP and waits for a real operational trigger, per Proposal Section 7.

This is written down because the repo's own rule (Document 4, Section 8) is that **repository content creates requirements only when its source is explicitly authoritative for the current work. Imperative wording alone creates nothing.** Document 4 is full of imperative wording — "Codex must", "the loop is entered only for" — and none of it is a build instruction. It is a description of a destination.

If a future session finds itself building the Consequential lane, a worktree mechanism, a hooks/automation layer, or an independent-reviewer role, it has misread this folder. Stop and check the Proposal's scope.

---

## Relationship to the existing Work Loop (v1)

A Work Loop **v1** already exists and is live in this repo. It is a different thing from the subject of this folder:

| v1 (live now) | v2 MVP (being built) |
|---|---|
| `ai-resources/.claude/commands/work-loop.md` | Not yet built |
| `ai-resources/docs/work-loop.md` — shared contract | Executable core, to be written in Step 3 |
| `ai-resources/docs/work-loop-spec.md` — operational spec | — |
| `ai-resources/.agents/skills/work-loop/SKILL.md` — Codex side | Codex resource, to be built in Step 5 |

Two rules follow:

1. **No self-hosting.** Neither v1 nor the emerging v2 governs this build (Proposal, Section 6). Do not run the v1 `/work-loop` command to build v2.
2. **v1 retirement is decided at pilot start, no later** (Proposal, Decision 4). Until then both exist; do not retire, edit, or "align" v1 as part of this build.

---

## Decisions taken after v0.4

Recorded here because they amend an authoritative document that is not itself edited. A session
reading the Proposal alone would otherwise follow superseded wording.

- **2026-08-01 — Claude commits the state file.** Codex writes the brief into the file; Claude makes
  every commit. This **amends the Proposal's destination behaviour 1** ("Codex writes a bounded brief
  into a task-state file in the repository and commits it"). Operator decision, on the Step 2
  evidence that Codex can write repository files but is refused write access to `.git`
  (`step-2-transport-seam-conclusions.md` § 2). Recorded in the executable core, § 4.
  ✓ **Reconciled 2026-08-01 (session S4-1bc).** The mission's validation contract carried the
  pre-amendment wording, which made the mission unable to satisfy its own definition of done.
  The operator chose to amend the assertion rather than record a standing divergence: a contract
  that cannot be satisfied measures nothing, and an assertion waived at closure teaches the habit
  of waiving assertions. Acceptance assertion 1 in `logs/missions/work-loop-v2-mvp.md` now reads
  "…Claude commits it", with the date, the original wording and the basis recorded inline. That is
  the **only** amendment made to that frozen contract; the freeze otherwise stands.

---

## Known inconsistencies in the source documents

Recorded at commit time so a future session does not treat them as findings. None blocks Step 1.

- **Playbook version numbering.** The Playbook file declares itself **v0.4**. The Proposal (header and Section 8) refers to the companion Playbook as **v0.2**, and the operator's setup instruction called it **v0.3**. The file in this folder is the current one; the Proposal's internal reference is stale. Cosmetic — the Proposal remains authoritative on content.
- **"Three documents" vs. four.** The Playbook's Step 0 and the Proposal both speak of three governing documents. The skill-writing standard is the fourth, added by the operator at setup. Its authority is scoped in the table above.
- **Where the Playbook's named commands live.** The Playbook names `/research`, `/prototype`, `/to-spec`, `/to-tickets`, `/implement`, `/tdd`, `/code-review`, `/diagnosing-bugs`. These are **user-level Pocock skills**, not repo resources — they live in `~/.claude/skills/`, outside both this repo and the workspace. Verified present 2026-08-01: `code-review`, `domain-modeling`, `grill-me`, `grilling`, `implement`, `prototype`, `research`, `tdd`, `to-spec`, `to-tickets`, `wayfinder`. **`diagnosing-bugs` is the one exception — not found** (searched `~/.claude/skills/`, `~/.claude/commands/`, `ai-resources/{.claude,skills,.agents}`, workspace `.claude/`). The Playbook invokes it by name in Step 7; treat that as a description of session style ("build a tight reproduction first, then fix"), not a command to run. Nearest repo equivalent: `/resolve-incident`.

---

## Placement note

These are **plan artifacts**, not runtime process docs — that is why they live in `plans/` and not `docs/`. `docs/` already holds the v1 runtime contract (`work-loop.md`, `work-loop-spec.md`); keeping the v2 build's governing set out of that namespace prevents exactly the authority confusion this README exists to stop. When the MVP ships, the surviving runtime contract graduates to `docs/`; these four documents stay here as the build record.
