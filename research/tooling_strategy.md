TITLE
Tooling Strategy
Project Chimera

Purpose

This document defines the tooling strategy for Project Chimera.
It explicitly separates developer-facing tools from agent runtime skills.

No tooling is selected for convenience.
All tools exist to enforce safety, traceability, and spec alignment.

Guiding Principle

Agents must never have the same tools as developers.

Developers explore, inspect, and modify.
Agents execute narrow, audited actions.

This separation prevents:
• Privilege escalation
• Uncontrolled autonomy
• Irreversible side effects

Developer Tooling (Build-Time)
Objective

Enable humans to design, inspect, and govern the system without embedding logic into agents.

Tooling Category

Developer tooling is allowed to:
• Read and write files
• Inspect repository state
• Log actions
• Provide traceability

These tools are never exposed to runtime agents.

Selected Developer Tools
Tenx MCP Sense

Role:
• System-wide telemetry
• Interaction logging
• Audit trail for agent-assisted development

Rationale:
Provides a “black box recorder” for the development process.
Ensures traceability of decisions and actions.

Filesystem MCP Server

Role:
• Read and write project files
• Assist with spec drafting
• Modify documentation

Rationale:
Allows structured interaction with the repository while keeping changes observable.

Git-Oriented MCP Tooling

Role:
• Inspect commit history
• Assist with structured commits
• Enforce git hygiene

Rationale:
Supports Spec-Driven Development by making repository evolution explicit.

Agent Runtime Skills (Execution-Time)
Objective

Define what Chimera agents are allowed to do at runtime.
Each skill is narrow, auditable, and replaceable.

Agents never “explore”.
They only execute approved capabilities.

Definition of a Skill

A Skill is:
• A single-purpose capability
• With a defined input contract
• With a defined output contract
• With bounded side effects

Skills are not MCP servers.
They may internally call MCP tools, but agents do not see that complexity.

Core Skills Identified
Skill: Trend Fetcher

Purpose:
Retrieve current content trends from external platforms.

Inputs:
• Platform identifier
• Topic category
• Time window

Outputs:
• Normalized trend data structure

Notes:
This skill supports planning decisions only.
It does not publish or act.

Skill: Video Metadata Ingestor

Purpose:
Store high-velocity video metadata for later analysis.

Inputs:
• Video identifier
• Platform metadata
• Timestamp
• Engagement metrics

Outputs:
• Persistent metadata record reference

Notes:
Designed for write-heavy workloads.
Optimized for ingestion, not querying.

Skill: Publish Content

Purpose:
Distribute approved content to external platforms.

Inputs:
• Content payload
• Target platform
• Disclosure flags

Outputs:
• Publication confirmation
• External reference ID

Notes:
Execution is gated by Judge approval.
This skill has irreversible side effects.

Boundary Enforcement

Rules:
• Agents only call Skills
• Skills may call MCP servers
• Agents never call MCP servers directly

This ensures:
• Observability
• Replaceability
• Auditable execution paths

Non-Goals

This document does not define:
• Skill implementation
• Performance optimization
• Vendor selection
• Cost models

Those are deferred until after specification ratification.

Conclusion

This tooling strategy enforces a strict separation between human control and agent autonomy.

By isolating developer tooling from agent skills, Project Chimera maintains:
• Safety
• Traceability
• Scalable governance

This foundation allows future implementation without risking uncontrolled agent behavior.