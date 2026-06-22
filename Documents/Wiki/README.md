# DeepWiki Human Guide

This wiki explains what was fixed in the Documentation_agent, why it was fixed, and how to verify the full workflow in a real repository.

## Navigation

1. [Problems and Fixes](PROBLEMS_AND_FIXES.md)
2. [Operational Workflow](WORKFLOW.md)
3. [Execution Evidence](EVIDENCE.md)

## Goal

Provide a reliable, reproducible, and human-readable documentation pipeline using:

- code-review-graph (CRG)
- graphify
- git hooks for automatic updates

## Expected outputs after a successful install

- `.vscode/mcp.json`
- `.code-review-graph/graph.db`
- `.code-review-graph/wiki/`
- `graphify-out/GRAPH_REPORT.md`
- `graphify-out/graph.json`
- `graphify-out/graph.html`
