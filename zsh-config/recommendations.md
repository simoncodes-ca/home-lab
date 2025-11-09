# Comprehensive Zsh Configuration Recommendations
## For TypeScript, Git, Python, Node.js, Angular, and React Development

---

## Executive Summary

Based on extensive research of current best practices in 2025, this guide provides battle-tested recommendations for setting up a highly productive zsh environment. Key recommendations:

- **Framework**: Use **Zinit** for performance-focused setup or **Oh-My-Zsh** for easier onboarding
- **Theme**: Use **Starship** (cross-shell, future-proof) or **Powerlevel10k** (maximum performance)
- **Essential Tools**: fzf, zoxide, zsh-autosuggestions, zsh-syntax-highlighting
- **Organization**: Modular `.zshrc` structure with topic-based files
- **Performance**: Lazy-load heavy tools (NVM, pyenv), cache eval statements, optimize completions

**Expected Performance**: With proper optimization, startup time should be under 100ms (vs 1-2 seconds unoptimized).

---

## 1. Framework Comparison & Selection

### Zinit (Recommended for Performance)

**Pros:**
- **80% faster startup** with Turbo mode (200ms → 40ms)
- Most granular control over plugin loading
- Asynchronous background loading
- Works with Oh-My-Zsh plugins
- Best for power users who need speed

**Cons:**
- Steeper learning curve
- More complex configuration
- Requires understanding of loading patterns

**Installation:**
```bash
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
```

### Oh-My-Zsh (Recommended for Beginners)

**Pros:**
- Easiest setup and configuration
- 300+ built-in plugins
- Massive community and documentation
- Excellent for learning zsh
- Simple plugin management

**Cons:**
- Slower startup (1+ second typical)
- Can be bloated with unused features
- Auto-updates can be intrusive

**Installation:**
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Prezto (Balanced Alternative)

**Pros:**
- Good balance of performance and features
- Cleaner, more modular than Oh-My-Zsh
- Sane defaults
- Won't auto-update without permission

**Cons:**
- Smaller plugin ecosystem
- Less documentation than Oh-My-Zsh

**Recommendation**: Start with **Oh-My-Zsh** for quick productivity gains, migrate to **Zinit** when you need performance optimization.

---

## 2. Essential Plugins for Your Tech Stack

### Core Plugins (All Frameworks)

#### 1. **zsh-autosuggestions**
Fish-like autosuggestions based on command history.

**Oh-My-Zsh Installation:**
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

**Zinit Installation:**
```bash
zinit light zsh-users/zsh-autosuggestions
```

**Configuration:**
```bash
# Accept suggestions with right arrow or Ctrl+Space
bindkey '^ ' autosuggest-accept  # Ctrl+Space to accept
```

#### 2. **zsh-syntax-highlighting**
Real-time syntax highlighting for commands.

**Oh-My-Zsh Installation:**
```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

**Zinit Installation:**
```bash
zinit light zsh-users/zsh-syntax-highlighting
```

**Note**: Must be loaded **last** in plugin list.

#### 3. **fzf-tab**
Replaces zsh's default completion selection menu with fzf.

**Installation:**
```bash
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
```

### Language & Tool-Specific Plugins

#### Git
**Built-in Plugin**: `git`

Provides 100+ aliases:
- `ga` → `git add`
- `gcmsg` → `git commit -m`
- `gco` → `git checkout`
- `gst` → `git status`
- `glog` → `git log --oneline --decorate --graph`
- `gapa` → `git add --patch`
- `gstp` → `git stash pop`

#### Node.js & npm
**Built-in Plugin**: `npm`

Features:
- npm command completions
- `npm-scripts` plugin for package.json script completion

**Enhanced npm completion:**
```bash
# Install zsh-better-npm-completion
git clone https://github.com/lukechilds/zsh-better-npm-completion.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-better-npm-completion
```

**Package.json script autocomplete:**
```bash
# Install zsh-npm-scripts-autocomplete
git clone https://github.com/grigorii-zander/zsh-npm-scripts-autocomplete ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-npm-scripts-autocomplete
```

#### Python
**Built-in Plugin**: `python`

Features:
- Python-related aliases
- Virtual environment detection

#### TypeScript
No dedicated plugin needed - works through npm/node plugins.

Consider adding:
```bash
# TypeScript aliases (add to custom aliases file)
alias tsc='npx tsc'
alias tsw='npx tsc --watch'
alias tslint='npx tslint'
```

#### Docker
**Built-in Plugin**: `docker` and `docker-compose`

Features:
- Docker command completion
- Docker Compose completion
- Common aliases

### Recommended Plugin List (Oh-My-Zsh)

```bash
# In ~/.zshrc
plugins=(
  git
  npm
  node
  python
  docker
  docker-compose
  zsh-autosuggestions
  zsh-syntax-highlighting
  fzf-tab
  zsh-better-npm-completion
  dotenv
  command-not-found
)
```

### Additional Useful Plugins

#### dotenv
Auto-loads `.env` files when entering project directories.

**Usage**: Automatically sources `.env` when you `cd` into a directory containing one.

#### command-not-found
Suggests package installation when command is not found (macOS/Linux).

#### web-search
Search web from command line:
```bash
google react hooks
stackoverflow typescript generics
github zsh plugins
```

---

## 3. Productivity Aliases and Functions

### Git Aliases (Beyond Oh-My-Zsh)

```bash
# ~/.config/zsh/aliases/git.zsh

