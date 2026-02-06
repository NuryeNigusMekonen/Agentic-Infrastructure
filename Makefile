.PHONY: env sync verify runbook-sync runbook-verify run train eval plot \
        mcp-env mcp-help mcp-servers mcp-sync

env:
	@bash scripts/session_log.sh artifacts/logs/env.txt true

runbook-sync:
	@mkdir -p docs
	@printf "\n- Date. %s\n- Change. Ran uv sync.\n- Why. Create or update virtual environment and dependencies.\n- Result. See sync log.\n- Evidence. artifacts/logs/sync.txt\n" "$$(date +%Y-%m-%d)" >> docs/05_runbook.md

runbook-verify:
	@mkdir -p docs
	@printf "\n- Date. %s\n- Change. Ran verification checks.\n- Why. Capture tool availability and CLI health.\n- Result. See verify logs.\n- Evidence. artifacts/logs/help.txt, artifacts/logs/providers.txt, artifacts/logs/presets.txt\n" "$$(date +%Y-%m-%d)" >> docs/05_runbook.md

sync:
	@bash scripts/session_log.sh artifacts/logs/sync.txt uv sync
	@$(MAKE) runbook-sync

verify:
	@bash scripts/session_log.sh artifacts/logs/help.txt sh -c "command -v ai-content >/dev/null 2>&1 && ai-content --help || echo 'ai-content missing. Verify skipped.'"
	@bash scripts/session_log.sh artifacts/logs/providers.txt sh -c "command -v ai-content >/dev/null 2>&1 && ai-content list-providers || echo 'ai-content missing. providers skipped.'"
	@bash scripts/session_log.sh artifacts/logs/presets.txt sh -c "command -v ai-content >/dev/null 2>&1 && ai-content list-presets || echo 'ai-content missing. presets skipped.'"
	@$(MAKE) runbook-verify

run:
	@bash scripts/session_log.sh artifacts/logs/run.txt uv run python main.py

train:
	@bash scripts/session_log.sh artifacts/logs/train.txt uv run python train.py

eval:
	@bash scripts/session_log.sh artifacts/logs/eval.txt uv run python eval.py

plot:
	@bash scripts/session_log.sh artifacts/logs/plot.txt uv run python plot.py

# ---------------- MCP SECTION ----------------

mcp-env:
	@bash scripts/session_log.sh artifacts/logs/mcp_env.txt sh -c "ls -la mcp.json 2>/dev/null || echo 'mcp.json missing at repo root'"

mcp-help:
	@bash scripts/session_log.sh artifacts/logs/mcp_help.txt sh -c "command -v mcp >/dev/null 2>&1 && mcp --help || echo 'mcp cli missing. Replace mcp with correct binary if needed.'"

mcp-servers:
	@bash scripts/session_log.sh artifacts/logs/mcp_servers.txt sh -c "command -v mcp >/dev/null 2>&1 && mcp servers || echo 'mcp cli missing or servers command unsupported.'"

mcp-sync:
	@bash scripts/session_log.sh artifacts/logs/mcp_sync.txt sh -c "command -v mcp >/dev/null 2>&1 && mcp sync || echo 'mcp cli missing or sync command unsupported.'"
# ---------------- GOVERNANCE ----------------

help:
	@echo ""
	@echo "Project Chimera - Available Commands"
	@echo ""
	@echo "Core:"
	@echo "  make env            Initialize environment"
	@echo "  make sync           Sync dependencies"
	@echo "  make verify         Verify tool availability"
	@echo ""
	@echo "Execution:"
	@echo "  make run            Run main entrypoint"
	@echo "  make train          Run training pipeline"
	@echo "  make eval           Run evaluation pipeline"
	@echo ""
	@echo "Governance:"
	@echo "  make spec-check     Validate required specs exist"
	@echo ""
	@echo "MCP:"
	@echo "  make mcp-env        Verify MCP config presence"
	@echo "  make mcp-servers    List MCP servers"
	@echo "  make mcp-sync       Sync MCP servers"
	@echo ""

spec-check:
	@echo "Validating spec-driven development requirements..."
	@test -d specs || (echo "ERROR: specs/ directory missing" && exit 1)
	@test -f specs/_meta.md || (echo "ERROR: specs/_meta.md missing" && exit 1)
	@test -f specs/functional.md || (echo "ERROR: specs/functional.md missing" && exit 1)
	@test -f specs/technical.md || (echo "ERROR: specs/technical.md missing" && exit 1)
	@test -f specs/db_schema.md || (echo "ERROR: specs/db_schema.md missing" && exit 1)
	@test -f specs/security_model.md || (echo "ERROR: specs/security_model.md missing" && exit 1)
	@echo "Spec validation passed."
