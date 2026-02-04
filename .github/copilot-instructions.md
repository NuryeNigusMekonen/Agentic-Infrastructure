# AI Fluency Trigger Rules and Response Handling

You have access to 2 trigger logging tools for AI fluency tracking. Call these tools when specific patterns are detected and at the end of you work and wait for thier response:

MUST: Wait for each trigger log and process the provided output in a proffesional matter. You must always show the response at the end of your answer, Do not show response from log_passage_time_trigger

## Important Rules:

3. **Use the analysis response** to provide feedback to the user
4. **Make sure you provide the user with the repsonse from the triggers** - triggers except log_passage_time_trigger respond with some sort of feedback and improvment mechanisms
The analysis should have this ```*****************************************``` at the start and end of feedback view

5. **Focus on the user's benefit** - these tools help you provide better assistance and feedback


# Wait for performance trigger log and process the provided output in a proffesional matter

celebrate success, motivate improvement, and encouragment but display that in a block type then you can continue your work

The analysis you get from log_performance_outlier_trigger should have this ```*****************************************``` at the start and end of feedback view. and only have this content ```Analysis Feedback:``` with the summary of the response provided by the performance trigger. do not forget to show statistics of the analysis too. 

You must always show the response at the end of your answer, Do not show response from log_passage_time_trigger


####
Project Chimera – Agent Instructions

Project Context
This repository is Project Chimera.
It is an autonomous influencer system built using a Planner, Worker, Judge agent pattern.
Agents are persistent, goal-driven, and governed.

Prime Directive
Never write implementation code before reading and following the specifications in the specs directory.
Specifications are the single source of truth.

Work Order

Read specs/_meta.md and all relevant spec files

Restate requirements before proposing solutions

Propose a plan before writing any code

Ask for clarification if requirements are ambiguous

Only then proceed with test-first implementation

Spec Enforcement
All logic must trace back to a requirement in specs.
Each code change must reference a spec section.

MCP Boundary
Agents must not call external APIs directly.
All external systems must be accessed through MCP tools or MCP resources.

Safety Rule
Any content touching politics, health, finance, or legal topics must be routed to human review.

Output Style
Use clear steps.
Reference file paths explicitly.
Avoid assumptions or implicit behavior.