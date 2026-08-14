---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the frozen `plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md`, whose governing direction is the content-bound approved autonomy/authority/capability proposal.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state; do not create parallel state or review systems.

## Lane and unit
Standard. Discovery mode. Unit 9 — T2 pre-implementation premise verification and risk-aware review payload.

Named reason for the loop: T2 inserts governing policy into the canonical executable core, a shared high-consequence authority surface whose placement and references must be settled before implementation.

## Brief
T1 is complete: commit `5fef08fff11a1009b30d925f49d68844fc4e2f03`, core blob `30c62c418d3bd29b6c4a17841c90886f7be5ffe8`, received the operator's content-bound approval on 2026-08-14 and the core is now canonical. T2 is the next frozen-plan tracer, but implementation must wait for its own premise verification and seven-dimension risk-aware Codex review.

Governing authority:

- Frozen plan: freeze commit `fe2c62fddf8124caf44836b8237e44e06041db6f`, plan blob `d1a6162b8e92c9689f261b85607dfcdb89105c6d`; T2 contract at §3.2 and §4 T2.
- Approved proposal: commit `d8a89e0f7d4444bc1d3cabb963a6f49cdfc1ce67`, blob `39c67196dcec35a1be8f4fcf8ea3ef6a50cfde0b`; governing clause in proposal §1 and sequence at §14 item 2.
- Approved T1 identity: implementation commit `5fef08fff11a1009b30d925f49d68844fc4e2f03`; operator-approval record commit `9a0fdb41fa27ae7ac813504a5145a59d465b93b7`.
- Review rule: `docs/qc-independence.md`, including premise verification and the seven risk-aware dimensions.

Required outcome: prepare a repository-grounded T2 review payload and hand back without editing the core or any other target surface.

Verify and report:

1. Confirm the current core matches approved T1 blob `30c62c418d3bd29b6c4a17841c90886f7be5ffe8`, retains the approved authority paragraph unchanged, and still lacks `pre-authorized capabilities`.
2. Extract the governing autonomy clause verbatim from the approved proposal content and prove its exact content identity. Do not paraphrase it.
3. Inspect the core's complete current heading/section topology and re-derive every live reference that depends on its section numbers. The frozen plan says to add a “new numbered section,” while the core already has `## 1. Who does what`; determine whether the instruction has a safe literal implementation without renumbering or breaking references. If not, state the false premise and compare the smallest faithful placement options without choosing silently.
4. Resolve the canonical-status contradiction exposed by T1 approval: the core header still says `Status: draft for operator approval`, and the two amendment notes say that header is deliberately unchanged. Determine whether T2 can remain truthful without changing those lines, whether a status-only reconciliation is necessary, and whether that reconciliation fits T2's frozen scope or requires an explicit plan/operator decision.
5. Propose the smallest exact T2 diff shape that keeps T1's approved authority paragraph byte-identical, carries the clause verbatim once, creates no competing copy, and avoids consumer breakage. Do not apply it.
6. Evaluate the exact proposed shape across usage cost, permissions surface, blast radius, reversibility, hidden coupling, principle alignment, and problem reality.
7. Run the existing core-resolver and slice-1 deterministic suites as the current baseline, and define fail-capable evidence for the later implementation unit.

Scope: read-only investigation plus this state-file handback. Do not edit the core, frozen plan, proposal, skill, command, autonomy rules, session plan, carrier, dispatcher, tests, or any target implementation surface. Do not create a separate review artifact or begin T2 implementation.

Completion condition: return the exact clause, section/reference topology, status-header disposition, smallest proposed diff shape, seven-dimension risk evidence, and a clear recommendation—safe to implement as bounded, revise before implementation, or operator decision required—then set `turn: codex`, commit only the state-file handback, and stop.

Stop conditions: stop if T1 identity or approval is contradictory, the clause cannot be proved verbatim, literal numbering would cause uncontrolled renumbering, the stale status cannot be reconciled inside authority, or a consequential decision remains unresolved. Challenge a false premise rather than improvising.

## Latest result

