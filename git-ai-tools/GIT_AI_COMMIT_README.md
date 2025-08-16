# Git AI Commit Script for Cursor AI IDE

This script automatically generates AI commit messages for staged git changes, commits them, and syncs with the remote repository. Perfect for one-click git workflow from Cursor AI IDE.

## 🚀 Features

- **AI Commit Messages**: Automatically generates meaningful commit messages based on changes
- **Smart Staging**: Automatically stages unstaged changes if none are staged
- **Auto Sync**: Pulls remote changes and pushes local commits
- **Commit Types**: Supports conventional commit types (feat, fix, docs, etc.)
- **Colored Output**: Beautiful terminal output with status indicators
- **Dry Run Mode**: Preview what will happen before executing
- **Error Handling**: Robust error handling with helpful messages

## 📁 Files

- `git-ai-commit.sh` - Main script with full functionality
- `commit.sh` - Simple launcher script for Cursor
- `GIT_AI_COMMIT_README.md` - This documentation

## 🛠️ Setup in Cursor AI IDE

### Method 1: Terminal Integration (Recommended)

1. **Open Terminal in Cursor**:
   - Press `Cmd+Shift+P` (Mac) or `Ctrl+Shift+P` (Windows/Linux)
   - Type "Terminal: Create New Terminal"
   - Press Enter

2. **Navigate to your project**:
   ```bash
   cd /path/to/your/project
   ```

3. **Run the script**:
   ```bash
   ./commit.sh
   ```

### Method 2: Cursor Tasks

1. **Create `.vscode/tasks.json`** in your project root:
   ```json
   {
     "version": "2.0.0",
     "tasks": [
       {
         "label": "Git AI Commit",
         "type": "shell",
         "command": "./commit.sh",
         "group": "build",
         "presentation": {
           "echo": true,
           "reveal": "always",
           "focus": false,
           "panel": "shared",
           "showReuseMessage": true,
           "clear": false
         },
         "problemMatcher": []
       }
     ]
   }
   ```

2. **Run the task**:
   - Press `Cmd+Shift+P` (Mac) or `Ctrl+Shift+P` (Windows/Linux)
   - Type "Tasks: Run Task"
   - Select "Git AI Commit"
   - Press Enter

### Method 3: Keyboard Shortcut

1. **Open Keyboard Shortcuts**:
   - Press `Cmd+K Cmd+S` (Mac) or `Ctrl+K Ctrl+S` (Windows/Linux)

2. **Add custom shortcut**:
   ```json
   {
     "key": "cmd+shift+g",
     "command": "workbench.action.terminal.sendSequence",
     "args": {
       "text": "./commit.sh\n"
     },
     "when": "terminalFocus"
   }
   ```

3. **Use the shortcut**: Press `Cmd+Shift+G` to run the script

## 🎯 Usage

### Basic Usage

```bash
# Auto-detect and commit all changes
./commit.sh

# Commit with specific type
./commit.sh feat
./commit.sh fix
./commit.sh docs

# Commit with custom message
./commit.sh feat "user authentication system"
./commit.sh fix "login button not working"
```

### Advanced Options

```bash
# Show help
./commit.sh --help

# Show git status
./commit.sh --status

# Dry run (preview without executing)
./commit.sh --dry-run

# Combine options
./commit.sh feat "new feature" --dry-run
```

## 🔧 Commit Types

| Type | Description | Example |
|------|-------------|---------|
| `feat` | New features | `feat: add user login system` |
| `fix` | Bug fixes | `fix: resolve login button issue` |
| `docs` | Documentation | `docs: update API documentation` |
| `style` | Code formatting | `style: improve code readability` |
| `refactor` | Code refactoring | `refactor: restructure user module` |
| `test` | Test changes | `test: add login unit tests` |
| `chore` | Maintenance | `chore: update dependencies` |
| `perf` | Performance | `perf: optimize database queries` |
| `ci` | CI/CD | `ci: update GitHub Actions` |
| `build` | Build system | `build: update webpack config` |

## 📊 What the Script Does

1. **Checks Git Repository**: Ensures you're in a git repository
2. **Stages Changes**: Automatically stages unstaged changes if needed
3. **Generates Message**: Creates AI-powered commit message based on:
   - Commit type (feat, fix, docs, etc.)
   - Files changed
   - Number of changes
   - File types modified
4. **Commits Changes**: Creates git commit with generated message
5. **Syncs Remote**: 
   - Pulls latest changes from remote
   - Pushes local commits to remote
6. **Shows Status**: Displays final git status

## 🎨 Output Example

```
[INFO] Starting Git AI Commit process...

[INFO] Found staged changes
[INFO] Generating AI commit message...
[SUCCESS] Generated commit message: feat: add new functionality (html, css, js files) (3 changes)

[INFO] Committing changes with message: feat: add new functionality (html, css, js files) (3 changes)
[SUCCESS] Changes committed successfully

[INFO] Syncing with remote repository...
[INFO] Pushing local changes to remote...
[SUCCESS] Successfully pushed to remote

[SUCCESS] Git AI Commit completed successfully! 🎉

[INFO] Repository: CyberBike
[INFO] Branch: main
[INFO] Remote: https://github.com/username/CyberBike.git

[INFO] Git Status:
M  ui.html

[INFO] Staged Changes:
 ui.html | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)
```

## ⚠️ Requirements

- **Git**: Must be installed and configured
- **Bash**: Script requires bash shell
- **Permissions**: Script must be executable (`chmod +x commit.sh`)
- **Remote**: Should have a remote repository configured (optional)

## 🔒 Safety Features

- **Dry Run Mode**: Preview changes before executing
- **Error Handling**: Exits on any git errors
- **Status Checking**: Shows what will happen before doing it
- **Backup**: Original git state is preserved

## 🚨 Troubleshooting

### Script not executable
```bash
chmod +x commit.sh
chmod +x git-ai-commit.sh
```

### Permission denied
```bash
# Check if you're in the right directory
pwd
ls -la commit.sh

# Make executable again if needed
chmod +x commit.sh
```

### Git not found
```bash
# Check git installation
git --version

# Install git if needed (Mac)
brew install git

# Install git if needed (Ubuntu/Debian)
sudo apt-get install git
```

### No remote configured
```bash
# Add remote origin
git remote add origin https://github.com/username/repository.git

# Or skip remote sync by using --dry-run first
./commit.sh --dry-run
```

## 🎉 Success!

Once set up, you can commit and sync your git changes with just one click in Cursor AI IDE! The script will handle everything automatically and provide clear feedback on what's happening.

## 📝 License

This script is provided as-is for educational and productivity purposes. Feel free to modify and distribute as needed.
