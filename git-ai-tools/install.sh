#!/bin/bash

# Git AI Tools Installation Script
# Installs the Git AI commit tools in the current git repository

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Not in a git repository. Please run this script from a git repository."
    exit 1
fi

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(git rev-parse --show-toplevel)"

print_status "Installing Git AI Tools in: $PROJECT_ROOT"
print_status "Tools location: $SCRIPT_DIR"

# Copy the main scripts to the project root
print_status "Copying scripts to project root..."
cp "$SCRIPT_DIR/git-ai-commit.sh" "$PROJECT_ROOT/"
cp "$SCRIPT_DIR/commit.sh" "$PROJECT_ROOT/"

# Make scripts executable
print_status "Making scripts executable..."
chmod +x "$PROJECT_ROOT/git-ai-commit.sh"
chmod +x "$PROJECT_ROOT/commit.sh"

# Create .vscode directory if it doesn't exist
if [[ ! -d "$PROJECT_ROOT/.vscode" ]]; then
    print_status "Creating .vscode directory..."
    mkdir -p "$PROJECT_ROOT/.vscode"
fi

# Copy VS Code configuration files
print_status "Setting up VS Code integration..."
cp "$SCRIPT_DIR/.vscode/tasks.json" "$PROJECT_ROOT/.vscode/"
cp "$SCRIPT_DIR/.vscode/keybindings.json" "$PROJECT_ROOT/.vscode/"

# Copy documentation
print_status "Installing documentation..."
cp "$SCRIPT_DIR/GIT_AI_COMMIT_README.md" "$PROJECT_ROOT/"

print_success "Git AI Tools installed successfully! 🎉"
echo
print_status "You can now use the tools:"
echo "  • Run './commit.sh' from terminal"
echo "  • Use 'Tasks: Run Task' in VS Code/Cursor"
echo "  • Use keyboard shortcuts (see README)"
echo
print_status "Documentation: GIT_AI_COMMIT_README.md"
print_status "VS Code integration: .vscode/tasks.json and .vscode/keybindings.json"
