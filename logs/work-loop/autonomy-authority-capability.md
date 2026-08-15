---
task: autonomy-authority-capability
turn: operator
---

## Outcome

**Implementation is complete through T7.** The approved autonomy, authority and capability proposal was
implemented through the research-corrected implementation plan, tracer by tracer: T1, T1a, T2, T3, T3a,
T4, T5, T6 and T7 all landed, each on its own evidence and its own review row. The governing autonomy
rule is canonical in the executable core as § 8, its categorical operator-gate language is reconciled
across the core, the Codex skill, the Claude command, `docs/autonomy-rules.md` and `/session-plan`, the
MVP capability envelope and subset convention are documented, and the carrier's Codex actor path now
requests direct-route nested-actor refusal symmetrically with its Claude path.

**T8 and T9 were removed from the completion bar rather than met.** The task closes at the T7 boundary by
the operator's 2026-08-15 scope decision, recorded authoritatively in the implementation plan at § 1 Fixed
Point, *Scope decision — 2026-08-15*. The plan is approved and final for this task; the final status
announcement is commit `7dceb727`.

## Decisions that matter

**The operator's 2026-08-15 scope decision — the one that ends this task.** T8's twelve constructed
scenarios and T9's 3–5 organic Standard tasks were **removed from this task's required completion bar**.
They were **not run, not bypassed, not simulated, and not satisfied by substitute evidence**; zero of
T8's twelve rows carry a verdict and zero organic tasks were recorded under T9. This was the operator-owned
change to the Fixed Point that T8's and T9's own exit conditions named as the only route past their bars,
so it was taken on the route the plan itself specified. Both remain accurate specifications of **optional
future validation**, re-openable only as separately approved new work.

**T7's mechanism was reviewed before it was built, and its claims were held to what was observed.** T7
changed a permission surface, machine-wide configuration outside the repository, and carrier runtime
behaviour, so it took a fresh risk-aware review of its exact candidate, one bounded correction round, a
final tightly-bounded fix and a closure check before any implementation. Three earlier units falsified
premises rather than building on them — `denials=` does not evidence a requested deny rule (Unit 31), the
two actor paths were not symmetric (Unit 32), and the plan's claim that only two live draft-status regions
existed was false (Unit 40, which changed nothing and handed back).

**Deferrals carried out of this task, with their reasons — recorded, not implemented.**

- The plan's two history stacks (Status preamble, Plan-readiness) are five supersessions deep. Every entry
  is correctly labelled, but a reader must scan both to find the two live records. Consolidating them
  would rewrite passages no unit here was authorized to touch.
- `logs/harness-runs/` is untracked output from Units 37–38's failed carrier attempts; whether to commit,
  ignore or remove it was never in scope.
- `logs/friction-log.md` carries uncommitted insertions, deliberately untouched throughout.
- Pre-write physical-path resolution before editing any file, from Unit 34's symlink incident.
- The `ridx` routing-index drift in `work-loop-v2-slice-1.test.sh`.
- The § 3.4 Claude-hop wording note, deferred at the Unit 33 correction.
- The dispatcher's unpolicied Codex launch line (`dispatch.sh:2115`) — outside T7's scope, and the
  residual asymmetry T7 did not close.
- Unit 35 and Unit 36 measured the carrier's Claude branch over different extraction ranges (129 lines /
  `6f8cc966…` versus 41 lines / `b0393ce2…`); one range should be pinned so the two records cannot read
  as disagreeing.
- The external rules file's mode (`644`) is not part of its reviewed identity, which is content-sha only.

## Evidence

- **T7 landed** at commit `48cca1c01adbeb07470e480d74d427ae5de3331c`: the reviewed exact candidate applied
  unchanged to its three approved surfaces — the operator-authorized machine-wide execpolicy rules file at
  `~/.codex/rules/axcion-nested-actor.rules` (381 bytes, sha256 `b0f8b79c3ef137ac5db07bd7f8195235c086ec2542b29a40092fa4a4a5b9f303`,
  outside Git and therefore recorded by identity here), the Codex branch of `carry-turn.sh` (blob
  `982c3df54af7acbd527b2c44bc89289ba92156bc`) and `carry-turn.test.sh` (blob
  `031b60ea9f603bddd6941ebcb8b689ee897244f9`), both at mode `100755`. Carrier suite **318 passed / 0
  failed** against a 285/0 pre-change baseline; `--prove-failure` **43 passed / 0 failed** including the
  M19 mutant that strips the approval policy; the Claude branch byte-identical; both rollback procedures
  demonstrated in isolated fixtures across five cases including the dangling-symlink one.
- **The scope amendment** is commit `ff3175cd5123dd2195cc7e80b2487ba3849e57a1`, whose plan blob
  `ad97ded715e80fd1370b27e79437c4880c8416d4` is the operator-approved substantive content.
- **The final status announcement** is commit `7dceb727`, which records that approval on all four live
  plan status surfaces and changes no substantive content; § 1's scope-decision subsection is byte-identical
  outside its `Status consequence` paragraph.
- Across the amendment and the status announcement, the proposal blob `e2a50c5e6e82482ed81a37000ac927af4f5bc672`
  and the canonical core blob `fb0ba8b6bddbf27dac971ec1c2458c6e5be32136` were verified unchanged.

## Accepted limitations

- **Proposal §16's observable-success standard is not established by this project**, and neither is §14
  items 10–11's operational-evidence standard. The acceptance instrument was never run. The mechanism is
  implemented; its behaviour under that instrument is **unmeasured**. This is the substantive cost of
  closing at T7 and is stated as an unmet standard, not a discharged one.
- **T7 requests; it does not enforce.** The execpolicy rules and `approval_policy=never` are a **requested**
  policy on the Codex hop, not containment. Four things remain unverified or deferred and are claimed
  nowhere: that the rules file is loaded on any given run (automatic loading is a documented premise, not
  an observation); that the requested policy is **effective**; a matched command's **live runtime
  disposition**; and **descendant containment**, which stays deferred.
- **Wrapper and absolute-path routes are unmatched** — `bash -lc 'claude -p x'`, `env claude -p x` and an
  absolute binary path all return no match against the installed policy. This is evidenced and accepted,
  not solved.
- **The machine-wide `codex` `prompt` rule overrides the narrower `codex --version` `allow`** inside
  Codex-mediated execution. Ordinary Terminal use is unaffected, and the effect is reversible by the
  identity-guarded rollback recorded in the plan.
- **The residual asymmetry at `dispatch.sh:2115` is open.** T7 covered the attended carrier only; the
  unattended dispatcher's Codex launch line requests no equivalent policy.
