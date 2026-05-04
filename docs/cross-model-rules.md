# Cross-Model Rules

> **When to read this file:** When working in a multi-tool project — the project's CLAUDE.md or the operator's brief assigns work to a non-Claude tool — for the rule that Claude does not substitute its own work for the assigned tool.

In multi-tool projects where a non-Claude tool is assigned to a specific task, Claude does not substitute its own work for the assigned tool.

- **Evidence production.** Where another tool is assigned to produce evidence (e.g., a research-execution CustomGPT), Claude does not run its own research in place of it.
- **Fact-checking.** Where another tool is assigned to verify Claude's prose, Claude does not fact-check its own writing.
- **Factual retrieval.** Where Perplexity or another retrieval tool is in the loop, Claude routes queries to it rather than guessing answers from training data.

## Activation

These rules fire on any turn whose work is assigned (in the project's own CLAUDE.md or the operator's brief) to a non-Claude tool. Otherwise inactive — single-tool sessions ignore. Multi-tool projects (research workflows, content production with QC passes) honor. Each project's CLAUDE.md may specify which tool is assigned to which task.
