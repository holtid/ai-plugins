# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About

Internal Claude Code plugin for Sendify employees. This plugin provides MCP servers and configurations for working with Sendify codebases.

## Tech Stack

- **Go** - Backend services
- **TypeScript (React)** - Frontend applications

## MCP Servers

### Sendify

Internal logistics management server at `https://app.sendify.se/mcp`. Requires authentication via `/mcp` command.

**Capabilities:**
- Create, manage, and book shipments
- Compare carrier rates
- Print shipping labels and documents
- Track shipments

**Admin debugging tools:**
- `get_search_log` - Debug why a product or carrier isn't available for a specific search
- `get_failed_booking_logs` - Analyze why a booking failed

### Context7

Library documentation lookup via `@upstash/context7-mcp`. Works out of the box.

## LSP Configuration

Language servers are configured in `.lsp.json`:
- **gopls** - Go language server (install: `go install golang.org/x/tools/gopls@latest`)
- **typescript-language-server** - TypeScript/JavaScript (install: `npm install -g typescript-language-server typescript`)
