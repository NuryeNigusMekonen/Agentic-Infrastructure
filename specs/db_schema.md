TITLE
Database Schema and Lifecycle

VERSION
0.2

DATE
2026-02-06

OWNER
Nurye Nigus Mekonen

PURPOSE
Define explicit relational schemas, constraints, and lifecycle flows so an agent can generate migrations without guessing. Define MetricEvent and AuditLog with full detail.

SCOPE
In scope
Relational schema for core entities
Relationships and constraints
Indexing and partitioning guidance
Lifecycle flows: ingestion, archiving, deletions
Migration and versioning strategy

Out of scope
Vendor specific DDL for a specific cloud provider
Physical sharding plans beyond partitioning guidance

ASSUMPTIONS
Primary relational store is Postgres compatible.
Time series writes for MetricEvent are high frequency.

ENTITY LIST
Campaign
Agent
Task
Artifact
ReviewDecision
PublishRecord
MetricEvent
AuditLog

RELATIONSHIPS ERD
Mermaid ERD

erDiagram
  CAMPAIGN ||--o{ TASK : generates
  CAMPAIGN ||--o{ PUBLISH_RECORD : publishes
  CAMPAIGN ||--o{ METRIC_EVENT : measures
  AGENT ||--o{ TASK : executes
  TASK ||--o{ ARTIFACT : produces
  TASK ||--o{ REVIEW_DECISION : results_in
  ARTIFACT ||--o{ REVIEW_DECISION : reviewed_by
  ARTIFACT ||--o{ PUBLISH_RECORD : published_as
  TASK ||--o{ AUDIT_LOG : traced_by
  ARTIFACT ||--o{ AUDIT_LOG : traced_by


TABLE SCHEMAS
Conventions
All IDs are UUID.
Timestamps are timestamptz.
All tables include created_at and updated_at.
Soft delete uses deleted_at timestamptz where applicable.

campaign
Fields
campaign_id uuid primary key
name text not null
goal text not null
target_platforms jsonb not null
budget_cap_etb numeric(12,2) not null check budget_cap_etb >= 0
start_time timestamptz null
end_time timestamptz null
status text not null check status in (draft, active, paused, stopped, completed)
constraints jsonb null
created_at timestamptz not null default now()
updated_at timestamptz not null default now()

Indexes
idx_campaign_status on status
idx_campaign_time on start_time, end_time

agent
Fields
agent_id text primary key
display_name text null
persona_ref text null
status text not null check status in (active, suspended, retired)
created_at timestamptz not null default now()
updated_at timestamptz not null default now()

task
Fields
task_id uuid primary key
campaign_id uuid not null references campaign(campaign_id)
agent_id text not null references agent(agent_id)
task_type text not null check task_type in (trend_fetch, draft_post, generate_media, publish_post, collect_metrics)
priority text not null check priority in (high, medium, low)
status text not null check status in (pending, in_progress, review, done, failed)
context jsonb not null
attempt int not null default 0 check attempt >= 0
max_attempts int not null default 3 check max_attempts >= 0
parent_task_id uuid null references task(task_id)
created_at timestamptz not null default now()
updated_at timestamptz not null default now()

Constraints
Unique constraint optional by design. Duplicate tasks are allowed for retries, tracked by attempt and parent_task_id.

Indexes
idx_task_campaign on campaign_id
idx_task_agent on agent_id
idx_task_status on status
idx_task_type_status on task_type, status
idx_task_created on created_at

artifact
Fields
artifact_id uuid primary key
task_id uuid not null references task(task_id)
campaign_id uuid not null references campaign(campaign_id)
artifact_type text not null check artifact_type in (text, image, video, plan, metrics_batch)
version int not null check version >= 1
content_ref text not null
metadata jsonb null
sources jsonb null
created_at timestamptz not null default now()

Constraints
unique(task_id, artifact_type, version)

Indexes
idx_artifact_task on task_id
idx_artifact_campaign on campaign_id
idx_artifact_type on artifact_type

review_decision
Fields
review_id uuid primary key
task_id uuid not null references task(task_id)
artifact_id uuid not null references artifact(artifact_id)
decision text not null check decision in (approve, reject, escalate)
confidence_score numeric(4,3) not null check confidence_score >= 0 and confidence_score <= 1
reasons jsonb not null
policy_hits jsonb null
next_action text not null check next_action in (publish, retry, human_review)
reviewer_type text not null check reviewer_type in (judge, human)
reviewer_id text null
created_at timestamptz not null default now()

Indexes
idx_review_task on task_id
idx_review_artifact on artifact_id
idx_review_decision on decision
idx_review_reviewer_type on reviewer_type

publish_record
Fields
publish_id uuid primary key
campaign_id uuid not null references campaign(campaign_id)
artifact_id uuid not null references artifact(artifact_id)
platform text not null
platform_post_id text null
disclosure_level text not null check disclosure_level in (automated, assisted, none)
status text not null check status in (queued, published, failed)
published_at timestamptz null
created_at timestamptz not null default now()

Indexes
idx_publish_campaign on campaign_id
idx_publish_platform on platform
idx_publish_status on status
idx_publish_time on published_at

metric_event
Goal
High velocity append. Time based aggregations.

Fields
event_id uuid primary key
campaign_id uuid not null references campaign(campaign_id)
agent_id text not null references agent(agent_id)
content_id uuid not null references artifact(artifact_id)
platform text not null
metric_type text not null check metric_type in (views, likes, comments, shares, watch_time_seconds)
metric_value bigint not null check metric_value >= 0
observed_at timestamptz not null
ingested_at timestamptz not null default now()
source text not null

Partitioning
Partition by range on observed_at, monthly partitions.

Indexes
idx_metric_campaign_time on campaign_id, observed_at
idx_metric_content_time on content_id, observed_at
idx_metric_platform_type_time on platform, metric_type, observed_at

Retention and archiving
Default retention 180 days in hot store.
Archive older partitions to cold storage monthly.

audit_log
Goal
Traceability for every significant read or write.

Fields
audit_id uuid primary key
trace_id text not null
actor_type text not null check actor_type in (planner, worker, judge, human, system)
actor_id text null
entity_type text not null check entity_type in (task, artifact, review_decision, publish_record, metric_event, context_snapshot)
entity_id text not null
action text not null
tool_name text null
inputs_hash text null
output_summary text null
severity text not null check severity in (info, warning, error)
created_at timestamptz not null default now()

Indexes
idx_audit_trace on trace_id
idx_audit_entity on entity_type, entity_id
idx_audit_time on created_at
idx_audit_actor on actor_type, actor_id

MIGRATIONS AND VERSIONING STRATEGY
Migration tool
Alembic style approach or equivalent.
One migration per schema change.
Schema version recorded in a single table.

schema_migrations table
version text primary key
applied_at timestamptz not null default now()

Rules
Migrations are forward only for production.
Down migrations optional for local dev only.
Breaking changes require a compatibility period:
Add new columns nullable.
Backfill.
Switch reads.
Enforce constraints last.

LIFECYCLE FLOWS
Ingestion
Planner creates Task rows.
Worker produces Artifact rows.
Judge creates ReviewDecision rows.
Publish creates PublishRecord rows.
Metrics pipeline appends MetricEvent rows.
All steps emit AuditLog rows linked by trace_id.

Deletions
Hard deletes are forbidden for auditability.
Use deleted_at on campaign and task if needed.
Metric partitions expire by retention policy and are archived, not deleted, unless contract requires deletion.

PII
Avoid storing direct PII in relational tables.
If required, store redacted fields only and record redaction version in AuditLog.