.PHONY: help install uninstall claude-install claude-uninstall claude-update opencode-install opencode-uninstall opencode-update

MARKETPLACE = holtid/ai-plugins
MARKETPLACE_NAME = ai-plugins
PLUGIN = sendify@ai-plugins

help:
	@echo "Sendify Plugin Management"
	@echo "========================="
	@echo ""
	@echo "Claude Code:"
	@echo "  make claude-install    - Install plugin from marketplace"
	@echo "  make claude-uninstall  - Uninstall plugin"
	@echo "  make claude-update     - Update plugin to latest version"
	@echo ""
	@echo "OpenCode:"
	@echo "  make opencode-install  - Install to ~/.config/opencode/"
	@echo "  make opencode-uninstall- Remove from ~/.config/opencode/"
	@echo "  make opencode-update   - Update (re-run install)"
	@echo ""
	@echo "Both:"
	@echo "  make install           - Install both plugins"
	@echo "  make uninstall         - Uninstall both plugins"

# Claude Code targets
claude-install:
	@echo "Installing Claude Code plugin..."
	claude plugin marketplace add $(MARKETPLACE)
	claude plugin install $(PLUGIN)
	@echo ""
	@echo "Done! To authenticate with Sendify MCP, run /mcp in Claude Code."

claude-uninstall:
	@echo "Uninstalling Claude Code plugin..."
	claude plugin uninstall $(PLUGIN)
	claude plugin marketplace remove $(MARKETPLACE_NAME)
	@echo "Done."

claude-update:
	@echo "Updating Claude Code plugin..."
	claude plugin marketplace update $(MARKETPLACE_NAME)
	claude plugin update $(PLUGIN)
	@echo "Done. Restart Claude Code to apply updates."

# OpenCode targets
opencode-install:
	@echo "Installing OpenCode plugin..."
	@.opencode/install.sh

opencode-uninstall:
	@echo "Uninstalling OpenCode plugin..."
	@rm -f ~/.config/opencode/opencode.json.backup
	@rm -f ~/.config/opencode/opencode.json
	@rm -f ~/.config/opencode/agent/code-simplicity-reviewer.md
	@rm -f ~/.config/opencode/agent/power-of-ten-reviewer.md
	@rm -f ~/.config/opencode/command/blueprint.md
	@rm -f ~/.config/opencode/command/build.md
	@rm -f ~/.config/opencode/command/commit.md
	@rm -f ~/.config/opencode/command/review.md
	@rm -rf ~/.config/opencode/skill/power-of-ten-go
	@rm -rf ~/.config/opencode/skill/power-of-ten-ts
	@echo "Done. Sendify plugin removed from OpenCode."

opencode-update: opencode-install

# Combined targets
install: claude-install opencode-install

uninstall: claude-uninstall opencode-uninstall
