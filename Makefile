.PHONY: sync verify env runbook-sync runbook-verify run train eval plot

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

# Optional project commands (edit file names as your project grows)
run:
	@bash scripts/session_log.sh artifacts/logs/run.txt uv run python main.py

train:
	@bash scripts/session_log.sh artifacts/logs/train.txt uv run python train.py

eval:
	@bash scripts/session_log.sh artifacts/logs/eval.txt uv run python eval.py

plot:
	@bash scripts/session_log.sh artifacts/logs/plot.txt uv run python plot.py
