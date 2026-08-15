---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through the research-corrected implementation plan.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow, with unnecessary ceremony removed. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state.

## Lane and unit
Standard. Discovery mode. Unit 32 — resolve the carrier's real Codex-path containment and the smallest honest amendment needed before T6 resumes.

Named reason for the loop: Unit 31 falsified a plan acceptance check and an independent review found related actor-specific control claims that may invalidate T7; repository evidence must settle the technical boundary before the approved plan can be corrected safely.

## Brief
Unit 31 correctly stopped before implementation. Its non-nested paired carrier probe proved `RESULT denials=` reports the child's `permission_denials`, not which `--disallowedTools` rules were requested; recorded argv is the fail-capable evidence for the requested Claude deny set. An independent review accepted that finding but found that an argv-only T6 correction would still be incomplete because the Claude and Codex carrier paths differ and downstream T7/T8 contracts rely on the same false assumptions.

The approved proposal's outcome remains governing: proposal § 14 item 7 requires symmetric nested-actor prevention. Its factual premise that the carrier already refuses nested Claude and Codex actors symmetrically is now a verify-first claim, not governing fact. No operator intent is needed yet: first establish whether the approved outcome can be met inside the existing carrier architecture and what exact plan surfaces must change.

Required discovery outcome: return an evidence-backed technical recommendation for the smallest safe way to satisfy symmetric direct nested-actor prevention on both carrier actor paths, or prove that no available mechanism can enforce it safely. Also return the complete bounded semantic amendment inventory needed to make § 3.4, T6, T7 and T8 internally honest. Do not implement the remedy or edit any plan/skill/runtime/test target.

Scope: read-only inspection of `scripts/axcion-harness-v0.2/carry-turn.sh`, its tests and directly referenced fixtures; the current Codex launch/runtime options available locally; approved proposal § 11/§ 14 item 7; implementation-plan § 3.4, T6, T7 and T8 rows S5/S9; canonical core §§ 7–8; and this state-file handback only. Excluded: implementation, plan amendment, skill edit, carrier/test edit, external deployment, and T8/T9 execution.

Questions to resolve:

1. Precisely what prevention, requested restriction, sandboxing and observation each carrier path applies today: Claude hop versus Codex hop. Separate direct nested-actor refusal from descendant containment.
2. Whether Codex's current local CLI/runtime exposes a supported, non-self-bypassable way for the carrier to deny direct `claude` and `codex` launches while retaining the authorized shell capabilities the hop needs. Inspect local help/config/docs first; do not launch a nested model. If current official product documentation is required, identify that need rather than guessing.
3. If no built-in Codex deny surface exists, compare only the smallest repository-compatible alternatives that could enforce proposal item 7. For each, state bypass limits, blast radius, reversibility, testability, and whether it changes the approved solution envelope, capability envelope, governance model or deferred descendant-containment boundary.
4. Identify every plan statement invalidated by the evidence. At minimum assess: § 3.4's sandbox rows, baseline deny row and symmetric nested row; T6's baseline-deny paragraph, verification (e) and deferred-profile language; T7's evidence-only contract; T8 S5's `denials=` exit and S9's `denials=` proof. Check the named plan sections for additional occurrences, but do not expand beyond them.
5. Recommend the smallest coherent next sequence: which plan edits are mandatory, whether T7 becomes an implementation tracer, what review tier applies to any runtime carrier change, and what content-bound operator approval is required before implementation resumes.

Required evidence:

- Cite exact carrier/test/CLI surfaces for every actor-specific statement; distinguish observed facts from inference.
- Demonstrate the Codex-path conclusion without invoking Claude or Codex recursively and without changing repository targets.
- For any proposed prevention mechanism, give at least one fail-capable positive test and one bypass/negative test; reject a mechanism that only documents policy or observes after the fact.
- Provide a complete, concise amendment inventory and explicitly state what approved outcome and boundaries remain unchanged.

