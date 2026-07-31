---
iso_doc_type: "Description"
iso_viewpoint: "ArchitectureDecision"
type: "adr"
title: "ADR 002: Sovereignty Separation Model (Spec-Kit / Superpowers / OpenWiki)"
source_path: "openwiki/architecture/adr/adr_002_sovereignty_model.md"
description: "Architecture Decision Record documenting the three-domain sovereignty separation between Spec-Kit (specification), Superpowers (execution), and OpenWiki (architecture description)."
tags: ["adr", "iso42010", "decision", "sovereignty", "spec-kit", "superpowers"]
timestamp: "2026-07-31T18:15:00Z"
generated: "agent:okf-professional-documenter"
verified: "true"
last_verified_commit: "N/A"
---

# Architecture Decision Record (ADR 002): Sovereignty Separation Model

## 1. Status

**ACCEPTED** (Date: 2026-07-31)

## 2. Context & Stakeholder Concern

* **Addressed Concern:** When multiple agentic frameworks (Spec-Kit for specification, Superpowers for execution) operate in the same repository, file ownership conflicts and context duplication cause hallucinated duplicate task lists, state corruption, and broken audit trails.
* **Framing Viewpoint:** Component View & Security View (ISO 42010).
* **Stakeholders Affected:** System Architect, Lead Developer, ISO Compliance Auditor.

## 3. Decision

Establish a **three-domain sovereignty model** with strict file ownership boundaries:

| Domain | Owner | Governed Artifacts |
|:---|:---|:---|
| **Specification** | Spec-Kit | `specs/`, `plan.md`, `tasks.md`, `.specify/memory/constitution.md` |
| **Execution** | Superpowers | `src/`, `tests/`, runtime scripts |
| **Architecture Description** | OpenWiki/OKF | `openwiki/**/*.md` |

A **Bridge** (`.specify/bridge/`) mediates all cross-domain state transitions. Direct execution without an active `superpowers-handoff.json` is a policy violation.

## 4. Rationale & Alternatives Evaluated

| Alternative | Trade-Off / Failure Mode | Result |
|:---|:---|:---|
| **Single Monolithic Framework** | One tool managing everything creates lock-in and violates separation of concerns. | **Rejected** |
| **Loose Coordination (No Bridge)** | Race conditions when Spec-Kit and Superpowers modify overlapping files simultaneously. Context duplication. | **Rejected** |
| **Strict Sovereignty with Bridge** | Clear ownership boundaries. Bridge mediates transitions. Event log enables ISO 15289 traceability. | **Selected** ✅ |

## 5. Consequences

### Positive
- **No race conditions** — File ownership is unambiguous.
- **ISO 15289 traceability** — Bridge events log all cross-domain operations.
- **Context efficiency** — No duplicate task tracking across tools.
- **Audit-ready** — Clear provenance chain from spec → plan → tasks → code → docs.

### Negative
- **Bridge overhead** — Requires maintaining `bridge-config.json` and event log.
- **Learning curve** — Developers must understand sovereignty boundaries.
- **External bridge dependency** — If `superspec` bridge is unavailable, manual mediation required.

## 6. Affected System Artifacts

- `.github/copilot-instructions.md:L288+` — Sovereignty rules (Section 3).
- `.specify/bridge/sovereignty-rules.md` — Formal sovereignty contract.
- `.specify/bridge/bridge-config.json` — Machine-readable sovereignty configuration.
- `.specify/bridge/bridge-events.jsonl` — ISO 15289 traceability log.
- `.specify/memory/constitution.md` — Principle III (Sovereignty Separation).

## 7. Forward References

- [Architecture/ComponentStructure](../component_structure.md) — Shows Layer 1 (Governance) component relationships.
- [Architecture/SystemContext](../system_context.md) — Shows Bridge as mediator between Spec-Kit and Superpowers.
- [[Quality/ISO25010Quality]] — Maintainability evaluation of the sovereignty model.
