# Zsh Configuration Templates - Installation Guide

This directory contains template zsh configuration files that can be used to set up a productive development environment.

## Quick Installation

### Option 1: Copy All Files

```bash
# Create the config directory if it doesn't exist
mkdir -p ~/.config/zsh

# Copy all templates
cp -r ./zsh-config/templates/* ~/.config/zsh/

# Verify installation
ls -la ~/.config/zsh/
```

### Option 2: Selective Installation

Copy only the files you need:

```bash
# Create directories
mkdir -p ~/.config/zsh/{aliases,functions}

# Copy specific alias files
cp ./zsh-config/templates/aliases/git.zsh ~/.config/zsh/aliases/
cp ./zsh-config/templates/aliases/npm.zsh ~/.config/zsh/aliases/
# ... copy others as needed

# Copy utility functions
cp ./zsh-config/templates/functions/utils.zsh ~/.config/zsh/functions/
```

## Configuration Setup

After copying the files, add the following to your `~/.zshrc`:

```bash
# ============================================================================
# Load Modular Configuration
# ============================================================================

# ZSH Configuration Directory
export ZSH_CONFIG="$HOME/.config/zsh"

# Source all alias files
for alias_file in $ZSH_CONFIG/aliases/*.zsh; do
  source "$alias_file"
done

# Source all function files
for function_file in $ZSH_CONFIG/functions/*.zsh; do
  source "$function_file"
done
```

## Reload Shell

After installation, reload your shell:

```bash
source ~/.zshrc
```

## File Overview

### Aliases

- **git.zsh** - Git workflow enhancements (`gundo`, `gpf`, `gbclean`, `greb`, etc.)
- **npm.zsh** - npm/Node.js shortcuts (`nrs`, `nrd`, `nclean`, `nrun`, etc.)
- **python.zsh** - Python development aliases (`mkvenv`, `freeze`, `pipr`, etc.)
- **navigation.zsh** - Directory navigation (`mkcd`, `cdroot`, `..`, etc.)
- **frontend.zsh** - TypeScript/React/Angular tools (`tsc`, `lint`, `mkcomp`, etc.)

### Functions

- **utils.zsh** - Utility functions (`killport`, `extract`, `gclone`, `weather`, etc.)

## Requirements

Some functions require additional tools:

- **fzf** - For `nrun` interactive script selector
  ```bash
  brew install fzf  # macOS
  ```

- **jq** - For JSON parsing in `nrun` and `npkg`
  ```bash
  brew install jq  # macOS
  ```

- **exa** - Modern ls replacement (optional, navigation.zsh will use it if available)
  ```bash
  brew install exa  # macOS
  ```

## Customization

Feel free to modify these templates to suit your workflow:

1. Edit the copied files in `~/.config/zsh/`
2. Add new `.zsh` files to the `aliases/` or `functions/` directories
3. Changes take effect after `source ~/.zshrc`

## Compatibility

These configurations are designed to work with:

- **Zinit** - Fast plugin manager (as used in this setup)
- **Oh-My-Zsh** - Popular framework (some aliases extend OMZ plugins)
- **Plain Zsh** - Works standalone without frameworks

## Notes

- Git aliases extend Oh-My-Zsh git plugin (if present)
- Some aliases like `gcb`, `gcam` are already in OMZ and are documented but not duplicated
- All functions are namespaced to avoid conflicts

## Troubleshooting

**Aliases not working:**
```bash
# Verify files are sourced
echo $ZSH_CONFIG
ls -la $ZSH_CONFIG/aliases/

# Reload shell
source ~/.zshrc
```

**Function conflicts:**
```bash
# Check if function exists
type killport

# Check for alias conflicts
alias | grep killport
```

## Support

For detailed information about all available aliases and functions, see `README.md` in this directory.

For the comprehensive zsh setup guide, see `recommendations.md` in the parent directory.
