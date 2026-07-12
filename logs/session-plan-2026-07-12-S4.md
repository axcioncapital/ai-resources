# Session Plan — 2026-07-12 (S4)

## Intent
Advance the W3.2 repo-redesign mission — close the M-A Phase 0 remainder (M-A2a: declare model tiers at the command-side / inline-spawn sites; M-A4: reconcile `docs/agent-tier-table.md` + `skills/CATALOG.md` against the 42-agent ground truth), then re-assess the R3 Pass 2 gate against the three closed run-manifests and implement Pass 2 only if the gate genuinely holds.

## Model
opus — match (active: Opus 4.8). The hard part is *deciding*: the M-A2a design question and the R3 Pass 2 gate call are both judgment under ambiguity, not execution of a defined process.

## Source Material
- `projects/axcion-ai-system-redesign/output/implementation-prep/packets/M-A-phase0-defects.md` (§ 4 change spec, § 6 verification levels)
- `projects/axcion-ai-system-redesign/output/implementation-prep/remediation-register.md`
- `ai-resources/logs/missions/w32-migration-execution.md` (validation contract)
- `ai-resources/docs/agent-tier-table.md`, `ai-resources/skills/CATALOG.md` (M-A4 targets)
- `ai-resources/.claude/commands/{drift-check,contract-check,resolve-repo-problem,create-skill,improve-skill,migrate-skill}.md` (M-A2a live sites)
- `ai-resources/logs/runs/2026-07-12-S{1,2,3}.json` (R3 Pass 2 gate evidence)
- `ai-resources/logs/scratchpads/2026-07-12-S1-r3-pass1-scratchpad.md` (Pass 2 scope + the invariant)
- `ai-resources/docs/audit-discipline.md` (structural change classes)

## Findings / Items to Address

**Recon completed this session — three packet claims are stale, and one is misclassified.**

