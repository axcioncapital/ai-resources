---
task: work-loop-v2-dispatcher-supervised-semi-agentic-use
status: active
turn: codex
---

## Objective and scope

Implement the approved revised plan at `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` through its complete revised Gate SA acceptance contract and independent adoption review, so the dispatcher may truthfully carry the label **Ready for supervised semi-agentic use — durable terminal results are guaranteed after run admission.**

Scope: the existing Work Loop v2 supervised dispatcher, its accepted helpers and runtime surfaces, focused proof, the required live trials, and the synchronous regression gate named by the plan. Excluded throughout: durable results for invalid pre-admission invocations; the unqualified **Reliable supervised semi-autonomous dispatcher** label; Gate ST; Gate U; unattended or walk-away release claims; a dispatcher rewrite or language migration; merge, push, deployment, destructive cleanup; and every other exclusion in plan §§ 4 and 7.

Task exit condition: one integrated candidate has passed the revised Gate SA and the independent review has returned `ADOPT`, or Patrik has explicitly chosen `SHRINK` or `STOP`.

## Lane and unit

Standard. Discovery mode. Unit 23 — adjudicate remaining hostile protocol inputs

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 22 is accepted through implementation `4730569b5703833ddc042496edec7b66b59c32b2` and correction `44496eca7dc0954b029882799f6e43fbf45c5a76`. Git path ingestion is now raw and NUL-delimited; allowlist and rename decisions are preserved; operator-facing control bytes are rendered inert; and internal snapshots carry a bounded raw-path digest so two same-display filenames cannot cancel each other through a content swap. The 16-hex digest is accepted as proportionate collision resistance for this supervised local threat model; a reversible filename encoder would add machinery without practical Gate SA value.

The path-canonicalization clause is therefore met. The next hostile-input requirement is rejection of traversal, control/newline injection, unsafe symlinks, leading-option attacks, outside-root values, duplicate singleton fields, unknown versions, malformed encodings, oversized values and fake control lines. Prior units already settled many path and framing cases; this discovery isolates what remains in the trusted terminal-result/protocol boundary rather than reopening accepted path work.

Dominant deliverable: an adjudication of the remaining non-path hostile protocol and terminal-result inputs.
Evidence required in this hop: one compact map of duplicate fields, versions/tokens, encoding, size bounds and fake control-line handling across the one terminal-result producer/consumer boundary, with exact proof and verdict; then one earliest genuine target only if a gap exists.
Evidence explicitly deferred: implementation or test changes; accepted path, argv and actor-handback work; the default-evidence-location end-to-end coverage gap; Unit 22's unrelated untracked-mode asymmetry; the experimental `--unattended` stream-json denial proof; `too-many-lines` defence-in-depth proof unless it is the exact active size boundary; Change set B execution budgets; full dispatcher regression; Change sets B–D; live trials; final regression; adoption review; historical cleanup; merge, push, deployment and destructive cleanup.

Required outcome:

- Inspect the single terminal-result producer and its structural, path, identity and meaning consumers. Map duplicate singleton fields, schema/version/outcome/reason/control tokens, malformed bytes or encodings, per-field and whole-record size, and fake `RESULT`/control lines.
- Determine whether each input can enter trusted routing, terminal classification, lease release, operator handoff or status output. Raw actor output and experimental unattended stream parsing stay out unless bytes from them cross this trusted result boundary.
- Credit accepted proof rather than rerunning it. Distinguish behavior coverage from missing regression proof, and conservative refusal from a value that can advance or misreport a run.
- Classify each category `COVERED`, `BEHAVIOR GAP`, `PROOF GAP`, `NOT APPLICABLE`, or `UNKNOWN`. For every non-covered verdict, name the exact parser/consumer position, wrong decision, and one smallest discriminator without executing it.
- Identify one earliest necessary implementation target or state that this hostile-input requirement is behaviorally met and name the next unmet Change set A requirement. Do not propose a second parser, generalized validation framework or richer Gate ST schema.

Check against the repository:

1. Verify Unit 22's two commits and bounded file scope without rerunning tests.
2. Verify the approved plan's hostile-input bullet and preserve the supervised release exclusions.
3. Inspect `finalize_terminal_result`, the one structural reader and every production consumer of its verdict/value fields, plus focused tests for duplicates, unknown versions, malformed/binary bytes, size limits and fake control lines.
4. Treat raw captures and logs as untrusted display/audit material unless current executable code promotes a value from them into trusted terminal routing.

Required fail-capable evidence:

- Return one compact table: hostile category, producer/trust, validation/bound, trusted consumer, smallest discriminator, exact permanent proof, verdict.
- State whether duplicate singleton fields can be accepted, whether an unknown schema/version/outcome/control token can route, whether invalid UTF-8 or embedded NUL/control bytes can be trusted, and what exact whole-record/per-field size limits exist.
- For any absent bound, say whether the consequence is only resource consumption or can alter trusted meaning; do not label all missing limits equally.
- For fake control lines, distinguish raw actor/log text from a terminal artifact that the consumer actually opens and validates.
- Confirm no production, test, plan or documentation file changed and no test suite ran; only this state file may be committed. Leave `logs/friction-log.md` unstaged.

