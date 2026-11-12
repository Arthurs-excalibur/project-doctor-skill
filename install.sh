#!/usr/bin/env bash
# Project Doctor Installer & Uninstaller for macOS & Linux
# Supports: Claude Code CLI, Cursor, Antigravity, and Agent Skills standard

set -e

REPO_RAW_URL="https://raw.githubusercontent.com/Arthurs-excalibur/project-doctor-skill/main"
SKILL_REL_PATH="skills/project-doctor/SKILL.md"
CURSOR_REL_PATH=".cursor/rules/project-doctor.mdc"
COMMANDS=(".claude/commands/doctor.md" ".claude/commands/doctor-fix.md" ".claude/commands/doctor-deploy.md")

INSTALL_GLOBAL=false
INSTALL_LOCAL=false
UNINSTALL=false

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --global|-g) INSTALL_GLOBAL=true ;;
        --project|-p) INSTALL_LOCAL=true ;;
        --uninstall|-u) UNINSTALL=true ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

if [ "$UNINSTALL" = true ]; then
    echo "Uninstalling Project Doctor..."
    rm -rf "$HOME/.claude/skills/project-doctor"
    rm -f "$HOME/.claude/commands/doctor.md" "$HOME/.claude/commands/doctor-fix.md" "$HOME/.claude/commands/doctor-deploy.md"
    rm -rf "$HOME/.gemini/antigravity/skills/project-doctor"
    if [ -d ".git" ]; then
        rm -rf ".claude/skills/project-doctor"
        rm -f ".claude/commands/doctor.md" ".claude/commands/doctor-fix.md" ".claude/commands/doctor-deploy.md"
        rm -rf ".gemini/skills/project-doctor"
        rm -f ".cursor/rules/project-doctor.mdc"
    fi
    echo "[OK] Project Doctor has been removed."
    exit 0
fi

if [ "$INSTALL_GLOBAL" = false ] && [ "$INSTALL_LOCAL" = false ]; then
    INSTALL_GLOBAL=true
    INSTALL_LOCAL=true
fi

echo "Installing Project Doctor..."

get_file() {
    local rel_path="$1"
    local dest="$2"
    mkdir -p "$(dirname "$dest")"
    if [ -f "$rel_path" ]; then
        cp "$rel_path" "$dest"
    else
        curl -fsSL "${REPO_RAW_URL}/${rel_path}" -o "$dest"
    fi
}

# 1. Claude Code CLI Global
if [ "$INSTALL_GLOBAL" = true ]; then
    CLAUDE_GLOBAL="$HOME/.claude/skills/project-doctor"
    get_file "$SKILL_REL_PATH" "$CLAUDE_GLOBAL/SKILL.md"
    echo "  [OK] Claude Code (Global): $CLAUDE_GLOBAL/SKILL.md"
    for cmd in "${COMMANDS[@]}"; do
        get_file "$cmd" "$HOME/$cmd"
        echo "  [OK] Claude Code (Global): ~/$cmd"
    done
fi

# 2. Antigravity Global
if [ "$INSTALL_GLOBAL" = true ]; then
    ANTIGRAVITY_GLOBAL="$HOME/.gemini/antigravity/skills/project-doctor"
    get_file "$SKILL_REL_PATH" "$ANTIGRAVITY_GLOBAL/SKILL.md"
    echo "  [OK] Antigravity (Global): $ANTIGRAVITY_GLOBAL/SKILL.md"
fi

# 3. Project-level install
if [ "$INSTALL_LOCAL" = true ] && [ -d ".git" ]; then
    get_file "$SKILL_REL_PATH" ".claude/skills/project-doctor/SKILL.md"
    echo "  [OK] Current Project (.claude/skills): .claude/skills/project-doctor/SKILL.md"
    for cmd in "${COMMANDS[@]}"; do
        get_file "$cmd" "$cmd"
        echo "  [OK] Current Project: $cmd"
    done
    get_file "$CURSOR_REL_PATH" ".cursor/rules/project-doctor.mdc"
    echo "  [OK] Current Project (.cursor/rules): .cursor/rules/project-doctor.mdc"
    get_file "$SKILL_REL_PATH" ".gemini/skills/project-doctor/SKILL.md"
    echo "  [OK] Current Project (.gemini/skills): .gemini/skills/project-doctor/SKILL.md"
fi

echo ""
echo "Installation complete. You can now use Project Doctor in your AI prompts."
echo "Claude Code users: type /doctor, /doctor-fix, or /doctor-deploy."
