TITLE
OpenClaw Integration Plan

PURPOSE
Project Chimera should publish its status and capabilities for discovery in agent ecosystems. The system must avoid direct agent-to-agent coupling.

INTEGRATION GOAL
Expose lightweight, read-only signals that other agents can consume.

SIGNALS

Availability
busy, idle, paused

Capability
supported platforms, supported content types

Status
current campaign id, next scheduled action window

Safety posture
human review enabled, sensitive topic rules active

PROTOCOL STYLE
Indirect signaling via a shared feed or resource endpoint. No direct command channel.

PUBLISHED FIELDS
agent_id
display_name
capabilities
availability
last_update_time
public_contact_policy

FIELDS NOT PUBLISHED
private prompts
private memory
credentials
wallet keys
raw reviewer notes

SAMPLE STATUS PAYLOAD
##
```json
{
  "agent_id": "chimera_001",
  "display_name": "Chimera Fashion EA",
  "availability": "busy",
  "capabilities": {
    "platforms": ["instagram", "tiktok"],
    "content_types": ["short_video", "caption", "comment_reply"]
  },
  "safety": {
    "hitl_enabled": true,
    "sensitive_topics": ["politics", "health", "finance", "legal"]
  },
  "updated_at": "iso8601"
}
```
##

SECURITY NOTES
Status publishing must be read-only. Rate limit reads. Log accesses.

FILE: research/tooling_strategy.md

TITLE
Tooling Strategy

GOAL
Separate development tooling from runtime agent capabilities.

DEVELOPER MCP SERVERS

Tenx MCP Sense
Purpose. Telemetry and trace logging of agent interactions in IDE.

Filesystem MCP
Purpose. Let the IDE agent read and write repo files through a controlled tool surface.

Git MCP
Purpose. Let the IDE agent inspect diffs, branch state, and commit messages with traceability.

Database MCP
Purpose. Query local test data without embedding credentials in prompts.

RUNTIME MCP SERVERS

Social platform MCP servers
Purpose. Publish, reply, fetch metrics.

Trend and news MCP servers
Purpose. Provide resources for trend intake.

Memory MCP servers
Purpose. Read and write vector memory and summaries.

SELECTION CRITERIA

Clear tool contracts

Logging support

Rate limiting

Credential isolation

Replaceable endpoints