1. **M-A2a — agent-side half already done.** All 42 files under `.claude/agents/` declare a `model:` tier (0 missing). Confirms the packet's own re-scope (packet L30). No action.
2. **M-A2a — six LIVE inline spawn sites, none declaring a tier.** Each says "spawn a/one general-purpose subagent" with no model: `drift-check.md:45`, `contract-check.md:114`, `resolve-repo-problem.md:41`, `create-skill.md:35`, `improve-skill.md:49`, `migrate-skill.md:52`. These are agent-less dispatches, so no agent frontmatter exists to carry the tier — they silently inherit the session model.
3. **M-A2a — three roadmap-named sites are STALE.** `/plan-draft` does not exist in `ai-resources/.claude/commands/`. `wrap-session.md` contains **no inline spawn at all** (it dispatches *named* agents, which carry their own frontmatter — so there is no gap). WF10 is not an ai-resources command. Each needs an explicit disposition in the packet, not a silent skip.
4. **M-A2a is NOT "mechanical" as the packet tags it (packet L120).** A real design question sits underneath: workspace `CLAUDE.md` § Model Tier says per-command/agent/skill YAML frontmatter is *the only permitted way* to declare a tier outside the live session — but an inline spawn has **no frontmatter**. So "declare the tier" means either (a) pass a `model` param at the spawn call, which is arguably outside the rule's letter, or (b) promote these six to named agent files, which carries frontmatter but is a much larger change. This is a judgment call. S2's own method lesson applies verbatim: *"a `[det]` mechanical tag is a hypothesis, not a warrant."*
5. **M-A4 — both targets exist and are reconcilable.** `docs/agent-tier-table.md` (last edited 2026-07-05) and `skills/CATALOG.md` (last edited 2026-04-06 — likely stale by a quarter). Ground truth: 42 agent files; frontmatter is authoritative. Note the roadmap phrasing is ambiguous — `CATALOG.md` is a **skills** catalog, not an agents catalog (packet L35).
6. **R3 Pass 2 gate — evidence is at the FLOOR, not comfortably clear.** Three closed manifests exist (`stop_reason`/`outcome` non-null on S1, S2, S3). But S1 was self-verified by the session that wrote the code (weakest possible evidence, by its own scratchpad's admission), leaving **two** ordinary wraps — the bottom of the "2–3 ordinary wraps" bar. Counter-evidence: S3's wrap was *messy* (its commit was blocked, then failed to land, and its batch sat orphaned in the index until this session committed it). A wrap path that is still throwing operational faults is thin ground on which to retire the note sections that are the *only* other copy of that data.
7. **The Pass 2 invariant (from the S1 scratchpad, must not be broken):** an ABSENT manifest must NEVER block a wrap. Only an EXISTING-but-malformed manifest may abort. Absent-at-wrap is a normal path.

## Execution Sequence

1. **M-A4 first (lowest risk, unblocks a clean verification).**
   Reconcile `docs/agent-tier-table.md` against the 42 live agent files — add missing rows, drop dead ones, correct tiers to match frontmatter (frontmatter is ground truth). Then reconcile `skills/CATALOG.md` against the live `skills/` inventory.
   *Verify (mechanical, per packet § 6):* tier-table row count == 42; every row's tier matches that agent's frontmatter. Assert by script, not by eye.

2. **M-A2a — resolve the design question BEFORE editing.**
   Decide between (a) `model` param at the six inline spawn sites and (b) promoting them to named agents. Recommendation going in: **(a)**, scoped as an explicit tier declaration on the spawn instruction — it is the minimal change that closes the real gap (silent session-model inheritance on six judgment-heavy dispatches), and the workspace rule's target is *settings.json defaults that contest `/model`*, not per-dispatch tiers. Option (b) is a much larger change with a weak second-consumer case. If the reasoning does not survive scrutiny, **stop and surface** rather than edit six canonical commands on a shaky premise.
   *Verify (mechanical):* every named site declares a bare tier (`opus`/`sonnet`); **no `[1m]` suffix anywhere** in the changed set (auto-memory: the suffix breaks subagent spawns).

3. **M-A2a stale-claim disposition.**
   Record `/plan-draft`, `wrap-session` Step 6.4, and WF10 as explicitly stale in the packet with the evidence. A silent skip is how a stale claim survives to the next audit as a "you missed this."

4. **R3 Pass 2 gate call — record the verdict and its evidence.**
   Apply the gate as written (2–3 *ordinary* closed manifests). Recommendation going in: **HOLD**. Two ordinary wraps is the floor, and S3's wrap threw real operational faults — that is not a proven-stable close path. Banking one or two clean wraps costs a day; shipping the cut against a flaky close path risks a session losing its file/decision record from **both** surfaces, which is the exact data-loss the two-pass split exists to prevent.
   *If the gate is judged OPEN:* Pass 2 is a structural change (touches `/wrap-session`, a Critical component, in **both** paired copies, plus `session-feedback-collector`) → `/risk-check` is **blocking** per the session mandate's `Stop if`.

5. **Close out.** Update `remediation-register` rows (status + verification), tick the mission thread, `/qc-pass` the changed set, commit by pathspec.

## Scope Alternatives

- **Min:** M-A4 only (tier-table + CATALOG reconciliation). Purely mechanical, zero design risk.
- **Recommended:** M-A4 + M-A2a (six sites, design question resolved and stated) + stale-claim disposition + an explicit **HOLD** verdict on R3 Pass 2 with its evidence recorded. Closes the M-A batch; leaves Pass 2 correctly gated.
- **Max:** the above **plus** R3 Pass 2 implementation. Only reachable if the gate genuinely holds on inspection AND `/risk-check` returns GO. On current evidence I do not expect to reach this, and I will not manufacture a GO to get there.

## Autonomy Posture
Gated.

**Stop points:**
- Before editing the six M-A2a commands, if the design question (finding 4) does not resolve cleanly — surface rather than edit canonical commands on a shaky premise.
- Before any R3 Pass 2 implementation — `/risk-check` is blocking; RECONSIDER or NO-GO halts execution (redesign, never override, per `DR-8` and the mandate's `Stop if`).
- **Concurrent session S3 is LIVE in this checkout.** No commits touching `logs/session-notes.md` until it is done; pathspec-scoped commits only (`git commit -- <paths>`), never a bare `git commit`.

## Risk

**Run `/risk-check` before any R3 Pass 2 implementation (plan-time gate).** Pass 2 touches `/wrap-session` — a Critical component — in both paired copies, plus `session-feedback-collector`. That is a structural change class (automation with shared-state effects) per `docs/audit-discipline.md`. The "existing-command refactor" framing does **not** exempt it: Pass 2 *reorders what data lands where* across shared session state, which is the tripwire exactly.

**M-A2a** edits six canonical commands but changes only a declared tier value on an already-wired dispatch — a value edit to existing components, not a new-component or rewiring class. No `/risk-check` required on its own; `/qc-pass` covers it. **However**, finding 4 means it carries a doctrine-interpretation decision, so it gets an explicit stated rationale rather than a silent edit.

**M-A4** is a pure doc-to-ground-truth reconciliation. No structural class.

**Environment-fit:** not applicable — no executable or launcher is produced this session.

**Live-concurrency risk (highest operational risk this session):** S3 is active in the same checkout and has not committed its session note. `logs/session-notes.md` is the one contended file. My file set (`docs/`, `skills/`, six commands) has **zero overlap** with S3's declared footprint.
