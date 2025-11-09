# ~/.config/zsh/aliases/git.zsh
# Git aliases (extends Oh-My-Zsh git plugin)

# Note: The following are already provided by OMZ git plugin:
# - gcb='git checkout -b'
# - gcam='git commit -am'
# - gbd='git branch --delete'
# - gs (but we override with -sb flag below)

# Quick status with short format
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

# Interactive rebase last N commits
greb() {
  git rebase -i HEAD~$1
}

# Delete branch locally and remotely (enhanced version of OMZ gbd)
# This overrides the OMZ alias to also delete from remote
gbda() {
  git branch -d "$1"
  git push origin --delete "$1"
}
