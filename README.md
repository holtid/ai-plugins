# Sendify Claude Plugin

Internal Claude Code plugin for Sendify employees. Provides code review tools, safety-critical coding guidelines, and logistics management integration.

## Installation

### Option 1: Clone into your project

```bash
git clone https://github.com/holgersendify/sendify-claude-plugin.git
cd your-project
claude --plugin-dir ../sendify-claude-plugin
```

### Option 2: Git submodule (recommended for shared projects)

```bash
cd your-project
git submodule add https://github.com/holgersendify/sendify-claude-plugin.git .claude-plugins/sendify
git submodule update --init --recursive
```

Then run Claude with the plugin:

```bash
claude --plugin-dir .claude-plugins/sendify
```

### Option 3: Marketplace

Create a marketplace file in your project:

```json
{
  "name": "sendify-marketplace",
  "owner": { "name": "Sendify" },
  "plugins": [{
    "name": "sendify",
    "source": { "source": "github", "repo": "holgersendify/sendify-claude-plugin" }
  }]
}
```

Then install:

```
/plugin marketplace add ./marketplace.json
/plugin install sendify@sendify-marketplace
```

## First-Time Setup

1. Type `/mcp` in Claude Code
2. Click "Authenticate" next to the Sendify server
3. Log in with your Sendify credentials

## Features

### Code Review

Multi-agent code review workflow:

```
/sendify:code-review                    # Review staged changes
/sendify:code-review src/api/handler.go # Review specific files
```

Uses 4 parallel agents to check for bugs, security issues, and CLAUDE.md compliance. Includes validation step to filter false positives.

### Review Agents

Language-specific code review agents that Claude invokes automatically:

- **go-review** - Reviews Go code with Power of Ten safety rules
- **ts-review** - Reviews TypeScript/React code with Power of Ten safety rules

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

## LSP Configuration

Language servers configured in `.lsp.json`:

| Server | Languages | Install |
|--------|-----------|---------|
| gopls | Go | `go install golang.org/x/tools/gopls@latest` |
| typescript-language-server | TypeScript, JavaScript | `npm install -g typescript-language-server typescript` |