Inspected (2026-08-14):

- Claim (1) frozen plan identity: HOLDS — `git cat-file -t fe2c62fddf8124caf44836b8237e44e06041db6f` returns `commit` ("freeze: autonomy-authority-capability Unit 6 — content-bound plan freeze"); `git rev-parse fe2c62f:plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md` = `d1a6162b8e92c9689f261b85607dfcdb89105c6d`, and `git hash-object` on the current file returns the same blob. The plan is unchanged since the freeze.
- Claim (2) approved proposal identity: HOLDS — commit `d8a89e0f7d4444bc1d3cabb963a6f49cdfc1ce67` exists; `git ls-tree -r d8a89e0f` maps blob `39c67196dcec35a1be8f4fcf8ea3ef6a50cfde0b` to `plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-proposal-v0.1.md`.
- Claim (3) T1 identity: HOLDS — implementation commit `5fef08fff11a1009b30d925f49d68844fc4e2f03` and approval-record commit `9a0fdb41fa27ae7ac813504a5145a59d465b93b7` both resolve to commits with the subjects the brief states.
- Claim (4) review rule: HOLDS — searched `docs/qc-independence.md` for the premise precondition and the dimension list; line 37 carries **Premise-verification precondition**, line 35 carries all seven dimensions (usage cost, permissions surface, blast radius, reversibility, hidden coupling, principle alignment, problem reality).
- Claim (5) core matches approved T1 blob: HOLDS — `git hash-object` on `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` = `30c62c418d3bd29b6c4a17841c90886f7be5ffe8`, identical to `HEAD:` for that path, and `git status --porcelain` on it is empty. Byte-identity to the approved blob subsumes the narrower "authority paragraph unchanged" claim — no paragraph in the file can differ.
- Claim (6) core lacks `pre-authorized capabilities`: HOLDS — searched the core for the literal string `pre-authorized capabilities`; `grep -c` returns 0.

Result: the T2 premise base holds, but T2's *placement* instruction contains a false premise. T2 is not safe to implement as currently frozen. Recommendation: **revise before implementation** — two narrow items need plan/operator authority first.

**(2) The governing clause, verbatim.** Extracted from the approved blob, not the working file:

```
> **Within the approved solution envelope, resolve what evidence can resolve, exercise professional technical judgment, and use only pre-authorized capabilities. Consequence increases containment and verification; it does not by itself transfer the decision to the operator. Escalate only when continuing requires operator-owned intent, accepted risk, a material change outside the solution envelope, or expansion of the authorized capability envelope. Stop when a load-bearing premise or required verification cannot be established, or when continuing would bypass the control system.**
```

Content identity proved: it is line 15 of blob `39c67196dcec35a1be8f4fcf8ea3ef6a50cfde0b`, 588 bytes including the trailing newline, sha256 `51552195d73e42e0ef15b13904ad8d0d5cbb52d0447df5812a202727da182b80`. The same line in the current working proposal file hashes identically (`cmp` returns IDENTICAL), so either source may be used. The working file's blob is now `e2a50c5e6e82482ed81a37000ac927af4f5bc672`, differing from the approved blob in exactly one line — the `**Status:**` line recording the approval itself (`git diff` between the two blobs: 1 insertion, 1 deletion). No substantive content diverged.

**(3) Section topology, live references, and the false premise.** The core has exactly seven numbered sections: `## 1. Who does what` (L16), `## 2. When to use the loop` (L40), `## 3. The unit cycle` (L64), `## 4. The task-state file` (L251), `## 5. Words we use` (L416), `## 6. Safety rules` (L438), `## 7. When to stop and ask` (L456). References that depend on those numbers: 27 self-references inside the core; 443 tracked hits repo-wide for `core § N`; on the live surfaces, `.agents/skills/work-loop-v2/SKILL.md` cites §1×4, §2×3, §3×10, §4×16, §6×4, §7×4, and `.claude/commands/work-loop-v2.md` cites §2×3, §3×5, §4×4, §5×1, §6×8, §7×3.

