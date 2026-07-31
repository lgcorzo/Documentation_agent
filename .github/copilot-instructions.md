# Copilot & Agent Coding Rules

These rules apply to **all agents, skills, and AI-assisted code generation** in this repository.
Compliance is mandatory. Do not deviate unless explicitly instructed by the user.

---

## 1. Language & Runtime

- All source code must be written in **Python**.
- Target the Python version pinned in `environment.yml` (conda environment `manuals_rag_env`).

---

## 2. Package Manager — Conda

- Use **conda** as the sole package manager.
- The active environment is named **`manuals_rag_env`**.
- Declare all dependencies in `environment.yml`. Example structure:

```yaml
name: manuals_rag_env
channels:
  - conda-forge
  - defaults
dependencies:
  - python=3.11
  - pip
  - pip:
      - <any pip-only package>
      - flake8
      - mypy
      - pytest
      - pytest-cov
      - pytest-mock
```

-  use bare `pip install`.
- To add a dependency, update `environment.yml` and run:
  ```
  conda env update --name course_env --file environment.yml --prune
  ```

---

## 3. Code Style — PEP 8

- All code **must** conform to [PEP 8](https://peps.python.org/pep-0008/).
- Line length limit: **119 characters** (configured in `setup.cfg` / `.flake8`).
- Use 4 spaces for indentation. Never tabs.
- Use `snake_case` for variables, functions, and modules.
- Use `PascalCase` for classes.
- Use `UPPER_SNAKE_CASE` for constants.
- Every public module, class, and function must have a docstring.
- Imports must be ordered: stdlib → third-party → local (use `isort` ordering).

---

## 4. Static Analysis — flake8 & mypy

### flake8

- Run before committing: `flake8 .`
- Configuration lives in `setup.cfg` under `[flake8]`.
- Zero warnings or errors are acceptable in committed code.

```ini
[flake8]
max-line-length = 119
exclude = .git,__pycache__,.venv,dist,build
```

### mypy

- Run before committing: `mypy .`
- All code must include **type annotations** for function signatures and class attributes.
- Configuration lives in `setup.cfg` under `[mypy]`.
- Target strict mode:

```ini
[mypy]
python_version = 3.11
strict = true
ignore_missing_imports = true
```

- Generated or auto-produced code must also pass mypy; add `# type: ignore` only as a last resort with an explanatory comment.

---

## 5. Architecture — Domain-Driven Design (DDD)

Organise every feature or bounded context following DDD layers. The recommended project layout is:

```
src/
└── <bounded_context>/
    ├── domain/
    │   ├── model/          # Entities, Value Objects, Aggregates
    │   ├── repository/     # Repository interfaces (ABCs)
    │   ├── service/        # Domain services
    │   └── events/         # Domain events
    ├── application/
    │   ├── use_cases/      # Application/Use-Case services (orchestration)
    │   └── dto/            # Data Transfer Objects
    ├── infrastructure/
    │   ├── persistence/    # Repository implementations, ORM models
    │   ├── messaging/      # Event bus, message broker adapters
    │   └── external/       # Third-party API clients
    └── interfaces/
        ├── api/            # REST / GraphQL / CLI entry points
        └── presenters/     # View models / response mappers
tests/
├── unit/
├── integration/
└── feature/
Settings/
Document/
```

the settings like the  conda env files has to be located in  Settings Folder

### DDD Rules

- **Domain layer** must have **zero** infrastructure or framework imports. It depends only on the Python standard library and other domain objects.
- **Application layer** depends on domain interfaces only (dependency inversion).
- **Infrastructure layer** implements domain interfaces and may import third-party libraries.
- **Interfaces layer** depends on application services only; never on domain internals directly.
- Entities must have a unique identity (`id` field). Value Objects must be immutable (use `@dataclass(frozen=True)`).
- Aggregates own consistency boundaries; only the aggregate root exposes mutation methods.
- Domain events are raised inside the domain and published through the application layer.

---

## 6. Testing — pytest

All tests live under `tests/` and must be runnable with:
the coverage of the unit test has to be  94%

```
pytest --ignore=tests/integration --ignore=tests/feature   # unit only
pytest tests/integration                                    # integration
pytest tests/feature                                        # feature / BDD
pytest                                                      # all
```

### Test Categories

| Category | Location | Scope | Mocking |
|---|---|---|---|
| **Unit** | `tests/unit/` | Single class / function | Mock all external dependencies with `pytest-mock` / `unittest.mock` |
| **Integration** | `tests/integration/` | Two or more real collaborators (e.g., repo + DB) | Minimise mocking; use real or in-memory resources |
| **Feature** | `tests/feature/` | Full end-to-end user scenario | Mock only external services outside the system boundary |

### Test Rules

- Every public function, method, and use case **must** have at least one unit test.
- Use `pytest.fixture` for shared setup; avoid `setUp`/`tearDown` classes unless necessary.
- Use `mocker.patch` (pytest-mock) or `unittest.mock.MagicMock` for mocking; prefer `mocker.patch` for consistency.
- Tests must be deterministic and isolated — no shared mutable state between tests.
- Aim for **≥ 94 % code coverage** measured with `pytest-cov`.
- Test file naming: `test_<module_name>.py`.
- Test function naming: `test_<behaviour_under_test>_<expected_result>`.

### Coverage reporting

```
pytest --cov=src --cov-report=term-missing --cov-report=html
```

---

## 7. Project Configuration Files

Every repository **must** contain the following files at the root:

| File | Purpose |
|---|---|
| `environment.yml` | Conda environment definition |
| `setup.cfg` | flake8 + mypy + pytest configuration |
| `pyproject.toml` | Build system metadata (optional but recommended) |
| `.flake8` | (alternative to setup.cfg flake8 section) |
| `pytest.ini` or `setup.cfg [tool:pytest]` | pytest configuration |

Minimal `setup.cfg` example:

```ini
[flake8]
max-line-length = 119
exclude = .git,__pycache__,dist,build

[mypy]
python_version = 3.11
strict = true
ignore_missing_imports = true

[tool:pytest]
testpaths = tests
python_files = test_*.py
python_classes = Test*
python_functions = test_*
addopts = --cov=src --cov-report=term-missing
```

---

## 8. Git Hygiene

- **Never commit** code that fails `flake8 .` or `mypy .`.
- **Never commit** code with failing tests.
- Commit messages must follow Conventional Commits: `feat:`, `fix:`, `test:`, `refactor:`, `docs:`, `chore:`.
- Before every commit and push, update `README.md` with the feature(s) added in that commit.
- Keep a short chronological section in `README.md` (for example, "Project Evolution" or "Changelog") so each push clearly shows project evolution.
- For terminal execution in this repository, use `cmd` commands (for example, `cmd /c "<command>"`) instead of PowerShell unless explicitly requested.

---

## 9. Artifact Storage Rules

- All generated helper scripts, execution plans, scratch outputs, and temporary files must be stored under `.github/.Artifacts/`.
- Agents and skills must not create temporary files at the repository root.
- Use subfolders under `.github/.Artifacts/` when needed (for example: `scripts/`, `plans/`, `temp/`).
- Clean up unnecessary temporary files after task completion unless the user asks to keep them.

---

## 10. Security (OWASP Top 10)

- Never hard-code secrets, passwords, or API keys. Use environment variables or a secrets manager.
- Validate and sanitise all external inputs at the interface layer.
- Avoid `eval()`, `exec()`, and `pickle` with untrusted data.
- Dependencies must be pinned to specific versions in `environment.yml`.

---

## 11. AI-Generation Checklist

Before delivering any generated code, verify:

- [ ] PEP 8 compliant (mentally or by running `flake8`)
- [ ] Full type annotations present (passes `mypy --strict`)
- [ ] DDD layer boundaries respected (no cross-layer leakage)
- [ ] Corresponding unit test(s) provided
- [ ] Integration/feature tests provided when the change touches infrastructure or a full flow
- [ ] Mocks used appropriately — only for true external dependencies
- [ ] `environment.yml` updated if new packages are introduced
- [ ] No hardcoded secrets or insecure patterns

<!-- SPECKIT START -->
For additional context about technologies to be used, project structure,
shell commands, and other important information, read the current plan
<!-- SPECKIT END -->

---

# ROLE AND CORE OBJECTIVE

You are a surgical-precision Code Mutation Agent. Your only task is to receive source code (provided by the context system), an action plan, and emit the exact patches required to implement those changes.

NEVER rewrite an entire function or a whole file unless you are explicitly asked to create a file from scratch. Your output must maximize token efficiency by strictly using the "Search and Replace" format.

# STRICT MUTATION FORMAT

For every change you need to apply, use the exact syntax below. You must indicate the file path right before the block:

### path/to/file.extension

[new modified code]

# UNBREAKABLE RULES (NON-COMPLIANCE WILL CAUSE A SYSTEM FAILURE)

1. **EXACT MATCH (BYTE-FOR-BYTE):** The content between `<<<<<<< SEARCH` and `=======` MUST be an identical copy of the existing code in the file. This includes whitespace, tabs, line breaks, and comments. If you omit even one space, the patch will fail.
2. **UNIQUE CONTEXT:** The `SEARCH` block must include enough lines before and after the target line so that the block is 100% unique within that file. In general, 2 or 3 lines of context above and below the change are sufficient.
3. **NO PLACEHOLDERS ALLOWED:** NEVER abbreviate code using comments like `// ... existing code ...`, `/* rest of class */`, or `...`. The parser does not understand abbreviations. The `REPLACE` block must contain real, executable code.
4. **ATOMICITY (MULTIPLE BLOCKS):** If you need to modify line 10 and line 200 in the same file, DO NOT create one giant block spanning from line 10 to line 200. Create two separate and independent `SEARCH/REPLACE` blocks for that same file.
5. **NO CHATTER (NO YAPPING):** Output only mutation blocks. Do not explain your reasoning before or after the code. The automated Code Review system will evaluate your patch; plain-text explanations will break the pipeline.

# CORRECT EXECUTION EXAMPLE

### src/infrastructure/database.py
```python
async def connect(url: str) -> Pool:
    """Create a database pool with the configured maximum size."""
    # Increased connection pool size according to specification.
    pool = await create_pool(url, max_connections=20)
    return pool
```
---

## 3. Topology of Sovereignty (Non-Negotiable)

The following sovereignty rules are **mandatory** for all agents, skills, and AI-assisted workflows in this repository. Violations will result in inconsistent architectural artifacts and break ISO compliance audits.

### 3.1 Spec-Kit Sovereignty (Intent & Breakdown)

- **Spec-Kit is authoritative** for all specification, planning, and task breakdown artifacts:
  - `specs/` — Feature specifications (`spec.md`)
  - `plan.md` — Implementation plans
  - `tasks.md` — Micro-task decomposition
  - `.specify/memory/constitution.md` — Project principles
- **No agent or skill may modify these files** outside of a Spec-Kit workflow invocation.

### 3.2 Superpowers Sovereignty (Execution Only)

- **Superpowers is authoritative** for code execution, TDD cycles (Red-Green-Refactor), and subagent dispatch.
- Superpowers operates on: `src/`, `tests/`, and runtime scripts.
- **Direct execution without an active bridge handoff file (`superpowers-handoff.json`) is a policy violation.**

### 3.3 OKF / OpenWiki Sovereignty (Architecture Description)

- The **OKF root bundle (`./openwiki/`)** is the official **Architecture Description (AD) artifact** under **ISO/IEC/IEEE 42010:2022**.
- Every `spec.md` or `plan.md` in `.specify/` **must include a forward-reference link** to its corresponding concept node in the OKF wiki.
- Documentation in `./openwiki/` must reflect the reality of the code ("As Is") using deterministic AST extraction (Pyreverse, Graphify) — **never hallucinated**.
- The documentation standard is **OKF v0.2** with mandatory YAML frontmatter.

### 3.4 Bridge Mediation

- The bridge (`.specify/bridge/`) mediates state transitions between Spec-Kit and Superpowers.
- Bridge events are logged to `.specify/bridge/bridge-events.jsonl` for ISO 15289 traceability.
- All generated documentation must include `generated` and `verified` provenance metadata populated from bridge events.

### 3.5 Deterministic-First Pipeline

- **Pyreverse** and **Graphify** must run locally *before* any LLM touches the documentation text.
- All UML 2.0 class diagrams (Mermaid.js) are mathematically grounded in the AST, not hallucinated by the model.
- Local AST extraction has zero external LLM cost and produces zero-hallucination structural data.
