"""Skill: trend_fetcher package.

Provides a module-level `run(...)` entrypoint expected by integration tests.
"""

from . import api


def run(*args, **kwargs):
	"""Proxy entrypoint for tests that expect `run` at module level.

	Calls `api.fetch_trends` with the provided arguments.
	"""
	return api.fetch_trends(*args, **kwargs)


__all__ = ["api", "run"]

