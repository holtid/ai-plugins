#!/bin/bash

# OpenCode Plugin Installer for Sendify
# Installs configuration to ~/.config/opencode/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.config/opencode"

echo "OpenCode Plugin Installer"
echo "========================="
echo ""
echo "Source: $SCRIPT_DIR"
echo "Target: $TARGET_DIR"
echo ""

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Function to copy with backup
copy_with_backup() {
    local src="$1"
    local dest="$2"

    if [ -e "$dest" ]; then
        echo "  Backing up existing: $dest -> $dest.backup"
        mv "$dest" "$dest.backup"
    fi

    cp -r "$src" "$dest"
    echo "  Installed: $dest"
}

# Install opencode.json
if [ -f "$SCRIPT_DIR/opencode.json" ]; then
    if [ -f "$TARGET_DIR/opencode.json" ]; then
        echo ""
        echo "WARNING: $TARGET_DIR/opencode.json already exists."
        echo "Do you want to:"
        echo "  1) Replace it (backup will be created)"
        echo "  2) Merge MCP servers only (manual merge)"
        echo "  3) Skip"
        read -p "Choice [1/2/3]: " choice

        case $choice in
            1)
                copy_with_backup "$SCRIPT_DIR/opencode.json" "$TARGET_DIR/opencode.json"
                ;;
            2)
                echo ""
                echo "To merge manually, add this to your existing opencode.json 'mcp' section:"
                echo ""
                cat "$SCRIPT_DIR/opencode.json" | grep -A 20 '"mcp"'
                echo ""
                ;;
            3)
                echo "  Skipped: opencode.json"
                ;;
        esac
    else
        cp "$SCRIPT_DIR/opencode.json" "$TARGET_DIR/opencode.json"
        echo "  Installed: $TARGET_DIR/opencode.json"
    fi
fi

# Install agent directory
echo ""
echo "Installing agents..."
mkdir -p "$TARGET_DIR/agent"
for file in "$SCRIPT_DIR/agent/"*.md; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        cp "$file" "$TARGET_DIR/agent/$filename"
        echo "  Installed: agent/$filename"
    fi
done

# Install command directory
echo ""
echo "Installing commands..."
mkdir -p "$TARGET_DIR/command"
for file in "$SCRIPT_DIR/command/"*.md; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        cp "$file" "$TARGET_DIR/command/$filename"
        echo "  Installed: command/$filename"
    fi
done

# Install skill directory
echo ""
echo "Installing skills..."
mkdir -p "$TARGET_DIR/skill"
for skill_dir in "$SCRIPT_DIR/skill/"*/; do
    if [ -d "$skill_dir" ]; then
        skill_name=$(basename "$skill_dir")
        mkdir -p "$TARGET_DIR/skill/$skill_name"
        cp "$skill_dir/SKILL.md" "$TARGET_DIR/skill/$skill_name/SKILL.md"
        echo "  Installed: skill/$skill_name/SKILL.md"
    fi
done

echo ""
echo "========================="
echo "Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Authenticate with Sendify MCP:"
echo "     opencode mcp auth sendify"
echo ""
echo "  2. Create AGENTS.md in your project root with project-specific instructions"
echo ""
echo "  3. Start OpenCode in any project:"
echo "     cd ~/your-project"
echo "     opencode"
echo ""
echo "Available commands:"
echo "  /blueprint - Create implementation plans"
echo "  /build     - Execute blueprints"
echo "  /review    - Multi-agent code review"
echo ""
