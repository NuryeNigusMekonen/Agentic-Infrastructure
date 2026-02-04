# Architecture Strategy - Project Chimera
## Purpose
This document defines the high-level architectural direction for Project Chimera.
No implementation decisions are made here.
This file exists to remove ambiguity before agent-driven development begins.

## Market and Ecosystem Context
Project Chimera operates in the emerging Agent Social Network landscape.
Projects like OpenClaw and MoltBook demonstrate agents acting as autonomous social participants.
Chimera differs by focusing on goal-directed influencer agents with governance, memory, and economic constraints.

Chimera agents are not chat assistants.
They are persistent entities with identity, memory, and operational budgets.

## Agent Interaction Model
Chimera agents must communicate with:
• Humans via social platforms
• Platforms via MCP servers
• Other agents via standardized protocols

Future inter-agent communication should rely on published availability, status, and capability metadata.
Direct peer-to-peer coupling is intentionally avoided.

## Selected Agent Pattern
Chosen pattern: Hierarchical Swarm (Planner, Worker, Judge)

Rationale:
• Planner decomposes goals into tasks
• Workers execute isolated actions
• Judges enforce quality, safety, and policy

This pattern supports scale, fault isolation, and human-in-the-loop governance.

## Human-in-the-Loop Strategy
Human review is enforced at the Judge layer.
Escalation is based on confidence thresholds and topic sensitivity.
Humans approve, reject, or edit outputs without blocking the entire swarm.

This preserves velocity while maintaining safety.

## Data Storage Strategy
Relational Database:
Used for campaigns, tasks, audit logs, and financial records.
Rationale: strong consistency, traceability, compliance.

Vector Database:
Used for semantic memory and persona recall.
Rationale: similarity search over long-term experiences.

Both stores are accessed through MCP servers only.

## MCP Boundary
All external systems are accessed exclusively via MCP.
Agents never call APIs directly.
This ensures observability, replaceability, and auditability.

## Non-Goals
This document does not define:
• Exact APIs
• Database schemas
• Implementation details
• Model choices

Those belong in the specification phase.
