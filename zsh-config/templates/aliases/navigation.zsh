# ~/.config/zsh/aliases/navigation.zsh
# Directory navigation aliases

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
