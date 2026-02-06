Project Chimera
Agentic Infrastructure Challenge
Forward Deployed Engineer Trainee

## Overview

Project Chimera is an **agentic infrastructure** designed to build autonomous influencer systems in a **controlled, auditable, and scalable** way.

This repository does **not** implement influencer behavior.

Instead, it defines the **factory and governance layer** that enables AI agents to safely research, plan, generate, review, and publish content once implementation begins.

The primary objective is to demonstrate:

* Spec-Driven Development
* Agent orchestration and governance
* Clear separation of skills, tools, and intent
* Test-Driven Development before implementation
* Production-grade CI/CD and containerization

Intent is the source of truth. Infrastructure enforces it.

---

## Core Principles

### Spec-Driven Development

All system behavior is defined in specifications **before** any implementation exists.

* Specs are authoritative
* Code must trace back to specs
* Tests are written against specs, not features

This prevents ambiguity, hallucination, and ungoverned agent behavior.

---

### Agent Governance Model

Agents operate under explicit, enforced roles:

* Planner. Decomposes goals into tasks
* Worker. Executes a single atomic task
* Judge. Validates outputs against policy and quality gates

Human-in-the-Loop review is mandatory for:

* Low confidence outputs
* Sensitive topics
* Policy-flagged content

---

### Skills vs Tools Boundary

* **Skills** are internal, reusable agent capabilities with strict input and output contracts
* **Tools** are external integrations accessed only through MCP servers

Agents are **not allowed** to call external APIs directly.

This boundary enforces security, auditability, and repeatability.

---

### Traceability and Auditability

Every decision and artifact is traceable through:

* Specifications
* Tests
* Logs
* CI execution
* MCP telemetry

This enables post-hoc analysis, debugging, and governance.

---

## Repository Structure

```
specs/        System intent, contracts, and constraints
research/     Architectural reasoning and tooling strategy
skills/       Runtime skill interfaces (no business logic)
tests/        Test-Driven definitions of expected behavior
docs/         Runbooks and evaluation documentation
artifacts/    Logs, execution evidence, and MCP traces
.github/      CI/CD workflows and governance
.vscode/      IDE agent rules and MCP configuration
```

Each directory exists to satisfy a specific governance or scalability requirement.

---

## Specifications

The `specs/` directory is the **single source of truth**.

* `_meta.md`
  Vision, constraints, success criteria, risks, and glossary

* `functional.md`
  User stories and acceptance criteria for agent behavior

* `technical.md`
  API contracts, data models, non-functional requirements, and storage guidance

* `context_engine.md`
  Context normalization, task-scoped reasoning, freshness rules, and audit hooks

* `openclaw_integration.md`
  Strategy for agent discovery and participation in agent social networks

No implementation is permitted unless it maps directly to these specs.

---

## Skills Architecture

The `skills/` directory contains **scaffolded runtime skills**.

Each skill:

* Is a Python package
* Exposes a `run(payload: dict) -> dict` entrypoint
* Documents its contract in a README
* Contains **no implementation logic**

This is intentional.

The goal is to define **clear interfaces first**, enabling agents to later fill in logic without ambiguity.

---

## Testing Strategy

This project follows **true Test-Driven Development**.

Tests are written **before implementation** to define the system’s expected shape.

Current tests validate:

* Skill modules are importable
* Entry points exist and match contracts
* Agent interfaces align with specs

Passing tests confirm infrastructure correctness, not feature completeness.

Failing tests historically demonstrated the “empty slot” agents are expected to fill.

---

## Backend, Data, and Frontend Scope Clarification

This challenge evaluates **infrastructure readiness**, not feature delivery.

* Backend behavior is specified via API contracts and agent roles
* Data models and storage strategy are defined in specs
* Frontend concerns are intentionally deferred until agent workflows are implemented

This aligns with Spec-Driven Development and prevents premature coupling.

---

## Tooling, Automation, and CI/CD

* Python environment managed using `uv`
* Docker encapsulates the runtime environment
* Makefile standardizes repeatable workflows
* GitHub Actions runs CI on every push

CI performs:

* Container build
* Test execution
* Governance enforcement

---

## MCP and Observability

Tenx MCP Sense is connected during development to capture:

* Agent interactions
* Decision flow
* Tool usage
* Reasoning traces

This provides observability without polluting agent logic.

---

## Status

This repository is **implementation-ready**.

All foundations are complete:

* Specifications ratified
* Skills defined
* Tests passing
* CI green
* Containerization complete
* Governance enforced

Implementation will begin only after explicit approval.

---

## Loom Walkthrough

A recorded walkthrough demonstrating:

* Spec structure
* CI passing
* TDD approach
* Skills vs Tools separation
* IDE agent context

[https://www.loom.com/share/7f36499ebeac44969fbbe49a6a3705bb](https://www.loom.com/share/7f36499ebeac44969fbbe49a6a3705bb)

---

## Author

Nurye Nigus Mekonen
Forward Deployed Engineer Trainee
Agentic Infrastructure Challenge

---
