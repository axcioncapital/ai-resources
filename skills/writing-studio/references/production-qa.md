# Production QA

Run production QA after an identifiable candidate exists and before preparing an independent-review handoff. This is authoring hygiene performed by the producing context; label it `independent: false` and never describe it as approval.

## Bind the check

Record the exact candidate path and its destination version identifier. When the destination has no identifier that binds later decisions to exact wording, record a minimal candidate label plus a content hash.

Do not QA an unnamed working buffer or transfer a verdict to materially changed wording. A material change creates a new candidate identity and repeats every affected check.

## Check semantic integrity

Check the exact candidate against:

- the settled writing job and production contract;
- source roles and claim permissions;
- evidence limits, qualifications, and calibrated claim strength;
- communication authority, required terminology, and prohibited wording;
- reader prerequisites and concept grounding;
- the selected opening's promise;
- journey completion and distinct contribution;
- destination constraints and authorised write boundaries; and
- clean separation between reader-facing copy and production notes.

If a defect cannot be fixed without new authority, evidence, or scope, do not improvise. Return it through `SOURCE_OR_DECISION_REQUIRED`.

## Apply the writing-quality lenses

1. **Thesis progression:** each material section advances a proposition rather than merely covering a topic.
2. **Analytical value:** important evidence is interpreted rather than deposited.
3. **Judgment discipline:** observation, interpretation, implication, and qualification remain distinguishable where the argument depends on them.
4. **Calibrated certainty:** wording expresses no more confidence than the permitted support.
5. **Reader sophistication:** the candidate explains what this audience needs without rehearsing what it is expected to know.
6. **Restrained prose:** the writing is precise, economical, and non-promotional; commercial or domain implications appear only when the production contract requires them.

Treat these as defect signals rather than mechanical bans:

- generic scene-setting;
- evidence without interpretation;
- inflated claims;
- redundant section summaries;
- unnecessary explanation; and
- recap-only conclusions.

Do not create a numerical score or paragraph-by-paragraph compliance form. The purpose is to find material defects, not demonstrate that every sentence was inspected.

## Disposition defects

For each material defect:

- fix it within the existing authority and write boundary; or
- return it to the named owner with the missing decision, evidence, or permission.

After any material fix, update the candidate identity as destination policy requires and repeat the affected checks. Do not weaken a finding merely to reach a pass.

## Output

Write a compact record in the destination's existing production artifact:

```text
PRODUCTION_QA
candidate: <exact identity and path>
independent: false
verdict: PASS | SOURCE_OR_DECISION_REQUIRED
material_defects:
  - <none, or concise defect and disposition>
```

`PASS` means the producing context found no unresolved material production defect. It does not mean independently reviewed, accepted, approved, or publishable.
