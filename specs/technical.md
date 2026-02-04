TITLE
Technical Requirements

ARCHITECTURE BOUNDARIES

Agent core logic does planning and reasoning

All external access is via MCP tools and resources

Orchestrator stores global campaign state

Task queues decouple Planner, Worker, Judge

SYSTEM ROLES
Planner service
Reads campaign goals and state. Emits tasks.

Worker pool
Executes tasks. Produces artifacts.

Judge service
Validates outputs. Routes to approve, retry, or human review.

Human review service
Shows queue. Captures approvals and edits.

DATA MODEL OVERVIEW
Entities
Campaign
Task
Artifact
ReviewDecision
PublishRecord
MetricEvent

DATA STORAGE GUIDANCE
Relational store is the system of record for Campaign, Task, ReviewDecision, PublishRecord.
MetricEvent uses append-heavy writes and time-based queries. Use time partitioning and batch ingestion.
Vector store holds semantic memory for persona recall and past interactions.

API CONTRACTS

Task payload from Planner to Worker

##
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
##
Worker result payload to Judge
##
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
##
Judge decision payload

{
  "task_id": "uuid",
  "decision": "approve | reject | escalate",
  "reasons": ["string"],
  "policy_hits": ["string"],
  "confidence_score": 0.0,
  "next_action": "publish | retry | human_review",
  "created_at": "iso8601"
}


Metric event schema for high-velocity ingestion

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
##

HITL THRESHOLDS
High confidence. Auto approve
Medium confidence. Human review
Low confidence. Reject and retry

Sensitive topic override
Any sensitive classification routes to human review even with high confidence.

MCP REQUIREMENTS

All platform actions are MCP tools

All trend feeds and metrics sources are MCP resources

Tool calls include minimal payload plus trace ids

Logs capture tool name, inputs hash, and outputs summary

NON FUNCTIONAL REQUIREMENTS

Scale. Worker pool supports parallel tasks

Latency. High priority reply workflows target under 10 seconds excluding human review

Reliability. Retries for transient MCP failures with capped attempts

Observability. Logs for tasks, decisions, and publish records