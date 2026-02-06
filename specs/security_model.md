TITLE
Security Model

VERSION
0.2

DATE
2026-02-06

OWNER
Nurye Nigus Mekonen

PURPOSE
Define AuthN, AuthZ, rate limiting, secret management, and moderation pipeline. Provide concrete rules for agents to implement.

AUTHENTICATION
Internal services use JWT bearer tokens.
JWT claims
sub
roles
exp
aud

Human Reviewer auth
OAuth2 login flow.
Session yields JWT with role reviewer.

Service to service auth
Short lived JWT minted by orchestrator.
Rotate signing keys every 30 days.

AUTHORIZATION
Roles
operator
reviewer
developer
service

Endpoint access
Campaign endpoints operator, service
Human review endpoints reviewer, service
Metrics ingestion service only
OpenClaw status service only

RATE LIMITS
Global
100 requests per minute per token for read endpoints.
20 requests per minute per token for write endpoints.

Metrics ingestion
Up to 5 batch calls per second per service token.
Max events per batch 2000.

Moderation related actions
10 decisions per minute per reviewer to reduce accidental bulk actions.

SECRETS AND TOKEN MANAGEMENT
No secrets in repo.
No tokens in logs.
MCP tool credentials stored in OS keychain or secret manager.
CI uses GitHub Secrets.
Never print env vars in CI logs.
Redact with fixed patterns:
Authorization headers
Bearer tokens
API keys

CONTENT MODERATION PIPELINE
States
drafted
judge_review
human_review
approved
published
rejected
retrying

Routing
If sensitivity_tags not empty -> human_review
If confidence_score < 0.7 -> human_review
If policy_hits contains restricted -> rejected

Moderation evidence
Store policy_hits and reasons in ReviewDecision.
Store trace_id for full replay.

AUDIT REQUIREMENTS
Every request writes AuditLog.
Minimum fields
trace_id
actor_type
actor_id when available
entity_type and entity_id
action
severity