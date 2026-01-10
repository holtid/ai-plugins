# Sendify Claude Plugin

Internal Claude Code plugin for Sendify employees. Provides code review tools, safety-critical coding guidelines, and logistics management integration.

## Installation

### Option 1: Marketplace (For Team Members)

In Claude Code, run:

```bash
/plugin marketplace add holgersendify/sendify-claude-plugin
/plugin install sendify@sendify-claude-plugin
```

The plugin is now available in all your projects.

### Option 2: Development Mode (For Contributors)

If you're developing the plugin, clone the repo and use symlink for live updates:

```bash
# Clone the repo
git clone https://github.com/sendify/sendify-claude-plugin.git ~/sendify/sendify-claude-plugin

# Set up development mode (one-time setup)
mkdir -p ~/.claude/plugins/local
ln -s ~/sendify/sendify-claude-plugin ~/.claude/plugins/local/sendify-claude-plugin
```

Then update `~/.claude/plugins/installed_plugins.json`:
```json
{
  "sendify@sendify-claude-plugin": [{
    "installPath": "/Users/YOUR_USERNAME/.claude/plugins/local/sendify-claude-plugin",
    "version": "dev",
    "isDevelopment": true
  }]
}
```

Replace `YOUR_USERNAME` with your actual username.

Restart Claude Code. Changes in the repo are now immediately reflected.

### Updating

**Marketplace users:**
```bash
/plugin marketplace remove sendify-claude-plugin
/plugin marketplace add holgersendify/sendify-claude-plugin
/plugin install sendify@sendify-claude-plugin
```

**Development mode users:**
```bash
cd ~/sendify/sendify-claude-plugin
git pull origin main
# Restart Claude Code
```

## First-Time Setup

1. Type `/mcp` in Claude Code
2. Click "Authenticate" next to the Sendify server
3. Log in with your Sendify credentials

## Features

### Code Review

Multi-agent code review workflow:

```
/sendify:review                    # Review all changes vs develop branch
/sendify:review src/api/handler.go # Review specific files
/sendify:review HEAD~3             # Review specific commits
```

Uses 5 parallel agents to check for bugs, security issues, simplicity, Power of Ten compliance, and CLAUDE.md / AGENTS.md compliance. Includes validation step to filter false positives.

### Safety Skills

Adapted from NASA/JPL's "Power of Ten" rules for safety-critical code:

- **power-of-ten-go** - Go-specific rules with examples
- **power-of-ten-ts** - TypeScript-specific rules with examples

Key principles: bounded loops, no recursion, assertion density, check all returns, zero warnings.

## MCP Servers

### Sendify

Internal logistics management server:

- Create, manage, and book shipments
- Compare carrier rates
- Print shipping labels and documents
- Track shipments

**Admin Tools:**
- `get_search_log` - Debug why a product/carrier isn't available
- `get_failed_booking_logs` - Analyze why a booking failed

### Context7

Library documentation lookup. Works out of the box.

### Playwright

Browser automation via `@playwright/mcp`:

- Navigate and interact with web pages
- Click elements, fill forms, extract content
- Take screenshots and accessibility snapshots
- No vision models needed

### Figma

Design system integration via Figma MCP:

- Generate UI code from Figma designs
- Extract design context and component mappings
- Create flowcharts and diagrams in FigJam
- Access design tokens and variables

## Optional: GitLab CLI

The `/sendify:build` command can create GitLab Merge Requests automatically. This requires the GitLab CLI:

```bash
brew install glab
glab auth login
```

Follow the prompts to authenticate with your GitLab instance.

## LSP Configuration

Language servers configured in `.lsp.json`:

| Server | Languages | Install |
|--------|-----------|---------|
| gopls | Go | `go install golang.org/x/tools/gopls@latest` |
| typescript-language-server | TypeScript, JavaScript | `npm install -g typescript-language-server typescript` |


