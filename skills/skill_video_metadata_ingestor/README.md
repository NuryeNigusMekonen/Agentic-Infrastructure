TITLE
Skill Video Metadata Ingestor

PURPOSE
Ingest high-velocity video and social metrics as append-only events.

INPUTS
campaign_id
agent_id
content_id
platform
metric_events, list of events
batch_size

OUTPUTS
ingest_result with counts and time range

OUTPUT SCHEMA

{
  "campaign_id": "uuid",
  "content_id": "uuid",
  "platform": "string",
  "received_count": 0,
  "written_count": 0,
  "window_start": "iso8601",
  "window_end": "iso8601"
}


DATA NOTES
Writes are append-heavy. Use batch ingestion. Use time partitioned storage on the database side.

FAILURE MODES

MCP tool failure on write

Partial write

Duplicate events

Clock skew in timestamps