# Quick status
alias gs='git status -sb'

# Interactive add
alias gai='git add -i'

# Undo last commit (keep changes)
alias gundo='git reset HEAD~1'

# Force push safely
alias gpf='git push --force-with-lease'

# Clean merged branches
alias gbclean='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'

# Pretty log
alias gl='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

# Show files changed in last commit
alias glast='git diff HEAD^..HEAD'

# Amend without changing message
alias gamend='git commit --amend --no-edit'

# Quick commit all changes
alias gcam='git commit -am'

# Interactive rebase last N commits
greb() {
  git rebase -i HEAD~$1
}

# Create and checkout new branch
gcb() {
  git checkout -b "$1"
}

# Delete branch locally and remotely
gbd() {
  git branch -d "$1"
  git push origin --delete "$1"
}
```

### npm/Node.js Aliases

```bash
# ~/.config/zsh/aliases/npm.zsh

# Package management
alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nu='npm uninstall'
alias nup='npm update'

# Scripts
alias nrs='npm run start'
alias nrd='npm run dev'
alias nrb='npm run build'
alias nrt='npm run test'
alias nrtw='npm run test:watch'
alias nrl='npm run lint'
alias nrf='npm run format'

# Clean node_modules
alias nrm='rm -rf node_modules'
alias nclean='rm -rf node_modules package-lock.json && npm install'

# List global packages
alias nlg='npm list -g --depth=0'

# Check outdated packages
alias nout='npm outdated'

# Audit fix
alias naudit='npm audit fix'

# Quick package.json script runner with fzf
nrun() {
  local script
  script=$(cat package.json | jq -r '.scripts | keys[]' | fzf --height 40% --reverse)
  if [[ -n $script ]]; then
    npm run $script
  fi
}

# Open package on npm website
npkg() {
  local package=${1:-$(cat package.json | jq -r .name)}
  open "https://www.npmjs.com/package/$package"
}
```

### Python Aliases

```bash
# ~/.config/zsh/aliases/python.zsh

# Python version shortcuts
alias py='python3'
alias pip='pip3'

# Virtual environment
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'
alias deactivate='deactivate'

# Quick venv creation and activation
mkvenv() {
  python3 -m venv "${1:-.venv}"
  source "${1:-.venv}/bin/activate"
  pip install --upgrade pip
}

# Freeze requirements
alias freeze='pip freeze > requirements.txt'

# Install from requirements
alias pipr='pip install -r requirements.txt'

# List installed packages
alias pipl='pip list'

# Run Python HTTP server
alias serve='python3 -m http.server'

# Run pytest with coverage
alias pyt='pytest --cov=. --cov-report=html'
```

### Directory Navigation Aliases

```bash
# ~/.config/zsh/aliases/navigation.zsh

# Quick directory jumps
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# List directories
alias l='ls -lFh'     # long list, human-readable
alias la='ls -lAFh'   # all files
alias ll='ls -l'      # long list
alias lt='ls -ltFh'   # sort by time
alias lS='ls -lSFh'   # sort by size

# Use exa if available (better ls)
if command -v exa &> /dev/null; then
  alias ls='exa --icons'
  alias l='exa -lFh --icons'
  alias la='exa -laFh --icons'
  alias ll='exa -l --icons'
  alias lt='exa -lFh --sort=modified --icons'
  alias tree='exa --tree --icons'
fi

# Create and enter directory
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Go back to project root (find git root)
cdroot() {
  cd "$(git rev-parse --show-toplevel 2>/dev/null || echo .)"
}
```

### TypeScript/Angular/React Specific

```bash
# ~/.config/zsh/aliases/frontend.zsh

# Angular CLI
alias ng='npx ng'
alias ngs='ng serve'
alias ngb='ng build'
alias ngt='ng test'
alias ngg='ng generate'

# React
alias cra='npx create-react-app'
alias cra-ts='npx create-react-app --template typescript'

# Next.js
alias next-dev='npm run dev'
alias next-build='npm run build'
alias next-start='npm run start'

# TypeScript
alias tsc='npx tsc'
alias tsw='npx tsc --watch'
alias tsi='npx tsc --init'

# Prettier
alias prettier='npx prettier'
alias pf='npx prettier --write .'

# ESLint
alias lint='npx eslint'
alias lintfix='npx eslint --fix'

# Check types + lint + format
alias check='npm run type-check && npm run lint && npm run format'

# Clean build artifacts
alias clean='rm -rf dist build .next out coverage'

# Bundle analyzer
alias analyze='npm run build -- --stats && npx webpack-bundle-analyzer dist/stats.json'

