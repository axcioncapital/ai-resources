# Spine Schemas (Kernel Reference)

> **When to read this file:** Before writing or validating a run manifest, a defect-log entry, an escalation packet, or before checking a verification-level floor, a caller-side subagent-output check, or an O6-profile output. This is the single defining authority for these seven schemas — definitions live once, here; commands and skills reference this doc rather than restating field lists.
>
> **Origin:** W3.2 roadmap item R1 (`W3.2-migration-roadmap.md` :45). Design source: `axcion-ai-system-redesign/window-outputs/W2.3-reliability-safety-eval-spine.md` (§3b, §4a, §5, §7a, §8, §12, §13b) and `W3.2-target-architecture.md` §2.7 mechanism 5. Implementation packet (source of truth for the design decision + gate history): `axcion-ai-system-redesign/output/implementation-prep/packets/R1-spine-schemas.md` (SO-approved 2026-07-09).
>
> **Maintenance:** Hand-maintained. This doc is a prerequisite for W3.2 roadmap items R3 (run-manifest write + wrap), R4 (incident wrap-gate), PJ (propagation join), and M-D2 (lane telemetry) — those items read the schemas below; do not fork or restate them locally. Changes to field names here are two-end contracts with those consumers once they land — coordinate before renaming.

---

## 1. Run-manifest schema

One JSON record per substantive session, at `logs/runs/{date}-{marker}.json`.

```json
{
  "run_id": "...", "project": "...", "date": "...", "marker": "...",
  "model": "...", "lane": "fast | standard | complex",
  "mandate_ref": "...", "mission": "...",
  "context": { "pack_path": "...", "always_loaded_estimate_tok": 0 },
  "resources": {
    "skills": ["..."],
    "subagents": [ { "type": "...", "declared_tier": "...", "dispatch": "spawned | inline-degraded" } ],
    "tools_notable": ["..."]
  },
  "files_changed": ["..."],
  "decisions_refs": ["..."],
  "validation": [ { "output": "...", "level_reached": "mechanical | functional | mandate | independent | real-world" } ],
  "evaluator_findings": { "sidecar_refs": ["..."], "verdicts": ["GO | REVISE | BLOCKED"] },
  "overrides": [ { "gate": "...", "action": "operator-override", "reason": "..." } ],
  "cost": { "turns": 0, "subagents": 0, "token_estimate": null },
  "stop_reason": "completed | deferred | blocked | cap-hit | compaction | crash(absent)",
  "outcome": "DELIVERED | PARTIAL | ABANDONED",
  "failure_class": "one of the 11 taxonomy values (§5) | null",
  "incidents_refs": ["defect-log.md#entry-id"]
}
```

**Load-bearing fields (two-end contract — do not rename or omit):** `run_id`, `mandate_ref`, `model`, `files_changed` (maintained *running*, not wrap-only, so partial-edit recovery reads the manifest rather than a plan file that may not exist), `overrides` (feeds guard-recalibration telemetry), `failure_class` (the incident-gate key, §5), `validation.level_reached` (the verification-floor key, §4). R3's wrap-time write and close-validation step reads these under exactly these names.

**Write discipline:**
- **Start-stub** at mandate confirmation: `run_id`, `mandate_ref`, `model`, `date`, `marker`. Enables crash/orphan detection on every lane.
- **Append-updated** at named checkpoints (post-plan, post-QC).
- **Closed at wrap** with a schema validation that **aborts loudly on mismatch** — never a silent pass.

## 2. Defect-entry schema

Extends `ai-resources/logs/defect-log.md`'s existing 7 defect classes — this is additive, not a replacement.

| Field | Content |
|---|---|
| incident | What happened, one paragraph, with evidence path (manifest ref, log line, diff) |
| expected / actual | The contract that was violated, quoted |
| root cause | Structural cause, not proximate |
| correction | The fix applied — or `deliberate-no-fix` with rationale (parking is legitimate; silence is not) |
| regression test | A golden task or mechanical check added to the eval set — the entry's exit condition |
| owner | The rule/doc/hook that should prevent recurrence |
| displacement check | At the next eval run: did the failure reappear elsewhere? Entry closes only when the test passes AND this is clean |

**Trigger (via the run manifest, §1):** manifest `failure_class ≠ null` ⇒ wrap refuses to close without a defect-log entry **or** an explicit one-line waiver in the manifest (`"incident_waived": "reason"`). The schema is the trigger, not operator memory.

