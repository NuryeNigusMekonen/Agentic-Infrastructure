"""Skill: publish_content package.

Provides a module-level `run(...)` entrypoint for test compatibility.
"""

from . import api


def run(*args, **kwargs):
	"""Proxy entrypoint that calls `api.publish_content`.
	"""
	return api.publish_content(*args, **kwargs)


__all__ = ["api", "run"]