Completion condition: the five questions are resolved, the recommended repair is technically enforceable or the capability gap is precisely proven, the amendment inventory is complete enough for Codex to frame one bounded plan amendment, only this state handback is committed, `turn: codex`, and Claude stops without implementing T6/T7.

Stop conditions: stop if answering requires nested model execution, external authorization, a destructive/shared-state action, or inventing an unverified Codex capability. Surface any operator-owned change separately; do not treat the approved proposal's false factual premise as permission to weaken its symmetric-prevention outcome.

## Latest result

Discovery unit. Nothing was implemented and no plan, skill, carrier or test file was touched. `git status --porcelain` shows this state file and the pre-existing untouched `logs/friction-log.md`. Every Codex-side conclusion came from `--help`, `codex doctor`, `codex execpolicy check` and binary strings; no `claude` or `codex` model session was started at any point.

**The independent review's core finding is confirmed, and it is worse than stated.** The carrier does not refuse nested actors symmetrically. It never has. What is symmetric is the *observation*; what is asymmetric is the *request*, and on the Codex path the request does not exist at all.

### Q1 — What each carrier path actually applies today

Read from `scripts/axcion-harness-v0.2/carry-turn.sh` `launch_actor()`, lines 845–906. Direct nested-actor refusal and descendant containment are separated, as asked.

| | **Claude hop** (`:865-903`) | **Codex hop** (`:855-861`) |
|---|---|---|
| Launch line | `claude -p '/work-loop-v2 <task>' --output-format json --permission-mode <default\|acceptEdits> --disallowedTools <mandatory + operator>` | `codex exec --sandbox workspace-write -C <checkout> --json <prompt>` |
| Direct nested-actor refusal | **Requested.** `CLAUDE_DENY_MANDATORY` (`:224-229`) — `Bash(claude:*)`, `Bash(claude *)`, `Bash(codex:*)`, `Bash(codex *)` — assembled at `:879-882`, passed at `:899`. Never absent, not overridable. | **None.** No deny list, no rules path, no approval flag, no `--ignore-rules`. Nothing on this launch line asks the child to refuse anything. |
| Sandbox / filesystem containment | **None.** `--permission-mode` is a permission policy, not containment — the carrier says so itself at `:53-54` ("it makes the child ask, it does not sandbox it"). | **`--sandbox workspace-write`.** A real OS-backed sandbox (`codex doctor` → `filesystem sandbox restricted`, `network sandbox restricted`, `execve wrapper helper ~/.codex/tmp/arg0/codex-…-execve-wrapper`). |
| Descendant containment | Deferred both paths — `carry-turn.sh:306-307` refuses `--unattended`, `--contained` and `--sandbox` outright on this surface. | Deferred as a *carrier* control; the Codex child's own sandbox is not the carrier enforcing a boundary. |
| Observation | `observe_nested` (`:746`, called at `:810`/`:821`), process-group census counting both `claude`- and `codex`-named processes. | **Identical.** The census is actor-agnostic — same function, same call sites, same recognition rule (`:725-730`). |

**So the asymmetry is exact and one-directional.** A Claude hop is *asked* not to start either actor and is *watched*. A Codex hop is only *watched*. The `--sandbox workspace-write` a Codex hop does get is filesystem containment, which is a different control and does not restrict launching a process.

**The carrier already says this, in its own header.** `:110-114`: "The Codex actor path carries NO equivalent. `codex exec` (0.147.0-alpha.6.5) offers sandbox modes and config overrides, not a per-command deny list, so there is no native already-used mechanism to request the same of a Codex hop. This policy therefore covers the Claude child only, and saying otherwise would be a claim this script cannot support." The plan asserted the opposite of what the implementation documents about itself.

### Q2 — Does the Codex CLI expose a usable deny surface? Partly, and not as a deny

