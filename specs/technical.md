TITLE
Technical Requirements

ARCHITECTURE BOUNDARIES

Agent core logic performs planning and reasoning only.
Agents do not directly access external systems.

All external access occurs exclusively through MCP tools and MCP resources.
This includes social platforms, databases, analytics sources, and storage systems.

The Orchestrator maintains global campaign state and lifecycle control.

Planner, Worker, and Judge are decoupled via task queues to enable parallelism, fault isolation, and retries.

SYSTEM ROLES

Planner Service
Reads campaign goals, constraints, and global state.
Emits discrete, executable tasks with explicit acceptance criteria.

Worker Pool
Executes tasks in isolation.
Produces artifacts and structured outputs without mutating global state.

Judge Service
Validates Worker outputs against policy, confidence thresholds, and acceptance criteria.
Routes results to approval, retry, or Human-in-the-Loop review.

Human Review Service
Presents escalated outputs.
Captures approve, reject, or edit actions without blocking the system.

DATA MODEL OVERVIEW

Core Entities

Campaign
Defines objectives, budget, target platforms, and lifecycle state.

Task
Represents a unit of work emitted by the Planner and executed by a Worker.

Artifact
Represents generated outputs such as text, images, video references, or metrics batches.

ReviewDecision
Captures Judge or Human approval outcomes and rationale.

PublishRecord
Records successful content publication events and platform identifiers.

MetricEvent
Represents time-series engagement data collected post-publication.

DATA STORAGE STRATEGY AND JUSTIFICATION

Relational Database (System of Record)

Used for:
• Campaign
• Task
• ReviewDecision
• PublishRecord

Rationale:
• Strong consistency requirements
• Traceability for governance and audits
• Clear relational constraints between entities

This data changes relatively infrequently but must be correct.

High-Velocity Video Metadata and Metrics Storage

MetricEvent is append-only and write-heavy.

Characteristics:
• High ingestion rate
• Time-series access patterns
• Platform-specific metric schemas
• Late or out-of-order arrivals

Strategy:
• Store MetricEvent in a time-partitioned relational table or a dedicated time-series store
• Partition by observed_at (daily or hourly)
• Use batch ingestion from MCP resources
• Index on (campaign_id, content_id, metric_type, observed_at)

Rationale:
• Enables efficient aggregation over time windows
• Supports replay and backfill
• Maintains analytical consistency
• Avoids overloading transactional tables

Raw metrics are immutable. Aggregations are computed downstream.

Vector Database

Used for:
• Semantic memory
• Persona recall
• Historical interaction embeddings

Rationale:
• Similarity search over long-term experience
• Supports Retrieval-Augmented Generation
• Decoupled from transactional consistency requirements

All access is mediated through MCP.

API CONTRACTS

Task Payload from Planner to Worker
```json
{
  "task_id": "uuid",
  "task_type": "trend_fetch | draft_post | generate_media | publish_post | collect_metrics",
  "priority": "high | medium | low",
  "campaign_id": "uuid",
  "agent_id": "string",
  "context": {
    "goal": "string",
    "persona_constraints": ["string"],
    "required_resources": ["mcp://..."],
    "acceptance_criteria": ["string"]
  },
  "created_at": "iso8601",
  "status": "pending | in_progress | review | done | failed"
}
```

Worker Result Payload to Judge
```json
{
  "task_id": "uuid",
  "agent_id": "string",
  "artifact": {
    "artifact_id": "uuid",
    "artifact_type": "text | image | video | plan | metrics_batch",
    "version": "int",
    "content_ref": "string",
    "metadata": {
      "sources": ["string"],
      "platform": "string",
      "disclosure_level": "automated | assisted | none"
    }
  },
  "confidence_score": 0.0,
  "notes": "string",
  "created_at": "iso8601"
}
```

Judge Decision Payload
```json
{
  "task_id": "uuid",
  "decision": "approve | reject | escalate",
  "reasons": ["string"],
  "policy_hits": ["string"],
  "confidence_score": 0.0,
  "next_action": "publish | retry | human_review",
  "created_at": "iso8601"
}
```

Metric Event Schema for High-Velocity Ingestion
```json
{
  "event_id": "uuid",
  "campaign_id": "uuid",
  "agent_id": "string",
  "content_id": "uuid",
  "platform": "string",
  "metric_type": "views | likes | comments | shares | watch_time_seconds",
  "metric_value": 0,
  "observed_at": "iso8601",
  "ingested_at": "iso8601",
  "source": "mcp_resource"
}
```

HUMAN-IN-THE-LOOP THRESHOLDS

High confidence
Automatically approved.

Medium confidence
Routed to Human Review queue.

Low confidence
Rejected and re-planned.

Sensitive topic override
Any sensitive classification triggers Human Review regardless of confidence.

MCP REQUIREMENTS

All platform actions are executed via MCP tools.

All trend feeds and metrics ingestion occur via MCP resources.

Tool calls include:
• Minimal payload
• Trace identifiers
• Deterministic input hashes

Logs capture:
• Tool name
• Inputs hash
• Outputs summary
• Execution status

This enables observability, auditing, and replay.

NON-FUNCTIONAL REQUIREMENTS

Scalability
Worker pool supports horizontal scaling for parallel task execution.

Latency
High-priority reply workflows target under 10 seconds excluding Human Review.

Reliability
Transient MCP failures trigger bounded retries with exponential backoff.

Observability
Structured logs exist for tasks, decisions, publish records, and metric ingestion.