Capability subset: baseline only — read the approved plan, accepted Unit 22 evidence, current terminal-result producer/consumers and focused committed tests; inspect necessary accepted history; and commit only this task state. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No test execution, source mutation, model launch, authentication attempt, network, external service or operator-reserved capability is permitted.

Completion condition: one committed discovery handback establishes which remaining hostile protocol inputs are rejected before trusted use, identifies one justified next target or next plan clause without implementing anything, changes only this state file, and returns with `turn: codex`.

Stop and hand back if adjudication requires designing a new result schema, if more than one independent behavior gap prevents a bounded next target, or if the trusted consumer boundary is not singular as the approved plan requires.

## Latest result

Inspected (2026-08-19):

- Claim (1): HOLDS — `git show --stat --name-only` on `4730569b` and `44496eca`; both exist, both bounded to the same three files (this state file, `dispatch.sh`, `dispatch.test.sh`). Tests not rerun.
- Claim (2): HOLDS — the hostile-input bullet is `plan:213`; the adjacent framing bullets are `:209`–`:214` and the change-set acceptance list `:218`–`:223`. Supervised release exclusions (plan §§ 4 and 7) unchanged and preserved.
- Claim (3): HOLDS — inspected the one producer `finalize_terminal_result()` (all 41 field writes), the one structural reader `validate_terminal_result()` (`dispatch.sh:1082`–`1209`), the identity reader (`:1288`) and semantics reader (`:1324`–`:1367`), their single composed consumer `consume_terminal_result()` (`:2274`–`:2287`), and the committed cases per refusal token.
- Claim (4): HOLDS — no production consumer opens a run log or hop capture and promotes a value from it into trusted routing. `--status` reads the owner declaration, lease-holder metadata and run-log *names*; it never opens a `.result`. Searched `dispatch.sh` for `.result` outside the producer/consumer pair: the only occurrences are the promised-path derivations at `:777`, `:1062`, `:2275` and one operator message at `:2178`.

### The trusted boundary is singular, and that is what makes this adjudicable

One producer writes the record; one gate clears its path; one structural reader parses it; identity and semantics readers compare it; one function composes all four. The brief's stop condition on a non-singular consumer boundary did not fire.

### Adjudication

| Hostile category | Producer / trust | Validation and bound | Trusted consumer | Smallest discriminator | Permanent proof | Verdict |
|---|---|---|---|---|---|---|
| Duplicate singleton field | artifact at the promised path, untrusted | `seen` accumulator; second occurrence of any key → `duplicate-field` (`:1171`) | parse aborts before any TR_* is published | a record repeating `outcome=` | 2 committed cases | **COVERED** |
| Unknown / misdeclared version | untrusted | line 1 **must** be `terminal_result_version`, else `bad-version-line`; value must be exactly `1`, else `unknown-version` (`:1160`–`:1163`) | parse aborts | version declared on line 2 with a matching string buried below | 1 case each token | **COVERED** |
| Unknown schema | untrusted | exact string compare against `TERMINAL_RESULT_SCHEMA` (`:1164`) | parse aborts | any other schema value | 1 case | **COVERED** |
| Unknown / extra field | untrusted | key must appear in the 41-item `TERMINAL_RESULT_REQUIRED` (`:1170`) | parse aborts | one appended `x_note=` line | 1 case | **COVERED** |
| Outcome / reason-code token | untrusted | **not parsed for meaning at all** — `TR_OUTCOME`/`TR_CODE` are only compared against the outcome and code the dispatcher itself supplies (`:1362`–`:1363`) | comparison only | a record claiming a different outcome | `outcome-mismatch` / `code-mismatch`, separate tokens with mutation controls | **COVERED** |
| Malformed encoding, embedded control bytes | untrusted | key charset `[a-z0-9_]` (`:1152`); tab and CR in a value → `malformed-line` (`:1156`); newline cannot occur (line-delimited read) | none — only 8 TR_* globals are published, every one compared against a dispatcher-supplied expectation, and **none is ever printed** | invalid UTF-8 in a non-compared field | none needed; there is no consumer to mislead | **NOT APPLICABLE** |
| Fake control line **inside the record** | dispatcher, trusted | every one of the 41 fields is written through `tr_kv`/`tr_kv_or` → `tr_val`, which maps `\n`, `\r`, `\t` to spaces and truncates at 512. **No direct `printf` writes into the record** — all 41 writes read and confirmed | n/a | a lease-holder or path value carrying a newline, which `tr_val` flattens before it can forge a `key=value` line | the encoder is unconditional | **COVERED** |
| Fake control line in raw actor output / run log | actor, untrusted | kept out of the record entirely | none | n/a | claim (4) | **NOT APPLICABLE** |
| Whole-record size | untrusted | `wc -c` **before a single line is read**; > 65536 → `too-large` (`:1124`–`:1127`) | parse aborts at one stat | a planted 100 KB artifact | 1 case | **COVERED** |
| Per-value size | untrusted | > 512 → `value-too-long` (`:1153`); the producer independently truncates at 512 | parse aborts | one 600-character value | 1 case | **COVERED** |
| Line count | untrusted | > 200 → `too-many-lines` (`:1148`) | — | **none exists** | **0 cases** | **NOT APPLICABLE — unreachable** |
| Artifact rewritten or swapped mid-parse | untrusted | content digest **and** device/inode identity taken before and after the read, both required to match (`:1139`–`:1142`, `:1193`–`:1198`) | parse aborts | replacing the file between its first and last line | 5 cases each | **COVERED** |

