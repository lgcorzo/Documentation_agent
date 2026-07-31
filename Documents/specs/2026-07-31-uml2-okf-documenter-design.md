# Technical Design Specification: `uml2-okf-documenter` Skill

## 1. Executive Overview

The `uml2-okf-documenter` agent skill equips AI coding assistants with an enterprise-grade, deterministic software documentation workflow. It combines **UML 2.0 notation**, the **Open Knowledge Format (OKF) & OpenWiki standard**, and the **NotebookLM / Local Dev Documentation Ecosystem** (`graphify`, `code-review-graph`, `pyreverse`, `Ollama` embeddings, and `notebooklm-mcp`).

---

## 2. Key Standards & Architectural Principles

### A. Open Knowledge Format (OKF) & OpenWiki
* Every generated document includes standardized YAML frontmatter (`type`, `title`, `description`, `tags`, `timestamp`).
* Maintains a synchronized root wiki index (`index.md`) and change log (`logs.md`).
* Output directory: `./openwiki/` mirroring source repository directory hierarchy 1:1.

### B. UML 2.0 Compliance (Mermaid.js)
* **Class Diagrams (`classDiagram`)**: Explicit inheritance (`<|--`), realizations (`<|..`), associations (`-->`), methods, and properties derived via local AST extraction.
* **Sequence Diagrams (`sequenceDiagram`)**: Autonumbered runtime message passing, polymorphic method calls, and control flow.
* **Component & Package Diagrams**: Clear system boundaries, layer interactions, and inter-package dependencies.

### C. Local Dev Ecosystem & Deterministic Extraction
* **AST Class Analysis**: `pyreverse` for zero-hallucination OOP class mapping.
* **Topology & Knowledge Graph**: `graphify` and `code-review-graph` for local dependency topology and SQLite FTS5 semantic queries.
* **NotebookLM MCP Integration**: Interoperable with `notebooklm-mcp` tools (`notebook_query`, `note`, `studio_create`) for contextual queries and artifact summaries.
* **Obsidian Wikilinks**: Interconnected documentation pages using `[[Module]]` syntax.
* **Relative Path References**: Strict use of relative source links (e.g., `src/core/processor.py:L25-L80`).

---

## 3. File Location & Layout

Target repository path:
* `/mnt/F024B17C24B145FE/Repos/Documentation_agent/.agentskills/uml2-okf-documenter/SKILL.md`

---

## 4. Verification & Quality Gates

* **Frontmatter Validation**: Ensure YAML header complies with `agentskills.io` spec.
* **Mermaid Syntax**: Valid syntax for all class, sequence, and component diagrams.
* **Relative Paths**: No absolute paths allowed in generated output or skill instructions.
* **Zero-Hallucination**: AST & local graph tools used as single source of truth for code symbols.