No script binds mechanically to the core's numbered headings — searched `*.sh` for anchored numbered-heading patterns, and every `CORE_F` assertion in `work-loop-v2-slice-1.test.sh` (lines 268, 568, 765–767, 1267–1314) greps content strings, never a section number; the 38 `core § N` occurrences in that file are comments. **Renumbering would therefore break 443 prose citations silently, with both suites still green** — worse than a mechanical failure, not better.

FALSE PREMISE: the frozen plan's inventory row (plan line 127) records the target as `same file, § 1 (new)` and justifies it with "No §1 clause exists in the core today; the file currently has no numbered governing-autonomy section." The core does have a `## 1.` — `Who does what`. Placing the clause literally at §1 renumbers 1→2 … 7→8 and invalidates every reference above. §3.3 (plan line 257) and T5 (plan line 531) compound this: both require downstream files to gain the citation text "§1 of the canonical core" / "the canonical core's §1", which is only true if the clause is core §1.

Placement options compared, none chosen:

- **A — insert as `## 1.`, renumber 1–7 to 2–8.** Literal to plan line 127 and makes §3.3/T5's citation text true. Cost: uncontrolled renumbering, 443 broken citations, silent. Rejected on the brief's own stop condition.
- **B — append as `## 8.` after §7.** Literal to T2's actual contract, which says only "a new numbered section" (§3.2 Outputs, T2 Intended change) and never names a number. Zero renumbering, zero reference breakage. Cost: a governing rule sits after "When to stop and ask", and §3.3/T5's "§1 of the canonical core" text becomes false and must be corrected before T3–T5 run.
- **C — insert as `## 2.`, renumber 2–7 to 3–8.** Better reading position than B. Same breakage class as A, marginally smaller. Rejected for the same reason.
- **D — unnumbered section.** Violates "a new numbered section". Rejected.

B is the only option that satisfies T2's contract without renumbering. It is not free: it requires correcting two citation strings in the frozen plan, which is a plan amendment and therefore not Claude's or Codex's call.

**(4) Status-header disposition.** Core line 3 reads `**Version:** v0.1 (MVP). **Status:** draft for operator approval.` The authority paragraph (L9–12) states that the operator's content-bound approval of the identifiable commit "is what makes this file canonical" — and that approval exists (commit `9a0fdb41`, of blob `30c62c41`). The header is therefore stale. The two amendment notes (L165–167, L285–287) each say the header "still reads **draft for operator approval** and that is deliberately unchanged. Do not read this amendment as approval of the rest of the file." Their rationale was that a single clause's approval is not the file's approval — T1's whole-file content-bound approval has overtaken it.

T2 can remain truthful without touching those lines only if it adds **no** third note of that form: repeating "the header still reads draft" would restate a claim T1's approval falsified. A status-only reconciliation is genuinely necessary, but it does not fit T2's frozen scope — T2's intended change is "add the §1 clause, verbatim, as a new numbered section", and the header is neither the clause nor the T1 authority line. It needs its own bounded unit and operator authority, because the header is the record of approval state. It does not block T2 provided T2 adds no draft-status note.

**(5) Smallest exact T2 diff shape (proposed, not applied).** One file, `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`. Append after line 477 (end of §7), an addition-only hunk of five lines:

```
## 8. The governing autonomy rule
(blank)
> **Within the approved solution envelope, … would bypass the control system.**   ← the 588-byte line above, byte-identical
(blank)
```

Lines 1–477 unchanged, so the header, the T1 authority paragraph, all seven existing headings and all 27 self-references are untouched by construction. One copy of the rule; no consumer file touched; no competing statement created. Heading title avoids `## Mode`, which slice-1 assertion at line 1283 forbids.

**(6) Seven-dimension evaluation of that exact shape.**

