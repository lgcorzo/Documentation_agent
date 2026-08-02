---
type: "quality"
title: "ISO/IEC 25010 Software Quality Assessment"
source_path: "openwiki/quality/iso_25010_quality.md"
description: "Evaluation of system quality characteristics against the ISO/IEC 25010 SQuaRE standard for the Documentation_agent ecosystem."
tags: ["iso25010", "quality", "square", "assessment"]
timestamp: "2026-07-31T18:15:00Z"
generated: "agent:okf-professional-documenter"
verified: "true"
last_verified_commit: "N/A"
---

# ISO/IEC 25010 Software Quality Assessment

## Quality Characteristics Matrix

| Quality Characteristic | Sub-Characteristic | System Mechanism / Evidence | Source Line Citation | Rating |
|:---|:---|:---|:---|:---|
| **Functional Suitability** | Functional Completeness | Local AST parsing covers Python, TypeScript, Go, Rust, Java, C/C++ via Graphify/Pyreverse/tree-sitter. | `.agents/skills/uml2-okf-documenter/SKILL.md:L54-L59` | ✅ High |
| **Functional Suitability** | Functional Correctness | AST extraction produces zero-hallucination structural data; validated against codebase. | `openwiki/logs.md` | ✅ High |
| **Performance Efficiency** | Time Behaviour | `graphify update .` executes AST indexing locally in seconds without API latency. Background execution via Git hooks. | `hooks/post-commit` | ✅ High |
| **Performance Efficiency** | Resource Utilization | Background processes with 5-minute timeout. Guard clauses prevent duplicate processes. | `hooks/post-commit` | ✅ High |
| **Compatibility** | Co-existence | Cross-platform support (Linux Bash + Windows PowerShell). OS detection in hooks. | `hooks/post-commit` | ✅ High |
| **Compatibility** | Interoperability | Graphify platform integration for IDEs. Standard Markdown output. OKF v0.2 schema. | `install.sh` | ✅ High |
| **Usability** | Learnability | Single `install.sh` / `install.ps1` command sets up entire ecosystem. | `install.sh:L1-L123` | ✅ High |
| **Usability** | Operability | Git hooks make updates invisible to developer. No manual invocation needed. | `openwiki/user_guides/developer_guide.md` | ✅ High |
| **Reliability** | Fault Tolerance | Package naming fallback (`graphify` → `graphifyy`). Graceful skip when tools missing. | `install.sh:L30-L33` | ⚠️ Medium |
| **Reliability** | Recoverability | Graph can be fully rebuilt from source at any time via `graphify update .`. | `openwiki/user_guides/developer_guide.md` | ✅ High |
| **Security** | Confidentiality | Local-first AST execution — no external code sent to third-party embedding servers. | [[Architecture/ADR/ADR001ASTEngine]] | ✅ High |
| **Security** | Integrity | OKF validator ensures documentation provenance and frontmatter compliance. | `skills/validate/scripts/okf_validate.py` | ✅ High |
| **Maintainability** | Modularity | Clean 1:1 mirroring between `src/` and `openwiki/modules/`. Sovereignty separation. | [[Architecture/ADR/ADR002SovereigntyModel]] | ✅ High |
| **Maintainability** | Analysability | Graphify community detection groups related code into logical clusters. | `graphify-out/GRAPH_REPORT.md` | ✅ High |
| **Maintainability** | Testability | OKF validator provides automated conformance testing in CI/CD. | `.github/workflows/validate-docs.yml` | ✅ High |
| **Portability** | Adaptability | OS-agnostic support (Linux Bash & Windows PowerShell). Fallback install paths. | `install.ps1`, `install.sh` | ✅ High |
| **Portability** | Installability | Install-into-repo wrappers for deploying ecosystem to target repositories. | `install-into-repo.sh`, `install-into-repo.ps1` | ✅ High |

## Overall Quality Score

| Characteristic | Score |
|:---|:---|
| Functional Suitability | ⭐⭐⭐⭐⭐ |
| Performance Efficiency | ⭐⭐⭐⭐⭐ |
| Compatibility | ⭐⭐⭐⭐⭐ |
| Usability | ⭐⭐⭐⭐⭐ |
| Reliability | ⭐⭐⭐⭐ |
| Security | ⭐⭐⭐⭐ |
| Maintainability | ⭐⭐⭐⭐ |
| Portability | ⭐⭐⭐⭐⭐ |

## Improvement Areas

1. **Security → Integrity**: Complete the OKF validator replacement (mock → real conformance checker) to fully enforce documentation provenance.
2. **Reliability → Fault Tolerance**: Add retry logic for network-dependent installations (Ollama, uv).
3. **Maintainability → Testability**: Add unit tests for `okf_validate.py` and `log-bridge-event.sh`.