## 3. Escalation packet

One shape, used by every gate that needs an operator decision:

- `decision_required` — the one-line question.
- `options[]` — 2–4 choices, each one line.
- `evidence[]` — paths/counts, not prose.
- `recommendation` — exactly one.

This is the closed set. Do not invent a per-command variant.

## 4. Verification levels

**The five levels:**

| Level | Test | Deterministic share |
|---|---|---|
| **1 Mechanical** | Schema/lint/reference-integrity/format — scripts and hooks | Fully deterministic |
| **2 Functional** | Executes on realistic inputs incl. empty/error states | Script-driven fixtures |
| **3 Mandate** | Solves the intended problem, stays in scope | Model judgment (`/qc-pass`, `/contract-check`) |
| **4 Independent** | Separate evaluator, clean context | O6 profile (§7); `qc-reviewer` shell |
| **5 Real-world** | Rendering/deployment/user-path/artifact-opening | Designed now, built later — trigger: first artifact class with a real-world surface |

**Minimum-level floor per output class:**

| Output class | Floor | Rationale |
|---|---|---|
| Hooks, settings, scripts (executable surface) | **1 + 2 mandatory** | Behavioral bugs are missed by static review alone |
| Commands, skills, docs | 1 + 3 | Reference-integrity script + mandate QC |
| O6 outputs | 3 + 4, multi-trial | §7 |
| Federation exports/snapshots | 1 + export-correctness spot-check | Confidentiality is covered elsewhere; this covers accuracy |
| Window/design artifacts | 3 + 4 | Current practice, kept |

**Enforcement:** the run manifest's `validation.level_reached` (§1) records the per-output level reached. Wrap checks the floor for the classes touched — class is derived from path pattern, floor from the table above. Below-floor closes only with an explicit waiver line; never a silent pass.

## 5. Failure taxonomy

**Closed set, 11 values** (grown from 10 — the 11th value, `confidentiality/disclosure`, was added to close a gap where a caught confidentiality leak had no classifiable `failure_class`, so the incident wrap-gate never forced a defect entry):

1. mandate drift
2. unsupported inference
3. generic output
4. weak prioritization
5. false completeness
6. context omission
7. instruction conflict
8. excessive complexity
9. tool misuse
10. evaluation blind spot
11. **confidentiality/disclosure**

Each value = one `failure_class` enum entry (§1) + at least one probing golden task in the evaluation framework. This is a closed set — do not add a 12th value without updating every consumer that enumerates it.

## 6. Caller-side 4-check convention

Every dispatching command runs the same four mechanical checks on a subagent's return, before consuming it:

1. **Exists** — output non-empty / file present at the echoed path.
2. **Path-echo** — the returned path matches the requested target.
3. **Entry-floor** — the return meets the declared minimum lines/fields for its contract.
4. **Schema-parse** — structured returns validate; verdict tokens fall within the closed set.

**On failure:** one re-invoke, then **inline-degraded mode with a loud flag** — record `"dispatch": "inline-degraded"` in the run manifest (§1). Silent trust and silent fallback both end here.

## 7. O6 profile — planner → generator → evaluator separation

**Scope — exactly four output types:** buyer-fit assessments, research conclusions, strategic recommendations, final external copy. **Not** routine file changes, infra edits, or internal docs — the separation's cost is justified only where a correlated blind spot carries commercial consequence.

**Topology:**

| Role | Context | Gets | Never gets |
|---|---|---|---|
| **Planner** | Business context, project files | The task; writes the spec + selects the rubric + **authors the evaluation scope line** | — |
| **Generator** | Clean context | Spec + inputs | The planner's reasoning beyond the spec; the rubric's scoring detail |
| **Evaluator** | Clean context (`qc-reviewer` isolation shell) | Output + rubric + golden-task reference outputs | The generator's reasoning, context pack, or prompt framing |

**The structural win:** in most review setups, the reviewed party authors the scope the reviewer judges against. Here, the **planner** — not the generator whose output is being judged — authors the evaluation scope line. That one reassignment closes the leak without new machinery.

**Verification floor:** level 3 + 4, multi-trial (§4).

**Relationship to `qc-independence.md`:** the O6 profile is this repo's existing QC context-isolation discipline (`ai-resources/docs/qc-independence.md`) plus the planner role. O6 is defined here, in this kernel doc, and cross-references `qc-independence.md` — it does not fork or edit that doc's methodology.