- *Usage cost* — negligible. One append to a file already loaded on every Work Loop invocation; ~590 bytes added to a 477-line document.
- *Permissions surface* — none. No hook, setting, allowlist, script or capability changes. The clause is read-only text.
- *Blast radius* — nominally one file, but that file is the shared authority document every Work Loop unit resolves. Under shape B the radius is bounded to *addition*: no existing sentence changes, so no consumer's current reading is altered. Under shape A it would extend to 443 citations across the repo.
- *Reversibility* — high. A pure-addition hunk reverts by deleting five lines; no migration, no dependent state.
- *Hidden coupling* — one, now named: T3, T4 and T5 are ordered after T2 and cite the clause's section number. Shape B makes the plan's prescribed citation text ("§1 of the canonical core") wrong, so the coupling must be resolved before T3 starts, not after.
- *Principle alignment* — aligned. Proposal §14 item 2 and the design constraint both require one copy in the canonical core with no duplication into consumers; shape B does exactly that. The residual misalignment is with the plan's §1 *placement* wording, not with the proposal.
- *Problem reality* — observed, not inferred. The subordination line was really present and really removed at T1; the clause is really absent from the core (`grep -c` = 0); the §1 collision was found by reading the core's actual heading list, not predicted.

**(7) Baseline suites, run now.** `work-loop-v2-core-resolver.test.sh`: `4 passed, 0 failed`. `work-loop-v2-slice-1.test.sh`: `passed: 308  failed: 0`.

Fail-capable evidence defined for the later T2 implementation unit — each check must be run before the edit and shown failing, then after and shown passing:

- (a) `grep -c 'pre-authorized capabilities'` on the core: **0 now**, must be ≥1 after. Forgetting the clause fails it.
- (b) Verbatim identity: extract the added blockquote line, `shasum -a 256` it, and require `51552195d73e42e0ef15b13904ad8d0d5cbb52d0447df5812a202727da182b80`. Any paraphrase, rewrap or smart-quote substitution fails it — this is the check §3.2's failure behavior demands.
- (c) No reopening of T1: `git diff` of the T2 commit restricted to lines 1–15 must be empty, proving the header and the approved authority paragraph were not touched.
- (d) No renumbering: `grep -n '^## [0-9]'` must return exactly eight lines, numbered 1–8 in order, with headings 1–7 byte-identical to their current text. Fails immediately under shape A or C.
- (e) Single copy: `git grep -c 'pre-authorized capabilities'` must show the core at 1, the proposal at 1 (its source), and no new file — a duplicate into any consumer fails it.
- (f) Regression: both suites stay at 4/0 and 308/0. Reported as regression only — neither exercises the new clause, so neither is evidence that T2 worked.

## Blocker
T2's placement instruction rests on a false premise and cannot be implemented literally. The frozen plan (line 127) records the target as core `§ 1 (new)` on the stated ground that the core "has no numbered governing-autonomy section"; the core's §1 is `Who does what`. Literal §1 placement renumbers all seven sections and silently invalidates 443 tracked citations, including 35 in the Codex skill and 22 in the Claude command, with both test suites still green. Two dependent plan strings — §3.3 (line 257) and T5 (line 531) — require downstream files to cite "§1 of the canonical core", which is true only under the placement that causes the renumbering.

Resolving this means amending a content-frozen plan, which is outside Claude's and Codex's authority. Separately, the core's `Status: draft for operator approval` header is stale after T1's whole-file approval; that reconciliation is necessary but does not fit T2's frozen scope.

## Next action
Codex: decide the disposition of the two items above, both of which need operator authority because they amend a content-frozen plan and an approval-status header.

1. **Placement.** Confirm shape B (append as `## 8.`, addition-only, per section (5) above) as T2's diff shape, and correct the frozen plan's line 127 inventory row plus the two citation strings at §3.3 line 257 and T5 line 531 to name the chosen number — before T3 starts, since T3–T5 cite it. Or direct a different option from the four compared.
2. **Status header.** Decide whether the stale `draft for operator approval` line is reconciled in its own bounded unit before or after T2, and confirm that T2 adds no new "still a draft" amendment note.

Do not treat this evidence as authority to implement T2. Once both are settled, T2's own risk-aware review can be briefed against the exact shape in section (5) and the fail-capable checks in section (7).
