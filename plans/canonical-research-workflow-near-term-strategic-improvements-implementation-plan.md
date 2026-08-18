# Canonical Research Workflow — Near-Term Strategic Improvements

**Status:** Approved — content-bound operator approval recorded 2026-08-18
**Date:** 2026-08-18 (rescoped; supersedes the 2026-08-17 twelve-slice proposal in place)
**Author:** Claude (Work Loop v2 task `canonical-rw-lean-plan`, Unit 1)
**Method:** Axcíon Repository Development Operating Standard (`skills/axcion-repository-development/SKILL.md` + `references/operating-standard.md`)
**Approval:** The operator gave content-bound approval on 2026-08-18. It binds the **material content
committed at `8bf9d0d96ca7796621035e3f83b50c9dfc8055ec`**, and it carries both § 6 authority
conditions: (1) for L3 only, this approval supersedes the deploy-fitness mission's earlier
research-tier prohibition, leaving every other mission thread unchanged; and (2) founder
revise/approve/reject remains operator-owned, with no judgment content pre-approved. Everything written
into this file after that commit is **administrative approval metadata only** — the approved material
content is the version at that commit.

This document replaces the previous twelve-slice, six-gate proposal. That programme was rejected by the
operator on 2026-08-18 as non-viable at an estimated 250–410 remaining hours. What remains is one small
plan serving the operator's two stated priorities — a **lightweight Research Workflow** and a
**canonical judgment layer / House View** — running as two concurrent lanes that meet once.

This is now the governing plan. The operator's content-bound approval of the commit named above closed
the pending-approval condition, so the lean outcomes may open under the sequence and gates in § 7.
Approval covers this plan's scope only; it grants no authority over anything in § 8.

---

## 1. Operating outcome

Two capabilities, and nothing else:

1. **A lightweight research entry capability** with Light, Standard and Deep behavior, so fast and
   standard research has a home instead of bypassing the workflow entirely. Recorded evidence for the
   gap: 3 of 8 candidate projects never adopted the RW, 2 of 5 deployments built lighter parallel
   pipelines, and zero fast research has ever run through the RW
   (`plans/lean-research-workflow/proposal.md` § 1.3; `audits/working/rw-lean-usage-evidence.md`).
2. **One founder-authorized judgment / House View contract** that governs consequential analysis and
   writing — evidence, interpretation and Axcíon context kept separate; independently challenged;
   approved by the founder before any downstream agent may treat a thesis as authority.

**Explicitly not part of this plan:** retrieval runtimes, external API retrieval, official-statistics
ingestion, source products or profiles, general deployment/propagation infrastructure, and Content
Programme integration. See § 8.

## 2. Completed foundation — not reopened

**Slice S1 (content-relay → path-passing refactor) is complete.** It is finished foundation, not an
open slice, is not renumbered as lean work, and counts zero remaining effort.

- Closing record: `logs/work-loop/canonical-rw-near-term-improvements.md`, closed at commit
  `16b3cd5803fc11617247e159b54eef90897def18`.
- Accepted evidence: 40/40 named W4-H1–H4 seams accounted for (27 converted, 13 justified exemptions),
  99.82% relay-payload reduction against an 80% target, deterministic checker `TARGET MET`,
  representative Part-A scorer 38/38, and a fresh context-isolated Part-B evaluator returning
  `PRESERVED` on all eight judgments and overall. Evidence commits `5035a379` and `2b9770fa`.
- Its recorded limitations and deferrals stand as written in that closing record and are not reopened
  here.

## 3. Substrate that still governs the lean work

Findings from the 2026-08-17 inspection that remain load-bearing. Everything else in the former § 2
concerned removed programmes and is dropped.