Local surfaces inspected (`codex-cli 0.147.0-alpha.6.5`, `/Applications/ChatGPT.app/Contents/Resources/codex`): `codex --help`, `codex exec --help`, `codex sandbox --help`, `codex execpolicy check --help`, `codex doctor`, `~/.codex/config.toml`, `~/.codex/rules/default.rules`, and binary strings.

**There is an execpolicy mechanism.** `codex exec --ignore-rules` documents it: "Do not load user or project execpolicy `.rules` files". User rules live at `~/.codex/rules/*.rules`; the live file today holds three `prefix_rule(pattern=[…], decision="allow")` entries. A hidden `codex execpolicy check --rules <path> <command…>` subcommand evaluates a policy against a command and prints JSON, with no model involved — that is what every test below used.

**It has no deny decision. Observed, not inferred.** Writing `decision="deny"` fails to parse:

```
error: invalid decision: deny
  --> deny.rules:1:1
```

Same for `forbid`, `reject`, `block`, `ask`, `never`, `deny_always`. Only two values parse: **`allow`** and **`prompt`**. An unmatched command returns `{"matchedRules": []}` with no `decision` key at all — the policy is an allowlist and approval-recorder, not a denylist. That is consistent with the binary's own model-facing amendment flow (`proposed_execpolicy_amendment` / `approved_execpolicy_amendment` / `available_decisions`): rules exist to record what a human approved, not to forbid.

**`prompt` is nevertheless usable as a refusal in a non-interactive run.** Three observations, in increasing strength. (a) `codex exec --help` exposes **no** `--ask-for-approval` flag, so an exec hop has no interactive approver. (b) The binary carries the exact error strings `approval required by policy, but AskForApproval is set to Never`, `approval required by policy rule, but AskForApproval::Granular.rules is false`, and `blocked by policy` — so an unsatisfiable approval requirement terminates the command rather than passing it. (c) `codex doctor` reports the effective policy here as `approval OnRequest`, and `approval_policy` is a `-c`-settable config key, so a carrier could pin `-c approval_policy=never` per invocation. **Not established locally:** whether an exec hop with `approval_policy=never` reports a `prompt`-matched command as blocked or as an error the model may route around. Confirming that needs a live Codex turn, which the stop conditions forbid — **this is the one documentation need this unit could not close by inspection.**

### Q3 — The one mechanism worth comparing, with both required tests

Only one repository-compatible mechanism exists, so there is nothing to rank: **a user-level execpolicy rules file carrying `prefix_rule(pattern=["claude"], decision="prompt")` and the same for `codex`**, with the Codex hop launched under an approval policy that cannot grant it.

**Positive test — fail-capable, and it passes:**

```
$ codex execpolicy check --rules p.rules claude -p x
{"matchedRules":[{"prefixRuleMatch":{"matchedPrefix":["claude"],"decision":"prompt"}}],"decision":"prompt"}
```

It can fail: with the rule removed the same command returns `{"matchedRules":[]}`, and with `decision="allow"` it returns `"decision":"allow"`. The three outcomes are distinguishable.

**Bypass test — and it does not pass:**

```
$ codex execpolicy check --rules p.rules bash -lc 'claude -p x'   → {"matchedRules":[]}
$ codex execpolicy check --rules p.rules env claude -p x          → {"matchedRules":[]}
$ codex execpolicy check --rules p.rules /usr/local/bin/claude -p x → {"matchedRules":[]}
$ codex execpolicy check --rules p.rules --resolve-host-executables /usr/local/bin/claude -p x
                                                                  → "decision":"prompt"
```

A shell wrapper, `env`, or an absolute path all evade the rule at this surface. Absolute paths are recoverable with `--resolve-host-executables`; `bash -lc` is not. The binary does carry an interpreter/wrapper token list (`bash`, `sh`, `zsh`, `env`, `sudo`, `node`, `python`, `npm`, `sudo`, …) adjacent to `core/src/exec_policy.rs`, which *suggests* the runtime unwraps wrappers before consulting policy even though the static checker does not — **inference, flagged as such**, and it folds into the same documentation need as Q2(c).

