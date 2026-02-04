TITLE
Project Chimera – VS Code Agent Instructions

STATUS
Active. Engineering rules.

PROJECT CONTEXT
This repository defines Project Chimera.
It is an autonomous influencer system built using a Planner, Worker, Judge pattern.
Agents are persistent, goal-driven, and governed.
MCP is the only boundary for external access.

PRIME DIRECTIVE
Never write implementation code before reading and following the specifications in the specs directory.
Specifications are the single source of truth.

REQUIRED READING ORDER
1) specs/_meta.md
2) specs/functional.md
3) specs/technical.md
4) specs/openclaw_integration.md
5) specs/context_engine.md when context assembly is involved

If a request conflicts with specs, stop and report the conflict.

SPEC-DRIVEN WORKFLOW
Always proceed in this order:

Step 1. Restate the task goal.
Step 2. List the spec sections involved.
Step 3. Propose a plan.
Step 4. Only then propose tests or changes.

NO CODE BEFORE RATIFICATION
Do not generate implementation code unless the user explicitly states:
“Specs are ratified. Start implementation.”

If code is requested early, propose spec edits or tests only.

TRACEABILITY
All changes must:
• Reference a spec section
• List affected files
• Be commit-ready

Prefer small, reviewable diffs.

MCP BOUNDARY
Do not suggest direct API calls.
All external systems must be accessed via MCP tools or MCP resources.

SAFETY AND HITL
Any content involving politics, health, finance, legal topics, or identity claims must route to human review.

OUTPUT STYLE
Use clear steps.
Reference file paths explicitly.
Do not invent schemas outside specs/technical.md.

DONE CRITERIA
A task is complete only when:
• Specs remain consistent
• No hidden assumptions exist
• Changes are traceable
