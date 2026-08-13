# Phase 0 — attended launcher proof

**Date:** 2026-08-07  
**Checkout:** isolated Codex worktree, not Claude's active checkout  
**Plan:** `unattended-operation-plan-v0.2.md`, Phase 0  
**Result:** nested launch works; direct detachment from a Codex command does not; the supervised
terminal fallback works; a five-hop live run exercised `continue` and closed.

No dispatcher, skill, command, core, setting, hook, or permission file was changed for this proof.
The only repository effects were the two proof fixtures and this evidence record. Run captures were
written under `/tmp/wl2-phase0-codex.9FZift/`.

---

## 0a — launch from inside a Codex task

The dispatcher was invoked from this Codex task with a read-only nested Codex sentinel as its actor.
The first attempt, inside the ordinary tool sandbox, failed before the child initialized:

```text
failed to open logs db ... attempt to write a readonly database
Error: failed to initialize in-process app-server client: Operation not permitted
```

The permitted unsandboxed rerun launched the nested child successfully:

```text
{"type":"thread.started","thread_id":"019fdae2-37c3-7140-ae95-3a7be70b2f2f"}
{"type":"item.completed","item":{"type":"agent_message","text":"NESTED_CODEX_OK"}}
{"type":"turn.completed",...}
```

The child completed in 4 seconds. The dispatcher then stopped `22 NO_TRANSITION`, which was the
deliberate expected outcome because the sentinel was read-only and the fixture state file remained
byte-identical:

```text
before sha256=97017fec4176def7932ccf182ea92e95b265e05e4af84031aa7a696e248246e9
after  sha256=97017fec4176def7932ccf182ea92e95b265e05e4af84031aa7a696e248246e9
```

**Finding:** nested Codex works from a Codex task, but the launch must run outside the ordinary
command sandbox so the child can access its own state and authentication.

---

## 0b — detached survival checklist

### 1. What keeps the dispatcher alive after the launching Codex command ends?

Nothing in the attempted direct-detached shape. This command returned `0`:

```text
nohup caffeinate -i dispatch.sh ... --actor-cmd 'sleep 240' > detached-console.out 2>&1 &
```

But the recorded `caffeinate` PID was already gone at the next check, `detached-console.out` was
empty, and no dispatcher lock or run log was ever created. The Codex command runner cleaned up the
background process before the dispatcher started.

**Conclusion:** the detached shape fails in this launch environment. The plan's fallback — a
supervised terminal session — is required.

### 2. Does nested `codex exec` run reliably?

It ran successfully once outside the sandbox and failed twice inside the sandbox before
initialization. This proves the viable launch condition, not repeat reliability.

### 3. How are PID and logs discovered afterwards?

The supervised fallback was launched in a managed terminal under `caffeinate -i`. Unsandboxed
`--status` reported:

```text
run: IN FLIGHT — dispatcher pid 79266
to stop it: kill -TERM 79266
logs: /tmp/wl2-phase0-codex.9FZift/20260807T092330-fixture-slice1-false.log
last hop line: hop=1 actor=codex
```

A status call made inside the ordinary command sandbox falsely reported the same live lock as
`STALE LOCK`, because `kill -0` could not see the unsandboxed PID. This is a real status defect for
Codex-launched operation: status must distinguish “permission denied while checking” from “PID does
not exist.”

### 4. How does the operator stop it?

`kill -TERM 79266` produced:

```text
STOP [28] interrupted by SIGTERM during hop 1 (actor 'codex')
terminating actor process group 79425
Nothing is retried.
```

The managed terminal returned exit `28`; process 79425 was gone; the lock disappeared; the fixture
state hash stayed byte-identical.

### 5. How does the originating Codex task learn the run finished?

The supervised terminal returns the final dispatcher output to the task, and `--status` can be
polled. No detached completion callback or end-state notification was demonstrated because the
detached launch itself did not survive.

### 6. Do Claude and Codex authentication tolerate concurrent parent and child use?

Yes when the child is launched outside the ordinary tool sandbox:

```text
Nested Codex: NESTED_CODEX_OK
Claude 2.1.220: CLAUDE_CONCURRENT_OK
```

The sandboxed Claude attempt returned `Not logged in`; the unsandboxed attempt completed normally.
This is an environment-access distinction, not evidence that the account itself was unavailable.

---

## 0c — attended multi-hop run with `continue`

**Run:** `20260807T092540-phase0-attended-continue-proof`  
**Limits:** `--max-hops 6`, `--timeout 300`, `--deadline 900`, `caffeinate -i`  
**Terminal condition:** valid core § 4 closing record at `turn: operator`  
**Operator transport during the run:** none

The task changed two proof markers, one accepted unit at a time:

```text
hop 1  Claude  62s  Unit 1 implemented and committed  -> codex
hop 2  Codex   68s  Unit 1 accepted; Unit 2 opened    -> claude
hop 3  Claude  78s  Unit 2 implemented and committed  -> codex
hop 4  Codex   43s  Unit 2 accepted; close verdict    -> claude
hop 5  Claude  50s  closing record committed          -> operator
```

Total actor time was 301 seconds. The run used three commits, each reported by the dispatcher as
entirely within the allowlist. Codex moved no HEAD. `continue` was exercised at hop 2 without an
invented token and without operator intervention.

Durable result:

- `logs/work-loop/phase0-attended-continue-proof.md` — valid closing record
- `logs/work-loop/phase0-continue-target.md` — exactly:

```text
first: current
second: current
```

**What stopped the run:** the task closed correctly at hop 5. It did not stop on timeout, budget,
hop limit, permission, unexpected effect, malformed state, or operator question.

---

## Phase 0 conclusion

- The viable launch shape is a **supervised terminal session**, not a detached background process
  started by a Codex command.
- Nested Codex and Claude both work with concurrent parent use when unsandboxed access is approved.
- One task can chain multiple units automatically. The fixture took roughly five minutes, which is
  useful timing evidence but too artificial to justify a new cross-task supervisor.
- The status sandbox/PID false-negative must be corrected before `--status` can be trusted from the
  originating Codex task.
- Phase 0 is complete. Phase 1 may continue. Phase 2 remains blocked by every Phase 1 prerequisite
  and especially the operator's unattended-authority decision in 1d.
