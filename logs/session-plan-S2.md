# Session Plan — 2026-06-01

## Intent
Replace the contradicting "After committing, push automatically" line with the canonical gated/batched push wording across all 11 project CLAUDE.md files that carry it.

## Model
sonnet (mechanical uniform edit) — currently on opus-4-8[1m] → /model sonnet optional; staying on opus is harmless since the session also runs a /risk-check reasoning pass.

## Source Material
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md (canonical Push behavior + Commit behavior — the correct wording to mirror)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md (canonical Commit Rules block — gated/batched push wording)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md (structural change classes — cross-cutting CLAUDE.md edits)
- The 11 target files (all under /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/):
  - ai-development-lab/CLAUDE.md
  - axcion-brand-book/CLAUDE.md
  - buy-side-service-plan/CLAUDE.md
  - corporate-identity/CLAUDE.md
  - interpersonal-communication/CLAUDE.md
  - nordic-pe-macro-landscape-H1-2026/CLAUDE.md
  - nordic-pe-screening-project/CLAUDE.md
  - obsidian-pe-kb/CLAUDE.md
  - personal/travel-os/CLAUDE.md
  - project-planning/CLAUDE.md
  - strategic-os/CLAUDE.md

## Findings / Items to Address
1. All 11 files carry exactly one identical line (verified by grep -c = 1 each):
   `After committing, push automatically. Remind the operator to run \`/wrap-session\` if the work is complete. Never commit files that may contain secrets (\`.env\`, credentials, tokens).`
   This sits inside an identical `## Commit Rules` mirror block, between the "Commit directly" paragraph and the "This rule mirrors the canonical `Commit behavior` section" paragraph.
2. The contradiction: "push automatically" directly contradicts the canonical Push behavior rule (workspace CLAUDE.md), which was inverted on 2026-05-29 to gated/batched — no mid-session pushes, single operator confirmation at /wrap-session. Source: Monday-prep 2026-W23 flag (session-notes.md, HIGH confirmed).
3. Three project files do NOT need the edit and are out of scope: axcion-ai-system-owner (already says "do not push"), global-macro-analysis and repo-documentation (no matching Commit Rules line).
4. Replacement wording (mirrors canonical): replace the "After committing, push automatically." sentence with — "After committing, do NOT push. Pushes are batched until session end and gated by a single operator confirmation at `/wrap-session` (or an explicit signal like \"we're done\" / \"ship it\")." — keeping the rest of the line (the `/wrap-session` reminder + secrets warning) intact.

## Execution Sequence
1. Run `/risk-check` on the proposed change (cross-cutting CLAUDE.md edit, 11 files). Verify: GO verdict before any edit. On RECONSIDER/NO-GO → stop, surface, do not edit.
2. Apply the uniform replacement in each of the 11 files via Edit (old_string = the full contradicting line; new_string = corrected line). Verify per file: Edit succeeds (tool errors if old_string absent/non-unique).
3. Verify zero residue: `grep -rl "push automatically" projects --include=CLAUDE.md` returns nothing. Verify the 11 files now contain the gated wording.
4. Run `/qc-pass` on the change set (wording fidelity vs canonical; no collateral edits; all 11 covered).
5. Commit directly with `batch:` message. Verify: commit lands (no post-commit git checks per workspace rule).

## Scope Alternatives
Single scope — no alternatives. The fix is a fixed-content uniform replace dictated by the already-decided canonical rule; no degrees of freedom on wording or file set.

## Autonomy Posture
Gated — one structural class touched (cross-cutting CLAUDE.md edits) but scope is bounded and content is pre-decided.

**Stop points:**
- `/risk-check` verdict before any file edit (RECONSIDER/NO-GO halts execution).

## Risk
Run `/risk-check` after the plan is approved (plan-time gate) — cross-cutting CLAUDE.md edit across 11 files. End-time gate before commit may be skipped per the documented end-time skip rule only if plan-time covered the exact change set with mitigations and drift is bounded.
