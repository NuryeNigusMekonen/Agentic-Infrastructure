TITLE
Skills Directory

DEFINITION
A skill is a reusable runtime capability invoked by Workers. Skills are not MCP servers. Skills call MCP tools and read MCP resources.

RULES

Each skill has a clear input and output contract

Each skill has defined failure modes

Each skill logs its actions with a trace id

Skills do not store secrets in code or logs

SKILLS IN THIS REPO

skill_trend_fetcher

skill_video_metadata_ingestor

skill_publish_content