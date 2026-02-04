#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="${1:-artifacts/logs/session.txt}"

{
  echo ""
  echo "=============================="
  date "+%Y-%m-%d %H:%M:%S"
  echo "pwd: $(pwd)"
  echo "user: $(whoami)"
  echo "system: $(uname -a)"
  echo "python: $(python --version 2>&1 || true)"
  echo "uv: $(uv --version 2>&1 || true)"
} | tee -a "$LOG_FILE"

shift || true

if [ "$#" -gt 0 ]; then
  {
    echo "command: $*"
    echo "------------------------------"
  } | tee -a "$LOG_FILE"
  "$@" 2>&1 | tee -a "$LOG_FILE"
fi