# Quick component generator (React)
mkcomp() {
  local name=$1
  local dir=${2:-src/components}
  mkdir -p "$dir/$name"
  cat > "$dir/$name/$name.tsx" <<EOF
import React from 'react';
import './$name.css';

interface ${name}Props {
  // Props interface
}

export const $name: React.FC<${name}Props> = (props) => {
  return (
    <div className="$name">
      <h2>$name Component</h2>
    </div>
  );
};
EOF
  cat > "$dir/$name/$name.css" <<EOF
.$name {
  /* Component styles */
}
EOF
  echo "Created component: $dir/$name"
}
```

### Utility Functions

```bash
# ~/.config/zsh/functions/utils.zsh

# Find and kill process by port
killport() {
  local port=$1
  local pid=$(lsof -ti:$port)
  if [[ -n $pid ]]; then
    kill -9 $pid
    echo "Killed process on port $port (PID: $pid)"
  else
    echo "No process found on port $port"
  fi
}

# Extract any archive
extract() {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Quick file search
find-file() {
  find . -type f -iname "*$1*"
}

# Quick directory search
find-dir() {
  find . -type d -iname "*$1*"
}

# Git clone and cd
gclone() {
  git clone "$1" && cd "$(basename "$1" .git)"
}

# Create backup of file
backup() {
  cp "$1"{,.backup-$(date +%Y%m%d-%H%M%S)}
}

# Show disk usage of current directory
duf() {
  du -sh * | sort -hr
}

# Get public IP
myip() {
  curl -s https://api.ipify.org
}

# Weather in terminal
weather() {
  curl -s "wttr.in/${1:-}"
}
```

---

## 4. Theme Recommendations

### Starship (Recommended - Future-Proof)

**Why Starship:**
- Cross-shell compatible (Bash, Fish, Zsh)
- Written in Rust (fast)
- Simple TOML configuration
- Active development
- Future-proof (Powerlevel10k is EOL)

**Installation:**
```bash
# macOS
brew install starship

# Add to ~/.zshrc
eval "$(starship init zsh)"
```

**Basic Configuration** (`~/.config/starship.toml`):
```toml
# Minimal startup prompt
format = """
[┌───────────────────>](bold green)
[│](bold green)$directory$git_branch$git_status
[└─>](bold green) """

# Directory
[directory]
truncation_length = 3
truncate_to_repo = true
style = "bold cyan"

# Git branch
[git_branch]
symbol = " "
style = "bold purple"

# Git status
[git_status]
style = "bold red"
conflicted = "🏳"
ahead = "⇡${count}"
behind = "⇣${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
untracked = "?${count}"
stashed = "$${count}"
modified = "!${count}"
staged = "+${count}"
renamed = "»${count}"
deleted = "✘${count}"

# Node.js version
[nodejs]
symbol = " "
style = "bold green"
format = "via [$symbol$version]($style) "

# Python version
[python]
symbol = " "
style = "bold yellow"
format = "via [$symbol$version]($style) "

# TypeScript
[typescript]
symbol = "ﯤ "
style = "bold blue"

# Command duration
[cmd_duration]
min_time = 500
format = "took [$duration](bold yellow)"
```

### Powerlevel10k (Maximum Performance)

**Why Powerlevel10k:**
- Fastest prompt available
- Excellent configuration wizard
- Zsh-specific optimizations
- Rich feature set

**Note**: Project is EOL but still works excellently.

**Installation:**
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Set in ~/.zshrc
ZSH_THEME="powerlevel10k/powerlevel10k"

# Run configuration wizard
p10k configure
```

### Pure (Minimalist Alternative)

**Why Pure:**
- Extremely minimal
- Shows Git status
- No configuration needed

**Installation:**
```bash
npm install --global pure-prompt

# Add to ~/.zshrc
autoload -U promptinit; promptinit
prompt pure
```

---

## 5. Auto-completion Configuration

### Basic Completion Setup

```bash
# ~/.zshrc - Completion configuration

# Enable completion system
autoload -Uz compinit

# Cache completions for 24 hours (performance optimization)
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Colored completion
zstyle ':completion:*' group-name '' # Group results by category
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'

# Enable menu selection with keyboard navigation
zmodload -i zsh/complist
bindkey -M menuselect '^M' .accept-line # Enter to accept
bindkey -M menuselect '^[[Z' reverse-menu-complete # Shift-Tab reverse

# Improve directory completion
zstyle ':completion:*' special-dirs true # Complete . and ..

# Process completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
```

### npm Completion

```bash
# Built-in npm completion
if command -v npm &> /dev/null; then
  eval "$(npm completion)"
fi
```

### Git Enhanced Completion

```bash
# Git completion is built into Oh-My-Zsh git plugin
# For manual setup:
# autoload -Uz compinit && compinit
# source ~/.zsh/git-completion.zsh
```

### Custom Completions

```bash
# ~/.config/zsh/completions/_custom

# Example: Custom completion for 'deploy' command
_deploy() {
  local -a environments
  environments=('dev' 'staging' 'production')
  _describe 'environment' environments
}

compdef _deploy deploy
```

---

## 6. Terminal Integration Tools

### fzf (Fuzzy Finder) - Essential

**Why fzf:**
- Fuzzy search for files, history, processes
- Integrates with Ctrl+R (history), Ctrl+T (files), Alt+C (directories)
- Essential productivity tool

**Installation:**
```bash
# macOS
brew install fzf
$(brew --prefix)/opt/fzf/install

# Or via git
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

**Configuration:**
```bash
# ~/.config/zsh/fzf.zsh

# Use fd instead of find for better performance
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Preview files with bat
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# Preview directories with tree
export FZF_ALT_C_OPTS="--preview 'tree -C {}'"

# Better colors
export FZF_DEFAULT_OPTS='
  --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
  --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
  --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
  --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

# Key bindings
# Ctrl+R - Search command history
# Ctrl+T - Search files in current directory
# Alt+C - cd into directory
```

**Usage Examples:**
```bash
# Search command history
# Press Ctrl+R

# Open file in editor with fzf
vim $(fzf)

# cd to directory with fzf
cd $(find . -type d | fzf)

# Kill process with fzf
kill -9 $(ps aux | fzf | awk '{print $2}')

# Git checkout branch with fzf
git checkout $(git branch -a | fzf)

# Search and open npm script
npm run $(cat package.json | jq -r '.scripts | keys[]' | fzf)
```

### zoxide (Smart cd) - Essential

**Why zoxide:**
- Learns your most visited directories
- Jump to directories with partial names
- Faster than cd for frequent directories
- 'frecency' based (frequency + recency)

**Installation:**
```bash
# macOS
brew install zoxide

# Add to ~/.zshrc
eval "$(zoxide init zsh)"
```

**Usage:**
```bash
# Jump to directory (traditional cd still works)
z home-lab          # Jumps to ~/git/home-lab
z vps               # Jumps to ~/git/home-lab/vps-config
z config zsh        # Jumps to ~/git/home-lab/vps-config/zsh-config

# Interactive selection with fzf
zi vps              # Shows fuzzy list of matching directories

# List all tracked directories
zoxide query -l

# Remove directory from zoxide
zoxide remove ~/some/path
```

**Aliases:**
```bash
# Add to aliases file
alias zz='z -'      # Go to previous directory
alias zh='zoxide query -l | fzf'  # Interactive history
```

### bat (Better cat) - Recommended

**Why bat:**
- Syntax highlighting
- Git integration
- Line numbers
- Paging support

**Installation:**
```bash
brew install bat

# Alias cat to bat
alias cat='bat'
```

### exa (Better ls) - Recommended

**Why exa:**
- Modern replacement for ls
- Icons, colors, git integration
- Tree view built-in

**Installation:**
```bash
brew install exa

# Aliases (add to aliases file)
alias ls='exa --icons'
alias ll='exa -lh --icons'
alias la='exa -lah --icons'
alias tree='exa --tree --icons'
```

### fd (Better find) - Recommended

**Why fd:**
- Faster than find
- Simpler syntax
- Respects .gitignore
- Colored output

**Installation:**
```bash
brew install fd

# Usage examples
fd pattern              # Find files matching pattern
fd -e js                # Find all .js files
fd -e ts -e tsx         # Find TypeScript files
fd -t d config          # Find directories named config
```

### ripgrep (Better grep) - Recommended

**Why ripgrep:**
- Extremely fast
- Respects .gitignore
- Recursive by default
- Regular expression support

**Installation:**
```bash
brew install ripgrep

# Usage examples
rg "function"           # Search for "function" in all files
rg "useState" -t ts     # Search in TypeScript files only
rg "TODO" -g "*.tsx"    # Search in .tsx files
rg "api" --hidden       # Include hidden files
```

### tldr (Simplified man pages) - Recommended

**Why tldr:**
- Community-driven simplified documentation
- Practical examples instead of verbose man pages
- Quick reference

**Installation:**
```bash
brew install tldr

# Usage
tldr git                # Show git examples
tldr npm                # Show npm examples
tldr docker             # Show docker examples
```

### Integrated Tool Configuration

```bash
# ~/.config/zsh/tools.zsh

# fzf + bat + git integration
# Preview git commits
fshow() {
  git log --graph --color=always \
    --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index \
    --preview 'echo {} | grep -o "[a-f0-9]\{7\}" | head -1 | xargs git show --color=always' \
    --bind "enter:execute:echo {} | grep -o '[a-f0-9]\{7\}' | head -1 | xargs git show | less -R"
}

# fzf + ripgrep - Search file contents
fif() {
  rg --line-number --no-heading --color=always --smart-case "$1" |
  fzf --ansi \
    --delimiter : \
    --preview 'bat --color=always --highlight-line {2} {1}' \
    --preview-window '+{2}-/2' \
    --bind 'enter:execute(vim {1} +{2})'
}

# fzf + zoxide - Interactive directory jump
fzd() {
  local dir
  dir=$(zoxide query -l | fzf --height 40% --reverse) && cd "$dir"
}
```

---

## 7. Performance Optimization Tips

### Measure Startup Time

```bash
# Add to top of ~/.zshrc to enable profiling
zmodload zsh/zprof

# Add to bottom of ~/.zshrc to see results
zprof

# Or time it manually
time zsh -i -c exit
```

**Target**: <100ms startup time

### 1. Lazy Load NVM (Critical)

NVM is the #1 cause of slow zsh startup (can add 1+ second).

**Solution 1: Oh-My-Zsh Plugin (Easiest)**
```bash
# In ~/.zshrc
plugins=(... nvm)

# Enable lazy loading
zstyle ':omz:plugins:nvm' lazy yes
```

**Solution 2: Manual Lazy Loading**
```bash
# ~/.config/zsh/lazy-load-nvm.zsh

# Don't load nvm immediately
export NVM_DIR="$HOME/.nvm"

# Lazy load function
lazy_load_nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}