| Finding | Evidence | Why it still governs |
|---|---|---|
| The judgment-layer pilot lives in a separate workspace checkout with passing regression suites; canonical adoption was deferred pending authority and representative proof | `projects/axcion-sector-intelligence` at inspected commit `d0cb658b`; its four `logs/scripts/check-judgment-*.test.sh` suites (82 assertions at the inspected record) | L1 binds that checkout; L4 uses it as the single integration consumer |
| Canonical skills take **live effect** in deployed projects through symlinks | `logs/missions/research-workflow-deploy-fitness.md` § Pre-deployment corrections | Every canonical edit in L2/L3 enumerates live consumers before editing |
| `/sync-workflow` cannot truthfully propagate reference and runtime surfaces | `.claude/commands/sync-workflow.md:30-54`; `audits/2026-08-13-workflow-sync-reconciliation-ruling.md:76-85` | Why L4 is a deliberate manual install/reconcile rather than generic propagation |
| The deploy-fitness mission is **active** and lists **research tiers** on the operator's explicitly-not-to-be-built set | `logs/missions/research-workflow-deploy-fitness.md` frontmatter `status: active`; § In/Out of scope, line 41 | A live authority conflict with L3 — see § 6 |
| Fast/standard research has no canonical home; the RW is a five-stage deep pipeline | `plans/lean-research-workflow/proposal.md` § 1.3 and its usage evidence | The reason L3 exists |

## 4. Before / after scope map

Old labels appear in this table and in § 8 only. They are historical references, not obligations.

| Old item | Disposition | Lands in |
|---|---|---|
| S1 — content-relay refactor | **Completed** | § 2 (foundation, closed) |
| S6 — judgment local operating trial | **Retained, reduced** | **L1** |
| S7 — canonical judgment artifact + founder authority | **Combined, essentials only** | **L2** |
| S8 — canonical orchestration + independent content QC | **Combined into L2's essentials**; the separate rollout/propagation programme does not survive | **L2** |
| S5 — shared research entry capability | **Retained, reduced** | **L3** |
| S9 — deploy canonical judgment and prove a genuine unit | **Retained, reduced to one manual pilot** | **L4** |
| S0 — propagation truthfulness | **Removed — not authorized, not scheduled** | § 8 |
| S2 — Perplexity lead-not-source canonization | **Removed — not authorized, not scheduled** | § 8 |
| S3 — deploy-time source profile | **Removed — not authorized, not scheduled** | § 8 |
| S4 — retrieval runtime / execution relay | **Removed — not authorized, not scheduled** | § 8 |
| S10 — Content Programme House View adapter | **Removed — not authorized, not scheduled** | § 8 |
| S11 — official-statistics retrieval lane | **Removed — not authorized, not scheduled** | § 8 |
| The six-gate matrix (G1–G6) | **Removed.** Content-bound approval of this file plus the two authority conditions in § 6 replace it; the lean plan's actual gates are in § 7 | § 6, § 7 |
| Programme-wide outcome benchmark and its DELIVERED thresholds | **Removed.** Replaced by per-outcome proof in § 7 | § 7 |

The old standalone S7, S8 and S9 shapes do not survive as separate obligations. L2 is one combined
capability, and L4 is one manual pilot.

## 5. The four lean outcomes

### L1 — Genuine local judgment trial
- **Outcome:** one real Sector Intelligence unit runs through the **existing local** judgment
  implementation: a proposed Unit Judgment Brief from live evidence, **at least one substantive
  operator revision** before explicit approval, approved judgment visibly shaping downstream work, and
  a recorded burden (review loops, operator minutes, tokens/cost, elapsed time).
- **Boundary:** entirely inside the bound `projects/axcion-sector-intelligence` checkout. **No
  canonical file changes.** The trial proves the existing mechanism and exposes adaptation
  requirements; it does not itself approve canonical adoption.
- **Binding:** bind the exact checkout and commit at open, and run the four
  `check-judgment-*.test.sh` suites before and after.
- **Terminal rule:** **PASS opens L2. FAIL stops judgment canonicalization** and the trial memo names
  the smallest local contract that needs another trial.

### L2 — Canonical judgment layer and House View
- **Outcome:** one canonical **Unit Judgment Brief** that separates (a) evidence tied to claim IDs,
  (b) conventional and candidate interpretations with countercases, and (c) Axcíon context used only
  for relevance and framing. A fresh-context reviewer challenges it; the founder may **approve, require
  revision, or reject**; only explicit approval mechanically promotes the reviewed content, and the
  approved authority then governs analysis, synthesis, report architecture, prose and the relevant QC
  surfaces.
