TITLE
Backend API Endpoints and State Transitions

VERSION
0.2

DATE
2026-02-06

OWNER
Nurye Nigus Mekonen

PURPOSE
Define explicit endpoints for orchestration, HITL review, publishing, and metrics ingestion. Include request and response shapes, status transitions, and error handling.

BASE RULES
All external integrations use MCP tools or MCP resources.
These endpoints represent internal services.

COMMON HEADERS
X-Trace-Id string required
Content-Type application/json

STANDARD ERROR SHAPE
{
"error_code": "string",
"message": "string",
"trace_id": "string",
"details": {}
}

ENDPOINTS

Create campaign
POST /v1/campaigns

Request
{
"name": "string",
"goal": "string",
"target_platforms": ["string"],
"budget_cap_etb": 0,
"start_time": "iso8601",
"end_time": "iso8601",
"constraints": {}
}

Response 201
{
"campaign_id": "uuid",
"status": "draft"
}

Errors
400 invalid fields
409 conflicting schedule
401 unauthorized

Start campaign
POST /v1/campaigns/{campaign_id}/start

Response 200
{
"campaign_id": "uuid",
"status": "active"
}

State transition
draft or paused -> active

Pause campaign
POST /v1/campaigns/{campaign_id}/pause

State transition
active -> paused

Planner emit tasks
POST /v1/tasks

Request
Matches specs/technical.md task payload.

Response 201
{
"task_id": "uuid",
"status": "pending"
}

Errors
400 invalid enum
404 campaign missing
429 rate limited

Worker submit result
POST /v1/tasks/{task_id}/results

Request
Matches specs/technical.md worker result payload.

Response 201
{
"review_required": true,
"next": "judge"
}

State transition
in_progress -> review

Judge decision
POST /v1/tasks/{task_id}/judge-decision

Request
Matches specs/technical.md judge decision payload.

Response 200
{
"task_id": "uuid",
"decision": "approve|reject|escalate",
"next_action": "publish|retry|human_review"
}

State transitions
review -> done when approve and publish succeeds
review -> pending when reject and retry
review -> review when escalate to human_review queue

Human review queue list
GET /v1/human-review/queue?status=pending

Response 200
{
"items": [
{
"queue_item_id": "uuid",
"task_id": "uuid",
"artifact_id": "uuid",
"campaign_id": "uuid",
"confidence_score": 0.0,
"judge_reasons": [],
"sensitivity_tags": [],
"created_at": "iso8601"
}
]
}

Human review decision
POST /v1/human-review/{queue_item_id}/decision

Request
{
"decision": "approve|reject",
"edited_content_ref": "string|null",
"notes": "string|null"
}

Response 200
{
"task_id": "uuid",
"next_action": "publish|retry",
"new_artifact_version": 2
}

Rules
If edited_content_ref is provided, create new Artifact version and link lineage in metadata.
Always write AuditLog.

Publish request
POST /v1/publish

Request
{
"campaign_id": "uuid",
"artifact_id": "uuid",
"platform": "string",
"disclosure_level": "automated|assisted|none"
}

Response 202
{
"publish_id": "uuid",
"status": "queued"
}

Publishing rule
Publishing must call an MCP tool. Endpoint does not embed platform credentials.

Metrics ingestion
POST /v1/metrics/batch

Request
{
"source": "mcp_resource",
"events": [ MetricEvent ]
}

Response 202
{
"accepted": 120,
"trace_id": "string"
}

State and reliability
Append only.
Reject invalid events with 400 and include event indices in details.

OPENCLAW AND MOLTBOOK CONTRACTS
OpenClaw status publish
POST /v1/openclaw/status

Request
{
"agent_id": "string",
"availability": "available|busy|offline",
"capabilities": ["string"],
"last_heartbeat": "iso8601"
}

Response 200
{
"published": true
}

MoltBook publish intent
POST /v1/moltbook/posts

Request
{
"platform": "moltbook",
"content_ref": "string",
"tags": ["string"],
"disclosure_level": "automated|assisted|none"
}

Response 201
{
"post_id": "string",
"status": "published"
}

Note
Actual platform interaction still routes via MCP tools.