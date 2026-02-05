TITLE
Skill Trend Fetcher

PURPOSE
Fetch trend signals and produce ranked trend items for the Planner.

INPUTS
agent_id
campaign_id
resource_refs, list of MCP resources
relevance_threshold, float

OUTPUTS
ranked_trends, list of items with relevance score and source refs

OUTPUT SCHEMA
```json
{
  "agent_id": "string",
  "campaign_id": "uuid",
  "ranked_trends": [
    {
      "trend_id": "string",
      "title": "string",
      "summary": "string",
      "source_ref": "mcp://...",
      "relevance_score": 0.0,
      "observed_at": "iso8601"
    }
  ]
}
```

FAILURE MODES

MCP resource timeout

Empty feed

Invalid resource ref

Scoring model failure