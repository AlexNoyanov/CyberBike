#!/bin/bash

# Simple launcher for Git AI Commit
# This script can be executed from Cursor AI IDE with one click

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Change to the script directory
cd "$SCRIPT_DIR"

# Execute the main git-ai-commit script
./git-ai-commit.sh

# Keep terminal open to see results
echo
echo "Press Enter to close..."
read