**Assessment against the seven dimensions the brief asks for.** *Bypass limits:* blocks the direct route only — identical in kind to the Claude path's `Bash(claude:*)` rules, which `carry-turn.sh:102-108` already refuses to call containment. *Blast radius:* this is the problem. A **user-level** file at `~/.codex/rules/` sits outside the workspace-write sandbox, so the Codex child cannot edit it — but it applies to **every Codex session on this machine**, not only Work Loop hops. A **project-level** file inside the checkout is scoped correctly but is writable by a `workspace-write` child, so it is self-bypassable and worthless as a control. There is no third option: the mechanism's only non-self-bypassable placement is machine-wide. *Reversibility:* full, one file. *Testability:* good — `codex execpolicy check` is a non-model checker, so both legs are cheap and repeatable. *Envelope impact:* the solution envelope, capability envelope and deferred descendant-containment boundary are all unchanged. **The governance model is not** — a machine-wide config file outside the repository is an operator-owned change, and it is the one thing here Codex cannot decide.

**Honest ceiling.** Even fully applied, this reaches *"requested restriction that blocks the direct route"* — the same strength the Claude path already has, and the same strength `carry-turn.sh` already declines to call prevention. It does not reach *prevented*. Proposal § 14 item 7's word is "prevention"; what is achievable today is symmetric **request**. Whether that satisfies item 7 is a semantic call on the approved outcome, and it belongs to the operator, not to this unit.

### Q4 — Amendment inventory: every statement the evidence invalidates

Eleven, in the named sections only. Nothing outside them was expanded into.

| # | Surface | What it says | Why it fails |
|---|---|---|---|
| 1 | § 3.4 map, nested row (plan `:914`) | "Prevented (request) + observed (verification), **symmetric**" | The request half is Claude-only. Split per actor path, or the map asserts a control the Codex hop does not receive. |
| 2 | § 3.4 map, baseline-deny row (`:915`) | evidence is "`denials=` field and the recorded argv" | Unit 31: `denials=` reports the child's `permission_denials`, not the requested rules. Argv is the sound half. Also Claude-path-only. |
| 3 | § 3.4 map, sandbox row (`:911`) | "Deferred" | True of the Claude hop; **false of the Codex hop**, which gets `--sandbox workspace-write`. |
| 4 | § 3.4 map, network/tools row (`:912`) | "Deferred" | Same: `codex doctor` reports `network sandbox restricted` for the Codex path. |
| 5 | § 3.4 enforced/requested clause (`:931-940`) | the MVP list includes "symmetric nested-actor refusal", "confirmed live by this plan's own test runs" | The runs confirmed symmetric *observation*. No run could have confirmed symmetric refusal, because the Codex launch line requests none. |
| 6 | T6 baseline-deny paragraph (`:1335-1341`) | documents the deny rules "a baseline Standard invocation must pass via `--claude-deny`" | `--claude-deny` reaches Claude hops only. A Codex-actor baseline invocation has no surface to pass them to. The documented set must state its actor scope. |
| 7 | T6 verification (e) (`:1350-1352`) | paired `denials=` proof | Falsified in Unit 31. Replace with the argv pairing the carrier's own tests already use. |
| 8 | T6 deferred-profile language (`:1353-1355`) | "per-invocation sandbox/network restriction … remain explicitly named as deferred" | Deferred on the attended Claude path; present on the Codex path. Needs the same per-path split as rows 3–4. |
| 9 | T7 whole tracer (`:1362-1372`) | item 7 "recorded as satisfied, with the evidence this plan already gathered (285/0)" | The suite proves symmetric observation and Claude-path-only request. It cannot record item 7 satisfied. T7's premise is false, not just its wording. |
| 10 | T8 S5 (`:1398`) | "`denials=` shows the restriction was in force" | Wrong field (Unit 31), and silent about which actor the leg runs. |
| 11 | T8 S9 (`:1402`) | "leg B's `denials=` shows the rule passed and the action refused" | Same, and it is the row that most depends on the distinction, since S9 is the mechanical-layer row. |

