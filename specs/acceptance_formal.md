TITLE
Formal Acceptance Criteria

VERSION
0.1

DATE
2026-02-06

OWNER
Nurye Nigus Mekonen

FORMAT
Given, When, Then

LINKING RULE
Each scenario references a spec ID.
Example
FR-7 from specs/functional.md
API-10 from specs/api_endpoints.md

SCENARIOS

AC-FR1-01 Campaign creation
Given an operator has a valid JWT with role operator
When they POST /v1/campaigns with goal, platforms, and budget
Then the system returns 201 with campaign_id and status draft
And an AuditLog record is created for entity campaign with action create

AC-FR2-01 Trend intake MCP only
Given the planner receives a trend source
When the source is not an mcp resource uri
Then the system rejects the task creation with 400
And the AuditLog severity is warning

AC-FR4-01 Judge gate decision shape
Given a task is in status review
When the judge posts a decision payload
Then the decision is stored with reviewer_type judge
And task status transitions based on next_action

AC-FR5-01 Human review escalation
Given a task has sensitivity_tags present
When the judge decision is escalate with next_action human_review
Then the item appears in GET /v1/human-review/queue status pending

AC-FR7-01 Metric ingestion throughput constraint
Given the metrics service posts a batch of 2000 events
When events validate against MetricEvent schema
Then the system returns 202 accepted 2000
And Worker tasks are not blocked by ingestion
And p95 ingest response time target is under 2 seconds under normal load

AC-FR8-01 Traceability
Given any endpoint is called with X-Trace-Id
When the request completes
Then AuditLog contains the same trace_id and actor_type
And entity_id references the created or updated entity