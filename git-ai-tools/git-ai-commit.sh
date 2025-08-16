#!/bin/bash

# Git AI Commit Script
# Automatically generates commit messages, commits changes, and syncs with remote
# Usage: ./git-ai-commit.sh [commit_type] [custom_message]

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_NAME=$(basename "$(git rev-parse --show-toplevel 2>/dev/null || echo 'unknown')")
DEFAULT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || echo 'unknown')

# Function to print colored output
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

# Function to check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a git repository. Please run this script from a git repository."
        exit 1
    fi
}

# Function to check if there are staged changes
check_staged_changes() {
    if ! git diff --cached --quiet; then
        print_status "Found staged changes"
        return 0
    else
        print_warning "No staged changes found. Staging all changes..."
        git add .
        if ! git diff --cached --quiet; then
            print_success "All changes staged"
            return 0
        else
            print_error "No changes to commit"
            exit 1
        fi
    fi
}

# Function to generate AI commit message using git diff
generate_ai_commit_message() {
    local commit_type="${1:-feat}"
    local custom_message="${2:-}"
    
    print_status "Generating AI commit message..."
    
    # Get staged changes summary
    local staged_summary=$(git diff --cached --stat)
    local file_changes=$(git diff --cached --name-status | wc -l)
    
    # Get file types changed
    local file_types=$(git diff --cached --name-only | grep -E '\.[a-zA-Z0-9]+$' | sed 's/.*\.//' | sort | uniq -c | sort -nr | head -3 | awk '{print $2}' | tr '\n' ', ' | sed 's/,$//')
    
    # Generate commit message based on type and changes
    local commit_message=""
    
    case $commit_type in
        "feat"|"feature")
            commit_message="feat: add new functionality"
            ;;
        "fix"|"bugfix")
            commit_message="fix: resolve issue"
            ;;
        "docs"|"documentation")
            commit_message="docs: update documentation"
            ;;
        "style"|"formatting")
            commit_message="style: improve code formatting"
            ;;
        "refactor")
            commit_message="refactor: restructure code"
            ;;
        "test")
            commit_message="test: add or update tests"
            ;;
        "chore")
            commit_message="chore: maintenance tasks"
            ;;
        "perf")
            commit_message="perf: performance improvements"
            ;;
        "ci")
            commit_message="ci: update CI/CD configuration"
            ;;
        "build")
            commit_message="build: update build system"
            ;;
        *)
            commit_message="feat: update code"
            ;;
    esac
    
    # Add custom message if provided
    if [[ -n "$custom_message" ]]; then
        commit_message="$commit_message: $custom_message"
    fi
    
    # Add context about what changed
    if [[ -n "$file_types" ]]; then
        commit_message="$commit_message ($file_types files)"
    fi
    
    # Add change count
    commit_message="$commit_message ($file_changes changes)"
    
    echo "$commit_message"
}

# Function to commit changes
commit_changes() {
    local commit_message="$1"
    
    print_status "Committing changes with message: $commit_message"
    
    if git commit -m "$commit_message"; then
        print_success "Changes committed successfully"
        return 0
    else
        print_error "Failed to commit changes"
        return 1
    fi
}

# Function to sync with remote
sync_with_remote() {
    print_status "Syncing with remote repository..."
    
    # Get current branch
    local current_branch=$(git symbolic-ref --short HEAD)
    
    # Check if remote exists
    if ! git remote get-url origin >/dev/null 2>&1; then
        print_warning "No remote 'origin' found. Skipping sync."
        return 0
    fi
    
    # Check if we're behind remote
    git fetch origin
    
    local behind_count=$(git rev-list --count HEAD..origin/$current_branch 2>/dev/null || echo "0")
    local ahead_count=$(git rev-list --count origin/$current_branch..HEAD 2>/dev/null || echo "0")
    
    if [[ "$behind_count" -gt 0 ]]; then
        print_warning "Local branch is $behind_count commits behind remote. Pulling changes..."
        if git pull origin "$current_branch"; then
            print_success "Successfully pulled remote changes"
        else
            print_error "Failed to pull remote changes"
            return 1
        fi
    fi
    
    if [[ "$ahead_count" -gt 0 ]]; then
        print_status "Pushing local changes to remote..."
        if git push origin "$current_branch"; then
            print_success "Successfully pushed to remote"
        else
            print_error "Failed to push to remote"
            return 1
        fi
    else
        print_status "No local commits to push"
    fi
}

# Function to show git status
show_status() {
    print_status "Repository: $REPO_NAME"
    print_status "Branch: $DEFAULT_BRANCH"
    print_status "Remote: $(git remote get-url origin 2>/dev/null || echo 'none')"
    
    echo
    print_status "Git Status:"
    git status --short
    
    echo
    print_status "Staged Changes:"
    git diff --cached --stat
}

# Function to show help
show_help() {
    echo "Git AI Commit Script"
    echo "==================="
    echo
    echo "Usage: $0 [commit_type] [custom_message]"
    echo
    echo "Commit Types:"
    echo "  feat/feature    - New features"
    echo "  fix/bugfix      - Bug fixes"
    echo "  docs            - Documentation changes"
    echo "  style           - Code formatting"
    echo "  refactor        - Code refactoring"
    echo "  test            - Test changes"
    echo "  chore           - Maintenance tasks"
    echo "  perf            - Performance improvements"
    echo "  ci              - CI/CD changes"
    echo "  build           - Build system changes"
    echo
    echo "Examples:"
    echo "  $0                    # Auto-detect and commit"
    echo "  $0 feat              # Feature commit"
    echo "  $0 fix               # Bug fix commit"
    echo "  $0 feat \"user login\" # Feature with custom message"
    echo
    echo "Options:"
    echo "  -h, --help          Show this help message"
    echo "  -s, --status        Show git status"
    echo "  -d, --dry-run       Show what would be done without executing"
}

# Function to perform dry run
dry_run() {
    print_status "DRY RUN - No changes will be made"
    echo
    
    check_git_repo
    check_staged_changes
    
    local commit_message=$(generate_ai_commit_message "$1" "$2")
    echo
    print_status "Would commit with message: $commit_message"
    echo
    print_status "Would sync with remote repository"
    
    print_success "Dry run completed successfully"
}

# Main execution
main() {
    local commit_type=""
    local custom_message=""
    local dry_run_flag=false
    local status_flag=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -s|--status)
                status_flag=true
                shift
                ;;
            -d|--dry-run)
                dry_run_flag=true
                shift
                ;;
            -*)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
            *)
                if [[ -z "$commit_type" ]]; then
                    commit_type="$1"
                elif [[ -z "$custom_message" ]]; then
                    custom_message="$1"
                else
                    print_error "Too many arguments"
                    show_help
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # Show status if requested
    if [[ "$status_flag" == true ]]; then
        check_git_repo
        show_status
        exit 0
    fi
    
    # Perform dry run if requested
    if [[ "$dry_run_flag" == true ]]; then
        dry_run "$commit_type" "$custom_message"
        exit 0
    fi
    
    # Main execution
    print_status "Starting Git AI Commit process..."
    echo
    
    check_git_repo
    check_staged_changes
    
    local commit_message=$(generate_ai_commit_message "$commit_type" "$custom_message")
    echo
    print_success "Generated commit message: $commit_message"
    echo
    
    if commit_changes "$commit_message"; then
        if sync_with_remote; then
            echo
            print_success "Git AI Commit completed successfully! 🎉"
            echo
            show_status
        else
            print_warning "Changes committed but sync failed"
            exit 1
        fi
    else
        print_error "Git AI Commit failed"
        exit 1
    fi
}

# Run main function with all arguments
main "$@"
