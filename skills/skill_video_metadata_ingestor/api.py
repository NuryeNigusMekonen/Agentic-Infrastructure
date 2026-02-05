def ingest_metrics(payload: dict | None = None) -> dict:
    """Minimal stub for video metadata ingestor skill API.

    Returns a simple acknowledgement dict so tests can import and call it.
    """
    if payload is None:
        payload = {}

    return {"ok": True, "ingested": 0, "meta": {"received_payload": payload}}
