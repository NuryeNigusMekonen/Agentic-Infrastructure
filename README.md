# Project Chimera

Agentic Infrastructure Challenge - Forward Deployed Engineer (FDE) Trainee

## Overview

Project Chimera is an agentic infrastructure designed to build **autonomous influencer systems** in a controlled, auditable, and scalable way.

This repository does **not** implement influencer behavior.
It defines the **factory** that allows AI agents to build those behaviors safely.

The focus is on:

* Spec-Driven Development
* Agent orchestration
* Tool and skill boundaries
* Test-driven governance
* CI/CD discipline

Intent is the source of truth. Infrastructure enforces it.

---

## Core Principles

### Spec-Driven Development (SDD)

All behavior is defined in specifications before any implementation exists.
Specs are authoritative. Code must trace back to them.

### Agent Governance

Agents operate under explicit roles:

* Planner
* Worker
* Judge

Human-in-the-loop review is enforced for sensitive or low-confidence outputs.

### Skills vs Tools

* **Skills** are internal, reusable agent capabilities with strict contracts.
* **Tools** are external integrations accessed only through MCP.

Agents never call external systems directly.

### Traceability

Every decision, task, and artifact is traceable via:

* Specs
* Logs
* Tests
* CI execution

---

## Repository Structure

```
specs/        Authoritative intent and contracts
research/     Architectural and tooling strategy
skills/       Runtime skill interfaces (no implementations)
tests/        Test-driven definitions of expected behavior
docs/         Runbooks and supporting documentation
artifacts/    Logs and execution evidence
.github/      CI workflows and governance
.vscode/      IDE agent rules and MCP configuration
```

---

## Specifications

The `specs/` directory defines the system blueprint:

* `_meta.md`
  Vision, constraints, success criteria, and risks

* `functional.md`
  User stories and acceptance criteria

* `technical.md`
  API contracts, data models, non-functional requirements

* `context_engine.md`
  Context normalization and task-scoped reasoning interface

* `openclaw_integration.md`
  Agent social network integration strategy

No implementation is allowed without spec alignment.

---

## Skills

The `skills/` directory contains **scaffolded runtime skills**.

Each skill:

* Is a Python package
* Exposes a `run(payload)` entrypoint
* Documents its input and output contract
* Contains no business logic yet

Skills are intentionally minimal to support TDD and prevent premature coupling.

---

## Testing Strategy

Tests define the **expected shape of the system** before it exists.

Current tests verify:

* Skill interfaces exist and are importable
* Entry points conform to contracts
* Future agent behavior has clear goalposts

Passing tests confirm infrastructure correctness, not feature completeness.

---

## Tooling and Automation

* Python environment managed with `uv`
* Docker encapsulates execution environment
* Makefile standardizes workflows
* GitHub Actions runs CI on every push

CI builds the container and runs tests to enforce discipline.

---

## MCP and Observability

The Tenx MCP Sense server is connected during development to capture:

* Agent interactions
* Decision flow
* Tool usage

MCP provides observability without contaminating agent logic.

---

## Status

This repository is **ready for agent-driven implementation**.

All foundations are in place:

* Specs ratified
* Skills defined
* Tests passing
* CI green
* Governance enforced

Implementation will begin only after explicit approval.

---

## Author

Nurye Nigus Mekonen
Forward Deployed Engineer Trainee
Agentic Infrastructure Challenge

---
## loom video recoreded 
https://www.loom.com/share/7f36499ebeac44969fbbe49a6a3705bb