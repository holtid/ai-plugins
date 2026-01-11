# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About

Internal Claude Code plugin for Sendify employees. This plugin provides MCP servers and configurations for working with Sendify codebases.

## Tech Stack

- **Go** - Backend services
- **TypeScript (React)** - Frontend applications

## Structure

- `.claude-plugin/` - Claude Code plugin (commands, agents, skills, MCP/LSP configs)
- `.opencode/` - OpenCode configuration (mirrors Claude plugin functionality)
- `Makefile` - Installation commands for both platforms

## Commands

```bash
make install           # Install for Claude Code and OpenCode
make claude-install    # Claude Code only
make opencode-install  # OpenCode only
```

## MCP Servers

### Sendify

Internal logistics server at `https://app.sendify.se/mcp`. Authenticate via `/mcp` command.

**Capabilities:** Create/manage shipments, compare rates, print labels, track shipments.

**Admin tools:** `get_search_log`, `get_failed_booking_logs`

### Context7

Library documentation lookup via `@upstash/context7-mcp`.

### Playwright

Browser automation via `@playwright/mcp`.

### Figma

Design system integration via `https://mcp.figma.com/mcp`.

## Versioning

Pre-commit hook auto-bumps `.claude-plugin/plugin.json` version when files in `.claude-plugin/` change.