# Create placeholder functions
nvm() {
  lazy_load_nvm
  nvm "$@"
}

node() {
  lazy_load_nvm
  node "$@"
}

npm() {
  lazy_load_nvm
  npm "$@"
}

npx() {
  lazy_load_nvm
  npx "$@"
}
```

**Alternative: Use fnm instead of nvm** (much faster)
```bash
brew install fnm

# Add to ~/.zshrc
eval "$(fnm env --use-on-cd)"
```

### 2. Lazy Load pyenv

```bash
# ~/.config/zsh/lazy-load-pyenv.zsh

# Don't initialize pyenv immediately
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Lazy load function
lazy_load_pyenv() {
  unset -f pyenv
  eval "$(pyenv init -)"
}

# Placeholder function
pyenv() {
  lazy_load_pyenv
  pyenv "$@"
}
```

### 3. Cache Eval Statements

```bash
# Install evalcache plugin (Oh-My-Zsh)
git clone https://github.com/mroth/evalcache ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/evalcache

# Enable in plugins list
plugins=(... evalcache)

# Replace eval with _evalcache
# Before: eval "$(starship init zsh)"
# After:
_evalcache starship init zsh
_evalcache zoxide init zsh
```

### 4. Optimize Completions

```bash
# ~/.zshrc - Only rebuild completion cache once per day

