---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through the research-corrected implementation plan.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow, with unnecessary ceremony removed. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state.

## Lane and unit
Standard. Implementation mode. Unit 34 — record the corrected plan's re-freeze and implement T6's documentation-only capability convention in the Codex Work Loop skill.

Named reason for the loop: the exact corrected amendment is now content-bound approved, and T6 remains a consequential cross-cutting documentation change requiring independent assessment after implementation. The status announcement is bundled with T6 to avoid a separate administrative unit.

## Brief
The operator explicitly approved the exact corrected implementation-plan content at commit `74e91209b31b0cf32aa1b0a27cc3b5ccbe2da115`, plan blob `0fabe8601871c5f7c49ff1e8628d4922c4422ba2`, on 2026-08-15. That content is now governing. Its operator decisions remain: machine-wide Codex execpolicy placement authorized for T7; symmetric direct-route request plus observation accepted for this MVP; shell-wrapper evasion accepted as a limitation; full descendant containment deferred. T7 is not part of this unit.

This unit has one implementation outcome with an attached status announcement: make T6's approved documentation convention live in `.agents/skills/work-loop-v2/SKILL.md`, while changing only the plan's Status block and § Plan-readiness statement from Draft to re-frozen and binding them to the approved commit/blob above. The plan status edit must announce approval only; every substantive byte outside those two status regions remains identical to approved blob `0fabe860…`.

T6 required content, drawn from approved § 3.4/T6:

- State the three capability sets completely: baseline-granted; operator-reserved/not baseline; separately pre-authorizable with current membership empty.
- Map every § 11 control to its actual surface, strength and fail-capable evidence, naming Claude versus Codex wherever paths differ. Preserve exact verbs: prevented, detected, observed, requested, deferred, and neither carrier-selected nor carrier-verified.
- State that attended Claude hops have no sandbox/network containment; Codex hops request `--sandbox workspace-write` and have host-reported restricted network, but neither is a carrier-selected/verified capability profile.
- State that direct nested-actor refusal is requested plus observed on Claude today, observed-only on Codex today; do not implement or claim T7's future symmetric request.
- Document the exact baseline `--claude-deny` rules for Claude hops only. Recorded per-argument argv proves rules were requested; `denials=` reports child permission-denial evidence only.
- Show the selected capability subset inside the existing `## Brief` and the actor-specific requested/observed runtime profile inside `## Latest result

Inspected (2026-08-15):
- Claim (1): HOLDS on the repository half — the plan is blob `0fabe8601871c5f7c49ff1e8628d4922c4422ba2` live and at `HEAD`, its Status block opened `**Draft — bounded T6/T7 evidence-and-control amendment**`, and `git log -1` on the file returns `74e91209b31b0cf32aa1b0a27cc3b5ccbe2da115`. The commit and blob the brief names therefore exist and match. **The operator's approval itself is Codex's assertion carried in this brief; it has no repository surface to check against**, so it is recorded as relied on rather than inspected. Nothing found contradicts it.
- Claim (2): HOLDS — `git hash-object .agents/skills/work-loop-v2/SKILL.md` returned `b21cf35002b7f6ac90b7189258a2af0240a6e662`. Searched it for `capability envelope|Operator-reserved|pre-authorizable|Runtime profile|Capability subset` — 0 matches for every term. The only prior hit for `claude-deny` anywhere in the file is line 266, which describes the dispatcher's `--unattended` flag and is not a T6 convention.
- Claim (3): HOLDS — the carrier is blob `45f52ab4…`, unchanged, and `carry-turn.test.sh` runs **285 passed / 0 failed**. The exact baseline deny rules are derivable and passable with no runtime edit, proved live below: ten rules reached argv unchanged and the four mandatory nested-actor rules survived alongside them, so operator rules append rather than displace.
- Claim (4): HOLDS — core blob `fb0ba8b6bddbf27dac971ec1c2458c6e5be32136`; its § 4 field table still carries exactly 5 rows. The core was read and not edited.

Result: both outcomes landed. The plan re-freeze is status-only — blob `0fabe8601871c5f7c49ff1e8628d4922c4422ba2` -> **`e27dbda980962610a924a220296961d1cb902b09`**. The T6 convention is live in the Codex skill — blob `b21cf35002b7f6ac90b7189258a2af0240a6e662` -> **`e4a8d44a120c76212dd868e5b26ff7eb6cef77b3`**, a single 66-line pure addition. T7 was not begun.

### Evidence

**The plan edit is status-only, proved positionally rather than asserted.** In the approved blob the Status block spans lines 3–232 and § Plan-readiness statement spans 1763–1915. The diff changes **24 old lines, all 24 inside those two regions, 0 outside**. Stronger: the entire substantive body from `## 1. Fixed Point` to just before `## Plan-readiness statement` — **158,636 bytes**, containing § 3.4, § 3.5, T6, T7, T8's rows, the traceability table and the internal consistency check — is **byte-identical** before and after, same length both sides. No tracer contract moved. The re-freeze binds to commit `74e91209…` / blob `0fabe860…` and records the seven gates in order, including the REVISE verdict, the single frozen finding, the 13-line correction and the closure PASS, and it points at the preserved review notes.

**The skill diff is one pure addition.** 66 insertions, **0 deletions**, one hunk at line 457, inside `## Opening a unit and writing the brief` — the brief-preparation guidance § 3.4's placement decision names. Nothing existing was reworded or moved.

**T6 concepts absent before, present after.** `capability envelope` 0 -> 1, `Operator-reserved` 0 -> 2, `pre-authorizable` 0 -> 2, `Runtime profile` 0 -> 2, `Capability subset` 0 -> 1.

