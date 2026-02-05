def fetch_trends(payload: dict | None = None) -> dict:
    """Minimal stub for trend fetcher skill API.

    This is intentionally tiny to satisfy tests. Returns a predictable
    dict shape so callers can exercise the contract.
    """
    if payload is None:
        payload = {}

    # Minimal response shape used by integration tests.
    return {"ok": True, "data": [], "meta": {"received_payload": payload}}