autoload -Uz compinit
setopt EXTENDEDGLOB
for dump in ${ZDOTDIR:-$HOME}/.zcompdump(N.mh+24); do
  compinit
done
compinit -C
unsetopt EXTENDEDGLOB
```

### 5. Defer Plugin Loading (Zinit)

```bash
# Use Zinit's turbo mode to load plugins asynchronously

zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

zinit ice wait lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

# Load heavy plugins after zsh initialization
zinit ice wait'1' lucid
zinit snippet OMZ::plugins/docker/docker.plugin.zsh
```

### 6. Disable Oh-My-Zsh Auto-Updates

```bash
# ~/.zshrc
zstyle ':omz:update' mode disabled

# Or check weekly instead of daily
zstyle ':omz:update' frequency 7
```

### 7. Minimal Plugin Selection

Only load plugins you actually use. Each plugin adds startup time.

**Before optimization:**
```bash
plugins=(git node npm python docker docker-compose kubectl helm terraform aws gcloud azure ...)
# Startup: 1.5s
```

**After optimization:**
```bash
plugins=(git npm docker zsh-autosuggestions zsh-syntax-highlighting)
# Startup: 200ms
```

### 8. Use Alternative Plugin Manager

If using 100+ plugins, consider migrating to Zinit for async loading.

### Performance Checklist

- [ ] Enable zprof and measure startup time
- [ ] Lazy load nvm/pyenv (or use faster alternatives)
- [ ] Cache eval statements with evalcache
- [ ] Optimize completion cache rebuilding
- [ ] Remove unused plugins
- [ ] Disable Oh-My-Zsh auto-updates
- [ ] Use async plugin loading (Zinit turbo mode)
- [ ] Profile again - target <100ms

**Expected Improvements:**
- Before: 1-2 seconds
- After: 50-100ms
- Improvement: 10-20x faster

---

## 8. Best Practices for Organizing .zshrc

### Modular Structure (Recommended)

**Directory Structure:**
```
~/.config/zsh/
├── .zshrc              # Main config (sources others)
├── zshenv              # Environment variables
├── aliases/
│   ├── git.zsh
│   ├── npm.zsh
│   ├── python.zsh
│   ├── docker.zsh
│   └── navigation.zsh
├── functions/
│   ├── utils.zsh
│   ├── git.zsh
│   └── dev.zsh
├── completions/
│   └── _custom
├── plugins.zsh         # Plugin configuration
├── theme.zsh           # Theme configuration
├── keybindings.zsh     # Custom keybindings
├── fzf.zsh            # fzf configuration
├── tools.zsh          # Tool integrations (zoxide, etc.)
└── lazy-load.zsh      # Lazy loading functions
```

### Main .zshrc Template

```bash
# ~/.zshrc - Main configuration file

# Enable Powerlevel10k instant prompt (if using p10k)
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# Performance profiling (uncomment to debug)
# zmodload zsh/zprof

