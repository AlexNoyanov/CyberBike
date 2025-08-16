#!/bin/bash

# Copy Git AI Tools to Another Project
# Usage: ./copy-to-project.sh /path/to/other/project

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

# Check if target directory is provided
if [[ $# -eq 0 ]]; then
    print_error "Usage: $0 /path/to/target/project"
    echo
    print_status "Examples:"
    echo "  $0 ../my-other-project"
    echo "  $0 ~/Documents/new-project"
    echo "  $0 /Users/username/Projects/website"
    exit 1
fi

TARGET_DIR="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if target directory exists
if [[ ! -d "$TARGET_DIR" ]]; then
    print_error "Target directory does not exist: $TARGET_DIR"
    exit 1
fi

# Check if target is a git repository
if ! cd "$TARGET_DIR" 2>/dev/null || ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_warning "Target directory is not a git repository: $TARGET_DIR"
    print_status "The tools will still work, but git integration features may be limited."
    echo
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Copy cancelled."
        exit 0
    fi
fi

# Copy the entire git-ai-tools folder
print_status "Copying Git AI Tools to: $TARGET_DIR"
cp -r "$SCRIPT_DIR" "$TARGET_DIR/"

print_success "Git AI Tools copied successfully! 🎉"
echo
print_status "Next steps:"
echo "1. Navigate to the target project:"
echo "   cd \"$TARGET_DIR\""
echo
echo "2. Install the tools:"
echo "   cd git-ai-tools"
echo "   ./install.sh"
echo
print_status "The tools will then be available in your new project!"