**Outside the plan, one proposal statement.** Proposal `:378` states "no nested Claude or Codex actor (carrier refuses symmetrically today…)". That parenthesis is a false factual premise and is where the error entered. Proposal `:491` § 14 item 7 — "Add symmetric nested-actor prevention and verify the carrier on a host where process observation is available" — is an outcome **to add**, and it is unmet. It is not weakened by anything above.

**What remains unchanged, stated explicitly:** the approved outcome (item 7, symmetric prevention) stands as a requirement; the approved solution envelope; the capability envelope's three sets and empty pre-authorized set; the deferred descendant-containment boundary; the MVP release boundary excluding the dispatcher; and every accepted T1–T5 result.

### Q5 — Recommended smallest coherent sequence

1. **One bounded plan amendment, before any implementation resumes** — the eleven rows above plus the proposal note, as a single correction. Mandatory; the plan currently asserts a control that does not exist, and every downstream tracer inherits it.
2. **T6 proceeds after the amendment, unchanged in shape.** Its content is fine once rows 1–8 land: the envelope's three sets, a per-actor-path control map, argv as the deny evidence, and the sandbox rows split per path. Still documentation-only, still the skill only. Unit 31's second finding folds in here — the sandbox sentence must be scoped to the attended Claude path so it does not contradict the skill's own line 266 about the dispatcher's `--unattended`.
3. **T7 becomes an implementation tracer, or item 7 stays open.** It cannot remain an evidence-recording tracer. Its review row must change with it: adding an execpolicy rules file is a permission-surface change, which is a structural change class, so it takes the **risk-aware** review row of `docs/qc-independence.md`, not "small/mechanical". If instead T7 modifies `carry-turn.sh` to pin `-c approval_policy=never` and a rules path on the Codex launch line, that is a runtime carrier change and takes the same risk-aware row.
4. **T8 S5 and S9 are re-specified with T6's corrected evidence contract**, and each names the actor its legs run. They cannot run before step 1.
5. **Two operator decisions are required before step 3 implements anything**, and neither is Codex's:
   - **Machine-wide placement.** The only non-self-bypassable home for the rules file is `~/.codex/rules/`, outside the repository, affecting every Codex session on this host. A repo-local file is writable by a `workspace-write` child and is not a control.
   - **Whether "symmetric request" satisfies item 7's word "prevention."** The achievable ceiling blocks the direct route and is evaded by `bash -lc`. Accepting that as item 7 is accepting a residual risk that was not previously delegated; recording it as a limitation instead is also the operator's call.

   Both are content-bound: they should be approved against the exact amended text, not in principle.

## Blocker

None blocking this unit — the discovery is complete and the technical boundary is settled. Two operator-owned decisions (Q5 step 5) block **implementation of T7**, not the plan amendment. They are surfaced here rather than taken, and no operator turn is set: Codex frames the amendment first, so the operator approves exact text rather than a direction.

## Next action

Codex: frame one bounded plan amendment covering Q4's eleven rows plus the proposal `:378` note, then decide T7's new shape and review tier. The technical boundary is established and needs no further discovery: execpolicy has no deny decision (only `allow` and `prompt`), the Codex launch line requests nothing today, the achievable ceiling is a symmetric *request* that blocks the direct route and is evaded by `bash -lc`, and the only non-self-bypassable placement for it is machine-wide. One documentation need is open and does not block the amendment — whether a `prompt`-matched command under `approval_policy=never` is reported to an exec hop as blocked; confirming it needs a live Codex turn. Route Q5 step 5's two decisions to the operator with exact amended text once the amendment is drafted. T6 remains unimplemented and nothing was built.