# ZSH Configuration Directory
export ZSH_CONFIG="$HOME/.config/zsh"

# Oh-My-Zsh Configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"  # Or "powerlevel10k/powerlevel10k"

# Update settings
zstyle ':omz:update' mode disabled
# zstyle ':omz:update' frequency 7

# Plugins
plugins=(
  git
  npm
  python
  docker
  zsh-autosuggestions
  zsh-syntax-highlighting
  fzf-tab
)

# Load Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

# Source modular configuration
source "$ZSH_CONFIG/plugins.zsh"
source "$ZSH_CONFIG/theme.zsh"
source "$ZSH_CONFIG/keybindings.zsh"
source "$ZSH_CONFIG/lazy-load.zsh"
source "$ZSH_CONFIG/tools.zsh"

# Source aliases
for alias_file in $ZSH_CONFIG/aliases/*.zsh; do
  source "$alias_file"
done

# Source functions
for function_file in $ZSH_CONFIG/functions/*.zsh; do
  source "$function_file"
done

# fzf configuration
[ -f "$ZSH_CONFIG/fzf.zsh" ] && source "$ZSH_CONFIG/fzf.zsh"

# Local configuration (not in git)
[ -f "$ZSH_CONFIG/local.zsh" ] && source "$ZSH_CONFIG/local.zsh"

# Starship prompt (if using)
# eval "$(starship init zsh)"

# zoxide (smart cd)
eval "$(zoxide init zsh)"

# Performance profiling output (uncomment to debug)
# zprof
```

### Environment Variables (.zshenv)

```bash
# ~/.config/zsh/zshenv
# Loaded before .zshrc - for environment variables

# XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Editor
export EDITOR="vim"
export VISUAL="code"

# Language settings
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Path
export PATH="$HOME/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

# Node.js
export NODE_ENV="development"

# Python
export PYTHONDONTWRITEBYTECODE=1

# Homebrew (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
  export HOMEBREW_NO_ANALYTICS=1
fi

# fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
```

### Keybindings Configuration

```bash
# ~/.config/zsh/keybindings.zsh

# Use emacs-style keybindings
bindkey -e

# History search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

# Delete key
bindkey '^[[3~' delete-char

# Home/End
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# Word movement
bindkey '^[[1;5C' forward-word    # Ctrl+Right
bindkey '^[[1;5D' backward-word   # Ctrl+Left

# Accept autosuggestion
bindkey '^ ' autosuggest-accept   # Ctrl+Space
bindkey '^[[Z' autosuggest-accept # Shift+Tab

# Edit command in editor
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line
```

### Git-Friendly .gitignore

```bash
# ~/.config/zsh/.gitignore

# Local configuration (machine-specific)
local.zsh

# Completion cache
.zcompdump*

# History
.zsh_history

# Plugins (if managed by package manager)
plugins/

# Theme (if managed by package manager)
themes/
```

### Benefits of Modular Structure

1. **Maintainability**: Easy to find and edit specific configurations
2. **Organization**: Logical grouping of related settings
3. **Version Control**: Clean git diffs, easier to track changes
4. **Sharing**: Share specific modules without exposing everything
5. **Performance**: Only load what you need
6. **Testing**: Easy to disable modules for debugging

### Migration from Single .zshrc

```bash
# Create structure
mkdir -p ~/.config/zsh/{aliases,functions,completions}

# Move existing .zshrc
mv ~/.zshrc ~/.zshrc.backup

# Create new modular .zshrc
# (Use template above)

# Split aliases into topic files
# Extract git aliases → ~/.config/zsh/aliases/git.zsh
# Extract npm aliases → ~/.config/zsh/aliases/npm.zsh
# etc.

# Test new configuration
source ~/.zshrc

# Verify everything works
# If issues, check: echo $ZSH_CONFIG
```

---

## 9. Complete Installation Guide

### Quick Start (Oh-My-Zsh + Essential Tools)

```bash
# 1. Install Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 2. Install essential tools (macOS)
brew install fzf zoxide bat exa fd ripgrep tldr starship

# 3. Install zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
git clone https://github.com/lukechilds/zsh-better-npm-completion.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-better-npm-completion

# 4. Setup fzf
$(brew --prefix)/opt/fzf/install

# 5. Create modular config directory
mkdir -p ~/.config/zsh/{aliases,functions,completions}

# 6. Configure .zshrc
# (Use template from Section 8)

# 7. Add plugins to .zshrc
# plugins=(git npm python docker zsh-autosuggestions zsh-syntax-highlighting fzf-tab)

# 8. Add tool initialization
cat >> ~/.zshrc <<'EOF'

# Starship prompt
eval "$(starship init zsh)"

# zoxide
eval "$(zoxide init zsh)"
EOF

# 9. Reload zsh
source ~/.zshrc

# 10. Configure Starship
mkdir -p ~/.config
# Create starship.toml (use config from Section 4)
```

### Performance-Optimized Setup (Zinit)

```bash
# 1. Install Zinit
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# 2. Install tools
brew install fzf zoxide bat exa fd ripgrep tldr starship fnm

# 3. Configure .zshrc for Zinit
cat > ~/.zshrc <<'EOF'
# Zinit setup
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"

# Load Oh-My-Zsh libs
zinit snippet OMZL::git.zsh
zinit snippet OMZL::theme-and-appearance.zsh

# Plugins with turbo mode
zinit wait lucid light-mode for \
  OMZP::git \
  OMZP::npm \
  OMZP::docker

zinit ice wait lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

zinit ice wait lucid
zinit light Aloxaf/fzf-tab

# Completions
zinit wait lucid light-mode for \
  lukechilds/zsh-better-npm-completion

# Starship
zinit ice as"command" from"gh-r" \
  atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
  atpull"%atclone" src"init.zsh"
zinit light starship/starship

# zoxide
zinit ice wait lucid
zinit light ajeetdsouza/zoxide

# Tools
eval "$(fnm env --use-on-cd)"
eval "$(zoxide init zsh)"
EOF

# 4. Reload
source ~/.zshrc
```

---

## 10. Recommended Starter Configuration

### Complete .zshrc for TypeScript/React/Angular Developer

```bash
# ~/.zshrc
# Optimized Zsh configuration for TypeScript/React/Angular/Node.js development

# ============================================================================
# Oh-My-Zsh Configuration
# ============================================================================

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Update settings
zstyle ':omz:update' mode disabled

# Plugins
plugins=(
  git
  npm
  node
  python
  docker
  docker-compose
  dotenv
  zsh-autosuggestions
  zsh-syntax-highlighting
  fzf-tab
  zsh-better-npm-completion
)

source $ZSH/oh-my-zsh.sh

# ============================================================================
# Environment Variables
# ============================================================================

export EDITOR="vim"
export VISUAL="code"
export LANG="en_US.UTF-8"

# Node.js
export NODE_ENV="development"

# ============================================================================
# Path Configuration
# ============================================================================

export PATH="$HOME/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

# ============================================================================
# Tool Integrations
# ============================================================================

# Starship prompt
eval "$(starship init zsh)"

# zoxide (smart cd)
eval "$(zoxide init zsh)"

# fzf configuration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
export FZF_ALT_C_OPTS="--preview 'tree -C {}'"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ============================================================================
# Aliases
# ============================================================================

# Git
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias gco='git checkout'
alias gcb='git checkout -b'

# npm
alias ni='npm install'
alias nrs='npm run start'
alias nrd='npm run dev'
alias nrb='npm run build'
alias nrt='npm run test'
alias nrl='npm run lint'
alias nclean='rm -rf node_modules package-lock.json && npm install'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Modern replacements
alias ls='exa --icons'
alias ll='exa -lh --icons'
alias la='exa -lah --icons'
alias cat='bat'
alias tree='exa --tree --icons'

# Python
alias py='python3'
alias pip='pip3'

# ============================================================================
# Functions
# ============================================================================

# Create directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Kill process on port
killport() {
  local port=$1
  local pid=$(lsof -ti:$port)
  if [[ -n $pid ]]; then
    kill -9 $pid
    echo "Killed process on port $port"
  else
    echo "No process found on port $port"
  fi
}

# Git clone and cd
gclone() {
  git clone "$1" && cd "$(basename "$1" .git)"
}

# npm run with fzf
nrun() {
  local script
  script=$(cat package.json 2>/dev/null | jq -r '.scripts | keys[]' 2>/dev/null | fzf --height 40% --reverse)
  if [[ -n $script ]]; then
    npm run $script
  fi
}

# ============================================================================
# Keybindings
# ============================================================================

bindkey '^ ' autosuggest-accept  # Ctrl+Space to accept suggestion

# ============================================================================
# Completion Configuration
# ============================================================================

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Colored completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ============================================================================
# Local Configuration
# ============================================================================

# Source local config if it exists (not in version control)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
```

---

## 11. Next Steps & Learning Resources

### Immediate Next Steps

1. **Day 1: Foundation**
   - [ ] Install Oh-My-Zsh
   - [ ] Install fzf, zoxide, bat, exa
   - [ ] Configure basic .zshrc with essential plugins
   - [ ] Install Starship theme

2. **Day 2-3: Customize**
   - [ ] Add aliases for your most common commands
   - [ ] Set up fzf keybindings and learn Ctrl+R, Ctrl+T
   - [ ] Create custom functions for repetitive tasks
   - [ ] Configure Starship theme to your liking

3. **Week 1: Optimize**
   - [ ] Measure startup time with zprof
   - [ ] Lazy load nvm/pyenv
   - [ ] Remove unused plugins
   - [ ] Create modular config structure

4. **Week 2: Master**
   - [ ] Learn advanced fzf usage
   - [ ] Practice with zoxide for directory navigation
   - [ ] Create project-specific functions
   - [ ] Set up completion for custom scripts

### Learning Resources

**Official Documentation:**
- [Zsh Documentation](http://zsh.sourceforge.net/Doc/)
- [Oh-My-Zsh Wiki](https://github.com/ohmyzsh/ohmyzsh/wiki)
- [Starship Documentation](https://starship.rs/)
- [fzf Wiki](https://github.com/junegunn/fzf/wiki)

**Recommended Reading:**
- [Awesome Zsh Plugins](https://github.com/unixorn/awesome-zsh-plugins)
- [Modern Unix Tools](https://github.com/ibraheemdev/modern-unix)
- [Command Line Productivity](https://github.com/jaywcjlove/awesome-mac#command-line-tools)

**Video Tutorials:**
- Search "Oh-My-Zsh setup" on YouTube
- "fzf tutorial" for fuzzy finder usage
- "Starship prompt customization"

**Communities:**
- [r/zsh](https://reddit.com/r/zsh)
- [r/commandline](https://reddit.com/r/commandline)
- [Unix StackExchange](https://unix.stackexchange.com/)

### Dotfiles Inspiration

Study these popular dotfiles for ideas:
- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
- [paulirish/dotfiles](https://github.com/paulirish/dotfiles)
- [holman/dotfiles](https://github.com/holman/dotfiles)
- [jessfraz/dotfiles](https://github.com/jessfraz/dotfiles)

### Advanced Topics to Explore

1. **Zsh Scripting**
   - Write custom completion functions
   - Create advanced aliases with conditionals
   - Build project-specific automation

2. **Git Integration**
   - fzf-based git workflows
   - Custom git functions
   - Interactive staging and rebasing

3. **Project Management**
   - direnv for project-specific environments
   - Project-specific .zshrc files
   - Automated project setup scripts

4. **Multi-machine Sync**
   - Git-based dotfiles management
   - Mackup for application settings
   - Conditional configurations per machine

### Continuous Improvement

**Monthly Review:**
- Run `zprof` to check performance
- Review command history: `history | awk '{print $2}' | sort | uniq -c | sort -rn | head -20`
- Create aliases for top 10 commands
- Update plugins and tools

**Experiment:**
- Try one new tool per month
- Test different themes
- Share configurations with team
- Learn from others' dotfiles

---

## Troubleshooting

### Common Issues

**Slow startup time:**
```bash
# Profile your setup
zmodload zsh/zprof
# ... in ~/.zshrc
zprof  # at the end

# Focus on lazy loading nvm and pyenv first
```

**Plugin not working:**
```bash
# Check if plugin is loaded
echo $plugins

# Reload zsh
source ~/.zshrc

# Check Oh-My-Zsh installation
ls -la ~/.oh-my-zsh/custom/plugins/
```

**Completions not working:**
```bash
# Rebuild completion cache
rm ~/.zcompdump*
compinit
```

**fzf keybindings not working:**
```bash
# Ensure fzf is properly installed
$(brew --prefix)/opt/fzf/install
```

**zoxide not finding directories:**
```bash
# Check zoxide database
zoxide query -l

# It needs time to learn - use cd normally at first
```

---

## Appendix: Quick Reference

### Essential Commands

```bash
# History search
Ctrl+R              # Search backward
Ctrl+S              # Search forward

# fzf
Ctrl+T              # File search
Ctrl+R              # Command history (enhanced)
Alt+C               # Directory search

# zoxide
z <partial-name>    # Jump to directory
zi <partial-name>   # Interactive jump
z -                 # Jump to previous directory

# Git (Oh-My-Zsh)
gst                 # git status
ga                  # git add
gcmsg "msg"         # git commit -m
gp                  # git push
gl                  # git pull
gco branch          # git checkout
```

### Most Useful Aliases

```bash
# Quick reference of starter aliases
alias ..='cd ..'
alias ll='exa -lh --icons'
alias gs='git status -sb'
alias ni='npm install'
alias nrs='npm run start'
alias cat='bat'
alias find='fd'
alias grep='rg'
```

### Performance Targets

- **Startup time**: <100ms (optimal), <200ms (acceptable)
- **Plugin count**: 5-10 (essential), 10-20 (acceptable)
- **Completion delay**: <50ms (instant feel)

---

## Conclusion

This comprehensive guide provides everything you need to set up a highly productive zsh environment for TypeScript, React, Angular, Node.js, Python, and Git development.

**Key Takeaways:**

1. **Start Simple**: Oh-My-Zsh + Starship + fzf + zoxide
2. **Optimize Early**: Lazy load nvm/pyenv for fast startup
3. **Modular Config**: Organize .zshrc into topic-based files
4. **Learn Tools**: Master fzf, zoxide, and modern CLI replacements
5. **Measure Performance**: Keep startup time under 100ms
6. **Iterate**: Continuously improve based on your workflow

With these configurations, you'll have a terminal environment that:
- Starts in <100ms
- Provides intelligent autosuggestions
- Enables fuzzy search for everything
- Supports all your development tools
- Looks modern and professional
- Scales as your needs grow

Happy coding!

---

**Document Version**: 1.0
**Last Updated**: 2025-01-08
**Maintained by**: Home Lab Project
**File Location**: `/Users/simon/git/home-lab/vps-config/zsh-config/recommendations.md`
