---
type: "architecture"
title: "System Context View"
source_path: "openwiki/architecture/system_context.md"
description: "ISO 42010 Context View defining system boundaries, external actor interactions, and tool dependencies for the Documentation_agent ecosystem."
tags: ["iso42010", "context-view", "boundaries", "external-tools"]
timestamp: "2026-07-31T18:15:00Z"
generated: "agent:okf-professional-documenter"
verified: "true"
last_verified_commit: "N/A"
---

# Context View: Documentation_agent Ecosystem

## 1. System Boundary Definition

The Documentation_agent ecosystem is a **local-first developer tooling platform** that automates the generation and maintenance of ISO-compliant software documentation. It runs entirely on the developer's machine, with optional CI/CD extensions via GitHub Actions.

```mermaid
flowchart TD
    subgraph "Documentation_agent Ecosystem"
        direction TB
        A["Agent Skills<br/>(okf-professional-documenter,<br/>uml2-okf-documenter)"]
        B["Git Hooks<br/>(post-commit, post-checkout)"]
        C["OKF Validator<br/>(okf_validate.py)"]
        D["OpenWiki<br/>(./openwiki/)"]
        E["Bridge<br/>(.specify/bridge/)"]
    end

    subgraph "External Tools (Local)"
        F["Graphify CLI"]
        H["Pyreverse (pylint)"]
    end

    subgraph "External Platforms"
        J["GitHub Actions"]
        K["GitHub Repository"]
        L["Confluence (optional)"]
    end

    subgraph "Governance Frameworks"
        M["Spec-Kit (.specify/)"]
        N["Superpowers"]
    end

    B --> F
    A --> H
    A --> F
    B --> D
    A --> D
    C --> D
    J --> C
    J --> K
    M --> E
    N --> E
```

## 2. External Actor Interactions

| External Actor | Interaction Type | Protocol / Interface | Data Exchanged |
|:---|:---|:---|:---|
| **Graphify CLI** | CLI execution | `graphify update .` / `graphify cluster-only .` | `graphify-out/graph.json`, `GRAPH_REPORT.md`, `graph.html` |
| **Pyreverse** | CLI execution | `pyreverse -o dot <dir>` | DOT graph output for class hierarchies |
| **GitHub Actions** | CI/CD trigger | `on: [push, pull_request]` / `schedule` | OKF validation results, OpenWiki update PRs |
| **Spec-Kit** | IDE agent workflow | `/speckit.specify`, `/speckit.plan`, `/speckit.tasks` | `spec.md`, `plan.md`, `tasks.md` |
| **Superpowers** | IDE agent execution | TDD cycles via bridge handoff | Test results, code mutations |

## 3. Installation Dependencies

```mermaid
flowchart LR
    A["install.sh / install.ps1"] --> B["uv (package manager)"]
    B --> D["graphifyy"]
    A --> G["Git Hooks installed"]
```

### Dependency Matrix

| Dependency | Required? | Purpose | Install Method |
|:---|:---|:---|:---|
| `uv` | Yes | Python package management | `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| `graphify` / `graphifyy` | Yes | AST graph + community detection | `uv tool install graphifyy` |
| `pylint` (pyreverse) | Recommended | Class hierarchy extraction | `pip install pylint` |
| `Node.js 22+` | CI/CD only | OpenWiki GitHub Action | GitHub Actions `setup-node` |

## 4. Data Flow Overview

```mermaid
flowchart TD
    A["Developer writes code"] -->|"git commit"| B["Git Hook (post-commit)"]
    B -->|"Background"| C["Graphify: AST extraction"]
    B -->|"Sync"| E["Bridge Event Logger"]
    C --> F["graphify-out/graph.json"]
    E --> H[".specify/bridge/bridge-events.jsonl"]
    
    I["Agent Skill invoked"] --> J["Read AST data"]
    J --> F
    I --> K["Generate OKF pages"]
    K --> L["openwiki/**/*.md"]
    
    M["CI/CD Pipeline"] -->|"Validate"| L
    M -->|"Read provenance"| H
    M -->|"Report"| N["GitHub PR / Actions Summary"]
```
