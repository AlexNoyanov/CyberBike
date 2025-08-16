# Git AI Tools

A collection of scripts and configurations for automated git commits with AI-generated messages, designed for Cursor AI IDE and VS Code.

## 📁 Contents

- **`git-ai-commit.sh`** - Main intelligent commit script
- **`commit.sh`** - Simple launcher script
- **`install.sh`** - Installation script for new projects
- **`.vscode/`** - VS Code/Cursor integration files
- **`GIT_AI_COMMIT_README.md`** - Detailed documentation

## 🚀 Quick Setup in New Project

### Method 1: Copy and Install (Recommended)

1. **Copy the entire `git-ai-tools` folder** to your new project
2. **Run the installation script**:
   ```bash
   cd git-ai-tools
   ./install.sh
   ```
3. **Done!** Tools are now available in your project

### Method 2: Manual Copy

1. **Copy these files** to your project root:
   - `git-ai-commit.sh`
   - `commit.sh`
   - `GIT_AI_COMMIT_README.md`
2. **Copy `.vscode` folder** to your project root
3. **Make scripts executable**:
   ```bash
   chmod +x git-ai-commit.sh commit.sh
   ```

## 🎯 Usage

After installation, you can use the tools in any of these ways:

- **Terminal**: `./commit.sh`
- **VS Code/Cursor**: `Cmd+Shift+P` → "Tasks: Run Task" → "Git AI Commit"
- **Keyboard shortcuts**: `Cmd+Shift+G` (and others)

## 📋 Requirements

- Git repository
- Bash shell
- VS Code or Cursor (for full integration)

## 🔄 Updating Tools

To update the tools in an existing project:

1. **Copy the new `git-ai-tools` folder** to your project
2. **Run `./install.sh` again** - it will overwrite existing files
3. **Your customizations will be preserved** (if you modified the scripts)

## 📝 Customization

Feel free to modify the scripts and configurations to match your workflow:

- **Edit `git-ai-commit.sh`** for custom commit logic
- **Modify `.vscode/tasks.json`** for different task configurations
- **Update `.vscode/keybindings.json`** for custom keyboard shortcuts

## 🆘 Support

See `GIT_AI_COMMIT_README.md` for detailed documentation and troubleshooting.
