TITLE
Context Engine Specification

STATUS
Draft. Optional extension of Technical Specification.
No implementation expected in Phase 2.

VERSION
0.1

DATE
2026-02-05

OWNER
Nurye Nigus

---

PURPOSE

Define the Context Engine, the internal “Brain” responsible for assembling, versioning, and serving task-scoped context to Workers and Judges.

This document exists to remove ambiguity around how context is constructed, validated, and audited before implementation begins.

This specification complements, but does not replace:
• specs/_meta.md
• specs/functional.md
• specs/technical.md

---

BACKGROUND AND REFERENCES

This document derives from the following approved specifications:

• Project Chimera Meta Specification
See specs/_meta.md for scope boundaries and traceability rules.

• Functional Requirements
Trend intake, auditability, and HITL routing.
See specs/functional.md, FR-2, FR-5, FR-7, FR-8.

• Technical Requirements
API contracts, data storage guidance, and MCP boundaries.
See specs/technical.md.

---

SCOPE

In scope:

• Definition of a context snapshot and its versioning model
• Skill-facing interface for context access
• Freshness, TTL, and retention defaults
• Sensitivity tagging and HITL routing hooks
• Audit and traceability expectations

Out of scope:

• External connector implementations
• Database-specific optimizations
• Long-term archival strategy beyond defaults

All external data sources are accessed via MCP only.

---

TERMINOLOGY

Context snapshot
A JSON document representing task-scoped information required by a Worker or Judge.

Source link
An mcp:// or https:// URI identifying the origin of a data element.

---

CONTEXT SNAPSHOT SCHEMA
Conceptual JSON schema sketch. Non-executable.

```json
{
  "context_id": "uuid",
  "task_id": "uuid",
  "version": 1,
  "created_at": "iso8601",
  "goal": "string",
  "persona_constraints": ["string"],
  "required_resources": ["mcp://resource"],
  "acceptance_criteria": ["string"],
  "sensitivity_tags": ["string"],
  "sources": ["mcp://resource"],
  "confidence_score": 0.0
}
```

Each update produces a new immutable version.

---

SKILL-FACING INTERFACE
Conceptual contracts. No implementation implied.

1. fetch_context
   Used by Workers and Judges.

Input
• task_id
• required_scope, optional
• freshness_ttl_seconds, optional

Output
• context_snapshot
• served_at timestamp
• trace_id

2. update_context
   Used by Planner or Worker.

Input
• task_id
• partial_context
• source, must be MCP resource

Output
• context_id
• new_version
• trace_id

3. ingest_metrics_batch
   Used by ingestion pipelines only.

Input
• Array of MetricEvent objects
• MCP resource source only

Behavior
• Append-only ingestion
• Batch acknowledgment with trace_id

---

FRESHNESS, TTL, AND RETENTION

• Default trend freshness: 300 seconds
• Context snapshots are immutable
• Metadata retention default: 90 days
• Retention configurable per campaign

Stale context must be explicitly flagged.

---

PRIVACY, SENSITIVITY, AND HITL

• Sensitivity tags propagate with the snapshot
• Any sensitive tag forces human review routing
• PII must be redacted at ingestion time
• Redaction rules are auditable and configurable

This behavior aligns with HITL thresholds in specs/technical.md.

---

AUDIT AND TRACEABILITY

Every read and write must emit an audit record containing:

• trace_id
• actor
• tool or skill name
• inputs hash
• output summary
• timestamp
• context version

Audit records are written via developer MCP tools and referenced by task_id.

---

STORAGE AND SCALING GUIDANCE

• Context snapshots stored in relational system of record
• Metric events stored in append-optimized, time-partitioned store
• Optional vector cache for semantic recall

Workers must never block on ingestion.

---

ACCEPTANCE CRITERIA
Traceable and non-executable.

AC-1
Context snapshot validates against schema and includes required fields.

AC-2
All inputs originate from MCP resources.

AC-3
Freshness TTL is honored or explicitly marked stale.

AC-4
Sensitivity tags trigger HITL routing.

AC-5
Every read and write produces an auditable trace.

Each criterion maps to specs/functional.md and specs/technical.md.

---

RELATION TO OTHER SPECS

This document is an **extension**, not a dependency.

If removed, core system behavior remains fully defined by:
• specs/_meta.md
• specs/functional.md
• specs/technical.md

---

NEXT STEPS

• Optional review and refinement
• Optional TDD tests in Phase 3
• No implementation before spec ratification

---

END OF DOCUMENT

---