**Coverage, checked mechanically — 17 checks, and it fails on the pre-edit skill.** Against the pre-edit file 15 of 17 fail; against the new file all 17 pass. What they establish: all three envelope sets present with **7 / 9 / 7 members, each exactly once** inside the envelope block; the pre-authorizable set explicitly declared empty; **13 control rows, each present once with four cells**; every exact strength verb present (`Prevented`, `Detected, not prevented`, `Deferred`, `Requested`, `neither carrier-selected nor carrier-verified`, `Observed only, today`); all **10 baseline deny rules** present and scoped to the Claude path alone; `denials=` stated only as child evidence; the subset shown inside `## Brief` and the profile inside `## Latest result`; **no new state heading added** (regex over `^## `); the five-field ceiling explicitly named as untouched; the requested-never-effective rule stated; connected-development and full descendant containment named deferred; core § 8 cited without any of its prose copied; and T7's future symmetric request **not** claimed as present. *(One check was corrected mid-run: it counted envelope members across the whole file and flagged "irreversible deletion", which legitimately appears twice — once as a set member, once as the category comment on the `rm -rf` deny rule. The count is now scoped to the envelope block, which is what the check meant.)*

**The baseline deny set proved in argv, paired and non-nested.** Two real `carry-turn.sh` runs, identical except for the deny set, with the actor supplied through `--claude-bin` as a fixture binary. **No `claude` or `codex` process was launched**, and both runs happened in throwaway repositories outside this checkout.

```
A (ten baseline rules passed): baseline rules in argv = 10/10   mandatory nested-actor rules = 4/4
B (no baseline rules passed):  baseline rules in argv =  0/10   mandatory nested-actor rules = 4/4

A: RESULT ... denials=0 partial=0 actors=1 nested=0
B: RESULT ... denials=0 partial=0 actors=1 nested=0
```

The argv discriminates 10 versus 0 and can fail; `denials=` is identical across the pair, which is the third independent confirmation that it does not report the requested rules. The mandatory four survive in both legs, so operator rules append rather than displace.

**Regression: no new failure.** `work-loop-v2-slice-1.test.sh` -> **307 passed / 1 failed**, the known baseline, the single failure being the pre-existing `ridx` routing-index/live-installation drift, which remains deferred. `carry-turn.test.sh` -> **285 passed / 0 failed**. **Neither suite binds to the new convention** — `capability envelope`, `Capability subset`, `Runtime profile` and `pre-authoriz` all return 0 matches in both suites — so they are breakage evidence only, not evidence T6 landed. The coverage check above carries that.

**Excluded targets unchanged.** Core, autonomy-rules, session-plan, carrier, carrier tests, the slice-1 suite and the approved proposal all compare byte-for-byte equal to `HEAD`. `git status --porcelain` shows the skill, the plan, this state file, and the pre-existing untouched `logs/friction-log.md`.

### An incident during this unit, reported rather than buried

**I wrote the T6 section into the wrong file first.** I addressed `.agents/skills/work-loop-v2/SKILL.md` from the **workspace root** rather than from this checkout. That path is a symlink — `<workspace>/.agents/skills/work-loop-v2 -> ../../ai-resources/.agents/skills/work-loop-v2` — so the write landed in the **canonical `ai-resources` checkout, which is on `main`**, not in this worktree and not on this branch.

I caught it on the next command, confirmed the change was a pure 66-line addition with **0 deletions** so nothing of anyone else's was at risk, copied the modified file to the scratchpad as a backup, and restored it with `git checkout --` against that one path. The canonical checkout is now back at blob `e8fbbe65b577149a665d6e8a9cbb5b0668a0e34d`, matching its own `HEAD`, and `git status` there is clean apart from a pre-existing untracked `logs/harness-runs/` directory dated 2026-08-13 that predates this session and was not touched. Nothing was committed there at any point.

Two things worth Codex's attention. **The symlink defeats path-based scope discipline**: an absolute path that looks like it is inside the correct repository can resolve into a different checkout on a different branch, and no ownership check fires, because `work-loop-owner.sh` checks task ownership of a checkout rather than the destination of a write. **The habit that caught it was verifying the target before continuing, not before starting** — I checked whether the *second* path was a symlink only because the first had just failed. A pre-write resolution check on any file a unit intends to edit would have caught it at the first attempt. Both are recorded as candidate deferrals, not implemented, and neither is in this unit's scope.

Also carried forward, still not done: `logs/friction-log.md`'s uncommitted insertions, untouched; the `ridx` suite failure; and the § 3.4 Claude-hop wording note deferred at the Unit 33 correction.

## Blocker

None.

## Next action

Codex: assess Unit 34. Both outcomes landed — the plan is re-frozen status-only at blob `e27dbda980962610a924a220296961d1cb902b09` with its 158,636-byte substantive body proven byte-identical, and the T6 convention is live in the skill at blob `e4a8d44a120c76212dd868e5b26ff7eb6cef77b3` as a 66-line pure addition passing all 17 coverage checks. Three things to weigh. **First**, claim (1)'s approval half was Codex's own assertion and could not be checked against the repository. **Second**, the misdirected write to the canonical `ai-resources` checkout is reported above — it was reverted and nothing was committed there, but the symlink hazard and the missing pre-write path-resolution check are recorded as candidate deferrals for a decision. **Third**, the baseline deny set's exact five categories and ten rule strings were stated by this unit as the convention T6 fixes; if Codex wants a different set, that is a content decision on the skill text, not a defect in the evidence. Decide close, continue to T7, or correct once. **T7 was not begun, and it remains gated on its own fresh risk-aware review.**
