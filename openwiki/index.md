---
iso_doc_type: "Description"
iso_viewpoint: "ArchitectureDescription"
type: "index"
title: "Documentation_agent OpenWiki Knowledge Hub"
description: "Master navigation hub and index for the Documentation_agent ISO-compliant architecture wiki."
tags: ["index", "navigation", "okf", "openwiki"]
timestamp: "2026-07-31T18:15:00Z"
generated: "agent:okf-professional-documenter"
verified: "true"
last_verified_commit: "N/A"
---

# 📚 Documentation_agent — OpenWiki Knowledge Hub

> **ISO/IEC/IEEE 42010:2022 Architecture Description** for the DeepWiki Documenter Ecosystem.
> This wiki is the single, authoritative Architecture Description (AD) artifact.

---

## 🏗️ Architecture

| Page | ISO Viewpoint | Description |
|:---|:---|:---|
| [[Architecture/ISO42010Overview]] | AD Overview | Master viewpoint index, stakeholder matrix, and compliance traceability |
| [[Architecture/SystemContext]] | Context View | System boundaries, external tool interactions, data flow |
| [[Architecture/ComponentStructure]] | Component View | Subsystem decomposition, UML 2.0 component diagrams |

### Architecture Decision Records (ADRs)

| ADR | Status | Decision |
|:---|:---|:---|
| [[Architecture/ADR/ADR001ASTEngine]] | ✅ Accepted | Local AST tools over external LLM databases |
| [[Architecture/ADR/ADR002SovereigntyModel]] | ✅ Accepted | Three-domain sovereignty separation (Spec-Kit / Superpowers / OpenWiki) |

---

## 📋 Specifications

| Page | ISO Doc Type | Description |
|:---|:---|:---|
| [[Specifications/APIContracts]] | Specification | CLI scripts, Git hooks, validator, and agent skills interface contracts |

---

## 📊 Quality

| Page | ISO Standard | Description |
|:---|:---|:---|
| [[Quality/ISO25010Quality]] | ISO 25010 | Software quality assessment across 8 SQuaRE characteristics |

---

## 📖 User Guides

| Page | Audience | Description |
|:---|:---|:---|
| [[UserGuides/DeveloperGuide]] | Developers | Installation, onboarding, sovereignty rules, troubleshooting |

---

## 📝 Audit & Governance

| Page | Purpose |
|:---|:---|
| [[Logs]] | Incremental audit log and git diff history |

### Governance Documents (outside wiki)

| Document | Location |
|:---|:---|
| Constitution | `.specify/memory/constitution.md` |
| Sovereignty Rules | `.specify/bridge/sovereignty-rules.md` |
| Bridge Configuration | `.specify/bridge/bridge-config.json` |
| Copilot Instructions | `.github/copilot-instructions.md` |

---

## 🗂️ Wiki Structure

```
openwiki/
├── index.md                          ← YOU ARE HERE
├── architecture/
│   ├── iso_42010_overview.md         # AD Overview & Viewpoint Index
│   ├── system_context.md             # Context View
│   ├── component_structure.md        # Component View
│   └── adr/
│       ├── adr_001_ast_engine.md     # ADR: Local AST Tools
│       └── adr_002_sovereignty_model.md  # ADR: Sovereignty Separation
├── specifications/
│   └── api_contracts.md              # CLI & API Contracts
├── quality/
│   └── iso_25010_quality.md          # ISO 25010 Quality Assessment
├── user_guides/
│   └── developer_guide.md            # Developer Onboarding Guide
└── logs.md                           # Audit Log
```
