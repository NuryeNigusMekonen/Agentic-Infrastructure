TITLE
Acceptance Criteria

VERSION
0.1

DATE
2026-02-06

OWNER
Nurye Nigus Mekonen

PURPOSE
Define testable acceptance criteria in Given, When, Then form.
Each AC references:

Spec source file and section

Endpoint ID from specs/api_endpoints.md

Data entities from specs/db_schema.md
This enables automatic test generation without guessing.

FORMAT
AC-<DOMAIN>-<NUMBER>
References:

Spec: <path>#<section>

Endpoint: <ID>

Data: <Entity>

Campaign lifecycle

AC-CAM-001 Create campaign happy path
References

Spec: specs/functional.md#FR-1 Campaign Creation

Spec: specs/_meta.md#PRIMARY OUTCOMES

Endpoint: API-CAMPAIGN-001

Data: Campaign
Given a valid campaign request with goal, platforms, budget_cap, start_time, end_time
When the operator submits the request to create a campaign
Then a Campaign record is created with status active
And a campaign_id is returned
And an audit record is written with actor, time, and trace_id

AC-CAM-002 Create campaign validation failure
References

Spec: specs/functional.md#FR-1 Campaign Creation

Endpoint: API-CAMPAIGN-001

Data: Campaign
Given a campaign request missing budget_cap or end_time
When the operator submits the request
Then the system rejects the request with a validation error
And no Campaign record is created
And an audit record is written with failure_reason

AC-CAM-003 Pause campaign
References

Spec: specs/functional.md#FR-1 Campaign Creation

Endpoint: API-CAMPAIGN-002

Data: Campaign
Given an active campaign
When the operator pauses the campaign
Then campaign status becomes paused
And Planner stops emitting new tasks for this campaign

Trend intake

AC-TRND-001 MCP only sources
References

Spec: specs/functional.md#FR-2 Trend Intake

Spec: specs/technical.md#MCP REQUIREMENTS

Endpoint: API-TREND-001

Data: Task
Given a trend source that is not an mcp resource URI
When the trend fetch flow runs
Then the system rejects the source
And emits a traceable audit event with the source value

AC-TRND-002 Relevance threshold gating
References

Spec: specs/functional.md#FR-2 Trend Intake

Endpoint: API-TREND-001

Data: Task
Given trend items with computed relevance_score
When relevance_score is below threshold
Then no tasks are created
And the decision is logged with threshold and scores

Task execution and contracts

AC-TASK-001 Task payload contract validation
References

Spec: specs/technical.md#Task payload from Planner to Worker

Endpoint: API-TASK-001

Data: Task
Given a task payload with task_type outside the allowed enum
When the worker receives the task
Then the payload is rejected
And the task is marked failed with reason invalid_enum
And the event is logged with inputs_hash and trace_id

AC-TASK-002 Worker result to Judge happy path
References

Spec: specs/technical.md#Worker result payload to Judge

Endpoint: API-JUDGE-001

Data: Artifact
Given a worker result with artifact metadata, sources, and confidence_score
When the Judge receives the result
Then an Artifact record is created with version 1
And the Judge proceeds to decision evaluation

Judge gate and HITL

AC-JDG-001 Auto approve high confidence
References

Spec: specs/functional.md#FR-4 Judge Review Gate

Spec: specs/technical.md#HITL THRESHOLDS

Endpoint: API-JUDGE-001

Data: ReviewDecision
Given a worker result with high confidence_score and no sensitivity tags
When the Judge evaluates it
Then decision is approve
And next_action is publish
And reasons and trace_id are stored

AC-JDG-002 Escalate on sensitive topic override
References

Spec: specs/functional.md#FR-5 Human Review

Spec: specs/technical.md#HITL THRESHOLDS

Endpoint: API-JUDGE-001

Data: ReviewDecision
Given a worker result with sensitivity_tags containing a sensitive label
When the Judge evaluates it
Then decision is escalate
And next_action is human_review
And the item is added to the review queue

AC-JDG-003 Reject low confidence
References

Spec: specs/technical.md#HITL THRESHOLDS

Endpoint: API-JUDGE-001

Data: ReviewDecision
Given a worker result with low confidence_score
When the Judge evaluates it
Then decision is reject
And next_action is retry
And the retry reason is recorded

Human review console

AC-HITL-001 Queue list performance
References

Spec: specs/human_review_ui.md#NON FUNCTIONAL

Endpoint: API-REVIEW-001

Data: ReviewQueueItem
Given 100 pending items
When the reviewer opens the queue list
Then the system returns results within 2 seconds
And results include the required fields per row

AC-HITL-002 Approve flow and version lineage
References

Spec: specs/functional.md#FR-5 Human Review

Endpoint: API-REVIEW-002

Data: ReviewDecision, Artifact
Given a queued item in status pending
When the reviewer approves without edits
Then status becomes decided
And a ReviewDecision record is created
And the artifact version remains unchanged

AC-HITL-003 Edit and approve creates new version
References

Spec: specs/functional.md#FR-5 Human Review

Endpoint: API-REVIEW-003

Data: Artifact
Given a queued item
When the reviewer edits content and approves
Then a new artifact version is created with lineage to previous version
And the decision references the new artifact version

AC-HITL-004 Block approve if content_ref missing
References

Spec: specs/human_review_ui.md#ERROR STATES

Endpoint: API-REVIEW-003

Data: Artifact
Given a queued item with missing content_ref
When the reviewer attempts approve
Then the system blocks approval
And allows reject with an explicit reason

Publishing

AC-PUB-001 Publish uses MCP tool calls only
References

Spec: specs/functional.md#FR-6 Publishing

Spec: specs/technical.md#MCP REQUIREMENTS

Endpoint: API-PUBLISH-001

Data: PublishRecord
Given an approved artifact
When the publish step runs
Then the action is performed via an MCP tool call
And the PublishRecord stores platform_post_id, timestamp, disclosure_level, and trace_id

High velocity metrics ingestion

AC-MET-001 Append only ingestion does not block workers
References

Spec: specs/functional.md#FR-7 High-Velocity Video Metadata Ingestion

Spec: specs/technical.md#Metric event schema for high-velocity ingestion

Endpoint: API-METRICS-001

Data: MetricEvent
Given a batch of MetricEvent records
When ingestion runs
Then the system acknowledges ingestion with ingested_count
And worker task execution is not blocked by ingestion

AC-MET-002 Time based aggregation support
References

Spec: specs/functional.md#FR-7 High-Velocity Video Metadata Ingestion

Endpoint: API-METRICS-002

Data: MetricEvent
Given MetricEvent records over time for a campaign and content_id
When an aggregation query runs for a time window
Then results return aggregated metrics grouped by campaign_id and content_id

Audit and traceability

AC-AUD-001 Every task has traceable chain
References

Spec: specs/functional.md#FR-8 Audit and Traceability

Spec: specs/technical.md#MCP REQUIREMENTS

Endpoint: API-AUDIT-001

Data: AuditLog
Given any task lifecycle from creation to publish
When viewing audit logs by task_id
Then logs include inputs_hash, output_summary, actor, tool_name, timestamp, and trace_id

Add a quick mapping note to README