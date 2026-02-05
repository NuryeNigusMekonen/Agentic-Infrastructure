"""Skill: video_metadata_ingestor package.

Provides a module-level `run(...)` entrypoint for test compatibility.
"""

from . import api


def run(*args, **kwargs):
	"""Proxy entrypoint that calls `api.ingest_metrics`.
	"""
	return api.ingest_metrics(*args, **kwargs)


__all__ = ["api", "run"]

