# Documentation_agent Ecosystem Constitution

## Core Principles

### I. Deterministic-First Documentation

All software documentation is grounded in **local, executable AST extraction** tools (`graphify`, `pyreverse`, Python `ast` module) before any LLM synthesizes prose. UML 2.0 class diagrams, inheritance hierarchies, and dependency graphs are mathematically derived from the Abstract Syntax Tree — never hallucinated. This ensures zero-drift between code reality and documentation.

### II. ISO 42010 Architecture Description Coherence

The **OKF root bundle (`./openwiki/`)** is the single, authoritative **Architecture Description (AD) artifact** per ISO/IEC/IEEE 42010:2022. All architectural viewpoints (Context, Component, Sequence, Deployment, Security) are mapped and traceable through this bundle. Scattered architectural intent across `.specify/`, `graphify-out/`, or other locations must always forward-reference back to the OKF wiki.

### III. Sovereignty Separation (Topology of Authority)

Three domains of authority are strictly separated:
- **Spec-Kit** owns specification, planning, and task breakdown (`spec.md`, `plan.md`, `tasks.md`, `constitution.md`).
- **Superpowers** owns code execution, TDD cycles (Red-Green-Refactor), and subagent dispatch.
- **OpenWiki/OKF** owns the documentation-as-architecture-description artifact.
- The **Bridge** (`.specify/bridge/`) mediates all cross-domain state transitions. Direct execution without an active bridge handoff file is a policy violation.

### IV. Provenance & Attestation (ISO 15289 Traceability)

Every generated documentation artifact must include provenance metadata:
- `generated`: Which agent or tool produced the artifact.
- `verified`: Whether the artifact was validated against live code.
- `last_verified_commit`: The git SHA at which the artifact was last confirmed accurate.
- Bridge events are logged to `.specify/bridge/bridge-events.jsonl` and consumed by the CI/CD pipeline to populate trust signals.

### V. Incremental Documentation by Default

Git-diff mode is the default operational mode for documentation updates. Full documentation regeneration is on-demand only. The `post-commit` hook triggers `graphify update .` asynchronously, and the OpenWiki CI/CD pipeline analyzes only changed files via `git diff`. This minimizes token consumption and ensures documentation stays current with every commit.

## Technical Standards

- **Language**: Python 3.10+ (per `copilot-instructions.md` Section 1)
- **Documentation Format**: Open Knowledge Format (OKF) v0.2 with mandatory YAML frontmatter
- **Diagram Notation**: UML 2.0 via Mermaid.js
- **AST Tools**: `graphify`, `pyreverse` (pylint backend), Python `ast` module
- **ISO Compliance**: ISO/IEC/IEEE 42010:2022, ISO/IEC/IEEE 15289:2019, ISO/IEC 25010
- **CI/CD**: GitHub Actions with real OKF conformance validation (no mocks)

## Development Workflow

1. **Specification**: Use Spec-Kit to define requirements → `spec.md` → `plan.md` → `tasks.md`
2. **Execution**: Use Superpowers bridge for TDD implementation cycles
3. **Documentation**: Run AST extraction → synthesize OKF pages → validate via CI/CD
4. **Verification**: OKF conformance checker validates frontmatter, relative paths, Mermaid syntax, and provenance fields

## Governance

- This constitution supersedes all informal agreements and ad-hoc practices.
- Amendments require: documentation of rationale, explicit user approval, and migration plan.
- All PRs and reviews must verify compliance with sovereignty boundaries.
- Complexity must be justified; apply YAGNI ruthlessly.
- Use `.github/copilot-instructions.md` Section 3 (Topology of Sovereignty) for runtime development guidance.

**Version**: 1.0.0 | **Ratified**: 2026-07-31 | **Last Amended**: 2026-07-31
