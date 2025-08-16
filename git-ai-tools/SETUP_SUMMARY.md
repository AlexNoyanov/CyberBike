# 🚀 Git AI Tools - Quick Setup Guide

## 📁 What You Have

The `git-ai-tools` folder contains everything needed for AI-powered git commits:

- **`git-ai-commit.sh`** - Main intelligent commit script
- **`commit.sh`** - Simple launcher for one-click execution
- **`install.sh`** - Automatic installation script
- **`copy-to-project.sh`** - Easy deployment to other projects
- **`.vscode/`** - VS Code/Cursor integration
- **Documentation** - Complete usage guide

## 🔄 Deploy to New Project

### Option 1: Copy & Install (Recommended)
```bash
# Copy the entire folder to your new project
cp -r git-ai-tools /path/to/new/project/

# Navigate to the new project
cd /path/to/new/project

# Install the tools
cd git-ai-tools
./install.sh
```

### Option 2: Use Copy Script
```bash
# From the git-ai-tools folder
./copy-to-project.sh /path/to/new/project

# Then follow the instructions shown
```

### Option 3: Manual Copy
```bash
# Copy these files to your project root:
cp git-ai-commit.sh /path/to/new/project/
cp commit.sh /path/to/new/project/
cp -r .vscode /path/to/new/project/
cp GIT_AI_COMMIT_README.md /path/to/new/project/

# Make executable
chmod +x /path/to/new/project/*.sh
```

## ✅ After Installation

Your new project will have:
- **Terminal access**: `./commit.sh`
- **VS Code/Cursor tasks**: Command palette → "Tasks: Run Task"
- **Keyboard shortcuts**: `Cmd+Shift+G` and others
- **Full documentation**: `GIT_AI_COMMIT_README.md`

## 🎯 Usage Examples

```bash
# Basic commit
./commit.sh

# Specific commit types
./commit.sh feat
./commit.sh fix
./commit.sh docs

# Preview without executing
./commit.sh --dry-run

# Show status
./commit.sh --status
```

## 🔧 Requirements

- Git repository
- Bash shell
- VS Code or Cursor (for full integration)

## 📚 Full Documentation

See `GIT_AI_COMMIT_README.md` for complete details and troubleshooting.

---

**That's it!** Copy the `git-ai-tools` folder to any project and run `./install.sh` to get started. 🎉
