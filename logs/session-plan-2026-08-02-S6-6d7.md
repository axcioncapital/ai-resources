# Session Plan — 2026-08-02

## Intent
Complete Phase 0 only of Work Loop v2 Context Engineering — verify the working-tree specification matches a committed version, record the operator's approval of it as the governing Context Engineering specification bound to that commit and dated 2026-08-02, reconcile only the stale draft/status/authority wording, commit, and report the hash.

## Model
opus — match (judging which wording the approval makes false, and which changes would exceed "no other material changes", is the hard part; the edit itself is trivial)

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md` — the file being approved and edited
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` — the Work Loop v2 contract the spec sits under (read only if the authority wording cross-references it)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/decisions.md` — reference for how prior operator decisions on this spec were recorded (read-only; out of scope to edit)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/qc-independence.md` — review sizing

## Findings / Items to Address

1. **The approval-scope ambiguity this session closes.** `logs/session-notes.md` § S4-510 → Open Questions records it verbatim: *"Whether the CE spec is now approved as governing, or only as authorisation for one implementation unit."* The prior approval (S4-510 mandate line) read *"approved for this implementation unit"* — deliberately narrow. The operator's mandate this session supersedes it with an unrestricted governing approval bound to current content.
2. **The stage header is stale.** S2-384 and S3-e53 both recorded that the spec's stage header still reads *"draft specification — awaiting operator approval"*, and both sessions deliberately did NOT flip it (S4-510 § Decisions Made: *"did not edit the CE spec's stage header"* — the approval then was scoped to one unit, and the spec was an allowed input, not a file in scope). It is now in scope and must be reconciled.
3. **§4's standing statement was rewritten in S3-e53** (`148689d`) to separate directional governing authority — *operator approval or a current operator decision only* — from factual/evidentiary standing. The approval recorded this session is exactly the "operator approval" that clause names, so §4's wording must be checked for anything that presumes the approval has not yet been given.
4. **CE-4 binding discipline.** Prior approvals on this spec were bound to *identifiable content at a commit*, never to a filename. The approval recorded this session must follow the same shape — hence the mandate's step 1 verification precondition.
5. **The one-file rule (FP-4).** Corrections and status changes are applied in place. Do not create a `-v2` sibling or an approval side-file.
6. **The staging guard has blocked prior commits in this stream** (S1-92b, S2-384, S3-e53, S5-8ee all record it). `logs/friction-log.md` is dirty from a prior session and `logs/runs/2026-08-02-S5-8ee.json` is untracked — neither may be staged.

## Execution Sequence

1. **Read the specification in full.** Verify: the stage/status header, §4's standing statement, and any other draft/pending-approval wording are located and quoted before any edit. *(Read-scope floor: the whole file — a downstream claim about "no other stale wording" depends on having seen all of it.)*
2. **Verify the working tree matches a committed version.** Run `git diff --quiet HEAD -- <spec>`. If clean, the working tree equals the HEAD blob; identify the last commit that touched the file with `git log -1 --format='%H %s' -- <spec>`. Cross-check by comparing `git hash-object <spec>` against `git rev-parse HEAD:<spec>`. Verify: the two hashes are identical, and the commit is named.
3. **Halt branch.** If the hashes differ, the working tree matches no committed version — search prior commits for a matching blob; if none matches, STOP, report the discrepancy (what differs, against which commit), and record no approval.
4. **Record the approval.** Insert the operator approval into the specification, stating: approved as the governing Context Engineering specification, bound to the content at commit `<hash from step 2>`, dated 2026-08-02. Verify: the approval names a commit hash, not a filename or version string alone.
5. **Reconcile stale wording only.** Change the draft/status/authority wording that the approval makes false — the stage header first, then anything located in step 1 that asserts the spec is awaiting approval or is non-governing. Verify: each edit traces to a sentence the approval falsifies. Behaviour count (17), version (v0.1), and all behavioural content stay untouched.
6. **Inspect the diff before committing.** `git diff -- <spec>`. Verify: every hunk is either the approval record or a wording reconciliation from step 5. Any hunk that is neither is reverted.
7. **Commit by explicit pathspec** — the spec plus `logs/session-notes.md` only. Verify: `git status --short` afterwards still shows `logs/friction-log.md` modified and the S5/S6 run manifests untracked. If the staging guard blocks, surface it rather than working around it.
8. **Report the commit hash** and stop. Do not open S1; do not create `logs/work-loop/context-engineering-implementation.md`.

## Scope Alternatives
Single scope — no alternatives. The mandate names six ordered steps with a halt branch and an explicit out-of-scope list; there are no degrees of freedom to trade.

## Autonomy Posture
Full autonomy

**Stop points:**
- The working-tree specification matches no committed version (mandate's stated stop condition) — report the discrepancy, approve nothing.
- The staging guard blocks the commit — surface it to the operator rather than overriding, per the standing rule this stream has hit four times.
- A wording change needed to reflect the approval would also change the spec's substance — surface it rather than deciding unilaterally, since "no other material changes" is an explicit mandate bound.

## Risk
No structural change classes apparent — the work edits one plan-stage document and touches no hook, permission file, CLAUDE.md, command, agent, or symlink. **However, the change is consequential in a different sense the class list does not capture:** it converts a draft into a governing specification, which is the authority downstream Context Engineering implementation will be gated on. The consequence is contained by the mandate's own bounds (one file, approval + stale wording only, no S1) and by step 6's diff inspection. Independent review sized as: deterministic verification only — the hash comparison in step 2 and the diff inspection in step 6 are objective checks, and the substantive judgment (whether to approve) is the operator's, already made. Re-size if step 5 turns out to require more than sentence-level wording changes.
