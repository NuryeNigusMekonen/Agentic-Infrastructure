TITLE
Human Review Console Specification

VERSION
0.1

DATE
2026-02-06

OWNER
Nurye Nigus Mekonen

PURPOSE
Define minimal frontend requirements for the Human Review workflow. No UI code required.

PRIMARY USER
Human Reviewer

SCREENS

Queue screen
Shows list of pending review items.

Fields per row
campaign_id
task_id
artifact_id
platform
confidence_score
sensitivity_tags
created_at
status

Actions
Open item
Filter by status, platform, campaign
Sort by confidence_score ascending
Search by task_id

Review detail screen
Shows content preview and evidence.

Content blocks
Draft text preview
Media references list
Disclosure level
Judge reasons and policy hits
Source links summary
Audit trace_id

Actions
Approve
Reject
Edit and approve

Decision confirmation
Shows resulting next action and status transition.

STATE MODEL
Queue item status
pending -> in_review -> decided

Task status mapping
pending and in_progress are not visible
review is visible
done and failed are viewable in history

ERROR STATES
Content_ref missing
Show placeholder and block approve action.
Allow reject with reason.

Stale data
If artifact version changes while in_review, prompt reload.

NON FUNCTIONAL
Latency target for queue list under 2 seconds for 100 items.
Reviewer actions must be idempotent by queue_item_id.