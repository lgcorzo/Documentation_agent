---
iso_doc_type: "Description"
iso_viewpoint: "ArchitectureDecision"
type: "adr"
title: "ADR 001: Local AST Parsing Over External LLM Databases"
source_path: "openwiki/architecture/adr/adr_001_ast_engine.md"
description: "Architecture Decision Record documenting the choice of local Graphify/Pyreverse AST tools over complex external LLM/embedding servers for code knowledge extraction."
tags: ["adr", "iso42010", "decision", "ast", "graphify", "pyreverse"]
timestamp: "2026-07-31T18:15:00Z"
generated: "agent:okf-professional-documenter"
verified: "true"
last_verified_commit: "N/A"
---

# Architecture Decision Record (ADR 001): Local AST Parsing Over External LLM Databases

## 1. Status

**ACCEPTED** (Date: 2026-07-31)

## 2. Context & Stakeholder Concern

* **Addressed Concern:** The documentation ecosystem needs a reliable, fast, and cost-effective way to extract structural code information (classes, inheritance, dependencies, function signatures) for documentation generation.
* **Framing Viewpoint:** Component View & Maintainability (ISO 42010).
* **Stakeholders Affected:** System Architect, Lead Developer, DevOps Lead.

## 3. Decision

Adopt lightweight local AST CLI tools (`graphify update .`, `pyreverse -o dot`, Python `ast` module scripts) as the primary knowledge extraction engine. Documentation synthesis is performed exclusively by the primary agent LLM using deterministic AST data as input — never by guessing or hallucinating code structure.

## 4. Rationale & Alternatives Evaluated

| Alternative Evaluated | Trade-Off / Failure Mode | Evaluation Result |
|:---|:---|:---|
| **Multi-Service External LLM Graph** (e.g., dedicated vector DB + external embedding API) | Requires external servers (Ollama, Weaviate, etc.), complex installation, network dependency, API costs. | **Rejected** — Violates local-first principle. |
| **Vector-Only Semantic Search** | Captures semantic similarity but misses exact AST call graphs, inheritance trees (`<\|--`), and method contracts. | **Rejected** — Insufficient structural fidelity. |
| **LLM-Generated Code Analysis** | LLM reads source files directly and describes structure. | **Rejected** — Hallucination risk on signatures, parameters, and line numbers. |
| **Local AST Scripts + Primary LLM** | 0% hallucination on structural data, lightweight local execution, zero extra LLMs needed. Graphify provides community detection. Pyreverse provides class hierarchies. | **Selected** ✅ |

## 5. Consequences

### Positive
- **Zero hallucination** on code structure (mathematical extraction from AST).
- **Zero API cost** for structural knowledge extraction.
- **Sub-second execution** for incremental updates.
- **Offline capable** — no network dependency for AST extraction.
- **Deterministic** — same code always produces same graph.

### Negative
- Requires installing `graphify`/`graphifyy` and `pylint` (pyreverse) locally.
- Package naming inconsistency (`graphify` vs `graphifyy`) requires fallback logic in installers.
- AST extraction is language-specific; tree-sitter needed for non-Python languages.

## 6. Affected System Artifacts

- `install.sh:L26-L33` — Graphify installation with naming fallback.
- `hooks/post-commit:L35-L39` — Background graphify update trigger.
- `.agents/skills/uml2-okf-documenter/SKILL.md:L54-L59` — Tooling matrix specification.
- [[Architecture/ComponentStructure]] — Structural Memory components.

## 7. Validation Evidence

See [[../../../Documents/Wiki/EVIDENCE.md]] for validated execution evidence including:
- `graphify update .` producing 432 nodes, 578 edges, 37 communities.
- `code-review-graph build && code-review-graph wiki --force` producing 8 wiki pages.
- Package naming edge case (`graphify` → `graphifyy`) detected and mitigated.
