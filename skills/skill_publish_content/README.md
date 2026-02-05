TITLE
Skill Publish Content

PURPOSE
Publish approved content through platform MCP tools.

INPUTS
agent_id
campaign_id
platform
text_content
media_refs
disclosure_level
trace_id

OUTPUTS
publish_record with platform post id and timestamp

OUTPUT SCHEMA
```json
{
  "agent_id": "string",
  "campaign_id": "uuid",
  "platform": "string",
  "post_id": "string",
  "published_at": "iso8601",
  "disclosure_level": "automated | assisted | none"
}
```

FAILURE MODES

Platform rate limit

Invalid media ref

Policy rejection from platform

MCP server unavailable