- **Boundary:** the artifact, its producer, its validator/promotion helper, the independent judgment
  QC, and the authority checks on existing owners. **No separate rollout programme, no duplicate
  approval system, no second House View artifact, no new stage or top-level command.**
- **Publishes:** the **stable authority contract** — the artifact shape and the trigger/consumption
  interface that L3's House View adapter binds to.

### L3 — Lightweight Research Workflow
- **Outcome:** one shared entry capability that classifies an incoming question and runs **Light**,
  **Standard** and **Deep** behavior. Evidence standards and one-way escalation are preserved: a
  load-bearing claim cannot remain on an under-controlled route, and the deep route hands off to the
  existing deployed RW.
- **Concurrency:** classification, Light/Standard behavior, evidence and escalation controls, the deep
  handoff and its tests **may be built concurrently with L1 and L2**. The Standard-route **House View
  trigger and adapter cannot be finalized** until L2 publishes its stable authority contract. L3 may
  not invent that contract, and may not build a second lightweight House View mechanism.
- **Boundary:** the entry mechanism and its three route behaviors only. No deep-pipeline redesign, no
  retrieval work, no propagation machinery.

### L4 — One manual integrated operating proof
- **Outcome:** the canonical L2 capability is **deliberately installed and reconciled by hand** into
  one bound Sector Intelligence consumer, and one genuine integrated case runs end to end: evidence →
  independently reviewed proposal → founder revision/approval or rejection → approved House View →
  downstream analysis and prose → independent content QC. The same pilot exercises **L3's handoff and
  escalation behavior with real representative uses** before adoption.
- **Boundary:** one consumer, by hand. **Do not build generic propagation first.** A project-owned
  specialization must not be overwritten; failure to preserve one stops the pilot.
- **Reconsideration trigger:** a **second concrete consumer** is what reopens the question of generic
  deploy/sync machinery. Nothing before that.

## 6. Two-lane execution model

Two isolated lanes, branched from the same approved lean-plan commit.

| | **Judgment lane** | **Lightweight-RW lane** |
|---|---|---|
| Checkout | this worktree / branch (`session/2026-08-17-research-workflow-fixes`) | a **new** worktree and branch, created **only** from the approved lean-plan commit |
| Owns | L1 evidence intake, L2 canonical judgment / House View | L3 |
| Allowed surfaces | the judgment artifact, its producer/validator, judgment QC, and the authority checks on existing analysis/synthesis/report owners; the bound Sector Intelligence checkout for L1 | the entry capability and its route behaviors, its own tests, and its handoff to the deployed RW |
| Forbidden surfaces | the lightweight entry capability and its route behaviors | the judgment artifact, its authority contract, and any House View mechanism it did not receive from L2 |

Surfaces are named by outcome rather than by guessed file paths; each lane resolves exact files at its
own unit open.

**State isolation.** Each lane runs **its own Work Loop task with its own state file and its own
`.owner` declaration**. A state file is never copied between checkouts. No branch or path named for the
lightweight lane exists today (checked against the registered worktrees and every local and remote
branch on 2026-08-18), so its name is free — but this unit creates nothing.

**No third lane.** There is no Daniel lane in this plan.

**Two authority conditions the approval record must carry**, because both are live conflicts rather
than plan-internal choices:

1. **Research tiers.** The active deploy-fitness mission lists research tiers as explicitly not to be
   built. L3 cannot open until the approval record states the successor or supersession that reopens
   that entry. The mission's other threads stay owned by the mission.
2. **Founder judgment stays operator-owned.** L1's revision and L2's approve/revise/reject are the
   operator's own acts. Neither lane may auto-approve, and no plan approval pre-approves any judgment
   content.

## 7. Sequence, gates and stop conditions

```
L1 (judgment trial) ──PASS──> L2 (canonical judgment + House View) ──┐
                                          │ stable authority contract │
L3 core (lightweight RW) ─────────────────┴──> L3 House View adapter ─┴──> L4 (manual integrated pilot)
```

