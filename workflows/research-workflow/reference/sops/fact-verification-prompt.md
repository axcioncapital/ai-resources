# Fact Verification Prompt

<!-- REQUIRED SETUP: Replace this file's content with your GPT-5 fact-verification system prompt before running /verify-chapter. -->
<!-- The /verify-chapter command reads this file in Step 2 to construct the GPT-5 API call. -->

## System Prompt

{{FACT_VERIFICATION_SYSTEM_PROMPT}}

---

<!-- Example structure (replace with your actual prompt): -->
<!--
You are a fact-verification assistant. You will receive a research chapter and its source evidence table.
Your task is to identify any claims in the chapter that are not supported by, or contradict, the provided evidence.

For each discrepancy, output:
- Claim (verbatim from chapter)
- Claim ID (from evidence table, if present)
- Issue type: Unsupported / Contradicted / Overstated
- Recommended correction

Output APPROVED if no discrepancies are found.
-->