### The one non-obvious result: `too-many-lines` is dead, not unproven

It has zero committed cases, and no honest case can be written for it. Reaching line 201 requires 200 lines that all passed `unknown-field` and `duplicate-field` first — but `TERMINAL_RESULT_REQUIRED` holds **41** distinct keys and a repeat is refused, so the parse cannot survive past roughly line 42. The bound sits behind two strictly tighter gates and can never fire.

The brief deferred this proof "unless it is the exact active size boundary". It is not: the active whole-record boundary is `too-large`, which is reachable precisely because it is a `stat` taken **before** parsing, on arbitrary planted bytes. So the deferral stands, and on its own terms. The honest disposition is deletion rather than a test — a case asserting `too-many-lines` would have to construct a record the parser rejects for a different reason, and would then be proving the wrong refusal.

### Whether each input can enter a trusted decision — stated directly

- **Duplicate fields:** no. Refused before any value is published.
- **Unknown schema / version / outcome / control token:** no, and by a stronger mechanism than a grammar — the closed required-key set plus exact-match version and schema. The outcome and code are never *read for meaning*; they are only checked to agree with what this run already decided, so a record cannot select a terminal class.
- **Invalid UTF-8, embedded NUL or control bytes:** cannot be trusted, because nothing consumes them. The 8 published globals are all compared to expectations; a hostile byte can only cause a mismatch, which is a refusal. Nothing prints a record value, so there is no display path either.
- **Exact size limits:** whole record 65536 bytes (pre-parse, active); per value 512 bytes (active, and mirrored at the producer); 200 lines (unreachable).

### Missing bounds, distinguished rather than lumped

Only one bound is absent in effect — the line ceiling — and its consequence is **neither resource consumption nor altered meaning**: it is unreachable, so it consumes nothing and decides nothing. There is no category here where a missing limit could alter trusted meaning. That is the material difference from a merely unproven bound, and the reason this returns no behavior gap.

### Two adjacent observations, recorded and not acted on

- `dispatch.sh:4068` and `:4083` use `eval`, and `:1880` uses `.` — the plan forbids `eval`/`source` of **actor content**. Neither is: the `eval`s interpolate `TREE_MARKER_FD`, a dispatcher-set integer, and the `.` sources the tracked lease library from the checkout. Not a finding; recorded so a later reader does not re-raise it.
- The refusal token reaching an operator message is `head -1` of `$RUN_LOG.consume`, a transient file inside the allowlisted evidence directory. The validators only ever emit fixed one-word literals, and the token reaches a message rather than a decision, so a race there cannot change routing.

### Earliest target, and the next unmet clause

**This hostile-input requirement is behaviorally met at the terminal-result boundary.** No `BEHAVIOR GAP` and no `PROOF GAP` was found: every category is either actively refused with committed proof, or has no consumer to mislead.

The only concrete change this discovery justifies is a **removal** — delete the unreachable `too-many-lines` bound and its constant — which is the brief's stated preference for removal over new machinery, and is a one-unit change with no behavior consequence to prove.

The next unmet Change set A item is therefore not in this boundary but in the **change-set acceptance sweep** (plan `:218`–`:223`): the end-to-end assertions that every admitted-run terminal class produces exactly one valid result, that crash injection at each named durable boundary (plan `:194`–`:199`) yields no duplicate model request, duplicate commit, false completion, unsafe owner clear or premature lease release, and that adversarial fixtures write nowhere outside admitted roots. Substantial crash and signal proof already exists in the committed suite, so the honest next unit is to establish which of those acceptance clauses lack an end-to-end assertion rather than to assume any of them do.

### Bounded-scope confirmation

No production, test, plan or documentation file changed and no test suite ran. Only this state file is staged; `logs/friction-log.md` left unstaged.

## Blocker

None.

## Next action

Codex: assess Unit 23 — the terminal-result hostile-input boundary is behaviorally met with committed proof in every reachable category, the one bound without proof (`too-many-lines`) is unreachable dead code behind two tighter gates rather than a gap, and no category has a missing limit that could alter trusted meaning. Decide whether to open the one-unit removal of that dead bound, or to move to establishing which change-set acceptance clauses lack an end-to-end assertion.
