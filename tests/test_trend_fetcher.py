import uuid
from datetime import datetime, timezone
ALLOWED_TASK_TYPES = {
    "trend_fetch",
    "draft_post",
    "generate_media",
    "publish_post",
    "collect_metrics",
}

ALLOWED_PRIORITIES = {"high", "medium", "low"}
ALLOWED_STATUSES = {"pending", "in_progress", "review", "done", "failed"}

ALLOWED_ARTIFACT_TYPES = {"text", "image", "video", "plan", "metrics_batch"}
ALLOWED_DISCLOSURE = {"automated", "assisted", "none"}

ALLOWED_JUDGE_DECISIONS = {"approve", "reject", "escalate"}
ALLOWED_NEXT_ACTIONS = {"publish", "retry", "human_review"}

ALLOWED_METRIC_TYPES = {"views", "likes", "comments", "shares", "watch_time_seconds"}


def _iso_now() -> str:
    return datetime.now(timezone.utc).isoformat()


def test_task_payload_contract_shape_matches_spec():
    payload = {
        "task_id": str(uuid.uuid4()),
        "task_type": "trend_fetch",
        "priority": "high",
        "campaign_id": str(uuid.uuid4()),
        "agent_id": "agent_alpha",
        "context": {
            "goal": "string",
            "persona_constraints": ["string"],
            "required_resources": ["mcp://resource/path"],
            "acceptance_criteria": ["string"],
        },
        "created_at": _iso_now(),
        "status": "pending",
    }

    required_top = {
        "task_id",
        "task_type",
        "priority",
        "campaign_id",
        "agent_id",
        "context",
        "created_at",
        "status",
    }
    assert required_top.issubset(payload.keys())

    assert payload["task_type"] in ALLOWED_TASK_TYPES
    assert payload["priority"] in ALLOWED_PRIORITIES
    assert payload["status"] in ALLOWED_STATUSES

    context = payload["context"]
    required_ctx = {"goal", "persona_constraints", "required_resources", "acceptance_criteria"}
    assert required_ctx.issubset(context.keys())
    assert isinstance(context["persona_constraints"], list)
    assert isinstance(context["required_resources"], list)
    assert isinstance(context["acceptance_criteria"], list)


def test_worker_result_contract_shape_matches_spec():
    payload = {
        "task_id": str(uuid.uuid4()),
        "agent_id": "agent_alpha",
        "artifact": {
            "artifact_id": str(uuid.uuid4()),
            "artifact_type": "text",
            "version": 1,
            "content_ref": "mcp://artifact/ref",
            "metadata": {
                "sources": ["mcp://source/a"],
                "platform": "tiktok",
                "disclosure_level": "assisted",
            },
        },
        "confidence_score": 0.72,
        "notes": "string",
        "created_at": _iso_now(),
    }

    required_top = {"task_id", "agent_id", "artifact", "confidence_score", "notes", "created_at"}
    assert required_top.issubset(payload.keys())

    artifact = payload["artifact"]
    required_art = {"artifact_id", "artifact_type", "version", "content_ref", "metadata"}
    assert required_art.issubset(artifact.keys())
    assert artifact["artifact_type"] in ALLOWED_ARTIFACT_TYPES

    md = artifact["metadata"]
    required_md = {"sources", "platform", "disclosure_level"}
    assert required_md.issubset(md.keys())
    assert md["disclosure_level"] in ALLOWED_DISCLOSURE


def test_judge_decision_contract_shape_matches_spec():
    payload = {
        "task_id": str(uuid.uuid4()),
        "decision": "approve",
        "reasons": ["string"],
        "policy_hits": ["string"],
        "confidence_score": 0.86,
        "next_action": "publish",
        "created_at": _iso_now(),
    }

    required_top = {
        "task_id",
        "decision",
        "reasons",
        "policy_hits",
        "confidence_score",
        "next_action",
        "created_at",
    }
    assert required_top.issubset(payload.keys())

    assert payload["decision"] in ALLOWED_JUDGE_DECISIONS
    assert payload["next_action"] in ALLOWED_NEXT_ACTIONS
    assert isinstance(payload["reasons"], list)
    assert isinstance(payload["policy_hits"], list)


def test_metric_event_schema_shape_matches_spec():
    payload = {
        "event_id": str(uuid.uuid4()),
        "campaign_id": str(uuid.uuid4()),
        "agent_id": "agent_alpha",
        "content_id": str(uuid.uuid4()),
        "platform": "tiktok",
        "metric_type": "views",
        "metric_value": 10,
        "observed_at": _iso_now(),
        "ingested_at": _iso_now(),
        "source": "mcp_resource",
    }

    required_top = {
        "event_id",
        "campaign_id",
        "agent_id",
        "content_id",
        "platform",
        "metric_type",
        "metric_value",
        "observed_at",
        "ingested_at",
        "source",
    }
    assert required_top.issubset(payload.keys())
    assert payload["metric_type"] in ALLOWED_METRIC_TYPES
    assert isinstance(payload["metric_value"], int)