- **L1 and L3's core run concurrently.** Neither waits for the other.
- **L1 PASS precedes L2.** An L1 FAIL stops judgment canonicalization; L3 may continue on its own.
- **L2's stable authority contract precedes L3's final House View adapter.** L3 finishes everything
  else first and stops at that seam rather than inventing the interface.
- **Accepted L2 and accepted L3 precede L4.** L4 is a separate integration unit after both lanes are
  accepted, not a tail of either.

**Proof, per outcome** — one deterministic floor that can fail, plus one proportionate representative
proof. Nothing broader.

| Outcome | Deterministic floor | Representative proof |
|---|---|---|
| L1 | the four `check-judgment-*.test.sh` suites green before and after; a fixture proving a rejected decision cannot be promoted or used downstream | the trial itself: one real unit, one substantive operator revision, an independent semantic review, and a burden record |
| L2 | structural fixtures reject absent, malformed, proposed-as-authority, rejected, approval-without-approver, context-used-as-evidence and analytically altered promotion states, and accept one minimal valid approved brief; command-path fixtures exercise produce → challenge → revise → approve | one brief independently scored for evidence permission, countercase, House View selection, confidence and invalidation conditions |
| L3 | real invocation-path tests prove the entry surface loads in a non-RW project, classifies correctly, dispatches actual behavior rather than printing a label, and cannot leave a load-bearing claim on an under-controlled route | one genuine Standard assignment and one operator-run Light question, plus one deep handoff |
| L4 | pre/post install inventory; all canonical and project regression suites green; every instantiated project reference deliberately reconciled | one genuine integrated case scored by independent content QC, with a burden comparison against L1 |

**Stop conditions.** Any of these stops the affected lane and hands back; none of them expands scope:

1. The L1 trial fails its semantic or burden bar.
2. L2's authority contract cannot be settled, or L3 would have to invent it.
3. A material evidence-standard regression — Light/Standard output failing to carry the same
   evidence-versus-inference discipline and per-claim sourcing as the deep route.
4. A canonical edit would take live effect in a deployed project whose state cannot be verified first.
5. Scope pressure to restore a removed programme (§ 8) mid-unit — record the deferral, do not
   implement.

## 8. Explicit non-commitments

The following are **not authorized and not scheduled**. They are not deferred obligations of this plan
and carry no owner, trigger or sequence position here:

- Former **S0** (reference/runtime propagation truthfulness) and **generic propagation machinery**.
- Former **S2** (Perplexity lead-not-source canonization).
- Former **S3** (deploy-time source profiles) and **source products** generally.
- Former **S4** (retrieval runtime, execution relay, verified-access log) and **API retrieval**.
- Former **S10** (**Content Programme integration** / Editorial V2 House View adapter).
- Former **S11** (**official-statistics ingestion**).
- **Broad rollout** to any consumer beyond L4's single bound pilot.
- Deep-pipeline slimming, deployment/lifecycle leaning, research-mode calibration, the multi-agent
  experiment, and paid source subscriptions.

Any of these may return **only through a fresh business case and a new operator decision**. Accepting
this plan does not queue them.

## 9. Effort and terminal condition

**Estimates, not promises.** Both figures are labelled estimates for pilot-quality delivery of L1–L4:

- **50–80 hours** — the strict pilot-quality target.
- **70–120 hours** — the safer range if the L1 trial needs a second pass or L2's authority contract
  takes more than one revision.

Neither figure includes the removed programmes, and neither is a commitment the plan can be held to
without a re-estimate at the point it is missed.

**Terminal condition.** This plan ends when **L4 is accepted**. At that point the two priorities are
delivered at pilot quality with their limitations written down. The plan does not silently reopen a
removed programme, and it does not roll forward into a broader rollout: any further work is a new
plan with its own operator decision.

**First action after approval.** With this shared baseline committed and content-approved, the next
routed action is creating the lightweight-RW worktree from the approved commit so both lanes start
from identical authority. That creation is not part of this planning unit.
