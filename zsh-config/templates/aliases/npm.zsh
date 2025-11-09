# ~/.config/zsh/aliases/npm.zsh
# npm/Node.js aliases

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
