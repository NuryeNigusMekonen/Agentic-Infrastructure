TITLE
Project Chimera Specification Meta

VERSION
0.1

DATE
February 5, 2026

OWNER
Nurye

SCOPE
Project Chimera is an autonomous influencer network. It runs a fleet of persistent influencer agents. Each agent plans, creates, reviews, and publishes content. The system supports human review for risky content. The system tracks performance and costs.

PRIMARY OUTCOMES

Create and publish on-brand content at scale

Maintain safety via review gates

Maintain traceability via logs and audit records

Support high-velocity metadata ingestion for social and video performance

Support tool-based external actions via MCP only

IN SCOPE

Orchestrator control plane for goals, campaigns, and monitoring

Agent runtime based on Planner, Worker, Judge roles

Human review queue and decision logging

Data plane for task state, content artifacts, and performance metadata

MCP boundary for all external integrations

OUT OF SCOPE FOR THIS PHASE

Full media generation quality tuning

Full multi-platform publishing coverage

Token cost optimization

Production deployment on Kubernetes

On-chain commerce execution

CONSTRAINTS

Spec-Driven Development. No implementation before specs are ratified

MCP boundary. No direct API calls from agent logic

Traceability. Log key decisions, inputs, outputs, and review actions

Safety. Sensitive topics route to human review

Multi-tenancy ready design, even if single-tenant first

SUCCESS CRITERIA

A campaign goal produces a task plan and content drafts

Judge gates are applied before publish actions

Human reviewers can approve or reject within a clear workflow

Video and social metadata is ingested at high write rates without blocking agents

All external actions are visible via MCP tool calls and logs

RISK REGISTER

Prompt injection from external content and links

Platform policy changes and API churn

Cost runaway from repeated retries

Safety drift from weak persona constraints

Data growth from high-frequency metrics

GLOSSARY
Orchestrator. Central control plane for goals, budgets, and monitoring
Planner. Decomposes goals into tasks
Worker. Executes a single atomic task
Judge. Validates and gates outputs
HITL. Human in the loop review
MCP. Standard interface for tools and resources